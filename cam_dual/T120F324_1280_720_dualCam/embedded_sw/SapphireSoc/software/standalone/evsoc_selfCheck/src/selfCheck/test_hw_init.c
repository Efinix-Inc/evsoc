////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2026 Efinix Inc. All rights reserved.
// See https://github.com/Efinix-Inc/evsoc/blob/main/LICENSE.txt for details.
////////////////////////////////////////////////////////////////////////////////

#include "board_config.h"
#include "axi4_hw_accel.h"
#include "test_harness.h"
#include "apb3_cam.h"

void test_hw_init() {
    bsp_printf("\n\r-- Layer 1: Hardware init --\n\r");

    // REG9 (offset 0x24): hardcoded verification register in APB3 HDL
    // Always returns 0xABCD5678 if bus address decoding and read path work
    u32 r1data = EXAMPLE_APB3_REGR(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG9_OFFSET);
    TEST("APB3 bus alive - REG9 == 0xABCD5678", r1data == 0xABCD5678);

    u32 r2data = read_u32(EXAMPLE_AXI4_SLV + EXAMPLE_AXI4_SLV_REG4_OFFSET);
    TEST("AXI4 bus alive - REG3 == 0xABCD1234", r2data == 0xABCD1234);

    // debug_fifo_status (offset 0x28): live signal from FPGA fabric
    // Bits are overflow/underflow flags - should all be 0 at startup with no camera
    u32 fifo_status = EXAMPLE_APB3_REGR(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG10_OFFSET);
    TEST("No FIFO overflow/underflow at startup", fifo_status == 0x00000000);

    // debug_cam1_dma_status (offset 0x40): should be 0 before any DMA triggered
    // debug_cam_dma_status = {29'd0, cam_dma_fifo_empty, cam_dma_write, cam_dma_wready}; cam_dma_fifo_empty = 1, cam_dma_write = 0, cam_dma_wready = 1
    u32 cam1_dma_status = EXAMPLE_APB3_REGR(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG16_OFFSET);
    TEST("Cam1 DMA status clean at startup", cam1_dma_status == 0x00000005);

    // debug_cam2_dma_status (offset 0x50): same for cam2
    u32 cam2_dma_status = EXAMPLE_APB3_REGR(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG20_OFFSET);
    TEST("Cam2 DMA status clean at startup", cam2_dma_status == 0x00000005);

    // Control register writes - write-only, just verify bus doesn't hang
    EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG3_OFFSET, 0x00000000);
    TEST("APB3 cam1 rgb_gray write completes", 1);

    EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG7_OFFSET, 0x00000000);
    TEST("APB3 cam2 rgb_gray write completes", 1);

    // AXI4 - write-only confirmed, just verify no bus hang
    write_u32(100, EXAMPLE_AXI4_SLV + EXAMPLE_AXI4_SLV_REG0_OFFSET);
    TEST("AXI4 Sobel threshold write completes", 1);

    write_u32(0x00000000, EXAMPLE_AXI4_SLV + EXAMPLE_AXI4_SLV_REG1_OFFSET);
    TEST("AXI4 HW accel mode write completes", 1);

    write_u32(0x00000001, EXAMPLE_AXI4_SLV + EXAMPLE_AXI4_SLV_REG1_OFFSET);
    TEST("AXI4 HW accel mode 1 write completes", 1);

    write_u32(0x00000002, EXAMPLE_AXI4_SLV + EXAMPLE_AXI4_SLV_REG1_OFFSET);
    TEST("AXI4 HW accel mode 2 write completes", 1);

    write_u32(0x00000003, EXAMPLE_AXI4_SLV + EXAMPLE_AXI4_SLV_REG1_OFFSET);
    TEST("AXI4 HW accel mode 3 write completes", 1);

    write_u32(0x00000000, EXAMPLE_AXI4_SLV + EXAMPLE_AXI4_SLV_REG2_OFFSET);
    TEST("HW accel merger mode 0 write completes (left/right)", 1);

    write_u32(0x00000001, EXAMPLE_AXI4_SLV + EXAMPLE_AXI4_SLV_REG2_OFFSET);
    TEST("HW accel merger mode 1 write completes (main+overlay)", 1);

    // Restore safe state
    write_u32(0x00000000, EXAMPLE_AXI4_SLV + EXAMPLE_AXI4_SLV_REG1_OFFSET);
}
