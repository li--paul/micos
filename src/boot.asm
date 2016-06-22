;
; 系统引导程序
;
; treelite(c.xinle@gmail.com)
;

; 引导程序会被 BIOS 加载到 0x0000:0x7C00 位置
; 使用 org 可以指定后续所有的编译地址都加上这个偏移量
; 以使编译后的地址与实际运行地址一致
org 7C00h

; 指定为16位汇编
bits 16

; 针对 8086 CPU
; 所有的 x86 CPU 在启动后都只相当于 8086，也就是工作在实模式
cpu 8086

; 内核加载地址
K_ADDRESS equ 3000h

; 设置内核加载地址
mov ax, K_ADDRESS
mov es, ax
mov bx, 0
; 保存内核代码段地址
mov [KERNEL_ENTRY + 2], ax

; 设置 boot 栈地址
mov ax, K_ADDRESS
sub ax, 1000h
mov ss, ax
mov sp, 0

; 尝试读取 boot 后的一个扇区
; 获取内核的头信息
mov ax, 1
push ax
push ax
call readFloopy

; 获取内核大小
mov ax, [es:bx]
mov dx, [es:bx + 2]
; 获取内核入口地址偏移量
mov cx, [es:bx + 4]
; 保存内核入口地址偏移量
mov [KERNEL_ENTRY], cx

; 用内核大小除以扇区字节数
; 以确定是否需要继续加载内核
div word [SECTOR_LEN]
cmp ax, 0
jz runKernel

; 继续加载剩余的内核代码
push ax
mov ax, 2
push ax
add bx, [SECTOR_LEN]
call readFloopy

; 跳转至内核入口地址继续执行
runKernel jmp far [KERNEL_ENTRY]

%include 'io.asm'

; 内核的入口地址
KERNEL_ENTRY dd 0

; 填充剩余的扇区空间
; 并标记当前扇区为引导区
times 512 - 2 - ($ - $$) db 0
; 以 0xAA55 结尾的扇区是可引导扇区
dw 0AA55h
