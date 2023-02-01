
#include "hdmi_config.h"
#include "hdmi_driver.h"
#include "typedef.h"

#define INPUT_SIGNAL_TYPE 0 // 24 bit sync seperate

#define I2S 0
#define SPDIF 1
_IDATA INSTANCE InstanceData =
{
    0,      // BYTE I2C_DEV ;
    0x98,    // BYTE I2C_ADDR ;

    /////////////////////////////////////////////////
    // Interrupt Type
    /////////////////////////////////////////////////
    0x40,
    /////////////////////////////////////////////////
    // Video Property
    /////////////////////////////////////////////////
    INPUT_SIGNAL_TYPE ,

    /////////////////////////////////////////////////
    // Audio Property
    /////////////////////////////////////////////////
    I2S, 			// BYTE bOutputAudioMode ; // = 0 ;
    FALSE , 		// BYTE bAudioChannelSwap ; // = 0 ;
    0x01, 			// BYTE bAudioChannelEnable ;
    AUDFS_48KHz ,	// BYTE bAudFs ;
    0, 				// unsigned long TMDSClock ;
    FALSE, 			// BYTE bAuthenticated:1 ;
    FALSE, 			// BYTE bHDMIMode: 1;
    FALSE, 			// BYTE bIntPOL:1 ; // 0 = Low Active
    FALSE, 			// BYTE bHPD:1 ;

};

////////////////////////////////////////////////////////////////////////////////
// EDID
////////////////////////////////////////////////////////////////////////////////

BOOL bChangeMode = FALSE ;
BOOL bForceCTS = FALSE;
_IDATA AVI_InfoFrame AviInfo;
_IDATA Audio_InfoFrame AudioInfo ;
_IDATA USHORT LastInputPclk;
_IDATA VendorSpecific_InfoFrame VS_Info;


void ConfigAVIInfoFrame(BYTE VIC, BYTE pixelrep);
void ConfigAudioInfoFrm();
_XDATA volatile BYTE cBuf[128] ;

_IDATA BYTE bInputColorMode = F_MODE_RGB444;
// _IDATA BYTE bInputColorMode = F_MODE_YUV422 ;
// _IDATA BYTE bInputColorMode = F_MODE_YUV444 ;
_IDATA BYTE OutputColorDepth = 24 ;
// _IDATA BYTE bOutputColorMode = F_MODE_YUV422 ;
// _IDATA BYTE bOutputColorMode = F_MODE_YUV444 ;
_IDATA BYTE bOutputColorMode = F_MODE_RGB444 ;

_IDATA BYTE iVideoModeSelect=0 ;

_IDATA ULONG VideoPixelClock ;
_IDATA BYTE VIC ; // 480p60
_IDATA BYTE HDMI3DFormat = 0xFF ; // 3D Format
_IDATA BYTE pixelrep ; // no pixelrepeating
_IDATA HDMI_Aspec aspec ;
_IDATA HDMI_Colorimetry Colorimetry ;

_IDATA BYTE bAudioSampleFreq = INPUT_SAMPLE_FREQ ;
BOOL bHDMIMode, bAudioEnable ;
BOOL ReGenTimingEnable=FALSE;




void InitIT626X_Instance();
void HDMITX_ChangeDisplayOption(HDMI_Video_Type VideoMode, HDMI_OutputColorMode OutputColorMode);
void HDMITX_SetOutput();

_IDATA BYTE HPDStatus = FALSE;
_IDATA BYTE HPDChangeStatus = FALSE;

BOOL AudeoModeDetect(void)
{
    SetupAudioChannel(bAudioEnable);
    return  TRUE;
}
BOOL VideoModeDetect(void)
{
    static BOOL ForceUpdate=TRUE;

    if(CheckLVDS()==FALSE)
    {
        ForceUpdate=TRUE;
        return FALSE;
    }


    if(ForceUpdate)
    {

	    VIC = HDMI_Unknown ; // turn off Regentiming at first.
        ForceUpdate=FALSE;

		VIC = HDMITX_DetectVIC() ;
        HDMITX_ChangeDisplayOption(VIC,HDMI_RGB444);

    }
    return TRUE;
}

