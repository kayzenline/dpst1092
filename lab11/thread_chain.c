#include <pthread.h>
#include <stdint.h>
#include "thread_chain.h"

void *my_thread(void *data) {
    int remaining = (int)(intptr_t)data;
    thread_hello();
    if (remaining > 1) {
        pthread_t next_tid;
        int next_remaining = remaining - 1;
        pthread_create(&next_tid, NULL, my_thread, (void *)(intptr_t)next_remaining);
        pthread_join(next_tid, NULL);
    }
    return NULL;
}

void my_main(void) {
    int chain_len = 50;
    pthread_t thread_handle;
    pthread_create(&thread_handle, NULL, my_thread, (void *)(intptr_t)chain_len);
    pthread_join(thread_handle, NULL);
}