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


void container_scheduler(int cid)
{
  struct proc *p;
  struct cpu *c = mycpu();
  struct container* con = &ctable.container[cid];

  acquire(&ctable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(con->presentProc[p->pid]){
      if(p->state != RUNNABLE)
        continue;

      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
      swtch(&(c->scheduler), p->context);
      switchkvm();
      c->proc = 0;
    }
  }
  release(&ctable.lock);
}

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
