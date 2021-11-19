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

#define FRAME_WIDTH    1280
#define FRAME_HEIGHT   720

//Start address to be divided evenly by 8. Otherwise DMA tkeep might be shifted, not handled in display and hw_accel blocks.
#define CAM1_START_ADDR       0x01000000
#define CAM2_START_ADDR       0x02000000
#define HW_ACCEL_START_ADDR   0x03000000

#define cam1_array      ((volatile uint32_t*)CAM1_START_ADDR)
#define cam2_array      ((volatile uint32_t*)CAM2_START_ADDR)
#define hw_accel_array  ((volatile uint32_t*)HW_ACCEL_START_ADDR)

u32 select_demo_mode;   //For demo mode selection

/*******************************************************UART-RELATED FUNCTIONS******************************************************/

#define UART_A_SAMPLE_PER_BAUD 8
#define CORE_HZ SYSTEM_MACHINE_TIMER_HZ

u32 uart_status_read(void) {
   return read_u32(BSP_UART_TERMINAL+UART_STATUS);
}

void uart_status_write(char data) {
   write_u32(data ,BSP_UART_TERMINAL+UART_STATUS);
}

void uart_init(){
   //UART init
   Uart_Config uartA;
   uartA.dataLength = BITS_8; //8 bits
   uartA.parity = NONE;
   uartA.stop = ONE;
   uartA.clockDivider = CORE_HZ/(115200*UART_A_SAMPLE_PER_BAUD)-1;
   uart_applyConfig(BSP_UART_TERMINAL, &uartA);

   uart_status_write(uart_status_read() | 0x02);   // RX FIFO not empty interrupt enable
   
   //Configure PLIC
   plic_set_threshold(BSP_PLIC, BSP_PLIC_CPU_0, 0); //cpu 0 accept all interrupts with priority above 0
   
   //Enable SYSTEM_PLIC_USER_INTERRUPT_A_INTERRUPT rising edge interrupt
	plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, SYSTEM_PLIC_SYSTEM_UART_0_IO_INTERRUPT, 1);
	plic_set_priority(BSP_PLIC, SYSTEM_PLIC_SYSTEM_UART_0_IO_INTERRUPT, 1);
   
   //Enable interrupts
   csr_write(mtvec, trap_entry); //Set the machine trap vector (../common/trap.S)
   csr_set(mie, MIE_MEIE);       //Enable external interrupts
   csr_write(mstatus, MSTATUS_MPP | MSTATUS_MIE);
}

void uart_demo_mode_selection()
{
   u32 uart_user_input;
   if (uart_status_read() & 0x00000200){

      uart_status_write(uart_status_read() & 0xFFFFFFFD);   // RX FIFO not empty interrupt Disable
      uart_user_input = uart_read(BSP_UART_TERMINAL);
      uart_status_write(uart_status_read() | 0x02);         // RX FIFO not empty interrupt enable

      //Assign UART input for demo mode selection
      if (uart_user_input == 'a') {
         select_demo_mode = 0;
         uart_writeStr(BSP_UART_TERMINAL, "Selected Demo Mode: a\n\r");
      } else if (uart_user_input == 'b') {
         select_demo_mode = 1;
         uart_writeStr(BSP_UART_TERMINAL, "Selected Demo Mode: b\n\r");
      } else if (uart_user_input == 'c') {
         select_demo_mode = 2;
         uart_writeStr(BSP_UART_TERMINAL, "Selected Demo Mode: c\n\r");
      } else if (uart_user_input == 'd') {
         select_demo_mode = 3;
         uart_writeStr(BSP_UART_TERMINAL, "Selected Demo Mode: d\n\r");
      } else {
         select_demo_mode = 4;
         uart_writeStr(BSP_UART_TERMINAL, "Selected Demo Mode: e\n\r");
      }
	}
}

void externalInterrupt(){
   uint32_t claim;
   //While there is pending interrupts
   while(claim = plic_claim(BSP_PLIC, BSP_PLIC_CPU_0)){
      switch(claim){
      //UART interrupt
      case SYSTEM_PLIC_SYSTEM_UART_0_IO_INTERRUPT:
         uart_demo_mode_selection();
         break;
         
      default: crash(); break;
      }
      plic_release(BSP_PLIC, BSP_PLIC_CPU_0, claim); //unmask the claimed interrupt
   }
}

