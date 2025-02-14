
user/_schedset:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    if (argc != 2)
   8:	4789                	li	a5,2
   a:	00f50f63          	beq	a0,a5,28 <main+0x28>
    {
        printf("Usage: schedset [SCHED ID]\n");
   e:	00001517          	auipc	a0,0x1
  12:	82250513          	addi	a0,a0,-2014 # 830 <malloc+0x100>
  16:	00000097          	auipc	ra,0x0
  1a:	65e080e7          	jalr	1630(ra) # 674 <printf>
        exit(1);
  1e:	4505                	li	a0,1
  20:	00000097          	auipc	ra,0x0
  24:	2de080e7          	jalr	734(ra) # 2fe <exit>
    }
    int schedid = (*argv[1]) - '0';
  28:	659c                	ld	a5,8(a1)
  2a:	0007c503          	lbu	a0,0(a5)
    schedset(schedid);
  2e:	fd05051b          	addiw	a0,a0,-48
  32:	00000097          	auipc	ra,0x0
  36:	37c080e7          	jalr	892(ra) # 3ae <schedset>
    exit(0);
  3a:	4501                	li	a0,0
  3c:	00000097          	auipc	ra,0x0
  40:	2c2080e7          	jalr	706(ra) # 2fe <exit>

0000000000000044 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  44:	1141                	addi	sp,sp,-16
  46:	e406                	sd	ra,8(sp)
  48:	e022                	sd	s0,0(sp)
  4a:	0800                	addi	s0,sp,16
  extern int main();
  main();
  4c:	00000097          	auipc	ra,0x0
  50:	fb4080e7          	jalr	-76(ra) # 0 <main>
  exit(0);
  54:	4501                	li	a0,0
  56:	00000097          	auipc	ra,0x0
  5a:	2a8080e7          	jalr	680(ra) # 2fe <exit>

000000000000005e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  5e:	1141                	addi	sp,sp,-16
  60:	e406                	sd	ra,8(sp)
  62:	e022                	sd	s0,0(sp)
  64:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  66:	87aa                	mv	a5,a0
  68:	0585                	addi	a1,a1,1
  6a:	0785                	addi	a5,a5,1
  6c:	fff5c703          	lbu	a4,-1(a1)
  70:	fee78fa3          	sb	a4,-1(a5)
  74:	fb75                	bnez	a4,68 <strcpy+0xa>
    ;
  return os;
}
  76:	60a2                	ld	ra,8(sp)
  78:	6402                	ld	s0,0(sp)
  7a:	0141                	addi	sp,sp,16
  7c:	8082                	ret

000000000000007e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7e:	1141                	addi	sp,sp,-16
  80:	e406                	sd	ra,8(sp)
  82:	e022                	sd	s0,0(sp)
  84:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  86:	00054783          	lbu	a5,0(a0)
  8a:	cb91                	beqz	a5,9e <strcmp+0x20>
  8c:	0005c703          	lbu	a4,0(a1)
  90:	00f71763          	bne	a4,a5,9e <strcmp+0x20>
    p++, q++;
  94:	0505                	addi	a0,a0,1
  96:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  98:	00054783          	lbu	a5,0(a0)
  9c:	fbe5                	bnez	a5,8c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  9e:	0005c503          	lbu	a0,0(a1)
}
  a2:	40a7853b          	subw	a0,a5,a0
  a6:	60a2                	ld	ra,8(sp)
  a8:	6402                	ld	s0,0(sp)
  aa:	0141                	addi	sp,sp,16
  ac:	8082                	ret

00000000000000ae <strlen>:

uint
strlen(const char *s)
{
  ae:	1141                	addi	sp,sp,-16
  b0:	e406                	sd	ra,8(sp)
  b2:	e022                	sd	s0,0(sp)
  b4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  b6:	00054783          	lbu	a5,0(a0)
  ba:	cf99                	beqz	a5,d8 <strlen+0x2a>
  bc:	0505                	addi	a0,a0,1
  be:	87aa                	mv	a5,a0
  c0:	86be                	mv	a3,a5
  c2:	0785                	addi	a5,a5,1
  c4:	fff7c703          	lbu	a4,-1(a5)
  c8:	ff65                	bnez	a4,c0 <strlen+0x12>
  ca:	40a6853b          	subw	a0,a3,a0
  ce:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  d0:	60a2                	ld	ra,8(sp)
  d2:	6402                	ld	s0,0(sp)
  d4:	0141                	addi	sp,sp,16
  d6:	8082                	ret
  for(n = 0; s[n]; n++)
  d8:	4501                	li	a0,0
  da:	bfdd                	j	d0 <strlen+0x22>

00000000000000dc <memset>:

void*
memset(void *dst, int c, uint n)
{
  dc:	1141                	addi	sp,sp,-16
  de:	e406                	sd	ra,8(sp)
  e0:	e022                	sd	s0,0(sp)
  e2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  e4:	ca19                	beqz	a2,fa <memset+0x1e>
  e6:	87aa                	mv	a5,a0
  e8:	1602                	slli	a2,a2,0x20
  ea:	9201                	srli	a2,a2,0x20
  ec:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  f0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  f4:	0785                	addi	a5,a5,1
  f6:	fee79de3          	bne	a5,a4,f0 <memset+0x14>
  }
  return dst;
}
  fa:	60a2                	ld	ra,8(sp)
  fc:	6402                	ld	s0,0(sp)
  fe:	0141                	addi	sp,sp,16
 100:	8082                	ret

