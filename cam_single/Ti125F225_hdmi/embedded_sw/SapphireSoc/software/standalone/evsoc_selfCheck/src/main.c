////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2026 Efinix Inc. All rights reserved.
// See https://github.com/Efinix-Inc/evsoc/blob/main/LICENSE.txt for details.
////////////////////////////////////////////////////////////////////////////////

#include "bsp.h"
#include "test_harness.h"
#include "plic.h"

void test_hw_init();
void test_dma();
void test_pipeline();

// Provides the interrupt handler dma_init() expects to register
void externalInterrupt() {
    // Stub — regression tests don't exercise live UART interrupts
}

int _pass;
int _fail;

void main() {
    bsp_printf("\n\r=== Dual-Camera SoC Regression Suite ===\n\r");

    test_hw_init();
    test_dma();
    test_pipeline();

    TEST_REPORT();

}
