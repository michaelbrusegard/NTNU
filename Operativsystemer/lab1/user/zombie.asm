
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

0000000000000594 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 594:	1101                	addi	sp,sp,-32
 596:	ec06                	sd	ra,24(sp)
 598:	e822                	sd	s0,16(sp)
 59a:	1000                	addi	s0,sp,32
 59c:	87aa                	mv	a5,a0
 59e:	872e                	mv	a4,a1
 5a0:	fef42623          	sw	a5,-20(s0)
 5a4:	87ba                	mv	a5,a4
 5a6:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 5aa:	feb40713          	addi	a4,s0,-21
 5ae:	fec42783          	lw	a5,-20(s0)
 5b2:	4605                	li	a2,1
 5b4:	85ba                	mv	a1,a4
 5b6:	853e                	mv	a0,a5
 5b8:	00000097          	auipc	ra,0x0
 5bc:	f5c080e7          	jalr	-164(ra) # 514 <write>
}
 5c0:	0001                	nop
 5c2:	60e2                	ld	ra,24(sp)
 5c4:	6442                	ld	s0,16(sp)
 5c6:	6105                	addi	sp,sp,32
 5c8:	8082                	ret

00000000000005ca <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5ca:	7139                	addi	sp,sp,-64
 5cc:	fc06                	sd	ra,56(sp)
 5ce:	f822                	sd	s0,48(sp)
 5d0:	0080                	addi	s0,sp,64
 5d2:	87aa                	mv	a5,a0
 5d4:	8736                	mv	a4,a3
 5d6:	fcf42623          	sw	a5,-52(s0)
 5da:	87ae                	mv	a5,a1
 5dc:	fcf42423          	sw	a5,-56(s0)
 5e0:	87b2                	mv	a5,a2
 5e2:	fcf42223          	sw	a5,-60(s0)
 5e6:	87ba                	mv	a5,a4
 5e8:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5ec:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 5f0:	fc042783          	lw	a5,-64(s0)
 5f4:	2781                	sext.w	a5,a5
 5f6:	c38d                	beqz	a5,618 <printint+0x4e>
 5f8:	fc842783          	lw	a5,-56(s0)
 5fc:	2781                	sext.w	a5,a5
 5fe:	0007dd63          	bgez	a5,618 <printint+0x4e>
    neg = 1;
 602:	4785                	li	a5,1
 604:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 608:	fc842783          	lw	a5,-56(s0)
 60c:	40f007bb          	negw	a5,a5
 610:	2781                	sext.w	a5,a5
 612:	fef42223          	sw	a5,-28(s0)
 616:	a029                	j	620 <printint+0x56>
  } else {
    x = xx;
 618:	fc842783          	lw	a5,-56(s0)
 61c:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 620:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 624:	fc442783          	lw	a5,-60(s0)
 628:	fe442703          	lw	a4,-28(s0)
 62c:	02f777bb          	remuw	a5,a4,a5
 630:	0007871b          	sext.w	a4,a5
 634:	fec42783          	lw	a5,-20(s0)
 638:	0017869b          	addiw	a3,a5,1
 63c:	fed42623          	sw	a3,-20(s0)
 640:	00001697          	auipc	a3,0x1
 644:	9c068693          	addi	a3,a3,-1600 # 1000 <digits>
 648:	1702                	slli	a4,a4,0x20
 64a:	9301                	srli	a4,a4,0x20
 64c:	9736                	add	a4,a4,a3
 64e:	00074703          	lbu	a4,0(a4)
 652:	17c1                	addi	a5,a5,-16
 654:	97a2                	add	a5,a5,s0
 656:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 65a:	fc442783          	lw	a5,-60(s0)
 65e:	fe442703          	lw	a4,-28(s0)
 662:	02f757bb          	divuw	a5,a4,a5
 666:	fef42223          	sw	a5,-28(s0)
 66a:	fe442783          	lw	a5,-28(s0)
 66e:	2781                	sext.w	a5,a5
 670:	fbd5                	bnez	a5,624 <printint+0x5a>
  if(neg)
 672:	fe842783          	lw	a5,-24(s0)
 676:	2781                	sext.w	a5,a5
 678:	cf85                	beqz	a5,6b0 <printint+0xe6>
    buf[i++] = '-';
 67a:	fec42783          	lw	a5,-20(s0)
 67e:	0017871b          	addiw	a4,a5,1
 682:	fee42623          	sw	a4,-20(s0)
 686:	17c1                	addi	a5,a5,-16
 688:	97a2                	add	a5,a5,s0
 68a:	02d00713          	li	a4,45
 68e:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 692:	a839                	j	6b0 <printint+0xe6>
    putc(fd, buf[i]);
 694:	fec42783          	lw	a5,-20(s0)
 698:	17c1                	addi	a5,a5,-16
 69a:	97a2                	add	a5,a5,s0
 69c:	fe07c703          	lbu	a4,-32(a5)
 6a0:	fcc42783          	lw	a5,-52(s0)
 6a4:	85ba                	mv	a1,a4
 6a6:	853e                	mv	a0,a5
 6a8:	00000097          	auipc	ra,0x0
 6ac:	eec080e7          	jalr	-276(ra) # 594 <putc>
  while(--i >= 0)
 6b0:	fec42783          	lw	a5,-20(s0)
 6b4:	37fd                	addiw	a5,a5,-1
 6b6:	fef42623          	sw	a5,-20(s0)
 6ba:	fec42783          	lw	a5,-20(s0)
 6be:	2781                	sext.w	a5,a5
 6c0:	fc07dae3          	bgez	a5,694 <printint+0xca>
}
 6c4:	0001                	nop
 6c6:	0001                	nop
 6c8:	70e2                	ld	ra,56(sp)
 6ca:	7442                	ld	s0,48(sp)
 6cc:	6121                	addi	sp,sp,64
 6ce:	8082                	ret

