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

module line_buffer2 #(
   parameter DATA_WIDTH  = 8,
   parameter LINE_WORDS  = 10
)(
   input  wire                  clk,
   input  wire                  rst,
   input  wire                  en,
   input  wire [DATA_WIDTH-1:0] din,
   output wire [DATA_WIDTH-1:0] dout_tap0,
   output wire [DATA_WIDTH-1:0] dout_tap1,
   output reg  [DATA_WIDTH-1:0] dout_tap2,
   //output wire                  dout_valid
   output wire                  dout_padded_valid
);

   localparam ADDR_WIDTH = $clog2 (LINE_WORDS);
   
   reg  [ADDR_WIDTH-1:0] addr;
   reg                   alternate;
   reg [ADDR_WIDTH+1:0]  latency_count;
   //reg                   latency_done;
   reg                   latency_padded_done;
   reg                   en_r;
   
   //assign dout_valid        = en_r && latency_done;
   assign dout_padded_valid = en_r && latency_padded_done;
   
   true_dual_port_ram2 #(
      .DATA_WIDTH    (DATA_WIDTH),
      .ADDR_WIDTH    (ADDR_WIDTH+1),
      .WRITE_MODE_1  ("READ_FIRST"),
      .WRITE_MODE_2  ("READ_FIRST"),
      .OUTPUT_REG_1  ("FALSE"),
      .OUTPUT_REG_2  ("FALSE"),
      .RAM_INIT_FILE ("")
   ) u_ram (
      .we1   (en),
      .clka  (clk),
      .din1  (din),
      .addr1 ({alternate, addr}),
      .dout1 (dout_tap0),

      .we2   (1'b0),
      .clkb  (clk),
      .din2  ({DATA_WIDTH{1'b0}}),
      .addr2 ({~alternate, addr}),
      .dout2 (dout_tap1)
   );
   
   always@(posedge clk or posedge rst)
   begin
      if (rst) begin
         dout_tap2           <= {DATA_WIDTH{1'b0}};
         addr                <= {ADDR_WIDTH{1'b0}};
         alternate           <= 1'b0;
         latency_count       <= {ADDR_WIDTH+2{1'b0}};
         //latency_done        <= 1'b0;
         latency_padded_done <= 1'b0;
         en_r                <= 1'b0;
      end else begin
         dout_tap2           <= din;
         addr                <= (en && (addr==LINE_WORDS-1)) ? {ADDR_WIDTH{1'b0}} :
                                (en)                         ? addr + {{ADDR_WIDTH-1{1'b0}}, 1'b1}
                                                             : addr;
         alternate           <= (en && (addr==LINE_WORDS-1)) ? ~alternate : alternate;
         latency_count       <= (en) ? latency_count + {{ADDR_WIDTH+1{1'b0}}, 1'b1} : latency_count;
         //latency_done        <= ((latency_count == (LINE_WORDS*2)) && en) ? 1'b1 : latency_done;        //LINE_COUNT*M where M =(kernel_height-1)/2 + 1;
         latency_padded_done <= ((latency_count == (LINE_WORDS*1)) && en) ? 1'b1 : latency_padded_done;   //LINE_COUNT*M where M =(kernel_height-1)/2;
         en_r                <= en;
      end
   end
  
endmodule
