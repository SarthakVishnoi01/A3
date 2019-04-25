#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int
main(void)
{
	// toggle();	// toggle the system trace on or off
  create_container();
  create_container();
  create_container();

  // join_container(1);
  // leave_container();
  // printf(1, "sdfiushf\n");

  // int cid1 = fork();
  // if(cid1 == 0){
  //   printf(1, "I am not here\n");
  //   join_container(1);
  //   printf(1, "I am here\n");
  //   exit();
  // }
  int cid = fork();
  int fd = 0;
  if(cid == 0){
    join_container(1);
    fd = open("myfile.txt",O_CREATE | O_RDWR);
    printf(1, "FD : %d\n", fd);
    char* d = "Sarthak";
    int writee = write(fd, d, 7);
    printf(1,"1: %d\n",writee);
    close(fd);
    exit();
  }
  sleep(2);
  wait();
	int cid3 = fork();
	if(cid3==0){
    join_container(2);
		char* c = "2";
    char* temp = "Chinmay";
		int kk = read(fd,temp,1);
		printf(1,"2: %d\n", kk);
		int fd1 = open("merifile.txt",O_CREATE | O_RDWR);
		printf(1,"3: %d\n",write(fd1,c,1) );
    close(fd1);
		exit();
	}

  // sleep(2);
  // // destroy_container(1);
  // list_containers();
	//
  // int cid2 = fork();
  // if(cid2 == 0){
  //   join_container(2);
  //   wait();
  //   ps();
  //   exit();
  // }
	//
  // sleep(2);
  // // list_containers();
	//
  // ps();
	// wait();



	//Malloc
	// int *mal1 = malloc(6);
	// int *mal2 = malloc(10);
	// printf(1, "%d %d\n", mal1, mal2);
	//malloc returns the address
	// int cid3 = fork();



	// int fd = open("myfile.txt",512);
	// char x;
	// char d = '0';
	// printf(1,"1: %d\n",write(fd,&d,1) );
	// close(fd);
	// int cid3 = fork();
	// // int fd1=-1;
	// if(cid3==0){
	// 	printf(1, "Do I\n");
	// 	// char c = '2';
	// 	join_container(1);
	// 	printf(1, "I want to come here\n");
	// 	// int kk = read(fd,&c,1);
	// 	printf(1, "I can't\n");
	// 	// printf(1,"2: %d\n", kk);
	// 	printf(1, "HELLLP\n");
	// 	// fd1 = open("myfile.txt",512);
	// 	// printf(1,"3: %d\n",write(fd1,&c,1) );
	// 	list_containers();
	// 	ps();
	// 	wait();
	// 	exit();
	// }
	// ps();


	// printf(1,"4: %d\n", read(fd,&x,1));
	// printf(1,"5: %s\n", &x);
	// printf(1,"6: %d\n", read(fd1,&x,1));
	// printf(1,"7: %s\n", &x);



	// if(cid3 == 0){
	// 	join_container(2);
	// 	ps();
	// 	memory_log_on();
	// 	container_malloc(5);
	// 	memory_log_off();
	// 	container_malloc(3);
	// 	wait();
	// 	exit();
	// }
	// sleep(2);
	wait();
	exit();
}
