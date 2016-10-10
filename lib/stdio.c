/**
 * @fle Standard IO
 * @author treelite(c.xinle@gmail.com)
 */

#include <stdio.h>
#include <string.h>

static const int VGA_ADDRESS = 0xB8000;

void print(char *str) {
    int len = strlen(str);
    char *p;
    p = VGA_ADDRESS;
    for (int i = 0; i < len; i++) {
        *p = str[i];
        p++;
        *p = 7;
        p++;
    }
}
