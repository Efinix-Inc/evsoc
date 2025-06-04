////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2025 Efinix Inc. All rights reserved.
// Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
////////////////////////////////////////////////////////////////////////////////

/*******************************************************************************
*
* @file Temperature_Driver_EMC1413.h
*
* @brief Header file contain definition and function for EMC1413 Temperature module.
*
******************************************************************************/

#ifndef TEMPERATURE_DRIVER_EMC1413_H_
#define TEMPERATURE_DRIVER_EMC1413_H_

#pragma once
#include <stdint.h>
#include <stdbool.h>
#include "i2c.h"
#include "bsp.h"
#include <math.h>

/******************************************* REGISTER-MAP FOR TEMPERATURE EMC1413 MODULE ********************************************/

//ADDRESS FOR I2C Temperature Slave Address
#define MUX_ADDR			0x71<<1
#define TEMP_ADDR			0x4C<<1

//ADDRESS FOR ID Register
#define PRODUCT_ID			0xFD	//Should return h'21
#define MICROCHIP_ID		0xFE	//Should return h'5D

//ADDRESS FOR Temperature Data Register
#define INT_DIODE_HB		0x00
#define INT_DIODE_LB		0x29
#define EXT_DIODE1_HB		0x01
#define EXT_DIODE1_LB		0x10
#define EXT_DIODE2_HB		0x23
#define EXT_DIODE2_LB		0x24

//ADDRESS FOR CSR REGISTER
#define STATUS_REG			0x02
#define CONFIG_REG			0x03	//Can accessed this at address of 0x09 as well
#define CONVERT_RATE_REG	0x04	//Can accessed this at address of 0x0A as well

//ADDRESS FOR LIMIT REGISTER
#define HIGH_LIMIT_REG_INT_DIODE		0x05 //Can accessed this at address of 0x0B as well
#define LOW_LIMIT_REG_INT_DIODE			0x06 //Can accessed this at address of 0x0C as well

#define HIGH_LIMIT_REG_EXT_DIODE1_HB	0x07 //Can accessed this at address of 0x0D as well
#define LOW_LIMIT_REG_EXT_DIODE1_HB 	0x08 //Can accessed this at address of 0x0E as well

#define HIGH_LIMIT_REG_EXT_DIODE1_LB 	0x13 
#define LOW_LIMIT_REG_EXT_DIODE1_LB 	0x14

#define HIGH_LIMIT_REG_EXT_DIODE2_HB 	0x15 
#define LOW_LIMIT_REG_EXT_DIODE2_HB 	0x16
#define HIGH_LIMIT_REG_EXT_DIODE2_LB 	0x17 
#define LOW_LIMIT_REG_EXT_DIODE2_LB 	0x18

//Only for EMC1414 - EXT DIODE 3
#define HIGH_LIMIT_REG_EXT_DIODE3_HB 	0x2C
#define HIGH_LIMIT_REG_EXT_DIODE3_LB 	0x2E
#define LOW_LIMIT_REG_EXT_DIODE3_HB 	0x2D
#define LOW_LIMIT_REG_EXT_DIODE3_LB 	0x2F

//ADDRESS FOR THERM LIMIT REGISTER
#define THERM_LIMIT          			0X37
#define THERM_LIMIT_EXT_DIODE1			0X19
#define THERM_LIMIT_EXT_DIODE2			0X1A
#define THERM_LIMIT_EXT_DIODE3			0X30
#define THERM_LIMIT_INT_DIODE 			0X20
#define THERM_LIMIT_HYSTERESIS 			0X21

//ADDRESS FOR LIMIT STATUS REGISTER
#define HIGH_LIMIT_STATUS_REG			0x35
#define LOW_LIMIT_STATUS_REG			0x36
#define THERM_LIMIT_STATUS_REG			0x37

//ADDRESS FOR CALIBRATION
#define BETA_CONFIG_EX1_REG				0x25 //Default: h'08
#define BETA_CONFIG_EX2_REG				0x26 //Default: h'08

