///////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 2025 SaxonSoc contributors
//  SPDX license identifier: MIT
//  Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
///////////////////////////////////////////////////////////////////////////////////

/*******************************************************************************
/**
* @file i2c.h
*
* @brief Header file for I2C module containing various I2C functions for communication.
*
* The available functions are:
* - i2c_writeData_b: Writes data to a specified register address (8bit) on an I2C slave device.
* - i2c_writeData_w: Writes data to a specified register address (16bit) on an I2C slave device.
* - i2c_readData_b: Reads data from a specified register address (8bit) on an I2C slave device.
* - i2c_readData_w: Reads data from a specified register address (16bit) on an I2C slave device.
* - i2c_applyConfig: Applies the configuration settings to the I2C module.
* - i2c_filterEnable: Enables filtering for a specific filter ID.
* - i2c_masterStart: Initiates the start condition for I2C communication.
* - i2c_masterRestart: Initiates a repeated start condition for I2C communication.
* - i2c_masterRecover: Initiates the recovery process for I2C communication.
* - i2c_masterBusy: Checks if the I2C master is busy.
* - i2c_masterStatus: Returns the status of the I2C master.
* - i2c_masterStartBlocking: Initiates the start condition for I2C communication and waits until it completes.
* - i2c_masterRestartBlocking: Initiates the restart condition for I2C communication
* - i2c_masterStop: Initiates the stop condition for I2C communication.
* - i2c_masterRecoverBlocking: Initiates the recovery process for I2C communication and waits until it completes.
* - i2c_masterStopWait: Waits until the I2C master stops.
* - i2c_masterDrop: Initiates the drop condition for I2C communication.
* - i2c_masterStopBlocking: Initiates the stop condition for I2C communication and waits until it completes.
* - i2c_listenAck: Listens for acknowledgment during I2C communication.
* - i2c_txByte: Transmits a byte over the I2C bus.
* - i2c_txAck: Transmits an acknowledgment signal over the I2C bus.
* - i2c_txNack: Transmits a non-acknowledgment signal over the I2C bus.
* - i2c_txAckWait: Waits until the acknowledgment signal transmission completes.
* - i2c_txAckBlocking: Transmits an acknowledgment signal over the I2C bus and waits until it completes.
* - i2c_txNackBlocking: Transmits a non-acknowledgment signal over the I2C bus and waits until it completes.
* - i2c_rxData: Reads received data from the I2C bus.
* - i2c_rxNack: Checks if a NACK signal is received.
* - i2c_rxAck: Checks if an ACK signal is received.
* - i2c_txByteRepeat: Transmits a byte over the I2C bus with repeat mode enabled.
* - i2c_txNackRepeat: Transmits a non-acknowledgment signal over the I2C bus with repeat mode enabled.
* - i2c_setFilterConfig: Sets the filter configuration for a specific filter ID.
* - i2c_enableInterrupt: Enables specific interrupts for the I2C module.
* - i2c_disableInterrupt: Disables specific interrupts for the I2C module.
* - i2c_clearInterruptFlag: Clears specific interrupt flags for the I2C module.
*
******************************************************************************/

