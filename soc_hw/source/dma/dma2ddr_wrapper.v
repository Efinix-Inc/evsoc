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

`timescale 1ns/1ps

module dma2ddr_wrapper #(
   parameter DW = 256
) (
   input                dma_clk,
   input                dma_reset,

   //APB3 slave and interrupt
   input                ctrl_clk,
   input                ctrl_reset,
   input  [13:0]        ctrl_PADDR,
   input  [0:0]         ctrl_PSEL,
   input                ctrl_PENABLE,
   output               ctrl_PREADY,
   input                ctrl_PWRITE,
   input  [31:0]        ctrl_PWDATA,
   output [31:0]        ctrl_PRDATA,
   output               ctrl_PSLVERROR,
   output [3:0]         ctrl_interrupts,

   //DDR port
   output               io_ddr_arw_valid,
   input                io_ddr_arw_ready,
   output [31:0]        io_ddr_arw_payload_addr,
   output [7:0]         io_ddr_arw_payload_id,
   output [7:0]         io_ddr_arw_payload_len,
   output [2:0]         io_ddr_arw_payload_size,
   output [1:0]         io_ddr_arw_payload_burst,
   output [1:0]         io_ddr_arw_payload_lock,
   output               io_ddr_arw_payload_write,
   output [7:0]         io_ddr_w_payload_id,
   output               io_ddr_w_valid,
   input                io_ddr_w_ready,
   output [DW-1:0]      io_ddr_w_payload_data,
   output [(DW/8)-1:0]  io_ddr_w_payload_strb,
   output               io_ddr_w_payload_last,
   input                io_ddr_b_valid,
   output               io_ddr_b_ready,
   input  [7:0]         io_ddr_b_payload_id,
   input                io_ddr_r_valid,
   output               io_ddr_r_ready,
   input  [DW-1:0]      io_ddr_r_payload_data,
   input  [7:0]         io_ddr_r_payload_id,
   input  [1:0]         io_ddr_r_payload_resp,
   input                io_ddr_r_payload_last,

   //64-bit dma channel (S2MM - to DDR)
   input                dat64_i_ch0_clk,
   input                dat64_i_ch0_reset,   
   input                dat64_i_ch0_tvalid,
   output               dat64_i_ch0_tready,
   input  [63:0]        dat64_i_ch0_tdata,
   input  [7:0]         dat64_i_ch0_tkeep,
   input  [3:0]         dat64_i_ch0_tdest,
   input                dat64_i_ch0_tlast,
   output               dat64_i_ch0_descriptorUpdated,

   //64-bit dma channel (MM2S - from DDR)
   input                dat64_o_ch1_clk,
   input                dat64_o_ch1_reset,
   output               dat64_o_ch1_tvalid,
   input                dat64_o_ch1_tready,
   output [63:0]        dat64_o_ch1_tdata,
   output [7:0]         dat64_o_ch1_tkeep,
   output [3:0]         dat64_o_ch1_tdest,
   output               dat64_o_ch1_tlast,

   //32-bit dma channel (S2MM - to DDR)
   input                dat32_i_ch2_clk,
   input                dat32_i_ch2_reset,
   input                dat32_i_ch2_tvalid,
   output               dat32_i_ch2_tready,
   input  [31:0]        dat32_i_ch2_tdata,
   input  [3:0]         dat32_i_ch2_tkeep,
   input  [3:0]         dat32_i_ch2_tdest,
   input                dat32_i_ch2_tlast,
   output               dat32_i_ch2_descriptorUpdated,

   //32-bit dma channel (MM2S - from DDR)
   input                dat32_o_ch3_clk,
   input                dat32_o_ch3_reset,
   output               dat32_o_ch3_tvalid,
   input                dat32_o_ch3_tready,
   output [31:0]        dat32_o_ch3_tdata,
   output [3:0]         dat32_o_ch3_tkeep,
   output [3:0]         dat32_o_ch3_tdest,
   output               dat32_o_ch3_tlast
);

wire         read_arvalid;
wire         read_arready;
wire [31:0]  read_araddr;
wire [3:0]   read_arregion;
wire [7:0]   read_arlen;
wire [2:0]   read_arsize;
wire [1:0]   read_arburst;
wire [0:0]   read_arlock;
wire [3:0]   read_arcache;
wire [3:0]   read_arqos;
wire [2:0]   read_arprot;
wire         read_rvalid;
wire         read_rready;
wire [255:0] read_rdata;
wire [1:0]   read_rresp;
wire         read_rlast;
wire         write_awvalid;
wire         write_awready;
wire [31:0]  write_awaddr;
wire [3:0]   write_awregion;
wire [7:0]   write_awlen;
wire [2:0]   write_awsize;
wire [1:0]   write_awburst;
wire [0:0]   write_awlock;
wire [3:0]   write_awcache;
wire [3:0]   write_awqos;
wire [2:0]   write_awprot;
wire         write_wvalid;
wire         write_wready;
wire [255:0] write_wdata;
wire [31:0]  write_wstrb;
wire         write_wlast;
wire         write_bvalid;
wire         write_bready;
wire [1:0]   write_bresp;

//request state machine
localparam [1:0] REQ_IDLE   = 'h0,
                 REQ_PRE_WR = 'h1,
                 REQ_PRE_RD = 'h2,
                 REQ_DONE   = 'h3;


reg [1:0] req_st,
          req_nx;

wire    req_wr;
wire    req_rd;

always@ (posedge dma_clk or posedge dma_reset)
begin
   if(dma_reset)
      req_st <= REQ_IDLE;
   else
      req_st <= req_nx;
end 
//sm assignment
always @(*)
begin
   req_nx = req_st;
   case(req_st)
      REQ_IDLE:
      begin
         if(write_awvalid)
            req_nx = REQ_PRE_WR;
         else if (read_arvalid)
            req_nx = REQ_PRE_RD;
         else
            req_nx = REQ_IDLE;
      end
      REQ_PRE_WR:
      begin
         if(write_awready)
            req_nx = REQ_DONE;
         else
            req_nx = REQ_PRE_WR;
      end
      REQ_PRE_RD:
      begin
         if(read_arready)
            req_nx = REQ_DONE;
         else
            req_nx = REQ_PRE_RD;
      end
      REQ_DONE: req_nx = REQ_IDLE;
      default: req_nx = REQ_IDLE;
   endcase
end
   
assign req_wr = (req_st == REQ_PRE_WR);
assign req_rd = (req_st == REQ_PRE_RD);

assign io_ddr_arw_valid          = req_rd ? read_arvalid : 
                                   req_wr ? write_awvalid : 1'b0;

assign write_awready             = req_wr  ? io_ddr_arw_ready : 1'b0;
assign read_arready              = req_rd  ? io_ddr_arw_ready : 1'b0;

assign io_ddr_arw_payload_addr   = req_wr ? write_awaddr : 
                                   req_rd ? read_araddr : 'h0; 

assign io_ddr_arw_payload_id     = 'hE0;
assign io_ddr_arw_payload_len    = req_wr ? write_awlen : 
                                   req_rd ? read_arlen : 'h0;

assign io_ddr_arw_payload_size   = req_wr ? write_awsize : 
                                   req_rd ? read_arsize : 'h0;
assign io_ddr_arw_payload_burst  = req_wr ? write_awburst : 
                                   req_rd ? read_arburst : 'h0;
assign io_ddr_arw_payload_lock   = req_wr ? write_awlock :
                                   req_rd ? read_arlock : 'h0;
assign io_ddr_arw_payload_write  = req_wr ? write_awvalid : 1'b0;

assign io_ddr_w_payload_id       = 'hE1;
assign io_ddr_w_valid            = write_wvalid ;
assign write_wready              = io_ddr_w_ready;
assign io_ddr_w_payload_data     = write_wdata;
assign io_ddr_w_payload_strb     = write_wstrb;
assign io_ddr_w_payload_last     = write_wlast;

assign write_bvalid              = io_ddr_b_valid;
assign io_ddr_b_ready            = write_bready;
assign write_bresp               = 'h0;
assign read_rvalid               = io_ddr_r_valid; 
assign io_ddr_r_ready            = read_rready;
assign read_rdata                = io_ddr_r_payload_data;
assign read_rresp                = io_ddr_r_payload_resp; 
assign read_rlast                = io_ddr_r_payload_last;

//Make descriptorUpdate signals pulse longer (multiple clock cycles to facilitate CDC)
wire io_0_descriptorUpdate;
wire io_2_descriptorUpdate;

reg [2:0] io_0_descriptorUpdate_r;
reg [2:0] io_2_descriptorUpdate_r;

always@ (posedge dma_clk)
begin
   io_0_descriptorUpdate_r [0] <= io_0_descriptorUpdate;
   io_0_descriptorUpdate_r [1] <= io_0_descriptorUpdate_r [0];
   io_0_descriptorUpdate_r [2] <= io_0_descriptorUpdate_r [1];
   
   io_2_descriptorUpdate_r [0] <= io_2_descriptorUpdate;
   io_2_descriptorUpdate_r [1] <= io_2_descriptorUpdate_r [0];
   io_2_descriptorUpdate_r [2] <= io_2_descriptorUpdate_r [1];
end

assign dat64_i_ch0_descriptorUpdated = (|io_0_descriptorUpdate_r) || io_0_descriptorUpdate;
assign dat32_i_ch2_descriptorUpdated = (|io_2_descriptorUpdate_r) || io_2_descriptorUpdate;

dma_socRuby u_dma (
   .clk                    (dma_clk),
   .reset                  (dma_reset),
   .ctrl_clk               (ctrl_clk),
   .ctrl_reset             (ctrl_reset),
   .ctrl_PADDR             (ctrl_PADDR),
   .ctrl_PSEL              (ctrl_PSEL),
   .ctrl_PENABLE           (ctrl_PENABLE),
   .ctrl_PREADY            (ctrl_PREADY),
   .ctrl_PWRITE            (ctrl_PWRITE),
   .ctrl_PWDATA            (ctrl_PWDATA),
   .ctrl_PRDATA            (ctrl_PRDATA),
   .ctrl_PSLVERROR         (ctrl_PSLVERROR),
   .ctrl_interrupts        (ctrl_interrupts),
   .read_arvalid           (read_arvalid),
   .read_arready           (read_arready),
   .read_araddr            (read_araddr),
   .read_arregion          (read_arregion),
   .read_arlen             (read_arlen),
   .read_arsize            (read_arsize),
   .read_arburst           (read_arburst),
   .read_arlock            (read_arlock),
   .read_arcache           (read_arcache),
   .read_arqos             (read_arqos),
   .read_arprot            (read_arprot),
   .read_rvalid            (read_rvalid),
   .read_rready            (read_rready),
   .read_rdata             (read_rdata),
   .read_rresp             (read_rresp),
   .read_rlast             (read_rlast),
   .write_awvalid          (write_awvalid),
   .write_awready          (write_awready),
   .write_awaddr           (write_awaddr),
   .write_awregion         (write_awregion),
   .write_awlen            (write_awlen),
   .write_awsize           (write_awsize),
   .write_awburst          (write_awburst),
   .write_awlock           (write_awlock),
   .write_awcache          (write_awcache),
   .write_awqos            (write_awqos),
   .write_awprot           (write_awprot),
   .write_wvalid           (write_wvalid),
   .write_wready           (write_wready),
   .write_wdata            (write_wdata),
   .write_wstrb            (write_wstrb),
   .write_wlast            (write_wlast),
   .write_bvalid           (write_bvalid),
   .write_bready           (write_bready),
   .write_bresp            (write_bresp),
   .dat0_i_clk             (dat64_i_ch0_clk),
   .dat0_i_reset           (dat64_i_ch0_reset),   
   .dat0_i_tvalid          (dat64_i_ch0_tvalid),
   .dat0_i_tready          (dat64_i_ch0_tready),
   .dat0_i_tdata           (dat64_i_ch0_tdata),
   .dat0_i_tkeep           (dat64_i_ch0_tkeep),
   .dat0_i_tdest           (dat64_i_ch0_tdest),
   .dat0_i_tlast           (dat64_i_ch0_tlast),
   .io_0_descriptorUpdate  (io_0_descriptorUpdate),
   .dat0_o_clk             (dat64_o_ch1_clk),
   .dat0_o_reset           (dat64_o_ch1_reset),
   .dat0_o_tvalid          (dat64_o_ch1_tvalid),
   .dat0_o_tready          (dat64_o_ch1_tready),
   .dat0_o_tdata           (dat64_o_ch1_tdata),
   .dat0_o_tkeep           (dat64_o_ch1_tkeep),
   .dat0_o_tdest           (dat64_o_ch1_tdest),
   .dat0_o_tlast           (dat64_o_ch1_tlast),
   .io_1_descriptorUpdate  (),
   .dat1_i_clk             (dat32_i_ch2_clk),
   .dat1_i_reset           (dat32_i_ch2_reset),
   .dat1_i_tvalid          (dat32_i_ch2_tvalid),
   .dat1_i_tready          (dat32_i_ch2_tready),
   .dat1_i_tdata           (dat32_i_ch2_tdata),
   .dat1_i_tkeep           (dat32_i_ch2_tkeep),
   .dat1_i_tdest           (dat32_i_ch2_tdest),
   .dat1_i_tlast           (dat32_i_ch2_tlast),
   .io_2_descriptorUpdate  (io_2_descriptorUpdate),
   .dat1_o_clk             (dat32_o_ch3_clk),
   .dat1_o_reset           (dat32_o_ch3_reset),
   .dat1_o_tvalid          (dat32_o_ch3_tvalid),
   .dat1_o_tready          (dat32_o_ch3_tready),
   .dat1_o_tdata           (dat32_o_ch3_tdata),
   .dat1_o_tkeep           (dat32_o_ch3_tkeep),
   .dat1_o_tdest           (dat32_o_ch3_tdest),
   .dat1_o_tlast           (dat32_o_ch3_tlast),
   .io_3_descriptorUpdate  ()
);

endmodule
