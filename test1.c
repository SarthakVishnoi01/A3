#include "types.h"
#include "stat.h"
#include "user.h"

int
main(void)
{
	// toggle();	// toggle the system trace on or off
	create_container();
  create_container();
  create_container();

  int cid1 = fork();
  if(cid1 == 0){
    join_container(1);
    ps();
    wait();
    // list_containers();
    exit();
  }
  sleep(2);
  // destroy_container(1);
  list_containers();

  int cid2 = fork();
  if(cid2 == 0){
    join_container(2);
    wait();
    ps();
    exit();
  }

  sleep(2);
  // list_containers();

  ps();
	wait();



	//Malloc
	int *mal1 = malloc(6);
	int *mal2 = malloc(10);
	printf(1, "%d %d\n", *mal1, *mal2);
	//malloc returns the address
	exit();
}
