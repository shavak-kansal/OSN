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
    float interest_quotient;
    int64_t max_slots;

    int64_t num_labs;
    int64_t *lab_list;

    sem_t tut_slots;
    sem_t tut_not_started_binary_semaphore;
    pthread_mutex_t semaphore_lock;

    pthread_cond_t tut_cond;
    pthread_mutex_t tut_cond_lock;
    
    pthread_cond_t in_tut;
    pthread_mutex_t in_tut_lock;
    
    pthread_mutex_t student_counter_lock;
    int64_t course_end;
    int64_t students_attending;
} course;

typedef struct student {
    int64_t student_id;
    int64_t pref1;
    int64_t pref2;
    int64_t pref3;
    float calibre;
    int64_t time;
} student;



