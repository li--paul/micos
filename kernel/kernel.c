/**
 * @file Kernel
 * @author treelite(c.xinle@gmail.com)
 */

#include <stdint.h>
#include "pic.h"
#include "idt.h"
#include "mm/pmm.h"
#include "mm/paging.h"
#include "console.h"

void init(uint32_t memory_size) {
    init_pmm(memory_size);
    init_paging();
    init_pic();
    init_idt();
}

int _main(uint32_t memory_size) {
    init(memory_size);
    cs_printf("Welcome to MicOS\n");
    // Paging test
    int *n = (int *)0x800003FF;
    *n = 1;
    cs_printf("This variable is %u, come from %h\n", *n, n);
    return 0;
}
