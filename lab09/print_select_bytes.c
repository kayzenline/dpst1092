//
#include<stdio.h>
#include <ctype.h>
#include <stdlib.h>
int main(int argc, char *argv[]) {
	if(argc < 3) {
        fprintf(stderr, "Usage: %s <filename> <byte_pos1> [byte_pos2] ...\n", argv[0]);
        return 1;
	}
	char *filename = argv[1];
	FILE *fp = fopen(filename, "rb");
	if (fp == NULL) {
		perror(filename);
		return 1;
	}
	for (int i = 2; i < argc; i ++) {
		char *endptr;
        long pos = strtol(argv[i], &endptr, 10);
        if (*endptr != '\0' || pos < 0) {
            fprintf(stderr, "Invalid byte position: %s\n", argv[i]);
            continue;
        }

        if (fseek(fp, pos, SEEK_SET) != 0) {
            fprintf(stderr, "Cannot seek to position %ld\n", pos);
            continue;
        }

        int byte = fgetc(fp);
        if (byte == EOF) {
            fprintf(stderr, "No byte at position %ld\n", pos);
            continue;
        }

        if (isprint(byte)) {
            printf("%d - 0x%02X - '%c'\n", byte, byte, byte);
        } else {
            printf("%d - 0x%02X\n", byte, byte);
        }
    }

    fclose(fp);

	return 0;
}