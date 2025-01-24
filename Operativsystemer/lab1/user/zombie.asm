
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	00000097          	auipc	ra,0x0
   c:	4e4080e7          	jalr	1252(ra) # 4ec <fork>
  10:	87aa                	mv	a5,a0
  12:	00f05763          	blez	a5,20 <main+0x20>
    sleep(5);  // Let child exit before parent.
  16:	4515                	li	a0,5
  18:	00000097          	auipc	ra,0x0
  1c:	56c080e7          	jalr	1388(ra) # 584 <sleep>
  exit(0);
  20:	4501                	li	a0,0
  22:	00000097          	auipc	ra,0x0
  26:	4d2080e7          	jalr	1234(ra) # 4f4 <exit>

000000000000002a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  2a:	1141                	addi	sp,sp,-16
  2c:	e406                	sd	ra,8(sp)
  2e:	e022                	sd	s0,0(sp)
  30:	0800                	addi	s0,sp,16
  extern int main();
  main();
  32:	00000097          	auipc	ra,0x0
  36:	fce080e7          	jalr	-50(ra) # 0 <main>
  exit(0);
  3a:	4501                	li	a0,0
  3c:	00000097          	auipc	ra,0x0
  40:	4b8080e7          	jalr	1208(ra) # 4f4 <exit>

0000000000000044 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  44:	7179                	addi	sp,sp,-48
  46:	f406                	sd	ra,40(sp)
  48:	f022                	sd	s0,32(sp)
  4a:	1800                	addi	s0,sp,48
  4c:	fca43c23          	sd	a0,-40(s0)
  50:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
  54:	fd843783          	ld	a5,-40(s0)
  58:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
  5c:	0001                	nop
  5e:	fd043703          	ld	a4,-48(s0)
  62:	00170793          	addi	a5,a4,1
  66:	fcf43823          	sd	a5,-48(s0)
  6a:	fd843783          	ld	a5,-40(s0)
  6e:	00178693          	addi	a3,a5,1
  72:	fcd43c23          	sd	a3,-40(s0)
  76:	00074703          	lbu	a4,0(a4)
  7a:	00e78023          	sb	a4,0(a5)
  7e:	0007c783          	lbu	a5,0(a5)
  82:	fff1                	bnez	a5,5e <strcpy+0x1a>
    ;
  return os;
  84:	fe843783          	ld	a5,-24(s0)
}
  88:	853e                	mv	a0,a5
  8a:	70a2                	ld	ra,40(sp)
  8c:	7402                	ld	s0,32(sp)
  8e:	6145                	addi	sp,sp,48
  90:	8082                	ret

0000000000000092 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  92:	1101                	addi	sp,sp,-32
  94:	ec06                	sd	ra,24(sp)
  96:	e822                	sd	s0,16(sp)
  98:	1000                	addi	s0,sp,32
  9a:	fea43423          	sd	a0,-24(s0)
  9e:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
  a2:	a819                	j	b8 <strcmp+0x26>
    p++, q++;
  a4:	fe843783          	ld	a5,-24(s0)
  a8:	0785                	addi	a5,a5,1
  aa:	fef43423          	sd	a5,-24(s0)
  ae:	fe043783          	ld	a5,-32(s0)
  b2:	0785                	addi	a5,a5,1
  b4:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
  b8:	fe843783          	ld	a5,-24(s0)
  bc:	0007c783          	lbu	a5,0(a5)
  c0:	cb99                	beqz	a5,d6 <strcmp+0x44>
  c2:	fe843783          	ld	a5,-24(s0)
  c6:	0007c703          	lbu	a4,0(a5)
  ca:	fe043783          	ld	a5,-32(s0)
  ce:	0007c783          	lbu	a5,0(a5)
  d2:	fcf709e3          	beq	a4,a5,a4 <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
  d6:	fe843783          	ld	a5,-24(s0)
  da:	0007c783          	lbu	a5,0(a5)
  de:	0007871b          	sext.w	a4,a5
  e2:	fe043783          	ld	a5,-32(s0)
  e6:	0007c783          	lbu	a5,0(a5)
  ea:	2781                	sext.w	a5,a5
  ec:	40f707bb          	subw	a5,a4,a5
  f0:	2781                	sext.w	a5,a5
}
  f2:	853e                	mv	a0,a5
  f4:	60e2                	ld	ra,24(sp)
  f6:	6442                	ld	s0,16(sp)
  f8:	6105                	addi	sp,sp,32
  fa:	8082                	ret

00000000000000fc <strlen>:

uint
strlen(const char *s)
{
  fc:	7179                	addi	sp,sp,-48
  fe:	f406                	sd	ra,40(sp)
 100:	f022                	sd	s0,32(sp)
 102:	1800                	addi	s0,sp,48
 104:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
 108:	fe042623          	sw	zero,-20(s0)
 10c:	a031                	j	118 <strlen+0x1c>
 10e:	fec42783          	lw	a5,-20(s0)
 112:	2785                	addiw	a5,a5,1
 114:	fef42623          	sw	a5,-20(s0)
 118:	fec42783          	lw	a5,-20(s0)
 11c:	fd843703          	ld	a4,-40(s0)
 120:	97ba                	add	a5,a5,a4
 122:	0007c783          	lbu	a5,0(a5)
 126:	f7e5                	bnez	a5,10e <strlen+0x12>
    ;
  return n;
 128:	fec42783          	lw	a5,-20(s0)
}
 12c:	853e                	mv	a0,a5
 12e:	70a2                	ld	ra,40(sp)
 130:	7402                	ld	s0,32(sp)
 132:	6145                	addi	sp,sp,48
 134:	8082                	ret

0000000000000136 <memset>:

void*
memset(void *dst, int c, uint n)
{
 136:	7179                	addi	sp,sp,-48
 138:	f406                	sd	ra,40(sp)
 13a:	f022                	sd	s0,32(sp)
 13c:	1800                	addi	s0,sp,48
 13e:	fca43c23          	sd	a0,-40(s0)
 142:	87ae                	mv	a5,a1
 144:	8732                	mv	a4,a2
 146:	fcf42a23          	sw	a5,-44(s0)
 14a:	87ba                	mv	a5,a4
 14c:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
 150:	fd843783          	ld	a5,-40(s0)
 154:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
 158:	fe042623          	sw	zero,-20(s0)
 15c:	a00d                	j	17e <memset+0x48>
    cdst[i] = c;
 15e:	fec42783          	lw	a5,-20(s0)
 162:	fe043703          	ld	a4,-32(s0)
 166:	97ba                	add	a5,a5,a4
 168:	fd442703          	lw	a4,-44(s0)
 16c:	0ff77713          	zext.b	a4,a4
 170:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
 174:	fec42783          	lw	a5,-20(s0)
 178:	2785                	addiw	a5,a5,1
 17a:	fef42623          	sw	a5,-20(s0)
 17e:	fec42783          	lw	a5,-20(s0)
 182:	fd042703          	lw	a4,-48(s0)
 186:	2701                	sext.w	a4,a4
 188:	fce7ebe3          	bltu	a5,a4,15e <memset+0x28>
  }
  return dst;
 18c:	fd843783          	ld	a5,-40(s0)
}
 190:	853e                	mv	a0,a5
 192:	70a2                	ld	ra,40(sp)
 194:	7402                	ld	s0,32(sp)
 196:	6145                	addi	sp,sp,48
 198:	8082                	ret

000000000000019a <strchr>:

char*
strchr(const char *s, char c)
{
 19a:	1101                	addi	sp,sp,-32
 19c:	ec06                	sd	ra,24(sp)
 19e:	e822                	sd	s0,16(sp)
 1a0:	1000                	addi	s0,sp,32
 1a2:	fea43423          	sd	a0,-24(s0)
 1a6:	87ae                	mv	a5,a1
 1a8:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
 1ac:	a01d                	j	1d2 <strchr+0x38>
    if(*s == c)
 1ae:	fe843783          	ld	a5,-24(s0)
 1b2:	0007c703          	lbu	a4,0(a5)
 1b6:	fe744783          	lbu	a5,-25(s0)
 1ba:	0ff7f793          	zext.b	a5,a5
 1be:	00e79563          	bne	a5,a4,1c8 <strchr+0x2e>
      return (char*)s;
 1c2:	fe843783          	ld	a5,-24(s0)
 1c6:	a821                	j	1de <strchr+0x44>
  for(; *s; s++)
 1c8:	fe843783          	ld	a5,-24(s0)
 1cc:	0785                	addi	a5,a5,1
 1ce:	fef43423          	sd	a5,-24(s0)
 1d2:	fe843783          	ld	a5,-24(s0)
 1d6:	0007c783          	lbu	a5,0(a5)
 1da:	fbf1                	bnez	a5,1ae <strchr+0x14>
  return 0;
 1dc:	4781                	li	a5,0
}
 1de:	853e                	mv	a0,a5
 1e0:	60e2                	ld	ra,24(sp)
 1e2:	6442                	ld	s0,16(sp)
 1e4:	6105                	addi	sp,sp,32
 1e6:	8082                	ret

00000000000001e8 <gets>:

char*
gets(char *buf, int max)
{
 1e8:	7179                	addi	sp,sp,-48
 1ea:	f406                	sd	ra,40(sp)
 1ec:	f022                	sd	s0,32(sp)
 1ee:	1800                	addi	s0,sp,48
 1f0:	fca43c23          	sd	a0,-40(s0)
 1f4:	87ae                	mv	a5,a1
 1f6:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1fa:	fe042623          	sw	zero,-20(s0)
 1fe:	a8a1                	j	256 <gets+0x6e>
    cc = read(0, &c, 1);
 200:	fe740793          	addi	a5,s0,-25
 204:	4605                	li	a2,1
 206:	85be                	mv	a1,a5
 208:	4501                	li	a0,0
 20a:	00000097          	auipc	ra,0x0
 20e:	302080e7          	jalr	770(ra) # 50c <read>
 212:	87aa                	mv	a5,a0
 214:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
 218:	fe842783          	lw	a5,-24(s0)
 21c:	2781                	sext.w	a5,a5
 21e:	04f05663          	blez	a5,26a <gets+0x82>
      break;
    buf[i++] = c;
 222:	fec42783          	lw	a5,-20(s0)
 226:	0017871b          	addiw	a4,a5,1
 22a:	fee42623          	sw	a4,-20(s0)
 22e:	873e                	mv	a4,a5
 230:	fd843783          	ld	a5,-40(s0)
 234:	97ba                	add	a5,a5,a4
 236:	fe744703          	lbu	a4,-25(s0)
 23a:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
 23e:	fe744783          	lbu	a5,-25(s0)
 242:	873e                	mv	a4,a5
 244:	47a9                	li	a5,10
 246:	02f70363          	beq	a4,a5,26c <gets+0x84>
 24a:	fe744783          	lbu	a5,-25(s0)
 24e:	873e                	mv	a4,a5
 250:	47b5                	li	a5,13
 252:	00f70d63          	beq	a4,a5,26c <gets+0x84>
  for(i=0; i+1 < max; ){
 256:	fec42783          	lw	a5,-20(s0)
 25a:	2785                	addiw	a5,a5,1
 25c:	2781                	sext.w	a5,a5
 25e:	fd442703          	lw	a4,-44(s0)
 262:	2701                	sext.w	a4,a4
 264:	f8e7cee3          	blt	a5,a4,200 <gets+0x18>
 268:	a011                	j	26c <gets+0x84>
      break;
 26a:	0001                	nop
      break;
  }
  buf[i] = '\0';
 26c:	fec42783          	lw	a5,-20(s0)
 270:	fd843703          	ld	a4,-40(s0)
 274:	97ba                	add	a5,a5,a4
 276:	00078023          	sb	zero,0(a5)
  return buf;
 27a:	fd843783          	ld	a5,-40(s0)
}
 27e:	853e                	mv	a0,a5
 280:	70a2                	ld	ra,40(sp)
 282:	7402                	ld	s0,32(sp)
 284:	6145                	addi	sp,sp,48
 286:	8082                	ret

0000000000000288 <stat>:

int
stat(const char *n, struct stat *st)
{
 288:	7179                	addi	sp,sp,-48
 28a:	f406                	sd	ra,40(sp)
 28c:	f022                	sd	s0,32(sp)
 28e:	1800                	addi	s0,sp,48
 290:	fca43c23          	sd	a0,-40(s0)
 294:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 298:	4581                	li	a1,0
 29a:	fd843503          	ld	a0,-40(s0)
 29e:	00000097          	auipc	ra,0x0
 2a2:	296080e7          	jalr	662(ra) # 534 <open>
 2a6:	87aa                	mv	a5,a0
 2a8:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
 2ac:	fec42783          	lw	a5,-20(s0)
 2b0:	2781                	sext.w	a5,a5
 2b2:	0007d463          	bgez	a5,2ba <stat+0x32>
    return -1;
 2b6:	57fd                	li	a5,-1
 2b8:	a035                	j	2e4 <stat+0x5c>
  r = fstat(fd, st);
 2ba:	fec42783          	lw	a5,-20(s0)
 2be:	fd043583          	ld	a1,-48(s0)
 2c2:	853e                	mv	a0,a5
 2c4:	00000097          	auipc	ra,0x0
 2c8:	288080e7          	jalr	648(ra) # 54c <fstat>
 2cc:	87aa                	mv	a5,a0
 2ce:	fef42423          	sw	a5,-24(s0)
  close(fd);
 2d2:	fec42783          	lw	a5,-20(s0)
 2d6:	853e                	mv	a0,a5
 2d8:	00000097          	auipc	ra,0x0
 2dc:	244080e7          	jalr	580(ra) # 51c <close>
  return r;
 2e0:	fe842783          	lw	a5,-24(s0)
}
 2e4:	853e                	mv	a0,a5
 2e6:	70a2                	ld	ra,40(sp)
 2e8:	7402                	ld	s0,32(sp)
 2ea:	6145                	addi	sp,sp,48
 2ec:	8082                	ret

00000000000002ee <atoi>:

int
atoi(const char *s)
{
 2ee:	7179                	addi	sp,sp,-48
 2f0:	f406                	sd	ra,40(sp)
 2f2:	f022                	sd	s0,32(sp)
 2f4:	1800                	addi	s0,sp,48
 2f6:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
 2fa:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
 2fe:	a81d                	j	334 <atoi+0x46>
    n = n*10 + *s++ - '0';
 300:	fec42783          	lw	a5,-20(s0)
 304:	873e                	mv	a4,a5
 306:	87ba                	mv	a5,a4
 308:	0027979b          	slliw	a5,a5,0x2
 30c:	9fb9                	addw	a5,a5,a4
 30e:	0017979b          	slliw	a5,a5,0x1
 312:	0007871b          	sext.w	a4,a5
 316:	fd843783          	ld	a5,-40(s0)
 31a:	00178693          	addi	a3,a5,1
 31e:	fcd43c23          	sd	a3,-40(s0)
 322:	0007c783          	lbu	a5,0(a5)
 326:	2781                	sext.w	a5,a5
 328:	9fb9                	addw	a5,a5,a4
 32a:	2781                	sext.w	a5,a5
 32c:	fd07879b          	addiw	a5,a5,-48
 330:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
 334:	fd843783          	ld	a5,-40(s0)
 338:	0007c783          	lbu	a5,0(a5)
 33c:	873e                	mv	a4,a5
 33e:	02f00793          	li	a5,47
 342:	00e7fb63          	bgeu	a5,a4,358 <atoi+0x6a>
 346:	fd843783          	ld	a5,-40(s0)
 34a:	0007c783          	lbu	a5,0(a5)
 34e:	873e                	mv	a4,a5
 350:	03900793          	li	a5,57
 354:	fae7f6e3          	bgeu	a5,a4,300 <atoi+0x12>
  return n;
 358:	fec42783          	lw	a5,-20(s0)
}
 35c:	853e                	mv	a0,a5
 35e:	70a2                	ld	ra,40(sp)
 360:	7402                	ld	s0,32(sp)
 362:	6145                	addi	sp,sp,48
 364:	8082                	ret

0000000000000366 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 366:	7139                	addi	sp,sp,-64
 368:	fc06                	sd	ra,56(sp)
 36a:	f822                	sd	s0,48(sp)
 36c:	0080                	addi	s0,sp,64
 36e:	fca43c23          	sd	a0,-40(s0)
 372:	fcb43823          	sd	a1,-48(s0)
 376:	87b2                	mv	a5,a2
 378:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
 37c:	fd843783          	ld	a5,-40(s0)
 380:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
 384:	fd043783          	ld	a5,-48(s0)
 388:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
 38c:	fe043703          	ld	a4,-32(s0)
 390:	fe843783          	ld	a5,-24(s0)
 394:	02e7fc63          	bgeu	a5,a4,3cc <memmove+0x66>
    while(n-- > 0)
 398:	a00d                	j	3ba <memmove+0x54>
      *dst++ = *src++;
 39a:	fe043703          	ld	a4,-32(s0)
 39e:	00170793          	addi	a5,a4,1
 3a2:	fef43023          	sd	a5,-32(s0)
 3a6:	fe843783          	ld	a5,-24(s0)
 3aa:	00178693          	addi	a3,a5,1
 3ae:	fed43423          	sd	a3,-24(s0)
 3b2:	00074703          	lbu	a4,0(a4)
 3b6:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 3ba:	fcc42783          	lw	a5,-52(s0)
 3be:	fff7871b          	addiw	a4,a5,-1
 3c2:	fce42623          	sw	a4,-52(s0)
 3c6:	fcf04ae3          	bgtz	a5,39a <memmove+0x34>
 3ca:	a891                	j	41e <memmove+0xb8>
  } else {
    dst += n;
 3cc:	fcc42783          	lw	a5,-52(s0)
 3d0:	fe843703          	ld	a4,-24(s0)
 3d4:	97ba                	add	a5,a5,a4
 3d6:	fef43423          	sd	a5,-24(s0)
    src += n;
 3da:	fcc42783          	lw	a5,-52(s0)
 3de:	fe043703          	ld	a4,-32(s0)
 3e2:	97ba                	add	a5,a5,a4
 3e4:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
 3e8:	a01d                	j	40e <memmove+0xa8>
      *--dst = *--src;
 3ea:	fe043783          	ld	a5,-32(s0)
 3ee:	17fd                	addi	a5,a5,-1
 3f0:	fef43023          	sd	a5,-32(s0)
 3f4:	fe843783          	ld	a5,-24(s0)
 3f8:	17fd                	addi	a5,a5,-1
 3fa:	fef43423          	sd	a5,-24(s0)
 3fe:	fe043783          	ld	a5,-32(s0)
 402:	0007c703          	lbu	a4,0(a5)
 406:	fe843783          	ld	a5,-24(s0)
 40a:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 40e:	fcc42783          	lw	a5,-52(s0)
 412:	fff7871b          	addiw	a4,a5,-1
 416:	fce42623          	sw	a4,-52(s0)
 41a:	fcf048e3          	bgtz	a5,3ea <memmove+0x84>
  }
  return vdst;
 41e:	fd843783          	ld	a5,-40(s0)
}
 422:	853e                	mv	a0,a5
 424:	70e2                	ld	ra,56(sp)
 426:	7442                	ld	s0,48(sp)
 428:	6121                	addi	sp,sp,64
 42a:	8082                	ret

000000000000042c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 42c:	7139                	addi	sp,sp,-64
 42e:	fc06                	sd	ra,56(sp)
 430:	f822                	sd	s0,48(sp)
 432:	0080                	addi	s0,sp,64
 434:	fca43c23          	sd	a0,-40(s0)
 438:	fcb43823          	sd	a1,-48(s0)
 43c:	87b2                	mv	a5,a2
 43e:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
 442:	fd843783          	ld	a5,-40(s0)
 446:	fef43423          	sd	a5,-24(s0)
 44a:	fd043783          	ld	a5,-48(s0)
 44e:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 452:	a0a1                	j	49a <memcmp+0x6e>
    if (*p1 != *p2) {
 454:	fe843783          	ld	a5,-24(s0)
 458:	0007c703          	lbu	a4,0(a5)
 45c:	fe043783          	ld	a5,-32(s0)
 460:	0007c783          	lbu	a5,0(a5)
 464:	02f70163          	beq	a4,a5,486 <memcmp+0x5a>
      return *p1 - *p2;
 468:	fe843783          	ld	a5,-24(s0)
 46c:	0007c783          	lbu	a5,0(a5)
 470:	0007871b          	sext.w	a4,a5
 474:	fe043783          	ld	a5,-32(s0)
 478:	0007c783          	lbu	a5,0(a5)
 47c:	2781                	sext.w	a5,a5
 47e:	40f707bb          	subw	a5,a4,a5
 482:	2781                	sext.w	a5,a5
 484:	a01d                	j	4aa <memcmp+0x7e>
    }
    p1++;
 486:	fe843783          	ld	a5,-24(s0)
 48a:	0785                	addi	a5,a5,1
 48c:	fef43423          	sd	a5,-24(s0)
    p2++;
 490:	fe043783          	ld	a5,-32(s0)
 494:	0785                	addi	a5,a5,1
 496:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 49a:	fcc42783          	lw	a5,-52(s0)
 49e:	fff7871b          	addiw	a4,a5,-1
 4a2:	fce42623          	sw	a4,-52(s0)
 4a6:	f7dd                	bnez	a5,454 <memcmp+0x28>
  }
  return 0;
 4a8:	4781                	li	a5,0
}
 4aa:	853e                	mv	a0,a5
 4ac:	70e2                	ld	ra,56(sp)
 4ae:	7442                	ld	s0,48(sp)
 4b0:	6121                	addi	sp,sp,64
 4b2:	8082                	ret

00000000000004b4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4b4:	7179                	addi	sp,sp,-48
 4b6:	f406                	sd	ra,40(sp)
 4b8:	f022                	sd	s0,32(sp)
 4ba:	1800                	addi	s0,sp,48
 4bc:	fea43423          	sd	a0,-24(s0)
 4c0:	feb43023          	sd	a1,-32(s0)
 4c4:	87b2                	mv	a5,a2
 4c6:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
 4ca:	fdc42783          	lw	a5,-36(s0)
 4ce:	863e                	mv	a2,a5
 4d0:	fe043583          	ld	a1,-32(s0)
 4d4:	fe843503          	ld	a0,-24(s0)
 4d8:	00000097          	auipc	ra,0x0
 4dc:	e8e080e7          	jalr	-370(ra) # 366 <memmove>
 4e0:	87aa                	mv	a5,a0
}
 4e2:	853e                	mv	a0,a5
 4e4:	70a2                	ld	ra,40(sp)
 4e6:	7402                	ld	s0,32(sp)
 4e8:	6145                	addi	sp,sp,48
 4ea:	8082                	ret

