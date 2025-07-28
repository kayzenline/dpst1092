#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <inttypes.h>
#include <errno.h>
#include <string.h>

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <file> [file...]\n", argv[0]);
        return EXIT_FAILURE;
    }

    uintmax_t total = 0;

    for (int i = 1; i < argc; i++) {
        struct stat st;
        if (stat(argv[i], &st) == -1) {
            fprintf(stderr, "%s: %s\n", argv[i], strerror(errno));
            continue;
        }

        uintmax_t size = (uintmax_t)st.st_size;
        printf("%s: %" PRIuMAX " bytes\n", argv[i], size);
        total += size;
    }

    printf("Total: %" PRIuMAX " bytes\n", total);
    return EXIT_SUCCESS;
}
