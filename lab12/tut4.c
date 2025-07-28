#include<stdio.h>


int main() {
    int x = 0x80;
    printf("%032b\n", x);
    int count = 0;
    int i = 0;
    while(((x >> i) & 1) != 1) {
        count++;
        i ++;
    }
    printf("%d\n", count);
    return 0;
}
