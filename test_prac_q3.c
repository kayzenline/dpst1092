// Call the `prac_q3()' function from the command-line.
// See the exam paper and `prac_q3.c' file for a description of the question.

// Do not change this file.

#include <stdio.h>

int prac_q3(int array[], int length);

// MIPS translation of the below can be found in test_prac_q3.s
// test_prac_q3.s should not be modified

// read 10 numbers into an array

int numbers[10] = {0};

int main(void)
{

    int i = 0;

    while (i < 10) {
        scanf("%d", &numbers[i]);
        i++;
    }

    int answer = prac_q3(numbers, 10);

    printf("%d\n", answer);

    return 0;

}

// MIPS translation of the above can be found in test_prac_q3.s
// test_prac_q3.s should not be modified
