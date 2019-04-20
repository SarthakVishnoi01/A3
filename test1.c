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
	wait();
	exit();
}
