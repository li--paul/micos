/**
 * @file Variable Argument Lists
 * @author treelite(c.xinle@gmail.com)
 */

#ifndef _STD_ARG_H
#define _STD_ARG_H

#include <stdint.h>

typedef char * va_list;

#define _sizeof32_(type) ((sizeof(type) + sizeof(uint32_t) - 1) & ~(sizeof(uint32_t) - 1))
#define va_start(va, last_arg) (va = (va_list)&last_arg + _sizeof32_(last_arg))
#define va_arg(va, type) (*(type *)((va += _sizeof32_(type)) - _sizeof32_(type)))
#define va_end(va) (va = (va_list) 0)

#endif
