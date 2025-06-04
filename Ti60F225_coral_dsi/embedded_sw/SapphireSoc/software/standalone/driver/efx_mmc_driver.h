////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2025 Efinix Inc. All rights reserved.
// Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
////////////////////////////////////////////////////////////////////////////////


/*******************************************************************************
*
* @file efx_mmc_driver.h
* 
* @brief Header file containing declarations for SD controller functions and structures.
*
* Functions:
* - sd_ctrl_write: Writes a 32-bit data value to the specified offset within the SD controller device registers.
* - sd_ctrl_read: Reads a 32-bit data value from the specified offset within the SD controller device registers.
* - sd_ctrl_cmd: Sends a command to the SD controller device and handles the response accordingly.
* - sd_ctrl_creat_Descriptor: Creates a descriptor for data transfer by allocating memory and setting up the descriptor entries.
* - sd_ctrl_data: Handles data transfer between the SD controller and the SD card.
* - sd_ctrl_check_read_write: Checks if the MMC command requires data read or write operations.
* - sd_ctrl_send_cmd: Sends the MMC command with or without data transfer based on the command type.
* - sd_ctrl_get_cd: Gets the card detect status.
* - sd_ctrl_get_wp: Gets the write protect status.
* - sd_ctrl_set_clk: Sets the clock frequency for SD operations.
* - sd_ctrl_set_bus: Sets the bus width for SD operations.
* - sd_ctrl_set_ios: Sets the I/O settings for the SD controller.
* - sd_ctrl_init: Initializes the SD controller and MMC/SD card.
* - sd_ctrl_mmc_probe: Probes and initializes the MMC/SD controller.
*
******************************************************************************/

#pragma once

#include "bsp.h"
#include "mmc.h" 
#include "userDef.h"

#define REG_VERSION 					0x0000
#define REG_ARGUMENT2 					0x0000
#define REG_BLOCKSIZE_COUNT				0x0004
#define REG_ARGUMENT1 					0x0008
#define REG_TRANFER_MODE 				0x000C
#define REG_COMMAND_RESP31_0 			0x0010
#define REG_COMMAND_RESP63_32 			0x0014
#define REG_COMMAND_RESP95_64 			0x0018
#define REG_COMMAND_RESP127_96 			0x001C
#define REG_BUFFER_DATA					0x0020
#define REG_PRESENT_STATE 				0x0024
#define REG_HOST_CONTORL				0x0028
#define REG_CLOCK_CONTORL				0x002C
#define REG_NORMAL_INTERRUPT_STATUS0	0x0030
#define REG_NORMAL_INTERRUPT_STATUS1	0x0034
#define REG_AUTO_CMD_ERROR				0x003C
#define REG_CAPABILITIES0				0x0040
#define REG_CAPABILITIES1				0x0044
#define REG_MAX_CURRENT					0x0048
#define REG_CAPABILITIES2				0x004C
#define REG_FORECE_EVENT				0x0050
#define REG_ADMA_ERROR_STATUS			0x0054
#define REG_ADMA_SYSTEM_ADDR0			0x0058
#define REG_ADMA_SYSTEM_ADDR1			0x005C
#define REG_PRESENT_VALUE0				0x0060
#define REG_PRESENT_VALUE1				0x0064
#define REG_PRESENT_VALUE2				0x0068
#define REG_PRESENT_VALUE3				0x006C
#define REG_SHARE_BUS_CONTORL			0x00E0
#define REG_SLOT_INTERRUPT_STATUS		0x00FC
#define MAX_DESCRIPTOR                  65536

