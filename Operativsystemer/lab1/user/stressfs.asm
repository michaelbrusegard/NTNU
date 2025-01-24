
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dc010113          	addi	sp,sp,-576
   4:	22113c23          	sd	ra,568(sp)
   8:	22813823          	sd	s0,560(sp)
   c:	0480                	addi	s0,sp,576
   e:	87aa                	mv	a5,a0
  10:	dcb43023          	sd	a1,-576(s0)
  14:	dcf42623          	sw	a5,-564(s0)
  int fd, i;
  char path[] = "stressfs0";
  18:	00001797          	auipc	a5,0x1
  1c:	ec878793          	addi	a5,a5,-312 # ee0 <malloc+0x174>
  20:	6398                	ld	a4,0(a5)
  22:	fce43c23          	sd	a4,-40(s0)
  26:	0087d783          	lhu	a5,8(a5)
  2a:	fef41023          	sh	a5,-32(s0)
  char data[512];

  printf("stressfs starting\n");
  2e:	00001517          	auipc	a0,0x1
  32:	e8250513          	addi	a0,a0,-382 # eb0 <malloc+0x144>
  36:	00001097          	auipc	ra,0x1
  3a:	b42080e7          	jalr	-1214(ra) # b78 <printf>
  memset(data, 'a', sizeof(data));
  3e:	dd840793          	addi	a5,s0,-552
  42:	20000613          	li	a2,512
  46:	06100593          	li	a1,97
  4a:	853e                	mv	a0,a5
  4c:	00000097          	auipc	ra,0x0
  50:	24a080e7          	jalr	586(ra) # 296 <memset>

  for(i = 0; i < 4; i++)
  54:	fe042623          	sw	zero,-20(s0)
  58:	a829                	j	72 <main+0x72>
    if(fork() > 0)
  5a:	00000097          	auipc	ra,0x0
  5e:	5f2080e7          	jalr	1522(ra) # 64c <fork>
  62:	87aa                	mv	a5,a0
  64:	00f04f63          	bgtz	a5,82 <main+0x82>
  for(i = 0; i < 4; i++)
  68:	fec42783          	lw	a5,-20(s0)
  6c:	2785                	addiw	a5,a5,1
  6e:	fef42623          	sw	a5,-20(s0)
  72:	fec42783          	lw	a5,-20(s0)
  76:	0007871b          	sext.w	a4,a5
  7a:	478d                	li	a5,3
  7c:	fce7dfe3          	bge	a5,a4,5a <main+0x5a>
  80:	a011                	j	84 <main+0x84>
      break;
  82:	0001                	nop

  printf("write %d\n", i);
  84:	fec42783          	lw	a5,-20(s0)
  88:	85be                	mv	a1,a5
  8a:	00001517          	auipc	a0,0x1
  8e:	e3e50513          	addi	a0,a0,-450 # ec8 <malloc+0x15c>
  92:	00001097          	auipc	ra,0x1
  96:	ae6080e7          	jalr	-1306(ra) # b78 <printf>

  path[8] += i;
  9a:	fe044703          	lbu	a4,-32(s0)
  9e:	fec42783          	lw	a5,-20(s0)
  a2:	0ff7f793          	zext.b	a5,a5
  a6:	9fb9                	addw	a5,a5,a4
  a8:	0ff7f793          	zext.b	a5,a5
  ac:	fef40023          	sb	a5,-32(s0)
  fd = open(path, O_CREATE | O_RDWR);
  b0:	fd840793          	addi	a5,s0,-40
  b4:	20200593          	li	a1,514
  b8:	853e                	mv	a0,a5
  ba:	00000097          	auipc	ra,0x0
  be:	5da080e7          	jalr	1498(ra) # 694 <open>
  c2:	87aa                	mv	a5,a0
  c4:	fef42423          	sw	a5,-24(s0)
  for(i = 0; i < 20; i++)
  c8:	fe042623          	sw	zero,-20(s0)
  cc:	a015                	j	f0 <main+0xf0>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  ce:	dd840713          	addi	a4,s0,-552
  d2:	fe842783          	lw	a5,-24(s0)
  d6:	20000613          	li	a2,512
  da:	85ba                	mv	a1,a4
  dc:	853e                	mv	a0,a5
  de:	00000097          	auipc	ra,0x0
  e2:	596080e7          	jalr	1430(ra) # 674 <write>
  for(i = 0; i < 20; i++)
  e6:	fec42783          	lw	a5,-20(s0)
  ea:	2785                	addiw	a5,a5,1
  ec:	fef42623          	sw	a5,-20(s0)
  f0:	fec42783          	lw	a5,-20(s0)
  f4:	0007871b          	sext.w	a4,a5
  f8:	47cd                	li	a5,19
  fa:	fce7dae3          	bge	a5,a4,ce <main+0xce>
  close(fd);
  fe:	fe842783          	lw	a5,-24(s0)
 102:	853e                	mv	a0,a5
 104:	00000097          	auipc	ra,0x0
 108:	578080e7          	jalr	1400(ra) # 67c <close>

  printf("read\n");
 10c:	00001517          	auipc	a0,0x1
 110:	dcc50513          	addi	a0,a0,-564 # ed8 <malloc+0x16c>
 114:	00001097          	auipc	ra,0x1
 118:	a64080e7          	jalr	-1436(ra) # b78 <printf>

  fd = open(path, O_RDONLY);
 11c:	fd840793          	addi	a5,s0,-40
 120:	4581                	li	a1,0
 122:	853e                	mv	a0,a5
 124:	00000097          	auipc	ra,0x0
 128:	570080e7          	jalr	1392(ra) # 694 <open>
 12c:	87aa                	mv	a5,a0
 12e:	fef42423          	sw	a5,-24(s0)
  for (i = 0; i < 20; i++)
 132:	fe042623          	sw	zero,-20(s0)
 136:	a015                	j	15a <main+0x15a>
    read(fd, data, sizeof(data));
 138:	dd840713          	addi	a4,s0,-552
 13c:	fe842783          	lw	a5,-24(s0)
 140:	20000613          	li	a2,512
 144:	85ba                	mv	a1,a4
 146:	853e                	mv	a0,a5
 148:	00000097          	auipc	ra,0x0
 14c:	524080e7          	jalr	1316(ra) # 66c <read>
  for (i = 0; i < 20; i++)
 150:	fec42783          	lw	a5,-20(s0)
 154:	2785                	addiw	a5,a5,1
 156:	fef42623          	sw	a5,-20(s0)
 15a:	fec42783          	lw	a5,-20(s0)
 15e:	0007871b          	sext.w	a4,a5
 162:	47cd                	li	a5,19
 164:	fce7dae3          	bge	a5,a4,138 <main+0x138>
  close(fd);
 168:	fe842783          	lw	a5,-24(s0)
 16c:	853e                	mv	a0,a5
 16e:	00000097          	auipc	ra,0x0
 172:	50e080e7          	jalr	1294(ra) # 67c <close>

  wait(0);
 176:	4501                	li	a0,0
 178:	00000097          	auipc	ra,0x0
 17c:	4e4080e7          	jalr	1252(ra) # 65c <wait>

  exit(0);
 180:	4501                	li	a0,0
 182:	00000097          	auipc	ra,0x0
 186:	4d2080e7          	jalr	1234(ra) # 654 <exit>

000000000000018a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 18a:	1141                	addi	sp,sp,-16
 18c:	e406                	sd	ra,8(sp)
 18e:	e022                	sd	s0,0(sp)
 190:	0800                	addi	s0,sp,16
  extern int main();
  main();
 192:	00000097          	auipc	ra,0x0
 196:	e6e080e7          	jalr	-402(ra) # 0 <main>
  exit(0);
 19a:	4501                	li	a0,0
 19c:	00000097          	auipc	ra,0x0
 1a0:	4b8080e7          	jalr	1208(ra) # 654 <exit>

00000000000001a4 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1a4:	7179                	addi	sp,sp,-48
 1a6:	f406                	sd	ra,40(sp)
 1a8:	f022                	sd	s0,32(sp)
 1aa:	1800                	addi	s0,sp,48
 1ac:	fca43c23          	sd	a0,-40(s0)
 1b0:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
 1b4:	fd843783          	ld	a5,-40(s0)
 1b8:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
 1bc:	0001                	nop
 1be:	fd043703          	ld	a4,-48(s0)
 1c2:	00170793          	addi	a5,a4,1
 1c6:	fcf43823          	sd	a5,-48(s0)
 1ca:	fd843783          	ld	a5,-40(s0)
 1ce:	00178693          	addi	a3,a5,1
 1d2:	fcd43c23          	sd	a3,-40(s0)
 1d6:	00074703          	lbu	a4,0(a4)
 1da:	00e78023          	sb	a4,0(a5)
 1de:	0007c783          	lbu	a5,0(a5)
 1e2:	fff1                	bnez	a5,1be <strcpy+0x1a>
    ;
  return os;
 1e4:	fe843783          	ld	a5,-24(s0)
}
 1e8:	853e                	mv	a0,a5
 1ea:	70a2                	ld	ra,40(sp)
 1ec:	7402                	ld	s0,32(sp)
 1ee:	6145                	addi	sp,sp,48
 1f0:	8082                	ret

