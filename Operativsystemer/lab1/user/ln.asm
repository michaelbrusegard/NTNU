
user/_ln:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
   8:	87aa                	mv	a5,a0
   a:	feb43023          	sd	a1,-32(s0)
   e:	fef42623          	sw	a5,-20(s0)
  if(argc != 3){
  12:	fec42783          	lw	a5,-20(s0)
  16:	0007871b          	sext.w	a4,a5
  1a:	478d                	li	a5,3
  1c:	02f70063          	beq	a4,a5,3c <main+0x3c>
    fprintf(2, "Usage: ln old new\n");
  20:	00001597          	auipc	a1,0x1
  24:	d9058593          	addi	a1,a1,-624 # db0 <malloc+0x140>
  28:	4509                	li	a0,2
  2a:	00001097          	auipc	ra,0x1
  2e:	9fa080e7          	jalr	-1542(ra) # a24 <fprintf>
    exit(1);
  32:	4505                	li	a0,1
  34:	00000097          	auipc	ra,0x0
  38:	524080e7          	jalr	1316(ra) # 558 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  3c:	fe043783          	ld	a5,-32(s0)
  40:	07a1                	addi	a5,a5,8
  42:	6398                	ld	a4,0(a5)
  44:	fe043783          	ld	a5,-32(s0)
  48:	07c1                	addi	a5,a5,16
  4a:	639c                	ld	a5,0(a5)
  4c:	85be                	mv	a1,a5
  4e:	853a                	mv	a0,a4
  50:	00000097          	auipc	ra,0x0
  54:	568080e7          	jalr	1384(ra) # 5b8 <link>
  58:	87aa                	mv	a5,a0
  5a:	0207d563          	bgez	a5,84 <main+0x84>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  5e:	fe043783          	ld	a5,-32(s0)
  62:	07a1                	addi	a5,a5,8
  64:	6398                	ld	a4,0(a5)
  66:	fe043783          	ld	a5,-32(s0)
  6a:	07c1                	addi	a5,a5,16
  6c:	639c                	ld	a5,0(a5)
  6e:	86be                	mv	a3,a5
  70:	863a                	mv	a2,a4
  72:	00001597          	auipc	a1,0x1
  76:	d5658593          	addi	a1,a1,-682 # dc8 <malloc+0x158>
  7a:	4509                	li	a0,2
  7c:	00001097          	auipc	ra,0x1
  80:	9a8080e7          	jalr	-1624(ra) # a24 <fprintf>
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

00000000000005f8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5f8:	1101                	addi	sp,sp,-32
 5fa:	ec06                	sd	ra,24(sp)
 5fc:	e822                	sd	s0,16(sp)
 5fe:	1000                	addi	s0,sp,32
 600:	87aa                	mv	a5,a0
 602:	872e                	mv	a4,a1
 604:	fef42623          	sw	a5,-20(s0)
 608:	87ba                	mv	a5,a4
 60a:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 60e:	feb40713          	addi	a4,s0,-21
 612:	fec42783          	lw	a5,-20(s0)
 616:	4605                	li	a2,1
 618:	85ba                	mv	a1,a4
 61a:	853e                	mv	a0,a5
 61c:	00000097          	auipc	ra,0x0
 620:	f5c080e7          	jalr	-164(ra) # 578 <write>
}
 624:	0001                	nop
 626:	60e2                	ld	ra,24(sp)
 628:	6442                	ld	s0,16(sp)
 62a:	6105                	addi	sp,sp,32
 62c:	8082                	ret

