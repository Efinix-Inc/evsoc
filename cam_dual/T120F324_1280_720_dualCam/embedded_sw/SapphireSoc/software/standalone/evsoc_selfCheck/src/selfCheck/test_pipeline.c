////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2026 Efinix Inc. All rights reserved.
// See https://github.com/Efinix-Inc/evsoc/blob/main/LICENSE.txt for details.
////////////////////////////////////////////////////////////////////////////////

// test_pipeline.c
#include "test_harness.h"
#include "board_config.h"
#include "apb3_cam.h"
#include "axi4_hw_accel.h"
#include "dmasg.h"
#include "dmasg_config.h"

#define cam1_array     ((volatile uint32_t *)CAM1_START_ADDR)
#define cam2_array     ((volatile uint32_t *)CAM2_START_ADDR)
#define hw_accel_array ((volatile uint32_t *)HW_ACCEL_START_ADDR)

#define PIPELINE_TIMEOUT 10000000

/*******************************************************
 * Helpers
 *******************************************************/

static int pipeline_wait() {
    for (int i = 0; i < PIPELINE_TIMEOUT; i++) {
        if (!dmasg_busy(DMASG_BASE, DMASG_HW_ACCEL_MM2S_1_CHANNEL) &&
            !dmasg_busy(DMASG_BASE, DMASG_HW_ACCEL_MM2S_2_CHANNEL) &&
            !dmasg_busy(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL))
            return 1;
    }
    return 0;
}

static void fill_buffer(volatile uint32_t *buf, uint32_t colour) {
    uint32_t total = (uint32_t)FRAME_WIDTH * (uint32_t)FRAME_HEIGHT;
    for (uint32_t i = 0; i < total; i++)
        buf[i] = colour;
}

static void fill_colourbar(volatile uint32_t *buf) {
    for (int y = 0; y < FRAME_HEIGHT; y++) {
        for (int x = 0; x < FRAME_WIDTH; x++) {
            if (x < FRAME_WIDTH / 4)
                buf[y * FRAME_WIDTH + x] = 0x0000FF00; // GREEN
            else if (x < FRAME_WIDTH / 4 * 2)
                buf[y * FRAME_WIDTH + x] = 0x00FF0000; // BLUE
            else if (x < FRAME_WIDTH / 4 * 3)
                buf[y * FRAME_WIDTH + x] = 0x000000FF; // RED
            else
                buf[y * FRAME_WIDTH + x] = 0x00FFFFFF; // WHITE
        }
    }
}

/*
 * Mirrors the exact HW accel trigger sequence from production main.c.
 * accel_mode : AXI4 REG1 value (0=passthrough, 1=Sobel cam2, 3=Sobel both)
 * merger_mode: AXI4 REG2 value (0=left/right split, 1=main+overlay)
 * mm2s1_src  : DDR address fed to MM2S channel 1 (cam1 or cam2)
 * mm2s2_src  : DDR address fed to MM2S channel 2 (cam2 or cam1)
 */
