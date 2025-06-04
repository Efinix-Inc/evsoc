///////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 2025 SaxonSoc contributors
//  SPDX license identifier: MIT
//  Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
///////////////////////////////////////////////////////////////////////////////////

/*******************************************************************************
*
* @file prescaler.h
*
* @brief Header file containing prescaler function declarations and configuration structures
*
* Functions:
* - prescaler_setValue: Writes a prescaler value to a register (0x00)
*
******************************************************************************/
#pragma once

#include "type.h"
#include "io.h"

#define PRESCALER_VALUE     0x00

/*******************************************************************************
*
* @brief This function writes a prescaler value to a register (0x00)
*
* @param data  The data is prescaler value, also known as clock divider ratio. 
*              Example:
*              16'd0: divide by 1
*              16'd1: divide by 2
*              ...
*              16'd65534: divide by 65535
*              16'd65535: divide by 65536
*
* @note Refer to writeReg_u32 from io.h for more detail info. 
*
******************************************************************************/
    writeReg_u32(prescaler_setValue              , PRESCALER_VALUE)