000000000000062e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 62e:	7139                	addi	sp,sp,-64
 630:	fc06                	sd	ra,56(sp)
 632:	f822                	sd	s0,48(sp)
 634:	0080                	addi	s0,sp,64
 636:	87aa                	mv	a5,a0
 638:	8736                	mv	a4,a3
 63a:	fcf42623          	sw	a5,-52(s0)
 63e:	87ae                	mv	a5,a1
 640:	fcf42423          	sw	a5,-56(s0)
 644:	87b2                	mv	a5,a2
 646:	fcf42223          	sw	a5,-60(s0)
 64a:	87ba                	mv	a5,a4
 64c:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 650:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 654:	fc042783          	lw	a5,-64(s0)
 658:	2781                	sext.w	a5,a5
 65a:	c38d                	beqz	a5,67c <printint+0x4e>
 65c:	fc842783          	lw	a5,-56(s0)
 660:	2781                	sext.w	a5,a5
 662:	0007dd63          	bgez	a5,67c <printint+0x4e>
    neg = 1;
 666:	4785                	li	a5,1
 668:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 66c:	fc842783          	lw	a5,-56(s0)
 670:	40f007bb          	negw	a5,a5
 674:	2781                	sext.w	a5,a5
 676:	fef42223          	sw	a5,-28(s0)
 67a:	a029                	j	684 <printint+0x56>
  } else {
    x = xx;
 67c:	fc842783          	lw	a5,-56(s0)
 680:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 684:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 688:	fc442783          	lw	a5,-60(s0)
 68c:	fe442703          	lw	a4,-28(s0)
 690:	02f777bb          	remuw	a5,a4,a5
 694:	0007871b          	sext.w	a4,a5
 698:	fec42783          	lw	a5,-20(s0)
 69c:	0017869b          	addiw	a3,a5,1
 6a0:	fed42623          	sw	a3,-20(s0)
 6a4:	00001697          	auipc	a3,0x1
 6a8:	95c68693          	addi	a3,a3,-1700 # 1000 <digits>
 6ac:	1702                	slli	a4,a4,0x20
 6ae:	9301                	srli	a4,a4,0x20
 6b0:	9736                	add	a4,a4,a3
 6b2:	00074703          	lbu	a4,0(a4)
 6b6:	17c1                	addi	a5,a5,-16
 6b8:	97a2                	add	a5,a5,s0
 6ba:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 6be:	fc442783          	lw	a5,-60(s0)
 6c2:	fe442703          	lw	a4,-28(s0)
 6c6:	02f757bb          	divuw	a5,a4,a5
 6ca:	fef42223          	sw	a5,-28(s0)
 6ce:	fe442783          	lw	a5,-28(s0)
 6d2:	2781                	sext.w	a5,a5
 6d4:	fbd5                	bnez	a5,688 <printint+0x5a>
  if(neg)
 6d6:	fe842783          	lw	a5,-24(s0)
 6da:	2781                	sext.w	a5,a5
 6dc:	cf85                	beqz	a5,714 <printint+0xe6>
    buf[i++] = '-';
 6de:	fec42783          	lw	a5,-20(s0)
 6e2:	0017871b          	addiw	a4,a5,1
 6e6:	fee42623          	sw	a4,-20(s0)
 6ea:	17c1                	addi	a5,a5,-16
 6ec:	97a2                	add	a5,a5,s0
 6ee:	02d00713          	li	a4,45
 6f2:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 6f6:	a839                	j	714 <printint+0xe6>
    putc(fd, buf[i]);
 6f8:	fec42783          	lw	a5,-20(s0)
 6fc:	17c1                	addi	a5,a5,-16
 6fe:	97a2                	add	a5,a5,s0
 700:	fe07c703          	lbu	a4,-32(a5)
 704:	fcc42783          	lw	a5,-52(s0)
 708:	85ba                	mv	a1,a4
 70a:	853e                	mv	a0,a5
 70c:	00000097          	auipc	ra,0x0
 710:	eec080e7          	jalr	-276(ra) # 5f8 <putc>
  while(--i >= 0)
 714:	fec42783          	lw	a5,-20(s0)
 718:	37fd                	addiw	a5,a5,-1
 71a:	fef42623          	sw	a5,-20(s0)
 71e:	fec42783          	lw	a5,-20(s0)
 722:	2781                	sext.w	a5,a5
 724:	fc07dae3          	bgez	a5,6f8 <printint+0xca>
}
 728:	0001                	nop
 72a:	0001                	nop
 72c:	70e2                	ld	ra,56(sp)
 72e:	7442                	ld	s0,48(sp)
 730:	6121                	addi	sp,sp,64
 732:	8082                	ret

0000000000000734 <printptr>:

static void
printptr(int fd, uint64 x) {
 734:	7179                	addi	sp,sp,-48
 736:	f406                	sd	ra,40(sp)
 738:	f022                	sd	s0,32(sp)
 73a:	1800                	addi	s0,sp,48
 73c:	87aa                	mv	a5,a0
 73e:	fcb43823          	sd	a1,-48(s0)
 742:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 746:	fdc42783          	lw	a5,-36(s0)
 74a:	03000593          	li	a1,48
 74e:	853e                	mv	a0,a5
 750:	00000097          	auipc	ra,0x0
 754:	ea8080e7          	jalr	-344(ra) # 5f8 <putc>
  putc(fd, 'x');
 758:	fdc42783          	lw	a5,-36(s0)
 75c:	07800593          	li	a1,120
 760:	853e                	mv	a0,a5
 762:	00000097          	auipc	ra,0x0
 766:	e96080e7          	jalr	-362(ra) # 5f8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 76a:	fe042623          	sw	zero,-20(s0)
 76e:	a82d                	j	7a8 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 770:	fd043783          	ld	a5,-48(s0)
 774:	93f1                	srli	a5,a5,0x3c
 776:	00001717          	auipc	a4,0x1
 77a:	88a70713          	addi	a4,a4,-1910 # 1000 <digits>
 77e:	97ba                	add	a5,a5,a4
 780:	0007c703          	lbu	a4,0(a5)
 784:	fdc42783          	lw	a5,-36(s0)
 788:	85ba                	mv	a1,a4
 78a:	853e                	mv	a0,a5
 78c:	00000097          	auipc	ra,0x0
 790:	e6c080e7          	jalr	-404(ra) # 5f8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 794:	fec42783          	lw	a5,-20(s0)
 798:	2785                	addiw	a5,a5,1
 79a:	fef42623          	sw	a5,-20(s0)
 79e:	fd043783          	ld	a5,-48(s0)
 7a2:	0792                	slli	a5,a5,0x4
 7a4:	fcf43823          	sd	a5,-48(s0)
 7a8:	fec42703          	lw	a4,-20(s0)
 7ac:	47bd                	li	a5,15
 7ae:	fce7f1e3          	bgeu	a5,a4,770 <printptr+0x3c>
}
 7b2:	0001                	nop
 7b4:	0001                	nop
 7b6:	70a2                	ld	ra,40(sp)
 7b8:	7402                	ld	s0,32(sp)
 7ba:	6145                	addi	sp,sp,48
 7bc:	8082                	ret

