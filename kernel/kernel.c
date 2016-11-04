/**
 * @file Kernel
 * @author treelite(c.xinle@gmail.com)
 */

#include "pic.h"
#include "paging.h"

void init() {
    init_paging();
    init_interrupt();
}

int _main() {
    init();
    return 0;
}
