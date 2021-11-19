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

module hw_accel #(
   parameter DATA_WIDTH    = 8,
   parameter IMG_WIDTH     = 512,
   parameter IMG_HEIGHT    = 512
)(
   input  wire                  clk,
   input  wire                  rst,
   input  wire [1:0]            hw_accel_mode,
   input  wire [DATA_WIDTH-1:0] sobel_thresh_val,
   input  wire [DATA_WIDTH-1:0] pixel_in,
   input  wire                  pixel_in_valid,
   output reg  [DATA_WIDTH-1:0] pixel_out,
   output reg                   pixel_out_valid
);

   wire [DATA_WIDTH-1:0] sobel_pixel_out;
   wire                  sobel_pixel_out_valid;
   wire [DATA_WIDTH-1:0] erosion_pixel_out;
   wire                  erosion_pixel_out_valid;
   wire [DATA_WIDTH-1:0] dilation_pixel_out;
   wire                  dilation_pixel_out_valid;

   sobel_edge_detection 
   # (
      .DATA_WIDTH (DATA_WIDTH),
      .IMG_WIDTH  (IMG_WIDTH),
      .IMG_HEIGHT (IMG_HEIGHT)
   ) u_sobel (
      .clk               (clk),
      .rst               (rst),
      .sobel_thresh_val  (sobel_thresh_val),
      .pixel_in          (pixel_in),
      .pixel_in_valid    (pixel_in_valid),
      .pixel_out         (sobel_pixel_out),
      .pixel_out_valid   (sobel_pixel_out_valid)
   );
   
   binary_dilation 
   # (
      .DATA_WIDTH (DATA_WIDTH),
      .IMG_WIDTH  (IMG_WIDTH),
      .IMG_HEIGHT (IMG_HEIGHT)
   ) u_dilation (
      .clk               (clk),
      .rst               (rst),
      .pixel_in          (sobel_pixel_out),
      .pixel_in_valid    (sobel_pixel_out_valid),
      .pixel_out         (dilation_pixel_out),
      .pixel_out_valid   (dilation_pixel_out_valid)
   );
   
   binary_erosion 
   # (
      .DATA_WIDTH (DATA_WIDTH),
      .IMG_WIDTH  (IMG_WIDTH),
      .IMG_HEIGHT (IMG_HEIGHT)
   ) u_erosion (
      .clk               (clk),
      .rst               (rst),
      .pixel_in          (sobel_pixel_out),
      .pixel_in_valid    (sobel_pixel_out_valid),
      .pixel_out         (erosion_pixel_out),
      .pixel_out_valid   (erosion_pixel_out_valid)
   );

   //2'd0: Sobel only; 2'd1: Sobel+Dilation; Otherwise: Sobel+Erosion
   always@(posedge clk or posedge rst)
   begin
      if (rst) begin
         pixel_out       <= {DATA_WIDTH{1'b0}};
         pixel_out_valid <= 1'b0;
      end else begin
         pixel_out       <= (hw_accel_mode == 2'd0) ? sobel_pixel_out          : 
                            (hw_accel_mode == 2'd1) ? dilation_pixel_out       : erosion_pixel_out;
         pixel_out_valid <= (hw_accel_mode == 2'd0) ? sobel_pixel_out_valid    : 
                            (hw_accel_mode == 2'd1) ? dilation_pixel_out_valid : erosion_pixel_out_valid;
      end
   end

endmodule
