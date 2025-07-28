//                     ***  DO NOT CHANGE THIS FILE! ***                     //
// DPST1092 25T2 ... prac exam, question 4
// You are not required to understand the code in this file.
// You should modify prac_q4.c instead.

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifdef main
#undef main
#endif

char *prac_q4(char *string);

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <string>\n", argv[0]);
        return EXIT_FAILURE;
    }

    char *str = strdup(argv[1]);
    char * result = prac_q4(str);
    printf("%s\n", result);
    free(str);
    free(result);
    return EXIT_SUCCESS;
}
