///////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 2025 SaxonSoc contributors
//  SPDX license identifier: MIT
//  Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
//////////////////////////////////////////////////////////////////////////////////

/*******************************************************************************
*
* @file main.c : Simple I2C Communication Demo
*
* @brief This demo use the I2C peripheral to communicate with a MCP4725 (DAC)
* 		 It assume it is the single master on the bus, and send frame in 
*		 a blocking manner.
*
* @note This demo required I2C_0 enabled in order to run it.
*
******************************************************************************/

#include <stdint.h>

#include "bsp.h"
#include "i2c.h"
#include "userDef.h" 

uint32_t phase = 0;

#ifdef SYSTEM_I2C_0_IO_CTRL

/******************************************************************************
*
*  This function initiates the configuration of I2C by setting I2C speed to 400kHz.
*
* @param i2c.samplingClockDivider  => Sampling rate = (FCLK/(samplingClockDivider + 1). 
* 								   => Controls the rate at which the I2C controller samples SCL and SDA.
*
* @param i2c.timeout => Inactive timeout clock cycle. The controller will drop the transfer when the value of the timeout is reached or exceeded. 
* 					  => Setting the timeout value to zero will disable the timeout feature.
*
* @param i2c.tsuDat  => Data setup time. The number of clock cycles should SDA hold its state before the rising edge of SCL.
* @param i2c.tLow    => The number of clock cycles of SCL in LOW state.
* @param i2c.tHigh   => The number of clock cycles of SCL in HIGH state.
* @param i2c.tBuf 	  => The number of clock cycles delay before master can initiate a START bit after a STOP bit is issued.
*
* @return None.
*
******************************************************************************/
void init() {
	//I2C init
	I2c_Config i2c;
    i2c.samplingClockDivider    = 3;
    i2c.timeout                 = I2C_CTRL_HZ /1000;   	//timeout = 1ms
    i2c.tsuDat                  = I2C_CTRL_HZ/2000000;  //tsuDat  = 500ns
    i2c.tLow                    = I2C_CTRL_HZ/800000;   //tLow 	  = 1.25us
    i2c.tHigh                   = I2C_CTRL_HZ/800000;  	//tHigh   = 1.25us
    i2c.tBuf                    = I2C_CTRL_HZ/400000;   //tBuf 	  = 2.5us
	i2c_applyConfig(I2C_CTRL, &i2c);
}

/******************************************************************************
*
* @brief This main function initializes and performs I2C communication to interact with a DAC.
*        It continuously reads the DAC status, increments the DAC value, and sends it
*        back to the DAC if it is ready.
*
******************************************************************************/
void main() {
	bsp_init();
	init();
	bsp_printf("i2c 0 demo ! \r\n");
	while (1) {
		uint32_t ready;
		uint32_t dacValue = 0;
		i2c_masterStartBlocking(I2C_CTRL);			//Start the I2C communication
		i2c_txByte(I2C_CTRL, 0xC1);					//Send the DAC address with write bit
		i2c_txNackBlocking(I2C_CTRL);
		i2c_txByte(I2C_CTRL, 0xFF);					//Send the command byte to read DAC status
		i2c_txAckBlocking(I2C_CTRL);
		ready = (i2c_rxData(I2C_CTRL) & 0x80) != 0;	//Read the DAC status byte and check the ready bit
		i2c_txByte(I2C_CTRL, 0xFF);					//Send a dummy byte to trigger the next read operation
		i2c_txAckBlocking(I2C_CTRL);
		dacValue |= i2c_rxData(I2C_CTRL) << 4;		//Read the upper nibble of the DAC value
		i2c_txByte(I2C_CTRL, 0xFF);					//Send another dummy byte to trigger the final read operation
		i2c_txNackBlocking(I2C_CTRL);
		dacValue |= i2c_rxData(I2C_CTRL) >> 4;		//Read the lower nibble of the DAC value
		i2c_masterStopBlocking(I2C_CTRL);			//Stop the I2C communication

		// Check if the DAC is not busy
		if (ready) {
			bsp_printf("DAC is ready \r\n");
		    dacValue += 1;											//Increment the DAC value and mask it to 12 bits
		    dacValue &= 0xFFF;
		    i2c_masterStartBlocking(I2C_CTRL);						//Start the I2C communication
		    i2c_txByte(I2C_CTRL, 0xC0);								//Send the DAC address with write bit
		    i2c_txNackBlocking(I2C_CTRL);
		    i2c_txByte(I2C_CTRL, 0x00 | ((dacValue >> 8) & 0x0F));	//Send the upper byte of the DAC value
		    i2c_txNackBlocking(I2C_CTRL);
		    i2c_txByte(I2C_CTRL, 0x00 | ((dacValue >> 0) & 0xFF));	// Send the lower byte of the DAC value
		    i2c_txNackBlocking(I2C_CTRL);
		    i2c_masterStopBlocking(I2C_CTRL);						// Stop the I2C communication
		    bsp_printf("Increment the dacValue by one and send it to MCP4725\r\n");

		    // Delay loop for stabilization
		    for (uint32_t i = 0; i < 1000; i++)
		        asm("nop");
		}
	}
}
#else
/******************************************************************************
*
* @brief This main function handles the initialization and prints a message to 
*        indicate that I2C 0 is disabled. To run the application, I2C 0 needs 
*        to be enabled.
*
******************************************************************************/
void main() {
    bsp_init();
    bsp_printf("i2c 0 is disabled, please enable it to run this app. \r\n");
}
#endif
