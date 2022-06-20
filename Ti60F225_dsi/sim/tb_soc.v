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

`timescale 100ps/10ps

`define NOC 1

module tb_soc ();

`include "hbram_define.vh"
`include "image_64_48.vh"

localparam FRAME_WIDTH        = 64;
localparam FRAME_HEIGHT       = 48;

//Not following any standard, just maintaining frame rate as most cameras would do
//Negative polarity hsync and vsync, blanking are set based on scaled-down resolution to speed up simulation process
localparam FRAME_PER_SECOND   = 5;
localparam H_FRONT_PORCH      = 50;   //Make sure allocate sufficient blanking to facilitate 4PPC to 2PPC mapping and DMA transfer. **Should be able to catch up with actual camera captured frames.
localparam H_SYNC_PULSE       = 10;
localparam H_BACK_PORCH       = 10;
localparam V_FRONT_PORCH      = 2;
localparam V_SYNC_PULSE       = 1;
localparam V_BACK_PORCH       = 2;
localparam CLK_PER_SECOND     = 8000;
localparam BALANCE_BLANKING   = CLK_PER_SECOND - (FRAME_PER_SECOND*((FRAME_WIDTH/2 + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH) * (FRAME_HEIGHT + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH)));

localparam tCYC               = (1000000/MHZ);
localparam TS                 = tCYC/100;
localparam U_DLY              = 0;

localparam LINEAR             = 1'b1;
localparam WAPPED             = 1'b0;
localparam REG                = 1'b1;
localparam MEM                = 1'b0;
localparam IR0                = 'b0000_0000_0000_0000;
localparam IR1                = 'b0000_0000_0000_0001;
localparam CR0                = 'b0000_1000_0000_0000;
localparam CR1                = 'b0000_1000_0000_0001;

reg                     rst_clk_gen;
reg                     i_hbramClk_pll_locked;
reg                     i_pll_locked;
reg                     i_mipi_tx_pll_locked;
reg                     i_arstn;

wire                    i_fb_clk;         //25MHz
wire                    i_sysclk_div_2;   //62.5MHz
wire                    i_mipi_rx_pclk;   //100MHz
wire                    i_mipi_clk;       //100MHz
wire                    i_mipi_tx_pclk;   //125MHz
wire                    i_hbramClk;       //200MHz
wire                    i_hbramClk90;     //200MHz
wire                    i_systemClk;      //300MHz

wire [2:0]              o_hbc_cal_SHIFT;
wire                    hbc_rst_n;
wire                    hbc_cs_n;
wire                    hbc_ck_p_HI;
wire                    hbc_ck_p_LO;
wire                    hbc_ck_n_HI;
wire                    hbc_ck_n_LO;
wire [RAM_DBW/8-1:0]    hbc_rwds_OUT_HI;
wire [RAM_DBW/8-1:0]    hbc_rwds_OUT_LO;
wire [RAM_DBW/8-1:0]    hbc_rwds_IN_HI;
wire [RAM_DBW/8-1:0]    hbc_rwds_IN_LO;
wire [RAM_DBW/8-1:0]    hbc_rwds_OE;
wire [RAM_DBW-1:0]      hbc_dq_OUT_HI;
wire [RAM_DBW-1:0]      hbc_dq_OUT_LO;
wire [RAM_DBW-1:0]      hbc_dq_IN_LO;
wire [RAM_DBW-1:0]      hbc_dq_IN_HI;
wire [RAM_DBW-1:0]      hbc_dq_OE;
//hyperbus ram signals
wire                    ram_rst_n;
wire                    ram_cs_n;
wire                    ram_ck_p;
wire                    ram_ck_n;
wire [RAM_DBW/8-1:0]    ram_rwds;
reg  [RAM_DBW/8-1:0]    ram_rds;
wire [RAM_DBW-1:0]      ram_dq;

wire                    hbc_cal_pass;

