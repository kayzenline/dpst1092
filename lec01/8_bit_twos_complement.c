#include <stdio.h>

int main() {
	for(int i =-128;i <128;i++) { 
		printf("%4d",i); 
		print_bits(i,8); 
		printf("\n"); 
	}
return 0;
}