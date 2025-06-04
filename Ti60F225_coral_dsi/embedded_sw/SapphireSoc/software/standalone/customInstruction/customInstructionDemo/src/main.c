////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2025 Efinix Inc. All rights reserved.              
// Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
////////////////////////////////////////////////////////////////////////////////

/******************************************************************************
*
* @file main.c: customInstructionDemo
*
* @brief  This demo shows how to use a custom instruction to accelerate the processing 
*         time of an algorithm. It demonstrates how performing an algorithm
*         in hardware can provide significant acceleration vs, using software only. 
*         This demo uses the Tiny encryption algorithm to encrypt two 32-bit unsigned 
*         integers with a 128-bit key. The encryption is 1,024 cycles.
*
* @note   Please ensure that the custom instruction is enabled in Sapphire Soc. 
*
******************************************************************************/
#include <stdint.h>
#include <stdlib.h>
#include "bsp.h"
#include "userDef.h"
#include "riscv.h"


/*******************************************************************************
 *
 * @brief This function perform a TEA (Tiny Encryption Algorithm) operation on two 32-bit words.
 *
 * @param v0 The first 32-bit word
 * @param v1 The second 32-bit word
 * @param rv0 Pointer to store the result of v0 after encryption
 * @param rv1 Pointer to store the result of v1 after encryption
 *
 ******************************************************************************/

void software_tinyEncrypt (uint32_t v0, uint32_t v1, uint32_t *rv0, uint32_t *rv1) {
    uint32_t sum=0, i;

    uint32_t delta=0x9e3779b9;

    uint32_t k0=0x01234567,
             k1=0x89abcdef,
             k2=0x13579248,
             k3=0x248a0135;

    for (i=0; i < 1024; i++) {
        sum += delta;
        v0 += ((v1<<4) + k0) ^ (v1 + sum) ^ ((v1>>5) + k1);
        v1 += ((v0<<4) + k2) ^ (v0 + sum) ^ ((v0>>5) + k3);

    }
    *rv0=v0;
    *rv1=v1;
}

/*******************************************************************************
*
* @brief This function prints error message on terminal and enters an infinite loop
*         to halt the program's execution.
*
******************************************************************************/
void error_state() {
    bsp_printf("Custom instruction and software output results are not matched .. \r\n");
    while (1) {}
}

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
    bsp_printf("%s %d \n\n\r", s, rts);

}

/*******************************************************************************
*
* @brief This main function initializes variables, performs custom instruction 
*        TEA encryption, software TEA encryption, and compares the results in
*        terms of the processing time. 
*
 ******************************************************************************/
void main() {
    uint32_t num1, num2;
    uint64_t timerCmp0, timerCmp1;
    uint32_t result_ci0,result_ci1,result_s0,result_s1;

    num1=0x84425820;
    num2=0xdeadbe11;

    bsp_init();
#if (SYSTEM_CORES_0_CFU == 1)
    bsp_printf("***Starting Custom Instruction Demo*** \r\n");
    timerCmp0 = clint_getTime(BSP_CLINT);
    result_ci0=tinyEncryption_lowerword(num1,num2);
    result_ci1=tinyEncryption_upperword(0x0, 0x0);
    timerCmp1 = clint_getTime(BSP_CLINT);
    bsp_printf("Custom instruction method");
    printPTime(timerCmp0,timerCmp1," processing clock cycles:");

    timerCmp0 = clint_getTime(BSP_CLINT);
    software_tinyEncrypt(num1, num2, &result_s0, &result_s1);
    timerCmp1 = clint_getTime(BSP_CLINT);
    bsp_printf("Software method");
    printPTime(timerCmp0,timerCmp1," processing clock cycles:");

    if(result_ci0 != result_s0 || result_ci1 != result_s1) {
        error_state();
    } else {
        bsp_printf("Custom instruction and software output results are matched .. \r\n");
    }

    bsp_printf("***Succesfully Ran Demo*** \r\n");
#else
        bsp_printf("Custom instruction plugin is disabled, please enable it to run this app \r\n");
#endif 

}
