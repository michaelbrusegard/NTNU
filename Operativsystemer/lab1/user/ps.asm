
user/_ps:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  ps();
   8:	00000097          	auipc	ra,0x0
   c:	57c080e7          	jalr	1404(ra) # 584 <ps>
  exit(0);
  10:	4501                	li	a0,0
  12:	00000097          	auipc	ra,0x0
  16:	4d2080e7          	jalr	1234(ra) # 4e4 <exit>

000000000000001a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  1a:	1141                	addi	sp,sp,-16
  1c:	e406                	sd	ra,8(sp)
  1e:	e022                	sd	s0,0(sp)
  20:	0800                	addi	s0,sp,16
  extern int main();
  main();
  22:	00000097          	auipc	ra,0x0
  26:	fde080e7          	jalr	-34(ra) # 0 <main>
  exit(0);
  2a:	4501                	li	a0,0
  2c:	00000097          	auipc	ra,0x0
  30:	4b8080e7          	jalr	1208(ra) # 4e4 <exit>

0000000000000034 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  34:	7179                	addi	sp,sp,-48
  36:	f406                	sd	ra,40(sp)
  38:	f022                	sd	s0,32(sp)
  3a:	1800                	addi	s0,sp,48
  3c:	fca43c23          	sd	a0,-40(s0)
  40:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
  44:	fd843783          	ld	a5,-40(s0)
  48:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
  4c:	0001                	nop
  4e:	fd043703          	ld	a4,-48(s0)
  52:	00170793          	addi	a5,a4,1
  56:	fcf43823          	sd	a5,-48(s0)
  5a:	fd843783          	ld	a5,-40(s0)
  5e:	00178693          	addi	a3,a5,1
  62:	fcd43c23          	sd	a3,-40(s0)
  66:	00074703          	lbu	a4,0(a4)
  6a:	00e78023          	sb	a4,0(a5)
  6e:	0007c783          	lbu	a5,0(a5)
  72:	fff1                	bnez	a5,4e <strcpy+0x1a>
    ;
  return os;
  74:	fe843783          	ld	a5,-24(s0)
}
  78:	853e                	mv	a0,a5
  7a:	70a2                	ld	ra,40(sp)
  7c:	7402                	ld	s0,32(sp)
  7e:	6145                	addi	sp,sp,48
  80:	8082                	ret

0000000000000082 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  82:	1101                	addi	sp,sp,-32
  84:	ec06                	sd	ra,24(sp)
  86:	e822                	sd	s0,16(sp)
  88:	1000                	addi	s0,sp,32
  8a:	fea43423          	sd	a0,-24(s0)
  8e:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
  92:	a819                	j	a8 <strcmp+0x26>
    p++, q++;
  94:	fe843783          	ld	a5,-24(s0)
  98:	0785                	addi	a5,a5,1
  9a:	fef43423          	sd	a5,-24(s0)
  9e:	fe043783          	ld	a5,-32(s0)
  a2:	0785                	addi	a5,a5,1
  a4:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
  a8:	fe843783          	ld	a5,-24(s0)
  ac:	0007c783          	lbu	a5,0(a5)
  b0:	cb99                	beqz	a5,c6 <strcmp+0x44>
  b2:	fe843783          	ld	a5,-24(s0)
  b6:	0007c703          	lbu	a4,0(a5)
  ba:	fe043783          	ld	a5,-32(s0)
  be:	0007c783          	lbu	a5,0(a5)
  c2:	fcf709e3          	beq	a4,a5,94 <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
  c6:	fe843783          	ld	a5,-24(s0)
  ca:	0007c783          	lbu	a5,0(a5)
  ce:	0007871b          	sext.w	a4,a5
  d2:	fe043783          	ld	a5,-32(s0)
  d6:	0007c783          	lbu	a5,0(a5)
  da:	2781                	sext.w	a5,a5
  dc:	40f707bb          	subw	a5,a4,a5
  e0:	2781                	sext.w	a5,a5
}
  e2:	853e                	mv	a0,a5
  e4:	60e2                	ld	ra,24(sp)
  e6:	6442                	ld	s0,16(sp)
  e8:	6105                	addi	sp,sp,32
  ea:	8082                	ret

00000000000000ec <strlen>:

uint
strlen(const char *s)
{
  ec:	7179                	addi	sp,sp,-48
  ee:	f406                	sd	ra,40(sp)
  f0:	f022                	sd	s0,32(sp)
  f2:	1800                	addi	s0,sp,48
  f4:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
  f8:	fe042623          	sw	zero,-20(s0)
  fc:	a031                	j	108 <strlen+0x1c>
  fe:	fec42783          	lw	a5,-20(s0)
 102:	2785                	addiw	a5,a5,1
 104:	fef42623          	sw	a5,-20(s0)
 108:	fec42783          	lw	a5,-20(s0)
 10c:	fd843703          	ld	a4,-40(s0)
 110:	97ba                	add	a5,a5,a4
 112:	0007c783          	lbu	a5,0(a5)
 116:	f7e5                	bnez	a5,fe <strlen+0x12>
    ;
  return n;
 118:	fec42783          	lw	a5,-20(s0)
}
 11c:	853e                	mv	a0,a5
 11e:	70a2                	ld	ra,40(sp)
 120:	7402                	ld	s0,32(sp)
 122:	6145                	addi	sp,sp,48
 124:	8082                	ret

0000000000000126 <memset>:

void*
memset(void *dst, int c, uint n)
{
 126:	7179                	addi	sp,sp,-48
 128:	f406                	sd	ra,40(sp)
 12a:	f022                	sd	s0,32(sp)
 12c:	1800                	addi	s0,sp,48
 12e:	fca43c23          	sd	a0,-40(s0)
 132:	87ae                	mv	a5,a1
 134:	8732                	mv	a4,a2
 136:	fcf42a23          	sw	a5,-44(s0)
 13a:	87ba                	mv	a5,a4
 13c:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
 140:	fd843783          	ld	a5,-40(s0)
 144:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
 148:	fe042623          	sw	zero,-20(s0)
 14c:	a00d                	j	16e <memset+0x48>
    cdst[i] = c;
 14e:	fec42783          	lw	a5,-20(s0)
 152:	fe043703          	ld	a4,-32(s0)
 156:	97ba                	add	a5,a5,a4
 158:	fd442703          	lw	a4,-44(s0)
 15c:	0ff77713          	zext.b	a4,a4
 160:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
 164:	fec42783          	lw	a5,-20(s0)
 168:	2785                	addiw	a5,a5,1
 16a:	fef42623          	sw	a5,-20(s0)
 16e:	fec42783          	lw	a5,-20(s0)
 172:	fd042703          	lw	a4,-48(s0)
 176:	2701                	sext.w	a4,a4
 178:	fce7ebe3          	bltu	a5,a4,14e <memset+0x28>
  }
  return dst;
 17c:	fd843783          	ld	a5,-40(s0)
}
 180:	853e                	mv	a0,a5
 182:	70a2                	ld	ra,40(sp)
 184:	7402                	ld	s0,32(sp)
 186:	6145                	addi	sp,sp,48
 188:	8082                	ret

000000000000018a <strchr>:

char*
strchr(const char *s, char c)
{
 18a:	1101                	addi	sp,sp,-32
 18c:	ec06                	sd	ra,24(sp)
 18e:	e822                	sd	s0,16(sp)
 190:	1000                	addi	s0,sp,32
 192:	fea43423          	sd	a0,-24(s0)
 196:	87ae                	mv	a5,a1
 198:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
 19c:	a01d                	j	1c2 <strchr+0x38>
    if(*s == c)
 19e:	fe843783          	ld	a5,-24(s0)
 1a2:	0007c703          	lbu	a4,0(a5)
 1a6:	fe744783          	lbu	a5,-25(s0)
 1aa:	0ff7f793          	zext.b	a5,a5
 1ae:	00e79563          	bne	a5,a4,1b8 <strchr+0x2e>
      return (char*)s;
 1b2:	fe843783          	ld	a5,-24(s0)
 1b6:	a821                	j	1ce <strchr+0x44>
  for(; *s; s++)
 1b8:	fe843783          	ld	a5,-24(s0)
 1bc:	0785                	addi	a5,a5,1
 1be:	fef43423          	sd	a5,-24(s0)
 1c2:	fe843783          	ld	a5,-24(s0)
 1c6:	0007c783          	lbu	a5,0(a5)
 1ca:	fbf1                	bnez	a5,19e <strchr+0x14>
  return 0;
 1cc:	4781                	li	a5,0
}
 1ce:	853e                	mv	a0,a5
 1d0:	60e2                	ld	ra,24(sp)
 1d2:	6442                	ld	s0,16(sp)
 1d4:	6105                	addi	sp,sp,32
 1d6:	8082                	ret

00000000000001d8 <gets>:

char*
gets(char *buf, int max)
{
 1d8:	7179                	addi	sp,sp,-48
 1da:	f406                	sd	ra,40(sp)
 1dc:	f022                	sd	s0,32(sp)
 1de:	1800                	addi	s0,sp,48
 1e0:	fca43c23          	sd	a0,-40(s0)
 1e4:	87ae                	mv	a5,a1
 1e6:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ea:	fe042623          	sw	zero,-20(s0)
 1ee:	a8a1                	j	246 <gets+0x6e>
    cc = read(0, &c, 1);
 1f0:	fe740793          	addi	a5,s0,-25
 1f4:	4605                	li	a2,1
 1f6:	85be                	mv	a1,a5
 1f8:	4501                	li	a0,0
 1fa:	00000097          	auipc	ra,0x0
 1fe:	302080e7          	jalr	770(ra) # 4fc <read>
 202:	87aa                	mv	a5,a0
 204:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
 208:	fe842783          	lw	a5,-24(s0)
 20c:	2781                	sext.w	a5,a5
 20e:	04f05663          	blez	a5,25a <gets+0x82>
      break;
    buf[i++] = c;
 212:	fec42783          	lw	a5,-20(s0)
 216:	0017871b          	addiw	a4,a5,1
 21a:	fee42623          	sw	a4,-20(s0)
 21e:	873e                	mv	a4,a5
 220:	fd843783          	ld	a5,-40(s0)
 224:	97ba                	add	a5,a5,a4
 226:	fe744703          	lbu	a4,-25(s0)
 22a:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
 22e:	fe744783          	lbu	a5,-25(s0)
 232:	873e                	mv	a4,a5
 234:	47a9                	li	a5,10
 236:	02f70363          	beq	a4,a5,25c <gets+0x84>
 23a:	fe744783          	lbu	a5,-25(s0)
 23e:	873e                	mv	a4,a5
 240:	47b5                	li	a5,13
 242:	00f70d63          	beq	a4,a5,25c <gets+0x84>
  for(i=0; i+1 < max; ){
 246:	fec42783          	lw	a5,-20(s0)
 24a:	2785                	addiw	a5,a5,1
 24c:	2781                	sext.w	a5,a5
 24e:	fd442703          	lw	a4,-44(s0)
 252:	2701                	sext.w	a4,a4
 254:	f8e7cee3          	blt	a5,a4,1f0 <gets+0x18>
 258:	a011                	j	25c <gets+0x84>
      break;
 25a:	0001                	nop
      break;
  }
  buf[i] = '\0';
 25c:	fec42783          	lw	a5,-20(s0)
 260:	fd843703          	ld	a4,-40(s0)
 264:	97ba                	add	a5,a5,a4
 266:	00078023          	sb	zero,0(a5)
  return buf;
 26a:	fd843783          	ld	a5,-40(s0)
}
 26e:	853e                	mv	a0,a5
 270:	70a2                	ld	ra,40(sp)
 272:	7402                	ld	s0,32(sp)
 274:	6145                	addi	sp,sp,48
 276:	8082                	ret

0000000000000278 <stat>:

int
stat(const char *n, struct stat *st)
{
 278:	7179                	addi	sp,sp,-48
 27a:	f406                	sd	ra,40(sp)
 27c:	f022                	sd	s0,32(sp)
 27e:	1800                	addi	s0,sp,48
 280:	fca43c23          	sd	a0,-40(s0)
 284:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 288:	4581                	li	a1,0
 28a:	fd843503          	ld	a0,-40(s0)
 28e:	00000097          	auipc	ra,0x0
 292:	296080e7          	jalr	662(ra) # 524 <open>
 296:	87aa                	mv	a5,a0
 298:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
 29c:	fec42783          	lw	a5,-20(s0)
 2a0:	2781                	sext.w	a5,a5
 2a2:	0007d463          	bgez	a5,2aa <stat+0x32>
    return -1;
 2a6:	57fd                	li	a5,-1
 2a8:	a035                	j	2d4 <stat+0x5c>
  r = fstat(fd, st);
 2aa:	fec42783          	lw	a5,-20(s0)
 2ae:	fd043583          	ld	a1,-48(s0)
 2b2:	853e                	mv	a0,a5
 2b4:	00000097          	auipc	ra,0x0
 2b8:	288080e7          	jalr	648(ra) # 53c <fstat>
 2bc:	87aa                	mv	a5,a0
 2be:	fef42423          	sw	a5,-24(s0)
  close(fd);
 2c2:	fec42783          	lw	a5,-20(s0)
 2c6:	853e                	mv	a0,a5
 2c8:	00000097          	auipc	ra,0x0
 2cc:	244080e7          	jalr	580(ra) # 50c <close>
  return r;
 2d0:	fe842783          	lw	a5,-24(s0)
}
 2d4:	853e                	mv	a0,a5
 2d6:	70a2                	ld	ra,40(sp)
 2d8:	7402                	ld	s0,32(sp)
 2da:	6145                	addi	sp,sp,48
 2dc:	8082                	ret

00000000000002de <atoi>:

int
atoi(const char *s)
{
 2de:	7179                	addi	sp,sp,-48
 2e0:	f406                	sd	ra,40(sp)
 2e2:	f022                	sd	s0,32(sp)
 2e4:	1800                	addi	s0,sp,48
 2e6:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
 2ea:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
 2ee:	a81d                	j	324 <atoi+0x46>
    n = n*10 + *s++ - '0';
 2f0:	fec42783          	lw	a5,-20(s0)
 2f4:	873e                	mv	a4,a5
 2f6:	87ba                	mv	a5,a4
 2f8:	0027979b          	slliw	a5,a5,0x2
 2fc:	9fb9                	addw	a5,a5,a4
 2fe:	0017979b          	slliw	a5,a5,0x1
 302:	0007871b          	sext.w	a4,a5
 306:	fd843783          	ld	a5,-40(s0)
 30a:	00178693          	addi	a3,a5,1
 30e:	fcd43c23          	sd	a3,-40(s0)
 312:	0007c783          	lbu	a5,0(a5)
 316:	2781                	sext.w	a5,a5
 318:	9fb9                	addw	a5,a5,a4
 31a:	2781                	sext.w	a5,a5
 31c:	fd07879b          	addiw	a5,a5,-48
 320:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
 324:	fd843783          	ld	a5,-40(s0)
 328:	0007c783          	lbu	a5,0(a5)
 32c:	873e                	mv	a4,a5
 32e:	02f00793          	li	a5,47
 332:	00e7fb63          	bgeu	a5,a4,348 <atoi+0x6a>
 336:	fd843783          	ld	a5,-40(s0)
 33a:	0007c783          	lbu	a5,0(a5)
 33e:	873e                	mv	a4,a5
 340:	03900793          	li	a5,57
 344:	fae7f6e3          	bgeu	a5,a4,2f0 <atoi+0x12>
  return n;
 348:	fec42783          	lw	a5,-20(s0)
}
 34c:	853e                	mv	a0,a5
 34e:	70a2                	ld	ra,40(sp)
 350:	7402                	ld	s0,32(sp)
 352:	6145                	addi	sp,sp,48
 354:	8082                	ret

