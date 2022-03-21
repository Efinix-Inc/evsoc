
#include "bsp.h"
#include "hdmi_common.h"
#include "hdmi_driver.h"
#include "hdmi_config.h"

#define FALLING_EDGE_TRIGGER

#define MSCOUNT 1000
#define LOADING_UPDATE_TIMEOUT (3000/32)    // 3sec

_IDATA INSTANCE Instance[HDMITX_INSTANCE_MAX] ;

static void SetupAFE(VIDEOPCLKLEVEL PCLKLevel);
static void FireAFE();

static SYS_STATUS SetNCTS(BYTE Fs);

static void AutoAdjustAudio(void);
static SYS_STATUS SetAVIInfoFrame(AVI_InfoFrame *pAVIInfoFrame);
static SYS_STATUS SetAudioInfoFrame(Audio_InfoFrame *pAudioInfoFrame);
static SYS_STATUS ReadEDID(BYTE *pData,BYTE bSegment,BYTE offset,SHORT Count);
static void AbortDDC();
static void ClearDDCFIFO();
static void ClearDDCFIFO();
//static void GenerateDDCSCLK();

static void ENABLE_NULL_PKT();
//static void ENABLE_ACP_PKT();
//static void ENABLE_ISRC1_PKT();
//sstatic void ENABLE_ISRC2_PKT();
static void ENABLE_AVI_INFOFRM_PKT();
static void ENABLE_AUD_INFOFRM_PKT();

static void DISABLE_NULL_PKT();
static void DISABLE_ACP_PKT();
static void DISABLE_ISRC1_PKT();
static void DISABLE_ISRC2_PKT();
static void DISABLE_AVI_INFOFRM_PKT();
static void DISABLE_AUD_INFOFRM_PKT();
static void DISABLE_SPD_INFOFRM_PKT();
static void DISABLE_MPG_INFOFRM_PKT();

_IDATA BYTE LastRefaudfreqnum=0;

BOOL BootFlag=TRUE;
extern BOOL ReGenTimingEnable;
extern BOOL bChangeMode;
extern BOOL bForceCTS;
_IDATA BYTE AudioDelayCnt=0;
BYTE LVDS_ReadI2C_Byte(BYTE RegAddr)
{
    BYTE p_data;

    p_data=ReadRegData_LVDS(RegAddr);

    return p_data;
}

SYS_STATUS LVDS_WriteI2C_Byte(BYTE RegAddr, BYTE d)
{
    BOOL flag;

    WriteRegData_LVDS(RegAddr,d);

    return !flag;
}
void InitLVDS()
{
    Switch_HDMITX_Bank(0);
    HDMITX_WriteI2C_Byte(0x1d,0x66);
    HDMITX_WriteI2C_Byte(0x1E,0x01);

    ResetLVDS();
    bsp_uDelay(1000*10);
    SetLVDSinterface();
    bsp_uDelay(1000*10);
    SetLVDS_AFE();
    bsp_uDelay(1000*500);
}
void ResetLVDS(void)
{
    LVDS_AndREG_TX_Byte(0x3c,0xfe);//LVDS AFE PLL RESET
    bsp_uDelay(1000*1);
    LVDS_OrREG_TX_Byte(0x3c,0x01);
    LVDS_OrREG_TX_Byte(0x05,0x02);//RESET LVDS PCLK
    bsp_uDelay(1000*1);
    LVDS_AndREG_TX_Byte(0x05,0xfd);

}
void SetLVDS_AFE(void)
{
    LVDS_WriteI2C_Byte(0x3e,0xaa);
    LVDS_WriteI2C_Byte(0x3f,0x02);
    LVDS_WriteI2C_Byte(0x47,0xaa);
    LVDS_WriteI2C_Byte(0x48,0x02);
    LVDS_WriteI2C_Byte(0x4f,0x11);

    LVDS_OrREG_TX_Byte(0x0b,0x01);

    LVDS_AndREG_TX_Byte(0x3c,(~0x07));
    LVDS_OrREG_TX_Byte(0x2c,(1<<6));

    if(100000000L<GetInputPclk())
        LVDS_AndREG_TX_Byte(0x39,0x3f);
    else
        LVDS_OrREG_TX_Byte(0x39,0xc0);

    LVDS_OrREG_TX_Byte(0x2c,(1<<4));

    LVDS_OrREG_TX_Byte(0x39,0x02);
    LVDS_AndREG_TX_Byte(0x39,0xfd);

    bsp_uDelay(1000*20);

}
BOOL SetLVDSinterface(void)
{
    BYTE uc;
    uc=(LVDS_ReadI2C_Byte(0x2c)&0x03);

#ifdef SUPPORT_LVDS_8_BIT
    if(0x01 != uc)
    {
        LVDS_AndREG_TX_Byte(0x2c,0xfc);//[1:0]=("00"-6 bit),("01"-8 bit),("10"-10 bit)
        LVDS_OrREG_TX_Byte(0x2c,0x01);
    }
#endif
#ifdef SUPPORT_LVDS_6_BIT
    if(0x00 != uc)
    {
        LVDS_AndREG_TX_Byte(0x2c,0xfc);//[1:0]=("00"-6 bit),("01"-8 bit),("10"-10 bit)
        LVDS_OrREG_TX_Byte(0x2c,0x00);
    }
#endif
#ifdef SUPPORT_LVDS_10_BIT
    if(0x02 != uc)
    {
        LVDS_AndREG_TX_Byte(0x2c,0xfc);//[1:0]=("00"-6 bit),("01"-8 bit),("10"-10 bit)
        LVDS_OrREG_TX_Byte(0x2c,0x02);
    }
#endif

    uc=(LVDS_ReadI2C_Byte(0x2c)&(1<<7));
#ifdef SUPPORT_DISO
    if(uc != (1<<7))
    {
        LVDS_OrREG_TX_Byte(0x2c,(1<<7));
        LVDS_OrREG_TX_Byte(0x52,(1<<1));
    }
#else
    if(uc != (0<<7))
    {
        LVDS_AndREG_TX_Byte(0x2c,(~(1<<7)));
        LVDS_AndREG_TX_Byte(0x52,(~(1<<1)));
    }
#endif
    return TRUE;
}
WORD GetInputClockCount(void)
{
    BYTE u1,u2;
    WORD temp1;
    u1 = LVDS_ReadI2C_Byte(0x58);
    u2 = LVDS_ReadI2C_Byte(0x57);
    temp1=((WORD)u1<<8);
    temp1+=u2;
    return temp1;
}
ULONG GetInputPclk(void)
{
    BYTE u3,StableCnt=0,LoopCnt=20;
    WORD LastTemp;
    WORD temp1;
    while(LoopCnt--)
    {
        temp1=GetInputClockCount();
        if( (temp1<(LastTemp-(LastTemp>>6)))||
            (temp1>(LastTemp+(LastTemp>>6))))
        {
            StableCnt=0;
        }
        else
        {
            StableCnt++;
        }
        if(StableCnt>5)break;
        LastTemp=temp1;
    }

    u3=LVDS_ReadI2C_Byte(0x2c);
    if(u3&0x80)
        temp1/=2;
    if(0x40&u3)
    {
        return ((49000000L/temp1)<<8);
    }
    else
    {
        return ((27000000L/temp1)<<10);
    }
}

BOOL CheckLVDS(void)
{
    BYTE u1;
    static BYTE LVDS_UnStable_Cnt=0;
    SetLVDSinterface();
    u1=(0x03&LVDS_ReadI2C_Byte(0x30));

    if(0x03!=u1)//0x30[1] LVDS Lock [0] LVDS Stable
    {
        LVDS_UnStable_Cnt++;
    }
    else
    {
        LVDS_UnStable_Cnt=0;
        return TRUE;
    }
    if(LVDS_UnStable_Cnt>0)
    {
        InitLVDS();
        LVDS_UnStable_Cnt=0;
    }
    return FALSE;
}
//===================================================================
struct CRT_TimingSetting {
	BYTE fmt;
    BYTE interlaced;
	UINT  VEC[11];
};
//   VDEE_L,   VDEE_H, VRS2S_L, VRS2S_H, VRS2E_L, VRS2E_H, HalfL_L, HalfL_H, VDE2S_L, VDE2S_H, HVP&Progress
_CODE struct CRT_TimingSetting TimingTable[] =
{
// {    FMT             ,  Int,      HT   ,	 H_DEW,    H_FBH,  H_SyncW,   H_BBH,   VTotal,   V_DEW,  V_FBH,  V_SyncW,  V_BBH,   Sync_pol,   }},
	{ HDMI_480p60       ,    0,    { 858 ,    720,       16,      62,       60,       525,     480,      9,        6,     30,    0 } },
	{ HDMI_480p60_16x9  ,    0,    { 858 ,    720,       16,      62,       60,       525,     480,      9,        6,     30,    0 } },
	{ HDMI_720p60       ,    0,    {1650 ,   1280,      110,      40,      220,       750,     720,      5,        5,     20,    3 } },
	{ HDMI_1080i60      ,    1,    {2200 ,   1920,       88,      44,      148,      1125,     540,      2,        5,     15,    3 } },
	{ HDMI_480i60_16x9  ,    1,    { 858 ,    720,       19,      62,       57,       525,     240,      4,        3,     15,    0 } },
	{ HDMI_1080p60      ,    0,    {2200 ,   1920,       88,      44,      148,      1125,    1080,      4,        5,     36,    3 } },

	{ HDMI_576p50       ,    0,    { 864 ,    720,       12,      64,       68,       525,     480,      5,        5,     36,    0 } },
	{ HDMI_720p50       ,    0,    {1980 ,   1280,      440,      40,      220,       750,     720,      5,        5,     20,    3 } },
	{ HDMI_1080i50      ,    1,    {2640 ,   1920,      528,      44,      148,      1125,     540,      2,        5,     15,    3 } },
	{ HDMI_1080p50      ,    0,    {2640 ,   1920,      528,      44,      148,      1125,    1080,      4,        5,     36,    3 } },
	{ HDMI_1080p24      ,    0,    {2750 ,   1920,      638,      44,      148,      1125,    1080,      4,        5,     36,    3 } },
	{ HDMI_720p60_FP3D  ,    0,    {1650 ,   1280,      110,      40,      220,     2*750,  750+720,      5,        5,     20,    3 } },
	{ HDMI_720p50_FP3D  ,    0,    {1980 ,   1280,      440,      40,      220,     2*750,  750+720,      5,        5,     20,    3 } },
	{ HDMI_1080p24_FP3D ,    0,    {2750 ,   1920,      638,      44,      148,     2*1125,1125+1080,      4,        5,     36,    3 } },

};
#define MaxIndex (sizeof(TimingTable)/sizeof(struct CRT_TimingSetting))


