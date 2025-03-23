
user/_vatopa:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	1800                	addi	s0,sp,48
    if(argc < 2) {
   8:	4785                	li	a5,1
   a:	04a7d563          	bge	a5,a0,54 <main+0x54>
   e:	ec26                	sd	s1,24(sp)
  10:	e84a                	sd	s2,16(sp)
  12:	e44e                	sd	s3,8(sp)
  14:	84aa                	mv	s1,a0
  16:	892e                	mv	s2,a1
        printf("Usage: vatopa virtual_address [pid]\n");
        exit(1);
    }

    uint64 va = atoi(argv[1]);
  18:	6588                	ld	a0,8(a1)
  1a:	00000097          	auipc	ra,0x0
  1e:	230080e7          	jalr	560(ra) # 24a <atoi>
  22:	89aa                	mv	s3,a0
    int pid = (argc > 2) ? atoi(argv[2]) : 0;
  24:	4789                	li	a5,2
  26:	4581                	li	a1,0
  28:	0497c663          	blt	a5,s1,74 <main+0x74>

    uint64 pa = va2pa(va, pid);
  2c:	854e                	mv	a0,s3
  2e:	00000097          	auipc	ra,0x0
  32:	3da080e7          	jalr	986(ra) # 408 <va2pa>
  36:	85aa                	mv	a1,a0
    if(pa == 0) {
  38:	e531                	bnez	a0,84 <main+0x84>
        printf("0x0\n");
  3a:	00001517          	auipc	a0,0x1
  3e:	87e50513          	addi	a0,a0,-1922 # 8b8 <malloc+0x12e>
  42:	00000097          	auipc	ra,0x0
  46:	68c080e7          	jalr	1676(ra) # 6ce <printf>
    } else {
        printf("0x%x\n", pa);
    }
    exit(0);
  4a:	4501                	li	a0,0
  4c:	00000097          	auipc	ra,0x0
  50:	304080e7          	jalr	772(ra) # 350 <exit>
  54:	ec26                	sd	s1,24(sp)
  56:	e84a                	sd	s2,16(sp)
  58:	e44e                	sd	s3,8(sp)
        printf("Usage: vatopa virtual_address [pid]\n");
  5a:	00001517          	auipc	a0,0x1
  5e:	83650513          	addi	a0,a0,-1994 # 890 <malloc+0x106>
  62:	00000097          	auipc	ra,0x0
  66:	66c080e7          	jalr	1644(ra) # 6ce <printf>
        exit(1);
  6a:	4505                	li	a0,1
  6c:	00000097          	auipc	ra,0x0
  70:	2e4080e7          	jalr	740(ra) # 350 <exit>
    int pid = (argc > 2) ? atoi(argv[2]) : 0;
  74:	01093503          	ld	a0,16(s2)
  78:	00000097          	auipc	ra,0x0
  7c:	1d2080e7          	jalr	466(ra) # 24a <atoi>
  80:	85aa                	mv	a1,a0
  82:	b76d                	j	2c <main+0x2c>
        printf("0x%x\n", pa);
  84:	00001517          	auipc	a0,0x1
  88:	83c50513          	addi	a0,a0,-1988 # 8c0 <malloc+0x136>
  8c:	00000097          	auipc	ra,0x0
  90:	642080e7          	jalr	1602(ra) # 6ce <printf>
  94:	bf5d                	j	4a <main+0x4a>

0000000000000096 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  96:	1141                	addi	sp,sp,-16
  98:	e406                	sd	ra,8(sp)
  9a:	e022                	sd	s0,0(sp)
  9c:	0800                	addi	s0,sp,16
  extern int main();
  main();
  9e:	00000097          	auipc	ra,0x0
  a2:	f62080e7          	jalr	-158(ra) # 0 <main>
  exit(0);
  a6:	4501                	li	a0,0
  a8:	00000097          	auipc	ra,0x0
  ac:	2a8080e7          	jalr	680(ra) # 350 <exit>

00000000000000b0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  b0:	1141                	addi	sp,sp,-16
  b2:	e406                	sd	ra,8(sp)
  b4:	e022                	sd	s0,0(sp)
  b6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  b8:	87aa                	mv	a5,a0
  ba:	0585                	addi	a1,a1,1
  bc:	0785                	addi	a5,a5,1
  be:	fff5c703          	lbu	a4,-1(a1)
  c2:	fee78fa3          	sb	a4,-1(a5)
  c6:	fb75                	bnez	a4,ba <strcpy+0xa>
    ;
  return os;
}
  c8:	60a2                	ld	ra,8(sp)
  ca:	6402                	ld	s0,0(sp)
  cc:	0141                	addi	sp,sp,16
  ce:	8082                	ret

00000000000000d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d0:	1141                	addi	sp,sp,-16
  d2:	e406                	sd	ra,8(sp)
  d4:	e022                	sd	s0,0(sp)
  d6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  d8:	00054783          	lbu	a5,0(a0)
  dc:	cb91                	beqz	a5,f0 <strcmp+0x20>
  de:	0005c703          	lbu	a4,0(a1)
  e2:	00f71763          	bne	a4,a5,f0 <strcmp+0x20>
    p++, q++;
  e6:	0505                	addi	a0,a0,1
  e8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  ea:	00054783          	lbu	a5,0(a0)
  ee:	fbe5                	bnez	a5,de <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  f0:	0005c503          	lbu	a0,0(a1)
}
  f4:	40a7853b          	subw	a0,a5,a0
  f8:	60a2                	ld	ra,8(sp)
  fa:	6402                	ld	s0,0(sp)
  fc:	0141                	addi	sp,sp,16
  fe:	8082                	ret

