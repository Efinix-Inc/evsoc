
#include "bsp.h"
#include "i2c.h"
#include "i2cDemo.h"
#include "riscv.h"
#include "CoralCam.h"
#include "common.h"

int i2c_WriteRegData(u8 addr,u16 reg,u8 data) {
    i2c_masterStartBlocking(I2C_CTRL_MIPI);

    i2c_txByte(I2C_CTRL_MIPI, addr<<1);
    i2c_txNackBlocking(I2C_CTRL_MIPI);
    i2c_txByte(I2C_CTRL_MIPI, (reg>>8) & 0xFF);
    i2c_txNackBlocking(I2C_CTRL_MIPI);
    i2c_txByte(I2C_CTRL_MIPI, (reg) & 0xFF);
    i2c_txNackBlocking(I2C_CTRL_MIPI);
    i2c_txByte(I2C_CTRL_MIPI, data & 0xFF);
    i2c_txNackBlocking(I2C_CTRL_MIPI);
    i2c_masterStopBlocking(I2C_CTRL_MIPI);
    return 0;
}

u8 i2c_ReadRegData(u8 addr, u16 reg) {
   u8 outdata;
   
   i2c_masterStartBlocking(I2C_CTRL_MIPI);
   
   i2c_txByte(I2C_CTRL_MIPI, addr<<1);
   i2c_txNackBlocking(I2C_CTRL_MIPI);
   
   i2c_txByte(I2C_CTRL_MIPI, (reg>>8) & 0xFF);
   i2c_txNackBlocking(I2C_CTRL_MIPI);
   
   i2c_txByte(I2C_CTRL_MIPI, (reg) & 0xFF);
   i2c_txNackBlocking(I2C_CTRL_MIPI);
   
   i2c_masterStopBlocking(I2C_CTRL_MIPI);
   i2c_masterStartBlocking(I2C_CTRL_MIPI);
   
   i2c_txByte(I2C_CTRL_MIPI, (addr<<1) | 0x01);
   i2c_txNack(I2C_CTRL_MIPI);
   i2c_txAckWait(I2C_CTRL_MIPI);
   
   i2c_txByte(I2C_CTRL_MIPI, 0xFF);
   i2c_txNack(I2C_CTRL_MIPI);
   i2c_txAckWait(I2C_CTRL_MIPI);
   
   outdata = i2c_rxData(I2C_CTRL_MIPI);
   
   i2c_masterStopBlocking(I2C_CTRL_MIPI);
   
   return outdata;
}

//write CoralCam_configuration to cam
int CoralCam_configure(i2c_reg_config_t *cfg, u32 len) {
    int ret = 0;
    for (int i=0 ; i<len; ++i) {
        ret = i2c_WriteRegData(CORALCAM_I2C_ADDRESS, cfg[i].reg, cfg[i].data);
        if (ret)
            return ret; 
    }

    return 0;
}

void CoralCam_init(void) {
   // set 1920*1080
   for (int i = 0; i < 318; i++){
      i2c_WriteRegData(CORALCAM_I2C_ADDRESS, cam_config[i].reg, cam_config[i].data);
      bsp_uDelay((cam_config[i].msleep)*1000)
   }
   
   for (int i = 0; i < 4095; i++){
      i2c_WriteRegData(CORALCAM_I2C_ADDRESS, af_firmware[i].reg, af_firmware[i].data);
      bsp_uDelay((af_firmware[i].msleep)*1000)
   }
   
   // Enable Auto Focus
   CoralCam_enable_afc();
   
   uart_writeStr(BSP_UART_TERMINAL, "\n\rDone Camera Init");
}

// CoralCam enable auto focus continous
void CoralCam_enable_afc(void) {
   CoralCam_configure(af_cont_cfg, sizeof(af_cont_cfg)/sizeof(af_cont_cfg[0]));
}

// CoralCam release auto focus
void CoralCam_af_release(void) {
   CoralCam_configure(af_release, sizeof(af_release)/sizeof(af_release[0]));
}

// CoralCam Trigger auto focus
void CoralCam_af_trigger(void) {
   CoralCam_configure(af_trigger_cfg, sizeof(af_trigger_cfg)/sizeof(af_trigger_cfg[0]));
}

// CoralCam Exposure control
void CoralCam_set_ev(u8 ev_state) {
   CoralCam_configure(ev_cfg[ev_state], sizeof(ev_cfg[ev_state])/sizeof(ev_cfg[ev_state][0]));
}