BYTE HDMITX_DetectVIC()
{
    BYTE  i ;
    UINT HTotal, VTotal, HActive, VActive ;

    for( i = 0 ;i  < MaxIndex ; i++ )
    {
        EnableHVToolDetect(TRUE);
        HTotal = GetHTotal();
        VTotal = GetVTotal() ;
        HActive = GetHActive() ;
        VActive = GetVActive() ;

        if(( TimingTable[i].VEC[0] == HTotal )&&
           ( TimingTable[i].VEC[1] == HActive )&&
           ( (TimingTable[i].VEC[5]%2048) == VTotal )&&
           ( (TimingTable[i].VEC[6]%2048) == VActive ))
        {
            return TimingTable[i].fmt ;
        }
    }
    return 0 ;
}
//===================================================================
void HDMITX_InitInstance(INSTANCE *pInstance)
{
	if(pInstance && 0 < HDMITX_INSTANCE_MAX)
	{
		Instance[0] = *pInstance ;
	}
    Instance[0].bAudFs=AUDFS_OTHER;
}

void InitIT626X()
{
    BYTE intclr;
    HDMITX_WriteI2C_Byte(REG_TX_SW_RST,B_REF_RST|B_VID_RST|B_AUD_RST|B_AREF_RST|B_HDCP_RST);
    bsp_uDelay(1000*1);
    Switch_HDMITX_Bank(0);
    HDMITX_WriteI2C_Byte(REG_TX_INT_CTRL,Instance[0].bIntType);
    Instance[0].bIntPOL = (Instance[0].bIntType&B_INTPOL_ACTH)?TRUE:FALSE ;
    Instance[0].TxEMEMStatus=TRUE;


    HDMITX_WriteI2C_Byte(REG_TX_SW_RST,B_AUD_RST|B_AREF_RST|B_HDCP_RST);
    InitLVDS();

    HDMITX_WriteI2C_Byte(REG_TX_AFE_DRV_CTRL,B_AFE_DRV_RST|B_AFE_DRV_PWD);

    HDMITX_AndREG_Byte(0xF3,~0x30);
    HDMITX_OrREG_Byte(0xF3,0x20);

	HDMITX_WriteI2C_Byte(REG_TX_INT_MASK1,0x30);
    HDMITX_WriteI2C_Byte(REG_TX_INT_MASK2,0xF8);
    HDMITX_WriteI2C_Byte(REG_TX_INT_MASK3,0x37);
    Switch_HDMITX_Bank(0);
    DISABLE_NULL_PKT();
    DISABLE_ACP_PKT();
    DISABLE_ISRC1_PKT();
    DISABLE_ISRC2_PKT();
    DISABLE_AVI_INFOFRM_PKT();
    DISABLE_AUD_INFOFRM_PKT();
    DISABLE_SPD_INFOFRM_PKT();
    DISABLE_MPG_INFOFRM_PKT();
    Switch_HDMITX_Bank(1);
    HDMITX_AndREG_Byte(REG_TX_AVIINFO_DB1,~(3<<5));
    Switch_HDMITX_Bank(0);
	//////////////////////////////////////////////////////////////////
	// Setup Output Audio format.
	//////////////////////////////////////////////////////////////////
    HDMITX_WriteI2C_Byte(REG_TX_AUDIO_CTRL1,Instance[0].bOutputAudioMode); // regE1 bOutputAudioMode should be loaded from ROM image.


	HDMITX_WriteI2C_Byte(REG_TX_INT_CLR0,0xFF);
    HDMITX_WriteI2C_Byte(REG_TX_INT_CLR1,0xFF);
    intclr = (HDMITX_ReadI2C_Byte(REG_TX_SYS_STATUS))|B_CLR_AUD_CTS | B_INTACTDONE ;
    HDMITX_WriteI2C_Byte(REG_TX_SYS_STATUS,intclr); // clear interrupt.
    intclr &= ~(B_INTACTDONE);
    HDMITX_WriteI2C_Byte(REG_TX_SYS_STATUS,intclr); // INTACTDONE reset to zero.

    {
        ULONG n=6144L;
        Switch_HDMITX_Bank(1);
        HDMITX_WriteI2C_Byte(REGPktAudN0,(BYTE)((n)&0xFF));
        HDMITX_WriteI2C_Byte(REGPktAudN1,(BYTE)((n>>8)&0xFF));
        HDMITX_WriteI2C_Byte(REGPktAudN2,(BYTE)((n>>16)&0xF));
        Switch_HDMITX_Bank(0);
        HDMITX_WriteI2C_Byte(0xc4,0xfe);
        HDMITX_OrREG_Byte(REG_TX_PKT_SINGLE_CTRL,(1<<4)|(1<<5));
    }
}

BOOL SetupVideoInputSignal(BYTE inputSignalType)
{
	Instance[0].bInputVideoSignalType = inputSignalType ;

    return TRUE ;
}

BOOL EnableVideoOutput(/*VIDEOPCLKLEVEL*/BYTE level,BYTE inputColorMode,BYTE outputColorMode,BYTE bHDMI)
{


    Instance[0].bHDMIMode = (BYTE)bHDMI ;

    SetAVMute(TRUE);


    Switch_HDMITX_Bank(1);
    HDMITX_WriteI2C_Byte(REG_TX_AVIINFO_DB1, 0x10) ;
    Switch_HDMITX_Bank(0);
    HDMITX_WriteI2C_Byte(0x70,0) ;
    HDMITX_WriteI2C_Byte(0x71,0) ;
    if(Instance[0].bHDMIMode)
    {
        HDMITX_WriteI2C_Byte(REG_TX_HDMI_MODE,B_TX_HDMI_MODE);
    }
    else
    {
        HDMITX_WriteI2C_Byte(REG_TX_HDMI_MODE,B_TX_DVI_MODE);
    }


    SetupAFE(level); // pass if High Freq request
    FireAFE();

    HDMITX_WriteI2C_Byte(REG_TX_INT_CLR0,0);
    HDMITX_WriteI2C_Byte(REG_TX_INT_CLR1,B_CLR_VIDSTABLE);
    HDMITX_WriteI2C_Byte(REG_TX_SYS_STATUS,B_INTACTDONE);

	return TRUE ;
}

BOOL GetEDIDData(int EDIDBlockID,BYTE *pEDIDData)
{
	if(!pEDIDData)
	{
		return FALSE ;
	}

    if(ReadEDID(pEDIDData,EDIDBlockID/2,(EDIDBlockID%2)*128,128) == ER_FAIL)
    {
        return FALSE ;
    }

    return TRUE ;
}

