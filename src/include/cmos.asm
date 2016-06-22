;
; CMOS 相关
;
; treelite(c.xinle@gmail.com)
;

; 获取系统时钟信息
;
; params:
;   {dw} 字符串地址
getTimeStr:
    push bp
    mov bp, sp
    push ax
    push bx

    mov ax, 0

    ; 使用 bx 存储目标字符串的偏移地址
    mov bx, [bp + 4]

    ; 以下部分通过对 CMOS 的端口访问，获取时间
    ; 70h 与 71h 端口是 CMOS 的输入输出端口 
    ; 通过 70h 端口告知 CMOS 需要访问的数据，再通过 71h 获取数据

    ; 获取世纪数
    mov al, 32h
    out 70h, al
    ; 从 CMOS 获取到达数字是使用 BCD 方式编码的
    ; 即使用一个字节表示两位十进制数，高4位表示十位数，低4位表示个位数
    in al, 71h
    ; 下面这部分调用 bcd2Str 将 BCD 编码的数字转化成 ASCII 并存入目的地字符串地址中
    push ax
    push bx
    call bcd2Str
    add bx, 2

    ; 获取年份
    mov al, 09h
    out 70h, al
    in al, 71h
    push ax
    push bx
    call bcd2Str
    add bx, 2

    ; 添加分割符
    mov byte [bx], '-'
    inc bx

    ; 获取月份
    mov al, 08h
    out 70h, al
    in al, 71h
    push ax
    push bx
    call bcd2Str
    add bx, 2

    ; 添加分割符
    mov byte [bx], '-'
    inc bx

    ; 获取日期
    mov al, 07h
    out 70h, al
    in al, 71h
    push ax
    push bx
    call bcd2Str
    add bx, 2

    ; 添加分割符
    mov byte [bx], ' '
    inc bx

    ; 获取小时
    mov al, 04h
    out 70h, al
    in al, 71h
    push ax
    push bx
    call bcd2Str
    add bx, 2

    ; 添加分割符
    mov byte [bx], ':'
    inc bx

    ; 获取分钟
    mov al, 02h
    out 70h, al
    in al, 71h
    push ax
    push bx
    call bcd2Str
    add bx, 2

    ; 添加分割符
    mov byte [bx], ':'
    inc bx

    ; 获取秒
    mov al, 00h
    out 70h, al
    in al, 71h
    push ax
    push bx
    call bcd2Str

    pop bx
    pop ax
    pop bp
    ret 2
