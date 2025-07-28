/*
    This file is intentionally provided (almost) empty.
    Remove this comment and add your code.
*/
#include <stdio.h>
#include <time.h>
#include <sys/stat.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    if(argc < 2) {
        return 0;
    }
    time_t now = time(NULL);
    for(int i = 0; i < argc; i++){
        struct stat st;
        stat(argv[i], &st);
        if(st.st_atime > now || st.st_mtime > now) {
            printf("%s has a timestamp that is in the future\n", argv[i]);
        }
    }
    return 0;
}