/*******************************************************************************
*
* @brief Structure to hold various interrupt status flags.
*
******************************************************************************/
typedef struct _IntStruct {
    volatile u32 command_complete;           /* Command complete flag */
    volatile u32 transfer_complete;          /* Transfer complete flag */
    volatile u32 block_gap_event;            /* Block gap event flag */
    volatile u32 buffer_write_ready;         /* Buffer write ready flag */
    volatile u32 buffer_read_ready;          /* Buffer read ready flag */
    volatile u32 card_insertion;             /* Card insertion flag */
    volatile u32 card_removal;               /* Card removal flag */
    volatile u32 command_timeout_error;      /* Command timeout error flag */
    volatile u32 command_crc_error;          /* Command CRC error flag */
    volatile u32 command_end_bit_error;      /* Command end bit error flag */
    volatile u32 command_index_error;        /* Command index error flag */
    volatile u32 data_crc_error;             /* Data CRC error flag */
} IntStruct;

/*******************************************************************************
*
* @brief Structure to hold transaction mode settings.
*
******************************************************************************/
typedef struct {
    u32 dma_enable;                     /* DMA enable flag */
    u32 block_count_enable;             /* Block count enable flag */
    u32 auto_cmd_enable;                /* Auto command enable flag */
    u32 data_transfer_direction_select; /* Data transfer direction select flag */
    u32 multi_or_single_block_select;   /* Multi or single block select flag */
} TransModeStruct;

/*******************************************************************************
*
* @brief Structure representing the SD controller device.
*
******************************************************************************/
struct sd_ctrl_dev {
    int base_addr;              	/* Base address of the SD controller */
    int clk_freq;               	/* Clock frequency */
    int f_min;                  	/* Minimum clock frequency */
    int f_max;                  	/* Maximum clock frequency */
    int app_cmd;                	/* Application command flag */
    TransModeStruct *TransModePtr; 	/* Pointer to transaction mode settings */
};

IntStruct IntPtr; 				/* Global interrupt status structure */
u32 Descriptor[64];				/* Array to hold Descriptor */
u32 DataDescriptor[64];			/* Array to hold Data Descriptor */
u32 AttributeDescriptor[64]; 	/* Array to hold Attribute Descriptor */




/*******************************************************************************
*
* @brief This function writes a 32-bit data value to the specified offset within the SD controller device registers.
*
* @param dev     Pointer to the SD controller device structure.
* @param offset  Offset address within the device registers where the data will be written.
* @param data    32-bit data value to be written.
*
******************************************************************************/
static void sd_ctrl_write(struct sd_ctrl_dev *dev, uint32_t offset, uint32_t data)
{
	write_u32(data,dev->base_addr+offset);
}

/*******************************************************************************
*
* @brief This function reads a 32-bit data value from the specified offset within the SD controller device registers.
*
* @param dev     Pointer to the SD controller device structure.
* @param offset  Offset address within the device registers from where the data will be read.
* @return        The 32-bit data value read from the specified offset.
*
******************************************************************************/
static uint32_t sd_ctrl_read(struct sd_ctrl_dev *dev, uint32_t offset)
{
	return read_u32(dev->base_addr+offset);
}

