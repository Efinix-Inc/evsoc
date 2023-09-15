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
//#include "hdmi_config.h"
//#include "hdmi_driver.h"
#include "dmasg.h"
#include "dmasg_config.h"
#include "axi4_hw_accel.h"
#include "isp.h"

#define FRAME_WIDTH    1920
#define FRAME_HEIGHT   1080

//#define FRAME_WIDTH    1280
//#define FRAME_HEIGHT   720

//#define FRAME_WIDTH    640
//#define FRAME_HEIGHT   480

//Start address to be divided evenly by 8. Otherwise DMA tkeep might be shifted, not handled in display and hw_accel blocks.
#define CAM_START_ADDR        0x01000000
#define GRAYSCALE_START_ADDR  0x02000000
#define SOBEL_START_ADDR      0x03000000

#define cam_array       ((volatile uint32_t*)CAM_START_ADDR)
#define grayscale_array ((volatile uint32_t*)GRAYSCALE_START_ADDR)
#define sobel_array     ((volatile uint32_t*)SOBEL_START_ADDR)

u32 select_demo_mode;      //For demo mode selection
u32 display_mm2s_active=0; //For DMA interrupt

/*******************************************************UART & DMA-RELATED FUNCTIONS***************************************************/

#define UART_A_SAMPLE_PER_BAUD 8
#define CORE_HZ BSP_MACHINE_TIMER_HZ

//For DMA interrupt
uint32_t hw_accel_mm2s_active;
uint32_t hw_accel_s2mm_active;
uint32_t cam_s2mm_active;
uint32_t display_mm2s_active;

void dma_uart_init(){
   //UART init
   Uart_Config uartA;
   uartA.dataLength = BITS_8; //8 bits
   uartA.parity = NONE;
   uartA.stop = ONE;
   uartA.clockDivider = CORE_HZ/(115200*UART_A_SAMPLE_PER_BAUD)-1;
   uart_applyConfig(BSP_UART_TERMINAL, &uartA);

   uart_status_write(BSP_UART_TERMINAL,uart_status_read(BSP_UART_TERMINAL) | 0x02);   // RX FIFO not empty interrupt enable
   
   //Configure PLIC
   plic_set_threshold(BSP_PLIC, BSP_PLIC_CPU_0, 0); //cpu 0 accept all interrupts with priority above 0
   
   //Enable PLIC DMASG channel 0 interrupt listening (But for the demo, we enable the DMASG internal interrupts later)
   plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, PLIC_DMASG_CHANNEL, 1);
   plic_set_priority(BSP_PLIC, PLIC_DMASG_CHANNEL, 1);
   
   //Enable SYSTEM_PLIC_USER_INTERRUPT_A_INTERRUPT rising edge interrupt
	plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, SYSTEM_PLIC_SYSTEM_UART_0_IO_INTERRUPT, 1);
	plic_set_priority(BSP_PLIC, SYSTEM_PLIC_SYSTEM_UART_0_IO_INTERRUPT, 2); //1
   
   //Enable interrupts
   csr_write(mtvec, trap_entry); //Set the machine trap vector (../common/trap.S)
   csr_set(mie, MIE_MEIE);       //Enable external interrupts
   csr_write(mstatus, MSTATUS_MPP | MSTATUS_MIE);
}

void trigger_next_display_dma () {

   //SELECT start address of to be displayed data accordingly
   if(select_demo_mode==0 || select_demo_mode==3) {
      dmasg_input_memory(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, CAM_START_ADDR, 16);
   } else if (select_demo_mode==1) {
      dmasg_input_memory(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, GRAYSCALE_START_ADDR, 16);
   } else {
      dmasg_input_memory(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, SOBEL_START_ADDR, 16);
   }
   
   dmasg_output_stream(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, DMASG_DISPLAY_MM2S_PORT, 0, 0, 1);
   dmasg_interrupt_config(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, DMASG_CHANNEL_INTERRUPT_CHANNEL_COMPLETION_MASK);
   dmasg_direct_start(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, (FRAME_WIDTH*FRAME_HEIGHT)*4, 0);  //Without self restar
}

