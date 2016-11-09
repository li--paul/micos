/**
 * @file Physical memory management
 * @author treelite(c.xinle@gmail.com)
 */

#ifndef _MM_PMM_H_
#define _MM_PMM_H_

#include <stdint.h>
#include <stdbool.h>
#include "../kernel.h"

bool alloc_page(uint32_t *address);
void free_page(uint32_t address);
void init_pmm(uint32_t memory_size);

#endif
