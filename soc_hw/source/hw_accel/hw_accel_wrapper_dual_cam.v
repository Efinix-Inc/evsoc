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

module hw_accel_wrapper_dual_cam
#(
   parameter AXI_ADDR_WIDTH         = 32,
   parameter DATA_WIDTH	            = 32,  //For DMA and AXI
   parameter FRAME_WIDTH            = 640,
   parameter FRAME_HEIGHT           = 480,
   parameter DMA_TRANSFER_LENGTH    = 1920
) (
   input  wire                      clk,
   input  wire                      rst,
   input  wire                      axi_slave_clk,
   input  wire                      axi_slave_rst,
   
   //AXI-related signals
   input  wire                      axi_slave_we,
   input  wire [AXI_ADDR_WIDTH-1:0] axi_slave_waddr,
   input  wire [DATA_WIDTH-1:0]     axi_slave_wdata,
   input  wire                      axi_slave_re,
   input  wire [AXI_ADDR_WIDTH-1:0] axi_slave_raddr,
   output reg  [DATA_WIDTH-1:0]     axi_slave_rdata,
   output reg                       axi_slave_rvalid,
   
   //DMA-related signals
   output reg                       dma1_rready,
   input  wire                      dma1_rvalid,
   input  wire [(DATA_WIDTH/8)-1:0] dma1_rkeep,
   input  wire [DATA_WIDTH-1:0]     dma1_rdata,
   output reg                       dma2_rready,
   input  wire                      dma2_rvalid,
   input  wire [(DATA_WIDTH/8)-1:0] dma2_rkeep,
   input  wire [DATA_WIDTH-1:0]     dma2_rdata,
   input  wire                      dma_wready,
   output wire                      dma_wvalid,
   output wire                      dma_wlast,
   output wire [DATA_WIDTH-1:0]     dma_wdata,
   input  wire                      dma_descriptorUpdated
);

   localparam DMA_WR_WORDS_COUNT_BIT = $clog2(DMA_TRANSFER_LENGTH);
   localparam INT_DATA_WIDTH         = 24;   //HW accelerator takes in RGB888 image data (24-bit width)
   localparam SOBEL_THRESH           = 100;

   reg                               axi_slave_re_r;
   wire                              axi_slave_re_pulse;
   reg                               rst_after_each_frame;
   wire                              rst_hw_accel;
   reg  [DMA_WR_WORDS_COUNT_BIT-1:0] dma_wr_words_count;
   reg                               dma_write;
   
   reg  [INT_DATA_WIDTH-1:0]         sobel_thresh_val;
   reg  [INT_DATA_WIDTH-1:0]         sobel_thresh_val_r;
   reg  [INT_DATA_WIDTH-1:0]         sobel_thresh_val_synced;
   reg  [1:0]                        hw_accel_mode;
   reg  [1:0]                        hw_accel_mode_r;
   reg  [1:0]                        hw_accel_mode_synced;
   reg                               hw_accel_mode2;
   reg                               hw_accel_mode2_r;
   reg                               hw_accel_mode2_synced;
   reg                               hw_accel_dma_init_done;
   reg                               hw_accel_dma_init_done_r1;
   reg                               hw_accel_dma_init_done_r2;
   reg                               hw_accel_dma_init_done_r3;
   
   reg                               debug_dma1_in_fifo_underflow;
   reg                               debug_dma1_in_fifo_overflow;
   reg  [31:0]                       debug_dma1_in_fifo_wcount;
   reg                               debug_dma2_in_fifo_underflow;
   reg                               debug_dma2_in_fifo_overflow;
   reg  [31:0]                       debug_dma2_in_fifo_wcount;
   reg                               debug_dma_out_fifo_underflow;
   reg                               debug_dma_out_fifo_overflow;
   reg  [31:0]                       debug_dma_out_fifo_rcount;
   reg                               debug_dual_cam_scaling_fifo_underflow;
   reg                               debug_dual_cam_scaling_fifo_overflow;
   wire [5:0]                        debug_hw_accel_fifo_status;
   
   wire                              dma1_in_fifo_underflow;
   wire                              dma1_in_fifo_overflow;
   wire                              dma1_in_fifo_prog_full;
   wire                              dma1_in_fifo_empty;
   reg                               dma1_in_fifo_we;
   reg  [INT_DATA_WIDTH-1:0]         dma1_in_fifo_wdata;
   wire                              dma1_in_fifo_re;
   wire [INT_DATA_WIDTH-1:0]         dma1_in_fifo_rdata;
   wire                              dma1_in_fifo_rvalid;
   
   wire                              dma2_in_fifo_underflow;
   wire                              dma2_in_fifo_overflow;
   wire                              dma2_in_fifo_prog_full;
   wire                              dma2_in_fifo_empty;
   reg                               dma2_in_fifo_we;
   reg  [INT_DATA_WIDTH-1:0]         dma2_in_fifo_wdata;
   wire                              dma2_in_fifo_re;
   wire [INT_DATA_WIDTH-1:0]         dma2_in_fifo_rdata;
   wire                              dma2_in_fifo_rvalid;
   
   wire                              dma_out_fifo_underflow;
   wire                              dma_out_fifo_overflow;
   wire                              dma_out_fifo_prog_full;
   wire                              dma_out_fifo_empty;
   wire                              dma_out_fifo_we;
   wire [INT_DATA_WIDTH-1:0]         dma_out_fifo_wdata;
   wire                              dma_out_fifo_re;
   wire [INT_DATA_WIDTH-1:0]         dma_out_fifo_rdata;
   wire                              dma_out_fifo_rvalid;
   
   wire                              dual_cam_scaling_fifo_underflow;
   wire                              dual_cam_scaling_fifo_overflow;
   wire                              dual_cam_scaling_fifo_we;
   wire                              dual_cam_scaling_fifo_re;
   reg  [31:0]                       debug_dual_cam_scaling_fifo_wcount;
   reg  [31:0]                       debug_dual_cam_scaling_fifo_rcount;
   
   assign axi_slave_re_pulse         = ~axi_slave_re_r && axi_slave_re; //Detect rising edge. Observed input axi_slave_re might be asserted more than 1 clock cycle
   assign rst_hw_accel               = rst || rst_after_each_frame;     //Reset after every output frame.
   
   assign debug_hw_accel_fifo_status = {debug_dma1_in_fifo_underflow, debug_dma1_in_fifo_overflow, debug_dma2_in_fifo_underflow, debug_dma2_in_fifo_overflow, 
                                        debug_dma_out_fifo_underflow, debug_dma_out_fifo_overflow, debug_dual_cam_scaling_fifo_underflow, debug_dual_cam_scaling_fifo_overflow};
   
   //Debug registers
   always@(posedge clk or posedge rst) 
   begin
      if (rst) begin
         debug_dma1_in_fifo_underflow          <= 1'b0;
         debug_dma1_in_fifo_overflow           <= 1'b0;
         debug_dma1_in_fifo_wcount             <= 32'd0;
         debug_dma2_in_fifo_underflow          <= 1'b0;
         debug_dma2_in_fifo_overflow           <= 1'b0;
         debug_dma2_in_fifo_wcount             <= 32'd0;
         debug_dma_out_fifo_underflow          <= 1'b0;
         debug_dma_out_fifo_overflow           <= 1'b0;
         debug_dma_out_fifo_rcount             <= 32'd0;
         debug_dual_cam_scaling_fifo_underflow <= 1'b0;
         debug_dual_cam_scaling_fifo_overflow  <= 1'b0;
         debug_dual_cam_scaling_fifo_wcount    <= 32'd0;
         debug_dual_cam_scaling_fifo_rcount    <= 32'd0;
      end else begin
         debug_dma1_in_fifo_underflow          <= (dma1_in_fifo_underflow)          ? 1'b1 : debug_dma1_in_fifo_underflow;
         debug_dma1_in_fifo_overflow           <= (dma1_in_fifo_overflow)           ? 1'b1 : debug_dma1_in_fifo_overflow;
         debug_dma1_in_fifo_wcount             <= (dma1_in_fifo_we)                 ? debug_dma1_in_fifo_wcount + 1'b1 : debug_dma1_in_fifo_wcount;
         
         debug_dma2_in_fifo_underflow          <= (dma2_in_fifo_underflow)          ? 1'b1 : debug_dma2_in_fifo_underflow;
         debug_dma2_in_fifo_overflow           <= (dma2_in_fifo_overflow)           ? 1'b1 : debug_dma2_in_fifo_overflow;
         debug_dma2_in_fifo_wcount             <= (dma2_in_fifo_we)                 ? debug_dma2_in_fifo_wcount + 1'b1 : debug_dma2_in_fifo_wcount;
         
         debug_dma_out_fifo_underflow          <= (dma_out_fifo_underflow)          ? 1'b1 : debug_dma_out_fifo_underflow;
         debug_dma_out_fifo_overflow           <= (dma_out_fifo_overflow)           ? 1'b1 : debug_dma_out_fifo_overflow;
         debug_dma_out_fifo_rcount             <= (dma_out_fifo_re)                 ? debug_dma_out_fifo_rcount + 1'b1 : debug_dma_out_fifo_rcount;
         
         debug_dual_cam_scaling_fifo_underflow <= (dual_cam_scaling_fifo_underflow) ? 1'b1 : debug_dual_cam_scaling_fifo_underflow;
         debug_dual_cam_scaling_fifo_overflow  <= (dual_cam_scaling_fifo_overflow)  ? 1'b1 : debug_dual_cam_scaling_fifo_overflow;
         debug_dual_cam_scaling_fifo_wcount    <= (dual_cam_scaling_fifo_we)        ? debug_dual_cam_scaling_fifo_wcount + 1'b1 : debug_dual_cam_scaling_fifo_wcount;
         debug_dual_cam_scaling_fifo_rcount    <= (dual_cam_scaling_fifo_re)        ? debug_dual_cam_scaling_fifo_rcount + 1'b1 : debug_dual_cam_scaling_fifo_rcount;
      end
   end
   
   //AXI slave read/write from/to HW accelerator
   always@(posedge axi_slave_clk or posedge axi_slave_rst) 
   begin
      if (axi_slave_rst) begin
         axi_slave_re_r         <= 1'b0;
         axi_slave_rvalid       <= 1'b0;
         axi_slave_rdata        <= {DATA_WIDTH{1'b0}};
         sobel_thresh_val       <= SOBEL_THRESH;
         hw_accel_mode          <= 2'd0;
         hw_accel_mode2         <= 1'b0;
         hw_accel_dma_init_done <= 1'b0;
      end else begin
         //AXI slave
         axi_slave_re_r         <= axi_slave_re;
         axi_slave_rvalid       <= axi_slave_re_pulse;   //Read data ready after 1 clock cycle latency
         //Default value
         axi_slave_rdata        <= {DATA_WIDTH{1'b0}};
         sobel_thresh_val       <= sobel_thresh_val;
         hw_accel_mode          <= hw_accel_mode;
         hw_accel_mode2         <= hw_accel_mode2;
         hw_accel_dma_init_done <= hw_accel_dma_init_done;
         
         //AXI write to HW accelerator
         if (axi_slave_we) begin
            case(axi_slave_waddr[5:2])
               4'd0 : sobel_thresh_val       <= axi_slave_wdata [INT_DATA_WIDTH-1:0];
               4'd1 : hw_accel_mode          <= axi_slave_wdata [1:0];
               4'd2 : hw_accel_mode2         <= axi_slave_wdata [0];
               4'd3 : hw_accel_dma_init_done <= axi_slave_wdata [0];
               default: 
               begin
                  sobel_thresh_val       <= sobel_thresh_val;
                  hw_accel_mode          <= hw_accel_mode;
                  hw_accel_mode2         <= hw_accel_mode2;
                  hw_accel_dma_init_done <= hw_accel_dma_init_done;
               end
            endcase
         end
         
         //AXI read from HW accelerator
         if (axi_slave_re_pulse) begin
            case(axi_slave_raddr[5:2])
               4'd4  : axi_slave_rdata <= 32'hABCD_1234; //To check if slave read works correctly
               4'd5  : axi_slave_rdata <= {24'd0, debug_hw_accel_fifo_status};
               4'd6  : axi_slave_rdata <= debug_dma1_in_fifo_wcount;
               4'd7  : axi_slave_rdata <= debug_dma2_in_fifo_wcount;
               4'd8  : axi_slave_rdata <= debug_dma_out_fifo_rcount;
               4'd9  : axi_slave_rdata <= debug_dual_cam_scaling_fifo_wcount;
               4'd10 : axi_slave_rdata <= debug_dual_cam_scaling_fifo_rcount;
               default: axi_slave_rdata <= {DATA_WIDTH{1'b0}};
            endcase
         end
      end
   end
   
   //DMA - Write to DDR & Control
   always@(posedge clk or posedge rst)
   begin
      if (rst) begin
         dma_wr_words_count        <= {DMA_WR_WORDS_COUNT_BIT{1'b0}};
         dma_write                 <= 1'b0;
         rst_after_each_frame      <= 1'b0;
         dma1_rready               <= 1'b0;
         dma1_in_fifo_we           <= 1'b0;
         dma1_in_fifo_wdata        <= {INT_DATA_WIDTH{1'b0}};
         dma2_rready               <= 1'b0;
         dma2_in_fifo_we           <= 1'b0;
         dma2_in_fifo_wdata        <= {INT_DATA_WIDTH{1'b0}};
         hw_accel_dma_init_done_r1 <= 1'b0;
         hw_accel_dma_init_done_r2 <= 1'b0;
         hw_accel_dma_init_done_r3 <= 1'b0;
         hw_accel_mode_r           <= 2'd0;
         hw_accel_mode_synced      <= 2'd0;
         hw_accel_mode2_r          <= 1'b0;
         hw_accel_mode2_synced     <= 1'b0;
         sobel_thresh_val_r        <= {INT_DATA_WIDTH{1'b0}};
         sobel_thresh_val_synced   <= {INT_DATA_WIDTH{1'b0}};
      end else begin
         //DMA
         dma_wr_words_count        <= (dma_wvalid && (dma_wr_words_count==DMA_TRANSFER_LENGTH-1)) ? {DMA_WR_WORDS_COUNT_BIT{1'b0}}                                :
                                      (dma_wvalid)                                                ? dma_wr_words_count + {{DMA_WR_WORDS_COUNT_BIT-1{1'b0}}, 1'b1} :
                                                                                                    dma_wr_words_count;
         dma_write                 <= (~hw_accel_dma_init_done_r3 && hw_accel_dma_init_done_r2)   ? 1'b1 :
                                      (dma_wvalid && (dma_wr_words_count==DMA_TRANSFER_LENGTH-1)) ? 1'b0 : dma_write;
         rst_after_each_frame      <= dma_wlast && (dma_wr_words_count==(FRAME_HEIGHT*FRAME_WIDTH)-1);

         dma1_rready               <= ~dma1_in_fifo_prog_full && ~dma_out_fifo_prog_full;
         dma1_in_fifo_we           <= dma1_rvalid && (&dma1_rkeep) && dma1_rready;
         dma1_in_fifo_wdata        <= dma1_rdata [INT_DATA_WIDTH-1:0];

         dma2_rready               <= ~dma2_in_fifo_prog_full && ~dma_out_fifo_prog_full;
         dma2_in_fifo_we           <= dma2_rvalid && (&dma2_rkeep) && dma2_rready;
         dma2_in_fifo_wdata        <= dma2_rdata [INT_DATA_WIDTH-1:0];
         
         //Synchronizer
         hw_accel_dma_init_done_r1 <= hw_accel_dma_init_done;
         hw_accel_dma_init_done_r2 <= hw_accel_dma_init_done_r1;
         hw_accel_dma_init_done_r3 <= hw_accel_dma_init_done_r2;
         
         hw_accel_mode_r           <= hw_accel_mode;
         hw_accel_mode_synced      <= hw_accel_mode_r;
         hw_accel_mode2_r          <= hw_accel_mode2;
         hw_accel_mode2_synced     <= hw_accel_mode2_r;
         
         sobel_thresh_val_r        <= sobel_thresh_val;
         sobel_thresh_val_synced   <= sobel_thresh_val_r;
      end
   end
   
   //DMA read/input fifo
   hw_accel_dma_in_fifo u_dma1_in_fifo (
      .almost_full_o  (),
      .prog_full_o    (dma1_in_fifo_prog_full),
      .full_o         (),
      .overflow_o     (dma1_in_fifo_overflow),
      .wr_ack_o       (),
      .empty_o        (dma1_in_fifo_empty),
      .almost_empty_o (),
      .underflow_o    (dma1_in_fifo_underflow),
      .rd_valid_o     (dma1_in_fifo_rvalid),
      .rdata          (dma1_in_fifo_rdata),
      .clk_i          (clk),
      .wr_en_i        (dma1_in_fifo_we),
      .rd_en_i        (dma1_in_fifo_re),
      .a_rst_i        (rst_hw_accel),
      .wdata          (dma1_in_fifo_wdata),
      .datacount_o    (),
      .wr_datacount_o (),
      .rd_datacount_o ()
   );
   
   hw_accel_dma_in_fifo u_dma2_in_fifo (
      .almost_full_o  (),
      .prog_full_o    (dma2_in_fifo_prog_full),
      .full_o         (),
      .overflow_o     (dma2_in_fifo_overflow),
      .wr_ack_o       (),
      .empty_o        (dma2_in_fifo_empty),
      .almost_empty_o (),
      .underflow_o    (dma2_in_fifo_underflow),
      .rd_valid_o     (dma2_in_fifo_rvalid),
      .rdata          (dma2_in_fifo_rdata),
      .clk_i          (clk),
      .wr_en_i        (dma2_in_fifo_we),
      .rd_en_i        (dma2_in_fifo_re),
      .a_rst_i        (rst_hw_accel),
      .wdata          (dma2_in_fifo_wdata),
      .datacount_o    (),
      .wr_datacount_o (),
      .rd_datacount_o ()
   );
   
   //DMA write/output fifo - FWFT mode
   //Threshold for dma_out_fifo_prog_full need to consider pipeline stages within HW accelerator, which might continue to flush out several data
   //after input valid comes to a halt 
   assign dma_out_fifo_re = dma_write && dma_wready && ~dma_out_fifo_empty;
   assign dma_wvalid      = dma_out_fifo_rvalid && dma_out_fifo_re;
   assign dma_wlast       = dma_wvalid && (dma_wr_words_count==DMA_TRANSFER_LENGTH-1);
   assign dma_wdata       = {{(DATA_WIDTH-INT_DATA_WIDTH){1'b0}}, dma_out_fifo_rdata};
   
   hw_accel_dma_out_fifo u_dma_out_fifo (
      .almost_full_o  (),
      .prog_full_o    (dma_out_fifo_prog_full),
      .full_o         (),
      .overflow_o     (dma_out_fifo_overflow),
      .wr_ack_o       (),
      .empty_o        (dma_out_fifo_empty),
      .almost_empty_o (),
      .underflow_o    (dma_out_fifo_underflow),
      .rd_valid_o     (dma_out_fifo_rvalid),
      .rdata          (dma_out_fifo_rdata),
      .clk_i          (clk),
      .wr_en_i        (dma_out_fifo_we),
      .rd_en_i        (dma_out_fifo_re),
      .a_rst_i        (rst_hw_accel),
      .wdata          (dma_out_fifo_wdata),
      .datacount_o    (),
      .wr_datacount_o (),
      .rd_datacount_o ()
   );

   //Hardware accelerator - Image Merger
   //Two sets of selection mode

   //HW accel mode: Processing
   //0: Cam source 1 - Passthrough;       Cam source 2 - Passthrough
   //1: Cam source 1 - Passthrough;       Cam source 2 - Processed (Sobel)
   //2: Cam source 1 - Processed (Sobel); Cam source 2 - Passthrough
   //3: Cam source 1 - Processed (Sobel); Cam source 2 - Processed (Sobel)
   
   //HW accel mode2: Merging
   //0: Merge frame data from cam source 1 (cropped by half, left side) and cam source 2 (cropped by half, right side)
   //1: Merge frame data from cam source 1 (main) and cam source 2 (downscaled overlay)
   
   hw_accel_dual_cam # (
      .DATA_WIDTH (INT_DATA_WIDTH),
      .IMG_WIDTH  (FRAME_WIDTH),
      .IMG_HEIGHT (FRAME_HEIGHT)
   ) u_hw_accel (
      .clk                             (clk),
      .rst                             (rst_hw_accel),
      .hw_accel_mode                   (hw_accel_mode_synced),
      .hw_accel_mode2                  (hw_accel_mode2_synced),
      .sobel_thresh_val                (sobel_thresh_val_synced),
      .pixel_in1_rready                (~dma1_in_fifo_empty),
      .pixel_in1_req                   (dma1_in_fifo_re),
      .pixel_in1                       (dma1_in_fifo_rdata),
      .pixel_in1_valid                 (dma1_in_fifo_rvalid),
      .pixel_in2_rready                (~dma2_in_fifo_empty),
      .pixel_in2_req                   (dma2_in_fifo_re),
      .pixel_in2                       (dma2_in_fifo_rdata),
      .pixel_in2_valid                 (dma2_in_fifo_rvalid),
      .pixel_out_wready                (~dma_out_fifo_prog_full),
      .pixel_out                       (dma_out_fifo_wdata),
      .pixel_out_valid                 (dma_out_fifo_we),
      .dual_cam_scaling_fifo_underflow (dual_cam_scaling_fifo_underflow),
      .dual_cam_scaling_fifo_overflow  (dual_cam_scaling_fifo_overflow),
      .dual_cam_scaling_fifo_we        (dual_cam_scaling_fifo_we),
      .dual_cam_scaling_fifo_re        (dual_cam_scaling_fifo_re)
   );

endmodule
