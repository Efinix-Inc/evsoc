////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2025 Efinix Inc. All rights reserved.              
// Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
////////////////////////////////////////////////////////////////////////////////
/******************************************************************************
*
* @file main.c: semihostingDemo
*
* @brief The semihostingDemo illustrates how to leverage semihosting in the
*        Sapphire SoC by printing message through the console. 
*
* @note Please ensure that the ENABLE_SEMIHOSTING_PRINT is set to 1 in the bsp.h header file. 
*       This enables the seamless output of debug messages. All UART printing calls, e.g., 
*       bsp_print, bsp_printf, and other printing APIs, that are available in the bsp.h file 
*       is directed to the console.
*
******************************************************************************/

#include "bsp.h"

/******************************************************************************
*
* @brief This function demonstrates the use of semihosting to print messages
*        and echo back a string entered through the console.
*
******************************************************************************/
void main() {
#if (ENABLE_SEMIHOSTING_PRINT == 1)
    uint8_t dat;
    uint8_t string[100];
    uint8_t counter = 0;

    bsp_init();
    bsp_printf("***Starting Semihosting Demo ***\n\r");
    bsp_printf("You should see this printing in your console .. \n\r");
    bsp_printf("Echo demo. Key in your string and press enter .. \n\r");
    while (1){
        dat=sh_readc();
        if (dat != '\n'){
            string[counter]=dat;
            counter++;
        }
        else {
            string[counter]='\0';
            bsp_printf("Echo string: %s \r\n", string);
            counter = 0;
        }
    }

#else
    #error "Set ENABLE_SEMIHOSTING_PRINT to 1 in bsp.h for the program to work as expected..."
#endif //#if (ENABLE_SEMIHOSTING_PRINT == 1)


}