//Generate clock with/without phase shift
clock_gen #(
   .FREQ_CLK_MHZ(25)
) u_gen_i_fb_clk (
   .rst        (rst_clk_gen),
   .clk_out0   (i_fb_clk),
   .clk_out45  (),
   .clk_out90  (),
   .clk_out135 (),
   .locked     ()
);

clock_gen #(
   .FREQ_CLK_MHZ(62)
) u_gen_i_sysclk_div_2 (
   .rst        (rst_clk_gen),
   .clk_out0   (i_sysclk_div_2),
   .clk_out45  (),
   .clk_out90  (),
   .clk_out135 (),
   .locked     ()
);

clock_gen #(
   .FREQ_CLK_MHZ(100)
) u_gen_i_mipi_rx_pclk (
   .rst        (rst_clk_gen),
   .clk_out0   (i_mipi_rx_pclk),
   .clk_out45  (),
   .clk_out90  (),
   .clk_out135 (),
   .locked     ()
);

clock_gen #(
   .FREQ_CLK_MHZ(100)
) u_gen_i_mipi_clk (
   .rst        (rst_clk_gen),
   .clk_out0   (i_mipi_clk),
   .clk_out45  (),
   .clk_out90  (),
   .clk_out135 (),
   .locked     ()
);

clock_gen #(
   .FREQ_CLK_MHZ(125)
) u_gen_i_mipi_tx_pclk (
   .rst        (rst_clk_gen),
   .clk_out0   (i_mipi_tx_pclk),
   .clk_out45  (),
   .clk_out90  (),
   .clk_out135 (),
   .locked     ()
);

clock_gen #(
   .FREQ_CLK_MHZ(200)
) u_gen_hbramClk (
   .rst        (rst_clk_gen),
   .clk_out0   (i_hbramClk),
   .clk_out45  (),
   .clk_out90  (i_hbramClk90),
   .clk_out135 (),
   .locked     ()
);

clock_gen #(
   .FREQ_CLK_MHZ(25)
) u_gen_i_systemClk (
   .rst        (rst_clk_gen),
   .clk_out0   (i_systemClk),
   .clk_out45  (),
   .clk_out90  (),
   .clk_out135 (),
   .locked     ()
);

always @ ( * ) begin
   case(o_hbc_cal_SHIFT)
      3'b000:
         ram_rds <= #(0*TS/8) i_hbramClk;
      3'b001:
         ram_rds <= #(1*TS/8) i_hbramClk;
      3'b010:
         ram_rds <= #(2*TS/8) i_hbramClk;
      3'b011:
         ram_rds <= #(3*TS/8) i_hbramClk;
      3'b100:
         ram_rds <= #(4*TS/8) i_hbramClk;
      3'b101:
         ram_rds <= #(5*TS/8) i_hbramClk;          
      3'b110:
         ram_rds <= #(6*TS/8) i_hbramClk;
      3'b111:
         ram_rds <= #(7*TS/8) i_hbramClk;
      default:
         ram_rds <= #(0*TS/8) i_hbramClk;
   endcase
end

//RST_N
assign ram_rst_n = hbc_rst_n;

//Simulation frame data
reg          cam_hsync;
reg          cam_vsync;
reg          cam_valid;
reg [15:0]   cam_r_pix;
reg [15:0]   cam_g_pix;
reg [15:0]   cam_b_pix;
//Simulation frame data (Registered)
reg          sim_cam_hsync;
reg          sim_cam_vsync;
reg          sim_cam_valid;
reg [15:0]   sim_cam_r_pix;
reg [15:0]   sim_cam_g_pix;
reg [15:0]   sim_cam_b_pix;

//Counters for checking
reg [31:0]   cam_valid_count;
reg [31:0]   display_valid_count;
reg [31:0]   hw_accel_in_valid_count;
reg [31:0]   hw_accel_out_valid_count;

integer x;
integer y;
integer frame;
integer outfile1;
integer outfile2;