00000000000007be <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7be:	715d                	addi	sp,sp,-80
 7c0:	e486                	sd	ra,72(sp)
 7c2:	e0a2                	sd	s0,64(sp)
 7c4:	0880                	addi	s0,sp,80
 7c6:	87aa                	mv	a5,a0
 7c8:	fcb43023          	sd	a1,-64(s0)
 7cc:	fac43c23          	sd	a2,-72(s0)
 7d0:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 7d4:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 7d8:	fe042223          	sw	zero,-28(s0)
 7dc:	a42d                	j	a06 <vprintf+0x248>
    c = fmt[i] & 0xff;
 7de:	fe442783          	lw	a5,-28(s0)
 7e2:	fc043703          	ld	a4,-64(s0)
 7e6:	97ba                	add	a5,a5,a4
 7e8:	0007c783          	lbu	a5,0(a5)
 7ec:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 7f0:	fe042783          	lw	a5,-32(s0)
 7f4:	2781                	sext.w	a5,a5
 7f6:	eb9d                	bnez	a5,82c <vprintf+0x6e>
      if(c == '%'){
 7f8:	fdc42783          	lw	a5,-36(s0)
 7fc:	0007871b          	sext.w	a4,a5
 800:	02500793          	li	a5,37
 804:	00f71763          	bne	a4,a5,812 <vprintf+0x54>
        state = '%';
 808:	02500793          	li	a5,37
 80c:	fef42023          	sw	a5,-32(s0)
 810:	a2f5                	j	9fc <vprintf+0x23e>
      } else {
        putc(fd, c);
 812:	fdc42783          	lw	a5,-36(s0)
 816:	0ff7f713          	zext.b	a4,a5
 81a:	fcc42783          	lw	a5,-52(s0)
 81e:	85ba                	mv	a1,a4
 820:	853e                	mv	a0,a5
 822:	00000097          	auipc	ra,0x0
 826:	dd6080e7          	jalr	-554(ra) # 5f8 <putc>
 82a:	aac9                	j	9fc <vprintf+0x23e>
      }
    } else if(state == '%'){
 82c:	fe042783          	lw	a5,-32(s0)
 830:	0007871b          	sext.w	a4,a5
 834:	02500793          	li	a5,37
 838:	1cf71263          	bne	a4,a5,9fc <vprintf+0x23e>
      if(c == 'd'){
 83c:	fdc42783          	lw	a5,-36(s0)
 840:	0007871b          	sext.w	a4,a5
 844:	06400793          	li	a5,100
 848:	02f71463          	bne	a4,a5,870 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 84c:	fb843783          	ld	a5,-72(s0)
 850:	00878713          	addi	a4,a5,8
 854:	fae43c23          	sd	a4,-72(s0)
 858:	4398                	lw	a4,0(a5)
 85a:	fcc42783          	lw	a5,-52(s0)
 85e:	4685                	li	a3,1
 860:	4629                	li	a2,10
 862:	85ba                	mv	a1,a4
 864:	853e                	mv	a0,a5
 866:	00000097          	auipc	ra,0x0
 86a:	dc8080e7          	jalr	-568(ra) # 62e <printint>
 86e:	a269                	j	9f8 <vprintf+0x23a>
      } else if(c == 'l') {
 870:	fdc42783          	lw	a5,-36(s0)
 874:	0007871b          	sext.w	a4,a5
 878:	06c00793          	li	a5,108
 87c:	02f71663          	bne	a4,a5,8a8 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 880:	fb843783          	ld	a5,-72(s0)
 884:	00878713          	addi	a4,a5,8
 888:	fae43c23          	sd	a4,-72(s0)
 88c:	639c                	ld	a5,0(a5)
 88e:	0007871b          	sext.w	a4,a5
 892:	fcc42783          	lw	a5,-52(s0)
 896:	4681                	li	a3,0
 898:	4629                	li	a2,10
 89a:	85ba                	mv	a1,a4
 89c:	853e                	mv	a0,a5
 89e:	00000097          	auipc	ra,0x0
 8a2:	d90080e7          	jalr	-624(ra) # 62e <printint>
 8a6:	aa89                	j	9f8 <vprintf+0x23a>
      } else if(c == 'x') {
 8a8:	fdc42783          	lw	a5,-36(s0)
 8ac:	0007871b          	sext.w	a4,a5
 8b0:	07800793          	li	a5,120
 8b4:	02f71463          	bne	a4,a5,8dc <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 8b8:	fb843783          	ld	a5,-72(s0)
 8bc:	00878713          	addi	a4,a5,8
 8c0:	fae43c23          	sd	a4,-72(s0)
 8c4:	4398                	lw	a4,0(a5)
 8c6:	fcc42783          	lw	a5,-52(s0)
 8ca:	4681                	li	a3,0
 8cc:	4641                	li	a2,16
 8ce:	85ba                	mv	a1,a4
 8d0:	853e                	mv	a0,a5
 8d2:	00000097          	auipc	ra,0x0
 8d6:	d5c080e7          	jalr	-676(ra) # 62e <printint>
 8da:	aa39                	j	9f8 <vprintf+0x23a>
      } else if(c == 'p') {
 8dc:	fdc42783          	lw	a5,-36(s0)
 8e0:	0007871b          	sext.w	a4,a5
 8e4:	07000793          	li	a5,112
 8e8:	02f71263          	bne	a4,a5,90c <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 8ec:	fb843783          	ld	a5,-72(s0)
 8f0:	00878713          	addi	a4,a5,8
 8f4:	fae43c23          	sd	a4,-72(s0)
 8f8:	6398                	ld	a4,0(a5)
 8fa:	fcc42783          	lw	a5,-52(s0)
 8fe:	85ba                	mv	a1,a4
 900:	853e                	mv	a0,a5
 902:	00000097          	auipc	ra,0x0
 906:	e32080e7          	jalr	-462(ra) # 734 <printptr>
 90a:	a0fd                	j	9f8 <vprintf+0x23a>
      } else if(c == 's'){
 90c:	fdc42783          	lw	a5,-36(s0)
 910:	0007871b          	sext.w	a4,a5
 914:	07300793          	li	a5,115
 918:	04f71c63          	bne	a4,a5,970 <vprintf+0x1b2>
        s = va_arg(ap, char*);
 91c:	fb843783          	ld	a5,-72(s0)
 920:	00878713          	addi	a4,a5,8
 924:	fae43c23          	sd	a4,-72(s0)
 928:	639c                	ld	a5,0(a5)
 92a:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 92e:	fe843783          	ld	a5,-24(s0)
 932:	eb8d                	bnez	a5,964 <vprintf+0x1a6>
          s = "(null)";
 934:	00000797          	auipc	a5,0x0
 938:	4ac78793          	addi	a5,a5,1196 # de0 <malloc+0x170>
 93c:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 940:	a015                	j	964 <vprintf+0x1a6>
          putc(fd, *s);
 942:	fe843783          	ld	a5,-24(s0)
 946:	0007c703          	lbu	a4,0(a5)
 94a:	fcc42783          	lw	a5,-52(s0)
 94e:	85ba                	mv	a1,a4
 950:	853e                	mv	a0,a5
 952:	00000097          	auipc	ra,0x0
 956:	ca6080e7          	jalr	-858(ra) # 5f8 <putc>
          s++;
 95a:	fe843783          	ld	a5,-24(s0)
 95e:	0785                	addi	a5,a5,1
 960:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 964:	fe843783          	ld	a5,-24(s0)
 968:	0007c783          	lbu	a5,0(a5)
 96c:	fbf9                	bnez	a5,942 <vprintf+0x184>
 96e:	a069                	j	9f8 <vprintf+0x23a>
        }
      } else if(c == 'c'){
 970:	fdc42783          	lw	a5,-36(s0)
 974:	0007871b          	sext.w	a4,a5
 978:	06300793          	li	a5,99
 97c:	02f71463          	bne	a4,a5,9a4 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 980:	fb843783          	ld	a5,-72(s0)
 984:	00878713          	addi	a4,a5,8
 988:	fae43c23          	sd	a4,-72(s0)
 98c:	439c                	lw	a5,0(a5)
 98e:	0ff7f713          	zext.b	a4,a5
 992:	fcc42783          	lw	a5,-52(s0)
 996:	85ba                	mv	a1,a4
 998:	853e                	mv	a0,a5
 99a:	00000097          	auipc	ra,0x0
 99e:	c5e080e7          	jalr	-930(ra) # 5f8 <putc>
 9a2:	a899                	j	9f8 <vprintf+0x23a>
      } else if(c == '%'){
 9a4:	fdc42783          	lw	a5,-36(s0)
 9a8:	0007871b          	sext.w	a4,a5
 9ac:	02500793          	li	a5,37
 9b0:	00f71f63          	bne	a4,a5,9ce <vprintf+0x210>
        putc(fd, c);
 9b4:	fdc42783          	lw	a5,-36(s0)
 9b8:	0ff7f713          	zext.b	a4,a5
 9bc:	fcc42783          	lw	a5,-52(s0)
 9c0:	85ba                	mv	a1,a4
 9c2:	853e                	mv	a0,a5
 9c4:	00000097          	auipc	ra,0x0
 9c8:	c34080e7          	jalr	-972(ra) # 5f8 <putc>
 9cc:	a035                	j	9f8 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9ce:	fcc42783          	lw	a5,-52(s0)
 9d2:	02500593          	li	a1,37
 9d6:	853e                	mv	a0,a5
 9d8:	00000097          	auipc	ra,0x0
 9dc:	c20080e7          	jalr	-992(ra) # 5f8 <putc>
        putc(fd, c);
 9e0:	fdc42783          	lw	a5,-36(s0)
 9e4:	0ff7f713          	zext.b	a4,a5
 9e8:	fcc42783          	lw	a5,-52(s0)
 9ec:	85ba                	mv	a1,a4
 9ee:	853e                	mv	a0,a5
 9f0:	00000097          	auipc	ra,0x0
 9f4:	c08080e7          	jalr	-1016(ra) # 5f8 <putc>
      }
      state = 0;
 9f8:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 9fc:	fe442783          	lw	a5,-28(s0)
 a00:	2785                	addiw	a5,a5,1
 a02:	fef42223          	sw	a5,-28(s0)
 a06:	fe442783          	lw	a5,-28(s0)
 a0a:	fc043703          	ld	a4,-64(s0)
 a0e:	97ba                	add	a5,a5,a4
 a10:	0007c783          	lbu	a5,0(a5)
 a14:	dc0795e3          	bnez	a5,7de <vprintf+0x20>
    }
  }
}
 a18:	0001                	nop
 a1a:	0001                	nop
 a1c:	60a6                	ld	ra,72(sp)
 a1e:	6406                	ld	s0,64(sp)
 a20:	6161                	addi	sp,sp,80
 a22:	8082                	ret

