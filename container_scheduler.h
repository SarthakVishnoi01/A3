enum containerState {CRUNNING,CWAITING,CUNUSED};

struct pgElement{
  int GVA;      //Guest Virtual Address
  char* HVA;      //Host Virtual Address
  int pid;      //Which process has asked for it
};

struct pgTable{
  struct pgElement page[100];
  int next;
};

struct container{
  int containerID;                            // ID of the container
  int presentProc[NPROC];                     // Boolean for which processes are present in this container
  enum containerState state;                  // Whetehr the container is running or not
  int nextGVA;
  struct pgTable pgTable;                 //PageTable for this container
  int nextprocId;
  struct inode* root
};
