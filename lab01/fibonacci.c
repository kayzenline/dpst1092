// Author: JIAWEN LIN
// Date: 15/05/2025
// z5647814
// Add the preceding two Fibonacci numbers together to get the current Fibonacci number:

#include<stdio.h>

int Fibonacci(int inp) {
    if(inp == 0) {
        return 0;
    }
    if(inp == 1) {
        return 1;
    }
    return Fibonacci(inp - 1) + Fibonacci(inp -2);
}
int main() {
    int input = 0;
    while (scanf("%d", &input) != EOF){
        printf("%d\n", Fibonacci(input));
    }
    return 0;
}