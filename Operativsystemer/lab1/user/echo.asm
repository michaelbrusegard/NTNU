
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
  6a:	d7a58593          	addi	a1,a1,-646 # de0 <malloc+0x14a>
  6e:	4505                	li	a0,1
  70:	00000097          	auipc	ra,0x0
  74:	52e080e7          	jalr	1326(ra) # 59e <write>
  78:	a819                	j	8e <main+0x8e>
    } else {
      write(1, "\n", 1);
  7a:	4605                	li	a2,1
  7c:	00001597          	auipc	a1,0x1
  80:	d6c58593          	addi	a1,a1,-660 # de8 <malloc+0x152>
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

000000000000061e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 61e:	1101                	addi	sp,sp,-32
 620:	ec06                	sd	ra,24(sp)
 622:	e822                	sd	s0,16(sp)
 624:	1000                	addi	s0,sp,32
 626:	87aa                	mv	a5,a0
 628:	872e                	mv	a4,a1
 62a:	fef42623          	sw	a5,-20(s0)
 62e:	87ba                	mv	a5,a4
 630:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 634:	feb40713          	addi	a4,s0,-21
 638:	fec42783          	lw	a5,-20(s0)
 63c:	4605                	li	a2,1
 63e:	85ba                	mv	a1,a4
 640:	853e                	mv	a0,a5
 642:	00000097          	auipc	ra,0x0
 646:	f5c080e7          	jalr	-164(ra) # 59e <write>
}
 64a:	0001                	nop
 64c:	60e2                	ld	ra,24(sp)
 64e:	6442                	ld	s0,16(sp)
 650:	6105                	addi	sp,sp,32
 652:	8082                	ret

0000000000000654 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 654:	7139                	addi	sp,sp,-64
 656:	fc06                	sd	ra,56(sp)
 658:	f822                	sd	s0,48(sp)
 65a:	0080                	addi	s0,sp,64
 65c:	87aa                	mv	a5,a0
 65e:	8736                	mv	a4,a3
 660:	fcf42623          	sw	a5,-52(s0)
 664:	87ae                	mv	a5,a1
 666:	fcf42423          	sw	a5,-56(s0)
 66a:	87b2                	mv	a5,a2
 66c:	fcf42223          	sw	a5,-60(s0)
 670:	87ba                	mv	a5,a4
 672:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 676:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 67a:	fc042783          	lw	a5,-64(s0)
 67e:	2781                	sext.w	a5,a5
 680:	c38d                	beqz	a5,6a2 <printint+0x4e>
 682:	fc842783          	lw	a5,-56(s0)
 686:	2781                	sext.w	a5,a5
 688:	0007dd63          	bgez	a5,6a2 <printint+0x4e>
    neg = 1;
 68c:	4785                	li	a5,1
 68e:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 692:	fc842783          	lw	a5,-56(s0)
 696:	40f007bb          	negw	a5,a5
 69a:	2781                	sext.w	a5,a5
 69c:	fef42223          	sw	a5,-28(s0)
 6a0:	a029                	j	6aa <printint+0x56>
  } else {
    x = xx;
 6a2:	fc842783          	lw	a5,-56(s0)
 6a6:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 6aa:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 6ae:	fc442783          	lw	a5,-60(s0)
 6b2:	fe442703          	lw	a4,-28(s0)
 6b6:	02f777bb          	remuw	a5,a4,a5
 6ba:	0007871b          	sext.w	a4,a5
 6be:	fec42783          	lw	a5,-20(s0)
 6c2:	0017869b          	addiw	a3,a5,1
 6c6:	fed42623          	sw	a3,-20(s0)
 6ca:	00001697          	auipc	a3,0x1
 6ce:	93668693          	addi	a3,a3,-1738 # 1000 <digits>
 6d2:	1702                	slli	a4,a4,0x20
 6d4:	9301                	srli	a4,a4,0x20
 6d6:	9736                	add	a4,a4,a3
 6d8:	00074703          	lbu	a4,0(a4)
 6dc:	17c1                	addi	a5,a5,-16
 6de:	97a2                	add	a5,a5,s0
 6e0:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 6e4:	fc442783          	lw	a5,-60(s0)
 6e8:	fe442703          	lw	a4,-28(s0)
 6ec:	02f757bb          	divuw	a5,a4,a5
 6f0:	fef42223          	sw	a5,-28(s0)
 6f4:	fe442783          	lw	a5,-28(s0)
 6f8:	2781                	sext.w	a5,a5
 6fa:	fbd5                	bnez	a5,6ae <printint+0x5a>
  if(neg)
 6fc:	fe842783          	lw	a5,-24(s0)
 700:	2781                	sext.w	a5,a5
 702:	cf85                	beqz	a5,73a <printint+0xe6>
    buf[i++] = '-';
 704:	fec42783          	lw	a5,-20(s0)
 708:	0017871b          	addiw	a4,a5,1
 70c:	fee42623          	sw	a4,-20(s0)
 710:	17c1                	addi	a5,a5,-16
 712:	97a2                	add	a5,a5,s0
 714:	02d00713          	li	a4,45
 718:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 71c:	a839                	j	73a <printint+0xe6>
    putc(fd, buf[i]);
 71e:	fec42783          	lw	a5,-20(s0)
 722:	17c1                	addi	a5,a5,-16
 724:	97a2                	add	a5,a5,s0
 726:	fe07c703          	lbu	a4,-32(a5)
 72a:	fcc42783          	lw	a5,-52(s0)
 72e:	85ba                	mv	a1,a4
 730:	853e                	mv	a0,a5
 732:	00000097          	auipc	ra,0x0
 736:	eec080e7          	jalr	-276(ra) # 61e <putc>
  while(--i >= 0)
 73a:	fec42783          	lw	a5,-20(s0)
 73e:	37fd                	addiw	a5,a5,-1
 740:	fef42623          	sw	a5,-20(s0)
 744:	fec42783          	lw	a5,-20(s0)
 748:	2781                	sext.w	a5,a5
 74a:	fc07dae3          	bgez	a5,71e <printint+0xca>
}
 74e:	0001                	nop
 750:	0001                	nop
 752:	70e2                	ld	ra,56(sp)
 754:	7442                	ld	s0,48(sp)
 756:	6121                	addi	sp,sp,64
 758:	8082                	ret

