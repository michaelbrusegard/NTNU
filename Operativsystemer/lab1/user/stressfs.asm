
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
  1c:	ec878793          	addi	a5,a5,-312 # ee0 <malloc+0x16c>
  20:	6398                	ld	a4,0(a5)
  22:	fce43c23          	sd	a4,-40(s0)
  26:	0087d783          	lhu	a5,8(a5)
  2a:	fef41023          	sh	a5,-32(s0)
  char data[512];

  printf("stressfs starting\n");
  2e:	00001517          	auipc	a0,0x1
  32:	e8250513          	addi	a0,a0,-382 # eb0 <malloc+0x13c>
  36:	00001097          	auipc	ra,0x1
  3a:	b4a080e7          	jalr	-1206(ra) # b80 <printf>
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
  8e:	e3e50513          	addi	a0,a0,-450 # ec8 <malloc+0x154>
  92:	00001097          	auipc	ra,0x1
  96:	aee080e7          	jalr	-1298(ra) # b80 <printf>

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
 110:	dcc50513          	addi	a0,a0,-564 # ed8 <malloc+0x164>
 114:	00001097          	auipc	ra,0x1
 118:	a6c080e7          	jalr	-1428(ra) # b80 <printf>

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

00000000000006f4 <ps>:
.global ps
ps:
 li a7, SYS_ps
 6f4:	48d9                	li	a7,22
 ecall
 6f6:	00000073          	ecall
 ret
 6fa:	8082                	ret

00000000000006fc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6fc:	1101                	addi	sp,sp,-32
 6fe:	ec06                	sd	ra,24(sp)
 700:	e822                	sd	s0,16(sp)
 702:	1000                	addi	s0,sp,32
 704:	87aa                	mv	a5,a0
 706:	872e                	mv	a4,a1
 708:	fef42623          	sw	a5,-20(s0)
 70c:	87ba                	mv	a5,a4
 70e:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 712:	feb40713          	addi	a4,s0,-21
 716:	fec42783          	lw	a5,-20(s0)
 71a:	4605                	li	a2,1
 71c:	85ba                	mv	a1,a4
 71e:	853e                	mv	a0,a5
 720:	00000097          	auipc	ra,0x0
 724:	f54080e7          	jalr	-172(ra) # 674 <write>
}
 728:	0001                	nop
 72a:	60e2                	ld	ra,24(sp)
 72c:	6442                	ld	s0,16(sp)
 72e:	6105                	addi	sp,sp,32
 730:	8082                	ret

