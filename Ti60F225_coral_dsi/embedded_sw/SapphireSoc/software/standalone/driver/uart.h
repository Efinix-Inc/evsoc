///////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 2025 SaxonSoc contributors
//  SPDX license identifier: MIT
//  Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
///////////////////////////////////////////////////////////////////////////////////

/*******************************************************************************
*
* @file UART.h
*
* @brief Header file containing definitions and functions for UART operations.
*
* Functions:
* - uart_write: Writes a single character of data to the UART buffer.
* - uart_writeStr: Writes a null-terminated string to the UART buffer.
* - uart_read: Reads a single character of data from the UART buffer.
* - uart_applyConfig: Applies configuration settings to the UART module.
* - uart_writeHex: Writes the hexadecimal representation of an integer value to the UART buffer.
* - uart_status_read: Reads the status register of the UART module.
* - uart_status_write: Writes data to the status register of the UART module.
* - uart_TX_emptyInterruptEna: Enables or disables the TX empty interrupt for the UART module.
* - uart_RX_NotemptyInterruptEna: Enables or disables the RX not empty interrupt for the UART module.
*
*
******************************************************************************/

#pragma once

#include "type.h"
#include "io.h"

#define UART_DATA           0x00 /* Offset for the UART data register */
#define UART_STATUS         0x04 /* Offset for the UART status register. */
#define UART_CLOCK_DIVIDER  0x08
#define UART_FRAME_CONFIG   0x0C


enum UartDataLength {BITS_8 = 8}; /* Enumerates different data length configurations for UART. */
enum UartParity {NONE = 0,EVEN = 1,ODD = 2};
enum UartStop {ONE = 0,TWO = 1};
/*******************************************************************************
*
* Structure:
*   - Uart_Config: Structure representing UART configuration parameters.
*   - dataLength: Enumerated value indicating the data length configuration.
*   - parity: Enumerated value indicating the parity configuration.
*   - stop: Enumerated value indicating the stop bit configuration.
*   - clockDivider: Clock divider value for UART communication.
*
\******************************************************************************/
    typedef struct {
        enum UartDataLength dataLength;
        enum UartParity parity;
        enum UartStop stop;
        u32 clockDivider;
    } Uart_Config;

/*******************************************************************************
*
* @brief This function checks the availability of space for writing data to the UART buffer.
*
* @param   reg: The base address of the UART registers.
*
* @return  The number of available spaces for writing data to the UART buffer
*          as a 32-bit unsigned integer.
*
* @note    The function reads the UART status register and extracts the number
*          of available spaces for writing data from bits 23 to 16. It then
*          returns this value after masking with 0xFF.
*
******************************************************************************/
    static u32 uart_writeAvailability(u32 reg){
        return (read_u32(reg + UART_STATUS) >> 16) & 0xFF;
    }

/*******************************************************************************
*
* @brief This function checks the occupancy of the UART  buffer for reading data.
*
* @param   reg: The base address of the UART registers.
*
* @return  The number of occupied spaces in the UART buffer for reading data
*          as a 32-bit unsigned integer.
*
* @note    The function reads the UART status register and extracts the number
*          of occupied spaces for reading data from bits 31 to 24.
*
******************************************************************************/
    static u32 uart_readOccupancy(u32 reg){
        return read_u32(reg + UART_STATUS) >> 24;
    }
    
/*******************************************************************************
*
* @brief This function writes a single character of data to the UART buffer.
*
* @param   reg: The base address of the UART registers.
* @param   data: The character data to be written to the UART buffer.
*
* @return  None.
*
* @note    The function waits until there is available space in the UART buffer
*          for writing data. Once space is available, it writes the character
*          data to the UART data register.
*
******************************************************************************/
    static void uart_write(u32 reg, char data){
        while(uart_writeAvailability(reg) == 0);
        write_u32(data, reg + UART_DATA);
    }
    
/*******************************************************************************
*
* @brief This function writes a null-terminated string to the UART buffer.
*
* @param   reg: The base address of the UART registers.
* @param   str: Pointer to the null-terminated string to be written to the UART buffer.
*
* @return  None.
*
* @note    The function iterates through each character of the string and writes
*          them one by one to the UART buffer using the uart_write function.
*
******************************************************************************/
    static void uart_writeStr(u32 reg, const char* str){
        while(*str) uart_write(reg, *str++);
    }

