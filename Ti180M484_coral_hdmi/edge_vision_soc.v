///////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023 github-efx
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

// To enable RiscV soft tap connection (for debugger).
//`define SOFT_TAP

module edge_vision_soc #(

    parameter MIPI_FRAME_WIDTH  = 1920, // camera input Width
    parameter MIPI_FRAME_HEIGHT = 1080, // camera input Height

    parameter AXI_0_DATA_WIDTH  = 512, // AXI Width 0 connected to SOC
    parameter AXI_1_DATA_WIDTH  = 512 // AXI Width 0 connected to DMA

) (
    input                  i_soc_clk,
    input                  i_axi0_mem_clk,
    input                  i_hdmi_clk_148p5MHz,
    input                  i_hdmi_clk_74p25MHz,
    input                  i_hdmi_clk_25p25MHz,
    input                  i_pixel_clk,
    input                  i_pixel_clk_tx,
    
    input                  rx_cfgclk,
    input                  tx_escclk,
    
    input                  pll_ddr_LOCKED,
    output                 pll_ddr_RSTN,
    input                  pll_osc2_LOCKED,
    output                 pll_osc2_RSTN,
    input                  pll_osc3_LOCKED,
    output                 pll_osc3_RSTN,
    
    input                  i_sys_clk,
    output                 pll_sys_RSTN,
    input                  pll_sys_LOCKED,
    
    input                  mipi_clk,
    input                  i_sys_clk_25mhz,
    
    
    //Startup Sequencer Signals
    output                 ddr_inst_CFG_RST,   //Active-high DDR configuration controller reset.
    output                 ddr_inst_CFG_START, //Start the DDR configuration controller.
    input                  ddr_inst_CFG_DONE,  //Indicates the controller configuration is done
    output                 ddr_inst_CFG_SEL,   //To select whether to use internal DDR configuration controller or user register ports for configuration:
    
    //DDR AXI 0
    output                 ddr_inst_ARST_0,
    
    //DDR AXI 0 Read Address Channel
    output  [32:0]         ddr_inst_ARADDR_0,   //Read address. It gives the address of the first transfer in a burst transaction.
    output  [1:0]          ddr_inst_ARBURST_0,   //Burst type. The burst type and the size determine how the address for each transfer within the burst is calculated.
    output  [5:0]          ddr_inst_ARID_0,      //Address ID. This signal identifies the group of address signals.
    output  [7:0]          ddr_inst_ARLEN_0,     //Burst length. This signal indicates the number of transfers in a burst.
    input                  ddr_inst_ARREADY_0,         //Address ready. This signal indicates that the slave is ready to accept an address and associated control signals.
    output  [2:0]          ddr_inst_ARSIZE_0,     //Burst size. This signal indicates the size of each transfer in the burst.
    output                 ddr_inst_ARVALID_0,         //Address valid. This signal indicates that the channel is signaling valid address and control information.
    output                 ddr_inst_ARLOCK_0,          //Lock type. This signal provides additional information about the atomic characteristics of the transfer.
    output                 ddr_inst_ARAPCMD_0,         //Read auto-precharge.
    output                 ddr_inst_ARQOS_0,           //QoS indentifier for read transaction.
    
    //DDR AXI 0 Wrtie Address Channel
    output  [32:0]         ddr_inst_AWADDR_0,   //Write address. It gives the address of the first transfer in a burst transaction.
    output  [1:0]          ddr_inst_AWBURST_0,   //Burst type. The burst type and the size determine how the address for each transfer within the burst is calculated.
    output  [5:0]          ddr_inst_AWID_0,      //Address ID. This signal identifies the group of address signals.
    output  [7:0]          ddr_inst_AWLEN_0,     //Burst length. This signal indicates the number of transfers in a burst.
    input                  ddr_inst_AWREADY_0,         //Address ready. This signal indicates that the slave is ready to accept an address and associated control signals.
    output  [2:0]          ddr_inst_AWSIZE_0,    //Burst size. This signal indicates the size of each transfer in the burst.
    output                 ddr_inst_AWVALID_0,         //Address valid. This signal indicates that the channel is signaling valid address and control information.
    output                 ddr_inst_AWLOCK_0,          //Lock type. This signal provides additional information about the atomic characteristics of the transfer.
    output                 ddr_inst_AWAPCMD_0,         //Write auto-precharge.
    output                 ddr_inst_AWQOS_0,           //QoS indentifier for write transaction.
    output  [3:0]          ddr_inst_AWCACHE_0,   //Memory type. This signal indicates how transactions are required to progress through a system.
    output                 ddr_inst_AWALLSTRB_0,       //Write all strobes asserted.
    output                 ddr_inst_AWCOBUF_0,         //Write coherent bufferable selection.
    
    //DDR AXI 0 Wrtie Response Channel
    input  [5:0]           ddr_inst_BID_0,        //Response ID tag. This signal is the ID tag of the write response.
    output                 ddr_inst_BREADY_0,          //Response ready. This signal indicates that the master can accept a write response.
    input  [1:0]           ddr_inst_BRESP_0,      //Read response. This signal indicates the status of the read transfer.
    input                  ddr_inst_BVALID_0,          //Write response valid. This signal indicates that the channel is signaling a valid write response.
    
    //DDR AXI 0 Read Data Channel
    input  [AXI_0_DATA_WIDTH-1:0]      ddr_inst_RDATA_0,    //Read data.
    input  [5:0]           ddr_inst_RID_0,                       //Read ID tag. This signal is the identification tag for the read data group of signals generated by the slave.
    input                  ddr_inst_RLAST_0,                           //Read last. This signal indicates the last transfer in a read burst.
    output                 ddr_inst_RREADY_0,                          //Read ready. This signal indicates that the master can accept the read data and response information.
    input  [1:0]           ddr_inst_RRESP_0,                     //Read response. This signal indicates the status of the read transfer.
    input                  ddr_inst_RVALID_0,                          //Read valid. This signal indicates that the channel is signaling the required read data.
    
    //DDR AXI 0 Write Data Channel Signals
    output  [AXI_0_DATA_WIDTH-1:0]     ddr_inst_WDATA_0,   //Write data. AXI4 port 0 is 256, port 1 is 128.
    output                             ddr_inst_WLAST_0,                           //Write last. This signal indicates the last transfer in a write burst.
    input                              ddr_inst_WREADY_0,                          //Write ready. This signal indicates that the slave can accept the write data.
    output  [AXI_0_DATA_WIDTH/8-1:0]   ddr_inst_WSTRB_0,  //Write strobes. This signal indicates which byte lanes hold valid data. There is one write strobe bit for each eight bits of the write data bus.
    output                             ddr_inst_WVALID_0,                          //Write valid. This signal indicates that valid write data and strobes are available.
    
    
    //DDR AXI 1 Read Address Channel
    output                 ddr_inst_ARST_1,
    output  [32:0]         ddr_inst_ARADDR_1,   //Read address. It gives the address of the first transfer in a burst transaction.
    output  [1:0]          ddr_inst_ARBURST_1,   //Burst type. The burst type and the size determine how the address for each transfer within the burst is calculated.
    output  [5:0]          ddr_inst_ARID_1,      //Address ID. This signal identifies the group of address signals.
    output  [7:0]          ddr_inst_ARLEN_1,     //Burst length. This signal indicates the number of transfers in a burst.
    input                  ddr_inst_ARREADY_1,         //Address ready. This signal indicates that the slave is ready to accept an address and associated control signals.
    output  [2:0]          ddr_inst_ARSIZE_1,     //Burst size. This signal indicates the size of each transfer in the burst.
    output                 ddr_inst_ARVALID_1,         //Address valid. This signal indicates that the channel is signaling valid address and control information.
    output                 ddr_inst_ARLOCK_1,          //Lock type. This signal provides additional information about the atomic characteristics of the transfer.
    output                 ddr_inst_ARAPCMD_1,         //Read auto-precharge.
    output                 ddr_inst_ARQOS_1,           //QoS indentifier for read transaction.
    
    //DDR AXI 1 Wrtie Address Channel
    output  [32:0]         ddr_inst_AWADDR_1,       //Write address. It gives the address of the first transfer in a burst transaction.
    output  [1:0]          ddr_inst_AWBURST_1,       //Burst type. The burst type and the size determine how the address for each transfer within the burst is calculated.
    output  [5:0]          ddr_inst_AWID_1,          //Address ID. This signal identifies the group of address signals.
    output  [7:0]          ddr_inst_AWLEN_1,         //Burst length. This signal indicates the number of transfers in a burst.
    input                  ddr_inst_AWREADY_1,             //Address ready. This signal indicates that the slave is ready to accept an address and associated control signals.
    output  [2:0]          ddr_inst_AWSIZE_1,        //Burst size. This signal indicates the size of each transfer in the burst.
    output                 ddr_inst_AWVALID_1,             //Address valid. This signal indicates that the channel is signaling valid address and control information.
    output                 ddr_inst_AWLOCK_1,              //Lock type. This signal provides additional information about the atomic characteristics of the transfer.
    output                 ddr_inst_AWAPCMD_1,             //Write auto-precharge.
    output                 ddr_inst_AWQOS_1,               //QoS indentifier for write transaction.
    output  [3:0]          ddr_inst_AWCACHE_1,       //Memory type. This signal indicates how transactions are required to progress through a system.
    output                 ddr_inst_AWALLSTRB_1,           //Write all strobes asserted.
    output                 ddr_inst_AWCOBUF_1,             //Write coherent bufferable selection.
    
    //DDR AXI 1 Wrtie Response Channel
    input   [5:0]          ddr_inst_BID_1,            //Response ID tag. This signal is the ID tag of the write response.
    output                 ddr_inst_BREADY_1,              //Response ready. This signal indicates that the master can accept a write response.
    input   [1:0]          ddr_inst_BRESP_1,          //Read response. This signal indicates the status of the read transfer.
    input                  ddr_inst_BVALID_1,              //Write response valid. This signal indicates that the channel is signaling a valid write response.
    
    //DDR AXI 1 Read Data Channel
    input   [AXI_1_DATA_WIDTH-1:0]     ddr_inst_RDATA_1,    //Read data.
    input   [5:0]          ddr_inst_RID_1,                       //Read ID tag. This signal is the identification tag for the read data group of signals generated by the slave.
    input                  ddr_inst_RLAST_1,                           //Read last. This signal indicates the last transfer in a read burst.
    output                 ddr_inst_RREADY_1,                          //Read ready. This signal indicates that the master can accept the read data and response information.
    input   [1:0]          ddr_inst_RRESP_1,                     //Read response. This signal indicates the status of the read transfer.
    input                  ddr_inst_RVALID_1,                          //Read valid. This signal indicates that the channel is signaling the required read data.
    
    //DDR AXI 1 Write Data Channel Signals
    output  [AXI_1_DATA_WIDTH-1:0]     ddr_inst_WDATA_1,   //Write data. AXI4 port 0 is 256, port 1 is 128.
    output                 ddr_inst_WLAST_1,                           //Write last. This signal indicates the last transfer in a write burst.
    input                  ddr_inst_WREADY_1,                          //Write ready. This signal indicates that the slave can accept the write data.
    output  [AXI_1_DATA_WIDTH/8-1:0]   ddr_inst_WSTRB_1,  //Write strobes. This signal indicates which byte lanes hold valid data. There is one write strobe bit for each eight bits of the write data bus.
    output                 ddr_inst_WVALID_1,                          //Write valid. This signal indicates that valid write data and strobes are available.
    
    //SOC port
    output                 system_spi_0_io_sclk_write,
    output                 system_spi_0_io_data_0_writeEnable,
    input                  system_spi_0_io_data_0_read,
    output                 system_spi_0_io_data_0_write,
    output                 system_spi_0_io_data_1_writeEnable,
    input                  system_spi_0_io_data_1_read,
    output                 system_spi_0_io_data_1_write,
    output                 system_spi_0_io_ss,

    output                 system_uart_0_io_txd,
    input                  system_uart_0_io_rxd,
    
    //CSI Camera interface
    input                  i_cam_sda,
    output                 o_cam_sda_oe,
    input                  i_cam_scl,
    output                 o_cam_scl_oe,
    output                 o_cam_rstn,
    
    //CSI RX Interface
    //MIPI DPHY RX0
    input                  mipi_dphy_rx_inst1_WORD_CLKOUT_HS,
    output                 mipi_dphy_rx_inst1_FORCE_RX_MODE,
    output                 mipi_dphy_rx_inst1_RESET_N,
    output                 mipi_dphy_rx_inst1_RST0_N,
    input                  mipi_dphy_rx_inst1_ERR_CONTENTION_LP0,
    input                  mipi_dphy_rx_inst1_ERR_CONTENTION_LP1,
    input                  mipi_dphy_rx_inst1_ERR_CONTROL_LAN0,
    input                  mipi_dphy_rx_inst1_ERR_CONTROL_LAN1,
    input                  mipi_dphy_rx_inst1_ERR_ESC_LAN0,
    input                  mipi_dphy_rx_inst1_ERR_ESC_LAN1,
    input                  mipi_dphy_rx_inst1_ERR_SOT_HS_LAN0,
    input                  mipi_dphy_rx_inst1_ERR_SOT_HS_LAN1,
    input                  mipi_dphy_rx_inst1_ERR_SOT_SYNC_HS_LAN0,
    input                  mipi_dphy_rx_inst1_ERR_SOT_SYNC_HS_LAN1,
    input                  mipi_dphy_rx_inst1_LP_CLK,
    input                  mipi_dphy_rx_inst1_RX_ACTIVE_HS_LAN0,
    input                  mipi_dphy_rx_inst1_RX_ACTIVE_HS_LAN1,
    input                  mipi_dphy_rx_inst1_RX_CLK_ACTIVE_HS,
    input                  mipi_dphy_rx_inst1_ESC_LAN0_CLK,
    input                  mipi_dphy_rx_inst1_ESC_LAN1_CLK,
    input  [7:0]           mipi_dphy_rx_inst1_RX_DATA_ESC,
    input  [CSI_RX_DATA_WIDTH_LANE-1:0] mipi_dphy_rx_inst1_RX_DATA_HS_LAN0,
    input  [CSI_RX_DATA_WIDTH_LANE-1:0] mipi_dphy_rx_inst1_RX_DATA_HS_LAN1,
    input                  mipi_dphy_rx_inst1_RX_LPDT_ESC,
    input                  mipi_dphy_rx_inst1_RX_SKEW_CAL_HS_LAN0,
    input                  mipi_dphy_rx_inst1_RX_SKEW_CAL_HS_LAN1,
    input                  mipi_dphy_rx_inst1_RX_SYNC_HS_LAN0,
    input                  mipi_dphy_rx_inst1_RX_SYNC_HS_LAN1,
    input  [3:0]           mipi_dphy_rx_inst1_RX_TRIGGER_ESC,
    input                  mipi_dphy_rx_inst1_RX_ULPS_ACTIVE_CLK_NOT,
    input                  mipi_dphy_rx_inst1_RX_ULPS_ACTIVE_NOT_LAN0,
    input                  mipi_dphy_rx_inst1_RX_ULPS_ACTIVE_NOT_LAN1,
    input                  mipi_dphy_rx_inst1_RX_ULPS_CLK_NOT,
    input                  mipi_dphy_rx_inst1_RX_ULPS_ESC_LAN0,
    input                  mipi_dphy_rx_inst1_RX_ULPS_ESC_LAN1,
    input                  mipi_dphy_rx_inst1_RX_VALID_ESC,
    input                  mipi_dphy_rx_inst1_RX_VALID_HS_LAN0,
    input                  mipi_dphy_rx_inst1_RX_VALID_HS_LAN1,
    input                  mipi_dphy_rx_inst1_STOPSTATE_CLK,
    input                  mipi_dphy_rx_inst1_STOPSTATE_LAN0,
    input                  mipi_dphy_rx_inst1_STOPSTATE_LAN1,

    // I2C Configuration for HDMI
    input                  i_hdmi_sda,
    output                 o_hdmi_sda_oe,
    input                  i_hdmi_scl,
    output                 o_hdmi_scl_oe,
    
    // HDMI YUV Output
    output                 hdmi_yuv_vs,
    output                 hdmi_yuv_hs,
    output                 hdmi_yuv_de,
    output  [15:0]         hdmi_yuv_data,
    
    //LED, SW
    output  [5:0]          o_led,
    input   [1:0]          i_sw,

    //Debug Interface
    `ifdef SOFT_TAP
    input                  io_jtag_tms,
    input                  io_jtag_tdi,
    output                 io_jtag_tdo,
    input                  io_jtag_tck
    
    `else
    input                  jtag_inst1_TCK,
    input                  jtag_inst1_TDI,
    output                 jtag_inst1_TDO,
    input                  jtag_inst1_SEL,
    input                  jtag_inst1_CAPTURE,
    input                  jtag_inst1_SHIFT,
    input                  jtag_inst1_UPDATE,
    input                  jtag_inst1_RESET
    `endif
);

////////////////////////////////////////
// Resolution Parameter (Vesa Standard)
///////////////////////////////////////
wire w_hdmi_clk;

`ifdef Full_HD_1920x1080_60Hz

    localparam  FRAME_WIDTH     = 1920;
    localparam  FRAME_HEIGHT    = 1080;
    
    localparam  VIDEO_MAX_HRES  = 11'd1920;
    localparam  VIDEO_HSP       = 8'd44;
    localparam  VIDEO_HBP       = 8'd148;
    localparam  VIDEO_HFP       = 8'd88;
    
    localparam  VIDEO_MAX_VRES  = 11'd1080;
    localparam  VIDEO_VSP       = 6'd5;
    localparam  VIDEO_VBP       = 6'd36;
    localparam  VIDEO_VFP       = 6'd4;
    
    assign w_hdmi_clk = i_hdmi_clk_148p5MHz; // HDMI Clock 148.5 MHz
`endif

`ifdef HD_Ready_1280x720_60Hz
    localparam  FRAME_WIDTH     = 1280;
    localparam  FRAME_HEIGHT    = 720;
    
    localparam  VIDEO_MAX_HRES  = 11'd1280;
    localparam  VIDEO_HSP       = 8'd684;
    localparam  VIDEO_HBP       = 8'd148;
    localparam  VIDEO_HFP       = 8'd88;
    
    localparam  VIDEO_MAX_VRES  = 11'd720;
    localparam  VIDEO_VSP       = 6'd365;
    localparam  VIDEO_VBP       = 6'd36;
    localparam  VIDEO_VFP       = 6'd4;
    
    assign w_hdmi_clk = i_hdmi_clk_74p25MHz; // HDMI Clock 74.250 MHz
`endif

`ifdef SD_640x480_60Hz
    localparam  FRAME_WIDTH     = 640;
    localparam  FRAME_HEIGHT    = 480;
    
    localparam  VIDEO_MAX_HRES  = 11'd640;
    localparam  VIDEO_HSP       = 8'd96;
    localparam  VIDEO_HBP       = 8'd40;
    localparam  VIDEO_HFP       = 8'd8;
    
    localparam  VIDEO_MAX_VRES  = 11'd480;
    localparam  VIDEO_VSP       = 6'd2;
    localparam  VIDEO_VBP       = 6'd2;
    localparam  VIDEO_VFP       = 6'd25;
    
    assign w_hdmi_clk = i_hdmi_clk_25p25MHz; // HDMI Clock 25.250 MHz
`endif


////////////////
//Reset Related
//////////////////
wire                       io_systemReset;
wire                       io_memoryReset;

wire                       w_sysclk_arstn;
wire                       w_sysclk_arst;

wire                       io_asyncResetn;

wire                       i_arstn;
wire                       mipi_rstn;

assign   pll_ddr_RSTN     = 1'b1;
assign   pll_osc2_RSTN    = 1'b1;
assign   pll_osc3_RSTN    = 1'b1;

assign   pll_sys_RSTN     = 1'b1;

assign   io_asyncResetn   = i_sw[0] & pll_sys_LOCKED & pll_ddr_LOCKED & pll_osc2_LOCKED & pll_osc3_LOCKED;
assign   w_sysclk_arst    = ~( io_asyncResetn );
assign   w_sysclk_arstn   = ~w_sysclk_arst;

assign   i_arstn          = (w_sysclk_arstn & (!mipi_rstn)) ;
assign   o_cam_rstn       = i_arstn;

/////////////
//ddr4 config
/////////////

wire  [31:0]               io_ddrA_ar_payload_addr_i;
wire  [31:0]               io_ddrA_aw_payload_addr_i;
wire  [7:0]                io_ddrA_ar_payload_id_i;
wire  [7:0]                io_ddrA_aw_payload_id_i;
wire  [7:0]                io_ddrA_b_payload_id_i;
wire  [7:0]                io_ddrA_r_payload_id_i;

wire                       ddr_cfg_ok;

common_ti180_ddr_config common_ti180_ddr_config_inst (
    .i_sys_clk                  (i_sys_clk),
    .io_memoryReset             (io_memoryReset),
    .io_asyncResetn             (io_asyncResetn),

    .ddr_inst_ARST_0            (ddr_inst_ARST_0),
    .ddr_inst_ARADDR_0          (ddr_inst_ARADDR_0),
    .ddr_inst_ARID_0            (ddr_inst_ARID_0),
    .ddr_inst_ARAPCMD_0         (ddr_inst_ARAPCMD_0),
    
    .ddr_inst_BID_0             (ddr_inst_BID_0),
    
    .ddr_inst_RID_0             (ddr_inst_RID_0),
    
    .ddr_inst_AWADDR_0          (ddr_inst_AWADDR_0),
    .ddr_inst_AWID_0            (ddr_inst_AWID_0),
    .ddr_inst_AWAPCMD_0         (ddr_inst_AWAPCMD_0),
    .ddr_inst_AWALLSTRB_0       (ddr_inst_AWALLSTRB_0),
    .ddr_inst_AWCOBUF_0         (ddr_inst_AWCOBUF_0),
    
    //DDR AXI 1 Read Address Channel
    .ddr_inst_ARST_1             (ddr_inst_ARST_1),
    .ddr_inst_ARADDR_1           (ddr_inst_ARADDR_1),
    .ddr_inst_ARID_1             (ddr_inst_ARID_1),
    .ddr_inst_ARAPCMD_1          (ddr_inst_ARAPCMD_1),
    
    //DDR AXI 1 Wrtie Address Channel
    .ddr_inst_AWADDR_1          (ddr_inst_AWADDR_1),
    .ddr_inst_AWID_1            (ddr_inst_AWID_1),
    .ddr_inst_AWAPCMD_1         (ddr_inst_AWAPCMD_1),
    .ddr_inst_AWALLSTRB_1       (ddr_inst_AWALLSTRB_1),
    .ddr_inst_AWCOBUF_1         (ddr_inst_AWCOBUF_1),
    
    .ddr_inst_CFG_RST           (ddr_inst_CFG_RST),
    .ddr_inst_CFG_START         (ddr_inst_CFG_START),
    .ddr_inst_CFG_DONE          (ddr_inst_CFG_DONE),
    .ddr_inst_CFG_SEL           (ddr_inst_CFG_SEL),
    
    .io_ddrA_ar_payload_addr_i  (io_ddrA_ar_payload_addr_i),
    .io_ddrA_aw_payload_addr_i  (io_ddrA_aw_payload_addr_i),
    .io_ddrA_ar_payload_id_i    (io_ddrA_ar_payload_id_i),
    .io_ddrA_aw_payload_id_i    (io_ddrA_aw_payload_id_i),
    .io_ddrA_b_payload_id_i     (io_ddrA_b_payload_id_i),
    .io_ddrA_r_payload_id_i     (io_ddrA_r_payload_id_i),
    
    .ddr_cfg_ok                 (ddr_cfg_ok)
);

//////////////////
// Memory checker
//////////////////
/*
localparam  SYS_FREQ_MHZ    = 100;
localparam  SOC_AXI_0_DBW   = 32;

wire  [7:0]                      m_aid_0;
wire  [31:0]                     m_aaddr_0;
wire  [7:0]                      m_alen_0;
wire  [2:0]                      m_asize_0;
wire  [1:0]                      m_aburst_0;
wire  [1:0]                      m_alock_0;
wire                             m_avalid_0;
wire                             m_aready_0;
wire                             m_awready_0;
wire                             m_arready_0;
wire                             m_atype_0;
wire  [7:0]                      m_wid_0;
wire  [SOC_AXI_0_DBW-1:0]        m_wdata_0;
wire  [(SOC_AXI_0_DBW/8)-1:0]    m_wstrb_0;
wire                             m_wlast_0;
wire                             m_wvalid_0;
wire                             m_wready_0;
wire  [3:0]                      m_rid_0;
wire  [SOC_AXI_0_DBW-1:0]        m_rdata_0;
wire                             m_rlast_0;
wire                             m_rvalid_0;
wire                             m_rready_0;
wire  [1:0]                      m_rresp_0;
wire  [7:0]                      m_bid_0;
wire  [1:0]                      m_bresp_0;
wire                             m_bvalid_0;
wire                             m_bready_0;
wire                             m_awvalid_0;
wire                             m_arvalid_0;
wire                             m_pass_0;
wire                             m_start_0;

wire                             io_axiMasterReset_0;
reg                              r_test_start_0;

wire                             memoryCheckerPass;
*/
wire                             peripheralClk;
wire                             peripheralReset; 

assign    peripheralClk = i_sys_clk;// 100MHz
/*
common_timer_start #(
    .MHZ    (SYS_FREQ_MHZ),
    .SECOND (3)
) memcheck_s0 (
    .clk    (peripheralClk),
    .rst_n  (~peripheralReset),
    .start  (m_start_0)
);

common_ddr_memory_checker #(
    .START_ADDR ('h00100000),
    .STOP_ADDR  ('h001FF800),
    .ALEN       (63),
    .WIDTH      (SOC_AXI_0_DBW)
) memcheck_0 (
    .axi_clk    (i_axi0_mem_clk),
    .rstn       (~io_axiMasterReset_0),
    .start      (m_start_0),
    .aid        (m_aid_0),
    .aaddr      (m_aaddr_0),
    .alen       (m_alen_0),
    .asize      (m_asize_0),
    .aburst     (m_aburst_0),
    .alock      (m_alock_0),
    .avalid     (m_avalid_0),
    .aready     (m_aready_0),
    .atype      (m_atype_0),
    .wdata      (m_wdata_0),
    .wstrb      (m_wstrb_0),
    .wlast      (m_wlast_0),
    .wvalid     (m_wvalid_0),
    .wready     (m_wready_0),
    .rid        (m_rid_0),
    .rdata      (m_rdata_0),
    .rlast      (m_rlast_0),
    .rvalid     (m_rvalid_0),
    .rready     (m_rready_0),
    .rresp      (m_rresp_0),
    .bid        (m_bid_0),
    .bvalid     (m_bvalid_0),
    .bready     (m_bready_0),
    .pass       (m_pass_0)
);

assign    m_aready_0=(m_atype_0 & m_awready_0) | (!m_atype_0 & m_arready_0);
assign    m_awvalid_0=m_avalid_0 & m_atype_0;
assign    m_arvalid_0=m_avalid_0 & ~m_atype_0;

assign    memoryCheckerPass = m_pass_0;
*/

///////////////////////////////////////////////////////////
// LED Status (active high) all LEDS light up == status OK
///////////////////////////////////////////////////////////
assign   o_led[5] = ddr_cfg_ok;
assign   o_led[4] = 'b1;
assign   o_led[3] = 'b1;
assign   o_led[2] = 'b1;
assign   o_led[1] = 'b1;
assign   o_led[0] = 'b1;


//////////////////////////////////////////////
// CSI controllers ouptut interface port
//////////////////////////////////////////////
localparam  CSI_RX_NUM_DATA_LANE =2;
localparam  CSI_RX_DATA_WIDTH_LANE = 16;
localparam  CAM_PIXEL_RX_DATAWIDTH = 10;   //RAW10, RAW12
localparam  CAM_PIXEL_RX_MEM_DATAWIDTH = 8;

wire w_rx_out_de;
wire w_rx_out_vs;
wire w_rx_out_hs;
wire [CAM_PIXEL_RX_MEM_DATAWIDTH-1:0] w_rx_out_data_00;
wire [CAM_PIXEL_RX_MEM_DATAWIDTH-1:0] w_rx_out_data_01;
wire [CAM_PIXEL_RX_MEM_DATAWIDTH-1:0] w_rx_out_data_10;
wire [CAM_PIXEL_RX_MEM_DATAWIDTH-1:0] w_rx_out_data_11;
wire [5:0] rx_out_dt;

cam_csi_rx_controllers #(
    .NUM_CHANNEL            (1),
    .NUM_RX_PER_CHANNEL     (CSI_RX_NUM_DATA_LANE),
    .DATAWIDTH_PER_CHANNEL  (CSI_RX_DATA_WIDTH_LANE),
    .PIXEL_RX_DATAWIDTH     (CAM_PIXEL_RX_DATAWIDTH),   //RAW10, RAW12
    .PIXEL_OUT_DATAWIDTH    (CAM_PIXEL_RX_MEM_DATAWIDTH)    //DATAWIDTH will be store to Memory
) inst_csi_rx_controllersn(

    .rstn               (i_arstn), //(i_arstn),
    .clk                (i_pixel_clk),
    .clk_pixel          (i_pixel_clk),

    // DPHY interface port
    .clk_byte_HS        (mipi_dphy_rx_inst1_WORD_CLKOUT_HS),
    .reset_byte_HS_n    (mipi_dphy_rx_inst1_RST0_N),
    .resetb_rx          (mipi_dphy_rx_inst1_RESET_N),

    .RxDataHS0          (mipi_dphy_rx_inst1_RX_DATA_HS_LAN0),  //full 16 bit
    .RxDataHS1          (mipi_dphy_rx_inst1_RX_DATA_HS_LAN1),
    .RxValidHS0         (mipi_dphy_rx_inst1_RX_VALID_HS_LAN0),
    .RxValidHS1         (mipi_dphy_rx_inst1_RX_VALID_HS_LAN1),

    .RxSyncHS           ({mipi_dphy_rx_inst1_RX_SYNC_HS_LAN1,mipi_dphy_rx_inst1_RX_SYNC_HS_LAN0 }),
    .RxUlpsClkNot       ({mipi_dphy_rx_inst1_RX_ULPS_CLK_NOT }),
    .RxUlpsActiveClkNot ({mipi_dphy_rx_inst1_RX_ULPS_ACTIVE_CLK_NOT}),
    .RxErrEsc           ({mipi_dphy_rx_inst1_ERR_ESC_LAN1,mipi_dphy_rx_inst1_ERR_ESC_LAN0 }),
    .RxErrControl       ({mipi_dphy_rx_inst1_ERR_CONTROL_LAN1,mipi_dphy_rx_inst1_ERR_CONTROL_LAN0 }),
    .RxErrSotSyncHS     ({mipi_dphy_rx_inst1_ERR_SOT_SYNC_HS_LAN1,mipi_dphy_rx_inst1_ERR_SOT_SYNC_HS_LAN0 }),
    .RxUlpsEsc          ({mipi_dphy_rx_inst1_RX_ULPS_ESC_LAN1,mipi_dphy_rx_inst1_RX_ULPS_ESC_LAN0 }),
    .RxUlpsActiveNot    ({mipi_dphy_rx_inst1_RX_ULPS_ACTIVE_NOT_LAN1,mipi_dphy_rx_inst1_RX_ULPS_ACTIVE_NOT_LAN0 }),
    .RxSkewCalHS        ({mipi_dphy_rx_inst1_RX_SKEW_CAL_HS_LAN1,mipi_dphy_rx_inst1_RX_SKEW_CAL_HS_LAN0 }),
    .RxStopState        ({mipi_dphy_rx_inst1_STOPSTATE_LAN1,mipi_dphy_rx_inst1_STOPSTATE_LAN0 }),

    // CSI controller ouptut interface port
    .rx_out_de          (w_rx_out_de),
    .rx_out_vs          (w_rx_out_vs),
    .rx_out_hs          (w_rx_out_hs),
    .rx_out_data_00     (w_rx_out_data_00),
    .rx_out_data_01     (w_rx_out_data_01),
    .rx_out_data_10     (w_rx_out_data_10),
    .rx_out_data_11     (w_rx_out_data_11),
    .rx_out_dt          (rx_out_dt)
);


//////////////////////////////
// Camera Input Preprocessing
//////////////////////////////

// Cam to DMA connection
wire            cam_dma_wready;
wire            cam_dma_wvalid;
wire            cam_dma_wlast;
wire [63:0]     cam_dma_wdata;

// Cam Debug register to APB status registers.
wire            debug_cam_dma_fifo_overflow;
wire            debug_cam_dma_fifo_underflow;
wire [31:0]     debug_cam_dma_fifo_rcount;
wire [31:0]     debug_cam_dma_fifo_wcount;
wire [31:0]     debug_cam_dma_status;

wire [31:0]     debug_cam_display_fifo_status;
wire [15:0]     rgb_control;
wire            trigger_capture_frame;
wire            continuous_capture_frame;
wire            rgb_gray;
wire            cam_dma_init_done;
wire [31:0]     frames_per_second;

wire [63:0] w_mapped_raw_ata;
assign w_mapped_raw_ata = {24'h0, w_rx_out_data_11[7:0],2'b0, w_rx_out_data_10[7:0],2'b0, w_rx_out_data_01[7:0],2'b0, w_rx_out_data_00[7:0],2'b0};

cam_coral # (
    .MIPI_FRAME_WIDTH                       (MIPI_FRAME_WIDTH),             //Input frame resolution from MIPI
    .MIPI_FRAME_HEIGHT                      (MIPI_FRAME_HEIGHT),            //Input frame resolution from MIPI
    .FRAME_WIDTH                            (FRAME_WIDTH),                  //Output frame resolution to external memory
    .FRAME_HEIGHT                           (FRAME_HEIGHT),                 //Output frame resolution to external memory
    .DMA_TRANSFER_LENGTH                    ((FRAME_WIDTH*FRAME_HEIGHT)/2), //2PPC
    .MIPI_PCLK_CLK_RATE                     (32'd100_000_000)               // as mipi_pclk is 100MHz
) u_cam (
    .mipi_pclk                              (i_pixel_clk),
    .rst_n                                  (i_arstn),
    .mipi_cam_data                          (w_mapped_raw_ata),
    .mipi_cam_valid                         (w_rx_out_de),
    .mipi_cam_vs                            (w_rx_out_vs),
    .mipi_cam_hs                            (w_rx_out_hs),
    .mipi_cam_type                          (rx_out_dt),
    
    .cam_dma_wready                         (cam_dma_wready),
    .cam_dma_wvalid                         (cam_dma_wvalid),
    .cam_dma_wlast                          (cam_dma_wlast),
    .cam_dma_wdata                          (cam_dma_wdata),

    .rgb_control                            (rgb_control),
    .trigger_capture_frame                  (trigger_capture_frame),
    .continuous_capture_frame               (continuous_capture_frame),
    .rgb_gray                               (rgb_gray),
    .cam_dma_init_done                      (cam_dma_init_done),
    .frames_per_second                      (frames_per_second),
    .debug_cam_pixel_remap_fifo_overflow    (debug_cam_pixel_remap_fifo_overflow),
    .debug_cam_pixel_remap_fifo_underflow   (debug_cam_pixel_remap_fifo_underflow),
    .debug_cam_dma_fifo_overflow            (debug_cam_dma_fifo_overflow),
    .debug_cam_dma_fifo_underflow           (debug_cam_dma_fifo_underflow),
    .debug_cam_dma_fifo_rcount              (debug_cam_dma_fifo_rcount),
    .debug_cam_dma_fifo_wcount              (debug_cam_dma_fifo_wcount),
    .debug_cam_dma_status                   (debug_cam_dma_status)
);

localparam CSI_RX_PIXEL_DATAWIDTH = CAM_PIXEL_RX_MEM_DATAWIDTH;
localparam CSI_RX_PIXEL_PER_CLK = 4;
localparam CSI_RX_TOTAL_DATAWIDTH = CSI_RX_PIXEL_DATAWIDTH * CSI_RX_PIXEL_PER_CLK;


//////////////////
//  DIPLAY (HDMI)
//////////////////

/* I2C initialization for ADV7511 */
display_hdmi_adv7511_config #(
    .INITIAL_CODE   ("source/display/hdmi/display_hdmi_adv7511_reg.mem")
) inst_adv7511_config (
    .i_arst         (w_sysclk_arst),
    .i_sysclk       (i_sys_clk_25mhz),
    .i_pll_locked   (pll_sys_LOCKED),
    .o_state        (),
    .o_confdone     (w_hdmi_confdone),
    
    .i_sda          (i_hdmi_sda),
    .o_sda_oe       (o_hdmi_sda_oe),
    .i_scl          (i_hdmi_scl),
    .o_scl_oe       (o_hdmi_scl_oe),
    .o_rstn         ()
);


// Diplay post process from DMA to HDMI Port

wire [63:0]             display_dma_rdata;
wire                    display_dma_rvalid;
wire [7:0]              display_dma_rkeep;
wire                    display_dma_rready;
wire                    debug_display_dma_fifo_overflow;
wire                    debug_display_dma_fifo_underflow;
wire [31:0]             debug_display_dma_fifo_rcount;
wire [31:0]             debug_display_dma_fifo_wcount;

assign debug_cam_display_fifo_status = {26'd0, debug_cam_pixel_remap_fifo_underflow, debug_cam_pixel_remap_fifo_overflow, debug_cam_dma_fifo_underflow, debug_cam_dma_fifo_overflow, 
                                        debug_display_dma_fifo_underflow, debug_display_dma_fifo_overflow};

display_hdmi_yuv #(
    .FRAME_WIDTH     (FRAME_WIDTH),
    .FRAME_HEIGHT    (FRAME_HEIGHT),

    .VIDEO_MAX_HRES  (VIDEO_MAX_HRES),
    .VIDEO_HSP       (VIDEO_HSP),
    .VIDEO_HBP       (VIDEO_HBP),
    .VIDEO_HFP       (VIDEO_HFP),

    .VIDEO_MAX_VRES  (VIDEO_MAX_VRES),
    .VIDEO_VSP       (VIDEO_VSP),
    .VIDEO_VBP       (VIDEO_VBP),
    .VIDEO_VFP       (VIDEO_VFP)
    
) inst_display_hdmi_yuv(
    .iHdmiClk                           (w_hdmi_clk),
    .iRst_n                             (i_arstn),
    
    //DMA RGB Input
    .ivDisplayDmaRdData                 (display_dma_rdata),
    .iDisplayDmaRdValid                 (display_dma_rvalid),
    .iv7DisplayDmaRdKeep                (display_dma_rkeep),
    .oDisplayDmaRdReady                 (display_dma_rready),
    
    // Status.
    .iRstDebugReg                       (1'b0),
    .oDebugDisplayDmaFifoUnderflow      (debug_display_dma_fifo_underflow),
    .oDebugDisplayDmaFifoOverflow       (debug_display_dma_fifo_overflow),
    .ov32DebugDisplayDmaFifoRCount      (debug_display_dma_fifo_rcount), 
    .ov32DebugDisplayDmaFifoWCount      (debug_display_dma_fifo_wcount),

    // Output to HDMI
    .oHdmiYuvVs                         (hdmi_yuv_vs),
    .oHdmiYuvHs                         (hdmi_yuv_hs),
    .oHdmiYuvDe                         (hdmi_yuv_de),
    .ov16HdmiYuvData                    (hdmi_yuv_data)
);

///////////////
// Camera Input
///////////////

wire    mipi_i2c_0_io_sda_writeEnable;
wire    mipi_i2c_0_io_sda_read;
wire    mipi_i2c_0_io_scl_writeEnable;
wire    mipi_i2c_0_io_scl_read;
wire    mipi_i2c_0_io_sda_write;
wire    mipi_i2c_0_io_scl_write;

// Mapped
assign o_cam_sda_oe = mipi_i2c_0_io_sda_writeEnable;
assign mipi_i2c_0_io_sda_read = i_cam_sda;
assign mipi_i2c_0_io_scl_read = i_cam_scl;
assign o_cam_scl_oe = mipi_i2c_0_io_scl_writeEnable;

assign mipi_i2c_0_io_sda_writeEnable = !mipi_i2c_0_io_sda_write;
assign mipi_i2c_0_io_scl_writeEnable = !mipi_i2c_0_io_scl_write;

////////////////////
// Sapphire SOC inst
////////////////////

//APB Slave 0  (DMA)
wire    [15:0]  w_dma_apbSlave_PADDR;
wire    [0:0]   w_dma_apbSlave_PSEL;
wire            w_dma_apbSlave_PENABLE;
wire            w_dma_apbSlave_PREADY;
wire            w_dma_apbSlave_PWRITE;
wire    [31:0]  w_dma_apbSlave_PWDATA;
wire    [31:0]  w_dma_apbSlave_PRDATA;
wire            w_dma_apbSlave_PSLVERROR;
wire            w_dma_ctrl_interrupt;

//APB Slave 1  (Regsisters Test)
wire    [15:0]   w_apbSlave_1_PADDR;
wire    [0:0]    w_apbSlave_1_PSEL;
wire             w_apbSlave_1_PENABLE;
wire             w_apbSlave_1_PREADY;
wire             w_apbSlave_1_PWRITE;
wire    [31:0]   w_apbSlave_1_PWDATA;
wire    [31:0]   w_apbSlave_1_PRDATA;
wire             w_apbSlave_1_PSLVERROR;

//For demo mode selection using push button
reg     [1:0]    select_demo_mode;
wire             rSw1_neg;

//AXI Slave 0
wire [7:0]      axi_awid;
wire [31:0]     axi_awaddr;
wire [7:0]      axi_awlen;
wire [2:0]      axi_awsize;
wire [1:0]      axi_awburst;
wire            axi_awlock;
wire [3:0]      axi_awcache;
wire [2:0]      axi_awprot;
wire [3:0]      axi_awqos;
wire [3:0]      axi_awregion;
wire            axi_awvalid;
wire            axi_awready;
wire [31:0]     axi_wdata;
wire [3:0]      axi_wstrb;
wire            axi_wvalid;
wire            axi_wlast;
wire            axi_wready;
wire [7:0]      axi_bid;
wire [1:0]      axi_bresp;
wire            axi_bvalid;
wire            axi_bready;
wire [7:0]      axi_arid;
wire [31:0]     axi_araddr;
wire [7:0]      axi_arlen;
wire [2:0]      axi_arsize;
wire [1:0]      axi_arburst;
wire            axi_arlock;
wire [3:0]      axi_arcache;
wire [2:0]      axi_arprot;
wire [3:0]      axi_arqos;
wire [3:0]      axi_arregion;
wire            axi_arvalid;
wire            axi_arready;
wire [7:0]      axi_rid;
wire [31:0]     axi_rdata;
wire [1:0]      axi_rresp;
wire            axi_rlast;
wire            axi_rvalid;
wire            axi_rready;
wire            axi4Interrupt;

//Hardware accelerator
wire            hw_accel_dma_rready;
wire            hw_accel_dma_rvalid;
wire [3:0]      hw_accel_dma_rkeep;
wire [31:0]     hw_accel_dma_rdata;
wire            hw_accel_dma_wready;
wire            hw_accel_dma_wvalid;
wire            hw_accel_dma_wlast;
wire [31:0]     hw_accel_dma_wdata;
wire            hw_accel_axi_we;
wire [31:0]     hw_accel_axi_waddr;
wire [31:0]     hw_accel_axi_wdata;
wire            hw_accel_axi_re;
wire [31:0]     hw_accel_axi_raddr;
wire [31:0]     hw_accel_axi_rdata;
wire            hw_accel_axi_rvalid;



SapphireSoc SapphireSoc_inst (

    //Soc Clock and Reset
    .io_systemClk                   (i_soc_clk),
    .io_asyncReset                  (w_sysclk_arst),
    .io_memoryClk                   (i_axi0_mem_clk),
    .io_memoryReset                 (io_memoryReset),
    .io_systemReset                 (io_systemReset),
    .io_peripheralClk               (peripheralClk),
    .io_peripheralReset             (peripheralReset),
    
     // Uart
    .system_uart_0_io_txd           (system_uart_0_io_txd),
    .system_uart_0_io_rxd           (system_uart_0_io_rxd),
    
    // Pi Camera I2C
    .system_i2c_0_io_sda_write      (mipi_i2c_0_io_sda_write),
    .system_i2c_0_io_sda_read       (mipi_i2c_0_io_sda_read),
    .system_i2c_0_io_scl_write      (mipi_i2c_0_io_scl_write),
    .system_i2c_0_io_scl_read       (mipi_i2c_0_io_scl_read),

    .userInterruptA                 (w_dma_ctrl_interrupt), // Dma Interrupt

     .io_ddrA_ar_valid               (ddr_inst_ARVALID_0 ),
     .io_ddrA_ar_ready               (ddr_inst_ARREADY_0 ),
     .io_ddrA_ar_payload_addr        (io_ddrA_ar_payload_addr_i ),
     .io_ddrA_ar_payload_id          (io_ddrA_ar_payload_id_i ),
     .io_ddrA_ar_payload_region      (),
     .io_ddrA_ar_payload_len         (ddr_inst_ARLEN_0 ),
     .io_ddrA_ar_payload_size        (ddr_inst_ARSIZE_0 ),
     .io_ddrA_ar_payload_burst       (ddr_inst_ARBURST_0 ),
     .io_ddrA_ar_payload_lock        (ddr_inst_ARLOCK_0 ),
     .io_ddrA_ar_payload_cache       (),
     .io_ddrA_ar_payload_qos         (ddr_inst_ARQOS_0),
     .io_ddrA_ar_payload_prot        (),
     
     .io_ddrA_aw_valid               (ddr_inst_AWVALID_0),
     .io_ddrA_aw_ready               (ddr_inst_AWREADY_0),
     .io_ddrA_aw_payload_addr        (io_ddrA_aw_payload_addr_i),
     .io_ddrA_aw_payload_id          (io_ddrA_aw_payload_id_i),
     .io_ddrA_aw_payload_region      (),
     .io_ddrA_aw_payload_len         (ddr_inst_AWLEN_0),
     .io_ddrA_aw_payload_size        (ddr_inst_AWSIZE_0),
     .io_ddrA_aw_payload_burst       (ddr_inst_AWBURST_0),
     .io_ddrA_aw_payload_lock        (ddr_inst_AWLOCK_0),
     .io_ddrA_aw_payload_cache       (ddr_inst_AWCACHE_0),
     .io_ddrA_aw_payload_qos         (ddr_inst_AWQOS_0),
     .io_ddrA_aw_payload_prot        (),
     
    .io_ddrA_w_valid                (ddr_inst_WVALID_0 ),
    .io_ddrA_w_ready                (ddr_inst_WREADY_0 ),
    .io_ddrA_w_payload_data         (ddr_inst_WDATA_0 ),
    .io_ddrA_w_payload_strb         (ddr_inst_WSTRB_0 ),
    .io_ddrA_w_payload_last         (ddr_inst_WLAST_0 ),
                                    
    .io_ddrA_b_valid                (ddr_inst_BVALID_0 ),
    .io_ddrA_b_ready                (ddr_inst_BREADY_0 ),
    .io_ddrA_b_payload_id           (io_ddrA_b_payload_id_i ),
    .io_ddrA_b_payload_resp         (ddr_inst_BRESP_0 ),
    
    .io_ddrA_r_valid                (ddr_inst_RVALID_0 ),
    .io_ddrA_r_ready                (ddr_inst_RREADY_0 ),
    .io_ddrA_r_payload_data         (ddr_inst_RDATA_0 ),
    .io_ddrA_r_payload_id           (io_ddrA_r_payload_id_i ),
    .io_ddrA_r_payload_resp         (ddr_inst_RRESP_0 ),
    .io_ddrA_r_payload_last         (ddr_inst_RLAST_0 ),

    // SPI Flash 0 Interface 
   .system_spi_0_io_sclk_write         (system_spi_0_io_sclk_write),
   .system_spi_0_io_data_0_writeEnable (system_spi_0_io_data_0_writeEnable),
   .system_spi_0_io_data_0_read        (system_spi_0_io_data_0_read),
   .system_spi_0_io_data_0_write       (system_spi_0_io_data_0_write),
   .system_spi_0_io_data_1_writeEnable (system_spi_0_io_data_1_writeEnable),
   .system_spi_0_io_data_1_read        (system_spi_0_io_data_1_read),
   .system_spi_0_io_data_1_write       (system_spi_0_io_data_1_write),
   .system_spi_0_io_ss                 (system_spi_0_io_ss),

    // APB 3 Slave 3
    .io_apbSlave_0_PADDR            (w_dma_apbSlave_PADDR),
    .io_apbSlave_0_PSEL             (w_dma_apbSlave_PSEL),
    .io_apbSlave_0_PENABLE          (w_dma_apbSlave_PENABLE),
    .io_apbSlave_0_PREADY           (w_dma_apbSlave_PREADY),
    .io_apbSlave_0_PWRITE           (w_dma_apbSlave_PWRITE),
    .io_apbSlave_0_PWDATA           (w_dma_apbSlave_PWDATA),
    .io_apbSlave_0_PRDATA           (w_dma_apbSlave_PRDATA),
    .io_apbSlave_0_PSLVERROR        (w_dma_apbSlave_PSLVERROR),
    
    // APB 3 Slave 1
    .io_apbSlave_1_PADDR            (w_apbSlave_1_PADDR),
    .io_apbSlave_1_PSEL             (w_apbSlave_1_PSEL),
    .io_apbSlave_1_PENABLE          (w_apbSlave_1_PENABLE),
    .io_apbSlave_1_PREADY           (w_apbSlave_1_PREADY),
    .io_apbSlave_1_PWRITE           (w_apbSlave_1_PWRITE),
    .io_apbSlave_1_PWDATA           (w_apbSlave_1_PWDATA),
    .io_apbSlave_1_PRDATA           (w_apbSlave_1_PRDATA),
    .io_apbSlave_1_PSLVERROR        (w_apbSlave_1_PSLVERROR),

    //AXI4 slave port
    .axiA_awvalid                   (axi_awvalid),
    .axiA_awready                   (axi_awready),
    .axiA_awaddr                    (axi_awaddr),
    .axiA_awid                      (axi_awid),
    .axiA_awregion                  (axi_awregion),
    .axiA_awlen                     (axi_awlen),
    .axiA_awsize                    (axi_awsize),
    .axiA_awburst                   (axi_awburst),
    .axiA_awlock                    (axi_awlock),
    .axiA_awcache                   (axi_awcache),
    .axiA_awqos                     (axi_awqos),
    .axiA_awprot                    (axi_awprot),
    .axiA_wvalid                    (axi_wvalid),
    .axiA_wready                    (axi_wready),
    .axiA_wdata                     (axi_wdata),
    .axiA_wstrb                     (axi_wstrb),
    .axiA_wlast                     (axi_wlast),
    .axiA_bvalid                    (axi_bvalid),
    .axiA_bready                    (axi_bready),
    .axiA_bid                       (axi_bid),
    .axiA_bresp                     (axi_bresp),
    .axiA_arvalid                   (axi_arvalid),
    .axiA_arready                   (axi_arready),
    .axiA_araddr                    (axi_araddr),
    .axiA_arid                      (axi_arid),
    .axiA_arregion                  (axi_arregion),
    .axiA_arlen                     (axi_arlen),
    .axiA_arsize                    (axi_arsize),
    .axiA_arburst                   (axi_arburst),
    .axiA_arlock                    (axi_arlock),
    .axiA_arcache                   (axi_arcache),
    .axiA_arqos                     (axi_arqos),
    .axiA_arprot                    (axi_arprot),
    .axiA_rvalid                    (axi_rvalid),
    .axiA_rready                    (axi_rready),
    .axiA_rdata                     (axi_rdata),
    .axiA_rid                       (axi_rid),
    .axiA_rresp                     (axi_rresp),
    .axiA_rlast                     (axi_rlast),
    .axiAInterrupt                  (axi4Interrupt),
    
    // DDR Memory Checker
    /*
    .io_ddrMasters_0_clk                (peripheralClk),
    .io_ddrMasters_0_reset              (io_axiMasterReset_0),
    .io_ddrMasters_0_aw_valid           (m_awvalid_0),
    .io_ddrMasters_0_aw_ready           (m_awready_0),
    .io_ddrMasters_0_aw_payload_addr    (m_aaddr_0),
    .io_ddrMasters_0_aw_payload_id      (m_aid_0[3:0]),
    .io_ddrMasters_0_aw_payload_region  (4'h0),
    .io_ddrMasters_0_aw_payload_len     (m_alen_0),
    .io_ddrMasters_0_aw_payload_size    (m_asize_0),
    .io_ddrMasters_0_aw_payload_burst   (m_aburst_0),
    .io_ddrMasters_0_aw_payload_lock    (m_alock_0[0]),
    .io_ddrMasters_0_aw_payload_cache   (4'h0),
    .io_ddrMasters_0_aw_payload_qos     (4'h0),
    .io_ddrMasters_0_aw_payload_prot    (3'h0),
    .io_ddrMasters_0_w_valid            (m_wvalid_0),
    .io_ddrMasters_0_w_ready            (m_wready_0),
    .io_ddrMasters_0_w_payload_data     (m_wdata_0),
    .io_ddrMasters_0_w_payload_strb     (m_wstrb_0),
    .io_ddrMasters_0_w_payload_last     (m_wlast_0),
    .io_ddrMasters_0_b_valid            (m_bvalid_0),
    .io_ddrMasters_0_b_ready            (m_bready_0),
    .io_ddrMasters_0_b_payload_id       (m_bid_0[3:0]),
    .io_ddrMasters_0_b_payload_resp     (m_bresp_0),
    .io_ddrMasters_0_ar_valid           (m_arvalid_0),
    .io_ddrMasters_0_ar_ready           (m_arready_0),
    .io_ddrMasters_0_ar_payload_addr    (m_aaddr_0),
    .io_ddrMasters_0_ar_payload_id      (m_aid_0[3:0]),
    .io_ddrMasters_0_ar_payload_region  (4'h0),
    .io_ddrMasters_0_ar_payload_len     (m_alen_0),
    .io_ddrMasters_0_ar_payload_size    (m_asize_0),
    .io_ddrMasters_0_ar_payload_burst   (m_aburst_0),
    .io_ddrMasters_0_ar_payload_lock    (m_alock_0[0]),
    .io_ddrMasters_0_ar_payload_cache   (4'h0),
    .io_ddrMasters_0_ar_payload_qos     (4'h0),
    .io_ddrMasters_0_ar_payload_prot    (3'h0),
    .io_ddrMasters_0_r_valid            (m_rvalid_0),
    .io_ddrMasters_0_r_ready            (m_rready_0),
    .io_ddrMasters_0_r_payload_data     (m_rdata_0),
    .io_ddrMasters_0_r_payload_id       (m_rid_0),
    .io_ddrMasters_0_r_payload_resp     (m_rresp_0),
    .io_ddrMasters_0_r_payload_last     (m_rlast_0),
*/
    `ifdef SOFT_TAP
    .io_jtag_tck                        (io_jtag_tck),
    .io_jtag_tdi                        (io_jtag_tdi),
    .io_jtag_tdo                        (io_jtag_tdo),
    .io_jtag_tms                        (io_jtag_tms)
    `else 
    .jtagCtrl_tck                       (jtag_inst1_TCK),
    .jtagCtrl_tdi                       (jtag_inst1_TDI),
    .jtagCtrl_tdo                       (jtag_inst1_TDO),
    .jtagCtrl_enable                    (jtag_inst1_SEL),
    .jtagCtrl_capture                   (jtag_inst1_CAPTURE),
    .jtagCtrl_shift                     (jtag_inst1_SHIFT),
    .jtagCtrl_update                    (jtag_inst1_UPDATE),
    .jtagCtrl_reset                     (jtag_inst1_RESET) 
    
    `endif

);