0000000000000732 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 732:	7139                	addi	sp,sp,-64
 734:	fc06                	sd	ra,56(sp)
 736:	f822                	sd	s0,48(sp)
 738:	0080                	addi	s0,sp,64
 73a:	87aa                	mv	a5,a0
 73c:	8736                	mv	a4,a3
 73e:	fcf42623          	sw	a5,-52(s0)
 742:	87ae                	mv	a5,a1
 744:	fcf42423          	sw	a5,-56(s0)
 748:	87b2                	mv	a5,a2
 74a:	fcf42223          	sw	a5,-60(s0)
 74e:	87ba                	mv	a5,a4
 750:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 754:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 758:	fc042783          	lw	a5,-64(s0)
 75c:	2781                	sext.w	a5,a5
 75e:	c38d                	beqz	a5,780 <printint+0x4e>
 760:	fc842783          	lw	a5,-56(s0)
 764:	2781                	sext.w	a5,a5
 766:	0007dd63          	bgez	a5,780 <printint+0x4e>
    neg = 1;
 76a:	4785                	li	a5,1
 76c:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 770:	fc842783          	lw	a5,-56(s0)
 774:	40f007bb          	negw	a5,a5
 778:	2781                	sext.w	a5,a5
 77a:	fef42223          	sw	a5,-28(s0)
 77e:	a029                	j	788 <printint+0x56>
  } else {
    x = xx;
 780:	fc842783          	lw	a5,-56(s0)
 784:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 788:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 78c:	fc442783          	lw	a5,-60(s0)
 790:	fe442703          	lw	a4,-28(s0)
 794:	02f777bb          	remuw	a5,a4,a5
 798:	0007871b          	sext.w	a4,a5
 79c:	fec42783          	lw	a5,-20(s0)
 7a0:	0017869b          	addiw	a3,a5,1
 7a4:	fed42623          	sw	a3,-20(s0)
 7a8:	00001697          	auipc	a3,0x1
 7ac:	85868693          	addi	a3,a3,-1960 # 1000 <digits>
 7b0:	1702                	slli	a4,a4,0x20
 7b2:	9301                	srli	a4,a4,0x20
 7b4:	9736                	add	a4,a4,a3
 7b6:	00074703          	lbu	a4,0(a4)
 7ba:	17c1                	addi	a5,a5,-16
 7bc:	97a2                	add	a5,a5,s0
 7be:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 7c2:	fc442783          	lw	a5,-60(s0)
 7c6:	fe442703          	lw	a4,-28(s0)
 7ca:	02f757bb          	divuw	a5,a4,a5
 7ce:	fef42223          	sw	a5,-28(s0)
 7d2:	fe442783          	lw	a5,-28(s0)
 7d6:	2781                	sext.w	a5,a5
 7d8:	fbd5                	bnez	a5,78c <printint+0x5a>
  if(neg)
 7da:	fe842783          	lw	a5,-24(s0)
 7de:	2781                	sext.w	a5,a5
 7e0:	cf85                	beqz	a5,818 <printint+0xe6>
    buf[i++] = '-';
 7e2:	fec42783          	lw	a5,-20(s0)
 7e6:	0017871b          	addiw	a4,a5,1
 7ea:	fee42623          	sw	a4,-20(s0)
 7ee:	17c1                	addi	a5,a5,-16
 7f0:	97a2                	add	a5,a5,s0
 7f2:	02d00713          	li	a4,45
 7f6:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 7fa:	a839                	j	818 <printint+0xe6>
    putc(fd, buf[i]);
 7fc:	fec42783          	lw	a5,-20(s0)
 800:	17c1                	addi	a5,a5,-16
 802:	97a2                	add	a5,a5,s0
 804:	fe07c703          	lbu	a4,-32(a5)
 808:	fcc42783          	lw	a5,-52(s0)
 80c:	85ba                	mv	a1,a4
 80e:	853e                	mv	a0,a5
 810:	00000097          	auipc	ra,0x0
 814:	eec080e7          	jalr	-276(ra) # 6fc <putc>
  while(--i >= 0)
 818:	fec42783          	lw	a5,-20(s0)
 81c:	37fd                	addiw	a5,a5,-1
 81e:	fef42623          	sw	a5,-20(s0)
 822:	fec42783          	lw	a5,-20(s0)
 826:	2781                	sext.w	a5,a5
 828:	fc07dae3          	bgez	a5,7fc <printint+0xca>
}
 82c:	0001                	nop
 82e:	0001                	nop
 830:	70e2                	ld	ra,56(sp)
 832:	7442                	ld	s0,48(sp)
 834:	6121                	addi	sp,sp,64
 836:	8082                	ret

0000000000000838 <printptr>:

static void
printptr(int fd, uint64 x) {
 838:	7179                	addi	sp,sp,-48
 83a:	f406                	sd	ra,40(sp)
 83c:	f022                	sd	s0,32(sp)
 83e:	1800                	addi	s0,sp,48
 840:	87aa                	mv	a5,a0
 842:	fcb43823          	sd	a1,-48(s0)
 846:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 84a:	fdc42783          	lw	a5,-36(s0)
 84e:	03000593          	li	a1,48
 852:	853e                	mv	a0,a5
 854:	00000097          	auipc	ra,0x0
 858:	ea8080e7          	jalr	-344(ra) # 6fc <putc>
  putc(fd, 'x');
 85c:	fdc42783          	lw	a5,-36(s0)
 860:	07800593          	li	a1,120
 864:	853e                	mv	a0,a5
 866:	00000097          	auipc	ra,0x0
 86a:	e96080e7          	jalr	-362(ra) # 6fc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 86e:	fe042623          	sw	zero,-20(s0)
 872:	a82d                	j	8ac <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 874:	fd043783          	ld	a5,-48(s0)
 878:	93f1                	srli	a5,a5,0x3c
 87a:	00000717          	auipc	a4,0x0
 87e:	78670713          	addi	a4,a4,1926 # 1000 <digits>
 882:	97ba                	add	a5,a5,a4
 884:	0007c703          	lbu	a4,0(a5)
 888:	fdc42783          	lw	a5,-36(s0)
 88c:	85ba                	mv	a1,a4
 88e:	853e                	mv	a0,a5
 890:	00000097          	auipc	ra,0x0
 894:	e6c080e7          	jalr	-404(ra) # 6fc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 898:	fec42783          	lw	a5,-20(s0)
 89c:	2785                	addiw	a5,a5,1
 89e:	fef42623          	sw	a5,-20(s0)
 8a2:	fd043783          	ld	a5,-48(s0)
 8a6:	0792                	slli	a5,a5,0x4
 8a8:	fcf43823          	sd	a5,-48(s0)
 8ac:	fec42703          	lw	a4,-20(s0)
 8b0:	47bd                	li	a5,15
 8b2:	fce7f1e3          	bgeu	a5,a4,874 <printptr+0x3c>
}
 8b6:	0001                	nop
 8b8:	0001                	nop
 8ba:	70a2                	ld	ra,40(sp)
 8bc:	7402                	ld	s0,32(sp)
 8be:	6145                	addi	sp,sp,48
 8c0:	8082                	ret

