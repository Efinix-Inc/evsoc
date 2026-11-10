///////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2014-2021 Alex Forencich
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
///////////////////////////////////////////////////////////////////////////////////
//
// MODIFIED: outstanding-read limiter (MAX_OUTSTANDING_RD).
//
// Why
// ---
// The read-data path through this module is a pure wire: s_axi_rvalid/rdata/
// rlast/rid are driven straight from io_ddr_r_valid/_payload_data/_last/_id.
// This module therefore forwards, unaltered, whatever the DDR3 controller
// emits -- including the beat count and the ID.
//
// The original request state machine forwards each AR or AW onto the shared
// address channel and returns immediately to REQ_IDLE. It never tracks
// completion, so an unbounded number of reads can be in flight at once.
//
// Measured failure (Ti125F225, DDR3L x16 soft controller, eCNN master):
// with four reads outstanding across two IDs and two lengths --
//     ID 4 len 127 (2048 B) x3  and  ID 0 len 0 (16 B) x1
// -- the last three responses came back MERGED into a single 257-beat run
// (128 + 128 + 1) tagged RID = 0, with RLAST never asserted on any of them.
// The master could retire none of the three and deadlocked permanently.
// With two or fewer reads outstanding the same traffic completes cleanly.
//
// What this adds
// --------------
// A counter that holds off s_axi_arready once MAX_OUTSTANDING_RD read bursts
// are in flight, releasing as each RLAST is consumed. Writes are untouched
// and still arbitrate normally, so there is no deadlock: while reads are
// held off the FSM simply stays in REQ_IDLE for reads and continues to
// service AW through REQ_PRE_WR.
//
// Set MAX_OUTSTANDING_RD = 1 to serialise reads completely (the safe value,
// and the one that reproduces/repairs the bug above). Raising it to 2 or 3
// recovers read throughput if the downstream limit turns out to be higher;
// the failure was first seen at 4.
//
// Cost at 1: the address phase of the next read no longer overlaps the data
// phase of the current one. For 128-beat bursts that is roughly 30% of read
// bandwidth.
//
// NOTE, not fixed here: io_ddr_w_valid is driven directly from s_axi_wvalid,
// so write data is forwarded whether or not its AW has been pushed through
// the FSM yet. That is a separate latent hazard and is left as-is so this
// change stays minimal and reviewable.
///////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns / 1 ns
module axi_full_to_half_duplex #(
   parameter DATA_WIDTH           = 32,
   parameter ADDR_WIDTH           = 32,
   parameter ID_WIDTH             = 8,
   // Maximum read bursts in flight towards the DDR controller. 1 = fully
   // serialised. 0 is illegal.
   parameter MAX_OUTSTANDING_RD   = 1
)(
   input                         clk,
   input                         rst,
   //AXI Master Interface (half duplex) - DDR Memory
   output                        io_ddr_arw_valid,
   input                         io_ddr_arw_ready,
   output [ADDR_WIDTH-1:0]       io_ddr_arw_payload_addr,
   output [ID_WIDTH-1:0]         io_ddr_arw_payload_id,
   output [7:0]                  io_ddr_arw_payload_len,
   output [2:0]                  io_ddr_arw_payload_size,
   output [1:0]                  io_ddr_arw_payload_burst,
   output [1:0]                  io_ddr_arw_payload_lock,
   output                        io_ddr_arw_payload_write,
   output [ID_WIDTH-1:0]         io_ddr_w_payload_id,
   output                        io_ddr_w_valid,
   input                         io_ddr_w_ready,
   output [DATA_WIDTH-1:0]       io_ddr_w_payload_data,
   output [(DATA_WIDTH/8)-1:0]   io_ddr_w_payload_strb,
   output                        io_ddr_w_payload_last,
   input                         io_ddr_b_valid,
   output                        io_ddr_b_ready,
   input  [ID_WIDTH-1:0]         io_ddr_b_payload_id,
   input                         io_ddr_r_valid,
   output                        io_ddr_r_ready,
   input  [DATA_WIDTH-1:0]       io_ddr_r_payload_data,
   input  [ID_WIDTH-1:0]         io_ddr_r_payload_id,
   input  [1:0]                  io_ddr_r_payload_resp,
   input                         io_ddr_r_payload_last,

   //AXI Slave Bus Interface (full duplex)
   input   [ID_WIDTH-1:0]        s_axi_awid,
   input   [ADDR_WIDTH-1:0]      s_axi_awaddr,
   input   [7:0]                 s_axi_awlen,
   input   [2:0]                 s_axi_awsize,
   input   [1:0]                 s_axi_awburst,
   input                         s_axi_awlock,
   input   [3:0]                 s_axi_awcache,
   input   [2:0]                 s_axi_awprot,
   input   [3:0]                 s_axi_awqos,
   input   [3:0]                 s_axi_awregion,
   input                         s_axi_awvalid,
   output                        s_axi_awready,
   input   [DATA_WIDTH-1:0]      s_axi_wdata,
   input   [(DATA_WIDTH/8)-1:0]  s_axi_wstrb,
   input                         s_axi_wlast,
   input                         s_axi_wvalid,
   output                        s_axi_wready,
   output  [ID_WIDTH-1:0]        s_axi_bid,
   output  [1:0]                 s_axi_bresp,
   output                        s_axi_bvalid,
   input                         s_axi_bready,
   input   [ID_WIDTH-1:0]        s_axi_arid,
   input   [ADDR_WIDTH-1:0]      s_axi_araddr,
   input   [7:0]                 s_axi_arlen,
   input   [2:0]                 s_axi_arsize,
   input   [1:0]                 s_axi_arburst,
   input                         s_axi_arlock,
   input   [3:0]                 s_axi_arcache,
   input   [2:0]                 s_axi_arprot,
   input   [3:0]                 s_axi_arqos,
   input   [3:0]                 s_axi_arregion,
   input                         s_axi_arvalid,
   output                        s_axi_arready,
   output  [ID_WIDTH-1:0]        s_axi_rid,
   output  [DATA_WIDTH-1:0]      s_axi_rdata,
   output  [1:0]                 s_axi_rresp,
   output                        s_axi_rlast,
   output                        s_axi_rvalid,
   input                         s_axi_rready
);