000000000000075a <printptr>:

static void
printptr(int fd, uint64 x) {
 75a:	7179                	addi	sp,sp,-48
 75c:	f406                	sd	ra,40(sp)
 75e:	f022                	sd	s0,32(sp)
 760:	1800                	addi	s0,sp,48
 762:	87aa                	mv	a5,a0
 764:	fcb43823          	sd	a1,-48(s0)
 768:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 76c:	fdc42783          	lw	a5,-36(s0)
 770:	03000593          	li	a1,48
 774:	853e                	mv	a0,a5
 776:	00000097          	auipc	ra,0x0
 77a:	ea8080e7          	jalr	-344(ra) # 61e <putc>
  putc(fd, 'x');
 77e:	fdc42783          	lw	a5,-36(s0)
 782:	07800593          	li	a1,120
 786:	853e                	mv	a0,a5
 788:	00000097          	auipc	ra,0x0
 78c:	e96080e7          	jalr	-362(ra) # 61e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 790:	fe042623          	sw	zero,-20(s0)
 794:	a82d                	j	7ce <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 796:	fd043783          	ld	a5,-48(s0)
 79a:	93f1                	srli	a5,a5,0x3c
 79c:	00001717          	auipc	a4,0x1
 7a0:	86470713          	addi	a4,a4,-1948 # 1000 <digits>
 7a4:	97ba                	add	a5,a5,a4
 7a6:	0007c703          	lbu	a4,0(a5)
 7aa:	fdc42783          	lw	a5,-36(s0)
 7ae:	85ba                	mv	a1,a4
 7b0:	853e                	mv	a0,a5
 7b2:	00000097          	auipc	ra,0x0
 7b6:	e6c080e7          	jalr	-404(ra) # 61e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7ba:	fec42783          	lw	a5,-20(s0)
 7be:	2785                	addiw	a5,a5,1
 7c0:	fef42623          	sw	a5,-20(s0)
 7c4:	fd043783          	ld	a5,-48(s0)
 7c8:	0792                	slli	a5,a5,0x4
 7ca:	fcf43823          	sd	a5,-48(s0)
 7ce:	fec42703          	lw	a4,-20(s0)
 7d2:	47bd                	li	a5,15
 7d4:	fce7f1e3          	bgeu	a5,a4,796 <printptr+0x3c>
}
 7d8:	0001                	nop
 7da:	0001                	nop
 7dc:	70a2                	ld	ra,40(sp)
 7de:	7402                	ld	s0,32(sp)
 7e0:	6145                	addi	sp,sp,48
 7e2:	8082                	ret

