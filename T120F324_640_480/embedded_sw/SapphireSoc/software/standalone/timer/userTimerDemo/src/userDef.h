///////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 2025 SaxonSoc contributors
//  SPDX license identifier: MIT
//  Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
///////////////////////////////////////////////////////////////////////////////////

#define SYSTEM_PLIC_TIMER_INTERRUPTS_0  SYSTEM_PLIC_SYSTEM_USER_TIMER_0_INTERRUPTS_0
#define TIMER_CTRL                      SYSTEM_USER_TIMER_0_CTRL 
#define TIMER_PRESCALER_CTRL            (TIMER_CTRL + 0x00)
#define TIMER_0_CTRL                    (TIMER_CTRL +  0x40)
#define TIMER_CONFIG_WITH_PRESCALER     0x2
#define TIMER_CONFIG_WITHOUT_PRESCALER  0x1
#define TIMER_CONFIG_SELF_RESTART       0x10000
#ifdef SIM
    //Faster timer tick in simulation
    #define TIMER_TICK_DELAY            (BSP_CLINT_HZ/200) 
#else
    #define TIMER_TICK_DELAY            (BSP_CLINT_HZ)
#endif
