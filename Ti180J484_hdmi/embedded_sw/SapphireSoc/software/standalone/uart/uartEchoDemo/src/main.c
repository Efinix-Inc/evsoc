////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2025 Efinix Inc. All rights reserved.              
// Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
////////////////////////////////////////////////////////////////////////////////

/******************************************************************************
*
* @file main.c: uartEchoDemo
*
* @brief This demo shows how to use the UART to print messages on a terminal. 
*        The characters user type on a keyboard are echoed back to the terminal
*        from the SoC and printed on the terminal. 
*
******************************************************************************/

#include "bsp.h"

/******************************************************************************
*
* @brief This function capture the character that user asserted on keyboard and 
*        printed on the terminal. 
*
******************************************************************************/
void main() {
    uint8_t dat;

    bsp_init();
    
    bsp_printf("***Starting Uart Echo Demo*** \r\n");
    bsp_printf("Start typing on terminal to send character... \r\n");
    while(1)
    {
        while(uart_readOccupancy(BSP_UART_TERMINAL)){
            dat=uart_read(BSP_UART_TERMINAL);
            bsp_printf("Echo character: %c \r\n", dat);
        }
    }
}
