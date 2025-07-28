// compile .c files specified as command line arguments
//
// if my_program.c and other_program.c is speicified as an argument then the follow two command will be executed:
// /usr/local/bin/dcc my_program.c -o my_program
// /usr/local/bin/dcc other_program.c -o other_program

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <spawn.h>
#include <sys/types.h>
#include <sys/wait.h>

#define DCC_PATH "/usr/local/bin/dcc"

extern char **environ;

char *basename_noext(char *path)
{
    char *p = strrchr(path, '/');
    char *base = p ? p + 1 : path;
    size_t len = strlen(base);

    if (len >= 2 && strcmp(base + len - 2, ".c") == 0)
        len -= 2;

    char *out = malloc(len + 1);
    if (out) {
        memcpy(out, base, len);
        out[len] = '\0';
    }
    return out;
}

int main(int argc, char **argv)
{
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <file1.c> [file2.c ...]\n", argv[0]);
        return EXIT_FAILURE;
    }

    for (int i = 1; i < argc; i++) {
        char *outfile = basename_noext(argv[i]);
        if (!outfile) {
            perror("malloc");
            return EXIT_FAILURE;
        }
        char *spawn_argv[] = { "dcc", argv[i], "-o", outfile, NULL };

        printf("running the command: \"%s %s -o %s\"\n",
               DCC_PATH, argv[i], outfile);

        pid_t pid;
        int rc = posix_spawn(&pid, DCC_PATH, NULL, NULL,
                             spawn_argv, environ);
        if (rc != 0) {
            fprintf(stderr, "posix_spawn: %s\n", strerror(rc));
            free(outfile);
            return EXIT_FAILURE;
        }

        int status;
        if (waitpid(pid, &status, 0) == -1) {
            perror("waitpid");
            free(outfile);
            return EXIT_FAILURE;
        }

        free(outfile);

        if (!WIFEXITED(status) || WEXITSTATUS(status) != 0)
            return WIFEXITED(status) ? WEXITSTATUS(status) : EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}
