
user/_rm:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
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
    fprintf(2, "Usage: rm files...\n");
  20:	00001597          	auipc	a1,0x1
  24:	dc058593          	addi	a1,a1,-576 # de0 <malloc+0x14a>
  28:	4509                	li	a0,2
  2a:	00001097          	auipc	ra,0x1
  2e:	a20080e7          	jalr	-1504(ra) # a4a <fprintf>
    exit(1);
  32:	4505                	li	a0,1
  34:	00000097          	auipc	ra,0x0
  38:	542080e7          	jalr	1346(ra) # 576 <exit>
  }

  for(i = 1; i < argc; i++){
  3c:	4785                	li	a5,1
  3e:	fef42623          	sw	a5,-20(s0)
  42:	a0b9                	j	90 <main+0x90>
    if(unlink(argv[i]) < 0){
  44:	fec42783          	lw	a5,-20(s0)
  48:	078e                	slli	a5,a5,0x3
  4a:	fd043703          	ld	a4,-48(s0)
  4e:	97ba                	add	a5,a5,a4
  50:	639c                	ld	a5,0(a5)
  52:	853e                	mv	a0,a5
  54:	00000097          	auipc	ra,0x0
  58:	572080e7          	jalr	1394(ra) # 5c6 <unlink>
  5c:	87aa                	mv	a5,a0
  5e:	0207d463          	bgez	a5,86 <main+0x86>
      fprintf(2, "rm: %s failed to delete\n", argv[i]);
  62:	fec42783          	lw	a5,-20(s0)
  66:	078e                	slli	a5,a5,0x3
  68:	fd043703          	ld	a4,-48(s0)
  6c:	97ba                	add	a5,a5,a4
  6e:	639c                	ld	a5,0(a5)
  70:	863e                	mv	a2,a5
  72:	00001597          	auipc	a1,0x1
  76:	d8658593          	addi	a1,a1,-634 # df8 <malloc+0x162>
  7a:	4509                	li	a0,2
  7c:	00001097          	auipc	ra,0x1
  80:	9ce080e7          	jalr	-1586(ra) # a4a <fprintf>
      break;
  84:	a839                	j	a2 <main+0xa2>
  for(i = 1; i < argc; i++){
  86:	fec42783          	lw	a5,-20(s0)
  8a:	2785                	addiw	a5,a5,1
  8c:	fef42623          	sw	a5,-20(s0)
  90:	fec42783          	lw	a5,-20(s0)
  94:	873e                	mv	a4,a5
  96:	fdc42783          	lw	a5,-36(s0)
  9a:	2701                	sext.w	a4,a4
  9c:	2781                	sext.w	a5,a5
  9e:	faf743e3          	blt	a4,a5,44 <main+0x44>
    }
  }

  exit(0);
  a2:	4501                	li	a0,0
  a4:	00000097          	auipc	ra,0x0
  a8:	4d2080e7          	jalr	1234(ra) # 576 <exit>

00000000000000ac <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  ac:	1141                	addi	sp,sp,-16
  ae:	e406                	sd	ra,8(sp)
  b0:	e022                	sd	s0,0(sp)
  b2:	0800                	addi	s0,sp,16
  extern int main();
  main();
  b4:	00000097          	auipc	ra,0x0
  b8:	f4c080e7          	jalr	-180(ra) # 0 <main>
  exit(0);
  bc:	4501                	li	a0,0
  be:	00000097          	auipc	ra,0x0
  c2:	4b8080e7          	jalr	1208(ra) # 576 <exit>

00000000000000c6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  c6:	7179                	addi	sp,sp,-48
  c8:	f406                	sd	ra,40(sp)
  ca:	f022                	sd	s0,32(sp)
  cc:	1800                	addi	s0,sp,48
  ce:	fca43c23          	sd	a0,-40(s0)
  d2:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
  d6:	fd843783          	ld	a5,-40(s0)
  da:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
  de:	0001                	nop
  e0:	fd043703          	ld	a4,-48(s0)
  e4:	00170793          	addi	a5,a4,1
  e8:	fcf43823          	sd	a5,-48(s0)
  ec:	fd843783          	ld	a5,-40(s0)
  f0:	00178693          	addi	a3,a5,1
  f4:	fcd43c23          	sd	a3,-40(s0)
  f8:	00074703          	lbu	a4,0(a4)
  fc:	00e78023          	sb	a4,0(a5)
 100:	0007c783          	lbu	a5,0(a5)
 104:	fff1                	bnez	a5,e0 <strcpy+0x1a>
    ;
  return os;
 106:	fe843783          	ld	a5,-24(s0)
}
 10a:	853e                	mv	a0,a5
 10c:	70a2                	ld	ra,40(sp)
 10e:	7402                	ld	s0,32(sp)
 110:	6145                	addi	sp,sp,48
 112:	8082                	ret

