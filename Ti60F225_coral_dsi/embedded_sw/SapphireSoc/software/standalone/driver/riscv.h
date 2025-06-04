///////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 2025 SaxonSoc contributors
//  SPDX license identifier: MIT
//  Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
///////////////////////////////////////////////////////////////////////////////////

/*******************************************************************************
*
* @file riscv.h 
*
* @brief Header file containing RISC-V related functions and definitions.
*
* Functions:
*   csr_read(csr_name): Accessing registers.
*   csr_read_set(csr, val): reading and setting a CSR with a specified value.
*   csr_read_clear(csr, val) for performing a read-clear operation on the specified CSR.
*   csr_write(csr_name): Accessing registers.
*   csr_clear(csr, val) for clearing a CSR.
*   csr_set(csr_name, new_value): Setting CSR.
*   csr_swap(csr_name, new_value): Swapping a CSR.
*   opcode_R(opcode, func3, func7, rs1, rs2): Performing R-type instruction operation.
	
******************************************************************************/

#pragma once

//exceptions
#define CAUSE_ILLEGAL_INSTRUCTION       2
#define CAUSE_MACHINE_TIMER             7
#define CAUSE_SCALL                     9
//interrupts
#define CAUSE_MACHINE_EXTERNAL          11
#define MEDELEG_INSTRUCTION_PAGE_FAULT  (1 << 12)
#define MEDELEG_LOAD_PAGE_FAULT         (1 << 13)
#define MEDELEG_STORE_PAGE_FAULT        (1 << 15)
#define MEDELEG_USER_ENVIRONNEMENT_CALL (1 << 8)
#define MIDELEG_SUPERVISOR_SOFTWARE     (1 << 1)
#define MIDELEG_SUPERVISOR_TIMER        (1 << 5)
#define MIDELEG_SUPERVISOR_EXTERNAL     (1 << 9)
#define MIP_STIP                        (1 << 5)
#define MIE_MTIE                        (1 << CAUSE_MACHINE_TIMER)
#define MIE_MEIE                        (1 << CAUSE_MACHINE_EXTERNAL)
#define MSTATUS_UIE                     0x00000001
#define MSTATUS_SIE                     0x00000002
#define MSTATUS_HIE                     0x00000004
#define MSTATUS_MIE                     0x00000008
#define MSTATUS_UPIE                    0x00000010
#define MSTATUS_SPIE                    0x00000020
#define MSTATUS_HPIE                    0x00000040
#define MSTATUS_MPIE                    0x00000080
#define MSTATUS_SPP                     0x00000100
#define MSTATUS_HPP                     0x00000600
#define MSTATUS_MPP                     0x00001800
#define MSTATUS_FS                      0x00006000
#define MSTATUS_XS                      0x00018000
#define MSTATUS_MPRV                    0x00020000
#define MSTATUS_SUM                     0x00040000
#define MSTATUS_MXR                     0x00080000
#define MSTATUS_TVM                     0x00100000
#define MSTATUS_TW                      0x00200000
#define MSTATUS_TSR                     0x00400000
#define MSTATUS32_SD                    0x80000000
#define MSTATUS_UXL                     0x0000000300000000
#define MSTATUS_SXL                     0x0000000C00000000
#define MSTATUS64_SD                    0x8000000000000000
#define SSTATUS_UIE                     0x00000001
#define SSTATUS_SIE                     0x00000002
#define SSTATUS_UPIE                    0x00000010
#define SSTATUS_SPIE                    0x00000020
#define SSTATUS_SPP                     0x00000100
#define SSTATUS_FS                      0x00006000
#define SSTATUS_XS                      0x00018000
#define SSTATUS_SUM                     0x00040000
#define SSTATUS_MXR                     0x00080000
#define SSTATUS32_SD                    0x80000000
#define SSTATUS_UXL                     0x0000000300000000
#define SSTATUS64_SD                    0x8000000000000000
#define PMP_R                           0x01
#define PMP_W                           0x02
#define PMP_X                           0x04
#define PMP_A                           0x18
#define PMP_L                           0x80
#define PMP_SHIFT                       2
#define PMP_TOR                         0x08
#define PMP_NA4                         0x10
#define PMP_NAPOT                       0x18
//Read-only cycle Cycle counter for RDCYCLE instruction.
#define RDCYCLE                         0xC00 
//Read-only time Timer for RDTIME instruction.
#define RDTIME                          0xC01 
//Read-only instret Instructions-retired counter for RDINSTRET instruction.
#define RDINSTRET                       0xC02 
//Read-only cycleh Upper 32 bits of cycle, RV32I only.
#define RDCYCLEH                        0xC80 
//Read-only timeh Upper 32 bits of time, RV32I only.
#define RDTIMEH                         0xC81 
//Read-only instreth Upper 32 bits of instret, RV32I only.
#define RDINSTRETH                      0xC82 