0000000000000356 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 356:	7139                	addi	sp,sp,-64
 358:	fc06                	sd	ra,56(sp)
 35a:	f822                	sd	s0,48(sp)
 35c:	0080                	addi	s0,sp,64
 35e:	fca43c23          	sd	a0,-40(s0)
 362:	fcb43823          	sd	a1,-48(s0)
 366:	87b2                	mv	a5,a2
 368:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
 36c:	fd843783          	ld	a5,-40(s0)
 370:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
 374:	fd043783          	ld	a5,-48(s0)
 378:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
 37c:	fe043703          	ld	a4,-32(s0)
 380:	fe843783          	ld	a5,-24(s0)
 384:	02e7fc63          	bgeu	a5,a4,3bc <memmove+0x66>
    while(n-- > 0)
 388:	a00d                	j	3aa <memmove+0x54>
      *dst++ = *src++;
 38a:	fe043703          	ld	a4,-32(s0)
 38e:	00170793          	addi	a5,a4,1
 392:	fef43023          	sd	a5,-32(s0)
 396:	fe843783          	ld	a5,-24(s0)
 39a:	00178693          	addi	a3,a5,1
 39e:	fed43423          	sd	a3,-24(s0)
 3a2:	00074703          	lbu	a4,0(a4)
 3a6:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 3aa:	fcc42783          	lw	a5,-52(s0)
 3ae:	fff7871b          	addiw	a4,a5,-1
 3b2:	fce42623          	sw	a4,-52(s0)
 3b6:	fcf04ae3          	bgtz	a5,38a <memmove+0x34>
 3ba:	a891                	j	40e <memmove+0xb8>
  } else {
    dst += n;
 3bc:	fcc42783          	lw	a5,-52(s0)
 3c0:	fe843703          	ld	a4,-24(s0)
 3c4:	97ba                	add	a5,a5,a4
 3c6:	fef43423          	sd	a5,-24(s0)
    src += n;
 3ca:	fcc42783          	lw	a5,-52(s0)
 3ce:	fe043703          	ld	a4,-32(s0)
 3d2:	97ba                	add	a5,a5,a4
 3d4:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
 3d8:	a01d                	j	3fe <memmove+0xa8>
      *--dst = *--src;
 3da:	fe043783          	ld	a5,-32(s0)
 3de:	17fd                	addi	a5,a5,-1
 3e0:	fef43023          	sd	a5,-32(s0)
 3e4:	fe843783          	ld	a5,-24(s0)
 3e8:	17fd                	addi	a5,a5,-1
 3ea:	fef43423          	sd	a5,-24(s0)
 3ee:	fe043783          	ld	a5,-32(s0)
 3f2:	0007c703          	lbu	a4,0(a5)
 3f6:	fe843783          	ld	a5,-24(s0)
 3fa:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 3fe:	fcc42783          	lw	a5,-52(s0)
 402:	fff7871b          	addiw	a4,a5,-1
 406:	fce42623          	sw	a4,-52(s0)
 40a:	fcf048e3          	bgtz	a5,3da <memmove+0x84>
  }
  return vdst;
 40e:	fd843783          	ld	a5,-40(s0)
}
 412:	853e                	mv	a0,a5
 414:	70e2                	ld	ra,56(sp)
 416:	7442                	ld	s0,48(sp)
 418:	6121                	addi	sp,sp,64
 41a:	8082                	ret

000000000000041c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 41c:	7139                	addi	sp,sp,-64
 41e:	fc06                	sd	ra,56(sp)
 420:	f822                	sd	s0,48(sp)
 422:	0080                	addi	s0,sp,64
 424:	fca43c23          	sd	a0,-40(s0)
 428:	fcb43823          	sd	a1,-48(s0)
 42c:	87b2                	mv	a5,a2
 42e:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
 432:	fd843783          	ld	a5,-40(s0)
 436:	fef43423          	sd	a5,-24(s0)
 43a:	fd043783          	ld	a5,-48(s0)
 43e:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 442:	a0a1                	j	48a <memcmp+0x6e>
    if (*p1 != *p2) {
 444:	fe843783          	ld	a5,-24(s0)
 448:	0007c703          	lbu	a4,0(a5)
 44c:	fe043783          	ld	a5,-32(s0)
 450:	0007c783          	lbu	a5,0(a5)
 454:	02f70163          	beq	a4,a5,476 <memcmp+0x5a>
      return *p1 - *p2;
 458:	fe843783          	ld	a5,-24(s0)
 45c:	0007c783          	lbu	a5,0(a5)
 460:	0007871b          	sext.w	a4,a5
 464:	fe043783          	ld	a5,-32(s0)
 468:	0007c783          	lbu	a5,0(a5)
 46c:	2781                	sext.w	a5,a5
 46e:	40f707bb          	subw	a5,a4,a5
 472:	2781                	sext.w	a5,a5
 474:	a01d                	j	49a <memcmp+0x7e>
    }
    p1++;
 476:	fe843783          	ld	a5,-24(s0)
 47a:	0785                	addi	a5,a5,1
 47c:	fef43423          	sd	a5,-24(s0)
    p2++;
 480:	fe043783          	ld	a5,-32(s0)
 484:	0785                	addi	a5,a5,1
 486:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 48a:	fcc42783          	lw	a5,-52(s0)
 48e:	fff7871b          	addiw	a4,a5,-1
 492:	fce42623          	sw	a4,-52(s0)
 496:	f7dd                	bnez	a5,444 <memcmp+0x28>
  }
  return 0;
 498:	4781                	li	a5,0
}
 49a:	853e                	mv	a0,a5
 49c:	70e2                	ld	ra,56(sp)
 49e:	7442                	ld	s0,48(sp)
 4a0:	6121                	addi	sp,sp,64
 4a2:	8082                	ret

00000000000004a4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4a4:	7179                	addi	sp,sp,-48
 4a6:	f406                	sd	ra,40(sp)
 4a8:	f022                	sd	s0,32(sp)
 4aa:	1800                	addi	s0,sp,48
 4ac:	fea43423          	sd	a0,-24(s0)
 4b0:	feb43023          	sd	a1,-32(s0)
 4b4:	87b2                	mv	a5,a2
 4b6:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
 4ba:	fdc42783          	lw	a5,-36(s0)
 4be:	863e                	mv	a2,a5
 4c0:	fe043583          	ld	a1,-32(s0)
 4c4:	fe843503          	ld	a0,-24(s0)
 4c8:	00000097          	auipc	ra,0x0
 4cc:	e8e080e7          	jalr	-370(ra) # 356 <memmove>
 4d0:	87aa                	mv	a5,a0
}
 4d2:	853e                	mv	a0,a5
 4d4:	70a2                	ld	ra,40(sp)
 4d6:	7402                	ld	s0,32(sp)
 4d8:	6145                	addi	sp,sp,48
 4da:	8082                	ret