void InitIT626X_Instance()
{
    HDMITX_InitInstance(&InstanceData);
	HPDStatus = FALSE;
	HPDChangeStatus = FALSE;
}

void HDMITX_SetOutput()
{
    BYTE uc;
    BYTE level ;
    unsigned long cTMDSClock = VideoPixelClock*(pixelrep+1);
    DisableAudioOutput();
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

	SetOutputColorDepthPhase(OutputColorDepth,0);
	SetupVideoInputSignal(InstanceData.bInputVideoSignalType);
	EnableVideoOutput(level,F_MODE_RGB444,F_MODE_RGB444 ,(BYTE)bHDMIMode);
    if( bHDMIMode )
    {
        ConfigAVIInfoFrame(VIC, pixelrep);

        ConfigfHdmiVendorSpecificInfoFrame(HDMI3DFormat);
/*		if( bAudioEnable )
		{
#ifdef SUPPORT_HBR_AUDIO
            EnableHDMIAudio(T_AUDIO_HBR, FALSE, 768000L,OUTPUT_CHANNEL,NULL,cTMDSClock);
#else

        #ifdef SUPPORT_I2S_AUDIO
            EnableHDMIAudio(T_AUDIO_LPCM, FALSE, INPUT_AUDIO_SAMPLE_FREQ,OUTPUT_CHANNEL,NULL,cTMDSClock);
        #else
            EnableHDMIAudio(T_AUDIO_LPCM, TRUE, INPUT_AUDIO_SAMPLE_FREQ,OUTPUT_CHANNEL,NULL,cTMDSClock);
        #endif
#endif
            ConfigAudioInfoFrm();
		}*/

        SetAVMute(FALSE);

    }
	else
	{
		EnableAVIInfoFrame(FALSE ,NULL);
        EnableVSInfoFrame(FALSE,NULL);
        SetAVMute(FALSE);
	}
    bChangeMode = FALSE ;

}


void MuteUpdata()
{
    if(GetAVMute())
    {
        if(GetVideoStatus())
        {
            HDMITX_AndREG_Byte(0x04,~(0x14));
            SetAVMute(FALSE);
        }
    }
}

