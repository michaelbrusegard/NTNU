
user/_hello:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char *argv[]) {
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
   8:	87aa                	mv	a5,a0
   a:	feb43023          	sd	a1,-32(s0)
   e:	fef42623          	sw	a5,-20(s0)
  if (argc < 2) {
  12:	fec42783          	lw	a5,-20(s0)
  16:	0007871b          	sext.w	a4,a5
  1a:	4785                	li	a5,1
  1c:	00e7cb63          	blt	a5,a4,32 <main+0x32>
    printf("Hello World!\n");
  20:	00001517          	auipc	a0,0x1
  24:	d6050513          	addi	a0,a0,-672 # d80 <malloc+0x148>
  28:	00001097          	auipc	ra,0x1
  2c:	a1c080e7          	jalr	-1508(ra) # a44 <printf>
  30:	a831                	j	4c <main+0x4c>
  } else {
    printf("Nice to meet you %s!\n", argv[1]);
  32:	fe043783          	ld	a5,-32(s0)
  36:	07a1                	addi	a5,a5,8
  38:	639c                	ld	a5,0(a5)
  3a:	85be                	mv	a1,a5
  3c:	00001517          	auipc	a0,0x1
  40:	d5450513          	addi	a0,a0,-684 # d90 <malloc+0x158>
  44:	00001097          	auipc	ra,0x1
  48:	a00080e7          	jalr	-1536(ra) # a44 <printf>
  }
  exit(0);
  4c:	4501                	li	a0,0
  4e:	00000097          	auipc	ra,0x0
  52:	4d2080e7          	jalr	1234(ra) # 520 <exit>

0000000000000056 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  56:	1141                	addi	sp,sp,-16
  58:	e406                	sd	ra,8(sp)
  5a:	e022                	sd	s0,0(sp)
  5c:	0800                	addi	s0,sp,16
  extern int main();
  main();
  5e:	00000097          	auipc	ra,0x0
  62:	fa2080e7          	jalr	-94(ra) # 0 <main>
  exit(0);
  66:	4501                	li	a0,0
  68:	00000097          	auipc	ra,0x0
  6c:	4b8080e7          	jalr	1208(ra) # 520 <exit>

0000000000000070 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  70:	7179                	addi	sp,sp,-48
  72:	f406                	sd	ra,40(sp)
  74:	f022                	sd	s0,32(sp)
  76:	1800                	addi	s0,sp,48
  78:	fca43c23          	sd	a0,-40(s0)
  7c:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
  80:	fd843783          	ld	a5,-40(s0)
  84:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
  88:	0001                	nop
  8a:	fd043703          	ld	a4,-48(s0)
  8e:	00170793          	addi	a5,a4,1
  92:	fcf43823          	sd	a5,-48(s0)
  96:	fd843783          	ld	a5,-40(s0)
  9a:	00178693          	addi	a3,a5,1
  9e:	fcd43c23          	sd	a3,-40(s0)
  a2:	00074703          	lbu	a4,0(a4)
  a6:	00e78023          	sb	a4,0(a5)
  aa:	0007c783          	lbu	a5,0(a5)
  ae:	fff1                	bnez	a5,8a <strcpy+0x1a>
    ;
  return os;
  b0:	fe843783          	ld	a5,-24(s0)
}
  b4:	853e                	mv	a0,a5
  b6:	70a2                	ld	ra,40(sp)
  b8:	7402                	ld	s0,32(sp)
  ba:	6145                	addi	sp,sp,48
  bc:	8082                	ret

00000000000000be <strcmp>:

int
strcmp(const char *p, const char *q)
{
  be:	1101                	addi	sp,sp,-32
  c0:	ec06                	sd	ra,24(sp)
  c2:	e822                	sd	s0,16(sp)
  c4:	1000                	addi	s0,sp,32
  c6:	fea43423          	sd	a0,-24(s0)
  ca:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
  ce:	a819                	j	e4 <strcmp+0x26>
    p++, q++;
  d0:	fe843783          	ld	a5,-24(s0)
  d4:	0785                	addi	a5,a5,1
  d6:	fef43423          	sd	a5,-24(s0)
  da:	fe043783          	ld	a5,-32(s0)
  de:	0785                	addi	a5,a5,1
  e0:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
  e4:	fe843783          	ld	a5,-24(s0)
  e8:	0007c783          	lbu	a5,0(a5)
  ec:	cb99                	beqz	a5,102 <strcmp+0x44>
  ee:	fe843783          	ld	a5,-24(s0)
  f2:	0007c703          	lbu	a4,0(a5)
  f6:	fe043783          	ld	a5,-32(s0)
  fa:	0007c783          	lbu	a5,0(a5)
  fe:	fcf709e3          	beq	a4,a5,d0 <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
 102:	fe843783          	ld	a5,-24(s0)
 106:	0007c783          	lbu	a5,0(a5)
 10a:	0007871b          	sext.w	a4,a5
 10e:	fe043783          	ld	a5,-32(s0)
 112:	0007c783          	lbu	a5,0(a5)
 116:	2781                	sext.w	a5,a5
 118:	40f707bb          	subw	a5,a4,a5
 11c:	2781                	sext.w	a5,a5
}
 11e:	853e                	mv	a0,a5
 120:	60e2                	ld	ra,24(sp)
 122:	6442                	ld	s0,16(sp)
 124:	6105                	addi	sp,sp,32
 126:	8082                	ret

0000000000000128 <strlen>:

uint
strlen(const char *s)
{
 128:	7179                	addi	sp,sp,-48
 12a:	f406                	sd	ra,40(sp)
 12c:	f022                	sd	s0,32(sp)
 12e:	1800                	addi	s0,sp,48
 130:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
 134:	fe042623          	sw	zero,-20(s0)
 138:	a031                	j	144 <strlen+0x1c>
 13a:	fec42783          	lw	a5,-20(s0)
 13e:	2785                	addiw	a5,a5,1
 140:	fef42623          	sw	a5,-20(s0)
 144:	fec42783          	lw	a5,-20(s0)
 148:	fd843703          	ld	a4,-40(s0)
 14c:	97ba                	add	a5,a5,a4
 14e:	0007c783          	lbu	a5,0(a5)
 152:	f7e5                	bnez	a5,13a <strlen+0x12>
    ;
  return n;
 154:	fec42783          	lw	a5,-20(s0)
}
 158:	853e                	mv	a0,a5
 15a:	70a2                	ld	ra,40(sp)
 15c:	7402                	ld	s0,32(sp)
 15e:	6145                	addi	sp,sp,48
 160:	8082                	ret

0000000000000162 <memset>:

void*
memset(void *dst, int c, uint n)
{
 162:	7179                	addi	sp,sp,-48
 164:	f406                	sd	ra,40(sp)
 166:	f022                	sd	s0,32(sp)
 168:	1800                	addi	s0,sp,48
 16a:	fca43c23          	sd	a0,-40(s0)
 16e:	87ae                	mv	a5,a1
 170:	8732                	mv	a4,a2
 172:	fcf42a23          	sw	a5,-44(s0)
 176:	87ba                	mv	a5,a4
 178:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
 17c:	fd843783          	ld	a5,-40(s0)
 180:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
 184:	fe042623          	sw	zero,-20(s0)
 188:	a00d                	j	1aa <memset+0x48>
    cdst[i] = c;
 18a:	fec42783          	lw	a5,-20(s0)
 18e:	fe043703          	ld	a4,-32(s0)
 192:	97ba                	add	a5,a5,a4
 194:	fd442703          	lw	a4,-44(s0)
 198:	0ff77713          	zext.b	a4,a4
 19c:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
 1a0:	fec42783          	lw	a5,-20(s0)
 1a4:	2785                	addiw	a5,a5,1
 1a6:	fef42623          	sw	a5,-20(s0)
 1aa:	fec42783          	lw	a5,-20(s0)
 1ae:	fd042703          	lw	a4,-48(s0)
 1b2:	2701                	sext.w	a4,a4
 1b4:	fce7ebe3          	bltu	a5,a4,18a <memset+0x28>
  }
  return dst;
 1b8:	fd843783          	ld	a5,-40(s0)
}
 1bc:	853e                	mv	a0,a5
 1be:	70a2                	ld	ra,40(sp)
 1c0:	7402                	ld	s0,32(sp)
 1c2:	6145                	addi	sp,sp,48
 1c4:	8082                	ret

