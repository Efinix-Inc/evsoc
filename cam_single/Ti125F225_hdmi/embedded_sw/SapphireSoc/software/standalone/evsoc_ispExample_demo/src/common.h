////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2026 Efinix Inc. All rights reserved.
// See https://github.com/Efinix-Inc/evsoc/blob/main/LICENSE.txt for details.
////////////////////////////////////////////////////////////////////////////////

#ifndef SRC_COMMON_H_
#define SRC_COMMON_H_

#include "soc.h"
#include "bsp.h"
#include "i2c.h"
#include "userDef.h"

void init_mem_content(volatile uint32_t mem_array[], int32_t num_words);
void check_mem_content(volatile uint32_t mem_array[], int32_t num_words);
void print_hex_64(uint64_t val, uint32_t digits);
u32 axi_slave_read32(u32 address);

void assert(int cond);
void print_hex_digit(u8 digit);
void print_hex_byte(u8 byte);
void print_hex(u32 val, u32 digits);

void msDelay(u32 ms);
u32 number_pow(u32 base, u32 pow);
unsigned char UartGetChar(void);
u32 UartGetDec(void);

void mipi_i2c_init(u32 i2cCtrl);
void hdmi_i2c_init(u32 i2chdmi);

#endif /* SRC_COMMON_H_ */