initial
begin: main
   $display($time,,"--------------------------------------------");
   $display($time,,"[EFX_INFO]: Start Edge Vision SoC Simulation");
   $display($time,,"--------------------------------------------");

   i_hbramClk_pll_locked    = 1'b0;
   i_pll_locked             = 1'b0;
   i_mipi_tx_pll_locked     = 1'b0;
   rst_clk_gen              = 1'b1;
   i_arstn                  = 1'b0;
   
   cam_hsync                = 1'b1;
   cam_vsync                = 1'b1;
   cam_valid                = 1'b0;
   cam_r_pix                = 16'd0;
   cam_g_pix                = 16'd0;
   cam_b_pix                = 16'd0;
   
   cam_valid_count          = 32'd0;
   display_valid_count      = 32'd0;
   hw_accel_in_valid_count  = 32'd0;
   hw_accel_out_valid_count = 32'd0;
   
   #(100*TS);
   rst_clk_gen              = 1'b0;
   #3000
   i_hbramClk_pll_locked    = 1'b1;
   i_pll_locked             = 1'b1;
   i_mipi_tx_pll_locked     = 1'b1;
   
   repeat (50) @(posedge i_systemClk);
   i_arstn                  = 1'b1;
   
   repeat (50) @(posedge i_systemClk);
   
   fork
      //Branch 1: Video data Generation (offline/Static frame data)
      begin
         repeat (50) @(posedge i_mipi_rx_pclk);
         //For camera sensors, they will burst out data according to their high speed clock, which means they will have high line rate.
         //Then they will insert a lot of blanking time to maintain target frame rate.
         //Most of the cameras will only follow frame rate. Few cameras can have slave mode to receive sync signals as reference.
         while (1) begin
            for (frame=0; frame<FRAME_PER_SECOND; frame=frame+1) begin   
               for (y=0; y<(FRAME_HEIGHT+V_FRONT_PORCH+V_SYNC_PULSE+V_BACK_PORCH); y=y+1) begin
                  
                  if (y < V_SYNC_PULSE) begin
                     cam_vsync = 1'b0;
                  end else begin
                     cam_vsync = 1'b1;
                  end
               
                  for (x=0; x<FRAME_WIDTH/2; x=x+1) begin   //2PPC
                     if ((y >= V_SYNC_PULSE+V_BACK_PORCH) && (y < FRAME_HEIGHT+V_BACK_PORCH+V_SYNC_PULSE)) begin
                        cam_valid = 1'b1;
                        cam_r_pix = {IMG_DATA[(y-(V_SYNC_PULSE+V_BACK_PORCH))*FRAME_WIDTH + (x*2+1)][7:0]  , IMG_DATA[(y-(V_SYNC_PULSE+V_BACK_PORCH))*FRAME_WIDTH + (x*2)][7:0]  };
                        cam_g_pix = {IMG_DATA[(y-(V_SYNC_PULSE+V_BACK_PORCH))*FRAME_WIDTH + (x*2+1)][15:8] , IMG_DATA[(y-(V_SYNC_PULSE+V_BACK_PORCH))*FRAME_WIDTH + (x*2)][15:8] };
                        cam_b_pix = {IMG_DATA[(y-(V_SYNC_PULSE+V_BACK_PORCH))*FRAME_WIDTH + (x*2+1)][23:16], IMG_DATA[(y-(V_SYNC_PULSE+V_BACK_PORCH))*FRAME_WIDTH + (x*2)][23:16]};
                        @(posedge i_mipi_rx_pclk);
                     end else begin
                        cam_valid = 1'b0;
                        cam_r_pix = 16'd0;
                        cam_g_pix = 16'd0;
                        cam_b_pix = 16'd0;
                        @(posedge i_mipi_rx_pclk);
                     end
                  end
                  
                  //Horizontal blanking
                  cam_valid = 1'b0;
                  cam_r_pix = 16'd0;
                  cam_g_pix = 16'd0;
                  cam_b_pix = 16'd0;
                  repeat(H_FRONT_PORCH) @(posedge i_mipi_rx_pclk);
                  
                  //HSYNC pulse
                  if ((y >= V_SYNC_PULSE+V_BACK_PORCH) && (y < FRAME_HEIGHT+V_BACK_PORCH+V_SYNC_PULSE)) begin
                     cam_hsync = 1'b0;
                  end else begin
                     cam_hsync = 1'b1;
                  end
                  repeat(H_SYNC_PULSE) @(posedge i_mipi_rx_pclk);
                  
                  cam_hsync = 1'b1;
                  repeat(H_BACK_PORCH) @(posedge i_mipi_rx_pclk);
               end
            end
            
            repeat(BALANCE_BLANKING) @(posedge i_mipi_rx_pclk);
         end
      end
      
      //Branch 2: Camera building block DMA data counter (write to DDR)
      begin
         @(posedge i_mipi_rx_pclk);
         
         while(1) begin
            cam_valid_count = (DUT_wrapper.DUT.cam_dma_wvalid) ? cam_valid_count + 1'b1 : cam_valid_count;
            @(posedge i_mipi_rx_pclk);
         end
      end
      
      //Branch 3: HW accelerator building block input DMA data counter (read from DDR) & Save to file (HW accelerator input data)
      begin
         @(posedge i_systemClk);
      
         outfile1 = $fopen("grayscale_out.txt");
         while (hw_accel_in_valid_count < (FRAME_WIDTH*FRAME_HEIGHT)) begin
            if (DUT_wrapper.DUT.hw_accel_dma_rvalid && (&DUT_wrapper.DUT.hw_accel_dma_rkeep) && DUT_wrapper.DUT.hw_accel_dma_rready) begin
               $fwrite(outfile1, "%x\n", DUT_wrapper.DUT.hw_accel_dma_rdata[31:0]);
               hw_accel_in_valid_count = hw_accel_in_valid_count + 32'd1;
            end
            @(posedge i_systemClk);
         end
         $fclose(outfile1);
         $display($time,,"[EFX_INFO]: Done written grayscale output to file.."); //Post RISC-V embedded SW processing
         
         repeat(100) @(posedge i_systemClk);
      end
      
      //Branch 4: HW accelerator building block output DMA data counter (write to DDR)
      begin
         @(posedge i_systemClk);
         
         while(1) begin
            hw_accel_out_valid_count = (DUT_wrapper.DUT.hw_accel_dma_wvalid) ? hw_accel_out_valid_count + 1'b1 : hw_accel_out_valid_count;
            @(posedge i_systemClk);
         end
      end
    
      //Branch 5: Display building block input DMA data counter (read from DDR) & Save to file (display input data)
      //Single frame display DMA transfer for checking. Check MM2S DMA output to display. Do not check frame forming and LVDS format
      begin         
         @(posedge i_sysclk_div_2);
      
         outfile2 = $fopen("display_out.txt");
         while (display_valid_count < ((FRAME_WIDTH/2)*FRAME_HEIGHT)) begin
            if (DUT_wrapper.DUT.display_dma_rvalid && (&DUT_wrapper.DUT.display_dma_rkeep) && DUT_wrapper.DUT.display_dma_rready) begin
               $fwrite(outfile2, "%x\n", DUT_wrapper.DUT.display_dma_rdata[31:0]);
               $fwrite(outfile2, "%x\n", DUT_wrapper.DUT.display_dma_rdata[63:32]);
               display_valid_count = display_valid_count + 32'd1;
            end
            @(posedge i_sysclk_div_2);
         end
         $fclose(outfile2);
         $display($time,,"[EFX_INFO]: Done written display side output to file..");
         
         repeat(100) @(posedge i_sysclk_div_2);
         $display($time,,"[EFX_INFO]: Simulation Completed..");
         $stop;
      end