00000000000001c6 <strchr>:

char*
strchr(const char *s, char c)
{
 1c6:	1101                	addi	sp,sp,-32
 1c8:	ec06                	sd	ra,24(sp)
 1ca:	e822                	sd	s0,16(sp)
 1cc:	1000                	addi	s0,sp,32
 1ce:	fea43423          	sd	a0,-24(s0)
 1d2:	87ae                	mv	a5,a1
 1d4:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
 1d8:	a01d                	j	1fe <strchr+0x38>
    if(*s == c)
 1da:	fe843783          	ld	a5,-24(s0)
 1de:	0007c703          	lbu	a4,0(a5)
 1e2:	fe744783          	lbu	a5,-25(s0)
 1e6:	0ff7f793          	zext.b	a5,a5
 1ea:	00e79563          	bne	a5,a4,1f4 <strchr+0x2e>
      return (char*)s;
 1ee:	fe843783          	ld	a5,-24(s0)
 1f2:	a821                	j	20a <strchr+0x44>
  for(; *s; s++)
 1f4:	fe843783          	ld	a5,-24(s0)
 1f8:	0785                	addi	a5,a5,1
 1fa:	fef43423          	sd	a5,-24(s0)
 1fe:	fe843783          	ld	a5,-24(s0)
 202:	0007c783          	lbu	a5,0(a5)
 206:	fbf1                	bnez	a5,1da <strchr+0x14>
  return 0;
 208:	4781                	li	a5,0
}
 20a:	853e                	mv	a0,a5
 20c:	60e2                	ld	ra,24(sp)
 20e:	6442                	ld	s0,16(sp)
 210:	6105                	addi	sp,sp,32
 212:	8082                	ret

0000000000000214 <gets>:

char*
gets(char *buf, int max)
{
 214:	7179                	addi	sp,sp,-48
 216:	f406                	sd	ra,40(sp)
 218:	f022                	sd	s0,32(sp)
 21a:	1800                	addi	s0,sp,48
 21c:	fca43c23          	sd	a0,-40(s0)
 220:	87ae                	mv	a5,a1
 222:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 226:	fe042623          	sw	zero,-20(s0)
 22a:	a8a1                	j	282 <gets+0x6e>
    cc = read(0, &c, 1);
 22c:	fe740793          	addi	a5,s0,-25
 230:	4605                	li	a2,1
 232:	85be                	mv	a1,a5
 234:	4501                	li	a0,0
 236:	00000097          	auipc	ra,0x0
 23a:	302080e7          	jalr	770(ra) # 538 <read>
 23e:	87aa                	mv	a5,a0
 240:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
 244:	fe842783          	lw	a5,-24(s0)
 248:	2781                	sext.w	a5,a5
 24a:	04f05663          	blez	a5,296 <gets+0x82>
      break;
    buf[i++] = c;
 24e:	fec42783          	lw	a5,-20(s0)
 252:	0017871b          	addiw	a4,a5,1
 256:	fee42623          	sw	a4,-20(s0)
 25a:	873e                	mv	a4,a5
 25c:	fd843783          	ld	a5,-40(s0)
 260:	97ba                	add	a5,a5,a4
 262:	fe744703          	lbu	a4,-25(s0)
 266:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
 26a:	fe744783          	lbu	a5,-25(s0)
 26e:	873e                	mv	a4,a5
 270:	47a9                	li	a5,10
 272:	02f70363          	beq	a4,a5,298 <gets+0x84>
 276:	fe744783          	lbu	a5,-25(s0)
 27a:	873e                	mv	a4,a5
 27c:	47b5                	li	a5,13
 27e:	00f70d63          	beq	a4,a5,298 <gets+0x84>
  for(i=0; i+1 < max; ){
 282:	fec42783          	lw	a5,-20(s0)
 286:	2785                	addiw	a5,a5,1
 288:	2781                	sext.w	a5,a5
 28a:	fd442703          	lw	a4,-44(s0)
 28e:	2701                	sext.w	a4,a4
 290:	f8e7cee3          	blt	a5,a4,22c <gets+0x18>
 294:	a011                	j	298 <gets+0x84>
      break;
 296:	0001                	nop
      break;
  }
  buf[i] = '\0';
 298:	fec42783          	lw	a5,-20(s0)
 29c:	fd843703          	ld	a4,-40(s0)
 2a0:	97ba                	add	a5,a5,a4
 2a2:	00078023          	sb	zero,0(a5)
  return buf;
 2a6:	fd843783          	ld	a5,-40(s0)
}
 2aa:	853e                	mv	a0,a5
 2ac:	70a2                	ld	ra,40(sp)
 2ae:	7402                	ld	s0,32(sp)
 2b0:	6145                	addi	sp,sp,48
 2b2:	8082                	ret

00000000000002b4 <stat>:

int
stat(const char *n, struct stat *st)
{
 2b4:	7179                	addi	sp,sp,-48
 2b6:	f406                	sd	ra,40(sp)
 2b8:	f022                	sd	s0,32(sp)
 2ba:	1800                	addi	s0,sp,48
 2bc:	fca43c23          	sd	a0,-40(s0)
 2c0:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c4:	4581                	li	a1,0
 2c6:	fd843503          	ld	a0,-40(s0)
 2ca:	00000097          	auipc	ra,0x0
 2ce:	296080e7          	jalr	662(ra) # 560 <open>
 2d2:	87aa                	mv	a5,a0
 2d4:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
 2d8:	fec42783          	lw	a5,-20(s0)
 2dc:	2781                	sext.w	a5,a5
 2de:	0007d463          	bgez	a5,2e6 <stat+0x32>
    return -1;
 2e2:	57fd                	li	a5,-1
 2e4:	a035                	j	310 <stat+0x5c>
  r = fstat(fd, st);
 2e6:	fec42783          	lw	a5,-20(s0)
 2ea:	fd043583          	ld	a1,-48(s0)
 2ee:	853e                	mv	a0,a5
 2f0:	00000097          	auipc	ra,0x0
 2f4:	288080e7          	jalr	648(ra) # 578 <fstat>
 2f8:	87aa                	mv	a5,a0
 2fa:	fef42423          	sw	a5,-24(s0)
  close(fd);
 2fe:	fec42783          	lw	a5,-20(s0)
 302:	853e                	mv	a0,a5
 304:	00000097          	auipc	ra,0x0
 308:	244080e7          	jalr	580(ra) # 548 <close>
  return r;
 30c:	fe842783          	lw	a5,-24(s0)
}
 310:	853e                	mv	a0,a5
 312:	70a2                	ld	ra,40(sp)
 314:	7402                	ld	s0,32(sp)
 316:	6145                	addi	sp,sp,48
 318:	8082                	ret

000000000000031a <atoi>:

int
atoi(const char *s)
{
 31a:	7179                	addi	sp,sp,-48
 31c:	f406                	sd	ra,40(sp)
 31e:	f022                	sd	s0,32(sp)
 320:	1800                	addi	s0,sp,48
 322:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
 326:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
 32a:	a81d                	j	360 <atoi+0x46>
    n = n*10 + *s++ - '0';
 32c:	fec42783          	lw	a5,-20(s0)
 330:	873e                	mv	a4,a5
 332:	87ba                	mv	a5,a4
 334:	0027979b          	slliw	a5,a5,0x2
 338:	9fb9                	addw	a5,a5,a4
 33a:	0017979b          	slliw	a5,a5,0x1
 33e:	0007871b          	sext.w	a4,a5
 342:	fd843783          	ld	a5,-40(s0)
 346:	00178693          	addi	a3,a5,1
 34a:	fcd43c23          	sd	a3,-40(s0)
 34e:	0007c783          	lbu	a5,0(a5)
 352:	2781                	sext.w	a5,a5
 354:	9fb9                	addw	a5,a5,a4
 356:	2781                	sext.w	a5,a5
 358:	fd07879b          	addiw	a5,a5,-48
 35c:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
 360:	fd843783          	ld	a5,-40(s0)
 364:	0007c783          	lbu	a5,0(a5)
 368:	873e                	mv	a4,a5
 36a:	02f00793          	li	a5,47
 36e:	00e7fb63          	bgeu	a5,a4,384 <atoi+0x6a>
 372:	fd843783          	ld	a5,-40(s0)
 376:	0007c783          	lbu	a5,0(a5)
 37a:	873e                	mv	a4,a5
 37c:	03900793          	li	a5,57
 380:	fae7f6e3          	bgeu	a5,a4,32c <atoi+0x12>
  return n;
 384:	fec42783          	lw	a5,-20(s0)
}
 388:	853e                	mv	a0,a5
 38a:	70a2                	ld	ra,40(sp)
 38c:	7402                	ld	s0,32(sp)
 38e:	6145                	addi	sp,sp,48
 390:	8082                	ret

0000000000000392 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 392:	7139                	addi	sp,sp,-64
 394:	fc06                	sd	ra,56(sp)
 396:	f822                	sd	s0,48(sp)
 398:	0080                	addi	s0,sp,64
 39a:	fca43c23          	sd	a0,-40(s0)
 39e:	fcb43823          	sd	a1,-48(s0)
 3a2:	87b2                	mv	a5,a2
 3a4:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
 3a8:	fd843783          	ld	a5,-40(s0)
 3ac:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
 3b0:	fd043783          	ld	a5,-48(s0)
 3b4:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
 3b8:	fe043703          	ld	a4,-32(s0)
 3bc:	fe843783          	ld	a5,-24(s0)
 3c0:	02e7fc63          	bgeu	a5,a4,3f8 <memmove+0x66>
    while(n-- > 0)
 3c4:	a00d                	j	3e6 <memmove+0x54>
      *dst++ = *src++;
 3c6:	fe043703          	ld	a4,-32(s0)
 3ca:	00170793          	addi	a5,a4,1
 3ce:	fef43023          	sd	a5,-32(s0)
 3d2:	fe843783          	ld	a5,-24(s0)
 3d6:	00178693          	addi	a3,a5,1
 3da:	fed43423          	sd	a3,-24(s0)
 3de:	00074703          	lbu	a4,0(a4)
 3e2:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 3e6:	fcc42783          	lw	a5,-52(s0)
 3ea:	fff7871b          	addiw	a4,a5,-1
 3ee:	fce42623          	sw	a4,-52(s0)
 3f2:	fcf04ae3          	bgtz	a5,3c6 <memmove+0x34>
 3f6:	a891                	j	44a <memmove+0xb8>
  } else {
    dst += n;
 3f8:	fcc42783          	lw	a5,-52(s0)
 3fc:	fe843703          	ld	a4,-24(s0)
 400:	97ba                	add	a5,a5,a4
 402:	fef43423          	sd	a5,-24(s0)
    src += n;
 406:	fcc42783          	lw	a5,-52(s0)
 40a:	fe043703          	ld	a4,-32(s0)
 40e:	97ba                	add	a5,a5,a4
 410:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
 414:	a01d                	j	43a <memmove+0xa8>
      *--dst = *--src;
 416:	fe043783          	ld	a5,-32(s0)
 41a:	17fd                	addi	a5,a5,-1
 41c:	fef43023          	sd	a5,-32(s0)
 420:	fe843783          	ld	a5,-24(s0)
 424:	17fd                	addi	a5,a5,-1
 426:	fef43423          	sd	a5,-24(s0)
 42a:	fe043783          	ld	a5,-32(s0)
 42e:	0007c703          	lbu	a4,0(a5)
 432:	fe843783          	ld	a5,-24(s0)
 436:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 43a:	fcc42783          	lw	a5,-52(s0)
 43e:	fff7871b          	addiw	a4,a5,-1
 442:	fce42623          	sw	a4,-52(s0)
 446:	fcf048e3          	bgtz	a5,416 <memmove+0x84>
  }
  return vdst;
 44a:	fd843783          	ld	a5,-40(s0)
}
 44e:	853e                	mv	a0,a5
 450:	70e2                	ld	ra,56(sp)
 452:	7442                	ld	s0,48(sp)
 454:	6121                	addi	sp,sp,64
 456:	8082                	ret

0000000000000458 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 458:	7139                	addi	sp,sp,-64
 45a:	fc06                	sd	ra,56(sp)
 45c:	f822                	sd	s0,48(sp)
 45e:	0080                	addi	s0,sp,64
 460:	fca43c23          	sd	a0,-40(s0)
 464:	fcb43823          	sd	a1,-48(s0)
 468:	87b2                	mv	a5,a2
 46a:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
 46e:	fd843783          	ld	a5,-40(s0)
 472:	fef43423          	sd	a5,-24(s0)
 476:	fd043783          	ld	a5,-48(s0)
 47a:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 47e:	a0a1                	j	4c6 <memcmp+0x6e>
    if (*p1 != *p2) {
 480:	fe843783          	ld	a5,-24(s0)
 484:	0007c703          	lbu	a4,0(a5)
 488:	fe043783          	ld	a5,-32(s0)
 48c:	0007c783          	lbu	a5,0(a5)
 490:	02f70163          	beq	a4,a5,4b2 <memcmp+0x5a>
      return *p1 - *p2;
 494:	fe843783          	ld	a5,-24(s0)
 498:	0007c783          	lbu	a5,0(a5)
 49c:	0007871b          	sext.w	a4,a5
 4a0:	fe043783          	ld	a5,-32(s0)
 4a4:	0007c783          	lbu	a5,0(a5)
 4a8:	2781                	sext.w	a5,a5
 4aa:	40f707bb          	subw	a5,a4,a5
 4ae:	2781                	sext.w	a5,a5
 4b0:	a01d                	j	4d6 <memcmp+0x7e>
    }
    p1++;
 4b2:	fe843783          	ld	a5,-24(s0)
 4b6:	0785                	addi	a5,a5,1
 4b8:	fef43423          	sd	a5,-24(s0)
    p2++;
 4bc:	fe043783          	ld	a5,-32(s0)
 4c0:	0785                	addi	a5,a5,1
 4c2:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 4c6:	fcc42783          	lw	a5,-52(s0)
 4ca:	fff7871b          	addiw	a4,a5,-1
 4ce:	fce42623          	sw	a4,-52(s0)
 4d2:	f7dd                	bnez	a5,480 <memcmp+0x28>
  }
  return 0;
 4d4:	4781                	li	a5,0
}
 4d6:	853e                	mv	a0,a5
 4d8:	70e2                	ld	ra,56(sp)
 4da:	7442                	ld	s0,48(sp)
 4dc:	6121                	addi	sp,sp,64
 4de:	8082                	ret

