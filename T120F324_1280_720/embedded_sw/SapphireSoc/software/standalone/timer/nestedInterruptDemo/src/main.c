///////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 2025 SaxonSoc contributors
//  SPDX license identifier: MIT
//  Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
///////////////////////////////////////////////////////////////////////////////////

/******************************************************************************
*
* @file main.c: nestedInterruptDemo
*
* @brief   This demo illustrates how to escalate from an interrupt routine and to execute 
*          higher priority routine. The program returns to the lower priority routine after 
*          the higher priority routine finished executing. 
*
* @note    This demo instantiates two user timers; timer 0 has higher priority than timer 1. 
*          Timer 0 interrupts the CPU multiple times. The CPU then executes the timer 0 
*          interrupt routine in the middle of executing the timer 1 interrupt routine.
*
******************************************************************************/

#include <stdint.h>
#include "bsp.h"
#include "userDef.h"
#include "prescaler.h"
#include "timer.h"
#include "riscv.h"
#include "plic.h"

#if defined(SYSTEM_USER_TIMER_0_CTRL) && defined(SYSTEM_USER_TIMER_1_CTRL)
void trap();
void crash();
void trap_entry();
void isrRoutine();
void initTimer();
void isrInit();
void main();

/******************************************************************************
*
* @brief This function handles the system crash scenario by printing a crash message
* 		 and entering an infinite loop.
*
******************************************************************************/

void crash(){
    bsp_printf("\r\n*** CRASH ***\r\n");
    while(1);
}


/******************************************************************************
*
* @brief This function handles exceptions and interrupts in the system.
*
* @note It is called by the trap_entry function on both exceptions and interrupts 
* 		events. If the cause of the trap is an interrupt, it checks the cause of 
* 		the interrupt and calls corresponding interrupt handler functions. If 
* 		the cause is an exception or an unhandled interrupt, it calls a 
*		crash function to handle the error.
*
******************************************************************************/
void trap(){
    int32_t mcause = csr_read(mcause);
    // Interrupt if true, exception if false
    int32_t interrupt = mcause < 0;    
    int32_t cause     = mcause & 0xF;
    if(interrupt){
        switch(cause){
        case CAUSE_MACHINE_EXTERNAL: isrRoutine(); break;
        default: crash(); break;
        }
    } else {
        crash();
    }
}

/******************************************************************************
*
* @brief This function handles external interrupts. It checks for pending
*        interrupts and processes them accordingly. If an interrupt from
*        user timer 0/1 are detected, it prints a message indicating the interrupt
*        source. If an interrupt from an unknown source is detected, it 
*        calls a crash function to handle the error.
*
******************************************************************************/
void isrRoutine(){
    uint32_t claim;

    // Save the Machine Exception Programme Counter to be able to restore it in case a higher priority interrupt happen
    u32 epc = csr_read(mepc);                                     
    // Save it to restore it later
    u32 threshold = plic_get_threshold(BSP_PLIC, BSP_PLIC_CPU_0); 

    // While there is pending interrupts
    while(claim = plic_claim(BSP_PLIC, BSP_PLIC_CPU_0)){
        // Identify which priority level the current claimed interrupt is
        u32 priority = plic_get_priority(BSP_PLIC, claim);            
        // Enable only the interrupts which higher priority than the currently claimed one.
        plic_set_threshold(BSP_PLIC, BSP_PLIC_CPU_0, priority);       
        // Enable machine external interrupts
        csr_set(mstatus, MSTATUS_MIE);                                
        switch(claim){
        case SYSTEM_PLIC_TIMER_INTERRUPTS_0: {
            bsp_printf("T0S-HP\r\n");
            bsp_printf("T0E-HP\r\n");
        }  break;
        case SYSTEM_PLIC_TIMER_INTERRUPTS_1: {
            bsp_printf("T1S\r\n");
            // User delay
            for(int i = 0;i < 1200000;i++) asm("nop"); 
            bsp_printf("T1E\r\n");
            // That timer wasn't configured with self restart, require to do it manually.
            timer_clearValue(TIMER_1_CTRL); 
        } break;
        default: crash(); break;
        }
        // disable machine external interrupts
        csr_clear(mstatus, MSTATUS_MIE);                              
        // Restore the original threshold level
        plic_set_threshold(BSP_PLIC, BSP_PLIC_CPU_0, threshold); 
        plic_release(BSP_PLIC, BSP_PLIC_CPU_0, claim); //unmask the claimed interrupt
    }
    //Restore the mepc, in case it was overwritten by a nested interrupt
    csr_write(mepc, epc); 
}

/******************************************************************************
*
* @brief This function initializes Timer 0 and Timer 1. It configures the 
*        prescaler values, sets the timer configuration with the prescaler, 
*        sets the timer limits, and enables self-restart for Timer 0.
*
******************************************************************************/
void initTimer(){
    // Divide clock rate by 399+1
    prescaler_setValue(TIMER_0_PRESCALER_CTRL, 399); 
    // Will tick each (9999+1)*(399+1) cycles (as it use the prescaler)
    timer_setLimit(TIMER_0_CTRL, 3999);
    timer_setConfig(TIMER_0_CTRL, TIMER_CONFIG_WITH_PRESCALER | TIMER_CONFIG_SELF_RESTART); 
    // Will tick each (3999+1)*(999+1) cycles (as it use the prescaler)
    prescaler_setValue(TIMER_1_PRESCALER_CTRL, 999); 
    timer_setLimit(TIMER_1_CTRL, 3999);
    timer_setConfig(TIMER_1_CTRL, TIMER_CONFIG_WITH_PRESCALER); 
}

/******************************************************************************
*
* @brief This function configures the timer, enables Timer 0 & 1 external interrupts
*        by setting up the machine trap vector. 
*
******************************************************************************/

void isrInit(){
    // Configure timer
    initTimer();
    // Configure PLIC
    // Cpu 0 accept all interrupts with priority above 0
    plic_set_threshold(BSP_PLIC, BSP_PLIC_CPU_0, 0); 
    // Enable Timer 0 interrupts
    // Priority 2 win against priority 1
    plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, SYSTEM_PLIC_TIMER_INTERRUPTS_0, 1);
    plic_set_priority(BSP_PLIC, SYSTEM_PLIC_TIMER_INTERRUPTS_0, 2);  
    // Enable Timer 1 interrupts
    plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, SYSTEM_PLIC_TIMER_INTERRUPTS_1, 1);
    plic_set_priority(BSP_PLIC, SYSTEM_PLIC_TIMER_INTERRUPTS_1, 1);
    // Enable interrupts
    // Set the machine trap vector (../common/trap.S)
    csr_write(mtvec, trap_entry); 
    // Enable external interrupts only
    csr_set(mie, MIE_MEIE); 
    csr_write(mstatus, csr_read(mstatus) | MSTATUS_MPP | MSTATUS_MIE);
}

/******************************************************************************
*
* @brief This main function initializes interrupts, and then enters an infinite
*        loop to demonstrate nested interrupts.       
*
******************************************************************************/
void main() {
    bsp_init();
    bsp_printf("***Starting Nested Interrupt Demo*** \r\n");
    isrInit();
    while(1); 
}
#else
void trap(){
}

/******************************************************************************
*
* @brief This main function is executed when user timer functionality is disabled.
*        It initializes the BSP and prints a message indicating that
*        user timer 0 & 1 are disabled, and the user should enable it to run the app.
*
******************************************************************************/
void main() {
    bsp_init();
    bsp_printf("This demo requires user timer 0 and user timer 1, please enable them to run this app \r\n");
}
#endif
