
_test1:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
	// toggle();	// toggle the system trace on or off
	create_container();
  11:	e8 5c 03 00 00       	call   372 <create_container>
  create_container();
  16:	e8 57 03 00 00       	call   372 <create_container>
  create_container();
  1b:	e8 52 03 00 00       	call   372 <create_container>

  int cid1 = fork();
  20:	e8 a5 02 00 00       	call   2ca <fork>
  if(cid1 == 0){
  25:	85 c0                	test   %eax,%eax
  27:	75 19                	jne    42 <main+0x42>
    join_container(1);
  29:	83 ec 0c             	sub    $0xc,%esp
  2c:	6a 01                	push   $0x1
  2e:	e8 47 03 00 00       	call   37a <join_container>
    ps();
  33:	e8 5a 03 00 00       	call   392 <ps>
    wait();
  38:	e8 9d 02 00 00       	call   2da <wait>
    // list_containers();
    exit();
  3d:	e8 90 02 00 00       	call   2d2 <exit>
  }
  sleep(2);
  42:	83 ec 0c             	sub    $0xc,%esp
  45:	6a 02                	push   $0x2
  47:	e8 16 03 00 00       	call   362 <sleep>
  // destroy_container(1);
  list_containers();
  4c:	e8 49 03 00 00       	call   39a <list_containers>

  int cid2 = fork();
  51:	e8 74 02 00 00       	call   2ca <fork>
  if(cid2 == 0){
  56:	83 c4 10             	add    $0x10,%esp
  59:	85 c0                	test   %eax,%eax
  5b:	75 19                	jne    76 <main+0x76>
    join_container(2);
  5d:	83 ec 0c             	sub    $0xc,%esp
  60:	6a 02                	push   $0x2
  62:	e8 13 03 00 00       	call   37a <join_container>
    wait();
  67:	e8 6e 02 00 00       	call   2da <wait>
    ps();
  6c:	e8 21 03 00 00       	call   392 <ps>
    exit();
  71:	e8 5c 02 00 00       	call   2d2 <exit>
  }

  sleep(2);
  76:	83 ec 0c             	sub    $0xc,%esp
  79:	6a 02                	push   $0x2
  7b:	e8 e2 02 00 00       	call   362 <sleep>
  // list_containers();

  ps();
  80:	e8 0d 03 00 00       	call   392 <ps>
	wait();
  85:	e8 50 02 00 00       	call   2da <wait>
	exit();
  8a:	e8 43 02 00 00       	call   2d2 <exit>
  8f:	90                   	nop

00000090 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	53                   	push   %ebx
  94:	8b 45 08             	mov    0x8(%ebp),%eax
  97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  9a:	89 c2                	mov    %eax,%edx
  9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  a0:	83 c1 01             	add    $0x1,%ecx
  a3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  a7:	83 c2 01             	add    $0x1,%edx
  aa:	84 db                	test   %bl,%bl
  ac:	88 5a ff             	mov    %bl,-0x1(%edx)
  af:	75 ef                	jne    a0 <strcpy+0x10>
    ;
  return os;
}
  b1:	5b                   	pop    %ebx
  b2:	5d                   	pop    %ebp
  b3:	c3                   	ret    
  b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000000c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	56                   	push   %esi
  c4:	53                   	push   %ebx
  c5:	8b 55 08             	mov    0x8(%ebp),%edx
  c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  cb:	0f b6 02             	movzbl (%edx),%eax
  ce:	0f b6 19             	movzbl (%ecx),%ebx
  d1:	84 c0                	test   %al,%al
  d3:	75 1e                	jne    f3 <strcmp+0x33>
  d5:	eb 29                	jmp    100 <strcmp+0x40>
  d7:	89 f6                	mov    %esi,%esi
  d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
  e0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  e3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
  e6:	8d 71 01             	lea    0x1(%ecx),%esi
  while(*p && *p == *q)
  e9:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
  ed:	84 c0                	test   %al,%al
  ef:	74 0f                	je     100 <strcmp+0x40>
  f1:	89 f1                	mov    %esi,%ecx
  f3:	38 d8                	cmp    %bl,%al
  f5:	74 e9                	je     e0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
  f7:	29 d8                	sub    %ebx,%eax
}
  f9:	5b                   	pop    %ebx
  fa:	5e                   	pop    %esi
  fb:	5d                   	pop    %ebp
  fc:	c3                   	ret    
  fd:	8d 76 00             	lea    0x0(%esi),%esi
  while(*p && *p == *q)
 100:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 102:	29 d8                	sub    %ebx,%eax
}
 104:	5b                   	pop    %ebx
 105:	5e                   	pop    %esi
 106:	5d                   	pop    %ebp
 107:	c3                   	ret    
 108:	90                   	nop
 109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000110 <strlen>:

