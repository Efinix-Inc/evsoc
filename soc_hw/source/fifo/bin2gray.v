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

module bin2gray
#(parameter WIDTH=5)
(// outputs
 output reg [WIDTH-1:0] gray_o,
 // input
 input [WIDTH-1:0] bin_i,
 input clk_i);

//---------------------------------------------------------------------
// Function :   bit_xor
// Description: reduction xor
function bit_xor (
  input [31:0] nex_bit,
  input [31:0] curr_bit,
  input [WIDTH-1:0] xor_in);
  begin : fn_bit_xor
    bit_xor = xor_in[nex_bit] ^ xor_in[curr_bit];
  end
endfunction

   wire [WIDTH-1:0] gray_combi;
// Convert Binary to Gray, bit by bit
generate 
begin
  genvar bit_idx;
  for(bit_idx=0; bit_idx<WIDTH-1; bit_idx=bit_idx+1) begin : gBinBits
    assign gray_combi[bit_idx] = bit_xor(bit_idx+1, bit_idx, bin_i);
  end
  assign   gray_combi[WIDTH-1] = bin_i[WIDTH-1];
end
endgenerate

   always @(posedge clk_i)
     gray_o <= gray_combi;

endmodule
