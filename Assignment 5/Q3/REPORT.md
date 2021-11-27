# Compiling and Running the code 
To compile both the files just run 
>make

After that for starting the server application use the command 
>./server (number of threads)

for example if you want the number of threads as 4 use the command
>./server 4

after compiling server.

For starting the client application just run 
>./client

The input format is as shown in the assignment pdf.

# Explaining the logic 

## Data Structures 

### LockedString

`LockedString` is just a string object with an associated lock packaged in the form of a class. The lock is used for synchronizing operations. 

The operations implemented are :- 

> int UpdateString(string new_str)

`UpdateString` as the name suggest updates the string stored in the object.

It acquires the lock and then changes the string.

Return Value  : (-1) if string doesn't exist otherwise 0.

> int InsertString(string new_str)

`InsertString` inserts the string new_str.

It acquires the lock and then inserts the string.

Return Value : -1 if string already exists, 0 otherwise

> string GetString()

`GetString()` returns the string stored in the object instance

> int concat(LockedString &other)

This function takes another instance of LockedString and concatenate the string stored in both the objects, since it is modifying the strings in both the objects, it has to require locks, this can cause deadlock, so in order to avoid the deadlock, we fix an order for acquiring the locks, the order of acquiring the locks is given by the int index variable in the object, whichever object has the lower value of index gets acquired first.

Return Value : (-1) if either of the strings doesn't exist, and 0 otherwise

> int Remove()

 Sets the empty variable to true and sets the string to empty.

Return Value : (-1) if the empty variable is true and 0 otherwise.

### ClientRequests 

The main program accepts client requests and stores the associated sockaddr_in object and the file descriptors associated with the socket in an object of this class.

### LockedQueue 

Structure for maintaining a queue of ClientRequests, it has an associated lock that makes sure that push and pop instructions are synced since multiple worker threads might try to access the queue at the same time, it has a codnitional variable associated with it on which worker threads wait, whenever a new request is pushed into the queue the conditional variable is signaled to wake up a worker thread.

## Function Entities

### Worker Thread

> void *WorkerThread(void *arg){}

At the beginning of the program a number of worker threads are spawned that  pop requests form the queue of the ClientRequests, using the file descriptors they take in input from the socket sanitize the input into usable format, and then access the appropriate item in the dictionary of the specified key and use the provided functions in the LockedString class to perform the actions, then it writethe output along with the thread id to the socket.

All of this keeps going in a while loop.

### send_string_on_socket

> int send_string_on_socket(int fd, const string &s)

Writes string s on the file descriptors fd and returns the bytes written.

### read_string_from_socket

> pair<string, int> read_string_from_socket(const int &fd, int bytes)

Reads string from file descriptor fd and returns a pair containing the string and the bytes read.

### Client Thread Handler

> void *thread_handler(void *arg)

For handling multiple request the client program assigns each request its own thread, each request contains the delay time argument and the request string which can be sent to the server program