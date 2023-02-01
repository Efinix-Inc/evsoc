////////////////////////////////////////////////////////////////////////////
//           _____       
//          / _______    Copyright (C) 2013-2022 Efinix Inc. All rights reserved.
//         / /       \   
//        / /  ..    /   design_modules.v
//       / / .'     /    
//    __/ /.'      /     Description:
//   __   \       /      Modules for SapphireSoC example design
//  /_/ /\ \_____/ /     
// ____/  \_______/      
//
// ***********************************************************************
// Revisions:
// 1.0 Initial rev
// 1.1 Added Custom ALU
// 1.2 Fixed AXI4 slave read first issue
// 1.3 Added axi full-duplex to half-duplex converter
// ***********************************************************************
`timescale 1ns/1ps

module apb3_slave #(
	// user parameter starts here
	//
	parameter	ADDR_WIDTH	= 16,
	parameter	DATA_WIDTH	= 32,
	parameter	NUM_REG		= 4
) (
	// user logic starts here
	input				     clk,
	input				     resetn,
	input	[ADDR_WIDTH-1:0] PADDR,
	input				     PSEL,
	input				     PENABLE,
	output				     PREADY,
	input				     PWRITE,
	input 	[DATA_WIDTH-1:0] PWDATA,
	output	[DATA_WIDTH-1:0] PRDATA,
	output				     PSLVERROR

);


///////////////////////////////////////////////////////////////////////////////

localparam [1:0]	IDLE   = 2'b00,
			        SETUP  = 2'b01,
			        ACCESS = 2'b10;

integer			     byteIndex;
reg [DATA_WIDTH-1:0] slaveReg [0:NUM_REG-1];
reg [DATA_WIDTH-1:0] slaveRegOut;
reg [1:0] 		     busState, 
			         busNext;
reg			         slaveReady;
wire	 		     actWrite,
			         actRead;
reg [31:0]           lfsr;
wire                 lfsr_stop;


///////////////////////////////////////////////////////////////////////////////

	always@(posedge clk or negedge resetn)
	begin
		if(!resetn) 
			busState <= IDLE; 
		else
			busState <= busNext; 
	end

	always@(*)
	begin
		busNext = busState;

		case(busState)
			IDLE:
			begin
				if(PSEL && !PENABLE)
					busNext = SETUP;
				else
					busNext = IDLE;
			end
			SETUP:
			begin
				if(PSEL && PENABLE)
					busNext = ACCESS;
				else
					busNext = IDLE;
			end
			ACCESS:
			begin
				if(PREADY)
					busNext = IDLE;
				else
					busNext = ACCESS;
			end
			default:
			begin
				busNext = IDLE;
			end
		endcase
	end


	assign actWrite = PWRITE  & (busState == ACCESS);
	assign actRead  = !PWRITE & (busState == ACCESS);
	assign PSLVERROR = 1'b0; 
	assign PRDATA = slaveRegOut;
	assign PREADY = slaveReady & & (busState !== IDLE);

	always@ (posedge clk)
	begin
		slaveReady <= actWrite | actRead;
	end

	always@ (posedge clk or negedge resetn)
	begin
		if(!resetn)
			for(byteIndex = 0; byteIndex < NUM_REG; byteIndex = byteIndex + 1)
			slaveReg[byteIndex] <= {DATA_WIDTH{1'b0}};
		else 
        begin
			if(actWrite) 
            begin
			    for(byteIndex = 0; byteIndex < NUM_REG; byteIndex = byteIndex + 1)
                if (PADDR[3:0] == (byteIndex*4))
				    slaveReg[byteIndex] <= PWDATA;
            end
			else
            begin
				slaveReg[0] <= lfsr;
                for(byteIndex = 1; byteIndex < NUM_REG; byteIndex = byteIndex + 1)
                slaveReg[byteIndex] <= slaveReg[byteIndex];
            end
		end
	end

	always@ (posedge clk or negedge resetn)
	begin
		if(!resetn)
			slaveRegOut <= {DATA_WIDTH{1'b0}};
		else begin
			if(actRead)
				slaveRegOut <= slaveReg[PADDR[7:2]];
			else
				slaveRegOut <= slaveRegOut;
				
		end

	end

    assign lfsr_stop = slaveReg[1][0];
//custom logics

    always@(posedge clk or negedge resetn)
    begin 
        if (!resetn)
            lfsr <= 'd1;
        else
        begin
            if(!lfsr_stop)
            begin
                lfsr[31] <= lfsr[0];
                lfsr[30] <= lfsr[31];
                lfsr[29] <= lfsr[30];
                lfsr[28] <= lfsr[29];
                lfsr[27] <= lfsr[28];
                lfsr[26] <= lfsr[27];
                lfsr[25] <= lfsr[26];
                lfsr[24] <= lfsr[25];
                lfsr[23] <= lfsr[24];
                lfsr[22] <= lfsr[23];
                lfsr[21] <= lfsr[22];
                lfsr[20] <= lfsr[21];
                lfsr[19] <= lfsr[20];
                lfsr[18] <= lfsr[19];
                lfsr[17] <= lfsr[18];
                lfsr[16] <= lfsr[17];
                lfsr[15] <= lfsr[16];
                lfsr[14] <= lfsr[15];
                lfsr[13] <= lfsr[14];
                lfsr[12] <= lfsr[13];
                lfsr[11] <= lfsr[12];
                lfsr[10] <= lfsr[11];
                lfsr[9 ] <= lfsr[10];
                lfsr[8 ] <= lfsr[9 ];
                lfsr[7 ] <= lfsr[8 ];
                lfsr[6 ] <= lfsr[7 ];
                lfsr[5 ] <= lfsr[6 ];
                lfsr[4 ] <= lfsr[5 ];
                lfsr[3 ] <= lfsr[4 ] ^ lfsr[0];
                lfsr[2 ] <= lfsr[3 ];
                lfsr[1 ] <= lfsr[2 ];
                lfsr[0 ] <= lfsr[1 ] ^ lfsr[0];
            end
            else
            begin
                lfsr <= lfsr;
            end
        end
    end

endmodule

// ***********************************************************************

module axi4_slave #(
	parameter ADDR_WIDTH = 32,
	parameter DATA_WIDTH = 32
) (
	//custom logic starts here
	output			        axi_interrupt,
	//
	input			        axi_aclk,
	input			        axi_resetn,
	//AW
	input [7:0]		        axi_awid,
	input [ADDR_WIDTH-1:0]	axi_awaddr,
	input [7:0]		        axi_awlen,
	input [2:0]		        axi_awsize,
	input [1:0]		        axi_awburst,
	input			        axi_awlock,
	input [3:0]		        axi_awcache,
	input [2:0]		        axi_awprot,
	input [3:0]		        axi_awqos,
	input [3:0]		        axi_awregion,
	input 			        axi_awvalid,
	output			        axi_awready,
	//W
	input [DATA_WIDTH-1:0]	axi_wdata,
	input [(DATA_WIDTH/8)-1:0] 
				            axi_wstrb,
	input 			        axi_wlast,
	input			        axi_wvalid,
	output			        axi_wready,
	//B
	output [7:0]	        axi_bid,
	output [1:0]	        axi_bresp,
	output 			        axi_bvalid,
	input			        axi_bready,
	//AR
	input [7:0]		        axi_arid,
	input [ADDR_WIDTH-1:0]	axi_araddr,
	input [7:0]		        axi_arlen,
	input [2:0]		        axi_arsize,
	input [1:0]		        axi_arburst,
	input 			        axi_arlock,
	input [3:0]		        axi_arcache,
	input [2:0]		        axi_arprot,
	input [3:0]		        axi_arqos,
	input [3:0]		        axi_arregion,
	input 			        axi_arvalid,
	output			        axi_arready,
	//R
	output [7:0]		    axi_rid,
	output [DATA_WIDTH-1:0]	axi_rdata,
	output [1:0]		    axi_rresp,
    output 			        axi_rlast,
	output			        axi_rvalid,
	input			        axi_rready	
);

///////////////////////////////////////////////////////////////////////////////
localparam		RAM_SIZE = 2048;
localparam		RAMW	 = $clog2(RAM_SIZE);

localparam [2:0]	IDLE  	= 3'h0,
			        PRE_WR	= 3'h1,
			        WR 	    = 3'h2,
			        WR_RESP = 3'h3,
			        PRE_RD	= 3'h4,
			        RD	    = 3'h5;
		
reg [2:0] 	    busState,
			    busNext;
wire 		    busReady,
                busPreWrite,
			    busWrite,
			    busWriteResp,
                busPreRead,
			    busRead;
wire            awWrap,
                arWrap;
reg  [7:0]		awidReg;
reg  [ADDR_WIDTH-1:0]	awaddrReg;
reg  [7:0]		awlenReg;
reg  [2:0]		awsizeReg;
reg  [1:0]		awburstReg,
  			    awlockReg;
reg  [3:0]		awcacheReg;
reg  [2:0]		awprotReg;
reg  [3:0]		awqosReg;
reg  [3:0]		awregionReg;

reg  [7:0]		aridReg;
reg  [ADDR_WIDTH-1:0]	araddrReg;
reg  [7:0]		arlenReg;
reg  [2:0]		arsizeReg;
reg  [1:0]		arburstReg,
  			    arlockReg;
reg  [3:0]		arcacheReg;
reg  [2:0]		arprotReg;
reg  [3:0]		arqosReg;
reg  [3:0]		arregionReg;

reg  [31:0]		awaddr_base;
wire [31:0]		awWrapSize;
reg  [7:0]		decodeAwsize;

wire [31:0]		araddr_wrap;
reg  [7:0]		decodeArsize;

reg  [31:0]		araddr_base;
wire [31:0]		arWrapSize;
reg  [7:0]		ridReg;
reg  [1:0]		rrespReg;
reg  [1:0]		rlastReg;

wire			pWr_done;
wire			pRd_done;
wire			awaddr_ext;
wire			araddr_ext;
wire [(DATA_WIDTH/8)-1:0] 
			    rlast;
wire [(DATA_WIDTH/8)-1:0] 
			    rvalid;
//custom logic
wire [9:0]  	wdata  [0:3];
wire	    	wEnable[0:3];
wire [9:0]  	rdata  [0:3];
wire [31:0] 	data_o;
wire  	    	rEnable;
reg 			r_axi_interrupt;

///////////////////////////////////////////////////////////////////////////////


	always@ (posedge axi_aclk or negedge axi_resetn)
	begin
		if(!axi_resetn)
			busState <= IDLE;
		else
			busState <= busNext;

	end

	always@ (*)
	begin
		busNext = busState;

		case(busState)
		IDLE:
		begin
			if(axi_awvalid)
				busNext = PRE_WR;
			else if(axi_arvalid)
				busNext = PRE_RD;
			else
				busNext = IDLE;
		end
		PRE_WR:
		begin
			if(pWr_done)
				busNext = WR;
			else
				busNext = PRE_WR;
		end
		WR:
		begin
			if(axi_wlast)
				busNext = WR_RESP;
			else
				busNext = WR;
		end
		WR_RESP:
		begin
			if(axi_bready)
				busNext = IDLE;
			else
				busNext = WR_RESP;
		end
		PRE_RD:
		begin
			if(pRd_done)
				busNext = RD;
			else
				busNext = PRE_RD;
		end
		RD:
		begin
			if(axi_rlast && axi_rready)
				busNext = IDLE;
			else
				busNext = RD;
		end
		default:
			busNext = IDLE;
		endcase
	end

	assign busReady     = (busState == IDLE);
	assign busPreWrite  = (busState == PRE_WR);
	assign busWrite     = (busState == WR);
	assign busWriteResp = (busState == WR_RESP);
	assign busPreRead   = (busState == PRE_RD);
	assign busRead      = (busState == RD);

    //PRE_WRITE
    assign pWr_done = (awburstReg == 2'b10)? awaddr_ext : 1'b1;
    //AW Control

	assign axi_awready 	= busReady;

    //Wrap Control
        always@ (posedge axi_aclk or negedge axi_resetn)
        begin
		if (!axi_resetn)
			awaddr_base <= 'h0;
		else begin
			if(busReady)
				awaddr_base <= 'h0;
			else if(busPreWrite && !awaddr_ext)
				awaddr_base <= awaddr_base + awWrapSize;
			else
				awaddr_base <= awaddr_base;
		end
	end

	assign awaddr_ext	= busPreWrite ? (awaddr_base[RAMW:0] > awaddrReg[RAMW:0]) : 1'b0;
	assign awWrap 		= busWrite && (axi_awburst == 2'b10) ? (awaddrReg[RAMW:0] == awaddr_base - 4)     : 1'b0;
	assign awWrapSize 	= (DATA_WIDTH/8) * awlenReg;

    //AW Info 
    	always@ (posedge axi_aclk)
	begin
		if(axi_awvalid) begin
			awidReg     <= axi_awid;
			awlenReg    <= axi_awlen + 1'b1;
			awsizeReg   <= axi_awsize;
			awburstReg  <= axi_awburst;
			awlockReg   <= axi_awlock;
			awcacheReg  <= axi_awcache;
			awprotReg   <= axi_awprot;
			awqosReg    <= axi_awqos;
			awregionReg <= axi_awregion;
		end
		else begin
			awidReg     <= awidReg;
			awlenReg    <= awlenReg;
			awsizeReg   <= awsizeReg;
			awburstReg  <= awburstReg;
			awlockReg   <= awlockReg;
			awcacheReg  <= awcacheReg;
			awprotReg   <= awprotReg;
			awqosReg    <= awqosReg;
			awregionReg <= awregionReg;
		end
	end

	always@ (awsizeReg)
	begin
		case(awsizeReg)
		3'h0:decodeAwsize    <= 8'd1;
		3'h1:decodeAwsize    <= 8'd2;
		3'h2:decodeAwsize    <= 8'd4;
		3'h3:decodeAwsize    <= 8'd8;
		3'h4:decodeAwsize    <= 8'd16;
		3'h5:decodeAwsize    <= 8'd32;
		3'h6:decodeAwsize    <= 8'd64;
		3'h7:decodeAwsize    <= 8'd128;
		default:decodeAwsize <= 8'd1;
		endcase
	end

	always@ (posedge axi_aclk)
	begin
		if(axi_awvalid)
			awaddrReg   <= axi_awaddr;
		else if (busWrite) begin
			case(awburstReg)
			2'b00://fixed burst
			awaddrReg <= awaddrReg;
			2'b01://incremental burst
			awaddrReg <= awaddrReg + decodeAwsize;
			2'b10://wrap burst
			begin
				if(awWrap)
					awaddrReg <= awaddrReg - awWrapSize;
				else
					awaddrReg <= awaddrReg + decodeAwsize;
			end
			default:
			awaddrReg <= awaddrReg;
			endcase
		end
	end
    //W operation
    	assign axi_wready = busWrite;

    //B Response
	assign axi_bid    = awidReg;
	assign axi_bresp  = 2'b00;
	assign axi_bvalid = busWriteResp;

   //PRE_READ
   assign pRd_done = (arburstReg == 2'b10)? araddr_ext : 1'b1;

   //AR Control
	assign axi_arready = busReady;

   //Wrap Control
        always@ (posedge axi_aclk or negedge axi_resetn)
        begin
		if (!axi_resetn)
			araddr_base <= 'h0;
		else begin
			if(busReady)
				araddr_base <= 'h0;
			else if(busPreRead && !araddr_ext)
				araddr_base <= araddr_base + arWrapSize;
			else
				araddr_base <= araddr_base;
		end
	end

	assign araddr_ext	= busPreRead ? (araddr_base[RAMW:0] > araddrReg[RAMW:0]) : 1'b0;
	assign arWrap 		= (busRead && axi_arburst == 2'b10)   ? (araddrReg[RAMW:0] == araddr_base - 4)     : 1'b0;
	assign arWrapSize 	= (DATA_WIDTH/8) * arlenReg;

    //AR Info 
    	always@ (posedge axi_aclk)
	begin
		if(axi_arvalid) begin
			aridReg     <= axi_arid;
			arlenReg    <= axi_arlen + 1'b1;
			arsizeReg   <= axi_arsize;
			arburstReg  <= axi_arburst;
			arlockReg   <= axi_arlock;
			arcacheReg  <= axi_arcache;
			arprotReg   <= axi_arprot;
			arqosReg    <= axi_arqos;
			arregionReg <= axi_arregion;
		end
		else begin
			aridReg     <= aridReg;
			arlenReg    <= arlenReg;
			arsizeReg   <= arsizeReg;
			arburstReg  <= arburstReg;
			arlockReg   <= arlockReg;
			arcacheReg  <= arcacheReg;
			arprotReg   <= arprotReg;
			arqosReg    <= arqosReg;
			arregionReg <= arregionReg;
		end
	end

	always@ (arsizeReg)
	begin
		case(arsizeReg)
		3'h0:decodeArsize    <= 8'd1;
		3'h1:decodeArsize    <= 8'd2;
		3'h2:decodeArsize    <= 8'd4;
		3'h3:decodeArsize    <= 8'd8;
		3'h4:decodeArsize    <= 8'd16;
		3'h5:decodeArsize    <= 8'd32;
		3'h6:decodeArsize    <= 8'd64;
		3'h7:decodeArsize    <= 8'd128;
		default:decodeArsize <= 8'd1;
		endcase
	end

	always@ (posedge axi_aclk)
	begin
		if(axi_arvalid)
			araddrReg   <= axi_araddr;
		else if (rEnable && axi_rready) begin
			case(arburstReg)
			2'b00://fixed burst
			araddrReg <= araddrReg;
			2'b01://incremental burst
			araddrReg <= araddrReg + decodeArsize;
			2'b10://wrap burst
			begin
				if(arWrap)
					araddrReg <= araddrReg - arWrapSize;
				else
					araddrReg <= araddrReg + decodeArsize;
			end
			default:
			araddrReg <= araddrReg;
			endcase
		end
	end

    // R Operation
	assign axi_rdata  = data_o;
 
    // R Response
	assign axi_rvalid = busRead? |rvalid : 1'b0 ;
	assign axi_rlast  = busRead? |rlast : 1'b0 ;
    	
	assign axi_rresp = 2'b00;
	assign axi_rid	 = aridReg;

    //custom logic starts here
    assign axi_interrupt = r_axi_interrupt;	
	assign rEnable = (axi_arburst == 2'b10)? busRead : busPreRead;
	
	always@ (posedge axi_aclk)
	begin
		if (!axi_resetn)
		begin
			r_axi_interrupt <= 1'b0;
		end
		else
		begin
			if((axi_wvalid) && (axi_wdata == 16'hABCD))	
                r_axi_interrupt <= 1'b1;
			else						
                r_axi_interrupt <= 1'b0;	
		end		
	end
	
 	genvar i;
	generate
		for(i=0;i < (DATA_WIDTH/8); i = i + 1) begin
	
		assign rvalid[i] = (arlenReg != 'h1)? rdata[i][8] : 1'b1;
		assign rlast[i] = (arlenReg != 'h1)? rdata[i][9] : 1'b1;
		assign wdata[i] = {axi_wlast, axi_wvalid, axi_wdata[(i*8+7) -: 8]} ;
		assign data_o[(i*8+7) -: 8] = rdata[i];
		assign wEnable[i] = axi_wready & axi_wvalid & axi_wstrb[i];

	 	ext_mem #(
			.DATA_WIDTH (10),
			.ADDR_WIDTH (RAMW-2),
			.OUTPUT_REG ("TRUE")
						 
	 	) user_ram (
			.wdata 	(wdata[i]),
			.waddr	(awaddrReg[RAMW-1:2]), 
			.raddr	(araddrReg[RAMW-1:2]),
			.we	    (wEnable[i]), 
			.wclk	(axi_aclk), 
			.re	    (rEnable), 
			.rclk	(axi_aclk),
			.rdata	(rdata[i])
	 	);
		end
	endgenerate

endmodule

// ***********************************************************************

module memory_checker #(
    parameter WIDTH       = 32,
    parameter ALEN        = 23,
    parameter START_ADDR  = 32'h00000000,
    parameter STOP_ADDR   = 32'h00100000,
    parameter ADDR_OFFSET = (ALEN + 1)*(WIDTH/8)
) (
input                       axi_clk,
input                       rstn,
input                       start,
output      [7:0]           aid,
output reg  [31:0]          aaddr,
output reg  [7:0]           alen,
output reg  [2:0]           asize,
output reg  [1:0]           aburst,
output reg  [1:0]           alock,
output reg                  avalid,
input                       aready,
output reg                  atype,

output      [7:0]           wid,
output reg  [WIDTH-1:0]     wdata,
output      [WIDTH/8-1:0]   wstrb,
output reg                  wlast,
output reg                  wvalid,
input                       wready,

input       [3:0]           rid,
input       [WIDTH-1:0]     rdata,
input                       rlast,
input                       rvalid,
output reg                  rready,
input       [1:0]           rresp,

input       [7:0]           bid,
input                       bvalid,
output reg                  bready,
output                      pass

);

///////////////////////////////////////////////////////////////////////////////
localparam  ASIZE = (WIDTH == 512)? 6 :
                    (WIDTH == 256)? 5 :
                    (WIDTH == 128)? 4 :
                    (WIDTH == 64)?  3 : 2;

//Main states
localparam  COMPARE_WIDTH = WIDTH;
localparam  IDLE = 4'b0000, 
	        WRITE_ADDR = 4'b0001,
	        PRE_WRITE = 4'b0010,
	        WRITE = 4'b0011,
	        POST_WRITE = 4'b0100,
	        READ_ADDR = 4'b0101,
	        PRE_READ = 4'b0110,
	        READ_COMPARE = 4'b0111,
	        POST_READ = 4'b1000,
	        DONE = 4'b1001;

//reg [3:0] states, nstates;
reg             fail;
reg             done;
reg [3:0]       states;
reg [3:0]       nstates;
reg             bvalid_done;
reg [1:0]       start_sync;
reg [8:0]       write_cnt, read_cnt;
reg [WIDTH-1:0] rdata_store;
reg             wburst_done, 
                rburst_done, 
                write_done, 
                read_done;

///////////////////////////////////////////////////////////////////////////////
    assign aid   = 8'h00;
    assign wstrb = {WIDTH/8{1'b1}};
    assign wid   = 8'h00;
    assign pass  = done & ~fail;
    
    always @(posedge axi_clk or negedge rstn) 
    begin
    	if (!rstn) begin
    		start_sync <= 2'b00;
    	end else begin
    		start_sync[0] <= start;
    		start_sync[1] <= start_sync[0];
    	end
    end
    
    always @(posedge axi_clk or negedge rstn) 
    begin
     	if (!rstn) begin
    	    states <= IDLE;
    	end else begin
    	    states <= nstates;
    	end
    end
    
    always @(states or start_sync[1] or write_cnt or rburst_done or write_done or read_done or bvalid_done or aready) 
    begin
    	case(states) 
    	IDLE 	   : 
        if (start_sync[1]) 			
            nstates = WRITE_ADDR;
    	else					
            nstates = IDLE;
    	WRITE_ADDR : 
        if (aready)				
            nstates = PRE_WRITE;
    	else					
            nstates = WRITE_ADDR;
    	PRE_WRITE  : 	
        nstates = WRITE;
    	WRITE	   : 
        if (write_cnt == 9'd0)			
            nstates = POST_WRITE;
    	else		 			
            nstates = WRITE;
    	POST_WRITE : 
        if (write_done & bvalid_done) 		
            nstates = READ_ADDR;
    	else if (bvalid_done)			
            nstates = WRITE_ADDR;
    	else					
            nstates = POST_WRITE;
    	READ_ADDR  : 
        if (aready) 				
            nstates = PRE_READ;
    	else					
            nstates = READ_ADDR;
    	PRE_READ   :						
        nstates = READ_COMPARE;
    	READ_COMPARE  : 
        if (rburst_done) 			
            nstates = POST_READ;
    	else					
            nstates = READ_COMPARE;
    	POST_READ  :	
        if (read_done) 				
            nstates = DONE;
    	else					
            nstates = READ_ADDR;
    	DONE	   : 						
        nstates = DONE;
    	default	   :
        nstates = IDLE;
    	endcase
    end
    
    always @(posedge axi_clk or negedge rstn) 
    begin
    	if (!rstn) begin
    		aaddr       <= START_ADDR;
    		avalid      <= 1'b0;
    		atype       <= 1'b0;
    		aburst      <= 2'b00;
    		asize       <= 3'b000;
    		alen        <= 8'd0;
    		alock       <= 2'b00;
    		wvalid      <= 1'b0;
    		write_cnt   <= ALEN + 1;
    		write_done  <= 1'b0;
    		wdata       <= {WIDTH{1'b0}};
    		wburst_done <= 1'b0;
    		wlast       <= 1'b0;
    		bready      <= 1'b0;
    		fail        <= 1'b0;
    		done        <= 1'b0;
    		rready      <= 1'b0;
    		bvalid_done <=1'b0;
    	end 
        else 
        begin
    		if (states == IDLE) 
            begin
    	        aaddr       <= START_ADDR;
    	        avalid      <= 1'b0;
                atype       <= 1'b0;
                aburst      <= 2'b00;
                asize       <= 3'b000;
                alen        <= 8'd0;
                alock       <= 2'b00;
                wvalid      <= 1'b0;
                write_cnt   <= ALEN + 1;
                wdata       <= {WIDTH{1'b0}};
                wburst_done <= 1'b0;
                wlast       <= 1'b0;
                bready      <= 1'b0;
    		    rready      <= 1'b0;
    		    bvalid_done <= 1'b0;
    		    fail        <= 1'b0;
    		    done        <= 1'b0;
    		end
    		if (states == WRITE_ADDR) 
            begin
    			avalid      <= 1'b1;
    			atype       <= 1'b1;
    			asize       <= ASIZE;
    			alen        <= ALEN;
    			aburst      <= 2'b01;
    			alock       <= 2'b00;
    			wvalid      <= 1'b0;
    			write_cnt   <= ALEN + 1;
    			wburst_done <= 1'b0;
    			bvalid_done <= 1'b0;
    			bready      <= 1'b0;
    			rready      <= 1'b0;
    			done        <= 1'b0;
    			fail        <= 1'b0;
    		end
    		if (states == PRE_WRITE) 
            begin
    			avalid      <= 1'b0;
    			atype       <= 1'b0;
    			wvalid      <= 1'b1;
    			wdata       <= {{WIDTH/32{~aaddr[7:0]}},{WIDTH/32{~write_cnt[7:0]}},{WIDTH/32{aaddr[7:0]}},{WIDTH/32{write_cnt[7:0]}}};
    			bready      <= 1'b1;
    			write_cnt   <= write_cnt - 1;
                if(alen == 'd0)
                begin
                    wlast <= 1'b1;
                end
    		end
    		if (states == WRITE) 
            begin
    			if (wready == 1'b1) 
                begin
    			    wdata   <= {{WIDTH/32{~aaddr[7:0]}},{WIDTH/32{~write_cnt[7:0]}},{WIDTH/32{aaddr[7:0]}},{WIDTH/32{write_cnt[7:0]}}};
    				if (write_cnt == 9'd0) 
                    begin
    				    wburst_done <= 1'b1;
    				    wlast       <= 1'b0;
    				    wvalid      <= 1'b0;
    					if (aaddr >= STOP_ADDR) 
                        begin
    					    write_done <= 1'b1;
    					end else 
                        begin
    					    write_done <= 1'b0;
    					end
    				end if (write_cnt == 9'd1) 
                    begin
    					wlast     <= 1'b1;
    					write_cnt <= write_cnt - 1;
    				end 
                    else 
                    begin
    				    write_cnt <= write_cnt - 1;
    				end
    			end
    		end
    		if (states == POST_WRITE) 
            begin
    			if (write_done) 
                begin
    				    aaddr <= START_ADDR;
    			end 
                else 
                begin
    				if (bvalid) begin
    				    aaddr <= aaddr + ADDR_OFFSET;
    				end
    			end
    			if (wready == 1'b1) 
                begin
    				wlast   <= 1'b0;	
    				wvalid  <= 1'b0;	
    			end
    			if (bvalid) 
                begin
    				bvalid_done <= 1'b1;
    				bready      <= 1'b0;
    			end
    		end
    		if (states == READ_ADDR) 
            begin
    			avalid   <= 1'b1;
    			read_cnt <= ALEN + 1;
    				
    		end
    		if (states == PRE_READ) 
            begin
    			avalid      <= 1'b0;
    			rburst_done <= 1'b0;
                rdata_store <= {{WIDTH/32{~aaddr[7:0]}},{WIDTH/32{~read_cnt[7:0]}},{WIDTH/32{aaddr[7:0]}},{WIDTH/32{read_cnt[7:0]}}};
    			read_cnt    <= read_cnt - 1'b1;
    		end
    		if (states == READ_COMPARE) 
            begin
    			rready <= 1'b1;
    			if (read_cnt != 9'd0) 
                begin
    			    if (rvalid == 1'b1) 
                    begin
                        rdata_store <= {{WIDTH/32{~aaddr[7:0]}},{WIDTH/32{~read_cnt[7:0]}},{WIDTH/32{aaddr[7:0]}},{WIDTH/32{read_cnt[7:0]}}};
    			        read_cnt <= read_cnt - 1'b1;
    				    if (rdata[COMPARE_WIDTH-1:0] != rdata_store[COMPARE_WIDTH-1:0]) 
    					    fail <= 1'b1;
    				    else 
                            fail <= 1'b0;
    				end
    	
    			end
    		end
    		if (read_cnt == 9'd0) 
            begin
    	        if (rvalid == 1'b1) 
                begin
                    if (rdata[COMPARE_WIDTH-1:0] != rdata_store[COMPARE_WIDTH-1:0]) 
                    begin
                        fail <= 1'b1;
                    end 
                    else 
                    begin
                        fail <= 1'b0;
                    end
    				if (aaddr >= STOP_ADDR) 
                    begin
    					read_done <= 1'b1;
    				end 
                    else 
                    begin
    					read_done <= 1'b0;
    				end
    				rburst_done <= 1'b1;
    			end
    		end
    		if (states == POST_READ) 
            begin
    			aaddr <= aaddr + ADDR_OFFSET;
    			rready <= 1'b1;
    		end
    		if (states == DONE)
            begin
    			done <= 1'b1;
    		end
    	end
    end
endmodule

// ***********************************************************************
module timer_start #(
	parameter MHZ	 = 50,
	parameter SECOND = 3,
    parameter PULSE  = 0
) (
	input		clk,
	input		rst_n,
	output 		start
); 

reg [35:0]	delay_cnt;
wire		second_tick;
reg [4:0]	second_cnt;
reg [3:0]   pulse_reg;
wire        start_reg;

///////////////////////////////////////////////////////////////////////////////

`ifndef EFX_SIM
localparam tick_cnt = (MHZ * 1000000) >> 1;
`else
localparam tick_cnt = MHZ * 200;
`endif

	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
		delay_cnt <= 'd0;
	else
	begin
		if(delay_cnt == tick_cnt || start_reg == 1'b1)
			delay_cnt <= 'd0;
		else
			delay_cnt <= delay_cnt + 1'b1;
	end
	end

	assign second_tick = ((delay_cnt) == (tick_cnt - 1)); 

	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
		second_cnt <= 'd0;
	else
	begin
		if(second_tick)
			second_cnt <= second_cnt + 1'b1;
		else
			second_cnt <= second_cnt;
	end
	end

	assign start_reg = (second_cnt == SECOND);
    
    always@(posedge clk)
    begin
        pulse_reg <= {pulse_reg[2:0],start_reg};
    end

generate
if(PULSE == 1)
    assign start = ~pulse_reg[3] & start_reg;
else
    assign start = start_reg;
endgenerate

endmodule

// ***********************************************************************
module ext_mem #(
    parameter DATA_WIDTH    = 8,
    parameter ADDR_WIDTH    = 9,
    parameter OUTPUT_REG    = "TRUE",
    parameter RAM_INIT_FILE = ""
) (
    input [DATA_WIDTH-1:0]  wdata,
    input [ADDR_WIDTH-1:0]  waddr, 
    input [ADDR_WIDTH-1:0]  raddr,
    input                   we, 
    input                   wclk, 
    input                   re, 
    input                   rclk,
    output [DATA_WIDTH-1:0] rdata
);

