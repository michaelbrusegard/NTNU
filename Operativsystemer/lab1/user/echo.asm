
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	0080                	addi	s0,sp,64
   a:	87aa                	mv	a5,a0
   c:	fcb43023          	sd	a1,-64(s0)
  10:	fcf42623          	sw	a5,-52(s0)
  int i;

  for(i = 1; i < argc; i++){
  14:	4785                	li	a5,1
  16:	fcf42e23          	sw	a5,-36(s0)
  1a:	a8bd                	j	98 <main+0x98>
    write(1, argv[i], strlen(argv[i]));
  1c:	fdc42783          	lw	a5,-36(s0)
  20:	078e                	slli	a5,a5,0x3
  22:	fc043703          	ld	a4,-64(s0)
  26:	97ba                	add	a5,a5,a4
  28:	6384                	ld	s1,0(a5)
  2a:	fdc42783          	lw	a5,-36(s0)
  2e:	078e                	slli	a5,a5,0x3
  30:	fc043703          	ld	a4,-64(s0)
  34:	97ba                	add	a5,a5,a4
  36:	639c                	ld	a5,0(a5)
  38:	853e                	mv	a0,a5
  3a:	00000097          	auipc	ra,0x0
  3e:	14c080e7          	jalr	332(ra) # 186 <strlen>
  42:	87aa                	mv	a5,a0
  44:	863e                	mv	a2,a5
  46:	85a6                	mv	a1,s1
  48:	4505                	li	a0,1
  4a:	00000097          	auipc	ra,0x0
  4e:	554080e7          	jalr	1364(ra) # 59e <write>
    if(i + 1 < argc){
  52:	fdc42783          	lw	a5,-36(s0)
  56:	2785                	addiw	a5,a5,1
  58:	2781                	sext.w	a5,a5
  5a:	fcc42703          	lw	a4,-52(s0)
  5e:	2701                	sext.w	a4,a4
  60:	00e7dd63          	bge	a5,a4,7a <main+0x7a>
      write(1, " ", 1);
  64:	4605                	li	a2,1
  66:	00001597          	auipc	a1,0x1
  6a:	d7a58593          	addi	a1,a1,-646 # de0 <malloc+0x142>
  6e:	4505                	li	a0,1
  70:	00000097          	auipc	ra,0x0
  74:	52e080e7          	jalr	1326(ra) # 59e <write>
  78:	a819                	j	8e <main+0x8e>
    } else {
      write(1, "\n", 1);
  7a:	4605                	li	a2,1
  7c:	00001597          	auipc	a1,0x1
  80:	d6c58593          	addi	a1,a1,-660 # de8 <malloc+0x14a>
  84:	4505                	li	a0,1
  86:	00000097          	auipc	ra,0x0
  8a:	518080e7          	jalr	1304(ra) # 59e <write>
  for(i = 1; i < argc; i++){
  8e:	fdc42783          	lw	a5,-36(s0)
  92:	2785                	addiw	a5,a5,1
  94:	fcf42e23          	sw	a5,-36(s0)
  98:	fdc42783          	lw	a5,-36(s0)
  9c:	873e                	mv	a4,a5
  9e:	fcc42783          	lw	a5,-52(s0)
  a2:	2701                	sext.w	a4,a4
  a4:	2781                	sext.w	a5,a5
  a6:	f6f74be3          	blt	a4,a5,1c <main+0x1c>
    }
  }
  exit(0);
  aa:	4501                	li	a0,0
  ac:	00000097          	auipc	ra,0x0
  b0:	4d2080e7          	jalr	1234(ra) # 57e <exit>

00000000000000b4 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  b4:	1141                	addi	sp,sp,-16
  b6:	e406                	sd	ra,8(sp)
  b8:	e022                	sd	s0,0(sp)
  ba:	0800                	addi	s0,sp,16
  extern int main();
  main();
  bc:	00000097          	auipc	ra,0x0
  c0:	f44080e7          	jalr	-188(ra) # 0 <main>
  exit(0);
  c4:	4501                	li	a0,0
  c6:	00000097          	auipc	ra,0x0
  ca:	4b8080e7          	jalr	1208(ra) # 57e <exit>

00000000000000ce <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  ce:	7179                	addi	sp,sp,-48
  d0:	f406                	sd	ra,40(sp)
  d2:	f022                	sd	s0,32(sp)
  d4:	1800                	addi	s0,sp,48
  d6:	fca43c23          	sd	a0,-40(s0)
  da:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
  de:	fd843783          	ld	a5,-40(s0)
  e2:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
  e6:	0001                	nop
  e8:	fd043703          	ld	a4,-48(s0)
  ec:	00170793          	addi	a5,a4,1
  f0:	fcf43823          	sd	a5,-48(s0)
  f4:	fd843783          	ld	a5,-40(s0)
  f8:	00178693          	addi	a3,a5,1
  fc:	fcd43c23          	sd	a3,-40(s0)
 100:	00074703          	lbu	a4,0(a4)
 104:	00e78023          	sb	a4,0(a5)
 108:	0007c783          	lbu	a5,0(a5)
 10c:	fff1                	bnez	a5,e8 <strcpy+0x1a>
    ;
  return os;
 10e:	fe843783          	ld	a5,-24(s0)
}
 112:	853e                	mv	a0,a5
 114:	70a2                	ld	ra,40(sp)
 116:	7402                	ld	s0,32(sp)
 118:	6145                	addi	sp,sp,48
 11a:	8082                	ret

000000000000011c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 11c:	1101                	addi	sp,sp,-32
 11e:	ec06                	sd	ra,24(sp)
 120:	e822                	sd	s0,16(sp)
 122:	1000                	addi	s0,sp,32
 124:	fea43423          	sd	a0,-24(s0)
 128:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
 12c:	a819                	j	142 <strcmp+0x26>
    p++, q++;
 12e:	fe843783          	ld	a5,-24(s0)
 132:	0785                	addi	a5,a5,1
 134:	fef43423          	sd	a5,-24(s0)
 138:	fe043783          	ld	a5,-32(s0)
 13c:	0785                	addi	a5,a5,1
 13e:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
 142:	fe843783          	ld	a5,-24(s0)
 146:	0007c783          	lbu	a5,0(a5)
 14a:	cb99                	beqz	a5,160 <strcmp+0x44>
 14c:	fe843783          	ld	a5,-24(s0)
 150:	0007c703          	lbu	a4,0(a5)
 154:	fe043783          	ld	a5,-32(s0)
 158:	0007c783          	lbu	a5,0(a5)
 15c:	fcf709e3          	beq	a4,a5,12e <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
 160:	fe843783          	ld	a5,-24(s0)
 164:	0007c783          	lbu	a5,0(a5)
 168:	0007871b          	sext.w	a4,a5
 16c:	fe043783          	ld	a5,-32(s0)
 170:	0007c783          	lbu	a5,0(a5)
 174:	2781                	sext.w	a5,a5
 176:	40f707bb          	subw	a5,a4,a5
 17a:	2781                	sext.w	a5,a5
}
 17c:	853e                	mv	a0,a5
 17e:	60e2                	ld	ra,24(sp)
 180:	6442                	ld	s0,16(sp)
 182:	6105                	addi	sp,sp,32
 184:	8082                	ret

0000000000000186 <strlen>:

uint
strlen(const char *s)
{
 186:	7179                	addi	sp,sp,-48
 188:	f406                	sd	ra,40(sp)
 18a:	f022                	sd	s0,32(sp)
 18c:	1800                	addi	s0,sp,48
 18e:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
 192:	fe042623          	sw	zero,-20(s0)
 196:	a031                	j	1a2 <strlen+0x1c>
 198:	fec42783          	lw	a5,-20(s0)
 19c:	2785                	addiw	a5,a5,1
 19e:	fef42623          	sw	a5,-20(s0)
 1a2:	fec42783          	lw	a5,-20(s0)
 1a6:	fd843703          	ld	a4,-40(s0)
 1aa:	97ba                	add	a5,a5,a4
 1ac:	0007c783          	lbu	a5,0(a5)
 1b0:	f7e5                	bnez	a5,198 <strlen+0x12>
    ;
  return n;
 1b2:	fec42783          	lw	a5,-20(s0)
}
 1b6:	853e                	mv	a0,a5
 1b8:	70a2                	ld	ra,40(sp)
 1ba:	7402                	ld	s0,32(sp)
 1bc:	6145                	addi	sp,sp,48
 1be:	8082                	ret

