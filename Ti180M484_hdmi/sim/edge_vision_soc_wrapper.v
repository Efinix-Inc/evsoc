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

`timescale 100ps/10ps

module edge_vision_soc_wrapper #(
   parameter MIPI_FRAME_WIDTH      = 1920,  
   parameter MIPI_FRAME_HEIGHT     = 1080,
   parameter FRAME_WIDTH           = 64,    
   parameter FRAME_HEIGHT          = 48
   //Actual frame resolution used for subsequent processing (after cropping).
   //Not applicable for LVDS HDMI display (display setup to be modified separately).
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
   output [5:0]   io_ddrA_arw_payload_id,
   output [7:0]   io_ddrA_arw_payload_len,
   output [2:0]   io_ddrA_arw_payload_size,
   output [1:0]   io_ddrA_arw_payload_burst,
   output [1:0]   io_ddrA_arw_payload_lock,
   output         io_ddrA_arw_payload_write,
   output [7:0]   io_ddrA_w_payload_id,
   output         io_ddrA_w_valid,
   input          io_ddrA_w_ready,
   output [511:0] io_ddrA_w_payload_data,
   output [63:0]  io_ddrA_w_payload_strb,
   output         io_ddrA_w_payload_last,
   input          io_ddrA_b_valid,
   output         io_ddrA_b_ready,
   input  [7:0]   io_ddrA_b_payload_id,
   input          io_ddrA_r_valid,
   output         io_ddrA_r_ready,
   input  [511:0] io_ddrA_r_payload_data,
   input  [7:0]   io_ddrA_r_payload_id,
   input  [1:0]   io_ddrA_r_payload_resp,
   input          io_ddrA_r_payload_last,
   output         io_ddrB_arw_valid,
   input          io_ddrB_arw_ready,
   output [31:0]  io_ddrB_arw_payload_addr,
   output [5:0]   io_ddrB_arw_payload_id,
   output [7:0]   io_ddrB_arw_payload_len,
   output [2:0]   io_ddrB_arw_payload_size,
   output [1:0]   io_ddrB_arw_payload_burst,
   output [1:0]   io_ddrB_arw_payload_lock,
   output         io_ddrB_arw_payload_write,
   output [7:0]   io_ddrB_w_payload_id,
   output         io_ddrB_w_valid,
   input          io_ddrB_w_ready,
   output [511:0] io_ddrB_w_payload_data,
   output [63:0]  io_ddrB_w_payload_strb,
   output         io_ddrB_w_payload_last,
   input          io_ddrB_b_valid,
   output         io_ddrB_b_ready,
   input  [7:0]   io_ddrB_b_payload_id,
   input          io_ddrB_r_valid,
   output         io_ddrB_r_ready,
   input  [511:0] io_ddrB_r_payload_data,
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

wire		io_ddrA_ar_valid;
wire		io_ddrA_ar_ready;
wire [31:0] io_ddrA_ar_payload_addr;
wire [5:0] io_ddrA_ar_payload_id;
wire [7:0] io_ddrA_ar_payload_len;
wire [2:0] io_ddrA_ar_payload_size;
wire [1:0] io_ddrA_ar_payload_burst;
wire [1:0] io_ddrA_ar_payload_lock;
wire		io_ddrA_aw_valid;
wire		io_ddrA_aw_ready;
wire [31:0] io_ddrA_aw_payload_addr;
wire [5:0] io_ddrA_aw_payload_id;
wire [7:0] io_ddrA_aw_payload_len;
wire [2:0] io_ddrA_aw_payload_size;
wire [1:0] io_ddrA_aw_payload_burst;
wire [1:0] io_ddrA_aw_payload_lock;

wire		io_ddrB_ar_valid;
wire		io_ddrB_ar_ready;
wire [31:0] io_ddrB_ar_payload_addr;
wire [5:0] io_ddrB_ar_payload_id;
wire [7:0] io_ddrB_ar_payload_len;
wire [2:0] io_ddrB_ar_payload_size;
wire [1:0] io_ddrB_ar_payload_burst;
wire [1:0] io_ddrB_ar_payload_lock;
wire		io_ddrB_aw_valid;
wire		io_ddrB_aw_ready;
wire [31:0] io_ddrB_aw_payload_addr;
wire [5:0] io_ddrB_aw_payload_id;
wire [7:0] io_ddrB_aw_payload_len;
wire [2:0] io_ddrB_aw_payload_size;
wire [1:0] io_ddrB_aw_payload_burst;
wire [1:0] io_ddrB_aw_payload_lock;

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


fd_to_hd_wrapper fd_to_hd_wrapper_inst_0(
.clk(axi_clk),
.reset(!master_rstn),
.io_ddrA_arw_valid(io_ddrA_arw_valid),
.io_ddrA_arw_ready(io_ddrA_arw_ready),
.io_ddrA_arw_payload_addr(io_ddrA_arw_payload_addr),
.io_ddrA_arw_payload_id(io_ddrA_arw_payload_id),
.io_ddrA_arw_payload_len(io_ddrA_arw_payload_len),
.io_ddrA_arw_payload_size(io_ddrA_arw_payload_size),
.io_ddrA_arw_payload_burst(io_ddrA_arw_payload_burst),
.io_ddrA_arw_payload_lock(io_ddrA_arw_payload_lock),
.io_ddrA_arw_payload_write(io_ddrA_arw_payload_write),
.io_ddrA_aw_valid(io_ddrA_aw_valid),
.io_ddrA_aw_ready(io_ddrA_aw_ready),
.io_ddrA_aw_payload_addr(io_ddrA_aw_payload_addr),
.io_ddrA_aw_payload_id(io_ddrA_aw_payload_id),
.io_ddrA_aw_payload_len(io_ddrA_aw_payload_len),
.io_ddrA_aw_payload_size(io_ddrA_aw_payload_size),
.io_ddrA_aw_payload_burst(io_ddrA_aw_payload_burst),
.io_ddrA_aw_payload_lock(io_ddrA_aw_payload_lock),
.io_ddrA_ar_valid(io_ddrA_ar_valid),
.io_ddrA_ar_ready(io_ddrA_ar_ready),
.io_ddrA_ar_payload_addr(io_ddrA_ar_payload_addr),
.io_ddrA_ar_payload_id(io_ddrA_ar_payload_id),
.io_ddrA_ar_payload_len(io_ddrA_ar_payload_len),
.io_ddrA_ar_payload_size(io_ddrA_ar_payload_size),
.io_ddrA_ar_payload_burst(io_ddrA_ar_payload_burst),
.io_ddrA_ar_payload_lock(io_ddrA_ar_payload_lock));

fd_to_hd_wrapper fd_to_hd_wrapper_inst_1(
.clk(axi_clk),
.reset(!master_rstn),
.io_ddrA_arw_valid(io_ddrB_arw_valid),
.io_ddrA_arw_ready(io_ddrB_arw_ready),
.io_ddrA_arw_payload_addr(io_ddrB_arw_payload_addr),
.io_ddrA_arw_payload_id(io_ddrB_arw_payload_id),
.io_ddrA_arw_payload_len(io_ddrB_arw_payload_len),
.io_ddrA_arw_payload_size(io_ddrB_arw_payload_size),
.io_ddrA_arw_payload_burst(io_ddrB_arw_payload_burst),
.io_ddrA_arw_payload_lock(io_ddrB_arw_payload_lock),
.io_ddrA_arw_payload_write(io_ddrB_arw_payload_write),
.io_ddrA_aw_valid(io_ddrB_aw_valid),
.io_ddrA_aw_ready(io_ddrB_aw_ready),
.io_ddrA_aw_payload_addr(io_ddrB_aw_payload_addr),
.io_ddrA_aw_payload_id(io_ddrB_aw_payload_id),
.io_ddrA_aw_payload_len(io_ddrB_aw_payload_len),
.io_ddrA_aw_payload_size(io_ddrB_aw_payload_size),
.io_ddrA_aw_payload_burst(io_ddrB_aw_payload_burst),
.io_ddrA_aw_payload_lock(io_ddrB_aw_payload_lock),
.io_ddrA_ar_valid(io_ddrB_ar_valid),
.io_ddrA_ar_ready(io_ddrB_ar_ready),
.io_ddrA_ar_payload_addr(io_ddrB_ar_payload_addr),
.io_ddrA_ar_payload_id(io_ddrB_ar_payload_id),
.io_ddrA_ar_payload_len(io_ddrB_ar_payload_len),
.io_ddrA_ar_payload_size(io_ddrB_ar_payload_size),
.io_ddrA_ar_payload_burst(io_ddrB_ar_payload_burst),
.io_ddrA_ar_payload_lock(io_ddrB_ar_payload_lock));


edge_vision_soc_sim #(
   .MIPI_FRAME_WIDTH    (MIPI_FRAME_WIDTH),
   .MIPI_FRAME_HEIGHT   (MIPI_FRAME_HEIGHT),
   .FRAME_WIDTH         (FRAME_WIDTH),
   .FRAME_HEIGHT        (FRAME_HEIGHT)
) DUT (
    //Clock Control & reset pin
 .i_soc_clk                             (soc_clk),
 .i_axi0_mem_clk                        (axi_clk),
 .i_hdmi_clk_148p5MHz                   (),
 .i_hdmi_clk_74p25MHz                   (),
 .i_hdmi_clk_25p25MHz                   (),
 .i_pixel_clk                           (mipi_pclk),           
 .i_pixel_clk_tx                        (tx_slowclk),           
 .rx_cfgclk                             (),          
 .tx_escclk                             (),          
             
 .pll_ddr_LOCKED                        (ddr_clk_locked),           
 .pll_ddr_RSTN                          (),          
 .pll_osc2_LOCKED                       (i_pll_locked),          
 .pll_osc2_RSTN                         (),            
 .pll_osc3_LOCKED                       (i_pll_locked),          
 .pll_osc3_RSTN                         (),            
             
 .i_sys_clk                             (mipi_pclk),          
 .pll_sys_RSTN                          (),          
 .pll_sys_LOCKED                        (i_pll_locked),           
 .mipi_clk                              (mipi_pclk),           
 .i_sys_clk_25mhz                       (),          
    
`ifdef SIM
   //Simulation frame data from testbench
 .sim_cam_hsync                        (sim_cam_hsync),
 .sim_cam_vsync                        (sim_cam_vsync),
 .sim_cam_valid                        (sim_cam_valid),
 .sim_cam_r_pix                        (sim_cam_r_pix),
 .sim_cam_g_pix                        (sim_cam_g_pix),
 .sim_cam_b_pix                        (sim_cam_b_pix),
