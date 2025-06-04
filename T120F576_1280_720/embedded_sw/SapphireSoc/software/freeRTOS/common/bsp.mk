BSP_PATH ?= ${STANDALONE}/../../bsp/${BSP}
LWIP_PATH ?= ${BSP_PATH}/app/lwip
FATFS_PATH ?= ${BSP_PATH}/app/fatfs
CFLAGS += -I${BSP_PATH}/include
CFLAGS += -I${BSP_PATH}/app

include ${BSP_PATH}/include/soc.mk

LDSCRIPT ?= ${BSP_PATH}/linker/freertos.ld
