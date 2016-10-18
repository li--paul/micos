/**
 * @file PIC
 * @author treelite(c.xinle@gmail.com)
 */

#ifndef _PIC_H_
#define _PIC_H_

#include <stdint.h>
#include <string.h>
#include "kernel.h"
#include "io.h"

void pic_init();
void load_idt();

#endif
