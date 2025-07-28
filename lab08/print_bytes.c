#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
        return EXIT_FAILURE;
    }

    const char *filename = argv[1];
    FILE *fp = fopen(filename, "rb");
    if (fp == NULL) {
        perror(filename);
        return EXIT_FAILURE;
    }

    int ch;
    long index = 0;                           
    while ((ch = fgetc(fp)) != EOF) {
        printf("byte %4ld: %3d 0x%02x", index, ch, ch & 0xFF);
        if (isprint(ch)) {
            printf(" '%c'", ch);
        }
        putchar('\n');
        index++;
    }

    fclose(fp);
    return EXIT_SUCCESS;
}