/*
      //Branch 5: For self restart display DMA transfer, first valid frame data to display building block might be random initial data in memory.
      //Save to file HW accelerator building block output DMA data (write to DDR)
      begin         
         @(posedge i_systemClk);
      
         outfile2 = $fopen("display_out.txt");
         while (display_valid_count < (FRAME_WIDTH*FRAME_HEIGHT)) begin
            if (DUT_wrapper.DUT.hw_accel_dma_wvalid) begin
               $fwrite(outfile2, "%x\n", DUT_wrapper.DUT.hw_accel_dma_wdata);
               display_valid_count = display_valid_count + 32'd1;
            end
            @(posedge i_systemClk);
         end
         $fclose(outfile2);
         $display($time,,"[EFX_INFO]: Done written hw accel side output to file..");
         
         repeat(100) @(posedge i_systemClk);
         $display($time,,"[EFX_INFO]: Simulation Completed..");
         $stop;
      end
*/
   
   join
   
end: main

//Registered - Ensure synced to mipi_pclk
always@(posedge i_mipi_rx_pclk)
begin
   sim_cam_hsync <= cam_hsync;
   sim_cam_vsync <= cam_vsync;
   sim_cam_valid <= cam_valid;
   sim_cam_r_pix <= cam_r_pix;
   sim_cam_g_pix <= cam_g_pix;
   sim_cam_b_pix <= cam_b_pix;
