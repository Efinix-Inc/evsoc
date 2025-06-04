////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2025 Efinix Inc. All rights reserved.
// Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
////////////////////////////////////////////////////////////////////////////////

/*******************************************************************************
*
* @file RTC_Driver_PCF8523.h
*
* @brief Header file contain definition and function for PCF8523 RTC module.
*
******************************************************************************/
#ifndef SRC_RTC_PCF8523_H_
#define SRC_RTC_PCF8523_H_

#pragma once
#include <stdint.h>
#include <stdbool.h>
#include "i2c.h"
#include "bsp.h"

/******************************************* REGISTER-MAP FOR RTC PCF8523 MODULE ********************************************/
//ADDRESS FOR I2C RTC Slave Address
#define MUX_ADDR 			0x71<<1
#define RTC_ADDR 			0x68<<1

//ADDRESS FOR CONTROL STATUS REGISTER
#define RTC_CONTROL_1		0X00
#define	RTC_CONTROL_2		0X01
#define RTC_CONTROL_3		0X02

//ADDRESS FOR TIMEKEEPING REGISTER
#define RTC_SECONDS			0X03
#define	RTC_MINUTES			0X04
#define RTC_HOURS			0X05
#define RTC_DAYS			0X06
#define RTC_WEEKDAYS		0X07
#define RTC_MONTH			0X08
#define RTC_YEAR			0X09

//ADDRESS FOR ALARM REGISTER
#define	ALARM_MINUTES		0X0A
#define ALARM_HOURS		    0X0B
#define ALARM_DAYS		    0X0C
#define ALARM_WEEKDAYS		0X0D

#define OFFSET              0x0E //This is used for Aging adjustment, temperature compensation, accuracy tunning. 

//ADDRESS FOR TIMER REGISTER
#define TIMER_A_FREQ_CTRL   0x10
#define TIMER_A_REG         0x11
#define TIMER_B_FREQ_CTRL   0x12
#define TIMER_B_REG         0x13

//DATA FOR TIMEKEEPING/ALARM IN EACH REG
#define SECONDS_DATA 		0X7F //The BIT_7 is used to indicate the oscillator has stopped when set to 1. 
#define MINUTES_DATA 		0X7F //The BIT_7 is unused.
#define HOURS_DATA 			0X3F 
#define DAYS_DATA 			0X3F
#define WEEKDAYS_DATA 		0X07
#define MONTH_DATA 			0X1F
#define YEAR_DATA 			0XFF


//************************************************* Power Management Function Control Bits *********************************************//
#define PM_0				 0x00  //battery switch-over function is enabled in standard mode; battery low detection function is enabled
#define PM_1				 0x20  //battery switch-over function is enabled in direct switching mode; battery low detection function is enabled
#define PM_2				 0x40  //battery switch-over function is disabled - only one power supply (VDD); battery low detection function is enabled
#define PM_3				 0x60  //battery switch-over function is disabled - only one power supply (VDD); battery low detection function is enabled
#define PM_4				 0x80  //battery switch-over function is enabled in standard mode; battery low detection function is disabled
#define PM_5				 0xA0  //battery switch-over function is enabled in direct switching mode; battery low detection function is disabled
#define PM_6				 0xC0  //not allowed
#define PM_7				 0xE0  //battery switch-over function is disabled - only one power supply (VDD); battery low detection function is disabled

//********************************************************** Function Prototype ***********************************************//

//Global variable - Time Keeping
static uint8_t get_data [17] 	= {};

//Function prototype for accessing RTC
static void setI2cMux(const uint8_t cr);
static void RTC_softreset();
static void readCR_RTC();

//Function Prototype for battery related function
static uint8_t check_battery_status_RTC(uint8_t *data);
static void print_battery_status_RTC();
static void battery_mode_RTC(const uint8_t mode);

//Function Prototype for time related function
static uint8_t get_seconds();
static uint8_t get_minutes();
static uint8_t get_hours();
static uint8_t get_days();
static uint8_t get_weekdays();
static uint8_t get_months();
static uint8_t get_years();
static void set_timesystem (const uint8_t _12hour);
static void set_datetime(const uint8_t set_seconds, const uint8_t set_minutes, const uint8_t set_hours, const uint8_t set_dayOfWeek, \
const uint8_t set_days, const uint8_t set_month, const uint8_t set_years);