//ADDRESS FOR OTHER REGISTER
#define FILTER_CTRL_REG					0x40
#define EXT_DIODE_FAULT					0x1B
#define CONSECUTIVE_ALRT_REG			0x70
#define CHANNEL_MASK_REG				0x1F

//DEFAULT VALUE FOR LIMIT TEMP DATA
#define DEFAULT_HIGH_LIMIT_VALUE		0x55
#define DEFAULT_LOW_LIMIT_VALUE			0x00


/******************************************* Function Prototype ********************************************/

//Function prototype - Accessing Temperature data (R/W) 
static void get_templimit();
static void get_tempdata ();
static uint8_t check_temp_alert();
static uint8_t check_lowtemp_alert();
static uint8_t check_hightemp_alert();
static uint8_t check_temprange_reg();
static void config_temprange_reg(const uint8_t val);
static void config_REC(const uint8_t sensor, const uint8_t enable);
static void config_softreset(const uint8_t enable);
static void config_ALERTpin(const uint8_t sensor, const uint8_t enable);
static void set_templimit(double high_limit, double low_limit, uint8_t sensor);

//Function prototype - Accessing Temperature Module (EMC1413)
static uint8_t check_temprange_reg();
static void setI2cMux(const uint8_t cr);
static uint8_t readtemp_reg(const uint8_t reg);
static void writetemp_reg(const uint8_t reg, const uint8_t data);
static uint8_t check_inputval_templimit(double *high_limit, double *low_limit, uint8_t sensor);

//Internal Function prototype
static void convert_templimit();
static void read_templimit(const uint8_t sensor,double *temp_data);
static void read_raw_templimit(const uint8_t sensor,int8_t *raw_data);
static void get_sensor_addr_templimit(const uint8_t sensor, uint8_t *address);
static void write_raw_templimit(const uint8_t sensor,int8_t *raw_data);
static void fractional_extractor(const double val, int8_t *process_data);


/******************************************* Structure of temperature data ********************************************/

/******************************************************************************
*
* @brief Temperature data Structure.
*
* This structure represents various temperatue data for different purpose.
*
******************************************************************************/
typedef struct {
	double int_HB;			//internal diode high byte
	double int_LB;			//internal diode low byte
	double int_HL_temp; 	//internal diode temperature high limit
	double int_LL_temp;		//internal diode temperature low limit
	uint8_t therm_int;		//internal diode thermal limit 

	double ext1_HL_HB;		//external diode 1 high limit (HB) temperature
	double ext1_HL_LB;		//external diode 1 high limit (LB) temperature
	double ext1_LL_HB;		//external diode 1 low limit  (HB) temperature
	double ext1_LL_LB;		//internal diode 1 low limit  (LB) temperature
	double ext1_HL_temp;	//external diode 1 high limit 	   temperature
	double ext1_LL_temp;	//external diode 1 low limit 	   temperature
	uint8_t therm_ext1;		//external diode 1 thermal limit 

	double ext2_HL_HB;		//external diode 2 high limit (HB) temperature
	double ext2_HL_LB;		//external diode 2 high limit (LB) temperature
	double ext2_LL_HB;		//external diode 2 low limit  (HB) temperature
	double ext2_LL_LB;		//internal diode 2 low limit  (LB) temperature
	double ext2_HL_temp;	//external diode 2 high limit      temperature
	double ext2_LL_temp;	//external diode 2 low limit       temperature
	uint8_t therm_ext2;		//external diode 2 thermal limit 

} temperature_data;

/********************************************** Accessing Temperature data (R/W) Function **************************************************/

