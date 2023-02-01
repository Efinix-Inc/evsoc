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
module common_timer_start #(
	parameter MHZ	 = 50,
	parameter SECOND = 3,
    parameter PULSE  = 0
) (
	input		clk,
	input		rst_n,
	output 		start
); 

reg [35:0]	delay_cnt;
wire		second_tick;
reg [4:0]	second_cnt;
reg [3:0]   pulse_reg;
wire        start_reg;

///////////////////////////////////////////////////////////////////////////////

`ifndef EFX_SIM
localparam tick_cnt = (MHZ * 1000000) >> 1;
`else
localparam tick_cnt = MHZ * 200;
`endif

	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
		delay_cnt <= 'd0;
	else
	begin
		if(delay_cnt == tick_cnt || start_reg == 1'b1)
			delay_cnt <= 'd0;
		else
			delay_cnt <= delay_cnt + 1'b1;
	end
	end

	assign second_tick = ((delay_cnt) == (tick_cnt - 1)); 

	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
		second_cnt <= 'd0;
	else
	begin
		if(second_tick)
			second_cnt <= second_cnt + 1'b1;
		else
			second_cnt <= second_cnt;
	end
	end

	assign start_reg = (second_cnt == SECOND);
    
    always@(posedge clk)
    begin
        pulse_reg <= {pulse_reg[2:0],start_reg};
    end

generate
if(PULSE == 1)
    assign start = ~pulse_reg[3] & start_reg;
else
    assign start = start_reg;
endgenerate

endmodule
