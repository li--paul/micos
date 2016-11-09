/**
 * @file Paging
 * @author treelite(c.xinle@gmail.com)
 */

#include "paging.h"

#define PG_P 1
#define PR_RW 2

#define ADDRESS_MASK 0xFFFFF000

#define ITEM_COUNT 1024

#define create_entry(base) (((base) & ADDRESS_MASK) | PG_P | PR_RW)

void init_page_table(uint32_t *ptr, uint32_t base, uint32_t count) {
    for (int i = 0; i < ITEM_COUNT; i++) {
        if (i < count) {
            *ptr++ = create_entry(base);
            base += 1 << S_4K;
        }
        else {
            *ptr++ = 0;
        }
    }
}

void init_paging() {
    uint32_t i = 0;
    uint32_t *p = (uint32_t *)PD_ADDRESS;
    uint32_t p_count = KERNEL_RESERVED_SIZE >> S_4K;
    uint32_t pt_count = ceil(p_count, S_1K);
    uint32_t pt_address;

    while (i++ < ITEM_COUNT) {
        if (i <= pt_count) {
            pt_address = PD_ADDRESS + (i << S_4K);
            *p++ = create_entry(pt_address);
            init_page_table((uint32_t *)pt_address, (i - 1) << S_4M, p_count);
            if (p_count >= ITEM_COUNT) {
                p_count -= ITEM_COUNT;
            }
        }
        // Uninitial page directory entry
        // over physical memory
        else {
            *p++ = 0;
        }
    }

    // Load cr3
    set_cr3(PD_ADDRESS);

    // Enable paging
    uint32_t cr0 = get_cr0();
    cr0 |= 0x80000000;
    set_cr0(cr0);
}

void int_page_fault() {
    // Get invalid address
    uint32_t linear_address = get_cr2();
    uint32_t *ptr = (uint32_t *)PD_ADDRESS;
    uint32_t index_pd = linear_address >> S_4M;
    uint32_t index_pt = (linear_address >> S_4K) & 0x3FF;
    uint32_t address = PD_ADDRESS + (index_pd + 1 << S_4K);
    ptr += index_pd;

    // Create page directory
    if (*ptr == 0) {
        *ptr = create_entry(address);
    }

    ptr = (uint32_t *)address;
    ptr += index_pt;
    // Create page entry
    if (*ptr == 0) {
        if (alloc_page(&address)) {
            *ptr = create_entry(address);
        }
    }

    // Refresh TLB
    invlpg(linear_address);
}
