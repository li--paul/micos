/**
 * @file String
 * @author treelite(c.xinle@gmail.com)
 */

#include <string.h>

int strlen(char *str) {
    int len = 0;
    int i = 0;
    while (str[i++] != '\0') {
        len++;
    }
    return len;
}

void memcpy(void *desc, const void *src, uint32_t n) {
    char *p = (char *)desc;
    char *s = (char *)src;
    while (n--) {
        *p++ = *s++;
    }
}
