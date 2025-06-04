////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2025 Efinix Inc. All rights reserved.              
// Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
////////////////////////////////////////////////////////////////////////////////

/*******************************************************************************
* @file mmc.h
* 
* @brief Header file containing MMC (MultiMediaCard) related declarations and structures.
*
******************************************************************************/
#pragma once
#include <stdint.h>

#define BIT(X)	                    1<<X
#define MMC_VDD_165_195		        0x00000080	/* VDD voltage 1.65 - 1.95 */
#define MMC_VDD_20_21		        0x00000100	/* VDD voltage 2.0 ~ 2.1 */
#define MMC_VDD_21_22		        0x00000200	/* VDD voltage 2.1 ~ 2.2 */
#define MMC_VDD_22_23		        0x00000400	/* VDD voltage 2.2 ~ 2.3 */
#define MMC_VDD_23_24		        0x00000800	/* VDD voltage 2.3 ~ 2.4 */
#define MMC_VDD_24_25		        0x00001000	/* VDD voltage 2.4 ~ 2.5 */
#define MMC_VDD_25_26		        0x00002000	/* VDD voltage 2.5 ~ 2.6 */
#define MMC_VDD_26_27		        0x00004000	/* VDD voltage 2.6 ~ 2.7 */
#define MMC_VDD_27_28		        0x00008000	/* VDD voltage 2.7 ~ 2.8 */
#define MMC_VDD_28_29		        0x00010000	/* VDD voltage 2.8 ~ 2.9 */
#define MMC_VDD_29_30		        0x00020000	/* VDD voltage 2.9 ~ 3.0 */
#define MMC_VDD_30_31		        0x00040000	/* VDD voltage 3.0 ~ 3.1 */
#define MMC_VDD_31_32		        0x00080000	/* VDD voltage 3.1 ~ 3.2 */
#define MMC_VDD_32_33		        0x00100000	/* VDD voltage 3.2 ~ 3.3 */
#define MMC_VDD_33_34		        0x00200000	/* VDD voltage 3.3 ~ 3.4 */
#define MMC_VDD_34_35		        0x00400000	/* VDD voltage 3.4 ~ 3.5 */
#define MMC_VDD_35_36		        0x00800000	/* VDD voltage 3.5 ~ 3.6 */


#define MMC_DATA_READ		            1
#define MMC_DATA_WRITE		            2
#define MMC_CMD_GO_IDLE_STATE		    0 //Resets the SD Memory Card. 
#define MMC_CMD_SEND_OP_COND		    1 //Sends host capcity support infocmation and activate card's intialization process.
#define MMC_CMD_ALL_SEND_CID		    2
#define MMC_CMD_SET_RELATIVE_ADDR	    3
#define MMC_CMD_SET_DSR			        4
#define MMC_CMD_SWITCH			        6
#define MMC_CMD_SELECT_CARD		        7
#define MMC_CMD_SEND_EXT_CSD		    8
#define MMC_CMD_SEND_CSD		        9  //Asks the selected card to send its card-specific data (CSD)
#define MMC_CMD_SEND_CID		        10 //Asks the selected card to send its card identification (CID)
#define MMC_CMD_STOP_TRANSMISSION	    12 //Forces the card to stop transmission in Multiple Block Read Operation.
#define MMC_CMD_SEND_STATUS		        13 //Asks the selected card to sends its status register.
#define MMC_CMD_SET_BLOCKLEN		    16 //Sets a block length for R/W cmd. Block length R/W cmd set to 512B in High Capacity card. 
#define MMC_CMD_READ_SINGLE_BLOCK	    17 //Reads a block of the size selected by the SET_BLOCKLEN command. 
#define MMC_CMD_READ_MULTIPLE_BLOCK	    18 //Continuously transfers data blocks from card to host until interupted.
#define MMC_CMD_SEND_TUNING_BLOCK		19 //Reserved. 
#define MMC_CMD_SEND_TUNING_BLOCK_HS200	21
#define MMC_CMD_SET_BLOCK_COUNT         23 //Reserved. 
#define MMC_CMD_WRITE_SINGLE_BLOCK	    24 //Writes a block of the size selected by the SET_BLOCKLEN command. 
#define MMC_CMD_WRITE_MULTIPLE_BLOCK	25 //Continuously writes block of data until 'Stop Tran' token is sent. 
#define MMC_CMD_ERASE_GROUP_START	    35
#define MMC_CMD_ERASE_GROUP_END		    36
#define MMC_CMD_ERASE			        38 //Erases all previously selected write blocks. 
#define MMC_CMD_APP_CMD			        55 //Defines to the card that the next command is an app specific command. 
#define MMC_CMD_SPI_READ_OCR		    58 //Reads the OCR register of a cord/ CCS bit is assigned to OCR[30]
#define MMC_CMD_SPI_CRC_ON_OFF		    59 //Turns the CRC option on or off. 
#define MMC_CMD_RES_MAN			        62 //Reserved for Manufacturer