0000000000000102 <strchr>:

char*
strchr(const char *s, char c)
{
 102:	1141                	addi	sp,sp,-16
 104:	e406                	sd	ra,8(sp)
 106:	e022                	sd	s0,0(sp)
 108:	0800                	addi	s0,sp,16
  for(; *s; s++)
 10a:	00054783          	lbu	a5,0(a0)
 10e:	cf81                	beqz	a5,126 <strchr+0x24>
    if(*s == c)
 110:	00f58763          	beq	a1,a5,11e <strchr+0x1c>
  for(; *s; s++)
 114:	0505                	addi	a0,a0,1
 116:	00054783          	lbu	a5,0(a0)
 11a:	fbfd                	bnez	a5,110 <strchr+0xe>
      return (char*)s;
  return 0;
 11c:	4501                	li	a0,0
}
 11e:	60a2                	ld	ra,8(sp)
 120:	6402                	ld	s0,0(sp)
 122:	0141                	addi	sp,sp,16
 124:	8082                	ret
  return 0;
 126:	4501                	li	a0,0
 128:	bfdd                	j	11e <strchr+0x1c>

000000000000012a <gets>:

char*
gets(char *buf, int max)
{
 12a:	7159                	addi	sp,sp,-112
 12c:	f486                	sd	ra,104(sp)
 12e:	f0a2                	sd	s0,96(sp)
 130:	eca6                	sd	s1,88(sp)
 132:	e8ca                	sd	s2,80(sp)
 134:	e4ce                	sd	s3,72(sp)
 136:	e0d2                	sd	s4,64(sp)
 138:	fc56                	sd	s5,56(sp)
 13a:	f85a                	sd	s6,48(sp)
 13c:	f45e                	sd	s7,40(sp)
 13e:	f062                	sd	s8,32(sp)
 140:	ec66                	sd	s9,24(sp)
 142:	e86a                	sd	s10,16(sp)
 144:	1880                	addi	s0,sp,112
 146:	8caa                	mv	s9,a0
 148:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 14a:	892a                	mv	s2,a0
 14c:	4481                	li	s1,0
    cc = read(0, &c, 1);
 14e:	f9f40b13          	addi	s6,s0,-97
 152:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 154:	4ba9                	li	s7,10
 156:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 158:	8d26                	mv	s10,s1
 15a:	0014899b          	addiw	s3,s1,1
 15e:	84ce                	mv	s1,s3
 160:	0349d763          	bge	s3,s4,18e <gets+0x64>
    cc = read(0, &c, 1);
 164:	8656                	mv	a2,s5
 166:	85da                	mv	a1,s6
 168:	4501                	li	a0,0
 16a:	00000097          	auipc	ra,0x0
 16e:	1ac080e7          	jalr	428(ra) # 316 <read>
    if(cc < 1)
 172:	00a05e63          	blez	a0,18e <gets+0x64>
    buf[i++] = c;
 176:	f9f44783          	lbu	a5,-97(s0)
 17a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 17e:	01778763          	beq	a5,s7,18c <gets+0x62>
 182:	0905                	addi	s2,s2,1
 184:	fd879ae3          	bne	a5,s8,158 <gets+0x2e>
    buf[i++] = c;
 188:	8d4e                	mv	s10,s3
 18a:	a011                	j	18e <gets+0x64>
 18c:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 18e:	9d66                	add	s10,s10,s9
 190:	000d0023          	sb	zero,0(s10)
  return buf;
}
 194:	8566                	mv	a0,s9
 196:	70a6                	ld	ra,104(sp)
 198:	7406                	ld	s0,96(sp)
 19a:	64e6                	ld	s1,88(sp)
 19c:	6946                	ld	s2,80(sp)
 19e:	69a6                	ld	s3,72(sp)
 1a0:	6a06                	ld	s4,64(sp)
 1a2:	7ae2                	ld	s5,56(sp)
 1a4:	7b42                	ld	s6,48(sp)
 1a6:	7ba2                	ld	s7,40(sp)
 1a8:	7c02                	ld	s8,32(sp)
 1aa:	6ce2                	ld	s9,24(sp)
 1ac:	6d42                	ld	s10,16(sp)
 1ae:	6165                	addi	sp,sp,112
 1b0:	8082                	ret

00000000000001b2 <stat>:

int
stat(const char *n, struct stat *st)
{
 1b2:	1101                	addi	sp,sp,-32
 1b4:	ec06                	sd	ra,24(sp)
 1b6:	e822                	sd	s0,16(sp)
 1b8:	e04a                	sd	s2,0(sp)
 1ba:	1000                	addi	s0,sp,32
 1bc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1be:	4581                	li	a1,0
 1c0:	00000097          	auipc	ra,0x0
 1c4:	17e080e7          	jalr	382(ra) # 33e <open>
  if(fd < 0)
 1c8:	02054663          	bltz	a0,1f4 <stat+0x42>
 1cc:	e426                	sd	s1,8(sp)
 1ce:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1d0:	85ca                	mv	a1,s2
 1d2:	00000097          	auipc	ra,0x0
 1d6:	184080e7          	jalr	388(ra) # 356 <fstat>
 1da:	892a                	mv	s2,a0
  close(fd);
 1dc:	8526                	mv	a0,s1
 1de:	00000097          	auipc	ra,0x0
 1e2:	148080e7          	jalr	328(ra) # 326 <close>
  return r;
 1e6:	64a2                	ld	s1,8(sp)
}
 1e8:	854a                	mv	a0,s2
 1ea:	60e2                	ld	ra,24(sp)
 1ec:	6442                	ld	s0,16(sp)
 1ee:	6902                	ld	s2,0(sp)
 1f0:	6105                	addi	sp,sp,32
 1f2:	8082                	ret
    return -1;
 1f4:	597d                	li	s2,-1
 1f6:	bfcd                	j	1e8 <stat+0x36>

00000000000001f8 <atoi>:

int
atoi(const char *s)
{
 1f8:	1141                	addi	sp,sp,-16
 1fa:	e406                	sd	ra,8(sp)
 1fc:	e022                	sd	s0,0(sp)
 1fe:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 200:	00054683          	lbu	a3,0(a0)
 204:	fd06879b          	addiw	a5,a3,-48
 208:	0ff7f793          	zext.b	a5,a5
 20c:	4625                	li	a2,9
 20e:	02f66963          	bltu	a2,a5,240 <atoi+0x48>
 212:	872a                	mv	a4,a0
  n = 0;
 214:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 216:	0705                	addi	a4,a4,1
 218:	0025179b          	slliw	a5,a0,0x2
 21c:	9fa9                	addw	a5,a5,a0
 21e:	0017979b          	slliw	a5,a5,0x1
 222:	9fb5                	addw	a5,a5,a3
 224:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 228:	00074683          	lbu	a3,0(a4)
 22c:	fd06879b          	addiw	a5,a3,-48
 230:	0ff7f793          	zext.b	a5,a5
 234:	fef671e3          	bgeu	a2,a5,216 <atoi+0x1e>
  return n;
}
 238:	60a2                	ld	ra,8(sp)
 23a:	6402                	ld	s0,0(sp)
 23c:	0141                	addi	sp,sp,16
 23e:	8082                	ret
  n = 0;
 240:	4501                	li	a0,0
 242:	bfdd                	j	238 <atoi+0x40>

0000000000000244 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 244:	1141                	addi	sp,sp,-16
 246:	e406                	sd	ra,8(sp)
 248:	e022                	sd	s0,0(sp)
 24a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 24c:	02b57563          	bgeu	a0,a1,276 <memmove+0x32>
    while(n-- > 0)
 250:	00c05f63          	blez	a2,26e <memmove+0x2a>
 254:	1602                	slli	a2,a2,0x20
 256:	9201                	srli	a2,a2,0x20
 258:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 25c:	872a                	mv	a4,a0
      *dst++ = *src++;
 25e:	0585                	addi	a1,a1,1
 260:	0705                	addi	a4,a4,1
 262:	fff5c683          	lbu	a3,-1(a1)
 266:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 26a:	fee79ae3          	bne	a5,a4,25e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 26e:	60a2                	ld	ra,8(sp)
 270:	6402                	ld	s0,0(sp)
 272:	0141                	addi	sp,sp,16
 274:	8082                	ret
    dst += n;
 276:	00c50733          	add	a4,a0,a2
    src += n;
 27a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 27c:	fec059e3          	blez	a2,26e <memmove+0x2a>
 280:	fff6079b          	addiw	a5,a2,-1
 284:	1782                	slli	a5,a5,0x20
 286:	9381                	srli	a5,a5,0x20
 288:	fff7c793          	not	a5,a5
 28c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 28e:	15fd                	addi	a1,a1,-1
 290:	177d                	addi	a4,a4,-1
 292:	0005c683          	lbu	a3,0(a1)
 296:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 29a:	fef71ae3          	bne	a4,a5,28e <memmove+0x4a>
 29e:	bfc1                	j	26e <memmove+0x2a>