BYTE CheckHDMITX(BYTE *pHPD,BYTE *pHPDChange)
{
    BYTE intdata1,intdata2,intdata3,sysstat;
    BYTE  intclr3 = 0 ;
    BYTE PrevHPD = Instance[0].bHPD ;
    BYTE HPD ;

    sysstat = HDMITX_ReadI2C_Byte(REG_TX_SYS_STATUS);

	if((sysstat & (B_HPDETECT/*|B_RXSENDETECT*/)) == (B_HPDETECT/*|B_RXSENDETECT*/))
	{
    	HPD = TRUE;
    }
	else
	{
	    HPD = FALSE;
	}

    if(pHPDChange)
    {
    	*pHPDChange = FALSE ;
    }


    if(HPD==FALSE)
    {
        Instance[0].bAuthenticated = FALSE ;
    }

    if(sysstat & B_INT_ACTIVE)
    {

        intdata1 = HDMITX_ReadI2C_Byte(REG_TX_INT_STAT1);
        if(intdata1 & B_INT_AUD_OVERFLOW)
        {
            HDMITX_OrREG_Byte(0xc5,(1<<4));
            HDMITX_OrREG_Byte(REG_TX_SW_RST,(B_AUD_RST|B_AREF_RST));
            HDMITX_AndREG_Byte(REG_TX_SW_RST,~(B_AUD_RST|B_AREF_RST));
            AudioDelayCnt=AudioOutDelayCnt;
            LastRefaudfreqnum=0;
        }

		if(intdata1 & B_INT_DDCFIFO_ERR)
		{
		    ClearDDCFIFO();
		}


		if(intdata1 & B_INT_DDC_BUS_HANG)
		{
            AbortDDC();
		}


		if(intdata1 & (B_INT_HPD_PLUG|B_INT_RX_SENSE))
		{
            if(pHPDChange && (Instance[0].bHPD != HPD))
            {
				*pHPDChange = TRUE;
			}
            if(HPD == FALSE)
            {
                HDMITX_WriteI2C_Byte(REG_TX_SW_RST,B_AREF_RST|B_VID_RST|B_AUD_RST|B_HDCP_RST);
                bsp_uDelay(1000*1);
                HDMITX_WriteI2C_Byte(REG_TX_AFE_DRV_CTRL,B_AFE_DRV_RST|B_AFE_DRV_PWD);

                LastRefaudfreqnum=0;
            }
		}


        intdata2 = HDMITX_ReadI2C_Byte(REG_TX_INT_STAT2);

		intdata3 = HDMITX_ReadI2C_Byte(REG_TX_INT_STAT3);
		if(intdata3 & B_INT_VIDSTABLE)
		{
			sysstat = HDMITX_ReadI2C_Byte(REG_TX_SYS_STATUS);
            if(Instance[0].bVideoOut==FALSE || (sysstat & B_TXVIDSTABLE))
            {
                bChangeMode=TRUE;
            }
            else
            {
                Instance[0].bVideoOut=FALSE;
            }
		}
        HDMITX_WriteI2C_Byte(REG_TX_INT_CLR0,0xFF);
        HDMITX_WriteI2C_Byte(REG_TX_INT_CLR1,0xFF);
        intclr3 = (HDMITX_ReadI2C_Byte(REG_TX_SYS_STATUS))|B_CLR_AUD_CTS | B_INTACTDONE ;
        HDMITX_WriteI2C_Byte(REG_TX_SYS_STATUS,intclr3); // clear interrupt.
        intclr3 &= ~(B_INTACTDONE);
        HDMITX_WriteI2C_Byte(REG_TX_SYS_STATUS,intclr3); // INTACTDONE reset to zero.
    }
    else
    {
        if(pHPDChange)
        {
		    if(HPD != PrevHPD)
		    {
                *pHPDChange = TRUE;
            }
            else
            {
               *pHPDChange = FALSE;
            }
        }
    }
    if(pHPDChange)
    {
        if((*pHPDChange==TRUE) &&(HPD==FALSE))
        {
            HDMITX_WriteI2C_Byte(REG_TX_AFE_DRV_CTRL,B_AFE_DRV_RST|B_AFE_DRV_PWD);
        }
    }

    if(pHPD)
    {
         *pHPD = HPD    ;
    }

    Instance[0].bHPD = HPD ;
    return HPD ;
}




void DisableIT626X()
{
    HDMITX_WriteI2C_Byte(REG_TX_SW_RST,B_AREF_RST|B_VID_RST|B_AUD_RST|B_HDCP_RST);
    bsp_uDelay(1000*1);
    HDMITX_WriteI2C_Byte(REG_TX_AFE_DRV_CTRL,B_AFE_DRV_RST|B_AFE_DRV_PWD);
}

void DisableVideoOutput()
{
    BYTE uc = HDMITX_ReadI2C_Byte(REG_TX_SW_RST) | B_VID_RST ;
    HDMITX_WriteI2C_Byte(REG_TX_SW_RST,uc);
    HDMITX_WriteI2C_Byte(REG_TX_AFE_DRV_CTRL,B_AFE_DRV_RST|B_AFE_DRV_PWD);
    Instance[0].bVideoOut=FALSE;
}


void DisableAudioOutput()
{

    HDMITX_OrREG_Byte(REG_TX_PKT_SINGLE_CTRL,(1<<5));
    //SetAVMute(TRUE);

    HDMITX_OrREG_Byte(REG_TX_SW_RST,B_AUD_RST|B_AREF_RST);

    AudioDelayCnt=AudioOutDelayCnt;
    LastRefaudfreqnum=0;
}

static SYS_STATUS
SetVSIInfoFrame(VendorSpecific_InfoFrame *pVSIInfoFrame)
{
    int i ;
    BYTE ucData=0 ;

    if(!pVSIInfoFrame)
    {
        return ER_FAIL ;
    }

    Switch_HDMITX_Bank(1);

    if(pVSIInfoFrame->pktbyte.VS_HB[2]>27) // HB[2] = Checksum ;
    {
        pVSIInfoFrame->pktbyte.VS_HB[2] = 27 ;
    }

    HDMITX_WriteI2C_Byte(REG_TX_PKT_HB00,pVSIInfoFrame->pktbyte.VS_HB[0]); ucData -= pVSIInfoFrame->pktbyte.VS_HB[0] ;
    HDMITX_WriteI2C_Byte(REG_TX_PKT_HB01,pVSIInfoFrame->pktbyte.VS_HB[1]); ucData -= pVSIInfoFrame->pktbyte.VS_HB[1] ;
    HDMITX_WriteI2C_Byte(REG_TX_PKT_HB02,pVSIInfoFrame->pktbyte.VS_HB[2]); ucData -= pVSIInfoFrame->pktbyte.VS_HB[2] ;

    for( i = 0 ; i < (int)(pVSIInfoFrame->pktbyte.VS_HB[2]) ; i++ )
    {
        HDMITX_WriteI2C_Byte(REG_TX_PKT_PB01+i,pVSIInfoFrame->pktbyte.VS_DB[1+i]) ;
        ucData -= pVSIInfoFrame->pktbyte.VS_DB[1+i] ;
    }

    for( ; i < 27 ;i++ )
    {
        HDMITX_WriteI2C_Byte(REG_TX_PKT_PB01+i,0 ) ;
    }

    ucData &= 0xFF ;
    pVSIInfoFrame->pktbyte.VS_DB[0]=ucData;

    HDMITX_WriteI2C_Byte(REG_TX_PKT_PB00,pVSIInfoFrame->pktbyte.VS_DB[0]);
    Switch_HDMITX_Bank(0);
    ENABLE_NULL_PKT();
    return ER_SUCCESS ;
}

BOOL EnableVSInfoFrame(BYTE bEnable,BYTE *pVSInfoFrame)
{
    if(!bEnable)
    {
        DISABLE_NULL_PKT();
        return TRUE ;
    }

    if(SetVSIInfoFrame((VendorSpecific_InfoFrame *)pVSInfoFrame) == ER_SUCCESS)
    {
        return TRUE ;
    }

    return FALSE ;
}

BOOL
EnableAVIInfoFrame(BYTE bEnable,BYTE *pAVIInfoFrame)
{
    if(!bEnable)
    {
        DISABLE_AVI_INFOFRM_PKT();
        Switch_HDMITX_Bank(1);
        HDMITX_AndREG_Byte(REG_TX_AVIINFO_DB1,~(3<<5));
        Switch_HDMITX_Bank(0);
        return TRUE ;
    }

    if(SetAVIInfoFrame((AVI_InfoFrame *)pAVIInfoFrame) == ER_SUCCESS)
    {
        return TRUE ;
    }

    return FALSE ;
}

BOOL
EnableAudioInfoFrame(BYTE bEnable,BYTE *pAudioInfoFrame)
{
    if(!bEnable)
    {
        DISABLE_AVI_INFOFRM_PKT();
        return TRUE ;
    }


    if(SetAudioInfoFrame((Audio_InfoFrame *)pAudioInfoFrame) == ER_SUCCESS)
    {
        return TRUE ;
    }

    return FALSE ;
}

void SetAVMute(BYTE bEnable)
{
    BYTE uc ;

    Switch_HDMITX_Bank(0);
    uc = HDMITX_ReadI2C_Byte(REG_TX_GCP);
    uc &= ~B_TX_SETAVMUTE ;
    uc |= bEnable?B_TX_SETAVMUTE:0 ;

    HDMITX_WriteI2C_Byte(REG_TX_GCP,uc);
    HDMITX_WriteI2C_Byte(REG_TX_PKT_GENERAL_CTRL,B_ENABLE_PKT|B_REPEAT_PKT);

    if(bEnable)
    {
    	HDMI_OrREG_TX_Byte(REG_TX_AFE_DRV_CTRL,B_AFE_DRV_PWD);
    }
    else
    {
    	HDMI_AndREG_TX_Byte(REG_TX_AFE_DRV_CTRL,((~B_AFE_DRV_PWD) & 0xFF));
    }
}
BOOL GetAVMute()
{
    if(B_SET_AVMUTE&HDMITX_ReadI2C_Byte(REG_TX_GCP))
    {    return TRUE;}
    else
    {    return FALSE;}
}
void SetOutputColorDepthPhase(BYTE ColorDepth,BYTE bPhase)
{
    BYTE uc ;
    BYTE bColorDepth ;
    bPhase=(~bPhase);
    if(ColorDepth == 30)
    {
        bColorDepth = B_CD_30 ;
    }
    else if (ColorDepth == 36)
    {
        bColorDepth = B_CD_36 ;
    }/*
    else if (ColorDepth == 24)
    {
        bColorDepth = B_CD_24 ;
    }*/
    else
    {
        bColorDepth = 0 ; // not indicated
    }

    Switch_HDMITX_Bank(0);
    uc = HDMITX_ReadI2C_Byte(REG_TX_GCP);
    uc &= ~B_COLOR_DEPTH_MASK ;
    uc |= bColorDepth&B_COLOR_DEPTH_MASK;
    HDMITX_WriteI2C_Byte(REG_TX_GCP,uc);
}

