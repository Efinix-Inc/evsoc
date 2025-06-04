///////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 2025 SaxonSoc contributors
//  SPDX license identifier: MIT
//  Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
//////////////////////////////////////////////////////////////////////////////////

/******************************************************************************
*
* @file main.c: inlineAsmDemo
*
* @brief  This demo illustrates utilizing the inline assembly feature. The inline 
*         assembly feature allows user to embed assembly language code into high-level
*         code such as C and C++ whenever user need to implement low-level operations 
*         or improve the performance.
*
* @note   The following are demonstrations of inlineAsmDemo applications
*         • Integer arithmetic operations
*         • Looping implementation
*         • if-else implementation
*         • Memory access
*         • Proper use of general-purpose register (x0 – x31)
*         • Exchange of values between the inline assembly and C
*
******************************************************************************/

#include "bsp.h"
#include "gpio.h"

#ifdef SYSTEM_GPIO_0_IO_CTRL
//#define C_IMPLEMENTATION 1 // uncomment this to use C high level implementation
#define GPIO0 SYSTEM_GPIO_0_IO_CTRL

/******************************************************************************
*
* @brief This function reads data from the UART register. It continuously checks
*        the occupancy of the UART register and reads data until the register is
*        empty. It then returns the last data read.       
*
* @param reg: UART register address to read from
*
* @return:   Data read from the UART register
*
******************************************************************************/
uint8_t read_uart(u32 reg) // function implementation in C
{
  uint8_t dat = 0;
  while(uart_readOccupancy(reg))
  {
    dat=uart_read(reg);
  }
  return dat;
}

#ifdef C_IMPLEMENTATION // C implemented main function
/******************************************************************************
*
* @brief Main Function - C Implementation
*
* @note This function demonstrates a simple C implementation with C implementation.
*       It initializes the system and GPIOs, then enters a loop where it increments
*       a counter and sets GPIO outputs based on the counter value.
*       The LEDs can be reset by pressing 'r' on the UART terminal.
*
******************************************************************************/

void main()
{
    int i = 0;
    u8 p = 0;
    bsp_printf("Inline Assembly Demo\r\n");
    bsp_printf("Demonstrating C implementation\r\n");
    bsp_printf("Reset the LEDs by pressing 'r' \r\n");
    gpio_setOutputEnable(GPIO0,0xe);
    gpio_setOutput(GPIO0,0x0);
    while(1){
        i=i+1;
        if((i>>24) & 0x01){
            p = read_uart(BSP_UART_TERMINAL);
            while (p!='r'){
                p = read_uart(BSP_UART_TERMINAL);
            }
            i = 0;
        } else {
            p=(i >> 20);
        }
        gpio_setOutput(GPIO0, p);
    }
}
#else //Assembly Implementation

/******************************************************************************
*
* @brief Main Function - Assembly Implementation
*
* @note This function demonstrates a main implementation using inline assembly.
*       The main function initializes the system and GPIOs, then enters a loop 
*       with inline assembly for the main operations including counter 
*       incrementation, checking the UART input, and setting GPIO outputs.
*       The LEDs can be reset by pressing 'r' on the UART terminal.
*
******************************************************************************/
void main() //implementation in inline assembly except function call
{
    uint8_t p=0;
    bsp_printf("Inline Assembly Demo\r\n");
    bsp_printf("Reset the LEDs by pressing 'r' \r\n");
    __asm__ __volatile__
          (
          "li %[p], 0\n"                    // Load immediate: load constant zero into variable p
          "li t1, 0\n"                      // Load immediate: load constant zero into t1 register
        //Assign address for GPIO port
          "lui t2, %[gpio]\n"               // load upper immediate: load t2 with 0xf8015 with last 12 bit set to 0 which indicates 0xf8015000
          "lui t3, %[gpio]\n"               // load upper immediate: load t3 with 0xf8015 / last 12 bit set to 0 which indicates 0xf8015000
        //Assign output enable for GPIO port, refer to line "gpio_setOutputEnable(GPIO,0xe)"
          "li t4, 14\n"                     // load immediate: load 0x0e into t4
          "sw t4, 8(t2)\n"                  // store word: store t4 data into t2 (offset 8) = output enable register
        //Store value "0" to the memory address of the GPIO port as initial value of GPIO port.
          "sw zero, 4(t2)\n"                // store word: store zero into t2 (offset 4)=output register
        // While loop starts here
    "1:"  "addi t1, t1, 1\n"                // Add immediate: add 1 to t1 and store it in t1 (C Code = i=i+1). Label `1:`.
          "srli t2, t1, 24\n"               // Shift right logical immediate: shift right t1 by 24 and store it in t2 (C Code = i>>24)
          "li t5, 1\n"                      // load immediate: load t5 register with value 1
          "and t2, t2, t5\n"                // And operation: AND t2 with t5 and store it in t2
          "beqz t2, 4f\n"                   // branch if equal to zero: if t2 equal zero, jump to 4f
  "loop:" "li t6, 'r'\n"                    // load immediate: load character 'r' to register t6. Label `loop`.
        //Output operand
          :[p] "+r" (p)                     // Variable p is used as input and output
          :[gpio] "i" ((GPIO0 >> 12) & 0xFFFFF) // input operand using GPIO0 define
        );

        //Function call in C
        p=read_uart(BSP_UART_TERMINAL);     // get the uart character and put it into variable p

    __asm__ __volatile__
          (
        //The third "if" statement
          "bne %[p], t6, loop\n"            // branch if not equal zero: Go to label loop if p is not zero ti read from uart again
          "li t1,0\n"                       // reset i = 0
        //Assign Value P to GPIO port
    "2:"  "andi %[p], %[p], 255\n"          // AND with immediate value. Perform and operation on P with 0xFF and store into variable p. Label `2:`.
    "3:"  "sw %[p], 4(t3)\n"                // store word. store variable p value into register t3(offset 4): output register (C code = gpio_set Output()). Label `3:`.
          "j 1b\n"                          // Jump to 1b = '1:'. Go back to start of while loop
        //The "else" statement
    "4:"  "srai %[p], t1, 0x14\n"           // shift right arithmetic immediate. Shift right by 20 bits on value t1 and put it into variable p. Label `4`.
          "j 2b\n"                          // Jump to 2b = '2:'
        //Output operand
          :[p] "+r" (p)                     // Variable p is used as input and output
        );
}
#endif
#else
/******************************************************************************
*
* @brief This main function is executed when GPIO functionality is disabled.
*        It initializes the BSP and prints a message indicating that
*        GPIO 0 is disabled, and the user should enable it to run the app.
*
******************************************************************************/
void main() {
    bsp_init();
    bsp_printf("gpio 0 is disabled, please enable it to run this app.\r\n");
}
#endif