//Called by trap_entry on both exceptions and interrupts events
void trap(){
   int32_t mcause = csr_read(mcause);
   int32_t interrupt = mcause < 0;    //Interrupt if true, exception if false
   int32_t cause     = mcause & 0xF;
   if(interrupt){
      switch(cause){
      case CAUSE_MACHINE_EXTERNAL: externalInterrupt(); break;
      default: crash(); break;
      }
   } else {
      crash();
   }
}

/*******************************************************DEMO-RELATED FUNCTIONS******************************************************/

void dualCam_menu()
{
	uart_writeStr(BSP_UART_TERMINAL, "================================================================================\n\r");
	uart_writeStr(BSP_UART_TERMINAL, "                    Dual-Camera Design Scenario Selection\n\r");
	uart_writeStr(BSP_UART_TERMINAL, "================================================================================\n\r");
   
   uart_writeStr(BSP_UART_TERMINAL, "'a' : Merge Left + Right   - RGB Colour (cam 1) + RGB Colour (cam 2)            \n\r");
   uart_writeStr(BSP_UART_TERMINAL, "'b' : Merge Main + Overlay - RGB Colour (cam 1) + RGB Colour (cam 2)            \n\r");
   uart_writeStr(BSP_UART_TERMINAL, "'c' : Merge Main + Overlay - RGB Colour (cam 2) + RGB Colour (cam 1)            \n\r");
   uart_writeStr(BSP_UART_TERMINAL, "'d' : Merge Main + Overlay - Grayscale  (cam 1) + Sobel      (cam 2)            \n\r");
   uart_writeStr(BSP_UART_TERMINAL, "'e' : Merge Main + Overlay - Sobel      (cam 1) + Sobel      (cam 2)            \n\r");

	uart_writeStr(BSP_UART_TERMINAL, "================================================================================\n\n\r");
}

