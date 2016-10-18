/**
 * @file PIC
 * @author treelite(c.xinle@gmail.com)
 */

#include "pic.h"

const uint16_t PIC_MASTER = 0x20;
const uint16_t PIC_SLAVE = 0xA0;

const int IDT_SIZE = 256;
const uint16_t INT_GATE = 0xE;
const uint16_t INT_TRAP = 0xF;

const uint8_t IRQ_SLAVE = 2;
const uint8_t IRQ_OFFSET = 0x20;

const uint8_t CODE_SELECTOR = 0x08;

const uint32_t IDT_ADDRESS = 0;

struct IDTDesc {
    uint16_t offset0_15;
    uint16_t selector;
    uint16_t type;
    uint16_t offset16_31;
} __attribute__ ((packed));

struct IDTReg {
    uint16_t limit;
    uint32_t base;
} __attribute__ ((packed));

extern void _def_handler_();

struct IDTReg idt_reg;

void pic_init() {
    outb(PIC_MASTER, 0x11);
    outb(PIC_SLAVE, 0x11);

    outb(PIC_MASTER + 1, IRQ_OFFSET);
    outb(PIC_SLAVE + 1, IRQ_OFFSET + 8);

    outb(PIC_MASTER + 1, 1 << IRQ_SLAVE);
    outb(PIC_SLAVE + 1, IRQ_SLAVE);

    outb(PIC_MASTER + 1, 3);
    outb(PIC_SLAVE + 1, 3);

    // 屏蔽所有中断
    outb(PIC_MASTER + 1, 0xFF);
    outb(PIC_SLAVE + 1, 0xFF);
}

void create_idt_desc(uint16_t selector, uint32_t offset, uint16_t type, struct IDTDesc *desc) {
    desc->offset0_15 = offset  & 0xffff;
    desc->selector = selector;
    desc->type = type;
    desc->offset16_31 = (offset & 0xffff0000) >> 16;
}

void load_idt() {
    struct IDTDesc idt[IDT_SIZE];
    for (int i = 0; i < IDT_SIZE; i++) {
        create_idt_desc(CODE_SELECTOR, (uint32_t)_def_handler_, INT_GATE, &idt[i]);
    }

    idt_reg.limit = 8 * IDT_SIZE;
    idt_reg.base = IDT_ADDRESS;

    memcpy((char *)idt_reg.base, (char *)idt, idt_reg.limit);
    asm("lidtl (idt_reg)");
}
