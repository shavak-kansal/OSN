#include "utils.h"

typedef struct person{
    char name[NAME_LENGTH];
    char type;
    int time_reached;
    int patience_time;
    int goal_limit;

} person;

typedef struct group {
    int id;
    int size;
    person *members;
} group;

typedef struct locks_stuff
{   
    // sem_t home_capacity;
    // sem_t away_capacity;
    // sem_t neutral_capacity;

    sem_t capacity[3]; // 0 - home_capacity, 1- away_capacity, 2 - neutral_capacity

    pthread_cond_t fans_type[3]; // 0 - home, 1 - away, 2 - neutral
    pthread_mutex_t fans_type_mutex[3]; // 0 - home, 1 - away, 2 - neutral

    pthread_cond_t goal_cond;
    pthread_mutex_t goal_cond_mutex;

    // pthread_cond_t away_fans;
    // pthread_cond_t home_fans;
    // pthread_cond_t neutral_fans;
    // pthread_mutex_t away_fans_mutex;
    // pthread_mutex_t home_fans_mutex;
    // pthread_mutex_t neutral_fans_mutex;

    int goals_count[3]; // 0 - home, 1 - neutral, 2 - away
    pthread_mutex_t goals_count_mutex;

}locks_stuff;

struct goal_prob {
    char team_id;
    int time;
    float prob;
};