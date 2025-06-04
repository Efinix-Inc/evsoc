#include "diskio.h"

extern BYTE interface_selector;
uint8_t 	buffer [20];
static volatile DSTATUS Stat = STA_NOINIT;	/* Physical drive status */

static void deselect(void);
static int xmit_datablock( /* 1:OK, 0:Failed */
const BYTE *buff, /* 512 byte data block to be transmitted */
BYTE token /* Data/Stop token */
);
static int rcvr_datablock( /* 1:OK, 0:Failed */
BYTE *buff, /* Data buffer to store received data */
UINT btr /* Byte count */
);
static int select(void);
static void rcvr_mmc(BYTE *buff, /* Pointer to read buffer */
UINT bc /* Number of bytes to receive */
);
static void xmit_mmc(const BYTE *buff, /* Data to be sent */
UINT bc /* Number of bytes to send */
);
static BYTE spi_send_cmd( /* Returns command response (bit7==1:Send failed)*/
BYTE cmd, /* Command byte */
DWORD arg /* Argument */
);
static void dly_us(UINT n);

/*--------------------------------------------------------------------------

   Public Functions

---------------------------------------------------------------------------*/

static void sd_read_csd(struct mmc *mmc, struct mmc_cmd *cmd)
{
	sd_send_cmd(mmc,cmd,MMC_CMD_SEND_CSD,MMC_RSP_R2,(mmc->rca<<16)); // CMD9 // get card specific data (CSD)
	mmc->csd[0]= cmd->response[0];
	mmc->csd[1]= cmd->response[1];
	mmc->csd[2]= cmd->response[2];
	mmc->csd[3]= cmd->response[3];

	mmc->capacity = (((mmc->csd[1]>>8) &0x3FFFFF)+1)*512;
	mmc->capacity *=1024;
	mmc->tran_speed = multipliers[(mmc->csd[2]>>27) &0x07] * fbase[(mmc->csd[2]>>24) &0x03];

#if(DEBUG_PRINTF_EN == 1)
		bsp_printf("CSD 0x%x 0x%x 0x%x 0x%x\r\n",mmc->csd[0],mmc->csd[1],mmc->csd[2],mmc->csd[3]);
		bsp_printf("FILE_FORMAT = %d\r\n",(mmc->csd[0]>>2) &0x03);		//[11:10]
		bsp_printf("TMP_WRITE_PROTECT = %d\r\n",(mmc->csd[0]>>4) &0x01);//[12]
		bsp_printf("PERM_WRITE_PROTECT = %d\r\n",(mmc->csd[0]>>5) &0x01);//[13]
		bsp_printf("COPY = %d\r\n",(mmc->csd[0]>>6) &0x01);			//[14]
		bsp_printf("FILE_FORMAT_GRP = %d\r\n",(mmc->csd[0]>>7) &0x01);//[15]
		//[20:16]
		bsp_printf("WRITE_BL_PARTIAL = %d\r\n",(mmc->csd[0]>>13) &0x01);//[21]
		bsp_printf("WRITE_BL_LEN = %d\r\n",(mmc->csd[0]>>14) &0x0F);//[25:22]
		bsp_printf("R2W_FACTOR = %d\r\n",(mmc->csd[0]>>18) &0x07);//[28:26]
		//[30:29]
		bsp_printf("WP_GRP_ENABLE = %d\r\n",(mmc->csd[0]>>23) &0x01);//[31]

		bsp_printf("WP_GRP_SIZE = %d\r\n",(mmc->csd[0]>>24) &0x7F);//[38:32]

		bsp_printf("SECTOR_SIZE = %d\r\n",((mmc->csd[1] & 0x3F)<<1)|((mmc->csd[0])>>31 &0x1));//[45:39]
		bsp_printf("ERASE_BLK_EN = %d\r\n",(mmc->csd[1]>>6) &0x01);//[46]
		//[47]
		bsp_printf("C_SIZE = %d\r\n",(mmc->csd[1]>>8) &0x3FFFFF);//[69:48]
		//[75:70]
		bsp_printf("DSR_IMP = %d\r\n",(mmc->csd[2]>>4) &0x01);//[76]
		bsp_printf("READ_BLK_MISAIGN = %d\r\n",(mmc->csd[2]>>5) &0x01);//[77]
		bsp_printf("WRITE_BLK_MISAIGN = %d\r\n",(mmc->csd[2]>>6) &0x01);//[78]
		bsp_printf("READ_BL_PARTIAL = %d\r\n",(mmc->csd[2]>>7) &0x01);//[79]
		bsp_printf("READ_BL_LEN = %d\r\n",(mmc->csd[2]>>8) &0x0F);//[83:80]
		bsp_printf("CCC = %d\r\n",(mmc->csd[2]>>12) &0x0FFF);//[95:84]
		bsp_printf("TRAN_SPEED = 0x%x\r\n",(mmc->csd[2]>>24) &0x0FF);//[103:96]
		bsp_printf("NSAC = 0x%x\r\n",(mmc->csd[3]) &0x0FF);//[111:104]
		bsp_printf("TAAC = 0x%x\r\n",(mmc->csd[3]>>8) &0x0FF);//[119:112]
		//[125:120]
		bsp_printf("TAAC = 0x%x\r\n",(mmc->csd[3]>>22) &0x03);//[127:126]
		bsp_printf("mmc->capacity = %d\r\n",(((mmc->csd[1]>>8) &0x3FFFFF)+1)*512);
		bsp_printf("mmc->tran_speed = %d\r\n",mmc->tran_speed);
#endif //(DEBUG_PRINTF_EN == 1)
}


