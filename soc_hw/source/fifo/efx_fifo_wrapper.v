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

`resetall
`timescale 1ns/1ps

  module efx_fifo_wrapper(
			  //Output
			  almost_full_o,
			  prog_full_o,
			  full_o,
			  overflow_o,
			  wr_ack_o,
			  datacount_o,
			  wr_datacount_o,
			  empty_o,
			  almost_empty_o,
			  prog_empty_o,
			  underflow_o,
			  rd_valid_o,
			  rdata,
			  rd_datacount_o,
			  //Input
			  clk_i,
			  wr_clk_i,
			  rd_clk_i,
			  wr_en_i,
			  rd_en_i,
			  a_rst_i,
			  wdata);
//Parameter and localparam for ports declaration
   parameter SYNC_CLK	= 1;
   parameter DEPTH	= 512; //Must be power of 2
   parameter DATA_WIDTH	= 32;
   localparam WCNT_WIDTH	= depth2width(DEPTH); //Removed feature
   localparam RCNT_WIDTH	= depth2width(DEPTH); //Removed feature
   parameter MODE		= "STANDARD";
   parameter OUTPUT_REG		= 0;
   parameter PIPELINE_REG	= 1;
   parameter OPTIONAL_FLAGS	= 1;
   parameter PROGRAMMABLE_FULL	= "NONE";
   parameter PROG_FULL_ASSERT	= DEPTH;
   parameter PROG_FULL_NEGATE	= PROG_FULL_ASSERT;
   parameter PROGRAMMABLE_EMPTY	= "NONE";
   parameter PROG_EMPTY_ASSERT	= 0;
   parameter PROG_EMPTY_NEGATE	= PROG_EMPTY_ASSERT;

//Ports declaration
   //Output
   output wire 			almost_full_o;
   output wire 			prog_full_o;
   output wire 			full_o;
   output wire 			overflow_o;
   output wire 			wr_ack_o;
   output wire [WCNT_WIDTH-1:0] datacount_o;
   output wire [WCNT_WIDTH-1:0] wr_datacount_o;
   output wire 			empty_o;
   output wire 			almost_empty_o;
   output wire 			prog_empty_o;
   output wire 			underflow_o;
   output reg 			rd_valid_o;
   output wire [DATA_WIDTH-1:0] rdata;
   output wire [RCNT_WIDTH-1:0] rd_datacount_o;
   //Input
   input 			clk_i;
   input 			wr_clk_i;
   input 			rd_clk_i;
   input 			wr_en_i;
   input 			rd_en_i;
   input 			a_rst_i;
   input [DATA_WIDTH-1:0] 	wdata;