0000000000000100 <strlen>:

uint
strlen(const char *s)
{
 100:	1141                	addi	sp,sp,-16
 102:	e406                	sd	ra,8(sp)
 104:	e022                	sd	s0,0(sp)
 106:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 108:	00054783          	lbu	a5,0(a0)
 10c:	cf99                	beqz	a5,12a <strlen+0x2a>
 10e:	0505                	addi	a0,a0,1
 110:	87aa                	mv	a5,a0
 112:	86be                	mv	a3,a5
 114:	0785                	addi	a5,a5,1
 116:	fff7c703          	lbu	a4,-1(a5)
 11a:	ff65                	bnez	a4,112 <strlen+0x12>
 11c:	40a6853b          	subw	a0,a3,a0
 120:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 122:	60a2                	ld	ra,8(sp)
 124:	6402                	ld	s0,0(sp)
 126:	0141                	addi	sp,sp,16
 128:	8082                	ret
  for(n = 0; s[n]; n++)
 12a:	4501                	li	a0,0
 12c:	bfdd                	j	122 <strlen+0x22>

000000000000012e <memset>:

void*
memset(void *dst, int c, uint n)
{
 12e:	1141                	addi	sp,sp,-16
 130:	e406                	sd	ra,8(sp)
 132:	e022                	sd	s0,0(sp)
 134:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 136:	ca19                	beqz	a2,14c <memset+0x1e>
 138:	87aa                	mv	a5,a0
 13a:	1602                	slli	a2,a2,0x20
 13c:	9201                	srli	a2,a2,0x20
 13e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 142:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 146:	0785                	addi	a5,a5,1
 148:	fee79de3          	bne	a5,a4,142 <memset+0x14>
  }
  return dst;
}
 14c:	60a2                	ld	ra,8(sp)
 14e:	6402                	ld	s0,0(sp)
 150:	0141                	addi	sp,sp,16
 152:	8082                	ret

0000000000000154 <strchr>:

char*
strchr(const char *s, char c)
{
 154:	1141                	addi	sp,sp,-16
 156:	e406                	sd	ra,8(sp)
 158:	e022                	sd	s0,0(sp)
 15a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 15c:	00054783          	lbu	a5,0(a0)
 160:	cf81                	beqz	a5,178 <strchr+0x24>
    if(*s == c)
 162:	00f58763          	beq	a1,a5,170 <strchr+0x1c>
  for(; *s; s++)
 166:	0505                	addi	a0,a0,1
 168:	00054783          	lbu	a5,0(a0)
 16c:	fbfd                	bnez	a5,162 <strchr+0xe>
      return (char*)s;
  return 0;
 16e:	4501                	li	a0,0
}
 170:	60a2                	ld	ra,8(sp)
 172:	6402                	ld	s0,0(sp)
 174:	0141                	addi	sp,sp,16
 176:	8082                	ret
  return 0;
 178:	4501                	li	a0,0
 17a:	bfdd                	j	170 <strchr+0x1c>

000000000000017c <gets>:

char*
gets(char *buf, int max)
{
 17c:	7159                	addi	sp,sp,-112
 17e:	f486                	sd	ra,104(sp)
 180:	f0a2                	sd	s0,96(sp)
 182:	eca6                	sd	s1,88(sp)
 184:	e8ca                	sd	s2,80(sp)
 186:	e4ce                	sd	s3,72(sp)
 188:	e0d2                	sd	s4,64(sp)
 18a:	fc56                	sd	s5,56(sp)
 18c:	f85a                	sd	s6,48(sp)
 18e:	f45e                	sd	s7,40(sp)
 190:	f062                	sd	s8,32(sp)
 192:	ec66                	sd	s9,24(sp)
 194:	e86a                	sd	s10,16(sp)
 196:	1880                	addi	s0,sp,112
 198:	8caa                	mv	s9,a0
 19a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19c:	892a                	mv	s2,a0
 19e:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1a0:	f9f40b13          	addi	s6,s0,-97
 1a4:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1a6:	4ba9                	li	s7,10
 1a8:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 1aa:	8d26                	mv	s10,s1
 1ac:	0014899b          	addiw	s3,s1,1
 1b0:	84ce                	mv	s1,s3
 1b2:	0349d763          	bge	s3,s4,1e0 <gets+0x64>
    cc = read(0, &c, 1);
 1b6:	8656                	mv	a2,s5
 1b8:	85da                	mv	a1,s6
 1ba:	4501                	li	a0,0
 1bc:	00000097          	auipc	ra,0x0
 1c0:	1ac080e7          	jalr	428(ra) # 368 <read>
    if(cc < 1)
 1c4:	00a05e63          	blez	a0,1e0 <gets+0x64>
    buf[i++] = c;
 1c8:	f9f44783          	lbu	a5,-97(s0)
 1cc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1d0:	01778763          	beq	a5,s7,1de <gets+0x62>
 1d4:	0905                	addi	s2,s2,1
 1d6:	fd879ae3          	bne	a5,s8,1aa <gets+0x2e>
    buf[i++] = c;
 1da:	8d4e                	mv	s10,s3
 1dc:	a011                	j	1e0 <gets+0x64>
 1de:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1e0:	9d66                	add	s10,s10,s9
 1e2:	000d0023          	sb	zero,0(s10)
  return buf;
}
 1e6:	8566                	mv	a0,s9
 1e8:	70a6                	ld	ra,104(sp)
 1ea:	7406                	ld	s0,96(sp)
 1ec:	64e6                	ld	s1,88(sp)
 1ee:	6946                	ld	s2,80(sp)
 1f0:	69a6                	ld	s3,72(sp)
 1f2:	6a06                	ld	s4,64(sp)
 1f4:	7ae2                	ld	s5,56(sp)
 1f6:	7b42                	ld	s6,48(sp)
 1f8:	7ba2                	ld	s7,40(sp)
 1fa:	7c02                	ld	s8,32(sp)
 1fc:	6ce2                	ld	s9,24(sp)
 1fe:	6d42                	ld	s10,16(sp)
 200:	6165                	addi	sp,sp,112
 202:	8082                	ret

