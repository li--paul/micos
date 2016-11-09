;
; Interrupt & exception
;
; treelite(c.xinle@gmail.com)
;

NO_ERROR equ 0

; 默认中断处理函数
global _def_interrupt_handler_

global _keyboard_handler_

extern sys_exception_handler

extern inter_keyboard
extern int_page_fault

_def_interrupt_handler_:
    ; Do nothing
    ; Just send EOI
    mov al, 0x20
    out 0x20, al
    iretd

_keyboard_handler_:
    call inter_keyboard
    mov al, 0x20
    out 0x20, al
    iretd

_div_fault_:
    push NO_ERROR
    push 0
    jmp sys_exception

_debug_exception_:
    push NO_ERROR
    push 1
    jmp sys_exception

_nmi_:
    push NO_ERROR
    push 2
    jmp sys_exception

_break_point_:
    push NO_ERROR
    push 3
    jmp sys_exception

_overflow_:
    push NO_ERROR
    push 4
    jmp sys_exception

_over_bound_:
    push NO_ERROR
    push 5
    jmp sys_exception

_inval_opcode_:
    push NO_ERROR
    push 6
    jmp sys_exception

_copr_not_available_:
    push NO_ERROR
    push 7
    jmp sys_exception

_double_fault_:
    push 8
    jmp sys_exception

_over_segment_:
    push NO_ERROR
    push 9
    jmp sys_exception

_inval_tss_:
    push 10
    jmp sys_exception

_no_segment_:
    push 11
    jmp sys_exception

_ss_fault_:
    push 12
    jmp sys_exception

_general_protection_:
    push 13
    jmp sys_exception

_page_fault_:
    push 14
    call int_page_fault
    jmp end_sys_exception

_math_fault_:
    push NO_ERROR
    push 16
    jmp sys_exception

_align_check_:
    push 17
    jmp sys_exception

_machine_check_:
    push NO_ERROR
    push 18
    jmp sys_exception

_float_fault_:
    push NO_ERROR
    push 19
    jmp sys_exception

sys_exception:
    call sys_exception_handler
end_sys_exception:
    add esp, 8
    iretd

section .data
global _sys_interrupts_
; 系统默认异常与中断
_sys_interrupts_:
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
    dd _def_interrupt_handler_
    dd _math_fault_
    dd _align_check_
    dd _machine_check_
    dd _float_fault_
