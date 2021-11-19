#ifndef DMASG_CONFIG_H
#define DMASG_CONFIG_H

#define DMASG_BASE            IO_APB_SLAVE_0_APB
#define PLIC_DMASG_CHANNEL    SYSTEM_PLIC_USER_INTERRUPT_A_INTERRUPT

//Each channel connects to only 1 port, hence all ports are referred as port 0.
#define DMASG_CAM_S2MM_CHANNEL         0
#define DMASG_CAM_S2MM_PORT            0

#define DMASG_DISPLAY_MM2S_CHANNEL     1
#define DMASG_DISPLAY_MM2S_PORT        0

#define DMASG_HW_ACCEL_S2MM_CHANNEL    2
#define DMASG_HW_ACCEL_S2MM_PORT       0

#define DMASG_HW_ACCEL_MM2S_CHANNEL    3
#define DMASG_HW_ACCEL_MM2S_PORT       0

void trap_entry();

//Used on unexpected trap/interrupt codes
void crash(){
   bsp_putString("\n*** CRASH ***\n");
   while(1);
}

void flush_data_cache(){
   asm(".word(0x500F)");
}

#endif
