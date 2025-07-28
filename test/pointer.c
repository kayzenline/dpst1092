# include<stdio.h>
int sum (int *num_1, int *num_2);

int main(){
    int * numb_1;
    int * numb_2;
    *numb_1 = 1;
    *numb_2 = 2;
    int ans = sum(numb_1, numb_2);
    printf("%d\n", ans);
    return 0;
}

int sum (int *num_1, int *num_2){
    //to do
    return *num_1 + *num_2;
}