00000000000004ec <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4ec:	4885                	li	a7,1
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4f4:	4889                	li	a7,2
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <wait>:
.global wait
wait:
 li a7, SYS_wait
 4fc:	488d                	li	a7,3
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 504:	4891                	li	a7,4
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <read>:
.global read
read:
 li a7, SYS_read
 50c:	4895                	li	a7,5
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <write>:
.global write
write:
 li a7, SYS_write
 514:	48c1                	li	a7,16
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <close>:
.global close
close:
 li a7, SYS_close
 51c:	48d5                	li	a7,21
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <kill>:
.global kill
kill:
 li a7, SYS_kill
 524:	4899                	li	a7,6
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <exec>:
.global exec
exec:
 li a7, SYS_exec
 52c:	489d                	li	a7,7
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <open>:
.global open
open:
 li a7, SYS_open
 534:	48bd                	li	a7,15
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 53c:	48c5                	li	a7,17
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 544:	48c9                	li	a7,18
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 54c:	48a1                	li	a7,8
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <link>:
.global link
link:
 li a7, SYS_link
 554:	48cd                	li	a7,19
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 55c:	48d1                	li	a7,20
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 564:	48a5                	li	a7,9
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <dup>:
.global dup
dup:
 li a7, SYS_dup
 56c:	48a9                	li	a7,10
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 574:	48ad                	li	a7,11
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 57c:	48b1                	li	a7,12
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 584:	48b5                	li	a7,13
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 58c:	48b9                	li	a7,14
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <ps>:
.global ps
ps:
 li a7, SYS_ps
 594:	48d9                	li	a7,22
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 59c:	1101                	addi	sp,sp,-32
 59e:	ec06                	sd	ra,24(sp)
 5a0:	e822                	sd	s0,16(sp)
 5a2:	1000                	addi	s0,sp,32
 5a4:	87aa                	mv	a5,a0
 5a6:	872e                	mv	a4,a1
 5a8:	fef42623          	sw	a5,-20(s0)
 5ac:	87ba                	mv	a5,a4
 5ae:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 5b2:	feb40713          	addi	a4,s0,-21
 5b6:	fec42783          	lw	a5,-20(s0)
 5ba:	4605                	li	a2,1
 5bc:	85ba                	mv	a1,a4
 5be:	853e                	mv	a0,a5
 5c0:	00000097          	auipc	ra,0x0
 5c4:	f54080e7          	jalr	-172(ra) # 514 <write>
}
 5c8:	0001                	nop
 5ca:	60e2                	ld	ra,24(sp)
 5cc:	6442                	ld	s0,16(sp)
 5ce:	6105                	addi	sp,sp,32
 5d0:	8082                	ret

00000000000005d2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5d2:	7139                	addi	sp,sp,-64
 5d4:	fc06                	sd	ra,56(sp)
 5d6:	f822                	sd	s0,48(sp)
 5d8:	0080                	addi	s0,sp,64
 5da:	87aa                	mv	a5,a0
 5dc:	8736                	mv	a4,a3
 5de:	fcf42623          	sw	a5,-52(s0)
 5e2:	87ae                	mv	a5,a1
 5e4:	fcf42423          	sw	a5,-56(s0)
 5e8:	87b2                	mv	a5,a2
 5ea:	fcf42223          	sw	a5,-60(s0)
 5ee:	87ba                	mv	a5,a4
 5f0:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5f4:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 5f8:	fc042783          	lw	a5,-64(s0)
 5fc:	2781                	sext.w	a5,a5
 5fe:	c38d                	beqz	a5,620 <printint+0x4e>
 600:	fc842783          	lw	a5,-56(s0)
 604:	2781                	sext.w	a5,a5
 606:	0007dd63          	bgez	a5,620 <printint+0x4e>
    neg = 1;
 60a:	4785                	li	a5,1
 60c:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 610:	fc842783          	lw	a5,-56(s0)
 614:	40f007bb          	negw	a5,a5
 618:	2781                	sext.w	a5,a5
 61a:	fef42223          	sw	a5,-28(s0)
 61e:	a029                	j	628 <printint+0x56>
  } else {
    x = xx;
 620:	fc842783          	lw	a5,-56(s0)
 624:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 628:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 62c:	fc442783          	lw	a5,-60(s0)
 630:	fe442703          	lw	a4,-28(s0)
 634:	02f777bb          	remuw	a5,a4,a5
 638:	0007871b          	sext.w	a4,a5
 63c:	fec42783          	lw	a5,-20(s0)
 640:	0017869b          	addiw	a3,a5,1
 644:	fed42623          	sw	a3,-20(s0)
 648:	00001697          	auipc	a3,0x1
 64c:	9b868693          	addi	a3,a3,-1608 # 1000 <digits>
 650:	1702                	slli	a4,a4,0x20
 652:	9301                	srli	a4,a4,0x20
 654:	9736                	add	a4,a4,a3
 656:	00074703          	lbu	a4,0(a4)
 65a:	17c1                	addi	a5,a5,-16
 65c:	97a2                	add	a5,a5,s0
 65e:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 662:	fc442783          	lw	a5,-60(s0)
 666:	fe442703          	lw	a4,-28(s0)
 66a:	02f757bb          	divuw	a5,a4,a5
 66e:	fef42223          	sw	a5,-28(s0)
 672:	fe442783          	lw	a5,-28(s0)
 676:	2781                	sext.w	a5,a5
 678:	fbd5                	bnez	a5,62c <printint+0x5a>
  if(neg)
 67a:	fe842783          	lw	a5,-24(s0)
 67e:	2781                	sext.w	a5,a5
 680:	cf85                	beqz	a5,6b8 <printint+0xe6>
    buf[i++] = '-';
 682:	fec42783          	lw	a5,-20(s0)
 686:	0017871b          	addiw	a4,a5,1
 68a:	fee42623          	sw	a4,-20(s0)
 68e:	17c1                	addi	a5,a5,-16
 690:	97a2                	add	a5,a5,s0
 692:	02d00713          	li	a4,45
 696:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 69a:	a839                	j	6b8 <printint+0xe6>
    putc(fd, buf[i]);
 69c:	fec42783          	lw	a5,-20(s0)
 6a0:	17c1                	addi	a5,a5,-16
 6a2:	97a2                	add	a5,a5,s0
 6a4:	fe07c703          	lbu	a4,-32(a5)
 6a8:	fcc42783          	lw	a5,-52(s0)
 6ac:	85ba                	mv	a1,a4
 6ae:	853e                	mv	a0,a5
 6b0:	00000097          	auipc	ra,0x0
 6b4:	eec080e7          	jalr	-276(ra) # 59c <putc>
  while(--i >= 0)
 6b8:	fec42783          	lw	a5,-20(s0)
 6bc:	37fd                	addiw	a5,a5,-1
 6be:	fef42623          	sw	a5,-20(s0)
 6c2:	fec42783          	lw	a5,-20(s0)
 6c6:	2781                	sext.w	a5,a5
 6c8:	fc07dae3          	bgez	a5,69c <printint+0xca>
}
 6cc:	0001                	nop
 6ce:	0001                	nop
 6d0:	70e2                	ld	ra,56(sp)
 6d2:	7442                	ld	s0,48(sp)
 6d4:	6121                	addi	sp,sp,64
 6d6:	8082                	ret

