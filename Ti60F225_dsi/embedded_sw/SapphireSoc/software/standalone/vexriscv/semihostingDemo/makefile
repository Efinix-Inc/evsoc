PROJ_NAME=semihostingDemo

STANDALONE=../..

CFLAGS+=-DSMP

DEBUG?=no
DEBUG_OG?=no

SRCS =  $(wildcard src/*.c) \
        $(wildcard src/*.cpp) \
        $(wildcard src/*.S) \
        ${STANDALONE}/common/start.S

include ${STANDALONE}/common/bsp.mk
include ${STANDALONE}/common/riscv64-unknown-elf.mk
include ${STANDALONE}/common/standalone.mk

LDSCRIPT = ${BSP_PATH}/linker/default.ld