0000000000000114 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 114:	1101                	addi	sp,sp,-32
 116:	ec06                	sd	ra,24(sp)
 118:	e822                	sd	s0,16(sp)
 11a:	1000                	addi	s0,sp,32
 11c:	fea43423          	sd	a0,-24(s0)
 120:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
 124:	a819                	j	13a <strcmp+0x26>
    p++, q++;
 126:	fe843783          	ld	a5,-24(s0)
 12a:	0785                	addi	a5,a5,1
 12c:	fef43423          	sd	a5,-24(s0)
 130:	fe043783          	ld	a5,-32(s0)
 134:	0785                	addi	a5,a5,1
 136:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
 13a:	fe843783          	ld	a5,-24(s0)
 13e:	0007c783          	lbu	a5,0(a5)
 142:	cb99                	beqz	a5,158 <strcmp+0x44>
 144:	fe843783          	ld	a5,-24(s0)
 148:	0007c703          	lbu	a4,0(a5)
 14c:	fe043783          	ld	a5,-32(s0)
 150:	0007c783          	lbu	a5,0(a5)
 154:	fcf709e3          	beq	a4,a5,126 <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
 158:	fe843783          	ld	a5,-24(s0)
 15c:	0007c783          	lbu	a5,0(a5)
 160:	0007871b          	sext.w	a4,a5
 164:	fe043783          	ld	a5,-32(s0)
 168:	0007c783          	lbu	a5,0(a5)
 16c:	2781                	sext.w	a5,a5
 16e:	40f707bb          	subw	a5,a4,a5
 172:	2781                	sext.w	a5,a5
}
 174:	853e                	mv	a0,a5
 176:	60e2                	ld	ra,24(sp)
 178:	6442                	ld	s0,16(sp)
 17a:	6105                	addi	sp,sp,32
 17c:	8082                	ret

000000000000017e <strlen>:

uint
strlen(const char *s)
{
 17e:	7179                	addi	sp,sp,-48
 180:	f406                	sd	ra,40(sp)
 182:	f022                	sd	s0,32(sp)
 184:	1800                	addi	s0,sp,48
 186:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
 18a:	fe042623          	sw	zero,-20(s0)
 18e:	a031                	j	19a <strlen+0x1c>
 190:	fec42783          	lw	a5,-20(s0)
 194:	2785                	addiw	a5,a5,1
 196:	fef42623          	sw	a5,-20(s0)
 19a:	fec42783          	lw	a5,-20(s0)
 19e:	fd843703          	ld	a4,-40(s0)
 1a2:	97ba                	add	a5,a5,a4
 1a4:	0007c783          	lbu	a5,0(a5)
 1a8:	f7e5                	bnez	a5,190 <strlen+0x12>
    ;
  return n;
 1aa:	fec42783          	lw	a5,-20(s0)
}
 1ae:	853e                	mv	a0,a5
 1b0:	70a2                	ld	ra,40(sp)
 1b2:	7402                	ld	s0,32(sp)
 1b4:	6145                	addi	sp,sp,48
 1b6:	8082                	ret

