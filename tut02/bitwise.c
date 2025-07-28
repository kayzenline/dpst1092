
#include<stdio.h>
unsigned char set_nth_bit(unsigned char value, unsigned char n) {
	int mask = 1;
	int result = 0;
	mask <<= n;
	return value | mask;
}

int main() {
	int x = 52;
	int n = 4;
	int result = set_nth_bit(x,n);
	printf("%08b  ---- changed value\n", result);
}