00000000000001c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c0:	7179                	addi	sp,sp,-48
 1c2:	f406                	sd	ra,40(sp)
 1c4:	f022                	sd	s0,32(sp)
 1c6:	1800                	addi	s0,sp,48
 1c8:	fca43c23          	sd	a0,-40(s0)
 1cc:	87ae                	mv	a5,a1
 1ce:	8732                	mv	a4,a2
 1d0:	fcf42a23          	sw	a5,-44(s0)
 1d4:	87ba                	mv	a5,a4
 1d6:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
 1da:	fd843783          	ld	a5,-40(s0)
 1de:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
 1e2:	fe042623          	sw	zero,-20(s0)
 1e6:	a00d                	j	208 <memset+0x48>
    cdst[i] = c;
 1e8:	fec42783          	lw	a5,-20(s0)
 1ec:	fe043703          	ld	a4,-32(s0)
 1f0:	97ba                	add	a5,a5,a4
 1f2:	fd442703          	lw	a4,-44(s0)
 1f6:	0ff77713          	zext.b	a4,a4
 1fa:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
 1fe:	fec42783          	lw	a5,-20(s0)
 202:	2785                	addiw	a5,a5,1
 204:	fef42623          	sw	a5,-20(s0)
 208:	fec42783          	lw	a5,-20(s0)
 20c:	fd042703          	lw	a4,-48(s0)
 210:	2701                	sext.w	a4,a4
 212:	fce7ebe3          	bltu	a5,a4,1e8 <memset+0x28>
  }
  return dst;
 216:	fd843783          	ld	a5,-40(s0)
}
 21a:	853e                	mv	a0,a5
 21c:	70a2                	ld	ra,40(sp)
 21e:	7402                	ld	s0,32(sp)
 220:	6145                	addi	sp,sp,48
 222:	8082                	ret

0000000000000224 <strchr>:

char*
strchr(const char *s, char c)
{
 224:	1101                	addi	sp,sp,-32
 226:	ec06                	sd	ra,24(sp)
 228:	e822                	sd	s0,16(sp)
 22a:	1000                	addi	s0,sp,32
 22c:	fea43423          	sd	a0,-24(s0)
 230:	87ae                	mv	a5,a1
 232:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
 236:	a01d                	j	25c <strchr+0x38>
    if(*s == c)
 238:	fe843783          	ld	a5,-24(s0)
 23c:	0007c703          	lbu	a4,0(a5)
 240:	fe744783          	lbu	a5,-25(s0)
 244:	0ff7f793          	zext.b	a5,a5
 248:	00e79563          	bne	a5,a4,252 <strchr+0x2e>
      return (char*)s;
 24c:	fe843783          	ld	a5,-24(s0)
 250:	a821                	j	268 <strchr+0x44>
  for(; *s; s++)
 252:	fe843783          	ld	a5,-24(s0)
 256:	0785                	addi	a5,a5,1
 258:	fef43423          	sd	a5,-24(s0)
 25c:	fe843783          	ld	a5,-24(s0)
 260:	0007c783          	lbu	a5,0(a5)
 264:	fbf1                	bnez	a5,238 <strchr+0x14>
  return 0;
 266:	4781                	li	a5,0
}
 268:	853e                	mv	a0,a5
 26a:	60e2                	ld	ra,24(sp)
 26c:	6442                	ld	s0,16(sp)
 26e:	6105                	addi	sp,sp,32
 270:	8082                	ret

0000000000000272 <gets>:

char*
gets(char *buf, int max)
{
 272:	7179                	addi	sp,sp,-48
 274:	f406                	sd	ra,40(sp)
 276:	f022                	sd	s0,32(sp)
 278:	1800                	addi	s0,sp,48
 27a:	fca43c23          	sd	a0,-40(s0)
 27e:	87ae                	mv	a5,a1
 280:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 284:	fe042623          	sw	zero,-20(s0)
 288:	a8a1                	j	2e0 <gets+0x6e>
    cc = read(0, &c, 1);
 28a:	fe740793          	addi	a5,s0,-25
 28e:	4605                	li	a2,1
 290:	85be                	mv	a1,a5
 292:	4501                	li	a0,0
 294:	00000097          	auipc	ra,0x0
 298:	302080e7          	jalr	770(ra) # 596 <read>
 29c:	87aa                	mv	a5,a0
 29e:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
 2a2:	fe842783          	lw	a5,-24(s0)
 2a6:	2781                	sext.w	a5,a5
 2a8:	04f05663          	blez	a5,2f4 <gets+0x82>
      break;
    buf[i++] = c;
 2ac:	fec42783          	lw	a5,-20(s0)
 2b0:	0017871b          	addiw	a4,a5,1
 2b4:	fee42623          	sw	a4,-20(s0)
 2b8:	873e                	mv	a4,a5
 2ba:	fd843783          	ld	a5,-40(s0)
 2be:	97ba                	add	a5,a5,a4
 2c0:	fe744703          	lbu	a4,-25(s0)
 2c4:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
 2c8:	fe744783          	lbu	a5,-25(s0)
 2cc:	873e                	mv	a4,a5
 2ce:	47a9                	li	a5,10
 2d0:	02f70363          	beq	a4,a5,2f6 <gets+0x84>
 2d4:	fe744783          	lbu	a5,-25(s0)
 2d8:	873e                	mv	a4,a5
 2da:	47b5                	li	a5,13
 2dc:	00f70d63          	beq	a4,a5,2f6 <gets+0x84>
  for(i=0; i+1 < max; ){
 2e0:	fec42783          	lw	a5,-20(s0)
 2e4:	2785                	addiw	a5,a5,1
 2e6:	2781                	sext.w	a5,a5
 2e8:	fd442703          	lw	a4,-44(s0)
 2ec:	2701                	sext.w	a4,a4
 2ee:	f8e7cee3          	blt	a5,a4,28a <gets+0x18>
 2f2:	a011                	j	2f6 <gets+0x84>
      break;
 2f4:	0001                	nop
      break;
  }
  buf[i] = '\0';
 2f6:	fec42783          	lw	a5,-20(s0)
 2fa:	fd843703          	ld	a4,-40(s0)
 2fe:	97ba                	add	a5,a5,a4
 300:	00078023          	sb	zero,0(a5)
  return buf;
 304:	fd843783          	ld	a5,-40(s0)
}
 308:	853e                	mv	a0,a5
 30a:	70a2                	ld	ra,40(sp)
 30c:	7402                	ld	s0,32(sp)
 30e:	6145                	addi	sp,sp,48
 310:	8082                	ret

0000000000000312 <stat>:

int
stat(const char *n, struct stat *st)
{
 312:	7179                	addi	sp,sp,-48
 314:	f406                	sd	ra,40(sp)
 316:	f022                	sd	s0,32(sp)
 318:	1800                	addi	s0,sp,48
 31a:	fca43c23          	sd	a0,-40(s0)
 31e:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 322:	4581                	li	a1,0
 324:	fd843503          	ld	a0,-40(s0)
 328:	00000097          	auipc	ra,0x0
 32c:	296080e7          	jalr	662(ra) # 5be <open>
 330:	87aa                	mv	a5,a0
 332:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
 336:	fec42783          	lw	a5,-20(s0)
 33a:	2781                	sext.w	a5,a5
 33c:	0007d463          	bgez	a5,344 <stat+0x32>
    return -1;
 340:	57fd                	li	a5,-1
 342:	a035                	j	36e <stat+0x5c>
  r = fstat(fd, st);
 344:	fec42783          	lw	a5,-20(s0)
 348:	fd043583          	ld	a1,-48(s0)
 34c:	853e                	mv	a0,a5
 34e:	00000097          	auipc	ra,0x0
 352:	288080e7          	jalr	648(ra) # 5d6 <fstat>
 356:	87aa                	mv	a5,a0
 358:	fef42423          	sw	a5,-24(s0)
  close(fd);
 35c:	fec42783          	lw	a5,-20(s0)
 360:	853e                	mv	a0,a5
 362:	00000097          	auipc	ra,0x0
 366:	244080e7          	jalr	580(ra) # 5a6 <close>
  return r;
 36a:	fe842783          	lw	a5,-24(s0)
}
 36e:	853e                	mv	a0,a5
 370:	70a2                	ld	ra,40(sp)
 372:	7402                	ld	s0,32(sp)
 374:	6145                	addi	sp,sp,48
 376:	8082                	ret

