#include "utils.h"
#include "network_utils.h"
#include "useless.h"
#include <sstream>

class LockedString {
    public:

    std::string str;
    pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;
    bool empty = true;
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
        std::cout << "GetString: " << ret << std::endl;
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
            pthread_mutex_lock(&other.lock);
            std::string s = this->str;
            this->str += other.str;
            other.str += s;
            pthread_mutex_unlock(&other.lock);
            pthread_mutex_unlock(&lock);
        } 
        else if(other.index < index) {
            pthread_mutex_lock(&other.lock);
            pthread_mutex_lock(&lock);
            //other.str += GetString();
            std::string s = this->str;
            this->str += other.str;
            other.str += s;
            pthread_mutex_unlock(&lock);
            pthread_mutex_unlock(&other.lock);
        }
        else if(index == other.index) {
            pthread_mutex_lock(&lock);
            str += str;
            pthread_mutex_unlock(&lock);
        }

        return 0;
    }

    int Remove(){
        if(empty)
            return -1;

        pthread_mutex_lock(&lock);
        str = "";
        empty = true;
        pthread_mutex_unlock(&lock);
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

        //std::cout<<"Request: "<<request<<std::endl;
        std::istringstream ss(request);

        std::string word;
        
        ss>>word;
        std::string type = word;

        //std::cout<<"type: "<<type<<std::endl;

        ss>>word;
        int key = std::stoi(word);

        //std::cout<<"key: "<<key<<std::endl;

        std::string value;

        if(type != "delete" && type != "fetch"){
            ss>>word;
            value = word;
        }

        //std::cout<<"value: "<<value<<std::endl;

        if(type == "insert") {
            int status = dict[key].InsertString(value);

            if(status == -1) {
                //std::cout<<"Error: Insert failed"<<std::endl;
                write(req.client_socket_fd ,"Key already exists", 19);
            }
            else {
                //std::cout<<"Inserted: "<<value<<" at index: "<<key<<std::endl;
                write(req.client_socket_fd ,"Insertion successful", 21);
            }
        }
        else if(type == "update") {
            int status = dict[key].UpdateString(value);

            if(status == -1) {
                std::cout<<"Error: Update failed"<<std::endl;
                write(req.client_socket_fd ,"Key does not exist", 19);
            }
            else {
                std::cout<<"Updated: "<<value<<" at index: "<<key<<std::endl;
                std::string ret = dict[key].GetString();
                write(req.client_socket_fd, ret.c_str(), ret.length());
            }
        }
        else if(type == "fetch") {

            if(dict[key].isEmpty()){
                //std::cout<<"Key does not exist"<<std::endl;
                write(req.client_socket_fd ,"Key does not exist", 19);
            }
            else {
                std::string ret = dict[key].GetString();
                std::cout<<"Fetched: "<<ret<<std::endl;
                write(req.client_socket_fd, ret.c_str(), ret.length());
            }
            //std::cout<<"Fetched: "<<ret<<std::endl;
        }
        else if(type == "concat") {
            int key2 = std::stoi(value);
            int status = dict[key].concat(dict[key2]);

            if(status == -1) {
                write(req.client_socket_fd ,"Concat failed as at least one of the keys does not exist", 57);
            }
            else {
                std::string ret = dict[key2].GetString();
                write(req.client_socket_fd, ret.c_str(), ret.length());
            }
        }
        else if(type == "delete") {
            if(dict[key].isEmpty()){
                write(req.client_socket_fd ,"No such key exists", 19);
            }
            dict[key].Remove();
        }
        else {
            std::string ret = "Invalid request";
            write(req.client_socket_fd, ret.c_str(), ret.length());
        }

        close(req.client_socket_fd);
        printf(BRED "Disconnected from client" ANSI_RESET "\n");

    }

}

int main(int argc, char *argv[]) {

    f(100)
        dict[i].index = i;

    int num_workers = atoi(argv[1]);

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

    listen(wel_socket_fd, 20);
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