00000000000001f2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1f2:	1101                	addi	sp,sp,-32
 1f4:	ec06                	sd	ra,24(sp)
 1f6:	e822                	sd	s0,16(sp)
 1f8:	1000                	addi	s0,sp,32
 1fa:	fea43423          	sd	a0,-24(s0)
 1fe:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
 202:	a819                	j	218 <strcmp+0x26>
    p++, q++;
 204:	fe843783          	ld	a5,-24(s0)
 208:	0785                	addi	a5,a5,1
 20a:	fef43423          	sd	a5,-24(s0)
 20e:	fe043783          	ld	a5,-32(s0)
 212:	0785                	addi	a5,a5,1
 214:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
 218:	fe843783          	ld	a5,-24(s0)
 21c:	0007c783          	lbu	a5,0(a5)
 220:	cb99                	beqz	a5,236 <strcmp+0x44>
 222:	fe843783          	ld	a5,-24(s0)
 226:	0007c703          	lbu	a4,0(a5)
 22a:	fe043783          	ld	a5,-32(s0)
 22e:	0007c783          	lbu	a5,0(a5)
 232:	fcf709e3          	beq	a4,a5,204 <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
 236:	fe843783          	ld	a5,-24(s0)
 23a:	0007c783          	lbu	a5,0(a5)
 23e:	0007871b          	sext.w	a4,a5
 242:	fe043783          	ld	a5,-32(s0)
 246:	0007c783          	lbu	a5,0(a5)
 24a:	2781                	sext.w	a5,a5
 24c:	40f707bb          	subw	a5,a4,a5
 250:	2781                	sext.w	a5,a5
}
 252:	853e                	mv	a0,a5
 254:	60e2                	ld	ra,24(sp)
 256:	6442                	ld	s0,16(sp)
 258:	6105                	addi	sp,sp,32
 25a:	8082                	ret

000000000000025c <strlen>:

uint
strlen(const char *s)
{
 25c:	7179                	addi	sp,sp,-48
 25e:	f406                	sd	ra,40(sp)
 260:	f022                	sd	s0,32(sp)
 262:	1800                	addi	s0,sp,48
 264:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
 268:	fe042623          	sw	zero,-20(s0)
 26c:	a031                	j	278 <strlen+0x1c>
 26e:	fec42783          	lw	a5,-20(s0)
 272:	2785                	addiw	a5,a5,1
 274:	fef42623          	sw	a5,-20(s0)
 278:	fec42783          	lw	a5,-20(s0)
 27c:	fd843703          	ld	a4,-40(s0)
 280:	97ba                	add	a5,a5,a4
 282:	0007c783          	lbu	a5,0(a5)
 286:	f7e5                	bnez	a5,26e <strlen+0x12>
    ;
  return n;
 288:	fec42783          	lw	a5,-20(s0)
}
 28c:	853e                	mv	a0,a5
 28e:	70a2                	ld	ra,40(sp)
 290:	7402                	ld	s0,32(sp)
 292:	6145                	addi	sp,sp,48
 294:	8082                	ret

0000000000000296 <memset>:

void*
memset(void *dst, int c, uint n)
{
 296:	7179                	addi	sp,sp,-48
 298:	f406                	sd	ra,40(sp)
 29a:	f022                	sd	s0,32(sp)
 29c:	1800                	addi	s0,sp,48
 29e:	fca43c23          	sd	a0,-40(s0)
 2a2:	87ae                	mv	a5,a1
 2a4:	8732                	mv	a4,a2
 2a6:	fcf42a23          	sw	a5,-44(s0)
 2aa:	87ba                	mv	a5,a4
 2ac:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
 2b0:	fd843783          	ld	a5,-40(s0)
 2b4:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
 2b8:	fe042623          	sw	zero,-20(s0)
 2bc:	a00d                	j	2de <memset+0x48>
    cdst[i] = c;
 2be:	fec42783          	lw	a5,-20(s0)
 2c2:	fe043703          	ld	a4,-32(s0)
 2c6:	97ba                	add	a5,a5,a4
 2c8:	fd442703          	lw	a4,-44(s0)
 2cc:	0ff77713          	zext.b	a4,a4
 2d0:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
 2d4:	fec42783          	lw	a5,-20(s0)
 2d8:	2785                	addiw	a5,a5,1
 2da:	fef42623          	sw	a5,-20(s0)
 2de:	fec42783          	lw	a5,-20(s0)
 2e2:	fd042703          	lw	a4,-48(s0)
 2e6:	2701                	sext.w	a4,a4
 2e8:	fce7ebe3          	bltu	a5,a4,2be <memset+0x28>
  }
  return dst;
 2ec:	fd843783          	ld	a5,-40(s0)
}
 2f0:	853e                	mv	a0,a5
 2f2:	70a2                	ld	ra,40(sp)
 2f4:	7402                	ld	s0,32(sp)
 2f6:	6145                	addi	sp,sp,48
 2f8:	8082                	ret

00000000000002fa <strchr>:

char*
strchr(const char *s, char c)
{
 2fa:	1101                	addi	sp,sp,-32
 2fc:	ec06                	sd	ra,24(sp)
 2fe:	e822                	sd	s0,16(sp)
 300:	1000                	addi	s0,sp,32
 302:	fea43423          	sd	a0,-24(s0)
 306:	87ae                	mv	a5,a1
 308:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
 30c:	a01d                	j	332 <strchr+0x38>
    if(*s == c)
 30e:	fe843783          	ld	a5,-24(s0)
 312:	0007c703          	lbu	a4,0(a5)
 316:	fe744783          	lbu	a5,-25(s0)
 31a:	0ff7f793          	zext.b	a5,a5
 31e:	00e79563          	bne	a5,a4,328 <strchr+0x2e>
      return (char*)s;
 322:	fe843783          	ld	a5,-24(s0)
 326:	a821                	j	33e <strchr+0x44>
  for(; *s; s++)
 328:	fe843783          	ld	a5,-24(s0)
 32c:	0785                	addi	a5,a5,1
 32e:	fef43423          	sd	a5,-24(s0)
 332:	fe843783          	ld	a5,-24(s0)
 336:	0007c783          	lbu	a5,0(a5)
 33a:	fbf1                	bnez	a5,30e <strchr+0x14>
  return 0;
 33c:	4781                	li	a5,0
}
 33e:	853e                	mv	a0,a5
 340:	60e2                	ld	ra,24(sp)
 342:	6442                	ld	s0,16(sp)
 344:	6105                	addi	sp,sp,32
 346:	8082                	ret

0000000000000348 <gets>:

char*
gets(char *buf, int max)
{
 348:	7179                	addi	sp,sp,-48
 34a:	f406                	sd	ra,40(sp)
 34c:	f022                	sd	s0,32(sp)
 34e:	1800                	addi	s0,sp,48
 350:	fca43c23          	sd	a0,-40(s0)
 354:	87ae                	mv	a5,a1
 356:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 35a:	fe042623          	sw	zero,-20(s0)
 35e:	a8a1                	j	3b6 <gets+0x6e>
    cc = read(0, &c, 1);
 360:	fe740793          	addi	a5,s0,-25
 364:	4605                	li	a2,1
 366:	85be                	mv	a1,a5
 368:	4501                	li	a0,0
 36a:	00000097          	auipc	ra,0x0
 36e:	302080e7          	jalr	770(ra) # 66c <read>
 372:	87aa                	mv	a5,a0
 374:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
 378:	fe842783          	lw	a5,-24(s0)
 37c:	2781                	sext.w	a5,a5
 37e:	04f05663          	blez	a5,3ca <gets+0x82>
      break;
    buf[i++] = c;
 382:	fec42783          	lw	a5,-20(s0)
 386:	0017871b          	addiw	a4,a5,1
 38a:	fee42623          	sw	a4,-20(s0)
 38e:	873e                	mv	a4,a5
 390:	fd843783          	ld	a5,-40(s0)
 394:	97ba                	add	a5,a5,a4
 396:	fe744703          	lbu	a4,-25(s0)
 39a:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
 39e:	fe744783          	lbu	a5,-25(s0)
 3a2:	873e                	mv	a4,a5
 3a4:	47a9                	li	a5,10
 3a6:	02f70363          	beq	a4,a5,3cc <gets+0x84>
 3aa:	fe744783          	lbu	a5,-25(s0)
 3ae:	873e                	mv	a4,a5
 3b0:	47b5                	li	a5,13
 3b2:	00f70d63          	beq	a4,a5,3cc <gets+0x84>
  for(i=0; i+1 < max; ){
 3b6:	fec42783          	lw	a5,-20(s0)
 3ba:	2785                	addiw	a5,a5,1
 3bc:	2781                	sext.w	a5,a5
 3be:	fd442703          	lw	a4,-44(s0)
 3c2:	2701                	sext.w	a4,a4
 3c4:	f8e7cee3          	blt	a5,a4,360 <gets+0x18>
 3c8:	a011                	j	3cc <gets+0x84>
      break;
 3ca:	0001                	nop
      break;
  }
  buf[i] = '\0';
 3cc:	fec42783          	lw	a5,-20(s0)
 3d0:	fd843703          	ld	a4,-40(s0)
 3d4:	97ba                	add	a5,a5,a4
 3d6:	00078023          	sb	zero,0(a5)
  return buf;
 3da:	fd843783          	ld	a5,-40(s0)
}
 3de:	853e                	mv	a0,a5
 3e0:	70a2                	ld	ra,40(sp)
 3e2:	7402                	ld	s0,32(sp)
 3e4:	6145                	addi	sp,sp,48
 3e6:	8082                	ret