//Function Prototype for alarm related function
static bool alarmDisable();
static bool alarmClearFlag();
static uint8_t checkalarmStatus();
static uint8_t alarmMinutes();
static uint8_t alarmHours();
static uint8_t alarmDays();
static uint8_t alarmWeekdays();
static bool alarmSet(const uint8_t minute, const uint8_t hour, const uint8_t day, const uint8_t weekday);

//Function Prototype for internal function
static uint8_t decimal_to_bcd(const uint8_t decimal);
static uint8_t isLeapYear(const uint8_t temp_year);
static uint8_t check_month_error(const uint8_t temp_month,const uint8_t temp_day,const uint8_t temp_year);


//********************************************************** Structure of timekeeping  ***********************************************//

/******************************************************************************
*
* @brief Time-keeping Structure. 
*
* This structure represents real-time data and alarm data from register.
*
******************************************************************************/
typedef struct {
    uint8_t seconds;
    uint8_t minutes;
    uint8_t hours;
	uint8_t PM;
	uint8_t timesystem;
    uint8_t weekdays;
    uint8_t days;
    uint8_t months;
    uint8_t years;
    uint8_t AL_minutes; 
    uint8_t AL_hours;   
    uint8_t AL_days;	  
    uint8_t AL_weekdays;
	uint8_t AL_status;

}time_data;

/******************************************************************************
*
* @brief This array contain the ordinal numbers for DAY register.
*
******************************************************************************/
static const char* Day_ordinal [] = {
    	"st",
		"nd",
		"rd",
		"th"
};

/******************************************************************************
*
* @brief This array contain the day strings. 
*
******************************************************************************/
static const char* const DayStrings[]  = {
		"Sunday",
		"Monday",
		"Tuesday",
		"Wednesday",
		"Thursday",
		"Friday",
		"Saturday"
};

/******************************************************************************
*
* @brief This array contain the month strings. 
*
******************************************************************************/
static const char* const MonthStrings[]  = {
		"January",
		"February",
		"March",
		"April",
		"May",
		"June",
		"July" ,
		"August" ,
		"September" ,
		"October",
		"November" ,
		"December"
};

/******************************************************************************
*
* @brief This array contain the Ante meridiem and Post meridiem strings. 
*
******************************************************************************/
static const char* const  meridiem[] = {
		"am",
		"pm"
};

/******************************************************************************
*
* @brief This array contain oridinal date (st,nd,th) in string format.
*
******************************************************************************/
static const char* get_days_ordinalno(time_data *config){
	switch(config->days){
		case 1:
		case 21:
		case 31:
				return Day_ordinal[0];
				break;
		case 2:
		case 22:
				return Day_ordinal[1];
				break;
		case 3:
		case 23:
				return Day_ordinal[2];
		    	break;
		default:
				return Day_ordinal[3];
				break;
	}

}

/********************************************** TimeKeeping Function **************************************************/


