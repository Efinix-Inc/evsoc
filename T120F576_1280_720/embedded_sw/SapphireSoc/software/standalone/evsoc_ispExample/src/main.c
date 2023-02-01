#include "bsp.h"
#include "i2c.h"
#include "i2cDemo.h"
#include <stdint.h>
#include "io.h"
#include "riscv.h"
#include "plic.h"
#include "gpio.h"
#include "uart.h"

#include "clint.h"
#include "common.h"
#include "PiCamDriver.h"
#include "apb3_cam.h"
#include "hdmi_config.h"
#include "hdmi_driver.h"
#include "dmasg.h"
#include "dmasg_config.h"
#include "axi4_hw_accel.h"
#include "isp.h"

#define FRAME_WIDTH    1280
#define FRAME_HEIGHT    720

//Start address to be divided evenly by 8. Otherwise DMA tkeep might be shifted, not handled in display and hw_accel blocks.
#define CAM_START_ADDR        0x01000000
#define GRAYSCALE_START_ADDR  0x02000000
#define SOBEL_START_ADDR      0x03000000

#define cam_array       ((volatile uint32_t*)CAM_START_ADDR)
#define grayscale_array ((volatile uint32_t*)GRAYSCALE_START_ADDR)
#define sobel_array     ((volatile uint32_t*)SOBEL_START_ADDR)


