
#include "typedef.h"
#include "bsp.h"
#include "i2c.h"
#include "i2cDemo.h" //From BSP
#include "common.h"
#include "hdmi_common.h"
#include "hdmi_driver.h"

void WriteRegData_HDMI(u8 reg, u8 data)
{

    i2c_masterStartBlocking(I2C_CTRL_HDMI);

    i2c_txByte(I2C_CTRL_HDMI, HDMI_TX_I2C_SLAVE_ADDR);
	i2c_txNackBlocking(I2C_CTRL_HDMI);
	assert(i2c_rxAck(I2C_CTRL_HDMI)); // Optional check

	i2c_txByte(I2C_CTRL_HDMI, reg);
	i2c_txNackBlocking(I2C_CTRL_HDMI);
	assert(i2c_rxAck(I2C_CTRL_HDMI)); // Optional check

	i2c_txByte(I2C_CTRL_HDMI, data);
	i2c_txNackBlocking(I2C_CTRL_HDMI);
	assert(i2c_rxAck(I2C_CTRL_HDMI)); // Optional check

	i2c_masterStopBlocking(I2C_CTRL_HDMI);
}


u8 ReadRegData_HDMI(u8 reg)
{
	u8 outdata;

    i2c_masterStartBlocking(I2C_CTRL_HDMI);

    i2c_txByte(I2C_CTRL_HDMI, HDMI_TX_I2C_SLAVE_ADDR);
	i2c_txNackBlocking(I2C_CTRL_HDMI);
	assert(i2c_rxAck(I2C_CTRL_HDMI)); // Optional check

	i2c_txByte(I2C_CTRL_HDMI, reg);
	i2c_txNackBlocking(I2C_CTRL_HDMI);
	assert(i2c_rxAck(I2C_CTRL_HDMI)); // Optional check

	i2c_masterStartBlocking(I2C_CTRL_HDMI);

	i2c_txByte(I2C_CTRL_HDMI, HDMI_TX_I2C_SLAVE_ADDR | 0x01);
	i2c_txNackBlocking(I2C_CTRL_HDMI);
	assert(i2c_rxAck(I2C_CTRL_HDMI)); // Optional check

	i2c_txByte(I2C_CTRL_HDMI, 0xFF);
	i2c_txNackBlocking(I2C_CTRL_HDMI);
	outdata = i2c_rxData(I2C_CTRL_HDMI);

	i2c_masterStopBlocking(I2C_CTRL_HDMI);

	return outdata;
}

u8 ReadRegData_LVDS(u8 reg)
{
	u8 outdata;

    i2c_masterStartBlocking(I2C_CTRL_HDMI);

    i2c_txByte(I2C_CTRL_HDMI, IT6263_LVDS_SLAVE_ADDR);
	i2c_txNackBlocking(I2C_CTRL_HDMI);
	assert(i2c_rxAck(I2C_CTRL_HDMI)); // Optional check

	i2c_txByte(I2C_CTRL_HDMI, reg);
	i2c_txNackBlocking(I2C_CTRL_HDMI);
	assert(i2c_rxAck(I2C_CTRL_HDMI)); // Optional check

	i2c_masterStopBlocking(I2C_CTRL_HDMI);

	i2c_masterStartBlocking(I2C_CTRL_HDMI);

	i2c_txByte(I2C_CTRL_HDMI, IT6263_LVDS_SLAVE_ADDR | 0x01);
	i2c_txNackBlocking(I2C_CTRL_HDMI);
	assert(i2c_rxAck(I2C_CTRL_HDMI)); // Optional check

	i2c_txByte(I2C_CTRL_HDMI, 0xFF);
	i2c_txNackBlocking(I2C_CTRL_HDMI);
	outdata = i2c_rxData(I2C_CTRL_HDMI);
	i2c_masterStopBlocking(I2C_CTRL_HDMI);

	return outdata;
}

void WriteRegData_LVDS(u8 reg, u8 data)
{
    i2c_masterStartBlocking(I2C_CTRL_HDMI);

    i2c_txByte(I2C_CTRL_HDMI, IT6263_LVDS_SLAVE_ADDR);
	i2c_txNackBlocking(I2C_CTRL_HDMI);
	assert(i2c_rxAck(I2C_CTRL_HDMI)); // Optional check

	i2c_txByte(I2C_CTRL_HDMI, reg);
	i2c_txNackBlocking(I2C_CTRL_HDMI);
	assert(i2c_rxAck(I2C_CTRL_HDMI)); // Optional check

	i2c_txByte(I2C_CTRL_HDMI, data);
	i2c_txNackBlocking(I2C_CTRL_HDMI);
	assert(i2c_rxAck(I2C_CTRL_HDMI)); // Optional check

	i2c_masterStopBlocking(I2C_CTRL_HDMI);
}


BYTE ReadI2C_Byte(BYTE RegAddr)
{
    BYTE p_data;

    p_data=ReadRegData_HDMI(RegAddr);

    return p_data;
}

SYS_STATUS WriteI2C_Byte(BYTE RegAddr, BYTE d)
{

    WriteRegData_HDMI(RegAddr,d);

    return ER_SUCCESS;
}

SYS_STATUS ReadI2C_ByteN(BYTE RegAddr, BYTE *pData, int N)
{
    BOOL flag;
    int i;
    for(i=0;i<N;i++)
    	pData[i]=ReadRegData_HDMI(RegAddr+i);


    return ER_SUCCESS;
}

void delay1ms(USHORT ms)
{
	bsp_uDelay(ms*1000);
}