/******************************************************************************
*
* @brief This function extract real-time data from RTC Module and save it into
*		 timedata struct. 
*
* @return  none.
*
******************************************************************************/
static void getdata(time_data *config) {

	//uint8_t timesystem[1] ={} ;
    setI2cMux(0x1);
    i2c_readData_b(I2C_CTRL, RTC_ADDR, RTC_CONTROL_1, get_data, 14);

    //Read Time from RTC
	config->timesystem = (get_data[RTC_CONTROL_1] & 0x08)>> 3;
    config->seconds    = (get_data[RTC_SECONDS] & 0x0F) + ((get_data[RTC_SECONDS] >> 4) & 0x7) * 10;
    config->minutes    = (get_data[RTC_MINUTES] & 0x0F) + ((get_data[RTC_MINUTES] >> 4) & 0x7) * 10;
	config->days  	   = (get_data[RTC_DAYS] & 0x0F) + ((get_data[RTC_DAYS] >> 4) & 0x3) * 10;
	config->weekdays   = (get_data[RTC_WEEKDAYS] & WEEKDAYS_DATA);
    config->months     = (get_data[RTC_MONTH] & 0x0F) + ((get_data[RTC_MONTH] >> 4) & 0x01) * 10;
    config->years      = (get_data[RTC_YEAR] & 0x0F) + ((get_data[RTC_YEAR] >> 4) & 0x0F) * 10;
	config->PM		   = ((get_data[RTC_HOURS] & 0x20)>> 5);  	//Check for Time  AM/PM
	config->AL_status  = ((get_data[ALARM_HOURS] & 0x20)>> 5);  //Check for Alarm AM/PM

	//Checking timesystem from register
	if ((config->timesystem)==1){   // 12 hour time system is selected
		config->hours     = (get_data[RTC_HOURS] & 0x0F)   + ((get_data[RTC_HOURS] >> 4) & 0x1) * 10;
		config->AL_hours  = (get_data[ALARM_HOURS] & 0x0F) + ((get_data[ALARM_HOURS] >> 4) & 0x1) * 10;	
	}else{ 							// 24 hour time system is selected
		config->hours     = (get_data[RTC_HOURS] & 0x0F)   + ((get_data[RTC_HOURS] >> 4) & 0x3) * 10;
		config->AL_hours  = (get_data[ALARM_HOURS] & 0x0F) + ((get_data[ALARM_HOURS] >> 4) & 0x3) * 10;
	}

#if(DEBUG_MODE)
		bsp_printf("Timesystem:%d\r\n",config->timesystem);
		bsp_printf("Raw data from Hour reg:%x\r\n",get_data[5]);
		bsp_printf("Data Hour (Bcdtodec):%d\r\n",config->hours);
		bsp_printf("Data PM (Bcdtodec):%d\r\n",config->PM);
		bsp_printf("Raw data from AL_Hour reg:%x\r\n",get_data[11]);
		bsp_printf("Data AL_Hour (Bcdtodec):%d\r\n",config->AL_hours);
		bsp_printf("Data AL_PM (Bcdtodec):%d\r\n",config->AL_status);
#endif
    //Read set Alarm time
    config->AL_minutes    = (get_data[ALARM_MINUTES] & 0x0F) + ((get_data[ALARM_MINUTES] >> 4) & 0x7) * 10;
	config->AL_days  	  = (get_data[ALARM_DAYS] & 0x0F) + ((get_data[ALARM_DAYS] >> 4) & 0x3) * 10;
	config->AL_weekdays   = (get_data[ALARM_WEEKDAYS] & WEEKDAYS_DATA);
}



/******************************************************************************
*
* @brief This function change the current timesystem (12/24hr)
*
* @param set_seconds 	Set for current seconds.
* @param set_minutes 	Set for current minutes.
* @param set_hours 		Set for current hours.
* @param set_dayOfWeek 	Set for current dayOfWeek.
* @param set_days 		Set for current days.
* @param set_month 		Set for current month.
* @param set_years 		Set for current years.
*
* @return          none.
*
* @note			   The value is set in 24hr timesystem only.
*
******************************************************************************/
static void set_datetime(const uint8_t set_seconds, const uint8_t set_minutes, const uint8_t set_hours, const uint8_t set_dayOfWeek, const uint8_t set_days, const uint8_t set_month, const uint8_t set_years){

	uint8_t data[7] ={
		decimal_to_bcd(set_seconds),
		decimal_to_bcd(set_minutes),
		decimal_to_bcd(set_hours),
		decimal_to_bcd(set_days),
		decimal_to_bcd(set_dayOfWeek),
		decimal_to_bcd(set_month),
		decimal_to_bcd(set_years)
	};
    setI2cMux(0xF);
	i2c_writeData_b(I2C_CTRL,RTC_ADDR,RTC_SECONDS,data,7);
}


