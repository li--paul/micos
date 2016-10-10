OUTPUT = output

BOOT_DIR = bootloader
BOOT_OUTPUT = $(BOOT_DIR)/boot.img
BOOT_SRC = $(BOOT_DIR)/boot.asm

KERNEL_DIR = kernel
KERNEL_OBJ = $(KERNEL_DIR)/kernel.o
KERNEL_SRC = $(KERNEL_DIR)/kernel.c
KERNEL_OUTPUT = $(KERNEL_DIR)/kernel
KERNEL_LINK_SCRIPT = $(KERNEL_DIR)/kernel.ld

LIBC = $(OUTPUT)/libc.a

FLOPPY_OUTPUT = $(OUTPUT)/micos.img

LIB_DIR = lib
LIB_OBJ = $(patsubst %.c, %.o, $(wildcard $(LIB_DIR)/*.c))

NASM = nasm
NASM_OPTIONS = -f bin

LD = ld
LD_OPTIONS = -melf_i386 -s -L$(OUTPUT) -lc
GCC = gcc
GCC_OPTIONS = -c -std=c99 -m32 -nostdinc -fno-builtin -fno-stack-protector -I $(LIB_DIR)

all: build burn

build: boot kernel

boot:
	$(NASM) $(NASM_OPTIONS) -i $(BOOT_DIR)/ -o $(BOOT_OUTPUT) $(BOOT_SRC)

kernel: $(KERNEL_OBJ) $(LIBC)
	$(LD) $(KERNEL_OBJ) $(LD_OPTIONS) -T $(KERNEL_LINK_SCRIPT) -o $(KERNEL_OUTPUT)

$(KERNEL_OBJ): $(KERNEL_SRC)
	$(GCC) $(GCC_OPTIONS) -o $@ $<

$(LIBC): $(LIB_OBJ)
	ar -r $(LIBC) $(LIB_OBJ)

$(LIB_OBJ): %.o : %.c
	$(GCC) $(GCC_OPTIONS) -o $@ $<

burn:
	node tool/burnFloopy.js $(BOOT_OUTPUT) $(KERNEL_OUTPUT) $(FLOPPY_OUTPUT)
