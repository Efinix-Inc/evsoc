///////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 2025 SaxonSoc contributors
//  SPDX license identifier: MIT
//  Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
//////////////////////////////////////////////////////////////////////////////////

#pragma once
#include "type.h"
#include "io.h"

#define WATCHDOG_HEARTBEAT   0x0
#define WATCHDOG_ENABLE      0x4
#define WATCHDOG_PRESCALER  0x40
#define WATCHDOG_COUNTER_LIMIT 0x80
#define WATCHDOG_COUNTER_VALUE 0xC0

#define WATCHDOG_HEARTBEAT_CHALLENGE 0xAD68E70D

/*
The watchdog hadware is designed as following :
- There is a shared prescaler provide a periodic tick
- There is one/multiple counters which increment when the prescaler overflow
- Each of those counters will have its own "limit" register which will specify when it will generate its own interrupt
- All counters and the "softPanic" can be cleared together by the software executing a heartbeat
- Typicaly, the watchdog can be configured to have two counters
  - Counter 0 would provide an interrupt to let's the CPU handle the issue or shutdown the system cleanly
  - Counter 1, configured to trigger after counter 0, would be connected in hardware to reset the whole system in a hard way
*/

writeReg_u32(watchdog_setPrescaler , WATCHDOG_PRESCALER)

void watchdog_setCounterLimit(u32 reg, u32 counterId, u32 value){
    write_u32(value, reg + WATCHDOG_COUNTER_LIMIT + counterId * 4);
}

u32 watchdog_getCounterValue(u32 reg, u32 counterId, u32 value){
    return read_u32(reg + WATCHDOG_COUNTER_VALUE + counterId * 4);
}

void watchdog_heartbeat(u32 reg){
    write_u32(WATCHDOG_HEARTBEAT_CHALLENGE, reg + WATCHDOG_HEARTBEAT);
}

void watchdog_enable(u32 reg, u32 mask){
    write_u32(mask, reg + WATCHDOG_ENABLE);
}
