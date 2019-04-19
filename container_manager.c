struct proc_cont {


}

struct {
  struct spinlock lock;
  struct cont proc_cont[NPROC_CONT];
  int cid;
} container;


enum c_state{RUNNING,READY,WAITING}
void container_scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
  
  for(;;){
    // Loop over process table looking for process to run.
    acquire(&ptable_container.lock);
    for(p = ptable_container.proc; p < &ptable_container.proc[NPROC_conctainer]; p++){
      if(p->state != WAITING)
        continue;

      c->proc = p;
      p->state = READY;

      while(p->state != WAITING){};

      c->proc = 0;
    }
    release(&ptable_container.lock);

  }
}