u32 getdata_fatfs() {
	getdata(&myConfig);
	u8 seconds, minutes, hours, dayOfWeek, days, months, years, timesystem;
	//READ TIME FROM RTC
	seconds   	= get_seconds(&myConfig);
	minutes		= get_minutes(&myConfig);
	if (myConfig.timesystem && myConfig.PM)
		hours = myConfig.hours +12;
	else
		hours = myConfig.hours;
	dayOfWeek	= get_weekdays(&myConfig);
	days		= get_days(&myConfig);
	months 		= get_months(&myConfig);
	years		= get_years(&myConfig);
	seconds = seconds/2;
	years = ((years + 2000) - 1980);

	u32 ret = (((years & 0x7F) << 25) | ((months & 0x0F) << 21)  | ((days & 0x1F) << 16) | ((hours & 0x1F) << 11) |((minutes & 0x3F) << 5) |(seconds & 0x1F));
	return ret;
}

/*-----------------------------------------------------------------------*/
/* Initialize disk drive                                                 */
/*-----------------------------------------------------------------------*/
DSTATUS disk_initialize (
	BYTE drv		/* Physical drive number (0) */
)
{

		u8 busy = 0;
		u32 Value;
		u32 rca=0;
		u8 wait_busy_count;

#if(DEBUG_PRINTF_EN)
			bsp_printf("disk_initialize started\r\n");
#endif //(DEBUG_PRINTF_EN)
		struct mmc_data *data;
		struct mmc_ops	*ops = mmc->cfg->ops;

		data = malloc(sizeof(struct mmc_data));

		memset(data,0,sizeof(struct mmc_data));

		sd_send_cmd(mmc,xmmc_cmd,MMC_CMD_GO_IDLE_STATE,MMC_RSP_NONE,0); // Send CMD0 to reset the SD Card
		bsp_uDelay(1000);
		sd_send_cmd(mmc,xmmc_cmd,MMC_CMD_SEND_EXT_CSD,MMC_RSP_R7,0x01AA); //CMD8
		if (xmmc_cmd -> response[0] != 0x01AA){
			return RES_ERROR;
		}

		sd_send_cmd(mmc,xmmc_cmd,MMC_CMD_SPI_READ_OCR,MMC_RSP_R3,0); // CMD58
		mmc->ocr=xmmc_cmd->response[0];

		bsp_uDelay(50000);//delay 50ms
		sd_send_cmd(mmc,xmmc_cmd,MMC_CMD_APP_CMD,MMC_RSP_R1,0);  // CMD55

		while (busy==0)
		{
			Value = 0;
			Value |= 0x1<<30;	//HCS
			Value |= 0x0<<28;	//XPC
			Value |= 0x0<<24;	//S18R - this is to switch to 1.8V operating voltage. our FPGA dont support switching to 1.8v
			Value |= 0x100000;	//VDD VOLTAGE - indicate the voltage range to be 3.2 to 3.3 (Refer to the OCR Register)
			sd_send_cmd(mmc,xmmc_cmd,MMC_CMD_APP_CMD,MMC_RSP_R1,0); //make the card accept acmd command so that we can send ACMD41 to set the operating condition
			bsp_uDelay(1000);//delay 50ms
			sd_send_cmd(mmc,xmmc_cmd,SD_CMD_APP_SEND_OP_COND,MMC_RSP_R3,Value); // send ACMD41 to set operating condition
			busy = (xmmc_cmd->response[0]>>31)&0x1; 	// need to shift right 31 as the response format is R3. R1 return will be located at bit 32:39
			bsp_uDelay(50000);	//delay 50ms

			wait_busy_count++;
			if (wait_busy_count >=10)
			{
				return STA_NOINIT;
			}
		}

		mmc->ocr=xmmc_cmd->response[0]; // get back OCR value and put into mmc structure

		bsp_uDelay(1000000);

		sd_send_cmd(mmc,xmmc_cmd,MMC_CMD_ALL_SEND_CID,MMC_RSP_R2,0);
		mmc->cid[0]=xmmc_cmd->response[0];
		mmc->cid[1]=xmmc_cmd->response[1];
		mmc->cid[2]=xmmc_cmd->response[2];
		mmc->cid[3]=xmmc_cmd->response[3];

		sd_send_cmd(mmc,xmmc_cmd,MMC_CMD_SET_RELATIVE_ADDR,MMC_RSP_R6,0);

		mmc->rca = (xmmc_cmd->response[0]&0xffff0000)>>16;
		sd_read_csd(mmc,xmmc_cmd);
		// End of standby State
		sd_send_cmd(mmc,xmmc_cmd,MMC_CMD_SELECT_CARD,MMC_RSP_R1b,(mmc->rca<<16)); // CMD7 // going to transfer state

		sd_send_cmd(mmc,xmmc_cmd,MMC_CMD_APP_CMD,MMC_RSP_R1,(mmc->rca<<16));
		sd_send_cmd(mmc,xmmc_cmd,SD_CMD_APP_SET_BUS_WIDTH,MMC_RSP_R1,DATA_WIDTH);
		sd_send_cmd(mmc,xmmc_cmd,MMC_CMD_SET_BLOCKLEN,MMC_RSP_R1,BLOCK_SIZE);

#if(DEBUG_PRINTF_EN)
			bsp_printf("disk_initialize done\r\n");
#endif //(DEBUG_PRINTF_EN)
		free(data);
		Stat &= ~STA_NOINIT;
		return Stat;
	
}

