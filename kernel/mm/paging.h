/**
 * @file Paging
 * @author treelite(c.xinle@gmail.com)
 */

#ifndef _MM_PAGING_H_
#define _MM_PAGING_H_

#include <stdint.h>
#include "../kernel.h"
#include "pmm.h"

void init_paging();
void int_page_fault();

#endif