00000000000003e8 <stat>:

int
stat(const char *n, struct stat *st)
{
 3e8:	7179                	addi	sp,sp,-48
 3ea:	f406                	sd	ra,40(sp)
 3ec:	f022                	sd	s0,32(sp)
 3ee:	1800                	addi	s0,sp,48
 3f0:	fca43c23          	sd	a0,-40(s0)
 3f4:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3f8:	4581                	li	a1,0
 3fa:	fd843503          	ld	a0,-40(s0)
 3fe:	00000097          	auipc	ra,0x0
 402:	296080e7          	jalr	662(ra) # 694 <open>
 406:	87aa                	mv	a5,a0
 408:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
 40c:	fec42783          	lw	a5,-20(s0)
 410:	2781                	sext.w	a5,a5
 412:	0007d463          	bgez	a5,41a <stat+0x32>
    return -1;
 416:	57fd                	li	a5,-1
 418:	a035                	j	444 <stat+0x5c>
  r = fstat(fd, st);
 41a:	fec42783          	lw	a5,-20(s0)
 41e:	fd043583          	ld	a1,-48(s0)
 422:	853e                	mv	a0,a5
 424:	00000097          	auipc	ra,0x0
 428:	288080e7          	jalr	648(ra) # 6ac <fstat>
 42c:	87aa                	mv	a5,a0
 42e:	fef42423          	sw	a5,-24(s0)
  close(fd);
 432:	fec42783          	lw	a5,-20(s0)
 436:	853e                	mv	a0,a5
 438:	00000097          	auipc	ra,0x0
 43c:	244080e7          	jalr	580(ra) # 67c <close>
  return r;
 440:	fe842783          	lw	a5,-24(s0)
}
 444:	853e                	mv	a0,a5
 446:	70a2                	ld	ra,40(sp)
 448:	7402                	ld	s0,32(sp)
 44a:	6145                	addi	sp,sp,48
 44c:	8082                	ret

000000000000044e <atoi>:

int
atoi(const char *s)
{
 44e:	7179                	addi	sp,sp,-48
 450:	f406                	sd	ra,40(sp)
 452:	f022                	sd	s0,32(sp)
 454:	1800                	addi	s0,sp,48
 456:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
 45a:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
 45e:	a81d                	j	494 <atoi+0x46>
    n = n*10 + *s++ - '0';
 460:	fec42783          	lw	a5,-20(s0)
 464:	873e                	mv	a4,a5
 466:	87ba                	mv	a5,a4
 468:	0027979b          	slliw	a5,a5,0x2
 46c:	9fb9                	addw	a5,a5,a4
 46e:	0017979b          	slliw	a5,a5,0x1
 472:	0007871b          	sext.w	a4,a5
 476:	fd843783          	ld	a5,-40(s0)
 47a:	00178693          	addi	a3,a5,1
 47e:	fcd43c23          	sd	a3,-40(s0)
 482:	0007c783          	lbu	a5,0(a5)
 486:	2781                	sext.w	a5,a5
 488:	9fb9                	addw	a5,a5,a4
 48a:	2781                	sext.w	a5,a5
 48c:	fd07879b          	addiw	a5,a5,-48
 490:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
 494:	fd843783          	ld	a5,-40(s0)
 498:	0007c783          	lbu	a5,0(a5)
 49c:	873e                	mv	a4,a5
 49e:	02f00793          	li	a5,47
 4a2:	00e7fb63          	bgeu	a5,a4,4b8 <atoi+0x6a>
 4a6:	fd843783          	ld	a5,-40(s0)
 4aa:	0007c783          	lbu	a5,0(a5)
 4ae:	873e                	mv	a4,a5
 4b0:	03900793          	li	a5,57
 4b4:	fae7f6e3          	bgeu	a5,a4,460 <atoi+0x12>
  return n;
 4b8:	fec42783          	lw	a5,-20(s0)
}
 4bc:	853e                	mv	a0,a5
 4be:	70a2                	ld	ra,40(sp)
 4c0:	7402                	ld	s0,32(sp)
 4c2:	6145                	addi	sp,sp,48
 4c4:	8082                	ret

00000000000004c6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4c6:	7139                	addi	sp,sp,-64
 4c8:	fc06                	sd	ra,56(sp)
 4ca:	f822                	sd	s0,48(sp)
 4cc:	0080                	addi	s0,sp,64
 4ce:	fca43c23          	sd	a0,-40(s0)
 4d2:	fcb43823          	sd	a1,-48(s0)
 4d6:	87b2                	mv	a5,a2
 4d8:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
 4dc:	fd843783          	ld	a5,-40(s0)
 4e0:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
 4e4:	fd043783          	ld	a5,-48(s0)
 4e8:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
 4ec:	fe043703          	ld	a4,-32(s0)
 4f0:	fe843783          	ld	a5,-24(s0)
 4f4:	02e7fc63          	bgeu	a5,a4,52c <memmove+0x66>
    while(n-- > 0)
 4f8:	a00d                	j	51a <memmove+0x54>
      *dst++ = *src++;
 4fa:	fe043703          	ld	a4,-32(s0)
 4fe:	00170793          	addi	a5,a4,1
 502:	fef43023          	sd	a5,-32(s0)
 506:	fe843783          	ld	a5,-24(s0)
 50a:	00178693          	addi	a3,a5,1
 50e:	fed43423          	sd	a3,-24(s0)
 512:	00074703          	lbu	a4,0(a4)
 516:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 51a:	fcc42783          	lw	a5,-52(s0)
 51e:	fff7871b          	addiw	a4,a5,-1
 522:	fce42623          	sw	a4,-52(s0)
 526:	fcf04ae3          	bgtz	a5,4fa <memmove+0x34>
 52a:	a891                	j	57e <memmove+0xb8>
  } else {
    dst += n;
 52c:	fcc42783          	lw	a5,-52(s0)
 530:	fe843703          	ld	a4,-24(s0)
 534:	97ba                	add	a5,a5,a4
 536:	fef43423          	sd	a5,-24(s0)
    src += n;
 53a:	fcc42783          	lw	a5,-52(s0)
 53e:	fe043703          	ld	a4,-32(s0)
 542:	97ba                	add	a5,a5,a4
 544:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
 548:	a01d                	j	56e <memmove+0xa8>
      *--dst = *--src;
 54a:	fe043783          	ld	a5,-32(s0)
 54e:	17fd                	addi	a5,a5,-1
 550:	fef43023          	sd	a5,-32(s0)
 554:	fe843783          	ld	a5,-24(s0)
 558:	17fd                	addi	a5,a5,-1
 55a:	fef43423          	sd	a5,-24(s0)
 55e:	fe043783          	ld	a5,-32(s0)
 562:	0007c703          	lbu	a4,0(a5)
 566:	fe843783          	ld	a5,-24(s0)
 56a:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 56e:	fcc42783          	lw	a5,-52(s0)
 572:	fff7871b          	addiw	a4,a5,-1
 576:	fce42623          	sw	a4,-52(s0)
 57a:	fcf048e3          	bgtz	a5,54a <memmove+0x84>
  }
  return vdst;
 57e:	fd843783          	ld	a5,-40(s0)
}
 582:	853e                	mv	a0,a5
 584:	70e2                	ld	ra,56(sp)
 586:	7442                	ld	s0,48(sp)
 588:	6121                	addi	sp,sp,64
 58a:	8082                	ret

