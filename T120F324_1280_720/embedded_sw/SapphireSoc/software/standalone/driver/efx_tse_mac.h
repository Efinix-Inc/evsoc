////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2025 Efinix Inc. All rights reserved.              
// Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
////////////////////////////////////////////////////////////////////////////////

/*******************************************************************************
*
* @file efx_tse_mac.h
*
* @brief Header file contain Mac function for the TSE (Triple-Speed Ethernet)
*
* Functions:
* - MacTxEn: Sets the transmit enable (TxEn) bit in the TSEMAC control/status register.
* - MacRxEn: Sets the receive enable (RxEn) bit in the TSEMAC control/status register.
* - MacSpeedSet: Sets the speed mode in the TSEMAC control/status register.
* - MacLoopbackSet: Sets the loopback mode in the TSEMAC control/status register.
* - MacIpgSet: Sets the Inter-Packet Gap (IPG) value in the TSEMAC IPG register.
* - MacAddrSet: Sets the destination and source MAC addresses in the TSEMAC registers.
* - Pause_XOn: Sets the transmit pause frame (XON) generation in the TSEMAC control/status register.
* - MacCntClean: Resets the statistics counters in the TSEMAC control/status register.
* - CntMonitor: Monitors and prints various statistics counters from the TSEMAC registers.
* - MacNormalInit: Initializes the TSEMAC with normal settings.
*
******************************************************************************/
#pragma once

#include "bsp.h"
#include "userDef.h"

// MAC Configuration Registers
#define VERSION 					0x0000
#define COMMAND_CONFIG				0x0008
#define MAC_ADDR_LO					0x000C
#define MAC_ADDR_HI					0x0010
#define FRM_LENGHT					0x0014
#define PAUSE_QUANT					0x0018
#define TX_IPG_LEN					0x005C
#define ETHERNET_CTRL_MAC_RST       0x0200
#define ETHERNET_CTRL_PHY_RST       0x0204
// MDIO Configuration Registers
#define	DIVIDER_PRE					0x0100
#define	RD_WR_EN					0x0104
#define	REG_PHY_ADDR				0x0108
#define	WR_DATA						0x010C
#define	RD_DATA						0x0110
#define	STATUS						0x0114

// Receive Supplementary Registers
#define	BOARD_FILTER_EN				0x0140
#define	MAC_ADDR_MAKE_LO			0x0144
#define	MAC_ADDR_MAKE_HI			0x0148
#define TX_DST_ADDR_INS				0x0180
#define DST_MAC_ADDR_LO				0x0184
#define	DST_MAC_ADDR_HI				0x0188

// Statistic Counter Registers
#define	A_FRAME_TRANSMITTED_OK		0x0068
#define	A_FRAME_RECEIVED_OK			0x006C
#define	A_FRAME_CHECK_SEQ_ERR		0x0070
#define	A_TX_PAUSE_MAC_CTRL_FRAME	0x0080
#define	A_RX_PAUSE_MAC_CTRL_FRAME	0x0084
#define	IF_INDICATES_ERROR			0x0088
#define	IF_OUT_ERROR				0x008C
#define	A_RX_FILTER_FRAMES_ERROR	0x009C
#define	ETHER_STATS_PKTS			0x00B4
#define	ETHER_STATS_UNDER_SIZE_PKTS	0x00B8
#define	ETHER_STATS_OVERSIZE_PKTS	0x00BC
#define	ETHER_PACKET_LENS			0x00C0

// IP Example Design Configuration Registers
#define	MAC_SW_RST					0x0200	//[0] mac_sw_rst
#define MUX_SELECT					0x0204	//[1] pat_mux_select [0] axi4_st_mux_select
#define UDP_MAC_PAT_GEN_EN			0x0208	//[1] mac_pat_gen_en [0] udp_pat_gen_en
#define PAT_GEN_NUM_IPG				0x020C	//[15:0] pat_gen_num [31:16] pat_gen_ipg
#define PAT_DST_MAC_LO				0x0210	//[31:0] pat_dst_mac
#define PAT_DST_MAC_HI				0x0214	//[47:32] pat_dst_mac
#define PAT_SRC_MAC_LO				0x0218	//[31:0] pat_src_mac
#define PAT_SRC_MAC_HI				0x021C	//[47:32] pat_src_mac
#define PAT_MAC_DLEN				0x0220	//[15:0] pat_mac_dlen
#define PAT_SRC_IP					0x0224	//[31:0] pat_src_ip
#define PAT_DST_IP					0x0228	//[31:0] pat_dst_ip
#define PAT_SRC_DST_PORT			0x022C	//[31:16] pat_dst_port [15:0] pat_src_port
#define PAT_UDP_DLEN				0x0230	//[15:0] pat_udp_dlen


