
// synopsys translate_off
`timescale 1 ns / 1 ps													
// synopsys translate_on

module TI60_MIPI_csi_tb ();
	
logic mipi_dphy_tx_clk_LP_P_OUT, mipi_dphy_tx_clk_LP_N_OUT;
logic mipi_dphy_tx_data0_LP_P_OUT, mipi_dphy_tx_data0_LP_N_OUT;
logic mipi_dphy_tx_data1_LP_P_OUT, mipi_dphy_tx_data1_LP_N_OUT;
logic mipi_dphy_tx_data2_LP_P_OUT, mipi_dphy_tx_data2_LP_N_OUT;
logic mipi_dphy_tx_data3_LP_P_OUT, mipi_dphy_tx_data3_LP_N_OUT;
logic [7:0] mipi_dphy_tx_data0_HS_OUT;
logic [7:0] mipi_dphy_tx_data1_HS_OUT;
logic [7:0] mipi_dphy_tx_data2_HS_OUT;
logic [7:0] mipi_dphy_tx_data3_HS_OUT;
logic mipi_dphy_tx_data0_HS_OE;
logic mipi_dphy_tx_data1_HS_OE;
logic mipi_dphy_tx_data2_HS_OE;
logic mipi_dphy_tx_data3_HS_OE;
logic reset_n;
logic mipi_clk, pixel_clk, pclk;


localparam real HS_BYTECLK_MHZ = 100;
localparam real HS_BYTECLK_NS = 10;  //1000/100
localparam real DATARATE = 800;
localparam real DATARATE_NS = 1.25;   //1000/800
localparam NUM_DATA_LANE = 4;
localparam real PIXELCLK_MHZ = 66.67; //(DATARATE * NUM_DATA_LANE) / PACK_BIT;
localparam real PIXELCLK_NS = 15;

initial begin
    $display (" Mipi test: begin @ %0t",$time);
    reset_n = 1'b0;
    #1
    reset_n = 1'b1;
    $display (" Mipi test: reset released @ %0t",$time);
    #34ms;
    $display (" Mipi test: simulation done @ %0t",$time);

    $display (" Mipi test: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    if (inst_dut.w_hsync_match && inst_dut.w_vsync_match && inst_dut.w_pdata_match && inst_dut.w_vdata_match) begin
        $display(" Mipi test: RESULT ...... TEST PASSED ^_^ ");
    end
    else begin
        $display(" Mipi test: RESULT ...... TEST FAILED !!!!! ");
    end
    $display (" Mipi test: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    
    $finish(1);
end

initial begin   //100Mhz
	mipi_clk = 0;
	forever #(10ns/2) mipi_clk = ~mipi_clk;
end

initial begin   //100Mhz
	pixel_clk = 0;
	forever #(PIXELCLK_NS/2) pixel_clk = ~pixel_clk;
end
initial begin
	pclk = 0;
	forever #(HS_BYTECLK_NS/2) pclk = ~pclk;
end

top #(
    .HS_BYTECLK_MHZ (HS_BYTECLK_MHZ)
) inst_dut (
    .mipi_clk       (mipi_clk   ),
    .reset_n        (reset_n    ),
    .led            (           ),
    .pixel_clk      (pixel_clk  ),
    .i_pll1_locked  (1'b1       ),
    .i_pll2_locked  (1'b1       ),
    .i_inject_err_n (1'b1       ),
    .pll_rstn       (           ),
    .mipi_dphy_rx_clk_LP_P_IN     (mipi_dphy_tx_clk_LP_P_OUT),
    .mipi_dphy_rx_clk_LP_N_IN     (mipi_dphy_tx_clk_LP_N_OUT),
    .mipi_dphy_rx_clk_HS_TERM     (),
    .mipi_dphy_rx_clk_HS_ENA      (), 
    .mipi_dphy_rx_clk_CLKOUT      (pclk),
    .mipi_dphy_rx_data0_HS_IN      (mipi_dphy_tx_data0_HS_OUT),
    .mipi_dphy_rx_data0_LP_P_IN    (mipi_dphy_tx_data0_LP_P_OUT),
    .mipi_dphy_rx_data0_LP_N_IN    (mipi_dphy_tx_data0_LP_N_OUT),
    .mipi_dphy_rx_data1_HS_IN      (mipi_dphy_tx_data1_HS_OUT),
    .mipi_dphy_rx_data1_LP_P_IN    (mipi_dphy_tx_data1_LP_P_OUT),
    .mipi_dphy_rx_data1_LP_N_IN    (mipi_dphy_tx_data1_LP_N_OUT),
    .mipi_dphy_rx_data2_HS_IN      (mipi_dphy_tx_data2_HS_OUT),
    .mipi_dphy_rx_data2_LP_P_IN    (mipi_dphy_tx_data2_LP_P_OUT),
    .mipi_dphy_rx_data2_LP_N_IN    (mipi_dphy_tx_data2_LP_N_OUT),
    .mipi_dphy_rx_data3_HS_IN      (mipi_dphy_tx_data3_HS_OUT),
    .mipi_dphy_rx_data3_LP_P_IN    (mipi_dphy_tx_data3_LP_P_OUT),
    .mipi_dphy_rx_data3_LP_N_IN    (mipi_dphy_tx_data3_LP_N_OUT),
    .mipi_dphy_rx_data0_HS_TERM    (),
    .mipi_dphy_rx_data0_HS_ENA     (),
    .mipi_dphy_rx_data0_FIFO_RD    (),
    .mipi_dphy_rx_data0_FIFO_EMPTY (),
    .mipi_dphy_rx_data0_DLY_RST    (),
    .mipi_dphy_rx_data0_DLY_INC    (),
    .mipi_dphy_rx_data0_DLY_ENA    (),
    .mipi_dphy_rx_data1_HS_TERM    (),
    .mipi_dphy_rx_data1_HS_ENA     (),
    .mipi_dphy_rx_data1_FIFO_RD    (),
    .mipi_dphy_rx_data1_FIFO_EMPTY (),
    .mipi_dphy_rx_data1_DLY_RST    (),
    .mipi_dphy_rx_data1_DLY_INC    (),
    .mipi_dphy_rx_data1_DLY_ENA    (),
    .mipi_dphy_rx_data2_HS_TERM    (),
    .mipi_dphy_rx_data2_HS_ENA     (),
    .mipi_dphy_rx_data2_FIFO_RD    (),
    .mipi_dphy_rx_data2_FIFO_EMPTY (),
    .mipi_dphy_rx_data2_DLY_RST    (),
    .mipi_dphy_rx_data2_DLY_INC    (),
    .mipi_dphy_rx_data2_DLY_ENA    (),
    .mipi_dphy_rx_data3_HS_TERM    (),
    .mipi_dphy_rx_data3_HS_ENA     (),
    .mipi_dphy_rx_data3_FIFO_RD    (),
    .mipi_dphy_rx_data3_FIFO_EMPTY (),
    .mipi_dphy_rx_data3_DLY_RST    (),
    .mipi_dphy_rx_data3_DLY_INC    (),
    .mipi_dphy_rx_data3_DLY_ENA    (),
    
    .mipi_dphy_tx_SLOWCLK         (pclk),
    .mipi_dphy_tx_HS_enable_C     (),
    .mipi_dphy_tx_clk_LP_P_OE     (),
    .mipi_dphy_tx_clk_LP_N_OE     (),
    .mipi_dphy_tx_data0_HS_OE     (),
    .mipi_dphy_tx_data0_LP_N_OE   (),
    .mipi_dphy_tx_data0_LP_P_OE   (),
    .mipi_dphy_tx_data1_HS_OE     (),
    .mipi_dphy_tx_data1_LP_N_OE   (),
    .mipi_dphy_tx_data1_LP_P_OE   (),
    .mipi_dphy_tx_data2_HS_OE     (),
    .mipi_dphy_tx_data2_LP_N_OE   (),
    .mipi_dphy_tx_data2_LP_P_OE   (),
    .mipi_dphy_tx_data3_HS_OE     (),
    .mipi_dphy_tx_data3_LP_N_OE   (),
    .mipi_dphy_tx_data3_LP_P_OE   (),
    .mipi_dphy_tx_clk_LP_P_OUT    (mipi_dphy_tx_clk_LP_P_OUT),
    .mipi_dphy_tx_clk_LP_N_OUT    (mipi_dphy_tx_clk_LP_N_OUT),
    .mipi_dphy_tx_data0_HS_OUT    (mipi_dphy_tx_data0_HS_OUT),
    .mipi_dphy_tx_data0_LP_N_OUT  (mipi_dphy_tx_data0_LP_N_OUT),
    .mipi_dphy_tx_data0_LP_P_OUT  (mipi_dphy_tx_data0_LP_P_OUT),
    .mipi_dphy_tx_data1_HS_OUT    (mipi_dphy_tx_data1_HS_OUT),
    .mipi_dphy_tx_data1_LP_N_OUT  (mipi_dphy_tx_data1_LP_N_OUT),
    .mipi_dphy_tx_data1_LP_P_OUT  (mipi_dphy_tx_data1_LP_P_OUT),
    .mipi_dphy_tx_data2_HS_OUT    (mipi_dphy_tx_data2_HS_OUT),
    .mipi_dphy_tx_data2_LP_N_OUT  (mipi_dphy_tx_data2_LP_N_OUT),
    .mipi_dphy_tx_data2_LP_P_OUT  (mipi_dphy_tx_data2_LP_P_OUT),
    .mipi_dphy_tx_data3_HS_OUT    (mipi_dphy_tx_data3_HS_OUT),
    .mipi_dphy_tx_data3_LP_N_OUT  (mipi_dphy_tx_data3_LP_N_OUT),
    .mipi_dphy_tx_data3_LP_P_OUT  (mipi_dphy_tx_data3_LP_P_OUT)
);

endmodule
