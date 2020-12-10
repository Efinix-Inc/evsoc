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

module tb_soc ();

`include "image_64_48.vh"

//Use frame size & setting to reduce simulation time 
localparam FRAME_WIDTH         = 64;
localparam FRAME_HEIGHT        = 48;

//Not following any standard, just maintaining frame rate as most cameras would do
//Negative polarity hsync and vsync, blanking are set based on scaled-down resolution to speed up simulation process
localparam FRAME_PER_SECOND = 5;
localparam H_FRONT_PORCH    = 50;   //Make sure allocate sufficient blanking to facilitate 4PPC to 2PPC mapping and DMA transfer. **Should be able to catch up with actual camera captured frames.
localparam H_SYNC_PULSE     = 10;
localparam H_BACK_PORCH     = 10;
localparam V_FRONT_PORCH    = 2;
localparam V_SYNC_PULSE     = 1;
localparam V_BACK_PORCH     = 2;
localparam CLK_PER_SECOND   = 8000;
localparam BALANCE_BLANKING = CLK_PER_SECOND - (FRAME_PER_SECOND*((FRAME_WIDTH/2 + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH) * (FRAME_HEIGHT + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH)));

//DDR - 128-bit port
wire         io_ddrA_arw_valid;
wire         io_ddrA_arw_ready;
wire [31:0]  io_ddrA_arw_payload_addr;
wire [7:0]   io_ddrA_arw_payload_id;
wire [7:0]   io_ddrA_arw_payload_len;
wire [2:0]   io_ddrA_arw_payload_size;
wire [1:0]   io_ddrA_arw_payload_burst;
wire [1:0]   io_ddrA_arw_payload_lock;
wire         io_ddrA_arw_payload_write;
wire [7:0]   io_ddrA_w_payload_id;
wire         io_ddrA_w_valid;
wire         io_ddrA_w_ready;
wire [127:0] io_ddrA_w_payload_data;
wire [15:0]  io_ddrA_w_payload_strb;
wire         io_ddrA_w_payload_last;
wire         io_ddrA_b_valid;
wire         io_ddrA_b_ready;
wire [7:0]   io_ddrA_b_payload_id;
wire         io_ddrA_r_valid;
wire         io_ddrA_r_ready;
wire [127:0] io_ddrA_r_payload_data;
wire [7:0]   io_ddrA_r_payload_id;
wire [1:0]   io_ddrA_r_payload_resp;
wire         io_ddrA_r_payload_last;  
//DDR - 256-bit port
wire         io_ddrB_arw_valid;
wire         io_ddrB_arw_ready;
wire [31:0]  io_ddrB_arw_payload_addr;
wire [7:0]   io_ddrB_arw_payload_id;
wire [7:0]   io_ddrB_arw_payload_len;
wire [2:0]   io_ddrB_arw_payload_size;
wire [1:0]   io_ddrB_arw_payload_burst;
wire [1:0]   io_ddrB_arw_payload_lock;
wire         io_ddrB_arw_payload_write;
wire [7:0]   io_ddrB_w_payload_id;
wire         io_ddrB_w_valid;
wire         io_ddrB_w_ready;
wire [255:0] io_ddrB_w_payload_data;
wire [31:0]  io_ddrB_w_payload_strb;
wire         io_ddrB_w_payload_last;
wire         io_ddrB_b_valid;
wire         io_ddrB_b_ready;
wire [7:0]   io_ddrB_b_payload_id;
wire         io_ddrB_r_valid;
wire         io_ddrB_r_ready;
wire [255:0] io_ddrB_r_payload_data;
wire [7:0]   io_ddrB_r_payload_id;
wire [1:0]   io_ddrB_r_payload_resp;
wire         io_ddrB_r_payload_last;  

//Reset & Clock related
reg          i_pll_locked;
reg          ddr_clk_locked;
reg          axi_clk_locked;
reg          master_rstn;
reg          mipi_pclk;
reg          tx_slowclk;
reg          axi_clk;
reg          soc_clk;
reg          dma_clk;

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

//100MHz
initial
begin
   axi_clk = 1'b0;
   forever
      #5
      axi_clk = ~axi_clk;
end

//50MHz
initial
begin
   soc_clk = 1'b0;
   forever
      #10
      soc_clk = ~soc_clk;
end

//75MHz
initial
begin
   mipi_pclk  = 1'b0;
   forever
      #6.67
      mipi_pclk  = ~mipi_pclk;
end

//12.38MHz
initial
begin
   tx_slowclk = 1'b0;
   forever
      #40.41
      tx_slowclk = ~tx_slowclk;
end

//62.5MHz
initial
begin
   dma_clk = 1'b0;
   forever
      #8
      dma_clk = ~dma_clk;
end

initial 
begin:timeout
	#1000000000
	$display($time,,"[EFX_INFO]: Simulation timeout, end of simulation..");
	$stop;
end

initial
begin: main
   $display($time,,"--------------------------------------------");
	$display($time,,"[EFX_INFO]: Start Edge Vision SoC Simulation");
	$display($time,,"--------------------------------------------");

   master_rstn              = 1'b0;
   i_pll_locked             = 1'b0;
   ddr_clk_locked           = 1'b0;
   axi_clk_locked           = 1'b0;
   
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

   //Initial reset
   repeat (100) @(posedge soc_clk);
   master_rstn    = 1'b1;

   //PLL locked
   repeat (5) @(posedge soc_clk);
   i_pll_locked   = 1'b1;
   ddr_clk_locked = 1'b1;
   axi_clk_locked = 1'b1;
   repeat (5) @(posedge soc_clk);
   
   fork
      //Branch 1: Video data Generation (offline/Static frame data)
      begin
         repeat (50) @(posedge mipi_pclk);
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
                        @(posedge mipi_pclk);
                     end else begin
                        cam_valid = 1'b0;
                        cam_r_pix = 16'd0;
                        cam_g_pix = 16'd0;
                        cam_b_pix = 16'd0;
                        @(posedge mipi_pclk);
                     end
                  end
                  
                  //Horizontal blanking
                  cam_valid = 1'b0;
                  cam_r_pix = 16'd0;
                  cam_g_pix = 16'd0;
                  cam_b_pix = 16'd0;
                  repeat(H_FRONT_PORCH) @(posedge mipi_pclk);
                  
                  //HSYNC pulse
                  if ((y >= V_SYNC_PULSE+V_BACK_PORCH) && (y < FRAME_HEIGHT+V_BACK_PORCH+V_SYNC_PULSE)) begin
                     cam_hsync = 1'b0;
                  end else begin
                     cam_hsync = 1'b1;
                  end
                  repeat(H_SYNC_PULSE) @(posedge mipi_pclk);
                  
                  cam_hsync = 1'b1;
                  repeat(H_BACK_PORCH) @(posedge mipi_pclk);
               end
            end
            
            repeat(BALANCE_BLANKING) @(posedge mipi_pclk);
         end
      end
      
      //Branch 2: Camera building block DMA data counter (write to DDR)
      begin
         @(posedge mipi_pclk);
         
         while(1) begin
            cam_valid_count = (DUT_wrapper.DUT.cam_dma_wvalid) ? cam_valid_count + 1'b1 : cam_valid_count;
            @(posedge mipi_pclk);
         end
      end
      
      //Branch 3: HW accelerator building block input DMA data counter (read from DDR) & Save to file (HW accelerator input data)
      begin
         @(posedge axi_clk);
      
         outfile1 = $fopen("grayscale_out.txt");
         while (hw_accel_in_valid_count < (FRAME_WIDTH*FRAME_HEIGHT)) begin
            if (DUT_wrapper.DUT.hw_accel_dma_rvalid && (&DUT_wrapper.DUT.hw_accel_dma_rkeep) && DUT_wrapper.DUT.hw_accel_dma_rready) begin
               $fwrite(outfile1, "%x\n", DUT_wrapper.DUT.hw_accel_dma_rdata[31:0]);
               hw_accel_in_valid_count = hw_accel_in_valid_count + 32'd1;
            end
            @(posedge axi_clk);
         end
         $fclose(outfile1);
         $display($time,,"[EFX_INFO]: Done written grayscale output to file.."); //Post RISC-V embedded SW processing
         
         repeat(100) @(posedge axi_clk);
      end
      
      //Branch 4: HW accelerator building block output DMA data counter (write to DDR)
      begin
         @(posedge axi_clk);
         
         while(1) begin
            hw_accel_out_valid_count = (DUT_wrapper.DUT.hw_accel_dma_wvalid) ? hw_accel_out_valid_count + 1'b1 : hw_accel_out_valid_count;
            @(posedge axi_clk);
         end
      end
    
      //Branch 5: Display building block input DMA data counter (read from DDR) & Save to file (display input data)
      //Single frame display DMA transfer for checking. Check MM2S DMA output to display. Do not check frame forming and LVDS format
      begin
         @(posedge tx_slowclk);
      
         outfile2 = $fopen("display_out.txt");
         while (display_valid_count < ((FRAME_WIDTH/2)*FRAME_HEIGHT)) begin
            if (DUT_wrapper.DUT.display_dma_rvalid && (&DUT_wrapper.DUT.display_dma_rkeep) && DUT_wrapper.DUT.display_dma_rready) begin
               $fwrite(outfile2, "%x\n", DUT_wrapper.DUT.display_dma_rdata[31:0]);
               $fwrite(outfile2, "%x\n", DUT_wrapper.DUT.display_dma_rdata[63:32]);
               display_valid_count = display_valid_count + 32'd1;
            end
            @(posedge tx_slowclk);
         end
         $fclose(outfile2);
         $display($time,,"[EFX_INFO]: Done written display side output to file..");
         
         repeat(100) @(posedge tx_slowclk);
         $display($time,,"[EFX_INFO]: Simulation Completed..");
         $stop;
      end

/*
      //Branch 5: For self restart display DMA transfer, first valid frame data to display building block might be random initial data in memory.
      //Save to file HW accelerator building block output DMA data (write to DDR)
      begin         
         @(posedge axi_clk);
      
         outfile2 = $fopen("display_out.txt");
         while (display_valid_count < (FRAME_WIDTH*FRAME_HEIGHT)) begin
            if (DUT_wrapper.DUT.hw_accel_dma_wvalid) begin
               $fwrite(outfile2, "%x\n", DUT_wrapper.DUT.hw_accel_dma_wdata);
               display_valid_count = display_valid_count + 32'd1;
            end
            @(posedge axi_clk);
         end
         $fclose(outfile2);
         $display($time,,"[EFX_INFO]: Done written hw accel side output to file..");
         
         repeat(100) @(posedge axi_clk);
         $display($time,,"[EFX_INFO]: Simulation Completed..");
         $stop;
      end
*/
   
   join
   
end: main

//Registered - Ensure synced to mipi_pclk
always@(posedge mipi_pclk)
begin
   sim_cam_hsync <= cam_hsync;
   sim_cam_vsync <= cam_vsync;
   sim_cam_valid <= cam_valid;
   sim_cam_r_pix <= cam_r_pix;
   sim_cam_g_pix <= cam_g_pix;
   sim_cam_b_pix <= cam_b_pix;
end

edge_vision_soc_wrapper #(
   .FRAME_WIDTH         (FRAME_WIDTH),
   .FRAME_HEIGHT        (FRAME_HEIGHT)
) DUT_wrapper (
   //Clock and Reset Pins
   .master_rstn                        (master_rstn),
   .i_pll_locked                       (i_pll_locked),
   .ddr_clk_locked                     (ddr_clk_locked),
   .mipi_pclk                          (mipi_pclk),
   .tx_slowclk                         (tx_slowclk),
   .axi_clk_locked                     (axi_clk_locked),
   .axi_clk                            (axi_clk),
   .soc_clk                            (soc_clk),
   .dma_clk                            (dma_clk),
   .offchip_rstn                       (1'b1),
   .cam_rstn                           (),
   .hdmi_rstn                          (),
   //MIPI Control
   .mipi_inst1_DPHY_RSTN               (),
   .mipi_inst1_RSTN                    (),
   .mipi_inst1_VC_ENA                  (),
   .mipi_inst1_LANES                   (),
   .mipi_inst1_CLEAR                   (),
   //MIPI Video input
   .mipi_inst1_HSYNC                   (4'd0),
   .mipi_inst1_VSYNC                   (4'd0),
   .mipi_inst1_CNT                     (4'd0),
   .mipi_inst1_VALID                   (1'b0),
   .mipi_inst1_TYPE                    (6'd0),
   .mipi_inst1_DATA                    (64'd0),
   .mipi_inst1_VC                      (2'd0),	
   .mipi_inst1_ERR                     (18'd0),
   //Simulation frame data
   .sim_cam_hsync                      (sim_cam_hsync),
   .sim_cam_vsync                      (sim_cam_vsync),
   .sim_cam_valid                      (sim_cam_valid),
   .sim_cam_r_pix                      (sim_cam_r_pix),
   .sim_cam_g_pix                      (sim_cam_g_pix),
   .sim_cam_b_pix                      (sim_cam_b_pix),
   //LVDS Video output
   .lvds_1a_DATA                       (),
   .lvds_1b_DATA                       (),
   .lvds_1c_DATA                       (),
   .lvds_1d_DATA                       (),
   .lvds_2a_DATA                       (),
   .lvds_2b_DATA                       (),
   .lvds_2c_DATA                       (),
   .lvds_2d_DATA                       (),
   .lvds_clk                           (),
   //RiscV Soc Pinout
   .system_uart_0_io_txd               (),
   .system_uart_0_io_rxd               (1'b0),
   .mipi_i2c_0_io_sda                  (),
   .mipi_i2c_0_io_scl                  (),
   .hdmi_i2c_1_io_sda                  (),
   .hdmi_i2c_1_io_scl                  (),
   .io_ddrA_arw_valid                  (io_ddrA_arw_valid),
   .io_ddrA_arw_ready                  (io_ddrA_arw_ready),
   .io_ddrA_arw_payload_addr           (io_ddrA_arw_payload_addr),
   .io_ddrA_arw_payload_id             (io_ddrA_arw_payload_id),
   .io_ddrA_arw_payload_len            (io_ddrA_arw_payload_len),
   .io_ddrA_arw_payload_size           (io_ddrA_arw_payload_size),
   .io_ddrA_arw_payload_burst          (io_ddrA_arw_payload_burst),
   .io_ddrA_arw_payload_lock           (io_ddrA_arw_payload_lock),
   .io_ddrA_arw_payload_write          (io_ddrA_arw_payload_write),
   .io_ddrA_w_payload_id               (io_ddrA_w_payload_id),
   .io_ddrA_w_valid                    (io_ddrA_w_valid),
   .io_ddrA_w_ready                    (io_ddrA_w_ready),
   .io_ddrA_w_payload_data             (io_ddrA_w_payload_data),
   .io_ddrA_w_payload_strb             (io_ddrA_w_payload_strb),
   .io_ddrA_w_payload_last             (io_ddrA_w_payload_last),
   .io_ddrA_b_valid                    (io_ddrA_b_valid),
   .io_ddrA_b_ready                    (io_ddrA_b_ready),
   .io_ddrA_b_payload_id               (io_ddrA_b_payload_id),
   .io_ddrA_r_valid                    (io_ddrA_r_valid),
   .io_ddrA_r_ready                    (io_ddrA_r_ready),
   .io_ddrA_r_payload_data             (io_ddrA_r_payload_data),
   .io_ddrA_r_payload_id               (io_ddrA_r_payload_id),
   .io_ddrA_r_payload_resp             (io_ddrA_r_payload_resp),
   .io_ddrA_r_payload_last             (io_ddrA_r_payload_last),
   .io_ddrB_arw_valid                  (io_ddrB_arw_valid),
   .io_ddrB_arw_ready                  (io_ddrB_arw_ready),
   .io_ddrB_arw_payload_addr           (io_ddrB_arw_payload_addr),
   .io_ddrB_arw_payload_id             (io_ddrB_arw_payload_id),
   .io_ddrB_arw_payload_len            (io_ddrB_arw_payload_len),
   .io_ddrB_arw_payload_size           (io_ddrB_arw_payload_size),
   .io_ddrB_arw_payload_burst          (io_ddrB_arw_payload_burst),
   .io_ddrB_arw_payload_lock           (io_ddrB_arw_payload_lock),
   .io_ddrB_arw_payload_write          (io_ddrB_arw_payload_write),
   .io_ddrB_w_payload_id               (io_ddrB_w_payload_id),
   .io_ddrB_w_valid                    (io_ddrB_w_valid),
   .io_ddrB_w_ready                    (io_ddrB_w_ready),
   .io_ddrB_w_payload_data             (io_ddrB_w_payload_data),
   .io_ddrB_w_payload_strb             (io_ddrB_w_payload_strb),
   .io_ddrB_w_payload_last             (io_ddrB_w_payload_last),
   .io_ddrB_b_valid                    (io_ddrB_b_valid),
   .io_ddrB_b_ready                    (io_ddrB_b_ready),
   .io_ddrB_b_payload_id               (io_ddrB_b_payload_id),
   .io_ddrB_r_valid                    (io_ddrB_r_valid),
   .io_ddrB_r_ready                    (io_ddrB_r_ready),
   .io_ddrB_r_payload_data             (io_ddrB_r_payload_data),
   .io_ddrB_r_payload_id               (io_ddrB_r_payload_id),
   .io_ddrB_r_payload_resp             (io_ddrB_r_payload_resp),
   .io_ddrB_r_payload_last             (io_ddrB_r_payload_last),
   .system_spi_0_io_data_0             (),
   .system_spi_0_io_data_1             (),
   .system_spi_0_io_sclk_write         (),
   .system_spi_0_io_ss                 (),
   //SOC Debugger
   .jtag_inst1_TCK                     (1'b0),
   .jtag_inst1_TDI                     (1'b0),
   .jtag_inst1_TDO                     (),
   .jtag_inst1_SEL                     (1'b0),
   .jtag_inst1_CAPTURE                 (1'b0),
   .jtag_inst1_SHIFT                   (1'b0),
   .jtag_inst1_UPDATE                  (1'b0),
   .jtag_inst1_RESET                   (1'b0),
   .jtag_inst1_DRCK                    (1'b0),
   .jtag_inst1_RUNTEST                 (1'b0),
   .jtag_inst1_TMS                     (1'b0),
   //DDR RESET
   .ddr_inst1_CFG_RST_N                (),
   .ddr_inst1_CFG_SEQ_RST              (),
   .ddr_inst1_CFG_SEQ_START            ()
);

//128-bit and 256-bit DDR ports are connected to two independent simple DDR models.
//Data written through one port is not synced with another. Simple DDR model to be enhanced to support two DDR ports.

simple_ddr_model #(.DW(128)) u_simple_dramA
(
   .mem_clk    (axi_clk),
   .resetn     (master_rstn),
   .aid_0      (io_ddrA_arw_payload_id),
   .aaddr_0    (io_ddrA_arw_payload_addr),
   .alen_0     (io_ddrA_arw_payload_len),
   .asize_0    (io_ddrA_arw_payload_size),
   .aburst_0   (io_ddrA_arw_payload_burst),
   .alock_0    (io_ddrA_arw_payload_lock),
   .avalid_0   (io_ddrA_arw_valid),
   .aready_0   (io_ddrA_arw_ready),
   .atype_0    (io_ddrA_arw_payload_write),
   .wid_0      (io_ddrA_w_payload_id),
   .wdata_0    (io_ddrA_w_payload_data),
   .wstrb_0    (io_ddrA_w_payload_strb),
   .wlast_0    (io_ddrA_w_payload_last),
   .wvalid_0   (io_ddrA_w_valid),
   .wready_0   (io_ddrA_w_ready),
   .rid_0      (io_ddrA_r_payload_id),
   .rdata_0    (io_ddrA_r_payload_data),
   .rlast_0    (io_ddrA_r_payload_last),
   .rvalid_0   (io_ddrA_r_valid),
   .rready_0   (io_ddrA_r_ready),
   .rresp_0    (io_ddrA_r_payload_resp),
   .bid_0      (io_ddrA_b_payload_id),
   .bvalid_0   (io_ddrA_b_valid),
   .bready_0   (io_ddrA_b_ready)
);

simple_ddr_model #(.DW(256)) u_simple_dramB
(
   .mem_clk    (dma_clk),
   .resetn     (master_rstn),
   .aid_0      (io_ddrB_arw_payload_id),
   .aaddr_0    (io_ddrB_arw_payload_addr),
   .alen_0     (io_ddrB_arw_payload_len),
   .asize_0    (io_ddrB_arw_payload_size),
   .aburst_0   (io_ddrB_arw_payload_burst),
   .alock_0    (io_ddrB_arw_payload_lock),
   .avalid_0   (io_ddrB_arw_valid),
   .aready_0   (io_ddrB_arw_ready),
   .atype_0    (io_ddrB_arw_payload_write),
   .wid_0      (io_ddrB_w_payload_id),
   .wdata_0    (io_ddrB_w_payload_data),
   .wstrb_0    (io_ddrB_w_payload_strb),
   .wlast_0    (io_ddrB_w_payload_last),
   .wvalid_0   (io_ddrB_w_valid),
   .wready_0   (io_ddrB_w_ready),
   .rid_0      (io_ddrB_r_payload_id),
   .rdata_0    (io_ddrB_r_payload_data),
   .rlast_0    (io_ddrB_r_payload_last),
   .rvalid_0   (io_ddrB_r_valid),
   .rready_0   (io_ddrB_r_ready),
   .rresp_0    (io_ddrB_r_payload_resp),
   .bid_0      (io_ddrB_b_payload_id),
   .bvalid_0   (io_ddrB_b_valid),
   .bready_0   (io_ddrB_b_ready)
);

endmodule
