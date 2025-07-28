# include <stdio.h>
# include <stdlib.h>
# include <string.h>
int main(int argc, char * argv[]) {
	if(argc < 2) {
		return 0;
	}
    char *home = getenv("HOME");
	if(home == NULL || *home == '\0') {
		fprintf(stderr, "HOME not set\n");
		return 1;
	}

	char path[1000];
	if(sprintf(path, "%s/.diary", home)>=(int)sizeof path) {
		fprintf(stderr,"Path too long\n");
		return 1;
	}

	FILE *fp = fopen(path, "a");
	if (fp == NULL) {
		perror(path);
		return 1;
	}

	for (int i = 1; i < argc; i++) {
		fputs(argv[i], fp);
		if (i != argc - 1) {
			fputc(' ', fp);
		}
	}
    fputc('\n', fp);
	fclose(fp);
	return 0;
}