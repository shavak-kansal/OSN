#include "utils.h"

typedef struct ta {
    pthread_mutex_t lock;
    int64_t ta_id;
    int64_t course_id;
    int64_t turns_left;
} ta;

typedef struct lab {
    int64_t lab_id;
    char lab_name[NAME_LENGTH];
    int64_t ta_num;
    int64_t max_turns;
    ta *ta_list;
} lab;

typedef struct course {
    char name[NAME_LENGTH];
    int64_t interest_quotient;
    int64_t max_slots;

    int64_t num_labs;
    int64_t *lab_list;

    sem_t tut_slots;

    //pthread_cond_t tut_cond;
    pthread_mutex_t semaphore_lock;

    pthread_cond_t tut_cond;
    pthread_mutex_t tut_cond_lock;

    int course_end;
} course;

typedef struct student {
    int64_t student_id;
    int64_t pref1;
    int64_t pref2;
    int64_t pref3;
    int64_t calibre;
    int64_t time;
} student;



