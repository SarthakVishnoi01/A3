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
