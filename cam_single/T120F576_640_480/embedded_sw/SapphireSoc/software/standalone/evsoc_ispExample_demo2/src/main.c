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

/*******************************************************DMA-RELATED FUNCTIONS******************************************************/

// For DMA interrupt
uint32_t select_demo_mode = 0;
uint32_t display_mm2s_active = 0;

void trigger_next_display_dma()
{

    // SELECT start address of to be displayed data accordingly
    if (select_demo_mode == 0)
    {
        dmasg_input_memory(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, CAM_START_ADDR, 16);
    }
    else
    {
        dmasg_input_memory(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, SOBEL_START_ADDR, 16);
    }

    dmasg_output_stream(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, DMASG_DISPLAY_MM2S_PORT, 0, 0, 1);
    dmasg_interrupt_config(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, DMASG_CHANNEL_INTERRUPT_CHANNEL_COMPLETION_MASK);
    dmasg_direct_start(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, (FRAME_WIDTH * FRAME_HEIGHT) * 4, 0);
}

void externalInterrupt()
{
    uint32_t claim;
    // While there is pending interrupts
    while (claim = plic_claim(BSP_PLIC, BSP_PLIC_CPU_0))
    {
        switch (claim)
        {
        // DMA interrupt
        case PLIC_DMASG_CHANNEL:
            if (display_mm2s_active && !(dmasg_busy(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL)))
            {
                trigger_next_display_dma();
            }
            break;

        default:
            crash();
            break;
        }
        plic_release(BSP_PLIC, BSP_PLIC_CPU_0, claim); // unmask the claimed interrupt
    }
}

/*******************************************************DEMO-RELATED FUNCTIONS******************************************************/

void ispExample_menu()
{
    bsp_printf("================================================================================\n\r");
    bsp_printf("                    ISP Example Design Scenario Selection\n\r");
    bsp_printf("================================================================================\n\r");

    bsp_printf("00 : Camera Capture + HDMI Display                                             \n\r");
    bsp_printf("01 : Camera Capture + RGB2Grayscale (SW) + Sobel (HW) + HDMI Display           \n\r");
    bsp_printf("10 : Camera Capture + RGB2Grayscale & Sobel (HW) + HDMI Display                \n\r");
    bsp_printf("11 : Camera Capture + RGB2Grayscale & Sobel & Dilation (HW) + HDMI Display     \n\r");

    bsp_printf("================================================================================\n\n\r");
}

/****************************************************************MAIN**************************************************************/

