///////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 2025 SaxonSoc contributors
//  SPDX license identifier: MIT
//  Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
//////////////////////////////////////////////////////////////////////////////////

/******************************************************************************
*
* @file main.c: axi4Demo
*
* @brief This demo performs a write and read test for the internal BRAM that is attached 
*        to an AXI interface. First, the software writes to the internal BRAM through
*        the AXI interface. Next, it reads back the data and compares it to the expected 
*        value. If the data is correct, the software writes "Passed" to a UART terminal
*        The AXI bus interrupt pin triggers a software interrupt when write data 
*        to the AXI bus is 0xABCD. 
*
* @note Please ensure the AXI4 Slave is enabled in Sapphire Soc.
*
******************************************************************************/

#include <stdint.h>
#include "bsp.h"
#include "riscv.h"
#include "plic.h"

#ifdef SYSTEM_AXI_A_BMB

    #define AXI SYSTEM_AXI_A_BMB
    #define AXI_SIZE 2048

#endif

void main();
void error_state();
void intr_init();
void trap();
void crash();
void trap_entry();
void axiInterrupt();

/*******************************************************************************
*
* @brief This function prints error message on terminal and enters an infinite loop
*         to halt the program's execution.
*
******************************************************************************/
void error_state() {
    bsp_printf("Failed! \r\n");
    while (1) {}
}

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
* @brief This function initialize axi interrupt and set the machine trap 
*        vector.
*
******************************************************************************/
void intr_init(){
    //configure PLIC
    //cpu 0 accept all interrupts with priority above 0
    plic_set_threshold(BSP_PLIC, BSP_PLIC_CPU_0, 0); 
    //enable SYSTEM_PLIC_USER_INTERRUPT_A_INTERRUPT rising edge interrupt
#ifdef SYSTEM_AXI_A_BMB

    plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, SYSTEM_PLIC_SYSTEM_AXI_A_INTERRUPT, 1);
    plic_set_priority(BSP_PLIC, SYSTEM_PLIC_SYSTEM_AXI_A_INTERRUPT, 1);

#endif  
    //enable interrupts
    //Set the machine trap vector (../common/trap.S)
    csr_write(mtvec, trap_entry); 
    //Enable external interrupts
    csr_set(mie, MIE_MEIE); 
    csr_write(mstatus, csr_read(mstatus) | MSTATUS_MPP | MSTATUS_MIE);
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
    int32_t mcause    = csr_read(mcause);
    //Interrupt if true, exception if false
    int32_t interrupt = mcause < 0;    
    int32_t cause     = mcause & 0xF;
    if(interrupt){
        switch(cause){
        case CAUSE_MACHINE_EXTERNAL: axiInterrupt(); break;
        default: crash(); break;
        }
    } else {
        crash();
    }
}

/******************************************************************************
*
* @brief This function handles AXI interrupts by claiming pending interrupts 
* 		 and print the message regarding the claimed interrupt. 
*
******************************************************************************/
void axiInterrupt(){

    uint32_t claim;
    //While there is pending interrupts
    while(claim = plic_claim(BSP_PLIC, BSP_PLIC_CPU_0)){
        switch(claim){
#ifdef SYSTEM_AXI_A_BMB

        case SYSTEM_PLIC_SYSTEM_AXI_A_INTERRUPT:
            bsp_printf("Entered AXI Interrupt Routine, Passed! \r\n");
            break;

#endif
        default: crash(); break;
        }
        //unmask the claimed interrupt
        plic_release(BSP_PLIC, BSP_PLIC_CPU_0, claim); 
    }
}


/******************************************************************************
*
* @brief This function perform write/read test for the internal BRAM and 
*        AXI4 slave interrupt is triggered when the data written to AXI bus is 
*        0xABCD. 
*
******************************************************************************/
void main() {
    u32 data;
    bsp_init();

#ifdef SYSTEM_AXI_A_BMB

    bsp_printf("axi4 slave demo ! \r\n");

    for (int i=0; i < AXI_SIZE ; i = i + 4 ){
        write_u32(i, AXI + i);
    }

    for (int i=0; i < AXI_SIZE ; i = i + 4 ){
        data = read_u32(AXI + i);
        if(i != data){
            bsp_printf("Failed at address 0x%x with value 0x%x \r\n", i, data);
            error_state();
        }
    }
    bsp_printf("Passed! \r\n");
    bsp_printf("axi4 slave interrupt demo ! \r\n");
    intr_init();
    // Set 0xABCD to trigger AXI interrupt pin '1'
    write_u32(0xABCD, SYSTEM_AXI_A_BMB);    
    // write 0x0000 to clear AXI interrupt pin to '0'
    write_u32(0x0000, SYSTEM_AXI_A_BMB);    

#else

    bsp_printf("axi4 slave is disabled, please enable it to run this app. \r\n");

#endif

}

