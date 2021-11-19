PROJ_NAME=evsoc_ispExample
STANDALONE = ..


DEBUG = yes
DEBUG_og = no

SRCS = $(wildcard src/*.c) \
		 $(wildcard src/*.cpp) \
		 $(wildcard src/*.S) \
		 ${STANDALONE}/common/start.S  \
       ${STANDALONE}/common/trap.S

include ${STANDALONE}/common/bsp.mk
include ${STANDALONE}/common/riscv64-unknown-elf.mk
include ${STANDALONE}/common/standalone.mk
