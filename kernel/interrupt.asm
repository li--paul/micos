;
; Interrupt & exception
;
; treelite(c.xinle@gmail.com)
;

global _def_handler_

_def_handler_:
    mov ah, 0x0C
    mov al, 'X'
    mov [gs:0], ax
    ; send EOI
    mov al, 0x20
    out 0x20, al
    iretd