#pragma once
#include "type.h"
#include "io.h"
#define I2C_TX_DATA                     0x00
#define I2C_TX_ACK                      0x04
#define I2C_RX_DATA                     0x08
#define I2C_RX_ACK                      0x0C
#define I2C_INTERRUPT_ENABLE            0x20
#define I2C_INTERRUPT_FLAG              0x24
#define I2C_SAMPLING_CLOCK_DIVIDER      0x28
#define I2C_TIMEOUT                     0x2C
#define I2C_TSUDAT                      0x30
#define I2C_MASTER_STATUS               0x40
#define I2C_SLAVE_STATUS                0x44
#define I2C_SLAVE_OVERRIDE              0x48
#define I2C_TLOW                        0x50
#define I2C_THIGH                       0x54
#define I2C_TBUF                        0x58
#define I2C_FILTERING_HIT               0x80
#define I2C_FILTERING_STATUS            0x84
#define I2C_FILTERING_CONFIG            0x88
#define I2C_MODE_CPOL                   (1 << 0)
#define I2C_MODE_CPHA                   (1 << 1)
#define I2C_TX_VALUE                    (0xFF)
#define I2C_TX_VALID                    (1 << 8)
#define I2C_TX_ENABLE                   (1 << 9)
#define I2C_TX_REPEAT                   (1 << 10)
#define I2C_TX_DISABLE_ON_DATA_CONFLICT (1 << 11)
#define I2C_RX_VALUE                    (0xFF)
#define I2C_RX_VALID                    (1 << 8)
#define I2C_RX_LISTEN                   (1 << 9)
#define I2C_MASTER_BUSY                 (1 << 0)
#define I2C_MASTER_START                (1 << 4)
#define I2C_MASTER_STOP                 (1 << 5)
#define I2C_MASTER_DROP                 (1 << 6)
#define I2C_MASTER_RECOVER              (1 << 7)
#define I2C_MASTER_START_DROPPED        (1 << 9)
#define I2C_MASTER_STOP_DROPPED         (1 << 10)
#define I2C_MASTER_RECOVER_DROPPED      (1 << 11)
#define I2C_SLAVE_STATUS_IN_FRAME       (1 << 0)
#define I2C_SLAVE_STATUS_SDA            (1 << 1)
#define I2C_SLAVE_STATUS_SCL            (1 << 2)
#define I2C_SLAVE_OVERRIDE_SDA          (1 << 1)
#define I2C_SLAVE_OVERRIDE_SCL          (1 << 2)
#define I2C_FILTER_7_BITS               (0)
#define I2C_FILTER_10_BITS              (1 << 14)
#define I2C_FILTER_ENABLE               (1 << 15)
#define I2C_INTERRUPT_TX_DATA           (1 << 2)
#define I2C_INTERRUPT_TX_ACK            (1 << 3)
#define I2C_INTERRUPT_DROP              (1 << 7)
#define I2C_INTERRUPT_CLOCK_GEN_EXIT    (1 << 15)
#define I2C_INTERRUPT_CLOCK_GEN_ENTER   (1 << 16)
#define I2C_INTERRUPT_CLOCK_GEN_BUSY    (1 << 16) //Renamed into I2C_INTERRUPT_CLOCK_GEN_ENTER
#define I2C_INTERRUPT_FILTER            (1 << 17)
#define I2C_READ                        0x01
#define I2C_WRITE                       0x00


/******************************************************************************
*
* Backward compatibility
*
* Please use i2c_get* functions for new designs
*
******************************************************************************/

#define gpio_getInterruptFlag(reg) i2c_getInterruptFlag(reg)
#define gpio_getMasterStatus(reg) i2c_getMasterStatus(reg)
#define gpio_getFilteringHit(reg) i2c_getFilteringHit(reg)
#define gpio_getFilteringStatus(reg) i2c_getFilteringStatus(reg)
//end
    readReg_u32 (i2c_getInterruptFlag   , I2C_INTERRUPT_FLAG)
    readReg_u32 (i2c_getMasterStatus    , I2C_MASTER_STATUS)
    readReg_u32 (i2c_getFilteringHit    , I2C_FILTERING_HIT)
    readReg_u32 (i2c_getFilteringStatus , I2C_FILTERING_STATUS)
    readReg_u32 (i2c_getSlaveStatus , I2C_SLAVE_STATUS)
    writeReg_u32 (i2c_getSlaveOverride , I2C_SLAVE_OVERRIDE)


/******************************************************************************
*
* This is my try struct.
*
* This structure represents the configuration settings for an I2C interface.
* It contains various parameters related to the timing and operation of the I2C bus.
*
******************************************************************************/
    typedef struct {
        //Master/Slave mode
        //Number of cycle - 1 between each SDA/SCL sample
        u32 samplingClockDivider; 
        //Number of cycle - 1 after which an inactive frame is considered dropped.
        u32 timeout;              
        //Number of cycle - 1 SCL should be keept low (clock stretching) after having feed the data to
        //the SDA to ensure a correct propagation to other devices
        u32 tsuDat;               
        //Master mode
        //SCL low (cycle count -1)
        u32 tLow;  
        //SCL high (cycle count -1)
        u32 tHigh; 
        //Minimum time between the Stop/Drop -> Start transition
        u32 tBuf;  
    } I2c_Config;

