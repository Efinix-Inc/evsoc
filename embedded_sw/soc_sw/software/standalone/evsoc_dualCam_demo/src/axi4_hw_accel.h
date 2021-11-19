#ifndef AXI4_HW_ACCEL_H
#define AXI4_HW_ACCEL_H

#include "bsp.h"

#define EXAMPLE_AXI4_SLV   SYSTEM_AXI_A_BMB

#define EXAMPLE_AXI4_SLV_REG0_OFFSET   0  //sobel_thresh_val                   (Write)
#define EXAMPLE_AXI4_SLV_REG1_OFFSET   4  //hw_accel_mode                      (Write)
#define EXAMPLE_AXI4_SLV_REG2_OFFSET   8  //hw_accel_mode2                     (Write)
#define EXAMPLE_AXI4_SLV_REG3_OFFSET   12 //dma_wr_init_done                   (Write)
#define EXAMPLE_AXI4_SLV_REG4_OFFSET   16 //32'hABCD_1234                      (Read - verify slave read)
#define EXAMPLE_AXI4_SLV_REG5_OFFSET   20 //debug_hw_accel_fifo_status         (Read)
#define EXAMPLE_AXI4_SLV_REG6_OFFSET   24 //debug_dma1_in_fifo_wcount          (Read)
#define EXAMPLE_AXI4_SLV_REG7_OFFSET   28 //debug_dma2_in_fifo_wcount          (Read)
#define EXAMPLE_AXI4_SLV_REG8_OFFSET   32 //debug_dma_out_fifo_rcount          (Read)
#define EXAMPLE_AXI4_SLV_REG9_OFFSET   36 //debug_dual_cam_scaling_fifo_wcount (Read)
#define EXAMPLE_AXI4_SLV_REG10_OFFSET  40 //debug_dual_cam_scaling_fifo_rcount (Read)

#endif
