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

#define cam_array     ((volatile uint32_t *)CAM_START_ADDR)
#define grayscale_array     ((volatile uint32_t *)GRAYSCALE_START_ADDR)
#define sobel_array ((volatile uint32_t *)SOBEL_START_ADDR)

void test_dma() {
    bsp_printf("\n\r-- Layer 2: DMA pipeline --\n\r");

    // Pure arithmetic checks - no hardware needed
    TEST("CAM_START_ADDR aligned to 8 bytes", (CAM_START_ADDR % 8) == 0);
    TEST("GRAYSCALE_START_ADDR aligned to 8 bytes", (GRAYSCALE_START_ADDR % 8) == 0);
    TEST("SOBEL_START_ADDR aligned to 8 bytes", (SOBEL_START_ADDR % 8) == 0);


    // Trigger S2MM DMA into hw_accel region (HW accel write channel)
    // This channel writes FROM the HW accel stream TO DDR
    // With no stream source active, S2MM won't start — so instead
    // verify the DMA channel is not stuck in busy from a previous run
    TEST("HW accel S2MM channel idle at start",
         !dmasg_busy(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL));
    TEST("HW accel MM2S channel idle at start",
         !dmasg_busy(DMASG_BASE, DMASG_HW_ACCEL_MM2S_1_CHANNEL));
    TEST("Cam S2MM channel idle at start",
         !dmasg_busy(DMASG_BASE, DMASG_CAM1_S2MM_CHANNEL));
    TEST("Display MM2S channel idle at start",
         !dmasg_busy(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL));


    // Read back debug FIFO counts via APB3 - should be 0 before any DMA runs
    // From top-level HDL: these are wired to real DMA FIFO counters
    u32 cam_rcount = EXAMPLE_APB3_REGR(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG7_OFFSET);
    u32 cam_wcount = EXAMPLE_APB3_REGR(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG8_OFFSET);
    TEST("Cam DMA FIFO read count is 0 at startup",  cam_rcount == 0);
    TEST("Cam DMA FIFO write count is 0 at startup", cam_wcount == 0);

}
