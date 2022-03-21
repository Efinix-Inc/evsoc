///////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022 github-efx
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

`include "mipi_parameter.vh"

module edge_vision_soc #(
   //Input frame resolution from MIPI Rx.
   parameter MIPI_FRAME_WIDTH      = 1920,
   parameter MIPI_FRAME_HEIGHT     = 1080,
   //Actual frame resolution used for subsequent processing (after cropping/scaling).
   parameter FRAME_WIDTH           = 1280, //Multiple of 2 - To match with 2PPC pixel data.
   parameter FRAME_HEIGHT          = 720,  //Multiple of 2 - To preserve bayer format prior to raw2rgb conversion.
   //Display resolution setting: "640x480_60Hz" or "1280x720_60Hz"
   parameter DISPLAY_MODE          = "1280x720_60Hz"
) (
   //Clock and Reset Pins
   input          mipi_pll_locked,
   input          lvds_pll_locked,
   input          ddr_clk_locked,
   input          mipi_pclk,
   input          tx_slowclk,
   input          axi_clk_locked,
   input          axi_clk,
   input          soc_clk,
   input          dma_clk,
   output reg     cam1_rstn,
   output reg     cam2_rstn,
   output reg     hdmi_rstn, 

   //MIPI Rx Control
   output         mipi_rx_inst1_DPHY_RSTN,
   output         mipi_rx_inst1_RSTN,
   output [3:0]   mipi_rx_inst1_VC_ENA,
   output [1:0]   mipi_rx_inst1_LANES,
   output         mipi_rx_inst1_CLEAR,
   
   output         mipi_rx_inst2_DPHY_RSTN,
   output         mipi_rx_inst2_RSTN,
   output [3:0]   mipi_rx_inst2_VC_ENA,
   output [1:0]   mipi_rx_inst2_LANES,
   output         mipi_rx_inst2_CLEAR,

   //MIPI Rx Video input
   input [3:0]    mipi_rx_inst1_HSYNC,
   input [3:0]    mipi_rx_inst1_VSYNC,
   input [3:0]    mipi_rx_inst1_CNT,
   input          mipi_rx_inst1_VALID,
   input [5:0]    mipi_rx_inst1_TYPE,
   input [63:0]   mipi_rx_inst1_DATA,
   input [1:0]    mipi_rx_inst1_VC,
   input [17:0]   mipi_rx_inst1_ERR,
   
   input [3:0]    mipi_rx_inst2_HSYNC,
   input [3:0]    mipi_rx_inst2_VSYNC,
   input [3:0]    mipi_rx_inst2_CNT,
   input          mipi_rx_inst2_VALID,
   input [5:0]    mipi_rx_inst2_TYPE,
   input [63:0]   mipi_rx_inst2_DATA,
   input [1:0]    mipi_rx_inst2_VC, 
   input [17:0]   mipi_rx_inst2_ERR,
   
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

   //User LEDs will toggle if MIPI Rx has VSYNC
   output         user_led2,
   output         user_led3,

   //RiscV Soc Pinout
   output         system_uart_0_io_txd,
   input          system_uart_0_io_rxd,
   
   //Cam1
   output         mipi_i2c_0_io_sda_writeEnable,
   output         mipi_i2c_0_io_sda_write,
   input          mipi_i2c_0_io_sda_read,
   output         mipi_i2c_0_io_scl_writeEnable,
   output         mipi_i2c_0_io_scl_write,
   input          mipi_i2c_0_io_scl_read,
   //Cam2
   output         mipi_i2c_2_io_sda_writeEnable,
   output         mipi_i2c_2_io_sda_write,
   input          mipi_i2c_2_io_sda_read,
   output         mipi_i2c_2_io_scl_writeEnable,
   output         mipi_i2c_2_io_scl_write,
   input          mipi_i2c_2_io_scl_read,

   output         hdmi_i2c_1_io_sda_writeEnable,
   output         hdmi_i2c_1_io_sda_write,
   input          hdmi_i2c_1_io_sda_read,
   output         hdmi_i2c_1_io_scl_writeEnable,
   output         hdmi_i2c_1_io_scl_write,
   input          hdmi_i2c_1_io_scl_read,

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

   output         system_spi_0_io_sclk_write,
   output         system_spi_0_io_data_0_writeEnable,
   input          system_spi_0_io_data_0_read,
   output         system_spi_0_io_data_0_write,
   output         system_spi_0_io_data_1_writeEnable,
   input          system_spi_0_io_data_1_read,
   output         system_spi_0_io_data_1_write,
   output         system_spi_0_io_ss,

   //SOC Debugger
`ifndef SOFT_TAP
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
`else
   input          io_jtag_tms,
   input          io_jtag_tdi,
   output         io_jtag_tdo,
   input          io_jtag_tck,
`endif

   //DDR RESET
   output         ddr_inst1_CFG_RST_N,
   output         ddr_inst1_CFG_SEQ_RST,
   output         ddr_inst1_CFG_SEQ_START
);

wire i_arstn;
wire mipi_rst;

assign i_arstn = (!mipi_rst) & mipi_pll_locked && lvds_pll_locked;

//DDR RESET
ddr_reset_seq u_ddr_reset (
   .ddr_rstn_i        (axi_clk_locked),
   .clk               (axi_clk),
   .ddr_rstn          (ddr_inst1_CFG_RST_N),
   .ddr_cfg_seq_rst   (ddr_inst1_CFG_SEQ_RST),
   .ddr_cfg_seq_start (ddr_inst1_CFG_SEQ_START),
   .ddr_init_done     ()
);

//RESET signals for HDMI chip and camera
always @(posedge soc_clk)
begin
   if (~mipi_pll_locked || ~lvds_pll_locked)
   begin
      hdmi_rstn <= 1'b0;
      cam1_rstn <= 1'b0;
      cam2_rstn <= 1'b0;
   end
   else
   begin
      hdmi_rstn <= 1'b1;
      cam1_rstn <= 1'b1;
      cam2_rstn <= 1'b1;
   end
