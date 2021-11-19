#include "bsp.h"
#include "i2c.h"
#include "i2cDemo.h" //From BSP
#include <stdint.h>
#include "io.h"
#include "machineTimer.h"
#include "riscv.h"
#include "plic.h"
#include "timerAndGpioInterruptDemo.h"
#include "gpio.h"
#include "uart.h"

#include "common.h"
#include "PiCamDriver.h"
#include "apb3_cam.h"
#include "hdmi_config.h"
#include "hdmi_driver.h"
#include "dmasg.h"
#include "dmasg_config.h"
#include "axi4_hw_accel.h"
#include "isp.h"

#define FRAME_WIDTH     64
#define FRAME_HEIGHT    48

//Simple DDR model in simulation supports up to 23-bit address bits only (**Insufficient for 640x480 resolution simulation)
//Start address to be divided evenly by 8. Otherwise DMA tkeep might be shifted, not handled in display and hw_accel blocks.
#define CAM_START_ADDR        0x00100000
#define GRAYSCALE_START_ADDR  0x00300000
#define SOBEL_START_ADDR      0x00500000

#define cam_array       ((volatile uint32_t*)CAM_START_ADDR)
#define grayscale_array ((volatile uint32_t*)GRAYSCALE_START_ADDR)
#define sobel_array     ((volatile uint32_t*)SOBEL_START_ADDR)


void main() {

   /*************************************************************SETUP DMA*************************************************************/
   
   dma_init();
   
   dmasg_priority(DMASG_BASE, DMASG_HW_ACCEL_MM2S_CHANNEL, 0);
   dmasg_priority(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL, 0);
   dmasg_priority(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL,  0);
   dmasg_priority(DMASG_BASE, DMASG_CAM_S2MM_CHANNEL,      0);

   /*******************************************************Display (Self Restart)******************************************************/
   
/*  
   //SELECT start address of to be displayed data accordingly
   //dmasg_input_memory(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, CAM_START_ADDR, 16);
   //dmasg_input_memory(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, GRAYSCALE_START_ADDR, 16);
   dmasg_input_memory(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, SOBEL_START_ADDR, 16);
   
   dmasg_output_stream(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, DMASG_DISPLAY_MM2S_PORT, 0, 0, 1);
   dmasg_direct_start(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, (FRAME_WIDTH*FRAME_HEIGHT)*4, 1);
*/
   
   /**********************************************************Camera Capture***********************************************************/

   //SELECT RGB or grayscale output from camera pre-processing block.
   //EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG3_OFFSET, 0x00000000); //RGB
   EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG3_OFFSET, 0x00000001);   //grayscale
   
   //Trigger camera DMA
   dmasg_input_stream(DMASG_BASE, DMASG_CAM_S2MM_CHANNEL, DMASG_CAM_S2MM_PORT, 1, 0);
   dmasg_output_memory(DMASG_BASE, DMASG_CAM_S2MM_CHANNEL, CAM_START_ADDR, 16);
   dmasg_direct_start(DMASG_BASE, DMASG_CAM_S2MM_CHANNEL, (FRAME_WIDTH*FRAME_HEIGHT)*4, 0);
   
   //Indicate start of S2MM DMA to camera building block via APB3 slave
   EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG4_OFFSET, 0x00000001);
   EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG4_OFFSET, 0x00000000);
   
   //Trigger storage of one captured frame via APB3 slave
   EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG2_OFFSET, 0x00000001);
   EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG2_OFFSET, 0x00000000);
   
   //Wait for DMA transfer completion
   while(dmasg_busy(DMASG_BASE, DMASG_CAM_S2MM_CHANNEL));
   flush_data_cache();

   /*********************************************************RISC-V Processing**********************************************************/
   
/*
   rgb2grayscale (cam_array, grayscale_array, FRAME_WIDTH, FRAME_HEIGHT);
*/ 
   
   /**********************************************************HW Accelerator***********************************************************/
   
   //SET Sobel edge detection threshold via AXI4 slave
   write_u32(100, EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG0_OFFSET); //Default value 100; Range 0 to 255
      
   //SELECT HW accelerator mode - Make sure match with DMA transfer length setting
   write_u32(0x00000000, EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG1_OFFSET);   //2'd0: Sobel only - Default
   //write_u32(0x00000001, EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG1_OFFSET); //2'd1: Sobel+Dilation
   //write_u32(0x00000002, EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG1_OFFSET); //2'd2: Sobel+Erosion
   
   //Trigger HW accel MM2S DMA
   //SELECT start address of DMA input to HW accel block
   //dmasg_input_memory(DMASG_BASE, DMASG_HW_ACCEL_MM2S_CHANNEL, GRAYSCALE_START_ADDR, 16); //RISC-V performs SW RGB2grayscale conversion
   dmasg_input_memory(DMASG_BASE, DMASG_HW_ACCEL_MM2S_CHANNEL, CAM_START_ADDR, 16);         //Camera pre-processing block performs HW RGB2grayscale conversion
   dmasg_output_stream(DMASG_BASE, DMASG_HW_ACCEL_MM2S_CHANNEL, DMASG_HW_ACCEL_MM2S_PORT, 0, 0, 1);
   
   //SELECT dma transfer length - Make sure match with HW accelerator mode selection
   //Additonal data is required to be fed for line buffer(s) data flushing
   dmasg_direct_start(DMASG_BASE, DMASG_HW_ACCEL_MM2S_CHANNEL, ((FRAME_WIDTH*FRAME_HEIGHT)+(FRAME_WIDTH+1))*4, 0);      //Sobel only
   //dmasg_direct_start(DMASG_BASE, DMASG_HW_ACCEL_MM2S_CHANNEL, (((FRAME_WIDTH*FRAME_HEIGHT)+(2*FRAME_WIDTH+2))*4, 0); //Sobel + Dilation/Erosion
   
   //Trigger HW accel S2MM DMA
   dmasg_input_stream(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL, DMASG_HW_ACCEL_S2MM_PORT, 1, 0);
   dmasg_output_memory(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL, SOBEL_START_ADDR, 16);
   dmasg_direct_start(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL, (FRAME_WIDTH*FRAME_HEIGHT)*4, 0);
   
   //Indicate start of S2MM DMA to HW accel building block via APB3 slave
   write_u32(0x00000001, EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG2_OFFSET);
   write_u32(0x00000000, EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG2_OFFSET);
   
   //Wait for DMA transfer completion
   while(dmasg_busy(DMASG_BASE, DMASG_HW_ACCEL_MM2S_CHANNEL) || dmasg_busy(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL));
   flush_data_cache();
   
   /**********************************************************Display***********************************************************/

   //SELECT start address of to be displayed data accordingly
   //dmasg_input_memory(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, CAM_START_ADDR, 16);
   //dmasg_input_memory(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, GRAYSCALE_START_ADDR, 16);
   dmasg_input_memory(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, SOBEL_START_ADDR, 16);
   dmasg_output_stream(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, DMASG_DISPLAY_MM2S_PORT, 0, 0, 1);
   dmasg_direct_start(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, (FRAME_WIDTH*FRAME_HEIGHT)*4, 0);
   
   //Wait for DMA transfer completion
   while(dmasg_busy(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL));
   flush_data_cache();

   /*************************************************Completed One Iteration***************************************************/
   
	while(1) {
	}

   errorRoutine: while(1);
}


