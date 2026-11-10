////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2026 Efinix Inc. All rights reserved.
// See https://github.com/Efinix-Inc/evsoc/blob/main/LICENSE.txt for details.
////////////////////////////////////////////////////////////////////////////////
//
// Ti125F225 simulation wrapper (adapted from the Ti180J484 wrapper).
// Ti125 differences:
//   * One memory port: the SoC already merges the CPU and the DMA
//     (io_ddrMasters_0) onto its 128-bit DDR port, and edge_vision_soc_sim
//     converts it to half-duplex AXI4 with axi_full_to_half_duplex, exactly as
//     on hardware. So no fd_to_hd_wrapper and no second (ddrB) port.
//   * i_sys_clk is its own 200 MHz clock (Ti180 wrapper tied it to the pixel clock).
//   * SPI0 only (the Ti125 SoC has no SPI1). No hard-DDR startup sequencer pins.
////////////////////////////////////////////////////////////////////////////////

`timescale 100ps/10ps

module edge_vision_soc_wrapper #(
   parameter MIPI_FRAME_WIDTH      = 1920,
   parameter MIPI_FRAME_HEIGHT     = 1080,
   parameter FRAME_WIDTH           = 64,
   parameter FRAME_HEIGHT          = 48
   //Actual frame resolution used for subsequent processing (after cropping).
   //Not applicable for HDMI display (display setup to be modified separately).
)(
   //Clock and Reset Pins
   input          master_rstn,
   input          i_pll_locked,
   input          ddr_clk_locked,
   input          i_pixel_clk,
   input          i_hdmi_sim,
   input          i_axi0_mem_clk,
   input          i_soc_clk,
   input          i_sys_clk,

`ifdef SIM
   //Simulation frame data from testbench
   input          sim_cam_hsync,
   input          sim_cam_vsync,
   input          sim_cam_valid,
   input [15:0]   sim_cam_r_pix,
   input [15:0]   sim_cam_g_pix,
   input [15:0]   sim_cam_b_pix,
`endif

   //RiscV Soc Pinout
   output         system_uart_0_io_txd,
   input          system_uart_0_io_rxd,
   inout          mipi_i2c_0_io_sda,
   inout          mipi_i2c_0_io_scl,

   //DDR - 128-bit half-duplex AXI4 (to simple_ddr_model)
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
   output         jtag_inst1_TDO
);

wire        mipi_i2c_0_io_sda_read;
wire        mipi_i2c_0_io_sda_writeEnable;
wire        mipi_i2c_0_io_scl_read;
wire        mipi_i2c_0_io_scl_writeEnable;

wire        spi_0_io_sclk_write;
wire        spi_0_io_ss;
wire        spi_0_io_data_0_write;
reg         system_spi_0_io_data_0_write;
reg         system_spi_0_io_data_0_read;
wire        spi_0_io_data_0_writeEnable;
reg         system_spi_0_io_data_0_writeEnable;
wire        spi_0_io_data_1_write;
reg         system_spi_0_io_data_1_write;
reg         system_spi_0_io_data_1_read;
wire        spi_0_io_data_1_writeEnable;
reg         system_spi_0_io_data_1_writeEnable;

// Open-drain I2C, as on the board (the top drives only the output enables).
assign mipi_i2c_0_io_sda       = mipi_i2c_0_io_sda_writeEnable ? 1'b0 : 1'bZ;
assign mipi_i2c_0_io_sda_read  = mipi_i2c_0_io_sda;
assign mipi_i2c_0_io_scl       = mipi_i2c_0_io_scl_writeEnable ? 1'b0 : 1'bZ;
assign mipi_i2c_0_io_scl_read  = mipi_i2c_0_io_scl;
pullup (mipi_i2c_0_io_sda);   // board pull-ups
pullup (mipi_i2c_0_io_scl);

assign system_spi_0_io_data_0 = system_spi_0_io_data_0_writeEnable? system_spi_0_io_data_0_write : 1'bZ;
assign system_spi_0_io_data_1 = system_spi_0_io_data_1_writeEnable? system_spi_0_io_data_1_write : 1'bZ;

always@(posedge i_soc_clk)
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

edge_vision_soc_sim #(
   .MIPI_FRAME_WIDTH    (MIPI_FRAME_WIDTH),
   .MIPI_FRAME_HEIGHT   (MIPI_FRAME_HEIGHT),
   .FRAME_WIDTH         (FRAME_WIDTH),
   .FRAME_HEIGHT        (FRAME_HEIGHT)
) DUT (
   //Clock Control & reset pin
   .i_axi0_mem_clk                     (i_axi0_mem_clk),
   .pll_ddr_LOCKED                     (ddr_clk_locked),
   .i_sw                               ({1'b1, master_rstn}),  // [1] demo button released (pull-up)
   .i_soc_clk                          (i_soc_clk),
   .i_sys_clk                          (i_sys_clk),
   .i_hdmi_sim                         (i_hdmi_sim), //For simulation only
   .i_pixel_clk                        (i_pixel_clk),
   .i_sys_clk_25mhz                    (1'b0),       //ADV7511 setup clock, not simulated
   .pll_osc3_LOCKED                    (i_pll_locked),
   .i_hdmi_clk_148p5MHz                (1'b0),
   .i_hdmi_clk_74p25MHz                (1'b0),
   .pll_osc2_LOCKED                    (i_pll_locked),

   //DDR: half-duplex AXI4 from axi_full_to_half_duplex
   .ddr_axi_aid                        (io_ddrA_arw_payload_id),
   .ddr_axi_aaddr                      (io_ddrA_arw_payload_addr),
   .ddr_axi_alen                       (io_ddrA_arw_payload_len),
   .ddr_axi_asize                      (io_ddrA_arw_payload_size),
   .ddr_axi_aburst                     (io_ddrA_arw_payload_burst),
   .ddr_axi_alock                      (io_ddrA_arw_payload_lock),
   .ddr_axi_avalid                     (io_ddrA_arw_valid),
   .ddr_axi_aready                     (io_ddrA_arw_ready),
   .ddr_axi_atype                      (io_ddrA_arw_payload_write),
   .ddr_axi_wid                        (io_ddrA_w_payload_id),
   .ddr_axi_wdata                      (io_ddrA_w_payload_data),
   .ddr_axi_wstrb                      (io_ddrA_w_payload_strb),
   .ddr_axi_wlast                      (io_ddrA_w_payload_last),
   .ddr_axi_wvalid                     (io_ddrA_w_valid),
   .ddr_axi_wready                     (io_ddrA_w_ready),
   .ddr_axi_rid                        (io_ddrA_r_payload_id),
   .ddr_axi_rdata                      (io_ddrA_r_payload_data),
   .ddr_axi_rlast                      (io_ddrA_r_payload_last),
   .ddr_axi_rvalid                     (io_ddrA_r_valid),
   .ddr_axi_rready                     (io_ddrA_r_ready),
   .ddr_axi_rresp                      (io_ddrA_r_payload_resp),
   .ddr_axi_bid                        (io_ddrA_b_payload_id),
   .ddr_axi_bvalid                     (io_ddrA_b_valid),
   .ddr_axi_bready                     (io_ddrA_b_ready),

`ifdef SIM
   //Simulation frame data from testbench
   .sim_cam_hsync                      (sim_cam_hsync),
   .sim_cam_vsync                      (sim_cam_vsync),
   .sim_cam_valid                      (sim_cam_valid),
   .sim_cam_r_pix                      (sim_cam_r_pix),
   .sim_cam_g_pix                      (sim_cam_g_pix),
   .sim_cam_b_pix                      (sim_cam_b_pix),