00000000000007e4 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7e4:	715d                	addi	sp,sp,-80
 7e6:	e486                	sd	ra,72(sp)
 7e8:	e0a2                	sd	s0,64(sp)
 7ea:	0880                	addi	s0,sp,80
 7ec:	87aa                	mv	a5,a0
 7ee:	fcb43023          	sd	a1,-64(s0)
 7f2:	fac43c23          	sd	a2,-72(s0)
 7f6:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 7fa:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 7fe:	fe042223          	sw	zero,-28(s0)
 802:	a42d                	j	a2c <vprintf+0x248>
    c = fmt[i] & 0xff;
 804:	fe442783          	lw	a5,-28(s0)
 808:	fc043703          	ld	a4,-64(s0)
 80c:	97ba                	add	a5,a5,a4
 80e:	0007c783          	lbu	a5,0(a5)
 812:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 816:	fe042783          	lw	a5,-32(s0)
 81a:	2781                	sext.w	a5,a5
 81c:	eb9d                	bnez	a5,852 <vprintf+0x6e>
      if(c == '%'){
 81e:	fdc42783          	lw	a5,-36(s0)
 822:	0007871b          	sext.w	a4,a5
 826:	02500793          	li	a5,37
 82a:	00f71763          	bne	a4,a5,838 <vprintf+0x54>
        state = '%';
 82e:	02500793          	li	a5,37
 832:	fef42023          	sw	a5,-32(s0)
 836:	a2f5                	j	a22 <vprintf+0x23e>
      } else {
        putc(fd, c);
 838:	fdc42783          	lw	a5,-36(s0)
 83c:	0ff7f713          	zext.b	a4,a5
 840:	fcc42783          	lw	a5,-52(s0)
 844:	85ba                	mv	a1,a4
 846:	853e                	mv	a0,a5
 848:	00000097          	auipc	ra,0x0
 84c:	dd6080e7          	jalr	-554(ra) # 61e <putc>
 850:	aac9                	j	a22 <vprintf+0x23e>
      }
    } else if(state == '%'){
 852:	fe042783          	lw	a5,-32(s0)
 856:	0007871b          	sext.w	a4,a5
 85a:	02500793          	li	a5,37
 85e:	1cf71263          	bne	a4,a5,a22 <vprintf+0x23e>
      if(c == 'd'){
 862:	fdc42783          	lw	a5,-36(s0)
 866:	0007871b          	sext.w	a4,a5
 86a:	06400793          	li	a5,100
 86e:	02f71463          	bne	a4,a5,896 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 872:	fb843783          	ld	a5,-72(s0)
 876:	00878713          	addi	a4,a5,8
 87a:	fae43c23          	sd	a4,-72(s0)
 87e:	4398                	lw	a4,0(a5)
 880:	fcc42783          	lw	a5,-52(s0)
 884:	4685                	li	a3,1
 886:	4629                	li	a2,10
 888:	85ba                	mv	a1,a4
 88a:	853e                	mv	a0,a5
 88c:	00000097          	auipc	ra,0x0
 890:	dc8080e7          	jalr	-568(ra) # 654 <printint>
 894:	a269                	j	a1e <vprintf+0x23a>
      } else if(c == 'l') {
 896:	fdc42783          	lw	a5,-36(s0)
 89a:	0007871b          	sext.w	a4,a5
 89e:	06c00793          	li	a5,108
 8a2:	02f71663          	bne	a4,a5,8ce <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8a6:	fb843783          	ld	a5,-72(s0)
 8aa:	00878713          	addi	a4,a5,8
 8ae:	fae43c23          	sd	a4,-72(s0)
 8b2:	639c                	ld	a5,0(a5)
 8b4:	0007871b          	sext.w	a4,a5
 8b8:	fcc42783          	lw	a5,-52(s0)
 8bc:	4681                	li	a3,0
 8be:	4629                	li	a2,10
 8c0:	85ba                	mv	a1,a4
 8c2:	853e                	mv	a0,a5
 8c4:	00000097          	auipc	ra,0x0
 8c8:	d90080e7          	jalr	-624(ra) # 654 <printint>
 8cc:	aa89                	j	a1e <vprintf+0x23a>
      } else if(c == 'x') {
 8ce:	fdc42783          	lw	a5,-36(s0)
 8d2:	0007871b          	sext.w	a4,a5
 8d6:	07800793          	li	a5,120
 8da:	02f71463          	bne	a4,a5,902 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 8de:	fb843783          	ld	a5,-72(s0)
 8e2:	00878713          	addi	a4,a5,8
 8e6:	fae43c23          	sd	a4,-72(s0)
 8ea:	4398                	lw	a4,0(a5)
 8ec:	fcc42783          	lw	a5,-52(s0)
 8f0:	4681                	li	a3,0
 8f2:	4641                	li	a2,16
 8f4:	85ba                	mv	a1,a4
 8f6:	853e                	mv	a0,a5
 8f8:	00000097          	auipc	ra,0x0
 8fc:	d5c080e7          	jalr	-676(ra) # 654 <printint>
 900:	aa39                	j	a1e <vprintf+0x23a>
      } else if(c == 'p') {
 902:	fdc42783          	lw	a5,-36(s0)
 906:	0007871b          	sext.w	a4,a5
 90a:	07000793          	li	a5,112
 90e:	02f71263          	bne	a4,a5,932 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 912:	fb843783          	ld	a5,-72(s0)
 916:	00878713          	addi	a4,a5,8
 91a:	fae43c23          	sd	a4,-72(s0)
 91e:	6398                	ld	a4,0(a5)
 920:	fcc42783          	lw	a5,-52(s0)
 924:	85ba                	mv	a1,a4
 926:	853e                	mv	a0,a5
 928:	00000097          	auipc	ra,0x0
 92c:	e32080e7          	jalr	-462(ra) # 75a <printptr>
 930:	a0fd                	j	a1e <vprintf+0x23a>
      } else if(c == 's'){
 932:	fdc42783          	lw	a5,-36(s0)
 936:	0007871b          	sext.w	a4,a5
 93a:	07300793          	li	a5,115
 93e:	04f71c63          	bne	a4,a5,996 <vprintf+0x1b2>
        s = va_arg(ap, char*);
 942:	fb843783          	ld	a5,-72(s0)
 946:	00878713          	addi	a4,a5,8
 94a:	fae43c23          	sd	a4,-72(s0)
 94e:	639c                	ld	a5,0(a5)
 950:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 954:	fe843783          	ld	a5,-24(s0)
 958:	eb8d                	bnez	a5,98a <vprintf+0x1a6>
          s = "(null)";
 95a:	00000797          	auipc	a5,0x0
 95e:	49678793          	addi	a5,a5,1174 # df0 <malloc+0x15a>
 962:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 966:	a015                	j	98a <vprintf+0x1a6>
          putc(fd, *s);
 968:	fe843783          	ld	a5,-24(s0)
 96c:	0007c703          	lbu	a4,0(a5)
 970:	fcc42783          	lw	a5,-52(s0)
 974:	85ba                	mv	a1,a4
 976:	853e                	mv	a0,a5
 978:	00000097          	auipc	ra,0x0
 97c:	ca6080e7          	jalr	-858(ra) # 61e <putc>
          s++;
 980:	fe843783          	ld	a5,-24(s0)
 984:	0785                	addi	a5,a5,1
 986:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 98a:	fe843783          	ld	a5,-24(s0)
 98e:	0007c783          	lbu	a5,0(a5)
 992:	fbf9                	bnez	a5,968 <vprintf+0x184>
 994:	a069                	j	a1e <vprintf+0x23a>
        }
      } else if(c == 'c'){
 996:	fdc42783          	lw	a5,-36(s0)
 99a:	0007871b          	sext.w	a4,a5
 99e:	06300793          	li	a5,99
 9a2:	02f71463          	bne	a4,a5,9ca <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 9a6:	fb843783          	ld	a5,-72(s0)
 9aa:	00878713          	addi	a4,a5,8
 9ae:	fae43c23          	sd	a4,-72(s0)
 9b2:	439c                	lw	a5,0(a5)
 9b4:	0ff7f713          	zext.b	a4,a5
 9b8:	fcc42783          	lw	a5,-52(s0)
 9bc:	85ba                	mv	a1,a4
 9be:	853e                	mv	a0,a5
 9c0:	00000097          	auipc	ra,0x0
 9c4:	c5e080e7          	jalr	-930(ra) # 61e <putc>
 9c8:	a899                	j	a1e <vprintf+0x23a>
      } else if(c == '%'){
 9ca:	fdc42783          	lw	a5,-36(s0)
 9ce:	0007871b          	sext.w	a4,a5
 9d2:	02500793          	li	a5,37
 9d6:	00f71f63          	bne	a4,a5,9f4 <vprintf+0x210>
        putc(fd, c);
 9da:	fdc42783          	lw	a5,-36(s0)
 9de:	0ff7f713          	zext.b	a4,a5
 9e2:	fcc42783          	lw	a5,-52(s0)
 9e6:	85ba                	mv	a1,a4
 9e8:	853e                	mv	a0,a5
 9ea:	00000097          	auipc	ra,0x0
 9ee:	c34080e7          	jalr	-972(ra) # 61e <putc>
 9f2:	a035                	j	a1e <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9f4:	fcc42783          	lw	a5,-52(s0)
 9f8:	02500593          	li	a1,37
 9fc:	853e                	mv	a0,a5
 9fe:	00000097          	auipc	ra,0x0
 a02:	c20080e7          	jalr	-992(ra) # 61e <putc>
        putc(fd, c);
 a06:	fdc42783          	lw	a5,-36(s0)
 a0a:	0ff7f713          	zext.b	a4,a5
 a0e:	fcc42783          	lw	a5,-52(s0)
 a12:	85ba                	mv	a1,a4
 a14:	853e                	mv	a0,a5
 a16:	00000097          	auipc	ra,0x0
 a1a:	c08080e7          	jalr	-1016(ra) # 61e <putc>
      }
      state = 0;
 a1e:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 a22:	fe442783          	lw	a5,-28(s0)
 a26:	2785                	addiw	a5,a5,1
 a28:	fef42223          	sw	a5,-28(s0)
 a2c:	fe442783          	lw	a5,-28(s0)
 a30:	fc043703          	ld	a4,-64(s0)
 a34:	97ba                	add	a5,a5,a4
 a36:	0007c783          	lbu	a5,0(a5)
 a3a:	dc0795e3          	bnez	a5,804 <vprintf+0x20>
    }
  }
}
 a3e:	0001                	nop
 a40:	0001                	nop
 a42:	60a6                	ld	ra,72(sp)
 a44:	6406                	ld	s0,64(sp)
 a46:	6161                	addi	sp,sp,80
 a48:	8082                	ret