000000000000058c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 58c:	7139                	addi	sp,sp,-64
 58e:	fc06                	sd	ra,56(sp)
 590:	f822                	sd	s0,48(sp)
 592:	0080                	addi	s0,sp,64
 594:	fca43c23          	sd	a0,-40(s0)
 598:	fcb43823          	sd	a1,-48(s0)
 59c:	87b2                	mv	a5,a2
 59e:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
 5a2:	fd843783          	ld	a5,-40(s0)
 5a6:	fef43423          	sd	a5,-24(s0)
 5aa:	fd043783          	ld	a5,-48(s0)
 5ae:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 5b2:	a0a1                	j	5fa <memcmp+0x6e>
    if (*p1 != *p2) {
 5b4:	fe843783          	ld	a5,-24(s0)
 5b8:	0007c703          	lbu	a4,0(a5)
 5bc:	fe043783          	ld	a5,-32(s0)
 5c0:	0007c783          	lbu	a5,0(a5)
 5c4:	02f70163          	beq	a4,a5,5e6 <memcmp+0x5a>
      return *p1 - *p2;
 5c8:	fe843783          	ld	a5,-24(s0)
 5cc:	0007c783          	lbu	a5,0(a5)
 5d0:	0007871b          	sext.w	a4,a5
 5d4:	fe043783          	ld	a5,-32(s0)
 5d8:	0007c783          	lbu	a5,0(a5)
 5dc:	2781                	sext.w	a5,a5
 5de:	40f707bb          	subw	a5,a4,a5
 5e2:	2781                	sext.w	a5,a5
 5e4:	a01d                	j	60a <memcmp+0x7e>
    }
    p1++;
 5e6:	fe843783          	ld	a5,-24(s0)
 5ea:	0785                	addi	a5,a5,1
 5ec:	fef43423          	sd	a5,-24(s0)
    p2++;
 5f0:	fe043783          	ld	a5,-32(s0)
 5f4:	0785                	addi	a5,a5,1
 5f6:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 5fa:	fcc42783          	lw	a5,-52(s0)
 5fe:	fff7871b          	addiw	a4,a5,-1
 602:	fce42623          	sw	a4,-52(s0)
 606:	f7dd                	bnez	a5,5b4 <memcmp+0x28>
  }
  return 0;
 608:	4781                	li	a5,0
}
 60a:	853e                	mv	a0,a5
 60c:	70e2                	ld	ra,56(sp)
 60e:	7442                	ld	s0,48(sp)
 610:	6121                	addi	sp,sp,64
 612:	8082                	ret

0000000000000614 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 614:	7179                	addi	sp,sp,-48
 616:	f406                	sd	ra,40(sp)
 618:	f022                	sd	s0,32(sp)
 61a:	1800                	addi	s0,sp,48
 61c:	fea43423          	sd	a0,-24(s0)
 620:	feb43023          	sd	a1,-32(s0)
 624:	87b2                	mv	a5,a2
 626:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
 62a:	fdc42783          	lw	a5,-36(s0)
 62e:	863e                	mv	a2,a5
 630:	fe043583          	ld	a1,-32(s0)
 634:	fe843503          	ld	a0,-24(s0)
 638:	00000097          	auipc	ra,0x0
 63c:	e8e080e7          	jalr	-370(ra) # 4c6 <memmove>
 640:	87aa                	mv	a5,a0
}
 642:	853e                	mv	a0,a5
 644:	70a2                	ld	ra,40(sp)
 646:	7402                	ld	s0,32(sp)
 648:	6145                	addi	sp,sp,48
 64a:	8082                	ret

000000000000064c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 64c:	4885                	li	a7,1
 ecall
 64e:	00000073          	ecall
 ret
 652:	8082                	ret

0000000000000654 <exit>:
.global exit
exit:
 li a7, SYS_exit
 654:	4889                	li	a7,2
 ecall
 656:	00000073          	ecall
 ret
 65a:	8082                	ret

000000000000065c <wait>:
.global wait
wait:
 li a7, SYS_wait
 65c:	488d                	li	a7,3
 ecall
 65e:	00000073          	ecall
 ret
 662:	8082                	ret

0000000000000664 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 664:	4891                	li	a7,4
 ecall
 666:	00000073          	ecall
 ret
 66a:	8082                	ret

000000000000066c <read>:
.global read
read:
 li a7, SYS_read
 66c:	4895                	li	a7,5
 ecall
 66e:	00000073          	ecall
 ret
 672:	8082                	ret

0000000000000674 <write>:
.global write
write:
 li a7, SYS_write
 674:	48c1                	li	a7,16
 ecall
 676:	00000073          	ecall
 ret
 67a:	8082                	ret

000000000000067c <close>:
.global close
close:
 li a7, SYS_close
 67c:	48d5                	li	a7,21
 ecall
 67e:	00000073          	ecall
 ret
 682:	8082                	ret

0000000000000684 <kill>:
.global kill
kill:
 li a7, SYS_kill
 684:	4899                	li	a7,6
 ecall
 686:	00000073          	ecall
 ret
 68a:	8082                	ret

000000000000068c <exec>:
.global exec
exec:
 li a7, SYS_exec
 68c:	489d                	li	a7,7
 ecall
 68e:	00000073          	ecall
 ret
 692:	8082                	ret

0000000000000694 <open>:
.global open
open:
 li a7, SYS_open
 694:	48bd                	li	a7,15
 ecall
 696:	00000073          	ecall
 ret
 69a:	8082                	ret

000000000000069c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 69c:	48c5                	li	a7,17
 ecall
 69e:	00000073          	ecall
 ret
 6a2:	8082                	ret

00000000000006a4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 6a4:	48c9                	li	a7,18
 ecall
 6a6:	00000073          	ecall
 ret
 6aa:	8082                	ret

00000000000006ac <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 6ac:	48a1                	li	a7,8
 ecall
 6ae:	00000073          	ecall
 ret
 6b2:	8082                	ret

00000000000006b4 <link>:
.global link
link:
 li a7, SYS_link
 6b4:	48cd                	li	a7,19
 ecall
 6b6:	00000073          	ecall
 ret
 6ba:	8082                	ret

00000000000006bc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 6bc:	48d1                	li	a7,20
 ecall
 6be:	00000073          	ecall
 ret
 6c2:	8082                	ret

00000000000006c4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 6c4:	48a5                	li	a7,9
 ecall
 6c6:	00000073          	ecall
 ret
 6ca:	8082                	ret

00000000000006cc <dup>:
.global dup
dup:
 li a7, SYS_dup
 6cc:	48a9                	li	a7,10
 ecall
 6ce:	00000073          	ecall
 ret
 6d2:	8082                	ret

00000000000006d4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6d4:	48ad                	li	a7,11
 ecall
 6d6:	00000073          	ecall
 ret
 6da:	8082                	ret

00000000000006dc <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6dc:	48b1                	li	a7,12
 ecall
 6de:	00000073          	ecall
 ret
 6e2:	8082                	ret

00000000000006e4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6e4:	48b5                	li	a7,13
 ecall
 6e6:	00000073          	ecall
 ret
 6ea:	8082                	ret

00000000000006ec <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6ec:	48b9                	li	a7,14
 ecall
 6ee:	00000073          	ecall
 ret
 6f2:	8082                	ret

00000000000006f4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6f4:	1101                	addi	sp,sp,-32
 6f6:	ec06                	sd	ra,24(sp)
 6f8:	e822                	sd	s0,16(sp)
 6fa:	1000                	addi	s0,sp,32
 6fc:	87aa                	mv	a5,a0
 6fe:	872e                	mv	a4,a1
 700:	fef42623          	sw	a5,-20(s0)
 704:	87ba                	mv	a5,a4
 706:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 70a:	feb40713          	addi	a4,s0,-21
 70e:	fec42783          	lw	a5,-20(s0)
 712:	4605                	li	a2,1
 714:	85ba                	mv	a1,a4
 716:	853e                	mv	a0,a5
 718:	00000097          	auipc	ra,0x0
 71c:	f5c080e7          	jalr	-164(ra) # 674 <write>
}
 720:	0001                	nop
 722:	60e2                	ld	ra,24(sp)
 724:	6442                	ld	s0,16(sp)
 726:	6105                	addi	sp,sp,32
 728:	8082                	ret