/******************************************************************************
*
* @brief This function retrieve temperature data and store it into struct.
* @param temperature_data Structure that contain various temperature data.
* @return  none.
*
******************************************************************************/
static void get_tempdata(temperature_data *config) {

	uint8_t ext_temp = check_temprange_reg();

	//Reading internal diode data
	config->int_HB = readtemp_reg(INT_DIODE_HB);
	config->int_LB = (readtemp_reg(INT_DIODE_LB) >> 5);
	config->int_HL_temp =
			(ext_temp) ?
					(config->int_HB - 64 + (config->int_LB / 8)) :
					((config->int_HB) + (config->int_LB / 8));
	//Reading external diode 1 data
	config->ext1_HL_HB = readtemp_reg(EXT_DIODE1_HB);
	config->ext1_HL_LB = (readtemp_reg(EXT_DIODE1_LB) >> 5);
	config->ext1_HL_temp =
			(ext_temp) ?
					(config->ext1_HL_HB - 64 + (config->ext1_HL_LB / 8)) :
					((config->ext1_HL_HB) + (config->ext1_HL_LB / 8));
	//Reading external diode 2 data
	config->ext2_HL_HB = readtemp_reg(EXT_DIODE2_HB);
	config->ext2_HL_LB = (readtemp_reg(EXT_DIODE2_LB) >> 5);
	config->ext2_HL_temp =
			(ext_temp) ?
					(config->ext2_HL_HB - 64 + (config->ext2_HL_LB / 8)) :
					((config->ext2_HL_HB) + (config->ext2_HL_LB / 8));
	return;
}

/******************************************************************************
*
* @brief This function retrieve high/low temperature limit and store it into struct.
* @param temperature_data Structure that contain various temperature data.
* @return  none.
*				  
******************************************************************************/
static void get_templimit(temperature_data *config) {

	double temp_data[3];
	uint8_t ext_temp = check_temprange_reg();

	read_templimit(0,temp_data);
	config->int_HL_temp  = (ext_temp)?temp_data[0]-64:temp_data[0];
	config->int_LL_temp  = (ext_temp)?temp_data[1]-64:temp_data[1];
	config->therm_int    = (ext_temp)?temp_data[2]-64:temp_data[2];

	read_templimit(1,temp_data);
	config->ext1_HL_temp = (ext_temp)?temp_data[0]-64:temp_data[0];
	config->ext1_LL_temp = (ext_temp)?temp_data[1]-64:temp_data[1];
	config->therm_ext1   = (ext_temp)?temp_data[2]-64:temp_data[2];

	read_templimit(2,temp_data);
	config->ext2_HL_temp = (ext_temp)?temp_data[0]-64:temp_data[0];
	config->ext2_LL_temp = (ext_temp)?temp_data[1]-64:temp_data[1];
	config->therm_ext2   = (ext_temp)?temp_data[2]-64:temp_data[2];
	return;
}

/******************************************************************************
*
* @brief This function set the high/low temperature limit.
*
* @param high_limit	  High limit temperature data in double type format.
* @param low_limit	  Low limit temperature data in double type format.
* @param  sensor      0: Internal temperature sensor in EMC1413 itself.
*				      1: Temperature sensor 1 on Ti375C529.
*				      2: Temperature sensor 2 on Ti375C529.
* @return  none.
*
******************************************************************************/
static void set_templimit(double high_limit, double low_limit, uint8_t sensor){

	uint8_t ext_temp = check_temprange_reg();
	int8_t temp_limit_data[5] = {};
	int8_t raw_data[5];
	int8_t processed_HL_data[2]; //High Limit temperature data (Processed)
	int8_t processed_LL_data[2]; //Low Limit temperature data (Processed)

	//Check high/low limit input ,prints msg if invalid input
	uint8_t error = check_inputval_templimit(&high_limit,&low_limit,sensor);
	if (error) bsp_printf ("Invalid input,set to default value\r\n");

	//Read temperature limit data from reg 
	read_raw_templimit(sensor,raw_data);

	//Separate the value into two variable, fractional and integer.
	fractional_extractor(high_limit,processed_HL_data);
	fractional_extractor(low_limit,processed_LL_data);

	temp_limit_data[0] = (ext_temp)?(processed_HL_data[1] + 64): processed_HL_data[1];
	temp_limit_data[1] = processed_HL_data[0]<<5;
	temp_limit_data[2] = (ext_temp)?(processed_LL_data[1] + 64): processed_LL_data[1];
	temp_limit_data[3] = processed_LL_data[0]<<5;
	temp_limit_data[4] = (ext_temp)?(processed_HL_data[1] + 64): processed_HL_data[1];

	//Write temperature limit data to reg
	write_raw_templimit(sensor,temp_limit_data);
	return;
}

