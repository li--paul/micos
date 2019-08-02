.PHONY: all build clean

OUTPUT = output

BOOT_DIR = bootloader
BOOT_OUTPUT = $(BOOT_DIR)/boot.img
BOOT_SRC = $(BOOT_DIR)/boot.asm
BOOT_INC = $(wildcard $(BOOT_DIR)/**/*.asm)

KERNEL_DIR = kernel
KERNEL_C = $(wildcard $(KERNEL_DIR)/*.c) $(wildcard $(KERNEL_DIR)/mm/*.c)
KERNEL_C_OBJ = $(patsubst %.c, %.o, $(KERNEL_C))
KERNEL_ASM = $(wildcard $(KERNEL_DIR)/*.asm)
KERNEL_ASM_OBJ = $(patsubst %.asm, %.o, $(KERNEL_ASM))
KERNEL_OBJ = $(KERNEL_C_OBJ) $(KERNEL_ASM_OBJ)
KERNEL_SRC = $(KERNEL_DIR)/kernel.c
KERNEL_OUTPUT = $(KERNEL_DIR)/kernel
KERNEL_LINK_SCRIPT = $(KERNEL_DIR)/kernel.ld

LIBC = $(OUTPUT)/libc.a

FLOPPY_OUTPUT = $(OUTPUT)/micos.img

LIB_DIR = lib
LIB_INCLUDE = include
LIB_OBJ = $(patsubst %.c, %.o, $(wildcard $(LIB_DIR)/*.c))

NASM = nasm

LD = ld
LD_OPTIONS = -melf_i386 -s -L$(OUTPUT) -lc
GCC = gcc
GCC_OPTIONS = -c -std=c99 -m32 -nostdinc -fno-builtin -fno-stack-protector -I $(LIB_INCLUDE)

ifeq "$(shell uname)" "Linux"
	TARGET = build
else
	TARGET = docker
endif

all: $(TARGET)

docker:
	docker run -v $(PWD):/micos --rm treelite/micos-dev-env build

build: $(FLOPPY_OUTPUT)

$(FLOPPY_OUTPUT): $(BOOT_OUTPUT) $(KERNEL_OUTPUT)
	node tool/burnFloopy.js $(BOOT_OUTPUT) $(KERNEL_OUTPUT) $(FLOPPY_OUTPUT)

$(BOOT_OUTPUT): $(BOOT_SRC) $(BOOT_INC)
	$(NASM) -f bin -i $(BOOT_DIR)/ -o $(BOOT_OUTPUT) $(BOOT_SRC)

$(KERNEL_OUTPUT): $(KERNEL_OBJ) $(LIBC)
	$(LD) $(KERNEL_OBJ) $(LD_OPTIONS) -T $(KERNEL_LINK_SCRIPT) -o $(KERNEL_OUTPUT)

$(KERNEL_ASM_OBJ): %.o : %.asm
	$(NASM) -f elf -o $@ $<

$(KERNEL_C_OBJ): %.o : %.c
	$(GCC) $(GCC_OPTIONS) -o $@ $<

$(LIBC): $(LIB_OBJ)
	ar -r $(LIBC) $(LIB_OBJ)

$(LIB_OBJ): %.o : %.c
	$(GCC) $(GCC_OPTIONS) -o $@ $<

clean:
	-rm $(BOOT_OUTPUT)
	-rm $(OUTPUT)/*
	-rm $(LIB_DIR)/*.o
	-rm $(KERNEL_OUTPUT)
	-rm $(KERNEL_DIR)/*.o
	-rm $(KERNEL_DIR)/mm/*.o