00000000000001b8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1b8:	7179                	addi	sp,sp,-48
 1ba:	f406                	sd	ra,40(sp)
 1bc:	f022                	sd	s0,32(sp)
 1be:	1800                	addi	s0,sp,48
 1c0:	fca43c23          	sd	a0,-40(s0)
 1c4:	87ae                	mv	a5,a1
 1c6:	8732                	mv	a4,a2
 1c8:	fcf42a23          	sw	a5,-44(s0)
 1cc:	87ba                	mv	a5,a4
 1ce:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
 1d2:	fd843783          	ld	a5,-40(s0)
 1d6:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
 1da:	fe042623          	sw	zero,-20(s0)
 1de:	a00d                	j	200 <memset+0x48>
    cdst[i] = c;
 1e0:	fec42783          	lw	a5,-20(s0)
 1e4:	fe043703          	ld	a4,-32(s0)
 1e8:	97ba                	add	a5,a5,a4
 1ea:	fd442703          	lw	a4,-44(s0)
 1ee:	0ff77713          	zext.b	a4,a4
 1f2:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
 1f6:	fec42783          	lw	a5,-20(s0)
 1fa:	2785                	addiw	a5,a5,1
 1fc:	fef42623          	sw	a5,-20(s0)
 200:	fec42783          	lw	a5,-20(s0)
 204:	fd042703          	lw	a4,-48(s0)
 208:	2701                	sext.w	a4,a4
 20a:	fce7ebe3          	bltu	a5,a4,1e0 <memset+0x28>
  }
  return dst;
 20e:	fd843783          	ld	a5,-40(s0)
}
 212:	853e                	mv	a0,a5
 214:	70a2                	ld	ra,40(sp)
 216:	7402                	ld	s0,32(sp)
 218:	6145                	addi	sp,sp,48
 21a:	8082                	ret

000000000000021c <strchr>:

char*
strchr(const char *s, char c)
{
 21c:	1101                	addi	sp,sp,-32
 21e:	ec06                	sd	ra,24(sp)
 220:	e822                	sd	s0,16(sp)
 222:	1000                	addi	s0,sp,32
 224:	fea43423          	sd	a0,-24(s0)
 228:	87ae                	mv	a5,a1
 22a:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
 22e:	a01d                	j	254 <strchr+0x38>
    if(*s == c)
 230:	fe843783          	ld	a5,-24(s0)
 234:	0007c703          	lbu	a4,0(a5)
 238:	fe744783          	lbu	a5,-25(s0)
 23c:	0ff7f793          	zext.b	a5,a5
 240:	00e79563          	bne	a5,a4,24a <strchr+0x2e>
      return (char*)s;
 244:	fe843783          	ld	a5,-24(s0)
 248:	a821                	j	260 <strchr+0x44>
  for(; *s; s++)
 24a:	fe843783          	ld	a5,-24(s0)
 24e:	0785                	addi	a5,a5,1
 250:	fef43423          	sd	a5,-24(s0)
 254:	fe843783          	ld	a5,-24(s0)
 258:	0007c783          	lbu	a5,0(a5)
 25c:	fbf1                	bnez	a5,230 <strchr+0x14>
  return 0;
 25e:	4781                	li	a5,0
}
 260:	853e                	mv	a0,a5
 262:	60e2                	ld	ra,24(sp)
 264:	6442                	ld	s0,16(sp)
 266:	6105                	addi	sp,sp,32
 268:	8082                	ret

000000000000026a <gets>:

char*
gets(char *buf, int max)
{
 26a:	7179                	addi	sp,sp,-48
 26c:	f406                	sd	ra,40(sp)
 26e:	f022                	sd	s0,32(sp)
 270:	1800                	addi	s0,sp,48
 272:	fca43c23          	sd	a0,-40(s0)
 276:	87ae                	mv	a5,a1
 278:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 27c:	fe042623          	sw	zero,-20(s0)
 280:	a8a1                	j	2d8 <gets+0x6e>
    cc = read(0, &c, 1);
 282:	fe740793          	addi	a5,s0,-25
 286:	4605                	li	a2,1
 288:	85be                	mv	a1,a5
 28a:	4501                	li	a0,0
 28c:	00000097          	auipc	ra,0x0
 290:	302080e7          	jalr	770(ra) # 58e <read>
 294:	87aa                	mv	a5,a0
 296:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
 29a:	fe842783          	lw	a5,-24(s0)
 29e:	2781                	sext.w	a5,a5
 2a0:	04f05663          	blez	a5,2ec <gets+0x82>
      break;
    buf[i++] = c;
 2a4:	fec42783          	lw	a5,-20(s0)
 2a8:	0017871b          	addiw	a4,a5,1
 2ac:	fee42623          	sw	a4,-20(s0)
 2b0:	873e                	mv	a4,a5
 2b2:	fd843783          	ld	a5,-40(s0)
 2b6:	97ba                	add	a5,a5,a4
 2b8:	fe744703          	lbu	a4,-25(s0)
 2bc:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
 2c0:	fe744783          	lbu	a5,-25(s0)
 2c4:	873e                	mv	a4,a5
 2c6:	47a9                	li	a5,10
 2c8:	02f70363          	beq	a4,a5,2ee <gets+0x84>
 2cc:	fe744783          	lbu	a5,-25(s0)
 2d0:	873e                	mv	a4,a5
 2d2:	47b5                	li	a5,13
 2d4:	00f70d63          	beq	a4,a5,2ee <gets+0x84>
  for(i=0; i+1 < max; ){
 2d8:	fec42783          	lw	a5,-20(s0)
 2dc:	2785                	addiw	a5,a5,1
 2de:	2781                	sext.w	a5,a5
 2e0:	fd442703          	lw	a4,-44(s0)
 2e4:	2701                	sext.w	a4,a4
 2e6:	f8e7cee3          	blt	a5,a4,282 <gets+0x18>
 2ea:	a011                	j	2ee <gets+0x84>
      break;
 2ec:	0001                	nop
      break;
  }
  buf[i] = '\0';
 2ee:	fec42783          	lw	a5,-20(s0)
 2f2:	fd843703          	ld	a4,-40(s0)
 2f6:	97ba                	add	a5,a5,a4
 2f8:	00078023          	sb	zero,0(a5)
  return buf;
 2fc:	fd843783          	ld	a5,-40(s0)
}
 300:	853e                	mv	a0,a5
 302:	70a2                	ld	ra,40(sp)
 304:	7402                	ld	s0,32(sp)
 306:	6145                	addi	sp,sp,48
 308:	8082                	ret

000000000000030a <stat>:

int
stat(const char *n, struct stat *st)
{
 30a:	7179                	addi	sp,sp,-48
 30c:	f406                	sd	ra,40(sp)
 30e:	f022                	sd	s0,32(sp)
 310:	1800                	addi	s0,sp,48
 312:	fca43c23          	sd	a0,-40(s0)
 316:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 31a:	4581                	li	a1,0
 31c:	fd843503          	ld	a0,-40(s0)
 320:	00000097          	auipc	ra,0x0
 324:	296080e7          	jalr	662(ra) # 5b6 <open>
 328:	87aa                	mv	a5,a0
 32a:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
 32e:	fec42783          	lw	a5,-20(s0)
 332:	2781                	sext.w	a5,a5
 334:	0007d463          	bgez	a5,33c <stat+0x32>
    return -1;
 338:	57fd                	li	a5,-1
 33a:	a035                	j	366 <stat+0x5c>
  r = fstat(fd, st);
 33c:	fec42783          	lw	a5,-20(s0)
 340:	fd043583          	ld	a1,-48(s0)
 344:	853e                	mv	a0,a5
 346:	00000097          	auipc	ra,0x0
 34a:	288080e7          	jalr	648(ra) # 5ce <fstat>
 34e:	87aa                	mv	a5,a0
 350:	fef42423          	sw	a5,-24(s0)
  close(fd);
 354:	fec42783          	lw	a5,-20(s0)
 358:	853e                	mv	a0,a5
 35a:	00000097          	auipc	ra,0x0
 35e:	244080e7          	jalr	580(ra) # 59e <close>
  return r;
 362:	fe842783          	lw	a5,-24(s0)
}
 366:	853e                	mv	a0,a5
 368:	70a2                	ld	ra,40(sp)
 36a:	7402                	ld	s0,32(sp)
 36c:	6145                	addi	sp,sp,48
 36e:	8082                	ret

