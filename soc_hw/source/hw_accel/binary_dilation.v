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

module binary_dilation #(
   parameter DATA_WIDTH	   = 8,
   parameter IMG_WIDTH     = 10,
   parameter IMG_HEIGHT    = 4
)(
   input  wire                  clk,
   input  wire                  rst,
   input  wire [DATA_WIDTH-1:0] pixel_in,
   input  wire                  pixel_in_valid,
   output reg  [DATA_WIDTH-1:0] pixel_out,
   output reg                   pixel_out_valid
);
   localparam X_COUNT_BIT   = $clog2(IMG_WIDTH);
   localparam Y_COUNT_BIT   = $clog2(IMG_HEIGHT);
   localparam KERNEL_WIDTH  = 3;
   localparam KERNEL_HEIGHT = 3;
   
   integer x, y;
   
   reg  [DATA_WIDTH-1:0]  pixel_in_r;
   reg                    pixel_in_valid_r;
   reg                    skip1;  //To be revised for different kernel size
   reg  [DATA_WIDTH-1:0]  window_pixels [1:KERNEL_WIDTH][1:KERNEL_HEIGHT];
   reg                    window_pixels_valid;
   reg  [X_COUNT_BIT-1:0] x_count;
   reg  [Y_COUNT_BIT-1:0] y_count;
   
   wire [DATA_WIDTH-1:0]  dout_tap0;
   wire [DATA_WIDTH-1:0]  dout_tap1;
   wire [DATA_WIDTH-1:0]  dout_tap2;
   wire                   dout_valid;
   wire                   padding;

   //Line buffer optimized for 3x3 windowing - Not parameterizable
   line_buffer2 
   # (
      .DATA_WIDTH   (DATA_WIDTH),
      .LINE_WORDS   (IMG_WIDTH)
   ) u_line_buffer (
      .clk               (clk),
      .rst               (rst),
      .en                (pixel_in_valid_r),
      .din               (pixel_in_r),
      .dout_tap0         (dout_tap0),
      .dout_tap1         (dout_tap1),
      .dout_tap2         (dout_tap2),
      .dout_padded_valid (dout_valid)
   );

   //Orginize pixels into 3x3 window & Generate relavant control/valid signals
   always@(posedge clk or posedge rst) 
   begin
      if (rst) begin
         pixel_in_r          <= {DATA_WIDTH{1'b0}};
         pixel_in_valid_r    <= 1'b0;
         skip1               <= 1'b0;
         window_pixels_valid <= 1'b0;
         x_count             <= {X_COUNT_BIT{1'b0}};
         y_count             <= {Y_COUNT_BIT{1'b0}};
         
         for (y=1; y<=KERNEL_HEIGHT; y=y+1) begin
            for (x=1; x<=KERNEL_WIDTH; x=x+1) begin
               window_pixels [x][y] <= {DATA_WIDTH{1'b0}};
            end
         end
      end else begin
         x=0;
         y=0;
         //Registered inputs
         pixel_in_r          <= pixel_in;
         pixel_in_valid_r    <= pixel_in_valid;
         skip1               <= (dout_valid) ? 1'b1 : skip1;
         window_pixels_valid <= dout_valid && skip1;
         
         //X-, Y- image windowing counters
         x_count             <= (window_pixels_valid && x_count==IMG_WIDTH-1)                          ? {X_COUNT_BIT{1'b0}} :
                                (window_pixels_valid)                                                  ? x_count + {{X_COUNT_BIT-1{1'b0}}, 1'b1} : x_count;
         y_count             <= (window_pixels_valid && x_count==IMG_WIDTH-1 && y_count==IMG_HEIGHT-1) ? {Y_COUNT_BIT{1'b0}} :
                                (window_pixels_valid && x_count==IMG_WIDTH-1)                          ? y_count + {{Y_COUNT_BIT-1{1'b0}}, 1'b1} : y_count;

         //Form 3x3 window
         if (dout_valid) begin
            window_pixels [3][1] <= dout_tap0;
            window_pixels [3][2] <= dout_tap1;
            window_pixels [3][3] <= dout_tap2;
            
            window_pixels [2][1] <= window_pixels [3][1];
            window_pixels [2][2] <= window_pixels [3][2];
            window_pixels [2][3] <= window_pixels [3][3];
            
            window_pixels [1][1] <= window_pixels [2][1];
            window_pixels [1][2] <= window_pixels [2][2];
            window_pixels [1][3] <= window_pixels [2][3];
         end
      end
   end

   assign padding = (x_count=={X_COUNT_BIT{1'b0}}) || (y_count=={Y_COUNT_BIT{1'b0}}) || (x_count==IMG_WIDTH-1) || (y_count==IMG_HEIGHT-1);
   
   
   //Binary Dilation - Output pixel is 255 if one of window pixels are 255; otherwise output pixel is assigned to 0
   reg                   padding_r;
   reg                   window_pixels_valid_r;
   reg  [DATA_WIDTH-1:0] or_all_pixels;
   wire [DATA_WIDTH-1:0] dilate_out;
   
   always@(posedge clk or posedge rst) 
   begin
      if (rst) begin
         padding_r             <= 1'b0;
         window_pixels_valid_r <= 1'b0;
         or_all_pixels         <= {DATA_WIDTH{1'b0}};
         pixel_out             <= {DATA_WIDTH{1'b0}};
         pixel_out_valid       <= 1'b0;
      end else begin
         padding_r             <= padding;
         window_pixels_valid_r <= window_pixels_valid;
         or_all_pixels         <= window_pixels [1][1] | window_pixels [1][2] | window_pixels [1][3] | window_pixels [2][1] | window_pixels [2][2] | window_pixels [2][3] | window_pixels [3][1] | window_pixels [3][2] | window_pixels [3][3];
         //Set border pixels to zeros
         pixel_out             <= (padding_r) ? {DATA_WIDTH{1'b0}} : dilate_out;
         pixel_out_valid       <= window_pixels_valid_r;
      end
   end
   
   assign dilate_out = (or_all_pixels == {DATA_WIDTH{1'b0}}) ? {DATA_WIDTH{1'b0}} : {DATA_WIDTH{1'b1}};
  
endmodule