/*******************************************************************************
*
* @brief This function sends a command to the SD controller device and handles the response accordingly.
*
* @param mmc  Pointer to the MMC structure.
* @param cmd  Pointer to the MMC command structure containing command details.
* @return     0 on success, -1 on failure.
*
******************************************************************************/
static int sd_ctrl_cmd(struct mmc *mmc, struct mmc_cmd *cmd)
{
	int time_out;
	u32 Value;
	struct sd_ctrl_dev *dev = mmc->priv;

#if(DEBUG_PRINTF_EN == 1)
	{
		if(dev->app_cmd)
			bsp_printf("----[ACMD %d ARG 0x%x Rsp %d ]----\r\n",cmd->cmdidx, cmd->cmdarg,cmd->resp_type);
		else
			bsp_printf("----[CMD %d ARG 0x%x Rsp %d ]----\r\n",cmd->cmdidx, cmd->cmdarg,cmd->resp_type);
	}
#endif //(DEBUG_PRINTF_EN == 1)

	sd_ctrl_write(dev,SDHC_ADDR+REG_ARGUMENT1,cmd->cmdarg);

	//Transfer Mode
	Value = 0;
	Value |= (dev->TransModePtr->dma_enable&0x1)<<0;
	Value |= (dev->TransModePtr->block_count_enable&0x1)<<1;
	Value |= (dev->TransModePtr->auto_cmd_enable&0x3)<<2;
	Value |= (dev->TransModePtr->data_transfer_direction_select&0x1)<<4;
	Value |= (dev->TransModePtr->multi_or_single_block_select&0x1)<<5;
	//Command
	//-resp_type [000b:No Response; 001b:R2; 010 b:R3,R4; 110b:R1,R5,R6,R7; 011b:R1b,R5b;]
	if(cmd->resp_type & MMC_RSP_PRESENT)
	{
			 if(cmd->resp_type & MMC_RSP_BUSY)		Value |= 0x03<<16;
		else if(cmd->resp_type & MMC_RSP_136)		Value |= 0x01<<16;
		else										Value |= 0x02<<16;

		if(cmd->resp_type & MMC_RSP_CRC)			Value |= 0x01<<19;
		if(cmd->resp_type & MMC_RSP_OPCODE)			Value |= 0x01<<20;
	}

	//-data_present_select
	if(dev->app_cmd)
	{
		if(cmd->cmdidx ==SD_CMD_APP_SEND_SCR || cmd->cmdidx == MMC_CMD_SEND_STATUS)	//ACMD51 or ACMD13
			Value |= 0x1<<21;
		else
			Value |= 0x0<<21;
	}
	else{
		switch(cmd->cmdidx){
		case MMC_CMD_SWITCH:				Value |= 0x1<<21; break;	//CMD6
		case MMC_CMD_READ_SINGLE_BLOCK:		Value |= 0x1<<21; break;	//CMD17
		case MMC_CMD_READ_MULTIPLE_BLOCK:	Value |= 0x1<<21; break;	//CMD18
		case MMC_CMD_SEND_TUNING_BLOCK:		Value |= 0x1<<21; break;	//CMD19
		case MMC_CMD_WRITE_SINGLE_BLOCK:	Value |= 0x1<<21; break;	//CMD24
		case MMC_CMD_WRITE_MULTIPLE_BLOCK:	Value |= 0x1<<21; break;	//CMD25
		default:							Value |= 0x0<<21; break;	//else
		}
	}

	//-command_type
	Value |= 0x0<<22;
	//-command_index
	Value |= (cmd->cmdidx&0x3f)<<24;
	//Wait CMD Status idle.

	while(read_u32(SDHC_BASE+0x008)&0x1) {
		bsp_uDelay(1);
	}
	sd_ctrl_write(dev,SDHC_ADDR+REG_TRANFER_MODE,Value);

	time_out = 0;
	while(1) {
		if(IntPtr.command_complete == 0x1) {
			IntPtr.command_complete = 0x0;
			if((IntPtr.command_timeout_error == 0x0) && (IntPtr.command_crc_error == 0x0) &&
			   (IntPtr.command_end_bit_error == 0x0) && (IntPtr.command_index_error == 0x0))  {
#if(DEBUG_PRINTF_EN == 1)
					bsp_printf("Info : CMD Succeed!\n\r");
#endif //(DEBUG_PRINTF_EN == 1)

				if((cmd->resp_type&0xf) == 0x0) {//No Response

				} else if(cmd->resp_type & MMC_RSP_136) {//Response Length 136
					cmd->response[0] = sd_ctrl_read(dev,SDHC_ADDR+REG_COMMAND_RESP31_0);//cmd_resp[31:0]
					cmd->response[1] = sd_ctrl_read(dev,SDHC_ADDR+REG_COMMAND_RESP63_32);//cmd_resp[63:32]
					cmd->response[2] = sd_ctrl_read(dev,SDHC_ADDR+REG_COMMAND_RESP95_64);//cmd_resp[95:64]
					cmd->response[3] = sd_ctrl_read(dev,SDHC_ADDR+REG_COMMAND_RESP127_96);//cmd_resp[127:96]
				} else {//Response Length 48
					cmd->response[0] = sd_ctrl_read(dev,SDHC_ADDR+REG_COMMAND_RESP31_0);//cmd_resp[31:0]
					cmd->response[1] = sd_ctrl_read(dev,SDHC_ADDR+REG_COMMAND_RESP63_32);//cmd_resp[63:32]
				}

			} else {
				IntPtr.command_timeout_error = 0x0;
				IntPtr.command_crc_error = 0x0;
				IntPtr.command_end_bit_error = 0x0;
				IntPtr.command_index_error = 0x0;

#if(DEBUG_PRINTF_EN == 1)
					bsp_printf("Err : CMD Failed!\n\r");
#endif //(DEBUG_PRINTF_EN == 1)
			}

			break;
		}
	}

	if(cmd->cmdidx == MMC_CMD_APP_CMD)
		dev->app_cmd =1;
	else
		dev->app_cmd =0;

	mmc->priv = dev;

	return 0;
}