void main() {

   /**************************************************SETUP PICAM & HDMI DISPLAY***************************************************/
   
   Set_MipiRst(1);
   Set_MipiRst(0);

   uart_writeStr(BSP_UART_TERMINAL, "\n\rHello Efinix Edge Vision SoC!!\n\n\r");

   uart_writeStr(BSP_UART_TERMINAL, "Init HDMI I2C.....");
   hdmi_i2c_init();
   hdmi_init();
   uart_writeStr(BSP_UART_TERMINAL, "Done !!\n\r");

   uart_writeStr(BSP_UART_TERMINAL, "Init MIPI I2C.....");
   mipi_i2c_init();
   PiCam_init();
   uart_writeStr(BSP_UART_TERMINAL, "Done !!\n\n\r");

   Set_RGBGain(1,5,3,4); //SET camera pre-processing RGB gain value
   
   /**********************************************************SETUP DMA***********************************************************/
   
   uart_writeStr(BSP_UART_TERMINAL, "Init DMA.....");
   
   dma_init();
   
   dmasg_priority(DMASG_BASE, DMASG_HW_ACCEL_MM2S_CHANNEL, 0, 0);
   dmasg_priority(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL, 0, 0);
   dmasg_priority(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL,  0, 0);
   dmasg_priority(DMASG_BASE, DMASG_CAM_S2MM_CHANNEL,      0, 0);
   
   uart_writeStr(BSP_UART_TERMINAL, "Done !!\n\n\r");
  
   /*******************************************************Trigger Display********************************************************/
   
   u32 rdata;
 
   //To check display functionality
   uart_writeStr(BSP_UART_TERMINAL, "Initialize test display content..\n\r");

   //Array name to be modified to DDR location used for display
   //Colour bar & Red dots at 4 corners of active display

   //Initialize test image in cam_array
   for (int y=0; y<FRAME_HEIGHT; y++) {
      for (int x=0; x<FRAME_WIDTH; x++) {
         if ((x<3 && y<3) || (x>=FRAME_WIDTH-3 && y<3) || (x<3 && y>=FRAME_HEIGHT-3) || (x>=FRAME_WIDTH-3 && y>=FRAME_HEIGHT-3)) {
            cam_array [y*FRAME_WIDTH + x] = 0x000000FF; //RED
         } else if (x<(FRAME_WIDTH/4)) {
            cam_array [y*FRAME_WIDTH + x] = 0x0000FF00; //GREEN
         } else if (x<(FRAME_WIDTH/4 *2)) {
            cam_array [y*FRAME_WIDTH + x] = 0x00FF0000; //BLUE
         } else if (x<(FRAME_WIDTH/4 *3)) {
            cam_array [y*FRAME_WIDTH + x] = 0x000000FF; //RED
         } else {
            cam_array [y*FRAME_WIDTH + x] = 0x00FF0000; //BLUE
         }
      }
   }
   
/*   
   //Initialize test image in sobel_array
   for (int y=0; y<FRAME_HEIGHT; y++) {
      for (int x=0; x<FRAME_WIDTH; x++) {
         if ((x<3 && y<3) || (x>=FRAME_WIDTH-3 && y<3) || (x<3 && y>=FRAME_HEIGHT-3) || (x>=FRAME_WIDTH-3 && y>=FRAME_HEIGHT-3)) {
            sobel_array [y*FRAME_WIDTH + x] = 0x000000FF; //RED
         } else if (x<(FRAME_WIDTH/4)) {
            sobel_array [y*FRAME_WIDTH + x] = 0x0000FF00; //GREEN
         } else if (x<(FRAME_WIDTH/4 *2)) {
            sobel_array [y*FRAME_WIDTH + x] = 0x00FF0000; //BLUE
         } else if (x<(FRAME_WIDTH/4 *3)) {
            sobel_array [y*FRAME_WIDTH + x] = 0x000000FF; //RED
         } else {
            sobel_array [y*FRAME_WIDTH + x] = 0x00FF0000; //BLUE
         }
      }
   }
*/
   
   //Trigger display DMA once then the rest handled by DMA self restart
   uart_writeStr(BSP_UART_TERMINAL, "\nTrigger display DMA..\n\r");
   
   //SELECT start address of to be displayed data accordingly
   dmasg_input_memory(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, CAM_START_ADDR, 16);
   //dmasg_input_memory(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, GRAYSCALE_START_ADDR, 16);
   //dmasg_input_memory(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, SOBEL_START_ADDR, 16);
   
   dmasg_output_stream(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, DMASG_DISPLAY_MM2S_PORT, 0, 0, 1);
   dmasg_direct_start(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, (FRAME_WIDTH*FRAME_HEIGHT)*4, 1);
   
   msDelay(5000); //Display test content for 5 seconds
   
   uart_writeStr(BSP_UART_TERMINAL, "Done !!\n\n\r");
   
/*
   //Camera capture - continuous mode (to facilitate processing without frame-drop if scaler is enabled in camera building block)
   
   //SELECT RGB or grayscale output from camera pre-processing block.
   EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG3_OFFSET, 0x00000000);   //RGB
   //EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG3_OFFSET, 0x00000001); //grayscale
   
   //Trigger continuous frame capture via APB3 slave
   EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG2_OFFSET, 0x00000002);
*/

   while (1) {
      
      /**********************************************************CAMERA CAPTURE***********************************************************/
      
      //uart_writeStr(BSP_UART_TERMINAL, "\nTrigger camera capture..\n\r");
      
      //SELECT RGB or grayscale output from camera pre-processing block.
      EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG3_OFFSET, 0x00000000);   //RGB
      //EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG3_OFFSET, 0x00000001); //grayscale
      
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
      
      //uart_writeStr(BSP_UART_TERMINAL, "Done !!\n\n\r");
   
      /*******************************************************RISC-V Processing***********************************************************/
/*
      //uart_writeStr(BSP_UART_TERMINAL, "\nRISC-V processing..\n\r");
      
      rgb2grayscale (cam_array, grayscale_array, FRAME_WIDTH, FRAME_HEIGHT);
      //sobel_edge_detection (grayscale_array, sobel_array, FRAME_WIDTH, FRAME_HEIGHT);
      
      //uart_writeStr(BSP_UART_TERMINAL, "Done !!\n\n\r");
*/
      /**********************************************************HW Accelerator***********************************************************/
/*
      //uart_writeStr(BSP_UART_TERMINAL, "\nHardware acceleration..\n\r");
      
      //SET Sobel edge detection threshold via AXI4 slave
      write_u32(100, EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG0_OFFSET); //Default value 100; Range 0 to 255
      
      //SELECT HW accelerator mode - Make sure match with DMA transfer length setting
      write_u32(0x00000000, EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG1_OFFSET);   //2'd0: Sobel only - Default
      //write_u32(0x00000001, EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG1_OFFSET); //2'd1: Sobel+Dilation
      //write_u32(0x00000002, EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG1_OFFSET); //2'd2: Sobel+Erosion
      
      //Trigger HW accel MM2S DMA
      //SELECT start address of DMA input to HW accel block
      dmasg_input_memory(DMASG_BASE, DMASG_HW_ACCEL_MM2S_CHANNEL, GRAYSCALE_START_ADDR, 16);   //RISC-V performs SW RGB2grayscale conversion
      //dmasg_input_memory(DMASG_BASE, DMASG_HW_ACCEL_MM2S_CHANNEL, CAM_START_ADDR, 16);       //Camera pre-processing block performs HW RGB2grayscale conversion
      dmasg_output_stream(DMASG_BASE, DMASG_HW_ACCEL_MM2S_CHANNEL, DMASG_HW_ACCEL_MM2S_PORT, 0, 0, 1);
      
      //SELECT dma transfer length - Make sure match with HW accelerator mode selection
      //Additonal data is required to be fed for line buffer(s) data flushing
      dmasg_direct_start(DMASG_BASE, DMASG_HW_ACCEL_MM2S_CHANNEL, ((FRAME_WIDTH*FRAME_HEIGHT)+(FRAME_WIDTH+1))*4, 0);     //Sobel only
      //dmasg_direct_start(DMASG_BASE, DMASG_HW_ACCEL_MM2S_CHANNEL, ((FRAME_WIDTH*FRAME_HEIGHT)+(2*FRAME_WIDTH+2))*4, 0); //Sobel + Dilation/Erosion

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

      //uart_writeStr(BSP_UART_TERMINAL, "Done !!\n\n\r");
*/
   }
   
   /***********************************************Check AXI4 Slave Status (HW Accelerator)********************************************/
