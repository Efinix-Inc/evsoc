///////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 2025 SaxonSoc contributors
//  SPDX license identifier: MIT
//  Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
///////////////////////////////////////////////////////////////////////////////////

/*******************************************************************************
 *
 * @file spi.h
 *
 * @brief Header file containing SPI function declarations and configuration structures
 *
 * Functions:
 * - spi_write32: Writes a 32-bit data value to the SPI write register
 * - spi_writeRead32: Writes a 32-bit data value to the SPI write register and reads a 32-bit value
 * - spi_read32: Reads a 32-bit data value from the SPI read register
 * - spi_select: Selects a slave device on the SPI bus
 * - spi_diselect: Deselects a slave device on the SPI bus
 * - spi_applyConfig: Applies SPI configuration settings
 * - spi_waitXferBusy: Wait for SPI Transfer to complete.
 * - spiReadStatusRegister: Read Status Register.
 * - spiWriteStatusRegister: Write Status Register.
 * - spiWriteEnable: Set Write Enable Latch.
 *
 ******************************************************************************/
#pragma once

#include "type.h"
#include "io.h"

#define SPI_DATA             0x00
#define SPI_BUFFER           0x04
#define SPI_CONFIG           0x08
#define SPI_INTERRUPT        0x0C
#define SPI_CLK_DIVIDER      0x20
#define SPI_SS_SETUP         0x24
#define SPI_SS_HOLD          0x28
#define SPI_SS_DISABLE       0x2C
#define SPI_WRITE_LARGE      0x50
#define SPI_READ_WRITE_LARGE 0x54
#define SPI_READ_LARGE       0x58
#define SPI_CMD_WRITE   (1 << 8)
#define SPI_CMD_READ    (1 << 9)
#define SPI_CMD_SS      (1 << 11)
#define SPI_RSP_VALID   (1 << 31)
#define SPI_STATUS_CMD_INT_ENABLE = (1 << 0)
#define SPI_STATUS_RSP_INT_ENABLE = (1 << 1)
#define SPI_STATUS_CMD_INT_FLAG = (1 << 8)
#define SPI_STATUS_RSP_INT_FLAG = (1 << 9)
#define SPI_MODE_CPOL   (1 << 0)
#define SPI_MODE_CPHA   (1 << 1)

/*******************************************************************************
 *
 * @brief Structure for SPI configuration settings.
 *
 * This structure defines the configuration settings for the SPI interface.
 * Members:
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

    typedef struct {
        u32 cpol;
        u32 cpha;
        u32 mode;
        u32 clkDivider;
        u32 ssSetup;
        u32 ssHold;
        u32 ssDisable;
    } Spi_Config;
    
/*******************************************************************************
 *
 * @brief This function returns the availability of command buffer space in the SPI buffer
 *
 * @param reg The base address of the SPI register
 *
 * @return The availability of command buffer space (lower 16 bits of SPI buffer)
 *
 ******************************************************************************/
    static u32 spi_cmdAvailability(u32 reg){
        return read_u32(reg + SPI_BUFFER) & 0xFFFF;
    }

/*******************************************************************************
 *
 * @brief This function returns the occupancy of response buffer space in the SPI buffer
 *
 * @param reg The base address of the SPI register
 *
 * @return The occupancy of response buffer space (upper 16 bits of SPI buffer)
 *
 ******************************************************************************/
    static u32 spi_rspOccupancy(u32 reg){
        return read_u32(reg + SPI_BUFFER) >> 16;
    }
    
/*******************************************************************************
 *
 * @brief This function writes data to the SPI data register after checking the
 *        availability of command buffer space.
 *
 * @param reg The base address of the SPI register
 *
 * @param data The data to be written
 *
 ******************************************************************************/
    static void spi_write(u32 reg, u8 data){
        while(spi_cmdAvailability(reg) == 0);
        write_u32(data | SPI_CMD_WRITE, reg + SPI_DATA);
    }
    
/*******************************************************************************
 *
 * @brief This function reads data from the SPI data register after checking the
 *        availability of command buffer space and the occupancy of response buffer space.
 *
 * @param reg The base address of the SPI register
 *
 * @return The data read from the SPI data register
 *
 ******************************************************************************/   
    static u8 spi_read(u32 reg){
        while(spi_cmdAvailability(reg) == 0);
        write_u32(SPI_CMD_READ, reg + SPI_DATA);
        while(spi_rspOccupancy(reg) == 0);
        return read_u32(reg + SPI_DATA);
    }
    