/******************************************************************************
*
* This function is used to apply the provided configuration settings to the specified I2C interface.
*
* @param reg    The base address of the I2C registers.
* @param config Pointer to the I2C configuration structure containing the settings to be applied.
*
* @return       None.
*
******************************************************************************/
    static void i2c_applyConfig(u32 reg, I2c_Config *config){
        write_u32(config->samplingClockDivider, reg + I2C_SAMPLING_CLOCK_DIVIDER);
        write_u32(config->timeout, reg + I2C_TIMEOUT);
        write_u32(config->tsuDat, reg + I2C_TSUDAT);
        write_u32(config->tLow, reg + I2C_TLOW);
        write_u32(config->tHigh, reg + I2C_THIGH);
        write_u32(config->tBuf, reg + I2C_TBUF);
    }

/******************************************************************************
*
* This function enables the specified filter for the I2C interface with the provided configuration.
*
* @param reg       The base address of the I2C registers.
* @param filterId  The identifier of the filter to be enabled.
* @param config    The configuration to be applied to the filter.
*
* @return          None.
*
******************************************************************************/

    static inline void i2c_filterEnable(u32 reg, u32 filterId, u32 config){
        write_u32(config, reg + I2C_FILTERING_CONFIG + 4*filterId);
    }

/******************************************************************************
*
*  This function initiates the start condition for I2C master mode and sets the dropped status if necessary.
*
* @param reg   The base address of the I2C registers.
*
* @return      None.
*
******************************************************************************/
    static inline void i2c_masterStart(u32 reg){
        write_u32(I2C_MASTER_START | I2C_MASTER_START_DROPPED, reg + I2C_MASTER_STATUS);
    }

/******************************************************************************
*
* This function initiates the restart condition for I2C master mode.
*
* @param reg   The base address of the I2C registers.
*
* @return      None.
*
******************************************************************************/
    static inline void i2c_masterRestart(u32 reg){
        i2c_masterStart(reg);
    }

/******************************************************************************
*
* This function initiates the recovery sequence for I2C master mode.
*
* @param reg   The base address of the I2C registers.
*
* @return      None.
*
******************************************************************************/
    static inline void i2c_masterRecover(u32 reg){
        write_u32(I2C_MASTER_RECOVER | I2C_MASTER_RECOVER_DROPPED, reg + I2C_MASTER_STATUS);
    }

/******************************************************************************
*
* This function checks whether the I2C master is busy.
*
* @param reg   The base address of the I2C registers.
*
* @return      Returns 1 if the I2C master is busy, and 0 otherwise.
*
******************************************************************************/
    static int i2c_masterBusy(u32 reg){
        return (read_u32(reg + I2C_MASTER_STATUS) & I2C_MASTER_BUSY) != 0;
    }

/******************************************************************************
*
* This function retrieves the status of the I2C master.
*
* @param reg   The base address of the I2C registers.
*
* @return      Returns the status of the I2C master.
*
******************************************************************************/
    static int i2c_masterStatus(u32 reg){
        return (read_u32(reg + I2C_MASTER_STATUS));
    }

/******************************************************************************
*
* This function initiates a start condition on the I2C bus and blocks until the start condition is completed.
*
* @param reg   The base address of the I2C registers.
*
* @return      None.
*
******************************************************************************/
    static void i2c_masterStartBlocking(u32 reg){
        i2c_masterStart(reg);
        while(i2c_getMasterStatus(reg) & I2C_MASTER_START);
    }

/******************************************************************************
*
* This function initiates a restart condition on the I2C bus.
*
* @param reg   The base address of the I2C registers.
*
* @return      None.
*
******************************************************************************/
    static void i2c_masterRestartBlocking(u32 reg){
        i2c_masterStartBlocking(reg);
    }