/******************************************************************************
*
* @brief This function change the current timesystem (12/24hr) for real-time data and alarm.
*
* @param _12hour   If value = 0, means it is set to 24hr timesystem, vice versa.
*
* @return          none.
*
******************************************************************************/
static void set_timesystem (const uint8_t _12hour){
	time_data tempConfig;
	uint8_t status[1]={};
	setI2cMux(0x1);
	i2c_readData_b(I2C_CTRL,RTC_ADDR,RTC_CONTROL_1,status,1);
	if (((status[0] & 0x08)>>3) == _12hour)
		return;
	else { //Only Trigger when different TimeSystem is detected

	//Clear the bit and reassign the new value given by user for timesystem
	status[0] = status[0] & 0xF7;
	status[0] = (status[0] | (_12hour << 3) );
	setI2cMux(0xF);
	i2c_writeData_b(I2C_CTRL,RTC_ADDR,RTC_CONTROL_1,status,1);

	
	uint8_t i[2] = {ALARM_HOURS,RTC_HOURS};
	uint8_t j;

	//If alarm is disabled then it only loops once to change the timesystem for time.
	if(checkalarmStatus()!=2) j=0; 
	else j=1;
	for(;j<2;j++){ //Loop twice to change timesystem for alarm hour and time hour. 

	//Read hour reg to alter the value based on the timesystem
	setI2cMux(0x1);
	i2c_readData_b(I2C_CTRL,RTC_ADDR,i[j],status,1);

	//Check for current timesystem,if 12hr, then check for AM/PM
	tempConfig.PM    = (status[0] & 0x20)>> 5;

	
	switch (_12hour){
		case 0: //24hours time system
				tempConfig.timesystem = 0;
				tempConfig.hours = (status[0] & 0x0F) + ((status[0] >> 4) & 0x1) * 10;
				uint8_t original_12hr = tempConfig.hours;
				if ((tempConfig.hours ==12) && (tempConfig.PM)); // Value remain the same for both TimeSystem
				else if (tempConfig.PM) tempConfig.hours = tempConfig.hours + 12;//If 24hr system, then it will change 2pm to 14:00
				status[0] = decimal_to_bcd(tempConfig.hours) ; //Change timesystem bit in 02h_address
				//bsp_printf("Timesystem has change to 24hr Timesystem\r\n");
#if(DEBUG_MODE)
				bsp_printf("Timesystem:%d,Convert %d (12hr) to %d (24hr)\r\n",tempConfig.timesystem,original_12hr,tempConfig.hours);
				bsp_printf("Hours value:%d,%d\r\n",tempConfig.hours,decimal_to_bcd(tempConfig.hours));
#endif
				break;

		case 1://12hours time system
				tempConfig.timesystem = 1;
				tempConfig.hours = (status[0] & 0x0F) + ((status[0] >> 4) & 0x3) * 10;
				uint8_t original_24hr =tempConfig.hours;
				if (tempConfig.hours == 12) tempConfig.PM =1;
				else if (tempConfig.hours>12 ) //Evening
				{
					tempConfig.PM = 1;
					tempConfig.hours = tempConfig.hours -12;
				}
				else if (((tempConfig.hours>=0) | (tempConfig.hours<=3)) && tempConfig.PM) tempConfig.hours = tempConfig.hours +8;
				else tempConfig.PM = 0;//Morning
				//bsp_printf("Timesystem has change to 12hr Timesystem\r\n");
#if(DEBUG_MODE)
				bsp_printf("Timesystem:%d,Convert %x (24hr) to %x (12hr)\r\n",tempConfig.timesystem,original_24hr,tempConfig.hours);
				bsp_printf("Hours value:%d,%d\r\n",tempConfig.hours,decimal_to_bcd(tempConfig.hours));
#endif
				status[0] = ((tempConfig.PM <<5)|decimal_to_bcd(tempConfig.hours)); //Change timesystem bit in 02h_address
				break;
		default:
				break;

	}
	setI2cMux(0xF);
	i2c_writeData_b(I2C_CTRL,RTC_ADDR,i[j],status,1);
	}
	(_12hour)?bsp_printf("Timesystem has change to 12hr Timesystem\r\n"):
	bsp_printf("Timesystem has change to 24hr Timesystem\r\n");
}
}



