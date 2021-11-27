# Data Structures

## Struct Course

>  Name - Name of course
>
> interest_quotient - Interest associated with the course
>
> max_slots - Max slots that can be allotted in a course tutorial
>
> num_labs - Number of labs the ta's can be chosen from 
>
> lab_list - list of the labs from which ta's can be selected 
>
> tut_cond - conditional variable for selecting students for the course tutorial
>
> tut_cond_lock - lock associated with tut_cond 
>
> in_tut - conditional variable for signaling the end of the tut, student threads wait on it to indicate being in tut
>
> in_tut_lock - lock associated with in_tut
>
> students_attending - Keeps count of how many students are in the current tut
>
> student_counter_lock - lock associated with students_attending variable for it be thread safe
>
> course_end - variable which indicates whether course has ended  1 - indicates end of course 0 - indicates course isnt ended yet

## Struct Student 

> student_id - id of student
>
> pref1 - course id of first course preference
>
> pref2 -  course id of second course preference
>
> pref3 -  course id of third course preference
>
> calibre - caliber of student
>
> time - time when student registers

## Struct Lab 

> lab_id - id of lab 
>
> lab_name - name of lab 
>
> ta_num - number of ta's
>
> max_turns - max turns of a ta in this lab 
>
> ta_list - list of ta in labs 

## Struct TA 

> lock - lock associated with individual ta so as to make it thread safe
>
> ta_id - id of ta 
>
> course_id -  id of ta they whose tutorial they are taking right now 