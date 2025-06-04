///////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 2025 SaxonSoc contributors
//  SPDX license identifier: MIT
//  Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
///////////////////////////////////////////////////////////////////////////////////

/*****************************************************************************
*
* @file io.h 
*
* @brief Header file contains basic read and write function with different data types.
*
* Functions:
* - read_u32: Reads a 32-bit unsigned integer value from a memory address.
* - read_u16: Reads a 16-bit unsigned integer value from a memory address.
* - read_u8 : Reads a 8-bit unsigned integer value from a memory address.
* - write_u32: Writes a 32-bit unsigned integer value to a memory address.
* - write_u16: Writes a 16-bit unsigned integer value to a memory address.
* - write_u8 : Writes a 8-bit unsigned integer value to a memory address.
* - writeReg_u32: Defines a function for writing a 32-bit unsigned integer value
*                 to a register at a specific offset from a base address.
* - readReg_u32: Defines a function for reading a 32-bit unsigned integer value
*                from a register at a specific offset from a base address.
*
******************************************************************************/

#pragma once

#include "type.h"
#include "soc.h"


    static inline u32 read_u32(u32 address){
        return *((volatile u32*) address);
    }
    
    static inline void write_u32(u32 data, u32 address){
        *((volatile u32*) address) = data;
    }
    
    static inline u16 read_u16(u32 address){
        return *((volatile u16*) address);
    }
    
    static inline void write_u16(u16 data, u32 address){
        *((volatile u16*) address) = data;
    }
    
    static inline u8 read_u8(u32 address){
        return *((volatile u8*) address);
    }
    
    static inline void write_u8(u8 data, u32 address){
        *((volatile u8*) address) = data;
    }
    
    static inline void write_u32_ad(u32 address, u32 data){
        *((volatile u32*) address) = data;
    }
    
    #define writeReg_u32(name, offset) \
    static inline void name(u32 reg, u32 value){ \
        write_u32(value, reg + offset); \
    } \
    
    #define readReg_u32(name, offset) \
    static inline u32 name(u32 reg){ \
        return read_u32(reg + offset); \
    } \