00000000000006d0 <printptr>:

static void
printptr(int fd, uint64 x) {
 6d0:	7179                	addi	sp,sp,-48
 6d2:	f406                	sd	ra,40(sp)
 6d4:	f022                	sd	s0,32(sp)
 6d6:	1800                	addi	s0,sp,48
 6d8:	87aa                	mv	a5,a0
 6da:	fcb43823          	sd	a1,-48(s0)
 6de:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 6e2:	fdc42783          	lw	a5,-36(s0)
 6e6:	03000593          	li	a1,48
 6ea:	853e                	mv	a0,a5
 6ec:	00000097          	auipc	ra,0x0
 6f0:	ea8080e7          	jalr	-344(ra) # 594 <putc>
  putc(fd, 'x');
 6f4:	fdc42783          	lw	a5,-36(s0)
 6f8:	07800593          	li	a1,120
 6fc:	853e                	mv	a0,a5
 6fe:	00000097          	auipc	ra,0x0
 702:	e96080e7          	jalr	-362(ra) # 594 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 706:	fe042623          	sw	zero,-20(s0)
 70a:	a82d                	j	744 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 70c:	fd043783          	ld	a5,-48(s0)
 710:	93f1                	srli	a5,a5,0x3c
 712:	00001717          	auipc	a4,0x1
 716:	8ee70713          	addi	a4,a4,-1810 # 1000 <digits>
 71a:	97ba                	add	a5,a5,a4
 71c:	0007c703          	lbu	a4,0(a5)
 720:	fdc42783          	lw	a5,-36(s0)
 724:	85ba                	mv	a1,a4
 726:	853e                	mv	a0,a5
 728:	00000097          	auipc	ra,0x0
 72c:	e6c080e7          	jalr	-404(ra) # 594 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 730:	fec42783          	lw	a5,-20(s0)
 734:	2785                	addiw	a5,a5,1
 736:	fef42623          	sw	a5,-20(s0)
 73a:	fd043783          	ld	a5,-48(s0)
 73e:	0792                	slli	a5,a5,0x4
 740:	fcf43823          	sd	a5,-48(s0)
 744:	fec42703          	lw	a4,-20(s0)
 748:	47bd                	li	a5,15
 74a:	fce7f1e3          	bgeu	a5,a4,70c <printptr+0x3c>
}
 74e:	0001                	nop
 750:	0001                	nop
 752:	70a2                	ld	ra,40(sp)
 754:	7402                	ld	s0,32(sp)
 756:	6145                	addi	sp,sp,48
 758:	8082                	ret

