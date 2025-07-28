#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

#define BORT_MIN 0
#define BORT_MAX 65535

int main(int argc, char *argv[]) {
    if (argc != 4) {
        fprintf(stderr,
            "Usage: %s <filename> <start> <end>\n", argv[0]);
        return EXIT_FAILURE;
    }

    const char *filename = argv[1];
    unsigned start  = (unsigned)atoi(argv[2]);
    unsigned end    = (unsigned)atoi(argv[3]);

    if (start < BORT_MIN || start > BORT_MAX ||
        end   < BORT_MIN || end   > BORT_MAX ||
        start > end) {
        fprintf(stderr,
            "Error: start/end must be %u–%u and start ≤ end\n",
            BORT_MIN, BORT_MAX);
        return EXIT_FAILURE;
    }

    FILE *fp = fopen(filename, "wb");
    if (fp == NULL) {
        perror(filename);
        return EXIT_FAILURE;
    }

    for (unsigned b = start; b <= end; b++) {
        unsigned char msb = (b >> 8) & 0xFF;
        unsigned char lsb =  b & 0xFF;

        if (fputc(msb, fp) == EOF || fputc(lsb, fp) == EOF) {
            fprintf(stderr,
                "Error writing to '%s': %s\n",
                filename, strerror(errno));
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