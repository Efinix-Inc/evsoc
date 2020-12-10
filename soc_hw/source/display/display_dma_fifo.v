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

module display_dma_fifo #(
   parameter FIFO_DEPTH = 512
) (
   almost_full_o,
   full_o,
   overflow_o,
   datacount_o,
   empty_o,
   almost_empty_o,
   underflow_o,
   rd_valid_o,
   rdata,
   clk_i,
   wr_en_i,
   rd_en_i,
   a_rst_i,
   wdata
);

   localparam SYNC_CLK            = 1;
   localparam DEPTH               = FIFO_DEPTH;    //Must be power of 2
   localparam DATA_WIDTH          = 48;
   localparam MODE                = "STANDARD";
   localparam OUTPUT_REG          = 1;
   localparam PIPELINE_REG        = 0;
   localparam OPTIONAL_FLAGS      = 1;
   localparam PROGRAMMABLE_FULL   = "NONE";
   localparam PROG_FULL_ASSERT    = DEPTH;
   localparam PROG_FULL_NEGATE    = PROG_FULL_ASSERT;
   localparam PROGRAMMABLE_EMPTY  = "NONE";
   localparam PROG_EMPTY_ASSERT   = 0;
   localparam PROG_EMPTY_NEGATE   = PROG_EMPTY_ASSERT;

   localparam COUNT_BIT           = $clog2(DEPTH);

   output                  almost_full_o;
   output                  full_o;
   output                  overflow_o;
   output [COUNT_BIT-1:0]  datacount_o;
   output                  empty_o;
   output                  almost_empty_o;
   output                  underflow_o;
   output                  rd_valid_o;
   output [DATA_WIDTH-1:0] rdata;
   input                   clk_i;
   input                   wr_en_i;
   input                   rd_en_i;
   input                   a_rst_i;
   input  [DATA_WIDTH-1:0] wdata;

   efx_fifo_wrapper #(
      .SYNC_CLK           (SYNC_CLK          ),
      .DEPTH              (DEPTH             ),
      .DATA_WIDTH         (DATA_WIDTH        ),
      .MODE               (MODE              ),
      .OUTPUT_REG         (OUTPUT_REG        ),
      .PIPELINE_REG       (PIPELINE_REG      ),
      .OPTIONAL_FLAGS     (OPTIONAL_FLAGS    ),
      .PROGRAMMABLE_FULL  (PROGRAMMABLE_FULL ),
      .PROG_FULL_ASSERT   (PROG_FULL_ASSERT  ),
      .PROG_FULL_NEGATE   (PROG_FULL_NEGATE  ),
      .PROGRAMMABLE_EMPTY (PROGRAMMABLE_EMPTY),
      .PROG_EMPTY_ASSERT  (PROG_EMPTY_ASSERT ),
      .PROG_EMPTY_NEGATE  (PROG_EMPTY_NEGATE )
   ) efx_fifo_wrapper_u (
      .almost_full_o     (almost_full_o),
      .prog_full_o       (),
      .full_o            (full_o),
      .overflow_o        (overflow_o),
      .wr_ack_o          (),
      .datacount_o       (datacount_o),
      .wr_datacount_o    (),
      .empty_o           (empty_o),
      .almost_empty_o    (almost_empty_o),
      .prog_empty_o      (),
      .underflow_o       (underflow_o),
      .rd_valid_o        (rd_valid_o),
      .rdata             (rdata),
      .rd_datacount_o    (),
      .clk_i             (clk_i),
      .wr_clk_i          (1'b0),
      .rd_clk_i          (1'b0),
      .wr_en_i           (wr_en_i),
      .rd_en_i           (rd_en_i),
      .a_rst_i           (a_rst_i),
      .wdata             (wdata)
   );

endmodule