0000000000000a24 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a24:	7159                	addi	sp,sp,-112
 a26:	fc06                	sd	ra,56(sp)
 a28:	f822                	sd	s0,48(sp)
 a2a:	0080                	addi	s0,sp,64
 a2c:	fcb43823          	sd	a1,-48(s0)
 a30:	e010                	sd	a2,0(s0)
 a32:	e414                	sd	a3,8(s0)
 a34:	e818                	sd	a4,16(s0)
 a36:	ec1c                	sd	a5,24(s0)
 a38:	03043023          	sd	a6,32(s0)
 a3c:	03143423          	sd	a7,40(s0)
 a40:	87aa                	mv	a5,a0
 a42:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 a46:	03040793          	addi	a5,s0,48
 a4a:	fcf43423          	sd	a5,-56(s0)
 a4e:	fc843783          	ld	a5,-56(s0)
 a52:	fd078793          	addi	a5,a5,-48
 a56:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 a5a:	fe843703          	ld	a4,-24(s0)
 a5e:	fdc42783          	lw	a5,-36(s0)
 a62:	863a                	mv	a2,a4
 a64:	fd043583          	ld	a1,-48(s0)
 a68:	853e                	mv	a0,a5
 a6a:	00000097          	auipc	ra,0x0
 a6e:	d54080e7          	jalr	-684(ra) # 7be <vprintf>
}
 a72:	0001                	nop
 a74:	70e2                	ld	ra,56(sp)
 a76:	7442                	ld	s0,48(sp)
 a78:	6165                	addi	sp,sp,112
 a7a:	8082                	ret

