
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
  24:	db058593          	addi	a1,a1,-592 # dd0 <malloc+0x142>
  28:	4509                	li	a0,2
  2a:	00001097          	auipc	ra,0x1
  2e:	a18080e7          	jalr	-1512(ra) # a42 <fprintf>
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
  76:	d7658593          	addi	a1,a1,-650 # de8 <malloc+0x15a>
  7a:	4509                	li	a0,2
  7c:	00001097          	auipc	ra,0x1
  80:	9c6080e7          	jalr	-1594(ra) # a42 <fprintf>
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

0000000000000616 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 616:	1101                	addi	sp,sp,-32
 618:	ec06                	sd	ra,24(sp)
 61a:	e822                	sd	s0,16(sp)
 61c:	1000                	addi	s0,sp,32
 61e:	87aa                	mv	a5,a0
 620:	872e                	mv	a4,a1
 622:	fef42623          	sw	a5,-20(s0)
 626:	87ba                	mv	a5,a4
 628:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 62c:	feb40713          	addi	a4,s0,-21
 630:	fec42783          	lw	a5,-20(s0)
 634:	4605                	li	a2,1
 636:	85ba                	mv	a1,a4
 638:	853e                	mv	a0,a5
 63a:	00000097          	auipc	ra,0x0
 63e:	f5c080e7          	jalr	-164(ra) # 596 <write>
}
 642:	0001                	nop
 644:	60e2                	ld	ra,24(sp)
 646:	6442                	ld	s0,16(sp)
 648:	6105                	addi	sp,sp,32
 64a:	8082                	ret

000000000000064c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 64c:	7139                	addi	sp,sp,-64
 64e:	fc06                	sd	ra,56(sp)
 650:	f822                	sd	s0,48(sp)
 652:	0080                	addi	s0,sp,64
 654:	87aa                	mv	a5,a0
 656:	8736                	mv	a4,a3
 658:	fcf42623          	sw	a5,-52(s0)
 65c:	87ae                	mv	a5,a1
 65e:	fcf42423          	sw	a5,-56(s0)
 662:	87b2                	mv	a5,a2
 664:	fcf42223          	sw	a5,-60(s0)
 668:	87ba                	mv	a5,a4
 66a:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 66e:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 672:	fc042783          	lw	a5,-64(s0)
 676:	2781                	sext.w	a5,a5
 678:	c38d                	beqz	a5,69a <printint+0x4e>
 67a:	fc842783          	lw	a5,-56(s0)
 67e:	2781                	sext.w	a5,a5
 680:	0007dd63          	bgez	a5,69a <printint+0x4e>
    neg = 1;
 684:	4785                	li	a5,1
 686:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 68a:	fc842783          	lw	a5,-56(s0)
 68e:	40f007bb          	negw	a5,a5
 692:	2781                	sext.w	a5,a5
 694:	fef42223          	sw	a5,-28(s0)
 698:	a029                	j	6a2 <printint+0x56>
  } else {
    x = xx;
 69a:	fc842783          	lw	a5,-56(s0)
 69e:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 6a2:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 6a6:	fc442783          	lw	a5,-60(s0)
 6aa:	fe442703          	lw	a4,-28(s0)
 6ae:	02f777bb          	remuw	a5,a4,a5
 6b2:	0007871b          	sext.w	a4,a5
 6b6:	fec42783          	lw	a5,-20(s0)
 6ba:	0017869b          	addiw	a3,a5,1
 6be:	fed42623          	sw	a3,-20(s0)
 6c2:	00001697          	auipc	a3,0x1
 6c6:	93e68693          	addi	a3,a3,-1730 # 1000 <digits>
 6ca:	1702                	slli	a4,a4,0x20
 6cc:	9301                	srli	a4,a4,0x20
 6ce:	9736                	add	a4,a4,a3
 6d0:	00074703          	lbu	a4,0(a4)
 6d4:	17c1                	addi	a5,a5,-16
 6d6:	97a2                	add	a5,a5,s0
 6d8:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 6dc:	fc442783          	lw	a5,-60(s0)
 6e0:	fe442703          	lw	a4,-28(s0)
 6e4:	02f757bb          	divuw	a5,a4,a5
 6e8:	fef42223          	sw	a5,-28(s0)
 6ec:	fe442783          	lw	a5,-28(s0)
 6f0:	2781                	sext.w	a5,a5
 6f2:	fbd5                	bnez	a5,6a6 <printint+0x5a>
  if(neg)
 6f4:	fe842783          	lw	a5,-24(s0)
 6f8:	2781                	sext.w	a5,a5
 6fa:	cf85                	beqz	a5,732 <printint+0xe6>
    buf[i++] = '-';
 6fc:	fec42783          	lw	a5,-20(s0)
 700:	0017871b          	addiw	a4,a5,1
 704:	fee42623          	sw	a4,-20(s0)
 708:	17c1                	addi	a5,a5,-16
 70a:	97a2                	add	a5,a5,s0
 70c:	02d00713          	li	a4,45
 710:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 714:	a839                	j	732 <printint+0xe6>
    putc(fd, buf[i]);
 716:	fec42783          	lw	a5,-20(s0)
 71a:	17c1                	addi	a5,a5,-16
 71c:	97a2                	add	a5,a5,s0
 71e:	fe07c703          	lbu	a4,-32(a5)
 722:	fcc42783          	lw	a5,-52(s0)
 726:	85ba                	mv	a1,a4
 728:	853e                	mv	a0,a5
 72a:	00000097          	auipc	ra,0x0
 72e:	eec080e7          	jalr	-276(ra) # 616 <putc>
  while(--i >= 0)
 732:	fec42783          	lw	a5,-20(s0)
 736:	37fd                	addiw	a5,a5,-1
 738:	fef42623          	sw	a5,-20(s0)
 73c:	fec42783          	lw	a5,-20(s0)
 740:	2781                	sext.w	a5,a5
 742:	fc07dae3          	bgez	a5,716 <printint+0xca>
}
 746:	0001                	nop
 748:	0001                	nop
 74a:	70e2                	ld	ra,56(sp)
 74c:	7442                	ld	s0,48(sp)
 74e:	6121                	addi	sp,sp,64
 750:	8082                	ret

