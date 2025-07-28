// z5647814 12/07/2025
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <stdio.h>
#include <stdlib.h>

void stat_file(char *pathname);

int main(int argc, char *argv[]) {
    for (int arg = 1; arg < argc; arg++) {
        stat_file(argv[arg]);
    }
    return 0;
}

void stat_file(char *pathname) {
    struct stat s;
    if (stat(pathname, &s) != 0) {
        perror(pathname);
        exit(1);
    }

    char perms[11] = "----------";
    
    if (S_ISDIR(s.st_mode))  perms[0] = 'd';
    if (S_ISLNK(s.st_mode))  perms[0] = 'l';
    if (S_ISCHR(s.st_mode))  perms[0] = 'c';
    if (S_ISBLK(s.st_mode))  perms[0] = 'b';
    if (S_ISFIFO(s.st_mode)) perms[0] = 'p';
    if (S_ISSOCK(s.st_mode)) perms[0] = 's';
    
    if (s.st_mode & S_IRUSR) perms[1] = 'r';
    if (s.st_mode & S_IWUSR) perms[2] = 'w';
    if (s.st_mode & S_IXUSR) perms[3] = 'x';
    if (s.st_mode & S_IRGRP) perms[4] = 'r';
    if (s.st_mode & S_IWGRP) perms[5] = 'w';
    if (s.st_mode & S_IXGRP) perms[6] = 'x';
    if (s.st_mode & S_IROTH) perms[7] = 'r';
    if (s.st_mode & S_IWOTH) perms[8] = 'w';
    if (s.st_mode & S_IXOTH) perms[9] = 'x';
    
    printf("%s %s\n", perms, pathname);
}