000000000000075a <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 75a:	715d                	addi	sp,sp,-80
 75c:	e486                	sd	ra,72(sp)
 75e:	e0a2                	sd	s0,64(sp)
 760:	0880                	addi	s0,sp,80
 762:	87aa                	mv	a5,a0
 764:	fcb43023          	sd	a1,-64(s0)
 768:	fac43c23          	sd	a2,-72(s0)
 76c:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 770:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 774:	fe042223          	sw	zero,-28(s0)
 778:	a42d                	j	9a2 <vprintf+0x248>
    c = fmt[i] & 0xff;
 77a:	fe442783          	lw	a5,-28(s0)
 77e:	fc043703          	ld	a4,-64(s0)
 782:	97ba                	add	a5,a5,a4
 784:	0007c783          	lbu	a5,0(a5)
 788:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 78c:	fe042783          	lw	a5,-32(s0)
 790:	2781                	sext.w	a5,a5
 792:	eb9d                	bnez	a5,7c8 <vprintf+0x6e>
      if(c == '%'){
 794:	fdc42783          	lw	a5,-36(s0)
 798:	0007871b          	sext.w	a4,a5
 79c:	02500793          	li	a5,37
 7a0:	00f71763          	bne	a4,a5,7ae <vprintf+0x54>
        state = '%';
 7a4:	02500793          	li	a5,37
 7a8:	fef42023          	sw	a5,-32(s0)
 7ac:	a2f5                	j	998 <vprintf+0x23e>
      } else {
        putc(fd, c);
 7ae:	fdc42783          	lw	a5,-36(s0)
 7b2:	0ff7f713          	zext.b	a4,a5
 7b6:	fcc42783          	lw	a5,-52(s0)
 7ba:	85ba                	mv	a1,a4
 7bc:	853e                	mv	a0,a5
 7be:	00000097          	auipc	ra,0x0
 7c2:	dd6080e7          	jalr	-554(ra) # 594 <putc>
 7c6:	aac9                	j	998 <vprintf+0x23e>
      }
    } else if(state == '%'){
 7c8:	fe042783          	lw	a5,-32(s0)
 7cc:	0007871b          	sext.w	a4,a5
 7d0:	02500793          	li	a5,37
 7d4:	1cf71263          	bne	a4,a5,998 <vprintf+0x23e>
      if(c == 'd'){
 7d8:	fdc42783          	lw	a5,-36(s0)
 7dc:	0007871b          	sext.w	a4,a5
 7e0:	06400793          	li	a5,100
 7e4:	02f71463          	bne	a4,a5,80c <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 7e8:	fb843783          	ld	a5,-72(s0)
 7ec:	00878713          	addi	a4,a5,8
 7f0:	fae43c23          	sd	a4,-72(s0)
 7f4:	4398                	lw	a4,0(a5)
 7f6:	fcc42783          	lw	a5,-52(s0)
 7fa:	4685                	li	a3,1
 7fc:	4629                	li	a2,10
 7fe:	85ba                	mv	a1,a4
 800:	853e                	mv	a0,a5
 802:	00000097          	auipc	ra,0x0
 806:	dc8080e7          	jalr	-568(ra) # 5ca <printint>
 80a:	a269                	j	994 <vprintf+0x23a>
      } else if(c == 'l') {
 80c:	fdc42783          	lw	a5,-36(s0)
 810:	0007871b          	sext.w	a4,a5
 814:	06c00793          	li	a5,108
 818:	02f71663          	bne	a4,a5,844 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 81c:	fb843783          	ld	a5,-72(s0)
 820:	00878713          	addi	a4,a5,8
 824:	fae43c23          	sd	a4,-72(s0)
 828:	639c                	ld	a5,0(a5)
 82a:	0007871b          	sext.w	a4,a5
 82e:	fcc42783          	lw	a5,-52(s0)
 832:	4681                	li	a3,0
 834:	4629                	li	a2,10
 836:	85ba                	mv	a1,a4
 838:	853e                	mv	a0,a5
 83a:	00000097          	auipc	ra,0x0
 83e:	d90080e7          	jalr	-624(ra) # 5ca <printint>
 842:	aa89                	j	994 <vprintf+0x23a>
      } else if(c == 'x') {
 844:	fdc42783          	lw	a5,-36(s0)
 848:	0007871b          	sext.w	a4,a5
 84c:	07800793          	li	a5,120
 850:	02f71463          	bne	a4,a5,878 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 854:	fb843783          	ld	a5,-72(s0)
 858:	00878713          	addi	a4,a5,8
 85c:	fae43c23          	sd	a4,-72(s0)
 860:	4398                	lw	a4,0(a5)
 862:	fcc42783          	lw	a5,-52(s0)
 866:	4681                	li	a3,0
 868:	4641                	li	a2,16
 86a:	85ba                	mv	a1,a4
 86c:	853e                	mv	a0,a5
 86e:	00000097          	auipc	ra,0x0
 872:	d5c080e7          	jalr	-676(ra) # 5ca <printint>
 876:	aa39                	j	994 <vprintf+0x23a>
      } else if(c == 'p') {
 878:	fdc42783          	lw	a5,-36(s0)
 87c:	0007871b          	sext.w	a4,a5
 880:	07000793          	li	a5,112
 884:	02f71263          	bne	a4,a5,8a8 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 888:	fb843783          	ld	a5,-72(s0)
 88c:	00878713          	addi	a4,a5,8
 890:	fae43c23          	sd	a4,-72(s0)
 894:	6398                	ld	a4,0(a5)
 896:	fcc42783          	lw	a5,-52(s0)
 89a:	85ba                	mv	a1,a4
 89c:	853e                	mv	a0,a5
 89e:	00000097          	auipc	ra,0x0
 8a2:	e32080e7          	jalr	-462(ra) # 6d0 <printptr>
 8a6:	a0fd                	j	994 <vprintf+0x23a>
      } else if(c == 's'){
 8a8:	fdc42783          	lw	a5,-36(s0)
 8ac:	0007871b          	sext.w	a4,a5
 8b0:	07300793          	li	a5,115
 8b4:	04f71c63          	bne	a4,a5,90c <vprintf+0x1b2>
        s = va_arg(ap, char*);
 8b8:	fb843783          	ld	a5,-72(s0)
 8bc:	00878713          	addi	a4,a5,8
 8c0:	fae43c23          	sd	a4,-72(s0)
 8c4:	639c                	ld	a5,0(a5)
 8c6:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 8ca:	fe843783          	ld	a5,-24(s0)
 8ce:	eb8d                	bnez	a5,900 <vprintf+0x1a6>
          s = "(null)";
 8d0:	00000797          	auipc	a5,0x0
 8d4:	48078793          	addi	a5,a5,1152 # d50 <malloc+0x144>
 8d8:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 8dc:	a015                	j	900 <vprintf+0x1a6>
          putc(fd, *s);
 8de:	fe843783          	ld	a5,-24(s0)
 8e2:	0007c703          	lbu	a4,0(a5)
 8e6:	fcc42783          	lw	a5,-52(s0)
 8ea:	85ba                	mv	a1,a4
 8ec:	853e                	mv	a0,a5
 8ee:	00000097          	auipc	ra,0x0
 8f2:	ca6080e7          	jalr	-858(ra) # 594 <putc>
          s++;
 8f6:	fe843783          	ld	a5,-24(s0)
 8fa:	0785                	addi	a5,a5,1
 8fc:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 900:	fe843783          	ld	a5,-24(s0)
 904:	0007c783          	lbu	a5,0(a5)
 908:	fbf9                	bnez	a5,8de <vprintf+0x184>
 90a:	a069                	j	994 <vprintf+0x23a>
        }
      } else if(c == 'c'){
 90c:	fdc42783          	lw	a5,-36(s0)
 910:	0007871b          	sext.w	a4,a5
 914:	06300793          	li	a5,99
 918:	02f71463          	bne	a4,a5,940 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 91c:	fb843783          	ld	a5,-72(s0)
 920:	00878713          	addi	a4,a5,8
 924:	fae43c23          	sd	a4,-72(s0)
 928:	439c                	lw	a5,0(a5)
 92a:	0ff7f713          	zext.b	a4,a5
 92e:	fcc42783          	lw	a5,-52(s0)
 932:	85ba                	mv	a1,a4
 934:	853e                	mv	a0,a5
 936:	00000097          	auipc	ra,0x0
 93a:	c5e080e7          	jalr	-930(ra) # 594 <putc>
 93e:	a899                	j	994 <vprintf+0x23a>
      } else if(c == '%'){
 940:	fdc42783          	lw	a5,-36(s0)
 944:	0007871b          	sext.w	a4,a5
 948:	02500793          	li	a5,37
 94c:	00f71f63          	bne	a4,a5,96a <vprintf+0x210>
        putc(fd, c);
 950:	fdc42783          	lw	a5,-36(s0)
 954:	0ff7f713          	zext.b	a4,a5
 958:	fcc42783          	lw	a5,-52(s0)
 95c:	85ba                	mv	a1,a4
 95e:	853e                	mv	a0,a5
 960:	00000097          	auipc	ra,0x0
 964:	c34080e7          	jalr	-972(ra) # 594 <putc>
 968:	a035                	j	994 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 96a:	fcc42783          	lw	a5,-52(s0)
 96e:	02500593          	li	a1,37
 972:	853e                	mv	a0,a5
 974:	00000097          	auipc	ra,0x0
 978:	c20080e7          	jalr	-992(ra) # 594 <putc>
        putc(fd, c);
 97c:	fdc42783          	lw	a5,-36(s0)
 980:	0ff7f713          	zext.b	a4,a5
 984:	fcc42783          	lw	a5,-52(s0)
 988:	85ba                	mv	a1,a4
 98a:	853e                	mv	a0,a5
 98c:	00000097          	auipc	ra,0x0
 990:	c08080e7          	jalr	-1016(ra) # 594 <putc>
      }
      state = 0;
 994:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 998:	fe442783          	lw	a5,-28(s0)
 99c:	2785                	addiw	a5,a5,1
 99e:	fef42223          	sw	a5,-28(s0)
 9a2:	fe442783          	lw	a5,-28(s0)
 9a6:	fc043703          	ld	a4,-64(s0)
 9aa:	97ba                	add	a5,a5,a4
 9ac:	0007c783          	lbu	a5,0(a5)
 9b0:	dc0795e3          	bnez	a5,77a <vprintf+0x20>
    }
  }
}
 9b4:	0001                	nop
 9b6:	0001                	nop
 9b8:	60a6                	ld	ra,72(sp)
 9ba:	6406                	ld	s0,64(sp)
 9bc:	6161                	addi	sp,sp,80
 9be:	8082                	ret

