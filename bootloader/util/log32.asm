;
; 保护模式下的控制台输出函数
;
; treelite(c.xinle@gmail.com)
;

VGA_ADDRESS equ 0xB8000

; 显示寄存器内容
;
; params:
;    {dw} 寄存器内容
printReg:
    push ebp
    mov ebp, esp
    push eax
    push edx
    push ebx
    push ecx
    push edi

    mov edi, VGA_ADDRESS

    mov ecx, 0
    mov eax, [ebp + 8]
    mov ebx, 16
    _opDiv:
        mov edx, 0
        div ebx
        push edx
        add ecx, 1
        cmp eax, 0
        jnz _opDiv
    _print:
        pop eax
        cmp eax, 10
        jb _toChar
        add eax, 7
        _toChar:
            add eax, 48
        mov ah, 7
        mov [edi], ax
        add edi, 2
        loop _print

    pop edi
    pop ecx
    pop ebx
    pop edx
    pop eax
    pop ebp
    ret 4

; 显示字符串
;
; params:
;    {dw} 字符串长度
;    {dw} 字符串地址
printStr:
    push ebp
    mov ebp, esp
    push ecx
    push eax
    push edi
    push esi

    ; 字符串地址
    mov esi, [ebp + 8]
    ; 字符串长度
    mov ecx, [ebp + 12]
    ; 显存地址
    mov edi, VGA_ADDRESS
    mov eax, 0
    mov ah, 7

    _printLoop:
        lodsb
        stosw
        loop _printLoop

    pop esi
    pop edi
    pop eax
    pop ecx
    pop ebp
    ret 8