/*   
   uart_writeStr(BSP_UART_TERMINAL, "\nHW accelerator AXI4 status..\n\r");
   
   //Verify slave read operation. Expecting 32'hABCD_1234   
   rdata = axi_slave_read32(EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG3_OFFSET);
   uart_writeStr(BSP_UART_TERMINAL, "test_value :");
   print_hex(rdata, 8);
   uart_writeStr(BSP_UART_TERMINAL, "\n\r");
   
   //LSB: {debug_dma_in_fifo_underflow, debug_dma_in_fifo_overflow, debug_dma_out_fifo_underflow, debug_dma_out_fifo_overflow}
   rdata = axi_slave_read32(EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG4_OFFSET);
   uart_writeStr(BSP_UART_TERMINAL, "debug_hw_accel_fifo_status :");
   print_hex(rdata, 8);
   uart_writeStr(BSP_UART_TERMINAL, "\n\r");
   
   //debug_dma_in_fifo_wcount
   rdata = axi_slave_read32(EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG5_OFFSET);
   uart_writeStr(BSP_UART_TERMINAL, "debug_dma_in_fifo_wcount :");
   print_hex(rdata, 8);
   uart_writeStr(BSP_UART_TERMINAL, "\n\r");
   
   //debug_dma_out_fifo_rcount 
   rdata = axi_slave_read32(EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG6_OFFSET);
   uart_writeStr(BSP_UART_TERMINAL, "debug_dma_out_fifo_rcount :");
   print_hex(rdata, 8);
   uart_writeStr(BSP_UART_TERMINAL, "\n\r");
   
   //debug_dma_out_status 
   rdata = axi_slave_read32(EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG7_OFFSET);
   uart_writeStr(BSP_UART_TERMINAL, "debug_dma_out_status :");
   print_hex(rdata, 8);
   uart_writeStr(BSP_UART_TERMINAL, "\n\r");
*/

   /**********************************************Check APB3 Slave Status (Camera & Display)******************************************/
/*
   uart_writeStr(BSP_UART_TERMINAL, "\nCamera and display APB3 status..\n\r");
   
   //Verify slave read operation. Expecting 32'hABCD_5678
   rdata = example_register_read(EXAMPLE_APB3_SLV_REG5_OFFSET);
   uart_writeStr(BSP_UART_TERMINAL, "test_value :");
   print_hex(rdata, 8);
   uart_writeStr(BSP_UART_TERMINAL, "\n\r");
   
   //{28'd0, debug_cam_dma_fifo_underflow, debug_cam_dma_fifo_overflow, debug_display_dma_fifo_underflow, debug_display_dma_fifo_overflow}
   rdata = example_register_read(EXAMPLE_APB3_SLV_REG6_OFFSET);
   uart_writeStr(BSP_UART_TERMINAL, "debug_fifo_status :");
   print_hex(rdata, 8);
   uart_writeStr(BSP_UART_TERMINAL, "\n\r");
   
   //debug_cam_dma_fifo_rcount
   rdata = example_register_read(EXAMPLE_APB3_SLV_REG7_OFFSET);
   uart_writeStr(BSP_UART_TERMINAL, "debug_cam_dma_fifo_rcount :");
   print_hex(rdata, 8);
   uart_writeStr(BSP_UART_TERMINAL, "\n\r");
   
   //debug_cam_dma_fifo_wcount
   rdata = example_register_read(EXAMPLE_APB3_SLV_REG8_OFFSET);
   uart_writeStr(BSP_UART_TERMINAL, "debug_cam_dma_fifo_wcount :");
   print_hex(rdata, 8);
   uart_writeStr(BSP_UART_TERMINAL, "\n\r");
   
   //debug_display_dma_fifo_rcount
   rdata = example_register_read(EXAMPLE_APB3_SLV_REG9_OFFSET);
   uart_writeStr(BSP_UART_TERMINAL, "debug_display_dma_fifo_rcount :");
   print_hex(rdata, 8);
   uart_writeStr(BSP_UART_TERMINAL, "\n\r");
   
   //debug_display_dma_fifo_wcount
   rdata = example_register_read(EXAMPLE_APB3_SLV_REG10_OFFSET);
   uart_writeStr(BSP_UART_TERMINAL, "debug_display_dma_fifo_wcount :");
   print_hex(rdata, 8);
   uart_writeStr(BSP_UART_TERMINAL, "\n\r");
   
   //debug_cam_dma_status
   rdata = example_register_read(EXAMPLE_APB3_SLV_REG11_OFFSET);
   uart_writeStr(BSP_UART_TERMINAL, "debug_cam_dma_status :");
   print_hex(rdata, 8);
   uart_writeStr(BSP_UART_TERMINAL, "\n\r");
   
   //frames_per_second
   rdata = example_register_read(EXAMPLE_APB3_SLV_REG12_OFFSET);
   uart_writeStr(BSP_UART_TERMINAL, "frames_per_second :");
   print_hex(rdata, 8);
   uart_writeStr(BSP_UART_TERMINAL, "\n\r");
*/
   
   while(1) {
   }
}