/*-----------------------------------------------------------------------*/
/* Get disk status                                                       */
/*-----------------------------------------------------------------------*/
DSTATUS disk_status (
	BYTE drv		/* Physical drive number (0) */
)
{
	if (drv) return STA_NOINIT;		/* Supports only drive 0 */

	return Stat;	/* Return disk status */
}

void printBuffer(BYTE *buffer, size_t bufferSize);
/*-----------------------------------------------------------------------*/
/* Write sector(s)                                                       */
/*-----------------------------------------------------------------------*/

void printBuffer(BYTE *buffer, size_t bufferSize) {
    for (size_t i = 0; i < bufferSize; i++) {
    	bsp_printf("%02X ", buffer[i]);
        if ((i + 1) % 16 == 0) // Print a newline every 16 bytes for clarity
        	bsp_printf("\n");
    }
    bsp_printf("\n\r");
}


/*-----------------------------------------------------------------------*/
/* Read sector(s)                                                        */
/*-----------------------------------------------------------------------*/
DRESULT disk_read (
	BYTE drv,		/* Physical drive number (0) */
	BYTE *buff,		/* Pointer to the data buffer to store read data */
	LBA_t sector,	/* Start sector number (LBA) */
	UINT count		/* Number of sectors to read (1..128) */
)
{
	if (drv || !count) return RES_PARERR;		/* Check parameter */
	if (Stat & STA_NOINIT) return RES_NOTRDY;	/* Check if drive is ready */
	struct mmc_cmd *cmd;
	struct mmc_data *data;
	struct mmc_ops	*ops = mmc->cfg->ops;

	cmd = malloc(sizeof(struct mmc_cmd));
	data = malloc(sizeof(struct mmc_data));

	memset(cmd,0,sizeof(struct mmc_cmd));
	memset(data,0,sizeof(struct mmc_data));

	data->blocksize = mmc->read_bl_len;
	data->blocks = count*MAX_BLK_BUF;

	if(data->blocks == 1)	cmd->cmdidx=MMC_CMD_READ_SINGLE_BLOCK;
	else					cmd->cmdidx=MMC_CMD_READ_MULTIPLE_BLOCK;

	cmd->cmdarg =sector;
	cmd->resp_type=MMC_RSP_R1;
	data->dest=buff;
	data->flags = MMC_DATA_READ;


	mmc->cfg->ops->send_cmd(mmc,cmd,data);

	data_cache_invalidate_all();

	free(cmd);
	free(data);
	return RES_OK;
	
}


