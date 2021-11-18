#include "utils.h"
#include "network_utils.h"
#include "useless.h"
#include <sstream>

class LockedString {
    std::string str;
    pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;
    bool empty = true;
    

    public:
    
    int index;
    int UpdateString(std::string new_str) {
        if(empty) 
            return -1;

        pthread_mutex_lock(&lock);
        str = new_str;
        pthread_mutex_unlock(&lock);

        return 0;
    }

    int InsertString(std::string new_str) {
        if(!empty) 
            return -1;

        pthread_mutex_lock(&lock);
        str = new_str;
        empty = false;
        pthread_mutex_unlock(&lock);

        return 0;
    }

    std::string GetString() {
        pthread_mutex_lock(&lock);
        std::string ret = str;
        pthread_mutex_unlock(&lock);
        return ret;
    }

    bool isEmpty() {
        return empty;
    }

    int concat(LockedString &other) {
        if(other.isEmpty())
            return -1;

        if(empty)
            return -1;

        if(index < other.index) {
            pthread_mutex_lock(&lock);
            str += other.GetString();
            pthread_mutex_unlock(&lock);
        } 
        else if(other.index < index) {
            pthread_mutex_lock(&other.lock);
            other.str += GetString();
            pthread_mutex_unlock(&other.lock);
        }
        else if(index == other.index) {
            pthread_mutex_lock(&lock);
            str += str;
            pthread_mutex_unlock(&lock);
        }

        return 0;
    }

};

class ClientRequests {
    public:
    struct sockaddr_in client_addr_obj;
    socklen_t clilen =  sizeof(client_addr_obj);
    int client_socket_fd;
};

class LockedQueue {
    public:

    std::queue<ClientRequests> queue;
    pthread_mutex_t queue_lock = PTHREAD_MUTEX_INITIALIZER;
    
    pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
    pthread_mutex_t cond_lock = PTHREAD_MUTEX_INITIALIZER;
};


std::vector<LockedString> dict(100);
LockedQueue requestsList;

void *WorkerThread(void *arg) {
    
    while(1){

        pthread_mutex_lock(&requestsList.cond_lock);
        pthread_cond_wait(&requestsList.cond, &requestsList.cond_lock);
        pthread_mutex_unlock(&requestsList.cond_lock);

        pthread_mutex_lock(&requestsList.queue_lock);

        ClientRequests req = requestsList.queue.front();
        requestsList.queue.pop();

        pthread_mutex_unlock(&requestsList.queue_lock);


        std::string request;
        request.resize(128);
        int n = read(req.client_socket_fd, &request[0], 127);

        std::istringstream ss(request);

        std::string word;
        
        ss>>word;
        std::string type = word;

        ss>>word;
        int key = stoi(word);

        ss>>word;
        std::string value = word;

        if(type == "insert") {
            dict[key].InsertString(value);
        }
        else if(type == "update") {
            dict[key].UpdateString(value);
        }
        else if(type == "fetch") {
            std::string ret = dict[key].GetString();
            write(req.client_socket_fd, ret.c_str(), ret.length());
        }
        else if(type == "concat") {
            int key2 = stoi(value);
            dict[key].concat(dict[key2]);
        }
        else {
            std::string ret = "Invalid request";
            write(req.client_socket_fd, ret.c_str(), ret.length());
        }
    }

}

int main(int argc, char *argv[]) {

    f(100)
        dict[i].index = i;

    int num_workers = std::stoi(argv[1]);

    std::vector<pthread_t> threads(num_workers);

    f(num_workers)
        pthread_create(&threads[i], NULL, WorkerThread, NULL);


    int wel_socket_fd, client_socket_fd, port_number;
    socklen_t clilen;

    struct sockaddr_in serv_addr_obj, client_addr_obj;
    clilen = sizeof(client_addr_obj);

    wel_socket_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (wel_socket_fd < 0)
    {
        perror("ERROR creating welcoming socket");
        exit(-1);
    }

    bzero((char *)&serv_addr_obj, sizeof(serv_addr_obj));
    port_number = PORT_ARG;
    serv_addr_obj.sin_family = AF_INET;
    serv_addr_obj.sin_addr.s_addr = INADDR_ANY;
    serv_addr_obj.sin_port = htons(port_number);

    if (bind(wel_socket_fd, (struct sockaddr *)&serv_addr_obj, sizeof(serv_addr_obj)) < 0)
    {
        perror("Error on bind on welcome socket: ");
        exit(-1);
    }

    listen(wel_socket_fd, 11);
    std::cout << "Server has started listening on the LISTEN PORT" << std::endl;

    while (1)
    {
        client_socket_fd = accept(wel_socket_fd, (struct sockaddr *)&client_addr_obj, &clilen);
        if (client_socket_fd < 0)
        {
            perror("ERROR on accept");
            exit(-1);
        }

        printf(BGRN "New client connected from port number %d and IP %s \n" ANSI_RESET, ntohs(client_addr_obj.sin_port), inet_ntoa(client_addr_obj.sin_addr));

        ClientRequests req;
        req.client_socket_fd = client_socket_fd;
        memcpy(&req.client_addr_obj, &client_addr_obj, sizeof(client_addr_obj));
        req.clilen = sizeof(client_addr_obj);

        pthread_mutex_lock(&requestsList.queue_lock);
        requestsList.queue.push(req);
        pthread_mutex_unlock(&requestsList.queue_lock);

        //sth uncertain here
        pthread_cond_signal(&requestsList.cond);
    }

    f(num_workers)
        pthread_join(threads[i], NULL);
}