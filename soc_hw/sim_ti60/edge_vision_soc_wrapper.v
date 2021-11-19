///////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021 github-efx
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
///////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module edge_vision_soc_wrapper #(
   parameter MIPI_FRAME_WIDTH      = 1920,  
   parameter MIPI_FRAME_HEIGHT     = 1080,
   //Actual frame resolution used for subsequent processing (after cropping/scaling).
   parameter FRAME_WIDTH           = 640,
   parameter FRAME_HEIGHT          = 480
)(
   //Reset
   input             i_arstn,
   output            o_lcd_rstn,
   output            o_pll_rstn,
   output            o_mipi_pll_rstn,
   
   //PLL clock and locked
   input             i_fb_clk,
   input             i_sysclk_div_2,
   input             i_mipi_rx_pclk,
   input             i_pll_locked,
   
   input             i_mipi_clk,
   input             i_mipi_txc_sclk,
   input             i_mipi_txd_sclk,
   input             i_mipi_tx_pclk,
   input             i_mipi_tx_pll_locked,
   
   input             i_hbramClk,
   input             i_hbramClk_cal,
   input             i_hbramClk90,
   input             i_systemClk,
   input             i_hbramClk_pll_locked,
   
   //PiCam configuration
   inout             mipi_i2c_0_io_sda,
   inout             mipi_i2c_0_io_scl,
   output            o_cam_rstn,
   
   //MIPI RX - Camera
   input             i_cam_ck_LP_P_IN,
   input             i_cam_ck_LP_N_IN,
   output            o_cam_ck_HS_TERM,
   output            o_cam_ck_HS_ENA,
   input             i_cam_ck_CLKOUT_0,
   input  [7:0]      i_cam_d0_HS_IN_0,
   input  [7:0]      i_cam_d0_HS_IN_1,
   input  [7:0]      i_cam_d0_HS_IN_2,
   input  [7:0]      i_cam_d0_HS_IN_3,
   input             i_cam_d0_LP_P_IN,
   input             i_cam_d0_LP_N_IN,
   output            o_cam_d0_HS_TERM,
   output            o_cam_d0_HS_ENA,
   output            o_cam_d0_RST,
   output            o_cam_d0_FIFO_RD,
   input             i_cam_d0_FIFO_EMPTY,
   input  [7:0]      i_cam_d1_HS_IN_0,
   input  [7:0]      i_cam_d1_HS_IN_1,
   input  [7:0]      i_cam_d1_HS_IN_2,
   input  [7:0]      i_cam_d1_HS_IN_3,
   input             i_cam_d1_LP_P_IN,
   input             i_cam_d1_LP_N_IN,
   output            o_cam_d1_HS_TERM,
   output            o_cam_d1_HS_ENA,
   output            o_cam_d1_RST,
   output            o_cam_d1_FIFO_RD,
   input             i_cam_d1_FIFO_EMPTY,
   
   //Simulation frame data from testbench
   input             sim_cam_hsync,
   input             sim_cam_vsync,
   input             sim_cam_valid,
   input  [15:0]     sim_cam_r_pix,
   input  [15:0]     sim_cam_g_pix,
   input  [15:0]     sim_cam_b_pix,

   //MIPI TX - Display Panel
   output            mipi_dp_clk_LP_P_OUT,
   output            mipi_dp_clk_LP_N_OUT,
   output [7:0]      mipi_dp_clk_HS_OUT,
   output            mipi_dp_clk_HS_OE,
   output            mipi_dp_data3_LP_P_OUT,
   output            mipi_dp_data2_LP_P_OUT,
   output            mipi_dp_data1_LP_P_OUT,
   output            mipi_dp_data0_LP_P_OUT,
   output            mipi_dp_data3_LP_N_OUT,
   output            mipi_dp_data2_LP_N_OUT,
   output            mipi_dp_data1_LP_N_OUT,
   output            mipi_dp_data0_LP_N_OUT,
   output [7:0]      mipi_dp_data0_HS_OUT,
   output [7:0]      mipi_dp_data1_HS_OUT,
   output [7:0]      mipi_dp_data2_HS_OUT,
   output [7:0]      mipi_dp_data3_HS_OUT,
   output            mipi_dp_data3_HS_OE,
   output            mipi_dp_data2_HS_OE,
   output            mipi_dp_data1_HS_OE,
   output            mipi_dp_data0_HS_OE,
   output            mipi_dp_clk_RST,
   output            mipi_dp_data0_RST,
   output            mipi_dp_data1_RST,
   output            mipi_dp_data2_RST,
   output            mipi_dp_data3_RST,
   output            mipi_dp_clk_LP_P_OE,
   output            mipi_dp_clk_LP_N_OE,
   output            mipi_dp_data3_LP_P_OE,
   output            mipi_dp_data3_LP_N_OE,
   output            mipi_dp_data2_LP_P_OE,
   output            mipi_dp_data2_LP_N_OE,
   output            mipi_dp_data1_LP_P_OE,
   output            mipi_dp_data1_LP_N_OE,
   output            mipi_dp_data0_LP_P_OE,
   output            mipi_dp_data0_LP_N_OE,
   input             mipi_dp_data0_LP_P_IN,
   input             mipi_dp_data0_LP_N_IN,

   //Push button
   input             sw1,
   input             sw6,
   input             sw7,

   //LED
   output            o_led,
   output            hbc_cal_pass,

   //SoC
   output            system_uart_0_io_txd,
   input             system_uart_0_io_rxd,
   
   //HyperRAM
   output            hbc_rst_n,
   output            hbc_cs_n,
   output            hbc_ck_p_HI,
   output            hbc_ck_p_LO,
   output            hbc_ck_n_HI,
   output            hbc_ck_n_LO,
   output  [1:0]     hbc_rwds_OUT_HI,
   output  [1:0]     hbc_rwds_OUT_LO,
   input   [1:0]     hbc_rwds_IN_HI,
   input   [1:0]     hbc_rwds_IN_LO,
   output  [1:0]     hbc_rwds_OE,
   output  [15:0]    hbc_dq_OUT_HI,
   output  [15:0]    hbc_dq_OUT_LO,
   input   [15:0]    hbc_dq_IN_LO,
   input   [15:0]    hbc_dq_IN_HI,
   output  [15:0]    hbc_dq_OE,
   
   output  [2:0]     o_hbc_cal_SHIFT,
   output  [4:0]     o_hbc_cal_SHIFT_SEL,
   output            o_hbc_cal_SHIFT_ENA,
   output            o_hbramClk_pll_rstn,

   //SPI
   output            system_spi_0_io_sclk_write,
   output            system_spi_0_io_data_0_writeEnable,
   input             system_spi_0_io_data_0_read,
   output            system_spi_0_io_data_0_write,
   output            system_spi_0_io_data_1_writeEnable,
   input             system_spi_0_io_data_1_read,
   output            system_spi_0_io_data_1_write,
   output            system_spi_0_io_ss,

   //JTAG
`ifndef SOFT_TAP
   input             jtag_inst1_TCK,
   input             jtag_inst1_TDI,
   output            jtag_inst1_TDO,
   input             jtag_inst1_SEL,
   input             jtag_inst1_CAPTURE,
   input             jtag_inst1_SHIFT,
   input             jtag_inst1_UPDATE,
   input             jtag_inst1_RESET
`else
   input             io_jtag_tms,
   input             io_jtag_tdi,
   output            io_jtag_tdo,
   input             io_jtag_tck
`endif
);

wire  mipi_i2c_0_io_sda_read;
wire  mipi_i2c_0_io_sda_writeEnable;
wire  mipi_i2c_0_io_scl_read;
wire  mipi_i2c_0_io_scl_writeEnable;

assign mipi_i2c_0_io_sda       = mipi_i2c_0_io_sda_writeEnable;
assign mipi_i2c_0_io_sda_read  = mipi_i2c_0_io_sda;
assign mipi_i2c_0_io_scl       = mipi_i2c_0_io_scl_writeEnable;
assign mipi_i2c_0_io_scl_read  = mipi_i2c_0_io_scl;

edge_vision_soc #(
   .MIPI_FRAME_WIDTH    (MIPI_FRAME_WIDTH),
   .MIPI_FRAME_HEIGHT   (MIPI_FRAME_HEIGHT),
   .FRAME_WIDTH         (FRAME_WIDTH),
   .FRAME_HEIGHT        (FRAME_HEIGHT)
) DUT (
   .i_arstn                            (i_arstn                           ),
   .i_fb_clk                           (i_fb_clk                          ),
   .i_sysclk_div_2                     (i_sysclk_div_2                    ),
   .i_mipi_rx_pclk                     (i_mipi_rx_pclk                    ),
   .i_pll_locked                       (i_pll_locked                      ),
   .i_mipi_clk                         (i_mipi_clk                        ),
   .i_mipi_txc_sclk                    (i_mipi_txc_sclk                   ),
   .i_mipi_txd_sclk                    (i_mipi_txd_sclk                   ),
   .i_mipi_tx_pclk                     (i_mipi_tx_pclk                    ),
   .i_mipi_tx_pll_locked               (i_mipi_tx_pll_locked              ),
   .i_hbramClk                         (i_hbramClk                        ),
   .i_hbramClk_cal                     (i_hbramClk_cal                    ),
   .i_hbramClk90                       (i_hbramClk90                      ),
   .i_systemClk                        (i_systemClk                       ),
   .i_hbramClk_pll_locked              (i_hbramClk_pll_locked             ),
   .o_lcd_rstn                         (o_lcd_rstn                        ),
   .o_pll_rstn                         (o_pll_rstn                        ),
   .o_mipi_pll_rstn                    (o_mipi_pll_rstn                   ),
   .mipi_i2c_0_io_sda_writeEnable      (mipi_i2c_0_io_sda_writeEnable     ),
   .mipi_i2c_0_io_sda_read             (mipi_i2c_0_io_sda_read            ),
   .mipi_i2c_0_io_scl_writeEnable      (mipi_i2c_0_io_scl_writeEnable     ),
   .mipi_i2c_0_io_scl_read             (mipi_i2c_0_io_scl_read            ),
   .o_cam_rstn                         (o_cam_rstn                        ),
   .i_cam_ck_LP_P_IN                   (i_cam_ck_LP_P_IN                  ),
   .i_cam_ck_LP_N_IN                   (i_cam_ck_LP_N_IN                  ),
   .o_cam_ck_HS_TERM                   (o_cam_ck_HS_TERM                  ),
   .o_cam_ck_HS_ENA                    (o_cam_ck_HS_ENA                   ),
   .i_cam_ck_CLKOUT_0                  (i_cam_ck_CLKOUT_0                 ),
   .i_cam_d0_HS_IN_0                   (i_cam_d0_HS_IN_0                  ),
   .i_cam_d0_HS_IN_1                   (i_cam_d0_HS_IN_1                  ),
   .i_cam_d0_HS_IN_2                   (i_cam_d0_HS_IN_2                  ),
   .i_cam_d0_HS_IN_3                   (i_cam_d0_HS_IN_3                  ),
   .i_cam_d0_LP_P_IN                   (i_cam_d0_LP_P_IN                  ),
   .i_cam_d0_LP_N_IN                   (i_cam_d0_LP_N_IN                  ),
   .o_cam_d0_HS_TERM                   (o_cam_d0_HS_TERM                  ),
   .o_cam_d0_HS_ENA                    (o_cam_d0_HS_ENA                   ),
   .o_cam_d0_RST                       (o_cam_d0_RST                      ),
   .o_cam_d0_FIFO_RD                   (o_cam_d0_FIFO_RD                  ),
   .i_cam_d0_FIFO_EMPTY                (i_cam_d0_FIFO_EMPTY               ),
   .i_cam_d1_HS_IN_0                   (i_cam_d1_HS_IN_0                  ),
   .i_cam_d1_HS_IN_1                   (i_cam_d1_HS_IN_1                  ),
   .i_cam_d1_HS_IN_2                   (i_cam_d1_HS_IN_2                  ),
   .i_cam_d1_HS_IN_3                   (i_cam_d1_HS_IN_3                  ),
   .i_cam_d1_LP_P_IN                   (i_cam_d1_LP_P_IN                  ),
   .i_cam_d1_LP_N_IN                   (i_cam_d1_LP_N_IN                  ),
   .o_cam_d1_HS_TERM                   (o_cam_d1_HS_TERM                  ),
   .o_cam_d1_HS_ENA                    (o_cam_d1_HS_ENA                   ),
   .o_cam_d1_RST                       (o_cam_d1_RST                      ),
   .o_cam_d1_FIFO_RD                   (o_cam_d1_FIFO_RD                  ),
   .i_cam_d1_FIFO_EMPTY                (i_cam_d1_FIFO_EMPTY               ),
   .sim_cam_hsync                      (sim_cam_hsync                     ),
   .sim_cam_vsync                      (sim_cam_vsync                     ),
   .sim_cam_valid                      (sim_cam_valid                     ),
   .sim_cam_r_pix                      (sim_cam_r_pix                     ),
   .sim_cam_g_pix                      (sim_cam_g_pix                     ),
   .sim_cam_b_pix                      (sim_cam_b_pix                     ),
   .mipi_dp_clk_LP_P_OUT               (mipi_dp_clk_LP_P_OUT              ),
   .mipi_dp_clk_LP_N_OUT               (mipi_dp_clk_LP_N_OUT              ),
   .mipi_dp_clk_HS_OUT                 (mipi_dp_clk_HS_OUT                ),
   .mipi_dp_clk_HS_OE                  (mipi_dp_clk_HS_OE                 ),
   .mipi_dp_data3_LP_P_OUT             (mipi_dp_data3_LP_P_OUT            ),
   .mipi_dp_data2_LP_P_OUT             (mipi_dp_data2_LP_P_OUT            ),
   .mipi_dp_data1_LP_P_OUT             (mipi_dp_data1_LP_P_OUT            ),
   .mipi_dp_data0_LP_P_OUT             (mipi_dp_data0_LP_P_OUT            ),
   .mipi_dp_data3_LP_N_OUT             (mipi_dp_data3_LP_N_OUT            ),
   .mipi_dp_data2_LP_N_OUT             (mipi_dp_data2_LP_N_OUT            ),
   .mipi_dp_data1_LP_N_OUT             (mipi_dp_data1_LP_N_OUT            ),
   .mipi_dp_data0_LP_N_OUT             (mipi_dp_data0_LP_N_OUT            ),
   .mipi_dp_data0_HS_OUT               (mipi_dp_data0_HS_OUT              ),
   .mipi_dp_data1_HS_OUT               (mipi_dp_data1_HS_OUT              ),
   .mipi_dp_data2_HS_OUT               (mipi_dp_data2_HS_OUT              ),
   .mipi_dp_data3_HS_OUT               (mipi_dp_data3_HS_OUT              ),
   .mipi_dp_data3_HS_OE                (mipi_dp_data3_HS_OE               ),
   .mipi_dp_data2_HS_OE                (mipi_dp_data2_HS_OE               ),
   .mipi_dp_data1_HS_OE                (mipi_dp_data1_HS_OE               ),
   .mipi_dp_data0_HS_OE                (mipi_dp_data0_HS_OE               ),
   .mipi_dp_clk_RST                    (mipi_dp_clk_RST                   ),
   .mipi_dp_data0_RST                  (mipi_dp_data0_RST                 ),
   .mipi_dp_data1_RST                  (mipi_dp_data1_RST                 ),
   .mipi_dp_data2_RST                  (mipi_dp_data2_RST                 ),
   .mipi_dp_data3_RST                  (mipi_dp_data3_RST                 ),
   .mipi_dp_clk_LP_P_OE                (mipi_dp_clk_LP_P_OE               ),
   .mipi_dp_clk_LP_N_OE                (mipi_dp_clk_LP_N_OE               ),
   .mipi_dp_data3_LP_P_OE              (mipi_dp_data3_LP_P_OE             ),
   .mipi_dp_data3_LP_N_OE              (mipi_dp_data3_LP_N_OE             ),
   .mipi_dp_data2_LP_P_OE              (mipi_dp_data2_LP_P_OE             ),
   .mipi_dp_data2_LP_N_OE              (mipi_dp_data2_LP_N_OE             ),
   .mipi_dp_data1_LP_P_OE              (mipi_dp_data1_LP_P_OE             ),
   .mipi_dp_data1_LP_N_OE              (mipi_dp_data1_LP_N_OE             ),
   .mipi_dp_data0_LP_P_OE              (mipi_dp_data0_LP_P_OE             ),
   .mipi_dp_data0_LP_N_OE              (mipi_dp_data0_LP_N_OE             ),
   .mipi_dp_data0_LP_P_IN              (mipi_dp_data0_LP_P_IN             ),
   .mipi_dp_data0_LP_N_IN              (mipi_dp_data0_LP_N_IN             ),
   .sw1                                (sw1                               ),
   .sw6                                (sw6                               ),
   .sw7                                (sw7                               ),
   .o_led                              (o_led                             ),
   .hbc_cal_pass                       (hbc_cal_pass                      ),
   .system_uart_0_io_txd               (system_uart_0_io_txd              ),
   .system_uart_0_io_rxd               (system_uart_0_io_rxd              ),
   .system_spi_0_io_sclk_write         (system_spi_0_io_sclk_write        ),
   .system_spi_0_io_data_0_writeEnable (system_spi_0_io_data_0_writeEnable),
   .system_spi_0_io_data_0_read        (system_spi_0_io_data_0_read       ),
   .system_spi_0_io_data_0_write       (system_spi_0_io_data_0_write      ),
   .system_spi_0_io_data_1_writeEnable (system_spi_0_io_data_1_writeEnable),
   .system_spi_0_io_data_1_read        (system_spi_0_io_data_1_read       ),
   .system_spi_0_io_data_1_write       (system_spi_0_io_data_1_write      ),
   .system_spi_0_io_ss                 (system_spi_0_io_ss                ),
   .hbc_rst_n                          (hbc_rst_n                         ),
   .hbc_cs_n                           (hbc_cs_n                          ),
   .hbc_ck_p_HI                        (hbc_ck_p_HI                       ),
   .hbc_ck_p_LO                        (hbc_ck_p_LO                       ),
   .hbc_ck_n_HI                        (hbc_ck_n_HI                       ),
   .hbc_ck_n_LO                        (hbc_ck_n_LO                       ),
   .hbc_rwds_OUT_HI                    (hbc_rwds_OUT_HI                   ),
   .hbc_rwds_OUT_LO                    (hbc_rwds_OUT_LO                   ),
   .hbc_rwds_IN_HI                     (hbc_rwds_IN_HI                    ),
   .hbc_rwds_IN_LO                     (hbc_rwds_IN_LO                    ),
   .hbc_rwds_OE                        (hbc_rwds_OE                       ),
   .hbc_dq_OUT_HI                      (hbc_dq_OUT_HI                     ),
   .hbc_dq_OUT_LO                      (hbc_dq_OUT_LO                     ),
   .hbc_dq_IN_LO                       (hbc_dq_IN_LO                      ),
   .hbc_dq_IN_HI                       (hbc_dq_IN_HI                      ),
   .hbc_dq_OE                          (hbc_dq_OE                         ),
   .o_hbc_cal_SHIFT                    (o_hbc_cal_SHIFT                   ),
   .o_hbc_cal_SHIFT_SEL                (o_hbc_cal_SHIFT_SEL               ),
   .o_hbc_cal_SHIFT_ENA                (o_hbc_cal_SHIFT_ENA               ),
   .o_hbramClk_pll_rstn                (o_hbramClk_pll_rstn               ),
`ifndef SOFT_TAP
   .jtag_inst1_TCK                     (jtag_inst1_TCK                    ),
   .jtag_inst1_TDI                     (jtag_inst1_TDI                    ),
   .jtag_inst1_TDO                     (jtag_inst1_TDO                    ),
   .jtag_inst1_SEL                     (jtag_inst1_SEL                    ),
   .jtag_inst1_CAPTURE                 (jtag_inst1_CAPTURE                ),
   .jtag_inst1_SHIFT                   (jtag_inst1_SHIFT                  ),
   .jtag_inst1_UPDATE                  (jtag_inst1_UPDATE                 ),
   .jtag_inst1_RESET                   (jtag_inst1_RESET                  )
`else
   .io_jtag_tms                        (io_jtag_tms                       ),
   .io_jtag_tdi                        (io_jtag_tdi                       ),
   .io_jtag_tdo                        (io_jtag_tdo                       ),
   .io_jtag_tck                        (io_jtag_tck                       )
`endif
);

endmodule