/*******************************************************************************
*
* @brief This function reads a single character of data from the UART buffer.
*
* @param   reg: The base address of the UART registers.
*
* @return  The character read from the UART buffer as a 32-bit unsigned integer
*          (converted to char).
*
* @note    The function waits until there is data available in the UART buffer
*          for reading. Once data is available, it reads the character data from
*          the UART data register and returns it.
*
******************************************************************************/
    static char uart_read(u32 reg){
        while(uart_readOccupancy(reg) == 0);
        return read_u32(reg + UART_DATA);
    }
    
/*******************************************************************************
*
* @brief This function applies the configuration settings to the UART module.
*
* @param   reg: The base address of the UART registers.
* @param   config: Pointer to the Uart_Config structure containing the configuration
*          settings.
*
* @return  None.
*
* @note    The function writes the clock divider value from the configuration structure
*          to the UART clock divider register. It then constructs the frame configuration
*          value using data length, parity, and stop bit settings from the configuration
*          structure, and writes this value to the UART frame configuration register.
*
******************************************************************************/
    static void uart_applyConfig(u32 reg, Uart_Config *config){
        write_u32(config->clockDivider, reg + UART_CLOCK_DIVIDER);
        write_u32(((config->dataLength-1) << 0) | (config->parity << 8) | (config->stop << 16), reg + UART_FRAME_CONFIG);
    }

/*******************************************************************************
*
* @brief This function writes the hexadecimal representation of an integer value to the UART buffer.
*
* @param   reg: The base address of the UART registers.
* @param   value: The integer value to be converted to hexadecimal and written
*          to the UART buffer.
*
* @return  None.
*
* @note    The function iterates through each nibble (4 bits) of the integer value
*          starting from the most significant nibble. It extracts each nibble,
*          converts it to its corresponding hexadecimal character, and writes
*          the character to the UART buffer using the uart_write function.
*
******************************************************************************/
    static void uart_writeHex(u32 reg, int value){
        for(int i = 7; i >= 0; i--){
            int hex = (value >> i*4) & 0xF;
            uart_write(reg, hex > 9 ? 'A' + hex - 10 : '0' + hex);
        }
    }

/*******************************************************************************
*
* @brief This function reads the status register of the UART module.
*
* @param   reg: The base address of the UART registers.
*
* @return  The value read from the UART status register as a 32-bit unsigned integer.
*
* @note    The function reads the value from the UART status register and returns it.
*
******************************************************************************/    
    static u32 uart_status_read(u32 reg)
     {
    	 return read_u32(reg+UART_STATUS);
     }
    
/*******************************************************************************
*
* @brief This function writes data to the status register of the UART module.
*
* @param   reg: The base address of the UART registers.
* @param   data: The data to be written to the UART status register.
*
* @return  None.
*
* @note    The function writes the specified data to the UART status register.
*
******************************************************************************/
    static void uart_status_write(u32 reg, char data)
    {
    	write_u32(data ,reg+UART_STATUS);
    }
    
/*******************************************************************************
*
* @brief This function enables or disables the transmit (TX) empty interrupt for the UART module.
*
* @param   reg: The base address of the UART registers.
* @param   Ena: Flag indicating whether to enable (1) or disable (0) the TX empty interrupt.
*
* @return  None.
*
* @note    The function reads the current value from the UART status register,
*          clears the least significant bit to disable the TX empty interrupt,
*          or sets it to enable the TX empty interrupt based on the provided flag,
*          and then writes the modified value back to the UART status register.
*
******************************************************************************/
    static void uart_TX_emptyInterruptEna(u32 reg, char Ena){
    	uart_status_write(reg,(uart_status_read(reg) & 0xFFFFFFFE) | (Ena & 0x01));	
    }
    
/*******************************************************************************
*
* @brief This function enables or disables the receive (RX) not empty interrupt for the UART module.
*
* @param   reg: The base address of the UART registers.
* @param   Ena: Flag indicating whether to enable (1) or disable (0) the RX not empty interrupt.
*
* @return  None.
*
* @note    The function reads the current value from the UART status register,
*          clears the second least significant bit to disable the RX not empty interrupt,
*          or sets it to enable the RX not empty interrupt based on the provided flag,
*          and then writes the modified value back to the UART status register.
*
******************************************************************************/
    static void uart_RX_NotemptyInterruptEna(u32 reg, char Ena){
    	uart_status_write(reg,(uart_status_read(reg) & 0xFFFFFFFD) | (Ena << 1));	
    }