0000000000000204 <stat>:

int
stat(const char *n, struct stat *st)
{
 204:	1101                	addi	sp,sp,-32
 206:	ec06                	sd	ra,24(sp)
 208:	e822                	sd	s0,16(sp)
 20a:	e04a                	sd	s2,0(sp)
 20c:	1000                	addi	s0,sp,32
 20e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 210:	4581                	li	a1,0
 212:	00000097          	auipc	ra,0x0
 216:	17e080e7          	jalr	382(ra) # 390 <open>
  if(fd < 0)
 21a:	02054663          	bltz	a0,246 <stat+0x42>
 21e:	e426                	sd	s1,8(sp)
 220:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 222:	85ca                	mv	a1,s2
 224:	00000097          	auipc	ra,0x0
 228:	184080e7          	jalr	388(ra) # 3a8 <fstat>
 22c:	892a                	mv	s2,a0
  close(fd);
 22e:	8526                	mv	a0,s1
 230:	00000097          	auipc	ra,0x0
 234:	148080e7          	jalr	328(ra) # 378 <close>
  return r;
 238:	64a2                	ld	s1,8(sp)
}
 23a:	854a                	mv	a0,s2
 23c:	60e2                	ld	ra,24(sp)
 23e:	6442                	ld	s0,16(sp)
 240:	6902                	ld	s2,0(sp)
 242:	6105                	addi	sp,sp,32
 244:	8082                	ret
    return -1;
 246:	597d                	li	s2,-1
 248:	bfcd                	j	23a <stat+0x36>

000000000000024a <atoi>:

int
atoi(const char *s)
{
 24a:	1141                	addi	sp,sp,-16
 24c:	e406                	sd	ra,8(sp)
 24e:	e022                	sd	s0,0(sp)
 250:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 252:	00054683          	lbu	a3,0(a0)
 256:	fd06879b          	addiw	a5,a3,-48
 25a:	0ff7f793          	zext.b	a5,a5
 25e:	4625                	li	a2,9
 260:	02f66963          	bltu	a2,a5,292 <atoi+0x48>
 264:	872a                	mv	a4,a0
  n = 0;
 266:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 268:	0705                	addi	a4,a4,1
 26a:	0025179b          	slliw	a5,a0,0x2
 26e:	9fa9                	addw	a5,a5,a0
 270:	0017979b          	slliw	a5,a5,0x1
 274:	9fb5                	addw	a5,a5,a3
 276:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 27a:	00074683          	lbu	a3,0(a4)
 27e:	fd06879b          	addiw	a5,a3,-48
 282:	0ff7f793          	zext.b	a5,a5
 286:	fef671e3          	bgeu	a2,a5,268 <atoi+0x1e>
  return n;
}
 28a:	60a2                	ld	ra,8(sp)
 28c:	6402                	ld	s0,0(sp)
 28e:	0141                	addi	sp,sp,16
 290:	8082                	ret
  n = 0;
 292:	4501                	li	a0,0
 294:	bfdd                	j	28a <atoi+0x40>

0000000000000296 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 296:	1141                	addi	sp,sp,-16
 298:	e406                	sd	ra,8(sp)
 29a:	e022                	sd	s0,0(sp)
 29c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 29e:	02b57563          	bgeu	a0,a1,2c8 <memmove+0x32>
    while(n-- > 0)
 2a2:	00c05f63          	blez	a2,2c0 <memmove+0x2a>
 2a6:	1602                	slli	a2,a2,0x20
 2a8:	9201                	srli	a2,a2,0x20
 2aa:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2ae:	872a                	mv	a4,a0
      *dst++ = *src++;
 2b0:	0585                	addi	a1,a1,1
 2b2:	0705                	addi	a4,a4,1
 2b4:	fff5c683          	lbu	a3,-1(a1)
 2b8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2bc:	fee79ae3          	bne	a5,a4,2b0 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2c0:	60a2                	ld	ra,8(sp)
 2c2:	6402                	ld	s0,0(sp)
 2c4:	0141                	addi	sp,sp,16
 2c6:	8082                	ret
    dst += n;
 2c8:	00c50733          	add	a4,a0,a2
    src += n;
 2cc:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2ce:	fec059e3          	blez	a2,2c0 <memmove+0x2a>
 2d2:	fff6079b          	addiw	a5,a2,-1
 2d6:	1782                	slli	a5,a5,0x20
 2d8:	9381                	srli	a5,a5,0x20
 2da:	fff7c793          	not	a5,a5
 2de:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2e0:	15fd                	addi	a1,a1,-1
 2e2:	177d                	addi	a4,a4,-1
 2e4:	0005c683          	lbu	a3,0(a1)
 2e8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2ec:	fef71ae3          	bne	a4,a5,2e0 <memmove+0x4a>
 2f0:	bfc1                	j	2c0 <memmove+0x2a>