00000000000008c2 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 8c2:	715d                	addi	sp,sp,-80
 8c4:	e486                	sd	ra,72(sp)
 8c6:	e0a2                	sd	s0,64(sp)
 8c8:	0880                	addi	s0,sp,80
 8ca:	87aa                	mv	a5,a0
 8cc:	fcb43023          	sd	a1,-64(s0)
 8d0:	fac43c23          	sd	a2,-72(s0)
 8d4:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 8d8:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 8dc:	fe042223          	sw	zero,-28(s0)
 8e0:	a42d                	j	b0a <vprintf+0x248>
    c = fmt[i] & 0xff;
 8e2:	fe442783          	lw	a5,-28(s0)
 8e6:	fc043703          	ld	a4,-64(s0)
 8ea:	97ba                	add	a5,a5,a4
 8ec:	0007c783          	lbu	a5,0(a5)
 8f0:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 8f4:	fe042783          	lw	a5,-32(s0)
 8f8:	2781                	sext.w	a5,a5
 8fa:	eb9d                	bnez	a5,930 <vprintf+0x6e>
      if(c == '%'){
 8fc:	fdc42783          	lw	a5,-36(s0)
 900:	0007871b          	sext.w	a4,a5
 904:	02500793          	li	a5,37
 908:	00f71763          	bne	a4,a5,916 <vprintf+0x54>
        state = '%';
 90c:	02500793          	li	a5,37
 910:	fef42023          	sw	a5,-32(s0)
 914:	a2f5                	j	b00 <vprintf+0x23e>
      } else {
        putc(fd, c);
 916:	fdc42783          	lw	a5,-36(s0)
 91a:	0ff7f713          	zext.b	a4,a5
 91e:	fcc42783          	lw	a5,-52(s0)
 922:	85ba                	mv	a1,a4
 924:	853e                	mv	a0,a5
 926:	00000097          	auipc	ra,0x0
 92a:	dd6080e7          	jalr	-554(ra) # 6fc <putc>
 92e:	aac9                	j	b00 <vprintf+0x23e>
      }
    } else if(state == '%'){
 930:	fe042783          	lw	a5,-32(s0)
 934:	0007871b          	sext.w	a4,a5
 938:	02500793          	li	a5,37
 93c:	1cf71263          	bne	a4,a5,b00 <vprintf+0x23e>
      if(c == 'd'){
 940:	fdc42783          	lw	a5,-36(s0)
 944:	0007871b          	sext.w	a4,a5
 948:	06400793          	li	a5,100
 94c:	02f71463          	bne	a4,a5,974 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 950:	fb843783          	ld	a5,-72(s0)
 954:	00878713          	addi	a4,a5,8
 958:	fae43c23          	sd	a4,-72(s0)
 95c:	4398                	lw	a4,0(a5)
 95e:	fcc42783          	lw	a5,-52(s0)
 962:	4685                	li	a3,1
 964:	4629                	li	a2,10
 966:	85ba                	mv	a1,a4
 968:	853e                	mv	a0,a5
 96a:	00000097          	auipc	ra,0x0
 96e:	dc8080e7          	jalr	-568(ra) # 732 <printint>
 972:	a269                	j	afc <vprintf+0x23a>
      } else if(c == 'l') {
 974:	fdc42783          	lw	a5,-36(s0)
 978:	0007871b          	sext.w	a4,a5
 97c:	06c00793          	li	a5,108
 980:	02f71663          	bne	a4,a5,9ac <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 984:	fb843783          	ld	a5,-72(s0)
 988:	00878713          	addi	a4,a5,8
 98c:	fae43c23          	sd	a4,-72(s0)
 990:	639c                	ld	a5,0(a5)
 992:	0007871b          	sext.w	a4,a5
 996:	fcc42783          	lw	a5,-52(s0)
 99a:	4681                	li	a3,0
 99c:	4629                	li	a2,10
 99e:	85ba                	mv	a1,a4
 9a0:	853e                	mv	a0,a5
 9a2:	00000097          	auipc	ra,0x0
 9a6:	d90080e7          	jalr	-624(ra) # 732 <printint>
 9aa:	aa89                	j	afc <vprintf+0x23a>
      } else if(c == 'x') {
 9ac:	fdc42783          	lw	a5,-36(s0)
 9b0:	0007871b          	sext.w	a4,a5
 9b4:	07800793          	li	a5,120
 9b8:	02f71463          	bne	a4,a5,9e0 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 9bc:	fb843783          	ld	a5,-72(s0)
 9c0:	00878713          	addi	a4,a5,8
 9c4:	fae43c23          	sd	a4,-72(s0)
 9c8:	4398                	lw	a4,0(a5)
 9ca:	fcc42783          	lw	a5,-52(s0)
 9ce:	4681                	li	a3,0
 9d0:	4641                	li	a2,16
 9d2:	85ba                	mv	a1,a4
 9d4:	853e                	mv	a0,a5
 9d6:	00000097          	auipc	ra,0x0
 9da:	d5c080e7          	jalr	-676(ra) # 732 <printint>
 9de:	aa39                	j	afc <vprintf+0x23a>
      } else if(c == 'p') {
 9e0:	fdc42783          	lw	a5,-36(s0)
 9e4:	0007871b          	sext.w	a4,a5
 9e8:	07000793          	li	a5,112
 9ec:	02f71263          	bne	a4,a5,a10 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 9f0:	fb843783          	ld	a5,-72(s0)
 9f4:	00878713          	addi	a4,a5,8
 9f8:	fae43c23          	sd	a4,-72(s0)
 9fc:	6398                	ld	a4,0(a5)
 9fe:	fcc42783          	lw	a5,-52(s0)
 a02:	85ba                	mv	a1,a4
 a04:	853e                	mv	a0,a5
 a06:	00000097          	auipc	ra,0x0
 a0a:	e32080e7          	jalr	-462(ra) # 838 <printptr>
 a0e:	a0fd                	j	afc <vprintf+0x23a>
      } else if(c == 's'){
 a10:	fdc42783          	lw	a5,-36(s0)
 a14:	0007871b          	sext.w	a4,a5
 a18:	07300793          	li	a5,115
 a1c:	04f71c63          	bne	a4,a5,a74 <vprintf+0x1b2>
        s = va_arg(ap, char*);
 a20:	fb843783          	ld	a5,-72(s0)
 a24:	00878713          	addi	a4,a5,8
 a28:	fae43c23          	sd	a4,-72(s0)
 a2c:	639c                	ld	a5,0(a5)
 a2e:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 a32:	fe843783          	ld	a5,-24(s0)
 a36:	eb8d                	bnez	a5,a68 <vprintf+0x1a6>
          s = "(null)";
 a38:	00000797          	auipc	a5,0x0
 a3c:	4b878793          	addi	a5,a5,1208 # ef0 <malloc+0x17c>
 a40:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 a44:	a015                	j	a68 <vprintf+0x1a6>
          putc(fd, *s);
 a46:	fe843783          	ld	a5,-24(s0)
 a4a:	0007c703          	lbu	a4,0(a5)
 a4e:	fcc42783          	lw	a5,-52(s0)
 a52:	85ba                	mv	a1,a4
 a54:	853e                	mv	a0,a5
 a56:	00000097          	auipc	ra,0x0
 a5a:	ca6080e7          	jalr	-858(ra) # 6fc <putc>
          s++;
 a5e:	fe843783          	ld	a5,-24(s0)
 a62:	0785                	addi	a5,a5,1
 a64:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 a68:	fe843783          	ld	a5,-24(s0)
 a6c:	0007c783          	lbu	a5,0(a5)
 a70:	fbf9                	bnez	a5,a46 <vprintf+0x184>
 a72:	a069                	j	afc <vprintf+0x23a>
        }
      } else if(c == 'c'){
 a74:	fdc42783          	lw	a5,-36(s0)
 a78:	0007871b          	sext.w	a4,a5
 a7c:	06300793          	li	a5,99
 a80:	02f71463          	bne	a4,a5,aa8 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 a84:	fb843783          	ld	a5,-72(s0)
 a88:	00878713          	addi	a4,a5,8
 a8c:	fae43c23          	sd	a4,-72(s0)
 a90:	439c                	lw	a5,0(a5)
 a92:	0ff7f713          	zext.b	a4,a5
 a96:	fcc42783          	lw	a5,-52(s0)
 a9a:	85ba                	mv	a1,a4
 a9c:	853e                	mv	a0,a5
 a9e:	00000097          	auipc	ra,0x0
 aa2:	c5e080e7          	jalr	-930(ra) # 6fc <putc>
 aa6:	a899                	j	afc <vprintf+0x23a>
      } else if(c == '%'){
 aa8:	fdc42783          	lw	a5,-36(s0)
 aac:	0007871b          	sext.w	a4,a5
 ab0:	02500793          	li	a5,37
 ab4:	00f71f63          	bne	a4,a5,ad2 <vprintf+0x210>
        putc(fd, c);
 ab8:	fdc42783          	lw	a5,-36(s0)
 abc:	0ff7f713          	zext.b	a4,a5
 ac0:	fcc42783          	lw	a5,-52(s0)
 ac4:	85ba                	mv	a1,a4
 ac6:	853e                	mv	a0,a5
 ac8:	00000097          	auipc	ra,0x0
 acc:	c34080e7          	jalr	-972(ra) # 6fc <putc>
 ad0:	a035                	j	afc <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 ad2:	fcc42783          	lw	a5,-52(s0)
 ad6:	02500593          	li	a1,37
 ada:	853e                	mv	a0,a5
 adc:	00000097          	auipc	ra,0x0
 ae0:	c20080e7          	jalr	-992(ra) # 6fc <putc>
        putc(fd, c);
 ae4:	fdc42783          	lw	a5,-36(s0)
 ae8:	0ff7f713          	zext.b	a4,a5
 aec:	fcc42783          	lw	a5,-52(s0)
 af0:	85ba                	mv	a1,a4
 af2:	853e                	mv	a0,a5
 af4:	00000097          	auipc	ra,0x0
 af8:	c08080e7          	jalr	-1016(ra) # 6fc <putc>
      }
      state = 0;
 afc:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 b00:	fe442783          	lw	a5,-28(s0)
 b04:	2785                	addiw	a5,a5,1
 b06:	fef42223          	sw	a5,-28(s0)
 b0a:	fe442783          	lw	a5,-28(s0)
 b0e:	fc043703          	ld	a4,-64(s0)
 b12:	97ba                	add	a5,a5,a4
 b14:	0007c783          	lbu	a5,0(a5)
 b18:	dc0795e3          	bnez	a5,8e2 <vprintf+0x20>
    }
  }
}
 b1c:	0001                	nop
 b1e:	0001                	nop
 b20:	60a6                	ld	ra,72(sp)
 b22:	6406                	ld	s0,64(sp)
 b24:	6161                	addi	sp,sp,80
 b26:	8082                	ret