/******************************************************************************
*
* @brief  This function check whether the temperature exceed the high limit
*		   temperature register.
*
* @return 0	The temperature of the device still within the acceptable range.
* @return 1	The temperature of the device exceed above the high temp limit register.
*
******************************************************************************/
static uint8_t check_hightemp_alert() {
	uint8_t status;
	status = (readtemp_reg(HIGH_LIMIT_STATUS_REG)& 0x0E) ;
	return 1?(status>0):0; //Return 1 means high temp.
}

/******************************************************************************
*
* @brief  This function check whether the temperature drop below the low limit
*		   temperature register.
*
* @return 0	The temperature of the device still within the acceptable range.
* @return 1	The temperature of the device drop below the low temp limit register.
*
******************************************************************************/
static uint8_t check_lowtemp_alert() {
	uint8_t status;
	status= (readtemp_reg(LOW_LIMIT_STATUS_REG) & 0x0E) ;
	return 1?(status>0):0; //Return 1 means low temp.
}

/******************************************************************************
*
* @brief  This function check whether the temperature exceed/drop above/below
*		  the high/low limit temperature register.
*
* @return 0	The temperature of the device still within the acceptable range.
* @return 1	The temperature of the device drop below the low temp limit register.
* @return 2	The temperature of the device exceed above the high temp limit register.
*
* @note   Not recomended to use it as it will autoclear the alert bit once read the reg. 
*
******************************************************************************/
static uint8_t check_temp_alert() {
	uint8_t status[1] = { };
	status[0] = (readtemp_reg(STATUS_REG) & 0x18) >> 3;
	return status[0]; //Return 2 means high temp.
}
/******************************************************************************
*
* @brief This function configure the range of the temperature
*
* @param temperature_data Structure that contain various temperature data.
* @param val If set to 0, means range of temp from 0°C to +127°C
*			 If set to 1, means range of temp from -64°C to +191°C
* @return  none.
*
******************************************************************************/
static void config_temprange_reg(const uint8_t val) {
	uint8_t status[1] = { };
	status[0] = readtemp_reg(CONFIG_REG);
	uint8_t current_status = ((status[0] &= 0x04) >> 2) ;
	if (current_status == val) return; //if input val is same as current value, then return
	else {
		//Clear bit and add new val
		status[0] &= 0xFB;
		status[0] |= (val << 2);
		writetemp_reg(CONFIG_REG, status[0]);
	}	return;
}

/******************************************************************************
*
* @brief  This function check whether the extended range of temperature is in used.
*
* @return 0	Default Range of the temperature measurement (0°C to +127°C) is used.
* @return 1	Extended Range of the temperature measurement (-65°C to +191°C) is used
*
******************************************************************************/
static uint8_t check_temprange_reg() {
	uint8_t status[1] = { };
	status[0] = readtemp_reg(CONFIG_REG);
	status[0] = (status[0] & 0x04) >> 2;
	return status[0]; //return 1 means extended range of temp is used.
}


/******************************************************************************
*
* @brief  This function configure individual channel masking to disable !ALERT pin. 
*
* @param  enable 	  0: (DEFAULT) Temperature sensor will cause !ALERT pin to be 
*						 asserted if it is out of limit or reports a diode fault.
*				      1: Temperature sensor will NOT cause !ALERT pin to be asserted 
*						 if it is out of limit or reports a diode fault.
*
* @param  sensor      0: Internal temperature sensor in EMC1413 itself.
*				      1: Temperature sensor 1 on Ti375C529.
*				      2: Temperature sensor 2 on Ti375C529. 
*
* @note When a channel is masked, the !ALERT pin will not be asserted when the masked
*       channel reads a diode fault or out of limit error. The channel mask does not 
*		mask the !THERM pin.
******************************************************************************/
static void config_ALERTpin(const uint8_t sensor, const uint8_t enable){
	uint8_t status[3];
	status[0] = readtemp_reg(CHANNEL_MASK_REG);
	status[0] &= ~(1 << sensor);   //Clear the specific bit based on the sensor
	status[0] |= (enable <<sensor);
	writetemp_reg(CHANNEL_MASK_REG,status[0]);
	return;
}