00000000000009c0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9c0:	7159                	addi	sp,sp,-112
 9c2:	fc06                	sd	ra,56(sp)
 9c4:	f822                	sd	s0,48(sp)
 9c6:	0080                	addi	s0,sp,64
 9c8:	fcb43823          	sd	a1,-48(s0)
 9cc:	e010                	sd	a2,0(s0)
 9ce:	e414                	sd	a3,8(s0)
 9d0:	e818                	sd	a4,16(s0)
 9d2:	ec1c                	sd	a5,24(s0)
 9d4:	03043023          	sd	a6,32(s0)
 9d8:	03143423          	sd	a7,40(s0)
 9dc:	87aa                	mv	a5,a0
 9de:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 9e2:	03040793          	addi	a5,s0,48
 9e6:	fcf43423          	sd	a5,-56(s0)
 9ea:	fc843783          	ld	a5,-56(s0)
 9ee:	fd078793          	addi	a5,a5,-48
 9f2:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 9f6:	fe843703          	ld	a4,-24(s0)
 9fa:	fdc42783          	lw	a5,-36(s0)
 9fe:	863a                	mv	a2,a4
 a00:	fd043583          	ld	a1,-48(s0)
 a04:	853e                	mv	a0,a5
 a06:	00000097          	auipc	ra,0x0
 a0a:	d54080e7          	jalr	-684(ra) # 75a <vprintf>
}
 a0e:	0001                	nop
 a10:	70e2                	ld	ra,56(sp)
 a12:	7442                	ld	s0,48(sp)
 a14:	6165                	addi	sp,sp,112
 a16:	8082                	ret

