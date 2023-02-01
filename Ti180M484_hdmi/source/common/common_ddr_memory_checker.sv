///////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022 github-efx
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
module common_ddr_memory_checker #(
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