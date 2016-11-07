/**
 * @file I/O port
 * @author treelite(c.xinle@gmail.com)
 */

#include "io.h"
#include "kernel.h"

void outb(uint16_t port, uint8_t data) {
    asmv("outb %%al, %%dx" :: "d"(port), "a"(data));
}

uint8_t inb(uint16_t port) {
    uint8_t res;
    asmv("inb %%dx, %%al" : "=a"(res) : "d"(port));
    return res;
}
