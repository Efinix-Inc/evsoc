// RX
// Virtual Channel (VC) Enable [3:0]
`define  MIPI_VC0 0
`define  MIPI_VC1 1
`define  MIPI_VC2 2
`define  MIPI_VC3 3

// Lanes[1:0] Bus
`define MIPI_1_LANE  2'b00
`define MIPI_2_LANE  2'b01
`define MIPI_4_LANE  2'b11

// Resolution
`define MIPI_FRAME_WIDTH   1920
`define MIPI_FRAME_HEIGHT  1080
`define FRAME_WIDTH        640
`define FRAME_HEIGHT       480
`define DISPLAY_MODE       "640x480_60Hz"
`define SINGLE_CAM