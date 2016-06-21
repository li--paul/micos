OUTPUT = output
SOURCE = src

all: compile
	node tool/burnFloopy.js $(OUTPUT)/boot.img $(OUTPUT)/micos.img

compile: before boot

boot:
	nasm -f bin $(SOURCE)/boot.asm -o $(OUTPUT)/boot.img

before: clear
	mkdir output

clear:
	rm -rf output

