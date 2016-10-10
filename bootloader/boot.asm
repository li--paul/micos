;
; 系统引导程序
;
; treelite(c.xinle@gmail.com)
;

; 引导程序会被 BIOS 加载到 0x7C00 位置
; 使用 org 可以指定后续所有的编译地址都加上这个偏移量
; 以使编译后的地址与实际运行地址一致
org 7C00h

; 内核文件的加载地址
KERNEL_ADDRESS equ 0x7E00

; 指定为16位汇编
bits 16

; 加载内核文件
; 读取引导区后内核文件到 0x7E00 位置
mov ax, 0x7E0
mov es, ax
mov bx, 0
; TODO
; 假设内核文件大小在10个扇区以内
; 一次性加载内核文件
mov ax, 10
push ax
mov ax, 1 ;从2号扇区开始加载
push ax
call readSector

; 准备进入保护模式
cli

; 加载全局描述符表
lgdt [GDTR]

; 打开第21条地址线(A20)
in al, 0x92
or al, 2
out 0x92, al

; 开启保护模式
mov eax, cr0
or al, 1
mov cr0, eax

; 远跳，其目的是刷新 CS 段寄存器
; 并且终止CPU流线操作，抛弃所有已进入流水管线执行的结果
; 0x8 为段选择子，选择代码段
jmp 0x8:p_mode

%include 'util/io.asm'

; 以下代码开始使用 32 位编码
bits 32
p_mode:
    ; 重新设置所有的段寄存器
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ax, 0x18
    mov ss, ax
    mov eax, 0
    mov esp, eax


	; 展开内核文件到 0x200000
	mov esi, KERNEL_ADDRESS
	; Save kernel entry
	mov eax, [esi + 24]

	mov [KERNEL_ENTRY], eax
	; Program header offset
	mov ebx, [esi + 28]
	; Program header item size
	mov edx, 0
	mov dx, [esi + 42]
	; Program header item count
	mov ecx, 0
	mov cx, [esi + 44]

	; Read program header
	add esi, ebx
	loadProgram:
		; p_type
		mov eax, [esi]
		cmp eax, 1
		jnz nextProgram

		; load program segment
		; Segment size
		push ecx
		mov ecx, [esi + 20]

		; Segment virtual address
		mov edi, [esi + 8]

		; Segment file address
		push esi
		mov ebx, [esi + 4]
		mov esi, KERNEL_ADDRESS
		add esi, ebx


		cpySegment:
			lodsb
			stosb
			loop cpySegment

		pop esi
		pop ecx

	nextProgram:
		add esi, edx
		loop loadProgram

	mov eax, 0
	; 执行正真的内核
	call [KERNEL_ENTRY]
	; 检查执行结果
	cmp eax, 0
	jz end
	push eax
	call printReg
	end jmp $

%include 'util/log32.asm'

; 全局描述符表
; TODO 区分内核段与用户段
GDT:
    ; Null
    times 2 dd 0
    ; Code descriptor
	; all memory
    dw 0xFFFF ; 段界限(低16位)
    dw 0      ; 段基地址(低16位)
    db 0      ; 段基地址(中8位) 0
    db 0x9A   ; 1001 1010（P:1, DPL:0, S:1, TYPE:1010）
    db 0xCF   ; 1100 1111 (G:1, D/B:1, L:0, AVL:0, 段界限高4位:1111)
    db 0      ; 段基地址(高8位)
    ; Data descriptor
	; all memory
    dw 0xFFFF
    dw 0
    db 0
    db 0x92   ; 10010010
    db 0xCF   ; 11001111
    db 0
    ; Stack descriptor
	; 0x100000 - 0x1FFFFF
    dw 0xFEFF
    dw 0
    db 0x20
    db 0x96   ; 10010110
    db 0xCF   ; 11001111
    db 0
GDT_LEN equ $ - GDT

; 全局描述符表地址与界限
GDTR:
    dw GDT_LEN - 1
    dd GDT

; 内核入口地址
KERNEL_ENTRY dd 0

; 填充剩余的扇区空间
; 并标记当前扇区为引导区
times 512 - 2 - ($ - $$) db 0
; 以 0xAA55 结尾的扇区是可引导扇区
dw 0AA55h
