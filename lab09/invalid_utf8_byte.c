#include <stdint.h>
#include <stddef.h>

static int is_cont(uint8_t b) {
    return (b & 0xC0) == 0x80;
}

// Do NOT change this function's return type or signature.
int invalid_utf8_byte(char *utf8_string) {
    if (utf8_string == NULL) return 0;

    for (size_t i = 0; utf8_string[i] != '\0'; ) {

        uint8_t b = (uint8_t)utf8_string[i];

        if ((b & 0x80) == 0) {
            i += 1;
            continue;
        }

        size_t need = 0;
        if ((b & 0xE0) == 0xC0) {
            need = 1;
        }
        else if ((b & 0xF0) == 0xE0) {
            need = 2;
        }
        else if ((b & 0xF8) == 0xF0) {
            need = 3;
        }
        else {
            return (int)i;
        }

        for (size_t j = 1; j <= need; j++) {
            uint8_t nxt = (uint8_t)utf8_string[i + j];
            if (nxt == 0)
                return (int)i + j;
            if (!is_cont(nxt))
                return (int)(i + j);
        }

        i += need + 1;
    }

    return -1;
}

// 11110000 1001 1111 1001 1000
