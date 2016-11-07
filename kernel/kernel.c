/**
 * @file Kernel
 * @author treelite(c.xinle@gmail.com)
 */

#include <stdint.h>
#include "pic.h"
#include "paging.h"
#include "console.h"

void init(uint32_t memory_size) {
    init_paging(memory_size);
    init_interrupt();
}

int _main(uint32_t memory_size) {
    init(memory_size);
    cs_printf("Welcome to MicOS\n");
    return 0;
}
