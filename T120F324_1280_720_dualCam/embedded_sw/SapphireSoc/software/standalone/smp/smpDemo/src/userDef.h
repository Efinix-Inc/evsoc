////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2025 Efinix Inc. All rights reserved.
// Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
////////////////////////////////////////////////////////////////////////////////

#pragma once
#include "soc.h"

#define STACK_PER_HART 4096

#ifdef SYSTEM_PLIC_SYSTEM_CORES_3_EXTERNAL_INTERRUPT
	#define HART_COUNT 4
#elif SYSTEM_PLIC_SYSTEM_CORES_2_EXTERNAL_INTERRUPT
	#define HART_COUNT 3
#elif SYSTEM_PLIC_SYSTEM_CORES_1_EXTERNAL_INTERRUPT
	#define HART_COUNT 2
#else
	#define HART_COUNT 1
#endif
#define SMP_INUSE       (HART_COUNT > 1)

