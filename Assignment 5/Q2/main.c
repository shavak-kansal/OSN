#include "utils.h"
#include "defs.h"
#include "useless.h"

locks_stuff sync_stuff;
group *groups;
int home_capacity, away_capacity, neutral_capacity, spectating_time, num_groups;
int seating_capacity[3];

int done = 0;

int team_char_to_int(char c) {
    if (c == 'H') return 0;
    if (c == 'A') return 2;
    if (c == 'N') return 1;
    return -1;
}

int team_int_to_char(int i) {
    if (i == 0) return 'H';
    if (i == 2) return 'A';
    if (i == 1) return 'N';
    return -1;
}

void *spectator_thread(void *arg) {
    person *p = (person *)arg;

    sleep(p->time_reached);

    printf(BBLU "Person %s has reached the stadium\n", p->name);
    int type_id;
    char* person_id;

    person_id = p->name;

    type_id = team_char_to_int(p->type);
    
    //printf("type of fan %d should be %c\n", type_id, p->type);

    int zone_id; // for holding which zone was allocated 0 - home, 1 - away, 2 - neutral
    {
        int i = type_id;
        struct timespec timeToWait;
        struct timeval now;
        int rt;

        
        gettimeofday(&now,NULL);


        timeToWait.tv_sec = now.tv_sec+p->patience_time;
        
        justincase :
        pthread_mutex_lock(&sync_stuff.fans_type_mutex[i]);
        rt = pthread_cond_timedwait(&sync_stuff.fans_type[i], &sync_stuff.fans_type_mutex[i], &timeToWait);
        //pthread_cond_wait(&sync_stuff.fans_type[i], &sync_stuff.fans_type_mutex[i]);
        pthread_mutex_unlock(&sync_stuff.fans_type_mutex[i]);

        if(rt == ETIMEDOUT){
            printf(BCYN "Person %s couldn't get a seat\n", person_id);
            return NULL;
        }

        if(i == 0){
            if(!sem_trywait(&sync_stuff.capacity[0])) {
                //printf("Person %s got a seat in zone %d\n", person_id, 0);
                zone_id = 0;
                printf(BMAG "Person %s got a seat in zone %c\n", person_id, team_int_to_char(zone_id));
            }
            else 
            if(!sem_trywait(&sync_stuff.capacity[1])) {
                //printf("Person %s got a seat in zone %d\n", person_id, 1);
                zone_id = 1;
                printf(BMAG "Person %s got a seat in zone %c\n", person_id, team_int_to_char(zone_id));
            }
            else 
            goto justincase;
        }
        else if(i == 1){
            if(!sem_trywait(&sync_stuff.capacity[0])) {
                zone_id = 0;
                printf(BMAG "Person %s got a seat in zone %c\n", person_id, team_int_to_char(zone_id));
            }
            else 
            if(!sem_trywait(&sync_stuff.capacity[1])) {
                zone_id = 1;
                printf(BMAG "Person %s got a seat in zone %c\n", person_id, team_int_to_char(zone_id));
            }
            else 
            if(!sem_trywait(&sync_stuff.capacity[2])) {
                zone_id = 2;
                printf(BMAG "Person %s got a seat in zone %c\n", person_id, team_int_to_char(zone_id));
            }
            else
            goto justincase;
        }
        else{
            if(!sem_trywait(&sync_stuff.capacity[2])) {
                zone_id = 2;
                printf(BMAG "Person %s got a seat in zone %c\n", person_id, team_int_to_char(zone_id));
            }
            else
            goto justincase;
        }
    }

    {
        
        int i = type_id;
        struct timespec timeToWait;
        struct timeval now;
        int rt;

        
        gettimeofday(&now,NULL);


        timeToWait.tv_sec = now.tv_sec+spectating_time;
        timeToWait.tv_nsec = now.tv_usec*1000;
        
        restarting :
        pthread_mutex_lock(&sync_stuff.goal_cond_mutex);
        rt = pthread_cond_timedwait(&sync_stuff.goal_cond , &sync_stuff.goal_cond_mutex , &timeToWait);
        pthread_mutex_unlock(&sync_stuff.goal_cond_mutex);

        if(rt == ETIMEDOUT){
            printf(BYEL "Person %s watched the match for %d seconds and is leaving\n", person_id, spectating_time);
            goto end;
        }

        if(sync_stuff.goals_count[team_char_to_int(p->type)] >= p->goal_limit){
            printf(BYEL "Person %s is leaving due to the bad defensive performance of his team\n", person_id);
            goto end;
        }
        else goto restarting;
    }

    end: 
        sem_post(&sync_stuff.capacity[zone_id]);
}


