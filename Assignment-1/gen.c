#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>

int main(){
    int dst_file = open("input.txt", O_WRONLY | O_CREAT, S_IRWXU|S_IRWXO|S_IRWXG);

    char msg[] = "word_splits_apart_with_thunder1word_splits_apart_with_thunder1word_splits_apart_with_thunder1word_splits_apart_with_thunder1word_splits_apart_with_thunder1word_splits_apart_with_thunder1word_splits_apart_with_thunder1word_splits_apart_with_thunder1word_splits_apart_with_thunder1word_splits_apart_with_thunder1word_splits_apart_with_thunder1word_splits_apart_with_thunder1word_splits_apart_with_thunder1word_splits_apart_with_thunder1word_splits_apart_with_thunder1word_splits_apart_with_thunder1word_splits_apart_with_thunder1word_splits_apart_with_thunder1word_splits_apart_with_thunder1word_splits_apart_with_thunder1word_splits_apart_with_thunder1word_splits_apart_with_thunder1word_splits_apart_with_thunder1word_splits_apart_with_thunder1word_splits_apart_with_thunder1word_splits_apart_with_thunder1word_splits_apart_with_thunder1word_splits_apart_with_thunder1word_splits_apart_with_thunder1word_splits_apart_with_thunder1word_splits_apart_with_thunder1word_splits_apart_with_thunder1word_splits_apart_with_thunder1";
    char ty[] = "word_splits_apart_with_thunder1";
    
    for(int i=0;i<1024*1024;i++){
        write(dst_file, msg, 1023);
    }
}