//request state machine
localparam [1:0]  REQ_IDLE   = 'h0,
                  REQ_PRE_WR = 'h1,
                  REQ_PRE_RD = 'h2,
                  REQ_DONE   = 'h3;

// Width of the outstanding-read counter: enough to hold MAX_OUTSTANDING_RD.
localparam RD_CNT_W = (MAX_OUTSTANDING_RD <   2) ? 1 :
                      (MAX_OUTSTANDING_RD <   4) ? 2 :
                      (MAX_OUTSTANDING_RD <   8) ? 3 :
                      (MAX_OUTSTANDING_RD <  16) ? 4 :
                      (MAX_OUTSTANDING_RD <  32) ? 5 :
                      (MAX_OUTSTANDING_RD <  64) ? 6 :
                      (MAX_OUTSTANDING_RD < 128) ? 7 : 8;

reg [1:0]   req_st;
reg [1:0]   req_nx;
wire        req_wr;
wire        req_rd;

//---------------------------------------------------------------------------
// Outstanding-read tracking
//---------------------------------------------------------------------------
reg  [RD_CNT_W:0] rd_outstanding;   // one spare bit, cannot wrap
wire              rd_issue;         // an AR was accepted from the master
wire              rd_retire;        // an RLAST beat was consumed by the master
wire              rd_allow;         // room for another read burst

assign rd_issue  = s_axi_arvalid && s_axi_arready;
assign rd_retire = s_axi_rvalid  && s_axi_rready && s_axi_rlast;
assign rd_allow  = (rd_outstanding < MAX_OUTSTANDING_RD[RD_CNT_W:0]);

always @(posedge clk or posedge rst)
begin
   if(rst)
      rd_outstanding <= 'h0;
   else if(rd_issue && !rd_retire)
      rd_outstanding <= rd_outstanding + 1'b1;
   else if(!rd_issue && rd_retire)
      rd_outstanding <= rd_outstanding - 1'b1;
   // issue and retire in the same cycle: count unchanged
end

always@ (posedge clk or posedge rst)
begin
   if(rst)
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
      if(s_axi_awvalid)
         req_nx = REQ_PRE_WR;
      else if (s_axi_arvalid && rd_allow)
         req_nx = REQ_PRE_RD;
      else
         req_nx = REQ_IDLE;
   end
   REQ_PRE_WR:
   begin
      if(s_axi_awready)
         req_nx = REQ_DONE;
      else
         req_nx = REQ_PRE_WR;
   end
   REQ_PRE_RD:
   begin
      if(s_axi_arready)
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

assign s_axi_awready             = req_wr ? io_ddr_arw_ready : 1'b0;
// rd_allow is re-checked here as well as at the REQ_IDLE transition, so a
// burst can never slip through if the count moves while the FSM is in
// REQ_PRE_RD. It cannot deadlock: the count only ever grows on an accepted
// AR, which rd_allow itself gates.
assign s_axi_arready             = (req_rd && rd_allow) ? io_ddr_arw_ready : 1'b0;
assign io_ddr_arw_valid          = req_rd ? (s_axi_arvalid && rd_allow) :
                                   req_wr ?  s_axi_awvalid              : 1'b0;
assign io_ddr_arw_payload_addr   = req_wr ? s_axi_awaddr     : 
                                   req_rd ? s_axi_araddr     : 'h0;
assign io_ddr_arw_payload_id     = req_wr ? s_axi_awid       : 
                                   req_rd ? s_axi_arid       : 'h0;
assign io_ddr_arw_payload_len    = req_wr ? s_axi_awlen      : 
                                   req_rd ? s_axi_arlen      : 'h0;
assign io_ddr_arw_payload_size   = req_wr ? s_axi_awsize     : 
                                   req_rd ? s_axi_arsize     : 'h0;
assign io_ddr_arw_payload_burst  = req_wr ? s_axi_awburst    : 
                                   req_rd ? s_axi_arburst    : 'h0;
assign io_ddr_arw_payload_lock   = req_wr ? s_axi_awlock     :
                                   req_rd ? s_axi_arlock     : 'h0;
assign io_ddr_arw_payload_write  = req_wr ? s_axi_awvalid    : 1'b0;


assign io_ddr_w_payload_id       = 'h0; //Can be ignored
assign io_ddr_w_valid            = s_axi_wvalid ;
assign s_axi_wready              = io_ddr_w_ready;
assign io_ddr_w_payload_data     = s_axi_wdata;
assign io_ddr_w_payload_strb     = s_axi_wstrb;
assign io_ddr_w_payload_last     = s_axi_wlast;
assign s_axi_bvalid              = io_ddr_b_valid;
assign io_ddr_b_ready            = s_axi_bready;
assign s_axi_bresp               = 'h0;
assign s_axi_bid                 = io_ddr_b_payload_id;
assign s_axi_rvalid              = io_ddr_r_valid; 
assign io_ddr_r_ready            = s_axi_rready;
assign s_axi_rdata               = io_ddr_r_payload_data;
assign s_axi_rresp               = io_ddr_r_payload_resp; 
assign s_axi_rlast               = io_ddr_r_payload_last;
assign s_axi_rid                 = io_ddr_r_payload_id;

endmodule