0000000000000370 <atoi>:

int
atoi(const char *s)
{
 370:	7179                	addi	sp,sp,-48
 372:	f406                	sd	ra,40(sp)
 374:	f022                	sd	s0,32(sp)
 376:	1800                	addi	s0,sp,48
 378:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
 37c:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
 380:	a81d                	j	3b6 <atoi+0x46>
    n = n*10 + *s++ - '0';
 382:	fec42783          	lw	a5,-20(s0)
 386:	873e                	mv	a4,a5
 388:	87ba                	mv	a5,a4
 38a:	0027979b          	slliw	a5,a5,0x2
 38e:	9fb9                	addw	a5,a5,a4
 390:	0017979b          	slliw	a5,a5,0x1
 394:	0007871b          	sext.w	a4,a5
 398:	fd843783          	ld	a5,-40(s0)
 39c:	00178693          	addi	a3,a5,1
 3a0:	fcd43c23          	sd	a3,-40(s0)
 3a4:	0007c783          	lbu	a5,0(a5)
 3a8:	2781                	sext.w	a5,a5
 3aa:	9fb9                	addw	a5,a5,a4
 3ac:	2781                	sext.w	a5,a5
 3ae:	fd07879b          	addiw	a5,a5,-48
 3b2:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
 3b6:	fd843783          	ld	a5,-40(s0)
 3ba:	0007c783          	lbu	a5,0(a5)
 3be:	873e                	mv	a4,a5
 3c0:	02f00793          	li	a5,47
 3c4:	00e7fb63          	bgeu	a5,a4,3da <atoi+0x6a>
 3c8:	fd843783          	ld	a5,-40(s0)
 3cc:	0007c783          	lbu	a5,0(a5)
 3d0:	873e                	mv	a4,a5
 3d2:	03900793          	li	a5,57
 3d6:	fae7f6e3          	bgeu	a5,a4,382 <atoi+0x12>
  return n;
 3da:	fec42783          	lw	a5,-20(s0)
}
 3de:	853e                	mv	a0,a5
 3e0:	70a2                	ld	ra,40(sp)
 3e2:	7402                	ld	s0,32(sp)
 3e4:	6145                	addi	sp,sp,48
 3e6:	8082                	ret

