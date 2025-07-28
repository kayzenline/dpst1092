// Author: JIAWEN LIN
// Date: 14/05/2025
// z5647814
// Remove Uneven Lines of Input

#include <stdio.h>
#include <string.h>

int main() {
	char line[1000];
	int count = 0;
	while (fgets(line, sizeof(line), stdin) != NULL) {
		count = strlen(line);
		if (count % 2 == 0) {
			printf("%s", line);
		}
	}
	return 0;
}