static void SetupAFE(VIDEOPCLKLEVEL level)
{
    BYTE uc ;
    HDMITX_WriteI2C_Byte(REG_TX_AFE_DRV_CTRL,B_AFE_DRV_RST);/* 0x10 */

    switch(level)
    {
    case PCLK_HIGH:
        HDMITX_WriteI2C_Byte(REG_TX_AFE_XP_CTRL,0x88); // reg62
        HDMITX_WriteI2C_Byte(REG_TX_AFE_ISW_CTRL, 0x10); // reg63
        HDMITX_WriteI2C_Byte(REG_TX_AFE_IP_CTRL,0x84); // reg64
        break ;
    default:
        HDMITX_WriteI2C_Byte(REG_TX_AFE_XP_CTRL,0x18); // reg62
        HDMITX_WriteI2C_Byte(REG_TX_AFE_ISW_CTRL, 0x10); // reg63
        HDMITX_WriteI2C_Byte(REG_TX_AFE_IP_CTRL,0x0C); // reg64
        break ;
    }
}

static void FireAFE()
{
    BYTE reg;
    SoftWareVideoReset();
    Switch_HDMITX_Bank(0) ;
    HDMITX_WriteI2C_Byte(REG_TX_AFE_DRV_CTRL,0);
    Instance[0].bVideoOut=TRUE;
}

static void AutoAdjustAudio(void)
{
    unsigned long SampleFreq,cTMDSClock ;
    unsigned long N ;
    ULONG aCTS=0;
    BYTE fs, uc,LoopCnt=10;
    if(bForceCTS)
    {
        Switch_HDMITX_Bank(0);
        HDMITX_WriteI2C_Byte(0xF8, 0xC3) ;
        HDMITX_WriteI2C_Byte(0xF8, 0xA5) ;
        HDMITX_AndREG_Byte(REG_TX_PKT_SINGLE_CTRL,~B_SW_CTS) ; // D[1] = 0, HW auto count CTS
        HDMITX_WriteI2C_Byte(0xF8, 0xFF) ;
    }

    Switch_HDMITX_Bank(1);
    N = ((unsigned long)HDMITX_ReadI2C_Byte(REGPktAudN2)&0xF) << 16 ;
    N |= ((unsigned long)HDMITX_ReadI2C_Byte(REGPktAudN1)) <<8 ;
    N |= ((unsigned long)HDMITX_ReadI2C_Byte(REGPktAudN0));

    while(LoopCnt--)
    {   ULONG TempCTS=0;
        aCTS = ((unsigned long)HDMITX_ReadI2C_Byte(REGPktAudCTSCnt2)) << 12 ;
        aCTS |= ((unsigned long)HDMITX_ReadI2C_Byte(REGPktAudCTSCnt1)) <<4 ;
        aCTS |= ((unsigned long)HDMITX_ReadI2C_Byte(REGPktAudCTSCnt0)&0xf0)>>4  ;
        if(aCTS==TempCTS)
        {break;}
        TempCTS=aCTS;
    }
    Switch_HDMITX_Bank(0);
    if( aCTS == 0)
    {
        return;
    }

    uc = HDMITX_ReadI2C_Byte(0xc1);

    cTMDSClock = GetInputPclk();//Instance[0].TMDSClock ;

    switch(uc & 0x70)
    {
    case 0x50:
        cTMDSClock *= 5 ;
        cTMDSClock /= 4 ;
        break ;
    case 0x60:
        cTMDSClock *= 3 ;
        cTMDSClock /= 2 ;
    }
    SampleFreq = cTMDSClock/aCTS ;
    SampleFreq *= N ;
    SampleFreq /= 128 ;

    if( SampleFreq>31000L && SampleFreq<=38050L ){fs = AUDFS_32KHz ;}
    else if (SampleFreq < 46550L )  {fs = AUDFS_44p1KHz ;}//46050
    else if (SampleFreq < 68100L )  {fs = AUDFS_48KHz ;}
    else if (SampleFreq < 92100L )  {fs = AUDFS_88p2KHz ;}
    else if (SampleFreq < 136200L ) {fs = AUDFS_96KHz ;}
    else if (SampleFreq < 184200L ) {fs = AUDFS_176p4KHz ;}
    else if (SampleFreq < 240200L ) {fs = AUDFS_192KHz ;}
    else if (SampleFreq < 800000L ) {fs = AUDFS_768KHz ;}
    else
    {
        fs = AUDFS_OTHER;
    }
    if(Instance[0].bAudFs != fs)
    {
        Instance[0].bAudFs=fs;
        SetNCTS(/*Instance[0].TMDSClock, */Instance[0].bAudFs); // set N, CTS by new generated clock.
        //CurrCTS=0;
        return;
    }
    return;
}
BOOL IsAudioChang()
{

    BYTE FreDiff=0,Refaudfreqnum;
    Switch_HDMITX_Bank(0) ;
    Refaudfreqnum=HDMITX_ReadI2C_Byte(0x60);

    if((1<<4)&HDMITX_ReadI2C_Byte(0x5f))
    {
        return FALSE;
    }

    if(LastRefaudfreqnum>Refaudfreqnum)
        {FreDiff=LastRefaudfreqnum-Refaudfreqnum;}
    else
        {FreDiff=Refaudfreqnum-LastRefaudfreqnum;}
    LastRefaudfreqnum=Refaudfreqnum;
    if(2<FreDiff)
    {
        HDMITX_OrREG_Byte(REG_TX_PKT_SINGLE_CTRL,(1<<5));
        HDMITX_AndREG_Byte(REG_TX_AUDIO_CTRL0,0xF0);
        return TRUE;
    }
    else
    {
        return FALSE;
    }

}
void SetupAudioChannel(BOOL EnableAudio_b)
{
    static BOOL AudioOutStatus=FALSE;
    if(EnableAudio_b)
    {
        if(AudioDelayCnt==0)
        {
#ifdef SUPPORT_AUDIO_MONITOR
            if(IsAudioChang())
            {
                AutoAdjustAudio();
#else
                if(AudioOutStatus==FALSE)
                {
                    SetNCTS(Instance[0].bAudFs);
#endif
                    HDMITX_WriteI2C_Byte(REG_TX_AUD_SRCVALID_FLAT,0);
                    HDMITX_OrREG_Byte(REG_TX_PKT_SINGLE_CTRL,(1<<5));
                    HDMITX_WriteI2C_Byte(REG_TX_AUDIO_CTRL0, Instance[0].bAudioChannelEnable);

                    HDMITX_AndREG_Byte(REG_TX_PKT_SINGLE_CTRL,(~0x3C));
                    HDMITX_AndREG_Byte(REG_TX_PKT_SINGLE_CTRL,(~(1<<5)));

#ifndef SUPPORT_AUDIO_MONITOR
                    AudioOutStatus=TRUE;
                }
#endif
            }
        }
        else
        {
            AudioOutStatus=FALSE;
            if(((Instance[0].bAudioChannelEnable & B_AUD_SPDIF)==0)|| // if I2S , ignore the reg5F[5] check.
                (0x20==(HDMITX_ReadI2C_Byte(REG_TX_CLK_STATUS2)&0x30)))
            {
                AudioDelayCnt--;
            }
            else
            {
                AudioDelayCnt=AudioOutDelayCnt;
            }
        }
    }
    else
    {
       // CurrCTS=0;
    }
}