00000000000004dc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4dc:	4885                	li	a7,1
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4e4:	4889                	li	a7,2
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <wait>:
.global wait
wait:
 li a7, SYS_wait
 4ec:	488d                	li	a7,3
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4f4:	4891                	li	a7,4
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <read>:
.global read
read:
 li a7, SYS_read
 4fc:	4895                	li	a7,5
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <write>:
.global write
write:
 li a7, SYS_write
 504:	48c1                	li	a7,16
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <close>:
.global close
close:
 li a7, SYS_close
 50c:	48d5                	li	a7,21
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <kill>:
.global kill
kill:
 li a7, SYS_kill
 514:	4899                	li	a7,6
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <exec>:
.global exec
exec:
 li a7, SYS_exec
 51c:	489d                	li	a7,7
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <open>:
.global open
open:
 li a7, SYS_open
 524:	48bd                	li	a7,15
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 52c:	48c5                	li	a7,17
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 534:	48c9                	li	a7,18
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 53c:	48a1                	li	a7,8
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <link>:
.global link
link:
 li a7, SYS_link
 544:	48cd                	li	a7,19
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 54c:	48d1                	li	a7,20
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 554:	48a5                	li	a7,9
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <dup>:
.global dup
dup:
 li a7, SYS_dup
 55c:	48a9                	li	a7,10
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 564:	48ad                	li	a7,11
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 56c:	48b1                	li	a7,12
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 574:	48b5                	li	a7,13
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 57c:	48b9                	li	a7,14
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <ps>:
.global ps
ps:
 li a7, SYS_ps
 584:	48d9                	li	a7,22
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 58c:	1101                	addi	sp,sp,-32
 58e:	ec06                	sd	ra,24(sp)
 590:	e822                	sd	s0,16(sp)
 592:	1000                	addi	s0,sp,32
 594:	87aa                	mv	a5,a0
 596:	872e                	mv	a4,a1
 598:	fef42623          	sw	a5,-20(s0)
 59c:	87ba                	mv	a5,a4
 59e:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 5a2:	feb40713          	addi	a4,s0,-21
 5a6:	fec42783          	lw	a5,-20(s0)
 5aa:	4605                	li	a2,1
 5ac:	85ba                	mv	a1,a4
 5ae:	853e                	mv	a0,a5
 5b0:	00000097          	auipc	ra,0x0
 5b4:	f54080e7          	jalr	-172(ra) # 504 <write>
}
 5b8:	0001                	nop
 5ba:	60e2                	ld	ra,24(sp)
 5bc:	6442                	ld	s0,16(sp)
 5be:	6105                	addi	sp,sp,32
 5c0:	8082                	ret

00000000000005c2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5c2:	7139                	addi	sp,sp,-64
 5c4:	fc06                	sd	ra,56(sp)
 5c6:	f822                	sd	s0,48(sp)
 5c8:	0080                	addi	s0,sp,64
 5ca:	87aa                	mv	a5,a0
 5cc:	8736                	mv	a4,a3
 5ce:	fcf42623          	sw	a5,-52(s0)
 5d2:	87ae                	mv	a5,a1
 5d4:	fcf42423          	sw	a5,-56(s0)
 5d8:	87b2                	mv	a5,a2
 5da:	fcf42223          	sw	a5,-60(s0)
 5de:	87ba                	mv	a5,a4
 5e0:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5e4:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 5e8:	fc042783          	lw	a5,-64(s0)
 5ec:	2781                	sext.w	a5,a5
 5ee:	c38d                	beqz	a5,610 <printint+0x4e>
 5f0:	fc842783          	lw	a5,-56(s0)
 5f4:	2781                	sext.w	a5,a5
 5f6:	0007dd63          	bgez	a5,610 <printint+0x4e>
    neg = 1;
 5fa:	4785                	li	a5,1
 5fc:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 600:	fc842783          	lw	a5,-56(s0)
 604:	40f007bb          	negw	a5,a5
 608:	2781                	sext.w	a5,a5
 60a:	fef42223          	sw	a5,-28(s0)
 60e:	a029                	j	618 <printint+0x56>
  } else {
    x = xx;
 610:	fc842783          	lw	a5,-56(s0)
 614:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 618:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 61c:	fc442783          	lw	a5,-60(s0)
 620:	fe442703          	lw	a4,-28(s0)
 624:	02f777bb          	remuw	a5,a4,a5
 628:	0007871b          	sext.w	a4,a5
 62c:	fec42783          	lw	a5,-20(s0)
 630:	0017869b          	addiw	a3,a5,1
 634:	fed42623          	sw	a3,-20(s0)
 638:	00001697          	auipc	a3,0x1
 63c:	9c868693          	addi	a3,a3,-1592 # 1000 <digits>
 640:	1702                	slli	a4,a4,0x20
 642:	9301                	srli	a4,a4,0x20
 644:	9736                	add	a4,a4,a3
 646:	00074703          	lbu	a4,0(a4)
 64a:	17c1                	addi	a5,a5,-16
 64c:	97a2                	add	a5,a5,s0
 64e:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 652:	fc442783          	lw	a5,-60(s0)
 656:	fe442703          	lw	a4,-28(s0)
 65a:	02f757bb          	divuw	a5,a4,a5
 65e:	fef42223          	sw	a5,-28(s0)
 662:	fe442783          	lw	a5,-28(s0)
 666:	2781                	sext.w	a5,a5
 668:	fbd5                	bnez	a5,61c <printint+0x5a>
  if(neg)
 66a:	fe842783          	lw	a5,-24(s0)
 66e:	2781                	sext.w	a5,a5
 670:	cf85                	beqz	a5,6a8 <printint+0xe6>
    buf[i++] = '-';
 672:	fec42783          	lw	a5,-20(s0)
 676:	0017871b          	addiw	a4,a5,1
 67a:	fee42623          	sw	a4,-20(s0)
 67e:	17c1                	addi	a5,a5,-16
 680:	97a2                	add	a5,a5,s0
 682:	02d00713          	li	a4,45
 686:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 68a:	a839                	j	6a8 <printint+0xe6>
    putc(fd, buf[i]);
 68c:	fec42783          	lw	a5,-20(s0)
 690:	17c1                	addi	a5,a5,-16
 692:	97a2                	add	a5,a5,s0
 694:	fe07c703          	lbu	a4,-32(a5)
 698:	fcc42783          	lw	a5,-52(s0)
 69c:	85ba                	mv	a1,a4
 69e:	853e                	mv	a0,a5
 6a0:	00000097          	auipc	ra,0x0
 6a4:	eec080e7          	jalr	-276(ra) # 58c <putc>
  while(--i >= 0)
 6a8:	fec42783          	lw	a5,-20(s0)
 6ac:	37fd                	addiw	a5,a5,-1
 6ae:	fef42623          	sw	a5,-20(s0)
 6b2:	fec42783          	lw	a5,-20(s0)
 6b6:	2781                	sext.w	a5,a5
 6b8:	fc07dae3          	bgez	a5,68c <printint+0xca>
}
 6bc:	0001                	nop
 6be:	0001                	nop
 6c0:	70e2                	ld	ra,56(sp)
 6c2:	7442                	ld	s0,48(sp)
 6c4:	6121                	addi	sp,sp,64
 6c6:	8082                	ret

00000000000006c8 <printptr>:

static void
printptr(int fd, uint64 x) {
 6c8:	7179                	addi	sp,sp,-48
 6ca:	f406                	sd	ra,40(sp)
 6cc:	f022                	sd	s0,32(sp)
 6ce:	1800                	addi	s0,sp,48
 6d0:	87aa                	mv	a5,a0
 6d2:	fcb43823          	sd	a1,-48(s0)
 6d6:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 6da:	fdc42783          	lw	a5,-36(s0)
 6de:	03000593          	li	a1,48
 6e2:	853e                	mv	a0,a5
 6e4:	00000097          	auipc	ra,0x0
 6e8:	ea8080e7          	jalr	-344(ra) # 58c <putc>
  putc(fd, 'x');
 6ec:	fdc42783          	lw	a5,-36(s0)
 6f0:	07800593          	li	a1,120
 6f4:	853e                	mv	a0,a5
 6f6:	00000097          	auipc	ra,0x0
 6fa:	e96080e7          	jalr	-362(ra) # 58c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6fe:	fe042623          	sw	zero,-20(s0)
 702:	a82d                	j	73c <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 704:	fd043783          	ld	a5,-48(s0)
 708:	93f1                	srli	a5,a5,0x3c
 70a:	00001717          	auipc	a4,0x1
 70e:	8f670713          	addi	a4,a4,-1802 # 1000 <digits>
 712:	97ba                	add	a5,a5,a4
 714:	0007c703          	lbu	a4,0(a5)
 718:	fdc42783          	lw	a5,-36(s0)
 71c:	85ba                	mv	a1,a4
 71e:	853e                	mv	a0,a5
 720:	00000097          	auipc	ra,0x0
 724:	e6c080e7          	jalr	-404(ra) # 58c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 728:	fec42783          	lw	a5,-20(s0)
 72c:	2785                	addiw	a5,a5,1
 72e:	fef42623          	sw	a5,-20(s0)
 732:	fd043783          	ld	a5,-48(s0)
 736:	0792                	slli	a5,a5,0x4
 738:	fcf43823          	sd	a5,-48(s0)
 73c:	fec42703          	lw	a4,-20(s0)
 740:	47bd                	li	a5,15
 742:	fce7f1e3          	bgeu	a5,a4,704 <printptr+0x3c>
}
 746:	0001                	nop
 748:	0001                	nop
 74a:	70a2                	ld	ra,40(sp)
 74c:	7402                	ld	s0,32(sp)
 74e:	6145                	addi	sp,sp,48
 750:	8082                	ret

