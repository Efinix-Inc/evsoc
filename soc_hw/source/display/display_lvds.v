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

module display_lvds #(
   parameter DISPLAY_MODE = "640x480_60Hz" //"640x480_60Hz" or "1280x720_60Hz" or "1920x1080_60Hz"
) (
   input  wire          lvds_slowclk,
   input  wire          rst_n,
   
   //DMA
   input  wire [63:0]   display_dma_rdata,
   input  wire          display_dma_rvalid,
   input  wire [7:0]    display_dma_rkeep,
   output reg           display_dma_rready,
   
   // LVDS Video output
   output wire [6:0]    lvds_1a_DATA,
   output wire [6:0]    lvds_1b_DATA,
   output wire [6:0]    lvds_1c_DATA,
   output wire [6:0]    lvds_1d_DATA,
   output wire [6:0]    lvds_2a_DATA,
   output wire [6:0]    lvds_2b_DATA,
   output wire [6:0]    lvds_2c_DATA,
   output wire [6:0]    lvds_2d_DATA,
   output wire [6:0]    lvds_clk,
   
   //Debug registers
   output reg           debug_display_dma_fifo_overflow,
   output reg           debug_display_dma_fifo_underflow,
   output reg [31:0]    debug_display_dma_fifo_rcount,
   output reg [31:0]    debug_display_dma_fifo_wcount
);

//-----------------------------------//
// 640*480 VGA 60Hz fps
//-----------------------------------//
//DISPLAY_MODE == "640x480_60Hz"
//tx_slowclk: 12.38MHz
//tx_fastclk: 43.31MHz

//-----------------------------------//
// 1280*720 VGA 60Hz fps
//-----------------------------------//
//DISPLAY_MODE == "1280x720_60Hz"
//tx_slowclk: 37.13MHz
//tx_fastclk: 129.94MHz

//-----------------------------------//
// 1920*1080 VGA 60Hz fps
//-----------------------------------//
//DISPLAY_MODE == "1920x1080_60Hz"
//tx_slowclk: 74.25MHz
//tx_fastclk: 259.88MHz

//Hor total time
parameter LinePeriod    = (DISPLAY_MODE == "640x480_60Hz")  ? 12'd400  :
                          (DISPLAY_MODE == "1280x720_60Hz") ? 12'd825  :
                                                              12'd1100 ;

//Hor sync time
parameter H_SyncPulse   = (DISPLAY_MODE == "640x480_60Hz")  ? 8'd48 :
                          (DISPLAY_MODE == "1280x720_60Hz") ? 8'd20 :
                                                              8'd22 ;

//H back porch
parameter H_BackPorch   = (DISPLAY_MODE == "640x480_60Hz")  ? 8'd20  :
                          (DISPLAY_MODE == "1280x720_60Hz") ? 8'd110 :
                                                              8'd74  ;

//Hor pixels
parameter H_ActivePix   = (DISPLAY_MODE == "640x480_60Hz")  ? 12'd320 :
                          (DISPLAY_MODE == "1280x720_60Hz") ? 12'd640 :
                                                              12'd960 ;

//H front porch
parameter H_FrontPorch  = (DISPLAY_MODE == "640x480_60Hz")  ? 8'd4  :
                          (DISPLAY_MODE == "1280x720_60Hz") ? 8'd55 :
                                                              8'd44 ;

//H_SyncPulse + H_BackPorch
parameter Hde_start     = (DISPLAY_MODE == "640x480_60Hz")  ? 8'd68  :
                          (DISPLAY_MODE == "1280x720_60Hz") ? 8'd130 :
                                                              8'd96  ;

//H_SyncPulse + H_BackPorch + H_ActivePix
parameter Hde_end       = (DISPLAY_MODE == "640x480_60Hz")  ? 12'd388 :
                          (DISPLAY_MODE == "1280x720_60Hz") ? 12'd770 :
                                                              12'd1056;


//Ver total time
parameter FramePeriod   = (DISPLAY_MODE == "640x480_60Hz")  ? 11'd525 :
                          (DISPLAY_MODE == "1280x720_60Hz") ? 11'd750 :
                                                              11'd1125;