////////////////
// APB3 Slave 1
///////////////

// For control and status register
common_apb3 #(
   .ADDR_WIDTH                              (16),
   .DATA_WIDTH                              (32),
   .NUM_REG                                 (7)
) u_apb3_cam_display (
    .clk                                    (peripheralClk),
    .resetn                                 (~peripheralReset),
    
    // Output Control
    .mipi_rstn                              (mipi_rstn),
    .rgb_control                            (rgb_control),
    .trigger_capture_frame                  (trigger_capture_frame),
    .continuous_capture_frame               (continuous_capture_frame),
    .rgb_gray                               (rgb_gray),
    .cam_dma_init_done                      (cam_dma_init_done),
    .frames_per_second                      (frames_per_second),
    .select_demo_mode                       (select_demo_mode),

    // Input Info Data
    .debug_fifo_status                      (debug_cam_display_fifo_status),
    .debug_cam_dma_fifo_rcount              (debug_cam_dma_fifo_rcount),
    .debug_cam_dma_fifo_wcount              (debug_cam_dma_fifo_wcount),
    .debug_cam_dma_status                   (debug_cam_dma_status),
    .debug_display_dma_fifo_rcount          (debug_display_dma_fifo_rcount),
    .debug_display_dma_fifo_wcount          (debug_display_dma_fifo_wcount),

    // Apb 3 interface
    .PADDR                                  (w_apbSlave_1_PADDR),
    .PSEL                                   (w_apbSlave_1_PSEL),
    .PENABLE                                (w_apbSlave_1_PENABLE),
    .PREADY                                 (w_apbSlave_1_PREADY),
    .PWRITE                                 (w_apbSlave_1_PWRITE),
    .PWDATA                                 (w_apbSlave_1_PWDATA),
    .PRDATA                                 (w_apbSlave_1_PRDATA),
    .PSLVERROR                              (w_apbSlave_1_PSLVERROR)
);