end

/**************************************************************RISC-V SOC**************************************************************/

//Reset and PLL
wire       mcuReset;
wire       io_systemReset;
wire       io_d32_ddrMasterReset;
wire       io_d64_ddrMasterReset;
wire [1:0] io_ddrA_b_payload_resp;
(* keep , syn_keep *) wire       io_memoryReset             /* synthesis syn_keep = 1 */;
(* keep , syn_keep *) wire [3:0] io_ddrA_arw_payload_qos    /* synthesis syn_keep = 1 */;
(* keep , syn_keep *) wire [2:0] io_ddrA_arw_payload_prot   /* synthesis syn_keep = 1 */;
(* keep , syn_keep *) wire [3:0] io_ddrA_arw_payload_cache  /* synthesis syn_keep = 1 */;
(* keep , syn_keep *) wire [3:0] io_ddrA_arw_payload_region /* synthesis syn_keep = 1 */;

//User Interrupt
wire       userInterrupt;
wire       axi4Interrupt;
wire [3:0] dma_interrupts;

//APB Slave 0
wire [15:0] io_apbSlave_0_PADDR;
wire        io_apbSlave_0_PSEL;
wire        io_apbSlave_0_PENABLE;
wire        io_apbSlave_0_PREADY;
wire        io_apbSlave_0_PWRITE;
wire [31:0] io_apbSlave_0_PWDATA;
wire [31:0] io_apbSlave_0_PRDATA;
wire        io_apbSlave_0_PSLVERROR;

//APB Slave 1
wire [15:0] io_apbSlave_1_PADDR;
wire        io_apbSlave_1_PSEL;
wire        io_apbSlave_1_PENABLE;
wire        io_apbSlave_1_PREADY;
wire        io_apbSlave_1_PWRITE;
wire [31:0] io_apbSlave_1_PWDATA;
wire [31:0] io_apbSlave_1_PRDATA;
wire        io_apbSlave_1_PSLVERROR;

//AXI Slave 0
wire [7:0]  axi_awid;
wire [31:0] axi_awaddr;
wire [7:0]  axi_awlen;
wire [2:0]  axi_awsize;
wire [1:0]  axi_awburst;
wire        axi_awlock;
wire [3:0]  axi_awcache;
wire [2:0]  axi_awprot;
wire [3:0]  axi_awqos;
wire [3:0]  axi_awregion;
wire        axi_awvalid;
wire        axi_awready;
wire [31:0] axi_wdata;
wire [3:0]  axi_wstrb;
wire        axi_wvalid;
wire        axi_wlast;
wire        axi_wready;
wire [7:0]  axi_bid;
wire [1:0]  axi_bresp;
wire        axi_bvalid;
wire        axi_bready;
wire [7:0]  axi_arid;
wire [31:0] axi_araddr;
wire [7:0]  axi_arlen;
wire [2:0]  axi_arsize;
wire [1:0]  axi_arburst;
wire        axi_arlock;
wire [3:0]  axi_arcache;
wire [2:0]  axi_arprot;
wire [3:0]  axi_arqos;
wire [3:0]  axi_arregion;
wire        axi_arvalid;
wire        axi_arready;
wire [7:0]  axi_rid;
wire [31:0] axi_rdata;
wire [1:0]  axi_rresp;
wire        axi_rlast;
wire        axi_rvalid;
wire        axi_rready;

//Hardware accelerator
wire        hw_accel_dma1_rready;
wire        hw_accel_dma1_rvalid;
wire [3:0]  hw_accel_dma1_rkeep;
wire [31:0] hw_accel_dma1_rdata;
wire        hw_accel_dma2_rready;
wire        hw_accel_dma2_rvalid;
wire [3:0]  hw_accel_dma2_rkeep;
wire [31:0] hw_accel_dma2_rdata;
wire        hw_accel_dma_wready;
wire        hw_accel_dma_wvalid;
wire        hw_accel_dma_wlast;
wire [31:0] hw_accel_dma_wdata;
wire        hw_accel_axi_we;
wire [31:0] hw_accel_axi_waddr;
wire [31:0] hw_accel_axi_wdata;
wire        hw_accel_axi_re;
wire [31:0] hw_accel_axi_raddr;
wire [31:0] hw_accel_axi_rdata;
wire        hw_accel_axi_rvalid;

//Reset and PLL
assign mcuReset                      = ~(mipi_pll_locked & lvds_pll_locked & ddr_clk_locked);
assign my_pll_rstn                   = 1'b1;
assign my_ddr_pll_rstn               = 1'b1;
//I2C
assign mipi_i2c_0_io_sda_writeEnable = !mipi_i2c_0_io_sda_write;
assign mipi_i2c_0_io_scl_writeEnable = !mipi_i2c_0_io_scl_write;
assign hdmi_i2c_1_io_sda_writeEnable = !hdmi_i2c_1_io_sda_write;
assign hdmi_i2c_1_io_scl_writeEnable = !hdmi_i2c_1_io_scl_write;
assign mipi_i2c_2_io_sda_writeEnable = !mipi_i2c_2_io_sda_write;
assign mipi_i2c_2_io_scl_writeEnable = !mipi_i2c_2_io_scl_write;
//User Interrupt
assign userInterrupt                 = |dma_interrupts;
//DDR controller
assign io_ddrA_b_payload_resp        = 2'b00;