00000000000003e8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3e8:	7139                	addi	sp,sp,-64
 3ea:	fc06                	sd	ra,56(sp)
 3ec:	f822                	sd	s0,48(sp)
 3ee:	0080                	addi	s0,sp,64
 3f0:	fca43c23          	sd	a0,-40(s0)
 3f4:	fcb43823          	sd	a1,-48(s0)
 3f8:	87b2                	mv	a5,a2
 3fa:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
 3fe:	fd843783          	ld	a5,-40(s0)
 402:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
 406:	fd043783          	ld	a5,-48(s0)
 40a:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
 40e:	fe043703          	ld	a4,-32(s0)
 412:	fe843783          	ld	a5,-24(s0)
 416:	02e7fc63          	bgeu	a5,a4,44e <memmove+0x66>
    while(n-- > 0)
 41a:	a00d                	j	43c <memmove+0x54>
      *dst++ = *src++;
 41c:	fe043703          	ld	a4,-32(s0)
 420:	00170793          	addi	a5,a4,1
 424:	fef43023          	sd	a5,-32(s0)
 428:	fe843783          	ld	a5,-24(s0)
 42c:	00178693          	addi	a3,a5,1
 430:	fed43423          	sd	a3,-24(s0)
 434:	00074703          	lbu	a4,0(a4)
 438:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 43c:	fcc42783          	lw	a5,-52(s0)
 440:	fff7871b          	addiw	a4,a5,-1
 444:	fce42623          	sw	a4,-52(s0)
 448:	fcf04ae3          	bgtz	a5,41c <memmove+0x34>
 44c:	a891                	j	4a0 <memmove+0xb8>
  } else {
    dst += n;
 44e:	fcc42783          	lw	a5,-52(s0)
 452:	fe843703          	ld	a4,-24(s0)
 456:	97ba                	add	a5,a5,a4
 458:	fef43423          	sd	a5,-24(s0)
    src += n;
 45c:	fcc42783          	lw	a5,-52(s0)
 460:	fe043703          	ld	a4,-32(s0)
 464:	97ba                	add	a5,a5,a4
 466:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
 46a:	a01d                	j	490 <memmove+0xa8>
      *--dst = *--src;
 46c:	fe043783          	ld	a5,-32(s0)
 470:	17fd                	addi	a5,a5,-1
 472:	fef43023          	sd	a5,-32(s0)
 476:	fe843783          	ld	a5,-24(s0)
 47a:	17fd                	addi	a5,a5,-1
 47c:	fef43423          	sd	a5,-24(s0)
 480:	fe043783          	ld	a5,-32(s0)
 484:	0007c703          	lbu	a4,0(a5)
 488:	fe843783          	ld	a5,-24(s0)
 48c:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 490:	fcc42783          	lw	a5,-52(s0)
 494:	fff7871b          	addiw	a4,a5,-1
 498:	fce42623          	sw	a4,-52(s0)
 49c:	fcf048e3          	bgtz	a5,46c <memmove+0x84>
  }
  return vdst;
 4a0:	fd843783          	ld	a5,-40(s0)
}
 4a4:	853e                	mv	a0,a5
 4a6:	70e2                	ld	ra,56(sp)
 4a8:	7442                	ld	s0,48(sp)
 4aa:	6121                	addi	sp,sp,64
 4ac:	8082                	ret

00000000000004ae <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4ae:	7139                	addi	sp,sp,-64
 4b0:	fc06                	sd	ra,56(sp)
 4b2:	f822                	sd	s0,48(sp)
 4b4:	0080                	addi	s0,sp,64
 4b6:	fca43c23          	sd	a0,-40(s0)
 4ba:	fcb43823          	sd	a1,-48(s0)
 4be:	87b2                	mv	a5,a2
 4c0:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
 4c4:	fd843783          	ld	a5,-40(s0)
 4c8:	fef43423          	sd	a5,-24(s0)
 4cc:	fd043783          	ld	a5,-48(s0)
 4d0:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 4d4:	a0a1                	j	51c <memcmp+0x6e>
    if (*p1 != *p2) {
 4d6:	fe843783          	ld	a5,-24(s0)
 4da:	0007c703          	lbu	a4,0(a5)
 4de:	fe043783          	ld	a5,-32(s0)
 4e2:	0007c783          	lbu	a5,0(a5)
 4e6:	02f70163          	beq	a4,a5,508 <memcmp+0x5a>
      return *p1 - *p2;
 4ea:	fe843783          	ld	a5,-24(s0)
 4ee:	0007c783          	lbu	a5,0(a5)
 4f2:	0007871b          	sext.w	a4,a5
 4f6:	fe043783          	ld	a5,-32(s0)
 4fa:	0007c783          	lbu	a5,0(a5)
 4fe:	2781                	sext.w	a5,a5
 500:	40f707bb          	subw	a5,a4,a5
 504:	2781                	sext.w	a5,a5
 506:	a01d                	j	52c <memcmp+0x7e>
    }
    p1++;
 508:	fe843783          	ld	a5,-24(s0)
 50c:	0785                	addi	a5,a5,1
 50e:	fef43423          	sd	a5,-24(s0)
    p2++;
 512:	fe043783          	ld	a5,-32(s0)
 516:	0785                	addi	a5,a5,1
 518:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 51c:	fcc42783          	lw	a5,-52(s0)
 520:	fff7871b          	addiw	a4,a5,-1
 524:	fce42623          	sw	a4,-52(s0)
 528:	f7dd                	bnez	a5,4d6 <memcmp+0x28>
  }
  return 0;
 52a:	4781                	li	a5,0
}
 52c:	853e                	mv	a0,a5
 52e:	70e2                	ld	ra,56(sp)
 530:	7442                	ld	s0,48(sp)
 532:	6121                	addi	sp,sp,64
 534:	8082                	ret

