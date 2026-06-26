////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2026 Efinix Inc. All rights reserved.
// See https://github.com/Efinix-Inc/evsoc/blob/main/LICENSE.txt for details.
////////////////////////////////////////////////////////////////////////////////

#include "test_harness.h"
#include "board_config.h"
#include "apb3_cam.h"
#include "dmasg.h"
#include "dmasg_config.h"

#define DMA_TIMEOUT_MS 500

#define cam1_array     ((volatile uint32_t *)CAM1_START_ADDR)
#define cam2_array     ((volatile uint32_t *)CAM2_START_ADDR)
#define hw_accel_array ((volatile uint32_t *)HW_ACCEL_START_ADDR)

void test_dma() {
    bsp_printf("\n\r-- Layer 2: DMA pipeline --\n\r");

    // Pure arithmetic checks - no hardware needed
    TEST("CAM1_START_ADDR aligned to 8 bytes", (CAM1_START_ADDR % 8) == 0);
    TEST("CAM2_START_ADDR aligned to 8 bytes", (CAM2_START_ADDR % 8) == 0);
    TEST("HW_ACCEL_START_ADDR aligned to 8 bytes", (HW_ACCEL_START_ADDR % 8) == 0);


    // Trigger S2MM DMA into hw_accel region (HW accel write channel)
    // This channel writes FROM the HW accel stream TO DDR
    // With no stream source active, S2MM won't start — so instead
    // verify the DMA channel is not stuck in busy from a previous run
    TEST("HW accel S2MM channel idle at start",
         !dmasg_busy(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL));
    TEST("HW accel MM2S 1 channel idle at start",
         !dmasg_busy(DMASG_BASE, DMASG_HW_ACCEL_MM2S_1_CHANNEL));
    TEST("HW accel MM2S 2 channel idle at start",
         !dmasg_busy(DMASG_BASE, DMASG_HW_ACCEL_MM2S_2_CHANNEL));
    TEST("Cam1 S2MM channel idle at start",
         !dmasg_busy(DMASG_BASE, DMASG_CAM1_S2MM_CHANNEL));
    TEST("Cam2 S2MM channel idle at start",
         !dmasg_busy(DMASG_BASE, DMASG_CAM2_S2MM_CHANNEL));
    TEST("Display MM2S channel idle at start",
         !dmasg_busy(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL));


    // Read back debug FIFO counts via APB3 - should be 0 before any DMA runs
    // From top-level HDL: these are wired to real DMA FIFO counters
    u32 cam1_rcount = EXAMPLE_APB3_REGR(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG14_OFFSET);
    u32 cam1_wcount = EXAMPLE_APB3_REGR(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG15_OFFSET);
    TEST("Cam1 DMA FIFO read count is 0 at startup",  cam1_rcount == 0);
    TEST("Cam1 DMA FIFO write count is 0 at startup", cam1_wcount == 0);

    u32 cam2_rcount = EXAMPLE_APB3_REGR(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG18_OFFSET);
    u32 cam2_wcount = EXAMPLE_APB3_REGR(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG19_OFFSET);
    TEST("Cam2 DMA FIFO read count is 0 at startup",  cam2_rcount == 0);
    TEST("Cam2 DMA FIFO write count is 0 at startup", cam2_wcount == 0);
}
