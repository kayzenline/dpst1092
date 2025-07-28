// // // // // // // // DO NOT CHANGE THIS FILE! // // // // // // // //
// DPST1092 25T2 ... prac exam, question 2

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

int prac_q2(uint32_t x);

#ifdef main
#undef main
#endif

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <number>\n", argv[0]);
        return EXIT_FAILURE;
    }

    uint32_t input = strtoul(argv[1], NULL, 0);

    int result = prac_q2(input);
    if(result == 0){
    	printf("0x%x is NOT a binary palindrome\n", input);
    } else {
    	printf("0x%x is a binary palindrome\n", input);
    }
    
    return EXIT_SUCCESS;
}
