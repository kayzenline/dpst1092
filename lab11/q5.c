// greeting_threads.c
// 编译：gcc -Wall -Wextra -pthread greeting_threads.c -o greetings

#include <pthread.h>
#include <stdio.h>
#include <unistd.h>     // sleep

// 子线程要打印的消息通过 void* 传进来
void *print_msg_forever(void *arg) {
    const char *msg = arg;   // 主线程传进来的字符串常量
    while (1) {
        printf("%s", msg);   // msg 已含 '\n'，不再额外加
        fflush(stdout);      // 立刻刷到终端，减少行缓冲干扰
        sleep(1);
    }
    return NULL;             // 永不返回，写给编译器看
}

int main(void) {
    pthread_t tid;

    // 想让子线程打印什么，就在这里改字符串
    const char *child_msg = "Hello\n";

    // 创建子线程，传入消息字符串
    if (pthread_create(&tid, NULL, print_msg_forever, (void *)child_msg) != 0) {
        perror("pthread_create");
        return 1;
    }

    // 主线程自己打印另一条消息
    while (1) {
        printf("there!\n");
        fflush(stdout);
        sleep(1);
    }

    // 代码到不了这里，写 return 0 只是形式
    return 0;
}