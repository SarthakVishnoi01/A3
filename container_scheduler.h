enum c_state{RUNNING,WAITING,UNUSED}
struct container {
  int containerID;                // ID of the container
  int presentProc[NPROC] = {0};   // Boolean for which processes are present in this container
  c_state state;                  // Whetehr the container is running or not
};
