////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2025 Efinix Inc. All rights reserved.              
// Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
////////////////////////////////////////////////////////////////////////////////
#pragma once

#include "bsp.h"
#include "userDef.h"
#include "efx_tse_mac.h"

#define RTL8211F_RX_DELAY			BIT_3

static u32 Phy_Rd(u32 RegAddr)
{
    u32 Value;
    write_u32(((PHY_ADDR&0x1f)<<8)|(RegAddr&0x1f), (TSEMAC_BASE+REG_PHY_ADDR));
    write_u32(0x1, (TSEMAC_BASE+RD_WR_EN));
    bsp_uDelay(1000);
    Value = read_u32(TSEMAC_BASE+RD_DATA);
	if(DEBUG_PRINTF_EN == 1) {
        bsp_printf("Rd Phy Addr :%x \r\n", RegAddr);
        bsp_printf("Return Value :%x \r\n", Value);
    }

    return Value;
}

static void Phy_Wr(u32 RegAddr,u32 Data)
{
    write_u32(((PHY_ADDR&0x1f)<<8)|(RegAddr&0x1f), (TSEMAC_BASE+REG_PHY_ADDR));
    write_u32(Data, (TSEMAC_BASE+WR_DATA));
    write_u32(0x2, (TSEMAC_BASE+RD_WR_EN));
	if(DEBUG_PRINTF_EN == 1) {
        bsp_printf("Wr Phy Addr :%x \r\n", RegAddr);
        bsp_printf("Wr Phy Data :%x \r\n", Data);
    }
}

static int rtl8211_drv_rddata(int addr)
{
	 return Phy_Rd(addr);
}

static void rtl8211_drv_wrdata(int addr ,int data)
{
	 Phy_Wr(addr,data);
	 bsp_uDelay(100);
}

static void rtl8211_drv_setpage(int page)
{
	 Phy_Wr(31,page & 0xFFFF);
	 bsp_uDelay(100);
}

static int rtl8211_drv_linkup(void)
{
	int phy_reg=0;
	int speed=TSE_Speed_1000Mhz;

	/* Below to fix 1000mbps fail to ping intermittently when power cycle */
	// 1000mbps control register
	int ctrl_reg = 0;
	ctrl_reg=rtl8211_drv_rddata(9);
	rtl8211_drv_wrdata(0x09,ctrl_reg|0x1800 );

	ctrl_reg=rtl8211_drv_rddata(9);
	/* Above to fix 1000mbps fail to ping intermittently when power cycle */
	phy_reg=rtl8211_drv_rddata(26);

	 while(1)
	{
		phy_reg=rtl8211_drv_rddata(26);

		if(phy_reg & 0x04)
		{
			bsp_printf("Linked Up\r\n");
			break;
		}

		bsp_uDelay(1000000); /* To fix 1000mbps fail to ping intermittently when power cycle */
	}

	if((phy_reg & 0x30) == 0x20)
	{
		if(phy_reg & 0x08)
			bsp_printf("Link Partner Full duplex 1000 Mbps\n\r\n\r");
		else
			bsp_printf("Link Partner half duplex 1000 Mbps\n\r\n\r");
		speed = TSE_Speed_1000Mhz;
	}
	else if((phy_reg & 0x30) == 0x10)
	{
		if(phy_reg & 0x08)
			bsp_printf("Link Partner Full duplex 100 Mbps\n\r\n\r");
		else
			bsp_printf("Link Partner half duplex 100 Mbps\n\r\n\r");
		speed = TSE_Speed_100Mhz;
	}
	else if((phy_reg & 0x30) == 0)
	{
		if(phy_reg & 0x08)
			bsp_printf("Link Partner Full duplex 10 Mbps\n\r\n\r");
		else
			bsp_printf("Link Partner half duplex 10 Mbps\n\r\n\r");
		speed = TSE_Speed_10Mhz;
	}

	return speed;
}

static void rtl8211_drv_init(void)
{
	rtl8211_drv_setpage(0);
	rtl8211_drv_wrdata(0,0x9000);
	bsp_uDelay(1000*50);
	rtl8211_drv_wrdata(0,0x1000);
	bsp_uDelay(1000*50);

	rtl8211_drv_setpage(0x0A43);
	rtl8211_drv_wrdata(27,0x8011);
	rtl8211_drv_wrdata(28,0xD73F);
//	bsp_uDelay(1000*50);

	rtl8211_drv_setpage(0xD04);
	rtl8211_drv_wrdata(0x10,0x820B);
//	bsp_uDelay(1000*50);

	rtl8211_drv_setpage(0x0D08);
	rtl8211_drv_wrdata(0x15, 0 & RTL8211F_RX_DELAY);
//	bsp_uDelay(1000*50);
}
