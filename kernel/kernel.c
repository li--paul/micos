/**
 * @file Kernel
 * @author treelite(c.xinle@gmail.com)
 */

#include "pic.h"

void init() {
    pic_init();
    load_idt();
}

int _main() {
    init();
    return 0;
}
