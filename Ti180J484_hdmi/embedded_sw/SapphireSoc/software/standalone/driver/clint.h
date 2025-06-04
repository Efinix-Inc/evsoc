///////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 2025 SaxonSoc contributors
//  SPDX license identifier: MIT
//  Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
//////////////////////////////////////////////////////////////////////////////////

/*******************************************************************************
*
* @file clint.h
*
* @brief Header file containing definitions and functions for CLINT operations.
*
*
* Functions:
* - clint_getTimeLow: Retrieves the low 32 bits of the current timer value.
* - clint_getTimeHigh: Retrieves the high 32 bits of the current timer value.
* - clint_setCmp: Sets the compare value for the timer interrupt.
* - clint_getTime: Retrieves the current timer value as a 64-bit unsigned integer.
* - clint_uDelay: Delays execution for a specified number of microseconds.
*
******************************************************************************/

#pragma once

#include "type.h"
#include "io.h"

#define CLINT_IPI_ADDR      0x0000 /*Base address for the inter-processor interrupt registers.*/
#define CLINT_CMP_ADDR      0x4000 /* Timer interrupts related */
#define CLINT_TIME_ADDR     0xBFF8  /* Base address for the timer registers. */

/*******************************************************************************
*
* This usage of the readReg_u32 macro defines two functions for reading 32-bit
* unsigned integer values from the CLINT peripheral registers representing the low 
* and high parts of the current time.
*
* - clint_getTimeLow:
*   - Function name for reading the low part of the current time.
*   - This function reads a 32-bit unsigned integer value from the CLINT
*     TIME register.
*
* - clint_getTimeHigh:
*   - Function name for reading the high part of the current time.
*   - This function reads a 32-bit unsigned integer value from the CLINT
*     TIME register offset by 4 bytes (representing the high part).
*
* @param   CLINT_TIME_ADDR: Base address of the CLINT TIME register.
*
* @return  The 32-bit unsigned integer value read from the specified register.
*
* @note    The readReg_u32 macro is used to define these functions, which internally
*          call the read_u32 function to perform the read operation.
*
******************************************************************************/
    readReg_u32 (clint_getTimeLow , CLINT_TIME_ADDR)
    readReg_u32 (clint_getTimeHigh, CLINT_TIME_ADDR+4)
    
/*******************************************************************************
*
* @brief  This function sets the compare value for the CLINT CMP register for a specific hardware thread.
*
* @param   p is a pointer to the base address of the CLINT CMP register set
*          for the specified hardware thread.
* @param   cmp is the 64-bit compare value to be set in the CMP register.
* @param   hart_id is the ID of the hardware thread for which the compare value
*          is being set.
*
* @return  None.
*
* @note    The function calculates the address offset for the CMP register
*          associated with the specified hardware thread and writes the lower
*          32 bits of the compare value to the lower 32 bits of the CMP register,
*          the upper 32 bits of the compare value to the upper 32 bits of the CMP
*          register, and sets the lower 32 bits to all 1s (0xFFFFFFFF) to ensure the compare
*          value is treated as an absolute value.
*
******************************************************************************/

    static void clint_setCmp(u32 p, u64 cmp, u32 hart_id) {
        p += CLINT_CMP_ADDR + hart_id*8;
        write_u32(0xFFFFFFFF, p + 4);
        write_u32(cmp, p + 0);
        write_u32(cmp >> 32, p + 4);
    }
    
/*******************************************************************************
*
* @brief   This function retrieves the current time from the CLINT TIME register.
*
* @param   p is the base address of the CLINT TIME register.
*
* @return  The 64-bit current time value read from the CLINT TIME register.
*
* @note    The function reads the high and low parts of the time value separately
*          to guard against rollover. It checks if the high part remains unchanged
*          during the read operation to ensure consistency. The high and low parts
*          are then combined to form the 64-bit current time value.
*
******************************************************************************/
    static u64 clint_getTime(u32 p){
        u32 lo, hi;
    
        /* Likewise, must guard against rollover when reading */
        do {
            hi = clint_getTimeHigh(p);
            lo = clint_getTimeLow(p);
        } while (clint_getTimeHigh(p) != hi);
    
        return (((u64)hi) << 32) | lo;
    }
    
/*******************************************************************************
*
* @brief   This function introduces a microsecond delay using the CLINT TIME register.
*
* @param   usec is the delay time in microseconds.
* @param   hz is the frequency of the timer in Hz.
* @param   reg is the base address of the CLINT TIME register.
*
* @return  None.
*
* @note    The function calculates the number of machine cycles per microsecond
*          based on the given timer frequency 'hz'. It then calculates the time
*          limit by adding the delay 'usec' in microseconds to the current time
*          obtained from the CLINT TIME register. The function enters a loop,
*          continuously checking if the difference between the current time
*          and the time limit is non-negative, indicating that the delay has
*          not yet elapsed.
*
******************************************************************************/
    static void clint_uDelay(u32 usec, u32 hz, u32 reg){
        u32 mTimePerUsec = hz/1000000;
        u32 limit = clint_getTimeLow(reg) + usec*mTimePerUsec;
        while((int32_t)(limit-(clint_getTimeLow(reg))) >= 0);
    }