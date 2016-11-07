/**
 * @file Paging
 * @author treelite(c.xinle@gmail.com)
 */

#include "paging.h"

#define PG_P 1
#define PR_RW 2

#define BASE_MASK 0xFFFFF000

#define PD_BASE 0x100000

#define ITEM_COUNT 1024
#define SIZE_4K 0x1000
#define SIZE_4M 0x400000

#define create_entry(base) ((base & BASE_MASK) | PG_P | PR_RW)

uint32_t cr0;

void init_page_table(uint32_t *ptr, uint32_t base, uint32_t count) {
    for (int i = 0; i < ITEM_COUNT; i++) {
        if (i < count) {
            *ptr++ = create_entry(base);
            base += SIZE_4K;
        }
        else {
            *ptr++ = 0;
        }
    }
}

void init_paging(uint32_t memory_size) {
    uint32_t i = 0;
    uint32_t *p = (uint32_t *)PD_BASE;
    uint32_t p_count = memory_size >> 12;
    uint32_t pt_count = p_count >> 10;
    if (p_count % ITEM_COUNT) {
        pt_count++;
    }

    while (i++ < ITEM_COUNT) {
        if (i <= pt_count) {
            uint32_t pt_address = PD_BASE + i * SIZE_4K;
            *p++ = create_entry(pt_address);
            p_count -= ITEM_COUNT;
            init_page_table(
                (uint32_t *)pt_address,
                (i - 1) * SIZE_4M,
                p_count > 0 ? ITEM_COUNT : p_count + ITEM_COUNT
            );
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