/******************************************************************************
*
* This function initiates a stop condition on the I2C bus.
*
* @param reg   The base address of the I2C registers.
*
* @return      None.
*
******************************************************************************/
    static inline void i2c_masterStop(u32 reg){
        write_u32(I2C_MASTER_STOP | I2C_MASTER_STOP_DROPPED, reg + I2C_MASTER_STATUS);
    }

/******************************************************************************
*
* This function initiates a recovery sequence on the I2C bus and blocks until the recovery is completed.
*
* @param reg   The base address of the I2C registers.
*
* @return      None.
*
******************************************************************************/
    static void i2c_masterRecoverBlocking(u32 reg){
        for(int i = 0;i < 3;i++){
            i2c_masterRecover(reg);
            while(i2c_getMasterStatus(reg) & I2C_MASTER_RECOVER);
            if((i2c_getMasterStatus(reg) & I2C_MASTER_RECOVER_DROPPED) == 0){
                break;
            }
        }
    }

/******************************************************************************
*
* This function waits until the I2C master bus is no longer busy, indicating that the stop condition has been completed.
*
* @param reg   The base address of the I2C registers.
*
* @return      None.
*
******************************************************************************/
    static void i2c_masterStopWait(u32 reg){
        while(i2c_masterBusy(reg));
    }

/******************************************************************************
*
* This function initiates a drop operation on the I2C bus.
*
* @param reg   The base address of the I2C registers.
*
* @return      None.
*
******************************************************************************/
    static inline void i2c_masterDrop(u32 reg){
        write_u32(I2C_MASTER_DROP, reg + I2C_MASTER_STATUS);
    }

/******************************************************************************
*
* This function initiates a stop sequence on the I2C bus and waits until the bus is no longer busy.
*
* @param reg   The base address of the I2C registers.
*
* @return      None.
*
******************************************************************************/
    static void i2c_masterStopBlocking(u32 reg){
        i2c_masterStop(reg);
        i2c_masterStopWait(reg);
    }

/******************************************************************************
*
* This function configures the I2C controller to listen for ACK signals on the receiver (RX) line.
*
* @param reg   The base address of the I2C registers.
*
* @return      None.
*
******************************************************************************/
    static inline void i2c_listenAck(u32 reg){
        write_u32(I2C_RX_LISTEN ,reg + I2C_RX_ACK);
    }

/******************************************************************************
*
* This function transmits a byte of data over the I2C bus.
*
* @param reg   The base address of the I2C registers.
* @param byte  The byte of data to transmit.
*
* @return      None.
*
******************************************************************************/
    static inline void i2c_txByte(u32 reg,u8 byte){
        write_u32(byte | I2C_TX_VALID | I2C_TX_ENABLE | I2C_TX_DISABLE_ON_DATA_CONFLICT, reg + I2C_TX_DATA);
    }

/******************************************************************************
*
* This function transmits an ACK signal over the I2C bus.
*
* @param reg   The base address of the I2C registers.
*
* @return      None.
*
******************************************************************************/
    static inline void i2c_txAck(u32 reg){
        write_u32(I2C_TX_VALID | I2C_TX_ENABLE, reg + I2C_TX_ACK);
    }

/******************************************************************************
*
* This function transmits an NACK signal over the I2C bus.
*
* @param reg   The base address of the I2C registers.
*
* @return      None.
*
******************************************************************************/
    static inline void i2c_txNack(u32 reg){
        write_u32(1 | I2C_TX_VALID | I2C_TX_ENABLE, reg + I2C_TX_ACK);
    }

/******************************************************************************
*
* This function waits until the transmission of an ACK signal is complete over the I2C bus.
*
* @param reg   The base address of the I2C registers.
*
* @return      None.
*
******************************************************************************/
    static void i2c_txAckWait(u32 reg){
        while(read_u32(reg + I2C_TX_ACK) & I2C_TX_VALID);
    }

/******************************************************************************
*
* This function sends an ACK signal over the I2C bus and waits until the transmission is complete.
*
* @param reg   The base address of the I2C registers.
*
* @return      None.
*
******************************************************************************/
    static void i2c_txAckBlocking(u32 reg){
        i2c_txAck(reg);
        i2c_txAckWait(reg);


    }

