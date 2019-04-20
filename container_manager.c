#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "container_scheduler.h"
#include "spinlock.h"
#include "proc.h"

//Assume this has access to ctable
struct ctable {
  struct spinlock lock;
  struct container container[NCONT];
};

struct ptable {
  struct spinlock lock;
  struct proc proc[NPROC];
};


struct ctable ctable;
struct ptable ptable;


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
    con->containerID = i;
    con->state = CUNUSED;
    for(int j=0; j<NPROC; j++){
      con->presentProc[j] = 0;
    }
  }
  //Initialise Container 0
  struct container *firstContainer;
  firstContainer = &ctable.container[0];
  firstContainer->state = CWAITING;
}

int createContainer(void){
  struct container *c;
  acquire(&ctable.lock);
  int id = 0;
  int flag = 0;
  for(c=ctable.container; c<&ctable.container[NCONT]; c++){
    id = c->containerID;
    if(containers[id] == 0){
      //This is a free container
      containers[id] = 1;
      c->state = CWAITING;
      release(&ctable.lock);
      return id;
    }
  }
  cprintf("This is id is already created\n");
  release(&ctable.lock);
  con->state = CWAITING;
  return -1;
}

void destroyContainer(int id){
  struct container *con;
  acquire(&ctable.lock);
  con = &ctable.container[id];
  release(&ctable.lock);
  con->state = CUNUSED;

  //Killing the processes which are present
  struct proc *p;
  acquire(&ptable.lock);
  for(p = ptable.proc; p<&ptable.proc[NPROC]; p++){
    int pid = p->pid;
    if(con->presentProc[pid] == 1){
      //This proc is present in the container, SO KILL IT
      con->presentProc[pid] = 0;
      release(&ptable.lock);
      kill(pid);
      acquire(&ptable.lock);
    }
  }
  release(&ptable.lock);
}

void addProcessToContainer(int pid, int containerID){
  struct container *con;
  acquire(&ctable.lock);
  for(con = ctable.container; con < &ctable.container[NCONT]; con++){
    if(con->containerID == containerID){
      //This is the container ID, add this process
      con->presentProc[pid] = 1; // Added the process
      break;
    }
  }

  //Deleting this from Container 0
  struct container *firstContainer;
  firstContainer = &ctable.container[0];
  firstContainer->presentProc[pid] = 0;
  release(&ctable.lock);
}

void removeProcessFromContainer(int pid, int containerID){
  struct container *con;
  acquire(&ctable.lock);
  for(con = ctable.container; con < &ctable.container[NCONT]; con++){
    if(con->containerID == containerID){
      //This is the container ID, remove this process
      con->presentProc[pid] = 0; // Remove the process
      break;
    }
  }

  //Adding this process to root container
  struct container *firstContainer;
  firstContainer = &ctable.container[0];
  firstContainer->presentProc[pid] = 1;
  release(&ctable.lock);
}

void listContainersHelper(void){
  struct container *c;
  acquire(&ctable.lock);
  for(c = ctable.container; c < &ctable.container[NCONT]; c++){
    if(containers[c->containerID] == 1){
      //This container is initialised
      cprintf("The container with id %d is initialised: \n", c->containerID);
      //Checking the processes in this container
      for(int j=0; j<NPROC; j++){
        if(c->presentProc[j] == 1){
          cprintf("The process with id %d is present in container with id %d: \n", j, c->containerID);
        }
      }
    }
  }
  release(&ctable.lock);
}
