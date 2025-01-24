
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
  24:	d6050513          	addi	a0,a0,-672 # d80 <malloc+0x140>
  28:	00001097          	auipc	ra,0x1
  2c:	a24080e7          	jalr	-1500(ra) # a4c <printf>
  30:	a831                	j	4c <main+0x4c>
  } else {
    printf("Nice to meet you %s!\n", argv[1]);
  32:	fe043783          	ld	a5,-32(s0)
  36:	07a1                	addi	a5,a5,8
  38:	639c                	ld	a5,0(a5)
  3a:	85be                	mv	a1,a5
  3c:	00001517          	auipc	a0,0x1
  40:	d5450513          	addi	a0,a0,-684 # d90 <malloc+0x150>
  44:	00001097          	auipc	ra,0x1
  48:	a08080e7          	jalr	-1528(ra) # a4c <printf>
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

00000000000005c0 <ps>:
.global ps
ps:
 li a7, SYS_ps
 5c0:	48d9                	li	a7,22
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5c8:	1101                	addi	sp,sp,-32
 5ca:	ec06                	sd	ra,24(sp)
 5cc:	e822                	sd	s0,16(sp)
 5ce:	1000                	addi	s0,sp,32
 5d0:	87aa                	mv	a5,a0
 5d2:	872e                	mv	a4,a1
 5d4:	fef42623          	sw	a5,-20(s0)
 5d8:	87ba                	mv	a5,a4
 5da:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 5de:	feb40713          	addi	a4,s0,-21
 5e2:	fec42783          	lw	a5,-20(s0)
 5e6:	4605                	li	a2,1
 5e8:	85ba                	mv	a1,a4
 5ea:	853e                	mv	a0,a5
 5ec:	00000097          	auipc	ra,0x0
 5f0:	f54080e7          	jalr	-172(ra) # 540 <write>
}
 5f4:	0001                	nop
 5f6:	60e2                	ld	ra,24(sp)
 5f8:	6442                	ld	s0,16(sp)
 5fa:	6105                	addi	sp,sp,32
 5fc:	8082                	ret

00000000000005fe <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5fe:	7139                	addi	sp,sp,-64
 600:	fc06                	sd	ra,56(sp)
 602:	f822                	sd	s0,48(sp)
 604:	0080                	addi	s0,sp,64
 606:	87aa                	mv	a5,a0
 608:	8736                	mv	a4,a3
 60a:	fcf42623          	sw	a5,-52(s0)
 60e:	87ae                	mv	a5,a1
 610:	fcf42423          	sw	a5,-56(s0)
 614:	87b2                	mv	a5,a2
 616:	fcf42223          	sw	a5,-60(s0)
 61a:	87ba                	mv	a5,a4
 61c:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 620:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 624:	fc042783          	lw	a5,-64(s0)
 628:	2781                	sext.w	a5,a5
 62a:	c38d                	beqz	a5,64c <printint+0x4e>
 62c:	fc842783          	lw	a5,-56(s0)
 630:	2781                	sext.w	a5,a5
 632:	0007dd63          	bgez	a5,64c <printint+0x4e>
    neg = 1;
 636:	4785                	li	a5,1
 638:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 63c:	fc842783          	lw	a5,-56(s0)
 640:	40f007bb          	negw	a5,a5
 644:	2781                	sext.w	a5,a5
 646:	fef42223          	sw	a5,-28(s0)
 64a:	a029                	j	654 <printint+0x56>
  } else {
    x = xx;
 64c:	fc842783          	lw	a5,-56(s0)
 650:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 654:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 658:	fc442783          	lw	a5,-60(s0)
 65c:	fe442703          	lw	a4,-28(s0)
 660:	02f777bb          	remuw	a5,a4,a5
 664:	0007871b          	sext.w	a4,a5
 668:	fec42783          	lw	a5,-20(s0)
 66c:	0017869b          	addiw	a3,a5,1
 670:	fed42623          	sw	a3,-20(s0)
 674:	00001697          	auipc	a3,0x1
 678:	98c68693          	addi	a3,a3,-1652 # 1000 <digits>
 67c:	1702                	slli	a4,a4,0x20
 67e:	9301                	srli	a4,a4,0x20
 680:	9736                	add	a4,a4,a3
 682:	00074703          	lbu	a4,0(a4)
 686:	17c1                	addi	a5,a5,-16
 688:	97a2                	add	a5,a5,s0
 68a:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 68e:	fc442783          	lw	a5,-60(s0)
 692:	fe442703          	lw	a4,-28(s0)
 696:	02f757bb          	divuw	a5,a4,a5
 69a:	fef42223          	sw	a5,-28(s0)
 69e:	fe442783          	lw	a5,-28(s0)
 6a2:	2781                	sext.w	a5,a5
 6a4:	fbd5                	bnez	a5,658 <printint+0x5a>
  if(neg)
 6a6:	fe842783          	lw	a5,-24(s0)
 6aa:	2781                	sext.w	a5,a5
 6ac:	cf85                	beqz	a5,6e4 <printint+0xe6>
    buf[i++] = '-';
 6ae:	fec42783          	lw	a5,-20(s0)
 6b2:	0017871b          	addiw	a4,a5,1
 6b6:	fee42623          	sw	a4,-20(s0)
 6ba:	17c1                	addi	a5,a5,-16
 6bc:	97a2                	add	a5,a5,s0
 6be:	02d00713          	li	a4,45
 6c2:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 6c6:	a839                	j	6e4 <printint+0xe6>
    putc(fd, buf[i]);
 6c8:	fec42783          	lw	a5,-20(s0)
 6cc:	17c1                	addi	a5,a5,-16
 6ce:	97a2                	add	a5,a5,s0
 6d0:	fe07c703          	lbu	a4,-32(a5)
 6d4:	fcc42783          	lw	a5,-52(s0)
 6d8:	85ba                	mv	a1,a4
 6da:	853e                	mv	a0,a5
 6dc:	00000097          	auipc	ra,0x0
 6e0:	eec080e7          	jalr	-276(ra) # 5c8 <putc>
  while(--i >= 0)
 6e4:	fec42783          	lw	a5,-20(s0)
 6e8:	37fd                	addiw	a5,a5,-1
 6ea:	fef42623          	sw	a5,-20(s0)
 6ee:	fec42783          	lw	a5,-20(s0)
 6f2:	2781                	sext.w	a5,a5
 6f4:	fc07dae3          	bgez	a5,6c8 <printint+0xca>
}
 6f8:	0001                	nop
 6fa:	0001                	nop
 6fc:	70e2                	ld	ra,56(sp)
 6fe:	7442                	ld	s0,48(sp)
 700:	6121                	addi	sp,sp,64
 702:	8082                	ret

