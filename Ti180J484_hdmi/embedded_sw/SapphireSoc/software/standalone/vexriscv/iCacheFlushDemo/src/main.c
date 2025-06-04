////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2025 Efinix Inc. All rights reserved.              
// Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
////////////////////////////////////////////////////////////////////////////////

/*******************************************************************************
*
* @file main.c : iCacheFlushDemo
*
* @brief  This demo illustrates how to invalidate the instruction cache. 
*         The instruction cache invalidation is critical to ensure the coherency between the
*         cache and the main memory, ensuring that the CPU fetches the most up-to-date instructions.
*
******************************************************************************/

#include <string.h>
#include "bsp.h"

const char* funcA(){
    return "funcA\r\n";
}

const char* funcB(){
    return "funcB\r\n";
}

uint32_t array[64]  __attribute__ ((aligned (64)));

/*******************************************************************************
*
* @brief This main function demonstrate function pointer behavior after memcpy operations.
*        It uses memcpy to copy functions into an array and checks the behavior of a function pointer.
*
******************************************************************************/
void main() {
    bsp_init();

    bsp_printf("***Starting Flush Instruction Cache Demo*** \r\n");
    
    const char* (*funcPtr)() = (const char* (*)())array;
    bsp_printf("Memcpy funcA into array .. \r\n");
    memcpy(array, funcA, 64*4);
    bsp_printf("Flush the instruction cache once to avoid preloaded data .. \r\n");
    asm("fence.i"); 
    bsp_printf("Expected 'funcA', Obtained : ");
    bsp_printf(funcPtr()); 

    bsp_printf("Memcpy funcB into array .. \r\n");
    memcpy(array, funcB, 64*4);
    bsp_printf("Expected 'funcA', Obtained : ");
    bsp_printf(funcPtr());
    bsp_printf("Still get the FuncA as there is no cache flush .. \r\n");

    bsp_printf("Flush the instruction cache now .. \r\n");
    asm("fence.i"); // flush instruction cache
    bsp_printf("Expected 'funcB', Obtained : ");
    bsp_printf(funcPtr());
    
    bsp_printf("***Successfully Ran Demo*** \r\n");
}