000000000000072a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 72a:	7139                	addi	sp,sp,-64
 72c:	fc06                	sd	ra,56(sp)
 72e:	f822                	sd	s0,48(sp)
 730:	0080                	addi	s0,sp,64
 732:	87aa                	mv	a5,a0
 734:	8736                	mv	a4,a3
 736:	fcf42623          	sw	a5,-52(s0)
 73a:	87ae                	mv	a5,a1
 73c:	fcf42423          	sw	a5,-56(s0)
 740:	87b2                	mv	a5,a2
 742:	fcf42223          	sw	a5,-60(s0)
 746:	87ba                	mv	a5,a4
 748:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 74c:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 750:	fc042783          	lw	a5,-64(s0)
 754:	2781                	sext.w	a5,a5
 756:	c38d                	beqz	a5,778 <printint+0x4e>
 758:	fc842783          	lw	a5,-56(s0)
 75c:	2781                	sext.w	a5,a5
 75e:	0007dd63          	bgez	a5,778 <printint+0x4e>
    neg = 1;
 762:	4785                	li	a5,1
 764:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 768:	fc842783          	lw	a5,-56(s0)
 76c:	40f007bb          	negw	a5,a5
 770:	2781                	sext.w	a5,a5
 772:	fef42223          	sw	a5,-28(s0)
 776:	a029                	j	780 <printint+0x56>
  } else {
    x = xx;
 778:	fc842783          	lw	a5,-56(s0)
 77c:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 780:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 784:	fc442783          	lw	a5,-60(s0)
 788:	fe442703          	lw	a4,-28(s0)
 78c:	02f777bb          	remuw	a5,a4,a5
 790:	0007871b          	sext.w	a4,a5
 794:	fec42783          	lw	a5,-20(s0)
 798:	0017869b          	addiw	a3,a5,1
 79c:	fed42623          	sw	a3,-20(s0)
 7a0:	00001697          	auipc	a3,0x1
 7a4:	86068693          	addi	a3,a3,-1952 # 1000 <digits>
 7a8:	1702                	slli	a4,a4,0x20
 7aa:	9301                	srli	a4,a4,0x20
 7ac:	9736                	add	a4,a4,a3
 7ae:	00074703          	lbu	a4,0(a4)
 7b2:	17c1                	addi	a5,a5,-16
 7b4:	97a2                	add	a5,a5,s0
 7b6:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 7ba:	fc442783          	lw	a5,-60(s0)
 7be:	fe442703          	lw	a4,-28(s0)
 7c2:	02f757bb          	divuw	a5,a4,a5
 7c6:	fef42223          	sw	a5,-28(s0)
 7ca:	fe442783          	lw	a5,-28(s0)
 7ce:	2781                	sext.w	a5,a5
 7d0:	fbd5                	bnez	a5,784 <printint+0x5a>
  if(neg)
 7d2:	fe842783          	lw	a5,-24(s0)
 7d6:	2781                	sext.w	a5,a5
 7d8:	cf85                	beqz	a5,810 <printint+0xe6>
    buf[i++] = '-';
 7da:	fec42783          	lw	a5,-20(s0)
 7de:	0017871b          	addiw	a4,a5,1
 7e2:	fee42623          	sw	a4,-20(s0)
 7e6:	17c1                	addi	a5,a5,-16
 7e8:	97a2                	add	a5,a5,s0
 7ea:	02d00713          	li	a4,45
 7ee:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 7f2:	a839                	j	810 <printint+0xe6>
    putc(fd, buf[i]);
 7f4:	fec42783          	lw	a5,-20(s0)
 7f8:	17c1                	addi	a5,a5,-16
 7fa:	97a2                	add	a5,a5,s0
 7fc:	fe07c703          	lbu	a4,-32(a5)
 800:	fcc42783          	lw	a5,-52(s0)
 804:	85ba                	mv	a1,a4
 806:	853e                	mv	a0,a5
 808:	00000097          	auipc	ra,0x0
 80c:	eec080e7          	jalr	-276(ra) # 6f4 <putc>
  while(--i >= 0)
 810:	fec42783          	lw	a5,-20(s0)
 814:	37fd                	addiw	a5,a5,-1
 816:	fef42623          	sw	a5,-20(s0)
 81a:	fec42783          	lw	a5,-20(s0)
 81e:	2781                	sext.w	a5,a5
 820:	fc07dae3          	bgez	a5,7f4 <printint+0xca>
}
 824:	0001                	nop
 826:	0001                	nop
 828:	70e2                	ld	ra,56(sp)
 82a:	7442                	ld	s0,48(sp)
 82c:	6121                	addi	sp,sp,64
 82e:	8082                	ret

0000000000000830 <printptr>:

static void
printptr(int fd, uint64 x) {
 830:	7179                	addi	sp,sp,-48
 832:	f406                	sd	ra,40(sp)
 834:	f022                	sd	s0,32(sp)
 836:	1800                	addi	s0,sp,48
 838:	87aa                	mv	a5,a0
 83a:	fcb43823          	sd	a1,-48(s0)
 83e:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 842:	fdc42783          	lw	a5,-36(s0)
 846:	03000593          	li	a1,48
 84a:	853e                	mv	a0,a5
 84c:	00000097          	auipc	ra,0x0
 850:	ea8080e7          	jalr	-344(ra) # 6f4 <putc>
  putc(fd, 'x');
 854:	fdc42783          	lw	a5,-36(s0)
 858:	07800593          	li	a1,120
 85c:	853e                	mv	a0,a5
 85e:	00000097          	auipc	ra,0x0
 862:	e96080e7          	jalr	-362(ra) # 6f4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 866:	fe042623          	sw	zero,-20(s0)
 86a:	a82d                	j	8a4 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 86c:	fd043783          	ld	a5,-48(s0)
 870:	93f1                	srli	a5,a5,0x3c
 872:	00000717          	auipc	a4,0x0
 876:	78e70713          	addi	a4,a4,1934 # 1000 <digits>
 87a:	97ba                	add	a5,a5,a4
 87c:	0007c703          	lbu	a4,0(a5)
 880:	fdc42783          	lw	a5,-36(s0)
 884:	85ba                	mv	a1,a4
 886:	853e                	mv	a0,a5
 888:	00000097          	auipc	ra,0x0
 88c:	e6c080e7          	jalr	-404(ra) # 6f4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 890:	fec42783          	lw	a5,-20(s0)
 894:	2785                	addiw	a5,a5,1
 896:	fef42623          	sw	a5,-20(s0)
 89a:	fd043783          	ld	a5,-48(s0)
 89e:	0792                	slli	a5,a5,0x4
 8a0:	fcf43823          	sd	a5,-48(s0)
 8a4:	fec42703          	lw	a4,-20(s0)
 8a8:	47bd                	li	a5,15
 8aa:	fce7f1e3          	bgeu	a5,a4,86c <printptr+0x3c>
}
 8ae:	0001                	nop
 8b0:	0001                	nop
 8b2:	70a2                	ld	ra,40(sp)
 8b4:	7402                	ld	s0,32(sp)
 8b6:	6145                	addi	sp,sp,48
 8b8:	8082                	ret

