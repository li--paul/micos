/**
 * @file PIC
 * @author treelite(c.xinle@gmail.com)
 */

#include "pic.h"

#define PIC_MASTER 0x20
#define PIC_SLAVE 0xA0

#define IRQ_SLAVE 2
#define IRQ_OFFSET 0x20

void init_pic() {
    outb(PIC_MASTER, 0x11);
    outb(PIC_SLAVE, 0x11);

    outb(PIC_MASTER + 1, IRQ_OFFSET);
    outb(PIC_SLAVE + 1, IRQ_OFFSET + 8);

    outb(PIC_MASTER + 1, 1 << IRQ_SLAVE);
    outb(PIC_SLAVE + 1, IRQ_SLAVE);

    outb(PIC_MASTER + 1, 3);
    outb(PIC_SLAVE + 1, 3);

    // 只打开 IRQ0 与 IRQ1
    // 即只开启时钟与键盘中断
    outb(PIC_MASTER + 1, 0xFD);
    // 屏蔽SLAVE所有中断
    outb(PIC_SLAVE + 1, 0xFF);
}