/******************************************************************************
*
* This function sends an NACK signal over the I2C bus and waits until the transmission is complete.
*
* @param reg   The base address of the I2C registers.
*
* @return      None.
*
******************************************************************************/
    static void i2c_txNackBlocking(u32 reg){
        i2c_txNack(reg);
        i2c_txAckWait(reg);
    }

/******************************************************************************
*
* This function reads data from the I2C receive data register.
*
* @param reg   The base address of the I2C registers.
*
* @return      The received data from the I2C bus.
*
******************************************************************************/

    static u32 i2c_rxData(u32 reg){
        return read_u32(reg + I2C_RX_DATA) & I2C_RX_VALUE;
    }

/******************************************************************************
*
* This function checks if the received NACK signal is detected.
*
* @param reg   The base address of the I2C registers.
*
* @return      1 if NACK signal is detected, otherwise 0.
*
******************************************************************************/
    static int i2c_rxNack(u32 reg){
        return (read_u32(reg + I2C_RX_ACK) & I2C_RX_VALUE) != 0;
    }

/******************************************************************************
*
* This function checks if the received ACK signal is detected.
*
* @param reg   The base address of the I2C registers.
*
* @return      1 if ACK signal is detected, otherwise 0.
*
******************************************************************************/
    static int i2c_rxAck(u32 reg){
        return (read_u32(reg + I2C_RX_ACK) & I2C_RX_VALUE) == 0;
    }

/******************************************************************************
*
* This function sends a byte over the I2C bus with repeat mode enabled.
*
* @param reg   The base address of the I2C registers.
* @param byte  The byte to be sent.
*
* @return      None.
*
******************************************************************************/
    static void i2c_txByteRepeat(u32 reg,u8 byte){
        write_u32(byte | I2C_TX_VALID | I2C_TX_ENABLE | I2C_TX_DISABLE_ON_DATA_CONFLICT | I2C_TX_REPEAT, reg + I2C_TX_DATA);
    }

/******************************************************************************
*
* This function sends a NACK signal over the I2C bus with repeat mode enabled.
*
* @param reg   The base address of the I2C registers.
*
* @return      None.
*
******************************************************************************/
    static void i2c_txNackRepeat(u32 reg){
        write_u32(1 | I2C_TX_VALID | I2C_TX_ENABLE | I2C_TX_REPEAT, reg + I2C_TX_ACK);
    }

/******************************************************************************
*
* This function sets the filter configuration for a specific filter ID.
*
* @param reg       The base address of the I2C registers.
* @param filterId  The ID of the filter.
* @param value     The value to be set for the filter configuration.
*
* @return          None.
*
******************************************************************************/
    static inline void i2c_setFilterConfig(u32 reg, u32 filterId, u32 value){
        write_u32(value, reg + I2C_FILTERING_CONFIG + 4*filterId);
    }

/******************************************************************************
*
* This function enables specific interrupts for the I2C module.
*
* @param reg       The base address of the I2C registers.
* @param value     The value representing the interrupts to be enabled.
*
* @return          None.
*
******************************************************************************/
    static void i2c_enableInterrupt(u32 reg, u32 value){
        write_u32(value | read_u32(reg + I2C_INTERRUPT_ENABLE), reg + I2C_INTERRUPT_ENABLE);
    }

/******************************************************************************
*
* This function disables specific interrupts for the I2C module.
*
* @param reg       The base address of the I2C registers.
* @param value     The value representing the interrupts to be enabled.
*
* @return          None.
*
******************************************************************************/
    static void i2c_disableInterrupt(u32 reg, u32 value){
        write_u32(~value & read_u32(reg + I2C_INTERRUPT_ENABLE), reg + I2C_INTERRUPT_ENABLE);
    }

/******************************************************************************
*
* This function clears specific interrupt flags for the I2C module.
*
* @param reg       The base address of the I2C registers.
* @param value     The value representing the interrupt flags to be cleared.
*
* @return          None.
*
******************************************************************************/
    static inline void i2c_clearInterruptFlag(u32 reg, u32 value){
        write_u32(value, reg + I2C_INTERRUPT_FLAG);
    }

