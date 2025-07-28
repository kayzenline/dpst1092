// Author: JIAWEN LIN
// Date: 14/05/2025
// z5647814

#include <stdio.h>

int main() {
	char c = getchar();
	while (c != EOF) {
		if (c >= 'A' && c <= 'Z') {
			c += 32;
		}
		putchar(c);
		c = getchar();
	}
	return 0;
}		