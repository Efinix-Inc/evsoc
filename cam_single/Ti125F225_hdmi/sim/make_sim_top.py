#!/usr/bin/env python3
"""Build sim/edge_vision_soc_sim.v from the Ti125 synthesis top (edge_vision_soc.v).

Every edit is an exact, asserted block replacement, so if edge_vision_soc.v
changes in one of these places the script stops instead of guessing.
Usage: make_sim_top.py <edge_vision_soc.v> <out edge_vision_soc_sim.v>
"""
import sys, re, datetime

src, dst = sys.argv[1], sys.argv[2]
s = open(src, encoding="utf-8").read().replace("\r\n", "\n")


def cut(text, start, end, new, incl_end=True):
    """Replace text[start .. end] (end included if incl_end) with new; both markers must be unique."""
    assert text.count(start) == 1, ("start marker count", start[:70], text.count(start))
    i = text.index(start)
    j = text.index(end, i)
    assert text.count(end) >= 1
    j = j + len(end) if incl_end else j
    return text[:i] + new + text[j:]


def rep(text, old, new):
    assert text.count(old) == 1, ("marker count", old[:70], text.count(old))
    return text.replace(old, new)


# ---------------------------------------------------------------- header
hdr = f"""//=============================================================================
// edge_vision_soc_sim.v  --  Ti125F225 SIMULATION top (testbench use only)
//
// Generated from edge_vision_soc.v by make_sim_top.py ({datetime.date.today()}).
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

"""

# drop the two `include lines (no resolution define in sim, no DDR3 controller)
s = rep(s, '`include "evsoc_defines.v"\n`include "ip/efx_ddr3_controller_v2/ddr3_controller.vh"\n',
        "// SIM: evsoc_defines.v / ddr3_controller.vh not included (see header).\n")

# ---------------------------------------------------------------- module + params
s = cut(s, "module edge_vision_soc #(", ") (\n", """module edge_vision_soc_sim #(
    // Input frame resolution from MIPI Rx
    parameter MIPI_FRAME_WIDTH  = 1920,
    parameter MIPI_FRAME_HEIGHT = 1080,
    // Actual frame resolution used for simulation (tb_soc.v drives 64x48)
    parameter FRAME_WIDTH       = 64,
    parameter FRAME_HEIGHT      = 48
) (
""")

# ---------------------------------------------------------------- ports: clocks + DDR3 pins -> sim ports
s = cut(s, "    // ---- clocks and reset ----\n",
        "    output wire [1:0]               o_led,\n", """    // ---- clocks and reset ----
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
""")

# MIPI lane ports -> removed
s = cut(s, "    // ---- camera: MIPI RX Lanes on QSE2",
        "    output wire                     cam_d1_DLY_RST,  cam_d1_DLY_INC, cam_d1_DLY_ENA,\n",
        "    // SIM: MIPI RX lane ports removed (camera data comes from sim_cam_*).\n")

# ---------------------------------------------------------------- resolution blocks -> sim display clock
s = cut(s, "wire w_hdmi_clk;\n",
        "    assign w_hdmi_clk = i_sys_clk_25mhz; // HDMI Clock 25.2 MHz (Ti180: i_hdmi_clk_25p25MHz)\n`endif\n",
        """wire w_hdmi_clk;

// SIM: the display timing generator is not simulated, so no resolution define
// is needed; the display DMA stream runs on the testbench clock.
assign w_hdmi_clk = i_hdmi_sim;
""")

# ---------------------------------------------------------------- POR / CAL RETRY / SoC timeout -> plain reset
s = cut(s, "    //=========================================================================\n    // Ti125 DEVICE: power-on reset, DDR3L calibration retry",
        "    //=========================================================================\n    // AXI4: bridge <-> DDR3 controller.",
        """    //=========================================================================
    // SIM: no DDR3L controller, so no power-on counter, calibration retry or
    // SoC timeout. The memory model is ready as soon as i_sw[0] is released.
    //=========================================================================
    wire sys_rst_n       = i_sw[0];
    wire soc_async_reset = ~sys_rst_n;

""", incl_end=False)

# ddr_axi_* wires are ports now
s = cut(s, "    wire [7:0]               ddr_axi_aid;\n",
        "    wire [1:0]               ddr_axi_bresp;\n",
        "    // SIM: ddr_axi_* are module ports (memory model in tb_soc.v).\n")