00000000000004e0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4e0:	7179                	addi	sp,sp,-48
 4e2:	f406                	sd	ra,40(sp)
 4e4:	f022                	sd	s0,32(sp)
 4e6:	1800                	addi	s0,sp,48
 4e8:	fea43423          	sd	a0,-24(s0)
 4ec:	feb43023          	sd	a1,-32(s0)
 4f0:	87b2                	mv	a5,a2
 4f2:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
 4f6:	fdc42783          	lw	a5,-36(s0)
 4fa:	863e                	mv	a2,a5
 4fc:	fe043583          	ld	a1,-32(s0)
 500:	fe843503          	ld	a0,-24(s0)
 504:	00000097          	auipc	ra,0x0
 508:	e8e080e7          	jalr	-370(ra) # 392 <memmove>
 50c:	87aa                	mv	a5,a0
}
 50e:	853e                	mv	a0,a5
 510:	70a2                	ld	ra,40(sp)
 512:	7402                	ld	s0,32(sp)
 514:	6145                	addi	sp,sp,48
 516:	8082                	ret

0000000000000518 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 518:	4885                	li	a7,1
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <exit>:
.global exit
exit:
 li a7, SYS_exit
 520:	4889                	li	a7,2
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <wait>:
.global wait
wait:
 li a7, SYS_wait
 528:	488d                	li	a7,3
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 530:	4891                	li	a7,4
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <read>:
.global read
read:
 li a7, SYS_read
 538:	4895                	li	a7,5
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <write>:
.global write
write:
 li a7, SYS_write
 540:	48c1                	li	a7,16
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <close>:
.global close
close:
 li a7, SYS_close
 548:	48d5                	li	a7,21
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <kill>:
.global kill
kill:
 li a7, SYS_kill
 550:	4899                	li	a7,6
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <exec>:
.global exec
exec:
 li a7, SYS_exec
 558:	489d                	li	a7,7
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <open>:
.global open
open:
 li a7, SYS_open
 560:	48bd                	li	a7,15
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 568:	48c5                	li	a7,17
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 570:	48c9                	li	a7,18
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 578:	48a1                	li	a7,8
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <link>:
.global link
link:
 li a7, SYS_link
 580:	48cd                	li	a7,19
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 588:	48d1                	li	a7,20
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 590:	48a5                	li	a7,9
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <dup>:
.global dup
dup:
 li a7, SYS_dup
 598:	48a9                	li	a7,10
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5a0:	48ad                	li	a7,11
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5a8:	48b1                	li	a7,12
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5b0:	48b5                	li	a7,13
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5b8:	48b9                	li	a7,14
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5c0:	1101                	addi	sp,sp,-32
 5c2:	ec06                	sd	ra,24(sp)
 5c4:	e822                	sd	s0,16(sp)
 5c6:	1000                	addi	s0,sp,32
 5c8:	87aa                	mv	a5,a0
 5ca:	872e                	mv	a4,a1
 5cc:	fef42623          	sw	a5,-20(s0)
 5d0:	87ba                	mv	a5,a4
 5d2:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 5d6:	feb40713          	addi	a4,s0,-21
 5da:	fec42783          	lw	a5,-20(s0)
 5de:	4605                	li	a2,1
 5e0:	85ba                	mv	a1,a4
 5e2:	853e                	mv	a0,a5
 5e4:	00000097          	auipc	ra,0x0
 5e8:	f5c080e7          	jalr	-164(ra) # 540 <write>
}
 5ec:	0001                	nop
 5ee:	60e2                	ld	ra,24(sp)
 5f0:	6442                	ld	s0,16(sp)
 5f2:	6105                	addi	sp,sp,32
 5f4:	8082                	ret

00000000000005f6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5f6:	7139                	addi	sp,sp,-64
 5f8:	fc06                	sd	ra,56(sp)
 5fa:	f822                	sd	s0,48(sp)
 5fc:	0080                	addi	s0,sp,64
 5fe:	87aa                	mv	a5,a0
 600:	8736                	mv	a4,a3
 602:	fcf42623          	sw	a5,-52(s0)
 606:	87ae                	mv	a5,a1
 608:	fcf42423          	sw	a5,-56(s0)
 60c:	87b2                	mv	a5,a2
 60e:	fcf42223          	sw	a5,-60(s0)
 612:	87ba                	mv	a5,a4
 614:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 618:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 61c:	fc042783          	lw	a5,-64(s0)
 620:	2781                	sext.w	a5,a5
 622:	c38d                	beqz	a5,644 <printint+0x4e>
 624:	fc842783          	lw	a5,-56(s0)
 628:	2781                	sext.w	a5,a5
 62a:	0007dd63          	bgez	a5,644 <printint+0x4e>
    neg = 1;
 62e:	4785                	li	a5,1
 630:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 634:	fc842783          	lw	a5,-56(s0)
 638:	40f007bb          	negw	a5,a5
 63c:	2781                	sext.w	a5,a5
 63e:	fef42223          	sw	a5,-28(s0)
 642:	a029                	j	64c <printint+0x56>
  } else {
    x = xx;
 644:	fc842783          	lw	a5,-56(s0)
 648:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 64c:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 650:	fc442783          	lw	a5,-60(s0)
 654:	fe442703          	lw	a4,-28(s0)
 658:	02f777bb          	remuw	a5,a4,a5
 65c:	0007871b          	sext.w	a4,a5
 660:	fec42783          	lw	a5,-20(s0)
 664:	0017869b          	addiw	a3,a5,1
 668:	fed42623          	sw	a3,-20(s0)
 66c:	00001697          	auipc	a3,0x1
 670:	99468693          	addi	a3,a3,-1644 # 1000 <digits>
 674:	1702                	slli	a4,a4,0x20
 676:	9301                	srli	a4,a4,0x20
 678:	9736                	add	a4,a4,a3
 67a:	00074703          	lbu	a4,0(a4)
 67e:	17c1                	addi	a5,a5,-16
 680:	97a2                	add	a5,a5,s0
 682:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 686:	fc442783          	lw	a5,-60(s0)
 68a:	fe442703          	lw	a4,-28(s0)
 68e:	02f757bb          	divuw	a5,a4,a5
 692:	fef42223          	sw	a5,-28(s0)
 696:	fe442783          	lw	a5,-28(s0)
 69a:	2781                	sext.w	a5,a5
 69c:	fbd5                	bnez	a5,650 <printint+0x5a>
  if(neg)
 69e:	fe842783          	lw	a5,-24(s0)
 6a2:	2781                	sext.w	a5,a5
 6a4:	cf85                	beqz	a5,6dc <printint+0xe6>
    buf[i++] = '-';
 6a6:	fec42783          	lw	a5,-20(s0)
 6aa:	0017871b          	addiw	a4,a5,1
 6ae:	fee42623          	sw	a4,-20(s0)
 6b2:	17c1                	addi	a5,a5,-16
 6b4:	97a2                	add	a5,a5,s0
 6b6:	02d00713          	li	a4,45
 6ba:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 6be:	a839                	j	6dc <printint+0xe6>
    putc(fd, buf[i]);
 6c0:	fec42783          	lw	a5,-20(s0)
 6c4:	17c1                	addi	a5,a5,-16
 6c6:	97a2                	add	a5,a5,s0
 6c8:	fe07c703          	lbu	a4,-32(a5)
 6cc:	fcc42783          	lw	a5,-52(s0)
 6d0:	85ba                	mv	a1,a4
 6d2:	853e                	mv	a0,a5
 6d4:	00000097          	auipc	ra,0x0
 6d8:	eec080e7          	jalr	-276(ra) # 5c0 <putc>
  while(--i >= 0)
 6dc:	fec42783          	lw	a5,-20(s0)
 6e0:	37fd                	addiw	a5,a5,-1
 6e2:	fef42623          	sw	a5,-20(s0)
 6e6:	fec42783          	lw	a5,-20(s0)
 6ea:	2781                	sext.w	a5,a5
 6ec:	fc07dae3          	bgez	a5,6c0 <printint+0xca>
}
 6f0:	0001                	nop
 6f2:	0001                	nop
 6f4:	70e2                	ld	ra,56(sp)
 6f6:	7442                	ld	s0,48(sp)
 6f8:	6121                	addi	sp,sp,64
 6fa:	8082                	ret

00000000000006fc <printptr>:

static void
printptr(int fd, uint64 x) {
 6fc:	7179                	addi	sp,sp,-48
 6fe:	f406                	sd	ra,40(sp)
 700:	f022                	sd	s0,32(sp)
 702:	1800                	addi	s0,sp,48
 704:	87aa                	mv	a5,a0
 706:	fcb43823          	sd	a1,-48(s0)
 70a:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 70e:	fdc42783          	lw	a5,-36(s0)
 712:	03000593          	li	a1,48
 716:	853e                	mv	a0,a5
 718:	00000097          	auipc	ra,0x0
 71c:	ea8080e7          	jalr	-344(ra) # 5c0 <putc>
  putc(fd, 'x');
 720:	fdc42783          	lw	a5,-36(s0)
 724:	07800593          	li	a1,120
 728:	853e                	mv	a0,a5
 72a:	00000097          	auipc	ra,0x0
 72e:	e96080e7          	jalr	-362(ra) # 5c0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 732:	fe042623          	sw	zero,-20(s0)
 736:	a82d                	j	770 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 738:	fd043783          	ld	a5,-48(s0)
 73c:	93f1                	srli	a5,a5,0x3c
 73e:	00001717          	auipc	a4,0x1
 742:	8c270713          	addi	a4,a4,-1854 # 1000 <digits>
 746:	97ba                	add	a5,a5,a4
 748:	0007c703          	lbu	a4,0(a5)
 74c:	fdc42783          	lw	a5,-36(s0)
 750:	85ba                	mv	a1,a4
 752:	853e                	mv	a0,a5
 754:	00000097          	auipc	ra,0x0
 758:	e6c080e7          	jalr	-404(ra) # 5c0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 75c:	fec42783          	lw	a5,-20(s0)
 760:	2785                	addiw	a5,a5,1
 762:	fef42623          	sw	a5,-20(s0)
 766:	fd043783          	ld	a5,-48(s0)
 76a:	0792                	slli	a5,a5,0x4
 76c:	fcf43823          	sd	a5,-48(s0)
 770:	fec42703          	lw	a4,-20(s0)
 774:	47bd                	li	a5,15
 776:	fce7f1e3          	bgeu	a5,a4,738 <printptr+0x3c>
}
 77a:	0001                	nop
 77c:	0001                	nop
 77e:	70a2                	ld	ra,40(sp)
 780:	7402                	ld	s0,32(sp)
 782:	6145                	addi	sp,sp,48
 784:	8082                	ret

0000000000000786 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 786:	715d                	addi	sp,sp,-80
 788:	e486                	sd	ra,72(sp)
 78a:	e0a2                	sd	s0,64(sp)
 78c:	0880                	addi	s0,sp,80
 78e:	87aa                	mv	a5,a0
 790:	fcb43023          	sd	a1,-64(s0)
 794:	fac43c23          	sd	a2,-72(s0)
 798:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 79c:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 7a0:	fe042223          	sw	zero,-28(s0)
 7a4:	a42d                	j	9ce <vprintf+0x248>
    c = fmt[i] & 0xff;
 7a6:	fe442783          	lw	a5,-28(s0)
 7aa:	fc043703          	ld	a4,-64(s0)
 7ae:	97ba                	add	a5,a5,a4
 7b0:	0007c783          	lbu	a5,0(a5)
 7b4:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 7b8:	fe042783          	lw	a5,-32(s0)
 7bc:	2781                	sext.w	a5,a5
 7be:	eb9d                	bnez	a5,7f4 <vprintf+0x6e>
      if(c == '%'){
 7c0:	fdc42783          	lw	a5,-36(s0)
 7c4:	0007871b          	sext.w	a4,a5
 7c8:	02500793          	li	a5,37
 7cc:	00f71763          	bne	a4,a5,7da <vprintf+0x54>
        state = '%';
 7d0:	02500793          	li	a5,37
 7d4:	fef42023          	sw	a5,-32(s0)
 7d8:	a2f5                	j	9c4 <vprintf+0x23e>
      } else {
        putc(fd, c);
 7da:	fdc42783          	lw	a5,-36(s0)
 7de:	0ff7f713          	zext.b	a4,a5
 7e2:	fcc42783          	lw	a5,-52(s0)
 7e6:	85ba                	mv	a1,a4
 7e8:	853e                	mv	a0,a5
 7ea:	00000097          	auipc	ra,0x0
 7ee:	dd6080e7          	jalr	-554(ra) # 5c0 <putc>
 7f2:	aac9                	j	9c4 <vprintf+0x23e>
      }
    } else if(state == '%'){
 7f4:	fe042783          	lw	a5,-32(s0)
 7f8:	0007871b          	sext.w	a4,a5
 7fc:	02500793          	li	a5,37
 800:	1cf71263          	bne	a4,a5,9c4 <vprintf+0x23e>
      if(c == 'd'){
 804:	fdc42783          	lw	a5,-36(s0)
 808:	0007871b          	sext.w	a4,a5
 80c:	06400793          	li	a5,100
 810:	02f71463          	bne	a4,a5,838 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 814:	fb843783          	ld	a5,-72(s0)
 818:	00878713          	addi	a4,a5,8
 81c:	fae43c23          	sd	a4,-72(s0)
 820:	4398                	lw	a4,0(a5)
 822:	fcc42783          	lw	a5,-52(s0)
 826:	4685                	li	a3,1
 828:	4629                	li	a2,10
 82a:	85ba                	mv	a1,a4
 82c:	853e                	mv	a0,a5
 82e:	00000097          	auipc	ra,0x0
 832:	dc8080e7          	jalr	-568(ra) # 5f6 <printint>
 836:	a269                	j	9c0 <vprintf+0x23a>
      } else if(c == 'l') {
 838:	fdc42783          	lw	a5,-36(s0)
 83c:	0007871b          	sext.w	a4,a5
 840:	06c00793          	li	a5,108
 844:	02f71663          	bne	a4,a5,870 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 848:	fb843783          	ld	a5,-72(s0)
 84c:	00878713          	addi	a4,a5,8
 850:	fae43c23          	sd	a4,-72(s0)
 854:	639c                	ld	a5,0(a5)
 856:	0007871b          	sext.w	a4,a5
 85a:	fcc42783          	lw	a5,-52(s0)
 85e:	4681                	li	a3,0
 860:	4629                	li	a2,10
 862:	85ba                	mv	a1,a4
 864:	853e                	mv	a0,a5
 866:	00000097          	auipc	ra,0x0
 86a:	d90080e7          	jalr	-624(ra) # 5f6 <printint>
 86e:	aa89                	j	9c0 <vprintf+0x23a>
      } else if(c == 'x') {
 870:	fdc42783          	lw	a5,-36(s0)
 874:	0007871b          	sext.w	a4,a5
 878:	07800793          	li	a5,120
 87c:	02f71463          	bne	a4,a5,8a4 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 880:	fb843783          	ld	a5,-72(s0)
 884:	00878713          	addi	a4,a5,8
 888:	fae43c23          	sd	a4,-72(s0)
 88c:	4398                	lw	a4,0(a5)
 88e:	fcc42783          	lw	a5,-52(s0)
 892:	4681                	li	a3,0
 894:	4641                	li	a2,16
 896:	85ba                	mv	a1,a4
 898:	853e                	mv	a0,a5
 89a:	00000097          	auipc	ra,0x0
 89e:	d5c080e7          	jalr	-676(ra) # 5f6 <printint>
 8a2:	aa39                	j	9c0 <vprintf+0x23a>
      } else if(c == 'p') {
 8a4:	fdc42783          	lw	a5,-36(s0)
 8a8:	0007871b          	sext.w	a4,a5
 8ac:	07000793          	li	a5,112
 8b0:	02f71263          	bne	a4,a5,8d4 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 8b4:	fb843783          	ld	a5,-72(s0)
 8b8:	00878713          	addi	a4,a5,8
 8bc:	fae43c23          	sd	a4,-72(s0)
 8c0:	6398                	ld	a4,0(a5)
 8c2:	fcc42783          	lw	a5,-52(s0)
 8c6:	85ba                	mv	a1,a4
 8c8:	853e                	mv	a0,a5
 8ca:	00000097          	auipc	ra,0x0
 8ce:	e32080e7          	jalr	-462(ra) # 6fc <printptr>
 8d2:	a0fd                	j	9c0 <vprintf+0x23a>
      } else if(c == 's'){
 8d4:	fdc42783          	lw	a5,-36(s0)
 8d8:	0007871b          	sext.w	a4,a5
 8dc:	07300793          	li	a5,115
 8e0:	04f71c63          	bne	a4,a5,938 <vprintf+0x1b2>
        s = va_arg(ap, char*);
 8e4:	fb843783          	ld	a5,-72(s0)
 8e8:	00878713          	addi	a4,a5,8
 8ec:	fae43c23          	sd	a4,-72(s0)
 8f0:	639c                	ld	a5,0(a5)
 8f2:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 8f6:	fe843783          	ld	a5,-24(s0)
 8fa:	eb8d                	bnez	a5,92c <vprintf+0x1a6>
          s = "(null)";
 8fc:	00000797          	auipc	a5,0x0
 900:	4ac78793          	addi	a5,a5,1196 # da8 <malloc+0x170>
 904:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 908:	a015                	j	92c <vprintf+0x1a6>
          putc(fd, *s);
 90a:	fe843783          	ld	a5,-24(s0)
 90e:	0007c703          	lbu	a4,0(a5)
 912:	fcc42783          	lw	a5,-52(s0)
 916:	85ba                	mv	a1,a4
 918:	853e                	mv	a0,a5
 91a:	00000097          	auipc	ra,0x0
 91e:	ca6080e7          	jalr	-858(ra) # 5c0 <putc>
          s++;
 922:	fe843783          	ld	a5,-24(s0)
 926:	0785                	addi	a5,a5,1
 928:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 92c:	fe843783          	ld	a5,-24(s0)
 930:	0007c783          	lbu	a5,0(a5)
 934:	fbf9                	bnez	a5,90a <vprintf+0x184>
 936:	a069                	j	9c0 <vprintf+0x23a>
        }
      } else if(c == 'c'){
 938:	fdc42783          	lw	a5,-36(s0)
 93c:	0007871b          	sext.w	a4,a5
 940:	06300793          	li	a5,99
 944:	02f71463          	bne	a4,a5,96c <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 948:	fb843783          	ld	a5,-72(s0)
 94c:	00878713          	addi	a4,a5,8
 950:	fae43c23          	sd	a4,-72(s0)
 954:	439c                	lw	a5,0(a5)
 956:	0ff7f713          	zext.b	a4,a5
 95a:	fcc42783          	lw	a5,-52(s0)
 95e:	85ba                	mv	a1,a4
 960:	853e                	mv	a0,a5
 962:	00000097          	auipc	ra,0x0
 966:	c5e080e7          	jalr	-930(ra) # 5c0 <putc>
 96a:	a899                	j	9c0 <vprintf+0x23a>
      } else if(c == '%'){
 96c:	fdc42783          	lw	a5,-36(s0)
 970:	0007871b          	sext.w	a4,a5
 974:	02500793          	li	a5,37
 978:	00f71f63          	bne	a4,a5,996 <vprintf+0x210>
        putc(fd, c);
 97c:	fdc42783          	lw	a5,-36(s0)
 980:	0ff7f713          	zext.b	a4,a5
 984:	fcc42783          	lw	a5,-52(s0)
 988:	85ba                	mv	a1,a4
 98a:	853e                	mv	a0,a5
 98c:	00000097          	auipc	ra,0x0
 990:	c34080e7          	jalr	-972(ra) # 5c0 <putc>
 994:	a035                	j	9c0 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 996:	fcc42783          	lw	a5,-52(s0)
 99a:	02500593          	li	a1,37
 99e:	853e                	mv	a0,a5
 9a0:	00000097          	auipc	ra,0x0
 9a4:	c20080e7          	jalr	-992(ra) # 5c0 <putc>
        putc(fd, c);
 9a8:	fdc42783          	lw	a5,-36(s0)
 9ac:	0ff7f713          	zext.b	a4,a5
 9b0:	fcc42783          	lw	a5,-52(s0)
 9b4:	85ba                	mv	a1,a4
 9b6:	853e                	mv	a0,a5
 9b8:	00000097          	auipc	ra,0x0
 9bc:	c08080e7          	jalr	-1016(ra) # 5c0 <putc>
      }
      state = 0;
 9c0:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 9c4:	fe442783          	lw	a5,-28(s0)
 9c8:	2785                	addiw	a5,a5,1
 9ca:	fef42223          	sw	a5,-28(s0)
 9ce:	fe442783          	lw	a5,-28(s0)
 9d2:	fc043703          	ld	a4,-64(s0)
 9d6:	97ba                	add	a5,a5,a4
 9d8:	0007c783          	lbu	a5,0(a5)
 9dc:	dc0795e3          	bnez	a5,7a6 <vprintf+0x20>
    }
  }
}
 9e0:	0001                	nop
 9e2:	0001                	nop
 9e4:	60a6                	ld	ra,72(sp)
 9e6:	6406                	ld	s0,64(sp)
 9e8:	6161                	addi	sp,sp,80
 9ea:	8082                	ret

00000000000009ec <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9ec:	7159                	addi	sp,sp,-112
 9ee:	fc06                	sd	ra,56(sp)
 9f0:	f822                	sd	s0,48(sp)
 9f2:	0080                	addi	s0,sp,64
 9f4:	fcb43823          	sd	a1,-48(s0)
 9f8:	e010                	sd	a2,0(s0)
 9fa:	e414                	sd	a3,8(s0)
 9fc:	e818                	sd	a4,16(s0)
 9fe:	ec1c                	sd	a5,24(s0)
 a00:	03043023          	sd	a6,32(s0)
 a04:	03143423          	sd	a7,40(s0)
 a08:	87aa                	mv	a5,a0
 a0a:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 a0e:	03040793          	addi	a5,s0,48
 a12:	fcf43423          	sd	a5,-56(s0)
 a16:	fc843783          	ld	a5,-56(s0)
 a1a:	fd078793          	addi	a5,a5,-48
 a1e:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 a22:	fe843703          	ld	a4,-24(s0)
 a26:	fdc42783          	lw	a5,-36(s0)
 a2a:	863a                	mv	a2,a4
 a2c:	fd043583          	ld	a1,-48(s0)
 a30:	853e                	mv	a0,a5
 a32:	00000097          	auipc	ra,0x0
 a36:	d54080e7          	jalr	-684(ra) # 786 <vprintf>
}
 a3a:	0001                	nop
 a3c:	70e2                	ld	ra,56(sp)
 a3e:	7442                	ld	s0,48(sp)
 a40:	6165                	addi	sp,sp,112
 a42:	8082                	ret

0000000000000a44 <printf>:

void
printf(const char *fmt, ...)
{
 a44:	7159                	addi	sp,sp,-112
 a46:	f406                	sd	ra,40(sp)
 a48:	f022                	sd	s0,32(sp)
 a4a:	1800                	addi	s0,sp,48
 a4c:	fca43c23          	sd	a0,-40(s0)
 a50:	e40c                	sd	a1,8(s0)
 a52:	e810                	sd	a2,16(s0)
 a54:	ec14                	sd	a3,24(s0)
 a56:	f018                	sd	a4,32(s0)
 a58:	f41c                	sd	a5,40(s0)
 a5a:	03043823          	sd	a6,48(s0)
 a5e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a62:	04040793          	addi	a5,s0,64
 a66:	fcf43823          	sd	a5,-48(s0)
 a6a:	fd043783          	ld	a5,-48(s0)
 a6e:	fc878793          	addi	a5,a5,-56
 a72:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 a76:	fe843783          	ld	a5,-24(s0)
 a7a:	863e                	mv	a2,a5
 a7c:	fd843583          	ld	a1,-40(s0)
 a80:	4505                	li	a0,1
 a82:	00000097          	auipc	ra,0x0
 a86:	d04080e7          	jalr	-764(ra) # 786 <vprintf>
}
 a8a:	0001                	nop
 a8c:	70a2                	ld	ra,40(sp)
 a8e:	7402                	ld	s0,32(sp)
 a90:	6165                	addi	sp,sp,112
 a92:	8082                	ret

0000000000000a94 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a94:	7179                	addi	sp,sp,-48
 a96:	f406                	sd	ra,40(sp)
 a98:	f022                	sd	s0,32(sp)
 a9a:	1800                	addi	s0,sp,48
 a9c:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 aa0:	fd843783          	ld	a5,-40(s0)
 aa4:	17c1                	addi	a5,a5,-16
 aa6:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 aaa:	00000797          	auipc	a5,0x0
 aae:	58678793          	addi	a5,a5,1414 # 1030 <freep>
 ab2:	639c                	ld	a5,0(a5)
 ab4:	fef43423          	sd	a5,-24(s0)
 ab8:	a815                	j	aec <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 aba:	fe843783          	ld	a5,-24(s0)
 abe:	639c                	ld	a5,0(a5)
 ac0:	fe843703          	ld	a4,-24(s0)
 ac4:	00f76f63          	bltu	a4,a5,ae2 <free+0x4e>
 ac8:	fe043703          	ld	a4,-32(s0)
 acc:	fe843783          	ld	a5,-24(s0)
 ad0:	02e7eb63          	bltu	a5,a4,b06 <free+0x72>
 ad4:	fe843783          	ld	a5,-24(s0)
 ad8:	639c                	ld	a5,0(a5)
 ada:	fe043703          	ld	a4,-32(s0)
 ade:	02f76463          	bltu	a4,a5,b06 <free+0x72>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ae2:	fe843783          	ld	a5,-24(s0)
 ae6:	639c                	ld	a5,0(a5)
 ae8:	fef43423          	sd	a5,-24(s0)
 aec:	fe043703          	ld	a4,-32(s0)
 af0:	fe843783          	ld	a5,-24(s0)
 af4:	fce7f3e3          	bgeu	a5,a4,aba <free+0x26>
 af8:	fe843783          	ld	a5,-24(s0)
 afc:	639c                	ld	a5,0(a5)
 afe:	fe043703          	ld	a4,-32(s0)
 b02:	faf77ce3          	bgeu	a4,a5,aba <free+0x26>
      break;
  if(bp + bp->s.size == p->s.ptr){
 b06:	fe043783          	ld	a5,-32(s0)
 b0a:	479c                	lw	a5,8(a5)
 b0c:	1782                	slli	a5,a5,0x20
 b0e:	9381                	srli	a5,a5,0x20
 b10:	0792                	slli	a5,a5,0x4
 b12:	fe043703          	ld	a4,-32(s0)
 b16:	973e                	add	a4,a4,a5
 b18:	fe843783          	ld	a5,-24(s0)
 b1c:	639c                	ld	a5,0(a5)
 b1e:	02f71763          	bne	a4,a5,b4c <free+0xb8>
    bp->s.size += p->s.ptr->s.size;
 b22:	fe043783          	ld	a5,-32(s0)
 b26:	4798                	lw	a4,8(a5)
 b28:	fe843783          	ld	a5,-24(s0)
 b2c:	639c                	ld	a5,0(a5)
 b2e:	479c                	lw	a5,8(a5)
 b30:	9fb9                	addw	a5,a5,a4
 b32:	0007871b          	sext.w	a4,a5
 b36:	fe043783          	ld	a5,-32(s0)
 b3a:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 b3c:	fe843783          	ld	a5,-24(s0)
 b40:	639c                	ld	a5,0(a5)
 b42:	6398                	ld	a4,0(a5)
 b44:	fe043783          	ld	a5,-32(s0)
 b48:	e398                	sd	a4,0(a5)
 b4a:	a039                	j	b58 <free+0xc4>
  } else
    bp->s.ptr = p->s.ptr;
 b4c:	fe843783          	ld	a5,-24(s0)
 b50:	6398                	ld	a4,0(a5)
 b52:	fe043783          	ld	a5,-32(s0)
 b56:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 b58:	fe843783          	ld	a5,-24(s0)
 b5c:	479c                	lw	a5,8(a5)
 b5e:	1782                	slli	a5,a5,0x20
 b60:	9381                	srli	a5,a5,0x20
 b62:	0792                	slli	a5,a5,0x4
 b64:	fe843703          	ld	a4,-24(s0)
 b68:	97ba                	add	a5,a5,a4
 b6a:	fe043703          	ld	a4,-32(s0)
 b6e:	02f71563          	bne	a4,a5,b98 <free+0x104>
    p->s.size += bp->s.size;
 b72:	fe843783          	ld	a5,-24(s0)
 b76:	4798                	lw	a4,8(a5)
 b78:	fe043783          	ld	a5,-32(s0)
 b7c:	479c                	lw	a5,8(a5)
 b7e:	9fb9                	addw	a5,a5,a4
 b80:	0007871b          	sext.w	a4,a5
 b84:	fe843783          	ld	a5,-24(s0)
 b88:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b8a:	fe043783          	ld	a5,-32(s0)
 b8e:	6398                	ld	a4,0(a5)
 b90:	fe843783          	ld	a5,-24(s0)
 b94:	e398                	sd	a4,0(a5)
 b96:	a031                	j	ba2 <free+0x10e>
  } else
    p->s.ptr = bp;
 b98:	fe843783          	ld	a5,-24(s0)
 b9c:	fe043703          	ld	a4,-32(s0)
 ba0:	e398                	sd	a4,0(a5)
  freep = p;
 ba2:	00000797          	auipc	a5,0x0
 ba6:	48e78793          	addi	a5,a5,1166 # 1030 <freep>
 baa:	fe843703          	ld	a4,-24(s0)
 bae:	e398                	sd	a4,0(a5)
}
 bb0:	0001                	nop
 bb2:	70a2                	ld	ra,40(sp)
 bb4:	7402                	ld	s0,32(sp)
 bb6:	6145                	addi	sp,sp,48
 bb8:	8082                	ret

0000000000000bba <morecore>:

static Header*
morecore(uint nu)
{
 bba:	7179                	addi	sp,sp,-48
 bbc:	f406                	sd	ra,40(sp)
 bbe:	f022                	sd	s0,32(sp)
 bc0:	1800                	addi	s0,sp,48
 bc2:	87aa                	mv	a5,a0
 bc4:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 bc8:	fdc42783          	lw	a5,-36(s0)
 bcc:	0007871b          	sext.w	a4,a5
 bd0:	6785                	lui	a5,0x1
 bd2:	00f77563          	bgeu	a4,a5,bdc <morecore+0x22>
    nu = 4096;
 bd6:	6785                	lui	a5,0x1
 bd8:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 bdc:	fdc42783          	lw	a5,-36(s0)
 be0:	0047979b          	slliw	a5,a5,0x4
 be4:	2781                	sext.w	a5,a5
 be6:	853e                	mv	a0,a5
 be8:	00000097          	auipc	ra,0x0
 bec:	9c0080e7          	jalr	-1600(ra) # 5a8 <sbrk>
 bf0:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 bf4:	fe843703          	ld	a4,-24(s0)
 bf8:	57fd                	li	a5,-1
 bfa:	00f71463          	bne	a4,a5,c02 <morecore+0x48>
    return 0;
 bfe:	4781                	li	a5,0
 c00:	a03d                	j	c2e <morecore+0x74>
  hp = (Header*)p;
 c02:	fe843783          	ld	a5,-24(s0)
 c06:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 c0a:	fe043783          	ld	a5,-32(s0)
 c0e:	fdc42703          	lw	a4,-36(s0)
 c12:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 c14:	fe043783          	ld	a5,-32(s0)
 c18:	07c1                	addi	a5,a5,16 # 1010 <digits+0x10>
 c1a:	853e                	mv	a0,a5
 c1c:	00000097          	auipc	ra,0x0
 c20:	e78080e7          	jalr	-392(ra) # a94 <free>
  return freep;
 c24:	00000797          	auipc	a5,0x0
 c28:	40c78793          	addi	a5,a5,1036 # 1030 <freep>
 c2c:	639c                	ld	a5,0(a5)
}
 c2e:	853e                	mv	a0,a5
 c30:	70a2                	ld	ra,40(sp)
 c32:	7402                	ld	s0,32(sp)
 c34:	6145                	addi	sp,sp,48
 c36:	8082                	ret

0000000000000c38 <malloc>:

void*
malloc(uint nbytes)
{
 c38:	7139                	addi	sp,sp,-64
 c3a:	fc06                	sd	ra,56(sp)
 c3c:	f822                	sd	s0,48(sp)
 c3e:	0080                	addi	s0,sp,64
 c40:	87aa                	mv	a5,a0
 c42:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c46:	fcc46783          	lwu	a5,-52(s0)
 c4a:	07bd                	addi	a5,a5,15
 c4c:	8391                	srli	a5,a5,0x4
 c4e:	2781                	sext.w	a5,a5
 c50:	2785                	addiw	a5,a5,1
 c52:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 c56:	00000797          	auipc	a5,0x0
 c5a:	3da78793          	addi	a5,a5,986 # 1030 <freep>
 c5e:	639c                	ld	a5,0(a5)
 c60:	fef43023          	sd	a5,-32(s0)
 c64:	fe043783          	ld	a5,-32(s0)
 c68:	ef95                	bnez	a5,ca4 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 c6a:	00000797          	auipc	a5,0x0
 c6e:	3b678793          	addi	a5,a5,950 # 1020 <base>
 c72:	fef43023          	sd	a5,-32(s0)
 c76:	00000797          	auipc	a5,0x0
 c7a:	3ba78793          	addi	a5,a5,954 # 1030 <freep>
 c7e:	fe043703          	ld	a4,-32(s0)
 c82:	e398                	sd	a4,0(a5)
 c84:	00000797          	auipc	a5,0x0
 c88:	3ac78793          	addi	a5,a5,940 # 1030 <freep>
 c8c:	6398                	ld	a4,0(a5)
 c8e:	00000797          	auipc	a5,0x0
 c92:	39278793          	addi	a5,a5,914 # 1020 <base>
 c96:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 c98:	00000797          	auipc	a5,0x0
 c9c:	38878793          	addi	a5,a5,904 # 1020 <base>
 ca0:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ca4:	fe043783          	ld	a5,-32(s0)
 ca8:	639c                	ld	a5,0(a5)
 caa:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 cae:	fe843783          	ld	a5,-24(s0)
 cb2:	479c                	lw	a5,8(a5)
 cb4:	fdc42703          	lw	a4,-36(s0)
 cb8:	2701                	sext.w	a4,a4
 cba:	06e7e763          	bltu	a5,a4,d28 <malloc+0xf0>
      if(p->s.size == nunits)
 cbe:	fe843783          	ld	a5,-24(s0)
 cc2:	479c                	lw	a5,8(a5)
 cc4:	fdc42703          	lw	a4,-36(s0)
 cc8:	2701                	sext.w	a4,a4
 cca:	00f71963          	bne	a4,a5,cdc <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 cce:	fe843783          	ld	a5,-24(s0)
 cd2:	6398                	ld	a4,0(a5)
 cd4:	fe043783          	ld	a5,-32(s0)
 cd8:	e398                	sd	a4,0(a5)
 cda:	a825                	j	d12 <malloc+0xda>
      else {
        p->s.size -= nunits;
 cdc:	fe843783          	ld	a5,-24(s0)
 ce0:	479c                	lw	a5,8(a5)
 ce2:	fdc42703          	lw	a4,-36(s0)
 ce6:	9f99                	subw	a5,a5,a4
 ce8:	0007871b          	sext.w	a4,a5
 cec:	fe843783          	ld	a5,-24(s0)
 cf0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 cf2:	fe843783          	ld	a5,-24(s0)
 cf6:	479c                	lw	a5,8(a5)
 cf8:	1782                	slli	a5,a5,0x20
 cfa:	9381                	srli	a5,a5,0x20
 cfc:	0792                	slli	a5,a5,0x4
 cfe:	fe843703          	ld	a4,-24(s0)
 d02:	97ba                	add	a5,a5,a4
 d04:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 d08:	fe843783          	ld	a5,-24(s0)
 d0c:	fdc42703          	lw	a4,-36(s0)
 d10:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 d12:	00000797          	auipc	a5,0x0
 d16:	31e78793          	addi	a5,a5,798 # 1030 <freep>
 d1a:	fe043703          	ld	a4,-32(s0)
 d1e:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 d20:	fe843783          	ld	a5,-24(s0)
 d24:	07c1                	addi	a5,a5,16
 d26:	a091                	j	d6a <malloc+0x132>
    }
    if(p == freep)
 d28:	00000797          	auipc	a5,0x0
 d2c:	30878793          	addi	a5,a5,776 # 1030 <freep>
 d30:	639c                	ld	a5,0(a5)
 d32:	fe843703          	ld	a4,-24(s0)
 d36:	02f71063          	bne	a4,a5,d56 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 d3a:	fdc42783          	lw	a5,-36(s0)
 d3e:	853e                	mv	a0,a5
 d40:	00000097          	auipc	ra,0x0
 d44:	e7a080e7          	jalr	-390(ra) # bba <morecore>
 d48:	fea43423          	sd	a0,-24(s0)
 d4c:	fe843783          	ld	a5,-24(s0)
 d50:	e399                	bnez	a5,d56 <malloc+0x11e>
        return 0;
 d52:	4781                	li	a5,0
 d54:	a819                	j	d6a <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d56:	fe843783          	ld	a5,-24(s0)
 d5a:	fef43023          	sd	a5,-32(s0)
 d5e:	fe843783          	ld	a5,-24(s0)
 d62:	639c                	ld	a5,0(a5)
 d64:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 d68:	b799                	j	cae <malloc+0x76>
  }
}
 d6a:	853e                	mv	a0,a5
 d6c:	70e2                	ld	ra,56(sp)
 d6e:	7442                	ld	s0,48(sp)
 d70:	6121                	addi	sp,sp,64
 d72:	8082                	ret