0000000000000752 <printptr>:

static void
printptr(int fd, uint64 x) {
 752:	7179                	addi	sp,sp,-48
 754:	f406                	sd	ra,40(sp)
 756:	f022                	sd	s0,32(sp)
 758:	1800                	addi	s0,sp,48
 75a:	87aa                	mv	a5,a0
 75c:	fcb43823          	sd	a1,-48(s0)
 760:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 764:	fdc42783          	lw	a5,-36(s0)
 768:	03000593          	li	a1,48
 76c:	853e                	mv	a0,a5
 76e:	00000097          	auipc	ra,0x0
 772:	ea8080e7          	jalr	-344(ra) # 616 <putc>
  putc(fd, 'x');
 776:	fdc42783          	lw	a5,-36(s0)
 77a:	07800593          	li	a1,120
 77e:	853e                	mv	a0,a5
 780:	00000097          	auipc	ra,0x0
 784:	e96080e7          	jalr	-362(ra) # 616 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 788:	fe042623          	sw	zero,-20(s0)
 78c:	a82d                	j	7c6 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 78e:	fd043783          	ld	a5,-48(s0)
 792:	93f1                	srli	a5,a5,0x3c
 794:	00001717          	auipc	a4,0x1
 798:	86c70713          	addi	a4,a4,-1940 # 1000 <digits>
 79c:	97ba                	add	a5,a5,a4
 79e:	0007c703          	lbu	a4,0(a5)
 7a2:	fdc42783          	lw	a5,-36(s0)
 7a6:	85ba                	mv	a1,a4
 7a8:	853e                	mv	a0,a5
 7aa:	00000097          	auipc	ra,0x0
 7ae:	e6c080e7          	jalr	-404(ra) # 616 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7b2:	fec42783          	lw	a5,-20(s0)
 7b6:	2785                	addiw	a5,a5,1
 7b8:	fef42623          	sw	a5,-20(s0)
 7bc:	fd043783          	ld	a5,-48(s0)
 7c0:	0792                	slli	a5,a5,0x4
 7c2:	fcf43823          	sd	a5,-48(s0)
 7c6:	fec42703          	lw	a4,-20(s0)
 7ca:	47bd                	li	a5,15
 7cc:	fce7f1e3          	bgeu	a5,a4,78e <printptr+0x3c>
}
 7d0:	0001                	nop
 7d2:	0001                	nop
 7d4:	70a2                	ld	ra,40(sp)
 7d6:	7402                	ld	s0,32(sp)
 7d8:	6145                	addi	sp,sp,48
 7da:	8082                	ret

