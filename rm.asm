
_rm:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	bf 01 00 00 00       	mov    $0x1,%edi
  16:	83 ec 08             	sub    $0x8,%esp
  19:	8b 31                	mov    (%ecx),%esi
  1b:	8b 59 04             	mov    0x4(%ecx),%ebx
  1e:	83 c3 04             	add    $0x4,%ebx
  int i;

  if(argc < 2){
  21:	83 fe 01             	cmp    $0x1,%esi
  24:	7e 3e                	jle    64 <main+0x64>
  26:	8d 76 00             	lea    0x0(%esi),%esi
  29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    printf(2, "Usage: rm files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
    if(unlink(argv[i]) < 0){
  30:	83 ec 0c             	sub    $0xc,%esp
  33:	ff 33                	pushl  (%ebx)
  35:	e8 d8 02 00 00       	call   312 <unlink>
  3a:	83 c4 10             	add    $0x10,%esp
  3d:	85 c0                	test   %eax,%eax
  3f:	78 0f                	js     50 <main+0x50>
  for(i = 1; i < argc; i++){
  41:	83 c7 01             	add    $0x1,%edi
  44:	83 c3 04             	add    $0x4,%ebx
  47:	39 fe                	cmp    %edi,%esi
  49:	75 e5                	jne    30 <main+0x30>
      printf(2, "rm: %s failed to delete\n", argv[i]);
      break;
    }
  }

  exit();
  4b:	e8 72 02 00 00       	call   2c2 <exit>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  50:	50                   	push   %eax
  51:	ff 33                	pushl  (%ebx)
  53:	68 74 07 00 00       	push   $0x774
  58:	6a 02                	push   $0x2
  5a:	e8 e1 03 00 00       	call   440 <printf>
      break;
  5f:	83 c4 10             	add    $0x10,%esp
  62:	eb e7                	jmp    4b <main+0x4b>
    printf(2, "Usage: rm files...\n");
  64:	52                   	push   %edx
  65:	52                   	push   %edx
  66:	68 60 07 00 00       	push   $0x760
  6b:	6a 02                	push   $0x2
  6d:	e8 ce 03 00 00       	call   440 <printf>
    exit();
  72:	e8 4b 02 00 00       	call   2c2 <exit>
  77:	66 90                	xchg   %ax,%ax
  79:	66 90                	xchg   %ax,%ax
  7b:	66 90                	xchg   %ax,%ax
  7d:	66 90                	xchg   %ax,%ax
  7f:	90                   	nop

00000080 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  80:	55                   	push   %ebp
  81:	89 e5                	mov    %esp,%ebp
  83:	53                   	push   %ebx
  84:	8b 45 08             	mov    0x8(%ebp),%eax
  87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  8a:	89 c2                	mov    %eax,%edx
  8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  90:	83 c1 01             	add    $0x1,%ecx
  93:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  97:	83 c2 01             	add    $0x1,%edx
  9a:	84 db                	test   %bl,%bl
  9c:	88 5a ff             	mov    %bl,-0x1(%edx)
  9f:	75 ef                	jne    90 <strcpy+0x10>
    ;
  return os;
}
  a1:	5b                   	pop    %ebx
  a2:	5d                   	pop    %ebp
  a3:	c3                   	ret    
  a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000000b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	56                   	push   %esi
  b4:	53                   	push   %ebx
  b5:	8b 55 08             	mov    0x8(%ebp),%edx
  b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  bb:	0f b6 02             	movzbl (%edx),%eax
  be:	0f b6 19             	movzbl (%ecx),%ebx
  c1:	84 c0                	test   %al,%al
  c3:	75 1e                	jne    e3 <strcmp+0x33>
  c5:	eb 29                	jmp    f0 <strcmp+0x40>
  c7:	89 f6                	mov    %esi,%esi
  c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
  d0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  d3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
  d6:	8d 71 01             	lea    0x1(%ecx),%esi
  while(*p && *p == *q)
  d9:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
  dd:	84 c0                	test   %al,%al
  df:	74 0f                	je     f0 <strcmp+0x40>
  e1:	89 f1                	mov    %esi,%ecx
  e3:	38 d8                	cmp    %bl,%al
  e5:	74 e9                	je     d0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
  e7:	29 d8                	sub    %ebx,%eax
}
  e9:	5b                   	pop    %ebx
  ea:	5e                   	pop    %esi
  eb:	5d                   	pop    %ebp
  ec:	c3                   	ret    
  ed:	8d 76 00             	lea    0x0(%esi),%esi
  while(*p && *p == *q)
  f0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  f2:	29 d8                	sub    %ebx,%eax
}
  f4:	5b                   	pop    %ebx
  f5:	5e                   	pop    %esi
  f6:	5d                   	pop    %ebp
  f7:	c3                   	ret    
  f8:	90                   	nop
  f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000100 <strlen>:

uint
strlen(const char *s)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 106:	80 39 00             	cmpb   $0x0,(%ecx)
 109:	74 12                	je     11d <strlen+0x1d>
 10b:	31 d2                	xor    %edx,%edx
 10d:	8d 76 00             	lea    0x0(%esi),%esi
 110:	83 c2 01             	add    $0x1,%edx
 113:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 117:	89 d0                	mov    %edx,%eax
 119:	75 f5                	jne    110 <strlen+0x10>
    ;
  return n;
}
 11b:	5d                   	pop    %ebp
 11c:	c3                   	ret    
  for(n = 0; s[n]; n++)
 11d:	31 c0                	xor    %eax,%eax
}
 11f:	5d                   	pop    %ebp
 120:	c3                   	ret    
 121:	eb 0d                	jmp    130 <memset>
 123:	90                   	nop
 124:	90                   	nop
 125:	90                   	nop
 126:	90                   	nop
 127:	90                   	nop
 128:	90                   	nop
 129:	90                   	nop
 12a:	90                   	nop
 12b:	90                   	nop
 12c:	90                   	nop
 12d:	90                   	nop
 12e:	90                   	nop
 12f:	90                   	nop

00000130 <memset>:

void*
memset(void *dst, int c, uint n)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	57                   	push   %edi
 134:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 137:	8b 4d 10             	mov    0x10(%ebp),%ecx
 13a:	8b 45 0c             	mov    0xc(%ebp),%eax
 13d:	89 d7                	mov    %edx,%edi
 13f:	fc                   	cld    
 140:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 142:	89 d0                	mov    %edx,%eax
 144:	5f                   	pop    %edi
 145:	5d                   	pop    %ebp
 146:	c3                   	ret    
 147:	89 f6                	mov    %esi,%esi
 149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000150 <strchr>:

char*
strchr(const char *s, char c)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	53                   	push   %ebx
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 15a:	0f b6 10             	movzbl (%eax),%edx
 15d:	84 d2                	test   %dl,%dl
 15f:	74 1d                	je     17e <strchr+0x2e>
    if(*s == c)
 161:	38 d3                	cmp    %dl,%bl
 163:	89 d9                	mov    %ebx,%ecx
 165:	75 0d                	jne    174 <strchr+0x24>
 167:	eb 17                	jmp    180 <strchr+0x30>
 169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 170:	38 ca                	cmp    %cl,%dl
 172:	74 0c                	je     180 <strchr+0x30>
  for(; *s; s++)
 174:	83 c0 01             	add    $0x1,%eax
 177:	0f b6 10             	movzbl (%eax),%edx
 17a:	84 d2                	test   %dl,%dl
 17c:	75 f2                	jne    170 <strchr+0x20>
      return (char*)s;
  return 0;
 17e:	31 c0                	xor    %eax,%eax
}
 180:	5b                   	pop    %ebx
 181:	5d                   	pop    %ebp
 182:	c3                   	ret    
 183:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000190 <gets>:

char*
gets(char *buf, int max)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	57                   	push   %edi
 194:	56                   	push   %esi
 195:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 196:	31 f6                	xor    %esi,%esi
    cc = read(0, &c, 1);
 198:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 19b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 19e:	eb 29                	jmp    1c9 <gets+0x39>
    cc = read(0, &c, 1);
 1a0:	83 ec 04             	sub    $0x4,%esp
 1a3:	6a 01                	push   $0x1
 1a5:	57                   	push   %edi
 1a6:	6a 00                	push   $0x0
 1a8:	e8 2d 01 00 00       	call   2da <read>
    if(cc < 1)
 1ad:	83 c4 10             	add    $0x10,%esp
 1b0:	85 c0                	test   %eax,%eax
 1b2:	7e 1d                	jle    1d1 <gets+0x41>
      break;
    buf[i++] = c;
 1b4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1b8:	8b 55 08             	mov    0x8(%ebp),%edx
 1bb:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 1bd:	3c 0a                	cmp    $0xa,%al
    buf[i++] = c;
 1bf:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1c3:	74 1b                	je     1e0 <gets+0x50>
 1c5:	3c 0d                	cmp    $0xd,%al
 1c7:	74 17                	je     1e0 <gets+0x50>
  for(i=0; i+1 < max; ){
 1c9:	8d 5e 01             	lea    0x1(%esi),%ebx
 1cc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1cf:	7c cf                	jl     1a0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 1d1:	8b 45 08             	mov    0x8(%ebp),%eax
 1d4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 1d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1db:	5b                   	pop    %ebx
 1dc:	5e                   	pop    %esi
 1dd:	5f                   	pop    %edi
 1de:	5d                   	pop    %ebp
 1df:	c3                   	ret    
  buf[i] = '\0';
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
  for(i=0; i+1 < max; ){
 1e3:	89 de                	mov    %ebx,%esi
  buf[i] = '\0';
 1e5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 1e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1ec:	5b                   	pop    %ebx
 1ed:	5e                   	pop    %esi
 1ee:	5f                   	pop    %edi
 1ef:	5d                   	pop    %ebp
 1f0:	c3                   	ret    
 1f1:	eb 0d                	jmp    200 <stat>
 1f3:	90                   	nop
 1f4:	90                   	nop
 1f5:	90                   	nop
 1f6:	90                   	nop
 1f7:	90                   	nop
 1f8:	90                   	nop
 1f9:	90                   	nop
 1fa:	90                   	nop
 1fb:	90                   	nop
 1fc:	90                   	nop
 1fd:	90                   	nop
 1fe:	90                   	nop
 1ff:	90                   	nop

00000200 <stat>:

int
stat(const char *n, struct stat *st)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	56                   	push   %esi
 204:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 205:	83 ec 08             	sub    $0x8,%esp
 208:	6a 00                	push   $0x0
 20a:	ff 75 08             	pushl  0x8(%ebp)
 20d:	e8 f0 00 00 00       	call   302 <open>
  if(fd < 0)
 212:	83 c4 10             	add    $0x10,%esp
 215:	85 c0                	test   %eax,%eax
 217:	78 27                	js     240 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 219:	83 ec 08             	sub    $0x8,%esp
 21c:	ff 75 0c             	pushl  0xc(%ebp)
 21f:	89 c3                	mov    %eax,%ebx
 221:	50                   	push   %eax
 222:	e8 f3 00 00 00       	call   31a <fstat>
  close(fd);
 227:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 22a:	89 c6                	mov    %eax,%esi
  close(fd);
 22c:	e8 b9 00 00 00       	call   2ea <close>
  return r;
 231:	83 c4 10             	add    $0x10,%esp
}
 234:	8d 65 f8             	lea    -0x8(%ebp),%esp
 237:	89 f0                	mov    %esi,%eax
 239:	5b                   	pop    %ebx
 23a:	5e                   	pop    %esi
 23b:	5d                   	pop    %ebp
 23c:	c3                   	ret    
 23d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 240:	be ff ff ff ff       	mov    $0xffffffff,%esi
 245:	eb ed                	jmp    234 <stat+0x34>
 247:	89 f6                	mov    %esi,%esi
 249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000250 <atoi>:

int
atoi(const char *s)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	53                   	push   %ebx
 254:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 257:	0f be 11             	movsbl (%ecx),%edx
 25a:	8d 42 d0             	lea    -0x30(%edx),%eax
 25d:	3c 09                	cmp    $0x9,%al
 25f:	b8 00 00 00 00       	mov    $0x0,%eax
 264:	77 1f                	ja     285 <atoi+0x35>
 266:	8d 76 00             	lea    0x0(%esi),%esi
 269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 270:	8d 04 80             	lea    (%eax,%eax,4),%eax
 273:	83 c1 01             	add    $0x1,%ecx
 276:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 27a:	0f be 11             	movsbl (%ecx),%edx
 27d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 280:	80 fb 09             	cmp    $0x9,%bl
 283:	76 eb                	jbe    270 <atoi+0x20>
  return n;
}
 285:	5b                   	pop    %ebx
 286:	5d                   	pop    %ebp
 287:	c3                   	ret    
 288:	90                   	nop
 289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000290 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	56                   	push   %esi
 294:	53                   	push   %ebx
 295:	8b 5d 10             	mov    0x10(%ebp),%ebx
 298:	8b 45 08             	mov    0x8(%ebp),%eax
 29b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 29e:	85 db                	test   %ebx,%ebx
 2a0:	7e 14                	jle    2b6 <memmove+0x26>
 2a2:	31 d2                	xor    %edx,%edx
 2a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 2a8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 2ac:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2af:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 2b2:	39 da                	cmp    %ebx,%edx
 2b4:	75 f2                	jne    2a8 <memmove+0x18>
  return vdst;
}
 2b6:	5b                   	pop    %ebx
 2b7:	5e                   	pop    %esi
 2b8:	5d                   	pop    %ebp
 2b9:	c3                   	ret    