00000000000002a0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2a0:	1141                	addi	sp,sp,-16
 2a2:	e406                	sd	ra,8(sp)
 2a4:	e022                	sd	s0,0(sp)
 2a6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2a8:	ca0d                	beqz	a2,2da <memcmp+0x3a>
 2aa:	fff6069b          	addiw	a3,a2,-1
 2ae:	1682                	slli	a3,a3,0x20
 2b0:	9281                	srli	a3,a3,0x20
 2b2:	0685                	addi	a3,a3,1
 2b4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2b6:	00054783          	lbu	a5,0(a0)
 2ba:	0005c703          	lbu	a4,0(a1)
 2be:	00e79863          	bne	a5,a4,2ce <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 2c2:	0505                	addi	a0,a0,1
    p2++;
 2c4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2c6:	fed518e3          	bne	a0,a3,2b6 <memcmp+0x16>
  }
  return 0;
 2ca:	4501                	li	a0,0
 2cc:	a019                	j	2d2 <memcmp+0x32>
      return *p1 - *p2;
 2ce:	40e7853b          	subw	a0,a5,a4
}
 2d2:	60a2                	ld	ra,8(sp)
 2d4:	6402                	ld	s0,0(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret
  return 0;
 2da:	4501                	li	a0,0
 2dc:	bfdd                	j	2d2 <memcmp+0x32>

00000000000002de <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2de:	1141                	addi	sp,sp,-16
 2e0:	e406                	sd	ra,8(sp)
 2e2:	e022                	sd	s0,0(sp)
 2e4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2e6:	00000097          	auipc	ra,0x0
 2ea:	f5e080e7          	jalr	-162(ra) # 244 <memmove>
}
 2ee:	60a2                	ld	ra,8(sp)
 2f0:	6402                	ld	s0,0(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret

00000000000002f6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2f6:	4885                	li	a7,1
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <exit>:
.global exit
exit:
 li a7, SYS_exit
 2fe:	4889                	li	a7,2
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <wait>:
.global wait
wait:
 li a7, SYS_wait
 306:	488d                	li	a7,3
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 30e:	4891                	li	a7,4
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <read>:
.global read
read:
 li a7, SYS_read
 316:	4895                	li	a7,5
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <write>:
.global write
write:
 li a7, SYS_write
 31e:	48c1                	li	a7,16
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <close>:
.global close
close:
 li a7, SYS_close
 326:	48d5                	li	a7,21
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <kill>:
.global kill
kill:
 li a7, SYS_kill
 32e:	4899                	li	a7,6
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <exec>:
.global exec
exec:
 li a7, SYS_exec
 336:	489d                	li	a7,7
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <open>:
.global open
open:
 li a7, SYS_open
 33e:	48bd                	li	a7,15
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 346:	48c5                	li	a7,17
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 34e:	48c9                	li	a7,18
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 356:	48a1                	li	a7,8
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <link>:
.global link
link:
 li a7, SYS_link
 35e:	48cd                	li	a7,19
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 366:	48d1                	li	a7,20
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 36e:	48a5                	li	a7,9
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <dup>:
.global dup
dup:
 li a7, SYS_dup
 376:	48a9                	li	a7,10
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 37e:	48ad                	li	a7,11
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 386:	48b1                	li	a7,12
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 38e:	48b5                	li	a7,13
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 396:	48b9                	li	a7,14
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <ps>:
.global ps
ps:
 li a7, SYS_ps
 39e:	48d9                	li	a7,22
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
 3a6:	48dd                	li	a7,23
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
 3ae:	48e1                	li	a7,24
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <yield>:
.global yield
yield:
 li a7, SYS_yield
 3b6:	48e5                	li	a7,25
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3be:	1101                	addi	sp,sp,-32
 3c0:	ec06                	sd	ra,24(sp)
 3c2:	e822                	sd	s0,16(sp)
 3c4:	1000                	addi	s0,sp,32
 3c6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3ca:	4605                	li	a2,1
 3cc:	fef40593          	addi	a1,s0,-17
 3d0:	00000097          	auipc	ra,0x0
 3d4:	f4e080e7          	jalr	-178(ra) # 31e <write>
}
 3d8:	60e2                	ld	ra,24(sp)
 3da:	6442                	ld	s0,16(sp)
 3dc:	6105                	addi	sp,sp,32
 3de:	8082                	ret

