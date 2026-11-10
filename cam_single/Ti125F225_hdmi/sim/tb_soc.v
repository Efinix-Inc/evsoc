////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2026 Efinix Inc. All rights reserved.
// See https://github.com/Efinix-Inc/evsoc/blob/main/LICENSE.txt for details.
////////////////////////////////////////////////////////////////////////////////

`timescale 100ps/10ps

module tb_soc ();

// Ti125F225 testbench (adapted from Ti180J484 tb_soc.v):
//   * one 128-bit memory model: the Ti125 SoC merges CPU and DMA onto one
//     DDR port (Ti180 used two unsynchronised 512-bit models)
//   * clocks as on the Ti125 board: i_soc_clk 200 MHz, i_sys_clk 200 MHz,
//     i_axi0_mem_clk 100 MHz, pixel 100 MHz (display stream: 125 MHz, sim only)

`include "image_64_48.vh"

//Use frame size & setting to reduce simulation time 
localparam FRAME_WIDTH         = 64;
localparam FRAME_HEIGHT        = 48;
localparam  MEMDEPTH=20; //2^20 x 16 bytes = 16 MB: app at 0x1000, frames at 0x100000/0x300000/0x500000

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

//add
localparam tCYC               = (1000000/200);
localparam TS                 = tCYC/100;

//DDR - 128-bit half-duplex AXI4 port (axi_full_to_half_duplex -> memory model)
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

//Reset & Clock related
reg          rst_clk_gen;
reg          i_pll_locked;
reg          ddr_clk_locked;
reg          axi_clk_locked;
reg          master_rstn;
wire         i_mipi_rx_pclk; //100Mhz
wire         i_mipi_tx_pclk;
wire         i_memoryClk; //100MHz: i_axi0_mem_clk
wire         i_systemClk; //200MHz: i_soc_clk
wire         i_sysClk;    //200MHz: i_sys_clk (peripherals, DMA memory side)

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

//SoC UART TX (decoded below)
wire         uart_txd;
//UART monitor state (monitor is at the end of this file; 1736 i_sys_clk cycles per bit)
localparam integer UART_BIT_CYC = 200000000/115200;
reg [7:0]    uart_byte;
reg [1023:0] uart_line;
integer      uart_i;
integer      uart_n;

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

clock_gen #(
   .FREQ_CLK_MHZ(100)
) u_gen_i_memoryClk (
   .rst        (rst_clk_gen),
   .clk_out0   (i_memoryClk),
   .clk_out45  (),
   .clk_out90  (),
   .clk_out135 (),
   .locked     ()
);

clock_gen #(
   .FREQ_CLK_MHZ(200)
) u_gen_i_systemClk (
   .rst        (rst_clk_gen),
   .clk_out0   (i_systemClk),
   .clk_out45  (),
   .clk_out90  (),
   .clk_out135 (),
   .locked     ()
);

clock_gen #(
   .FREQ_CLK_MHZ(200)
) u_gen_i_sysClk (
   .rst        (rst_clk_gen),
   .clk_out0   (i_sysClk),
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
   .FREQ_CLK_MHZ(125)
) u_gen_i_mipi_tx_pclk (
   .rst        (rst_clk_gen),
   .clk_out0   (i_mipi_tx_pclk),
   .clk_out45  (),
   .clk_out90  (),
   .clk_out135 (),
   .locked     ()
);

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

   rst_clk_gen              = 1'b1;
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

   #(100*TS);
   rst_clk_gen              = 1'b0;
   #3000
   //PLL locked
   i_pll_locked   = 1'b1;
   ddr_clk_locked = 1'b1;
   axi_clk_locked = 1'b1;
   
   //Initial reset
   repeat (50) @(posedge i_systemClk);
   //Ti125: hold reset until every clock is running. cam_picam_v2 and other blocks use
   //synchronous resets; if reset is released before their clock starts they stay X
   //(on hardware they start at 0 after configuration, so this only matters in a
   //4-state simulator).
   repeat (10) @(posedge i_mipi_rx_pclk);
   repeat (10) @(posedge i_mipi_tx_pclk);
   repeat (10) @(posedge i_memoryClk);
   repeat (10) @(posedge i_sysClk);
   master_rstn    = 1'b1;   
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
         @(posedge i_mipi_tx_pclk);
      
         outfile2 = $fopen("display_out.txt");
         while (display_valid_count < ((FRAME_WIDTH/2)*FRAME_HEIGHT)) begin
            if (DUT_wrapper.DUT.display_dma_rvalid && (&DUT_wrapper.DUT.display_dma_rkeep) && DUT_wrapper.DUT.display_dma_rready) begin
               $fwrite(outfile2, "%x\n", DUT_wrapper.DUT.display_dma_rdata[31:0]);
               $fwrite(outfile2, "%x\n", DUT_wrapper.DUT.display_dma_rdata[63:32]);
               display_valid_count = display_valid_count + 32'd1;
            end
            @(posedge i_mipi_tx_pclk);
         end
         $fclose(outfile2);
         $display($time,,"[EFX_INFO]: Done written display side output to file..");
         
         repeat(100) @(posedge i_mipi_tx_pclk);
         if (uart_n != 0) $display($time,,"[UART] %0s  (line still being sent)", uart_line);
         $display($time,,"[EFX_INFO]: Simulation Completed..");
         $stop;
      end

