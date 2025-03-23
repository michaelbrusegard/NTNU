
user/_schedls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    schedls();
   8:	00000097          	auipc	ra,0x0
   c:	374080e7          	jalr	884(ra) # 37c <schedls>
    exit(0);
  10:	4501                	li	a0,0
  12:	00000097          	auipc	ra,0x0
  16:	2c2080e7          	jalr	706(ra) # 2d4 <exit>

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
  30:	2a8080e7          	jalr	680(ra) # 2d4 <exit>

0000000000000034 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  34:	1141                	addi	sp,sp,-16
  36:	e406                	sd	ra,8(sp)
  38:	e022                	sd	s0,0(sp)
  3a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  3c:	87aa                	mv	a5,a0
  3e:	0585                	addi	a1,a1,1
  40:	0785                	addi	a5,a5,1
  42:	fff5c703          	lbu	a4,-1(a1)
  46:	fee78fa3          	sb	a4,-1(a5)
  4a:	fb75                	bnez	a4,3e <strcpy+0xa>
    ;
  return os;
}
  4c:	60a2                	ld	ra,8(sp)
  4e:	6402                	ld	s0,0(sp)
  50:	0141                	addi	sp,sp,16
  52:	8082                	ret

0000000000000054 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  54:	1141                	addi	sp,sp,-16
  56:	e406                	sd	ra,8(sp)
  58:	e022                	sd	s0,0(sp)
  5a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  5c:	00054783          	lbu	a5,0(a0)
  60:	cb91                	beqz	a5,74 <strcmp+0x20>
  62:	0005c703          	lbu	a4,0(a1)
  66:	00f71763          	bne	a4,a5,74 <strcmp+0x20>
    p++, q++;
  6a:	0505                	addi	a0,a0,1
  6c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  6e:	00054783          	lbu	a5,0(a0)
  72:	fbe5                	bnez	a5,62 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  74:	0005c503          	lbu	a0,0(a1)
}
  78:	40a7853b          	subw	a0,a5,a0
  7c:	60a2                	ld	ra,8(sp)
  7e:	6402                	ld	s0,0(sp)
  80:	0141                	addi	sp,sp,16
  82:	8082                	ret

0000000000000084 <strlen>:

uint
strlen(const char *s)
{
  84:	1141                	addi	sp,sp,-16
  86:	e406                	sd	ra,8(sp)
  88:	e022                	sd	s0,0(sp)
  8a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  8c:	00054783          	lbu	a5,0(a0)
  90:	cf99                	beqz	a5,ae <strlen+0x2a>
  92:	0505                	addi	a0,a0,1
  94:	87aa                	mv	a5,a0
  96:	86be                	mv	a3,a5
  98:	0785                	addi	a5,a5,1
  9a:	fff7c703          	lbu	a4,-1(a5)
  9e:	ff65                	bnez	a4,96 <strlen+0x12>
  a0:	40a6853b          	subw	a0,a3,a0
  a4:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  a6:	60a2                	ld	ra,8(sp)
  a8:	6402                	ld	s0,0(sp)
  aa:	0141                	addi	sp,sp,16
  ac:	8082                	ret
  for(n = 0; s[n]; n++)
  ae:	4501                	li	a0,0
  b0:	bfdd                	j	a6 <strlen+0x22>

00000000000000b2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b2:	1141                	addi	sp,sp,-16
  b4:	e406                	sd	ra,8(sp)
  b6:	e022                	sd	s0,0(sp)
  b8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  ba:	ca19                	beqz	a2,d0 <memset+0x1e>
  bc:	87aa                	mv	a5,a0
  be:	1602                	slli	a2,a2,0x20
  c0:	9201                	srli	a2,a2,0x20
  c2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  c6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  ca:	0785                	addi	a5,a5,1
  cc:	fee79de3          	bne	a5,a4,c6 <memset+0x14>
  }
  return dst;
}
  d0:	60a2                	ld	ra,8(sp)
  d2:	6402                	ld	s0,0(sp)
  d4:	0141                	addi	sp,sp,16
  d6:	8082                	ret

00000000000000d8 <strchr>:

char*
strchr(const char *s, char c)
{
  d8:	1141                	addi	sp,sp,-16
  da:	e406                	sd	ra,8(sp)
  dc:	e022                	sd	s0,0(sp)
  de:	0800                	addi	s0,sp,16
  for(; *s; s++)
  e0:	00054783          	lbu	a5,0(a0)
  e4:	cf81                	beqz	a5,fc <strchr+0x24>
    if(*s == c)
  e6:	00f58763          	beq	a1,a5,f4 <strchr+0x1c>
  for(; *s; s++)
  ea:	0505                	addi	a0,a0,1
  ec:	00054783          	lbu	a5,0(a0)
  f0:	fbfd                	bnez	a5,e6 <strchr+0xe>
      return (char*)s;
  return 0;
  f2:	4501                	li	a0,0
}
  f4:	60a2                	ld	ra,8(sp)
  f6:	6402                	ld	s0,0(sp)
  f8:	0141                	addi	sp,sp,16
  fa:	8082                	ret
  return 0;
  fc:	4501                	li	a0,0
  fe:	bfdd                	j	f4 <strchr+0x1c>