uint
strlen(const char *s)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 116:	80 39 00             	cmpb   $0x0,(%ecx)
 119:	74 12                	je     12d <strlen+0x1d>
 11b:	31 d2                	xor    %edx,%edx
 11d:	8d 76 00             	lea    0x0(%esi),%esi
 120:	83 c2 01             	add    $0x1,%edx
 123:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 127:	89 d0                	mov    %edx,%eax
 129:	75 f5                	jne    120 <strlen+0x10>
    ;
  return n;
}
 12b:	5d                   	pop    %ebp
 12c:	c3                   	ret    
  for(n = 0; s[n]; n++)
 12d:	31 c0                	xor    %eax,%eax
}
 12f:	5d                   	pop    %ebp
 130:	c3                   	ret    
 131:	eb 0d                	jmp    140 <memset>
 133:	90                   	nop
 134:	90                   	nop
 135:	90                   	nop
 136:	90                   	nop
 137:	90                   	nop
 138:	90                   	nop
 139:	90                   	nop
 13a:	90                   	nop
 13b:	90                   	nop
 13c:	90                   	nop
 13d:	90                   	nop
 13e:	90                   	nop
 13f:	90                   	nop

00000140 <memset>:

void*
memset(void *dst, int c, uint n)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	57                   	push   %edi
 144:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 147:	8b 4d 10             	mov    0x10(%ebp),%ecx
 14a:	8b 45 0c             	mov    0xc(%ebp),%eax
 14d:	89 d7                	mov    %edx,%edi
 14f:	fc                   	cld    
 150:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 152:	89 d0                	mov    %edx,%eax
 154:	5f                   	pop    %edi
 155:	5d                   	pop    %ebp
 156:	c3                   	ret    
 157:	89 f6                	mov    %esi,%esi
 159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000160 <strchr>:

char*
strchr(const char *s, char c)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	53                   	push   %ebx
 164:	8b 45 08             	mov    0x8(%ebp),%eax
 167:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 16a:	0f b6 10             	movzbl (%eax),%edx
 16d:	84 d2                	test   %dl,%dl
 16f:	74 1d                	je     18e <strchr+0x2e>
    if(*s == c)
 171:	38 d3                	cmp    %dl,%bl
 173:	89 d9                	mov    %ebx,%ecx
 175:	75 0d                	jne    184 <strchr+0x24>
 177:	eb 17                	jmp    190 <strchr+0x30>
 179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 180:	38 ca                	cmp    %cl,%dl
 182:	74 0c                	je     190 <strchr+0x30>
  for(; *s; s++)
 184:	83 c0 01             	add    $0x1,%eax
 187:	0f b6 10             	movzbl (%eax),%edx
 18a:	84 d2                	test   %dl,%dl
 18c:	75 f2                	jne    180 <strchr+0x20>
      return (char*)s;
  return 0;
 18e:	31 c0                	xor    %eax,%eax
}
 190:	5b                   	pop    %ebx
 191:	5d                   	pop    %ebp
 192:	c3                   	ret    
 193:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001a0 <gets>:

char*
gets(char *buf, int max)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	57                   	push   %edi
 1a4:	56                   	push   %esi
 1a5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a6:	31 f6                	xor    %esi,%esi
    cc = read(0, &c, 1);
 1a8:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 1ab:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 1ae:	eb 29                	jmp    1d9 <gets+0x39>
    cc = read(0, &c, 1);
 1b0:	83 ec 04             	sub    $0x4,%esp
 1b3:	6a 01                	push   $0x1
 1b5:	57                   	push   %edi
 1b6:	6a 00                	push   $0x0
 1b8:	e8 2d 01 00 00       	call   2ea <read>
    if(cc < 1)
 1bd:	83 c4 10             	add    $0x10,%esp
 1c0:	85 c0                	test   %eax,%eax
 1c2:	7e 1d                	jle    1e1 <gets+0x41>
      break;
    buf[i++] = c;
 1c4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1c8:	8b 55 08             	mov    0x8(%ebp),%edx
 1cb:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 1cd:	3c 0a                	cmp    $0xa,%al
    buf[i++] = c;
 1cf:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1d3:	74 1b                	je     1f0 <gets+0x50>
 1d5:	3c 0d                	cmp    $0xd,%al
 1d7:	74 17                	je     1f0 <gets+0x50>
  for(i=0; i+1 < max; ){
 1d9:	8d 5e 01             	lea    0x1(%esi),%ebx
 1dc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1df:	7c cf                	jl     1b0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 1e1:	8b 45 08             	mov    0x8(%ebp),%eax
 1e4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 1e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1eb:	5b                   	pop    %ebx
 1ec:	5e                   	pop    %esi
 1ed:	5f                   	pop    %edi
 1ee:	5d                   	pop    %ebp
 1ef:	c3                   	ret    
  buf[i] = '\0';
 1f0:	8b 45 08             	mov    0x8(%ebp),%eax
  for(i=0; i+1 < max; ){
 1f3:	89 de                	mov    %ebx,%esi
  buf[i] = '\0';
 1f5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 1f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1fc:	5b                   	pop    %ebx
 1fd:	5e                   	pop    %esi
 1fe:	5f                   	pop    %edi
 1ff:	5d                   	pop    %ebp
 200:	c3                   	ret    
 201:	eb 0d                	jmp    210 <stat>
 203:	90                   	nop
 204:	90                   	nop
 205:	90                   	nop
 206:	90                   	nop
 207:	90                   	nop
 208:	90                   	nop
 209:	90                   	nop
 20a:	90                   	nop
 20b:	90                   	nop
 20c:	90                   	nop
 20d:	90                   	nop
 20e:	90                   	nop
 20f:	90                   	nop

00000210 <stat>:

int
stat(const char *n, struct stat *st)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	56                   	push   %esi
 214:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 215:	83 ec 08             	sub    $0x8,%esp
 218:	6a 00                	push   $0x0
 21a:	ff 75 08             	pushl  0x8(%ebp)
 21d:	e8 f0 00 00 00       	call   312 <open>
  if(fd < 0)
 222:	83 c4 10             	add    $0x10,%esp
 225:	85 c0                	test   %eax,%eax
 227:	78 27                	js     250 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 229:	83 ec 08             	sub    $0x8,%esp
 22c:	ff 75 0c             	pushl  0xc(%ebp)
 22f:	89 c3                	mov    %eax,%ebx
 231:	50                   	push   %eax
 232:	e8 f3 00 00 00       	call   32a <fstat>
  close(fd);
 237:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 23a:	89 c6                	mov    %eax,%esi
  close(fd);
 23c:	e8 b9 00 00 00       	call   2fa <close>
  return r;
 241:	83 c4 10             	add    $0x10,%esp
}
 244:	8d 65 f8             	lea    -0x8(%ebp),%esp
 247:	89 f0                	mov    %esi,%eax
 249:	5b                   	pop    %ebx
 24a:	5e                   	pop    %esi
 24b:	5d                   	pop    %ebp
 24c:	c3                   	ret    
 24d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 250:	be ff ff ff ff       	mov    $0xffffffff,%esi
 255:	eb ed                	jmp    244 <stat+0x34>
 257:	89 f6                	mov    %esi,%esi
 259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000260 <atoi>:

int
atoi(const char *s)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	53                   	push   %ebx
 264:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 267:	0f be 11             	movsbl (%ecx),%edx
 26a:	8d 42 d0             	lea    -0x30(%edx),%eax
 26d:	3c 09                	cmp    $0x9,%al
 26f:	b8 00 00 00 00       	mov    $0x0,%eax
 274:	77 1f                	ja     295 <atoi+0x35>
 276:	8d 76 00             	lea    0x0(%esi),%esi
 279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 280:	8d 04 80             	lea    (%eax,%eax,4),%eax
 283:	83 c1 01             	add    $0x1,%ecx
 286:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 28a:	0f be 11             	movsbl (%ecx),%edx
 28d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 290:	80 fb 09             	cmp    $0x9,%bl
 293:	76 eb                	jbe    280 <atoi+0x20>
  return n;
}
 295:	5b                   	pop    %ebx
 296:	5d                   	pop    %ebp
 297:	c3                   	ret    
 298:	90                   	nop
 299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	56                   	push   %esi
 2a4:	53                   	push   %ebx
 2a5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ae:	85 db                	test   %ebx,%ebx
 2b0:	7e 14                	jle    2c6 <memmove+0x26>
 2b2:	31 d2                	xor    %edx,%edx
 2b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 2b8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 2bc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2bf:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 2c2:	39 da                	cmp    %ebx,%edx
 2c4:	75 f2                	jne    2b8 <memmove+0x18>
  return vdst;
}
 2c6:	5b                   	pop    %ebx
 2c7:	5e                   	pop    %esi
 2c8:	5d                   	pop    %ebp
 2c9:	c3                   	ret    

