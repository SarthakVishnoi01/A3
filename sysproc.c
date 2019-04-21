#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "container_scheduler.h"

//Sys_calls which I will implement
int sys_create_container(void){
  int id;
  id = createContainer();
  return id;
}

int sys_destroy_container(void){
  int id;
  argint(0, &id);
  if(containers[id] == 0){
    cprintf("This is id is already non-existant\n");
  }
  else{
    // cprintf("Container Destroyed Successfully\n");
    containers[id] = 0;
  }
  destroyContainer(id);
  return 0;
}

int sys_join_container(void){
  int id;
  argint(0, &id);
  //Join this process in container ID
  if(containers[id] == 0){
    cprintf("This container doesn't exists");
    return 0;
  }
  myproc()->containerID = id;
  //Add this process in this container
  addProcessToContainer(myproc()->pid, id);
  return 0;
}

int sys_leave_container(void){
  int pid = myproc()->pid;
  int containerID = myproc()->containerID;
  removeProcessFromContainer(pid, containerID);
  return 0;
}

int sys_ps(void){
  int procID = myproc()->pid;
  int containerID = myproc()->containerID;
  cprintf("My containerID is: %d", containerID);
  psHelper(procID, containerID);
  return 0;
}

int sys_list_containers(void){
  listContainersHelper();
  return 0;
}

// SYS_calls which were implemented from before
int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
