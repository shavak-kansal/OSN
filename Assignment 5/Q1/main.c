#include <pthread.h>
#include <stdio.h>
#include <semaphore.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

typedef struct lab {
    pthread_mutex_t lock;
    int32_t count;
    int32_t* ta;
    int32_t limit;
};

void course_thread(){

}

int main() {

}