000002ca <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2ca:	b8 01 00 00 00       	mov    $0x1,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <exit>:
SYSCALL(exit)
 2d2:	b8 02 00 00 00       	mov    $0x2,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <wait>:
SYSCALL(wait)
 2da:	b8 03 00 00 00       	mov    $0x3,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <pipe>:
SYSCALL(pipe)
 2e2:	b8 04 00 00 00       	mov    $0x4,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <read>:
SYSCALL(read)
 2ea:	b8 05 00 00 00       	mov    $0x5,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <write>:
SYSCALL(write)
 2f2:	b8 10 00 00 00       	mov    $0x10,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <close>:
SYSCALL(close)
 2fa:	b8 15 00 00 00       	mov    $0x15,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <kill>:
SYSCALL(kill)
 302:	b8 06 00 00 00       	mov    $0x6,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <exec>:
SYSCALL(exec)
 30a:	b8 07 00 00 00       	mov    $0x7,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <open>:
SYSCALL(open)
 312:	b8 0f 00 00 00       	mov    $0xf,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <mknod>:
SYSCALL(mknod)
 31a:	b8 11 00 00 00       	mov    $0x11,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <unlink>:
SYSCALL(unlink)
 322:	b8 12 00 00 00       	mov    $0x12,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <fstat>:
SYSCALL(fstat)
 32a:	b8 08 00 00 00       	mov    $0x8,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <link>:
SYSCALL(link)
 332:	b8 13 00 00 00       	mov    $0x13,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <mkdir>:
SYSCALL(mkdir)
 33a:	b8 14 00 00 00       	mov    $0x14,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <chdir>:
SYSCALL(chdir)
 342:	b8 09 00 00 00       	mov    $0x9,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <dup>:
SYSCALL(dup)
 34a:	b8 0a 00 00 00       	mov    $0xa,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <getpid>:
SYSCALL(getpid)
 352:	b8 0b 00 00 00       	mov    $0xb,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <sbrk>:
SYSCALL(sbrk)
 35a:	b8 0c 00 00 00       	mov    $0xc,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <sleep>:
SYSCALL(sleep)
 362:	b8 0d 00 00 00       	mov    $0xd,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <uptime>:
SYSCALL(uptime)
 36a:	b8 0e 00 00 00       	mov    $0xe,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <create_container>:
SYSCALL(create_container)
 372:	b8 16 00 00 00       	mov    $0x16,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <join_container>:
SYSCALL(join_container)
 37a:	b8 17 00 00 00       	mov    $0x17,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <leave_container>:
SYSCALL(leave_container)
 382:	b8 18 00 00 00       	mov    $0x18,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <destroy_container>:
SYSCALL(destroy_container)
 38a:	b8 19 00 00 00       	mov    $0x19,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <ps>:
SYSCALL(ps)
 392:	b8 1a 00 00 00       	mov    $0x1a,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <list_containers>:
SYSCALL(list_containers)
 39a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    
 3a2:	66 90                	xchg   %ax,%ax
 3a4:	66 90                	xchg   %ax,%ax
 3a6:	66 90                	xchg   %ax,%ax
 3a8:	66 90                	xchg   %ax,%ax
 3aa:	66 90                	xchg   %ax,%ax
 3ac:	66 90                	xchg   %ax,%ax
 3ae:	66 90                	xchg   %ax,%ax

