/**
 * @file Kernel
 * @author treelite(c.xinle@gmail.com)
 */

#include "pic.h"

void init() {
    init_interrupt();
}

int _main() {
    init();
    return 0;
}