0000000000000704 <printptr>:

static void
printptr(int fd, uint64 x) {
 704:	7179                	addi	sp,sp,-48
 706:	f406                	sd	ra,40(sp)
 708:	f022                	sd	s0,32(sp)
 70a:	1800                	addi	s0,sp,48
 70c:	87aa                	mv	a5,a0
 70e:	fcb43823          	sd	a1,-48(s0)
 712:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 716:	fdc42783          	lw	a5,-36(s0)
 71a:	03000593          	li	a1,48
 71e:	853e                	mv	a0,a5
 720:	00000097          	auipc	ra,0x0
 724:	ea8080e7          	jalr	-344(ra) # 5c8 <putc>
  putc(fd, 'x');
 728:	fdc42783          	lw	a5,-36(s0)
 72c:	07800593          	li	a1,120
 730:	853e                	mv	a0,a5
 732:	00000097          	auipc	ra,0x0
 736:	e96080e7          	jalr	-362(ra) # 5c8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 73a:	fe042623          	sw	zero,-20(s0)
 73e:	a82d                	j	778 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 740:	fd043783          	ld	a5,-48(s0)
 744:	93f1                	srli	a5,a5,0x3c
 746:	00001717          	auipc	a4,0x1
 74a:	8ba70713          	addi	a4,a4,-1862 # 1000 <digits>
 74e:	97ba                	add	a5,a5,a4
 750:	0007c703          	lbu	a4,0(a5)
 754:	fdc42783          	lw	a5,-36(s0)
 758:	85ba                	mv	a1,a4
 75a:	853e                	mv	a0,a5
 75c:	00000097          	auipc	ra,0x0
 760:	e6c080e7          	jalr	-404(ra) # 5c8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 764:	fec42783          	lw	a5,-20(s0)
 768:	2785                	addiw	a5,a5,1
 76a:	fef42623          	sw	a5,-20(s0)
 76e:	fd043783          	ld	a5,-48(s0)
 772:	0792                	slli	a5,a5,0x4
 774:	fcf43823          	sd	a5,-48(s0)
 778:	fec42703          	lw	a4,-20(s0)
 77c:	47bd                	li	a5,15
 77e:	fce7f1e3          	bgeu	a5,a4,740 <printptr+0x3c>
}
 782:	0001                	nop
 784:	0001                	nop
 786:	70a2                	ld	ra,40(sp)
 788:	7402                	ld	s0,32(sp)
 78a:	6145                	addi	sp,sp,48
 78c:	8082                	ret

