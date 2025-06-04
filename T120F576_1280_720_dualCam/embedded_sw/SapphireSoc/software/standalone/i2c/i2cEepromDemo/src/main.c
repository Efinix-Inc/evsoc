///////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 2025 SaxonSoc contributors
//  SPDX license identifier: MIT
//  Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
//////////////////////////////////////////////////////////////////////////////////

/*******************************************************************************
*
* @file main.c: i2cEepromDemo (Read/Write On-Board EEPROM AT24C01)
*
* @brief This demo uses the I2C peripheral to communicate with the T120F324 Dev Kit 
* 		 On-Board EEPROM AT24C01. It allows the user to read and write to a specific
*  		 address based on input throughthe UART interface. This example design is 
*		 using UART Interrupt method.
*
* @note To run this example design, please make sure the following requirements are fulfilled:
* 		1. T120F324/ T120F576 Dev Board
* 		2. Enable UART0 and I2C0
*
******************************************************************************/
#include <stdint.h>

#include "bsp.h"
#include "i2c.h"
#include "userDef.h" 
#include "stdlib.h"
#include "riscv.h"
#include "plic.h"
#include "clint.h"
#include "stdio.h"

//function prototype
uint8_t write_data_to_addr(u32 reg, u32 addr, u8 data);
uint8_t read_data_from_addr(u32 reg, u32 addr);
uint8_t current_addr_read(u32 reg);
uint8_t read_multi_byte_data_from_addr(u32 reg, u32 addr, u32 length, u8 *data);
uint8_t write_multi_byte_data_to_addr(u32 reg, u32 addr, u32 length, u8 *data);

unsigned char ascii_to_bin(unsigned char inchar);
void trap_entry();
void trap();
void crash();
void UartInterrupt();

// I2C Related Defines
#define SLAVE_ADDRESS			0xA0
#define WRITE					0x00
#define READ					0x01

// UART Related Defines
#define TARGET_I2C_FREQ 		400000 //400kHz
#define UART_A_SAMPLE_PER_BAUD 	8
#define CORE_HZ 				BSP_CLINT_HZ

#ifdef SYSTEM_I2C_0_IO_CTRL

typedef enum {
	IDLE,
	CHECK_ADDRESS,
	START_OP,
	WAIT_COMPLETION,
	GET_WRITE_DATA,
	RESTART,
	GET_NUM_OF_BYTE
} states;

#define BYTE_OP		 		0x01 // Offset for One byte Operation
#define CURRENT_ADDR_READ 	0x02 // Offset for Read Current Address Operation
#define MULTI_BYTE_OP 		0x03 // Offset for Multi-byte Operation

//Global Variables
char 		new_line_detected	= 0;
uint8_t 	buffer [200];
uint32_t	counter 			= 0;
uint8_t 	write_data 			= 0;
uint8_t 	number_of_byte		= 0;
uint8_t 	read_data 			= 0;
uint32_t 	address 			= 0;

/******************************************************************************
*
* The OPENING_STRING is used to display the message at the beginning of the program
*
******************************************************************************/
#define OPENING_STRING			"T120F324/T120F576 Dev Kit on-board EEPROM, AT24C01 i2c-demo !" \
								"\r\nPlease make sure you are using the T120F324/T120F576 Dev Kit to run this demo! \r\n"
#define FEATURE_SELECT_STRING	"Please choose the feature you would like to run (Key in the selection and press enter): \r\n" \
								"1: Write a byte to EEPROM\r\n2: Read a byte from EEPROM\n\r3: Current Address Read (Last accessed address incremented by 1)\r\n" \
								"4: Read multiple byte from EEPROM\r\n5: Write multiple byte to EEPROM\r\n"
#define INVALID_ADDR_STRING		"Invalid address input, please key in correct address. I.e. 1024 which is in hexadecimal.\r\n"

