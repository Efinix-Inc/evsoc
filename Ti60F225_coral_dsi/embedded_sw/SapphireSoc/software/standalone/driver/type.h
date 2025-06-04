///////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 2025 SaxonSoc contributors
//  SPDX license identifier: MIT
//  Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
///////////////////////////////////////////////////////////////////////////////////

/*******************************************************************************
*
* @file type.h 
*
* @brief Header file defines common types and bit macros.
*
******************************************************************************/

#pragma once

#include <stdint.h>

/*******************************************************************************
*
* Types defined:
*   - u64: Unsigned 64-bit integer.
*   - s64: Signed 64-bit integer.
*   - u32: Unsigned 32-bit integer.
*   - s32: Signed 32-bit integer.
*   - u16: Unsigned 16-bit integer.
*   - s16: Signed 16-bit integer.
*   - u8:  Unsigned 8-bit integer.
*   - s8:  Signed 8-bit integer.
*
* Bit Macros defined:
*   - BIT_0  through BIT_31: Macros representing individual bits, where BIT_0
*     represents bit position 0, BIT_1 represents bit position 1, and so on.
*
******************************************************************************/


typedef uint64_t    u64;
typedef int64_t     s64;
typedef uint32_t    u32;
typedef int32_t     s32;
typedef uint16_t    u16;
typedef int16_t     s16;
typedef uint8_t     u8;
typedef int8_t      s8;

#define BIT_0   (1 << 0)
#define BIT_1   (1 << 1)
#define BIT_2   (1 << 2)
#define BIT_3   (1 << 3)
#define BIT_4   (1 << 4)
#define BIT_5   (1 << 5)
#define BIT_6   (1 << 6)
#define BIT_7   (1 << 7)
#define BIT_8   (1 << 8)
#define BIT_9   (1 << 9)
#define BIT_10  (1 << 10)
#define BIT_11  (1 << 11)
#define BIT_12  (1 << 12)
#define BIT_13  (1 << 13)
#define BIT_14  (1 << 14)
#define BIT_15  (1 << 15)
#define BIT_16  (1 << 16)
#define BIT_17  (1 << 17)
#define BIT_18  (1 << 18)
#define BIT_19  (1 << 19)
#define BIT_20  (1 << 20)
#define BIT_21  (1 << 21)
#define BIT_22  (1 << 22)
#define BIT_23  (1 << 23)
#define BIT_24  (1 << 24)
#define BIT_25  (1 << 25)
#define BIT_26  (1 << 26)
#define BIT_27  (1 << 27)
#define BIT_28  (1 << 28)
#define BIT_29  (1 << 29)
#define BIT_30  (1 << 30)
#define BIT_31  (1 << 31)



