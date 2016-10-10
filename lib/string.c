/**
 * @file String
 * @author treelite(c.xinle@gmail.com)
 */

#include <string.h>

int strlen(char *str) {
    int len = 0;
    int i = 0;
    while (str[i] !== '\0') {
        len++;
    }
    return len;
}
