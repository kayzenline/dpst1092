#include <stdio.h>
#include <stdlib.h>

int main(int argc, char * argv[]) {
    if(argc < 3){
        fprintf(stderr, "Usage: %s num1 num2\n",argv[0]);
        return 1;
    }
    int result = atoi(argv[1])  + atoi(argv[2]);
    printf("Result: %d\n",result);
    return 0;
}