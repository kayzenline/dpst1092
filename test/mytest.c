#include <stdio.h>
#include <stdlib.h>

int main()
{
	char *a = getenv("my1");
	if (a != NULL) {
		printf("%s\n", a);
	}
	return 0;
}
