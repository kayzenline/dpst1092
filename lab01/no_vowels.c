// Author: JIAWEN LIN
// Date: 14/05/2025
// z5647814

#include <stdio.h>

int main() {
	char c;
	while (scanf("%c", &c) != EOF) {
		
		if (c != 'a' && c != 'e' && c != 'i' && c != 'o' && c != 'u' &&
		    c != 'A' && c != 'E' && c != 'I' && c != 'O' && c != 'U') {
			printf("%c", c);
		}
	}
	return 0;
}