/*
      //Branch 5: For self restart display DMA transfer, first valid frame data to display building block might be random initial data in memory.
      //Save to file HW accelerator building block output DMA data (write to DDR)
      begin         
         @(posedge soc_clk);
      
         outfile2 = $fopen("display_out.txt");
         while (display_valid_count < (FRAME_WIDTH*FRAME_HEIGHT)) begin
            if (DUT_wrapper.DUT.hw_accel_dma_wvalid) begin
               $fwrite(outfile2, "%x\n", DUT_wrapper.DUT.hw_accel_dma_wdata);
               display_valid_count = display_valid_count + 32'd1;
            end
            @(posedge soc_clk);
         end
         $fclose(outfile2);
         $display($time,,"[EFX_INFO]: Done written hw accel side output to file..");
         
         repeat(100) @(posedge soc_clk);
         $display($time,,"[EFX_INFO]: Simulation Completed..");
         $stop;
      end
*/
   
   join
   
end: main

//Registered - Ensure synced to i_mipi_rx_pclk.
//Ti125: sampled on the FALLING edge. The frame generator above updates cam_* with
//blocking assignments right after the rising edge, so sampling on that same rising
//edge is a race whose result differs between simulators (pixels repeated/skipped).
always@(negedge i_mipi_rx_pclk)
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

   .i_soc_clk                          (i_systemClk),
   .i_axi0_mem_clk                     (i_memoryClk),
   .i_sys_clk                          (i_sysClk),
   .i_hdmi_sim                         (i_mipi_tx_pclk),
   .i_pixel_clk                        (i_mipi_rx_pclk),

   //Simulation frame data
   .sim_cam_hsync                      (sim_cam_hsync),
   .sim_cam_vsync                      (sim_cam_vsync),
   .sim_cam_valid                      (sim_cam_valid),
   .sim_cam_r_pix                      (sim_cam_r_pix),
   .sim_cam_g_pix                      (sim_cam_g_pix),
   .sim_cam_b_pix                      (sim_cam_b_pix),

   //RiscV Soc Pinout
   .system_uart_0_io_txd               (uart_txd),
   .system_uart_0_io_rxd               (1'b1),  //idle high: a low RX line is a UART break, which discards TX data
   .mipi_i2c_0_io_sda                  (),
   .mipi_i2c_0_io_scl                  (),
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
   .jtag_inst1_TMS                     (1'b0)
);

//Single 128-bit memory model: holds the application (MEM.TXT, loaded at 0x1000)
//and the frame buffers written/read by the DMA, so CPU and DMA see the same data.
simple_ddr_model #(.DW(128), .MEMDEPTH(MEMDEPTH)) u_simple_dramA
(
   .mem_clk    (i_memoryClk),
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

//Status line every 20 us: memory-bus traffic and reset states (shows X), to see
//where a run stops progressing. Expected: first=00001000 (CPU fetching the app),
//all resets 0/1 (no x), then rd/wr counts growing and the DMA lines appearing.
integer      st_rd    = 0;
integer      st_wr    = 0;
reg          st_seen  = 1'b0;
reg [31:0]   st_first = 32'd0;
reg [31:0]   st_last  = 32'd0;
integer      st_instr = 0;      //instructions completed by the CPU
integer      st_bytes = 0;      //UART bytes received
`define TB_CPU DUT_wrapper.DUT.SapphireSoc_inst.u_EfxSapphireSoc.system_cores_0_logic_cpu
always @(posedge i_systemClk) if (`TB_CPU.writeBack_arbitration_isFiring === 1'b1) st_instr = st_instr + 1;
always @(posedge i_memoryClk) begin
   if (io_ddrA_arw_valid === 1'b1 && io_ddrA_arw_ready === 1'b1) begin
      if (!st_seen) begin st_seen = 1'b1; st_first = io_ddrA_arw_payload_addr; end
      st_last = io_ddrA_arw_payload_addr;
      if (io_ddrA_arw_payload_write) st_wr = st_wr + 1; else st_rd = st_rd + 1;
   end
end
initial begin : status_monitor
   forever begin
      #200000;   //20 us
      $display($time,,"[STATUS] mem rd=%0d wr=%0d first=%h last=%h | socRst=%b prpRst=%b arstn=%b | cam=%0d hwIn=%0d hwOut=%0d disp=%0d | txd=%b",
         st_rd, st_wr, st_first, st_last,
         DUT_wrapper.DUT.soc_async_reset, DUT_wrapper.DUT.peripheralReset, DUT_wrapper.DUT.i_arstn,
         cam_valid_count, hw_accel_in_valid_count, hw_accel_out_valid_count, display_valid_count, uart_txd);
      $display($time,,"[STATUS] cpu pc=%h instr=%0d trap: mcause=%b/%h mepc=%h | uart bytes=%0d text=\"%0s\"",
         `TB_CPU.writeBack_PC, st_instr, `TB_CPU.CsrPlugin_mcause_interrupt, `TB_CPU.CsrPlugin_mcause_exceptionCode,
         `TB_CPU.CsrPlugin_mepc, st_bytes, uart_line);
   end
end

//UART monitor: prints the firmware's bsp_printf output (115200 8N1) to the transcript.
//Timed in i_sys_clk cycles (the SoC peripheral/UART clock, 200 MHz): 1736 cycles per bit.
initial begin : uart_monitor
   uart_n    = 0;
   uart_line = 0;
   forever begin
      @(negedge uart_txd);
      repeat (UART_BIT_CYC + UART_BIT_CYC/2) @(posedge i_sysClk);   //middle of bit 0
      for (uart_i=0; uart_i<8; uart_i=uart_i+1) begin
         uart_byte[uart_i] = uart_txd;
         repeat (UART_BIT_CYC) @(posedge i_sysClk);
      end
      st_bytes = st_bytes + 1;
      if (uart_byte == 8'h0A || uart_n == 127) begin
         $display($time,,"[UART] %0s", uart_line);
         uart_n    = 0;
         uart_line = 0;
      end else if (uart_byte != 8'h0D) begin
         uart_line = {uart_line[1015:0], uart_byte};
         uart_n    = uart_n + 1;
      end
   end
end

endmodule
