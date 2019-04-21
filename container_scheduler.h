enum containerState {CRUNNING,CWAITING,CUNUSED};

struct container{
  int containerID;                // ID of the container
  int presentProc[NPROC];   // Boolean for which processes are present in this container
  enum containerState state;                  // Whetehr the container is running or not
  int nextGVA;
};

struct pageElement{
  int GVA;      //Guest Virtual Address
  int HVA;      //Host Virtual Address
  int pid;      //Which process has asked for it
};