00000000000002f2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2f2:	1141                	addi	sp,sp,-16
 2f4:	e406                	sd	ra,8(sp)
 2f6:	e022                	sd	s0,0(sp)
 2f8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2fa:	ca0d                	beqz	a2,32c <memcmp+0x3a>
 2fc:	fff6069b          	addiw	a3,a2,-1
 300:	1682                	slli	a3,a3,0x20
 302:	9281                	srli	a3,a3,0x20
 304:	0685                	addi	a3,a3,1
 306:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 308:	00054783          	lbu	a5,0(a0)
 30c:	0005c703          	lbu	a4,0(a1)
 310:	00e79863          	bne	a5,a4,320 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 314:	0505                	addi	a0,a0,1
    p2++;
 316:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 318:	fed518e3          	bne	a0,a3,308 <memcmp+0x16>
  }
  return 0;
 31c:	4501                	li	a0,0
 31e:	a019                	j	324 <memcmp+0x32>
      return *p1 - *p2;
 320:	40e7853b          	subw	a0,a5,a4
}
 324:	60a2                	ld	ra,8(sp)
 326:	6402                	ld	s0,0(sp)
 328:	0141                	addi	sp,sp,16
 32a:	8082                	ret
  return 0;
 32c:	4501                	li	a0,0
 32e:	bfdd                	j	324 <memcmp+0x32>

0000000000000330 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 330:	1141                	addi	sp,sp,-16
 332:	e406                	sd	ra,8(sp)
 334:	e022                	sd	s0,0(sp)
 336:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 338:	00000097          	auipc	ra,0x0
 33c:	f5e080e7          	jalr	-162(ra) # 296 <memmove>
}
 340:	60a2                	ld	ra,8(sp)
 342:	6402                	ld	s0,0(sp)
 344:	0141                	addi	sp,sp,16
 346:	8082                	ret

0000000000000348 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 348:	4885                	li	a7,1
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <exit>:
.global exit
exit:
 li a7, SYS_exit
 350:	4889                	li	a7,2
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <wait>:
.global wait
wait:
 li a7, SYS_wait
 358:	488d                	li	a7,3
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 360:	4891                	li	a7,4
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <read>:
.global read
read:
 li a7, SYS_read
 368:	4895                	li	a7,5
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <write>:
.global write
write:
 li a7, SYS_write
 370:	48c1                	li	a7,16
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <close>:
.global close
close:
 li a7, SYS_close
 378:	48d5                	li	a7,21
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <kill>:
.global kill
kill:
 li a7, SYS_kill
 380:	4899                	li	a7,6
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <exec>:
.global exec
exec:
 li a7, SYS_exec
 388:	489d                	li	a7,7
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <open>:
.global open
open:
 li a7, SYS_open
 390:	48bd                	li	a7,15
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 398:	48c5                	li	a7,17
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3a0:	48c9                	li	a7,18
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3a8:	48a1                	li	a7,8
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <link>:
.global link
link:
 li a7, SYS_link
 3b0:	48cd                	li	a7,19
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3b8:	48d1                	li	a7,20
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3c0:	48a5                	li	a7,9
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3c8:	48a9                	li	a7,10
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3d0:	48ad                	li	a7,11
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3d8:	48b1                	li	a7,12
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3e0:	48b5                	li	a7,13
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3e8:	48b9                	li	a7,14
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <ps>:
.global ps
ps:
 li a7, SYS_ps
 3f0:	48d9                	li	a7,22
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
 3f8:	48dd                	li	a7,23
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
 400:	48e1                	li	a7,24
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <va2pa>:
.global va2pa
va2pa:
 li a7, SYS_va2pa
 408:	48e9                	li	a7,26
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <pfreepages>:
.global pfreepages
pfreepages:
 li a7, SYS_pfreepages
 410:	48e5                	li	a7,25
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 418:	1101                	addi	sp,sp,-32
 41a:	ec06                	sd	ra,24(sp)
 41c:	e822                	sd	s0,16(sp)
 41e:	1000                	addi	s0,sp,32
 420:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 424:	4605                	li	a2,1
 426:	fef40593          	addi	a1,s0,-17
 42a:	00000097          	auipc	ra,0x0
 42e:	f46080e7          	jalr	-186(ra) # 370 <write>
}
 432:	60e2                	ld	ra,24(sp)
 434:	6442                	ld	s0,16(sp)
 436:	6105                	addi	sp,sp,32
 438:	8082                	ret

