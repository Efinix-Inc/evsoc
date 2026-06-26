////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2026 Efinix Inc. All rights reserved.
// See https://github.com/Efinix-Inc/evsoc/blob/main/LICENSE.txt for details.
////////////////////////////////////////////////////////////////////////////////

#include "bsp.h"
#include "vexriscv.h"
#include "plic.h"

#include "board_config.h"
#include "common.h"
#include "camera.h"
#include "apb3_cam.h"
#if defined(BOARD_T120F324) || defined(BOARD_T120F576)
#include "hdmi_config.h"
#include "hdmi_driver.h"
#endif
#include "dmasg.h"
#include "dmasg_config.h"
#include "axi4_hw_accel.h"
#include "isp.h"

// Start address to be divided evenly by 8. Otherwise DMA tkeep might be shifted, not handled in display and hw_accel blocks.
#define cam_array ((volatile uint32_t *)CAM_START_ADDR)
#define grayscale_array ((volatile uint32_t *)GRAYSCALE_START_ADDR)
#define sobel_array ((volatile uint32_t *)SOBEL_START_ADDR)

// Number of frames processing set for timestamp - To be adjusted based anticipated frame processing rate
// For low frame rate scenario, loop count could be set lower to shorten the profiling time.
// For high frame rate scenario, loop count could be set higher to obtain better average frame counts.
#define PROFILING_LOOP 100

/*******************************************************UART & DMA-RELATED FUNCTIONS***************************************************/

// For DMA interrupt
uint32_t cam1_s2mm_active;
uint32_t display_mm2s_active;
uint32_t hw_accel_s2mm_active;
uint32_t hw_accel_mm2s_1_active;

void externalInterrupt()
{
    uint32_t claim;
    // While there is pending interrupts
    while (claim = plic_claim(BSP_PLIC, BSP_PLIC_CPU_0))
    {
        switch (claim)
        {
        case PLIC_DMASG_CHANNEL:
            if (cam1_s2mm_active && !(dmasg_busy(DMASG_BASE, DMASG_CAM1_S2MM_CHANNEL)))
            {
                dmasg_interrupt_config(DMASG_BASE, DMASG_CAM1_S2MM_CHANNEL, 0); // Disable dmasg channel interrupt
                cam1_s2mm_active = 0;
                // interrupt_service_routine();
            }
            if (display_mm2s_active && !(dmasg_busy(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL)))
            {
                dmasg_interrupt_config(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, 0); // Disable dmasg channel interrupt
                display_mm2s_active = 0;
                // interrupt_service_routine();
            }
            if (hw_accel_s2mm_active && !(dmasg_busy(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL)))
            {
                dmasg_interrupt_config(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL, 0); // Disable dmasg channel interrupt
                hw_accel_s2mm_active = 0;
                // interrupt_service_routine();
            }
            if (hw_accel_mm2s_1_active && !(dmasg_busy(DMASG_BASE, DMASG_HW_ACCEL_MM2S_1_CHANNEL)))
            {
                dmasg_interrupt_config(DMASG_BASE, DMASG_HW_ACCEL_MM2S_1_CHANNEL, 0); // Disable dmasg channel interrupt
                hw_accel_mm2s_1_active = 0;
                // interrupt_service_routine();
            }
            break;
        default:
            crash();
            break;
        }
        plic_release(BSP_PLIC, BSP_PLIC_CPU_0, claim); // unmask the claimed interrupt
    }
}

void main()
{

    bsp_printf("\n\rHello Efinix Edge Vision SoC!!\n\n\r");

    // For system profiling
    uint64_t timerCmp0, timerCmp1, timerDiff_0_1;

    /**************************************************SETUP PICAM & HDMI DISPLAY***************************************************/

#if defined(BOARD_T120F324) || defined(BOARD_T120F576) || defined(BOARD_Ti180J484)
    bsp_printf("Init Camera.....");
    Set_MipiRst(1);
    Set_MipiRst(0);

#if defined(BOARD_T120F324) || defined(BOARD_T120576)
    bsp_printf("Init HDMI I2C.....");
    hdmi_i2c_init(I2C_CTRL_HDMI);
    hdmi_init();
    bsp_printf("Done !!\n\r");
#endif

    cam0_init(I2C_CTRL_CAM0);
    bsp_printf("\n\rDone !!\n\r");

#elif defined(BOARD_Ti60F225)
    bsp_printf("Init Camera.....");

    // Assert camera reset
    EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG1_OFFSET, 0x00000000);
    bsp_uDelay(100);
    EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG1_OFFSET, 0x00000002);
    bsp_uDelay(1000 * 10);

    cam0_init(I2C_CTRL_CAM0);

    // Indicate camera configuration done
    EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG1_OFFSET, 0x00000003);
    bsp_printf("Done\n\r");