0000000000000100 <gets>:

char*
gets(char *buf, int max)
{
 100:	7159                	addi	sp,sp,-112
 102:	f486                	sd	ra,104(sp)
 104:	f0a2                	sd	s0,96(sp)
 106:	eca6                	sd	s1,88(sp)
 108:	e8ca                	sd	s2,80(sp)
 10a:	e4ce                	sd	s3,72(sp)
 10c:	e0d2                	sd	s4,64(sp)
 10e:	fc56                	sd	s5,56(sp)
 110:	f85a                	sd	s6,48(sp)
 112:	f45e                	sd	s7,40(sp)
 114:	f062                	sd	s8,32(sp)
 116:	ec66                	sd	s9,24(sp)
 118:	e86a                	sd	s10,16(sp)
 11a:	1880                	addi	s0,sp,112
 11c:	8caa                	mv	s9,a0
 11e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 120:	892a                	mv	s2,a0
 122:	4481                	li	s1,0
    cc = read(0, &c, 1);
 124:	f9f40b13          	addi	s6,s0,-97
 128:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 12a:	4ba9                	li	s7,10
 12c:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 12e:	8d26                	mv	s10,s1
 130:	0014899b          	addiw	s3,s1,1
 134:	84ce                	mv	s1,s3
 136:	0349d763          	bge	s3,s4,164 <gets+0x64>
    cc = read(0, &c, 1);
 13a:	8656                	mv	a2,s5
 13c:	85da                	mv	a1,s6
 13e:	4501                	li	a0,0
 140:	00000097          	auipc	ra,0x0
 144:	1ac080e7          	jalr	428(ra) # 2ec <read>
    if(cc < 1)
 148:	00a05e63          	blez	a0,164 <gets+0x64>
    buf[i++] = c;
 14c:	f9f44783          	lbu	a5,-97(s0)
 150:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 154:	01778763          	beq	a5,s7,162 <gets+0x62>
 158:	0905                	addi	s2,s2,1
 15a:	fd879ae3          	bne	a5,s8,12e <gets+0x2e>
    buf[i++] = c;
 15e:	8d4e                	mv	s10,s3
 160:	a011                	j	164 <gets+0x64>
 162:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 164:	9d66                	add	s10,s10,s9
 166:	000d0023          	sb	zero,0(s10)
  return buf;
}
 16a:	8566                	mv	a0,s9
 16c:	70a6                	ld	ra,104(sp)
 16e:	7406                	ld	s0,96(sp)
 170:	64e6                	ld	s1,88(sp)
 172:	6946                	ld	s2,80(sp)
 174:	69a6                	ld	s3,72(sp)
 176:	6a06                	ld	s4,64(sp)
 178:	7ae2                	ld	s5,56(sp)
 17a:	7b42                	ld	s6,48(sp)
 17c:	7ba2                	ld	s7,40(sp)
 17e:	7c02                	ld	s8,32(sp)
 180:	6ce2                	ld	s9,24(sp)
 182:	6d42                	ld	s10,16(sp)
 184:	6165                	addi	sp,sp,112
 186:	8082                	ret

0000000000000188 <stat>:

int
stat(const char *n, struct stat *st)
{
 188:	1101                	addi	sp,sp,-32
 18a:	ec06                	sd	ra,24(sp)
 18c:	e822                	sd	s0,16(sp)
 18e:	e04a                	sd	s2,0(sp)
 190:	1000                	addi	s0,sp,32
 192:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 194:	4581                	li	a1,0
 196:	00000097          	auipc	ra,0x0
 19a:	17e080e7          	jalr	382(ra) # 314 <open>
  if(fd < 0)
 19e:	02054663          	bltz	a0,1ca <stat+0x42>
 1a2:	e426                	sd	s1,8(sp)
 1a4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1a6:	85ca                	mv	a1,s2
 1a8:	00000097          	auipc	ra,0x0
 1ac:	184080e7          	jalr	388(ra) # 32c <fstat>
 1b0:	892a                	mv	s2,a0
  close(fd);
 1b2:	8526                	mv	a0,s1
 1b4:	00000097          	auipc	ra,0x0
 1b8:	148080e7          	jalr	328(ra) # 2fc <close>
  return r;
 1bc:	64a2                	ld	s1,8(sp)
}
 1be:	854a                	mv	a0,s2
 1c0:	60e2                	ld	ra,24(sp)
 1c2:	6442                	ld	s0,16(sp)
 1c4:	6902                	ld	s2,0(sp)
 1c6:	6105                	addi	sp,sp,32
 1c8:	8082                	ret
    return -1;
 1ca:	597d                	li	s2,-1
 1cc:	bfcd                	j	1be <stat+0x36>

