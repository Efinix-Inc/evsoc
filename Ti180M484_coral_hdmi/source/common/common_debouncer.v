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

/*
  Function:
  Module of the debouncer is implemented in Verilog to generate only a single pulse when pressing a button on FPGA.
  When a switch on FPGA is pressed and released, there are many unexpected up-and-down bounces in the push-button signal. 
  Therefore, Switch_debouncer is used to solve this issue by generating a single pulse with a period of the slow clock 
  without bouncing as we expected.

*/
module common_debouncer(
	input	               clk,
   input                rst_n,
   input                switch,
	output 	            q
);

	wire                 q0;
   wire                 q1;
   wire                 q2;
	reg[19:0]            counter;
   reg                  slowclk;
	integer 	   	      count = 1_000_000;
	
	always @ (posedge clk, negedge rst_n)
	begin
		if (~rst_n)
			counter <= 'd0;
		else
		begin
                counter <= counter + 'd1;
          if (counter >=count) //  500_000=>10ms to register switch
          begin
                counter<='d0;
          end
                slowclk<=(counter<count)?1'b1:1'b0;
      
		end	
	end
		
	dff1 u0	(.clk(slowclk), .d(switch),	.rst_n(rst_n),.q(q0));
	dff1 u1	(.clk(slowclk), .d(q0),		.rst_n(rst_n),.q(q1));
	dff1 u2	(.clk(clk),	.d(q1),		.rst_n(rst_n),.q(q2));
	assign q = ~q2 && q1; //posedge clock detector

endmodule

/*
  Functions:
  A simple D flip flop with negative asynchronous reset is implemented using Verilog. 
  It is used for switch debouncer. 
*/
//dflipflop for switch bouncer
module dff1(
    input         clk,
    input         d,
    input         rst_n,
    output reg	   q
);

	always @ (posedge clk, negedge rst_n)
	begin
		if (~rst_n)
			q <= 0;
		else
			q <= d;
	end
endmodule