///////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020 github-efx
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
   //Actual frame resolution used for subsequent processing (after cropping).
   //Not applicable for LVDS HDMI display (display setup to be modified separately).
   parameter FRAME_WIDTH           = 640,
   parameter FRAME_HEIGHT          = 480
)(
   //Clock and Reset Pins
   input          master_rstn,
   input          i_pll_locked,
   input          ddr_clk_locked,   
   input          mipi_pclk,     //75MHz
   input          tx_slowclk,    //12.38MHz
   input          axi_clk_locked,
   input          axi_clk,       //100MHz
   input          soc_clk,       //50MHz
   input          dma_clk,       //80MHz
   input          offchip_rstn,
   output         cam_rstn,
   output         hdmi_rstn,
   //MIPI Control
   output         mipi_inst1_DPHY_RSTN,
   output         mipi_inst1_RSTN,
   output [3:0]   mipi_inst1_VC_ENA,
   output [1:0]   mipi_inst1_LANES,
   output         mipi_inst1_CLEAR,
   //MIPI Video input
   input [3:0]    mipi_inst1_HSYNC,
   input [3:0]    mipi_inst1_VSYNC,
   input [3:0]    mipi_inst1_CNT,
   input          mipi_inst1_VALID,
   input [5:0]    mipi_inst1_TYPE,
   input [63:0]   mipi_inst1_DATA,
   input [1:0]    mipi_inst1_VC, 
   input [17:0]   mipi_inst1_ERR,
`ifdef SIM
   //Simulation frame data from testbench
   input          sim_cam_hsync,
   input          sim_cam_vsync,
   input          sim_cam_valid,
   input [15:0]   sim_cam_r_pix,
   input [15:0]   sim_cam_g_pix,
   input [15:0]   sim_cam_b_pix,
`endif
   //LVDS Video output
   output [6:0]   lvds_1a_DATA,
   output [6:0]   lvds_1b_DATA,
   output [6:0]   lvds_1c_DATA,
   output [6:0]   lvds_1d_DATA,
   output [6:0]   lvds_2a_DATA,
   output [6:0]   lvds_2b_DATA,
   output [6:0]   lvds_2c_DATA,
   output [6:0]   lvds_2d_DATA,
   output [6:0]   lvds_clk,
   //RiscV Soc Pinout
   output         system_uart_0_io_txd,
   input          system_uart_0_io_rxd,
   inout          mipi_i2c_0_io_sda,
   inout          mipi_i2c_0_io_scl,
   inout          hdmi_i2c_1_io_sda,
   inout          hdmi_i2c_1_io_scl,
   output         io_ddrA_arw_valid,
   input          io_ddrA_arw_ready,
   output [31:0]  io_ddrA_arw_payload_addr,
   output [7:0]   io_ddrA_arw_payload_id,
   output [7:0]   io_ddrA_arw_payload_len,
   output [2:0]   io_ddrA_arw_payload_size,
   output [1:0]   io_ddrA_arw_payload_burst,
   output [1:0]   io_ddrA_arw_payload_lock,
   output         io_ddrA_arw_payload_write,
   output [7:0]   io_ddrA_w_payload_id,
   output         io_ddrA_w_valid,
   input          io_ddrA_w_ready,
   output [127:0] io_ddrA_w_payload_data,
   output [15:0]  io_ddrA_w_payload_strb,
   output         io_ddrA_w_payload_last,
   input          io_ddrA_b_valid,
   output         io_ddrA_b_ready,
   input  [7:0]   io_ddrA_b_payload_id,
   input          io_ddrA_r_valid,
   output         io_ddrA_r_ready,
   input  [127:0] io_ddrA_r_payload_data,
   input  [7:0]   io_ddrA_r_payload_id,
   input  [1:0]   io_ddrA_r_payload_resp,
   input          io_ddrA_r_payload_last,
   output         io_ddrB_arw_valid,
   input          io_ddrB_arw_ready,
   output [31:0]  io_ddrB_arw_payload_addr,
   output [7:0]   io_ddrB_arw_payload_id,
   output [7:0]   io_ddrB_arw_payload_len,
   output [2:0]   io_ddrB_arw_payload_size,
   output [1:0]   io_ddrB_arw_payload_burst,
   output [1:0]   io_ddrB_arw_payload_lock,
   output         io_ddrB_arw_payload_write,
   output [7:0]   io_ddrB_w_payload_id,
   output         io_ddrB_w_valid,
   input          io_ddrB_w_ready,
   output [255:0] io_ddrB_w_payload_data,
   output [31:0]  io_ddrB_w_payload_strb,
   output         io_ddrB_w_payload_last,
   input          io_ddrB_b_valid,
   output         io_ddrB_b_ready,
   input  [7:0]   io_ddrB_b_payload_id,
   input          io_ddrB_r_valid,
   output         io_ddrB_r_ready,
   input  [255:0] io_ddrB_r_payload_data,
   input  [7:0]   io_ddrB_r_payload_id,
   input  [1:0]   io_ddrB_r_payload_resp,
   input          io_ddrB_r_payload_last,
   inout          system_spi_0_io_data_0,
   inout          system_spi_0_io_data_1,
   output reg     system_spi_0_io_sclk_write,
   output reg     system_spi_0_io_ss,
   //SOC Debugger
   input          jtag_inst1_CAPTURE,
   input          jtag_inst1_DRCK,
   input          jtag_inst1_RESET,
   input          jtag_inst1_RUNTEST,
   input          jtag_inst1_SEL,
   input          jtag_inst1_SHIFT,
   input          jtag_inst1_TCK,
   input          jtag_inst1_TDI,
   input          jtag_inst1_TMS,
   input          jtag_inst1_UPDATE,
   output         jtag_inst1_TDO,
   //DDR RESET
   output         ddr_inst1_CFG_RST_N,
   output         ddr_inst1_CFG_SEQ_RST,
   output         ddr_inst1_CFG_SEQ_START
);

