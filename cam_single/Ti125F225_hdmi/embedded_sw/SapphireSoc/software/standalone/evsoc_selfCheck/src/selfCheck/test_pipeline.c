////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2026 Efinix Inc. All rights reserved.
// See https://github.com/Efinix-Inc/evsoc/blob/main/LICENSE.txt for details.
////////////////////////////////////////////////////////////////////////////////

// test_pipeline.c (single camera version)
#include "test_harness.h"
#include "board_config.h"
#include "apb3_cam.h"
#include "axi4_hw_accel.h"
#include "dmasg.h"
#include "dmasg_config.h"
#include "isp.h"

#define cam_array       ((volatile uint32_t *)CAM_START_ADDR)
#define grayscale_array ((volatile uint32_t *)GRAYSCALE_START_ADDR)
#define sobel_array     ((volatile uint32_t *)SOBEL_START_ADDR)

#define PIPELINE_TIMEOUT 10000000

/*******************************************************
 * Helpers
 *******************************************************/

static int pipeline_wait() {
    for (int i = 0; i < PIPELINE_TIMEOUT; i++) {
        if (!dmasg_busy(DMASG_BASE, DMASG_HW_ACCEL_MM2S_1_CHANNEL) &&
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
 * accel_mode  : AXI4 REG1 value
 *               0 = Sobel only
 *               1 = Sobel + Dilation
 *               2 = Sobel + Erosion
 * input_addr  : DDR address to read from (cam_array or grayscale_array)
 * output_addr : DDR address to write result to (sobel_array)
 */
static int run_hw_accel(uint32_t accel_mode, uint32_t input_addr,
                         uint32_t output_addr) {
    // Set Sobel threshold and accel mode — same as production main.c
    write_u32(100,        EXAMPLE_AXI4_SLV + EXAMPLE_AXI4_SLV_REG0_OFFSET);
    write_u32(accel_mode, EXAMPLE_AXI4_SLV + EXAMPLE_AXI4_SLV_REG1_OFFSET);

    // Trigger MM2S DMA — reads from input_addr
    dmasg_input_memory(DMASG_BASE, DMASG_HW_ACCEL_MM2S_1_CHANNEL, input_addr, 16);
    dmasg_output_stream(DMASG_BASE, DMASG_HW_ACCEL_MM2S_1_CHANNEL,
                        DMASG_HW_ACCEL_MM2S_1_PORT, 0, 0, 1);

    // Transfer length differs between modes — matches production main.c exactly
    if (accel_mode == 0) {
        // Sobel only — one extra line for line buffer flushing
        dmasg_direct_start(DMASG_BASE, DMASG_HW_ACCEL_MM2S_1_CHANNEL,
                           ((FRAME_WIDTH * FRAME_HEIGHT) + (FRAME_WIDTH + 1)) * 4, 0);
    } else {
        // Sobel + Dilation or Erosion — two extra lines for line buffer flushing
        dmasg_direct_start(DMASG_BASE, DMASG_HW_ACCEL_MM2S_1_CHANNEL,
                           ((FRAME_WIDTH * FRAME_HEIGHT) + (2 * FRAME_WIDTH + 2)) * 4, 0);
    }

    // Trigger S2MM DMA — writes result to output_addr
    dmasg_input_stream(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL,
                       DMASG_HW_ACCEL_S2MM_PORT, 1, 0);
    dmasg_output_memory(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL, output_addr, 16);
    dmasg_direct_start(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL,
                       (FRAME_WIDTH * FRAME_HEIGHT) * 4, 0);

    // Start pulse — REG2 is the trigger in single-cam (not REG3 like dual-cam)
    write_u32(0x00000001, EXAMPLE_AXI4_SLV + EXAMPLE_AXI4_SLV_REG2_OFFSET);
    write_u32(0x00000000, EXAMPLE_AXI4_SLV + EXAMPLE_AXI4_SLV_REG2_OFFSET);

    return pipeline_wait();
}

/*******************************************************
 * Mode A — Camera capture + HDMI display (passthrough)
 * No HW accel involved — just verifies cam_array is
 * readable and contains what was written
 * Input : cam_array = colourbar
 * Expect: cam_array unchanged after pipeline
 *******************************************************/
static void test_mode_a() {
    bsp_printf("\n\r  Mode A: camera passthrough (no HW accel)\n\r");

    // Inject synthetic camera frame
    fill_colourbar(cam_array);
    data_cache_invalidate_all();

    // No HW accel in mode A — just verify cam_array is intact
    int mid = (FRAME_HEIGHT / 2) * FRAME_WIDTH;
    uint32_t green = cam_array[mid + FRAME_WIDTH / 8];
    uint32_t blue  = cam_array[mid + FRAME_WIDTH * 3 / 8];
    uint32_t red   = cam_array[mid + FRAME_WIDTH * 5 / 8];
    uint32_t white = cam_array[mid + FRAME_WIDTH * 7 / 8];

    bsp_printf("  green=0x%08X (expect 0x0000FF00)\n\r", green);
    bsp_printf("  blue =0x%08X (expect 0x00FF0000)\n\r", blue);
    bsp_printf("  red  =0x%08X (expect 0x000000FF)\n\r", red);
    bsp_printf("  white=0x%08X (expect 0x00FFFFFF)\n\r", white);

    TEST("Mode A: GREEN bar in cam_array", green == 0x0000FF00);
    TEST("Mode A: BLUE bar in cam_array",  blue  == 0x00FF0000);
    TEST("Mode A: RED bar in cam_array",   red   == 0x000000FF);
    TEST("Mode A: WHITE bar in cam_array", white == 0x00FFFFFF);
}

/*******************************************************
 * Mode B — SW RGB2Grayscale
 * RISC-V converts cam_array → grayscale_array
 * Input : cam_array = solid RED (0x000000FF)
 * Expect: grayscale_array = gray value matching
 *         RGB2grayscale formula: 0.299R + 0.587G + 0.114B
 *         RED (R=255,G=0,B=0) → gray = round(0.299*255) = 76 = 0x4C
 *         Full pixel: 0x004C4C4C (gray replicated to R,G,B)
 *******************************************************/
static void test_mode_b() {
    bsp_printf("\n\r  Mode B: SW RGB2Grayscale (RISC-V)\n\r");

    // Inject solid RED into cam_array
    fill_buffer(cam_array, 0x000000FF); // RED: R=255, G=0, B=0
    data_cache_invalidate_all();

    // Run SW grayscale — same call as production main.c
    rgb2grayscale(cam_array, grayscale_array, FRAME_WIDTH, FRAME_HEIGHT);
    data_cache_invalidate_all();

    // RED → grayscale: 0.299*255 + 0.587*0 + 0.114*0 = 76.245 ≈ 76 = 0x4C
    uint32_t pixel = grayscale_array[(FRAME_HEIGHT / 2) * FRAME_WIDTH + FRAME_WIDTH / 2];
    bsp_printf("  gray pixel=0x%08X (expect ~0x004C4C4C for RED input)\n\r", pixel);

    // Allow ±1 tolerance for rounding differences in rgb2grayscale implementation
    uint8_t gray = pixel & 0xFF;
    TEST("Mode B: SW grayscale of RED is ~76 (0x4C)", gray >= 75 && gray <= 77);
    TEST("Mode B: grayscale R==G==B channels",
         ((pixel & 0xFF) == ((pixel >> 8) & 0xFF)) &&
         ((pixel & 0xFF) == ((pixel >> 16) & 0xFF)));
}

/*******************************************************
 * Mode C — SW RGB2Grayscale + HW Sobel
 * RISC-V: cam_array → grayscale_array
 * HW accel reads grayscale_array, runs Sobel → sobel_array
 * Input : solid colour → no edges → Sobel output = black
 *******************************************************/
static void test_mode_c() {
    bsp_printf("\n\r  Mode C: SW grayscale + HW Sobel\n\r");

    // Inject solid GREEN — no edges after grayscale conversion
    fill_buffer(cam_array, 0x0000FF00); // GREEN
    data_cache_invalidate_all();

    // SW grayscale first
    rgb2grayscale(cam_array, grayscale_array, FRAME_WIDTH, FRAME_HEIGHT);
    data_cache_invalidate_all();

    // HW Sobel on SW grayscale output
    // Mode 2 in production: reads from GRAYSCALE_START_ADDR
    TEST("Mode C: HW Sobel pipeline completes",
         run_hw_accel(0x00000000, GRAYSCALE_START_ADDR, SOBEL_START_ADDR));
    data_cache_invalidate_all();

    // Solid input → no edges → Sobel output should be black
    uint32_t sobel_pixel = sobel_array[(FRAME_HEIGHT / 2) * FRAME_WIDTH + FRAME_WIDTH / 2];
    bsp_printf("  sobel pixel=0x%08X (expect 0x00000000 - no edges)\n\r", sobel_pixel);
    TEST("Mode C: Sobel on solid colour = no edges (black)", sobel_pixel == 0x00000000);
}

/*******************************************************
 * Mode D — HW RGB2Grayscale (camera pre-processing block)
 * Camera block outputs grayscale directly into cam_array
 * We simulate by filling cam_array with a known grayscale value
 * Input : cam_array = solid gray (0x00808080)
 * Expect: cam_array unchanged (HW grayscale already applied by cam block)
 *******************************************************/
static void test_mode_d() {
    bsp_printf("\n\r  Mode D: HW RGB2Grayscale (cam pre-processing)\n\r");

    // In production, the camera block outputs grayscale into cam_array
    // We simulate by directly writing a grayscale value
    fill_buffer(cam_array, 0x00808080); // mid-gray
    data_cache_invalidate_all();

    // No HW accel in mode D — HW grayscale is done by camera block
    // Verify cam_array holds the expected grayscale value
    uint32_t pixel = cam_array[(FRAME_HEIGHT / 2) * FRAME_WIDTH + FRAME_WIDTH / 2];
    bsp_printf("  gray pixel=0x%08X (expect 0x00808080)\n\r", pixel);
    TEST("Mode D: HW grayscale value in cam_array", pixel == 0x00808080);

    // Verify R==G==B (grayscale property)
    TEST("Mode D: grayscale R==G==B channels",
         ((pixel & 0xFF) == ((pixel >> 8) & 0xFF)) &&
         ((pixel & 0xFF) == ((pixel >> 16) & 0xFF)));
}

/*******************************************************
 * Mode E — HW RGB2Grayscale + HW Sobel
 * Camera block outputs grayscale into cam_array
 * HW accel reads cam_array, runs Sobel → sobel_array
 * Input : solid gray → no edges → Sobel = black
 *******************************************************/
static void test_mode_e() {
    bsp_printf("\n\r  Mode E: HW grayscale + HW Sobel\n\r");

    // Simulate HW grayscale output — solid gray, no edges
    fill_buffer(cam_array, 0x00808080);
    data_cache_invalidate_all();

    // HW Sobel reads from cam_array (HW grayscale already applied by cam block)
    TEST("Mode E: HW Sobel pipeline completes",
         run_hw_accel(0x00000000, CAM_START_ADDR, SOBEL_START_ADDR));
    data_cache_invalidate_all();

    uint32_t sobel_pixel = sobel_array[(FRAME_HEIGHT / 2) * FRAME_WIDTH + FRAME_WIDTH / 2];
    bsp_printf("  sobel pixel=0x%08X (expect 0x00000000 - no edges)\n\r", sobel_pixel);
    TEST("Mode E: Sobel on solid gray = no edges (black)", sobel_pixel == 0x00000000);
}

/*******************************************************
 * Mode F — HW Grayscale + Sobel + Dilation
 * Dilation expands bright regions — on a solid black
 * Sobel output, dilation should produce no change (stays black)
 * Input : solid gray → Sobel = black → Dilation of black = black
 *******************************************************/
static void test_mode_f() {
    bsp_printf("\n\r  Mode F: HW grayscale + Sobel + Dilation\n\r");

    fill_buffer(cam_array, 0x00808080); // solid gray — no edges
    data_cache_invalidate_all();

    // accel_mode=1: Sobel + Dilation
    TEST("Mode F: Sobel+Dilation pipeline completes",
         run_hw_accel(0x00000001, CAM_START_ADDR, SOBEL_START_ADDR));
    data_cache_invalidate_all();

    // Solid input → Sobel = black → Dilation of black = still black
    uint32_t pixel = sobel_array[(FRAME_HEIGHT / 2) * FRAME_WIDTH + FRAME_WIDTH / 2];
    bsp_printf("  output pixel=0x%08X (expect 0x00000000)\n\r", pixel);
    TEST("Mode F: Dilation of black Sobel output = black", pixel == 0x00000000);
}

/*******************************************************
 * Mode G — HW Grayscale + Sobel + Erosion
 * Erosion shrinks bright regions — on a solid black
 * Sobel output, erosion should produce no change (stays black)
 * Input : solid gray → Sobel = black → Erosion of black = black
 *******************************************************/
static void test_mode_g() {
    bsp_printf("\n\r  Mode G: HW grayscale + Sobel + Erosion\n\r");

    fill_buffer(cam_array, 0x00808080); // solid gray — no edges
    data_cache_invalidate_all();

    // accel_mode=2: Sobel + Erosion
    TEST("Mode G: Sobel+Erosion pipeline completes",
         run_hw_accel(0x00000002, CAM_START_ADDR, SOBEL_START_ADDR));
    data_cache_invalidate_all();

    // Solid input → Sobel = black → Erosion of black = still black
    uint32_t pixel = sobel_array[(FRAME_HEIGHT / 2) * FRAME_WIDTH + FRAME_WIDTH / 2];
    bsp_printf("  output pixel=0x%08X (expect 0x00000000)\n\r", pixel);
    TEST("Mode G: Erosion of black Sobel output = black", pixel == 0x00000000);
}

/*******************************************************
 * Additional — Edge injection test
 * Inject a synthetic frame with a known hard edge,
 * verify Sobel detects it (non-zero output at edge location)
 * Input : left half black, right half white — strong vertical edge
 * Expect: Sobel output non-zero at the boundary column
 *******************************************************/
static void test_edge_detection() {
    bsp_printf("\n\r  Edge detection: hard vertical edge input\n\r");

    // Fill left half black, right half white — creates a strong vertical edge
    uint32_t total = (uint32_t)FRAME_WIDTH * (uint32_t)FRAME_HEIGHT;
    for (uint32_t i = 0; i < total; i++) {
        int x = i % FRAME_WIDTH;
        cam_array[i] = (x < FRAME_WIDTH / 2) ? 0x00000000 : 0x00FFFFFF;
    }
    data_cache_invalidate_all();

    // Run HW Sobel on cam_array directly (simulating HW grayscale output)
    TEST("Edge detection: Sobel pipeline completes",
         run_hw_accel(0x00000000, CAM_START_ADDR, SOBEL_START_ADDR));
    data_cache_invalidate_all();

    // Sample pixel at the edge boundary — should be non-zero (edge detected)
    int edge_col = FRAME_WIDTH / 2;
    int mid_row  = FRAME_HEIGHT / 2;
    uint32_t edge_pixel = sobel_array[mid_row * FRAME_WIDTH + edge_col];
    bsp_printf("  edge pixel=0x%08X (expect non-zero)\n\r", edge_pixel);
    TEST("Edge detection: Sobel detects hard vertical edge", edge_pixel != 0x00000000);

    // Sample pixel far from edge — should be zero (no edge)
    uint32_t flat_pixel = sobel_array[mid_row * FRAME_WIDTH + FRAME_WIDTH / 4];
    bsp_printf("  flat pixel=0x%08X (expect 0x00000000)\n\r", flat_pixel);
    TEST("Edge detection: flat region has no edges", flat_pixel == 0x00000000);
}

/*******************************************************
 * Main pipeline test entry point
 *******************************************************/
void test_pipeline() {
    bsp_printf("\n\r-- Pipeline injection tests (single camera) --\n\r");
    bsp_printf("Bypassing camera, injecting synthetic data into DDR\n\r");
    bsp_printf("Running through all 7 demo modes\n\r");

    test_mode_a();
    test_mode_b();
    test_mode_c();
    test_mode_d();
    test_mode_e();
    test_mode_f();
    test_mode_g();
    test_edge_detection();

    // Confirm no FIFOs overflowed across all pipeline runs
    u32 fifo_status = EXAMPLE_APB3_REGR(EXAMPLE_APB3_SLV,
                                         EXAMPLE_APB3_SLV_REG6_OFFSET);
    TEST("No FIFO overflow after all pipeline tests", fifo_status == 0x00000000);
    if (fifo_status != 0)
        bsp_printf("  FIFO status: 0x%08X\n\r", fifo_status);
}
