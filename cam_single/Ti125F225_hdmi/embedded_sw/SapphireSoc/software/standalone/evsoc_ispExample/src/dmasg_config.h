////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2026 Efinix Inc. All rights reserved.
// See https://github.com/Efinix-Inc/evsoc/blob/main/LICENSE.txt for details.
////////////////////////////////////////////////////////////////////////////////

#ifndef DMASG_CONFIG_H
#define DMASG_CONFIG_H

#include "userDef.h"

#define DMASG_CAM1_S2MM_CHANNEL         0
#define DMASG_CAM1_S2MM_PORT            0

#define DMASG_CAM2_S2MM_CHANNEL         1
#define DMASG_CAM2_S2MM_PORT            0

#define DMASG_DISPLAY_MM2S_CHANNEL      2
#define DMASG_DISPLAY_MM2S_PORT         0

#define DMASG_HW_ACCEL_S2MM_CHANNEL     3
#define DMASG_HW_ACCEL_S2MM_PORT        0

#define DMASG_HW_ACCEL_MM2S_1_CHANNEL   4
#define DMASG_HW_ACCEL_MM2S_1_PORT      0

#define DMASG_HW_ACCEL_MM2S_2_CHANNEL   5
#define DMASG_HW_ACCEL_MM2S_2_PORT      0

// Declarations only — defined in dma.c
void trap_entry();
void crash();
void dma_init();
void trap();

#endif