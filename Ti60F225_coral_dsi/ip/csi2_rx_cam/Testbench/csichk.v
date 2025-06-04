
module csichk # (

parameter MAX_HRES      = 11'd1080  ,
parameter MAX_VRES      = 11'd1920  ,
parameter HSP           = 10'd100   ,
parameter HBP           = 10'd100   ,
parameter HFP           = 10'd250   ,
parameter VSP           = 10'd3     ,
parameter VBP           = 10'd5     ,
parameter VFP           = 11'd6     ,
parameter PixelPerClock = 3'd1      ,
parameter FRAME_MODE    = "GENERIC"     //1-ACCURATE, 0-GENERIC
) 
(
    input               i_arstn,
    input               pll_locked,
    output              o_pixel_rstn,
    output              o_global_rstn,

    input               i_fb_clk,
    input               i_sysclk,

    output              o_vsync,
    output              o_hsync,
    output              o_valid,
    output [9:0]        o_out_x,
    output [9:0]        o_out_y,
    input  [63:0]       i_data_mask,

    input               i_inject_err1_n,
    input               i_inject_err2_n,
    output              o_hsync_match,
    output              o_vsync_match,
    output              o_pdata_match,
    output              o_vdata_match,
    output [ 8:0]       o_frame_cnt,

    input               i_vsync,
    input               i_hsync,
    input               i_valid,
    input [63:0]        i_pdata,

    input               i_init_done
    
//// axi 
//	input		        i_axi_awready,
//	input		        i_axi_wready,
//	input		        i_axi_bvalid,
//	output [6:0]        o_axi_awaddr,
//	output              o_axi_awvalid,
//	output [31:0]       o_axi_wdata,
//	output   	        o_axi_wvalid,
//	output   	        o_axi_bready,
//	
//	input		        i_axi_arready,
//	input		[31:0]  i_axi_rdata,
//	input		        i_axi_rvalid,
//	output 	[6:0]       o_axi_araddr,
//	output 	            o_axi_arvalid,
//	output 	            o_axi_rready
    
    
);

localparam RESET_COUNT          = 26;
localparam RELEASE_RESET_ALL    = 26'd1500;


reg         r_rstn_video;
reg  [ 8:0] r_frame_cnt ;
reg  [25:0] r_rst_cnt   ;
reg         global_rstn ;
wire        w_confdone  ;

////////////////////////////////////////////////////////////////
// System & Debugger
wire        w_cam_arstn;
wire        w_cam_arst;
wire        w_sysclk_arstn;
wire        w_sysclk_arst;
wire        w_sysclkdiv2_arstn;
wire        w_sysclkdiv2_arst;
wire        w_fb_clk_arstn;
wire        w_fb_clk_arst;
////////////////////////////////////////////////////////////////
reg         r_vs_p1 = 0;
reg         r_hs_p1 = 0;
reg         r_de_p1;
reg [63:0]  r_pdata_p1, r_pdata_p2;


wire         w_tx_vsync_int;
wire         w_tx_hsync_int;
wire         w_tx_valid_int;
wire [9:0]   w_tx_out_x_int;
wire [9:0]   w_tx_out_y_int;

reg         r_tx_vsync_p1;
reg         r_tx_hsync_p1;
reg         r_tx_valid_p1;
reg [9:0]   r_tx_out_x_p1;
reg [9:0]   r_tx_out_y_p1;

reg         r_tx_vsync_p2;
reg         r_tx_hsync_p2;
reg         r_tx_valid_p2;
reg [9:0]   r_tx_out_x_p2;
reg [9:0]   r_tx_out_y_p2;

reg         r_tx_vsync_p3;
reg         r_tx_hsync_p3;
reg         r_tx_valid_p3;
reg [9:0]   r_tx_out_x_p3;
reg [9:0]   r_tx_out_y_p3;

reg         r_tx_vsync_p4;
reg         r_tx_hsync_p4;
reg         r_tx_valid_p4;
reg [9:0]   r_tx_out_x_p4;
reg [9:0]   r_tx_out_y_p4;