static SYS_STATUS SetNCTS(BYTE Fs)
{
    ULONG n,MCLK,SampleFreq;
    BYTE LoopCnt=255,CTSStableCnt=0;
    ULONG diff;
    ULONG CTS=0,LastCTS=0;
    BOOL HBR_mode;
    BYTE aVIC;
    if(B_HBR & HDMITX_ReadI2C_Byte(REG_TX_AUD_HDAUDIO))
    {
        HBR_mode=TRUE;
    }
    else
    {
        HBR_mode=FALSE;
    }

    Switch_HDMITX_Bank(1);
    aVIC = (HDMITX_ReadI2C_Byte(REG_TX_AVIINFO_DB4)&0x7f);
    Switch_HDMITX_Bank(0);

    if(aVIC)
    {
        switch(Fs)
        {
        case AUDFS_32KHz: n = 4096; break;
        case AUDFS_44p1KHz: n = 6272; break;
        case AUDFS_48KHz: n = 6144; break;
        case AUDFS_88p2KHz: n = 12544; break;
        case AUDFS_96KHz: n = 12288; break;
        case AUDFS_176p4KHz: n = 25088; break;
        case AUDFS_192KHz: n = 24576; break;
        default: n = 6144;
        }
    }
    else
    {
        switch(Fs)
        {
            case AUDFS_32KHz: SampleFreq = 32000L; break;
            case AUDFS_44p1KHz: SampleFreq = 44100L; break;
            case AUDFS_48KHz: SampleFreq = 48000L; break;
            case AUDFS_88p2KHz: SampleFreq = 88200L; break;
            case AUDFS_96KHz: SampleFreq = 96000L; break;
            case AUDFS_176p4KHz: SampleFreq = 176000L; break;
            case AUDFS_192KHz: SampleFreq = 192000L; break;
            default: SampleFreq = 768000L;
        }
        MCLK = SampleFreq * 256 ; // MCLK = fs * 256 ;
        n = MCLK / 2000;
    }

    Switch_HDMITX_Bank(1) ;
    HDMITX_WriteI2C_Byte(REGPktAudN0,(BYTE)((n)&0xFF)) ;
    HDMITX_WriteI2C_Byte(REGPktAudN1,(BYTE)((n>>8)&0xFF)) ;
    HDMITX_WriteI2C_Byte(REGPktAudN2,(BYTE)((n>>16)&0xF)) ;

    if(bForceCTS)
    {
        ULONG SumCTS=0;
        while(LoopCnt--)
        {
            bsp_uDelay(1000*30);
            CTS = ((unsigned long)HDMITX_ReadI2C_Byte(REGPktAudCTSCnt2)) << 12 ;
            CTS |= ((unsigned long)HDMITX_ReadI2C_Byte(REGPktAudCTSCnt1)) <<4 ;
            CTS |= ((unsigned long)HDMITX_ReadI2C_Byte(REGPktAudCTSCnt0)&0xf0)>>4  ;
            if( CTS == 0)
            {
                continue;
            }
            else
            {
                if(LastCTS>CTS )
                    {diff=LastCTS-CTS;}
                else
                    {diff=CTS-LastCTS;}

                LastCTS=CTS;
                if(5>diff)
                {
                    CTSStableCnt++;
                    SumCTS+=CTS;
                }
                else
                {
                    CTSStableCnt=0;
                    SumCTS=0;
                    continue;
                }
                if(CTSStableCnt>=32)
                {
                    LastCTS=(SumCTS>>5);
                    break;
                }
            }
        }
    }
    HDMITX_WriteI2C_Byte(REGPktAudCTS0,(BYTE)((LastCTS)&0xFF)) ;
    HDMITX_WriteI2C_Byte(REGPktAudCTS1,(BYTE)((LastCTS>>8)&0xFF)) ;
    HDMITX_WriteI2C_Byte(REGPktAudCTS2,(BYTE)((LastCTS>>16)&0xF)) ;
    Switch_HDMITX_Bank(0) ;

    HDMITX_WriteI2C_Byte(0xF8, 0xC3) ;
    HDMITX_WriteI2C_Byte(0xF8, 0xA5) ;
    if(bForceCTS)
    {
        HDMITX_OrREG_Byte(REG_TX_PKT_SINGLE_CTRL,B_SW_CTS) ; // D[1] = 0, HW auto count CTS

    }
    else
    {
        HDMITX_AndREG_Byte(REG_TX_PKT_SINGLE_CTRL,~B_SW_CTS) ; // D[1] = 0, HW auto count CTS

    }
    HDMITX_WriteI2C_Byte(0xF8, 0xFF) ;

    if(FALSE==HBR_mode) //LPCM
    {
        BYTE uData;
        Switch_HDMITX_Bank(1);
        HDMITX_WriteI2C_Byte(REG_TX_AUDCHST_CA_FS,0x00|Fs);
        Fs = ~Fs ; // OFS is the one's complement of FS
        uData = (0x0f&HDMITX_ReadI2C_Byte(REG_TX_AUDCHST_OFS_WL));
        HDMITX_WriteI2C_Byte(REG_TX_AUDCHST_OFS_WL,(Fs<<4)|uData);
        Switch_HDMITX_Bank(0);
    }


    return ER_SUCCESS ;
}

static void ClearDDCFIFO()
{
    HDMITX_WriteI2C_Byte(REG_TX_DDC_MASTER_CTRL,B_MASTERDDC|B_MASTERHOST);
    HDMITX_WriteI2C_Byte(REG_TX_DDC_CMD,CMD_FIFO_CLR);
}
/*
static void GenerateDDCSCLK()
{
    HDMITX_WriteI2C_Byte(REG_TX_DDC_MASTER_CTRL,B_MASTERDDC|B_MASTERHOST);
    HDMITX_WriteI2C_Byte(REG_TX_DDC_CMD,CMD_GEN_SCLCLK);
}*/
//////////////////////////////////////////////////////////////////////

static void AbortDDC()
{
    BYTE CPDesire,SWReset,DDCMaster ;
    BYTE uc, timeout, i ;

    SWReset = HDMITX_ReadI2C_Byte(REG_TX_SW_RST);
    CPDesire = HDMITX_ReadI2C_Byte(REG_TX_HDCP_DESIRE);
    DDCMaster = HDMITX_ReadI2C_Byte(REG_TX_DDC_MASTER_CTRL);


    HDMITX_WriteI2C_Byte(REG_TX_HDCP_DESIRE,0x08|(CPDesire&(~B_CPDESIRE)));
    HDMITX_WriteI2C_Byte(REG_TX_SW_RST,SWReset|B_HDCP_RST);
    HDMITX_WriteI2C_Byte(REG_TX_DDC_MASTER_CTRL,B_MASTERDDC|B_MASTERHOST);

    for( i = 0 ; i < 2 ; i++ )
    {
        HDMITX_WriteI2C_Byte(REG_TX_DDC_CMD,CMD_DDC_ABORT);

        for( timeout = 0 ; timeout < 200 ; timeout++ )
        {
            uc = HDMITX_ReadI2C_Byte(REG_TX_DDC_STATUS);
            if (uc&B_DDC_DONE)
            {
                break ; // success
            }

            if( uc & (B_DDC_NOACK|B_DDC_WAITBUS|B_DDC_ARBILOSE) )
            {
                break ;
            }
            bsp_uDelay(1000*1); // delay 1 ms to stable.
        }
    }

    HDMITX_WriteI2C_Byte(REG_TX_SW_RST,SWReset);
    HDMITX_WriteI2C_Byte(REG_TX_HDCP_DESIRE,0x08|CPDesire);
    HDMITX_WriteI2C_Byte(REG_TX_DDC_MASTER_CTRL,DDCMaster);
}

static SYS_STATUS ReadEDID(BYTE *pData,BYTE bSegment,BYTE offset,SHORT Count)
{
    SHORT RemainedCount,ReqCount ;
    BYTE bCurrOffset ;
    SHORT TimeOut ;
    BYTE *pBuff = pData ;
    BYTE ucdata ;

    if(!pData)
    {
        return ER_FAIL ;
    }

    if(HDMITX_ReadI2C_Byte(REG_TX_INT_STAT1) & B_INT_DDC_BUS_HANG)
    {
        AbortDDC();

    }

    ClearDDCFIFO();

    RemainedCount = Count ;
    bCurrOffset = offset ;

    Switch_HDMITX_Bank(0);

    while(RemainedCount > 0)
    {

        ReqCount = (RemainedCount > DDC_FIFO_MAXREQ)?DDC_FIFO_MAXREQ:RemainedCount ;
        HDMITX_WriteI2C_Byte(REG_TX_DDC_MASTER_CTRL,B_MASTERDDC|B_MASTERHOST);
        HDMITX_WriteI2C_Byte(REG_TX_DDC_CMD,CMD_FIFO_CLR);

        for(TimeOut = 0 ; TimeOut < 200 ; TimeOut++)
        {
            ucdata = HDMITX_ReadI2C_Byte(REG_TX_DDC_STATUS);

            if(ucdata&B_DDC_DONE)
            {
                break ;
            }

            if((ucdata & B_DDC_ERROR)||(HDMITX_ReadI2C_Byte(REG_TX_INT_STAT1) & B_INT_DDC_BUS_HANG))
            {
                AbortDDC();
                return ER_FAIL ;
            }
        }

        HDMITX_WriteI2C_Byte(REG_TX_DDC_MASTER_CTRL,B_MASTERDDC|B_MASTERHOST);
        HDMITX_WriteI2C_Byte(REG_TX_DDC_HEADER,DDC_EDID_ADDRESS);
        HDMITX_WriteI2C_Byte(REG_TX_DDC_REQOFF,bCurrOffset);
        HDMITX_WriteI2C_Byte(REG_TX_DDC_REQCOUNT,(BYTE)ReqCount);
        HDMITX_WriteI2C_Byte(REG_TX_DDC_EDIDSEG,bSegment);
        HDMITX_WriteI2C_Byte(REG_TX_DDC_CMD,CMD_EDID_READ);

        bCurrOffset += ReqCount ;
        RemainedCount -= ReqCount ;

        for(TimeOut = 250 ; TimeOut > 0 ; TimeOut --)
        {
            bsp_uDelay(1000*1);
            ucdata = HDMITX_ReadI2C_Byte(REG_TX_DDC_STATUS);
            if(ucdata & B_DDC_DONE)
            {
                break ;
            }

            if(ucdata & B_DDC_ERROR)
            {
                return ER_FAIL ;
            }
        }

        if(TimeOut == 0)
        {
            return ER_FAIL ;
        }

        do
        {
            *(pBuff++) = HDMITX_ReadI2C_Byte(REG_TX_DDC_READFIFO);
            ReqCount -- ;
        }while(ReqCount > 0);

    }

    return ER_SUCCESS ;
}



static void ENABLE_NULL_PKT()
{
    HDMITX_WriteI2C_Byte(REG_TX_NULL_CTRL,B_ENABLE_PKT|B_REPEAT_PKT);
}
/*

static void
ENABLE_ACP_PKT()
{

    HDMITX_WriteI2C_Byte(REG_TX_ACP_CTRL,B_ENABLE_PKT|B_REPEAT_PKT);
}


static void
ENABLE_ISRC1_PKT()
{

    HDMITX_WriteI2C_Byte(REG_TX_ISRC1_CTRL,B_ENABLE_PKT|B_REPEAT_PKT);
}


static void ENABLE_ISRC2_PKT()
{

    HDMITX_WriteI2C_Byte(REG_TX_ISRC2_CTRL,B_ENABLE_PKT|B_REPEAT_PKT);
}
*/

