////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2025 Efinix Inc. All rights reserved.              
// Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
////////////////////////////////////////////////////////////////////////////////

/******************************************************************************
*
* @file main.c: dCacheFlushDemo
*
* @brief  This demo shows how to invalidate the data cache. 
*
* @note   The data cache invalidation is critical to ensure the coherency between the cache
*         and the main memory, ensuring that the CPU fetches the most up-to-date data.
*         In the example, a value of 0xaa550000 is directly written into the memory using 
*         a pointer at address 0x00100000. The data increments by 1 for each address increment of 4. 
*         The writing process continues until address 0x0010001C. Next, the data is overwritten 
*         by the memory_checker module, triggered by the apb3 module. The overwritten data 
*         ranges from 0xaa001100 to 0xaa001107. When printing the data from addresses 0x00100000 
*         to 0x0010001C, it can be observed that the data remains unchanged. This is because the 
*         data is still being fetched from the cache memory and not from the main memory. 
*         To address this, the data cache invalidation is performed before reading the data
*         again. This ensures that the data is updated.
*         Please ensure ABP3 and DDR is enabled in Sapphire Soc to run this app. 
*
******************************************************************************/
#include "bsp.h"
#include "vexriscv.h"

#define LOC_EXT_MEM ((volatile uint32_t*)0x00100000)
#define NUM 8

void main() 
{
    bsp_init();
    bsp_printf("***Starting Invalidate Data Cache Demo*** \r\n");

    bsp_printf("Invalidate 3 cache lines .. \r\n");
    for(int j=0; j<NUM; j++){
        data_cache_invalidate_address(LOC_EXT_MEM+j);
    }
    bsp_printf("Invalidate all cache line .. \r\n");
    data_cache_invalidate_all();
    
    bsp_printf("***Succesfully Ran Demo*** \r\n");
}


