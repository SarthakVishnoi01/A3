
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
   e:	83 ec 10             	sub    $0x10,%esp
	// toggle();	// toggle the system trace on or off
	create_container(1);
  11:	6a 01                	push   $0x1
  13:	e8 7a 03 00 00       	call   392 <create_container>
  create_container(2);
  18:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1f:	e8 6e 03 00 00       	call   392 <create_container>
  create_container(3);
  24:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  2b:	e8 62 03 00 00       	call   392 <create_container>

  int cid1 = fork();
  30:	e8 b5 02 00 00       	call   2ea <fork>
  if(cid1 == 0){
  35:	83 c4 10             	add    $0x10,%esp
  38:	85 c0                	test   %eax,%eax
  3a:	75 19                	jne    55 <main+0x55>
    join_container(1);
  3c:	83 ec 0c             	sub    $0xc,%esp
  3f:	6a 01                	push   $0x1
  41:	e8 54 03 00 00       	call   39a <join_container>
    ps();
  46:	e8 67 03 00 00       	call   3b2 <ps>
    wait();
  4b:	e8 aa 02 00 00       	call   2fa <wait>
    // list_containers();
    exit();
  50:	e8 9d 02 00 00       	call   2f2 <exit>
  }
  sleep(2);
  55:	83 ec 0c             	sub    $0xc,%esp
  58:	6a 02                	push   $0x2
  5a:	e8 23 03 00 00       	call   382 <sleep>
  // destroy_container(1);
  list_containers();
  5f:	e8 56 03 00 00       	call   3ba <list_containers>

  int cid2 = fork();
  64:	e8 81 02 00 00       	call   2ea <fork>
  if(cid2 == 0){
  69:	83 c4 10             	add    $0x10,%esp
  6c:	85 c0                	test   %eax,%eax
  6e:	75 19                	jne    89 <main+0x89>
    join_container(2);
  70:	83 ec 0c             	sub    $0xc,%esp
  73:	6a 02                	push   $0x2
  75:	e8 20 03 00 00       	call   39a <join_container>
    wait();
  7a:	e8 7b 02 00 00       	call   2fa <wait>
    ps();
  7f:	e8 2e 03 00 00       	call   3b2 <ps>
    exit();
  84:	e8 69 02 00 00       	call   2f2 <exit>
  }

  sleep(2);
  89:	83 ec 0c             	sub    $0xc,%esp
  8c:	6a 02                	push   $0x2
  8e:	e8 ef 02 00 00       	call   382 <sleep>
  // list_containers();

  ps();
  93:	e8 1a 03 00 00       	call   3b2 <ps>
	wait();
  98:	e8 5d 02 00 00       	call   2fa <wait>
	exit();
  9d:	e8 50 02 00 00       	call   2f2 <exit>
  a2:	66 90                	xchg   %ax,%ax
  a4:	66 90                	xchg   %ax,%ax
  a6:	66 90                	xchg   %ax,%ax
  a8:	66 90                	xchg   %ax,%ax
  aa:	66 90                	xchg   %ax,%ax
  ac:	66 90                	xchg   %ax,%ax
  ae:	66 90                	xchg   %ax,%ax

000000b0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	53                   	push   %ebx
  b4:	8b 45 08             	mov    0x8(%ebp),%eax
  b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ba:	89 c2                	mov    %eax,%edx
  bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  c0:	83 c1 01             	add    $0x1,%ecx
  c3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  c7:	83 c2 01             	add    $0x1,%edx
  ca:	84 db                	test   %bl,%bl
  cc:	88 5a ff             	mov    %bl,-0x1(%edx)
  cf:	75 ef                	jne    c0 <strcpy+0x10>
    ;
  return os;
}
  d1:	5b                   	pop    %ebx
  d2:	5d                   	pop    %ebp
  d3:	c3                   	ret    
  d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000000e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	56                   	push   %esi
  e4:	53                   	push   %ebx
  e5:	8b 55 08             	mov    0x8(%ebp),%edx
  e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  eb:	0f b6 02             	movzbl (%edx),%eax
  ee:	0f b6 19             	movzbl (%ecx),%ebx
  f1:	84 c0                	test   %al,%al
  f3:	75 1e                	jne    113 <strcmp+0x33>
  f5:	eb 29                	jmp    120 <strcmp+0x40>
  f7:	89 f6                	mov    %esi,%esi
  f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 100:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 103:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 106:	8d 71 01             	lea    0x1(%ecx),%esi
  while(*p && *p == *q)
 109:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 10d:	84 c0                	test   %al,%al
 10f:	74 0f                	je     120 <strcmp+0x40>
 111:	89 f1                	mov    %esi,%ecx
 113:	38 d8                	cmp    %bl,%al
 115:	74 e9                	je     100 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 117:	29 d8                	sub    %ebx,%eax
}
 119:	5b                   	pop    %ebx
 11a:	5e                   	pop    %esi
 11b:	5d                   	pop    %ebp
 11c:	c3                   	ret    
 11d:	8d 76 00             	lea    0x0(%esi),%esi
  while(*p && *p == *q)
 120:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 122:	29 d8                	sub    %ebx,%eax
}
 124:	5b                   	pop    %ebx
 125:	5e                   	pop    %esi
 126:	5d                   	pop    %ebp
 127:	c3                   	ret    
 128:	90                   	nop
 129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000130 <strlen>:

uint
strlen(const char *s)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 136:	80 39 00             	cmpb   $0x0,(%ecx)
 139:	74 12                	je     14d <strlen+0x1d>
 13b:	31 d2                	xor    %edx,%edx
 13d:	8d 76 00             	lea    0x0(%esi),%esi
 140:	83 c2 01             	add    $0x1,%edx
 143:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 147:	89 d0                	mov    %edx,%eax
 149:	75 f5                	jne    140 <strlen+0x10>
    ;
  return n;
}
 14b:	5d                   	pop    %ebp
 14c:	c3                   	ret    
  for(n = 0; s[n]; n++)
 14d:	31 c0                	xor    %eax,%eax
}
 14f:	5d                   	pop    %ebp
 150:	c3                   	ret    
 151:	eb 0d                	jmp    160 <memset>
 153:	90                   	nop
 154:	90                   	nop
 155:	90                   	nop
 156:	90                   	nop
 157:	90                   	nop
 158:	90                   	nop
 159:	90                   	nop
 15a:	90                   	nop
 15b:	90                   	nop
 15c:	90                   	nop
 15d:	90                   	nop
 15e:	90                   	nop
 15f:	90                   	nop

00000160 <memset>:

void*
memset(void *dst, int c, uint n)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	57                   	push   %edi
 164:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 167:	8b 4d 10             	mov    0x10(%ebp),%ecx
 16a:	8b 45 0c             	mov    0xc(%ebp),%eax
 16d:	89 d7                	mov    %edx,%edi
 16f:	fc                   	cld    
 170:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 172:	89 d0                	mov    %edx,%eax
 174:	5f                   	pop    %edi
 175:	5d                   	pop    %ebp
 176:	c3                   	ret    
 177:	89 f6                	mov    %esi,%esi
 179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000180 <strchr>:

char*
strchr(const char *s, char c)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	53                   	push   %ebx
 184:	8b 45 08             	mov    0x8(%ebp),%eax
 187:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 18a:	0f b6 10             	movzbl (%eax),%edx
 18d:	84 d2                	test   %dl,%dl
 18f:	74 1d                	je     1ae <strchr+0x2e>
    if(*s == c)
 191:	38 d3                	cmp    %dl,%bl
 193:	89 d9                	mov    %ebx,%ecx
 195:	75 0d                	jne    1a4 <strchr+0x24>
 197:	eb 17                	jmp    1b0 <strchr+0x30>
 199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1a0:	38 ca                	cmp    %cl,%dl
 1a2:	74 0c                	je     1b0 <strchr+0x30>
  for(; *s; s++)
 1a4:	83 c0 01             	add    $0x1,%eax
 1a7:	0f b6 10             	movzbl (%eax),%edx
 1aa:	84 d2                	test   %dl,%dl
 1ac:	75 f2                	jne    1a0 <strchr+0x20>
      return (char*)s;
  return 0;
 1ae:	31 c0                	xor    %eax,%eax
}
 1b0:	5b                   	pop    %ebx
 1b1:	5d                   	pop    %ebp
 1b2:	c3                   	ret    
 1b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001c0 <gets>:

char*
gets(char *buf, int max)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	57                   	push   %edi
 1c4:	56                   	push   %esi
 1c5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c6:	31 f6                	xor    %esi,%esi
    cc = read(0, &c, 1);
 1c8:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 1cb:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 1ce:	eb 29                	jmp    1f9 <gets+0x39>
    cc = read(0, &c, 1);
 1d0:	83 ec 04             	sub    $0x4,%esp
 1d3:	6a 01                	push   $0x1
 1d5:	57                   	push   %edi
 1d6:	6a 00                	push   $0x0
 1d8:	e8 2d 01 00 00       	call   30a <read>
    if(cc < 1)
 1dd:	83 c4 10             	add    $0x10,%esp
 1e0:	85 c0                	test   %eax,%eax
 1e2:	7e 1d                	jle    201 <gets+0x41>
      break;
    buf[i++] = c;
 1e4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1e8:	8b 55 08             	mov    0x8(%ebp),%edx
 1eb:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 1ed:	3c 0a                	cmp    $0xa,%al
    buf[i++] = c;
 1ef:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1f3:	74 1b                	je     210 <gets+0x50>
 1f5:	3c 0d                	cmp    $0xd,%al
 1f7:	74 17                	je     210 <gets+0x50>
  for(i=0; i+1 < max; ){
 1f9:	8d 5e 01             	lea    0x1(%esi),%ebx
 1fc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1ff:	7c cf                	jl     1d0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 201:	8b 45 08             	mov    0x8(%ebp),%eax
 204:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 208:	8d 65 f4             	lea    -0xc(%ebp),%esp
 20b:	5b                   	pop    %ebx
 20c:	5e                   	pop    %esi
 20d:	5f                   	pop    %edi
 20e:	5d                   	pop    %ebp
 20f:	c3                   	ret    
  buf[i] = '\0';
 210:	8b 45 08             	mov    0x8(%ebp),%eax
  for(i=0; i+1 < max; ){
 213:	89 de                	mov    %ebx,%esi
  buf[i] = '\0';
 215:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 219:	8d 65 f4             	lea    -0xc(%ebp),%esp
 21c:	5b                   	pop    %ebx
 21d:	5e                   	pop    %esi
 21e:	5f                   	pop    %edi
 21f:	5d                   	pop    %ebp
 220:	c3                   	ret    
 221:	eb 0d                	jmp    230 <stat>
 223:	90                   	nop
 224:	90                   	nop
 225:	90                   	nop
 226:	90                   	nop
 227:	90                   	nop
 228:	90                   	nop
 229:	90                   	nop
 22a:	90                   	nop
 22b:	90                   	nop
 22c:	90                   	nop
 22d:	90                   	nop
 22e:	90                   	nop
 22f:	90                   	nop

00000230 <stat>:

int
stat(const char *n, struct stat *st)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	56                   	push   %esi
 234:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 235:	83 ec 08             	sub    $0x8,%esp
 238:	6a 00                	push   $0x0
 23a:	ff 75 08             	pushl  0x8(%ebp)
 23d:	e8 f0 00 00 00       	call   332 <open>
  if(fd < 0)
 242:	83 c4 10             	add    $0x10,%esp
 245:	85 c0                	test   %eax,%eax
 247:	78 27                	js     270 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 249:	83 ec 08             	sub    $0x8,%esp
 24c:	ff 75 0c             	pushl  0xc(%ebp)
 24f:	89 c3                	mov    %eax,%ebx
 251:	50                   	push   %eax
 252:	e8 f3 00 00 00       	call   34a <fstat>
  close(fd);
 257:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 25a:	89 c6                	mov    %eax,%esi
  close(fd);
 25c:	e8 b9 00 00 00       	call   31a <close>
  return r;
 261:	83 c4 10             	add    $0x10,%esp
}
 264:	8d 65 f8             	lea    -0x8(%ebp),%esp
 267:	89 f0                	mov    %esi,%eax
 269:	5b                   	pop    %ebx
 26a:	5e                   	pop    %esi
 26b:	5d                   	pop    %ebp
 26c:	c3                   	ret    
 26d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 270:	be ff ff ff ff       	mov    $0xffffffff,%esi
 275:	eb ed                	jmp    264 <stat+0x34>
 277:	89 f6                	mov    %esi,%esi
 279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000280 <atoi>:

int
atoi(const char *s)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	53                   	push   %ebx
 284:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 287:	0f be 11             	movsbl (%ecx),%edx
 28a:	8d 42 d0             	lea    -0x30(%edx),%eax
 28d:	3c 09                	cmp    $0x9,%al
 28f:	b8 00 00 00 00       	mov    $0x0,%eax
 294:	77 1f                	ja     2b5 <atoi+0x35>
 296:	8d 76 00             	lea    0x0(%esi),%esi
 299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 2a0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 2a3:	83 c1 01             	add    $0x1,%ecx
 2a6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 2aa:	0f be 11             	movsbl (%ecx),%edx
 2ad:	8d 5a d0             	lea    -0x30(%edx),%ebx
 2b0:	80 fb 09             	cmp    $0x9,%bl
 2b3:	76 eb                	jbe    2a0 <atoi+0x20>
  return n;
}
 2b5:	5b                   	pop    %ebx
 2b6:	5d                   	pop    %ebp
 2b7:	c3                   	ret    
 2b8:	90                   	nop
 2b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002c0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	56                   	push   %esi
 2c4:	53                   	push   %ebx
 2c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 2c8:	8b 45 08             	mov    0x8(%ebp),%eax
 2cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ce:	85 db                	test   %ebx,%ebx
 2d0:	7e 14                	jle    2e6 <memmove+0x26>
 2d2:	31 d2                	xor    %edx,%edx
 2d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 2d8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 2dc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2df:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 2e2:	39 da                	cmp    %ebx,%edx
 2e4:	75 f2                	jne    2d8 <memmove+0x18>
  return vdst;
}
 2e6:	5b                   	pop    %ebx
 2e7:	5e                   	pop    %esi
 2e8:	5d                   	pop    %ebp
 2e9:	c3                   	ret    