0000000000000a4a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a4a:	7159                	addi	sp,sp,-112
 a4c:	fc06                	sd	ra,56(sp)
 a4e:	f822                	sd	s0,48(sp)
 a50:	0080                	addi	s0,sp,64
 a52:	fcb43823          	sd	a1,-48(s0)
 a56:	e010                	sd	a2,0(s0)
 a58:	e414                	sd	a3,8(s0)
 a5a:	e818                	sd	a4,16(s0)
 a5c:	ec1c                	sd	a5,24(s0)
 a5e:	03043023          	sd	a6,32(s0)
 a62:	03143423          	sd	a7,40(s0)
 a66:	87aa                	mv	a5,a0
 a68:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 a6c:	03040793          	addi	a5,s0,48
 a70:	fcf43423          	sd	a5,-56(s0)
 a74:	fc843783          	ld	a5,-56(s0)
 a78:	fd078793          	addi	a5,a5,-48
 a7c:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 a80:	fe843703          	ld	a4,-24(s0)
 a84:	fdc42783          	lw	a5,-36(s0)
 a88:	863a                	mv	a2,a4
 a8a:	fd043583          	ld	a1,-48(s0)
 a8e:	853e                	mv	a0,a5
 a90:	00000097          	auipc	ra,0x0
 a94:	d54080e7          	jalr	-684(ra) # 7e4 <vprintf>
}
 a98:	0001                	nop
 a9a:	70e2                	ld	ra,56(sp)
 a9c:	7442                	ld	s0,48(sp)
 a9e:	6165                	addi	sp,sp,112
 aa0:	8082                	ret

