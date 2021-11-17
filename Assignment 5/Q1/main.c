//#include "utils.h"
#include "defs.h"

course *course_list;
student *stu_list;
lab *lab_list;


void *lab_thread(void *arg) {
    lab *l = (lab *) arg;

    
}

void *course_thread(void* arg){
    course* c = (course*)arg;

    while(1){

        int lab_index;
        int ta_index;

        f(c->num_labs){
            f1(lab_list[i].ta_num){
                pthread_mutex_lock(&lab_list[i].ta_list[i1].lock);
                
                if(lab_list[i].ta_list[i1].turns_left > 0){
                    lab_list[i].ta_list[i1].turns_left--;
                    //pthread_mutex_unlock(&lab_list[i].ta_list[i1].lock);

                    lab_index = i;
                    ta_index = i1;
                    goto found;
                }
                else 
                    pthread_mutex_unlock(&lab_list[i].ta_list[i1].lock);
            }
        }
        
        printf("Course %s doesn’t have any TA’s eligible and is removed from course offerings\n", c->name);
        c->course_end = 1;
        pthread_cond_broadcast(&c->tut_cond);
        break;

        found:
            ;
            int64_t random_slots = (rand()%c->max_slots) + 1;
            
            printf("Course %s has been allocated %ld seats\n", c->name ,random_slots);
            /* sem_init(&c->tut_slots,0, random_slots);
            f(random_slots){
                sem_post(&c->tut_slots);
            }

            pthread_mutex_lock(&c->semaphore_lock);
                int num_students;
                sem_getvalue(&c->tut_slots, &num_students);

            pthread_mutex_unlock(&c->semaphore_lock);
 */
            
            pthread_mutex_lock(&c->tut_cond_lock);
            
            f(random_slots){
                pthread_cond_signal(&c->tut_cond);
            }

            pthread_mutex_unlock(&c->tut_cond_lock);

            sleep(1);

            sem_wait(&c->tut_not_started_binary_semaphore);

            sleep(2);

            printf("Tutorial has started for Course %s  with %ld seats filled out of %ld\n", c->name, c->students_attending, random_slots);
            
            sleep(2);

            printf("TA %ld from lab %s has completed the tutorial and left the course %s\n", ta_index, lab_list[lab_index].lab_name, c->name);

    }
}

/* void student_thread1(void* arg){
    student* s = (student*)arg;

    sleep(s->time);

    printf("Student %ld has filled in preferences for course registration", s->student_id);

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

void *student_thread(void* arg){
    student* s = (student*)arg;

    sleep(s->time);

    printf("Student %ld has filled in preferences for course registration", s->student_id);

    /* pthread_mutex_lock(&course_list[s->pref1].tut_cond_lock);
    pthread_cond_wait(&course_list[s->pref1].tut_cond, &course_list[s->pref1].tut_cond_lock);
    pthread_mutex_unlock(&course_list[s->pref1].tut_cond_lock);
    
    pthread_mutex_lock(&course_list[s->pref1].student_counter_lock);
        course_list[s->pref1].students_attending++;
        printf("Student %ld has been allocated a seat for course %s", s->student_id, course_list[s->pref1].name);
    pthread_mutex_unlock(&course_list[s->pref1].student_counter_lock); */

    int pref[3];
    pref[0] = s->pref1;
    pref[1] = s->pref2;
    pref[2] = s->pref3;

    f(3){
        pthread_mutex_lock(&course_list[pref[i]].tut_cond_lock);
        pthread_cond_wait(&course_list[pref[i]].tut_cond, &course_list[pref[i]].tut_cond_lock);
        pthread_mutex_unlock(&course_list[pref[i]].tut_cond_lock);
    
        pthread_mutex_lock(&course_list[pref[i]].student_counter_lock);
            course_list[pref[i]].students_attending++;
            printf("Student %ld has been allocated a seat for course %s", s->student_id, course_list[pref[i]].name);
        pthread_mutex_unlock(&course_list[pref[i]].student_counter_lock);

        int prob = course_list[pref[i]].interest_quotient*s->calibre*100;
        int random_num = rand()%100;

        if(random_num < prob){
            printf("Student %ld has selected course %s permanently", s->student_id, course_list[pref[i]].name);
            break;
        }
        else {
            printf("Student %ld has withdrawn from course %s", s->student_id, course_list[pref[i]].name);
        }
    }

    printf("Student %ld couldn’t get any of his preferred courses", s->student_id);
}   

int main() {
    int num_courses, num_stu, num_labs;

    scanf("%d %d %d", &num_stu , &num_labs ,  &num_courses);
    
    // course course_list[num_courses];
    // student stu_list[num_stu];
    // lab lab_list[num_labs];

    course_list = malloc(num_courses * sizeof(course));
    stu_list = malloc(num_stu * sizeof(student));
    lab_list = malloc(num_labs * sizeof(lab));

    f(num_courses){
        char t1[NAME_LENGTH];
        float t2;
        int64_t t3, t4;

        scanf("%s %f %ld %ld", t1, &t2, &t3, &t4);

        course_list[i].interest_quotient = t2;
        course_list[i].max_slots = t3;
        strcpy(course_list[i].name, t1);

        course_list[i].num_labs = t4;
        course_list[i].lab_list = (int64_t *)malloc(sizeof(int64_t) * t4);

        for(int j = 0; j < t4; j++){
            scanf("%ld", &(course_list[i].lab_list[j]));
        }

        sem_init(&course_list[i].tut_slots, 0, 0);
        sem_init(&course_list[i].tut_not_started_binary_semaphore, 0, 1);
        course_list[i].semaphore_lock = (pthread_mutex_t)PTHREAD_MUTEX_INITIALIZER;
        

        course_list[i].tut_cond = (pthread_cond_t)PTHREAD_COND_INITIALIZER;
        course_list[i].tut_cond_lock = (pthread_mutex_t)PTHREAD_MUTEX_INITIALIZER;

        course_list[i].student_counter_lock = (pthread_mutex_t)PTHREAD_MUTEX_INITIALIZER;
        course_list[i].course_end = 0;
    }

    f(num_stu){
        int64_t t1,t2,t3,t4,t5;

        scanf("%ld %ld %ld %ld %ld",&t1,&t2,&t3,&t4,&t5);

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

        scanf("%s %ld %ld",t1,&t2,&t3);

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

    pthread_t *course_threads = malloc(sizeof(pthread_t) * num_courses);
    pthread_t *student_threads = malloc(sizeof(pthread_t) * num_stu);

    f(num_courses){
        pthread_create(&course_threads[i], NULL, course_thread, &course_list[i]);
    }

    f(num_stu){
        pthread_create(&student_threads[i], NULL, student_thread, &stu_list[i]);
    }

    f(num_courses){
        pthread_join(course_threads[i], NULL);
    }

    f(num_stu){
        pthread_join(student_threads[i], NULL);
    }

    printf("Exiting simulation\n");
}