/*******************************************************************************
*
* @brief This function creates a descriptor for data transfer by allocating memory 
* for the descriptor table and setting up the descriptor entries. It calculates the 
* number of lines required for the descriptor table based on the block size and 
* number of blocks to transfer.
*
* @param mmc        Pointer to the MMC structure.
* @param blocks     Number of blocks to transfer.
* @param block_size Size of each block.
* @param src        Source buffer for data transfer.
* @return           0 on success, -1 on failure.
*
 ******************************************************************************/
static int sd_ctrl_creat_Descriptor(struct mmc *mmc,u32 blocks,u32 block_size ,char* src)
{
	u32 Value=0;
	u32 addr_location;
	u32 lenght,sub,line,n;

	struct sd_ctrl_dev *dev = mmc->priv;

	//Max 64 line Descriptor
	//Descriptor=malloc(sizeof(u32)*64);
	memset(Descriptor,0,sizeof(Descriptor));
	memset(DataDescriptor,0,sizeof(DataDescriptor));
	memset(AttributeDescriptor,0,sizeof(AttributeDescriptor));

	lenght = block_size*blocks;

	line=(lenght/MAX_DESCRIPTOR);

	if(lenght%MAX_DESCRIPTOR) line++;

#if(DEBUG_PRINTF_EN == 1)
		bsp_printf("lenght = %d line = %d in Addr = 0x%x\r\n",lenght,line,(u32)src);
#endif //(DEBUG_PRINTF_EN == 1)

	//Greate Descriptor Table
	//Descriptor Table - Attribute

	for(n=0;n<line;n++)
	{
		Value=0;
		if(lenght > MAX_DESCRIPTOR)
			Value |= (MAX_DESCRIPTOR&0xffff) <<16;
		else
			Value |= (lenght&0xffff)<<16;
		//
		//[5:4]:Nop(00b)/rsv(01b)/Tran(10b)/Link(11b); [2]:Int; [1]:End; [0]:Valid;
		if(n==(line-1))
		{
			Value |= 0x23;
		}
		else
		{
			Value |= 0x21;
		}

		//Descriptor Table - Length
		//The maximum data length of each descriptor line is less than 64KB. 0x0=65536 0x1=1 0x2=2......0xFFFFFFFF=65535
		DataDescriptor[n]=((u32)Descriptor)+(sizeof(u32)*2*n);
		write_u32(Value, DataDescriptor[n]);

		AttributeDescriptor[n]=((u32)Descriptor)+sizeof(u32)+(sizeof(u32)*2*n);

		//Descriptor Table - Address Field
		addr_location=((u32)src+(n*MAX_DESCRIPTOR)) & 0xFFFFFFFF;
		write_u32(addr_location, AttributeDescriptor[n]);

		if (lenght > MAX_DESCRIPTOR)
			lenght = lenght - MAX_DESCRIPTOR;

#if(DEBUG_PRINTF_EN == 1)
			bsp_printf("%d AttributeDescriptor[0x%x] = 0x%x  Data[0x%x] = 0x%x\r\n",n,AttributeDescriptor[n],addr_location,DataDescriptor[n],Value);
#endif //(DEBUG_PRINTF_EN == 1)
	}

	sd_ctrl_write(dev,SDHC_ADDR+REG_ADMA_SYSTEM_ADDR0,DataDescriptor[0]);//sdhc_reg - adma_system_address[31:0]

	return 0;
}