0000000000000378 <atoi>:

int
atoi(const char *s)
{
 378:	7179                	addi	sp,sp,-48
 37a:	f406                	sd	ra,40(sp)
 37c:	f022                	sd	s0,32(sp)
 37e:	1800                	addi	s0,sp,48
 380:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
 384:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
 388:	a81d                	j	3be <atoi+0x46>
    n = n*10 + *s++ - '0';
 38a:	fec42783          	lw	a5,-20(s0)
 38e:	873e                	mv	a4,a5
 390:	87ba                	mv	a5,a4
 392:	0027979b          	slliw	a5,a5,0x2
 396:	9fb9                	addw	a5,a5,a4
 398:	0017979b          	slliw	a5,a5,0x1
 39c:	0007871b          	sext.w	a4,a5
 3a0:	fd843783          	ld	a5,-40(s0)
 3a4:	00178693          	addi	a3,a5,1
 3a8:	fcd43c23          	sd	a3,-40(s0)
 3ac:	0007c783          	lbu	a5,0(a5)
 3b0:	2781                	sext.w	a5,a5
 3b2:	9fb9                	addw	a5,a5,a4
 3b4:	2781                	sext.w	a5,a5
 3b6:	fd07879b          	addiw	a5,a5,-48
 3ba:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
 3be:	fd843783          	ld	a5,-40(s0)
 3c2:	0007c783          	lbu	a5,0(a5)
 3c6:	873e                	mv	a4,a5
 3c8:	02f00793          	li	a5,47
 3cc:	00e7fb63          	bgeu	a5,a4,3e2 <atoi+0x6a>
 3d0:	fd843783          	ld	a5,-40(s0)
 3d4:	0007c783          	lbu	a5,0(a5)
 3d8:	873e                	mv	a4,a5
 3da:	03900793          	li	a5,57
 3de:	fae7f6e3          	bgeu	a5,a4,38a <atoi+0x12>
  return n;
 3e2:	fec42783          	lw	a5,-20(s0)
}
 3e6:	853e                	mv	a0,a5
 3e8:	70a2                	ld	ra,40(sp)
 3ea:	7402                	ld	s0,32(sp)
 3ec:	6145                	addi	sp,sp,48
 3ee:	8082                	ret

00000000000003f0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3f0:	7139                	addi	sp,sp,-64
 3f2:	fc06                	sd	ra,56(sp)
 3f4:	f822                	sd	s0,48(sp)
 3f6:	0080                	addi	s0,sp,64
 3f8:	fca43c23          	sd	a0,-40(s0)
 3fc:	fcb43823          	sd	a1,-48(s0)
 400:	87b2                	mv	a5,a2
 402:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
 406:	fd843783          	ld	a5,-40(s0)
 40a:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
 40e:	fd043783          	ld	a5,-48(s0)
 412:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
 416:	fe043703          	ld	a4,-32(s0)
 41a:	fe843783          	ld	a5,-24(s0)
 41e:	02e7fc63          	bgeu	a5,a4,456 <memmove+0x66>
    while(n-- > 0)
 422:	a00d                	j	444 <memmove+0x54>
      *dst++ = *src++;
 424:	fe043703          	ld	a4,-32(s0)
 428:	00170793          	addi	a5,a4,1
 42c:	fef43023          	sd	a5,-32(s0)
 430:	fe843783          	ld	a5,-24(s0)
 434:	00178693          	addi	a3,a5,1
 438:	fed43423          	sd	a3,-24(s0)
 43c:	00074703          	lbu	a4,0(a4)
 440:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 444:	fcc42783          	lw	a5,-52(s0)
 448:	fff7871b          	addiw	a4,a5,-1
 44c:	fce42623          	sw	a4,-52(s0)
 450:	fcf04ae3          	bgtz	a5,424 <memmove+0x34>
 454:	a891                	j	4a8 <memmove+0xb8>
  } else {
    dst += n;
 456:	fcc42783          	lw	a5,-52(s0)
 45a:	fe843703          	ld	a4,-24(s0)
 45e:	97ba                	add	a5,a5,a4
 460:	fef43423          	sd	a5,-24(s0)
    src += n;
 464:	fcc42783          	lw	a5,-52(s0)
 468:	fe043703          	ld	a4,-32(s0)
 46c:	97ba                	add	a5,a5,a4
 46e:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
 472:	a01d                	j	498 <memmove+0xa8>
      *--dst = *--src;
 474:	fe043783          	ld	a5,-32(s0)
 478:	17fd                	addi	a5,a5,-1
 47a:	fef43023          	sd	a5,-32(s0)
 47e:	fe843783          	ld	a5,-24(s0)
 482:	17fd                	addi	a5,a5,-1
 484:	fef43423          	sd	a5,-24(s0)
 488:	fe043783          	ld	a5,-32(s0)
 48c:	0007c703          	lbu	a4,0(a5)
 490:	fe843783          	ld	a5,-24(s0)
 494:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 498:	fcc42783          	lw	a5,-52(s0)
 49c:	fff7871b          	addiw	a4,a5,-1
 4a0:	fce42623          	sw	a4,-52(s0)
 4a4:	fcf048e3          	bgtz	a5,474 <memmove+0x84>
  }
  return vdst;
 4a8:	fd843783          	ld	a5,-40(s0)
}
 4ac:	853e                	mv	a0,a5
 4ae:	70e2                	ld	ra,56(sp)
 4b0:	7442                	ld	s0,48(sp)
 4b2:	6121                	addi	sp,sp,64
 4b4:	8082                	ret

00000000000004b6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4b6:	7139                	addi	sp,sp,-64
 4b8:	fc06                	sd	ra,56(sp)
 4ba:	f822                	sd	s0,48(sp)
 4bc:	0080                	addi	s0,sp,64
 4be:	fca43c23          	sd	a0,-40(s0)
 4c2:	fcb43823          	sd	a1,-48(s0)
 4c6:	87b2                	mv	a5,a2
 4c8:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
 4cc:	fd843783          	ld	a5,-40(s0)
 4d0:	fef43423          	sd	a5,-24(s0)
 4d4:	fd043783          	ld	a5,-48(s0)
 4d8:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 4dc:	a0a1                	j	524 <memcmp+0x6e>
    if (*p1 != *p2) {
 4de:	fe843783          	ld	a5,-24(s0)
 4e2:	0007c703          	lbu	a4,0(a5)
 4e6:	fe043783          	ld	a5,-32(s0)
 4ea:	0007c783          	lbu	a5,0(a5)
 4ee:	02f70163          	beq	a4,a5,510 <memcmp+0x5a>
      return *p1 - *p2;
 4f2:	fe843783          	ld	a5,-24(s0)
 4f6:	0007c783          	lbu	a5,0(a5)
 4fa:	0007871b          	sext.w	a4,a5
 4fe:	fe043783          	ld	a5,-32(s0)
 502:	0007c783          	lbu	a5,0(a5)
 506:	2781                	sext.w	a5,a5
 508:	40f707bb          	subw	a5,a4,a5
 50c:	2781                	sext.w	a5,a5
 50e:	a01d                	j	534 <memcmp+0x7e>
    }
    p1++;
 510:	fe843783          	ld	a5,-24(s0)
 514:	0785                	addi	a5,a5,1
 516:	fef43423          	sd	a5,-24(s0)
    p2++;
 51a:	fe043783          	ld	a5,-32(s0)
 51e:	0785                	addi	a5,a5,1
 520:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 524:	fcc42783          	lw	a5,-52(s0)
 528:	fff7871b          	addiw	a4,a5,-1
 52c:	fce42623          	sw	a4,-52(s0)
 530:	f7dd                	bnez	a5,4de <memcmp+0x28>
  }
  return 0;
 532:	4781                	li	a5,0
}
 534:	853e                	mv	a0,a5
 536:	70e2                	ld	ra,56(sp)
 538:	7442                	ld	s0,48(sp)
 53a:	6121                	addi	sp,sp,64
 53c:	8082                	ret

