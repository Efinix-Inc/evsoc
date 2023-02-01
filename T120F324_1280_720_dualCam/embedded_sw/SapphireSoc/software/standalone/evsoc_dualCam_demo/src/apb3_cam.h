#ifndef APB3_CAM_H
#define APB3_CAM_H

#include "bsp.h"

#define DELAY_BUSY   5

#define EXAMPLE_APB3_SLV   IO_APB_SLAVE_0_INPUT
#define EXAMPLE_APB3_SLV_REG0_OFFSET   0  //mipi_rst
#define EXAMPLE_APB3_SLV_REG1_OFFSET   4  //cam1_rgb_control
#define EXAMPLE_APB3_SLV_REG2_OFFSET   8  //cam1_trigger_capture_frame
#define EXAMPLE_APB3_SLV_REG3_OFFSET   12 //cam1_rgb_gray
#define EXAMPLE_APB3_SLV_REG4_OFFSET   16 //cam1_dma_init_done
#define EXAMPLE_APB3_SLV_REG5_OFFSET   20 //cam2_rgb_control
#define EXAMPLE_APB3_SLV_REG6_OFFSET   24 //cam2_trigger_capture_frame
#define EXAMPLE_APB3_SLV_REG7_OFFSET   28 //cam2_rgb_gray
#define EXAMPLE_APB3_SLV_REG8_OFFSET   32 //cam2_dma_init_done
#define EXAMPLE_APB3_SLV_REG9_OFFSET   36 //Expect 32'hABCD_5678 - Verify slave read operation
#define EXAMPLE_APB3_SLV_REG10_OFFSET  40 //debug_fifo_status
#define EXAMPLE_APB3_SLV_REG11_OFFSET  44 //debug_display_dma_fifo_rcount
#define EXAMPLE_APB3_SLV_REG12_OFFSET  48 //debug_display_dma_fifo_wcount
#define EXAMPLE_APB3_SLV_REG13_OFFSET  52 //cam1_frames_per_second
#define EXAMPLE_APB3_SLV_REG14_OFFSET  56 //debug_cam1_dma_fifo_rcount
#define EXAMPLE_APB3_SLV_REG15_OFFSET  60 //debug_cam1_dma_fifo_wcount
#define EXAMPLE_APB3_SLV_REG16_OFFSET  64 //debug_cam1_dma_status
#define EXAMPLE_APB3_SLV_REG17_OFFSET  68 //cam2_frames_per_second
#define EXAMPLE_APB3_SLV_REG18_OFFSET  72 //debug_cam2_dma_fifo_rcount
#define EXAMPLE_APB3_SLV_REG19_OFFSET  76 //debug_cam2_dma_fifo_wcount
#define EXAMPLE_APB3_SLV_REG20_OFFSET  80 //debug_cam2_dma_status

#define EXAMPLE_APB3_REGW(addr, offset, data) \
	write_u32(data, addr+offset)

#define EXAMPLE_APB3_REGR(addr, offset) \
	read_u32(addr+offset)

u32 example_register_read(u16 reg)
{
	u32 rdata;
	rdata = EXAMPLE_APB3_REGR(EXAMPLE_APB3_SLV, reg);
	return rdata;
}

void Set_RGBGain1(u8 ena, u8 R, u8 G, u8 B)
{
	u32 data = ((B & 0x7)<<12)|((G & 0x7)<<8)|((R & 0x7)<<4)|(ena&0x1);

	EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG1_OFFSET, data);
	bsp_uDelay(DELAY_BUSY);
}

void Set_RGBGain2(u8 ena, u8 R, u8 G, u8 B)
{
	u32 data = ((B & 0x7)<<12)|((G & 0x7)<<8)|((R & 0x7)<<4)|(ena&0x1);

	EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG5_OFFSET, data);
	bsp_uDelay(DELAY_BUSY);
}

void Set_MipiRst(u8 rst)
{
	EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG0_OFFSET, rst &0x01);
	bsp_uDelay(DELAY_BUSY);
}

#endif