0000000000000aa2 <printf>:

void
printf(const char *fmt, ...)
{
 aa2:	7159                	addi	sp,sp,-112
 aa4:	f406                	sd	ra,40(sp)
 aa6:	f022                	sd	s0,32(sp)
 aa8:	1800                	addi	s0,sp,48
 aaa:	fca43c23          	sd	a0,-40(s0)
 aae:	e40c                	sd	a1,8(s0)
 ab0:	e810                	sd	a2,16(s0)
 ab2:	ec14                	sd	a3,24(s0)
 ab4:	f018                	sd	a4,32(s0)
 ab6:	f41c                	sd	a5,40(s0)
 ab8:	03043823          	sd	a6,48(s0)
 abc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 ac0:	04040793          	addi	a5,s0,64
 ac4:	fcf43823          	sd	a5,-48(s0)
 ac8:	fd043783          	ld	a5,-48(s0)
 acc:	fc878793          	addi	a5,a5,-56
 ad0:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 ad4:	fe843783          	ld	a5,-24(s0)
 ad8:	863e                	mv	a2,a5
 ada:	fd843583          	ld	a1,-40(s0)
 ade:	4505                	li	a0,1
 ae0:	00000097          	auipc	ra,0x0
 ae4:	d04080e7          	jalr	-764(ra) # 7e4 <vprintf>
}
 ae8:	0001                	nop
 aea:	70a2                	ld	ra,40(sp)
 aec:	7402                	ld	s0,32(sp)
 aee:	6165                	addi	sp,sp,112
 af0:	8082                	ret