/*******************************************************************************
 *
 * @brief This function writes data to and reads data from the SPI data register.
 *
 * @param reg The base address of the SPI register
 * @param data The data to be written
 *
 * @return The data read from the SPI data register
 *
 ******************************************************************************/  
    static u8 spi_writeRead(u32 reg, u8 data){
        while(spi_cmdAvailability(reg) == 0);
        write_u32(data | SPI_CMD_READ | SPI_CMD_WRITE, reg + SPI_DATA);
        while(spi_rspOccupancy(reg) == 0);
        return read_u32(reg + SPI_DATA);
    }

/*******************************************************************************
 *
 * @brief This function writes a 32-bit data value to the SPI write register 
 *        after checking the availability of command buffer space.
 *
 * @param reg The base address of the SPI register
 * @param data The 32-bit data value to be written
 *
 ******************************************************************************/
    static void spi_write32(u32 reg, u32 data){
        while(spi_cmdAvailability(reg) == 0);
        write_u32(data, reg + SPI_WRITE_LARGE);
    }
    
/*******************************************************************************
 *
 * @brief This function writes a 32-bit data value to the SPI write register 
 *        and reads a 32-bit value from the SPI read register.
 *
 * @param reg The base address of the SPI register
 * @param data The 32-bit data value to be written
 *
 * @return The 32-bit value read from the SPI read register
 *
 ******************************************************************************/    
    static u32 spi_writeRead32(u32 reg, u32 data){
        while(spi_cmdAvailability(reg) == 0);
        write_u32(data, reg + SPI_READ_WRITE_LARGE);
        while(spi_rspOccupancy(reg) == 0);
        return read_u32(reg + SPI_READ_LARGE);
    }
    
/*******************************************************************************
 *
 * @brief This function reads a 32-bit data value from the SPI read register.
 *
 * @param reg The base address of the SPI register
 *
 * @return The 32-bit data value read from the SPI read register
 *
 ******************************************************************************/
    static u32 spi_read32(u32 reg){
        while(spi_cmdAvailability(reg) == 0);
        write_u32(SPI_CMD_READ, reg + SPI_DATA);
        while(spi_rspOccupancy(reg) == 0);
        return read_u32(reg + SPI_READ_LARGE);
    }
    
/*******************************************************************************
 *
 * @brief This function selects a slave device on the SPI bus .
 *
 * @param reg The base address of the SPI register
 * @param slaveId The ID of the slave device to select
 *
 ******************************************************************************/
    static void spi_select(u32 reg, u32 slaveId){
        while(spi_cmdAvailability(reg) == 0);
        write_u32(slaveId | 0x80 | SPI_CMD_SS, reg + SPI_DATA);
    }
    
/*******************************************************************************
 *
 * @brief This function deselects a slave device on the SPI bus.
 *
 * @param reg The base address of the SPI register
 * @param slaveId The ID of the slave device to deselect
 *
 ******************************************************************************/  
    static void spi_diselect(u32 reg, u32 slaveId){
        while(spi_cmdAvailability(reg) == 0);
        write_u32(slaveId | 0x00 | SPI_CMD_SS, reg + SPI_DATA);
    }
    
/*******************************************************************************
 *
 * @brief This function applies SPI configuration settings to the SPI configuration register,
 *        clock divider register, slave setup register, hold register, and disable register.
 *
 * @param reg The base address of the SPI register
 * @param config Pointer to a Spi_Config structure containing the configuration settings
 *
 ******************************************************************************/
    static void spi_applyConfig(u32 reg, Spi_Config *config){
        write_u32((config->cpol << 0) | (config->cpha << 1) | (config->mode << 4), reg + SPI_CONFIG);
        write_u32(config->clkDivider, reg + SPI_CLK_DIVIDER);
        write_u32(config->ssSetup, reg + SPI_SS_SETUP);
        write_u32(config->ssHold, reg + SPI_SS_HOLD);
        write_u32(config->ssDisable, reg + SPI_SS_DISABLE);
    }
    
/*******************************************************************************
*
* @brief This function wait for SPI Transfer to complete.
    * 
    * @param reg SPI base address 
*
******************************************************************************/
    static void spi_waitXferBusy(u32 reg){
    	bsp_uDelay(1);
    	while(spi_cmdAvailability(reg) != 256);
    }

