////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2026 Efinix Inc. All rights reserved.
// See https://github.com/Efinix-Inc/evsoc/blob/main/LICENSE.txt for details.
////////////////////////////////////////////////////////////////////////////////

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