#include<stdio.h>

int main(int argc, char argv[]) {
	FILE * f = fopen(argv[1], "a");
	if (f == NULL) {
		perror("");
	}
	char input[1000];
	fgets(input, sizeof(input), stdin);
	fputs(input, f);
}