000002ea <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2ea:	b8 01 00 00 00       	mov    $0x1,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <exit>:
SYSCALL(exit)
 2f2:	b8 02 00 00 00       	mov    $0x2,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <wait>:
SYSCALL(wait)
 2fa:	b8 03 00 00 00       	mov    $0x3,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <pipe>:
SYSCALL(pipe)
 302:	b8 04 00 00 00       	mov    $0x4,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <read>:
SYSCALL(read)
 30a:	b8 05 00 00 00       	mov    $0x5,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <write>:
SYSCALL(write)
 312:	b8 10 00 00 00       	mov    $0x10,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <close>:
SYSCALL(close)
 31a:	b8 15 00 00 00       	mov    $0x15,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <kill>:
SYSCALL(kill)
 322:	b8 06 00 00 00       	mov    $0x6,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <exec>:
SYSCALL(exec)
 32a:	b8 07 00 00 00       	mov    $0x7,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <open>:
SYSCALL(open)
 332:	b8 0f 00 00 00       	mov    $0xf,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <mknod>:
SYSCALL(mknod)
 33a:	b8 11 00 00 00       	mov    $0x11,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <unlink>:
SYSCALL(unlink)
 342:	b8 12 00 00 00       	mov    $0x12,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <fstat>:
SYSCALL(fstat)
 34a:	b8 08 00 00 00       	mov    $0x8,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <link>:
SYSCALL(link)
 352:	b8 13 00 00 00       	mov    $0x13,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <mkdir>:
SYSCALL(mkdir)
 35a:	b8 14 00 00 00       	mov    $0x14,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <chdir>:
SYSCALL(chdir)
 362:	b8 09 00 00 00       	mov    $0x9,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <dup>:
SYSCALL(dup)
 36a:	b8 0a 00 00 00       	mov    $0xa,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <getpid>:
SYSCALL(getpid)
 372:	b8 0b 00 00 00       	mov    $0xb,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <sbrk>:
SYSCALL(sbrk)
 37a:	b8 0c 00 00 00       	mov    $0xc,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <sleep>:
SYSCALL(sleep)
 382:	b8 0d 00 00 00       	mov    $0xd,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <uptime>:
SYSCALL(uptime)
 38a:	b8 0e 00 00 00       	mov    $0xe,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <create_container>:
SYSCALL(create_container)
 392:	b8 16 00 00 00       	mov    $0x16,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <join_container>:
SYSCALL(join_container)
 39a:	b8 17 00 00 00       	mov    $0x17,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <leave_container>:
SYSCALL(leave_container)
 3a2:	b8 18 00 00 00       	mov    $0x18,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <destroy_container>:
SYSCALL(destroy_container)
 3aa:	b8 19 00 00 00       	mov    $0x19,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <ps>:
SYSCALL(ps)
 3b2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <list_containers>:
SYSCALL(list_containers)
 3ba:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    
 3c2:	66 90                	xchg   %ax,%ax
 3c4:	66 90                	xchg   %ax,%ax
 3c6:	66 90                	xchg   %ax,%ax
 3c8:	66 90                	xchg   %ax,%ax
 3ca:	66 90                	xchg   %ax,%ax
 3cc:	66 90                	xchg   %ax,%ax
 3ce:	66 90                	xchg   %ax,%ax

