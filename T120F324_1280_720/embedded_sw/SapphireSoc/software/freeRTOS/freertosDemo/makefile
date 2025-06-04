PROJ_NAME=freertosDemo

STANDALONE = ..

CFLAGS+=-DSMP

FREERTOS=${FreeRTOS_KERNEL_SRC}/FreeRTOS/Source
FREERTOS_RISCV=${FREERTOS}/portable/GCC/RISC-V

SRCS = 	$(wildcard src/*.c) \
		$(wildcard src/*.cpp) \
		$(wildcard src/*.S) \
		$(wildcard ${FREERTOS}/*.c) \
        ${FREERTOS}/portable/MemMang/heap_4.c \
        ${FREERTOS_RISCV}/port.c \
        ${FREERTOS_RISCV}/portASM.S \
        ${STANDALONE}/common/start.S

CFLAGS += -Isrc
CFLAGS += -I../driver
CFLAGS += -I${FREERTOS}/include
CFLAGS += -I${FREERTOS_RISCV}
CFLAGS += -DportasmHANDLE_INTERRUPT=external_interrupt_handler

include ${STANDALONE}/common/bsp.mk
include ${STANDALONE}/common/riscv64-unknown-elf.mk
include ${STANDALONE}/common/standalone.mk

LDSCRIPT = ${BSP_PATH}/linker/freertos.ld