/******************************************************************************
*
* @brief  This function configure resistance error correction (REC) for temperature
*		  sensor 1 and 2 ONLY.  
*
* @param  enable 	  0: REC is disabled for the temperature sensors.
*				      1: (DEFAULT) REC is enabled for the temperature sensors.  
*
* @param  sensor      1: Temperature sensor 1 on Ti375C529.
*				      2: Temperature sensor 2 on Ti375C529. 
*
* @note Parsitic resistance in series with the external diodes will limit the accuracy
*		obtainable from temperature measurement devices. The voltage developed across
*		this resistance cause the reading of temp higher than actual value. The errors
* 		cased by series resistance is +0.7°C per ohm. EMC1413 can auto corrects up to 
*		100ohms of series resistance. 
*
******************************************************************************/
static void config_REC(const uint8_t sensor, const uint8_t enable){
	uint8_t status[1]={};
	status[0] = readtemp_reg(CONFIG_REG);
	status[0] &= ~(1 <<(5-sensor));   //Clear the specific bit based on the sensor
	status[0] |= (!enable <<(5-sensor)); //Clear the specific bit based on the sensor
	writetemp_reg(CONFIG_REG,status[0]);
	return;
}

/******************************************************************************
*
* @brief  This function soft reset the configuration status by set the value to 0x00.  
*
* @param  enable 	  0: Reset to default configuration setting. 
*				      1: Do nothing. 
*
* @note Users are encouraged to reconfigure the range of temperature measurement and  
*		high/low temperature limit after soft-reset. 
*
******************************************************************************/
static void config_softreset(const uint8_t enable){
	uint8_t status[1]= {};
	if(enable){
		status[0] = readtemp_reg(CONFIG_REG);
		status[0] &= 0x00;
		writetemp_reg(CONFIG_REG,status[0]);
	}
	else return;
}

/********************************************** Accessing Temperature Module (EMC1413) Function **************************************************/


/******************************************************************************
*
* @brief  This function is used to read the register of the onboard temperature module in Ti375C529.
*
* @param reg    Address of the register.
. @param data   The data to be written to the specific reg address.
* @return		none.
*
******************************************************************************/
static void writetemp_reg(const uint8_t reg, const uint8_t data) {
	uint8_t status[1] = { data };
	setI2cMux(0x0F);
	i2c_writeData_b(I2C_CTRL, TEMP_ADDR, reg, status, 1);
	return;
}

/******************************************************************************
*
* @brief  This function is used to read the register of the onboard temperature module in Ti375C529.
*
* @param reg    Address of the register.
* @return		Data that read from the reg.
*
******************************************************************************/
static uint8_t readtemp_reg(const uint8_t reg) {
	uint8_t status[1] = { };
	setI2cMux(0x0F);
	i2c_readData_b(I2C_CTRL, TEMP_ADDR, reg, status, 1);
	return status[0];
}



/******************************************************************************
*
* @brief  This function is used to set TCA9546A mux to access Temp module in Ti375C529.
* @return none.
* @note	  Please ensure that this function is used before read/write to Temp module.
*
******************************************************************************/
static void setI2cMux(const uint8_t cr) {
	uint8_t outdata;

	i2c_masterStartBlocking (I2C_CTRL);

	i2c_txByte(I2C_CTRL, MUX_ADDR);
	i2c_txNackBlocking(I2C_CTRL);
	// assert(i2c_rxAck(I2C_CTRL)); // Optional check

	i2c_txByte(I2C_CTRL, cr);
	i2c_txNackBlocking(I2C_CTRL);
	// assert(i2c_rxAck(I2C_CTRL)); // Optional check

	i2c_masterStopBlocking(I2C_CTRL);
}
/********************************************** Internal Function related to Temperature Limit Register **************************************************/