`endif

   //SOC port
   .system_spi_0_io_sclk_write         (spi_0_io_sclk_write),
   .system_spi_0_io_data_0_writeEnable (spi_0_io_data_0_writeEnable),
   .system_spi_0_io_data_0_read        (system_spi_0_io_data_0_read),
   .system_spi_0_io_data_0_write       (spi_0_io_data_0_write),
   .system_spi_0_io_data_1_writeEnable (spi_0_io_data_1_writeEnable),
   .system_spi_0_io_data_1_read        (system_spi_0_io_data_1_read),
   .system_spi_0_io_data_1_write       (spi_0_io_data_1_write),
   .system_spi_0_io_ss                 (spi_0_io_ss),
   .system_uart_0_io_txd               (system_uart_0_io_txd),
   .system_uart_0_io_rxd               (system_uart_0_io_rxd),

   //CSI Camera interface
   .i_cam_sda                          (mipi_i2c_0_io_sda_read),
   .o_cam_sda_oe                       (mipi_i2c_0_io_sda_writeEnable),
   .i_cam_scl                          (mipi_i2c_0_io_scl_read),
   .o_cam_scl_oe                       (mipi_i2c_0_io_scl_writeEnable),
   .o_cam_rstn                         (),

   // I2C Configuration for HDMI (not simulated)
   .i_hdmi_sda                         (1'b1),
   .o_hdmi_sda_oe                      (),
   .i_hdmi_scl                         (1'b1),
   .o_hdmi_scl_oe                      (),

   // HDMI YUV Output (not simulated)
   .hdmi_yuv_vs                        (),
   .hdmi_yuv_hs                        (),
   .hdmi_yuv_de                        (),
   .hdmi_yuv_data                      (),

   //LED
   .o_led                              (),

   .jtag_inst1_CAPTURE                 (jtag_inst1_CAPTURE),
   .jtag_inst1_DRCK                    (jtag_inst1_DRCK),
   .jtag_inst1_RESET                   (jtag_inst1_RESET),
   .jtag_inst1_RUNTEST                 (jtag_inst1_RUNTEST),
   .jtag_inst1_SEL                     (jtag_inst1_SEL),
   .jtag_inst1_SHIFT                   (jtag_inst1_SHIFT),
   .jtag_inst1_TCK                     (jtag_inst1_TCK),
   .jtag_inst1_TDI                     (jtag_inst1_TDI),
   .jtag_inst1_TMS                     (jtag_inst1_TMS),
   .jtag_inst1_UPDATE                  (jtag_inst1_UPDATE),
   .jtag_inst1_TDO                     (jtag_inst1_TDO)
);

endmodule
