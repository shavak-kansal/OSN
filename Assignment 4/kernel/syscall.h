// System call numbers
#define SYS_fork    1 // fork - 0
#define SYS_exit    2 // exit - 1
#define SYS_wait    3 // wait - 1
#define SYS_pipe    4 // pipe - 1
#define SYS_read    5 // read - 3
#define SYS_kill    6 // kill - 1
#define SYS_exec    7 // exec - 2
#define SYS_fstat   8 // fstat - 2
#define SYS_chdir   9 // chdir - 1
#define SYS_dup    10 // dup - 1
#define SYS_getpid 11 // getpid - 0
#define SYS_sbrk   12 // sbrk - 1
#define SYS_sleep  13 // sleep - 1
#define SYS_uptime 14 // uptime - 0
#define SYS_open   15 // open - 2
#define SYS_write  16 // write - 3
#define SYS_mknod  17 // mknod - 3
#define SYS_unlink 18 // unlink - 1 
#define SYS_link   19 // link - 2 
#define SYS_mkdir  20 // mkdir - 1 
#define SYS_close  21 // close - 1
#define SYS_trace 22 // trace - 1
#define SYS_set_priority 23 // set_priority - 2
#define SYS_waitx  24