0000000000000a18 <printf>:

void
printf(const char *fmt, ...)
{
 a18:	7159                	addi	sp,sp,-112
 a1a:	f406                	sd	ra,40(sp)
 a1c:	f022                	sd	s0,32(sp)
 a1e:	1800                	addi	s0,sp,48
 a20:	fca43c23          	sd	a0,-40(s0)
 a24:	e40c                	sd	a1,8(s0)
 a26:	e810                	sd	a2,16(s0)
 a28:	ec14                	sd	a3,24(s0)
 a2a:	f018                	sd	a4,32(s0)
 a2c:	f41c                	sd	a5,40(s0)
 a2e:	03043823          	sd	a6,48(s0)
 a32:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a36:	04040793          	addi	a5,s0,64
 a3a:	fcf43823          	sd	a5,-48(s0)
 a3e:	fd043783          	ld	a5,-48(s0)
 a42:	fc878793          	addi	a5,a5,-56
 a46:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 a4a:	fe843783          	ld	a5,-24(s0)
 a4e:	863e                	mv	a2,a5
 a50:	fd843583          	ld	a1,-40(s0)
 a54:	4505                	li	a0,1
 a56:	00000097          	auipc	ra,0x0
 a5a:	d04080e7          	jalr	-764(ra) # 75a <vprintf>
}
 a5e:	0001                	nop
 a60:	70a2                	ld	ra,40(sp)
 a62:	7402                	ld	s0,32(sp)
 a64:	6165                	addi	sp,sp,112
 a66:	8082                	ret