00000000000007dc <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7dc:	715d                	addi	sp,sp,-80
 7de:	e486                	sd	ra,72(sp)
 7e0:	e0a2                	sd	s0,64(sp)
 7e2:	0880                	addi	s0,sp,80
 7e4:	87aa                	mv	a5,a0
 7e6:	fcb43023          	sd	a1,-64(s0)
 7ea:	fac43c23          	sd	a2,-72(s0)
 7ee:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 7f2:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 7f6:	fe042223          	sw	zero,-28(s0)
 7fa:	a42d                	j	a24 <vprintf+0x248>
    c = fmt[i] & 0xff;
 7fc:	fe442783          	lw	a5,-28(s0)
 800:	fc043703          	ld	a4,-64(s0)
 804:	97ba                	add	a5,a5,a4
 806:	0007c783          	lbu	a5,0(a5)
 80a:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 80e:	fe042783          	lw	a5,-32(s0)
 812:	2781                	sext.w	a5,a5
 814:	eb9d                	bnez	a5,84a <vprintf+0x6e>
      if(c == '%'){
 816:	fdc42783          	lw	a5,-36(s0)
 81a:	0007871b          	sext.w	a4,a5
 81e:	02500793          	li	a5,37
 822:	00f71763          	bne	a4,a5,830 <vprintf+0x54>
        state = '%';
 826:	02500793          	li	a5,37
 82a:	fef42023          	sw	a5,-32(s0)
 82e:	a2f5                	j	a1a <vprintf+0x23e>
      } else {
        putc(fd, c);
 830:	fdc42783          	lw	a5,-36(s0)
 834:	0ff7f713          	zext.b	a4,a5
 838:	fcc42783          	lw	a5,-52(s0)
 83c:	85ba                	mv	a1,a4
 83e:	853e                	mv	a0,a5
 840:	00000097          	auipc	ra,0x0
 844:	dd6080e7          	jalr	-554(ra) # 616 <putc>
 848:	aac9                	j	a1a <vprintf+0x23e>
      }
    } else if(state == '%'){
 84a:	fe042783          	lw	a5,-32(s0)
 84e:	0007871b          	sext.w	a4,a5
 852:	02500793          	li	a5,37
 856:	1cf71263          	bne	a4,a5,a1a <vprintf+0x23e>
      if(c == 'd'){
 85a:	fdc42783          	lw	a5,-36(s0)
 85e:	0007871b          	sext.w	a4,a5
 862:	06400793          	li	a5,100
 866:	02f71463          	bne	a4,a5,88e <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 86a:	fb843783          	ld	a5,-72(s0)
 86e:	00878713          	addi	a4,a5,8
 872:	fae43c23          	sd	a4,-72(s0)
 876:	4398                	lw	a4,0(a5)
 878:	fcc42783          	lw	a5,-52(s0)
 87c:	4685                	li	a3,1
 87e:	4629                	li	a2,10
 880:	85ba                	mv	a1,a4
 882:	853e                	mv	a0,a5
 884:	00000097          	auipc	ra,0x0
 888:	dc8080e7          	jalr	-568(ra) # 64c <printint>
 88c:	a269                	j	a16 <vprintf+0x23a>
      } else if(c == 'l') {
 88e:	fdc42783          	lw	a5,-36(s0)
 892:	0007871b          	sext.w	a4,a5
 896:	06c00793          	li	a5,108
 89a:	02f71663          	bne	a4,a5,8c6 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 89e:	fb843783          	ld	a5,-72(s0)
 8a2:	00878713          	addi	a4,a5,8
 8a6:	fae43c23          	sd	a4,-72(s0)
 8aa:	639c                	ld	a5,0(a5)
 8ac:	0007871b          	sext.w	a4,a5
 8b0:	fcc42783          	lw	a5,-52(s0)
 8b4:	4681                	li	a3,0
 8b6:	4629                	li	a2,10
 8b8:	85ba                	mv	a1,a4
 8ba:	853e                	mv	a0,a5
 8bc:	00000097          	auipc	ra,0x0
 8c0:	d90080e7          	jalr	-624(ra) # 64c <printint>
 8c4:	aa89                	j	a16 <vprintf+0x23a>
      } else if(c == 'x') {
 8c6:	fdc42783          	lw	a5,-36(s0)
 8ca:	0007871b          	sext.w	a4,a5
 8ce:	07800793          	li	a5,120
 8d2:	02f71463          	bne	a4,a5,8fa <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 8d6:	fb843783          	ld	a5,-72(s0)
 8da:	00878713          	addi	a4,a5,8
 8de:	fae43c23          	sd	a4,-72(s0)
 8e2:	4398                	lw	a4,0(a5)
 8e4:	fcc42783          	lw	a5,-52(s0)
 8e8:	4681                	li	a3,0
 8ea:	4641                	li	a2,16
 8ec:	85ba                	mv	a1,a4
 8ee:	853e                	mv	a0,a5
 8f0:	00000097          	auipc	ra,0x0
 8f4:	d5c080e7          	jalr	-676(ra) # 64c <printint>
 8f8:	aa39                	j	a16 <vprintf+0x23a>
      } else if(c == 'p') {
 8fa:	fdc42783          	lw	a5,-36(s0)
 8fe:	0007871b          	sext.w	a4,a5
 902:	07000793          	li	a5,112
 906:	02f71263          	bne	a4,a5,92a <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 90a:	fb843783          	ld	a5,-72(s0)
 90e:	00878713          	addi	a4,a5,8
 912:	fae43c23          	sd	a4,-72(s0)
 916:	6398                	ld	a4,0(a5)
 918:	fcc42783          	lw	a5,-52(s0)
 91c:	85ba                	mv	a1,a4
 91e:	853e                	mv	a0,a5
 920:	00000097          	auipc	ra,0x0
 924:	e32080e7          	jalr	-462(ra) # 752 <printptr>
 928:	a0fd                	j	a16 <vprintf+0x23a>
      } else if(c == 's'){
 92a:	fdc42783          	lw	a5,-36(s0)
 92e:	0007871b          	sext.w	a4,a5
 932:	07300793          	li	a5,115
 936:	04f71c63          	bne	a4,a5,98e <vprintf+0x1b2>
        s = va_arg(ap, char*);
 93a:	fb843783          	ld	a5,-72(s0)
 93e:	00878713          	addi	a4,a5,8
 942:	fae43c23          	sd	a4,-72(s0)
 946:	639c                	ld	a5,0(a5)
 948:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 94c:	fe843783          	ld	a5,-24(s0)
 950:	eb8d                	bnez	a5,982 <vprintf+0x1a6>
          s = "(null)";
 952:	00000797          	auipc	a5,0x0
 956:	4b678793          	addi	a5,a5,1206 # e08 <malloc+0x17a>
 95a:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 95e:	a015                	j	982 <vprintf+0x1a6>
          putc(fd, *s);
 960:	fe843783          	ld	a5,-24(s0)
 964:	0007c703          	lbu	a4,0(a5)
 968:	fcc42783          	lw	a5,-52(s0)
 96c:	85ba                	mv	a1,a4
 96e:	853e                	mv	a0,a5
 970:	00000097          	auipc	ra,0x0
 974:	ca6080e7          	jalr	-858(ra) # 616 <putc>
          s++;
 978:	fe843783          	ld	a5,-24(s0)
 97c:	0785                	addi	a5,a5,1
 97e:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 982:	fe843783          	ld	a5,-24(s0)
 986:	0007c783          	lbu	a5,0(a5)
 98a:	fbf9                	bnez	a5,960 <vprintf+0x184>
 98c:	a069                	j	a16 <vprintf+0x23a>
        }
      } else if(c == 'c'){
 98e:	fdc42783          	lw	a5,-36(s0)
 992:	0007871b          	sext.w	a4,a5
 996:	06300793          	li	a5,99
 99a:	02f71463          	bne	a4,a5,9c2 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 99e:	fb843783          	ld	a5,-72(s0)
 9a2:	00878713          	addi	a4,a5,8
 9a6:	fae43c23          	sd	a4,-72(s0)
 9aa:	439c                	lw	a5,0(a5)
 9ac:	0ff7f713          	zext.b	a4,a5
 9b0:	fcc42783          	lw	a5,-52(s0)
 9b4:	85ba                	mv	a1,a4
 9b6:	853e                	mv	a0,a5
 9b8:	00000097          	auipc	ra,0x0
 9bc:	c5e080e7          	jalr	-930(ra) # 616 <putc>
 9c0:	a899                	j	a16 <vprintf+0x23a>
      } else if(c == '%'){
 9c2:	fdc42783          	lw	a5,-36(s0)
 9c6:	0007871b          	sext.w	a4,a5
 9ca:	02500793          	li	a5,37
 9ce:	00f71f63          	bne	a4,a5,9ec <vprintf+0x210>
        putc(fd, c);
 9d2:	fdc42783          	lw	a5,-36(s0)
 9d6:	0ff7f713          	zext.b	a4,a5
 9da:	fcc42783          	lw	a5,-52(s0)
 9de:	85ba                	mv	a1,a4
 9e0:	853e                	mv	a0,a5
 9e2:	00000097          	auipc	ra,0x0
 9e6:	c34080e7          	jalr	-972(ra) # 616 <putc>
 9ea:	a035                	j	a16 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9ec:	fcc42783          	lw	a5,-52(s0)
 9f0:	02500593          	li	a1,37
 9f4:	853e                	mv	a0,a5
 9f6:	00000097          	auipc	ra,0x0
 9fa:	c20080e7          	jalr	-992(ra) # 616 <putc>
        putc(fd, c);
 9fe:	fdc42783          	lw	a5,-36(s0)
 a02:	0ff7f713          	zext.b	a4,a5
 a06:	fcc42783          	lw	a5,-52(s0)
 a0a:	85ba                	mv	a1,a4
 a0c:	853e                	mv	a0,a5
 a0e:	00000097          	auipc	ra,0x0
 a12:	c08080e7          	jalr	-1016(ra) # 616 <putc>
      }
      state = 0;
 a16:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 a1a:	fe442783          	lw	a5,-28(s0)
 a1e:	2785                	addiw	a5,a5,1
 a20:	fef42223          	sw	a5,-28(s0)
 a24:	fe442783          	lw	a5,-28(s0)
 a28:	fc043703          	ld	a4,-64(s0)
 a2c:	97ba                	add	a5,a5,a4
 a2e:	0007c783          	lbu	a5,0(a5)
 a32:	dc0795e3          	bnez	a5,7fc <vprintf+0x20>
    }
  }
}
 a36:	0001                	nop
 a38:	0001                	nop
 a3a:	60a6                	ld	ra,72(sp)
 a3c:	6406                	ld	s0,64(sp)
 a3e:	6161                	addi	sp,sp,80
 a40:	8082                	ret

