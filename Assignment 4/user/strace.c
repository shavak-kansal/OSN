#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/param.h"

int main(int argc, char *argv[]){

    int n = atoi(argv[1]);
    
    char *exec_args[MAXARG];

    trace(n);

    for(int i=2;i<argc;i++)
        exec_args[i-2] = argv[i];

    exec(exec_args[0], exec_args);
    exit(0);
}