00000000000008ba <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 8ba:	715d                	addi	sp,sp,-80
 8bc:	e486                	sd	ra,72(sp)
 8be:	e0a2                	sd	s0,64(sp)
 8c0:	0880                	addi	s0,sp,80
 8c2:	87aa                	mv	a5,a0
 8c4:	fcb43023          	sd	a1,-64(s0)
 8c8:	fac43c23          	sd	a2,-72(s0)
 8cc:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 8d0:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 8d4:	fe042223          	sw	zero,-28(s0)
 8d8:	a42d                	j	b02 <vprintf+0x248>
    c = fmt[i] & 0xff;
 8da:	fe442783          	lw	a5,-28(s0)
 8de:	fc043703          	ld	a4,-64(s0)
 8e2:	97ba                	add	a5,a5,a4
 8e4:	0007c783          	lbu	a5,0(a5)
 8e8:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 8ec:	fe042783          	lw	a5,-32(s0)
 8f0:	2781                	sext.w	a5,a5
 8f2:	eb9d                	bnez	a5,928 <vprintf+0x6e>
      if(c == '%'){
 8f4:	fdc42783          	lw	a5,-36(s0)
 8f8:	0007871b          	sext.w	a4,a5
 8fc:	02500793          	li	a5,37
 900:	00f71763          	bne	a4,a5,90e <vprintf+0x54>
        state = '%';
 904:	02500793          	li	a5,37
 908:	fef42023          	sw	a5,-32(s0)
 90c:	a2f5                	j	af8 <vprintf+0x23e>
      } else {
        putc(fd, c);
 90e:	fdc42783          	lw	a5,-36(s0)
 912:	0ff7f713          	zext.b	a4,a5
 916:	fcc42783          	lw	a5,-52(s0)
 91a:	85ba                	mv	a1,a4
 91c:	853e                	mv	a0,a5
 91e:	00000097          	auipc	ra,0x0
 922:	dd6080e7          	jalr	-554(ra) # 6f4 <putc>
 926:	aac9                	j	af8 <vprintf+0x23e>
      }
    } else if(state == '%'){
 928:	fe042783          	lw	a5,-32(s0)
 92c:	0007871b          	sext.w	a4,a5
 930:	02500793          	li	a5,37
 934:	1cf71263          	bne	a4,a5,af8 <vprintf+0x23e>
      if(c == 'd'){
 938:	fdc42783          	lw	a5,-36(s0)
 93c:	0007871b          	sext.w	a4,a5
 940:	06400793          	li	a5,100
 944:	02f71463          	bne	a4,a5,96c <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 948:	fb843783          	ld	a5,-72(s0)
 94c:	00878713          	addi	a4,a5,8
 950:	fae43c23          	sd	a4,-72(s0)
 954:	4398                	lw	a4,0(a5)
 956:	fcc42783          	lw	a5,-52(s0)
 95a:	4685                	li	a3,1
 95c:	4629                	li	a2,10
 95e:	85ba                	mv	a1,a4
 960:	853e                	mv	a0,a5
 962:	00000097          	auipc	ra,0x0
 966:	dc8080e7          	jalr	-568(ra) # 72a <printint>
 96a:	a269                	j	af4 <vprintf+0x23a>
      } else if(c == 'l') {
 96c:	fdc42783          	lw	a5,-36(s0)
 970:	0007871b          	sext.w	a4,a5
 974:	06c00793          	li	a5,108
 978:	02f71663          	bne	a4,a5,9a4 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 97c:	fb843783          	ld	a5,-72(s0)
 980:	00878713          	addi	a4,a5,8
 984:	fae43c23          	sd	a4,-72(s0)
 988:	639c                	ld	a5,0(a5)
 98a:	0007871b          	sext.w	a4,a5
 98e:	fcc42783          	lw	a5,-52(s0)
 992:	4681                	li	a3,0
 994:	4629                	li	a2,10
 996:	85ba                	mv	a1,a4
 998:	853e                	mv	a0,a5
 99a:	00000097          	auipc	ra,0x0
 99e:	d90080e7          	jalr	-624(ra) # 72a <printint>
 9a2:	aa89                	j	af4 <vprintf+0x23a>
      } else if(c == 'x') {
 9a4:	fdc42783          	lw	a5,-36(s0)
 9a8:	0007871b          	sext.w	a4,a5
 9ac:	07800793          	li	a5,120
 9b0:	02f71463          	bne	a4,a5,9d8 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 9b4:	fb843783          	ld	a5,-72(s0)
 9b8:	00878713          	addi	a4,a5,8
 9bc:	fae43c23          	sd	a4,-72(s0)
 9c0:	4398                	lw	a4,0(a5)
 9c2:	fcc42783          	lw	a5,-52(s0)
 9c6:	4681                	li	a3,0
 9c8:	4641                	li	a2,16
 9ca:	85ba                	mv	a1,a4
 9cc:	853e                	mv	a0,a5
 9ce:	00000097          	auipc	ra,0x0
 9d2:	d5c080e7          	jalr	-676(ra) # 72a <printint>
 9d6:	aa39                	j	af4 <vprintf+0x23a>
      } else if(c == 'p') {
 9d8:	fdc42783          	lw	a5,-36(s0)
 9dc:	0007871b          	sext.w	a4,a5
 9e0:	07000793          	li	a5,112
 9e4:	02f71263          	bne	a4,a5,a08 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 9e8:	fb843783          	ld	a5,-72(s0)
 9ec:	00878713          	addi	a4,a5,8
 9f0:	fae43c23          	sd	a4,-72(s0)
 9f4:	6398                	ld	a4,0(a5)
 9f6:	fcc42783          	lw	a5,-52(s0)
 9fa:	85ba                	mv	a1,a4
 9fc:	853e                	mv	a0,a5
 9fe:	00000097          	auipc	ra,0x0
 a02:	e32080e7          	jalr	-462(ra) # 830 <printptr>
 a06:	a0fd                	j	af4 <vprintf+0x23a>
      } else if(c == 's'){
 a08:	fdc42783          	lw	a5,-36(s0)
 a0c:	0007871b          	sext.w	a4,a5
 a10:	07300793          	li	a5,115
 a14:	04f71c63          	bne	a4,a5,a6c <vprintf+0x1b2>
        s = va_arg(ap, char*);
 a18:	fb843783          	ld	a5,-72(s0)
 a1c:	00878713          	addi	a4,a5,8
 a20:	fae43c23          	sd	a4,-72(s0)
 a24:	639c                	ld	a5,0(a5)
 a26:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 a2a:	fe843783          	ld	a5,-24(s0)
 a2e:	eb8d                	bnez	a5,a60 <vprintf+0x1a6>
          s = "(null)";
 a30:	00000797          	auipc	a5,0x0
 a34:	4c078793          	addi	a5,a5,1216 # ef0 <malloc+0x184>
 a38:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 a3c:	a015                	j	a60 <vprintf+0x1a6>
          putc(fd, *s);
 a3e:	fe843783          	ld	a5,-24(s0)
 a42:	0007c703          	lbu	a4,0(a5)
 a46:	fcc42783          	lw	a5,-52(s0)
 a4a:	85ba                	mv	a1,a4
 a4c:	853e                	mv	a0,a5
 a4e:	00000097          	auipc	ra,0x0
 a52:	ca6080e7          	jalr	-858(ra) # 6f4 <putc>
          s++;
 a56:	fe843783          	ld	a5,-24(s0)
 a5a:	0785                	addi	a5,a5,1
 a5c:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 a60:	fe843783          	ld	a5,-24(s0)
 a64:	0007c783          	lbu	a5,0(a5)
 a68:	fbf9                	bnez	a5,a3e <vprintf+0x184>
 a6a:	a069                	j	af4 <vprintf+0x23a>
        }
      } else if(c == 'c'){
 a6c:	fdc42783          	lw	a5,-36(s0)
 a70:	0007871b          	sext.w	a4,a5
 a74:	06300793          	li	a5,99
 a78:	02f71463          	bne	a4,a5,aa0 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 a7c:	fb843783          	ld	a5,-72(s0)
 a80:	00878713          	addi	a4,a5,8
 a84:	fae43c23          	sd	a4,-72(s0)
 a88:	439c                	lw	a5,0(a5)
 a8a:	0ff7f713          	zext.b	a4,a5
 a8e:	fcc42783          	lw	a5,-52(s0)
 a92:	85ba                	mv	a1,a4
 a94:	853e                	mv	a0,a5
 a96:	00000097          	auipc	ra,0x0
 a9a:	c5e080e7          	jalr	-930(ra) # 6f4 <putc>
 a9e:	a899                	j	af4 <vprintf+0x23a>
      } else if(c == '%'){
 aa0:	fdc42783          	lw	a5,-36(s0)
 aa4:	0007871b          	sext.w	a4,a5
 aa8:	02500793          	li	a5,37
 aac:	00f71f63          	bne	a4,a5,aca <vprintf+0x210>
        putc(fd, c);
 ab0:	fdc42783          	lw	a5,-36(s0)
 ab4:	0ff7f713          	zext.b	a4,a5
 ab8:	fcc42783          	lw	a5,-52(s0)
 abc:	85ba                	mv	a1,a4
 abe:	853e                	mv	a0,a5
 ac0:	00000097          	auipc	ra,0x0
 ac4:	c34080e7          	jalr	-972(ra) # 6f4 <putc>
 ac8:	a035                	j	af4 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 aca:	fcc42783          	lw	a5,-52(s0)
 ace:	02500593          	li	a1,37
 ad2:	853e                	mv	a0,a5
 ad4:	00000097          	auipc	ra,0x0
 ad8:	c20080e7          	jalr	-992(ra) # 6f4 <putc>
        putc(fd, c);
 adc:	fdc42783          	lw	a5,-36(s0)
 ae0:	0ff7f713          	zext.b	a4,a5
 ae4:	fcc42783          	lw	a5,-52(s0)
 ae8:	85ba                	mv	a1,a4
 aea:	853e                	mv	a0,a5
 aec:	00000097          	auipc	ra,0x0
 af0:	c08080e7          	jalr	-1016(ra) # 6f4 <putc>
      }
      state = 0;
 af4:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 af8:	fe442783          	lw	a5,-28(s0)
 afc:	2785                	addiw	a5,a5,1
 afe:	fef42223          	sw	a5,-28(s0)
 b02:	fe442783          	lw	a5,-28(s0)
 b06:	fc043703          	ld	a4,-64(s0)
 b0a:	97ba                	add	a5,a5,a4
 b0c:	0007c783          	lbu	a5,0(a5)
 b10:	dc0795e3          	bnez	a5,8da <vprintf+0x20>
    }
  }
}
 b14:	0001                	nop
 b16:	0001                	nop
 b18:	60a6                	ld	ra,72(sp)
 b1a:	6406                	ld	s0,64(sp)
 b1c:	6161                	addi	sp,sp,80
 b1e:	8082                	ret