000000000000053e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 53e:	7179                	addi	sp,sp,-48
 540:	f406                	sd	ra,40(sp)
 542:	f022                	sd	s0,32(sp)
 544:	1800                	addi	s0,sp,48
 546:	fea43423          	sd	a0,-24(s0)
 54a:	feb43023          	sd	a1,-32(s0)
 54e:	87b2                	mv	a5,a2
 550:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
 554:	fdc42783          	lw	a5,-36(s0)
 558:	863e                	mv	a2,a5
 55a:	fe043583          	ld	a1,-32(s0)
 55e:	fe843503          	ld	a0,-24(s0)
 562:	00000097          	auipc	ra,0x0
 566:	e8e080e7          	jalr	-370(ra) # 3f0 <memmove>
 56a:	87aa                	mv	a5,a0
}
 56c:	853e                	mv	a0,a5
 56e:	70a2                	ld	ra,40(sp)
 570:	7402                	ld	s0,32(sp)
 572:	6145                	addi	sp,sp,48
 574:	8082                	ret

0000000000000576 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 576:	4885                	li	a7,1
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <exit>:
.global exit
exit:
 li a7, SYS_exit
 57e:	4889                	li	a7,2
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <wait>:
.global wait
wait:
 li a7, SYS_wait
 586:	488d                	li	a7,3
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 58e:	4891                	li	a7,4
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <read>:
.global read
read:
 li a7, SYS_read
 596:	4895                	li	a7,5
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <write>:
.global write
write:
 li a7, SYS_write
 59e:	48c1                	li	a7,16
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <close>:
.global close
close:
 li a7, SYS_close
 5a6:	48d5                	li	a7,21
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <kill>:
.global kill
kill:
 li a7, SYS_kill
 5ae:	4899                	li	a7,6
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5b6:	489d                	li	a7,7
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <open>:
.global open
open:
 li a7, SYS_open
 5be:	48bd                	li	a7,15
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5c6:	48c5                	li	a7,17
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5ce:	48c9                	li	a7,18
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5d6:	48a1                	li	a7,8
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <link>:
.global link
link:
 li a7, SYS_link
 5de:	48cd                	li	a7,19
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	8082                	ret

00000000000005e6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5e6:	48d1                	li	a7,20
 ecall
 5e8:	00000073          	ecall
 ret
 5ec:	8082                	ret

00000000000005ee <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5ee:	48a5                	li	a7,9
 ecall
 5f0:	00000073          	ecall
 ret
 5f4:	8082                	ret

00000000000005f6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5f6:	48a9                	li	a7,10
 ecall
 5f8:	00000073          	ecall
 ret
 5fc:	8082                	ret

00000000000005fe <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5fe:	48ad                	li	a7,11
 ecall
 600:	00000073          	ecall
 ret
 604:	8082                	ret

0000000000000606 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 606:	48b1                	li	a7,12
 ecall
 608:	00000073          	ecall
 ret
 60c:	8082                	ret

000000000000060e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 60e:	48b5                	li	a7,13
 ecall
 610:	00000073          	ecall
 ret
 614:	8082                	ret

0000000000000616 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 616:	48b9                	li	a7,14
 ecall
 618:	00000073          	ecall
 ret
 61c:	8082                	ret

000000000000061e <ps>:
.global ps
ps:
 li a7, SYS_ps
 61e:	48d9                	li	a7,22
 ecall
 620:	00000073          	ecall
 ret
 624:	8082                	ret

0000000000000626 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 626:	1101                	addi	sp,sp,-32
 628:	ec06                	sd	ra,24(sp)
 62a:	e822                	sd	s0,16(sp)
 62c:	1000                	addi	s0,sp,32
 62e:	87aa                	mv	a5,a0
 630:	872e                	mv	a4,a1
 632:	fef42623          	sw	a5,-20(s0)
 636:	87ba                	mv	a5,a4
 638:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 63c:	feb40713          	addi	a4,s0,-21
 640:	fec42783          	lw	a5,-20(s0)
 644:	4605                	li	a2,1
 646:	85ba                	mv	a1,a4
 648:	853e                	mv	a0,a5
 64a:	00000097          	auipc	ra,0x0
 64e:	f54080e7          	jalr	-172(ra) # 59e <write>
}
 652:	0001                	nop
 654:	60e2                	ld	ra,24(sp)
 656:	6442                	ld	s0,16(sp)
 658:	6105                	addi	sp,sp,32
 65a:	8082                	ret

000000000000065c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 65c:	7139                	addi	sp,sp,-64
 65e:	fc06                	sd	ra,56(sp)
 660:	f822                	sd	s0,48(sp)
 662:	0080                	addi	s0,sp,64
 664:	87aa                	mv	a5,a0
 666:	8736                	mv	a4,a3
 668:	fcf42623          	sw	a5,-52(s0)
 66c:	87ae                	mv	a5,a1
 66e:	fcf42423          	sw	a5,-56(s0)
 672:	87b2                	mv	a5,a2
 674:	fcf42223          	sw	a5,-60(s0)
 678:	87ba                	mv	a5,a4
 67a:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 67e:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 682:	fc042783          	lw	a5,-64(s0)
 686:	2781                	sext.w	a5,a5
 688:	c38d                	beqz	a5,6aa <printint+0x4e>
 68a:	fc842783          	lw	a5,-56(s0)
 68e:	2781                	sext.w	a5,a5
 690:	0007dd63          	bgez	a5,6aa <printint+0x4e>
    neg = 1;
 694:	4785                	li	a5,1
 696:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 69a:	fc842783          	lw	a5,-56(s0)
 69e:	40f007bb          	negw	a5,a5
 6a2:	2781                	sext.w	a5,a5
 6a4:	fef42223          	sw	a5,-28(s0)
 6a8:	a029                	j	6b2 <printint+0x56>
  } else {
    x = xx;
 6aa:	fc842783          	lw	a5,-56(s0)
 6ae:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 6b2:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 6b6:	fc442783          	lw	a5,-60(s0)
 6ba:	fe442703          	lw	a4,-28(s0)
 6be:	02f777bb          	remuw	a5,a4,a5
 6c2:	0007871b          	sext.w	a4,a5
 6c6:	fec42783          	lw	a5,-20(s0)
 6ca:	0017869b          	addiw	a3,a5,1
 6ce:	fed42623          	sw	a3,-20(s0)
 6d2:	00001697          	auipc	a3,0x1
 6d6:	92e68693          	addi	a3,a3,-1746 # 1000 <digits>
 6da:	1702                	slli	a4,a4,0x20
 6dc:	9301                	srli	a4,a4,0x20
 6de:	9736                	add	a4,a4,a3
 6e0:	00074703          	lbu	a4,0(a4)
 6e4:	17c1                	addi	a5,a5,-16
 6e6:	97a2                	add	a5,a5,s0
 6e8:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 6ec:	fc442783          	lw	a5,-60(s0)
 6f0:	fe442703          	lw	a4,-28(s0)
 6f4:	02f757bb          	divuw	a5,a4,a5
 6f8:	fef42223          	sw	a5,-28(s0)
 6fc:	fe442783          	lw	a5,-28(s0)
 700:	2781                	sext.w	a5,a5
 702:	fbd5                	bnez	a5,6b6 <printint+0x5a>
  if(neg)
 704:	fe842783          	lw	a5,-24(s0)
 708:	2781                	sext.w	a5,a5
 70a:	cf85                	beqz	a5,742 <printint+0xe6>
    buf[i++] = '-';
 70c:	fec42783          	lw	a5,-20(s0)
 710:	0017871b          	addiw	a4,a5,1
 714:	fee42623          	sw	a4,-20(s0)
 718:	17c1                	addi	a5,a5,-16
 71a:	97a2                	add	a5,a5,s0
 71c:	02d00713          	li	a4,45
 720:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 724:	a839                	j	742 <printint+0xe6>
    putc(fd, buf[i]);
 726:	fec42783          	lw	a5,-20(s0)
 72a:	17c1                	addi	a5,a5,-16
 72c:	97a2                	add	a5,a5,s0
 72e:	fe07c703          	lbu	a4,-32(a5)
 732:	fcc42783          	lw	a5,-52(s0)
 736:	85ba                	mv	a1,a4
 738:	853e                	mv	a0,a5
 73a:	00000097          	auipc	ra,0x0
 73e:	eec080e7          	jalr	-276(ra) # 626 <putc>
  while(--i >= 0)
 742:	fec42783          	lw	a5,-20(s0)
 746:	37fd                	addiw	a5,a5,-1
 748:	fef42623          	sw	a5,-20(s0)
 74c:	fec42783          	lw	a5,-20(s0)
 750:	2781                	sext.w	a5,a5
 752:	fc07dae3          	bgez	a5,726 <printint+0xca>
}
 756:	0001                	nop
 758:	0001                	nop
 75a:	70e2                	ld	ra,56(sp)
 75c:	7442                	ld	s0,48(sp)
 75e:	6121                	addi	sp,sp,64
 760:	8082                	ret