#endif

    /**********************************************************SETUP DMA***********************************************************/

    bsp_printf("Init DMA.....");

    dma_init();

    dmasg_priority(DMASG_BASE, DMASG_HW_ACCEL_MM2S_1_CHANNEL, 0, 0);
    dmasg_priority(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL, 0, 0);
    dmasg_priority(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, 0, 0);
    dmasg_priority(DMASG_BASE, DMASG_CAM1_S2MM_CHANNEL, 0, 0);

    bsp_printf("Done !!\n\n\r");

    /*******************************************************Trigger Display********************************************************/

    uint32_t rdata;

    // To check display functionality
    bsp_printf("Initialize test display content..\n\r");

    // Array name to be modified to DDR location used for display
    // Colour bar & Red dots at 4 corners of active display

    // Initialize test image in cam_array
    for (int y = 0; y < FRAME_HEIGHT; y++)
    {
        for (int x = 0; x < FRAME_WIDTH; x++)
        {
            if ((x < 3 && y < 3) || (x >= FRAME_WIDTH - 3 && y < 3) || (x < 3 && y >= FRAME_HEIGHT - 3) || (x >= FRAME_WIDTH - 3 && y >= FRAME_HEIGHT - 3))
            {
                cam_array[y * FRAME_WIDTH + x] = 0x000000FF; // RED
            }
            else if (x < (FRAME_WIDTH / 4))
            {
                cam_array[y * FRAME_WIDTH + x] = 0x0000FF00; // GREEN
            }
            else if (x < (FRAME_WIDTH / 4 * 2))
            {
                cam_array[y * FRAME_WIDTH + x] = 0x00FF0000; // BLUE
            }
            else if (x < (FRAME_WIDTH / 4 * 3))
            {
                cam_array[y * FRAME_WIDTH + x] = 0x000000FF; // RED
            }
            else
            {
                cam_array[y * FRAME_WIDTH + x] = 0x00FF0000; // BLUE
            }
        }
    }

    // Trigger display DMA once then the rest handled by DMA self restart
    bsp_printf("\nTrigger display DMA..\n\r");

    // SELECT start address of to be displayed data accordingly
    dmasg_input_memory(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, CAM_START_ADDR, 16);
    // dmasg_input_memory(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, GRAYSCALE_START_ADDR, 16);
    // dmasg_input_memory(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, SOBEL_START_ADDR, 16);

    dmasg_output_stream(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, DMASG_DISPLAY_MM2S_PORT, 0, 0, 1);
    dmasg_direct_start(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, (FRAME_WIDTH * FRAME_HEIGHT) * 4, 1);

    msDelay(5000); // Display test content for 5 seconds

    bsp_printf("Done !!\n\n\r");

    bsp_printf("---SYSTEM PROFILING---\n\r");
    bsp_printf("Start frames processing..\n\n\r");

    timerCmp0 = clint_getTime(BSP_CLINT);

    for (int i = 0; i < PROFILING_LOOP; i++)
    {

        /**********************************************************CAMERA CAPTURE***********************************************************/

        // SELECT RGB or grayscale output from camera pre-processing block.
        EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG3_OFFSET, 0x00000000); // RGB
        // EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG3_OFFSET, 0x00000001); //grayscale

        // Trigger camera DMA
        dmasg_input_stream(DMASG_BASE, DMASG_CAM1_S2MM_CHANNEL, DMASG_CAM1_S2MM_PORT, 1, 0);
        dmasg_output_memory(DMASG_BASE, DMASG_CAM1_S2MM_CHANNEL, CAM_START_ADDR, 16);
        dmasg_direct_start(DMASG_BASE, DMASG_CAM1_S2MM_CHANNEL, (FRAME_WIDTH * FRAME_HEIGHT) * 4, 0);

        // Indicate start of S2MM DMA to camera building block via APB3 slave
        EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG4_OFFSET, 0x00000001);
        EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG4_OFFSET, 0x00000000);

        // Trigger storage of one captured frame via APB3 slave
        EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG2_OFFSET, 0x00000001);
        EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG2_OFFSET, 0x00000000);

        // Wait for DMA transfer completion
        while (dmasg_busy(DMASG_BASE, DMASG_CAM1_S2MM_CHANNEL))
            ;
        data_cache_invalidate_all();
    }

    timerCmp1 = clint_getTime(BSP_CLINT);
    timerDiff_0_1 = timerCmp1 - timerCmp0;

    bsp_printf("DONE frames processing..\n\n\r");

    rdata = example_register_read(EXAMPLE_APB3_SLV_REG12_OFFSET);
    bsp_printf("MIPI Input Frames Per Second : ");
    print_hex(rdata, 8);
    bsp_printf("\n\r");

    bsp_printf("PROCESSING_CLOCK_CYCLES      : "); // Timestamp
    print_hex_64(timerDiff_0_1, 16);
    bsp_printf("\n\r");

    bsp_printf("TIMER_CLOCK_RATE (Hz)    : ");
    print_hex(SYSTEM_CLINT_HZ, 8);
    bsp_printf("\n\r");

    bsp_printf("PROCESSING_LOOP              : ");
    print_hex(PROFILING_LOOP, 8);
    bsp_printf("\n\r");

    bsp_printf("\n\r-------------------------------------------------------------------------------\n\r");
    bsp_printf("Formula for seconds/frame (low frame rate - less than one frame per second) :\n\r");
    bsp_printf("SPF = (PROCESSING_CLOCK_CYCLES/TIMER_CLOCK_RATE)/PROCESSING_LOOP\n\r");

    bsp_printf("\n\rFormula for frames/second (high frame rate - more than one frame per second):\n\r");
    bsp_printf("FPS = 1/SPF\n\r");
    bsp_printf("-------------------------------------------------------------------------------\n\r");

    while (1)
    {
    }
}
