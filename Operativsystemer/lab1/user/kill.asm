
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	1800                	addi	s0,sp,48
   8:	87aa                	mv	a5,a0
   a:	fcb43823          	sd	a1,-48(s0)
   e:	fcf42e23          	sw	a5,-36(s0)
  int i;

  if(argc < 2){
  12:	fdc42783          	lw	a5,-36(s0)
  16:	0007871b          	sext.w	a4,a5
  1a:	4785                	li	a5,1
  1c:	02e7c063          	blt	a5,a4,3c <main+0x3c>
    fprintf(2, "usage: kill pid...\n");
  20:	00001597          	auipc	a1,0x1
  24:	da058593          	addi	a1,a1,-608 # dc0 <malloc+0x148>
  28:	4509                	li	a0,2
  2a:	00001097          	auipc	ra,0x1
  2e:	a02080e7          	jalr	-1534(ra) # a2c <fprintf>
    exit(1);
  32:	4505                	li	a0,1
  34:	00000097          	auipc	ra,0x0
  38:	524080e7          	jalr	1316(ra) # 558 <exit>
  }
  for(i=1; i<argc; i++)
  3c:	4785                	li	a5,1
  3e:	fef42623          	sw	a5,-20(s0)
  42:	a805                	j	72 <main+0x72>
    kill(atoi(argv[i]));
  44:	fec42783          	lw	a5,-20(s0)
  48:	078e                	slli	a5,a5,0x3
  4a:	fd043703          	ld	a4,-48(s0)
  4e:	97ba                	add	a5,a5,a4
  50:	639c                	ld	a5,0(a5)
  52:	853e                	mv	a0,a5
  54:	00000097          	auipc	ra,0x0
  58:	2fe080e7          	jalr	766(ra) # 352 <atoi>
  5c:	87aa                	mv	a5,a0
  5e:	853e                	mv	a0,a5
  60:	00000097          	auipc	ra,0x0
  64:	528080e7          	jalr	1320(ra) # 588 <kill>
  for(i=1; i<argc; i++)
  68:	fec42783          	lw	a5,-20(s0)
  6c:	2785                	addiw	a5,a5,1
  6e:	fef42623          	sw	a5,-20(s0)
  72:	fec42783          	lw	a5,-20(s0)
  76:	873e                	mv	a4,a5
  78:	fdc42783          	lw	a5,-36(s0)
  7c:	2701                	sext.w	a4,a4
  7e:	2781                	sext.w	a5,a5
  80:	fcf742e3          	blt	a4,a5,44 <main+0x44>
  exit(0);
  84:	4501                	li	a0,0
  86:	00000097          	auipc	ra,0x0
  8a:	4d2080e7          	jalr	1234(ra) # 558 <exit>

000000000000008e <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  8e:	1141                	addi	sp,sp,-16
  90:	e406                	sd	ra,8(sp)
  92:	e022                	sd	s0,0(sp)
  94:	0800                	addi	s0,sp,16
  extern int main();
  main();
  96:	00000097          	auipc	ra,0x0
  9a:	f6a080e7          	jalr	-150(ra) # 0 <main>
  exit(0);
  9e:	4501                	li	a0,0
  a0:	00000097          	auipc	ra,0x0
  a4:	4b8080e7          	jalr	1208(ra) # 558 <exit>

00000000000000a8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  a8:	7179                	addi	sp,sp,-48
  aa:	f406                	sd	ra,40(sp)
  ac:	f022                	sd	s0,32(sp)
  ae:	1800                	addi	s0,sp,48
  b0:	fca43c23          	sd	a0,-40(s0)
  b4:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
  b8:	fd843783          	ld	a5,-40(s0)
  bc:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
  c0:	0001                	nop
  c2:	fd043703          	ld	a4,-48(s0)
  c6:	00170793          	addi	a5,a4,1
  ca:	fcf43823          	sd	a5,-48(s0)
  ce:	fd843783          	ld	a5,-40(s0)
  d2:	00178693          	addi	a3,a5,1
  d6:	fcd43c23          	sd	a3,-40(s0)
  da:	00074703          	lbu	a4,0(a4)
  de:	00e78023          	sb	a4,0(a5)
  e2:	0007c783          	lbu	a5,0(a5)
  e6:	fff1                	bnez	a5,c2 <strcpy+0x1a>
    ;
  return os;
  e8:	fe843783          	ld	a5,-24(s0)
}
  ec:	853e                	mv	a0,a5
  ee:	70a2                	ld	ra,40(sp)
  f0:	7402                	ld	s0,32(sp)
  f2:	6145                	addi	sp,sp,48
  f4:	8082                	ret

00000000000000f6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f6:	1101                	addi	sp,sp,-32
  f8:	ec06                	sd	ra,24(sp)
  fa:	e822                	sd	s0,16(sp)
  fc:	1000                	addi	s0,sp,32
  fe:	fea43423          	sd	a0,-24(s0)
 102:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
 106:	a819                	j	11c <strcmp+0x26>
    p++, q++;
 108:	fe843783          	ld	a5,-24(s0)
 10c:	0785                	addi	a5,a5,1
 10e:	fef43423          	sd	a5,-24(s0)
 112:	fe043783          	ld	a5,-32(s0)
 116:	0785                	addi	a5,a5,1
 118:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
 11c:	fe843783          	ld	a5,-24(s0)
 120:	0007c783          	lbu	a5,0(a5)
 124:	cb99                	beqz	a5,13a <strcmp+0x44>
 126:	fe843783          	ld	a5,-24(s0)
 12a:	0007c703          	lbu	a4,0(a5)
 12e:	fe043783          	ld	a5,-32(s0)
 132:	0007c783          	lbu	a5,0(a5)
 136:	fcf709e3          	beq	a4,a5,108 <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
 13a:	fe843783          	ld	a5,-24(s0)
 13e:	0007c783          	lbu	a5,0(a5)
 142:	0007871b          	sext.w	a4,a5
 146:	fe043783          	ld	a5,-32(s0)
 14a:	0007c783          	lbu	a5,0(a5)
 14e:	2781                	sext.w	a5,a5
 150:	40f707bb          	subw	a5,a4,a5
 154:	2781                	sext.w	a5,a5
}
 156:	853e                	mv	a0,a5
 158:	60e2                	ld	ra,24(sp)
 15a:	6442                	ld	s0,16(sp)
 15c:	6105                	addi	sp,sp,32
 15e:	8082                	ret

0000000000000160 <strlen>:

uint
strlen(const char *s)
{
 160:	7179                	addi	sp,sp,-48
 162:	f406                	sd	ra,40(sp)
 164:	f022                	sd	s0,32(sp)
 166:	1800                	addi	s0,sp,48
 168:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
 16c:	fe042623          	sw	zero,-20(s0)
 170:	a031                	j	17c <strlen+0x1c>
 172:	fec42783          	lw	a5,-20(s0)
 176:	2785                	addiw	a5,a5,1
 178:	fef42623          	sw	a5,-20(s0)
 17c:	fec42783          	lw	a5,-20(s0)
 180:	fd843703          	ld	a4,-40(s0)
 184:	97ba                	add	a5,a5,a4
 186:	0007c783          	lbu	a5,0(a5)
 18a:	f7e5                	bnez	a5,172 <strlen+0x12>
    ;
  return n;
 18c:	fec42783          	lw	a5,-20(s0)
}
 190:	853e                	mv	a0,a5
 192:	70a2                	ld	ra,40(sp)
 194:	7402                	ld	s0,32(sp)
 196:	6145                	addi	sp,sp,48
 198:	8082                	ret

000000000000019a <memset>:

void*
memset(void *dst, int c, uint n)
{
 19a:	7179                	addi	sp,sp,-48
 19c:	f406                	sd	ra,40(sp)
 19e:	f022                	sd	s0,32(sp)
 1a0:	1800                	addi	s0,sp,48
 1a2:	fca43c23          	sd	a0,-40(s0)
 1a6:	87ae                	mv	a5,a1
 1a8:	8732                	mv	a4,a2
 1aa:	fcf42a23          	sw	a5,-44(s0)
 1ae:	87ba                	mv	a5,a4
 1b0:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
 1b4:	fd843783          	ld	a5,-40(s0)
 1b8:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
 1bc:	fe042623          	sw	zero,-20(s0)
 1c0:	a00d                	j	1e2 <memset+0x48>
    cdst[i] = c;
 1c2:	fec42783          	lw	a5,-20(s0)
 1c6:	fe043703          	ld	a4,-32(s0)
 1ca:	97ba                	add	a5,a5,a4
 1cc:	fd442703          	lw	a4,-44(s0)
 1d0:	0ff77713          	zext.b	a4,a4
 1d4:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
 1d8:	fec42783          	lw	a5,-20(s0)
 1dc:	2785                	addiw	a5,a5,1
 1de:	fef42623          	sw	a5,-20(s0)
 1e2:	fec42783          	lw	a5,-20(s0)
 1e6:	fd042703          	lw	a4,-48(s0)
 1ea:	2701                	sext.w	a4,a4
 1ec:	fce7ebe3          	bltu	a5,a4,1c2 <memset+0x28>
  }
  return dst;
 1f0:	fd843783          	ld	a5,-40(s0)
}
 1f4:	853e                	mv	a0,a5
 1f6:	70a2                	ld	ra,40(sp)
 1f8:	7402                	ld	s0,32(sp)
 1fa:	6145                	addi	sp,sp,48
 1fc:	8082                	ret

00000000000001fe <strchr>:

char*
strchr(const char *s, char c)
{
 1fe:	1101                	addi	sp,sp,-32
 200:	ec06                	sd	ra,24(sp)
 202:	e822                	sd	s0,16(sp)
 204:	1000                	addi	s0,sp,32
 206:	fea43423          	sd	a0,-24(s0)
 20a:	87ae                	mv	a5,a1
 20c:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
 210:	a01d                	j	236 <strchr+0x38>
    if(*s == c)
 212:	fe843783          	ld	a5,-24(s0)
 216:	0007c703          	lbu	a4,0(a5)
 21a:	fe744783          	lbu	a5,-25(s0)
 21e:	0ff7f793          	zext.b	a5,a5
 222:	00e79563          	bne	a5,a4,22c <strchr+0x2e>
      return (char*)s;
 226:	fe843783          	ld	a5,-24(s0)
 22a:	a821                	j	242 <strchr+0x44>
  for(; *s; s++)
 22c:	fe843783          	ld	a5,-24(s0)
 230:	0785                	addi	a5,a5,1
 232:	fef43423          	sd	a5,-24(s0)
 236:	fe843783          	ld	a5,-24(s0)
 23a:	0007c783          	lbu	a5,0(a5)
 23e:	fbf1                	bnez	a5,212 <strchr+0x14>
  return 0;
 240:	4781                	li	a5,0
}
 242:	853e                	mv	a0,a5
 244:	60e2                	ld	ra,24(sp)
 246:	6442                	ld	s0,16(sp)
 248:	6105                	addi	sp,sp,32
 24a:	8082                	ret

000000000000024c <gets>:

char*
gets(char *buf, int max)
{
 24c:	7179                	addi	sp,sp,-48
 24e:	f406                	sd	ra,40(sp)
 250:	f022                	sd	s0,32(sp)
 252:	1800                	addi	s0,sp,48
 254:	fca43c23          	sd	a0,-40(s0)
 258:	87ae                	mv	a5,a1
 25a:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 25e:	fe042623          	sw	zero,-20(s0)
 262:	a8a1                	j	2ba <gets+0x6e>
    cc = read(0, &c, 1);
 264:	fe740793          	addi	a5,s0,-25
 268:	4605                	li	a2,1
 26a:	85be                	mv	a1,a5
 26c:	4501                	li	a0,0
 26e:	00000097          	auipc	ra,0x0
 272:	302080e7          	jalr	770(ra) # 570 <read>
 276:	87aa                	mv	a5,a0
 278:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
 27c:	fe842783          	lw	a5,-24(s0)
 280:	2781                	sext.w	a5,a5
 282:	04f05663          	blez	a5,2ce <gets+0x82>
      break;
    buf[i++] = c;
 286:	fec42783          	lw	a5,-20(s0)
 28a:	0017871b          	addiw	a4,a5,1
 28e:	fee42623          	sw	a4,-20(s0)
 292:	873e                	mv	a4,a5
 294:	fd843783          	ld	a5,-40(s0)
 298:	97ba                	add	a5,a5,a4
 29a:	fe744703          	lbu	a4,-25(s0)
 29e:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
 2a2:	fe744783          	lbu	a5,-25(s0)
 2a6:	873e                	mv	a4,a5
 2a8:	47a9                	li	a5,10
 2aa:	02f70363          	beq	a4,a5,2d0 <gets+0x84>
 2ae:	fe744783          	lbu	a5,-25(s0)
 2b2:	873e                	mv	a4,a5
 2b4:	47b5                	li	a5,13
 2b6:	00f70d63          	beq	a4,a5,2d0 <gets+0x84>
  for(i=0; i+1 < max; ){
 2ba:	fec42783          	lw	a5,-20(s0)
 2be:	2785                	addiw	a5,a5,1
 2c0:	2781                	sext.w	a5,a5
 2c2:	fd442703          	lw	a4,-44(s0)
 2c6:	2701                	sext.w	a4,a4
 2c8:	f8e7cee3          	blt	a5,a4,264 <gets+0x18>
 2cc:	a011                	j	2d0 <gets+0x84>
      break;
 2ce:	0001                	nop
      break;
  }
  buf[i] = '\0';
 2d0:	fec42783          	lw	a5,-20(s0)
 2d4:	fd843703          	ld	a4,-40(s0)
 2d8:	97ba                	add	a5,a5,a4
 2da:	00078023          	sb	zero,0(a5)
  return buf;
 2de:	fd843783          	ld	a5,-40(s0)
}
 2e2:	853e                	mv	a0,a5
 2e4:	70a2                	ld	ra,40(sp)
 2e6:	7402                	ld	s0,32(sp)
 2e8:	6145                	addi	sp,sp,48
 2ea:	8082                	ret

00000000000002ec <stat>:

int
stat(const char *n, struct stat *st)
{
 2ec:	7179                	addi	sp,sp,-48
 2ee:	f406                	sd	ra,40(sp)
 2f0:	f022                	sd	s0,32(sp)
 2f2:	1800                	addi	s0,sp,48
 2f4:	fca43c23          	sd	a0,-40(s0)
 2f8:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2fc:	4581                	li	a1,0
 2fe:	fd843503          	ld	a0,-40(s0)
 302:	00000097          	auipc	ra,0x0
 306:	296080e7          	jalr	662(ra) # 598 <open>
 30a:	87aa                	mv	a5,a0
 30c:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
 310:	fec42783          	lw	a5,-20(s0)
 314:	2781                	sext.w	a5,a5
 316:	0007d463          	bgez	a5,31e <stat+0x32>
    return -1;
 31a:	57fd                	li	a5,-1
 31c:	a035                	j	348 <stat+0x5c>
  r = fstat(fd, st);
 31e:	fec42783          	lw	a5,-20(s0)
 322:	fd043583          	ld	a1,-48(s0)
 326:	853e                	mv	a0,a5
 328:	00000097          	auipc	ra,0x0
 32c:	288080e7          	jalr	648(ra) # 5b0 <fstat>
 330:	87aa                	mv	a5,a0
 332:	fef42423          	sw	a5,-24(s0)
  close(fd);
 336:	fec42783          	lw	a5,-20(s0)
 33a:	853e                	mv	a0,a5
 33c:	00000097          	auipc	ra,0x0
 340:	244080e7          	jalr	580(ra) # 580 <close>
  return r;
 344:	fe842783          	lw	a5,-24(s0)
}
 348:	853e                	mv	a0,a5
 34a:	70a2                	ld	ra,40(sp)
 34c:	7402                	ld	s0,32(sp)
 34e:	6145                	addi	sp,sp,48
 350:	8082                	ret

