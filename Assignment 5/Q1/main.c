#include "utils.h"
#include "defs.h"

void lab_thread(void *arg) {
    lab *l = (lab *) arg;

    
}

void course_thread(void* arg){
    course* c = (course*)arg;
}

void student_thread(void* arg){
    student* s = (student*)arg;

    
}

int main() {
    int num_courses, num_stu, num_labs;

    scanf("%d %d %d", num_courses, num_stu, num_labs);
    
    course course_list[num_courses];
    student stu_list[num_stu];
    lab lab_list[num_labs];

    f(num_courses){
        char t1[NAME_LENGTH];
        int64_t t2, t3, t4;

        scanf("%s %d %d %d", t1, t2, t3, t4);

        course_list[i].interest_quotient = t2;
        course_list[i].max_slots = t3;
        strcpy(course_list[i].name, t1);

        course_list[i].num_labs = t4;
        course_list[i].lab_list = (int64_t *)malloc(sizeof(int64_t) * t4);

        for(int j = 0; j < t4; j++){
            scanf("%d", &course_list[i].lab_list[j]);
        }
    }

    f(num_stu){
        int64_t t1,t2,t3,t4,t5;

        scanf("%d %d %d %d %d",t1,t2,t3,t4,t5);

        stu_list[i].student_id = i;
        stu_list[i].calibre = t1;
        stu_list[i].pref1 = t2;
        stu_list[i].pref2 = t3;
        stu_list[i].pref3 = t4;

    }

    f(num_labs){
        char t1[NAME_LENGTH];
        int64_t t2,t3;

        scanf("%s %d %d",t1,t2,t3);

        strcpy(lab_list[i].lab_name, t1);
        lab_list[i].lab_id = i;
        lab_list[i].ta_num = t2;
        lab_list[i].max_turns = t3;

        lab_list[i].ta_list = (ta*)malloc(sizeof(ta) * lab_list[i].ta_num);

        for(int j=0;j<lab_list[i].ta_num;j++){
            lab_list[i].ta_list[j].ta_id = j;
            lab_list[i].ta_list[j].lock = (pthread_mutex_t)PTHREAD_MUTEX_INITIALIZER;
            lab_list[i].ta_list[j].turns_left = lab_list[i].max_turns;
            lab_list[i].ta_list[j].course_id = -1;
        }
    }

}