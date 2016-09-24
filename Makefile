OUTPUT = output
SOURCE = src
INC_DIR = src/include/
nasm = nasm -f bin -i $(INC_DIR)

all: compile
	node tool/burnFloopy.js $(OUTPUT)/boot.img $(OUTPUT)/kernel.img $(OUTPUT)/micos.img

compile: before boot kernel

boot:
	$(nasm) $(SOURCE)/boot.asm -o $(OUTPUT)/boot.img

kernel:
	$(nasm) $(SOURCE)/kernel.asm -o $(OUTPUT)/kernel.img

before: clear
	mkdir output

clear:
	rm -rf output