00000000000006d8 <printptr>:

static void
printptr(int fd, uint64 x) {
 6d8:	7179                	addi	sp,sp,-48
 6da:	f406                	sd	ra,40(sp)
 6dc:	f022                	sd	s0,32(sp)
 6de:	1800                	addi	s0,sp,48
 6e0:	87aa                	mv	a5,a0
 6e2:	fcb43823          	sd	a1,-48(s0)
 6e6:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 6ea:	fdc42783          	lw	a5,-36(s0)
 6ee:	03000593          	li	a1,48
 6f2:	853e                	mv	a0,a5
 6f4:	00000097          	auipc	ra,0x0
 6f8:	ea8080e7          	jalr	-344(ra) # 59c <putc>
  putc(fd, 'x');
 6fc:	fdc42783          	lw	a5,-36(s0)
 700:	07800593          	li	a1,120
 704:	853e                	mv	a0,a5
 706:	00000097          	auipc	ra,0x0
 70a:	e96080e7          	jalr	-362(ra) # 59c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 70e:	fe042623          	sw	zero,-20(s0)
 712:	a82d                	j	74c <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 714:	fd043783          	ld	a5,-48(s0)
 718:	93f1                	srli	a5,a5,0x3c
 71a:	00001717          	auipc	a4,0x1
 71e:	8e670713          	addi	a4,a4,-1818 # 1000 <digits>
 722:	97ba                	add	a5,a5,a4
 724:	0007c703          	lbu	a4,0(a5)
 728:	fdc42783          	lw	a5,-36(s0)
 72c:	85ba                	mv	a1,a4
 72e:	853e                	mv	a0,a5
 730:	00000097          	auipc	ra,0x0
 734:	e6c080e7          	jalr	-404(ra) # 59c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 738:	fec42783          	lw	a5,-20(s0)
 73c:	2785                	addiw	a5,a5,1
 73e:	fef42623          	sw	a5,-20(s0)
 742:	fd043783          	ld	a5,-48(s0)
 746:	0792                	slli	a5,a5,0x4
 748:	fcf43823          	sd	a5,-48(s0)
 74c:	fec42703          	lw	a4,-20(s0)
 750:	47bd                	li	a5,15
 752:	fce7f1e3          	bgeu	a5,a4,714 <printptr+0x3c>
}
 756:	0001                	nop
 758:	0001                	nop
 75a:	70a2                	ld	ra,40(sp)
 75c:	7402                	ld	s0,32(sp)
 75e:	6145                	addi	sp,sp,48
 760:	8082                	ret