00000000000003e0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3e0:	7139                	addi	sp,sp,-64
 3e2:	fc06                	sd	ra,56(sp)
 3e4:	f822                	sd	s0,48(sp)
 3e6:	f426                	sd	s1,40(sp)
 3e8:	f04a                	sd	s2,32(sp)
 3ea:	ec4e                	sd	s3,24(sp)
 3ec:	0080                	addi	s0,sp,64
 3ee:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3f0:	c299                	beqz	a3,3f6 <printint+0x16>
 3f2:	0805c063          	bltz	a1,472 <printint+0x92>
  neg = 0;
 3f6:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 3f8:	fc040313          	addi	t1,s0,-64
  neg = 0;
 3fc:	869a                	mv	a3,t1
  i = 0;
 3fe:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 400:	00000817          	auipc	a6,0x0
 404:	4b080813          	addi	a6,a6,1200 # 8b0 <digits>
 408:	88be                	mv	a7,a5
 40a:	0017851b          	addiw	a0,a5,1
 40e:	87aa                	mv	a5,a0
 410:	02c5f73b          	remuw	a4,a1,a2
 414:	1702                	slli	a4,a4,0x20
 416:	9301                	srli	a4,a4,0x20
 418:	9742                	add	a4,a4,a6
 41a:	00074703          	lbu	a4,0(a4)
 41e:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 422:	872e                	mv	a4,a1
 424:	02c5d5bb          	divuw	a1,a1,a2
 428:	0685                	addi	a3,a3,1
 42a:	fcc77fe3          	bgeu	a4,a2,408 <printint+0x28>
  if(neg)
 42e:	000e0c63          	beqz	t3,446 <printint+0x66>
    buf[i++] = '-';
 432:	fd050793          	addi	a5,a0,-48
 436:	00878533          	add	a0,a5,s0
 43a:	02d00793          	li	a5,45
 43e:	fef50823          	sb	a5,-16(a0)
 442:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 446:	fff7899b          	addiw	s3,a5,-1
 44a:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 44e:	fff4c583          	lbu	a1,-1(s1)
 452:	854a                	mv	a0,s2
 454:	00000097          	auipc	ra,0x0
 458:	f6a080e7          	jalr	-150(ra) # 3be <putc>
  while(--i >= 0)
 45c:	39fd                	addiw	s3,s3,-1
 45e:	14fd                	addi	s1,s1,-1
 460:	fe09d7e3          	bgez	s3,44e <printint+0x6e>
}
 464:	70e2                	ld	ra,56(sp)
 466:	7442                	ld	s0,48(sp)
 468:	74a2                	ld	s1,40(sp)
 46a:	7902                	ld	s2,32(sp)
 46c:	69e2                	ld	s3,24(sp)
 46e:	6121                	addi	sp,sp,64
 470:	8082                	ret
    x = -xx;
 472:	40b005bb          	negw	a1,a1
    neg = 1;
 476:	4e05                	li	t3,1
    x = -xx;
 478:	b741                	j	3f8 <printint+0x18>