0000000000000b20 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b20:	7159                	addi	sp,sp,-112
 b22:	fc06                	sd	ra,56(sp)
 b24:	f822                	sd	s0,48(sp)
 b26:	0080                	addi	s0,sp,64
 b28:	fcb43823          	sd	a1,-48(s0)
 b2c:	e010                	sd	a2,0(s0)
 b2e:	e414                	sd	a3,8(s0)
 b30:	e818                	sd	a4,16(s0)
 b32:	ec1c                	sd	a5,24(s0)
 b34:	03043023          	sd	a6,32(s0)
 b38:	03143423          	sd	a7,40(s0)
 b3c:	87aa                	mv	a5,a0
 b3e:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 b42:	03040793          	addi	a5,s0,48
 b46:	fcf43423          	sd	a5,-56(s0)
 b4a:	fc843783          	ld	a5,-56(s0)
 b4e:	fd078793          	addi	a5,a5,-48
 b52:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 b56:	fe843703          	ld	a4,-24(s0)
 b5a:	fdc42783          	lw	a5,-36(s0)
 b5e:	863a                	mv	a2,a4
 b60:	fd043583          	ld	a1,-48(s0)
 b64:	853e                	mv	a0,a5
 b66:	00000097          	auipc	ra,0x0
 b6a:	d54080e7          	jalr	-684(ra) # 8ba <vprintf>
}
 b6e:	0001                	nop
 b70:	70e2                	ld	ra,56(sp)
 b72:	7442                	ld	s0,48(sp)
 b74:	6165                	addi	sp,sp,112
 b76:	8082                	ret

0000000000000b78 <printf>:

void
printf(const char *fmt, ...)
{
 b78:	7159                	addi	sp,sp,-112
 b7a:	f406                	sd	ra,40(sp)
 b7c:	f022                	sd	s0,32(sp)
 b7e:	1800                	addi	s0,sp,48
 b80:	fca43c23          	sd	a0,-40(s0)
 b84:	e40c                	sd	a1,8(s0)
 b86:	e810                	sd	a2,16(s0)
 b88:	ec14                	sd	a3,24(s0)
 b8a:	f018                	sd	a4,32(s0)
 b8c:	f41c                	sd	a5,40(s0)
 b8e:	03043823          	sd	a6,48(s0)
 b92:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b96:	04040793          	addi	a5,s0,64
 b9a:	fcf43823          	sd	a5,-48(s0)
 b9e:	fd043783          	ld	a5,-48(s0)
 ba2:	fc878793          	addi	a5,a5,-56
 ba6:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 baa:	fe843783          	ld	a5,-24(s0)
 bae:	863e                	mv	a2,a5
 bb0:	fd843583          	ld	a1,-40(s0)
 bb4:	4505                	li	a0,1
 bb6:	00000097          	auipc	ra,0x0
 bba:	d04080e7          	jalr	-764(ra) # 8ba <vprintf>
}
 bbe:	0001                	nop
 bc0:	70a2                	ld	ra,40(sp)
 bc2:	7402                	ld	s0,32(sp)
 bc4:	6165                	addi	sp,sp,112
 bc6:	8082                	ret

0000000000000bc8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 bc8:	7179                	addi	sp,sp,-48
 bca:	f406                	sd	ra,40(sp)
 bcc:	f022                	sd	s0,32(sp)
 bce:	1800                	addi	s0,sp,48
 bd0:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 bd4:	fd843783          	ld	a5,-40(s0)
 bd8:	17c1                	addi	a5,a5,-16
 bda:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bde:	00000797          	auipc	a5,0x0
 be2:	45278793          	addi	a5,a5,1106 # 1030 <freep>
 be6:	639c                	ld	a5,0(a5)
 be8:	fef43423          	sd	a5,-24(s0)
 bec:	a815                	j	c20 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bee:	fe843783          	ld	a5,-24(s0)
 bf2:	639c                	ld	a5,0(a5)
 bf4:	fe843703          	ld	a4,-24(s0)
 bf8:	00f76f63          	bltu	a4,a5,c16 <free+0x4e>
 bfc:	fe043703          	ld	a4,-32(s0)
 c00:	fe843783          	ld	a5,-24(s0)
 c04:	02e7eb63          	bltu	a5,a4,c3a <free+0x72>
 c08:	fe843783          	ld	a5,-24(s0)
 c0c:	639c                	ld	a5,0(a5)
 c0e:	fe043703          	ld	a4,-32(s0)
 c12:	02f76463          	bltu	a4,a5,c3a <free+0x72>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c16:	fe843783          	ld	a5,-24(s0)
 c1a:	639c                	ld	a5,0(a5)
 c1c:	fef43423          	sd	a5,-24(s0)
 c20:	fe043703          	ld	a4,-32(s0)
 c24:	fe843783          	ld	a5,-24(s0)
 c28:	fce7f3e3          	bgeu	a5,a4,bee <free+0x26>
 c2c:	fe843783          	ld	a5,-24(s0)
 c30:	639c                	ld	a5,0(a5)
 c32:	fe043703          	ld	a4,-32(s0)
 c36:	faf77ce3          	bgeu	a4,a5,bee <free+0x26>
      break;
  if(bp + bp->s.size == p->s.ptr){
 c3a:	fe043783          	ld	a5,-32(s0)
 c3e:	479c                	lw	a5,8(a5)
 c40:	1782                	slli	a5,a5,0x20
 c42:	9381                	srli	a5,a5,0x20
 c44:	0792                	slli	a5,a5,0x4
 c46:	fe043703          	ld	a4,-32(s0)
 c4a:	973e                	add	a4,a4,a5
 c4c:	fe843783          	ld	a5,-24(s0)
 c50:	639c                	ld	a5,0(a5)
 c52:	02f71763          	bne	a4,a5,c80 <free+0xb8>
    bp->s.size += p->s.ptr->s.size;
 c56:	fe043783          	ld	a5,-32(s0)
 c5a:	4798                	lw	a4,8(a5)
 c5c:	fe843783          	ld	a5,-24(s0)
 c60:	639c                	ld	a5,0(a5)
 c62:	479c                	lw	a5,8(a5)
 c64:	9fb9                	addw	a5,a5,a4
 c66:	0007871b          	sext.w	a4,a5
 c6a:	fe043783          	ld	a5,-32(s0)
 c6e:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 c70:	fe843783          	ld	a5,-24(s0)
 c74:	639c                	ld	a5,0(a5)
 c76:	6398                	ld	a4,0(a5)
 c78:	fe043783          	ld	a5,-32(s0)
 c7c:	e398                	sd	a4,0(a5)
 c7e:	a039                	j	c8c <free+0xc4>
  } else
    bp->s.ptr = p->s.ptr;
 c80:	fe843783          	ld	a5,-24(s0)
 c84:	6398                	ld	a4,0(a5)
 c86:	fe043783          	ld	a5,-32(s0)
 c8a:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 c8c:	fe843783          	ld	a5,-24(s0)
 c90:	479c                	lw	a5,8(a5)
 c92:	1782                	slli	a5,a5,0x20
 c94:	9381                	srli	a5,a5,0x20
 c96:	0792                	slli	a5,a5,0x4
 c98:	fe843703          	ld	a4,-24(s0)
 c9c:	97ba                	add	a5,a5,a4
 c9e:	fe043703          	ld	a4,-32(s0)
 ca2:	02f71563          	bne	a4,a5,ccc <free+0x104>
    p->s.size += bp->s.size;
 ca6:	fe843783          	ld	a5,-24(s0)
 caa:	4798                	lw	a4,8(a5)
 cac:	fe043783          	ld	a5,-32(s0)
 cb0:	479c                	lw	a5,8(a5)
 cb2:	9fb9                	addw	a5,a5,a4
 cb4:	0007871b          	sext.w	a4,a5
 cb8:	fe843783          	ld	a5,-24(s0)
 cbc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 cbe:	fe043783          	ld	a5,-32(s0)
 cc2:	6398                	ld	a4,0(a5)
 cc4:	fe843783          	ld	a5,-24(s0)
 cc8:	e398                	sd	a4,0(a5)
 cca:	a031                	j	cd6 <free+0x10e>
  } else
    p->s.ptr = bp;
 ccc:	fe843783          	ld	a5,-24(s0)
 cd0:	fe043703          	ld	a4,-32(s0)
 cd4:	e398                	sd	a4,0(a5)
  freep = p;
 cd6:	00000797          	auipc	a5,0x0
 cda:	35a78793          	addi	a5,a5,858 # 1030 <freep>
 cde:	fe843703          	ld	a4,-24(s0)
 ce2:	e398                	sd	a4,0(a5)
}
 ce4:	0001                	nop
 ce6:	70a2                	ld	ra,40(sp)
 ce8:	7402                	ld	s0,32(sp)
 cea:	6145                	addi	sp,sp,48
 cec:	8082                	ret