/******************************************************************************
*
* @brief This function initiates the configuration of I2C and UART by setting I2C speed to 400kHz and baud rate to 115200.
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
*
* @param uartA.dataLength 		=> Enumerated value indicating the data length configuration.
* @param uartA.parity 			=> Enumerated value indicating the parity configuration.
* @param uartA.stop				=> Enumerated value indicating the stop bit configuration.
* @param uartA.clockDivider		=> Clock divider value for UART communication.
* @return None.
*
******************************************************************************/
void main_init(){
    //I2C init
    I2c_Config i2c;
    i2c.samplingClockDivider = 3;
    i2c.timeout                 = I2C_CTRL_HZ /1000;   	//timeout = 1ms
    i2c.tsuDat                  = I2C_CTRL_HZ/2000000;  //tsuDat  = 500ns
    i2c.tLow                    = I2C_CTRL_HZ/800000;   //tLow 	  = 1.25us
    i2c.tHigh                   = I2C_CTRL_HZ/800000;  	//tHigh   = 1.25us
    i2c.tBuf                    = I2C_CTRL_HZ/400000;   //tBuf 	  = 2.5us
    i2c_applyConfig(I2C_CTRL, &i2c);

    //UART init
	Uart_Config uartA;
	uartA.dataLength = BITS_8;
	uartA.parity = NONE;
	uartA.stop = ONE;
	uartA.clockDivider = CORE_HZ/(115200*UART_A_SAMPLE_PER_BAUD)-1;
	uart_applyConfig(BSP_UART_TERMINAL, &uartA);

	// TX FIFO empty interrupt enable
	//uart_TX_emptyInterruptEna(BSP_UART_TERMINAL,1);

	// RX FIFO not empty interrupt enable
	uart_RX_NotemptyInterruptEna(BSP_UART_TERMINAL,1);

	//configure PLIC
	//cpu 0 accept all interrupts with priority above 0
	plic_set_threshold(BSP_PLIC, BSP_PLIC_CPU_0, 0);

	//enable SYSTEM_PLIC_USER_INTERRUPT_A_INTERRUPT rising edge interrupt
	plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, SYSTEM_PLIC_SYSTEM_UART_0_IO_INTERRUPT, 1);
	plic_set_priority(BSP_PLIC, SYSTEM_PLIC_SYSTEM_UART_0_IO_INTERRUPT, 1);

	//enable interrupts
	csr_write(mtvec, trap_entry); //Set the machine trap vector (../common/trap.S)
	csr_set(mie, MIE_MEIE); //Enable external interrupts
	csr_write(mstatus, csr_read(mstatus) | MSTATUS_MPP | MSTATUS_MIE);
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
void trap() {
    int32_t mcause = csr_read(mcause); 	// Read the machine cause register to determine the cause of the trap

    // Determine whether the trap was caused by an interrupt or an exception
    int32_t interrupt = mcause < 0; 		// If mcause is negative, it's an interrupt, otherwise, it's an exception
    int32_t cause = mcause & 0xF;   		// Extract the cause bits from the machine cause register

    if (interrupt) { 						// If it's an interrupt
        switch (cause) { 					// Check the cause of the interrupt
            case CAUSE_MACHINE_EXTERNAL: 	// If it's an external interrupt
                UartInterrupt(); 			// Call UartInterrupt function
                break;
            default: 						// If it's any other type of interrupt not handled
                crash(); break;					// Call crash function
        }
    } else {
        crash();
    }
}