0000000000000352 <atoi>:

int
atoi(const char *s)
{
 352:	7179                	addi	sp,sp,-48
 354:	f406                	sd	ra,40(sp)
 356:	f022                	sd	s0,32(sp)
 358:	1800                	addi	s0,sp,48
 35a:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
 35e:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
 362:	a81d                	j	398 <atoi+0x46>
    n = n*10 + *s++ - '0';
 364:	fec42783          	lw	a5,-20(s0)
 368:	873e                	mv	a4,a5
 36a:	87ba                	mv	a5,a4
 36c:	0027979b          	slliw	a5,a5,0x2
 370:	9fb9                	addw	a5,a5,a4
 372:	0017979b          	slliw	a5,a5,0x1
 376:	0007871b          	sext.w	a4,a5
 37a:	fd843783          	ld	a5,-40(s0)
 37e:	00178693          	addi	a3,a5,1
 382:	fcd43c23          	sd	a3,-40(s0)
 386:	0007c783          	lbu	a5,0(a5)
 38a:	2781                	sext.w	a5,a5
 38c:	9fb9                	addw	a5,a5,a4
 38e:	2781                	sext.w	a5,a5
 390:	fd07879b          	addiw	a5,a5,-48
 394:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
 398:	fd843783          	ld	a5,-40(s0)
 39c:	0007c783          	lbu	a5,0(a5)
 3a0:	873e                	mv	a4,a5
 3a2:	02f00793          	li	a5,47
 3a6:	00e7fb63          	bgeu	a5,a4,3bc <atoi+0x6a>
 3aa:	fd843783          	ld	a5,-40(s0)
 3ae:	0007c783          	lbu	a5,0(a5)
 3b2:	873e                	mv	a4,a5
 3b4:	03900793          	li	a5,57
 3b8:	fae7f6e3          	bgeu	a5,a4,364 <atoi+0x12>
  return n;
 3bc:	fec42783          	lw	a5,-20(s0)
}
 3c0:	853e                	mv	a0,a5
 3c2:	70a2                	ld	ra,40(sp)
 3c4:	7402                	ld	s0,32(sp)
 3c6:	6145                	addi	sp,sp,48
 3c8:	8082                	ret

00000000000003ca <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3ca:	7139                	addi	sp,sp,-64
 3cc:	fc06                	sd	ra,56(sp)
 3ce:	f822                	sd	s0,48(sp)
 3d0:	0080                	addi	s0,sp,64
 3d2:	fca43c23          	sd	a0,-40(s0)
 3d6:	fcb43823          	sd	a1,-48(s0)
 3da:	87b2                	mv	a5,a2
 3dc:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
 3e0:	fd843783          	ld	a5,-40(s0)
 3e4:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
 3e8:	fd043783          	ld	a5,-48(s0)
 3ec:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
 3f0:	fe043703          	ld	a4,-32(s0)
 3f4:	fe843783          	ld	a5,-24(s0)
 3f8:	02e7fc63          	bgeu	a5,a4,430 <memmove+0x66>
    while(n-- > 0)
 3fc:	a00d                	j	41e <memmove+0x54>
      *dst++ = *src++;
 3fe:	fe043703          	ld	a4,-32(s0)
 402:	00170793          	addi	a5,a4,1
 406:	fef43023          	sd	a5,-32(s0)
 40a:	fe843783          	ld	a5,-24(s0)
 40e:	00178693          	addi	a3,a5,1
 412:	fed43423          	sd	a3,-24(s0)
 416:	00074703          	lbu	a4,0(a4)
 41a:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 41e:	fcc42783          	lw	a5,-52(s0)
 422:	fff7871b          	addiw	a4,a5,-1
 426:	fce42623          	sw	a4,-52(s0)
 42a:	fcf04ae3          	bgtz	a5,3fe <memmove+0x34>
 42e:	a891                	j	482 <memmove+0xb8>
  } else {
    dst += n;
 430:	fcc42783          	lw	a5,-52(s0)
 434:	fe843703          	ld	a4,-24(s0)
 438:	97ba                	add	a5,a5,a4
 43a:	fef43423          	sd	a5,-24(s0)
    src += n;
 43e:	fcc42783          	lw	a5,-52(s0)
 442:	fe043703          	ld	a4,-32(s0)
 446:	97ba                	add	a5,a5,a4
 448:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
 44c:	a01d                	j	472 <memmove+0xa8>
      *--dst = *--src;
 44e:	fe043783          	ld	a5,-32(s0)
 452:	17fd                	addi	a5,a5,-1
 454:	fef43023          	sd	a5,-32(s0)
 458:	fe843783          	ld	a5,-24(s0)
 45c:	17fd                	addi	a5,a5,-1
 45e:	fef43423          	sd	a5,-24(s0)
 462:	fe043783          	ld	a5,-32(s0)
 466:	0007c703          	lbu	a4,0(a5)
 46a:	fe843783          	ld	a5,-24(s0)
 46e:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 472:	fcc42783          	lw	a5,-52(s0)
 476:	fff7871b          	addiw	a4,a5,-1
 47a:	fce42623          	sw	a4,-52(s0)
 47e:	fcf048e3          	bgtz	a5,44e <memmove+0x84>
  }
  return vdst;
 482:	fd843783          	ld	a5,-40(s0)
}
 486:	853e                	mv	a0,a5
 488:	70e2                	ld	ra,56(sp)
 48a:	7442                	ld	s0,48(sp)
 48c:	6121                	addi	sp,sp,64
 48e:	8082                	ret

0000000000000490 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 490:	7139                	addi	sp,sp,-64
 492:	fc06                	sd	ra,56(sp)
 494:	f822                	sd	s0,48(sp)
 496:	0080                	addi	s0,sp,64
 498:	fca43c23          	sd	a0,-40(s0)
 49c:	fcb43823          	sd	a1,-48(s0)
 4a0:	87b2                	mv	a5,a2
 4a2:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
 4a6:	fd843783          	ld	a5,-40(s0)
 4aa:	fef43423          	sd	a5,-24(s0)
 4ae:	fd043783          	ld	a5,-48(s0)
 4b2:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 4b6:	a0a1                	j	4fe <memcmp+0x6e>
    if (*p1 != *p2) {
 4b8:	fe843783          	ld	a5,-24(s0)
 4bc:	0007c703          	lbu	a4,0(a5)
 4c0:	fe043783          	ld	a5,-32(s0)
 4c4:	0007c783          	lbu	a5,0(a5)
 4c8:	02f70163          	beq	a4,a5,4ea <memcmp+0x5a>
      return *p1 - *p2;
 4cc:	fe843783          	ld	a5,-24(s0)
 4d0:	0007c783          	lbu	a5,0(a5)
 4d4:	0007871b          	sext.w	a4,a5
 4d8:	fe043783          	ld	a5,-32(s0)
 4dc:	0007c783          	lbu	a5,0(a5)
 4e0:	2781                	sext.w	a5,a5
 4e2:	40f707bb          	subw	a5,a4,a5
 4e6:	2781                	sext.w	a5,a5
 4e8:	a01d                	j	50e <memcmp+0x7e>
    }
    p1++;
 4ea:	fe843783          	ld	a5,-24(s0)
 4ee:	0785                	addi	a5,a5,1
 4f0:	fef43423          	sd	a5,-24(s0)
    p2++;
 4f4:	fe043783          	ld	a5,-32(s0)
 4f8:	0785                	addi	a5,a5,1
 4fa:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 4fe:	fcc42783          	lw	a5,-52(s0)
 502:	fff7871b          	addiw	a4,a5,-1
 506:	fce42623          	sw	a4,-52(s0)
 50a:	f7dd                	bnez	a5,4b8 <memcmp+0x28>
  }
  return 0;
 50c:	4781                	li	a5,0
}
 50e:	853e                	mv	a0,a5
 510:	70e2                	ld	ra,56(sp)
 512:	7442                	ld	s0,48(sp)
 514:	6121                	addi	sp,sp,64
 516:	8082                	ret