#define SD_CMD_SEND_RELATIVE_ADDR	    3
#define SD_CMD_SWITCH_FUNC		        6 //Checks switchable function and switches card function.
#define SD_CMD_SEND_IF_COND		        8 //Sends SD Memory Card interface condition that includes host supply 
										  //voltage information and ask the accessed card whether card can 
										  //operate in supplied voltage range. Reserved bits shall be set to '0'.

#define SD_CMD_APP_SET_BUS_WIDTH	    6
#define SD_CMD_ERASE_WR_BLK_START	    32 //Sets the address of the first write block to be erased.
#define SD_CMD_ERASE_WR_BLK_END		    33 //Sets the address of the last write block of the continuous range to be erased.
#define SD_CMD_APP_SEND_OP_COND		    41 //Sends host capcity support infocmation and activate card's intialization process.
#define SD_CMD_APP_SEND_SCR		        51 //Reads the SD Configuration Register (SCR)

#define MMC_MODE_8BIT		            BIT(30)
#define MMC_MODE_4BIT		            BIT(29)
#define MMC_MODE_1BIT		            BIT(28)
#define MMC_MODE_SPI		            BIT(27)

//Response Format
#define MMC_RSP_PRESENT                 (1 << 0)
#define MMC_RSP_136	                    (1 << 1)		/* 136 bit response */
#define MMC_RSP_CRC	                    (1 << 2)		/* expect valid crc */
#define MMC_RSP_BUSY	                (1 << 3)		/* card may send busy */
#define MMC_RSP_OPCODE	                (1 << 4)		/* response contains opcode */

#define MMC_RSP_NONE	                (0)
#define MMC_RSP_R1	                    (MMC_RSP_PRESENT|MMC_RSP_CRC|MMC_RSP_OPCODE)	//Card Status
#define MMC_RSP_R1b 	                (MMC_RSP_PRESENT|MMC_RSP_CRC|MMC_RSP_OPCODE|MMC_RSP_BUSY)	//Card Status with addtional of busy signal	                            
#define MMC_RSP_R2	                    (MMC_RSP_PRESENT|MMC_RSP_136|MMC_RSP_CRC)		//Two Bytes long 
#define MMC_RSP_R3	                    (MMC_RSP_PRESENT)								//Sent by card when a READ_OCR is received
#define MMC_RSP_R4	                    (MMC_RSP_PRESENT)								//Reserved for I/O mode
#define MMC_RSP_R5	                    (MMC_RSP_PRESENT|MMC_RSP_CRC|MMC_RSP_OPCODE)	//Reserved for I/O mode
#define MMC_RSP_R6	                    (MMC_RSP_PRESENT|MMC_RSP_CRC|MMC_RSP_OPCODE)	//Published RCA response
#define MMC_RSP_R7	                    (MMC_RSP_PRESENT|MMC_RSP_CRC|MMC_RSP_OPCODE)	//Card interface condition

struct mmc;

struct mmc_cid {
	unsigned long psn;  		// Product Serial Number
	unsigned short oid;			// OEM/Application ID
	unsigned char mid;			// Manufacturer ID
	unsigned char prv;			// Product Revision
	unsigned char mdt;			// Manufacturing Date
	char pnm[7];				// Product Name
};

struct mmc_cmd {
	unsigned short  cmdidx;		// Command index
	unsigned int  resp_type;	// Response type
	unsigned int  cmdarg;		// Command argument
	unsigned int  response[4];	// Response data
};


/*******************************************************************************
*
* @brief This structure defines the settings for MMC data transfer, including 
* the destination and source buffers, transfer flags, number of blocks, and 
* block size.
*
* Members:
* - dest: Destination buffer for data transfer.
* - src: Source buffer for data transfer (src buffers are read-only).
* - flags: Transfer flags.
* - blocks: Number of blocks to transfer.
* - blocksize: Size of each block.
*
******************************************************************************/
struct mmc_data {
	union {
        char *dest;              // Destination buffer for data transfer
        const char *src;         // Source buffer for data transfer (read-only)
	};
    unsigned int flags;         // Transfer flags
    unsigned int blocks;        // Number of blocks to transfer
    unsigned int blocksize;     // Size of each block
};