/*******************************************************************************
*
* The function is to write data with 8-bit register address.
*
* @param   reg: I2C peripheral register base address.
* @param   slaveAddr: Address of the slave device.
* @param   regAddr: 8-bit register address.
* @param   data: Pointer to the data buffer to be written.
* @param   length: Length of the data buffer.
*
* This function performs a write operation over I2C bus with an 8-bit register address.
* It starts by sending the start sequence followed by the device address with the write bit.
* Then, it sends the register address byte to access. If the length of the data buffer
* is greater than one, it iterates through the buffer, sending each byte of data to the slave.
* Finally, it sends the stop sequence to complete the transaction.
*
*******************************************************************************/
    static void i2c_writeData_b(u32 reg, u8 slaveAddr, u8 regAddr, u8 *data, u32 length){
        i2c_masterStartBlocking(reg);               // Send start sequence
        i2c_txByte(reg, slaveAddr | I2C_WRITE);     // write device address byte with write bit
        i2c_txNackBlocking(reg);                    // send nack bit
        i2c_txByte(reg, (regAddr & 0xFF));          // write a byte of register address to access
        i2c_txNackBlocking(reg);                    // send nack bit
        if(length > 1){
            for(int i = 0; i < length - 1; i++){
                    i2c_txByte(reg, data[i]);       // send 8-bit data to slave
                    i2c_txNackBlocking(reg);        // send nack bit
                }
        }
        i2c_txByte(reg, data[length-1]);            // send last 8-bit data to slave
        i2c_txNackBlocking(reg);                    // send nack bit
        i2c_masterStopBlocking(reg);                // send stop sequence
    }


/*******************************************************************************
*
* The function is to write data with 16-bit register address.
*
* @param   reg: I2C peripheral register base address.
* @param   slaveAddr: Address of the slave device.
* @param   regAddr: 16-bit register address.
* @param   data: Pointer to the data buffer to be written.
* @param   length: Length of the data buffer.
*
* This function performs a write operation over I2C bus with an 16-bit register address.
* It starts by sending the start sequence followed by the device address with the write bit.
* Then, it sends the register address byte to access. If the length of the data buffer
* is greater than one, it iterates through the buffer, sending each byte of data to the slave.
* Finally, it sends the stop sequence to complete the transaction.
*
*******************************************************************************/
    static void i2c_writeData_w(u32 reg, u8 slaveAddr, u16 regAddr, u8 *data, u32 length){
        i2c_masterStartBlocking(reg);               // Send start sequence
        i2c_txByte(reg, slaveAddr | I2C_WRITE);     // write device address byte with write bit
        i2c_txNackBlocking(reg);                    // send nack bit
        i2c_txByte(reg, ((regAddr >>8) & 0xFF));    // send MSB of register address to access
        i2c_txNackBlocking(reg);                    // send nack bit
        i2c_txByte(reg, (regAddr & 0xFF));          // send LSB of register address to access
        i2c_txNackBlocking(reg);                    // send nack bit
        if(length > 1){
            for(int i = 0; i < length - 1; i++){
                    i2c_txByte(reg, data[i]);       // send 8-bit data to slave
                    i2c_txNackBlocking(reg);        // send nack bit
                }
        }
        i2c_txByte(reg, data[length-1]);            // send last 8-bit data to slave
        i2c_txNackBlocking(reg);                    // send nack bit
        i2c_masterStopBlocking(reg);                // send stop sequence
    }

