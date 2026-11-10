// To select resolution: uncomment only one at a time to select resolution of preprocessing and display.
`define Full_HD_1920x1080_60Hz 1
//`define HD_Ready_1280x720_60Hz 1
//`define SD_640x480_60Hz 1

// Note Change Resolution:
// Resolution from input camera maintain 1920x1080, only impact processing and display
//  1) Need to change to output output clock according to resolution on Peripheral Interface:
//          Full_HD_1920x1080_60Hz : Set hdmi_yuv_clk output clock to i_hdmi_clk_148p5MHz
//          HD_Ready_1280x720_60Hz : Set hdmi_yuv_clk output clock to i_hdmi_clk_74p25MHz
//          SD_640x480_60Hz : Set hdmi_yuv_clk output clock to i_hdmi_clk_25p25MHz
//  2) Need to change FRAME_WIDTH and FRAME_HEIGHT accordingly on SW main.cc

`define MIPI_FRAME_WIDTH   1920
`define MIPI_FRAME_HEIGHT  1080