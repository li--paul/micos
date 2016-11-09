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

#define MEM_MAP_BASE 0x510000
#define KERNEL_AREA 0xF00000

#define create_entry(base) (((base) & BASE_MASK) | PG_P | PR_RW)

struct MemMapReg {
    uint8_t *ptr;
    uint32_t len;
};

uint32_t cr0;
uint32_t cr2;
struct MemMapReg mem_map_reg;

void init_mem_map(uint32_t memory_size) {
    uint8_t *ptr = mem_map_reg.ptr = (uint8_t *)MEM_MAP_BASE;
    mem_map_reg.len = memory_size >> 15;
    if (memory_size & 0xFFFF) {
        mem_map_reg.len++;
    }
    for (uint32_t i = 0; i < mem_map_reg.len; i++) {
        *ptr++ = 0;
    }
}

void mark_mem_map(uint32_t index, uint32_t value) {
    uint32_t offset = index >> 3;
    uint32_t inner_index = index & 0x7;
    uint8_t marker = 1 << inner_index;
    uint8_t *ptr = mem_map_reg.ptr;
    ptr += offset;

    if (value) {
        *ptr = *ptr | marker;
    }
    else {
        *ptr = *ptr & marker;
    }
}

long find_mem_map() {
    uint8_t *ptr = mem_map_reg.ptr;
    long res = -1;
    uint8_t c;
    uint8_t b;
    for (uint32_t i = 0; i < mem_map_reg.len; i++) {
        c = *ptr++;
        if (c != 0xFF) {
            res = 0;
            while (res < 8) {
                b = 1 << res;
                if ((c & b) == 0) {
                    break;
                }
                res++;
            }
            res += i << 3;
            break;
        }
    }
    return res;
}

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
    uint32_t p_count = KERNEL_AREA >> 12;
    uint32_t pt_count = p_count >> 10;

    if (p_count & 0x7FF) {
        pt_count++;
    }

    while (i++ < ITEM_COUNT) {
        if (i <= pt_count) {
            uint32_t pt_address = PD_BASE + i * SIZE_4K;
            *p++ = create_entry(pt_address);
            init_page_table((uint32_t *)pt_address, (i - 1) * SIZE_4M, p_count);
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

    init_mem_map(memory_size);
    uint32_t len = KERNEL_AREA >> 12;
    if (KERNEL_AREA & 0xFFF) {
        len++;
    }
    for (i = 0; i < len; i++) {
        mark_mem_map(i, 1);
    }

    // Load cr3
    asm("mov %0, %%cr3"::"r"(PD_BASE));

    // Enable paging
    asm("mov %%cr0, %0":"=r"(cr0));
    cr0 |= 0x80000000;
    asm("mov %0, %%cr0"::"r"(cr0));
}

void int_page_fault(uint32_t id, uint32_t error_code, uint32_t eip, uint32_t cs, uint32_t eflags) {
    // Get invalid address
    asm("mov %%cr2, %0":"=r"(cr2));

    uint32_t *ptr = (uint32_t *)PD_BASE;
    uint32_t index_pd = cr2 >> 22;
    uint32_t index_pt = (cr2 >> 12) & 0x3FF;
    uint32_t pt_address = PD_BASE + index_pd * SIZE_4K;
    ptr += index_pd;

    // Create page directory
    if (*ptr == 0) {
        *ptr = create_entry(pt_address);
    }

    ptr = (uint32_t *)pt_address;
    ptr += index_pt;
    // Create page entry
    if (*ptr == 0) {
        long index_page = find_mem_map();
        if (index_page >= 0) {
            mark_mem_map((uint32_t)index_page, 1);
            *ptr = create_entry(SIZE_4K * (uint32_t)index_page);
        }
    }

    // Refresh TLB
    asm("invlpg (%0)"::"r"(cr2));
}