0000000000000b28 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b28:	7159                	addi	sp,sp,-112
 b2a:	fc06                	sd	ra,56(sp)
 b2c:	f822                	sd	s0,48(sp)
 b2e:	0080                	addi	s0,sp,64
 b30:	fcb43823          	sd	a1,-48(s0)
 b34:	e010                	sd	a2,0(s0)
 b36:	e414                	sd	a3,8(s0)
 b38:	e818                	sd	a4,16(s0)
 b3a:	ec1c                	sd	a5,24(s0)
 b3c:	03043023          	sd	a6,32(s0)
 b40:	03143423          	sd	a7,40(s0)
 b44:	87aa                	mv	a5,a0
 b46:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 b4a:	03040793          	addi	a5,s0,48
 b4e:	fcf43423          	sd	a5,-56(s0)
 b52:	fc843783          	ld	a5,-56(s0)
 b56:	fd078793          	addi	a5,a5,-48
 b5a:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 b5e:	fe843703          	ld	a4,-24(s0)
 b62:	fdc42783          	lw	a5,-36(s0)
 b66:	863a                	mv	a2,a4
 b68:	fd043583          	ld	a1,-48(s0)
 b6c:	853e                	mv	a0,a5
 b6e:	00000097          	auipc	ra,0x0
 b72:	d54080e7          	jalr	-684(ra) # 8c2 <vprintf>
}
 b76:	0001                	nop
 b78:	70e2                	ld	ra,56(sp)
 b7a:	7442                	ld	s0,48(sp)
 b7c:	6165                	addi	sp,sp,112
 b7e:	8082                	ret

