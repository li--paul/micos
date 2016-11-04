/**
 * @file Paging
 * @author treelite(c.xinle@gmail.com)
 */

#include "paging.h"

#define PG_P 1
#define PR_RW 2

#define BASE_MASK 0xFFFFF000

#define PD_BASE 0x100000

// 16 page tables
// Control 64M memory
#define PT_COUNT 16

#define ITEM_COUNT 1024
#define SIZE_4K 0x1000
#define SIZE_4M 0x400000

#define create_entry(base) ((base & BASE_MASK) | PG_P | PR_RW)

uint32_t cr0;

void create_page_table(uint32_t *ptr, uint32_t base) {
    for (int i = 0; i < ITEM_COUNT; i++) {
        *ptr++ = create_entry(base);
        base += SIZE_4K;
    }
}

void init_paging() {
    uint32_t i = 0;
    uint32_t *p = (uint32_t *)PD_BASE;

    while (i++ < ITEM_COUNT) {
        if (i <= PT_COUNT) {
            uint32_t pt_address = PD_BASE + i * SIZE_4K;
            *p++ = create_entry(pt_address);
            create_page_table((uint32_t *)pt_address, (i - 1) * SIZE_4M);
        }
        // Uninitial page directory entry
        // over physical memory
        else {
            *p++ = 0;
        }
    }

    // Load cr3
    asm("mov %0, %%cr3"::"r"(PD_BASE));

    // Enable paging
    asm("mov %%cr0, %0":"=r"(cr0));
    cr0 |= 0x80000000;
    asm("mov %0, %%cr0"::"r"(cr0));
}