000000000000047a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 47a:	715d                	addi	sp,sp,-80
 47c:	e486                	sd	ra,72(sp)
 47e:	e0a2                	sd	s0,64(sp)
 480:	f84a                	sd	s2,48(sp)
 482:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 484:	0005c903          	lbu	s2,0(a1)
 488:	1a090a63          	beqz	s2,63c <vprintf+0x1c2>
 48c:	fc26                	sd	s1,56(sp)
 48e:	f44e                	sd	s3,40(sp)
 490:	f052                	sd	s4,32(sp)
 492:	ec56                	sd	s5,24(sp)
 494:	e85a                	sd	s6,16(sp)
 496:	e45e                	sd	s7,8(sp)
 498:	8aaa                	mv	s5,a0
 49a:	8bb2                	mv	s7,a2
 49c:	00158493          	addi	s1,a1,1
  state = 0;
 4a0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4a2:	02500a13          	li	s4,37
 4a6:	4b55                	li	s6,21
 4a8:	a839                	j	4c6 <vprintf+0x4c>
        putc(fd, c);
 4aa:	85ca                	mv	a1,s2
 4ac:	8556                	mv	a0,s5
 4ae:	00000097          	auipc	ra,0x0
 4b2:	f10080e7          	jalr	-240(ra) # 3be <putc>
 4b6:	a019                	j	4bc <vprintf+0x42>
    } else if(state == '%'){
 4b8:	01498d63          	beq	s3,s4,4d2 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 4bc:	0485                	addi	s1,s1,1
 4be:	fff4c903          	lbu	s2,-1(s1)
 4c2:	16090763          	beqz	s2,630 <vprintf+0x1b6>
    if(state == 0){
 4c6:	fe0999e3          	bnez	s3,4b8 <vprintf+0x3e>
      if(c == '%'){
 4ca:	ff4910e3          	bne	s2,s4,4aa <vprintf+0x30>
        state = '%';
 4ce:	89d2                	mv	s3,s4
 4d0:	b7f5                	j	4bc <vprintf+0x42>
      if(c == 'd'){
 4d2:	13490463          	beq	s2,s4,5fa <vprintf+0x180>
 4d6:	f9d9079b          	addiw	a5,s2,-99
 4da:	0ff7f793          	zext.b	a5,a5
 4de:	12fb6763          	bltu	s6,a5,60c <vprintf+0x192>
 4e2:	f9d9079b          	addiw	a5,s2,-99
 4e6:	0ff7f713          	zext.b	a4,a5
 4ea:	12eb6163          	bltu	s6,a4,60c <vprintf+0x192>
 4ee:	00271793          	slli	a5,a4,0x2
 4f2:	00000717          	auipc	a4,0x0
 4f6:	36670713          	addi	a4,a4,870 # 858 <malloc+0x128>
 4fa:	97ba                	add	a5,a5,a4
 4fc:	439c                	lw	a5,0(a5)
 4fe:	97ba                	add	a5,a5,a4
 500:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 502:	008b8913          	addi	s2,s7,8
 506:	4685                	li	a3,1
 508:	4629                	li	a2,10
 50a:	000ba583          	lw	a1,0(s7)
 50e:	8556                	mv	a0,s5
 510:	00000097          	auipc	ra,0x0
 514:	ed0080e7          	jalr	-304(ra) # 3e0 <printint>
 518:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 51a:	4981                	li	s3,0
 51c:	b745                	j	4bc <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 51e:	008b8913          	addi	s2,s7,8
 522:	4681                	li	a3,0
 524:	4629                	li	a2,10
 526:	000ba583          	lw	a1,0(s7)
 52a:	8556                	mv	a0,s5
 52c:	00000097          	auipc	ra,0x0
 530:	eb4080e7          	jalr	-332(ra) # 3e0 <printint>
 534:	8bca                	mv	s7,s2
      state = 0;
 536:	4981                	li	s3,0
 538:	b751                	j	4bc <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 53a:	008b8913          	addi	s2,s7,8
 53e:	4681                	li	a3,0
 540:	4641                	li	a2,16
 542:	000ba583          	lw	a1,0(s7)
 546:	8556                	mv	a0,s5
 548:	00000097          	auipc	ra,0x0
 54c:	e98080e7          	jalr	-360(ra) # 3e0 <printint>
 550:	8bca                	mv	s7,s2
      state = 0;
 552:	4981                	li	s3,0
 554:	b7a5                	j	4bc <vprintf+0x42>
 556:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 558:	008b8c13          	addi	s8,s7,8
 55c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 560:	03000593          	li	a1,48
 564:	8556                	mv	a0,s5
 566:	00000097          	auipc	ra,0x0
 56a:	e58080e7          	jalr	-424(ra) # 3be <putc>
  putc(fd, 'x');
 56e:	07800593          	li	a1,120
 572:	8556                	mv	a0,s5
 574:	00000097          	auipc	ra,0x0
 578:	e4a080e7          	jalr	-438(ra) # 3be <putc>
 57c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 57e:	00000b97          	auipc	s7,0x0
 582:	332b8b93          	addi	s7,s7,818 # 8b0 <digits>
 586:	03c9d793          	srli	a5,s3,0x3c
 58a:	97de                	add	a5,a5,s7
 58c:	0007c583          	lbu	a1,0(a5)
 590:	8556                	mv	a0,s5
 592:	00000097          	auipc	ra,0x0
 596:	e2c080e7          	jalr	-468(ra) # 3be <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 59a:	0992                	slli	s3,s3,0x4
 59c:	397d                	addiw	s2,s2,-1
 59e:	fe0914e3          	bnez	s2,586 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 5a2:	8be2                	mv	s7,s8
      state = 0;
 5a4:	4981                	li	s3,0
 5a6:	6c02                	ld	s8,0(sp)
 5a8:	bf11                	j	4bc <vprintf+0x42>
        s = va_arg(ap, char*);
 5aa:	008b8993          	addi	s3,s7,8
 5ae:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5b2:	02090163          	beqz	s2,5d4 <vprintf+0x15a>
        while(*s != 0){
 5b6:	00094583          	lbu	a1,0(s2)
 5ba:	c9a5                	beqz	a1,62a <vprintf+0x1b0>
          putc(fd, *s);
 5bc:	8556                	mv	a0,s5
 5be:	00000097          	auipc	ra,0x0
 5c2:	e00080e7          	jalr	-512(ra) # 3be <putc>
          s++;
 5c6:	0905                	addi	s2,s2,1
        while(*s != 0){
 5c8:	00094583          	lbu	a1,0(s2)
 5cc:	f9e5                	bnez	a1,5bc <vprintf+0x142>
        s = va_arg(ap, char*);
 5ce:	8bce                	mv	s7,s3
      state = 0;
 5d0:	4981                	li	s3,0
 5d2:	b5ed                	j	4bc <vprintf+0x42>
          s = "(null)";
 5d4:	00000917          	auipc	s2,0x0
 5d8:	27c90913          	addi	s2,s2,636 # 850 <malloc+0x120>
        while(*s != 0){
 5dc:	02800593          	li	a1,40
 5e0:	bff1                	j	5bc <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 5e2:	008b8913          	addi	s2,s7,8
 5e6:	000bc583          	lbu	a1,0(s7)
 5ea:	8556                	mv	a0,s5
 5ec:	00000097          	auipc	ra,0x0
 5f0:	dd2080e7          	jalr	-558(ra) # 3be <putc>
 5f4:	8bca                	mv	s7,s2
      state = 0;
 5f6:	4981                	li	s3,0
 5f8:	b5d1                	j	4bc <vprintf+0x42>
        putc(fd, c);
 5fa:	02500593          	li	a1,37
 5fe:	8556                	mv	a0,s5
 600:	00000097          	auipc	ra,0x0
 604:	dbe080e7          	jalr	-578(ra) # 3be <putc>
      state = 0;
 608:	4981                	li	s3,0
 60a:	bd4d                	j	4bc <vprintf+0x42>
        putc(fd, '%');
 60c:	02500593          	li	a1,37
 610:	8556                	mv	a0,s5
 612:	00000097          	auipc	ra,0x0
 616:	dac080e7          	jalr	-596(ra) # 3be <putc>
        putc(fd, c);
 61a:	85ca                	mv	a1,s2
 61c:	8556                	mv	a0,s5
 61e:	00000097          	auipc	ra,0x0
 622:	da0080e7          	jalr	-608(ra) # 3be <putc>
      state = 0;
 626:	4981                	li	s3,0
 628:	bd51                	j	4bc <vprintf+0x42>
        s = va_arg(ap, char*);
 62a:	8bce                	mv	s7,s3
      state = 0;
 62c:	4981                	li	s3,0
 62e:	b579                	j	4bc <vprintf+0x42>
 630:	74e2                	ld	s1,56(sp)
 632:	79a2                	ld	s3,40(sp)
 634:	7a02                	ld	s4,32(sp)
 636:	6ae2                	ld	s5,24(sp)
 638:	6b42                	ld	s6,16(sp)
 63a:	6ba2                	ld	s7,8(sp)
    }
  }
}
 63c:	60a6                	ld	ra,72(sp)
 63e:	6406                	ld	s0,64(sp)
 640:	7942                	ld	s2,48(sp)
 642:	6161                	addi	sp,sp,80
 644:	8082                	ret

0000000000000646 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 646:	715d                	addi	sp,sp,-80
 648:	ec06                	sd	ra,24(sp)
 64a:	e822                	sd	s0,16(sp)
 64c:	1000                	addi	s0,sp,32
 64e:	e010                	sd	a2,0(s0)
 650:	e414                	sd	a3,8(s0)
 652:	e818                	sd	a4,16(s0)
 654:	ec1c                	sd	a5,24(s0)
 656:	03043023          	sd	a6,32(s0)
 65a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 65e:	8622                	mv	a2,s0
 660:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 664:	00000097          	auipc	ra,0x0
 668:	e16080e7          	jalr	-490(ra) # 47a <vprintf>
}
 66c:	60e2                	ld	ra,24(sp)
 66e:	6442                	ld	s0,16(sp)
 670:	6161                	addi	sp,sp,80
 672:	8082                	ret

0000000000000674 <printf>:

void
printf(const char *fmt, ...)
{
 674:	711d                	addi	sp,sp,-96
 676:	ec06                	sd	ra,24(sp)
 678:	e822                	sd	s0,16(sp)
 67a:	1000                	addi	s0,sp,32
 67c:	e40c                	sd	a1,8(s0)
 67e:	e810                	sd	a2,16(s0)
 680:	ec14                	sd	a3,24(s0)
 682:	f018                	sd	a4,32(s0)
 684:	f41c                	sd	a5,40(s0)
 686:	03043823          	sd	a6,48(s0)
 68a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 68e:	00840613          	addi	a2,s0,8
 692:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 696:	85aa                	mv	a1,a0
 698:	4505                	li	a0,1
 69a:	00000097          	auipc	ra,0x0
 69e:	de0080e7          	jalr	-544(ra) # 47a <vprintf>
}
 6a2:	60e2                	ld	ra,24(sp)
 6a4:	6442                	ld	s0,16(sp)
 6a6:	6125                	addi	sp,sp,96
 6a8:	8082                	ret

00000000000006aa <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6aa:	1141                	addi	sp,sp,-16
 6ac:	e406                	sd	ra,8(sp)
 6ae:	e022                	sd	s0,0(sp)
 6b0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6b2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b6:	00001797          	auipc	a5,0x1
 6ba:	94a7b783          	ld	a5,-1718(a5) # 1000 <freep>
 6be:	a02d                	j	6e8 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6c0:	4618                	lw	a4,8(a2)
 6c2:	9f2d                	addw	a4,a4,a1
 6c4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6c8:	6398                	ld	a4,0(a5)
 6ca:	6310                	ld	a2,0(a4)
 6cc:	a83d                	j	70a <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6ce:	ff852703          	lw	a4,-8(a0)
 6d2:	9f31                	addw	a4,a4,a2
 6d4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6d6:	ff053683          	ld	a3,-16(a0)
 6da:	a091                	j	71e <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6dc:	6398                	ld	a4,0(a5)
 6de:	00e7e463          	bltu	a5,a4,6e6 <free+0x3c>
 6e2:	00e6ea63          	bltu	a3,a4,6f6 <free+0x4c>
{
 6e6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e8:	fed7fae3          	bgeu	a5,a3,6dc <free+0x32>
 6ec:	6398                	ld	a4,0(a5)
 6ee:	00e6e463          	bltu	a3,a4,6f6 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f2:	fee7eae3          	bltu	a5,a4,6e6 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 6f6:	ff852583          	lw	a1,-8(a0)
 6fa:	6390                	ld	a2,0(a5)
 6fc:	02059813          	slli	a6,a1,0x20
 700:	01c85713          	srli	a4,a6,0x1c
 704:	9736                	add	a4,a4,a3
 706:	fae60de3          	beq	a2,a4,6c0 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 70a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 70e:	4790                	lw	a2,8(a5)
 710:	02061593          	slli	a1,a2,0x20
 714:	01c5d713          	srli	a4,a1,0x1c
 718:	973e                	add	a4,a4,a5
 71a:	fae68ae3          	beq	a3,a4,6ce <free+0x24>
    p->s.ptr = bp->s.ptr;
 71e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 720:	00001717          	auipc	a4,0x1
 724:	8ef73023          	sd	a5,-1824(a4) # 1000 <freep>
}
 728:	60a2                	ld	ra,8(sp)
 72a:	6402                	ld	s0,0(sp)
 72c:	0141                	addi	sp,sp,16
 72e:	8082                	ret

0000000000000730 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 730:	7139                	addi	sp,sp,-64
 732:	fc06                	sd	ra,56(sp)
 734:	f822                	sd	s0,48(sp)
 736:	f04a                	sd	s2,32(sp)
 738:	ec4e                	sd	s3,24(sp)
 73a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 73c:	02051993          	slli	s3,a0,0x20
 740:	0209d993          	srli	s3,s3,0x20
 744:	09bd                	addi	s3,s3,15
 746:	0049d993          	srli	s3,s3,0x4
 74a:	2985                	addiw	s3,s3,1
 74c:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 74e:	00001517          	auipc	a0,0x1
 752:	8b253503          	ld	a0,-1870(a0) # 1000 <freep>
 756:	c905                	beqz	a0,786 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 758:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 75a:	4798                	lw	a4,8(a5)
 75c:	09377a63          	bgeu	a4,s3,7f0 <malloc+0xc0>
 760:	f426                	sd	s1,40(sp)
 762:	e852                	sd	s4,16(sp)
 764:	e456                	sd	s5,8(sp)
 766:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 768:	8a4e                	mv	s4,s3
 76a:	6705                	lui	a4,0x1
 76c:	00e9f363          	bgeu	s3,a4,772 <malloc+0x42>
 770:	6a05                	lui	s4,0x1
 772:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 776:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 77a:	00001497          	auipc	s1,0x1
 77e:	88648493          	addi	s1,s1,-1914 # 1000 <freep>
  if(p == (char*)-1)
 782:	5afd                	li	s5,-1
 784:	a089                	j	7c6 <malloc+0x96>
 786:	f426                	sd	s1,40(sp)
 788:	e852                	sd	s4,16(sp)
 78a:	e456                	sd	s5,8(sp)
 78c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 78e:	00001797          	auipc	a5,0x1
 792:	88278793          	addi	a5,a5,-1918 # 1010 <base>
 796:	00001717          	auipc	a4,0x1
 79a:	86f73523          	sd	a5,-1942(a4) # 1000 <freep>
 79e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7a0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7a4:	b7d1                	j	768 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 7a6:	6398                	ld	a4,0(a5)
 7a8:	e118                	sd	a4,0(a0)
 7aa:	a8b9                	j	808 <malloc+0xd8>
  hp->s.size = nu;
 7ac:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7b0:	0541                	addi	a0,a0,16
 7b2:	00000097          	auipc	ra,0x0
 7b6:	ef8080e7          	jalr	-264(ra) # 6aa <free>
  return freep;
 7ba:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 7bc:	c135                	beqz	a0,820 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7be:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7c0:	4798                	lw	a4,8(a5)
 7c2:	03277363          	bgeu	a4,s2,7e8 <malloc+0xb8>
    if(p == freep)
 7c6:	6098                	ld	a4,0(s1)
 7c8:	853e                	mv	a0,a5
 7ca:	fef71ae3          	bne	a4,a5,7be <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 7ce:	8552                	mv	a0,s4
 7d0:	00000097          	auipc	ra,0x0
 7d4:	bb6080e7          	jalr	-1098(ra) # 386 <sbrk>
  if(p == (char*)-1)
 7d8:	fd551ae3          	bne	a0,s5,7ac <malloc+0x7c>
        return 0;
 7dc:	4501                	li	a0,0
 7de:	74a2                	ld	s1,40(sp)
 7e0:	6a42                	ld	s4,16(sp)
 7e2:	6aa2                	ld	s5,8(sp)
 7e4:	6b02                	ld	s6,0(sp)
 7e6:	a03d                	j	814 <malloc+0xe4>
 7e8:	74a2                	ld	s1,40(sp)
 7ea:	6a42                	ld	s4,16(sp)
 7ec:	6aa2                	ld	s5,8(sp)
 7ee:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 7f0:	fae90be3          	beq	s2,a4,7a6 <malloc+0x76>
        p->s.size -= nunits;
 7f4:	4137073b          	subw	a4,a4,s3
 7f8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7fa:	02071693          	slli	a3,a4,0x20
 7fe:	01c6d713          	srli	a4,a3,0x1c
 802:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 804:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 808:	00000717          	auipc	a4,0x0
 80c:	7ea73c23          	sd	a0,2040(a4) # 1000 <freep>
      return (void*)(p + 1);
 810:	01078513          	addi	a0,a5,16
  }
}
 814:	70e2                	ld	ra,56(sp)
 816:	7442                	ld	s0,48(sp)
 818:	7902                	ld	s2,32(sp)
 81a:	69e2                	ld	s3,24(sp)
 81c:	6121                	addi	sp,sp,64
 81e:	8082                	ret
 820:	74a2                	ld	s1,40(sp)
 822:	6a42                	ld	s4,16(sp)
 824:	6aa2                	ld	s5,8(sp)
 826:	6b02                	ld	s6,0(sp)
 828:	b7f5                	j	814 <malloc+0xe4>
