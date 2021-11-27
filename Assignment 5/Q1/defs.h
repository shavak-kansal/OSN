#include "utils.h"

typedef struct ta {
    pthread_mutex_t lock; //  lock associated with individual ta so as to make it thread safe
    int64_t ta_id; //  id of ta 
    int64_t course_id; //  id of ta they whose tutorial they are taking right now 
    int64_t turns_left; // turns left for the ta
} ta;

typedef struct lab {
    int64_t lab_id; //  id of lab 
    char lab_name[NAME_LENGTH]; // name of lab
    int64_t ta_num; // number of tas
    int64_t max_turns; // max number of turns of every ta
    ta *ta_list; // list of tas in this lab
} lab;

typedef struct course {
    char name[NAME_LENGTH]; // course name
    float interest_quotient; // Interest associated with the course
    int64_t max_slots; // Max slots that can be allotted in a course tutorial

    int64_t num_labs; //  Number of labs the ta's can be chosen from 
    int64_t *lab_list; //  list of the labs from which ta's can be selected 

    sem_t tut_slots; 
    sem_t tut_not_started_binary_semaphore;
    pthread_mutex_t semaphore_lock;

    pthread_cond_t tut_cond; // conditional variable for selecting students for the course tutorial
    pthread_mutex_t tut_cond_lock; //  lock associated with tut_cond 
    
    pthread_cond_t in_tut; //  conditional variable for signaling the end of the tut, student threads wait on it to indicate being in tut
    pthread_mutex_t in_tut_lock; //  lock associated with in_tut
    
    pthread_mutex_t student_counter_lock; //  lock associated with students_attending variable for it be thread safe
    int64_t course_end; // variable which indicates whether course has ended  1 - indicates end of course 0 - indicates course isnt ended yet
    int64_t students_attending; // Keeps count of how many students are in the current tut
} course;

typedef struct student {
    int64_t student_id; // id of student
    int64_t pref1; //  course id of first course preference
    int64_t pref2; // course id of second course preference
    int64_t pref3; //  course id of third course preference
    float calibre; // caliber of student
    int64_t time; //  time when student registers
} student;



