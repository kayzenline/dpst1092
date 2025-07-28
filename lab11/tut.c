//Write a C program that creates a thread that infinitely prints some message 
//provided by main (eg. "Hello\n"), while the main (default) thread infinitely prints a different message
#include<stdio.h>
#include <pthread.h>
void *thread_run(void * x) {
	while(1) {
		printf("hello");
	}
}
int main() {
	pthread_t thread;
    pthread_create(
        &thread,    // the pthread_t handle that will represent this thread
        NULL,       // thread-attributes -- we usually just leave this NULL
        thread_run, // the function that the thread should start executing
        NULL        // data we want to pass to the thread -- this will be
                    // given in the `void *data` argument above
    );
}