void uart_demo_mode_selection()
{
   u32 uart_user_input;
   if (uart_status_read(BSP_UART_TERMINAL) & 0x00000200){

      uart_status_write(BSP_UART_TERMINAL,uart_status_read(BSP_UART_TERMINAL) & 0xFFFFFFFD);   // RX FIFO not empty interrupt Disable
      uart_user_input = uart_read(BSP_UART_TERMINAL);
      uart_status_write(BSP_UART_TERMINAL,uart_status_read(BSP_UART_TERMINAL) | 0x02);         // RX FIFO not empty interrupt enable

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
      } else if (uart_user_input == 'e') {
         select_demo_mode = 4;
         uart_writeStr(BSP_UART_TERMINAL, "Selected Demo Mode: e\n\r");
      } else if (uart_user_input == 'f') {
         select_demo_mode = 5;
         uart_writeStr(BSP_UART_TERMINAL, "Selected Demo Mode: f\n\r");
      } else {
         select_demo_mode = 6;
         uart_writeStr(BSP_UART_TERMINAL, "Selected Demo Mode: g\n\r");
      }
	}
}

void externalInterrupt(){
   uint32_t claim;
   //While there is pending interrupts
   while(claim = plic_claim(BSP_PLIC, BSP_PLIC_CPU_0)){
      switch(claim){
      //DMA interrupt
      case PLIC_DMASG_CHANNEL:
         if(display_mm2s_active && !(dmasg_busy(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL))) {
            trigger_next_display_dma();
         }
         break;
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

void ispExample_menu()
{
	uart_writeStr(BSP_UART_TERMINAL, "================================================================================\n\r");
	uart_writeStr(BSP_UART_TERMINAL, "                    ISP Example Design Scenario Selection\n\r");
	uart_writeStr(BSP_UART_TERMINAL, "================================================================================\n\r");
   
	uart_writeStr(BSP_UART_TERMINAL, "'a' : Camera Capture + HDMI Display                                             \n\r");
   uart_writeStr(BSP_UART_TERMINAL, "'b' : Camera Capture + RGB2Grayscale (SW) + HDMI Display                        \n\r");
   uart_writeStr(BSP_UART_TERMINAL, "'c' : Camera Capture + RGB2Grayscale (SW) + Sobel (HW) + HDMI Display           \n\r");
   uart_writeStr(BSP_UART_TERMINAL, "'d' : Camera Capture + RGB2Grayscale (HW) + HDMI Display                        \n\r");
   uart_writeStr(BSP_UART_TERMINAL, "'e' : Camera Capture + RGB2Grayscale & Sobel (HW) + HDMI Display                \n\r");
   uart_writeStr(BSP_UART_TERMINAL, "'f' : Camera Capture + RGB2Grayscale & Sobel & Dilation (HW) + HDMI Display     \n\r");
   uart_writeStr(BSP_UART_TERMINAL, "'g' : Camera Capture + RGB2Grayscale & Sobel & Erosion  (HW) + HDMI Display     \n\r");

	uart_writeStr(BSP_UART_TERMINAL, "================================================================================\n\n\r");
}


/****************************************************************MAIN**************************************************************/
void main() {

    /**************************************************SETUP PICAM & HDMI DISPLAY***************************************************/

    Set_MipiRst(1);
    Set_MipiRst(0);
    
    uart_writeStr(BSP_UART_TERMINAL, "\n\rHello Efinix Edge Vision SoC Demo!!\n\n\r");  //Mode selection using UART input
    
//    uart_writeStr(BSP_UART_TERMINAL, "Init HDMI I2C.....");
//    hdmi_i2c_init();
//    hdmi_init();
//    uart_writeStr(BSP_UART_TERMINAL, "Done !!\n\r");
    
    uart_writeStr(BSP_UART_TERMINAL, "Init MIPI I2C.....");
    mipi_i2c_init();
    PiCam_init();
    uart_writeStr(BSP_UART_TERMINAL, "Done !!\n\n\r");
    
    Set_RGBGain(1,5,3,4); //SET camera pre-processing RGB gain value
    
    /******************************************************SETUP DMA & UART********************************************************/
    
    uart_writeStr(BSP_UART_TERMINAL, "Init DMA & UART.....");
    
    dma_uart_init();
    
    dmasg_priority(DMASG_BASE, DMASG_HW_ACCEL_MM2S_CHANNEL, 0, 0);
    dmasg_priority(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL, 0, 0);
    dmasg_priority(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL,  0, 0);
    dmasg_priority(DMASG_BASE, DMASG_CAM_S2MM_CHANNEL,      0, 0);
    
    uart_writeStr(BSP_UART_TERMINAL, "Done !!\n\n\r");
    
    /*******************************************************Trigger Display********************************************************/
    
    u32 rdata;
    
    select_demo_mode = 0;   //Default
    
    //To check display functionality
    uart_writeStr(BSP_UART_TERMINAL, "Initialize test display content..\n\r");
    
    //Array name to be modified to DDR location used for display
    //Colour bar & Red dots at 4 corners of active display
    //Initialize test image in cam_array - Default
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
    
    //Trigger display DMA once then the rest handled by DMA (Direct mode DMA)
    uart_writeStr(BSP_UART_TERMINAL, "\nTrigger display DMA..\n\r");
    
    //SELECT start address of to be displayed data accordingly - Default
    dmasg_input_memory(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, CAM_START_ADDR, 16);
    
    dmasg_output_stream(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, DMASG_DISPLAY_MM2S_PORT, 0, 0, 1);
    dmasg_interrupt_config(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, DMASG_CHANNEL_INTERRUPT_CHANNEL_COMPLETION_MASK);
    dmasg_direct_start(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, (FRAME_WIDTH*FRAME_HEIGHT)*4, 0);  //Without self restart
    display_mm2s_active = 1;   //Display always active
    
    msDelay(5000); //Display test content for 5 seconds
    
    ispExample_menu();
    
    uart_writeStr(BSP_UART_TERMINAL, "Default Demo Mode: a\n\r");
    
    while (1) {
        
        /**********************************************************CAMERA CAPTURE***********************************************************/
        
        //uart_writeStr(BSP_UART_TERMINAL, "\nTrigger camera capture..\n\r");
        
        //SELECT RGB or grayscale output from camera pre-processing block.
        if(select_demo_mode>2) {
            EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG3_OFFSET, 0x00000001); //grayscale
        } else {
            EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG3_OFFSET, 0x00000000); //RGB
        }
        
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
    
        //uart_writeStr(BSP_UART_TERMINAL, "\nRISC-V processing..\n\r");
        
        if(select_demo_mode==1 || select_demo_mode==2) {
            rgb2grayscale (cam_array, grayscale_array, FRAME_WIDTH, FRAME_HEIGHT);
        }
        
        //uart_writeStr(BSP_UART_TERMINAL, "Done !!\n\n\r");
    
        /**********************************************************HW Accelerator***********************************************************/
    
        //uart_writeStr(BSP_UART_TERMINAL, "\nHardware acceleration..\n\r");
        
        if(select_demo_mode==2 || select_demo_mode>3) {
        
            //SET Sobel edge detection threshold via AXI4 slave
            write_u32(100, EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG0_OFFSET); //Default value 100; Range 0 to 255
            
            //SELECT HW accelerator mode - Make sure match with DMA transfer length setting
            if(select_demo_mode==2 || select_demo_mode==4) {
            write_u32(0x00000000, EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG1_OFFSET);   //2'd0: Sobel only
            } else if (select_demo_mode==5) {
            write_u32(0x00000001, EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG1_OFFSET);   //2'd1: Sobel+Dilation
            } else {
            write_u32(0x00000002, EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG1_OFFSET);   //2'd2: Sobel+Erosion
            }
            
            //Trigger HW accel MM2S DMA
            //SELECT start address of DMA input to HW accel block
            dmasg_input_memory(DMASG_BASE, DMASG_HW_ACCEL_MM2S_CHANNEL, CAM_START_ADDR, 16);         //Camera pre-processing block performs HW RGB2grayscale conversion
            //dmasg_input_memory(DMASG_BASE, DMASG_HW_ACCEL_MM2S_CHANNEL, GRAYSCALE_START_ADDR, 16); //RISC-V performs SW RGB2grayscale conversion       
            dmasg_output_stream(DMASG_BASE, DMASG_HW_ACCEL_MM2S_CHANNEL, DMASG_HW_ACCEL_MM2S_PORT, 0, 0, 1);
            
            //SELECT dma transfer length - Make sure match with HW accelerator mode selection
            //Additonal data is required to be fed for line buffer(s) data flushing
            if(select_demo_mode==2 || select_demo_mode==4) {
            dmasg_direct_start(DMASG_BASE, DMASG_HW_ACCEL_MM2S_CHANNEL, ((FRAME_WIDTH*FRAME_HEIGHT)+(FRAME_WIDTH+1))*4, 0);   //Sobel only
            } else {
            dmasg_direct_start(DMASG_BASE, DMASG_HW_ACCEL_MM2S_CHANNEL, ((FRAME_WIDTH*FRAME_HEIGHT)+(2*FRAME_WIDTH+2))*4, 0); //Sobel + Dilation/Erosion
            }
    
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
        }
        //uart_writeStr(BSP_UART_TERMINAL, "Done !!\n\n\r");
    }
}