end

initial 
begin: hyperRAM_cal
   wait (hbc_cal_pass);
   $display($time,,"-----------------------------------------");
   $display($time,,"[EFX_INFO]: HBRAM CALIBRATION PASS");
   $display($time,,"-----------------------------------------");
end: hyperRAM_cal

initial 
begin: timeout
   #500000000
   $display($time,,"-----------------------------------------");
   $display($time,,"[EFX_FATAL]: Simulation timeout, aborting simulation  ");
   $display($time,,"-----------------------------------------");
   $finish;
end: timeout


edge_vision_soc_wrapper #(
   .FRAME_WIDTH         (FRAME_WIDTH),
   .FRAME_HEIGHT        (FRAME_HEIGHT)
) DUT_wrapper (
   .i_arstn                            (i_arstn),
   .i_fb_clk                           (i_fb_clk),
   .i_sysclk_div_2                     (i_sysclk_div_2),
   .i_mipi_rx_pclk                     (i_mipi_rx_pclk),
   .i_pll_locked                       (i_pll_locked),
   .i_mipi_clk                         (i_mipi_clk),
   .i_mipi_txc_sclk                    (), //Not used in RTL
   .i_mipi_txd_sclk                    (), //Not used in RTL
   .i_mipi_tx_pclk                     (i_mipi_tx_pclk),
   .i_mipi_tx_pll_locked               (i_mipi_tx_pll_locked),
   .i_hbramClk                         (i_hbramClk),
   .i_hbramClk_cal                     (ram_rds[0]),
   .i_hbramClk90                       (i_hbramClk90),
   .i_systemClk                        (i_systemClk),
   .i_hbramClk_pll_locked              (i_hbramClk_pll_locked),
   .o_lcd_rstn                         (),
   .o_pll_rstn                         (),
   .o_mipi_pll_rstn                    (),
   .mipi_i2c_0_io_sda                  (),
   .mipi_i2c_0_io_scl                  (),
   .o_cam_rstn                         (),
   .i_cam_ck_LP_P_IN                   (1'b0),
   .i_cam_ck_LP_N_IN                   (1'b0),
   .o_cam_ck_HS_TERM                   (),
   .o_cam_ck_HS_ENA                    (),
   .i_cam_ck_CLKOUT_0                  (1'b0),
   .i_cam_d0_HS_IN_0                   (8'd0),
   .i_cam_d0_HS_IN_1                   (8'd0),
   .i_cam_d0_HS_IN_2                   (8'd0),
   .i_cam_d0_HS_IN_3                   (8'd0),
   .i_cam_d0_LP_P_IN                   (1'b0),
   .i_cam_d0_LP_N_IN                   (1'b0),
   .o_cam_d0_HS_TERM                   (),
   .o_cam_d0_HS_ENA                    (),
   .o_cam_d0_RST                       (),
   .o_cam_d0_FIFO_RD                   (),
   .i_cam_d0_FIFO_EMPTY                (1'b0),
   .i_cam_d1_HS_IN_0                   (8'd0),
   .i_cam_d1_HS_IN_1                   (8'd0),
   .i_cam_d1_HS_IN_2                   (8'd0),
   .i_cam_d1_HS_IN_3                   (8'd0),
   .i_cam_d1_LP_P_IN                   (1'b0),
   .i_cam_d1_LP_N_IN                   (1'b0),
   .o_cam_d1_HS_TERM                   (),
   .o_cam_d1_HS_ENA                    (),
   .o_cam_d1_RST                       (),
   .o_cam_d1_FIFO_RD                   (),
   .i_cam_d1_FIFO_EMPTY                (1'b0),
   .sim_cam_hsync                      (sim_cam_hsync),
   .sim_cam_vsync                      (sim_cam_vsync),
   .sim_cam_valid                      (sim_cam_valid),
   .sim_cam_r_pix                      (sim_cam_r_pix),
   .sim_cam_g_pix                      (sim_cam_g_pix),
   .sim_cam_b_pix                      (sim_cam_b_pix),
   .mipi_dp_clk_LP_P_OUT               (),
   .mipi_dp_clk_LP_N_OUT               (),
   .mipi_dp_clk_HS_OUT                 (),
   .mipi_dp_clk_HS_OE                  (),
   .mipi_dp_data3_LP_P_OUT             (),
   .mipi_dp_data2_LP_P_OUT             (),
   .mipi_dp_data1_LP_P_OUT             (),
   .mipi_dp_data0_LP_P_OUT             (),
   .mipi_dp_data3_LP_N_OUT             (),
   .mipi_dp_data2_LP_N_OUT             (),
   .mipi_dp_data1_LP_N_OUT             (),
   .mipi_dp_data0_LP_N_OUT             (),
   .mipi_dp_data0_HS_OUT               (),
   .mipi_dp_data1_HS_OUT               (),
   .mipi_dp_data2_HS_OUT               (),
   .mipi_dp_data3_HS_OUT               (),
   .mipi_dp_data3_HS_OE                (),
   .mipi_dp_data2_HS_OE                (),
   .mipi_dp_data1_HS_OE                (),
   .mipi_dp_data0_HS_OE                (),
   .mipi_dp_clk_RST                    (),
   .mipi_dp_data0_RST                  (),
   .mipi_dp_data1_RST                  (),
   .mipi_dp_data2_RST                  (),
   .mipi_dp_data3_RST                  (),
   .mipi_dp_clk_LP_P_OE                (),
   .mipi_dp_clk_LP_N_OE                (),
   .mipi_dp_data3_LP_P_OE              (),
   .mipi_dp_data3_LP_N_OE              (),
   .mipi_dp_data2_LP_P_OE              (),
   .mipi_dp_data2_LP_N_OE              (),
   .mipi_dp_data1_LP_P_OE              (),
   .mipi_dp_data1_LP_N_OE              (),
   .mipi_dp_data0_LP_P_OE              (),
   .mipi_dp_data0_LP_N_OE              (),
   .mipi_dp_data0_LP_P_IN              (1'b0),
   .mipi_dp_data0_LP_N_IN              (1'b0),
   .sw1                                (1'b1),
   .sw6                                (1'b1),
   .sw7                                (1'b1),
   .user_dip0                          (1'b0),
   .user_dip1                          (1'b0),
   .o_led                              (),
   .hbc_cal_pass                       (hbc_cal_pass),
   .system_uart_0_io_txd               (),
   .system_uart_0_io_rxd               (1'b0),
   .hbc_rst_n                          (hbc_rst_n),
   .hbc_cs_n                           (hbc_cs_n),
   .hbc_ck_p_HI                        (hbc_ck_p_HI),
   .hbc_ck_p_LO                        (hbc_ck_p_LO),
   .hbc_ck_n_HI                        (hbc_ck_n_HI),
   .hbc_ck_n_LO                        (hbc_ck_n_LO),
   .hbc_rwds_OUT_HI                    (hbc_rwds_OUT_HI),
   .hbc_rwds_OUT_LO                    (hbc_rwds_OUT_LO),
   .hbc_rwds_IN_HI                     (hbc_rwds_IN_HI),
   .hbc_rwds_IN_LO                     (hbc_rwds_IN_LO),
   .hbc_rwds_OE                        (hbc_rwds_OE),
   .hbc_dq_OUT_HI                      (hbc_dq_OUT_HI),
   .hbc_dq_OUT_LO                      (hbc_dq_OUT_LO),
   .hbc_dq_IN_LO                       (hbc_dq_IN_LO),
   .hbc_dq_IN_HI                       (hbc_dq_IN_HI),
   .hbc_dq_OE                          (hbc_dq_OE),
   .o_hbc_cal_SHIFT                    (o_hbc_cal_SHIFT),
   .o_hbc_cal_SHIFT_SEL                (),
   .o_hbc_cal_SHIFT_ENA                (),
   .o_hbramClk_pll_rstn                (),
   .system_spi_0_io_sclk_write         (),
   .system_spi_0_io_data_0_writeEnable (),
   .system_spi_0_io_data_0_read        (1'b0),
   .system_spi_0_io_data_0_write       (),
   .system_spi_0_io_data_1_writeEnable (),
   .system_spi_0_io_data_1_read        (1'b0),
   .system_spi_0_io_data_1_write       (),
   .system_spi_0_io_ss                 (),
`ifndef SOFT_TAP
   .jtag_inst1_TCK                     (1'b0),
   .jtag_inst1_TDI                     (1'b0),
   .jtag_inst1_TDO                     (),
   .jtag_inst1_SEL                     (1'b0),
   .jtag_inst1_CAPTURE                 (1'b0),
   .jtag_inst1_SHIFT                   (1'b0),
   .jtag_inst1_UPDATE                  (1'b0),
   .jtag_inst1_RESET                   (1'b0)
`else
   .io_jtag_tms                        (1'b0),
   .io_jtag_tdi                        (1'b0),
   .io_jtag_tdo                        (),
   .io_jtag_tck                        (1'b0)
`endif
);

/////////////////////////////////////////////////////////////////////////////////
//CS_N
EFX_GPIO_model #(
   .BUS_WIDTH   (1        ), // define ddio bus width
   .TYPE        ("OUT"    ), // "IN"=input "OUT"=output "INOUT"=inout
   .OUT_REG     (1        ), // 1: enable 0: disable
   .OUT_DDIO    (0        ), // 1: enable 0: disable
   .OUT_RESYNC  (0        ), // 1: enable 0: disable
   .OUTCLK_INV  (0        ), // 1: enable 0: disable
   .OE_REG      (0        ), // 1: enable 0: disable
   .IN_REG      (0        ), // 1: enable 0: disable
   .IN_DDIO     (0        ), // 1: enable 0: disable
   .IN_RESYNC   (0        ), // 1: enable 0: disable
   .INCLK_INV   (0        )  // 1: enable 0: disable
) cs_n_inst (
   .out_HI      (hbc_cs_n    ), // tx HI data input from internal logic
   .out_LO      ({`NOC{1'b0}}), // tx LO data input from internal logic
   .outclk      (i_hbramClk  ), // tx data clk input from internal logic
   .oe          (1'b1        ), // tx data output enable from internal logic
   .in_HI       (            ), // rx HI data output to internal logic
   .in_LO       (            ), // rx LO data output to internal logic
   .inclk       (1'b0        ), // rx data clk input from internal logic
   .io          (ram_cs_n    )  // outside io signal
);
//CK_P
EFX_GPIO_model #(
   .BUS_WIDTH   (1        ), 
   .TYPE        ("OUT"    ), 
   .OUT_REG     (1        ), 
   .OUT_DDIO    (1        ), 
   .OUT_RESYNC  (0        ), 
   .OUTCLK_INV  (1        ), 
   .OE_REG      (0        ), 
   .IN_REG      (0        ), 
   .IN_DDIO     (0        ), 
   .IN_RESYNC   (0        ), 
   .INCLK_INV   (0        )  
) ck_p_inst (
   .out_HI      (hbc_ck_p_HI ), 
   .out_LO      (hbc_ck_p_LO ), 
   .outclk      (i_hbramClk90), 
   .oe          (1'b1        ), 
   .in_HI       (            ), 
   .in_LO       (            ), 
   .inclk       (1'b0        ), 
   .io          (ram_ck_p    )  
);
//CK_N
EFX_GPIO_model #(
   .BUS_WIDTH   (1           ), 
   .TYPE        ("OUT"       ), 
   .OUT_REG     (1           ), 
   .OUT_DDIO    (1           ), 
   .OUT_RESYNC  (0           ), 
   .OUTCLK_INV  (1           ), 
   .OE_REG      (0           ), 
   .IN_REG      (0           ), 
   .IN_DDIO     (0           ), 
   .IN_RESYNC   (0           ), 
   .INCLK_INV   (0           )  
) ck_n_inst (
   .out_HI      (hbc_ck_n_HI ), 
   .out_LO      (hbc_ck_n_LO ), 
   .outclk      (i_hbramClk90), 
   .oe          (1'b1        ), 
   .in_HI       (            ), 
   .in_LO       (            ), 
   .inclk       (1'b0        ), 
   .io          (ram_ck_n    )  
);

//RWDS
EFX_GPIO_model #(
   .BUS_WIDTH   (RAM_DBW/8   ), 
   .TYPE        ("INOUT"     ), 
   .OUT_REG     (1           ), 
   .OUT_DDIO    (1           ), 
   .OUT_RESYNC  (0           ), 
   .OUTCLK_INV  (0           ), 
   .OE_REG      (1           ), 
   .IN_REG      (1           ), 
   .IN_DDIO     (1           ), 
   .IN_RESYNC   (1           ), 
   .INCLK_INV   (0           )  
) rwds_inst (
   .out_HI      (hbc_rwds_OUT_HI), 
   .out_LO      (hbc_rwds_OUT_LO), 
   .outclk      (i_hbramClk     ), 
   .oe          (hbc_rwds_OE[0] ), 
   .in_HI       (hbc_rwds_IN_HI ), 
   .in_LO       (hbc_rwds_IN_LO ), 
   .inclk       (ram_rds[0]     ), 
   .io          (ram_rwds       )  
);

//DQ
EFX_GPIO_model #(
   .BUS_WIDTH   (RAM_DBW    ), 
   .TYPE        ("INOUT"    ), 
   .OUT_REG     (1          ), 
   .OUT_DDIO    (1          ), 
   .OUT_RESYNC  (0          ), 
   .OUTCLK_INV  (1          ), 
   .OE_REG      (1          ), 
   .IN_REG      (1          ), 
   .IN_DDIO     (1          ), 
   .IN_RESYNC   (1          ), 
   .INCLK_INV   (0          )  
) dq_inst (
   .out_HI      (hbc_dq_OUT_HI ), 
   .out_LO      (hbc_dq_OUT_LO ), 
   .outclk      (i_hbramClk    ), 
   .oe          (hbc_dq_OE[0]  ), 
   .in_HI       (hbc_dq_IN_HI  ), 
   .in_LO       (hbc_dq_IN_LO  ), 
   .inclk       (ram_rds[0]    ), 
   .io          (ram_dq        )  
);

//Hyperbus RAM
W958D6NKY ram_x16_inst(
   .adq        (ram_dq),       
   .clk        (ram_ck_p),    
   .clk_n      (1'b0),      
   .csb        (ram_cs_n),    
   .rwds       (ram_rwds),        
   .VCC        (1'b1),
   .VSS        (1'b0),
   .resetb     (ram_rst_n),
   .die_stack  (1'b0),
   .optddp     (1'b0)
);

endmodule
