#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>

int main(int argc, char *argv[]){

    int last_index = -1;

    for(int i=0;i<strlen(argv[1]);i++){
        if(argv[1][i] == '/')
            last_index = i;
    }

    int src_file = open(argv[1], O_RDONLY);

    if(src_file == -1){
        write(1, "error opening input file", 25);
        return 0;
    }
    char* output_name = (char*)malloc(100*sizeof(char)); 
    sprintf(output_name, "2_%s", (argv[1]+last_index+1));
    int dst_file = open(output_name, O_WRONLY | O_CREAT, S_IRWXU|S_IRWXO|S_IRWXG);

    if(dst_file == -1){
        write(1, "error opening output file", 25);
        return 0;
    }
    
    int length = lseek(src_file, 0, SEEK_END);

    int a, b;
    a = argv[2][0] - '0';
    b = argv[3][0] - '0';
    
    length = length/a;

    size_t size=1024;

    char og[size+1];
    char rvs[size+1];

    int to_read = size;

    lseek(src_file,b*length ,SEEK_SET);

    if(length < size){
        lseek(src_file, -length, SEEK_CUR);
        to_read = length;
    }
    else 
        lseek(src_file, -size, SEEK_CUR);

    lseek(dst_file, 0, SEEK_SET);

    int char_read = 0;

    printf("");

    while(char_read<length)
    {
        char *progress_bar = (char*)malloc(sizeof(char)*100);

        sprintf(progress_bar , "\rProgress: %.2f%%", (char_read*100.0)/length);
        write(1, progress_bar, 100);
        fflush(stdout);
        //printf("\rProgress: %.2f%%", (char_read*100.0)/length);
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
    printf("\n");  

    close(src_file);
    close(dst_file);
}