# DDR3 controller instance -> removed
s = cut(s, "    //=========================================================================\n    // DDR3 soft controller\n",
        "        .axi_bready (ddr_axi_bready)\n    );\n",
        "    // SIM: efx_ddr3_controller_v2 removed; ddr_axi_* go to the testbench memory model.\n")

# ---------------------------------------------------------------- CSI-2 receiver + lanes -> tied off
s = cut(s, "//-----------------------------------------------------------------------------\n// Ti125 DEVICE: replaces cam_csi_rx_controllers",
        "assign w_rx_out_data_11 = w_rx_data[CAM_PIXEL_RX_DATAWIDTH*4-1 -: CAM_PIXEL_RX_MEM_DATAWIDTH];\n",
        """// SIM: CSI-2 receiver and MIPI lanes not simulated. cam_picam_v2 ignores its
// mipi_cam_* inputs under `ifdef SIM and uses sim_cam_* instead.
assign w_rx_out_de      = 1'b0;
assign w_rx_out_vs      = 1'b0;
assign w_rx_out_hs      = 1'b0;
assign w_rx_out_data_00 = {CAM_PIXEL_RX_MEM_DATAWIDTH{1'b0}};
assign w_rx_out_data_01 = {CAM_PIXEL_RX_MEM_DATAWIDTH{1'b0}};
assign w_rx_out_data_10 = {CAM_PIXEL_RX_MEM_DATAWIDTH{1'b0}};
assign w_rx_out_data_11 = {CAM_PIXEL_RX_MEM_DATAWIDTH{1'b0}};
assign rx_out_dt        = 6'd0;
""")

# camera block: add the sim frame ports
s = rep(s, "    .mipi_cam_type                          (rx_out_dt),\n",
        """    .mipi_cam_type                          (rx_out_dt),
`ifdef SIM
    // Simulation frame data from testbench
    .sim_cam_hsync                          (sim_cam_hsync),
    .sim_cam_vsync                          (sim_cam_vsync),
    .sim_cam_valid                          (sim_cam_valid),
    .sim_cam_r_pix                          (sim_cam_r_pix),
    .sim_cam_g_pix                          (sim_cam_g_pix),
    .sim_cam_b_pix                          (sim_cam_b_pix),
`endif
""")

# ---------------------------------------------------------------- display: not simulated
s = cut(s, "/* I2C initialization for ADV7511 */\n", "    .o_rstn         ()\n);\n",
        """// SIM: ADV7511 I2C configuration not simulated.
assign w_hdmi_confdone = 1'b0;
assign o_hdmi_sda_oe   = 1'b0;
assign o_hdmi_scl_oe   = 1'b0;
""")

s = cut(s, "display_hdmi_yuv #(\n", "    .ov16HdmiYuvData                    (hdmi_yuv_data)\n);\n",
        """// SIM: HDMI timing generator not simulated. As in the Ti180 sim top the
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
""")

# ddrm0_reset is declared but never driven in edge_vision_soc.v; synthesis
# turns the undriven net into 0, a simulator would leave it Z and the
# peripheral reset would stay X. Tie it to 0 to match the hardware.
s = rep(s, "    wire ddrm0_reset;                   // per-port reset, SoC OUTPUT\n",
        "    wire ddrm0_reset = 1'b0;            // SIM: undriven in edge_vision_soc.v; synthesis makes it 0\n")

# ---------------------------------------------------------------- DDR3 status LEDs
s = cut(s, "    //=========================================================================\n    // Ti125 DEVICE: status LEDs",
        "    assign o_led = LED_ACTIVE_LOW ? ~led_raw : led_raw;\n",
        "    // SIM: DDR3L status / heartbeat LEDs not simulated.\n    assign o_led = 2'b00;\n")

# keep the original copyright/notes header after ours
s = hdr + s

# sanity: nothing that only existed for the removed hardware may remain
leftover = [b for b in ["u_ddr3 (", "csi2_rx_cam inst", "cam_ck_CLKOUT", "tdqss_clk", "`DRAM_", "`WFIFO",
                        "VIDEO_MAX_HRES", "CLK_FREQ_HZ", "por_done", "w_cal_done", "display_hdmi_adv7511_config #"]
            if b in s]
assert not leftover, leftover

open(dst, "w", encoding="utf-8", newline="\n").write(s)
print("wrote", dst, len(s.splitlines()), "lines")