/*******************************************************************************
*
* This function is to read data with 8-bit register address.
*
* @param   reg: I2C peripheral register base address.
* @param   slaveAddr: Address of the slave device.
* @param   regAddr: 8-bit register address.
* @param   data: Pointer to the data buffer to store read data.
* @param   length: Length of the data buffer.
*
* This function performs a read operation over I2C bus with an 8-bit register address.
* It starts by sending the start sequence followed by the device address with the write bit.
* Then, it sends the register address byte to access. After that, it sends the restart sequence
* to switch from write mode to read mode. Next, it sends the device address byte with the read bit.
* If the length of the data buffer is greater than one, it iterates through the buffer, sending
* 0xFF to generate clock pulses while receiving data bytes from the slave. Finally, it sends the
* stop sequence to complete the transaction.
*
*******************************************************************************/
    static void i2c_readData_b(u32 reg, u8 slaveAddr, u8 regAddr, u8 *data , u32 length){
        i2c_masterStartBlocking(reg);               // Send start sequence
        i2c_txByte(reg, slaveAddr|I2C_WRITE);       // write device address byte with write bit
        i2c_txNackBlocking(reg);                    // send nack bit
        i2c_txByte(reg, (regAddr & 0xFF));          // write second byte address
        i2c_txNackBlocking(reg);                    // send nack bit
        i2c_masterRestartBlocking(reg);             // send restart sequence and wait for it to complete
        i2c_txByte(reg, slaveAddr|I2C_READ);        // write device address byt ewith read bit
        i2c_txNackBlocking(reg);                    // send nack bit
        if(length > 1){
            for(int i = 0; i < length - 1; i++){
                i2c_txByte(reg, 0xFF);              // send 0xFF (Release SDA line) to the slave while generate 8-bit SCL pulses
                i2c_txAckBlocking(reg);             // send ack bit to ask slave to continue send the next byte
                data[i] = i2c_rxData(reg);          // read the data from rx data register and place it into data array
            }
        }
        i2c_txByte(reg, 0xFF);                      // send 0xFF (Release SDA line) to the slave while generate 8-bit SCL pulses
        i2c_txNackBlocking(reg);                    // send nack bit
        data[length-1] = i2c_rxData(reg);           // read the data from rx data register and place it into last data array
        i2c_masterStopBlocking(reg);                // send stop sequence
    }

/*******************************************************************************
*
* This function is to read data with 16-bit register address.
*
* @param   reg: I2C peripheral register base address.
* @param   slaveAddr: Address of the slave device.
* @param   regAddr: 16-bit register address.
* @param   data: Pointer to the data buffer to store read data.
* @param   length: Length of the data buffer.
*
* This function performs a read operation over I2C bus with an 16-bit register address.
* It starts by sending the start sequence followed by the device address with the write bit.
* Then, it sends the register address byte to access. After that, it sends the restart sequence
* to switch from write mode to read mode. Next, it sends the device address byte with the read bit.
* If the length of the data buffer is greater than one, it iterates through the buffer, sending
* 0xFF to generate clock pulses while receiving data bytes from the slave. Finally, it sends the
* stop sequence to complete the transaction.
*
*******************************************************************************/
    static void i2c_readData_w(u32 reg, u8 slaveAddr, u16 regAddr, u8 *data , u32 length){
        i2c_masterStartBlocking(reg);               // Send start sequence
        i2c_txByte(reg, slaveAddr|I2C_WRITE);       // write device address byte with write bit
        i2c_txNackBlocking(reg);                    // send nack bit
        i2c_txByte(reg, ((regAddr >>8) & 0xFF));    // write first byte address
        i2c_txNackBlocking(reg);                    // send nack bit
        i2c_txByte(reg, (regAddr & 0xFF));          // write second byte address
        i2c_txNackBlocking(reg);                    // send nack bit
        i2c_masterRestartBlocking(reg);             // send restart sequence and wait for it to complete
        i2c_txByte(reg, slaveAddr|I2C_READ);        // write device address byt ewith read bit
        i2c_txNackBlocking(reg);                    // send nack bit
        if(length > 1){
            for(int i = 0; i < length - 1; i++){
                i2c_txByte(reg, 0xFF);              // send 0xFF (Release SDA line) to the slave while generate 8-bit SCL pulses
                i2c_txAckBlocking(reg);             // send ack bit to ask slave to continue send the next byte
                data[i] = i2c_rxData(reg);          // read the data from rx data register and place it into data array
            }
        }
        i2c_txByte(reg, 0xFF);                      // send 0xFF (Release SDA line) to the slave while generate 8-bit SCL pulses
        i2c_txNackBlocking(reg);                    // send nack bit
        data[length-1] = i2c_rxData(reg);           // read the data from rx data register and place it into last data array
        i2c_masterStopBlocking(reg);                // send stop sequence
    }