/////////////////////////////////////////////////////////////////////////////

    localparam MEMORY_DEPTH = 2**ADDR_WIDTH;
    localparam MAX_DATA = (1<<ADDR_WIDTH)-1;

    reg [DATA_WIDTH-1:0]ram [MEMORY_DEPTH-1:0];
    wire [DATA_WIDTH-1:0] r_rdata_1P;
    reg [DATA_WIDTH-1:0] r_rdata_2P = 'h0;

/////////////////////////////////////////////////////////////////////////////
    initial
    begin
        if (RAM_INIT_FILE != "")
        begin
            $readmemh(RAM_INIT_FILE, ram);
        end
    end

    always @ (posedge wclk)
        if (we)
        ram[waddr] <= wdata;

    assign r_rdata_1P = re? ram[raddr] : 'hZ;

    always @ (posedge rclk)
    begin
        if (re)
        r_rdata_2P <= r_rdata_1P;
    end

    generate
        if (OUTPUT_REG == "TRUE")
            assign  rdata = r_rdata_2P;
        else
            assign  rdata = r_rdata_1P;
    endgenerate

endmodule

// ***********************************************************************
module custom_instruction_tea (
    input             clk,
    input             reset,
    input             cmd_valid,
    output            cmd_ready,
    input  [9:0]      cmd_function_id,
    input  [31:0]     cmd_inputs_0,
    input  [31:0]     cmd_inputs_1,
    output reg        rsp_valid,
    input             rsp_ready,
    output [31:0]     rsp_outputs_0
);

