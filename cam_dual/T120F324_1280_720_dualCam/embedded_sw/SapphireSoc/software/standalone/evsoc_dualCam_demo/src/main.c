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
#define cam1_array ((volatile uint32_t *)CAM1_START_ADDR)
#define cam2_array ((volatile uint32_t *)CAM2_START_ADDR)
#define hw_accel_array ((volatile uint32_t *)HW_ACCEL_START_ADDR)

/*******************************************************UART-RELATED FUNCTIONS******************************************************/

// For DMA interrupt
uint32_t select_demo_mode;        // For demo mode selection
uint32_t display_mm2s_active = 0; // For DMA interrupt

void uart_interrupt_init()
{
   // UART init
   bsp_init();

   uart_status_write(BSP_UART_TERMINAL, uart_status_read(BSP_UART_TERMINAL) | 0x02); // RX FIFO not empty interrupt enable

   // Enable SYSTEM_PLIC_USER_INTERRUPT_A_INTERRUPT rising edge interrupt
   plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, SYSTEM_PLIC_SYSTEM_UART_0_IO_INTERRUPT, 1);
   plic_set_priority(BSP_PLIC, SYSTEM_PLIC_SYSTEM_UART_0_IO_INTERRUPT, 2); // 1
}

void uart_demo_mode_selection()
{
   u32 uart_user_input;
   if (uart_status_read(BSP_UART_TERMINAL) & 0x00000200)
   {

      uart_status_write(BSP_UART_TERMINAL, uart_status_read(BSP_UART_TERMINAL) & 0xFFFFFFFD); // RX FIFO not empty interrupt Disable
      uart_user_input = uart_read(BSP_UART_TERMINAL);
      uart_status_write(BSP_UART_TERMINAL, uart_status_read(BSP_UART_TERMINAL) | 0x02); // RX FIFO not empty interrupt enable

      // Assign UART input for demo mode selection
      if (uart_user_input == 'a')
      {
         select_demo_mode = 0;
         bsp_printf("Selected Demo Mode: a\n\r");
      }
      else if (uart_user_input == 'b')
      {
         select_demo_mode = 1;
         bsp_printf("Selected Demo Mode: b\n\r");
      }
      else if (uart_user_input == 'c')
      {
         select_demo_mode = 2;
         bsp_printf("Selected Demo Mode: c\n\r");
      }
      else if (uart_user_input == 'd')
      {
         select_demo_mode = 3;
         bsp_printf("Selected Demo Mode: d\n\r");
      }
      else
      {
         select_demo_mode = 4;
         bsp_printf("Selected Demo Mode: e\n\r");
      }
   }
}

void externalInterrupt()
{
   uint32_t claim;
   // While there is pending interrupts
   while (claim = plic_claim(BSP_PLIC, BSP_PLIC_CPU_0))
   {
      switch (claim)
      {
      case SYSTEM_PLIC_SYSTEM_UART_0_IO_INTERRUPT:
         uart_demo_mode_selection();
         break;
      default:
         crash();
         break;
      }
      plic_release(BSP_PLIC, BSP_PLIC_CPU_0, claim); // unmask the claimed interrupt
   }
}

/*******************************************************DEMO-RELATED FUNCTIONS******************************************************/

void dualCam_menu()
{
   bsp_printf("================================================================================\n\r");
   bsp_printf("                    Dual-Camera Design Scenario Selection\n\r");
   bsp_printf("================================================================================\n\r");

   bsp_printf("'a' : Merge Left + Right   - RGB Colour (cam 1) + RGB Colour (cam 2)            \n\r");
   bsp_printf("'b' : Merge Main + Overlay - RGB Colour (cam 1) + RGB Colour (cam 2)            \n\r");
   bsp_printf("'c' : Merge Main + Overlay - RGB Colour (cam 2) + RGB Colour (cam 1)            \n\r");
   bsp_printf("'d' : Merge Main + Overlay - Grayscale  (cam 1) + Sobel      (cam 2)            \n\r");
   bsp_printf("'e' : Merge Main + Overlay - Sobel      (cam 1) + Sobel      (cam 2)            \n\r");

   bsp_printf("================================================================================\n\n\r");
}

