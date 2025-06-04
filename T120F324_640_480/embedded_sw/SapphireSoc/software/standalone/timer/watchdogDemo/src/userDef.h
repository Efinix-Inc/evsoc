
///////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 2025 SaxonSoc contributors
//  SPDX license identifier: MIT
//  Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
///////////////////////////////////////////////////////////////////////////////////

#ifdef SYSTEM_PLIC_SYSTEM_WATCHDOG_SOFT_PANIC_INTERRUPT //HPS
    #define WATCHDOG_SOFT_PANIC_INTERRUPT SYSTEM_PLIC_SYSTEM_WATCHDOG_SOFT_PANIC_INTERRUPT
#endif
#ifdef SYSTEM_PLIC_SYSTEM_WATCHDOG_LOGIC_PANICS_0 // Soft Sapphire
    #define WATCHDOG_SOFT_PANIC_INTERRUPT SYSTEM_PLIC_SYSTEM_WATCHDOG_LOGIC_PANICS_0
#endif

#define WATCHDOG_PRESCALER_CYCLE_PER_MS SYSTEM_CLINT_HZ/1000
#define WATCHDOG_TIMEOUT_MS 3000
#define WAIT_TIME_MS (WATCHDOG_TIMEOUT_MS - 500)