/******************************************************************************
*
* @brief This function return seconds from struct of timedata. 
* @return seconds.
*
******************************************************************************/
static uint8_t get_seconds(time_data *config){
	return config->seconds;
}


/******************************************************************************
*
* @brief This function return minutes from struct of timedata. 
* @return minutes.
*
******************************************************************************/
static uint8_t get_minutes(time_data *config){
	return config->minutes;
}

/******************************************************************************
*
* @brief This function return hours from struct of timedata. 
* @return hours.
*
******************************************************************************/
static uint8_t get_hours(time_data *config){
	return config->hours;
}

/******************************************************************************
*
* @brief This function return days from struct of timedata. 
* @return days.
*
******************************************************************************/
static uint8_t get_days(time_data *config){
	return config->days;
}

/******************************************************************************
*
* @brief This function return months from struct of timedata. 
* @return months.
*
******************************************************************************/
static uint8_t get_months(time_data *config){
	return config->months;
}

/******************************************************************************
*
* @brief This function return years from struct of timedata. 
* @return years.
*
******************************************************************************/
static uint8_t get_years(time_data *config){
	return config->years;
}

/******************************************************************************
*
* @brief This function return weekdays from struct of timedata. 
* @return weekdays.
*
******************************************************************************/
static uint8_t get_weekdays(time_data *config){
	return config->weekdays;
}

/******************************************************************************
*
* @brief This function convert decimal value to BCD. 
*
* @param decimal Decimal Value
* @return 		 BCD value.
*
******************************************************************************/
static uint8_t decimal_to_bcd(const uint8_t decimal) {
    uint8_t bcd1, bcd2;

    bcd1 = decimal % 10;
    bcd2 = (decimal / 10) << 4 ;

    return (bcd2 | bcd1);
}




/************************************** Alarm Function *****************************************************/


/******************************************************************************
*
* @brief This function enable Alarm and set the value in 24hr timesystem. 
*
* @param minutes 	Set for alarm minutes.
* @param hours 		Set for alarm hours.
* @param day 		Set for alarm day.
* @param weekday 	Set for alarm weekday.
*
* @note				Alarm only triggered when all alarm register match with all
*					time register which generate alarm flag (AF) in CSR1.
*
* @return 			true
*
******************************************************************************/
static bool alarmSet(const uint8_t minute, const uint8_t hour, const uint8_t day, const uint8_t weekday){

	time_data config;
	uint8_t status[1] = {};
	uint8_t type_alarm = 0;

	//Enable AIE
	setI2cMux(0x1); //Read
	i2c_readData_b(I2C_CTRL,RTC_ADDR,RTC_CONTROL_1,status,1);
	status[0] |= 0x02;
	setI2cMux(0xF); //Write
	i2c_writeData_b(I2C_CTRL,RTC_ADDR,RTC_CONTROL_1,status,1);

    config.AL_minutes    = minute;
    config.AL_hours      = hour;
    config.AL_days       = day;
    config.AL_weekdays   = weekday;


	uint8_t alarm1_set[4] = {(0x00|decimal_to_bcd(minute)),(0x00|decimal_to_bcd(hour)),(0x00|decimal_to_bcd(day)),(0x00|decimal_to_bcd(weekday))};
    setI2cMux(0xF);
	i2c_writeData_b(I2C_CTRL,RTC_ADDR,ALARM_MINUTES,alarm1_set,4);
	return true;

}