0000000000000518 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 518:	7179                	addi	sp,sp,-48
 51a:	f406                	sd	ra,40(sp)
 51c:	f022                	sd	s0,32(sp)
 51e:	1800                	addi	s0,sp,48
 520:	fea43423          	sd	a0,-24(s0)
 524:	feb43023          	sd	a1,-32(s0)
 528:	87b2                	mv	a5,a2
 52a:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
 52e:	fdc42783          	lw	a5,-36(s0)
 532:	863e                	mv	a2,a5
 534:	fe043583          	ld	a1,-32(s0)
 538:	fe843503          	ld	a0,-24(s0)
 53c:	00000097          	auipc	ra,0x0
 540:	e8e080e7          	jalr	-370(ra) # 3ca <memmove>
 544:	87aa                	mv	a5,a0
}
 546:	853e                	mv	a0,a5
 548:	70a2                	ld	ra,40(sp)
 54a:	7402                	ld	s0,32(sp)
 54c:	6145                	addi	sp,sp,48
 54e:	8082                	ret

0000000000000550 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 550:	4885                	li	a7,1
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <exit>:
.global exit
exit:
 li a7, SYS_exit
 558:	4889                	li	a7,2
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <wait>:
.global wait
wait:
 li a7, SYS_wait
 560:	488d                	li	a7,3
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 568:	4891                	li	a7,4
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <read>:
.global read
read:
 li a7, SYS_read
 570:	4895                	li	a7,5
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <write>:
.global write
write:
 li a7, SYS_write
 578:	48c1                	li	a7,16
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <close>:
.global close
close:
 li a7, SYS_close
 580:	48d5                	li	a7,21
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <kill>:
.global kill
kill:
 li a7, SYS_kill
 588:	4899                	li	a7,6
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <exec>:
.global exec
exec:
 li a7, SYS_exec
 590:	489d                	li	a7,7
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <open>:
.global open
open:
 li a7, SYS_open
 598:	48bd                	li	a7,15
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5a0:	48c5                	li	a7,17
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5a8:	48c9                	li	a7,18
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5b0:	48a1                	li	a7,8
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <link>:
.global link
link:
 li a7, SYS_link
 5b8:	48cd                	li	a7,19
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5c0:	48d1                	li	a7,20
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5c8:	48a5                	li	a7,9
 ecall
 5ca:	00000073          	ecall
 ret
 5ce:	8082                	ret

00000000000005d0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5d0:	48a9                	li	a7,10
 ecall
 5d2:	00000073          	ecall
 ret
 5d6:	8082                	ret

00000000000005d8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5d8:	48ad                	li	a7,11
 ecall
 5da:	00000073          	ecall
 ret
 5de:	8082                	ret

00000000000005e0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5e0:	48b1                	li	a7,12
 ecall
 5e2:	00000073          	ecall
 ret
 5e6:	8082                	ret

00000000000005e8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5e8:	48b5                	li	a7,13
 ecall
 5ea:	00000073          	ecall
 ret
 5ee:	8082                	ret

00000000000005f0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5f0:	48b9                	li	a7,14
 ecall
 5f2:	00000073          	ecall
 ret
 5f6:	8082                	ret

00000000000005f8 <ps>:
.global ps
ps:
 li a7, SYS_ps
 5f8:	48d9                	li	a7,22
 ecall
 5fa:	00000073          	ecall
 ret
 5fe:	8082                	ret

0000000000000600 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 600:	1101                	addi	sp,sp,-32
 602:	ec06                	sd	ra,24(sp)
 604:	e822                	sd	s0,16(sp)
 606:	1000                	addi	s0,sp,32
 608:	87aa                	mv	a5,a0
 60a:	872e                	mv	a4,a1
 60c:	fef42623          	sw	a5,-20(s0)
 610:	87ba                	mv	a5,a4
 612:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 616:	feb40713          	addi	a4,s0,-21
 61a:	fec42783          	lw	a5,-20(s0)
 61e:	4605                	li	a2,1
 620:	85ba                	mv	a1,a4
 622:	853e                	mv	a0,a5
 624:	00000097          	auipc	ra,0x0
 628:	f54080e7          	jalr	-172(ra) # 578 <write>
}
 62c:	0001                	nop
 62e:	60e2                	ld	ra,24(sp)
 630:	6442                	ld	s0,16(sp)
 632:	6105                	addi	sp,sp,32
 634:	8082                	ret

0000000000000636 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 636:	7139                	addi	sp,sp,-64
 638:	fc06                	sd	ra,56(sp)
 63a:	f822                	sd	s0,48(sp)
 63c:	0080                	addi	s0,sp,64
 63e:	87aa                	mv	a5,a0
 640:	8736                	mv	a4,a3
 642:	fcf42623          	sw	a5,-52(s0)
 646:	87ae                	mv	a5,a1
 648:	fcf42423          	sw	a5,-56(s0)
 64c:	87b2                	mv	a5,a2
 64e:	fcf42223          	sw	a5,-60(s0)
 652:	87ba                	mv	a5,a4
 654:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 658:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 65c:	fc042783          	lw	a5,-64(s0)
 660:	2781                	sext.w	a5,a5
 662:	c38d                	beqz	a5,684 <printint+0x4e>
 664:	fc842783          	lw	a5,-56(s0)
 668:	2781                	sext.w	a5,a5
 66a:	0007dd63          	bgez	a5,684 <printint+0x4e>
    neg = 1;
 66e:	4785                	li	a5,1
 670:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 674:	fc842783          	lw	a5,-56(s0)
 678:	40f007bb          	negw	a5,a5
 67c:	2781                	sext.w	a5,a5
 67e:	fef42223          	sw	a5,-28(s0)
 682:	a029                	j	68c <printint+0x56>
  } else {
    x = xx;
 684:	fc842783          	lw	a5,-56(s0)
 688:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 68c:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 690:	fc442783          	lw	a5,-60(s0)
 694:	fe442703          	lw	a4,-28(s0)
 698:	02f777bb          	remuw	a5,a4,a5
 69c:	0007871b          	sext.w	a4,a5
 6a0:	fec42783          	lw	a5,-20(s0)
 6a4:	0017869b          	addiw	a3,a5,1
 6a8:	fed42623          	sw	a3,-20(s0)
 6ac:	00001697          	auipc	a3,0x1
 6b0:	95468693          	addi	a3,a3,-1708 # 1000 <digits>
 6b4:	1702                	slli	a4,a4,0x20
 6b6:	9301                	srli	a4,a4,0x20
 6b8:	9736                	add	a4,a4,a3
 6ba:	00074703          	lbu	a4,0(a4)
 6be:	17c1                	addi	a5,a5,-16
 6c0:	97a2                	add	a5,a5,s0
 6c2:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 6c6:	fc442783          	lw	a5,-60(s0)
 6ca:	fe442703          	lw	a4,-28(s0)
 6ce:	02f757bb          	divuw	a5,a4,a5
 6d2:	fef42223          	sw	a5,-28(s0)
 6d6:	fe442783          	lw	a5,-28(s0)
 6da:	2781                	sext.w	a5,a5
 6dc:	fbd5                	bnez	a5,690 <printint+0x5a>
  if(neg)
 6de:	fe842783          	lw	a5,-24(s0)
 6e2:	2781                	sext.w	a5,a5
 6e4:	cf85                	beqz	a5,71c <printint+0xe6>
    buf[i++] = '-';
 6e6:	fec42783          	lw	a5,-20(s0)
 6ea:	0017871b          	addiw	a4,a5,1
 6ee:	fee42623          	sw	a4,-20(s0)
 6f2:	17c1                	addi	a5,a5,-16
 6f4:	97a2                	add	a5,a5,s0
 6f6:	02d00713          	li	a4,45
 6fa:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 6fe:	a839                	j	71c <printint+0xe6>
    putc(fd, buf[i]);
 700:	fec42783          	lw	a5,-20(s0)
 704:	17c1                	addi	a5,a5,-16
 706:	97a2                	add	a5,a5,s0
 708:	fe07c703          	lbu	a4,-32(a5)
 70c:	fcc42783          	lw	a5,-52(s0)
 710:	85ba                	mv	a1,a4
 712:	853e                	mv	a0,a5
 714:	00000097          	auipc	ra,0x0
 718:	eec080e7          	jalr	-276(ra) # 600 <putc>
  while(--i >= 0)
 71c:	fec42783          	lw	a5,-20(s0)
 720:	37fd                	addiw	a5,a5,-1
 722:	fef42623          	sw	a5,-20(s0)
 726:	fec42783          	lw	a5,-20(s0)
 72a:	2781                	sext.w	a5,a5
 72c:	fc07dae3          	bgez	a5,700 <printint+0xca>
}
 730:	0001                	nop
 732:	0001                	nop
 734:	70e2                	ld	ra,56(sp)
 736:	7442                	ld	s0,48(sp)
 738:	6121                	addi	sp,sp,64
 73a:	8082                	ret