0000000000000762 <printptr>:

static void
printptr(int fd, uint64 x) {
 762:	7179                	addi	sp,sp,-48
 764:	f406                	sd	ra,40(sp)
 766:	f022                	sd	s0,32(sp)
 768:	1800                	addi	s0,sp,48
 76a:	87aa                	mv	a5,a0
 76c:	fcb43823          	sd	a1,-48(s0)
 770:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 774:	fdc42783          	lw	a5,-36(s0)
 778:	03000593          	li	a1,48
 77c:	853e                	mv	a0,a5
 77e:	00000097          	auipc	ra,0x0
 782:	ea8080e7          	jalr	-344(ra) # 626 <putc>
  putc(fd, 'x');
 786:	fdc42783          	lw	a5,-36(s0)
 78a:	07800593          	li	a1,120
 78e:	853e                	mv	a0,a5
 790:	00000097          	auipc	ra,0x0
 794:	e96080e7          	jalr	-362(ra) # 626 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 798:	fe042623          	sw	zero,-20(s0)
 79c:	a82d                	j	7d6 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 79e:	fd043783          	ld	a5,-48(s0)
 7a2:	93f1                	srli	a5,a5,0x3c
 7a4:	00001717          	auipc	a4,0x1
 7a8:	85c70713          	addi	a4,a4,-1956 # 1000 <digits>
 7ac:	97ba                	add	a5,a5,a4
 7ae:	0007c703          	lbu	a4,0(a5)
 7b2:	fdc42783          	lw	a5,-36(s0)
 7b6:	85ba                	mv	a1,a4
 7b8:	853e                	mv	a0,a5
 7ba:	00000097          	auipc	ra,0x0
 7be:	e6c080e7          	jalr	-404(ra) # 626 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7c2:	fec42783          	lw	a5,-20(s0)
 7c6:	2785                	addiw	a5,a5,1
 7c8:	fef42623          	sw	a5,-20(s0)
 7cc:	fd043783          	ld	a5,-48(s0)
 7d0:	0792                	slli	a5,a5,0x4
 7d2:	fcf43823          	sd	a5,-48(s0)
 7d6:	fec42703          	lw	a4,-20(s0)
 7da:	47bd                	li	a5,15
 7dc:	fce7f1e3          	bgeu	a5,a4,79e <printptr+0x3c>
}
 7e0:	0001                	nop
 7e2:	0001                	nop
 7e4:	70a2                	ld	ra,40(sp)
 7e6:	7402                	ld	s0,32(sp)
 7e8:	6145                	addi	sp,sp,48
 7ea:	8082                	ret

