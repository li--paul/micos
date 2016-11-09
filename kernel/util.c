/**
 * @file Util
 * @author treelite(c.xinle@gmail.com)
 */

#include "util.h"

inline void set_cr0(uint32_t value) {
    asmv("mov %0, %%cr0" :: "r"(value));
}

inline void set_cr2(uint32_t value) {
    asmv("mov %0, %%cr2" :: "r"(value));
}

inline void set_cr3(uint32_t value) {
    asmv("mov %0, %%cr3" :: "r"(value));
}

inline uint32_t get_cr0() {
    uint32_t res;
    asmv("mov %%cr0, %0" : "=r"(res));
    return res;
}

inline uint32_t get_cr2() {
    uint32_t res;
    asmv("mov %%cr2, %0" : "=r"(res));
    return res;
}

inline uint32_t get_cr3() {
    uint32_t res;
    asmv("mov %%cr3, %0" : "=r"(res));
    return res;
}

inline void invlpg(uint32_t address) {
    asmv("invlpg (%0)" :: "r"(address));
}

inline void lidt(uint32_t base, uint16_t len) {
    struct {
        uint16_t len;
        uint32_t base;
    } __attribute__ ((packed)) idtr = {len, base};
    asm("lidt %0" :: "m"(idtr));
}
