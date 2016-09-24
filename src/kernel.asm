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
%include 'util.asm'
%include 'cmos.asm'

; 入口代码
_start:
mov ax, cs
; 设置数据段
mov ds, ax
; 设置栈
; 在代码段下方
sub ax, 1000h
mov ss, ax
mov sp, 0

; 打印欢迎文字
mov ax, MSG_TEXT
push ax
; log 用于在屏幕上输出字符串
call log

; 设置定时器中断
; 保存 ds 的值是由于后面需要重新设置 ds 的值来配合 bx 进行基址寻址定位中断表
push ds
; 中断表从 0000h:0000h 位置开始，共 1024 字节
; 故将 ds 设置位 0h
mov ax, 0h
mov ds, ax
; 定时器中断号为 08h
; 其中每一项是 4 字节，低 16 位为处理程序的地址偏移量，高 16 位为处理程序的段地址
; 所以 08h * 04h 就是定时器中断在中断表中的偏移量
mov bx, 08h * 04h
; 设置中断处理程序的地址偏移量
mov word [bx], ClockInter
add bx, 2
; 设置中断处理程序的段地址
mov word [bx], cs
pop ds

jmp $

ClockInter:
    ; 关闭中断的响应
    ; 也就是说在进行定时器中断处理的过程中不再响应其它中断请求
    cli

    ; 设置光标在第0行第61列（时间一共19个字符）
    ; ah 表示列，al 表示行
    mov ax, 3D00h
    push ax
    call setCursor

    push TIME_TEXT
    ; 获取当前时间的字符串
    call getTimeStr
    push TIME_TEXT
    ; 输出字符串
    call log

    ; 通知 PIC 中断处理已结束
    ; 不然 PIC 不会继续产生中断
    mov al, 20h
    out 20h, al

    ; 中断处理过程的返回必须使用 iret 而不是 ret
    ; 因为相较普通过程而言，中断处理过程在退出时除了需要从栈中出栈 IP 外
    ; 还需要出栈 CS 并且开启中断响应
    iret

MSG_TEXT db 'Welcome to Kernel', 0
; 时间字符串
TIME_TEXT times 19 db 0

; 设置结束标示 用于计算整个内核的大小
_end:
