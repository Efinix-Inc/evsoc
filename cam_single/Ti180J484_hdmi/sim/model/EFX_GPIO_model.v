//--------------------------------------------------------------------------
// https://www.efinixinc.com
// Copyright@2019. All rights reserved. Efinix, Inc.
//--------------------------------------------------------------------------
// Module : EFX_GPIO_model
// Author : Bruce Chen
// Contact: brucec@efinixinc.com
// Version: V1.0
// Date   : Nov.18th.2019
//--------------------------------------------------------------------------
// Decription : Simulate model for Efinix Trion-1 GPIO
//--------------------------------------------------------------------------

`timescale 10ps/1ps

module EFX_GPIO_model
#(
parameter BUS_WIDTH   = 1           , // define ddio bus width
parameter TYPE        = "INOUT"     , // "IN"=input "OUT"=output "INOUT"=inout
parameter OUT_REG     = 1'b1        , // 1: enable 0: disable
parameter OUT_DDIO    = 1'b1        , // 1: enable 0: disable
parameter OUT_RESYNC  = 1'b1        , // 1: enable 0: disable
parameter OUTCLK_INV  = 1'b0        , // 1: enable 0: disable
parameter OE_REG      = 1'b1        , // 1: enable 0: disable
parameter IN_REG      = 1'b1        , // 1: enable 0: disable
parameter IN_DDIO     = 1'b1        , // 1: enable 0: disable
parameter IN_RESYNC   = 1'b1        , // 1: enable 0: disable
parameter INCLK_INV   = 1'b0          // 1: enable 0: disable
)
(
input     [BUS_WIDTH-1:0]  out_HI   , // tx HI data input from internal logic
input     [BUS_WIDTH-1:0]  out_LO   , // tx LO data input from internal logic
input                      outclk   , // tx data clk input from internal logic
input                      oe       , // tx data output enable from internal logic
output    [BUS_WIDTH-1:0]  in_HI    , // rx HI data output to internal logic
output    [BUS_WIDTH-1:0]  in_LO    , // rx LO data output to internal logic
input                      inclk    , // rx data clk input from internal logic
inout     [BUS_WIDTH-1:0]  io         // outside io signal
);

//-------------------------------------Main Code-------------------------------------
// clock mux
wire inclk_act;
wire outclk_act;
assign inclk_act = INCLK_INV ? ~inclk : inclk;
assign outclk_act = OUTCLK_INV ? ~outclk : outclk;

// Ouput Enable mux
reg oe_reg = 0;
wire oe_act;
always @ (posedge outclk_act) oe_reg <= oe;
assign oe_act = (TYPE == "IN") ? 1'b0 : ((TYPE == "OUT") ? 1'b1 : (OE_REG ? oe_reg : oe));

// Ouput data mux
reg  [BUS_WIDTH-1:0]  out_HI_reg = 'dz ;
wire [BUS_WIDTH-1:0]  out_HI_act;
reg  [BUS_WIDTH-1:0]  out_LO_resync = 0;
reg  [BUS_WIDTH-1:0]  out_LO_reg = 'dz;
wire [BUS_WIDTH-1:0]  out_LO_act;
wire [BUS_WIDTH-1:0]  out_io;

always @ (posedge outclk_act) out_HI_reg <= out_HI; //HI data clock at POS edge
always @ (posedge outclk_act) out_LO_resync <= out_LO; // LO data resync at POS edge
always @ (negedge outclk_act) out_LO_reg <= OUT_RESYNC ? out_LO_resync : out_LO; // LO data clock at POS edge

assign out_HI_act = OUT_REG ? out_HI_reg : out_HI;
assign out_LO_act = OUT_REG ? out_LO_reg : 1'b0;
assign out_io   = OUT_DDIO ? (outclk_act ? out_HI_act : out_LO_act) : out_HI_act;

// Input data mux
reg  [BUS_WIDTH-1:0]  in_HI_reg = 'dz;
wire [BUS_WIDTH-1:0]  in_HI_act;
reg  [BUS_WIDTH-1:0]  in_LO_resync = 0;
reg  [BUS_WIDTH-1:0]  in_LO_reg = 'dz;
wire [BUS_WIDTH-1:0]  in_LO_act;

always @ (posedge inclk_act) in_HI_reg <= io; //HI data clock at POS edge
always @ (negedge inclk_act) in_LO_reg <= io; //LO data clock at NEG edge
always @ (posedge inclk_act) in_LO_resync <= in_LO_reg;//LO resync at POS edge

assign in_HI_act = IN_REG ? in_HI_reg : io;
assign in_LO_act = (IN_REG & IN_DDIO) ? (IN_RESYNC ? in_LO_resync : in_LO_reg) : 1'b0;
assign in_HI = in_HI_act;
assign in_LO = in_LO_act;

// IO PIN assignment
assign io = oe_act ? out_io : {BUS_WIDTH{1'bz}};

endmodule