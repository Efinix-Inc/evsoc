//=============================================================================
// edge_vision_soc_sim.v  --  Ti125F225 SIMULATION top (testbench use only)
//
// Generated from edge_vision_soc.v by make_sim_top.py (2026-11-04).
// Same design as the synthesis top except:
//   * DDR3L soft controller removed: the SoC memory port still goes through
//     axi_full_to_half_duplex (MAX_OUTSTANDING_RD = 1), and its half-duplex
//     AXI4 side (ddr_axi_*) is a port for the testbench memory model.
//   * No power-on counter / calibration retry: reset = i_sw[0] only.
//   * CSI-2 receiver and MIPI lanes removed: cam_picam_v2 takes the testbench
//     frame on its sim_cam_* ports (`ifdef SIM).
//   * ADV7511 I2C setup and HDMI timing generator not simulated
//     (display_dma_rready tied 1, as in the Ti180 sim top). The display DMA
//     stream runs on i_hdmi_sim.
//   * DDR3 status LEDs removed (o_led = 0).
// Compile with +define+SIM.
//=============================================================================

//=============================================================================
// edge_vision_soc.v -- Ti125F225 Edge Vision SoC
//
// Ported from the Efinix Ti180J484 evsoc reference (edge_vision_soc.v).
// Same file, module, IP and top-level port names as Ti180. Everything below
// follows edge_vision_soc.v line for line (same sources, register map, DMA
// channel map, hw_accel, resets), EXCEPT the parts this device/board forces
// to be different. Each of those is marked "Ti125 DEVICE:" and listed here:
//
//   1. DDR      : Ti180 hard LPDDR4 (2 x 512-bit ports) -> Ti125 soft DDR3L
//                 controller (efx_ddr3_controller_v2) behind
//                 axi_full_to_half_duplex (MAX_OUTSTANDING_RD = 1), with the
//                 POR / calibration-retry FSM. The SoC reaches it on io_ddrA
//                 (128-bit); the DMA through the SoC's io_ddrMasters_0 (128-bit).
//   2. MIPI     : Ti180 hard D-PHY + csi2_hard_mipi_rx (inside
//                 cam_csi_rx_controllers) -> Ti125 MIPI RX lanes +
//                 soft csi2_rx_cam. The receiver output is sliced exactly as
//                 cam_csi_rx_controllers does, so cam_picam_v2 sees the
//                 same bus.
//   3. SoC      : SapphireSoc generated for Ti125 (no SPI1; 128-bit DDR port).
//   4. Clocks   : i_sys_clk (peripheral clock) is 200 MHz instead of 100 MHz
//                 and also clocks the DMA memory side (io_ddrMasters_0);
//                 i_axi0_mem_clk is the DDR3L controller AXI clock. No
//                 25.25 MHz pixel clock: 640x480 uses i_sys_clk_25mhz (25.2 MHz).
//                 No pll_*_RSTN outputs (Ti125 PLLs have no reset pins here).
//   5. Board    : 2 LEDs (DDR3 status / heartbeat) instead of 6.
//                 i_sw[0] = reset (board BTN2, GPIOR_N_00),
//                 i_sw[1] = demo2 mode button (board BTN1, GPIOR_P_02_CSI;
//                 do not hold it while the FPGA is configuring).
//                 DDR3L and MIPI-lane pins are Ti125-only.
//=============================================================================

// SIM: evsoc_defines.v / ddr3_controller.vh not included (see header).