0000000000000b80 <printf>:

void
printf(const char *fmt, ...)
{
 b80:	7159                	addi	sp,sp,-112
 b82:	f406                	sd	ra,40(sp)
 b84:	f022                	sd	s0,32(sp)
 b86:	1800                	addi	s0,sp,48
 b88:	fca43c23          	sd	a0,-40(s0)
 b8c:	e40c                	sd	a1,8(s0)
 b8e:	e810                	sd	a2,16(s0)
 b90:	ec14                	sd	a3,24(s0)
 b92:	f018                	sd	a4,32(s0)
 b94:	f41c                	sd	a5,40(s0)
 b96:	03043823          	sd	a6,48(s0)
 b9a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b9e:	04040793          	addi	a5,s0,64
 ba2:	fcf43823          	sd	a5,-48(s0)
 ba6:	fd043783          	ld	a5,-48(s0)
 baa:	fc878793          	addi	a5,a5,-56
 bae:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 bb2:	fe843783          	ld	a5,-24(s0)
 bb6:	863e                	mv	a2,a5
 bb8:	fd843583          	ld	a1,-40(s0)
 bbc:	4505                	li	a0,1
 bbe:	00000097          	auipc	ra,0x0
 bc2:	d04080e7          	jalr	-764(ra) # 8c2 <vprintf>
}
 bc6:	0001                	nop
 bc8:	70a2                	ld	ra,40(sp)
 bca:	7402                	ld	s0,32(sp)
 bcc:	6165                	addi	sp,sp,112
 bce:	8082                	ret