00000000000007ec <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7ec:	715d                	addi	sp,sp,-80
 7ee:	e486                	sd	ra,72(sp)
 7f0:	e0a2                	sd	s0,64(sp)
 7f2:	0880                	addi	s0,sp,80
 7f4:	87aa                	mv	a5,a0
 7f6:	fcb43023          	sd	a1,-64(s0)
 7fa:	fac43c23          	sd	a2,-72(s0)
 7fe:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 802:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 806:	fe042223          	sw	zero,-28(s0)
 80a:	a42d                	j	a34 <vprintf+0x248>
    c = fmt[i] & 0xff;
 80c:	fe442783          	lw	a5,-28(s0)
 810:	fc043703          	ld	a4,-64(s0)
 814:	97ba                	add	a5,a5,a4
 816:	0007c783          	lbu	a5,0(a5)
 81a:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 81e:	fe042783          	lw	a5,-32(s0)
 822:	2781                	sext.w	a5,a5
 824:	eb9d                	bnez	a5,85a <vprintf+0x6e>
      if(c == '%'){
 826:	fdc42783          	lw	a5,-36(s0)
 82a:	0007871b          	sext.w	a4,a5
 82e:	02500793          	li	a5,37
 832:	00f71763          	bne	a4,a5,840 <vprintf+0x54>
        state = '%';
 836:	02500793          	li	a5,37
 83a:	fef42023          	sw	a5,-32(s0)
 83e:	a2f5                	j	a2a <vprintf+0x23e>
      } else {
        putc(fd, c);
 840:	fdc42783          	lw	a5,-36(s0)
 844:	0ff7f713          	zext.b	a4,a5
 848:	fcc42783          	lw	a5,-52(s0)
 84c:	85ba                	mv	a1,a4
 84e:	853e                	mv	a0,a5
 850:	00000097          	auipc	ra,0x0
 854:	dd6080e7          	jalr	-554(ra) # 626 <putc>
 858:	aac9                	j	a2a <vprintf+0x23e>
      }
    } else if(state == '%'){
 85a:	fe042783          	lw	a5,-32(s0)
 85e:	0007871b          	sext.w	a4,a5
 862:	02500793          	li	a5,37
 866:	1cf71263          	bne	a4,a5,a2a <vprintf+0x23e>
      if(c == 'd'){
 86a:	fdc42783          	lw	a5,-36(s0)
 86e:	0007871b          	sext.w	a4,a5
 872:	06400793          	li	a5,100
 876:	02f71463          	bne	a4,a5,89e <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 87a:	fb843783          	ld	a5,-72(s0)
 87e:	00878713          	addi	a4,a5,8
 882:	fae43c23          	sd	a4,-72(s0)
 886:	4398                	lw	a4,0(a5)
 888:	fcc42783          	lw	a5,-52(s0)
 88c:	4685                	li	a3,1
 88e:	4629                	li	a2,10
 890:	85ba                	mv	a1,a4
 892:	853e                	mv	a0,a5
 894:	00000097          	auipc	ra,0x0
 898:	dc8080e7          	jalr	-568(ra) # 65c <printint>
 89c:	a269                	j	a26 <vprintf+0x23a>
      } else if(c == 'l') {
 89e:	fdc42783          	lw	a5,-36(s0)
 8a2:	0007871b          	sext.w	a4,a5
 8a6:	06c00793          	li	a5,108
 8aa:	02f71663          	bne	a4,a5,8d6 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8ae:	fb843783          	ld	a5,-72(s0)
 8b2:	00878713          	addi	a4,a5,8
 8b6:	fae43c23          	sd	a4,-72(s0)
 8ba:	639c                	ld	a5,0(a5)
 8bc:	0007871b          	sext.w	a4,a5
 8c0:	fcc42783          	lw	a5,-52(s0)
 8c4:	4681                	li	a3,0
 8c6:	4629                	li	a2,10
 8c8:	85ba                	mv	a1,a4
 8ca:	853e                	mv	a0,a5
 8cc:	00000097          	auipc	ra,0x0
 8d0:	d90080e7          	jalr	-624(ra) # 65c <printint>
 8d4:	aa89                	j	a26 <vprintf+0x23a>
      } else if(c == 'x') {
 8d6:	fdc42783          	lw	a5,-36(s0)
 8da:	0007871b          	sext.w	a4,a5
 8de:	07800793          	li	a5,120
 8e2:	02f71463          	bne	a4,a5,90a <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 8e6:	fb843783          	ld	a5,-72(s0)
 8ea:	00878713          	addi	a4,a5,8
 8ee:	fae43c23          	sd	a4,-72(s0)
 8f2:	4398                	lw	a4,0(a5)
 8f4:	fcc42783          	lw	a5,-52(s0)
 8f8:	4681                	li	a3,0
 8fa:	4641                	li	a2,16
 8fc:	85ba                	mv	a1,a4
 8fe:	853e                	mv	a0,a5
 900:	00000097          	auipc	ra,0x0
 904:	d5c080e7          	jalr	-676(ra) # 65c <printint>
 908:	aa39                	j	a26 <vprintf+0x23a>
      } else if(c == 'p') {
 90a:	fdc42783          	lw	a5,-36(s0)
 90e:	0007871b          	sext.w	a4,a5
 912:	07000793          	li	a5,112
 916:	02f71263          	bne	a4,a5,93a <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 91a:	fb843783          	ld	a5,-72(s0)
 91e:	00878713          	addi	a4,a5,8
 922:	fae43c23          	sd	a4,-72(s0)
 926:	6398                	ld	a4,0(a5)
 928:	fcc42783          	lw	a5,-52(s0)
 92c:	85ba                	mv	a1,a4
 92e:	853e                	mv	a0,a5
 930:	00000097          	auipc	ra,0x0
 934:	e32080e7          	jalr	-462(ra) # 762 <printptr>
 938:	a0fd                	j	a26 <vprintf+0x23a>
      } else if(c == 's'){
 93a:	fdc42783          	lw	a5,-36(s0)
 93e:	0007871b          	sext.w	a4,a5
 942:	07300793          	li	a5,115
 946:	04f71c63          	bne	a4,a5,99e <vprintf+0x1b2>
        s = va_arg(ap, char*);
 94a:	fb843783          	ld	a5,-72(s0)
 94e:	00878713          	addi	a4,a5,8
 952:	fae43c23          	sd	a4,-72(s0)
 956:	639c                	ld	a5,0(a5)
 958:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 95c:	fe843783          	ld	a5,-24(s0)
 960:	eb8d                	bnez	a5,992 <vprintf+0x1a6>
          s = "(null)";
 962:	00000797          	auipc	a5,0x0
 966:	48e78793          	addi	a5,a5,1166 # df0 <malloc+0x152>
 96a:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 96e:	a015                	j	992 <vprintf+0x1a6>
          putc(fd, *s);
 970:	fe843783          	ld	a5,-24(s0)
 974:	0007c703          	lbu	a4,0(a5)
 978:	fcc42783          	lw	a5,-52(s0)
 97c:	85ba                	mv	a1,a4
 97e:	853e                	mv	a0,a5
 980:	00000097          	auipc	ra,0x0
 984:	ca6080e7          	jalr	-858(ra) # 626 <putc>
          s++;
 988:	fe843783          	ld	a5,-24(s0)
 98c:	0785                	addi	a5,a5,1
 98e:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 992:	fe843783          	ld	a5,-24(s0)
 996:	0007c783          	lbu	a5,0(a5)
 99a:	fbf9                	bnez	a5,970 <vprintf+0x184>
 99c:	a069                	j	a26 <vprintf+0x23a>
        }
      } else if(c == 'c'){
 99e:	fdc42783          	lw	a5,-36(s0)
 9a2:	0007871b          	sext.w	a4,a5
 9a6:	06300793          	li	a5,99
 9aa:	02f71463          	bne	a4,a5,9d2 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 9ae:	fb843783          	ld	a5,-72(s0)
 9b2:	00878713          	addi	a4,a5,8
 9b6:	fae43c23          	sd	a4,-72(s0)
 9ba:	439c                	lw	a5,0(a5)
 9bc:	0ff7f713          	zext.b	a4,a5
 9c0:	fcc42783          	lw	a5,-52(s0)
 9c4:	85ba                	mv	a1,a4
 9c6:	853e                	mv	a0,a5
 9c8:	00000097          	auipc	ra,0x0
 9cc:	c5e080e7          	jalr	-930(ra) # 626 <putc>
 9d0:	a899                	j	a26 <vprintf+0x23a>
      } else if(c == '%'){
 9d2:	fdc42783          	lw	a5,-36(s0)
 9d6:	0007871b          	sext.w	a4,a5
 9da:	02500793          	li	a5,37
 9de:	00f71f63          	bne	a4,a5,9fc <vprintf+0x210>
        putc(fd, c);
 9e2:	fdc42783          	lw	a5,-36(s0)
 9e6:	0ff7f713          	zext.b	a4,a5
 9ea:	fcc42783          	lw	a5,-52(s0)
 9ee:	85ba                	mv	a1,a4
 9f0:	853e                	mv	a0,a5
 9f2:	00000097          	auipc	ra,0x0
 9f6:	c34080e7          	jalr	-972(ra) # 626 <putc>
 9fa:	a035                	j	a26 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9fc:	fcc42783          	lw	a5,-52(s0)
 a00:	02500593          	li	a1,37
 a04:	853e                	mv	a0,a5
 a06:	00000097          	auipc	ra,0x0
 a0a:	c20080e7          	jalr	-992(ra) # 626 <putc>
        putc(fd, c);
 a0e:	fdc42783          	lw	a5,-36(s0)
 a12:	0ff7f713          	zext.b	a4,a5
 a16:	fcc42783          	lw	a5,-52(s0)
 a1a:	85ba                	mv	a1,a4
 a1c:	853e                	mv	a0,a5
 a1e:	00000097          	auipc	ra,0x0
 a22:	c08080e7          	jalr	-1016(ra) # 626 <putc>
      }
      state = 0;
 a26:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 a2a:	fe442783          	lw	a5,-28(s0)
 a2e:	2785                	addiw	a5,a5,1
 a30:	fef42223          	sw	a5,-28(s0)
 a34:	fe442783          	lw	a5,-28(s0)
 a38:	fc043703          	ld	a4,-64(s0)
 a3c:	97ba                	add	a5,a5,a4
 a3e:	0007c783          	lbu	a5,0(a5)
 a42:	dc0795e3          	bnez	a5,80c <vprintf+0x20>
    }
  }
}
 a46:	0001                	nop
 a48:	0001                	nop
 a4a:	60a6                	ld	ra,72(sp)
 a4c:	6406                	ld	s0,64(sp)
 a4e:	6161                	addi	sp,sp,80
 a50:	8082                	ret

0000000000000a52 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a52:	7159                	addi	sp,sp,-112
 a54:	fc06                	sd	ra,56(sp)
 a56:	f822                	sd	s0,48(sp)
 a58:	0080                	addi	s0,sp,64
 a5a:	fcb43823          	sd	a1,-48(s0)
 a5e:	e010                	sd	a2,0(s0)
 a60:	e414                	sd	a3,8(s0)
 a62:	e818                	sd	a4,16(s0)
 a64:	ec1c                	sd	a5,24(s0)
 a66:	03043023          	sd	a6,32(s0)
 a6a:	03143423          	sd	a7,40(s0)
 a6e:	87aa                	mv	a5,a0
 a70:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 a74:	03040793          	addi	a5,s0,48
 a78:	fcf43423          	sd	a5,-56(s0)
 a7c:	fc843783          	ld	a5,-56(s0)
 a80:	fd078793          	addi	a5,a5,-48
 a84:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 a88:	fe843703          	ld	a4,-24(s0)
 a8c:	fdc42783          	lw	a5,-36(s0)
 a90:	863a                	mv	a2,a4
 a92:	fd043583          	ld	a1,-48(s0)
 a96:	853e                	mv	a0,a5
 a98:	00000097          	auipc	ra,0x0
 a9c:	d54080e7          	jalr	-684(ra) # 7ec <vprintf>
}
 aa0:	0001                	nop
 aa2:	70e2                	ld	ra,56(sp)
 aa4:	7442                	ld	s0,48(sp)
 aa6:	6165                	addi	sp,sp,112
 aa8:	8082                	ret