000002ba <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2ba:	b8 01 00 00 00       	mov    $0x1,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <exit>:
SYSCALL(exit)
 2c2:	b8 02 00 00 00       	mov    $0x2,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <wait>:
SYSCALL(wait)
 2ca:	b8 03 00 00 00       	mov    $0x3,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <pipe>:
SYSCALL(pipe)
 2d2:	b8 04 00 00 00       	mov    $0x4,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <read>:
SYSCALL(read)
 2da:	b8 05 00 00 00       	mov    $0x5,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <write>:
SYSCALL(write)
 2e2:	b8 10 00 00 00       	mov    $0x10,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <close>:
SYSCALL(close)
 2ea:	b8 15 00 00 00       	mov    $0x15,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <kill>:
SYSCALL(kill)
 2f2:	b8 06 00 00 00       	mov    $0x6,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <exec>:
SYSCALL(exec)
 2fa:	b8 07 00 00 00       	mov    $0x7,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <open>:
SYSCALL(open)
 302:	b8 0f 00 00 00       	mov    $0xf,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <mknod>:
SYSCALL(mknod)
 30a:	b8 11 00 00 00       	mov    $0x11,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <unlink>:
SYSCALL(unlink)
 312:	b8 12 00 00 00       	mov    $0x12,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <fstat>:
SYSCALL(fstat)
 31a:	b8 08 00 00 00       	mov    $0x8,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <link>:
SYSCALL(link)
 322:	b8 13 00 00 00       	mov    $0x13,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <mkdir>:
SYSCALL(mkdir)
 32a:	b8 14 00 00 00       	mov    $0x14,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <chdir>:
SYSCALL(chdir)
 332:	b8 09 00 00 00       	mov    $0x9,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <dup>:
SYSCALL(dup)
 33a:	b8 0a 00 00 00       	mov    $0xa,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <getpid>:
SYSCALL(getpid)
 342:	b8 0b 00 00 00       	mov    $0xb,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <sbrk>:
SYSCALL(sbrk)
 34a:	b8 0c 00 00 00       	mov    $0xc,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <sleep>:
SYSCALL(sleep)
 352:	b8 0d 00 00 00       	mov    $0xd,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <uptime>:
SYSCALL(uptime)
 35a:	b8 0e 00 00 00       	mov    $0xe,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <create_container>:
SYSCALL(create_container)
 362:	b8 16 00 00 00       	mov    $0x16,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <join_container>:
SYSCALL(join_container)
 36a:	b8 17 00 00 00       	mov    $0x17,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <leave_container>:
SYSCALL(leave_container)
 372:	b8 18 00 00 00       	mov    $0x18,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <destroy_container>:
SYSCALL(destroy_container)
 37a:	b8 19 00 00 00       	mov    $0x19,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <ps>:
SYSCALL(ps)
 382:	b8 1a 00 00 00       	mov    $0x1a,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <list_containers>:
SYSCALL(list_containers)
 38a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    
 392:	66 90                	xchg   %ax,%ax
 394:	66 90                	xchg   %ax,%ax
 396:	66 90                	xchg   %ax,%ax
 398:	66 90                	xchg   %ax,%ax
 39a:	66 90                	xchg   %ax,%ax
 39c:	66 90                	xchg   %ax,%ax
 39e:	66 90                	xchg   %ax,%ax

