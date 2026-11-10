////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2026 Efinix Inc. All rights reserved.
// See https://github.com/Efinix-Inc/evsoc/blob/main/LICENSE.txt for details.
////////////////////////////////////////////////////////////////////////////////

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

   hw_accel_sobel_edge_detection 
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
   
   hw_accel_binary_dilation 
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
   
   hw_accel_binary_erosion 
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