/*******************************************************************************
*
* @brief This function sets the transmit enable (TxEn) bit in the TSEMAC control/status register.
*
* @param tx_en The value to set for the transmit enable bit.
*             - 0: Disable transmit.
*             - 1: Enable transmit.
*
******************************************************************************/
static void MacTxEn(u32 tx_en)
{
	u32 Value;
	//Set Mac TxEn
	Value = read_u32(TSEMAC_BASE+COMMAND_CONFIG) & TX_ENA_MASK;
	Value |= (tx_en&0x1)<<0;
	write_u32(Value, (TSEMAC_BASE+COMMAND_CONFIG));
	if(DEBUG_PRINTF_EN == 1) {
		bsp_printf("Info : Set Mac TxEn.\r\n");
	}
}

/*******************************************************************************
*
* @brief This function sets the transmit enable (RxEn) bit in the TSEMAC control/status register.
*
* @param tx_en The value to set for the receive enable bit.
*             - 0: Disable receive.
*             - 1: Enable receive.
*
******************************************************************************/
static void MacRxEn(u32 rx_en)
{
	u32 Value;
	//Set Mac RxEn
	Value = read_u32(TSEMAC_BASE+COMMAND_CONFIG) & RX_ENA_MASK;
	Value |= (rx_en&0x1)<<1;
	write_u32(Value, (TSEMAC_BASE+COMMAND_CONFIG));
	if(DEBUG_PRINTF_EN == 1) {
		bsp_printf("Info : Set Mac RxEn.\r\n");
	}
}

/*******************************************************************************
*
* @brief This function sets the Ethernet Speed 
*
* @param speed The value to set for the Ethernet Speed.
*             - 0x01: 10Mbps
*             - 0x02: 100Mbps
*             - 0x04: 1000Mbps
*
******************************************************************************/
static void MacSpeedSet(u32 speed)
{
	u32 Value;
	//Set Mac Speed
	Value = read_u32(TSEMAC_BASE+COMMAND_CONFIG) & ETH_SPEED_MASK;
	Value |= (speed&0x7)<<16;
	write_u32(Value, (TSEMAC_BASE+COMMAND_CONFIG));
	if(DEBUG_PRINTF_EN == 1) {
	    bsp_printf("Info : Set Mac Speed %d.\r\n",speed);
	}
}

/*******************************************************************************
*
* @brief This function sets the loopback mode in the TSEMAC control/status register.
*
* @param loopback_en The value to set for the loopback mode.
*                    - 0: Disable loopback.
*                    - 1: Enable loopback.
*
******************************************************************************/
static void MacLoopbackSet(u32 loopback_en)
{
	u32 Value;
	//Set Mac Loopback
	Value = read_u32(TSEMAC_BASE+COMMAND_CONFIG) & LOOP_ENA_MASK;
	Value |= (loopback_en&0x1)<<15;
	write_u32(Value, (TSEMAC_BASE+COMMAND_CONFIG));
	if(DEBUG_PRINTF_EN == 1) {
	    bsp_printf("Info : Set Mac Loopback.");
	}
}

/*******************************************************************************
*
* @brief This function sets the inter-packet gap (IPG) value in the TSEMAC IPG register.
*
* @param ipg The value of the inter-packet gap to be set.
*
******************************************************************************/
static void MacIpgSet(u32 ipg)
{
	//Set Mac IPG
	write_u32(ipg&0x3f, (TSEMAC_BASE+TX_IPG_LEN));
	if(DEBUG_PRINTF_EN == 1) {
	    bsp_printf("Info : Set Mac IPG.");
	}
}

/*******************************************************************************
*
* @brief This function sets the destination and source MAC addresses in the TSEMAC control/status register.
*
* @param dst_addr_ins The value to be written to the destination MAC address insert register.
* @param src_addr_ins The value to be written to the source MAC address insert register.
*
******************************************************************************/
static void MacAddrSet(u32 dst_addr_ins, u32 src_addr_ins)
{
	u32 Value;
	//dst mac addr set
    //mac_reg mac_addr[47:32]
	write_u32(DST_MAC_H, (TSEMAC_BASE+DST_MAC_ADDR_HI));
    //mac_reg mac_addr[31:0]
	write_u32(DST_MAC_L, (TSEMAC_BASE+DST_MAC_ADDR_LO));
	//dst mac addr ins set
    //mac_reg tx_dst_addr_ins
	write_u32(dst_addr_ins, (TSEMAC_BASE+TX_DST_ADDR_INS));
	//src mac addr set
    //mac_addr[47:32]
	write_u32(SRC_MAC_H, (TSEMAC_BASE+MAC_ADDR_HI));
    //mac_addr[31:0]
	write_u32(SRC_MAC_L, (TSEMAC_BASE+MAC_ADDR_LO));
	//src mac addr ins set
	Value = read_u32(TSEMAC_BASE+COMMAND_CONFIG) & TX_ADDR_INS_MASK;
	Value |= (src_addr_ins&0x1)<<9;
	write_u32(Value, (TSEMAC_BASE+COMMAND_CONFIG));
	if(DEBUG_PRINTF_EN == 1) {
	    bsp_printf("Info : Set Mac Address.");
	}
}

