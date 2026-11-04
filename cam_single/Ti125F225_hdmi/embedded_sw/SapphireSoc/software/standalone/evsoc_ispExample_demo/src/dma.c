////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2026 Efinix Inc. All rights reserved.
// See https://github.com/Efinix-Inc/evsoc/blob/main/LICENSE.txt for details.
////////////////////////////////////////////////////////////////////////////////

#include "dmasg_config.h"
#include "plic.h"
#include "riscv.h"
#include "clint.h"
#include "uart.h"
#include "bsp.h"

// crash() and trap()
void crash()
{
    bsp_printf("\n*** CRASH ***\n");
    while (1)
        ;
}

void dma_init()
{
    plic_set_threshold(BSP_PLIC, BSP_PLIC_CPU_0, 0);
    plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, PLIC_DMASG_CHANNEL, 1);
    plic_set_priority(BSP_PLIC, PLIC_DMASG_CHANNEL, 1);
    csr_write(mtvec, trap_entry);
    csr_set(mie, MIE_MEIE);
    csr_write(mstatus, csr_read(mstatus) | MSTATUS_MPP | MSTATUS_MIE);
}

// defined in main.c
extern void externalInterrupt();

void trap()
{
    int32_t mcause = csr_read(mcause);
    int32_t interrupt = mcause < 0;
    int32_t cause = mcause & 0xF;
    if (interrupt)
    {
        switch (cause)
        {
        case CAUSE_MACHINE_EXTERNAL:
            externalInterrupt();
            break;
        default:
            crash();
            break;
        }
    }
    else
    {
        crash();
    }
}