0000000000000a7c <printf>:

void
printf(const char *fmt, ...)
{
 a7c:	7159                	addi	sp,sp,-112
 a7e:	f406                	sd	ra,40(sp)
 a80:	f022                	sd	s0,32(sp)
 a82:	1800                	addi	s0,sp,48
 a84:	fca43c23          	sd	a0,-40(s0)
 a88:	e40c                	sd	a1,8(s0)
 a8a:	e810                	sd	a2,16(s0)
 a8c:	ec14                	sd	a3,24(s0)
 a8e:	f018                	sd	a4,32(s0)
 a90:	f41c                	sd	a5,40(s0)
 a92:	03043823          	sd	a6,48(s0)
 a96:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a9a:	04040793          	addi	a5,s0,64
 a9e:	fcf43823          	sd	a5,-48(s0)
 aa2:	fd043783          	ld	a5,-48(s0)
 aa6:	fc878793          	addi	a5,a5,-56
 aaa:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 aae:	fe843783          	ld	a5,-24(s0)
 ab2:	863e                	mv	a2,a5
 ab4:	fd843583          	ld	a1,-40(s0)
 ab8:	4505                	li	a0,1
 aba:	00000097          	auipc	ra,0x0
 abe:	d04080e7          	jalr	-764(ra) # 7be <vprintf>
}
 ac2:	0001                	nop
 ac4:	70a2                	ld	ra,40(sp)
 ac6:	7402                	ld	s0,32(sp)
 ac8:	6165                	addi	sp,sp,112
 aca:	8082                	ret