000000000000043a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 43a:	7139                	addi	sp,sp,-64
 43c:	fc06                	sd	ra,56(sp)
 43e:	f822                	sd	s0,48(sp)
 440:	f426                	sd	s1,40(sp)
 442:	f04a                	sd	s2,32(sp)
 444:	ec4e                	sd	s3,24(sp)
 446:	0080                	addi	s0,sp,64
 448:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 44a:	c299                	beqz	a3,450 <printint+0x16>
 44c:	0805c063          	bltz	a1,4cc <printint+0x92>
  neg = 0;
 450:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 452:	fc040313          	addi	t1,s0,-64
  neg = 0;
 456:	869a                	mv	a3,t1
  i = 0;
 458:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 45a:	00000817          	auipc	a6,0x0
 45e:	4ce80813          	addi	a6,a6,1230 # 928 <digits>
 462:	88be                	mv	a7,a5
 464:	0017851b          	addiw	a0,a5,1
 468:	87aa                	mv	a5,a0
 46a:	02c5f73b          	remuw	a4,a1,a2
 46e:	1702                	slli	a4,a4,0x20
 470:	9301                	srli	a4,a4,0x20
 472:	9742                	add	a4,a4,a6
 474:	00074703          	lbu	a4,0(a4)
 478:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 47c:	872e                	mv	a4,a1
 47e:	02c5d5bb          	divuw	a1,a1,a2
 482:	0685                	addi	a3,a3,1
 484:	fcc77fe3          	bgeu	a4,a2,462 <printint+0x28>
  if(neg)
 488:	000e0c63          	beqz	t3,4a0 <printint+0x66>
    buf[i++] = '-';
 48c:	fd050793          	addi	a5,a0,-48
 490:	00878533          	add	a0,a5,s0
 494:	02d00793          	li	a5,45
 498:	fef50823          	sb	a5,-16(a0)
 49c:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 4a0:	fff7899b          	addiw	s3,a5,-1
 4a4:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 4a8:	fff4c583          	lbu	a1,-1(s1)
 4ac:	854a                	mv	a0,s2
 4ae:	00000097          	auipc	ra,0x0
 4b2:	f6a080e7          	jalr	-150(ra) # 418 <putc>
  while(--i >= 0)
 4b6:	39fd                	addiw	s3,s3,-1
 4b8:	14fd                	addi	s1,s1,-1
 4ba:	fe09d7e3          	bgez	s3,4a8 <printint+0x6e>
}
 4be:	70e2                	ld	ra,56(sp)
 4c0:	7442                	ld	s0,48(sp)
 4c2:	74a2                	ld	s1,40(sp)
 4c4:	7902                	ld	s2,32(sp)
 4c6:	69e2                	ld	s3,24(sp)
 4c8:	6121                	addi	sp,sp,64
 4ca:	8082                	ret
    x = -xx;
 4cc:	40b005bb          	negw	a1,a1
    neg = 1;
 4d0:	4e05                	li	t3,1
    x = -xx;
 4d2:	b741                	j	452 <printint+0x18>

