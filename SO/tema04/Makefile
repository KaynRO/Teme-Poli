build:libscheduler.so

libscheduler.so: PriorityQueue.c  so_scheduler.c
	gcc -fPIC -Wall -Wextra -c PriorityQueue.c -o PriorityQueue.o
	gcc -fPIC -Wall -Wextra -c so_scheduler.c -o so_scheduler.o
	gcc -shared -o libscheduler.so so_scheduler.o PriorityQueue.o -pthread

clean: 
	rm PriorityQueue.o so_scheduler.o libscheduler.so