/*******************************************************************************
*
* @brief This function is used to swap the value of a CSR with a specified value.
*
* @param   csr: The name of the CSR to be swapped.
* @param   val: The value to be swapped with the CSR.
*
* @return  The previous value of the CSR.
*
* This macro performs a swap operation using CSR instructions in RISC-V assembly. It reads the
* current value of the CSR, writes the specified value to the CSR, and returns the previous value
* of the CSR before the write operation. It allows for efficient manipulation of CSRs in RISC-V
* assembly code.
*
******************************************************************************/

#define csr_swap(csr, val)                    \
({                                \
    unsigned long __v = (unsigned long)(val);        \
    __asm__ __volatile__ ("csrrw %0, " #csr ", %1"        \
                  : "=r" (__v) : "rK" (__v));    \
    __v;                            \
})

/*******************************************************************************
*
* @brief This function is used to read the value of a CSR.
*
* @param   csr: The name of the CSR to be read.
*
* @return  The value of the CSR.
*
* This macro reads the current value of the specified CSR using CSR instructions in RISC-V
* assembly. It returns the value of the CSR, allowing for efficient access to CSRs in RISC-V
* assembly code.
*
******************************************************************************/

#define csr_read(csr)                        \
({                                \
    register unsigned long __v;                \
    __asm__ __volatile__ ("csrr %0, " #csr            \
                  : "=r" (__v));            \
    __v;                            \
})


/*******************************************************************************
*
* @brief This function is used to write a value to a CSR.
*
* @param   csr: The name of the CSR to which the value will be written.
* @param   val: The value to be written to the CSR.
*
* This macro writes the specified value to the specified CSR using CSR instructions
* in RISC-V assembly. It allows for efficient modification of CSRs in RISC-V assembly
* code.
*
******************************************************************************/

#define csr_write(csr, val)                    \
({                                \
    unsigned long __v = (unsigned long)(val);        \
    __asm__ __volatile__ ("csrw " #csr ", %0"        \
                  : : "rK" (__v));            \
})

/*******************************************************************************
*
* @brief This function is used to read and set a CSR with a specified value.
*
* @param   csr: The name of the CSR to be read and set.
* @param   val: The value to be ORed with the current value of the CSR.
*
* @return  The previous value of the CSR before the set operation.
*
* This macro reads the current value of the specified CSR, ORs it with the specified value,
* and writes the result back to the CSR using CSR instructions in RISC-V assembly. It returns
* the previous value of the CSR before the set operation.
*
******************************************************************************/

#define csr_read_set(csr, val)                    \
({                                \
    unsigned long __v = (unsigned long)(val);        \
    __asm__ __volatile__ ("csrrs %0, " #csr ", %1"        \
                  : "=r" (__v) : "rK" (__v));    \
    __v;                            \
})

/*******************************************************************************
*
* @brief This function is used to set a CSR to a specified value.
*
* @param   csr: The name of the CSR to be set.
* @param   val: The value to be set for the CSR.
*
******************************************************************************/
#define csr_set(csr, val)                    \
({                                \
    unsigned long __v = (unsigned long)(val);        \
    __asm__ __volatile__ ("csrs " #csr ", %0"        \
                  : : "rK" (__v));            \
})

/*******************************************************************************
*
* @brief This function is used for performing a read-clear operation on the specified CSR.
*
* @param csr The Control and Status Register (CSR) to read-clear.
* @param val The value to use for the operation.
* @return The previous value of the CSR before the read-clear operation.
*
******************************************************************************/

#define csr_read_clear(csr, val)                \
({                                \
    unsigned long __v = (unsigned long)(val);        \
    __asm__ __volatile__ ("csrrc %0, " #csr ", %1"        \
                  : "=r" (__v) : "rK" (__v));    \
    __v;                            \
})

/********************************************************************************
*
* @brief This function is used to clear a CSR.
*
* @param csr: The name of the CSR to be cleared.
* @param val: The value to be used for the operation (unused in clearing).
*
* @note This macro clears the specified CSR using the "csrc" instruction in RISC-V assembly.
*       It takes the CSR name and a value as parameters, but the value parameter is unused
*       as clearing a CSR typically does not involve any additional value.
*
******************************************************************************/

#define csr_clear(csr, val)                    \
({                                \
    unsigned long __v = (unsigned long)(val);        \
    __asm__ __volatile__ ("csrc " #csr ", %0"        \
                  : : "rK" (__v));            \
})