/*******************************************************************************
*
* @brief This function handles data transfer between the SD controller and the SD card.
*
* @param mmc Pointer to the MMC structure representing the MMC/SD card.
* @param cmd Pointer to the MMC command structure.
* @param data Pointer to the MMC data structure containing data transfer information.
* @return Returns 0 upon successful data transfer.
*
******************************************************************************/
static int sd_ctrl_data(struct mmc *mmc, struct mmc_cmd *cmd, struct mmc_data *data)
{
	u32 buf=0,tmp=0;
	struct sd_ctrl_dev *dev =mmc->priv;

	//Transfer Mode Set
#if(DEBUG_PRINTF_EN == 1)
		bsp_printf("Write OPS Addr = 0x%x\r\n",dev->base_addr);
		bsp_printf("IntPtr.transfer_complete %d \r\n",IntPtr.transfer_complete);
#endif //(DEBUG_PRINTF_EN == 1)

#ifdef DMA_MODE

	dev->TransModePtr->dma_enable = 0x1;
	if(data->flags==MMC_DATA_WRITE)
		sd_ctrl_creat_Descriptor(mmc,data->blocks,data->blocksize,(char*)data->src);
	else
		sd_ctrl_creat_Descriptor(mmc,data->blocks,data->blocksize,data->dest);

#else
	dev->TransModePtr->dma_enable = 0x0;
#endif

	if(data->blocks == 0x1) {
		dev->TransModePtr->auto_cmd_enable = 0x0;
	} else {
		dev->TransModePtr->auto_cmd_enable = 0x1;
	}

	if(data->flags==MMC_DATA_WRITE)
		dev->TransModePtr->data_transfer_direction_select = 0x0;
	else
		dev->TransModePtr->data_transfer_direction_select = 0x1;

	mmc->priv = dev;

	//Set Block Size & Block Count
		sd_ctrl_write(dev,SDHC_ADDR+REG_BLOCKSIZE_COUNT,((data->blocks&0xffff)<<16) | data->blocksize);//sdhc_reg - Block Size & Block Count Register

		sd_ctrl_cmd(mmc,cmd);


#if(DEBUG_PRINTF_EN == 1)
			if((cmd->response[0]>>3)&0x1) bsp_printf("CS-AKE_SEQ_ERROR\r\n");
			if((cmd->response[0]>>5)&0x1) bsp_printf("CS-APP_CMD\r\n");
			if((cmd->response[0]>>8)&0x1) bsp_printf("CS-READY_FOR_DATA\r\n");
			bsp_printf("CS-CURRENT_STATE %d\r\n", (cmd->response[0]>>9)&0xf);
			if((cmd->response[0]>>13)&0x1) bsp_printf("CS-ERASE_RESET\r\n");
			if((cmd->response[0]>>14)&0x1) bsp_printf("CS-CARD_ECC_DISABLED\r\n");
			if((cmd->response[0]>>15)&0x1) bsp_printf("CS-WP_ERASE_SKIP\r\n");
			if((cmd->response[0]>>16)&0x1) bsp_printf("CS-CSD_OVERWRITE\r\n");
			if((cmd->response[0]>>19)&0x1) bsp_printf("CS-ERROR\r\n");
			if((cmd->response[0]>>20)&0x1) bsp_printf("CS-CC_ERROR\r\n");
			if((cmd->response[0]>>21)&0x1) bsp_printf("CS-CARD_ECC_FAILED\r\n");
			if((cmd->response[0]>>22)&0x1) bsp_printf("CS-ILLEGALCOMMAND\r\n");
			if((cmd->response[0]>>23)&0x1) bsp_printf("CS-COM_CRC_ERROR\r\n");
			if((cmd->response[0]>>24)&0x1) bsp_printf("CS-LOCK_UNLOCK_FAILED\r\n");
			if((cmd->response[0]>>25)&0x1) bsp_printf("CS-CARD_IS_LOCKED\r\n");
			if((cmd->response[0]>>26)&0x1) bsp_printf("CS-WP_VIOLATION\r\n");
			if((cmd->response[0]>>27)&0x1) bsp_printf("CS-ERASE_PARAM\r\n");
			if((cmd->response[0]>>28)&0x1) bsp_printf("CS-ERASE_SEQ_ERROR\r\n");
			if((cmd->response[0]>>29)&0x1) bsp_printf("CS-BLOCK_LEN_ERROR\r\n");
			if((cmd->response[0]>>30)&0x1) bsp_printf("CS-ADDRESS_ERROR\r\n");
			if((cmd->response[0]>>31)&0x1) bsp_printf("CS-OUT_OF_RANGE\r\n");
#endif //(DEBUG_PRINTF_EN == 1)

#ifndef DMA_MODE

	if(data->flags==MMC_DATA_WRITE)
	{
		for(int i=0; i<(data->blocks); i++) {

			//Wait one block data can be written to the buffer.
			while(1) {
				if(sd_ctrl_read(dev,SDHC_ADDR+REG_PRESENT_STATE)&0x400) {
					break;
				}
				//bsp_uDelay(1);
			}
			//Write One Block
			for(int j=0; j<((data->blocksize)/4); j++) {

				buf = data->src[tmp++];
				buf |= data->src[tmp++]<<8;
				buf |= data->src[tmp++]<<16;
				buf |= data->src[tmp++]<<24;
				//bsp_printf("WRITE %x \r\n",buf);

				sd_ctrl_write(dev,SDHC_ADDR+REG_BUFFER_DATA,buf);//sdhc_reg - buffer_data_port Register
//				bsp_uDelay(1);
			}
		}
	}
	else
	{
		for(int i=0; i<data->blocks; i++) {
			//Wait readable block data exists in the buffer.
			while(1) {
				if(sd_ctrl_read(dev,SDHC_ADDR+REG_PRESENT_STATE)&0x800) {
					break;
				}
				//bsp_uDelay(1);
			}
			//Read One Block
			for(int j=0; j<(BLOCK_SIZE/4); j++) {
				buf = sd_ctrl_read(dev,SDHC_ADDR+REG_BUFFER_DATA);

				data->dest[tmp++]=buf & 0xFF;
				data->dest[tmp++]=(buf>>8) & 0xFF;
				data->dest[tmp++]=(buf>>16) & 0xFF;
				data->dest[tmp++]=(buf>>24) & 0xFF;

				//bsp_uDelay(1);//Must ensure that the read rate is lower than the SD clock rate.
			}
            //clear read buffer ready in the end of transfer if the signal asserted in the middle of transfer
            sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0,0x20);
			//bsp_uDelay(1);
		}
	}