000000000000073c <printptr>:

static void
printptr(int fd, uint64 x) {
 73c:	7179                	addi	sp,sp,-48
 73e:	f406                	sd	ra,40(sp)
 740:	f022                	sd	s0,32(sp)
 742:	1800                	addi	s0,sp,48
 744:	87aa                	mv	a5,a0
 746:	fcb43823          	sd	a1,-48(s0)
 74a:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 74e:	fdc42783          	lw	a5,-36(s0)
 752:	03000593          	li	a1,48
 756:	853e                	mv	a0,a5
 758:	00000097          	auipc	ra,0x0
 75c:	ea8080e7          	jalr	-344(ra) # 600 <putc>
  putc(fd, 'x');
 760:	fdc42783          	lw	a5,-36(s0)
 764:	07800593          	li	a1,120
 768:	853e                	mv	a0,a5
 76a:	00000097          	auipc	ra,0x0
 76e:	e96080e7          	jalr	-362(ra) # 600 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 772:	fe042623          	sw	zero,-20(s0)
 776:	a82d                	j	7b0 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 778:	fd043783          	ld	a5,-48(s0)
 77c:	93f1                	srli	a5,a5,0x3c
 77e:	00001717          	auipc	a4,0x1
 782:	88270713          	addi	a4,a4,-1918 # 1000 <digits>
 786:	97ba                	add	a5,a5,a4
 788:	0007c703          	lbu	a4,0(a5)
 78c:	fdc42783          	lw	a5,-36(s0)
 790:	85ba                	mv	a1,a4
 792:	853e                	mv	a0,a5
 794:	00000097          	auipc	ra,0x0
 798:	e6c080e7          	jalr	-404(ra) # 600 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 79c:	fec42783          	lw	a5,-20(s0)
 7a0:	2785                	addiw	a5,a5,1
 7a2:	fef42623          	sw	a5,-20(s0)
 7a6:	fd043783          	ld	a5,-48(s0)
 7aa:	0792                	slli	a5,a5,0x4
 7ac:	fcf43823          	sd	a5,-48(s0)
 7b0:	fec42703          	lw	a4,-20(s0)
 7b4:	47bd                	li	a5,15
 7b6:	fce7f1e3          	bgeu	a5,a4,778 <printptr+0x3c>
}
 7ba:	0001                	nop
 7bc:	0001                	nop
 7be:	70a2                	ld	ra,40(sp)
 7c0:	7402                	ld	s0,32(sp)
 7c2:	6145                	addi	sp,sp,48
 7c4:	8082                	ret