/******************************************************************************
*
* @brief This function handles UART interrupt sub-events such as TX FIFO 
*		 empty interrupt and RX FIFO not empty interrupt.
*
******************************************************************************/
void UartInterrupt_Sub()
{
    if (uart_status_read(BSP_UART_TERMINAL) & 0x00000100){

//        bsp_printf("\nuart 0 tx fifo empty interrupt routine \r\n");
        // TX FIFO empty interrupt Disable
        uart_status_write(BSP_UART_TERMINAL,uart_status_read(BSP_UART_TERMINAL) & 0xFFFFFFFE);
        // TX FIFO empty interrupt enable
        uart_status_write(BSP_UART_TERMINAL,uart_status_read(BSP_UART_TERMINAL) | 0x01);
    }
    else if (uart_status_read(BSP_UART_TERMINAL) & 0x00000200){

//        bsp_printf("\nuart 0 rx fifo not empty interrupt routine \r\n");
        // RX FIFO not empty interrupt Disable
        uart_status_write(BSP_UART_TERMINAL,uart_status_read(BSP_UART_TERMINAL) & 0xFFFFFFFD);
        //Dummy Read Clear FIFO
        char uart_read_data = uart_read(BSP_UART_TERMINAL);
        uart_write(BSP_UART_TERMINAL, uart_read_data);

        if(uart_read_data == '\r'){ //if newline detected
        	new_line_detected = 1;
        	uart_write(BSP_UART_TERMINAL, '\r');
        }
        else{
        	buffer[counter] = uart_read_data;
        	counter++;
        }
        // RX FIFO not empty interrupt enable
        uart_status_write(BSP_UART_TERMINAL,uart_status_read(BSP_UART_TERMINAL) | 0x02);
    }
}

