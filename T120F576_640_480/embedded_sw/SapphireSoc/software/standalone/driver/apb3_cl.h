///////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 2025 SaxonSoc contributors
//  SPDX license identifier: MIT
//  Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
//////////////////////////////////////////////////////////////////////////////////

/*******************************************************************************
* @file apb3_cl.h
*
* @brief Header file for apb3 function such as read/write to/from APB3 slave and 
*  		 configure APB3 slave by controling configuration register for APB3demo. 
* Functions:
* - apb3_read: Reads a 32-bit value from an APB3 slave register.
* - apb3_ctrl_write: Write a control register configuration to an APB3 slave.
* - cfg_write: Write configuration data to an APB3 slave.
* - cfg_data: Write data to an APB3 slave.
* - cfg_addr: Write an address to an APB3 slave.
*
******************************************************************************/


#pragma once

#include "bsp.h"
#include "io.h"

#define EXAMPLE_APB3_SLV_REG0_OFFSET 	0
#define EXAMPLE_APB3_SLV_REG1_OFFSET 	4
#define EXAMPLE_APB3_SLV_REG2_OFFSET 	8
#define EXAMPLE_APB3_SLV_REG3_OFFSET 	12
#define EXAMPLE_APB3_SLV_REG4_OFFSET 	16
#define EXAMPLE_APB3_SLV_REG5_OFFSET 	20

/*******************************************************************************
*
* @brief  Structure representing the control register configuration for APB3 slave
*
******************************************************************************/   
	struct ctrl_reg {
		unsigned int lfsr_stop	        :1; 	// 1 bit for stopping LFSR operation
		unsigned int reserved			:31;	// Reserved 31 bits

	}apb3_ctrl_reg;

/*******************************************************************************
*
* @brief  Structure representing the control register configuration for APB3 slave
*
******************************************************************************/ 
	struct ctrl_reg2{
		unsigned int mem_start : 1; 		// 1 bit for starting memory operation
	    unsigned int rsv0 : 7;      		// 7 bits reserved
	    unsigned int ilen : 8;      		// 8 bits for length
	    unsigned int rsv1 : 16;     		// 16 bits reserved
	}owrite_crtl;

/*******************************************************************************
*
* @brief This function read a 32-bit value from an APB3 slave register.
*
* @return The value read from the APB3 slave  register.
*
******************************************************************************/
	u32 apb3_read(u32 slave)
	{
		return read_u32(slave+EXAMPLE_APB3_SLV_REG0_OFFSET);	
	}

/*******************************************************************************
*
* @brief This funciton write a control register configuration to an APB3 slave.
*
* @param slave The base address of slave. 
* @param ctrl_reg* Control register.
*
******************************************************************************/   
	void apb3_ctrl_write(u32 slave, struct ctrl_reg *cfg)
	{
	    write_u32(*(int *)cfg, slave+EXAMPLE_APB3_SLV_REG1_OFFSET);
	}

/*******************************************************************************
*
* @brief This funciton write configuration data to an APB3 slave.
*
* @param slave The base address of slave. 
* @param ctrl_reg* Control register.
*
******************************************************************************/ 
	void cfg_write(u32 slave, struct ctrl_reg2 *cfg)
	{
		write_u32(*(int *)cfg, slave+EXAMPLE_APB3_SLV_REG3_OFFSET);
	}

/*******************************************************************************
*
* @brief This funciton write data to an APB3 slave.
*
* @param slave The base address of slave. 
* @param data The data to be written to slave. 
*
******************************************************************************/ 
	void cfg_data(u32 slave, u32 data)
	{
		write_u32(data, slave+EXAMPLE_APB3_SLV_REG4_OFFSET);
	}

/*******************************************************************************
*
* @brief This funciton write an address to an APB3 slave.
*
* @param slave The base address of slave. 
* @param addr Address to be written to slave. 
*
******************************************************************************/ 
	void cfg_addr(u32 slave, u32  addr)
	{
		write_u32(addr, slave+EXAMPLE_APB3_SLV_REG5_OFFSET);
	}
    
void apb3_ctrl_write(u32 slave, struct ctrl_reg *cfg);
void cfg_write(u32 slave, struct ctrl_reg2 *cfg);
void cfg_data(u32 slave, u32 data);
void cfg_addr(u32 slave, u32 addr);
u32 apb3_read(u32 slave);