/******************************************************************************
*
* @brief  This internal function obtain the address of the High/Low temperature Limit 
*		  register based on the sensor.
*
* @param  sensor     0: Internal temperature sensor in EMC1413 itself.
*				     1: Temperature sensor 1 on Ti375C529.
*				     2: Temperature sensor 2 on Ti375C529.
* @param  address    Address of the High/Low limit temp reg.
* @return none.
*
******************************************************************************/
static void get_sensor_addr_templimit(const uint8_t sensor, uint8_t *address){
	uint8_t tempdata[5] = {};
if (sensor<3){
	switch (sensor){
	case 0: //Configure Internal diode data
		address[0] = HIGH_LIMIT_REG_INT_DIODE;
		address[1] = 0;
		address[2] = LOW_LIMIT_REG_INT_DIODE;
		address[3] = 0;
		address[4] = THERM_LIMIT_INT_DIODE;
		break;
	case 1:
		address[0] = HIGH_LIMIT_REG_EXT_DIODE1_HB;
		address[1] = HIGH_LIMIT_REG_EXT_DIODE1_LB;
		address[2] = LOW_LIMIT_REG_EXT_DIODE1_HB;
		address[3] = LOW_LIMIT_REG_EXT_DIODE1_LB;
		address[4] = THERM_LIMIT_EXT_DIODE1;
		break;
	case 2:
		address[0] = HIGH_LIMIT_REG_EXT_DIODE2_HB;
		address[1] = HIGH_LIMIT_REG_EXT_DIODE2_LB;
		address[2] = LOW_LIMIT_REG_EXT_DIODE2_HB;
		address[3] = LOW_LIMIT_REG_EXT_DIODE2_LB;
		address[4] = THERM_LIMIT_EXT_DIODE2;
		break;
	}

}return;
}

/******************************************************************************
*
* @brief  This internal function read data from temperature limit register.
*
* @param  sensor     0: Internal temperature sensor in EMC1413 itself.
*				     1: Temperature sensor 1 on Ti375C529.
*				     2: Temperature sensor 2 on Ti375C529.
* @param  temp_data  Address of the High/Low limit temp reg.
* 					 *	temp_data[0] = High Limit Temperature Value
*		  			 *	temp_data[1] = Low Limit Temperature Value
*		  		  	 *	temp_data[2] = Thermal Limit data
* @return none.
*
******************************************************************************/
static void read_templimit(const uint8_t sensor,double *temp_data){

	uint8_t address_data[5] ={};

	get_sensor_addr_templimit(sensor,address_data);
	//Convert retrieved uint8_t data to double type
	double data_0 = (readtemp_reg(address_data[1]) >> 5);
	double data_1 = (readtemp_reg(address_data[3]) >> 5);
	//First two data are for high/low limit data
	temp_data[0]= (sensor==0)?readtemp_reg(address_data[0]):readtemp_reg(address_data[0]) + (data_0/8);
	temp_data[1]= (sensor==0)?readtemp_reg(address_data[2]):readtemp_reg(address_data[2]) + (data_1/8);
	//Thermal Limit data
	temp_data[2]= readtemp_reg(address_data[4]);
	return;
}

/******************************************************************************
*
* @brief  This internal function read raw data from temperature limit register.
*
* @param  sensor     0: Internal temperature sensor in EMC1413 itself.
*				     1: Temperature sensor 1 on Ti375C529.
*				     2: Temperature sensor 2 on Ti375C529.
* @param  temp_data  Address of the High/Low limit temp reg.
* 					 *	raw_data[0] = High Limit Temperature High Byte Value
*		  			 *	raw_data[1] = High Limit Temperature Low  Byte Value
*		  		  	 *	raw_data[2] = Low Limit Temperature High Byte Value
* 					 *	raw_data[3] = Low Limit Temperature Low Byte Value
*		  		  	 *	raw_data[4] = Thermal Limit data
* @return none.
* 
******************************************************************************/
static void read_raw_templimit(const uint8_t sensor,int8_t *raw_data){

	uint8_t address_data[5] ={};

	get_sensor_addr_templimit(sensor,address_data);
	raw_data[0]= readtemp_reg(address_data[0]); 
	raw_data[1]= readtemp_reg(address_data[1]);
	raw_data[2]= readtemp_reg(address_data[2]);
	raw_data[3]= readtemp_reg(address_data[3]);
	raw_data[4]= readtemp_reg(address_data[4]);

}