00000000000001ce <atoi>:

int
atoi(const char *s)
{
 1ce:	1141                	addi	sp,sp,-16
 1d0:	e406                	sd	ra,8(sp)
 1d2:	e022                	sd	s0,0(sp)
 1d4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1d6:	00054683          	lbu	a3,0(a0)
 1da:	fd06879b          	addiw	a5,a3,-48
 1de:	0ff7f793          	zext.b	a5,a5
 1e2:	4625                	li	a2,9
 1e4:	02f66963          	bltu	a2,a5,216 <atoi+0x48>
 1e8:	872a                	mv	a4,a0
  n = 0;
 1ea:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1ec:	0705                	addi	a4,a4,1
 1ee:	0025179b          	slliw	a5,a0,0x2
 1f2:	9fa9                	addw	a5,a5,a0
 1f4:	0017979b          	slliw	a5,a5,0x1
 1f8:	9fb5                	addw	a5,a5,a3
 1fa:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1fe:	00074683          	lbu	a3,0(a4)
 202:	fd06879b          	addiw	a5,a3,-48
 206:	0ff7f793          	zext.b	a5,a5
 20a:	fef671e3          	bgeu	a2,a5,1ec <atoi+0x1e>
  return n;
}
 20e:	60a2                	ld	ra,8(sp)
 210:	6402                	ld	s0,0(sp)
 212:	0141                	addi	sp,sp,16
 214:	8082                	ret
  n = 0;
 216:	4501                	li	a0,0
 218:	bfdd                	j	20e <atoi+0x40>

000000000000021a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 21a:	1141                	addi	sp,sp,-16
 21c:	e406                	sd	ra,8(sp)
 21e:	e022                	sd	s0,0(sp)
 220:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 222:	02b57563          	bgeu	a0,a1,24c <memmove+0x32>
    while(n-- > 0)
 226:	00c05f63          	blez	a2,244 <memmove+0x2a>
 22a:	1602                	slli	a2,a2,0x20
 22c:	9201                	srli	a2,a2,0x20
 22e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 232:	872a                	mv	a4,a0
      *dst++ = *src++;
 234:	0585                	addi	a1,a1,1
 236:	0705                	addi	a4,a4,1
 238:	fff5c683          	lbu	a3,-1(a1)
 23c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 240:	fee79ae3          	bne	a5,a4,234 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 244:	60a2                	ld	ra,8(sp)
 246:	6402                	ld	s0,0(sp)
 248:	0141                	addi	sp,sp,16
 24a:	8082                	ret
    dst += n;
 24c:	00c50733          	add	a4,a0,a2
    src += n;
 250:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 252:	fec059e3          	blez	a2,244 <memmove+0x2a>
 256:	fff6079b          	addiw	a5,a2,-1
 25a:	1782                	slli	a5,a5,0x20
 25c:	9381                	srli	a5,a5,0x20
 25e:	fff7c793          	not	a5,a5
 262:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 264:	15fd                	addi	a1,a1,-1
 266:	177d                	addi	a4,a4,-1
 268:	0005c683          	lbu	a3,0(a1)
 26c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 270:	fef71ae3          	bne	a4,a5,264 <memmove+0x4a>
 274:	bfc1                	j	244 <memmove+0x2a>

0000000000000276 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 276:	1141                	addi	sp,sp,-16
 278:	e406                	sd	ra,8(sp)
 27a:	e022                	sd	s0,0(sp)
 27c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 27e:	ca0d                	beqz	a2,2b0 <memcmp+0x3a>
 280:	fff6069b          	addiw	a3,a2,-1
 284:	1682                	slli	a3,a3,0x20
 286:	9281                	srli	a3,a3,0x20
 288:	0685                	addi	a3,a3,1
 28a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 28c:	00054783          	lbu	a5,0(a0)
 290:	0005c703          	lbu	a4,0(a1)
 294:	00e79863          	bne	a5,a4,2a4 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 298:	0505                	addi	a0,a0,1
    p2++;
 29a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 29c:	fed518e3          	bne	a0,a3,28c <memcmp+0x16>
  }
  return 0;
 2a0:	4501                	li	a0,0
 2a2:	a019                	j	2a8 <memcmp+0x32>
      return *p1 - *p2;
 2a4:	40e7853b          	subw	a0,a5,a4
}
 2a8:	60a2                	ld	ra,8(sp)
 2aa:	6402                	ld	s0,0(sp)
 2ac:	0141                	addi	sp,sp,16
 2ae:	8082                	ret
  return 0;
 2b0:	4501                	li	a0,0
 2b2:	bfdd                	j	2a8 <memcmp+0x32>

00000000000002b4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e406                	sd	ra,8(sp)
 2b8:	e022                	sd	s0,0(sp)
 2ba:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2bc:	00000097          	auipc	ra,0x0
 2c0:	f5e080e7          	jalr	-162(ra) # 21a <memmove>
}
 2c4:	60a2                	ld	ra,8(sp)
 2c6:	6402                	ld	s0,0(sp)
 2c8:	0141                	addi	sp,sp,16
 2ca:	8082                	ret