0000000000000bd0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 bd0:	7179                	addi	sp,sp,-48
 bd2:	f406                	sd	ra,40(sp)
 bd4:	f022                	sd	s0,32(sp)
 bd6:	1800                	addi	s0,sp,48
 bd8:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 bdc:	fd843783          	ld	a5,-40(s0)
 be0:	17c1                	addi	a5,a5,-16
 be2:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 be6:	00000797          	auipc	a5,0x0
 bea:	44a78793          	addi	a5,a5,1098 # 1030 <freep>
 bee:	639c                	ld	a5,0(a5)
 bf0:	fef43423          	sd	a5,-24(s0)
 bf4:	a815                	j	c28 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bf6:	fe843783          	ld	a5,-24(s0)
 bfa:	639c                	ld	a5,0(a5)
 bfc:	fe843703          	ld	a4,-24(s0)
 c00:	00f76f63          	bltu	a4,a5,c1e <free+0x4e>
 c04:	fe043703          	ld	a4,-32(s0)
 c08:	fe843783          	ld	a5,-24(s0)
 c0c:	02e7eb63          	bltu	a5,a4,c42 <free+0x72>
 c10:	fe843783          	ld	a5,-24(s0)
 c14:	639c                	ld	a5,0(a5)
 c16:	fe043703          	ld	a4,-32(s0)
 c1a:	02f76463          	bltu	a4,a5,c42 <free+0x72>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c1e:	fe843783          	ld	a5,-24(s0)
 c22:	639c                	ld	a5,0(a5)
 c24:	fef43423          	sd	a5,-24(s0)
 c28:	fe043703          	ld	a4,-32(s0)
 c2c:	fe843783          	ld	a5,-24(s0)
 c30:	fce7f3e3          	bgeu	a5,a4,bf6 <free+0x26>
 c34:	fe843783          	ld	a5,-24(s0)
 c38:	639c                	ld	a5,0(a5)
 c3a:	fe043703          	ld	a4,-32(s0)
 c3e:	faf77ce3          	bgeu	a4,a5,bf6 <free+0x26>
      break;
  if(bp + bp->s.size == p->s.ptr){
 c42:	fe043783          	ld	a5,-32(s0)
 c46:	479c                	lw	a5,8(a5)
 c48:	1782                	slli	a5,a5,0x20
 c4a:	9381                	srli	a5,a5,0x20
 c4c:	0792                	slli	a5,a5,0x4
 c4e:	fe043703          	ld	a4,-32(s0)
 c52:	973e                	add	a4,a4,a5
 c54:	fe843783          	ld	a5,-24(s0)
 c58:	639c                	ld	a5,0(a5)
 c5a:	02f71763          	bne	a4,a5,c88 <free+0xb8>
    bp->s.size += p->s.ptr->s.size;
 c5e:	fe043783          	ld	a5,-32(s0)
 c62:	4798                	lw	a4,8(a5)
 c64:	fe843783          	ld	a5,-24(s0)
 c68:	639c                	ld	a5,0(a5)
 c6a:	479c                	lw	a5,8(a5)
 c6c:	9fb9                	addw	a5,a5,a4
 c6e:	0007871b          	sext.w	a4,a5
 c72:	fe043783          	ld	a5,-32(s0)
 c76:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 c78:	fe843783          	ld	a5,-24(s0)
 c7c:	639c                	ld	a5,0(a5)
 c7e:	6398                	ld	a4,0(a5)
 c80:	fe043783          	ld	a5,-32(s0)
 c84:	e398                	sd	a4,0(a5)
 c86:	a039                	j	c94 <free+0xc4>
  } else
    bp->s.ptr = p->s.ptr;
 c88:	fe843783          	ld	a5,-24(s0)
 c8c:	6398                	ld	a4,0(a5)
 c8e:	fe043783          	ld	a5,-32(s0)
 c92:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 c94:	fe843783          	ld	a5,-24(s0)
 c98:	479c                	lw	a5,8(a5)
 c9a:	1782                	slli	a5,a5,0x20
 c9c:	9381                	srli	a5,a5,0x20
 c9e:	0792                	slli	a5,a5,0x4
 ca0:	fe843703          	ld	a4,-24(s0)
 ca4:	97ba                	add	a5,a5,a4
 ca6:	fe043703          	ld	a4,-32(s0)
 caa:	02f71563          	bne	a4,a5,cd4 <free+0x104>
    p->s.size += bp->s.size;
 cae:	fe843783          	ld	a5,-24(s0)
 cb2:	4798                	lw	a4,8(a5)
 cb4:	fe043783          	ld	a5,-32(s0)
 cb8:	479c                	lw	a5,8(a5)
 cba:	9fb9                	addw	a5,a5,a4
 cbc:	0007871b          	sext.w	a4,a5
 cc0:	fe843783          	ld	a5,-24(s0)
 cc4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 cc6:	fe043783          	ld	a5,-32(s0)
 cca:	6398                	ld	a4,0(a5)
 ccc:	fe843783          	ld	a5,-24(s0)
 cd0:	e398                	sd	a4,0(a5)
 cd2:	a031                	j	cde <free+0x10e>
  } else
    p->s.ptr = bp;
 cd4:	fe843783          	ld	a5,-24(s0)
 cd8:	fe043703          	ld	a4,-32(s0)
 cdc:	e398                	sd	a4,0(a5)
  freep = p;
 cde:	00000797          	auipc	a5,0x0
 ce2:	35278793          	addi	a5,a5,850 # 1030 <freep>
 ce6:	fe843703          	ld	a4,-24(s0)
 cea:	e398                	sd	a4,0(a5)
}
 cec:	0001                	nop
 cee:	70a2                	ld	ra,40(sp)
 cf0:	7402                	ld	s0,32(sp)
 cf2:	6145                	addi	sp,sp,48
 cf4:	8082                	ret