0000000000000af2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 af2:	7179                	addi	sp,sp,-48
 af4:	f406                	sd	ra,40(sp)
 af6:	f022                	sd	s0,32(sp)
 af8:	1800                	addi	s0,sp,48
 afa:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 afe:	fd843783          	ld	a5,-40(s0)
 b02:	17c1                	addi	a5,a5,-16
 b04:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b08:	00000797          	auipc	a5,0x0
 b0c:	52878793          	addi	a5,a5,1320 # 1030 <freep>
 b10:	639c                	ld	a5,0(a5)
 b12:	fef43423          	sd	a5,-24(s0)
 b16:	a815                	j	b4a <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b18:	fe843783          	ld	a5,-24(s0)
 b1c:	639c                	ld	a5,0(a5)
 b1e:	fe843703          	ld	a4,-24(s0)
 b22:	00f76f63          	bltu	a4,a5,b40 <free+0x4e>
 b26:	fe043703          	ld	a4,-32(s0)
 b2a:	fe843783          	ld	a5,-24(s0)
 b2e:	02e7eb63          	bltu	a5,a4,b64 <free+0x72>
 b32:	fe843783          	ld	a5,-24(s0)
 b36:	639c                	ld	a5,0(a5)
 b38:	fe043703          	ld	a4,-32(s0)
 b3c:	02f76463          	bltu	a4,a5,b64 <free+0x72>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b40:	fe843783          	ld	a5,-24(s0)
 b44:	639c                	ld	a5,0(a5)
 b46:	fef43423          	sd	a5,-24(s0)
 b4a:	fe043703          	ld	a4,-32(s0)
 b4e:	fe843783          	ld	a5,-24(s0)
 b52:	fce7f3e3          	bgeu	a5,a4,b18 <free+0x26>
 b56:	fe843783          	ld	a5,-24(s0)
 b5a:	639c                	ld	a5,0(a5)
 b5c:	fe043703          	ld	a4,-32(s0)
 b60:	faf77ce3          	bgeu	a4,a5,b18 <free+0x26>
      break;
  if(bp + bp->s.size == p->s.ptr){
 b64:	fe043783          	ld	a5,-32(s0)
 b68:	479c                	lw	a5,8(a5)
 b6a:	1782                	slli	a5,a5,0x20
 b6c:	9381                	srli	a5,a5,0x20
 b6e:	0792                	slli	a5,a5,0x4
 b70:	fe043703          	ld	a4,-32(s0)
 b74:	973e                	add	a4,a4,a5
 b76:	fe843783          	ld	a5,-24(s0)
 b7a:	639c                	ld	a5,0(a5)
 b7c:	02f71763          	bne	a4,a5,baa <free+0xb8>
    bp->s.size += p->s.ptr->s.size;
 b80:	fe043783          	ld	a5,-32(s0)
 b84:	4798                	lw	a4,8(a5)
 b86:	fe843783          	ld	a5,-24(s0)
 b8a:	639c                	ld	a5,0(a5)
 b8c:	479c                	lw	a5,8(a5)
 b8e:	9fb9                	addw	a5,a5,a4
 b90:	0007871b          	sext.w	a4,a5
 b94:	fe043783          	ld	a5,-32(s0)
 b98:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 b9a:	fe843783          	ld	a5,-24(s0)
 b9e:	639c                	ld	a5,0(a5)
 ba0:	6398                	ld	a4,0(a5)
 ba2:	fe043783          	ld	a5,-32(s0)
 ba6:	e398                	sd	a4,0(a5)
 ba8:	a039                	j	bb6 <free+0xc4>
  } else
    bp->s.ptr = p->s.ptr;
 baa:	fe843783          	ld	a5,-24(s0)
 bae:	6398                	ld	a4,0(a5)
 bb0:	fe043783          	ld	a5,-32(s0)
 bb4:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 bb6:	fe843783          	ld	a5,-24(s0)
 bba:	479c                	lw	a5,8(a5)
 bbc:	1782                	slli	a5,a5,0x20
 bbe:	9381                	srli	a5,a5,0x20
 bc0:	0792                	slli	a5,a5,0x4
 bc2:	fe843703          	ld	a4,-24(s0)
 bc6:	97ba                	add	a5,a5,a4
 bc8:	fe043703          	ld	a4,-32(s0)
 bcc:	02f71563          	bne	a4,a5,bf6 <free+0x104>
    p->s.size += bp->s.size;
 bd0:	fe843783          	ld	a5,-24(s0)
 bd4:	4798                	lw	a4,8(a5)
 bd6:	fe043783          	ld	a5,-32(s0)
 bda:	479c                	lw	a5,8(a5)
 bdc:	9fb9                	addw	a5,a5,a4
 bde:	0007871b          	sext.w	a4,a5
 be2:	fe843783          	ld	a5,-24(s0)
 be6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 be8:	fe043783          	ld	a5,-32(s0)
 bec:	6398                	ld	a4,0(a5)
 bee:	fe843783          	ld	a5,-24(s0)
 bf2:	e398                	sd	a4,0(a5)
 bf4:	a031                	j	c00 <free+0x10e>
  } else
    p->s.ptr = bp;
 bf6:	fe843783          	ld	a5,-24(s0)
 bfa:	fe043703          	ld	a4,-32(s0)
 bfe:	e398                	sd	a4,0(a5)
  freep = p;
 c00:	00000797          	auipc	a5,0x0
 c04:	43078793          	addi	a5,a5,1072 # 1030 <freep>
 c08:	fe843703          	ld	a4,-24(s0)
 c0c:	e398                	sd	a4,0(a5)
}
 c0e:	0001                	nop
 c10:	70a2                	ld	ra,40(sp)
 c12:	7402                	ld	s0,32(sp)
 c14:	6145                	addi	sp,sp,48
 c16:	8082                	ret

