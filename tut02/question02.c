#include<stdio.h>

unsigned char unset_nth_bit(unsigned char value, unsigned char n) {
	int mask = 1;
	mask <<= n;
	mask =~ mask;
	return value & mask;
}


int main() {
	int x = 52;
	int n = 4;
	int result = unset_nth_bit(x,n);
	printf("%08b  ---- changed value\n", result);
}
