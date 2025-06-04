///////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 2025 SaxonSoc contributors
//  SPDX license identifier: MIT
//  Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
///////////////////////////////////////////////////////////////////////////////////

/******************************************************************************
*
* @file main.c: spiDemo
*
* @brief This demo provides example code for reading the device ID and JEDEC ID of the SPI flash 
*        device on the development board. The application displays the results on a UART terminal. 
*        It continues to print to the terminal until you suspend or stop the application.
*
* @note
*   The default base address map of the SPI flash master is 0xF801_4000.
*   The default SCK frequency is half of the SoC system clock frequency.
*   The default base address of the UART is 0xF801_0000 with a default baud rate of 115200.
*
******************************************************************************/
#include <stdint.h>
#include "bsp.h"
#include "userDef.h"
#include "spi.h"

/******************************************************************************
*
* @brief This function waits until the SPI flash is not busy.
*
******************************************************************************/
void WaitBusy(void)
{
    u8 out;
    u16 timeout=0;

    while(1)
    {
        bsp_uDelay(1*1000);
        spi_select(SPI, 0);
        //Write Enable
        spi_write(SPI, 0x05);   
        out = spi_read(SPI);
        spi_diselect(SPI, 0);
        if((out & 0x01) ==0x00)
            return;
        timeout++;
        //sector erase max=400ms
        if(timeout >=400)       
        {
            bsp_printf("Time out .. \r\n");
            return;
        }
    }
}

/******************************************************************************
*
* @brief This function enables the write latch of the SPI flash. 
*
******************************************************************************/
void WriteEnableLatch(void)
{
    spi_select(SPI, 0);
    //Write Enable latch
    spi_write(SPI, 0x06);   
    spi_diselect(SPI, 0);
}

/******************************************************************************
*
* @brief This function globally locks the SPI flash.  
*
******************************************************************************/
void GlobalLock(void)
{
    WriteEnableLatch();
    spi_select(SPI, 0);
    //Global lock
    spi_write(SPI, 0x7E);   
    spi_diselect(SPI, 0);
}

/******************************************************************************
*
* @brief This function globally unlocks the SPI flash.  
*
******************************************************************************/
void GlobalUnlock(void)
{
    WriteEnableLatch();
    spi_select(SPI, 0);
    //Global unlock
    spi_write(SPI, 0x98);   
    spi_diselect(SPI, 0);
}

/******************************************************************************
*
* @brief This function erases a sector of the SPI flash given an address. 
*
******************************************************************************/
void SectorErase(u32 Addr)
{
    WriteEnableLatch();
    spi_select(SPI, 0);     
    //Erase Sector
    spi_write(SPI, 0x20);
    spi_write(SPI, (Addr>>16)&0xFF);
    spi_write(SPI, (Addr>>8)&0xFF);
    spi_write(SPI, Addr&0xFF);
    spi_diselect(SPI, 0);
    WaitBusy();
}

/*******************************************************************************
*
* @brief This function initialize the spi configuration setting based on the following
*        parameters. 
*
* @param
* - cpol: Clock polarity (0 or 1).
* - cpha: Clock phase (0 or 1).
* - mode: SPI mode 
*      0: Full-duplex dual line
*      1: Half-duplex dual line
*          (Available only when data width is configured as 8 or 16)
*      2: Half-duplex quad line
*          (Available only when data width is configured as 8 or 16)
*
* - clkDivider: Clock divider value. SPI frequency = FCLK/((clockDivider+1)*2)
*               FCLK is the system clock (io_systemClk) to the SoC. If
*               you enable the peripheral clock, then FCLK is driven by
*               the peripheral clock (io_peripheralClk) instead.
*
* - ssSetup: Slave select setup time. Clock cycle between activated chip-select and first
*            rising-edge of SCLK. Clock cycle refers to FCLK.
*
* - ssHold: Slave select hold time. Clock cycle between last falling-edge and deactivated
*           chip-select is activated. Clock cycle refers to FCLK.
*           
* - ssDisable: Slave select disable time.
*
******************************************************************************/
void spiInit(){
    //SPI init
    Spi_Config spiA;
    spiA.cpol       = 1;
    spiA.cpha       = 1;
    spiA.mode       = 0; 
    spiA.clkDivider = 19;
    spiA.ssSetup    = 5;
    spiA.ssHold     = 5;
    spiA.ssDisable  = 5;
    spi_applyConfig(SPI, &spiA);
}

/******************************************************************************
*
* @brief This main function initializes the SPI interface, selects the SPI device, 
*        writes to SPI flash starting from a specific address and for a specified length.
*
******************************************************************************/

void main() {
    uint8_t id;
    int i,len;
    u8 out;

    bsp_init();
    bsp_printf("***Starting SPI Demo*** \r\n");
    spiInit();
    spi_select(SPI, 0);
    spi_write(SPI, 0xAB);
    spi_write(SPI, 0x00);
    spi_write(SPI, 0x00);
    spi_write(SPI, 0x00);
    id = spi_read(SPI);
    spi_diselect(SPI, 0);
    bsp_printf("Device ID : %x \r\n", id);

       
    bsp_printf("Writing data to flash .. \r\n");
    len=256;
    GlobalUnlock();
    SectorErase(FLASH_START_ADDR);
    WriteEnableLatch();
    spi_select(SPI, 0);
    spi_write(SPI, 0x02);
    spi_write(SPI, (FLASH_START_ADDR>>16) & 0xFF);
    spi_write(SPI, (FLASH_START_ADDR>>8) & 0xFF);
    spi_write(SPI, FLASH_START_ADDR & 0xFF);
    // Write dummy data
    for(i=0; i<len; i++)          
    {
        spi_write(SPI, i & 0xFF);
        bsp_printf("Write address %x := %x \r\n", FLASH_START_ADDR+i, i & 0xFF);
    }
    spi_diselect(SPI, 0);
    // Wait for page writing done
    WaitBusy(); 
    GlobalLock();
   
    bsp_printf("Reading from flash .. \r\n");
    for(i=FLASH_START_ADDR;i< (FLASH_START_ADDR+len) ;i++)
    {
        spi_select(SPI, 0);
        spi_write(SPI, 0x03);
        spi_write(SPI, (i>>16) & 0xFF);
        spi_write(SPI, (i>>8) & 0xFF);
        spi_write(SPI, i & 0xFF);
        out = spi_read(SPI);
        spi_diselect(SPI, 0);
        bsp_printf("Read address %x := %x \r\n", i, out);
    }
    bsp_printf("***Succesfully Ran Demo*** \r\n");
}