00000000000002cc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2cc:	4885                	li	a7,1
 ecall
 2ce:	00000073          	ecall
 ret
 2d2:	8082                	ret

00000000000002d4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2d4:	4889                	li	a7,2
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <wait>:
.global wait
wait:
 li a7, SYS_wait
 2dc:	488d                	li	a7,3
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2e4:	4891                	li	a7,4
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <read>:
.global read
read:
 li a7, SYS_read
 2ec:	4895                	li	a7,5
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <write>:
.global write
write:
 li a7, SYS_write
 2f4:	48c1                	li	a7,16
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <close>:
.global close
close:
 li a7, SYS_close
 2fc:	48d5                	li	a7,21
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <kill>:
.global kill
kill:
 li a7, SYS_kill
 304:	4899                	li	a7,6
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <exec>:
.global exec
exec:
 li a7, SYS_exec
 30c:	489d                	li	a7,7
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <open>:
.global open
open:
 li a7, SYS_open
 314:	48bd                	li	a7,15
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 31c:	48c5                	li	a7,17
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 324:	48c9                	li	a7,18
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 32c:	48a1                	li	a7,8
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <link>:
.global link
link:
 li a7, SYS_link
 334:	48cd                	li	a7,19
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 33c:	48d1                	li	a7,20
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 344:	48a5                	li	a7,9
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <dup>:
.global dup
dup:
 li a7, SYS_dup
 34c:	48a9                	li	a7,10
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 354:	48ad                	li	a7,11
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 35c:	48b1                	li	a7,12
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 364:	48b5                	li	a7,13
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 36c:	48b9                	li	a7,14
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <ps>:
.global ps
ps:
 li a7, SYS_ps
 374:	48d9                	li	a7,22
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
 37c:	48dd                	li	a7,23
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
 384:	48e1                	li	a7,24
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <va2pa>:
.global va2pa
va2pa:
 li a7, SYS_va2pa
 38c:	48e9                	li	a7,26
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <pfreepages>:
.global pfreepages
pfreepages:
 li a7, SYS_pfreepages
 394:	48e5                	li	a7,25
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 39c:	1101                	addi	sp,sp,-32
 39e:	ec06                	sd	ra,24(sp)
 3a0:	e822                	sd	s0,16(sp)
 3a2:	1000                	addi	s0,sp,32
 3a4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3a8:	4605                	li	a2,1
 3aa:	fef40593          	addi	a1,s0,-17
 3ae:	00000097          	auipc	ra,0x0
 3b2:	f46080e7          	jalr	-186(ra) # 2f4 <write>
}
 3b6:	60e2                	ld	ra,24(sp)
 3b8:	6442                	ld	s0,16(sp)
 3ba:	6105                	addi	sp,sp,32
 3bc:	8082                	ret

00000000000003be <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3be:	7139                	addi	sp,sp,-64
 3c0:	fc06                	sd	ra,56(sp)
 3c2:	f822                	sd	s0,48(sp)
 3c4:	f426                	sd	s1,40(sp)
 3c6:	f04a                	sd	s2,32(sp)
 3c8:	ec4e                	sd	s3,24(sp)
 3ca:	0080                	addi	s0,sp,64
 3cc:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ce:	c299                	beqz	a3,3d4 <printint+0x16>
 3d0:	0805c063          	bltz	a1,450 <printint+0x92>
  neg = 0;
 3d4:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 3d6:	fc040313          	addi	t1,s0,-64
  neg = 0;
 3da:	869a                	mv	a3,t1
  i = 0;
 3dc:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 3de:	00000817          	auipc	a6,0x0
 3e2:	49280813          	addi	a6,a6,1170 # 870 <digits>
 3e6:	88be                	mv	a7,a5
 3e8:	0017851b          	addiw	a0,a5,1
 3ec:	87aa                	mv	a5,a0
 3ee:	02c5f73b          	remuw	a4,a1,a2
 3f2:	1702                	slli	a4,a4,0x20
 3f4:	9301                	srli	a4,a4,0x20
 3f6:	9742                	add	a4,a4,a6
 3f8:	00074703          	lbu	a4,0(a4)
 3fc:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 400:	872e                	mv	a4,a1
 402:	02c5d5bb          	divuw	a1,a1,a2
 406:	0685                	addi	a3,a3,1
 408:	fcc77fe3          	bgeu	a4,a2,3e6 <printint+0x28>
  if(neg)
 40c:	000e0c63          	beqz	t3,424 <printint+0x66>
    buf[i++] = '-';
 410:	fd050793          	addi	a5,a0,-48
 414:	00878533          	add	a0,a5,s0
 418:	02d00793          	li	a5,45
 41c:	fef50823          	sb	a5,-16(a0)
 420:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 424:	fff7899b          	addiw	s3,a5,-1
 428:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 42c:	fff4c583          	lbu	a1,-1(s1)
 430:	854a                	mv	a0,s2
 432:	00000097          	auipc	ra,0x0
 436:	f6a080e7          	jalr	-150(ra) # 39c <putc>
  while(--i >= 0)
 43a:	39fd                	addiw	s3,s3,-1
 43c:	14fd                	addi	s1,s1,-1
 43e:	fe09d7e3          	bgez	s3,42c <printint+0x6e>
}
 442:	70e2                	ld	ra,56(sp)
 444:	7442                	ld	s0,48(sp)
 446:	74a2                	ld	s1,40(sp)
 448:	7902                	ld	s2,32(sp)
 44a:	69e2                	ld	s3,24(sp)
 44c:	6121                	addi	sp,sp,64
 44e:	8082                	ret
    x = -xx;
 450:	40b005bb          	negw	a1,a1
    neg = 1;
 454:	4e05                	li	t3,1
    x = -xx;
 456:	b741                	j	3d6 <printint+0x18>