void *goal_thread(void *arg) {
    
    struct goal_prob *store = (struct goal_prob *)arg;

    sleep(store->time);

    int chance = store->prob*100;

    if((rand()%100) < chance){
        printf(BRED "Team %c have scored their %dth goal\n", store->team_id, (sync_stuff.goals_count[team_char_to_int(store->team_id)]+1));
        
        pthread_mutex_lock(&sync_stuff.goals_count_mutex);
        sync_stuff.goals_count[team_char_to_int(store->team_id)]++;        
        pthread_mutex_unlock(&sync_stuff.goals_count_mutex);

        pthread_cond_broadcast(&sync_stuff.goal_cond);
    }
    else {
        printf(BRED "Team %c missed the chance to score their %dth goal\n", store->team_id, (sync_stuff.goals_count[team_char_to_int(store->team_id)]+1));
    } 
}

void *zone_thread(void *arg){
    
    int i = *(int *)arg;

    //printf("Zone %d is ready\n", i);
    while(1){
        if(done) break;

        int val;
        sem_getvalue(&sync_stuff.capacity[i], &val);

        //printf("Zone %d has %d people\n", i, val);

        if(!sem_wait(&sync_stuff.capacity[i])){

            //printf("Am i useful ?\n");
            if(i == 0){
                sem_post(&sync_stuff.capacity[i]);
                //pthread_mutex_lock(&sync_stuff.fans_type_mutex[0]);
                pthread_cond_signal(&sync_stuff.fans_type[0]);
                //pthread_mutex_unlock(&sync_stuff.fans_type_mutex[0]);

                //pthread_mutex_lock(&sync_stuff.fans_type_mutex[1]);
                pthread_cond_signal(&sync_stuff.fans_type[1]);
                //pthread_mutex_unlock(&sync_stuff.fans_type_mutex[1]);
                
            }
            else if(i == 1){
                sem_post(&sync_stuff.capacity[i]);
                //pthread_mutex_lock(&sync_stuff.fans_type_mutex[0]);
                pthread_cond_signal(&sync_stuff.fans_type[0]);
                //pthread_mutex_unlock(&sync_stuff.fans_type_mutex[0]);

                //pthread_mutex_lock(&sync_stuff.fans_type_mutex[1]);
                pthread_cond_signal(&sync_stuff.fans_type[1]);
                //pthread_mutex_unlock(&sync_stuff.fans_type_mutex[1]);
                
            }
            else if(i == 2){
                sem_post(&sync_stuff.capacity[i]);
                //pthread_mutex_lock(&sync_stuff.fans_type_mutex[1]);
                pthread_cond_signal(&sync_stuff.fans_type[1]);
                //pthread_mutex_unlock(&sync_stuff.fans_type_mutex[1]);

                //pthread_mutex_lock(&sync_stuff.fans_type_mutex[2]);
                pthread_cond_signal(&sync_stuff.fans_type[2]);
                //pthread_mutex_unlock(&sync_stuff.fans_type_mutex[2]);
                
            }

            
            sem_getvalue(&sync_stuff.capacity[i], &val);

            //printf("Zone %d has %d people before incrementing\n", i, val);
            
            
            
            
            sem_getvalue(&sync_stuff.capacity[i], &val);

            //printf("Zone %d has %d people after incrementing\n", i, val);
            
        } 
    }

}