0000000000000536 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 536:	7179                	addi	sp,sp,-48
 538:	f406                	sd	ra,40(sp)
 53a:	f022                	sd	s0,32(sp)
 53c:	1800                	addi	s0,sp,48
 53e:	fea43423          	sd	a0,-24(s0)
 542:	feb43023          	sd	a1,-32(s0)
 546:	87b2                	mv	a5,a2
 548:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
 54c:	fdc42783          	lw	a5,-36(s0)
 550:	863e                	mv	a2,a5
 552:	fe043583          	ld	a1,-32(s0)
 556:	fe843503          	ld	a0,-24(s0)
 55a:	00000097          	auipc	ra,0x0
 55e:	e8e080e7          	jalr	-370(ra) # 3e8 <memmove>
 562:	87aa                	mv	a5,a0
}
 564:	853e                	mv	a0,a5
 566:	70a2                	ld	ra,40(sp)
 568:	7402                	ld	s0,32(sp)
 56a:	6145                	addi	sp,sp,48
 56c:	8082                	ret

000000000000056e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 56e:	4885                	li	a7,1
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <exit>:
.global exit
exit:
 li a7, SYS_exit
 576:	4889                	li	a7,2
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <wait>:
.global wait
wait:
 li a7, SYS_wait
 57e:	488d                	li	a7,3
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 586:	4891                	li	a7,4
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <read>:
.global read
read:
 li a7, SYS_read
 58e:	4895                	li	a7,5
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <write>:
.global write
write:
 li a7, SYS_write
 596:	48c1                	li	a7,16
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <close>:
.global close
close:
 li a7, SYS_close
 59e:	48d5                	li	a7,21
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 5a6:	4899                	li	a7,6
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <exec>:
.global exec
exec:
 li a7, SYS_exec
 5ae:	489d                	li	a7,7
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <open>:
.global open
open:
 li a7, SYS_open
 5b6:	48bd                	li	a7,15
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5be:	48c5                	li	a7,17
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5c6:	48c9                	li	a7,18
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5ce:	48a1                	li	a7,8
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <link>:
.global link
link:
 li a7, SYS_link
 5d6:	48cd                	li	a7,19
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5de:	48d1                	li	a7,20
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	8082                	ret

00000000000005e6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5e6:	48a5                	li	a7,9
 ecall
 5e8:	00000073          	ecall
 ret
 5ec:	8082                	ret

00000000000005ee <dup>:
.global dup
dup:
 li a7, SYS_dup
 5ee:	48a9                	li	a7,10
 ecall
 5f0:	00000073          	ecall
 ret
 5f4:	8082                	ret

00000000000005f6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5f6:	48ad                	li	a7,11
 ecall
 5f8:	00000073          	ecall
 ret
 5fc:	8082                	ret

00000000000005fe <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5fe:	48b1                	li	a7,12
 ecall
 600:	00000073          	ecall
 ret
 604:	8082                	ret

0000000000000606 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 606:	48b5                	li	a7,13
 ecall
 608:	00000073          	ecall
 ret
 60c:	8082                	ret

000000000000060e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 60e:	48b9                	li	a7,14
 ecall
 610:	00000073          	ecall
 ret
 614:	8082                	ret

0000000000000616 <ps>:
.global ps
ps:
 li a7, SYS_ps
 616:	48d9                	li	a7,22
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
 646:	f54080e7          	jalr	-172(ra) # 596 <write>
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
 95e:	4be78793          	addi	a5,a5,1214 # e18 <malloc+0x182>
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
 c4a:	9b8080e7          	jalr	-1608(ra) # 5fe <sbrk>
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
