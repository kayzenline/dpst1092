// create_binary_file.c
//
// Build: gcc -Wall -Werror -o create_binary_file create_binary_file.c
//
// Usage:
//   ./create_binary_file <filename> <byte0> <byte1> ...
//
// Each <byteN> must be an integer 0-255 (decimal).
// The program writes them to <filename> exactly as bytes.

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

#define BYTE_MIN 0
#define BYTE_MAX 255

int main(int argc, char *argv[]) {

    if (argc < 3) {
        fprintf(stderr,
                "Usage: %s <filename> <byte0> [byte1] ...\n",
                argv[0]);
        return EXIT_FAILURE;
    }

    const char *filename = argv[1];

    FILE *fp = fopen(filename, "wb");
    if (fp == NULL) {
        perror(filename);
        return EXIT_FAILURE;
    }


    for (int i = 2; i < argc; i++) {
        int value = atoi(argv[i]);
        if (value < BYTE_MIN || value > BYTE_MAX) {
            fprintf(stderr,
                    "Error: byte value '%s' out of range 0-255\n",
                    argv[i]);
            fclose(fp);
            return EXIT_FAILURE;
        }

        if (fputc(value, fp) == EOF) {
            fprintf(stderr,
                    "Error writing to '%s': %s\n",
                    filename,
                    strerror(errno));
            fclose(fp);
            return EXIT_FAILURE;
        }
    }

    if (fclose(fp) == EOF) {
        perror("fclose");
        return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}
