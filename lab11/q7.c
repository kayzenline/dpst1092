#include<stdio.h>
#include<stdbool.h>
#include<unis.h>
#include<pthread.h>
void *thread_run(void *data) {
	while(1) {
		printf("feed me !!!\n");
		sleep(1);
	}
}
int main(void) {
    pthread_t tid;
    if (pthread_create(&tid, NULL, prompt_thread, NULL) != 0) {
        perror("pthread_create");
        exit(EXIT_FAILURE);
    }

    char buf[1024];
    while (fgets(buf, sizeof buf, stdin) != NULL) {
        printf("you entered: %s", buf);
        fflush(stdout);
    }
	return 0;
}