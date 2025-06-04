--------------------------------------------------------------------------------
-- Copyright (C) 2013-2025 Efinix Inc. All rights reserved.              
--
-- This   document  contains  proprietary information  which   is        
-- protected by  copyright. All rights  are reserved.  This notice       
-- refers to original work by Efinix, Inc. which may be derivitive       
-- of other work distributed under license of the authors.  In the       
-- case of derivative work, nothing in this notice overrides the         
-- original author's license agreement.  Where applicable, the           
-- original license agreement is included in it's original               
-- unmodified form immediately below this header.                        
--                                                                       
-- WARRANTY DISCLAIMER.                                                  
--     THE  DESIGN, CODE, OR INFORMATION ARE PROVIDED “AS IS” AND        
--     EFINIX MAKES NO WARRANTIES, EXPRESS OR IMPLIED WITH               
--     RESPECT THERETO, AND EXPRESSLY DISCLAIMS ANY IMPLIED WARRANTIES,  
--     INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF          
--     MERCHANTABILITY, NON-INFRINGEMENT AND FITNESS FOR A PARTICULAR    
--     PURPOSE.  SOME STATES DO NOT ALLOW EXCLUSIONS OF AN IMPLIED       
--     WARRANTY, SO THIS DISCLAIMER MAY NOT APPLY TO LICENSEE.           
--                                                                       
-- LIMITATION OF LIABILITY.                                              
--     NOTWITHSTANDING ANYTHING TO THE CONTRARY, EXCEPT FOR BODILY       
--     INJURY, EFINIX SHALL NOT BE LIABLE WITH RESPECT TO ANY SUBJECT    
--     MATTER OF THIS AGREEMENT UNDER TORT, CONTRACT, STRICT LIABILITY   
--     OR ANY OTHER LEGAL OR EQUITABLE THEORY (I) FOR ANY INDIRECT,      
--     SPECIAL, INCIDENTAL, EXEMPLARY OR CONSEQUENTIAL DAMAGES OF ANY    
--     CHARACTER INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF      
--     GOODWILL, DATA OR PROFIT, WORK STOPPAGE, OR COMPUTER FAILURE OR   
--     MALFUNCTION, OR IN ANY EVENT (II) FOR ANY AMOUNT IN EXCESS, IN    
--     THE AGGREGATE, OF THE FEE PAID BY LICENSEE TO EFINIX HEREUNDER    
--     (OR, IF THE FEE HAS BEEN WAIVED, $100), EVEN IF EFINIX SHALL HAVE 
--     BEEN INFORMED OF THE POSSIBILITY OF SUCH DAMAGES.  SOME STATES DO 
--     NOT ALLOW THE EXCLUSION OR LIMITATION OF INCIDENTAL OR            
--     CONSEQUENTIAL DAMAGES, SO THIS LIMITATION AND EXCLUSION MAY NOT   
--     APPLY TO LICENSEE.                                                
--
--------------------------------------------------------------------------------
------------- Begin Cut here for COMPONENT Declaration ------
component csi2_hard_mipi_rx is
port (
    reset_n : in std_logic;
    clk : in std_logic;
    reset_byte_HS_n : in std_logic;
    clk_byte_HS : in std_logic;
    reset_pixel_n : in std_logic;
    clk_pixel : in std_logic;
    vsync_vc1 : out std_logic;
    vsync_vc15 : out std_logic;
    vsync_vc12 : out std_logic;
    vsync_vc9 : out std_logic;
    vsync_vc7 : out std_logic;
    vsync_vc14 : out std_logic;
    vsync_vc13 : out std_logic;
    vsync_vc11 : out std_logic;
    vsync_vc10 : out std_logic;
    vsync_vc8 : out std_logic;
    vsync_vc6 : out std_logic;
    vsync_vc4 : out std_logic;
    vsync_vc0 : out std_logic;
    vsync_vc5 : out std_logic;
    irq : out std_logic;
    pixel_data_valid : out std_logic;
    pixel_data : out std_logic_vector(63 downto 0);
    pixel_per_clk : out std_logic_vector(3 downto 0);
    datatype : out std_logic_vector(5 downto 0);
    shortpkt_data_field : out std_logic_vector(15 downto 0);
    word_count : out std_logic_vector(15 downto 0);
    vcx : out std_logic_vector(1 downto 0);
    vc : out std_logic_vector(1 downto 0);
    hsync_vc3 : out std_logic;
    hsync_vc2 : out std_logic;
    hsync_vc8 : out std_logic;
    hsync_vc12 : out std_logic;
    hsync_vc7 : out std_logic;
    hsync_vc10 : out std_logic;
    hsync_vc1 : out std_logic;
    hsync_vc0 : out std_logic;
    hsync_vc13 : out std_logic;
    hsync_vc4 : out std_logic;
    hsync_vc11 : out std_logic;
    hsync_vc6 : out std_logic;
    hsync_vc9 : out std_logic;
    hsync_vc15 : out std_logic;
    hsync_vc14 : out std_logic;
    hsync_vc5 : out std_logic;
    axi_rready : in std_logic;
    axi_rvalid : out std_logic;
    axi_rdata : out std_logic_vector(31 downto 0);
    axi_arready : out std_logic;
    axi_arvalid : in std_logic;
    axi_araddr : in std_logic_vector(5 downto 0);
    axi_bready : in std_logic;
    axi_bvalid : out std_logic;
    axi_wready : out std_logic;
    axi_wvalid : in std_logic;
    axi_wdata : in std_logic_vector(31 downto 0);
    vsync_vc3 : out std_logic;
    vsync_vc2 : out std_logic;
    axi_awready : out std_logic;
    axi_clk : in std_logic;
    axi_reset_n : in std_logic;
    axi_awaddr : in std_logic_vector(5 downto 0);
    axi_awvalid : in std_logic;
    RxUlpsClkNot : in std_logic;
    RxUlpsActiveClkNot : in std_logic;
    RxClkEsc : in std_logic_vector(1 downto 0);
    RxErrEsc : in std_logic_vector(1 downto 0);
    RxErrControl : in std_logic_vector(1 downto 0);
    RxErrSotSyncHS : in std_logic_vector(1 downto 0);
    RxUlpsEsc : in std_logic_vector(1 downto 0);
    RxUlpsActiveNot : in std_logic_vector(1 downto 0);
    RxSkewCalHS : in std_logic_vector(1 downto 0);
    RxStopState : in std_logic_vector(1 downto 0);
    RxSyncHS : in std_logic_vector(1 downto 0);
    RxDataHS0 : in std_logic_vector(15 downto 0);
    RxDataHS1 : in std_logic_vector(15 downto 0);
    RxDataHS2 : in std_logic_vector(15 downto 0);
    RxDataHS3 : in std_logic_vector(15 downto 0);
    RxDataHS4 : in std_logic_vector(15 downto 0);
    RxDataHS5 : in std_logic_vector(15 downto 0);
    RxDataHS6 : in std_logic_vector(15 downto 0);
    RxDataHS7 : in std_logic_vector(15 downto 0);
    RxValidHS0 : in std_logic_vector(1 downto 0);
    RxValidHS1 : in std_logic_vector(1 downto 0);
    RxValidHS2 : in std_logic_vector(1 downto 0);
    RxValidHS3 : in std_logic_vector(1 downto 0);
    RxValidHS4 : in std_logic_vector(1 downto 0);
    RxValidHS5 : in std_logic_vector(1 downto 0);
    RxValidHS6 : in std_logic_vector(1 downto 0);
    RxValidHS7 : in std_logic_vector(1 downto 0)
);
end component csi2_hard_mipi_rx;