000000000000078e <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 78e:	715d                	addi	sp,sp,-80
 790:	e486                	sd	ra,72(sp)
 792:	e0a2                	sd	s0,64(sp)
 794:	0880                	addi	s0,sp,80
 796:	87aa                	mv	a5,a0
 798:	fcb43023          	sd	a1,-64(s0)
 79c:	fac43c23          	sd	a2,-72(s0)
 7a0:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 7a4:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 7a8:	fe042223          	sw	zero,-28(s0)
 7ac:	a42d                	j	9d6 <vprintf+0x248>
    c = fmt[i] & 0xff;
 7ae:	fe442783          	lw	a5,-28(s0)
 7b2:	fc043703          	ld	a4,-64(s0)
 7b6:	97ba                	add	a5,a5,a4
 7b8:	0007c783          	lbu	a5,0(a5)
 7bc:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 7c0:	fe042783          	lw	a5,-32(s0)
 7c4:	2781                	sext.w	a5,a5
 7c6:	eb9d                	bnez	a5,7fc <vprintf+0x6e>
      if(c == '%'){
 7c8:	fdc42783          	lw	a5,-36(s0)
 7cc:	0007871b          	sext.w	a4,a5
 7d0:	02500793          	li	a5,37
 7d4:	00f71763          	bne	a4,a5,7e2 <vprintf+0x54>
        state = '%';
 7d8:	02500793          	li	a5,37
 7dc:	fef42023          	sw	a5,-32(s0)
 7e0:	a2f5                	j	9cc <vprintf+0x23e>
      } else {
        putc(fd, c);
 7e2:	fdc42783          	lw	a5,-36(s0)
 7e6:	0ff7f713          	zext.b	a4,a5
 7ea:	fcc42783          	lw	a5,-52(s0)
 7ee:	85ba                	mv	a1,a4
 7f0:	853e                	mv	a0,a5
 7f2:	00000097          	auipc	ra,0x0
 7f6:	dd6080e7          	jalr	-554(ra) # 5c8 <putc>
 7fa:	aac9                	j	9cc <vprintf+0x23e>
      }
    } else if(state == '%'){
 7fc:	fe042783          	lw	a5,-32(s0)
 800:	0007871b          	sext.w	a4,a5
 804:	02500793          	li	a5,37
 808:	1cf71263          	bne	a4,a5,9cc <vprintf+0x23e>
      if(c == 'd'){
 80c:	fdc42783          	lw	a5,-36(s0)
 810:	0007871b          	sext.w	a4,a5
 814:	06400793          	li	a5,100
 818:	02f71463          	bne	a4,a5,840 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 81c:	fb843783          	ld	a5,-72(s0)
 820:	00878713          	addi	a4,a5,8
 824:	fae43c23          	sd	a4,-72(s0)
 828:	4398                	lw	a4,0(a5)
 82a:	fcc42783          	lw	a5,-52(s0)
 82e:	4685                	li	a3,1
 830:	4629                	li	a2,10
 832:	85ba                	mv	a1,a4
 834:	853e                	mv	a0,a5
 836:	00000097          	auipc	ra,0x0
 83a:	dc8080e7          	jalr	-568(ra) # 5fe <printint>
 83e:	a269                	j	9c8 <vprintf+0x23a>
      } else if(c == 'l') {
 840:	fdc42783          	lw	a5,-36(s0)
 844:	0007871b          	sext.w	a4,a5
 848:	06c00793          	li	a5,108
 84c:	02f71663          	bne	a4,a5,878 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 850:	fb843783          	ld	a5,-72(s0)
 854:	00878713          	addi	a4,a5,8
 858:	fae43c23          	sd	a4,-72(s0)
 85c:	639c                	ld	a5,0(a5)
 85e:	0007871b          	sext.w	a4,a5
 862:	fcc42783          	lw	a5,-52(s0)
 866:	4681                	li	a3,0
 868:	4629                	li	a2,10
 86a:	85ba                	mv	a1,a4
 86c:	853e                	mv	a0,a5
 86e:	00000097          	auipc	ra,0x0
 872:	d90080e7          	jalr	-624(ra) # 5fe <printint>
 876:	aa89                	j	9c8 <vprintf+0x23a>
      } else if(c == 'x') {
 878:	fdc42783          	lw	a5,-36(s0)
 87c:	0007871b          	sext.w	a4,a5
 880:	07800793          	li	a5,120
 884:	02f71463          	bne	a4,a5,8ac <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 888:	fb843783          	ld	a5,-72(s0)
 88c:	00878713          	addi	a4,a5,8
 890:	fae43c23          	sd	a4,-72(s0)
 894:	4398                	lw	a4,0(a5)
 896:	fcc42783          	lw	a5,-52(s0)
 89a:	4681                	li	a3,0
 89c:	4641                	li	a2,16
 89e:	85ba                	mv	a1,a4
 8a0:	853e                	mv	a0,a5
 8a2:	00000097          	auipc	ra,0x0
 8a6:	d5c080e7          	jalr	-676(ra) # 5fe <printint>
 8aa:	aa39                	j	9c8 <vprintf+0x23a>
      } else if(c == 'p') {
 8ac:	fdc42783          	lw	a5,-36(s0)
 8b0:	0007871b          	sext.w	a4,a5
 8b4:	07000793          	li	a5,112
 8b8:	02f71263          	bne	a4,a5,8dc <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 8bc:	fb843783          	ld	a5,-72(s0)
 8c0:	00878713          	addi	a4,a5,8
 8c4:	fae43c23          	sd	a4,-72(s0)
 8c8:	6398                	ld	a4,0(a5)
 8ca:	fcc42783          	lw	a5,-52(s0)
 8ce:	85ba                	mv	a1,a4
 8d0:	853e                	mv	a0,a5
 8d2:	00000097          	auipc	ra,0x0
 8d6:	e32080e7          	jalr	-462(ra) # 704 <printptr>
 8da:	a0fd                	j	9c8 <vprintf+0x23a>
      } else if(c == 's'){
 8dc:	fdc42783          	lw	a5,-36(s0)
 8e0:	0007871b          	sext.w	a4,a5
 8e4:	07300793          	li	a5,115
 8e8:	04f71c63          	bne	a4,a5,940 <vprintf+0x1b2>
        s = va_arg(ap, char*);
 8ec:	fb843783          	ld	a5,-72(s0)
 8f0:	00878713          	addi	a4,a5,8
 8f4:	fae43c23          	sd	a4,-72(s0)
 8f8:	639c                	ld	a5,0(a5)
 8fa:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 8fe:	fe843783          	ld	a5,-24(s0)
 902:	eb8d                	bnez	a5,934 <vprintf+0x1a6>
          s = "(null)";
 904:	00000797          	auipc	a5,0x0
 908:	4a478793          	addi	a5,a5,1188 # da8 <malloc+0x168>
 90c:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 910:	a015                	j	934 <vprintf+0x1a6>
          putc(fd, *s);
 912:	fe843783          	ld	a5,-24(s0)
 916:	0007c703          	lbu	a4,0(a5)
 91a:	fcc42783          	lw	a5,-52(s0)
 91e:	85ba                	mv	a1,a4
 920:	853e                	mv	a0,a5
 922:	00000097          	auipc	ra,0x0
 926:	ca6080e7          	jalr	-858(ra) # 5c8 <putc>
          s++;
 92a:	fe843783          	ld	a5,-24(s0)
 92e:	0785                	addi	a5,a5,1
 930:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 934:	fe843783          	ld	a5,-24(s0)
 938:	0007c783          	lbu	a5,0(a5)
 93c:	fbf9                	bnez	a5,912 <vprintf+0x184>
 93e:	a069                	j	9c8 <vprintf+0x23a>
        }
      } else if(c == 'c'){
 940:	fdc42783          	lw	a5,-36(s0)
 944:	0007871b          	sext.w	a4,a5
 948:	06300793          	li	a5,99
 94c:	02f71463          	bne	a4,a5,974 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 950:	fb843783          	ld	a5,-72(s0)
 954:	00878713          	addi	a4,a5,8
 958:	fae43c23          	sd	a4,-72(s0)
 95c:	439c                	lw	a5,0(a5)
 95e:	0ff7f713          	zext.b	a4,a5
 962:	fcc42783          	lw	a5,-52(s0)
 966:	85ba                	mv	a1,a4
 968:	853e                	mv	a0,a5
 96a:	00000097          	auipc	ra,0x0
 96e:	c5e080e7          	jalr	-930(ra) # 5c8 <putc>
 972:	a899                	j	9c8 <vprintf+0x23a>
      } else if(c == '%'){
 974:	fdc42783          	lw	a5,-36(s0)
 978:	0007871b          	sext.w	a4,a5
 97c:	02500793          	li	a5,37
 980:	00f71f63          	bne	a4,a5,99e <vprintf+0x210>
        putc(fd, c);
 984:	fdc42783          	lw	a5,-36(s0)
 988:	0ff7f713          	zext.b	a4,a5
 98c:	fcc42783          	lw	a5,-52(s0)
 990:	85ba                	mv	a1,a4
 992:	853e                	mv	a0,a5
 994:	00000097          	auipc	ra,0x0
 998:	c34080e7          	jalr	-972(ra) # 5c8 <putc>
 99c:	a035                	j	9c8 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 99e:	fcc42783          	lw	a5,-52(s0)
 9a2:	02500593          	li	a1,37
 9a6:	853e                	mv	a0,a5
 9a8:	00000097          	auipc	ra,0x0
 9ac:	c20080e7          	jalr	-992(ra) # 5c8 <putc>
        putc(fd, c);
 9b0:	fdc42783          	lw	a5,-36(s0)
 9b4:	0ff7f713          	zext.b	a4,a5
 9b8:	fcc42783          	lw	a5,-52(s0)
 9bc:	85ba                	mv	a1,a4
 9be:	853e                	mv	a0,a5
 9c0:	00000097          	auipc	ra,0x0
 9c4:	c08080e7          	jalr	-1016(ra) # 5c8 <putc>
      }
      state = 0;
 9c8:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 9cc:	fe442783          	lw	a5,-28(s0)
 9d0:	2785                	addiw	a5,a5,1
 9d2:	fef42223          	sw	a5,-28(s0)
 9d6:	fe442783          	lw	a5,-28(s0)
 9da:	fc043703          	ld	a4,-64(s0)
 9de:	97ba                	add	a5,a5,a4
 9e0:	0007c783          	lbu	a5,0(a5)
 9e4:	dc0795e3          	bnez	a5,7ae <vprintf+0x20>
    }
  }
}
 9e8:	0001                	nop
 9ea:	0001                	nop
 9ec:	60a6                	ld	ra,72(sp)
 9ee:	6406                	ld	s0,64(sp)
 9f0:	6161                	addi	sp,sp,80
 9f2:	8082                	ret