static void ENABLE_AVI_INFOFRM_PKT()
{
    HDMITX_WriteI2C_Byte(REG_TX_AVI_INFOFRM_CTRL,B_ENABLE_PKT|B_REPEAT_PKT);
}


static void ENABLE_AUD_INFOFRM_PKT()
{
    HDMITX_WriteI2C_Byte(REG_TX_AUD_INFOFRM_CTRL,B_ENABLE_PKT|B_REPEAT_PKT);
}


static void DISABLE_NULL_PKT()
{
    HDMITX_WriteI2C_Byte(REG_TX_NULL_CTRL,0);
}


static void DISABLE_ACP_PKT()
{
    HDMITX_WriteI2C_Byte(REG_TX_ACP_CTRL,0);
}


static void DISABLE_ISRC1_PKT()
{
    HDMITX_WriteI2C_Byte(REG_TX_ISRC1_CTRL,0);
}


static void DISABLE_ISRC2_PKT()
{
    HDMITX_WriteI2C_Byte(REG_TX_ISRC2_CTRL,0);
}


static void DISABLE_AVI_INFOFRM_PKT()
{
    HDMITX_WriteI2C_Byte(REG_TX_AVI_INFOFRM_CTRL,0);
}


static void DISABLE_AUD_INFOFRM_PKT()
{
	HDMITX_WriteI2C_Byte(REG_TX_AUD_INFOFRM_CTRL,0);
}


static void DISABLE_SPD_INFOFRM_PKT()
{
    HDMITX_WriteI2C_Byte(REG_TX_SPD_INFOFRM_CTRL,0);
}


static void DISABLE_MPG_INFOFRM_PKT()
{
    HDMITX_WriteI2C_Byte(REG_TX_MPG_INFOFRM_CTRL,0);
}

static SYS_STATUS SetAVIInfoFrame(AVI_InfoFrame *pAVIInfoFrame)
{
    int i ;
    byte ucData ;

    if(!pAVIInfoFrame)
    {
        return ER_FAIL ;
    }

    Switch_HDMITX_Bank(1);
    HDMITX_WriteI2C_Byte(REG_TX_AVIINFO_DB1,pAVIInfoFrame->pktbyte.AVI_DB[0]);
    HDMITX_WriteI2C_Byte(REG_TX_AVIINFO_DB2,pAVIInfoFrame->pktbyte.AVI_DB[1]);
    HDMITX_WriteI2C_Byte(REG_TX_AVIINFO_DB3,pAVIInfoFrame->pktbyte.AVI_DB[2]);
    HDMITX_WriteI2C_Byte(REG_TX_AVIINFO_DB4,pAVIInfoFrame->pktbyte.AVI_DB[3]);
    HDMITX_WriteI2C_Byte(REG_TX_AVIINFO_DB5,pAVIInfoFrame->pktbyte.AVI_DB[4]);
    HDMITX_WriteI2C_Byte(REG_TX_AVIINFO_DB6,pAVIInfoFrame->pktbyte.AVI_DB[5]);
    HDMITX_WriteI2C_Byte(REG_TX_AVIINFO_DB7,pAVIInfoFrame->pktbyte.AVI_DB[6]);
    HDMITX_WriteI2C_Byte(REG_TX_AVIINFO_DB8,pAVIInfoFrame->pktbyte.AVI_DB[7]);
    HDMITX_WriteI2C_Byte(REG_TX_AVIINFO_DB9,pAVIInfoFrame->pktbyte.AVI_DB[8]);
    HDMITX_WriteI2C_Byte(REG_TX_AVIINFO_DB10,pAVIInfoFrame->pktbyte.AVI_DB[9]);
    HDMITX_WriteI2C_Byte(REG_TX_AVIINFO_DB11,pAVIInfoFrame->pktbyte.AVI_DB[10]);
    HDMITX_WriteI2C_Byte(REG_TX_AVIINFO_DB12,pAVIInfoFrame->pktbyte.AVI_DB[11]);
    HDMITX_WriteI2C_Byte(REG_TX_AVIINFO_DB13,pAVIInfoFrame->pktbyte.AVI_DB[12]);
    for(i = 0,ucData = 0; i < 13 ; i++)
    {
        ucData -= pAVIInfoFrame->pktbyte.AVI_DB[i] ;
    }

    ucData -= 0x80+AVI_INFOFRAME_VER+AVI_INFOFRAME_TYPE+AVI_INFOFRAME_LEN ;
    HDMITX_WriteI2C_Byte(REG_TX_AVIINFO_SUM,ucData);


    Switch_HDMITX_Bank(0);
    ENABLE_AVI_INFOFRM_PKT();
    return ER_SUCCESS ;
}


static SYS_STATUS SetAudioInfoFrame(Audio_InfoFrame *pAudioInfoFrame)
{
    BYTE uc ;

    if(!pAudioInfoFrame)
    {
        return ER_FAIL ;
    }

    Switch_HDMITX_Bank(1);
    uc = 0x80-(AUDIO_INFOFRAME_VER+AUDIO_INFOFRAME_TYPE+AUDIO_INFOFRAME_LEN );
    HDMITX_WriteI2C_Byte(REG_TX_PKT_AUDINFO_CC,pAudioInfoFrame->pktbyte.AUD_DB[0]);
    uc -= HDMITX_ReadI2C_Byte(REG_TX_PKT_AUDINFO_CC); uc &= 0xFF ;
    HDMITX_WriteI2C_Byte(REG_TX_PKT_AUDINFO_SF,pAudioInfoFrame->pktbyte.AUD_DB[1]);
    uc -= HDMITX_ReadI2C_Byte(REG_TX_PKT_AUDINFO_SF); uc &= 0xFF ;
    HDMITX_WriteI2C_Byte(REG_TX_PKT_AUDINFO_CA,pAudioInfoFrame->pktbyte.AUD_DB[3]);
    uc -= HDMITX_ReadI2C_Byte(REG_TX_PKT_AUDINFO_CA); uc &= 0xFF ;

    HDMITX_WriteI2C_Byte(REG_TX_PKT_AUDINFO_DM_LSV,pAudioInfoFrame->pktbyte.AUD_DB[4]);
    uc -= HDMITX_ReadI2C_Byte(REG_TX_PKT_AUDINFO_DM_LSV); uc &= 0xFF ;

    HDMITX_WriteI2C_Byte(REG_TX_PKT_AUDINFO_SUM,uc);


    Switch_HDMITX_Bank(0);
    ENABLE_AUD_INFOFRM_PKT();
    return ER_SUCCESS ;
}

/////////////////////////////////////////////////////////////////////////////////////
// IT626X part
/////////////////////////////////////////////////////////////////////////////////////
void setIT626X_ChStat(BYTE ucIEC60958ChStat[]);
void setIT626X_UpdateChStatFs(ULONG Fs);
void setIT626X_LPCMAudio(BYTE AudioSrcNum, BYTE AudSWL, BOOL bSPDIF);
void setIT626X_NLPCMAudio();
void setIT626X_HBRAudio(BOOL bSPDIF);
void setIT626X_DSDAudio();


void setIT626X_ChStat(BYTE ucIEC60958ChStat[])
{
    BYTE uc ;

    Switch_HDMITX_Bank(1);
    uc = (ucIEC60958ChStat[0] <<1)& 0x7C ;
    HDMITX_WriteI2C_Byte(REG_TX_AUDCHST_MODE,uc);
    HDMITX_WriteI2C_Byte(REG_TX_AUDCHST_CAT,ucIEC60958ChStat[1]); // 192, audio CATEGORY
    HDMITX_WriteI2C_Byte(REG_TX_AUDCHST_SRCNUM,ucIEC60958ChStat[2]&0xF);
    HDMITX_WriteI2C_Byte(REG_TX_AUD0CHST_CHTNUM,(ucIEC60958ChStat[2]>>4)&0xF);
    HDMITX_WriteI2C_Byte(REG_TX_AUDCHST_CA_FS,ucIEC60958ChStat[3]); // choose clock
    HDMITX_WriteI2C_Byte(REG_TX_AUDCHST_OFS_WL,ucIEC60958ChStat[4]);
    Switch_HDMITX_Bank(0);
}

void setIT626X_UpdateChStatFs(ULONG Fs)
{
    BYTE uc ;

    Switch_HDMITX_Bank(1);
    uc = HDMITX_ReadI2C_Byte(REG_TX_AUDCHST_CA_FS); // choose clock
    HDMITX_WriteI2C_Byte(REG_TX_AUDCHST_CA_FS,uc); // choose clock
    uc &= 0xF0 ;
    uc |= (Fs&0xF);

    uc = HDMITX_ReadI2C_Byte(REG_TX_AUDCHST_OFS_WL);
    uc &= 0xF ;
    uc |= ((~Fs) << 4)&0xF0 ;
    HDMITX_WriteI2C_Byte(REG_TX_AUDCHST_OFS_WL,uc);

    Switch_HDMITX_Bank(0);
}