#endif
	//Wait Transfer Complete Interrupt
	while(1) {
		if(IntPtr.transfer_complete == 0x1) {
			IntPtr.transfer_complete = 0x0;
			//bsp_uDelay(100);
			break;
		}
	}
	return 0;
}


/*******************************************************************************
*
* @brief This function checks if the MMC command requires data read or write operations.
*
* @param cmd Pointer to the MMC command structure.
* @return Returns 1 if the command requires data read or write operations, otherwise returns 0.
*
*******************************************************************************/

static int sd_ctrl_check_read_write(struct mmc_cmd *cmd)
{
		 if(cmd->cmdidx== MMC_CMD_READ_SINGLE_BLOCK)	return 1;
	else if(cmd->cmdidx== MMC_CMD_READ_MULTIPLE_BLOCK)	return 1;
	else if(cmd->cmdidx== MMC_CMD_WRITE_SINGLE_BLOCK)	return 1;
	else if(cmd->cmdidx== MMC_CMD_WRITE_MULTIPLE_BLOCK)	return 1;
	else if(cmd->cmdidx== MMC_CMD_SEND_STATUS)			return 1;
	else if(cmd->cmdidx== SD_CMD_APP_SEND_SCR)			return 1;
	else	return 0;
}

/*******************************************************************************
*
* @brief This function sends the MMC command with or without data transfer 
*		 based on the command type.
*
* @param mmc Pointer to the MMC structure representing the MMC/SD card.
* @param cmd Pointer to the MMC command structure.
* @param data Pointer to the MMC data structure containing data transfer information.
* @return Returns 0 upon successful command execution.
*
*******************************************************************************/
static int sd_ctrl_send_cmd(struct mmc *mmc, struct mmc_cmd *cmd, struct mmc_data *data)
{
	if(sd_ctrl_check_read_write(cmd))
	{
		if(data)
		{
			sd_ctrl_data(mmc,cmd,data);
		}
	}
	else
	{
		sd_ctrl_cmd(mmc,cmd);
	}

	return 0;
}

