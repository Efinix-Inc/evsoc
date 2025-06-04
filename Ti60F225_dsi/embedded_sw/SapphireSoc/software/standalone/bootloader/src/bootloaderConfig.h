///////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 2025 SaxonSoc contributors
//  SPDX license identifier: MIT
//  Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
///////////////////////////////////////////////////////////////////////////////////

#pragma once

#include "bsp.h"
#include "io.h"
#include "spiFlash.h"
#include "start.h"

#define SPI SYSTEM_SPI_0_IO_CTRL
#define SPI_CS 0

#define USER_SOFTWARE_MEMORY 0x00001000
#define USER_SOFTWARE_FLASH    0x400000
#define USER_SOFTWARE_SIZE	   0x01F000

#define SINGLE_SPI 1 //define DUAL_SPI for dual data SPI or QUAD_SPI for quad data SPI

void bspMain() {
#ifndef SIM
	spiFlash_init(SPI, SPI_CS);
	spiFlash_wake(SPI, SPI_CS);
	spiFlash_exit4ByteAddr(SPI, SPI_CS);
#ifdef SINGLE_SPI
	spiFlash_f2m(SPI, SPI_CS, USER_SOFTWARE_FLASH, USER_SOFTWARE_MEMORY, USER_SOFTWARE_SIZE);
#elif DUAL_SPI 
    spiFlash_f2m_dual(SPI, SPI_CS, USER_SOFTWARE_FLASH, USER_SOFTWARE_MEMORY, USER_SOFTWARE_SIZE); // dual data line half duplex
#elif QUAD_SPI
    spiFlash_f2m_quad(SPI, SPI_CS, USER_SOFTWARE_FLASH, USER_SOFTWARE_MEMORY, USER_SOFTWARE_SIZE); // quad data line full duplex
#else 
    	#error "You must either define SINGLE_SPI to use single data line SPI, DUAL_SPI to use dual data line SPI or QUAD_SPI to use quad data line SPI."
#endif
#endif

	void (*userMain)() = (void (*)())USER_SOFTWARE_MEMORY;
    #ifdef SMP
        smp_unlock(userMain);
    #endif
	userMain();
}