0000000000000acc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 acc:	7179                	addi	sp,sp,-48
 ace:	f406                	sd	ra,40(sp)
 ad0:	f022                	sd	s0,32(sp)
 ad2:	1800                	addi	s0,sp,48
 ad4:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 ad8:	fd843783          	ld	a5,-40(s0)
 adc:	17c1                	addi	a5,a5,-16
 ade:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ae2:	00000797          	auipc	a5,0x0
 ae6:	54e78793          	addi	a5,a5,1358 # 1030 <freep>
 aea:	639c                	ld	a5,0(a5)
 aec:	fef43423          	sd	a5,-24(s0)
 af0:	a815                	j	b24 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 af2:	fe843783          	ld	a5,-24(s0)
 af6:	639c                	ld	a5,0(a5)
 af8:	fe843703          	ld	a4,-24(s0)
 afc:	00f76f63          	bltu	a4,a5,b1a <free+0x4e>
 b00:	fe043703          	ld	a4,-32(s0)
 b04:	fe843783          	ld	a5,-24(s0)
 b08:	02e7eb63          	bltu	a5,a4,b3e <free+0x72>
 b0c:	fe843783          	ld	a5,-24(s0)
 b10:	639c                	ld	a5,0(a5)
 b12:	fe043703          	ld	a4,-32(s0)
 b16:	02f76463          	bltu	a4,a5,b3e <free+0x72>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b1a:	fe843783          	ld	a5,-24(s0)
 b1e:	639c                	ld	a5,0(a5)
 b20:	fef43423          	sd	a5,-24(s0)
 b24:	fe043703          	ld	a4,-32(s0)
 b28:	fe843783          	ld	a5,-24(s0)
 b2c:	fce7f3e3          	bgeu	a5,a4,af2 <free+0x26>
 b30:	fe843783          	ld	a5,-24(s0)
 b34:	639c                	ld	a5,0(a5)
 b36:	fe043703          	ld	a4,-32(s0)
 b3a:	faf77ce3          	bgeu	a4,a5,af2 <free+0x26>
      break;
  if(bp + bp->s.size == p->s.ptr){
 b3e:	fe043783          	ld	a5,-32(s0)
 b42:	479c                	lw	a5,8(a5)
 b44:	1782                	slli	a5,a5,0x20
 b46:	9381                	srli	a5,a5,0x20
 b48:	0792                	slli	a5,a5,0x4
 b4a:	fe043703          	ld	a4,-32(s0)
 b4e:	973e                	add	a4,a4,a5
 b50:	fe843783          	ld	a5,-24(s0)
 b54:	639c                	ld	a5,0(a5)
 b56:	02f71763          	bne	a4,a5,b84 <free+0xb8>
    bp->s.size += p->s.ptr->s.size;
 b5a:	fe043783          	ld	a5,-32(s0)
 b5e:	4798                	lw	a4,8(a5)
 b60:	fe843783          	ld	a5,-24(s0)
 b64:	639c                	ld	a5,0(a5)
 b66:	479c                	lw	a5,8(a5)
 b68:	9fb9                	addw	a5,a5,a4
 b6a:	0007871b          	sext.w	a4,a5
 b6e:	fe043783          	ld	a5,-32(s0)
 b72:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 b74:	fe843783          	ld	a5,-24(s0)
 b78:	639c                	ld	a5,0(a5)
 b7a:	6398                	ld	a4,0(a5)
 b7c:	fe043783          	ld	a5,-32(s0)
 b80:	e398                	sd	a4,0(a5)
 b82:	a039                	j	b90 <free+0xc4>
  } else
    bp->s.ptr = p->s.ptr;
 b84:	fe843783          	ld	a5,-24(s0)
 b88:	6398                	ld	a4,0(a5)
 b8a:	fe043783          	ld	a5,-32(s0)
 b8e:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 b90:	fe843783          	ld	a5,-24(s0)
 b94:	479c                	lw	a5,8(a5)
 b96:	1782                	slli	a5,a5,0x20
 b98:	9381                	srli	a5,a5,0x20
 b9a:	0792                	slli	a5,a5,0x4
 b9c:	fe843703          	ld	a4,-24(s0)
 ba0:	97ba                	add	a5,a5,a4
 ba2:	fe043703          	ld	a4,-32(s0)
 ba6:	02f71563          	bne	a4,a5,bd0 <free+0x104>
    p->s.size += bp->s.size;
 baa:	fe843783          	ld	a5,-24(s0)
 bae:	4798                	lw	a4,8(a5)
 bb0:	fe043783          	ld	a5,-32(s0)
 bb4:	479c                	lw	a5,8(a5)
 bb6:	9fb9                	addw	a5,a5,a4
 bb8:	0007871b          	sext.w	a4,a5
 bbc:	fe843783          	ld	a5,-24(s0)
 bc0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 bc2:	fe043783          	ld	a5,-32(s0)
 bc6:	6398                	ld	a4,0(a5)
 bc8:	fe843783          	ld	a5,-24(s0)
 bcc:	e398                	sd	a4,0(a5)
 bce:	a031                	j	bda <free+0x10e>
  } else
    p->s.ptr = bp;
 bd0:	fe843783          	ld	a5,-24(s0)
 bd4:	fe043703          	ld	a4,-32(s0)
 bd8:	e398                	sd	a4,0(a5)
  freep = p;
 bda:	00000797          	auipc	a5,0x0
 bde:	45678793          	addi	a5,a5,1110 # 1030 <freep>
 be2:	fe843703          	ld	a4,-24(s0)
 be6:	e398                	sd	a4,0(a5)
}
 be8:	0001                	nop
 bea:	70a2                	ld	ra,40(sp)
 bec:	7402                	ld	s0,32(sp)
 bee:	6145                	addi	sp,sp,48
 bf0:	8082                	ret