void main() {

   /**************************************************SETUP PICAM & HDMI DISPLAY***************************************************/
   
   Set_MipiRst(1);
   Set_MipiRst(0);

   uart_writeStr(BSP_UART_TERMINAL, "\n\rHello Efinix Edge Vision SoC (Dual-Camera)!!\n\n\r");

   uart_writeStr(BSP_UART_TERMINAL, "Init HDMI I2C.....");
   hdmi_i2c_init();
   hdmi_init();
   uart_writeStr(BSP_UART_TERMINAL, "Done !!\n\r");

   uart_writeStr(BSP_UART_TERMINAL, "Init MIPI I2C.....");
   cam1_i2c_init();
   cam2_i2c_init();
   PiCam1_init();
   PiCam2_init();
   uart_writeStr(BSP_UART_TERMINAL, "Done !!\n\r");

   Set_RGBGain1(1,5,3,4); //SET camera pre-processing RGB gain value (cam1)
   Set_RGBGain2(1,5,3,4); //SET camera pre-processing RGB gain value (cam2)
   
   /*******************************************************SETUP DMA & UART********************************************************/
   
   uart_writeStr(BSP_UART_TERMINAL, "Init DMA & UART.....");
   
   uart_init();
   
   dmasg_priority(DMASG_BASE, DMASG_CAM1_S2MM_CHANNEL,       0);
   dmasg_priority(DMASG_BASE, DMASG_CAM2_S2MM_CHANNEL,       0);
   dmasg_priority(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL,    0);
   dmasg_priority(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL,   0);
   dmasg_priority(DMASG_BASE, DMASG_HW_ACCEL_MM2S_1_CHANNEL, 0);
   dmasg_priority(DMASG_BASE, DMASG_HW_ACCEL_MM2S_2_CHANNEL, 0);

   uart_writeStr(BSP_UART_TERMINAL, "Done !!\n\r");
  
   /*******************************************************Trigger Display********************************************************/
   
   u32 rdata;
   
   select_demo_mode = 0;   //Default
 
   //To check display functionality
   uart_writeStr(BSP_UART_TERMINAL, "Init test display content.....");

   //Array name to be modified to DDR location used for display
   //Colour bar & Red dots at 4 corners of active display
   
   //Initialize test image in hw_accel_array
   for (int y=0; y<FRAME_HEIGHT; y++) {
      for (int x=0; x<FRAME_WIDTH; x++) {
         if ((x<3 && y<3) || (x>=FRAME_WIDTH-3 && y<3) || (x<3 && y>=FRAME_HEIGHT-3) || (x>=FRAME_WIDTH-3 && y>=FRAME_HEIGHT-3)) {
            hw_accel_array [y*FRAME_WIDTH + x] = 0x000000FF; //RED
         } else if (x<(FRAME_WIDTH/4)) {
            hw_accel_array [y*FRAME_WIDTH + x] = 0x0000FF00; //GREEN
         } else if (x<(FRAME_WIDTH/4 *2)) {
            hw_accel_array [y*FRAME_WIDTH + x] = 0x00FF0000; //BLUE
         } else if (x<(FRAME_WIDTH/4 *3)) {
            hw_accel_array [y*FRAME_WIDTH + x] = 0x000000FF; //RED
         } else {
            hw_accel_array [y*FRAME_WIDTH + x] = 0x00FF0000; //BLUE
         }
      }
   }
   
   uart_writeStr(BSP_UART_TERMINAL, "Done !!\n\r");

   //Trigger display DMA once then the rest handled by DMA self restart
   uart_writeStr(BSP_UART_TERMINAL, "\nTrigger display DMA.....");
   
   dmasg_input_memory(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, HW_ACCEL_START_ADDR, 16);
   dmasg_output_stream(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, DMASG_DISPLAY_MM2S_PORT, 0, 0, 1);
   dmasg_direct_start(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, (FRAME_WIDTH*FRAME_HEIGHT)*4, 1);
   
   uart_writeStr(BSP_UART_TERMINAL, "Done !!\n\n\r");
   
   msDelay(5000); //Display test content for 5 seconds
   
   dualCam_menu();
   
   uart_writeStr(BSP_UART_TERMINAL, "Default Demo Mode: a\n\r");

   while (1) {
      
      /**********************************************************CAMERA CAPTURE***********************************************************/
      
      //uart_writeStr(BSP_UART_TERMINAL, "\nTrigger camera capture..\n\r");
      
      //SELECT RGB or grayscale output from camera pre-processing block (cam1)
      if(select_demo_mode<3) {
         EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG3_OFFSET, 0x00000000);   //RGB
      } else {
         EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG3_OFFSET, 0x00000001);   //grayscale
      }
      
      //SELECT RGB or grayscale output from camera pre-processing block (cam2)
      if(select_demo_mode<3) {
         EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG7_OFFSET, 0x00000000);   //RGB
      } else {
         EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG7_OFFSET, 0x00000001);   //grayscale
      }
      
      //Trigger camera DMA (cam1)
      dmasg_input_stream(DMASG_BASE, DMASG_CAM1_S2MM_CHANNEL, DMASG_CAM1_S2MM_PORT, 1, 0);
      dmasg_output_memory(DMASG_BASE, DMASG_CAM1_S2MM_CHANNEL, CAM1_START_ADDR, 16);
      dmasg_direct_start(DMASG_BASE, DMASG_CAM1_S2MM_CHANNEL, (FRAME_WIDTH*FRAME_HEIGHT)*4, 0);
      
      //Trigger camera DMA (cam2)
      dmasg_input_stream(DMASG_BASE, DMASG_CAM2_S2MM_CHANNEL, DMASG_CAM2_S2MM_PORT, 1, 0);
      dmasg_output_memory(DMASG_BASE, DMASG_CAM2_S2MM_CHANNEL, CAM2_START_ADDR, 16);
      dmasg_direct_start(DMASG_BASE, DMASG_CAM2_S2MM_CHANNEL, (FRAME_WIDTH*FRAME_HEIGHT)*4, 0);
      
      //Indicate start of S2MM DMA to camera building block via APB3 slave (cam1)
      EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG4_OFFSET, 0x00000001);
      EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG4_OFFSET, 0x00000000);
      
      //Indicate start of S2MM DMA to camera building block via APB3 slave (cam2)
      EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG8_OFFSET, 0x00000001);
      EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG8_OFFSET, 0x00000000);
      
      //Trigger storage of one captured frame via APB3 slave (cam1)
      EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG2_OFFSET, 0x00000001);
      EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG2_OFFSET, 0x00000000);
      
      //Trigger storage of one captured frame via APB3 slave (cam2)
      EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG6_OFFSET, 0x00000001);
      EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG6_OFFSET, 0x00000000);
      
      //Wait for DMA transfer completion
      while(dmasg_busy(DMASG_BASE, DMASG_CAM1_S2MM_CHANNEL) || dmasg_busy(DMASG_BASE, DMASG_CAM2_S2MM_CHANNEL));
      flush_data_cache();
      
      //uart_writeStr(BSP_UART_TERMINAL, "Done !!\n\n\r");
   
      /*******************************************************RISC-V Processing***********************************************************/