00000000000009f4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9f4:	7159                	addi	sp,sp,-112
 9f6:	fc06                	sd	ra,56(sp)
 9f8:	f822                	sd	s0,48(sp)
 9fa:	0080                	addi	s0,sp,64
 9fc:	fcb43823          	sd	a1,-48(s0)
 a00:	e010                	sd	a2,0(s0)
 a02:	e414                	sd	a3,8(s0)
 a04:	e818                	sd	a4,16(s0)
 a06:	ec1c                	sd	a5,24(s0)
 a08:	03043023          	sd	a6,32(s0)
 a0c:	03143423          	sd	a7,40(s0)
 a10:	87aa                	mv	a5,a0
 a12:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 a16:	03040793          	addi	a5,s0,48
 a1a:	fcf43423          	sd	a5,-56(s0)
 a1e:	fc843783          	ld	a5,-56(s0)
 a22:	fd078793          	addi	a5,a5,-48
 a26:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 a2a:	fe843703          	ld	a4,-24(s0)
 a2e:	fdc42783          	lw	a5,-36(s0)
 a32:	863a                	mv	a2,a4
 a34:	fd043583          	ld	a1,-48(s0)
 a38:	853e                	mv	a0,a5
 a3a:	00000097          	auipc	ra,0x0
 a3e:	d54080e7          	jalr	-684(ra) # 78e <vprintf>
}
 a42:	0001                	nop
 a44:	70e2                	ld	ra,56(sp)
 a46:	7442                	ld	s0,48(sp)
 a48:	6165                	addi	sp,sp,112
 a4a:	8082                	ret

