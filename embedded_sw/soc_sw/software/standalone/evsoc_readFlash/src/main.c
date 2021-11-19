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
#include "apb3_cam.h"
#include "hdmi_config.h"
#include "hdmi_driver.h"
#include "dmasg.h"
#include "dmasg_config.h"

#include "spi.h"
#include "spiDemo.h"

#define FRAME_WIDTH    640
#define FRAME_HEIGHT   480

//Start address to be divided evenly by 8. Otherwise DMA tkeep might be shifted, not handled in display block.
#define DISPLAY_START_ADDR    0x01000000
#define display_array         ((volatile uint32_t*)DISPLAY_START_ADDR)

//User data location in flash (non-volatile)
#define FLASH_START_ADDR      0x003B0000

void spi_init(){
   //SPI init
   Spi_Config spiA;
   spiA.cpol = 1;
   spiA.cpha = 1;
   spiA.mode = 0; //Assume full duplex (standard SPI)
   spiA.clkDivider = 10;
   spiA.ssSetup = 5;
   spiA.ssHold = 5;
   spiA.ssDisable = 5;
   spi_applyConfig(SPI, &spiA);
}

void main() {

   /******************************************************SETUP HDMI DISPLAY******************************************************/
   
   Set_MipiRst(1);
   Set_MipiRst(0);

   uart_writeStr(BSP_UART_TERMINAL, "\n\rHello Efinix Edge Vision SoC!!\n\n\r");

   uart_writeStr(BSP_UART_TERMINAL, "Init HDMI I2C.....");
   hdmi_i2c_init();
   hdmi_init();
   uart_writeStr(BSP_UART_TERMINAL, "Done !!\n\r");
   
   /**********************************************************SETUP DMA***********************************************************/
   
   uart_writeStr(BSP_UART_TERMINAL, "Init DMA.....");
   
   dma_init();
   dmasg_priority(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL,  0);
   
   uart_writeStr(BSP_UART_TERMINAL, "Done !!\n\n\r");
  
   /**********************************************************READ FLASH***********************************************************/
   
   uint8_t red_byte, green_byte, blue_byte;
   uint32_t pixel_data;
   
   uart_writeStr(BSP_UART_TERMINAL, "Init SPI.....");
   spi_init();
   uart_writeStr(BSP_UART_TERMINAL, "Done !!\n\r");

   //Initialize display content with offline image retrieved from flash
   uart_writeStr(BSP_UART_TERMINAL, "Reading offline image from flash..\n\r");

   //The address is automatically incremented to the next higher address after each byte of data is shifted out
   //allowing for a continuous stream of data. This means that the entire memory can be accessed with a single 
   //instruction as long as the clock continues.

   spi_select(SPI, 0);
   spi_write(SPI, 0x03);
   spi_write(SPI, (FLASH_START_ADDR>>16)&0xFF);
   spi_write(SPI, (FLASH_START_ADDR>>8)&0xFF);
   spi_write(SPI, FLASH_START_ADDR&0xFF);

   for(int i=0;i<FRAME_WIDTH*FRAME_HEIGHT;i++)
   {
      red_byte   = spi_read(SPI);
      green_byte = spi_read(SPI);
      blue_byte  = spi_read(SPI);
      
      pixel_data = (blue_byte<<16) + (green_byte<<8) + (red_byte);
      display_array [i] = pixel_data;
   }
   
   spi_diselect(SPI, 0);
   uart_writeStr(BSP_UART_TERMINAL, "Done !!\n\n\r");

   /*******************************************************TRIGGER DISPLAY********************************************************/
   
   //Trigger display DMA once then the rest handled by DMA self restart
   uart_writeStr(BSP_UART_TERMINAL, "Trigger display DMA..\n\r");
   
   dmasg_input_memory(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, DISPLAY_START_ADDR, 16);
   dmasg_output_stream(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, DMASG_DISPLAY_MM2S_PORT, 0, 0, 1);
   dmasg_direct_start(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, (FRAME_WIDTH*FRAME_HEIGHT)*4, 1);
   
   uart_writeStr(BSP_UART_TERMINAL, "Done !!\n\n\r");
   
   while(1) {
   }
}