0000000000000a68 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a68:	7179                	addi	sp,sp,-48
 a6a:	f406                	sd	ra,40(sp)
 a6c:	f022                	sd	s0,32(sp)
 a6e:	1800                	addi	s0,sp,48
 a70:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a74:	fd843783          	ld	a5,-40(s0)
 a78:	17c1                	addi	a5,a5,-16
 a7a:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a7e:	00000797          	auipc	a5,0x0
 a82:	5b278793          	addi	a5,a5,1458 # 1030 <freep>
 a86:	639c                	ld	a5,0(a5)
 a88:	fef43423          	sd	a5,-24(s0)
 a8c:	a815                	j	ac0 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a8e:	fe843783          	ld	a5,-24(s0)
 a92:	639c                	ld	a5,0(a5)
 a94:	fe843703          	ld	a4,-24(s0)
 a98:	00f76f63          	bltu	a4,a5,ab6 <free+0x4e>
 a9c:	fe043703          	ld	a4,-32(s0)
 aa0:	fe843783          	ld	a5,-24(s0)
 aa4:	02e7eb63          	bltu	a5,a4,ada <free+0x72>
 aa8:	fe843783          	ld	a5,-24(s0)
 aac:	639c                	ld	a5,0(a5)
 aae:	fe043703          	ld	a4,-32(s0)
 ab2:	02f76463          	bltu	a4,a5,ada <free+0x72>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ab6:	fe843783          	ld	a5,-24(s0)
 aba:	639c                	ld	a5,0(a5)
 abc:	fef43423          	sd	a5,-24(s0)
 ac0:	fe043703          	ld	a4,-32(s0)
 ac4:	fe843783          	ld	a5,-24(s0)
 ac8:	fce7f3e3          	bgeu	a5,a4,a8e <free+0x26>
 acc:	fe843783          	ld	a5,-24(s0)
 ad0:	639c                	ld	a5,0(a5)
 ad2:	fe043703          	ld	a4,-32(s0)
 ad6:	faf77ce3          	bgeu	a4,a5,a8e <free+0x26>
      break;
  if(bp + bp->s.size == p->s.ptr){
 ada:	fe043783          	ld	a5,-32(s0)
 ade:	479c                	lw	a5,8(a5)
 ae0:	1782                	slli	a5,a5,0x20
 ae2:	9381                	srli	a5,a5,0x20
 ae4:	0792                	slli	a5,a5,0x4
 ae6:	fe043703          	ld	a4,-32(s0)
 aea:	973e                	add	a4,a4,a5
 aec:	fe843783          	ld	a5,-24(s0)
 af0:	639c                	ld	a5,0(a5)
 af2:	02f71763          	bne	a4,a5,b20 <free+0xb8>
    bp->s.size += p->s.ptr->s.size;
 af6:	fe043783          	ld	a5,-32(s0)
 afa:	4798                	lw	a4,8(a5)
 afc:	fe843783          	ld	a5,-24(s0)
 b00:	639c                	ld	a5,0(a5)
 b02:	479c                	lw	a5,8(a5)
 b04:	9fb9                	addw	a5,a5,a4
 b06:	0007871b          	sext.w	a4,a5
 b0a:	fe043783          	ld	a5,-32(s0)
 b0e:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 b10:	fe843783          	ld	a5,-24(s0)
 b14:	639c                	ld	a5,0(a5)
 b16:	6398                	ld	a4,0(a5)
 b18:	fe043783          	ld	a5,-32(s0)
 b1c:	e398                	sd	a4,0(a5)
 b1e:	a039                	j	b2c <free+0xc4>
  } else
    bp->s.ptr = p->s.ptr;
 b20:	fe843783          	ld	a5,-24(s0)
 b24:	6398                	ld	a4,0(a5)
 b26:	fe043783          	ld	a5,-32(s0)
 b2a:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 b2c:	fe843783          	ld	a5,-24(s0)
 b30:	479c                	lw	a5,8(a5)
 b32:	1782                	slli	a5,a5,0x20
 b34:	9381                	srli	a5,a5,0x20
 b36:	0792                	slli	a5,a5,0x4
 b38:	fe843703          	ld	a4,-24(s0)
 b3c:	97ba                	add	a5,a5,a4
 b3e:	fe043703          	ld	a4,-32(s0)
 b42:	02f71563          	bne	a4,a5,b6c <free+0x104>
    p->s.size += bp->s.size;
 b46:	fe843783          	ld	a5,-24(s0)
 b4a:	4798                	lw	a4,8(a5)
 b4c:	fe043783          	ld	a5,-32(s0)
 b50:	479c                	lw	a5,8(a5)
 b52:	9fb9                	addw	a5,a5,a4
 b54:	0007871b          	sext.w	a4,a5
 b58:	fe843783          	ld	a5,-24(s0)
 b5c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b5e:	fe043783          	ld	a5,-32(s0)
 b62:	6398                	ld	a4,0(a5)
 b64:	fe843783          	ld	a5,-24(s0)
 b68:	e398                	sd	a4,0(a5)
 b6a:	a031                	j	b76 <free+0x10e>
  } else
    p->s.ptr = bp;
 b6c:	fe843783          	ld	a5,-24(s0)
 b70:	fe043703          	ld	a4,-32(s0)
 b74:	e398                	sd	a4,0(a5)
  freep = p;
 b76:	00000797          	auipc	a5,0x0
 b7a:	4ba78793          	addi	a5,a5,1210 # 1030 <freep>
 b7e:	fe843703          	ld	a4,-24(s0)
 b82:	e398                	sd	a4,0(a5)
}
 b84:	0001                	nop
 b86:	70a2                	ld	ra,40(sp)
 b88:	7402                	ld	s0,32(sp)
 b8a:	6145                	addi	sp,sp,48
 b8c:	8082                	ret