00000000000004d4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4d4:	715d                	addi	sp,sp,-80
 4d6:	e486                	sd	ra,72(sp)
 4d8:	e0a2                	sd	s0,64(sp)
 4da:	f84a                	sd	s2,48(sp)
 4dc:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4de:	0005c903          	lbu	s2,0(a1)
 4e2:	1a090a63          	beqz	s2,696 <vprintf+0x1c2>
 4e6:	fc26                	sd	s1,56(sp)
 4e8:	f44e                	sd	s3,40(sp)
 4ea:	f052                	sd	s4,32(sp)
 4ec:	ec56                	sd	s5,24(sp)
 4ee:	e85a                	sd	s6,16(sp)
 4f0:	e45e                	sd	s7,8(sp)
 4f2:	8aaa                	mv	s5,a0
 4f4:	8bb2                	mv	s7,a2
 4f6:	00158493          	addi	s1,a1,1
  state = 0;
 4fa:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4fc:	02500a13          	li	s4,37
 500:	4b55                	li	s6,21
 502:	a839                	j	520 <vprintf+0x4c>
        putc(fd, c);
 504:	85ca                	mv	a1,s2
 506:	8556                	mv	a0,s5
 508:	00000097          	auipc	ra,0x0
 50c:	f10080e7          	jalr	-240(ra) # 418 <putc>
 510:	a019                	j	516 <vprintf+0x42>
    } else if(state == '%'){
 512:	01498d63          	beq	s3,s4,52c <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 516:	0485                	addi	s1,s1,1
 518:	fff4c903          	lbu	s2,-1(s1)
 51c:	16090763          	beqz	s2,68a <vprintf+0x1b6>
    if(state == 0){
 520:	fe0999e3          	bnez	s3,512 <vprintf+0x3e>
      if(c == '%'){
 524:	ff4910e3          	bne	s2,s4,504 <vprintf+0x30>
        state = '%';
 528:	89d2                	mv	s3,s4
 52a:	b7f5                	j	516 <vprintf+0x42>
      if(c == 'd'){
 52c:	13490463          	beq	s2,s4,654 <vprintf+0x180>
 530:	f9d9079b          	addiw	a5,s2,-99
 534:	0ff7f793          	zext.b	a5,a5
 538:	12fb6763          	bltu	s6,a5,666 <vprintf+0x192>
 53c:	f9d9079b          	addiw	a5,s2,-99
 540:	0ff7f713          	zext.b	a4,a5
 544:	12eb6163          	bltu	s6,a4,666 <vprintf+0x192>
 548:	00271793          	slli	a5,a4,0x2
 54c:	00000717          	auipc	a4,0x0
 550:	38470713          	addi	a4,a4,900 # 8d0 <malloc+0x146>
 554:	97ba                	add	a5,a5,a4
 556:	439c                	lw	a5,0(a5)
 558:	97ba                	add	a5,a5,a4
 55a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 55c:	008b8913          	addi	s2,s7,8
 560:	4685                	li	a3,1
 562:	4629                	li	a2,10
 564:	000ba583          	lw	a1,0(s7)
 568:	8556                	mv	a0,s5
 56a:	00000097          	auipc	ra,0x0
 56e:	ed0080e7          	jalr	-304(ra) # 43a <printint>
 572:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 574:	4981                	li	s3,0
 576:	b745                	j	516 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 578:	008b8913          	addi	s2,s7,8
 57c:	4681                	li	a3,0
 57e:	4629                	li	a2,10
 580:	000ba583          	lw	a1,0(s7)
 584:	8556                	mv	a0,s5
 586:	00000097          	auipc	ra,0x0
 58a:	eb4080e7          	jalr	-332(ra) # 43a <printint>
 58e:	8bca                	mv	s7,s2
      state = 0;
 590:	4981                	li	s3,0
 592:	b751                	j	516 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 594:	008b8913          	addi	s2,s7,8
 598:	4681                	li	a3,0
 59a:	4641                	li	a2,16
 59c:	000ba583          	lw	a1,0(s7)
 5a0:	8556                	mv	a0,s5
 5a2:	00000097          	auipc	ra,0x0
 5a6:	e98080e7          	jalr	-360(ra) # 43a <printint>
 5aa:	8bca                	mv	s7,s2
      state = 0;
 5ac:	4981                	li	s3,0
 5ae:	b7a5                	j	516 <vprintf+0x42>
 5b0:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5b2:	008b8c13          	addi	s8,s7,8
 5b6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5ba:	03000593          	li	a1,48
 5be:	8556                	mv	a0,s5
 5c0:	00000097          	auipc	ra,0x0
 5c4:	e58080e7          	jalr	-424(ra) # 418 <putc>
  putc(fd, 'x');
 5c8:	07800593          	li	a1,120
 5cc:	8556                	mv	a0,s5
 5ce:	00000097          	auipc	ra,0x0
 5d2:	e4a080e7          	jalr	-438(ra) # 418 <putc>
 5d6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5d8:	00000b97          	auipc	s7,0x0
 5dc:	350b8b93          	addi	s7,s7,848 # 928 <digits>
 5e0:	03c9d793          	srli	a5,s3,0x3c
 5e4:	97de                	add	a5,a5,s7
 5e6:	0007c583          	lbu	a1,0(a5)
 5ea:	8556                	mv	a0,s5
 5ec:	00000097          	auipc	ra,0x0
 5f0:	e2c080e7          	jalr	-468(ra) # 418 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5f4:	0992                	slli	s3,s3,0x4
 5f6:	397d                	addiw	s2,s2,-1
 5f8:	fe0914e3          	bnez	s2,5e0 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 5fc:	8be2                	mv	s7,s8
      state = 0;
 5fe:	4981                	li	s3,0
 600:	6c02                	ld	s8,0(sp)
 602:	bf11                	j	516 <vprintf+0x42>
        s = va_arg(ap, char*);
 604:	008b8993          	addi	s3,s7,8
 608:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 60c:	02090163          	beqz	s2,62e <vprintf+0x15a>
        while(*s != 0){
 610:	00094583          	lbu	a1,0(s2)
 614:	c9a5                	beqz	a1,684 <vprintf+0x1b0>
          putc(fd, *s);
 616:	8556                	mv	a0,s5
 618:	00000097          	auipc	ra,0x0
 61c:	e00080e7          	jalr	-512(ra) # 418 <putc>
          s++;
 620:	0905                	addi	s2,s2,1
        while(*s != 0){
 622:	00094583          	lbu	a1,0(s2)
 626:	f9e5                	bnez	a1,616 <vprintf+0x142>
        s = va_arg(ap, char*);
 628:	8bce                	mv	s7,s3
      state = 0;
 62a:	4981                	li	s3,0
 62c:	b5ed                	j	516 <vprintf+0x42>
          s = "(null)";
 62e:	00000917          	auipc	s2,0x0
 632:	29a90913          	addi	s2,s2,666 # 8c8 <malloc+0x13e>
        while(*s != 0){
 636:	02800593          	li	a1,40
 63a:	bff1                	j	616 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 63c:	008b8913          	addi	s2,s7,8
 640:	000bc583          	lbu	a1,0(s7)
 644:	8556                	mv	a0,s5
 646:	00000097          	auipc	ra,0x0
 64a:	dd2080e7          	jalr	-558(ra) # 418 <putc>
 64e:	8bca                	mv	s7,s2
      state = 0;
 650:	4981                	li	s3,0
 652:	b5d1                	j	516 <vprintf+0x42>
        putc(fd, c);
 654:	02500593          	li	a1,37
 658:	8556                	mv	a0,s5
 65a:	00000097          	auipc	ra,0x0
 65e:	dbe080e7          	jalr	-578(ra) # 418 <putc>
      state = 0;
 662:	4981                	li	s3,0
 664:	bd4d                	j	516 <vprintf+0x42>
        putc(fd, '%');
 666:	02500593          	li	a1,37
 66a:	8556                	mv	a0,s5
 66c:	00000097          	auipc	ra,0x0
 670:	dac080e7          	jalr	-596(ra) # 418 <putc>
        putc(fd, c);
 674:	85ca                	mv	a1,s2
 676:	8556                	mv	a0,s5
 678:	00000097          	auipc	ra,0x0
 67c:	da0080e7          	jalr	-608(ra) # 418 <putc>
      state = 0;
 680:	4981                	li	s3,0
 682:	bd51                	j	516 <vprintf+0x42>
        s = va_arg(ap, char*);
 684:	8bce                	mv	s7,s3
      state = 0;
 686:	4981                	li	s3,0
 688:	b579                	j	516 <vprintf+0x42>
 68a:	74e2                	ld	s1,56(sp)
 68c:	79a2                	ld	s3,40(sp)
 68e:	7a02                	ld	s4,32(sp)
 690:	6ae2                	ld	s5,24(sp)
 692:	6b42                	ld	s6,16(sp)
 694:	6ba2                	ld	s7,8(sp)
    }
  }
}
 696:	60a6                	ld	ra,72(sp)
 698:	6406                	ld	s0,64(sp)
 69a:	7942                	ld	s2,48(sp)
 69c:	6161                	addi	sp,sp,80
 69e:	8082                	ret

00000000000006a0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6a0:	715d                	addi	sp,sp,-80
 6a2:	ec06                	sd	ra,24(sp)
 6a4:	e822                	sd	s0,16(sp)
 6a6:	1000                	addi	s0,sp,32
 6a8:	e010                	sd	a2,0(s0)
 6aa:	e414                	sd	a3,8(s0)
 6ac:	e818                	sd	a4,16(s0)
 6ae:	ec1c                	sd	a5,24(s0)
 6b0:	03043023          	sd	a6,32(s0)
 6b4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6b8:	8622                	mv	a2,s0
 6ba:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6be:	00000097          	auipc	ra,0x0
 6c2:	e16080e7          	jalr	-490(ra) # 4d4 <vprintf>
}
 6c6:	60e2                	ld	ra,24(sp)
 6c8:	6442                	ld	s0,16(sp)
 6ca:	6161                	addi	sp,sp,80
 6cc:	8082                	ret

00000000000006ce <printf>:

void
printf(const char *fmt, ...)
{
 6ce:	711d                	addi	sp,sp,-96
 6d0:	ec06                	sd	ra,24(sp)
 6d2:	e822                	sd	s0,16(sp)
 6d4:	1000                	addi	s0,sp,32
 6d6:	e40c                	sd	a1,8(s0)
 6d8:	e810                	sd	a2,16(s0)
 6da:	ec14                	sd	a3,24(s0)
 6dc:	f018                	sd	a4,32(s0)
 6de:	f41c                	sd	a5,40(s0)
 6e0:	03043823          	sd	a6,48(s0)
 6e4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6e8:	00840613          	addi	a2,s0,8
 6ec:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6f0:	85aa                	mv	a1,a0
 6f2:	4505                	li	a0,1
 6f4:	00000097          	auipc	ra,0x0
 6f8:	de0080e7          	jalr	-544(ra) # 4d4 <vprintf>
}
 6fc:	60e2                	ld	ra,24(sp)
 6fe:	6442                	ld	s0,16(sp)
 700:	6125                	addi	sp,sp,96
 702:	8082                	ret

0000000000000704 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 704:	1141                	addi	sp,sp,-16
 706:	e406                	sd	ra,8(sp)
 708:	e022                	sd	s0,0(sp)
 70a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 70c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 710:	00001797          	auipc	a5,0x1
 714:	8f07b783          	ld	a5,-1808(a5) # 1000 <freep>
 718:	a02d                	j	742 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 71a:	4618                	lw	a4,8(a2)
 71c:	9f2d                	addw	a4,a4,a1
 71e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 722:	6398                	ld	a4,0(a5)
 724:	6310                	ld	a2,0(a4)
 726:	a83d                	j	764 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 728:	ff852703          	lw	a4,-8(a0)
 72c:	9f31                	addw	a4,a4,a2
 72e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 730:	ff053683          	ld	a3,-16(a0)
 734:	a091                	j	778 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 736:	6398                	ld	a4,0(a5)
 738:	00e7e463          	bltu	a5,a4,740 <free+0x3c>
 73c:	00e6ea63          	bltu	a3,a4,750 <free+0x4c>
{
 740:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 742:	fed7fae3          	bgeu	a5,a3,736 <free+0x32>
 746:	6398                	ld	a4,0(a5)
 748:	00e6e463          	bltu	a3,a4,750 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 74c:	fee7eae3          	bltu	a5,a4,740 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 750:	ff852583          	lw	a1,-8(a0)
 754:	6390                	ld	a2,0(a5)
 756:	02059813          	slli	a6,a1,0x20
 75a:	01c85713          	srli	a4,a6,0x1c
 75e:	9736                	add	a4,a4,a3
 760:	fae60de3          	beq	a2,a4,71a <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 764:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 768:	4790                	lw	a2,8(a5)
 76a:	02061593          	slli	a1,a2,0x20
 76e:	01c5d713          	srli	a4,a1,0x1c
 772:	973e                	add	a4,a4,a5
 774:	fae68ae3          	beq	a3,a4,728 <free+0x24>
    p->s.ptr = bp->s.ptr;
 778:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 77a:	00001717          	auipc	a4,0x1
 77e:	88f73323          	sd	a5,-1914(a4) # 1000 <freep>
}
 782:	60a2                	ld	ra,8(sp)
 784:	6402                	ld	s0,0(sp)
 786:	0141                	addi	sp,sp,16
 788:	8082                	ret

000000000000078a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 78a:	7139                	addi	sp,sp,-64
 78c:	fc06                	sd	ra,56(sp)
 78e:	f822                	sd	s0,48(sp)
 790:	f04a                	sd	s2,32(sp)
 792:	ec4e                	sd	s3,24(sp)
 794:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 796:	02051993          	slli	s3,a0,0x20
 79a:	0209d993          	srli	s3,s3,0x20
 79e:	09bd                	addi	s3,s3,15
 7a0:	0049d993          	srli	s3,s3,0x4
 7a4:	2985                	addiw	s3,s3,1
 7a6:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7a8:	00001517          	auipc	a0,0x1
 7ac:	85853503          	ld	a0,-1960(a0) # 1000 <freep>
 7b0:	c905                	beqz	a0,7e0 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7b4:	4798                	lw	a4,8(a5)
 7b6:	09377a63          	bgeu	a4,s3,84a <malloc+0xc0>
 7ba:	f426                	sd	s1,40(sp)
 7bc:	e852                	sd	s4,16(sp)
 7be:	e456                	sd	s5,8(sp)
 7c0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7c2:	8a4e                	mv	s4,s3
 7c4:	6705                	lui	a4,0x1
 7c6:	00e9f363          	bgeu	s3,a4,7cc <malloc+0x42>
 7ca:	6a05                	lui	s4,0x1
 7cc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7d0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7d4:	00001497          	auipc	s1,0x1
 7d8:	82c48493          	addi	s1,s1,-2004 # 1000 <freep>
  if(p == (char*)-1)
 7dc:	5afd                	li	s5,-1
 7de:	a089                	j	820 <malloc+0x96>
 7e0:	f426                	sd	s1,40(sp)
 7e2:	e852                	sd	s4,16(sp)
 7e4:	e456                	sd	s5,8(sp)
 7e6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7e8:	00001797          	auipc	a5,0x1
 7ec:	82878793          	addi	a5,a5,-2008 # 1010 <base>
 7f0:	00001717          	auipc	a4,0x1
 7f4:	80f73823          	sd	a5,-2032(a4) # 1000 <freep>
 7f8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7fa:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7fe:	b7d1                	j	7c2 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 800:	6398                	ld	a4,0(a5)
 802:	e118                	sd	a4,0(a0)
 804:	a8b9                	j	862 <malloc+0xd8>
  hp->s.size = nu;
 806:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 80a:	0541                	addi	a0,a0,16
 80c:	00000097          	auipc	ra,0x0
 810:	ef8080e7          	jalr	-264(ra) # 704 <free>
  return freep;
 814:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 816:	c135                	beqz	a0,87a <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 818:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 81a:	4798                	lw	a4,8(a5)
 81c:	03277363          	bgeu	a4,s2,842 <malloc+0xb8>
    if(p == freep)
 820:	6098                	ld	a4,0(s1)
 822:	853e                	mv	a0,a5
 824:	fef71ae3          	bne	a4,a5,818 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 828:	8552                	mv	a0,s4
 82a:	00000097          	auipc	ra,0x0
 82e:	bae080e7          	jalr	-1106(ra) # 3d8 <sbrk>
  if(p == (char*)-1)
 832:	fd551ae3          	bne	a0,s5,806 <malloc+0x7c>
        return 0;
 836:	4501                	li	a0,0
 838:	74a2                	ld	s1,40(sp)
 83a:	6a42                	ld	s4,16(sp)
 83c:	6aa2                	ld	s5,8(sp)
 83e:	6b02                	ld	s6,0(sp)
 840:	a03d                	j	86e <malloc+0xe4>
 842:	74a2                	ld	s1,40(sp)
 844:	6a42                	ld	s4,16(sp)
 846:	6aa2                	ld	s5,8(sp)
 848:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 84a:	fae90be3          	beq	s2,a4,800 <malloc+0x76>
        p->s.size -= nunits;
 84e:	4137073b          	subw	a4,a4,s3
 852:	c798                	sw	a4,8(a5)
        p += p->s.size;
 854:	02071693          	slli	a3,a4,0x20
 858:	01c6d713          	srli	a4,a3,0x1c
 85c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 85e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 862:	00000717          	auipc	a4,0x0
 866:	78a73f23          	sd	a0,1950(a4) # 1000 <freep>
      return (void*)(p + 1);
 86a:	01078513          	addi	a0,a5,16
  }
}
 86e:	70e2                	ld	ra,56(sp)
 870:	7442                	ld	s0,48(sp)
 872:	7902                	ld	s2,32(sp)
 874:	69e2                	ld	s3,24(sp)
 876:	6121                	addi	sp,sp,64
 878:	8082                	ret
 87a:	74a2                	ld	s1,40(sp)
 87c:	6a42                	ld	s4,16(sp)
 87e:	6aa2                	ld	s5,8(sp)
 880:	6b02                	ld	s6,0(sp)
 882:	b7f5                	j	86e <malloc+0xe4>