/*******************************************************************************
*
* @brief This structure defines various MMC operations such as sending commands, 
* setting I/Os, initializing MMC, checking card detection, checking write protection, 
* performing host power cycle, and getting the maximum block count.
*
* Members:
* - send_cmd: Function pointer to send a command.
* - set_ios: Function pointer to set I/Os.
* - init: Function pointer to initialize MMC.
* - getcd: Function pointer to check card detection.
* - getwp: Function pointer to check write protection.
* - host_power_cycle: Function pointer to perform host power cycle.
* - get_b_max: Function pointer to get the maximum block count.
*
******************************************************************************/
struct mmc_ops {
	int (*send_cmd)(struct mmc *mmc,
			struct mmc_cmd *cmd, struct mmc_data *data);
	int (*set_ios)(struct mmc *mmc);
	int (*init)(struct mmc *mmc);
	int (*getcd)(struct mmc *mmc);
	int (*getwp)(struct mmc *mmc);
	int (*host_power_cycle)(struct mmc *mmc);
	int (*get_b_max)(struct mmc *mmc, void *dst, uint64_t blkcnt);
};

/*******************************************************************************
*
* @brief This structure holds the MMC configuration settings including MMC name,
* operations,host capabilities, supported voltages, minimum and maximum frequencies, 
* maximum block count, and partition type.
*
* Members:
* - name: Name of the MMC.
* - ops: Pointer to MMC operations.
* - host_caps: Host capabilities.
* - voltages: Supported voltages.
* - f_min: Minimum frequency.
* - f_max: Maximum frequency.
* - b_max: Maximum block count.
* - part_type: Partition type.
*
 ******************************************************************************/
struct mmc_config {
    char *name;                     // Name of the MMC
    struct mmc_ops *ops;            // Pointer to MMC operations
    unsigned int host_caps;         // Host capabilities
    unsigned int voltages;          // Supported voltages
    unsigned int f_min;             // Minimum frequency
    unsigned int f_max;             // Maximum frequency
    unsigned int b_max;             // Maximum block count
    unsigned char part_type;        // Partition type
};

/*******************************************************************************
*
* @brief  This structure represents an MMC device and contains various attributes 
* such as MMC configuration, version, private data, capabilities, frequencies,
* capacity, etc.
*
* Members:
* - cfg: Pointer to MMC configuration.
* - version: MMC version.
* - priv: Pointer to private data.
* - voltages: Supported voltages.
* - has_init: Initialization flag.
* - f_min: Minimum frequency.
* - f_max: Maximum frequency.
* - high_capacity: High capacity flag.
* - bus_width: Bus width.
* - clock: Clock frequency.
* - card_caps: Card capabilities.
* - host_caps: Host capabilities.
* - ocr: Operating conditions register.
* - scr: SD configuration register.
* - csd: Card-specific data.
* - cid: Card identification.
* - rca: Relative card address.
* - part_config: Partition configuration.
* - part_num: Partition number.
* - tran_speed: Transfer speed.
* - read_bl_len: Read block length.
* - write_bl_len: Write block length.
* - erase_grp_size: Erase group size.
* - capacity: Capacity of the MMC device.
*
 ******************************************************************************/
struct mmc {
    struct mmc_config *cfg;         // Pointer to MMC configuration
    unsigned int version;           // MMC version
    void *priv;                     // Pointer to private data
    unsigned int voltages;          // Supported voltages
    unsigned int has_init;          // Initialization flag
    unsigned int f_min;             // Minimum frequency
    unsigned int f_max;             // Maximum frequency
    int high_capacity;              // High capacity flag
    unsigned int bus_width;         // Bus width
    unsigned int clock;             // Clock frequency
    unsigned int card_caps;         // Card capabilities
    unsigned int host_caps;         // Host capabilities
    unsigned int ocr;               // Operating conditions register
    unsigned int scr[2];            // SD configuration register
    unsigned int csd[4];            // Card-specific data
    unsigned int cid[4];            // Card identification
    unsigned short rca;             // Relative card address
    char part_config;               // Partition configuration
    char part_num;                  // Partition number
    unsigned int tran_speed;        // Transfer speed
    unsigned int read_bl_len;       // Read block length
    unsigned int write_bl_len;      // Write block length
    unsigned int erase_grp_size;    // Erase group size
    uint64_t capacity;              // Capacity of the MMC device
};
