///////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 2025 SaxonSoc contributors
//  SPDX license identifier: MIT
//  Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
//////////////////////////////////////////////////////////////////////////////////

/******************************************************************************
*
* @file main.c: i2cSlaveDemo
*
* @brief This demo demonstrate how to configure Sapphire SoC as an I2C Slave device, emulating
*        the behavior of an I2C EEPROM device. You may use the I2CMasterDemo to act as the
*        master to control this slave device.
*
* @note  Please ensure you've configured the correct address and and number of byte of register
*        address.
*        Please also ensure your hardware and RTL connected the SDA and SCL with pull-up resistors.
*        You may run this demo on a Sapphire SoC while the I2CMasterDemo on another Sapphire SoC,
*        on the same or different board/ device.
*        It assume it is the single master on the bus, and send frame in a blocking manner.
*        Please enable printf_full for a cleaner UART printout.
*
******************************************************************************/

#include <stdint.h>
#include "bsp.h"
#include "riscv.h"
#include "clint.h"
#include "plic.h"
#include "i2c.h"
#include "userDef.h"

#define MEM_SIZE        256     // Size of the memory
#define I2C_SLAVE_ADDR  0x67    // Slave device address
#define WORD_REG_ADDR   0       // Set 0 if master only expect to send 1-byte of register address, else set 1.#define I2C_SLAVE_ADDR 0x67   // Slave device address
#define I2C_FREQUENCY   100000  // Set your I2C Frequency here
unsigned char addr0 = 0x00;     // MSB
unsigned char addr1 = 0x00;     // LSB
u16 addr = 0x00;
unsigned char data0[MEM_SIZE];

#ifdef SYSTEM_I2C_0_IO_CTRL

void main();
void init();
void trap();
void crash();
void trap_entry();
void externalInterrupt();
void externalInterrupt_i2c();

//I2C interrupt state
enum {
    IDLE,
    Write_Addr_0,
    Write_Addr_1,
    Read_DATA_0,
    Write_DATA_0
} state = IDLE;

I2c_Config i2c;

/******************************************************************************
*
* @brief This function initiates the configuration of I2C by setting it to 100kHz and enable I2c interrupt. 
*
* @param i2c.samplingClockDivider => Sampling rate = (FCLK/(samplingClockDivider + 1).
* 							   	  => Controls the rate at which the I2C controller samples SCL and SDA.
*
* @param i2c.timeout => Inactive timeout clock cycle. The controller will drop the transfer when the value of the timeout is reached or exceeded.
* 				  => Setting the timeout value to zero will disable the timeout feature.
*
* @param i2c.tsuDat  => Data setup time. The number of clock cycles should SDA hold its state before the rising edge of SCL.
* @param i2c.tLow    => The number of clock cycles of SCL in LOW state.
* @param i2c.tHigh   => The number of clock cycles of SCL in HIGH state.
* @param i2c.tBuf 	 => The number of clock cycles delay before master can initiate a START bit after a STOP bit is issued.
* @return None.
*
******************************************************************************/
void init(){
    //I2C init
        i2c.samplingClockDivider    = 3;                            // Sampling rate = (FCLK/(samplingClockDivider + 1). Controls the rate at which the I2C controller samples SCL and SDA.
        i2c.timeout                 = I2C_CTRL_HZ/10;               // 100 ms; // Inactive timeout clock cycle. The controller will drop the transfer when the value of the timeout is reached or exceeded. Setting the timeout value to zero will disable the timeout feature.
        i2c.tsuDat                  = I2C_CTRL_HZ/I2C_FREQUENCY/3;  // Data setup time. The number of clock cycles should SDA hold its state before the rising edge of SCL. Refer to your I2C slave datasheet.
        i2c.tLow                    = I2C_CTRL_HZ/I2C_FREQUENCY/2;  // The number of clock cycles of SCL in LOW state.
        i2c.tHigh                   = I2C_CTRL_HZ/I2C_FREQUENCY/2;  // The number of clock cycles of SCL in HIGH state.
        i2c.tBuf                    = I2C_CTRL_HZ/I2C_FREQUENCY;    // The number of clock cycles delay before master can initiate a START bit after a STOP bit is issued. Refer to your I2C slave datasheet.
    i2c_applyConfig(I2C_CTRL, &i2c);

    i2c_setFilterConfig(I2C_CTRL, 0, I2C_SLAVE_ADDR | I2C_FILTER_7_BITS | I2C_FILTER_ENABLE);
    i2c_enableInterrupt(I2C_CTRL, I2C_INTERRUPT_FILTER);

    //configure PLIC
    plic_set_threshold(BSP_PLIC, BSP_PLIC_CPU_0, 0);

    //enable PLIC I2C interrupts
    plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, I2C_CTRL_PLIC_INTERRUPT, 1);
    plic_set_priority(BSP_PLIC, I2C_CTRL_PLIC_INTERRUPT, 1);

    //configure RISC-V interrupt CSR
    //Set the machine trap vector (trap.S)
    csr_write(mtvec, trap_entry);
    //Enable machine external interrupts
    csr_write(mie, MIE_MEIE);
    //Enable interrupts
    csr_write(mstatus, csr_read(mstatus) | MSTATUS_MPP | MSTATUS_MIE);

}

