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

module simple_dual_port_ram_fifo
  #(
    parameter SYNC_CLK		= 1,
    parameter WR_DEPTH		= 512,
    parameter RD_DEPTH		= 512,
    parameter WDATA_WIDTH	= 8,
    parameter RDATA_WIDTH	= 8,
    parameter WADDR_WIDTH	= 9,
    parameter RADDR_WIDTH	= 9,
    parameter OUTPUT_REG	= 1,
    parameter ASYM_WIDTH	= 0,
    parameter MODE		= "STANDARD"
    )
   (
    input [(WDATA_WIDTH-1):0]  wdata,
    input [(WADDR_WIDTH-1):0]  waddr,
    input [(RADDR_WIDTH-1):0]  raddr,
    input 		       we, re, clk, wclk, rclk,
    output [(RDATA_WIDTH-1):0] rdata
    );

   //Depth and data width is inversely proportional
   localparam MEM_DEPTH = (WR_DEPTH > RD_DEPTH) ? WR_DEPTH : RD_DEPTH;
   localparam MEM_DATA_WIDTH = (WDATA_WIDTH > RDATA_WIDTH) ? RDATA_WIDTH : WDATA_WIDTH;

   reg [MEM_DATA_WIDTH-1:0]        ram[MEM_DEPTH-1:0];

   reg [RDATA_WIDTH-1:0]       r_rdata_1P;

generate
   if (ASYM_WIDTH == 0) begin
      if (SYNC_CLK == 1) begin
	 always @ (posedge clk) begin
	    if (we)
	      ram[waddr] <= wdata;
	    if (re)
	      r_rdata_1P <= ram[raddr];
	 end
      end
      else /* (SYNC_CLK == 0) */ begin
	 always @ (posedge wclk)
	   if (we)
	     ram[waddr] <= wdata;

	 always @ (posedge rclk) begin
	    if (re)
	      r_rdata_1P <= ram[raddr];
	 end
      end
   end
   else /* (ASYM_WIDTH == 1) */ begin //Sync FIFO only
      if (WDATA_WIDTH == RDATA_WIDTH*2) begin
	 always @ (posedge clk) begin : wrwidth_gt_rdwidth
	    integer i;
	    reg     lsbaddr;
	    for (i=0; i<2; i=i+1) begin // : write1
	       lsbaddr = i;
	       if (we) begin
	   	  //ram[{waddr,lsbaddr}] <= wdata[((i+1)*WDATA_WIDTH/2)-1 -: WDATA_WIDTH/2]; //Little Endian
	   	  ram[{waddr,lsbaddr}] <= wdata[(WDATA_WIDTH/(i+1))-1 -: WDATA_WIDTH/2]; //Big Endian
	       end
	    end
	    if (re)
	      r_rdata_1P <= ram[raddr];
	 end
      end
      else if (WDATA_WIDTH == RDATA_WIDTH/2) begin
	 always @ (posedge clk) begin : wrwidth_lt_rdwidth
	    integer i;
	    reg     lsbaddr;
	    if (we)
	      ram[waddr] <= wdata;
	    for (i=0; i<2; i=i+1) begin
	       lsbaddr = i;
	       if (re) begin
		  //r_rdata_1P[((i+1)*RDATA_WIDTH/2)-1 -: RDATA_WIDTH/2] <= ram[{raddr,lsbaddr}]; //Little Endian
		  r_rdata_1P[(RDATA_WIDTH/(i+1))-1 -: RDATA_WIDTH/2] <= ram[{raddr,lsbaddr}]; //Big Endian
	       end
	    end
	 end
      end
   end
endgenerate

generate
   if (OUTPUT_REG == 1) begin
      reg [RDATA_WIDTH-1:0] r_rdata_2P;
      if (SYNC_CLK == 1)
	always @(posedge clk)
	  r_rdata_2P <= r_rdata_1P;
      else /* (SYNC_CLK == 0) */
	always @(posedge rclk)
	  r_rdata_2P <= r_rdata_1P;
      assign rdata = r_rdata_2P;
   end
   else /* (OUTPUT_REG == 0) */
     assign rdata = r_rdata_1P;
endgenerate

endmodule