0000000000000a42 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a42:	7159                	addi	sp,sp,-112
 a44:	fc06                	sd	ra,56(sp)
 a46:	f822                	sd	s0,48(sp)
 a48:	0080                	addi	s0,sp,64
 a4a:	fcb43823          	sd	a1,-48(s0)
 a4e:	e010                	sd	a2,0(s0)
 a50:	e414                	sd	a3,8(s0)
 a52:	e818                	sd	a4,16(s0)
 a54:	ec1c                	sd	a5,24(s0)
 a56:	03043023          	sd	a6,32(s0)
 a5a:	03143423          	sd	a7,40(s0)
 a5e:	87aa                	mv	a5,a0
 a60:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 a64:	03040793          	addi	a5,s0,48
 a68:	fcf43423          	sd	a5,-56(s0)
 a6c:	fc843783          	ld	a5,-56(s0)
 a70:	fd078793          	addi	a5,a5,-48
 a74:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 a78:	fe843703          	ld	a4,-24(s0)
 a7c:	fdc42783          	lw	a5,-36(s0)
 a80:	863a                	mv	a2,a4
 a82:	fd043583          	ld	a1,-48(s0)
 a86:	853e                	mv	a0,a5
 a88:	00000097          	auipc	ra,0x0
 a8c:	d54080e7          	jalr	-684(ra) # 7dc <vprintf>
}
 a90:	0001                	nop
 a92:	70e2                	ld	ra,56(sp)
 a94:	7442                	ld	s0,48(sp)
 a96:	6165                	addi	sp,sp,112
 a98:	8082                	ret

