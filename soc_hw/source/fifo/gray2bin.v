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

module gray2bin
#(parameter WIDTH=5)
(// outputs
 output wire [WIDTH-1:0] bin_o,
 // input
 input [WIDTH-1:0] gray_i);

//---------------------------------------------------------------------
// Recursive Module
// Description: reduction xor
generate
   if (WIDTH > 1) begin
      wire [1:0] bin_1;
      assign bin_1 = {gray_i[WIDTH-1], gray_i[WIDTH-1]^gray_i[WIDTH-2]};
      if (WIDTH == 2) begin
	 assign bin_o = bin_1;
      end
      else begin
	 assign bin_o[WIDTH-1] = bin_1[1];
	 gray2bin #(.WIDTH(WIDTH-1)) u_gray2bin (.bin_o(bin_o[WIDTH-2:0]), .gray_i({bin_1[0], gray_i[WIDTH-3:0]}));
      end
   end
   else /* if (WIDTH == 1) */
     assign bin_o = gray_i;
endgenerate
   
endmodule 