void HDMITX_ChangeDisplayOption(HDMI_Video_Type OutputVideoTiming, HDMI_OutputColorMode OutputColorMode)
{
   HDMI3DFormat = 0xFF ;
    switch(OutputVideoTiming)
	{
    case HDMI_640x480p60:
        VIC = 1 ;
        VideoPixelClock = 25000000L ;
        pixelrep = 0 ;
        aspec = HDMI_4x3 ;
        Colorimetry = HDMI_ITU601 ;
        break ;
    case HDMI_480p60:
        VIC = 2 ;
        VideoPixelClock = 27000000L ;
        pixelrep = 0 ;
        aspec = HDMI_4x3 ;
        Colorimetry = HDMI_ITU601 ;
        break ;
    case HDMI_480p60_16x9:
        VIC = 3 ;
        VideoPixelClock = 27000000L ;
        pixelrep = 0 ;
        aspec = HDMI_16x9 ;
        Colorimetry = HDMI_ITU601 ;
        break ;
    case HDMI_720p60:
        VIC = 4 ;
        VideoPixelClock = 74250000L ;
        pixelrep = 0 ;
        aspec = HDMI_16x9 ;
        Colorimetry = HDMI_ITU709 ;
        break ;
    case HDMI_720p60_FP3D:
        VIC = 4 ;
        VideoPixelClock = 148500000L ;
        pixelrep = 0 ;
        aspec = HDMI_16x9 ;
        Colorimetry = HDMI_ITU709 ;
        HDMI3DFormat = Frame_Packing;
        break ;
    case HDMI_1080i60:
        VIC = 5 ;
        VideoPixelClock = 74250000L ;
        pixelrep = 0 ;
        aspec = HDMI_16x9 ;
        Colorimetry = HDMI_ITU709 ;
        break ;
    case HDMI_480i60:
        VIC = 6 ;
        VideoPixelClock = 13500000L ;
        pixelrep = 1 ;
        aspec = HDMI_4x3 ;
        Colorimetry = HDMI_ITU601 ;
        break ;
    case HDMI_480i60_16x9:
        VIC = 7 ;
        VideoPixelClock = 13500000L ;
        pixelrep = 1 ;
        aspec = HDMI_16x9 ;
        Colorimetry = HDMI_ITU601 ;
        break ;
    case HDMI_1080p60:
        VIC = 16 ;
        VideoPixelClock = 148500000L ;
        pixelrep = 0 ;
        aspec = HDMI_16x9 ;
        Colorimetry = HDMI_ITU709 ;
        break ;
    case HDMI_576p50:
        VIC = 17 ;
        VideoPixelClock = 27000000L ;
        pixelrep = 0 ;
        aspec = HDMI_4x3 ;
        Colorimetry = HDMI_ITU601 ;
        break ;
    case HDMI_576p50_16x9:
        VIC = 18 ;
        VideoPixelClock = 27000000L ;
        pixelrep = 0 ;
        aspec = HDMI_16x9 ;
        Colorimetry = HDMI_ITU601 ;
        break ;
    case HDMI_720p50:
        VIC = 19 ;
        VideoPixelClock = 74250000L ;
        pixelrep = 0 ;
        aspec = HDMI_16x9 ;
        Colorimetry = HDMI_ITU709 ;
        break ;
    case HDMI_720p50_FP3D:
        VIC = 19 ;
        VideoPixelClock = 148500000L ;
        pixelrep = 0 ;
        aspec = HDMI_16x9 ;
        Colorimetry = HDMI_ITU709 ;
        HDMI3DFormat = Frame_Packing;
        break ;
    case HDMI_1080i50:
        VIC = 20 ;
        VideoPixelClock = 74250000L ;
        pixelrep = 0 ;
        aspec = HDMI_16x9 ;
        Colorimetry = HDMI_ITU709 ;
        break ;
    case HDMI_576i50:
        VIC = 21 ;
        VideoPixelClock = 13500000L ;
        pixelrep = 1 ;
        aspec = HDMI_4x3 ;
        Colorimetry = HDMI_ITU601 ;
        break ;
    case HDMI_576i50_16x9:
        VIC = 22 ;
        VideoPixelClock = 13500000L ;
        pixelrep = 1 ;
        aspec = HDMI_16x9 ;
        Colorimetry = HDMI_ITU601 ;
        break ;
    case HDMI_1080p50:
        VIC = 31 ;
        VideoPixelClock = 148500000L ;
        pixelrep = 0 ;
        aspec = HDMI_16x9 ;
        Colorimetry = HDMI_ITU709 ;
        break ;
    case HDMI_1080p24:
        VIC = 32 ;
        VideoPixelClock = 74250000L ;
        pixelrep = 0 ;
        aspec = HDMI_16x9 ;
        Colorimetry = HDMI_ITU709 ;
        break ;
    case HDMI_1080p24_FP3D:
        VIC = 32 ;
        VideoPixelClock = 2*74250000L ;
        pixelrep = 0 ;
        aspec = HDMI_16x9 ;
        Colorimetry = HDMI_ITU709 ;
        HDMI3DFormat = Frame_Packing;
        break ;
    case HDMI_1080p25:
        VIC = 33 ;
        VideoPixelClock = 74250000L ;
        pixelrep = 0 ;
        aspec = HDMI_16x9 ;
        Colorimetry = HDMI_ITU709 ;
        break ;
    case HDMI_1080p30:
        VIC = 34 ;
        VideoPixelClock = 74250000L ;
        pixelrep = 0 ;
        aspec = HDMI_16x9 ;
        Colorimetry = HDMI_ITU709 ;
        break ;
    default:
        VIC = 0 ;
        VideoPixelClock = GetInputPclk();
        pixelrep = 0 ;
        aspec = HDMI_4x3 ;
        Colorimetry = HDMI_ITU601 ;
        break ;
        //bChangeMode = FALSE ;
        //return ;
    }
    bOutputColorMode = F_MODE_RGB444 ;

    if( Colorimetry == HDMI_ITU709 )
    {
        bInputColorMode |= F_MODE_ITU709 ;
    }
    else
    {
        bInputColorMode &= ~F_MODE_ITU709 ;
    }

    if( Colorimetry != HDMI_640x480p60)
    {
        bInputColorMode |= F_MODE_16_235 ;
    }
    else
    {
        bInputColorMode &= ~F_MODE_16_235 ;
    }

    bChangeMode = TRUE ;
}