module edge_vision_soc_sim #(
    // Input frame resolution from MIPI Rx
    parameter MIPI_FRAME_WIDTH  = 1920,
    parameter MIPI_FRAME_HEIGHT = 1080,
    // Actual frame resolution used for simulation (tb_soc.v drives 64x48)
    parameter FRAME_WIDTH       = 64,
    parameter FRAME_HEIGHT      = 48
) (
    // ---- clocks and reset ----
    input  wire                     i_axi0_mem_clk,   // 100 MHz: bridge + memory model
    input  wire                     pll_ddr_LOCKED,
    input  wire [1:0]               i_sw,             // [0] reset (active low), [1] demo button

    input  wire                     i_soc_clk,        // SoC io_systemClk
    input  wire                     i_sys_clk,        // peripherals + DMA memory side

    input  wire                     i_hdmi_sim,       // SIM: display DMA stream clock

    // ---- SIM: half-duplex AXI4 to the memory model (replaces the DDR3L controller) ----
    output wire [7:0]               ddr_axi_aid,
    output wire [31:0]              ddr_axi_aaddr,
    output wire [7:0]               ddr_axi_alen,
    output wire [2:0]               ddr_axi_asize,
    output wire [1:0]               ddr_axi_aburst,
    output wire [1:0]               ddr_axi_alock,
    output wire                     ddr_axi_avalid,
    input  wire                     ddr_axi_aready,
    output wire                     ddr_axi_atype,    // 1 = write, 0 = read

    output wire [7:0]               ddr_axi_wid,
    output wire [127:0]             ddr_axi_wdata,
    output wire [15:0]              ddr_axi_wstrb,
    output wire                     ddr_axi_wlast,
    output wire                     ddr_axi_wvalid,
    input  wire                     ddr_axi_wready,

    input  wire [7:0]               ddr_axi_rid,
    input  wire [127:0]             ddr_axi_rdata,
    input  wire                     ddr_axi_rlast,
    input  wire                     ddr_axi_rvalid,
    output wire                     ddr_axi_rready,
    input  wire [1:0]               ddr_axi_rresp,

    input  wire [7:0]               ddr_axi_bid,
    input  wire                     ddr_axi_bvalid,
    output wire                     ddr_axi_bready,

    // ---- SIM: camera frame from the testbench ----
    input  wire                     sim_cam_hsync,
    input  wire                     sim_cam_vsync,
    input  wire                     sim_cam_valid,
    input  wire [15:0]              sim_cam_r_pix,
    input  wire [15:0]              sim_cam_g_pix,
    input  wire [15:0]              sim_cam_b_pix,

    output wire [1:0]               o_led,

    // ---- JTAG_USER1 -> SoC debug ----
    input  wire                     jtag_inst1_CAPTURE, jtag_inst1_DRCK,
    input  wire                     jtag_inst1_RESET,   jtag_inst1_RUNTEST,
    input  wire                     jtag_inst1_SEL,     jtag_inst1_SHIFT,
    input  wire                     jtag_inst1_TCK,     jtag_inst1_TDI,
    input  wire                     jtag_inst1_TMS,     jtag_inst1_UPDATE,
    output wire                     jtag_inst1_TDO,

    // ---- SoC peripherals (Ti180 names) ----
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

    // SIM: MIPI RX lane ports removed (camera data comes from sim_cam_*).

    // ---- camera I2C and reset (Ti180 names) ---------------------------------
    input  wire                     i_cam_sda,
    output wire                     o_cam_sda_oe,
    input  wire                     i_cam_scl,
    output wire                     o_cam_scl_oe,
    output wire                     o_cam_rstn,

    // ---- HDMI: ADV7511 on the QSE daughter card (Ti180 names) ---------------
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

// SIM: the display timing generator is not simulated, so no resolution define
// is needed; the display DMA stream runs on the testbench clock.
assign w_hdmi_clk = i_hdmi_sim;

    //=========================================================================
    // SIM: no DDR3L controller, so no power-on counter, calibration retry or
    // SoC timeout. The memory model is ready as soon as i_sw[0] is released.
    //=========================================================================
    wire sys_rst_n       = i_sw[0];
    wire soc_async_reset = ~sys_rst_n;

    //=========================================================================
    // AXI4: bridge <-> DDR3 controller.
    // One SHARED address channel (ddr_axi_a*), ddr_axi_atype: 1 = write, 0 = read.
    //=========================================================================
    // SIM: ddr_axi_* are module ports (memory model in tb_soc.v).

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
        // MUST be 1 (was 16 in the Ti125 design). Captured on hardware: when a
        // short read (e.g. the 1-beat tail of the hw_accel input transfer) is
        // accepted while a 32-beat read is still returning data, the DDR3L
        // controller returns its beat WITHOUT RLAST; that read never completes
        // and the whole SoC locks up (modes c/e/f/g). With 1, no read reaches
        // the controller until the previous RLAST is back. Raise only after
        // the controller read-return path is fixed.
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

    // SIM: efx_ddr3_controller_v2 removed; ddr_axi_* go to the testbench memory model.

    wire io_peripheralReset;            // active high, SoC peripheral domain
    wire ddrm0_reset = 1'b0;            // SIM: undriven in edge_vision_soc.v; synthesis makes it 0

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

// Ti125 DEVICE: Ti180 builds io_asyncResetn from SW0 and the PLL locks. Here
// SW0 is i_sw[0], already folded into soc_async_reset together with the POR and
// the DDR3L calibration result; the two video PLL locks are added as on Ti180.
assign   io_asyncResetn   = ~soc_async_reset & pll_osc3_LOCKED & pll_osc2_LOCKED;
assign   w_sysclk_arst    = ~( io_asyncResetn );
assign   w_sysclk_arstn   = ~w_sysclk_arst;

assign   i_arstn          = (w_sysclk_arstn & (!mipi_rstn)) ;
assign   o_cam_rstn       = i_arstn;

wire    peripheralClk;
wire    peripheralReset;

assign peripheralClk   = i_sys_clk;           // Ti125 DEVICE: 200 MHz (Ti180: 100 MHz)
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

// SIM: CSI-2 receiver and MIPI lanes not simulated. cam_picam_v2 ignores its
// mipi_cam_* inputs under `ifdef SIM and uses sim_cam_* instead.
assign w_rx_out_de      = 1'b0;
assign w_rx_out_vs      = 1'b0;
assign w_rx_out_hs      = 1'b0;
assign w_rx_out_data_00 = {CAM_PIXEL_RX_MEM_DATAWIDTH{1'b0}};
assign w_rx_out_data_01 = {CAM_PIXEL_RX_MEM_DATAWIDTH{1'b0}};
assign w_rx_out_data_10 = {CAM_PIXEL_RX_MEM_DATAWIDTH{1'b0}};
assign w_rx_out_data_11 = {CAM_PIXEL_RX_MEM_DATAWIDTH{1'b0}};
assign rx_out_dt        = 6'd0;
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
`ifdef SIM
    // Simulation frame data from testbench
    .sim_cam_hsync                          (sim_cam_hsync),
    .sim_cam_vsync                          (sim_cam_vsync),
    .sim_cam_valid                          (sim_cam_valid),
    .sim_cam_r_pix                          (sim_cam_r_pix),
    .sim_cam_g_pix                          (sim_cam_g_pix),
    .sim_cam_b_pix                          (sim_cam_b_pix),
`endif
    
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

// SIM: ADV7511 I2C configuration not simulated.
assign w_hdmi_confdone = 1'b0;
assign o_hdmi_sda_oe   = 1'b0;
assign o_hdmi_scl_oe   = 1'b0;


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

// SIM: HDMI timing generator not simulated. As in the Ti180 sim top the
// display DMA stream is always accepted; tb_soc.v records it to display_out.txt.
assign display_dma_rready               = 1'b1;
assign debug_display_dma_fifo_underflow = 1'b0;
assign debug_display_dma_fifo_overflow  = 1'b0;
assign debug_display_dma_fifo_rcount    = 32'd0;
assign debug_display_dma_fifo_wcount    = 32'd0;
assign hdmi_yuv_vs                      = 1'b0;
assign hdmi_yuv_hs                      = 1'b0;
assign hdmi_yuv_de                      = 1'b0;
assign hdmi_yuv_data                    = 16'd0;

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



// Ti125 DEVICE: DMA memory side, into the SoC's io_ddrMasters_0 (128-bit),
// which arbitrates it with the CPU onto the single DDR3L controller port.
// (Ti180: DMA on the second hard-DDR AXI port, 512-bit.)
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
    .io_memoryClk                       (i_axi0_mem_clk),                  // Ti125 DEVICE: DDR3L AXI clock
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

    // Ti125 DEVICE: DMA path into DDR (Ti180: DMA on hard-DDR AXI port 1)
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


    // SIM: DDR3L status / heartbeat LEDs not simulated.
    assign o_led = 2'b00;

endmodule
