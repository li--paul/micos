/**
 * @file Interrupt Descriptor Table
 * @author treelite(c.xinle@gmail.com)
 */

#include "idt.h"

#define IDT_SIZE 256
#define INT_GATE 0x8E00
#define INT_TRAP 0xEF00

extern uint32_t _sys_int_[];
extern void _def_int_handler_();
extern void _int_keyboard_();

struct IDTDesc {
    uint16_t offset0_15;
    uint16_t selector;
    uint16_t type;
    uint16_t offset16_31;
} __attribute__ ((packed));

void create_idt_desc(uint16_t selector, uint32_t offset, uint16_t type, struct IDTDesc *desc) {
    desc->offset0_15 = offset  & 0xffff;
    desc->selector = selector;
    desc->type = type;
    desc->offset16_31 = (offset & 0xffff0000) >> 16;
}

void init_idt() {
    int i;
    struct IDTDesc idt[IDT_SIZE];
    // 初始化 IDT
    // 全部填充默认中断处理
    for (i = 0; i < IDT_SIZE; i++) {
        create_idt_desc(CODE_SELECTOR, (uint32_t)_def_int_handler_, INT_GATE, &idt[i]);
    }

    // 添加系统默认异常与中断处理
    for (i = 0; i < 20; i++) {
        if (_sys_int_[i]) {
            create_idt_desc(CODE_SELECTOR, _sys_int_[i], INT_GATE, &idt[i]);
        }
    }

    // Test keyboard handler
    create_idt_desc(CODE_SELECTOR, (uint32_t)_int_keyboard_, INT_GATE, &idt[33]);

    uint16_t len = IDT_SIZE << 3;
    memcpy((char *)IDT_ADDRESS, (char *)idt, len);

    lidt(IDT_ADDRESS, len);
    // Open interruption
    asm("sti");
}

void sys_exception(uint32_t id, uint32_t error_code, uint32_t eip, uint32_t cs, uint32_t eflags) {
    cs_printf("System error: %u\n", id);
}

void int_keyboard() {
    cs_printf("Keyboard, ID: %u\n", 33);
}