000003b0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	57                   	push   %edi
 3b4:	56                   	push   %esi
 3b5:	53                   	push   %ebx
 3b6:	89 c6                	mov    %eax,%esi
 3b8:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 3be:	85 db                	test   %ebx,%ebx
 3c0:	74 7e                	je     440 <printint+0x90>
 3c2:	89 d0                	mov    %edx,%eax
 3c4:	c1 e8 1f             	shr    $0x1f,%eax
 3c7:	84 c0                	test   %al,%al
 3c9:	74 75                	je     440 <printint+0x90>
    neg = 1;
    x = -xx;
 3cb:	89 d0                	mov    %edx,%eax
    neg = 1;
 3cd:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    x = -xx;
 3d4:	f7 d8                	neg    %eax
 3d6:	89 75 c0             	mov    %esi,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3d9:	31 ff                	xor    %edi,%edi
 3db:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 3de:	89 ce                	mov    %ecx,%esi
 3e0:	eb 08                	jmp    3ea <printint+0x3a>
 3e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 3e8:	89 cf                	mov    %ecx,%edi
 3ea:	31 d2                	xor    %edx,%edx
 3ec:	8d 4f 01             	lea    0x1(%edi),%ecx
 3ef:	f7 f6                	div    %esi
 3f1:	0f b6 92 78 07 00 00 	movzbl 0x778(%edx),%edx
  }while((x /= base) != 0);
 3f8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 3fa:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 3fd:	75 e9                	jne    3e8 <printint+0x38>
  if(neg)
 3ff:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 402:	8b 75 c0             	mov    -0x40(%ebp),%esi
 405:	85 c0                	test   %eax,%eax
 407:	74 08                	je     411 <printint+0x61>
    buf[i++] = '-';
 409:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 40e:	8d 4f 02             	lea    0x2(%edi),%ecx

  while(--i >= 0)
 411:	8d 79 ff             	lea    -0x1(%ecx),%edi
 414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 418:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
  write(fd, &c, 1);
 41d:	83 ec 04             	sub    $0x4,%esp
  while(--i >= 0)
 420:	83 ef 01             	sub    $0x1,%edi
  write(fd, &c, 1);
 423:	6a 01                	push   $0x1
 425:	53                   	push   %ebx
 426:	56                   	push   %esi
 427:	88 45 d7             	mov    %al,-0x29(%ebp)
 42a:	e8 c3 fe ff ff       	call   2f2 <write>
  while(--i >= 0)
 42f:	83 c4 10             	add    $0x10,%esp
 432:	83 ff ff             	cmp    $0xffffffff,%edi
 435:	75 e1                	jne    418 <printint+0x68>
    putc(fd, buf[i]);
}
 437:	8d 65 f4             	lea    -0xc(%ebp),%esp
 43a:	5b                   	pop    %ebx
 43b:	5e                   	pop    %esi
 43c:	5f                   	pop    %edi
 43d:	5d                   	pop    %ebp
 43e:	c3                   	ret    
 43f:	90                   	nop
    x = xx;
 440:	89 d0                	mov    %edx,%eax
  neg = 0;
 442:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 449:	eb 8b                	jmp    3d6 <printint+0x26>
 44b:	90                   	nop
 44c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000450 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	57                   	push   %edi
 454:	56                   	push   %esi
 455:	53                   	push   %ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 456:	8d 45 10             	lea    0x10(%ebp),%eax
{
 459:	83 ec 2c             	sub    $0x2c,%esp
  for(i = 0; fmt[i]; i++){
 45c:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 45f:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 462:	89 45 d0             	mov    %eax,-0x30(%ebp)
 465:	0f b6 1e             	movzbl (%esi),%ebx
 468:	83 c6 01             	add    $0x1,%esi
 46b:	84 db                	test   %bl,%bl
 46d:	0f 84 b0 00 00 00    	je     523 <printf+0xd3>
 473:	31 d2                	xor    %edx,%edx
 475:	eb 39                	jmp    4b0 <printf+0x60>
 477:	89 f6                	mov    %esi,%esi
 479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 480:	83 f8 25             	cmp    $0x25,%eax
 483:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 486:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 48b:	74 18                	je     4a5 <printf+0x55>
  write(fd, &c, 1);
 48d:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 490:	83 ec 04             	sub    $0x4,%esp
 493:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 496:	6a 01                	push   $0x1
 498:	50                   	push   %eax
 499:	57                   	push   %edi
 49a:	e8 53 fe ff ff       	call   2f2 <write>
 49f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 4a2:	83 c4 10             	add    $0x10,%esp
 4a5:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 4a8:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 4ac:	84 db                	test   %bl,%bl
 4ae:	74 73                	je     523 <printf+0xd3>
    if(state == 0){
 4b0:	85 d2                	test   %edx,%edx
    c = fmt[i] & 0xff;
 4b2:	0f be cb             	movsbl %bl,%ecx
 4b5:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 4b8:	74 c6                	je     480 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4ba:	83 fa 25             	cmp    $0x25,%edx
 4bd:	75 e6                	jne    4a5 <printf+0x55>
      if(c == 'd'){
 4bf:	83 f8 64             	cmp    $0x64,%eax
 4c2:	0f 84 f8 00 00 00    	je     5c0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4c8:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 4ce:	83 f9 70             	cmp    $0x70,%ecx
 4d1:	74 5d                	je     530 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4d3:	83 f8 73             	cmp    $0x73,%eax
 4d6:	0f 84 84 00 00 00    	je     560 <printf+0x110>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4dc:	83 f8 63             	cmp    $0x63,%eax
 4df:	0f 84 ea 00 00 00    	je     5cf <printf+0x17f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4e5:	83 f8 25             	cmp    $0x25,%eax
 4e8:	0f 84 c2 00 00 00    	je     5b0 <printf+0x160>
  write(fd, &c, 1);
 4ee:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4f1:	83 ec 04             	sub    $0x4,%esp
 4f4:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4f8:	6a 01                	push   $0x1
 4fa:	50                   	push   %eax
 4fb:	57                   	push   %edi
 4fc:	e8 f1 fd ff ff       	call   2f2 <write>
 501:	83 c4 0c             	add    $0xc,%esp
 504:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 507:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 50a:	6a 01                	push   $0x1
 50c:	50                   	push   %eax
 50d:	57                   	push   %edi
 50e:	83 c6 01             	add    $0x1,%esi
 511:	e8 dc fd ff ff       	call   2f2 <write>
  for(i = 0; fmt[i]; i++){
 516:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 51a:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 51d:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 51f:	84 db                	test   %bl,%bl
 521:	75 8d                	jne    4b0 <printf+0x60>
    }
  }
}
 523:	8d 65 f4             	lea    -0xc(%ebp),%esp
 526:	5b                   	pop    %ebx
 527:	5e                   	pop    %esi
 528:	5f                   	pop    %edi
 529:	5d                   	pop    %ebp
 52a:	c3                   	ret    
 52b:	90                   	nop
 52c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 16, 0);
 530:	83 ec 0c             	sub    $0xc,%esp
 533:	b9 10 00 00 00       	mov    $0x10,%ecx
 538:	6a 00                	push   $0x0
 53a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 53d:	89 f8                	mov    %edi,%eax
 53f:	8b 13                	mov    (%ebx),%edx
 541:	e8 6a fe ff ff       	call   3b0 <printint>
        ap++;
 546:	89 d8                	mov    %ebx,%eax
 548:	83 c4 10             	add    $0x10,%esp
      state = 0;
 54b:	31 d2                	xor    %edx,%edx
        ap++;
 54d:	83 c0 04             	add    $0x4,%eax
 550:	89 45 d0             	mov    %eax,-0x30(%ebp)
 553:	e9 4d ff ff ff       	jmp    4a5 <printf+0x55>
 558:	90                   	nop
 559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 560:	8b 45 d0             	mov    -0x30(%ebp),%eax
 563:	8b 18                	mov    (%eax),%ebx
        ap++;
 565:	83 c0 04             	add    $0x4,%eax
 568:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 56b:	85 db                	test   %ebx,%ebx
 56d:	74 7c                	je     5eb <printf+0x19b>
        while(*s != 0){
 56f:	0f b6 03             	movzbl (%ebx),%eax
 572:	84 c0                	test   %al,%al
 574:	74 29                	je     59f <printf+0x14f>
 576:	8d 76 00             	lea    0x0(%esi),%esi
 579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 580:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 583:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 586:	83 ec 04             	sub    $0x4,%esp
 589:	6a 01                	push   $0x1
          s++;
 58b:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 58e:	50                   	push   %eax
 58f:	57                   	push   %edi
 590:	e8 5d fd ff ff       	call   2f2 <write>
        while(*s != 0){
 595:	0f b6 03             	movzbl (%ebx),%eax
 598:	83 c4 10             	add    $0x10,%esp
 59b:	84 c0                	test   %al,%al
 59d:	75 e1                	jne    580 <printf+0x130>
      state = 0;
 59f:	31 d2                	xor    %edx,%edx
 5a1:	e9 ff fe ff ff       	jmp    4a5 <printf+0x55>
 5a6:	8d 76 00             	lea    0x0(%esi),%esi
 5a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  write(fd, &c, 1);
 5b0:	83 ec 04             	sub    $0x4,%esp
 5b3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 5b6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 5b9:	6a 01                	push   $0x1
 5bb:	e9 4c ff ff ff       	jmp    50c <printf+0xbc>
        printint(fd, *ap, 10, 1);
 5c0:	83 ec 0c             	sub    $0xc,%esp
 5c3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5c8:	6a 01                	push   $0x1
 5ca:	e9 6b ff ff ff       	jmp    53a <printf+0xea>
        putc(fd, *ap);
 5cf:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 5d2:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 5d5:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 5d7:	6a 01                	push   $0x1
        putc(fd, *ap);
 5d9:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 5dc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 5df:	50                   	push   %eax
 5e0:	57                   	push   %edi
 5e1:	e8 0c fd ff ff       	call   2f2 <write>
 5e6:	e9 5b ff ff ff       	jmp    546 <printf+0xf6>
        while(*s != 0){
 5eb:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 5f0:	bb 70 07 00 00       	mov    $0x770,%ebx
 5f5:	eb 89                	jmp    580 <printf+0x130>
 5f7:	66 90                	xchg   %ax,%ax
 5f9:	66 90                	xchg   %ax,%ax
 5fb:	66 90                	xchg   %ax,%ax
 5fd:	66 90                	xchg   %ax,%ax
 5ff:	90                   	nop

00000600 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 600:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 601:	a1 10 0a 00 00       	mov    0xa10,%eax
{
 606:	89 e5                	mov    %esp,%ebp
 608:	57                   	push   %edi
 609:	56                   	push   %esi
 60a:	53                   	push   %ebx
 60b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 60e:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 610:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 613:	39 c8                	cmp    %ecx,%eax
 615:	73 19                	jae    630 <free+0x30>
 617:	89 f6                	mov    %esi,%esi
 619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 620:	39 d1                	cmp    %edx,%ecx
 622:	72 1c                	jb     640 <free+0x40>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 624:	39 d0                	cmp    %edx,%eax
 626:	73 18                	jae    640 <free+0x40>
{
 628:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 62a:	39 c8                	cmp    %ecx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 62c:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 62e:	72 f0                	jb     620 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 630:	39 d0                	cmp    %edx,%eax
 632:	72 f4                	jb     628 <free+0x28>
 634:	39 d1                	cmp    %edx,%ecx
 636:	73 f0                	jae    628 <free+0x28>
 638:	90                   	nop
 639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
  if(bp + bp->s.size == p->s.ptr){
 640:	8b 73 fc             	mov    -0x4(%ebx),%esi
 643:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 646:	39 fa                	cmp    %edi,%edx
 648:	74 19                	je     663 <free+0x63>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 64a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 64d:	8b 50 04             	mov    0x4(%eax),%edx
 650:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 653:	39 f1                	cmp    %esi,%ecx
 655:	74 23                	je     67a <free+0x7a>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 657:	89 08                	mov    %ecx,(%eax)
  freep = p;
 659:	a3 10 0a 00 00       	mov    %eax,0xa10
}
 65e:	5b                   	pop    %ebx
 65f:	5e                   	pop    %esi
 660:	5f                   	pop    %edi
 661:	5d                   	pop    %ebp
 662:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 663:	03 72 04             	add    0x4(%edx),%esi
 666:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 669:	8b 10                	mov    (%eax),%edx
 66b:	8b 12                	mov    (%edx),%edx
 66d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 670:	8b 50 04             	mov    0x4(%eax),%edx
 673:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 676:	39 f1                	cmp    %esi,%ecx
 678:	75 dd                	jne    657 <free+0x57>
    p->s.size += bp->s.size;
 67a:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 67d:	a3 10 0a 00 00       	mov    %eax,0xa10
    p->s.size += bp->s.size;
 682:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 685:	8b 53 f8             	mov    -0x8(%ebx),%edx
 688:	89 10                	mov    %edx,(%eax)
}
 68a:	5b                   	pop    %ebx
 68b:	5e                   	pop    %esi
 68c:	5f                   	pop    %edi
 68d:	5d                   	pop    %ebp
 68e:	c3                   	ret    
 68f:	90                   	nop

00000690 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 690:	55                   	push   %ebp
 691:	89 e5                	mov    %esp,%ebp
 693:	57                   	push   %edi
 694:	56                   	push   %esi
 695:	53                   	push   %ebx
 696:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 699:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 69c:	8b 15 10 0a 00 00    	mov    0xa10,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6a2:	8d 78 07             	lea    0x7(%eax),%edi
 6a5:	c1 ef 03             	shr    $0x3,%edi
 6a8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 6ab:	85 d2                	test   %edx,%edx
 6ad:	0f 84 93 00 00 00    	je     746 <malloc+0xb6>
 6b3:	8b 02                	mov    (%edx),%eax
 6b5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 6b8:	39 cf                	cmp    %ecx,%edi
 6ba:	76 64                	jbe    720 <malloc+0x90>
 6bc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 6c2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6c7:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 6ca:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 6d1:	eb 0e                	jmp    6e1 <malloc+0x51>
 6d3:	90                   	nop
 6d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6d8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6da:	8b 48 04             	mov    0x4(%eax),%ecx
 6dd:	39 cf                	cmp    %ecx,%edi
 6df:	76 3f                	jbe    720 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6e1:	39 05 10 0a 00 00    	cmp    %eax,0xa10
 6e7:	89 c2                	mov    %eax,%edx
 6e9:	75 ed                	jne    6d8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 6eb:	83 ec 0c             	sub    $0xc,%esp
 6ee:	56                   	push   %esi
 6ef:	e8 66 fc ff ff       	call   35a <sbrk>
  if(p == (char*)-1)
 6f4:	83 c4 10             	add    $0x10,%esp
 6f7:	83 f8 ff             	cmp    $0xffffffff,%eax
 6fa:	74 1c                	je     718 <malloc+0x88>
  hp->s.size = nu;
 6fc:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6ff:	83 ec 0c             	sub    $0xc,%esp
 702:	83 c0 08             	add    $0x8,%eax
 705:	50                   	push   %eax
 706:	e8 f5 fe ff ff       	call   600 <free>
  return freep;
 70b:	8b 15 10 0a 00 00    	mov    0xa10,%edx
      if((p = morecore(nunits)) == 0)
 711:	83 c4 10             	add    $0x10,%esp
 714:	85 d2                	test   %edx,%edx
 716:	75 c0                	jne    6d8 <malloc+0x48>
        return 0;
 718:	31 c0                	xor    %eax,%eax
 71a:	eb 1c                	jmp    738 <malloc+0xa8>
 71c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 720:	39 cf                	cmp    %ecx,%edi
 722:	74 1c                	je     740 <malloc+0xb0>
        p->s.size -= nunits;
 724:	29 f9                	sub    %edi,%ecx
 726:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 729:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 72c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 72f:	89 15 10 0a 00 00    	mov    %edx,0xa10
      return (void*)(p + 1);
 735:	83 c0 08             	add    $0x8,%eax
  }
}
 738:	8d 65 f4             	lea    -0xc(%ebp),%esp
 73b:	5b                   	pop    %ebx
 73c:	5e                   	pop    %esi
 73d:	5f                   	pop    %edi
 73e:	5d                   	pop    %ebp
 73f:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 740:	8b 08                	mov    (%eax),%ecx
 742:	89 0a                	mov    %ecx,(%edx)
 744:	eb e9                	jmp    72f <malloc+0x9f>
    base.s.ptr = freep = prevp = &base;
 746:	c7 05 10 0a 00 00 14 	movl   $0xa14,0xa10
 74d:	0a 00 00 
 750:	c7 05 14 0a 00 00 14 	movl   $0xa14,0xa14
 757:	0a 00 00 
    base.s.size = 0;
 75a:	b8 14 0a 00 00       	mov    $0xa14,%eax
 75f:	c7 05 18 0a 00 00 00 	movl   $0x0,0xa18
 766:	00 00 00 
 769:	e9 4e ff ff ff       	jmp    6bc <malloc+0x2c>