#if FF_FS_READONLY == 0
DRESULT disk_write (
	BYTE drv,			/* Physical drive number (0) */
	const BYTE *buff,	/* Ponter to the data to write */
	LBA_t sector,		/* Start sector number (LBA) */
	UINT count			/* Number of sectors to write (1..128) */
)
{
	if (drv || !count) return RES_PARERR;		/* Check parameter */
	if (Stat & STA_NOINIT) return RES_NOTRDY;	/* Check drive status */
	if (Stat & STA_PROTECT) return RES_WRPRT;	/* Check write protect */

	struct mmc_cmd *cmd;
	struct mmc_data *data;
	struct mmc_ops	*ops = mmc->cfg->ops;

	cmd = malloc(sizeof(struct mmc_cmd));
	if (cmd == NULL){
		bsp_printf("Error cmd \r\n");
		while(1);
	}
	data = malloc(sizeof(struct mmc_data));
	if (data == NULL){
		bsp_printf("Error data\r\n");
		while(1);
	}
	memset(cmd,0,sizeof(struct mmc_cmd));
	memset(data,0,sizeof(struct mmc_data));

	data->blocksize = mmc->read_bl_len;
	data->blocks = count; //*MAX_BLK_BUF;

	if(data->blocks == 1)	cmd->cmdidx=MMC_CMD_WRITE_SINGLE_BLOCK;
	else					cmd->cmdidx=MMC_CMD_WRITE_MULTIPLE_BLOCK;

	cmd->cmdarg =sector;
	cmd->resp_type=MMC_RSP_R1;

	data->src=buff;
	data->flags = MMC_DATA_WRITE;

	ops->send_cmd(mmc,cmd,data);

	data_cache_invalidate_all();

	free(cmd);
	free(data);
	return RES_OK;
}
#endif




/*-----------------------------------------------------------------------*/
/* Miscellaneous drive controls other than data read/write               */
/*-----------------------------------------------------------------------*/