/////////////////////////////////////////////////////////////////////////////

    reg  [31:0]     raw_data0;
    reg  [31:0]     raw_data1;          
    reg             raw_valid;
    reg             raw_valid_upper;
    reg  [1:0]      valid_upper_r1;
    wire [63:0]     enc_out;
    wire            enc_valid;
    wire            enc_valid_upper;
    reg             enc_busy;
/////////////////////////////////////////////////////////////////////////////

    always@(posedge clk or posedge reset) 
    begin
        if(reset) 
        begin
            raw_data0       <= 32'd0;
            raw_data1       <= 32'd0;
            raw_valid       <= 1'b0;    
            raw_valid_upper <= raw_valid_upper;
        end 
        else 
        begin
            if (cmd_ready & cmd_valid) 
            begin
                case (cmd_function_id[1:0])
                2'd0:
                begin
                    raw_data0       <= cmd_inputs_0;
                    raw_data1       <= cmd_inputs_1;
                    raw_valid       <= 1'b1;
                    raw_valid_upper <= 1'b0;
                    
                end
                2'd1:
                begin
                    raw_data0       <= raw_data0;
                    raw_data1       <= raw_data1;
                    raw_valid       <= 1'b0;
                    raw_valid_upper <= 1'b1;
                end
                default:
                begin
                    raw_data0       <= raw_data0;
                    raw_data1       <= raw_data1;
                    raw_valid       <= 1'b0;
                    raw_valid_upper <= raw_valid_upper;
                end
                endcase 
            end
            else
            begin   
                raw_data0       <= raw_data0;
                raw_data1       <= raw_data1;
                raw_valid       <= 1'b0;
                raw_valid_upper <= raw_valid_upper;
            end
        end
    end

    always@(posedge clk or posedge reset)
    begin
        if(reset)
            enc_busy <= 1'b0;
        else
        begin
            if(rsp_valid && rsp_ready)
                enc_busy <= 1'b0;
            else if(cmd_valid)
                begin
                    case (cmd_function_id[1:0])
                    2'd0,2'd1:
                    enc_busy    <= 1'b1;
                    default:
                    enc_busy    <= 1'b0;
                    endcase
                end
            else
                enc_busy <= enc_busy;
        end
    end

    always@(posedge clk)
    begin
        valid_upper_r1 <= {valid_upper_r1[0], raw_valid_upper};
    end

    assign enc_valid_upper = valid_upper_r1[0] & ~valid_upper_r1[1];

    always@(posedge clk or posedge reset)
    begin
        if(reset)
            rsp_valid <= 1'b0;
        else
        begin
            if(enc_valid | enc_valid_upper)
                rsp_valid <= 1'b1;
            else if(rsp_ready)            
                rsp_valid <= 1'b0;
            else
                rsp_valid <= rsp_valid;
        end
    end
                

    assign rsp_outputs_0 = raw_valid_upper ? enc_out[63:32]:enc_out[31:0];
    assign cmd_ready     = !enc_busy;

    tiny_encrytion #(
    .ITER(1024)
    ) tea (
        .clk        (clk),
        .reset      (reset),
        .raw0       (raw_data0),
        .raw1       (raw_data1),
        .rawEn      (raw_valid),
        .busy       (),
        .enc_out    (enc_out),
        .enc_valid  (enc_valid)
    );

