;
; 工具函数集
;
; treelite(c.xinle@gmail.com)
;

; 将 BCD 编码转化为 ASCII
;
; params:
;   {dw} BCD
;   {dw} 目标地址偏移量
bcd2Str:
    push bp
    mov bp, sp
    push ax
    push cx
    push bx

    ; 获取目标字符串地址参数
    mov bx, [bp + 4]
    ; 获取 BCD 参数
    mov ax, [bp + 6]

    mov ah, al
    ; 处理十位（高4位）
    mov cx, 4
    shr al, cl
    ; 数字加 30h 就是对应的 ASCII 码
    add al, 30h
    mov byte [bx], al
    inc bx

    ; 处理个位（低4位）
    mov al, ah
    and al, 0Fh
    add al, 30h
    mov byte [bx], al

    pop bx
    pop cx
    pop ax
    pop bp
    ret 4