0000000000000a9a <printf>:

void
printf(const char *fmt, ...)
{
 a9a:	7159                	addi	sp,sp,-112
 a9c:	f406                	sd	ra,40(sp)
 a9e:	f022                	sd	s0,32(sp)
 aa0:	1800                	addi	s0,sp,48
 aa2:	fca43c23          	sd	a0,-40(s0)
 aa6:	e40c                	sd	a1,8(s0)
 aa8:	e810                	sd	a2,16(s0)
 aaa:	ec14                	sd	a3,24(s0)
 aac:	f018                	sd	a4,32(s0)
 aae:	f41c                	sd	a5,40(s0)
 ab0:	03043823          	sd	a6,48(s0)
 ab4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 ab8:	04040793          	addi	a5,s0,64
 abc:	fcf43823          	sd	a5,-48(s0)
 ac0:	fd043783          	ld	a5,-48(s0)
 ac4:	fc878793          	addi	a5,a5,-56
 ac8:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 acc:	fe843783          	ld	a5,-24(s0)
 ad0:	863e                	mv	a2,a5
 ad2:	fd843583          	ld	a1,-40(s0)
 ad6:	4505                	li	a0,1
 ad8:	00000097          	auipc	ra,0x0
 adc:	d04080e7          	jalr	-764(ra) # 7dc <vprintf>
}
 ae0:	0001                	nop
 ae2:	70a2                	ld	ra,40(sp)
 ae4:	7402                	ld	s0,32(sp)
 ae6:	6165                	addi	sp,sp,112
 ae8:	8082                	ret

