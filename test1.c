#include "types.h"
#include "stat.h"
#include "user.h"

int
main(void)
{
	// toggle();	// toggle the system trace on or off
	create_container(1);
  create_container(2);
  create_container(3);
  // int cid = fork();
  // if(cid == 0){
  //   join_container(1);
  // }
  //Function to list the containers and pid's in it
  list_containers();

	wait();
	exit();
}
