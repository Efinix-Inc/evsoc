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

module hw_accel_dual_cam #(
   parameter DATA_WIDTH    = 8,
   parameter IMG_WIDTH     = 512,
   parameter IMG_HEIGHT    = 512
)(
   input  wire                   clk,
   input  wire                   rst,
   input  wire [1:0]             hw_accel_mode,
   input  wire                   hw_accel_mode2,
   input  wire [DATA_WIDTH-1:0]  sobel_thresh_val,
   input  wire                   pixel_in1_rready,
   output wire                   pixel_in1_req,
   input  wire [DATA_WIDTH-1:0]  pixel_in1,
   input  wire                   pixel_in1_valid,
   input  wire                   pixel_in2_rready,
   output wire                   pixel_in2_req,
   input  wire [DATA_WIDTH-1:0]  pixel_in2,
   input  wire                   pixel_in2_valid,
   input  wire                   pixel_out_wready,
   output reg  [DATA_WIDTH-1:0]  pixel_out,
   output reg                    pixel_out_valid,
   output wire                   dual_cam_scaling_fifo_underflow,
   output wire                   dual_cam_scaling_fifo_overflow,
   output wire                   dual_cam_scaling_fifo_we,
   output wire                   dual_cam_scaling_fifo_re
);

   localparam COUNT_X_BIT = $clog2(IMG_WIDTH);
   localparam COUNT_Y_BIT = $clog2(IMG_HEIGHT);

   /*******************************************************************IMAGE SCALING*******************************************************************/
   
   //Perform nearest neighbour downscaling on frame data from cam2
   
   reg  [COUNT_X_BIT:0]  scaling_x_pixel_count;
   reg  [COUNT_Y_BIT:0]  scaling_y_pixel_count;
   wire                  dual_cam_scaling_fifo_prog_full;
   wire                  dual_cam_scaling_fifo_empty;
   wire [DATA_WIDTH-1:0] dual_cam_scaling_fifo_wdata;
   wire [DATA_WIDTH-1:0] dual_cam_scaling_fifo_rdata;
   wire                  dual_cam_scaling_fifo_rvalid;
   wire                  pixel_in2_req_scaling;
   
   always@(posedge clk or posedge rst)
   begin
      //With assumption reset is triggered before start of new frame
      if (rst) begin
         scaling_x_pixel_count <= {COUNT_X_BIT{1'b0}};
         scaling_y_pixel_count <= {COUNT_Y_BIT{1'b0}};
      end else begin
         scaling_x_pixel_count <= (pixel_in2_valid && (scaling_x_pixel_count==IMG_WIDTH-1)) ? {COUNT_X_BIT{1'b0}}          :
                                  (pixel_in2_valid)                                         ? scaling_x_pixel_count + 1'b1 : scaling_x_pixel_count;
         scaling_y_pixel_count <= (pixel_in2_valid && (scaling_x_pixel_count==IMG_WIDTH-1)) ? scaling_y_pixel_count + 1'b1 : scaling_y_pixel_count;
      end
   end
   
   assign pixel_in2_req_scaling = pixel_in2_rready && (~dual_cam_scaling_fifo_prog_full);
   
   //Downscale by 4x (horizontal & vertical)
   assign dual_cam_scaling_fifo_we    = (hw_accel_mode2==1'b1) && pixel_in2_valid && (scaling_x_pixel_count[1:0] == 2'b10) && (scaling_y_pixel_count[1:0] == 2'b10);
   assign dual_cam_scaling_fifo_wdata = pixel_in2;

   hw_accel_dual_cam_fifo u_dual_cam_scaling_fifo (
      .almost_full_o    (),
      .prog_full_o      (dual_cam_scaling_fifo_prog_full),
      .full_o           (),
      .overflow_o       (dual_cam_scaling_fifo_overflow),
      .wr_ack_o         (),
      .empty_o          (dual_cam_scaling_fifo_empty),
      .almost_empty_o   (),
      .underflow_o      (dual_cam_scaling_fifo_underflow),
      .rd_valid_o       (dual_cam_scaling_fifo_rvalid),
      .rdata            (dual_cam_scaling_fifo_rdata),
      .clk_i            (clk),
      .wr_en_i          (dual_cam_scaling_fifo_we),
      .rd_en_i          (dual_cam_scaling_fifo_re),
      .a_rst_i          (rst),
      .wdata            (dual_cam_scaling_fifo_wdata),
      .datacount_o      (),
      .wr_datacount_o   (),
      .rd_datacount_o   ()
   );


   /****************************************************************IMAGE MERGER (STAGE1)****************************************************************/
    
   //For merging frame data from cam source 1 (main) and cam source 2 (downscaled overlay)
   
   //Downscale by 4x (horizontal & vertical)
   //Should match with nearest neighbour pixel skipping in IMAGE SCALING section.
   localparam SCALED_IMG_WIDTH      = (IMG_WIDTH/4);
   localparam SCALED_IMG_HEIGHT     = (IMG_HEIGHT/4);
   
   //Coordinates for inserting downscaled overlay from cam source 2
   //(X_OFFSET_INSERT_START + SCALED_IMG_WIDTH)  must be less than or equal to IMG_WIDTH
   //(Y_OFFSET_INSERT_START + SCALED_IMG_HEIGHT) must be less than or equal to IMG_HEIGHT
   localparam X_OFFSET_INSERT_START = IMG_WIDTH - SCALED_IMG_WIDTH - 50;
   localparam Y_OFFSET_INSERT_START = 50;
   localparam X_OFFSET_INSERT_END   = X_OFFSET_INSERT_START + SCALED_IMG_WIDTH;
   localparam Y_OFFSET_INSERT_END   = Y_OFFSET_INSERT_START + SCALED_IMG_HEIGHT;
   
   wire                   pixel_in1_req_scaling;
   reg  [COUNT_X_BIT:0]   st1_x_pixel_count;
   reg  [COUNT_X_BIT:0]   st1_x_pixel_count2;
   reg  [COUNT_Y_BIT:0]   st1_y_pixel_count;
   reg                    stl_overlay_insert_done;
   wire [DATA_WIDTH-1:0]  st1_merged_pixel;
   wire                   st1_merged_pixel_valid;
   wire                   stl_overlay_insert;
   
   always@(posedge clk or posedge rst)
   begin
      //With assumption reset is triggered before start of new frame
      if (rst) begin
         st1_x_pixel_count       <= {COUNT_X_BIT{1'b0}};
         st1_x_pixel_count2      <= {COUNT_X_BIT{1'b0}};
         st1_y_pixel_count       <= {COUNT_Y_BIT{1'b0}};
         stl_overlay_insert_done <= 1'b0;
      end else begin
         st1_x_pixel_count       <= (pixel_in1_req && (st1_x_pixel_count==IMG_WIDTH-1))    ? {COUNT_X_BIT{1'b0}}       :
                                    (pixel_in1_req)                                        ? st1_x_pixel_count + 1'b1  : st1_x_pixel_count;                             
         st1_x_pixel_count2      <= (pixel_in1_valid && (st1_x_pixel_count2==IMG_WIDTH-1)) ? {COUNT_X_BIT{1'b0}}       :
                                    (pixel_in1_valid)                                      ? st1_x_pixel_count2 + 1'b1 : st1_x_pixel_count2;
         st1_y_pixel_count       <= (pixel_in1_req && (st1_x_pixel_count==IMG_WIDTH-1))    ? st1_y_pixel_count + 1'b1  : st1_y_pixel_count;
         stl_overlay_insert_done <= (dual_cam_scaling_fifo_re && (st1_x_pixel_count == X_OFFSET_INSERT_END-1) && (st1_y_pixel_count == Y_OFFSET_INSERT_END-1)) ? 
                                    1'b1 : stl_overlay_insert_done;
      end
   end

   assign stl_overlay_insert       = (st1_x_pixel_count >= X_OFFSET_INSERT_START) && (st1_x_pixel_count < X_OFFSET_INSERT_END)
                                     && (st1_y_pixel_count >= Y_OFFSET_INSERT_START) && (st1_y_pixel_count < Y_OFFSET_INSERT_END);
   assign pixel_in1_req_scaling    = pixel_in1_rready && pixel_out_wready && ((~dual_cam_scaling_fifo_empty) || stl_overlay_insert_done);
   assign dual_cam_scaling_fifo_re = pixel_in1_rready && pixel_out_wready && (~dual_cam_scaling_fifo_empty)  && stl_overlay_insert;

   //Merging mode selection - hw_accel_mode2
   //0: Merge frame data from cam source 1 (cropped by half, left side) and cam source 2 (cropped by half, right side)
   //1: Merge frame data from cam source 1 (main) and cam source 2 (downscaled overlay)
   assign pixel_in1_req          = (hw_accel_mode2 == 1'b1) ? pixel_in1_req_scaling : pixel_in1_rready && pixel_in2_rready && pixel_out_wready;
   assign pixel_in2_req          = (hw_accel_mode2 == 1'b1) ? pixel_in2_req_scaling : pixel_in1_rready && pixel_in2_rready && pixel_out_wready;
   //With assumption, data and valid for both pixel_in1 and dual_cam_scaling_fifo are synced (read from STANDARD mode fifo)
   assign st1_merged_pixel_valid = pixel_in1_valid;
   assign st1_merged_pixel       = ((hw_accel_mode2 == 1'b1) && dual_cam_scaling_fifo_rvalid)          ? dual_cam_scaling_fifo_rdata :
                                   ((hw_accel_mode2 == 1'b0) && (st1_x_pixel_count2 >= (IMG_WIDTH/2))) ? pixel_in2                   : pixel_in1;
                                   

   /**************************************************************PROCESS MERGED FRAME DATA**************************************************************/
   
   //Sobel edge detection - Perform on grayscale image
   
   wire [7:0]            sobel_pixel_8bit_out;
   wire [DATA_WIDTH-1:0] sobel_pixel_out;
   wire                  sobel_pixel_out_valid;
   
   sobel_edge_detection 
   # (
      .DATA_WIDTH (8),
      .IMG_WIDTH  (IMG_WIDTH),
      .IMG_HEIGHT (IMG_HEIGHT)
   ) u_sobel (
      .clk               (clk),
      .rst               (rst),
      .sobel_thresh_val  (sobel_thresh_val[7:0]),
      .pixel_in          (st1_merged_pixel[7:0]),
      .pixel_in_valid    (st1_merged_pixel_valid),
      .pixel_out         (sobel_pixel_8bit_out),
      .pixel_out_valid   (sobel_pixel_out_valid)
   );
   
   //With assumption DATA_WIDTH is 24-bit
   assign sobel_pixel_out = {sobel_pixel_8bit_out,sobel_pixel_8bit_out,sobel_pixel_8bit_out};
 
 
   /************************************************************PASSTHROUGH MERGED FRAME DATA************************************************************/
   
   //Insert delay line buffer to retain stage1 merged frame data and ensure they are in synced with output from Sobel.
   
   localparam KERNEL_WIDTH  = 3;
   localparam KERNEL_HEIGHT = 3;
   
   integer x, y;
   
   reg  [DATA_WIDTH-1:0]  pixel_in_r;
   reg                    pixel_in_valid_r;
   reg                    skip1;  //To be revised for different kernel size
   reg  [DATA_WIDTH-1:0]  window_pixels [1:KERNEL_WIDTH][1:KERNEL_HEIGHT];
   reg                    window_pixels_valid;
   reg  [COUNT_X_BIT-1:0] x_count;
   reg  [COUNT_Y_BIT-1:0] y_count;
   
   wire [DATA_WIDTH-1:0]  dout_tap0;
   wire [DATA_WIDTH-1:0]  dout_tap1;
   wire [DATA_WIDTH-1:0]  dout_tap2;
   wire                   dout_valid;

   //Line buffer optimized for 3x3 windowing - Not parameterizable
   line_buffer2 
   # (
      .DATA_WIDTH   (DATA_WIDTH),
      .LINE_WORDS   (IMG_WIDTH)
   ) u_passthrough_line_buffer (
      .clk               (clk),
      .rst               (rst),
      .en                (pixel_in_valid_r),
      .din               (pixel_in_r),
      .dout_tap0         (dout_tap0),
      .dout_tap1         (dout_tap1),
      .dout_tap2         (dout_tap2),
      .dout_padded_valid (dout_valid)
   );

   //Organize pixels into 3x3 window & Generate relavant control/valid signals
   always@(posedge clk or posedge rst) 
   begin
      if (rst) begin
         pixel_in_r          <= {DATA_WIDTH{1'b0}};
         pixel_in_valid_r    <= 1'b0;
         skip1               <= 1'b0;
         window_pixels_valid <= 1'b0;
         x_count             <= {COUNT_X_BIT{1'b0}};
         y_count             <= {COUNT_Y_BIT{1'b0}};
         
         for (y=1; y<=KERNEL_HEIGHT; y=y+1) begin
            for (x=1; x<=KERNEL_WIDTH; x=x+1) begin
               window_pixels [x][y] <= {DATA_WIDTH{1'b0}};
            end
         end
      end else begin
         x=0;
         y=0;
         //Registered inputs
         pixel_in_r          <= st1_merged_pixel;
         pixel_in_valid_r    <= st1_merged_pixel_valid;
         skip1               <= (dout_valid) ? 1'b1 : skip1;
         window_pixels_valid <= dout_valid && skip1;
         
         //X-, Y- image windowing counters
         x_count             <= (window_pixels_valid && x_count==IMG_WIDTH-1)                          ? {COUNT_X_BIT{1'b0}} :
                                (window_pixels_valid)                                                  ? x_count + {{COUNT_X_BIT-1{1'b0}}, 1'b1} : x_count;
         y_count             <= (window_pixels_valid && x_count==IMG_WIDTH-1 && y_count==IMG_HEIGHT-1) ? {COUNT_Y_BIT{1'b0}} :
                                (window_pixels_valid && x_count==IMG_WIDTH-1)                          ? y_count + {{COUNT_Y_BIT-1{1'b0}}, 1'b1} : y_count;

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
   
   //Add in pipelined registers to sync with Sobel window computation
   reg [DATA_WIDTH-1:0] passthrough_pixel_pre1_out;
   reg                  passthrough_pixel_pre1_out_valid;
   reg [DATA_WIDTH-1:0] passthrough_pixel_pre2_out;
   reg                  passthrough_pixel_pre2_out_valid;
   reg [DATA_WIDTH-1:0] passthrough_pixel_out;
   reg                  passthrough_pixel_out_valid;
   
   always@(posedge clk or posedge rst) 
   begin
      if (rst) begin
         passthrough_pixel_pre1_out_valid <= 1'b0;
         passthrough_pixel_pre2_out_valid <= 1'b0;
         passthrough_pixel_out_valid      <= 1'b0;
         passthrough_pixel_pre1_out       <= {DATA_WIDTH{1'b0}};
         passthrough_pixel_pre2_out       <= {DATA_WIDTH{1'b0}};
         passthrough_pixel_out            <= {DATA_WIDTH{1'b0}};
      end else begin
         passthrough_pixel_pre1_out_valid <= window_pixels_valid;
         passthrough_pixel_pre2_out_valid <= passthrough_pixel_pre1_out_valid;
         passthrough_pixel_out_valid      <= passthrough_pixel_pre2_out_valid;
         passthrough_pixel_pre1_out       <= window_pixels [2][2];
         passthrough_pixel_pre2_out       <= passthrough_pixel_pre1_out;
         passthrough_pixel_out            <= passthrough_pixel_pre2_out;
      end
   end
   
   
   /****************************************************************IMAGE MERGER (STAGE2)****************************************************************/
     
   //Merge frame data (processed & passthrough) according to hw_accel_mode
   //With assumption, data and valid for both both Sobel and passthrough are synced
   reg  [COUNT_X_BIT:0]   st2_x_pixel_count;
   reg  [COUNT_Y_BIT:0]   st2_y_pixel_count;
   
   wire [DATA_WIDTH-1:0]  mode0_pixel_out;
   wire [DATA_WIDTH-1:0]  mode1_pixel_out_cropped;
   wire [DATA_WIDTH-1:0]  mode1_pixel_out_overlay;
   wire [DATA_WIDTH-1:0]  mode2_pixel_out_cropped;
   wire [DATA_WIDTH-1:0]  mode2_pixel_out_overlay;
   wire [DATA_WIDTH-1:0]  mode3_pixel_out;
   
   always@(posedge clk or posedge rst)
   begin
      //With assumption reset is triggered before start of new frame
      if (rst) begin
         st2_x_pixel_count <= {COUNT_X_BIT{1'b0}};
         st2_y_pixel_count <= {COUNT_Y_BIT{1'b0}};
      end else begin
         st2_x_pixel_count <= (passthrough_pixel_out_valid && (st2_x_pixel_count==IMG_WIDTH-1)) ? {COUNT_X_BIT{1'b0}}      :
                              (passthrough_pixel_out_valid)                                     ? st2_x_pixel_count + 1'b1 : st2_x_pixel_count;
         st2_y_pixel_count <= (passthrough_pixel_out_valid && (st2_x_pixel_count==IMG_WIDTH-1)) ? st2_y_pixel_count + 1'b1 : st2_y_pixel_count;
      end
   end
   
   //HW accel mode: Processing
   //Mode 0: Cam source 1 - Passthrough;       Cam source 2 - Passthrough
   assign mode0_pixel_out         = passthrough_pixel_out;
   //Mode 1: Cam source 1 - Passthrough;       Cam source 2 - Processed (Sobel)
   assign mode1_pixel_out_cropped = (st2_x_pixel_count < (IMG_WIDTH/2)) ? passthrough_pixel_out : sobel_pixel_out;
   assign mode1_pixel_out_overlay = (st2_x_pixel_count >= X_OFFSET_INSERT_START) && (st2_x_pixel_count < X_OFFSET_INSERT_END)
                                    && (st2_y_pixel_count >= Y_OFFSET_INSERT_START) && (st2_y_pixel_count < Y_OFFSET_INSERT_END) ? 
                                    sobel_pixel_out : passthrough_pixel_out;
   //Mode 2: Cam source 1 - Processed (Sobel); Cam source 2 - Passthrough
   assign mode2_pixel_out_cropped = (st2_x_pixel_count < (IMG_WIDTH/2)) ? sobel_pixel_out       : passthrough_pixel_out;
   assign mode2_pixel_out_overlay = (st2_x_pixel_count >= X_OFFSET_INSERT_START) && (st2_x_pixel_count < X_OFFSET_INSERT_END)
                                    && (st2_y_pixel_count >= Y_OFFSET_INSERT_START) && (st2_y_pixel_count < Y_OFFSET_INSERT_END) ? 
                                    passthrough_pixel_out : sobel_pixel_out;
   //Mode 3: Left half - Processed (Sobel); Right half - Processed (Sobel)
   assign mode3_pixel_out         = sobel_pixel_out;
   
   //Hardware acceletor mode selection
   always@(posedge clk or posedge rst)
   begin
      if (rst) begin
         pixel_out       <= {DATA_WIDTH{1'b0}};
         pixel_out_valid <= 1'b0;
      end else begin
         if (hw_accel_mode == 2'd0) begin
            pixel_out <= mode0_pixel_out;
         end else if (hw_accel_mode == 2'd1) begin
            pixel_out <= (hw_accel_mode2 == 1'b1) ? mode1_pixel_out_overlay : mode1_pixel_out_cropped;
         end else if (hw_accel_mode == 2'd2) begin
            pixel_out <= (hw_accel_mode2 == 1'b1) ? mode2_pixel_out_overlay : mode2_pixel_out_cropped;
         end else begin
            pixel_out <= mode3_pixel_out;
         end
         
         pixel_out_valid <= passthrough_pixel_out_valid;
      end
   end

endmodule
