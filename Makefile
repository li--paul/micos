OUTPUT = output

BOOT_DIR = bootloader
BOOT_OUTPUT = $(OUTPUT)/boot.img
BOOT_SRC = $(BOOT_DIR)/boot.asm

KERNEL_DIR = kernel
KERNEL_OBJ = $(OUTPUT)/kernel.o
KERNEL_SRC = $(KERNEL_DIR)/kernel.c
KERNEL_OUTPUT = $(OUTPUT)/kernel
KERNEL_LINK_SCRIPT = $(KERNEL_DIR)/kernel.ld

FLOPPY_OUTPUT = $(OUTPUT)/micos.img

NASM = nasm
NASM_OPTIONS = -f bin

LD = ld
LD_OPTIONS = -melf_i386 -s
GCC = gcc
GCC_OPTIONS = -c -m32 -nostdinc -fno-builtin -fno-stack-protector

all: build burn

build: boot kernel

boot:
	$(NASM) $(NASM_OPTIONS) -i $(BOOT_DIR)/ -o $(BOOT_OUTPUT) $(BOOT_SRC)

kernel: compileKernel linkKerenl

compileKernel:
	$(GCC) $(GCC_OPTIONS) -o $(KERNEL_OBJ) $(KERNEL_SRC)

linkKerenl:
	$(LD) $(LD_OPTIONS) -T $(KERNEL_LINK_SCRIPT) -o $(KERNEL_OUTPUT) $(KERNEL_OBJ)

burn:
	node tool/burnFloopy.js $(BOOT_OUTPUT) $(KERNEL_OUTPUT) $(FLOPPY_OUTPUT)
