////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2026 Efinix Inc. All rights reserved.
// See https://github.com/Efinix-Inc/evsoc/blob/main/LICENSE.txt for details.
////////////////////////////////////////////////////////////////////////////////

#ifndef TEST_HARNESS_H
#define TEST_HARNESS_H

#include "bsp.h"

// Declared here, defined once in main_test.c
extern int _pass;
extern int _fail;

#define TEST(name, condition)                          \
    do {                                               \
        if (condition) {                               \
            bsp_printf("[PASS] %s\n\r", name);        \
            _pass++;                                   \
        } else {                                       \
            bsp_printf("[FAIL] %s\n\r", name);        \
            _fail++;                                   \
        }                                              \
    } while(0)

#define TEST_REPORT() \
    bsp_printf("\n\r=== Results: %d passed, %d failed ===\n\r", _pass, _fail)

#endif
