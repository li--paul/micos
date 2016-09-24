;
; 日志相关
;
; treelite(c.xinle@gmail.com)
;

; 显存段地址
V_ADDRESS equ 0B800h

; 显示字符串
; 
; params:
;   {dw} 字符串地址偏移量
log:
    push bp
    mov bp, sp
    push es
    push di
    push ax
    push dx

    mov ax, V_ADDRESS
    mov es, ax
    mov di, [screenPtr]
    mov bx, [bp + 4]

    _print:
    mov al, [bx]
    cmp al, 0
    jz _printEnd
    mov ah, 7
    mov [es:di], ax
    add di, 2
    inc bx
    jmp _print
    _printEnd:
    mov ax, di
    mov dl, 160
    div dl
    inc al
    and ax, 00FFh
    mul dl
    mov [screenPtr], ax
    ; 设置光标位置
    mov dl, 2
    div dl
    and ax, 00FFh
    call _setCursor
    
    pop dx
    pop ax
    pop di
    pop es
    pop bp
    ret 2

; 设置光标位置
;
; params:
;   ax 光标位置
_setCursor:
    push bx
    push dx

    mov bx, ax
    ; 通过 3d4h 与 3d5h I/O 端口对显卡的内部寄存器进行操作
    ; 端口 3d4h 设置要操作的寄存器
    ; 端口 3d5h 接收数据
    ; 0Eh 寄存器用于存储光标位置的高8位
    ; 0Fh 寄存器用于存储光标位置的低8位
    mov al, 0Eh
    mov dx, 3d4h
    out dx, al
    mov dx, 3d5h
    mov al, bh
    out dx, al

    mov al, 0Fh
    mov dx, 3d4h
    out dx, al
    mov dx, 3d5h
    mov al, bl
    out dx, al

    mov ax, bx

    pop dx
    pop bx
    ret
    

; 设置光标位置
;
; params:
;   {dw} 位置信息，低8位为行，高8位为列
setCursor:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx

    mov ax, [bp + 4]
    ; 计算光标位置（行 x 80 + 列）
    mov bx, ax
    mov cl, 80
    mul cl
    mov cl, 8
    shr bx, cl
    add ax, bx

    call _setCursor

    add ax, ax
    mov [screenPtr], ax

    pop cx
    pop bx
    pop ax
    pop bp
    ret 2

; 文本输出的位置索引
screenPtr dw 0