0000000000000b8e <morecore>:

static Header*
morecore(uint nu)
{
 b8e:	7179                	addi	sp,sp,-48
 b90:	f406                	sd	ra,40(sp)
 b92:	f022                	sd	s0,32(sp)
 b94:	1800                	addi	s0,sp,48
 b96:	87aa                	mv	a5,a0
 b98:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 b9c:	fdc42783          	lw	a5,-36(s0)
 ba0:	0007871b          	sext.w	a4,a5
 ba4:	6785                	lui	a5,0x1
 ba6:	00f77563          	bgeu	a4,a5,bb0 <morecore+0x22>
    nu = 4096;
 baa:	6785                	lui	a5,0x1
 bac:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 bb0:	fdc42783          	lw	a5,-36(s0)
 bb4:	0047979b          	slliw	a5,a5,0x4
 bb8:	2781                	sext.w	a5,a5
 bba:	853e                	mv	a0,a5
 bbc:	00000097          	auipc	ra,0x0
 bc0:	9c0080e7          	jalr	-1600(ra) # 57c <sbrk>
 bc4:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 bc8:	fe843703          	ld	a4,-24(s0)
 bcc:	57fd                	li	a5,-1
 bce:	00f71463          	bne	a4,a5,bd6 <morecore+0x48>
    return 0;
 bd2:	4781                	li	a5,0
 bd4:	a03d                	j	c02 <morecore+0x74>
  hp = (Header*)p;
 bd6:	fe843783          	ld	a5,-24(s0)
 bda:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 bde:	fe043783          	ld	a5,-32(s0)
 be2:	fdc42703          	lw	a4,-36(s0)
 be6:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 be8:	fe043783          	ld	a5,-32(s0)
 bec:	07c1                	addi	a5,a5,16 # 1010 <digits+0x10>
 bee:	853e                	mv	a0,a5
 bf0:	00000097          	auipc	ra,0x0
 bf4:	e78080e7          	jalr	-392(ra) # a68 <free>
  return freep;
 bf8:	00000797          	auipc	a5,0x0
 bfc:	43878793          	addi	a5,a5,1080 # 1030 <freep>
 c00:	639c                	ld	a5,0(a5)
}
 c02:	853e                	mv	a0,a5
 c04:	70a2                	ld	ra,40(sp)
 c06:	7402                	ld	s0,32(sp)
 c08:	6145                	addi	sp,sp,48
 c0a:	8082                	ret

0000000000000c0c <malloc>:

void*
malloc(uint nbytes)
{
 c0c:	7139                	addi	sp,sp,-64
 c0e:	fc06                	sd	ra,56(sp)
 c10:	f822                	sd	s0,48(sp)
 c12:	0080                	addi	s0,sp,64
 c14:	87aa                	mv	a5,a0
 c16:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c1a:	fcc46783          	lwu	a5,-52(s0)
 c1e:	07bd                	addi	a5,a5,15
 c20:	8391                	srli	a5,a5,0x4
 c22:	2781                	sext.w	a5,a5
 c24:	2785                	addiw	a5,a5,1
 c26:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 c2a:	00000797          	auipc	a5,0x0
 c2e:	40678793          	addi	a5,a5,1030 # 1030 <freep>
 c32:	639c                	ld	a5,0(a5)
 c34:	fef43023          	sd	a5,-32(s0)
 c38:	fe043783          	ld	a5,-32(s0)
 c3c:	ef95                	bnez	a5,c78 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 c3e:	00000797          	auipc	a5,0x0
 c42:	3e278793          	addi	a5,a5,994 # 1020 <base>
 c46:	fef43023          	sd	a5,-32(s0)
 c4a:	00000797          	auipc	a5,0x0
 c4e:	3e678793          	addi	a5,a5,998 # 1030 <freep>
 c52:	fe043703          	ld	a4,-32(s0)
 c56:	e398                	sd	a4,0(a5)
 c58:	00000797          	auipc	a5,0x0
 c5c:	3d878793          	addi	a5,a5,984 # 1030 <freep>
 c60:	6398                	ld	a4,0(a5)
 c62:	00000797          	auipc	a5,0x0
 c66:	3be78793          	addi	a5,a5,958 # 1020 <base>
 c6a:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 c6c:	00000797          	auipc	a5,0x0
 c70:	3b478793          	addi	a5,a5,948 # 1020 <base>
 c74:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c78:	fe043783          	ld	a5,-32(s0)
 c7c:	639c                	ld	a5,0(a5)
 c7e:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 c82:	fe843783          	ld	a5,-24(s0)
 c86:	479c                	lw	a5,8(a5)
 c88:	fdc42703          	lw	a4,-36(s0)
 c8c:	2701                	sext.w	a4,a4
 c8e:	06e7e763          	bltu	a5,a4,cfc <malloc+0xf0>
      if(p->s.size == nunits)
 c92:	fe843783          	ld	a5,-24(s0)
 c96:	479c                	lw	a5,8(a5)
 c98:	fdc42703          	lw	a4,-36(s0)
 c9c:	2701                	sext.w	a4,a4
 c9e:	00f71963          	bne	a4,a5,cb0 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 ca2:	fe843783          	ld	a5,-24(s0)
 ca6:	6398                	ld	a4,0(a5)
 ca8:	fe043783          	ld	a5,-32(s0)
 cac:	e398                	sd	a4,0(a5)
 cae:	a825                	j	ce6 <malloc+0xda>
      else {
        p->s.size -= nunits;
 cb0:	fe843783          	ld	a5,-24(s0)
 cb4:	479c                	lw	a5,8(a5)
 cb6:	fdc42703          	lw	a4,-36(s0)
 cba:	9f99                	subw	a5,a5,a4
 cbc:	0007871b          	sext.w	a4,a5
 cc0:	fe843783          	ld	a5,-24(s0)
 cc4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 cc6:	fe843783          	ld	a5,-24(s0)
 cca:	479c                	lw	a5,8(a5)
 ccc:	1782                	slli	a5,a5,0x20
 cce:	9381                	srli	a5,a5,0x20
 cd0:	0792                	slli	a5,a5,0x4
 cd2:	fe843703          	ld	a4,-24(s0)
 cd6:	97ba                	add	a5,a5,a4
 cd8:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 cdc:	fe843783          	ld	a5,-24(s0)
 ce0:	fdc42703          	lw	a4,-36(s0)
 ce4:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 ce6:	00000797          	auipc	a5,0x0
 cea:	34a78793          	addi	a5,a5,842 # 1030 <freep>
 cee:	fe043703          	ld	a4,-32(s0)
 cf2:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 cf4:	fe843783          	ld	a5,-24(s0)
 cf8:	07c1                	addi	a5,a5,16
 cfa:	a091                	j	d3e <malloc+0x132>
    }
    if(p == freep)
 cfc:	00000797          	auipc	a5,0x0
 d00:	33478793          	addi	a5,a5,820 # 1030 <freep>
 d04:	639c                	ld	a5,0(a5)
 d06:	fe843703          	ld	a4,-24(s0)
 d0a:	02f71063          	bne	a4,a5,d2a <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 d0e:	fdc42783          	lw	a5,-36(s0)
 d12:	853e                	mv	a0,a5
 d14:	00000097          	auipc	ra,0x0
 d18:	e7a080e7          	jalr	-390(ra) # b8e <morecore>
 d1c:	fea43423          	sd	a0,-24(s0)
 d20:	fe843783          	ld	a5,-24(s0)
 d24:	e399                	bnez	a5,d2a <malloc+0x11e>
        return 0;
 d26:	4781                	li	a5,0
 d28:	a819                	j	d3e <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d2a:	fe843783          	ld	a5,-24(s0)
 d2e:	fef43023          	sd	a5,-32(s0)
 d32:	fe843783          	ld	a5,-24(s0)
 d36:	639c                	ld	a5,0(a5)
 d38:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 d3c:	b799                	j	c82 <malloc+0x76>
  }
}
 d3e:	853e                	mv	a0,a5
 d40:	70e2                	ld	ra,56(sp)
 d42:	7442                	ld	s0,48(sp)
 d44:	6121                	addi	sp,sp,64
 d46:	8082                	ret
