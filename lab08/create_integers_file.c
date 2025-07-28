#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    if (argc != 4) {
        fprintf(stderr, "Usage: %s <filename> <start> <end>\n", argv[0]);
        return 1;
    }

    int start = atoi(argv[2]);
    int end   = atoi(argv[3]);

    FILE *fp = fopen(argv[1], "w");
    if (fp == NULL) {
        perror("fopen");
        return 1;
    }

    for (int i = start; i <= end; i++) {
        fprintf(fp, "%d\n", i);
    }

    // 关闭文件
    fclose(fp);
    return 0;
}
