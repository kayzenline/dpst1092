/*
    This file is intentionally provided (almost) empty.
    Remove this comment and add your code.
*/
#include<stdio.h>
#include <stdlib.h>
int main(int argc, char * argv[]) {
    FILE *in = fopen(argv[1], "r");
    char tmp_template[] = "ascii_tmpXXXXXX";
    int tmp_fd = mkstemp(tmp_template);
    if (tmp_fd == -1) exit(EXIT_FAILURE);
    FILE *out = fdopen(tmp_fd, "w");
    int ch;
    while ((ch = fgetc(in)) != EOF) {
        if (ch >= 0 && ch < 128) {
            fputc(ch, out);
        }
    }

    fclose(in);
    fclose(out);
    if (rename(tmp_template, argv[1]) != 0) {
        remove(tmp_template);
        exit(EXIT_FAILURE);
    }
    return 0;
}