0000000000000762 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 762:	715d                	addi	sp,sp,-80
 764:	e486                	sd	ra,72(sp)
 766:	e0a2                	sd	s0,64(sp)
 768:	0880                	addi	s0,sp,80
 76a:	87aa                	mv	a5,a0
 76c:	fcb43023          	sd	a1,-64(s0)
 770:	fac43c23          	sd	a2,-72(s0)
 774:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 778:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 77c:	fe042223          	sw	zero,-28(s0)
 780:	a42d                	j	9aa <vprintf+0x248>
    c = fmt[i] & 0xff;
 782:	fe442783          	lw	a5,-28(s0)
 786:	fc043703          	ld	a4,-64(s0)
 78a:	97ba                	add	a5,a5,a4
 78c:	0007c783          	lbu	a5,0(a5)
 790:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 794:	fe042783          	lw	a5,-32(s0)
 798:	2781                	sext.w	a5,a5
 79a:	eb9d                	bnez	a5,7d0 <vprintf+0x6e>
      if(c == '%'){
 79c:	fdc42783          	lw	a5,-36(s0)
 7a0:	0007871b          	sext.w	a4,a5
 7a4:	02500793          	li	a5,37
 7a8:	00f71763          	bne	a4,a5,7b6 <vprintf+0x54>
        state = '%';
 7ac:	02500793          	li	a5,37
 7b0:	fef42023          	sw	a5,-32(s0)
 7b4:	a2f5                	j	9a0 <vprintf+0x23e>
      } else {
        putc(fd, c);
 7b6:	fdc42783          	lw	a5,-36(s0)
 7ba:	0ff7f713          	zext.b	a4,a5
 7be:	fcc42783          	lw	a5,-52(s0)
 7c2:	85ba                	mv	a1,a4
 7c4:	853e                	mv	a0,a5
 7c6:	00000097          	auipc	ra,0x0
 7ca:	dd6080e7          	jalr	-554(ra) # 59c <putc>
 7ce:	aac9                	j	9a0 <vprintf+0x23e>
      }
    } else if(state == '%'){
 7d0:	fe042783          	lw	a5,-32(s0)
 7d4:	0007871b          	sext.w	a4,a5
 7d8:	02500793          	li	a5,37
 7dc:	1cf71263          	bne	a4,a5,9a0 <vprintf+0x23e>
      if(c == 'd'){
 7e0:	fdc42783          	lw	a5,-36(s0)
 7e4:	0007871b          	sext.w	a4,a5
 7e8:	06400793          	li	a5,100
 7ec:	02f71463          	bne	a4,a5,814 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 7f0:	fb843783          	ld	a5,-72(s0)
 7f4:	00878713          	addi	a4,a5,8
 7f8:	fae43c23          	sd	a4,-72(s0)
 7fc:	4398                	lw	a4,0(a5)
 7fe:	fcc42783          	lw	a5,-52(s0)
 802:	4685                	li	a3,1
 804:	4629                	li	a2,10
 806:	85ba                	mv	a1,a4
 808:	853e                	mv	a0,a5
 80a:	00000097          	auipc	ra,0x0
 80e:	dc8080e7          	jalr	-568(ra) # 5d2 <printint>
 812:	a269                	j	99c <vprintf+0x23a>
      } else if(c == 'l') {
 814:	fdc42783          	lw	a5,-36(s0)
 818:	0007871b          	sext.w	a4,a5
 81c:	06c00793          	li	a5,108
 820:	02f71663          	bne	a4,a5,84c <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 824:	fb843783          	ld	a5,-72(s0)
 828:	00878713          	addi	a4,a5,8
 82c:	fae43c23          	sd	a4,-72(s0)
 830:	639c                	ld	a5,0(a5)
 832:	0007871b          	sext.w	a4,a5
 836:	fcc42783          	lw	a5,-52(s0)
 83a:	4681                	li	a3,0
 83c:	4629                	li	a2,10
 83e:	85ba                	mv	a1,a4
 840:	853e                	mv	a0,a5
 842:	00000097          	auipc	ra,0x0
 846:	d90080e7          	jalr	-624(ra) # 5d2 <printint>
 84a:	aa89                	j	99c <vprintf+0x23a>
      } else if(c == 'x') {
 84c:	fdc42783          	lw	a5,-36(s0)
 850:	0007871b          	sext.w	a4,a5
 854:	07800793          	li	a5,120
 858:	02f71463          	bne	a4,a5,880 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 85c:	fb843783          	ld	a5,-72(s0)
 860:	00878713          	addi	a4,a5,8
 864:	fae43c23          	sd	a4,-72(s0)
 868:	4398                	lw	a4,0(a5)
 86a:	fcc42783          	lw	a5,-52(s0)
 86e:	4681                	li	a3,0
 870:	4641                	li	a2,16
 872:	85ba                	mv	a1,a4
 874:	853e                	mv	a0,a5
 876:	00000097          	auipc	ra,0x0
 87a:	d5c080e7          	jalr	-676(ra) # 5d2 <printint>
 87e:	aa39                	j	99c <vprintf+0x23a>
      } else if(c == 'p') {
 880:	fdc42783          	lw	a5,-36(s0)
 884:	0007871b          	sext.w	a4,a5
 888:	07000793          	li	a5,112
 88c:	02f71263          	bne	a4,a5,8b0 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 890:	fb843783          	ld	a5,-72(s0)
 894:	00878713          	addi	a4,a5,8
 898:	fae43c23          	sd	a4,-72(s0)
 89c:	6398                	ld	a4,0(a5)
 89e:	fcc42783          	lw	a5,-52(s0)
 8a2:	85ba                	mv	a1,a4
 8a4:	853e                	mv	a0,a5
 8a6:	00000097          	auipc	ra,0x0
 8aa:	e32080e7          	jalr	-462(ra) # 6d8 <printptr>
 8ae:	a0fd                	j	99c <vprintf+0x23a>
      } else if(c == 's'){
 8b0:	fdc42783          	lw	a5,-36(s0)
 8b4:	0007871b          	sext.w	a4,a5
 8b8:	07300793          	li	a5,115
 8bc:	04f71c63          	bne	a4,a5,914 <vprintf+0x1b2>
        s = va_arg(ap, char*);
 8c0:	fb843783          	ld	a5,-72(s0)
 8c4:	00878713          	addi	a4,a5,8
 8c8:	fae43c23          	sd	a4,-72(s0)
 8cc:	639c                	ld	a5,0(a5)
 8ce:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 8d2:	fe843783          	ld	a5,-24(s0)
 8d6:	eb8d                	bnez	a5,908 <vprintf+0x1a6>
          s = "(null)";
 8d8:	00000797          	auipc	a5,0x0
 8dc:	47878793          	addi	a5,a5,1144 # d50 <malloc+0x13c>
 8e0:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 8e4:	a015                	j	908 <vprintf+0x1a6>
          putc(fd, *s);
 8e6:	fe843783          	ld	a5,-24(s0)
 8ea:	0007c703          	lbu	a4,0(a5)
 8ee:	fcc42783          	lw	a5,-52(s0)
 8f2:	85ba                	mv	a1,a4
 8f4:	853e                	mv	a0,a5
 8f6:	00000097          	auipc	ra,0x0
 8fa:	ca6080e7          	jalr	-858(ra) # 59c <putc>
          s++;
 8fe:	fe843783          	ld	a5,-24(s0)
 902:	0785                	addi	a5,a5,1
 904:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 908:	fe843783          	ld	a5,-24(s0)
 90c:	0007c783          	lbu	a5,0(a5)
 910:	fbf9                	bnez	a5,8e6 <vprintf+0x184>
 912:	a069                	j	99c <vprintf+0x23a>
        }
      } else if(c == 'c'){
 914:	fdc42783          	lw	a5,-36(s0)
 918:	0007871b          	sext.w	a4,a5
 91c:	06300793          	li	a5,99
 920:	02f71463          	bne	a4,a5,948 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 924:	fb843783          	ld	a5,-72(s0)
 928:	00878713          	addi	a4,a5,8
 92c:	fae43c23          	sd	a4,-72(s0)
 930:	439c                	lw	a5,0(a5)
 932:	0ff7f713          	zext.b	a4,a5
 936:	fcc42783          	lw	a5,-52(s0)
 93a:	85ba                	mv	a1,a4
 93c:	853e                	mv	a0,a5
 93e:	00000097          	auipc	ra,0x0
 942:	c5e080e7          	jalr	-930(ra) # 59c <putc>
 946:	a899                	j	99c <vprintf+0x23a>
      } else if(c == '%'){
 948:	fdc42783          	lw	a5,-36(s0)
 94c:	0007871b          	sext.w	a4,a5
 950:	02500793          	li	a5,37
 954:	00f71f63          	bne	a4,a5,972 <vprintf+0x210>
        putc(fd, c);
 958:	fdc42783          	lw	a5,-36(s0)
 95c:	0ff7f713          	zext.b	a4,a5
 960:	fcc42783          	lw	a5,-52(s0)
 964:	85ba                	mv	a1,a4
 966:	853e                	mv	a0,a5
 968:	00000097          	auipc	ra,0x0
 96c:	c34080e7          	jalr	-972(ra) # 59c <putc>
 970:	a035                	j	99c <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 972:	fcc42783          	lw	a5,-52(s0)
 976:	02500593          	li	a1,37
 97a:	853e                	mv	a0,a5
 97c:	00000097          	auipc	ra,0x0
 980:	c20080e7          	jalr	-992(ra) # 59c <putc>
        putc(fd, c);
 984:	fdc42783          	lw	a5,-36(s0)
 988:	0ff7f713          	zext.b	a4,a5
 98c:	fcc42783          	lw	a5,-52(s0)
 990:	85ba                	mv	a1,a4
 992:	853e                	mv	a0,a5
 994:	00000097          	auipc	ra,0x0
 998:	c08080e7          	jalr	-1016(ra) # 59c <putc>
      }
      state = 0;
 99c:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 9a0:	fe442783          	lw	a5,-28(s0)
 9a4:	2785                	addiw	a5,a5,1
 9a6:	fef42223          	sw	a5,-28(s0)
 9aa:	fe442783          	lw	a5,-28(s0)
 9ae:	fc043703          	ld	a4,-64(s0)
 9b2:	97ba                	add	a5,a5,a4
 9b4:	0007c783          	lbu	a5,0(a5)
 9b8:	dc0795e3          	bnez	a5,782 <vprintf+0x20>
    }
  }
}
 9bc:	0001                	nop
 9be:	0001                	nop
 9c0:	60a6                	ld	ra,72(sp)
 9c2:	6406                	ld	s0,64(sp)
 9c4:	6161                	addi	sp,sp,80
 9c6:	8082                	ret

00000000000009c8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9c8:	7159                	addi	sp,sp,-112
 9ca:	fc06                	sd	ra,56(sp)
 9cc:	f822                	sd	s0,48(sp)
 9ce:	0080                	addi	s0,sp,64
 9d0:	fcb43823          	sd	a1,-48(s0)
 9d4:	e010                	sd	a2,0(s0)
 9d6:	e414                	sd	a3,8(s0)
 9d8:	e818                	sd	a4,16(s0)
 9da:	ec1c                	sd	a5,24(s0)
 9dc:	03043023          	sd	a6,32(s0)
 9e0:	03143423          	sd	a7,40(s0)
 9e4:	87aa                	mv	a5,a0
 9e6:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 9ea:	03040793          	addi	a5,s0,48
 9ee:	fcf43423          	sd	a5,-56(s0)
 9f2:	fc843783          	ld	a5,-56(s0)
 9f6:	fd078793          	addi	a5,a5,-48
 9fa:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 9fe:	fe843703          	ld	a4,-24(s0)
 a02:	fdc42783          	lw	a5,-36(s0)
 a06:	863a                	mv	a2,a4
 a08:	fd043583          	ld	a1,-48(s0)
 a0c:	853e                	mv	a0,a5
 a0e:	00000097          	auipc	ra,0x0
 a12:	d54080e7          	jalr	-684(ra) # 762 <vprintf>
}
 a16:	0001                	nop
 a18:	70e2                	ld	ra,56(sp)
 a1a:	7442                	ld	s0,48(sp)
 a1c:	6165                	addi	sp,sp,112
 a1e:	8082                	ret

0000000000000a20 <printf>:

void
printf(const char *fmt, ...)
{
 a20:	7159                	addi	sp,sp,-112
 a22:	f406                	sd	ra,40(sp)
 a24:	f022                	sd	s0,32(sp)
 a26:	1800                	addi	s0,sp,48
 a28:	fca43c23          	sd	a0,-40(s0)
 a2c:	e40c                	sd	a1,8(s0)
 a2e:	e810                	sd	a2,16(s0)
 a30:	ec14                	sd	a3,24(s0)
 a32:	f018                	sd	a4,32(s0)
 a34:	f41c                	sd	a5,40(s0)
 a36:	03043823          	sd	a6,48(s0)
 a3a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a3e:	04040793          	addi	a5,s0,64
 a42:	fcf43823          	sd	a5,-48(s0)
 a46:	fd043783          	ld	a5,-48(s0)
 a4a:	fc878793          	addi	a5,a5,-56
 a4e:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 a52:	fe843783          	ld	a5,-24(s0)
 a56:	863e                	mv	a2,a5
 a58:	fd843583          	ld	a1,-40(s0)
 a5c:	4505                	li	a0,1
 a5e:	00000097          	auipc	ra,0x0
 a62:	d04080e7          	jalr	-764(ra) # 762 <vprintf>
}
 a66:	0001                	nop
 a68:	70a2                	ld	ra,40(sp)
 a6a:	7402                	ld	s0,32(sp)
 a6c:	6165                	addi	sp,sp,112
 a6e:	8082                	ret

0000000000000a70 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a70:	7179                	addi	sp,sp,-48
 a72:	f406                	sd	ra,40(sp)
 a74:	f022                	sd	s0,32(sp)
 a76:	1800                	addi	s0,sp,48
 a78:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a7c:	fd843783          	ld	a5,-40(s0)
 a80:	17c1                	addi	a5,a5,-16
 a82:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a86:	00000797          	auipc	a5,0x0
 a8a:	5aa78793          	addi	a5,a5,1450 # 1030 <freep>
 a8e:	639c                	ld	a5,0(a5)
 a90:	fef43423          	sd	a5,-24(s0)
 a94:	a815                	j	ac8 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a96:	fe843783          	ld	a5,-24(s0)
 a9a:	639c                	ld	a5,0(a5)
 a9c:	fe843703          	ld	a4,-24(s0)
 aa0:	00f76f63          	bltu	a4,a5,abe <free+0x4e>
 aa4:	fe043703          	ld	a4,-32(s0)
 aa8:	fe843783          	ld	a5,-24(s0)
 aac:	02e7eb63          	bltu	a5,a4,ae2 <free+0x72>
 ab0:	fe843783          	ld	a5,-24(s0)
 ab4:	639c                	ld	a5,0(a5)
 ab6:	fe043703          	ld	a4,-32(s0)
 aba:	02f76463          	bltu	a4,a5,ae2 <free+0x72>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 abe:	fe843783          	ld	a5,-24(s0)
 ac2:	639c                	ld	a5,0(a5)
 ac4:	fef43423          	sd	a5,-24(s0)
 ac8:	fe043703          	ld	a4,-32(s0)
 acc:	fe843783          	ld	a5,-24(s0)
 ad0:	fce7f3e3          	bgeu	a5,a4,a96 <free+0x26>
 ad4:	fe843783          	ld	a5,-24(s0)
 ad8:	639c                	ld	a5,0(a5)
 ada:	fe043703          	ld	a4,-32(s0)
 ade:	faf77ce3          	bgeu	a4,a5,a96 <free+0x26>
      break;
  if(bp + bp->s.size == p->s.ptr){
 ae2:	fe043783          	ld	a5,-32(s0)
 ae6:	479c                	lw	a5,8(a5)
 ae8:	1782                	slli	a5,a5,0x20
 aea:	9381                	srli	a5,a5,0x20
 aec:	0792                	slli	a5,a5,0x4
 aee:	fe043703          	ld	a4,-32(s0)
 af2:	973e                	add	a4,a4,a5
 af4:	fe843783          	ld	a5,-24(s0)
 af8:	639c                	ld	a5,0(a5)
 afa:	02f71763          	bne	a4,a5,b28 <free+0xb8>
    bp->s.size += p->s.ptr->s.size;
 afe:	fe043783          	ld	a5,-32(s0)
 b02:	4798                	lw	a4,8(a5)
 b04:	fe843783          	ld	a5,-24(s0)
 b08:	639c                	ld	a5,0(a5)
 b0a:	479c                	lw	a5,8(a5)
 b0c:	9fb9                	addw	a5,a5,a4
 b0e:	0007871b          	sext.w	a4,a5
 b12:	fe043783          	ld	a5,-32(s0)
 b16:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 b18:	fe843783          	ld	a5,-24(s0)
 b1c:	639c                	ld	a5,0(a5)
 b1e:	6398                	ld	a4,0(a5)
 b20:	fe043783          	ld	a5,-32(s0)
 b24:	e398                	sd	a4,0(a5)
 b26:	a039                	j	b34 <free+0xc4>
  } else
    bp->s.ptr = p->s.ptr;
 b28:	fe843783          	ld	a5,-24(s0)
 b2c:	6398                	ld	a4,0(a5)
 b2e:	fe043783          	ld	a5,-32(s0)
 b32:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 b34:	fe843783          	ld	a5,-24(s0)
 b38:	479c                	lw	a5,8(a5)
 b3a:	1782                	slli	a5,a5,0x20
 b3c:	9381                	srli	a5,a5,0x20
 b3e:	0792                	slli	a5,a5,0x4
 b40:	fe843703          	ld	a4,-24(s0)
 b44:	97ba                	add	a5,a5,a4
 b46:	fe043703          	ld	a4,-32(s0)
 b4a:	02f71563          	bne	a4,a5,b74 <free+0x104>
    p->s.size += bp->s.size;
 b4e:	fe843783          	ld	a5,-24(s0)
 b52:	4798                	lw	a4,8(a5)
 b54:	fe043783          	ld	a5,-32(s0)
 b58:	479c                	lw	a5,8(a5)
 b5a:	9fb9                	addw	a5,a5,a4
 b5c:	0007871b          	sext.w	a4,a5
 b60:	fe843783          	ld	a5,-24(s0)
 b64:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b66:	fe043783          	ld	a5,-32(s0)
 b6a:	6398                	ld	a4,0(a5)
 b6c:	fe843783          	ld	a5,-24(s0)
 b70:	e398                	sd	a4,0(a5)
 b72:	a031                	j	b7e <free+0x10e>
  } else
    p->s.ptr = bp;
 b74:	fe843783          	ld	a5,-24(s0)
 b78:	fe043703          	ld	a4,-32(s0)
 b7c:	e398                	sd	a4,0(a5)
  freep = p;
 b7e:	00000797          	auipc	a5,0x0
 b82:	4b278793          	addi	a5,a5,1202 # 1030 <freep>
 b86:	fe843703          	ld	a4,-24(s0)
 b8a:	e398                	sd	a4,0(a5)
}
 b8c:	0001                	nop
 b8e:	70a2                	ld	ra,40(sp)
 b90:	7402                	ld	s0,32(sp)
 b92:	6145                	addi	sp,sp,48
 b94:	8082                	ret

0000000000000b96 <morecore>:

static Header*
morecore(uint nu)
{
 b96:	7179                	addi	sp,sp,-48
 b98:	f406                	sd	ra,40(sp)
 b9a:	f022                	sd	s0,32(sp)
 b9c:	1800                	addi	s0,sp,48
 b9e:	87aa                	mv	a5,a0
 ba0:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 ba4:	fdc42783          	lw	a5,-36(s0)
 ba8:	0007871b          	sext.w	a4,a5
 bac:	6785                	lui	a5,0x1
 bae:	00f77563          	bgeu	a4,a5,bb8 <morecore+0x22>
    nu = 4096;
 bb2:	6785                	lui	a5,0x1
 bb4:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 bb8:	fdc42783          	lw	a5,-36(s0)
 bbc:	0047979b          	slliw	a5,a5,0x4
 bc0:	2781                	sext.w	a5,a5
 bc2:	853e                	mv	a0,a5
 bc4:	00000097          	auipc	ra,0x0
 bc8:	9b8080e7          	jalr	-1608(ra) # 57c <sbrk>
 bcc:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 bd0:	fe843703          	ld	a4,-24(s0)
 bd4:	57fd                	li	a5,-1
 bd6:	00f71463          	bne	a4,a5,bde <morecore+0x48>
    return 0;
 bda:	4781                	li	a5,0
 bdc:	a03d                	j	c0a <morecore+0x74>
  hp = (Header*)p;
 bde:	fe843783          	ld	a5,-24(s0)
 be2:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 be6:	fe043783          	ld	a5,-32(s0)
 bea:	fdc42703          	lw	a4,-36(s0)
 bee:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 bf0:	fe043783          	ld	a5,-32(s0)
 bf4:	07c1                	addi	a5,a5,16 # 1010 <digits+0x10>
 bf6:	853e                	mv	a0,a5
 bf8:	00000097          	auipc	ra,0x0
 bfc:	e78080e7          	jalr	-392(ra) # a70 <free>
  return freep;
 c00:	00000797          	auipc	a5,0x0
 c04:	43078793          	addi	a5,a5,1072 # 1030 <freep>
 c08:	639c                	ld	a5,0(a5)
}
 c0a:	853e                	mv	a0,a5
 c0c:	70a2                	ld	ra,40(sp)
 c0e:	7402                	ld	s0,32(sp)
 c10:	6145                	addi	sp,sp,48
 c12:	8082                	ret

0000000000000c14 <malloc>:

void*
malloc(uint nbytes)
{
 c14:	7139                	addi	sp,sp,-64
 c16:	fc06                	sd	ra,56(sp)
 c18:	f822                	sd	s0,48(sp)
 c1a:	0080                	addi	s0,sp,64
 c1c:	87aa                	mv	a5,a0
 c1e:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c22:	fcc46783          	lwu	a5,-52(s0)
 c26:	07bd                	addi	a5,a5,15
 c28:	8391                	srli	a5,a5,0x4
 c2a:	2781                	sext.w	a5,a5
 c2c:	2785                	addiw	a5,a5,1
 c2e:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 c32:	00000797          	auipc	a5,0x0
 c36:	3fe78793          	addi	a5,a5,1022 # 1030 <freep>
 c3a:	639c                	ld	a5,0(a5)
 c3c:	fef43023          	sd	a5,-32(s0)
 c40:	fe043783          	ld	a5,-32(s0)
 c44:	ef95                	bnez	a5,c80 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 c46:	00000797          	auipc	a5,0x0
 c4a:	3da78793          	addi	a5,a5,986 # 1020 <base>
 c4e:	fef43023          	sd	a5,-32(s0)
 c52:	00000797          	auipc	a5,0x0
 c56:	3de78793          	addi	a5,a5,990 # 1030 <freep>
 c5a:	fe043703          	ld	a4,-32(s0)
 c5e:	e398                	sd	a4,0(a5)
 c60:	00000797          	auipc	a5,0x0
 c64:	3d078793          	addi	a5,a5,976 # 1030 <freep>
 c68:	6398                	ld	a4,0(a5)
 c6a:	00000797          	auipc	a5,0x0
 c6e:	3b678793          	addi	a5,a5,950 # 1020 <base>
 c72:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 c74:	00000797          	auipc	a5,0x0
 c78:	3ac78793          	addi	a5,a5,940 # 1020 <base>
 c7c:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c80:	fe043783          	ld	a5,-32(s0)
 c84:	639c                	ld	a5,0(a5)
 c86:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 c8a:	fe843783          	ld	a5,-24(s0)
 c8e:	479c                	lw	a5,8(a5)
 c90:	fdc42703          	lw	a4,-36(s0)
 c94:	2701                	sext.w	a4,a4
 c96:	06e7e763          	bltu	a5,a4,d04 <malloc+0xf0>
      if(p->s.size == nunits)
 c9a:	fe843783          	ld	a5,-24(s0)
 c9e:	479c                	lw	a5,8(a5)
 ca0:	fdc42703          	lw	a4,-36(s0)
 ca4:	2701                	sext.w	a4,a4
 ca6:	00f71963          	bne	a4,a5,cb8 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 caa:	fe843783          	ld	a5,-24(s0)
 cae:	6398                	ld	a4,0(a5)
 cb0:	fe043783          	ld	a5,-32(s0)
 cb4:	e398                	sd	a4,0(a5)
 cb6:	a825                	j	cee <malloc+0xda>
      else {
        p->s.size -= nunits;
 cb8:	fe843783          	ld	a5,-24(s0)
 cbc:	479c                	lw	a5,8(a5)
 cbe:	fdc42703          	lw	a4,-36(s0)
 cc2:	9f99                	subw	a5,a5,a4
 cc4:	0007871b          	sext.w	a4,a5
 cc8:	fe843783          	ld	a5,-24(s0)
 ccc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 cce:	fe843783          	ld	a5,-24(s0)
 cd2:	479c                	lw	a5,8(a5)
 cd4:	1782                	slli	a5,a5,0x20
 cd6:	9381                	srli	a5,a5,0x20
 cd8:	0792                	slli	a5,a5,0x4
 cda:	fe843703          	ld	a4,-24(s0)
 cde:	97ba                	add	a5,a5,a4
 ce0:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 ce4:	fe843783          	ld	a5,-24(s0)
 ce8:	fdc42703          	lw	a4,-36(s0)
 cec:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 cee:	00000797          	auipc	a5,0x0
 cf2:	34278793          	addi	a5,a5,834 # 1030 <freep>
 cf6:	fe043703          	ld	a4,-32(s0)
 cfa:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 cfc:	fe843783          	ld	a5,-24(s0)
 d00:	07c1                	addi	a5,a5,16
 d02:	a091                	j	d46 <malloc+0x132>
    }
    if(p == freep)
 d04:	00000797          	auipc	a5,0x0
 d08:	32c78793          	addi	a5,a5,812 # 1030 <freep>
 d0c:	639c                	ld	a5,0(a5)
 d0e:	fe843703          	ld	a4,-24(s0)
 d12:	02f71063          	bne	a4,a5,d32 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 d16:	fdc42783          	lw	a5,-36(s0)
 d1a:	853e                	mv	a0,a5
 d1c:	00000097          	auipc	ra,0x0
 d20:	e7a080e7          	jalr	-390(ra) # b96 <morecore>
 d24:	fea43423          	sd	a0,-24(s0)
 d28:	fe843783          	ld	a5,-24(s0)
 d2c:	e399                	bnez	a5,d32 <malloc+0x11e>
        return 0;
 d2e:	4781                	li	a5,0
 d30:	a819                	j	d46 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d32:	fe843783          	ld	a5,-24(s0)
 d36:	fef43023          	sd	a5,-32(s0)
 d3a:	fe843783          	ld	a5,-24(s0)
 d3e:	639c                	ld	a5,0(a5)
 d40:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 d44:	b799                	j	c8a <malloc+0x76>
  }
}
 d46:	853e                	mv	a0,a5
 d48:	70e2                	ld	ra,56(sp)
 d4a:	7442                	ld	s0,48(sp)
 d4c:	6121                	addi	sp,sp,64
 d4e:	8082                	ret