0000000000000cee <morecore>:

static Header*
morecore(uint nu)
{
 cee:	7179                	addi	sp,sp,-48
 cf0:	f406                	sd	ra,40(sp)
 cf2:	f022                	sd	s0,32(sp)
 cf4:	1800                	addi	s0,sp,48
 cf6:	87aa                	mv	a5,a0
 cf8:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 cfc:	fdc42783          	lw	a5,-36(s0)
 d00:	0007871b          	sext.w	a4,a5
 d04:	6785                	lui	a5,0x1
 d06:	00f77563          	bgeu	a4,a5,d10 <morecore+0x22>
    nu = 4096;
 d0a:	6785                	lui	a5,0x1
 d0c:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 d10:	fdc42783          	lw	a5,-36(s0)
 d14:	0047979b          	slliw	a5,a5,0x4
 d18:	2781                	sext.w	a5,a5
 d1a:	853e                	mv	a0,a5
 d1c:	00000097          	auipc	ra,0x0
 d20:	9c0080e7          	jalr	-1600(ra) # 6dc <sbrk>
 d24:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 d28:	fe843703          	ld	a4,-24(s0)
 d2c:	57fd                	li	a5,-1
 d2e:	00f71463          	bne	a4,a5,d36 <morecore+0x48>
    return 0;
 d32:	4781                	li	a5,0
 d34:	a03d                	j	d62 <morecore+0x74>
  hp = (Header*)p;
 d36:	fe843783          	ld	a5,-24(s0)
 d3a:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 d3e:	fe043783          	ld	a5,-32(s0)
 d42:	fdc42703          	lw	a4,-36(s0)
 d46:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 d48:	fe043783          	ld	a5,-32(s0)
 d4c:	07c1                	addi	a5,a5,16 # 1010 <digits+0x10>
 d4e:	853e                	mv	a0,a5
 d50:	00000097          	auipc	ra,0x0
 d54:	e78080e7          	jalr	-392(ra) # bc8 <free>
  return freep;
 d58:	00000797          	auipc	a5,0x0
 d5c:	2d878793          	addi	a5,a5,728 # 1030 <freep>
 d60:	639c                	ld	a5,0(a5)
}
 d62:	853e                	mv	a0,a5
 d64:	70a2                	ld	ra,40(sp)
 d66:	7402                	ld	s0,32(sp)
 d68:	6145                	addi	sp,sp,48
 d6a:	8082                	ret

0000000000000d6c <malloc>:

void*
malloc(uint nbytes)
{
 d6c:	7139                	addi	sp,sp,-64
 d6e:	fc06                	sd	ra,56(sp)
 d70:	f822                	sd	s0,48(sp)
 d72:	0080                	addi	s0,sp,64
 d74:	87aa                	mv	a5,a0
 d76:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d7a:	fcc46783          	lwu	a5,-52(s0)
 d7e:	07bd                	addi	a5,a5,15
 d80:	8391                	srli	a5,a5,0x4
 d82:	2781                	sext.w	a5,a5
 d84:	2785                	addiw	a5,a5,1
 d86:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 d8a:	00000797          	auipc	a5,0x0
 d8e:	2a678793          	addi	a5,a5,678 # 1030 <freep>
 d92:	639c                	ld	a5,0(a5)
 d94:	fef43023          	sd	a5,-32(s0)
 d98:	fe043783          	ld	a5,-32(s0)
 d9c:	ef95                	bnez	a5,dd8 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 d9e:	00000797          	auipc	a5,0x0
 da2:	28278793          	addi	a5,a5,642 # 1020 <base>
 da6:	fef43023          	sd	a5,-32(s0)
 daa:	00000797          	auipc	a5,0x0
 dae:	28678793          	addi	a5,a5,646 # 1030 <freep>
 db2:	fe043703          	ld	a4,-32(s0)
 db6:	e398                	sd	a4,0(a5)
 db8:	00000797          	auipc	a5,0x0
 dbc:	27878793          	addi	a5,a5,632 # 1030 <freep>
 dc0:	6398                	ld	a4,0(a5)
 dc2:	00000797          	auipc	a5,0x0
 dc6:	25e78793          	addi	a5,a5,606 # 1020 <base>
 dca:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 dcc:	00000797          	auipc	a5,0x0
 dd0:	25478793          	addi	a5,a5,596 # 1020 <base>
 dd4:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 dd8:	fe043783          	ld	a5,-32(s0)
 ddc:	639c                	ld	a5,0(a5)
 dde:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 de2:	fe843783          	ld	a5,-24(s0)
 de6:	479c                	lw	a5,8(a5)
 de8:	fdc42703          	lw	a4,-36(s0)
 dec:	2701                	sext.w	a4,a4
 dee:	06e7e763          	bltu	a5,a4,e5c <malloc+0xf0>
      if(p->s.size == nunits)
 df2:	fe843783          	ld	a5,-24(s0)
 df6:	479c                	lw	a5,8(a5)
 df8:	fdc42703          	lw	a4,-36(s0)
 dfc:	2701                	sext.w	a4,a4
 dfe:	00f71963          	bne	a4,a5,e10 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 e02:	fe843783          	ld	a5,-24(s0)
 e06:	6398                	ld	a4,0(a5)
 e08:	fe043783          	ld	a5,-32(s0)
 e0c:	e398                	sd	a4,0(a5)
 e0e:	a825                	j	e46 <malloc+0xda>
      else {
        p->s.size -= nunits;
 e10:	fe843783          	ld	a5,-24(s0)
 e14:	479c                	lw	a5,8(a5)
 e16:	fdc42703          	lw	a4,-36(s0)
 e1a:	9f99                	subw	a5,a5,a4
 e1c:	0007871b          	sext.w	a4,a5
 e20:	fe843783          	ld	a5,-24(s0)
 e24:	c798                	sw	a4,8(a5)
        p += p->s.size;
 e26:	fe843783          	ld	a5,-24(s0)
 e2a:	479c                	lw	a5,8(a5)
 e2c:	1782                	slli	a5,a5,0x20
 e2e:	9381                	srli	a5,a5,0x20
 e30:	0792                	slli	a5,a5,0x4
 e32:	fe843703          	ld	a4,-24(s0)
 e36:	97ba                	add	a5,a5,a4
 e38:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 e3c:	fe843783          	ld	a5,-24(s0)
 e40:	fdc42703          	lw	a4,-36(s0)
 e44:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 e46:	00000797          	auipc	a5,0x0
 e4a:	1ea78793          	addi	a5,a5,490 # 1030 <freep>
 e4e:	fe043703          	ld	a4,-32(s0)
 e52:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 e54:	fe843783          	ld	a5,-24(s0)
 e58:	07c1                	addi	a5,a5,16
 e5a:	a091                	j	e9e <malloc+0x132>
    }
    if(p == freep)
 e5c:	00000797          	auipc	a5,0x0
 e60:	1d478793          	addi	a5,a5,468 # 1030 <freep>
 e64:	639c                	ld	a5,0(a5)
 e66:	fe843703          	ld	a4,-24(s0)
 e6a:	02f71063          	bne	a4,a5,e8a <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 e6e:	fdc42783          	lw	a5,-36(s0)
 e72:	853e                	mv	a0,a5
 e74:	00000097          	auipc	ra,0x0
 e78:	e7a080e7          	jalr	-390(ra) # cee <morecore>
 e7c:	fea43423          	sd	a0,-24(s0)
 e80:	fe843783          	ld	a5,-24(s0)
 e84:	e399                	bnez	a5,e8a <malloc+0x11e>
        return 0;
 e86:	4781                	li	a5,0
 e88:	a819                	j	e9e <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e8a:	fe843783          	ld	a5,-24(s0)
 e8e:	fef43023          	sd	a5,-32(s0)
 e92:	fe843783          	ld	a5,-24(s0)
 e96:	639c                	ld	a5,0(a5)
 e98:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 e9c:	b799                	j	de2 <malloc+0x76>
  }
}
 e9e:	853e                	mv	a0,a5
 ea0:	70e2                	ld	ra,56(sp)
 ea2:	7442                	ld	s0,48(sp)
 ea4:	6121                	addi	sp,sp,64
 ea6:	8082                	ret
