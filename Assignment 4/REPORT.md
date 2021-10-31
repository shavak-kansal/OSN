# Specification 1
Adding a system call called `strace`.
To implement this we create two arrays one storing the number of arguments in each syscall and the other array holding the name of each syscall.

We use this arrays in syscall() by comparing the syscall numberm and then saving the first argument before calling the system call function, after that in the inner loop we print the system call arguments and its return value.

# Specification 2 - Scheduling

## FCFS 

Mostly the same as the default scheduler but created a new variable `birthtime` in proc struct which stores the creation time using ticks in allocproc, using this we find the process in the proc table with smallest birthtime and then scheduling that process.

## PBS 

Once again similar to FCFS but instead of using the parameter birthtime we use dynamic priority.

Dynamic priotiy depends on static priority and niceness.

Niceness is a variable dependent on sleeping and running time, we create a variable runtime which records the time the process ran the last time it was scheduled which is updated by the function , the variable sched1 records the time it was scheduled last and sched2 records the time it became RUNNABLE again, sleeping time is derived by sched2 - sched1 - runtime.

Then we just use the formulas described in the PDF.

## MLFQ

Firstly we create 5 separte arrays of pointers (circular queues), each queue corresponds to the 5 levels of MLFQ the queue array is mfq.

Then we have two variables called inQ and timeinQ holding wether the process is in q or not and how much time it has left in the queue respectively. 

The variable level holds which level (level of queue) it is in.

The variable timeinQ is updated in the RunningTime() function, in the trap.c we make the proper interrupts including the condition for updating of the level of the processor if it has used its time slice and we update timeinQ variable too according to the new level of the process.

In allocproc we set the level of every process to 0 and the associated timeinQ.

The function used by the array mfq are ProcQueueDeque which just removes the first element from the front and returns it, ProcQueueuEnque adds a new process at the rear of the queue, ProcQueueRemove removes a element from the queue at random by moving to the end and then decrementing the rear int value.

# Performance Benchmark 

## MLFQ 

| Average Runtime | Average waittime |
| --------------- | ---------------- |
| 6              | 119               |

## PBS

| Average Runtime | Average waitime |
| --------------- | --------------- |
| 6               | 112              |

## FCFS
| Average Runtime | Average waitime |
| --------------- | --------------- |
| 5               | 111             |

## DEFAULT - RR
| Average Runtime | Average waitime |
| --------------- | --------------- |
| 6               | 124            |