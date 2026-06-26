////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2026 Efinix Inc. All rights reserved.
// See https://github.com/Efinix-Inc/evsoc/blob/main/LICENSE.txt for details.
////////////////////////////////////////////////////////////////////////////////

#pragma once

#include "board_config.h"


#ifdef SYSTEM_I2C_0_IO_CTRL
#define I2C_CTRL                    SYSTEM_I2C_0_IO_CTRL
#define I2C_CTRL_PLIC_INTERRUPT     SYSTEM_PLIC_SYSTEM_I2C_0_IO_INTERRUPT
#endif
#define I2C_CTRL_HZ             SYSTEM_CLINT_HZ
#define BSP_MACHINE_TIMER_HZ    BSP_CLINT_HZ
#define SPI                     SYSTEM_SPI_0_IO_CTRL
#define EXAMPLE_APB3_SLV        IO_APB_SLAVE_0_INPUT
#define DMASG_BASE              IO_APB_SLAVE_1_INPUT
#define PLIC_DMASG_CHANNEL      SYSTEM_PLIC_USER_INTERRUPT_A_INTERRUPT
#define EXAMPLE_AXI4_SLV		SYSTEM_AXI_A_BMB

#define I2C_CTRL_CAM0   SYSTEM_I2C_0_IO_CTRL
#ifdef DUAL_CAM
#define I2C_CTRL_CAM1   SYSTEM_I2C_2_IO_CTRL
#endif
#if defined(BOARD_T120F324) || defined(BOARD_T120F576)
#define I2C_CTRL_HDMI   SYSTEM_I2C_1_IO_CTRL
#endif