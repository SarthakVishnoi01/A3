#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "container_scheduler.h"
#include "spinlock.h"

//Assume this has access to ctable

struct {
  struct spinlock lock;
  struct container container[NCONT];
} ctable;

// void container_scheduler(void)
// {
//   struct proc *p;
//   struct cpu *c = mycpu();
//   c->proc = 0;
//
//   for(;;){
//     // Loop over process table looking for process to run.
//     acquire(&ptable_container.lock);
//     for(p = ptable_container.proc; p < &ptable_container.proc[NPROC_conctainer]; p++){
//       if(p->state != WAITING)
//         continue;
//
//       c->proc = p;
//       p->state = READY;
//
//       while(p->state != WAITING){};
//
//       c->proc = 0;
//     }
//     release(&ptable_container.lock);
//   }
// }

void containerInit(void){
  struct container *con;
  for(int i=0; i<NCONT; i++){
    con = &ctable.container[i];
    con->id = i;
    con->state = CUNUSED;
    for(int j=0; j<NPROC; j++){
      con->presentProc[j] = 0;
    }
  }
}

void createContainer(int id){
  struct container *con;
  con = &ctable.container[id];
  con->state = CWAITING;
}

void addProcessToContainer(int pid, int containerID){
  struct container *con;
  for(con = ctable.container; con < &ctable.container[NCONT]; con++){
    if(con->containerID == containerID){
      //This is the container ID, add this process
      con->presentProc[pid] = 1; // Added the process
      break;
    }
  }
}

void removeProcessFromContainer(int pid, int containerID){
  struct container *con;
  for(con = ctable.container; con < &ctable.container[NCONT]; con++){
    if(con->containerID == containerID){
      //This is the container ID, remove this process
      con->presentProc[pid] = 0; // Remove the process
      break;
    }
  }
}

void listContainersHelper(void){
  struct container *c;
  for(c = ctable.container; c < &ctable.container[NCONT]; c++){
    // cprintf("Accessed Container %d: \n", c->containerID);
    if(containers[c->containerID] == 1){
      //This container is initialised
      cprintf("The container with id %d is initialised: \n", c->containerID);
    }
  }
}