wire     mipi_i2c_0_io_sda_read;
wire     mipi_i2c_0_io_sda_write;
wire     mipi_i2c_0_io_sda_writeEnable;
wire     mipi_i2c_0_io_scl_read;
wire     mipi_i2c_0_io_scl_write;
wire     mipi_i2c_0_io_scl_writeEnable;

wire     hdmi_i2c_1_io_sda_read;
wire     hdmi_i2c_1_io_sda_write;
wire     hdmi_i2c_1_io_sda_writeEnable;
wire     hdmi_i2c_1_io_scl_read;
wire     hdmi_i2c_1_io_scl_write;
wire     hdmi_i2c_1_io_scl_writeEnable;

wire     spi_0_io_sclk_write;
wire     spi_0_io_ss;
wire     spi_0_io_data_0_write;
reg      system_spi_0_io_data_0_write;
reg      system_spi_0_io_data_0_read;
wire     spi_0_io_data_0_writeEnable;
reg      system_spi_0_io_data_0_writeEnable;
wire     spi_0_io_data_1_write;
reg      system_spi_0_io_data_1_write;
reg      system_spi_0_io_data_1_read;
wire     spi_0_io_data_1_writeEnable;
reg      system_spi_0_io_data_1_writeEnable;

assign mipi_i2c_0_io_sda       = mipi_i2c_0_io_sda_writeEnable? mipi_i2c_0_io_sda_write : 1'bZ;
assign mipi_i2c_0_io_sda_read  = mipi_i2c_0_io_sda;
assign mipi_i2c_0_io_scl       = mipi_i2c_0_io_scl_writeEnable? mipi_i2c_0_io_scl_write : 1'bZ;
assign mipi_i2c_0_io_scl_read  = mipi_i2c_0_io_scl;