000003a0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	57                   	push   %edi
 3a4:	56                   	push   %esi
 3a5:	53                   	push   %ebx
 3a6:	89 c6                	mov    %eax,%esi
 3a8:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
 3ae:	85 db                	test   %ebx,%ebx
 3b0:	74 7e                	je     430 <printint+0x90>
 3b2:	89 d0                	mov    %edx,%eax
 3b4:	c1 e8 1f             	shr    $0x1f,%eax
 3b7:	84 c0                	test   %al,%al
 3b9:	74 75                	je     430 <printint+0x90>
    neg = 1;
    x = -xx;
 3bb:	89 d0                	mov    %edx,%eax
    neg = 1;
 3bd:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    x = -xx;
 3c4:	f7 d8                	neg    %eax
 3c6:	89 75 c0             	mov    %esi,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3c9:	31 ff                	xor    %edi,%edi
 3cb:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 3ce:	89 ce                	mov    %ecx,%esi
 3d0:	eb 08                	jmp    3da <printint+0x3a>
 3d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 3d8:	89 cf                	mov    %ecx,%edi
 3da:	31 d2                	xor    %edx,%edx
 3dc:	8d 4f 01             	lea    0x1(%edi),%ecx
 3df:	f7 f6                	div    %esi
 3e1:	0f b6 92 94 07 00 00 	movzbl 0x794(%edx),%edx
  }while((x /= base) != 0);
 3e8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 3ea:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 3ed:	75 e9                	jne    3d8 <printint+0x38>
  if(neg)
 3ef:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 3f2:	8b 75 c0             	mov    -0x40(%ebp),%esi
 3f5:	85 c0                	test   %eax,%eax
 3f7:	74 08                	je     401 <printint+0x61>
    buf[i++] = '-';
 3f9:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 3fe:	8d 4f 02             	lea    0x2(%edi),%ecx

  while(--i >= 0)
 401:	8d 79 ff             	lea    -0x1(%ecx),%edi
 404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 408:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
  write(fd, &c, 1);
 40d:	83 ec 04             	sub    $0x4,%esp
  while(--i >= 0)
 410:	83 ef 01             	sub    $0x1,%edi
  write(fd, &c, 1);
 413:	6a 01                	push   $0x1
 415:	53                   	push   %ebx
 416:	56                   	push   %esi
 417:	88 45 d7             	mov    %al,-0x29(%ebp)
 41a:	e8 c3 fe ff ff       	call   2e2 <write>
  while(--i >= 0)
 41f:	83 c4 10             	add    $0x10,%esp
 422:	83 ff ff             	cmp    $0xffffffff,%edi
 425:	75 e1                	jne    408 <printint+0x68>
    putc(fd, buf[i]);
}
 427:	8d 65 f4             	lea    -0xc(%ebp),%esp
 42a:	5b                   	pop    %ebx
 42b:	5e                   	pop    %esi
 42c:	5f                   	pop    %edi
 42d:	5d                   	pop    %ebp
 42e:	c3                   	ret    
 42f:	90                   	nop
    x = xx;
 430:	89 d0                	mov    %edx,%eax
  neg = 0;
 432:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 439:	eb 8b                	jmp    3c6 <printint+0x26>
 43b:	90                   	nop
 43c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000440 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	57                   	push   %edi
 444:	56                   	push   %esi
 445:	53                   	push   %ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 446:	8d 45 10             	lea    0x10(%ebp),%eax
{
 449:	83 ec 2c             	sub    $0x2c,%esp
  for(i = 0; fmt[i]; i++){
 44c:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 44f:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 452:	89 45 d0             	mov    %eax,-0x30(%ebp)
 455:	0f b6 1e             	movzbl (%esi),%ebx
 458:	83 c6 01             	add    $0x1,%esi
 45b:	84 db                	test   %bl,%bl
 45d:	0f 84 b0 00 00 00    	je     513 <printf+0xd3>
 463:	31 d2                	xor    %edx,%edx
 465:	eb 39                	jmp    4a0 <printf+0x60>
 467:	89 f6                	mov    %esi,%esi
 469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 470:	83 f8 25             	cmp    $0x25,%eax
 473:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 476:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 47b:	74 18                	je     495 <printf+0x55>
  write(fd, &c, 1);
 47d:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 480:	83 ec 04             	sub    $0x4,%esp
 483:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 486:	6a 01                	push   $0x1
 488:	50                   	push   %eax
 489:	57                   	push   %edi
 48a:	e8 53 fe ff ff       	call   2e2 <write>
 48f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 492:	83 c4 10             	add    $0x10,%esp
 495:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 498:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 49c:	84 db                	test   %bl,%bl
 49e:	74 73                	je     513 <printf+0xd3>
    if(state == 0){
 4a0:	85 d2                	test   %edx,%edx
    c = fmt[i] & 0xff;
 4a2:	0f be cb             	movsbl %bl,%ecx
 4a5:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 4a8:	74 c6                	je     470 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4aa:	83 fa 25             	cmp    $0x25,%edx
 4ad:	75 e6                	jne    495 <printf+0x55>
      if(c == 'd'){
 4af:	83 f8 64             	cmp    $0x64,%eax
 4b2:	0f 84 f8 00 00 00    	je     5b0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4b8:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 4be:	83 f9 70             	cmp    $0x70,%ecx
 4c1:	74 5d                	je     520 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4c3:	83 f8 73             	cmp    $0x73,%eax
 4c6:	0f 84 84 00 00 00    	je     550 <printf+0x110>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4cc:	83 f8 63             	cmp    $0x63,%eax
 4cf:	0f 84 ea 00 00 00    	je     5bf <printf+0x17f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4d5:	83 f8 25             	cmp    $0x25,%eax
 4d8:	0f 84 c2 00 00 00    	je     5a0 <printf+0x160>
  write(fd, &c, 1);
 4de:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4e1:	83 ec 04             	sub    $0x4,%esp
 4e4:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4e8:	6a 01                	push   $0x1
 4ea:	50                   	push   %eax
 4eb:	57                   	push   %edi
 4ec:	e8 f1 fd ff ff       	call   2e2 <write>
 4f1:	83 c4 0c             	add    $0xc,%esp
 4f4:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 4f7:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 4fa:	6a 01                	push   $0x1
 4fc:	50                   	push   %eax
 4fd:	57                   	push   %edi
 4fe:	83 c6 01             	add    $0x1,%esi
 501:	e8 dc fd ff ff       	call   2e2 <write>
  for(i = 0; fmt[i]; i++){
 506:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 50a:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 50d:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 50f:	84 db                	test   %bl,%bl
 511:	75 8d                	jne    4a0 <printf+0x60>
    }
  }
}
 513:	8d 65 f4             	lea    -0xc(%ebp),%esp
 516:	5b                   	pop    %ebx
 517:	5e                   	pop    %esi
 518:	5f                   	pop    %edi
 519:	5d                   	pop    %ebp
 51a:	c3                   	ret    
 51b:	90                   	nop
 51c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 16, 0);
 520:	83 ec 0c             	sub    $0xc,%esp
 523:	b9 10 00 00 00       	mov    $0x10,%ecx
 528:	6a 00                	push   $0x0
 52a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 52d:	89 f8                	mov    %edi,%eax
 52f:	8b 13                	mov    (%ebx),%edx
 531:	e8 6a fe ff ff       	call   3a0 <printint>
        ap++;
 536:	89 d8                	mov    %ebx,%eax
 538:	83 c4 10             	add    $0x10,%esp
      state = 0;
 53b:	31 d2                	xor    %edx,%edx
        ap++;
 53d:	83 c0 04             	add    $0x4,%eax
 540:	89 45 d0             	mov    %eax,-0x30(%ebp)
 543:	e9 4d ff ff ff       	jmp    495 <printf+0x55>
 548:	90                   	nop
 549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 550:	8b 45 d0             	mov    -0x30(%ebp),%eax
 553:	8b 18                	mov    (%eax),%ebx
        ap++;
 555:	83 c0 04             	add    $0x4,%eax
 558:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 55b:	85 db                	test   %ebx,%ebx
 55d:	74 7c                	je     5db <printf+0x19b>
        while(*s != 0){
 55f:	0f b6 03             	movzbl (%ebx),%eax
 562:	84 c0                	test   %al,%al
 564:	74 29                	je     58f <printf+0x14f>
 566:	8d 76 00             	lea    0x0(%esi),%esi
 569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 570:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 573:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 576:	83 ec 04             	sub    $0x4,%esp
 579:	6a 01                	push   $0x1
          s++;
 57b:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 57e:	50                   	push   %eax
 57f:	57                   	push   %edi
 580:	e8 5d fd ff ff       	call   2e2 <write>
        while(*s != 0){
 585:	0f b6 03             	movzbl (%ebx),%eax
 588:	83 c4 10             	add    $0x10,%esp
 58b:	84 c0                	test   %al,%al
 58d:	75 e1                	jne    570 <printf+0x130>
      state = 0;
 58f:	31 d2                	xor    %edx,%edx
 591:	e9 ff fe ff ff       	jmp    495 <printf+0x55>
 596:	8d 76 00             	lea    0x0(%esi),%esi
 599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  write(fd, &c, 1);
 5a0:	83 ec 04             	sub    $0x4,%esp
 5a3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 5a6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 5a9:	6a 01                	push   $0x1
 5ab:	e9 4c ff ff ff       	jmp    4fc <printf+0xbc>
        printint(fd, *ap, 10, 1);
 5b0:	83 ec 0c             	sub    $0xc,%esp
 5b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5b8:	6a 01                	push   $0x1
 5ba:	e9 6b ff ff ff       	jmp    52a <printf+0xea>
        putc(fd, *ap);
 5bf:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 5c2:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 5c5:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 5c7:	6a 01                	push   $0x1
        putc(fd, *ap);
 5c9:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 5cc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 5cf:	50                   	push   %eax
 5d0:	57                   	push   %edi
 5d1:	e8 0c fd ff ff       	call   2e2 <write>
 5d6:	e9 5b ff ff ff       	jmp    536 <printf+0xf6>
        while(*s != 0){
 5db:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 5e0:	bb 8d 07 00 00       	mov    $0x78d,%ebx
 5e5:	eb 89                	jmp    570 <printf+0x130>
 5e7:	66 90                	xchg   %ax,%ax
 5e9:	66 90                	xchg   %ax,%ax
 5eb:	66 90                	xchg   %ax,%ax
 5ed:	66 90                	xchg   %ax,%ax
 5ef:	90                   	nop

000005f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5f0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f1:	a1 38 0a 00 00       	mov    0xa38,%eax
{
 5f6:	89 e5                	mov    %esp,%ebp
 5f8:	57                   	push   %edi
 5f9:	56                   	push   %esi
 5fa:	53                   	push   %ebx
 5fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5fe:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 600:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 603:	39 c8                	cmp    %ecx,%eax
 605:	73 19                	jae    620 <free+0x30>
 607:	89 f6                	mov    %esi,%esi
 609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 610:	39 d1                	cmp    %edx,%ecx
 612:	72 1c                	jb     630 <free+0x40>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 614:	39 d0                	cmp    %edx,%eax
 616:	73 18                	jae    630 <free+0x40>
{
 618:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 61a:	39 c8                	cmp    %ecx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 61c:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 61e:	72 f0                	jb     610 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 620:	39 d0                	cmp    %edx,%eax
 622:	72 f4                	jb     618 <free+0x28>
 624:	39 d1                	cmp    %edx,%ecx
 626:	73 f0                	jae    618 <free+0x28>
 628:	90                   	nop
 629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
  if(bp + bp->s.size == p->s.ptr){
 630:	8b 73 fc             	mov    -0x4(%ebx),%esi
 633:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 636:	39 fa                	cmp    %edi,%edx
 638:	74 19                	je     653 <free+0x63>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 63a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 63d:	8b 50 04             	mov    0x4(%eax),%edx
 640:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 643:	39 f1                	cmp    %esi,%ecx
 645:	74 23                	je     66a <free+0x7a>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 647:	89 08                	mov    %ecx,(%eax)
  freep = p;
 649:	a3 38 0a 00 00       	mov    %eax,0xa38
}
 64e:	5b                   	pop    %ebx
 64f:	5e                   	pop    %esi
 650:	5f                   	pop    %edi
 651:	5d                   	pop    %ebp
 652:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 653:	03 72 04             	add    0x4(%edx),%esi
 656:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 659:	8b 10                	mov    (%eax),%edx
 65b:	8b 12                	mov    (%edx),%edx
 65d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 660:	8b 50 04             	mov    0x4(%eax),%edx
 663:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 666:	39 f1                	cmp    %esi,%ecx
 668:	75 dd                	jne    647 <free+0x57>
    p->s.size += bp->s.size;
 66a:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 66d:	a3 38 0a 00 00       	mov    %eax,0xa38
    p->s.size += bp->s.size;
 672:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 675:	8b 53 f8             	mov    -0x8(%ebx),%edx
 678:	89 10                	mov    %edx,(%eax)
}
 67a:	5b                   	pop    %ebx
 67b:	5e                   	pop    %esi
 67c:	5f                   	pop    %edi
 67d:	5d                   	pop    %ebp
 67e:	c3                   	ret    
 67f:	90                   	nop

00000680 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 680:	55                   	push   %ebp
 681:	89 e5                	mov    %esp,%ebp
 683:	57                   	push   %edi
 684:	56                   	push   %esi
 685:	53                   	push   %ebx
 686:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 689:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 68c:	8b 15 38 0a 00 00    	mov    0xa38,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 692:	8d 78 07             	lea    0x7(%eax),%edi
 695:	c1 ef 03             	shr    $0x3,%edi
 698:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 69b:	85 d2                	test   %edx,%edx
 69d:	0f 84 93 00 00 00    	je     736 <malloc+0xb6>
 6a3:	8b 02                	mov    (%edx),%eax
 6a5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 6a8:	39 cf                	cmp    %ecx,%edi
 6aa:	76 64                	jbe    710 <malloc+0x90>
 6ac:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 6b2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6b7:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 6ba:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 6c1:	eb 0e                	jmp    6d1 <malloc+0x51>
 6c3:	90                   	nop
 6c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6c8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6ca:	8b 48 04             	mov    0x4(%eax),%ecx
 6cd:	39 cf                	cmp    %ecx,%edi
 6cf:	76 3f                	jbe    710 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6d1:	39 05 38 0a 00 00    	cmp    %eax,0xa38
 6d7:	89 c2                	mov    %eax,%edx
 6d9:	75 ed                	jne    6c8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 6db:	83 ec 0c             	sub    $0xc,%esp
 6de:	56                   	push   %esi
 6df:	e8 66 fc ff ff       	call   34a <sbrk>
  if(p == (char*)-1)
 6e4:	83 c4 10             	add    $0x10,%esp
 6e7:	83 f8 ff             	cmp    $0xffffffff,%eax
 6ea:	74 1c                	je     708 <malloc+0x88>
  hp->s.size = nu;
 6ec:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6ef:	83 ec 0c             	sub    $0xc,%esp
 6f2:	83 c0 08             	add    $0x8,%eax
 6f5:	50                   	push   %eax
 6f6:	e8 f5 fe ff ff       	call   5f0 <free>
  return freep;
 6fb:	8b 15 38 0a 00 00    	mov    0xa38,%edx
      if((p = morecore(nunits)) == 0)
 701:	83 c4 10             	add    $0x10,%esp
 704:	85 d2                	test   %edx,%edx
 706:	75 c0                	jne    6c8 <malloc+0x48>
        return 0;
 708:	31 c0                	xor    %eax,%eax
 70a:	eb 1c                	jmp    728 <malloc+0xa8>
 70c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 710:	39 cf                	cmp    %ecx,%edi
 712:	74 1c                	je     730 <malloc+0xb0>
        p->s.size -= nunits;
 714:	29 f9                	sub    %edi,%ecx
 716:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 719:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 71c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 71f:	89 15 38 0a 00 00    	mov    %edx,0xa38
      return (void*)(p + 1);
 725:	83 c0 08             	add    $0x8,%eax
  }
}
 728:	8d 65 f4             	lea    -0xc(%ebp),%esp
 72b:	5b                   	pop    %ebx
 72c:	5e                   	pop    %esi
 72d:	5f                   	pop    %edi
 72e:	5d                   	pop    %ebp
 72f:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 730:	8b 08                	mov    (%eax),%ecx
 732:	89 0a                	mov    %ecx,(%edx)
 734:	eb e9                	jmp    71f <malloc+0x9f>
    base.s.ptr = freep = prevp = &base;
 736:	c7 05 38 0a 00 00 3c 	movl   $0xa3c,0xa38
 73d:	0a 00 00 
 740:	c7 05 3c 0a 00 00 3c 	movl   $0xa3c,0xa3c
 747:	0a 00 00 
    base.s.size = 0;
 74a:	b8 3c 0a 00 00       	mov    $0xa3c,%eax
 74f:	c7 05 40 0a 00 00 00 	movl   $0x0,0xa40
 756:	00 00 00 
 759:	e9 4e ff ff ff       	jmp    6ac <malloc+0x2c>