00000000000007c6 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7c6:	715d                	addi	sp,sp,-80
 7c8:	e486                	sd	ra,72(sp)
 7ca:	e0a2                	sd	s0,64(sp)
 7cc:	0880                	addi	s0,sp,80
 7ce:	87aa                	mv	a5,a0
 7d0:	fcb43023          	sd	a1,-64(s0)
 7d4:	fac43c23          	sd	a2,-72(s0)
 7d8:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 7dc:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 7e0:	fe042223          	sw	zero,-28(s0)
 7e4:	a42d                	j	a0e <vprintf+0x248>
    c = fmt[i] & 0xff;
 7e6:	fe442783          	lw	a5,-28(s0)
 7ea:	fc043703          	ld	a4,-64(s0)
 7ee:	97ba                	add	a5,a5,a4
 7f0:	0007c783          	lbu	a5,0(a5)
 7f4:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 7f8:	fe042783          	lw	a5,-32(s0)
 7fc:	2781                	sext.w	a5,a5
 7fe:	eb9d                	bnez	a5,834 <vprintf+0x6e>
      if(c == '%'){
 800:	fdc42783          	lw	a5,-36(s0)
 804:	0007871b          	sext.w	a4,a5
 808:	02500793          	li	a5,37
 80c:	00f71763          	bne	a4,a5,81a <vprintf+0x54>
        state = '%';
 810:	02500793          	li	a5,37
 814:	fef42023          	sw	a5,-32(s0)
 818:	a2f5                	j	a04 <vprintf+0x23e>
      } else {
        putc(fd, c);
 81a:	fdc42783          	lw	a5,-36(s0)
 81e:	0ff7f713          	zext.b	a4,a5
 822:	fcc42783          	lw	a5,-52(s0)
 826:	85ba                	mv	a1,a4
 828:	853e                	mv	a0,a5
 82a:	00000097          	auipc	ra,0x0
 82e:	dd6080e7          	jalr	-554(ra) # 600 <putc>
 832:	aac9                	j	a04 <vprintf+0x23e>
      }
    } else if(state == '%'){
 834:	fe042783          	lw	a5,-32(s0)
 838:	0007871b          	sext.w	a4,a5
 83c:	02500793          	li	a5,37
 840:	1cf71263          	bne	a4,a5,a04 <vprintf+0x23e>
      if(c == 'd'){
 844:	fdc42783          	lw	a5,-36(s0)
 848:	0007871b          	sext.w	a4,a5
 84c:	06400793          	li	a5,100
 850:	02f71463          	bne	a4,a5,878 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 854:	fb843783          	ld	a5,-72(s0)
 858:	00878713          	addi	a4,a5,8
 85c:	fae43c23          	sd	a4,-72(s0)
 860:	4398                	lw	a4,0(a5)
 862:	fcc42783          	lw	a5,-52(s0)
 866:	4685                	li	a3,1
 868:	4629                	li	a2,10
 86a:	85ba                	mv	a1,a4
 86c:	853e                	mv	a0,a5
 86e:	00000097          	auipc	ra,0x0
 872:	dc8080e7          	jalr	-568(ra) # 636 <printint>
 876:	a269                	j	a00 <vprintf+0x23a>
      } else if(c == 'l') {
 878:	fdc42783          	lw	a5,-36(s0)
 87c:	0007871b          	sext.w	a4,a5
 880:	06c00793          	li	a5,108
 884:	02f71663          	bne	a4,a5,8b0 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 888:	fb843783          	ld	a5,-72(s0)
 88c:	00878713          	addi	a4,a5,8
 890:	fae43c23          	sd	a4,-72(s0)
 894:	639c                	ld	a5,0(a5)
 896:	0007871b          	sext.w	a4,a5
 89a:	fcc42783          	lw	a5,-52(s0)
 89e:	4681                	li	a3,0
 8a0:	4629                	li	a2,10
 8a2:	85ba                	mv	a1,a4
 8a4:	853e                	mv	a0,a5
 8a6:	00000097          	auipc	ra,0x0
 8aa:	d90080e7          	jalr	-624(ra) # 636 <printint>
 8ae:	aa89                	j	a00 <vprintf+0x23a>
      } else if(c == 'x') {
 8b0:	fdc42783          	lw	a5,-36(s0)
 8b4:	0007871b          	sext.w	a4,a5
 8b8:	07800793          	li	a5,120
 8bc:	02f71463          	bne	a4,a5,8e4 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 8c0:	fb843783          	ld	a5,-72(s0)
 8c4:	00878713          	addi	a4,a5,8
 8c8:	fae43c23          	sd	a4,-72(s0)
 8cc:	4398                	lw	a4,0(a5)
 8ce:	fcc42783          	lw	a5,-52(s0)
 8d2:	4681                	li	a3,0
 8d4:	4641                	li	a2,16
 8d6:	85ba                	mv	a1,a4
 8d8:	853e                	mv	a0,a5
 8da:	00000097          	auipc	ra,0x0
 8de:	d5c080e7          	jalr	-676(ra) # 636 <printint>
 8e2:	aa39                	j	a00 <vprintf+0x23a>
      } else if(c == 'p') {
 8e4:	fdc42783          	lw	a5,-36(s0)
 8e8:	0007871b          	sext.w	a4,a5
 8ec:	07000793          	li	a5,112
 8f0:	02f71263          	bne	a4,a5,914 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 8f4:	fb843783          	ld	a5,-72(s0)
 8f8:	00878713          	addi	a4,a5,8
 8fc:	fae43c23          	sd	a4,-72(s0)
 900:	6398                	ld	a4,0(a5)
 902:	fcc42783          	lw	a5,-52(s0)
 906:	85ba                	mv	a1,a4
 908:	853e                	mv	a0,a5
 90a:	00000097          	auipc	ra,0x0
 90e:	e32080e7          	jalr	-462(ra) # 73c <printptr>
 912:	a0fd                	j	a00 <vprintf+0x23a>
      } else if(c == 's'){
 914:	fdc42783          	lw	a5,-36(s0)
 918:	0007871b          	sext.w	a4,a5
 91c:	07300793          	li	a5,115
 920:	04f71c63          	bne	a4,a5,978 <vprintf+0x1b2>
        s = va_arg(ap, char*);
 924:	fb843783          	ld	a5,-72(s0)
 928:	00878713          	addi	a4,a5,8
 92c:	fae43c23          	sd	a4,-72(s0)
 930:	639c                	ld	a5,0(a5)
 932:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 936:	fe843783          	ld	a5,-24(s0)
 93a:	eb8d                	bnez	a5,96c <vprintf+0x1a6>
          s = "(null)";
 93c:	00000797          	auipc	a5,0x0
 940:	49c78793          	addi	a5,a5,1180 # dd8 <malloc+0x160>
 944:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 948:	a015                	j	96c <vprintf+0x1a6>
          putc(fd, *s);
 94a:	fe843783          	ld	a5,-24(s0)
 94e:	0007c703          	lbu	a4,0(a5)
 952:	fcc42783          	lw	a5,-52(s0)
 956:	85ba                	mv	a1,a4
 958:	853e                	mv	a0,a5
 95a:	00000097          	auipc	ra,0x0
 95e:	ca6080e7          	jalr	-858(ra) # 600 <putc>
          s++;
 962:	fe843783          	ld	a5,-24(s0)
 966:	0785                	addi	a5,a5,1
 968:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 96c:	fe843783          	ld	a5,-24(s0)
 970:	0007c783          	lbu	a5,0(a5)
 974:	fbf9                	bnez	a5,94a <vprintf+0x184>
 976:	a069                	j	a00 <vprintf+0x23a>
        }
      } else if(c == 'c'){
 978:	fdc42783          	lw	a5,-36(s0)
 97c:	0007871b          	sext.w	a4,a5
 980:	06300793          	li	a5,99
 984:	02f71463          	bne	a4,a5,9ac <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 988:	fb843783          	ld	a5,-72(s0)
 98c:	00878713          	addi	a4,a5,8
 990:	fae43c23          	sd	a4,-72(s0)
 994:	439c                	lw	a5,0(a5)
 996:	0ff7f713          	zext.b	a4,a5
 99a:	fcc42783          	lw	a5,-52(s0)
 99e:	85ba                	mv	a1,a4
 9a0:	853e                	mv	a0,a5
 9a2:	00000097          	auipc	ra,0x0
 9a6:	c5e080e7          	jalr	-930(ra) # 600 <putc>
 9aa:	a899                	j	a00 <vprintf+0x23a>
      } else if(c == '%'){
 9ac:	fdc42783          	lw	a5,-36(s0)
 9b0:	0007871b          	sext.w	a4,a5
 9b4:	02500793          	li	a5,37
 9b8:	00f71f63          	bne	a4,a5,9d6 <vprintf+0x210>
        putc(fd, c);
 9bc:	fdc42783          	lw	a5,-36(s0)
 9c0:	0ff7f713          	zext.b	a4,a5
 9c4:	fcc42783          	lw	a5,-52(s0)
 9c8:	85ba                	mv	a1,a4
 9ca:	853e                	mv	a0,a5
 9cc:	00000097          	auipc	ra,0x0
 9d0:	c34080e7          	jalr	-972(ra) # 600 <putc>
 9d4:	a035                	j	a00 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9d6:	fcc42783          	lw	a5,-52(s0)
 9da:	02500593          	li	a1,37
 9de:	853e                	mv	a0,a5
 9e0:	00000097          	auipc	ra,0x0
 9e4:	c20080e7          	jalr	-992(ra) # 600 <putc>
        putc(fd, c);
 9e8:	fdc42783          	lw	a5,-36(s0)
 9ec:	0ff7f713          	zext.b	a4,a5
 9f0:	fcc42783          	lw	a5,-52(s0)
 9f4:	85ba                	mv	a1,a4
 9f6:	853e                	mv	a0,a5
 9f8:	00000097          	auipc	ra,0x0
 9fc:	c08080e7          	jalr	-1016(ra) # 600 <putc>
      }
      state = 0;
 a00:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 a04:	fe442783          	lw	a5,-28(s0)
 a08:	2785                	addiw	a5,a5,1
 a0a:	fef42223          	sw	a5,-28(s0)
 a0e:	fe442783          	lw	a5,-28(s0)
 a12:	fc043703          	ld	a4,-64(s0)
 a16:	97ba                	add	a5,a5,a4
 a18:	0007c783          	lbu	a5,0(a5)
 a1c:	dc0795e3          	bnez	a5,7e6 <vprintf+0x20>
    }
  }
}
 a20:	0001                	nop
 a22:	0001                	nop
 a24:	60a6                	ld	ra,72(sp)
 a26:	6406                	ld	s0,64(sp)
 a28:	6161                	addi	sp,sp,80
 a2a:	8082                	ret

0000000000000a2c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a2c:	7159                	addi	sp,sp,-112
 a2e:	fc06                	sd	ra,56(sp)
 a30:	f822                	sd	s0,48(sp)
 a32:	0080                	addi	s0,sp,64
 a34:	fcb43823          	sd	a1,-48(s0)
 a38:	e010                	sd	a2,0(s0)
 a3a:	e414                	sd	a3,8(s0)
 a3c:	e818                	sd	a4,16(s0)
 a3e:	ec1c                	sd	a5,24(s0)
 a40:	03043023          	sd	a6,32(s0)
 a44:	03143423          	sd	a7,40(s0)
 a48:	87aa                	mv	a5,a0
 a4a:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 a4e:	03040793          	addi	a5,s0,48
 a52:	fcf43423          	sd	a5,-56(s0)
 a56:	fc843783          	ld	a5,-56(s0)
 a5a:	fd078793          	addi	a5,a5,-48
 a5e:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 a62:	fe843703          	ld	a4,-24(s0)
 a66:	fdc42783          	lw	a5,-36(s0)
 a6a:	863a                	mv	a2,a4
 a6c:	fd043583          	ld	a1,-48(s0)
 a70:	853e                	mv	a0,a5
 a72:	00000097          	auipc	ra,0x0
 a76:	d54080e7          	jalr	-684(ra) # 7c6 <vprintf>
}
 a7a:	0001                	nop
 a7c:	70e2                	ld	ra,56(sp)
 a7e:	7442                	ld	s0,48(sp)
 a80:	6165                	addi	sp,sp,112
 a82:	8082                	ret

