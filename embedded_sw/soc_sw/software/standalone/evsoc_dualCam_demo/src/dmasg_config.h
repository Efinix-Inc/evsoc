#ifndef DMASG_CONFIG_H
#define DMASG_CONFIG_H

//For DMA interrupt
uint32_t cam1_s2mm_active;
uint32_t cam2_s2mm_active;
uint32_t display_mm2s_active;
uint32_t hw_accel_s2mm_active;
uint32_t hw_accel_mm2s_1_active;
uint32_t hw_accel_mm2s_2_active;

#define DMASG_BASE            IO_APB_SLAVE_1_APB
#define PLIC_DMASG_CHANNEL    SYSTEM_PLIC_USER_INTERRUPT_A_INTERRUPT

//Each channel connects to only 1 port, hence all ports are referred as port 0.
#define DMASG_CAM1_S2MM_CHANNEL        0
#define DMASG_CAM1_S2MM_PORT           0

#define DMASG_CAM2_S2MM_CHANNEL        1
#define DMASG_CAM2_S2MM_PORT           0

#define DMASG_DISPLAY_MM2S_CHANNEL     2
#define DMASG_DISPLAY_MM2S_PORT        0

#define DMASG_HW_ACCEL_S2MM_CHANNEL    3
#define DMASG_HW_ACCEL_S2MM_PORT       0

#define DMASG_HW_ACCEL_MM2S_1_CHANNEL  4
#define DMASG_HW_ACCEL_MM2S_1_PORT     0

#define DMASG_HW_ACCEL_MM2S_2_CHANNEL  5
#define DMASG_HW_ACCEL_MM2S_2_PORT     0

void trap_entry();

void dma_init(){
   //configure PLIC
   plic_set_threshold(BSP_PLIC, BSP_PLIC_CPU_0, 0); //cpu 0 accept all interrupts with priority above 0
   
   //enable PLIC DMASG channel 0 interrupt listening (But for the demo, we enable the DMASG internal interrupts later)
   plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, PLIC_DMASG_CHANNEL, 1);
   plic_set_priority(BSP_PLIC, PLIC_DMASG_CHANNEL, 1);
   
   //enable interrupts
   csr_write(mtvec, trap_entry); //Set the machine trap vector (../common/trap.S)
   csr_set(mie, MIE_MEIE); //Enable external interrupts
   csr_write(mstatus, MSTATUS_MPP | MSTATUS_MIE);
}

//Used on unexpected trap/interrupt codes
void crash(){
   bsp_putString("\n*** CRASH ***\n");
   while(1);
}

void flush_data_cache(){
   asm(".word(0x500F)");
}

#endif
