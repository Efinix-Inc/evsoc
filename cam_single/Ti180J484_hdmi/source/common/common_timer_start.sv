////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2026 Efinix Inc. All rights reserved.
// See https://github.com/Efinix-Inc/evsoc/blob/main/LICENSE.txt for details.
////////////////////////////////////////////////////////////////////////////////

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