/******************************************************************************
*
* @brief  This function disable Alarm by setting '1' to alarm_en bit in all alarm
*		  register. 
* @return true.
*
******************************************************************************/
static bool alarmDisable() {
	uint8_t status[4]= {};

	//Disable alarm interrupt enabled bit in CR1
	setI2cMux(0x1); //Read
	i2c_readData_b(I2C_CTRL,RTC_ADDR,RTC_CONTROL_1,status,1);
	status[0] &= 0xFD;
	setI2cMux(0xF); //Write
	i2c_writeData_b(I2C_CTRL,RTC_ADDR,RTC_CONTROL_1,status,1);

	//Disable all alarm enabled bit in minute register, ...
	setI2cMux(0x1);
	i2c_readData_b(I2C_CTRL,RTC_ADDR,ALARM_MINUTES,status,4);
	for (int i = 0;i<4;i++){
		//bsp_printf("Before masking: %x \r\n",status[i]);
		status[i]= (status[i] | 0x80); //Set alarm_en to 1 to disable
		//bsp_printf("After masking: %x \r\n",status[i]);
	}
	setI2cMux(0x1); //Write
	i2c_writeData_b(I2C_CTRL,RTC_ADDR,ALARM_MINUTES,status,4);
#if (DEBUG_MODE)
	i2c_readData_b(I2C_CTRL,RTC_ADDR,ALARM_MINUTES,status,4);
	for (int i = 0;i<4;i++){
		bsp_printf("ReadBack from reg%x: %x \r\n",0x0A+i,status[i]);
	}
#endif
	return true;

}

/******************************************************************************
*
* @brief  This function clear alarmFlag (AF) in CSR1.  
* @return true.
*
******************************************************************************/
static bool alarmClearFlag(){
		uint8_t status[1];
		setI2cMux(0x1);
		i2c_readData_b(I2C_CTRL,RTC_ADDR,RTC_CONTROL_2,status,1);
		status[0] = status[0] & 0xF7;
		setI2cMux(0xF);
		i2c_writeData_b(I2C_CTRL,RTC_ADDR,RTC_CONTROL_2,status,1);
		return true;

}

/******************************************************************************
*
* @brief  This function check alarm status if true means alarm has triggered.  
* @return 0	Alarm is not triggered.
* @return 1	Alarm is triggered.
* @return 2	Alarm is disabled.
*
******************************************************************************/
static uint8_t checkalarmStatus() {
	uint8_t status[5]={0,0,0,0,0};

	//Check Alarm enabled bit in reg
	setI2cMux(0x1);
	i2c_readData_b(I2C_CTRL,RTC_ADDR,ALARM_MINUTES,status,4);
#if (DEBUG_MODE)
		bsp_printf("\r\nDebug Mode ENABLED!");
		bsp_printf("\r\n*********************\r\n");
	for (int i = 0;i<4;i++){
		bsp_printf("Before Raw Value from reg%d : %x\r\n", i,status[i]);
		bsp_printf("Before Accumulated Raw val : %x\r\n", status[4]);
		status[i]=(status[i] & 0x80)>> 7; 	//Set alarm_en to 1
		status[4]+=status[i];				//Add all alarm_en bit (Bit7)
		bsp_printf("Value from masking reg%d : %x\r\n", i,status[i]);	
		bsp_printf("Accumulated val : %x\r\n", status[4]);
	}
		uint8_t status_debug[1]={};
		i2c_readData_b(I2C_CTRL,RTC_ADDR,RTC_CONTROL_1,status_debug,1); //Check Alarm INT in CR1
		bsp_printf("CR2: %x\r\n",status_debug[0]);
		bsp_printf("Done printing\r\n");

#else
	for (int i = 0;i<4;i++){
		status[i]=(status[i] & 0x80)>> 7; 	//Set alarm_en to 1
		status[4]+=status[i];				//Add all alarm_en bit (Bit7)
	}
#endif
	if (status[4]>0x00)			//If status[4] > 0 means alarm is disabled.
		return 2; 					//Alarm is disabled

	i2c_readData_b(I2C_CTRL,RTC_ADDR,RTC_CONTROL_2,status,1); //Check Alarm Flag in control reg

	if((status[0] &  0x08) == 0x08) //Alarm 1 is triggered
	    return 1; //bsp_printf("Alarm 1 is triggered! \r\n");
	else
		return 0; //bsp_printf("No Alarm is triggered! \r\n");
	
}

/******************************************************************************
*
* @brief This function return alarm minutes from struct of timedata. 
* @return alarm minutes.
*
******************************************************************************/
static uint8_t alarmMinutes(time_data *config){
	return config->AL_minutes;
}

/******************************************************************************
*
* @brief This function return alarm Hours from struct of timedata. 
* @return alarm hours.
*
******************************************************************************/
static uint8_t alarmHours(time_data *config){
	return config->AL_hours;
}