0000000000000a4c <printf>:

void
printf(const char *fmt, ...)
{
 a4c:	7159                	addi	sp,sp,-112
 a4e:	f406                	sd	ra,40(sp)
 a50:	f022                	sd	s0,32(sp)
 a52:	1800                	addi	s0,sp,48
 a54:	fca43c23          	sd	a0,-40(s0)
 a58:	e40c                	sd	a1,8(s0)
 a5a:	e810                	sd	a2,16(s0)
 a5c:	ec14                	sd	a3,24(s0)
 a5e:	f018                	sd	a4,32(s0)
 a60:	f41c                	sd	a5,40(s0)
 a62:	03043823          	sd	a6,48(s0)
 a66:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a6a:	04040793          	addi	a5,s0,64
 a6e:	fcf43823          	sd	a5,-48(s0)
 a72:	fd043783          	ld	a5,-48(s0)
 a76:	fc878793          	addi	a5,a5,-56
 a7a:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 a7e:	fe843783          	ld	a5,-24(s0)
 a82:	863e                	mv	a2,a5
 a84:	fd843583          	ld	a1,-40(s0)
 a88:	4505                	li	a0,1
 a8a:	00000097          	auipc	ra,0x0
 a8e:	d04080e7          	jalr	-764(ra) # 78e <vprintf>
}
 a92:	0001                	nop
 a94:	70a2                	ld	ra,40(sp)
 a96:	7402                	ld	s0,32(sp)
 a98:	6165                	addi	sp,sp,112
 a9a:	8082                	ret

0000000000000a9c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a9c:	7179                	addi	sp,sp,-48
 a9e:	f406                	sd	ra,40(sp)
 aa0:	f022                	sd	s0,32(sp)
 aa2:	1800                	addi	s0,sp,48
 aa4:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 aa8:	fd843783          	ld	a5,-40(s0)
 aac:	17c1                	addi	a5,a5,-16
 aae:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ab2:	00000797          	auipc	a5,0x0
 ab6:	57e78793          	addi	a5,a5,1406 # 1030 <freep>
 aba:	639c                	ld	a5,0(a5)
 abc:	fef43423          	sd	a5,-24(s0)
 ac0:	a815                	j	af4 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ac2:	fe843783          	ld	a5,-24(s0)
 ac6:	639c                	ld	a5,0(a5)
 ac8:	fe843703          	ld	a4,-24(s0)
 acc:	00f76f63          	bltu	a4,a5,aea <free+0x4e>
 ad0:	fe043703          	ld	a4,-32(s0)
 ad4:	fe843783          	ld	a5,-24(s0)
 ad8:	02e7eb63          	bltu	a5,a4,b0e <free+0x72>
 adc:	fe843783          	ld	a5,-24(s0)
 ae0:	639c                	ld	a5,0(a5)
 ae2:	fe043703          	ld	a4,-32(s0)
 ae6:	02f76463          	bltu	a4,a5,b0e <free+0x72>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 aea:	fe843783          	ld	a5,-24(s0)
 aee:	639c                	ld	a5,0(a5)
 af0:	fef43423          	sd	a5,-24(s0)
 af4:	fe043703          	ld	a4,-32(s0)
 af8:	fe843783          	ld	a5,-24(s0)
 afc:	fce7f3e3          	bgeu	a5,a4,ac2 <free+0x26>
 b00:	fe843783          	ld	a5,-24(s0)
 b04:	639c                	ld	a5,0(a5)
 b06:	fe043703          	ld	a4,-32(s0)
 b0a:	faf77ce3          	bgeu	a4,a5,ac2 <free+0x26>
      break;
  if(bp + bp->s.size == p->s.ptr){
 b0e:	fe043783          	ld	a5,-32(s0)
 b12:	479c                	lw	a5,8(a5)
 b14:	1782                	slli	a5,a5,0x20
 b16:	9381                	srli	a5,a5,0x20
 b18:	0792                	slli	a5,a5,0x4
 b1a:	fe043703          	ld	a4,-32(s0)
 b1e:	973e                	add	a4,a4,a5
 b20:	fe843783          	ld	a5,-24(s0)
 b24:	639c                	ld	a5,0(a5)
 b26:	02f71763          	bne	a4,a5,b54 <free+0xb8>
    bp->s.size += p->s.ptr->s.size;
 b2a:	fe043783          	ld	a5,-32(s0)
 b2e:	4798                	lw	a4,8(a5)
 b30:	fe843783          	ld	a5,-24(s0)
 b34:	639c                	ld	a5,0(a5)
 b36:	479c                	lw	a5,8(a5)
 b38:	9fb9                	addw	a5,a5,a4
 b3a:	0007871b          	sext.w	a4,a5
 b3e:	fe043783          	ld	a5,-32(s0)
 b42:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 b44:	fe843783          	ld	a5,-24(s0)
 b48:	639c                	ld	a5,0(a5)
 b4a:	6398                	ld	a4,0(a5)
 b4c:	fe043783          	ld	a5,-32(s0)
 b50:	e398                	sd	a4,0(a5)
 b52:	a039                	j	b60 <free+0xc4>
  } else
    bp->s.ptr = p->s.ptr;
 b54:	fe843783          	ld	a5,-24(s0)
 b58:	6398                	ld	a4,0(a5)
 b5a:	fe043783          	ld	a5,-32(s0)
 b5e:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 b60:	fe843783          	ld	a5,-24(s0)
 b64:	479c                	lw	a5,8(a5)
 b66:	1782                	slli	a5,a5,0x20
 b68:	9381                	srli	a5,a5,0x20
 b6a:	0792                	slli	a5,a5,0x4
 b6c:	fe843703          	ld	a4,-24(s0)
 b70:	97ba                	add	a5,a5,a4
 b72:	fe043703          	ld	a4,-32(s0)
 b76:	02f71563          	bne	a4,a5,ba0 <free+0x104>
    p->s.size += bp->s.size;
 b7a:	fe843783          	ld	a5,-24(s0)
 b7e:	4798                	lw	a4,8(a5)
 b80:	fe043783          	ld	a5,-32(s0)
 b84:	479c                	lw	a5,8(a5)
 b86:	9fb9                	addw	a5,a5,a4
 b88:	0007871b          	sext.w	a4,a5
 b8c:	fe843783          	ld	a5,-24(s0)
 b90:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b92:	fe043783          	ld	a5,-32(s0)
 b96:	6398                	ld	a4,0(a5)
 b98:	fe843783          	ld	a5,-24(s0)
 b9c:	e398                	sd	a4,0(a5)
 b9e:	a031                	j	baa <free+0x10e>
  } else
    p->s.ptr = bp;
 ba0:	fe843783          	ld	a5,-24(s0)
 ba4:	fe043703          	ld	a4,-32(s0)
 ba8:	e398                	sd	a4,0(a5)
  freep = p;
 baa:	00000797          	auipc	a5,0x0
 bae:	48678793          	addi	a5,a5,1158 # 1030 <freep>
 bb2:	fe843703          	ld	a4,-24(s0)
 bb6:	e398                	sd	a4,0(a5)
}
 bb8:	0001                	nop
 bba:	70a2                	ld	ra,40(sp)
 bbc:	7402                	ld	s0,32(sp)
 bbe:	6145                	addi	sp,sp,48
 bc0:	8082                	ret

0000000000000bc2 <morecore>:

static Header*
morecore(uint nu)
{
 bc2:	7179                	addi	sp,sp,-48
 bc4:	f406                	sd	ra,40(sp)
 bc6:	f022                	sd	s0,32(sp)
 bc8:	1800                	addi	s0,sp,48
 bca:	87aa                	mv	a5,a0
 bcc:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 bd0:	fdc42783          	lw	a5,-36(s0)
 bd4:	0007871b          	sext.w	a4,a5
 bd8:	6785                	lui	a5,0x1
 bda:	00f77563          	bgeu	a4,a5,be4 <morecore+0x22>
    nu = 4096;
 bde:	6785                	lui	a5,0x1
 be0:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 be4:	fdc42783          	lw	a5,-36(s0)
 be8:	0047979b          	slliw	a5,a5,0x4
 bec:	2781                	sext.w	a5,a5
 bee:	853e                	mv	a0,a5
 bf0:	00000097          	auipc	ra,0x0
 bf4:	9b8080e7          	jalr	-1608(ra) # 5a8 <sbrk>
 bf8:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 bfc:	fe843703          	ld	a4,-24(s0)
 c00:	57fd                	li	a5,-1
 c02:	00f71463          	bne	a4,a5,c0a <morecore+0x48>
    return 0;
 c06:	4781                	li	a5,0
 c08:	a03d                	j	c36 <morecore+0x74>
  hp = (Header*)p;
 c0a:	fe843783          	ld	a5,-24(s0)
 c0e:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 c12:	fe043783          	ld	a5,-32(s0)
 c16:	fdc42703          	lw	a4,-36(s0)
 c1a:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 c1c:	fe043783          	ld	a5,-32(s0)
 c20:	07c1                	addi	a5,a5,16 # 1010 <digits+0x10>
 c22:	853e                	mv	a0,a5
 c24:	00000097          	auipc	ra,0x0
 c28:	e78080e7          	jalr	-392(ra) # a9c <free>
  return freep;
 c2c:	00000797          	auipc	a5,0x0
 c30:	40478793          	addi	a5,a5,1028 # 1030 <freep>
 c34:	639c                	ld	a5,0(a5)
}
 c36:	853e                	mv	a0,a5
 c38:	70a2                	ld	ra,40(sp)
 c3a:	7402                	ld	s0,32(sp)
 c3c:	6145                	addi	sp,sp,48
 c3e:	8082                	ret

0000000000000c40 <malloc>:

void*
malloc(uint nbytes)
{
 c40:	7139                	addi	sp,sp,-64
 c42:	fc06                	sd	ra,56(sp)
 c44:	f822                	sd	s0,48(sp)
 c46:	0080                	addi	s0,sp,64
 c48:	87aa                	mv	a5,a0
 c4a:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c4e:	fcc46783          	lwu	a5,-52(s0)
 c52:	07bd                	addi	a5,a5,15
 c54:	8391                	srli	a5,a5,0x4
 c56:	2781                	sext.w	a5,a5
 c58:	2785                	addiw	a5,a5,1
 c5a:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 c5e:	00000797          	auipc	a5,0x0
 c62:	3d278793          	addi	a5,a5,978 # 1030 <freep>
 c66:	639c                	ld	a5,0(a5)
 c68:	fef43023          	sd	a5,-32(s0)
 c6c:	fe043783          	ld	a5,-32(s0)
 c70:	ef95                	bnez	a5,cac <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 c72:	00000797          	auipc	a5,0x0
 c76:	3ae78793          	addi	a5,a5,942 # 1020 <base>
 c7a:	fef43023          	sd	a5,-32(s0)
 c7e:	00000797          	auipc	a5,0x0
 c82:	3b278793          	addi	a5,a5,946 # 1030 <freep>
 c86:	fe043703          	ld	a4,-32(s0)
 c8a:	e398                	sd	a4,0(a5)
 c8c:	00000797          	auipc	a5,0x0
 c90:	3a478793          	addi	a5,a5,932 # 1030 <freep>
 c94:	6398                	ld	a4,0(a5)
 c96:	00000797          	auipc	a5,0x0
 c9a:	38a78793          	addi	a5,a5,906 # 1020 <base>
 c9e:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 ca0:	00000797          	auipc	a5,0x0
 ca4:	38078793          	addi	a5,a5,896 # 1020 <base>
 ca8:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cac:	fe043783          	ld	a5,-32(s0)
 cb0:	639c                	ld	a5,0(a5)
 cb2:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 cb6:	fe843783          	ld	a5,-24(s0)
 cba:	479c                	lw	a5,8(a5)
 cbc:	fdc42703          	lw	a4,-36(s0)
 cc0:	2701                	sext.w	a4,a4
 cc2:	06e7e763          	bltu	a5,a4,d30 <malloc+0xf0>
      if(p->s.size == nunits)
 cc6:	fe843783          	ld	a5,-24(s0)
 cca:	479c                	lw	a5,8(a5)
 ccc:	fdc42703          	lw	a4,-36(s0)
 cd0:	2701                	sext.w	a4,a4
 cd2:	00f71963          	bne	a4,a5,ce4 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 cd6:	fe843783          	ld	a5,-24(s0)
 cda:	6398                	ld	a4,0(a5)
 cdc:	fe043783          	ld	a5,-32(s0)
 ce0:	e398                	sd	a4,0(a5)
 ce2:	a825                	j	d1a <malloc+0xda>
      else {
        p->s.size -= nunits;
 ce4:	fe843783          	ld	a5,-24(s0)
 ce8:	479c                	lw	a5,8(a5)
 cea:	fdc42703          	lw	a4,-36(s0)
 cee:	9f99                	subw	a5,a5,a4
 cf0:	0007871b          	sext.w	a4,a5
 cf4:	fe843783          	ld	a5,-24(s0)
 cf8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 cfa:	fe843783          	ld	a5,-24(s0)
 cfe:	479c                	lw	a5,8(a5)
 d00:	1782                	slli	a5,a5,0x20
 d02:	9381                	srli	a5,a5,0x20
 d04:	0792                	slli	a5,a5,0x4
 d06:	fe843703          	ld	a4,-24(s0)
 d0a:	97ba                	add	a5,a5,a4
 d0c:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 d10:	fe843783          	ld	a5,-24(s0)
 d14:	fdc42703          	lw	a4,-36(s0)
 d18:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 d1a:	00000797          	auipc	a5,0x0
 d1e:	31678793          	addi	a5,a5,790 # 1030 <freep>
 d22:	fe043703          	ld	a4,-32(s0)
 d26:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 d28:	fe843783          	ld	a5,-24(s0)
 d2c:	07c1                	addi	a5,a5,16
 d2e:	a091                	j	d72 <malloc+0x132>
    }
    if(p == freep)
 d30:	00000797          	auipc	a5,0x0
 d34:	30078793          	addi	a5,a5,768 # 1030 <freep>
 d38:	639c                	ld	a5,0(a5)
 d3a:	fe843703          	ld	a4,-24(s0)
 d3e:	02f71063          	bne	a4,a5,d5e <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 d42:	fdc42783          	lw	a5,-36(s0)
 d46:	853e                	mv	a0,a5
 d48:	00000097          	auipc	ra,0x0
 d4c:	e7a080e7          	jalr	-390(ra) # bc2 <morecore>
 d50:	fea43423          	sd	a0,-24(s0)
 d54:	fe843783          	ld	a5,-24(s0)
 d58:	e399                	bnez	a5,d5e <malloc+0x11e>
        return 0;
 d5a:	4781                	li	a5,0
 d5c:	a819                	j	d72 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d5e:	fe843783          	ld	a5,-24(s0)
 d62:	fef43023          	sd	a5,-32(s0)
 d66:	fe843783          	ld	a5,-24(s0)
 d6a:	639c                	ld	a5,0(a5)
 d6c:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 d70:	b799                	j	cb6 <malloc+0x76>
  }
}
 d72:	853e                	mv	a0,a5
 d74:	70e2                	ld	ra,56(sp)
 d76:	7442                	ld	s0,48(sp)
 d78:	6121                	addi	sp,sp,64
 d7a:	8082                	ret