0000000000000752 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 752:	715d                	addi	sp,sp,-80
 754:	e486                	sd	ra,72(sp)
 756:	e0a2                	sd	s0,64(sp)
 758:	0880                	addi	s0,sp,80
 75a:	87aa                	mv	a5,a0
 75c:	fcb43023          	sd	a1,-64(s0)
 760:	fac43c23          	sd	a2,-72(s0)
 764:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 768:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 76c:	fe042223          	sw	zero,-28(s0)
 770:	a42d                	j	99a <vprintf+0x248>
    c = fmt[i] & 0xff;
 772:	fe442783          	lw	a5,-28(s0)
 776:	fc043703          	ld	a4,-64(s0)
 77a:	97ba                	add	a5,a5,a4
 77c:	0007c783          	lbu	a5,0(a5)
 780:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 784:	fe042783          	lw	a5,-32(s0)
 788:	2781                	sext.w	a5,a5
 78a:	eb9d                	bnez	a5,7c0 <vprintf+0x6e>
      if(c == '%'){
 78c:	fdc42783          	lw	a5,-36(s0)
 790:	0007871b          	sext.w	a4,a5
 794:	02500793          	li	a5,37
 798:	00f71763          	bne	a4,a5,7a6 <vprintf+0x54>
        state = '%';
 79c:	02500793          	li	a5,37
 7a0:	fef42023          	sw	a5,-32(s0)
 7a4:	a2f5                	j	990 <vprintf+0x23e>
      } else {
        putc(fd, c);
 7a6:	fdc42783          	lw	a5,-36(s0)
 7aa:	0ff7f713          	zext.b	a4,a5
 7ae:	fcc42783          	lw	a5,-52(s0)
 7b2:	85ba                	mv	a1,a4
 7b4:	853e                	mv	a0,a5
 7b6:	00000097          	auipc	ra,0x0
 7ba:	dd6080e7          	jalr	-554(ra) # 58c <putc>
 7be:	aac9                	j	990 <vprintf+0x23e>
      }
    } else if(state == '%'){
 7c0:	fe042783          	lw	a5,-32(s0)
 7c4:	0007871b          	sext.w	a4,a5
 7c8:	02500793          	li	a5,37
 7cc:	1cf71263          	bne	a4,a5,990 <vprintf+0x23e>
      if(c == 'd'){
 7d0:	fdc42783          	lw	a5,-36(s0)
 7d4:	0007871b          	sext.w	a4,a5
 7d8:	06400793          	li	a5,100
 7dc:	02f71463          	bne	a4,a5,804 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 7e0:	fb843783          	ld	a5,-72(s0)
 7e4:	00878713          	addi	a4,a5,8
 7e8:	fae43c23          	sd	a4,-72(s0)
 7ec:	4398                	lw	a4,0(a5)
 7ee:	fcc42783          	lw	a5,-52(s0)
 7f2:	4685                	li	a3,1
 7f4:	4629                	li	a2,10
 7f6:	85ba                	mv	a1,a4
 7f8:	853e                	mv	a0,a5
 7fa:	00000097          	auipc	ra,0x0
 7fe:	dc8080e7          	jalr	-568(ra) # 5c2 <printint>
 802:	a269                	j	98c <vprintf+0x23a>
      } else if(c == 'l') {
 804:	fdc42783          	lw	a5,-36(s0)
 808:	0007871b          	sext.w	a4,a5
 80c:	06c00793          	li	a5,108
 810:	02f71663          	bne	a4,a5,83c <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 814:	fb843783          	ld	a5,-72(s0)
 818:	00878713          	addi	a4,a5,8
 81c:	fae43c23          	sd	a4,-72(s0)
 820:	639c                	ld	a5,0(a5)
 822:	0007871b          	sext.w	a4,a5
 826:	fcc42783          	lw	a5,-52(s0)
 82a:	4681                	li	a3,0
 82c:	4629                	li	a2,10
 82e:	85ba                	mv	a1,a4
 830:	853e                	mv	a0,a5
 832:	00000097          	auipc	ra,0x0
 836:	d90080e7          	jalr	-624(ra) # 5c2 <printint>
 83a:	aa89                	j	98c <vprintf+0x23a>
      } else if(c == 'x') {
 83c:	fdc42783          	lw	a5,-36(s0)
 840:	0007871b          	sext.w	a4,a5
 844:	07800793          	li	a5,120
 848:	02f71463          	bne	a4,a5,870 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 84c:	fb843783          	ld	a5,-72(s0)
 850:	00878713          	addi	a4,a5,8
 854:	fae43c23          	sd	a4,-72(s0)
 858:	4398                	lw	a4,0(a5)
 85a:	fcc42783          	lw	a5,-52(s0)
 85e:	4681                	li	a3,0
 860:	4641                	li	a2,16
 862:	85ba                	mv	a1,a4
 864:	853e                	mv	a0,a5
 866:	00000097          	auipc	ra,0x0
 86a:	d5c080e7          	jalr	-676(ra) # 5c2 <printint>
 86e:	aa39                	j	98c <vprintf+0x23a>
      } else if(c == 'p') {
 870:	fdc42783          	lw	a5,-36(s0)
 874:	0007871b          	sext.w	a4,a5
 878:	07000793          	li	a5,112
 87c:	02f71263          	bne	a4,a5,8a0 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 880:	fb843783          	ld	a5,-72(s0)
 884:	00878713          	addi	a4,a5,8
 888:	fae43c23          	sd	a4,-72(s0)
 88c:	6398                	ld	a4,0(a5)
 88e:	fcc42783          	lw	a5,-52(s0)
 892:	85ba                	mv	a1,a4
 894:	853e                	mv	a0,a5
 896:	00000097          	auipc	ra,0x0
 89a:	e32080e7          	jalr	-462(ra) # 6c8 <printptr>
 89e:	a0fd                	j	98c <vprintf+0x23a>
      } else if(c == 's'){
 8a0:	fdc42783          	lw	a5,-36(s0)
 8a4:	0007871b          	sext.w	a4,a5
 8a8:	07300793          	li	a5,115
 8ac:	04f71c63          	bne	a4,a5,904 <vprintf+0x1b2>
        s = va_arg(ap, char*);
 8b0:	fb843783          	ld	a5,-72(s0)
 8b4:	00878713          	addi	a4,a5,8
 8b8:	fae43c23          	sd	a4,-72(s0)
 8bc:	639c                	ld	a5,0(a5)
 8be:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 8c2:	fe843783          	ld	a5,-24(s0)
 8c6:	eb8d                	bnez	a5,8f8 <vprintf+0x1a6>
          s = "(null)";
 8c8:	00000797          	auipc	a5,0x0
 8cc:	47878793          	addi	a5,a5,1144 # d40 <malloc+0x13c>
 8d0:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 8d4:	a015                	j	8f8 <vprintf+0x1a6>
          putc(fd, *s);
 8d6:	fe843783          	ld	a5,-24(s0)
 8da:	0007c703          	lbu	a4,0(a5)
 8de:	fcc42783          	lw	a5,-52(s0)
 8e2:	85ba                	mv	a1,a4
 8e4:	853e                	mv	a0,a5
 8e6:	00000097          	auipc	ra,0x0
 8ea:	ca6080e7          	jalr	-858(ra) # 58c <putc>
          s++;
 8ee:	fe843783          	ld	a5,-24(s0)
 8f2:	0785                	addi	a5,a5,1
 8f4:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 8f8:	fe843783          	ld	a5,-24(s0)
 8fc:	0007c783          	lbu	a5,0(a5)
 900:	fbf9                	bnez	a5,8d6 <vprintf+0x184>
 902:	a069                	j	98c <vprintf+0x23a>
        }
      } else if(c == 'c'){
 904:	fdc42783          	lw	a5,-36(s0)
 908:	0007871b          	sext.w	a4,a5
 90c:	06300793          	li	a5,99
 910:	02f71463          	bne	a4,a5,938 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 914:	fb843783          	ld	a5,-72(s0)
 918:	00878713          	addi	a4,a5,8
 91c:	fae43c23          	sd	a4,-72(s0)
 920:	439c                	lw	a5,0(a5)
 922:	0ff7f713          	zext.b	a4,a5
 926:	fcc42783          	lw	a5,-52(s0)
 92a:	85ba                	mv	a1,a4
 92c:	853e                	mv	a0,a5
 92e:	00000097          	auipc	ra,0x0
 932:	c5e080e7          	jalr	-930(ra) # 58c <putc>
 936:	a899                	j	98c <vprintf+0x23a>
      } else if(c == '%'){
 938:	fdc42783          	lw	a5,-36(s0)
 93c:	0007871b          	sext.w	a4,a5
 940:	02500793          	li	a5,37
 944:	00f71f63          	bne	a4,a5,962 <vprintf+0x210>
        putc(fd, c);
 948:	fdc42783          	lw	a5,-36(s0)
 94c:	0ff7f713          	zext.b	a4,a5
 950:	fcc42783          	lw	a5,-52(s0)
 954:	85ba                	mv	a1,a4
 956:	853e                	mv	a0,a5
 958:	00000097          	auipc	ra,0x0
 95c:	c34080e7          	jalr	-972(ra) # 58c <putc>
 960:	a035                	j	98c <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 962:	fcc42783          	lw	a5,-52(s0)
 966:	02500593          	li	a1,37
 96a:	853e                	mv	a0,a5
 96c:	00000097          	auipc	ra,0x0
 970:	c20080e7          	jalr	-992(ra) # 58c <putc>
        putc(fd, c);
 974:	fdc42783          	lw	a5,-36(s0)
 978:	0ff7f713          	zext.b	a4,a5
 97c:	fcc42783          	lw	a5,-52(s0)
 980:	85ba                	mv	a1,a4
 982:	853e                	mv	a0,a5
 984:	00000097          	auipc	ra,0x0
 988:	c08080e7          	jalr	-1016(ra) # 58c <putc>
      }
      state = 0;
 98c:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 990:	fe442783          	lw	a5,-28(s0)
 994:	2785                	addiw	a5,a5,1
 996:	fef42223          	sw	a5,-28(s0)
 99a:	fe442783          	lw	a5,-28(s0)
 99e:	fc043703          	ld	a4,-64(s0)
 9a2:	97ba                	add	a5,a5,a4
 9a4:	0007c783          	lbu	a5,0(a5)
 9a8:	dc0795e3          	bnez	a5,772 <vprintf+0x20>
    }
  }
}
 9ac:	0001                	nop
 9ae:	0001                	nop
 9b0:	60a6                	ld	ra,72(sp)
 9b2:	6406                	ld	s0,64(sp)
 9b4:	6161                	addi	sp,sp,80
 9b6:	8082                	ret

00000000000009b8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9b8:	7159                	addi	sp,sp,-112
 9ba:	fc06                	sd	ra,56(sp)
 9bc:	f822                	sd	s0,48(sp)
 9be:	0080                	addi	s0,sp,64
 9c0:	fcb43823          	sd	a1,-48(s0)
 9c4:	e010                	sd	a2,0(s0)
 9c6:	e414                	sd	a3,8(s0)
 9c8:	e818                	sd	a4,16(s0)
 9ca:	ec1c                	sd	a5,24(s0)
 9cc:	03043023          	sd	a6,32(s0)
 9d0:	03143423          	sd	a7,40(s0)
 9d4:	87aa                	mv	a5,a0
 9d6:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 9da:	03040793          	addi	a5,s0,48
 9de:	fcf43423          	sd	a5,-56(s0)
 9e2:	fc843783          	ld	a5,-56(s0)
 9e6:	fd078793          	addi	a5,a5,-48
 9ea:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 9ee:	fe843703          	ld	a4,-24(s0)
 9f2:	fdc42783          	lw	a5,-36(s0)
 9f6:	863a                	mv	a2,a4
 9f8:	fd043583          	ld	a1,-48(s0)
 9fc:	853e                	mv	a0,a5
 9fe:	00000097          	auipc	ra,0x0
 a02:	d54080e7          	jalr	-684(ra) # 752 <vprintf>
}
 a06:	0001                	nop
 a08:	70e2                	ld	ra,56(sp)
 a0a:	7442                	ld	s0,48(sp)
 a0c:	6165                	addi	sp,sp,112
 a0e:	8082                	ret

0000000000000a10 <printf>:

void
printf(const char *fmt, ...)
{
 a10:	7159                	addi	sp,sp,-112
 a12:	f406                	sd	ra,40(sp)
 a14:	f022                	sd	s0,32(sp)
 a16:	1800                	addi	s0,sp,48
 a18:	fca43c23          	sd	a0,-40(s0)
 a1c:	e40c                	sd	a1,8(s0)
 a1e:	e810                	sd	a2,16(s0)
 a20:	ec14                	sd	a3,24(s0)
 a22:	f018                	sd	a4,32(s0)
 a24:	f41c                	sd	a5,40(s0)
 a26:	03043823          	sd	a6,48(s0)
 a2a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a2e:	04040793          	addi	a5,s0,64
 a32:	fcf43823          	sd	a5,-48(s0)
 a36:	fd043783          	ld	a5,-48(s0)
 a3a:	fc878793          	addi	a5,a5,-56
 a3e:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 a42:	fe843783          	ld	a5,-24(s0)
 a46:	863e                	mv	a2,a5
 a48:	fd843583          	ld	a1,-40(s0)
 a4c:	4505                	li	a0,1
 a4e:	00000097          	auipc	ra,0x0
 a52:	d04080e7          	jalr	-764(ra) # 752 <vprintf>
}
 a56:	0001                	nop
 a58:	70a2                	ld	ra,40(sp)
 a5a:	7402                	ld	s0,32(sp)
 a5c:	6165                	addi	sp,sp,112
 a5e:	8082                	ret

0000000000000a60 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a60:	7179                	addi	sp,sp,-48
 a62:	f406                	sd	ra,40(sp)
 a64:	f022                	sd	s0,32(sp)
 a66:	1800                	addi	s0,sp,48
 a68:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a6c:	fd843783          	ld	a5,-40(s0)
 a70:	17c1                	addi	a5,a5,-16
 a72:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a76:	00000797          	auipc	a5,0x0
 a7a:	5ba78793          	addi	a5,a5,1466 # 1030 <freep>
 a7e:	639c                	ld	a5,0(a5)
 a80:	fef43423          	sd	a5,-24(s0)
 a84:	a815                	j	ab8 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a86:	fe843783          	ld	a5,-24(s0)
 a8a:	639c                	ld	a5,0(a5)
 a8c:	fe843703          	ld	a4,-24(s0)
 a90:	00f76f63          	bltu	a4,a5,aae <free+0x4e>
 a94:	fe043703          	ld	a4,-32(s0)
 a98:	fe843783          	ld	a5,-24(s0)
 a9c:	02e7eb63          	bltu	a5,a4,ad2 <free+0x72>
 aa0:	fe843783          	ld	a5,-24(s0)
 aa4:	639c                	ld	a5,0(a5)
 aa6:	fe043703          	ld	a4,-32(s0)
 aaa:	02f76463          	bltu	a4,a5,ad2 <free+0x72>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 aae:	fe843783          	ld	a5,-24(s0)
 ab2:	639c                	ld	a5,0(a5)
 ab4:	fef43423          	sd	a5,-24(s0)
 ab8:	fe043703          	ld	a4,-32(s0)
 abc:	fe843783          	ld	a5,-24(s0)
 ac0:	fce7f3e3          	bgeu	a5,a4,a86 <free+0x26>
 ac4:	fe843783          	ld	a5,-24(s0)
 ac8:	639c                	ld	a5,0(a5)
 aca:	fe043703          	ld	a4,-32(s0)
 ace:	faf77ce3          	bgeu	a4,a5,a86 <free+0x26>
      break;
  if(bp + bp->s.size == p->s.ptr){
 ad2:	fe043783          	ld	a5,-32(s0)
 ad6:	479c                	lw	a5,8(a5)
 ad8:	1782                	slli	a5,a5,0x20
 ada:	9381                	srli	a5,a5,0x20
 adc:	0792                	slli	a5,a5,0x4
 ade:	fe043703          	ld	a4,-32(s0)
 ae2:	973e                	add	a4,a4,a5
 ae4:	fe843783          	ld	a5,-24(s0)
 ae8:	639c                	ld	a5,0(a5)
 aea:	02f71763          	bne	a4,a5,b18 <free+0xb8>
    bp->s.size += p->s.ptr->s.size;
 aee:	fe043783          	ld	a5,-32(s0)
 af2:	4798                	lw	a4,8(a5)
 af4:	fe843783          	ld	a5,-24(s0)
 af8:	639c                	ld	a5,0(a5)
 afa:	479c                	lw	a5,8(a5)
 afc:	9fb9                	addw	a5,a5,a4
 afe:	0007871b          	sext.w	a4,a5
 b02:	fe043783          	ld	a5,-32(s0)
 b06:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 b08:	fe843783          	ld	a5,-24(s0)
 b0c:	639c                	ld	a5,0(a5)
 b0e:	6398                	ld	a4,0(a5)
 b10:	fe043783          	ld	a5,-32(s0)
 b14:	e398                	sd	a4,0(a5)
 b16:	a039                	j	b24 <free+0xc4>
  } else
    bp->s.ptr = p->s.ptr;
 b18:	fe843783          	ld	a5,-24(s0)
 b1c:	6398                	ld	a4,0(a5)
 b1e:	fe043783          	ld	a5,-32(s0)
 b22:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 b24:	fe843783          	ld	a5,-24(s0)
 b28:	479c                	lw	a5,8(a5)
 b2a:	1782                	slli	a5,a5,0x20
 b2c:	9381                	srli	a5,a5,0x20
 b2e:	0792                	slli	a5,a5,0x4
 b30:	fe843703          	ld	a4,-24(s0)
 b34:	97ba                	add	a5,a5,a4
 b36:	fe043703          	ld	a4,-32(s0)
 b3a:	02f71563          	bne	a4,a5,b64 <free+0x104>
    p->s.size += bp->s.size;
 b3e:	fe843783          	ld	a5,-24(s0)
 b42:	4798                	lw	a4,8(a5)
 b44:	fe043783          	ld	a5,-32(s0)
 b48:	479c                	lw	a5,8(a5)
 b4a:	9fb9                	addw	a5,a5,a4
 b4c:	0007871b          	sext.w	a4,a5
 b50:	fe843783          	ld	a5,-24(s0)
 b54:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b56:	fe043783          	ld	a5,-32(s0)
 b5a:	6398                	ld	a4,0(a5)
 b5c:	fe843783          	ld	a5,-24(s0)
 b60:	e398                	sd	a4,0(a5)
 b62:	a031                	j	b6e <free+0x10e>
  } else
    p->s.ptr = bp;
 b64:	fe843783          	ld	a5,-24(s0)
 b68:	fe043703          	ld	a4,-32(s0)
 b6c:	e398                	sd	a4,0(a5)
  freep = p;
 b6e:	00000797          	auipc	a5,0x0
 b72:	4c278793          	addi	a5,a5,1218 # 1030 <freep>
 b76:	fe843703          	ld	a4,-24(s0)
 b7a:	e398                	sd	a4,0(a5)
}
 b7c:	0001                	nop
 b7e:	70a2                	ld	ra,40(sp)
 b80:	7402                	ld	s0,32(sp)
 b82:	6145                	addi	sp,sp,48
 b84:	8082                	ret

0000000000000b86 <morecore>:

static Header*
morecore(uint nu)
{
 b86:	7179                	addi	sp,sp,-48
 b88:	f406                	sd	ra,40(sp)
 b8a:	f022                	sd	s0,32(sp)
 b8c:	1800                	addi	s0,sp,48
 b8e:	87aa                	mv	a5,a0
 b90:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 b94:	fdc42783          	lw	a5,-36(s0)
 b98:	0007871b          	sext.w	a4,a5
 b9c:	6785                	lui	a5,0x1
 b9e:	00f77563          	bgeu	a4,a5,ba8 <morecore+0x22>
    nu = 4096;
 ba2:	6785                	lui	a5,0x1
 ba4:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 ba8:	fdc42783          	lw	a5,-36(s0)
 bac:	0047979b          	slliw	a5,a5,0x4
 bb0:	2781                	sext.w	a5,a5
 bb2:	853e                	mv	a0,a5
 bb4:	00000097          	auipc	ra,0x0
 bb8:	9b8080e7          	jalr	-1608(ra) # 56c <sbrk>
 bbc:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 bc0:	fe843703          	ld	a4,-24(s0)
 bc4:	57fd                	li	a5,-1
 bc6:	00f71463          	bne	a4,a5,bce <morecore+0x48>
    return 0;
 bca:	4781                	li	a5,0
 bcc:	a03d                	j	bfa <morecore+0x74>
  hp = (Header*)p;
 bce:	fe843783          	ld	a5,-24(s0)
 bd2:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 bd6:	fe043783          	ld	a5,-32(s0)
 bda:	fdc42703          	lw	a4,-36(s0)
 bde:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 be0:	fe043783          	ld	a5,-32(s0)
 be4:	07c1                	addi	a5,a5,16 # 1010 <digits+0x10>
 be6:	853e                	mv	a0,a5
 be8:	00000097          	auipc	ra,0x0
 bec:	e78080e7          	jalr	-392(ra) # a60 <free>
  return freep;
 bf0:	00000797          	auipc	a5,0x0
 bf4:	44078793          	addi	a5,a5,1088 # 1030 <freep>
 bf8:	639c                	ld	a5,0(a5)
}
 bfa:	853e                	mv	a0,a5
 bfc:	70a2                	ld	ra,40(sp)
 bfe:	7402                	ld	s0,32(sp)
 c00:	6145                	addi	sp,sp,48
 c02:	8082                	ret

0000000000000c04 <malloc>:

void*
malloc(uint nbytes)
{
 c04:	7139                	addi	sp,sp,-64
 c06:	fc06                	sd	ra,56(sp)
 c08:	f822                	sd	s0,48(sp)
 c0a:	0080                	addi	s0,sp,64
 c0c:	87aa                	mv	a5,a0
 c0e:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c12:	fcc46783          	lwu	a5,-52(s0)
 c16:	07bd                	addi	a5,a5,15
 c18:	8391                	srli	a5,a5,0x4
 c1a:	2781                	sext.w	a5,a5
 c1c:	2785                	addiw	a5,a5,1
 c1e:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 c22:	00000797          	auipc	a5,0x0
 c26:	40e78793          	addi	a5,a5,1038 # 1030 <freep>
 c2a:	639c                	ld	a5,0(a5)
 c2c:	fef43023          	sd	a5,-32(s0)
 c30:	fe043783          	ld	a5,-32(s0)
 c34:	ef95                	bnez	a5,c70 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 c36:	00000797          	auipc	a5,0x0
 c3a:	3ea78793          	addi	a5,a5,1002 # 1020 <base>
 c3e:	fef43023          	sd	a5,-32(s0)
 c42:	00000797          	auipc	a5,0x0
 c46:	3ee78793          	addi	a5,a5,1006 # 1030 <freep>
 c4a:	fe043703          	ld	a4,-32(s0)
 c4e:	e398                	sd	a4,0(a5)
 c50:	00000797          	auipc	a5,0x0
 c54:	3e078793          	addi	a5,a5,992 # 1030 <freep>
 c58:	6398                	ld	a4,0(a5)
 c5a:	00000797          	auipc	a5,0x0
 c5e:	3c678793          	addi	a5,a5,966 # 1020 <base>
 c62:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 c64:	00000797          	auipc	a5,0x0
 c68:	3bc78793          	addi	a5,a5,956 # 1020 <base>
 c6c:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c70:	fe043783          	ld	a5,-32(s0)
 c74:	639c                	ld	a5,0(a5)
 c76:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 c7a:	fe843783          	ld	a5,-24(s0)
 c7e:	479c                	lw	a5,8(a5)
 c80:	fdc42703          	lw	a4,-36(s0)
 c84:	2701                	sext.w	a4,a4
 c86:	06e7e763          	bltu	a5,a4,cf4 <malloc+0xf0>
      if(p->s.size == nunits)
 c8a:	fe843783          	ld	a5,-24(s0)
 c8e:	479c                	lw	a5,8(a5)
 c90:	fdc42703          	lw	a4,-36(s0)
 c94:	2701                	sext.w	a4,a4
 c96:	00f71963          	bne	a4,a5,ca8 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 c9a:	fe843783          	ld	a5,-24(s0)
 c9e:	6398                	ld	a4,0(a5)
 ca0:	fe043783          	ld	a5,-32(s0)
 ca4:	e398                	sd	a4,0(a5)
 ca6:	a825                	j	cde <malloc+0xda>
      else {
        p->s.size -= nunits;
 ca8:	fe843783          	ld	a5,-24(s0)
 cac:	479c                	lw	a5,8(a5)
 cae:	fdc42703          	lw	a4,-36(s0)
 cb2:	9f99                	subw	a5,a5,a4
 cb4:	0007871b          	sext.w	a4,a5
 cb8:	fe843783          	ld	a5,-24(s0)
 cbc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 cbe:	fe843783          	ld	a5,-24(s0)
 cc2:	479c                	lw	a5,8(a5)
 cc4:	1782                	slli	a5,a5,0x20
 cc6:	9381                	srli	a5,a5,0x20
 cc8:	0792                	slli	a5,a5,0x4
 cca:	fe843703          	ld	a4,-24(s0)
 cce:	97ba                	add	a5,a5,a4
 cd0:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 cd4:	fe843783          	ld	a5,-24(s0)
 cd8:	fdc42703          	lw	a4,-36(s0)
 cdc:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 cde:	00000797          	auipc	a5,0x0
 ce2:	35278793          	addi	a5,a5,850 # 1030 <freep>
 ce6:	fe043703          	ld	a4,-32(s0)
 cea:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 cec:	fe843783          	ld	a5,-24(s0)
 cf0:	07c1                	addi	a5,a5,16
 cf2:	a091                	j	d36 <malloc+0x132>
    }
    if(p == freep)
 cf4:	00000797          	auipc	a5,0x0
 cf8:	33c78793          	addi	a5,a5,828 # 1030 <freep>
 cfc:	639c                	ld	a5,0(a5)
 cfe:	fe843703          	ld	a4,-24(s0)
 d02:	02f71063          	bne	a4,a5,d22 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 d06:	fdc42783          	lw	a5,-36(s0)
 d0a:	853e                	mv	a0,a5
 d0c:	00000097          	auipc	ra,0x0
 d10:	e7a080e7          	jalr	-390(ra) # b86 <morecore>
 d14:	fea43423          	sd	a0,-24(s0)
 d18:	fe843783          	ld	a5,-24(s0)
 d1c:	e399                	bnez	a5,d22 <malloc+0x11e>
        return 0;
 d1e:	4781                	li	a5,0
 d20:	a819                	j	d36 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d22:	fe843783          	ld	a5,-24(s0)
 d26:	fef43023          	sd	a5,-32(s0)
 d2a:	fe843783          	ld	a5,-24(s0)
 d2e:	639c                	ld	a5,0(a5)
 d30:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 d34:	b799                	j	c7a <malloc+0x76>
  }
}
 d36:	853e                	mv	a0,a5
 d38:	70e2                	ld	ra,56(sp)
 d3a:	7442                	ld	s0,48(sp)
 d3c:	6121                	addi	sp,sp,64
 d3e:	8082                	ret