void setIT626X_LPCMAudio(BYTE AudioSrcNum, BYTE AudSWL, BOOL bSPDIF)
{

    BYTE AudioEnable, AudioFormat ;

    AudioEnable = 0 ;
    AudioFormat = Instance[0].bOutputAudioMode ;


    switch(AudSWL)
    {
    case 16:
        AudioEnable |= M_AUD_16BIT ;
        break ;
    case 18:
        AudioEnable |= M_AUD_18BIT ;
        break ;
    case 20:
        AudioEnable |= M_AUD_20BIT ;
        break ;
    case 24:
    default:
        AudioEnable |= M_AUD_24BIT ;
        break ;
    }

    if( bSPDIF )
    {
        AudioFormat &= ~0x40 ;
        AudioEnable |= B_AUD_SPDIF|B_AUD_EN_I2S0 ;
    }
    else
    {
        AudioFormat |= 0x40 ;
        switch(AudioSrcNum)
        {
        case 4:
            AudioEnable |= B_AUD_EN_I2S3|B_AUD_EN_I2S2|B_AUD_EN_I2S1|B_AUD_EN_I2S0 ;
            break ;

        case 3:
            AudioEnable |= B_AUD_EN_I2S2|B_AUD_EN_I2S1|B_AUD_EN_I2S0 ;
            break ;

        case 2:
            AudioEnable |= B_AUD_EN_I2S1|B_AUD_EN_I2S0 ;
            break ;

        case 1:
        default:
            AudioFormat &= ~0x40 ;
            AudioEnable |= B_AUD_EN_I2S0 ;
            break ;

        }
    }
    AudioFormat|=0x01;
    Instance[0].bAudioChannelEnable=AudioEnable;

    Switch_HDMITX_Bank(0);
    HDMITX_WriteI2C_Byte(REG_TX_AUDIO_CTRL0,AudioEnable&0xF0);

    HDMITX_WriteI2C_Byte(REG_TX_AUDIO_CTRL1,AudioFormat); // regE1 bOutputAudioMode should be loaded from ROM image.
    HDMITX_WriteI2C_Byte(REG_TX_AUDIO_FIFOMAP,0xE4); // default mapping.
#ifdef USE_SPDIF_CHSTAT
    if( bSPDIF )
    {
        HDMITX_WriteI2C_Byte(REG_TX_AUDIO_CTRL3,B_CHSTSEL);
    }
    else
    {
        HDMITX_WriteI2C_Byte(REG_TX_AUDIO_CTRL3,0);
    }
#else // not USE_SPDIF_CHSTAT
    HDMITX_WriteI2C_Byte(REG_TX_AUDIO_CTRL3,0);
#endif // USE_SPDIF_CHSTAT

    HDMITX_WriteI2C_Byte(REG_TX_AUD_SRCVALID_FLAT,0x00);
    HDMITX_WriteI2C_Byte(REG_TX_AUD_HDAUDIO,0x00); // regE5 = 0 ;

    if( bSPDIF )
    {
        BYTE i ;
        HDMI_OrREG_TX_Byte(0x5c,(1<<6));
        for( i = 0 ; i < 100 ; i++ )
        {
            if(HDMITX_ReadI2C_Byte(REG_TX_CLK_STATUS2) & B_OSF_LOCK)
            {
                break ; // stable clock.
            }
        }
    }
}

void setIT626X_NLPCMAudio()
{
    BYTE AudioEnable, AudioFormat ;
    BYTE i ;

    AudioFormat = 0x01 ; // NLPCM must use standard I2S mode.
    AudioEnable = M_AUD_24BIT|B_AUD_SPDIF|B_AUD_EN_I2S0 ;

    Switch_HDMITX_Bank(0);
    HDMITX_WriteI2C_Byte(REG_TX_AUDIO_CTRL0, M_AUD_24BIT|B_AUD_SPDIF);


    HDMITX_WriteI2C_Byte(REG_TX_AUDIO_CTRL1,0x01); // regE1 bOutputAudioMode should be loaded from ROM image.
    HDMITX_WriteI2C_Byte(REG_TX_AUDIO_FIFOMAP,0xE4); // default mapping.

#ifdef USE_SPDIF_CHSTAT
    HDMITX_WriteI2C_Byte(REG_TX_AUDIO_CTRL3,B_CHSTSEL);
#else // not USE_SPDIF_CHSTAT
    HDMITX_WriteI2C_Byte(REG_TX_AUDIO_CTRL3,0);
#endif // USE_SPDIF_CHSTAT

    HDMITX_WriteI2C_Byte(REG_TX_AUD_SRCVALID_FLAT,0x00);
    HDMITX_WriteI2C_Byte(REG_TX_AUD_HDAUDIO,0x00); // regE5 = 0 ;

    for( i = 0 ; i < 100 ; i++ )
    {
        if(HDMITX_ReadI2C_Byte(REG_TX_CLK_STATUS2) & B_OSF_LOCK)
        {
            break ; // stable clock.
        }
    }
    HDMITX_WriteI2C_Byte(REG_TX_AUDIO_CTRL0, M_AUD_24BIT|B_AUD_SPDIF|B_AUD_EN_I2S0);
}

void setIT626X_HBRAudio(BOOL bSPDIF)
{
    BYTE rst,uc ;
    Switch_HDMITX_Bank(0);

    rst = HDMITX_ReadI2C_Byte(REG_TX_SW_RST);

    HDMITX_WriteI2C_Byte(REG_TX_AUDIO_CTRL1,0x47); // regE1 bOutputAudioMode should be loaded from ROM image.
    HDMITX_WriteI2C_Byte(REG_TX_AUDIO_FIFOMAP,0xE4); // default mapping.

    if( bSPDIF )
    {
        HDMITX_WriteI2C_Byte(REG_TX_AUDIO_CTRL0, M_AUD_24BIT|B_AUD_SPDIF);
        HDMITX_WriteI2C_Byte(REG_TX_AUDIO_CTRL3,B_CHSTSEL);
    }
    else
    {
        HDMITX_WriteI2C_Byte(REG_TX_AUDIO_CTRL0, M_AUD_24BIT);
        HDMITX_WriteI2C_Byte(REG_TX_AUDIO_CTRL3,0);
    }

    HDMITX_WriteI2C_Byte(REG_TX_AUD_SRCVALID_FLAT,0x08);
    HDMITX_WriteI2C_Byte(REG_TX_AUD_HDAUDIO,B_HBR); // regE5 = 0 ;
    uc = HDMITX_ReadI2C_Byte(REG_TX_CLK_CTRL1);
    uc &= ~M_AUD_DIV ;
    HDMITX_WriteI2C_Byte(REG_TX_CLK_CTRL1, uc);

    if( bSPDIF )
    {
        BYTE i ;
        for( i = 0 ; i < 100 ; i++ )
        {
            if(HDMITX_ReadI2C_Byte(REG_TX_CLK_STATUS2) & B_OSF_LOCK)
            {
                break ; // stable clock.
            }
        }
        HDMITX_WriteI2C_Byte(REG_TX_AUDIO_CTRL0, M_AUD_24BIT|B_AUD_SPDIF|B_AUD_EN_SPDIF);
    }
    else
    {
        HDMITX_WriteI2C_Byte(REG_TX_AUDIO_CTRL0, M_AUD_24BIT|B_AUD_EN_I2S3|B_AUD_EN_I2S2|B_AUD_EN_I2S1|B_AUD_EN_I2S0);
    }
    HDMI_AndREG_TX_Byte(0x5c,~(1<<6));
    Instance[0].bAudioChannelEnable=HDMITX_ReadI2C_Byte(REG_TX_AUDIO_CTRL0);
}

void setIT626X_DSDAudio()
{
    // to be continue
    BYTE rst, uc ;
    rst = HDMITX_ReadI2C_Byte(REG_TX_SW_RST);

    HDMITX_WriteI2C_Byte(REG_TX_AUDIO_CTRL1,0x41); // regE1 bOutputAudioMode should be loaded from ROM image.
    HDMITX_WriteI2C_Byte(REG_TX_AUDIO_FIFOMAP,0xE4); // default mapping.

    HDMITX_WriteI2C_Byte(REG_TX_AUDIO_CTRL0, M_AUD_24BIT);
    HDMITX_WriteI2C_Byte(REG_TX_AUDIO_CTRL3,0);

    HDMITX_WriteI2C_Byte(REG_TX_AUD_SRCVALID_FLAT,0x00);
    HDMITX_WriteI2C_Byte(REG_TX_AUD_HDAUDIO,B_DSD); // regE5 = 0 ;

    uc = HDMITX_ReadI2C_Byte(REG_TX_CLK_CTRL1);
    uc &= ~M_AUD_DIV ;
    HDMITX_WriteI2C_Byte(REG_TX_CLK_CTRL1, uc);



    HDMITX_WriteI2C_Byte(REG_TX_AUDIO_CTRL0, M_AUD_24BIT|B_AUD_EN_I2S3|B_AUD_EN_I2S2|B_AUD_EN_I2S1|B_AUD_EN_I2S0);
}

