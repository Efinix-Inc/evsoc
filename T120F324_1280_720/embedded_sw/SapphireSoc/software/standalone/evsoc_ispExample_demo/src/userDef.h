/*******************************************************************************
*
* @file userDef.h
*
* @brief Header file defines user definition on specific designs. 
*
*******************************************************************************/

#pragma once

#ifdef SYSTEM_I2C_0_IO_CTRL
    #define I2C_CTRL SYSTEM_I2C_0_IO_CTRL
    #define I2C_CTRL_PLIC_INTERRUPT SYSTEM_PLIC_SYSTEM_I2C_0_IO_INTERRUPT
#endif
#define I2C_CTRL_HZ SYSTEM_CLINT_HZ
#define BSP_MACHINE_TIMER_HZ BSP_CLINT_HZ
#define SPI SYSTEM_SPI_0_IO_CTRL

