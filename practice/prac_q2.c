// DPST1092 25T2 ... prac exam, question 2
// return 1 if the uint32_t value is a binary palindrome
// return 0 otherwise

#include <stdint.h>

int reserve(uint32_t value) {
    uint32_t back = value & 0xFFFF;
    uint32_t front = value >> 16;
    for(int i = 15; i >= 0; i--){
        if(((front >> i)&1) != ((back >> (15 - i))&1)){
            return 0;
        } 
        
    }
    return 1;
}
int prac_q2(uint32_t value){
    // YOUR CODE HERE

    return reserve(value);
}