0000000000000aea <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 aea:	7179                	addi	sp,sp,-48
 aec:	f406                	sd	ra,40(sp)
 aee:	f022                	sd	s0,32(sp)
 af0:	1800                	addi	s0,sp,48
 af2:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 af6:	fd843783          	ld	a5,-40(s0)
 afa:	17c1                	addi	a5,a5,-16
 afc:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b00:	00000797          	auipc	a5,0x0
 b04:	53078793          	addi	a5,a5,1328 # 1030 <freep>
 b08:	639c                	ld	a5,0(a5)
 b0a:	fef43423          	sd	a5,-24(s0)
 b0e:	a815                	j	b42 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b10:	fe843783          	ld	a5,-24(s0)
 b14:	639c                	ld	a5,0(a5)
 b16:	fe843703          	ld	a4,-24(s0)
 b1a:	00f76f63          	bltu	a4,a5,b38 <free+0x4e>
 b1e:	fe043703          	ld	a4,-32(s0)
 b22:	fe843783          	ld	a5,-24(s0)
 b26:	02e7eb63          	bltu	a5,a4,b5c <free+0x72>
 b2a:	fe843783          	ld	a5,-24(s0)
 b2e:	639c                	ld	a5,0(a5)
 b30:	fe043703          	ld	a4,-32(s0)
 b34:	02f76463          	bltu	a4,a5,b5c <free+0x72>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b38:	fe843783          	ld	a5,-24(s0)
 b3c:	639c                	ld	a5,0(a5)
 b3e:	fef43423          	sd	a5,-24(s0)
 b42:	fe043703          	ld	a4,-32(s0)
 b46:	fe843783          	ld	a5,-24(s0)
 b4a:	fce7f3e3          	bgeu	a5,a4,b10 <free+0x26>
 b4e:	fe843783          	ld	a5,-24(s0)
 b52:	639c                	ld	a5,0(a5)
 b54:	fe043703          	ld	a4,-32(s0)
 b58:	faf77ce3          	bgeu	a4,a5,b10 <free+0x26>
      break;
  if(bp + bp->s.size == p->s.ptr){
 b5c:	fe043783          	ld	a5,-32(s0)
 b60:	479c                	lw	a5,8(a5)
 b62:	1782                	slli	a5,a5,0x20
 b64:	9381                	srli	a5,a5,0x20
 b66:	0792                	slli	a5,a5,0x4
 b68:	fe043703          	ld	a4,-32(s0)
 b6c:	973e                	add	a4,a4,a5
 b6e:	fe843783          	ld	a5,-24(s0)
 b72:	639c                	ld	a5,0(a5)
 b74:	02f71763          	bne	a4,a5,ba2 <free+0xb8>
    bp->s.size += p->s.ptr->s.size;
 b78:	fe043783          	ld	a5,-32(s0)
 b7c:	4798                	lw	a4,8(a5)
 b7e:	fe843783          	ld	a5,-24(s0)
 b82:	639c                	ld	a5,0(a5)
 b84:	479c                	lw	a5,8(a5)
 b86:	9fb9                	addw	a5,a5,a4
 b88:	0007871b          	sext.w	a4,a5
 b8c:	fe043783          	ld	a5,-32(s0)
 b90:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 b92:	fe843783          	ld	a5,-24(s0)
 b96:	639c                	ld	a5,0(a5)
 b98:	6398                	ld	a4,0(a5)
 b9a:	fe043783          	ld	a5,-32(s0)
 b9e:	e398                	sd	a4,0(a5)
 ba0:	a039                	j	bae <free+0xc4>
  } else
    bp->s.ptr = p->s.ptr;
 ba2:	fe843783          	ld	a5,-24(s0)
 ba6:	6398                	ld	a4,0(a5)
 ba8:	fe043783          	ld	a5,-32(s0)
 bac:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 bae:	fe843783          	ld	a5,-24(s0)
 bb2:	479c                	lw	a5,8(a5)
 bb4:	1782                	slli	a5,a5,0x20
 bb6:	9381                	srli	a5,a5,0x20
 bb8:	0792                	slli	a5,a5,0x4
 bba:	fe843703          	ld	a4,-24(s0)
 bbe:	97ba                	add	a5,a5,a4
 bc0:	fe043703          	ld	a4,-32(s0)
 bc4:	02f71563          	bne	a4,a5,bee <free+0x104>
    p->s.size += bp->s.size;
 bc8:	fe843783          	ld	a5,-24(s0)
 bcc:	4798                	lw	a4,8(a5)
 bce:	fe043783          	ld	a5,-32(s0)
 bd2:	479c                	lw	a5,8(a5)
 bd4:	9fb9                	addw	a5,a5,a4
 bd6:	0007871b          	sext.w	a4,a5
 bda:	fe843783          	ld	a5,-24(s0)
 bde:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 be0:	fe043783          	ld	a5,-32(s0)
 be4:	6398                	ld	a4,0(a5)
 be6:	fe843783          	ld	a5,-24(s0)
 bea:	e398                	sd	a4,0(a5)
 bec:	a031                	j	bf8 <free+0x10e>
  } else
    p->s.ptr = bp;
 bee:	fe843783          	ld	a5,-24(s0)
 bf2:	fe043703          	ld	a4,-32(s0)
 bf6:	e398                	sd	a4,0(a5)
  freep = p;
 bf8:	00000797          	auipc	a5,0x0
 bfc:	43878793          	addi	a5,a5,1080 # 1030 <freep>
 c00:	fe843703          	ld	a4,-24(s0)
 c04:	e398                	sd	a4,0(a5)
}
 c06:	0001                	nop
 c08:	70a2                	ld	ra,40(sp)
 c0a:	7402                	ld	s0,32(sp)
 c0c:	6145                	addi	sp,sp,48
 c0e:	8082                	ret