000003d0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	57                   	push   %edi
 3d4:	56                   	push   %esi
 3d5:	53                   	push   %ebx
 3d6:	89 c6                	mov    %eax,%esi
 3d8:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3db:	8b 5d 08             	mov    0x8(%ebp),%ebx
 3de:	85 db                	test   %ebx,%ebx
 3e0:	74 7e                	je     460 <printint+0x90>
 3e2:	89 d0                	mov    %edx,%eax
 3e4:	c1 e8 1f             	shr    $0x1f,%eax
 3e7:	84 c0                	test   %al,%al
 3e9:	74 75                	je     460 <printint+0x90>
    neg = 1;
    x = -xx;
 3eb:	89 d0                	mov    %edx,%eax
    neg = 1;
 3ed:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    x = -xx;
 3f4:	f7 d8                	neg    %eax
 3f6:	89 75 c0             	mov    %esi,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3f9:	31 ff                	xor    %edi,%edi
 3fb:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 3fe:	89 ce                	mov    %ecx,%esi
 400:	eb 08                	jmp    40a <printint+0x3a>
 402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 408:	89 cf                	mov    %ecx,%edi
 40a:	31 d2                	xor    %edx,%edx
 40c:	8d 4f 01             	lea    0x1(%edi),%ecx
 40f:	f7 f6                	div    %esi
 411:	0f b6 92 98 07 00 00 	movzbl 0x798(%edx),%edx
  }while((x /= base) != 0);
 418:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 41a:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 41d:	75 e9                	jne    408 <printint+0x38>
  if(neg)
 41f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 422:	8b 75 c0             	mov    -0x40(%ebp),%esi
 425:	85 c0                	test   %eax,%eax
 427:	74 08                	je     431 <printint+0x61>
    buf[i++] = '-';
 429:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 42e:	8d 4f 02             	lea    0x2(%edi),%ecx

  while(--i >= 0)
 431:	8d 79 ff             	lea    -0x1(%ecx),%edi
 434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 438:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
  write(fd, &c, 1);
 43d:	83 ec 04             	sub    $0x4,%esp
  while(--i >= 0)
 440:	83 ef 01             	sub    $0x1,%edi
  write(fd, &c, 1);
 443:	6a 01                	push   $0x1
 445:	53                   	push   %ebx
 446:	56                   	push   %esi
 447:	88 45 d7             	mov    %al,-0x29(%ebp)
 44a:	e8 c3 fe ff ff       	call   312 <write>
  while(--i >= 0)
 44f:	83 c4 10             	add    $0x10,%esp
 452:	83 ff ff             	cmp    $0xffffffff,%edi
 455:	75 e1                	jne    438 <printint+0x68>
    putc(fd, buf[i]);
}
 457:	8d 65 f4             	lea    -0xc(%ebp),%esp
 45a:	5b                   	pop    %ebx
 45b:	5e                   	pop    %esi
 45c:	5f                   	pop    %edi
 45d:	5d                   	pop    %ebp
 45e:	c3                   	ret    
 45f:	90                   	nop
    x = xx;
 460:	89 d0                	mov    %edx,%eax
  neg = 0;
 462:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 469:	eb 8b                	jmp    3f6 <printint+0x26>
 46b:	90                   	nop
 46c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000470 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	57                   	push   %edi
 474:	56                   	push   %esi
 475:	53                   	push   %ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 476:	8d 45 10             	lea    0x10(%ebp),%eax
{
 479:	83 ec 2c             	sub    $0x2c,%esp
  for(i = 0; fmt[i]; i++){
 47c:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 47f:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 482:	89 45 d0             	mov    %eax,-0x30(%ebp)
 485:	0f b6 1e             	movzbl (%esi),%ebx
 488:	83 c6 01             	add    $0x1,%esi
 48b:	84 db                	test   %bl,%bl
 48d:	0f 84 b0 00 00 00    	je     543 <printf+0xd3>
 493:	31 d2                	xor    %edx,%edx
 495:	eb 39                	jmp    4d0 <printf+0x60>
 497:	89 f6                	mov    %esi,%esi
 499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4a0:	83 f8 25             	cmp    $0x25,%eax
 4a3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 4a6:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 4ab:	74 18                	je     4c5 <printf+0x55>
  write(fd, &c, 1);
 4ad:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 4b0:	83 ec 04             	sub    $0x4,%esp
 4b3:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 4b6:	6a 01                	push   $0x1
 4b8:	50                   	push   %eax
 4b9:	57                   	push   %edi
 4ba:	e8 53 fe ff ff       	call   312 <write>
 4bf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 4c2:	83 c4 10             	add    $0x10,%esp
 4c5:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 4c8:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 4cc:	84 db                	test   %bl,%bl
 4ce:	74 73                	je     543 <printf+0xd3>
    if(state == 0){
 4d0:	85 d2                	test   %edx,%edx
    c = fmt[i] & 0xff;
 4d2:	0f be cb             	movsbl %bl,%ecx
 4d5:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 4d8:	74 c6                	je     4a0 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4da:	83 fa 25             	cmp    $0x25,%edx
 4dd:	75 e6                	jne    4c5 <printf+0x55>
      if(c == 'd'){
 4df:	83 f8 64             	cmp    $0x64,%eax
 4e2:	0f 84 f8 00 00 00    	je     5e0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4e8:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 4ee:	83 f9 70             	cmp    $0x70,%ecx
 4f1:	74 5d                	je     550 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4f3:	83 f8 73             	cmp    $0x73,%eax
 4f6:	0f 84 84 00 00 00    	je     580 <printf+0x110>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4fc:	83 f8 63             	cmp    $0x63,%eax
 4ff:	0f 84 ea 00 00 00    	je     5ef <printf+0x17f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 505:	83 f8 25             	cmp    $0x25,%eax
 508:	0f 84 c2 00 00 00    	je     5d0 <printf+0x160>
  write(fd, &c, 1);
 50e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 511:	83 ec 04             	sub    $0x4,%esp
 514:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 518:	6a 01                	push   $0x1
 51a:	50                   	push   %eax
 51b:	57                   	push   %edi
 51c:	e8 f1 fd ff ff       	call   312 <write>
 521:	83 c4 0c             	add    $0xc,%esp
 524:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 527:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 52a:	6a 01                	push   $0x1
 52c:	50                   	push   %eax
 52d:	57                   	push   %edi
 52e:	83 c6 01             	add    $0x1,%esi
 531:	e8 dc fd ff ff       	call   312 <write>
  for(i = 0; fmt[i]; i++){
 536:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 53a:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 53d:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 53f:	84 db                	test   %bl,%bl
 541:	75 8d                	jne    4d0 <printf+0x60>
    }
  }
}
 543:	8d 65 f4             	lea    -0xc(%ebp),%esp
 546:	5b                   	pop    %ebx
 547:	5e                   	pop    %esi
 548:	5f                   	pop    %edi
 549:	5d                   	pop    %ebp
 54a:	c3                   	ret    
 54b:	90                   	nop
 54c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 16, 0);
 550:	83 ec 0c             	sub    $0xc,%esp
 553:	b9 10 00 00 00       	mov    $0x10,%ecx
 558:	6a 00                	push   $0x0
 55a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 55d:	89 f8                	mov    %edi,%eax
 55f:	8b 13                	mov    (%ebx),%edx
 561:	e8 6a fe ff ff       	call   3d0 <printint>
        ap++;
 566:	89 d8                	mov    %ebx,%eax
 568:	83 c4 10             	add    $0x10,%esp
      state = 0;
 56b:	31 d2                	xor    %edx,%edx
        ap++;
 56d:	83 c0 04             	add    $0x4,%eax
 570:	89 45 d0             	mov    %eax,-0x30(%ebp)
 573:	e9 4d ff ff ff       	jmp    4c5 <printf+0x55>
 578:	90                   	nop
 579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 580:	8b 45 d0             	mov    -0x30(%ebp),%eax
 583:	8b 18                	mov    (%eax),%ebx
        ap++;
 585:	83 c0 04             	add    $0x4,%eax
 588:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 58b:	85 db                	test   %ebx,%ebx
 58d:	74 7c                	je     60b <printf+0x19b>
        while(*s != 0){
 58f:	0f b6 03             	movzbl (%ebx),%eax
 592:	84 c0                	test   %al,%al
 594:	74 29                	je     5bf <printf+0x14f>
 596:	8d 76 00             	lea    0x0(%esi),%esi
 599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 5a0:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 5a3:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 5a6:	83 ec 04             	sub    $0x4,%esp
 5a9:	6a 01                	push   $0x1
          s++;
 5ab:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 5ae:	50                   	push   %eax
 5af:	57                   	push   %edi
 5b0:	e8 5d fd ff ff       	call   312 <write>
        while(*s != 0){
 5b5:	0f b6 03             	movzbl (%ebx),%eax
 5b8:	83 c4 10             	add    $0x10,%esp
 5bb:	84 c0                	test   %al,%al
 5bd:	75 e1                	jne    5a0 <printf+0x130>
      state = 0;
 5bf:	31 d2                	xor    %edx,%edx
 5c1:	e9 ff fe ff ff       	jmp    4c5 <printf+0x55>
 5c6:	8d 76 00             	lea    0x0(%esi),%esi
 5c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  write(fd, &c, 1);
 5d0:	83 ec 04             	sub    $0x4,%esp
 5d3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 5d6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 5d9:	6a 01                	push   $0x1
 5db:	e9 4c ff ff ff       	jmp    52c <printf+0xbc>
        printint(fd, *ap, 10, 1);
 5e0:	83 ec 0c             	sub    $0xc,%esp
 5e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5e8:	6a 01                	push   $0x1
 5ea:	e9 6b ff ff ff       	jmp    55a <printf+0xea>
        putc(fd, *ap);
 5ef:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 5f2:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 5f5:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 5f7:	6a 01                	push   $0x1
        putc(fd, *ap);
 5f9:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 5fc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 5ff:	50                   	push   %eax
 600:	57                   	push   %edi
 601:	e8 0c fd ff ff       	call   312 <write>
 606:	e9 5b ff ff ff       	jmp    566 <printf+0xf6>
        while(*s != 0){
 60b:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 610:	bb 90 07 00 00       	mov    $0x790,%ebx
 615:	eb 89                	jmp    5a0 <printf+0x130>
 617:	66 90                	xchg   %ax,%ax
 619:	66 90                	xchg   %ax,%ax
 61b:	66 90                	xchg   %ax,%ax
 61d:	66 90                	xchg   %ax,%ax
 61f:	90                   	nop

00000620 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 620:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 621:	a1 30 0a 00 00       	mov    0xa30,%eax
{
 626:	89 e5                	mov    %esp,%ebp
 628:	57                   	push   %edi
 629:	56                   	push   %esi
 62a:	53                   	push   %ebx
 62b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 62e:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 630:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 633:	39 c8                	cmp    %ecx,%eax
 635:	73 19                	jae    650 <free+0x30>
 637:	89 f6                	mov    %esi,%esi
 639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 640:	39 d1                	cmp    %edx,%ecx
 642:	72 1c                	jb     660 <free+0x40>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 644:	39 d0                	cmp    %edx,%eax
 646:	73 18                	jae    660 <free+0x40>
{
 648:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 64a:	39 c8                	cmp    %ecx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 64c:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 64e:	72 f0                	jb     640 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 650:	39 d0                	cmp    %edx,%eax
 652:	72 f4                	jb     648 <free+0x28>
 654:	39 d1                	cmp    %edx,%ecx
 656:	73 f0                	jae    648 <free+0x28>
 658:	90                   	nop
 659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
  if(bp + bp->s.size == p->s.ptr){
 660:	8b 73 fc             	mov    -0x4(%ebx),%esi
 663:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 666:	39 fa                	cmp    %edi,%edx
 668:	74 19                	je     683 <free+0x63>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 66a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 66d:	8b 50 04             	mov    0x4(%eax),%edx
 670:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 673:	39 f1                	cmp    %esi,%ecx
 675:	74 23                	je     69a <free+0x7a>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 677:	89 08                	mov    %ecx,(%eax)
  freep = p;
 679:	a3 30 0a 00 00       	mov    %eax,0xa30
}
 67e:	5b                   	pop    %ebx
 67f:	5e                   	pop    %esi
 680:	5f                   	pop    %edi
 681:	5d                   	pop    %ebp
 682:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 683:	03 72 04             	add    0x4(%edx),%esi
 686:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 689:	8b 10                	mov    (%eax),%edx
 68b:	8b 12                	mov    (%edx),%edx
 68d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 690:	8b 50 04             	mov    0x4(%eax),%edx
 693:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 696:	39 f1                	cmp    %esi,%ecx
 698:	75 dd                	jne    677 <free+0x57>
    p->s.size += bp->s.size;
 69a:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 69d:	a3 30 0a 00 00       	mov    %eax,0xa30
    p->s.size += bp->s.size;
 6a2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6a5:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6a8:	89 10                	mov    %edx,(%eax)
}
 6aa:	5b                   	pop    %ebx
 6ab:	5e                   	pop    %esi
 6ac:	5f                   	pop    %edi
 6ad:	5d                   	pop    %ebp
 6ae:	c3                   	ret    
 6af:	90                   	nop

000006b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6b0:	55                   	push   %ebp
 6b1:	89 e5                	mov    %esp,%ebp
 6b3:	57                   	push   %edi
 6b4:	56                   	push   %esi
 6b5:	53                   	push   %ebx
 6b6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6b9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6bc:	8b 15 30 0a 00 00    	mov    0xa30,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6c2:	8d 78 07             	lea    0x7(%eax),%edi
 6c5:	c1 ef 03             	shr    $0x3,%edi
 6c8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 6cb:	85 d2                	test   %edx,%edx
 6cd:	0f 84 93 00 00 00    	je     766 <malloc+0xb6>
 6d3:	8b 02                	mov    (%edx),%eax
 6d5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 6d8:	39 cf                	cmp    %ecx,%edi
 6da:	76 64                	jbe    740 <malloc+0x90>
 6dc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 6e2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6e7:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 6ea:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 6f1:	eb 0e                	jmp    701 <malloc+0x51>
 6f3:	90                   	nop
 6f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6f8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6fa:	8b 48 04             	mov    0x4(%eax),%ecx
 6fd:	39 cf                	cmp    %ecx,%edi
 6ff:	76 3f                	jbe    740 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 701:	39 05 30 0a 00 00    	cmp    %eax,0xa30
 707:	89 c2                	mov    %eax,%edx
 709:	75 ed                	jne    6f8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 70b:	83 ec 0c             	sub    $0xc,%esp
 70e:	56                   	push   %esi
 70f:	e8 66 fc ff ff       	call   37a <sbrk>
  if(p == (char*)-1)
 714:	83 c4 10             	add    $0x10,%esp
 717:	83 f8 ff             	cmp    $0xffffffff,%eax
 71a:	74 1c                	je     738 <malloc+0x88>
  hp->s.size = nu;
 71c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 71f:	83 ec 0c             	sub    $0xc,%esp
 722:	83 c0 08             	add    $0x8,%eax
 725:	50                   	push   %eax
 726:	e8 f5 fe ff ff       	call   620 <free>
  return freep;
 72b:	8b 15 30 0a 00 00    	mov    0xa30,%edx
      if((p = morecore(nunits)) == 0)
 731:	83 c4 10             	add    $0x10,%esp
 734:	85 d2                	test   %edx,%edx
 736:	75 c0                	jne    6f8 <malloc+0x48>
        return 0;
 738:	31 c0                	xor    %eax,%eax
 73a:	eb 1c                	jmp    758 <malloc+0xa8>
 73c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 740:	39 cf                	cmp    %ecx,%edi
 742:	74 1c                	je     760 <malloc+0xb0>
        p->s.size -= nunits;
 744:	29 f9                	sub    %edi,%ecx
 746:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 749:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 74c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 74f:	89 15 30 0a 00 00    	mov    %edx,0xa30
      return (void*)(p + 1);
 755:	83 c0 08             	add    $0x8,%eax
  }
}
 758:	8d 65 f4             	lea    -0xc(%ebp),%esp
 75b:	5b                   	pop    %ebx
 75c:	5e                   	pop    %esi
 75d:	5f                   	pop    %edi
 75e:	5d                   	pop    %ebp
 75f:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 760:	8b 08                	mov    (%eax),%ecx
 762:	89 0a                	mov    %ecx,(%edx)
 764:	eb e9                	jmp    74f <malloc+0x9f>
    base.s.ptr = freep = prevp = &base;
 766:	c7 05 30 0a 00 00 34 	movl   $0xa34,0xa30
 76d:	0a 00 00 
 770:	c7 05 34 0a 00 00 34 	movl   $0xa34,0xa34
 777:	0a 00 00 
    base.s.size = 0;
 77a:	b8 34 0a 00 00       	mov    $0xa34,%eax
 77f:	c7 05 38 0a 00 00 00 	movl   $0x0,0xa38
 786:	00 00 00 
 789:	e9 4e ff ff ff       	jmp    6dc <malloc+0x2c>