/******************************************************************************
*
* @brief This function handles UART interrupts by claiming pending interrupts 
* 		 and processing them through UartInterrupt_Sub().
*
******************************************************************************/
void UartInterrupt()
{

    uint32_t claim;
    //While there is pending interrupts
    while(claim = plic_claim(BSP_PLIC, BSP_PLIC_CPU_0)){
        switch(claim){
        case SYSTEM_PLIC_SYSTEM_UART_0_IO_INTERRUPT: UartInterrupt_Sub(); break;
        default: crash(); break;
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
* @brief This main function serves as the main control loop for the EEPROM operation.
* 		 It handles user input to perform various EEPROM operations such as read and write.
*
******************************************************************************/
void main() {
	uint8_t readback_data = 0;
	uint8_t access = READ;
	uint8_t operation = BYTE_OP;
	uint8_t buffer_hex [20];
	states state = IDLE;

    bsp_init();
    main_init();
    bsp_printf(OPENING_STRING);
    bsp_printf(FEATURE_SELECT_STRING);

    while(1){
		switch(state){
		case IDLE: //idle case wait for input to be 1 or 2
			if(new_line_detected){
				if(buffer[0] == '1' && counter == 1){ //Write operation selected
					bsp_printf("Write operation selected, please enter the location in hex with 16-bit size\r\n");
					access = WRITE;
					state = CHECK_ADDRESS;
					operation = BYTE_OP;
				}
				else if (buffer[0] == '2' && counter == 1){ //Read operation selected
					bsp_printf("Read operation selected, please enter the location in hex with 16-bit size\r\n");
					access = READ;
					state = CHECK_ADDRESS;
					operation = BYTE_OP;
				}
				else if (buffer[0] == '3' && counter == 1){ //Read current address data selected
					bsp_printf("Read current address data operation selected\r\n");
					access = READ;
					state = START_OP;
					operation = CURRENT_ADDR_READ;
				}
				else if (buffer[0] == '4' && counter == 1){ //Read operation selected
					bsp_printf("Read Multi-Byte operation selected, please enter the location in hex with 16-bit size\r\n");
					access = READ;
					state = CHECK_ADDRESS;
					operation = MULTI_BYTE_OP;
				}
				else if (buffer[0] == '5' && counter == 1){ //Write operation selected
					bsp_printf("Write Multi-Byte operation selected, please enter the location in hex with 16-bit size\r\n");
					access = WRITE;
					state = CHECK_ADDRESS;
					operation = MULTI_BYTE_OP;
				}
				else{
					bsp_printf("Invalid input. Please try again...\r\r\n");
					bsp_printf(FEATURE_SELECT_STRING);
					state = IDLE;
				}
				new_line_detected = 0;
				counter = 0;
			}
			break;

		case CHECK_ADDRESS: //check if the input location is correct
			if(new_line_detected){
				if(counter == 4){ //only 4 is correct

					int j =0;
					char ret = 0;
					char address_invalid = 0;
					//check if input is valid
					for(int i = 0;i<counter; i++){
						ret = ascii_to_bin(buffer[i]);
						if (ret == 0xFF){
							address_invalid = 1;
					}
					}
					if (address_invalid == 1){
						bsp_printf(INVALID_ADDR_STRING);
					}
					else{
						bsp_printf("Valid address input, please wait while the operation process\r\n");
						for(int i = 0;i<counter; i+=2){
							unsigned char top = ascii_to_bin(buffer[i]);
							unsigned char bot = ascii_to_bin(buffer[i+1]);
							buffer_hex[j] = (top << 4) | bot;
							j++;
						}
						address = 0x00000000 | (buffer_hex[0]&0xFF) << 8 | (buffer_hex[1] &0xFF);
						bsp_printf("address in hex = 0x%x%x \n\r", (address >> 8) & 0xFF, (address) & 0xFF);
						if(access == READ && operation == BYTE_OP) // read access
						{
							state = START_OP;
						}else if(operation == MULTI_BYTE_OP){
							bsp_printf("Enter the number of byte of data to write/read into/from the eeprom in hexadecimal (Maximum: 255 Bytes) \r\n");
							state = GET_NUM_OF_BYTE;
						}
						else{
							bsp_printf("Enter the byte of data to write into the eeprom in hexadecimal\r\n");
							state = GET_WRITE_DATA; //get data
						}
					}
				}
				else{
					bsp_printf(INVALID_ADDR_STRING);
				}
				new_line_detected = 0;
				counter = 0;
			}
			break;

		case GET_NUM_OF_BYTE:  //get number of byte of data to read or write

			if (new_line_detected){
				char ret = 0;
				char invalid_input = 0;
				if(counter == 1 ||counter == 2){
					if(counter == 1)//only 1 data inserted, put buffer[1] as 0
					{
						buffer[1] = buffer[0];
						buffer[0] = 0x30;
						counter = 2;
					}
					for(int i = 0;i<counter; i++){
						ret = ascii_to_bin(buffer[i]);
						if (ret == 0xFF){
							invalid_input = 1;
					}
					}
					if (invalid_input == 1){
						bsp_printf("Invalid input, please enter valid input\r\n");
						state = GET_NUM_OF_BYTE;
					}
					else{
						int j =0;
						for(int i = 0;i<counter; i+=2){
							unsigned char top = ascii_to_bin(buffer[i]);
							unsigned char bot = ascii_to_bin(buffer[i+1]);
							buffer_hex[j] = (top << 4) | bot;
							j++;
						}
						number_of_byte = buffer_hex[0];
						if (number_of_byte == 0){
							bsp_printf("The number of byte should be more than zero. Please enter valid input\r\n");
							state = GET_NUM_OF_BYTE;
						}else{
							if(operation == MULTI_BYTE_OP && access == READ){
								bsp_printf("Number of bytes to read: %x\r\n", number_of_byte);
								state = START_OP;
							}else {
								bsp_printf("Number of bytes: %x\r\n", number_of_byte);
								bsp_printf("Enter the byte of data to write into the eeprom in hexadecimal (Without Spacing in between) \r\n");
								state = GET_WRITE_DATA; //get data
							}
						}
					}

				}
				else{
					bsp_printf("Invalid input, please enter valid input\r\n");
					state = GET_NUM_OF_BYTE;
				}
				new_line_detected = 0;
				counter = 0;

			}
			break;

		case START_OP: //start operation
			if(access == WRITE){ //write operation
				if(operation == BYTE_OP){
					bsp_printf("Single Byte Write operation started\r\n ");
					write_data_to_addr(I2C_CTRL, address, buffer[0]);
				}else{
					bsp_printf("Multi Byte Write operation started\r\n ");
					write_multi_byte_data_to_addr(I2C_CTRL, address, number_of_byte, buffer);
				}

			}
			else{
				if(operation == BYTE_OP){
					bsp_printf("Read operation started\r\n");
					if(operation == CURRENT_ADDR_READ){
						read_data = current_addr_read(I2C_CTRL);
					}else{
						read_data = read_data_from_addr(I2C_CTRL, address);
					}
				}else{
					read_multi_byte_data_from_addr(I2C_CTRL, address, number_of_byte, buffer);
				}
			}
			state = WAIT_COMPLETION;
			break;

		case WAIT_COMPLETION: //wait operation to complete or enter q to quit
			if (new_line_detected){
				if(buffer[0] == 'q' && counter == 1){
					bsp_printf("Quit operation...\r\n");
					state = RESTART;
				}
				else{
					bsp_printf("Invalid command\r\n");
				}
				new_line_detected = 0;
				counter = 0;
			}
			if (access == WRITE){
				bsp_printf("Write operation successful\r\n");
			}
			else{
				if(operation == BYTE_OP){
					bsp_printf("Read operation successful. \r\nRead data = %x\r\n", read_data);
				}else {
					bsp_printf("Read operation successful. \r\n");
					for(u32 i=0;i<number_of_byte;i++){
						bsp_printf("0x%x ", buffer[i]);
					}
					bsp_printf("\r\n");
				}
			}
//			bsp_printf("Operation completed, back to origin...\r\n");
			state = RESTART;
			break;

		case GET_WRITE_DATA: //get input data
			if (new_line_detected){
				char ret = 0;
				char invalid_input = 0;
				if(counter%2 == 0){ //make sure it is all paired
					for(int i = 0;i<counter; i++){
						ret = ascii_to_bin(buffer[i]);
						if (ret == 0xFF){
							invalid_input = 1;
						}
					}
					if (invalid_input == 1){
						bsp_printf("Invalid input, please re-enter valid input\r\n");
						state = GET_WRITE_DATA;
					}
					else{
						int j =0;
						for(int i = 0;i<counter; i+=2){
							unsigned char top = ascii_to_bin(buffer[i]);
							unsigned char bot = ascii_to_bin(buffer[i+1]);
							buffer[j] = (top << 4) | bot;
							j++;
						}
						bsp_printf("Inputted number of byte of data to write\r\n", j);
						if(number_of_byte > j){
							bsp_printf("Only %u of data will be written into the EEPROM");
							number_of_byte = j;
						}
						state = START_OP;
					}
				}
				else{
					bsp_printf("Invalid command, please enter valid input\r\n");
					state = GET_WRITE_DATA;
				}
				new_line_detected = 0;
				counter = 0;

			}
			break;

		case RESTART:
			//restarting the operation
			bsp_printf(FEATURE_SELECT_STRING);
			state = IDLE;
			counter = 0;
			new_line_detected = 0;
			break;

		default:
			bsp_printf("Invalid state. \r\n");
			bsp_printf(FEATURE_SELECT_STRING);
			state = IDLE;
			counter = 0;
		}
    }
}

/******************************************************************************
*
* @brief This function converts an ASCII character representing a hexadecimal
*		 digit to its binary value.
*
* @param inchar    Input ASCII character to convert
* @return          unsigned char: Binary value corresponding to the input character
*                  -1 if the input character is not a valid hexadecimal digit
*
******************************************************************************/
unsigned char ascii_to_bin(unsigned char inchar)
{
  if ((inchar >= '0') && (inchar <= '9'))
    return inchar - '0'; // was in the range '0' to '9'
  if ((inchar >= 'A') && (inchar <= 'F'))
    return (inchar - 'A') + 10; // was in the range 'A' to 'F'
  if ((inchar >= 'a') && (inchar <= 'f'))
    return (inchar - 'a') + 10; // was in the range 'a' to 'f'
  return -1; //if the character was not a valid hex character
}

/******************************************************************************
*
* @brief This function write data to the address of an EEPROM device.
*
* @param reg       I2C register or channel number
* @param addr	   Address from which to write the data
* @param data	   Data that write to the address
* @return          uint8_t: Status code (0 for success, error code otherwise)
*
******************************************************************************/
uint8_t write_data_to_addr(u32 reg, u32 addr, u8 data){
	i2c_masterStartBlocking(reg);
	i2c_txByte(reg, SLAVE_ADDRESS | WRITE);
	i2c_txNackBlocking(reg);
	i2c_txByte(reg, ((addr >>8) & 0xFF));
	i2c_txNackBlocking(reg);
	i2c_txByte(reg, (addr & 0xFF));
	i2c_txNackBlocking(reg);
	i2c_txByte(reg, data);
	i2c_txNackBlocking(reg);
	i2c_masterStopBlocking(reg);
	return 0;
}

/******************************************************************************
*
* @brief This function write multiple bytes of data from a specified address of an EEPROM device
*
* @param reg       I2C register or channel number
* @param addr	   Address from which to write the data
* @param length	   Number of bytes to write
* @param data	   Pointer to the buffer where the data will be written
*
* @return          uint8_t: Status code (0 for success, error code otherwise)
*
******************************************************************************/
uint8_t write_multi_byte_data_to_addr (u32 reg, u32 addr, u32 length, u8 *data){
	i2c_masterStartBlocking(reg);  				// Start I2C communication
	i2c_txByte(reg, SLAVE_ADDRESS | WRITE);		// Transmit the device address with write mode to set the memory address pointer
	i2c_txNackBlocking(reg);					// Transmit a NACK to indicate the end of data transfer
	i2c_txByte(reg, ((addr >>8) & 0xFF));		// Write first word address (high byte)
	i2c_txNackBlocking(reg);					// Transmit a NACK to indicate the end of data transfer
	i2c_txByte(reg, (addr & 0xFF));				// Write second word address (low byte)
	i2c_txNackBlocking(reg);					// Transmit a NACK to indicate the end of data transfer
	if(length > 1){
		for(int i = 0; i < length - 1; i++){
				i2c_txByte(reg, data[i]);
				i2c_txNackBlocking(reg);		// Transmit a NACK to indicate the end of data transfer
			}
	}
	i2c_txByte(reg, data[length-1]);
	i2c_txAckBlocking(reg); 					//last byte write need to acknowledge it
	i2c_masterStopBlocking(reg);				// Stop I2C communication
	return 0;
}



/******************************************************************************
*
* @brief This function read data from a specified address of an EEPROM device
*
* @param reg       I2C register or channel number
* @param addr	   Address from which to read the data
*
* @return          uint8_t: readData
*
******************************************************************************/
uint8_t read_data_from_addr(u32 reg, u32 addr) {
    uint8_t readData = 0; 					// Variable to store the read data
    i2c_masterStartBlocking(reg);			// Start I2C communication
    i2c_txByte(reg, SLAVE_ADDRESS | WRITE); // Write device address byte
    i2c_txNackBlocking(reg); 				// Transmit a NACK to indicate the end of data transfer
    i2c_txByte(reg, ((addr >> 8) & 0xFF)); 	// Write first word address (high byte)
    i2c_txNackBlocking(reg); 				// Transmit a NACK to indicate the end of data transfer
    i2c_txByte(reg, (addr & 0xFF)); 		// Write second word address (low byte)
    i2c_txNackBlocking(reg); 				// Transmit a NACK to indicate the end of data transfer
    i2c_masterRestartBlocking(reg);			// Restart I2C communication for read operation
    i2c_txByte(reg, SLAVE_ADDRESS | READ); 	// Transmit the device address with read mode
    i2c_txNackBlocking(reg); 				// Transmit a NACK to indicate the end of data transfer
    i2c_txByte(reg, 0xFF);					// Transmit a dummy byte (0xFF) to initiate the read operation
    i2c_txNackBlocking(reg); 				// Transmit a NACK to indicate the end of data transfer
    readData = i2c_rxData(reg);				// Receive the data from the EEPROM
    i2c_masterStopBlocking(reg);			// Stop I2C communication
    return readData;						// Return the read data
}

/******************************************************************************
*
* @brief This function read multiple bytes of data from a specified address of an EEPROM device
*
* @param reg       I2C register or channel number
* @param addr	   Address from which to read the data
* @param length	   Number of bytes to read
* @param data	   Pointer to the buffer where the read data will be stored
*
* @return          uint8_t: Status code (0 for success, error code otherwise)
*
******************************************************************************/
uint8_t read_multi_byte_data_from_addr(u32 reg, u32 addr, u32 length, u8 *data) {
    i2c_masterStartBlocking(reg);				// Start I2C communication
    i2c_txByte(reg, SLAVE_ADDRESS | WRITE);		// Transmit the device address with write mode to set the memory address pointer
    i2c_txNackBlocking(reg);					// Transmit a NACK to indicate the end of data transfer
    i2c_txByte(reg, ((addr >> 8) & 0xFF));		// Transmit the high byte of the memory address
    i2c_txNackBlocking(reg);					// Transmit a NACK to indicate the end of data transfer
    i2c_txByte(reg, (addr & 0xFF));				// Transmit the low byte of the memory address
    i2c_txNackBlocking(reg);					// Transmit a NACK to indicate the end of data transfer
    i2c_masterRestartBlocking(reg);				// Restart I2C communication to switch from write mode to read mode
    i2c_txByte(reg, SLAVE_ADDRESS | READ);		// Transmit the device address with read mode
    i2c_txNackBlocking(reg);					// Transmit a NACK to indicate the end of data transfer
    if (length > 1) {							// Read multiple bytes of data
        for (int i = 0; i < length - 1; i++) {
            i2c_txByte(reg, 0xFF);				// Transmit a dummy byte to request data from the EEPROM
            i2c_txAckBlocking(reg);				// Transmit a ACK to indicate the end of data transfer
            data[i] = i2c_rxData(reg);
        }
    }
    i2c_txByte(reg, 0xFF);						// Transmit another dummy byte to request the last byte of data
    i2c_txNackBlocking(reg);					// Transmit a NACK to indicate the end of data transfer
    data[length - 1] = i2c_rxData(reg);			// Read the last byte of data
    i2c_masterStopBlocking(reg);				// Stop I2C communication
    return 0;									// Return status code (0 for success)
}

/******************************************************************************
*
* @brief This function read data from the current address of an EEPROM device
*
* @param reg       I2C register or channel number
*
* @return          uint8_t: Data read from the EEPROM
*
******************************************************************************/
uint8_t current_addr_read(u32 reg) {
    uint8_t readData = 0; 					// Variable to store the read data
    i2c_masterStartBlocking(reg);			// Start I2C communication
    i2c_txByte(reg, SLAVE_ADDRESS | READ);	// Transmit the device address with read mode
    i2c_txNackBlocking(reg);				// Transmit a NACK (Not Acknowledge) to indicate the end of data transfer
    i2c_txByte(reg, 0xFF);					// Transmit a dummy byte (0xFF) to initiate the read operation
    i2c_txNackBlocking(reg);				// Transmit a NACK to indicate the end of data transfer
    readData = i2c_rxData(reg);				// Receive data from the EEPROM
    bsp_uDelay(100);					 	// Delay for a short period (100 microseconds)
    i2c_masterStopBlocking(reg);			// Stop I2C communication
    return readData;						// Return the read data

}

#endif
