#pragma once

#include "type.h"
#include "io.h"

#define UART_DATA 0x00
#define UART_STATUS 0x04
#define UART_CLOCK_DIVIDER 0x08
#define UART_FRAME_CONFIG 0x0C

enum UartDataLength {BITS_8 = 8};
enum UartParity {NONE = 0,EVEN = 1,ODD = 2};
enum UartStop {ONE = 0,TWO = 1};

typedef struct {
    enum UartDataLength dataLength;
    enum UartParity parity;
    enum UartStop stop;
    u32 clockDivider;
} Uart_Config;

static u32 uart_writeAvailability(u32 reg){
    return (read_u32(reg + UART_STATUS) >> 16) & 0xFF;
}
static u32 uart_readOccupancy(u32 reg){
    return read_u32(reg + UART_STATUS) >> 24;
}

static void uart_write(u32 reg, char data){
    while(uart_writeAvailability(reg) == 0);
    write_u32(data, reg + UART_DATA);
}

static void uart_writeStr(u32 reg, const char* str){
    while(*str) uart_write(reg, *str++);
}

static char uart_read(u32 reg){
    while(uart_readOccupancy(reg) == 0);
    return read_u32(reg + UART_DATA);
}

static void uart_applyConfig(u32 reg, Uart_Config *config){
    write_u32(config->clockDivider, reg + UART_CLOCK_DIVIDER);
    write_u32(((config->dataLength-1) << 0) | (config->parity << 8) | (config->stop << 16), reg + UART_FRAME_CONFIG);
}

static u32 uart_status_read(u32 reg)
 {
	 return read_u32(reg+UART_STATUS);
 }

static void uart_status_write(u32 reg, char data)
{
	write_u32(data ,reg+UART_STATUS);
}

static void uart_TX_emptyInterruptEna(u32 reg, char Ena){
	uart_status_write(reg,(uart_status_read(reg) & 0xFFFFFFFE) | (Ena & 0x01));	
}

static void uart_RX_NotemptyInterruptEna(u32 reg, char Ena){
	uart_status_write(reg,(uart_status_read(reg) & 0xFFFFFFFD) | (Ena & 0x02));	
}



