////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2026 Efinix Inc. All rights reserved.
// See https://github.com/Efinix-Inc/evsoc/blob/main/LICENSE.txt for details.
////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module common_apb3_dualCam #(
   parameter   ADDR_WIDTH  = 12,
   parameter   DATA_WIDTH  = 32,
   parameter   NUM_REG     = 10
) (
   output                  mipi_rst,
   output   [15:0]         cam1_rgb_control,
   output                  cam1_trigger_capture_frame,
   output                  cam1_continuous_capture_frame,
   output                  cam1_rgb_gray,
   output                  cam1_dma_init_done,
   input   [31:0]          cam1_frames_per_second,
   input   [31:0]          debug_cam1_dma_fifo_rcount,
   input   [31:0]          debug_cam1_dma_fifo_wcount,
   input   [31:0]          debug_cam1_dma_status,
   output   [15:0]         cam2_rgb_control,
   output                  cam2_trigger_capture_frame,
   output                  cam2_continuous_capture_frame,
   output                  cam2_rgb_gray,
   output                  cam2_dma_init_done,
   input   [31:0]          cam2_frames_per_second,
   input   [31:0]          debug_cam2_dma_fifo_rcount,
   input   [31:0]          debug_cam2_dma_fifo_wcount,
   input   [31:0]          debug_cam2_dma_status,
   input   [31:0]          debug_fifo_status,
   input   [31:0]          debug_display_dma_fifo_rcount,
   input   [31:0]          debug_display_dma_fifo_wcount,
   input                   clk,
   input                   resetn,
   input  [ADDR_WIDTH-1:0] PADDR,
   input                   PSEL,
   input                   PENABLE,
   output                  PREADY,
   input                   PWRITE,
   input  [DATA_WIDTH-1:0] PWDATA,
   output [DATA_WIDTH-1:0] PRDATA,
   output                  PSLVERROR
);

///////////////////////////////////////////////////////////////////////////////

localparam [1:0] IDLE   = 2'b00,
                 SETUP  = 2'b01,
                 ACCESS = 2'b10;

reg [1:0]            busState, 
                     busNext;
reg [DATA_WIDTH-1:0] slaveReg [0:NUM_REG-1];
reg [DATA_WIDTH-1:0] slaveRegOut;
reg                  slaveReady;
wire                 actWrite,
                     actRead;
integer              byteIndex;

///////////////////////////////////////////////////////////////////////////////

   always@(posedge clk or negedge resetn)
   begin
      if(!resetn) 
         busState <= IDLE; 
      else
         busState <= busNext; 
   end

   always@(*)
   begin
      busNext = busState;
   
      case(busState)
         IDLE:
         begin
            if(PSEL && !PENABLE)
               busNext = SETUP;
            else
               busNext = IDLE;
         end
         SETUP:
         begin
            if(PSEL && PENABLE)
               busNext = ACCESS;
            else
               busNext = IDLE;
         end
         ACCESS:
         begin
            if(PREADY)
               busNext = IDLE;
            else
               busNext = ACCESS;
         end
         default:
         begin
            busNext = IDLE;
         end
      endcase
   end

   assign actWrite   = PWRITE  & (busState == ACCESS);
   assign actRead    = !PWRITE & (busState == ACCESS);
   assign PSLVERROR  = 1'b0; //FIXME
   assign PRDATA     = slaveRegOut;
   assign PREADY     = slaveReady & & (busState !== IDLE);

   always@ (posedge clk)
   begin
      slaveReady <= actWrite | actRead;
   end

   always@ (posedge clk or negedge resetn)
   begin
      if(!resetn)
         for(byteIndex = 0; byteIndex < NUM_REG; byteIndex = byteIndex + 1)
            slaveReg[byteIndex] <= {{DATA_WIDTH}{1'b0}};
      else begin
         for(byteIndex = 0; byteIndex < NUM_REG; byteIndex = byteIndex + 1)
            if(actWrite && PADDR[ADDR_WIDTH-1:0] == (byteIndex*4))
               slaveReg[byteIndex] <= PWDATA;
            else
               slaveReg[byteIndex] <= slaveReg[byteIndex];
      end
   end

   always@ (posedge clk or negedge resetn)
   begin
      if(!resetn)
         slaveRegOut <= {{DATA_WIDTH}{1'b0}};
      else begin
         if (actRead) begin
            case(PADDR[6:2])
               5'd9  : slaveRegOut <= 32'hABCD_5678;   //To verify correct slave read operation
               5'd10 : slaveRegOut <= debug_fifo_status;
               5'd11 : slaveRegOut <= debug_display_dma_fifo_rcount;
               5'd12 : slaveRegOut <= debug_display_dma_fifo_wcount;
               5'd13 : slaveRegOut <= cam1_frames_per_second;
               5'd14 : slaveRegOut <= debug_cam1_dma_fifo_rcount;
               5'd15 : slaveRegOut <= debug_cam1_dma_fifo_wcount;
               5'd16 : slaveRegOut <= debug_cam1_dma_status;
               5'd17 : slaveRegOut <= cam2_frames_per_second;
               5'd18 : slaveRegOut <= debug_cam2_dma_fifo_rcount;
               5'd19 : slaveRegOut <= debug_cam2_dma_fifo_wcount;
               5'd20 : slaveRegOut <= debug_cam2_dma_status;
               default: begin slaveRegOut <= slaveRegOut; end
            endcase
         end
         else
            slaveRegOut <= slaveRegOut;
      end
   end

   //custom logic starts here
   assign mipi_rst                        = slaveReg[0][0];
   assign cam1_rgb_control                = slaveReg[1][15:0];
   assign cam1_trigger_capture_frame      = slaveReg[2][0];
   assign cam1_continuous_capture_frame   = slaveReg[2][1];
   assign cam1_rgb_gray                   = slaveReg[3][0];
   assign cam1_dma_init_done              = slaveReg[4][0];
   assign cam2_rgb_control                = slaveReg[5][15:0];
   assign cam2_trigger_capture_frame      = slaveReg[6][0];
   assign cam2_continuous_capture_frame   = slaveReg[6][1];
   assign cam2_rgb_gray                   = slaveReg[7][0];
   assign cam2_dma_init_done              = slaveReg[8][0];
   
endmodule
