#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <errno.h>
#include <string.h>
#include <inttypes.h>
#define MAGIC_LEN 3
static const unsigned char MAGIC[MAGIC_LEN] = {0x4C, 0x49, 0x54};

#define MIN_NUM_BYTES '1'
#define MAX_NUM_BYTES '8'

static void usage(const char *prog) {
    fprintf(stderr, "Usage: %s <filename>\n", prog);
}

int main(int argc, char *argv[]) {

    if (argc != 2) {
        usage(argv[0]);
        return 1;
    }

    const char *filename = argv[1];

    FILE *fp = fopen(filename, "rb");
    if (fp == NULL) {
        perror(filename);
        return 1;
    }

    unsigned char hdr[MAGIC_LEN];
    if (fread(hdr, 1, MAGIC_LEN, fp) != MAGIC_LEN ||
        memcmp(hdr, MAGIC, MAGIC_LEN) != 0) {
        fprintf(stderr, "Failed to read magic\n");
        fclose(fp);
        return 1;
    }

    while (1) {
        int len_char = fgetc(fp);

        if (len_char == EOF) {
            break;
        }

        if (len_char < MIN_NUM_BYTES || len_char > MAX_NUM_BYTES) {
            fprintf(stderr, "Invalid record length\n");
            fclose(fp);
            return 1;
        }

        int num_bytes = len_char - '0';           // '1'..'8' → 1..8
        unsigned char buf[8];

        size_t n_read = fread(buf, 1, num_bytes, fp);
        if (n_read != (size_t)num_bytes) {
            fprintf(stderr, "Failed to read record\n");
            fclose(fp);
            return 1;
        }

        uint64_t value = 0;
        for (int i = num_bytes - 1; i >= 0; i--) {
            value = (value << 8) | buf[i];
        }

        printf("%" PRIu64 "\n", value);
    }

    fclose(fp);
    return 0;
}