DRESULT disk_ioctl (
	BYTE drv,		/* Physical drive number (0) */
	BYTE cmd,		/* Control command code */
	void *buff 		/* Pointer to the conrtol data */
)
{
	DRESULT res;
	BYTE n, csd[16];
	DWORD st, ed, csize;
	LBA_t *dp;
	DWORD blk_size = BLOCK_SIZE;
	DWORD sector_cnt = 0;

	if (drv) return RES_PARERR;					/* Check parameter */
	if (Stat & STA_NOINIT) return RES_NOTRDY;	/* Check if drive is ready */

	res = RES_ERROR;

	struct mmc_data *data;
	struct mmc_ops	*ops = mmc->cfg->ops;
	data = malloc(sizeof(struct mmc_data));
	memset(data,0,sizeof(struct mmc_data));


	switch (cmd) {
	case CTRL_SYNC :		/* Wait for end of internal write process of the drive */
		//TO DO: Enable sometime to check the internal process
		//	Makes sure that the device has finished pending write process. If the disk I/O layer or storage device has a write-back cache, the dirty cache data must be committed to the medium immediately. Nothing to do for this command if each write operation to the medium is completed in the disk_write function.
		// For Efinix, all our transaction completed in disk_write function
		res = RES_OK;
		break;

	case GET_SECTOR_COUNT :	/* Get drive capacity in unit of sector (DWORD) */
		// Card specific data
		// switch back to Standby state using CMD7 -> call CMD9 -> switch back to transfer state using CMD7
		sector_cnt = mmc->capacity/blk_size;
		memcpy(buff, &sector_cnt, sizeof(sector_cnt));
#if(DEBUG_PRINTF_EN)
			bsp_printf("Get sector count done\r\n");
#endif //(DEBUG_PRINTF_EN)
		res = RES_OK;
		break;

	case GET_BLOCK_SIZE :	/* Get erase block size in unit of sector (DWORD) */
		memcpy(buff, &blk_size, sizeof(blk_size));
		res = RES_OK;
#if(DEBUG_PRINTF_EN)
			bsp_printf("Get block size done\r\n");
#endif //(DEBUG_PRINTF_EN)
		break;

	case CTRL_TRIM :	/* Erase a block of sectors (used when _USE_ERASE == 1) */
		dp = buff; st = (DWORD)dp[0]; ed = (DWORD)dp[1];	/* Load sector block */
		sd_send_cmd(mmc,xmmc_cmd,SD_CMD_ERASE_WR_BLK_START,MMC_RSP_R1,st); 	//cmd32
		sd_send_cmd(mmc,xmmc_cmd,SD_CMD_ERASE_WR_BLK_END,MMC_RSP_R1,ed); 	//cmd33
		sd_send_cmd(mmc,xmmc_cmd,MMC_CMD_ERASE,MMC_RSP_R1b,0); 				//cmd38
#if(DEBUG_PRINTF_EN)
			bsp_printf("Delete done\r\n");
#endif //(DEBUG_PRINTF_EN)
		res = RES_OK;
		break;

	/* Following commands are never used by FatFs module */

	case MMC_GET_TYPE:		/* Get MMC/SDC type (BYTE) */
		//TO DO: see if we can support MMC
		*(BYTE*)buff = CT_SDC;
#if(DEBUG_PRINTF_EN)
			bsp_printf("Get Type done\r\n");
#endif //(DEBUG_PRINTF_EN)
		res = RES_OK;
		break;

	case MMC_GET_CSD:		/* Read CSD (16 bytes) */
		memcpy(buff, mmc->csd, sizeof(mmc->csd));
#if(DEBUG_PRINTF_EN)
			bsp_printf("Get CSD done\r\n");
#endif //(DEBUG_PRINTF_EN)
		res = RES_OK;
		break;

	case MMC_GET_CID:		/* Read CID (16 bytes) */
		memcpy(buff, mmc->cid, sizeof(mmc->cid));
#if(DEBUG_PRINTF_EN)
			bsp_printf("Get CID done\r\n");
#endif //(DEBUG_PRINTF_EN)
		res = RES_OK;
		break;

	case MMC_GET_OCR:		/* Read OCR (4 bytes) */
		memcpy(buff, &mmc->ocr, sizeof(mmc->ocr));
#if(DEBUG_PRINTF_EN)
			bsp_printf("Get OCR done\r\n");
#endif //(DEBUG_PRINTF_EN)
		res = RES_OK;
		break;

	default:
		res = RES_PARERR;
	}

	free(data);
	return res;
}

DWORD get_fattime (void){
//	bit31:25
//	Year origin from the 1980 (0..127, e.g. 37 for 2017)
//	bit24:21
//	Month (1..12)
//	bit20:16
//	Day of the month (1..31)
//	bit15:11
//	Hour (0..23)
//	bit10:5
//	Minute (0..59)
//	bit4:0
//	Second / 2 (0..29, e.g. 25 for 50)
	return getdata_fatfs();
}