void ConfigAVIInfoFrame(BYTE VIC, BYTE pixelrep)
{

    AviInfo.pktbyte.AVI_HB[0] = AVI_INFOFRAME_TYPE|0x80 ;
    AviInfo.pktbyte.AVI_HB[1] = AVI_INFOFRAME_VER ;
    AviInfo.pktbyte.AVI_HB[2] = AVI_INFOFRAME_LEN ;

    AviInfo.pktbyte.AVI_DB[0] = (0<<5)|(1<<4); // RGB Only

    AviInfo.pktbyte.AVI_DB[1] = 8 ;
    if(VIC )
        AviInfo.pktbyte.AVI_DB[1] |= (aspec != HDMI_16x9)?(1<<4):(2<<4); // 4:3 or 16:9
    else
        AviInfo.pktbyte.AVI_DB[1] &=(0xcf);

    AviInfo.pktbyte.AVI_DB[1] |= (Colorimetry != HDMI_ITU709)?(1<<6):(2<<6); // 4:3 or 16:9
    AviInfo.pktbyte.AVI_DB[2] = 0 ;
    AviInfo.pktbyte.AVI_DB[3] = VIC ;
    AviInfo.pktbyte.AVI_DB[4] =  pixelrep & 3 ;
    AviInfo.pktbyte.AVI_DB[5] = 0 ;
    AviInfo.pktbyte.AVI_DB[6] = 0 ;
    AviInfo.pktbyte.AVI_DB[7] = 0 ;
    AviInfo.pktbyte.AVI_DB[8] = 0 ;
    AviInfo.pktbyte.AVI_DB[9] = 0 ;
    AviInfo.pktbyte.AVI_DB[10] = 0 ;
    AviInfo.pktbyte.AVI_DB[11] = 0 ;
    AviInfo.pktbyte.AVI_DB[12] = 0 ;

    EnableAVIInfoFrame(TRUE, (unsigned char *)&AviInfo);
}


void ConfigfHdmiVendorSpecificInfoFrame(BYTE _3D_Stru)
{
    VS_Info.pktbyte.VS_HB[0] = VENDORSPEC_INFOFRAME_TYPE|0x80;
    VS_Info.pktbyte.VS_HB[1] = VENDORSPEC_INFOFRAME_VER;

    VS_Info.pktbyte.VS_DB[1] = 0x03;
    VS_Info.pktbyte.VS_DB[2] = 0x0C;
    VS_Info.pktbyte.VS_DB[3] = 0x00;
    VS_Info.pktbyte.VS_DB[4] = 0x40;
    switch(_3D_Stru)
    {
    case Side_by_Side:
        VS_Info.pktbyte.VS_HB[2] = 6;
        VS_Info.pktbyte.VS_DB[5] = (_3D_Stru<<4);
        VS_Info.pktbyte.VS_DB[6] = 0x00;
        break;

    case Top_and_Botton:
    case Frame_Packing:
        VS_Info.pktbyte.VS_HB[2] = 5;
        VS_Info.pktbyte.VS_DB[5] = (_3D_Stru<<4);
        break ;
    default:
        EnableVSInfoFrame(FALSE,NULL);
        return;
    }

    EnableVSInfoFrame(TRUE,(BYTE *)&VS_Info);
}

void ConfigAudioInfoFrm()
{
    int i ;
    AudioInfo.pktbyte.AUD_HB[0] = AUDIO_INFOFRAME_TYPE ;
    AudioInfo.pktbyte.AUD_HB[1] = 1 ;
    AudioInfo.pktbyte.AUD_HB[2] = AUDIO_INFOFRAME_LEN ;
    AudioInfo.pktbyte.AUD_DB[0] = 1 ;
    for( i = 1 ;i < AUDIO_INFOFRAME_LEN ; i++ )
    {
        AudioInfo.pktbyte.AUD_DB[i] = 0 ;
    }
    //AudioInfo.pktbyte.AUD_DB[3] = 0x1f ;
    EnableAudioInfoFrame(TRUE, (unsigned char *)&AudioInfo);
}