assign o_frame_cnt = r_frame_cnt;
assign o_global_rstn = global_rstn;
assign o_pixel_rstn = r_rstn_video;

reset_ctrl #(
    .NUM_RST       (4),
    .CYCLE         (4),
    .IN_RST_ACTIVE (4'b0000),
    .OUT_RST_ACTIVE(4'b1010)
) inst_reset_ctrl (
    .i_arst({4{global_rstn}}),
    .i_clk({
        {2{i_sysclk}}, {2{i_fb_clk}}
    }),
    .o_srst({
        w_sysclk_arst,
        w_sysclk_arstn,
        w_fb_clk_arst,
        w_fb_clk_arstn
    })
);

////////////////////////////////////////////////////////////////
// vga_gen for DSI TX
////////////////////////////////////////////////////////////////
vga_gen #(
    .H_SyncPulse    (HSP),
    .H_BackPorch    (HBP),
    .H_ActivePix    (MAX_HRES),
    .H_FrontPorch   (HFP),
    .V_SyncPulse    (VSP),
    .V_BackPorch    (VBP),
    .V_ActivePix    (MAX_VRES),
    .V_FrontPorch   (VFP),
    .P_Cnt          (3'd1),
    .PixelPerClock  (PixelPerClock)
) vga_gen_inst (
    .in_pclk        (i_sysclk),
    .in_rstn        (w_confdone & w_sysclk_arstn & i_init_done),

    .out_x          (w_tx_out_x_int),
    .out_y          (w_tx_out_y_int),
    .out_de         (),
    .out_valid      (w_tx_valid_int),
    .out_hs         (w_tx_hsync_int),
    .out_vs         (w_tx_vsync_int)
);

assign o_vsync = r_tx_vsync_p4;
assign o_hsync = r_tx_hsync_p4;
assign o_valid = r_tx_valid_p4;
assign o_out_x = r_tx_out_x_p4;
assign o_out_y = r_tx_out_y_p4;

always @(negedge w_sysclk_arstn or posedge i_sysclk) begin
    if (~w_sysclk_arstn) begin
        r_tx_vsync_p1   <= 'b0;
        r_tx_hsync_p1   <= 'b0;
        r_tx_valid_p1   <= 'b0;
        r_tx_out_x_p1   <= 'b0;
        r_tx_out_y_p1   <= 'b0;

        r_tx_vsync_p2   <= 'b0;
        r_tx_hsync_p2   <= 'b0;
        r_tx_valid_p2   <= 'b0;
        r_tx_out_x_p2   <= 'b0;
        r_tx_out_y_p2   <= 'b0;

        r_tx_vsync_p3   <= 'b0;
        r_tx_hsync_p3   <= 'b0;
        r_tx_valid_p3   <= 'b0;
        r_tx_out_x_p3   <= 'b0;
        r_tx_out_y_p3   <= 'b0;

        r_tx_vsync_p4   <= 'b0;
        r_tx_hsync_p4   <= 'b0;
        r_tx_valid_p4   <= 'b0;
        r_tx_out_x_p4   <= 'b0;
        r_tx_out_y_p4   <= 'b0;

    end else begin
        r_tx_vsync_p1   <= w_tx_vsync_int;
        r_tx_hsync_p1   <= w_tx_hsync_int;
        r_tx_valid_p1   <= w_tx_valid_int;
        r_tx_out_x_p1   <= w_tx_out_x_int;
        r_tx_out_y_p1   <= w_tx_out_y_int;

        r_tx_vsync_p2   <= r_tx_vsync_p1;
        r_tx_hsync_p2   <= r_tx_hsync_p1;
        r_tx_valid_p2   <= r_tx_valid_p1;
        r_tx_out_x_p2   <= r_tx_out_x_p1;
        r_tx_out_y_p2   <= r_tx_out_y_p1;

        r_tx_vsync_p3   <= r_tx_vsync_p2;
        r_tx_hsync_p3   <= r_tx_hsync_p2;
        r_tx_valid_p3   <= r_tx_valid_p2;
        r_tx_out_x_p3   <= r_tx_out_x_p2;
        r_tx_out_y_p3   <= r_tx_out_y_p2;

        r_tx_vsync_p4   <= r_tx_vsync_p3;
        r_tx_hsync_p4   <= r_tx_hsync_p3;
        r_tx_valid_p4   <= r_tx_valid_p3;
        r_tx_out_x_p4   <= r_tx_out_x_p3;
        r_tx_out_y_p4   <= r_tx_out_y_p3;

    end
end

always @(negedge w_sysclk_arstn or posedge i_sysclk) begin
    if (~w_sysclk_arstn) begin
        r_rstn_video    <= 1'b0;
        r_frame_cnt     <= {9{1'b0}};
    end else if (w_confdone & i_init_done) begin
        if (r_tx_vsync_p1 && ~w_tx_vsync_int)   r_frame_cnt  <= r_frame_cnt + 1'b1;
        if (r_frame_cnt == 1'b1)                r_rstn_video <= 1'b1;
    end
end


////////////////////////////////////////////////////////////////
// vga_gen comparator for DSI RX
////////////////////////////////////////////////////////////////

wire        w_vsync;
wire        w_hsync;
wire        w_valid;
wire [9:0]  w_out_x;
wire [9:0]  w_out_y;


reg r_vcomp_start;
reg r_hsync_match;
reg r_vsync_match;
reg r_pdata_match;
reg r_vdata_match;

wire [63:0] w_pdata;

assign w_pdata = ({w_out_y[1:0],w_out_x[1:0],{3{w_out_y,w_out_x}}} & i_data_mask);

assign o_hsync_match = r_hsync_match ;
assign o_vsync_match = r_vsync_match ;
assign o_pdata_match = r_pdata_match ;
assign o_vdata_match = r_vdata_match ;

/// hsync and vsync counter compare:

reg [11:0]    r_tx_hsync_cnt;
reg [11:0]    r_tx_vsync_cnt;
reg [11:0]    r_tx_vdata_cnt;
reg [11:0]    r_rx_hsync_cnt;
reg [11:0]    r_rx_vsync_cnt;
reg [11:0]    r_rx_vdata_cnt;
reg           w_valid_p1;

always @(negedge w_sysclk_arstn or posedge i_sysclk) begin
    if (~w_sysclk_arstn) begin
        r_vcomp_start   <= 1'b0;
    end else if (i_vsync) begin
        r_vcomp_start   <= 1'b1;
    end
    
    if (~w_sysclk_arstn) begin
        r_pdata_match   <= 1'b0;
    end else if (w_valid) begin
        if (r_pdata_p2 == w_pdata) begin
            r_pdata_match   <= 1'b1;
        end else begin
            r_pdata_match   <= 1'b0;
        end
    end

    if (~w_sysclk_arstn) begin
        r_vdata_match   <= 1'b0;
    end else if (o_pixel_rstn & (r_tx_vsync_p3 & ~r_tx_vsync_p4)) begin
        if (r_tx_vdata_cnt == r_rx_vdata_cnt) begin
            r_vdata_match   <= 1'b1;
        end else begin
            r_vdata_match   <= 1'b0;
        end
    end
    
end

vga_chk #(
    .H_SyncPulse    (HSP),
    .H_BackPorch    (HBP),
    .H_ActivePix    (MAX_HRES),
    .H_FrontPorch   (HFP),
    .V_SyncPulse    (VSP),
    .V_BackPorch    (VBP),
    .V_ActivePix    (MAX_VRES),
    .V_FrontPorch   (VFP),
    .P_Cnt          (3'd1),
    .PixelPerClock  (PixelPerClock)
) vga_chk_inst (
    .in_pclk        (i_sysclk),
    .in_rstn        (r_vcomp_start),
    .in_datavalid   (i_valid),

    .out_x          (w_out_x),
    .out_y          (w_out_y),
    .out_de         (),
    .out_valid      (w_valid),
    .out_hs         (w_hsync),
    .out_vs         (w_vsync)
);

always @(negedge w_sysclk_arstn or posedge i_valid) begin
    if (~w_sysclk_arstn)     r_rx_vdata_cnt  <= 'h0;
    else                     r_rx_vdata_cnt  <= r_rx_vdata_cnt + 1;
end


always @(negedge w_sysclk_arstn or posedge o_valid) begin
    if (~w_sysclk_arstn)     r_tx_vdata_cnt  <= 'h0;
    else if (o_pixel_rstn)   r_tx_vdata_cnt  <= r_tx_vdata_cnt + 1;
end


always @(negedge w_sysclk_arstn or posedge i_hsync) begin
    if (~w_sysclk_arstn)    r_rx_hsync_cnt  <= 'h0;
    else                    r_rx_hsync_cnt  <= r_rx_hsync_cnt + 1;
end


generate if (FRAME_MODE == "ACCURATE") begin
// accurate model require hsync toggle every lines..
always @(negedge w_sysclk_arstn or negedge w_hsync) begin
    if (~w_sysclk_arstn)        r_tx_hsync_cnt  <= 'h1;
    else if (~i_inject_err1_n)  r_tx_hsync_cnt  <= 'h1;
    else                        r_tx_hsync_cnt  <= r_tx_hsync_cnt + 1;
end

end
else begin
// generic model require hsync toggle only when data is valid lines..
always @(negedge w_sysclk_arstn or negedge w_valid) begin
    if (~w_sysclk_arstn)        r_tx_hsync_cnt  <= 'h1;
    else if (~i_inject_err1_n)  r_tx_hsync_cnt  <= 'h1;
    else                        r_tx_hsync_cnt  <= r_tx_hsync_cnt + 1;
end

end 
endgenerate

always @(negedge w_sysclk_arstn or posedge i_vsync) begin
    if (~w_sysclk_arstn)    r_rx_vsync_cnt  <= 'h0;
    else                    r_rx_vsync_cnt  <= r_rx_vsync_cnt + 1;
end

always @(negedge w_sysclk_arstn or posedge w_vsync) begin
    if (~w_sysclk_arstn)        r_tx_vsync_cnt  <= 'h0;
    else if (~i_inject_err2_n)  r_tx_vsync_cnt  <= 'h1;
    else                        r_tx_vsync_cnt  <= r_tx_vsync_cnt + 1;
end

always @(negedge w_sysclk_arstn or posedge i_sysclk) begin
    if (~w_sysclk_arstn)    r_pdata_p1  <= 'h0;
    else                    r_pdata_p1  <= i_pdata;
    if (~w_sysclk_arstn)    r_pdata_p2  <= 'h0;
    else                    r_pdata_p2  <= r_pdata_p1;

    if (~w_sysclk_arstn)    w_valid_p1  <= 'h0;
    else                    w_valid_p1  <= w_valid;
end

always @(negedge w_sysclk_arstn or posedge i_sysclk) begin
    if (~w_sysclk_arstn) begin
        r_vsync_match   <= 1'b0;
    end else if (w_valid & ~w_valid_p1) begin
        if (r_tx_vsync_cnt == r_rx_vsync_cnt) begin
            r_vsync_match   <= 1'b1;
        end else begin
            r_vsync_match   <= 1'b0;
        end
    end
    if (~w_sysclk_arstn) begin
        r_hsync_match   <= 1'b0;
    end else if (w_valid & ~w_valid_p1) begin
        if (r_tx_hsync_cnt == r_rx_hsync_cnt) begin
            r_hsync_match   <= 1'b1;
        end else begin
            r_hsync_match   <= 1'b0;
        end
    end
end

/// reset release control.. 

always @(negedge i_arstn or posedge i_fb_clk) begin
    if (~i_arstn) begin
        r_rst_cnt   <= {RESET_COUNT{1'b0}};
        global_rstn <= 1'b0;
    end else begin
        if (pll_locked) begin
            if (r_rst_cnt != {RESET_COUNT{1'b1}}) begin
                r_rst_cnt <= r_rst_cnt + 1'b1;
                if (r_rst_cnt == RELEASE_RESET_ALL) begin
                    global_rstn <= 1'b1;
                end
            end
        end else begin
            r_rst_cnt   <= {RESET_COUNT{1'b0}};
            global_rstn <= 1'b0;
        end
    end
end

assign w_confdone = 1'b1;

endmodule