/********************************* Function **********************************
* 
* @brief This function sets the XON/XOFF pause frame control in the TSEMAC control/status register.
*
******************************************************************************/
static void Pause_XOn()
{
	u32 Value;
	//Set xon_gen 1
	Value = read_u32(TSEMAC_BASE+COMMAND_CONFIG) & XON_GEN_MASK;
	Value |= 0x1<<2;
	write_u32(Value, (TSEMAC_BASE+COMMAND_CONFIG));
	//Set xon_gen 0
	Value &= XON_GEN_MASK;
	Value |= 0x0<<2;
	write_u32(Value, (TSEMAC_BASE+COMMAND_CONFIG));
}

/*******************************************************************************
*
* @brief This function sets and clears the statistics counters in the TSEMAC control/status register.
*
******************************************************************************/
static void MacCntClean()
{
	u32 Value;
	//Set cnt_reset 1
	Value = read_u32(TSEMAC_BASE+COMMAND_CONFIG) & CNT_RST_MASK;
	Value |= 0x80000000;
	write_u32(Value, (TSEMAC_BASE+COMMAND_CONFIG));
	bsp_uDelay(1);
	//Set cnt_reset 0
	Value &= CNT_RST_MASK;
	Value |= 0x0;
	write_u32(Value, (TSEMAC_BASE+COMMAND_CONFIG));
	if(DEBUG_PRINTF_EN == 1) {
		bsp_printf("Info : Mac Reset Statistics Counters.");
	}
}

/*******************************************************************************
*
* @brief This function prints the values of various statistics counters in the TSEMAC control/status register.
*
* @note This function is usefult to track trasmit/receive frame error such as CRC errors, etc
*
******************************************************************************/
static void CntMonitor()
{
	bsp_printf("--------------------\r\n");
	bsp_printf("aFramesTransmittedOK :%x\r\n"     , read_u32(TSEMAC_BASE+A_FRAME_TRANSMITTED_OK));
	bsp_printf("aFramesReceivedOK :%x\r\n"        , read_u32(TSEMAC_BASE+A_FRAME_RECEIVED_OK));
	bsp_printf("ifInErrors :%x\r\n"               , read_u32(TSEMAC_BASE+IF_INDICATES_ERROR));
	bsp_printf("ifOutErrors :%x\r\n"              , read_u32(TSEMAC_BASE+IF_OUT_ERROR));
	bsp_printf("etherStatsPkts :%x"            	  , read_u32(TSEMAC_BASE+ETHER_STATS_PKTS));
	bsp_printf("etherStatsUndersizePkts :%x\r\n"  , read_u32(TSEMAC_BASE+ETHER_STATS_UNDER_SIZE_PKTS));
	bsp_printf("etherStatsOversizePkts :%x\r\n"   , read_u32(TSEMAC_BASE+ETHER_STATS_OVERSIZE_PKTS));
	bsp_printf("aRxFilterFramesErrors :%x\r\n"    , read_u32(TSEMAC_BASE+A_RX_FILTER_FRAMES_ERROR));
	bsp_printf("aFrameCheckSequenceErrors :%x\r\n", read_u32(TSEMAC_BASE+A_FRAME_CHECK_SEQ_ERR));
	bsp_printf("aTxPAUSEMACCtrlFrames :%x\r\n"    , read_u32(TSEMAC_BASE+A_TX_PAUSE_MAC_CTRL_FRAME));
	bsp_printf("aRxPAUSEMACCtrlFrames :%x\r\n"    , read_u32(TSEMAC_BASE+A_RX_PAUSE_MAC_CTRL_FRAME));
	bsp_printf("--------------------\r\n");
}


/*******************************************************************************
*
* @brief This function initializes the MAC by setting IPG and Speed.
*
* @param speed The speed setting to be applied to the TSEMAC.
*
******************************************************************************/
static void MacNormalInit(u32 speed)
{
	MacSpeedSet(speed);
	MacIpgSet(0x0C);
}

/************************** Function File ***************************/
static void MacRst(u8 macRst, u8 phyRst)
{
	write_u32((phyRst & 0x01), TSEMAC_BASE+ETHERNET_CTRL_PHY_RST);
	write_u32((macRst & 0x01), TSEMAC_BASE+ETHERNET_CTRL_MAC_RST);
	bsp_uDelay(100*1000); // 100ms delay
	write_u32(0, TSEMAC_BASE+ETHERNET_CTRL_MAC_RST);
	bsp_uDelay(100*1000);  // 100ms delay
	write_u32(0, TSEMAC_BASE+ETHERNET_CTRL_PHY_RST);
	bsp_uDelay(100*1000);  // 100ms delay
}
