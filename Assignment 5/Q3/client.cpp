#include "utils.h"
#include "network_utils.h"
#include "useless.h"

using namespace std;

pair<string, int> read_string_from_socket(int fd, int bytes)
{
    std::string output;
    output.resize(bytes);

    int bytes_received = read(fd, &output[0], bytes - 1);
    // debug(bytes_received);
    if (bytes_received <= 0)
    {
        cerr << "Failed to read data from socket. Seems server has closed socket\n";
        // return "
        exit(-1);
    }

    // debug(output);
    output[bytes_received] = 0;
    output.resize(bytes_received);

    return {output, bytes_received};
}

int send_string_on_socket(int fd, const string &s)
{
    // cout << "We are sending " << s << endl;
    int bytes_sent = write(fd, s.c_str(), s.length());
    // debug(bytes_sent);
    // debug(s);
    if (bytes_sent < 0)
    {
        cerr << "Failed to SEND DATA on socket.\n";
        // return "
        exit(-1);
    }

    return bytes_sent;
}

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

    auto full = (pair<int, pair<string, int>> *) arg;
    auto p = (pair<string, int>*)(&full->second);

    int delay = p->second;
    string s = p->first;

    sleep(delay);
    
    //cout <<"Sending:"<<s<< endl;

    struct sockaddr_in server_obj;
    int socket_fd = get_socket_fd(&server_obj);

    send_string_on_socket(socket_fd, s);

    int num_bytes_read;
    string output_msg;
    tie(output_msg, num_bytes_read) = read_string_from_socket(socket_fd, buff_sz);


    printf("%d : %s\n",full->first, output_msg.c_str());
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

    pair<int,pair<string, int>> args[n];

    f(n){
        char s[128];

        scanf(" %[^\n]", s);

        pair<int,pair<string, int>> p;
        args[i].first = i;
        args[i].second = get_pair(s);

        pthread_create(&threads[i], NULL, thread_handler, (void *)&(args[i]));
    }

    f(n){
        pthread_join(threads[i], NULL);
    }
}   