0000000000000bf2 <morecore>:

static Header*
morecore(uint nu)
{
 bf2:	7179                	addi	sp,sp,-48
 bf4:	f406                	sd	ra,40(sp)
 bf6:	f022                	sd	s0,32(sp)
 bf8:	1800                	addi	s0,sp,48
 bfa:	87aa                	mv	a5,a0
 bfc:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 c00:	fdc42783          	lw	a5,-36(s0)
 c04:	0007871b          	sext.w	a4,a5
 c08:	6785                	lui	a5,0x1
 c0a:	00f77563          	bgeu	a4,a5,c14 <morecore+0x22>
    nu = 4096;
 c0e:	6785                	lui	a5,0x1
 c10:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 c14:	fdc42783          	lw	a5,-36(s0)
 c18:	0047979b          	slliw	a5,a5,0x4
 c1c:	2781                	sext.w	a5,a5
 c1e:	853e                	mv	a0,a5
 c20:	00000097          	auipc	ra,0x0
 c24:	9c0080e7          	jalr	-1600(ra) # 5e0 <sbrk>
 c28:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 c2c:	fe843703          	ld	a4,-24(s0)
 c30:	57fd                	li	a5,-1
 c32:	00f71463          	bne	a4,a5,c3a <morecore+0x48>
    return 0;
 c36:	4781                	li	a5,0
 c38:	a03d                	j	c66 <morecore+0x74>
  hp = (Header*)p;
 c3a:	fe843783          	ld	a5,-24(s0)
 c3e:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 c42:	fe043783          	ld	a5,-32(s0)
 c46:	fdc42703          	lw	a4,-36(s0)
 c4a:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 c4c:	fe043783          	ld	a5,-32(s0)
 c50:	07c1                	addi	a5,a5,16 # 1010 <digits+0x10>
 c52:	853e                	mv	a0,a5
 c54:	00000097          	auipc	ra,0x0
 c58:	e78080e7          	jalr	-392(ra) # acc <free>
  return freep;
 c5c:	00000797          	auipc	a5,0x0
 c60:	3d478793          	addi	a5,a5,980 # 1030 <freep>
 c64:	639c                	ld	a5,0(a5)
}
 c66:	853e                	mv	a0,a5
 c68:	70a2                	ld	ra,40(sp)
 c6a:	7402                	ld	s0,32(sp)
 c6c:	6145                	addi	sp,sp,48
 c6e:	8082                	ret

0000000000000c70 <malloc>:

void*
malloc(uint nbytes)
{
 c70:	7139                	addi	sp,sp,-64
 c72:	fc06                	sd	ra,56(sp)
 c74:	f822                	sd	s0,48(sp)
 c76:	0080                	addi	s0,sp,64
 c78:	87aa                	mv	a5,a0
 c7a:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c7e:	fcc46783          	lwu	a5,-52(s0)
 c82:	07bd                	addi	a5,a5,15
 c84:	8391                	srli	a5,a5,0x4
 c86:	2781                	sext.w	a5,a5
 c88:	2785                	addiw	a5,a5,1
 c8a:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 c8e:	00000797          	auipc	a5,0x0
 c92:	3a278793          	addi	a5,a5,930 # 1030 <freep>
 c96:	639c                	ld	a5,0(a5)
 c98:	fef43023          	sd	a5,-32(s0)
 c9c:	fe043783          	ld	a5,-32(s0)
 ca0:	ef95                	bnez	a5,cdc <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 ca2:	00000797          	auipc	a5,0x0
 ca6:	37e78793          	addi	a5,a5,894 # 1020 <base>
 caa:	fef43023          	sd	a5,-32(s0)
 cae:	00000797          	auipc	a5,0x0
 cb2:	38278793          	addi	a5,a5,898 # 1030 <freep>
 cb6:	fe043703          	ld	a4,-32(s0)
 cba:	e398                	sd	a4,0(a5)
 cbc:	00000797          	auipc	a5,0x0
 cc0:	37478793          	addi	a5,a5,884 # 1030 <freep>
 cc4:	6398                	ld	a4,0(a5)
 cc6:	00000797          	auipc	a5,0x0
 cca:	35a78793          	addi	a5,a5,858 # 1020 <base>
 cce:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 cd0:	00000797          	auipc	a5,0x0
 cd4:	35078793          	addi	a5,a5,848 # 1020 <base>
 cd8:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cdc:	fe043783          	ld	a5,-32(s0)
 ce0:	639c                	ld	a5,0(a5)
 ce2:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 ce6:	fe843783          	ld	a5,-24(s0)
 cea:	479c                	lw	a5,8(a5)
 cec:	fdc42703          	lw	a4,-36(s0)
 cf0:	2701                	sext.w	a4,a4
 cf2:	06e7e763          	bltu	a5,a4,d60 <malloc+0xf0>
      if(p->s.size == nunits)
 cf6:	fe843783          	ld	a5,-24(s0)
 cfa:	479c                	lw	a5,8(a5)
 cfc:	fdc42703          	lw	a4,-36(s0)
 d00:	2701                	sext.w	a4,a4
 d02:	00f71963          	bne	a4,a5,d14 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 d06:	fe843783          	ld	a5,-24(s0)
 d0a:	6398                	ld	a4,0(a5)
 d0c:	fe043783          	ld	a5,-32(s0)
 d10:	e398                	sd	a4,0(a5)
 d12:	a825                	j	d4a <malloc+0xda>
      else {
        p->s.size -= nunits;
 d14:	fe843783          	ld	a5,-24(s0)
 d18:	479c                	lw	a5,8(a5)
 d1a:	fdc42703          	lw	a4,-36(s0)
 d1e:	9f99                	subw	a5,a5,a4
 d20:	0007871b          	sext.w	a4,a5
 d24:	fe843783          	ld	a5,-24(s0)
 d28:	c798                	sw	a4,8(a5)
        p += p->s.size;
 d2a:	fe843783          	ld	a5,-24(s0)
 d2e:	479c                	lw	a5,8(a5)
 d30:	1782                	slli	a5,a5,0x20
 d32:	9381                	srli	a5,a5,0x20
 d34:	0792                	slli	a5,a5,0x4
 d36:	fe843703          	ld	a4,-24(s0)
 d3a:	97ba                	add	a5,a5,a4
 d3c:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 d40:	fe843783          	ld	a5,-24(s0)
 d44:	fdc42703          	lw	a4,-36(s0)
 d48:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 d4a:	00000797          	auipc	a5,0x0
 d4e:	2e678793          	addi	a5,a5,742 # 1030 <freep>
 d52:	fe043703          	ld	a4,-32(s0)
 d56:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 d58:	fe843783          	ld	a5,-24(s0)
 d5c:	07c1                	addi	a5,a5,16
 d5e:	a091                	j	da2 <malloc+0x132>
    }
    if(p == freep)
 d60:	00000797          	auipc	a5,0x0
 d64:	2d078793          	addi	a5,a5,720 # 1030 <freep>
 d68:	639c                	ld	a5,0(a5)
 d6a:	fe843703          	ld	a4,-24(s0)
 d6e:	02f71063          	bne	a4,a5,d8e <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 d72:	fdc42783          	lw	a5,-36(s0)
 d76:	853e                	mv	a0,a5
 d78:	00000097          	auipc	ra,0x0
 d7c:	e7a080e7          	jalr	-390(ra) # bf2 <morecore>
 d80:	fea43423          	sd	a0,-24(s0)
 d84:	fe843783          	ld	a5,-24(s0)
 d88:	e399                	bnez	a5,d8e <malloc+0x11e>
        return 0;
 d8a:	4781                	li	a5,0
 d8c:	a819                	j	da2 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d8e:	fe843783          	ld	a5,-24(s0)
 d92:	fef43023          	sd	a5,-32(s0)
 d96:	fe843783          	ld	a5,-24(s0)
 d9a:	639c                	ld	a5,0(a5)
 d9c:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 da0:	b799                	j	ce6 <malloc+0x76>
  }
}
 da2:	853e                	mv	a0,a5
 da4:	70e2                	ld	ra,56(sp)
 da6:	7442                	ld	s0,48(sp)
 da8:	6121                	addi	sp,sp,64
 daa:	8082                	ret
