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

/*******************************************************UART & DMA-RELATED FUNCTIONS***************************************************/

// For DMA interrupt
uint32_t cam1_s2mm_active;
uint32_t cam2_s2mm_active;
uint32_t display_mm2s_active;
uint32_t hw_accel_s2mm_active;
uint32_t hw_accel_mm2s_1_active;
uint32_t hw_accel_mm2s_2_active;

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
         if (cam2_s2mm_active && !(dmasg_busy(DMASG_BASE, DMASG_CAM2_S2MM_CHANNEL)))
         {
            dmasg_interrupt_config(DMASG_BASE, DMASG_CAM2_S2MM_CHANNEL, 0); // Disable dmasg channel interrupt
            cam2_s2mm_active = 0;
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
         if (hw_accel_mm2s_2_active && !(dmasg_busy(DMASG_BASE, DMASG_HW_ACCEL_MM2S_2_CHANNEL)))
         {
            dmasg_interrupt_config(DMASG_BASE, DMASG_HW_ACCEL_MM2S_2_CHANNEL, 0); // Disable dmasg channel interrupt
            hw_accel_mm2s_2_active = 0;
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

   /**********************************************************SETUP DMA***********************************************************/

   bsp_printf("Init DMA.....");

   dma_init();

   dmasg_priority(DMASG_BASE, DMASG_CAM1_S2MM_CHANNEL, 0, 0);
   dmasg_priority(DMASG_BASE, DMASG_CAM2_S2MM_CHANNEL, 0, 0);
   dmasg_priority(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, 0, 0);
   dmasg_priority(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL, 0, 0);
   dmasg_priority(DMASG_BASE, DMASG_HW_ACCEL_MM2S_1_CHANNEL, 0, 0);
   dmasg_priority(DMASG_BASE, DMASG_HW_ACCEL_MM2S_2_CHANNEL, 0, 0);

   bsp_printf("Done !!\n\r");

   /*******************************************************Trigger Display********************************************************/

   uint32_t rdata;

   // To check display functionality
   bsp_printf("Init test display content.....");

   // Array name to be modified to DDR location used for display
   // Colour bar & Red dots at 4 corners of active display
   /*
      //Initialize test image in cam1_array
      for (int y=0; y<FRAME_HEIGHT; y++) {
         for (int x=0; x<FRAME_WIDTH; x++) {
            if ((x<3 && y<3) || (x>=FRAME_WIDTH-3 && y<3) || (x<3 && y>=FRAME_HEIGHT-3) || (x>=FRAME_WIDTH-3 && y>=FRAME_HEIGHT-3)) {
               cam1_array [y*FRAME_WIDTH + x] = 0x000000FF; //RED
            } else if (x<(FRAME_WIDTH/4)) {
               cam1_array [y*FRAME_WIDTH + x] = 0x0000FF00; //GREEN
            } else if (x<(FRAME_WIDTH/4 *2)) {
               cam1_array [y*FRAME_WIDTH + x] = 0x00FF0000; //BLUE
            } else if (x<(FRAME_WIDTH/4 *3)) {
               cam1_array [y*FRAME_WIDTH + x] = 0x000000FF; //RED
            } else {
               cam1_array [y*FRAME_WIDTH + x] = 0x00FF0000; //BLUE
            }
         }
      }
   */
   /*
      //Initialize test image in cam2_array
      for (int y=0; y<FRAME_HEIGHT; y++) {
         for (int x=0; x<FRAME_WIDTH; x++) {
            if ((x<3 && y<3) || (x>=FRAME_WIDTH-3 && y<3) || (x<3 && y>=FRAME_HEIGHT-3) || (x>=FRAME_WIDTH-3 && y>=FRAME_HEIGHT-3)) {
               cam2_array [y*FRAME_WIDTH + x] = 0x000000FF; //RED
            } else if (x<(FRAME_WIDTH/4)) {
               cam2_array [y*FRAME_WIDTH + x] = 0x0000FF00; //GREEN
            } else if (x<(FRAME_WIDTH/4 *2)) {
               cam2_array [y*FRAME_WIDTH + x] = 0x00FF0000; //BLUE
            } else if (x<(FRAME_WIDTH/4 *3)) {
               cam2_array [y*FRAME_WIDTH + x] = 0x000000FF; //RED
            } else {
               cam2_array [y*FRAME_WIDTH + x] = 0x00FF0000; //BLUE
            }
         }
      }
   */

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

   // SELECT start address of to be displayed data accordingly
   // dmasg_input_memory(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, CAM1_START_ADDR, 16);
   // dmasg_input_memory(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, CAM2_START_ADDR, 16);
   dmasg_input_memory(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, HW_ACCEL_START_ADDR, 16);

   dmasg_output_stream(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, DMASG_DISPLAY_MM2S_PORT, 0, 0, 1);
   dmasg_direct_start(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL, (FRAME_WIDTH * FRAME_HEIGHT) * 4, 1);

   bsp_printf("Done !!\n\n\r");

   msDelay(5000); // Display test content for 5 seconds

   while (1)
   {

      /**********************************************************CAMERA CAPTURE***********************************************************/

      // bsp_printf("\nTrigger camera capture..\n\r");

      // SELECT RGB or grayscale output from camera pre-processing block (cam1)
      EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG3_OFFSET, 0x00000000); // RGB
      // EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG3_OFFSET, 0x00000001); //grayscale

      // SELECT RGB or grayscale output from camera pre-processing block (cam2)
      EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG7_OFFSET, 0x00000000); // RGB
      // EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG7_OFFSET, 0x00000001); //grayscale

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

      /**********************************************************HW Accelerator***********************************************************/

      // bsp_printf("\nHardware acceleration..\n\r");

      // SET Sobel edge detection threshold via AXI4 slave
      write_u32(100, EXAMPLE_AXI4_SLV + EXAMPLE_AXI4_SLV_REG0_OFFSET); // Default value 100; Range 0 to 255

      // SELECT HW accelerator mode - Processing
      write_u32(0x00000000, EXAMPLE_AXI4_SLV + EXAMPLE_AXI4_SLV_REG1_OFFSET); // 2'd0: Cam source 1 - Passthrough;       Cam source 2 - Passthrough
      // write_u32(0x00000001, EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG1_OFFSET); //2'd1: Cam source 1 - Passthrough;       Cam source 2 - Processed (Sobel)
      // write_u32(0x00000002, EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG1_OFFSET); //2'd2: Cam source 1 - Processed (Sobel); Cam source 2 - Passthrough
      // write_u32(0x00000003, EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG1_OFFSET); //2'd3: Cam source 1 - Processed (Sobel); Cam source 2 - Processed (Sobel)

      // SELECT HW accelerator mode - Merging
      // 1'b0: Merge frame data from cam source 1 (cropped by half, left side) and cam source 2 (cropped by half, right side)
      write_u32(0x00000000, EXAMPLE_AXI4_SLV + EXAMPLE_AXI4_SLV_REG2_OFFSET);
      // 1'b1: Merge frame data from cam source 1 (main) and cam source 2 (downscaled overlay)
      // write_u32(0x00000001, EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG2_OFFSET);

      // Trigger HW accel MM2S DMA (Cam1)
      dmasg_input_memory(DMASG_BASE, DMASG_HW_ACCEL_MM2S_1_CHANNEL, CAM1_START_ADDR, 16);
      dmasg_output_stream(DMASG_BASE, DMASG_HW_ACCEL_MM2S_1_CHANNEL, DMASG_HW_ACCEL_MM2S_1_PORT, 0, 0, 1);
      // Additional data is fed for Sobel/Passthrough line buffer data flushing
      dmasg_direct_start(DMASG_BASE, DMASG_HW_ACCEL_MM2S_1_CHANNEL, ((FRAME_WIDTH * FRAME_HEIGHT) + (FRAME_WIDTH + 1)) * 4, 0);

      // Trigger HW accel MM2S DMA (Cam2)
      dmasg_input_memory(DMASG_BASE, DMASG_HW_ACCEL_MM2S_2_CHANNEL, CAM2_START_ADDR, 16);
      dmasg_output_stream(DMASG_BASE, DMASG_HW_ACCEL_MM2S_2_CHANNEL, DMASG_HW_ACCEL_MM2S_2_PORT, 0, 0, 1);
      // Additional data is fed for Sobel/Passthrough line buffer data flushing
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

   /***********************************************Check AXI4 Slave Status (HW Accelerator)********************************************/
   /*
      bsp_printf("\nHW accelerator AXI4 status..\n\r");

      //Verify slave read operation. Expecting 32'hABCD_1234
      rdata = axi_slave_read32(EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG4_OFFSET);
      bsp_printf("test_value :");
      print_hex(rdata, 8);
      bsp_printf("\n\r");

      //LSB: {debug_dma1_in_fifo_underflow, debug_dma1_in_fifo_overflow, debug_dma2_in_fifo_underflow, debug_dma2_in_fifo_overflow,
      //      debug_dma_out_fifo_underflow, debug_dma_out_fifo_overflow, debug_dual_cam_scaling_fifo_underflow, debug_dual_cam_scaling_fifo_overflow}
      rdata = axi_slave_read32(EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG5_OFFSET);
      bsp_printf("debug_hw_accel_fifo_status :");
      print_hex(rdata, 8);
      bsp_printf("\n\r");

      //debug_dma1_in_fifo_wcount
      rdata = axi_slave_read32(EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG6_OFFSET);
      bsp_printf("debug_dma1_in_fifo_wcount :");
      print_hex(rdata, 8);
      bsp_printf("\n\r");

      //debug_dma2_in_fifo_wcount
      rdata = axi_slave_read32(EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG7_OFFSET);
      bsp_printf("debug_dma2_in_fifo_wcount :");
      print_hex(rdata, 8);
      bsp_printf("\n\r");

      //debug_dma_out_fifo_rcount
      rdata = axi_slave_read32(EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG8_OFFSET);
      bsp_printf("debug_dma_out_fifo_rcount :");
      print_hex(rdata, 8);
      bsp_printf("\n\r");

      //debug_dual_cam_scaling_fifo_wcount
      rdata = axi_slave_read32(EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG9_OFFSET);
      bsp_printf("debug_dual_cam_scaling_fifo_wcount :");
      print_hex(rdata, 8);
      bsp_printf("\n\r");

      //debug_dual_cam_scaling_fifo_rcount
      rdata = axi_slave_read32(EXAMPLE_AXI4_SLV+EXAMPLE_AXI4_SLV_REG10_OFFSET);
      bsp_printf("debug_dual_cam_scaling_fifo_rcount :");
      print_hex(rdata, 8);
      bsp_printf("\n\r");
   */

   /**********************************************Check APB3 Slave Status (Camera & Display)******************************************/
   /*
      bsp_printf("\nCamera and display APB3 status..\n\r");

      //Verify slave read operation. Expecting 32'hABCD_5678
      rdata = example_register_read(EXAMPLE_APB3_SLV_REG9_OFFSET);
      bsp_printf("test_value :");
      print_hex(rdata, 8);
      bsp_printf("\n\r");

      //{22'd0, debug_cam1_pixel_remap_fifo_underflow, debug_cam1_pixel_remap_fifo_overflow, debug_cam1_dma_fifo_underflow, debug_cam1_dma_fifo_overflow,
      //debug_cam2_pixel_remap_fifo_underflow, debug_cam2_pixel_remap_fifo_overflow, debug_cam2_dma_fifo_underflow, debug_cam2_dma_fifo_overflow,
      //debug_display_dma_fifo_underflow, debug_display_dma_fifo_overflow};
      rdata = example_register_read(EXAMPLE_APB3_SLV_REG10_OFFSET);
      bsp_printf("debug_fifo_status :");
      print_hex(rdata, 8);
      bsp_printf("\n\r");

      //debug_display_dma_fifo_rcount
      rdata = example_register_read(EXAMPLE_APB3_SLV_REG11_OFFSET);
      bsp_printf("debug_display_dma_fifo_rcount :");
      print_hex(rdata, 8);
      bsp_printf("\n\r");

      //debug_display_dma_fifo_wcount
      rdata = example_register_read(EXAMPLE_APB3_SLV_REG12_OFFSET);
      bsp_printf("debug_display_dma_fifo_wcount :");
      print_hex(rdata, 8);
      bsp_printf("\n\r");

      //cam1_frames_per_second
      rdata = example_register_read(EXAMPLE_APB3_SLV_REG13_OFFSET);
      bsp_printf("cam1_frames_per_second :");
      print_hex(rdata, 8);
      bsp_printf("\n\r");

      //debug_cam1_dma_fifo_rcount
      rdata = example_register_read(EXAMPLE_APB3_SLV_REG14_OFFSET);
      bsp_printf("debug_cam1_dma_fifo_rcount :");
      print_hex(rdata, 8);
      bsp_printf("\n\r");

      //debug_cam1_dma_fifo_wcount
      rdata = example_register_read(EXAMPLE_APB3_SLV_REG15_OFFSET);
      bsp_printf("debug_cam1_dma_fifo_wcount :");
      print_hex(rdata, 8);
      bsp_printf("\n\r");

      //debug_cam1_dma_status
      rdata = example_register_read(EXAMPLE_APB3_SLV_REG16_OFFSET);
      bsp_printf("debug_cam1_dma_status :");
      print_hex(rdata, 8);
      bsp_printf("\n\r");

      //cam2_frames_per_second
      rdata = example_register_read(EXAMPLE_APB3_SLV_REG17_OFFSET);
      bsp_printf("cam2_frames_per_second :");
      print_hex(rdata, 8);
      bsp_printf("\n\r");

      //debug_cam2_dma_fifo_rcount
      rdata = example_register_read(EXAMPLE_APB3_SLV_REG18_OFFSET);
      bsp_printf("debug_cam2_dma_fifo_rcount :");
      print_hex(rdata, 8);
      bsp_printf("\n\r");

      //debug_cam2_dma_fifo_wcount
      rdata = example_register_read(EXAMPLE_APB3_SLV_REG19_OFFSET);
      bsp_printf("debug_cam2_dma_fifo_wcount :");
      print_hex(rdata, 8);
      bsp_printf("\n\r");

      //debug_cam2_dma_status
      rdata = example_register_read(EXAMPLE_APB3_SLV_REG20_OFFSET);
      bsp_printf("debug_cam2_dma_status :");
      print_hex(rdata, 8);
      bsp_printf("\n\r");
   */

   while (1)
   {
   }
}
