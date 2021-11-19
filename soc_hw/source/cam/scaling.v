///////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021 github-efx
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

module scaling
#(
   parameter   P_DEPTH  = 10,
   parameter   X_TOTAL  = 1280,
   parameter   Y_TOTAL  = 720,
   parameter   X_SCALE  = 1920,
   parameter   Y_SCALE  = 1080
)
(
   input                in_pclk,
   input                in_arstn,
      
   input [10:0]         in_x,
   input [10:0]         in_y,
   input                in_valid,
   input [P_DEPTH-1:0]  in_data,
   
   output [10:0]        out_x,
   output [10:0]        out_y,
   output               out_valid,
   output [P_DEPTH-1:0] out_data,
   output               overflow_o,
   output               underflow_o
);

parameter   X_OUT_RATIO = ((X_TOTAL - 1'b1) * 32'h3FF / (X_SCALE));
parameter   X_IN_RATIO  = ((X_SCALE * 32'h3FF) / (X_TOTAL - 1'b1));
parameter   Y_OUT_RATIO = ((Y_TOTAL - 1'b1) * 32'h3FF / (Y_SCALE));
parameter   Y_IN_RATIO  = ((Y_SCALE * 32'h3FF) / (Y_TOTAL - 1'b1));

reg                  r_x_scale_up;
reg                  r_y_scale_up;
reg  [10:0]          r_x_out_cnt;
reg  [10:0]          r_y_out_cnt;
reg  [10:0]          r_in_x_1P;
reg  [10:0]          r_in_y_1P;
reg                  r_in_valid_1P;
reg  [P_DEPTH-1:0]   r_a0;
reg  [P_DEPTH-1:0]   r_a1;
reg  [P_DEPTH-1:0]   r_b0;
reg  [P_DEPTH-1:0]   r_b1;
reg                  r_out_en;
reg                  r_out_valid;
reg                  r_out_valid_1P;
reg                  r_out_valid_2P;
reg                  r_out_valid_3P;
reg  [22:0]          r_x_out_scaled;   
reg  [22:0]          r_y_out_scaled;   
reg  [22:0]          r_y_in_scaled; 
reg  [22:0]          r_x_scaled_1P;
reg  [22:0]          r_x_scaled_2P;
reg  [22:0]          r_x_scaled_3P;
reg  [22:0]          r_y_scaled_1P;
reg  [22:0]          r_y_scaled_2P;
reg  [22:0]          r_y_scaled_3P; 
reg  [1:0]           r_in_line_cnt;
reg                  r_in_line_start;
reg                  r_line_delay;

wire [10:0]          w_x_odd;
wire [10:0]          w_x_even;
wire [P_DEPTH-1:0]   w_data_0L_even;
wire [P_DEPTH-1:0]   w_data_0L_odd;
wire [P_DEPTH-1:0]   w_data_1L_even;
wire [P_DEPTH-1:0]   w_data_1L_odd;
wire [P_DEPTH-1:0]   w_data_2L_even;
wire [P_DEPTH-1:0]   w_data_2L_odd;
wire [P_DEPTH-1:0]   w_data_3L_even;
wire [P_DEPTH-1:0]   w_data_3L_odd;
wire                 w_valid_delay;
wire [10:0]          w_x_delay;
wire [10:0]          w_y_delay;

/* Scale ratio calculation */
always@(posedge in_pclk)
begin
   if (~in_arstn)
   begin
      r_y_in_scaled     <= 23'b0;
      r_in_valid_1P     <= 1'b0;
      r_in_x_1P         <= 11'b0;
      r_in_y_1P         <= 11'b0;
      r_in_line_cnt     <= 2'b0;
      r_in_line_start   <= 1'b0;
      r_line_delay      <= 1'b0;
   end
   else
   begin    
      // Scaling ratio calculation     
      r_in_valid_1P     <= in_valid;
      r_in_x_1P         <= in_x;
      r_in_y_1P         <= in_y;    
      
      r_in_valid_1P     <= in_valid;
      
      if (in_valid && in_x == 11'd0)
         r_in_line_cnt  <= r_in_line_cnt + 1'b1;
      
      if (r_in_line_cnt == 2'b01)
         r_in_line_start <= 1'b1;
      else
      if (r_in_line_cnt == 2'b10)
         r_line_delay <= 1'b1;
      
      if (w_valid_delay)
      begin
         if (w_x_delay == X_TOTAL - 1)
         begin
            if (w_y_delay == Y_TOTAL - 1)
               r_y_in_scaled <= 23'b0;
         end
         else if (w_x_delay == 11'b0)
            r_y_in_scaled <= r_y_in_scaled + Y_IN_RATIO;
      end
   end
end

// FIFO delay for input x, y and valid /
cam_scaler_fifo  fifo_01
(
   .clk_i      (in_pclk),
   .a_rst_i    (~in_arstn),
   .wr_en_i    (r_in_line_start),
   .rd_en_i    (r_line_delay),
   .overflow_o (),
   .underflow_o(),
   .wdata      ({r_in_valid_1P, r_in_x_1P, r_in_y_1P}),
   .rdata      ({w_valid_delay, w_x_delay, w_y_delay})
);

/* 4 lines buffer */
/* 1st line, even x count */
simple_dual_port_ram
#(
   . DATA_WIDTH   (P_DEPTH),
   . ADDR_WIDTH   (10)
)
inst_simple_dual_port_ram_0L_even
(
   .wclk    (in_pclk),
   .we      (in_valid && !in_x[0] && (in_y[1:0] == 2'd0)),
   .waddr   (in_x[10:1]),
   .wdata   (in_data),
      
   .rclk    (in_pclk),
   .re      (r_out_valid),
   .raddr   (w_x_even[10:1]), 
   .rdata   (w_data_0L_even)
);

/* 1st line, odd x count */
simple_dual_port_ram
#(
   . DATA_WIDTH   (P_DEPTH),
   . ADDR_WIDTH   (10)
)
inst_simple_dual_port_ram_0L_odd
(
   .wclk    (in_pclk),
   .we      (in_valid && in_x[0] && (in_y[1:0] == 2'd0)),
   .waddr   (in_x[10:1]),
   .wdata   (in_data),
      
   .rclk    (in_pclk),
   .re      (r_out_valid),
   .raddr   (w_x_odd[10:1]),  
   .rdata   (w_data_0L_odd)
);

/* 2nd line, even x count */
simple_dual_port_ram
#(
   . DATA_WIDTH   (P_DEPTH),
   . ADDR_WIDTH   (10)
)
inst_simple_dual_port_ram_1L_even
(
   .wclk    (in_pclk),
   .we      (in_valid && !in_x[0] && (in_y[1:0] == 2'd1)),
   .waddr   (in_x[10:1]),
   .wdata   (in_data),
      
   .rclk    (in_pclk),
   .re      (r_out_valid),
   .raddr   (w_x_even[10:1]), 
   .rdata   (w_data_1L_even)
);

/* 2nd line, odd x count */
simple_dual_port_ram
#(
   . DATA_WIDTH   (P_DEPTH),
   . ADDR_WIDTH   (10)
)
inst_simple_dual_port_ram_1L_odd
(
   .wclk    (in_pclk),
   .we      (in_valid && in_x[0] && (in_y[1:0] == 2'd1)),
   .waddr   (in_x[10:1]),
   .wdata   (in_data),
      
   .rclk    (in_pclk),
   .re      (r_out_valid),
   .raddr   (w_x_odd[10:1]),  
   .rdata   (w_data_1L_odd)
);

/* 3rd line, even x count */
simple_dual_port_ram
#(
   . DATA_WIDTH   (P_DEPTH),
   . ADDR_WIDTH   (10)
)
inst_simple_dual_port_ram_2L_even
(
   .wclk    (in_pclk),
   .we      (in_valid && !in_x[0] && (in_y[1:0] == 2'd2)),
   .waddr   (in_x[10:1]),
   .wdata   (in_data),
      
   .rclk    (in_pclk),
   .re      (r_out_valid),
   .raddr   (w_x_even[10:1]), 
   .rdata   (w_data_2L_even)
);

/* 3rd line, odd x count */
simple_dual_port_ram
#(
   . DATA_WIDTH   (P_DEPTH),
   . ADDR_WIDTH   (10)
)
inst_simple_dual_port_ram_2L_odd
(
   .wclk    (in_pclk),
   .we      (in_valid && in_x[0] && (in_y[1:0] == 2'd2)),
   .waddr   (in_x[10:1]),
   .wdata   (in_data),
      
   .rclk    (in_pclk),
   .re      (r_out_valid),
   .raddr   (w_x_odd[10:1]),  
   .rdata   (w_data_2L_odd)
);

/* 4th line, even x count */
simple_dual_port_ram
#(
   . DATA_WIDTH   (P_DEPTH),
   . ADDR_WIDTH   (10)
)
inst_simple_dual_port_ram_3L_even
(
   .wclk    (in_pclk),
   .we      (in_valid && !in_x[0] && (in_y[1:0] == 2'd3)),
   .waddr   (in_x[10:1]),
   .wdata   (in_data),
      
   .rclk    (in_pclk),
   .re      (r_out_valid),
   .raddr   (w_x_even[10:1]), 
   .rdata   (w_data_3L_even)
);

/* 4th line, odd x count */
simple_dual_port_ram
#(
   . DATA_WIDTH   (P_DEPTH),
   . ADDR_WIDTH   (10)
)
inst_simple_dual_port_ram_3L_odd
(
   .wclk    (in_pclk),
   .we      (in_valid && in_x[0] && (in_y[1:0] == 2'd3)),
   .waddr   (in_x[10:1]),
   .wdata   (in_data),
      
   .rclk    (in_pclk),
   .re      (r_out_valid),
   .raddr   (w_x_odd[10:1]),  
   .rdata   (w_data_3L_odd)
);

/* Scale up/down x and y count */
always@(posedge in_pclk)
begin
   if (~in_arstn)
   begin
      r_x_out_cnt       <= 11'b1;
      r_y_out_cnt       <= 11'b1;
      r_out_en          <= 1'b0;
      r_out_valid       <= 1'b0;
      r_out_valid_1P    <= 1'b0;
      r_out_valid_2P    <= 1'b0;
      r_out_valid_3P    <= 1'b0;
      r_x_scaled_1P     <= 23'b0;
      r_x_scaled_2P     <= 23'b0;
      r_x_scaled_3P     <= 23'b0;
      r_y_scaled_1P     <= 23'b0;
      r_y_scaled_2P     <= 23'b0;
      r_y_scaled_3P     <= 23'b0;
      r_x_out_scaled    <= X_OUT_RATIO;
      r_y_out_scaled    <= Y_OUT_RATIO;
   end
   else
   begin
      r_out_valid_1P    <= r_out_valid;
      r_out_valid_2P    <= r_out_valid_1P;
      r_out_valid_3P    <= r_out_valid_2P;
      r_x_scaled_1P     <= r_x_out_scaled;
      r_x_scaled_2P     <= r_x_scaled_1P;
      r_x_scaled_3P     <= r_x_scaled_2P;
      r_y_scaled_1P     <= r_y_out_scaled;
      r_y_scaled_2P     <= r_y_scaled_1P;
      r_y_scaled_3P     <= r_y_scaled_2P;
      
      // Start scaling at the end of 2nd line input
      if (w_valid_delay && (w_y_delay == 11'd0))
      begin
         r_out_en    <= 1'b1;
      end
      
      // End of scaling
      if ((r_y_out_cnt == Y_SCALE) && (r_x_out_cnt == X_SCALE))
         r_out_en    <= 1'b0;
         
      // Determine data enable of output line         
      if (r_y_out_scaled[20:10] < w_y_delay)
      begin 
         r_out_valid <= r_out_en;
         r_x_out_cnt <= 11'b1;         
      end
         
      // Scaling x and y counts     
      if (r_out_valid)
      begin
         if (r_x_out_cnt == X_SCALE)
         begin
            r_x_out_cnt    <= 11'b1;
            r_out_valid    <= 1'b0;
            r_x_out_scaled <= X_OUT_RATIO;
                        
            if (r_y_out_cnt == Y_SCALE)
            begin
               r_y_out_cnt    <= 11'b1;
               r_y_out_scaled <= Y_OUT_RATIO;               
            end
            else
            begin
               r_y_out_cnt    <= r_y_out_cnt + 1'b1;
               r_y_out_scaled <= Y_OUT_RATIO + r_y_out_scaled;
            end
         end
         else
         begin
            r_x_out_cnt    <= r_x_out_cnt + 1'b1;
            r_x_out_scaled <= X_OUT_RATIO + r_x_out_scaled;
         end
      end
      
      // Data mux for bilinear calculation            
      if (r_y_scaled_2P[11:10] == 2'd0)
      begin
         if (r_x_scaled_2P[10])
         begin
            r_a0  <= w_data_0L_odd;
            r_a1  <= w_data_0L_even;
            r_b0  <= w_data_1L_odd;
            r_b1  <= w_data_1L_even;
         end
         else
         begin
            r_a0  <= w_data_0L_even;
            r_a1  <= w_data_0L_odd;
            r_b0  <= w_data_1L_even;
            r_b1  <= w_data_1L_odd;
         end
      end
      
      if (r_y_scaled_2P[11:10] == 2'd1)
      begin
         if (r_x_scaled_2P[10])
         begin
            r_a0  <= w_data_1L_odd;
            r_a1  <= w_data_1L_even;
            r_b0  <= w_data_2L_odd;
            r_b1  <= w_data_2L_even;
         end
         else
         begin
            r_a0  <= w_data_1L_even;
            r_a1  <= w_data_1L_odd;
            r_b0  <= w_data_2L_even;
            r_b1  <= w_data_2L_odd;
         end
      end
      
      if (r_y_scaled_2P[11:10] == 2'd2)
      begin
         if (r_x_scaled_2P[10])
         begin
            r_a0  <= w_data_2L_odd;
            r_a1  <= w_data_2L_even;
            r_b0  <= w_data_3L_odd;
            r_b1  <= w_data_3L_even;
         end
         else
         begin
            r_a0  <= w_data_2L_even;
            r_a1  <= w_data_2L_odd;
            r_b0  <= w_data_3L_even;
            r_b1  <= w_data_3L_odd;
         end
      end
      
      if (r_y_scaled_2P[11:10] == 2'd3)
      begin
         if (r_x_scaled_2P[10])
         begin
            r_a0  <= w_data_3L_odd;
            r_a1  <= w_data_3L_even;
            r_b0  <= w_data_0L_odd;
            r_b1  <= w_data_0L_even;
         end
         else
         begin
            r_a0  <= w_data_3L_even;
            r_a1  <= w_data_3L_odd;
            r_b0  <= w_data_0L_even;
            r_b1  <= w_data_0L_odd;
         end
      end
   end
end

// Odd and even data count mux
assign   w_x_odd  = r_x_out_scaled[10] ? r_x_out_scaled[20:10] : r_x_out_scaled[20:10]+1'b1;
assign   w_x_even = !r_x_out_scaled[10] ? r_x_out_scaled[20:10] : r_x_out_scaled[20:10]+1'b1;

/* Bilinear calculation */
bilinear 
#( 
   .P_DEPTH    (P_DEPTH),
   .SHIFT_BITS (10)
)     
inst_bilinear_00 
(
  .p_clk    (in_pclk),
  .rstn     (in_arstn),
  
  .in_en    (r_out_valid_3P),
  .in_a0    (r_a0),
  .in_a1    (r_a1),
  .in_b0    (r_b0),
  .in_b1    (r_b1),
  .in_dx    (r_x_scaled_3P[9:0]),
  .in_dy    (r_y_scaled_3P[9:0]),

  .out_en   (out_valid),
  .out_c    (out_data)
);

/* FIFO delay for X and Y output */
shift_reg
#(
   .D_WIDTH (22),
   .TAPE    (8)
)
inst_shift_reg_00
(                                                                    
   .i_arst  (~in_arstn),                                               
   .i_clk   (in_pclk),                                               

   .i_d     ({r_x_out_cnt - 1'b1, r_y_out_cnt - 1'b1}),
   .o_q     ({out_x, out_y})                   
);

endmodule