/******************************************************************************
*
* @brief  This internal function write raw data to temperature limit register.
*
* @param  sensor     0: Internal temperature sensor in EMC1413 itself.
*				     1: Temperature sensor 1 on Ti375C529.
*				     2: Temperature sensor 2 on Ti375C529.
* @param  temp_data  Address of the High/Low limit temp reg.
* 					 *	raw_data[0] = High Limit Temperature High Byte Value
*		  			 *	raw_data[1] = High Limit Temperature Low  Byte Value
*		  		  	 *	raw_data[2] = Low Limit Temperature High Byte Value
* 					 *	raw_data[3] = Low Limit Temperature Low Byte Value
*		  		  	 *	raw_data[4] = Thermal Limit data
* @return none.
*
* @note For sensor 0, raw_data[1] & raw_data[3] are ignored.
* 
******************************************************************************/
static void write_raw_templimit(const uint8_t sensor,int8_t *raw_data){

	uint8_t address_data[5] ={};

	get_sensor_addr_templimit(sensor,address_data);
	writetemp_reg(address_data[0],raw_data[0]); 
	writetemp_reg(address_data[2],raw_data[2]);
	writetemp_reg(address_data[4],raw_data[4]);
	if(sensor>0){ //Ignore internal diode 1 data as it doesnt have low byte register
	writetemp_reg(address_data[1],raw_data[1]);
	writetemp_reg(address_data[3],raw_data[3]);
	}	return;

}


/******************************************************************************
*
* @brief This internal function separate a double type variable into integer and 
*		 fractional value.
*
* @param val	      Temperature data in double type format.
* @param process_data process_data[0]: Value contain only fractional part.
*					  process_data[1]: Value contain only integral part.
*
* @return  none.
*
******************************************************************************/
static void fractional_extractor(const double val, int8_t *process_data) {
    double fractional, integral;

    // Check if the value is negative
    if (val < 0) {
        // Convert negative value to positive
        double positive_val = -val;

        // Extract the fractional and integral parts
        fractional = modf(positive_val, &integral);

        // Convert back to negative after extracting fractional and integral parts
        integral = -integral;
        fractional = 0;
    } else {
        // Extract the fractional and integral parts
        fractional = modf(val, &integral);
    }

    // Shift the fractional part right by 3 bits
    process_data[0] = (int8_t)(fractional * 8); // Only fractional
    process_data[1] = (int8_t)integral;         // Only integer
	return;
}

/******************************************************************************
*
* @brief This internal function check user input for high & low limit value and default
*		 value is used if invalid input. 
*
* @param high_limit	  High limit temperature data in double type format.
* @param low_limit	  Low limit temperature data in double type format.
* @param process_data process_data[0]: Value contain only fractional part.
*					  process_data[1]: Value contain only integral part.
* @param  sensor      0: Internal temperature sensor in EMC1413 itself.
*				      1: Temperature sensor 1 on Ti375C529.
*				      2: Temperature sensor 2 on Ti375C529.
* @return  none.
*
******************************************************************************/
static uint8_t check_inputval_templimit(double *high_limit, double *low_limit, uint8_t sensor) {
    uint8_t ext_temp = check_temprange_reg();
	uint8_t error =0;

    switch (ext_temp) {
        case 0:
            if (*high_limit < 0 || *high_limit > 127) {
                *high_limit = DEFAULT_HIGH_LIMIT_VALUE;
				error++;
            }
            if (*low_limit < 0 || *low_limit > 127) {
                *low_limit = DEFAULT_LOW_LIMIT_VALUE;
				error++;
            }
            break;

        case 1:
            if (*high_limit < -64 || *high_limit > 191.875) {
                *high_limit = DEFAULT_HIGH_LIMIT_VALUE;
				error++;
            }
            if (*low_limit < -64  || *low_limit > 191.875) {
                *low_limit = DEFAULT_LOW_LIMIT_VALUE;
				error++;
            }
            break;
    }

    return error?error:0 ; // If 0 means free from errors.
}

