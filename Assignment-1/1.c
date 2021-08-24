#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>

int main(){
    int src_file = open("input.txt", O_RDONLY);
    int dst_file = open("output.txt", O_WRONLY | O_CREAT, S_IRWXU|S_IRWXO|S_IRWXG);

    int length = lseek(src_file, 0, SEEK_END);

    
    //printf("%d", length);
    size_t size=1024;

    char og[size+1];
    char rvs[size+1];

    int to_read = size;

    if(length < size){
        lseek(src_file, -length, SEEK_END);
        to_read = length;
    }
    else 
        lseek(src_file, -size, SEEK_END);

    lseek(dst_file, 0, SEEK_SET);

    int char_read = 0;

    printf("");

    while(char_read<length)
    {
        printf("\rProgress: %.2f%%", (char_read*100.0)/length);
        int bytes_read = read(src_file, og, to_read);

        for(int i=0;i<bytes_read;i++){
            rvs[i] = og[bytes_read-i-1];
        }

        //printf("%s\n", rvs);
        write(dst_file, rvs, bytes_read);

        //printf("SEEK-CUR = %d\n", lseek(src_file, 0, SEEK_CUR));

        if(lseek(src_file, 0, SEEK_CUR)-bytes_read-size<0){
            to_read = lseek(src_file, 0, SEEK_CUR)-bytes_read;
            lseek(src_file, 0, SEEK_CUR);
        }
        else{
            lseek(src_file, -bytes_read - size, SEEK_CUR);
            to_read = size;
        }

        char_read += bytes_read;
    }
    
}