///////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 2025 SaxonSoc contributors
//  SPDX license identifier: MIT
//  Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
///////////////////////////////////////////////////////////////////////////////////

/******************************************************************************
*
* @file main.c: bootloader
*
* @brief This demo initialize the spiFlash and copy the data from spiFlash to the memory.
*
* @note Please configure bootloader through "bootloaderConfig.h"
*
******************************************************************************/
#include "type.h"
#include "bsp.h"
#include "bootloaderConfig.h"

void main() {
    bsp_init();
    bspMain();
}

