# Generated makefile for evsoc_selfCheck.

PROJ_NAME = evsoc_selfCheck

STANDALONE = ..
SRCS = $(wildcard src/*.c)  \
       $(wildcard src/*.cpp) \
       $(wildcard src/*.S)   \
       $(wildcard src/driver/*.c) \
       $(wildcard src/selfCheck/*.c) \
       ${STANDALONE}/common/start.S \
       ${STANDALONE}/common/trap.S

CFLAGS += -Isrc/selfCheck
CFLAGS += -Isrc/driver
CFLAGS += -Isrc

include ${STANDALONE}/common/bsp.mk
include ${STANDALONE}/common/riscv64-unknown-elf.mk
include ${STANDALONE}/common/standalone.mk