/*******************************************************************************
* @brief Definition of symbolic constants for RISC-V registers.
*
* General-purpose registers (x0-x31):
*   Lines 1-32 define constants regnum_x0 through regnum_x31 for the 32 general-
*   purpose registers.
*
* Special-purpose registers:
*   Lines 34-63 define constants for special-purpose registers such as zero, ra,
*   sp, gp, tp, and the temporary registers t0-t6.
*
* Custom register:
*   Line 65 defines a symbolic constant CUSTOM0 for a custom register, which
*   could be used for a specific purpose defined by the programmer.
*
******************************************************************************/
asm(".set regnum_x0  ,  0");
asm(".set regnum_x1  ,  1");
asm(".set regnum_x2  ,  2");
asm(".set regnum_x3  ,  3");
asm(".set regnum_x4  ,  4");
asm(".set regnum_x5  ,  5");
asm(".set regnum_x6  ,  6");
asm(".set regnum_x7  ,  7");
asm(".set regnum_x8  ,  8");
asm(".set regnum_x9  ,  9");
asm(".set regnum_x10 , 10");
asm(".set regnum_x11 , 11");
asm(".set regnum_x12 , 12");
asm(".set regnum_x13 , 13");
asm(".set regnum_x14 , 14");
asm(".set regnum_x15 , 15");
asm(".set regnum_x16 , 16");
asm(".set regnum_x17 , 17");
asm(".set regnum_x18 , 18");
asm(".set regnum_x19 , 19");
asm(".set regnum_x20 , 20");
asm(".set regnum_x21 , 21");
asm(".set regnum_x22 , 22");
asm(".set regnum_x23 , 23");
asm(".set regnum_x24 , 24");
asm(".set regnum_x25 , 25");
asm(".set regnum_x26 , 26");
asm(".set regnum_x27 , 27");
asm(".set regnum_x28 , 28");
asm(".set regnum_x29 , 29");
asm(".set regnum_x30 , 30");
asm(".set regnum_x31 , 31");

asm(".set regnum_zero,  0");
asm(".set regnum_ra  ,  1");
asm(".set regnum_sp  ,  2");
asm(".set regnum_gp  ,  3");
asm(".set regnum_tp  ,  4");
asm(".set regnum_t0  ,  5");
asm(".set regnum_t1  ,  6");
asm(".set regnum_t2  ,  7");
asm(".set regnum_s0  ,  8");
asm(".set regnum_s1  ,  9");
asm(".set regnum_a0  , 10");
asm(".set regnum_a1  , 11");
asm(".set regnum_a2  , 12");
asm(".set regnum_a3  , 13");
asm(".set regnum_a4  , 14");
asm(".set regnum_a5  , 15");
asm(".set regnum_a6  , 16");
asm(".set regnum_a7  , 17");
asm(".set regnum_s2  , 18");
asm(".set regnum_s3  , 19");
asm(".set regnum_s4  , 20");
asm(".set regnum_s5  , 21");
asm(".set regnum_s6  , 22");
asm(".set regnum_s7  , 23");
asm(".set regnum_s8  , 24");
asm(".set regnum_s9  , 25");
asm(".set regnum_s10 , 26");
asm(".set regnum_s11 , 27");
asm(".set regnum_t3  , 28");
asm(".set regnum_t4  , 29");
asm(".set regnum_t5  , 30");
asm(".set regnum_t6  , 31");

asm(".set CUSTOM0  , 0x0B");
asm(".set CUSTOM1  , 0x2B");
asm(".set CUSTOM2  , 0x5B");

/********************************************************************************
* @brief opcode_R(opcode, func3, func7, rs1, rs2)  for generating the opcode of an R-type instruction.
*
* @param   opcode: The base opcode value for the instruction.
* @param   func3: The 3-bit function field.
* @param   func7: The 7-bit function field.
* @param   rs1: Register number for source register 1.
* @param   rs2: Register number for source register 2.
*
* @return  The generated opcode for the R-type instruction.
*
* @note    This macro generates the opcode for an R-type instruction in RISC-V assembly. It takes
*          the base opcode value, function field values (func3 and func7), and register numbers
*          for source registers rs1 and rs2. The resulting opcode is formed by combining the
*          provided values according to the R-type instruction encoding format and returned as
*          an unsigned long integer.
*
******************************************************************************/

#define opcode_R(opcode, func3, func7, rs1, rs2)   \
({                                             \
    register unsigned long __v;                \
    asm volatile(                              \
     ".word ((" #opcode ") | (regnum_%0 << 7) | (regnum_%1 << 15) | (regnum_%2 << 20) | ((" #func3 ") << 12) | ((" #func7 ") << 25));"   \
     : [rd] "=r" (__v)                          \
     : "r" (rs1), "r" (rs2)        \
    );                                         \
    __v;                                       \
})

#define cfu_type_R(func3, func7, rs1, rs2)  opcode_R(CUSTOM0, func3, func7, rs1, rs2)
#define cfu_push(func3, func7, rs1, rs2)    opcode_R(CUSTOM1, func3, func7, rs1, rs2)
#define cfu_pop2() ({ register unsigned long __v; asm volatile( ".word ((0x5B) | (regnum_%0 << 7));" : [rd] "=r" (__v) :   ); __v; })
#define cfu_pop() \
({                                             \
	register unsigned long __v;                \
	asm volatile(                              \
	".word ((0x5B) | (regnum_%0 << 7));"       \
     : [rd] "=r" (__v)                          \
     :                                          \
    );                                         \
    __v;                                       \
})