/******************************************************************************
*
* @brief This function checks the provided condition. If the condition is false,
*        it prints an "Assert failure" message and enters an infinite loop,
*        effectively halting the program.
*
* @param cond Condition to check
*
******************************************************************************/
void assert(int cond){
    if(!cond) {
        bsp_printf("Assert failure \r\n");
        while(1);
    }
}


/******************************************************************************
*
* @brief This function handles exceptions and interrupts in the system.
*
* @note It is called by the trap_entry function on both exceptions and interrupts 
* 		events. If the cause of the trap is an interrupt, it checks the cause of 
* 		the interrupt and calls corresponding interrupt handler functions. If 
* 		the cause is an exception or an unhandled interrupt, it calls a 
*		crash function to handle the error.
*
******************************************************************************/
void trap(){
    int32_t mcause = csr_read(mcause);
    int32_t interrupt = mcause < 0;
    int32_t cause     = mcause & 0xF;

    if(interrupt){
        switch(cause){
        case CAUSE_MACHINE_EXTERNAL: externalInterrupt(); break;
        default: crash(); break;
        }
    }
    else
    {
      crash();
    }
}
/******************************************************************************
*
* @brief This function handles I2C interrupts by claiming pending interrupts 
* 		 and processing them through externalInterrupt_i2c().
*
******************************************************************************/
void externalInterrupt(){
    uint32_t claim;
    //While there is pending interrupts
    while(claim = plic_claim(BSP_PLIC, BSP_PLIC_CPU_0)){
        switch(claim){
        case I2C_CTRL_PLIC_INTERRUPT: externalInterrupt_i2c(); break;
        default:crash(); break;
        }
        //unmask the claimed interrupt
        plic_release(BSP_PLIC, BSP_PLIC_CPU_0, claim);
    }
}

/******************************************************************************
*
* @brief This function handles the system crash scenario by printing a crash message
* 		 and entering an infinite loop.
*
******************************************************************************/
void crash(){
    bsp_printf("\r\n*** CRASH ***\r\n");
    while(1);
}

/******************************************************************************
*
* @brief This function handles external interrupts for I2C communication.
*        It manages I2C read and write operations based on the received data.
*
******************************************************************************/