---------------------- End COMPONENT Declaration ------------
------------- Begin Cut here for INSTANTIATION Template -----
u_csi2_hard_mipi_rx : csi2_hard_mipi_rx
port map (
    reset_n => reset_n,
    clk => clk,
    reset_byte_HS_n => reset_byte_HS_n,
    clk_byte_HS => clk_byte_HS,
    reset_pixel_n => reset_pixel_n,
    clk_pixel => clk_pixel,
    vsync_vc1 => vsync_vc1,
    vsync_vc15 => vsync_vc15,
    vsync_vc12 => vsync_vc12,
    vsync_vc9 => vsync_vc9,
    vsync_vc7 => vsync_vc7,
    vsync_vc14 => vsync_vc14,
    vsync_vc13 => vsync_vc13,
    vsync_vc11 => vsync_vc11,
    vsync_vc10 => vsync_vc10,
    vsync_vc8 => vsync_vc8,
    vsync_vc6 => vsync_vc6,
    vsync_vc4 => vsync_vc4,
    vsync_vc0 => vsync_vc0,
    vsync_vc5 => vsync_vc5,
    irq => irq,
    pixel_data_valid => pixel_data_valid,
    pixel_data => pixel_data,
    pixel_per_clk => pixel_per_clk,
    datatype => datatype,
    shortpkt_data_field => shortpkt_data_field,
    word_count => word_count,
    vcx => vcx,
    vc => vc,
    hsync_vc3 => hsync_vc3,
    hsync_vc2 => hsync_vc2,
    hsync_vc8 => hsync_vc8,
    hsync_vc12 => hsync_vc12,
    hsync_vc7 => hsync_vc7,
    hsync_vc10 => hsync_vc10,
    hsync_vc1 => hsync_vc1,
    hsync_vc0 => hsync_vc0,
    hsync_vc13 => hsync_vc13,
    hsync_vc4 => hsync_vc4,
    hsync_vc11 => hsync_vc11,
    hsync_vc6 => hsync_vc6,
    hsync_vc9 => hsync_vc9,
    hsync_vc15 => hsync_vc15,
    hsync_vc14 => hsync_vc14,
    hsync_vc5 => hsync_vc5,
    axi_rready => axi_rready,
    axi_rvalid => axi_rvalid,
    axi_rdata => axi_rdata,
    axi_arready => axi_arready,
    axi_arvalid => axi_arvalid,
    axi_araddr => axi_araddr,
    axi_bready => axi_bready,
    axi_bvalid => axi_bvalid,
    axi_wready => axi_wready,
    axi_wvalid => axi_wvalid,
    axi_wdata => axi_wdata,
    vsync_vc3 => vsync_vc3,
    vsync_vc2 => vsync_vc2,
    axi_awready => axi_awready,
    axi_clk => axi_clk,
    axi_reset_n => axi_reset_n,
    axi_awaddr => axi_awaddr,
    axi_awvalid => axi_awvalid,
    RxUlpsClkNot => RxUlpsClkNot,
    RxUlpsActiveClkNot => RxUlpsActiveClkNot,
    RxClkEsc => RxClkEsc,
    RxErrEsc => RxErrEsc,
    RxErrControl => RxErrControl,
    RxErrSotSyncHS => RxErrSotSyncHS,
    RxUlpsEsc => RxUlpsEsc,
    RxUlpsActiveNot => RxUlpsActiveNot,
    RxSkewCalHS => RxSkewCalHS,
    RxStopState => RxStopState,
    RxSyncHS => RxSyncHS,
    RxDataHS0 => RxDataHS0,
    RxDataHS1 => RxDataHS1,
    RxDataHS2 => RxDataHS2,
    RxDataHS3 => RxDataHS3,
    RxDataHS4 => RxDataHS4,
    RxDataHS5 => RxDataHS5,
    RxDataHS6 => RxDataHS6,
    RxDataHS7 => RxDataHS7,
    RxValidHS0 => RxValidHS0,
    RxValidHS1 => RxValidHS1,
    RxValidHS2 => RxValidHS2,
    RxValidHS3 => RxValidHS3,
    RxValidHS4 => RxValidHS4,
    RxValidHS5 => RxValidHS5,
    RxValidHS6 => RxValidHS6,
    RxValidHS7 => RxValidHS7
);

------------------------ End INSTANTIATION Template ---------