void main()
{

    bsp_printf("\n\rHello Efinix Edge Vision SoC!!\n\n\r");

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

    // Read demo mode from user DIP switches
    select_demo_mode = example_register_read(EXAMPLE_APB3_SLV_REG13_OFFSET);

    // To check display functionality
    bsp_printf("Initialize test display content..\n\r");

    // Array name to be modified to DDR location used for display
    // Colour bar & Red dots at 4 corners of active display
    if (select_demo_mode == 0)
    {
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
    }
    else
    {
        // Initialize test image in sobel_array
        for (int y = 0; y < FRAME_HEIGHT; y++)
        {
            for (int x = 0; x < FRAME_WIDTH; x++)
            {
                if ((x < 3 && y < 3) || (x >= FRAME_WIDTH - 3 && y < 3) || (x < 3 && y >= FRAME_HEIGHT - 3) || (x >= FRAME_WIDTH - 3 && y >= FRAME_HEIGHT - 3))
                {
                    sobel_array[y * FRAME_WIDTH + x] = 0x000000FF; // RED
                }
                else if (x < (FRAME_WIDTH / 4))
                {
                    sobel_array[y * FRAME_WIDTH + x] = 0x0000FF00; // GREEN
                }
                else if (x < (FRAME_WIDTH / 4 * 2))
                {
                    sobel_array[y * FRAME_WIDTH + x] = 0x00FF0000; // BLUE
                }
                else if (x < (FRAME_WIDTH / 4 * 3))
                {
                    sobel_array[y * FRAME_WIDTH + x] = 0x000000FF; // RED
                }
                else
                {
                    sobel_array[y * FRAME_WIDTH + x] = 0x00FF0000; // BLUE
                }
            }
        }
    }

    // Trigger display DMA once then the rest handled by DMA self restart
    bsp_printf("\nTrigger display DMA..\n\r");

    // SELECT start address of to be displayed data accordingly
    if (select_demo_mode == 0)
    {
        dmasg_input_memory(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, CAM_START_ADDR, 16);
    }
    else
    {
        dmasg_input_memory(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, SOBEL_START_ADDR, 16);
    }

    dmasg_output_stream(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, DMASG_DISPLAY_MM2S_PORT, 0, 0, 1);
    dmasg_interrupt_config(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, DMASG_CHANNEL_INTERRUPT_CHANNEL_COMPLETION_MASK);
    dmasg_direct_start(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, (FRAME_WIDTH * FRAME_HEIGHT) * 4, 0);
    display_mm2s_active = 1; // Display always active

    msDelay(5000); // Display test content for 5 seconds

    bsp_printf("Done !!\n\n\r");

    ispExample_menu();

    bsp_printf("Adjust user DIP switches for demo mode selection.\n\n\r");

    while (1)
    {

        /**********************************************************CAMERA CAPTURE***********************************************************/

        // bsp_printf("\nTrigger camera capture..\n\r");

        // SELECT RGB or grayscale output from camera pre-processing block.
        if (select_demo_mode == 2 || select_demo_mode == 3)
        {
            EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG3_OFFSET, 0x00000001); // grayscale
        }
        else
        {
            EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG3_OFFSET, 0x00000000); // RGB
        }

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

        /*******************************************************RISC-V Processing***********************************************************/

        if (select_demo_mode == 1)
        {
            rgb2grayscale(cam_array, grayscale_array, FRAME_WIDTH, FRAME_HEIGHT);
        }

        /**********************************************************HW Accelerator***********************************************************/

        if (select_demo_mode > 0)
        {

            // SET Sobel edge detection threshold via AXI4 slave
            write_u32(100, EXAMPLE_AXI4_SLV + EXAMPLE_AXI4_SLV_REG0_OFFSET); // Default value 100; Range 0 to 255

            // SELECT HW accelerator mode - Make sure match with DMA transfer length setting
            if (select_demo_mode == 3)
            {
                write_u32(0x00000001, EXAMPLE_AXI4_SLV + EXAMPLE_AXI4_SLV_REG1_OFFSET); // 2'd1: Sobel+Dilation
            }
            else
            {
                write_u32(0x00000000, EXAMPLE_AXI4_SLV + EXAMPLE_AXI4_SLV_REG1_OFFSET); // 2'd0: Sobel only
            }

            // Trigger HW accel MM2S DMA
            // SELECT start address of DMA input to HW accel block
            if (select_demo_mode == 2 || select_demo_mode == 3)
            {
                dmasg_input_memory(DMASG_BASE, DMASG_HW_ACCEL_MM2S_1_CHANNEL, CAM_START_ADDR, 16); // Camera pre-processing block performs HW RGB2grayscale conversion
            }
            else
            {
                dmasg_input_memory(DMASG_BASE, DMASG_HW_ACCEL_MM2S_1_CHANNEL, GRAYSCALE_START_ADDR, 16); // RISC-V performs SW RGB2grayscale conversion
            }

            dmasg_output_stream(DMASG_BASE, DMASG_HW_ACCEL_MM2S_1_CHANNEL, DMASG_HW_ACCEL_MM2S_1_PORT, 0, 0, 1);

            // SELECT dma transfer length - Make sure match with HW accelerator mode selection
            // Additonal data is required to be fed for line buffer(s) data flushing
            if (select_demo_mode == 3)
            {
                dmasg_direct_start(DMASG_BASE, DMASG_HW_ACCEL_MM2S_1_CHANNEL, ((FRAME_WIDTH * FRAME_HEIGHT) + (2 * FRAME_WIDTH + 2)) * 4, 0); // Sobel + Dilation/Erosion
            }
            else
            {
                dmasg_direct_start(DMASG_BASE, DMASG_HW_ACCEL_MM2S_1_CHANNEL, ((FRAME_WIDTH * FRAME_HEIGHT) + (FRAME_WIDTH + 1)) * 4, 0); // Sobel only
            }

            // Trigger HW accel S2MM DMA
            dmasg_input_stream(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL, DMASG_HW_ACCEL_S2MM_PORT, 1, 0);
            dmasg_output_memory(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL, SOBEL_START_ADDR, 16);
            dmasg_direct_start(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL, (FRAME_WIDTH * FRAME_HEIGHT) * 4, 0);

            // Indicate start of S2MM DMA to HW accel building block via APB3 slave
            write_u32(0x00000001, EXAMPLE_AXI4_SLV + EXAMPLE_AXI4_SLV_REG2_OFFSET);
            write_u32(0x00000000, EXAMPLE_AXI4_SLV + EXAMPLE_AXI4_SLV_REG2_OFFSET);

            // Wait for DMA transfer completion
            while (dmasg_busy(DMASG_BASE, DMASG_HW_ACCEL_MM2S_1_CHANNEL) || dmasg_busy(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL))
                ;
            data_cache_invalidate_all();
        }
    }
}