#include <pthread.h>
#include <stdio.h>
#include <semaphore.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <iostream>
#include <queue>
#include <string>
#include <tuple>

#include <sys/types.h>
#include <unistd.h>
#include <sys/syscall.h>

#define NAME_LENGTH 128
#define PORT_ARG 8001
typedef long long LL;

const LL buff_sz = 1048576;

#define f(x) for(int i=0;i<x;i++)
#define f1(x) for(int i1=0;i1<x;i1++)
#define f2(x) for(int i2=0;i2<x;i2++)
#define debug(x) cout << #x << " : " << x << endl