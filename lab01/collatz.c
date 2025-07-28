// Author: JIAWEN LIN
// Date: 14/05/2025
// z5647814
// Take a single positive integer 
// as a command-line argument and prints 
// the collatz chain for that number.

#include <stdio.h>
#include <stdlib.h>
int recursive(int input) {
    printf("%d\n", input); 
    if(input == 0) {
        return 0;
    }   
    if(input == 1) {
        return 1;
    }  
    if(input % 2 == 0) {
        return recursive(input / 2);
    } else if(input % 2 == 1) {
        return recursive(3 * input + 1);
    }
    return 1;
}
int main(int argc, char *argv[]) {
	if (argc <= 1) {
		fprintf(stderr, "Usage: %s NUMBER\n",
			 argv[0]);
		return 1;

    }
    recursive(atoi(argv[1]));
    return 0;
}


