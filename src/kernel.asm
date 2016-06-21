;
; 系统内核
;
; treelite(c.xinle@gmail.com)
;

; 内核头部信息区域
; 内核大小
dd _end
; 内核入口地址
dw _start

; 引入 log 文件
; 不同于 boot.asm, 外部引用可以放在执行代码之前
; 因为内核有了一个固定的入口点
%include 'log.asm'

; 入口代码
_start:
; 设置栈
; 在代码段下方
mov ax, cs
mov ss, ax
mov sp, 0FFFFh
; 设置数据段
mov ds, ax

; 打印文本
mov ax, MSG_TEXT
push ax
; log 用于在屏幕上输出字符串
call log
jmp $

MSG_TEXT db 'Hello, world! (from Kernel)', 0

; 设置结束标示 用于计算整个内核的大小
_end:
