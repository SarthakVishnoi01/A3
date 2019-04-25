#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
#include "fs.h"


char buf[512];

/*void
cat1(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
    if (write(1, buf, n) != n) {
      printf(1, "cat: write error\n");
      exit();
    }
  }
  if(n < 0){
    printf(1, "cat: read error\n");
    exit();
  }
}

int
cat1(char* s)
{
  int fd;

  if(strlen(s) <= 0){
    cat(0);return -1;
  }

  if((fd = open(s, O_RDWR)) < 0){
      printf(1, "cat: cannot open %s\n", s);
      return -1;
  }
  cat1(fd);  close(fd);
  return 1;
}*/

void cat(char* s){

    int f ;
    if((f= open(s,O_RDWR))<0)
      printf(1,"%s\n","Cat : Error" );

    char buf[13];
    read(f,buf,13);
    printf(1,"%s\n",buf );
    close(f);

}

    
char*
fmtname(char *path)
{
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    ;
  p++;

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}

void
ls1(char *path)
{
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
    printf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
    printf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
    break;

  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
      printf(1, "ls: path too long\n");
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';

    while(read(fd, &de, sizeof(de)) == sizeof(de)){

      if(de.inum == 0){
      	continue;
      }
      memmove(p, de.name, DIRSIZ);

      int c=0;
      while(*(buf+c)){
      	c++;
      }

      int num = buf[c-1]-'0';
      int cid = getcid();

      if(num>0 && num<8 && (cid!=0) ){
      	if(cid!=num)
      		continue;
      }

      p[DIRSIZ] = 0;
      if(stat(buf, &st) < 0){
      	printf(1, "%s\n", fmtname(buf));
        continue;
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
}

int
ls()
{
  ls1(".");
  return 1;
}

int
main(void)
{
	// toggle();	// toggle the system trace on or off
  create_container();
  create_container();
  create_container();

  int f1 = fork();
  if(f1==0){
  	join_container(1);

  	sleep(150);
  	leave_container();
  	exit();
  }

  int f2 = fork();
  if(f2==0){
  	join_container(1);



  	sleep(150);
  	leave_container();
  	exit();
  }

  int f3 = fork();
  if(f3==0){
  	join_container(1);
  	
  	ps();
  	sleep(120);

  	char* str = malloc(10);		strcpy(str,"file"); 	int num;
  	if(getpid()>9)
  		num = getpid() -10;
  	else
  		num = getpid();

  	str[4] = num + '0';
  	strcpy(str+5,".txt\0");
  	//printf(1,"%s\n",str );

  	int fd1 = open(str,O_CREATE | O_RDWR);
  	close(fd1);

    //ls();

  	int fd = open("my_file", O_CREATE | O_RDWR);
  	char c = num + '0'; 
  	char* st = malloc(14);strcpy(st,"Modified by:");strcpy(st+12,&c);strcpy(st+13,'\0');
  	write(fd,st,14);
  	close(fd);

    //cat("my_file");

    int f= open("my_file",O_RDWR);
    char buf[13];
    read(f,buf,13);
    printf(1,"%s\n",buf );
    close(f);


  	leave_container();
  	exit();
  }

  int f4 = fork();
  if(f4==0){
  	join_container(2);

  	ps();
  	sleep(120);

  	char* str = malloc(10);		strcpy(str,"file"); 	int num;
  	if(getpid()>9)
  		num = getpid() -10;
  	else
  		num = getpid();

  	str[4] = num + '0';
  	strcpy(str+5,".txt\0");
  	//printf(1,"%s\n",str );

  	int fd1 = open(str,O_CREATE | O_RDWR);
  	close(fd1);

    //ls();

  	int fd = open("my_file", O_CREATE | O_RDWR);
  	char c = num + '0'; 
  	char* st = malloc(14);strcpy(st,"Modified by:");strcpy(st+12,&c);strcpy(st+13,'\0');
  	write(fd,st,14);
  	close(fd);
  	
    //cat("my_file");

    int f= open("my_file",O_RDWR);
    char buf[13];
    read(f,buf,13);
    printf(1,"%s\n",buf );
    close(f);


  	leave_container();
  	exit();
  }

  int f5 = fork();
  if(f5==0){
  	join_container(3);
  	
  	ps();
  	sleep(120);

  	char* str = malloc(10);		strcpy(str,"file"); 	int num;
  	if(getpid()>9)
  		num = getpid() -10;
  	else
  		num = getpid();

  	str[4] = num + '0';
  	strcpy(str+5,".txt\0");
  	//printf(1,"%s\n",str );

	  int fd1 = open(str,O_CREATE | O_RDWR);
	  close(fd1);

    //ls();

	  int fd = open("my_file", O_CREATE | O_RDWR);
  	char c = num + '0'; 
  	char* st = malloc(14);strcpy(st,"Modified by:");strcpy(st+12,&c);strcpy(st+13,'\0');
  	write(fd,st,14);
  	close(fd);	  
    //cat("my_file");

    int f= open("my_file",O_RDWR);
    char buf[13];
    read(f,buf,13);
    printf(1,"%s\n",buf );
    close(f);


  	leave_container();
  	exit();
  }


  scheduler_log_on();
  sleep(10);
  scheduler_log_off();


  sleep(200);

  memory_log_on();
  container_malloc(8);
  
  destroy_container(1);
  destroy_container(2);
  destroy_container(3);
  wait();
  wait();
  wait();
  wait(); 
	wait();
	exit();
}
