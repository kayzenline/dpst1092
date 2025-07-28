// Author: JIAWEN LIN
// Date: 17/05/2025
// z5647814
// Convert an 8 digit Packed BCD Value to an Integer

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

#define N_BCD_DIGITS 8

uint32_t packed_bcd(uint32_t packed_bcd);

int main(int argc, char *argv[]) {

    for (int arg = 1; arg < argc; arg++) {
        long l = strtol(argv[arg], NULL, 0);
        assert(l >= 0 && l <= UINT32_MAX);
        uint32_t packed_bcd_value = l;

        printf("%lu\n", (unsigned long)packed_bcd(packed_bcd_value));
    }

    return 0;
}

// given a packed BCD encoded value between 0 .. 99999999
// return the corresponding integer
uint32_t packed_bcd(uint32_t packed_bcd_value) {

    // PUT YOUR CODE HERE
    uint32_t result = 0;
    for(int i = N_BCD_DIGITS - 1; i >= 0; i--) {
        uint32_t digit = (packed_bcd_value >> (i * 4)) & 0xF;
        result = result * 10 + digit; 
    }
    return result;
}
