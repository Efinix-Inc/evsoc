//////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 2025 SaxonSoc contributors
//  SPDX license identifier: MIT
//  Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
///////////////////////////////////////////////////////////////////////////////////
#include <stdint.h>
#include <time.h>
#include "bsp.h"
#include "clint.h"
#include "clint.h"
#include "riscv.h"
#include "gpio.h"
#include "plic.h"
#include "watchdog.h"
#include "userDef.h"
void main();
void trap();

#ifdef SYSTEM_WATCHDOG_LOGIC_CTRL
void init();
void crash();
void trap_entry();
void initWatchdog();
void externalInterrupt();
void watchdogSoftPanic();
void patWatchdog();


u32 softPanicCounter = 0;
u32 software_gone_wrong = 0;
u32 random_x = 3;
u32 random_y = 3;

void main() {
	u32 i;
	bsp_init();
	bsp_printf("***Starting WatchDog Timer Demo***\n\r");
    init();

    bsp_printf("Watchdog timer timeout = %ds .. \n\r", WATCHDOG_TIMEOUT_MS/1000);
    bsp_printf("Pat the watchdog every %dms for %d times then wait for soft panic trigger .. \n\r", WAIT_TIME_MS, random_x);
    bsp_printf("Watchdog patting will stop after %d soft panic trigger.. \n\n\r", random_y);

    while(1){
    	for(i=0; i<random_x; i++){
    		bsp_uDelay(WAIT_TIME_MS*1000);
    		patWatchdog();
    	}

    	software_gone_wrong = 1;
    	while(software_gone_wrong == 1){
    		bsp_uDelay(1000*1000);
    		bsp_printf("Assume software gone wrong here .. \n\r");
    	};
    	bsp_printf("\n\r");
    }; //Idle
}


void init(){
    //configure PLIC
    plic_set_threshold(BSP_PLIC, BSP_PLIC_CPU_0, 0); //cpu 0 accept all interrupts with priority above 0

    //enable the watchdog soft panic interrupt on the PLIC
    plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, WATCHDOG_SOFT_PANIC_INTERRUPT, 1);
    plic_set_priority(BSP_PLIC, WATCHDOG_SOFT_PANIC_INTERRUPT, 1);

    initWatchdog();

    //enable interrupts
    csr_write(mtvec, trap_entry); //Set the machine trap vector (../common/trap.S)
    csr_set(mie, MIE_MEIE);
    csr_write(mstatus, csr_read(mstatus) | MSTATUS_MPP | MSTATUS_MIE);
}

void initWatchdog(){
    // Divide the clock rate by WATCHDOG_PRESCALER_CYCLE_PER_MS
    watchdog_setPrescaler(SYSTEM_WATCHDOG_LOGIC_CTRL, WATCHDOG_PRESCALER_CYCLE_PER_MS-1);

    //Setup timeout limit for the various watchdog timers
    //The counter 0 being set to trigger first (interrupt)
    //The counter 1 being used to trigger the hardware reset of the SoC (Handled outside the SoC)
    watchdog_setCounterLimit(SYSTEM_WATCHDOG_LOGIC_CTRL, 0,   WATCHDOG_TIMEOUT_MS-1);
    watchdog_setCounterLimit(SYSTEM_WATCHDOG_LOGIC_CTRL, 1, 2*WATCHDOG_TIMEOUT_MS-1);

    // Irrevocably enable the watchdog counters 0 and 1
    watchdog_enable(SYSTEM_WATCHDOG_LOGIC_CTRL, 3); //Enable counter 0 and 1
}


//Called by trap_entry on both exceptions and interrupts events
void trap(){
    int32_t mcause = csr_read(mcause);
    int32_t interrupt = mcause < 0;    //Interrupt if true, exception if false
    int32_t cause     = mcause & 0xF;

    if(interrupt){
        switch(cause){
        case CAUSE_MACHINE_EXTERNAL: externalInterrupt(); break;
        default: crash(); break;
        }
    } else {
        crash();
    }
}

void externalInterrupt(){
    uint32_t claim;
    //While there is pending interrupts
    while(claim = plic_claim(BSP_PLIC, BSP_PLIC_CPU_0)){
        switch(claim){
        case WATCHDOG_SOFT_PANIC_INTERRUPT: watchdogSoftPanic(); break;
        default: crash(); break;
        }
        plic_release(BSP_PLIC, BSP_PLIC_CPU_0, claim); //unmask the claimed interrupt
    }
}


void watchdogSoftPanic(){

    softPanicCounter += 1;

    if(softPanicCounter > random_y){
    	bsp_printf("Soft panic count=%d \n\rstop pat the watchdog this time and watchdog will reset system after %ds ..\n\n\r", softPanicCounter, WATCHDOG_TIMEOUT_MS/1000);
    	while(1);
    }

    // Here your software can recover.

    patWatchdog();
    software_gone_wrong = 0;

    bsp_printf("Soft panic count=%d \n\r", softPanicCounter);
}

void patWatchdog(){
	bsp_printf("Pat the watchdog .. \n\r");
	watchdog_heartbeat(SYSTEM_WATCHDOG_LOGIC_CTRL); // This will clear all the timeout counters and the soft panic
}

//Used on unexpected trap/interrupt codes
void crash(){
	bsp_printf("\n*** CRASH ***\n\r");
    while(1);
}

#else
void trap(){
}

void main() {
	bsp_printf("***Starting WatchDog Timer Demo***\n\r");
	bsp_printf("Watchdog timer is not enabled, unable to run this demo...\n\r");
	while(1);
}
#endif