endmodule

/////////////////////////////////////////////////////////////////////////////
module tiny_encrytion #(
    parameter ITER = 1024
) (
	clk,
	reset,
	raw0,
	raw1,
	rawEn,
	busy,
	enc_out,
	enc_valid
	
);

input               clk;
input               reset;
input [31:0]        raw0;
input [31:0]        raw1;
input               rawEn;
output              busy;
output reg [63:0]   enc_out;
output              enc_valid; 


/////////////////////////////////////////////////////////////////////////////
localparam deltaConstant = 32'h9E3779B9;
localparam enckey0       = 32'h01234567;
localparam enckey1       = 32'h89abcdef;
localparam enckey2       = 32'h13579248;
localparam enckey3       = 32'h248a0135;
localparam CW            = $clog2(ITER);

reg [31:0]  raw_r0,
            raw_r1;

reg [CW-1:0] iteration_cnt;
reg [2:0]    iteration_start;
wire         iteration_stop;
reg          iteration_act;
reg [1:0]    data_tick;
reg          data_tick_r1;
reg [31:0]   delta_r1;

wire [31:0]  cal0_top;
wire [31:0]  cal0_mid;
wire [31:0]  cal0_bot;
wire [31:0]  cal0;

wire [31:0]  cal1_top;
wire [31:0]  cal1_mid;
wire [31:0]  cal1_bot;
wire [31:0]  cal1;

