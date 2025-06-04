//////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 2025 SaxonSoc contributors
//  SPDX license identifier: MIT
//  Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
///////////////////////////////////////////////////////////////////////////////////
#include "bsp.h"
#include "userDef.h"
#include "prescaler.h"
#include "timer.h"
#include "riscv.h"
#include "plic.h"
#ifdef SYSTEM_USER_TIMER_0_CTRL 
void crash();
void trap();
void trap_entry();
void timerIsr();
void isrRoutine();
void initTimer();
void isrInit();
void main();

//Store the count of interrupt happened
u32 count;

/******************************************************************************
*
* @brief This function handles the system crash scenario by printing a crash 
* 		 message and entering an infinite loop.
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
* @brief This function will keep on counting once enter interrupt routine.
*
******************************************************************************/
void timerIsr(){
    bsp_printf("Entering timer 0 interrupt routine .. \r\n");
    count++;
    bsp_printf("Count:%d .. Done \r\n",count);
}

/******************************************************************************
*
* @brief This function handles user timer interrupt by claiming pending interrupts 
* 		 and print message on terminal regarding the interrupt routine. 
*
******************************************************************************/
void isrRoutine(){
    uint32_t claim;
    // While there is pending interrupts
    while(claim = plic_claim(BSP_PLIC, BSP_PLIC_CPU_0)){
        switch(claim){
        case SYSTEM_PLIC_TIMER_INTERRUPTS_0:  timerIsr(); break;
        default: crash(); break;
        }
        // Unmask the claimed interrupt
        plic_release(BSP_PLIC, BSP_PLIC_CPU_0, claim); 
    }
}

/******************************************************************************
*
* @brief This function initializes user timer by setting up the prescaler value. 
*
******************************************************************************/

void initTimer(){
    // Divide clock rate by 1999+1
    prescaler_setValue(TIMER_PRESCALER_CTRL, 1999); 
    // Will tick each (19999+1)*(1999+1) cycles (as it use the prescaler)
    timer_setLimit(TIMER_0_CTRL, 19999);
    timer_setConfig(TIMER_0_CTRL, TIMER_CONFIG_WITH_PRESCALER | TIMER_CONFIG_SELF_RESTART); 
}

/******************************************************************************
*
* @brief This function initializes user timer interrupts and enables external interrupts
*        by setting up the machine trap vector. 
*
******************************************************************************/
void isrInit(){
    // Configure timer
    initTimer();
    // Configure PLIC
    // Cpu 0 accept all interrupts with priority above 0
    plic_set_threshold(BSP_PLIC, BSP_PLIC_CPU_0, 0); 
    // Enable Timer 0 interrupt
    plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, SYSTEM_PLIC_TIMER_INTERRUPTS_0, 1);
    plic_set_priority(BSP_PLIC, SYSTEM_PLIC_TIMER_INTERRUPTS_0, 1);
    // Enable interrupt
    csr_write(mtvec, trap_entry); //Set the machine trap vector (../common/trap.S)
    csr_set(mie, MIE_MEIE); //Enable machine timer and external interrupts
    csr_write(mstatus, csr_read(mstatus) | MSTATUS_MPP | MSTATUS_MIE);
}

/******************************************************************************
*
* @brief This main function intialize the system and then prints a message 
*        indicating that the user timer 0 demo is starting.
*
******************************************************************************/
void main() {
    bsp_init();
    bsp_printf("***Starting User Timer Interrupt Demo*** \r\n");
    isrInit();
    while(1); 
}

#else
void trap(){
}

/******************************************************************************
*
* @brief This main function is executed when I2C functionality is disabled.
*        It initializes the BSP and prints a message indicating that
*        I2C 0 is disabled, and the user should enable it to run the app.
*
******************************************************************************/
void main() {
    bsp_init();
    bsp_printf("User timer 0 is disabled, please enable it to run this app \r\n");
}
#endif