SapphireSoc u_soc (
  .io_systemClk                        (soc_clk),
  .io_asyncReset                       (mcuReset),
  .io_memoryClk                        (axi_clk),
  .io_memoryReset                      (io_memoryReset),
  .system_uart_0_io_txd                (system_uart_0_io_txd),
  .system_uart_0_io_rxd                (system_uart_0_io_rxd),
  .system_i2c_0_io_sda_write           (mipi_i2c_0_io_sda_write),
  .system_i2c_0_io_sda_read            (mipi_i2c_0_io_sda_read),
  .system_i2c_0_io_scl_write           (mipi_i2c_0_io_scl_write),
  .system_i2c_0_io_scl_read            (mipi_i2c_0_io_scl_read),
  .system_i2c_1_io_sda_write           (hdmi_i2c_1_io_sda_write),
  .system_i2c_1_io_sda_read            (hdmi_i2c_1_io_sda_read),
  .system_i2c_1_io_scl_write           (hdmi_i2c_1_io_scl_write),
  .system_i2c_1_io_scl_read            (hdmi_i2c_1_io_scl_read),
  .system_i2c_2_io_sda_write           (mipi_i2c_2_io_sda_write),
  .system_i2c_2_io_sda_read            (mipi_i2c_2_io_sda_read),
  .system_i2c_2_io_scl_write           (mipi_i2c_2_io_scl_write),
  .system_i2c_2_io_scl_read            (mipi_i2c_2_io_scl_read),
  .userInterruptA                      (userInterrupt),
  .io_systemReset                      (io_systemReset),
  //APB slave ports
  .io_apbSlave_0_PADDR                 (io_apbSlave_0_PADDR),
  .io_apbSlave_0_PSEL                  (io_apbSlave_0_PSEL),
  .io_apbSlave_0_PENABLE               (io_apbSlave_0_PENABLE),
  .io_apbSlave_0_PREADY                (io_apbSlave_0_PREADY),
  .io_apbSlave_0_PWRITE                (io_apbSlave_0_PWRITE),
  .io_apbSlave_0_PWDATA                (io_apbSlave_0_PWDATA),
  .io_apbSlave_0_PRDATA                (io_apbSlave_0_PRDATA),
  .io_apbSlave_0_PSLVERROR             (io_apbSlave_0_PSLVERROR),
  .io_apbSlave_1_PADDR                 (io_apbSlave_1_PADDR),
  .io_apbSlave_1_PSEL                  (io_apbSlave_1_PSEL),
  .io_apbSlave_1_PENABLE               (io_apbSlave_1_PENABLE),
  .io_apbSlave_1_PREADY                (io_apbSlave_1_PREADY),
  .io_apbSlave_1_PWRITE                (io_apbSlave_1_PWRITE),
  .io_apbSlave_1_PWDATA                (io_apbSlave_1_PWDATA),
  .io_apbSlave_1_PRDATA                (io_apbSlave_1_PRDATA),
  .io_apbSlave_1_PSLVERROR             (io_apbSlave_1_PSLVERROR),
  //Connect to DDR 128-bit port 
  .io_ddrA_arw_valid                   (io_ddrA_arw_valid),
  .io_ddrA_arw_ready                   (io_ddrA_arw_ready),
  .io_ddrA_arw_payload_addr            (io_ddrA_arw_payload_addr),
  .io_ddrA_arw_payload_id              (io_ddrA_arw_payload_id),
  .io_ddrA_arw_payload_region          (io_ddrA_arw_payload_region),
  .io_ddrA_arw_payload_len             (io_ddrA_arw_payload_len),
  .io_ddrA_arw_payload_size            (io_ddrA_arw_payload_size),
  .io_ddrA_arw_payload_burst           (io_ddrA_arw_payload_burst),
  .io_ddrA_arw_payload_lock            (io_ddrA_arw_payload_lock),
  .io_ddrA_arw_payload_cache           (io_ddrA_arw_payload_cache),
  .io_ddrA_arw_payload_qos             (io_ddrA_arw_payload_qos),
  .io_ddrA_arw_payload_prot            (io_ddrA_arw_payload_prot),
  .io_ddrA_arw_payload_write           (io_ddrA_arw_payload_write),
  .io_ddrA_w_valid                     (io_ddrA_w_valid),
  .io_ddrA_w_ready                     (io_ddrA_w_ready),
  .io_ddrA_w_payload_data              (io_ddrA_w_payload_data),
  .io_ddrA_w_payload_strb              (io_ddrA_w_payload_strb),
  .io_ddrA_w_payload_last              (io_ddrA_w_payload_last),
  .io_ddrA_b_valid                     (io_ddrA_b_valid),
  .io_ddrA_b_ready                     (io_ddrA_b_ready),
  .io_ddrA_b_payload_id                (io_ddrA_b_payload_id),
  .io_ddrA_b_payload_resp              (io_ddrA_b_payload_resp),
  .io_ddrA_r_valid                     (io_ddrA_r_valid),
  .io_ddrA_r_ready                     (io_ddrA_r_ready),
  .io_ddrA_r_payload_data              (io_ddrA_r_payload_data),
  .io_ddrA_r_payload_id                (io_ddrA_r_payload_id),
  .io_ddrA_r_payload_resp              (io_ddrA_r_payload_resp),
  .io_ddrA_r_payload_last              (io_ddrA_r_payload_last),
  .io_ddrA_w_payload_id                (io_ddrA_w_payload_id),
  //SPI
  .system_spi_0_io_sclk_write          (system_spi_0_io_sclk_write),
  .system_spi_0_io_data_0_writeEnable  (system_spi_0_io_data_0_writeEnable),
  .system_spi_0_io_data_0_read         (system_spi_0_io_data_0_read),
  .system_spi_0_io_data_0_write        (system_spi_0_io_data_0_write),
  .system_spi_0_io_data_1_writeEnable  (system_spi_0_io_data_1_writeEnable),
  .system_spi_0_io_data_1_read         (system_spi_0_io_data_1_read),
  .system_spi_0_io_data_1_write        (system_spi_0_io_data_1_write),
  .system_spi_0_io_ss                  (system_spi_0_io_ss),
  //AXI4 slave port
  .axiA_awvalid                        (axi_awvalid),
  .axiA_awready                        (axi_awready),
  .axiA_awaddr                         (axi_awaddr),
  .axiA_awid                           (axi_awid),
  .axiA_awregion                       (axi_awregion),
  .axiA_awlen                          (axi_awlen),
  .axiA_awsize                         (axi_awsize),
  .axiA_awburst                        (axi_awburst),
  .axiA_awlock                         (axi_awlock),
  .axiA_awcache                        (axi_awcache),
  .axiA_awqos                          (axi_awqos),
  .axiA_awprot                         (axi_awprot),
  .axiA_wvalid                         (axi_wvalid),
  .axiA_wready                         (axi_wready),
  .axiA_wdata                          (axi_wdata),
  .axiA_wstrb                          (axi_wstrb),
  .axiA_wlast                          (axi_wlast),
  .axiA_bvalid                         (axi_bvalid),
  .axiA_bready                         (axi_bready),
  .axiA_bid                            (axi_bid),
  .axiA_bresp                          (axi_bresp),
  .axiA_arvalid                        (axi_arvalid),
  .axiA_arready                        (axi_arready),
  .axiA_araddr                         (axi_araddr),
  .axiA_arid                           (axi_arid),
  .axiA_arregion                       (axi_arregion),
  .axiA_arlen                          (axi_arlen),
  .axiA_arsize                         (axi_arsize),
  .axiA_arburst                        (axi_arburst),
  .axiA_arlock                         (axi_arlock),
  .axiA_arcache                        (axi_arcache),
  .axiA_arqos                          (axi_arqos),
  .axiA_arprot                         (axi_arprot),
  .axiA_rvalid                         (axi_rvalid),
  .axiA_rready                         (axi_rready),
  .axiA_rdata                          (axi_rdata),
  .axiA_rid                            (axi_rid),
  .axiA_rresp                          (axi_rresp),
  .axiA_rlast                          (axi_rlast),
  .axiAInterrupt                       (axi4Interrupt),
  //JTAG
`ifndef SOFT_TAP
  .jtagCtrl_tck                        (jtag_inst1_TCK),
  .jtagCtrl_tdi                        (jtag_inst1_TDI),
  .jtagCtrl_tdo                        (jtag_inst1_TDO),
  .jtagCtrl_enable                     (jtag_inst1_SEL),
  .jtagCtrl_capture                    (jtag_inst1_CAPTURE),
  .jtagCtrl_shift                      (jtag_inst1_SHIFT),
  .jtagCtrl_update                     (jtag_inst1_UPDATE),
  .jtagCtrl_reset                      (jtag_inst1_RESET)
`else
  .io_jtag_tms                         (io_jtag_tms),
  .io_jtag_tdi                         (io_jtag_tdi),
  .io_jtag_tdo                         (io_jtag_tdo),
  .io_jtag_tck                         (io_jtag_tck)
`endif
);

/**************************************************************CAMERA**************************************************************/

//MIPI Rx settings
assign mipi_rx_inst1_DPHY_RSTN         = 1'b1;
assign mipi_rx_inst1_RSTN              = 1'b1;
assign mipi_rx_inst1_VC_ENA[`MIPI_VC0] = 1'b1;
assign mipi_rx_inst1_VC_ENA[`MIPI_VC1] = 1'b0;
assign mipi_rx_inst1_VC_ENA[`MIPI_VC2] = 1'b0;
assign mipi_rx_inst1_VC_ENA[`MIPI_VC3] = 1'b0;
assign mipi_rx_inst1_CLEAR             = 1'b0;
assign mipi_rx_inst1_LANES             = 2'b01;

assign mipi_rx_inst2_DPHY_RSTN         = 1'b1;
assign mipi_rx_inst2_RSTN              = 1'b1;
assign mipi_rx_inst2_VC_ENA[`MIPI_VC0] = 1'b1;
assign mipi_rx_inst2_VC_ENA[`MIPI_VC1] = 1'b0;
assign mipi_rx_inst2_VC_ENA[`MIPI_VC2] = 1'b0;
assign mipi_rx_inst2_VC_ENA[`MIPI_VC3] = 1'b0;
assign mipi_rx_inst2_CLEAR             = 1'b0;
assign mipi_rx_inst2_LANES             = 2'b01;

//MIPI RX
wire [63:0]  rx1_data;
wire         rx1_valid;
wire         rx1_vs;
wire         rx1_hs;
wire [5:0]   rx1_type;
wire [17:0]  rx1_error;
wire [1:0]   rx1_vc;
wire [3:0]   rx1_count;

wire [63:0]  rx2_data;
wire         rx2_valid;
wire         rx2_vs;
wire         rx2_hs;
wire [5:0]   rx2_type;
wire [17:0]  rx2_error;
wire [1:0]   rx2_vc;
wire [3:0]   rx2_count;

wire         cam1_dma_wready;
wire         cam1_dma_wvalid;
wire         cam1_dma_wlast;
wire [63:0]  cam1_dma_wdata;
wire [15:0]  cam1_rgb_control;
wire         cam1_trigger_capture_frame;
wire         cam1_continuous_capture_frame;
wire         cam1_rgb_gray;
wire         cam1_dma_init_done;
wire [31:0]  cam1_frames_per_second;
wire         debug_cam1_pixel_remap_fifo_overflow;
wire         debug_cam1_pixel_remap_fifo_underflow;
wire         debug_cam1_dma_fifo_overflow;
wire         debug_cam1_dma_fifo_underflow;
wire         debug_cam1_scaler_fifo_overflow;
wire         debug_cam1_scaler_fifo_underflow;
wire [31:0]  debug_cam1_dma_fifo_rcount;
wire [31:0]  debug_cam1_dma_fifo_wcount;
wire [31:0]  debug_cam1_dma_status;

wire         cam2_dma_wready;
wire         cam2_dma_wvalid;
wire         cam2_dma_wlast;
wire [63:0]  cam2_dma_wdata;
wire [15:0]  cam2_rgb_control;
wire         cam2_trigger_capture_frame;
wire         cam2_continuous_capture_frame;
wire         cam2_rgb_gray;
wire         cam2_dma_init_done;
wire [31:0]  cam2_frames_per_second;
wire         debug_cam2_pixel_remap_fifo_overflow;
wire         debug_cam2_pixel_remap_fifo_underflow;
wire         debug_cam2_dma_fifo_overflow;
wire         debug_cam2_dma_fifo_underflow;
wire         debug_cam2_scaler_fifo_overflow;
wire         debug_cam2_scaler_fifo_underflow;
wire [31:0]  debug_cam2_dma_fifo_rcount;
wire [31:0]  debug_cam2_dma_fifo_wcount;
wire [31:0]  debug_cam2_dma_status;

reg          vsync_LED;
reg  [4:0]   flash_cnt;

assign rx1_data  = mipi_rx_inst1_DATA;
assign rx1_valid = mipi_rx_inst1_VALID;
assign rx1_vs    = mipi_rx_inst1_VSYNC[0];
assign rx1_hs    = mipi_rx_inst1_HSYNC[0];
assign rx1_type  = mipi_rx_inst1_TYPE;
assign rx1_error = mipi_rx_inst1_ERR;
assign rx1_vc    = mipi_rx_inst1_VC;
assign rx1_count = mipi_rx_inst1_CNT;

assign rx2_data  = mipi_rx_inst2_DATA;
assign rx2_valid = mipi_rx_inst2_VALID;
assign rx2_vs    = mipi_rx_inst2_VSYNC[0];
assign rx2_hs    = mipi_rx_inst2_HSYNC[0];
assign rx2_type  = mipi_rx_inst2_TYPE;
assign rx2_error = mipi_rx_inst2_ERR;
assign rx2_vc    = mipi_rx_inst2_VC;
assign rx2_count = mipi_rx_inst2_CNT;

cam_picam_v2 # (
   .MIPI_FRAME_WIDTH     (MIPI_FRAME_WIDTH),             //Input frame resolution from MIPI
   .MIPI_FRAME_HEIGHT    (MIPI_FRAME_HEIGHT),            //Input frame resolution from MIPI
   .FRAME_WIDTH          (FRAME_WIDTH),                  //Output frame resolution to DDR
   .FRAME_HEIGHT         (FRAME_HEIGHT),                 //Output frame resolution to DDR
   .DMA_TRANSFER_LENGTH  ((FRAME_WIDTH*FRAME_HEIGHT)/2), //2PPC
   .CROP_SCALE           (0)                             //0: Crop to output resolution; 1: Scale to output resolution
) u_cam1 (
   .mipi_pclk                             (mipi_pclk),
   .rst_n                                 (i_arstn),
   .mipi_cam_data                         (rx1_data),
   .mipi_cam_valid                        (rx1_valid),
   .mipi_cam_vs                           (rx1_vs),
   .mipi_cam_hs                           (rx1_hs),
   .mipi_cam_type                         (rx1_type),
   .mipi_cam_error                        (rx1_error),
   .mipi_cam_vc                           (rx1_vc),
   .mipi_cam_count                        (rx1_count),
`ifdef SIM
   //Simulation frame data from testbench
   .sim_cam_hsync                         (sim_cam_hsync),
   .sim_cam_vsync                         (sim_cam_vsync),
   .sim_cam_valid                         (sim_cam_valid),
   .sim_cam_r_pix                         (sim_cam_r_pix),
   .sim_cam_g_pix                         (sim_cam_g_pix),
   .sim_cam_b_pix                         (sim_cam_b_pix),
`endif
   .cam_dma_wready                        (cam1_dma_wready),
   .cam_dma_wvalid                        (cam1_dma_wvalid),
   .cam_dma_wlast                         (cam1_dma_wlast),
   .cam_dma_wdata                         (cam1_dma_wdata),
   .rgb_control                           (cam1_rgb_control),
   .trigger_capture_frame                 (cam1_trigger_capture_frame),
   .continuous_capture_frame              (cam1_continuous_capture_frame),
   .rgb_gray                              (cam1_rgb_gray),
   .cam_dma_init_done                     (cam1_dma_init_done),
   .frames_per_second                     (cam1_frames_per_second),
   .debug_cam_pixel_remap_fifo_overflow   (debug_cam1_pixel_remap_fifo_overflow),
   .debug_cam_pixel_remap_fifo_underflow  (debug_cam1_pixel_remap_fifo_underflow),
   .debug_cam_dma_fifo_overflow           (debug_cam1_dma_fifo_overflow),
   .debug_cam_dma_fifo_underflow          (debug_cam1_dma_fifo_underflow),
   .debug_cam_scaler_fifo_overflow        (debug_cam1_scaler_fifo_overflow),
   .debug_cam_scaler_fifo_underflow       (debug_cam1_scaler_fifo_underflow),
   .debug_cam_dma_fifo_rcount             (debug_cam1_dma_fifo_rcount),
   .debug_cam_dma_fifo_wcount             (debug_cam1_dma_fifo_wcount),
   .debug_cam_dma_status                  (debug_cam1_dma_status)
);

cam_picam_v2 # (
   .MIPI_FRAME_WIDTH     (MIPI_FRAME_WIDTH),             //Input frame resolution from MIPI
   .MIPI_FRAME_HEIGHT    (MIPI_FRAME_HEIGHT),            //Input frame resolution from MIPI
   .FRAME_WIDTH          (FRAME_WIDTH),                  //Output frame resolution to DDR
   .FRAME_HEIGHT         (FRAME_HEIGHT),                 //Output frame resolution to DDR
   .DMA_TRANSFER_LENGTH  ((FRAME_WIDTH*FRAME_HEIGHT)/2), //2PPC
   .CROP_SCALE           (0)                             //0: Crop to output resolution; 1: Scale to output resolution
) u_cam2 (
   .mipi_pclk                             (mipi_pclk),
   .rst_n                                 (i_arstn),
   .mipi_cam_data                         (rx2_data),
   .mipi_cam_valid                        (rx2_valid),
   .mipi_cam_vs                           (rx2_vs),
   .mipi_cam_hs                           (rx2_hs),
   .mipi_cam_type                         (rx2_type),
   .mipi_cam_error                        (rx2_error),
   .mipi_cam_vc                           (rx2_vc),
   .mipi_cam_count                        (rx2_count),
`ifdef SIM
   //Simulation frame data from testbench
   .sim_cam_hsync                         (sim_cam_hsync),
   .sim_cam_vsync                         (sim_cam_vsync),
   .sim_cam_valid                         (sim_cam_valid),
   .sim_cam_r_pix                         (sim_cam_r_pix),
   .sim_cam_g_pix                         (sim_cam_g_pix),
   .sim_cam_b_pix                         (sim_cam_b_pix),
`endif
   .cam_dma_wready                        (cam2_dma_wready),
   .cam_dma_wvalid                        (cam2_dma_wvalid),
   .cam_dma_wlast                         (cam2_dma_wlast),
   .cam_dma_wdata                         (cam2_dma_wdata),
   .rgb_control                           (cam2_rgb_control),
   .trigger_capture_frame                 (cam2_trigger_capture_frame),
   .continuous_capture_frame              (cam2_continuous_capture_frame),
   .rgb_gray                              (cam2_rgb_gray),
   .cam_dma_init_done                     (cam2_dma_init_done),
   .frames_per_second                     (cam2_frames_per_second),
   .debug_cam_pixel_remap_fifo_overflow   (debug_cam2_pixel_remap_fifo_overflow),
   .debug_cam_pixel_remap_fifo_underflow  (debug_cam2_pixel_remap_fifo_underflow),
   .debug_cam_dma_fifo_overflow           (debug_cam2_dma_fifo_overflow),
   .debug_cam_dma_fifo_underflow          (debug_cam2_dma_fifo_underflow),
   .debug_cam_scaler_fifo_overflow        (debug_cam2_scaler_fifo_overflow),
   .debug_cam_scaler_fifo_underflow       (debug_cam2_scaler_fifo_underflow),
   .debug_cam_dma_fifo_rcount             (debug_cam2_dma_fifo_rcount),
   .debug_cam_dma_fifo_wcount             (debug_cam2_dma_fifo_wcount),
   .debug_cam_dma_status                  (debug_cam2_dma_status)
);

//User LEDs will toggle if there MIPI Rx has VS
always @(posedge mipi_pclk)
begin
   if (~i_arstn)
      flash_cnt <= 5'b0;
   else 
   if (mipi_rx_inst1_ERR[9]) // bit9 will be "1"   if there is no error
   begin
      vsync_LED <= mipi_rx_inst1_VSYNC[0];
      if (!vsync_LED && mipi_rx_inst1_VSYNC[0])
         flash_cnt <= flash_cnt + 1'b1;
      else
      if (flash_cnt == 5'b11111)
         flash_cnt <= 1;
   end
end

assign user_led2 = flash_cnt[4];
assign user_led3 = ~flash_cnt[4];

/**************************************************************DISPLAY**************************************************************/

wire        display_dma_rready;
wire        display_dma_rvalid;
wire [63:0] display_dma_rdata;
wire [7:0]  display_dma_rkeep;
wire        debug_display_dma_fifo_overflow;
wire        debug_display_dma_fifo_underflow;
wire [31:0] debug_display_dma_fifo_rcount;
wire [31:0] debug_display_dma_fifo_wcount;

display_lvds # (
   .DISPLAY_MODE (DISPLAY_MODE)
) u_display (
   .lvds_slowclk                     (tx_slowclk),
   .rst_n                            (i_arstn),
   .display_dma_rdata                (display_dma_rdata),
   .display_dma_rvalid               (display_dma_rvalid),
   .display_dma_rready               (display_dma_rready),
   .display_dma_rkeep                (display_dma_rkeep),
   .lvds_1a_DATA                     (lvds_1a_DATA),
   .lvds_1b_DATA                     (lvds_1b_DATA),
   .lvds_1c_DATA                     (lvds_1c_DATA),
   .lvds_1d_DATA                     (lvds_1d_DATA),
   .lvds_2a_DATA                     (lvds_2a_DATA),
   .lvds_2b_DATA                     (lvds_2b_DATA),
   .lvds_2c_DATA                     (lvds_2c_DATA),
   .lvds_2d_DATA                     (lvds_2d_DATA),
   .lvds_clk                         (lvds_clk),
   .debug_display_dma_fifo_overflow  (debug_display_dma_fifo_overflow),
   .debug_display_dma_fifo_underflow (debug_display_dma_fifo_underflow),
   .debug_display_dma_fifo_rcount    (debug_display_dma_fifo_rcount),
   .debug_display_dma_fifo_wcount    (debug_display_dma_fifo_wcount)
);

/****************************************************CAM & DISPLAY CONTROL/DEBUG****************************************************/

wire [31:0] debug_cam_display_fifo_status;

assign debug_cam_display_fifo_status = {18'd0,debug_cam1_scaler_fifo_underflow, debug_cam1_scaler_fifo_overflow,debug_cam2_scaler_fifo_underflow, debug_cam2_scaler_fifo_overflow, 
                                        debug_cam1_pixel_remap_fifo_underflow, debug_cam1_pixel_remap_fifo_overflow, debug_cam1_dma_fifo_underflow, debug_cam1_dma_fifo_overflow, 
                                        debug_cam2_pixel_remap_fifo_underflow, debug_cam2_pixel_remap_fifo_overflow, debug_cam2_dma_fifo_underflow, debug_cam2_dma_fifo_overflow,
                                        debug_display_dma_fifo_underflow, debug_display_dma_fifo_overflow};

//Shared for both camera and display
apb3_cam_dual_cam #(
   .ADDR_WIDTH (16),
   .DATA_WIDTH (32),
   .NUM_REG    (9)
) u_apb3_cam_display (
   .mipi_rst                      (mipi_rst),
   .cam1_rgb_control              (cam1_rgb_control),
   .cam1_trigger_capture_frame    (cam1_trigger_capture_frame),
   .cam1_continuous_capture_frame (cam1_continuous_capture_frame),
   .cam1_rgb_gray                 (cam1_rgb_gray),
   .cam1_dma_init_done            (cam1_dma_init_done),
   .cam1_frames_per_second        (cam1_frames_per_second),
   .debug_cam1_dma_fifo_rcount    (debug_cam1_dma_fifo_rcount),
   .debug_cam1_dma_fifo_wcount    (debug_cam1_dma_fifo_wcount),
   .debug_cam1_dma_status         (debug_cam1_dma_status),
   .cam2_rgb_control              (cam2_rgb_control),
   .cam2_trigger_capture_frame    (cam2_trigger_capture_frame),
   .cam2_continuous_capture_frame (cam2_continuous_capture_frame),
   .cam2_rgb_gray                 (cam2_rgb_gray),
   .cam2_dma_init_done            (cam2_dma_init_done),
   .cam2_frames_per_second        (cam2_frames_per_second),
   .debug_cam2_dma_fifo_rcount    (debug_cam2_dma_fifo_rcount),
   .debug_cam2_dma_fifo_wcount    (debug_cam2_dma_fifo_wcount),
   .debug_cam2_dma_status         (debug_cam2_dma_status),
   .debug_fifo_status             (debug_cam_display_fifo_status),
   .debug_display_dma_fifo_rcount (debug_display_dma_fifo_rcount),
   .debug_display_dma_fifo_wcount (debug_display_dma_fifo_wcount),
   .clk                           (soc_clk),
   .resetn                        (~io_systemReset),
   .PADDR                         (io_apbSlave_0_PADDR),
   .PSEL                          (io_apbSlave_0_PSEL),
   .PENABLE                       (io_apbSlave_0_PENABLE),
   .PREADY                        (io_apbSlave_0_PREADY),
   .PWRITE                        (io_apbSlave_0_PWRITE),
   .PWDATA                        (io_apbSlave_0_PWDATA),
   .PRDATA                        (io_apbSlave_0_PRDATA),
   .PSLVERROR                     (io_apbSlave_0_PSLVERROR)
);

/**************************************************************DMA**************************************************************/

assign io_ddrB_arw_payload_id = 'hE0;
assign io_ddrB_w_payload_id   = 'hE1;

dma u_dma (
   .clk                      (dma_clk),
   .reset                    (~i_arstn),
   //APB3 slave and interrupt
   .ctrl_clk                 (soc_clk),
   .ctrl_reset               (io_systemReset),
   .ctrl_PADDR               (io_apbSlave_1_PADDR [13:0]),
   .ctrl_PSEL                (io_apbSlave_1_PSEL),
   .ctrl_PENABLE             (io_apbSlave_1_PENABLE),
   .ctrl_PREADY              (io_apbSlave_1_PREADY),
   .ctrl_PWRITE              (io_apbSlave_1_PWRITE),
   .ctrl_PWDATA              (io_apbSlave_1_PWDATA),
   .ctrl_PRDATA              (io_apbSlave_1_PRDATA),
   .ctrl_PSLVERROR           (io_apbSlave_1_PSLVERROR),
   .ctrl_interrupts          (dma_interrupts),
   //DDR port
   .axi_arwvalid             (io_ddrB_arw_valid),
   .axi_arwready             (io_ddrB_arw_ready),
   .axi_arwaddr              (io_ddrB_arw_payload_addr),
   .axi_arwlen               (io_ddrB_arw_payload_len),
   .axi_arwsize              (io_ddrB_arw_payload_size),
   .axi_arwburst             (io_ddrB_arw_payload_burst),
   .axi_arwlock              (io_ddrB_arw_payload_lock),
   .axi_arwwrite             (io_ddrB_arw_payload_write),
   .axi_wvalid               (io_ddrB_w_valid),
   .axi_wready               (io_ddrB_w_ready),
   .axi_wdata                (io_ddrB_w_payload_data),
   .axi_wstrb                (io_ddrB_w_payload_strb),
   .axi_wlast                (io_ddrB_w_payload_last),
   .axi_bvalid               (io_ddrB_b_valid),
   .axi_bready               (io_ddrB_b_ready),
   .axi_bresp                (2'd0),
   .axi_rvalid               (io_ddrB_r_valid),
   .axi_rready               (io_ddrB_r_ready),
   .axi_rdata                (io_ddrB_r_payload_data),
   .axi_rresp                (io_ddrB_r_payload_resp),
   .axi_rlast                (io_ddrB_r_payload_last),
   //64-bit dma channel (S2MM - to DDR)
   .dat0_i_clk               (mipi_pclk),
   .dat0_i_reset             (~i_arstn),
   .dat0_i_tvalid            (cam1_dma_wvalid),
   .dat0_i_tready            (cam1_dma_wready),
   .dat0_i_tdata             (cam1_dma_wdata),
   .dat0_i_tkeep             ({8{cam1_dma_wvalid}}),
   .dat0_i_tdest             (4'd0),
   .dat0_i_tlast             (cam1_dma_wlast),
   //64-bit dma channel (S2MM - to DDR)
   .dat1_i_clk               (mipi_pclk),
   .dat1_i_reset             (~i_arstn),
   .dat1_i_tvalid            (cam2_dma_wvalid),
   .dat1_i_tready            (cam2_dma_wready), 
   .dat1_i_tdata             (cam2_dma_wdata),
   .dat1_i_tkeep             ({8{cam2_dma_wvalid}}),
   .dat1_i_tdest             (4'd0),
   .dat1_i_tlast             (cam2_dma_wlast),
   //64-bit dma channel (MM2S - from DDR)
   .dat2_o_clk               (tx_slowclk),
   .dat2_o_reset             (~i_arstn),
   .dat2_o_tvalid            (display_dma_rvalid),
   .dat2_o_tready            (display_dma_rready),
   .dat2_o_tdata             (display_dma_rdata),
   .dat2_o_tkeep             (display_dma_rkeep),
   .dat2_o_tdest             (),
   .dat2_o_tlast             (),
   //32-bit dma channel (S2MM - to DDR)
   .dat3_i_clk               (axi_clk),
   .dat3_i_reset             (~i_arstn),
   .dat3_i_tvalid            (hw_accel_dma_wvalid),
   .dat3_i_tready            (hw_accel_dma_wready),
   .dat3_i_tdata             (hw_accel_dma_wdata),
   .dat3_i_tkeep             ({4{hw_accel_dma_wvalid}}),
   .dat3_i_tdest             (4'd0),
   .dat3_i_tlast             (hw_accel_dma_wlast),
   //32-bit dma channel (MM2S - from DDR)
   .dat4_o_clk               (axi_clk),
   .dat4_o_reset             (~i_arstn),
   .dat4_o_tvalid            (hw_accel_dma1_rvalid),
   .dat4_o_tready            (hw_accel_dma1_rready),
   .dat4_o_tdata             (hw_accel_dma1_rdata),
   .dat4_o_tkeep             (hw_accel_dma1_rkeep),
   .dat4_o_tdest             (),
   .dat4_o_tlast             (),
   //32-bit dma channel (MM2S - from DDR)
   .dat5_o_clk               (axi_clk),
   .dat5_o_reset             (~i_arstn),
   .dat5_o_tvalid            (hw_accel_dma2_rvalid),
   .dat5_o_tready            (hw_accel_dma2_rready),
   .dat5_o_tdata             (hw_accel_dma2_rdata),
   .dat5_o_tkeep             (hw_accel_dma2_rkeep),
   .dat5_o_tdest             (),
   .dat5_o_tlast             ()
);

/**************************************************************HW ACCELERATOR**************************************************************/

axi4_hw_accel #(
   .ADDR_WIDTH (32),
   .DATA_WIDTH (32)
) u_axi4_hw_accel (
   .axi_interrupt (axi4Interrupt),
   .axi_aclk      (soc_clk),
   .axi_resetn    (~io_systemReset),
   .axi_awid      (axi_awid),
   .axi_awaddr    (axi_awaddr),
   .axi_awlen     (axi_awlen),
   .axi_awsize    (axi_awsize),
   .axi_awburst   (axi_awburst),
   .axi_awlock    (axi_awlock),
   .axi_awcache   (axi_awcache),
   .axi_awprot    (axi_awprot),
   .axi_awqos     (axi_awqos),
   .axi_awregion  (axi_awregion),
   .axi_awvalid   (axi_awvalid),
   .axi_awready   (axi_awready),
   .axi_wdata     (axi_wdata),
   .axi_wstrb     (axi_wstrb),
   .axi_wlast     (axi_wlast),
   .axi_wvalid    (axi_wvalid),
   .axi_wready    (axi_wready),
   .axi_bid       (axi_bid),
   .axi_bresp     (axi_bresp),
   .axi_bvalid    (axi_bvalid),
   .axi_bready    (axi_bready),
   .axi_arid      (axi_arid),
   .axi_araddr    (axi_araddr),
   .axi_arlen     (axi_arlen),
   .axi_arsize    (axi_arsize),
   .axi_arburst   (axi_arburst),
   .axi_arlock    (axi_arlock),
   .axi_arcache   (axi_arcache),
   .axi_arprot    (axi_arprot),
   .axi_arqos     (axi_arqos),
   .axi_arregion  (axi_arregion),
   .axi_arvalid   (axi_arvalid),
   .axi_arready   (axi_arready),
   .axi_rid       (axi_rid),
   .axi_rdata     (axi_rdata),
   .axi_rresp     (axi_rresp),
   .axi_rlast     (axi_rlast),
   .axi_rvalid    (axi_rvalid),
   .axi_rready    (axi_rready),
   .usr_we        (hw_accel_axi_we),
   .usr_waddr     (hw_accel_axi_waddr),
   .usr_wdata     (hw_accel_axi_wdata),
   .usr_re        (hw_accel_axi_re),
   .usr_raddr     (hw_accel_axi_raddr),
   .usr_rdata     (hw_accel_axi_rdata),
   .usr_rvalid    (hw_accel_axi_rvalid)
);

hw_accel_wrapper_dual_cam #(
   .FRAME_WIDTH         (FRAME_WIDTH),
   .FRAME_HEIGHT        (FRAME_HEIGHT),
   .DMA_TRANSFER_LENGTH (FRAME_WIDTH*FRAME_HEIGHT) //S2MM DMA transfer
) u_hw_accel_wrapper (
   .clk                   (axi_clk),
   .rst                   (~i_arstn),
   .axi_slave_clk         (soc_clk),
   .axi_slave_rst         (io_systemReset),
   .axi_slave_we          (hw_accel_axi_we),
   .axi_slave_waddr       (hw_accel_axi_waddr),
   .axi_slave_wdata       (hw_accel_axi_wdata),
   .axi_slave_re          (hw_accel_axi_re),
   .axi_slave_raddr       (hw_accel_axi_raddr),
   .axi_slave_rdata       (hw_accel_axi_rdata),
   .axi_slave_rvalid      (hw_accel_axi_rvalid),
   .dma1_rready           (hw_accel_dma1_rready),
   .dma1_rvalid           (hw_accel_dma1_rvalid),
   .dma1_rdata            (hw_accel_dma1_rdata),
   .dma1_rkeep            (hw_accel_dma1_rkeep),
   .dma2_rready           (hw_accel_dma2_rready),
   .dma2_rvalid           (hw_accel_dma2_rvalid),
   .dma2_rdata            (hw_accel_dma2_rdata),
   .dma2_rkeep            (hw_accel_dma2_rkeep),
   .dma_wready            (hw_accel_dma_wready),
   .dma_wvalid            (hw_accel_dma_wvalid),
   .dma_wlast             (hw_accel_dma_wlast),
   .dma_wdata             (hw_accel_dma_wdata)
);

endmodule
