/**
 * @file Util
 * @author treelite(c.xinle@gmail.com)
 */

#ifndef _UTIL_H_
#define _UTIL_H_

#include <stdint.h>

#define asm __asm__
#define asmv __asm__ __volatile__

#define ceil(n, e) ((n >> e) + (n & (1 << e - 1) ? 1 : 0))

void set_cr0(uint32_t value);
void set_cr2(uint32_t value);
void set_cr3(uint32_t value);

uint32_t get_cr0();
uint32_t get_cr2();
uint32_t get_cr3();

void invlpg(uint32_t address);
void lidt(uint32_t base, uint16_t len);

#endif