/******************************************************************************
*
* @brief   This internal function convert the temperature data format (High/Low)
*		   of the high/low limit temperature data in all sensors. 
*
* @return  none.	  
*
* @note    Not recomended to use this function for converting the data format.
*          Instead, use config_temprange_reg() function and reset the value by 
*		   using set_templimit();
*
******************************************************************************/
static void convert_templimit(){

	uint8_t ext_temp = check_temprange_reg();
	uint8_t temp_limit_data[5] = {};
	uint8_t sensor =0;
	uint8_t raw_data[5];

	for(;sensor<3;sensor++){ //Will convert all temp data format
	//Read temperature limit data from reg
	read_raw_templimit(sensor,raw_data);

	//Change only in high Byte data in reg
	temp_limit_data[0] = (ext_temp)?(raw_data[0] + 64): (raw_data[0] - 64);
	temp_limit_data[1] = raw_data[1];
	temp_limit_data[2] = (ext_temp)?(raw_data[2] + 64): (raw_data[2] - 64);
	temp_limit_data[3] = raw_data[3];
	temp_limit_data[4] = (ext_temp)?(raw_data[4] + 64): (raw_data[4] - 64);

	//Write temperature limit data to reg
	write_raw_templimit(sensor,temp_limit_data);

	}return;
}

/******************************************************************************
*
* @brief  This function is prints all limit register for debugging purposes. 
* @return none.
*
******************************************************************************/
static void debug_print(){
    bsp_printf("High Limit int register (HB):%x \r\n",readtemp_reg(HIGH_LIMIT_REG_INT_DIODE));
    bsp_printf("Low Limit  int register (LB):%x \r\n",readtemp_reg(LOW_LIMIT_REG_INT_DIODE));
    bsp_printf("High Limit ext1 register (HB):%x \r\n",readtemp_reg(HIGH_LIMIT_REG_EXT_DIODE1_HB));
    bsp_printf("High Limit ext1 register (LB):%x \r\n",readtemp_reg(HIGH_LIMIT_REG_EXT_DIODE1_LB));
    bsp_printf("Low  Limit ext1 register (HB):%x \r\n",readtemp_reg(LOW_LIMIT_REG_EXT_DIODE1_HB));
    bsp_printf("Low  Limit ext1 register (LB):%x \r\n",readtemp_reg(LOW_LIMIT_REG_EXT_DIODE1_LB));
    bsp_printf("High Limit ext2 register (HB):%x \r\n",readtemp_reg(HIGH_LIMIT_REG_EXT_DIODE2_HB));
    bsp_printf("High Limit ext2 register (LB):%x \r\n",readtemp_reg(HIGH_LIMIT_REG_EXT_DIODE2_LB));
    bsp_printf("Low  Limit ext2 register (HB):%x \r\n",readtemp_reg(LOW_LIMIT_REG_EXT_DIODE2_HB));
    bsp_printf("Low  Limit ext2 register (LB):%x \r\n",readtemp_reg(LOW_LIMIT_REG_EXT_DIODE2_LB));
    bsp_printf("High Limit Status register:%x \r\n",readtemp_reg(HIGH_LIMIT_STATUS_REG));
    bsp_printf("Low Limit Status register:%x \r\n",readtemp_reg(LOW_LIMIT_STATUS_REG));
    bsp_printf("External Fault register:%x \r\n",readtemp_reg(EXT_DIODE_FAULT));
	bsp_printf("Thermal limit on external diode 1:%x \r\n",readtemp_reg(THERM_LIMIT_EXT_DIODE1));
	bsp_printf("Thermal limit on external diode 2:%x \r\n",readtemp_reg(THERM_LIMIT_EXT_DIODE2));
	bsp_printf("Thermal limit on internal diode  :%x \r\n",readtemp_reg(THERM_LIMIT_INT_DIODE ));
	bsp_printf("Thermal limit (Hysteresis):%x \r\n",readtemp_reg(THERM_LIMIT_HYSTERESIS ));
	bsp_printf("Thermal limit status register :%x \r\n",readtemp_reg(THERM_LIMIT));
}
#endif /* TEMPERATURE_DRIVER_EMC1413_H_ */
