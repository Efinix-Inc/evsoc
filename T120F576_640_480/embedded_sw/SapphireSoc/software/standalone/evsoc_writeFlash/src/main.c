#include <stdint.h>
#include <stdio.h>

#include "bsp.h"
#include "spi.h"
#include "spiDemo.h"

#include "img_data.h"

#define StartAddress 0x3B0000 //User data location

void init(){
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

void print_hex(uint32_t val, uint32_t digits)
{
   for (int i = (4*digits)-4; i >= 0; i -= 4)
      uart_write(BSP_UART_TERMINAL, "0123456789ABCDEF"[(val >> i) % 16]);
}

void WaitBusy(void)
{
   u8 out;
   u16 timeout=0;

   while(1)
   {
      bsp_uDelay(1*1000);
   
      spi_select(SPI, 0);
      spi_write(SPI, 0x05);   //Write Enable
      out = spi_read(SPI);
      spi_diselect(SPI, 0);
   
      if((out & 0x01) ==0x00)
         return;
   
      timeout++;
      if(timeout >=400)       //sector erase max=400ms
      {
         uart_writeStr(BSP_UART_TERMINAL, "Time out\n\r");
         return;
      }
   }
}

//For 64KB block erase
void WaitBusy_B64(void)
{
   u8 out;
   u16 timeout=0;

   while(1)
   {
      bsp_uDelay(1*1000);
   
      spi_select(SPI, 0);
      spi_write(SPI, 0x05);   //Write Enable
      out = spi_read(SPI);
      spi_diselect(SPI, 0);
   
      if((out & 0x01) ==0x00)
         return;
   
      timeout++;
      if(timeout >=2000)      //64KB block erase max=2000ms
      {
         uart_writeStr(BSP_UART_TERMINAL, "Time out\n\r");
         return;
      }
   }
}

void WriteEnableLatch(void)
{
   spi_select(SPI, 0);
   spi_write(SPI, 0x06);      //Write Enable latch
   spi_diselect(SPI, 0);
}

void GlobalLock(void)
{
   WriteEnableLatch();
   spi_select(SPI, 0);
   spi_write(SPI, 0x7E);      //Global lock
   spi_diselect(SPI, 0);
}

void GlobalUnlock(void)
{
   WriteEnableLatch();
   spi_select(SPI, 0);
   spi_write(SPI, 0x98);      //Global unlock
   spi_diselect(SPI, 0);
}

void SectorErase(u32 Addr)
{
   WriteEnableLatch();
   
   spi_select(SPI, 0);
   spi_write(SPI, 0x20);      //Erase Sector
   spi_write(SPI, (Addr>>16)&0xFF);
   spi_write(SPI, (Addr>>8)&0xFF);
   spi_write(SPI, Addr&0xFF);
   spi_diselect(SPI, 0);
   
   WaitBusy();
}

void BlockErase_64KB(u32 Addr)
{
   WriteEnableLatch();
   
   spi_select(SPI, 0);
   spi_write(SPI, 0xD8);      //Erase Block (64KB)
   spi_write(SPI, (Addr>>16)&0xFF);
   spi_write(SPI, (Addr>>8)&0xFF);
   spi_write(SPI, Addr&0xFF);
   spi_diselect(SPI, 0);
   
   WaitBusy_B64();
}

void main() {
   
   uart_writeStr(BSP_UART_TERMINAL, "\n\rHello Efinix Edge Vision SoC!!\n\n\r");
   
   int i, p, q, page_len, num_page, data, pix_count, byte_count;
   u32 write_addr;
   
   page_len = 256;   //256 bytes per page program for deployed Winbond flash
   num_page = 3600;  //For 640x480 image, (640x480x3bytes) / 256bytes = 3600 pages 
   write_addr = StartAddress;
   
   uart_writeStr(BSP_UART_TERMINAL, "Initialization..\n\r");
   init();
   
   GlobalUnlock();
   
   uart_writeStr(BSP_UART_TERMINAL, "Erase Flash Start..\n\r");
   //Perform sector (4KB) erase before program
   //SectorErase(write_addr);
   
   //Perform block (64KB) erase before program
   //For storing 640x480x3bytes offline image to flash, 15 * 64KB blocks to be erased.
   for (i=0; i<15;i++)
      {BlockErase_64KB(write_addr + i*0x00010000);}
   
   uart_writeStr(BSP_UART_TERMINAL, "Erase Flash End..\n\r");
   
   /*******************************************************WRITE TO FLASH*******************************************************/
   byte_count = 0;
   pix_count = 0;
   
   uart_writeStr(BSP_UART_TERMINAL, "Write Flash Start..\n\r");
   //Program page-by-page data to flash
   for(p=0;p<num_page;p++)
   {  
      //Issue page program instruction
      WriteEnableLatch();
      spi_select(SPI, 0);
      spi_write(SPI, 0x02);
      spi_write(SPI, (write_addr>>16)&0xFF);
      spi_write(SPI, (write_addr>>8)&0xFF);
      spi_write(SPI, write_addr&0xFF);
      
      //Provide 1 - 256 byte(s) data
      //If an entire 256 byte page is to be programmed, the last address byte (the 8 least significant address bits) should be 
      //set to 0.
      //One condition to perform a partial page program is that the number of clocks cannot exceed the remaining page length.
      //Pixel data in IMG_DATA are stored in 32-bit "00BBGGRR" format (RGB888)
      for(i=0;i<page_len;i++)
      {
         if (byte_count == 0) {
            data = IMG_DATA [pix_count];           //Red
         } else if (byte_count == 1) {
            data = (IMG_DATA [pix_count]) >> 8;    //Green
         } else {
            data = (IMG_DATA [pix_count]) >> 16;   //Blue
         } 
      
         spi_write(SPI, data&0xFF);
         
         //3 bytes data per image pixel
         if (byte_count == 2) {
            byte_count = 0;
            pix_count++;
         } else {
            byte_count++;
         }
      }
      
      //Wait for completion of page program
      spi_diselect(SPI, 0);
      WaitBusy();
      
      write_addr = write_addr + page_len;
   }
   
   GlobalLock();
   uart_writeStr(BSP_UART_TERMINAL, "Write Flash End..\n\r");
   
   while(1){}
}