void EnableHDMIAudio(BYTE AudioType, BOOL bSPDIF,  ULONG SampleFreq,  BYTE ChNum, BYTE *pIEC60958ChStat, ULONG TMDSClock)
{
    static _IDATA BYTE ucIEC60958ChStat[5] ;
    BYTE Fs ;
    Instance[0].TMDSClock=TMDSClock;
    Instance[0].bAudioChannelEnable=0;
    Instance[0].bSPDIF_OUT=bSPDIF;
    HDMITX_WriteI2C_Byte(REG_TX_CLK_CTRL0,B_AUTO_OVER_SAMPLING_CLOCK|B_EXT_256FS|0x01);
    if(bSPDIF)
    {
        if(AudioType==T_AUDIO_HBR)
        {
            HDMITX_WriteI2C_Byte(REG_TX_CLK_CTRL0,0x81);
        }
        HDMITX_OrREG_Byte(REG_TX_AUDIO_CTRL0,B_AUD_SPDIF);
    }
    else
    {
        HDMITX_AndREG_Byte(REG_TX_AUDIO_CTRL0,(~B_AUD_SPDIF));
    }

    if( AudioType != T_AUDIO_DSD)
    {
        // one bit audio have no channel status.
        switch(SampleFreq)
        {
        case  44100L: Fs =  AUDFS_44p1KHz ; break ;
        case  88200L: Fs =  AUDFS_88p2KHz ; break ;
        case 176400L: Fs = AUDFS_176p4KHz ; break ;
        case  32000L: Fs =    AUDFS_32KHz ; break ;
        case  48000L: Fs =    AUDFS_48KHz ; break ;
        case  96000L: Fs =    AUDFS_96KHz ; break ;
        case 192000L: Fs =   AUDFS_192KHz ; break ;
        case 768000L: Fs =   AUDFS_768KHz ; break ;
        default:
            SampleFreq = 48000L ;
            Fs =    AUDFS_48KHz ;
            break ; // default, set Fs = 48KHz.
        }

#ifdef SUPPORT_AUDIO_MONITOR
    Instance[0].bAudFs=AUDFS_OTHER;
#else
    Instance[0].bAudFs=Fs;
#endif

        if( pIEC60958ChStat == NULL )
        {
            ucIEC60958ChStat[0] = 0 ;
            ucIEC60958ChStat[1] = 0 ;
            ucIEC60958ChStat[2] = (ChNum+1)/2 ;

            if(ucIEC60958ChStat[2]<1)
            {
                ucIEC60958ChStat[2] = 1 ;
            }
            else if( ucIEC60958ChStat[2] >4 )
            {
                ucIEC60958ChStat[2] = 4 ;
            }

            ucIEC60958ChStat[3] = Fs ;
#if(SUPPORT_AUDI_AudSWL==16)
            ucIEC60958ChStat[4] = (((~Fs)<<4) & 0xF0) | 0x02 ; // Fs | 24bit word length
#elif(SUPPORT_AUDI_AudSWL==18)
            ucIEC60958ChStat[4] = (((~Fs)<<4) & 0xF0) | 0x04 ; // Fs | 24bit word length
#elif(SUPPORT_AUDI_AudSWL==20)
            ucIEC60958ChStat[4] = (((~Fs)<<4) & 0xF0) | 0x03 ; // Fs | 24bit word length
#else
            ucIEC60958ChStat[4] = (((~Fs)<<4) & 0xF0) | 0x0B ; // Fs | 24bit word length
#endif
            pIEC60958ChStat = ucIEC60958ChStat ;
        }
    }

    switch(AudioType)
    {
    case T_AUDIO_HBR:
        pIEC60958ChStat[0] |= 1<<1 ;
        pIEC60958ChStat[2] = 0;
        pIEC60958ChStat[3] &= 0xF0 ;
        pIEC60958ChStat[3] |= AUDFS_768KHz ;
        pIEC60958ChStat[4] |= (((~AUDFS_768KHz)<<4) & 0xF0)| 0xB ;
        setIT626X_ChStat(pIEC60958ChStat);
        setIT626X_HBRAudio(bSPDIF);

        break ;
    case T_AUDIO_DSD:
        setIT626X_DSDAudio();
        break ;
    case T_AUDIO_NLPCM:
        pIEC60958ChStat[0] |= 1<<1 ;
        setIT626X_ChStat(pIEC60958ChStat);
        setIT626X_NLPCMAudio();
        break ;
    case T_AUDIO_LPCM:
        pIEC60958ChStat[0] &= ~(1<<1);

        setIT626X_ChStat(pIEC60958ChStat);
        setIT626X_LPCMAudio((ChNum+1)/2, /*24*/SUPPORT_AUDI_AudSWL, bSPDIF);
        // can add auto adjust
        break ;
    }
    HDMITX_AndREG_Byte(REG_TX_INT_MASK1,(~B_AUDIO_OVFLW_MASK));
    HDMITX_AndREG_Byte(REG_TX_SW_RST,~(B_AUD_RST|B_AREF_RST));
}
void SoftWareVideoReset(void)
{
    BYTE ResetCount;
    BYTE intclr = 0;

    ResetCount=5;
    I2C_OrReg_Byte(REG_TX_SW_RST, B_VID_RST);     //add 20080702  hermes
    bsp_uDelay(1000*1);
    I2C_AndReg_Byte(REG_TX_SW_RST,~(B_VID_RST));
    while(0 == (HDMITX_ReadI2C_Byte(REG_TX_SYS_STATUS) & B_TXVIDSTABLE) )
    {
        bsp_uDelay(1000*100);
        ResetCount--;
        if(ResetCount==0)break;
    }

    I2C_OrReg_Byte(REG_TX_INT_CLR1, B_CLR_VIDSTABLE) ;
    intclr |= (HDMITX_ReadI2C_Byte(REG_TX_SYS_STATUS)&(~B_CLR_AUD_CTS))| B_INTACTDONE ;
    HDMITX_WriteI2C_Byte(REG_TX_SYS_STATUS,intclr) ;
    intclr &= ~B_INTACTDONE ;
    HDMITX_WriteI2C_Byte(REG_TX_SYS_STATUS,intclr) ; // INTACTDONE reset to zero.

}
BOOL GetVideoStatus(void)
{
    if(HDMITX_ReadI2C_Byte(REG_TX_SYS_STATUS)&B_TXVIDSTABLE)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
void UpDateAFE(ULONG PixelClock)
{
    BYTE uc,level;
    unsigned long cTMDSClock = PixelClock;//*(pixelrep+1);
    uc = HDMITX_ReadI2C_Byte(0xc1);
    switch(uc & 0x70)
    {
    case 0x50:
        cTMDSClock *= 5 ;
        cTMDSClock /= 4 ;
        break ;
    case 0x60:
        cTMDSClock *= 3 ;
        cTMDSClock /= 2 ;
    }

    if( cTMDSClock>80000000L )
    {
        level = PCLK_HIGH ;
    }
    else if(cTMDSClock>20000000L)
    {
        level = PCLK_MEDIUM ;
    }
    else
    {
        level = PCLK_LOW ;
    }
    SetupAFE(level);
    //FireAFE();
}
void EnableDeOnly(BOOL DeOnly)
{
    if(DeOnly)
    {
        EnableHVToolDetect(FALSE);
        HDMITX_OrREG_Byte(0xa5,(1<<5));
        ReGenTimingEnable=TRUE;
    }
    else
    {
        EnableHVToolDetect(TRUE);
        HDMITX_AndREG_Byte(0xa5,~(1<<5));
        ReGenTimingEnable=FALSE;
    }
}
void EnableHVToolDetect(BOOL HVenable)
{
    if(HVenable)
        HDMITX_OrREG_Byte(0xa8,(1<<3));
    else
        HDMITX_AndREG_Byte(0xa8,~(1<<3));
}
UINT GetHTotal(void)
{
    return (((WORD)HDMITX_ReadI2C_Byte(0x91))<<4)+((WORD)(HDMITX_ReadI2C_Byte(0x90)>>4))+1;
}
UINT GetHActive(void)
{
	UINT out;

	out =((((WORD)(HDMITX_ReadI2C_Byte(0x94)&0xf0))<<4)+((WORD)HDMITX_ReadI2C_Byte(0x93)))
		-((((WORD)(HDMITX_ReadI2C_Byte(0x94)&0x0f))<<8)+((WORD)HDMITX_ReadI2C_Byte(0x92)));

	if(out>0)
	{
		return	out;
	}
	else
	{
		return (out*(-1));
	}
}
UINT GetHBlank(void)
{
    return (GetHTotal()-GetHActive());
}

UINT GetVTotal(void)
{
    return ((WORD)(HDMITX_ReadI2C_Byte(0x99)&0x07)<<8)+((WORD)HDMITX_ReadI2C_Byte(0x98))+1;
}
UINT GetVActive(void)
{
	UINT out;

	out =((((WORD)(HDMITX_ReadI2C_Byte(0x9C)&0x70))<<4)+((WORD)HDMITX_ReadI2C_Byte(0x9B)))
		-((((WORD)(HDMITX_ReadI2C_Byte(0x9C)&0x07))<<8)+((WORD)HDMITX_ReadI2C_Byte(0x9A)));

	if(out>0)
	{
		return	out;
	}
	else
	{
		return (out*(-1));
	}
}
UINT GetVBlank(void)
{
    return (GetVTotal()-GetVActive());
}

void CheckAudioVideoInput()
{
    BYTE LVDS_Lock;
    BYTE NoAudio_flag,AudioOFF_flag;

    LVDS_Lock = (0x03&LVDS_ReadI2C_Byte(0x30));
    NoAudio_flag = ((1<<4)&HDMITX_ReadI2C_Byte(0x5f));
    AudioOFF_flag = ((1<<4)&HDMITX_ReadI2C_Byte(0xc5));
    if(0x03!=LVDS_Lock)
    {
        DisableAudioOutput();
    }
    if(NoAudio_flag!=AudioOFF_flag)
    {
        HDMITX_WriteI2C_Byte(0xc5,(((0xEF)&HDMITX_ReadI2C_Byte(0xc5))|NoAudio_flag));
    }
}

void hdmi_init(void)
{
	InitIT626X_Instance();

	InitIT626X();

	bsp_uDelay(5000);

	HDMITX_ChangeDisplayOption(HDMI_1080p24,HDMI_RGB444);
	VideoModeDetect();

	HDMITX_SetOutput();
	DisableAudioOutput();
}