/*******************************************************************************
*
* @brief This function gets the card detect status.
*
* @param mmc Pointer to the MMC structure representing the MMC/SD card.
* @return Returns 1 if the card is detected, otherwise returns 0.
*
*******************************************************************************/
static int sd_ctrl_get_cd(struct mmc *mmc)
{
	return 1;
}

/*******************************************************************************
*
* @brief This function gets the write protect status.
*
* @param mmc Pointer to the MMC structure representing the MMC/SD card.
* @return Returns 0 indicating no write protection.
*
*******************************************************************************/
static int sd_ctrl_get_wp(struct mmc *mmc)
{
	return 0;
}

/*******************************************************************************
*
* @brief This function sets the clock frequency for SD operations.
*
* @param mmc Pointer to the MMC structure representing the MMC/SD card.
* @return Returns 0 upon successful clock setting.
*
*******************************************************************************/
static int sd_ctrl_set_clk(struct mmc *mmc)
{
	struct sd_ctrl_dev *dev = mmc->priv;
	int clk;
	u32 Value;

	if(dev->clk_freq >= mmc->f_max)
		clk=mmc->f_max;
	else if(dev->clk_freq <= mmc->f_min)
		clk=mmc->f_min;
	else
		clk = dev->clk_freq;

	mmc->clock = clk;

#if(DEBUG_PRINTF_EN == 1)
		bsp_printf("clk=%d\r\n",clk);
#endif //(DEBUG_PRINTF_EN == 1)

	Value = 100000/clk;

	//sys_reg - clk_out_en & clk_out_div
	sd_ctrl_write(dev,0x004,(0x1<<16) | Value);

#if(DEBUG_PRINTF_EN == 1)
		bsp_printf("SDS Clock Division oefficient %d\r\n", Value);
#endif //(DEBUG_PRINTF_EN == 1)

	bsp_uDelay(10);

	return 0;
}

/*******************************************************************************
*
* @brief This function sets the bus width for SD operations.
*
* @param mmc Pointer to the MMC structure representing the MMC/SD card.
* @return Returns 0 upon successful bus width setting.
*
*******************************************************************************/
static int sd_ctrl_set_bus(struct mmc *mmc)
{
	int set_width;
	struct sd_ctrl_dev *dev = mmc->priv;

	if(mmc->bus_width >=4)	set_width=2;	//4 bit
	else					set_width=1;	//1 bit

	sd_ctrl_write(dev,SDHC_ADDR+REG_HOST_CONTORL,set_width);

	return 0;
}