0000000000000c18 <morecore>:

static Header*
morecore(uint nu)
{
 c18:	7179                	addi	sp,sp,-48
 c1a:	f406                	sd	ra,40(sp)
 c1c:	f022                	sd	s0,32(sp)
 c1e:	1800                	addi	s0,sp,48
 c20:	87aa                	mv	a5,a0
 c22:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 c26:	fdc42783          	lw	a5,-36(s0)
 c2a:	0007871b          	sext.w	a4,a5
 c2e:	6785                	lui	a5,0x1
 c30:	00f77563          	bgeu	a4,a5,c3a <morecore+0x22>
    nu = 4096;
 c34:	6785                	lui	a5,0x1
 c36:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 c3a:	fdc42783          	lw	a5,-36(s0)
 c3e:	0047979b          	slliw	a5,a5,0x4
 c42:	2781                	sext.w	a5,a5
 c44:	853e                	mv	a0,a5
 c46:	00000097          	auipc	ra,0x0
 c4a:	9c0080e7          	jalr	-1600(ra) # 606 <sbrk>
 c4e:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 c52:	fe843703          	ld	a4,-24(s0)
 c56:	57fd                	li	a5,-1
 c58:	00f71463          	bne	a4,a5,c60 <morecore+0x48>
    return 0;
 c5c:	4781                	li	a5,0
 c5e:	a03d                	j	c8c <morecore+0x74>
  hp = (Header*)p;
 c60:	fe843783          	ld	a5,-24(s0)
 c64:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 c68:	fe043783          	ld	a5,-32(s0)
 c6c:	fdc42703          	lw	a4,-36(s0)
 c70:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 c72:	fe043783          	ld	a5,-32(s0)
 c76:	07c1                	addi	a5,a5,16 # 1010 <digits+0x10>
 c78:	853e                	mv	a0,a5
 c7a:	00000097          	auipc	ra,0x0
 c7e:	e78080e7          	jalr	-392(ra) # af2 <free>
  return freep;
 c82:	00000797          	auipc	a5,0x0
 c86:	3ae78793          	addi	a5,a5,942 # 1030 <freep>
 c8a:	639c                	ld	a5,0(a5)
}
 c8c:	853e                	mv	a0,a5
 c8e:	70a2                	ld	ra,40(sp)
 c90:	7402                	ld	s0,32(sp)
 c92:	6145                	addi	sp,sp,48
 c94:	8082                	ret

0000000000000c96 <malloc>:

void*
malloc(uint nbytes)
{
 c96:	7139                	addi	sp,sp,-64
 c98:	fc06                	sd	ra,56(sp)
 c9a:	f822                	sd	s0,48(sp)
 c9c:	0080                	addi	s0,sp,64
 c9e:	87aa                	mv	a5,a0
 ca0:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ca4:	fcc46783          	lwu	a5,-52(s0)
 ca8:	07bd                	addi	a5,a5,15
 caa:	8391                	srli	a5,a5,0x4
 cac:	2781                	sext.w	a5,a5
 cae:	2785                	addiw	a5,a5,1
 cb0:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 cb4:	00000797          	auipc	a5,0x0
 cb8:	37c78793          	addi	a5,a5,892 # 1030 <freep>
 cbc:	639c                	ld	a5,0(a5)
 cbe:	fef43023          	sd	a5,-32(s0)
 cc2:	fe043783          	ld	a5,-32(s0)
 cc6:	ef95                	bnez	a5,d02 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 cc8:	00000797          	auipc	a5,0x0
 ccc:	35878793          	addi	a5,a5,856 # 1020 <base>
 cd0:	fef43023          	sd	a5,-32(s0)
 cd4:	00000797          	auipc	a5,0x0
 cd8:	35c78793          	addi	a5,a5,860 # 1030 <freep>
 cdc:	fe043703          	ld	a4,-32(s0)
 ce0:	e398                	sd	a4,0(a5)
 ce2:	00000797          	auipc	a5,0x0
 ce6:	34e78793          	addi	a5,a5,846 # 1030 <freep>
 cea:	6398                	ld	a4,0(a5)
 cec:	00000797          	auipc	a5,0x0
 cf0:	33478793          	addi	a5,a5,820 # 1020 <base>
 cf4:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 cf6:	00000797          	auipc	a5,0x0
 cfa:	32a78793          	addi	a5,a5,810 # 1020 <base>
 cfe:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d02:	fe043783          	ld	a5,-32(s0)
 d06:	639c                	ld	a5,0(a5)
 d08:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 d0c:	fe843783          	ld	a5,-24(s0)
 d10:	479c                	lw	a5,8(a5)
 d12:	fdc42703          	lw	a4,-36(s0)
 d16:	2701                	sext.w	a4,a4
 d18:	06e7e763          	bltu	a5,a4,d86 <malloc+0xf0>
      if(p->s.size == nunits)
 d1c:	fe843783          	ld	a5,-24(s0)
 d20:	479c                	lw	a5,8(a5)
 d22:	fdc42703          	lw	a4,-36(s0)
 d26:	2701                	sext.w	a4,a4
 d28:	00f71963          	bne	a4,a5,d3a <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 d2c:	fe843783          	ld	a5,-24(s0)
 d30:	6398                	ld	a4,0(a5)
 d32:	fe043783          	ld	a5,-32(s0)
 d36:	e398                	sd	a4,0(a5)
 d38:	a825                	j	d70 <malloc+0xda>
      else {
        p->s.size -= nunits;
 d3a:	fe843783          	ld	a5,-24(s0)
 d3e:	479c                	lw	a5,8(a5)
 d40:	fdc42703          	lw	a4,-36(s0)
 d44:	9f99                	subw	a5,a5,a4
 d46:	0007871b          	sext.w	a4,a5
 d4a:	fe843783          	ld	a5,-24(s0)
 d4e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 d50:	fe843783          	ld	a5,-24(s0)
 d54:	479c                	lw	a5,8(a5)
 d56:	1782                	slli	a5,a5,0x20
 d58:	9381                	srli	a5,a5,0x20
 d5a:	0792                	slli	a5,a5,0x4
 d5c:	fe843703          	ld	a4,-24(s0)
 d60:	97ba                	add	a5,a5,a4
 d62:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 d66:	fe843783          	ld	a5,-24(s0)
 d6a:	fdc42703          	lw	a4,-36(s0)
 d6e:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 d70:	00000797          	auipc	a5,0x0
 d74:	2c078793          	addi	a5,a5,704 # 1030 <freep>
 d78:	fe043703          	ld	a4,-32(s0)
 d7c:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 d7e:	fe843783          	ld	a5,-24(s0)
 d82:	07c1                	addi	a5,a5,16
 d84:	a091                	j	dc8 <malloc+0x132>
    }
    if(p == freep)
 d86:	00000797          	auipc	a5,0x0
 d8a:	2aa78793          	addi	a5,a5,682 # 1030 <freep>
 d8e:	639c                	ld	a5,0(a5)
 d90:	fe843703          	ld	a4,-24(s0)
 d94:	02f71063          	bne	a4,a5,db4 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 d98:	fdc42783          	lw	a5,-36(s0)
 d9c:	853e                	mv	a0,a5
 d9e:	00000097          	auipc	ra,0x0
 da2:	e7a080e7          	jalr	-390(ra) # c18 <morecore>
 da6:	fea43423          	sd	a0,-24(s0)
 daa:	fe843783          	ld	a5,-24(s0)
 dae:	e399                	bnez	a5,db4 <malloc+0x11e>
        return 0;
 db0:	4781                	li	a5,0
 db2:	a819                	j	dc8 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 db4:	fe843783          	ld	a5,-24(s0)
 db8:	fef43023          	sd	a5,-32(s0)
 dbc:	fe843783          	ld	a5,-24(s0)
 dc0:	639c                	ld	a5,0(a5)
 dc2:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 dc6:	b799                	j	d0c <malloc+0x76>
  }
}
 dc8:	853e                	mv	a0,a5
 dca:	70e2                	ld	ra,56(sp)
 dcc:	7442                	ld	s0,48(sp)
 dce:	6121                	addi	sp,sp,64
 dd0:	8082                	ret
