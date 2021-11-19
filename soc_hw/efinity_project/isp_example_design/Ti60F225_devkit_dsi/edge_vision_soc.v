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

module edge_vision_soc #(
   //Input frame resolution from MIPI Rx.
   parameter MIPI_FRAME_WIDTH      = 1920,  
   parameter MIPI_FRAME_HEIGHT     = 1080,
   //Actual frame resolution used for subsequent processing (after cropping/scaling).
   parameter FRAME_WIDTH           = 540, //Multiple of 2 - To match with 2PPC pixel data.
   parameter FRAME_HEIGHT          = 540  //Multiple of 2 - To preserve bayer format prior to raw2rgb conversion.
)(
   input    wire           i_arstn,
   input    wire           i_fb_clk,
   input    wire           i_sysclk_div_2,
   input    wire           i_mipi_rx_pclk,
   input    wire           i_pll_locked,
   
   input    wire           i_mipi_clk,
   input    wire           i_mipi_txc_sclk,
   input    wire           i_mipi_txd_sclk,
   input    wire           i_mipi_tx_pclk,
   input    wire           i_mipi_tx_pll_locked,
   
   input    wire           i_hbramClk,
   input    wire           i_hbramClk_cal,
   input    wire           i_hbramClk90,
   input    wire           i_systemClk,
   input    wire           i_hbramClk_pll_locked,
   
   output   wire  [2:0]    o_hbc_cal_SHIFT,
   output   wire  [4:0]    o_hbc_cal_SHIFT_SEL,
   output   wire           o_hbc_cal_SHIFT_ENA,
   output   wire           o_hbramClk_pll_rstn,
   
   output   wire           o_lcd_rstn,
   output   wire           o_pll_rstn,
   output   wire           o_mipi_pll_rstn,
   
   //Camera configuration
   output  wire            mipi_i2c_0_io_sda_writeEnable,
   input   wire            mipi_i2c_0_io_sda_read,
   output  wire            mipi_i2c_0_io_scl_writeEnable,
   input   wire            mipi_i2c_0_io_scl_read,
   output  wire            o_cam_rstn,
   
   //MIPI RX - Camera
   input    wire           i_cam_ck_LP_P_IN,
   input    wire           i_cam_ck_LP_N_IN,
   output   wire           o_cam_ck_HS_TERM,
   output   wire           o_cam_ck_HS_ENA,
   input    wire           i_cam_ck_CLKOUT_0,
   
   input    wire  [7:0]    i_cam_d0_HS_IN_0,
   input    wire  [7:0]    i_cam_d0_HS_IN_1,
   input    wire  [7:0]    i_cam_d0_HS_IN_2,
   input    wire  [7:0]    i_cam_d0_HS_IN_3,
   input    wire           i_cam_d0_LP_P_IN,
   input    wire           i_cam_d0_LP_N_IN,
   output   wire           o_cam_d0_HS_TERM,
   output   wire           o_cam_d0_HS_ENA,
   output   wire           o_cam_d0_RST,
   output   wire           o_cam_d0_FIFO_RD,
   input    wire           i_cam_d0_FIFO_EMPTY,
   
   input    wire  [7:0]    i_cam_d1_HS_IN_0,
   input    wire  [7:0]    i_cam_d1_HS_IN_1,
   input    wire  [7:0]    i_cam_d1_HS_IN_2,
   input    wire  [7:0]    i_cam_d1_HS_IN_3,
   input    wire           i_cam_d1_LP_P_IN,
   input    wire           i_cam_d1_LP_N_IN,
   output   wire           o_cam_d1_HS_TERM,
   output   wire           o_cam_d1_HS_ENA,
   output   wire           o_cam_d1_RST,
   output   wire           o_cam_d1_FIFO_RD,
   input    wire           i_cam_d1_FIFO_EMPTY,

`ifdef SIM
   //Simulation frame data from testbench
   input    wire           sim_cam_hsync,
   input    wire           sim_cam_vsync,
   input    wire           sim_cam_valid,
   input    wire  [15:0]   sim_cam_r_pix,
   input    wire  [15:0]   sim_cam_g_pix,
   input    wire  [15:0]   sim_cam_b_pix,
`endif
   
   //MIPI TX - Display Panel
   output   wire           mipi_dp_clk_LP_P_OUT,
   output   wire           mipi_dp_clk_LP_N_OUT,
   output   wire  [7:0]    mipi_dp_clk_HS_OUT,
   output   wire           mipi_dp_clk_HS_OE,
   output   wire           mipi_dp_data3_LP_P_OUT,
   output   wire           mipi_dp_data2_LP_P_OUT,
   output   wire           mipi_dp_data1_LP_P_OUT,
   output   wire           mipi_dp_data0_LP_P_OUT,
   output   wire           mipi_dp_data3_LP_N_OUT,
   output   wire           mipi_dp_data2_LP_N_OUT,
   output   wire           mipi_dp_data1_LP_N_OUT,
   output   wire           mipi_dp_data0_LP_N_OUT,
   output   wire  [7:0]    mipi_dp_data0_HS_OUT,
   output   wire  [7:0]    mipi_dp_data1_HS_OUT,
   output   wire  [7:0]    mipi_dp_data2_HS_OUT,
   output   wire  [7:0]    mipi_dp_data3_HS_OUT,
   output   wire           mipi_dp_data3_HS_OE,
   output   wire           mipi_dp_data2_HS_OE,
   output   wire           mipi_dp_data1_HS_OE,
   output   wire           mipi_dp_data0_HS_OE,
   
   output   wire           mipi_dp_clk_RST,
   output   wire           mipi_dp_data0_RST,
   output   wire           mipi_dp_data1_RST,
   output   wire           mipi_dp_data2_RST,
   output   wire           mipi_dp_data3_RST,
   output   wire           mipi_dp_clk_LP_P_OE,
   output   wire           mipi_dp_clk_LP_N_OE,
   output   wire           mipi_dp_data3_LP_P_OE,
   output   wire           mipi_dp_data3_LP_N_OE,
   output   wire           mipi_dp_data2_LP_P_OE,
   output   wire           mipi_dp_data2_LP_N_OE,
   output   wire           mipi_dp_data1_LP_P_OE,
   output   wire           mipi_dp_data1_LP_N_OE,
   output   wire           mipi_dp_data0_LP_P_OE,
   output   wire           mipi_dp_data0_LP_N_OE,
   
   input    wire           mipi_dp_data0_LP_P_IN,
   input    wire           mipi_dp_data0_LP_N_IN,
   
   output   wire           hbc_rst_n,
   output   wire           hbc_cs_n,
   output   wire           hbc_ck_p_HI,
   output   wire           hbc_ck_p_LO,
   output   wire           hbc_ck_n_HI,
   output   wire           hbc_ck_n_LO,
   output   wire  [1:0]    hbc_rwds_OUT_HI,
   output   wire  [1:0]    hbc_rwds_OUT_LO,
   input    wire  [1:0]    hbc_rwds_IN_HI,
   input    wire  [1:0]    hbc_rwds_IN_LO,
   output   wire  [1:0]    hbc_rwds_OE,
   output   wire  [15:0]   hbc_dq_OUT_HI,
   output   wire  [15:0]   hbc_dq_OUT_LO,
   input    wire  [15:0]   hbc_dq_IN_HI,
   input    wire  [15:0]   hbc_dq_IN_LO,
   output   wire  [15:0]   hbc_dq_OE,
   
   input    wire           sw1,
   input    wire           sw6,
   input    wire           sw7,
   
   output   wire           o_led,
   output   wire           hbc_cal_pass,
   
   output   wire           system_uart_0_io_txd,
   input    wire           system_uart_0_io_rxd,
   output   wire           system_spi_0_io_sclk_write,
   output   wire           system_spi_0_io_data_0_writeEnable,
   input    wire           system_spi_0_io_data_0_read,
   output   wire           system_spi_0_io_data_0_write,
   output   wire           system_spi_0_io_data_1_writeEnable,
   input    wire           system_spi_0_io_data_1_read,
   output   wire           system_spi_0_io_data_1_write,
   output   wire           system_spi_0_io_ss,
   
`ifndef SOFT_TAP
   input    wire           jtag_inst1_TCK,
   input    wire           jtag_inst1_TDI,
   output   wire           jtag_inst1_TDO,
   input    wire           jtag_inst1_SEL,
   input    wire           jtag_inst1_CAPTURE,
   input    wire           jtag_inst1_SHIFT,
   input    wire           jtag_inst1_UPDATE,
   input    wire           jtag_inst1_RESET
`else
   input    wire           io_jtag_tms,
   input    wire           io_jtag_tdi,
   output   wire           io_jtag_tdo,
   input    wire           io_jtag_tck
`endif
);

`ifndef SIM
   `include "./ip/hbram/hbram_define.vh"
`else
   `include "hbram_define.vh"
`endif

////////////////////////////////////////////////////////////////
// System & Debugger
wire                    w_sysclk_arstn;
wire                    w_sysclk_arst;
wire                    w_fb_clk_arstn;
wire                    w_fb_clk_arst;
wire                    w_fb_dp_arstn;
wire                    w_fb_dp_arst;
wire                    w_sys_dp_arstn;
wire                    w_sys_dp_arst;
wire                    w_mipi_rx_pclk_arstn;
wire                    w_mipi_rx_pclk_arst;

////////////////////////////////////////////////////////////////
// MIPI RX - Camera
wire  [7:0]             w_cam_d0_HS_IN;
wire  [7:0]             w_cam_d1_HS_IN;
reg                     w_cam_confdone;
wire                    w_cam_ck_HS_ENA_0;
wire                    w_cam_ck_HS_TERM_0;
wire  [1:0]             w_cam_d_HS_ENA_0;

wire  [5:0]             w_mipi_rx_dt;
wire                    w_mipi_rx_vs;
wire                    w_mipi_rx_hs;
wire                    w_mipi_rx_de;
wire  [63:0]            w_mipi_rx_data;

reg   [10:0]            r_rx_x_mipi;
reg   [10:0]            r_rx_y_mipi;
reg                     r_rx_hs;
reg                     r_rx_vs;  

(* async_reg = "true" *)reg   [1:0]    r_mipi_rx_data_LP_P_IN_0_1P;
(* async_reg = "true" *)reg   [1:0]    r_mipi_rx_data_LP_N_IN_0_1P;
(* async_reg = "true" *)reg   [15:0]   r_mipi_rx_data_HS_IN_0_1P;
(* async_reg = "true" *)reg   [1:0]    r_mipi_rx_data_LP_P_IN_0_2P;
(* async_reg = "true" *)reg   [1:0]    r_mipi_rx_data_LP_N_IN_0_2P;
(* async_reg = "true" *)reg   [15:0]   r_mipi_rx_data_HS_IN_0_2P;

wire  [31:0]            debug_cam_display_fifo_status;
wire  [15:0]            rgb_control;
wire                    trigger_capture_frame;
wire                    continuous_capture_frame;
wire                    rgb_gray;
wire                    cam_dma_init_done;
wire  [31:0]            frames_per_second;
wire                    cam_confdone;

wire                    mipi_i2c_0_io_sda_write;
wire                    mipi_i2c_0_io_scl_write;

////////////////////////////////////////////////////////////////
// DSI Tx - Display Panel
wire  [7:0]             w_aid;
wire  [31:0]            w_aaddr;
wire  [7:0]             w_alen;
wire  [2:0]             w_asize;
wire  [1:0]             w_aburst;
wire  [1:0]             w_alock;
wire                    w_avalid;
wire                    w_aready;
wire                    w_atype;

wire  [7:0]             w_wid;
wire  [AXI_DBW-1:0]     w_wdata;
wire  [AXI_DBW/8-1:0]   w_wstrb;
wire                    w_wlast;
wire                    w_wvalid;
wire                    w_wready;

wire  [7:0]             w_rid;
wire  [AXI_DBW-1:0]     w_rdata;
wire                    w_rlast;
wire                    w_rvalid;
wire                    w_rready;
wire  [1:0]             w_rresp;

wire  [7:0]             w_bid;
wire                    w_bvalid;
wire                    w_bready;

wire  [31:0]            w_axi_rdata;
wire                    w_axi_awready;
wire                    w_axi_wready;
wire                    w_axi_arready;
wire                    w_axi_rvalid;
wire                    w_axi_bvalid;
wire  [6:0]             w_axi_awaddr;
wire                    w_axi_awvalid;
wire  [31:0]            w_axi_wdata;
wire                    w_axi_wvalid;
wire                    w_axi_bready;
wire  [6:0]             w_axi_araddr;
wire                    w_axi_arvalid;
wire                    w_axi_rready;

wire                    w_confdone;
reg   [19:0]            r_rst_cnt;
reg                     r_lcd_rstn;
wire                    r_rstn_video;

wire                    dp_vs;
wire                    dp_hs;
wire                    dp_data_valid;
wire  [15:0]            dp_r_data;
wire  [15:0]            dp_g_data;
wire  [15:0]            dp_b_data;
wire  [8:0]             dp_frame_cnt;

////////////////////////////////////////////////////////////////
// RISC-V SoC
wire                    mcuReset;
wire                    io_memoryClk;
wire                    io_systemReset;
wire                    io_arw_valid;
wire                    io_arw_ready;
wire    [31:0]          io_arw_payload_addr;
wire    [7:0]           io_arw_payload_id;
wire    [7:0]           io_arw_payload_len;
wire    [2:0]           io_arw_payload_size;
wire    [1:0]           io_arw_payload_burst;
wire    [1:0]           io_arw_payload_lock;
wire                    io_arw_payload_write;
wire    [7:0]           io_w_payload_id;
wire                    io_w_valid;
wire                    io_w_ready;
wire    [AXI_DBW-1:0]   io_w_payload_data;
wire    [AXI_DBW/8-1:0] io_w_payload_strb;
wire                    io_w_payload_last;
wire                    io_b_valid;
wire                    io_b_ready;
wire    [7:0]           io_b_payload_id;
wire                    io_r_valid;
wire                    io_r_ready;
wire    [AXI_DBW-1:0]   io_r_payload_data;
wire    [7:0]           io_r_payload_id;
wire    [1:0]           io_r_payload_resp;
wire                    io_r_payload_last;
wire    [1:0]           io_b_payload_resp;

wire                    userInterrupt;
wire                    axi4Interrupt;

wire  [15:0]            io_apbSlave_0_PADDR;
wire                    io_apbSlave_0_PSEL;
wire                    io_apbSlave_0_PENABLE;
wire                    io_apbSlave_0_PREADY;
wire                    io_apbSlave_0_PWRITE;
wire  [31:0]            io_apbSlave_0_PWDATA;
wire  [31:0]            io_apbSlave_0_PRDATA;
wire                    io_apbSlave_0_PSLVERROR;
wire  [15:0]            io_apbSlave_1_PADDR;
wire                    io_apbSlave_1_PSEL;
wire                    io_apbSlave_1_PENABLE;
wire                    io_apbSlave_1_PREADY;
wire                    io_apbSlave_1_PWRITE;
wire  [31:0]            io_apbSlave_1_PWDATA;
wire  [31:0]            io_apbSlave_1_PRDATA;
wire                    io_apbSlave_1_PSLVERROR;

(* keep , syn_keep *) wire       io_memoryReset /* synthesis syn_keep = 1 */;          
(* keep , syn_keep *) wire [3:0] io_arw_payload_qos /* synthesis syn_keep = 1 */;
(* keep , syn_keep *) wire [2:0] io_arw_payload_prot /* synthesis syn_keep = 1 */;
(* keep , syn_keep *) wire [3:0] io_arw_payload_cache /* synthesis syn_keep = 1 */;
(* keep , syn_keep *) wire [3:0] io_arw_payload_region /* synthesis syn_keep = 1 */;

////////////////////////////////////////////////////////////////
// Hardware accelerator related
wire  [7:0]             axi_awid;
wire  [31:0]            axi_awaddr;
wire  [7:0]             axi_awlen;
wire  [2:0]             axi_awsize;
wire  [1:0]             axi_awburst;
wire                    axi_awlock;
wire  [3:0]             axi_awcache;
wire  [2:0]             axi_awprot;
wire  [3:0]             axi_awqos;
wire  [3:0]             axi_awregion;
wire                    axi_awvalid;
wire                    axi_awready;
wire  [31:0]            axi_wdata;
wire  [3:0]             axi_wstrb;
wire                    axi_wvalid;
wire                    axi_wlast;
wire                    axi_wready;
wire  [7:0]             axi_bid;
wire  [1:0]             axi_bresp;
wire                    axi_bvalid;
wire                    axi_bready;
wire  [7:0]             axi_arid;
wire  [31:0]            axi_araddr;
wire  [7:0]             axi_arlen;
wire  [2:0]             axi_arsize;
wire  [1:0]             axi_arburst;
wire                    axi_arlock;
wire  [3:0]             axi_arcache;
wire  [2:0]             axi_arprot;
wire  [3:0]             axi_arqos;
wire  [3:0]             axi_arregion;
wire                    axi_arvalid;
wire                    axi_arready;
wire  [7:0]             axi_rid;
wire  [31:0]            axi_rdata;
wire  [1:0]             axi_rresp;
wire                    axi_rlast;
wire                    axi_rvalid;
wire                    axi_rready;

wire                    hw_accel_axi_we;
wire  [31:0]            hw_accel_axi_waddr;
wire  [31:0]            hw_accel_axi_wdata;
wire                    hw_accel_axi_re;
wire  [31:0]            hw_accel_axi_raddr;
wire  [31:0]            hw_accel_axi_rdata;
wire                    hw_accel_axi_rvalid;

////////////////////////////////////////////////////////////////
// AXI interconnect
wire                    soc_io_arw_valid;
wire                    soc_io_arw_ready;
wire  [31:0]            soc_io_arw_payload_addr;
wire  [7:0]             soc_io_arw_payload_id;
wire  [7:0]             soc_io_arw_payload_len;
wire  [2:0]             soc_io_arw_payload_size;
wire  [1:0]             soc_io_arw_payload_burst;
wire                    soc_io_arw_payload_lock;
wire                    soc_io_arw_payload_write;
wire  [3:0]             soc_io_arw_payload_cache;
wire  [3:0]             soc_io_arw_payload_qos;
wire  [2:0]             soc_io_arw_payload_prot;
wire                    soc_io_w_valid;
wire                    soc_io_w_ready;
wire  [127:0]           soc_io_w_payload_data;
wire  [15:0]            soc_io_w_payload_strb;
wire                    soc_io_w_payload_last;
wire                    soc_io_b_valid;
wire                    soc_io_b_ready;
wire  [7:0]             soc_io_b_payload_id;
wire                    soc_io_r_valid;
wire                    soc_io_r_ready;
wire  [127:0]           soc_io_r_payload_data;
wire  [7:0]             soc_io_r_payload_id;
wire  [1:0]             soc_io_r_payload_resp;
wire                    soc_io_r_payload_last;
wire  [1:0]             soc_io_b_payload_resp;

wire [7:0]              axi_inter_s0_awid;
wire [31:0]             axi_inter_s0_awaddr;
wire [7:0]              axi_inter_s0_awlen;
wire [2:0]              axi_inter_s0_awsize;
wire [1:0]              axi_inter_s0_awburst;
wire                    axi_inter_s0_awlock;
wire [3:0]              axi_inter_s0_awcache;
wire [2:0]              axi_inter_s0_awprot;
wire [3:0]              axi_inter_s0_awqos;
wire                    axi_inter_s0_awvalid;
wire                    axi_inter_s0_awready;
wire [127:0]            axi_inter_s0_wdata;
wire [15:0]             axi_inter_s0_wstrb;
wire                    axi_inter_s0_wlast;
wire                    axi_inter_s0_wvalid;
wire                    axi_inter_s0_wready;
wire [7:0]              axi_inter_s0_bid;
wire [1:0]              axi_inter_s0_bresp;
wire                    axi_inter_s0_bvalid;
wire                    axi_inter_s0_bready;
wire [7:0]              axi_inter_s0_arid;
wire [31:0]             axi_inter_s0_araddr;
wire [7:0]              axi_inter_s0_arlen;
wire [2:0]              axi_inter_s0_arsize;
wire [1:0]              axi_inter_s0_arburst;
wire                    axi_inter_s0_arlock;
wire [3:0]              axi_inter_s0_arcache;
wire [2:0]              axi_inter_s0_arprot;
wire [3:0]              axi_inter_s0_arqos;
wire                    axi_inter_s0_arvalid;
wire                    axi_inter_s0_arready;
wire [7:0]              axi_inter_s0_rid;
wire [127:0]            axi_inter_s0_rdata;
wire [1:0]              axi_inter_s0_rresp;
wire                    axi_inter_s0_rlast;
wire                    axi_inter_s0_rvalid;
wire                    axi_inter_s0_rready;

wire [7:0]              axi_inter_s1_awid;
wire [31:0]             axi_inter_s1_awaddr;
wire [7:0]              axi_inter_s1_awlen;
wire [2:0]              axi_inter_s1_awsize;
wire [1:0]              axi_inter_s1_awburst;
wire                    axi_inter_s1_awlock;
wire [3:0]              axi_inter_s1_awcache;
wire [2:0]              axi_inter_s1_awprot;
wire [3:0]              axi_inter_s1_awqos;
wire                    axi_inter_s1_awvalid;
wire                    axi_inter_s1_awready;
wire [127:0]            axi_inter_s1_wdata;
wire [15:0]             axi_inter_s1_wstrb;
wire                    axi_inter_s1_wlast;
wire                    axi_inter_s1_wvalid;
wire                    axi_inter_s1_wready;
wire [7:0]              axi_inter_s1_bid;
wire [1:0]              axi_inter_s1_bresp;
wire                    axi_inter_s1_bvalid;
wire                    axi_inter_s1_bready;
wire [7:0]              axi_inter_s1_arid;
wire [31:0]             axi_inter_s1_araddr;
wire [7:0]              axi_inter_s1_arlen;
wire [2:0]              axi_inter_s1_arsize;
wire [1:0]              axi_inter_s1_arburst;
wire                    axi_inter_s1_arlock;
wire [3:0]              axi_inter_s1_arcache;
wire [2:0]              axi_inter_s1_arprot;
wire [3:0]              axi_inter_s1_arqos;
wire                    axi_inter_s1_arvalid;
wire                    axi_inter_s1_arready;
wire [7:0]              axi_inter_s1_rid;
wire [127:0]            axi_inter_s1_rdata;
wire [1:0]              axi_inter_s1_rresp;
wire                    axi_inter_s1_rlast;
wire                    axi_inter_s1_rvalid;
wire                    axi_inter_s1_rready;

wire [7:0]              axi_inter_m_awid;
wire [31:0]             axi_inter_m_awaddr;
wire [7:0]              axi_inter_m_awlen;
wire [2:0]              axi_inter_m_awsize;
wire [1:0]              axi_inter_m_awburst;
wire                    axi_inter_m_awlock;
wire [3:0]              axi_inter_m_awcache;
wire [2:0]              axi_inter_m_awprot;
wire [3:0]              axi_inter_m_awqos;
wire [3:0]              axi_inter_m_awregion;
wire                    axi_inter_m_awvalid;
wire                    axi_inter_m_awready;
wire [127:0]            axi_inter_m_wdata;
wire [15:0]             axi_inter_m_wstrb;
wire                    axi_inter_m_wlast;
wire                    axi_inter_m_wvalid;
wire                    axi_inter_m_wready;
wire [7:0]              axi_inter_m_bid;
wire [1:0]              axi_inter_m_bresp;
wire                    axi_inter_m_bvalid;
wire                    axi_inter_m_bready;
wire [7:0]              axi_inter_m_arid;
wire [31:0]             axi_inter_m_araddr;
wire [7:0]              axi_inter_m_arlen;
wire [2:0]              axi_inter_m_arsize;
wire [1:0]              axi_inter_m_arburst;
wire                    axi_inter_m_arlock;
wire [3:0]              axi_inter_m_arcache;
wire [2:0]              axi_inter_m_arprot;
wire [3:0]              axi_inter_m_arqos;
wire [3:0]              axi_inter_m_arregion;
wire                    axi_inter_m_arvalid;
wire                    axi_inter_m_arready;
wire [7:0]              axi_inter_m_rid;
wire [127:0]            axi_inter_m_rdata;
wire [1:0]              axi_inter_m_rresp;
wire                    axi_inter_m_rlast;
wire                    axi_inter_m_rvalid;
wire                    axi_inter_m_rready;

(* keep , syn_keep *) wire [3:0] soc_io_arw_payload_region /* synthesis syn_keep = 1 */;
(* keep , syn_keep *) wire [7:0] soc_io_w_payload_id /* synthesis syn_keep = 1 */;

////////////////////////////////////////////////////////////////
// DMA controller
wire [63:0]             display_dma_rdata;
wire                    display_dma_rvalid;
wire [7:0]              display_dma_rkeep;
wire                    display_dma_rready;
wire                    debug_display_dma_fifo_overflow;
wire                    debug_display_dma_fifo_underflow;
wire [31:0]             debug_display_dma_fifo_rcount;
wire [31:0]             debug_display_dma_fifo_wcount;

wire                    cam_dma_wready;
wire                    cam_dma_wvalid;
wire                    cam_dma_wlast;
wire [63:0]             cam_dma_wdata;
wire                    cam_dma_descriptorUpdated;
wire                    debug_cam_dma_fifo_overflow;
wire                    debug_cam_dma_fifo_underflow;
wire [31:0]             debug_cam_dma_fifo_rcount;
wire [31:0]             debug_cam_dma_fifo_wcount;
wire [31:0]             debug_cam_dma_status;

wire                    hw_accel_dma_rready;
wire                    hw_accel_dma_rvalid;
wire  [3:0]             hw_accel_dma_rkeep;
wire  [31:0]            hw_accel_dma_rdata;
wire                    hw_accel_dma_wready;
wire                    hw_accel_dma_wvalid;
wire                    hw_accel_dma_wlast;
wire  [31:0]            hw_accel_dma_wdata;
wire                    hw_accel_dma_descriptorUpdated;

wire  [3:0]             dma_interrupts;

(* keep , syn_keep *) wire [3:0] dma_awregion /* synthesis syn_keep = 1 */;
(* keep , syn_keep *) wire [3:0] dma_arregion /* synthesis syn_keep = 1 */;

////////////////////////////////////////////////////////////////
// Reset related

`ifndef SIM
   reset_ctrl #(
      .NUM_RST          (8),
      .CYCLE            (1),
      .IN_RST_ACTIVE    (8'b000000),
      .OUT_RST_ACTIVE   (8'b101010)
   ) u_reset_ctrl (
      .i_arst ({{2{w_cam_confdone}}, {2{i_pll_locked}}, {4{r_rst_cnt[19]}}}),
      .i_clk  ({{2{i_mipi_rx_pclk}}, {2{i_fb_clk}}, {2{i_fb_clk}}, {2{i_sysclk_div_2}}}),
      .o_srst ({  w_mipi_rx_pclk_arst, w_mipi_rx_pclk_arstn,
                  w_fb_clk_arst,       w_fb_clk_arstn,
                  w_fb_dp_arst,        w_fb_dp_arstn,
                  w_sys_dp_arst,       w_sys_dp_arstn})
   );
`else
   assign w_mipi_rx_pclk_arst    = ~i_arstn;
   assign w_mipi_rx_pclk_arstn   = i_arstn;
   assign w_fb_clk_arst          = ~i_arstn;
   assign w_fb_clk_arstn         = i_arstn;
   assign w_fb_dp_arst           = ~i_arstn;
   assign w_fb_dp_arstn          = i_arstn;
   assign w_sys_dp_arst          = ~i_arstn;
   assign w_sys_dp_arstn         = i_arstn;
`endif

assign   mipi_dp_clk_RST      = ~i_arstn;
assign   mipi_dp_data0_RST    = ~i_arstn;
assign   mipi_dp_data1_RST    = ~i_arstn;
assign   mipi_dp_data2_RST    = ~i_arstn;
assign   mipi_dp_data3_RST    = ~i_arstn;

assign   o_hbramClk_pll_rstn  = i_arstn;
assign   o_lcd_rstn           = r_lcd_rstn;
assign   o_led                = dp_frame_cnt[4];
assign   o_pll_rstn           = i_arstn;
assign   o_mipi_pll_rstn      = i_arstn;
assign   o_cam_rstn           = i_arstn;

////////////////////////////////////////////////////////////////
// MIPI CSI RX Channel - Camera

always@(negedge i_arstn or posedge i_cam_ck_CLKOUT_0)
begin
   if (~i_arstn)
   begin
      r_mipi_rx_data_LP_P_IN_0_1P   <= 2'b0;
      r_mipi_rx_data_LP_N_IN_0_1P   <= 2'b0;
      r_mipi_rx_data_HS_IN_0_1P     <= {16{1'b0}};
      
      r_mipi_rx_data_LP_P_IN_0_2P   <= 2'b0;
      r_mipi_rx_data_LP_N_IN_0_2P   <= 2'b0;
      r_mipi_rx_data_HS_IN_0_2P     <= {16{1'b0}};
   end
   else
   begin
      r_mipi_rx_data_LP_P_IN_0_1P   <= {i_cam_d1_LP_P_IN, i_cam_d0_LP_P_IN}; 
      r_mipi_rx_data_LP_N_IN_0_1P   <= {i_cam_d1_LP_N_IN, i_cam_d0_LP_N_IN};
      r_mipi_rx_data_HS_IN_0_1P     <= {w_cam_d1_HS_IN[7:0], w_cam_d0_HS_IN[7:0]};
               
      r_mipi_rx_data_LP_P_IN_0_2P   <= r_mipi_rx_data_LP_P_IN_0_1P;
      r_mipi_rx_data_LP_N_IN_0_2P   <= r_mipi_rx_data_LP_N_IN_0_1P;
      r_mipi_rx_data_HS_IN_0_2P     <= r_mipi_rx_data_HS_IN_0_1P;
   end
end

assign   w_cam_d0_HS_IN    = {i_cam_d0_HS_IN_3, i_cam_d0_HS_IN_2, i_cam_d0_HS_IN_1, i_cam_d0_HS_IN_0};
assign   w_cam_d1_HS_IN    = {i_cam_d1_HS_IN_3, i_cam_d1_HS_IN_2, i_cam_d1_HS_IN_1, i_cam_d1_HS_IN_0};

assign   o_cam_ck_HS_TERM  = w_cam_ck_HS_ENA_0;
assign   o_cam_ck_HS_ENA   = w_cam_ck_HS_ENA_0;
assign   o_cam_d0_HS_TERM  = w_cam_d_HS_ENA_0[0];
assign   o_cam_d1_HS_TERM  = w_cam_d_HS_ENA_0[1];
assign   o_cam_d0_HS_ENA   = w_cam_d_HS_ENA_0[0];
assign   o_cam_d1_HS_ENA   = w_cam_d_HS_ENA_0[1];
assign   o_cam_d0_RST      = ~i_arstn;
assign   o_cam_d1_RST      = ~i_arstn;             

csi2_rx_cam #(
) u_csi2_rx_cam (
   .reset_n             (i_arstn),
   .clk                 (i_mipi_clk),
   .reset_byte_HS_n     (i_arstn),
   .clk_byte_HS         (i_cam_ck_CLKOUT_0),
   .reset_pixel_n       (w_mipi_rx_pclk_arstn),
   .clk_pixel           (i_mipi_rx_pclk),
   
   .Rx_LP_CLK_P         (i_cam_ck_LP_P_IN),
   .Rx_LP_CLK_N         (i_cam_ck_LP_N_IN),
   .Rx_HS_enable_C      (w_cam_ck_HS_ENA_0),
   .LVDS_termen_C       (w_cam_ck_HS_TERM_0),

   .Rx_LP_D_P           (r_mipi_rx_data_LP_P_IN_0_2P),
   .Rx_LP_D_N           (r_mipi_rx_data_LP_N_IN_0_2P),
   .Rx_HS_D_0           (r_mipi_rx_data_HS_IN_0_2P[7:0]),
   .Rx_HS_D_1           (r_mipi_rx_data_HS_IN_0_2P[15:8]),
   .Rx_HS_D_2           (),
   .Rx_HS_D_3           (),
   .Rx_HS_D_4           (),
   .Rx_HS_D_5           (),
   .Rx_HS_D_6           (),
   .Rx_HS_D_7           (),
   .Rx_HS_enable_D      (w_cam_d_HS_ENA_0),
   .LVDS_termen_D       (),
   .fifo_rd_enable      ({o_cam_d1_FIFO_RD,    o_cam_d0_FIFO_RD}),
   .fifo_rd_empty       ({i_cam_d1_FIFO_EMPTY, i_cam_d0_FIFO_EMPTY}),
   .DLY_enable_D        (),
   .DLY_inc_D           (),
   .u_dly_enable_D      (),
   .u_dly_inc_D         (),
   
   .axi_clk             (1'b0),
   .axi_reset_n         (1'b0),
   .axi_awaddr          (6'b0),
   .axi_awvalid         (1'b0),
   .axi_awready         (),
   .axi_wdata           (32'b0),
   .axi_wvalid          (1'b0),
   .axi_wready          (),
   
   .axi_bvalid          (),
   .axi_bready          (1'b0),
   .axi_araddr          (6'b0),
   .axi_arvalid         (1'b0),
   .axi_arready         (),
   .axi_rdata           (),
   .axi_rvalid          (),
   .axi_rready          (1'b0),
   
   .hsync_vc0           (w_mipi_rx_hs),
   .hsync_vc1           (),
   .hsync_vc2           (),
   .hsync_vc3           (),
   .hsync_vc4           (),
   .hsync_vc5           (),
   .hsync_vc6           (),
   .hsync_vc7           (),
   .hsync_vc8           (),
   .hsync_vc9           (),
   .hsync_vc10          (),
   .hsync_vc11          (),
   .hsync_vc12          (),
   .hsync_vc13          (),
   .hsync_vc14          (),
   .hsync_vc15          (),
   .vsync_vc0           (w_mipi_rx_vs),
   .vsync_vc1           (),
   .vsync_vc2           (),
   .vsync_vc3           (),
   .vsync_vc4           (),
   .vsync_vc5           (),
   .vsync_vc6           (),
   .vsync_vc7           (),
   .vsync_vc8           (),
   .vsync_vc9           (),
   .vsync_vc10          (),
   .vsync_vc11          (),
   .vsync_vc12          (),
   .vsync_vc13          (),
   .vsync_vc14          (),
   .vsync_vc15          (),
   .vc                  (),
   .vcx                 (),
   .word_count          (),
   .shortpkt_data_field (),
   .datatype            (w_mipi_rx_dt),
   .pixel_per_clk       (),
   .pixel_data          (w_mipi_rx_data),
   .pixel_data_valid    (w_mipi_rx_de),
   .irq                 ()
);

////////////////////////////////////////////////////////////////
// Camera
      
assign mipi_i2c_0_io_sda_writeEnable = !mipi_i2c_0_io_sda_write;
assign mipi_i2c_0_io_scl_writeEnable = !mipi_i2c_0_io_scl_write;

always@(posedge i_systemClk)
begin
   if (io_systemReset)
   begin
      w_cam_confdone <= 1'b0;
   end else begin
      w_cam_confdone <= (cam_confdone) ? 1'b1 : w_cam_confdone;
   end
end

cam_picam_v2 # (
   .MIPI_FRAME_WIDTH     (MIPI_FRAME_WIDTH),             //Input frame resolution from MIPI
   .MIPI_FRAME_HEIGHT    (MIPI_FRAME_HEIGHT),            //Input frame resolution from MIPI
   .FRAME_WIDTH          (FRAME_WIDTH),                  //Output frame resolution to external memory
   .FRAME_HEIGHT         (FRAME_HEIGHT),                 //Output frame resolution to external memory
   .DMA_TRANSFER_LENGTH  ((FRAME_WIDTH*FRAME_HEIGHT)/2)  //2PPC
) u_cam (
   .mipi_pclk                             (i_mipi_rx_pclk),
   .rst_n                                 (w_mipi_rx_pclk_arstn),
   .mipi_cam_data                         (w_mipi_rx_data),
   .mipi_cam_valid                        (w_mipi_rx_de),
   .mipi_cam_vs                           (w_mipi_rx_vs),
   .mipi_cam_hs                           (w_mipi_rx_hs),
   .mipi_cam_type                         (w_mipi_rx_dt),
`ifdef SIM
   //Simulation frame data from testbench
   .sim_cam_hsync                         (sim_cam_hsync),
   .sim_cam_vsync                         (sim_cam_vsync),
   .sim_cam_valid                         (sim_cam_valid),
   .sim_cam_r_pix                         (sim_cam_r_pix),
   .sim_cam_g_pix                         (sim_cam_g_pix),
   .sim_cam_b_pix                         (sim_cam_b_pix),
`endif
   .cam_dma_wready                        (cam_dma_wready),
   .cam_dma_wvalid                        (cam_dma_wvalid),
   .cam_dma_wlast                         (cam_dma_wlast),
   .cam_dma_wdata                         (cam_dma_wdata),
   .cam_dma_descriptorUpdated             (cam_dma_descriptorUpdated),  //SG mode DMA transfer
   .rgb_control                           (rgb_control),
   .trigger_capture_frame                 (trigger_capture_frame),
   .continuous_capture_frame              (continuous_capture_frame),
   .rgb_gray                              (rgb_gray),
   .cam_dma_init_done                     (cam_dma_init_done),
   .frames_per_second                     (frames_per_second),
   .debug_cam_pixel_remap_fifo_overflow   (debug_cam_pixel_remap_fifo_overflow),
   .debug_cam_pixel_remap_fifo_underflow  (debug_cam_pixel_remap_fifo_underflow),
   .debug_cam_dma_fifo_overflow           (debug_cam_dma_fifo_overflow),
   .debug_cam_dma_fifo_underflow          (debug_cam_dma_fifo_underflow),
   .debug_cam_dma_fifo_rcount             (debug_cam_dma_fifo_rcount),
   .debug_cam_dma_fifo_wcount             (debug_cam_dma_fifo_wcount),
   .debug_cam_dma_status                  (debug_cam_dma_status)
);

////////////////////////////////////////////////////////////////
// Display

// Reset
always@(negedge i_arstn or posedge i_fb_clk)
begin
   if (~i_arstn)
   begin
      r_rst_cnt   <= {20{1'b0}};
      r_lcd_rstn  <= 1'b0;
   end
   else
   begin    
      if (~r_rst_cnt[19])
      begin
         r_rst_cnt   <= r_rst_cnt + 1'b1;
         
         if (r_rst_cnt[18] && r_rst_cnt[17])
            r_lcd_rstn  <= 1'b0;
         else
            r_lcd_rstn  <= 1'b1;
      end
      else
         r_lcd_rstn  <= 1'b1;
   end
end

// Panel driver initialization
panel_config #(
   .INITIAL_CODE  ("../../../source_ti60/display/dsi_panel_1080p_reg.mem"),
   .REG_DEPTH     (9'd15)
) u_panel_config (
   .i_axi_clk        (i_fb_clk),
   .i_restn          (w_fb_dp_arstn),
   
   .i_axi_awready    (w_axi_awready),
   .i_axi_wready     (w_axi_wready),
   .i_axi_bvalid     (w_axi_bvalid),
   .o_axi_awaddr     (w_axi_awaddr),
   .o_axi_awvalid    (w_axi_awvalid),
   .o_axi_wdata      (w_axi_wdata),
   .o_axi_wvalid     (w_axi_wvalid),
   .o_axi_bready     (w_axi_bready),
   
   .i_axi_arready    (w_axi_arready),
   .i_axi_rdata      (w_axi_rdata),
   .i_axi_rvalid     (w_axi_rvalid),
   .o_axi_araddr     (w_axi_araddr),
   .o_axi_arvalid    (w_axi_arvalid),
   .o_axi_rready     (w_axi_rready),
   
   .o_addr_cnt       (),
   .o_state          (),
   .o_confdone       (w_confdone),
   
   .i_dbg_we         (0),
   .i_dbg_din        (0),
   .i_dbg_addr       (0),
   .o_dbg_dout       (),
   .i_dbg_reconfig   (0)
);

display_dsi #(
   .FRAME_WIDTH  (FRAME_WIDTH),
   .FRAME_HEIGHT (FRAME_HEIGHT)
) u_display (
   .clk                                   (i_sysclk_div_2),
   .rst_n                                 (w_sys_dp_arstn),
   .panel_confdone                        (w_confdone),
   .panel_on_off_sw                       (sw1),
   .rstn_video                            (r_rstn_video),
   .frame_cnt                             (dp_frame_cnt),
   
   .display_dma_rdata                     (display_dma_rdata),
   .display_dma_rvalid                    (display_dma_rvalid),
   .display_dma_rkeep                     (display_dma_rkeep),
   .display_dma_rready                    (display_dma_rready),
   
   .debug_display_dma_fifo_overflow       (debug_display_dma_fifo_overflow),
   .debug_display_dma_fifo_underflow      (debug_display_dma_fifo_underflow),
   .debug_display_dma_fifo_rcount         (debug_display_dma_fifo_rcount),
   .debug_display_dma_fifo_wcount         (debug_display_dma_fifo_wcount),
   
   .o_hs                                  (dp_hs),
   .o_vs                                  (dp_vs),
   .o_valid                               (dp_data_valid),
   .o_r                                   (dp_r_data),
   .o_g                                   (dp_g_data),
   .o_b                                   (dp_b_data)
);

////////////////////////////////////////////////////////////////
// MIPI DSI TX Channel - Display panel
efx_dsi_tx u_efx_dsi_tx (
   .reset_n          (w_sys_dp_arstn),
   .clk              (i_mipi_clk),     //100
   .reset_byte_HS_n  (w_sys_dp_arstn),
   .clk_byte_HS      (i_mipi_tx_pclk), //1000/8=125
   .reset_pixel_n    (r_rstn_video),
   .clk_pixel        (i_sysclk_div_2), //1000/16=62.5
   // LVDS clock lane   
   .Tx_LP_CLK_P      (mipi_dp_clk_LP_P_OUT),
   .Tx_LP_CLK_P_OE   (mipi_dp_clk_LP_P_OE),
   .Tx_LP_CLK_N      (mipi_dp_clk_LP_N_OUT),
   .Tx_LP_CLK_N_OE   (mipi_dp_clk_LP_N_OE),
   .Tx_HS_C          (mipi_dp_clk_HS_OUT),
   .Tx_HS_enable_C   (mipi_dp_clk_HS_OE),
   
   // ----- DLane -----------
   // LVDS data lane
   .Tx_LP_D_P        ({mipi_dp_data3_LP_P_OUT, mipi_dp_data2_LP_P_OUT, mipi_dp_data1_LP_P_OUT, mipi_dp_data0_LP_P_OUT}),
   .Tx_LP_D_P_OE     ({mipi_dp_data3_LP_P_OE, mipi_dp_data2_LP_P_OE, mipi_dp_data1_LP_P_OE, mipi_dp_data0_LP_P_OE}),
   .Tx_LP_D_N        ({mipi_dp_data3_LP_N_OUT, mipi_dp_data2_LP_N_OUT, mipi_dp_data1_LP_N_OUT, mipi_dp_data0_LP_N_OUT}),
   .Tx_LP_D_N_OE     ({mipi_dp_data3_LP_N_OE, mipi_dp_data2_LP_N_OE, mipi_dp_data1_LP_N_OE, mipi_dp_data0_LP_N_OE}),
   .Tx_HS_D_0        (mipi_dp_data0_HS_OUT),
   .Tx_HS_D_1        (mipi_dp_data1_HS_OUT),
   .Tx_HS_D_2        (mipi_dp_data2_HS_OUT),
   .Tx_HS_D_3        (mipi_dp_data3_HS_OUT),
   //.Tx_HS_D_4        (),
   //.Tx_HS_D_5        (),
   //.Tx_HS_D_6        (),
   //.Tx_HS_D_7        (),
   // control signal to LVDS IO
   .Tx_HS_enable_D   ({mipi_dp_data3_HS_OE, mipi_dp_data2_HS_OE, mipi_dp_data1_HS_OE, mipi_dp_data0_HS_OE}),
   .Rx_LP_D_P        (mipi_dp_data0_LP_P_IN),
   .Rx_LP_D_N        (mipi_dp_data0_LP_N_IN),
   
   //AXI4-Lite Interface
   .axi_clk          (i_fb_clk      ), 
   .axi_reset_n      (w_fb_clk_arstn),
   .axi_awaddr       (w_axi_awaddr  ),//Write Address. byte address.
   .axi_awvalid      (w_axi_awvalid ),//Write address valid.
   .axi_awready      (w_axi_awready ),//Write address ready.
   .axi_wdata        (w_axi_wdata   ),//Write data bus.
   .axi_wvalid       (w_axi_wvalid  ),//Write valid.
   .axi_wready       (w_axi_wready  ),//Write ready.
                    
   .axi_bvalid       (w_axi_bvalid  ),//Write response valid.
   .axi_bready       (w_axi_bready  ),//Response ready.      
   .axi_araddr       (w_axi_araddr  ),//Read address. byte address.
   .axi_arvalid      (w_axi_arvalid ),//Read address valid.
   .axi_arready      (w_axi_arready ),//Read address ready.
   .axi_rdata        (w_axi_rdata   ),//Read data.
   .axi_rvalid       (w_axi_rvalid  ),//Read valid.
   .axi_rready       (w_axi_rready  ),//Read ready.
   
   .hsync            (dp_hs),
   .vsync            (dp_vs),
   .vc               (2'b0),
   .datatype         (6'h3E),
   .pixel_data       ({16'b0, dp_b_data[15:8], dp_g_data[15:8], dp_r_data[15:8], dp_b_data[7:0], dp_g_data[7:0], dp_r_data[7:0]}),
   .pixel_data_valid (dp_data_valid),
   .haddr            (1080),
   .TurnRequest_dbg  (1'b0),
   .TurnRequest_done (),
   .irq              ()
);

////////////////////////////////////////////////////////////////
// APB3 for camera & display

assign debug_cam_display_fifo_status = {26'd0, debug_cam_pixel_remap_fifo_underflow, debug_cam_pixel_remap_fifo_overflow, debug_cam_dma_fifo_underflow, debug_cam_dma_fifo_overflow, 
                                        debug_display_dma_fifo_underflow, debug_display_dma_fifo_overflow};

//Shared for both camera and display
apb3_cam #(
   .ADDR_WIDTH (16),
   .DATA_WIDTH (32),
   .NUM_REG    (5)
) u_apb3_cam_display (
//   .select_demo_mode              ({user_dip1,user_dip0}),
   .cam_confdone                  (cam_confdone),
   .rgb_control                   (rgb_control),
   .trigger_capture_frame         (trigger_capture_frame),
   .continuous_capture_frame      (continuous_capture_frame),
   .rgb_gray                      (rgb_gray),
   .cam_dma_init_done             (cam_dma_init_done),
   .frames_per_second             (frames_per_second),
   .debug_fifo_status             (debug_cam_display_fifo_status),
   .debug_cam_dma_fifo_rcount     (debug_cam_dma_fifo_rcount),
   .debug_cam_dma_fifo_wcount     (debug_cam_dma_fifo_wcount),
   .debug_cam_dma_status          (debug_cam_dma_status),
   .debug_display_dma_fifo_rcount (debug_display_dma_fifo_rcount),
   .debug_display_dma_fifo_wcount (debug_display_dma_fifo_wcount),
   .clk                           (i_systemClk),
   .resetn                        (~io_systemReset),
   .PADDR                         (io_apbSlave_1_PADDR),
   .PSEL                          (io_apbSlave_1_PSEL),
   .PENABLE                       (io_apbSlave_1_PENABLE),
   .PREADY                        (io_apbSlave_1_PREADY),
   .PWRITE                        (io_apbSlave_1_PWRITE),
   .PWDATA                        (io_apbSlave_1_PWDATA),
   .PRDATA                        (io_apbSlave_1_PRDATA),
   .PSLVERROR                     (io_apbSlave_1_PSLVERROR)
);

////////////////////////////////////////////////////////////////
// HyperRAM contoller

assign io_memoryClk      = i_hbramClk;   //Reuse existing PLL output clock
assign io_b_payload_resp = 2'b00;

hbram u_hbram (
   .rst                    (io_systemReset),
   .ram_clk                (i_hbramClk), 
   .ram_clk_cal            (i_hbramClk_cal),
   .io_axi_clk             (io_memoryClk),
   .io_arw_valid           (io_arw_valid),
   .io_arw_ready           (io_arw_ready),
   .io_arw_payload_addr    (io_arw_payload_addr),
   .io_arw_payload_id      (io_arw_payload_id),
   .io_arw_payload_len     (io_arw_payload_len),
   .io_arw_payload_size    (io_arw_payload_size),
   .io_arw_payload_burst   (io_arw_payload_burst),
   .io_arw_payload_lock    (io_arw_payload_lock),
   .io_arw_payload_write   (io_arw_payload_write),
   .io_w_payload_id        (io_w_payload_id),
   .io_w_valid             (io_w_valid),
   .io_w_ready             (io_w_ready),
   .io_w_payload_data      (io_w_payload_data),
   .io_w_payload_strb      (io_w_payload_strb),
   .io_w_payload_last      (io_w_payload_last),
   .io_b_valid             (io_b_valid),
   .io_b_ready             (io_b_ready),
   .io_b_payload_id        (io_b_payload_id),
   .io_r_valid             (io_r_valid),
   .io_r_ready             (io_r_ready),
   .io_r_payload_data      (io_r_payload_data),
   .io_r_payload_id        (io_r_payload_id),
   .io_r_payload_resp      (io_r_payload_resp),
   .io_r_payload_last      (io_r_payload_last),
   .hbc_cal_SHIFT_ENA      (o_hbc_cal_SHIFT_ENA),
   .hbc_cal_SHIFT          (o_hbc_cal_SHIFT),
   .hbc_cal_SHIFT_SEL      (o_hbc_cal_SHIFT_SEL),
   .hbc_cal_pass           (hbc_cal_pass),
   .hbc_rst_n              (hbc_rst_n), 
   .hbc_cs_n               (hbc_cs_n),
   .hbc_ck_p_HI            (hbc_ck_p_HI),
   .hbc_ck_p_LO            (hbc_ck_p_LO),
   .hbc_ck_n_HI            (hbc_ck_n_HI),
   .hbc_ck_n_LO            (hbc_ck_n_LO),
   .hbc_rwds_OUT_HI        (hbc_rwds_OUT_HI),
   .hbc_rwds_OUT_LO        (hbc_rwds_OUT_LO),
   .hbc_rwds_IN_HI         (hbc_rwds_IN_HI),
   .hbc_rwds_IN_LO         (hbc_rwds_IN_LO),
   .hbc_rwds_OE            (hbc_rwds_OE),
   .hbc_dq_OUT_HI          (hbc_dq_OUT_HI),
   .hbc_dq_OUT_LO          (hbc_dq_OUT_LO),
   .hbc_dq_IN_HI           (hbc_dq_IN_HI),
   .hbc_dq_IN_LO           (hbc_dq_IN_LO),
   .hbc_dq_OE              (hbc_dq_OE)
);

////////////////////////////////////////////////////////////////
// RISC-V SoC

assign mcuReset = ~(i_hbramClk_pll_locked & i_pll_locked & i_arstn);

`ifndef SOFT_TAP

RubySoc u_risc_v
(
   .io_systemClk                       (i_systemClk),
   .io_asyncReset                      (mcuReset),
   .io_memoryClk                       (io_memoryClk),
   .io_memoryReset                     (io_memoryReset),
   .system_uart_0_io_txd               (system_uart_0_io_txd),
   .system_uart_0_io_rxd               (system_uart_0_io_rxd),
   .system_uart_1_io_txd               (),
   .system_uart_1_io_rxd               (),
   .system_i2c_0_io_sda_write          (mipi_i2c_0_io_sda_write),
   .system_i2c_0_io_sda_read           (mipi_i2c_0_io_sda_read),
   .system_i2c_0_io_scl_write          (mipi_i2c_0_io_scl_write),
   .system_i2c_0_io_scl_read           (mipi_i2c_0_io_scl_read),
   .system_i2c_1_io_sda_write          (),
   .system_i2c_1_io_sda_read           (),
   .system_i2c_1_io_scl_write          (),
   .system_i2c_1_io_scl_read           (),
   .system_i2c_2_io_sda_write          (),
   .system_i2c_2_io_sda_read           (),
   .system_i2c_2_io_scl_write          (),
   .system_i2c_2_io_scl_read           (),
   .system_gpio_0_io_read              (),
   .system_gpio_0_io_write             (),
   .system_gpio_0_io_writeEnable       (),
   .io_apbSlave_0_PADDR                (io_apbSlave_0_PADDR),
   .io_apbSlave_0_PSEL                 (io_apbSlave_0_PSEL),
   .io_apbSlave_0_PENABLE              (io_apbSlave_0_PENABLE),
   .io_apbSlave_0_PREADY               (io_apbSlave_0_PREADY),
   .io_apbSlave_0_PWRITE               (io_apbSlave_0_PWRITE),
   .io_apbSlave_0_PWDATA               (io_apbSlave_0_PWDATA),
   .io_apbSlave_0_PRDATA               (io_apbSlave_0_PRDATA),
   .io_apbSlave_0_PSLVERROR            (io_apbSlave_0_PSLVERROR),
   .io_apbSlave_1_PADDR                (io_apbSlave_1_PADDR),
   .io_apbSlave_1_PSEL                 (io_apbSlave_1_PSEL),
   .io_apbSlave_1_PENABLE              (io_apbSlave_1_PENABLE),
   .io_apbSlave_1_PREADY               (io_apbSlave_1_PREADY),
   .io_apbSlave_1_PWRITE               (io_apbSlave_1_PWRITE),
   .io_apbSlave_1_PWDATA               (io_apbSlave_1_PWDATA),
   .io_apbSlave_1_PRDATA               (io_apbSlave_1_PRDATA),
   .io_apbSlave_1_PSLVERROR            (io_apbSlave_1_PSLVERROR),
   .io_apbSlave_2_PADDR                (),
   .io_apbSlave_2_PSEL                 (),
   .io_apbSlave_2_PENABLE              (),
   .io_apbSlave_2_PREADY               (),
   .io_apbSlave_2_PWRITE               (),
   .io_apbSlave_2_PWDATA               (),
   .io_apbSlave_2_PRDATA               (),
   .io_apbSlave_2_PSLVERROR            (),
   .io_apbSlave_3_PADDR                (),
   .io_apbSlave_3_PSEL                 (),
   .io_apbSlave_3_PENABLE              (),
   .io_apbSlave_3_PREADY               (),
   .io_apbSlave_3_PWRITE               (),
   .io_apbSlave_3_PWDATA               (),
   .io_apbSlave_3_PRDATA               (),
   .io_apbSlave_3_PSLVERROR            (),
   .userInterruptA                     (userInterrupt),
   .io_systemReset                     (io_systemReset),
   .io_ddrA_arw_valid                  (soc_io_arw_valid),
   .io_ddrA_arw_ready                  (soc_io_arw_ready),
   .io_ddrA_arw_payload_addr           (soc_io_arw_payload_addr),
   .io_ddrA_arw_payload_id             (soc_io_arw_payload_id),
   .io_ddrA_arw_payload_region         (soc_io_arw_payload_region),
   .io_ddrA_arw_payload_len            (soc_io_arw_payload_len),
   .io_ddrA_arw_payload_size           (soc_io_arw_payload_size),
   .io_ddrA_arw_payload_burst          (soc_io_arw_payload_burst),
   .io_ddrA_arw_payload_lock           (soc_io_arw_payload_lock),
   .io_ddrA_arw_payload_cache          (soc_io_arw_payload_cache),
   .io_ddrA_arw_payload_qos            (soc_io_arw_payload_qos),
   .io_ddrA_arw_payload_prot           (soc_io_arw_payload_prot),
   .io_ddrA_arw_payload_write          (soc_io_arw_payload_write),
   .io_ddrA_w_valid                    (axi_inter_s0_wvalid),
   .io_ddrA_w_ready                    (axi_inter_s0_wready),
   .io_ddrA_w_payload_data             (axi_inter_s0_wdata),
   .io_ddrA_w_payload_strb             (axi_inter_s0_wstrb),
   .io_ddrA_w_payload_last             (axi_inter_s0_wlast),
   .io_ddrA_b_valid                    (axi_inter_s0_bvalid),
   .io_ddrA_b_ready                    (axi_inter_s0_bready),
   .io_ddrA_b_payload_id               (axi_inter_s0_bid),
   .io_ddrA_b_payload_resp             (axi_inter_s0_bresp),
   .io_ddrA_r_valid                    (axi_inter_s0_rvalid),
   .io_ddrA_r_ready                    (axi_inter_s0_rready),
   .io_ddrA_r_payload_data             (axi_inter_s0_rdata),
   .io_ddrA_r_payload_id               (axi_inter_s0_rid),
   .io_ddrA_r_payload_resp             (axi_inter_s0_rresp),
   .io_ddrA_r_payload_last             (axi_inter_s0_rlast),
   .io_ddrA_w_payload_id               (soc_io_w_payload_id),
   .io_ddrMasters_0_aw_ready           (),
   .io_ddrMasters_0_aw_payload_addr    (32'd0),
   .io_ddrMasters_0_aw_payload_id      (4'd0),
   .io_ddrMasters_0_aw_payload_region  (4'd0),
   .io_ddrMasters_0_aw_payload_len     (8'd0),
   .io_ddrMasters_0_aw_payload_size    (3'd0),
   .io_ddrMasters_0_aw_payload_burst   (2'd0),
   .io_ddrMasters_0_aw_payload_lock    (1'b0),
   .io_ddrMasters_0_aw_payload_cache   (4'd0),
   .io_ddrMasters_0_aw_payload_qos     (4'd0),
   .io_ddrMasters_0_aw_payload_prot    (3'd0),
   .io_ddrMasters_0_w_valid            (1'b0),
   .io_ddrMasters_0_w_ready            (),
   .io_ddrMasters_0_w_payload_data     (32'd0),
   .io_ddrMasters_0_w_payload_strb     (4'd0),
   .io_ddrMasters_0_w_payload_last     (1'b0),
   .io_ddrMasters_0_b_valid            (),
   .io_ddrMasters_0_b_ready            (1'b0),
   .io_ddrMasters_0_b_payload_id       (),
   .io_ddrMasters_0_b_payload_resp     (),
   .io_ddrMasters_0_ar_valid           (1'b0),
   .io_ddrMasters_0_ar_ready           (),
   .io_ddrMasters_0_ar_payload_addr    (32'd0),
   .io_ddrMasters_0_ar_payload_id      (4'd0),
   .io_ddrMasters_0_ar_payload_region  (4'd0),
   .io_ddrMasters_0_ar_payload_len     (8'd0),
   .io_ddrMasters_0_ar_payload_size    (3'd0),
   .io_ddrMasters_0_ar_payload_burst   (2'd0),
   .io_ddrMasters_0_ar_payload_lock    (1'b0),
   .io_ddrMasters_0_ar_payload_cache   (4'd0),
   .io_ddrMasters_0_ar_payload_qos     (4'd0),
   .io_ddrMasters_0_ar_payload_prot    (3'd0),
   .io_ddrMasters_0_r_valid            (),
   .io_ddrMasters_0_r_ready            (1'b0),
   .io_ddrMasters_0_r_payload_data     (),
   .io_ddrMasters_0_r_payload_id       (),
   .io_ddrMasters_0_r_payload_resp     (),
   .io_ddrMasters_0_r_payload_last     (),
   .io_ddrMasters_0_clk                (io_memoryClk),  //Unused master port clock must be connected.
   .io_ddrMasters_0_reset              (),
   .io_ddrMasters_1_aw_valid           (1'b0),
   .io_ddrMasters_1_aw_ready           (),
   .io_ddrMasters_1_aw_payload_addr    (32'd0),
   .io_ddrMasters_1_aw_payload_id      (4'd0),
   .io_ddrMasters_1_aw_payload_region  (4'd0),
   .io_ddrMasters_1_aw_payload_len     (8'd0),
   .io_ddrMasters_1_aw_payload_size    (3'd0),
   .io_ddrMasters_1_aw_payload_burst   (2'd0),
   .io_ddrMasters_1_aw_payload_lock    (1'b0),
   .io_ddrMasters_1_aw_payload_cache   (4'd0),
   .io_ddrMasters_1_aw_payload_qos     (4'd0),
   .io_ddrMasters_1_aw_payload_prot    (3'd0),
   .io_ddrMasters_1_w_valid            (1'b0),
   .io_ddrMasters_1_w_ready            (),
   .io_ddrMasters_1_w_payload_data     (32'd0),
   .io_ddrMasters_1_w_payload_strb     (4'd0),
   .io_ddrMasters_1_w_payload_last     (1'b0),
   .io_ddrMasters_1_b_valid            (),
   .io_ddrMasters_1_b_ready            (1'b0),
   .io_ddrMasters_1_b_payload_id       (),
   .io_ddrMasters_1_b_payload_resp     (),
   .io_ddrMasters_1_ar_valid           (1'b0),
   .io_ddrMasters_1_ar_ready           (),
   .io_ddrMasters_1_ar_payload_addr    (32'd0),
   .io_ddrMasters_1_ar_payload_id      (4'd0),
   .io_ddrMasters_1_ar_payload_region  (4'd0),
   .io_ddrMasters_1_ar_payload_len     (8'd0),
   .io_ddrMasters_1_ar_payload_size    (3'd0),
   .io_ddrMasters_1_ar_payload_burst   (2'd0),
   .io_ddrMasters_1_ar_payload_lock    (1'b0),
   .io_ddrMasters_1_ar_payload_cache   (4'd0),
   .io_ddrMasters_1_ar_payload_qos     (4'd0),
   .io_ddrMasters_1_ar_payload_prot    (3'd0),
   .io_ddrMasters_1_r_valid            (),
   .io_ddrMasters_1_r_ready            (1'b0),
   .io_ddrMasters_1_r_payload_data     (),
   .io_ddrMasters_1_r_payload_id       (),
   .io_ddrMasters_1_r_payload_resp     (),
   .io_ddrMasters_1_r_payload_last     (),
   .io_ddrMasters_1_clk                (io_memoryClk),  //Unused master port clock must be connected.
   .io_ddrMasters_1_reset              (),
   .system_spi_0_io_sclk_write         (system_spi_0_io_sclk_write),
   .system_spi_0_io_data_0_writeEnable (system_spi_0_io_data_0_writeEnable),
   .system_spi_0_io_data_0_read        (system_spi_0_io_data_0_read),
   .system_spi_0_io_data_0_write       (system_spi_0_io_data_0_write),
   .system_spi_0_io_data_1_writeEnable (system_spi_0_io_data_1_writeEnable),
   .system_spi_0_io_data_1_read        (system_spi_0_io_data_1_read),
   .system_spi_0_io_data_1_write       (system_spi_0_io_data_1_write),
   .system_spi_0_io_data_2_writeEnable (),
   .system_spi_0_io_data_2_read        (),
   .system_spi_0_io_data_2_write       (),
   .system_spi_0_io_data_3_writeEnable (),
   .system_spi_0_io_data_3_read        (),
   .system_spi_0_io_data_3_write       (),
   .system_spi_0_io_ss                 (system_spi_0_io_ss),
   .system_spi_1_io_sclk_write         (),
   .system_spi_1_io_data_0_writeEnable (),
   .system_spi_1_io_data_0_read        (),
   .system_spi_1_io_data_0_write       (),
   .system_spi_1_io_data_1_writeEnable (),
   .system_spi_1_io_data_1_read        (),
   .system_spi_1_io_data_1_write       (),
   .system_spi_1_io_data_2_writeEnable (),
   .system_spi_1_io_data_2_read        (),
   .system_spi_1_io_data_2_write       (),
   .system_spi_1_io_data_3_writeEnable (),
   .system_spi_1_io_data_3_read        (),
   .system_spi_1_io_data_3_write       (),
   .system_spi_1_io_ss                 (),
   .system_spi_2_io_sclk_write         (),
   .system_spi_2_io_data_0_writeEnable (),
   .system_spi_2_io_data_0_read        (),
   .system_spi_2_io_data_0_write       (),
   .system_spi_2_io_data_1_writeEnable (),
   .system_spi_2_io_data_1_read        (),
   .system_spi_2_io_data_1_write       (),
   .system_spi_2_io_data_2_writeEnable (),
   .system_spi_2_io_data_2_read        (),
   .system_spi_2_io_data_2_write       (),
   .system_spi_2_io_data_3_writeEnable (),
   .system_spi_2_io_data_3_read        (),
   .system_spi_2_io_data_3_write       (),
   .system_spi_2_io_ss                 (),
   .axiA_awvalid                       (axi_awvalid),
   .axiA_awready                       (axi_awready),
   .axiA_awaddr                        (axi_awaddr),
   .axiA_awid                          (axi_awid),
   .axiA_awregion                      (axi_awregion),
   .axiA_awlen                         (axi_awlen),
   .axiA_awsize                        (axi_awsize),
   .axiA_awburst                       (axi_awburst),
   .axiA_awlock                        (axi_awlock),
   .axiA_awcache                       (axi_awcache),
   .axiA_awqos                         (axi_awqos),
   .axiA_awprot                        (axi_awprot),
   .axiA_wvalid                        (axi_wvalid),
   .axiA_wready                        (axi_wready),
   .axiA_wdata                         (axi_wdata),
   .axiA_wstrb                         (axi_wstrb),
   .axiA_wlast                         (axi_wlast),
   .axiA_bvalid                        (axi_bvalid),
   .axiA_bready                        (axi_bready),
   .axiA_bid                           (axi_bid),
   .axiA_bresp                         (axi_bresp),
   .axiA_arvalid                       (axi_arvalid),
   .axiA_arready                       (axi_arready),
   .axiA_araddr                        (axi_araddr),
   .axiA_arid                          (axi_arid),
   .axiA_arregion                      (axi_arregion),
   .axiA_arlen                         (axi_arlen),
   .axiA_arsize                        (axi_arsize),
   .axiA_arburst                       (axi_arburst),
   .axiA_arlock                        (axi_arlock),
   .axiA_arcache                       (axi_arcache),
   .axiA_arqos                         (axi_arqos),
   .axiA_arprot                        (axi_arprot),
   .axiA_rvalid                        (axi_rvalid),
   .axiA_rready                        (axi_rready),
   .axiA_rdata                         (axi_rdata),
   .axiA_rid                           (axi_rid),
   .axiA_rresp                         (axi_rresp),
   .axiA_rlast                         (axi_rlast),
   .io_axiAInterrupt                   (axi4Interrupt),
   .jtagCtrl_tck                       (jtag_inst1_TCK),
   .jtagCtrl_tdi                       (jtag_inst1_TDI),
   .jtagCtrl_tdo                       (jtag_inst1_TDO),
   .jtagCtrl_enable                    (jtag_inst1_SEL),
   .jtagCtrl_capture                   (jtag_inst1_CAPTURE),
   .jtagCtrl_shift                     (jtag_inst1_SHIFT),
   .jtagCtrl_update                    (jtag_inst1_UPDATE),
   .jtagCtrl_reset                     (jtag_inst1_RESET)
);

`else

RubySoc_softTap u_risc_v_softTap
(
   .io_systemClk                       (i_systemClk),
   .io_asyncReset                      (mcuReset),
   .io_memoryClk                       (io_memoryClk),
   .io_memoryReset                     (io_memoryReset),
   .system_uart_0_io_txd               (system_uart_0_io_txd),
   .system_uart_0_io_rxd               (system_uart_0_io_rxd),
   .system_uart_1_io_txd               (),
   .system_uart_1_io_rxd               (),
   .system_i2c_0_io_sda_write          (mipi_i2c_0_io_sda_write),
   .system_i2c_0_io_sda_read           (mipi_i2c_0_io_sda_read),
   .system_i2c_0_io_scl_write          (mipi_i2c_0_io_scl_write),
   .system_i2c_0_io_scl_read           (mipi_i2c_0_io_scl_read),
   .system_i2c_1_io_sda_write          (),
   .system_i2c_1_io_sda_read           (),
   .system_i2c_1_io_scl_write          (),
   .system_i2c_1_io_scl_read           (),
   .system_i2c_2_io_sda_write          (),
   .system_i2c_2_io_sda_read           (),
   .system_i2c_2_io_scl_write          (),
   .system_i2c_2_io_scl_read           (),
   .system_gpio_0_io_read              (),
   .system_gpio_0_io_write             (),
   .system_gpio_0_io_writeEnable       (),
   .io_apbSlave_0_PADDR                (io_apbSlave_0_PADDR),
   .io_apbSlave_0_PSEL                 (io_apbSlave_0_PSEL),
   .io_apbSlave_0_PENABLE              (io_apbSlave_0_PENABLE),
   .io_apbSlave_0_PREADY               (io_apbSlave_0_PREADY),
   .io_apbSlave_0_PWRITE               (io_apbSlave_0_PWRITE),
   .io_apbSlave_0_PWDATA               (io_apbSlave_0_PWDATA),
   .io_apbSlave_0_PRDATA               (io_apbSlave_0_PRDATA),
   .io_apbSlave_0_PSLVERROR            (io_apbSlave_0_PSLVERROR),
   .io_apbSlave_1_PADDR                (io_apbSlave_1_PADDR),
   .io_apbSlave_1_PSEL                 (io_apbSlave_1_PSEL),
   .io_apbSlave_1_PENABLE              (io_apbSlave_1_PENABLE),
   .io_apbSlave_1_PREADY               (io_apbSlave_1_PREADY),
   .io_apbSlave_1_PWRITE               (io_apbSlave_1_PWRITE),
   .io_apbSlave_1_PWDATA               (io_apbSlave_1_PWDATA),
   .io_apbSlave_1_PRDATA               (io_apbSlave_1_PRDATA),
   .io_apbSlave_1_PSLVERROR            (io_apbSlave_1_PSLVERROR),
   .io_apbSlave_2_PADDR                (),
   .io_apbSlave_2_PSEL                 (),
   .io_apbSlave_2_PENABLE              (),
   .io_apbSlave_2_PREADY               (),
   .io_apbSlave_2_PWRITE               (),
   .io_apbSlave_2_PWDATA               (),
   .io_apbSlave_2_PRDATA               (),
   .io_apbSlave_2_PSLVERROR            (),
   .io_apbSlave_3_PADDR                (),
   .io_apbSlave_3_PSEL                 (),
   .io_apbSlave_3_PENABLE              (),
   .io_apbSlave_3_PREADY               (),
   .io_apbSlave_3_PWRITE               (),
   .io_apbSlave_3_PWDATA               (),
   .io_apbSlave_3_PRDATA               (),
   .io_apbSlave_3_PSLVERROR            (),
   .userInterruptA                     (userInterrupt),
   .io_systemReset                     (io_systemReset),
   .io_ddrA_arw_valid                  (soc_io_arw_valid),
   .io_ddrA_arw_ready                  (soc_io_arw_ready),
   .io_ddrA_arw_payload_addr           (soc_io_arw_payload_addr),
   .io_ddrA_arw_payload_id             (soc_io_arw_payload_id),
   .io_ddrA_arw_payload_region         (soc_io_arw_payload_region),
   .io_ddrA_arw_payload_len            (soc_io_arw_payload_len),
   .io_ddrA_arw_payload_size           (soc_io_arw_payload_size),
   .io_ddrA_arw_payload_burst          (soc_io_arw_payload_burst),
   .io_ddrA_arw_payload_lock           (soc_io_arw_payload_lock),
   .io_ddrA_arw_payload_cache          (soc_io_arw_payload_cache),
   .io_ddrA_arw_payload_qos            (soc_io_arw_payload_qos),
   .io_ddrA_arw_payload_prot           (soc_io_arw_payload_prot),
   .io_ddrA_arw_payload_write          (soc_io_arw_payload_write),
   .io_ddrA_w_valid                    (axi_inter_s0_wvalid),
   .io_ddrA_w_ready                    (axi_inter_s0_wready),
   .io_ddrA_w_payload_data             (axi_inter_s0_wdata),
   .io_ddrA_w_payload_strb             (axi_inter_s0_wstrb),
   .io_ddrA_w_payload_last             (axi_inter_s0_wlast),
   .io_ddrA_b_valid                    (axi_inter_s0_bvalid),
   .io_ddrA_b_ready                    (axi_inter_s0_bready),
   .io_ddrA_b_payload_id               (axi_inter_s0_bid),
   .io_ddrA_b_payload_resp             (axi_inter_s0_bresp),
   .io_ddrA_r_valid                    (axi_inter_s0_rvalid),
   .io_ddrA_r_ready                    (axi_inter_s0_rready),
   .io_ddrA_r_payload_data             (axi_inter_s0_rdata),
   .io_ddrA_r_payload_id               (axi_inter_s0_rid),
   .io_ddrA_r_payload_resp             (axi_inter_s0_rresp),
   .io_ddrA_r_payload_last             (axi_inter_s0_rlast),
   .io_ddrA_w_payload_id               (soc_io_w_payload_id),
   .io_ddrMasters_0_aw_ready           (),
   .io_ddrMasters_0_aw_payload_addr    (32'd0),
   .io_ddrMasters_0_aw_payload_id      (4'd0),
   .io_ddrMasters_0_aw_payload_region  (4'd0),
   .io_ddrMasters_0_aw_payload_len     (8'd0),
   .io_ddrMasters_0_aw_payload_size    (3'd0),
   .io_ddrMasters_0_aw_payload_burst   (2'd0),
   .io_ddrMasters_0_aw_payload_lock    (1'b0),
   .io_ddrMasters_0_aw_payload_cache   (4'd0),
   .io_ddrMasters_0_aw_payload_qos     (4'd0),
   .io_ddrMasters_0_aw_payload_prot    (3'd0),
   .io_ddrMasters_0_w_valid            (1'b0),
   .io_ddrMasters_0_w_ready            (),
   .io_ddrMasters_0_w_payload_data     (32'd0),
   .io_ddrMasters_0_w_payload_strb     (4'd0),
   .io_ddrMasters_0_w_payload_last     (1'b0),
   .io_ddrMasters_0_b_valid            (),
   .io_ddrMasters_0_b_ready            (1'b0),
   .io_ddrMasters_0_b_payload_id       (),
   .io_ddrMasters_0_b_payload_resp     (),
   .io_ddrMasters_0_ar_valid           (1'b0),
   .io_ddrMasters_0_ar_ready           (),
   .io_ddrMasters_0_ar_payload_addr    (32'd0),
   .io_ddrMasters_0_ar_payload_id      (4'd0),
   .io_ddrMasters_0_ar_payload_region  (4'd0),
   .io_ddrMasters_0_ar_payload_len     (8'd0),
   .io_ddrMasters_0_ar_payload_size    (3'd0),
   .io_ddrMasters_0_ar_payload_burst   (2'd0),
   .io_ddrMasters_0_ar_payload_lock    (1'b0),
   .io_ddrMasters_0_ar_payload_cache   (4'd0),
   .io_ddrMasters_0_ar_payload_qos     (4'd0),
   .io_ddrMasters_0_ar_payload_prot    (3'd0),
   .io_ddrMasters_0_r_valid            (),
   .io_ddrMasters_0_r_ready            (1'b0),
   .io_ddrMasters_0_r_payload_data     (),
   .io_ddrMasters_0_r_payload_id       (),
   .io_ddrMasters_0_r_payload_resp     (),
   .io_ddrMasters_0_r_payload_last     (),
   .io_ddrMasters_0_clk                (io_memoryClk),  //Unused master port clock must be connected.
   .io_ddrMasters_0_reset              (),
   .io_ddrMasters_1_aw_valid           (1'b0),
   .io_ddrMasters_1_aw_ready           (),
   .io_ddrMasters_1_aw_payload_addr    (32'd0),
   .io_ddrMasters_1_aw_payload_id      (4'd0),
   .io_ddrMasters_1_aw_payload_region  (4'd0),
   .io_ddrMasters_1_aw_payload_len     (8'd0),
   .io_ddrMasters_1_aw_payload_size    (3'd0),
   .io_ddrMasters_1_aw_payload_burst   (2'd0),
   .io_ddrMasters_1_aw_payload_lock    (1'b0),
   .io_ddrMasters_1_aw_payload_cache   (4'd0),
   .io_ddrMasters_1_aw_payload_qos     (4'd0),
   .io_ddrMasters_1_aw_payload_prot    (3'd0),
   .io_ddrMasters_1_w_valid            (1'b0),
   .io_ddrMasters_1_w_ready            (),
   .io_ddrMasters_1_w_payload_data     (32'd0),
   .io_ddrMasters_1_w_payload_strb     (4'd0),
   .io_ddrMasters_1_w_payload_last     (1'b0),
   .io_ddrMasters_1_b_valid            (),
   .io_ddrMasters_1_b_ready            (1'b0),
   .io_ddrMasters_1_b_payload_id       (),
   .io_ddrMasters_1_b_payload_resp     (),
   .io_ddrMasters_1_ar_valid           (1'b0),
   .io_ddrMasters_1_ar_ready           (),
   .io_ddrMasters_1_ar_payload_addr    (32'd0),
   .io_ddrMasters_1_ar_payload_id      (4'd0),
   .io_ddrMasters_1_ar_payload_region  (4'd0),
   .io_ddrMasters_1_ar_payload_len     (8'd0),
   .io_ddrMasters_1_ar_payload_size    (3'd0),
   .io_ddrMasters_1_ar_payload_burst   (2'd0),
   .io_ddrMasters_1_ar_payload_lock    (1'b0),
   .io_ddrMasters_1_ar_payload_cache   (4'd0),
   .io_ddrMasters_1_ar_payload_qos     (4'd0),
   .io_ddrMasters_1_ar_payload_prot    (3'd0),
   .io_ddrMasters_1_r_valid            (),
   .io_ddrMasters_1_r_ready            (1'b0),
   .io_ddrMasters_1_r_payload_data     (),
   .io_ddrMasters_1_r_payload_id       (),
   .io_ddrMasters_1_r_payload_resp     (),
   .io_ddrMasters_1_r_payload_last     (),
   .io_ddrMasters_1_clk                (io_memoryClk),  //Unused master port clock must be connected.
   .io_ddrMasters_1_reset              (),
   .system_spi_0_io_sclk_write         (system_spi_0_io_sclk_write),
   .system_spi_0_io_data_0_writeEnable (system_spi_0_io_data_0_writeEnable),
   .system_spi_0_io_data_0_read        (system_spi_0_io_data_0_read),
   .system_spi_0_io_data_0_write       (system_spi_0_io_data_0_write),
   .system_spi_0_io_data_1_writeEnable (system_spi_0_io_data_1_writeEnable),
   .system_spi_0_io_data_1_read        (system_spi_0_io_data_1_read),
   .system_spi_0_io_data_1_write       (system_spi_0_io_data_1_write),
   .system_spi_0_io_data_2_writeEnable (),
   .system_spi_0_io_data_2_read        (),
   .system_spi_0_io_data_2_write       (),
   .system_spi_0_io_data_3_writeEnable (),
   .system_spi_0_io_data_3_read        (),
   .system_spi_0_io_data_3_write       (),
   .system_spi_0_io_ss                 (system_spi_0_io_ss),
   .system_spi_1_io_sclk_write         (),
   .system_spi_1_io_data_0_writeEnable (),
   .system_spi_1_io_data_0_read        (),
   .system_spi_1_io_data_0_write       (),
   .system_spi_1_io_data_1_writeEnable (),
   .system_spi_1_io_data_1_read        (),
   .system_spi_1_io_data_1_write       (),
   .system_spi_1_io_data_2_writeEnable (),
   .system_spi_1_io_data_2_read        (),
   .system_spi_1_io_data_2_write       (),
   .system_spi_1_io_data_3_writeEnable (),
   .system_spi_1_io_data_3_read        (),
   .system_spi_1_io_data_3_write       (),
   .system_spi_1_io_ss                 (),
   .system_spi_2_io_sclk_write         (),
   .system_spi_2_io_data_0_writeEnable (),
   .system_spi_2_io_data_0_read        (),
   .system_spi_2_io_data_0_write       (),
   .system_spi_2_io_data_1_writeEnable (),
   .system_spi_2_io_data_1_read        (),
   .system_spi_2_io_data_1_write       (),
   .system_spi_2_io_data_2_writeEnable (),
   .system_spi_2_io_data_2_read        (),
   .system_spi_2_io_data_2_write       (),
   .system_spi_2_io_data_3_writeEnable (),
   .system_spi_2_io_data_3_read        (),
   .system_spi_2_io_data_3_write       (),
   .system_spi_2_io_ss                 (),
   .axiA_awvalid                       (axi_awvalid),
   .axiA_awready                       (axi_awready),
   .axiA_awaddr                        (axi_awaddr),
   .axiA_awid                          (axi_awid),
   .axiA_awregion                      (axi_awregion),
   .axiA_awlen                         (axi_awlen),
   .axiA_awsize                        (axi_awsize),
   .axiA_awburst                       (axi_awburst),
   .axiA_awlock                        (axi_awlock),
   .axiA_awcache                       (axi_awcache),
   .axiA_awqos                         (axi_awqos),
   .axiA_awprot                        (axi_awprot),
   .axiA_wvalid                        (axi_wvalid),
   .axiA_wready                        (axi_wready),
   .axiA_wdata                         (axi_wdata),
   .axiA_wstrb                         (axi_wstrb),
   .axiA_wlast                         (axi_wlast),
   .axiA_bvalid                        (axi_bvalid),
   .axiA_bready                        (axi_bready),
   .axiA_bid                           (axi_bid),
   .axiA_bresp                         (axi_bresp),
   .axiA_arvalid                       (axi_arvalid),
   .axiA_arready                       (axi_arready),
   .axiA_araddr                        (axi_araddr),
   .axiA_arid                          (axi_arid),
   .axiA_arregion                      (axi_arregion),
   .axiA_arlen                         (axi_arlen),
   .axiA_arsize                        (axi_arsize),
   .axiA_arburst                       (axi_arburst),
   .axiA_arlock                        (axi_arlock),
   .axiA_arcache                       (axi_arcache),
   .axiA_arqos                         (axi_arqos),
   .axiA_arprot                        (axi_arprot),
   .axiA_rvalid                        (axi_rvalid),
   .axiA_rready                        (axi_rready),
   .axiA_rdata                         (axi_rdata),
   .axiA_rid                           (axi_rid),
   .axiA_rresp                         (axi_rresp),
   .axiA_rlast                         (axi_rlast),
   .io_axiAInterrupt                   (axi4Interrupt),
   .io_jtag_tms                        (io_jtag_tms),
   .io_jtag_tdi                        (io_jtag_tdi),
   .io_jtag_tdo                        (io_jtag_tdo),
   .io_jtag_tck                        (io_jtag_tck)
);

`endif

////////////////////////////////////////////////////////////////
// Hardware Accelerator

axi4_hw_accel #(
   .ADDR_WIDTH (32),
   .DATA_WIDTH (32)
) u_axi4_hw_accel (
   .axi_interrupt (axi4Interrupt),
   .axi_aclk      (i_systemClk),
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

hw_accel_wrapper #(
   .FRAME_WIDTH         (FRAME_WIDTH),
   .FRAME_HEIGHT        (FRAME_HEIGHT),
   .DMA_TRANSFER_LENGTH (FRAME_WIDTH*FRAME_HEIGHT) //S2MM DMA transfer
) u_hw_accel_wrapper (
   .clk                   (i_systemClk),
   .rst                   (io_systemReset),
   .axi_slave_clk         (i_systemClk),
   .axi_slave_rst         (io_systemReset),
   .axi_slave_we          (hw_accel_axi_we),
   .axi_slave_waddr       (hw_accel_axi_waddr),
   .axi_slave_wdata       (hw_accel_axi_wdata),
   .axi_slave_re          (hw_accel_axi_re),
   .axi_slave_raddr       (hw_accel_axi_raddr),
   .axi_slave_rdata       (hw_accel_axi_rdata),
   .axi_slave_rvalid      (hw_accel_axi_rvalid),
   .dma_rready            (hw_accel_dma_rready),
   .dma_rvalid            (hw_accel_dma_rvalid),
   .dma_rdata             (hw_accel_dma_rdata),
   .dma_rkeep             (hw_accel_dma_rkeep),
   .dma_wready            (hw_accel_dma_wready),
   .dma_wvalid            (hw_accel_dma_wvalid),
   .dma_wlast             (hw_accel_dma_wlast),
   .dma_wdata             (hw_accel_dma_wdata),
   .dma_descriptorUpdated (hw_accel_dma_descriptorUpdated)  //S2MM SG mode DMA transfer
);

////////////////////////////////////////////////////////////////
// DMA controller

assign userInterrupt = |dma_interrupts;

dma_socRuby u_dma (
   .clk                    (io_memoryClk),
   .reset                  (io_systemReset),
   .ctrl_clk               (i_systemClk),
   .ctrl_reset             (io_systemReset),
   .ctrl_PADDR             (io_apbSlave_0_PADDR),
   .ctrl_PSEL              (io_apbSlave_0_PSEL),
   .ctrl_PENABLE           (io_apbSlave_0_PENABLE),
   .ctrl_PREADY            (io_apbSlave_0_PREADY),
   .ctrl_PWRITE            (io_apbSlave_0_PWRITE),
   .ctrl_PWDATA            (io_apbSlave_0_PWDATA),
   .ctrl_PRDATA            (io_apbSlave_0_PRDATA),
   .ctrl_PSLVERROR         (io_apbSlave_0_PSLVERROR),
   .ctrl_interrupts        (dma_interrupts),
   .read_arvalid           (axi_inter_s1_arvalid),
   .read_arready           (axi_inter_s1_arready),
   .read_araddr            (axi_inter_s1_araddr),
   .read_arregion          (dma_arregion),         //Keep from synthesized away
   .read_arlen             (axi_inter_s1_arlen),
   .read_arsize            (axi_inter_s1_arsize),
   .read_arburst           (axi_inter_s1_arburst),
   .read_arlock            (axi_inter_s1_arlock),
   .read_arcache           (axi_inter_s1_arcache),
   .read_arqos             (axi_inter_s1_arqos),
   .read_arprot            (axi_inter_s1_arprot),
   .read_rvalid            (axi_inter_s1_rvalid),
   .read_rready            (axi_inter_s1_rready),
   .read_rdata             (axi_inter_s1_rdata),
   .read_rresp             (axi_inter_s1_rresp),
   .read_rlast             (axi_inter_s1_rlast),
   .write_awvalid          (axi_inter_s1_awvalid),
   .write_awready          (axi_inter_s1_awready),
   .write_awaddr           (axi_inter_s1_awaddr),
   .write_awregion         (dma_awregion),         //Keep from synthesized away
   .write_awlen            (axi_inter_s1_awlen),
   .write_awsize           (axi_inter_s1_awsize),
   .write_awburst          (axi_inter_s1_awburst),
   .write_awlock           (axi_inter_s1_awlock),
   .write_awcache          (axi_inter_s1_awcache),
   .write_awqos            (axi_inter_s1_awqos),
   .write_awprot           (axi_inter_s1_awprot),
   .write_wvalid           (axi_inter_s1_wvalid),
   .write_wready           (axi_inter_s1_wready),
   .write_wdata            (axi_inter_s1_wdata),
   .write_wstrb            (axi_inter_s1_wstrb),
   .write_wlast            (axi_inter_s1_wlast),
   .write_bvalid           (axi_inter_s1_bvalid),
   .write_bready           (axi_inter_s1_bready),
   .write_bresp            (axi_inter_s1_bresp), 
   //64-bit dma channel (S2MM - to external memory)
   .dat64_i_ch0_clk        (i_mipi_rx_pclk),
   .dat64_i_ch0_reset      (~w_mipi_rx_pclk_arstn),
   .dat64_i_ch0_tvalid     (cam_dma_wvalid),
   .dat64_i_ch0_tready     (cam_dma_wready),
   .dat64_i_ch0_tdata      (cam_dma_wdata),
   .dat64_i_ch0_tkeep      ({8{cam_dma_wvalid}}),
   .dat64_i_ch0_tdest      (4'd0),
   .dat64_i_ch0_tlast      (cam_dma_wlast),
   //.io_0_descriptorUpdate  (cam_dma_descriptorUpdated),
   //32-bit dma channel (MM2S - from external memory)
   .dat64_o_ch1_clk        (i_sysclk_div_2),
   .dat64_o_ch1_reset      (~w_sys_dp_arstn),
   .dat64_o_ch1_tvalid     (display_dma_rvalid),
   .dat64_o_ch1_tready     (display_dma_rready),
   .dat64_o_ch1_tdata      (display_dma_rdata),
   .dat64_o_ch1_tkeep      (display_dma_rkeep),
   .dat64_o_ch1_tdest      (),
   .dat64_o_ch1_tlast      (),
   //.io_1_descriptorUpdate  (),
   //32-bit dma channel (S2MM - to external memory)
   .dat32_i_ch2_clk        (i_systemClk),
   .dat32_i_ch2_reset      (io_systemReset),
   .dat32_i_ch2_tvalid     (hw_accel_dma_wvalid),
   .dat32_i_ch2_tready     (hw_accel_dma_wready),
   .dat32_i_ch2_tdata      (hw_accel_dma_wdata),
   .dat32_i_ch2_tkeep      ({4{hw_accel_dma_wvalid}}),
   .dat32_i_ch2_tdest      (4'd0),
   .dat32_i_ch2_tlast      (hw_accel_dma_wlast),
   //.io_2_descriptorUpdate  (hw_accel_dma_descriptorUpdated),
   //32-bit dma channel (MM2S - from external memory)
   .dat32_o_ch3_clk        (i_systemClk),
   .dat32_o_ch3_reset      (io_systemReset),
   .dat32_o_ch3_tvalid     (hw_accel_dma_rvalid),
   .dat32_o_ch3_tready     (hw_accel_dma_rready),
   .dat32_o_ch3_tdata      (hw_accel_dma_rdata),
   .dat32_o_ch3_tkeep      (hw_accel_dma_rkeep),
   .dat32_o_ch3_tdest      (),
   .dat32_o_ch3_tlast      ()//,
   //.io_3_descriptorUpdate  ()
);

////////////////////////////////////////////////////////////////
// AXI interconnect - Bridge across HyperRAM controller, RISC-V SoC, and DMA controller

//Convert from half duplex to full duplex - Connected to RubySoC
assign axi_inter_s0_awid    = (soc_io_arw_payload_write) ? soc_io_arw_payload_id    :  'h0;
assign axi_inter_s0_awaddr  = (soc_io_arw_payload_write) ? soc_io_arw_payload_addr  :  'h0;
assign axi_inter_s0_awlen   = (soc_io_arw_payload_write) ? soc_io_arw_payload_len   :  'h0;
assign axi_inter_s0_awsize  = (soc_io_arw_payload_write) ? soc_io_arw_payload_size  :  'h0;
assign axi_inter_s0_awburst = (soc_io_arw_payload_write) ? soc_io_arw_payload_burst :  'h0;
assign axi_inter_s0_awlock  = (soc_io_arw_payload_write) ? soc_io_arw_payload_lock  : 1'b0;
assign axi_inter_s0_awcache = (soc_io_arw_payload_write) ? soc_io_arw_payload_cache :  'h0;
assign axi_inter_s0_awprot  = (soc_io_arw_payload_write) ? soc_io_arw_payload_prot  :  'h0;
assign axi_inter_s0_awqos   = (soc_io_arw_payload_write) ? soc_io_arw_payload_qos   :  'h0;
assign axi_inter_s0_awvalid = (soc_io_arw_payload_write) ? soc_io_arw_valid         : 1'b0;
 
assign axi_inter_s0_arid    = (~soc_io_arw_payload_write) ? soc_io_arw_payload_id    :  'h0;
assign axi_inter_s0_araddr  = (~soc_io_arw_payload_write) ? soc_io_arw_payload_addr  :  'h0;
assign axi_inter_s0_arlen   = (~soc_io_arw_payload_write) ? soc_io_arw_payload_len   :  'h0;
assign axi_inter_s0_arsize  = (~soc_io_arw_payload_write) ? soc_io_arw_payload_size  :  'h0;
assign axi_inter_s0_arburst = (~soc_io_arw_payload_write) ? soc_io_arw_payload_burst :  'h0;
assign axi_inter_s0_arlock  = (~soc_io_arw_payload_write) ? soc_io_arw_payload_lock  : 1'b0;
assign axi_inter_s0_arcache = (~soc_io_arw_payload_write) ? soc_io_arw_payload_cache :  'h0;
assign axi_inter_s0_arprot  = (~soc_io_arw_payload_write) ? soc_io_arw_payload_prot  :  'h0;
assign axi_inter_s0_arqos   = (~soc_io_arw_payload_write) ? soc_io_arw_payload_qos   :  'h0;
assign axi_inter_s0_arvalid = (~soc_io_arw_payload_write) ? soc_io_arw_valid         : 1'b0;

assign soc_io_arw_ready = (soc_io_arw_payload_write) ? axi_inter_s0_awready : axi_inter_s0_arready;

assign axi_inter_s1_awid  = 8'hE0; //Don't care for DMA controller
assign axi_inter_s1_arid  = 8'hE1; //Don't care for DMA controller

axi_interconnect #(
   .S_COUNT    (2),
   .M_COUNT    (1),
   .DATA_WIDTH (128),
   .ADDR_WIDTH (32),
   .ID_WIDTH   (8)
) u_axi_interconnect (
   .clk              (io_memoryClk),
   .rst              (io_systemReset),
   //AXI slave interfaces - S0: Connected to RubySoC; S1: Connected to DMA controller
   .s_axi_awid       ({axi_inter_s1_awid   , axi_inter_s0_awid   }),
   .s_axi_awaddr     ({axi_inter_s1_awaddr , axi_inter_s0_awaddr }),
   .s_axi_awlen      ({axi_inter_s1_awlen  , axi_inter_s0_awlen  }),
   .s_axi_awsize     ({axi_inter_s1_awsize , axi_inter_s0_awsize }),
   .s_axi_awburst    ({axi_inter_s1_awburst, axi_inter_s0_awburst}),
   .s_axi_awlock     ({axi_inter_s1_awlock , axi_inter_s0_awlock }),
   .s_axi_awcache    ({axi_inter_s1_awcache, axi_inter_s0_awcache}),
   .s_axi_awprot     ({axi_inter_s1_awprot , axi_inter_s0_awprot }),
   .s_axi_awqos      ({axi_inter_s1_awqos  , axi_inter_s0_awqos  }),
   .s_axi_awvalid    ({axi_inter_s1_awvalid, axi_inter_s0_awvalid}),
   .s_axi_awready    ({axi_inter_s1_awready, axi_inter_s0_awready}),
   .s_axi_wdata      ({axi_inter_s1_wdata  , axi_inter_s0_wdata  }),
   .s_axi_wstrb      ({axi_inter_s1_wstrb  , axi_inter_s0_wstrb  }),
   .s_axi_wlast      ({axi_inter_s1_wlast  , axi_inter_s0_wlast  }),
   .s_axi_wvalid     ({axi_inter_s1_wvalid , axi_inter_s0_wvalid }),
   .s_axi_wready     ({axi_inter_s1_wready , axi_inter_s0_wready }),
   .s_axi_bid        ({axi_inter_s1_bid    , axi_inter_s0_bid    }),
   .s_axi_bresp      ({axi_inter_s1_bresp  , axi_inter_s0_bresp  }),
   .s_axi_bvalid     ({axi_inter_s1_bvalid , axi_inter_s0_bvalid }),
   .s_axi_bready     ({axi_inter_s1_bready , axi_inter_s0_bready }),
   .s_axi_arid       ({axi_inter_s1_arid   , axi_inter_s0_arid   }),
   .s_axi_araddr     ({axi_inter_s1_araddr , axi_inter_s0_araddr }),
   .s_axi_arlen      ({axi_inter_s1_arlen  , axi_inter_s0_arlen  }),
   .s_axi_arsize     ({axi_inter_s1_arsize , axi_inter_s0_arsize }),
   .s_axi_arburst    ({axi_inter_s1_arburst, axi_inter_s0_arburst}),
   .s_axi_arlock     ({axi_inter_s1_arlock , axi_inter_s0_arlock }),
   .s_axi_arcache    ({axi_inter_s1_arcache, axi_inter_s0_arcache}),
   .s_axi_arprot     ({axi_inter_s1_arprot , axi_inter_s0_arprot }),
   .s_axi_arqos      ({axi_inter_s1_arqos  , axi_inter_s0_arqos  }),
   .s_axi_arvalid    ({axi_inter_s1_arvalid, axi_inter_s0_arvalid}),
   .s_axi_arready    ({axi_inter_s1_arready, axi_inter_s0_arready}),
   .s_axi_rid        ({axi_inter_s1_rid    , axi_inter_s0_rid    }),
   .s_axi_rdata      ({axi_inter_s1_rdata  , axi_inter_s0_rdata  }),
   .s_axi_rresp      ({axi_inter_s1_rresp  , axi_inter_s0_rresp  }),
   .s_axi_rlast      ({axi_inter_s1_rlast  , axi_inter_s0_rlast  }),
   .s_axi_rvalid     ({axi_inter_s1_rvalid , axi_inter_s0_rvalid }),
   .s_axi_rready     ({axi_inter_s1_rready , axi_inter_s0_rready }),
   //AXI master interface - Connect to HyperRAM controller
   .m_axi_awid       (axi_inter_m_awid),
   .m_axi_awaddr     (axi_inter_m_awaddr),
   .m_axi_awlen      (axi_inter_m_awlen),
   .m_axi_awsize     (axi_inter_m_awsize),
   .m_axi_awburst    (axi_inter_m_awburst),
   .m_axi_awlock     (axi_inter_m_awlock),
   .m_axi_awcache    (axi_inter_m_awcache),
   .m_axi_awprot     (axi_inter_m_awprot),
   .m_axi_awqos      (axi_inter_m_awqos),
   .m_axi_awregion   (axi_inter_m_awregion),
   .m_axi_awvalid    (axi_inter_m_awvalid),
   .m_axi_awready    (axi_inter_m_awready),
   .m_axi_wdata      (axi_inter_m_wdata),
   .m_axi_wstrb      (axi_inter_m_wstrb),
   .m_axi_wlast      (axi_inter_m_wlast),
   .m_axi_wvalid     (axi_inter_m_wvalid),
   .m_axi_wready     (axi_inter_m_wready),
   .m_axi_bid        (axi_inter_m_bid),
   .m_axi_bresp      (axi_inter_m_bresp),
   .m_axi_bvalid     (axi_inter_m_bvalid),
   .m_axi_bready     (axi_inter_m_bready),
   .m_axi_arid       (axi_inter_m_arid),
   .m_axi_araddr     (axi_inter_m_araddr),
   .m_axi_arlen      (axi_inter_m_arlen),
   .m_axi_arsize     (axi_inter_m_arsize),
   .m_axi_arburst    (axi_inter_m_arburst),
   .m_axi_arlock     (axi_inter_m_arlock),
   .m_axi_arcache    (axi_inter_m_arcache),
   .m_axi_arprot     (axi_inter_m_arprot),
   .m_axi_arqos      (axi_inter_m_arqos),
   .m_axi_arregion   (axi_inter_m_arregion),
   .m_axi_arvalid    (axi_inter_m_arvalid),
   .m_axi_arready    (axi_inter_m_arready),
   .m_axi_rid        (axi_inter_m_rid),
   .m_axi_rdata      (axi_inter_m_rdata),
   .m_axi_rresp      (axi_inter_m_rresp),
   .m_axi_rlast      (axi_inter_m_rlast),
   .m_axi_rvalid     (axi_inter_m_rvalid),
   .m_axi_rready     (axi_inter_m_rready)
);

//Convert from half duplex to full duplex of memory controller interface (Connect to HyperRAM controller)
axi_full_to_half_duplex #(
   .DATA_WIDTH (128),
   .ADDR_WIDTH (32),
   .ID_WIDTH   (8)
) u_axi_full_to_half_duplex (
   .clk                       (io_memoryClk),
   .rst                       (io_systemReset),
   .io_ddr_arw_valid          (io_arw_valid),
   .io_ddr_arw_ready          (io_arw_ready),
   .io_ddr_arw_payload_addr   (io_arw_payload_addr),
   .io_ddr_arw_payload_id     (io_arw_payload_id),
   .io_ddr_arw_payload_len    (io_arw_payload_len),
   .io_ddr_arw_payload_size   (io_arw_payload_size),
   .io_ddr_arw_payload_burst  (io_arw_payload_burst),
   .io_ddr_arw_payload_lock   (io_arw_payload_lock),
   .io_ddr_arw_payload_write  (io_arw_payload_write),
   .io_ddr_w_payload_id       (io_w_payload_id),
   .io_ddr_w_valid            (io_w_valid),
   .io_ddr_w_ready            (io_w_ready),
   .io_ddr_w_payload_data     (io_w_payload_data),
   .io_ddr_w_payload_strb     (io_w_payload_strb),
   .io_ddr_w_payload_last     (io_w_payload_last),
   .io_ddr_b_valid            (io_b_valid),
   .io_ddr_b_ready            (io_b_ready),
   .io_ddr_b_payload_id       (io_b_payload_id),
   .io_ddr_r_valid            (io_r_valid),
   .io_ddr_r_ready            (io_r_ready),
   .io_ddr_r_payload_data     (io_r_payload_data),
   .io_ddr_r_payload_id       (io_r_payload_id),
   .io_ddr_r_payload_resp     (io_r_payload_resp),
   .io_ddr_r_payload_last     (io_r_payload_last),
   .s_axi_awid                (axi_inter_m_awid),
   .s_axi_awaddr              (axi_inter_m_awaddr),
   .s_axi_awlen               (axi_inter_m_awlen),
   .s_axi_awsize              (axi_inter_m_awsize),
   .s_axi_awburst             (axi_inter_m_awburst),
   .s_axi_awlock              (axi_inter_m_awlock),
   .s_axi_awcache             (axi_inter_m_awcache),
   .s_axi_awprot              (axi_inter_m_awprot),
   .s_axi_awqos               (axi_inter_m_awqos),
   .s_axi_awregion            (axi_inter_m_awregion),
   .s_axi_awvalid             (axi_inter_m_awvalid),
   .s_axi_awready             (axi_inter_m_awready),
   .s_axi_wdata               (axi_inter_m_wdata),
   .s_axi_wstrb               (axi_inter_m_wstrb),
   .s_axi_wlast               (axi_inter_m_wlast),
   .s_axi_wvalid              (axi_inter_m_wvalid),
   .s_axi_wready              (axi_inter_m_wready),
   .s_axi_bid                 (axi_inter_m_bid),
   .s_axi_bresp               (axi_inter_m_bresp),
   .s_axi_bvalid              (axi_inter_m_bvalid),
   .s_axi_bready              (axi_inter_m_bready),
   .s_axi_arid                (axi_inter_m_arid),
   .s_axi_araddr              (axi_inter_m_araddr),
   .s_axi_arlen               (axi_inter_m_arlen),
   .s_axi_arsize              (axi_inter_m_arsize),
   .s_axi_arburst             (axi_inter_m_arburst),
   .s_axi_arlock              (axi_inter_m_arlock), 
   .s_axi_arcache             (axi_inter_m_arcache),
   .s_axi_arprot              (axi_inter_m_arprot),
   .s_axi_arqos               (axi_inter_m_arqos),
   .s_axi_arregion            (axi_inter_m_arregion),
   .s_axi_arvalid             (axi_inter_m_arvalid),
   .s_axi_arready             (axi_inter_m_arready),
   .s_axi_rid                 (axi_inter_m_rid),
   .s_axi_rdata               (axi_inter_m_rdata),
   .s_axi_rresp               (axi_inter_m_rresp),
   .s_axi_rlast               (axi_inter_m_rlast),
   .s_axi_rvalid              (axi_inter_m_rvalid),
   .s_axi_rready              (axi_inter_m_rready)
);

endmodule