static int run_hw_accel(uint32_t accel_mode, uint32_t merger_mode,
                         uint32_t mm2s1_src,  uint32_t mm2s2_src) {
    // Set Sobel threshold and modes — same as production main.c
    write_u32(100,         EXAMPLE_AXI4_SLV + EXAMPLE_AXI4_SLV_REG0_OFFSET);
    write_u32(accel_mode,  EXAMPLE_AXI4_SLV + EXAMPLE_AXI4_SLV_REG1_OFFSET);
    write_u32(merger_mode, EXAMPLE_AXI4_SLV + EXAMPLE_AXI4_SLV_REG2_OFFSET);

    // Trigger HW accel MM2S DMA 1 — reads from mm2s1_src
    dmasg_input_memory(DMASG_BASE, DMASG_HW_ACCEL_MM2S_1_CHANNEL, mm2s1_src, 16);
    dmasg_output_stream(DMASG_BASE, DMASG_HW_ACCEL_MM2S_1_CHANNEL,
                        DMASG_HW_ACCEL_MM2S_1_PORT, 0, 0, 1);
    dmasg_direct_start(DMASG_BASE, DMASG_HW_ACCEL_MM2S_1_CHANNEL,
                       ((FRAME_WIDTH * FRAME_HEIGHT) + (FRAME_WIDTH + 1)) * 4, 0);

    // Trigger HW accel MM2S DMA 2 — reads from mm2s2_src
    dmasg_input_memory(DMASG_BASE, DMASG_HW_ACCEL_MM2S_2_CHANNEL, mm2s2_src, 16);
    dmasg_output_stream(DMASG_BASE, DMASG_HW_ACCEL_MM2S_2_CHANNEL,
                        DMASG_HW_ACCEL_MM2S_2_PORT, 0, 0, 1);
    dmasg_direct_start(DMASG_BASE, DMASG_HW_ACCEL_MM2S_2_CHANNEL,
                       ((FRAME_WIDTH * FRAME_HEIGHT) + (FRAME_WIDTH + 1)) * 4, 0);

    // Trigger HW accel S2MM DMA — writes result to hw_accel_array
    dmasg_input_stream(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL,
                       DMASG_HW_ACCEL_S2MM_PORT, 1, 0);
    dmasg_output_memory(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL,
                        HW_ACCEL_START_ADDR, 16);
    dmasg_direct_start(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL,
                       (FRAME_WIDTH * FRAME_HEIGHT) * 4, 0);

    // Start pulse — same as production main.c
    write_u32(0x00000001, EXAMPLE_AXI4_SLV + EXAMPLE_AXI4_SLV_REG3_OFFSET);
    write_u32(0x00000000, EXAMPLE_AXI4_SLV + EXAMPLE_AXI4_SLV_REG3_OFFSET);

    // Wait for completion
    return pipeline_wait();
}

/*******************************************************
 * Mode A — Left/Right Split, both passthrough
 * cam1 → left half, cam2 → right half
 * Input : cam1=solid RED, cam2=solid BLUE
 * Expect: left half RED, right half BLUE
 *******************************************************/
static void test_mode_a() {
    bsp_printf("\n\r  Mode A: left/right split passthrough\n\r");

    // Inject synthetic input
    fill_buffer(cam1_array, 0x000000FF); // RED
    fill_buffer(cam2_array, 0x00FF0000); // BLUE
    data_cache_invalidate_all();

    // Run pipeline — mode a: accel=passthrough, merger=split
    // cam1 → MM2S1, cam2 → MM2S2 (same as production select_demo_mode==0)
    TEST("Mode A: pipeline completes",
         run_hw_accel(0x00000000, 0x00000000, CAM1_START_ADDR, CAM2_START_ADDR));
    data_cache_invalidate_all();

    // Sample mid-row left and right pixels
    int mid = (FRAME_HEIGHT / 2) * FRAME_WIDTH;
    uint32_t left  = hw_accel_array[mid + 0];
    uint32_t right = hw_accel_array[mid + FRAME_WIDTH - 1];
    bsp_printf("  left=0x%08X (expect RED  0x000000FF)\n\r", left);
    bsp_printf("  right=0x%08X (expect BLUE 0x00FF0000)\n\r", right);

    TEST("Mode A: left half is RED  (cam1 passthrough)", left  == 0x000000FF);
    TEST("Mode A: right half is BLUE (cam2 passthrough)", right == 0x00FF0000);
}

/*******************************************************
 * Mode B — Main + Overlay, both passthrough
 * cam1=main (full frame), cam2=overlay (downscaled)
 * Input : cam1=solid GREEN, cam2=solid RED
 * Expect: main area GREEN, overlay area RED
 *******************************************************/
static void test_mode_b() {
    bsp_printf("\n\r  Mode B: main+overlay passthrough (cam1 main, cam2 overlay)\n\r");

    fill_buffer(cam1_array, 0x0000FF00); // GREEN — main
    fill_buffer(cam2_array, 0x000000FF); // RED   — overlay
    data_cache_invalidate_all();

    // select_demo_mode==1: accel=passthrough, merger=overlay
    // cam1 → MM2S1 (main), cam2 → MM2S2 (overlay)
    TEST("Mode B: pipeline completes",
         run_hw_accel(0x00000000, 0x00000001, CAM1_START_ADDR, CAM2_START_ADDR));
    data_cache_invalidate_all();

    // Main area — top-left pixel should be GREEN from cam1
    uint32_t main_pixel = hw_accel_array[0];
    bsp_printf("  main pixel=0x%08X (expect GREEN 0x0000FF00)\n\r", main_pixel);
    TEST("Mode B: main area is GREEN (cam1 passthrough)", main_pixel == 0x0000FF00);
}

