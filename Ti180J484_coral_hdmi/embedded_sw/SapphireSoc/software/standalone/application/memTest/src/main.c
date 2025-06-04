///////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 2025 SaxonSoc contributors
//  SPDX license identifier: MIT
//  Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
///////////////////////////////////////////////////////////////////////////////////

/******************************************************************************
*
* @file main.c: memTest
*
* @brief  This demo performs memory test on the external memory module and reports
*         the results on a UART terminal. 
*
******************************************************************************/

#include <stdint.h>
#include "bsp.h"
#include "userDef.h"

/******************************************************************************
*
* @brief  This main function performs a memory test by writing ascending values 
*         to a memory array and then reading and checking each value. 
*         If a mismatch is found between the expected and read values, 
*         it prints an error message and enters an infinite loop.
*
******************************************************************************/
void main() {

    bsp_printf("***Starting Memory Test*** \r\n");
    for(int i=0; i<MAX_WORDS; i++) MEM_LOC[i] = i;

    for(int i=0; i<MAX_WORDS; i++) {
        if (MEM_LOC[i] != i) {
        bsp_printf("Data mismatched at address 0x%x with value of 0x%x \r\n", i, MEM_LOC[i]);
        while(1){
            }
        }
    }
    bsp_printf("Data matched .. Test PASSED\r\n");
    bsp_printf("***Succesfully Ran Demo*** \r\n");
}

