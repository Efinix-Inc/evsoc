////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2025 Efinix Inc. All rights reserved.              
// Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
////////////////////////////////////////////////////////////////////////////////

/******************************************************************************
*
* @file main.c: Floating-Point Unit Arithmetic Demo
*
* @brief This demo performs various floating-point arithmetic operations and 
*        measures the processing time for each operation. It also checks if 
*        the Floating Point Unit (FPU) is enabled and provides information 
*        accordingly.
*
******************************************************************************/

#include <stdlib.h>
#include <stdint.h>
#include "bsp.h"
#include "riscv.h"
#include "clint.h"
#include <math.h>


/*******************************************************************************
*
* @brief This function print processing time between two timestamps
*
* @param ts1 First timestamp.
* @param ts2 Second timestamp.
* @param s Character  
*
******************************************************************************/
void printPTime(uint64_t ts1, uint64_t ts2, char *s) {
    uint64_t rts;
    rts=ts2-ts1;
    bsp_printf("%s %d \n\n\r",s, rts );
}


/******************************************************************************
*
* @brief This main function demonstrates various floating-point calculations using
*        the FPU (Floating Point Unit). Additionally, it measures the clock cycles
*        taken for each calculation and prints the results along with the 
*        processing times.
*
******************************************************************************/
void main() {
    double inp1,
           inp2,
           rSin,
           rCos,
           rTan,
           rSqrt,
           rDiv;    
    uint64_t timerCmp0, timerCmp1;
    bsp_init();
    bsp_printf("***Starting FPU Demo*** \r\n");
#if (SYSTEM_CORES_0_FPU == 0) // If FPU extension is disabled in SOC
    bsp_printf("FPU is disabled, more processing time required for following calculation \r\n");
    bsp_printf("FPU is disabled, please expect bigger size compiled binary \r\n");
#endif

    /* Calculation */
    inp1=-0.8414709848078965;   
    timerCmp0 = clint_getTime(BSP_CLINT);   
    rSin=sin(inp1);
    timerCmp1 = clint_getTime(BSP_CLINT);
    printPTime(timerCmp0,timerCmp1,"Sine processing clock cycles:");
    timerCmp0 = clint_getTime(BSP_CLINT); 
    rCos=cos(inp1);
    timerCmp1 = clint_getTime(BSP_CLINT);
    printPTime(timerCmp0,timerCmp1,"Cosine processing clock cycles:");
    timerCmp0 = clint_getTime(BSP_CLINT); 
    rTan=tan(inp1);
    timerCmp1 = clint_getTime(BSP_CLINT);
    printPTime(timerCmp0,timerCmp1,"Tangent processing clock cycles:");   

    
    inp2=0.4161468365471424;
    timerCmp0 = clint_getTime(BSP_CLINT); 
    rSqrt=sqrt(inp2);
    timerCmp1 = clint_getTime(BSP_CLINT);
    printPTime(timerCmp0,timerCmp1,"Square root processing clock cycles:");
    timerCmp0 = clint_getTime(BSP_CLINT);
    rDiv=inp2/3.6789;
    timerCmp1 = clint_getTime(BSP_CLINT);
    printPTime(timerCmp0,timerCmp1,"Division processing clock cycles:");


    bsp_printf("\r\n");
    bsp_printf("Input 1 (in rad): %f \r\n", inp1);
    bsp_printf("Sine result: %f \r\n", rSin);
    bsp_printf("Cosine result: %f \r\n", rCos);
    bsp_printf("Tangent result: %f \r\n", rTan);
    bsp_printf("Input 2: %f \r\n", inp2);
    bsp_printf("Square root result: %f \r\n", rSqrt);
    bsp_printf("Divsion result: %f \r\n", rDiv);

    bsp_printf("***Succesfully Ran Demo*** \r\n");
}
