//#include "utils.h"
#include "defs.h"

course *course_list;
student *stu_list;
lab *lab_list;


void lab_thread(void *arg) {
    lab *l = (lab *) arg;

    
}

void course_thread(void* arg){
    course* c = (course*)arg;

    while(1){
        f(c->num_labs){
            f1(lab_list[i].ta_num){
                pthread_mutex_lock(&lab_list[i].ta_list[i1].lock);
                
                if(lab_list[i].ta_list[i1].turns_left > 0){
                    lab_list[i].ta_list[i1].turns_left--;
                    //pthread_mutex_unlock(&lab_list[i].ta_list[i1].lock);
                    goto found;
                }
                else 
                    pthread_mutex_unlock(&lab_list[i].ta_list[i1].lock);
            }
        }
        
        printf("%s ending\n", c->name);
        c->course_end = 1;
        //pthread_cond_broadcast(&c->tut_cond);
        break;

        found:
            int64_t random_slots = (rand()%c->max_slots) + 1;
            //sem_init(&c->tut_slots,0, random_slots);
            f(random_slots){
                sem_post(&c->tut_slots);
            }

            sleep(1);

            /* pthread_mutex_lock(&c->semaphore_lock);
                int num_students;
                sem_getvalue(&c->tut_slots, &num_students);

            pthread_mutex_unlock(&c->semaphore_lock); */

            /* pthread_mutex_lock(&c->tut_cond_lock);

            f(random_slots){
                pthread_cond_signal(&c->tut_cond);
            }

            pthread_mutex_unlock(&c->tut_cond_lock); */
    }
}

/* void student_thread1(void* arg){
    student* s = (student*)arg;

    sleep(s->time);

    printf("Student %d has filled in preferences for course registration", s->student_id);

    pthread_mutex_lock(&course_list[s->pref1].tut_cond_lock);
    pthread_cond_wait(&course_list[s->pref1].tut_cond, &course_list[s->pref1].tut_cond_lock);

    if(course_list[s->pref1].course_end == 1){
        pthread_mutex_unlock(&course_list[s->pref1].tut_cond_lock);
    }
    else {
        printf("%s ", s->);
        pthread_mutex_unlock(&course_list[s->pref1].tut_cond_lock);
    }

    pthread_mutex_lock(&course_list[s->pref2].tut_cond_lock);
    pthread_cond_wait(&course_list[s->pref2].tut_cond, &course_list[s->pref2].tut_cond_lock);

    if(course_list[s->pref2].course_end == 1){
        pthread_mutex_unlock(&course_list[s->pref2].tut_cond_lock);
    }
    else {
        pthread_mutex_unlock(&course_list[s->pref2].tut_cond_lock);
    }

    pthread_mutex_lock(&course_list[s->pref3].tut_cond_lock);
    pthread_cond_wait(&course_list[s->pref3].tut_cond, &course_list[s->pref3].tut_cond_lock);

    if(course_list[s->pref3].course_end == 1){
        pthread_mutex_unlock(&course_list[s->pref3].tut_cond_lock);
    }
    else {
        pthread_mutex_unlock(&course_list[s->pref3].tut_cond_lock);
    }

} */

void student_thread(void* arg){
    student* s = (student*)arg;

    sleep(s->time);

    printf("Student %d has filled in preferences for course registration", s->student_id);



}

int main() {
    int num_courses, num_stu, num_labs;

    scanf("%d %d %d", num_courses, num_stu, num_labs);
    
    // course course_list[num_courses];
    // student stu_list[num_stu];
    // lab lab_list[num_labs];

    course_list = malloc(num_courses * sizeof(course));
    stu_list = malloc(num_stu * sizeof(student));
    lab_list = malloc(num_labs * sizeof(lab));

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

        sem_init(&course_list[i].tut_slots, 0, 0);
        course_list[i].semaphore_lock = (pthread_mutex_t)PTHREAD_MUTEX_INITIALIZER;

        course_list[i].tut_cond = PTHREAD_COND_INITIALIZER;
        course_list[i].tut_cond_lock = PTHREAD_MUTEX_INITIALIZER;

        course_list[i].course_end = 0;
    }

    f(num_stu){
        int64_t t1,t2,t3,t4,t5;

        scanf("%d %d %d %d %d",t1,t2,t3,t4,t5);

        stu_list[i].student_id = i;
        stu_list[i].calibre = t1;
        stu_list[i].pref1 = t2;
        stu_list[i].pref2 = t3;
        stu_list[i].pref3 = t4;
        stu_list[i].time = t5;

        stu_list[i].student_id = i;

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