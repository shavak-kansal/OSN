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

    s.erase(0,1);

    sleep(delay);
    
    cout << "Sending " << s << endl;

    struct sockaddr_in server_obj;
    int socket_fd = get_socket_fd(&server_obj);

    write(socket_fd, s.c_str(), s.length());

    //string response;
    //response.resize(128);

    char response[128];

    read(socket_fd, &response[0], 127);

    //cout << "Response: " << response << endl;

    printf("Response : %s", response);
    return NULL;
}

int main(){
    int n;

    cin>>n;

    pthread_t threads[n];

    f(n){
        int time;
        cin>>time;

        string s;
        //cin>>s;

        getline(cin, s);

        pair<string, int> p(s, time);

        pthread_create(&threads[i], NULL, thread_handler, (void *)&p);
    }

    f(n){
        pthread_join(threads[i], NULL);
    }
}   