/**
 * @file Kernel
 * @author treelite(c.xinle@gmail.com)
 */

#ifndef _KERNEL_H_
#define _KERNEL_H_

#include "util.h"

#define IDT_ADDRESS 0
#define PD_ADDRESS 0x200000
#define MMAP_ADDRESS 0x100000

#define KERNEL_RESERVED_SIZE 0xA00000

#define CODE_SELECTOR 0x8

#define S_1K 10
#define S_4K 12
#define S_1M 20
#define S_4M 22

#endif
