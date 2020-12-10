#include "bsp.h"
#include "i2c.h"
#include "i2cDemo.h"
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

#define FRAME_WIDTH    1280  //640
#define FRAME_HEIGHT   720   //480

//Start address to be divided evenly by 8. Otherwise DMA tkeep might be shifted, not handled in display and hw_accel blocks.
#define CAM_START_ADDR        0x01000000
#define GRAYSCALE_START_ADDR  0x02000000
#define SOBEL_START_ADDR      0x03000000

#define cam_array       ((volatile uint32_t*)CAM_START_ADDR)
#define grayscale_array ((volatile uint32_t*)GRAYSCALE_START_ADDR)
#define sobel_array     ((volatile uint32_t*)SOBEL_START_ADDR)

//Number of frames processing set for timestamp - To be adjusted based anticipated frame processing rate
//For low frame rate scenario, loop count could be set lower to shorten the profiling time.
//For high frame rate scenario, loop count could be set higher to obtain better average frame counts.
#define PROFILING_LOOP  100

void main() {

   //For system profiling
   uint64_t timerCmp0, timerCmp1, timerDiff_0_1;

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
   
   dmasg_priority(DMASG_BASE, DMASG_HW_ACCEL_MM2S_CHANNEL, 0);
   dmasg_priority(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL, 0);
   dmasg_priority(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL,  0);
   dmasg_priority(DMASG_BASE, DMASG_CAM_S2MM_CHANNEL,      0);
   
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


   uart_writeStr(BSP_UART_TERMINAL, "                             ---SYSTEM PROFILING---\n\r");
   uart_writeStr(BSP_UART_TERMINAL, "Start frames processing..\n\n\r");
   
   timerCmp0 = machineTimer_getTime(BSP_MACHINE_TIMER);

   for (int i=0; i<PROFILING_LOOP; i++) {
      
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
   
   timerCmp1 = machineTimer_getTime(BSP_MACHINE_TIMER);
   timerDiff_0_1 = timerCmp1 - timerCmp0;
   
   uart_writeStr(BSP_UART_TERMINAL, "DONE frames processing..\n\n\r");
 
   rdata = example_register_read(EXAMPLE_APB3_SLV_REG12_OFFSET);
   uart_writeStr(BSP_UART_TERMINAL, "MIPI Input Frames Per Second : ");
   print_hex(rdata, 8);
   uart_writeStr(BSP_UART_TERMINAL, "\n\r");
 
   uart_writeStr(BSP_UART_TERMINAL, "PROCESSING_CLOCK_CYCLES      : "); //Timestamp
   print_hex_64(timerDiff_0_1, 16);
   uart_writeStr(BSP_UART_TERMINAL, "\n\r"); 
 
   uart_writeStr(BSP_UART_TERMINAL, "PROCESSOR_CLOCK_RATE (Hz)    : ");
   print_hex(BSP_MACHINE_TIMER_HZ, 8);
   uart_writeStr(BSP_UART_TERMINAL, "\n\r");
   
   uart_writeStr(BSP_UART_TERMINAL, "PROCESSING_LOOP              : ");
   print_hex(PROFILING_LOOP, 8);
   uart_writeStr(BSP_UART_TERMINAL, "\n\r");
   
   uart_writeStr(BSP_UART_TERMINAL, "\n\r-------------------------------------------------------------------------------\n\r");
   uart_writeStr(BSP_UART_TERMINAL, "Formula for seconds/frame (low frame rate - less than one frame per second) :\n\r");
   uart_writeStr(BSP_UART_TERMINAL, "SPF = (PROCESSING_CLOCK_CYCLES/PROCESSOR_CLOCK_RATE)/PROCESSING_LOOP\n\r");
   
   uart_writeStr(BSP_UART_TERMINAL, "\n\rFormula for frames/second (high frame rate - more than one frame per second):\n\r");
   uart_writeStr(BSP_UART_TERMINAL, "FPS = 1/SPF\n\r");
   uart_writeStr(BSP_UART_TERMINAL, "-------------------------------------------------------------------------------\n\r");
   
   while(1) {
   }
}