//for demo2 
common_debouncer u_common_debouncer (
   .switch(i_sw[1]),
   .clk(peripheralClk),
   .rst_n(i_arstn),
   .q(rSw1_neg)
   );

always @(posedge peripheralClk) begin
   if (~i_arstn)    begin
      select_demo_mode <= 2'b11; 
   end else begin
     if(rSw1_neg) begin
         select_demo_mode <= select_demo_mode + 2'b1;
     end else begin
         select_demo_mode <= select_demo_mode;
     end
   end
end
//


////////////
// Dma inst
///////////
wire  [3:0] dma_interrupts;
assign w_dma_ctrl_interrupt = | dma_interrupts;

dma u_dma(

    .clk                (i_axi0_mem_clk),
    .reset              (io_memoryReset),
    
    .ctrl_clk           (peripheralClk),
    .ctrl_reset         (peripheralReset),

    //APB Slave
    .ctrl_PADDR         (w_dma_apbSlave_PADDR),
    .ctrl_PSEL          (w_dma_apbSlave_PSEL),
    .ctrl_PENABLE       (w_dma_apbSlave_PENABLE),
    .ctrl_PREADY        (w_dma_apbSlave_PREADY),
    .ctrl_PWRITE        (w_dma_apbSlave_PWRITE),
    .ctrl_PWDATA        (w_dma_apbSlave_PWDATA),
    .ctrl_PRDATA        (w_dma_apbSlave_PRDATA),
    .ctrl_PSLVERROR     (w_dma_apbSlave_PSLVERROR),
    .ctrl_interrupts    (dma_interrupts),

    //DMA AXI memory Interface 
    .read_arvalid       (ddr_inst_ARVALID_1),
    .read_araddr        (ddr_inst_ARADDR_1[31:0]),
    .read_arready       (ddr_inst_ARREADY_1),
    .read_arregion      (),
    .read_arlen         (ddr_inst_ARLEN_1),
    .read_arsize        (ddr_inst_ARSIZE_1),
    .read_arburst       (ddr_inst_ARBURST_1),
    .read_arlock        (ddr_inst_ARLOCK_1),
    .read_arcache       ( ),
    .read_arqos         (ddr_inst_ARQOS_1),
    .read_arprot        ( ),
    
    .read_rready        (ddr_inst_RREADY_1),
    .read_rvalid        (ddr_inst_RVALID_1),
    .read_rdata         (ddr_inst_RDATA_1),
    .read_rlast         (ddr_inst_RLAST_1),
    .read_rresp         (ddr_inst_RRESP_1),
    
    .write_awvalid      (ddr_inst_AWVALID_1),
    .write_awready      (ddr_inst_AWREADY_1),
    .write_awaddr       (ddr_inst_AWADDR_1[31:0]),
    .write_awregion     (),
    .write_awlen        (ddr_inst_AWLEN_1),
    .write_awsize       (ddr_inst_AWSIZE_1),
    .write_awburst      (ddr_inst_AWBURST_1),
    .write_awlock       (ddr_inst_AWLOCK_1),
    .write_awcache      (ddr_inst_AWCACHE_1),
    .write_awqos        (ddr_inst_AWQOS_1),
    .write_awprot       (),
    
    .write_wvalid       (ddr_inst_WVALID_1),
    .write_wready       (ddr_inst_WREADY_1),
    .write_wdata        (ddr_inst_WDATA_1),
    .write_wstrb        (ddr_inst_WSTRB_1),
    .write_wlast        (ddr_inst_WLAST_1),
    
    .write_bvalid       (ddr_inst_BVALID_1),
    .write_bready       (ddr_inst_BREADY_1),
    .write_bresp        (ddr_inst_BRESP_1),


    //64bits Camera Video Stream In
    .dat0_i_clk         (i_pixel_clk),
    .dat0_i_reset       (~i_arstn),
    
    .dat0_i_tvalid      (cam_dma_wvalid),
    .dat0_i_tready      (cam_dma_wready),
    .dat0_i_tdata       (cam_dma_wdata),
    .dat0_i_tkeep       ({8{cam_dma_wvalid}}),
    .dat0_i_tdest       (4'd0),
    .dat0_i_tlast       (cam_dma_wlast),

    //64-bit dma channel (MM2S - from external memory)
    .dat1_o_clk         (w_hdmi_clk),
    .dat1_o_reset       (~i_arstn),
    .dat1_o_tvalid      (display_dma_rvalid),
    .dat1_o_tready      (display_dma_rready),
    .dat1_o_tdata       (display_dma_rdata),
    .dat1_o_tkeep       (display_dma_rkeep),
    .dat1_o_tdest       ( ),
    .dat1_o_tlast       ( ),
    
   //32-bit dma channel (S2MM - to DDR)
   .dat2_i_clk          (i_soc_clk),
   .dat2_i_reset        (~i_arstn),
   .dat2_i_tvalid       (hw_accel_dma_wvalid),
   .dat2_i_tready       (hw_accel_dma_wready),
   .dat2_i_tdata        (hw_accel_dma_wdata),
   .dat2_i_tkeep        ({4{hw_accel_dma_wvalid}}),
   .dat2_i_tdest        (4'd0),
   .dat2_i_tlast        (hw_accel_dma_wlast),
   
   //32-bit dma channel (MM2S - from DDR)
   .dat3_o_clk          (i_soc_clk),
   .dat3_o_reset        (~i_arstn),
   .dat3_o_tvalid       (hw_accel_dma_rvalid),
   .dat3_o_tready       (hw_accel_dma_rready),
   .dat3_o_tdata        (hw_accel_dma_rdata),
   .dat3_o_tkeep        (hw_accel_dma_rkeep),
   .dat3_o_tdest        (),
   .dat3_o_tlast        ()
);


//////////////////
//HW ACCELERATOR 
/////////////////

hw_accel_axi4 #(
    .ADDR_WIDTH     (32),
    .DATA_WIDTH     (32)
) u_hw_accel_axi4 (
    .axi_interrupt (axi4Interrupt),
    .axi_aclk      (peripheralClk),
    .axi_resetn    (~peripheralReset),
    
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

    .clk                   (i_soc_clk),
    .rst                   (~i_arstn),
    
    .axi_slave_clk         (peripheralClk),
    .axi_slave_rst         (peripheralReset),
    
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
    .dma_wdata             (hw_accel_dma_wdata)
);

endmodule