assign hdmi_i2c_1_io_sda       = hdmi_i2c_1_io_sda_writeEnable? hdmi_i2c_1_io_sda_write : 1'bZ;
assign hdmi_i2c_1_io_sda_read  = hdmi_i2c_1_io_sda;
assign hdmi_i2c_1_io_scl       = hdmi_i2c_1_io_scl_writeEnable? hdmi_i2c_1_io_scl_write : 1'bZ;
assign hdmi_i2c_1_io_scl_read  = hdmi_i2c_1_io_scl;

assign system_spi_0_io_data_0 = system_spi_0_io_data_0_writeEnable? system_spi_0_io_data_0_write : 1'bZ;
assign system_spi_0_io_data_1 = system_spi_0_io_data_1_writeEnable? system_spi_0_io_data_1_write : 1'bZ;

always@(posedge soc_clk)
begin
   system_spi_0_io_sclk_write          <= spi_0_io_sclk_write;
   system_spi_0_io_ss                  <= spi_0_io_ss;
   system_spi_0_io_data_0_writeEnable  <= spi_0_io_data_0_writeEnable;
   system_spi_0_io_data_1_writeEnable  <= spi_0_io_data_1_writeEnable;
   system_spi_0_io_data_0_read         <= system_spi_0_io_data_0;
   system_spi_0_io_data_1_read         <= system_spi_0_io_data_1;
   system_spi_0_io_data_0_write        <= spi_0_io_data_0_write;
   system_spi_0_io_data_1_write        <= spi_0_io_data_1_write;
end