/*******************************************************************************
*
* @brief This function sets the I/O settings for the SD controller.
*
* @param mmc Pointer to the MMC structure representing the MMC/SD card.
* @return Returns 0 upon successful I/O setting.
*
*******************************************************************************/
static int sd_ctrl_set_ios(struct mmc *mmc)
{
    sd_ctrl_set_clk(mmc); // Set clock frequency
    sd_ctrl_set_bus(mmc); // Set bus width
    return 0;
}

/*******************************************************************************
*
* @brief This function initializes the SD controller and MMC/SD card.
*
* @param mmc Pointer to the MMC structure representing the MMC/SD card.
* @return Returns 0 upon successful initialization.
*
*******************************************************************************/
static int sd_ctrl_init(struct mmc *mmc)
{
    mmc->cfg->ops->getcd(mmc); // Get card detect status
    mmc->cfg->ops->getwp(mmc); // Get write protect status
    mmc->cfg->ops->set_ios(mmc); // Set I/O settings
    return 0;
}

/*******************************************************************************
*
* @brief This function probes and initializes the MMC/SD controller.
*
* @param mmc Pointer to the MMC structure representing the MMC/SD card.
* @param base_addr Base address of the SD controller.
* @return Returns 0 upon successful probe and initialization.
*
*******************************************************************************/

static int sd_ctrl_mmc_probe(struct mmc *mmc, int base_addr)
{
    struct sd_ctrl_dev *dev;
    TransModeStruct *ptr;

    // Allocate memory for SD controller device and transfer mode structure
    dev = malloc(sizeof(struct sd_ctrl_dev));
    ptr = malloc(sizeof(TransModeStruct));

    // Initialize allocated memory with zeros
    memset(dev, 0, sizeof(struct sd_ctrl_dev));
    memset(ptr, 0, sizeof(TransModeStruct));

    // Set SD controller device properties
    dev->base_addr = base_addr;
    dev->clk_freq = SD_CLK_FREQ;
    dev->TransModePtr = ptr;

    // Set MMC private data to SD controller device
    mmc->priv = dev;

    // Set MMC configuration properties
    mmc->cfg->name = "efx_sd_controller";
    mmc->cfg->ops->send_cmd = sd_ctrl_send_cmd;
    mmc->cfg->ops->set_ios = sd_ctrl_set_ios;
    mmc->cfg->ops->getcd = sd_ctrl_get_cd;
    mmc->cfg->ops->getwp = sd_ctrl_get_wp;

    // Set MMC clock frequency and capabilities
    mmc->f_max = MAX_CLK_FREQ;
    mmc->f_min = MAX_CLK_FREQ / 4;
    mmc->host_caps = MMC_MODE_4BIT;
    mmc->cfg->b_max = 1024;
    mmc->bus_width = 4;
    mmc->high_capacity = 1;
    mmc->read_bl_len = BLOCK_SIZE;

    // Set MMC voltage support
    mmc->cfg->voltages = MMC_VDD_32_33 | MMC_VDD_33_34;

    // Initialize SD controller and MMC/SD card
    sd_ctrl_init(mmc);

    return 0;
}

/*******************************************************************************
*
* @brief This function triggers send command function
*
* @param mmc Pointer to the MMC structure representing the MMC/SD card.
* @param cmd Pointer to the MMC CMD structure representing the MMC/SD card.
* @param index The Command Index to send to MMC/SD card.
* @param resp_type The Response type expected to return from MMC/SD card.
* @param cmdarg Argument to send.
* @return Returns 0 upon successful probe and initialization.
*
*******************************************************************************/
static void sd_send_cmd(struct mmc *mmc, struct mmc_cmd *cmd, u32 index, u32 resp_type, u32 cmdarg)
{
	struct mmc_ops *ops = mmc->cfg->ops;
	struct mmc_data *data = NULL;

	cmd->cmdidx = index;
	cmd->resp_type = resp_type;
	cmd->cmdarg =cmdarg;

	ops->send_cmd(mmc,cmd,data);
}


