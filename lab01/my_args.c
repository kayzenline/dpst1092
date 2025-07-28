// Author: JIAWEN LIN
// Date: 14/05/2025
// z5647814
// Pretty Print Command Line Arguments

#include <stdio.h>

int main(int argc, char *argv[]) {
	printf("Program name: %s\n", argv[0]);
	if (argc > 1) {
		printf("There are %d arguments:\n", argc - 1);
		for (int i = 1; i < argc; i++) {
			// Print the argument number and its value
			printf("\tArgument %d is \"%s\"\n", i, argv[i]);
		}
	}
	else {
		printf("There are no other arguments\n");
	}
	return 0;	
}