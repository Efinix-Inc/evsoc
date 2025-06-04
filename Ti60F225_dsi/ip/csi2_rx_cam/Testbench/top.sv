
// synopsys translate_off
`timescale 1 ns / 1 ps                                                  
// synopsys translate_on

module top #(   //csi2 example design
    // Video parameters
    parameter HSA                   = 5             ,
    parameter HBP                   = 5             ,
    parameter HFP                   = 1024          ,
    parameter HACT_CNT              = 1920          ,
    parameter VSA                   = 1             ,
    parameter VBP                   = 1             ,
    parameter VFP                   = 2             ,
    parameter VACT_CNT              = 1080          ,
    // efx_csi2_tx parameter:    
    parameter tLPX_NS               = 50            ,
    parameter tINIT_NS              = 100000        ,
    parameter tLP_EXIT_NS           = 100           ,
    parameter tCLK_ZERO_NS          = 262           ,
    parameter tCLK_TRAIL_NS         = 60            ,
    parameter tCLK_POST_NS          = 60            ,
    parameter tCLK_PRE_NS           = 10            ,
    parameter tCLK_PREPARE_NS       = 38            ,
    parameter tHS_PREPARE_NS        = 40            ,
    parameter tWAKEUP_NS            = 1000          ,
    parameter tHS_EXIT_NS           = 100           ,
    parameter tHS_ZERO_NS           = 105           ,
    parameter tHS_TRAIL_NS          = 60            ,
    parameter NUM_DATA_LANE         = 4             ,
    parameter HS_BYTECLK_MHZ        = 187           ,
    parameter CLOCK_FREQ_MHZ        = 100           ,
    parameter DPHY_CLOCK_MODE       = "Continuous"  ,
    parameter PACK_TYPE             = 4'b1111       ,
    parameter PIXEL_FIFO_DEPTH      = 2048          ,
    parameter ENABLE_VCX            = 0             ,
    parameter FRAME_MODE            = "GENERIC"     ,
    parameter ASYNC_STAGE           = 2             ,
    // csi2_rx_cam parameter:    
    parameter tCLK_TERM_EN_NS       = 38            ,
    parameter tD_TERM_EN_NS         = 35            ,
    parameter tHS_SETTLE_NS         = 85            ,
    parameter tHS_PREPARE_ZERO_NS   = 145           ,
    parameter AREGISTER             = 8             
)(
input           mipi_clk,   //100MHz
input           reset_n,  //sw5
output [4:0]    led,
input           pixel_clk,  //50Mhz
input           i_pll1_locked,
input           i_pll2_locked,
input           i_inject_err_n,
output          pll_rstn,

input           mipi_dphy_rx_clk_LP_P_IN,
input           mipi_dphy_rx_clk_LP_N_IN,
output          mipi_dphy_rx_clk_HS_TERM,
output          mipi_dphy_rx_clk_HS_ENA,
input           mipi_dphy_rx_clk_CLKOUT,

input   [7:0]   mipi_dphy_rx_data0_HS_IN,
input           mipi_dphy_rx_data0_LP_P_IN,
input           mipi_dphy_rx_data0_LP_N_IN,
output          mipi_dphy_rx_data0_RST,
output          mipi_dphy_rx_data0_HS_TERM,
output          mipi_dphy_rx_data0_HS_ENA,
output          mipi_dphy_rx_data0_FIFO_RD,
input           mipi_dphy_rx_data0_FIFO_EMPTY,
output          mipi_dphy_rx_data0_DLY_RST,
output          mipi_dphy_rx_data0_DLY_INC,
output          mipi_dphy_rx_data0_DLY_ENA,

input   [7:0]   mipi_dphy_rx_data1_HS_IN,
input           mipi_dphy_rx_data1_LP_P_IN,
input           mipi_dphy_rx_data1_LP_N_IN,
output          mipi_dphy_rx_data1_RST,
output          mipi_dphy_rx_data1_HS_TERM,
output          mipi_dphy_rx_data1_HS_ENA,
output          mipi_dphy_rx_data1_FIFO_RD,
input           mipi_dphy_rx_data1_FIFO_EMPTY,
output          mipi_dphy_rx_data1_DLY_RST,
output          mipi_dphy_rx_data1_DLY_INC,
output          mipi_dphy_rx_data1_DLY_ENA,

input   [7:0]   mipi_dphy_rx_data2_HS_IN,
input           mipi_dphy_rx_data2_LP_P_IN,
input           mipi_dphy_rx_data2_LP_N_IN,
output          mipi_dphy_rx_data2_RST,
output          mipi_dphy_rx_data2_HS_TERM,
output          mipi_dphy_rx_data2_HS_ENA,
output          mipi_dphy_rx_data2_FIFO_RD,
input           mipi_dphy_rx_data2_FIFO_EMPTY,
output          mipi_dphy_rx_data2_DLY_RST,
output          mipi_dphy_rx_data2_DLY_INC,
output          mipi_dphy_rx_data2_DLY_ENA,

input   [7:0]   mipi_dphy_rx_data3_HS_IN,
input           mipi_dphy_rx_data3_LP_P_IN,
input           mipi_dphy_rx_data3_LP_N_IN,
output          mipi_dphy_rx_data3_RST,
output          mipi_dphy_rx_data3_HS_TERM,
output          mipi_dphy_rx_data3_HS_ENA,
output          mipi_dphy_rx_data3_FIFO_RD,
input           mipi_dphy_rx_data3_FIFO_EMPTY,
output          mipi_dphy_rx_data3_DLY_RST,
output          mipi_dphy_rx_data3_DLY_INC,
output          mipi_dphy_rx_data3_DLY_ENA,

input           mipi_dphy_tx_SLOWCLK,
output          mipi_dphy_tx_HS_enable_C,
output  [7:0]   mipi_dphy_tx_clk_HS_OUT,
output          mipi_dphy_tx_clk_RST,
output          mipi_dphy_tx_clk_LP_P_OE,
output          mipi_dphy_tx_clk_LP_P_OUT,
output          mipi_dphy_tx_clk_LP_N_OE,
output          mipi_dphy_tx_clk_LP_N_OUT,

output          mipi_dphy_tx_data0_HS_OE,
output  [7:0]   mipi_dphy_tx_data0_HS_OUT,
output          mipi_dphy_tx_data0_RST,
output          mipi_dphy_tx_data0_LP_N_OE,
output          mipi_dphy_tx_data0_LP_N_OUT,
output          mipi_dphy_tx_data0_LP_P_OE,
output          mipi_dphy_tx_data0_LP_P_OUT,

output          mipi_dphy_tx_data1_HS_OE,
output  [7:0]   mipi_dphy_tx_data1_HS_OUT,
output          mipi_dphy_tx_data1_RST,
output          mipi_dphy_tx_data1_LP_N_OE,
output          mipi_dphy_tx_data1_LP_N_OUT,
output          mipi_dphy_tx_data1_LP_P_OE,
output          mipi_dphy_tx_data1_LP_P_OUT,

output          mipi_dphy_tx_data2_HS_OE,
output  [7:0]   mipi_dphy_tx_data2_HS_OUT,
output          mipi_dphy_tx_data2_RST,
output          mipi_dphy_tx_data2_LP_N_OE,
output          mipi_dphy_tx_data2_LP_N_OUT,
output          mipi_dphy_tx_data2_LP_P_OE,
output          mipi_dphy_tx_data2_LP_P_OUT,

output          mipi_dphy_tx_data3_HS_OE,
output  [7:0]   mipi_dphy_tx_data3_HS_OUT,
output          mipi_dphy_tx_data3_RST,
output          mipi_dphy_tx_data3_LP_N_OE,
output          mipi_dphy_tx_data3_LP_N_OUT,
output          mipi_dphy_tx_data3_LP_P_OE,
output          mipi_dphy_tx_data3_LP_P_OUT
);


assign  mipi_dphy_tx_clk_RST    = 1'b0;
assign  mipi_dphy_tx_data0_RST  = 1'b0;
assign  mipi_dphy_rx_data0_RST  = 1'b0;
assign  mipi_dphy_tx_data1_RST  = 1'b0;
assign  mipi_dphy_rx_data1_RST  = 1'b0;
assign  mipi_dphy_tx_data2_RST  = 1'b0;
assign  mipi_dphy_rx_data2_RST  = 1'b0;
assign  mipi_dphy_tx_data3_RST  = 1'b0;
assign  mipi_dphy_rx_data3_RST  = 1'b0;

logic        w_vsync;
logic        w_hsync;
logic        w_valid;
logic [9:0] w_out_x;
logic [9:0] w_out_y;


// Mapping to CSI RX
logic        w_rx_vsync;
logic        w_rx_hsync;
logic [1:0]  w_rx_vc;
logic [15:0] w_rx_word_count;
logic [63:0] w_rx_pixel_data;
logic        w_rx_pixel_data_valid;
logic [5:0]  w_rx_datatype;

logic        w_hsync_match;
logic        w_vsync_match;
logic        w_pdata_match;
logic        w_vdata_match;

logic        w_pll_locked;
logic        w_global_rstn;
logic        w_pixel_rstn;
logic [8:0]  w_frame_cnt;

////////////////////////////////////////////////////////////////
assign pll_rstn = reset_n;

// output indicator assignment

assign led[0] = w_frame_cnt[5];
assign led[1] = w_hsync_match;
assign led[2] = w_vsync_match;
assign led[3] = w_pdata_match;
assign led[4] = w_vdata_match;

assign w_pll_locked  = i_pll1_locked & i_pll2_locked;

reset_ctrl #(
    .NUM_RST       (2),
    .CYCLE         (4),
    .IN_RST_ACTIVE (2'b00),
    .OUT_RST_ACTIVE(2'b00)
) inst_reset_ctrl (
    .i_arst({2{w_global_rstn}}),
    .i_clk({
        mipi_dphy_tx_SLOWCLK,
        mipi_dphy_tx_SLOWCLK
    }),
    .o_srst({
        mipi_dphy_rx_reset_byte_HS_n,
        mipi_dphy_tx_reset_byte_HS_n
    })
);


wire [63:0] w_data_mask;
wire [5:0]  video_format;

////////// testcase specific /////////////////////////////////////////////
localparam PixelPerClock = 3'd2;
assign video_format  = 6'h24; ///RGB888
assign w_data_mask   = { {16{1'h0}},{48{1'h1}} }; // RGB888: pack type 48.

//////////////////////////////////////////////////////////////////////////

// logic to handle the init timing of dphy (100us).
localparam INIT_CLK_MHZ = HS_BYTECLK_MHZ;
localparam integer INIT_CLK_NS = 1000/(INIT_CLK_MHZ);
localparam integer INIT_CYCLE = (tINIT_NS / INIT_CLK_NS); //min=100us for init.

logic [31:0] w_init_cnt;
logic w_init_done;

always @ (posedge mipi_dphy_tx_SLOWCLK or negedge mipi_dphy_tx_reset_byte_HS_n) begin
    if (~mipi_dphy_tx_reset_byte_HS_n) begin
        w_init_cnt    <= 'd0;
    end
    else if (w_init_cnt < INIT_CYCLE) begin
        w_init_cnt    <= w_init_cnt + 'd1;
    end
end

assign w_init_done = (w_init_cnt == INIT_CYCLE);

csichk #(
    .MAX_HRES       (HACT_CNT       ),
    .MAX_VRES       (VACT_CNT       ),
    .HSP            (HSA            ),
    .HBP            (HBP            ),
    .HFP            (HFP            ),
    .VSP            (VSA            ),
    .VBP            (VBP            ),
    .VFP            (VFP            ),
    .PixelPerClock  (PixelPerClock  ),
    .FRAME_MODE     (FRAME_MODE     )
) csichk_inst (
    .i_arstn        (reset_n        ),
    .pll_locked     (w_pll_locked   ),
    .o_pixel_rstn   (w_pixel_rstn   ),
    .o_global_rstn  (w_global_rstn  ),
    
    .i_fb_clk       (mipi_clk       ),
    .i_sysclk       (pixel_clk      ),
    
    .o_vsync        (w_vsync        ),
    .o_hsync        (w_hsync        ),
    .o_valid        (w_valid        ),
    .o_out_x        (w_out_x        ),
    .o_out_y        (w_out_y        ),
    .i_data_mask    (w_data_mask    ),

    .i_inject_err1_n(i_inject_err_n ),
    .i_inject_err2_n(1'b1           ),
    .o_hsync_match  (w_hsync_match  ),
    .o_vsync_match  (w_vsync_match  ),
    .o_pdata_match  (w_pdata_match  ),
    .o_vdata_match  (w_vdata_match  ),
    .o_frame_cnt    (w_frame_cnt    ),
    
    .i_vsync        (w_rx_vsync           ),
    .i_hsync        (w_rx_hsync           ),                 
    .i_valid        (w_rx_pixel_data_valid),                 
    .i_pdata        (w_rx_pixel_data      ), 

    .i_init_done    (w_init_done    )
);



reg     [5:0]   r_tx_axi_araddr_1P;
reg             r_tx_axi_arvalid_1P;
wire            w_tx_axi_arready;
wire    [31:0]  w_tx_axi_rdata;
wire            w_tx_axi_rvalid;
reg             r_tx_axi_rready_1P;

// efx_csi2_tx #(
//     .tLPX_NS          (tLPX_NS          ),
//     .tINIT_NS         (tINIT_NS         ),
//     .tLP_EXIT_NS      (tLP_EXIT_NS      ),
//     .tCLK_ZERO_NS     (tCLK_ZERO_NS     ),
//     .tCLK_TRAIL_NS    (tCLK_TRAIL_NS    ),
//     .tCLK_POST_NS     (tCLK_POST_NS     ),
//     .tCLK_PRE_NS      (tCLK_PRE_NS      ),
//     .tCLK_PREPARE_NS  (tCLK_PREPARE_NS  ),
//     .tHS_PREPARE_NS   (tHS_PREPARE_NS   ),
//     .tWAKEUP_NS       (tWAKEUP_NS       ),
//     .tHS_EXIT_NS      (tHS_EXIT_NS      ),
//     .tHS_ZERO_NS      (tHS_ZERO_NS      ),
//     .tHS_TRAIL_NS     (tHS_TRAIL_NS     ),
//     .NUM_DATA_LANE    (NUM_DATA_LANE    ),
//     .HS_BYTECLK_MHZ   (HS_BYTECLK_MHZ   ),
//     .CLOCK_FREQ_MHZ   (CLOCK_FREQ_MHZ   ),
//     .DPHY_CLOCK_MODE  (DPHY_CLOCK_MODE  ),
//     .PACK_TYPE        (PACK_TYPE        ),
//     .PIXEL_FIFO_DEPTH (PIXEL_FIFO_DEPTH ),
//     .ENABLE_VCX       (ENABLE_VCX       ),
//     .FRAME_MODE       (FRAME_MODE       ),
//     .ASYNC_STAGE      (ASYNC_STAGE      )
// ) 
efx_csi2_tx_modelsim inst_efx_csi2_tx
(
    .reset_n            (w_global_rstn),
    .clk                (mipi_clk),
    .reset_byte_HS_n    (mipi_dphy_tx_reset_byte_HS_n),
    .clk_byte_HS        (mipi_dphy_tx_SLOWCLK),
    .reset_pixel_n      (w_pixel_rstn),
    .clk_pixel          (pixel_clk),
    // LVDS clock lane   
    .Tx_LP_CLK_P        (mipi_dphy_tx_clk_LP_P_OUT),
    .Tx_LP_CLK_P_OE     (mipi_dphy_tx_clk_LP_P_OE),
    .Tx_LP_CLK_N        (mipi_dphy_tx_clk_LP_N_OUT),
    .Tx_LP_CLK_N_OE     (mipi_dphy_tx_clk_LP_N_OE),
    .Tx_HS_C            (mipi_dphy_tx_clk_HS_OUT),
    .Tx_HS_enable_C     (mipi_dphy_tx_HS_enable_C),
    
    // ----- DLane 0 -----------
    // LVDS data lane
    .Tx_LP_D_P          ({mipi_dphy_tx_data3_LP_P_OUT, mipi_dphy_tx_data2_LP_P_OUT, mipi_dphy_tx_data1_LP_P_OUT, mipi_dphy_tx_data0_LP_P_OUT}),
    .Tx_LP_D_P_OE       ({mipi_dphy_tx_data3_LP_P_OE, mipi_dphy_tx_data2_LP_P_OE, mipi_dphy_tx_data1_LP_P_OE, mipi_dphy_tx_data0_LP_P_OE}),
    .Tx_LP_D_N          ({mipi_dphy_tx_data3_LP_N_OUT, mipi_dphy_tx_data2_LP_N_OUT, mipi_dphy_tx_data1_LP_N_OUT, mipi_dphy_tx_data0_LP_N_OUT}),
    .Tx_LP_D_N_OE       ({mipi_dphy_tx_data3_LP_N_OE, mipi_dphy_tx_data2_LP_N_OE, mipi_dphy_tx_data1_LP_N_OE, mipi_dphy_tx_data0_LP_N_OE}),
    .Tx_HS_D_0          (mipi_dphy_tx_data0_HS_OUT),
    .Tx_HS_D_1          (mipi_dphy_tx_data1_HS_OUT),
    .Tx_HS_D_2          (mipi_dphy_tx_data2_HS_OUT),
    .Tx_HS_D_3          (mipi_dphy_tx_data3_HS_OUT),
    .Tx_HS_enable_D     ({mipi_dphy_tx_data3_HS_OE, mipi_dphy_tx_data2_HS_OE, mipi_dphy_tx_data1_HS_OE, mipi_dphy_tx_data0_HS_OE}),

    //AXI4-Lite Interface
    .axi_clk            (mipi_clk), 
    .axi_reset_n        (w_global_rstn),
    .axi_awaddr         (6'b0),//Write Address. byte address.
    .axi_awvalid        (1'b1),//Write address valid.
    .axi_awready        (),//Write address ready.
    .axi_wdata          (32'b0),//Write data bus.
    .axi_wvalid         (1'b0),//Write valid.
    .axi_wready         (),//Write ready.
    .axi_bvalid         (),//Write response valid.
    .axi_bready         (1'b0),//Response ready.      
    .axi_araddr         ('h0),//Read address. byte address.
    .axi_arvalid        ('h0),//Read address valid.
    .axi_arready        (w_tx_axi_arready),//Read address ready.
    .axi_rdata          (w_tx_axi_rdata),//Read data.
    .axi_rvalid         (w_tx_axi_rvalid),//Read valid.
    .axi_rready         (1'b1),//Read ready.
    
    .hsync_vc0          (w_hsync),
    .hsync_vc1          (1'b0),
    .hsync_vc2          (1'b0),
    .hsync_vc3          (1'b0),
    .hsync_vc4          (1'b0),
    .hsync_vc5          (1'b0),
    .hsync_vc6          (1'b0),
    .hsync_vc7          (1'b0),
    .hsync_vc8          (1'b0),
    .hsync_vc9          (1'b0),
    .hsync_vc10         (1'b0),
    .hsync_vc11         (1'b0),
    .hsync_vc12         (1'b0),
    .hsync_vc13         (1'b0),
    .hsync_vc14         (1'b0),
    .hsync_vc15         (1'b0),
    .vsync_vc0          (w_vsync),
    .vsync_vc1          (1'b0),
    .vsync_vc2          (1'b0),
    .vsync_vc3          (1'b0),
    .vsync_vc4          (1'b0),
    .vsync_vc5          (1'b0),
    .vsync_vc6          (1'b0),
    .vsync_vc7          (1'b0),
    .vsync_vc8          (1'b0),
    .vsync_vc9          (1'b0),
    .vsync_vc10         (1'b0),
    .vsync_vc11         (1'b0),
    .vsync_vc12         (1'b0),
    .vsync_vc13         (1'b0),
    .vsync_vc14         (1'b0),
    .vsync_vc15         (1'b0),

    .datatype           (video_format   ),
    .pixel_data         ({w_out_y[1:0],w_out_x[1:0],{3{w_out_y,w_out_x}}}),
    .pixel_data_valid   (w_valid        ),
    .haddr              (HACT_CNT       ),
    .line_num           ('h0            ),
    .frame_num          ('h0            ),  
    .irq                (               )
);

////////////////////////MIPI RX//////////////////////
reg     [5:0]   r_rx_axi_araddr_1P;
reg             r_rx_axi_arvalid_1P;
wire            w_rx_axi_arready;
wire    [31:0]  w_rx_axi_rdata;
wire            w_rx_axi_rvalid;
reg             r_rx_axi_rready_1P;

// csi2_rx_cam #(
//     .tLPX_NS               (tLPX_NS               ),
//     .tINIT_NS              (tINIT_NS              ),
//     .tCLK_TERM_EN_NS       (tCLK_TERM_EN_NS       ),
//     .tD_TERM_EN_NS         (tD_TERM_EN_NS         ),
//     .tHS_SETTLE_NS         (tHS_SETTLE_NS         ),
//     .tHS_PREPARE_ZERO_NS   (tHS_PREPARE_ZERO_NS   ),
//     .NUM_DATA_LANE         (NUM_DATA_LANE         ),
//     .HS_BYTECLK_MHZ        (HS_BYTECLK_MHZ        ),
//     .CLOCK_FREQ_MHZ        (CLOCK_FREQ_MHZ        ),
//     .DPHY_CLOCK_MODE       (DPHY_CLOCK_MODE       ),
//     .PIXEL_FIFO_DEPTH      (PIXEL_FIFO_DEPTH      ),
//     .AREGISTER             (AREGISTER             ),
//     .ENABLE_VCX            (ENABLE_VCX            ),
//     .FRAME_MODE            (FRAME_MODE            ),
//     .ASYNC_STAGE           (ASYNC_STAGE           ),
//     .PACK_TYPE             (PACK_TYPE             )
// ) 
csi2_rx_cam inst_efx_csi2_rx
(
    .reset_n            (w_global_rstn),
    .clk                (mipi_clk),
    .reset_byte_HS_n    (mipi_dphy_rx_reset_byte_HS_n),
    .clk_byte_HS        (mipi_dphy_rx_clk_CLKOUT),
    .reset_pixel_n      (w_pixel_rstn),
    .clk_pixel          (pixel_clk),  
    // LVDS clock lane   
    .Rx_LP_CLK_P        (mipi_dphy_rx_clk_LP_P_IN),
    .Rx_LP_CLK_N        (mipi_dphy_rx_clk_LP_N_IN),
    .Rx_HS_enable_C     (mipi_dphy_rx_clk_HS_ENA),
    .LVDS_termen_C      (mipi_dphy_rx_clk_HS_TERM),
    
    // ----- DLane 0 -----------
    // LVDS data lane
    .Rx_LP_D_P          ({mipi_dphy_rx_data3_LP_P_IN, mipi_dphy_rx_data2_LP_P_IN, mipi_dphy_rx_data1_LP_P_IN, mipi_dphy_rx_data0_LP_P_IN}),
    .Rx_LP_D_N          ({mipi_dphy_rx_data3_LP_N_IN, mipi_dphy_rx_data2_LP_N_IN, mipi_dphy_rx_data1_LP_N_IN, mipi_dphy_rx_data0_LP_N_IN}),
    .Rx_HS_D_0          (mipi_dphy_rx_data0_HS_IN),
    .Rx_HS_D_1          (mipi_dphy_rx_data1_HS_IN), 
    .Rx_HS_D_2          (mipi_dphy_rx_data2_HS_IN),
    .Rx_HS_D_3          (mipi_dphy_rx_data3_HS_IN),
    .Rx_HS_enable_D     ({mipi_dphy_rx_data3_HS_ENA, mipi_dphy_rx_data2_HS_ENA, mipi_dphy_rx_data1_HS_ENA, mipi_dphy_rx_data0_HS_ENA}),
    .LVDS_termen_D      ({mipi_dphy_rx_data3_HS_TERM, mipi_dphy_rx_data2_HS_TERM, mipi_dphy_rx_data1_HS_TERM, mipi_dphy_rx_data0_HS_TERM}),
    .fifo_rd_enable     ({mipi_dphy_rx_data3_FIFO_RD, mipi_dphy_rx_data2_FIFO_RD, mipi_dphy_rx_data1_FIFO_RD, mipi_dphy_rx_data0_FIFO_RD}),
    .fifo_rd_empty      ({mipi_dphy_rx_data3_FIFO_EMPTY, mipi_dphy_rx_data2_FIFO_EMPTY, mipi_dphy_rx_data1_FIFO_EMPTY, mipi_dphy_rx_data0_FIFO_EMPTY}),
    
    .DLY_enable_D       (),
    .DLY_inc_D          (),
    .u_dly_enable_D     (),
    .u_dly_inc_D        (),
    
    //AXI4-Lite Interface
    .axi_clk                (mipi_clk               ),
    .axi_reset_n            (w_global_rstn          ),
    .axi_awaddr             (6'b0                   ),//Write Address. byte address.
    .axi_awvalid            (1'b0                   ),//Write address valid.
    .axi_awready            (                       ),//Write address ready.
    .axi_wdata              (32'b0                  ),//Write data bus.
    .axi_wvalid             (1'b0                   ),//Write valid.
    .axi_wready             (                       ),//Write ready.           
    .axi_bvalid             (                       ),//Write response valid.
    .axi_bready             (1'b0                   ),//Response ready.      
    .axi_araddr             (r_rx_axi_araddr_1P     ),//Read address. byte address.
    .axi_arvalid            (r_rx_axi_arvalid_1P    ),//Read address valid.
    .axi_arready            (w_rx_axi_arready       ),//Read address ready.
    .axi_rdata              (w_rx_axi_rdata         ),//Read data.
    .axi_rvalid             (w_rx_axi_rvalid        ),//Read valid.
    .axi_rready             (1'b1                   ),//Read ready.

    .hsync_vc0              (w_rx_hsync             ),
    .hsync_vc1              (                       ),
    .hsync_vc2              (                       ),
    .hsync_vc3              (                       ),
    .hsync_vc4              (                       ),
    .hsync_vc5              (                       ),
    .hsync_vc6              (                       ),
    .hsync_vc7              (                       ),
    .hsync_vc8              (                       ),
    .hsync_vc9              (                       ),
    .hsync_vc10             (                       ),
    .hsync_vc11             (                       ),
    .hsync_vc12             (                       ),
    .hsync_vc13             (                       ),
    .hsync_vc14             (                       ),
    .hsync_vc15             (                       ),
    .vsync_vc0              (w_rx_vsync             ),
    .vsync_vc1              (                       ),
    .vsync_vc2              (                       ),
    .vsync_vc3              (                       ),
    .vsync_vc4              (                       ),
    .vsync_vc5              (                       ),
    .vsync_vc6              (                       ),
    .vsync_vc7              (                       ),
    .vsync_vc8              (                       ),
    .vsync_vc9              (                       ),
    .vsync_vc10             (                       ),
    .vsync_vc11             (                       ),
    .vsync_vc12             (                       ),
    .vsync_vc13             (                       ),
    .vsync_vc14             (                       ),
    .vsync_vc15             (                       ),

    .vc                     (w_rx_vc                ),
    .vcx                    (                       ),
    .word_count             (w_rx_word_count        ),
    .shortpkt_data_field    (                       ),
    .datatype               (w_rx_datatype          ),
    .pixel_per_clk          (                       ),
    .pixel_data             (w_rx_pixel_data        ),
    .pixel_data_valid       (w_rx_pixel_data_valid  ),
    .irq                    (                       )
);

endmodule
