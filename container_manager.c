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
// struct ctable {
//   struct spinlock lock;
//   struct container container[NCONT];
// };
//
// struct ptable {
//   struct spinlock lock;
//   struct proc proc[NPROC];
// };
//
// struct ctable ctable;
// struct ptable ptable;
// struct pgTable pgTable;

// void containerInit(void){
//   struct container *con;
//   for(int i=0; i<NCONT; i++){
//     con = &ctable.container[i];
//     con->containerID = i;
//     con->state = CUNUSED;
//     con->nextGVA = 0;
//     con->pgTable.next = 0; //Setting Next for this pgTable
//   }
//
//   //Initialise Container 0
//   struct container *firstContainer;
//   firstContainer = &ctable.container[0];
//   firstContainer->state = CWAITING;
// }
//
// int createContainer(void){
//   struct container *c;
//   acquire(&ctable.lock);
//   int id = 0;
//   for(c=ctable.container; c<&ctable.container[NCONT]; c++){
//     id = c->containerID;
//     if(containers[id] == 0 && id!=0){
//       //This is a free container
//       containers[id] = 1;
//       c->state = CWAITING;
//       release(&ctable.lock);
//       return id;
//     }
//   }
//   cprintf("Couldn't create a new container\n");
//   release(&ctable.lock);
//   return -1;
// }
//
// void destroyContainer(int id){
//   struct container *con;
//   acquire(&ctable.lock);
//   con = &ctable.container[id];
//   con->state = CUNUSED;
//   containers[id] = 0;
//   release(&ctable.lock);
//
//   //Killing the processes which are present
//   struct proc *p;
//   acquire(&ptable.lock);
//   for(p = ptable.proc; p<&ptable.proc[NPROC]; p++){
//     int pid = p->pid;
//     if(p->contaninerID == id){
//       //This proc is present in the container, SO KILL IT
//       release(&ptable.lock);
//       kill(pid);
//       acquire(&ptable.lock);
//     }
//   }
//   release(&ptable.lock);
// }
//
// void addProcessToContainer(int pid, int containerID){
//   // struct container *con;
//   struct proc *p;
//   acquire(&ptable.lock);
//   for(p=ptable.proc; p<&ptable.proc[NPROC]; p++){
//     if(p->pid == pid){
//       p->containerID = containerID;
//     }
//   }
//   release(&ptable.lock);
// }
//
// void removeProcessFromContainer(int pid){
//   // struct container *con;
//   struct proc *p;
//   acquire(&ptable.lock);
//   for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
//     if(p->pid == pid){
//       p->containerID = 0;
//     }
//   }
//   release(&ptable.lock);
// }
//
// void listContainersHelper(void){
//   struct proc *p;
//   acquire(&ptable.lock);
//   for(p=ptable.proc; p<&ptable.proc[NPROC]; p++){
//     cprintf("process %d is present in container %d\n", p->pid, p->containerID);
//   }
// }


