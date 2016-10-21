/**
 * @file PIC
 * @author treelite(c.xinle@gmail.com)
 */

#ifndef _PIC_H_
#define _PIC_H_

#include <stdint.h>
#include <string.h>
#include "kernel.h"
#include "console.h"
#include "io.h"

void init_interrupt();
void sys_exception(uint32_t id, uint32_t error_code, uint32_t eip, uint32_t cs, uint32_t eflags);

#endif