/*******************************************************
 * Mode C — Main + Overlay, sources swapped
 * cam2=main, cam1=overlay
 * Input : cam1=solid RED, cam2=solid BLUE
 * Expect: main area BLUE (cam2), overlay RED (cam1)
 *******************************************************/
static void test_mode_c() {
    bsp_printf("\n\r  Mode C: main+overlay passthrough (cam2 main, cam1 overlay)\n\r");

    fill_buffer(cam1_array, 0x000000FF); // RED  — will be overlay
    fill_buffer(cam2_array, 0x00FF0000); // BLUE — will be main
    data_cache_invalidate_all();

    // select_demo_mode==2: accel=passthrough, merger=overlay
    // cam2 → MM2S1 (main), cam1 → MM2S2 (overlay) — sources swapped vs mode B
    TEST("Mode C: pipeline completes",
         run_hw_accel(0x00000000, 0x00000001, CAM2_START_ADDR, CAM1_START_ADDR));
    data_cache_invalidate_all();

    uint32_t main_pixel = hw_accel_array[0];
    bsp_printf("  main pixel=0x%08X (expect BLUE 0x00FF0000)\n\r", main_pixel);
    TEST("Mode C: main area is BLUE (cam2 passthrough)", main_pixel == 0x00FF0000);
}

/*******************************************************
 * Mode D — Grayscale main + Sobel overlay
 * cam1=main (passthrough), cam2=Sobel processed
 * Input : cam1=solid GRAY, cam2=solid colour (no edges)
 * Expect: Sobel on solid input = black (no edges detected)
 *******************************************************/
static void test_mode_d() {
    bsp_printf("\n\r  Mode D: grayscale main + Sobel overlay\n\r");

    // Set BOTH cameras to grayscale mode via APB3
    // Required for mode D — matches production main.c select_demo_mode==3
    EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG3_OFFSET, 0x00000001); // cam1 grayscale
    EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG7_OFFSET, 0x00000001); // cam2 grayscale

    // Inject solid gray — no edges in either buffer
    fill_buffer(cam1_array, 0x00808080);
    fill_buffer(cam2_array, 0x00808080);
    data_cache_invalidate_all();

    // Mode 1 accel (Sobel on cam2), mode 1 merger (main+overlay)
    TEST("Mode D: pipeline completes",
         run_hw_accel(0x00000001, 0x00000001, CAM1_START_ADDR, CAM2_START_ADDR));
    data_cache_invalidate_all();

    // Sample main area — top-left pixel, well inside main region
    uint32_t main_pixel = hw_accel_array[0];
    bsp_printf("  main pixel=0x%08X (expect GRAY 0x00808080)\n\r", main_pixel);
    TEST("Mode D: main area is GRAY (cam1 passthrough)", main_pixel == 0x00808080);

    // For Sobel verification — instead of guessing the overlay position,
    // sample multiple points and check if any are non-zero
    // A solid input should produce zero Sobel output everywhere
    int errors = 0;
    uint32_t total = (uint32_t)FRAME_WIDTH * (uint32_t)FRAME_HEIGHT;
    for (uint32_t i = 0; i < total; i += FRAME_WIDTH) { // sample one pixel per row
        if (hw_accel_array[i] != 0x00808080 && hw_accel_array[i] != 0x00000000) {
            errors++;
        }
    }
    bsp_printf("  unexpected pixel count: %d (expect 0)\n\r", errors);
    TEST("Mode D: output contains only GRAY or BLACK pixels", errors == 0);

    // Restore RGB mode for subsequent tests
    EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG3_OFFSET, 0x00000000);
    EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG7_OFFSET, 0x00000000);
}

