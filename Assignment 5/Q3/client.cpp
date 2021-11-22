#include "utils.h"
#include "network_utils.h"
#include "useless.h"

using namespace std;

int get_socket_fd(struct sockaddr_in *ptr)
{
    struct sockaddr_in server_obj = *ptr;


    int socket_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (socket_fd < 0)
    {
        perror("Error in socket creation for CLIENT");
        exit(-1);
    }
    
    int port_num = PORT_ARG;

    memset(&server_obj, 0, sizeof(server_obj)); // Zero out structure
    server_obj.sin_family = AF_INET;
    server_obj.sin_port = htons(port_num); //convert to big-endian order



    if (connect(socket_fd, (struct sockaddr *)&server_obj, sizeof(server_obj)) < 0)
    {
        perror("Problem in connecting to the server");
        exit(-1);
    }

    return socket_fd;
}

void *thread_handler(void *arg){

    auto p = (pair<string, int> *)arg;

    int delay = p->second;
    string s = p->first;

    sleep(delay);
    
    cout <<"Sending " << s << endl;

    struct sockaddr_in server_obj;
    int socket_fd = get_socket_fd(&server_obj);

    write(socket_fd, s.c_str(), s.length());

    //string response;
    //response.resize(128);

    char response[128];

    read(socket_fd, response, 127);

    //cout << "Response: " << response << endl;

    printf("Response : %s\n", response);
    return NULL;
}

pair<string, int> get_pair(char* s){
    string s1;

    char time[2];
    time[0] = s[0];
    time[1] = '\0';

    int i = atoi(time);

    for(int i=2; s[i] != '\0'; i++){
        s1.push_back(s[i]);
    }

    return make_pair(s1, i);
}
int main(){
    int n;

    cin>>n;

    pthread_t threads[n];

    f(n){
        //int time;
        //cin>>time;

        //string s;
        //cin>>s;

        char s[100];

        //getline(cin, s);

        scanf(" %[^\n]", s);
        //cout<<s<<endl;

        //fgets(s, 100, stdin);
        pair<string, int> p = get_pair(s);

        pthread_create(&threads[i], NULL, thread_handler, (void *)&p);
    }

    f(n){
        pthread_join(threads[i], NULL);
    }
}   