0000000000000aaa <printf>:

void
printf(const char *fmt, ...)
{
 aaa:	7159                	addi	sp,sp,-112
 aac:	f406                	sd	ra,40(sp)
 aae:	f022                	sd	s0,32(sp)
 ab0:	1800                	addi	s0,sp,48
 ab2:	fca43c23          	sd	a0,-40(s0)
 ab6:	e40c                	sd	a1,8(s0)
 ab8:	e810                	sd	a2,16(s0)
 aba:	ec14                	sd	a3,24(s0)
 abc:	f018                	sd	a4,32(s0)
 abe:	f41c                	sd	a5,40(s0)
 ac0:	03043823          	sd	a6,48(s0)
 ac4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 ac8:	04040793          	addi	a5,s0,64
 acc:	fcf43823          	sd	a5,-48(s0)
 ad0:	fd043783          	ld	a5,-48(s0)
 ad4:	fc878793          	addi	a5,a5,-56
 ad8:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 adc:	fe843783          	ld	a5,-24(s0)
 ae0:	863e                	mv	a2,a5
 ae2:	fd843583          	ld	a1,-40(s0)
 ae6:	4505                	li	a0,1
 ae8:	00000097          	auipc	ra,0x0
 aec:	d04080e7          	jalr	-764(ra) # 7ec <vprintf>
}
 af0:	0001                	nop
 af2:	70a2                	ld	ra,40(sp)
 af4:	7402                	ld	s0,32(sp)
 af6:	6165                	addi	sp,sp,112
 af8:	8082                	ret

0000000000000afa <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 afa:	7179                	addi	sp,sp,-48
 afc:	f406                	sd	ra,40(sp)
 afe:	f022                	sd	s0,32(sp)
 b00:	1800                	addi	s0,sp,48
 b02:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b06:	fd843783          	ld	a5,-40(s0)
 b0a:	17c1                	addi	a5,a5,-16
 b0c:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b10:	00000797          	auipc	a5,0x0
 b14:	52078793          	addi	a5,a5,1312 # 1030 <freep>
 b18:	639c                	ld	a5,0(a5)
 b1a:	fef43423          	sd	a5,-24(s0)
 b1e:	a815                	j	b52 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b20:	fe843783          	ld	a5,-24(s0)
 b24:	639c                	ld	a5,0(a5)
 b26:	fe843703          	ld	a4,-24(s0)
 b2a:	00f76f63          	bltu	a4,a5,b48 <free+0x4e>
 b2e:	fe043703          	ld	a4,-32(s0)
 b32:	fe843783          	ld	a5,-24(s0)
 b36:	02e7eb63          	bltu	a5,a4,b6c <free+0x72>
 b3a:	fe843783          	ld	a5,-24(s0)
 b3e:	639c                	ld	a5,0(a5)
 b40:	fe043703          	ld	a4,-32(s0)
 b44:	02f76463          	bltu	a4,a5,b6c <free+0x72>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b48:	fe843783          	ld	a5,-24(s0)
 b4c:	639c                	ld	a5,0(a5)
 b4e:	fef43423          	sd	a5,-24(s0)
 b52:	fe043703          	ld	a4,-32(s0)
 b56:	fe843783          	ld	a5,-24(s0)
 b5a:	fce7f3e3          	bgeu	a5,a4,b20 <free+0x26>
 b5e:	fe843783          	ld	a5,-24(s0)
 b62:	639c                	ld	a5,0(a5)
 b64:	fe043703          	ld	a4,-32(s0)
 b68:	faf77ce3          	bgeu	a4,a5,b20 <free+0x26>
      break;
  if(bp + bp->s.size == p->s.ptr){
 b6c:	fe043783          	ld	a5,-32(s0)
 b70:	479c                	lw	a5,8(a5)
 b72:	1782                	slli	a5,a5,0x20
 b74:	9381                	srli	a5,a5,0x20
 b76:	0792                	slli	a5,a5,0x4
 b78:	fe043703          	ld	a4,-32(s0)
 b7c:	973e                	add	a4,a4,a5
 b7e:	fe843783          	ld	a5,-24(s0)
 b82:	639c                	ld	a5,0(a5)
 b84:	02f71763          	bne	a4,a5,bb2 <free+0xb8>
    bp->s.size += p->s.ptr->s.size;
 b88:	fe043783          	ld	a5,-32(s0)
 b8c:	4798                	lw	a4,8(a5)
 b8e:	fe843783          	ld	a5,-24(s0)
 b92:	639c                	ld	a5,0(a5)
 b94:	479c                	lw	a5,8(a5)
 b96:	9fb9                	addw	a5,a5,a4
 b98:	0007871b          	sext.w	a4,a5
 b9c:	fe043783          	ld	a5,-32(s0)
 ba0:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 ba2:	fe843783          	ld	a5,-24(s0)
 ba6:	639c                	ld	a5,0(a5)
 ba8:	6398                	ld	a4,0(a5)
 baa:	fe043783          	ld	a5,-32(s0)
 bae:	e398                	sd	a4,0(a5)
 bb0:	a039                	j	bbe <free+0xc4>
  } else
    bp->s.ptr = p->s.ptr;
 bb2:	fe843783          	ld	a5,-24(s0)
 bb6:	6398                	ld	a4,0(a5)
 bb8:	fe043783          	ld	a5,-32(s0)
 bbc:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 bbe:	fe843783          	ld	a5,-24(s0)
 bc2:	479c                	lw	a5,8(a5)
 bc4:	1782                	slli	a5,a5,0x20
 bc6:	9381                	srli	a5,a5,0x20
 bc8:	0792                	slli	a5,a5,0x4
 bca:	fe843703          	ld	a4,-24(s0)
 bce:	97ba                	add	a5,a5,a4
 bd0:	fe043703          	ld	a4,-32(s0)
 bd4:	02f71563          	bne	a4,a5,bfe <free+0x104>
    p->s.size += bp->s.size;
 bd8:	fe843783          	ld	a5,-24(s0)
 bdc:	4798                	lw	a4,8(a5)
 bde:	fe043783          	ld	a5,-32(s0)
 be2:	479c                	lw	a5,8(a5)
 be4:	9fb9                	addw	a5,a5,a4
 be6:	0007871b          	sext.w	a4,a5
 bea:	fe843783          	ld	a5,-24(s0)
 bee:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 bf0:	fe043783          	ld	a5,-32(s0)
 bf4:	6398                	ld	a4,0(a5)
 bf6:	fe843783          	ld	a5,-24(s0)
 bfa:	e398                	sd	a4,0(a5)
 bfc:	a031                	j	c08 <free+0x10e>
  } else
    p->s.ptr = bp;
 bfe:	fe843783          	ld	a5,-24(s0)
 c02:	fe043703          	ld	a4,-32(s0)
 c06:	e398                	sd	a4,0(a5)
  freep = p;
 c08:	00000797          	auipc	a5,0x0
 c0c:	42878793          	addi	a5,a5,1064 # 1030 <freep>
 c10:	fe843703          	ld	a4,-24(s0)
 c14:	e398                	sd	a4,0(a5)
}
 c16:	0001                	nop
 c18:	70a2                	ld	ra,40(sp)
 c1a:	7402                	ld	s0,32(sp)
 c1c:	6145                	addi	sp,sp,48
 c1e:	8082                	ret

0000000000000c20 <morecore>:

static Header*
morecore(uint nu)
{
 c20:	7179                	addi	sp,sp,-48
 c22:	f406                	sd	ra,40(sp)
 c24:	f022                	sd	s0,32(sp)
 c26:	1800                	addi	s0,sp,48
 c28:	87aa                	mv	a5,a0
 c2a:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 c2e:	fdc42783          	lw	a5,-36(s0)
 c32:	0007871b          	sext.w	a4,a5
 c36:	6785                	lui	a5,0x1
 c38:	00f77563          	bgeu	a4,a5,c42 <morecore+0x22>
    nu = 4096;
 c3c:	6785                	lui	a5,0x1
 c3e:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 c42:	fdc42783          	lw	a5,-36(s0)
 c46:	0047979b          	slliw	a5,a5,0x4
 c4a:	2781                	sext.w	a5,a5
 c4c:	853e                	mv	a0,a5
 c4e:	00000097          	auipc	ra,0x0
 c52:	9b8080e7          	jalr	-1608(ra) # 606 <sbrk>
 c56:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 c5a:	fe843703          	ld	a4,-24(s0)
 c5e:	57fd                	li	a5,-1
 c60:	00f71463          	bne	a4,a5,c68 <morecore+0x48>
    return 0;
 c64:	4781                	li	a5,0
 c66:	a03d                	j	c94 <morecore+0x74>
  hp = (Header*)p;
 c68:	fe843783          	ld	a5,-24(s0)
 c6c:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 c70:	fe043783          	ld	a5,-32(s0)
 c74:	fdc42703          	lw	a4,-36(s0)
 c78:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 c7a:	fe043783          	ld	a5,-32(s0)
 c7e:	07c1                	addi	a5,a5,16 # 1010 <digits+0x10>
 c80:	853e                	mv	a0,a5
 c82:	00000097          	auipc	ra,0x0
 c86:	e78080e7          	jalr	-392(ra) # afa <free>
  return freep;
 c8a:	00000797          	auipc	a5,0x0
 c8e:	3a678793          	addi	a5,a5,934 # 1030 <freep>
 c92:	639c                	ld	a5,0(a5)
}
 c94:	853e                	mv	a0,a5
 c96:	70a2                	ld	ra,40(sp)
 c98:	7402                	ld	s0,32(sp)
 c9a:	6145                	addi	sp,sp,48
 c9c:	8082                	ret

0000000000000c9e <malloc>:

void*
malloc(uint nbytes)
{
 c9e:	7139                	addi	sp,sp,-64
 ca0:	fc06                	sd	ra,56(sp)
 ca2:	f822                	sd	s0,48(sp)
 ca4:	0080                	addi	s0,sp,64
 ca6:	87aa                	mv	a5,a0
 ca8:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 cac:	fcc46783          	lwu	a5,-52(s0)
 cb0:	07bd                	addi	a5,a5,15
 cb2:	8391                	srli	a5,a5,0x4
 cb4:	2781                	sext.w	a5,a5
 cb6:	2785                	addiw	a5,a5,1
 cb8:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 cbc:	00000797          	auipc	a5,0x0
 cc0:	37478793          	addi	a5,a5,884 # 1030 <freep>
 cc4:	639c                	ld	a5,0(a5)
 cc6:	fef43023          	sd	a5,-32(s0)
 cca:	fe043783          	ld	a5,-32(s0)
 cce:	ef95                	bnez	a5,d0a <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 cd0:	00000797          	auipc	a5,0x0
 cd4:	35078793          	addi	a5,a5,848 # 1020 <base>
 cd8:	fef43023          	sd	a5,-32(s0)
 cdc:	00000797          	auipc	a5,0x0
 ce0:	35478793          	addi	a5,a5,852 # 1030 <freep>
 ce4:	fe043703          	ld	a4,-32(s0)
 ce8:	e398                	sd	a4,0(a5)
 cea:	00000797          	auipc	a5,0x0
 cee:	34678793          	addi	a5,a5,838 # 1030 <freep>
 cf2:	6398                	ld	a4,0(a5)
 cf4:	00000797          	auipc	a5,0x0
 cf8:	32c78793          	addi	a5,a5,812 # 1020 <base>
 cfc:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 cfe:	00000797          	auipc	a5,0x0
 d02:	32278793          	addi	a5,a5,802 # 1020 <base>
 d06:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d0a:	fe043783          	ld	a5,-32(s0)
 d0e:	639c                	ld	a5,0(a5)
 d10:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 d14:	fe843783          	ld	a5,-24(s0)
 d18:	479c                	lw	a5,8(a5)
 d1a:	fdc42703          	lw	a4,-36(s0)
 d1e:	2701                	sext.w	a4,a4
 d20:	06e7e763          	bltu	a5,a4,d8e <malloc+0xf0>
      if(p->s.size == nunits)
 d24:	fe843783          	ld	a5,-24(s0)
 d28:	479c                	lw	a5,8(a5)
 d2a:	fdc42703          	lw	a4,-36(s0)
 d2e:	2701                	sext.w	a4,a4
 d30:	00f71963          	bne	a4,a5,d42 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 d34:	fe843783          	ld	a5,-24(s0)
 d38:	6398                	ld	a4,0(a5)
 d3a:	fe043783          	ld	a5,-32(s0)
 d3e:	e398                	sd	a4,0(a5)
 d40:	a825                	j	d78 <malloc+0xda>
      else {
        p->s.size -= nunits;
 d42:	fe843783          	ld	a5,-24(s0)
 d46:	479c                	lw	a5,8(a5)
 d48:	fdc42703          	lw	a4,-36(s0)
 d4c:	9f99                	subw	a5,a5,a4
 d4e:	0007871b          	sext.w	a4,a5
 d52:	fe843783          	ld	a5,-24(s0)
 d56:	c798                	sw	a4,8(a5)
        p += p->s.size;
 d58:	fe843783          	ld	a5,-24(s0)
 d5c:	479c                	lw	a5,8(a5)
 d5e:	1782                	slli	a5,a5,0x20
 d60:	9381                	srli	a5,a5,0x20
 d62:	0792                	slli	a5,a5,0x4
 d64:	fe843703          	ld	a4,-24(s0)
 d68:	97ba                	add	a5,a5,a4
 d6a:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 d6e:	fe843783          	ld	a5,-24(s0)
 d72:	fdc42703          	lw	a4,-36(s0)
 d76:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 d78:	00000797          	auipc	a5,0x0
 d7c:	2b878793          	addi	a5,a5,696 # 1030 <freep>
 d80:	fe043703          	ld	a4,-32(s0)
 d84:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 d86:	fe843783          	ld	a5,-24(s0)
 d8a:	07c1                	addi	a5,a5,16
 d8c:	a091                	j	dd0 <malloc+0x132>
    }
    if(p == freep)
 d8e:	00000797          	auipc	a5,0x0
 d92:	2a278793          	addi	a5,a5,674 # 1030 <freep>
 d96:	639c                	ld	a5,0(a5)
 d98:	fe843703          	ld	a4,-24(s0)
 d9c:	02f71063          	bne	a4,a5,dbc <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 da0:	fdc42783          	lw	a5,-36(s0)
 da4:	853e                	mv	a0,a5
 da6:	00000097          	auipc	ra,0x0
 daa:	e7a080e7          	jalr	-390(ra) # c20 <morecore>
 dae:	fea43423          	sd	a0,-24(s0)
 db2:	fe843783          	ld	a5,-24(s0)
 db6:	e399                	bnez	a5,dbc <malloc+0x11e>
        return 0;
 db8:	4781                	li	a5,0
 dba:	a819                	j	dd0 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 dbc:	fe843783          	ld	a5,-24(s0)
 dc0:	fef43023          	sd	a5,-32(s0)
 dc4:	fe843783          	ld	a5,-24(s0)
 dc8:	639c                	ld	a5,0(a5)
 dca:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 dce:	b799                	j	d14 <malloc+0x76>
  }
}
 dd0:	853e                	mv	a0,a5
 dd2:	70e2                	ld	ra,56(sp)
 dd4:	7442                	ld	s0,48(sp)
 dd6:	6121                	addi	sp,sp,64
 dd8:	8082                	ret