void sync_init(){

    f(3){
        sem_init(&sync_stuff.capacity[i], 0, seating_capacity[i]);
        int j;
        sem_getvalue(&sync_stuff.capacity[i], &j);
        //printf("Zone %d capacity is %d\n", i, j);
        sync_stuff.fans_type[i] = (pthread_cond_t)PTHREAD_COND_INITIALIZER;
        sync_stuff.fans_type_mutex[i] =  (pthread_mutex_t)PTHREAD_MUTEX_INITIALIZER;
    }

    sync_stuff.goal_cond = (pthread_cond_t)PTHREAD_COND_INITIALIZER;
    sync_stuff.goal_cond_mutex =  (pthread_mutex_t)PTHREAD_MUTEX_INITIALIZER;

    sync_stuff.goal_cond = (pthread_cond_t)PTHREAD_COND_INITIALIZER;
    sync_stuff.goal_cond_mutex =  (pthread_mutex_t)PTHREAD_MUTEX_INITIALIZER;

    pthread_mutex_lock(&sync_stuff.goals_count_mutex);
    sync_stuff.goals_count[0] = 0;
    sync_stuff.goals_count[1] = -2;
    sync_stuff.goals_count[2] = 0;
    pthread_mutex_unlock(&sync_stuff.goals_count_mutex);
}

int main(){
    

    scanf("%d %d %d", &home_capacity, &away_capacity, &neutral_capacity);

    seating_capacity[0] = home_capacity;
    seating_capacity[2] = away_capacity;
    seating_capacity[1] = neutral_capacity;

    scanf("%d", &spectating_time);

    scanf("%d", &num_groups);

    sync_init();

    groups = (group*)malloc(num_groups * sizeof(group));

    int total_people = 0;    

    f(num_groups){
        int num_people;

        total_people += num_people;

        scanf("%d", &num_people);

        groups[i].size = num_people;
        groups[i].members = (person*)malloc(num_people * sizeof(person));
        groups[i].id = (i+1);

        f2(num_people){
            char name[NAME_LENGTH]; 
            char type;
            int reachtime;
            int patience;
            int goal_limit;

            scanf("%s %c %d %d %d", name, &type, &reachtime, &patience, &goal_limit);

            strcpy(groups[i].members[i2].name, name);
            groups[i].members[i2].type = type;
            groups[i].members[i2].time_reached = reachtime;
            groups[i].members[i2].patience_time = patience;
            groups[i].members[i2].goal_limit = goal_limit;
        }
    }

    pthread_t *spec_threads = (pthread_t*)malloc(total_people * sizeof(pthread_t));

    int index=0;

    f(num_groups){
        f1(groups[i].size){
            pthread_create(&spec_threads[index], NULL, &spectator_thread, &groups[i].members[i1]);
            index++;
        }
    }

    pthread_t *zone_threads = (pthread_t*)malloc(3 * sizeof(pthread_t));

    int a=0, b=1, c=2;

    pthread_create(&zone_threads[a], NULL, &zone_thread, &a);
    pthread_create(&zone_threads[b], NULL, &zone_thread, &b);
    pthread_create(&zone_threads[c], NULL, &zone_thread, &c);

    
    int num_goals;
    scanf("%d", &num_goals);
    //printf("%d\n", num_goals);

    struct goal_prob store[num_goals];

    pthread_t *goal_threads = (pthread_t*)malloc(num_goals * sizeof(pthread_t));

    f(num_goals){
        char team_id;
        int goal_time;
        float prob; 
        scanf(" %c %d %f", &team_id, &goal_time, &prob);

        //printf("%c %d %f\n", team_id, goal_time, prob);

        store[i].team_id = team_id;
        store[i].time = goal_time;
        store[i].prob = prob;

        pthread_create(&goal_threads[i], NULL, &goal_thread, &store[i]);
    }

    f(total_people){
        pthread_join(spec_threads[i], NULL);

        done = 1;
    }

    f(num_goals){
        pthread_join(goal_threads[i], NULL);
        pthread_cond_broadcast(&sync_stuff.goal_cond);
    }

    f(3){
        pthread_join(zone_threads[i], NULL);
    }
}