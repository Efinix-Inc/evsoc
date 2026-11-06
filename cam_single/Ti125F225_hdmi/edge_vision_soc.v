////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2026 Efinix Inc. All rights reserved.
// See https://github.com/Efinix-Inc/evsoc/blob/main/LICENSE.txt for details.
////////////////////////////////////////////////////////////////////////////////

`include "evsoc_defines.v"
`include "ip/efx_ddr3_controller_v2/ddr3_controller.vh"

module edge_vision_soc #(

    parameter MIPI_FRAME_WIDTH  = `MIPI_FRAME_WIDTH, // camera input Width
    parameter MIPI_FRAME_HEIGHT = `MIPI_FRAME_HEIGHT, // camera input Height

    // Ti125 DEVICE: DDR3L soft-controller bring-up and status LEDs.
    parameter int CLK_FREQ_HZ       = 100_000_000,
    parameter bit LED_ACTIVE_LOW    = 1'b0,
    parameter int POR_MS            = 50,
    parameter int CAL_RETRY_HOLD_MS = 5,
    parameter int CAL_RETRY_LIMIT   = 15,
    parameter int TICK_MS           = 125
) (
    // ---- clocks and reset ----
    input  wire                     i_axi0_mem_clk,          // DDR3 AXI + SoC   [PLL 1]
    input  wire                     core_clk,     // 200 MHz
    input  wire                     tdqss_clk,    // 400 MHz, 0 deg
    input  wire                     twd_clk,      // 400 MHz, 90 deg
    input  wire                     tac_clk,      // 400 MHz, dyn phase

    input  wire                     pll_ddr_LOCKED,
    input  wire [1:0]               i_sw,

    input  wire                     i_soc_clk,    // SoC io_systemClk
    input  wire                     i_sys_clk,      // peripherals

    input  wire                     prp_clk_2x,   // 2x, phase 0; PLL feedback

    // ---- DDR3 command / address ----
    output wire                     reset,
    output wire                     cs, ras, cas, we, cke, odt,
    output wire [15:0]              addr,
    output wire [2:0]               ba,

    // ---- DDR3 data mask / strobes / data ----
    output wire [`DRAM_GROUP-1:0]   o_dm_hi, o_dm_lo,
    input  wire [`DRAM_GROUP-1:0]   i_dqs_hi, i_dqs_lo,
    output wire [`DRAM_GROUP-1:0]   o_dqs_hi, o_dqs_lo, o_dqs_oe, o_dqs_n_oe,
    input  wire [`DRAM_WIDTH-1:0]   i_dq_hi, i_dq_lo,
    output wire [`DRAM_WIDTH-1:0]   o_dq_hi, o_dq_lo, o_dq_oe,

    // ---- PLL dynamic phase shift (read calibration) ----
    output wire [2:0]               shift,
    output wire [4:0]               shift_sel,
    output wire                     shift_ena,

    output wire [1:0]               o_led,

    // ---- JTAG_USER1 -> SoC debug ----
    input  wire                     jtag_inst1_CAPTURE, jtag_inst1_DRCK,
    input  wire                     jtag_inst1_RESET,   jtag_inst1_RUNTEST,
    input  wire                     jtag_inst1_SEL,     jtag_inst1_SHIFT,
    input  wire                     jtag_inst1_TCK,     jtag_inst1_TDI,
    input  wire                     jtag_inst1_TMS,     jtag_inst1_UPDATE,
    output wire                     jtag_inst1_TDO,

    // ---- SoC peripherals ----
    output wire                     system_spi_0_io_sclk_write,
    output wire                     system_spi_0_io_data_0_writeEnable,
    input  wire                     system_spi_0_io_data_0_read,
    output wire                     system_spi_0_io_data_0_write,
    output wire                     system_spi_0_io_data_1_writeEnable,
    input  wire                     system_spi_0_io_data_1_read,
    output wire                     system_spi_0_io_data_1_write,
    output wire                     system_spi_0_io_ss,

    output wire                     system_uart_0_io_txd,
    input  wire                     system_uart_0_io_rxd,

    // ---- camera / display clocks: a THIRD PLL (PLL 1 and 2 are full) --------
    input  wire                     i_pixel_clk,      // 100 MHz, CSI-2 + camera
    input  wire                     i_sys_clk_25mhz,       // 25.2 MHz: ADV7511 I2C setup
    input  wire                     pll_osc3_LOCKED,
    // HDMI pixel clocks from pll_osc2: 148.5 MHz for 1080p, 74.25 MHz for 720p
    input  wire                     i_hdmi_clk_148p5MHz,
    input  wire                     i_hdmi_clk_74p25MHz,
    input  wire                     pll_osc2_LOCKED,

    // ---- camera: MIPI RX Lanes on QSE2 ----
    // ---- cam_ck / cam_d0 / cam_d1, SERIAL_WIDTH 8) ---------------------------
    // Clock lane
    input  wire                     cam_ck_LP_P_IN,
    input  wire                     cam_ck_LP_N_IN,
    output wire                     cam_ck_HS_TERM,
    output wire                     cam_ck_HS_ENA,
    input  wire                     cam_ck_CLKOUT,        // lane byte clock (gclk)
    // Data lane 0
    input  wire [7:0]               cam_d0_HS_IN,
    input  wire                     cam_d0_LP_P_IN,
    input  wire                     cam_d0_LP_N_IN,
    output wire                     cam_d0_HS_TERM,
    output wire                     cam_d0_HS_ENA,
    output wire                     cam_d0_RST,
    output wire                     cam_d0_FIFO_RD,
    input  wire                     cam_d0_FIFO_EMPTY,
    // Data lane 1
    input  wire [7:0]               cam_d1_HS_IN,
    input  wire                     cam_d1_LP_P_IN,
    input  wire                     cam_d1_LP_N_IN,
    output wire                     cam_d1_HS_TERM,
    output wire                     cam_d1_HS_ENA,
    output wire                     cam_d1_RST,
    output wire                     cam_d1_FIFO_RD,
    input  wire                     cam_d1_FIFO_EMPTY,

    input  wire [7:0]               cam_ck_HS_IN,
    input  wire                     cam_ck_FIFO_EMPTY,
    input  wire                     cam_d0_CLKOUT,
    input  wire                     cam_d1_CLKOUT,

    output wire                     cam_ck_RST,
    output wire                     cam_ck_FIFO_RD,
    output wire                     cam_ck_LP_P_OUT, cam_ck_LP_N_OUT,
    output wire                     cam_ck_LP_P_OE,  cam_ck_LP_N_OE,
    output wire                     cam_ck_DLY_RST,  cam_ck_DLY_INC, cam_ck_DLY_ENA,
    output wire                     cam_d0_LP_P_OUT, cam_d0_LP_N_OUT,
    output wire                     cam_d0_LP_P_OE,  cam_d0_LP_N_OE,
    output wire                     cam_d0_DLY_RST,  cam_d0_DLY_INC, cam_d0_DLY_ENA,
    output wire                     cam_d1_LP_P_OUT, cam_d1_LP_N_OUT,
    output wire                     cam_d1_LP_P_OE,  cam_d1_LP_N_OE,
    output wire                     cam_d1_DLY_RST,  cam_d1_DLY_INC, cam_d1_DLY_ENA,

    // ---- camera I2C and reset ---------------------------------
    input  wire                     i_cam_sda,
    output wire                     o_cam_sda_oe,
    input  wire                     i_cam_scl,
    output wire                     o_cam_scl_oe,
    output wire                     o_cam_rstn,

    // ---- HDMI: ADV7511 on the QSE daughter card ---------------
    input  wire                     i_hdmi_sda,
    output wire                     o_hdmi_sda_oe,
    input  wire                     i_hdmi_scl,
    output wire                     o_hdmi_scl_oe,
    
    output wire                     hdmi_yuv_vs,
    output wire                     hdmi_yuv_hs,
    
    output wire                     hdmi_yuv_de,
    output wire [15:0]              hdmi_yuv_data
);

////////////////////////////////////////
// Resolution Parameter (Vesa Standard)
///////////////////////////////////////
wire w_hdmi_clk;

`ifdef Full_HD_1920x1080_60Hz

    localparam  FRAME_WIDTH     = 1920;
    localparam  FRAME_HEIGHT    = 1080;

    localparam  VIDEO_MAX_HRES  = 11'd1920;
    localparam  VIDEO_HSP       = 8'd44;
    localparam  VIDEO_HBP       = 8'd148;
    localparam  VIDEO_HFP       = 8'd88;

    localparam  VIDEO_MAX_VRES  = 11'd1080;
    localparam  VIDEO_VSP       = 6'd5;
    localparam  VIDEO_VBP       = 6'd36;
    localparam  VIDEO_VFP       = 6'd4;

    assign w_hdmi_clk = i_hdmi_clk_148p5MHz; // HDMI Clock 148.5 MHz
`endif

`ifdef HD_Ready_1280x720_60Hz
    localparam  FRAME_WIDTH     = 1280;
    localparam  FRAME_HEIGHT    = 720;

    localparam  VIDEO_MAX_HRES  = 11'd1280;
    localparam  VIDEO_HSP       = 8'd40;
    localparam  VIDEO_HBP       = 8'd220;
    localparam  VIDEO_HFP       = 8'd110;

    localparam  VIDEO_MAX_VRES  = 11'd720;
    localparam  VIDEO_VSP       = 6'd5;
    localparam  VIDEO_VBP       = 6'd20;
    localparam  VIDEO_VFP       = 6'd5;

    assign w_hdmi_clk = i_hdmi_clk_74p25MHz; // HDMI Clock 74.250 MHz
`endif

`ifdef SD_640x480_60Hz
    localparam  FRAME_WIDTH     = 640;
    localparam  FRAME_HEIGHT    = 480;

    localparam  VIDEO_MAX_HRES  = 11'd640;
    localparam  VIDEO_HSP       = 8'd96;
    localparam  VIDEO_HBP       = 8'd40;
    localparam  VIDEO_HFP       = 8'd8;

    localparam  VIDEO_MAX_VRES  = 11'd480;
    localparam  VIDEO_VSP       = 6'd2;
    localparam  VIDEO_VBP       = 6'd25;
    localparam  VIDEO_VFP       = 6'd2;

    assign w_hdmi_clk = i_sys_clk_25mhz; // HDMI Clock 25.2 MHz (Ti180: i_hdmi_clk_25p25MHz)
`endif

    //=========================================================================
    // Ti125 DEVICE: power-on reset, DDR3L calibration retry, SoC reset,
    // AXI bridge and DDR3L soft controller (unchanged from the Ti125 design).
    //=========================================================================

    //=========================================================================
    // Power-on reset.
    //=========================================================================
    localparam int POR_DIV = (CLK_FREQ_HZ / 1000) * POR_MS;
    localparam int POR_W   = $clog2(POR_DIV + 1);

    reg [POR_W-1:0] por_cnt;
    reg             por_done;
    always @(posedge i_axi0_mem_clk or negedge i_sw[0]) begin
        if (!i_sw[0]) begin
            por_cnt  <= '0;
            por_done <= 1'b0;
        end else if (!por_done) begin
            if (por_cnt == POR_W'(POR_DIV - 1)) por_done <= 1'b1;
            else                                por_cnt  <= por_cnt + 1'b1;
        end
    end

    wire sys_rst_n = i_sw[0] & por_done;

    //=========================================================================
    // CAL RETRY - fix for DDR calibration not passing on initial bitstream programming.
    //=========================================================================
    localparam int HOLD_DIV  = (CLK_FREQ_HZ / 1000) * CAL_RETRY_HOLD_MS;
    localparam int HOLD_W    = $clog2(HOLD_DIV + 1);
    localparam int CAL_DWELL = 1024;                  // ~10 us at 100 MHz
    localparam int DWELL_W   = $clog2(CAL_DWELL + 1);

    wire        w_cal_done, w_cal_pass;
    wire [7:0]  w_cal_fail_log;

    reg               ddr_rst_n;
    reg [HOLD_W-1:0]  hold_cnt;
    reg [DWELL_W-1:0] dwell_cnt;
    reg [4:0]         retry_cnt;
    wire retries_exhausted = (retry_cnt >= 5'(CAL_RETRY_LIMIT));

    always @(posedge i_axi0_mem_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            ddr_rst_n <= 1'b0;
            hold_cnt  <= '0;
            dwell_cnt <= '0;
            retry_cnt <= '0;
        end else if (!ddr_rst_n) begin
            dwell_cnt <= '0;
            if (hold_cnt == HOLD_W'(HOLD_DIV - 1)) begin
                hold_cnt  <= '0;
                ddr_rst_n <= 1'b1;
            end else begin
                hold_cnt <= hold_cnt + 1'b1;
            end
        end else if (w_cal_done && !w_cal_pass && !retries_exhausted) begin
            if (dwell_cnt == DWELL_W'(CAL_DWELL - 1)) begin
                dwell_cnt <= '0;
                ddr_rst_n <= 1'b0;
                retry_cnt <= retry_cnt + 1'b1;
            end else begin
                dwell_cnt <= dwell_cnt + 1'b1;
            end
        end else begin
            dwell_cnt <= '0;
        end
    end

    wire ddr_ready = ddr_rst_n & w_cal_done & w_cal_pass;

    //=========================================================================
    // cal_ena MUST be released once calibration completes.
    //=========================================================================
    reg cal_ena_r;
    always @(posedge i_axi0_mem_clk or negedge ddr_rst_n) begin
        if (!ddr_rst_n)      cal_ena_r <= 1'b1;
        else if (w_cal_done) cal_ena_r <= 1'b0;
    end

    //=========================================================================
    // SoC reset, so a memory failure can never lock the debugger out permanently.
    //=========================================================================
    reg [27:0] soc_to_cnt;
    reg        soc_to;
    always @(posedge i_axi0_mem_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            soc_to_cnt <= 28'd0;
            soc_to     <= 1'b0;
        end else if (!ddr_ready && !soc_to) begin
            if (&soc_to_cnt) soc_to     <= 1'b1;
            else             soc_to_cnt <= soc_to_cnt + 1'b1;
        end
    end

    wire soc_async_reset = ~(ddr_ready | soc_to);

    //=========================================================================
    // AXI4: bridge <-> DDR3 controller.
    // One SHARED address channel (ddr_axi_a*), ddr_axi_atype: 1 = write, 0 = read.
    //=========================================================================
    wire [7:0]               ddr_axi_aid;
    wire [31:0]              ddr_axi_aaddr;
    wire [7:0]               ddr_axi_alen;
    wire [2:0]               ddr_axi_asize;
    wire [1:0]               ddr_axi_aburst, ddr_axi_alock;
    wire                     ddr_axi_avalid, ddr_axi_aready, ddr_axi_atype;

    wire [7:0]               ddr_axi_wid;
    wire [`WFIFO_WIDTH-1:0]  ddr_axi_wdata;
    wire [`DM_BIT_WIDTH-1:0] ddr_axi_wstrb;
    wire                     ddr_axi_wlast, ddr_axi_wvalid, ddr_axi_wready;

    wire [7:0]               ddr_axi_rid;
    wire [`WFIFO_WIDTH-1:0]  ddr_axi_rdata;
    wire                     ddr_axi_rlast, ddr_axi_rvalid, ddr_axi_rready;
    wire [1:0]               ddr_axi_rresp;

    wire [7:0]               ddr_axi_bid;
    wire                     ddr_axi_bvalid, ddr_axi_bready;
    wire [1:0]               ddr_axi_bresp;

    //=========================================================================
    // AXI4: SoC memory port -> bridge (separate AW / AR)
    //=========================================================================
    wire         soc_aw_valid, soc_aw_ready, soc_aw_lock;
    wire [31:0]  soc_aw_addr;
    wire [7:0]   soc_aw_id, soc_aw_len;
    wire [2:0]   soc_aw_size;
    wire [1:0]   soc_aw_burst;

    wire         soc_ar_valid, soc_ar_ready, soc_ar_lock;
    wire [31:0]  soc_ar_addr;
    wire [7:0]   soc_ar_id, soc_ar_len;
    wire [2:0]   soc_ar_size;
    wire [1:0]   soc_ar_burst;

    wire         soc_w_valid, soc_w_ready, soc_w_last;
    wire [127:0] soc_w_data;
    wire [15:0]  soc_w_strb;

    wire         soc_r_valid, soc_r_ready, soc_r_last;
    wire [127:0] soc_r_data;
    wire [7:0]   soc_r_id;
    wire [1:0]   soc_r_resp;

    wire         soc_b_valid, soc_b_ready;
    wire [7:0]   soc_b_id;
    wire [1:0]   soc_b_resp;

    // The bridge wants full AXI4 decoration; the controller ignores these.
    wire [3:0]   soc_aw_cache,  soc_ar_cache;
    wire [2:0]   soc_aw_prot,   soc_ar_prot;
    wire [3:0]   soc_aw_qos,    soc_ar_qos;
    wire [3:0]   soc_aw_region, soc_ar_region;

    //=========================================================================
    // axi_full_to_half_duplex: full-duplex AXI4 -> shared address
    // channel (arw + payload_write == atype).
    //=========================================================================
    axi_full_to_half_duplex #(
        .DATA_WIDTH (128), .ADDR_WIDTH (32), .ID_WIDTH (8),
        // MUST be 1 due to DDR3 controller RLAST issue
        .MAX_OUTSTANDING_RD (1)
    ) u_axi_bridge (
        .clk (i_axi0_mem_clk), .rst (~sys_rst_n),                 // rst is active HIGH

        .io_ddr_arw_valid          (ddr_axi_avalid),
        .io_ddr_arw_ready          (ddr_axi_aready),
        .io_ddr_arw_payload_addr   (ddr_axi_aaddr),
        .io_ddr_arw_payload_id     (ddr_axi_aid),
        .io_ddr_arw_payload_len    (ddr_axi_alen),
        .io_ddr_arw_payload_size   (ddr_axi_asize),
        .io_ddr_arw_payload_burst  (ddr_axi_aburst),
        .io_ddr_arw_payload_lock   (ddr_axi_alock),
        .io_ddr_arw_payload_write  (ddr_axi_atype),

        .io_ddr_w_payload_id       (ddr_axi_wid),
        .io_ddr_w_valid            (ddr_axi_wvalid),
        .io_ddr_w_ready            (ddr_axi_wready),
        .io_ddr_w_payload_data     (ddr_axi_wdata),
        .io_ddr_w_payload_strb     (ddr_axi_wstrb),
        .io_ddr_w_payload_last     (ddr_axi_wlast),

        .io_ddr_b_valid            (ddr_axi_bvalid),
        .io_ddr_b_ready            (ddr_axi_bready),
        .io_ddr_b_payload_id       (ddr_axi_bid),

        .io_ddr_r_valid            (ddr_axi_rvalid),
        .io_ddr_r_ready            (ddr_axi_rready),
        .io_ddr_r_payload_data     (ddr_axi_rdata),
        .io_ddr_r_payload_id       (ddr_axi_rid),
        .io_ddr_r_payload_resp     (ddr_axi_rresp),
        .io_ddr_r_payload_last     (ddr_axi_rlast),

        .s_axi_awid    (soc_aw_id),     .s_axi_awaddr   (soc_aw_addr),
        .s_axi_awlen   (soc_aw_len),    .s_axi_awsize   (soc_aw_size),
        .s_axi_awburst (soc_aw_burst),  .s_axi_awlock   (soc_aw_lock),
        .s_axi_awcache (soc_aw_cache),  .s_axi_awprot   (soc_aw_prot),
        .s_axi_awqos   (soc_aw_qos),    .s_axi_awregion (soc_aw_region),
        .s_axi_awvalid (soc_aw_valid),  .s_axi_awready  (soc_aw_ready),

        .s_axi_wdata   (soc_w_data),    .s_axi_wstrb    (soc_w_strb),
        .s_axi_wlast   (soc_w_last),    .s_axi_wvalid   (soc_w_valid),
        .s_axi_wready  (soc_w_ready),

        .s_axi_bid     (soc_b_id),      .s_axi_bresp    (soc_b_resp),
        .s_axi_bvalid  (soc_b_valid),   .s_axi_bready   (soc_b_ready),

        .s_axi_arid    (soc_ar_id),     .s_axi_araddr   (soc_ar_addr),
        .s_axi_arlen   (soc_ar_len),    .s_axi_arsize   (soc_ar_size),
        .s_axi_arburst (soc_ar_burst),  .s_axi_arlock   (soc_ar_lock),
        .s_axi_arcache (soc_ar_cache),  .s_axi_arprot   (soc_ar_prot),
        .s_axi_arqos   (soc_ar_qos),    .s_axi_arregion (soc_ar_region),
        .s_axi_arvalid (soc_ar_valid),  .s_axi_arready  (soc_ar_ready),

        .s_axi_rid     (soc_r_id),      .s_axi_rdata    (soc_r_data),
        .s_axi_rresp   (soc_r_resp),    .s_axi_rlast    (soc_r_last),
        .s_axi_rvalid  (soc_r_valid),   .s_axi_rready   (soc_r_ready)
    );

    //=========================================================================
    // DDR3 soft controller
    //=========================================================================
    efx_ddr3_controller_v2 u_ddr3 (
        .clk (i_axi0_mem_clk), 
        .core_clk (core_clk), 
        .tdqss_clk (tdqss_clk),
        .twd_clk (twd_clk), 
        .tac_clk (tac_clk), 
        .reset_n (ddr_rst_n),

        .reset (reset), 
        .cs   (cs), 
        .ras  (ras), 
        .cas  (cas), 
        .we   (we),
        .cke  (cke), 
        .addr (addr), 
        .ba   (ba), 
        .odt  (odt),

        .o_dm_hi (o_dm_hi), 
        .o_dm_lo (o_dm_lo),
        .i_dqs_hi (i_dqs_hi), 
        .i_dqs_lo (i_dqs_lo),
        .i_dqs_n_hi ({`DRAM_GROUP{1'b0}}), 
        .i_dqs_n_lo ({`DRAM_GROUP{1'b0}}),
        .o_dqs_hi (o_dqs_hi), 
        .o_dqs_lo (o_dqs_lo),
        .o_dqs_n_hi (), 
        .o_dqs_n_lo (),
        .o_dqs_oe (o_dqs_oe), 
        .o_dqs_n_oe (o_dqs_n_oe),
        .i_dq_hi (i_dq_hi), 
        .i_dq_lo (i_dq_lo),
        .o_dq_hi (o_dq_hi), 
        .o_dq_lo (o_dq_lo), 
        .o_dq_oe (o_dq_oe),

        .shift (shift), .shift_sel (shift_sel), .shift_ena (shift_ena),
        .cal_ena (cal_ena_r), .cal_done (w_cal_done), .cal_pass (w_cal_pass),
        .cal_fail_log (w_cal_fail_log), .cal_shift_val (),

        .axi_aid (ddr_axi_aid), .axi_aaddr (ddr_axi_aaddr), .axi_alen (ddr_axi_alen),
        .axi_asize (ddr_axi_asize), .axi_aburst (ddr_axi_aburst),
        .axi_alock (ddr_axi_alock), .axi_avalid (ddr_axi_avalid),
        .axi_aready (ddr_axi_aready), .axi_atype (ddr_axi_atype),

        .axi_wid (ddr_axi_wid), .axi_wdata (ddr_axi_wdata), .axi_wstrb (ddr_axi_wstrb),
        .axi_wlast (ddr_axi_wlast), .axi_wvalid (ddr_axi_wvalid),
        .axi_wready (ddr_axi_wready),

        .axi_rid (ddr_axi_rid), .axi_rdata (ddr_axi_rdata), .axi_rlast (ddr_axi_rlast),
        .axi_rvalid (ddr_axi_rvalid), .axi_rready (ddr_axi_rready),
        .axi_rresp (ddr_axi_rresp),

        .axi_bid (ddr_axi_bid), .axi_bvalid (ddr_axi_bvalid), .axi_bresp (ddr_axi_bresp),
        .axi_bready (ddr_axi_bready)
    );

    wire io_peripheralReset;            // active high, SoC peripheral domain
    wire ddrm0_reset;                   // per-port reset, SoC OUTPUT

    //=========================================================================
    // i_sys_clk reset synchroniser.
    //=========================================================================
    wire prp_rst_in = io_peripheralReset | ddrm0_reset;

    reg [2:0] prp_rst_sync;
    always @(posedge i_sys_clk or posedge prp_rst_in) begin
        if (prp_rst_in) prp_rst_sync <= 3'b000;
        else            prp_rst_sync <= {prp_rst_sync[1:0], 1'b1};
    end
    wire soc_prp_reset_out = prp_rst_sync[2];    // active LOW
    wire soc_prp_reset = ~soc_prp_reset_out;     // active HIGH

////////////////
//Reset Related
//////////////////
wire                       w_sysclk_arstn;
wire                       w_sysclk_arst;

wire                       io_asyncResetn;

wire                       i_arstn;
wire                       mipi_rstn;

assign   io_asyncResetn   = ~soc_async_reset & pll_osc3_LOCKED & pll_osc2_LOCKED;
assign   w_sysclk_arst    = ~( io_asyncResetn );
assign   w_sysclk_arstn   = ~w_sysclk_arst;

assign   i_arstn          = (w_sysclk_arstn & (!mipi_rstn)) ;
assign   o_cam_rstn       = i_arstn;

wire    peripheralClk;
wire    peripheralReset;

assign peripheralClk   = i_sys_clk;          
assign peripheralReset = soc_prp_reset;     // SoC peripheral reset, synchronised to i_sys_clk


//////////////////////////////////////////////
// CSI controllers ouptut interface port
//////////////////////////////////////////////
localparam  CSI_RX_NUM_DATA_LANE =2;
localparam  CAM_PIXEL_RX_DATAWIDTH = 10;   //RAW10, RAW12
localparam  CAM_PIXEL_RX_MEM_DATAWIDTH = 8;

wire w_rx_out_de;
wire w_rx_out_vs;
wire w_rx_out_hs;
wire [CAM_PIXEL_RX_MEM_DATAWIDTH-1:0] w_rx_out_data_00;
wire [CAM_PIXEL_RX_MEM_DATAWIDTH-1:0] w_rx_out_data_01;
wire [CAM_PIXEL_RX_MEM_DATAWIDTH-1:0] w_rx_out_data_10;
wire [CAM_PIXEL_RX_MEM_DATAWIDTH-1:0] w_rx_out_data_11;
wire [5:0] rx_out_dt;

wire w_reset_pixel_n;
wire w_reset_byte_HS_n;

common_reset #(
    .NUM_RST          (1),
    .CYCLE            (3),
    .IN_RST_ACTIVE    (1'b0),
    .OUT_RST_ACTIVE   (1'b0)
) inst_pixel_clk_rst (
    .i_arst ({i_arstn}),
    .i_clk  ({i_pixel_clk}),
    .o_srst ({w_reset_pixel_n})
);

common_reset #(
    .NUM_RST          (1),
    .CYCLE            (3),
    .IN_RST_ACTIVE    (1'b0),
    .OUT_RST_ACTIVE   (1'b0)
) inst_rx_byteclk_rst (
    .i_arst ({i_arstn}),
    .i_clk  ({cam_ck_CLKOUT}),
    .o_srst ({w_reset_byte_HS_n})
);

// MIPI RX lanes: LP and HS lane data resynchronised onto the lane byte clock.
wire [7:0] w_cam_d0_HS_IN = cam_d0_HS_IN;
wire [7:0] w_cam_d1_HS_IN = cam_d1_HS_IN;

(* async_reg = "true" *) reg [1:0]  r_mipi_rx_data_LP_P_IN_0_1P, r_mipi_rx_data_LP_P_IN_0_2P;
(* async_reg = "true" *) reg [1:0]  r_mipi_rx_data_LP_N_IN_0_1P, r_mipi_rx_data_LP_N_IN_0_2P;
(* async_reg = "true" *) reg [15:0] r_mipi_rx_data_HS_IN_0_1P,   r_mipi_rx_data_HS_IN_0_2P;

always @(negedge w_reset_byte_HS_n or posedge cam_ck_CLKOUT) begin
    if (~w_reset_byte_HS_n) begin
        r_mipi_rx_data_LP_P_IN_0_1P <= 2'b0;
        r_mipi_rx_data_LP_N_IN_0_1P <= 2'b0;
        r_mipi_rx_data_HS_IN_0_1P   <= 16'b0;
        r_mipi_rx_data_LP_P_IN_0_2P <= 2'b0;
        r_mipi_rx_data_LP_N_IN_0_2P <= 2'b0;
        r_mipi_rx_data_HS_IN_0_2P   <= 16'b0;
    end else begin
        r_mipi_rx_data_LP_P_IN_0_1P <= {cam_d1_LP_P_IN, cam_d0_LP_P_IN};
        r_mipi_rx_data_LP_N_IN_0_1P <= {cam_d1_LP_N_IN, cam_d0_LP_N_IN};
        r_mipi_rx_data_HS_IN_0_1P   <= {w_cam_d1_HS_IN, w_cam_d0_HS_IN};
        r_mipi_rx_data_LP_P_IN_0_2P <= r_mipi_rx_data_LP_P_IN_0_1P;
        r_mipi_rx_data_LP_N_IN_0_2P <= r_mipi_rx_data_LP_N_IN_0_1P;
        r_mipi_rx_data_HS_IN_0_2P   <= r_mipi_rx_data_HS_IN_0_1P;
    end
end

wire       w_cam_ck_HS_ENA_0, w_cam_ck_HS_TERM_0;
wire [1:0] w_cam_d_HS_ENA_0;
assign cam_ck_HS_TERM = w_cam_ck_HS_ENA_0;
assign cam_ck_HS_ENA  = w_cam_ck_HS_ENA_0;
assign cam_d0_HS_TERM = w_cam_d_HS_ENA_0[0];
assign cam_d1_HS_TERM = w_cam_d_HS_ENA_0[1];
assign cam_d0_HS_ENA  = w_cam_d_HS_ENA_0[0];
assign cam_d1_HS_ENA  = w_cam_d_HS_ENA_0[1];
assign cam_d0_RST     = ~i_arstn;
assign cam_d1_RST     = ~i_arstn;

// Unused lane controls named in the peri.xml.
assign cam_ck_RST      = 1'b0;
assign cam_ck_FIFO_RD  = 1'b0;
assign {cam_ck_LP_P_OUT, cam_ck_LP_N_OUT, cam_ck_LP_P_OE, cam_ck_LP_N_OE} = 4'b0;
assign {cam_d0_LP_P_OUT, cam_d0_LP_N_OUT, cam_d0_LP_P_OE, cam_d0_LP_N_OE} = 4'b0;
assign {cam_d1_LP_P_OUT, cam_d1_LP_N_OUT, cam_d1_LP_P_OE, cam_d1_LP_N_OE} = 4'b0;
assign {cam_ck_DLY_RST, cam_ck_DLY_INC, cam_ck_DLY_ENA} = 3'b0;
assign {cam_d0_DLY_RST, cam_d0_DLY_INC, cam_d0_DLY_ENA} = 3'b0;
assign {cam_d1_DLY_RST, cam_d1_DLY_INC, cam_d1_DLY_ENA} = 3'b0;

wire [63:0] w_rx_data;
wire        w_rx_valid;
wire        w_rx_vs;
wire        w_rx_hs;

csi2_rx_cam inst_efx_csi2_rx0 (
    .reset_n          (i_arstn),
    .clk              (i_pixel_clk),
    .reset_byte_HS_n  (w_reset_byte_HS_n),
    .clk_byte_HS      (cam_ck_CLKOUT),
    .reset_pixel_n    (w_reset_pixel_n),
    .clk_pixel        (i_pixel_clk),

    .Rx_LP_CLK_P      (cam_ck_LP_P_IN),
    .Rx_LP_CLK_N      (cam_ck_LP_N_IN),
    .Rx_HS_enable_C   (w_cam_ck_HS_ENA_0),
    .LVDS_termen_C    (w_cam_ck_HS_TERM_0),

    .Rx_LP_D_P        (r_mipi_rx_data_LP_P_IN_0_2P),
    .Rx_LP_D_N        (r_mipi_rx_data_LP_N_IN_0_2P),
    .Rx_HS_D_0        (r_mipi_rx_data_HS_IN_0_2P[7:0]),
    .Rx_HS_D_1        (r_mipi_rx_data_HS_IN_0_2P[15:8]),
    .Rx_HS_enable_D   (w_cam_d_HS_ENA_0),
    .fifo_rd_enable   ({cam_d1_FIFO_RD,    cam_d0_FIFO_RD}),
    .fifo_rd_empty    ({cam_d1_FIFO_EMPTY, cam_d0_FIFO_EMPTY}),

    // Register interface unused (tied off as in cam_csi_rx_controllers).
    .axi_clk          (1'b0),
    .axi_reset_n      (1'b0),
    .axi_awaddr       (6'b0),
    .axi_awvalid      (1'b0),
    .axi_wdata        (32'b0),
    .axi_wvalid       (1'b0),
    .axi_bready       (1'b0),
    .axi_araddr       (6'b0),
    .axi_arvalid      (1'b0),
    .axi_rready       (1'b1),

    .hsync_vc0        (w_rx_hs),
    .vsync_vc0        (w_rx_vs),
    .datatype         (rx_out_dt),
    .pixel_data       (w_rx_data),
    .pixel_data_valid (w_rx_valid)
);

// output = top 8 bits of each RAW10 pixel.
assign w_rx_out_de      = w_rx_valid;
assign w_rx_out_vs      = w_rx_vs;
assign w_rx_out_hs      = w_rx_hs;
assign w_rx_out_data_00 = w_rx_data[CAM_PIXEL_RX_DATAWIDTH*1-1 -: CAM_PIXEL_RX_MEM_DATAWIDTH];
assign w_rx_out_data_01 = w_rx_data[CAM_PIXEL_RX_DATAWIDTH*2-1 -: CAM_PIXEL_RX_MEM_DATAWIDTH];
assign w_rx_out_data_10 = w_rx_data[CAM_PIXEL_RX_DATAWIDTH*3-1 -: CAM_PIXEL_RX_MEM_DATAWIDTH];
assign w_rx_out_data_11 = w_rx_data[CAM_PIXEL_RX_DATAWIDTH*4-1 -: CAM_PIXEL_RX_MEM_DATAWIDTH];
// Nets that edge_vision_soc.v leaves implicit, declared here.
wire            debug_cam_pixel_remap_fifo_overflow;
wire            debug_cam_pixel_remap_fifo_underflow;
wire            w_hdmi_confdone;
wire            w_dma_ctrl_interrupt;

//////////////////////////////
// Camera Input Preprocessing
//////////////////////////////

// Picam to DMA connection
wire            cam_dma_wready;
wire            cam_dma_wvalid;
wire            cam_dma_wlast;
wire [63:0]     cam_dma_wdata;

// Picam Debug register to APB status registers.
wire            debug_cam_dma_fifo_overflow;
wire            debug_cam_dma_fifo_underflow;
wire [31:0]     debug_cam_dma_fifo_rcount;
wire [31:0]     debug_cam_dma_fifo_wcount;
wire [31:0]     debug_cam_dma_status;

wire [31:0]     debug_cam_display_fifo_status;
wire [15:0]     rgb_control;
wire            trigger_capture_frame;
wire            continuous_capture_frame;
wire            rgb_gray;
wire            cam_dma_init_done;
wire [31:0]     frames_per_second;

wire [63:0]     w_mapped_raw_ata;

assign w_mapped_raw_ata = {24'h0, w_rx_out_data_11[7:0],2'b0, w_rx_out_data_10[7:0],2'b0, w_rx_out_data_01[7:0],2'b0, w_rx_out_data_00[7:0],2'b0};

cam_picam_v2 # (
    .MIPI_FRAME_WIDTH                       (MIPI_FRAME_WIDTH),             //Input frame resolution from MIPI
    .MIPI_FRAME_HEIGHT                      (MIPI_FRAME_HEIGHT),            //Input frame resolution from MIPI
    .FRAME_WIDTH                            (FRAME_WIDTH),                  //Output frame resolution to external memory
    .FRAME_HEIGHT                           (FRAME_HEIGHT),                 //Output frame resolution to external memory
    .DMA_TRANSFER_LENGTH                    ((FRAME_WIDTH*FRAME_HEIGHT)/2), //2PPC
    .MIPI_PCLK_CLK_RATE                     (32'd100_000_000)               // as mipi_pclk is 100MHz
) u_cam (
    .mipi_pclk                              (i_pixel_clk),
    .rst_n                                  (i_arstn),
    .mipi_cam_data                          (w_mapped_raw_ata),
    .mipi_cam_valid                         (w_rx_out_de),
    .mipi_cam_vs                            (w_rx_out_vs),
    .mipi_cam_hs                            (w_rx_out_hs),
    .mipi_cam_type                          (rx_out_dt),
    
    .cam_dma_wready                         (cam_dma_wready),
    .cam_dma_wvalid                         (cam_dma_wvalid),
    .cam_dma_wlast                          (cam_dma_wlast),
    .cam_dma_wdata                          (cam_dma_wdata),

    .rgb_control                            (rgb_control),
    .trigger_capture_frame                  (trigger_capture_frame),
    .continuous_capture_frame               (continuous_capture_frame),
    .rgb_gray                               (rgb_gray),
    .cam_dma_init_done                      (cam_dma_init_done),
    .frames_per_second                      (frames_per_second),
    .debug_cam_pixel_remap_fifo_overflow    (debug_cam_pixel_remap_fifo_overflow),
    .debug_cam_pixel_remap_fifo_underflow   (debug_cam_pixel_remap_fifo_underflow),
    .debug_cam_dma_fifo_overflow            (debug_cam_dma_fifo_overflow),
    .debug_cam_dma_fifo_underflow           (debug_cam_dma_fifo_underflow),
    .debug_cam_dma_fifo_rcount              (debug_cam_dma_fifo_rcount),
    .debug_cam_dma_fifo_wcount              (debug_cam_dma_fifo_wcount),
    .debug_cam_dma_status                   (debug_cam_dma_status)
);

localparam CSI_RX_PIXEL_DATAWIDTH   = CAM_PIXEL_RX_MEM_DATAWIDTH;
localparam CSI_RX_PIXEL_PER_CLK     = 4;
localparam CSI_RX_TOTAL_DATAWIDTH   = CSI_RX_PIXEL_DATAWIDTH * CSI_RX_PIXEL_PER_CLK;


//////////////////
//  DIPLAY (HDMI)
//////////////////

/* I2C initialization for ADV7511 */
display_hdmi_adv7511_config #(
    .INITIAL_CODE   ("source/display/hdmi/display_hdmi_adv7511_reg.mem")
) inst_adv7511_config (
    .i_arst         (w_sysclk_arst),
    .i_sysclk       (i_sys_clk_25mhz)       ,
    .i_pll_locked   (pll_osc3_LOCKED),
    .o_state        (),
    .o_confdone     (w_hdmi_confdone),
    
    .i_sda          (i_hdmi_sda),
    .o_sda_oe       (o_hdmi_sda_oe),
    .i_scl          (i_hdmi_scl),
    .o_scl_oe       (o_hdmi_scl_oe),
    .o_rstn         ()
);


// Diplay post process from DMA to HDMI Port

wire [63:0]             display_dma_rdata;
wire                    display_dma_rvalid;
wire [7:0]              display_dma_rkeep;
wire                    display_dma_rready;
wire                    debug_display_dma_fifo_overflow;
wire                    debug_display_dma_fifo_underflow;
wire [31:0]             debug_display_dma_fifo_rcount;
wire [31:0]             debug_display_dma_fifo_wcount;

assign debug_cam_display_fifo_status = {26'd0, debug_cam_pixel_remap_fifo_underflow, debug_cam_pixel_remap_fifo_overflow, debug_cam_dma_fifo_underflow, debug_cam_dma_fifo_overflow, 
                                        debug_display_dma_fifo_underflow, debug_display_dma_fifo_overflow};

display_hdmi_yuv #(
    .FRAME_WIDTH     (FRAME_WIDTH),
    .FRAME_HEIGHT    (FRAME_HEIGHT),

    .VIDEO_MAX_HRES  (VIDEO_MAX_HRES),
    .VIDEO_HSP       (VIDEO_HSP),
    .VIDEO_HBP       (VIDEO_HBP),
    .VIDEO_HFP       (VIDEO_HFP),

    .VIDEO_MAX_VRES  (VIDEO_MAX_VRES),
    .VIDEO_VSP       (VIDEO_VSP),
    .VIDEO_VBP       (VIDEO_VBP),
    .VIDEO_VFP       (VIDEO_VFP)
    
) inst_display_hdmi_yuv(
    .iHdmiClk                           (w_hdmi_clk),
    .iRst_n                             (i_arstn),
    
    //DMA RGB Input
    .ivDisplayDmaRdData                 (display_dma_rdata),
    .iDisplayDmaRdValid                 (display_dma_rvalid),
    .iv7DisplayDmaRdKeep                (display_dma_rkeep),
    .oDisplayDmaRdReady                 (display_dma_rready),
    
    // Status.
    .iRstDebugReg                       (1'b0),
    .oDebugDisplayDmaFifoUnderflow      (debug_display_dma_fifo_underflow),
    .oDebugDisplayDmaFifoOverflow       (debug_display_dma_fifo_overflow),
    .ov32DebugDisplayDmaFifoRCount      (debug_display_dma_fifo_rcount), 
    .ov32DebugDisplayDmaFifoWCount      (debug_display_dma_fifo_wcount),

    // Output to HDMI
    .oHdmiYuvVs                         (hdmi_yuv_vs),
    .oHdmiYuvHs                         (hdmi_yuv_hs),
    .oHdmiYuvDe                         (hdmi_yuv_de),
    .ov16HdmiYuvData                    (hdmi_yuv_data)
);

///////////////
// Camera Input
///////////////

wire    mipi_i2c_0_io_sda_writeEnable;
wire    mipi_i2c_0_io_sda_read;
wire    mipi_i2c_0_io_scl_writeEnable;
wire    mipi_i2c_0_io_scl_read;
wire    mipi_i2c_0_io_sda_write;
wire    mipi_i2c_0_io_scl_write;

// Mapped
assign o_cam_sda_oe             = mipi_i2c_0_io_sda_writeEnable;
assign mipi_i2c_0_io_sda_read   = i_cam_sda;
assign mipi_i2c_0_io_scl_read   = i_cam_scl;
assign o_cam_scl_oe             = mipi_i2c_0_io_scl_writeEnable;

assign mipi_i2c_0_io_sda_writeEnable = !mipi_i2c_0_io_sda_write;
assign mipi_i2c_0_io_scl_writeEnable = !mipi_i2c_0_io_scl_write;
////////////////////
// Sapphire SOC inst
////////////////////

wire [ 15:0] io_apbSlave_0_PADDR;
wire         io_apbSlave_0_PSEL;
wire         io_apbSlave_0_PENABLE;
wire         io_apbSlave_0_PREADY;
wire         io_apbSlave_0_PWRITE;
wire [ 31:0] io_apbSlave_0_PWDATA;
wire [ 31:0] io_apbSlave_0_PRDATA;
wire         io_apbSlave_0_PSLVERROR;

wire [ 15:0] io_apbSlave_1_PADDR;
wire         io_apbSlave_1_PSEL;
wire         io_apbSlave_1_PENABLE;
wire         io_apbSlave_1_PREADY;
wire         io_apbSlave_1_PWRITE;
wire [ 31:0] io_apbSlave_1_PWDATA;
wire [ 31:0] io_apbSlave_1_PRDATA;
wire         io_apbSlave_1_PSLVERROR;

//For demo mode selection using push button
reg     [1:0]   select_demo_mode;
wire            rSw1_neg;

//AXI Slave 0
wire [7:0]      axi_awid;
wire [31:0]     axi_awaddr;
wire [7:0]      axi_awlen;
wire [2:0]      axi_awsize;
wire [1:0]      axi_awburst;
wire            axi_awlock;
wire [3:0]      axi_awcache;
wire [2:0]      axi_awprot;
wire [3:0]      axi_awqos;
wire [3:0]      axi_awregion;
wire            axi_awvalid;
wire            axi_awready;
wire [31:0]     axi_wdata;
wire [3:0]      axi_wstrb;
wire            axi_wvalid;
wire            axi_wlast;
wire            axi_wready;
wire [7:0]      axi_bid;
wire [1:0]      axi_bresp;
wire            axi_bvalid;
wire            axi_bready;
wire [7:0]      axi_arid;
wire [31:0]     axi_araddr;
wire [7:0]      axi_arlen;
wire [2:0]      axi_arsize;
wire [1:0]      axi_arburst;
wire            axi_arlock;
wire [3:0]      axi_arcache;
wire [2:0]      axi_arprot;
wire [3:0]      axi_arqos;
wire [3:0]      axi_arregion;
wire            axi_arvalid;
wire            axi_arready;
wire [7:0]      axi_rid;
wire [31:0]     axi_rdata;
wire [1:0]      axi_rresp;
wire            axi_rlast;
wire            axi_rvalid;
wire            axi_rready;
wire            axi4Interrupt;

//Hardware accelerator
wire            hw_accel_dma_rready;
wire            hw_accel_dma_rvalid;
wire [3:0]      hw_accel_dma_rkeep;
wire [31:0]     hw_accel_dma_rdata;
wire            hw_accel_dma_wready;
wire            hw_accel_dma_wvalid;
wire            hw_accel_dma_wlast;
wire [31:0]     hw_accel_dma_wdata;
wire            hw_accel_axi_we;
wire [31:0]     hw_accel_axi_waddr;
wire [31:0]     hw_accel_axi_wdata;
wire            hw_accel_axi_re;
wire [31:0]     hw_accel_axi_raddr;
wire [31:0]     hw_accel_axi_rdata;
wire            hw_accel_axi_rvalid;



// DMA memory side, into the SoC's io_ddrMasters_0 (128-bit),
// which arbitrates it with the CPU onto the single DDR3L controller port.
wire [31:0]  dma_ARADDR,  dma_AWADDR;
wire [7:0]   dma_ARLEN,   dma_AWLEN;
wire [2:0]   dma_ARSIZE,  dma_AWSIZE,  dma_ARPROT, dma_AWPROT;
wire [1:0]   dma_ARBURST, dma_AWBURST, dma_RRESP,  dma_BRESP;
wire [3:0]   dma_ARREGION, dma_AWREGION, dma_ARCACHE, dma_AWCACHE;
wire [3:0]   dma_ARQOS,   dma_AWQOS;
wire         dma_ARLOCK,  dma_AWLOCK;
wire         dma_ARVALID, dma_ARREADY, dma_AWVALID, dma_AWREADY;
wire [127:0] dma_RDATA,   dma_WDATA;
wire [15:0]  dma_WSTRB;
wire         dma_RVALID, dma_RREADY, dma_RLAST;
wire         dma_WVALID, dma_WREADY, dma_WLAST;
wire         dma_BVALID, dma_BREADY;

SapphireSoc SapphireSoc_inst (

    //Soc Clock and Reset
    .io_systemClk                       (i_soc_clk),
    .io_asyncReset                      (soc_async_reset),      // Ti125 DEVICE: POR + DDR3L ready
    .io_memoryClk                       (i_axi0_mem_clk),       // Ti125 DEVICE: DDR3L AXI clock
    .io_memoryReset                     (),
    .io_systemReset                     (),
    .io_peripheralClk                   (peripheralClk),
    .io_peripheralReset                 (io_peripheralReset),

     // Uart
    .system_uart_0_io_txd               (system_uart_0_io_txd),
    .system_uart_0_io_rxd               (system_uart_0_io_rxd),

    // Pi Camera I2C
    .system_i2c_0_io_sda_write          (mipi_i2c_0_io_sda_write),
    .system_i2c_0_io_sda_read           (mipi_i2c_0_io_sda_read),
    .system_i2c_0_io_scl_write          (mipi_i2c_0_io_scl_write),
    .system_i2c_0_io_scl_read           (mipi_i2c_0_io_scl_read),

    .userInterruptA                     (w_dma_ctrl_interrupt),

    // Ti125 DEVICE: DDR AXI master -> axi_full_to_half_duplex -> DDR3L controller
    .io_ddrA_aw_valid                   (soc_aw_valid),
    .io_ddrA_aw_ready                   (soc_aw_ready),
    .io_ddrA_aw_payload_addr            (soc_aw_addr),
    .io_ddrA_aw_payload_id              (soc_aw_id),
    .io_ddrA_aw_payload_len             (soc_aw_len),
    .io_ddrA_aw_payload_size            (soc_aw_size),
    .io_ddrA_aw_payload_burst           (soc_aw_burst),
    .io_ddrA_aw_payload_lock            (soc_aw_lock),
    .io_ddrA_aw_payload_cache           (soc_aw_cache),
    .io_ddrA_aw_payload_prot            (soc_aw_prot),
    .io_ddrA_aw_payload_qos             (soc_aw_qos),
    .io_ddrA_aw_payload_region          (soc_aw_region),

    .io_ddrA_ar_valid                   (soc_ar_valid),
    .io_ddrA_ar_ready                   (soc_ar_ready),
    .io_ddrA_ar_payload_addr            (soc_ar_addr),
    .io_ddrA_ar_payload_id              (soc_ar_id),
    .io_ddrA_ar_payload_len             (soc_ar_len),
    .io_ddrA_ar_payload_size            (soc_ar_size),
    .io_ddrA_ar_payload_burst           (soc_ar_burst),
    .io_ddrA_ar_payload_lock            (soc_ar_lock),
    .io_ddrA_ar_payload_cache           (soc_ar_cache),
    .io_ddrA_ar_payload_prot            (soc_ar_prot),
    .io_ddrA_ar_payload_qos             (soc_ar_qos),
    .io_ddrA_ar_payload_region          (soc_ar_region),

    .io_ddrA_w_valid                    (soc_w_valid),
    .io_ddrA_w_ready                    (soc_w_ready),
    .io_ddrA_w_payload_data             (soc_w_data),
    .io_ddrA_w_payload_strb             (soc_w_strb),
    .io_ddrA_w_payload_last             (soc_w_last),

    .io_ddrA_b_valid                    (soc_b_valid),
    .io_ddrA_b_ready                    (soc_b_ready),
    .io_ddrA_b_payload_id               (soc_b_id),
    .io_ddrA_b_payload_resp             (soc_b_resp),

    .io_ddrA_r_valid                    (soc_r_valid),
    .io_ddrA_r_ready                    (soc_r_ready),
    .io_ddrA_r_payload_data             (soc_r_data),
    .io_ddrA_r_payload_id               (soc_r_id),
    .io_ddrA_r_payload_resp             (soc_r_resp),
    .io_ddrA_r_payload_last             (soc_r_last),

    // Ti125 DEVICE: DMA path into DDR
    .io_ddrMasters_0_clk               (i_sys_clk),
    .io_ddrMasters_0_reset             (),
    .io_ddrMasters_0_aw_valid          (dma_AWVALID),
    .io_ddrMasters_0_aw_ready          (dma_AWREADY),
    .io_ddrMasters_0_aw_payload_addr   (dma_AWADDR),
    .io_ddrMasters_0_aw_payload_id     (4'd0),
    .io_ddrMasters_0_aw_payload_region (dma_AWREGION),
    .io_ddrMasters_0_aw_payload_len    (dma_AWLEN),
    .io_ddrMasters_0_aw_payload_size   (dma_AWSIZE),
    .io_ddrMasters_0_aw_payload_burst  (dma_AWBURST),
    .io_ddrMasters_0_aw_payload_lock   (dma_AWLOCK),
    .io_ddrMasters_0_aw_payload_cache  (dma_AWCACHE),
    .io_ddrMasters_0_aw_payload_qos    (dma_AWQOS),
    .io_ddrMasters_0_aw_payload_prot   (dma_AWPROT),
    .io_ddrMasters_0_w_valid           (dma_WVALID),
    .io_ddrMasters_0_w_ready           (dma_WREADY),
    .io_ddrMasters_0_w_payload_data    (dma_WDATA),
    .io_ddrMasters_0_w_payload_strb    (dma_WSTRB),
    .io_ddrMasters_0_w_payload_last    (dma_WLAST),
    .io_ddrMasters_0_b_valid           (dma_BVALID),
    .io_ddrMasters_0_b_ready           (dma_BREADY),
    .io_ddrMasters_0_b_payload_id      (),
    .io_ddrMasters_0_b_payload_resp    (dma_BRESP),
    .io_ddrMasters_0_ar_valid          (dma_ARVALID),
    .io_ddrMasters_0_ar_ready          (dma_ARREADY),
    .io_ddrMasters_0_ar_payload_addr   (dma_ARADDR),
    .io_ddrMasters_0_ar_payload_id     (4'd0),
    .io_ddrMasters_0_ar_payload_region (dma_ARREGION),
    .io_ddrMasters_0_ar_payload_len    (dma_ARLEN),
    .io_ddrMasters_0_ar_payload_size   (dma_ARSIZE),
    .io_ddrMasters_0_ar_payload_burst  (dma_ARBURST),
    .io_ddrMasters_0_ar_payload_lock   (dma_ARLOCK),
    .io_ddrMasters_0_ar_payload_cache  (dma_ARCACHE),
    .io_ddrMasters_0_ar_payload_qos    (dma_ARQOS),
    .io_ddrMasters_0_ar_payload_prot   (dma_ARPROT),
    .io_ddrMasters_0_r_valid           (dma_RVALID),
    .io_ddrMasters_0_r_ready           (dma_RREADY),
    .io_ddrMasters_0_r_payload_data    (dma_RDATA),
    .io_ddrMasters_0_r_payload_id      (),
    .io_ddrMasters_0_r_payload_resp    (dma_RRESP),
    .io_ddrMasters_0_r_payload_last    (dma_RLAST),

    // SPI (Ti125 DEVICE: SPI0 only, x2 data; the Ti125 SoC has no SPI1)
    .system_spi_0_io_sclk_write         (system_spi_0_io_sclk_write),
    .system_spi_0_io_data_0_writeEnable (system_spi_0_io_data_0_writeEnable),
    .system_spi_0_io_data_0_read        (system_spi_0_io_data_0_read),
    .system_spi_0_io_data_0_write       (system_spi_0_io_data_0_write),
    .system_spi_0_io_data_1_writeEnable (system_spi_0_io_data_1_writeEnable),
    .system_spi_0_io_data_1_read        (system_spi_0_io_data_1_read),
    .system_spi_0_io_data_1_write       (system_spi_0_io_data_1_write),
    .system_spi_0_io_data_2_read        (1'b0),
    .system_spi_0_io_data_2_write       (),
    .system_spi_0_io_data_2_writeEnable (),
    .system_spi_0_io_data_3_read        (1'b0),
    .system_spi_0_io_data_3_write       (),
    .system_spi_0_io_data_3_writeEnable (),
    .system_spi_0_io_ss                 (system_spi_0_io_ss),

    // APB 3 Slave 0 (camera / display control: common_apb3)
    .io_apbSlave_0_PADDR                (io_apbSlave_0_PADDR),
    .io_apbSlave_0_PSEL                 (io_apbSlave_0_PSEL),
    .io_apbSlave_0_PENABLE              (io_apbSlave_0_PENABLE),
    .io_apbSlave_0_PREADY               (io_apbSlave_0_PREADY),
    .io_apbSlave_0_PWRITE               (io_apbSlave_0_PWRITE),
    .io_apbSlave_0_PWDATA               (io_apbSlave_0_PWDATA),
    .io_apbSlave_0_PRDATA               (io_apbSlave_0_PRDATA),
    .io_apbSlave_0_PSLVERROR            (io_apbSlave_0_PSLVERROR),

    // APB 3 Slave 1 (DMA)
    .io_apbSlave_1_PADDR                (io_apbSlave_1_PADDR),
    .io_apbSlave_1_PSEL                 (io_apbSlave_1_PSEL),
    .io_apbSlave_1_PENABLE              (io_apbSlave_1_PENABLE),
    .io_apbSlave_1_PREADY               (io_apbSlave_1_PREADY),
    .io_apbSlave_1_PWRITE               (io_apbSlave_1_PWRITE),
    .io_apbSlave_1_PWDATA               (io_apbSlave_1_PWDATA),
    .io_apbSlave_1_PRDATA               (io_apbSlave_1_PRDATA),
    .io_apbSlave_1_PSLVERROR            (io_apbSlave_1_PSLVERROR),

    //AXI4 slave port
    .axiA_awvalid                       (axi_awvalid),
    .axiA_awready                       (axi_awready),
    .axiA_awaddr                        (axi_awaddr),
    .axiA_awid                          (axi_awid),
    .axiA_awregion                      (axi_awregion),
    .axiA_awlen                         (axi_awlen),
    .axiA_awsize                        (axi_awsize),
    .axiA_awburst                       (axi_awburst),
    .axiA_awlock                        (axi_awlock),
    .axiA_awcache                       (axi_awcache),
    .axiA_awqos                         (axi_awqos),
    .axiA_awprot                        (axi_awprot),
    .axiA_wvalid                        (axi_wvalid),
    .axiA_wready                        (axi_wready),
    .axiA_wdata                         (axi_wdata),
    .axiA_wstrb                         (axi_wstrb),
    .axiA_wlast                         (axi_wlast),
    .axiA_bvalid                        (axi_bvalid),
    .axiA_bready                        (axi_bready),
    .axiA_bid                           (axi_bid),
    .axiA_bresp                         (axi_bresp),
    .axiA_arvalid                       (axi_arvalid),
    .axiA_arready                       (axi_arready),
    .axiA_araddr                        (axi_araddr),
    .axiA_arid                          (axi_arid),
    .axiA_arregion                      (axi_arregion),
    .axiA_arlen                         (axi_arlen),
    .axiA_arsize                        (axi_arsize),
    .axiA_arburst                       (axi_arburst),
    .axiA_arlock                        (axi_arlock),
    .axiA_arcache                       (axi_arcache),
    .axiA_arqos                         (axi_arqos),
    .axiA_arprot                        (axi_arprot),
    .axiA_rvalid                        (axi_rvalid),
    .axiA_rready                        (axi_rready),
    .axiA_rdata                         (axi_rdata),
    .axiA_rid                           (axi_rid),
    .axiA_rresp                         (axi_rresp),
    .axiA_rlast                         (axi_rlast),
    .axiAInterrupt                      (axi4Interrupt),

    .jtagCtrl_tck                       (jtag_inst1_TCK),
    .jtagCtrl_tdi                       (jtag_inst1_TDI),
    .jtagCtrl_tdo                       (jtag_inst1_TDO),
    .jtagCtrl_enable                    (jtag_inst1_SEL),
    .jtagCtrl_capture                   (jtag_inst1_CAPTURE),
    .jtagCtrl_shift                     (jtag_inst1_SHIFT),
    .jtagCtrl_update                    (jtag_inst1_UPDATE),
    .jtagCtrl_reset                     (jtag_inst1_RESET)
);

////////////////
// APB3 Slave 1
///////////////

// For control and status register
common_apb3 #(
   .ADDR_WIDTH                              (16),
   .DATA_WIDTH                              (32),
   .NUM_REG                                 (7)
) u_apb3_cam_display (
    .clk                                    (peripheralClk),
    .resetn                                 (~peripheralReset),
    
    // Output Control
    .mipi_rstn                              (mipi_rstn),
    .enable_cam                             (),
    .rgb_control                            (rgb_control),
    .trigger_capture_frame                  (trigger_capture_frame),
    .continuous_capture_frame               (continuous_capture_frame),
    .rgb_gray                               (rgb_gray),
    .cam_dma_init_done                      (cam_dma_init_done),
    .frames_per_second                      (frames_per_second),
    .select_demo_mode                       (select_demo_mode),

    // Input Info Data
    .debug_fifo_status                      (debug_cam_display_fifo_status),
    .debug_cam_dma_fifo_rcount              (debug_cam_dma_fifo_rcount),
    .debug_cam_dma_fifo_wcount              (debug_cam_dma_fifo_wcount),
    .debug_cam_dma_status                   (debug_cam_dma_status),
    .debug_display_dma_fifo_rcount          (debug_display_dma_fifo_rcount),
    .debug_display_dma_fifo_wcount          (debug_display_dma_fifo_wcount),

    // Apb 3 interface
    .PADDR                                  (io_apbSlave_0_PADDR),
    .PSEL                                   (io_apbSlave_0_PSEL),
    .PENABLE                                (io_apbSlave_0_PENABLE),
    .PREADY                                 (io_apbSlave_0_PREADY),
    .PWRITE                                 (io_apbSlave_0_PWRITE),
    .PWDATA                                 (io_apbSlave_0_PWDATA),
    .PRDATA                                 (io_apbSlave_0_PRDATA),
    .PSLVERROR                              (io_apbSlave_0_PSLVERROR)
);

//For demo2 
common_debouncer u_common_debouncer (
   .switch  (i_sw[1]),
   .clk     (peripheralClk),
   .rst_n   (i_arstn),
   .q       (rSw1_neg)
);

always @(posedge peripheralClk) begin
    if (~i_arstn) begin
        select_demo_mode <= 2'b11; 
    end else begin
        if(rSw1_neg) begin
            select_demo_mode <= select_demo_mode + 2'b1;
        end else begin
            select_demo_mode <= select_demo_mode;
        end
    end
end

////////////
// Dma inst
///////////
wire  [4:0] dma_interrupts;
assign w_dma_ctrl_interrupt = | dma_interrupts;

dma u_dma (
    // Ti125 DEVICE: memory side on i_sys_clk (io_ddrMasters_0 clock).
    .clk                (i_sys_clk),
    .reset              (peripheralReset),

    .ctrl_clk           (peripheralClk),
    .ctrl_reset         (peripheralReset),

    //APB Slave
    .ctrl_PADDR         (io_apbSlave_1_PADDR),
    .ctrl_PSEL          (io_apbSlave_1_PSEL),
    .ctrl_PENABLE       (io_apbSlave_1_PENABLE),
    .ctrl_PREADY        (io_apbSlave_1_PREADY),
    .ctrl_PWRITE        (io_apbSlave_1_PWRITE),
    .ctrl_PWDATA        (io_apbSlave_1_PWDATA),
    .ctrl_PRDATA        (io_apbSlave_1_PRDATA),
    .ctrl_PSLVERROR     (io_apbSlave_1_PSLVERROR),
    .ctrl_interrupts    (dma_interrupts),

    //DMA AXI memory Interface (Ti125 DEVICE: 128-bit, to io_ddrMasters_0)
    .read_arvalid       (dma_ARVALID),
    .read_araddr        (dma_ARADDR),
    .read_arready       (dma_ARREADY),
    .read_arregion      (dma_ARREGION),
    .read_arlen         (dma_ARLEN),
    .read_arsize        (dma_ARSIZE),
    .read_arburst       (dma_ARBURST),
    .read_arlock        (dma_ARLOCK),
    .read_arcache       (dma_ARCACHE),
    .read_arqos         (dma_ARQOS),
    .read_arprot        (dma_ARPROT),

    .read_rready        (dma_RREADY),
    .read_rvalid        (dma_RVALID),
    .read_rdata         (dma_RDATA),
    .read_rlast         (dma_RLAST),
    .read_rresp         (dma_RRESP),

    .write_awvalid      (dma_AWVALID),
    .write_awready      (dma_AWREADY),
    .write_awaddr       (dma_AWADDR),
    .write_awregion     (dma_AWREGION),
    .write_awlen        (dma_AWLEN),
    .write_awsize       (dma_AWSIZE),
    .write_awburst      (dma_AWBURST),
    .write_awlock       (dma_AWLOCK),
    .write_awcache      (dma_AWCACHE),
    .write_awqos        (dma_AWQOS),
    .write_awprot       (dma_AWPROT),

    .write_wvalid       (dma_WVALID),
    .write_wready       (dma_WREADY),
    .write_wdata        (dma_WDATA),
    .write_wstrb        (dma_WSTRB),
    .write_wlast        (dma_WLAST),

    .write_bvalid       (dma_BVALID),
    .write_bready       (dma_BREADY),
    .write_bresp        (dma_BRESP),
    //64-bit Camera Video Stream In
    .dat0_i_clk         (i_pixel_clk),
    .dat0_i_reset       (~i_arstn),
    .dat0_i_tvalid      (cam_dma_wvalid),
    .dat0_i_tready      (cam_dma_wready),
    .dat0_i_tdata       (cam_dma_wdata),
    .dat0_i_tkeep       ({8{cam_dma_wvalid}}),
    .dat0_i_tdest       (4'd0),
    .dat0_i_tlast       (cam_dma_wlast),

    .dat1_o_clk         (1'b0),
    .dat1_o_reset       (1'b0),
    .dat1_o_tvalid      (),
    .dat1_o_tready      (),
    .dat1_o_tdata       (),
    .dat1_o_tkeep       (),
    .dat1_o_tdest       (),
    .dat1_o_tlast       (),    
    
    //64-bit dma channel (MM2S - from external memory)
    .dat2_o_clk         (w_hdmi_clk),
    .dat2_o_reset       (~i_arstn),
    .dat2_o_tvalid      (display_dma_rvalid),
    .dat2_o_tready      (display_dma_rready),
    .dat2_o_tdata       (display_dma_rdata),
    .dat2_o_tkeep       (display_dma_rkeep),
    .dat2_o_tdest       ( ),
    .dat2_o_tlast       ( ),
    
    //32-bit dma channel (S2MM - to DDR)
    .dat3_i_clk         (i_soc_clk),
    .dat3_i_reset       (~i_arstn),
    .dat3_i_tvalid      (hw_accel_dma_wvalid),
    .dat3_i_tready      (hw_accel_dma_wready),
    .dat3_i_tdata       (hw_accel_dma_wdata),
    .dat3_i_tkeep       ({4{hw_accel_dma_wvalid}}),
    .dat3_i_tdest       (4'd0),
    .dat3_i_tlast       (hw_accel_dma_wlast),
   
    //32-bit dma channel (MM2S - from DDR)
    .dat4_o_clk         (i_soc_clk),
    .dat4_o_reset       (~i_arstn),
    .dat4_o_tvalid      (hw_accel_dma_rvalid),
    .dat4_o_tready      (hw_accel_dma_rready),
    .dat4_o_tdata       (hw_accel_dma_rdata),
    .dat4_o_tkeep       (hw_accel_dma_rkeep),
    .dat4_o_tdest       (),
    .dat4_o_tlast       ()
);


//////////////////
//HW ACCELERATOR 
/////////////////

hw_accel_axi4 #(
    .ADDR_WIDTH     (32),
    .DATA_WIDTH     (32)
) u_hw_accel_axi4 (
    .axi_interrupt (axi4Interrupt),
    .axi_aclk      (peripheralClk),
    .axi_resetn    (~peripheralReset),
    
    .axi_awid      (axi_awid),
    .axi_awaddr    (axi_awaddr),
    .axi_awlen     (axi_awlen),
    .axi_awsize    (axi_awsize),
    .axi_awburst   (axi_awburst),
    .axi_awlock    (axi_awlock),
    .axi_awcache   (axi_awcache),
    .axi_awprot    (axi_awprot),
    .axi_awqos     (axi_awqos),
    .axi_awregion  (axi_awregion),
    .axi_awvalid   (axi_awvalid),
    .axi_awready   (axi_awready),
    .axi_wdata     (axi_wdata),
    .axi_wstrb     (axi_wstrb),
    .axi_wlast     (axi_wlast),
    .axi_wvalid    (axi_wvalid),
    .axi_wready    (axi_wready),
    .axi_bid       (axi_bid),
    .axi_bresp     (axi_bresp),
    .axi_bvalid    (axi_bvalid),
    .axi_bready    (axi_bready),
    .axi_arid      (axi_arid),
    .axi_araddr    (axi_araddr),
    .axi_arlen     (axi_arlen),
    .axi_arsize    (axi_arsize),
    .axi_arburst   (axi_arburst),
    .axi_arlock    (axi_arlock),
    .axi_arcache   (axi_arcache),
    .axi_arprot    (axi_arprot),
    .axi_arqos     (axi_arqos),
    .axi_arregion  (axi_arregion),
    .axi_arvalid   (axi_arvalid),
    .axi_arready   (axi_arready),
    .axi_rid       (axi_rid),
    .axi_rdata     (axi_rdata),
    .axi_rresp     (axi_rresp),
    .axi_rlast     (axi_rlast),
    .axi_rvalid    (axi_rvalid),
    .axi_rready    (axi_rready),
    
    .usr_we        (hw_accel_axi_we),
    .usr_waddr     (hw_accel_axi_waddr),
    .usr_wdata     (hw_accel_axi_wdata),
    .usr_re        (hw_accel_axi_re),
    .usr_raddr     (hw_accel_axi_raddr),
    .usr_rdata     (hw_accel_axi_rdata),
    .usr_rvalid    (hw_accel_axi_rvalid)
);

hw_accel_wrapper #(
    .FRAME_WIDTH         (FRAME_WIDTH),
    .FRAME_HEIGHT        (FRAME_HEIGHT),
    .DMA_TRANSFER_LENGTH (FRAME_WIDTH*FRAME_HEIGHT) //S2MM DMA transfer
) u_hw_accel_wrapper (

    .clk                   (i_soc_clk),
    .rst                   (~i_arstn),
    
    .axi_slave_clk         (peripheralClk),
    .axi_slave_rst         (peripheralReset),
    
    .axi_slave_we          (hw_accel_axi_we),
    .axi_slave_waddr       (hw_accel_axi_waddr),
    .axi_slave_wdata       (hw_accel_axi_wdata),
    .axi_slave_re          (hw_accel_axi_re),
    .axi_slave_raddr       (hw_accel_axi_raddr),
    .axi_slave_rdata       (hw_accel_axi_rdata),
    .axi_slave_rvalid      (hw_accel_axi_rvalid),
    
    .dma_rready            (hw_accel_dma_rready),
    .dma_rvalid            (hw_accel_dma_rvalid),
    .dma_rdata             (hw_accel_dma_rdata),
    .dma_rkeep             (hw_accel_dma_rkeep),
    
    .dma_wready            (hw_accel_dma_wready),
    .dma_wvalid            (hw_accel_dma_wvalid),
    .dma_wlast             (hw_accel_dma_wlast),
    .dma_wdata             (hw_accel_dma_wdata)
);


    //=========================================================================
    // Ti125 DEVICE: status LEDs (2 on this board)
    //   o_led[1]: DDR3L status (solid = calibrated OK, else blink code)
    //   o_led[0]: heartbeat once the ADV7511 is configured
    //=========================================================================
    localparam int HB_DIV   = CLK_FREQ_HZ / 2;
    localparam int TICK_DIV = (CLK_FREQ_HZ / 1000) * TICK_MS;
    localparam int CNT_W    = $clog2(HB_DIV + 1);
    localparam int TCNT_W   = $clog2(TICK_DIV + 1);

    reg [CNT_W-1:0] hb_cnt;
    reg             hb;
    always @(posedge i_axi0_mem_clk or negedge i_sw[0]) begin
        if (!i_sw[0]) begin
            hb_cnt <= '0;
            hb     <= 1'b0;
        end else if (hb_cnt == CNT_W'(HB_DIV - 1)) begin
            hb_cnt <= '0;
            hb     <= ~hb;
        end else begin
            hb_cnt <= hb_cnt + 1'b1;
        end
    end

    reg [2:0] code;
    always @(*) begin
        if      (!sys_rst_n)        code = 3'd1;
        else if (retries_exhausted) code = 3'd5;
        else if (!ddr_rst_n)        code = 3'd3;
        else if (!w_cal_done)       code = 3'd2;
        else if (!w_cal_pass)       code = 3'd3;
        else if (retry_cnt != 5'd0) code = 3'd4;
        else                        code = 3'd0;
    end

    reg [TCNT_W-1:0] tick_cnt;
    reg [4:0]        tick_idx;
    reg [2:0]        code_q;
    wire [4:0] frame_len = 5'(2*code) + 5'd6;

    always @(posedge i_axi0_mem_clk or negedge i_sw[0]) begin
        if (!i_sw[0]) begin
            tick_cnt <= '0;
            tick_idx <= '0;
            code_q   <= 3'd1;
        end else begin
            code_q <= code;
            if (code != code_q) begin
                tick_cnt <= '0;
                tick_idx <= '0;
            end else if (tick_cnt == TCNT_W'(TICK_DIV - 1)) begin
                tick_cnt <= '0;
                tick_idx <= (tick_idx >= frame_len - 5'd1) ? 5'd0
                                                           : tick_idx + 5'd1;
            end else begin
                tick_cnt <= tick_cnt + 1'b1;
            end
        end
    end

    wire in_flash  = (tick_idx < 5'(2*code));
    wire state_led = (code == 3'd0) ? 1'b1 : (in_flash & ~tick_idx[0]);

    // HDMI bring-up aid: when LED_HDMI_DEBUG = 1, led[0] blinks only after
    // the ADV7511 I2C configuration has finished (w_hdmi_confdone) and stays
    // dark otherwise. Set back to 0 for the plain heartbeat.
    localparam bit LED_HDMI_DEBUG = 1'b1;
    wire led0 = LED_HDMI_DEBUG ? (hb & w_hdmi_confdone) : hb;

    wire [1:0] led_raw = { state_led, led0 };
    assign o_led = LED_ACTIVE_LOW ? ~led_raw : led_raw;

endmodule