/////////////////////////////////////////////////////////////////////////////
always@(posedge clk)
begin
    if(data_tick[0])
        enc_out <= {raw_r1, raw_r0};
    else
        enc_out <= enc_out;
end

assign busy = iteration_act;
assign enc_valid = data_tick[1];

always@(posedge clk)
begin
        iteration_start <= {iteration_start[1:0], rawEn};
        data_tick <= {data_tick[0], iteration_stop};
end

assign iteration_stop = (iteration_cnt == {CW{1'b1}});

always@(posedge clk or posedge reset)
begin
    if(reset)
        iteration_act <= 'b0;
    else
    begin
        if(iteration_start[2])
            iteration_act <= 1'b1;
        else if(iteration_stop)
            iteration_act <= 1'b0;
        else
            iteration_act <= iteration_act;
    end
end

always@(posedge clk or posedge reset)
begin
    if(reset)
        iteration_cnt <= 'd0;
    else
    begin
        if(iteration_act)
            iteration_cnt <= iteration_cnt + 1'b1;
        else
            iteration_cnt <= 'd0;
    end
end

always@(posedge clk)
begin
    if(iteration_start[1] && !iteration_act)
    begin
        raw_r0 <= raw0;
        raw_r1 <= raw1;
        delta_r1 <= deltaConstant;
    end
    else
    if(iteration_act)
    begin
        raw_r0      <= cal1 + raw_r0;
        raw_r1      <= cal0 + raw_r1;
        delta_r1    <= delta_r1 + deltaConstant;
    end 
    else
    begin
        raw_r0      <= raw_r0;
        raw_r1      <= raw_r1;
        delta_r1    <= delta_r1;

    end
end


assign cal0_top     = ((raw_r0 + cal1) << 4) + enckey2;
assign cal0_mid     = (raw_r0 + cal1) + delta_r1;
assign cal0_bot     = ((raw_r0 + cal1) >> 5) + enckey3;
assign cal0         = cal0_top ^ cal0_mid ^ cal0_bot;
assign cal1_top     = (raw_r1 << 4) + enckey0;
assign cal1_mid     = raw_r1 + delta_r1;
assign cal1_bot     = (raw_r1 >> 5) + enckey1;
assign cal1         = cal1_top ^ cal1_mid ^ cal1_bot;

endmodule
/////////////////////////////////////////////////////////////////////////////
module fd_to_hd_wrapper (
input                       clk,
input                       reset,
output  wire                io_ddrA_arw_valid,
input                       io_ddrA_arw_ready,
output  wire    [31:0]      io_ddrA_arw_payload_addr,
output  wire    [5:0]       io_ddrA_arw_payload_id,
output  wire    [7:0]       io_ddrA_arw_payload_len,
output  wire    [2:0]       io_ddrA_arw_payload_size,
output  wire    [1:0]       io_ddrA_arw_payload_burst,
output  wire    [1:0]       io_ddrA_arw_payload_lock,
output  wire                io_ddrA_arw_payload_write,

input                       io_ddrA_aw_valid,
output  wire                io_ddrA_aw_ready,
input           [31:0]      io_ddrA_aw_payload_addr,
input           [5:0]       io_ddrA_aw_payload_id,
input           [7:0]       io_ddrA_aw_payload_len,
input           [2:0]       io_ddrA_aw_payload_size,
input           [1:0]       io_ddrA_aw_payload_burst,
input           [1:0]       io_ddrA_aw_payload_lock,

input                       io_ddrA_ar_valid,
output  wire                io_ddrA_ar_ready,
input           [31:0]      io_ddrA_ar_payload_addr,
input           [5:0]       io_ddrA_ar_payload_id,
input           [7:0]       io_ddrA_ar_payload_len,
input           [2:0]       io_ddrA_ar_payload_size,
input           [1:0]       io_ddrA_ar_payload_burst,
input           [1:0]       io_ddrA_ar_payload_lock
);
/////////////////////////////////////////////////////////////////////////////
localparam [1:0]    IDLE    = 2'h0,
                    WRITE   = 2'h1,
                    READ    = 2'h2;

reg [1:0]           st_cur,
                    st_next; 

wire                op_write,
                    op_read;
/////////////////////////////////////////////////////////////////////////////
    always@(posedge clk or posedge reset)
    begin
    if(reset)
        st_cur <= IDLE;
    else
        st_cur <= st_next;
    end

    always@*
    begin
        st_next = st_cur;
        case(st_cur)
        IDLE:
        begin
            if(io_ddrA_aw_valid)
                st_next = WRITE;
            else if (io_ddrA_ar_valid)
                st_next = READ;
            else
                st_next = IDLE;
        end
        WRITE:
        begin
            if(io_ddrA_aw_ready)
                st_next = IDLE;
            else
                st_next = WRITE;
        end
        READ:
        begin
            if(io_ddrA_ar_ready)
                st_next = IDLE;
            else
                st_next = READ;
        end
        default: st_next = IDLE;
        endcase
    end
        
assign op_write = (st_cur == WRITE);
assign op_read = (st_cur == READ);

assign io_ddrA_arw_valid         = op_write ? io_ddrA_aw_valid : op_read ? io_ddrA_ar_valid : 1'b0; 
assign io_ddrA_arw_payload_addr  = op_write ? io_ddrA_aw_payload_addr    : io_ddrA_ar_payload_addr;  
assign io_ddrA_arw_payload_id    = op_write ? io_ddrA_aw_payload_id      : io_ddrA_ar_payload_id;    
assign io_ddrA_arw_payload_len   = op_write ? io_ddrA_aw_payload_len     : io_ddrA_ar_payload_len;   
assign io_ddrA_arw_payload_size  = op_write ? io_ddrA_aw_payload_size    : io_ddrA_ar_payload_size;  
assign io_ddrA_arw_payload_burst = op_write ? io_ddrA_aw_payload_burst   : io_ddrA_ar_payload_burst; 
assign io_ddrA_arw_payload_lock  = op_write ? io_ddrA_aw_payload_lock    : io_ddrA_ar_payload_lock;  
assign io_ddrA_arw_payload_write = op_write;

assign io_ddrA_aw_ready = op_write ? io_ddrA_arw_ready : 1'b0;
assign io_ddrA_ar_ready = op_read ? io_ddrA_arw_ready : 1'b0;

endmodule
