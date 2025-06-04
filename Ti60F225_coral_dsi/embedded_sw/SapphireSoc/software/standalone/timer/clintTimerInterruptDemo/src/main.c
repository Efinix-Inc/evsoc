///////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 2025 SaxonSoc contributors
//  SPDX license identifier: MIT
//  Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
///////////////////////////////////////////////////////////////////////////////////
#include "bsp.h"
#include "userDef.h"
#include "clint.h"
#include "riscv.h"
#include "plic.h"

void crash();
void trap();
void trap_entry();
void timerIsr();
void initTimer();
void scheduleTimer();
void isrInit();
void main();

// Store the next interrupt time
uint64_t timerCmp; 

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
        case CAUSE_MACHINE_TIMER: timerIsr(); break;
        default: crash(); break;
        }
    } else {
        crash();
    }
}

/******************************************************************************
*
* @brief This function handles the timer interrupt event. 
*
******************************************************************************/
void timerIsr(){
    static uint32_t counter = 0;
    scheduleTimer();
    bsp_printf("Entering clint timer interrupt routine .. \r\n");
    bsp_printf("Count:%d .. Done \r\n",counter);
    if(++counter == 59) counter = 0;
}

/******************************************************************************
*
* @brief This function make the timer tick in 1 second.
*
* @note For simulation, the timer tick faster as to avoid having to wait too long. 
*
******************************************************************************/
void scheduleTimer(){
    timerCmp += TIMER_TICK_DELAY;
    clint_setCmp(BSP_CLINT, timerCmp, 0);
}

/******************************************************************************
*
* @brief This function initialize timer.  
*
******************************************************************************/
void initTimer(){
    timerCmp = clint_getTime(BSP_CLINT);
    scheduleTimer();
}
/******************************************************************************
*
* @brief This function initialize timer and enable machine timer interrupts. 
*
******************************************************************************/
void isrInit(){
    // Configure timer
    initTimer();
    // Configure PLIC
    // Cpu 0 accept all interrupts with priority above 0
    plic_set_threshold(BSP_PLIC, BSP_PLIC_CPU_0, 0); 
    // Enable interrupts
    // Set the machine trap vector (../common/trap.S)
    csr_write(mtvec, trap_entry); 
    // Enable machine timer interrupts
    csr_set(mie, MIE_MTIE); 
    csr_write(mstatus, csr_read(mstatus) | MSTATUS_MPP | MSTATUS_MIE);
}

/******************************************************************************
*
* @brief This main function initialize the system and waiting to be interrupted
*        by the core timer.
*
******************************************************************************/
void main() {
    bsp_init();
    bsp_printf("***Starting Clint Timer Interrupt Demo*** \r\n");
    isrInit();
    while(1);
}