0000000000000458 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 458:	715d                	addi	sp,sp,-80
 45a:	e486                	sd	ra,72(sp)
 45c:	e0a2                	sd	s0,64(sp)
 45e:	f84a                	sd	s2,48(sp)
 460:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 462:	0005c903          	lbu	s2,0(a1)
 466:	1a090a63          	beqz	s2,61a <vprintf+0x1c2>
 46a:	fc26                	sd	s1,56(sp)
 46c:	f44e                	sd	s3,40(sp)
 46e:	f052                	sd	s4,32(sp)
 470:	ec56                	sd	s5,24(sp)
 472:	e85a                	sd	s6,16(sp)
 474:	e45e                	sd	s7,8(sp)
 476:	8aaa                	mv	s5,a0
 478:	8bb2                	mv	s7,a2
 47a:	00158493          	addi	s1,a1,1
  state = 0;
 47e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 480:	02500a13          	li	s4,37
 484:	4b55                	li	s6,21
 486:	a839                	j	4a4 <vprintf+0x4c>
        putc(fd, c);
 488:	85ca                	mv	a1,s2
 48a:	8556                	mv	a0,s5
 48c:	00000097          	auipc	ra,0x0
 490:	f10080e7          	jalr	-240(ra) # 39c <putc>
 494:	a019                	j	49a <vprintf+0x42>
    } else if(state == '%'){
 496:	01498d63          	beq	s3,s4,4b0 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 49a:	0485                	addi	s1,s1,1
 49c:	fff4c903          	lbu	s2,-1(s1)
 4a0:	16090763          	beqz	s2,60e <vprintf+0x1b6>
    if(state == 0){
 4a4:	fe0999e3          	bnez	s3,496 <vprintf+0x3e>
      if(c == '%'){
 4a8:	ff4910e3          	bne	s2,s4,488 <vprintf+0x30>
        state = '%';
 4ac:	89d2                	mv	s3,s4
 4ae:	b7f5                	j	49a <vprintf+0x42>
      if(c == 'd'){
 4b0:	13490463          	beq	s2,s4,5d8 <vprintf+0x180>
 4b4:	f9d9079b          	addiw	a5,s2,-99
 4b8:	0ff7f793          	zext.b	a5,a5
 4bc:	12fb6763          	bltu	s6,a5,5ea <vprintf+0x192>
 4c0:	f9d9079b          	addiw	a5,s2,-99
 4c4:	0ff7f713          	zext.b	a4,a5
 4c8:	12eb6163          	bltu	s6,a4,5ea <vprintf+0x192>
 4cc:	00271793          	slli	a5,a4,0x2
 4d0:	00000717          	auipc	a4,0x0
 4d4:	34870713          	addi	a4,a4,840 # 818 <malloc+0x10a>
 4d8:	97ba                	add	a5,a5,a4
 4da:	439c                	lw	a5,0(a5)
 4dc:	97ba                	add	a5,a5,a4
 4de:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4e0:	008b8913          	addi	s2,s7,8
 4e4:	4685                	li	a3,1
 4e6:	4629                	li	a2,10
 4e8:	000ba583          	lw	a1,0(s7)
 4ec:	8556                	mv	a0,s5
 4ee:	00000097          	auipc	ra,0x0
 4f2:	ed0080e7          	jalr	-304(ra) # 3be <printint>
 4f6:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4f8:	4981                	li	s3,0
 4fa:	b745                	j	49a <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4fc:	008b8913          	addi	s2,s7,8
 500:	4681                	li	a3,0
 502:	4629                	li	a2,10
 504:	000ba583          	lw	a1,0(s7)
 508:	8556                	mv	a0,s5
 50a:	00000097          	auipc	ra,0x0
 50e:	eb4080e7          	jalr	-332(ra) # 3be <printint>
 512:	8bca                	mv	s7,s2
      state = 0;
 514:	4981                	li	s3,0
 516:	b751                	j	49a <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 518:	008b8913          	addi	s2,s7,8
 51c:	4681                	li	a3,0
 51e:	4641                	li	a2,16
 520:	000ba583          	lw	a1,0(s7)
 524:	8556                	mv	a0,s5
 526:	00000097          	auipc	ra,0x0
 52a:	e98080e7          	jalr	-360(ra) # 3be <printint>
 52e:	8bca                	mv	s7,s2
      state = 0;
 530:	4981                	li	s3,0
 532:	b7a5                	j	49a <vprintf+0x42>
 534:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 536:	008b8c13          	addi	s8,s7,8
 53a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 53e:	03000593          	li	a1,48
 542:	8556                	mv	a0,s5
 544:	00000097          	auipc	ra,0x0
 548:	e58080e7          	jalr	-424(ra) # 39c <putc>
  putc(fd, 'x');
 54c:	07800593          	li	a1,120
 550:	8556                	mv	a0,s5
 552:	00000097          	auipc	ra,0x0
 556:	e4a080e7          	jalr	-438(ra) # 39c <putc>
 55a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 55c:	00000b97          	auipc	s7,0x0
 560:	314b8b93          	addi	s7,s7,788 # 870 <digits>
 564:	03c9d793          	srli	a5,s3,0x3c
 568:	97de                	add	a5,a5,s7
 56a:	0007c583          	lbu	a1,0(a5)
 56e:	8556                	mv	a0,s5
 570:	00000097          	auipc	ra,0x0
 574:	e2c080e7          	jalr	-468(ra) # 39c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 578:	0992                	slli	s3,s3,0x4
 57a:	397d                	addiw	s2,s2,-1
 57c:	fe0914e3          	bnez	s2,564 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 580:	8be2                	mv	s7,s8
      state = 0;
 582:	4981                	li	s3,0
 584:	6c02                	ld	s8,0(sp)
 586:	bf11                	j	49a <vprintf+0x42>
        s = va_arg(ap, char*);
 588:	008b8993          	addi	s3,s7,8
 58c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 590:	02090163          	beqz	s2,5b2 <vprintf+0x15a>
        while(*s != 0){
 594:	00094583          	lbu	a1,0(s2)
 598:	c9a5                	beqz	a1,608 <vprintf+0x1b0>
          putc(fd, *s);
 59a:	8556                	mv	a0,s5
 59c:	00000097          	auipc	ra,0x0
 5a0:	e00080e7          	jalr	-512(ra) # 39c <putc>
          s++;
 5a4:	0905                	addi	s2,s2,1
        while(*s != 0){
 5a6:	00094583          	lbu	a1,0(s2)
 5aa:	f9e5                	bnez	a1,59a <vprintf+0x142>
        s = va_arg(ap, char*);
 5ac:	8bce                	mv	s7,s3
      state = 0;
 5ae:	4981                	li	s3,0
 5b0:	b5ed                	j	49a <vprintf+0x42>
          s = "(null)";
 5b2:	00000917          	auipc	s2,0x0
 5b6:	25e90913          	addi	s2,s2,606 # 810 <malloc+0x102>
        while(*s != 0){
 5ba:	02800593          	li	a1,40
 5be:	bff1                	j	59a <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 5c0:	008b8913          	addi	s2,s7,8
 5c4:	000bc583          	lbu	a1,0(s7)
 5c8:	8556                	mv	a0,s5
 5ca:	00000097          	auipc	ra,0x0
 5ce:	dd2080e7          	jalr	-558(ra) # 39c <putc>
 5d2:	8bca                	mv	s7,s2
      state = 0;
 5d4:	4981                	li	s3,0
 5d6:	b5d1                	j	49a <vprintf+0x42>
        putc(fd, c);
 5d8:	02500593          	li	a1,37
 5dc:	8556                	mv	a0,s5
 5de:	00000097          	auipc	ra,0x0
 5e2:	dbe080e7          	jalr	-578(ra) # 39c <putc>
      state = 0;
 5e6:	4981                	li	s3,0
 5e8:	bd4d                	j	49a <vprintf+0x42>
        putc(fd, '%');
 5ea:	02500593          	li	a1,37
 5ee:	8556                	mv	a0,s5
 5f0:	00000097          	auipc	ra,0x0
 5f4:	dac080e7          	jalr	-596(ra) # 39c <putc>
        putc(fd, c);
 5f8:	85ca                	mv	a1,s2
 5fa:	8556                	mv	a0,s5
 5fc:	00000097          	auipc	ra,0x0
 600:	da0080e7          	jalr	-608(ra) # 39c <putc>
      state = 0;
 604:	4981                	li	s3,0
 606:	bd51                	j	49a <vprintf+0x42>
        s = va_arg(ap, char*);
 608:	8bce                	mv	s7,s3
      state = 0;
 60a:	4981                	li	s3,0
 60c:	b579                	j	49a <vprintf+0x42>
 60e:	74e2                	ld	s1,56(sp)
 610:	79a2                	ld	s3,40(sp)
 612:	7a02                	ld	s4,32(sp)
 614:	6ae2                	ld	s5,24(sp)
 616:	6b42                	ld	s6,16(sp)
 618:	6ba2                	ld	s7,8(sp)
    }
  }
}
 61a:	60a6                	ld	ra,72(sp)
 61c:	6406                	ld	s0,64(sp)
 61e:	7942                	ld	s2,48(sp)
 620:	6161                	addi	sp,sp,80
 622:	8082                	ret

0000000000000624 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 624:	715d                	addi	sp,sp,-80
 626:	ec06                	sd	ra,24(sp)
 628:	e822                	sd	s0,16(sp)
 62a:	1000                	addi	s0,sp,32
 62c:	e010                	sd	a2,0(s0)
 62e:	e414                	sd	a3,8(s0)
 630:	e818                	sd	a4,16(s0)
 632:	ec1c                	sd	a5,24(s0)
 634:	03043023          	sd	a6,32(s0)
 638:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 63c:	8622                	mv	a2,s0
 63e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 642:	00000097          	auipc	ra,0x0
 646:	e16080e7          	jalr	-490(ra) # 458 <vprintf>
}
 64a:	60e2                	ld	ra,24(sp)
 64c:	6442                	ld	s0,16(sp)
 64e:	6161                	addi	sp,sp,80
 650:	8082                	ret

0000000000000652 <printf>:

void
printf(const char *fmt, ...)
{
 652:	711d                	addi	sp,sp,-96
 654:	ec06                	sd	ra,24(sp)
 656:	e822                	sd	s0,16(sp)
 658:	1000                	addi	s0,sp,32
 65a:	e40c                	sd	a1,8(s0)
 65c:	e810                	sd	a2,16(s0)
 65e:	ec14                	sd	a3,24(s0)
 660:	f018                	sd	a4,32(s0)
 662:	f41c                	sd	a5,40(s0)
 664:	03043823          	sd	a6,48(s0)
 668:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 66c:	00840613          	addi	a2,s0,8
 670:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 674:	85aa                	mv	a1,a0
 676:	4505                	li	a0,1
 678:	00000097          	auipc	ra,0x0
 67c:	de0080e7          	jalr	-544(ra) # 458 <vprintf>
}
 680:	60e2                	ld	ra,24(sp)
 682:	6442                	ld	s0,16(sp)
 684:	6125                	addi	sp,sp,96
 686:	8082                	ret

0000000000000688 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 688:	1141                	addi	sp,sp,-16
 68a:	e406                	sd	ra,8(sp)
 68c:	e022                	sd	s0,0(sp)
 68e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 690:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 694:	00001797          	auipc	a5,0x1
 698:	96c7b783          	ld	a5,-1684(a5) # 1000 <freep>
 69c:	a02d                	j	6c6 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 69e:	4618                	lw	a4,8(a2)
 6a0:	9f2d                	addw	a4,a4,a1
 6a2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6a6:	6398                	ld	a4,0(a5)
 6a8:	6310                	ld	a2,0(a4)
 6aa:	a83d                	j	6e8 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6ac:	ff852703          	lw	a4,-8(a0)
 6b0:	9f31                	addw	a4,a4,a2
 6b2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6b4:	ff053683          	ld	a3,-16(a0)
 6b8:	a091                	j	6fc <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ba:	6398                	ld	a4,0(a5)
 6bc:	00e7e463          	bltu	a5,a4,6c4 <free+0x3c>
 6c0:	00e6ea63          	bltu	a3,a4,6d4 <free+0x4c>
{
 6c4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c6:	fed7fae3          	bgeu	a5,a3,6ba <free+0x32>
 6ca:	6398                	ld	a4,0(a5)
 6cc:	00e6e463          	bltu	a3,a4,6d4 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d0:	fee7eae3          	bltu	a5,a4,6c4 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 6d4:	ff852583          	lw	a1,-8(a0)
 6d8:	6390                	ld	a2,0(a5)
 6da:	02059813          	slli	a6,a1,0x20
 6de:	01c85713          	srli	a4,a6,0x1c
 6e2:	9736                	add	a4,a4,a3
 6e4:	fae60de3          	beq	a2,a4,69e <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 6e8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6ec:	4790                	lw	a2,8(a5)
 6ee:	02061593          	slli	a1,a2,0x20
 6f2:	01c5d713          	srli	a4,a1,0x1c
 6f6:	973e                	add	a4,a4,a5
 6f8:	fae68ae3          	beq	a3,a4,6ac <free+0x24>
    p->s.ptr = bp->s.ptr;
 6fc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6fe:	00001717          	auipc	a4,0x1
 702:	90f73123          	sd	a5,-1790(a4) # 1000 <freep>
}
 706:	60a2                	ld	ra,8(sp)
 708:	6402                	ld	s0,0(sp)
 70a:	0141                	addi	sp,sp,16
 70c:	8082                	ret

000000000000070e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 70e:	7139                	addi	sp,sp,-64
 710:	fc06                	sd	ra,56(sp)
 712:	f822                	sd	s0,48(sp)
 714:	f04a                	sd	s2,32(sp)
 716:	ec4e                	sd	s3,24(sp)
 718:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 71a:	02051993          	slli	s3,a0,0x20
 71e:	0209d993          	srli	s3,s3,0x20
 722:	09bd                	addi	s3,s3,15
 724:	0049d993          	srli	s3,s3,0x4
 728:	2985                	addiw	s3,s3,1
 72a:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 72c:	00001517          	auipc	a0,0x1
 730:	8d453503          	ld	a0,-1836(a0) # 1000 <freep>
 734:	c905                	beqz	a0,764 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 736:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 738:	4798                	lw	a4,8(a5)
 73a:	09377a63          	bgeu	a4,s3,7ce <malloc+0xc0>
 73e:	f426                	sd	s1,40(sp)
 740:	e852                	sd	s4,16(sp)
 742:	e456                	sd	s5,8(sp)
 744:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 746:	8a4e                	mv	s4,s3
 748:	6705                	lui	a4,0x1
 74a:	00e9f363          	bgeu	s3,a4,750 <malloc+0x42>
 74e:	6a05                	lui	s4,0x1
 750:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 754:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 758:	00001497          	auipc	s1,0x1
 75c:	8a848493          	addi	s1,s1,-1880 # 1000 <freep>
  if(p == (char*)-1)
 760:	5afd                	li	s5,-1
 762:	a089                	j	7a4 <malloc+0x96>
 764:	f426                	sd	s1,40(sp)
 766:	e852                	sd	s4,16(sp)
 768:	e456                	sd	s5,8(sp)
 76a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 76c:	00001797          	auipc	a5,0x1
 770:	8a478793          	addi	a5,a5,-1884 # 1010 <base>
 774:	00001717          	auipc	a4,0x1
 778:	88f73623          	sd	a5,-1908(a4) # 1000 <freep>
 77c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 77e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 782:	b7d1                	j	746 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 784:	6398                	ld	a4,0(a5)
 786:	e118                	sd	a4,0(a0)
 788:	a8b9                	j	7e6 <malloc+0xd8>
  hp->s.size = nu;
 78a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 78e:	0541                	addi	a0,a0,16
 790:	00000097          	auipc	ra,0x0
 794:	ef8080e7          	jalr	-264(ra) # 688 <free>
  return freep;
 798:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 79a:	c135                	beqz	a0,7fe <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 79c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 79e:	4798                	lw	a4,8(a5)
 7a0:	03277363          	bgeu	a4,s2,7c6 <malloc+0xb8>
    if(p == freep)
 7a4:	6098                	ld	a4,0(s1)
 7a6:	853e                	mv	a0,a5
 7a8:	fef71ae3          	bne	a4,a5,79c <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 7ac:	8552                	mv	a0,s4
 7ae:	00000097          	auipc	ra,0x0
 7b2:	bae080e7          	jalr	-1106(ra) # 35c <sbrk>
  if(p == (char*)-1)
 7b6:	fd551ae3          	bne	a0,s5,78a <malloc+0x7c>
        return 0;
 7ba:	4501                	li	a0,0
 7bc:	74a2                	ld	s1,40(sp)
 7be:	6a42                	ld	s4,16(sp)
 7c0:	6aa2                	ld	s5,8(sp)
 7c2:	6b02                	ld	s6,0(sp)
 7c4:	a03d                	j	7f2 <malloc+0xe4>
 7c6:	74a2                	ld	s1,40(sp)
 7c8:	6a42                	ld	s4,16(sp)
 7ca:	6aa2                	ld	s5,8(sp)
 7cc:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 7ce:	fae90be3          	beq	s2,a4,784 <malloc+0x76>
        p->s.size -= nunits;
 7d2:	4137073b          	subw	a4,a4,s3
 7d6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7d8:	02071693          	slli	a3,a4,0x20
 7dc:	01c6d713          	srli	a4,a3,0x1c
 7e0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7e2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7e6:	00001717          	auipc	a4,0x1
 7ea:	80a73d23          	sd	a0,-2022(a4) # 1000 <freep>
      return (void*)(p + 1);
 7ee:	01078513          	addi	a0,a5,16
  }
}
 7f2:	70e2                	ld	ra,56(sp)
 7f4:	7442                	ld	s0,48(sp)
 7f6:	7902                	ld	s2,32(sp)
 7f8:	69e2                	ld	s3,24(sp)
 7fa:	6121                	addi	sp,sp,64
 7fc:	8082                	ret
 7fe:	74a2                	ld	s1,40(sp)
 800:	6a42                	ld	s4,16(sp)
 802:	6aa2                	ld	s5,8(sp)
 804:	6b02                	ld	s6,0(sp)
 806:	b7f5                	j	7f2 <malloc+0xe4>
