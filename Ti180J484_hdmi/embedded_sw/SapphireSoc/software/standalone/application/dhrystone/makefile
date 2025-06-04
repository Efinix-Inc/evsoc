PROJ_NAME=dhrystone

STANDALONE=../..

CFLAGS+=-DSMP

DEBUG=no
BENCH=yes

CFLAGS += -fno-inline -fno-common
CFLAGS += -Wno-implicit-int -Wno-implicit-function-declaration -ffunction-sections
CFLAGS += -DTIME -DCORE_HZ=12000000ll

SRCS = 	$(wildcard src/*.c) \
		$(wildcard src/*.cpp) \
		$(wildcard src/*.S) \
        ${STANDALONE}/common/start.S

include ${STANDALONE}/common/bsp.mk
include ${STANDALONE}/common/riscv64-unknown-elf.mk
include ${STANDALONE}/common/standalone.mk

LDSCRIPT = ${BSP_PATH}/linker/default.ld
