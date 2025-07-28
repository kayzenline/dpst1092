// Author: JIAWEN LIN
// Date: 17/05/2025
// z5647814
//Convert a 2 digit BCD Value to an Integer

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

int bcd(int bcd_value);

int main(int argc, char *argv[]) {

    for (int arg = 1; arg < argc; arg++) {
        long l = strtol(argv[arg], NULL, 0);
        assert(l >= 0 && l <= 0x0909);
        int bcd_value = l;

        printf("%d\n", bcd(bcd_value));
    }

    return 0;
}

// given a  BCD encoded value between 0 .. 99
// return corresponding integer
int bcd(int bcd_value) {

    // PUT YOUR CODE HERE
    int tens = (bcd_value >> 8) & 0xF;//1111
    int ones = bcd_value & 0xF;
    return 10*tens + ones;
}