void main()
{

   bsp_printf("\n\rHello Efinix Edge Vision SoC (Dual-Camera)!!\n\n\r");

   /**************************************************SETUP PICAM & HDMI DISPLAY***************************************************/

   bsp_printf("Init Camera.....");
   Set_MipiRst(1);
   Set_MipiRst(0);

   bsp_printf("Init HDMI I2C.....");
   hdmi_i2c_init(I2C_CTRL_HDMI);
   hdmi_init();
   bsp_printf("Done !!\n\r");

   cam0_init(I2C_CTRL_CAM0);
   cam1_init(I2C_CTRL_CAM1);
   bsp_printf("\n\rDone !!\n\r");

   /*******************************************************SETUP DMA & UART********************************************************/

   bsp_printf("Init DMA & UART.....");

   uart_interrupt_init();
   dma_init();

   dmasg_priority(DMASG_BASE, DMASG_CAM1_S2MM_CHANNEL, 0, 0);
   dmasg_priority(DMASG_BASE, DMASG_CAM2_S2MM_CHANNEL, 0, 0);
   dmasg_priority(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, 0, 0);
   dmasg_priority(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL, 0, 0);
   dmasg_priority(DMASG_BASE, DMASG_HW_ACCEL_MM2S_1_CHANNEL, 0, 0);
   dmasg_priority(DMASG_BASE, DMASG_HW_ACCEL_MM2S_2_CHANNEL, 0, 0);

   bsp_printf("Done !!\n\r");

   /*******************************************************Trigger Display********************************************************/

   u32 rdata;

   select_demo_mode = 0; // Default

   // To check display functionality
   bsp_printf("Init test display content.....");

   // Array name to be modified to DDR location used for display
   // Colour bar & Red dots at 4 corners of active display

   // Initialize test image in hw_accel_array
   for (int y = 0; y < FRAME_HEIGHT; y++)
   {
      for (int x = 0; x < FRAME_WIDTH; x++)
      {
         if ((x < 3 && y < 3) || (x >= FRAME_WIDTH - 3 && y < 3) || (x < 3 && y >= FRAME_HEIGHT - 3) || (x >= FRAME_WIDTH - 3 && y >= FRAME_HEIGHT - 3))
         {
            hw_accel_array[y * FRAME_WIDTH + x] = 0x000000FF; // RED
         }
         else if (x < (FRAME_WIDTH / 4))
         {
            hw_accel_array[y * FRAME_WIDTH + x] = 0x0000FF00; // GREEN
         }
         else if (x < (FRAME_WIDTH / 4 * 2))
         {
            hw_accel_array[y * FRAME_WIDTH + x] = 0x00FF0000; // BLUE
         }
         else if (x < (FRAME_WIDTH / 4 * 3))
         {
            hw_accel_array[y * FRAME_WIDTH + x] = 0x000000FF; // RED
         }
         else
         {
            hw_accel_array[y * FRAME_WIDTH + x] = 0x00FF0000; // BLUE
         }
      }
   }

   bsp_printf("Done !!\n\r");

   // Trigger display DMA once then the rest handled by DMA self restart
   bsp_printf("\nTrigger display DMA.....");

   dmasg_input_memory(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, HW_ACCEL_START_ADDR, 16);
   dmasg_output_stream(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, DMASG_DISPLAY_MM2S_PORT, 0, 0, 1);
   dmasg_direct_start(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, (FRAME_WIDTH * FRAME_HEIGHT) * 4, 1);

   bsp_printf("Done !!\n\n\r");

   msDelay(5000); // Display test content for 5 seconds

   dualCam_menu();

   bsp_printf("Default Demo Mode: a\n\r");

   while (1)
   {

      /**********************************************************CAMERA CAPTURE***********************************************************/

      // bsp_printf("\nTrigger camera capture..\n\r");

      // SELECT RGB or grayscale output from camera pre-processing block (cam1)
      if (select_demo_mode < 3)
      {
         EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG3_OFFSET, 0x00000000); // RGB
      }
      else
      {
         EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG3_OFFSET, 0x00000001); // grayscale
      }

      // SELECT RGB or grayscale output from camera pre-processing block (cam2)
      if (select_demo_mode < 3)
      {
         EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG7_OFFSET, 0x00000000); // RGB
      }
      else
      {
         EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG7_OFFSET, 0x00000001); // grayscale
      }

      // Trigger camera DMA (cam1)
      dmasg_input_stream(DMASG_BASE, DMASG_CAM1_S2MM_CHANNEL, DMASG_CAM1_S2MM_PORT, 1, 0);
      dmasg_output_memory(DMASG_BASE, DMASG_CAM1_S2MM_CHANNEL, CAM1_START_ADDR, 16);
      dmasg_direct_start(DMASG_BASE, DMASG_CAM1_S2MM_CHANNEL, (FRAME_WIDTH * FRAME_HEIGHT) * 4, 0);

      // Trigger camera DMA (cam2)
      dmasg_input_stream(DMASG_BASE, DMASG_CAM2_S2MM_CHANNEL, DMASG_CAM2_S2MM_PORT, 1, 0);
      dmasg_output_memory(DMASG_BASE, DMASG_CAM2_S2MM_CHANNEL, CAM2_START_ADDR, 16);
      dmasg_direct_start(DMASG_BASE, DMASG_CAM2_S2MM_CHANNEL, (FRAME_WIDTH * FRAME_HEIGHT) * 4, 0);

      // Indicate start of S2MM DMA to camera building block via APB3 slave (cam1)
      EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG4_OFFSET, 0x00000001);
      EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG4_OFFSET, 0x00000000);

      // Indicate start of S2MM DMA to camera building block via APB3 slave (cam2)
      EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG8_OFFSET, 0x00000001);
      EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG8_OFFSET, 0x00000000);

      // Trigger storage of one captured frame via APB3 slave (cam1)
      EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG2_OFFSET, 0x00000001);
      EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG2_OFFSET, 0x00000000);

      // Trigger storage of one captured frame via APB3 slave (cam2)
      EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG6_OFFSET, 0x00000001);
      EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG6_OFFSET, 0x00000000);

      // Wait for DMA transfer completion
      while (dmasg_busy(DMASG_BASE, DMASG_CAM1_S2MM_CHANNEL) || dmasg_busy(DMASG_BASE, DMASG_CAM2_S2MM_CHANNEL))
         ;
      data_cache_invalidate_all();

      // bsp_printf("Done !!\n\n\r");

      /*******************************************************RISC-V Processing***********************************************************/
      /*
            //bsp_printf("\nRISC-V processing..\n\r");

            //...

            //bsp_printf("Done !!\n\n\r");
      */
      /**********************************************************HW Accelerator***********************************************************/

      // bsp_printf("\nHardware acceleration..\n\r");
      // SET Sobel edge detection threshold via AXI4 slave
      write_u32(100, EXAMPLE_AXI4_SLV + EXAMPLE_AXI4_SLV_REG0_OFFSET); // Default value 100; Range 0 to 255

      // SELECT HW accelerator mode - Image Merger
      if (select_demo_mode < 3)
      {
         write_u32(0x00000000, EXAMPLE_AXI4_SLV + EXAMPLE_AXI4_SLV_REG1_OFFSET); // 2'd0: Cam source 1 - Passthrough;       Cam source 2 - Passthrough
      }
      else if (select_demo_mode == 3)
      {
         write_u32(0x00000001, EXAMPLE_AXI4_SLV + EXAMPLE_AXI4_SLV_REG1_OFFSET); // 2'd1: Cam source 1 - Passthrough;       Cam source 2 - Processed (Sobel)
      }
      else if (select_demo_mode == 4)
      {
         write_u32(0x00000003, EXAMPLE_AXI4_SLV + EXAMPLE_AXI4_SLV_REG1_OFFSET); // 2'd3: Cam source 1 - Processed (Sobel); Cam source 2 - Processed (Sobel)
      }
      else
      {                                                                          // Not applicable for the listed demo scenarios
         write_u32(0x00000002, EXAMPLE_AXI4_SLV + EXAMPLE_AXI4_SLV_REG1_OFFSET); // 2'd2: Cam source 1 - Processed (Sobel); Cam source 2 - Passthrough
      }

      if (select_demo_mode == 0)
      {
         // Merge frame data from cam source 1 (cropped by half, left side) and cam source 2 (cropped by half, right side)
         write_u32(0x00000000, EXAMPLE_AXI4_SLV + EXAMPLE_AXI4_SLV_REG2_OFFSET);
      }
      else
      {
         // Merge frame data from cam source 1 (main) and cam source 2 (downscaled overlay)
         write_u32(0x00000001, EXAMPLE_AXI4_SLV + EXAMPLE_AXI4_SLV_REG2_OFFSET);
      }

      // Trigger HW accel MM2S DMA
      if (select_demo_mode == 2)
      {
         dmasg_input_memory(DMASG_BASE, DMASG_HW_ACCEL_MM2S_1_CHANNEL, CAM2_START_ADDR, 16);
      }
      else
      {
         dmasg_input_memory(DMASG_BASE, DMASG_HW_ACCEL_MM2S_1_CHANNEL, CAM1_START_ADDR, 16);
      }
      dmasg_output_stream(DMASG_BASE, DMASG_HW_ACCEL_MM2S_1_CHANNEL, DMASG_HW_ACCEL_MM2S_1_PORT, 0, 0, 1);
      dmasg_direct_start(DMASG_BASE, DMASG_HW_ACCEL_MM2S_1_CHANNEL, ((FRAME_WIDTH * FRAME_HEIGHT) + (FRAME_WIDTH + 1)) * 4, 0);

      // Trigger HW accel MM2S DMA
      if (select_demo_mode == 2)
      {
         dmasg_input_memory(DMASG_BASE, DMASG_HW_ACCEL_MM2S_2_CHANNEL, CAM1_START_ADDR, 16);
      }
      else
      {
         dmasg_input_memory(DMASG_BASE, DMASG_HW_ACCEL_MM2S_2_CHANNEL, CAM2_START_ADDR, 16);
      }
      dmasg_output_stream(DMASG_BASE, DMASG_HW_ACCEL_MM2S_2_CHANNEL, DMASG_HW_ACCEL_MM2S_2_PORT, 0, 0, 1);

      dmasg_direct_start(DMASG_BASE, DMASG_HW_ACCEL_MM2S_2_CHANNEL, ((FRAME_WIDTH * FRAME_HEIGHT) + (FRAME_WIDTH + 1)) * 4, 0);

      // Trigger HW accel S2MM DMA
      dmasg_input_stream(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL, DMASG_HW_ACCEL_S2MM_PORT, 1, 0);
      dmasg_output_memory(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL, HW_ACCEL_START_ADDR, 16);
      dmasg_direct_start(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL, (FRAME_WIDTH * FRAME_HEIGHT) * 4, 0);

      // Indicate start of S2MM DMA to HW accel building block via APB3 slave
      write_u32(0x00000001, EXAMPLE_AXI4_SLV + EXAMPLE_AXI4_SLV_REG3_OFFSET);
      write_u32(0x00000000, EXAMPLE_AXI4_SLV + EXAMPLE_AXI4_SLV_REG3_OFFSET);

      // Wait for DMA transfer completion
      while (dmasg_busy(DMASG_BASE, DMASG_HW_ACCEL_MM2S_1_CHANNEL) || dmasg_busy(DMASG_BASE, DMASG_HW_ACCEL_MM2S_2_CHANNEL) ||
             dmasg_busy(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL))
         ;
      data_cache_invalidate_all();

      // bsp_printf("Done !!\n\n\r");
   }

   while (1)
   {
   }
}
