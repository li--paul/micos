;
; Interrupt & exception
;
; treelite(c.xinle@gmail.com)
;

NO_ERROR equ 0

; 默认中断处理函数
global _def_int_handler_
global _int_keyboard_

; idt.c
extern sys_exception
; idt.c
extern int_keyboard
; mm/paging.c
extern int_page_fault

_def_int_handler_:
    ; Do nothing
    jmp _end_interrupt_

_int_keyboard_:
    call int_keyboard
    jmp _end_interrupt_

_end_interrupt_:
    ; Send EOI to complete a interruption
    mov al, 0x20
    out 0x20, al
    iretd

_div_fault_:
    push NO_ERROR
    push 0
    jmp _sys_exception_

_debug_exception_:
    push NO_ERROR
    push 1
    jmp _sys_exception_

_nmi_:
    push NO_ERROR
    push 2
    jmp _sys_exception_

_break_point_:
    push NO_ERROR
    push 3
    jmp _sys_exception_

_overflow_:
    push NO_ERROR
    push 4
    jmp _sys_exception_

_over_bound_:
    push NO_ERROR
    push 5
    jmp _sys_exception_

_inval_opcode_:
    push NO_ERROR
    push 6
    jmp _sys_exception_

_copr_not_available_:
    push NO_ERROR
    push 7
    jmp _sys_exception_

_double_fault_:
    push 8
    jmp _sys_exception_

_over_segment_:
    push NO_ERROR
    push 9
    jmp _sys_exception_

_inval_tss_:
    push 10
    jmp _sys_exception_

_no_segment_:
    push 11
    jmp _sys_exception_

_ss_fault_:
    push 12
    jmp _sys_exception_

_general_protection_:
    push 13
    jmp _sys_exception_

_page_fault_:
    push 14
    call int_page_fault
    jmp _end_sys_exception_

_math_fault_:
    push NO_ERROR
    push 16
    jmp _sys_exception_

_align_check_:
    push 17
    jmp _sys_exception_

_machine_check_:
    push NO_ERROR
    push 18
    jmp _sys_exception_

_float_fault_:
    push NO_ERROR
    push 19
    jmp _sys_exception_

_sys_exception_:
    call sys_exception
_end_sys_exception_:
    add esp, 8
    iretd

section .data
global _sys_int_
; 系统默认异常与中断
_sys_int_:
    dd _div_fault_
    dd _debug_exception_
    dd _nmi_
    dd _break_point_
    dd _overflow_
    dd _over_bound_
    dd _inval_opcode_
    dd _copr_not_available_
    dd _double_fault_
    dd _over_segment_
    dd _inval_tss_
    dd _no_segment_
    dd _ss_fault_
    dd _general_protection_
    dd _page_fault_
    ; intel 保留位
    dd 0
    dd _math_fault_
    dd _align_check_
    dd _machine_check_
    dd _float_fault_
