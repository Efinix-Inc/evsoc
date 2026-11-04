//--------------------------------------------------------------------------
// https://www.efinixinc.com
// Copyright@2019. All rights reserved. Efinix, Inc.
//--------------------------------------------------------------------------
// Module : clock_gen
// Author : Bruce Chen
// Contact: brucec@efinixinc.com
// Version: V1.0
// Date   : Nov.18th.2019
//--------------------------------------------------------------------------
// Decription : clock generator for psram simulation
//--------------------------------------------------------------------------

`timescale 10ps/1ps

module clock_gen
#(
parameter FREQ_CLK_MHZ = 166
)
(
input	 rst			,
output reg clk_out0		,
output reg clk_out45	,
output reg clk_out90	,
output reg clk_out135	,
output reg locked
);

localparam CYCLE 	= 100000/FREQ_CLK_MHZ;
localparam PHASE45 	= CYCLE/8;
localparam PHASE90  = CYCLE/4;
localparam PHASE135	= (CYCLE/8)*3;


always @ ( * ) begin
	  if (rst)
      locked <= 1'b0;
      else
      #(10*CYCLE)
      locked <= 1'b1;
end

// clock 0
initial begin
   clk_out0 = 1'b0;
   wait(locked)
    #(100*CYCLE)
   forever #(CYCLE/2) clk_out0 = ~clk_out0;
end

initial begin
   clk_out45 = 1'b0;
   wait(locked)
   #(100*CYCLE)
   #PHASE45
   forever #(CYCLE/2) clk_out45 = ~clk_out45;
end

initial begin
   clk_out90 = 1'b0;
   wait(locked)
   #(100*CYCLE)
   #PHASE90
   forever #(CYCLE/2) clk_out90 = ~clk_out90;
end

initial begin
   clk_out135 = 1'b0;
   wait(locked)
   #(100*CYCLE)
   #PHASE135
   forever #(CYCLE/2) clk_out135 = ~clk_out135;
end

endmodule