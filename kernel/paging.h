/**
 * @file Paging
 * @author treelite(c.xinle@gmail.com)
 */

#ifndef _PAGING_H_
#define _PAGING_H_

#include "kernel.h"
#include <stdint.h>

void init_paging(uint32_t memory_size);
void int_page_fault();

#endif