/*
      //uart_writeStr(BSP_UART_TERMINAL, "\nRISC-V processing..\n\r");
      
      //...
      
      //uart_writeStr(BSP_UART_TERMINAL, "Done !!\n\n\r");
*/
      /**********************************************************HW Accelerator***********************************************************/

      //uart_writeStr(BSP_UART_TERMINAL, "\nHardware acceleration..\n\r");
      //SET Sobel edge detection threshold via AXI4 slave
      write_u32(100, EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG0_OFFSET); //Default value 100; Range 0 to 255
      
      //SELECT HW accelerator mode - Image Merger
      if(select_demo_mode<3) {
         write_u32(0x00000000, EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG1_OFFSET);   //2'd0: Cam source 1 - Passthrough;       Cam source 2 - Passthrough
      } else if(select_demo_mode==3) {
         write_u32(0x00000001, EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG1_OFFSET);   //2'd1: Cam source 1 - Passthrough;       Cam source 2 - Processed (Sobel)
      } else if(select_demo_mode==4) {
         write_u32(0x00000003, EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG1_OFFSET);   //2'd3: Cam source 1 - Processed (Sobel); Cam source 2 - Processed (Sobel)
      } else { //Not applicable for the listed demo scenarios
         write_u32(0x00000002, EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG1_OFFSET);   //2'd2: Cam source 1 - Processed (Sobel); Cam source 2 - Passthrough
      }
      
      if(select_demo_mode==0) {
         //Merge frame data from cam source 1 (cropped by half, left side) and cam source 2 (cropped by half, right side)
         write_u32(0x00000000, EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG2_OFFSET);
      } else {
         //Merge frame data from cam source 1 (main) and cam source 2 (downscaled overlay)
         write_u32(0x00000001, EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG2_OFFSET);
      }
      
      //Trigger HW accel MM2S DMA
      if (select_demo_mode==2) {
         dmasg_input_memory(DMASG_BASE, DMASG_HW_ACCEL_MM2S_1_CHANNEL, CAM2_START_ADDR, 16);
      } else {
         dmasg_input_memory(DMASG_BASE, DMASG_HW_ACCEL_MM2S_1_CHANNEL, CAM1_START_ADDR, 16);
      }
      dmasg_output_stream(DMASG_BASE, DMASG_HW_ACCEL_MM2S_1_CHANNEL, DMASG_HW_ACCEL_MM2S_1_PORT, 0, 0, 1);
      dmasg_direct_start(DMASG_BASE, DMASG_HW_ACCEL_MM2S_1_CHANNEL, ((FRAME_WIDTH*FRAME_HEIGHT)+(FRAME_WIDTH+1))*4, 0);
      
      //Trigger HW accel MM2S DMA
      if (select_demo_mode==2) {
         dmasg_input_memory(DMASG_BASE, DMASG_HW_ACCEL_MM2S_2_CHANNEL, CAM1_START_ADDR, 16);
      } else {
         dmasg_input_memory(DMASG_BASE, DMASG_HW_ACCEL_MM2S_2_CHANNEL, CAM2_START_ADDR, 16);
      }
      dmasg_output_stream(DMASG_BASE, DMASG_HW_ACCEL_MM2S_2_CHANNEL, DMASG_HW_ACCEL_MM2S_2_PORT, 0, 0, 1);
      
      dmasg_direct_start(DMASG_BASE, DMASG_HW_ACCEL_MM2S_2_CHANNEL, ((FRAME_WIDTH*FRAME_HEIGHT)+(FRAME_WIDTH+1))*4, 0);

      //Trigger HW accel S2MM DMA
      dmasg_input_stream(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL, DMASG_HW_ACCEL_S2MM_PORT, 1, 0);
      dmasg_output_memory(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL, HW_ACCEL_START_ADDR, 16);
      dmasg_direct_start(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL, (FRAME_WIDTH*FRAME_HEIGHT)*4, 0);
      
      //Indicate start of S2MM DMA to HW accel building block via APB3 slave
      write_u32(0x00000001, EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG3_OFFSET);
      write_u32(0x00000000, EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG3_OFFSET);

      //Wait for DMA transfer completion
      while(dmasg_busy(DMASG_BASE, DMASG_HW_ACCEL_MM2S_1_CHANNEL) || dmasg_busy(DMASG_BASE, DMASG_HW_ACCEL_MM2S_2_CHANNEL) || 
         dmasg_busy(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL));
      flush_data_cache();
      
      //uart_writeStr(BSP_UART_TERMINAL, "Done !!\n\n\r");
   }
   
   while(1) {
   }
}
