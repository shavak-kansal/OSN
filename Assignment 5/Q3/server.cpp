#include "utils.h"
#include "network_utils.h"
#include "useless.h"
#include <sstream>

using namespace std;

pair<string, int> read_string_from_socket(const int &fd, int bytes)
{
    string output;
    output.resize(bytes);

    int bytes_received = read(fd, &output[0], bytes - 1);
    debug(bytes_received);
    if (bytes_received <= 0)
    {
        cerr << "Failed to read data from socket. \n";
    }

    output[bytes_received] = 0;
    output.resize(bytes_received);
    // debug(output);
    return {output, bytes_received};
}

int send_string_on_socket(int fd, const string &s)
{
    // debug(s.length());
    int bytes_sent = write(fd, s.c_str(), s.length());
    if (bytes_sent < 0)
    {
        cerr << "Failed to SEND DATA via socket.\n";
    }

    return bytes_sent;
}


class LockedString {
    public:

    string str;
    pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;
    bool empty = true;
    int index;

    int UpdateString(string new_str) {
        if(empty) 
            return -1;

        pthread_mutex_lock(&lock);
        str = new_str;
        pthread_mutex_unlock(&lock);

        return 0;
    }

    int InsertString(string new_str) {
        if(!empty) 
            return -1;

        pthread_mutex_lock(&lock);
        str = new_str;
        empty = false;
        pthread_mutex_unlock(&lock);

        return 0;
    }

    string GetString() {
        pthread_mutex_lock(&lock);
        string ret = str;
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
            pthread_mutex_lock(&other.lock);
            string s = this->str;
            this->str += other.str;
            other.str += s;
            pthread_mutex_unlock(&other.lock);
            pthread_mutex_unlock(&lock);
        } 
        else if(other.index < index) {
            pthread_mutex_lock(&other.lock);
            pthread_mutex_lock(&lock);
            //other.str += GetString();
            string s = this->str;
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

    queue<ClientRequests> queueInternal;
    pthread_mutex_t queue_lock = PTHREAD_MUTEX_INITIALIZER;
    
    pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
    pthread_mutex_t cond_lock = PTHREAD_MUTEX_INITIALIZER;
};


vector<LockedString> dict(100);
LockedQueue requestsList;

int SenderWrapper(int fd, string s1, string s2) {
    
    string msg_to_send_back = s1 + " : " + s2;
    int sent_to_client = send_string_on_socket(fd, msg_to_send_back);
    
    if(sent_to_client < 0) {
        cerr << "Failed to send data to client.\n";
    }

    return 0;
}
void *WorkerThread(void *arg) {
    
    while(1){

        pid_t x = syscall(__NR_gettid);

        string thread_id = to_string(x);

        pthread_mutex_lock(&requestsList.cond_lock);
        pthread_cond_wait(&requestsList.cond, &requestsList.cond_lock);
        pthread_mutex_unlock(&requestsList.cond_lock);

        pthread_mutex_lock(&requestsList.queue_lock);

        ClientRequests req = requestsList.queueInternal.front();
        requestsList.queueInternal.pop();

        pthread_mutex_unlock(&requestsList.queue_lock);


        string request;
        int received_num;
        
        tie(request, received_num) = read_string_from_socket(req.client_socket_fd, buff_sz);

        cout<<"Request:"<<request<<endl;
        
        if(!strcmp(request.c_str(), "clear")) {
            cout << "clearing" << endl;
            f(100)
                dict[i].Remove();
            
            write(req.client_socket_fd, "cleared", 7);

        }
        else 
        {
        istringstream ss(request);

        string word;
        
        ss>>word;
        string type = word;

        
        ss>>word;
        int key = stoi(word);

        
        string value;

        if(type != "delete" && type != "fetch"){
            ss>>word;
            value = word;
        }

        if(type == "insert") {
            int status = dict[key].InsertString(value);

            if(status == -1) {
                SenderWrapper(req.client_socket_fd, thread_id, "Key already exists");
            }
            else {
                SenderWrapper(req.client_socket_fd, thread_id, "Insertion successful");
            }
        }
        else if(type == "update") {
            int status = dict[key].UpdateString(value);

            if(status == -1) {
                cout<<"Error: Update failed"<<endl;
                SenderWrapper(req.client_socket_fd, thread_id, "Key does not exist");
            }
            else {
                cout<<"Updated: "<<value<<" at index: "<<key<<endl;
                string ret = dict[key].GetString();

                SenderWrapper(req.client_socket_fd, thread_id, ret);
                
            }
        }
        else if(type == "fetch") {

            if(dict[key].isEmpty()){

                SenderWrapper(req.client_socket_fd, thread_id, "Key does not exist");
            }
            else {
                string ret = dict[key].GetString();
                cout<<"Fetched: "<<ret<<endl;

                SenderWrapper(req.client_socket_fd, thread_id, ret);
            }
            //cout<<"Fetched: "<<ret<<endl;
        }
        else if(type == "concat") {
            int key2 = stoi(value);
            int status = dict[key].concat(dict[key2]);

            if(status == -1) {

                SenderWrapper(req.client_socket_fd, thread_id, "Concat failed as at least one of the keys does not exist");
            }
            else {
                string ret = dict[key2].GetString();
                cout<<"Concatenated str1: "<<dict[key].GetString()<<" and str2: "<<dict[key2].GetString()<<endl;

                SenderWrapper(req.client_socket_fd, thread_id, ret);
            }
        }
        else if(type == "delete") {
            if(dict[key].isEmpty()){
                SenderWrapper(req.client_socket_fd, thread_id, "No such key exists");
            }
            dict[key].Remove();
        }
        else {
            string ret = "Invalid request";

            SenderWrapper(req.client_socket_fd, thread_id, "Invalid request");

        }
    }
        
        close(req.client_socket_fd);
        printf(BRED "Disconnected from client" ANSI_RESET "\n");

    }

}

int main(int argc, char *argv[]) {

    f(100)
        dict[i].index = i;

    int num_workers = atoi(argv[1]);

    vector<pthread_t> threads(num_workers);

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
    cout << "Server has started listening on the LISTEN PORT" << endl;

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
        requestsList.queueInternal.push(req);
        pthread_mutex_unlock(&requestsList.queue_lock);

        //sth uncertain here
        pthread_cond_signal(&requestsList.cond);
    }

    f(num_workers)
        pthread_join(threads[i], NULL);
}