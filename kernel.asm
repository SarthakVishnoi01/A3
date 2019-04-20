
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 20 b6 10 80       	mov    $0x8010b620,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 80 2e 10 80       	mov    $0x80102e80,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 b6 10 80       	mov    $0x8010b654,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 20 71 10 80       	push   $0x80107120
80100051:	68 20 b6 10 80       	push   $0x8010b620
80100056:	e8 e5 41 00 00       	call   80104240 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 6c fd 10 80 1c 	movl   $0x8010fd1c,0x8010fd6c
80100062:	fd 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 70 fd 10 80 1c 	movl   $0x8010fd1c,0x8010fd70
8010006c:	fd 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba 1c fd 10 80       	mov    $0x8010fd1c,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fd 10 80 	movl   $0x8010fd1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 27 71 10 80       	push   $0x80107127
80100097:	50                   	push   %eax
80100098:	e8 73 40 00 00       	call   80104110 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fd 10 80       	mov    0x8010fd70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 70 fd 10 80    	mov    %ebx,0x8010fd70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d 1c fd 10 80       	cmp    $0x8010fd1c,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 b6 10 80       	push   $0x8010b620
801000e4:	e8 b7 42 00 00       	call   801043a0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fd 10 80    	mov    0x8010fd70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fd 10 80    	cmp    $0x8010fd1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fd 10 80    	cmp    $0x8010fd1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fd 10 80    	mov    0x8010fd6c,%ebx
80100126:	81 fb 1c fd 10 80    	cmp    $0x8010fd1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fd 10 80    	cmp    $0x8010fd1c,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 b6 10 80       	push   $0x8010b620
80100162:	e8 e9 42 00 00       	call   80104450 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 de 3f 00 00       	call   80104150 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 6d 1f 00 00       	call   801020f0 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 2e 71 10 80       	push   $0x8010712e
80100198:	e8 d3 01 00 00       	call   80100370 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 3d 40 00 00       	call   801041f0 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 27 1f 00 00       	jmp    801020f0 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 3f 71 10 80       	push   $0x8010713f
801001d1:	e8 9a 01 00 00       	call   80100370 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 fc 3f 00 00       	call   801041f0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 ac 3f 00 00       	call   801041b0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
8010020b:	e8 90 41 00 00       	call   801043a0 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 70 fd 10 80       	mov    0x8010fd70,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 1c fd 10 80 	movl   $0x8010fd1c,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 70 fd 10 80       	mov    0x8010fd70,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 70 fd 10 80    	mov    %ebx,0x8010fd70
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 20 b6 10 80 	movl   $0x8010b620,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 ef 41 00 00       	jmp    80104450 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 46 71 10 80       	push   $0x80107146
80100269:	e8 02 01 00 00       	call   80100370 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 cb 14 00 00       	call   80101750 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 0f 41 00 00       	call   801043a0 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e 9a 00 00 00    	jle    8010033b <consoleread+0xcb>
    while(input.r == input.w){
801002a1:	a1 00 00 11 80       	mov    0x80110000,%eax
801002a6:	3b 05 04 00 11 80    	cmp    0x80110004,%eax
801002ac:	74 24                	je     801002d2 <consoleread+0x62>
801002ae:	eb 58                	jmp    80100308 <consoleread+0x98>
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b0:	83 ec 08             	sub    $0x8,%esp
801002b3:	68 20 a5 10 80       	push   $0x8010a520
801002b8:	68 00 00 11 80       	push   $0x80110000
801002bd:	e8 de 3a 00 00       	call   80103da0 <sleep>
    while(input.r == input.w){
801002c2:	a1 00 00 11 80       	mov    0x80110000,%eax
801002c7:	83 c4 10             	add    $0x10,%esp
801002ca:	3b 05 04 00 11 80    	cmp    0x80110004,%eax
801002d0:	75 36                	jne    80100308 <consoleread+0x98>
      if(myproc()->killed){
801002d2:	e8 19 35 00 00       	call   801037f0 <myproc>
801002d7:	8b 40 28             	mov    0x28(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 20 a5 10 80       	push   $0x8010a520
801002e6:	e8 65 41 00 00       	call   80104450 <release>
        ilock(ip);
801002eb:	89 3c 24             	mov    %edi,(%esp)
801002ee:	e8 7d 13 00 00       	call   80101670 <ilock>
        return -1;
801002f3:	83 c4 10             	add    $0x10,%esp
801002f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002fe:	5b                   	pop    %ebx
801002ff:	5e                   	pop    %esi
80100300:	5f                   	pop    %edi
80100301:	5d                   	pop    %ebp
80100302:	c3                   	ret    
80100303:	90                   	nop
80100304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100308:	8d 50 01             	lea    0x1(%eax),%edx
8010030b:	89 15 00 00 11 80    	mov    %edx,0x80110000
80100311:	89 c2                	mov    %eax,%edx
80100313:	83 e2 7f             	and    $0x7f,%edx
80100316:	0f be 92 80 ff 10 80 	movsbl -0x7fef0080(%edx),%edx
    if(c == C('D')){  // EOF
8010031d:	83 fa 04             	cmp    $0x4,%edx
80100320:	74 39                	je     8010035b <consoleread+0xeb>
    *dst++ = c;
80100322:	83 c6 01             	add    $0x1,%esi
    --n;
80100325:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100328:	83 fa 0a             	cmp    $0xa,%edx
    *dst++ = c;
8010032b:	88 56 ff             	mov    %dl,-0x1(%esi)
    if(c == '\n')
8010032e:	74 35                	je     80100365 <consoleread+0xf5>
  while(n > 0){
80100330:	85 db                	test   %ebx,%ebx
80100332:	0f 85 69 ff ff ff    	jne    801002a1 <consoleread+0x31>
80100338:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
8010033b:	83 ec 0c             	sub    $0xc,%esp
8010033e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100341:	68 20 a5 10 80       	push   $0x8010a520
80100346:	e8 05 41 00 00       	call   80104450 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 1d 13 00 00       	call   80101670 <ilock>
  return target - n;
80100353:	83 c4 10             	add    $0x10,%esp
80100356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100359:	eb a0                	jmp    801002fb <consoleread+0x8b>
      if(n < target){
8010035b:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010035e:	76 05                	jbe    80100365 <consoleread+0xf5>
        input.r--;
80100360:	a3 00 00 11 80       	mov    %eax,0x80110000
80100365:	8b 45 10             	mov    0x10(%ebp),%eax
80100368:	29 d8                	sub    %ebx,%eax
8010036a:	eb cf                	jmp    8010033b <consoleread+0xcb>
8010036c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100370 <panic>:
{
80100370:	55                   	push   %ebp
80100371:	89 e5                	mov    %esp,%ebp
80100373:	56                   	push   %esi
80100374:	53                   	push   %ebx
80100375:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100378:	fa                   	cli    
  cons.locking = 0;
80100379:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100380:	00 00 00 
  getcallerpcs(&s, pcs);
80100383:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100386:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100389:	e8 72 23 00 00       	call   80102700 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 4d 71 10 80       	push   $0x8010714d
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 2f 7b 10 80 	movl   $0x80107b2f,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 a3 3e 00 00       	call   80104260 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 61 71 10 80       	push   $0x80107161
801003cd:	e8 8e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003d2:	83 c4 10             	add    $0x10,%esp
801003d5:	39 f3                	cmp    %esi,%ebx
801003d7:	75 e7                	jne    801003c0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003d9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003e0:	00 00 00 
801003e3:	eb fe                	jmp    801003e3 <panic+0x73>
801003e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801003e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801003f0 <consputc>:
  if(panicked){
801003f0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003f6:	85 d2                	test   %edx,%edx
801003f8:	74 06                	je     80100400 <consputc+0x10>
801003fa:	fa                   	cli    
801003fb:	eb fe                	jmp    801003fb <consputc+0xb>
801003fd:	8d 76 00             	lea    0x0(%esi),%esi
{
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 b8 00 00 00    	je     801004ce <consputc+0xde>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 51 58 00 00       	call   80105c70 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100434:	89 ca                	mov    %ecx,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	c1 e0 08             	shl    $0x8,%eax
8010043f:	89 c6                	mov    %eax,%esi
80100441:	b8 0f 00 00 00       	mov    $0xf,%eax
80100446:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100447:	89 ca                	mov    %ecx,%edx
80100449:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010044a:	0f b6 c0             	movzbl %al,%eax
8010044d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010044f:	83 fb 0a             	cmp    $0xa,%ebx
80100452:	0f 84 0b 01 00 00    	je     80100563 <consputc+0x173>
  else if(c == BACKSPACE){
80100458:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045e:	0f 84 e6 00 00 00    	je     8010054a <consputc+0x15a>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100464:	0f b6 d3             	movzbl %bl,%edx
80100467:	8d 78 01             	lea    0x1(%eax),%edi
8010046a:	80 ce 07             	or     $0x7,%dh
8010046d:	66 89 94 00 00 80 0b 	mov    %dx,-0x7ff48000(%eax,%eax,1)
80100474:	80 
  if(pos < 0 || pos > 25*80)
80100475:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
8010047b:	0f 8f bc 00 00 00    	jg     8010053d <consputc+0x14d>
  if((pos/80) >= 24){  // Scroll up.
80100481:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100487:	7f 6f                	jg     801004f8 <consputc+0x108>
80100489:	89 f8                	mov    %edi,%eax
8010048b:	8d 9c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ebx
80100492:	89 f9                	mov    %edi,%ecx
80100494:	c1 e8 08             	shr    $0x8,%eax
80100497:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100499:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010049e:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a3:	89 fa                	mov    %edi,%edx
801004a5:	ee                   	out    %al,(%dx)
801004a6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004ab:	89 f0                	mov    %esi,%eax
801004ad:	ee                   	out    %al,(%dx)
801004ae:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b3:	89 fa                	mov    %edi,%edx
801004b5:	ee                   	out    %al,(%dx)
801004b6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004bb:	89 c8                	mov    %ecx,%eax
801004bd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004be:	b8 20 07 00 00       	mov    $0x720,%eax
801004c3:	66 89 03             	mov    %ax,(%ebx)
}
801004c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c9:	5b                   	pop    %ebx
801004ca:	5e                   	pop    %esi
801004cb:	5f                   	pop    %edi
801004cc:	5d                   	pop    %ebp
801004cd:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004ce:	83 ec 0c             	sub    $0xc,%esp
801004d1:	6a 08                	push   $0x8
801004d3:	e8 98 57 00 00       	call   80105c70 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 8c 57 00 00       	call   80105c70 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 80 57 00 00       	call   80105c70 <uartputc>
801004f0:	83 c4 10             	add    $0x10,%esp
801004f3:	e9 2a ff ff ff       	jmp    80100422 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f8:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801004fb:	83 ef 50             	sub    $0x50,%edi
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004fe:	be 07 00 00 00       	mov    $0x7,%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100503:	68 60 0e 00 00       	push   $0xe60
80100508:	68 a0 80 0b 80       	push   $0x800b80a0
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010050d:	8d 9c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100514:	68 00 80 0b 80       	push   $0x800b8000
80100519:	e8 32 40 00 00       	call   80104550 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010051e:	b8 80 07 00 00       	mov    $0x780,%eax
80100523:	83 c4 0c             	add    $0xc,%esp
80100526:	29 f8                	sub    %edi,%eax
80100528:	01 c0                	add    %eax,%eax
8010052a:	50                   	push   %eax
8010052b:	6a 00                	push   $0x0
8010052d:	53                   	push   %ebx
8010052e:	e8 6d 3f 00 00       	call   801044a0 <memset>
80100533:	89 f9                	mov    %edi,%ecx
80100535:	83 c4 10             	add    $0x10,%esp
80100538:	e9 5c ff ff ff       	jmp    80100499 <consputc+0xa9>
    panic("pos under/overflow");
8010053d:	83 ec 0c             	sub    $0xc,%esp
80100540:	68 65 71 10 80       	push   $0x80107165
80100545:	e8 26 fe ff ff       	call   80100370 <panic>
    if(pos > 0) --pos;
8010054a:	85 c0                	test   %eax,%eax
8010054c:	8d 78 ff             	lea    -0x1(%eax),%edi
8010054f:	0f 85 20 ff ff ff    	jne    80100475 <consputc+0x85>
80100555:	bb 00 80 0b 80       	mov    $0x800b8000,%ebx
8010055a:	31 c9                	xor    %ecx,%ecx
8010055c:	31 f6                	xor    %esi,%esi
8010055e:	e9 36 ff ff ff       	jmp    80100499 <consputc+0xa9>
    pos += 80 - pos%80;
80100563:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100568:	f7 ea                	imul   %edx
8010056a:	89 d0                	mov    %edx,%eax
8010056c:	c1 e8 05             	shr    $0x5,%eax
8010056f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80100572:	c1 e0 04             	shl    $0x4,%eax
80100575:	8d 78 50             	lea    0x50(%eax),%edi
80100578:	e9 f8 fe ff ff       	jmp    80100475 <consputc+0x85>
8010057d:	8d 76 00             	lea    0x0(%esi),%esi

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d6                	mov    %edx,%esi
80100588:	83 ec 1c             	sub    $0x1c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
8010058d:	74 04                	je     80100593 <printint+0x13>
8010058f:	85 c0                	test   %eax,%eax
80100591:	78 57                	js     801005ea <printint+0x6a>
    x = xx;
80100593:	31 ff                	xor    %edi,%edi
  i = 0;
80100595:	31 c9                	xor    %ecx,%ecx
80100597:	eb 09                	jmp    801005a2 <printint+0x22>
80100599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a0:	89 d9                	mov    %ebx,%ecx
801005a2:	31 d2                	xor    %edx,%edx
801005a4:	8d 59 01             	lea    0x1(%ecx),%ebx
801005a7:	f7 f6                	div    %esi
801005a9:	0f b6 92 90 71 10 80 	movzbl -0x7fef8e70(%edx),%edx
  }while((x /= base) != 0);
801005b0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005b2:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
801005b6:	75 e8                	jne    801005a0 <printint+0x20>
  if(sign)
801005b8:	85 ff                	test   %edi,%edi
801005ba:	74 08                	je     801005c4 <printint+0x44>
    buf[i++] = '-';
801005bc:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
801005c1:	8d 59 02             	lea    0x2(%ecx),%ebx
  while(--i >= 0)
801005c4:	83 eb 01             	sub    $0x1,%ebx
801005c7:	89 f6                	mov    %esi,%esi
801005c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    consputc(buf[i]);
801005d0:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
  while(--i >= 0)
801005d5:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
801005d8:	e8 13 fe ff ff       	call   801003f0 <consputc>
  while(--i >= 0)
801005dd:	83 fb ff             	cmp    $0xffffffff,%ebx
801005e0:	75 ee                	jne    801005d0 <printint+0x50>
}
801005e2:	83 c4 1c             	add    $0x1c,%esp
801005e5:	5b                   	pop    %ebx
801005e6:	5e                   	pop    %esi
801005e7:	5f                   	pop    %edi
801005e8:	5d                   	pop    %ebp
801005e9:	c3                   	ret    
    x = -xx;
801005ea:	f7 d8                	neg    %eax
  if(sign && (sign = xx < 0))
801005ec:	bf 01 00 00 00       	mov    $0x1,%edi
    x = -xx;
801005f1:	eb a2                	jmp    80100595 <printint+0x15>
801005f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100609:	ff 75 08             	pushl  0x8(%ebp)
{
8010060c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010060f:	e8 3c 11 00 00       	call   80101750 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 80 3d 00 00       	call   801043a0 <acquire>
80100620:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100623:	83 c4 10             	add    $0x10,%esp
80100626:	85 f6                	test   %esi,%esi
80100628:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062b:	7e 12                	jle    8010063f <consolewrite+0x3f>
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 b5 fd ff ff       	call   801003f0 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 04 3e 00 00       	call   80104450 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 1b 10 00 00       	call   80101670 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100673:	0f 85 27 01 00 00    	jne    801007a0 <cprintf+0x140>
  if (fmt == 0)
80100679:	8b 75 08             	mov    0x8(%ebp),%esi
8010067c:	85 f6                	test   %esi,%esi
8010067e:	0f 84 40 01 00 00    	je     801007c4 <cprintf+0x164>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100684:	0f b6 06             	movzbl (%esi),%eax
80100687:	31 db                	xor    %ebx,%ebx
80100689:	8d 7d 0c             	lea    0xc(%ebp),%edi
8010068c:	85 c0                	test   %eax,%eax
8010068e:	75 51                	jne    801006e1 <cprintf+0x81>
80100690:	eb 64                	jmp    801006f6 <cprintf+0x96>
80100692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    c = fmt[++i] & 0xff;
80100698:	83 c3 01             	add    $0x1,%ebx
8010069b:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
8010069f:	85 d2                	test   %edx,%edx
801006a1:	74 53                	je     801006f6 <cprintf+0x96>
    switch(c){
801006a3:	83 fa 70             	cmp    $0x70,%edx
801006a6:	74 7a                	je     80100722 <cprintf+0xc2>
801006a8:	7f 6e                	jg     80100718 <cprintf+0xb8>
801006aa:	83 fa 25             	cmp    $0x25,%edx
801006ad:	0f 84 ad 00 00 00    	je     80100760 <cprintf+0x100>
801006b3:	83 fa 64             	cmp    $0x64,%edx
801006b6:	0f 85 84 00 00 00    	jne    80100740 <cprintf+0xe0>
      printint(*argp++, 10, 1);
801006bc:	8d 47 04             	lea    0x4(%edi),%eax
801006bf:	b9 01 00 00 00       	mov    $0x1,%ecx
801006c4:	ba 0a 00 00 00       	mov    $0xa,%edx
801006c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006cc:	8b 07                	mov    (%edi),%eax
801006ce:	e8 ad fe ff ff       	call   80100580 <printint>
801006d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d6:	83 c3 01             	add    $0x1,%ebx
801006d9:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801006dd:	85 c0                	test   %eax,%eax
801006df:	74 15                	je     801006f6 <cprintf+0x96>
    if(c != '%'){
801006e1:	83 f8 25             	cmp    $0x25,%eax
801006e4:	74 b2                	je     80100698 <cprintf+0x38>
      consputc('%');
801006e6:	e8 05 fd ff ff       	call   801003f0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006eb:	83 c3 01             	add    $0x1,%ebx
801006ee:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801006f2:	85 c0                	test   %eax,%eax
801006f4:	75 eb                	jne    801006e1 <cprintf+0x81>
  if(locking)
801006f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006f9:	85 c0                	test   %eax,%eax
801006fb:	74 10                	je     8010070d <cprintf+0xad>
    release(&cons.lock);
801006fd:	83 ec 0c             	sub    $0xc,%esp
80100700:	68 20 a5 10 80       	push   $0x8010a520
80100705:	e8 46 3d 00 00       	call   80104450 <release>
8010070a:	83 c4 10             	add    $0x10,%esp
}
8010070d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100710:	5b                   	pop    %ebx
80100711:	5e                   	pop    %esi
80100712:	5f                   	pop    %edi
80100713:	5d                   	pop    %ebp
80100714:	c3                   	ret    
80100715:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
80100718:	83 fa 73             	cmp    $0x73,%edx
8010071b:	74 53                	je     80100770 <cprintf+0x110>
8010071d:	83 fa 78             	cmp    $0x78,%edx
80100720:	75 1e                	jne    80100740 <cprintf+0xe0>
      printint(*argp++, 16, 0);
80100722:	8d 47 04             	lea    0x4(%edi),%eax
80100725:	31 c9                	xor    %ecx,%ecx
80100727:	ba 10 00 00 00       	mov    $0x10,%edx
8010072c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010072f:	8b 07                	mov    (%edi),%eax
80100731:	e8 4a fe ff ff       	call   80100580 <printint>
80100736:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      break;
80100739:	eb 9b                	jmp    801006d6 <cprintf+0x76>
8010073b:	90                   	nop
8010073c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100740:	b8 25 00 00 00       	mov    $0x25,%eax
80100745:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100748:	e8 a3 fc ff ff       	call   801003f0 <consputc>
      consputc(c);
8010074d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100750:	89 d0                	mov    %edx,%eax
80100752:	e8 99 fc ff ff       	call   801003f0 <consputc>
      break;
80100757:	e9 7a ff ff ff       	jmp    801006d6 <cprintf+0x76>
8010075c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100760:	b8 25 00 00 00       	mov    $0x25,%eax
80100765:	e8 86 fc ff ff       	call   801003f0 <consputc>
8010076a:	e9 7c ff ff ff       	jmp    801006eb <cprintf+0x8b>
8010076f:	90                   	nop
      if((s = (char*)*argp++) == 0)
80100770:	8d 47 04             	lea    0x4(%edi),%eax
80100773:	8b 3f                	mov    (%edi),%edi
80100775:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100778:	85 ff                	test   %edi,%edi
8010077a:	75 0c                	jne    80100788 <cprintf+0x128>
8010077c:	eb 3a                	jmp    801007b8 <cprintf+0x158>
8010077e:	66 90                	xchg   %ax,%ax
      for(; *s; s++)
80100780:	83 c7 01             	add    $0x1,%edi
        consputc(*s);
80100783:	e8 68 fc ff ff       	call   801003f0 <consputc>
      for(; *s; s++)
80100788:	0f be 07             	movsbl (%edi),%eax
8010078b:	84 c0                	test   %al,%al
8010078d:	75 f1                	jne    80100780 <cprintf+0x120>
      if((s = (char*)*argp++) == 0)
8010078f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80100792:	e9 3f ff ff ff       	jmp    801006d6 <cprintf+0x76>
80100797:	89 f6                	mov    %esi,%esi
80100799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    acquire(&cons.lock);
801007a0:	83 ec 0c             	sub    $0xc,%esp
801007a3:	68 20 a5 10 80       	push   $0x8010a520
801007a8:	e8 f3 3b 00 00       	call   801043a0 <acquire>
801007ad:	83 c4 10             	add    $0x10,%esp
801007b0:	e9 c4 fe ff ff       	jmp    80100679 <cprintf+0x19>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
      for(; *s; s++)
801007b8:	b8 28 00 00 00       	mov    $0x28,%eax
        s = "(null)";
801007bd:	bf 78 71 10 80       	mov    $0x80107178,%edi
801007c2:	eb bc                	jmp    80100780 <cprintf+0x120>
    panic("null fmt");
801007c4:	83 ec 0c             	sub    $0xc,%esp
801007c7:	68 7f 71 10 80       	push   $0x8010717f
801007cc:	e8 9f fb ff ff       	call   80100370 <panic>
801007d1:	eb 0d                	jmp    801007e0 <consoleintr>
801007d3:	90                   	nop
801007d4:	90                   	nop
801007d5:	90                   	nop
801007d6:	90                   	nop
801007d7:	90                   	nop
801007d8:	90                   	nop
801007d9:	90                   	nop
801007da:	90                   	nop
801007db:	90                   	nop
801007dc:	90                   	nop
801007dd:	90                   	nop
801007de:	90                   	nop
801007df:	90                   	nop

801007e0 <consoleintr>:
{
801007e0:	55                   	push   %ebp
801007e1:	89 e5                	mov    %esp,%ebp
801007e3:	57                   	push   %edi
801007e4:	56                   	push   %esi
801007e5:	53                   	push   %ebx
  int c, doprocdump = 0;
801007e6:	31 f6                	xor    %esi,%esi
{
801007e8:	83 ec 18             	sub    $0x18,%esp
801007eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
801007ee:	68 20 a5 10 80       	push   $0x8010a520
801007f3:	e8 a8 3b 00 00       	call   801043a0 <acquire>
  while((c = getc()) >= 0){
801007f8:	83 c4 10             	add    $0x10,%esp
801007fb:	90                   	nop
801007fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100800:	ff d3                	call   *%ebx
80100802:	85 c0                	test   %eax,%eax
80100804:	89 c7                	mov    %eax,%edi
80100806:	78 48                	js     80100850 <consoleintr+0x70>
    switch(c){
80100808:	83 ff 10             	cmp    $0x10,%edi
8010080b:	0f 84 3f 01 00 00    	je     80100950 <consoleintr+0x170>
80100811:	7e 5d                	jle    80100870 <consoleintr+0x90>
80100813:	83 ff 15             	cmp    $0x15,%edi
80100816:	0f 84 dc 00 00 00    	je     801008f8 <consoleintr+0x118>
8010081c:	83 ff 7f             	cmp    $0x7f,%edi
8010081f:	75 54                	jne    80100875 <consoleintr+0x95>
      if(input.e != input.w){
80100821:	a1 08 00 11 80       	mov    0x80110008,%eax
80100826:	3b 05 04 00 11 80    	cmp    0x80110004,%eax
8010082c:	74 d2                	je     80100800 <consoleintr+0x20>
        input.e--;
8010082e:	83 e8 01             	sub    $0x1,%eax
80100831:	a3 08 00 11 80       	mov    %eax,0x80110008
        consputc(BACKSPACE);
80100836:	b8 00 01 00 00       	mov    $0x100,%eax
8010083b:	e8 b0 fb ff ff       	call   801003f0 <consputc>
  while((c = getc()) >= 0){
80100840:	ff d3                	call   *%ebx
80100842:	85 c0                	test   %eax,%eax
80100844:	89 c7                	mov    %eax,%edi
80100846:	79 c0                	jns    80100808 <consoleintr+0x28>
80100848:	90                   	nop
80100849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100850:	83 ec 0c             	sub    $0xc,%esp
80100853:	68 20 a5 10 80       	push   $0x8010a520
80100858:	e8 f3 3b 00 00       	call   80104450 <release>
  if(doprocdump) {
8010085d:	83 c4 10             	add    $0x10,%esp
80100860:	85 f6                	test   %esi,%esi
80100862:	0f 85 f8 00 00 00    	jne    80100960 <consoleintr+0x180>
}
80100868:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010086b:	5b                   	pop    %ebx
8010086c:	5e                   	pop    %esi
8010086d:	5f                   	pop    %edi
8010086e:	5d                   	pop    %ebp
8010086f:	c3                   	ret    
    switch(c){
80100870:	83 ff 08             	cmp    $0x8,%edi
80100873:	74 ac                	je     80100821 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100875:	85 ff                	test   %edi,%edi
80100877:	74 87                	je     80100800 <consoleintr+0x20>
80100879:	a1 08 00 11 80       	mov    0x80110008,%eax
8010087e:	89 c2                	mov    %eax,%edx
80100880:	2b 15 00 00 11 80    	sub    0x80110000,%edx
80100886:	83 fa 7f             	cmp    $0x7f,%edx
80100889:	0f 87 71 ff ff ff    	ja     80100800 <consoleintr+0x20>
        input.buf[input.e++ % INPUT_BUF] = c;
8010088f:	8d 50 01             	lea    0x1(%eax),%edx
80100892:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100895:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100898:	89 15 08 00 11 80    	mov    %edx,0x80110008
        c = (c == '\r') ? '\n' : c;
8010089e:	0f 84 c8 00 00 00    	je     8010096c <consoleintr+0x18c>
        input.buf[input.e++ % INPUT_BUF] = c;
801008a4:	89 f9                	mov    %edi,%ecx
801008a6:	88 88 80 ff 10 80    	mov    %cl,-0x7fef0080(%eax)
        consputc(c);
801008ac:	89 f8                	mov    %edi,%eax
801008ae:	e8 3d fb ff ff       	call   801003f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008b3:	83 ff 0a             	cmp    $0xa,%edi
801008b6:	0f 84 c1 00 00 00    	je     8010097d <consoleintr+0x19d>
801008bc:	83 ff 04             	cmp    $0x4,%edi
801008bf:	0f 84 b8 00 00 00    	je     8010097d <consoleintr+0x19d>
801008c5:	a1 00 00 11 80       	mov    0x80110000,%eax
801008ca:	83 e8 80             	sub    $0xffffff80,%eax
801008cd:	39 05 08 00 11 80    	cmp    %eax,0x80110008
801008d3:	0f 85 27 ff ff ff    	jne    80100800 <consoleintr+0x20>
          wakeup(&input.r);
801008d9:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
801008dc:	a3 04 00 11 80       	mov    %eax,0x80110004
          wakeup(&input.r);
801008e1:	68 00 00 11 80       	push   $0x80110000
801008e6:	e8 75 36 00 00       	call   80103f60 <wakeup>
801008eb:	83 c4 10             	add    $0x10,%esp
801008ee:	e9 0d ff ff ff       	jmp    80100800 <consoleintr+0x20>
801008f3:	90                   	nop
801008f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
801008f8:	a1 08 00 11 80       	mov    0x80110008,%eax
801008fd:	39 05 04 00 11 80    	cmp    %eax,0x80110004
80100903:	75 2b                	jne    80100930 <consoleintr+0x150>
80100905:	e9 f6 fe ff ff       	jmp    80100800 <consoleintr+0x20>
8010090a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100910:	a3 08 00 11 80       	mov    %eax,0x80110008
        consputc(BACKSPACE);
80100915:	b8 00 01 00 00       	mov    $0x100,%eax
8010091a:	e8 d1 fa ff ff       	call   801003f0 <consputc>
      while(input.e != input.w &&
8010091f:	a1 08 00 11 80       	mov    0x80110008,%eax
80100924:	3b 05 04 00 11 80    	cmp    0x80110004,%eax
8010092a:	0f 84 d0 fe ff ff    	je     80100800 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100930:	83 e8 01             	sub    $0x1,%eax
80100933:	89 c2                	mov    %eax,%edx
80100935:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100938:	80 ba 80 ff 10 80 0a 	cmpb   $0xa,-0x7fef0080(%edx)
8010093f:	75 cf                	jne    80100910 <consoleintr+0x130>
80100941:	e9 ba fe ff ff       	jmp    80100800 <consoleintr+0x20>
80100946:	8d 76 00             	lea    0x0(%esi),%esi
80100949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      doprocdump = 1;
80100950:	be 01 00 00 00       	mov    $0x1,%esi
80100955:	e9 a6 fe ff ff       	jmp    80100800 <consoleintr+0x20>
8010095a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80100960:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100963:	5b                   	pop    %ebx
80100964:	5e                   	pop    %esi
80100965:	5f                   	pop    %edi
80100966:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100967:	e9 e4 36 00 00       	jmp    80104050 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
8010096c:	c6 80 80 ff 10 80 0a 	movb   $0xa,-0x7fef0080(%eax)
        consputc(c);
80100973:	b8 0a 00 00 00       	mov    $0xa,%eax
80100978:	e8 73 fa ff ff       	call   801003f0 <consputc>
8010097d:	a1 08 00 11 80       	mov    0x80110008,%eax
80100982:	e9 52 ff ff ff       	jmp    801008d9 <consoleintr+0xf9>
80100987:	89 f6                	mov    %esi,%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100990 <consoleinit>:

void
consoleinit(void)
{
80100990:	55                   	push   %ebp
80100991:	89 e5                	mov    %esp,%ebp
80100993:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100996:	68 88 71 10 80       	push   $0x80107188
8010099b:	68 20 a5 10 80       	push   $0x8010a520
801009a0:	e8 9b 38 00 00       	call   80104240 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009a5:	58                   	pop    %eax
801009a6:	5a                   	pop    %edx
801009a7:	6a 00                	push   $0x0
801009a9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009ab:	c7 05 cc 09 11 80 00 	movl   $0x80100600,0x801109cc
801009b2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009b5:	c7 05 c8 09 11 80 70 	movl   $0x80100270,0x801109c8
801009bc:	02 10 80 
  cons.locking = 1;
801009bf:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009c6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009c9:	e8 d2 18 00 00       	call   801022a0 <ioapicenable>
}
801009ce:	83 c4 10             	add    $0x10,%esp
801009d1:	c9                   	leave  
801009d2:	c3                   	ret    
801009d3:	66 90                	xchg   %ax,%ax
801009d5:	66 90                	xchg   %ax,%ax
801009d7:	66 90                	xchg   %ax,%ax
801009d9:	66 90                	xchg   %ax,%ax
801009db:	66 90                	xchg   %ax,%ax
801009dd:	66 90                	xchg   %ax,%ax
801009df:	90                   	nop

801009e0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009e0:	55                   	push   %ebp
801009e1:	89 e5                	mov    %esp,%ebp
801009e3:	57                   	push   %edi
801009e4:	56                   	push   %esi
801009e5:	53                   	push   %ebx
801009e6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009ec:	e8 ff 2d 00 00       	call   801037f0 <myproc>
801009f1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
801009f7:	e8 74 21 00 00       	call   80102b70 <begin_op>

  if((ip = namei(path)) == 0){
801009fc:	83 ec 0c             	sub    $0xc,%esp
801009ff:	ff 75 08             	pushl  0x8(%ebp)
80100a02:	e8 b9 14 00 00       	call   80101ec0 <namei>
80100a07:	83 c4 10             	add    $0x10,%esp
80100a0a:	85 c0                	test   %eax,%eax
80100a0c:	0f 84 9c 01 00 00    	je     80100bae <exec+0x1ce>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a12:	83 ec 0c             	sub    $0xc,%esp
80100a15:	89 c3                	mov    %eax,%ebx
80100a17:	50                   	push   %eax
80100a18:	e8 53 0c 00 00       	call   80101670 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a1d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a23:	6a 34                	push   $0x34
80100a25:	6a 00                	push   $0x0
80100a27:	50                   	push   %eax
80100a28:	53                   	push   %ebx
80100a29:	e8 22 0f 00 00       	call   80101950 <readi>
80100a2e:	83 c4 20             	add    $0x20,%esp
80100a31:	83 f8 34             	cmp    $0x34,%eax
80100a34:	74 22                	je     80100a58 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a36:	83 ec 0c             	sub    $0xc,%esp
80100a39:	53                   	push   %ebx
80100a3a:	e8 c1 0e 00 00       	call   80101900 <iunlockput>
    end_op();
80100a3f:	e8 9c 21 00 00       	call   80102be0 <end_op>
80100a44:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a4f:	5b                   	pop    %ebx
80100a50:	5e                   	pop    %esi
80100a51:	5f                   	pop    %edi
80100a52:	5d                   	pop    %ebp
80100a53:	c3                   	ret    
80100a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a58:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a5f:	45 4c 46 
80100a62:	75 d2                	jne    80100a36 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a64:	e8 87 63 00 00       	call   80106df0 <setupkvm>
80100a69:	85 c0                	test   %eax,%eax
80100a6b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a71:	74 c3                	je     80100a36 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a73:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a7a:	00 
80100a7b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100a81:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a88:	00 00 00 
80100a8b:	0f 84 c5 00 00 00    	je     80100b56 <exec+0x176>
80100a91:	31 ff                	xor    %edi,%edi
80100a93:	eb 18                	jmp    80100aad <exec+0xcd>
80100a95:	8d 76 00             	lea    0x0(%esi),%esi
80100a98:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a9f:	83 c7 01             	add    $0x1,%edi
80100aa2:	83 c6 20             	add    $0x20,%esi
80100aa5:	39 f8                	cmp    %edi,%eax
80100aa7:	0f 8e a9 00 00 00    	jle    80100b56 <exec+0x176>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100aad:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100ab3:	6a 20                	push   $0x20
80100ab5:	56                   	push   %esi
80100ab6:	50                   	push   %eax
80100ab7:	53                   	push   %ebx
80100ab8:	e8 93 0e 00 00       	call   80101950 <readi>
80100abd:	83 c4 10             	add    $0x10,%esp
80100ac0:	83 f8 20             	cmp    $0x20,%eax
80100ac3:	75 7b                	jne    80100b40 <exec+0x160>
    if(ph.type != ELF_PROG_LOAD)
80100ac5:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acc:	75 ca                	jne    80100a98 <exec+0xb8>
    if(ph.memsz < ph.filesz)
80100ace:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad4:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ada:	72 64                	jb     80100b40 <exec+0x160>
80100adc:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae2:	72 5c                	jb     80100b40 <exec+0x160>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100ae4:	83 ec 04             	sub    $0x4,%esp
80100ae7:	50                   	push   %eax
80100ae8:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100aee:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af4:	e8 57 61 00 00       	call   80106c50 <allocuvm>
80100af9:	83 c4 10             	add    $0x10,%esp
80100afc:	85 c0                	test   %eax,%eax
80100afe:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100b04:	74 3a                	je     80100b40 <exec+0x160>
    if(ph.vaddr % PGSIZE != 0)
80100b06:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0c:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b11:	75 2d                	jne    80100b40 <exec+0x160>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b13:	83 ec 0c             	sub    $0xc,%esp
80100b16:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1c:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b22:	53                   	push   %ebx
80100b23:	50                   	push   %eax
80100b24:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b2a:	e8 61 60 00 00       	call   80106b90 <loaduvm>
80100b2f:	83 c4 20             	add    $0x20,%esp
80100b32:	85 c0                	test   %eax,%eax
80100b34:	0f 89 5e ff ff ff    	jns    80100a98 <exec+0xb8>
80100b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    freevm(pgdir);
80100b40:	83 ec 0c             	sub    $0xc,%esp
80100b43:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b49:	e8 22 62 00 00       	call   80106d70 <freevm>
80100b4e:	83 c4 10             	add    $0x10,%esp
80100b51:	e9 e0 fe ff ff       	jmp    80100a36 <exec+0x56>
  iunlockput(ip);
80100b56:	83 ec 0c             	sub    $0xc,%esp
80100b59:	53                   	push   %ebx
80100b5a:	e8 a1 0d 00 00       	call   80101900 <iunlockput>
  end_op();
80100b5f:	e8 7c 20 00 00       	call   80102be0 <end_op>
  sz = PGROUNDUP(sz);
80100b64:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b6a:	83 c4 0c             	add    $0xc,%esp
  sz = PGROUNDUP(sz);
80100b6d:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b72:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b77:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b7d:	52                   	push   %edx
80100b7e:	50                   	push   %eax
80100b7f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b85:	e8 c6 60 00 00       	call   80106c50 <allocuvm>
80100b8a:	83 c4 10             	add    $0x10,%esp
80100b8d:	85 c0                	test   %eax,%eax
80100b8f:	89 c6                	mov    %eax,%esi
80100b91:	75 3a                	jne    80100bcd <exec+0x1ed>
    freevm(pgdir);
80100b93:	83 ec 0c             	sub    $0xc,%esp
80100b96:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b9c:	e8 cf 61 00 00       	call   80106d70 <freevm>
80100ba1:	83 c4 10             	add    $0x10,%esp
  return -1;
80100ba4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ba9:	e9 9e fe ff ff       	jmp    80100a4c <exec+0x6c>
    end_op();
80100bae:	e8 2d 20 00 00       	call   80102be0 <end_op>
    cprintf("exec: fail\n");
80100bb3:	83 ec 0c             	sub    $0xc,%esp
80100bb6:	68 a1 71 10 80       	push   $0x801071a1
80100bbb:	e8 a0 fa ff ff       	call   80100660 <cprintf>
    return -1;
80100bc0:	83 c4 10             	add    $0x10,%esp
80100bc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bc8:	e9 7f fe ff ff       	jmp    80100a4c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bcd:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bd3:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bd6:	31 ff                	xor    %edi,%edi
80100bd8:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bda:	50                   	push   %eax
80100bdb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100be1:	e8 aa 62 00 00       	call   80106e90 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100be6:	8b 45 0c             	mov    0xc(%ebp),%eax
80100be9:	83 c4 10             	add    $0x10,%esp
80100bec:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100bf2:	8b 00                	mov    (%eax),%eax
80100bf4:	85 c0                	test   %eax,%eax
80100bf6:	74 79                	je     80100c71 <exec+0x291>
80100bf8:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100bfe:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c04:	eb 13                	jmp    80100c19 <exec+0x239>
80100c06:	8d 76 00             	lea    0x0(%esi),%esi
80100c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(argc >= MAXARG)
80100c10:	83 ff 20             	cmp    $0x20,%edi
80100c13:	0f 84 7a ff ff ff    	je     80100b93 <exec+0x1b3>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c19:	83 ec 0c             	sub    $0xc,%esp
80100c1c:	50                   	push   %eax
80100c1d:	e8 9e 3a 00 00       	call   801046c0 <strlen>
80100c22:	f7 d0                	not    %eax
80100c24:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c26:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c29:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c2a:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c2d:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c30:	e8 8b 3a 00 00       	call   801046c0 <strlen>
80100c35:	83 c0 01             	add    $0x1,%eax
80100c38:	50                   	push   %eax
80100c39:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c3c:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c3f:	53                   	push   %ebx
80100c40:	56                   	push   %esi
80100c41:	e8 aa 63 00 00       	call   80106ff0 <copyout>
80100c46:	83 c4 20             	add    $0x20,%esp
80100c49:	85 c0                	test   %eax,%eax
80100c4b:	0f 88 42 ff ff ff    	js     80100b93 <exec+0x1b3>
  for(argc = 0; argv[argc]; argc++) {
80100c51:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c54:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c5b:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c5e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c64:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c67:	85 c0                	test   %eax,%eax
80100c69:	75 a5                	jne    80100c10 <exec+0x230>
80100c6b:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c71:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c78:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c7a:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c81:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100c85:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c8c:	ff ff ff 
  ustack[1] = argc;
80100c8f:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c95:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100c97:	83 c0 0c             	add    $0xc,%eax
80100c9a:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c9c:	50                   	push   %eax
80100c9d:	52                   	push   %edx
80100c9e:	53                   	push   %ebx
80100c9f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ca5:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cab:	e8 40 63 00 00       	call   80106ff0 <copyout>
80100cb0:	83 c4 10             	add    $0x10,%esp
80100cb3:	85 c0                	test   %eax,%eax
80100cb5:	0f 88 d8 fe ff ff    	js     80100b93 <exec+0x1b3>
  for(last=s=path; *s; s++)
80100cbb:	8b 45 08             	mov    0x8(%ebp),%eax
80100cbe:	0f b6 10             	movzbl (%eax),%edx
80100cc1:	84 d2                	test   %dl,%dl
80100cc3:	74 19                	je     80100cde <exec+0x2fe>
80100cc5:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cc8:	83 c0 01             	add    $0x1,%eax
      last = s+1;
80100ccb:	80 fa 2f             	cmp    $0x2f,%dl
  for(last=s=path; *s; s++)
80100cce:	0f b6 10             	movzbl (%eax),%edx
      last = s+1;
80100cd1:	0f 44 c8             	cmove  %eax,%ecx
80100cd4:	83 c0 01             	add    $0x1,%eax
  for(last=s=path; *s; s++)
80100cd7:	84 d2                	test   %dl,%dl
80100cd9:	75 f0                	jne    80100ccb <exec+0x2eb>
80100cdb:	89 4d 08             	mov    %ecx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cde:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100ce4:	50                   	push   %eax
80100ce5:	6a 10                	push   $0x10
80100ce7:	ff 75 08             	pushl  0x8(%ebp)
80100cea:	89 f8                	mov    %edi,%eax
80100cec:	83 c0 70             	add    $0x70,%eax
80100cef:	50                   	push   %eax
80100cf0:	e8 8b 39 00 00       	call   80104680 <safestrcpy>
  curproc->pgdir = pgdir;
80100cf5:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100cfb:	89 f8                	mov    %edi,%eax
80100cfd:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100d00:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100d02:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d05:	89 c1                	mov    %eax,%ecx
80100d07:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d0d:	8b 40 1c             	mov    0x1c(%eax),%eax
80100d10:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d13:	8b 41 1c             	mov    0x1c(%ecx),%eax
80100d16:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d19:	89 0c 24             	mov    %ecx,(%esp)
80100d1c:	e8 df 5c 00 00       	call   80106a00 <switchuvm>
  freevm(oldpgdir);
80100d21:	89 3c 24             	mov    %edi,(%esp)
80100d24:	e8 47 60 00 00       	call   80106d70 <freevm>
  return 0;
80100d29:	83 c4 10             	add    $0x10,%esp
80100d2c:	31 c0                	xor    %eax,%eax
80100d2e:	e9 19 fd ff ff       	jmp    80100a4c <exec+0x6c>
80100d33:	66 90                	xchg   %ax,%ax
80100d35:	66 90                	xchg   %ax,%ax
80100d37:	66 90                	xchg   %ax,%ax
80100d39:	66 90                	xchg   %ax,%ax
80100d3b:	66 90                	xchg   %ax,%ax
80100d3d:	66 90                	xchg   %ax,%ax
80100d3f:	90                   	nop

80100d40 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d40:	55                   	push   %ebp
80100d41:	89 e5                	mov    %esp,%ebp
80100d43:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d46:	68 ad 71 10 80       	push   $0x801071ad
80100d4b:	68 20 00 11 80       	push   $0x80110020
80100d50:	e8 eb 34 00 00       	call   80104240 <initlock>
}
80100d55:	83 c4 10             	add    $0x10,%esp
80100d58:	c9                   	leave  
80100d59:	c3                   	ret    
80100d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d60 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d64:	bb 54 00 11 80       	mov    $0x80110054,%ebx
{
80100d69:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d6c:	68 20 00 11 80       	push   $0x80110020
80100d71:	e8 2a 36 00 00       	call   801043a0 <acquire>
80100d76:	83 c4 10             	add    $0x10,%esp
80100d79:	eb 10                	jmp    80100d8b <filealloc+0x2b>
80100d7b:	90                   	nop
80100d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d80:	83 c3 18             	add    $0x18,%ebx
80100d83:	81 fb b4 09 11 80    	cmp    $0x801109b4,%ebx
80100d89:	73 25                	jae    80100db0 <filealloc+0x50>
    if(f->ref == 0){
80100d8b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d8e:	85 c0                	test   %eax,%eax
80100d90:	75 ee                	jne    80100d80 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100d92:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100d95:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100d9c:	68 20 00 11 80       	push   $0x80110020
80100da1:	e8 aa 36 00 00       	call   80104450 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100da6:	89 d8                	mov    %ebx,%eax
      return f;
80100da8:	83 c4 10             	add    $0x10,%esp
}
80100dab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dae:	c9                   	leave  
80100daf:	c3                   	ret    
  release(&ftable.lock);
80100db0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100db3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100db5:	68 20 00 11 80       	push   $0x80110020
80100dba:	e8 91 36 00 00       	call   80104450 <release>
}
80100dbf:	89 d8                	mov    %ebx,%eax
  return 0;
80100dc1:	83 c4 10             	add    $0x10,%esp
}
80100dc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dc7:	c9                   	leave  
80100dc8:	c3                   	ret    
80100dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100dd0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100dd0:	55                   	push   %ebp
80100dd1:	89 e5                	mov    %esp,%ebp
80100dd3:	53                   	push   %ebx
80100dd4:	83 ec 10             	sub    $0x10,%esp
80100dd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dda:	68 20 00 11 80       	push   $0x80110020
80100ddf:	e8 bc 35 00 00       	call   801043a0 <acquire>
  if(f->ref < 1)
80100de4:	8b 43 04             	mov    0x4(%ebx),%eax
80100de7:	83 c4 10             	add    $0x10,%esp
80100dea:	85 c0                	test   %eax,%eax
80100dec:	7e 1a                	jle    80100e08 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100dee:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100df1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100df4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100df7:	68 20 00 11 80       	push   $0x80110020
80100dfc:	e8 4f 36 00 00       	call   80104450 <release>
  return f;
}
80100e01:	89 d8                	mov    %ebx,%eax
80100e03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e06:	c9                   	leave  
80100e07:	c3                   	ret    
    panic("filedup");
80100e08:	83 ec 0c             	sub    $0xc,%esp
80100e0b:	68 b4 71 10 80       	push   $0x801071b4
80100e10:	e8 5b f5 ff ff       	call   80100370 <panic>
80100e15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e20 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e20:	55                   	push   %ebp
80100e21:	89 e5                	mov    %esp,%ebp
80100e23:	57                   	push   %edi
80100e24:	56                   	push   %esi
80100e25:	53                   	push   %ebx
80100e26:	83 ec 28             	sub    $0x28,%esp
80100e29:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e2c:	68 20 00 11 80       	push   $0x80110020
80100e31:	e8 6a 35 00 00       	call   801043a0 <acquire>
  if(f->ref < 1)
80100e36:	8b 47 04             	mov    0x4(%edi),%eax
80100e39:	83 c4 10             	add    $0x10,%esp
80100e3c:	85 c0                	test   %eax,%eax
80100e3e:	0f 8e 9b 00 00 00    	jle    80100edf <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e44:	83 e8 01             	sub    $0x1,%eax
80100e47:	85 c0                	test   %eax,%eax
80100e49:	89 47 04             	mov    %eax,0x4(%edi)
80100e4c:	74 1a                	je     80100e68 <fileclose+0x48>
    release(&ftable.lock);
80100e4e:	c7 45 08 20 00 11 80 	movl   $0x80110020,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e58:	5b                   	pop    %ebx
80100e59:	5e                   	pop    %esi
80100e5a:	5f                   	pop    %edi
80100e5b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e5c:	e9 ef 35 00 00       	jmp    80104450 <release>
80100e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100e68:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e6c:	8b 1f                	mov    (%edi),%ebx
  release(&ftable.lock);
80100e6e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100e71:	8b 77 0c             	mov    0xc(%edi),%esi
  f->type = FD_NONE;
80100e74:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  ff = *f;
80100e7a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e7d:	8b 47 10             	mov    0x10(%edi),%eax
  release(&ftable.lock);
80100e80:	68 20 00 11 80       	push   $0x80110020
  ff = *f;
80100e85:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100e88:	e8 c3 35 00 00       	call   80104450 <release>
  if(ff.type == FD_PIPE)
80100e8d:	83 c4 10             	add    $0x10,%esp
80100e90:	83 fb 01             	cmp    $0x1,%ebx
80100e93:	74 13                	je     80100ea8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100e95:	83 fb 02             	cmp    $0x2,%ebx
80100e98:	74 26                	je     80100ec0 <fileclose+0xa0>
}
80100e9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e9d:	5b                   	pop    %ebx
80100e9e:	5e                   	pop    %esi
80100e9f:	5f                   	pop    %edi
80100ea0:	5d                   	pop    %ebp
80100ea1:	c3                   	ret    
80100ea2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ea8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100eac:	83 ec 08             	sub    $0x8,%esp
80100eaf:	53                   	push   %ebx
80100eb0:	56                   	push   %esi
80100eb1:	e8 4a 24 00 00       	call   80103300 <pipeclose>
80100eb6:	83 c4 10             	add    $0x10,%esp
80100eb9:	eb df                	jmp    80100e9a <fileclose+0x7a>
80100ebb:	90                   	nop
80100ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ec0:	e8 ab 1c 00 00       	call   80102b70 <begin_op>
    iput(ff.ip);
80100ec5:	83 ec 0c             	sub    $0xc,%esp
80100ec8:	ff 75 e0             	pushl  -0x20(%ebp)
80100ecb:	e8 d0 08 00 00       	call   801017a0 <iput>
    end_op();
80100ed0:	83 c4 10             	add    $0x10,%esp
}
80100ed3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ed6:	5b                   	pop    %ebx
80100ed7:	5e                   	pop    %esi
80100ed8:	5f                   	pop    %edi
80100ed9:	5d                   	pop    %ebp
    end_op();
80100eda:	e9 01 1d 00 00       	jmp    80102be0 <end_op>
    panic("fileclose");
80100edf:	83 ec 0c             	sub    $0xc,%esp
80100ee2:	68 bc 71 10 80       	push   $0x801071bc
80100ee7:	e8 84 f4 ff ff       	call   80100370 <panic>
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	53                   	push   %ebx
80100ef4:	83 ec 04             	sub    $0x4,%esp
80100ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100efa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100efd:	75 31                	jne    80100f30 <filestat+0x40>
    ilock(f->ip);
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	ff 73 10             	pushl  0x10(%ebx)
80100f05:	e8 66 07 00 00       	call   80101670 <ilock>
    stati(f->ip, st);
80100f0a:	58                   	pop    %eax
80100f0b:	5a                   	pop    %edx
80100f0c:	ff 75 0c             	pushl  0xc(%ebp)
80100f0f:	ff 73 10             	pushl  0x10(%ebx)
80100f12:	e8 09 0a 00 00       	call   80101920 <stati>
    iunlock(f->ip);
80100f17:	59                   	pop    %ecx
80100f18:	ff 73 10             	pushl  0x10(%ebx)
80100f1b:	e8 30 08 00 00       	call   80101750 <iunlock>
    return 0;
80100f20:	83 c4 10             	add    $0x10,%esp
80100f23:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f28:	c9                   	leave  
80100f29:	c3                   	ret    
80100f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f38:	c9                   	leave  
80100f39:	c3                   	ret    
80100f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f40 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	57                   	push   %edi
80100f44:	56                   	push   %esi
80100f45:	53                   	push   %ebx
80100f46:	83 ec 0c             	sub    $0xc,%esp
80100f49:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f4f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f52:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f56:	74 60                	je     80100fb8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f58:	8b 03                	mov    (%ebx),%eax
80100f5a:	83 f8 01             	cmp    $0x1,%eax
80100f5d:	74 41                	je     80100fa0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f5f:	83 f8 02             	cmp    $0x2,%eax
80100f62:	75 5b                	jne    80100fbf <fileread+0x7f>
    ilock(f->ip);
80100f64:	83 ec 0c             	sub    $0xc,%esp
80100f67:	ff 73 10             	pushl  0x10(%ebx)
80100f6a:	e8 01 07 00 00       	call   80101670 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f6f:	57                   	push   %edi
80100f70:	ff 73 14             	pushl  0x14(%ebx)
80100f73:	56                   	push   %esi
80100f74:	ff 73 10             	pushl  0x10(%ebx)
80100f77:	e8 d4 09 00 00       	call   80101950 <readi>
80100f7c:	83 c4 20             	add    $0x20,%esp
80100f7f:	85 c0                	test   %eax,%eax
80100f81:	89 c6                	mov    %eax,%esi
80100f83:	7e 03                	jle    80100f88 <fileread+0x48>
      f->off += r;
80100f85:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f88:	83 ec 0c             	sub    $0xc,%esp
80100f8b:	ff 73 10             	pushl  0x10(%ebx)
80100f8e:	e8 bd 07 00 00       	call   80101750 <iunlock>
    return r;
80100f93:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100f96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f99:	89 f0                	mov    %esi,%eax
80100f9b:	5b                   	pop    %ebx
80100f9c:	5e                   	pop    %esi
80100f9d:	5f                   	pop    %edi
80100f9e:	5d                   	pop    %ebp
80100f9f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100fa0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fa3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fa6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fa9:	5b                   	pop    %ebx
80100faa:	5e                   	pop    %esi
80100fab:	5f                   	pop    %edi
80100fac:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fad:	e9 fe 24 00 00       	jmp    801034b0 <piperead>
80100fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fb8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fbd:	eb d7                	jmp    80100f96 <fileread+0x56>
  panic("fileread");
80100fbf:	83 ec 0c             	sub    $0xc,%esp
80100fc2:	68 c6 71 10 80       	push   $0x801071c6
80100fc7:	e8 a4 f3 ff ff       	call   80100370 <panic>
80100fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fd0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	57                   	push   %edi
80100fd4:	56                   	push   %esi
80100fd5:	53                   	push   %ebx
80100fd6:	83 ec 1c             	sub    $0x1c,%esp
80100fd9:	8b 75 08             	mov    0x8(%ebp),%esi
80100fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fdf:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80100fe3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100fe6:	8b 45 10             	mov    0x10(%ebp),%eax
80100fe9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80100fec:	0f 84 aa 00 00 00    	je     8010109c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80100ff2:	8b 06                	mov    (%esi),%eax
80100ff4:	83 f8 01             	cmp    $0x1,%eax
80100ff7:	0f 84 c2 00 00 00    	je     801010bf <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100ffd:	83 f8 02             	cmp    $0x2,%eax
80101000:	0f 85 e4 00 00 00    	jne    801010ea <filewrite+0x11a>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101006:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101009:	31 ff                	xor    %edi,%edi
8010100b:	85 c0                	test   %eax,%eax
8010100d:	7f 34                	jg     80101043 <filewrite+0x73>
8010100f:	e9 9c 00 00 00       	jmp    801010b0 <filewrite+0xe0>
80101014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101018:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010101b:	83 ec 0c             	sub    $0xc,%esp
8010101e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101021:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101024:	e8 27 07 00 00       	call   80101750 <iunlock>
      end_op();
80101029:	e8 b2 1b 00 00       	call   80102be0 <end_op>
8010102e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101031:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101034:	39 d8                	cmp    %ebx,%eax
80101036:	0f 85 a1 00 00 00    	jne    801010dd <filewrite+0x10d>
        panic("short filewrite");
      i += r;
8010103c:	01 c7                	add    %eax,%edi
    while(i < n){
8010103e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101041:	7e 6d                	jle    801010b0 <filewrite+0xe0>
      int n1 = n - i;
80101043:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101046:	b8 00 06 00 00       	mov    $0x600,%eax
8010104b:	29 fb                	sub    %edi,%ebx
8010104d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101053:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101056:	e8 15 1b 00 00       	call   80102b70 <begin_op>
      ilock(f->ip);
8010105b:	83 ec 0c             	sub    $0xc,%esp
8010105e:	ff 76 10             	pushl  0x10(%esi)
80101061:	e8 0a 06 00 00       	call   80101670 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101066:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101069:	53                   	push   %ebx
8010106a:	ff 76 14             	pushl  0x14(%esi)
8010106d:	01 f8                	add    %edi,%eax
8010106f:	50                   	push   %eax
80101070:	ff 76 10             	pushl  0x10(%esi)
80101073:	e8 d8 09 00 00       	call   80101a50 <writei>
80101078:	83 c4 20             	add    $0x20,%esp
8010107b:	85 c0                	test   %eax,%eax
8010107d:	7f 99                	jg     80101018 <filewrite+0x48>
      iunlock(f->ip);
8010107f:	83 ec 0c             	sub    $0xc,%esp
80101082:	ff 76 10             	pushl  0x10(%esi)
80101085:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101088:	e8 c3 06 00 00       	call   80101750 <iunlock>
      end_op();
8010108d:	e8 4e 1b 00 00       	call   80102be0 <end_op>
      if(r < 0)
80101092:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101095:	83 c4 10             	add    $0x10,%esp
80101098:	85 c0                	test   %eax,%eax
8010109a:	74 98                	je     80101034 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010109c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010109f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010a4:	5b                   	pop    %ebx
801010a5:	5e                   	pop    %esi
801010a6:	5f                   	pop    %edi
801010a7:	5d                   	pop    %ebp
801010a8:	c3                   	ret    
801010a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010b0:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801010b3:	75 e7                	jne    8010109c <filewrite+0xcc>
}
801010b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010b8:	89 f8                	mov    %edi,%eax
801010ba:	5b                   	pop    %ebx
801010bb:	5e                   	pop    %esi
801010bc:	5f                   	pop    %edi
801010bd:	5d                   	pop    %ebp
801010be:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801010bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801010c2:	89 45 10             	mov    %eax,0x10(%ebp)
801010c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010c8:	89 45 0c             	mov    %eax,0xc(%ebp)
801010cb:	8b 46 0c             	mov    0xc(%esi),%eax
801010ce:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d4:	5b                   	pop    %ebx
801010d5:	5e                   	pop    %esi
801010d6:	5f                   	pop    %edi
801010d7:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010d8:	e9 c3 22 00 00       	jmp    801033a0 <pipewrite>
        panic("short filewrite");
801010dd:	83 ec 0c             	sub    $0xc,%esp
801010e0:	68 cf 71 10 80       	push   $0x801071cf
801010e5:	e8 86 f2 ff ff       	call   80100370 <panic>
  panic("filewrite");
801010ea:	83 ec 0c             	sub    $0xc,%esp
801010ed:	68 d5 71 10 80       	push   $0x801071d5
801010f2:	e8 79 f2 ff ff       	call   80100370 <panic>
801010f7:	66 90                	xchg   %ax,%ax
801010f9:	66 90                	xchg   %ax,%ax
801010fb:	66 90                	xchg   %ax,%ax
801010fd:	66 90                	xchg   %ax,%ax
801010ff:	90                   	nop

80101100 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	57                   	push   %edi
80101104:	56                   	push   %esi
80101105:	53                   	push   %ebx
80101106:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101109:	8b 0d 20 0a 11 80    	mov    0x80110a20,%ecx
{
8010110f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101112:	85 c9                	test   %ecx,%ecx
80101114:	0f 84 87 00 00 00    	je     801011a1 <balloc+0xa1>
8010111a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101121:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101124:	83 ec 08             	sub    $0x8,%esp
80101127:	89 f0                	mov    %esi,%eax
80101129:	c1 f8 0c             	sar    $0xc,%eax
8010112c:	03 05 38 0a 11 80    	add    0x80110a38,%eax
80101132:	50                   	push   %eax
80101133:	ff 75 d8             	pushl  -0x28(%ebp)
80101136:	e8 95 ef ff ff       	call   801000d0 <bread>
8010113b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010113e:	a1 20 0a 11 80       	mov    0x80110a20,%eax
80101143:	83 c4 10             	add    $0x10,%esp
80101146:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101149:	31 c0                	xor    %eax,%eax
8010114b:	eb 2f                	jmp    8010117c <balloc+0x7c>
8010114d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101150:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101152:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101155:	bb 01 00 00 00       	mov    $0x1,%ebx
8010115a:	83 e1 07             	and    $0x7,%ecx
8010115d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010115f:	89 c1                	mov    %eax,%ecx
80101161:	c1 f9 03             	sar    $0x3,%ecx
80101164:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101169:	85 df                	test   %ebx,%edi
8010116b:	89 fa                	mov    %edi,%edx
8010116d:	74 41                	je     801011b0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010116f:	83 c0 01             	add    $0x1,%eax
80101172:	83 c6 01             	add    $0x1,%esi
80101175:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010117a:	74 05                	je     80101181 <balloc+0x81>
8010117c:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010117f:	72 cf                	jb     80101150 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101181:	83 ec 0c             	sub    $0xc,%esp
80101184:	ff 75 e4             	pushl  -0x1c(%ebp)
80101187:	e8 54 f0 ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010118c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101193:	83 c4 10             	add    $0x10,%esp
80101196:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101199:	39 05 20 0a 11 80    	cmp    %eax,0x80110a20
8010119f:	77 80                	ja     80101121 <balloc+0x21>
  }
  panic("balloc: out of blocks");
801011a1:	83 ec 0c             	sub    $0xc,%esp
801011a4:	68 df 71 10 80       	push   $0x801071df
801011a9:	e8 c2 f1 ff ff       	call   80100370 <panic>
801011ae:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801011b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011b3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801011b6:	09 da                	or     %ebx,%edx
801011b8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801011bc:	57                   	push   %edi
801011bd:	e8 8e 1b 00 00       	call   80102d50 <log_write>
        brelse(bp);
801011c2:	89 3c 24             	mov    %edi,(%esp)
801011c5:	e8 16 f0 ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801011ca:	58                   	pop    %eax
801011cb:	5a                   	pop    %edx
801011cc:	56                   	push   %esi
801011cd:	ff 75 d8             	pushl  -0x28(%ebp)
801011d0:	e8 fb ee ff ff       	call   801000d0 <bread>
801011d5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011d7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011da:	83 c4 0c             	add    $0xc,%esp
801011dd:	68 00 02 00 00       	push   $0x200
801011e2:	6a 00                	push   $0x0
801011e4:	50                   	push   %eax
801011e5:	e8 b6 32 00 00       	call   801044a0 <memset>
  log_write(bp);
801011ea:	89 1c 24             	mov    %ebx,(%esp)
801011ed:	e8 5e 1b 00 00       	call   80102d50 <log_write>
  brelse(bp);
801011f2:	89 1c 24             	mov    %ebx,(%esp)
801011f5:	e8 e6 ef ff ff       	call   801001e0 <brelse>
}
801011fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011fd:	89 f0                	mov    %esi,%eax
801011ff:	5b                   	pop    %ebx
80101200:	5e                   	pop    %esi
80101201:	5f                   	pop    %edi
80101202:	5d                   	pop    %ebp
80101203:	c3                   	ret    
80101204:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010120a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101210 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101210:	55                   	push   %ebp
80101211:	89 e5                	mov    %esp,%ebp
80101213:	57                   	push   %edi
80101214:	56                   	push   %esi
80101215:	53                   	push   %ebx
80101216:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101218:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010121a:	bb 74 0a 11 80       	mov    $0x80110a74,%ebx
{
8010121f:	83 ec 28             	sub    $0x28,%esp
80101222:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101225:	68 40 0a 11 80       	push   $0x80110a40
8010122a:	e8 71 31 00 00       	call   801043a0 <acquire>
8010122f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101232:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101235:	eb 1b                	jmp    80101252 <iget+0x42>
80101237:	89 f6                	mov    %esi,%esi
80101239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101240:	85 f6                	test   %esi,%esi
80101242:	74 44                	je     80101288 <iget+0x78>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101244:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010124a:	81 fb 94 26 11 80    	cmp    $0x80112694,%ebx
80101250:	73 4e                	jae    801012a0 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101252:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101255:	85 c9                	test   %ecx,%ecx
80101257:	7e e7                	jle    80101240 <iget+0x30>
80101259:	39 3b                	cmp    %edi,(%ebx)
8010125b:	75 e3                	jne    80101240 <iget+0x30>
8010125d:	39 53 04             	cmp    %edx,0x4(%ebx)
80101260:	75 de                	jne    80101240 <iget+0x30>
      release(&icache.lock);
80101262:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101265:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101268:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010126a:	68 40 0a 11 80       	push   $0x80110a40
      ip->ref++;
8010126f:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101272:	e8 d9 31 00 00       	call   80104450 <release>
      return ip;
80101277:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010127a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010127d:	89 f0                	mov    %esi,%eax
8010127f:	5b                   	pop    %ebx
80101280:	5e                   	pop    %esi
80101281:	5f                   	pop    %edi
80101282:	5d                   	pop    %ebp
80101283:	c3                   	ret    
80101284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101288:	85 c9                	test   %ecx,%ecx
8010128a:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010128d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101293:	81 fb 94 26 11 80    	cmp    $0x80112694,%ebx
80101299:	72 b7                	jb     80101252 <iget+0x42>
8010129b:	90                   	nop
8010129c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(empty == 0)
801012a0:	85 f6                	test   %esi,%esi
801012a2:	74 2d                	je     801012d1 <iget+0xc1>
  release(&icache.lock);
801012a4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801012a7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012a9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012ac:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012b3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012ba:	68 40 0a 11 80       	push   $0x80110a40
801012bf:	e8 8c 31 00 00       	call   80104450 <release>
  return ip;
801012c4:	83 c4 10             	add    $0x10,%esp
}
801012c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ca:	89 f0                	mov    %esi,%eax
801012cc:	5b                   	pop    %ebx
801012cd:	5e                   	pop    %esi
801012ce:	5f                   	pop    %edi
801012cf:	5d                   	pop    %ebp
801012d0:	c3                   	ret    
    panic("iget: no inodes");
801012d1:	83 ec 0c             	sub    $0xc,%esp
801012d4:	68 f5 71 10 80       	push   $0x801071f5
801012d9:	e8 92 f0 ff ff       	call   80100370 <panic>
801012de:	66 90                	xchg   %ax,%ax

801012e0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012e0:	55                   	push   %ebp
801012e1:	89 e5                	mov    %esp,%ebp
801012e3:	57                   	push   %edi
801012e4:	56                   	push   %esi
801012e5:	53                   	push   %ebx
801012e6:	89 c6                	mov    %eax,%esi
801012e8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012eb:	83 fa 0b             	cmp    $0xb,%edx
801012ee:	77 18                	ja     80101308 <bmap+0x28>
801012f0:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
801012f3:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801012f6:	85 db                	test   %ebx,%ebx
801012f8:	74 76                	je     80101370 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801012fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012fd:	89 d8                	mov    %ebx,%eax
801012ff:	5b                   	pop    %ebx
80101300:	5e                   	pop    %esi
80101301:	5f                   	pop    %edi
80101302:	5d                   	pop    %ebp
80101303:	c3                   	ret    
80101304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101308:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010130b:	83 fb 7f             	cmp    $0x7f,%ebx
8010130e:	0f 87 8e 00 00 00    	ja     801013a2 <bmap+0xc2>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101314:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010131a:	85 c0                	test   %eax,%eax
8010131c:	74 72                	je     80101390 <bmap+0xb0>
    bp = bread(ip->dev, addr);
8010131e:	83 ec 08             	sub    $0x8,%esp
80101321:	50                   	push   %eax
80101322:	ff 36                	pushl  (%esi)
80101324:	e8 a7 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
80101329:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010132d:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101330:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101332:	8b 1a                	mov    (%edx),%ebx
80101334:	85 db                	test   %ebx,%ebx
80101336:	75 1d                	jne    80101355 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
80101338:	8b 06                	mov    (%esi),%eax
8010133a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010133d:	e8 be fd ff ff       	call   80101100 <balloc>
80101342:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101345:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101348:	89 c3                	mov    %eax,%ebx
8010134a:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010134c:	57                   	push   %edi
8010134d:	e8 fe 19 00 00       	call   80102d50 <log_write>
80101352:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101355:	83 ec 0c             	sub    $0xc,%esp
80101358:	57                   	push   %edi
80101359:	e8 82 ee ff ff       	call   801001e0 <brelse>
8010135e:	83 c4 10             	add    $0x10,%esp
}
80101361:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101364:	89 d8                	mov    %ebx,%eax
80101366:	5b                   	pop    %ebx
80101367:	5e                   	pop    %esi
80101368:	5f                   	pop    %edi
80101369:	5d                   	pop    %ebp
8010136a:	c3                   	ret    
8010136b:	90                   	nop
8010136c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101370:	8b 00                	mov    (%eax),%eax
80101372:	e8 89 fd ff ff       	call   80101100 <balloc>
80101377:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010137a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010137d:	89 c3                	mov    %eax,%ebx
}
8010137f:	89 d8                	mov    %ebx,%eax
80101381:	5b                   	pop    %ebx
80101382:	5e                   	pop    %esi
80101383:	5f                   	pop    %edi
80101384:	5d                   	pop    %ebp
80101385:	c3                   	ret    
80101386:	8d 76 00             	lea    0x0(%esi),%esi
80101389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101390:	8b 06                	mov    (%esi),%eax
80101392:	e8 69 fd ff ff       	call   80101100 <balloc>
80101397:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010139d:	e9 7c ff ff ff       	jmp    8010131e <bmap+0x3e>
  panic("bmap: out of range");
801013a2:	83 ec 0c             	sub    $0xc,%esp
801013a5:	68 05 72 10 80       	push   $0x80107205
801013aa:	e8 c1 ef ff ff       	call   80100370 <panic>
801013af:	90                   	nop

801013b0 <readsb>:
{
801013b0:	55                   	push   %ebp
801013b1:	89 e5                	mov    %esp,%ebp
801013b3:	56                   	push   %esi
801013b4:	53                   	push   %ebx
801013b5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801013b8:	83 ec 08             	sub    $0x8,%esp
801013bb:	6a 01                	push   $0x1
801013bd:	ff 75 08             	pushl  0x8(%ebp)
801013c0:	e8 0b ed ff ff       	call   801000d0 <bread>
801013c5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013c7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ca:	83 c4 0c             	add    $0xc,%esp
801013cd:	6a 1c                	push   $0x1c
801013cf:	50                   	push   %eax
801013d0:	56                   	push   %esi
801013d1:	e8 7a 31 00 00       	call   80104550 <memmove>
  brelse(bp);
801013d6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013d9:	83 c4 10             	add    $0x10,%esp
}
801013dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013df:	5b                   	pop    %ebx
801013e0:	5e                   	pop    %esi
801013e1:	5d                   	pop    %ebp
  brelse(bp);
801013e2:	e9 f9 ed ff ff       	jmp    801001e0 <brelse>
801013e7:	89 f6                	mov    %esi,%esi
801013e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013f0 <bfree>:
{
801013f0:	55                   	push   %ebp
801013f1:	89 e5                	mov    %esp,%ebp
801013f3:	56                   	push   %esi
801013f4:	53                   	push   %ebx
801013f5:	89 d3                	mov    %edx,%ebx
801013f7:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
801013f9:	83 ec 08             	sub    $0x8,%esp
801013fc:	68 20 0a 11 80       	push   $0x80110a20
80101401:	50                   	push   %eax
80101402:	e8 a9 ff ff ff       	call   801013b0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101407:	58                   	pop    %eax
80101408:	5a                   	pop    %edx
80101409:	89 da                	mov    %ebx,%edx
8010140b:	c1 ea 0c             	shr    $0xc,%edx
8010140e:	03 15 38 0a 11 80    	add    0x80110a38,%edx
80101414:	52                   	push   %edx
80101415:	56                   	push   %esi
80101416:	e8 b5 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010141b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010141d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101420:	ba 01 00 00 00       	mov    $0x1,%edx
80101425:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101428:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010142e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101431:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101433:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101438:	85 d1                	test   %edx,%ecx
8010143a:	74 25                	je     80101461 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010143c:	f7 d2                	not    %edx
8010143e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101440:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101443:	21 ca                	and    %ecx,%edx
80101445:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101449:	56                   	push   %esi
8010144a:	e8 01 19 00 00       	call   80102d50 <log_write>
  brelse(bp);
8010144f:	89 34 24             	mov    %esi,(%esp)
80101452:	e8 89 ed ff ff       	call   801001e0 <brelse>
}
80101457:	83 c4 10             	add    $0x10,%esp
8010145a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010145d:	5b                   	pop    %ebx
8010145e:	5e                   	pop    %esi
8010145f:	5d                   	pop    %ebp
80101460:	c3                   	ret    
    panic("freeing free block");
80101461:	83 ec 0c             	sub    $0xc,%esp
80101464:	68 18 72 10 80       	push   $0x80107218
80101469:	e8 02 ef ff ff       	call   80100370 <panic>
8010146e:	66 90                	xchg   %ax,%ax

80101470 <iinit>:
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	53                   	push   %ebx
80101474:	bb 80 0a 11 80       	mov    $0x80110a80,%ebx
80101479:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010147c:	68 2b 72 10 80       	push   $0x8010722b
80101481:	68 40 0a 11 80       	push   $0x80110a40
80101486:	e8 b5 2d 00 00       	call   80104240 <initlock>
8010148b:	83 c4 10             	add    $0x10,%esp
8010148e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101490:	83 ec 08             	sub    $0x8,%esp
80101493:	68 32 72 10 80       	push   $0x80107232
80101498:	53                   	push   %ebx
80101499:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010149f:	e8 6c 2c 00 00       	call   80104110 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014a4:	83 c4 10             	add    $0x10,%esp
801014a7:	81 fb a0 26 11 80    	cmp    $0x801126a0,%ebx
801014ad:	75 e1                	jne    80101490 <iinit+0x20>
  readsb(dev, &sb);
801014af:	83 ec 08             	sub    $0x8,%esp
801014b2:	68 20 0a 11 80       	push   $0x80110a20
801014b7:	ff 75 08             	pushl  0x8(%ebp)
801014ba:	e8 f1 fe ff ff       	call   801013b0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014bf:	ff 35 38 0a 11 80    	pushl  0x80110a38
801014c5:	ff 35 34 0a 11 80    	pushl  0x80110a34
801014cb:	ff 35 30 0a 11 80    	pushl  0x80110a30
801014d1:	ff 35 2c 0a 11 80    	pushl  0x80110a2c
801014d7:	ff 35 28 0a 11 80    	pushl  0x80110a28
801014dd:	ff 35 24 0a 11 80    	pushl  0x80110a24
801014e3:	ff 35 20 0a 11 80    	pushl  0x80110a20
801014e9:	68 98 72 10 80       	push   $0x80107298
801014ee:	e8 6d f1 ff ff       	call   80100660 <cprintf>
}
801014f3:	83 c4 30             	add    $0x30,%esp
801014f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014f9:	c9                   	leave  
801014fa:	c3                   	ret    
801014fb:	90                   	nop
801014fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101500 <ialloc>:
{
80101500:	55                   	push   %ebp
80101501:	89 e5                	mov    %esp,%ebp
80101503:	57                   	push   %edi
80101504:	56                   	push   %esi
80101505:	53                   	push   %ebx
80101506:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101509:	83 3d 28 0a 11 80 01 	cmpl   $0x1,0x80110a28
{
80101510:	8b 45 0c             	mov    0xc(%ebp),%eax
80101513:	8b 75 08             	mov    0x8(%ebp),%esi
80101516:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101519:	0f 86 91 00 00 00    	jbe    801015b0 <ialloc+0xb0>
8010151f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101524:	eb 21                	jmp    80101547 <ialloc+0x47>
80101526:	8d 76 00             	lea    0x0(%esi),%esi
80101529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101530:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101533:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101536:	57                   	push   %edi
80101537:	e8 a4 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010153c:	83 c4 10             	add    $0x10,%esp
8010153f:	39 1d 28 0a 11 80    	cmp    %ebx,0x80110a28
80101545:	76 69                	jbe    801015b0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101547:	89 d8                	mov    %ebx,%eax
80101549:	83 ec 08             	sub    $0x8,%esp
8010154c:	c1 e8 03             	shr    $0x3,%eax
8010154f:	03 05 34 0a 11 80    	add    0x80110a34,%eax
80101555:	50                   	push   %eax
80101556:	56                   	push   %esi
80101557:	e8 74 eb ff ff       	call   801000d0 <bread>
8010155c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010155e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101560:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101563:	83 e0 07             	and    $0x7,%eax
80101566:	c1 e0 06             	shl    $0x6,%eax
80101569:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010156d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101571:	75 bd                	jne    80101530 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101573:	83 ec 04             	sub    $0x4,%esp
80101576:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101579:	6a 40                	push   $0x40
8010157b:	6a 00                	push   $0x0
8010157d:	51                   	push   %ecx
8010157e:	e8 1d 2f 00 00       	call   801044a0 <memset>
      dip->type = type;
80101583:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101587:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010158a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010158d:	89 3c 24             	mov    %edi,(%esp)
80101590:	e8 bb 17 00 00       	call   80102d50 <log_write>
      brelse(bp);
80101595:	89 3c 24             	mov    %edi,(%esp)
80101598:	e8 43 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010159d:	83 c4 10             	add    $0x10,%esp
}
801015a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015a3:	89 da                	mov    %ebx,%edx
801015a5:	89 f0                	mov    %esi,%eax
}
801015a7:	5b                   	pop    %ebx
801015a8:	5e                   	pop    %esi
801015a9:	5f                   	pop    %edi
801015aa:	5d                   	pop    %ebp
      return iget(dev, inum);
801015ab:	e9 60 fc ff ff       	jmp    80101210 <iget>
  panic("ialloc: no inodes");
801015b0:	83 ec 0c             	sub    $0xc,%esp
801015b3:	68 38 72 10 80       	push   $0x80107238
801015b8:	e8 b3 ed ff ff       	call   80100370 <panic>
801015bd:	8d 76 00             	lea    0x0(%esi),%esi

801015c0 <iupdate>:
{
801015c0:	55                   	push   %ebp
801015c1:	89 e5                	mov    %esp,%ebp
801015c3:	56                   	push   %esi
801015c4:	53                   	push   %ebx
801015c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015c8:	83 ec 08             	sub    $0x8,%esp
801015cb:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ce:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015d1:	c1 e8 03             	shr    $0x3,%eax
801015d4:	03 05 34 0a 11 80    	add    0x80110a34,%eax
801015da:	50                   	push   %eax
801015db:	ff 73 a4             	pushl  -0x5c(%ebx)
801015de:	e8 ed ea ff ff       	call   801000d0 <bread>
801015e3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015e5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801015e8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ec:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015ef:	83 e0 07             	and    $0x7,%eax
801015f2:	c1 e0 06             	shl    $0x6,%eax
801015f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801015f9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801015fc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101600:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101603:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101607:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010160b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010160f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101613:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101617:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010161a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010161d:	6a 34                	push   $0x34
8010161f:	53                   	push   %ebx
80101620:	50                   	push   %eax
80101621:	e8 2a 2f 00 00       	call   80104550 <memmove>
  log_write(bp);
80101626:	89 34 24             	mov    %esi,(%esp)
80101629:	e8 22 17 00 00       	call   80102d50 <log_write>
  brelse(bp);
8010162e:	89 75 08             	mov    %esi,0x8(%ebp)
80101631:	83 c4 10             	add    $0x10,%esp
}
80101634:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101637:	5b                   	pop    %ebx
80101638:	5e                   	pop    %esi
80101639:	5d                   	pop    %ebp
  brelse(bp);
8010163a:	e9 a1 eb ff ff       	jmp    801001e0 <brelse>
8010163f:	90                   	nop

80101640 <idup>:
{
80101640:	55                   	push   %ebp
80101641:	89 e5                	mov    %esp,%ebp
80101643:	53                   	push   %ebx
80101644:	83 ec 10             	sub    $0x10,%esp
80101647:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010164a:	68 40 0a 11 80       	push   $0x80110a40
8010164f:	e8 4c 2d 00 00       	call   801043a0 <acquire>
  ip->ref++;
80101654:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101658:	c7 04 24 40 0a 11 80 	movl   $0x80110a40,(%esp)
8010165f:	e8 ec 2d 00 00       	call   80104450 <release>
}
80101664:	89 d8                	mov    %ebx,%eax
80101666:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101669:	c9                   	leave  
8010166a:	c3                   	ret    
8010166b:	90                   	nop
8010166c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101670 <ilock>:
{
80101670:	55                   	push   %ebp
80101671:	89 e5                	mov    %esp,%ebp
80101673:	56                   	push   %esi
80101674:	53                   	push   %ebx
80101675:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101678:	85 db                	test   %ebx,%ebx
8010167a:	0f 84 b7 00 00 00    	je     80101737 <ilock+0xc7>
80101680:	8b 53 08             	mov    0x8(%ebx),%edx
80101683:	85 d2                	test   %edx,%edx
80101685:	0f 8e ac 00 00 00    	jle    80101737 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010168b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010168e:	83 ec 0c             	sub    $0xc,%esp
80101691:	50                   	push   %eax
80101692:	e8 b9 2a 00 00       	call   80104150 <acquiresleep>
  if(ip->valid == 0){
80101697:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010169a:	83 c4 10             	add    $0x10,%esp
8010169d:	85 c0                	test   %eax,%eax
8010169f:	74 0f                	je     801016b0 <ilock+0x40>
}
801016a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016a4:	5b                   	pop    %ebx
801016a5:	5e                   	pop    %esi
801016a6:	5d                   	pop    %ebp
801016a7:	c3                   	ret    
801016a8:	90                   	nop
801016a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016b0:	8b 43 04             	mov    0x4(%ebx),%eax
801016b3:	83 ec 08             	sub    $0x8,%esp
801016b6:	c1 e8 03             	shr    $0x3,%eax
801016b9:	03 05 34 0a 11 80    	add    0x80110a34,%eax
801016bf:	50                   	push   %eax
801016c0:	ff 33                	pushl  (%ebx)
801016c2:	e8 09 ea ff ff       	call   801000d0 <bread>
801016c7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016c9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016cc:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016cf:	83 e0 07             	and    $0x7,%eax
801016d2:	c1 e0 06             	shl    $0x6,%eax
801016d5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016d9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016dc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801016df:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801016e3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016e7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801016eb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016ef:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801016f3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801016f7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801016fb:	8b 50 fc             	mov    -0x4(%eax),%edx
801016fe:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101701:	6a 34                	push   $0x34
80101703:	50                   	push   %eax
80101704:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101707:	50                   	push   %eax
80101708:	e8 43 2e 00 00       	call   80104550 <memmove>
    brelse(bp);
8010170d:	89 34 24             	mov    %esi,(%esp)
80101710:	e8 cb ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101715:	83 c4 10             	add    $0x10,%esp
80101718:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010171d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101724:	0f 85 77 ff ff ff    	jne    801016a1 <ilock+0x31>
      panic("ilock: no type");
8010172a:	83 ec 0c             	sub    $0xc,%esp
8010172d:	68 50 72 10 80       	push   $0x80107250
80101732:	e8 39 ec ff ff       	call   80100370 <panic>
    panic("ilock");
80101737:	83 ec 0c             	sub    $0xc,%esp
8010173a:	68 4a 72 10 80       	push   $0x8010724a
8010173f:	e8 2c ec ff ff       	call   80100370 <panic>
80101744:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010174a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101750 <iunlock>:
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	56                   	push   %esi
80101754:	53                   	push   %ebx
80101755:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101758:	85 db                	test   %ebx,%ebx
8010175a:	74 28                	je     80101784 <iunlock+0x34>
8010175c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010175f:	83 ec 0c             	sub    $0xc,%esp
80101762:	56                   	push   %esi
80101763:	e8 88 2a 00 00       	call   801041f0 <holdingsleep>
80101768:	83 c4 10             	add    $0x10,%esp
8010176b:	85 c0                	test   %eax,%eax
8010176d:	74 15                	je     80101784 <iunlock+0x34>
8010176f:	8b 43 08             	mov    0x8(%ebx),%eax
80101772:	85 c0                	test   %eax,%eax
80101774:	7e 0e                	jle    80101784 <iunlock+0x34>
  releasesleep(&ip->lock);
80101776:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101779:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010177c:	5b                   	pop    %ebx
8010177d:	5e                   	pop    %esi
8010177e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010177f:	e9 2c 2a 00 00       	jmp    801041b0 <releasesleep>
    panic("iunlock");
80101784:	83 ec 0c             	sub    $0xc,%esp
80101787:	68 5f 72 10 80       	push   $0x8010725f
8010178c:	e8 df eb ff ff       	call   80100370 <panic>
80101791:	eb 0d                	jmp    801017a0 <iput>
80101793:	90                   	nop
80101794:	90                   	nop
80101795:	90                   	nop
80101796:	90                   	nop
80101797:	90                   	nop
80101798:	90                   	nop
80101799:	90                   	nop
8010179a:	90                   	nop
8010179b:	90                   	nop
8010179c:	90                   	nop
8010179d:	90                   	nop
8010179e:	90                   	nop
8010179f:	90                   	nop

801017a0 <iput>:
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	57                   	push   %edi
801017a4:	56                   	push   %esi
801017a5:	53                   	push   %ebx
801017a6:	83 ec 28             	sub    $0x28,%esp
801017a9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801017ac:	8d 7e 0c             	lea    0xc(%esi),%edi
801017af:	57                   	push   %edi
801017b0:	e8 9b 29 00 00       	call   80104150 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017b5:	8b 56 4c             	mov    0x4c(%esi),%edx
801017b8:	83 c4 10             	add    $0x10,%esp
801017bb:	85 d2                	test   %edx,%edx
801017bd:	74 07                	je     801017c6 <iput+0x26>
801017bf:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801017c4:	74 32                	je     801017f8 <iput+0x58>
  releasesleep(&ip->lock);
801017c6:	83 ec 0c             	sub    $0xc,%esp
801017c9:	57                   	push   %edi
801017ca:	e8 e1 29 00 00       	call   801041b0 <releasesleep>
  acquire(&icache.lock);
801017cf:	c7 04 24 40 0a 11 80 	movl   $0x80110a40,(%esp)
801017d6:	e8 c5 2b 00 00       	call   801043a0 <acquire>
  ip->ref--;
801017db:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
801017df:	83 c4 10             	add    $0x10,%esp
801017e2:	c7 45 08 40 0a 11 80 	movl   $0x80110a40,0x8(%ebp)
}
801017e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017ec:	5b                   	pop    %ebx
801017ed:	5e                   	pop    %esi
801017ee:	5f                   	pop    %edi
801017ef:	5d                   	pop    %ebp
  release(&icache.lock);
801017f0:	e9 5b 2c 00 00       	jmp    80104450 <release>
801017f5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
801017f8:	83 ec 0c             	sub    $0xc,%esp
801017fb:	68 40 0a 11 80       	push   $0x80110a40
80101800:	e8 9b 2b 00 00       	call   801043a0 <acquire>
    int r = ip->ref;
80101805:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
80101808:	c7 04 24 40 0a 11 80 	movl   $0x80110a40,(%esp)
8010180f:	e8 3c 2c 00 00       	call   80104450 <release>
    if(r == 1){
80101814:	83 c4 10             	add    $0x10,%esp
80101817:	83 fb 01             	cmp    $0x1,%ebx
8010181a:	75 aa                	jne    801017c6 <iput+0x26>
8010181c:	8d 8e 8c 00 00 00    	lea    0x8c(%esi),%ecx
80101822:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101825:	8d 5e 5c             	lea    0x5c(%esi),%ebx
80101828:	89 cf                	mov    %ecx,%edi
8010182a:	eb 0b                	jmp    80101837 <iput+0x97>
8010182c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101830:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101833:	39 fb                	cmp    %edi,%ebx
80101835:	74 19                	je     80101850 <iput+0xb0>
    if(ip->addrs[i]){
80101837:	8b 13                	mov    (%ebx),%edx
80101839:	85 d2                	test   %edx,%edx
8010183b:	74 f3                	je     80101830 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010183d:	8b 06                	mov    (%esi),%eax
8010183f:	e8 ac fb ff ff       	call   801013f0 <bfree>
      ip->addrs[i] = 0;
80101844:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010184a:	eb e4                	jmp    80101830 <iput+0x90>
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101850:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101856:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101859:	85 c0                	test   %eax,%eax
8010185b:	75 33                	jne    80101890 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010185d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101860:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101867:	56                   	push   %esi
80101868:	e8 53 fd ff ff       	call   801015c0 <iupdate>
      ip->type = 0;
8010186d:	31 c0                	xor    %eax,%eax
8010186f:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101873:	89 34 24             	mov    %esi,(%esp)
80101876:	e8 45 fd ff ff       	call   801015c0 <iupdate>
      ip->valid = 0;
8010187b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101882:	83 c4 10             	add    $0x10,%esp
80101885:	e9 3c ff ff ff       	jmp    801017c6 <iput+0x26>
8010188a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101890:	83 ec 08             	sub    $0x8,%esp
80101893:	50                   	push   %eax
80101894:	ff 36                	pushl  (%esi)
80101896:	e8 35 e8 ff ff       	call   801000d0 <bread>
8010189b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018a1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018a7:	8d 58 5c             	lea    0x5c(%eax),%ebx
801018aa:	83 c4 10             	add    $0x10,%esp
801018ad:	89 cf                	mov    %ecx,%edi
801018af:	eb 0e                	jmp    801018bf <iput+0x11f>
801018b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018b8:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
801018bb:	39 fb                	cmp    %edi,%ebx
801018bd:	74 0f                	je     801018ce <iput+0x12e>
      if(a[j])
801018bf:	8b 13                	mov    (%ebx),%edx
801018c1:	85 d2                	test   %edx,%edx
801018c3:	74 f3                	je     801018b8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018c5:	8b 06                	mov    (%esi),%eax
801018c7:	e8 24 fb ff ff       	call   801013f0 <bfree>
801018cc:	eb ea                	jmp    801018b8 <iput+0x118>
    brelse(bp);
801018ce:	83 ec 0c             	sub    $0xc,%esp
801018d1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018d4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018d7:	e8 04 e9 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018dc:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018e2:	8b 06                	mov    (%esi),%eax
801018e4:	e8 07 fb ff ff       	call   801013f0 <bfree>
    ip->addrs[NDIRECT] = 0;
801018e9:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801018f0:	00 00 00 
801018f3:	83 c4 10             	add    $0x10,%esp
801018f6:	e9 62 ff ff ff       	jmp    8010185d <iput+0xbd>
801018fb:	90                   	nop
801018fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101900 <iunlockput>:
{
80101900:	55                   	push   %ebp
80101901:	89 e5                	mov    %esp,%ebp
80101903:	53                   	push   %ebx
80101904:	83 ec 10             	sub    $0x10,%esp
80101907:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010190a:	53                   	push   %ebx
8010190b:	e8 40 fe ff ff       	call   80101750 <iunlock>
  iput(ip);
80101910:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101913:	83 c4 10             	add    $0x10,%esp
}
80101916:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101919:	c9                   	leave  
  iput(ip);
8010191a:	e9 81 fe ff ff       	jmp    801017a0 <iput>
8010191f:	90                   	nop

80101920 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	8b 55 08             	mov    0x8(%ebp),%edx
80101926:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101929:	8b 0a                	mov    (%edx),%ecx
8010192b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010192e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101931:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101934:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101938:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010193b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010193f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101943:	8b 52 58             	mov    0x58(%edx),%edx
80101946:	89 50 10             	mov    %edx,0x10(%eax)
}
80101949:	5d                   	pop    %ebp
8010194a:	c3                   	ret    
8010194b:	90                   	nop
8010194c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101950 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	57                   	push   %edi
80101954:	56                   	push   %esi
80101955:	53                   	push   %ebx
80101956:	83 ec 1c             	sub    $0x1c,%esp
80101959:	8b 45 08             	mov    0x8(%ebp),%eax
8010195c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010195f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101962:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101967:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010196a:	8b 7d 14             	mov    0x14(%ebp),%edi
8010196d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101970:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101973:	0f 84 a7 00 00 00    	je     80101a20 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101979:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010197c:	8b 40 58             	mov    0x58(%eax),%eax
8010197f:	39 f0                	cmp    %esi,%eax
80101981:	0f 82 ba 00 00 00    	jb     80101a41 <readi+0xf1>
80101987:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010198a:	89 f9                	mov    %edi,%ecx
8010198c:	01 f1                	add    %esi,%ecx
8010198e:	0f 82 ad 00 00 00    	jb     80101a41 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101994:	89 c2                	mov    %eax,%edx
80101996:	29 f2                	sub    %esi,%edx
80101998:	39 c8                	cmp    %ecx,%eax
8010199a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010199d:	31 ff                	xor    %edi,%edi
8010199f:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019a1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019a4:	74 6c                	je     80101a12 <readi+0xc2>
801019a6:	8d 76 00             	lea    0x0(%esi),%esi
801019a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019b0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019b3:	89 f2                	mov    %esi,%edx
801019b5:	c1 ea 09             	shr    $0x9,%edx
801019b8:	89 d8                	mov    %ebx,%eax
801019ba:	e8 21 f9 ff ff       	call   801012e0 <bmap>
801019bf:	83 ec 08             	sub    $0x8,%esp
801019c2:	50                   	push   %eax
801019c3:	ff 33                	pushl  (%ebx)
801019c5:	e8 06 e7 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019ca:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019cd:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019cf:	89 f0                	mov    %esi,%eax
801019d1:	25 ff 01 00 00       	and    $0x1ff,%eax
801019d6:	b9 00 02 00 00       	mov    $0x200,%ecx
801019db:	83 c4 0c             	add    $0xc,%esp
801019de:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
801019e0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
801019e4:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801019e7:	29 fb                	sub    %edi,%ebx
801019e9:	39 d9                	cmp    %ebx,%ecx
801019eb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019ee:	53                   	push   %ebx
801019ef:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019f0:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
801019f2:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019f5:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
801019f7:	e8 54 2b 00 00       	call   80104550 <memmove>
    brelse(bp);
801019fc:	8b 55 dc             	mov    -0x24(%ebp),%edx
801019ff:	89 14 24             	mov    %edx,(%esp)
80101a02:	e8 d9 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a07:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a0a:	83 c4 10             	add    $0x10,%esp
80101a0d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a10:	77 9e                	ja     801019b0 <readi+0x60>
  }
  return n;
80101a12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a15:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a18:	5b                   	pop    %ebx
80101a19:	5e                   	pop    %esi
80101a1a:	5f                   	pop    %edi
80101a1b:	5d                   	pop    %ebp
80101a1c:	c3                   	ret    
80101a1d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a20:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a24:	66 83 f8 09          	cmp    $0x9,%ax
80101a28:	77 17                	ja     80101a41 <readi+0xf1>
80101a2a:	8b 04 c5 c0 09 11 80 	mov    -0x7feef640(,%eax,8),%eax
80101a31:	85 c0                	test   %eax,%eax
80101a33:	74 0c                	je     80101a41 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a35:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a3b:	5b                   	pop    %ebx
80101a3c:	5e                   	pop    %esi
80101a3d:	5f                   	pop    %edi
80101a3e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a3f:	ff e0                	jmp    *%eax
      return -1;
80101a41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a46:	eb cd                	jmp    80101a15 <readi+0xc5>
80101a48:	90                   	nop
80101a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a50 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a50:	55                   	push   %ebp
80101a51:	89 e5                	mov    %esp,%ebp
80101a53:	57                   	push   %edi
80101a54:	56                   	push   %esi
80101a55:	53                   	push   %ebx
80101a56:	83 ec 1c             	sub    $0x1c,%esp
80101a59:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a5f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a62:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a67:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a6a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a6d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a70:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a73:	0f 84 b7 00 00 00    	je     80101b30 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a79:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a7c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a7f:	0f 82 eb 00 00 00    	jb     80101b70 <writei+0x120>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a85:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101a88:	89 c8                	mov    %ecx,%eax
80101a8a:	01 f0                	add    %esi,%eax
80101a8c:	0f 82 de 00 00 00    	jb     80101b70 <writei+0x120>
80101a92:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101a97:	0f 87 d3 00 00 00    	ja     80101b70 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a9d:	85 c9                	test   %ecx,%ecx
80101a9f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101aa6:	74 79                	je     80101b21 <writei+0xd1>
80101aa8:	90                   	nop
80101aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ab0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ab3:	89 f2                	mov    %esi,%edx
80101ab5:	c1 ea 09             	shr    $0x9,%edx
80101ab8:	89 f8                	mov    %edi,%eax
80101aba:	e8 21 f8 ff ff       	call   801012e0 <bmap>
80101abf:	83 ec 08             	sub    $0x8,%esp
80101ac2:	50                   	push   %eax
80101ac3:	ff 37                	pushl  (%edi)
80101ac5:	e8 06 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aca:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101acd:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ad2:	89 f0                	mov    %esi,%eax
80101ad4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ad9:	83 c4 0c             	add    $0xc,%esp
80101adc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ae1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101ae3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae7:	39 d9                	cmp    %ebx,%ecx
80101ae9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101aec:	53                   	push   %ebx
80101aed:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101af0:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101af2:	50                   	push   %eax
80101af3:	e8 58 2a 00 00       	call   80104550 <memmove>
    log_write(bp);
80101af8:	89 3c 24             	mov    %edi,(%esp)
80101afb:	e8 50 12 00 00       	call   80102d50 <log_write>
    brelse(bp);
80101b00:	89 3c 24             	mov    %edi,(%esp)
80101b03:	e8 d8 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b08:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b0b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b0e:	83 c4 10             	add    $0x10,%esp
80101b11:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101b14:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101b17:	77 97                	ja     80101ab0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b19:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b1c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b1f:	77 37                	ja     80101b58 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b21:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b24:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b27:	5b                   	pop    %ebx
80101b28:	5e                   	pop    %esi
80101b29:	5f                   	pop    %edi
80101b2a:	5d                   	pop    %ebp
80101b2b:	c3                   	ret    
80101b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b34:	66 83 f8 09          	cmp    $0x9,%ax
80101b38:	77 36                	ja     80101b70 <writei+0x120>
80101b3a:	8b 04 c5 c4 09 11 80 	mov    -0x7feef63c(,%eax,8),%eax
80101b41:	85 c0                	test   %eax,%eax
80101b43:	74 2b                	je     80101b70 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b45:	89 4d 10             	mov    %ecx,0x10(%ebp)
}
80101b48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b4b:	5b                   	pop    %ebx
80101b4c:	5e                   	pop    %esi
80101b4d:	5f                   	pop    %edi
80101b4e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b4f:	ff e0                	jmp    *%eax
80101b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b58:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b5b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b5e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b61:	50                   	push   %eax
80101b62:	e8 59 fa ff ff       	call   801015c0 <iupdate>
80101b67:	83 c4 10             	add    $0x10,%esp
80101b6a:	eb b5                	jmp    80101b21 <writei+0xd1>
80101b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101b70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b75:	eb ad                	jmp    80101b24 <writei+0xd4>
80101b77:	89 f6                	mov    %esi,%esi
80101b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b80 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b80:	55                   	push   %ebp
80101b81:	89 e5                	mov    %esp,%ebp
80101b83:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b86:	6a 0e                	push   $0xe
80101b88:	ff 75 0c             	pushl  0xc(%ebp)
80101b8b:	ff 75 08             	pushl  0x8(%ebp)
80101b8e:	e8 2d 2a 00 00       	call   801045c0 <strncmp>
}
80101b93:	c9                   	leave  
80101b94:	c3                   	ret    
80101b95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ba0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	57                   	push   %edi
80101ba4:	56                   	push   %esi
80101ba5:	53                   	push   %ebx
80101ba6:	83 ec 1c             	sub    $0x1c,%esp
80101ba9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bac:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bb1:	0f 85 80 00 00 00    	jne    80101c37 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bb7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bba:	31 ff                	xor    %edi,%edi
80101bbc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bbf:	85 d2                	test   %edx,%edx
80101bc1:	75 0d                	jne    80101bd0 <dirlookup+0x30>
80101bc3:	eb 5b                	jmp    80101c20 <dirlookup+0x80>
80101bc5:	8d 76 00             	lea    0x0(%esi),%esi
80101bc8:	83 c7 10             	add    $0x10,%edi
80101bcb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bce:	76 50                	jbe    80101c20 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bd0:	6a 10                	push   $0x10
80101bd2:	57                   	push   %edi
80101bd3:	56                   	push   %esi
80101bd4:	53                   	push   %ebx
80101bd5:	e8 76 fd ff ff       	call   80101950 <readi>
80101bda:	83 c4 10             	add    $0x10,%esp
80101bdd:	83 f8 10             	cmp    $0x10,%eax
80101be0:	75 48                	jne    80101c2a <dirlookup+0x8a>
      panic("dirlookup read");
    if(de.inum == 0)
80101be2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101be7:	74 df                	je     80101bc8 <dirlookup+0x28>
  return strncmp(s, t, DIRSIZ);
80101be9:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bec:	83 ec 04             	sub    $0x4,%esp
80101bef:	6a 0e                	push   $0xe
80101bf1:	50                   	push   %eax
80101bf2:	ff 75 0c             	pushl  0xc(%ebp)
80101bf5:	e8 c6 29 00 00       	call   801045c0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101bfa:	83 c4 10             	add    $0x10,%esp
80101bfd:	85 c0                	test   %eax,%eax
80101bff:	75 c7                	jne    80101bc8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c01:	8b 45 10             	mov    0x10(%ebp),%eax
80101c04:	85 c0                	test   %eax,%eax
80101c06:	74 05                	je     80101c0d <dirlookup+0x6d>
        *poff = off;
80101c08:	8b 45 10             	mov    0x10(%ebp),%eax
80101c0b:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c0d:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c11:	8b 03                	mov    (%ebx),%eax
80101c13:	e8 f8 f5 ff ff       	call   80101210 <iget>
    }
  }

  return 0;
}
80101c18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c1b:	5b                   	pop    %ebx
80101c1c:	5e                   	pop    %esi
80101c1d:	5f                   	pop    %edi
80101c1e:	5d                   	pop    %ebp
80101c1f:	c3                   	ret    
80101c20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c23:	31 c0                	xor    %eax,%eax
}
80101c25:	5b                   	pop    %ebx
80101c26:	5e                   	pop    %esi
80101c27:	5f                   	pop    %edi
80101c28:	5d                   	pop    %ebp
80101c29:	c3                   	ret    
      panic("dirlookup read");
80101c2a:	83 ec 0c             	sub    $0xc,%esp
80101c2d:	68 79 72 10 80       	push   $0x80107279
80101c32:	e8 39 e7 ff ff       	call   80100370 <panic>
    panic("dirlookup not DIR");
80101c37:	83 ec 0c             	sub    $0xc,%esp
80101c3a:	68 67 72 10 80       	push   $0x80107267
80101c3f:	e8 2c e7 ff ff       	call   80100370 <panic>
80101c44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101c4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101c50 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c50:	55                   	push   %ebp
80101c51:	89 e5                	mov    %esp,%ebp
80101c53:	57                   	push   %edi
80101c54:	56                   	push   %esi
80101c55:	53                   	push   %ebx
80101c56:	89 cf                	mov    %ecx,%edi
80101c58:	89 c3                	mov    %eax,%ebx
80101c5a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c5d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c60:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c63:	0f 84 55 01 00 00    	je     80101dbe <namex+0x16e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c69:	e8 82 1b 00 00       	call   801037f0 <myproc>
  acquire(&icache.lock);
80101c6e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101c71:	8b 70 6c             	mov    0x6c(%eax),%esi
  acquire(&icache.lock);
80101c74:	68 40 0a 11 80       	push   $0x80110a40
80101c79:	e8 22 27 00 00       	call   801043a0 <acquire>
  ip->ref++;
80101c7e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c82:	c7 04 24 40 0a 11 80 	movl   $0x80110a40,(%esp)
80101c89:	e8 c2 27 00 00       	call   80104450 <release>
80101c8e:	83 c4 10             	add    $0x10,%esp
80101c91:	eb 08                	jmp    80101c9b <namex+0x4b>
80101c93:	90                   	nop
80101c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101c98:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101c9b:	0f b6 03             	movzbl (%ebx),%eax
80101c9e:	3c 2f                	cmp    $0x2f,%al
80101ca0:	74 f6                	je     80101c98 <namex+0x48>
  if(*path == 0)
80101ca2:	84 c0                	test   %al,%al
80101ca4:	0f 84 e3 00 00 00    	je     80101d8d <namex+0x13d>
  while(*path != '/' && *path != 0)
80101caa:	0f b6 03             	movzbl (%ebx),%eax
80101cad:	89 da                	mov    %ebx,%edx
80101caf:	84 c0                	test   %al,%al
80101cb1:	0f 84 ac 00 00 00    	je     80101d63 <namex+0x113>
80101cb7:	3c 2f                	cmp    $0x2f,%al
80101cb9:	75 09                	jne    80101cc4 <namex+0x74>
80101cbb:	e9 a3 00 00 00       	jmp    80101d63 <namex+0x113>
80101cc0:	84 c0                	test   %al,%al
80101cc2:	74 0a                	je     80101cce <namex+0x7e>
    path++;
80101cc4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101cc7:	0f b6 02             	movzbl (%edx),%eax
80101cca:	3c 2f                	cmp    $0x2f,%al
80101ccc:	75 f2                	jne    80101cc0 <namex+0x70>
80101cce:	89 d1                	mov    %edx,%ecx
80101cd0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101cd2:	83 f9 0d             	cmp    $0xd,%ecx
80101cd5:	0f 8e 8d 00 00 00    	jle    80101d68 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101cdb:	83 ec 04             	sub    $0x4,%esp
80101cde:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101ce1:	6a 0e                	push   $0xe
80101ce3:	53                   	push   %ebx
80101ce4:	57                   	push   %edi
80101ce5:	e8 66 28 00 00       	call   80104550 <memmove>
    path++;
80101cea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101ced:	83 c4 10             	add    $0x10,%esp
    path++;
80101cf0:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101cf2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101cf5:	75 11                	jne    80101d08 <namex+0xb8>
80101cf7:	89 f6                	mov    %esi,%esi
80101cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d00:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d03:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d06:	74 f8                	je     80101d00 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d08:	83 ec 0c             	sub    $0xc,%esp
80101d0b:	56                   	push   %esi
80101d0c:	e8 5f f9 ff ff       	call   80101670 <ilock>
    if(ip->type != T_DIR){
80101d11:	83 c4 10             	add    $0x10,%esp
80101d14:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d19:	0f 85 7f 00 00 00    	jne    80101d9e <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d1f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d22:	85 d2                	test   %edx,%edx
80101d24:	74 09                	je     80101d2f <namex+0xdf>
80101d26:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d29:	0f 84 a5 00 00 00    	je     80101dd4 <namex+0x184>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d2f:	83 ec 04             	sub    $0x4,%esp
80101d32:	6a 00                	push   $0x0
80101d34:	57                   	push   %edi
80101d35:	56                   	push   %esi
80101d36:	e8 65 fe ff ff       	call   80101ba0 <dirlookup>
80101d3b:	83 c4 10             	add    $0x10,%esp
80101d3e:	85 c0                	test   %eax,%eax
80101d40:	74 5c                	je     80101d9e <namex+0x14e>
  iunlock(ip);
80101d42:	83 ec 0c             	sub    $0xc,%esp
80101d45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d48:	56                   	push   %esi
80101d49:	e8 02 fa ff ff       	call   80101750 <iunlock>
  iput(ip);
80101d4e:	89 34 24             	mov    %esi,(%esp)
80101d51:	e8 4a fa ff ff       	call   801017a0 <iput>
80101d56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d59:	83 c4 10             	add    $0x10,%esp
80101d5c:	89 c6                	mov    %eax,%esi
80101d5e:	e9 38 ff ff ff       	jmp    80101c9b <namex+0x4b>
  while(*path != '/' && *path != 0)
80101d63:	31 c9                	xor    %ecx,%ecx
80101d65:	8d 76 00             	lea    0x0(%esi),%esi
    memmove(name, s, len);
80101d68:	83 ec 04             	sub    $0x4,%esp
80101d6b:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d6e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d71:	51                   	push   %ecx
80101d72:	53                   	push   %ebx
80101d73:	57                   	push   %edi
80101d74:	e8 d7 27 00 00       	call   80104550 <memmove>
    name[len] = 0;
80101d79:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d7c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d7f:	83 c4 10             	add    $0x10,%esp
80101d82:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d86:	89 d3                	mov    %edx,%ebx
80101d88:	e9 65 ff ff ff       	jmp    80101cf2 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101d8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101d90:	85 c0                	test   %eax,%eax
80101d92:	75 56                	jne    80101dea <namex+0x19a>
    iput(ip);
    return 0;
  }
  return ip;
}
80101d94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d97:	89 f0                	mov    %esi,%eax
80101d99:	5b                   	pop    %ebx
80101d9a:	5e                   	pop    %esi
80101d9b:	5f                   	pop    %edi
80101d9c:	5d                   	pop    %ebp
80101d9d:	c3                   	ret    
  iunlock(ip);
80101d9e:	83 ec 0c             	sub    $0xc,%esp
80101da1:	56                   	push   %esi
80101da2:	e8 a9 f9 ff ff       	call   80101750 <iunlock>
  iput(ip);
80101da7:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101daa:	31 f6                	xor    %esi,%esi
  iput(ip);
80101dac:	e8 ef f9 ff ff       	call   801017a0 <iput>
      return 0;
80101db1:	83 c4 10             	add    $0x10,%esp
}
80101db4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101db7:	89 f0                	mov    %esi,%eax
80101db9:	5b                   	pop    %ebx
80101dba:	5e                   	pop    %esi
80101dbb:	5f                   	pop    %edi
80101dbc:	5d                   	pop    %ebp
80101dbd:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101dbe:	ba 01 00 00 00       	mov    $0x1,%edx
80101dc3:	b8 01 00 00 00       	mov    $0x1,%eax
80101dc8:	e8 43 f4 ff ff       	call   80101210 <iget>
80101dcd:	89 c6                	mov    %eax,%esi
80101dcf:	e9 c7 fe ff ff       	jmp    80101c9b <namex+0x4b>
      iunlock(ip);
80101dd4:	83 ec 0c             	sub    $0xc,%esp
80101dd7:	56                   	push   %esi
80101dd8:	e8 73 f9 ff ff       	call   80101750 <iunlock>
      return ip;
80101ddd:	83 c4 10             	add    $0x10,%esp
}
80101de0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101de3:	89 f0                	mov    %esi,%eax
80101de5:	5b                   	pop    %ebx
80101de6:	5e                   	pop    %esi
80101de7:	5f                   	pop    %edi
80101de8:	5d                   	pop    %ebp
80101de9:	c3                   	ret    
    iput(ip);
80101dea:	83 ec 0c             	sub    $0xc,%esp
80101ded:	56                   	push   %esi
    return 0;
80101dee:	31 f6                	xor    %esi,%esi
    iput(ip);
80101df0:	e8 ab f9 ff ff       	call   801017a0 <iput>
    return 0;
80101df5:	83 c4 10             	add    $0x10,%esp
80101df8:	eb 9a                	jmp    80101d94 <namex+0x144>
80101dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101e00 <dirlink>:
{
80101e00:	55                   	push   %ebp
80101e01:	89 e5                	mov    %esp,%ebp
80101e03:	57                   	push   %edi
80101e04:	56                   	push   %esi
80101e05:	53                   	push   %ebx
80101e06:	83 ec 20             	sub    $0x20,%esp
80101e09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e0c:	6a 00                	push   $0x0
80101e0e:	ff 75 0c             	pushl  0xc(%ebp)
80101e11:	53                   	push   %ebx
80101e12:	e8 89 fd ff ff       	call   80101ba0 <dirlookup>
80101e17:	83 c4 10             	add    $0x10,%esp
80101e1a:	85 c0                	test   %eax,%eax
80101e1c:	75 67                	jne    80101e85 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e1e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e21:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e24:	85 ff                	test   %edi,%edi
80101e26:	74 29                	je     80101e51 <dirlink+0x51>
80101e28:	31 ff                	xor    %edi,%edi
80101e2a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e2d:	eb 09                	jmp    80101e38 <dirlink+0x38>
80101e2f:	90                   	nop
80101e30:	83 c7 10             	add    $0x10,%edi
80101e33:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101e36:	76 19                	jbe    80101e51 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e38:	6a 10                	push   $0x10
80101e3a:	57                   	push   %edi
80101e3b:	56                   	push   %esi
80101e3c:	53                   	push   %ebx
80101e3d:	e8 0e fb ff ff       	call   80101950 <readi>
80101e42:	83 c4 10             	add    $0x10,%esp
80101e45:	83 f8 10             	cmp    $0x10,%eax
80101e48:	75 4e                	jne    80101e98 <dirlink+0x98>
    if(de.inum == 0)
80101e4a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e4f:	75 df                	jne    80101e30 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101e51:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e54:	83 ec 04             	sub    $0x4,%esp
80101e57:	6a 0e                	push   $0xe
80101e59:	ff 75 0c             	pushl  0xc(%ebp)
80101e5c:	50                   	push   %eax
80101e5d:	e8 be 27 00 00       	call   80104620 <strncpy>
  de.inum = inum;
80101e62:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e65:	6a 10                	push   $0x10
80101e67:	57                   	push   %edi
80101e68:	56                   	push   %esi
80101e69:	53                   	push   %ebx
  de.inum = inum;
80101e6a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e6e:	e8 dd fb ff ff       	call   80101a50 <writei>
80101e73:	83 c4 20             	add    $0x20,%esp
80101e76:	83 f8 10             	cmp    $0x10,%eax
80101e79:	75 2a                	jne    80101ea5 <dirlink+0xa5>
  return 0;
80101e7b:	31 c0                	xor    %eax,%eax
}
80101e7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e80:	5b                   	pop    %ebx
80101e81:	5e                   	pop    %esi
80101e82:	5f                   	pop    %edi
80101e83:	5d                   	pop    %ebp
80101e84:	c3                   	ret    
    iput(ip);
80101e85:	83 ec 0c             	sub    $0xc,%esp
80101e88:	50                   	push   %eax
80101e89:	e8 12 f9 ff ff       	call   801017a0 <iput>
    return -1;
80101e8e:	83 c4 10             	add    $0x10,%esp
80101e91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e96:	eb e5                	jmp    80101e7d <dirlink+0x7d>
      panic("dirlink read");
80101e98:	83 ec 0c             	sub    $0xc,%esp
80101e9b:	68 88 72 10 80       	push   $0x80107288
80101ea0:	e8 cb e4 ff ff       	call   80100370 <panic>
    panic("dirlink");
80101ea5:	83 ec 0c             	sub    $0xc,%esp
80101ea8:	68 92 78 10 80       	push   $0x80107892
80101ead:	e8 be e4 ff ff       	call   80100370 <panic>
80101eb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ec0 <namei>:

struct inode*
namei(char *path)
{
80101ec0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ec1:	31 d2                	xor    %edx,%edx
{
80101ec3:	89 e5                	mov    %esp,%ebp
80101ec5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101ec8:	8b 45 08             	mov    0x8(%ebp),%eax
80101ecb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101ece:	e8 7d fd ff ff       	call   80101c50 <namex>
}
80101ed3:	c9                   	leave  
80101ed4:	c3                   	ret    
80101ed5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ee0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101ee0:	55                   	push   %ebp
  return namex(path, 1, name);
80101ee1:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101ee6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101ee8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101eeb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101eee:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101eef:	e9 5c fd ff ff       	jmp    80101c50 <namex>
80101ef4:	66 90                	xchg   %ax,%ax
80101ef6:	66 90                	xchg   %ax,%ax
80101ef8:	66 90                	xchg   %ax,%ax
80101efa:	66 90                	xchg   %ax,%ax
80101efc:	66 90                	xchg   %ax,%ax
80101efe:	66 90                	xchg   %ax,%ax

80101f00 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f00:	55                   	push   %ebp
  if(b == 0)
80101f01:	85 c0                	test   %eax,%eax
{
80101f03:	89 e5                	mov    %esp,%ebp
80101f05:	56                   	push   %esi
80101f06:	53                   	push   %ebx
  if(b == 0)
80101f07:	0f 84 ad 00 00 00    	je     80101fba <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f0d:	8b 58 08             	mov    0x8(%eax),%ebx
80101f10:	89 c1                	mov    %eax,%ecx
80101f12:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f18:	0f 87 8f 00 00 00    	ja     80101fad <idestart+0xad>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f1e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f23:	90                   	nop
80101f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f28:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f29:	83 e0 c0             	and    $0xffffffc0,%eax
80101f2c:	3c 40                	cmp    $0x40,%al
80101f2e:	75 f8                	jne    80101f28 <idestart+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f30:	31 f6                	xor    %esi,%esi
80101f32:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f37:	89 f0                	mov    %esi,%eax
80101f39:	ee                   	out    %al,(%dx)
80101f3a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f3f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f44:	ee                   	out    %al,(%dx)
80101f45:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f4a:	89 d8                	mov    %ebx,%eax
80101f4c:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f4d:	89 d8                	mov    %ebx,%eax
80101f4f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f54:	c1 f8 08             	sar    $0x8,%eax
80101f57:	ee                   	out    %al,(%dx)
80101f58:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f5d:	89 f0                	mov    %esi,%eax
80101f5f:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f60:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80101f64:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f69:	c1 e0 04             	shl    $0x4,%eax
80101f6c:	83 e0 10             	and    $0x10,%eax
80101f6f:	83 c8 e0             	or     $0xffffffe0,%eax
80101f72:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101f73:	f6 01 04             	testb  $0x4,(%ecx)
80101f76:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f7b:	75 13                	jne    80101f90 <idestart+0x90>
80101f7d:	b8 20 00 00 00       	mov    $0x20,%eax
80101f82:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f83:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f86:	5b                   	pop    %ebx
80101f87:	5e                   	pop    %esi
80101f88:	5d                   	pop    %ebp
80101f89:	c3                   	ret    
80101f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f90:	b8 30 00 00 00       	mov    $0x30,%eax
80101f95:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101f96:	ba f0 01 00 00       	mov    $0x1f0,%edx
    outsl(0x1f0, b->data, BSIZE/4);
80101f9b:	8d 71 5c             	lea    0x5c(%ecx),%esi
80101f9e:	b9 80 00 00 00       	mov    $0x80,%ecx
80101fa3:	fc                   	cld    
80101fa4:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101fa6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101fa9:	5b                   	pop    %ebx
80101faa:	5e                   	pop    %esi
80101fab:	5d                   	pop    %ebp
80101fac:	c3                   	ret    
    panic("incorrect blockno");
80101fad:	83 ec 0c             	sub    $0xc,%esp
80101fb0:	68 f4 72 10 80       	push   $0x801072f4
80101fb5:	e8 b6 e3 ff ff       	call   80100370 <panic>
    panic("idestart");
80101fba:	83 ec 0c             	sub    $0xc,%esp
80101fbd:	68 eb 72 10 80       	push   $0x801072eb
80101fc2:	e8 a9 e3 ff ff       	call   80100370 <panic>
80101fc7:	89 f6                	mov    %esi,%esi
80101fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fd0 <ideinit>:
{
80101fd0:	55                   	push   %ebp
80101fd1:	89 e5                	mov    %esp,%ebp
80101fd3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80101fd6:	68 06 73 10 80       	push   $0x80107306
80101fdb:	68 80 a5 10 80       	push   $0x8010a580
80101fe0:	e8 5b 22 00 00       	call   80104240 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101fe5:	58                   	pop    %eax
80101fe6:	a1 60 2d 11 80       	mov    0x80112d60,%eax
80101feb:	5a                   	pop    %edx
80101fec:	83 e8 01             	sub    $0x1,%eax
80101fef:	50                   	push   %eax
80101ff0:	6a 0e                	push   $0xe
80101ff2:	e8 a9 02 00 00       	call   801022a0 <ioapicenable>
80101ff7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101ffa:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fff:	90                   	nop
80102000:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102001:	83 e0 c0             	and    $0xffffffc0,%eax
80102004:	3c 40                	cmp    $0x40,%al
80102006:	75 f8                	jne    80102000 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102008:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010200d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102012:	ee                   	out    %al,(%dx)
80102013:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102018:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010201d:	eb 06                	jmp    80102025 <ideinit+0x55>
8010201f:	90                   	nop
  for(i=0; i<1000; i++){
80102020:	83 e9 01             	sub    $0x1,%ecx
80102023:	74 0f                	je     80102034 <ideinit+0x64>
80102025:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102026:	84 c0                	test   %al,%al
80102028:	74 f6                	je     80102020 <ideinit+0x50>
      havedisk1 = 1;
8010202a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102031:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102034:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102039:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
8010203e:	ee                   	out    %al,(%dx)
}
8010203f:	c9                   	leave  
80102040:	c3                   	ret    
80102041:	eb 0d                	jmp    80102050 <ideintr>
80102043:	90                   	nop
80102044:	90                   	nop
80102045:	90                   	nop
80102046:	90                   	nop
80102047:	90                   	nop
80102048:	90                   	nop
80102049:	90                   	nop
8010204a:	90                   	nop
8010204b:	90                   	nop
8010204c:	90                   	nop
8010204d:	90                   	nop
8010204e:	90                   	nop
8010204f:	90                   	nop

80102050 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102050:	55                   	push   %ebp
80102051:	89 e5                	mov    %esp,%ebp
80102053:	57                   	push   %edi
80102054:	56                   	push   %esi
80102055:	53                   	push   %ebx
80102056:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102059:	68 80 a5 10 80       	push   $0x8010a580
8010205e:	e8 3d 23 00 00       	call   801043a0 <acquire>

  if((b = idequeue) == 0){
80102063:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102069:	83 c4 10             	add    $0x10,%esp
8010206c:	85 db                	test   %ebx,%ebx
8010206e:	74 34                	je     801020a4 <ideintr+0x54>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102070:	8b 43 58             	mov    0x58(%ebx),%eax
80102073:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102078:	8b 33                	mov    (%ebx),%esi
8010207a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102080:	74 3e                	je     801020c0 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102082:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102085:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102088:	83 ce 02             	or     $0x2,%esi
8010208b:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010208d:	53                   	push   %ebx
8010208e:	e8 cd 1e 00 00       	call   80103f60 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102093:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102098:	83 c4 10             	add    $0x10,%esp
8010209b:	85 c0                	test   %eax,%eax
8010209d:	74 05                	je     801020a4 <ideintr+0x54>
    idestart(idequeue);
8010209f:	e8 5c fe ff ff       	call   80101f00 <idestart>
    release(&idelock);
801020a4:	83 ec 0c             	sub    $0xc,%esp
801020a7:	68 80 a5 10 80       	push   $0x8010a580
801020ac:	e8 9f 23 00 00       	call   80104450 <release>

  release(&idelock);
}
801020b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020b4:	5b                   	pop    %ebx
801020b5:	5e                   	pop    %esi
801020b6:	5f                   	pop    %edi
801020b7:	5d                   	pop    %ebp
801020b8:	c3                   	ret    
801020b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020c0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020c5:	8d 76 00             	lea    0x0(%esi),%esi
801020c8:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020c9:	89 c1                	mov    %eax,%ecx
801020cb:	83 e1 c0             	and    $0xffffffc0,%ecx
801020ce:	80 f9 40             	cmp    $0x40,%cl
801020d1:	75 f5                	jne    801020c8 <ideintr+0x78>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020d3:	a8 21                	test   $0x21,%al
801020d5:	75 ab                	jne    80102082 <ideintr+0x32>
    insl(0x1f0, b->data, BSIZE/4);
801020d7:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801020da:	b9 80 00 00 00       	mov    $0x80,%ecx
801020df:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020e4:	fc                   	cld    
801020e5:	f3 6d                	rep insl (%dx),%es:(%edi)
801020e7:	8b 33                	mov    (%ebx),%esi
801020e9:	eb 97                	jmp    80102082 <ideintr+0x32>
801020eb:	90                   	nop
801020ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020f0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801020f0:	55                   	push   %ebp
801020f1:	89 e5                	mov    %esp,%ebp
801020f3:	53                   	push   %ebx
801020f4:	83 ec 10             	sub    $0x10,%esp
801020f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801020fa:	8d 43 0c             	lea    0xc(%ebx),%eax
801020fd:	50                   	push   %eax
801020fe:	e8 ed 20 00 00       	call   801041f0 <holdingsleep>
80102103:	83 c4 10             	add    $0x10,%esp
80102106:	85 c0                	test   %eax,%eax
80102108:	0f 84 ad 00 00 00    	je     801021bb <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010210e:	8b 03                	mov    (%ebx),%eax
80102110:	83 e0 06             	and    $0x6,%eax
80102113:	83 f8 02             	cmp    $0x2,%eax
80102116:	0f 84 b9 00 00 00    	je     801021d5 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010211c:	8b 53 04             	mov    0x4(%ebx),%edx
8010211f:	85 d2                	test   %edx,%edx
80102121:	74 0d                	je     80102130 <iderw+0x40>
80102123:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102128:	85 c0                	test   %eax,%eax
8010212a:	0f 84 98 00 00 00    	je     801021c8 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102130:	83 ec 0c             	sub    $0xc,%esp
80102133:	68 80 a5 10 80       	push   $0x8010a580
80102138:	e8 63 22 00 00       	call   801043a0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010213d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102143:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102146:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010214d:	85 d2                	test   %edx,%edx
8010214f:	75 09                	jne    8010215a <iderw+0x6a>
80102151:	eb 58                	jmp    801021ab <iderw+0xbb>
80102153:	90                   	nop
80102154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102158:	89 c2                	mov    %eax,%edx
8010215a:	8b 42 58             	mov    0x58(%edx),%eax
8010215d:	85 c0                	test   %eax,%eax
8010215f:	75 f7                	jne    80102158 <iderw+0x68>
80102161:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102164:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102166:	3b 1d 64 a5 10 80    	cmp    0x8010a564,%ebx
8010216c:	74 44                	je     801021b2 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010216e:	8b 03                	mov    (%ebx),%eax
80102170:	83 e0 06             	and    $0x6,%eax
80102173:	83 f8 02             	cmp    $0x2,%eax
80102176:	74 23                	je     8010219b <iderw+0xab>
80102178:	90                   	nop
80102179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102180:	83 ec 08             	sub    $0x8,%esp
80102183:	68 80 a5 10 80       	push   $0x8010a580
80102188:	53                   	push   %ebx
80102189:	e8 12 1c 00 00       	call   80103da0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010218e:	8b 03                	mov    (%ebx),%eax
80102190:	83 c4 10             	add    $0x10,%esp
80102193:	83 e0 06             	and    $0x6,%eax
80102196:	83 f8 02             	cmp    $0x2,%eax
80102199:	75 e5                	jne    80102180 <iderw+0x90>
  }


  release(&idelock);
8010219b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021a5:	c9                   	leave  
  release(&idelock);
801021a6:	e9 a5 22 00 00       	jmp    80104450 <release>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021ab:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
801021b0:	eb b2                	jmp    80102164 <iderw+0x74>
    idestart(b);
801021b2:	89 d8                	mov    %ebx,%eax
801021b4:	e8 47 fd ff ff       	call   80101f00 <idestart>
801021b9:	eb b3                	jmp    8010216e <iderw+0x7e>
    panic("iderw: buf not locked");
801021bb:	83 ec 0c             	sub    $0xc,%esp
801021be:	68 0a 73 10 80       	push   $0x8010730a
801021c3:	e8 a8 e1 ff ff       	call   80100370 <panic>
    panic("iderw: ide disk 1 not present");
801021c8:	83 ec 0c             	sub    $0xc,%esp
801021cb:	68 35 73 10 80       	push   $0x80107335
801021d0:	e8 9b e1 ff ff       	call   80100370 <panic>
    panic("iderw: nothing to do");
801021d5:	83 ec 0c             	sub    $0xc,%esp
801021d8:	68 20 73 10 80       	push   $0x80107320
801021dd:	e8 8e e1 ff ff       	call   80100370 <panic>
801021e2:	66 90                	xchg   %ax,%ax
801021e4:	66 90                	xchg   %ax,%ax
801021e6:	66 90                	xchg   %ax,%ax
801021e8:	66 90                	xchg   %ax,%ax
801021ea:	66 90                	xchg   %ax,%ax
801021ec:	66 90                	xchg   %ax,%ax
801021ee:	66 90                	xchg   %ax,%ax

801021f0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021f0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801021f1:	c7 05 94 26 11 80 00 	movl   $0xfec00000,0x80112694
801021f8:	00 c0 fe 
{
801021fb:	89 e5                	mov    %esp,%ebp
801021fd:	56                   	push   %esi
801021fe:	53                   	push   %ebx
  ioapic->reg = reg;
801021ff:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102206:	00 00 00 
  return ioapic->data;
80102209:	8b 15 94 26 11 80    	mov    0x80112694,%edx
8010220f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102212:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102218:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010221e:	0f b6 15 c0 27 11 80 	movzbl 0x801127c0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102225:	c1 ee 10             	shr    $0x10,%esi
80102228:	89 f0                	mov    %esi,%eax
8010222a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010222d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102230:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102233:	39 d0                	cmp    %edx,%eax
80102235:	74 16                	je     8010224d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102237:	83 ec 0c             	sub    $0xc,%esp
8010223a:	68 54 73 10 80       	push   $0x80107354
8010223f:	e8 1c e4 ff ff       	call   80100660 <cprintf>
80102244:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx
8010224a:	83 c4 10             	add    $0x10,%esp
8010224d:	83 c6 21             	add    $0x21,%esi
{
80102250:	ba 10 00 00 00       	mov    $0x10,%edx
80102255:	b8 20 00 00 00       	mov    $0x20,%eax
8010225a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102260:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102262:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102268:	89 c3                	mov    %eax,%ebx
8010226a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102270:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102273:	89 59 10             	mov    %ebx,0x10(%ecx)
80102276:	8d 5a 01             	lea    0x1(%edx),%ebx
80102279:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010227c:	39 f0                	cmp    %esi,%eax
  ioapic->reg = reg;
8010227e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102280:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx
80102286:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010228d:	75 d1                	jne    80102260 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010228f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102292:	5b                   	pop    %ebx
80102293:	5e                   	pop    %esi
80102294:	5d                   	pop    %ebp
80102295:	c3                   	ret    
80102296:	8d 76 00             	lea    0x0(%esi),%esi
80102299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022a0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022a0:	55                   	push   %ebp
  ioapic->reg = reg;
801022a1:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx
{
801022a7:	89 e5                	mov    %esp,%ebp
801022a9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022ac:	8d 50 20             	lea    0x20(%eax),%edx
801022af:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801022b3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022b5:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022bb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022be:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801022c4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022c6:	a1 94 26 11 80       	mov    0x80112694,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022cb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801022ce:	89 50 10             	mov    %edx,0x10(%eax)
}
801022d1:	5d                   	pop    %ebp
801022d2:	c3                   	ret    
801022d3:	66 90                	xchg   %ax,%ax
801022d5:	66 90                	xchg   %ax,%ax
801022d7:	66 90                	xchg   %ax,%ax
801022d9:	66 90                	xchg   %ax,%ax
801022db:	66 90                	xchg   %ax,%ax
801022dd:	66 90                	xchg   %ax,%ax
801022df:	90                   	nop

801022e0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 04             	sub    $0x4,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801022ea:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801022f0:	75 70                	jne    80102362 <kfree+0x82>
801022f2:	81 fb e8 6a 11 80    	cmp    $0x80116ae8,%ebx
801022f8:	72 68                	jb     80102362 <kfree+0x82>
801022fa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102300:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102305:	77 5b                	ja     80102362 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102307:	83 ec 04             	sub    $0x4,%esp
8010230a:	68 00 10 00 00       	push   $0x1000
8010230f:	6a 01                	push   $0x1
80102311:	53                   	push   %ebx
80102312:	e8 89 21 00 00       	call   801044a0 <memset>

  if(kmem.use_lock)
80102317:	8b 15 d4 26 11 80    	mov    0x801126d4,%edx
8010231d:	83 c4 10             	add    $0x10,%esp
80102320:	85 d2                	test   %edx,%edx
80102322:	75 2c                	jne    80102350 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102324:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102329:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010232b:	a1 d4 26 11 80       	mov    0x801126d4,%eax
  kmem.freelist = r;
80102330:	89 1d d8 26 11 80    	mov    %ebx,0x801126d8
  if(kmem.use_lock)
80102336:	85 c0                	test   %eax,%eax
80102338:	75 06                	jne    80102340 <kfree+0x60>
    release(&kmem.lock);
}
8010233a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010233d:	c9                   	leave  
8010233e:	c3                   	ret    
8010233f:	90                   	nop
    release(&kmem.lock);
80102340:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102347:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010234a:	c9                   	leave  
    release(&kmem.lock);
8010234b:	e9 00 21 00 00       	jmp    80104450 <release>
    acquire(&kmem.lock);
80102350:	83 ec 0c             	sub    $0xc,%esp
80102353:	68 a0 26 11 80       	push   $0x801126a0
80102358:	e8 43 20 00 00       	call   801043a0 <acquire>
8010235d:	83 c4 10             	add    $0x10,%esp
80102360:	eb c2                	jmp    80102324 <kfree+0x44>
    panic("kfree");
80102362:	83 ec 0c             	sub    $0xc,%esp
80102365:	68 86 73 10 80       	push   $0x80107386
8010236a:	e8 01 e0 ff ff       	call   80100370 <panic>
8010236f:	90                   	nop

80102370 <freerange>:
{
80102370:	55                   	push   %ebp
80102371:	89 e5                	mov    %esp,%ebp
80102373:	56                   	push   %esi
80102374:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102375:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102378:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010237b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102381:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102387:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010238d:	39 de                	cmp    %ebx,%esi
8010238f:	72 23                	jb     801023b4 <freerange+0x44>
80102391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102398:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010239e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023a7:	50                   	push   %eax
801023a8:	e8 33 ff ff ff       	call   801022e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023ad:	83 c4 10             	add    $0x10,%esp
801023b0:	39 f3                	cmp    %esi,%ebx
801023b2:	76 e4                	jbe    80102398 <freerange+0x28>
}
801023b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023b7:	5b                   	pop    %ebx
801023b8:	5e                   	pop    %esi
801023b9:	5d                   	pop    %ebp
801023ba:	c3                   	ret    
801023bb:	90                   	nop
801023bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023c0 <kinit1>:
{
801023c0:	55                   	push   %ebp
801023c1:	89 e5                	mov    %esp,%ebp
801023c3:	56                   	push   %esi
801023c4:	53                   	push   %ebx
801023c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023c8:	83 ec 08             	sub    $0x8,%esp
801023cb:	68 8c 73 10 80       	push   $0x8010738c
801023d0:	68 a0 26 11 80       	push   $0x801126a0
801023d5:	e8 66 1e 00 00       	call   80104240 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801023da:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023dd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801023e0:	c7 05 d4 26 11 80 00 	movl   $0x0,0x801126d4
801023e7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801023ea:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023f0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023f6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023fc:	39 de                	cmp    %ebx,%esi
801023fe:	72 1c                	jb     8010241c <kinit1+0x5c>
    kfree(p);
80102400:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102406:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102409:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010240f:	50                   	push   %eax
80102410:	e8 cb fe ff ff       	call   801022e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102415:	83 c4 10             	add    $0x10,%esp
80102418:	39 de                	cmp    %ebx,%esi
8010241a:	73 e4                	jae    80102400 <kinit1+0x40>
}
8010241c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010241f:	5b                   	pop    %ebx
80102420:	5e                   	pop    %esi
80102421:	5d                   	pop    %ebp
80102422:	c3                   	ret    
80102423:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102430 <kinit2>:
{
80102430:	55                   	push   %ebp
80102431:	89 e5                	mov    %esp,%ebp
80102433:	56                   	push   %esi
80102434:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102435:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102438:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010243b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102441:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102447:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010244d:	39 de                	cmp    %ebx,%esi
8010244f:	72 23                	jb     80102474 <kinit2+0x44>
80102451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102458:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010245e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102461:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102467:	50                   	push   %eax
80102468:	e8 73 fe ff ff       	call   801022e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010246d:	83 c4 10             	add    $0x10,%esp
80102470:	39 de                	cmp    %ebx,%esi
80102472:	73 e4                	jae    80102458 <kinit2+0x28>
  kmem.use_lock = 1;
80102474:	c7 05 d4 26 11 80 01 	movl   $0x1,0x801126d4
8010247b:	00 00 00 
}
8010247e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102481:	5b                   	pop    %ebx
80102482:	5e                   	pop    %esi
80102483:	5d                   	pop    %ebp
80102484:	c3                   	ret    
80102485:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102490 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	53                   	push   %ebx
80102494:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102497:	a1 d4 26 11 80       	mov    0x801126d4,%eax
8010249c:	85 c0                	test   %eax,%eax
8010249e:	75 30                	jne    801024d0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024a0:	8b 1d d8 26 11 80    	mov    0x801126d8,%ebx
  if(r)
801024a6:	85 db                	test   %ebx,%ebx
801024a8:	74 1c                	je     801024c6 <kalloc+0x36>
    kmem.freelist = r->next;
801024aa:	8b 13                	mov    (%ebx),%edx
801024ac:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  if(kmem.use_lock)
801024b2:	85 c0                	test   %eax,%eax
801024b4:	74 10                	je     801024c6 <kalloc+0x36>
    release(&kmem.lock);
801024b6:	83 ec 0c             	sub    $0xc,%esp
801024b9:	68 a0 26 11 80       	push   $0x801126a0
801024be:	e8 8d 1f 00 00       	call   80104450 <release>
801024c3:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
801024c6:	89 d8                	mov    %ebx,%eax
801024c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024cb:	c9                   	leave  
801024cc:	c3                   	ret    
801024cd:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
801024d0:	83 ec 0c             	sub    $0xc,%esp
801024d3:	68 a0 26 11 80       	push   $0x801126a0
801024d8:	e8 c3 1e 00 00       	call   801043a0 <acquire>
  r = kmem.freelist;
801024dd:	8b 1d d8 26 11 80    	mov    0x801126d8,%ebx
  if(r)
801024e3:	83 c4 10             	add    $0x10,%esp
801024e6:	a1 d4 26 11 80       	mov    0x801126d4,%eax
801024eb:	85 db                	test   %ebx,%ebx
801024ed:	75 bb                	jne    801024aa <kalloc+0x1a>
801024ef:	eb c1                	jmp    801024b2 <kalloc+0x22>
801024f1:	66 90                	xchg   %ax,%ax
801024f3:	66 90                	xchg   %ax,%ax
801024f5:	66 90                	xchg   %ax,%ax
801024f7:	66 90                	xchg   %ax,%ax
801024f9:	66 90                	xchg   %ax,%ax
801024fb:	66 90                	xchg   %ax,%ax
801024fd:	66 90                	xchg   %ax,%ax
801024ff:	90                   	nop

80102500 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102500:	ba 64 00 00 00       	mov    $0x64,%edx
80102505:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102506:	a8 01                	test   $0x1,%al
80102508:	0f 84 c2 00 00 00    	je     801025d0 <kbdgetc+0xd0>
8010250e:	ba 60 00 00 00       	mov    $0x60,%edx
80102513:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102514:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102517:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
8010251d:	0f 84 9d 00 00 00    	je     801025c0 <kbdgetc+0xc0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102523:	84 c0                	test   %al,%al
80102525:	78 59                	js     80102580 <kbdgetc+0x80>
{
80102527:	55                   	push   %ebp
80102528:	89 e5                	mov    %esp,%ebp
8010252a:	53                   	push   %ebx
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010252b:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
80102531:	f6 c3 40             	test   $0x40,%bl
80102534:	74 09                	je     8010253f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102536:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102539:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
8010253c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
8010253f:	0f b6 8a c0 74 10 80 	movzbl -0x7fef8b40(%edx),%ecx
  shift ^= togglecode[data];
80102546:	0f b6 82 c0 73 10 80 	movzbl -0x7fef8c40(%edx),%eax
  shift |= shiftcode[data];
8010254d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
8010254f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102551:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102553:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102559:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010255c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010255f:	8b 04 85 a0 73 10 80 	mov    -0x7fef8c60(,%eax,4),%eax
80102566:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010256a:	74 0b                	je     80102577 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010256c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010256f:	83 fa 19             	cmp    $0x19,%edx
80102572:	77 3c                	ja     801025b0 <kbdgetc+0xb0>
      c += 'A' - 'a';
80102574:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102577:	5b                   	pop    %ebx
80102578:	5d                   	pop    %ebp
80102579:	c3                   	ret    
8010257a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    data = (shift & E0ESC ? data : data & 0x7F);
80102580:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
80102586:	83 e0 7f             	and    $0x7f,%eax
80102589:	f6 c1 40             	test   $0x40,%cl
8010258c:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
8010258f:	0f b6 82 c0 74 10 80 	movzbl -0x7fef8b40(%edx),%eax
80102596:	83 c8 40             	or     $0x40,%eax
80102599:	0f b6 c0             	movzbl %al,%eax
8010259c:	f7 d0                	not    %eax
8010259e:	21 c8                	and    %ecx,%eax
801025a0:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
801025a5:	31 c0                	xor    %eax,%eax
801025a7:	c3                   	ret    
801025a8:	90                   	nop
801025a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801025b0:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025b3:	8d 50 20             	lea    0x20(%eax),%edx
}
801025b6:	5b                   	pop    %ebx
      c += 'a' - 'A';
801025b7:	83 f9 19             	cmp    $0x19,%ecx
801025ba:	0f 46 c2             	cmovbe %edx,%eax
}
801025bd:	5d                   	pop    %ebp
801025be:	c3                   	ret    
801025bf:	90                   	nop
    shift |= E0ESC;
801025c0:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
801025c7:	31 c0                	xor    %eax,%eax
801025c9:	c3                   	ret    
801025ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801025d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025d5:	c3                   	ret    
801025d6:	8d 76 00             	lea    0x0(%esi),%esi
801025d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025e0 <kbdintr>:

void
kbdintr(void)
{
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801025e6:	68 00 25 10 80       	push   $0x80102500
801025eb:	e8 f0 e1 ff ff       	call   801007e0 <consoleintr>
}
801025f0:	83 c4 10             	add    $0x10,%esp
801025f3:	c9                   	leave  
801025f4:	c3                   	ret    
801025f5:	66 90                	xchg   %ax,%ax
801025f7:	66 90                	xchg   %ax,%ax
801025f9:	66 90                	xchg   %ax,%ax
801025fb:	66 90                	xchg   %ax,%ax
801025fd:	66 90                	xchg   %ax,%ax
801025ff:	90                   	nop

80102600 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102600:	a1 dc 26 11 80       	mov    0x801126dc,%eax
{
80102605:	55                   	push   %ebp
80102606:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102608:	85 c0                	test   %eax,%eax
8010260a:	0f 84 c8 00 00 00    	je     801026d8 <lapicinit+0xd8>
  lapic[index] = value;
80102610:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102617:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010261a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010261d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102624:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102627:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010262a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102631:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102634:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102637:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010263e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102641:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102644:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010264b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010264e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102651:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102658:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010265b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010265e:	8b 50 30             	mov    0x30(%eax),%edx
80102661:	c1 ea 10             	shr    $0x10,%edx
80102664:	80 fa 03             	cmp    $0x3,%dl
80102667:	77 77                	ja     801026e0 <lapicinit+0xe0>
  lapic[index] = value;
80102669:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102670:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102673:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102676:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010267d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102680:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102683:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010268a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010268d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102690:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102697:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010269a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010269d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801026a4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026a7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026aa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801026b1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801026b4:	8b 50 20             	mov    0x20(%eax),%edx
801026b7:	89 f6                	mov    %esi,%esi
801026b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801026c0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801026c6:	80 e6 10             	and    $0x10,%dh
801026c9:	75 f5                	jne    801026c0 <lapicinit+0xc0>
  lapic[index] = value;
801026cb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801026d2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801026d8:	5d                   	pop    %ebp
801026d9:	c3                   	ret    
801026da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
801026e0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801026e7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ea:	8b 50 20             	mov    0x20(%eax),%edx
801026ed:	e9 77 ff ff ff       	jmp    80102669 <lapicinit+0x69>
801026f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102700 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102700:	a1 dc 26 11 80       	mov    0x801126dc,%eax
{
80102705:	55                   	push   %ebp
80102706:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102708:	85 c0                	test   %eax,%eax
8010270a:	74 0c                	je     80102718 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010270c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010270f:	5d                   	pop    %ebp
  return lapic[ID] >> 24;
80102710:	c1 e8 18             	shr    $0x18,%eax
}
80102713:	c3                   	ret    
80102714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102718:	31 c0                	xor    %eax,%eax
8010271a:	5d                   	pop    %ebp
8010271b:	c3                   	ret    
8010271c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102720 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102720:	a1 dc 26 11 80       	mov    0x801126dc,%eax
{
80102725:	55                   	push   %ebp
80102726:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102728:	85 c0                	test   %eax,%eax
8010272a:	74 0d                	je     80102739 <lapiceoi+0x19>
  lapic[index] = value;
8010272c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102733:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102736:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102739:	5d                   	pop    %ebp
8010273a:	c3                   	ret    
8010273b:	90                   	nop
8010273c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102740 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102740:	55                   	push   %ebp
80102741:	89 e5                	mov    %esp,%ebp
}
80102743:	5d                   	pop    %ebp
80102744:	c3                   	ret    
80102745:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102750 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102750:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102751:	ba 70 00 00 00       	mov    $0x70,%edx
80102756:	b8 0f 00 00 00       	mov    $0xf,%eax
8010275b:	89 e5                	mov    %esp,%ebp
8010275d:	53                   	push   %ebx
8010275e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102761:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102764:	ee                   	out    %al,(%dx)
80102765:	ba 71 00 00 00       	mov    $0x71,%edx
8010276a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010276f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102770:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102772:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102775:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010277b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010277d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102780:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102783:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102785:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102788:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010278e:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102793:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102799:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010279c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027a3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027a6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027a9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027b0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027b3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027b6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027bc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027bf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027c5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027c8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027ce:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027d1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027d7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801027da:	5b                   	pop    %ebx
801027db:	5d                   	pop    %ebp
801027dc:	c3                   	ret    
801027dd:	8d 76 00             	lea    0x0(%esi),%esi

801027e0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801027e0:	55                   	push   %ebp
801027e1:	ba 70 00 00 00       	mov    $0x70,%edx
801027e6:	b8 0b 00 00 00       	mov    $0xb,%eax
801027eb:	89 e5                	mov    %esp,%ebp
801027ed:	57                   	push   %edi
801027ee:	56                   	push   %esi
801027ef:	53                   	push   %ebx
801027f0:	83 ec 5c             	sub    $0x5c,%esp
801027f3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027f4:	ba 71 00 00 00       	mov    $0x71,%edx
801027f9:	ec                   	in     (%dx),%al
801027fa:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027fd:	bb 70 00 00 00       	mov    $0x70,%ebx
80102802:	88 45 a7             	mov    %al,-0x59(%ebp)
80102805:	8d 76 00             	lea    0x0(%esi),%esi
80102808:	31 c0                	xor    %eax,%eax
8010280a:	89 da                	mov    %ebx,%edx
8010280c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010280d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102812:	89 ca                	mov    %ecx,%edx
80102814:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
80102815:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102818:	89 da                	mov    %ebx,%edx
8010281a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
8010281d:	b8 02 00 00 00       	mov    $0x2,%eax
80102822:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102823:	89 ca                	mov    %ecx,%edx
80102825:	ec                   	in     (%dx),%al
80102826:	0f b6 f0             	movzbl %al,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102829:	89 da                	mov    %ebx,%edx
8010282b:	b8 04 00 00 00       	mov    $0x4,%eax
80102830:	89 75 b0             	mov    %esi,-0x50(%ebp)
80102833:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102834:	89 ca                	mov    %ecx,%edx
80102836:	ec                   	in     (%dx),%al
80102837:	0f b6 f8             	movzbl %al,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010283a:	89 da                	mov    %ebx,%edx
8010283c:	b8 07 00 00 00       	mov    $0x7,%eax
80102841:	89 7d ac             	mov    %edi,-0x54(%ebp)
80102844:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102845:	89 ca                	mov    %ecx,%edx
80102847:	ec                   	in     (%dx),%al
80102848:	0f b6 d0             	movzbl %al,%edx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010284b:	b8 08 00 00 00       	mov    $0x8,%eax
80102850:	89 55 a8             	mov    %edx,-0x58(%ebp)
80102853:	89 da                	mov    %ebx,%edx
80102855:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102856:	89 ca                	mov    %ecx,%edx
80102858:	ec                   	in     (%dx),%al
80102859:	0f b6 f8             	movzbl %al,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010285c:	89 da                	mov    %ebx,%edx
8010285e:	b8 09 00 00 00       	mov    $0x9,%eax
80102863:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102864:	89 ca                	mov    %ecx,%edx
80102866:	ec                   	in     (%dx),%al
80102867:	0f b6 f0             	movzbl %al,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010286a:	89 da                	mov    %ebx,%edx
8010286c:	b8 0a 00 00 00       	mov    $0xa,%eax
80102871:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102872:	89 ca                	mov    %ecx,%edx
80102874:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102875:	84 c0                	test   %al,%al
80102877:	78 8f                	js     80102808 <cmostime+0x28>
80102879:	8b 45 b4             	mov    -0x4c(%ebp),%eax
8010287c:	8b 55 a8             	mov    -0x58(%ebp),%edx
8010287f:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102882:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102885:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102888:	8b 45 b0             	mov    -0x50(%ebp),%eax
8010288b:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010288e:	89 da                	mov    %ebx,%edx
80102890:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102893:	8b 45 ac             	mov    -0x54(%ebp),%eax
80102896:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102899:	31 c0                	xor    %eax,%eax
8010289b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010289c:	89 ca                	mov    %ecx,%edx
8010289e:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
8010289f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028a2:	89 da                	mov    %ebx,%edx
801028a4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801028a7:	b8 02 00 00 00       	mov    $0x2,%eax
801028ac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ad:	89 ca                	mov    %ecx,%edx
801028af:	ec                   	in     (%dx),%al
801028b0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028b3:	89 da                	mov    %ebx,%edx
801028b5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801028b8:	b8 04 00 00 00       	mov    $0x4,%eax
801028bd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028be:	89 ca                	mov    %ecx,%edx
801028c0:	ec                   	in     (%dx),%al
801028c1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028c4:	89 da                	mov    %ebx,%edx
801028c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801028c9:	b8 07 00 00 00       	mov    $0x7,%eax
801028ce:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028cf:	89 ca                	mov    %ecx,%edx
801028d1:	ec                   	in     (%dx),%al
801028d2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028d5:	89 da                	mov    %ebx,%edx
801028d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801028da:	b8 08 00 00 00       	mov    $0x8,%eax
801028df:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028e0:	89 ca                	mov    %ecx,%edx
801028e2:	ec                   	in     (%dx),%al
801028e3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e6:	89 da                	mov    %ebx,%edx
801028e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801028eb:	b8 09 00 00 00       	mov    $0x9,%eax
801028f0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028f1:	89 ca                	mov    %ecx,%edx
801028f3:	ec                   	in     (%dx),%al
801028f4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028f7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
801028fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028fd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102900:	6a 18                	push   $0x18
80102902:	50                   	push   %eax
80102903:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102906:	50                   	push   %eax
80102907:	e8 e4 1b 00 00       	call   801044f0 <memcmp>
8010290c:	83 c4 10             	add    $0x10,%esp
8010290f:	85 c0                	test   %eax,%eax
80102911:	0f 85 f1 fe ff ff    	jne    80102808 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102917:	80 7d a7 00          	cmpb   $0x0,-0x59(%ebp)
8010291b:	75 78                	jne    80102995 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010291d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102920:	89 c2                	mov    %eax,%edx
80102922:	83 e0 0f             	and    $0xf,%eax
80102925:	c1 ea 04             	shr    $0x4,%edx
80102928:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010292b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010292e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102931:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102934:	89 c2                	mov    %eax,%edx
80102936:	83 e0 0f             	and    $0xf,%eax
80102939:	c1 ea 04             	shr    $0x4,%edx
8010293c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010293f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102942:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102945:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102948:	89 c2                	mov    %eax,%edx
8010294a:	83 e0 0f             	and    $0xf,%eax
8010294d:	c1 ea 04             	shr    $0x4,%edx
80102950:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102953:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102956:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102959:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010295c:	89 c2                	mov    %eax,%edx
8010295e:	83 e0 0f             	and    $0xf,%eax
80102961:	c1 ea 04             	shr    $0x4,%edx
80102964:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102967:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010296a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010296d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102970:	89 c2                	mov    %eax,%edx
80102972:	83 e0 0f             	and    $0xf,%eax
80102975:	c1 ea 04             	shr    $0x4,%edx
80102978:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010297b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010297e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102981:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102984:	89 c2                	mov    %eax,%edx
80102986:	83 e0 0f             	and    $0xf,%eax
80102989:	c1 ea 04             	shr    $0x4,%edx
8010298c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010298f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102992:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102995:	8b 75 08             	mov    0x8(%ebp),%esi
80102998:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010299b:	89 06                	mov    %eax,(%esi)
8010299d:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029a0:	89 46 04             	mov    %eax,0x4(%esi)
801029a3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029a6:	89 46 08             	mov    %eax,0x8(%esi)
801029a9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029ac:	89 46 0c             	mov    %eax,0xc(%esi)
801029af:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029b2:	89 46 10             	mov    %eax,0x10(%esi)
801029b5:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029b8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801029bb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801029c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029c5:	5b                   	pop    %ebx
801029c6:	5e                   	pop    %esi
801029c7:	5f                   	pop    %edi
801029c8:	5d                   	pop    %ebp
801029c9:	c3                   	ret    
801029ca:	66 90                	xchg   %ax,%ax
801029cc:	66 90                	xchg   %ax,%ax
801029ce:	66 90                	xchg   %ax,%ax

801029d0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029d0:	8b 0d 28 27 11 80    	mov    0x80112728,%ecx
801029d6:	85 c9                	test   %ecx,%ecx
801029d8:	0f 8e 85 00 00 00    	jle    80102a63 <install_trans+0x93>
{
801029de:	55                   	push   %ebp
801029df:	89 e5                	mov    %esp,%ebp
801029e1:	57                   	push   %edi
801029e2:	56                   	push   %esi
801029e3:	53                   	push   %ebx
801029e4:	31 db                	xor    %ebx,%ebx
801029e6:	83 ec 0c             	sub    $0xc,%esp
801029e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801029f0:	a1 14 27 11 80       	mov    0x80112714,%eax
801029f5:	83 ec 08             	sub    $0x8,%esp
801029f8:	01 d8                	add    %ebx,%eax
801029fa:	83 c0 01             	add    $0x1,%eax
801029fd:	50                   	push   %eax
801029fe:	ff 35 24 27 11 80    	pushl  0x80112724
80102a04:	e8 c7 d6 ff ff       	call   801000d0 <bread>
80102a09:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a0b:	58                   	pop    %eax
80102a0c:	5a                   	pop    %edx
80102a0d:	ff 34 9d 2c 27 11 80 	pushl  -0x7feed8d4(,%ebx,4)
80102a14:	ff 35 24 27 11 80    	pushl  0x80112724
  for (tail = 0; tail < log.lh.n; tail++) {
80102a1a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a1d:	e8 ae d6 ff ff       	call   801000d0 <bread>
80102a22:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a24:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a27:	83 c4 0c             	add    $0xc,%esp
80102a2a:	68 00 02 00 00       	push   $0x200
80102a2f:	50                   	push   %eax
80102a30:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a33:	50                   	push   %eax
80102a34:	e8 17 1b 00 00       	call   80104550 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a39:	89 34 24             	mov    %esi,(%esp)
80102a3c:	e8 5f d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a41:	89 3c 24             	mov    %edi,(%esp)
80102a44:	e8 97 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a49:	89 34 24             	mov    %esi,(%esp)
80102a4c:	e8 8f d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102a51:	83 c4 10             	add    $0x10,%esp
80102a54:	39 1d 28 27 11 80    	cmp    %ebx,0x80112728
80102a5a:	7f 94                	jg     801029f0 <install_trans+0x20>
  }
}
80102a5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a5f:	5b                   	pop    %ebx
80102a60:	5e                   	pop    %esi
80102a61:	5f                   	pop    %edi
80102a62:	5d                   	pop    %ebp
80102a63:	f3 c3                	repz ret 
80102a65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a70 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a70:	55                   	push   %ebp
80102a71:	89 e5                	mov    %esp,%ebp
80102a73:	53                   	push   %ebx
80102a74:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a77:	ff 35 14 27 11 80    	pushl  0x80112714
80102a7d:	ff 35 24 27 11 80    	pushl  0x80112724
80102a83:	e8 48 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a88:	8b 0d 28 27 11 80    	mov    0x80112728,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102a8e:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a91:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102a93:	85 c9                	test   %ecx,%ecx
  hb->n = log.lh.n;
80102a95:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102a98:	7e 1f                	jle    80102ab9 <write_head+0x49>
80102a9a:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102aa1:	31 d2                	xor    %edx,%edx
80102aa3:	90                   	nop
80102aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102aa8:	8b 8a 2c 27 11 80    	mov    -0x7feed8d4(%edx),%ecx
80102aae:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102ab2:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102ab5:	39 c2                	cmp    %eax,%edx
80102ab7:	75 ef                	jne    80102aa8 <write_head+0x38>
  }
  bwrite(buf);
80102ab9:	83 ec 0c             	sub    $0xc,%esp
80102abc:	53                   	push   %ebx
80102abd:	e8 de d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102ac2:	89 1c 24             	mov    %ebx,(%esp)
80102ac5:	e8 16 d7 ff ff       	call   801001e0 <brelse>
}
80102aca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102acd:	c9                   	leave  
80102ace:	c3                   	ret    
80102acf:	90                   	nop

80102ad0 <initlog>:
{
80102ad0:	55                   	push   %ebp
80102ad1:	89 e5                	mov    %esp,%ebp
80102ad3:	53                   	push   %ebx
80102ad4:	83 ec 2c             	sub    $0x2c,%esp
80102ad7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102ada:	68 c0 75 10 80       	push   $0x801075c0
80102adf:	68 e0 26 11 80       	push   $0x801126e0
80102ae4:	e8 57 17 00 00       	call   80104240 <initlock>
  readsb(dev, &sb);
80102ae9:	58                   	pop    %eax
80102aea:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102aed:	5a                   	pop    %edx
80102aee:	50                   	push   %eax
80102aef:	53                   	push   %ebx
80102af0:	e8 bb e8 ff ff       	call   801013b0 <readsb>
  log.size = sb.nlog;
80102af5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102af8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102afb:	59                   	pop    %ecx
  log.dev = dev;
80102afc:	89 1d 24 27 11 80    	mov    %ebx,0x80112724
  log.size = sb.nlog;
80102b02:	89 15 18 27 11 80    	mov    %edx,0x80112718
  log.start = sb.logstart;
80102b08:	a3 14 27 11 80       	mov    %eax,0x80112714
  struct buf *buf = bread(log.dev, log.start);
80102b0d:	5a                   	pop    %edx
80102b0e:	50                   	push   %eax
80102b0f:	53                   	push   %ebx
80102b10:	e8 bb d5 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102b15:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102b18:	83 c4 10             	add    $0x10,%esp
80102b1b:	85 c9                	test   %ecx,%ecx
  log.lh.n = lh->n;
80102b1d:	89 0d 28 27 11 80    	mov    %ecx,0x80112728
  for (i = 0; i < log.lh.n; i++) {
80102b23:	7e 1c                	jle    80102b41 <initlog+0x71>
80102b25:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102b2c:	31 d2                	xor    %edx,%edx
80102b2e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102b30:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b34:	83 c2 04             	add    $0x4,%edx
80102b37:	89 8a 28 27 11 80    	mov    %ecx,-0x7feed8d8(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102b3d:	39 da                	cmp    %ebx,%edx
80102b3f:	75 ef                	jne    80102b30 <initlog+0x60>
  brelse(buf);
80102b41:	83 ec 0c             	sub    $0xc,%esp
80102b44:	50                   	push   %eax
80102b45:	e8 96 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b4a:	e8 81 fe ff ff       	call   801029d0 <install_trans>
  log.lh.n = 0;
80102b4f:	c7 05 28 27 11 80 00 	movl   $0x0,0x80112728
80102b56:	00 00 00 
  write_head(); // clear the log
80102b59:	e8 12 ff ff ff       	call   80102a70 <write_head>
}
80102b5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b61:	c9                   	leave  
80102b62:	c3                   	ret    
80102b63:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b70 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b70:	55                   	push   %ebp
80102b71:	89 e5                	mov    %esp,%ebp
80102b73:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102b76:	68 e0 26 11 80       	push   $0x801126e0
80102b7b:	e8 20 18 00 00       	call   801043a0 <acquire>
80102b80:	83 c4 10             	add    $0x10,%esp
80102b83:	eb 18                	jmp    80102b9d <begin_op+0x2d>
80102b85:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b88:	83 ec 08             	sub    $0x8,%esp
80102b8b:	68 e0 26 11 80       	push   $0x801126e0
80102b90:	68 e0 26 11 80       	push   $0x801126e0
80102b95:	e8 06 12 00 00       	call   80103da0 <sleep>
80102b9a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102b9d:	a1 20 27 11 80       	mov    0x80112720,%eax
80102ba2:	85 c0                	test   %eax,%eax
80102ba4:	75 e2                	jne    80102b88 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102ba6:	a1 1c 27 11 80       	mov    0x8011271c,%eax
80102bab:	8b 15 28 27 11 80    	mov    0x80112728,%edx
80102bb1:	83 c0 01             	add    $0x1,%eax
80102bb4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102bb7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102bba:	83 fa 1e             	cmp    $0x1e,%edx
80102bbd:	7f c9                	jg     80102b88 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102bbf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102bc2:	a3 1c 27 11 80       	mov    %eax,0x8011271c
      release(&log.lock);
80102bc7:	68 e0 26 11 80       	push   $0x801126e0
80102bcc:	e8 7f 18 00 00       	call   80104450 <release>
      break;
    }
  }
}
80102bd1:	83 c4 10             	add    $0x10,%esp
80102bd4:	c9                   	leave  
80102bd5:	c3                   	ret    
80102bd6:	8d 76 00             	lea    0x0(%esi),%esi
80102bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102be0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102be0:	55                   	push   %ebp
80102be1:	89 e5                	mov    %esp,%ebp
80102be3:	57                   	push   %edi
80102be4:	56                   	push   %esi
80102be5:	53                   	push   %ebx
80102be6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102be9:	68 e0 26 11 80       	push   $0x801126e0
80102bee:	e8 ad 17 00 00       	call   801043a0 <acquire>
  log.outstanding -= 1;
80102bf3:	a1 1c 27 11 80       	mov    0x8011271c,%eax
  if(log.committing)
80102bf8:	8b 35 20 27 11 80    	mov    0x80112720,%esi
80102bfe:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102c01:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102c04:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102c06:	89 1d 1c 27 11 80    	mov    %ebx,0x8011271c
  if(log.committing)
80102c0c:	0f 85 22 01 00 00    	jne    80102d34 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102c12:	85 db                	test   %ebx,%ebx
80102c14:	0f 85 f6 00 00 00    	jne    80102d10 <end_op+0x130>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c1a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102c1d:	c7 05 20 27 11 80 01 	movl   $0x1,0x80112720
80102c24:	00 00 00 
  release(&log.lock);
80102c27:	68 e0 26 11 80       	push   $0x801126e0
80102c2c:	e8 1f 18 00 00       	call   80104450 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c31:	8b 0d 28 27 11 80    	mov    0x80112728,%ecx
80102c37:	83 c4 10             	add    $0x10,%esp
80102c3a:	85 c9                	test   %ecx,%ecx
80102c3c:	0f 8e 8b 00 00 00    	jle    80102ccd <end_op+0xed>
80102c42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c48:	a1 14 27 11 80       	mov    0x80112714,%eax
80102c4d:	83 ec 08             	sub    $0x8,%esp
80102c50:	01 d8                	add    %ebx,%eax
80102c52:	83 c0 01             	add    $0x1,%eax
80102c55:	50                   	push   %eax
80102c56:	ff 35 24 27 11 80    	pushl  0x80112724
80102c5c:	e8 6f d4 ff ff       	call   801000d0 <bread>
80102c61:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c63:	58                   	pop    %eax
80102c64:	5a                   	pop    %edx
80102c65:	ff 34 9d 2c 27 11 80 	pushl  -0x7feed8d4(,%ebx,4)
80102c6c:	ff 35 24 27 11 80    	pushl  0x80112724
  for (tail = 0; tail < log.lh.n; tail++) {
80102c72:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c75:	e8 56 d4 ff ff       	call   801000d0 <bread>
80102c7a:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c7c:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c7f:	83 c4 0c             	add    $0xc,%esp
80102c82:	68 00 02 00 00       	push   $0x200
80102c87:	50                   	push   %eax
80102c88:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c8b:	50                   	push   %eax
80102c8c:	e8 bf 18 00 00       	call   80104550 <memmove>
    bwrite(to);  // write the log
80102c91:	89 34 24             	mov    %esi,(%esp)
80102c94:	e8 07 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c99:	89 3c 24             	mov    %edi,(%esp)
80102c9c:	e8 3f d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102ca1:	89 34 24             	mov    %esi,(%esp)
80102ca4:	e8 37 d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ca9:	83 c4 10             	add    $0x10,%esp
80102cac:	3b 1d 28 27 11 80    	cmp    0x80112728,%ebx
80102cb2:	7c 94                	jl     80102c48 <end_op+0x68>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102cb4:	e8 b7 fd ff ff       	call   80102a70 <write_head>
    install_trans(); // Now install writes to home locations
80102cb9:	e8 12 fd ff ff       	call   801029d0 <install_trans>
    log.lh.n = 0;
80102cbe:	c7 05 28 27 11 80 00 	movl   $0x0,0x80112728
80102cc5:	00 00 00 
    write_head();    // Erase the transaction from the log
80102cc8:	e8 a3 fd ff ff       	call   80102a70 <write_head>
    acquire(&log.lock);
80102ccd:	83 ec 0c             	sub    $0xc,%esp
80102cd0:	68 e0 26 11 80       	push   $0x801126e0
80102cd5:	e8 c6 16 00 00       	call   801043a0 <acquire>
    wakeup(&log);
80102cda:	c7 04 24 e0 26 11 80 	movl   $0x801126e0,(%esp)
    log.committing = 0;
80102ce1:	c7 05 20 27 11 80 00 	movl   $0x0,0x80112720
80102ce8:	00 00 00 
    wakeup(&log);
80102ceb:	e8 70 12 00 00       	call   80103f60 <wakeup>
    release(&log.lock);
80102cf0:	c7 04 24 e0 26 11 80 	movl   $0x801126e0,(%esp)
80102cf7:	e8 54 17 00 00       	call   80104450 <release>
80102cfc:	83 c4 10             	add    $0x10,%esp
}
80102cff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d02:	5b                   	pop    %ebx
80102d03:	5e                   	pop    %esi
80102d04:	5f                   	pop    %edi
80102d05:	5d                   	pop    %ebp
80102d06:	c3                   	ret    
80102d07:	89 f6                	mov    %esi,%esi
80102d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    wakeup(&log);
80102d10:	83 ec 0c             	sub    $0xc,%esp
80102d13:	68 e0 26 11 80       	push   $0x801126e0
80102d18:	e8 43 12 00 00       	call   80103f60 <wakeup>
  release(&log.lock);
80102d1d:	c7 04 24 e0 26 11 80 	movl   $0x801126e0,(%esp)
80102d24:	e8 27 17 00 00       	call   80104450 <release>
80102d29:	83 c4 10             	add    $0x10,%esp
}
80102d2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d2f:	5b                   	pop    %ebx
80102d30:	5e                   	pop    %esi
80102d31:	5f                   	pop    %edi
80102d32:	5d                   	pop    %ebp
80102d33:	c3                   	ret    
    panic("log.committing");
80102d34:	83 ec 0c             	sub    $0xc,%esp
80102d37:	68 c4 75 10 80       	push   $0x801075c4
80102d3c:	e8 2f d6 ff ff       	call   80100370 <panic>
80102d41:	eb 0d                	jmp    80102d50 <log_write>
80102d43:	90                   	nop
80102d44:	90                   	nop
80102d45:	90                   	nop
80102d46:	90                   	nop
80102d47:	90                   	nop
80102d48:	90                   	nop
80102d49:	90                   	nop
80102d4a:	90                   	nop
80102d4b:	90                   	nop
80102d4c:	90                   	nop
80102d4d:	90                   	nop
80102d4e:	90                   	nop
80102d4f:	90                   	nop

80102d50 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d50:	55                   	push   %ebp
80102d51:	89 e5                	mov    %esp,%ebp
80102d53:	53                   	push   %ebx
80102d54:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d57:	8b 15 28 27 11 80    	mov    0x80112728,%edx
{
80102d5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d60:	83 fa 1d             	cmp    $0x1d,%edx
80102d63:	0f 8f 97 00 00 00    	jg     80102e00 <log_write+0xb0>
80102d69:	a1 18 27 11 80       	mov    0x80112718,%eax
80102d6e:	83 e8 01             	sub    $0x1,%eax
80102d71:	39 c2                	cmp    %eax,%edx
80102d73:	0f 8d 87 00 00 00    	jge    80102e00 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d79:	a1 1c 27 11 80       	mov    0x8011271c,%eax
80102d7e:	85 c0                	test   %eax,%eax
80102d80:	0f 8e 87 00 00 00    	jle    80102e0d <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102d86:	83 ec 0c             	sub    $0xc,%esp
80102d89:	68 e0 26 11 80       	push   $0x801126e0
80102d8e:	e8 0d 16 00 00       	call   801043a0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d93:	8b 0d 28 27 11 80    	mov    0x80112728,%ecx
80102d99:	83 c4 10             	add    $0x10,%esp
80102d9c:	83 f9 00             	cmp    $0x0,%ecx
80102d9f:	7e 50                	jle    80102df1 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102da1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102da4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102da6:	3b 15 2c 27 11 80    	cmp    0x8011272c,%edx
80102dac:	75 0b                	jne    80102db9 <log_write+0x69>
80102dae:	eb 38                	jmp    80102de8 <log_write+0x98>
80102db0:	39 14 85 2c 27 11 80 	cmp    %edx,-0x7feed8d4(,%eax,4)
80102db7:	74 2f                	je     80102de8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102db9:	83 c0 01             	add    $0x1,%eax
80102dbc:	39 c8                	cmp    %ecx,%eax
80102dbe:	75 f0                	jne    80102db0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102dc0:	89 14 85 2c 27 11 80 	mov    %edx,-0x7feed8d4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102dc7:	83 c0 01             	add    $0x1,%eax
80102dca:	a3 28 27 11 80       	mov    %eax,0x80112728
  b->flags |= B_DIRTY; // prevent eviction
80102dcf:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102dd2:	c7 45 08 e0 26 11 80 	movl   $0x801126e0,0x8(%ebp)
}
80102dd9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ddc:	c9                   	leave  
  release(&log.lock);
80102ddd:	e9 6e 16 00 00       	jmp    80104450 <release>
80102de2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102de8:	89 14 85 2c 27 11 80 	mov    %edx,-0x7feed8d4(,%eax,4)
80102def:	eb de                	jmp    80102dcf <log_write+0x7f>
80102df1:	8b 43 08             	mov    0x8(%ebx),%eax
80102df4:	a3 2c 27 11 80       	mov    %eax,0x8011272c
  if (i == log.lh.n)
80102df9:	75 d4                	jne    80102dcf <log_write+0x7f>
80102dfb:	31 c0                	xor    %eax,%eax
80102dfd:	eb c8                	jmp    80102dc7 <log_write+0x77>
80102dff:	90                   	nop
    panic("too big a transaction");
80102e00:	83 ec 0c             	sub    $0xc,%esp
80102e03:	68 d3 75 10 80       	push   $0x801075d3
80102e08:	e8 63 d5 ff ff       	call   80100370 <panic>
    panic("log_write outside of trans");
80102e0d:	83 ec 0c             	sub    $0xc,%esp
80102e10:	68 e9 75 10 80       	push   $0x801075e9
80102e15:	e8 56 d5 ff ff       	call   80100370 <panic>
80102e1a:	66 90                	xchg   %ax,%ax
80102e1c:	66 90                	xchg   %ax,%ax
80102e1e:	66 90                	xchg   %ax,%ax

80102e20 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e20:	55                   	push   %ebp
80102e21:	89 e5                	mov    %esp,%ebp
80102e23:	53                   	push   %ebx
80102e24:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e27:	e8 a4 09 00 00       	call   801037d0 <cpuid>
80102e2c:	89 c3                	mov    %eax,%ebx
80102e2e:	e8 9d 09 00 00       	call   801037d0 <cpuid>
80102e33:	83 ec 04             	sub    $0x4,%esp
80102e36:	53                   	push   %ebx
80102e37:	50                   	push   %eax
80102e38:	68 04 76 10 80       	push   $0x80107604
80102e3d:	e8 1e d8 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e42:	e8 79 2a 00 00       	call   801058c0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e47:	e8 04 09 00 00       	call   80103750 <mycpu>
80102e4c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e4e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e53:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e5a:	e8 51 0c 00 00       	call   80103ab0 <scheduler>
80102e5f:	90                   	nop

80102e60 <mpenter>:
{
80102e60:	55                   	push   %ebp
80102e61:	89 e5                	mov    %esp,%ebp
80102e63:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e66:	e8 75 3b 00 00       	call   801069e0 <switchkvm>
  seginit();
80102e6b:	e8 70 3a 00 00       	call   801068e0 <seginit>
  lapicinit();
80102e70:	e8 8b f7 ff ff       	call   80102600 <lapicinit>
  mpmain();
80102e75:	e8 a6 ff ff ff       	call   80102e20 <mpmain>
80102e7a:	66 90                	xchg   %ax,%ax
80102e7c:	66 90                	xchg   %ax,%ax
80102e7e:	66 90                	xchg   %ax,%ax

80102e80 <main>:
{
80102e80:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102e84:	83 e4 f0             	and    $0xfffffff0,%esp
80102e87:	ff 71 fc             	pushl  -0x4(%ecx)
80102e8a:	55                   	push   %ebp
80102e8b:	89 e5                	mov    %esp,%ebp
80102e8d:	53                   	push   %ebx
80102e8e:	51                   	push   %ecx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102e8f:	bb e0 27 11 80       	mov    $0x801127e0,%ebx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e94:	83 ec 08             	sub    $0x8,%esp
80102e97:	68 00 00 40 80       	push   $0x80400000
80102e9c:	68 e8 6a 11 80       	push   $0x80116ae8
80102ea1:	e8 1a f5 ff ff       	call   801023c0 <kinit1>
  kvmalloc();      // kernel page table
80102ea6:	e8 c5 3f 00 00       	call   80106e70 <kvmalloc>
  mpinit();        // detect other processors
80102eab:	e8 60 01 00 00       	call   80103010 <mpinit>
  lapicinit();     // interrupt controller
80102eb0:	e8 4b f7 ff ff       	call   80102600 <lapicinit>
  seginit();       // segment descriptors
80102eb5:	e8 26 3a 00 00       	call   801068e0 <seginit>
  picinit();       // disable pic
80102eba:	e8 21 03 00 00       	call   801031e0 <picinit>
  ioapicinit();    // another interrupt controller
80102ebf:	e8 2c f3 ff ff       	call   801021f0 <ioapicinit>
  consoleinit();   // console hardware
80102ec4:	e8 c7 da ff ff       	call   80100990 <consoleinit>
  uartinit();      // serial port
80102ec9:	e8 e2 2c 00 00       	call   80105bb0 <uartinit>
  pinit();         // process table
80102ece:	e8 5d 08 00 00       	call   80103730 <pinit>
  tvinit();        // trap vectors
80102ed3:	e8 48 29 00 00       	call   80105820 <tvinit>
  binit();         // buffer cache
80102ed8:	e8 63 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102edd:	e8 5e de ff ff       	call   80100d40 <fileinit>
  ideinit();       // disk 
80102ee2:	e8 e9 f0 ff ff       	call   80101fd0 <ideinit>
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102ee7:	83 c4 0c             	add    $0xc,%esp
80102eea:	68 8a 00 00 00       	push   $0x8a
80102eef:	68 8c a4 10 80       	push   $0x8010a48c
80102ef4:	68 00 70 00 80       	push   $0x80007000
80102ef9:	e8 52 16 00 00       	call   80104550 <memmove>
  for(c = cpus; c < cpus+ncpu; c++){
80102efe:	69 05 60 2d 11 80 b0 	imul   $0xb0,0x80112d60,%eax
80102f05:	00 00 00 
80102f08:	83 c4 10             	add    $0x10,%esp
80102f0b:	05 e0 27 11 80       	add    $0x801127e0,%eax
80102f10:	39 d8                	cmp    %ebx,%eax
80102f12:	76 6f                	jbe    80102f83 <main+0x103>
80102f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102f18:	e8 33 08 00 00       	call   80103750 <mycpu>
80102f1d:	39 d8                	cmp    %ebx,%eax
80102f1f:	74 49                	je     80102f6a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f21:	e8 6a f5 ff ff       	call   80102490 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f26:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102f2b:	c7 05 f8 6f 00 80 60 	movl   $0x80102e60,0x80006ff8
80102f32:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f35:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102f3c:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f3f:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102f44:	0f b6 03             	movzbl (%ebx),%eax
80102f47:	83 ec 08             	sub    $0x8,%esp
80102f4a:	68 00 70 00 00       	push   $0x7000
80102f4f:	50                   	push   %eax
80102f50:	e8 fb f7 ff ff       	call   80102750 <lapicstartap>
80102f55:	83 c4 10             	add    $0x10,%esp
80102f58:	90                   	nop
80102f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f60:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f66:	85 c0                	test   %eax,%eax
80102f68:	74 f6                	je     80102f60 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102f6a:	69 05 60 2d 11 80 b0 	imul   $0xb0,0x80112d60,%eax
80102f71:	00 00 00 
80102f74:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f7a:	05 e0 27 11 80       	add    $0x801127e0,%eax
80102f7f:	39 c3                	cmp    %eax,%ebx
80102f81:	72 95                	jb     80102f18 <main+0x98>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f83:	83 ec 08             	sub    $0x8,%esp
80102f86:	68 00 00 00 8e       	push   $0x8e000000
80102f8b:	68 00 00 40 80       	push   $0x80400000
80102f90:	e8 9b f4 ff ff       	call   80102430 <kinit2>
  userinit();      // first user process
80102f95:	e8 86 08 00 00       	call   80103820 <userinit>
  mpmain();        // finish this processor's setup
80102f9a:	e8 81 fe ff ff       	call   80102e20 <mpmain>
80102f9f:	90                   	nop

80102fa0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fa0:	55                   	push   %ebp
80102fa1:	89 e5                	mov    %esp,%ebp
80102fa3:	57                   	push   %edi
80102fa4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102fa5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102fab:	53                   	push   %ebx
  e = addr+len;
80102fac:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102faf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102fb2:	39 de                	cmp    %ebx,%esi
80102fb4:	73 40                	jae    80102ff6 <mpsearch1+0x56>
80102fb6:	8d 76 00             	lea    0x0(%esi),%esi
80102fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fc0:	83 ec 04             	sub    $0x4,%esp
80102fc3:	8d 7e 10             	lea    0x10(%esi),%edi
80102fc6:	6a 04                	push   $0x4
80102fc8:	68 18 76 10 80       	push   $0x80107618
80102fcd:	56                   	push   %esi
80102fce:	e8 1d 15 00 00       	call   801044f0 <memcmp>
80102fd3:	83 c4 10             	add    $0x10,%esp
80102fd6:	85 c0                	test   %eax,%eax
80102fd8:	75 16                	jne    80102ff0 <mpsearch1+0x50>
80102fda:	8d 7e 10             	lea    0x10(%esi),%edi
80102fdd:	89 f2                	mov    %esi,%edx
80102fdf:	90                   	nop
    sum += addr[i];
80102fe0:	0f b6 0a             	movzbl (%edx),%ecx
80102fe3:	83 c2 01             	add    $0x1,%edx
80102fe6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80102fe8:	39 fa                	cmp    %edi,%edx
80102fea:	75 f4                	jne    80102fe0 <mpsearch1+0x40>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fec:	84 c0                	test   %al,%al
80102fee:	74 10                	je     80103000 <mpsearch1+0x60>
  for(p = addr; p < e; p += sizeof(struct mp))
80102ff0:	39 fb                	cmp    %edi,%ebx
80102ff2:	89 fe                	mov    %edi,%esi
80102ff4:	77 ca                	ja     80102fc0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80102ff6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80102ff9:	31 c0                	xor    %eax,%eax
}
80102ffb:	5b                   	pop    %ebx
80102ffc:	5e                   	pop    %esi
80102ffd:	5f                   	pop    %edi
80102ffe:	5d                   	pop    %ebp
80102fff:	c3                   	ret    
80103000:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103003:	89 f0                	mov    %esi,%eax
80103005:	5b                   	pop    %ebx
80103006:	5e                   	pop    %esi
80103007:	5f                   	pop    %edi
80103008:	5d                   	pop    %ebp
80103009:	c3                   	ret    
8010300a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103010 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103010:	55                   	push   %ebp
80103011:	89 e5                	mov    %esp,%ebp
80103013:	57                   	push   %edi
80103014:	56                   	push   %esi
80103015:	53                   	push   %ebx
80103016:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103019:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103020:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103027:	c1 e0 08             	shl    $0x8,%eax
8010302a:	09 d0                	or     %edx,%eax
8010302c:	c1 e0 04             	shl    $0x4,%eax
8010302f:	85 c0                	test   %eax,%eax
80103031:	75 1b                	jne    8010304e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103033:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010303a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103041:	c1 e0 08             	shl    $0x8,%eax
80103044:	09 d0                	or     %edx,%eax
80103046:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103049:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010304e:	ba 00 04 00 00       	mov    $0x400,%edx
80103053:	e8 48 ff ff ff       	call   80102fa0 <mpsearch1>
80103058:	85 c0                	test   %eax,%eax
8010305a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010305d:	0f 84 37 01 00 00    	je     8010319a <mpinit+0x18a>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103063:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103066:	8b 58 04             	mov    0x4(%eax),%ebx
80103069:	85 db                	test   %ebx,%ebx
8010306b:	0f 84 43 01 00 00    	je     801031b4 <mpinit+0x1a4>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103071:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103077:	83 ec 04             	sub    $0x4,%esp
8010307a:	6a 04                	push   $0x4
8010307c:	68 35 76 10 80       	push   $0x80107635
80103081:	56                   	push   %esi
80103082:	e8 69 14 00 00       	call   801044f0 <memcmp>
80103087:	83 c4 10             	add    $0x10,%esp
8010308a:	85 c0                	test   %eax,%eax
8010308c:	0f 85 22 01 00 00    	jne    801031b4 <mpinit+0x1a4>
  if(conf->version != 1 && conf->version != 4)
80103092:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103099:	3c 01                	cmp    $0x1,%al
8010309b:	74 08                	je     801030a5 <mpinit+0x95>
8010309d:	3c 04                	cmp    $0x4,%al
8010309f:	0f 85 0f 01 00 00    	jne    801031b4 <mpinit+0x1a4>
  if(sum((uchar*)conf, conf->length) != 0)
801030a5:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
801030ac:	85 ff                	test   %edi,%edi
801030ae:	74 21                	je     801030d1 <mpinit+0xc1>
801030b0:	31 d2                	xor    %edx,%edx
801030b2:	31 c0                	xor    %eax,%eax
801030b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801030b8:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
801030bf:	80 
  for(i=0; i<len; i++)
801030c0:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801030c3:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801030c5:	39 c7                	cmp    %eax,%edi
801030c7:	75 ef                	jne    801030b8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801030c9:	84 d2                	test   %dl,%dl
801030cb:	0f 85 e3 00 00 00    	jne    801031b4 <mpinit+0x1a4>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801030d1:	85 f6                	test   %esi,%esi
801030d3:	0f 84 db 00 00 00    	je     801031b4 <mpinit+0x1a4>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801030d9:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801030df:	a3 dc 26 11 80       	mov    %eax,0x801126dc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030e4:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801030eb:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
801030f1:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030f6:	01 d6                	add    %edx,%esi
801030f8:	90                   	nop
801030f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103100:	39 c6                	cmp    %eax,%esi
80103102:	76 23                	jbe    80103127 <mpinit+0x117>
80103104:	0f b6 10             	movzbl (%eax),%edx
    switch(*p){
80103107:	80 fa 04             	cmp    $0x4,%dl
8010310a:	0f 87 c0 00 00 00    	ja     801031d0 <mpinit+0x1c0>
80103110:	ff 24 95 5c 76 10 80 	jmp    *-0x7fef89a4(,%edx,4)
80103117:	89 f6                	mov    %esi,%esi
80103119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103120:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103123:	39 c6                	cmp    %eax,%esi
80103125:	77 dd                	ja     80103104 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103127:	85 db                	test   %ebx,%ebx
80103129:	0f 84 92 00 00 00    	je     801031c1 <mpinit+0x1b1>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010312f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103132:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103136:	74 15                	je     8010314d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103138:	ba 22 00 00 00       	mov    $0x22,%edx
8010313d:	b8 70 00 00 00       	mov    $0x70,%eax
80103142:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103143:	ba 23 00 00 00       	mov    $0x23,%edx
80103148:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103149:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010314c:	ee                   	out    %al,(%dx)
  }
}
8010314d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103150:	5b                   	pop    %ebx
80103151:	5e                   	pop    %esi
80103152:	5f                   	pop    %edi
80103153:	5d                   	pop    %ebp
80103154:	c3                   	ret    
80103155:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103158:	8b 0d 60 2d 11 80    	mov    0x80112d60,%ecx
8010315e:	83 f9 07             	cmp    $0x7,%ecx
80103161:	7f 19                	jg     8010317c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103163:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103167:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010316d:	83 c1 01             	add    $0x1,%ecx
80103170:	89 0d 60 2d 11 80    	mov    %ecx,0x80112d60
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103176:	88 97 e0 27 11 80    	mov    %dl,-0x7feed820(%edi)
      p += sizeof(struct mpproc);
8010317c:	83 c0 14             	add    $0x14,%eax
      continue;
8010317f:	e9 7c ff ff ff       	jmp    80103100 <mpinit+0xf0>
80103184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103188:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010318c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010318f:	88 15 c0 27 11 80    	mov    %dl,0x801127c0
      continue;
80103195:	e9 66 ff ff ff       	jmp    80103100 <mpinit+0xf0>
  return mpsearch1(0xF0000, 0x10000);
8010319a:	ba 00 00 01 00       	mov    $0x10000,%edx
8010319f:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801031a4:	e8 f7 fd ff ff       	call   80102fa0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031a9:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801031ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031ae:	0f 85 af fe ff ff    	jne    80103063 <mpinit+0x53>
    panic("Expect to run on an SMP");
801031b4:	83 ec 0c             	sub    $0xc,%esp
801031b7:	68 1d 76 10 80       	push   $0x8010761d
801031bc:	e8 af d1 ff ff       	call   80100370 <panic>
    panic("Didn't find a suitable machine");
801031c1:	83 ec 0c             	sub    $0xc,%esp
801031c4:	68 3c 76 10 80       	push   $0x8010763c
801031c9:	e8 a2 d1 ff ff       	call   80100370 <panic>
801031ce:	66 90                	xchg   %ax,%ax
      ismp = 0;
801031d0:	31 db                	xor    %ebx,%ebx
801031d2:	e9 30 ff ff ff       	jmp    80103107 <mpinit+0xf7>
801031d7:	66 90                	xchg   %ax,%ax
801031d9:	66 90                	xchg   %ax,%ax
801031db:	66 90                	xchg   %ax,%ax
801031dd:	66 90                	xchg   %ax,%ax
801031df:	90                   	nop

801031e0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801031e0:	55                   	push   %ebp
801031e1:	ba 21 00 00 00       	mov    $0x21,%edx
801031e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801031eb:	89 e5                	mov    %esp,%ebp
801031ed:	ee                   	out    %al,(%dx)
801031ee:	ba a1 00 00 00       	mov    $0xa1,%edx
801031f3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801031f4:	5d                   	pop    %ebp
801031f5:	c3                   	ret    
801031f6:	66 90                	xchg   %ax,%ax
801031f8:	66 90                	xchg   %ax,%ax
801031fa:	66 90                	xchg   %ax,%ax
801031fc:	66 90                	xchg   %ax,%ax
801031fe:	66 90                	xchg   %ax,%ax

80103200 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103200:	55                   	push   %ebp
80103201:	89 e5                	mov    %esp,%ebp
80103203:	57                   	push   %edi
80103204:	56                   	push   %esi
80103205:	53                   	push   %ebx
80103206:	83 ec 0c             	sub    $0xc,%esp
80103209:	8b 75 08             	mov    0x8(%ebp),%esi
8010320c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010320f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103215:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010321b:	e8 40 db ff ff       	call   80100d60 <filealloc>
80103220:	85 c0                	test   %eax,%eax
80103222:	89 06                	mov    %eax,(%esi)
80103224:	0f 84 a8 00 00 00    	je     801032d2 <pipealloc+0xd2>
8010322a:	e8 31 db ff ff       	call   80100d60 <filealloc>
8010322f:	85 c0                	test   %eax,%eax
80103231:	89 03                	mov    %eax,(%ebx)
80103233:	0f 84 87 00 00 00    	je     801032c0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103239:	e8 52 f2 ff ff       	call   80102490 <kalloc>
8010323e:	85 c0                	test   %eax,%eax
80103240:	89 c7                	mov    %eax,%edi
80103242:	0f 84 b0 00 00 00    	je     801032f8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103248:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
8010324b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103252:	00 00 00 
  p->writeopen = 1;
80103255:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010325c:	00 00 00 
  p->nwrite = 0;
8010325f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103266:	00 00 00 
  p->nread = 0;
80103269:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103270:	00 00 00 
  initlock(&p->lock, "pipe");
80103273:	68 70 76 10 80       	push   $0x80107670
80103278:	50                   	push   %eax
80103279:	e8 c2 0f 00 00       	call   80104240 <initlock>
  (*f0)->type = FD_PIPE;
8010327e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103280:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103283:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103289:	8b 06                	mov    (%esi),%eax
8010328b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010328f:	8b 06                	mov    (%esi),%eax
80103291:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103295:	8b 06                	mov    (%esi),%eax
80103297:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010329a:	8b 03                	mov    (%ebx),%eax
8010329c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801032a2:	8b 03                	mov    (%ebx),%eax
801032a4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801032a8:	8b 03                	mov    (%ebx),%eax
801032aa:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801032ae:	8b 03                	mov    (%ebx),%eax
801032b0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801032b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801032b6:	31 c0                	xor    %eax,%eax
}
801032b8:	5b                   	pop    %ebx
801032b9:	5e                   	pop    %esi
801032ba:	5f                   	pop    %edi
801032bb:	5d                   	pop    %ebp
801032bc:	c3                   	ret    
801032bd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801032c0:	8b 06                	mov    (%esi),%eax
801032c2:	85 c0                	test   %eax,%eax
801032c4:	74 1e                	je     801032e4 <pipealloc+0xe4>
    fileclose(*f0);
801032c6:	83 ec 0c             	sub    $0xc,%esp
801032c9:	50                   	push   %eax
801032ca:	e8 51 db ff ff       	call   80100e20 <fileclose>
801032cf:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801032d2:	8b 03                	mov    (%ebx),%eax
801032d4:	85 c0                	test   %eax,%eax
801032d6:	74 0c                	je     801032e4 <pipealloc+0xe4>
    fileclose(*f1);
801032d8:	83 ec 0c             	sub    $0xc,%esp
801032db:	50                   	push   %eax
801032dc:	e8 3f db ff ff       	call   80100e20 <fileclose>
801032e1:	83 c4 10             	add    $0x10,%esp
}
801032e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801032e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032ec:	5b                   	pop    %ebx
801032ed:	5e                   	pop    %esi
801032ee:	5f                   	pop    %edi
801032ef:	5d                   	pop    %ebp
801032f0:	c3                   	ret    
801032f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801032f8:	8b 06                	mov    (%esi),%eax
801032fa:	85 c0                	test   %eax,%eax
801032fc:	75 c8                	jne    801032c6 <pipealloc+0xc6>
801032fe:	eb d2                	jmp    801032d2 <pipealloc+0xd2>

80103300 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103300:	55                   	push   %ebp
80103301:	89 e5                	mov    %esp,%ebp
80103303:	56                   	push   %esi
80103304:	53                   	push   %ebx
80103305:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103308:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010330b:	83 ec 0c             	sub    $0xc,%esp
8010330e:	53                   	push   %ebx
8010330f:	e8 8c 10 00 00       	call   801043a0 <acquire>
  if(writable){
80103314:	83 c4 10             	add    $0x10,%esp
80103317:	85 f6                	test   %esi,%esi
80103319:	74 45                	je     80103360 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010331b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103321:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103324:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010332b:	00 00 00 
    wakeup(&p->nread);
8010332e:	50                   	push   %eax
8010332f:	e8 2c 0c 00 00       	call   80103f60 <wakeup>
80103334:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103337:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010333d:	85 d2                	test   %edx,%edx
8010333f:	75 0a                	jne    8010334b <pipeclose+0x4b>
80103341:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103347:	85 c0                	test   %eax,%eax
80103349:	74 35                	je     80103380 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010334b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010334e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103351:	5b                   	pop    %ebx
80103352:	5e                   	pop    %esi
80103353:	5d                   	pop    %ebp
    release(&p->lock);
80103354:	e9 f7 10 00 00       	jmp    80104450 <release>
80103359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103360:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103366:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103369:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103370:	00 00 00 
    wakeup(&p->nwrite);
80103373:	50                   	push   %eax
80103374:	e8 e7 0b 00 00       	call   80103f60 <wakeup>
80103379:	83 c4 10             	add    $0x10,%esp
8010337c:	eb b9                	jmp    80103337 <pipeclose+0x37>
8010337e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103380:	83 ec 0c             	sub    $0xc,%esp
80103383:	53                   	push   %ebx
80103384:	e8 c7 10 00 00       	call   80104450 <release>
    kfree((char*)p);
80103389:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010338c:	83 c4 10             	add    $0x10,%esp
}
8010338f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103392:	5b                   	pop    %ebx
80103393:	5e                   	pop    %esi
80103394:	5d                   	pop    %ebp
    kfree((char*)p);
80103395:	e9 46 ef ff ff       	jmp    801022e0 <kfree>
8010339a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801033a0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801033a0:	55                   	push   %ebp
801033a1:	89 e5                	mov    %esp,%ebp
801033a3:	57                   	push   %edi
801033a4:	56                   	push   %esi
801033a5:	53                   	push   %ebx
801033a6:	83 ec 28             	sub    $0x28,%esp
801033a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801033ac:	53                   	push   %ebx
801033ad:	e8 ee 0f 00 00       	call   801043a0 <acquire>
  for(i = 0; i < n; i++){
801033b2:	8b 45 10             	mov    0x10(%ebp),%eax
801033b5:	83 c4 10             	add    $0x10,%esp
801033b8:	85 c0                	test   %eax,%eax
801033ba:	0f 8e ca 00 00 00    	jle    8010348a <pipewrite+0xea>
801033c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801033c3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801033c9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801033cf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801033d2:	03 4d 10             	add    0x10(%ebp),%ecx
801033d5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033d8:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801033de:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801033e4:	39 d0                	cmp    %edx,%eax
801033e6:	75 71                	jne    80103459 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
801033e8:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801033ee:	85 c0                	test   %eax,%eax
801033f0:	74 4e                	je     80103440 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801033f2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801033f8:	eb 3a                	jmp    80103434 <pipewrite+0x94>
801033fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103400:	83 ec 0c             	sub    $0xc,%esp
80103403:	57                   	push   %edi
80103404:	e8 57 0b 00 00       	call   80103f60 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103409:	5a                   	pop    %edx
8010340a:	59                   	pop    %ecx
8010340b:	53                   	push   %ebx
8010340c:	56                   	push   %esi
8010340d:	e8 8e 09 00 00       	call   80103da0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103412:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103418:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010341e:	83 c4 10             	add    $0x10,%esp
80103421:	05 00 02 00 00       	add    $0x200,%eax
80103426:	39 c2                	cmp    %eax,%edx
80103428:	75 36                	jne    80103460 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010342a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103430:	85 c0                	test   %eax,%eax
80103432:	74 0c                	je     80103440 <pipewrite+0xa0>
80103434:	e8 b7 03 00 00       	call   801037f0 <myproc>
80103439:	8b 40 28             	mov    0x28(%eax),%eax
8010343c:	85 c0                	test   %eax,%eax
8010343e:	74 c0                	je     80103400 <pipewrite+0x60>
        release(&p->lock);
80103440:	83 ec 0c             	sub    $0xc,%esp
80103443:	53                   	push   %ebx
80103444:	e8 07 10 00 00       	call   80104450 <release>
        return -1;
80103449:	83 c4 10             	add    $0x10,%esp
8010344c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103451:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103454:	5b                   	pop    %ebx
80103455:	5e                   	pop    %esi
80103456:	5f                   	pop    %edi
80103457:	5d                   	pop    %ebp
80103458:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103459:	89 c2                	mov    %eax,%edx
8010345b:	90                   	nop
8010345c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103460:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103463:	8d 42 01             	lea    0x1(%edx),%eax
80103466:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010346c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103472:	0f b6 0e             	movzbl (%esi),%ecx
80103475:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
80103479:	89 f1                	mov    %esi,%ecx
8010347b:	83 c1 01             	add    $0x1,%ecx
  for(i = 0; i < n; i++){
8010347e:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
80103481:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103484:	0f 85 4e ff ff ff    	jne    801033d8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010348a:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103490:	83 ec 0c             	sub    $0xc,%esp
80103493:	50                   	push   %eax
80103494:	e8 c7 0a 00 00       	call   80103f60 <wakeup>
  release(&p->lock);
80103499:	89 1c 24             	mov    %ebx,(%esp)
8010349c:	e8 af 0f 00 00       	call   80104450 <release>
  return n;
801034a1:	83 c4 10             	add    $0x10,%esp
801034a4:	8b 45 10             	mov    0x10(%ebp),%eax
801034a7:	eb a8                	jmp    80103451 <pipewrite+0xb1>
801034a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801034b0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801034b0:	55                   	push   %ebp
801034b1:	89 e5                	mov    %esp,%ebp
801034b3:	57                   	push   %edi
801034b4:	56                   	push   %esi
801034b5:	53                   	push   %ebx
801034b6:	83 ec 18             	sub    $0x18,%esp
801034b9:	8b 75 08             	mov    0x8(%ebp),%esi
801034bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801034bf:	56                   	push   %esi
801034c0:	e8 db 0e 00 00       	call   801043a0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801034c5:	83 c4 10             	add    $0x10,%esp
801034c8:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801034ce:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801034d4:	75 6a                	jne    80103540 <piperead+0x90>
801034d6:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
801034dc:	85 db                	test   %ebx,%ebx
801034de:	0f 84 c4 00 00 00    	je     801035a8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801034e4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801034ea:	eb 2d                	jmp    80103519 <piperead+0x69>
801034ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034f0:	83 ec 08             	sub    $0x8,%esp
801034f3:	56                   	push   %esi
801034f4:	53                   	push   %ebx
801034f5:	e8 a6 08 00 00       	call   80103da0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801034fa:	83 c4 10             	add    $0x10,%esp
801034fd:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103503:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103509:	75 35                	jne    80103540 <piperead+0x90>
8010350b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103511:	85 d2                	test   %edx,%edx
80103513:	0f 84 8f 00 00 00    	je     801035a8 <piperead+0xf8>
    if(myproc()->killed){
80103519:	e8 d2 02 00 00       	call   801037f0 <myproc>
8010351e:	8b 48 28             	mov    0x28(%eax),%ecx
80103521:	85 c9                	test   %ecx,%ecx
80103523:	74 cb                	je     801034f0 <piperead+0x40>
      release(&p->lock);
80103525:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103528:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010352d:	56                   	push   %esi
8010352e:	e8 1d 0f 00 00       	call   80104450 <release>
      return -1;
80103533:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103536:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103539:	89 d8                	mov    %ebx,%eax
8010353b:	5b                   	pop    %ebx
8010353c:	5e                   	pop    %esi
8010353d:	5f                   	pop    %edi
8010353e:	5d                   	pop    %ebp
8010353f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103540:	8b 45 10             	mov    0x10(%ebp),%eax
80103543:	85 c0                	test   %eax,%eax
80103545:	7e 61                	jle    801035a8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103547:	31 db                	xor    %ebx,%ebx
80103549:	eb 13                	jmp    8010355e <piperead+0xae>
8010354b:	90                   	nop
8010354c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103550:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103556:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
8010355c:	74 1f                	je     8010357d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010355e:	8d 41 01             	lea    0x1(%ecx),%eax
80103561:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103567:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
8010356d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103572:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103575:	83 c3 01             	add    $0x1,%ebx
80103578:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010357b:	75 d3                	jne    80103550 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010357d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103583:	83 ec 0c             	sub    $0xc,%esp
80103586:	50                   	push   %eax
80103587:	e8 d4 09 00 00       	call   80103f60 <wakeup>
  release(&p->lock);
8010358c:	89 34 24             	mov    %esi,(%esp)
8010358f:	e8 bc 0e 00 00       	call   80104450 <release>
  return i;
80103594:	83 c4 10             	add    $0x10,%esp
}
80103597:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010359a:	89 d8                	mov    %ebx,%eax
8010359c:	5b                   	pop    %ebx
8010359d:	5e                   	pop    %esi
8010359e:	5f                   	pop    %edi
8010359f:	5d                   	pop    %ebp
801035a0:	c3                   	ret    
801035a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
801035a8:	31 db                	xor    %ebx,%ebx
801035aa:	eb d1                	jmp    8010357d <piperead+0xcd>
801035ac:	66 90                	xchg   %ax,%ax
801035ae:	66 90                	xchg   %ax,%ax

801035b0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801035b0:	55                   	push   %ebp
801035b1:	89 e5                	mov    %esp,%ebp
801035b3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801035b4:	bb 94 42 11 80       	mov    $0x80114294,%ebx
{
801035b9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801035bc:	68 60 42 11 80       	push   $0x80114260
801035c1:	e8 da 0d 00 00       	call   801043a0 <acquire>
801035c6:	83 c4 10             	add    $0x10,%esp
801035c9:	eb 10                	jmp    801035db <allocproc+0x2b>
801035cb:	90                   	nop
801035cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801035d0:	83 eb 80             	sub    $0xffffff80,%ebx
801035d3:	81 fb 94 62 11 80    	cmp    $0x80116294,%ebx
801035d9:	73 75                	jae    80103650 <allocproc+0xa0>
    if(p->state == UNUSED)
801035db:	8b 43 0c             	mov    0xc(%ebx),%eax
801035de:	85 c0                	test   %eax,%eax
801035e0:	75 ee                	jne    801035d0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801035e2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801035e7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801035ea:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801035f1:	8d 50 01             	lea    0x1(%eax),%edx
801035f4:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
801035f7:	68 60 42 11 80       	push   $0x80114260
  p->pid = nextpid++;
801035fc:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103602:	e8 49 0e 00 00       	call   80104450 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103607:	e8 84 ee ff ff       	call   80102490 <kalloc>
8010360c:	83 c4 10             	add    $0x10,%esp
8010360f:	85 c0                	test   %eax,%eax
80103611:	89 43 08             	mov    %eax,0x8(%ebx)
80103614:	74 53                	je     80103669 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103616:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010361c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010361f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103624:	89 53 1c             	mov    %edx,0x1c(%ebx)
  *(uint*)sp = (uint)trapret;
80103627:	c7 40 14 12 58 10 80 	movl   $0x80105812,0x14(%eax)
  p->context = (struct context*)sp;
8010362e:	89 43 20             	mov    %eax,0x20(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103631:	6a 14                	push   $0x14
80103633:	6a 00                	push   $0x0
80103635:	50                   	push   %eax
80103636:	e8 65 0e 00 00       	call   801044a0 <memset>
  p->context->eip = (uint)forkret;
8010363b:	8b 43 20             	mov    0x20(%ebx),%eax

  return p;
8010363e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103641:	c7 40 10 80 36 10 80 	movl   $0x80103680,0x10(%eax)
}
80103648:	89 d8                	mov    %ebx,%eax
8010364a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010364d:	c9                   	leave  
8010364e:	c3                   	ret    
8010364f:	90                   	nop
  release(&ptable.lock);
80103650:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103653:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103655:	68 60 42 11 80       	push   $0x80114260
8010365a:	e8 f1 0d 00 00       	call   80104450 <release>
}
8010365f:	89 d8                	mov    %ebx,%eax
  return 0;
80103661:	83 c4 10             	add    $0x10,%esp
}
80103664:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103667:	c9                   	leave  
80103668:	c3                   	ret    
    p->state = UNUSED;
80103669:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103670:	31 db                	xor    %ebx,%ebx
80103672:	eb d4                	jmp    80103648 <allocproc+0x98>
80103674:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010367a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103680 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103680:	55                   	push   %ebp
80103681:	89 e5                	mov    %esp,%ebp
80103683:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103686:	68 60 42 11 80       	push   $0x80114260
8010368b:	e8 c0 0d 00 00       	call   80104450 <release>

  if (first) {
80103690:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103695:	83 c4 10             	add    $0x10,%esp
80103698:	85 c0                	test   %eax,%eax
8010369a:	75 04                	jne    801036a0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010369c:	c9                   	leave  
8010369d:	c3                   	ret    
8010369e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
801036a0:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
801036a3:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801036aa:	00 00 00 
    iinit(ROOTDEV);
801036ad:	6a 01                	push   $0x1
801036af:	e8 bc dd ff ff       	call   80101470 <iinit>
    initlog(ROOTDEV);
801036b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801036bb:	e8 10 f4 ff ff       	call   80102ad0 <initlog>
801036c0:	83 c4 10             	add    $0x10,%esp
}
801036c3:	c9                   	leave  
801036c4:	c3                   	ret    
801036c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801036d0 <psHelper>:
void psHelper(int procID, int containerID){
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	56                   	push   %esi
801036d4:	53                   	push   %ebx
801036d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801036d8:	bb 94 42 11 80       	mov    $0x80114294,%ebx
801036dd:	eb 0c                	jmp    801036eb <psHelper+0x1b>
801036df:	90                   	nop
801036e0:	83 eb 80             	sub    $0xffffff80,%ebx
801036e3:	81 fb 94 62 11 80    	cmp    $0x80116294,%ebx
801036e9:	73 32                	jae    8010371d <psHelper+0x4d>
    if(p->containerID == containerID){
801036eb:	39 73 18             	cmp    %esi,0x18(%ebx)
801036ee:	75 f0                	jne    801036e0 <psHelper+0x10>
      if(p->state == RUNNING || p->state == RUNNABLE){
801036f0:	8b 43 0c             	mov    0xc(%ebx),%eax
801036f3:	83 e8 03             	sub    $0x3,%eax
801036f6:	83 f8 01             	cmp    $0x1,%eax
801036f9:	77 e5                	ja     801036e0 <psHelper+0x10>
        cprintf("pid:%d name:%s\n", p->pid, p->name);
801036fb:	8d 43 70             	lea    0x70(%ebx),%eax
801036fe:	83 ec 04             	sub    $0x4,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103701:	83 eb 80             	sub    $0xffffff80,%ebx
        cprintf("pid:%d name:%s\n", p->pid, p->name);
80103704:	50                   	push   %eax
80103705:	ff 73 90             	pushl  -0x70(%ebx)
80103708:	68 75 76 10 80       	push   $0x80107675
8010370d:	e8 4e cf ff ff       	call   80100660 <cprintf>
80103712:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103715:	81 fb 94 62 11 80    	cmp    $0x80116294,%ebx
8010371b:	72 ce                	jb     801036eb <psHelper+0x1b>
}
8010371d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103720:	5b                   	pop    %ebx
80103721:	5e                   	pop    %esi
80103722:	5d                   	pop    %ebp
80103723:	c3                   	ret    
80103724:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010372a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103730 <pinit>:
{
80103730:	55                   	push   %ebp
80103731:	89 e5                	mov    %esp,%ebp
80103733:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103736:	68 85 76 10 80       	push   $0x80107685
8010373b:	68 60 42 11 80       	push   $0x80114260
80103740:	e8 fb 0a 00 00       	call   80104240 <initlock>
}
80103745:	83 c4 10             	add    $0x10,%esp
80103748:	c9                   	leave  
80103749:	c3                   	ret    
8010374a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103750 <mycpu>:
{
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	56                   	push   %esi
80103754:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103755:	9c                   	pushf  
80103756:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103757:	f6 c4 02             	test   $0x2,%ah
8010375a:	75 5e                	jne    801037ba <mycpu+0x6a>
  apicid = lapicid();
8010375c:	e8 9f ef ff ff       	call   80102700 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103761:	8b 35 60 2d 11 80    	mov    0x80112d60,%esi
80103767:	85 f6                	test   %esi,%esi
80103769:	7e 42                	jle    801037ad <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
8010376b:	0f b6 15 e0 27 11 80 	movzbl 0x801127e0,%edx
80103772:	39 d0                	cmp    %edx,%eax
80103774:	74 30                	je     801037a6 <mycpu+0x56>
80103776:	b9 90 28 11 80       	mov    $0x80112890,%ecx
8010377b:	31 d2                	xor    %edx,%edx
8010377d:	8d 76 00             	lea    0x0(%esi),%esi
  for (i = 0; i < ncpu; ++i) {
80103780:	83 c2 01             	add    $0x1,%edx
80103783:	39 f2                	cmp    %esi,%edx
80103785:	74 26                	je     801037ad <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103787:	0f b6 19             	movzbl (%ecx),%ebx
8010378a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103790:	39 d8                	cmp    %ebx,%eax
80103792:	75 ec                	jne    80103780 <mycpu+0x30>
80103794:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
8010379a:	05 e0 27 11 80       	add    $0x801127e0,%eax
}
8010379f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037a2:	5b                   	pop    %ebx
801037a3:	5e                   	pop    %esi
801037a4:	5d                   	pop    %ebp
801037a5:	c3                   	ret    
    if (cpus[i].apicid == apicid)
801037a6:	b8 e0 27 11 80       	mov    $0x801127e0,%eax
      return &cpus[i];
801037ab:	eb f2                	jmp    8010379f <mycpu+0x4f>
  panic("unknown apicid\n");
801037ad:	83 ec 0c             	sub    $0xc,%esp
801037b0:	68 8c 76 10 80       	push   $0x8010768c
801037b5:	e8 b6 cb ff ff       	call   80100370 <panic>
    panic("mycpu called with interrupts enabled\n");
801037ba:	83 ec 0c             	sub    $0xc,%esp
801037bd:	68 68 77 10 80       	push   $0x80107768
801037c2:	e8 a9 cb ff ff       	call   80100370 <panic>
801037c7:	89 f6                	mov    %esi,%esi
801037c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037d0 <cpuid>:
cpuid() {
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801037d6:	e8 75 ff ff ff       	call   80103750 <mycpu>
801037db:	2d e0 27 11 80       	sub    $0x801127e0,%eax
}
801037e0:	c9                   	leave  
  return mycpu()-cpus;
801037e1:	c1 f8 04             	sar    $0x4,%eax
801037e4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801037ea:	c3                   	ret    
801037eb:	90                   	nop
801037ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801037f0 <myproc>:
myproc(void) {
801037f0:	55                   	push   %ebp
801037f1:	89 e5                	mov    %esp,%ebp
801037f3:	53                   	push   %ebx
801037f4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801037f7:	e8 c4 0a 00 00       	call   801042c0 <pushcli>
  c = mycpu();
801037fc:	e8 4f ff ff ff       	call   80103750 <mycpu>
  p = c->proc;
80103801:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103807:	e8 f4 0a 00 00       	call   80104300 <popcli>
}
8010380c:	83 c4 04             	add    $0x4,%esp
8010380f:	89 d8                	mov    %ebx,%eax
80103811:	5b                   	pop    %ebx
80103812:	5d                   	pop    %ebp
80103813:	c3                   	ret    
80103814:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010381a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103820 <userinit>:
{
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	53                   	push   %ebx
80103824:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103827:	e8 84 fd ff ff       	call   801035b0 <allocproc>
8010382c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010382e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103833:	e8 b8 35 00 00       	call   80106df0 <setupkvm>
80103838:	85 c0                	test   %eax,%eax
8010383a:	89 43 04             	mov    %eax,0x4(%ebx)
8010383d:	0f 84 bd 00 00 00    	je     80103900 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103843:	83 ec 04             	sub    $0x4,%esp
80103846:	68 2c 00 00 00       	push   $0x2c
8010384b:	68 60 a4 10 80       	push   $0x8010a460
80103850:	50                   	push   %eax
80103851:	e8 ba 32 00 00       	call   80106b10 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103856:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103859:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010385f:	6a 4c                	push   $0x4c
80103861:	6a 00                	push   $0x0
80103863:	ff 73 1c             	pushl  0x1c(%ebx)
80103866:	e8 35 0c 00 00       	call   801044a0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010386b:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010386e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103873:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103878:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010387b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010387f:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103882:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103886:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103889:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010388d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103891:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103894:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103898:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010389c:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010389f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801038a6:	8b 43 1c             	mov    0x1c(%ebx),%eax
801038a9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801038b0:	8b 43 1c             	mov    0x1c(%ebx),%eax
801038b3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801038ba:	8d 43 70             	lea    0x70(%ebx),%eax
801038bd:	6a 10                	push   $0x10
801038bf:	68 b5 76 10 80       	push   $0x801076b5
801038c4:	50                   	push   %eax
801038c5:	e8 b6 0d 00 00       	call   80104680 <safestrcpy>
  p->cwd = namei("/");
801038ca:	c7 04 24 be 76 10 80 	movl   $0x801076be,(%esp)
801038d1:	e8 ea e5 ff ff       	call   80101ec0 <namei>
801038d6:	89 43 6c             	mov    %eax,0x6c(%ebx)
  acquire(&ptable.lock);
801038d9:	c7 04 24 60 42 11 80 	movl   $0x80114260,(%esp)
801038e0:	e8 bb 0a 00 00       	call   801043a0 <acquire>
  p->state = RUNNABLE;
801038e5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801038ec:	c7 04 24 60 42 11 80 	movl   $0x80114260,(%esp)
801038f3:	e8 58 0b 00 00       	call   80104450 <release>
}
801038f8:	83 c4 10             	add    $0x10,%esp
801038fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038fe:	c9                   	leave  
801038ff:	c3                   	ret    
    panic("userinit: out of memory?");
80103900:	83 ec 0c             	sub    $0xc,%esp
80103903:	68 9c 76 10 80       	push   $0x8010769c
80103908:	e8 63 ca ff ff       	call   80100370 <panic>
8010390d:	8d 76 00             	lea    0x0(%esi),%esi

80103910 <growproc>:
{
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	56                   	push   %esi
80103914:	53                   	push   %ebx
80103915:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103918:	e8 a3 09 00 00       	call   801042c0 <pushcli>
  c = mycpu();
8010391d:	e8 2e fe ff ff       	call   80103750 <mycpu>
  p = c->proc;
80103922:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103928:	e8 d3 09 00 00       	call   80104300 <popcli>
  if(n > 0){
8010392d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103930:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103932:	7e 34                	jle    80103968 <growproc+0x58>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103934:	83 ec 04             	sub    $0x4,%esp
80103937:	01 c6                	add    %eax,%esi
80103939:	56                   	push   %esi
8010393a:	50                   	push   %eax
8010393b:	ff 73 04             	pushl  0x4(%ebx)
8010393e:	e8 0d 33 00 00       	call   80106c50 <allocuvm>
80103943:	83 c4 10             	add    $0x10,%esp
80103946:	85 c0                	test   %eax,%eax
80103948:	74 36                	je     80103980 <growproc+0x70>
  switchuvm(curproc);
8010394a:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
8010394d:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010394f:	53                   	push   %ebx
80103950:	e8 ab 30 00 00       	call   80106a00 <switchuvm>
  return 0;
80103955:	83 c4 10             	add    $0x10,%esp
80103958:	31 c0                	xor    %eax,%eax
}
8010395a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010395d:	5b                   	pop    %ebx
8010395e:	5e                   	pop    %esi
8010395f:	5d                   	pop    %ebp
80103960:	c3                   	ret    
80103961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  } else if(n < 0){
80103968:	74 e0                	je     8010394a <growproc+0x3a>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010396a:	83 ec 04             	sub    $0x4,%esp
8010396d:	01 c6                	add    %eax,%esi
8010396f:	56                   	push   %esi
80103970:	50                   	push   %eax
80103971:	ff 73 04             	pushl  0x4(%ebx)
80103974:	e8 c7 33 00 00       	call   80106d40 <deallocuvm>
80103979:	83 c4 10             	add    $0x10,%esp
8010397c:	85 c0                	test   %eax,%eax
8010397e:	75 ca                	jne    8010394a <growproc+0x3a>
      return -1;
80103980:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103985:	eb d3                	jmp    8010395a <growproc+0x4a>
80103987:	89 f6                	mov    %esi,%esi
80103989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103990 <fork>:
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	57                   	push   %edi
80103994:	56                   	push   %esi
80103995:	53                   	push   %ebx
80103996:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103999:	e8 22 09 00 00       	call   801042c0 <pushcli>
  c = mycpu();
8010399e:	e8 ad fd ff ff       	call   80103750 <mycpu>
  p = c->proc;
801039a3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039a9:	e8 52 09 00 00       	call   80104300 <popcli>
  if((np = allocproc()) == 0){
801039ae:	e8 fd fb ff ff       	call   801035b0 <allocproc>
801039b3:	85 c0                	test   %eax,%eax
801039b5:	89 c7                	mov    %eax,%edi
801039b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801039ba:	0f 84 b5 00 00 00    	je     80103a75 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801039c0:	83 ec 08             	sub    $0x8,%esp
801039c3:	ff 33                	pushl  (%ebx)
801039c5:	ff 73 04             	pushl  0x4(%ebx)
801039c8:	e8 f3 34 00 00       	call   80106ec0 <copyuvm>
801039cd:	83 c4 10             	add    $0x10,%esp
801039d0:	85 c0                	test   %eax,%eax
801039d2:	89 47 04             	mov    %eax,0x4(%edi)
801039d5:	0f 84 a1 00 00 00    	je     80103a7c <fork+0xec>
  np->sz = curproc->sz;
801039db:	8b 03                	mov    (%ebx),%eax
801039dd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801039e0:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
801039e2:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801039e5:	89 c8                	mov    %ecx,%eax
801039e7:	8b 79 1c             	mov    0x1c(%ecx),%edi
801039ea:	8b 73 1c             	mov    0x1c(%ebx),%esi
801039ed:	b9 13 00 00 00       	mov    $0x13,%ecx
801039f2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
801039f4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801039f6:	8b 40 1c             	mov    0x1c(%eax),%eax
801039f9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103a00:	8b 44 b3 2c          	mov    0x2c(%ebx,%esi,4),%eax
80103a04:	85 c0                	test   %eax,%eax
80103a06:	74 13                	je     80103a1b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103a08:	83 ec 0c             	sub    $0xc,%esp
80103a0b:	50                   	push   %eax
80103a0c:	e8 bf d3 ff ff       	call   80100dd0 <filedup>
80103a11:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103a14:	83 c4 10             	add    $0x10,%esp
80103a17:	89 44 b2 2c          	mov    %eax,0x2c(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103a1b:	83 c6 01             	add    $0x1,%esi
80103a1e:	83 fe 10             	cmp    $0x10,%esi
80103a21:	75 dd                	jne    80103a00 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103a23:	83 ec 0c             	sub    $0xc,%esp
80103a26:	ff 73 6c             	pushl  0x6c(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a29:	83 c3 70             	add    $0x70,%ebx
  np->cwd = idup(curproc->cwd);
80103a2c:	e8 0f dc ff ff       	call   80101640 <idup>
80103a31:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a34:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103a37:	89 47 6c             	mov    %eax,0x6c(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a3a:	8d 47 70             	lea    0x70(%edi),%eax
80103a3d:	6a 10                	push   $0x10
80103a3f:	53                   	push   %ebx
80103a40:	50                   	push   %eax
80103a41:	e8 3a 0c 00 00       	call   80104680 <safestrcpy>
  pid = np->pid;
80103a46:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103a49:	c7 04 24 60 42 11 80 	movl   $0x80114260,(%esp)
80103a50:	e8 4b 09 00 00       	call   801043a0 <acquire>
  np->state = RUNNABLE;
80103a55:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103a5c:	c7 04 24 60 42 11 80 	movl   $0x80114260,(%esp)
80103a63:	e8 e8 09 00 00       	call   80104450 <release>
  return pid;
80103a68:	83 c4 10             	add    $0x10,%esp
}
80103a6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a6e:	89 d8                	mov    %ebx,%eax
80103a70:	5b                   	pop    %ebx
80103a71:	5e                   	pop    %esi
80103a72:	5f                   	pop    %edi
80103a73:	5d                   	pop    %ebp
80103a74:	c3                   	ret    
    return -1;
80103a75:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103a7a:	eb ef                	jmp    80103a6b <fork+0xdb>
    kfree(np->kstack);
80103a7c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103a7f:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80103a82:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    kfree(np->kstack);
80103a87:	ff 77 08             	pushl  0x8(%edi)
80103a8a:	e8 51 e8 ff ff       	call   801022e0 <kfree>
    np->kstack = 0;
80103a8f:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103a96:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103a9d:	83 c4 10             	add    $0x10,%esp
80103aa0:	eb c9                	jmp    80103a6b <fork+0xdb>
80103aa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ab0 <scheduler>:
{
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	57                   	push   %edi
80103ab4:	56                   	push   %esi
80103ab5:	53                   	push   %ebx
80103ab6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103ab9:	e8 92 fc ff ff       	call   80103750 <mycpu>
80103abe:	8d 78 04             	lea    0x4(%eax),%edi
80103ac1:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103ac3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103aca:	00 00 00 
80103acd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103ad0:	fb                   	sti    
    acquire(&ptable.lock);
80103ad1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ad4:	bb 94 42 11 80       	mov    $0x80114294,%ebx
    acquire(&ptable.lock);
80103ad9:	68 60 42 11 80       	push   $0x80114260
80103ade:	e8 bd 08 00 00       	call   801043a0 <acquire>
80103ae3:	83 c4 10             	add    $0x10,%esp
80103ae6:	eb 13                	jmp    80103afb <scheduler+0x4b>
80103ae8:	90                   	nop
80103ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103af0:	83 eb 80             	sub    $0xffffff80,%ebx
80103af3:	81 fb 94 62 11 80    	cmp    $0x80116294,%ebx
80103af9:	73 45                	jae    80103b40 <scheduler+0x90>
      if(p->state != RUNNABLE)
80103afb:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103aff:	75 ef                	jne    80103af0 <scheduler+0x40>
      switchuvm(p);
80103b01:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103b04:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103b0a:	53                   	push   %ebx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b0b:	83 eb 80             	sub    $0xffffff80,%ebx
      switchuvm(p);
80103b0e:	e8 ed 2e 00 00       	call   80106a00 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103b13:	58                   	pop    %eax
80103b14:	5a                   	pop    %edx
80103b15:	ff 73 a0             	pushl  -0x60(%ebx)
80103b18:	57                   	push   %edi
      p->state = RUNNING;
80103b19:	c7 43 8c 04 00 00 00 	movl   $0x4,-0x74(%ebx)
      swtch(&(c->scheduler), p->context);
80103b20:	e8 b6 0b 00 00       	call   801046db <swtch>
      switchkvm();
80103b25:	e8 b6 2e 00 00       	call   801069e0 <switchkvm>
      c->proc = 0;
80103b2a:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b2d:	81 fb 94 62 11 80    	cmp    $0x80116294,%ebx
      c->proc = 0;
80103b33:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103b3a:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b3d:	72 bc                	jb     80103afb <scheduler+0x4b>
80103b3f:	90                   	nop
    release(&ptable.lock);
80103b40:	83 ec 0c             	sub    $0xc,%esp
80103b43:	68 60 42 11 80       	push   $0x80114260
80103b48:	e8 03 09 00 00       	call   80104450 <release>
    sti();
80103b4d:	83 c4 10             	add    $0x10,%esp
80103b50:	e9 7b ff ff ff       	jmp    80103ad0 <scheduler+0x20>
80103b55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b60 <sched>:
{
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	56                   	push   %esi
80103b64:	53                   	push   %ebx
  pushcli();
80103b65:	e8 56 07 00 00       	call   801042c0 <pushcli>
  c = mycpu();
80103b6a:	e8 e1 fb ff ff       	call   80103750 <mycpu>
  p = c->proc;
80103b6f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b75:	e8 86 07 00 00       	call   80104300 <popcli>
  if(!holding(&ptable.lock))
80103b7a:	83 ec 0c             	sub    $0xc,%esp
80103b7d:	68 60 42 11 80       	push   $0x80114260
80103b82:	e8 e9 07 00 00       	call   80104370 <holding>
80103b87:	83 c4 10             	add    $0x10,%esp
80103b8a:	85 c0                	test   %eax,%eax
80103b8c:	74 4f                	je     80103bdd <sched+0x7d>
  if(mycpu()->ncli != 1)
80103b8e:	e8 bd fb ff ff       	call   80103750 <mycpu>
80103b93:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103b9a:	75 68                	jne    80103c04 <sched+0xa4>
  if(p->state == RUNNING)
80103b9c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103ba0:	74 55                	je     80103bf7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ba2:	9c                   	pushf  
80103ba3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ba4:	f6 c4 02             	test   $0x2,%ah
80103ba7:	75 41                	jne    80103bea <sched+0x8a>
  intena = mycpu()->intena;
80103ba9:	e8 a2 fb ff ff       	call   80103750 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103bae:	83 c3 20             	add    $0x20,%ebx
  intena = mycpu()->intena;
80103bb1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103bb7:	e8 94 fb ff ff       	call   80103750 <mycpu>
80103bbc:	83 ec 08             	sub    $0x8,%esp
80103bbf:	ff 70 04             	pushl  0x4(%eax)
80103bc2:	53                   	push   %ebx
80103bc3:	e8 13 0b 00 00       	call   801046db <swtch>
  mycpu()->intena = intena;
80103bc8:	e8 83 fb ff ff       	call   80103750 <mycpu>
}
80103bcd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103bd0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103bd6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bd9:	5b                   	pop    %ebx
80103bda:	5e                   	pop    %esi
80103bdb:	5d                   	pop    %ebp
80103bdc:	c3                   	ret    
    panic("sched ptable.lock");
80103bdd:	83 ec 0c             	sub    $0xc,%esp
80103be0:	68 c0 76 10 80       	push   $0x801076c0
80103be5:	e8 86 c7 ff ff       	call   80100370 <panic>
    panic("sched interruptible");
80103bea:	83 ec 0c             	sub    $0xc,%esp
80103bed:	68 ec 76 10 80       	push   $0x801076ec
80103bf2:	e8 79 c7 ff ff       	call   80100370 <panic>
    panic("sched running");
80103bf7:	83 ec 0c             	sub    $0xc,%esp
80103bfa:	68 de 76 10 80       	push   $0x801076de
80103bff:	e8 6c c7 ff ff       	call   80100370 <panic>
    panic("sched locks");
80103c04:	83 ec 0c             	sub    $0xc,%esp
80103c07:	68 d2 76 10 80       	push   $0x801076d2
80103c0c:	e8 5f c7 ff ff       	call   80100370 <panic>
80103c11:	eb 0d                	jmp    80103c20 <exit>
80103c13:	90                   	nop
80103c14:	90                   	nop
80103c15:	90                   	nop
80103c16:	90                   	nop
80103c17:	90                   	nop
80103c18:	90                   	nop
80103c19:	90                   	nop
80103c1a:	90                   	nop
80103c1b:	90                   	nop
80103c1c:	90                   	nop
80103c1d:	90                   	nop
80103c1e:	90                   	nop
80103c1f:	90                   	nop

80103c20 <exit>:
{
80103c20:	55                   	push   %ebp
80103c21:	89 e5                	mov    %esp,%ebp
80103c23:	57                   	push   %edi
80103c24:	56                   	push   %esi
80103c25:	53                   	push   %ebx
80103c26:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103c29:	e8 92 06 00 00       	call   801042c0 <pushcli>
  c = mycpu();
80103c2e:	e8 1d fb ff ff       	call   80103750 <mycpu>
  p = c->proc;
80103c33:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103c39:	e8 c2 06 00 00       	call   80104300 <popcli>
  if(curproc == initproc)
80103c3e:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103c44:	8d 5e 2c             	lea    0x2c(%esi),%ebx
80103c47:	8d 7e 6c             	lea    0x6c(%esi),%edi
80103c4a:	0f 84 e7 00 00 00    	je     80103d37 <exit+0x117>
    if(curproc->ofile[fd]){
80103c50:	8b 03                	mov    (%ebx),%eax
80103c52:	85 c0                	test   %eax,%eax
80103c54:	74 12                	je     80103c68 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103c56:	83 ec 0c             	sub    $0xc,%esp
80103c59:	50                   	push   %eax
80103c5a:	e8 c1 d1 ff ff       	call   80100e20 <fileclose>
      curproc->ofile[fd] = 0;
80103c5f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103c65:	83 c4 10             	add    $0x10,%esp
80103c68:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103c6b:	39 fb                	cmp    %edi,%ebx
80103c6d:	75 e1                	jne    80103c50 <exit+0x30>
  begin_op();
80103c6f:	e8 fc ee ff ff       	call   80102b70 <begin_op>
  iput(curproc->cwd);
80103c74:	83 ec 0c             	sub    $0xc,%esp
80103c77:	ff 76 6c             	pushl  0x6c(%esi)
80103c7a:	e8 21 db ff ff       	call   801017a0 <iput>
  end_op();
80103c7f:	e8 5c ef ff ff       	call   80102be0 <end_op>
  curproc->cwd = 0;
80103c84:	c7 46 6c 00 00 00 00 	movl   $0x0,0x6c(%esi)
  acquire(&ptable.lock);
80103c8b:	c7 04 24 60 42 11 80 	movl   $0x80114260,(%esp)
80103c92:	e8 09 07 00 00       	call   801043a0 <acquire>
  wakeup1(curproc->parent);
80103c97:	8b 56 14             	mov    0x14(%esi),%edx
80103c9a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c9d:	b8 94 42 11 80       	mov    $0x80114294,%eax
80103ca2:	eb 0e                	jmp    80103cb2 <exit+0x92>
80103ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ca8:	83 e8 80             	sub    $0xffffff80,%eax
80103cab:	3d 94 62 11 80       	cmp    $0x80116294,%eax
80103cb0:	73 1c                	jae    80103cce <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan){
80103cb2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103cb6:	75 f0                	jne    80103ca8 <exit+0x88>
80103cb8:	3b 50 24             	cmp    0x24(%eax),%edx
80103cbb:	75 eb                	jne    80103ca8 <exit+0x88>
      p->state = RUNNABLE;
80103cbd:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cc4:	83 e8 80             	sub    $0xffffff80,%eax
80103cc7:	3d 94 62 11 80       	cmp    $0x80116294,%eax
80103ccc:	72 e4                	jb     80103cb2 <exit+0x92>
      p->parent = initproc;
80103cce:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
80103cd4:	ba 94 42 11 80       	mov    $0x80114294,%edx
80103cd9:	eb 10                	jmp    80103ceb <exit+0xcb>
80103cdb:	90                   	nop
80103cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ce0:	83 ea 80             	sub    $0xffffff80,%edx
80103ce3:	81 fa 94 62 11 80    	cmp    $0x80116294,%edx
80103ce9:	73 33                	jae    80103d1e <exit+0xfe>
    if(p->parent == curproc){
80103ceb:	39 72 14             	cmp    %esi,0x14(%edx)
80103cee:	75 f0                	jne    80103ce0 <exit+0xc0>
      if(p->state == ZOMBIE)
80103cf0:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103cf4:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103cf7:	75 e7                	jne    80103ce0 <exit+0xc0>
80103cf9:	b8 94 42 11 80       	mov    $0x80114294,%eax
80103cfe:	eb 0a                	jmp    80103d0a <exit+0xea>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d00:	83 e8 80             	sub    $0xffffff80,%eax
80103d03:	3d 94 62 11 80       	cmp    $0x80116294,%eax
80103d08:	73 d6                	jae    80103ce0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan){
80103d0a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d0e:	75 f0                	jne    80103d00 <exit+0xe0>
80103d10:	3b 48 24             	cmp    0x24(%eax),%ecx
80103d13:	75 eb                	jne    80103d00 <exit+0xe0>
      p->state = RUNNABLE;
80103d15:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103d1c:	eb e2                	jmp    80103d00 <exit+0xe0>
  curproc->state = ZOMBIE;
80103d1e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103d25:	e8 36 fe ff ff       	call   80103b60 <sched>
  panic("zombie exit");
80103d2a:	83 ec 0c             	sub    $0xc,%esp
80103d2d:	68 0d 77 10 80       	push   $0x8010770d
80103d32:	e8 39 c6 ff ff       	call   80100370 <panic>
    panic("init exiting");
80103d37:	83 ec 0c             	sub    $0xc,%esp
80103d3a:	68 00 77 10 80       	push   $0x80107700
80103d3f:	e8 2c c6 ff ff       	call   80100370 <panic>
80103d44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103d4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103d50 <yield>:
{
80103d50:	55                   	push   %ebp
80103d51:	89 e5                	mov    %esp,%ebp
80103d53:	53                   	push   %ebx
80103d54:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103d57:	68 60 42 11 80       	push   $0x80114260
80103d5c:	e8 3f 06 00 00       	call   801043a0 <acquire>
  pushcli();
80103d61:	e8 5a 05 00 00       	call   801042c0 <pushcli>
  c = mycpu();
80103d66:	e8 e5 f9 ff ff       	call   80103750 <mycpu>
  p = c->proc;
80103d6b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d71:	e8 8a 05 00 00       	call   80104300 <popcli>
  myproc()->state = RUNNABLE;
80103d76:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103d7d:	e8 de fd ff ff       	call   80103b60 <sched>
  release(&ptable.lock);
80103d82:	c7 04 24 60 42 11 80 	movl   $0x80114260,(%esp)
80103d89:	e8 c2 06 00 00       	call   80104450 <release>
}
80103d8e:	83 c4 10             	add    $0x10,%esp
80103d91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d94:	c9                   	leave  
80103d95:	c3                   	ret    
80103d96:	8d 76 00             	lea    0x0(%esi),%esi
80103d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103da0 <sleep>:
{
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	57                   	push   %edi
80103da4:	56                   	push   %esi
80103da5:	53                   	push   %ebx
80103da6:	83 ec 0c             	sub    $0xc,%esp
80103da9:	8b 7d 08             	mov    0x8(%ebp),%edi
80103dac:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103daf:	e8 0c 05 00 00       	call   801042c0 <pushcli>
  c = mycpu();
80103db4:	e8 97 f9 ff ff       	call   80103750 <mycpu>
  p = c->proc;
80103db9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103dbf:	e8 3c 05 00 00       	call   80104300 <popcli>
  if(p == 0)
80103dc4:	85 db                	test   %ebx,%ebx
80103dc6:	0f 84 87 00 00 00    	je     80103e53 <sleep+0xb3>
  if(lk == 0)
80103dcc:	85 f6                	test   %esi,%esi
80103dce:	74 76                	je     80103e46 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103dd0:	81 fe 60 42 11 80    	cmp    $0x80114260,%esi
80103dd6:	74 50                	je     80103e28 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103dd8:	83 ec 0c             	sub    $0xc,%esp
80103ddb:	68 60 42 11 80       	push   $0x80114260
80103de0:	e8 bb 05 00 00       	call   801043a0 <acquire>
    release(lk);
80103de5:	89 34 24             	mov    %esi,(%esp)
80103de8:	e8 63 06 00 00       	call   80104450 <release>
  p->chan = chan;
80103ded:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
80103df0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103df7:	e8 64 fd ff ff       	call   80103b60 <sched>
  p->chan = 0;
80103dfc:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
    release(&ptable.lock);
80103e03:	c7 04 24 60 42 11 80 	movl   $0x80114260,(%esp)
80103e0a:	e8 41 06 00 00       	call   80104450 <release>
    acquire(lk);
80103e0f:	89 75 08             	mov    %esi,0x8(%ebp)
80103e12:	83 c4 10             	add    $0x10,%esp
}
80103e15:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e18:	5b                   	pop    %ebx
80103e19:	5e                   	pop    %esi
80103e1a:	5f                   	pop    %edi
80103e1b:	5d                   	pop    %ebp
    acquire(lk);
80103e1c:	e9 7f 05 00 00       	jmp    801043a0 <acquire>
80103e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80103e28:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
80103e2b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103e32:	e8 29 fd ff ff       	call   80103b60 <sched>
  p->chan = 0;
80103e37:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
}
80103e3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e41:	5b                   	pop    %ebx
80103e42:	5e                   	pop    %esi
80103e43:	5f                   	pop    %edi
80103e44:	5d                   	pop    %ebp
80103e45:	c3                   	ret    
    panic("sleep without lk");
80103e46:	83 ec 0c             	sub    $0xc,%esp
80103e49:	68 1f 77 10 80       	push   $0x8010771f
80103e4e:	e8 1d c5 ff ff       	call   80100370 <panic>
    panic("sleep");
80103e53:	83 ec 0c             	sub    $0xc,%esp
80103e56:	68 19 77 10 80       	push   $0x80107719
80103e5b:	e8 10 c5 ff ff       	call   80100370 <panic>

80103e60 <wait>:
{
80103e60:	55                   	push   %ebp
80103e61:	89 e5                	mov    %esp,%ebp
80103e63:	56                   	push   %esi
80103e64:	53                   	push   %ebx
  pushcli();
80103e65:	e8 56 04 00 00       	call   801042c0 <pushcli>
  c = mycpu();
80103e6a:	e8 e1 f8 ff ff       	call   80103750 <mycpu>
  p = c->proc;
80103e6f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103e75:	e8 86 04 00 00       	call   80104300 <popcli>
  acquire(&ptable.lock);
80103e7a:	83 ec 0c             	sub    $0xc,%esp
80103e7d:	68 60 42 11 80       	push   $0x80114260
80103e82:	e8 19 05 00 00       	call   801043a0 <acquire>
80103e87:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103e8a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e8c:	bb 94 42 11 80       	mov    $0x80114294,%ebx
80103e91:	eb 10                	jmp    80103ea3 <wait+0x43>
80103e93:	90                   	nop
80103e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e98:	83 eb 80             	sub    $0xffffff80,%ebx
80103e9b:	81 fb 94 62 11 80    	cmp    $0x80116294,%ebx
80103ea1:	73 1d                	jae    80103ec0 <wait+0x60>
      if(p->parent != curproc)
80103ea3:	39 73 14             	cmp    %esi,0x14(%ebx)
80103ea6:	75 f0                	jne    80103e98 <wait+0x38>
      if(p->state == ZOMBIE){
80103ea8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103eac:	74 30                	je     80103ede <wait+0x7e>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eae:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80103eb1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eb6:	81 fb 94 62 11 80    	cmp    $0x80116294,%ebx
80103ebc:	72 e5                	jb     80103ea3 <wait+0x43>
80103ebe:	66 90                	xchg   %ax,%ax
    if(!havekids || curproc->killed){
80103ec0:	85 c0                	test   %eax,%eax
80103ec2:	74 70                	je     80103f34 <wait+0xd4>
80103ec4:	8b 46 28             	mov    0x28(%esi),%eax
80103ec7:	85 c0                	test   %eax,%eax
80103ec9:	75 69                	jne    80103f34 <wait+0xd4>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103ecb:	83 ec 08             	sub    $0x8,%esp
80103ece:	68 60 42 11 80       	push   $0x80114260
80103ed3:	56                   	push   %esi
80103ed4:	e8 c7 fe ff ff       	call   80103da0 <sleep>
    havekids = 0;
80103ed9:	83 c4 10             	add    $0x10,%esp
80103edc:	eb ac                	jmp    80103e8a <wait+0x2a>
        kfree(p->kstack);
80103ede:	83 ec 0c             	sub    $0xc,%esp
80103ee1:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80103ee4:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103ee7:	e8 f4 e3 ff ff       	call   801022e0 <kfree>
        freevm(p->pgdir);
80103eec:	5a                   	pop    %edx
80103eed:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80103ef0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103ef7:	e8 74 2e 00 00       	call   80106d70 <freevm>
        p->pid = 0;
80103efc:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103f03:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103f0a:	c6 43 70 00          	movb   $0x0,0x70(%ebx)
        p->killed = 0;
80103f0e:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
        p->state = UNUSED;
80103f15:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103f1c:	c7 04 24 60 42 11 80 	movl   $0x80114260,(%esp)
80103f23:	e8 28 05 00 00       	call   80104450 <release>
        return pid;
80103f28:	83 c4 10             	add    $0x10,%esp
}
80103f2b:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f2e:	89 f0                	mov    %esi,%eax
80103f30:	5b                   	pop    %ebx
80103f31:	5e                   	pop    %esi
80103f32:	5d                   	pop    %ebp
80103f33:	c3                   	ret    
      release(&ptable.lock);
80103f34:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103f37:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80103f3c:	68 60 42 11 80       	push   $0x80114260
80103f41:	e8 0a 05 00 00       	call   80104450 <release>
      return -1;
80103f46:	83 c4 10             	add    $0x10,%esp
}
80103f49:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f4c:	89 f0                	mov    %esi,%eax
80103f4e:	5b                   	pop    %ebx
80103f4f:	5e                   	pop    %esi
80103f50:	5d                   	pop    %ebp
80103f51:	c3                   	ret    
80103f52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f60 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103f60:	55                   	push   %ebp
80103f61:	89 e5                	mov    %esp,%ebp
80103f63:	53                   	push   %ebx
80103f64:	83 ec 10             	sub    $0x10,%esp
80103f67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103f6a:	68 60 42 11 80       	push   $0x80114260
80103f6f:	e8 2c 04 00 00       	call   801043a0 <acquire>
80103f74:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f77:	b8 94 42 11 80       	mov    $0x80114294,%eax
80103f7c:	eb 0c                	jmp    80103f8a <wakeup+0x2a>
80103f7e:	66 90                	xchg   %ax,%ax
80103f80:	83 e8 80             	sub    $0xffffff80,%eax
80103f83:	3d 94 62 11 80       	cmp    $0x80116294,%eax
80103f88:	73 1c                	jae    80103fa6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan){
80103f8a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f8e:	75 f0                	jne    80103f80 <wakeup+0x20>
80103f90:	3b 58 24             	cmp    0x24(%eax),%ebx
80103f93:	75 eb                	jne    80103f80 <wakeup+0x20>
      p->state = RUNNABLE;
80103f95:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f9c:	83 e8 80             	sub    $0xffffff80,%eax
80103f9f:	3d 94 62 11 80       	cmp    $0x80116294,%eax
80103fa4:	72 e4                	jb     80103f8a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80103fa6:	c7 45 08 60 42 11 80 	movl   $0x80114260,0x8(%ebp)
}
80103fad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fb0:	c9                   	leave  
  release(&ptable.lock);
80103fb1:	e9 9a 04 00 00       	jmp    80104450 <release>
80103fb6:	8d 76 00             	lea    0x0(%esi),%esi
80103fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fc0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103fc0:	55                   	push   %ebp
80103fc1:	89 e5                	mov    %esp,%ebp
80103fc3:	53                   	push   %ebx
80103fc4:	83 ec 10             	sub    $0x10,%esp
80103fc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103fca:	68 60 42 11 80       	push   $0x80114260
80103fcf:	e8 cc 03 00 00       	call   801043a0 <acquire>
80103fd4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fd7:	b8 94 42 11 80       	mov    $0x80114294,%eax
80103fdc:	eb 0c                	jmp    80103fea <kill+0x2a>
80103fde:	66 90                	xchg   %ax,%ax
80103fe0:	83 e8 80             	sub    $0xffffff80,%eax
80103fe3:	3d 94 62 11 80       	cmp    $0x80116294,%eax
80103fe8:	73 3e                	jae    80104028 <kill+0x68>
    if(p->pid == pid){
80103fea:	39 58 10             	cmp    %ebx,0x10(%eax)
80103fed:	75 f1                	jne    80103fe0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING){
80103fef:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80103ff3:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
      if(p->state == SLEEPING){
80103ffa:	74 1c                	je     80104018 <kill+0x58>
        p->state = RUNNABLE;
      }

      release(&ptable.lock);
80103ffc:	83 ec 0c             	sub    $0xc,%esp
80103fff:	68 60 42 11 80       	push   $0x80114260
80104004:	e8 47 04 00 00       	call   80104450 <release>
      return 0;
80104009:	83 c4 10             	add    $0x10,%esp
8010400c:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
8010400e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104011:	c9                   	leave  
80104012:	c3                   	ret    
80104013:	90                   	nop
80104014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        p->state = RUNNABLE;
80104018:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010401f:	eb db                	jmp    80103ffc <kill+0x3c>
80104021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104028:	83 ec 0c             	sub    $0xc,%esp
8010402b:	68 60 42 11 80       	push   $0x80114260
80104030:	e8 1b 04 00 00       	call   80104450 <release>
  return -1;
80104035:	83 c4 10             	add    $0x10,%esp
80104038:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010403d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104040:	c9                   	leave  
80104041:	c3                   	ret    
80104042:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104050 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104050:	55                   	push   %ebp
80104051:	89 e5                	mov    %esp,%ebp
80104053:	57                   	push   %edi
80104054:	56                   	push   %esi
80104055:	53                   	push   %ebx
80104056:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104059:	bb 94 42 11 80       	mov    $0x80114294,%ebx
{
8010405e:	83 ec 3c             	sub    $0x3c,%esp
80104061:	eb 24                	jmp    80104087 <procdump+0x37>
80104063:	90                   	nop
80104064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104068:	83 ec 0c             	sub    $0xc,%esp
8010406b:	68 2f 7b 10 80       	push   $0x80107b2f
80104070:	e8 eb c5 ff ff       	call   80100660 <cprintf>
80104075:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104078:	83 eb 80             	sub    $0xffffff80,%ebx
8010407b:	81 fb 94 62 11 80    	cmp    $0x80116294,%ebx
80104081:	0f 83 81 00 00 00    	jae    80104108 <procdump+0xb8>
    if(p->state == UNUSED)
80104087:	8b 43 0c             	mov    0xc(%ebx),%eax
8010408a:	85 c0                	test   %eax,%eax
8010408c:	74 ea                	je     80104078 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010408e:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104091:	ba 30 77 10 80       	mov    $0x80107730,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104096:	77 11                	ja     801040a9 <procdump+0x59>
80104098:	8b 14 85 90 77 10 80 	mov    -0x7fef8870(,%eax,4),%edx
      state = "???";
8010409f:	b8 30 77 10 80       	mov    $0x80107730,%eax
801040a4:	85 d2                	test   %edx,%edx
801040a6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801040a9:	8d 43 70             	lea    0x70(%ebx),%eax
801040ac:	50                   	push   %eax
801040ad:	52                   	push   %edx
801040ae:	ff 73 10             	pushl  0x10(%ebx)
801040b1:	68 34 77 10 80       	push   $0x80107734
801040b6:	e8 a5 c5 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
801040bb:	83 c4 10             	add    $0x10,%esp
801040be:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801040c2:	75 a4                	jne    80104068 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801040c4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801040c7:	83 ec 08             	sub    $0x8,%esp
801040ca:	8d 7d c0             	lea    -0x40(%ebp),%edi
801040cd:	50                   	push   %eax
801040ce:	8b 43 20             	mov    0x20(%ebx),%eax
801040d1:	8b 40 0c             	mov    0xc(%eax),%eax
801040d4:	83 c0 08             	add    $0x8,%eax
801040d7:	50                   	push   %eax
801040d8:	e8 83 01 00 00       	call   80104260 <getcallerpcs>
801040dd:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801040e0:	8b 17                	mov    (%edi),%edx
801040e2:	85 d2                	test   %edx,%edx
801040e4:	74 82                	je     80104068 <procdump+0x18>
        cprintf(" %p", pc[i]);
801040e6:	83 ec 08             	sub    $0x8,%esp
801040e9:	83 c7 04             	add    $0x4,%edi
801040ec:	52                   	push   %edx
801040ed:	68 61 71 10 80       	push   $0x80107161
801040f2:	e8 69 c5 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801040f7:	83 c4 10             	add    $0x10,%esp
801040fa:	39 fe                	cmp    %edi,%esi
801040fc:	75 e2                	jne    801040e0 <procdump+0x90>
801040fe:	e9 65 ff ff ff       	jmp    80104068 <procdump+0x18>
80104103:	90                   	nop
80104104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
}
80104108:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010410b:	5b                   	pop    %ebx
8010410c:	5e                   	pop    %esi
8010410d:	5f                   	pop    %edi
8010410e:	5d                   	pop    %ebp
8010410f:	c3                   	ret    

80104110 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104110:	55                   	push   %ebp
80104111:	89 e5                	mov    %esp,%ebp
80104113:	53                   	push   %ebx
80104114:	83 ec 0c             	sub    $0xc,%esp
80104117:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010411a:	68 a8 77 10 80       	push   $0x801077a8
8010411f:	8d 43 04             	lea    0x4(%ebx),%eax
80104122:	50                   	push   %eax
80104123:	e8 18 01 00 00       	call   80104240 <initlock>
  lk->name = name;
80104128:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010412b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104131:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104134:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010413b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010413e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104141:	c9                   	leave  
80104142:	c3                   	ret    
80104143:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104150 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	56                   	push   %esi
80104154:	53                   	push   %ebx
80104155:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104158:	83 ec 0c             	sub    $0xc,%esp
8010415b:	8d 73 04             	lea    0x4(%ebx),%esi
8010415e:	56                   	push   %esi
8010415f:	e8 3c 02 00 00       	call   801043a0 <acquire>
  while (lk->locked) {
80104164:	8b 13                	mov    (%ebx),%edx
80104166:	83 c4 10             	add    $0x10,%esp
80104169:	85 d2                	test   %edx,%edx
8010416b:	74 16                	je     80104183 <acquiresleep+0x33>
8010416d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104170:	83 ec 08             	sub    $0x8,%esp
80104173:	56                   	push   %esi
80104174:	53                   	push   %ebx
80104175:	e8 26 fc ff ff       	call   80103da0 <sleep>
  while (lk->locked) {
8010417a:	8b 03                	mov    (%ebx),%eax
8010417c:	83 c4 10             	add    $0x10,%esp
8010417f:	85 c0                	test   %eax,%eax
80104181:	75 ed                	jne    80104170 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104183:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104189:	e8 62 f6 ff ff       	call   801037f0 <myproc>
8010418e:	8b 40 10             	mov    0x10(%eax),%eax
80104191:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104194:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104197:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010419a:	5b                   	pop    %ebx
8010419b:	5e                   	pop    %esi
8010419c:	5d                   	pop    %ebp
  release(&lk->lk);
8010419d:	e9 ae 02 00 00       	jmp    80104450 <release>
801041a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041b0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801041b0:	55                   	push   %ebp
801041b1:	89 e5                	mov    %esp,%ebp
801041b3:	56                   	push   %esi
801041b4:	53                   	push   %ebx
801041b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801041b8:	83 ec 0c             	sub    $0xc,%esp
801041bb:	8d 73 04             	lea    0x4(%ebx),%esi
801041be:	56                   	push   %esi
801041bf:	e8 dc 01 00 00       	call   801043a0 <acquire>
  lk->locked = 0;
801041c4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801041ca:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801041d1:	89 1c 24             	mov    %ebx,(%esp)
801041d4:	e8 87 fd ff ff       	call   80103f60 <wakeup>
  release(&lk->lk);
801041d9:	89 75 08             	mov    %esi,0x8(%ebp)
801041dc:	83 c4 10             	add    $0x10,%esp
}
801041df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041e2:	5b                   	pop    %ebx
801041e3:	5e                   	pop    %esi
801041e4:	5d                   	pop    %ebp
  release(&lk->lk);
801041e5:	e9 66 02 00 00       	jmp    80104450 <release>
801041ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801041f0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	57                   	push   %edi
801041f4:	56                   	push   %esi
801041f5:	53                   	push   %ebx
801041f6:	31 ff                	xor    %edi,%edi
801041f8:	83 ec 18             	sub    $0x18,%esp
801041fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801041fe:	8d 73 04             	lea    0x4(%ebx),%esi
80104201:	56                   	push   %esi
80104202:	e8 99 01 00 00       	call   801043a0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104207:	8b 03                	mov    (%ebx),%eax
80104209:	83 c4 10             	add    $0x10,%esp
8010420c:	85 c0                	test   %eax,%eax
8010420e:	74 13                	je     80104223 <holdingsleep+0x33>
80104210:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104213:	e8 d8 f5 ff ff       	call   801037f0 <myproc>
80104218:	39 58 10             	cmp    %ebx,0x10(%eax)
8010421b:	0f 94 c0             	sete   %al
8010421e:	0f b6 c0             	movzbl %al,%eax
80104221:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104223:	83 ec 0c             	sub    $0xc,%esp
80104226:	56                   	push   %esi
80104227:	e8 24 02 00 00       	call   80104450 <release>
  return r;
}
8010422c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010422f:	89 f8                	mov    %edi,%eax
80104231:	5b                   	pop    %ebx
80104232:	5e                   	pop    %esi
80104233:	5f                   	pop    %edi
80104234:	5d                   	pop    %ebp
80104235:	c3                   	ret    
80104236:	66 90                	xchg   %ax,%ax
80104238:	66 90                	xchg   %ax,%ax
8010423a:	66 90                	xchg   %ax,%ax
8010423c:	66 90                	xchg   %ax,%ax
8010423e:	66 90                	xchg   %ax,%ax

80104240 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104246:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104249:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010424f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104252:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104259:	5d                   	pop    %ebp
8010425a:	c3                   	ret    
8010425b:	90                   	nop
8010425c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104260 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
80104263:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104264:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104267:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010426a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010426d:	31 c0                	xor    %eax,%eax
8010426f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104270:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104276:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010427c:	77 1a                	ja     80104298 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010427e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104281:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104284:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104287:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104289:	83 f8 0a             	cmp    $0xa,%eax
8010428c:	75 e2                	jne    80104270 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010428e:	5b                   	pop    %ebx
8010428f:	5d                   	pop    %ebp
80104290:	c3                   	ret    
80104291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
80104298:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
8010429f:	83 c0 01             	add    $0x1,%eax
801042a2:	83 f8 0a             	cmp    $0xa,%eax
801042a5:	74 e7                	je     8010428e <getcallerpcs+0x2e>
    pcs[i] = 0;
801042a7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
801042ae:	83 c0 01             	add    $0x1,%eax
801042b1:	83 f8 0a             	cmp    $0xa,%eax
801042b4:	75 e2                	jne    80104298 <getcallerpcs+0x38>
801042b6:	eb d6                	jmp    8010428e <getcallerpcs+0x2e>
801042b8:	90                   	nop
801042b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801042c0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	53                   	push   %ebx
801042c4:	83 ec 04             	sub    $0x4,%esp
801042c7:	9c                   	pushf  
801042c8:	5b                   	pop    %ebx
  asm volatile("cli");
801042c9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801042ca:	e8 81 f4 ff ff       	call   80103750 <mycpu>
801042cf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801042d5:	85 c0                	test   %eax,%eax
801042d7:	75 11                	jne    801042ea <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801042d9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801042df:	e8 6c f4 ff ff       	call   80103750 <mycpu>
801042e4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801042ea:	e8 61 f4 ff ff       	call   80103750 <mycpu>
801042ef:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801042f6:	83 c4 04             	add    $0x4,%esp
801042f9:	5b                   	pop    %ebx
801042fa:	5d                   	pop    %ebp
801042fb:	c3                   	ret    
801042fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104300 <popcli>:

void
popcli(void)
{
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104306:	9c                   	pushf  
80104307:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104308:	f6 c4 02             	test   $0x2,%ah
8010430b:	75 52                	jne    8010435f <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010430d:	e8 3e f4 ff ff       	call   80103750 <mycpu>
80104312:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104318:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010431b:	85 d2                	test   %edx,%edx
8010431d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104323:	78 2d                	js     80104352 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104325:	e8 26 f4 ff ff       	call   80103750 <mycpu>
8010432a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104330:	85 d2                	test   %edx,%edx
80104332:	74 0c                	je     80104340 <popcli+0x40>
    sti();
}
80104334:	c9                   	leave  
80104335:	c3                   	ret    
80104336:	8d 76 00             	lea    0x0(%esi),%esi
80104339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104340:	e8 0b f4 ff ff       	call   80103750 <mycpu>
80104345:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010434b:	85 c0                	test   %eax,%eax
8010434d:	74 e5                	je     80104334 <popcli+0x34>
  asm volatile("sti");
8010434f:	fb                   	sti    
}
80104350:	c9                   	leave  
80104351:	c3                   	ret    
    panic("popcli");
80104352:	83 ec 0c             	sub    $0xc,%esp
80104355:	68 ca 77 10 80       	push   $0x801077ca
8010435a:	e8 11 c0 ff ff       	call   80100370 <panic>
    panic("popcli - interruptible");
8010435f:	83 ec 0c             	sub    $0xc,%esp
80104362:	68 b3 77 10 80       	push   $0x801077b3
80104367:	e8 04 c0 ff ff       	call   80100370 <panic>
8010436c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104370 <holding>:
{
80104370:	55                   	push   %ebp
80104371:	89 e5                	mov    %esp,%ebp
80104373:	56                   	push   %esi
80104374:	53                   	push   %ebx
80104375:	8b 75 08             	mov    0x8(%ebp),%esi
80104378:	31 db                	xor    %ebx,%ebx
  pushcli();
8010437a:	e8 41 ff ff ff       	call   801042c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010437f:	8b 06                	mov    (%esi),%eax
80104381:	85 c0                	test   %eax,%eax
80104383:	74 10                	je     80104395 <holding+0x25>
80104385:	8b 5e 08             	mov    0x8(%esi),%ebx
80104388:	e8 c3 f3 ff ff       	call   80103750 <mycpu>
8010438d:	39 c3                	cmp    %eax,%ebx
8010438f:	0f 94 c3             	sete   %bl
80104392:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104395:	e8 66 ff ff ff       	call   80104300 <popcli>
}
8010439a:	89 d8                	mov    %ebx,%eax
8010439c:	5b                   	pop    %ebx
8010439d:	5e                   	pop    %esi
8010439e:	5d                   	pop    %ebp
8010439f:	c3                   	ret    

801043a0 <acquire>:
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	56                   	push   %esi
801043a4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801043a5:	e8 16 ff ff ff       	call   801042c0 <pushcli>
  if(holding(lk))
801043aa:	8b 75 08             	mov    0x8(%ebp),%esi
801043ad:	83 ec 0c             	sub    $0xc,%esp
801043b0:	56                   	push   %esi
801043b1:	e8 ba ff ff ff       	call   80104370 <holding>
801043b6:	83 c4 10             	add    $0x10,%esp
801043b9:	85 c0                	test   %eax,%eax
801043bb:	0f 85 7f 00 00 00    	jne    80104440 <acquire+0xa0>
801043c1:	89 c3                	mov    %eax,%ebx
  asm volatile("lock; xchgl %0, %1" :
801043c3:	ba 01 00 00 00       	mov    $0x1,%edx
801043c8:	eb 09                	jmp    801043d3 <acquire+0x33>
801043ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801043d0:	8b 75 08             	mov    0x8(%ebp),%esi
801043d3:	89 d0                	mov    %edx,%eax
801043d5:	f0 87 06             	lock xchg %eax,(%esi)
  while(xchg(&lk->locked, 1) != 0)
801043d8:	85 c0                	test   %eax,%eax
801043da:	75 f4                	jne    801043d0 <acquire+0x30>
  __sync_synchronize();
801043dc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801043e1:	8b 75 08             	mov    0x8(%ebp),%esi
801043e4:	e8 67 f3 ff ff       	call   80103750 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801043e9:	8d 56 0c             	lea    0xc(%esi),%edx
  lk->cpu = mycpu();
801043ec:	89 46 08             	mov    %eax,0x8(%esi)
  ebp = (uint*)v - 2;
801043ef:	89 e8                	mov    %ebp,%eax
801043f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801043f8:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
801043fe:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104404:	77 1a                	ja     80104420 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104406:	8b 48 04             	mov    0x4(%eax),%ecx
80104409:	89 0c 9a             	mov    %ecx,(%edx,%ebx,4)
  for(i = 0; i < 10; i++){
8010440c:	83 c3 01             	add    $0x1,%ebx
    ebp = (uint*)ebp[0]; // saved %ebp
8010440f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104411:	83 fb 0a             	cmp    $0xa,%ebx
80104414:	75 e2                	jne    801043f8 <acquire+0x58>
}
80104416:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104419:	5b                   	pop    %ebx
8010441a:	5e                   	pop    %esi
8010441b:	5d                   	pop    %ebp
8010441c:	c3                   	ret    
8010441d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104420:	c7 04 9a 00 00 00 00 	movl   $0x0,(%edx,%ebx,4)
  for(; i < 10; i++)
80104427:	83 c3 01             	add    $0x1,%ebx
8010442a:	83 fb 0a             	cmp    $0xa,%ebx
8010442d:	74 e7                	je     80104416 <acquire+0x76>
    pcs[i] = 0;
8010442f:	c7 04 9a 00 00 00 00 	movl   $0x0,(%edx,%ebx,4)
  for(; i < 10; i++)
80104436:	83 c3 01             	add    $0x1,%ebx
80104439:	83 fb 0a             	cmp    $0xa,%ebx
8010443c:	75 e2                	jne    80104420 <acquire+0x80>
8010443e:	eb d6                	jmp    80104416 <acquire+0x76>
    panic("acquire");
80104440:	83 ec 0c             	sub    $0xc,%esp
80104443:	68 d1 77 10 80       	push   $0x801077d1
80104448:	e8 23 bf ff ff       	call   80100370 <panic>
8010444d:	8d 76 00             	lea    0x0(%esi),%esi

80104450 <release>:
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	53                   	push   %ebx
80104454:	83 ec 10             	sub    $0x10,%esp
80104457:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010445a:	53                   	push   %ebx
8010445b:	e8 10 ff ff ff       	call   80104370 <holding>
80104460:	83 c4 10             	add    $0x10,%esp
80104463:	85 c0                	test   %eax,%eax
80104465:	74 22                	je     80104489 <release+0x39>
  lk->pcs[0] = 0;
80104467:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010446e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104475:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010447a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104480:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104483:	c9                   	leave  
  popcli();
80104484:	e9 77 fe ff ff       	jmp    80104300 <popcli>
    panic("release");
80104489:	83 ec 0c             	sub    $0xc,%esp
8010448c:	68 d9 77 10 80       	push   $0x801077d9
80104491:	e8 da be ff ff       	call   80100370 <panic>
80104496:	66 90                	xchg   %ax,%ax
80104498:	66 90                	xchg   %ax,%ax
8010449a:	66 90                	xchg   %ax,%ax
8010449c:	66 90                	xchg   %ax,%ax
8010449e:	66 90                	xchg   %ax,%ax

801044a0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	57                   	push   %edi
801044a4:	53                   	push   %ebx
801044a5:	8b 55 08             	mov    0x8(%ebp),%edx
801044a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801044ab:	f6 c2 03             	test   $0x3,%dl
801044ae:	75 05                	jne    801044b5 <memset+0x15>
801044b0:	f6 c1 03             	test   $0x3,%cl
801044b3:	74 13                	je     801044c8 <memset+0x28>
  asm volatile("cld; rep stosb" :
801044b5:	89 d7                	mov    %edx,%edi
801044b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801044ba:	fc                   	cld    
801044bb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801044bd:	5b                   	pop    %ebx
801044be:	89 d0                	mov    %edx,%eax
801044c0:	5f                   	pop    %edi
801044c1:	5d                   	pop    %ebp
801044c2:	c3                   	ret    
801044c3:	90                   	nop
801044c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
801044c8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801044cc:	c1 e9 02             	shr    $0x2,%ecx
801044cf:	89 f8                	mov    %edi,%eax
801044d1:	89 fb                	mov    %edi,%ebx
801044d3:	c1 e0 18             	shl    $0x18,%eax
801044d6:	c1 e3 10             	shl    $0x10,%ebx
801044d9:	09 d8                	or     %ebx,%eax
801044db:	09 f8                	or     %edi,%eax
801044dd:	c1 e7 08             	shl    $0x8,%edi
801044e0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801044e2:	89 d7                	mov    %edx,%edi
801044e4:	fc                   	cld    
801044e5:	f3 ab                	rep stos %eax,%es:(%edi)
}
801044e7:	5b                   	pop    %ebx
801044e8:	89 d0                	mov    %edx,%eax
801044ea:	5f                   	pop    %edi
801044eb:	5d                   	pop    %ebp
801044ec:	c3                   	ret    
801044ed:	8d 76 00             	lea    0x0(%esi),%esi

801044f0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	57                   	push   %edi
801044f4:	56                   	push   %esi
801044f5:	53                   	push   %ebx
801044f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801044f9:	8b 75 08             	mov    0x8(%ebp),%esi
801044fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801044ff:	85 db                	test   %ebx,%ebx
80104501:	74 29                	je     8010452c <memcmp+0x3c>
    if(*s1 != *s2)
80104503:	0f b6 16             	movzbl (%esi),%edx
80104506:	0f b6 0f             	movzbl (%edi),%ecx
80104509:	38 d1                	cmp    %dl,%cl
8010450b:	75 2b                	jne    80104538 <memcmp+0x48>
8010450d:	b8 01 00 00 00       	mov    $0x1,%eax
80104512:	eb 14                	jmp    80104528 <memcmp+0x38>
80104514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104518:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010451c:	83 c0 01             	add    $0x1,%eax
8010451f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104524:	38 ca                	cmp    %cl,%dl
80104526:	75 10                	jne    80104538 <memcmp+0x48>
  while(n-- > 0){
80104528:	39 d8                	cmp    %ebx,%eax
8010452a:	75 ec                	jne    80104518 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010452c:	5b                   	pop    %ebx
  return 0;
8010452d:	31 c0                	xor    %eax,%eax
}
8010452f:	5e                   	pop    %esi
80104530:	5f                   	pop    %edi
80104531:	5d                   	pop    %ebp
80104532:	c3                   	ret    
80104533:	90                   	nop
80104534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104538:	0f b6 c2             	movzbl %dl,%eax
}
8010453b:	5b                   	pop    %ebx
      return *s1 - *s2;
8010453c:	29 c8                	sub    %ecx,%eax
}
8010453e:	5e                   	pop    %esi
8010453f:	5f                   	pop    %edi
80104540:	5d                   	pop    %ebp
80104541:	c3                   	ret    
80104542:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104550 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	56                   	push   %esi
80104554:	53                   	push   %ebx
80104555:	8b 45 08             	mov    0x8(%ebp),%eax
80104558:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010455b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010455e:	39 c3                	cmp    %eax,%ebx
80104560:	73 26                	jae    80104588 <memmove+0x38>
80104562:	8d 14 33             	lea    (%ebx,%esi,1),%edx
80104565:	39 d0                	cmp    %edx,%eax
80104567:	73 1f                	jae    80104588 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104569:	85 f6                	test   %esi,%esi
8010456b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010456e:	74 0f                	je     8010457f <memmove+0x2f>
      *--d = *--s;
80104570:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104574:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104577:	83 ea 01             	sub    $0x1,%edx
8010457a:	83 fa ff             	cmp    $0xffffffff,%edx
8010457d:	75 f1                	jne    80104570 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010457f:	5b                   	pop    %ebx
80104580:	5e                   	pop    %esi
80104581:	5d                   	pop    %ebp
80104582:	c3                   	ret    
80104583:	90                   	nop
80104584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104588:	31 d2                	xor    %edx,%edx
8010458a:	85 f6                	test   %esi,%esi
8010458c:	74 f1                	je     8010457f <memmove+0x2f>
8010458e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104590:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104594:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104597:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010459a:	39 f2                	cmp    %esi,%edx
8010459c:	75 f2                	jne    80104590 <memmove+0x40>
}
8010459e:	5b                   	pop    %ebx
8010459f:	5e                   	pop    %esi
801045a0:	5d                   	pop    %ebp
801045a1:	c3                   	ret    
801045a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045b0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801045b3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
801045b4:	eb 9a                	jmp    80104550 <memmove>
801045b6:	8d 76 00             	lea    0x0(%esi),%esi
801045b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045c0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	57                   	push   %edi
801045c4:	56                   	push   %esi
801045c5:	8b 7d 10             	mov    0x10(%ebp),%edi
801045c8:	53                   	push   %ebx
801045c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
801045cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
801045cf:	85 ff                	test   %edi,%edi
801045d1:	74 2f                	je     80104602 <strncmp+0x42>
801045d3:	0f b6 11             	movzbl (%ecx),%edx
801045d6:	0f b6 1e             	movzbl (%esi),%ebx
801045d9:	84 d2                	test   %dl,%dl
801045db:	74 37                	je     80104614 <strncmp+0x54>
801045dd:	38 d3                	cmp    %dl,%bl
801045df:	75 33                	jne    80104614 <strncmp+0x54>
801045e1:	01 f7                	add    %esi,%edi
801045e3:	eb 13                	jmp    801045f8 <strncmp+0x38>
801045e5:	8d 76 00             	lea    0x0(%esi),%esi
801045e8:	0f b6 11             	movzbl (%ecx),%edx
801045eb:	84 d2                	test   %dl,%dl
801045ed:	74 21                	je     80104610 <strncmp+0x50>
801045ef:	0f b6 18             	movzbl (%eax),%ebx
801045f2:	89 c6                	mov    %eax,%esi
801045f4:	38 da                	cmp    %bl,%dl
801045f6:	75 1c                	jne    80104614 <strncmp+0x54>
    n--, p++, q++;
801045f8:	8d 46 01             	lea    0x1(%esi),%eax
801045fb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801045fe:	39 f8                	cmp    %edi,%eax
80104600:	75 e6                	jne    801045e8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104602:	5b                   	pop    %ebx
    return 0;
80104603:	31 c0                	xor    %eax,%eax
}
80104605:	5e                   	pop    %esi
80104606:	5f                   	pop    %edi
80104607:	5d                   	pop    %ebp
80104608:	c3                   	ret    
80104609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104610:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104614:	0f b6 c2             	movzbl %dl,%eax
80104617:	29 d8                	sub    %ebx,%eax
}
80104619:	5b                   	pop    %ebx
8010461a:	5e                   	pop    %esi
8010461b:	5f                   	pop    %edi
8010461c:	5d                   	pop    %ebp
8010461d:	c3                   	ret    
8010461e:	66 90                	xchg   %ax,%ax

80104620 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	56                   	push   %esi
80104624:	53                   	push   %ebx
80104625:	8b 45 08             	mov    0x8(%ebp),%eax
80104628:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010462b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010462e:	89 c2                	mov    %eax,%edx
80104630:	eb 19                	jmp    8010464b <strncpy+0x2b>
80104632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104638:	83 c3 01             	add    $0x1,%ebx
8010463b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010463f:	83 c2 01             	add    $0x1,%edx
80104642:	84 c9                	test   %cl,%cl
80104644:	88 4a ff             	mov    %cl,-0x1(%edx)
80104647:	74 09                	je     80104652 <strncpy+0x32>
80104649:	89 f1                	mov    %esi,%ecx
8010464b:	85 c9                	test   %ecx,%ecx
8010464d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104650:	7f e6                	jg     80104638 <strncpy+0x18>
    ;
  while(n-- > 0)
80104652:	31 c9                	xor    %ecx,%ecx
80104654:	85 f6                	test   %esi,%esi
80104656:	7e 17                	jle    8010466f <strncpy+0x4f>
80104658:	90                   	nop
80104659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104660:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104664:	89 f3                	mov    %esi,%ebx
80104666:	83 c1 01             	add    $0x1,%ecx
80104669:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
8010466b:	85 db                	test   %ebx,%ebx
8010466d:	7f f1                	jg     80104660 <strncpy+0x40>
  return os;
}
8010466f:	5b                   	pop    %ebx
80104670:	5e                   	pop    %esi
80104671:	5d                   	pop    %ebp
80104672:	c3                   	ret    
80104673:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104680 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	56                   	push   %esi
80104684:	53                   	push   %ebx
80104685:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104688:	8b 45 08             	mov    0x8(%ebp),%eax
8010468b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010468e:	85 c9                	test   %ecx,%ecx
80104690:	7e 26                	jle    801046b8 <safestrcpy+0x38>
80104692:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104696:	89 c1                	mov    %eax,%ecx
80104698:	eb 17                	jmp    801046b1 <safestrcpy+0x31>
8010469a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801046a0:	83 c2 01             	add    $0x1,%edx
801046a3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801046a7:	83 c1 01             	add    $0x1,%ecx
801046aa:	84 db                	test   %bl,%bl
801046ac:	88 59 ff             	mov    %bl,-0x1(%ecx)
801046af:	74 04                	je     801046b5 <safestrcpy+0x35>
801046b1:	39 f2                	cmp    %esi,%edx
801046b3:	75 eb                	jne    801046a0 <safestrcpy+0x20>
    ;
  *s = 0;
801046b5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801046b8:	5b                   	pop    %ebx
801046b9:	5e                   	pop    %esi
801046ba:	5d                   	pop    %ebp
801046bb:	c3                   	ret    
801046bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046c0 <strlen>:

int
strlen(const char *s)
{
801046c0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801046c1:	31 c0                	xor    %eax,%eax
{
801046c3:	89 e5                	mov    %esp,%ebp
801046c5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801046c8:	80 3a 00             	cmpb   $0x0,(%edx)
801046cb:	74 0c                	je     801046d9 <strlen+0x19>
801046cd:	8d 76 00             	lea    0x0(%esi),%esi
801046d0:	83 c0 01             	add    $0x1,%eax
801046d3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801046d7:	75 f7                	jne    801046d0 <strlen+0x10>
    ;
  return n;
}
801046d9:	5d                   	pop    %ebp
801046da:	c3                   	ret    

801046db <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801046db:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801046df:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801046e3:	55                   	push   %ebp
  pushl %ebx
801046e4:	53                   	push   %ebx
  pushl %esi
801046e5:	56                   	push   %esi
  pushl %edi
801046e6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801046e7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801046e9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801046eb:	5f                   	pop    %edi
  popl %esi
801046ec:	5e                   	pop    %esi
  popl %ebx
801046ed:	5b                   	pop    %ebx
  popl %ebp
801046ee:	5d                   	pop    %ebp
  ret
801046ef:	c3                   	ret    

801046f0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	53                   	push   %ebx
801046f4:	83 ec 04             	sub    $0x4,%esp
801046f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801046fa:	e8 f1 f0 ff ff       	call   801037f0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801046ff:	8b 00                	mov    (%eax),%eax
80104701:	39 d8                	cmp    %ebx,%eax
80104703:	76 1b                	jbe    80104720 <fetchint+0x30>
80104705:	8d 53 04             	lea    0x4(%ebx),%edx
80104708:	39 d0                	cmp    %edx,%eax
8010470a:	72 14                	jb     80104720 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010470c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010470f:	8b 13                	mov    (%ebx),%edx
80104711:	89 10                	mov    %edx,(%eax)
  return 0;
80104713:	31 c0                	xor    %eax,%eax
}
80104715:	83 c4 04             	add    $0x4,%esp
80104718:	5b                   	pop    %ebx
80104719:	5d                   	pop    %ebp
8010471a:	c3                   	ret    
8010471b:	90                   	nop
8010471c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104720:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104725:	eb ee                	jmp    80104715 <fetchint+0x25>
80104727:	89 f6                	mov    %esi,%esi
80104729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104730 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	53                   	push   %ebx
80104734:	83 ec 04             	sub    $0x4,%esp
80104737:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010473a:	e8 b1 f0 ff ff       	call   801037f0 <myproc>

  if(addr >= curproc->sz)
8010473f:	39 18                	cmp    %ebx,(%eax)
80104741:	76 29                	jbe    8010476c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104743:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104746:	89 da                	mov    %ebx,%edx
80104748:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010474a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010474c:	39 c3                	cmp    %eax,%ebx
8010474e:	73 1c                	jae    8010476c <fetchstr+0x3c>
    if(*s == 0)
80104750:	80 3b 00             	cmpb   $0x0,(%ebx)
80104753:	75 10                	jne    80104765 <fetchstr+0x35>
80104755:	eb 29                	jmp    80104780 <fetchstr+0x50>
80104757:	89 f6                	mov    %esi,%esi
80104759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104760:	80 3a 00             	cmpb   $0x0,(%edx)
80104763:	74 1b                	je     80104780 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104765:	83 c2 01             	add    $0x1,%edx
80104768:	39 d0                	cmp    %edx,%eax
8010476a:	77 f4                	ja     80104760 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
8010476c:	83 c4 04             	add    $0x4,%esp
    return -1;
8010476f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104774:	5b                   	pop    %ebx
80104775:	5d                   	pop    %ebp
80104776:	c3                   	ret    
80104777:	89 f6                	mov    %esi,%esi
80104779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104780:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
80104783:	89 d0                	mov    %edx,%eax
80104785:	29 d8                	sub    %ebx,%eax
}
80104787:	5b                   	pop    %ebx
80104788:	5d                   	pop    %ebp
80104789:	c3                   	ret    
8010478a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104790 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	56                   	push   %esi
80104794:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104795:	e8 56 f0 ff ff       	call   801037f0 <myproc>
8010479a:	8b 40 1c             	mov    0x1c(%eax),%eax
8010479d:	8b 55 08             	mov    0x8(%ebp),%edx
801047a0:	8b 40 44             	mov    0x44(%eax),%eax
801047a3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801047a6:	e8 45 f0 ff ff       	call   801037f0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801047ab:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801047ad:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801047b0:	39 c6                	cmp    %eax,%esi
801047b2:	73 1c                	jae    801047d0 <argint+0x40>
801047b4:	8d 53 08             	lea    0x8(%ebx),%edx
801047b7:	39 d0                	cmp    %edx,%eax
801047b9:	72 15                	jb     801047d0 <argint+0x40>
  *ip = *(int*)(addr);
801047bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801047be:	8b 53 04             	mov    0x4(%ebx),%edx
801047c1:	89 10                	mov    %edx,(%eax)
  return 0;
801047c3:	31 c0                	xor    %eax,%eax
}
801047c5:	5b                   	pop    %ebx
801047c6:	5e                   	pop    %esi
801047c7:	5d                   	pop    %ebp
801047c8:	c3                   	ret    
801047c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801047d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801047d5:	eb ee                	jmp    801047c5 <argint+0x35>
801047d7:	89 f6                	mov    %esi,%esi
801047d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047e0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	56                   	push   %esi
801047e4:	53                   	push   %ebx
801047e5:	83 ec 10             	sub    $0x10,%esp
801047e8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801047eb:	e8 00 f0 ff ff       	call   801037f0 <myproc>
801047f0:	89 c6                	mov    %eax,%esi

  if(argint(n, &i) < 0)
801047f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801047f5:	83 ec 08             	sub    $0x8,%esp
801047f8:	50                   	push   %eax
801047f9:	ff 75 08             	pushl  0x8(%ebp)
801047fc:	e8 8f ff ff ff       	call   80104790 <argint>
80104801:	c1 e8 1f             	shr    $0x1f,%eax
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104804:	83 c4 10             	add    $0x10,%esp
80104807:	84 c0                	test   %al,%al
80104809:	75 2d                	jne    80104838 <argptr+0x58>
8010480b:	89 d8                	mov    %ebx,%eax
8010480d:	c1 e8 1f             	shr    $0x1f,%eax
80104810:	84 c0                	test   %al,%al
80104812:	75 24                	jne    80104838 <argptr+0x58>
80104814:	8b 16                	mov    (%esi),%edx
80104816:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104819:	39 c2                	cmp    %eax,%edx
8010481b:	76 1b                	jbe    80104838 <argptr+0x58>
8010481d:	01 c3                	add    %eax,%ebx
8010481f:	39 da                	cmp    %ebx,%edx
80104821:	72 15                	jb     80104838 <argptr+0x58>
    return -1;
  *pp = (char*)i;
80104823:	8b 55 0c             	mov    0xc(%ebp),%edx
80104826:	89 02                	mov    %eax,(%edx)
  return 0;
80104828:	31 c0                	xor    %eax,%eax
}
8010482a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010482d:	5b                   	pop    %ebx
8010482e:	5e                   	pop    %esi
8010482f:	5d                   	pop    %ebp
80104830:	c3                   	ret    
80104831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104838:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010483d:	eb eb                	jmp    8010482a <argptr+0x4a>
8010483f:	90                   	nop

80104840 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104846:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104849:	50                   	push   %eax
8010484a:	ff 75 08             	pushl  0x8(%ebp)
8010484d:	e8 3e ff ff ff       	call   80104790 <argint>
80104852:	83 c4 10             	add    $0x10,%esp
80104855:	85 c0                	test   %eax,%eax
80104857:	78 17                	js     80104870 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104859:	83 ec 08             	sub    $0x8,%esp
8010485c:	ff 75 0c             	pushl  0xc(%ebp)
8010485f:	ff 75 f4             	pushl  -0xc(%ebp)
80104862:	e8 c9 fe ff ff       	call   80104730 <fetchstr>
80104867:	83 c4 10             	add    $0x10,%esp
}
8010486a:	c9                   	leave  
8010486b:	c3                   	ret    
8010486c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104870:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104875:	c9                   	leave  
80104876:	c3                   	ret    
80104877:	89 f6                	mov    %esi,%esi
80104879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104880 <syscall>:
};

int containers[NCONT] = {0};
void
syscall(void)
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	56                   	push   %esi
80104884:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80104885:	e8 66 ef ff ff       	call   801037f0 <myproc>

  num = curproc->tf->eax;
8010488a:	8b 70 1c             	mov    0x1c(%eax),%esi
  struct proc *curproc = myproc();
8010488d:	89 c3                	mov    %eax,%ebx
  num = curproc->tf->eax;
8010488f:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104892:	8d 50 ff             	lea    -0x1(%eax),%edx
80104895:	83 fa 19             	cmp    $0x19,%edx
80104898:	77 1e                	ja     801048b8 <syscall+0x38>
8010489a:	8b 14 85 00 78 10 80 	mov    -0x7fef8800(,%eax,4),%edx
801048a1:	85 d2                	test   %edx,%edx
801048a3:	74 13                	je     801048b8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801048a5:	ff d2                	call   *%edx
801048a7:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801048aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048ad:	5b                   	pop    %ebx
801048ae:	5e                   	pop    %esi
801048af:	5d                   	pop    %ebp
801048b0:	c3                   	ret    
801048b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
801048b8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801048b9:	8d 43 70             	lea    0x70(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801048bc:	50                   	push   %eax
801048bd:	ff 73 10             	pushl  0x10(%ebx)
801048c0:	68 e1 77 10 80       	push   $0x801077e1
801048c5:	e8 96 bd ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
801048ca:	8b 43 1c             	mov    0x1c(%ebx),%eax
801048cd:	83 c4 10             	add    $0x10,%esp
801048d0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801048d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048da:	5b                   	pop    %ebx
801048db:	5e                   	pop    %esi
801048dc:	5d                   	pop    %ebp
801048dd:	c3                   	ret    
801048de:	66 90                	xchg   %ax,%ax

801048e0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	57                   	push   %edi
801048e4:	56                   	push   %esi
801048e5:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801048e6:	8d 5d da             	lea    -0x26(%ebp),%ebx
{
801048e9:	83 ec 44             	sub    $0x44,%esp
801048ec:	89 4d c0             	mov    %ecx,-0x40(%ebp)
801048ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801048f2:	53                   	push   %ebx
801048f3:	50                   	push   %eax
{
801048f4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
801048f7:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801048fa:	e8 e1 d5 ff ff       	call   80101ee0 <nameiparent>
801048ff:	83 c4 10             	add    $0x10,%esp
80104902:	85 c0                	test   %eax,%eax
80104904:	0f 84 f6 00 00 00    	je     80104a00 <create+0x120>
    return 0;
  ilock(dp);
8010490a:	83 ec 0c             	sub    $0xc,%esp
8010490d:	89 c6                	mov    %eax,%esi
8010490f:	50                   	push   %eax
80104910:	e8 5b cd ff ff       	call   80101670 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104915:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104918:	83 c4 0c             	add    $0xc,%esp
8010491b:	50                   	push   %eax
8010491c:	53                   	push   %ebx
8010491d:	56                   	push   %esi
8010491e:	e8 7d d2 ff ff       	call   80101ba0 <dirlookup>
80104923:	83 c4 10             	add    $0x10,%esp
80104926:	85 c0                	test   %eax,%eax
80104928:	89 c7                	mov    %eax,%edi
8010492a:	74 54                	je     80104980 <create+0xa0>
    iunlockput(dp);
8010492c:	83 ec 0c             	sub    $0xc,%esp
8010492f:	56                   	push   %esi
80104930:	e8 cb cf ff ff       	call   80101900 <iunlockput>
    ilock(ip);
80104935:	89 3c 24             	mov    %edi,(%esp)
80104938:	e8 33 cd ff ff       	call   80101670 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010493d:	83 c4 10             	add    $0x10,%esp
80104940:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104945:	75 19                	jne    80104960 <create+0x80>
80104947:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
8010494c:	75 12                	jne    80104960 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010494e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104951:	89 f8                	mov    %edi,%eax
80104953:	5b                   	pop    %ebx
80104954:	5e                   	pop    %esi
80104955:	5f                   	pop    %edi
80104956:	5d                   	pop    %ebp
80104957:	c3                   	ret    
80104958:	90                   	nop
80104959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
80104960:	83 ec 0c             	sub    $0xc,%esp
80104963:	57                   	push   %edi
    return 0;
80104964:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104966:	e8 95 cf ff ff       	call   80101900 <iunlockput>
    return 0;
8010496b:	83 c4 10             	add    $0x10,%esp
}
8010496e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104971:	89 f8                	mov    %edi,%eax
80104973:	5b                   	pop    %ebx
80104974:	5e                   	pop    %esi
80104975:	5f                   	pop    %edi
80104976:	5d                   	pop    %ebp
80104977:	c3                   	ret    
80104978:	90                   	nop
80104979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = ialloc(dp->dev, type)) == 0)
80104980:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104984:	83 ec 08             	sub    $0x8,%esp
80104987:	50                   	push   %eax
80104988:	ff 36                	pushl  (%esi)
8010498a:	e8 71 cb ff ff       	call   80101500 <ialloc>
8010498f:	83 c4 10             	add    $0x10,%esp
80104992:	85 c0                	test   %eax,%eax
80104994:	89 c7                	mov    %eax,%edi
80104996:	0f 84 cc 00 00 00    	je     80104a68 <create+0x188>
  ilock(ip);
8010499c:	83 ec 0c             	sub    $0xc,%esp
8010499f:	50                   	push   %eax
801049a0:	e8 cb cc ff ff       	call   80101670 <ilock>
  ip->major = major;
801049a5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801049a9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
801049ad:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801049b1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
801049b5:	b8 01 00 00 00       	mov    $0x1,%eax
801049ba:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
801049be:	89 3c 24             	mov    %edi,(%esp)
801049c1:	e8 fa cb ff ff       	call   801015c0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801049c6:	83 c4 10             	add    $0x10,%esp
801049c9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
801049ce:	74 40                	je     80104a10 <create+0x130>
  if(dirlink(dp, name, ip->inum) < 0)
801049d0:	83 ec 04             	sub    $0x4,%esp
801049d3:	ff 77 04             	pushl  0x4(%edi)
801049d6:	53                   	push   %ebx
801049d7:	56                   	push   %esi
801049d8:	e8 23 d4 ff ff       	call   80101e00 <dirlink>
801049dd:	83 c4 10             	add    $0x10,%esp
801049e0:	85 c0                	test   %eax,%eax
801049e2:	78 77                	js     80104a5b <create+0x17b>
  iunlockput(dp);
801049e4:	83 ec 0c             	sub    $0xc,%esp
801049e7:	56                   	push   %esi
801049e8:	e8 13 cf ff ff       	call   80101900 <iunlockput>
  return ip;
801049ed:	83 c4 10             	add    $0x10,%esp
}
801049f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049f3:	89 f8                	mov    %edi,%eax
801049f5:	5b                   	pop    %ebx
801049f6:	5e                   	pop    %esi
801049f7:	5f                   	pop    %edi
801049f8:	5d                   	pop    %ebp
801049f9:	c3                   	ret    
801049fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return 0;
80104a00:	31 ff                	xor    %edi,%edi
80104a02:	e9 47 ff ff ff       	jmp    8010494e <create+0x6e>
80104a07:	89 f6                	mov    %esi,%esi
80104a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    dp->nlink++;  // for ".."
80104a10:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
80104a15:	83 ec 0c             	sub    $0xc,%esp
80104a18:	56                   	push   %esi
80104a19:	e8 a2 cb ff ff       	call   801015c0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104a1e:	83 c4 0c             	add    $0xc,%esp
80104a21:	ff 77 04             	pushl  0x4(%edi)
80104a24:	68 88 78 10 80       	push   $0x80107888
80104a29:	57                   	push   %edi
80104a2a:	e8 d1 d3 ff ff       	call   80101e00 <dirlink>
80104a2f:	83 c4 10             	add    $0x10,%esp
80104a32:	85 c0                	test   %eax,%eax
80104a34:	78 18                	js     80104a4e <create+0x16e>
80104a36:	83 ec 04             	sub    $0x4,%esp
80104a39:	ff 76 04             	pushl  0x4(%esi)
80104a3c:	68 87 78 10 80       	push   $0x80107887
80104a41:	57                   	push   %edi
80104a42:	e8 b9 d3 ff ff       	call   80101e00 <dirlink>
80104a47:	83 c4 10             	add    $0x10,%esp
80104a4a:	85 c0                	test   %eax,%eax
80104a4c:	79 82                	jns    801049d0 <create+0xf0>
      panic("create dots");
80104a4e:	83 ec 0c             	sub    $0xc,%esp
80104a51:	68 7b 78 10 80       	push   $0x8010787b
80104a56:	e8 15 b9 ff ff       	call   80100370 <panic>
    panic("create: dirlink");
80104a5b:	83 ec 0c             	sub    $0xc,%esp
80104a5e:	68 8a 78 10 80       	push   $0x8010788a
80104a63:	e8 08 b9 ff ff       	call   80100370 <panic>
    panic("create: ialloc");
80104a68:	83 ec 0c             	sub    $0xc,%esp
80104a6b:	68 6c 78 10 80       	push   $0x8010786c
80104a70:	e8 fb b8 ff ff       	call   80100370 <panic>
80104a75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a80 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	56                   	push   %esi
80104a84:	53                   	push   %ebx
80104a85:	89 c6                	mov    %eax,%esi
  if(argint(n, &fd) < 0)
80104a87:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104a8a:	89 d3                	mov    %edx,%ebx
80104a8c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104a8f:	50                   	push   %eax
80104a90:	6a 00                	push   $0x0
80104a92:	e8 f9 fc ff ff       	call   80104790 <argint>
80104a97:	83 c4 10             	add    $0x10,%esp
80104a9a:	85 c0                	test   %eax,%eax
80104a9c:	78 32                	js     80104ad0 <argfd.constprop.0+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104a9e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104aa2:	77 2c                	ja     80104ad0 <argfd.constprop.0+0x50>
80104aa4:	e8 47 ed ff ff       	call   801037f0 <myproc>
80104aa9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104aac:	8b 44 90 2c          	mov    0x2c(%eax,%edx,4),%eax
80104ab0:	85 c0                	test   %eax,%eax
80104ab2:	74 1c                	je     80104ad0 <argfd.constprop.0+0x50>
  if(pfd)
80104ab4:	85 f6                	test   %esi,%esi
80104ab6:	74 02                	je     80104aba <argfd.constprop.0+0x3a>
    *pfd = fd;
80104ab8:	89 16                	mov    %edx,(%esi)
  if(pf)
80104aba:	85 db                	test   %ebx,%ebx
80104abc:	74 22                	je     80104ae0 <argfd.constprop.0+0x60>
    *pf = f;
80104abe:	89 03                	mov    %eax,(%ebx)
  return 0;
80104ac0:	31 c0                	xor    %eax,%eax
}
80104ac2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ac5:	5b                   	pop    %ebx
80104ac6:	5e                   	pop    %esi
80104ac7:	5d                   	pop    %ebp
80104ac8:	c3                   	ret    
80104ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ad0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104ad3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ad8:	5b                   	pop    %ebx
80104ad9:	5e                   	pop    %esi
80104ada:	5d                   	pop    %ebp
80104adb:	c3                   	ret    
80104adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return 0;
80104ae0:	31 c0                	xor    %eax,%eax
80104ae2:	eb de                	jmp    80104ac2 <argfd.constprop.0+0x42>
80104ae4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104aea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104af0 <sys_dup>:
{
80104af0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104af1:	31 c0                	xor    %eax,%eax
{
80104af3:	89 e5                	mov    %esp,%ebp
80104af5:	56                   	push   %esi
80104af6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104af7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104afa:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104afd:	e8 7e ff ff ff       	call   80104a80 <argfd.constprop.0>
80104b02:	85 c0                	test   %eax,%eax
80104b04:	78 1a                	js     80104b20 <sys_dup+0x30>
  for(fd = 0; fd < NOFILE; fd++){
80104b06:	31 db                	xor    %ebx,%ebx
  if((fd=fdalloc(f)) < 0)
80104b08:	8b 75 f4             	mov    -0xc(%ebp),%esi
  struct proc *curproc = myproc();
80104b0b:	e8 e0 ec ff ff       	call   801037f0 <myproc>
    if(curproc->ofile[fd] == 0){
80104b10:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
80104b14:	85 d2                	test   %edx,%edx
80104b16:	74 18                	je     80104b30 <sys_dup+0x40>
  for(fd = 0; fd < NOFILE; fd++){
80104b18:	83 c3 01             	add    $0x1,%ebx
80104b1b:	83 fb 10             	cmp    $0x10,%ebx
80104b1e:	75 f0                	jne    80104b10 <sys_dup+0x20>
}
80104b20:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104b23:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104b28:	89 d8                	mov    %ebx,%eax
80104b2a:	5b                   	pop    %ebx
80104b2b:	5e                   	pop    %esi
80104b2c:	5d                   	pop    %ebp
80104b2d:	c3                   	ret    
80104b2e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80104b30:	89 74 98 2c          	mov    %esi,0x2c(%eax,%ebx,4)
  filedup(f);
80104b34:	83 ec 0c             	sub    $0xc,%esp
80104b37:	ff 75 f4             	pushl  -0xc(%ebp)
80104b3a:	e8 91 c2 ff ff       	call   80100dd0 <filedup>
  return fd;
80104b3f:	83 c4 10             	add    $0x10,%esp
}
80104b42:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b45:	89 d8                	mov    %ebx,%eax
80104b47:	5b                   	pop    %ebx
80104b48:	5e                   	pop    %esi
80104b49:	5d                   	pop    %ebp
80104b4a:	c3                   	ret    
80104b4b:	90                   	nop
80104b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b50 <sys_read>:
{
80104b50:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b51:	31 c0                	xor    %eax,%eax
{
80104b53:	89 e5                	mov    %esp,%ebp
80104b55:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b58:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104b5b:	e8 20 ff ff ff       	call   80104a80 <argfd.constprop.0>
80104b60:	85 c0                	test   %eax,%eax
80104b62:	78 4c                	js     80104bb0 <sys_read+0x60>
80104b64:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b67:	83 ec 08             	sub    $0x8,%esp
80104b6a:	50                   	push   %eax
80104b6b:	6a 02                	push   $0x2
80104b6d:	e8 1e fc ff ff       	call   80104790 <argint>
80104b72:	83 c4 10             	add    $0x10,%esp
80104b75:	85 c0                	test   %eax,%eax
80104b77:	78 37                	js     80104bb0 <sys_read+0x60>
80104b79:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b7c:	83 ec 04             	sub    $0x4,%esp
80104b7f:	ff 75 f0             	pushl  -0x10(%ebp)
80104b82:	50                   	push   %eax
80104b83:	6a 01                	push   $0x1
80104b85:	e8 56 fc ff ff       	call   801047e0 <argptr>
80104b8a:	83 c4 10             	add    $0x10,%esp
80104b8d:	85 c0                	test   %eax,%eax
80104b8f:	78 1f                	js     80104bb0 <sys_read+0x60>
  return fileread(f, p, n);
80104b91:	83 ec 04             	sub    $0x4,%esp
80104b94:	ff 75 f0             	pushl  -0x10(%ebp)
80104b97:	ff 75 f4             	pushl  -0xc(%ebp)
80104b9a:	ff 75 ec             	pushl  -0x14(%ebp)
80104b9d:	e8 9e c3 ff ff       	call   80100f40 <fileread>
80104ba2:	83 c4 10             	add    $0x10,%esp
}
80104ba5:	c9                   	leave  
80104ba6:	c3                   	ret    
80104ba7:	89 f6                	mov    %esi,%esi
80104ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104bb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bb5:	c9                   	leave  
80104bb6:	c3                   	ret    
80104bb7:	89 f6                	mov    %esi,%esi
80104bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bc0 <sys_write>:
{
80104bc0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104bc1:	31 c0                	xor    %eax,%eax
{
80104bc3:	89 e5                	mov    %esp,%ebp
80104bc5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104bc8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104bcb:	e8 b0 fe ff ff       	call   80104a80 <argfd.constprop.0>
80104bd0:	85 c0                	test   %eax,%eax
80104bd2:	78 4c                	js     80104c20 <sys_write+0x60>
80104bd4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104bd7:	83 ec 08             	sub    $0x8,%esp
80104bda:	50                   	push   %eax
80104bdb:	6a 02                	push   $0x2
80104bdd:	e8 ae fb ff ff       	call   80104790 <argint>
80104be2:	83 c4 10             	add    $0x10,%esp
80104be5:	85 c0                	test   %eax,%eax
80104be7:	78 37                	js     80104c20 <sys_write+0x60>
80104be9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bec:	83 ec 04             	sub    $0x4,%esp
80104bef:	ff 75 f0             	pushl  -0x10(%ebp)
80104bf2:	50                   	push   %eax
80104bf3:	6a 01                	push   $0x1
80104bf5:	e8 e6 fb ff ff       	call   801047e0 <argptr>
80104bfa:	83 c4 10             	add    $0x10,%esp
80104bfd:	85 c0                	test   %eax,%eax
80104bff:	78 1f                	js     80104c20 <sys_write+0x60>
  return filewrite(f, p, n);
80104c01:	83 ec 04             	sub    $0x4,%esp
80104c04:	ff 75 f0             	pushl  -0x10(%ebp)
80104c07:	ff 75 f4             	pushl  -0xc(%ebp)
80104c0a:	ff 75 ec             	pushl  -0x14(%ebp)
80104c0d:	e8 be c3 ff ff       	call   80100fd0 <filewrite>
80104c12:	83 c4 10             	add    $0x10,%esp
}
80104c15:	c9                   	leave  
80104c16:	c3                   	ret    
80104c17:	89 f6                	mov    %esi,%esi
80104c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104c20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c25:	c9                   	leave  
80104c26:	c3                   	ret    
80104c27:	89 f6                	mov    %esi,%esi
80104c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c30 <sys_close>:
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104c36:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104c39:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c3c:	e8 3f fe ff ff       	call   80104a80 <argfd.constprop.0>
80104c41:	85 c0                	test   %eax,%eax
80104c43:	78 2b                	js     80104c70 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104c45:	e8 a6 eb ff ff       	call   801037f0 <myproc>
80104c4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104c4d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104c50:	c7 44 90 2c 00 00 00 	movl   $0x0,0x2c(%eax,%edx,4)
80104c57:	00 
  fileclose(f);
80104c58:	ff 75 f4             	pushl  -0xc(%ebp)
80104c5b:	e8 c0 c1 ff ff       	call   80100e20 <fileclose>
  return 0;
80104c60:	83 c4 10             	add    $0x10,%esp
80104c63:	31 c0                	xor    %eax,%eax
}
80104c65:	c9                   	leave  
80104c66:	c3                   	ret    
80104c67:	89 f6                	mov    %esi,%esi
80104c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104c70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c75:	c9                   	leave  
80104c76:	c3                   	ret    
80104c77:	89 f6                	mov    %esi,%esi
80104c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c80 <sys_fstat>:
{
80104c80:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104c81:	31 c0                	xor    %eax,%eax
{
80104c83:	89 e5                	mov    %esp,%ebp
80104c85:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104c88:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104c8b:	e8 f0 fd ff ff       	call   80104a80 <argfd.constprop.0>
80104c90:	85 c0                	test   %eax,%eax
80104c92:	78 2c                	js     80104cc0 <sys_fstat+0x40>
80104c94:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c97:	83 ec 04             	sub    $0x4,%esp
80104c9a:	6a 14                	push   $0x14
80104c9c:	50                   	push   %eax
80104c9d:	6a 01                	push   $0x1
80104c9f:	e8 3c fb ff ff       	call   801047e0 <argptr>
80104ca4:	83 c4 10             	add    $0x10,%esp
80104ca7:	85 c0                	test   %eax,%eax
80104ca9:	78 15                	js     80104cc0 <sys_fstat+0x40>
  return filestat(f, st);
80104cab:	83 ec 08             	sub    $0x8,%esp
80104cae:	ff 75 f4             	pushl  -0xc(%ebp)
80104cb1:	ff 75 f0             	pushl  -0x10(%ebp)
80104cb4:	e8 37 c2 ff ff       	call   80100ef0 <filestat>
80104cb9:	83 c4 10             	add    $0x10,%esp
}
80104cbc:	c9                   	leave  
80104cbd:	c3                   	ret    
80104cbe:	66 90                	xchg   %ax,%ax
    return -1;
80104cc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cc5:	c9                   	leave  
80104cc6:	c3                   	ret    
80104cc7:	89 f6                	mov    %esi,%esi
80104cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cd0 <sys_link>:
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	57                   	push   %edi
80104cd4:	56                   	push   %esi
80104cd5:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104cd6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104cd9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104cdc:	50                   	push   %eax
80104cdd:	6a 00                	push   $0x0
80104cdf:	e8 5c fb ff ff       	call   80104840 <argstr>
80104ce4:	83 c4 10             	add    $0x10,%esp
80104ce7:	85 c0                	test   %eax,%eax
80104ce9:	0f 88 fb 00 00 00    	js     80104dea <sys_link+0x11a>
80104cef:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104cf2:	83 ec 08             	sub    $0x8,%esp
80104cf5:	50                   	push   %eax
80104cf6:	6a 01                	push   $0x1
80104cf8:	e8 43 fb ff ff       	call   80104840 <argstr>
80104cfd:	83 c4 10             	add    $0x10,%esp
80104d00:	85 c0                	test   %eax,%eax
80104d02:	0f 88 e2 00 00 00    	js     80104dea <sys_link+0x11a>
  begin_op();
80104d08:	e8 63 de ff ff       	call   80102b70 <begin_op>
  if((ip = namei(old)) == 0){
80104d0d:	83 ec 0c             	sub    $0xc,%esp
80104d10:	ff 75 d4             	pushl  -0x2c(%ebp)
80104d13:	e8 a8 d1 ff ff       	call   80101ec0 <namei>
80104d18:	83 c4 10             	add    $0x10,%esp
80104d1b:	85 c0                	test   %eax,%eax
80104d1d:	89 c3                	mov    %eax,%ebx
80104d1f:	0f 84 f3 00 00 00    	je     80104e18 <sys_link+0x148>
  ilock(ip);
80104d25:	83 ec 0c             	sub    $0xc,%esp
80104d28:	50                   	push   %eax
80104d29:	e8 42 c9 ff ff       	call   80101670 <ilock>
  if(ip->type == T_DIR){
80104d2e:	83 c4 10             	add    $0x10,%esp
80104d31:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104d36:	0f 84 c4 00 00 00    	je     80104e00 <sys_link+0x130>
  ip->nlink++;
80104d3c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104d41:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80104d44:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104d47:	53                   	push   %ebx
80104d48:	e8 73 c8 ff ff       	call   801015c0 <iupdate>
  iunlock(ip);
80104d4d:	89 1c 24             	mov    %ebx,(%esp)
80104d50:	e8 fb c9 ff ff       	call   80101750 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104d55:	58                   	pop    %eax
80104d56:	5a                   	pop    %edx
80104d57:	57                   	push   %edi
80104d58:	ff 75 d0             	pushl  -0x30(%ebp)
80104d5b:	e8 80 d1 ff ff       	call   80101ee0 <nameiparent>
80104d60:	83 c4 10             	add    $0x10,%esp
80104d63:	85 c0                	test   %eax,%eax
80104d65:	89 c6                	mov    %eax,%esi
80104d67:	74 5b                	je     80104dc4 <sys_link+0xf4>
  ilock(dp);
80104d69:	83 ec 0c             	sub    $0xc,%esp
80104d6c:	50                   	push   %eax
80104d6d:	e8 fe c8 ff ff       	call   80101670 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104d72:	83 c4 10             	add    $0x10,%esp
80104d75:	8b 03                	mov    (%ebx),%eax
80104d77:	39 06                	cmp    %eax,(%esi)
80104d79:	75 3d                	jne    80104db8 <sys_link+0xe8>
80104d7b:	83 ec 04             	sub    $0x4,%esp
80104d7e:	ff 73 04             	pushl  0x4(%ebx)
80104d81:	57                   	push   %edi
80104d82:	56                   	push   %esi
80104d83:	e8 78 d0 ff ff       	call   80101e00 <dirlink>
80104d88:	83 c4 10             	add    $0x10,%esp
80104d8b:	85 c0                	test   %eax,%eax
80104d8d:	78 29                	js     80104db8 <sys_link+0xe8>
  iunlockput(dp);
80104d8f:	83 ec 0c             	sub    $0xc,%esp
80104d92:	56                   	push   %esi
80104d93:	e8 68 cb ff ff       	call   80101900 <iunlockput>
  iput(ip);
80104d98:	89 1c 24             	mov    %ebx,(%esp)
80104d9b:	e8 00 ca ff ff       	call   801017a0 <iput>
  end_op();
80104da0:	e8 3b de ff ff       	call   80102be0 <end_op>
  return 0;
80104da5:	83 c4 10             	add    $0x10,%esp
80104da8:	31 c0                	xor    %eax,%eax
}
80104daa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104dad:	5b                   	pop    %ebx
80104dae:	5e                   	pop    %esi
80104daf:	5f                   	pop    %edi
80104db0:	5d                   	pop    %ebp
80104db1:	c3                   	ret    
80104db2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80104db8:	83 ec 0c             	sub    $0xc,%esp
80104dbb:	56                   	push   %esi
80104dbc:	e8 3f cb ff ff       	call   80101900 <iunlockput>
    goto bad;
80104dc1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104dc4:	83 ec 0c             	sub    $0xc,%esp
80104dc7:	53                   	push   %ebx
80104dc8:	e8 a3 c8 ff ff       	call   80101670 <ilock>
  ip->nlink--;
80104dcd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104dd2:	89 1c 24             	mov    %ebx,(%esp)
80104dd5:	e8 e6 c7 ff ff       	call   801015c0 <iupdate>
  iunlockput(ip);
80104dda:	89 1c 24             	mov    %ebx,(%esp)
80104ddd:	e8 1e cb ff ff       	call   80101900 <iunlockput>
  end_op();
80104de2:	e8 f9 dd ff ff       	call   80102be0 <end_op>
  return -1;
80104de7:	83 c4 10             	add    $0x10,%esp
}
80104dea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80104ded:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104df2:	5b                   	pop    %ebx
80104df3:	5e                   	pop    %esi
80104df4:	5f                   	pop    %edi
80104df5:	5d                   	pop    %ebp
80104df6:	c3                   	ret    
80104df7:	89 f6                	mov    %esi,%esi
80104df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80104e00:	83 ec 0c             	sub    $0xc,%esp
80104e03:	53                   	push   %ebx
80104e04:	e8 f7 ca ff ff       	call   80101900 <iunlockput>
    end_op();
80104e09:	e8 d2 dd ff ff       	call   80102be0 <end_op>
    return -1;
80104e0e:	83 c4 10             	add    $0x10,%esp
80104e11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e16:	eb 92                	jmp    80104daa <sys_link+0xda>
    end_op();
80104e18:	e8 c3 dd ff ff       	call   80102be0 <end_op>
    return -1;
80104e1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e22:	eb 86                	jmp    80104daa <sys_link+0xda>
80104e24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104e30 <sys_unlink>:
{
80104e30:	55                   	push   %ebp
80104e31:	89 e5                	mov    %esp,%ebp
80104e33:	57                   	push   %edi
80104e34:	56                   	push   %esi
80104e35:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80104e36:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80104e39:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80104e3c:	50                   	push   %eax
80104e3d:	6a 00                	push   $0x0
80104e3f:	e8 fc f9 ff ff       	call   80104840 <argstr>
80104e44:	83 c4 10             	add    $0x10,%esp
80104e47:	85 c0                	test   %eax,%eax
80104e49:	0f 88 82 01 00 00    	js     80104fd1 <sys_unlink+0x1a1>
  if((dp = nameiparent(path, name)) == 0){
80104e4f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80104e52:	e8 19 dd ff ff       	call   80102b70 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104e57:	83 ec 08             	sub    $0x8,%esp
80104e5a:	53                   	push   %ebx
80104e5b:	ff 75 c0             	pushl  -0x40(%ebp)
80104e5e:	e8 7d d0 ff ff       	call   80101ee0 <nameiparent>
80104e63:	83 c4 10             	add    $0x10,%esp
80104e66:	85 c0                	test   %eax,%eax
80104e68:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104e6b:	0f 84 6a 01 00 00    	je     80104fdb <sys_unlink+0x1ab>
  ilock(dp);
80104e71:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104e74:	83 ec 0c             	sub    $0xc,%esp
80104e77:	56                   	push   %esi
80104e78:	e8 f3 c7 ff ff       	call   80101670 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104e7d:	58                   	pop    %eax
80104e7e:	5a                   	pop    %edx
80104e7f:	68 88 78 10 80       	push   $0x80107888
80104e84:	53                   	push   %ebx
80104e85:	e8 f6 cc ff ff       	call   80101b80 <namecmp>
80104e8a:	83 c4 10             	add    $0x10,%esp
80104e8d:	85 c0                	test   %eax,%eax
80104e8f:	0f 84 fc 00 00 00    	je     80104f91 <sys_unlink+0x161>
80104e95:	83 ec 08             	sub    $0x8,%esp
80104e98:	68 87 78 10 80       	push   $0x80107887
80104e9d:	53                   	push   %ebx
80104e9e:	e8 dd cc ff ff       	call   80101b80 <namecmp>
80104ea3:	83 c4 10             	add    $0x10,%esp
80104ea6:	85 c0                	test   %eax,%eax
80104ea8:	0f 84 e3 00 00 00    	je     80104f91 <sys_unlink+0x161>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104eae:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104eb1:	83 ec 04             	sub    $0x4,%esp
80104eb4:	50                   	push   %eax
80104eb5:	53                   	push   %ebx
80104eb6:	56                   	push   %esi
80104eb7:	e8 e4 cc ff ff       	call   80101ba0 <dirlookup>
80104ebc:	83 c4 10             	add    $0x10,%esp
80104ebf:	85 c0                	test   %eax,%eax
80104ec1:	89 c3                	mov    %eax,%ebx
80104ec3:	0f 84 c8 00 00 00    	je     80104f91 <sys_unlink+0x161>
  ilock(ip);
80104ec9:	83 ec 0c             	sub    $0xc,%esp
80104ecc:	50                   	push   %eax
80104ecd:	e8 9e c7 ff ff       	call   80101670 <ilock>
  if(ip->nlink < 1)
80104ed2:	83 c4 10             	add    $0x10,%esp
80104ed5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104eda:	0f 8e 24 01 00 00    	jle    80105004 <sys_unlink+0x1d4>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104ee0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104ee5:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104ee8:	74 66                	je     80104f50 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80104eea:	83 ec 04             	sub    $0x4,%esp
80104eed:	6a 10                	push   $0x10
80104eef:	6a 00                	push   $0x0
80104ef1:	56                   	push   %esi
80104ef2:	e8 a9 f5 ff ff       	call   801044a0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104ef7:	6a 10                	push   $0x10
80104ef9:	ff 75 c4             	pushl  -0x3c(%ebp)
80104efc:	56                   	push   %esi
80104efd:	ff 75 b4             	pushl  -0x4c(%ebp)
80104f00:	e8 4b cb ff ff       	call   80101a50 <writei>
80104f05:	83 c4 20             	add    $0x20,%esp
80104f08:	83 f8 10             	cmp    $0x10,%eax
80104f0b:	0f 85 e6 00 00 00    	jne    80104ff7 <sys_unlink+0x1c7>
  if(ip->type == T_DIR){
80104f11:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f16:	0f 84 9c 00 00 00    	je     80104fb8 <sys_unlink+0x188>
  iunlockput(dp);
80104f1c:	83 ec 0c             	sub    $0xc,%esp
80104f1f:	ff 75 b4             	pushl  -0x4c(%ebp)
80104f22:	e8 d9 c9 ff ff       	call   80101900 <iunlockput>
  ip->nlink--;
80104f27:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f2c:	89 1c 24             	mov    %ebx,(%esp)
80104f2f:	e8 8c c6 ff ff       	call   801015c0 <iupdate>
  iunlockput(ip);
80104f34:	89 1c 24             	mov    %ebx,(%esp)
80104f37:	e8 c4 c9 ff ff       	call   80101900 <iunlockput>
  end_op();
80104f3c:	e8 9f dc ff ff       	call   80102be0 <end_op>
  return 0;
80104f41:	83 c4 10             	add    $0x10,%esp
80104f44:	31 c0                	xor    %eax,%eax
}
80104f46:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f49:	5b                   	pop    %ebx
80104f4a:	5e                   	pop    %esi
80104f4b:	5f                   	pop    %edi
80104f4c:	5d                   	pop    %ebp
80104f4d:	c3                   	ret    
80104f4e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104f50:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104f54:	76 94                	jbe    80104eea <sys_unlink+0xba>
80104f56:	bf 20 00 00 00       	mov    $0x20,%edi
80104f5b:	eb 0f                	jmp    80104f6c <sys_unlink+0x13c>
80104f5d:	8d 76 00             	lea    0x0(%esi),%esi
80104f60:	83 c7 10             	add    $0x10,%edi
80104f63:	3b 7b 58             	cmp    0x58(%ebx),%edi
80104f66:	0f 83 7e ff ff ff    	jae    80104eea <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104f6c:	6a 10                	push   $0x10
80104f6e:	57                   	push   %edi
80104f6f:	56                   	push   %esi
80104f70:	53                   	push   %ebx
80104f71:	e8 da c9 ff ff       	call   80101950 <readi>
80104f76:	83 c4 10             	add    $0x10,%esp
80104f79:	83 f8 10             	cmp    $0x10,%eax
80104f7c:	75 6c                	jne    80104fea <sys_unlink+0x1ba>
    if(de.inum != 0)
80104f7e:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104f83:	74 db                	je     80104f60 <sys_unlink+0x130>
    iunlockput(ip);
80104f85:	83 ec 0c             	sub    $0xc,%esp
80104f88:	53                   	push   %ebx
80104f89:	e8 72 c9 ff ff       	call   80101900 <iunlockput>
    goto bad;
80104f8e:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80104f91:	83 ec 0c             	sub    $0xc,%esp
80104f94:	ff 75 b4             	pushl  -0x4c(%ebp)
80104f97:	e8 64 c9 ff ff       	call   80101900 <iunlockput>
  end_op();
80104f9c:	e8 3f dc ff ff       	call   80102be0 <end_op>
  return -1;
80104fa1:	83 c4 10             	add    $0x10,%esp
}
80104fa4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80104fa7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fac:	5b                   	pop    %ebx
80104fad:	5e                   	pop    %esi
80104fae:	5f                   	pop    %edi
80104faf:	5d                   	pop    %ebp
80104fb0:	c3                   	ret    
80104fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80104fb8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80104fbb:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80104fbe:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104fc3:	50                   	push   %eax
80104fc4:	e8 f7 c5 ff ff       	call   801015c0 <iupdate>
80104fc9:	83 c4 10             	add    $0x10,%esp
80104fcc:	e9 4b ff ff ff       	jmp    80104f1c <sys_unlink+0xec>
    return -1;
80104fd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fd6:	e9 6b ff ff ff       	jmp    80104f46 <sys_unlink+0x116>
    end_op();
80104fdb:	e8 00 dc ff ff       	call   80102be0 <end_op>
    return -1;
80104fe0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fe5:	e9 5c ff ff ff       	jmp    80104f46 <sys_unlink+0x116>
      panic("isdirempty: readi");
80104fea:	83 ec 0c             	sub    $0xc,%esp
80104fed:	68 ac 78 10 80       	push   $0x801078ac
80104ff2:	e8 79 b3 ff ff       	call   80100370 <panic>
    panic("unlink: writei");
80104ff7:	83 ec 0c             	sub    $0xc,%esp
80104ffa:	68 be 78 10 80       	push   $0x801078be
80104fff:	e8 6c b3 ff ff       	call   80100370 <panic>
    panic("unlink: nlink < 1");
80105004:	83 ec 0c             	sub    $0xc,%esp
80105007:	68 9a 78 10 80       	push   $0x8010789a
8010500c:	e8 5f b3 ff ff       	call   80100370 <panic>
80105011:	eb 0d                	jmp    80105020 <sys_open>
80105013:	90                   	nop
80105014:	90                   	nop
80105015:	90                   	nop
80105016:	90                   	nop
80105017:	90                   	nop
80105018:	90                   	nop
80105019:	90                   	nop
8010501a:	90                   	nop
8010501b:	90                   	nop
8010501c:	90                   	nop
8010501d:	90                   	nop
8010501e:	90                   	nop
8010501f:	90                   	nop

80105020 <sys_open>:

int
sys_open(void)
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	57                   	push   %edi
80105024:	56                   	push   %esi
80105025:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105026:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105029:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010502c:	50                   	push   %eax
8010502d:	6a 00                	push   $0x0
8010502f:	e8 0c f8 ff ff       	call   80104840 <argstr>
80105034:	83 c4 10             	add    $0x10,%esp
80105037:	85 c0                	test   %eax,%eax
80105039:	0f 88 9e 00 00 00    	js     801050dd <sys_open+0xbd>
8010503f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105042:	83 ec 08             	sub    $0x8,%esp
80105045:	50                   	push   %eax
80105046:	6a 01                	push   $0x1
80105048:	e8 43 f7 ff ff       	call   80104790 <argint>
8010504d:	83 c4 10             	add    $0x10,%esp
80105050:	85 c0                	test   %eax,%eax
80105052:	0f 88 85 00 00 00    	js     801050dd <sys_open+0xbd>
    return -1;

  begin_op();
80105058:	e8 13 db ff ff       	call   80102b70 <begin_op>

  if(omode & O_CREATE){
8010505d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105061:	0f 85 89 00 00 00    	jne    801050f0 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105067:	83 ec 0c             	sub    $0xc,%esp
8010506a:	ff 75 e0             	pushl  -0x20(%ebp)
8010506d:	e8 4e ce ff ff       	call   80101ec0 <namei>
80105072:	83 c4 10             	add    $0x10,%esp
80105075:	85 c0                	test   %eax,%eax
80105077:	89 c6                	mov    %eax,%esi
80105079:	0f 84 8e 00 00 00    	je     8010510d <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
8010507f:	83 ec 0c             	sub    $0xc,%esp
80105082:	50                   	push   %eax
80105083:	e8 e8 c5 ff ff       	call   80101670 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105088:	83 c4 10             	add    $0x10,%esp
8010508b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105090:	0f 84 d2 00 00 00    	je     80105168 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105096:	e8 c5 bc ff ff       	call   80100d60 <filealloc>
8010509b:	85 c0                	test   %eax,%eax
8010509d:	89 c7                	mov    %eax,%edi
8010509f:	74 2b                	je     801050cc <sys_open+0xac>
  for(fd = 0; fd < NOFILE; fd++){
801050a1:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801050a3:	e8 48 e7 ff ff       	call   801037f0 <myproc>
801050a8:	90                   	nop
801050a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801050b0:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
801050b4:	85 d2                	test   %edx,%edx
801050b6:	74 68                	je     80105120 <sys_open+0x100>
  for(fd = 0; fd < NOFILE; fd++){
801050b8:	83 c3 01             	add    $0x1,%ebx
801050bb:	83 fb 10             	cmp    $0x10,%ebx
801050be:	75 f0                	jne    801050b0 <sys_open+0x90>
    if(f)
      fileclose(f);
801050c0:	83 ec 0c             	sub    $0xc,%esp
801050c3:	57                   	push   %edi
801050c4:	e8 57 bd ff ff       	call   80100e20 <fileclose>
801050c9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801050cc:	83 ec 0c             	sub    $0xc,%esp
801050cf:	56                   	push   %esi
801050d0:	e8 2b c8 ff ff       	call   80101900 <iunlockput>
    end_op();
801050d5:	e8 06 db ff ff       	call   80102be0 <end_op>
    return -1;
801050da:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801050dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801050e0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801050e5:	89 d8                	mov    %ebx,%eax
801050e7:	5b                   	pop    %ebx
801050e8:	5e                   	pop    %esi
801050e9:	5f                   	pop    %edi
801050ea:	5d                   	pop    %ebp
801050eb:	c3                   	ret    
801050ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801050f0:	83 ec 0c             	sub    $0xc,%esp
801050f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801050f6:	31 c9                	xor    %ecx,%ecx
801050f8:	6a 00                	push   $0x0
801050fa:	ba 02 00 00 00       	mov    $0x2,%edx
801050ff:	e8 dc f7 ff ff       	call   801048e0 <create>
    if(ip == 0){
80105104:	83 c4 10             	add    $0x10,%esp
80105107:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105109:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010510b:	75 89                	jne    80105096 <sys_open+0x76>
      end_op();
8010510d:	e8 ce da ff ff       	call   80102be0 <end_op>
      return -1;
80105112:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105117:	eb 40                	jmp    80105159 <sys_open+0x139>
80105119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80105120:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105123:	89 7c 98 2c          	mov    %edi,0x2c(%eax,%ebx,4)
  iunlock(ip);
80105127:	56                   	push   %esi
80105128:	e8 23 c6 ff ff       	call   80101750 <iunlock>
  end_op();
8010512d:	e8 ae da ff ff       	call   80102be0 <end_op>
  f->type = FD_INODE;
80105132:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->readable = !(omode & O_WRONLY);
80105138:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010513b:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
8010513e:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105141:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105148:	89 c2                	mov    %eax,%edx
8010514a:	f7 d2                	not    %edx
8010514c:	88 57 08             	mov    %dl,0x8(%edi)
8010514f:	80 67 08 01          	andb   $0x1,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105153:	a8 03                	test   $0x3,%al
80105155:	0f 95 47 09          	setne  0x9(%edi)
}
80105159:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010515c:	89 d8                	mov    %ebx,%eax
8010515e:	5b                   	pop    %ebx
8010515f:	5e                   	pop    %esi
80105160:	5f                   	pop    %edi
80105161:	5d                   	pop    %ebp
80105162:	c3                   	ret    
80105163:	90                   	nop
80105164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105168:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010516b:	85 c9                	test   %ecx,%ecx
8010516d:	0f 84 23 ff ff ff    	je     80105096 <sys_open+0x76>
80105173:	e9 54 ff ff ff       	jmp    801050cc <sys_open+0xac>
80105178:	90                   	nop
80105179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105180 <sys_mkdir>:

int
sys_mkdir(void)
{
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
80105183:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105186:	e8 e5 d9 ff ff       	call   80102b70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010518b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010518e:	83 ec 08             	sub    $0x8,%esp
80105191:	50                   	push   %eax
80105192:	6a 00                	push   $0x0
80105194:	e8 a7 f6 ff ff       	call   80104840 <argstr>
80105199:	83 c4 10             	add    $0x10,%esp
8010519c:	85 c0                	test   %eax,%eax
8010519e:	78 30                	js     801051d0 <sys_mkdir+0x50>
801051a0:	83 ec 0c             	sub    $0xc,%esp
801051a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051a6:	31 c9                	xor    %ecx,%ecx
801051a8:	6a 00                	push   $0x0
801051aa:	ba 01 00 00 00       	mov    $0x1,%edx
801051af:	e8 2c f7 ff ff       	call   801048e0 <create>
801051b4:	83 c4 10             	add    $0x10,%esp
801051b7:	85 c0                	test   %eax,%eax
801051b9:	74 15                	je     801051d0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801051bb:	83 ec 0c             	sub    $0xc,%esp
801051be:	50                   	push   %eax
801051bf:	e8 3c c7 ff ff       	call   80101900 <iunlockput>
  end_op();
801051c4:	e8 17 da ff ff       	call   80102be0 <end_op>
  return 0;
801051c9:	83 c4 10             	add    $0x10,%esp
801051cc:	31 c0                	xor    %eax,%eax
}
801051ce:	c9                   	leave  
801051cf:	c3                   	ret    
    end_op();
801051d0:	e8 0b da ff ff       	call   80102be0 <end_op>
    return -1;
801051d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051da:	c9                   	leave  
801051db:	c3                   	ret    
801051dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801051e0 <sys_mknod>:

int
sys_mknod(void)
{
801051e0:	55                   	push   %ebp
801051e1:	89 e5                	mov    %esp,%ebp
801051e3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801051e6:	e8 85 d9 ff ff       	call   80102b70 <begin_op>
  if((argstr(0, &path)) < 0 ||
801051eb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801051ee:	83 ec 08             	sub    $0x8,%esp
801051f1:	50                   	push   %eax
801051f2:	6a 00                	push   $0x0
801051f4:	e8 47 f6 ff ff       	call   80104840 <argstr>
801051f9:	83 c4 10             	add    $0x10,%esp
801051fc:	85 c0                	test   %eax,%eax
801051fe:	78 60                	js     80105260 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105200:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105203:	83 ec 08             	sub    $0x8,%esp
80105206:	50                   	push   %eax
80105207:	6a 01                	push   $0x1
80105209:	e8 82 f5 ff ff       	call   80104790 <argint>
  if((argstr(0, &path)) < 0 ||
8010520e:	83 c4 10             	add    $0x10,%esp
80105211:	85 c0                	test   %eax,%eax
80105213:	78 4b                	js     80105260 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105215:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105218:	83 ec 08             	sub    $0x8,%esp
8010521b:	50                   	push   %eax
8010521c:	6a 02                	push   $0x2
8010521e:	e8 6d f5 ff ff       	call   80104790 <argint>
     argint(1, &major) < 0 ||
80105223:	83 c4 10             	add    $0x10,%esp
80105226:	85 c0                	test   %eax,%eax
80105228:	78 36                	js     80105260 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010522a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010522e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105231:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105235:	ba 03 00 00 00       	mov    $0x3,%edx
8010523a:	50                   	push   %eax
8010523b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010523e:	e8 9d f6 ff ff       	call   801048e0 <create>
80105243:	83 c4 10             	add    $0x10,%esp
80105246:	85 c0                	test   %eax,%eax
80105248:	74 16                	je     80105260 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010524a:	83 ec 0c             	sub    $0xc,%esp
8010524d:	50                   	push   %eax
8010524e:	e8 ad c6 ff ff       	call   80101900 <iunlockput>
  end_op();
80105253:	e8 88 d9 ff ff       	call   80102be0 <end_op>
  return 0;
80105258:	83 c4 10             	add    $0x10,%esp
8010525b:	31 c0                	xor    %eax,%eax
}
8010525d:	c9                   	leave  
8010525e:	c3                   	ret    
8010525f:	90                   	nop
    end_op();
80105260:	e8 7b d9 ff ff       	call   80102be0 <end_op>
    return -1;
80105265:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010526a:	c9                   	leave  
8010526b:	c3                   	ret    
8010526c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105270 <sys_chdir>:

int
sys_chdir(void)
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	56                   	push   %esi
80105274:	53                   	push   %ebx
80105275:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105278:	e8 73 e5 ff ff       	call   801037f0 <myproc>
8010527d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010527f:	e8 ec d8 ff ff       	call   80102b70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105284:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105287:	83 ec 08             	sub    $0x8,%esp
8010528a:	50                   	push   %eax
8010528b:	6a 00                	push   $0x0
8010528d:	e8 ae f5 ff ff       	call   80104840 <argstr>
80105292:	83 c4 10             	add    $0x10,%esp
80105295:	85 c0                	test   %eax,%eax
80105297:	78 77                	js     80105310 <sys_chdir+0xa0>
80105299:	83 ec 0c             	sub    $0xc,%esp
8010529c:	ff 75 f4             	pushl  -0xc(%ebp)
8010529f:	e8 1c cc ff ff       	call   80101ec0 <namei>
801052a4:	83 c4 10             	add    $0x10,%esp
801052a7:	85 c0                	test   %eax,%eax
801052a9:	89 c3                	mov    %eax,%ebx
801052ab:	74 63                	je     80105310 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801052ad:	83 ec 0c             	sub    $0xc,%esp
801052b0:	50                   	push   %eax
801052b1:	e8 ba c3 ff ff       	call   80101670 <ilock>
  if(ip->type != T_DIR){
801052b6:	83 c4 10             	add    $0x10,%esp
801052b9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052be:	75 30                	jne    801052f0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801052c0:	83 ec 0c             	sub    $0xc,%esp
801052c3:	53                   	push   %ebx
801052c4:	e8 87 c4 ff ff       	call   80101750 <iunlock>
  iput(curproc->cwd);
801052c9:	58                   	pop    %eax
801052ca:	ff 76 6c             	pushl  0x6c(%esi)
801052cd:	e8 ce c4 ff ff       	call   801017a0 <iput>
  end_op();
801052d2:	e8 09 d9 ff ff       	call   80102be0 <end_op>
  curproc->cwd = ip;
801052d7:	89 5e 6c             	mov    %ebx,0x6c(%esi)
  return 0;
801052da:	83 c4 10             	add    $0x10,%esp
801052dd:	31 c0                	xor    %eax,%eax
}
801052df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052e2:	5b                   	pop    %ebx
801052e3:	5e                   	pop    %esi
801052e4:	5d                   	pop    %ebp
801052e5:	c3                   	ret    
801052e6:	8d 76 00             	lea    0x0(%esi),%esi
801052e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
801052f0:	83 ec 0c             	sub    $0xc,%esp
801052f3:	53                   	push   %ebx
801052f4:	e8 07 c6 ff ff       	call   80101900 <iunlockput>
    end_op();
801052f9:	e8 e2 d8 ff ff       	call   80102be0 <end_op>
    return -1;
801052fe:	83 c4 10             	add    $0x10,%esp
80105301:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105306:	eb d7                	jmp    801052df <sys_chdir+0x6f>
80105308:	90                   	nop
80105309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105310:	e8 cb d8 ff ff       	call   80102be0 <end_op>
    return -1;
80105315:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010531a:	eb c3                	jmp    801052df <sys_chdir+0x6f>
8010531c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105320 <sys_exec>:

int
sys_exec(void)
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	57                   	push   %edi
80105324:	56                   	push   %esi
80105325:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105326:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010532c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105332:	50                   	push   %eax
80105333:	6a 00                	push   $0x0
80105335:	e8 06 f5 ff ff       	call   80104840 <argstr>
8010533a:	83 c4 10             	add    $0x10,%esp
8010533d:	85 c0                	test   %eax,%eax
8010533f:	78 7f                	js     801053c0 <sys_exec+0xa0>
80105341:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105347:	83 ec 08             	sub    $0x8,%esp
8010534a:	50                   	push   %eax
8010534b:	6a 01                	push   $0x1
8010534d:	e8 3e f4 ff ff       	call   80104790 <argint>
80105352:	83 c4 10             	add    $0x10,%esp
80105355:	85 c0                	test   %eax,%eax
80105357:	78 67                	js     801053c0 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105359:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010535f:	83 ec 04             	sub    $0x4,%esp
80105362:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105368:	68 80 00 00 00       	push   $0x80
8010536d:	6a 00                	push   $0x0
8010536f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105375:	50                   	push   %eax
80105376:	31 db                	xor    %ebx,%ebx
80105378:	e8 23 f1 ff ff       	call   801044a0 <memset>
8010537d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105380:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105386:	83 ec 08             	sub    $0x8,%esp
80105389:	57                   	push   %edi
8010538a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010538d:	50                   	push   %eax
8010538e:	e8 5d f3 ff ff       	call   801046f0 <fetchint>
80105393:	83 c4 10             	add    $0x10,%esp
80105396:	85 c0                	test   %eax,%eax
80105398:	78 26                	js     801053c0 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
8010539a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801053a0:	85 c0                	test   %eax,%eax
801053a2:	74 2c                	je     801053d0 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801053a4:	83 ec 08             	sub    $0x8,%esp
801053a7:	56                   	push   %esi
801053a8:	50                   	push   %eax
801053a9:	e8 82 f3 ff ff       	call   80104730 <fetchstr>
801053ae:	83 c4 10             	add    $0x10,%esp
801053b1:	85 c0                	test   %eax,%eax
801053b3:	78 0b                	js     801053c0 <sys_exec+0xa0>
  for(i=0;; i++){
801053b5:	83 c3 01             	add    $0x1,%ebx
801053b8:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801053bb:	83 fb 20             	cmp    $0x20,%ebx
801053be:	75 c0                	jne    80105380 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801053c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801053c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053c8:	5b                   	pop    %ebx
801053c9:	5e                   	pop    %esi
801053ca:	5f                   	pop    %edi
801053cb:	5d                   	pop    %ebp
801053cc:	c3                   	ret    
801053cd:	8d 76 00             	lea    0x0(%esi),%esi
  return exec(path, argv);
801053d0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801053d6:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
801053d9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801053e0:	00 00 00 00 
  return exec(path, argv);
801053e4:	50                   	push   %eax
801053e5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801053eb:	e8 f0 b5 ff ff       	call   801009e0 <exec>
801053f0:	83 c4 10             	add    $0x10,%esp
}
801053f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053f6:	5b                   	pop    %ebx
801053f7:	5e                   	pop    %esi
801053f8:	5f                   	pop    %edi
801053f9:	5d                   	pop    %ebp
801053fa:	c3                   	ret    
801053fb:	90                   	nop
801053fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105400 <sys_pipe>:

int
sys_pipe(void)
{
80105400:	55                   	push   %ebp
80105401:	89 e5                	mov    %esp,%ebp
80105403:	57                   	push   %edi
80105404:	56                   	push   %esi
80105405:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105406:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105409:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010540c:	6a 08                	push   $0x8
8010540e:	50                   	push   %eax
8010540f:	6a 00                	push   $0x0
80105411:	e8 ca f3 ff ff       	call   801047e0 <argptr>
80105416:	83 c4 10             	add    $0x10,%esp
80105419:	85 c0                	test   %eax,%eax
8010541b:	78 4a                	js     80105467 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010541d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105420:	83 ec 08             	sub    $0x8,%esp
80105423:	50                   	push   %eax
80105424:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105427:	50                   	push   %eax
80105428:	e8 d3 dd ff ff       	call   80103200 <pipealloc>
8010542d:	83 c4 10             	add    $0x10,%esp
80105430:	85 c0                	test   %eax,%eax
80105432:	78 33                	js     80105467 <sys_pipe+0x67>
  for(fd = 0; fd < NOFILE; fd++){
80105434:	31 db                	xor    %ebx,%ebx
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105436:	8b 7d e0             	mov    -0x20(%ebp),%edi
  struct proc *curproc = myproc();
80105439:	e8 b2 e3 ff ff       	call   801037f0 <myproc>
8010543e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105440:	8b 74 98 2c          	mov    0x2c(%eax,%ebx,4),%esi
80105444:	85 f6                	test   %esi,%esi
80105446:	74 30                	je     80105478 <sys_pipe+0x78>
  for(fd = 0; fd < NOFILE; fd++){
80105448:	83 c3 01             	add    $0x1,%ebx
8010544b:	83 fb 10             	cmp    $0x10,%ebx
8010544e:	75 f0                	jne    80105440 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105450:	83 ec 0c             	sub    $0xc,%esp
80105453:	ff 75 e0             	pushl  -0x20(%ebp)
80105456:	e8 c5 b9 ff ff       	call   80100e20 <fileclose>
    fileclose(wf);
8010545b:	58                   	pop    %eax
8010545c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010545f:	e8 bc b9 ff ff       	call   80100e20 <fileclose>
    return -1;
80105464:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105467:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010546a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010546f:	5b                   	pop    %ebx
80105470:	5e                   	pop    %esi
80105471:	5f                   	pop    %edi
80105472:	5d                   	pop    %ebp
80105473:	c3                   	ret    
80105474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80105478:	8d 73 08             	lea    0x8(%ebx),%esi
8010547b:	89 7c b0 0c          	mov    %edi,0xc(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010547f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105482:	e8 69 e3 ff ff       	call   801037f0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105487:	31 d2                	xor    %edx,%edx
80105489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105490:	8b 4c 90 2c          	mov    0x2c(%eax,%edx,4),%ecx
80105494:	85 c9                	test   %ecx,%ecx
80105496:	74 18                	je     801054b0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105498:	83 c2 01             	add    $0x1,%edx
8010549b:	83 fa 10             	cmp    $0x10,%edx
8010549e:	75 f0                	jne    80105490 <sys_pipe+0x90>
      myproc()->ofile[fd0] = 0;
801054a0:	e8 4b e3 ff ff       	call   801037f0 <myproc>
801054a5:	c7 44 b0 0c 00 00 00 	movl   $0x0,0xc(%eax,%esi,4)
801054ac:	00 
801054ad:	eb a1                	jmp    80105450 <sys_pipe+0x50>
801054af:	90                   	nop
      curproc->ofile[fd] = f;
801054b0:	89 7c 90 2c          	mov    %edi,0x2c(%eax,%edx,4)
  fd[0] = fd0;
801054b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801054b7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801054b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801054bc:	89 50 04             	mov    %edx,0x4(%eax)
}
801054bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801054c2:	31 c0                	xor    %eax,%eax
}
801054c4:	5b                   	pop    %ebx
801054c5:	5e                   	pop    %esi
801054c6:	5f                   	pop    %edi
801054c7:	5d                   	pop    %ebp
801054c8:	c3                   	ret    
801054c9:	66 90                	xchg   %ax,%ax
801054cb:	66 90                	xchg   %ax,%ax
801054cd:	66 90                	xchg   %ax,%ax
801054cf:	90                   	nop

801054d0 <sys_create_container>:
#include "mmu.h"
#include "proc.h"
#include "container_scheduler.h"

//Sys_calls which I will implement
int sys_create_container(void){
801054d0:	55                   	push   %ebp
801054d1:	89 e5                	mov    %esp,%ebp
801054d3:	83 ec 20             	sub    $0x20,%esp
  int id;
  argint(0, &id);
801054d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054d9:	50                   	push   %eax
801054da:	6a 00                	push   $0x0
801054dc:	e8 af f2 ff ff       	call   80104790 <argint>
  if(containers[id] == 1){
801054e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054e4:	83 c4 10             	add    $0x10,%esp
801054e7:	83 3c 85 c0 a5 10 80 	cmpl   $0x1,-0x7fef5a40(,%eax,4)
801054ee:	01 
801054ef:	74 1f                	je     80105510 <sys_create_container+0x40>
    cprintf("This is id is already created\n");
  }
  else{
    containers[id] = 1;
    cprintf("Container created successfully\n");
801054f1:	83 ec 0c             	sub    $0xc,%esp
    containers[id] = 1;
801054f4:	c7 04 85 c0 a5 10 80 	movl   $0x1,-0x7fef5a40(,%eax,4)
801054fb:	01 00 00 00 
    cprintf("Container created successfully\n");
801054ff:	68 f0 78 10 80       	push   $0x801078f0
80105504:	e8 57 b1 ff ff       	call   80100660 <cprintf>
80105509:	83 c4 10             	add    $0x10,%esp
  }
  return 0;
}
8010550c:	31 c0                	xor    %eax,%eax
8010550e:	c9                   	leave  
8010550f:	c3                   	ret    
    cprintf("This is id is already created\n");
80105510:	83 ec 0c             	sub    $0xc,%esp
80105513:	68 d0 78 10 80       	push   $0x801078d0
80105518:	e8 43 b1 ff ff       	call   80100660 <cprintf>
8010551d:	83 c4 10             	add    $0x10,%esp
}
80105520:	31 c0                	xor    %eax,%eax
80105522:	c9                   	leave  
80105523:	c3                   	ret    
80105524:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010552a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105530 <sys_destroy_container>:

int sys_destroy_container(void){
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	83 ec 20             	sub    $0x20,%esp
  int id;
  argint(0, &id);
80105536:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105539:	50                   	push   %eax
8010553a:	6a 00                	push   $0x0
8010553c:	e8 4f f2 ff ff       	call   80104790 <argint>
  if(containers[id] == 0){
80105541:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105544:	83 c4 10             	add    $0x10,%esp
80105547:	8b 14 85 c0 a5 10 80 	mov    -0x7fef5a40(,%eax,4),%edx
8010554e:	85 d2                	test   %edx,%edx
80105550:	74 16                	je     80105568 <sys_destroy_container+0x38>
    cprintf("This is id is already non-existant\n");
  }
  else{
    containers[id] = 0;
80105552:	c7 04 85 c0 a5 10 80 	movl   $0x0,-0x7fef5a40(,%eax,4)
80105559:	00 00 00 00 
  }
  return 0;
}
8010555d:	31 c0                	xor    %eax,%eax
8010555f:	c9                   	leave  
80105560:	c3                   	ret    
80105561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("This is id is already non-existant\n");
80105568:	83 ec 0c             	sub    $0xc,%esp
8010556b:	68 10 79 10 80       	push   $0x80107910
80105570:	e8 eb b0 ff ff       	call   80100660 <cprintf>
80105575:	83 c4 10             	add    $0x10,%esp
}
80105578:	31 c0                	xor    %eax,%eax
8010557a:	c9                   	leave  
8010557b:	c3                   	ret    
8010557c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105580 <sys_join_container>:

int sys_join_container(void){
80105580:	55                   	push   %ebp
80105581:	89 e5                	mov    %esp,%ebp
80105583:	53                   	push   %ebx
  int id;
  argint(0, &id);
80105584:	8d 45 f4             	lea    -0xc(%ebp),%eax
int sys_join_container(void){
80105587:	83 ec 1c             	sub    $0x1c,%esp
  argint(0, &id);
8010558a:	50                   	push   %eax
8010558b:	6a 00                	push   $0x0
8010558d:	e8 fe f1 ff ff       	call   80104790 <argint>
  //Join this process in container ID
  if(containers[id] == 0){
80105592:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105595:	83 c4 10             	add    $0x10,%esp
80105598:	8b 04 85 c0 a5 10 80 	mov    -0x7fef5a40(,%eax,4),%eax
8010559f:	85 c0                	test   %eax,%eax
801055a1:	74 2d                	je     801055d0 <sys_join_container+0x50>
    cprintf("This container doesn't exists");
    return 0;
  }
  myproc()->containerID = id;
801055a3:	e8 48 e2 ff ff       	call   801037f0 <myproc>
801055a8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801055ab:	89 58 18             	mov    %ebx,0x18(%eax)
  //Add this process in this container
  addProcessToContainer(myproc()->pid, id);
801055ae:	e8 3d e2 ff ff       	call   801037f0 <myproc>
801055b3:	83 ec 08             	sub    $0x8,%esp
801055b6:	53                   	push   %ebx
801055b7:	ff 70 10             	pushl  0x10(%eax)
801055ba:	e8 d1 1a 00 00       	call   80107090 <addProcessToContainer>
  return 0;
801055bf:	83 c4 10             	add    $0x10,%esp
}
801055c2:	31 c0                	xor    %eax,%eax
801055c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055c7:	c9                   	leave  
801055c8:	c3                   	ret    
801055c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("This container doesn't exists");
801055d0:	83 ec 0c             	sub    $0xc,%esp
801055d3:	68 34 79 10 80       	push   $0x80107934
801055d8:	e8 83 b0 ff ff       	call   80100660 <cprintf>
    return 0;
801055dd:	83 c4 10             	add    $0x10,%esp
}
801055e0:	31 c0                	xor    %eax,%eax
801055e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055e5:	c9                   	leave  
801055e6:	c3                   	ret    
801055e7:	89 f6                	mov    %esi,%esi
801055e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055f0 <sys_leave_container>:

int sys_leave_container(void){
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	53                   	push   %ebx
801055f4:	83 ec 04             	sub    $0x4,%esp
  int pid = myproc()->pid;
801055f7:	e8 f4 e1 ff ff       	call   801037f0 <myproc>
801055fc:	8b 58 10             	mov    0x10(%eax),%ebx
  int containerID = myproc()->containerID;
801055ff:	e8 ec e1 ff ff       	call   801037f0 <myproc>
  removeProcessFromContainer(pid, containerID);
80105604:	83 ec 08             	sub    $0x8,%esp
80105607:	ff 70 18             	pushl  0x18(%eax)
8010560a:	53                   	push   %ebx
8010560b:	e8 c0 1a 00 00       	call   801070d0 <removeProcessFromContainer>
  return 0;
}
80105610:	31 c0                	xor    %eax,%eax
80105612:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105615:	c9                   	leave  
80105616:	c3                   	ret    
80105617:	89 f6                	mov    %esi,%esi
80105619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105620 <sys_ps>:

int sys_ps(void){
80105620:	55                   	push   %ebp
80105621:	89 e5                	mov    %esp,%ebp
80105623:	53                   	push   %ebx
80105624:	83 ec 04             	sub    $0x4,%esp
  int procID = myproc()->pid;
80105627:	e8 c4 e1 ff ff       	call   801037f0 <myproc>
8010562c:	8b 58 10             	mov    0x10(%eax),%ebx
  int containerID = myproc()->containerID;
8010562f:	e8 bc e1 ff ff       	call   801037f0 <myproc>
  psHelper(procID, containerID);
80105634:	83 ec 08             	sub    $0x8,%esp
80105637:	ff 70 18             	pushl  0x18(%eax)
8010563a:	53                   	push   %ebx
8010563b:	e8 90 e0 ff ff       	call   801036d0 <psHelper>
  return 0;
}
80105640:	31 c0                	xor    %eax,%eax
80105642:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105645:	c9                   	leave  
80105646:	c3                   	ret    
80105647:	89 f6                	mov    %esi,%esi
80105649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105650 <sys_fork>:

// SYS_calls which were implemented from before
int
sys_fork(void)
{
80105650:	55                   	push   %ebp
80105651:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105653:	5d                   	pop    %ebp
  return fork();
80105654:	e9 37 e3 ff ff       	jmp    80103990 <fork>
80105659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105660 <sys_exit>:

int
sys_exit(void)
{
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
80105663:	83 ec 08             	sub    $0x8,%esp
  exit();
80105666:	e8 b5 e5 ff ff       	call   80103c20 <exit>
  return 0;  // not reached
}
8010566b:	31 c0                	xor    %eax,%eax
8010566d:	c9                   	leave  
8010566e:	c3                   	ret    
8010566f:	90                   	nop

80105670 <sys_wait>:

int
sys_wait(void)
{
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105673:	5d                   	pop    %ebp
  return wait();
80105674:	e9 e7 e7 ff ff       	jmp    80103e60 <wait>
80105679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105680 <sys_kill>:

int
sys_kill(void)
{
80105680:	55                   	push   %ebp
80105681:	89 e5                	mov    %esp,%ebp
80105683:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105686:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105689:	50                   	push   %eax
8010568a:	6a 00                	push   $0x0
8010568c:	e8 ff f0 ff ff       	call   80104790 <argint>
80105691:	83 c4 10             	add    $0x10,%esp
80105694:	85 c0                	test   %eax,%eax
80105696:	78 18                	js     801056b0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105698:	83 ec 0c             	sub    $0xc,%esp
8010569b:	ff 75 f4             	pushl  -0xc(%ebp)
8010569e:	e8 1d e9 ff ff       	call   80103fc0 <kill>
801056a3:	83 c4 10             	add    $0x10,%esp
}
801056a6:	c9                   	leave  
801056a7:	c3                   	ret    
801056a8:	90                   	nop
801056a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801056b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056b5:	c9                   	leave  
801056b6:	c3                   	ret    
801056b7:	89 f6                	mov    %esi,%esi
801056b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056c0 <sys_getpid>:

int
sys_getpid(void)
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
801056c3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801056c6:	e8 25 e1 ff ff       	call   801037f0 <myproc>
801056cb:	8b 40 10             	mov    0x10(%eax),%eax
}
801056ce:	c9                   	leave  
801056cf:	c3                   	ret    

801056d0 <sys_sbrk>:

int
sys_sbrk(void)
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801056d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801056d7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801056da:	50                   	push   %eax
801056db:	6a 00                	push   $0x0
801056dd:	e8 ae f0 ff ff       	call   80104790 <argint>
801056e2:	83 c4 10             	add    $0x10,%esp
801056e5:	85 c0                	test   %eax,%eax
801056e7:	78 27                	js     80105710 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801056e9:	e8 02 e1 ff ff       	call   801037f0 <myproc>
  if(growproc(n) < 0)
801056ee:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801056f1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801056f3:	ff 75 f4             	pushl  -0xc(%ebp)
801056f6:	e8 15 e2 ff ff       	call   80103910 <growproc>
801056fb:	83 c4 10             	add    $0x10,%esp
801056fe:	85 c0                	test   %eax,%eax
80105700:	78 0e                	js     80105710 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105702:	89 d8                	mov    %ebx,%eax
80105704:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105707:	c9                   	leave  
80105708:	c3                   	ret    
80105709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105710:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105715:	eb eb                	jmp    80105702 <sys_sbrk+0x32>
80105717:	89 f6                	mov    %esi,%esi
80105719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105720 <sys_sleep>:

int
sys_sleep(void)
{
80105720:	55                   	push   %ebp
80105721:	89 e5                	mov    %esp,%ebp
80105723:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105724:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105727:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010572a:	50                   	push   %eax
8010572b:	6a 00                	push   $0x0
8010572d:	e8 5e f0 ff ff       	call   80104790 <argint>
80105732:	83 c4 10             	add    $0x10,%esp
80105735:	85 c0                	test   %eax,%eax
80105737:	0f 88 8a 00 00 00    	js     801057c7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010573d:	83 ec 0c             	sub    $0xc,%esp
80105740:	68 a0 62 11 80       	push   $0x801162a0
80105745:	e8 56 ec ff ff       	call   801043a0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010574a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010574d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105750:	8b 1d e0 6a 11 80    	mov    0x80116ae0,%ebx
  while(ticks - ticks0 < n){
80105756:	85 d2                	test   %edx,%edx
80105758:	75 27                	jne    80105781 <sys_sleep+0x61>
8010575a:	eb 54                	jmp    801057b0 <sys_sleep+0x90>
8010575c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105760:	83 ec 08             	sub    $0x8,%esp
80105763:	68 a0 62 11 80       	push   $0x801162a0
80105768:	68 e0 6a 11 80       	push   $0x80116ae0
8010576d:	e8 2e e6 ff ff       	call   80103da0 <sleep>
  while(ticks - ticks0 < n){
80105772:	a1 e0 6a 11 80       	mov    0x80116ae0,%eax
80105777:	83 c4 10             	add    $0x10,%esp
8010577a:	29 d8                	sub    %ebx,%eax
8010577c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010577f:	73 2f                	jae    801057b0 <sys_sleep+0x90>
    if(myproc()->killed){
80105781:	e8 6a e0 ff ff       	call   801037f0 <myproc>
80105786:	8b 40 28             	mov    0x28(%eax),%eax
80105789:	85 c0                	test   %eax,%eax
8010578b:	74 d3                	je     80105760 <sys_sleep+0x40>
      release(&tickslock);
8010578d:	83 ec 0c             	sub    $0xc,%esp
80105790:	68 a0 62 11 80       	push   $0x801162a0
80105795:	e8 b6 ec ff ff       	call   80104450 <release>
      return -1;
8010579a:	83 c4 10             	add    $0x10,%esp
8010579d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
801057a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057a5:	c9                   	leave  
801057a6:	c3                   	ret    
801057a7:	89 f6                	mov    %esi,%esi
801057a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
801057b0:	83 ec 0c             	sub    $0xc,%esp
801057b3:	68 a0 62 11 80       	push   $0x801162a0
801057b8:	e8 93 ec ff ff       	call   80104450 <release>
  return 0;
801057bd:	83 c4 10             	add    $0x10,%esp
801057c0:	31 c0                	xor    %eax,%eax
}
801057c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057c5:	c9                   	leave  
801057c6:	c3                   	ret    
    return -1;
801057c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057cc:	eb d4                	jmp    801057a2 <sys_sleep+0x82>
801057ce:	66 90                	xchg   %ax,%ax

801057d0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801057d0:	55                   	push   %ebp
801057d1:	89 e5                	mov    %esp,%ebp
801057d3:	53                   	push   %ebx
801057d4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801057d7:	68 a0 62 11 80       	push   $0x801162a0
801057dc:	e8 bf eb ff ff       	call   801043a0 <acquire>
  xticks = ticks;
801057e1:	8b 1d e0 6a 11 80    	mov    0x80116ae0,%ebx
  release(&tickslock);
801057e7:	c7 04 24 a0 62 11 80 	movl   $0x801162a0,(%esp)
801057ee:	e8 5d ec ff ff       	call   80104450 <release>
  return xticks;
}
801057f3:	89 d8                	mov    %ebx,%eax
801057f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057f8:	c9                   	leave  
801057f9:	c3                   	ret    

801057fa <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801057fa:	1e                   	push   %ds
  pushl %es
801057fb:	06                   	push   %es
  pushl %fs
801057fc:	0f a0                	push   %fs
  pushl %gs
801057fe:	0f a8                	push   %gs
  pushal
80105800:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105801:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105805:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105807:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105809:	54                   	push   %esp
  call trap
8010580a:	e8 e1 00 00 00       	call   801058f0 <trap>
  addl $4, %esp
8010580f:	83 c4 04             	add    $0x4,%esp

80105812 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105812:	61                   	popa   
  popl %gs
80105813:	0f a9                	pop    %gs
  popl %fs
80105815:	0f a1                	pop    %fs
  popl %es
80105817:	07                   	pop    %es
  popl %ds
80105818:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105819:	83 c4 08             	add    $0x8,%esp
  iret
8010581c:	cf                   	iret   
8010581d:	66 90                	xchg   %ax,%ax
8010581f:	90                   	nop

80105820 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105820:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105821:	31 c0                	xor    %eax,%eax
{
80105823:	89 e5                	mov    %esp,%ebp
80105825:	83 ec 08             	sub    $0x8,%esp
80105828:	90                   	nop
80105829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105830:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105837:	b9 08 00 00 00       	mov    $0x8,%ecx
8010583c:	c6 04 c5 e4 62 11 80 	movb   $0x0,-0x7fee9d1c(,%eax,8)
80105843:	00 
80105844:	66 89 0c c5 e2 62 11 	mov    %cx,-0x7fee9d1e(,%eax,8)
8010584b:	80 
8010584c:	c6 04 c5 e5 62 11 80 	movb   $0x8e,-0x7fee9d1b(,%eax,8)
80105853:	8e 
80105854:	66 89 14 c5 e0 62 11 	mov    %dx,-0x7fee9d20(,%eax,8)
8010585b:	80 
8010585c:	c1 ea 10             	shr    $0x10,%edx
8010585f:	66 89 14 c5 e6 62 11 	mov    %dx,-0x7fee9d1a(,%eax,8)
80105866:	80 
  for(i = 0; i < 256; i++)
80105867:	83 c0 01             	add    $0x1,%eax
8010586a:	3d 00 01 00 00       	cmp    $0x100,%eax
8010586f:	75 bf                	jne    80105830 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105871:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105876:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105879:	ba 08 00 00 00       	mov    $0x8,%edx
  initlock(&tickslock, "time");
8010587e:	68 52 79 10 80       	push   $0x80107952
80105883:	68 a0 62 11 80       	push   $0x801162a0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105888:	66 89 15 e2 64 11 80 	mov    %dx,0x801164e2
8010588f:	c6 05 e4 64 11 80 00 	movb   $0x0,0x801164e4
80105896:	66 a3 e0 64 11 80    	mov    %ax,0x801164e0
8010589c:	c1 e8 10             	shr    $0x10,%eax
8010589f:	c6 05 e5 64 11 80 ef 	movb   $0xef,0x801164e5
801058a6:	66 a3 e6 64 11 80    	mov    %ax,0x801164e6
  initlock(&tickslock, "time");
801058ac:	e8 8f e9 ff ff       	call   80104240 <initlock>
}
801058b1:	83 c4 10             	add    $0x10,%esp
801058b4:	c9                   	leave  
801058b5:	c3                   	ret    
801058b6:	8d 76 00             	lea    0x0(%esi),%esi
801058b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058c0 <idtinit>:

void
idtinit(void)
{
801058c0:	55                   	push   %ebp
  pd[0] = size-1;
801058c1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801058c6:	89 e5                	mov    %esp,%ebp
801058c8:	83 ec 10             	sub    $0x10,%esp
801058cb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801058cf:	b8 e0 62 11 80       	mov    $0x801162e0,%eax
801058d4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801058d8:	c1 e8 10             	shr    $0x10,%eax
801058db:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801058df:	8d 45 fa             	lea    -0x6(%ebp),%eax
801058e2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801058e5:	c9                   	leave  
801058e6:	c3                   	ret    
801058e7:	89 f6                	mov    %esi,%esi
801058e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058f0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801058f0:	55                   	push   %ebp
801058f1:	89 e5                	mov    %esp,%ebp
801058f3:	57                   	push   %edi
801058f4:	56                   	push   %esi
801058f5:	53                   	push   %ebx
801058f6:	83 ec 1c             	sub    $0x1c,%esp
801058f9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
801058fc:	8b 47 30             	mov    0x30(%edi),%eax
801058ff:	83 f8 40             	cmp    $0x40,%eax
80105902:	0f 84 88 01 00 00    	je     80105a90 <trap+0x1a0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105908:	83 e8 20             	sub    $0x20,%eax
8010590b:	83 f8 1f             	cmp    $0x1f,%eax
8010590e:	77 10                	ja     80105920 <trap+0x30>
80105910:	ff 24 85 f8 79 10 80 	jmp    *-0x7fef8608(,%eax,4)
80105917:	89 f6                	mov    %esi,%esi
80105919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105920:	e8 cb de ff ff       	call   801037f0 <myproc>
80105925:	85 c0                	test   %eax,%eax
80105927:	0f 84 d7 01 00 00    	je     80105b04 <trap+0x214>
8010592d:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105931:	0f 84 cd 01 00 00    	je     80105b04 <trap+0x214>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105937:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010593a:	8b 57 38             	mov    0x38(%edi),%edx
8010593d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105940:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105943:	e8 88 de ff ff       	call   801037d0 <cpuid>
80105948:	8b 77 34             	mov    0x34(%edi),%esi
8010594b:	8b 5f 30             	mov    0x30(%edi),%ebx
8010594e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105951:	e8 9a de ff ff       	call   801037f0 <myproc>
80105956:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105959:	e8 92 de ff ff       	call   801037f0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010595e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105961:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105964:	51                   	push   %ecx
80105965:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105966:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105969:	ff 75 e4             	pushl  -0x1c(%ebp)
8010596c:	56                   	push   %esi
8010596d:	53                   	push   %ebx
            myproc()->pid, myproc()->name, tf->trapno,
8010596e:	83 c2 70             	add    $0x70,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105971:	52                   	push   %edx
80105972:	ff 70 10             	pushl  0x10(%eax)
80105975:	68 b4 79 10 80       	push   $0x801079b4
8010597a:	e8 e1 ac ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010597f:	83 c4 20             	add    $0x20,%esp
80105982:	e8 69 de ff ff       	call   801037f0 <myproc>
80105987:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
8010598e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105990:	e8 5b de ff ff       	call   801037f0 <myproc>
80105995:	85 c0                	test   %eax,%eax
80105997:	74 0c                	je     801059a5 <trap+0xb5>
80105999:	e8 52 de ff ff       	call   801037f0 <myproc>
8010599e:	8b 50 28             	mov    0x28(%eax),%edx
801059a1:	85 d2                	test   %edx,%edx
801059a3:	75 4b                	jne    801059f0 <trap+0x100>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801059a5:	e8 46 de ff ff       	call   801037f0 <myproc>
801059aa:	85 c0                	test   %eax,%eax
801059ac:	74 0b                	je     801059b9 <trap+0xc9>
801059ae:	e8 3d de ff ff       	call   801037f0 <myproc>
801059b3:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801059b7:	74 4f                	je     80105a08 <trap+0x118>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059b9:	e8 32 de ff ff       	call   801037f0 <myproc>
801059be:	85 c0                	test   %eax,%eax
801059c0:	74 1d                	je     801059df <trap+0xef>
801059c2:	e8 29 de ff ff       	call   801037f0 <myproc>
801059c7:	8b 40 28             	mov    0x28(%eax),%eax
801059ca:	85 c0                	test   %eax,%eax
801059cc:	74 11                	je     801059df <trap+0xef>
801059ce:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801059d2:	83 e0 03             	and    $0x3,%eax
801059d5:	66 83 f8 03          	cmp    $0x3,%ax
801059d9:	0f 84 da 00 00 00    	je     80105ab9 <trap+0x1c9>
    exit();
}
801059df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059e2:	5b                   	pop    %ebx
801059e3:	5e                   	pop    %esi
801059e4:	5f                   	pop    %edi
801059e5:	5d                   	pop    %ebp
801059e6:	c3                   	ret    
801059e7:	89 f6                	mov    %esi,%esi
801059e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059f0:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801059f4:	83 e0 03             	and    $0x3,%eax
801059f7:	66 83 f8 03          	cmp    $0x3,%ax
801059fb:	75 a8                	jne    801059a5 <trap+0xb5>
    exit();
801059fd:	e8 1e e2 ff ff       	call   80103c20 <exit>
80105a02:	eb a1                	jmp    801059a5 <trap+0xb5>
80105a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105a08:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105a0c:	75 ab                	jne    801059b9 <trap+0xc9>
    yield();
80105a0e:	e8 3d e3 ff ff       	call   80103d50 <yield>
80105a13:	eb a4                	jmp    801059b9 <trap+0xc9>
80105a15:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105a18:	e8 b3 dd ff ff       	call   801037d0 <cpuid>
80105a1d:	85 c0                	test   %eax,%eax
80105a1f:	0f 84 ab 00 00 00    	je     80105ad0 <trap+0x1e0>
    lapiceoi();
80105a25:	e8 f6 cc ff ff       	call   80102720 <lapiceoi>
    break;
80105a2a:	e9 61 ff ff ff       	jmp    80105990 <trap+0xa0>
80105a2f:	90                   	nop
    kbdintr();
80105a30:	e8 ab cb ff ff       	call   801025e0 <kbdintr>
    lapiceoi();
80105a35:	e8 e6 cc ff ff       	call   80102720 <lapiceoi>
    break;
80105a3a:	e9 51 ff ff ff       	jmp    80105990 <trap+0xa0>
80105a3f:	90                   	nop
    uartintr();
80105a40:	e8 5b 02 00 00       	call   80105ca0 <uartintr>
    lapiceoi();
80105a45:	e8 d6 cc ff ff       	call   80102720 <lapiceoi>
    break;
80105a4a:	e9 41 ff ff ff       	jmp    80105990 <trap+0xa0>
80105a4f:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105a50:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105a54:	8b 77 38             	mov    0x38(%edi),%esi
80105a57:	e8 74 dd ff ff       	call   801037d0 <cpuid>
80105a5c:	56                   	push   %esi
80105a5d:	53                   	push   %ebx
80105a5e:	50                   	push   %eax
80105a5f:	68 5c 79 10 80       	push   $0x8010795c
80105a64:	e8 f7 ab ff ff       	call   80100660 <cprintf>
    lapiceoi();
80105a69:	e8 b2 cc ff ff       	call   80102720 <lapiceoi>
    break;
80105a6e:	83 c4 10             	add    $0x10,%esp
80105a71:	e9 1a ff ff ff       	jmp    80105990 <trap+0xa0>
80105a76:	8d 76 00             	lea    0x0(%esi),%esi
80105a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ideintr();
80105a80:	e8 cb c5 ff ff       	call   80102050 <ideintr>
80105a85:	eb 9e                	jmp    80105a25 <trap+0x135>
80105a87:	89 f6                	mov    %esi,%esi
80105a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(myproc()->killed)
80105a90:	e8 5b dd ff ff       	call   801037f0 <myproc>
80105a95:	8b 58 28             	mov    0x28(%eax),%ebx
80105a98:	85 db                	test   %ebx,%ebx
80105a9a:	75 2c                	jne    80105ac8 <trap+0x1d8>
    myproc()->tf = tf;
80105a9c:	e8 4f dd ff ff       	call   801037f0 <myproc>
80105aa1:	89 78 1c             	mov    %edi,0x1c(%eax)
    syscall();
80105aa4:	e8 d7 ed ff ff       	call   80104880 <syscall>
    if(myproc()->killed)
80105aa9:	e8 42 dd ff ff       	call   801037f0 <myproc>
80105aae:	8b 48 28             	mov    0x28(%eax),%ecx
80105ab1:	85 c9                	test   %ecx,%ecx
80105ab3:	0f 84 26 ff ff ff    	je     801059df <trap+0xef>
}
80105ab9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105abc:	5b                   	pop    %ebx
80105abd:	5e                   	pop    %esi
80105abe:	5f                   	pop    %edi
80105abf:	5d                   	pop    %ebp
      exit();
80105ac0:	e9 5b e1 ff ff       	jmp    80103c20 <exit>
80105ac5:	8d 76 00             	lea    0x0(%esi),%esi
      exit();
80105ac8:	e8 53 e1 ff ff       	call   80103c20 <exit>
80105acd:	eb cd                	jmp    80105a9c <trap+0x1ac>
80105acf:	90                   	nop
      acquire(&tickslock);
80105ad0:	83 ec 0c             	sub    $0xc,%esp
80105ad3:	68 a0 62 11 80       	push   $0x801162a0
80105ad8:	e8 c3 e8 ff ff       	call   801043a0 <acquire>
      wakeup(&ticks);
80105add:	c7 04 24 e0 6a 11 80 	movl   $0x80116ae0,(%esp)
      ticks++;
80105ae4:	83 05 e0 6a 11 80 01 	addl   $0x1,0x80116ae0
      wakeup(&ticks);
80105aeb:	e8 70 e4 ff ff       	call   80103f60 <wakeup>
      release(&tickslock);
80105af0:	c7 04 24 a0 62 11 80 	movl   $0x801162a0,(%esp)
80105af7:	e8 54 e9 ff ff       	call   80104450 <release>
80105afc:	83 c4 10             	add    $0x10,%esp
80105aff:	e9 21 ff ff ff       	jmp    80105a25 <trap+0x135>
80105b04:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105b07:	8b 5f 38             	mov    0x38(%edi),%ebx
80105b0a:	e8 c1 dc ff ff       	call   801037d0 <cpuid>
80105b0f:	83 ec 0c             	sub    $0xc,%esp
80105b12:	56                   	push   %esi
80105b13:	53                   	push   %ebx
80105b14:	50                   	push   %eax
80105b15:	ff 77 30             	pushl  0x30(%edi)
80105b18:	68 80 79 10 80       	push   $0x80107980
80105b1d:	e8 3e ab ff ff       	call   80100660 <cprintf>
      panic("trap");
80105b22:	83 c4 14             	add    $0x14,%esp
80105b25:	68 57 79 10 80       	push   $0x80107957
80105b2a:	e8 41 a8 ff ff       	call   80100370 <panic>
80105b2f:	90                   	nop

80105b30 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105b30:	a1 10 a6 10 80       	mov    0x8010a610,%eax
{
80105b35:	55                   	push   %ebp
80105b36:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105b38:	85 c0                	test   %eax,%eax
80105b3a:	74 1c                	je     80105b58 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105b3c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105b41:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105b42:	a8 01                	test   $0x1,%al
80105b44:	74 12                	je     80105b58 <uartgetc+0x28>
80105b46:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b4b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105b4c:	0f b6 c0             	movzbl %al,%eax
}
80105b4f:	5d                   	pop    %ebp
80105b50:	c3                   	ret    
80105b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105b58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b5d:	5d                   	pop    %ebp
80105b5e:	c3                   	ret    
80105b5f:	90                   	nop

80105b60 <uartputc.part.0>:
uartputc(int c)
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	57                   	push   %edi
80105b64:	56                   	push   %esi
80105b65:	53                   	push   %ebx
80105b66:	89 c7                	mov    %eax,%edi
80105b68:	bb 80 00 00 00       	mov    $0x80,%ebx
80105b6d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105b72:	83 ec 0c             	sub    $0xc,%esp
80105b75:	eb 1b                	jmp    80105b92 <uartputc.part.0+0x32>
80105b77:	89 f6                	mov    %esi,%esi
80105b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105b80:	83 ec 0c             	sub    $0xc,%esp
80105b83:	6a 0a                	push   $0xa
80105b85:	e8 b6 cb ff ff       	call   80102740 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105b8a:	83 c4 10             	add    $0x10,%esp
80105b8d:	83 eb 01             	sub    $0x1,%ebx
80105b90:	74 07                	je     80105b99 <uartputc.part.0+0x39>
80105b92:	89 f2                	mov    %esi,%edx
80105b94:	ec                   	in     (%dx),%al
80105b95:	a8 20                	test   $0x20,%al
80105b97:	74 e7                	je     80105b80 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105b99:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b9e:	89 f8                	mov    %edi,%eax
80105ba0:	ee                   	out    %al,(%dx)
}
80105ba1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ba4:	5b                   	pop    %ebx
80105ba5:	5e                   	pop    %esi
80105ba6:	5f                   	pop    %edi
80105ba7:	5d                   	pop    %ebp
80105ba8:	c3                   	ret    
80105ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105bb0 <uartinit>:
{
80105bb0:	55                   	push   %ebp
80105bb1:	31 c9                	xor    %ecx,%ecx
80105bb3:	89 c8                	mov    %ecx,%eax
80105bb5:	89 e5                	mov    %esp,%ebp
80105bb7:	57                   	push   %edi
80105bb8:	56                   	push   %esi
80105bb9:	53                   	push   %ebx
80105bba:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105bbf:	89 da                	mov    %ebx,%edx
80105bc1:	83 ec 0c             	sub    $0xc,%esp
80105bc4:	ee                   	out    %al,(%dx)
80105bc5:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105bca:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105bcf:	89 fa                	mov    %edi,%edx
80105bd1:	ee                   	out    %al,(%dx)
80105bd2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105bd7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105bdc:	ee                   	out    %al,(%dx)
80105bdd:	be f9 03 00 00       	mov    $0x3f9,%esi
80105be2:	89 c8                	mov    %ecx,%eax
80105be4:	89 f2                	mov    %esi,%edx
80105be6:	ee                   	out    %al,(%dx)
80105be7:	b8 03 00 00 00       	mov    $0x3,%eax
80105bec:	89 fa                	mov    %edi,%edx
80105bee:	ee                   	out    %al,(%dx)
80105bef:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105bf4:	89 c8                	mov    %ecx,%eax
80105bf6:	ee                   	out    %al,(%dx)
80105bf7:	b8 01 00 00 00       	mov    $0x1,%eax
80105bfc:	89 f2                	mov    %esi,%edx
80105bfe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105bff:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105c04:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105c05:	3c ff                	cmp    $0xff,%al
80105c07:	74 5a                	je     80105c63 <uartinit+0xb3>
  uart = 1;
80105c09:	c7 05 10 a6 10 80 01 	movl   $0x1,0x8010a610
80105c10:	00 00 00 
80105c13:	89 da                	mov    %ebx,%edx
80105c15:	ec                   	in     (%dx),%al
80105c16:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c1b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105c1c:	83 ec 08             	sub    $0x8,%esp
80105c1f:	bb 78 7a 10 80       	mov    $0x80107a78,%ebx
80105c24:	6a 00                	push   $0x0
80105c26:	6a 04                	push   $0x4
80105c28:	e8 73 c6 ff ff       	call   801022a0 <ioapicenable>
80105c2d:	83 c4 10             	add    $0x10,%esp
80105c30:	b8 78 00 00 00       	mov    $0x78,%eax
80105c35:	eb 13                	jmp    80105c4a <uartinit+0x9a>
80105c37:	89 f6                	mov    %esi,%esi
80105c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(p="xv6...\n"; *p; p++)
80105c40:	83 c3 01             	add    $0x1,%ebx
80105c43:	0f be 03             	movsbl (%ebx),%eax
80105c46:	84 c0                	test   %al,%al
80105c48:	74 19                	je     80105c63 <uartinit+0xb3>
  if(!uart)
80105c4a:	8b 15 10 a6 10 80    	mov    0x8010a610,%edx
80105c50:	85 d2                	test   %edx,%edx
80105c52:	74 ec                	je     80105c40 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80105c54:	83 c3 01             	add    $0x1,%ebx
80105c57:	e8 04 ff ff ff       	call   80105b60 <uartputc.part.0>
80105c5c:	0f be 03             	movsbl (%ebx),%eax
80105c5f:	84 c0                	test   %al,%al
80105c61:	75 e7                	jne    80105c4a <uartinit+0x9a>
}
80105c63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c66:	5b                   	pop    %ebx
80105c67:	5e                   	pop    %esi
80105c68:	5f                   	pop    %edi
80105c69:	5d                   	pop    %ebp
80105c6a:	c3                   	ret    
80105c6b:	90                   	nop
80105c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c70 <uartputc>:
  if(!uart)
80105c70:	8b 15 10 a6 10 80    	mov    0x8010a610,%edx
{
80105c76:	55                   	push   %ebp
80105c77:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105c79:	85 d2                	test   %edx,%edx
{
80105c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105c7e:	74 10                	je     80105c90 <uartputc+0x20>
}
80105c80:	5d                   	pop    %ebp
80105c81:	e9 da fe ff ff       	jmp    80105b60 <uartputc.part.0>
80105c86:	8d 76 00             	lea    0x0(%esi),%esi
80105c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105c90:	5d                   	pop    %ebp
80105c91:	c3                   	ret    
80105c92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ca0 <uartintr>:

void
uartintr(void)
{
80105ca0:	55                   	push   %ebp
80105ca1:	89 e5                	mov    %esp,%ebp
80105ca3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105ca6:	68 30 5b 10 80       	push   $0x80105b30
80105cab:	e8 30 ab ff ff       	call   801007e0 <consoleintr>
}
80105cb0:	83 c4 10             	add    $0x10,%esp
80105cb3:	c9                   	leave  
80105cb4:	c3                   	ret    

80105cb5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105cb5:	6a 00                	push   $0x0
  pushl $0
80105cb7:	6a 00                	push   $0x0
  jmp alltraps
80105cb9:	e9 3c fb ff ff       	jmp    801057fa <alltraps>

80105cbe <vector1>:
.globl vector1
vector1:
  pushl $0
80105cbe:	6a 00                	push   $0x0
  pushl $1
80105cc0:	6a 01                	push   $0x1
  jmp alltraps
80105cc2:	e9 33 fb ff ff       	jmp    801057fa <alltraps>

80105cc7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105cc7:	6a 00                	push   $0x0
  pushl $2
80105cc9:	6a 02                	push   $0x2
  jmp alltraps
80105ccb:	e9 2a fb ff ff       	jmp    801057fa <alltraps>

80105cd0 <vector3>:
.globl vector3
vector3:
  pushl $0
80105cd0:	6a 00                	push   $0x0
  pushl $3
80105cd2:	6a 03                	push   $0x3
  jmp alltraps
80105cd4:	e9 21 fb ff ff       	jmp    801057fa <alltraps>

80105cd9 <vector4>:
.globl vector4
vector4:
  pushl $0
80105cd9:	6a 00                	push   $0x0
  pushl $4
80105cdb:	6a 04                	push   $0x4
  jmp alltraps
80105cdd:	e9 18 fb ff ff       	jmp    801057fa <alltraps>

80105ce2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105ce2:	6a 00                	push   $0x0
  pushl $5
80105ce4:	6a 05                	push   $0x5
  jmp alltraps
80105ce6:	e9 0f fb ff ff       	jmp    801057fa <alltraps>

80105ceb <vector6>:
.globl vector6
vector6:
  pushl $0
80105ceb:	6a 00                	push   $0x0
  pushl $6
80105ced:	6a 06                	push   $0x6
  jmp alltraps
80105cef:	e9 06 fb ff ff       	jmp    801057fa <alltraps>

80105cf4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105cf4:	6a 00                	push   $0x0
  pushl $7
80105cf6:	6a 07                	push   $0x7
  jmp alltraps
80105cf8:	e9 fd fa ff ff       	jmp    801057fa <alltraps>

80105cfd <vector8>:
.globl vector8
vector8:
  pushl $8
80105cfd:	6a 08                	push   $0x8
  jmp alltraps
80105cff:	e9 f6 fa ff ff       	jmp    801057fa <alltraps>

80105d04 <vector9>:
.globl vector9
vector9:
  pushl $0
80105d04:	6a 00                	push   $0x0
  pushl $9
80105d06:	6a 09                	push   $0x9
  jmp alltraps
80105d08:	e9 ed fa ff ff       	jmp    801057fa <alltraps>

80105d0d <vector10>:
.globl vector10
vector10:
  pushl $10
80105d0d:	6a 0a                	push   $0xa
  jmp alltraps
80105d0f:	e9 e6 fa ff ff       	jmp    801057fa <alltraps>

80105d14 <vector11>:
.globl vector11
vector11:
  pushl $11
80105d14:	6a 0b                	push   $0xb
  jmp alltraps
80105d16:	e9 df fa ff ff       	jmp    801057fa <alltraps>

80105d1b <vector12>:
.globl vector12
vector12:
  pushl $12
80105d1b:	6a 0c                	push   $0xc
  jmp alltraps
80105d1d:	e9 d8 fa ff ff       	jmp    801057fa <alltraps>

80105d22 <vector13>:
.globl vector13
vector13:
  pushl $13
80105d22:	6a 0d                	push   $0xd
  jmp alltraps
80105d24:	e9 d1 fa ff ff       	jmp    801057fa <alltraps>

80105d29 <vector14>:
.globl vector14
vector14:
  pushl $14
80105d29:	6a 0e                	push   $0xe
  jmp alltraps
80105d2b:	e9 ca fa ff ff       	jmp    801057fa <alltraps>

80105d30 <vector15>:
.globl vector15
vector15:
  pushl $0
80105d30:	6a 00                	push   $0x0
  pushl $15
80105d32:	6a 0f                	push   $0xf
  jmp alltraps
80105d34:	e9 c1 fa ff ff       	jmp    801057fa <alltraps>

80105d39 <vector16>:
.globl vector16
vector16:
  pushl $0
80105d39:	6a 00                	push   $0x0
  pushl $16
80105d3b:	6a 10                	push   $0x10
  jmp alltraps
80105d3d:	e9 b8 fa ff ff       	jmp    801057fa <alltraps>

80105d42 <vector17>:
.globl vector17
vector17:
  pushl $17
80105d42:	6a 11                	push   $0x11
  jmp alltraps
80105d44:	e9 b1 fa ff ff       	jmp    801057fa <alltraps>

80105d49 <vector18>:
.globl vector18
vector18:
  pushl $0
80105d49:	6a 00                	push   $0x0
  pushl $18
80105d4b:	6a 12                	push   $0x12
  jmp alltraps
80105d4d:	e9 a8 fa ff ff       	jmp    801057fa <alltraps>

80105d52 <vector19>:
.globl vector19
vector19:
  pushl $0
80105d52:	6a 00                	push   $0x0
  pushl $19
80105d54:	6a 13                	push   $0x13
  jmp alltraps
80105d56:	e9 9f fa ff ff       	jmp    801057fa <alltraps>

80105d5b <vector20>:
.globl vector20
vector20:
  pushl $0
80105d5b:	6a 00                	push   $0x0
  pushl $20
80105d5d:	6a 14                	push   $0x14
  jmp alltraps
80105d5f:	e9 96 fa ff ff       	jmp    801057fa <alltraps>

80105d64 <vector21>:
.globl vector21
vector21:
  pushl $0
80105d64:	6a 00                	push   $0x0
  pushl $21
80105d66:	6a 15                	push   $0x15
  jmp alltraps
80105d68:	e9 8d fa ff ff       	jmp    801057fa <alltraps>

80105d6d <vector22>:
.globl vector22
vector22:
  pushl $0
80105d6d:	6a 00                	push   $0x0
  pushl $22
80105d6f:	6a 16                	push   $0x16
  jmp alltraps
80105d71:	e9 84 fa ff ff       	jmp    801057fa <alltraps>

80105d76 <vector23>:
.globl vector23
vector23:
  pushl $0
80105d76:	6a 00                	push   $0x0
  pushl $23
80105d78:	6a 17                	push   $0x17
  jmp alltraps
80105d7a:	e9 7b fa ff ff       	jmp    801057fa <alltraps>

80105d7f <vector24>:
.globl vector24
vector24:
  pushl $0
80105d7f:	6a 00                	push   $0x0
  pushl $24
80105d81:	6a 18                	push   $0x18
  jmp alltraps
80105d83:	e9 72 fa ff ff       	jmp    801057fa <alltraps>

80105d88 <vector25>:
.globl vector25
vector25:
  pushl $0
80105d88:	6a 00                	push   $0x0
  pushl $25
80105d8a:	6a 19                	push   $0x19
  jmp alltraps
80105d8c:	e9 69 fa ff ff       	jmp    801057fa <alltraps>

80105d91 <vector26>:
.globl vector26
vector26:
  pushl $0
80105d91:	6a 00                	push   $0x0
  pushl $26
80105d93:	6a 1a                	push   $0x1a
  jmp alltraps
80105d95:	e9 60 fa ff ff       	jmp    801057fa <alltraps>

80105d9a <vector27>:
.globl vector27
vector27:
  pushl $0
80105d9a:	6a 00                	push   $0x0
  pushl $27
80105d9c:	6a 1b                	push   $0x1b
  jmp alltraps
80105d9e:	e9 57 fa ff ff       	jmp    801057fa <alltraps>

80105da3 <vector28>:
.globl vector28
vector28:
  pushl $0
80105da3:	6a 00                	push   $0x0
  pushl $28
80105da5:	6a 1c                	push   $0x1c
  jmp alltraps
80105da7:	e9 4e fa ff ff       	jmp    801057fa <alltraps>

80105dac <vector29>:
.globl vector29
vector29:
  pushl $0
80105dac:	6a 00                	push   $0x0
  pushl $29
80105dae:	6a 1d                	push   $0x1d
  jmp alltraps
80105db0:	e9 45 fa ff ff       	jmp    801057fa <alltraps>

80105db5 <vector30>:
.globl vector30
vector30:
  pushl $0
80105db5:	6a 00                	push   $0x0
  pushl $30
80105db7:	6a 1e                	push   $0x1e
  jmp alltraps
80105db9:	e9 3c fa ff ff       	jmp    801057fa <alltraps>

80105dbe <vector31>:
.globl vector31
vector31:
  pushl $0
80105dbe:	6a 00                	push   $0x0
  pushl $31
80105dc0:	6a 1f                	push   $0x1f
  jmp alltraps
80105dc2:	e9 33 fa ff ff       	jmp    801057fa <alltraps>

80105dc7 <vector32>:
.globl vector32
vector32:
  pushl $0
80105dc7:	6a 00                	push   $0x0
  pushl $32
80105dc9:	6a 20                	push   $0x20
  jmp alltraps
80105dcb:	e9 2a fa ff ff       	jmp    801057fa <alltraps>

80105dd0 <vector33>:
.globl vector33
vector33:
  pushl $0
80105dd0:	6a 00                	push   $0x0
  pushl $33
80105dd2:	6a 21                	push   $0x21
  jmp alltraps
80105dd4:	e9 21 fa ff ff       	jmp    801057fa <alltraps>

80105dd9 <vector34>:
.globl vector34
vector34:
  pushl $0
80105dd9:	6a 00                	push   $0x0
  pushl $34
80105ddb:	6a 22                	push   $0x22
  jmp alltraps
80105ddd:	e9 18 fa ff ff       	jmp    801057fa <alltraps>

80105de2 <vector35>:
.globl vector35
vector35:
  pushl $0
80105de2:	6a 00                	push   $0x0
  pushl $35
80105de4:	6a 23                	push   $0x23
  jmp alltraps
80105de6:	e9 0f fa ff ff       	jmp    801057fa <alltraps>

80105deb <vector36>:
.globl vector36
vector36:
  pushl $0
80105deb:	6a 00                	push   $0x0
  pushl $36
80105ded:	6a 24                	push   $0x24
  jmp alltraps
80105def:	e9 06 fa ff ff       	jmp    801057fa <alltraps>

80105df4 <vector37>:
.globl vector37
vector37:
  pushl $0
80105df4:	6a 00                	push   $0x0
  pushl $37
80105df6:	6a 25                	push   $0x25
  jmp alltraps
80105df8:	e9 fd f9 ff ff       	jmp    801057fa <alltraps>

80105dfd <vector38>:
.globl vector38
vector38:
  pushl $0
80105dfd:	6a 00                	push   $0x0
  pushl $38
80105dff:	6a 26                	push   $0x26
  jmp alltraps
80105e01:	e9 f4 f9 ff ff       	jmp    801057fa <alltraps>

80105e06 <vector39>:
.globl vector39
vector39:
  pushl $0
80105e06:	6a 00                	push   $0x0
  pushl $39
80105e08:	6a 27                	push   $0x27
  jmp alltraps
80105e0a:	e9 eb f9 ff ff       	jmp    801057fa <alltraps>

80105e0f <vector40>:
.globl vector40
vector40:
  pushl $0
80105e0f:	6a 00                	push   $0x0
  pushl $40
80105e11:	6a 28                	push   $0x28
  jmp alltraps
80105e13:	e9 e2 f9 ff ff       	jmp    801057fa <alltraps>

80105e18 <vector41>:
.globl vector41
vector41:
  pushl $0
80105e18:	6a 00                	push   $0x0
  pushl $41
80105e1a:	6a 29                	push   $0x29
  jmp alltraps
80105e1c:	e9 d9 f9 ff ff       	jmp    801057fa <alltraps>

80105e21 <vector42>:
.globl vector42
vector42:
  pushl $0
80105e21:	6a 00                	push   $0x0
  pushl $42
80105e23:	6a 2a                	push   $0x2a
  jmp alltraps
80105e25:	e9 d0 f9 ff ff       	jmp    801057fa <alltraps>

80105e2a <vector43>:
.globl vector43
vector43:
  pushl $0
80105e2a:	6a 00                	push   $0x0
  pushl $43
80105e2c:	6a 2b                	push   $0x2b
  jmp alltraps
80105e2e:	e9 c7 f9 ff ff       	jmp    801057fa <alltraps>

80105e33 <vector44>:
.globl vector44
vector44:
  pushl $0
80105e33:	6a 00                	push   $0x0
  pushl $44
80105e35:	6a 2c                	push   $0x2c
  jmp alltraps
80105e37:	e9 be f9 ff ff       	jmp    801057fa <alltraps>

80105e3c <vector45>:
.globl vector45
vector45:
  pushl $0
80105e3c:	6a 00                	push   $0x0
  pushl $45
80105e3e:	6a 2d                	push   $0x2d
  jmp alltraps
80105e40:	e9 b5 f9 ff ff       	jmp    801057fa <alltraps>

80105e45 <vector46>:
.globl vector46
vector46:
  pushl $0
80105e45:	6a 00                	push   $0x0
  pushl $46
80105e47:	6a 2e                	push   $0x2e
  jmp alltraps
80105e49:	e9 ac f9 ff ff       	jmp    801057fa <alltraps>

80105e4e <vector47>:
.globl vector47
vector47:
  pushl $0
80105e4e:	6a 00                	push   $0x0
  pushl $47
80105e50:	6a 2f                	push   $0x2f
  jmp alltraps
80105e52:	e9 a3 f9 ff ff       	jmp    801057fa <alltraps>

80105e57 <vector48>:
.globl vector48
vector48:
  pushl $0
80105e57:	6a 00                	push   $0x0
  pushl $48
80105e59:	6a 30                	push   $0x30
  jmp alltraps
80105e5b:	e9 9a f9 ff ff       	jmp    801057fa <alltraps>

80105e60 <vector49>:
.globl vector49
vector49:
  pushl $0
80105e60:	6a 00                	push   $0x0
  pushl $49
80105e62:	6a 31                	push   $0x31
  jmp alltraps
80105e64:	e9 91 f9 ff ff       	jmp    801057fa <alltraps>

80105e69 <vector50>:
.globl vector50
vector50:
  pushl $0
80105e69:	6a 00                	push   $0x0
  pushl $50
80105e6b:	6a 32                	push   $0x32
  jmp alltraps
80105e6d:	e9 88 f9 ff ff       	jmp    801057fa <alltraps>

80105e72 <vector51>:
.globl vector51
vector51:
  pushl $0
80105e72:	6a 00                	push   $0x0
  pushl $51
80105e74:	6a 33                	push   $0x33
  jmp alltraps
80105e76:	e9 7f f9 ff ff       	jmp    801057fa <alltraps>

80105e7b <vector52>:
.globl vector52
vector52:
  pushl $0
80105e7b:	6a 00                	push   $0x0
  pushl $52
80105e7d:	6a 34                	push   $0x34
  jmp alltraps
80105e7f:	e9 76 f9 ff ff       	jmp    801057fa <alltraps>

80105e84 <vector53>:
.globl vector53
vector53:
  pushl $0
80105e84:	6a 00                	push   $0x0
  pushl $53
80105e86:	6a 35                	push   $0x35
  jmp alltraps
80105e88:	e9 6d f9 ff ff       	jmp    801057fa <alltraps>

80105e8d <vector54>:
.globl vector54
vector54:
  pushl $0
80105e8d:	6a 00                	push   $0x0
  pushl $54
80105e8f:	6a 36                	push   $0x36
  jmp alltraps
80105e91:	e9 64 f9 ff ff       	jmp    801057fa <alltraps>

80105e96 <vector55>:
.globl vector55
vector55:
  pushl $0
80105e96:	6a 00                	push   $0x0
  pushl $55
80105e98:	6a 37                	push   $0x37
  jmp alltraps
80105e9a:	e9 5b f9 ff ff       	jmp    801057fa <alltraps>

80105e9f <vector56>:
.globl vector56
vector56:
  pushl $0
80105e9f:	6a 00                	push   $0x0
  pushl $56
80105ea1:	6a 38                	push   $0x38
  jmp alltraps
80105ea3:	e9 52 f9 ff ff       	jmp    801057fa <alltraps>

80105ea8 <vector57>:
.globl vector57
vector57:
  pushl $0
80105ea8:	6a 00                	push   $0x0
  pushl $57
80105eaa:	6a 39                	push   $0x39
  jmp alltraps
80105eac:	e9 49 f9 ff ff       	jmp    801057fa <alltraps>

80105eb1 <vector58>:
.globl vector58
vector58:
  pushl $0
80105eb1:	6a 00                	push   $0x0
  pushl $58
80105eb3:	6a 3a                	push   $0x3a
  jmp alltraps
80105eb5:	e9 40 f9 ff ff       	jmp    801057fa <alltraps>

80105eba <vector59>:
.globl vector59
vector59:
  pushl $0
80105eba:	6a 00                	push   $0x0
  pushl $59
80105ebc:	6a 3b                	push   $0x3b
  jmp alltraps
80105ebe:	e9 37 f9 ff ff       	jmp    801057fa <alltraps>

80105ec3 <vector60>:
.globl vector60
vector60:
  pushl $0
80105ec3:	6a 00                	push   $0x0
  pushl $60
80105ec5:	6a 3c                	push   $0x3c
  jmp alltraps
80105ec7:	e9 2e f9 ff ff       	jmp    801057fa <alltraps>

80105ecc <vector61>:
.globl vector61
vector61:
  pushl $0
80105ecc:	6a 00                	push   $0x0
  pushl $61
80105ece:	6a 3d                	push   $0x3d
  jmp alltraps
80105ed0:	e9 25 f9 ff ff       	jmp    801057fa <alltraps>

80105ed5 <vector62>:
.globl vector62
vector62:
  pushl $0
80105ed5:	6a 00                	push   $0x0
  pushl $62
80105ed7:	6a 3e                	push   $0x3e
  jmp alltraps
80105ed9:	e9 1c f9 ff ff       	jmp    801057fa <alltraps>

80105ede <vector63>:
.globl vector63
vector63:
  pushl $0
80105ede:	6a 00                	push   $0x0
  pushl $63
80105ee0:	6a 3f                	push   $0x3f
  jmp alltraps
80105ee2:	e9 13 f9 ff ff       	jmp    801057fa <alltraps>

80105ee7 <vector64>:
.globl vector64
vector64:
  pushl $0
80105ee7:	6a 00                	push   $0x0
  pushl $64
80105ee9:	6a 40                	push   $0x40
  jmp alltraps
80105eeb:	e9 0a f9 ff ff       	jmp    801057fa <alltraps>

80105ef0 <vector65>:
.globl vector65
vector65:
  pushl $0
80105ef0:	6a 00                	push   $0x0
  pushl $65
80105ef2:	6a 41                	push   $0x41
  jmp alltraps
80105ef4:	e9 01 f9 ff ff       	jmp    801057fa <alltraps>

80105ef9 <vector66>:
.globl vector66
vector66:
  pushl $0
80105ef9:	6a 00                	push   $0x0
  pushl $66
80105efb:	6a 42                	push   $0x42
  jmp alltraps
80105efd:	e9 f8 f8 ff ff       	jmp    801057fa <alltraps>

80105f02 <vector67>:
.globl vector67
vector67:
  pushl $0
80105f02:	6a 00                	push   $0x0
  pushl $67
80105f04:	6a 43                	push   $0x43
  jmp alltraps
80105f06:	e9 ef f8 ff ff       	jmp    801057fa <alltraps>

80105f0b <vector68>:
.globl vector68
vector68:
  pushl $0
80105f0b:	6a 00                	push   $0x0
  pushl $68
80105f0d:	6a 44                	push   $0x44
  jmp alltraps
80105f0f:	e9 e6 f8 ff ff       	jmp    801057fa <alltraps>

80105f14 <vector69>:
.globl vector69
vector69:
  pushl $0
80105f14:	6a 00                	push   $0x0
  pushl $69
80105f16:	6a 45                	push   $0x45
  jmp alltraps
80105f18:	e9 dd f8 ff ff       	jmp    801057fa <alltraps>

80105f1d <vector70>:
.globl vector70
vector70:
  pushl $0
80105f1d:	6a 00                	push   $0x0
  pushl $70
80105f1f:	6a 46                	push   $0x46
  jmp alltraps
80105f21:	e9 d4 f8 ff ff       	jmp    801057fa <alltraps>

80105f26 <vector71>:
.globl vector71
vector71:
  pushl $0
80105f26:	6a 00                	push   $0x0
  pushl $71
80105f28:	6a 47                	push   $0x47
  jmp alltraps
80105f2a:	e9 cb f8 ff ff       	jmp    801057fa <alltraps>

80105f2f <vector72>:
.globl vector72
vector72:
  pushl $0
80105f2f:	6a 00                	push   $0x0
  pushl $72
80105f31:	6a 48                	push   $0x48
  jmp alltraps
80105f33:	e9 c2 f8 ff ff       	jmp    801057fa <alltraps>

80105f38 <vector73>:
.globl vector73
vector73:
  pushl $0
80105f38:	6a 00                	push   $0x0
  pushl $73
80105f3a:	6a 49                	push   $0x49
  jmp alltraps
80105f3c:	e9 b9 f8 ff ff       	jmp    801057fa <alltraps>

80105f41 <vector74>:
.globl vector74
vector74:
  pushl $0
80105f41:	6a 00                	push   $0x0
  pushl $74
80105f43:	6a 4a                	push   $0x4a
  jmp alltraps
80105f45:	e9 b0 f8 ff ff       	jmp    801057fa <alltraps>

80105f4a <vector75>:
.globl vector75
vector75:
  pushl $0
80105f4a:	6a 00                	push   $0x0
  pushl $75
80105f4c:	6a 4b                	push   $0x4b
  jmp alltraps
80105f4e:	e9 a7 f8 ff ff       	jmp    801057fa <alltraps>

80105f53 <vector76>:
.globl vector76
vector76:
  pushl $0
80105f53:	6a 00                	push   $0x0
  pushl $76
80105f55:	6a 4c                	push   $0x4c
  jmp alltraps
80105f57:	e9 9e f8 ff ff       	jmp    801057fa <alltraps>

80105f5c <vector77>:
.globl vector77
vector77:
  pushl $0
80105f5c:	6a 00                	push   $0x0
  pushl $77
80105f5e:	6a 4d                	push   $0x4d
  jmp alltraps
80105f60:	e9 95 f8 ff ff       	jmp    801057fa <alltraps>

80105f65 <vector78>:
.globl vector78
vector78:
  pushl $0
80105f65:	6a 00                	push   $0x0
  pushl $78
80105f67:	6a 4e                	push   $0x4e
  jmp alltraps
80105f69:	e9 8c f8 ff ff       	jmp    801057fa <alltraps>

80105f6e <vector79>:
.globl vector79
vector79:
  pushl $0
80105f6e:	6a 00                	push   $0x0
  pushl $79
80105f70:	6a 4f                	push   $0x4f
  jmp alltraps
80105f72:	e9 83 f8 ff ff       	jmp    801057fa <alltraps>

80105f77 <vector80>:
.globl vector80
vector80:
  pushl $0
80105f77:	6a 00                	push   $0x0
  pushl $80
80105f79:	6a 50                	push   $0x50
  jmp alltraps
80105f7b:	e9 7a f8 ff ff       	jmp    801057fa <alltraps>

80105f80 <vector81>:
.globl vector81
vector81:
  pushl $0
80105f80:	6a 00                	push   $0x0
  pushl $81
80105f82:	6a 51                	push   $0x51
  jmp alltraps
80105f84:	e9 71 f8 ff ff       	jmp    801057fa <alltraps>

80105f89 <vector82>:
.globl vector82
vector82:
  pushl $0
80105f89:	6a 00                	push   $0x0
  pushl $82
80105f8b:	6a 52                	push   $0x52
  jmp alltraps
80105f8d:	e9 68 f8 ff ff       	jmp    801057fa <alltraps>

80105f92 <vector83>:
.globl vector83
vector83:
  pushl $0
80105f92:	6a 00                	push   $0x0
  pushl $83
80105f94:	6a 53                	push   $0x53
  jmp alltraps
80105f96:	e9 5f f8 ff ff       	jmp    801057fa <alltraps>

80105f9b <vector84>:
.globl vector84
vector84:
  pushl $0
80105f9b:	6a 00                	push   $0x0
  pushl $84
80105f9d:	6a 54                	push   $0x54
  jmp alltraps
80105f9f:	e9 56 f8 ff ff       	jmp    801057fa <alltraps>

80105fa4 <vector85>:
.globl vector85
vector85:
  pushl $0
80105fa4:	6a 00                	push   $0x0
  pushl $85
80105fa6:	6a 55                	push   $0x55
  jmp alltraps
80105fa8:	e9 4d f8 ff ff       	jmp    801057fa <alltraps>

80105fad <vector86>:
.globl vector86
vector86:
  pushl $0
80105fad:	6a 00                	push   $0x0
  pushl $86
80105faf:	6a 56                	push   $0x56
  jmp alltraps
80105fb1:	e9 44 f8 ff ff       	jmp    801057fa <alltraps>

80105fb6 <vector87>:
.globl vector87
vector87:
  pushl $0
80105fb6:	6a 00                	push   $0x0
  pushl $87
80105fb8:	6a 57                	push   $0x57
  jmp alltraps
80105fba:	e9 3b f8 ff ff       	jmp    801057fa <alltraps>

80105fbf <vector88>:
.globl vector88
vector88:
  pushl $0
80105fbf:	6a 00                	push   $0x0
  pushl $88
80105fc1:	6a 58                	push   $0x58
  jmp alltraps
80105fc3:	e9 32 f8 ff ff       	jmp    801057fa <alltraps>

80105fc8 <vector89>:
.globl vector89
vector89:
  pushl $0
80105fc8:	6a 00                	push   $0x0
  pushl $89
80105fca:	6a 59                	push   $0x59
  jmp alltraps
80105fcc:	e9 29 f8 ff ff       	jmp    801057fa <alltraps>

80105fd1 <vector90>:
.globl vector90
vector90:
  pushl $0
80105fd1:	6a 00                	push   $0x0
  pushl $90
80105fd3:	6a 5a                	push   $0x5a
  jmp alltraps
80105fd5:	e9 20 f8 ff ff       	jmp    801057fa <alltraps>

80105fda <vector91>:
.globl vector91
vector91:
  pushl $0
80105fda:	6a 00                	push   $0x0
  pushl $91
80105fdc:	6a 5b                	push   $0x5b
  jmp alltraps
80105fde:	e9 17 f8 ff ff       	jmp    801057fa <alltraps>

80105fe3 <vector92>:
.globl vector92
vector92:
  pushl $0
80105fe3:	6a 00                	push   $0x0
  pushl $92
80105fe5:	6a 5c                	push   $0x5c
  jmp alltraps
80105fe7:	e9 0e f8 ff ff       	jmp    801057fa <alltraps>

80105fec <vector93>:
.globl vector93
vector93:
  pushl $0
80105fec:	6a 00                	push   $0x0
  pushl $93
80105fee:	6a 5d                	push   $0x5d
  jmp alltraps
80105ff0:	e9 05 f8 ff ff       	jmp    801057fa <alltraps>

80105ff5 <vector94>:
.globl vector94
vector94:
  pushl $0
80105ff5:	6a 00                	push   $0x0
  pushl $94
80105ff7:	6a 5e                	push   $0x5e
  jmp alltraps
80105ff9:	e9 fc f7 ff ff       	jmp    801057fa <alltraps>

80105ffe <vector95>:
.globl vector95
vector95:
  pushl $0
80105ffe:	6a 00                	push   $0x0
  pushl $95
80106000:	6a 5f                	push   $0x5f
  jmp alltraps
80106002:	e9 f3 f7 ff ff       	jmp    801057fa <alltraps>

80106007 <vector96>:
.globl vector96
vector96:
  pushl $0
80106007:	6a 00                	push   $0x0
  pushl $96
80106009:	6a 60                	push   $0x60
  jmp alltraps
8010600b:	e9 ea f7 ff ff       	jmp    801057fa <alltraps>

80106010 <vector97>:
.globl vector97
vector97:
  pushl $0
80106010:	6a 00                	push   $0x0
  pushl $97
80106012:	6a 61                	push   $0x61
  jmp alltraps
80106014:	e9 e1 f7 ff ff       	jmp    801057fa <alltraps>

80106019 <vector98>:
.globl vector98
vector98:
  pushl $0
80106019:	6a 00                	push   $0x0
  pushl $98
8010601b:	6a 62                	push   $0x62
  jmp alltraps
8010601d:	e9 d8 f7 ff ff       	jmp    801057fa <alltraps>

80106022 <vector99>:
.globl vector99
vector99:
  pushl $0
80106022:	6a 00                	push   $0x0
  pushl $99
80106024:	6a 63                	push   $0x63
  jmp alltraps
80106026:	e9 cf f7 ff ff       	jmp    801057fa <alltraps>

8010602b <vector100>:
.globl vector100
vector100:
  pushl $0
8010602b:	6a 00                	push   $0x0
  pushl $100
8010602d:	6a 64                	push   $0x64
  jmp alltraps
8010602f:	e9 c6 f7 ff ff       	jmp    801057fa <alltraps>

80106034 <vector101>:
.globl vector101
vector101:
  pushl $0
80106034:	6a 00                	push   $0x0
  pushl $101
80106036:	6a 65                	push   $0x65
  jmp alltraps
80106038:	e9 bd f7 ff ff       	jmp    801057fa <alltraps>

8010603d <vector102>:
.globl vector102
vector102:
  pushl $0
8010603d:	6a 00                	push   $0x0
  pushl $102
8010603f:	6a 66                	push   $0x66
  jmp alltraps
80106041:	e9 b4 f7 ff ff       	jmp    801057fa <alltraps>

80106046 <vector103>:
.globl vector103
vector103:
  pushl $0
80106046:	6a 00                	push   $0x0
  pushl $103
80106048:	6a 67                	push   $0x67
  jmp alltraps
8010604a:	e9 ab f7 ff ff       	jmp    801057fa <alltraps>

8010604f <vector104>:
.globl vector104
vector104:
  pushl $0
8010604f:	6a 00                	push   $0x0
  pushl $104
80106051:	6a 68                	push   $0x68
  jmp alltraps
80106053:	e9 a2 f7 ff ff       	jmp    801057fa <alltraps>

80106058 <vector105>:
.globl vector105
vector105:
  pushl $0
80106058:	6a 00                	push   $0x0
  pushl $105
8010605a:	6a 69                	push   $0x69
  jmp alltraps
8010605c:	e9 99 f7 ff ff       	jmp    801057fa <alltraps>

80106061 <vector106>:
.globl vector106
vector106:
  pushl $0
80106061:	6a 00                	push   $0x0
  pushl $106
80106063:	6a 6a                	push   $0x6a
  jmp alltraps
80106065:	e9 90 f7 ff ff       	jmp    801057fa <alltraps>

8010606a <vector107>:
.globl vector107
vector107:
  pushl $0
8010606a:	6a 00                	push   $0x0
  pushl $107
8010606c:	6a 6b                	push   $0x6b
  jmp alltraps
8010606e:	e9 87 f7 ff ff       	jmp    801057fa <alltraps>

80106073 <vector108>:
.globl vector108
vector108:
  pushl $0
80106073:	6a 00                	push   $0x0
  pushl $108
80106075:	6a 6c                	push   $0x6c
  jmp alltraps
80106077:	e9 7e f7 ff ff       	jmp    801057fa <alltraps>

8010607c <vector109>:
.globl vector109
vector109:
  pushl $0
8010607c:	6a 00                	push   $0x0
  pushl $109
8010607e:	6a 6d                	push   $0x6d
  jmp alltraps
80106080:	e9 75 f7 ff ff       	jmp    801057fa <alltraps>

80106085 <vector110>:
.globl vector110
vector110:
  pushl $0
80106085:	6a 00                	push   $0x0
  pushl $110
80106087:	6a 6e                	push   $0x6e
  jmp alltraps
80106089:	e9 6c f7 ff ff       	jmp    801057fa <alltraps>

8010608e <vector111>:
.globl vector111
vector111:
  pushl $0
8010608e:	6a 00                	push   $0x0
  pushl $111
80106090:	6a 6f                	push   $0x6f
  jmp alltraps
80106092:	e9 63 f7 ff ff       	jmp    801057fa <alltraps>

80106097 <vector112>:
.globl vector112
vector112:
  pushl $0
80106097:	6a 00                	push   $0x0
  pushl $112
80106099:	6a 70                	push   $0x70
  jmp alltraps
8010609b:	e9 5a f7 ff ff       	jmp    801057fa <alltraps>

801060a0 <vector113>:
.globl vector113
vector113:
  pushl $0
801060a0:	6a 00                	push   $0x0
  pushl $113
801060a2:	6a 71                	push   $0x71
  jmp alltraps
801060a4:	e9 51 f7 ff ff       	jmp    801057fa <alltraps>

801060a9 <vector114>:
.globl vector114
vector114:
  pushl $0
801060a9:	6a 00                	push   $0x0
  pushl $114
801060ab:	6a 72                	push   $0x72
  jmp alltraps
801060ad:	e9 48 f7 ff ff       	jmp    801057fa <alltraps>

801060b2 <vector115>:
.globl vector115
vector115:
  pushl $0
801060b2:	6a 00                	push   $0x0
  pushl $115
801060b4:	6a 73                	push   $0x73
  jmp alltraps
801060b6:	e9 3f f7 ff ff       	jmp    801057fa <alltraps>

801060bb <vector116>:
.globl vector116
vector116:
  pushl $0
801060bb:	6a 00                	push   $0x0
  pushl $116
801060bd:	6a 74                	push   $0x74
  jmp alltraps
801060bf:	e9 36 f7 ff ff       	jmp    801057fa <alltraps>

801060c4 <vector117>:
.globl vector117
vector117:
  pushl $0
801060c4:	6a 00                	push   $0x0
  pushl $117
801060c6:	6a 75                	push   $0x75
  jmp alltraps
801060c8:	e9 2d f7 ff ff       	jmp    801057fa <alltraps>

801060cd <vector118>:
.globl vector118
vector118:
  pushl $0
801060cd:	6a 00                	push   $0x0
  pushl $118
801060cf:	6a 76                	push   $0x76
  jmp alltraps
801060d1:	e9 24 f7 ff ff       	jmp    801057fa <alltraps>

801060d6 <vector119>:
.globl vector119
vector119:
  pushl $0
801060d6:	6a 00                	push   $0x0
  pushl $119
801060d8:	6a 77                	push   $0x77
  jmp alltraps
801060da:	e9 1b f7 ff ff       	jmp    801057fa <alltraps>

801060df <vector120>:
.globl vector120
vector120:
  pushl $0
801060df:	6a 00                	push   $0x0
  pushl $120
801060e1:	6a 78                	push   $0x78
  jmp alltraps
801060e3:	e9 12 f7 ff ff       	jmp    801057fa <alltraps>

801060e8 <vector121>:
.globl vector121
vector121:
  pushl $0
801060e8:	6a 00                	push   $0x0
  pushl $121
801060ea:	6a 79                	push   $0x79
  jmp alltraps
801060ec:	e9 09 f7 ff ff       	jmp    801057fa <alltraps>

801060f1 <vector122>:
.globl vector122
vector122:
  pushl $0
801060f1:	6a 00                	push   $0x0
  pushl $122
801060f3:	6a 7a                	push   $0x7a
  jmp alltraps
801060f5:	e9 00 f7 ff ff       	jmp    801057fa <alltraps>

801060fa <vector123>:
.globl vector123
vector123:
  pushl $0
801060fa:	6a 00                	push   $0x0
  pushl $123
801060fc:	6a 7b                	push   $0x7b
  jmp alltraps
801060fe:	e9 f7 f6 ff ff       	jmp    801057fa <alltraps>

80106103 <vector124>:
.globl vector124
vector124:
  pushl $0
80106103:	6a 00                	push   $0x0
  pushl $124
80106105:	6a 7c                	push   $0x7c
  jmp alltraps
80106107:	e9 ee f6 ff ff       	jmp    801057fa <alltraps>

8010610c <vector125>:
.globl vector125
vector125:
  pushl $0
8010610c:	6a 00                	push   $0x0
  pushl $125
8010610e:	6a 7d                	push   $0x7d
  jmp alltraps
80106110:	e9 e5 f6 ff ff       	jmp    801057fa <alltraps>

80106115 <vector126>:
.globl vector126
vector126:
  pushl $0
80106115:	6a 00                	push   $0x0
  pushl $126
80106117:	6a 7e                	push   $0x7e
  jmp alltraps
80106119:	e9 dc f6 ff ff       	jmp    801057fa <alltraps>

8010611e <vector127>:
.globl vector127
vector127:
  pushl $0
8010611e:	6a 00                	push   $0x0
  pushl $127
80106120:	6a 7f                	push   $0x7f
  jmp alltraps
80106122:	e9 d3 f6 ff ff       	jmp    801057fa <alltraps>

80106127 <vector128>:
.globl vector128
vector128:
  pushl $0
80106127:	6a 00                	push   $0x0
  pushl $128
80106129:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010612e:	e9 c7 f6 ff ff       	jmp    801057fa <alltraps>

80106133 <vector129>:
.globl vector129
vector129:
  pushl $0
80106133:	6a 00                	push   $0x0
  pushl $129
80106135:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010613a:	e9 bb f6 ff ff       	jmp    801057fa <alltraps>

8010613f <vector130>:
.globl vector130
vector130:
  pushl $0
8010613f:	6a 00                	push   $0x0
  pushl $130
80106141:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106146:	e9 af f6 ff ff       	jmp    801057fa <alltraps>

8010614b <vector131>:
.globl vector131
vector131:
  pushl $0
8010614b:	6a 00                	push   $0x0
  pushl $131
8010614d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106152:	e9 a3 f6 ff ff       	jmp    801057fa <alltraps>

80106157 <vector132>:
.globl vector132
vector132:
  pushl $0
80106157:	6a 00                	push   $0x0
  pushl $132
80106159:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010615e:	e9 97 f6 ff ff       	jmp    801057fa <alltraps>

80106163 <vector133>:
.globl vector133
vector133:
  pushl $0
80106163:	6a 00                	push   $0x0
  pushl $133
80106165:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010616a:	e9 8b f6 ff ff       	jmp    801057fa <alltraps>

8010616f <vector134>:
.globl vector134
vector134:
  pushl $0
8010616f:	6a 00                	push   $0x0
  pushl $134
80106171:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106176:	e9 7f f6 ff ff       	jmp    801057fa <alltraps>

8010617b <vector135>:
.globl vector135
vector135:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $135
8010617d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106182:	e9 73 f6 ff ff       	jmp    801057fa <alltraps>

80106187 <vector136>:
.globl vector136
vector136:
  pushl $0
80106187:	6a 00                	push   $0x0
  pushl $136
80106189:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010618e:	e9 67 f6 ff ff       	jmp    801057fa <alltraps>

80106193 <vector137>:
.globl vector137
vector137:
  pushl $0
80106193:	6a 00                	push   $0x0
  pushl $137
80106195:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010619a:	e9 5b f6 ff ff       	jmp    801057fa <alltraps>

8010619f <vector138>:
.globl vector138
vector138:
  pushl $0
8010619f:	6a 00                	push   $0x0
  pushl $138
801061a1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801061a6:	e9 4f f6 ff ff       	jmp    801057fa <alltraps>

801061ab <vector139>:
.globl vector139
vector139:
  pushl $0
801061ab:	6a 00                	push   $0x0
  pushl $139
801061ad:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801061b2:	e9 43 f6 ff ff       	jmp    801057fa <alltraps>

801061b7 <vector140>:
.globl vector140
vector140:
  pushl $0
801061b7:	6a 00                	push   $0x0
  pushl $140
801061b9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801061be:	e9 37 f6 ff ff       	jmp    801057fa <alltraps>

801061c3 <vector141>:
.globl vector141
vector141:
  pushl $0
801061c3:	6a 00                	push   $0x0
  pushl $141
801061c5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801061ca:	e9 2b f6 ff ff       	jmp    801057fa <alltraps>

801061cf <vector142>:
.globl vector142
vector142:
  pushl $0
801061cf:	6a 00                	push   $0x0
  pushl $142
801061d1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801061d6:	e9 1f f6 ff ff       	jmp    801057fa <alltraps>

801061db <vector143>:
.globl vector143
vector143:
  pushl $0
801061db:	6a 00                	push   $0x0
  pushl $143
801061dd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801061e2:	e9 13 f6 ff ff       	jmp    801057fa <alltraps>

801061e7 <vector144>:
.globl vector144
vector144:
  pushl $0
801061e7:	6a 00                	push   $0x0
  pushl $144
801061e9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801061ee:	e9 07 f6 ff ff       	jmp    801057fa <alltraps>

801061f3 <vector145>:
.globl vector145
vector145:
  pushl $0
801061f3:	6a 00                	push   $0x0
  pushl $145
801061f5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801061fa:	e9 fb f5 ff ff       	jmp    801057fa <alltraps>

801061ff <vector146>:
.globl vector146
vector146:
  pushl $0
801061ff:	6a 00                	push   $0x0
  pushl $146
80106201:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106206:	e9 ef f5 ff ff       	jmp    801057fa <alltraps>

8010620b <vector147>:
.globl vector147
vector147:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $147
8010620d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106212:	e9 e3 f5 ff ff       	jmp    801057fa <alltraps>

80106217 <vector148>:
.globl vector148
vector148:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $148
80106219:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010621e:	e9 d7 f5 ff ff       	jmp    801057fa <alltraps>

80106223 <vector149>:
.globl vector149
vector149:
  pushl $0
80106223:	6a 00                	push   $0x0
  pushl $149
80106225:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010622a:	e9 cb f5 ff ff       	jmp    801057fa <alltraps>

8010622f <vector150>:
.globl vector150
vector150:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $150
80106231:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106236:	e9 bf f5 ff ff       	jmp    801057fa <alltraps>

8010623b <vector151>:
.globl vector151
vector151:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $151
8010623d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106242:	e9 b3 f5 ff ff       	jmp    801057fa <alltraps>

80106247 <vector152>:
.globl vector152
vector152:
  pushl $0
80106247:	6a 00                	push   $0x0
  pushl $152
80106249:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010624e:	e9 a7 f5 ff ff       	jmp    801057fa <alltraps>

80106253 <vector153>:
.globl vector153
vector153:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $153
80106255:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010625a:	e9 9b f5 ff ff       	jmp    801057fa <alltraps>

8010625f <vector154>:
.globl vector154
vector154:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $154
80106261:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106266:	e9 8f f5 ff ff       	jmp    801057fa <alltraps>

8010626b <vector155>:
.globl vector155
vector155:
  pushl $0
8010626b:	6a 00                	push   $0x0
  pushl $155
8010626d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106272:	e9 83 f5 ff ff       	jmp    801057fa <alltraps>

80106277 <vector156>:
.globl vector156
vector156:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $156
80106279:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010627e:	e9 77 f5 ff ff       	jmp    801057fa <alltraps>

80106283 <vector157>:
.globl vector157
vector157:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $157
80106285:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010628a:	e9 6b f5 ff ff       	jmp    801057fa <alltraps>

8010628f <vector158>:
.globl vector158
vector158:
  pushl $0
8010628f:	6a 00                	push   $0x0
  pushl $158
80106291:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106296:	e9 5f f5 ff ff       	jmp    801057fa <alltraps>

8010629b <vector159>:
.globl vector159
vector159:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $159
8010629d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801062a2:	e9 53 f5 ff ff       	jmp    801057fa <alltraps>

801062a7 <vector160>:
.globl vector160
vector160:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $160
801062a9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801062ae:	e9 47 f5 ff ff       	jmp    801057fa <alltraps>

801062b3 <vector161>:
.globl vector161
vector161:
  pushl $0
801062b3:	6a 00                	push   $0x0
  pushl $161
801062b5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801062ba:	e9 3b f5 ff ff       	jmp    801057fa <alltraps>

801062bf <vector162>:
.globl vector162
vector162:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $162
801062c1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801062c6:	e9 2f f5 ff ff       	jmp    801057fa <alltraps>

801062cb <vector163>:
.globl vector163
vector163:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $163
801062cd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801062d2:	e9 23 f5 ff ff       	jmp    801057fa <alltraps>

801062d7 <vector164>:
.globl vector164
vector164:
  pushl $0
801062d7:	6a 00                	push   $0x0
  pushl $164
801062d9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801062de:	e9 17 f5 ff ff       	jmp    801057fa <alltraps>

801062e3 <vector165>:
.globl vector165
vector165:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $165
801062e5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801062ea:	e9 0b f5 ff ff       	jmp    801057fa <alltraps>

801062ef <vector166>:
.globl vector166
vector166:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $166
801062f1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801062f6:	e9 ff f4 ff ff       	jmp    801057fa <alltraps>

801062fb <vector167>:
.globl vector167
vector167:
  pushl $0
801062fb:	6a 00                	push   $0x0
  pushl $167
801062fd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106302:	e9 f3 f4 ff ff       	jmp    801057fa <alltraps>

80106307 <vector168>:
.globl vector168
vector168:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $168
80106309:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010630e:	e9 e7 f4 ff ff       	jmp    801057fa <alltraps>

80106313 <vector169>:
.globl vector169
vector169:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $169
80106315:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010631a:	e9 db f4 ff ff       	jmp    801057fa <alltraps>

8010631f <vector170>:
.globl vector170
vector170:
  pushl $0
8010631f:	6a 00                	push   $0x0
  pushl $170
80106321:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106326:	e9 cf f4 ff ff       	jmp    801057fa <alltraps>

8010632b <vector171>:
.globl vector171
vector171:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $171
8010632d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106332:	e9 c3 f4 ff ff       	jmp    801057fa <alltraps>

80106337 <vector172>:
.globl vector172
vector172:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $172
80106339:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010633e:	e9 b7 f4 ff ff       	jmp    801057fa <alltraps>

80106343 <vector173>:
.globl vector173
vector173:
  pushl $0
80106343:	6a 00                	push   $0x0
  pushl $173
80106345:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010634a:	e9 ab f4 ff ff       	jmp    801057fa <alltraps>

8010634f <vector174>:
.globl vector174
vector174:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $174
80106351:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106356:	e9 9f f4 ff ff       	jmp    801057fa <alltraps>

8010635b <vector175>:
.globl vector175
vector175:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $175
8010635d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106362:	e9 93 f4 ff ff       	jmp    801057fa <alltraps>

80106367 <vector176>:
.globl vector176
vector176:
  pushl $0
80106367:	6a 00                	push   $0x0
  pushl $176
80106369:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010636e:	e9 87 f4 ff ff       	jmp    801057fa <alltraps>

80106373 <vector177>:
.globl vector177
vector177:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $177
80106375:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010637a:	e9 7b f4 ff ff       	jmp    801057fa <alltraps>

8010637f <vector178>:
.globl vector178
vector178:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $178
80106381:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106386:	e9 6f f4 ff ff       	jmp    801057fa <alltraps>

8010638b <vector179>:
.globl vector179
vector179:
  pushl $0
8010638b:	6a 00                	push   $0x0
  pushl $179
8010638d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106392:	e9 63 f4 ff ff       	jmp    801057fa <alltraps>

80106397 <vector180>:
.globl vector180
vector180:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $180
80106399:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010639e:	e9 57 f4 ff ff       	jmp    801057fa <alltraps>

801063a3 <vector181>:
.globl vector181
vector181:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $181
801063a5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801063aa:	e9 4b f4 ff ff       	jmp    801057fa <alltraps>

801063af <vector182>:
.globl vector182
vector182:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $182
801063b1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801063b6:	e9 3f f4 ff ff       	jmp    801057fa <alltraps>

801063bb <vector183>:
.globl vector183
vector183:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $183
801063bd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801063c2:	e9 33 f4 ff ff       	jmp    801057fa <alltraps>

801063c7 <vector184>:
.globl vector184
vector184:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $184
801063c9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801063ce:	e9 27 f4 ff ff       	jmp    801057fa <alltraps>

801063d3 <vector185>:
.globl vector185
vector185:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $185
801063d5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801063da:	e9 1b f4 ff ff       	jmp    801057fa <alltraps>

801063df <vector186>:
.globl vector186
vector186:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $186
801063e1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801063e6:	e9 0f f4 ff ff       	jmp    801057fa <alltraps>

801063eb <vector187>:
.globl vector187
vector187:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $187
801063ed:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801063f2:	e9 03 f4 ff ff       	jmp    801057fa <alltraps>

801063f7 <vector188>:
.globl vector188
vector188:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $188
801063f9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801063fe:	e9 f7 f3 ff ff       	jmp    801057fa <alltraps>

80106403 <vector189>:
.globl vector189
vector189:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $189
80106405:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010640a:	e9 eb f3 ff ff       	jmp    801057fa <alltraps>

8010640f <vector190>:
.globl vector190
vector190:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $190
80106411:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106416:	e9 df f3 ff ff       	jmp    801057fa <alltraps>

8010641b <vector191>:
.globl vector191
vector191:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $191
8010641d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106422:	e9 d3 f3 ff ff       	jmp    801057fa <alltraps>

80106427 <vector192>:
.globl vector192
vector192:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $192
80106429:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010642e:	e9 c7 f3 ff ff       	jmp    801057fa <alltraps>

80106433 <vector193>:
.globl vector193
vector193:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $193
80106435:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010643a:	e9 bb f3 ff ff       	jmp    801057fa <alltraps>

8010643f <vector194>:
.globl vector194
vector194:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $194
80106441:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106446:	e9 af f3 ff ff       	jmp    801057fa <alltraps>

8010644b <vector195>:
.globl vector195
vector195:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $195
8010644d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106452:	e9 a3 f3 ff ff       	jmp    801057fa <alltraps>

80106457 <vector196>:
.globl vector196
vector196:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $196
80106459:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010645e:	e9 97 f3 ff ff       	jmp    801057fa <alltraps>

80106463 <vector197>:
.globl vector197
vector197:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $197
80106465:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010646a:	e9 8b f3 ff ff       	jmp    801057fa <alltraps>

8010646f <vector198>:
.globl vector198
vector198:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $198
80106471:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106476:	e9 7f f3 ff ff       	jmp    801057fa <alltraps>

8010647b <vector199>:
.globl vector199
vector199:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $199
8010647d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106482:	e9 73 f3 ff ff       	jmp    801057fa <alltraps>

80106487 <vector200>:
.globl vector200
vector200:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $200
80106489:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010648e:	e9 67 f3 ff ff       	jmp    801057fa <alltraps>

80106493 <vector201>:
.globl vector201
vector201:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $201
80106495:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010649a:	e9 5b f3 ff ff       	jmp    801057fa <alltraps>

8010649f <vector202>:
.globl vector202
vector202:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $202
801064a1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801064a6:	e9 4f f3 ff ff       	jmp    801057fa <alltraps>

801064ab <vector203>:
.globl vector203
vector203:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $203
801064ad:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801064b2:	e9 43 f3 ff ff       	jmp    801057fa <alltraps>

801064b7 <vector204>:
.globl vector204
vector204:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $204
801064b9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801064be:	e9 37 f3 ff ff       	jmp    801057fa <alltraps>

801064c3 <vector205>:
.globl vector205
vector205:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $205
801064c5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801064ca:	e9 2b f3 ff ff       	jmp    801057fa <alltraps>

801064cf <vector206>:
.globl vector206
vector206:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $206
801064d1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801064d6:	e9 1f f3 ff ff       	jmp    801057fa <alltraps>

801064db <vector207>:
.globl vector207
vector207:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $207
801064dd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801064e2:	e9 13 f3 ff ff       	jmp    801057fa <alltraps>

801064e7 <vector208>:
.globl vector208
vector208:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $208
801064e9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801064ee:	e9 07 f3 ff ff       	jmp    801057fa <alltraps>

801064f3 <vector209>:
.globl vector209
vector209:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $209
801064f5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801064fa:	e9 fb f2 ff ff       	jmp    801057fa <alltraps>

801064ff <vector210>:
.globl vector210
vector210:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $210
80106501:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106506:	e9 ef f2 ff ff       	jmp    801057fa <alltraps>

8010650b <vector211>:
.globl vector211
vector211:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $211
8010650d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106512:	e9 e3 f2 ff ff       	jmp    801057fa <alltraps>

80106517 <vector212>:
.globl vector212
vector212:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $212
80106519:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010651e:	e9 d7 f2 ff ff       	jmp    801057fa <alltraps>

80106523 <vector213>:
.globl vector213
vector213:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $213
80106525:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010652a:	e9 cb f2 ff ff       	jmp    801057fa <alltraps>

8010652f <vector214>:
.globl vector214
vector214:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $214
80106531:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106536:	e9 bf f2 ff ff       	jmp    801057fa <alltraps>

8010653b <vector215>:
.globl vector215
vector215:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $215
8010653d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106542:	e9 b3 f2 ff ff       	jmp    801057fa <alltraps>

80106547 <vector216>:
.globl vector216
vector216:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $216
80106549:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010654e:	e9 a7 f2 ff ff       	jmp    801057fa <alltraps>

80106553 <vector217>:
.globl vector217
vector217:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $217
80106555:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010655a:	e9 9b f2 ff ff       	jmp    801057fa <alltraps>

8010655f <vector218>:
.globl vector218
vector218:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $218
80106561:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106566:	e9 8f f2 ff ff       	jmp    801057fa <alltraps>

8010656b <vector219>:
.globl vector219
vector219:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $219
8010656d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106572:	e9 83 f2 ff ff       	jmp    801057fa <alltraps>

80106577 <vector220>:
.globl vector220
vector220:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $220
80106579:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010657e:	e9 77 f2 ff ff       	jmp    801057fa <alltraps>

80106583 <vector221>:
.globl vector221
vector221:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $221
80106585:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010658a:	e9 6b f2 ff ff       	jmp    801057fa <alltraps>

8010658f <vector222>:
.globl vector222
vector222:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $222
80106591:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106596:	e9 5f f2 ff ff       	jmp    801057fa <alltraps>

8010659b <vector223>:
.globl vector223
vector223:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $223
8010659d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801065a2:	e9 53 f2 ff ff       	jmp    801057fa <alltraps>

801065a7 <vector224>:
.globl vector224
vector224:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $224
801065a9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801065ae:	e9 47 f2 ff ff       	jmp    801057fa <alltraps>

801065b3 <vector225>:
.globl vector225
vector225:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $225
801065b5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801065ba:	e9 3b f2 ff ff       	jmp    801057fa <alltraps>

801065bf <vector226>:
.globl vector226
vector226:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $226
801065c1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801065c6:	e9 2f f2 ff ff       	jmp    801057fa <alltraps>

801065cb <vector227>:
.globl vector227
vector227:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $227
801065cd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801065d2:	e9 23 f2 ff ff       	jmp    801057fa <alltraps>

801065d7 <vector228>:
.globl vector228
vector228:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $228
801065d9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801065de:	e9 17 f2 ff ff       	jmp    801057fa <alltraps>

801065e3 <vector229>:
.globl vector229
vector229:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $229
801065e5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801065ea:	e9 0b f2 ff ff       	jmp    801057fa <alltraps>

801065ef <vector230>:
.globl vector230
vector230:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $230
801065f1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801065f6:	e9 ff f1 ff ff       	jmp    801057fa <alltraps>

801065fb <vector231>:
.globl vector231
vector231:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $231
801065fd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106602:	e9 f3 f1 ff ff       	jmp    801057fa <alltraps>

80106607 <vector232>:
.globl vector232
vector232:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $232
80106609:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010660e:	e9 e7 f1 ff ff       	jmp    801057fa <alltraps>

80106613 <vector233>:
.globl vector233
vector233:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $233
80106615:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010661a:	e9 db f1 ff ff       	jmp    801057fa <alltraps>

8010661f <vector234>:
.globl vector234
vector234:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $234
80106621:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106626:	e9 cf f1 ff ff       	jmp    801057fa <alltraps>

8010662b <vector235>:
.globl vector235
vector235:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $235
8010662d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106632:	e9 c3 f1 ff ff       	jmp    801057fa <alltraps>

80106637 <vector236>:
.globl vector236
vector236:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $236
80106639:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010663e:	e9 b7 f1 ff ff       	jmp    801057fa <alltraps>

80106643 <vector237>:
.globl vector237
vector237:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $237
80106645:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010664a:	e9 ab f1 ff ff       	jmp    801057fa <alltraps>

8010664f <vector238>:
.globl vector238
vector238:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $238
80106651:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106656:	e9 9f f1 ff ff       	jmp    801057fa <alltraps>

8010665b <vector239>:
.globl vector239
vector239:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $239
8010665d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106662:	e9 93 f1 ff ff       	jmp    801057fa <alltraps>

80106667 <vector240>:
.globl vector240
vector240:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $240
80106669:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010666e:	e9 87 f1 ff ff       	jmp    801057fa <alltraps>

80106673 <vector241>:
.globl vector241
vector241:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $241
80106675:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010667a:	e9 7b f1 ff ff       	jmp    801057fa <alltraps>

8010667f <vector242>:
.globl vector242
vector242:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $242
80106681:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106686:	e9 6f f1 ff ff       	jmp    801057fa <alltraps>

8010668b <vector243>:
.globl vector243
vector243:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $243
8010668d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106692:	e9 63 f1 ff ff       	jmp    801057fa <alltraps>

80106697 <vector244>:
.globl vector244
vector244:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $244
80106699:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010669e:	e9 57 f1 ff ff       	jmp    801057fa <alltraps>

801066a3 <vector245>:
.globl vector245
vector245:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $245
801066a5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801066aa:	e9 4b f1 ff ff       	jmp    801057fa <alltraps>

801066af <vector246>:
.globl vector246
vector246:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $246
801066b1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801066b6:	e9 3f f1 ff ff       	jmp    801057fa <alltraps>

801066bb <vector247>:
.globl vector247
vector247:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $247
801066bd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801066c2:	e9 33 f1 ff ff       	jmp    801057fa <alltraps>

801066c7 <vector248>:
.globl vector248
vector248:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $248
801066c9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801066ce:	e9 27 f1 ff ff       	jmp    801057fa <alltraps>

801066d3 <vector249>:
.globl vector249
vector249:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $249
801066d5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801066da:	e9 1b f1 ff ff       	jmp    801057fa <alltraps>

801066df <vector250>:
.globl vector250
vector250:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $250
801066e1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801066e6:	e9 0f f1 ff ff       	jmp    801057fa <alltraps>

801066eb <vector251>:
.globl vector251
vector251:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $251
801066ed:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801066f2:	e9 03 f1 ff ff       	jmp    801057fa <alltraps>

801066f7 <vector252>:
.globl vector252
vector252:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $252
801066f9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801066fe:	e9 f7 f0 ff ff       	jmp    801057fa <alltraps>

80106703 <vector253>:
.globl vector253
vector253:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $253
80106705:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010670a:	e9 eb f0 ff ff       	jmp    801057fa <alltraps>

8010670f <vector254>:
.globl vector254
vector254:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $254
80106711:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106716:	e9 df f0 ff ff       	jmp    801057fa <alltraps>

8010671b <vector255>:
.globl vector255
vector255:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $255
8010671d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106722:	e9 d3 f0 ff ff       	jmp    801057fa <alltraps>
80106727:	66 90                	xchg   %ax,%ax
80106729:	66 90                	xchg   %ax,%ax
8010672b:	66 90                	xchg   %ax,%ax
8010672d:	66 90                	xchg   %ax,%ax
8010672f:	90                   	nop

80106730 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106730:	55                   	push   %ebp
80106731:	89 e5                	mov    %esp,%ebp
80106733:	57                   	push   %edi
80106734:	56                   	push   %esi
80106735:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106736:	89 d3                	mov    %edx,%ebx
{
80106738:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
8010673a:	c1 eb 16             	shr    $0x16,%ebx
8010673d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106740:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106743:	8b 06                	mov    (%esi),%eax
80106745:	a8 01                	test   $0x1,%al
80106747:	74 27                	je     80106770 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106749:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010674e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106754:	c1 ef 0a             	shr    $0xa,%edi
}
80106757:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010675a:	89 fa                	mov    %edi,%edx
8010675c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106762:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106765:	5b                   	pop    %ebx
80106766:	5e                   	pop    %esi
80106767:	5f                   	pop    %edi
80106768:	5d                   	pop    %ebp
80106769:	c3                   	ret    
8010676a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106770:	85 c9                	test   %ecx,%ecx
80106772:	74 2c                	je     801067a0 <walkpgdir+0x70>
80106774:	e8 17 bd ff ff       	call   80102490 <kalloc>
80106779:	85 c0                	test   %eax,%eax
8010677b:	89 c3                	mov    %eax,%ebx
8010677d:	74 21                	je     801067a0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010677f:	83 ec 04             	sub    $0x4,%esp
80106782:	68 00 10 00 00       	push   $0x1000
80106787:	6a 00                	push   $0x0
80106789:	50                   	push   %eax
8010678a:	e8 11 dd ff ff       	call   801044a0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010678f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106795:	83 c4 10             	add    $0x10,%esp
80106798:	83 c8 07             	or     $0x7,%eax
8010679b:	89 06                	mov    %eax,(%esi)
8010679d:	eb b5                	jmp    80106754 <walkpgdir+0x24>
8010679f:	90                   	nop
}
801067a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801067a3:	31 c0                	xor    %eax,%eax
}
801067a5:	5b                   	pop    %ebx
801067a6:	5e                   	pop    %esi
801067a7:	5f                   	pop    %edi
801067a8:	5d                   	pop    %ebp
801067a9:	c3                   	ret    
801067aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801067b0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801067b0:	55                   	push   %ebp
801067b1:	89 e5                	mov    %esp,%ebp
801067b3:	57                   	push   %edi
801067b4:	56                   	push   %esi
801067b5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801067b6:	89 d3                	mov    %edx,%ebx
801067b8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801067be:	83 ec 1c             	sub    $0x1c,%esp
801067c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801067c4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801067c8:	8b 7d 08             	mov    0x8(%ebp),%edi
801067cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801067d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801067d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801067d6:	29 df                	sub    %ebx,%edi
801067d8:	83 c8 01             	or     $0x1,%eax
801067db:	89 45 dc             	mov    %eax,-0x24(%ebp)
801067de:	eb 15                	jmp    801067f5 <mappages+0x45>
    if(*pte & PTE_P)
801067e0:	f6 00 01             	testb  $0x1,(%eax)
801067e3:	75 45                	jne    8010682a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
801067e5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
801067e8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
801067eb:	89 30                	mov    %esi,(%eax)
    if(a == last)
801067ed:	74 31                	je     80106820 <mappages+0x70>
      break;
    a += PGSIZE;
801067ef:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801067f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067f8:	b9 01 00 00 00       	mov    $0x1,%ecx
801067fd:	89 da                	mov    %ebx,%edx
801067ff:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106802:	e8 29 ff ff ff       	call   80106730 <walkpgdir>
80106807:	85 c0                	test   %eax,%eax
80106809:	75 d5                	jne    801067e0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010680b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010680e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106813:	5b                   	pop    %ebx
80106814:	5e                   	pop    %esi
80106815:	5f                   	pop    %edi
80106816:	5d                   	pop    %ebp
80106817:	c3                   	ret    
80106818:	90                   	nop
80106819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106820:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106823:	31 c0                	xor    %eax,%eax
}
80106825:	5b                   	pop    %ebx
80106826:	5e                   	pop    %esi
80106827:	5f                   	pop    %edi
80106828:	5d                   	pop    %ebp
80106829:	c3                   	ret    
      panic("remap");
8010682a:	83 ec 0c             	sub    $0xc,%esp
8010682d:	68 80 7a 10 80       	push   $0x80107a80
80106832:	e8 39 9b ff ff       	call   80100370 <panic>
80106837:	89 f6                	mov    %esi,%esi
80106839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106840 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106840:	55                   	push   %ebp
80106841:	89 e5                	mov    %esp,%ebp
80106843:	57                   	push   %edi
80106844:	56                   	push   %esi
80106845:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106846:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010684c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
8010684e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106854:	83 ec 1c             	sub    $0x1c,%esp
80106857:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010685a:	39 d3                	cmp    %edx,%ebx
8010685c:	73 66                	jae    801068c4 <deallocuvm.part.0+0x84>
8010685e:	89 d6                	mov    %edx,%esi
80106860:	eb 3d                	jmp    8010689f <deallocuvm.part.0+0x5f>
80106862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106868:	8b 10                	mov    (%eax),%edx
8010686a:	f6 c2 01             	test   $0x1,%dl
8010686d:	74 26                	je     80106895 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010686f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106875:	74 58                	je     801068cf <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106877:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010687a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106880:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106883:	52                   	push   %edx
80106884:	e8 57 ba ff ff       	call   801022e0 <kfree>
      *pte = 0;
80106889:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010688c:	83 c4 10             	add    $0x10,%esp
8010688f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106895:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010689b:	39 f3                	cmp    %esi,%ebx
8010689d:	73 25                	jae    801068c4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010689f:	31 c9                	xor    %ecx,%ecx
801068a1:	89 da                	mov    %ebx,%edx
801068a3:	89 f8                	mov    %edi,%eax
801068a5:	e8 86 fe ff ff       	call   80106730 <walkpgdir>
    if(!pte)
801068aa:	85 c0                	test   %eax,%eax
801068ac:	75 ba                	jne    80106868 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801068ae:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801068b4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801068ba:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801068c0:	39 f3                	cmp    %esi,%ebx
801068c2:	72 db                	jb     8010689f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
801068c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801068c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068ca:	5b                   	pop    %ebx
801068cb:	5e                   	pop    %esi
801068cc:	5f                   	pop    %edi
801068cd:	5d                   	pop    %ebp
801068ce:	c3                   	ret    
        panic("kfree");
801068cf:	83 ec 0c             	sub    $0xc,%esp
801068d2:	68 86 73 10 80       	push   $0x80107386
801068d7:	e8 94 9a ff ff       	call   80100370 <panic>
801068dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801068e0 <seginit>:
{
801068e0:	55                   	push   %ebp
801068e1:	89 e5                	mov    %esp,%ebp
801068e3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801068e6:	e8 e5 ce ff ff       	call   801037d0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801068eb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801068f1:	31 c9                	xor    %ecx,%ecx
801068f3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801068f8:	66 89 90 58 28 11 80 	mov    %dx,-0x7feed7a8(%eax)
801068ff:	66 89 88 5a 28 11 80 	mov    %cx,-0x7feed7a6(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106906:	ba ff ff ff ff       	mov    $0xffffffff,%edx
8010690b:	31 c9                	xor    %ecx,%ecx
8010690d:	66 89 90 60 28 11 80 	mov    %dx,-0x7feed7a0(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106914:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106919:	66 89 88 62 28 11 80 	mov    %cx,-0x7feed79e(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106920:	31 c9                	xor    %ecx,%ecx
80106922:	66 89 90 68 28 11 80 	mov    %dx,-0x7feed798(%eax)
80106929:	66 89 88 6a 28 11 80 	mov    %cx,-0x7feed796(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106930:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106935:	31 c9                	xor    %ecx,%ecx
80106937:	66 89 90 70 28 11 80 	mov    %dx,-0x7feed790(%eax)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010693e:	c6 80 5c 28 11 80 00 	movb   $0x0,-0x7feed7a4(%eax)
  pd[0] = size-1;
80106945:	ba 2f 00 00 00       	mov    $0x2f,%edx
8010694a:	c6 80 5d 28 11 80 9a 	movb   $0x9a,-0x7feed7a3(%eax)
80106951:	c6 80 5e 28 11 80 cf 	movb   $0xcf,-0x7feed7a2(%eax)
80106958:	c6 80 5f 28 11 80 00 	movb   $0x0,-0x7feed7a1(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010695f:	c6 80 64 28 11 80 00 	movb   $0x0,-0x7feed79c(%eax)
80106966:	c6 80 65 28 11 80 92 	movb   $0x92,-0x7feed79b(%eax)
8010696d:	c6 80 66 28 11 80 cf 	movb   $0xcf,-0x7feed79a(%eax)
80106974:	c6 80 67 28 11 80 00 	movb   $0x0,-0x7feed799(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010697b:	c6 80 6c 28 11 80 00 	movb   $0x0,-0x7feed794(%eax)
80106982:	c6 80 6d 28 11 80 fa 	movb   $0xfa,-0x7feed793(%eax)
80106989:	c6 80 6e 28 11 80 cf 	movb   $0xcf,-0x7feed792(%eax)
80106990:	c6 80 6f 28 11 80 00 	movb   $0x0,-0x7feed791(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106997:	66 89 88 72 28 11 80 	mov    %cx,-0x7feed78e(%eax)
8010699e:	c6 80 74 28 11 80 00 	movb   $0x0,-0x7feed78c(%eax)
801069a5:	c6 80 75 28 11 80 f2 	movb   $0xf2,-0x7feed78b(%eax)
801069ac:	c6 80 76 28 11 80 cf 	movb   $0xcf,-0x7feed78a(%eax)
801069b3:	c6 80 77 28 11 80 00 	movb   $0x0,-0x7feed789(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
801069ba:	05 50 28 11 80       	add    $0x80112850,%eax
801069bf:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
801069c3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801069c7:	c1 e8 10             	shr    $0x10,%eax
801069ca:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801069ce:	8d 45 f2             	lea    -0xe(%ebp),%eax
801069d1:	0f 01 10             	lgdtl  (%eax)
}
801069d4:	c9                   	leave  
801069d5:	c3                   	ret    
801069d6:	8d 76 00             	lea    0x0(%esi),%esi
801069d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801069e0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801069e0:	a1 e4 6a 11 80       	mov    0x80116ae4,%eax
{
801069e5:	55                   	push   %ebp
801069e6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801069e8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801069ed:	0f 22 d8             	mov    %eax,%cr3
}
801069f0:	5d                   	pop    %ebp
801069f1:	c3                   	ret    
801069f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a00 <switchuvm>:
{
80106a00:	55                   	push   %ebp
80106a01:	89 e5                	mov    %esp,%ebp
80106a03:	57                   	push   %edi
80106a04:	56                   	push   %esi
80106a05:	53                   	push   %ebx
80106a06:	83 ec 1c             	sub    $0x1c,%esp
80106a09:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106a0c:	85 f6                	test   %esi,%esi
80106a0e:	0f 84 cd 00 00 00    	je     80106ae1 <switchuvm+0xe1>
  if(p->kstack == 0)
80106a14:	8b 46 08             	mov    0x8(%esi),%eax
80106a17:	85 c0                	test   %eax,%eax
80106a19:	0f 84 dc 00 00 00    	je     80106afb <switchuvm+0xfb>
  if(p->pgdir == 0)
80106a1f:	8b 7e 04             	mov    0x4(%esi),%edi
80106a22:	85 ff                	test   %edi,%edi
80106a24:	0f 84 c4 00 00 00    	je     80106aee <switchuvm+0xee>
  pushcli();
80106a2a:	e8 91 d8 ff ff       	call   801042c0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106a2f:	e8 1c cd ff ff       	call   80103750 <mycpu>
80106a34:	89 c3                	mov    %eax,%ebx
80106a36:	e8 15 cd ff ff       	call   80103750 <mycpu>
80106a3b:	89 c7                	mov    %eax,%edi
80106a3d:	e8 0e cd ff ff       	call   80103750 <mycpu>
80106a42:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106a45:	83 c7 08             	add    $0x8,%edi
80106a48:	e8 03 cd ff ff       	call   80103750 <mycpu>
80106a4d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106a50:	83 c0 08             	add    $0x8,%eax
80106a53:	ba 67 00 00 00       	mov    $0x67,%edx
80106a58:	c1 e8 18             	shr    $0x18,%eax
80106a5b:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80106a62:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106a69:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80106a70:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106a77:	83 c1 08             	add    $0x8,%ecx
80106a7a:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106a80:	c1 e9 10             	shr    $0x10,%ecx
80106a83:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106a89:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106a8e:	e8 bd cc ff ff       	call   80103750 <mycpu>
80106a93:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106a9a:	e8 b1 cc ff ff       	call   80103750 <mycpu>
80106a9f:	b9 10 00 00 00       	mov    $0x10,%ecx
80106aa4:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106aa8:	e8 a3 cc ff ff       	call   80103750 <mycpu>
80106aad:	8b 56 08             	mov    0x8(%esi),%edx
80106ab0:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106ab6:	89 48 0c             	mov    %ecx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106ab9:	e8 92 cc ff ff       	call   80103750 <mycpu>
80106abe:	66 89 58 6e          	mov    %bx,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106ac2:	b8 28 00 00 00       	mov    $0x28,%eax
80106ac7:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106aca:	8b 46 04             	mov    0x4(%esi),%eax
80106acd:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106ad2:	0f 22 d8             	mov    %eax,%cr3
}
80106ad5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ad8:	5b                   	pop    %ebx
80106ad9:	5e                   	pop    %esi
80106ada:	5f                   	pop    %edi
80106adb:	5d                   	pop    %ebp
  popcli();
80106adc:	e9 1f d8 ff ff       	jmp    80104300 <popcli>
    panic("switchuvm: no process");
80106ae1:	83 ec 0c             	sub    $0xc,%esp
80106ae4:	68 86 7a 10 80       	push   $0x80107a86
80106ae9:	e8 82 98 ff ff       	call   80100370 <panic>
    panic("switchuvm: no pgdir");
80106aee:	83 ec 0c             	sub    $0xc,%esp
80106af1:	68 b1 7a 10 80       	push   $0x80107ab1
80106af6:	e8 75 98 ff ff       	call   80100370 <panic>
    panic("switchuvm: no kstack");
80106afb:	83 ec 0c             	sub    $0xc,%esp
80106afe:	68 9c 7a 10 80       	push   $0x80107a9c
80106b03:	e8 68 98 ff ff       	call   80100370 <panic>
80106b08:	90                   	nop
80106b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106b10 <inituvm>:
{
80106b10:	55                   	push   %ebp
80106b11:	89 e5                	mov    %esp,%ebp
80106b13:	57                   	push   %edi
80106b14:	56                   	push   %esi
80106b15:	53                   	push   %ebx
80106b16:	83 ec 1c             	sub    $0x1c,%esp
80106b19:	8b 75 10             	mov    0x10(%ebp),%esi
80106b1c:	8b 45 08             	mov    0x8(%ebp),%eax
80106b1f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106b22:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106b28:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106b2b:	77 49                	ja     80106b76 <inituvm+0x66>
  mem = kalloc();
80106b2d:	e8 5e b9 ff ff       	call   80102490 <kalloc>
  memset(mem, 0, PGSIZE);
80106b32:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106b35:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106b37:	68 00 10 00 00       	push   $0x1000
80106b3c:	6a 00                	push   $0x0
80106b3e:	50                   	push   %eax
80106b3f:	e8 5c d9 ff ff       	call   801044a0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106b44:	58                   	pop    %eax
80106b45:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106b4b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106b50:	5a                   	pop    %edx
80106b51:	6a 06                	push   $0x6
80106b53:	50                   	push   %eax
80106b54:	31 d2                	xor    %edx,%edx
80106b56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b59:	e8 52 fc ff ff       	call   801067b0 <mappages>
  memmove(mem, init, sz);
80106b5e:	89 75 10             	mov    %esi,0x10(%ebp)
80106b61:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106b64:	83 c4 10             	add    $0x10,%esp
80106b67:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106b6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b6d:	5b                   	pop    %ebx
80106b6e:	5e                   	pop    %esi
80106b6f:	5f                   	pop    %edi
80106b70:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106b71:	e9 da d9 ff ff       	jmp    80104550 <memmove>
    panic("inituvm: more than a page");
80106b76:	83 ec 0c             	sub    $0xc,%esp
80106b79:	68 c5 7a 10 80       	push   $0x80107ac5
80106b7e:	e8 ed 97 ff ff       	call   80100370 <panic>
80106b83:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b90 <loaduvm>:
{
80106b90:	55                   	push   %ebp
80106b91:	89 e5                	mov    %esp,%ebp
80106b93:	57                   	push   %edi
80106b94:	56                   	push   %esi
80106b95:	53                   	push   %ebx
80106b96:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106b99:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106ba0:	0f 85 91 00 00 00    	jne    80106c37 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106ba6:	8b 75 18             	mov    0x18(%ebp),%esi
80106ba9:	31 db                	xor    %ebx,%ebx
80106bab:	85 f6                	test   %esi,%esi
80106bad:	75 1a                	jne    80106bc9 <loaduvm+0x39>
80106baf:	eb 6f                	jmp    80106c20 <loaduvm+0x90>
80106bb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bb8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bbe:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106bc4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106bc7:	76 57                	jbe    80106c20 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106bc9:	8b 55 0c             	mov    0xc(%ebp),%edx
80106bcc:	8b 45 08             	mov    0x8(%ebp),%eax
80106bcf:	31 c9                	xor    %ecx,%ecx
80106bd1:	01 da                	add    %ebx,%edx
80106bd3:	e8 58 fb ff ff       	call   80106730 <walkpgdir>
80106bd8:	85 c0                	test   %eax,%eax
80106bda:	74 4e                	je     80106c2a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106bdc:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106bde:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80106be1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106be6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106beb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106bf1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106bf4:	01 d9                	add    %ebx,%ecx
80106bf6:	05 00 00 00 80       	add    $0x80000000,%eax
80106bfb:	57                   	push   %edi
80106bfc:	51                   	push   %ecx
80106bfd:	50                   	push   %eax
80106bfe:	ff 75 10             	pushl  0x10(%ebp)
80106c01:	e8 4a ad ff ff       	call   80101950 <readi>
80106c06:	83 c4 10             	add    $0x10,%esp
80106c09:	39 c7                	cmp    %eax,%edi
80106c0b:	74 ab                	je     80106bb8 <loaduvm+0x28>
}
80106c0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106c10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c15:	5b                   	pop    %ebx
80106c16:	5e                   	pop    %esi
80106c17:	5f                   	pop    %edi
80106c18:	5d                   	pop    %ebp
80106c19:	c3                   	ret    
80106c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106c23:	31 c0                	xor    %eax,%eax
}
80106c25:	5b                   	pop    %ebx
80106c26:	5e                   	pop    %esi
80106c27:	5f                   	pop    %edi
80106c28:	5d                   	pop    %ebp
80106c29:	c3                   	ret    
      panic("loaduvm: address should exist");
80106c2a:	83 ec 0c             	sub    $0xc,%esp
80106c2d:	68 df 7a 10 80       	push   $0x80107adf
80106c32:	e8 39 97 ff ff       	call   80100370 <panic>
    panic("loaduvm: addr must be page aligned");
80106c37:	83 ec 0c             	sub    $0xc,%esp
80106c3a:	68 80 7b 10 80       	push   $0x80107b80
80106c3f:	e8 2c 97 ff ff       	call   80100370 <panic>
80106c44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106c50 <allocuvm>:
{
80106c50:	55                   	push   %ebp
80106c51:	89 e5                	mov    %esp,%ebp
80106c53:	57                   	push   %edi
80106c54:	56                   	push   %esi
80106c55:	53                   	push   %ebx
80106c56:	83 ec 0c             	sub    $0xc,%esp
80106c59:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
80106c5c:	85 ff                	test   %edi,%edi
80106c5e:	78 7b                	js     80106cdb <allocuvm+0x8b>
  if(newsz < oldsz)
80106c60:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106c63:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106c66:	72 75                	jb     80106cdd <allocuvm+0x8d>
  a = PGROUNDUP(oldsz);
80106c68:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106c6e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106c74:	39 df                	cmp    %ebx,%edi
80106c76:	77 43                	ja     80106cbb <allocuvm+0x6b>
80106c78:	eb 6e                	jmp    80106ce8 <allocuvm+0x98>
80106c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106c80:	83 ec 04             	sub    $0x4,%esp
80106c83:	68 00 10 00 00       	push   $0x1000
80106c88:	6a 00                	push   $0x0
80106c8a:	50                   	push   %eax
80106c8b:	e8 10 d8 ff ff       	call   801044a0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106c90:	58                   	pop    %eax
80106c91:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106c97:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106c9c:	5a                   	pop    %edx
80106c9d:	6a 06                	push   $0x6
80106c9f:	50                   	push   %eax
80106ca0:	89 da                	mov    %ebx,%edx
80106ca2:	8b 45 08             	mov    0x8(%ebp),%eax
80106ca5:	e8 06 fb ff ff       	call   801067b0 <mappages>
80106caa:	83 c4 10             	add    $0x10,%esp
80106cad:	85 c0                	test   %eax,%eax
80106caf:	78 47                	js     80106cf8 <allocuvm+0xa8>
  for(; a < newsz; a += PGSIZE){
80106cb1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106cb7:	39 df                	cmp    %ebx,%edi
80106cb9:	76 2d                	jbe    80106ce8 <allocuvm+0x98>
    mem = kalloc();
80106cbb:	e8 d0 b7 ff ff       	call   80102490 <kalloc>
    if(mem == 0){
80106cc0:	85 c0                	test   %eax,%eax
    mem = kalloc();
80106cc2:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106cc4:	75 ba                	jne    80106c80 <allocuvm+0x30>
      cprintf("allocuvm out of memory\n");
80106cc6:	83 ec 0c             	sub    $0xc,%esp
80106cc9:	68 fd 7a 10 80       	push   $0x80107afd
80106cce:	e8 8d 99 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80106cd3:	83 c4 10             	add    $0x10,%esp
80106cd6:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106cd9:	77 4f                	ja     80106d2a <allocuvm+0xda>
      return 0;
80106cdb:	31 c0                	xor    %eax,%eax
}
80106cdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ce0:	5b                   	pop    %ebx
80106ce1:	5e                   	pop    %esi
80106ce2:	5f                   	pop    %edi
80106ce3:	5d                   	pop    %ebp
80106ce4:	c3                   	ret    
80106ce5:	8d 76 00             	lea    0x0(%esi),%esi
80106ce8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  for(; a < newsz; a += PGSIZE){
80106ceb:	89 f8                	mov    %edi,%eax
}
80106ced:	5b                   	pop    %ebx
80106cee:	5e                   	pop    %esi
80106cef:	5f                   	pop    %edi
80106cf0:	5d                   	pop    %ebp
80106cf1:	c3                   	ret    
80106cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106cf8:	83 ec 0c             	sub    $0xc,%esp
80106cfb:	68 15 7b 10 80       	push   $0x80107b15
80106d00:	e8 5b 99 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80106d05:	83 c4 10             	add    $0x10,%esp
80106d08:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106d0b:	76 0d                	jbe    80106d1a <allocuvm+0xca>
80106d0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106d10:	8b 45 08             	mov    0x8(%ebp),%eax
80106d13:	89 fa                	mov    %edi,%edx
80106d15:	e8 26 fb ff ff       	call   80106840 <deallocuvm.part.0>
      kfree(mem);
80106d1a:	83 ec 0c             	sub    $0xc,%esp
80106d1d:	56                   	push   %esi
80106d1e:	e8 bd b5 ff ff       	call   801022e0 <kfree>
      return 0;
80106d23:	83 c4 10             	add    $0x10,%esp
80106d26:	31 c0                	xor    %eax,%eax
80106d28:	eb b3                	jmp    80106cdd <allocuvm+0x8d>
80106d2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106d2d:	8b 45 08             	mov    0x8(%ebp),%eax
80106d30:	89 fa                	mov    %edi,%edx
80106d32:	e8 09 fb ff ff       	call   80106840 <deallocuvm.part.0>
      return 0;
80106d37:	31 c0                	xor    %eax,%eax
80106d39:	eb a2                	jmp    80106cdd <allocuvm+0x8d>
80106d3b:	90                   	nop
80106d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106d40 <deallocuvm>:
{
80106d40:	55                   	push   %ebp
80106d41:	89 e5                	mov    %esp,%ebp
80106d43:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d46:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106d49:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106d4c:	39 d1                	cmp    %edx,%ecx
80106d4e:	73 10                	jae    80106d60 <deallocuvm+0x20>
}
80106d50:	5d                   	pop    %ebp
80106d51:	e9 ea fa ff ff       	jmp    80106840 <deallocuvm.part.0>
80106d56:	8d 76 00             	lea    0x0(%esi),%esi
80106d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106d60:	89 d0                	mov    %edx,%eax
80106d62:	5d                   	pop    %ebp
80106d63:	c3                   	ret    
80106d64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106d70 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106d70:	55                   	push   %ebp
80106d71:	89 e5                	mov    %esp,%ebp
80106d73:	57                   	push   %edi
80106d74:	56                   	push   %esi
80106d75:	53                   	push   %ebx
80106d76:	83 ec 0c             	sub    $0xc,%esp
80106d79:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106d7c:	85 f6                	test   %esi,%esi
80106d7e:	74 59                	je     80106dd9 <freevm+0x69>
80106d80:	31 c9                	xor    %ecx,%ecx
80106d82:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106d87:	89 f0                	mov    %esi,%eax
80106d89:	e8 b2 fa ff ff       	call   80106840 <deallocuvm.part.0>
80106d8e:	89 f3                	mov    %esi,%ebx
80106d90:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106d96:	eb 0f                	jmp    80106da7 <freevm+0x37>
80106d98:	90                   	nop
80106d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106da0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106da3:	39 fb                	cmp    %edi,%ebx
80106da5:	74 23                	je     80106dca <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106da7:	8b 03                	mov    (%ebx),%eax
80106da9:	a8 01                	test   $0x1,%al
80106dab:	74 f3                	je     80106da0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106dad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106db2:	83 ec 0c             	sub    $0xc,%esp
80106db5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106db8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106dbd:	50                   	push   %eax
80106dbe:	e8 1d b5 ff ff       	call   801022e0 <kfree>
80106dc3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106dc6:	39 fb                	cmp    %edi,%ebx
80106dc8:	75 dd                	jne    80106da7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106dca:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106dcd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106dd0:	5b                   	pop    %ebx
80106dd1:	5e                   	pop    %esi
80106dd2:	5f                   	pop    %edi
80106dd3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106dd4:	e9 07 b5 ff ff       	jmp    801022e0 <kfree>
    panic("freevm: no pgdir");
80106dd9:	83 ec 0c             	sub    $0xc,%esp
80106ddc:	68 31 7b 10 80       	push   $0x80107b31
80106de1:	e8 8a 95 ff ff       	call   80100370 <panic>
80106de6:	8d 76 00             	lea    0x0(%esi),%esi
80106de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106df0 <setupkvm>:
{
80106df0:	55                   	push   %ebp
80106df1:	89 e5                	mov    %esp,%ebp
80106df3:	56                   	push   %esi
80106df4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106df5:	e8 96 b6 ff ff       	call   80102490 <kalloc>
80106dfa:	85 c0                	test   %eax,%eax
80106dfc:	89 c6                	mov    %eax,%esi
80106dfe:	74 42                	je     80106e42 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80106e00:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106e03:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106e08:	68 00 10 00 00       	push   $0x1000
80106e0d:	6a 00                	push   $0x0
80106e0f:	50                   	push   %eax
80106e10:	e8 8b d6 ff ff       	call   801044a0 <memset>
80106e15:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106e18:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106e1b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106e1e:	83 ec 08             	sub    $0x8,%esp
80106e21:	8b 13                	mov    (%ebx),%edx
80106e23:	ff 73 0c             	pushl  0xc(%ebx)
80106e26:	50                   	push   %eax
80106e27:	29 c1                	sub    %eax,%ecx
80106e29:	89 f0                	mov    %esi,%eax
80106e2b:	e8 80 f9 ff ff       	call   801067b0 <mappages>
80106e30:	83 c4 10             	add    $0x10,%esp
80106e33:	85 c0                	test   %eax,%eax
80106e35:	78 19                	js     80106e50 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106e37:	83 c3 10             	add    $0x10,%ebx
80106e3a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106e40:	75 d6                	jne    80106e18 <setupkvm+0x28>
}
80106e42:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106e45:	89 f0                	mov    %esi,%eax
80106e47:	5b                   	pop    %ebx
80106e48:	5e                   	pop    %esi
80106e49:	5d                   	pop    %ebp
80106e4a:	c3                   	ret    
80106e4b:	90                   	nop
80106e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80106e50:	83 ec 0c             	sub    $0xc,%esp
80106e53:	56                   	push   %esi
      return 0;
80106e54:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80106e56:	e8 15 ff ff ff       	call   80106d70 <freevm>
      return 0;
80106e5b:	83 c4 10             	add    $0x10,%esp
}
80106e5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106e61:	89 f0                	mov    %esi,%eax
80106e63:	5b                   	pop    %ebx
80106e64:	5e                   	pop    %esi
80106e65:	5d                   	pop    %ebp
80106e66:	c3                   	ret    
80106e67:	89 f6                	mov    %esi,%esi
80106e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e70 <kvmalloc>:
{
80106e70:	55                   	push   %ebp
80106e71:	89 e5                	mov    %esp,%ebp
80106e73:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106e76:	e8 75 ff ff ff       	call   80106df0 <setupkvm>
80106e7b:	a3 e4 6a 11 80       	mov    %eax,0x80116ae4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106e80:	05 00 00 00 80       	add    $0x80000000,%eax
80106e85:	0f 22 d8             	mov    %eax,%cr3
}
80106e88:	c9                   	leave  
80106e89:	c3                   	ret    
80106e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e90 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106e90:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106e91:	31 c9                	xor    %ecx,%ecx
{
80106e93:	89 e5                	mov    %esp,%ebp
80106e95:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106e98:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e9b:	8b 45 08             	mov    0x8(%ebp),%eax
80106e9e:	e8 8d f8 ff ff       	call   80106730 <walkpgdir>
  if(pte == 0)
80106ea3:	85 c0                	test   %eax,%eax
80106ea5:	74 05                	je     80106eac <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106ea7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106eaa:	c9                   	leave  
80106eab:	c3                   	ret    
    panic("clearpteu");
80106eac:	83 ec 0c             	sub    $0xc,%esp
80106eaf:	68 42 7b 10 80       	push   $0x80107b42
80106eb4:	e8 b7 94 ff ff       	call   80100370 <panic>
80106eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ec0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106ec0:	55                   	push   %ebp
80106ec1:	89 e5                	mov    %esp,%ebp
80106ec3:	57                   	push   %edi
80106ec4:	56                   	push   %esi
80106ec5:	53                   	push   %ebx
80106ec6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106ec9:	e8 22 ff ff ff       	call   80106df0 <setupkvm>
80106ece:	85 c0                	test   %eax,%eax
80106ed0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106ed3:	0f 84 9f 00 00 00    	je     80106f78 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106ed9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106edc:	85 c9                	test   %ecx,%ecx
80106ede:	0f 84 94 00 00 00    	je     80106f78 <copyuvm+0xb8>
80106ee4:	31 ff                	xor    %edi,%edi
80106ee6:	eb 4a                	jmp    80106f32 <copyuvm+0x72>
80106ee8:	90                   	nop
80106ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106ef0:	83 ec 04             	sub    $0x4,%esp
80106ef3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80106ef9:	68 00 10 00 00       	push   $0x1000
80106efe:	53                   	push   %ebx
80106eff:	50                   	push   %eax
80106f00:	e8 4b d6 ff ff       	call   80104550 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106f05:	58                   	pop    %eax
80106f06:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106f0c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f11:	5a                   	pop    %edx
80106f12:	ff 75 e4             	pushl  -0x1c(%ebp)
80106f15:	50                   	push   %eax
80106f16:	89 fa                	mov    %edi,%edx
80106f18:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f1b:	e8 90 f8 ff ff       	call   801067b0 <mappages>
80106f20:	83 c4 10             	add    $0x10,%esp
80106f23:	85 c0                	test   %eax,%eax
80106f25:	78 61                	js     80106f88 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106f27:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106f2d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80106f30:	76 46                	jbe    80106f78 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106f32:	8b 45 08             	mov    0x8(%ebp),%eax
80106f35:	31 c9                	xor    %ecx,%ecx
80106f37:	89 fa                	mov    %edi,%edx
80106f39:	e8 f2 f7 ff ff       	call   80106730 <walkpgdir>
80106f3e:	85 c0                	test   %eax,%eax
80106f40:	74 61                	je     80106fa3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80106f42:	8b 00                	mov    (%eax),%eax
80106f44:	a8 01                	test   $0x1,%al
80106f46:	74 4e                	je     80106f96 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80106f48:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
80106f4a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
80106f4f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80106f55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80106f58:	e8 33 b5 ff ff       	call   80102490 <kalloc>
80106f5d:	85 c0                	test   %eax,%eax
80106f5f:	89 c6                	mov    %eax,%esi
80106f61:	75 8d                	jne    80106ef0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80106f63:	83 ec 0c             	sub    $0xc,%esp
80106f66:	ff 75 e0             	pushl  -0x20(%ebp)
80106f69:	e8 02 fe ff ff       	call   80106d70 <freevm>
  return 0;
80106f6e:	83 c4 10             	add    $0x10,%esp
80106f71:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80106f78:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f7e:	5b                   	pop    %ebx
80106f7f:	5e                   	pop    %esi
80106f80:	5f                   	pop    %edi
80106f81:	5d                   	pop    %ebp
80106f82:	c3                   	ret    
80106f83:	90                   	nop
80106f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80106f88:	83 ec 0c             	sub    $0xc,%esp
80106f8b:	56                   	push   %esi
80106f8c:	e8 4f b3 ff ff       	call   801022e0 <kfree>
      goto bad;
80106f91:	83 c4 10             	add    $0x10,%esp
80106f94:	eb cd                	jmp    80106f63 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80106f96:	83 ec 0c             	sub    $0xc,%esp
80106f99:	68 66 7b 10 80       	push   $0x80107b66
80106f9e:	e8 cd 93 ff ff       	call   80100370 <panic>
      panic("copyuvm: pte should exist");
80106fa3:	83 ec 0c             	sub    $0xc,%esp
80106fa6:	68 4c 7b 10 80       	push   $0x80107b4c
80106fab:	e8 c0 93 ff ff       	call   80100370 <panic>

80106fb0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106fb0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106fb1:	31 c9                	xor    %ecx,%ecx
{
80106fb3:	89 e5                	mov    %esp,%ebp
80106fb5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106fb8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106fbb:	8b 45 08             	mov    0x8(%ebp),%eax
80106fbe:	e8 6d f7 ff ff       	call   80106730 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106fc3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80106fc5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80106fc6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106fc8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80106fcd:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106fd0:	05 00 00 00 80       	add    $0x80000000,%eax
80106fd5:	83 fa 05             	cmp    $0x5,%edx
80106fd8:	ba 00 00 00 00       	mov    $0x0,%edx
80106fdd:	0f 45 c2             	cmovne %edx,%eax
}
80106fe0:	c3                   	ret    
80106fe1:	eb 0d                	jmp    80106ff0 <copyout>
80106fe3:	90                   	nop
80106fe4:	90                   	nop
80106fe5:	90                   	nop
80106fe6:	90                   	nop
80106fe7:	90                   	nop
80106fe8:	90                   	nop
80106fe9:	90                   	nop
80106fea:	90                   	nop
80106feb:	90                   	nop
80106fec:	90                   	nop
80106fed:	90                   	nop
80106fee:	90                   	nop
80106fef:	90                   	nop

80106ff0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106ff0:	55                   	push   %ebp
80106ff1:	89 e5                	mov    %esp,%ebp
80106ff3:	57                   	push   %edi
80106ff4:	56                   	push   %esi
80106ff5:	53                   	push   %ebx
80106ff6:	83 ec 1c             	sub    $0x1c,%esp
80106ff9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106ffc:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106fff:	8b 7d 10             	mov    0x10(%ebp),%edi
80107002:	85 db                	test   %ebx,%ebx
80107004:	75 40                	jne    80107046 <copyout+0x56>
80107006:	eb 70                	jmp    80107078 <copyout+0x88>
80107008:	90                   	nop
80107009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107010:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107013:	89 f1                	mov    %esi,%ecx
80107015:	29 d1                	sub    %edx,%ecx
80107017:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010701d:	39 d9                	cmp    %ebx,%ecx
8010701f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107022:	29 f2                	sub    %esi,%edx
80107024:	83 ec 04             	sub    $0x4,%esp
80107027:	01 d0                	add    %edx,%eax
80107029:	51                   	push   %ecx
8010702a:	57                   	push   %edi
8010702b:	50                   	push   %eax
8010702c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010702f:	e8 1c d5 ff ff       	call   80104550 <memmove>
    len -= n;
    buf += n;
80107034:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107037:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010703a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107040:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107042:	29 cb                	sub    %ecx,%ebx
80107044:	74 32                	je     80107078 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107046:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107048:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010704b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010704e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107054:	56                   	push   %esi
80107055:	ff 75 08             	pushl  0x8(%ebp)
80107058:	e8 53 ff ff ff       	call   80106fb0 <uva2ka>
    if(pa0 == 0)
8010705d:	83 c4 10             	add    $0x10,%esp
80107060:	85 c0                	test   %eax,%eax
80107062:	75 ac                	jne    80107010 <copyout+0x20>
  }
  return 0;
}
80107064:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107067:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010706c:	5b                   	pop    %ebx
8010706d:	5e                   	pop    %esi
8010706e:	5f                   	pop    %edi
8010706f:	5d                   	pop    %ebp
80107070:	c3                   	ret    
80107071:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107078:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010707b:	31 c0                	xor    %eax,%eax
}
8010707d:	5b                   	pop    %ebx
8010707e:	5e                   	pop    %esi
8010707f:	5f                   	pop    %edi
80107080:	5d                   	pop    %ebp
80107081:	c3                   	ret    
80107082:	66 90                	xchg   %ax,%ax
80107084:	66 90                	xchg   %ax,%ax
80107086:	66 90                	xchg   %ax,%ax
80107088:	66 90                	xchg   %ax,%ax
8010708a:	66 90                	xchg   %ax,%ax
8010708c:	66 90                	xchg   %ax,%ax
8010708e:	66 90                	xchg   %ax,%ax

80107090 <addProcessToContainer>:
//     }
//     release(&ptable_container.lock);
//   }
// }

void addProcessToContainer(int pid, int containerID){
80107090:	55                   	push   %ebp
  struct container *con;
  for(con = ctable.container; con < &ctable.container[NCONT]; con++){
80107091:	b8 b4 2d 11 80       	mov    $0x80112db4,%eax
void addProcessToContainer(int pid, int containerID){
80107096:	89 e5                	mov    %esp,%ebp
80107098:	8b 55 0c             	mov    0xc(%ebp),%edx
8010709b:	90                   	nop
8010709c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(con->containerID == containerID){
801070a0:	39 10                	cmp    %edx,(%eax)
801070a2:	74 14                	je     801070b8 <addProcessToContainer+0x28>
  for(con = ctable.container; con < &ctable.container[NCONT]; con++){
801070a4:	05 08 01 00 00       	add    $0x108,%eax
801070a9:	3d 54 42 11 80       	cmp    $0x80114254,%eax
801070ae:	72 f0                	jb     801070a0 <addProcessToContainer+0x10>
      //This is the container ID, add this process
      con->presentProc[pid] = 1; // Added the process
      break;
    }
  }
}
801070b0:	5d                   	pop    %ebp
801070b1:	c3                   	ret    
801070b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      con->presentProc[pid] = 1; // Added the process
801070b8:	8b 55 08             	mov    0x8(%ebp),%edx
801070bb:	c7 44 90 04 01 00 00 	movl   $0x1,0x4(%eax,%edx,4)
801070c2:	00 
}
801070c3:	5d                   	pop    %ebp
801070c4:	c3                   	ret    
801070c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801070c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801070d0 <removeProcessFromContainer>:

void removeProcessFromContainer(int pid, int containerID){
801070d0:	55                   	push   %ebp
  struct container *con;
  for(con = ctable.container; con < &ctable.container[NCONT]; con++){
801070d1:	b8 b4 2d 11 80       	mov    $0x80112db4,%eax
void removeProcessFromContainer(int pid, int containerID){
801070d6:	89 e5                	mov    %esp,%ebp
801070d8:	8b 55 0c             	mov    0xc(%ebp),%edx
801070db:	90                   	nop
801070dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(con->containerID == containerID){
801070e0:	39 10                	cmp    %edx,(%eax)
801070e2:	74 14                	je     801070f8 <removeProcessFromContainer+0x28>
  for(con = ctable.container; con < &ctable.container[NCONT]; con++){
801070e4:	05 08 01 00 00       	add    $0x108,%eax
801070e9:	3d 54 42 11 80       	cmp    $0x80114254,%eax
801070ee:	72 f0                	jb     801070e0 <removeProcessFromContainer+0x10>
      //This is the container ID, remove this process
      con->presentProc[pid] = 0; // Remove the process
      break;
    }
  }
}
801070f0:	5d                   	pop    %ebp
801070f1:	c3                   	ret    
801070f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      con->presentProc[pid] = 0; // Remove the process
801070f8:	8b 55 08             	mov    0x8(%ebp),%edx
801070fb:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
80107102:	00 
}
80107103:	5d                   	pop    %ebp
80107104:	c3                   	ret    
