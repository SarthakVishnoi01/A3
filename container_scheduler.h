enum containerState {CRUNNING,CWAITING,CUNUSED};

struct container{
  int containerID;                // ID of the container
  int presentProc[NPROC];   // Boolean for which processes are present in this container
  enum containerState state;                  // Whetehr the container is running or not
  int nextprocId;
};