0000000000000a84 <printf>:

void
printf(const char *fmt, ...)
{
 a84:	7159                	addi	sp,sp,-112
 a86:	f406                	sd	ra,40(sp)
 a88:	f022                	sd	s0,32(sp)
 a8a:	1800                	addi	s0,sp,48
 a8c:	fca43c23          	sd	a0,-40(s0)
 a90:	e40c                	sd	a1,8(s0)
 a92:	e810                	sd	a2,16(s0)
 a94:	ec14                	sd	a3,24(s0)
 a96:	f018                	sd	a4,32(s0)
 a98:	f41c                	sd	a5,40(s0)
 a9a:	03043823          	sd	a6,48(s0)
 a9e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 aa2:	04040793          	addi	a5,s0,64
 aa6:	fcf43823          	sd	a5,-48(s0)
 aaa:	fd043783          	ld	a5,-48(s0)
 aae:	fc878793          	addi	a5,a5,-56
 ab2:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 ab6:	fe843783          	ld	a5,-24(s0)
 aba:	863e                	mv	a2,a5
 abc:	fd843583          	ld	a1,-40(s0)
 ac0:	4505                	li	a0,1
 ac2:	00000097          	auipc	ra,0x0
 ac6:	d04080e7          	jalr	-764(ra) # 7c6 <vprintf>
}
 aca:	0001                	nop
 acc:	70a2                	ld	ra,40(sp)
 ace:	7402                	ld	s0,32(sp)
 ad0:	6165                	addi	sp,sp,112
 ad2:	8082                	ret

0000000000000ad4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ad4:	7179                	addi	sp,sp,-48
 ad6:	f406                	sd	ra,40(sp)
 ad8:	f022                	sd	s0,32(sp)
 ada:	1800                	addi	s0,sp,48
 adc:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 ae0:	fd843783          	ld	a5,-40(s0)
 ae4:	17c1                	addi	a5,a5,-16
 ae6:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 aea:	00000797          	auipc	a5,0x0
 aee:	54678793          	addi	a5,a5,1350 # 1030 <freep>
 af2:	639c                	ld	a5,0(a5)
 af4:	fef43423          	sd	a5,-24(s0)
 af8:	a815                	j	b2c <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 afa:	fe843783          	ld	a5,-24(s0)
 afe:	639c                	ld	a5,0(a5)
 b00:	fe843703          	ld	a4,-24(s0)
 b04:	00f76f63          	bltu	a4,a5,b22 <free+0x4e>
 b08:	fe043703          	ld	a4,-32(s0)
 b0c:	fe843783          	ld	a5,-24(s0)
 b10:	02e7eb63          	bltu	a5,a4,b46 <free+0x72>
 b14:	fe843783          	ld	a5,-24(s0)
 b18:	639c                	ld	a5,0(a5)
 b1a:	fe043703          	ld	a4,-32(s0)
 b1e:	02f76463          	bltu	a4,a5,b46 <free+0x72>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b22:	fe843783          	ld	a5,-24(s0)
 b26:	639c                	ld	a5,0(a5)
 b28:	fef43423          	sd	a5,-24(s0)
 b2c:	fe043703          	ld	a4,-32(s0)
 b30:	fe843783          	ld	a5,-24(s0)
 b34:	fce7f3e3          	bgeu	a5,a4,afa <free+0x26>
 b38:	fe843783          	ld	a5,-24(s0)
 b3c:	639c                	ld	a5,0(a5)
 b3e:	fe043703          	ld	a4,-32(s0)
 b42:	faf77ce3          	bgeu	a4,a5,afa <free+0x26>
      break;
  if(bp + bp->s.size == p->s.ptr){
 b46:	fe043783          	ld	a5,-32(s0)
 b4a:	479c                	lw	a5,8(a5)
 b4c:	1782                	slli	a5,a5,0x20
 b4e:	9381                	srli	a5,a5,0x20
 b50:	0792                	slli	a5,a5,0x4
 b52:	fe043703          	ld	a4,-32(s0)
 b56:	973e                	add	a4,a4,a5
 b58:	fe843783          	ld	a5,-24(s0)
 b5c:	639c                	ld	a5,0(a5)
 b5e:	02f71763          	bne	a4,a5,b8c <free+0xb8>
    bp->s.size += p->s.ptr->s.size;
 b62:	fe043783          	ld	a5,-32(s0)
 b66:	4798                	lw	a4,8(a5)
 b68:	fe843783          	ld	a5,-24(s0)
 b6c:	639c                	ld	a5,0(a5)
 b6e:	479c                	lw	a5,8(a5)
 b70:	9fb9                	addw	a5,a5,a4
 b72:	0007871b          	sext.w	a4,a5
 b76:	fe043783          	ld	a5,-32(s0)
 b7a:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 b7c:	fe843783          	ld	a5,-24(s0)
 b80:	639c                	ld	a5,0(a5)
 b82:	6398                	ld	a4,0(a5)
 b84:	fe043783          	ld	a5,-32(s0)
 b88:	e398                	sd	a4,0(a5)
 b8a:	a039                	j	b98 <free+0xc4>
  } else
    bp->s.ptr = p->s.ptr;
 b8c:	fe843783          	ld	a5,-24(s0)
 b90:	6398                	ld	a4,0(a5)
 b92:	fe043783          	ld	a5,-32(s0)
 b96:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 b98:	fe843783          	ld	a5,-24(s0)
 b9c:	479c                	lw	a5,8(a5)
 b9e:	1782                	slli	a5,a5,0x20
 ba0:	9381                	srli	a5,a5,0x20
 ba2:	0792                	slli	a5,a5,0x4
 ba4:	fe843703          	ld	a4,-24(s0)
 ba8:	97ba                	add	a5,a5,a4
 baa:	fe043703          	ld	a4,-32(s0)
 bae:	02f71563          	bne	a4,a5,bd8 <free+0x104>
    p->s.size += bp->s.size;
 bb2:	fe843783          	ld	a5,-24(s0)
 bb6:	4798                	lw	a4,8(a5)
 bb8:	fe043783          	ld	a5,-32(s0)
 bbc:	479c                	lw	a5,8(a5)
 bbe:	9fb9                	addw	a5,a5,a4
 bc0:	0007871b          	sext.w	a4,a5
 bc4:	fe843783          	ld	a5,-24(s0)
 bc8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 bca:	fe043783          	ld	a5,-32(s0)
 bce:	6398                	ld	a4,0(a5)
 bd0:	fe843783          	ld	a5,-24(s0)
 bd4:	e398                	sd	a4,0(a5)
 bd6:	a031                	j	be2 <free+0x10e>
  } else
    p->s.ptr = bp;
 bd8:	fe843783          	ld	a5,-24(s0)
 bdc:	fe043703          	ld	a4,-32(s0)
 be0:	e398                	sd	a4,0(a5)
  freep = p;
 be2:	00000797          	auipc	a5,0x0
 be6:	44e78793          	addi	a5,a5,1102 # 1030 <freep>
 bea:	fe843703          	ld	a4,-24(s0)
 bee:	e398                	sd	a4,0(a5)
}
 bf0:	0001                	nop
 bf2:	70a2                	ld	ra,40(sp)
 bf4:	7402                	ld	s0,32(sp)
 bf6:	6145                	addi	sp,sp,48
 bf8:	8082                	ret

0000000000000bfa <morecore>:

static Header*
morecore(uint nu)
{
 bfa:	7179                	addi	sp,sp,-48
 bfc:	f406                	sd	ra,40(sp)
 bfe:	f022                	sd	s0,32(sp)
 c00:	1800                	addi	s0,sp,48
 c02:	87aa                	mv	a5,a0
 c04:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 c08:	fdc42783          	lw	a5,-36(s0)
 c0c:	0007871b          	sext.w	a4,a5
 c10:	6785                	lui	a5,0x1
 c12:	00f77563          	bgeu	a4,a5,c1c <morecore+0x22>
    nu = 4096;
 c16:	6785                	lui	a5,0x1
 c18:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 c1c:	fdc42783          	lw	a5,-36(s0)
 c20:	0047979b          	slliw	a5,a5,0x4
 c24:	2781                	sext.w	a5,a5
 c26:	853e                	mv	a0,a5
 c28:	00000097          	auipc	ra,0x0
 c2c:	9b8080e7          	jalr	-1608(ra) # 5e0 <sbrk>
 c30:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 c34:	fe843703          	ld	a4,-24(s0)
 c38:	57fd                	li	a5,-1
 c3a:	00f71463          	bne	a4,a5,c42 <morecore+0x48>
    return 0;
 c3e:	4781                	li	a5,0
 c40:	a03d                	j	c6e <morecore+0x74>
  hp = (Header*)p;
 c42:	fe843783          	ld	a5,-24(s0)
 c46:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 c4a:	fe043783          	ld	a5,-32(s0)
 c4e:	fdc42703          	lw	a4,-36(s0)
 c52:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 c54:	fe043783          	ld	a5,-32(s0)
 c58:	07c1                	addi	a5,a5,16 # 1010 <digits+0x10>
 c5a:	853e                	mv	a0,a5
 c5c:	00000097          	auipc	ra,0x0
 c60:	e78080e7          	jalr	-392(ra) # ad4 <free>
  return freep;
 c64:	00000797          	auipc	a5,0x0
 c68:	3cc78793          	addi	a5,a5,972 # 1030 <freep>
 c6c:	639c                	ld	a5,0(a5)
}
 c6e:	853e                	mv	a0,a5
 c70:	70a2                	ld	ra,40(sp)
 c72:	7402                	ld	s0,32(sp)
 c74:	6145                	addi	sp,sp,48
 c76:	8082                	ret

0000000000000c78 <malloc>:

void*
malloc(uint nbytes)
{
 c78:	7139                	addi	sp,sp,-64
 c7a:	fc06                	sd	ra,56(sp)
 c7c:	f822                	sd	s0,48(sp)
 c7e:	0080                	addi	s0,sp,64
 c80:	87aa                	mv	a5,a0
 c82:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c86:	fcc46783          	lwu	a5,-52(s0)
 c8a:	07bd                	addi	a5,a5,15
 c8c:	8391                	srli	a5,a5,0x4
 c8e:	2781                	sext.w	a5,a5
 c90:	2785                	addiw	a5,a5,1
 c92:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 c96:	00000797          	auipc	a5,0x0
 c9a:	39a78793          	addi	a5,a5,922 # 1030 <freep>
 c9e:	639c                	ld	a5,0(a5)
 ca0:	fef43023          	sd	a5,-32(s0)
 ca4:	fe043783          	ld	a5,-32(s0)
 ca8:	ef95                	bnez	a5,ce4 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 caa:	00000797          	auipc	a5,0x0
 cae:	37678793          	addi	a5,a5,886 # 1020 <base>
 cb2:	fef43023          	sd	a5,-32(s0)
 cb6:	00000797          	auipc	a5,0x0
 cba:	37a78793          	addi	a5,a5,890 # 1030 <freep>
 cbe:	fe043703          	ld	a4,-32(s0)
 cc2:	e398                	sd	a4,0(a5)
 cc4:	00000797          	auipc	a5,0x0
 cc8:	36c78793          	addi	a5,a5,876 # 1030 <freep>
 ccc:	6398                	ld	a4,0(a5)
 cce:	00000797          	auipc	a5,0x0
 cd2:	35278793          	addi	a5,a5,850 # 1020 <base>
 cd6:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 cd8:	00000797          	auipc	a5,0x0
 cdc:	34878793          	addi	a5,a5,840 # 1020 <base>
 ce0:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ce4:	fe043783          	ld	a5,-32(s0)
 ce8:	639c                	ld	a5,0(a5)
 cea:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 cee:	fe843783          	ld	a5,-24(s0)
 cf2:	479c                	lw	a5,8(a5)
 cf4:	fdc42703          	lw	a4,-36(s0)
 cf8:	2701                	sext.w	a4,a4
 cfa:	06e7e763          	bltu	a5,a4,d68 <malloc+0xf0>
      if(p->s.size == nunits)
 cfe:	fe843783          	ld	a5,-24(s0)
 d02:	479c                	lw	a5,8(a5)
 d04:	fdc42703          	lw	a4,-36(s0)
 d08:	2701                	sext.w	a4,a4
 d0a:	00f71963          	bne	a4,a5,d1c <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 d0e:	fe843783          	ld	a5,-24(s0)
 d12:	6398                	ld	a4,0(a5)
 d14:	fe043783          	ld	a5,-32(s0)
 d18:	e398                	sd	a4,0(a5)
 d1a:	a825                	j	d52 <malloc+0xda>
      else {
        p->s.size -= nunits;
 d1c:	fe843783          	ld	a5,-24(s0)
 d20:	479c                	lw	a5,8(a5)
 d22:	fdc42703          	lw	a4,-36(s0)
 d26:	9f99                	subw	a5,a5,a4
 d28:	0007871b          	sext.w	a4,a5
 d2c:	fe843783          	ld	a5,-24(s0)
 d30:	c798                	sw	a4,8(a5)
        p += p->s.size;
 d32:	fe843783          	ld	a5,-24(s0)
 d36:	479c                	lw	a5,8(a5)
 d38:	1782                	slli	a5,a5,0x20
 d3a:	9381                	srli	a5,a5,0x20
 d3c:	0792                	slli	a5,a5,0x4
 d3e:	fe843703          	ld	a4,-24(s0)
 d42:	97ba                	add	a5,a5,a4
 d44:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 d48:	fe843783          	ld	a5,-24(s0)
 d4c:	fdc42703          	lw	a4,-36(s0)
 d50:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 d52:	00000797          	auipc	a5,0x0
 d56:	2de78793          	addi	a5,a5,734 # 1030 <freep>
 d5a:	fe043703          	ld	a4,-32(s0)
 d5e:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 d60:	fe843783          	ld	a5,-24(s0)
 d64:	07c1                	addi	a5,a5,16
 d66:	a091                	j	daa <malloc+0x132>
    }
    if(p == freep)
 d68:	00000797          	auipc	a5,0x0
 d6c:	2c878793          	addi	a5,a5,712 # 1030 <freep>
 d70:	639c                	ld	a5,0(a5)
 d72:	fe843703          	ld	a4,-24(s0)
 d76:	02f71063          	bne	a4,a5,d96 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 d7a:	fdc42783          	lw	a5,-36(s0)
 d7e:	853e                	mv	a0,a5
 d80:	00000097          	auipc	ra,0x0
 d84:	e7a080e7          	jalr	-390(ra) # bfa <morecore>
 d88:	fea43423          	sd	a0,-24(s0)
 d8c:	fe843783          	ld	a5,-24(s0)
 d90:	e399                	bnez	a5,d96 <malloc+0x11e>
        return 0;
 d92:	4781                	li	a5,0
 d94:	a819                	j	daa <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d96:	fe843783          	ld	a5,-24(s0)
 d9a:	fef43023          	sd	a5,-32(s0)
 d9e:	fe843783          	ld	a5,-24(s0)
 da2:	639c                	ld	a5,0(a5)
 da4:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 da8:	b799                	j	cee <malloc+0x76>
  }
}
 daa:	853e                	mv	a0,a5
 dac:	70e2                	ld	ra,56(sp)
 dae:	7442                	ld	s0,48(sp)
 db0:	6121                	addi	sp,sp,64
 db2:	8082                	ret