//--------------------------------------------------------------------
// Local Function
`include "efx_fifo_functions.vh"

//--------------------------------------------------------------------
// Masked Signals/Parameters
   //Start: Asymmetrical Width parameter calculation and signal assignment
   //Minimum RDATA_WIDTH stops at odd number
   localparam WR_DEPTH = DEPTH;         //Removed Asym Feature
   localparam WDATA_WIDTH = DATA_WIDTH; //Removed Asym Feature
   localparam RDATA_WIDTH = DATA_WIDTH; //Removed Asym Feature
   localparam RDATA_WIDTH_MIN	= (WDATA_WIDTH % 2) ? (WDATA_WIDTH) :
				  (WDATA_WIDTH % 4) ? (WDATA_WIDTH / 2) :
				  (WDATA_WIDTH % 8) ? (WDATA_WIDTH / 4) :
				                      (WDATA_WIDTH / 8);
   //Maximum RDATA_WIDTH depends on WR_DEPTH, minimum WR_DEPTH=16
   localparam RDATA_WIDTH_MAX	= ((WR_DEPTH < 32)  || (WR_DEPTH % 2)) ? (WDATA_WIDTH) :
				  ((WR_DEPTH < 64)  || (WR_DEPTH % 4)) ? (WDATA_WIDTH * 2) :
				  ((WR_DEPTH < 128) || (WR_DEPTH % 8)) ? (WDATA_WIDTH * 4) :
				                                         (WDATA_WIDTH * 8);
   //Filter input RDATA_WIDTH to fit 8:1, 4:1, 2:1, 1:1, 1:2, 1:4, 1:8 W/R ratio
   //Smaller input RDATA_WIDTH will match to larger effective width, max 8*WDATA_WIDTH
   localparam RDATA_WIDTH_EFF	= (RDATA_WIDTH <= RDATA_WIDTH_MIN) ? RDATA_WIDTH_MIN :
				  (RDATA_WIDTH >  RDATA_WIDTH_MAX) ? RDATA_WIDTH_MAX :
				  (RDATA_WIDTH <= WDATA_WIDTH/4) ? WDATA_WIDTH/4 :
				  (RDATA_WIDTH <= WDATA_WIDTH/2) ? WDATA_WIDTH/2 :
				  (RDATA_WIDTH <= WDATA_WIDTH)   ? WDATA_WIDTH :
				  (RDATA_WIDTH <= WDATA_WIDTH*2) ? WDATA_WIDTH*2 :
				  (RDATA_WIDTH <= WDATA_WIDTH*4) ? WDATA_WIDTH*4 :
				                                   WDATA_WIDTH*8;
   localparam WADDR_WIDTH	= depth2width(WR_DEPTH);
   localparam ASYM_WIDTH	= (WDATA_WIDTH !== RDATA_WIDTH_EFF);
   localparam RD_DEPTH		= WR_DEPTH * WDATA_WIDTH / RDATA_WIDTH_EFF;
   localparam RADDR_WIDTH	= depth2width(RD_DEPTH);
   //localparam DATA_WIDTH_RATIO;

   wire [WADDR_WIDTH-1:0] wr_adr_o;
   wire [RADDR_WIDTH-1:0] rd_adr_o;
   wire 		  rd_ram, wr_ram;
   wire [RDATA_WIDTH_EFF-1:0] rdata_int; //Internal rdata
   //If RDATA_WIDTH is configured correctly, rdata should take the correct value
   //If not, either MSB of rdata_int is masked, or MSB of rdata is unassigned
   assign rdata = rdata_int;
   //End: Asymmetrical Width parameter calculation and signal assignment

   wire rd_valid_int; //Internal rd_valid
generate
   if (OUTPUT_REG == 1)
     if (SYNC_CLK == 0)
       always @(posedge rd_clk_i)
	 rd_valid_o <= rd_valid_int;
     else /* (SYNC_CLK == 1) */
       always @(posedge clk_i)
	 rd_valid_o <= rd_valid_int;
   else /* (OUTPUT_REG == 0) */
     always @(*)
       rd_valid_o = rd_valid_int;
endgenerate

   //Start: datacount_o signal assignment
   //If user input width < log2(fifo_depth)-1, LSB will be truncated
   //Internal datacounts
   wire [WADDR_WIDTH-1:0] datacount_int;
   wire [WADDR_WIDTH-1:0] wr_datacount_int;
   wire [RADDR_WIDTH-1:0] rd_datacount_int;

generate
   if (WCNT_WIDTH < WADDR_WIDTH) begin
      assign datacount_o = datacount_int[WADDR_WIDTH:WADDR_WIDTH-WCNT_WIDTH];
      assign wr_datacount_o = wr_datacount_int[WADDR_WIDTH:WADDR_WIDTH-WCNT_WIDTH];
   end
   else begin
      assign datacount_o = datacount_int;
      assign wr_datacount_o = wr_datacount_int;
   end

   if (RCNT_WIDTH < RADDR_WIDTH) begin
      assign rd_datacount_o = rd_datacount_int[RADDR_WIDTH:RADDR_WIDTH-RCNT_WIDTH];
   end
   else begin
      assign rd_datacount_o = rd_datacount_int;
   end
endgenerate
   //End: Datacount_o signal assignment

//--------------------------------------------------------------------
// Module Instantiation
// Read/Write Domain State Machine and Flags
generate begin : fifo_ctl
   if (SYNC_CLK == 1)
   efx_syncfifo_ctl #(
		      // Parameters
		      .SYNC_CLK		  (SYNC_CLK),
		      .WR_DEPTH		  (WR_DEPTH),
		      .RD_DEPTH		  (RD_DEPTH),
		      .WADDR_WIDTH	  (WADDR_WIDTH),
		      .RADDR_WIDTH	  (RADDR_WIDTH),
		      .ASYM_WIDTH	  (ASYM_WIDTH),
		      .MODE		  (MODE),
		      .OPTIONAL_FLAGS	  (OPTIONAL_FLAGS),
		      .PROGRAMMABLE_FULL  (PROGRAMMABLE_FULL),
		      .PROG_FULL_ASSERT	  (PROG_FULL_ASSERT),
		      .PROG_FULL_NEGATE   (PROG_FULL_NEGATE),
		      .PROGRAMMABLE_EMPTY (PROGRAMMABLE_EMPTY),
		      .PROG_EMPTY_ASSERT  (PROG_EMPTY_ASSERT),
		      .PROG_EMPTY_NEGATE  (PROG_EMPTY_NEGATE))
   u_efx_syncfifo_ctl (
		       // Outputs
		       .empty_o		(empty_o),
		       .almost_empty_o	(almost_empty_o),
		       .prog_empty_o	(prog_empty_o),
		       .underflow_o	(underflow_o),
		       .full_o		(full_o),
		       .almost_full_o	(almost_full_o),
		       .prog_full_o	(prog_full_o),
		       .overflow_o	(overflow_o),
		       .wr_adr_o	(wr_adr_o),
		       .rd_adr_o	(rd_adr_o),
		       .wr_ack_o	(wr_ack_o),
		       .wr_ram	        (wr_ram),
		       .rd_valid_o	(rd_valid_int),
		       .rd_ram	        (rd_ram),
		       .datacount_o	(datacount_int),
		       // Inputs
		       .clk_i		(clk_i),
		       .a_rst_i		(a_rst_i),
		       .wr_en_i		(wr_en_i),
		       .rd_en_i		(rd_en_i));
   else /* (SYNC_CLK == 0) */
   efx_asyncfifo_ctl #(
		       // Parameters
		       .SYNC_CLK	   (SYNC_CLK),
		       .WR_DEPTH	   (WR_DEPTH),
		       .RD_DEPTH	   (RD_DEPTH),
		       .WADDR_WIDTH	   (WADDR_WIDTH),
		       .RADDR_WIDTH	   (RADDR_WIDTH),
		       .ASYM_WIDTH	   (ASYM_WIDTH),
		       .MODE		   (MODE),
		       .PIPELINE_REG	   (PIPELINE_REG),
		       .OPTIONAL_FLAGS	   (OPTIONAL_FLAGS),
		       .PROGRAMMABLE_FULL  (PROGRAMMABLE_FULL),
		       .PROG_FULL_ASSERT   (PROG_FULL_ASSERT),
		       .PROG_FULL_NEGATE   (PROG_FULL_NEGATE),
		       .PROGRAMMABLE_EMPTY (PROGRAMMABLE_EMPTY),
		       .PROG_EMPTY_ASSERT  (PROG_EMPTY_ASSERT),
		       .PROG_EMPTY_NEGATE  (PROG_EMPTY_NEGATE))
   u_efx_asyncfifo_ctl (
			// Outputs
			.wr_almost_full_o  (almost_full_o),
			.wr_prog_full_o	   (prog_full_o),
			.wr_full_o	   (full_o),
			.overflow_o	   (overflow_o),
			.wr_adr_o	   (wr_adr_o),
			.wr_ack_o	   (wr_ack_o),
			.wr_ram		   (wr_ram),
			.wr_datacount_o	   (wr_datacount_int),
			.rd_empty_o	   (empty_o),
			.rd_almost_empty_o (almost_empty_o),
			.rd_prog_empty_o   (prog_empty_o),
			.underflow_o	   (underflow_o),
			.rd_adr_o	   (rd_adr_o),
			.rd_valid_o	   (rd_valid_int),
			.rd_ram		   (rd_ram),
			.rd_datacount_o	   (rd_datacount_int),
			// Inputs
			.wr_clk_i	   (wr_clk_i),
			.wr_en_i	   (wr_en_i),
			.rd_clk_i	   (rd_clk_i),
			.rd_en_i	   (rd_en_i),
			.a_rst_i	   (a_rst_i));
end
endgenerate

// RAM instantiation
generate begin : ram
   if (SYNC_CLK == 1)
   simple_dual_port_ram_fifo
     #( // Parameters
	.SYNC_CLK	(SYNC_CLK),
	.WR_DEPTH	(WR_DEPTH),
	.RD_DEPTH	(RD_DEPTH),
   	.WDATA_WIDTH	(WDATA_WIDTH),
   	.RDATA_WIDTH	(RDATA_WIDTH_EFF),
   	.WADDR_WIDTH	(WADDR_WIDTH),
   	.RADDR_WIDTH	(RADDR_WIDTH),
   	.OUTPUT_REG	(OUTPUT_REG),
	.ASYM_WIDTH	(ASYM_WIDTH),
   	.MODE		(MODE))
   u_simple_dual_port_ram_fifo
     ( // Outputs
       .rdata		(rdata_int),
       // Inputs
       .wdata		(wdata),
       .waddr		(wr_adr_o),
       .raddr		(rd_adr_o),
       .we		(wr_ram),
       .re		(rd_ram),
       .clk		(clk_i),
       .wclk		(1'b0),
       .rclk		(1'b0));

   else /* (SYNC_CLK == 0) */
   simple_dual_port_ram_fifo
     #( // Parameters
	.SYNC_CLK	(SYNC_CLK),
	.WR_DEPTH	(WR_DEPTH),
	.RD_DEPTH	(RD_DEPTH),
   	.WDATA_WIDTH	(WDATA_WIDTH),
   	.RDATA_WIDTH	(RDATA_WIDTH_EFF),
   	.WADDR_WIDTH	(WADDR_WIDTH),
   	.RADDR_WIDTH	(RADDR_WIDTH),
   	.OUTPUT_REG	(OUTPUT_REG),
	.ASYM_WIDTH	(ASYM_WIDTH),
   	.MODE		(MODE))
   u_simple_dual_port_ram_fifo
     ( // Outputs
       .rdata		(rdata_int),
       // Inputs
       .wdata		(wdata),
       .waddr		(wr_adr_o),
       .raddr		(rd_adr_o),
       .we		(wr_ram),
       .re		(rd_ram),
       .clk		(1'b0),
       .wclk		(wr_clk_i),
       .rclk		(rd_clk_i));
end
endgenerate
   
endmodule   