`endif
    
    //Startup Sequencer Signals
  .ddr_inst_CFG_RST                    (ddr_inst1_CFG_SEQ_RST),  
  .ddr_inst_CFG_START                  (ddr_inst1_CFG_SEQ_START),
                      
                      

    //DDR AXI 0
   .ddr_inst_ARST_0                    (),
    //DDR AXI 0 Read Address Channel
   .ddr_inst_ARADDR_0                  (io_ddrA_ar_payload_addr),  
   .ddr_inst_ARBURST_0                 (io_ddrA_ar_payload_burst), 
   .ddr_inst_ARID_0                    (io_ddrA_ar_payload_id),    
   .ddr_inst_ARLEN_0                   (io_ddrA_ar_payload_len),   
   .ddr_inst_ARREADY_0                 (io_ddrA_ar_ready), 
   .ddr_inst_ARSIZE_0                  (io_ddrA_ar_payload_size),  
   .ddr_inst_ARVALID_0                 (io_ddrA_ar_valid), 
   .ddr_inst_ARLOCK_0                  (io_ddrA_ar_payload_lock),  
   .ddr_inst_ARAPCMD_0                 (), 
   .ddr_inst_ARQOS_0                   (),   

    //DDR AXI 0 Wrtie Address Channel
   .ddr_inst_AWADDR_0                  (io_ddrA_aw_payload_addr),   
   .ddr_inst_AWBURST_0                 (io_ddrA_aw_payload_burst),  
   .ddr_inst_AWID_0                    (io_ddrA_aw_payload_id),     
   .ddr_inst_AWLEN_0                   (io_ddrA_aw_payload_len),    
   .ddr_inst_AWREADY_0                 (io_ddrA_aw_ready),  
   .ddr_inst_AWSIZE_0                  (io_ddrA_aw_payload_size),   
   .ddr_inst_AWVALID_0                 (io_ddrA_aw_valid),  
   .ddr_inst_AWLOCK_0                  (io_ddrA_aw_payload_lock),   
   .ddr_inst_AWAPCMD_0                 (),  
   .ddr_inst_AWQOS_0                   (),    
   .ddr_inst_AWCACHE_0                 (),  
   .ddr_inst_AWALLSTRB_0               (),
   .ddr_inst_AWCOBUF_0                 (),  
    
    //DDR AXI 0 Wrtie Response Channel
   .ddr_inst_BID_0                     (io_ddrA_b_payload_id),      
   .ddr_inst_BREADY_0                  (io_ddrA_b_ready),   
   .ddr_inst_BRESP_0                   (2'b00),    
   .ddr_inst_BVALID_0                  (io_ddrA_b_valid),   
    
    //DDR AXI 0 Read Data Channel
   .ddr_inst_RDATA_0                   (io_ddrA_r_payload_data),
   .ddr_inst_RID_0                     (io_ddrA_r_payload_id),                       
   .ddr_inst_RLAST_0                   (io_ddrA_r_payload_last),                     
   .ddr_inst_RREADY_0                  (io_ddrA_r_ready),                    
   .ddr_inst_RRESP_0                   (io_ddrA_r_payload_resp),                     
   .ddr_inst_RVALID_0                  (io_ddrA_r_valid),                    
    
    //DDR AXI 0 Write Data Channel Signals
    
   .ddr_inst_WDATA_0                   (io_ddrA_w_payload_data),  
   .ddr_inst_WLAST_0                   (io_ddrA_w_payload_last),  
   .ddr_inst_WREADY_0                  (io_ddrA_w_ready), 
   .ddr_inst_WSTRB_0                   (io_ddrA_w_payload_strb),  
   .ddr_inst_WVALID_0                  (io_ddrA_w_valid),                    
    
    
    //DDR AXI 0
   .ddr_inst_ARST_1                    (),
    //DDR AXI 0 Read Address Channel
   .ddr_inst_ARADDR_1                  (io_ddrB_ar_payload_addr),  
   .ddr_inst_ARBURST_1                 (io_ddrB_ar_payload_burst), 
   .ddr_inst_ARID_1                    (io_ddrB_ar_payload_id),    
   .ddr_inst_ARLEN_1                   (io_ddrB_ar_payload_len),   
   .ddr_inst_ARREADY_1                 (io_ddrB_ar_ready), 
   .ddr_inst_ARSIZE_1                  (io_ddrB_ar_payload_size),  
   .ddr_inst_ARVALID_1                 (io_ddrB_ar_valid), 
   .ddr_inst_ARLOCK_1                  (io_ddrB_ar_payload_lock),  
   .ddr_inst_ARAPCMD_1                 (), 
   .ddr_inst_ARQOS_1                   (),   

    //DDR AXI 0 Wrtie Address Channel
   .ddr_inst_AWADDR_1                  (io_ddrB_aw_payload_addr),   
   .ddr_inst_AWBURST_1                 (io_ddrB_aw_payload_burst),  
   .ddr_inst_AWID_1                    (io_ddrB_aw_payload_id),     
   .ddr_inst_AWLEN_1                   (io_ddrB_aw_payload_len),    
   .ddr_inst_AWREADY_1                 (io_ddrB_aw_ready),  
   .ddr_inst_AWSIZE_1                  (io_ddrB_aw_payload_size),   
   .ddr_inst_AWVALID_1                 (io_ddrB_aw_valid),  
   .ddr_inst_AWLOCK_1                  (io_ddrB_aw_payload_lock),   
   .ddr_inst_AWAPCMD_1                 (),  
   .ddr_inst_AWQOS_1                   (),    
   .ddr_inst_AWCACHE_1                 (),  
   .ddr_inst_AWALLSTRB_1               (),
   .ddr_inst_AWCOBUF_1                 (),  
    
    //DDR AXI 0 Wrtie Response Channel
   .ddr_inst_BID_1                     (io_ddrB_b_payload_id),      
   .ddr_inst_BREADY_1                  (io_ddrB_b_ready),   
   .ddr_inst_BRESP_1                   (2'b00),    
   .ddr_inst_BVALID_1                  (io_ddrB_b_valid),   
    
    //DDR AXI 0 Read Data Channel
   .ddr_inst_RDATA_1                   (io_ddrB_r_payload_data),
   .ddr_inst_RID_1                     (io_ddrB_r_payload_id),                       
   .ddr_inst_RLAST_1                   (io_ddrB_r_payload_last),                     
   .ddr_inst_RREADY_1                  (io_ddrB_r_ready),                    
   .ddr_inst_RRESP_1                   (io_ddrB_r_payload_resp),                     
   .ddr_inst_RVALID_1                  (io_ddrB_r_valid),                    
    
    //DDR AXI 0 Write Data Channel Signals
    
   .ddr_inst_WDATA_1                   (io_ddrB_w_payload_data),  
   .ddr_inst_WLAST_1                   (io_ddrB_w_payload_last),  
   .ddr_inst_WREADY_1                  (io_ddrB_w_ready), 
   .ddr_inst_WSTRB_1                   (io_ddrB_w_payload_strb),  
   .ddr_inst_WVALID_1                  (io_ddrB_w_valid),                    
    
    
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

    //CSI RX Interface
    //MIPI DPHY RX0
    /*
   .mipi_dphy_rx_inst1_WORD_CLKOUT_HS              (),
   .mipi_dphy_rx_inst1_FORCE_RX_MODE               (),
   .mipi_dphy_rx_inst1_RESET_N                     (),
   .mipi_dphy_rx_inst1_RST0_N                      (),
   .mipi_dphy_rx_inst1_ERR_CONTENTION_LP           (),
   .mipi_dphy_rx_inst1_ERR_CONTENTION_LP1          (),
   .mipi_dphy_rx_inst1_ERR_CONTROL_LAN0            (),
   .mipi_dphy_rx_inst1_ERR_CONTROL_LAN1            (),
   .mipi_dphy_rx_inst1_ERR_ESC_LAN0                (),
   .mipi_dphy_rx_inst1_ERR_ESC_LAN1                (),
   .mipi_dphy_rx_inst1_ERR_SOT_HS_LAN0             (),
   .mipi_dphy_rx_inst1_ERR_SOT_HS_LAN1             (),
   .mipi_dphy_rx_inst1_ERR_SOT_SYNC_HS_LAN0        (),
   .mipi_dphy_rx_inst1_ERR_SOT_SYNC_HS_LAN1        (),
   .mipi_dphy_rx_inst1_LP_CLK                      (),
   .mipi_dphy_rx_inst1_RX_ACTIVE_HS_LAN0           (),
   .mipi_dphy_rx_inst1_RX_ACTIVE_HS_LAN1           (),
   .mipi_dphy_rx_inst1_RX_CLK_ACTIVE_HS            (),
   .mipi_dphy_rx_inst1_ESC_LAN0_CLK                (),
   .mipi_dphy_rx_inst1_ESC_LAN1_CLK                (),
   .mipi_dphy_rx_inst1_RX_DATA_ESC                 (),
   .mipi_dphy_rx_inst1_RX_DATA_HS_LAN0             (),
   .mipi_dphy_rx_inst1_RX_DATA_HS_LAN1             (),
   .mipi_dphy_rx_inst1_RX_LPDT_ESC                 (),
   .mipi_dphy_rx_inst1_RX_SKEW_CAL_HS_LAN0         (),
   .mipi_dphy_rx_inst1_RX_SKEW_CAL_HS_LAN1         (),
   .mipi_dphy_rx_inst1_RX_SYNC_HS_LAN0             (),
   .mipi_dphy_rx_inst1_RX_SYNC_HS_LAN1             (),
   .mipi_dphy_rx_inst1_RX_TRIGGER_ESC              (),
   .mipi_dphy_rx_inst1_RX_ULPS_ACTIVE_CLK_NOT      (),
   .mipi_dphy_rx_inst1_RX_ULPS_ACTIVE_NOT_LAN0     (),
   .mipi_dphy_rx_inst1_RX_ULPS_ACTIVE_NOT_LAN1     (),
   .mipi_dphy_rx_inst1_RX_ULPS_CLK_NOT             (),
   .mipi_dphy_rx_inst1_RX_ULPS_ESC_LAN0            (),
   .mipi_dphy_rx_inst1_RX_ULPS_ESC_LAN1            (),
   .mipi_dphy_rx_inst1_RX_VALID_ESC                (),
   .mipi_dphy_rx_inst1_RX_VALID_HS_LAN0            (),
   .mipi_dphy_rx_inst1_RX_VALID_HS_LAN1            (),
   .mipi_dphy_rx_inst1_STOPSTATE_CLK               (),
   .mipi_dphy_rx_inst1_STOPSTATE_LAN0              (),
   .mipi_dphy_rx_inst1_STOPSTATE_LAN1              (),
*/
    // I2C Configuration for HDMI
   .i_hdmi_sda                       (),
   .o_hdmi_sda_oe                    (),
   .i_hdmi_scl                       (),
   .o_hdmi_scl_oe                    (),
    
    // HDMI YUV Output
   .hdmi_yuv_vs                      (),
   .hdmi_yuv_hs                      (),
   .hdmi_yuv_de                      (),
   .hdmi_yuv_data                    (),
    
    //LED, SW
   .o_led                            (),
   .i_sw                             (master_rstn),

   .jtag_inst1_TCK                   (jtag_inst1_TCK),
   .jtag_inst1_TDI                   (jtag_inst1_TDI),
   .jtag_inst1_TDO                   (jtag_inst1_TDO),
   .jtag_inst1_SEL                   (jtag_inst1_SEL),
   .jtag_inst1_CAPTURE               (jtag_inst1_CAPTURE),
   .jtag_inst1_SHIFT                 (jtag_inst1_SHIFT),
   .jtag_inst1_UPDATE                (jtag_inst1_UPDATE),
   .jtag_inst1_RESET                 (jtag_inst1_RESET)
);
endmodule
