;
; 日志相关
;
; treelite(c.xinle@gmail.com)
;

; 显存段地址
V_ADDRESS equ 0B800h

; 显示字符串
; 
; Params:
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

    print:
    mov al, [bx]
    cmp al, 0
    jz printEnd
    mov ah, 7
    mov [es:di], ax
    add di, 2
    inc bx
    jmp print
    printEnd:
    mov ax, di
    mov dl, 80
    div dl
    inc al
    and ax, 00FFh
    mul dl
    mov [screenPtr], ax
    
    pop dx
    pop ax
    pop di
    pop es
    pop bp
    ret

; 文本输出的位置索引
screenPtr dw 0
