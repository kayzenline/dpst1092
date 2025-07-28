// Author: JIAWEN LIN
// Date: 17/05/2025
// z5647814
// Convert a 16-bit signed integer to a string of binary digits

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

#define N_BITS 16

char *sixteen_out(int16_t value);

int main(int argc, char *argv[]) {

    for (int arg = 1; arg < argc; arg++) {
        long l = strtol(argv[arg], NULL, 0);
        assert(l >= INT16_MIN && l <= INT16_MAX);
        int16_t value = l;

        char *bits = sixteen_out(value);
        printf("%s\n", bits);

        free(bits);
    }

    return 0;
}

// given a signed 16 bit integer
// return a null-terminated string of 16 binary digits ('1' and '0')
// storage for string is allocated using malloc
char *sixteen_out(int16_t value) {

    // PUT YOUR CODE HERE
    char *bits = malloc(N_BITS + 1);
    if(bits == NULL) {
        perror("malloc failed");
    }
    uint16_t uvalue = (uint16_t)value;
    for(int i = N_BITS - 1; i >= 0; i--) {
        uint16_t shifted = uvalue >> i;
        uint16_t bit = shifted & 1;
        int j = N_BITS - 1 - i;
        if(bit == 1) {
            bits[j] = '1';
        } else {
            bits[j] = '0';
        }
    }
    bits[N_BITS] = '\0';
    return bits;
}

