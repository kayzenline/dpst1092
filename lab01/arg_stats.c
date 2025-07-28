// Author: JIAWEN LIN
// Date: 14/05/2025
// z5647814
// Statistical Analysis of Command Line Arguments

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
	if (argc < 2) {
		fprintf(stderr, "Usage: %s NUMBER [NUMBER ...]\n",
			 argv[0]);
		return 1;
		}
	int i;
	int num = 0;
	int sum = 0;
	int min = atoi(argv[1]);
	int max = atoi(argv[1]);
	int product = 1;
	int mean = 0;
	for (int i = 1; i < argc; i++) {
		num = atoi(argv[i]);
		sum += num;
		product *= num;
		mean = sum / (argc - 1);
		if (num < min) {
			min = num;
		}
		if (num > max) {
			max = num;
		}
	}
	printf ("MIN:  %d\n", min);
	printf ("MAX:  %d\n", max);
	printf ("SUM:  %d\n", sum);
	printf ("PROD: %d\n", product);
	printf ("MEAN: %d\n", mean);
}