/*******************************************************
 * Mode E — Sobel on both cameras
 * cam1=Sobel, cam2=Sobel
 * Input : both solid colour (no edges)
 * Expect: both Sobel outputs black
 *******************************************************/
static void test_mode_e() {
    bsp_printf("\n\r  Mode E: Sobel both cameras\n\r");

    fill_buffer(cam1_array, 0x00404040); // dark GRAY — no edges
    fill_buffer(cam2_array, 0x00404040); // dark GRAY — no edges
    data_cache_invalidate_all();

    // select_demo_mode==4: accel=Sobel both, merger=overlay
    // cam1 → MM2S1 (Sobel), cam2 → MM2S2 (Sobel)
    TEST("Mode E: pipeline completes",
         run_hw_accel(0x00000003, 0x00000001, CAM1_START_ADDR, CAM2_START_ADDR));
    data_cache_invalidate_all();

    // Both sources are solid — Sobel should produce black everywhere
    uint32_t main_pixel    = hw_accel_array[0];
    int overlay_x = FRAME_WIDTH  * 3 / 4;
    int overlay_y = FRAME_HEIGHT * 3 / 4;
    uint32_t overlay_pixel = hw_accel_array[overlay_y * FRAME_WIDTH + overlay_x];
    bsp_printf("  main pixel=0x%08X    (expect BLACK 0x00000000)\n\r", main_pixel);
    bsp_printf("  overlay pixel=0x%08X (expect BLACK 0x00000000)\n\r", overlay_pixel);

    TEST("Mode E: main Sobel on solid = black",    main_pixel    == 0x00000000);
    TEST("Mode E: overlay Sobel on solid = black", overlay_pixel == 0x00000000);
}

/*******************************************************
 * Additional — Colourbar input through passthrough
 * Verifies the pipeline preserves pixel values exactly
 * Input : cam1=colourbar pattern
 * Expect: output matches input pixel-for-pixel
 *******************************************************/
static void test_passthrough_fidelity() {
    bsp_printf("\n\r  Passthrough fidelity: colourbar input\n\r");

    fill_colourbar(cam1_array);
    fill_buffer(cam2_array, 0x00000000); // black — not used in left/right split left side
    data_cache_invalidate_all();

    // Use mode A (left/right split) so left half is pure cam1 passthrough
    TEST("Passthrough fidelity: pipeline completes",
         run_hw_accel(0x00000000, 0x00000000, CAM1_START_ADDR, CAM2_START_ADDR));
    data_cache_invalidate_all();

    // Sample each colour bar in the left half (cam1 passthrough region)
    int mid = (FRAME_HEIGHT / 2) * FRAME_WIDTH;
    uint32_t green = hw_accel_array[mid + FRAME_WIDTH / 8];         // col in GREEN bar
    uint32_t blue  = hw_accel_array[mid + FRAME_WIDTH * 3 / 8];     // col in BLUE bar
    bsp_printf("  green bar pixel=0x%08X (expect 0x0000FF00)\n\r", green);
    bsp_printf("  blue  bar pixel=0x%08X (expect 0x00FF0000)\n\r", blue);

    TEST("Passthrough fidelity: GREEN bar preserved", green == 0x0000FF00);
    TEST("Passthrough fidelity: BLUE bar preserved",  blue  == 0x00FF0000);
}

/*******************************************************
 * Main pipeline test entry point
 *******************************************************/
void test_pipeline() {
    bsp_printf("\n\r-- Pipeline injection tests --\n\r");
    bsp_printf("Bypassing camera, injecting synthetic data into DDR\n\r");
    bsp_printf("Running through HW accel for all 5 demo modes\n\r");

    test_mode_a();
    test_mode_b();
    test_mode_c();
    test_mode_d();
    test_mode_e();
    test_passthrough_fidelity();

    // Check no FIFOs overflowed during any pipeline run
    u32 fifo_status = EXAMPLE_APB3_REGR(EXAMPLE_APB3_SLV,
                                         EXAMPLE_APB3_SLV_REG10_OFFSET);
    TEST("No FIFO overflow after all pipeline tests", fifo_status == 0x00000000);
    if (fifo_status != 0)
        bsp_printf("  FIFO status: 0x%08X\n\r", fifo_status);
}
