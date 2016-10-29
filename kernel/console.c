/**
 * @file Console
 * @author treelite(c.xinle@gmail.com)
 */

#include "console.h"

#define VGA_ADDRESS 0xB8000
#define MAX_LINES 20
#define MAX_COLUMNS 80

#define COLOR_MASK 0x700

static uint32_t cursor_x = 0;
static uint32_t cursor_y = 0;

uint32_t get_offset() {
    return (cursor_y * MAX_COLUMNS + cursor_x) << 1;
}

uint16_t *get_address() {
    return (uint16_t *)(VGA_ADDRESS + get_offset());
}

void scroll_up() {
    uint32_t len = get_offset() - 2 * MAX_COLUMNS;
    char *base = (char *)(VGA_ADDRESS + MAX_COLUMNS * 2);
    char *target = (char *)VGA_ADDRESS;
    memcpy(base, target, len);

    uint16_t *p = (uint16_t *)(VGA_ADDRESS + len);
    int max = 2 * MAX_COLUMNS;
    int i = 0;
    while (i++ < max) {
        *p++ = 0;
    }
}

void next_line() {
    if (cursor_y + 1 >= MAX_LINES) {
        scroll_up();
    }
    else {
        cursor_y++;
    }
}

void forword() {
    cursor_x++;
    if (cursor_x >= MAX_COLUMNS) {
        next_line();
        cursor_x = 0;
    }
}

void update_cursor() {
    uint16_t pos = cursor_x + cursor_y * MAX_COLUMNS;
    outb(0x3D4, 0x0F);
    outb(0x3D5, (uint8_t)(pos & 0xFF));
    outb(0x3D4, 0x0E);
    outb(0x3D5, (uint8_t)((pos >> 8) & 0xFF));
}

void putc(char c) {
    if (c == '\r') {
        cursor_x = 0;
    }
    else if (c == '\n') {
        cursor_x = 0;
        next_line();
    }
    else {
        uint16_t *ptr = get_address();
        *ptr = COLOR_MASK | c;
        forword();
    }
    update_cursor();
}

void reverse(char *buffer, uint32_t len) {
    uint32_t mid = len / 2;
    char c;
    for (uint32_t i = 0; i < mid; i++) {
        c = buffer[i];
        buffer[i] = buffer[len - i - 1];
        buffer[len - i - 1] = c;
    }
}

uint32_t itoa(uint32_t value, char *buffer, uint32_t base) {
    uint32_t len = 0;

    do {
        uint32_t r = value % base;
        value /= base;
        if (r < 10) {
            buffer[len++] = '0' + r;
        }
        else {
            buffer[len++] = 'A' + r - 10;
        }
    }
    while (value);

    reverse(buffer, len);
    return len;
}

int print_arg(char c, va_list ap) {
    int res = 1;
    if (c == 'u') {
        uint32_t v = va_arg(ap, uint32_t);
        char buffer[32];
        uint32_t len = itoa(v, buffer, 10);
        uint32_t i = 0;
        while (i < len) {
            putc(buffer[i++]);
        }
    }
    else {
        res = 0;
    }

    return res;
}

void cs_printf(char *str, ...) {
    va_list ap;
    va_start(ap, str);

    while (*str) {
        if (*str == '%' && print_arg(*(str + 1), ap)) {
            str++;
        }
        else {
            putc(*str);
        }
        str++;
    }
    va_end(ap);
}
