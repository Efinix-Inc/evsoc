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

`timescale 1ns / 1ps

module simple_ddr_model #(
   parameter DW = 128,
   parameter MEMDEPTH=$clog2(469762048/512)
) (
   input             mem_clk,
   input             resetn,
   input [7:0]       aid_0,
   input [31:0]      aaddr_0,
   input [7:0]       alen_0,
   input [2:0]       asize_0,
   input [1:0]       aburst_0,
   input [1:0]       alock_0,
   input             avalid_0,
   output reg        aready_0,
   input             atype_0,


   input [7:0]       wid_0,
   input [DW-1:0]    wdata_0,
   input [DW/8-1:0]  wstrb_0,
   input             wlast_0,
   input             wvalid_0,
   output reg        wready_0,

   output [7:0]      rid_0,
   output [DW-1:0]   rdata_0,
   output reg        rlast_0,
   output reg        rvalid_0,
   input             rready_0,
   output reg [1:0]  rresp_0,


   output reg [7:0]  bid_0,
   output reg        bvalid_0,
   input             bready_0

);
/////////////////////////////////////////////////////////////////////////////
localparam  s_idle   = 2'b00;
localparam  s_write  = 2'b01;
localparam  s_resp   = 2'b10;
localparam  s_read   = 2'b11;

localparam  addrWidth =(DW == 1024)? 7 :
                       (DW == 512)?  6 :
                       (DW == 256)?  5 :
                       (DW == 128)?  4 :
                       (DW == 64 )?  3 : 2; 
                       /*
localparam  addrByte  =(DW == 1024)? 7 :
                       (DW == 512)?  6 :
                       (DW == 256)?  5 :
                       (DW == 128)?  4 :
                       (DW == 64 )?  3 : 2;
*/                       

reg   [1:0]    r_ram0_state_1P;
reg   [7:0]    r_aid_0_1P;
reg   [MEMDEPTH-1:0]   r_aaddr_0_1P;
reg   [7:0]    r_alen_0_1P;
wire  [DW-1:0] wdata;
reg   [DW-1:0] wdata_r = 'd0;
/////////////////////////////////////////////////////////////////////////////

always@(negedge resetn or posedge mem_clk)
begin
   if (~resetn)
   begin
      r_ram0_state_1P   <= s_idle;
      r_aid_0_1P        <= {8{1'b0}};
      r_aaddr_0_1P      <= {MEMDEPTH{1'b0}};
      r_alen_0_1P       <= {8{1'b0}};
      rlast_0           <= 1'b0;
      rvalid_0          <= 1'b0;
      aready_0          <= 1'b0;
      wready_0          <= 1'b0;
      bid_0             <= {8{1'b0}};
      bvalid_0          <= 1'b0;
      rresp_0           <= 2'b00;
   end else
   begin
      aready_0 <= 1'b0;
      rresp_0  <= 2'b00;
      
      case (r_ram0_state_1P)
         s_idle:
         begin
            if (avalid_0)
            begin
               if (atype_0)
               begin
                  r_ram0_state_1P   <= s_write;
                  wready_0          <= 1'b1;
               end
               else
               begin
                  r_ram0_state_1P   <= s_read;
               end
               
               r_aid_0_1P     <= aid_0;
               r_aaddr_0_1P   <= aaddr_0[MEMDEPTH+ addrWidth: addrWidth];
               r_alen_0_1P    <= alen_0;
               aready_0       <= 1'b1;
            end
         end
         
         s_write:
         begin
            if (wvalid_0)
            begin
               r_aaddr_0_1P      <= r_aaddr_0_1P+1'b1;
               r_alen_0_1P       <= r_alen_0_1P-1'b1;
               
               if (r_alen_0_1P == {8{1'b0}})
               begin
                  r_ram0_state_1P   <= s_resp;
                  wready_0          <= 1'b0;
                  bid_0             <= r_aid_0_1P;
                  bvalid_0          <= 1'b1;
               end
            end
         end

         s_resp:
         begin
            if (bready_0)
            begin
               r_ram0_state_1P   <= s_idle;
               bvalid_0          <= 1'b0;
            end
         end
         
         s_read:
         begin
            rvalid_0          <= 1'b1;
            
            if (r_alen_0_1P == 8'b0)
               rlast_0        <= 1'b1;
            
            if (rvalid_0 && rready_0)
            begin
               r_aaddr_0_1P   <= r_aaddr_0_1P+1'b1;
               r_alen_0_1P    <= r_alen_0_1P-1'b1;
               
               if (r_alen_0_1P == 8'b1)
                  rlast_0           <= 1'b1;
               
               if (r_alen_0_1P == {8{1'b0}})
               begin
                  rvalid_0          <= 1'b0;
                  rlast_0           <= 1'b0;
                  
                  r_ram0_state_1P   <= s_idle;
               end
            end
         end
         
         default:
         begin
            r_ram0_state_1P   <= s_idle;
            r_aid_0_1P        <= {8{1'b0}};
            r_aaddr_0_1P      <= {MEMDEPTH{1'b0}};
            r_alen_0_1P       <= {8{1'b0}};
            rlast_0           <= 1'b0;
            rvalid_0          <= 1'b0;
            wready_0          <= 1'b0;
            bid_0             <= {8{1'b0}};
            bvalid_0          <= 1'b0;
         end
      endcase
   end
end
 genvar i;
 generate
 for(i=0; i < DW/8; i = i + 1) begin
   //assign wdata[(i*8+7) -: 8] = (wdata_0[(i*8+7) -: 8] & {{8}{wstrb_0[i]}}) | rdata_0[(i*8+7) -: 8];
   assign wdata[(i*8+7) -: 8] =  (wdata_0[(i*8+7) -: 8] & {8{wstrb_0[i]}});
   
   //always@(wvalid_0 or rdata_0)
   always@(*)
      //wdata_r[(i*8+7) -: 8] <= wstrb_0[0] ? wdata[(i*8+7) -: 8] : wdata[(i*8+7) -: 8] | rdata_0[(i*8+7) -: 8];
      wdata_r[(i*8+7) -: 8] <= {8{wstrb_0[i]}} ? wdata[(i*8+7) -: 8] : rdata_0[(i*8+7) -: 8];

 end
 endgenerate

ddr_simple_dual_port_ram #(
   .DATA_WIDTH (DW),
   .ADDR_WIDTH (MEMDEPTH),
   .RAM_INIT_FILE("MEM.TXT"),
   .OUTPUT_REG ("FALSE")
) ddr_ram (
   .wdata   (wdata_r),
   .waddr   (r_aaddr_0_1P), 
   .raddr   (r_aaddr_0_1P),
   .we      (wvalid_0 && r_ram0_state_1P == s_write), 
   .wclk    (mem_clk), 
   .re      (rvalid_0|wready_0), 
   .rclk    (mem_clk),
   .rdata   (rdata_0)
);

assign   rid_0 = r_aid_0_1P;


endmodule
