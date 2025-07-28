#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

#define N 4

void *helloThread(void *arg) {
    int id = *(int *)arg;          // 读取自己的副本
    printf("Hello from Thread %d\n", id);
    return NULL;
}

int main(void) {
    pthread_t tid[N];
    int ids[N];                    // 为每个线程准备一个独立的 int

    for (int i = 0; i < N; i++) {
        ids[i] = i;                // 先写好，再把地址传进去
        if (pthread_create(&tid[i], NULL, helloThread, &ids[i]) != 0) {
            perror("pthread_create");
            exit(EXIT_FAILURE);
        }
    }

    for (int i = 0; i < N; i++) {
        if (pthread_join(tid[i], NULL) != 0) {
            perror("pthread_join");
            exit(EXIT_FAILURE);
        }
    }
    return 0;
}
