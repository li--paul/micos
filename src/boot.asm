; 引导程序会被 BIOS 加载到 0x0000:0x7C00 位置
; 使用 org 可以指定后续所有的编译地址都加上这个偏移量
; 以使编译后的地址与实际运行地址一致
org 7C00h

; 指定为16位汇编
bits 16

; 针对 8086 CPU
; 所有的 x86 CPU 在启动后都只相当于 8086，也就是工作在实模式
cpu 8086

; 将显存的段地址赋值给 es
; 通过直接操作显存的方式来显示字符串
mov ax, 0B800h
mov es, ax

; 设置 di 为 0
; es:di 就指向了显存的第一个字节
mov di, 0

; 设置 si 为需要显示的字符串首地址偏移量
; ds:si 就指向了字符串的第一个字节（ds 默认为 0）
mov si, MSG_TEXT

; 将字符串的长度赋值给 cx
; 方便后续循环输出字符串
mov cx, [MSG_TEXT_LEN]

; 设置显示字符的样式
; 在文本模式下，显存的奇数字节为需要显示的 ASCII 编码
; 偶数字节为字符对应的样式
mov ah, 7

; 循环输出字符串
print:
	; 从 ds:si 中读取一个字节的字符到 al，并将 si 加一
	lodsb
	; 将 al 中的字符存放在 es:di 中，并将 di 加一
	stosw
	; cx 减一 如果 cx 不为 0 则跳转到 print 处
	loop print

; 死循环
; 运行到这里就可以了
jmp $

; 申明需要显示的字符串
MSG_TEXT db 'Hello, World!'
; 字符串长度
MSG_TEXT_LEN db $ - MSG_TEXT

; 填充剩余的扇区空间
; 并标记当前扇区为引导区
times 512 - 2 - ($ - $$) db 0
; 以 0xAA55 结尾的扇区是可引导扇区
dw 0AA55h