//Ver sync time
parameter V_SyncPulse   = (DISPLAY_MODE == "640x480_60Hz")  ? 6'd2 :
                          (DISPLAY_MODE == "1280x720_60Hz") ? 6'd5 :
                                                              6'd5 ;

//V back porch
parameter V_BackPorch   = (DISPLAY_MODE == "640x480_60Hz")  ? 6'd25 :
                          (DISPLAY_MODE == "1280x720_60Hz") ? 6'd20 :
                                                              6'd36 ;

//Ver pixels
parameter V_ActivePix   = (DISPLAY_MODE == "640x480_60Hz")  ? 11'd480 :
                          (DISPLAY_MODE == "1280x720_60Hz") ? 11'd720 :
                                                              11'd1080;

//V front porch
parameter V_FrontPorch  = (DISPLAY_MODE == "640x480_60Hz")  ? 6'd2 :
                          (DISPLAY_MODE == "1280x720_60Hz") ? 6'd5 :
                                                              6'd4 ;

//V_SyncPulse + V_BackPorch
parameter Vde_start     = (DISPLAY_MODE == "640x480_60Hz")  ? 6'd27 :
                          (DISPLAY_MODE == "1280x720_60Hz") ? 6'd25 :
                                                              6'd41 ;

//V_SyncPulse + V_BackPorch + V_ActivePix
parameter Vde_end       = (DISPLAY_MODE == "640x480_60Hz")  ? 11'd507 :
                          (DISPLAY_MODE == "1280x720_60Hz") ? 11'd745 :
                                                              11'd1121;

localparam FIFO_READ_LATENCY = 2+1;    //Include one reg latency after readout
localparam DISP_FIFO_DEPTH   = 1024;   //Power of 2
localparam FIFO_COUNT_BIT    = $clog2(DISP_FIFO_DEPTH);
localparam HCOUNT_BIT        = $clog2(LinePeriod+1);
localparam VCOUNT_BIT        = $clog2(FramePeriod+1);

wire [15:0]               display_dma_red;
wire [15:0]               display_dma_green;
wire [15:0]               display_dma_blue;
wire                      display_dma_fifo_wvalid;
wire [47:0]               display_dma_fifo_wdata;
wire                      display_dma_fifo_re;
wire                      display_dma_fifo_rvalid;
wire [47:0]               display_dma_fifo_rdata;
wire [FIFO_COUNT_BIT-1:0] display_dma_fifo_dcount;
wire                      display_dma_fifo_overflow;
wire                      display_dma_fifo_underflow;
reg                       display_hde;
reg                       display_vde;
reg                       display_hsync;
reg                       display_vsync;
reg  [HCOUNT_BIT-1:0]     display_hcount;
reg  [VCOUNT_BIT-1:0]     display_vcount;
reg                       display_hde_ahead;
reg                       display_vsync_r;
reg                       display_valid_frames;
wire                      display_vsync_fall_edge;
reg                       w_out_de;
reg                       w_out_hsync;
reg                       w_out_vsync;
reg  [15:0]               w_out_rd_00;
reg  [15:0]               w_out_rd_01;
reg  [15:0]               w_out_rd_10;

//To facilitate incoming data from DMA
`ifndef SIM

always @ (posedge lvds_slowclk)
begin
   if(~rst_n) begin
      display_dma_rready <= 1'b0;
   end else begin
      display_dma_rready <= (display_dma_fifo_dcount < (DISP_FIFO_DEPTH-10));
   end
end

`else

//Simulation check display_dma_rdata and display_dma_rvalid only, bypass checking on async fifo and lvds signal forming.
always @ (posedge lvds_slowclk)
begin
   display_dma_rready <= 1'b1;
end

`endif

//IMPORTANT TO CHECK FIFO UNDERFLOW FLAG
//DATA_WIDTH = 48
//DEPTH - Might be further cut down

assign display_dma_red         = {display_dma_rdata [39:32], display_dma_rdata [7:0]};
assign display_dma_green       = {display_dma_rdata [47:40], display_dma_rdata [15:8]};
assign display_dma_blue        = {display_dma_rdata [55:48], display_dma_rdata [23:16]};
assign display_dma_fifo_wdata  = {display_dma_blue, display_dma_green, display_dma_red};
assign display_dma_fifo_wvalid = display_dma_rvalid && (&display_dma_rkeep) && display_dma_rready; //Advanced DMA behavior
assign display_dma_fifo_re     = display_hde_ahead && display_valid_frames;

display_dma_fifo #(
   .FIFO_DEPTH(DISP_FIFO_DEPTH)
) u_display_dma_fifo (
   .almost_full_o  (),
   .full_o         (),
   .overflow_o     (display_dma_fifo_overflow),
   .empty_o        (),
   .almost_empty_o (),
   .underflow_o    (display_dma_fifo_underflow),
   .datacount_o    (display_dma_fifo_dcount),
   .rd_valid_o     (display_dma_fifo_rvalid),
   .rdata          (display_dma_fifo_rdata),
   .clk_i          (lvds_slowclk),
   .wr_en_i        (display_dma_fifo_wvalid),
   .rd_en_i        (display_dma_fifo_re),
   .a_rst_i        (~rst_n),
   .wdata          (display_dma_fifo_wdata)
);

//Facilitate readout valid frames from fifo (once start, should not stop for valid hde, cautious on potential fifo underflow)
//VGA counter for the output display sync signals generator
//For HSYNC and DE
always @ (posedge lvds_slowclk)
begin
   if(~rst_n) begin
      display_hcount <= {HCOUNT_BIT{1'b0}};
      display_hsync  <= 1'b1;
      display_hde    <= 1'b0;
   end else if(display_hcount == LinePeriod-1) begin
      display_hcount <= {HCOUNT_BIT{1'b0}};
      display_hsync  <= 1'b0;
   end else begin
      display_hcount <= display_hcount + 1'b1;
      
      if (display_hcount == H_SyncPulse-1) begin
         display_hsync <= 1'b1;
      end
      if(display_hcount == Hde_end-1) begin
         display_hde <= 1'b0;
      end else if((display_hcount == Hde_start-1) && display_vde) begin
         display_hde <= 1'b1;
      end
   end
end

//For VSYNC
always @ (posedge lvds_slowclk) 
begin
   if(~rst_n) begin
      display_vcount <= {VCOUNT_BIT{1'b0}};
   end else if (display_vcount == FramePeriod) begin
      display_vcount <= {VCOUNT_BIT{1'b0}};
   end else if(display_hcount == LinePeriod-1) begin
      display_vcount <= display_vcount + 1'b1;
   end
end

always @(posedge lvds_slowclk)
begin
	if(~rst_n) begin
		display_vsync <= 1'b1;
	end else if(display_vcount == {VCOUNT_BIT{1'b0}}) begin
		display_vsync <= 1'b0;
	end else if(display_vcount == V_SyncPulse) begin
		display_vsync <= 1'b1;
   end
end
      
always @ (posedge lvds_slowclk)
begin
   if(~rst_n) begin
      display_vde <= 1'b0;
   end else begin		
      if(display_vcount == Vde_start) begin
         display_vde <= 1'b1;
      end else begin      
         if(display_vcount == Vde_end) begin
            display_vde <= 1'b0;
         end
      end
   end
end

assign display_vsync_fall_edge = display_vsync_r && ~display_vsync;

always @ (posedge lvds_slowclk)
begin
   if(~rst_n) begin
      display_vsync_r      <= 1'b0;
      display_valid_frames <= 1'b0;
      display_hde_ahead    <= 1'b0;
      w_out_rd_00          <= 16'd0;
      w_out_rd_01          <= 16'd0;
      w_out_rd_10          <= 16'd0;
      w_out_de             <= 1'b0;
      w_out_hsync          <= 1'b1;
      w_out_vsync          <= 1'b1;
   end else begin
      display_vsync_r      <= display_vsync;
      display_valid_frames <= (display_vsync_fall_edge && (display_dma_fifo_dcount > ((DISP_FIFO_DEPTH/2)))) ? 1'b1 : display_valid_frames;
      
      //Read ahead from fifo
      if(display_hcount == (Hde_end-FIFO_READ_LATENCY)) begin
         display_hde_ahead <= 1'b0;
      end else if((display_hcount == (Hde_start-FIFO_READ_LATENCY)) && display_vde) begin
         display_hde_ahead <= 1'b1;
      end

      w_out_rd_00 <= (display_dma_fifo_rvalid) ? display_dma_fifo_rdata [15:0]  : 16'd0;  //red
      w_out_rd_01 <= (display_dma_fifo_rvalid) ? display_dma_fifo_rdata [31:16] : 16'd0;  //green
      w_out_rd_10 <= (display_dma_fifo_rvalid) ? display_dma_fifo_rdata [47:32] : 16'd0;  //blue
      
      w_out_de    <= display_hde;
      w_out_hsync <= display_hsync;
      w_out_vsync <= display_vsync;
   end
end
   
 
//Output to LVDS
//24bit color, RGB888 pixel arrangement
assign lvds_1a_DATA = {w_out_rd_00[0], w_out_rd_00[1], w_out_rd_00[2], w_out_rd_00[3], w_out_rd_00[4], w_out_rd_00[5], w_out_rd_01[0]};
assign lvds_1b_DATA = {w_out_rd_01[1], w_out_rd_01[2], w_out_rd_01[3], w_out_rd_01[4], w_out_rd_01[5], w_out_rd_10[0], w_out_rd_10[1]};
assign lvds_1c_DATA = {w_out_rd_10[2], w_out_rd_10[3], w_out_rd_10[4], w_out_rd_10[5], w_out_hsync   , w_out_vsync   , w_out_de      };
assign lvds_1d_DATA = {w_out_rd_00[6], w_out_rd_00[7], w_out_rd_01[6], w_out_rd_01[7], w_out_rd_10[6], w_out_rd_10[7], 1'b0          };

assign lvds_2a_DATA = {w_out_rd_00[8],  w_out_rd_00[9],  w_out_rd_00[10], w_out_rd_00[11], w_out_rd_00[12], w_out_rd_00[13], w_out_rd_01[8]};
assign lvds_2b_DATA = {w_out_rd_01[9],  w_out_rd_01[10], w_out_rd_01[11], w_out_rd_01[12], w_out_rd_01[13], w_out_rd_10[8] , w_out_rd_10[9]};
assign lvds_2c_DATA = {w_out_rd_10[10], w_out_rd_10[11], w_out_rd_10[12], w_out_rd_10[13], w_out_hsync    , w_out_vsync    , w_out_de      };
assign lvds_2d_DATA = {w_out_rd_00[14], w_out_rd_00[15], w_out_rd_01[14], w_out_rd_01[15], w_out_rd_10[14], w_out_rd_10[15], 1'b0          };

assign lvds_clk		= 7'b1100011;  //Fixed value to compensate for HDMI chip delay.

//Debug registers
always @ (posedge lvds_slowclk)
begin
   if(~rst_n) begin
      debug_display_dma_fifo_underflow <= 1'b0;
      debug_display_dma_fifo_overflow  <= 1'b0;
      debug_display_dma_fifo_rcount    <= 32'd0;
      debug_display_dma_fifo_wcount    <= 32'd0;
   end else begin
      debug_display_dma_fifo_underflow <= (display_dma_fifo_underflow) ? 1'b1 : debug_display_dma_fifo_underflow;
      debug_display_dma_fifo_overflow  <= (display_dma_fifo_overflow)  ? 1'b1 : debug_display_dma_fifo_overflow;
      debug_display_dma_fifo_rcount    <= (display_dma_fifo_rvalid)    ? debug_display_dma_fifo_rcount + 1'b1 : debug_display_dma_fifo_rcount;
      debug_display_dma_fifo_wcount    <= (display_dma_fifo_wvalid)    ? debug_display_dma_fifo_wcount + 1'b1 : debug_display_dma_fifo_wcount;
   end
end
  
endmodule
