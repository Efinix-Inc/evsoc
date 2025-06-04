PROJ_NAME=iCacheFlushDemo

STANDALONE=../..

CFLAGS+=-DSMP

SRCS = 	$(wildcard src/*.c) \
		$(wildcard src/*.cpp) \
		$(wildcard src/*.S) \
        ${STANDALONE}/common/start.S

include ${STANDALONE}/common/bsp.mk
include ${STANDALONE}/common/riscv64-unknown-elf.mk
include ${STANDALONE}/common/standalone.mk

LDFLAGS += -fPIC
LDSCRIPT = ${BSP_PATH}/linker/default.ld