edge_vision_soc #(
   .MIPI_FRAME_WIDTH    (MIPI_FRAME_WIDTH),
   .MIPI_FRAME_HEIGHT   (MIPI_FRAME_HEIGHT),
   .FRAME_WIDTH         (FRAME_WIDTH),
   .FRAME_HEIGHT        (FRAME_HEIGHT)
) DUT (
   //Clock and Reset Pins
   .master_rstn                        (master_rstn),
   .i_pll_locked                       (i_pll_locked),
   .ddr_clk_locked                     (ddr_clk_locked),
   .mipi_pclk                          (mipi_pclk),
   .tx_slowclk                         (tx_slowclk),
   .axi_clk_locked                     (axi_clk_locked),
   .axi_clk                            (axi_clk),
   .soc_clk                            (soc_clk),
   .dma_clk                            (dma_clk),
   .offchip_rstn                       (offchip_rstn),
   .cam_rstn                           (cam_rstn),
   .hdmi_rstn                          (hdmi_rstn),
   //MIPI Control
   .mipi_inst1_DPHY_RSTN               (mipi_inst1_DPHY_RSTN),
   .mipi_inst1_RSTN                    (mipi_inst1_RSTN),
   .mipi_inst1_VC_ENA                  (mipi_inst1_VC_ENA),
   .mipi_inst1_LANES                   (mipi_inst1_LANES),
   .mipi_inst1_CLEAR                   (mipi_inst1_CLEAR),
   //MIPI Video input
   .mipi_inst1_HSYNC                   (mipi_inst1_HSYNC),
   .mipi_inst1_VSYNC                   (mipi_inst1_VSYNC),
   .mipi_inst1_CNT                     (mipi_inst1_CNT),
   .mipi_inst1_VALID                   (mipi_inst1_VALID),
   .mipi_inst1_TYPE                    (mipi_inst1_TYPE),
   .mipi_inst1_DATA                    (mipi_inst1_DATA),
   .mipi_inst1_VC                      (mipi_inst1_VC),  
   .mipi_inst1_ERR                     (mipi_inst1_ERR),   
`ifdef SIM
   //Simulation frame data from testbench
   .sim_cam_hsync                      (sim_cam_hsync),
   .sim_cam_vsync                      (sim_cam_vsync),
   .sim_cam_valid                      (sim_cam_valid),
   .sim_cam_r_pix                      (sim_cam_r_pix),
   .sim_cam_g_pix                      (sim_cam_g_pix),
   .sim_cam_b_pix                      (sim_cam_b_pix),
`endif
   //LVDS Video output
   .lvds_1a_DATA                       (lvds_1a_DATA),
   .lvds_1b_DATA                       (lvds_1b_DATA),
   .lvds_1c_DATA                       (lvds_1c_DATA),
   .lvds_1d_DATA                       (lvds_1d_DATA),
   .lvds_2a_DATA                       (lvds_2a_DATA),
   .lvds_2b_DATA                       (lvds_2b_DATA),
   .lvds_2c_DATA                       (lvds_2c_DATA),
   .lvds_2d_DATA                       (lvds_2d_DATA),
   .lvds_clk                           (lvds_clk),
   .user_dip0                          (1'b0),
   .user_dip1                          (1'b0),
   .user_led2                          (),
   .user_led3                          (),
   //RiscV Soc Pinout
   .system_uart_0_io_txd               (system_uart_0_io_txd),
   .system_uart_0_io_rxd               (system_uart_0_io_rxd),
   .mipi_i2c_0_io_sda_writeEnable      (mipi_i2c_0_io_sda_writeEnable),
   .mipi_i2c_0_io_sda_write            (mipi_i2c_0_io_sda_write),
   .mipi_i2c_0_io_sda_read             (mipi_i2c_0_io_sda_read),
   .mipi_i2c_0_io_scl_writeEnable      (mipi_i2c_0_io_scl_writeEnable),
   .mipi_i2c_0_io_scl_write            (mipi_i2c_0_io_scl_write),
   .mipi_i2c_0_io_scl_read             (mipi_i2c_0_io_scl_read),
   .hdmi_i2c_1_io_sda_writeEnable      (hdmi_i2c_1_io_sda_writeEnable),
   .hdmi_i2c_1_io_sda_write            (hdmi_i2c_1_io_sda_write),
   .hdmi_i2c_1_io_sda_read             (hdmi_i2c_1_io_sda_read),
   .hdmi_i2c_1_io_scl_writeEnable      (hdmi_i2c_1_io_scl_writeEnable),
   .hdmi_i2c_1_io_scl_write            (hdmi_i2c_1_io_scl_write),
   .hdmi_i2c_1_io_scl_read             (hdmi_i2c_1_io_scl_read),
   .io_ddrA_arw_valid                  (io_ddrA_arw_valid),
   .io_ddrA_arw_ready                  (io_ddrA_arw_ready),
   .io_ddrA_arw_payload_addr           (io_ddrA_arw_payload_addr),
   .io_ddrA_arw_payload_id             (io_ddrA_arw_payload_id),
   .io_ddrA_arw_payload_len            (io_ddrA_arw_payload_len),
   .io_ddrA_arw_payload_size           (io_ddrA_arw_payload_size),
   .io_ddrA_arw_payload_burst          (io_ddrA_arw_payload_burst),
   .io_ddrA_arw_payload_lock           (io_ddrA_arw_payload_lock),
   .io_ddrA_arw_payload_write          (io_ddrA_arw_payload_write),
   .io_ddrA_w_payload_id               (io_ddrA_w_payload_id),
   .io_ddrA_w_valid                    (io_ddrA_w_valid),
   .io_ddrA_w_ready                    (io_ddrA_w_ready),
   .io_ddrA_w_payload_data             (io_ddrA_w_payload_data),
   .io_ddrA_w_payload_strb             (io_ddrA_w_payload_strb),
   .io_ddrA_w_payload_last             (io_ddrA_w_payload_last),
   .io_ddrA_b_valid                    (io_ddrA_b_valid),
   .io_ddrA_b_ready                    (io_ddrA_b_ready),
   .io_ddrA_b_payload_id               (io_ddrA_b_payload_id),
   .io_ddrA_r_valid                    (io_ddrA_r_valid),
   .io_ddrA_r_ready                    (io_ddrA_r_ready),
   .io_ddrA_r_payload_data             (io_ddrA_r_payload_data),
   .io_ddrA_r_payload_id               (io_ddrA_r_payload_id),
   .io_ddrA_r_payload_resp             (io_ddrA_r_payload_resp),
   .io_ddrA_r_payload_last             (io_ddrA_r_payload_last),
   .io_ddrB_arw_valid                  (io_ddrB_arw_valid),
   .io_ddrB_arw_ready                  (io_ddrB_arw_ready),
   .io_ddrB_arw_payload_addr           (io_ddrB_arw_payload_addr),
   .io_ddrB_arw_payload_id             (io_ddrB_arw_payload_id),
   .io_ddrB_arw_payload_len            (io_ddrB_arw_payload_len),
   .io_ddrB_arw_payload_size           (io_ddrB_arw_payload_size),
   .io_ddrB_arw_payload_burst          (io_ddrB_arw_payload_burst),
   .io_ddrB_arw_payload_lock           (io_ddrB_arw_payload_lock),
   .io_ddrB_arw_payload_write          (io_ddrB_arw_payload_write),
   .io_ddrB_w_payload_id               (io_ddrB_w_payload_id),
   .io_ddrB_w_valid                    (io_ddrB_w_valid),
   .io_ddrB_w_ready                    (io_ddrB_w_ready),
   .io_ddrB_w_payload_data             (io_ddrB_w_payload_data),
   .io_ddrB_w_payload_strb             (io_ddrB_w_payload_strb),
   .io_ddrB_w_payload_last             (io_ddrB_w_payload_last),
   .io_ddrB_b_valid                    (io_ddrB_b_valid),
   .io_ddrB_b_ready                    (io_ddrB_b_ready),
   .io_ddrB_b_payload_id               (io_ddrB_b_payload_id),
   .io_ddrB_r_valid                    (io_ddrB_r_valid),
   .io_ddrB_r_ready                    (io_ddrB_r_ready),
   .io_ddrB_r_payload_data             (io_ddrB_r_payload_data),
   .io_ddrB_r_payload_id               (io_ddrB_r_payload_id),
   .io_ddrB_r_payload_resp             (io_ddrB_r_payload_resp),
   .io_ddrB_r_payload_last             (io_ddrB_r_payload_last),
   .system_spi_0_io_sclk_write         (spi_0_io_sclk_write),
   .system_spi_0_io_data_0_writeEnable (spi_0_io_data_0_writeEnable),
   .system_spi_0_io_data_0_read        (system_spi_0_io_data_0_read),
   .system_spi_0_io_data_0_write       (spi_0_io_data_0_write),
   .system_spi_0_io_data_1_writeEnable (spi_0_io_data_1_writeEnable),
   .system_spi_0_io_data_1_read        (system_spi_0_io_data_1_read),
   .system_spi_0_io_data_1_write       (spi_0_io_data_1_write),
   .system_spi_0_io_ss                 (spi_0_io_ss),
   //SOC Debugger
   .jtag_inst1_TCK                     (jtag_inst1_TCK),
   .jtag_inst1_TDI                     (jtag_inst1_TDI),
   .jtag_inst1_TDO                     (jtag_inst1_TDO),
   .jtag_inst1_SEL                     (jtag_inst1_SEL),
   .jtag_inst1_CAPTURE                 (jtag_inst1_CAPTURE),
   .jtag_inst1_SHIFT                   (jtag_inst1_SHIFT),
   .jtag_inst1_UPDATE                  (jtag_inst1_UPDATE),
   .jtag_inst1_RESET                   (jtag_inst1_RESET),
   .jtag_inst1_DRCK                    (jtag_inst1_DRCK),
   .jtag_inst1_RUNTEST                 (jtag_inst1_RUNTEST),
   .jtag_inst1_TMS                     (jtag_inst1_TMS),
   //DDR RESET
   .ddr_inst1_CFG_RST_N                (ddr_inst1_CFG_RST_N),
   .ddr_inst1_CFG_SEQ_RST              (ddr_inst1_CFG_SEQ_RST),
   .ddr_inst1_CFG_SEQ_START            (ddr_inst1_CFG_SEQ_START)
);

endmodule