0000000000000cf6 <morecore>:

static Header*
morecore(uint nu)
{
 cf6:	7179                	addi	sp,sp,-48
 cf8:	f406                	sd	ra,40(sp)
 cfa:	f022                	sd	s0,32(sp)
 cfc:	1800                	addi	s0,sp,48
 cfe:	87aa                	mv	a5,a0
 d00:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 d04:	fdc42783          	lw	a5,-36(s0)
 d08:	0007871b          	sext.w	a4,a5
 d0c:	6785                	lui	a5,0x1
 d0e:	00f77563          	bgeu	a4,a5,d18 <morecore+0x22>
    nu = 4096;
 d12:	6785                	lui	a5,0x1
 d14:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 d18:	fdc42783          	lw	a5,-36(s0)
 d1c:	0047979b          	slliw	a5,a5,0x4
 d20:	2781                	sext.w	a5,a5
 d22:	853e                	mv	a0,a5
 d24:	00000097          	auipc	ra,0x0
 d28:	9b8080e7          	jalr	-1608(ra) # 6dc <sbrk>
 d2c:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 d30:	fe843703          	ld	a4,-24(s0)
 d34:	57fd                	li	a5,-1
 d36:	00f71463          	bne	a4,a5,d3e <morecore+0x48>
    return 0;
 d3a:	4781                	li	a5,0
 d3c:	a03d                	j	d6a <morecore+0x74>
  hp = (Header*)p;
 d3e:	fe843783          	ld	a5,-24(s0)
 d42:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 d46:	fe043783          	ld	a5,-32(s0)
 d4a:	fdc42703          	lw	a4,-36(s0)
 d4e:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 d50:	fe043783          	ld	a5,-32(s0)
 d54:	07c1                	addi	a5,a5,16 # 1010 <digits+0x10>
 d56:	853e                	mv	a0,a5
 d58:	00000097          	auipc	ra,0x0
 d5c:	e78080e7          	jalr	-392(ra) # bd0 <free>
  return freep;
 d60:	00000797          	auipc	a5,0x0
 d64:	2d078793          	addi	a5,a5,720 # 1030 <freep>
 d68:	639c                	ld	a5,0(a5)
}
 d6a:	853e                	mv	a0,a5
 d6c:	70a2                	ld	ra,40(sp)
 d6e:	7402                	ld	s0,32(sp)
 d70:	6145                	addi	sp,sp,48
 d72:	8082                	ret

0000000000000d74 <malloc>:

void*
malloc(uint nbytes)
{
 d74:	7139                	addi	sp,sp,-64
 d76:	fc06                	sd	ra,56(sp)
 d78:	f822                	sd	s0,48(sp)
 d7a:	0080                	addi	s0,sp,64
 d7c:	87aa                	mv	a5,a0
 d7e:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d82:	fcc46783          	lwu	a5,-52(s0)
 d86:	07bd                	addi	a5,a5,15
 d88:	8391                	srli	a5,a5,0x4
 d8a:	2781                	sext.w	a5,a5
 d8c:	2785                	addiw	a5,a5,1
 d8e:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 d92:	00000797          	auipc	a5,0x0
 d96:	29e78793          	addi	a5,a5,670 # 1030 <freep>
 d9a:	639c                	ld	a5,0(a5)
 d9c:	fef43023          	sd	a5,-32(s0)
 da0:	fe043783          	ld	a5,-32(s0)
 da4:	ef95                	bnez	a5,de0 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 da6:	00000797          	auipc	a5,0x0
 daa:	27a78793          	addi	a5,a5,634 # 1020 <base>
 dae:	fef43023          	sd	a5,-32(s0)
 db2:	00000797          	auipc	a5,0x0
 db6:	27e78793          	addi	a5,a5,638 # 1030 <freep>
 dba:	fe043703          	ld	a4,-32(s0)
 dbe:	e398                	sd	a4,0(a5)
 dc0:	00000797          	auipc	a5,0x0
 dc4:	27078793          	addi	a5,a5,624 # 1030 <freep>
 dc8:	6398                	ld	a4,0(a5)
 dca:	00000797          	auipc	a5,0x0
 dce:	25678793          	addi	a5,a5,598 # 1020 <base>
 dd2:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 dd4:	00000797          	auipc	a5,0x0
 dd8:	24c78793          	addi	a5,a5,588 # 1020 <base>
 ddc:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 de0:	fe043783          	ld	a5,-32(s0)
 de4:	639c                	ld	a5,0(a5)
 de6:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 dea:	fe843783          	ld	a5,-24(s0)
 dee:	479c                	lw	a5,8(a5)
 df0:	fdc42703          	lw	a4,-36(s0)
 df4:	2701                	sext.w	a4,a4
 df6:	06e7e763          	bltu	a5,a4,e64 <malloc+0xf0>
      if(p->s.size == nunits)
 dfa:	fe843783          	ld	a5,-24(s0)
 dfe:	479c                	lw	a5,8(a5)
 e00:	fdc42703          	lw	a4,-36(s0)
 e04:	2701                	sext.w	a4,a4
 e06:	00f71963          	bne	a4,a5,e18 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 e0a:	fe843783          	ld	a5,-24(s0)
 e0e:	6398                	ld	a4,0(a5)
 e10:	fe043783          	ld	a5,-32(s0)
 e14:	e398                	sd	a4,0(a5)
 e16:	a825                	j	e4e <malloc+0xda>
      else {
        p->s.size -= nunits;
 e18:	fe843783          	ld	a5,-24(s0)
 e1c:	479c                	lw	a5,8(a5)
 e1e:	fdc42703          	lw	a4,-36(s0)
 e22:	9f99                	subw	a5,a5,a4
 e24:	0007871b          	sext.w	a4,a5
 e28:	fe843783          	ld	a5,-24(s0)
 e2c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 e2e:	fe843783          	ld	a5,-24(s0)
 e32:	479c                	lw	a5,8(a5)
 e34:	1782                	slli	a5,a5,0x20
 e36:	9381                	srli	a5,a5,0x20
 e38:	0792                	slli	a5,a5,0x4
 e3a:	fe843703          	ld	a4,-24(s0)
 e3e:	97ba                	add	a5,a5,a4
 e40:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 e44:	fe843783          	ld	a5,-24(s0)
 e48:	fdc42703          	lw	a4,-36(s0)
 e4c:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 e4e:	00000797          	auipc	a5,0x0
 e52:	1e278793          	addi	a5,a5,482 # 1030 <freep>
 e56:	fe043703          	ld	a4,-32(s0)
 e5a:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 e5c:	fe843783          	ld	a5,-24(s0)
 e60:	07c1                	addi	a5,a5,16
 e62:	a091                	j	ea6 <malloc+0x132>
    }
    if(p == freep)
 e64:	00000797          	auipc	a5,0x0
 e68:	1cc78793          	addi	a5,a5,460 # 1030 <freep>
 e6c:	639c                	ld	a5,0(a5)
 e6e:	fe843703          	ld	a4,-24(s0)
 e72:	02f71063          	bne	a4,a5,e92 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 e76:	fdc42783          	lw	a5,-36(s0)
 e7a:	853e                	mv	a0,a5
 e7c:	00000097          	auipc	ra,0x0
 e80:	e7a080e7          	jalr	-390(ra) # cf6 <morecore>
 e84:	fea43423          	sd	a0,-24(s0)
 e88:	fe843783          	ld	a5,-24(s0)
 e8c:	e399                	bnez	a5,e92 <malloc+0x11e>
        return 0;
 e8e:	4781                	li	a5,0
 e90:	a819                	j	ea6 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e92:	fe843783          	ld	a5,-24(s0)
 e96:	fef43023          	sd	a5,-32(s0)
 e9a:	fe843783          	ld	a5,-24(s0)
 e9e:	639c                	ld	a5,0(a5)
 ea0:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 ea4:	b799                	j	dea <malloc+0x76>
  }
}
 ea6:	853e                	mv	a0,a5
 ea8:	70e2                	ld	ra,56(sp)
 eaa:	7442                	ld	s0,48(sp)
 eac:	6121                	addi	sp,sp,64
 eae:	8082                	ret
