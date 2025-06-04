////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2025 Efinix Inc. All rights reserved.
// Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
////////////////////////////////////////////////////////////////////////////////

#ifndef EFX_SEMIHOSTING_H
#define EFX_SEMIHOSTING_H

/*******************************************************************************
/**
* @file semihosting.h
*
* @brief Header file for ARM semihosting functions that allow input and output operations 
*        with the debug console of ARM-based systems using semihosting operations.
*
* The available functions are:
* - sh_write0: Writes a zero-terminated string to the debug console.
* - sh_writec: Writes a single character to the debug console.
* - sh_readc: Reads a single character from the debug console.
*
* @note    The exact behavior of these functions may depend on the underlying
*          semihosting implementation and debugger.
*
******************************************************************************/


#include "bsp.h"
#include "vexriscv.h"

/*******************************************************************************
* @brief Definitions of ARM semihosting operation numbers.
*
* @note This enumeration defines the ARM semihosting operation numbers along with their
*       corresponding hexadecimal values. These operation numbers are used to identify
*       different semihosting operations when making semihosting system calls. This
*       enumeration contains the ARM semihosting operations in lexicographic order.
*
******************************************************************************/

#define RISCV_SEMIHOSTING_CALL_NUMBER 7
enum semihosting_operation_numbers {
    /*
     * ARM semihosting operations, in lexicographic order.
     */
    SEMIHOSTING_ENTER_SVC           = 0x17, /* DEPRECATED */

    SEMIHOSTING_SYS_CLOSE           = 0x02,
    SEMIHOSTING_SYS_CLOCK           = 0x10,
    SEMIHOSTING_SYS_ELAPSED         = 0x30,
    SEMIHOSTING_SYS_ERRNO           = 0x13,
    SEMIHOSTING_SYS_EXIT            = 0x18,
    SEMIHOSTING_SYS_EXIT_EXTENDED   = 0x20,
    SEMIHOSTING_SYS_FLEN            = 0x0C,
    SEMIHOSTING_SYS_GET_CMDLINE     = 0x15,
    SEMIHOSTING_SYS_HEAPINFO        = 0x16,
    SEMIHOSTING_SYS_ISERROR         = 0x08,
    SEMIHOSTING_SYS_ISTTY           = 0x09,
    SEMIHOSTING_SYS_OPEN            = 0x01,
    SEMIHOSTING_SYS_READ            = 0x06,
    SEMIHOSTING_SYS_READC           = 0x07,
    SEMIHOSTING_SYS_REMOVE          = 0x0E,
    SEMIHOSTING_SYS_RENAME          = 0x0F,
    SEMIHOSTING_SYS_SEEK            = 0x0A,
    SEMIHOSTING_SYS_SYSTEM          = 0x12,
    SEMIHOSTING_SYS_TICKFREQ        = 0x31,
    SEMIHOSTING_SYS_TIME            = 0x11,
    SEMIHOSTING_SYS_TMPNAM          = 0x0D,
    SEMIHOSTING_SYS_WRITE           = 0x05,
    SEMIHOSTING_SYS_WRITEC          = 0x03,
    SEMIHOSTING_SYS_WRITE0          = 0x04,
};

/*******************************************************************************
* @brief This function is used for making a semihosting call to the host.
*
* @param reason: The reason code for the semihosting call.
* @param arg: A pointer to an argument to be passed to the host.
*
* @return The return value from the semihosting call.
*
* @note This function uses inline assembly to issue a sequence of RISC-V instructions
*       to perform the semihosting call. It ensures that the call is always inlined
*       into the calling code using the "always_inline" attribute.
*
******************************************************************************/
static inline int __attribute__ ((always_inline)) call_host(int reason, void* arg) {
    register int value asm ("a0") = reason;
    register void* ptr asm ("a1") = arg;
    asm volatile (
        " .option push \n"
        // Force non-compressed RISC-V instructions
        " .option norvc \n"
        // Force 16-byte alignment to make sure that the 3 instructions fall
        // within the same virtual page.
        // Note: align 4 means, align by 2 to the power of 4!
        " .align 4 \n"
        " slli x0, x0, 0x1f \n"
        " ebreak \n"
        " srai x0, x0, %[swi] \n"
        " .option pop \n"
        " nop \n"

        : "=r" (value) /* Outputs */
        : "0" (value), "r" (ptr), [swi] "i" (RISCV_SEMIHOSTING_CALL_NUMBER) /* Inputs */
        : "memory" /* Clobbers */
    );
    return value;
}

/*******************************************************************************
* @brief This function write a zero-terminated string to the debug console.
*
* @param   buf: Pointer to the zero-terminated string to be written.
*
* @return  None.
*
* @note    None.
*
******************************************************************************/

static void sh_write0(char* buf)
{
    // Print zero-terminated string
    call_host(SEMIHOSTING_SYS_WRITE0, (void*) buf);
}

/*******************************************************************************
*
* @brief This function writes a single character to the debug console using the ARM
*        semihosting system call for writing a character.
*
* @param   c: The character to be written to the debug console.
*
* @return  None.
*
* @note    None.
*
******************************************************************************/
static void sh_writec(char c)
{
    // Print single character
    call_host(SEMIHOSTING_SYS_WRITEC, (void*)&c);
}

/*******************************************************************************
*
* @brief This function reads a single character from the debug console using the ARM
*        semihosting system call for reading a character. Note that this is a blocking
*        operation.
*
* @return  The character read from the debug console.
*
* @note    None.
*
******************************************************************************/

static char sh_readc(void)
{
    // Read character - Blocking operation!
    return call_host(SEMIHOSTING_SYS_READC, (void*)0);
}


#endif // EFX_SEMIHOSTING_H
