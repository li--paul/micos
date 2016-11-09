/**
 * @file Physical memory management
 * @author treelite(c.xinle@gmail.com)
 */

#include "pmm.h"

#define MMAP_USED 1
#define MMAP_UNUSED 0

static uint32_t mmap_size;
static const uint32_t mmap_max_size = 1 << S_1M;
static uint8_t *mmap_base = (uint8_t *)MMAP_ADDRESS;

void init_pmm(uint32_t memory_size) {
    // Ceil to 4K
    mmap_size = ceil(memory_size, S_4K);
    uint32_t reserved = ceil(KERNEL_RESERVED_SIZE, S_4K);

    uint8_t *ptr = mmap_base;
    for (uint32_t i = 0; i < mmap_max_size; i++) {
        *ptr++ = i < reserved ? MMAP_USED : MMAP_UNUSED;
    }
}

bool alloc_page(uint32_t *address) {
    uint8_t *ptr = mmap_base;
    uint32_t index = 0;

    while (index < mmap_size && *ptr++ != MMAP_UNUSED) {
        index++;
    }

    if (index >= mmap_size) {
        return false;
    }

    ptr += index;
    *ptr = MMAP_USED;

    *address = index << S_4K;
    return true;
}

void free_page(uint32_t address) {
    uint32_t index = address >> S_4K;
    uint8_t *ptr = mmap_base;
    ptr += index;
    *ptr = MMAP_UNUSED;
}