0000000000000c10 <morecore>:

static Header*
morecore(uint nu)
{
 c10:	7179                	addi	sp,sp,-48
 c12:	f406                	sd	ra,40(sp)
 c14:	f022                	sd	s0,32(sp)
 c16:	1800                	addi	s0,sp,48
 c18:	87aa                	mv	a5,a0
 c1a:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 c1e:	fdc42783          	lw	a5,-36(s0)
 c22:	0007871b          	sext.w	a4,a5
 c26:	6785                	lui	a5,0x1
 c28:	00f77563          	bgeu	a4,a5,c32 <morecore+0x22>
    nu = 4096;
 c2c:	6785                	lui	a5,0x1
 c2e:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 c32:	fdc42783          	lw	a5,-36(s0)
 c36:	0047979b          	slliw	a5,a5,0x4
 c3a:	2781                	sext.w	a5,a5
 c3c:	853e                	mv	a0,a5
 c3e:	00000097          	auipc	ra,0x0
 c42:	9c0080e7          	jalr	-1600(ra) # 5fe <sbrk>
 c46:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 c4a:	fe843703          	ld	a4,-24(s0)
 c4e:	57fd                	li	a5,-1
 c50:	00f71463          	bne	a4,a5,c58 <morecore+0x48>
    return 0;
 c54:	4781                	li	a5,0
 c56:	a03d                	j	c84 <morecore+0x74>
  hp = (Header*)p;
 c58:	fe843783          	ld	a5,-24(s0)
 c5c:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 c60:	fe043783          	ld	a5,-32(s0)
 c64:	fdc42703          	lw	a4,-36(s0)
 c68:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 c6a:	fe043783          	ld	a5,-32(s0)
 c6e:	07c1                	addi	a5,a5,16 # 1010 <digits+0x10>
 c70:	853e                	mv	a0,a5
 c72:	00000097          	auipc	ra,0x0
 c76:	e78080e7          	jalr	-392(ra) # aea <free>
  return freep;
 c7a:	00000797          	auipc	a5,0x0
 c7e:	3b678793          	addi	a5,a5,950 # 1030 <freep>
 c82:	639c                	ld	a5,0(a5)
}
 c84:	853e                	mv	a0,a5
 c86:	70a2                	ld	ra,40(sp)
 c88:	7402                	ld	s0,32(sp)
 c8a:	6145                	addi	sp,sp,48
 c8c:	8082                	ret

0000000000000c8e <malloc>:

void*
malloc(uint nbytes)
{
 c8e:	7139                	addi	sp,sp,-64
 c90:	fc06                	sd	ra,56(sp)
 c92:	f822                	sd	s0,48(sp)
 c94:	0080                	addi	s0,sp,64
 c96:	87aa                	mv	a5,a0
 c98:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c9c:	fcc46783          	lwu	a5,-52(s0)
 ca0:	07bd                	addi	a5,a5,15
 ca2:	8391                	srli	a5,a5,0x4
 ca4:	2781                	sext.w	a5,a5
 ca6:	2785                	addiw	a5,a5,1
 ca8:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 cac:	00000797          	auipc	a5,0x0
 cb0:	38478793          	addi	a5,a5,900 # 1030 <freep>
 cb4:	639c                	ld	a5,0(a5)
 cb6:	fef43023          	sd	a5,-32(s0)
 cba:	fe043783          	ld	a5,-32(s0)
 cbe:	ef95                	bnez	a5,cfa <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 cc0:	00000797          	auipc	a5,0x0
 cc4:	36078793          	addi	a5,a5,864 # 1020 <base>
 cc8:	fef43023          	sd	a5,-32(s0)
 ccc:	00000797          	auipc	a5,0x0
 cd0:	36478793          	addi	a5,a5,868 # 1030 <freep>
 cd4:	fe043703          	ld	a4,-32(s0)
 cd8:	e398                	sd	a4,0(a5)
 cda:	00000797          	auipc	a5,0x0
 cde:	35678793          	addi	a5,a5,854 # 1030 <freep>
 ce2:	6398                	ld	a4,0(a5)
 ce4:	00000797          	auipc	a5,0x0
 ce8:	33c78793          	addi	a5,a5,828 # 1020 <base>
 cec:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 cee:	00000797          	auipc	a5,0x0
 cf2:	33278793          	addi	a5,a5,818 # 1020 <base>
 cf6:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cfa:	fe043783          	ld	a5,-32(s0)
 cfe:	639c                	ld	a5,0(a5)
 d00:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 d04:	fe843783          	ld	a5,-24(s0)
 d08:	479c                	lw	a5,8(a5)
 d0a:	fdc42703          	lw	a4,-36(s0)
 d0e:	2701                	sext.w	a4,a4
 d10:	06e7e763          	bltu	a5,a4,d7e <malloc+0xf0>
      if(p->s.size == nunits)
 d14:	fe843783          	ld	a5,-24(s0)
 d18:	479c                	lw	a5,8(a5)
 d1a:	fdc42703          	lw	a4,-36(s0)
 d1e:	2701                	sext.w	a4,a4
 d20:	00f71963          	bne	a4,a5,d32 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 d24:	fe843783          	ld	a5,-24(s0)
 d28:	6398                	ld	a4,0(a5)
 d2a:	fe043783          	ld	a5,-32(s0)
 d2e:	e398                	sd	a4,0(a5)
 d30:	a825                	j	d68 <malloc+0xda>
      else {
        p->s.size -= nunits;
 d32:	fe843783          	ld	a5,-24(s0)
 d36:	479c                	lw	a5,8(a5)
 d38:	fdc42703          	lw	a4,-36(s0)
 d3c:	9f99                	subw	a5,a5,a4
 d3e:	0007871b          	sext.w	a4,a5
 d42:	fe843783          	ld	a5,-24(s0)
 d46:	c798                	sw	a4,8(a5)
        p += p->s.size;
 d48:	fe843783          	ld	a5,-24(s0)
 d4c:	479c                	lw	a5,8(a5)
 d4e:	1782                	slli	a5,a5,0x20
 d50:	9381                	srli	a5,a5,0x20
 d52:	0792                	slli	a5,a5,0x4
 d54:	fe843703          	ld	a4,-24(s0)
 d58:	97ba                	add	a5,a5,a4
 d5a:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 d5e:	fe843783          	ld	a5,-24(s0)
 d62:	fdc42703          	lw	a4,-36(s0)
 d66:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 d68:	00000797          	auipc	a5,0x0
 d6c:	2c878793          	addi	a5,a5,712 # 1030 <freep>
 d70:	fe043703          	ld	a4,-32(s0)
 d74:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 d76:	fe843783          	ld	a5,-24(s0)
 d7a:	07c1                	addi	a5,a5,16
 d7c:	a091                	j	dc0 <malloc+0x132>
    }
    if(p == freep)
 d7e:	00000797          	auipc	a5,0x0
 d82:	2b278793          	addi	a5,a5,690 # 1030 <freep>
 d86:	639c                	ld	a5,0(a5)
 d88:	fe843703          	ld	a4,-24(s0)
 d8c:	02f71063          	bne	a4,a5,dac <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 d90:	fdc42783          	lw	a5,-36(s0)
 d94:	853e                	mv	a0,a5
 d96:	00000097          	auipc	ra,0x0
 d9a:	e7a080e7          	jalr	-390(ra) # c10 <morecore>
 d9e:	fea43423          	sd	a0,-24(s0)
 da2:	fe843783          	ld	a5,-24(s0)
 da6:	e399                	bnez	a5,dac <malloc+0x11e>
        return 0;
 da8:	4781                	li	a5,0
 daa:	a819                	j	dc0 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 dac:	fe843783          	ld	a5,-24(s0)
 db0:	fef43023          	sd	a5,-32(s0)
 db4:	fe843783          	ld	a5,-24(s0)
 db8:	639c                	ld	a5,0(a5)
 dba:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 dbe:	b799                	j	d04 <malloc+0x76>
  }
}
 dc0:	853e                	mv	a0,a5
 dc2:	70e2                	ld	ra,56(sp)
 dc4:	7442                	ld	s0,48(sp)
 dc6:	6121                	addi	sp,sp,64
 dc8:	8082                	ret
