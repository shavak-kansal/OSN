#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/param.h"

int main(int argc, char *argv[]){

    int pid = atoi(argv[2]);
    int priority = atoi(argv[1]);

    set_priority(priority, pid);
    exit(0);
}