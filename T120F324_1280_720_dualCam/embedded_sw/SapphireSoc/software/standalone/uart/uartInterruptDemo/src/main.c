////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2025 Efinix Inc. All rights reserved.              
// Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
////////////////////////////////////////////////////////////////////////////////

/******************************************************************************
*
* @file main.c: uartInterruptDemo
*
* @brief This demo shows how to use a UART interrupt to indicate task completion when 
*        sending or receiving data over a UART. The UART can trigger a interrupt when 
*        data is available in the UART receiver FIFO or when the UART transmitter FIFO is
*        empty. 
*
* @note In this example, when user type a character in a UART terminal, the data goes to the
*       UART receiver and fills up FIFO buffer. This action interrupts the processor and forces the
*       processor to execute an interrupt/priority routine that allows the UART to read from the
*       buffer and send a message back to the terminal.
*
******************************************************************************/
#include <stdint.h>
#include "plic.h"
#include "clint.h"
#include "bsp.h"
#include "riscv.h"

void crash();
void trap();
void trap_entry();
void uartIsr();
void isrRoutine();
void isrInit();
void main();

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
* @brief This function handles UART interrupt sub-events such as TX FIFO 
*		 empty interrupt and RX FIFO not empty interrupt.
*
******************************************************************************/
void uartIsr()
{
    if (uart_status_read(BSP_UART_TERMINAL) & 0x00000100){
        
        bsp_printf("\nEntering uart tx fifo empty interrupt routine .. \r\n");
        // Disable TX FIFO empty interrupt 
        uart_status_write(BSP_UART_TERMINAL,uart_status_read(BSP_UART_TERMINAL) & 0xFFFFFFFE);  
        // Enable TX FIFO empty interrupt 
        uart_status_write(BSP_UART_TERMINAL,uart_status_read(BSP_UART_TERMINAL) | 0x01);
        bsp_printf("Done .. \r\n"); 
    }
    else if (uart_status_read(BSP_UART_TERMINAL) & 0x00000200){

        bsp_printf("\nEntering uart rx fifo not empty interrupt routine .. \r\n");
        // Disable RX FIFO not empty interrupt 
        uart_status_write(BSP_UART_TERMINAL,uart_status_read(BSP_UART_TERMINAL) & 0xFFFFFFFD);          
        // Read to clear RX FIFO
        uart_write(BSP_UART_TERMINAL, uart_read(BSP_UART_TERMINAL));    
        // Enable RX FIFO not empty interrupt 
        uart_status_write(BSP_UART_TERMINAL,uart_status_read(BSP_UART_TERMINAL) | 0x02);
        bsp_printf("Done .. \r\n");                    
    }
}

/******************************************************************************
*
* @brief This function handles UART interrupts by claiming pending interrupts 
* 		 and processing them through UartInterrupt_Sub().
*
******************************************************************************/
void isrRoutine()
{
    uint32_t claim;
    // While there is pending interrupts
    while(claim = plic_claim(BSP_PLIC, BSP_PLIC_CPU_0)){
        switch(claim){
        case SYSTEM_PLIC_SYSTEM_UART_0_IO_INTERRUPT: uartIsr(); break;
        default: crash(); break;
        }
        // Unmask the claimed interrupt
        plic_release(BSP_PLIC, BSP_PLIC_CPU_0, claim); 
    }
}

/******************************************************************************
*
* @brief This function initializes UART interrupts and enables external interrupts
*        by setting up the machine trap vector. 
*
******************************************************************************/

void isrInit(){

    // TX FIFO empty interrupt enable
    //uart_TX_emptyInterruptEna(BSP_UART_TERMINAL,1);   
    
    // RX FIFO not empty interrupt enable
    uart_RX_NotemptyInterruptEna(BSP_UART_TERMINAL,1);  

    // Configure PLIC
    // Cpu 0 accept all interrupts with priority above 0
    plic_set_threshold(BSP_PLIC, BSP_PLIC_CPU_0, 0); 

    // Enable SYSTEM_PLIC_USER_INTERRUPT_A_INTERRUPT rising edge interrupt
    plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, SYSTEM_PLIC_SYSTEM_UART_0_IO_INTERRUPT, 1);
    plic_set_priority(BSP_PLIC, SYSTEM_PLIC_SYSTEM_UART_0_IO_INTERRUPT, 1);

    // Enable interrupts
    // Set the machine trap vector (../common/trap.S)
    csr_write(mtvec, trap_entry); 
    // Enable external interrupts
    csr_set(mie, MIE_MEIE); 
    csr_write(mstatus, csr_read(mstatus) | MSTATUS_MPP | MSTATUS_MIE);
}

/******************************************************************************
*
* @brief This function intialize UART configuration and demostrate basic UART 
*        interrupt when user typing on terminal.
*
******************************************************************************/
void main() {
    bsp_init();
    isrInit();

    bsp_printf("***Starting Uart Interrupt Demo*** \r\n");
    bsp_printf("Start typing on terminal to trigger uart RX FIFO not empty interrupt .. \r\n");
    while(1){
        while(uart_readOccupancy(BSP_UART_TERMINAL)){
            uart_write(BSP_UART_TERMINAL, uart_read(BSP_UART_TERMINAL));
        }
    }
}


