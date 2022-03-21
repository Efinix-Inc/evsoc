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

module bilinear 
#(
   parameter   P_DEPTH     = 10,
   parameter   SHIFT_BITS  = 10
)
(
   input                   p_clk,
   input                   rstn,
      
   input                   in_en,
   input [P_DEPTH-1:0]     in_a0,
   input [P_DEPTH-1:0]     in_a1,
   input [P_DEPTH-1:0]     in_b0,
   input [P_DEPTH-1:0]     in_b1,
   
   input [SHIFT_BITS-1:0]  in_dx,
   input [SHIFT_BITS-1:0]  in_dy,
   
   output                  out_en,
   output [P_DEPTH-1:0]    out_c
);

/*///////////////////////////////////////////////////////
  
                      a0              a1 
                        ----         o   ----
    a0 | a1       |\                    | dy
   ---- ----  ----  \                    |
    b0 | b1   ----  /               c  o
   ---- ----      |/            ----
                         dx  
                           o----o
                         b0             b1 
                        ----           ----
   
*////////////////////////////////////////////////////////

reg [P_DEPTH-1:0] r_a0_1P;
reg [P_DEPTH-1:0] r_a1_1P;
reg [P_DEPTH-1:0] r_b0_1P;
reg [P_DEPTH-1:0] r_b1_1P;
reg [31:0]        r_dx_1P;
reg [31:0]        r_dy_1P;
reg [31:0]        r_1_dx_1P;
reg [31:0]        r_1_dy_1P;
reg               r_a_en_1P;
reg               r_a_en_2P;
reg [31:0]        r_dy_2P;
reg [31:0]        r_1_dy_2P;
reg [31:0]        r_sum_a0_2P;
reg [31:0]        r_sum_a1_2P;
reg [31:0]        r_sum_b0_2P;
reg [31:0]        r_sum_b1_2P;
reg               r_a_en_3P;
reg [31:0]        r_dy_3P;
reg [31:0]        r_1_dy_3P;
reg [31:0]        r_sum_a_3P;
reg [31:0]        r_sum_b_3P;
reg               r_a_en_4P;
reg [31:0]        r_sum_a_4P;
reg [31:0]        r_sum_b_4P;
reg               r_a_en_5P;
reg [31:0]        r_sum_5P;

//Main states
localparam
   SCALE = 32'd1 << SHIFT_BITS;

/* step 1 */
always @(posedge p_clk)
begin
    if (~rstn) 
   begin
      r_dx_1P     <= 32'b0;
      r_dy_1P     <= 32'b0;
      r_1_dx_1P   <= 32'b0;
      r_1_dy_1P   <= 32'b0;
      r_a0_1P     <= {P_DEPTH{1'b0}};
      r_a1_1P     <= {P_DEPTH{1'b0}};
      r_b0_1P     <= {P_DEPTH{1'b0}};
      r_b1_1P     <= {P_DEPTH{1'b0}};
      r_a_en_1P   <= 1'b0;    
   end
   else
   begin
      r_dx_1P     <= in_dx;
      r_dy_1P     <= in_dy;
      r_1_dx_1P   <= SCALE - in_dx;
      r_1_dy_1P   <= SCALE - in_dy;
      r_a0_1P     <= in_a0;
      r_a1_1P     <= in_a1;
      r_b0_1P     <= in_b0;
      r_b1_1P     <= in_b1;    
      r_a_en_1P   <= in_en;
   end
end

/* step 2 */
always @(posedge p_clk)
begin
    if (~rstn) 
   begin
      r_a_en_2P   <= 1'b0;
      r_dy_2P     <= 32'b0;
      r_1_dy_2P   <= 32'b0;
      r_sum_a0_2P <= 32'b0;
      r_sum_a1_2P <= 32'b0;
      r_sum_b0_2P <= 32'b0;
      r_sum_b1_2P <= 32'b0;
   end
   else
   begin
      r_a_en_2P   <= r_a_en_1P;
      r_dy_2P     <= r_dy_1P;
      r_1_dy_2P   <= r_1_dy_1P;
      r_sum_a0_2P <= r_a0_1P*r_1_dx_1P;
      r_sum_a1_2P <= r_a1_1P*r_dx_1P;
      r_sum_b0_2P <= r_b0_1P*r_1_dx_1P;
      r_sum_b1_2P <= r_b1_1P*r_dx_1P;
   end
end

/* step 3 */
always @(posedge p_clk)
begin
    if (~rstn) 
   begin
      r_a_en_3P   <= 1'b0;
      r_dy_3P     <= 32'b0;
      r_1_dy_3P   <= 32'b0;
      r_sum_a_3P  <= 32'b0;
      r_sum_b_3P  <= 32'b0;
   end
   else
   begin
      r_a_en_3P   <= r_a_en_2P;
      r_dy_3P     <= r_dy_2P;
      r_1_dy_3P   <= r_1_dy_2P;
      r_sum_a_3P  <= r_sum_a0_2P + r_sum_a1_2P;
      r_sum_b_3P  <= r_sum_b0_2P + r_sum_b1_2P;
   end
end
      
/* step 4 */
always @(posedge p_clk)
begin
    if (~rstn) 
   begin
      r_a_en_4P  <= 1'b0;
      r_sum_a_4P <= 32'b0;
      r_sum_b_4P <= 32'b0;
   end
   else
   begin
      r_a_en_4P   <= r_a_en_3P;
      r_sum_a_4P  <= r_sum_a_3P[31:(SHIFT_BITS-1)]*r_1_dy_3P;
      r_sum_b_4P  <= r_sum_b_3P[31:(SHIFT_BITS-1)]*r_dy_3P;
   end
end
   
/* step 5 */
always @(posedge p_clk)
begin
    if (~rstn) 
   begin
        r_a_en_5P <= 1'b0;
        r_sum_5P  <= 32'b0;
   end
   else
   begin
        r_a_en_5P <= r_a_en_4P;
        r_sum_5P  <= r_sum_a_4P + r_sum_b_4P;
   end
end

assign out_c   = r_sum_5P[(SHIFT_BITS+P_DEPTH):(SHIFT_BITS+1)];
assign out_en  = r_a_en_5P;

endmodule
