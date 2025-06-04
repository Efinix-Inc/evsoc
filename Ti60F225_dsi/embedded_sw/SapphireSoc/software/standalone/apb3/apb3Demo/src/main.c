///////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 2025 SaxonSoc contributors
//  SPDX license identifier: MIT
//  Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
//////////////////////////////////////////////////////////////////////////////////

/******************************************************************************
*
* @file main.c: apb3Demo
*
* @brief This demo shows how to use an APB3 slave peripheral where APB3 slave is 
*        attached to a pseudorandom number generator. When user run the application, 
*        the Sapphire SoC programs the APB3 slave to stop generating a new random
*        number and reads the last random number generated. The test passes if the 
*        returned data is a non-zero value.
*
* @note Please ensure APB3 is enabled in Sapphire Soc. 
*
******************************************************************************/
#include <stdint.h>
#include "bsp.h"
#include "apb3_cl.h"

#ifdef IO_APB_SLAVE_0_INPUT

    #define APB0    IO_APB_SLAVE_0_INPUT

#endif


/*******************************************************************************
*
* @brief This function prints error message on terminal and enters an infinite loop
*         to halt the program's execution.
*
******************************************************************************/
void error_state() {
    bsp_printf("Failed! \r\n");
    while (1) {}
}


/*******************************************************************************
*
* @brief This main function initialize the system and stop APB3 from generating a
*        new random number and read the value from APB3 slave. The result is passed
*        if the return value is non-zero. 
*
******************************************************************************/
void main() {
    struct ctrl_reg cfg0={0};
    u32 data = 0;    

    bsp_init();

#ifdef IO_APB_SLAVE_0_INPUT

    bsp_printf("apb3 slave 0 demo ! \r\n");
    cfg0.lfsr_stop = 1;
    apb3_ctrl_write(APB0, &cfg0);
    data = apb3_read(APB0);
    bsp_printf("Random number: 0x%x \r\n", data);
    if(data == 0x0)
        error_state();
    else
        bsp_printf("Passed! \r\n");

#else

    bsp_printf("apb3 Slave 0 is disabled, please enable it to run this app. \r\n");

#endif

}

