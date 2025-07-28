// Multiply a float by 2048 using bit operations only

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

#include "floats.h"

// float_2048 is given the bits of a float f as a uint32_t
// it uses bit operations and + to calculate f * 2048
// and returns the bits of this value as a uint32_t
//
// if the result is too large to be represented as a float +inf or -inf is returned
//
// if f is +0, -0, +inf or -inf, or Nan it is returned unchanged
//
// float_2048 assumes f is not a denormal number
//
uint32_t float_2048(uint32_t f) {
    // PUT YOUR CODE HERE
    float_components_t components;
    components.sign = (f >> 31) & 1;
    components.exponent = ((f << 1) >> 24) & 0xFF;
    components.fraction = f & 0x7FFFFF;
    //components.exponent = components.exponent + 0x2048;
    // uint32_t pos_inf = 0x7F800000;

    //uint32_t zero_comp = 0;

    if (components.sign == 0 && components.exponent >= 0xFF && components.fraction == 0) {
        return f;
    } else if (components.sign == 1 && components.exponent >= 0xFF && components.fraction == 0) {
        return f;
    } else if (components.exponent >= 0xFF && components.fraction != 0) {
        return f;
    } else if (components.sign == 0 && components.exponent == 0 && components.fraction == 0) {
        return f;
    } else if (components.sign == 1 && components.exponent == 0 && components.fraction == 0) {
        return f;
    }

    components.exponent += 11;
    if (components.exponent >= 0xFF) {
        return components.sign ? 0xFF800000 : 0x7F800000;  // -inf 或 +inf
    }
    uint32_t result = (components.sign << 31) |
                      (components.exponent << 23) |
                      (components.fraction);
    return result;

}