void externalInterrupt_i2c(){

    u32 irq_status = i2c_getInterruptFlag(I2C_CTRL);
    if (irq_status & I2C_INTERRUPT_FILTER) {
        i2c_disableInterrupt(I2C_CTRL, I2C_INTERRUPT_TX_DATA);
        state = IDLE;
    }

    switch(state){
    case IDLE:
        //I2C filter 0 hit => frame for us
        if(i2c_getFilteringHit(I2C_CTRL) == 1){
            //read
            if(i2c_getFilteringStatus(I2C_CTRL) == 1){ // Read Operation requested from master
                i2c_txAck(I2C_CTRL);
                i2c_txByte(I2C_CTRL, data0[addr0]); // Send First Read Value to Master
                state = Read_DATA_0;
            } else { // Write Operation requested from master
                i2c_txAck(I2C_CTRL);
                i2c_txByte(I2C_CTRL, 0xFF);
                state = Write_Addr_0;
            }

            i2c_enableInterrupt(I2C_CTRL, I2C_INTERRUPT_TX_DATA); // Enable the TX Data interrupt
        }
        else
        {
            bsp_printf("unknown condition\n\r"); // Interrupt occurred but the interrupt is not due to correct address received.
            state = IDLE;
        }
        i2c_clearInterruptFlag(I2C_CTRL, I2C_INTERRUPT_FILTER);

        break;

#if ( WORD_REG_ADDR == 1) // 2-Byte Register Address Selected
        //Write frame 0 to us
        case Write_Addr_0:
            i2c_txAck(I2C_CTRL);
            i2c_txByte(I2C_CTRL, 0xFF);
            //Get First register address byte from Master
            addr0 = i2c_rxData(I2C_CTRL);
            state = Write_Addr_1;
            break;

            //Write frame to us
        case Write_Addr_1:
            i2c_txAck(I2C_CTRL);
            i2c_txByte(I2C_CTRL, 0xFF);
            //Get second register address byte from Master
            addr1 = i2c_rxData(I2C_CTRL);
            addr = (addr0 << 8) | addr1; // concatenate 2 bytes of register address into a 16-bit address.
            state = Write_DATA_0;
            break;

        case Write_DATA_0:
            i2c_txAck(I2C_CTRL);
            i2c_txByte(I2C_CTRL, 0xFF);
            //Get Value from Master
            data0[addr] = i2c_rxData(I2C_CTRL);
            state = Write_DATA_0; // Continue remain at here if there is more write data received.
            addr++; // Increment the address to store the value.
            break;

        //Read frame to us
        case Read_DATA_0:
            addr++;
            i2c_txNack(I2C_CTRL);
            // Send second Read Value to Master
            i2c_txByte(I2C_CTRL, data0[addr]); // Write selected register data back to master
            state = Read_DATA_0;
            break;

#else // 1-Byte Register Address Selected
        //Write frame to us
        case Write_Addr_0:
            i2c_txAck(I2C_CTRL);
            i2c_txByte(I2C_CTRL, 0xFF);
            //Get register address from Master
            addr0 = i2c_rxData(I2C_CTRL);
            state = Write_DATA_0;
            break;

        case Write_DATA_0:
            i2c_txAck(I2C_CTRL);
            i2c_txByte(I2C_CTRL, 0xFF);
            //Get Value from Master
            data0[addr0] = i2c_rxData(I2C_CTRL);
            state = Write_DATA_0; // Continue here if more data receiving from master
            addr0++; // Increment the address to store the value.
            break;

        //Read frame to us
        case Read_DATA_0:
            addr0++;
            i2c_txNack(I2C_CTRL);
            // Send second Read Value to Master
            i2c_txByte(I2C_CTRL, data0[addr0]);
            state = Read_DATA_0;
            break;
#endif


    }
}

/******************************************************************************
*
* @brief  This function displays the content of the memory. It prints the memory content
*         in a formatted manner, displaying 16 bytes per line with corresponding memory 
*         addresses.
*
******************************************************************************/

void display_memory_content()
{
    int i, j;
    int count = 0;

    bsp_printf("\n\r     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f\n\r");
    for (i = 0; i < MEM_SIZE; i+=16) {
        bsp_printf("%2x: ", i);
        for (j = 0; j < 16; j++) {
            bsp_printf("%2x ", data0[count++]);
        }
        bsp_printf("\n\r");
    }

    bsp_printf("\n\r");
}


/******************************************************************************
*
* @brief This main function initializes the system, sets up the I2C slave configuration,
*       displays memory content, and waits for user input to display memory content.
*
******************************************************************************/
void main() {
    int n;
    u32 irq_status;
    char key;

    bsp_init();
    for(n=0;n<MEM_SIZE;n++)
    {
        data0[n]=0xff;
    }

    init();
    bsp_printf("i2c 0 slave demo ! \r\n");
    bsp_printf("i2c 0 init done \r\n");
    bsp_printf("This device will act as I2C Slave with 8 bit x 256 memory\n\r");
    bsp_printf("Configurations: \r\nSlave Address = 0x%x \r\nTimeout setting = 0x%x\r\nTsu = %i \r\ntLow = %i\r\ntHigh = %i\r\ntBuf = %i\r\n", I2C_SLAVE_ADDR, i2c.timeout, i2c.tsuDat, i2c.tLow, i2c.tHigh, i2c.tBuf);


    display_memory_content();

    while (1) {
        bsp_printf("Press i to show the memory content of I2C slave\n\r");
        bsp_printf(">> ");
        key = uart_read(BSP_UART_TERMINAL);
        if (key == 'i') {
            display_memory_content();
        }
    }
}
#else
/******************************************************************************
*
* @brief This main function is executed when I2C functionality is disabled.
*        It initializes the BSP and prints a message indicating that
*        I2C 0 is disabled, and the user should enable it to run the app.
*
******************************************************************************/

void main() {
    int n;
    bsp_init();
    bsp_printf("i2c 0 is disabled, please enable it to run this app \r\n");
}
#endif

