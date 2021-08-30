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

    {
        struct stat perms_data;
        int err = stat("Assignment", &perms_data);

        if(err = -1)
            write(1, "Directory is created: Yes\n", 26);
        else{
            write(1, "Directory is created: No\n", 25);
            return 0;
        }
    }

    {
        char* output_name = (char*)malloc(100*sizeof(char)); 
        sprintf(output_name, "Assignment/1_%s", (argv[1]+last_index+1));

        printf("%s\n", output_name);

        struct stat perms_data;

        int err = stat(output_name, &perms_data);

        if(err == -1){
            write(1, "Error related to file", 22);
            return 0;
        }
        
        write(1, "User has read permission on output_file_1: ", 44);
        if(perms_data.st_mode & S_IRUSR)
            write(1, "Yes\n", 5);
        else 
            write(1, "No\n", 4);

        write(1, "User has write permission on output_file_1: ", 45);
        if(perms_data.st_mode & S_IWUSR)
            write(1, "Yes\n", 5);
        else 
            write(1, "No\n", 4);

        write(1, "User has execute permission on output_file_1: ", 47);
        if(perms_data.st_mode & S_IXUSR)
            write(1, "Yes\n", 5);
        else 
            write(1, "No\n", 4);

        
        write(1, "Group has read permission on output_file_1: ", 45);
        if(perms_data.st_mode & S_IRGRP)
            write(1, "Yes\n", 5);
        else 
            write(1, "No\n", 4);

        write(1, "Group has write permission on output_file_1: ", 46);
        if(perms_data.st_mode & S_IWGRP)
            write(1, "Yes\n", 5);
        else 
            write(1, "No\n", 4);

        write(1, "Group has execute permission on output_file_1: ", 48);
        if(perms_data.st_mode & S_IXGRP)
            write(1, "Yes\n", 5);
        else 
            write(1, "No\n", 4);


        write(1, "Others has read permission on output_file_1: ", 46);
        if(perms_data.st_mode & S_IROTH)
            write(1, "Yes\n", 5);
        else 
            write(1, "No\n", 4);

        write(1, "Others has write permission on output_file_1: ", 47);
        if(perms_data.st_mode & S_IWOTH)
            write(1, "Yes\n", 5);
        else 
            write(1, "No\n", 4);

        write(1, "Others has execute permission on output_file_1: ", 49);
        if(perms_data.st_mode & S_IXOTH)
            write(1, "Yes\n", 5);
        else 
            write(1, "No\n", 4);

        free(output_name);
    }


    {
        char* output_name = (char*)malloc(100*sizeof(char)); 
        sprintf(output_name, "Assignment/2_%s", (argv[1]+last_index+1));

        printf("%s\n", output_name);
        struct stat perms_data;

        int err = stat(output_name, &perms_data);

        if(err == -1){
            write(1, "Error related to file", 22);
            return 0;
        }
        
        write(1, "User has read permission on output_file_2: ", 44);
        if(perms_data.st_mode & S_IRUSR)
            write(1, "Yes\n", 5);
        else 
            write(1, "No\n", 4);

        write(1, "User has write permission on output_file_2: ", 45);
        if(perms_data.st_mode & S_IWUSR)
            write(1, "Yes\n", 5);
        else 
            write(1, "No\n", 4);

        write(1, "User has execute permission on output_file_2: ", 47);
        if(perms_data.st_mode & S_IXUSR)
            write(1, "Yes\n", 5);
        else 
            write(1, "No\n", 4);

        
        write(1, "Group has read permission on output_file_2: ", 45);
        if(perms_data.st_mode & S_IRGRP)
            write(1, "Yes\n", 5);
        else 
            write(1, "No\n", 4);

        write(1, "Group has write permission on output_file_2: ", 46);
        if(perms_data.st_mode & S_IWGRP)
            write(1, "Yes\n", 5);
        else 
            write(1, "No\n", 4);

        write(1, "Group has execute permission on output_file_2: ", 48);
        if(perms_data.st_mode & S_IXGRP)
            write(1, "Yes\n", 5);
        else 
            write(1, "No\n", 4);


        write(1, "Others has read permission on output_file_2: ", 46);
        if(perms_data.st_mode & S_IROTH)
            write(1, "Yes\n", 5);
        else 
            write(1, "No\n", 4);

        write(1, "Others has write permission on output_file_2: ", 47);
        if(perms_data.st_mode & S_IWOTH)
            write(1, "Yes\n", 5);
        else 
            write(1, "No\n", 4);

        write(1, "Others has execute permission on output_file_2: ", 49);
        if(perms_data.st_mode & S_IXOTH)
            write(1, "Yes\n", 5);
        else 
            write(1, "No\n", 4);

        free(output_name);
    }

    {
        struct stat perms_data;

        int err = stat("Assignment", &perms_data);

        if(err == -1){
            write(1, "Error related to opening folder", 22);
            return 0;
        }
        
        write(1, "User has read permission on directory: ", 40);
        if(perms_data.st_mode & S_IRUSR)
            write(1, "Yes\n", 5);
        else 
            write(1, "No\n", 4);

        write(1, "User has write permission on directory: ", 41);
        if(perms_data.st_mode & S_IWUSR)
            write(1, "Yes\n", 5);
        else 
            write(1, "No\n", 4);

        write(1, "User has execute permission on directory: ", 43);
        if(perms_data.st_mode & S_IXUSR)
            write(1, "Yes\n", 5);
        else 
            write(1, "No\n", 4);

        
        write(1, "Group has read permission on directory: ", 41);
        if(perms_data.st_mode & S_IRGRP)
            write(1, "Yes\n", 5);
        else 
            write(1, "No\n", 4);

        write(1, "Group has write permission on directory: ", 42);
        if(perms_data.st_mode & S_IWGRP)
            write(1, "Yes\n", 5);
        else 
            write(1, "No\n", 4);

        write(1, "Group has execute permission on directory: ", 44);
        if(perms_data.st_mode & S_IXGRP)
            write(1, "Yes\n", 5);
        else 
            write(1, "No\n", 4);


        write(1, "Others has read permission on directory: ", 42);
        if(perms_data.st_mode & S_IROTH)
            write(1, "Yes\n", 5);
        else 
            write(1, "No\n", 4);

        write(1, "Others has write permission on directory: ", 43);
        if(perms_data.st_mode & S_IWOTH)
            write(1, "Yes\n", 5);
        else 
            write(1, "No\n", 4);

        write(1, "Others has execute permission on directory: ", 45);
        if(perms_data.st_mode & S_IXOTH)
            write(1, "Yes\n", 5);
        else 
            write(1, "No\n", 4);

    }
}