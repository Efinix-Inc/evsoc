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
`timescale 1ns / 1ps

module ddr_reset_sequencer (

input ddr_rstn_i,				// main user DDR reset, active low
input clk,						// user clock

/* Connect these three signals to DDR reset interface */
output ddr_rstn,				// Master Reset
output ddr_cfg_seq_rst,			// Sequencer Reset
output reg ddr_cfg_seq_start,	// Sequencer Start

/* optional status monitor for user logic */
output reg ddr_init_done		// Done status

);

parameter FREQ = 100;			// default is 100 MHz.  Redefine as needed.


localparam CNT_INIT = 1.5*FREQ*1000;

reg [1:0] rstn_dly;
always @(posedge clk or negedge ddr_rstn_i) begin
	if (!ddr_rstn_i) begin
		rstn_dly <= 3'd0;
	end else begin
		rstn_dly[0] <= 1'b1;
		rstn_dly[1] <= rstn_dly[0];
	end
end

assign ddr_rstn = ddr_rstn_i;

assign ddr_cfg_seq_rst = ~rstn_dly[1];

reg [19:0] cnt;
reg [1:0] cnt_start;

always @(posedge clk or negedge ddr_rstn_i) begin
	if (!ddr_rstn_i) begin
		ddr_init_done <= 1'b0;
		cnt <= CNT_INIT;
	end else begin
		if (cnt != 20'd0) begin
		cnt <= cnt - 20'd1;
		end else begin
		cnt <= cnt;
		ddr_init_done <= 1'b1;
		end
	end
end


always @(posedge clk or negedge rstn_dly[1]) begin
	if (!rstn_dly[1]) begin
		ddr_cfg_seq_start <= 1'b0;
		cnt_start <= 2'd0;
	end else begin
		if (cnt_start == 2'b11) begin
		ddr_cfg_seq_start <= 1'b1;
		cnt_start <= cnt_start;
		end else begin
		cnt_start <= cnt_start + 1'b1;
		end
	end

end


endmodule
