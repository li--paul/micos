;
; IO 相关
;
; treelite(c.xinle@gmail.com)
;

; 从磁盘读取扇区
; 使用 LAB 方式
;
; params:
;   {dw} 扇区数
;   {dw} 起始扇区编号
;   es:bx 缓冲区地址
readFloopy:
    push bp
    ; 保存当前的栈顶指针
    ; 方便后续访问调用参数
    mov bp, sp
    push ax
    push cx
    push dx

    ; 获取起始扇区编号参数
    mov ax, [bp + 4]
    mov dx, 0
    ; 计算磁头编号
    div word [FL_H_LEN]
    push dx
    mov dh, al
    
    ; 设置磁道编号
    pop ax
    div byte [FL_C_LEN]
    mov ch, al

    ; 设置起始扇区编号
    add ah, 1
    mov cl, ah

    ; 设置驱动器为软盘
    mov dl, 0

    ; 设置需要读取的扇区数
    mov al, [bp + 6]

    ; 设置磁盘读取的功能号
    mov ah, 2

    ; 调用 BIOS 磁盘服务
    ; 对外部存储设备进行操作
    int 13h

    pop dx
    pop cx
    pop ax
    pop bp

    ; 从栈上释放4字节的函数参数
    ret 4

; 扇区大小
SECTOR_LEN dw 512
; 单磁头的扇区数
FL_H_LEN dw 1440
; 单磁道的扇区数
FL_C_LEN db 18