/******************************************************************************
*
* @brief This function return alarm days from struct of timedata. 
* @return alarm days.
*
******************************************************************************/
static uint8_t alarmDays(time_data *config){
	return config->AL_days;
}

/******************************************************************************
*
* @brief This function return alarm weekdays from struct of timedata. 
* @return alarm weekdays.
*
******************************************************************************/
static uint8_t alarmWeekdays(time_data *config){
	return config->AL_weekdays;
}

/********************************************** Control Register Function**************************************************/

/******************************************************************************
*
* @brief  This function intialize soft reset on RTC module. 
* @return none.
* @note   Upon soft-reset, reconfiguration on CSR is needed as soft-reset will wipe
*		  the previous configuration, but time-keeping is not affected. 
*
******************************************************************************/
static void RTC_softreset()
{
	uint8_t status[1] = {0x58};
	setI2cMux(0xF);
	//writeRtc(RTC_CONTROL_1, 0x08);
	i2c_writeData_b(I2C_CTRL,RTC_ADDR,RTC_CONTROL_1,status,1);
}


/******************************************************************************
*
* @brief  This function checks all control register and prints the info on terminal. 
* @return none.
*
******************************************************************************/
static void readCR_RTC() {
	uint8_t status[3] = { };
	setI2cMux(0x1);
	i2c_readData_b(I2C_CTRL, RTC_ADDR, RTC_CONTROL_1, status, 3);
	for (int i = 1; i < 4; i++) {
		bsp_printf("RTC CR%d readback: %x\r\n", RTC_CONTROL_1 + i,
				status[i - 1]);
	}
}


/******************************************************************************
*
* @brief  This function is used to set TCA9546A mux to access RTC module in Ti375C529. 
* @return none.
* @note	  Please ensure that this function is used before read/write to RTC module.
*
******************************************************************************/
static void setI2cMux(const uint8_t cr)
{
	u8 outdata;

    i2c_masterStartBlocking(I2C_CTRL);

    i2c_txByte(I2C_CTRL, MUX_ADDR);
	i2c_txNackBlocking(I2C_CTRL);
	// assert(i2c_rxAck(I2C_CTRL)); // Optional check

	i2c_txByte(I2C_CTRL, cr);
	i2c_txNackBlocking(I2C_CTRL);
	// assert(i2c_rxAck(I2C_CTRL)); // Optional check

	i2c_masterStopBlocking(I2C_CTRL);
}


/********************************************** Battery Management Function **************************************************/

#define BATTERY_STRING			"\r\nBattery Management Function" \
								"\r\nSelect 0 to disable battery switch-over and battery low detection function" \
								"\r\nSelect 1 to enable battery low detection function ONLY " \
								"\r\nSelect 2 to enable battery switch-over function ONLY (Direct-switching mode) " \
								"\r\nSelect 3 to enable battery switch-over and battery low detection function" \
								"\r\nPlease select the correct mode: \r\n"

/******************************************************************************
*
* @brief  This function check battery status (low/ok), battery switch over function,
*		  battery low detection function and illegal control bit.
*
* @param  data     The data that store all the information regarding the battery 
*				   status. 
* @return data[0]. Return data is illegal control bits.
*
******************************************************************************/
static uint8_t check_battery_status_RTC(uint8_t *data)
{
	uint8_t status[1]={};
	setI2cMux(0x1);
	i2c_readData_b(I2C_CTRL,RTC_ADDR,RTC_CONTROL_3,status,1);
    // Update the battery status and switch over flag in data array
	//bsp_printf("status: %d \r\n",status[0]);
	data[0] = status[0] & 0xE0;  // Check for illegal control bits (0xC0)
    data[1] = status[0] & 0x04;  // Check battery status (low/ok),0 means ok
    data[2] = status[0] & 0x40;  // Check battery switch over function if 0 then enabled
    data[3] = status[0] & 0x80;	 // Check battery low detection function if 0
    //bsp_printf("Status: %d ,%d\r\n",data[0],data[1]);
    return data[0];				// Return 0xC0 if the illegal control bit is detected.

}

/******************************************************************************
*
* @brief  This function prints battery information.
* @return none.
*
******************************************************************************/
static void print_battery_status_RTC(){
	uint8_t battery_status_data[3]={};
    
	if (check_battery_status_RTC(battery_status_data) == PM_6)
		bsp_printf(
				"Invalid value in Power management functions, please reconfigure it "
				"using battery_mode_RTC!!!\r\n ");
	else
		bsp_printf(
				"Battery status (LOW/OK): %s\r\nBattery switch-over: %s\r\n"
				"Battery low detection: %s\r\n",
				battery_status_data[1] ? "LOW" : "OK",
				battery_status_data[2] ? "DISABLED" : "ENABLED",
				battery_status_data[3] ? "DISABLED" : "ENABLED");
	bsp_printf("Checking completed ! \r\n\n");
}

/******************************************************************************
*
* @brief  This function switch battery mode that either enable/disable battery 
*		  switch over function, battery low detection function or both enable/
*		  disable the function. 
*
* @param  mode    Battery mode 
* @return none.
*
******************************************************************************/
static void battery_mode_RTC(const uint8_t mode)
{
	uint8_t PM;
	uint8_t status[1]={};
	setI2cMux(0x1);
	i2c_readData_b(I2C_CTRL,RTC_ADDR,RTC_CONTROL_3,status,1);
	status[0] &= 0x1F; //Clear power management bits

	switch (mode)
	{
	case 0: //All Disable
		PM = PM_7;
		break;
	case 1: //Battery low detection is enabled only
		PM = PM_3;
		break;
	case 2: //Battery switch over is enabled only (Direct-switching mode)
		PM = PM_5;
		break;
	case 3: //Both battery low detection and switch over are enabled (Standard mode)
		PM = PM_0;
		break;
	default:
		PM = PM_7;
		break;
	}
	status[0] = PM | status[0];
	setI2cMux(0xF);
	i2c_writeData_b(I2C_CTRL,RTC_ADDR,RTC_CONTROL_3,status,1);
}
/********************************************** Internal Function: Checking Function **************************************************/

/******************************************************************************
*
* @brief  This function checks for leap year. 
*
* @param  temp_year   Years
* @return 0			  Means it is not a leap year.
* @return 1			  Means it is a leap year.
*
******************************************************************************/
static uint8_t isLeapYear(const uint8_t temp_year) {
    // If the year is in the '00' to '99' range, assume it's in the 21st century
	int year = temp_year;
    if (year >= 0 && year <= 99) {
        year = year + 2000;  // Convert two-digit year to four-digit year
        bsp_printf("year:%d\r\n",year);
    }

    // Leap year is divisible by 4
    if (year % 4 == 0) {
        // If divisible by 100, it should also be divisible by 400 to be a leap year
        if (year % 100 == 0 && year % 400 != 0) {
            return 0;  // Not a leap year
        } else {
            return 1;  // Leap year
        }
    } else {
        return 0;  // Not a leap year
    }
}

/******************************************************************************
*
* @brief  This function checks input value for the number of days in the specific month. 
*
* @param  temp_day    Days
* @param  temp_month  Month
* @param  temp_year   Years
* @return 0			  No error.
* @return 1			  Error.
*
******************************************************************************/
static uint8_t check_month_error(const uint8_t temp_month,const uint8_t temp_day,const uint8_t temp_year){
	uint8_t leap_year = 8;
	switch(temp_month)
	{
		case 1:
		case 3:
		case 5:
		case 7:
		case 8:
		case 10:
		case 12:
				return (temp_day>31)?1:0;
				break;
		case 2:
			leap_year = isLeapYear(temp_year);
			bsp_printf("Is Leap Year: %s \r\n",leap_year?("Yes"):("No"));


			if((temp_day <30) && (leap_year))
			{
				return 0;
			}

			return (temp_day>28)?1:0;

			break;

		default:
			return (temp_day>30)?1:0;
			break;
	}

	return 0;
}
/************************************************************************************************************************/

#endif /* SRC_RTC_PCF8523_H_ */
