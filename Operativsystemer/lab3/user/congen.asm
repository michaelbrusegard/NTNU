
user/_congen:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print>:
#include "user/user.h"

#define N 5

void print(const char *s)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
    write(1, s, strlen(s));
   c:	00000097          	auipc	ra,0x0
  10:	142080e7          	jalr	322(ra) # 14e <strlen>
  14:	862a                	mv	a2,a0
  16:	85a6                	mv	a1,s1
  18:	4505                	li	a0,1
  1a:	00000097          	auipc	ra,0x0
  1e:	3a4080e7          	jalr	932(ra) # 3be <write>
}
  22:	60e2                	ld	ra,24(sp)
  24:	6442                	ld	s0,16(sp)
  26:	64a2                	ld	s1,8(sp)
  28:	6105                	addi	sp,sp,32
  2a:	8082                	ret

000000000000002c <forktest>:

void forktest(void)
{
  2c:	7139                	addi	sp,sp,-64
  2e:	fc06                	sd	ra,56(sp)
  30:	f822                	sd	s0,48(sp)
  32:	f426                	sd	s1,40(sp)
  34:	f04a                	sd	s2,32(sp)
  36:	ec4e                	sd	s3,24(sp)
  38:	e852                	sd	s4,16(sp)
  3a:	e456                	sd	s5,8(sp)
  3c:	e05a                	sd	s6,0(sp)
  3e:	0080                	addi	s0,sp,64
    int n, pid;

    print("fork test\n");
  40:	00001517          	auipc	a0,0x1
  44:	8a050513          	addi	a0,a0,-1888 # 8e0 <malloc+0x108>
  48:	00000097          	auipc	ra,0x0
  4c:	fb8080e7          	jalr	-72(ra) # 0 <print>

    for (n = 0; n < N; n++)
  50:	4a01                	li	s4,0
  52:	4495                	li	s1,5
    {
        pid = fork();
  54:	00000097          	auipc	ra,0x0
  58:	342080e7          	jalr	834(ra) # 396 <fork>
  5c:	892a                	mv	s2,a0
        if (pid < 0)
            break;
        if (pid == 0)
  5e:	00a05563          	blez	a0,68 <forktest+0x3c>
    for (n = 0; n < N; n++)
  62:	2a05                	addiw	s4,s4,1
  64:	fe9a18e3          	bne	s4,s1,54 <forktest+0x28>
            break;
    }

    for (unsigned long long i = 0; i < 1000; i++)
  68:	4481                	li	s1,0
        {
            printf("CHILD %d: %d\n", n, i);
        }
        else
        {
            printf("PARENT: %d\n", i);
  6a:	00001b17          	auipc	s6,0x1
  6e:	896b0b13          	addi	s6,s6,-1898 # 900 <malloc+0x128>
            printf("CHILD %d: %d\n", n, i);
  72:	00001a97          	auipc	s5,0x1
  76:	87ea8a93          	addi	s5,s5,-1922 # 8f0 <malloc+0x118>
    for (unsigned long long i = 0; i < 1000; i++)
  7a:	3e800993          	li	s3,1000
  7e:	a811                	j	92 <forktest+0x66>
            printf("PARENT: %d\n", i);
  80:	85a6                	mv	a1,s1
  82:	855a                	mv	a0,s6
  84:	00000097          	auipc	ra,0x0
  88:	698080e7          	jalr	1688(ra) # 71c <printf>
    for (unsigned long long i = 0; i < 1000; i++)
  8c:	0485                	addi	s1,s1,1
  8e:	01348c63          	beq	s1,s3,a6 <forktest+0x7a>
        if (pid == 0)
  92:	fe0917e3          	bnez	s2,80 <forktest+0x54>
            printf("CHILD %d: %d\n", n, i);
  96:	8626                	mv	a2,s1
  98:	85d2                	mv	a1,s4
  9a:	8556                	mv	a0,s5
  9c:	00000097          	auipc	ra,0x0
  a0:	680080e7          	jalr	1664(ra) # 71c <printf>
  a4:	b7e5                	j	8c <forktest+0x60>
        }
    }

    print("fork test OK\n");
  a6:	00001517          	auipc	a0,0x1
  aa:	86a50513          	addi	a0,a0,-1942 # 910 <malloc+0x138>
  ae:	00000097          	auipc	ra,0x0
  b2:	f52080e7          	jalr	-174(ra) # 0 <print>
}
  b6:	70e2                	ld	ra,56(sp)
  b8:	7442                	ld	s0,48(sp)
  ba:	74a2                	ld	s1,40(sp)
  bc:	7902                	ld	s2,32(sp)
  be:	69e2                	ld	s3,24(sp)
  c0:	6a42                	ld	s4,16(sp)
  c2:	6aa2                	ld	s5,8(sp)
  c4:	6b02                	ld	s6,0(sp)
  c6:	6121                	addi	sp,sp,64
  c8:	8082                	ret

00000000000000ca <main>:

int main(void)
{
  ca:	1141                	addi	sp,sp,-16
  cc:	e406                	sd	ra,8(sp)
  ce:	e022                	sd	s0,0(sp)
  d0:	0800                	addi	s0,sp,16
    forktest();
  d2:	00000097          	auipc	ra,0x0
  d6:	f5a080e7          	jalr	-166(ra) # 2c <forktest>
    exit(0);
  da:	4501                	li	a0,0
  dc:	00000097          	auipc	ra,0x0
  e0:	2c2080e7          	jalr	706(ra) # 39e <exit>

00000000000000e4 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  e4:	1141                	addi	sp,sp,-16
  e6:	e406                	sd	ra,8(sp)
  e8:	e022                	sd	s0,0(sp)
  ea:	0800                	addi	s0,sp,16
  extern int main();
  main();
  ec:	00000097          	auipc	ra,0x0
  f0:	fde080e7          	jalr	-34(ra) # ca <main>
  exit(0);
  f4:	4501                	li	a0,0
  f6:	00000097          	auipc	ra,0x0
  fa:	2a8080e7          	jalr	680(ra) # 39e <exit>

00000000000000fe <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  fe:	1141                	addi	sp,sp,-16
 100:	e406                	sd	ra,8(sp)
 102:	e022                	sd	s0,0(sp)
 104:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 106:	87aa                	mv	a5,a0
 108:	0585                	addi	a1,a1,1
 10a:	0785                	addi	a5,a5,1
 10c:	fff5c703          	lbu	a4,-1(a1)
 110:	fee78fa3          	sb	a4,-1(a5)
 114:	fb75                	bnez	a4,108 <strcpy+0xa>
    ;
  return os;
}
 116:	60a2                	ld	ra,8(sp)
 118:	6402                	ld	s0,0(sp)
 11a:	0141                	addi	sp,sp,16
 11c:	8082                	ret

000000000000011e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 11e:	1141                	addi	sp,sp,-16
 120:	e406                	sd	ra,8(sp)
 122:	e022                	sd	s0,0(sp)
 124:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 126:	00054783          	lbu	a5,0(a0)
 12a:	cb91                	beqz	a5,13e <strcmp+0x20>
 12c:	0005c703          	lbu	a4,0(a1)
 130:	00f71763          	bne	a4,a5,13e <strcmp+0x20>
    p++, q++;
 134:	0505                	addi	a0,a0,1
 136:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 138:	00054783          	lbu	a5,0(a0)
 13c:	fbe5                	bnez	a5,12c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 13e:	0005c503          	lbu	a0,0(a1)
}
 142:	40a7853b          	subw	a0,a5,a0
 146:	60a2                	ld	ra,8(sp)
 148:	6402                	ld	s0,0(sp)
 14a:	0141                	addi	sp,sp,16
 14c:	8082                	ret

000000000000014e <strlen>:

uint
strlen(const char *s)
{
 14e:	1141                	addi	sp,sp,-16
 150:	e406                	sd	ra,8(sp)
 152:	e022                	sd	s0,0(sp)
 154:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 156:	00054783          	lbu	a5,0(a0)
 15a:	cf99                	beqz	a5,178 <strlen+0x2a>
 15c:	0505                	addi	a0,a0,1
 15e:	87aa                	mv	a5,a0
 160:	86be                	mv	a3,a5
 162:	0785                	addi	a5,a5,1
 164:	fff7c703          	lbu	a4,-1(a5)
 168:	ff65                	bnez	a4,160 <strlen+0x12>
 16a:	40a6853b          	subw	a0,a3,a0
 16e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 170:	60a2                	ld	ra,8(sp)
 172:	6402                	ld	s0,0(sp)
 174:	0141                	addi	sp,sp,16
 176:	8082                	ret
  for(n = 0; s[n]; n++)
 178:	4501                	li	a0,0
 17a:	bfdd                	j	170 <strlen+0x22>

000000000000017c <memset>:

void*
memset(void *dst, int c, uint n)
{
 17c:	1141                	addi	sp,sp,-16
 17e:	e406                	sd	ra,8(sp)
 180:	e022                	sd	s0,0(sp)
 182:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 184:	ca19                	beqz	a2,19a <memset+0x1e>
 186:	87aa                	mv	a5,a0
 188:	1602                	slli	a2,a2,0x20
 18a:	9201                	srli	a2,a2,0x20
 18c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 190:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 194:	0785                	addi	a5,a5,1
 196:	fee79de3          	bne	a5,a4,190 <memset+0x14>
  }
  return dst;
}
 19a:	60a2                	ld	ra,8(sp)
 19c:	6402                	ld	s0,0(sp)
 19e:	0141                	addi	sp,sp,16
 1a0:	8082                	ret

00000000000001a2 <strchr>:

char*
strchr(const char *s, char c)
{
 1a2:	1141                	addi	sp,sp,-16
 1a4:	e406                	sd	ra,8(sp)
 1a6:	e022                	sd	s0,0(sp)
 1a8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1aa:	00054783          	lbu	a5,0(a0)
 1ae:	cf81                	beqz	a5,1c6 <strchr+0x24>
    if(*s == c)
 1b0:	00f58763          	beq	a1,a5,1be <strchr+0x1c>
  for(; *s; s++)
 1b4:	0505                	addi	a0,a0,1
 1b6:	00054783          	lbu	a5,0(a0)
 1ba:	fbfd                	bnez	a5,1b0 <strchr+0xe>
      return (char*)s;
  return 0;
 1bc:	4501                	li	a0,0
}
 1be:	60a2                	ld	ra,8(sp)
 1c0:	6402                	ld	s0,0(sp)
 1c2:	0141                	addi	sp,sp,16
 1c4:	8082                	ret
  return 0;
 1c6:	4501                	li	a0,0
 1c8:	bfdd                	j	1be <strchr+0x1c>

00000000000001ca <gets>:

char*
gets(char *buf, int max)
{
 1ca:	7159                	addi	sp,sp,-112
 1cc:	f486                	sd	ra,104(sp)
 1ce:	f0a2                	sd	s0,96(sp)
 1d0:	eca6                	sd	s1,88(sp)
 1d2:	e8ca                	sd	s2,80(sp)
 1d4:	e4ce                	sd	s3,72(sp)
 1d6:	e0d2                	sd	s4,64(sp)
 1d8:	fc56                	sd	s5,56(sp)
 1da:	f85a                	sd	s6,48(sp)
 1dc:	f45e                	sd	s7,40(sp)
 1de:	f062                	sd	s8,32(sp)
 1e0:	ec66                	sd	s9,24(sp)
 1e2:	e86a                	sd	s10,16(sp)
 1e4:	1880                	addi	s0,sp,112
 1e6:	8caa                	mv	s9,a0
 1e8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ea:	892a                	mv	s2,a0
 1ec:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1ee:	f9f40b13          	addi	s6,s0,-97
 1f2:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1f4:	4ba9                	li	s7,10
 1f6:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 1f8:	8d26                	mv	s10,s1
 1fa:	0014899b          	addiw	s3,s1,1
 1fe:	84ce                	mv	s1,s3
 200:	0349d763          	bge	s3,s4,22e <gets+0x64>
    cc = read(0, &c, 1);
 204:	8656                	mv	a2,s5
 206:	85da                	mv	a1,s6
 208:	4501                	li	a0,0
 20a:	00000097          	auipc	ra,0x0
 20e:	1ac080e7          	jalr	428(ra) # 3b6 <read>
    if(cc < 1)
 212:	00a05e63          	blez	a0,22e <gets+0x64>
    buf[i++] = c;
 216:	f9f44783          	lbu	a5,-97(s0)
 21a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 21e:	01778763          	beq	a5,s7,22c <gets+0x62>
 222:	0905                	addi	s2,s2,1
 224:	fd879ae3          	bne	a5,s8,1f8 <gets+0x2e>
    buf[i++] = c;
 228:	8d4e                	mv	s10,s3
 22a:	a011                	j	22e <gets+0x64>
 22c:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 22e:	9d66                	add	s10,s10,s9
 230:	000d0023          	sb	zero,0(s10)
  return buf;
}
 234:	8566                	mv	a0,s9
 236:	70a6                	ld	ra,104(sp)
 238:	7406                	ld	s0,96(sp)
 23a:	64e6                	ld	s1,88(sp)
 23c:	6946                	ld	s2,80(sp)
 23e:	69a6                	ld	s3,72(sp)
 240:	6a06                	ld	s4,64(sp)
 242:	7ae2                	ld	s5,56(sp)
 244:	7b42                	ld	s6,48(sp)
 246:	7ba2                	ld	s7,40(sp)
 248:	7c02                	ld	s8,32(sp)
 24a:	6ce2                	ld	s9,24(sp)
 24c:	6d42                	ld	s10,16(sp)
 24e:	6165                	addi	sp,sp,112
 250:	8082                	ret

0000000000000252 <stat>:

int
stat(const char *n, struct stat *st)
{
 252:	1101                	addi	sp,sp,-32
 254:	ec06                	sd	ra,24(sp)
 256:	e822                	sd	s0,16(sp)
 258:	e04a                	sd	s2,0(sp)
 25a:	1000                	addi	s0,sp,32
 25c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 25e:	4581                	li	a1,0
 260:	00000097          	auipc	ra,0x0
 264:	17e080e7          	jalr	382(ra) # 3de <open>
  if(fd < 0)
 268:	02054663          	bltz	a0,294 <stat+0x42>
 26c:	e426                	sd	s1,8(sp)
 26e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 270:	85ca                	mv	a1,s2
 272:	00000097          	auipc	ra,0x0
 276:	184080e7          	jalr	388(ra) # 3f6 <fstat>
 27a:	892a                	mv	s2,a0
  close(fd);
 27c:	8526                	mv	a0,s1
 27e:	00000097          	auipc	ra,0x0
 282:	148080e7          	jalr	328(ra) # 3c6 <close>
  return r;
 286:	64a2                	ld	s1,8(sp)
}
 288:	854a                	mv	a0,s2
 28a:	60e2                	ld	ra,24(sp)
 28c:	6442                	ld	s0,16(sp)
 28e:	6902                	ld	s2,0(sp)
 290:	6105                	addi	sp,sp,32
 292:	8082                	ret
    return -1;
 294:	597d                	li	s2,-1
 296:	bfcd                	j	288 <stat+0x36>

0000000000000298 <atoi>:

int
atoi(const char *s)
{
 298:	1141                	addi	sp,sp,-16
 29a:	e406                	sd	ra,8(sp)
 29c:	e022                	sd	s0,0(sp)
 29e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2a0:	00054683          	lbu	a3,0(a0)
 2a4:	fd06879b          	addiw	a5,a3,-48
 2a8:	0ff7f793          	zext.b	a5,a5
 2ac:	4625                	li	a2,9
 2ae:	02f66963          	bltu	a2,a5,2e0 <atoi+0x48>
 2b2:	872a                	mv	a4,a0
  n = 0;
 2b4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2b6:	0705                	addi	a4,a4,1
 2b8:	0025179b          	slliw	a5,a0,0x2
 2bc:	9fa9                	addw	a5,a5,a0
 2be:	0017979b          	slliw	a5,a5,0x1
 2c2:	9fb5                	addw	a5,a5,a3
 2c4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2c8:	00074683          	lbu	a3,0(a4)
 2cc:	fd06879b          	addiw	a5,a3,-48
 2d0:	0ff7f793          	zext.b	a5,a5
 2d4:	fef671e3          	bgeu	a2,a5,2b6 <atoi+0x1e>
  return n;
}
 2d8:	60a2                	ld	ra,8(sp)
 2da:	6402                	ld	s0,0(sp)
 2dc:	0141                	addi	sp,sp,16
 2de:	8082                	ret
  n = 0;
 2e0:	4501                	li	a0,0
 2e2:	bfdd                	j	2d8 <atoi+0x40>

00000000000002e4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2e4:	1141                	addi	sp,sp,-16
 2e6:	e406                	sd	ra,8(sp)
 2e8:	e022                	sd	s0,0(sp)
 2ea:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2ec:	02b57563          	bgeu	a0,a1,316 <memmove+0x32>
    while(n-- > 0)
 2f0:	00c05f63          	blez	a2,30e <memmove+0x2a>
 2f4:	1602                	slli	a2,a2,0x20
 2f6:	9201                	srli	a2,a2,0x20
 2f8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2fc:	872a                	mv	a4,a0
      *dst++ = *src++;
 2fe:	0585                	addi	a1,a1,1
 300:	0705                	addi	a4,a4,1
 302:	fff5c683          	lbu	a3,-1(a1)
 306:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 30a:	fee79ae3          	bne	a5,a4,2fe <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 30e:	60a2                	ld	ra,8(sp)
 310:	6402                	ld	s0,0(sp)
 312:	0141                	addi	sp,sp,16
 314:	8082                	ret
    dst += n;
 316:	00c50733          	add	a4,a0,a2
    src += n;
 31a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 31c:	fec059e3          	blez	a2,30e <memmove+0x2a>
 320:	fff6079b          	addiw	a5,a2,-1
 324:	1782                	slli	a5,a5,0x20
 326:	9381                	srli	a5,a5,0x20
 328:	fff7c793          	not	a5,a5
 32c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 32e:	15fd                	addi	a1,a1,-1
 330:	177d                	addi	a4,a4,-1
 332:	0005c683          	lbu	a3,0(a1)
 336:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 33a:	fef71ae3          	bne	a4,a5,32e <memmove+0x4a>
 33e:	bfc1                	j	30e <memmove+0x2a>

0000000000000340 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 340:	1141                	addi	sp,sp,-16
 342:	e406                	sd	ra,8(sp)
 344:	e022                	sd	s0,0(sp)
 346:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 348:	ca0d                	beqz	a2,37a <memcmp+0x3a>
 34a:	fff6069b          	addiw	a3,a2,-1
 34e:	1682                	slli	a3,a3,0x20
 350:	9281                	srli	a3,a3,0x20
 352:	0685                	addi	a3,a3,1
 354:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 356:	00054783          	lbu	a5,0(a0)
 35a:	0005c703          	lbu	a4,0(a1)
 35e:	00e79863          	bne	a5,a4,36e <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 362:	0505                	addi	a0,a0,1
    p2++;
 364:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 366:	fed518e3          	bne	a0,a3,356 <memcmp+0x16>
  }
  return 0;
 36a:	4501                	li	a0,0
 36c:	a019                	j	372 <memcmp+0x32>
      return *p1 - *p2;
 36e:	40e7853b          	subw	a0,a5,a4
}
 372:	60a2                	ld	ra,8(sp)
 374:	6402                	ld	s0,0(sp)
 376:	0141                	addi	sp,sp,16
 378:	8082                	ret
  return 0;
 37a:	4501                	li	a0,0
 37c:	bfdd                	j	372 <memcmp+0x32>

000000000000037e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 37e:	1141                	addi	sp,sp,-16
 380:	e406                	sd	ra,8(sp)
 382:	e022                	sd	s0,0(sp)
 384:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 386:	00000097          	auipc	ra,0x0
 38a:	f5e080e7          	jalr	-162(ra) # 2e4 <memmove>
}
 38e:	60a2                	ld	ra,8(sp)
 390:	6402                	ld	s0,0(sp)
 392:	0141                	addi	sp,sp,16
 394:	8082                	ret

0000000000000396 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 396:	4885                	li	a7,1
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <exit>:
.global exit
exit:
 li a7, SYS_exit
 39e:	4889                	li	a7,2
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3a6:	488d                	li	a7,3
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3ae:	4891                	li	a7,4
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <read>:
.global read
read:
 li a7, SYS_read
 3b6:	4895                	li	a7,5
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <write>:
.global write
write:
 li a7, SYS_write
 3be:	48c1                	li	a7,16
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <close>:
.global close
close:
 li a7, SYS_close
 3c6:	48d5                	li	a7,21
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <kill>:
.global kill
kill:
 li a7, SYS_kill
 3ce:	4899                	li	a7,6
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3d6:	489d                	li	a7,7
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <open>:
.global open
open:
 li a7, SYS_open
 3de:	48bd                	li	a7,15
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3e6:	48c5                	li	a7,17
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3ee:	48c9                	li	a7,18
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3f6:	48a1                	li	a7,8
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <link>:
.global link
link:
 li a7, SYS_link
 3fe:	48cd                	li	a7,19
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 406:	48d1                	li	a7,20
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 40e:	48a5                	li	a7,9
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <dup>:
.global dup
dup:
 li a7, SYS_dup
 416:	48a9                	li	a7,10
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 41e:	48ad                	li	a7,11
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 426:	48b1                	li	a7,12
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 42e:	48b5                	li	a7,13
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 436:	48b9                	li	a7,14
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <ps>:
.global ps
ps:
 li a7, SYS_ps
 43e:	48d9                	li	a7,22
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
 446:	48dd                	li	a7,23
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
 44e:	48e1                	li	a7,24
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <va2pa>:
.global va2pa
va2pa:
 li a7, SYS_va2pa
 456:	48e9                	li	a7,26
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <pfreepages>:
.global pfreepages
pfreepages:
 li a7, SYS_pfreepages
 45e:	48e5                	li	a7,25
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 466:	1101                	addi	sp,sp,-32
 468:	ec06                	sd	ra,24(sp)
 46a:	e822                	sd	s0,16(sp)
 46c:	1000                	addi	s0,sp,32
 46e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 472:	4605                	li	a2,1
 474:	fef40593          	addi	a1,s0,-17
 478:	00000097          	auipc	ra,0x0
 47c:	f46080e7          	jalr	-186(ra) # 3be <write>
}
 480:	60e2                	ld	ra,24(sp)
 482:	6442                	ld	s0,16(sp)
 484:	6105                	addi	sp,sp,32
 486:	8082                	ret

0000000000000488 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 488:	7139                	addi	sp,sp,-64
 48a:	fc06                	sd	ra,56(sp)
 48c:	f822                	sd	s0,48(sp)
 48e:	f426                	sd	s1,40(sp)
 490:	f04a                	sd	s2,32(sp)
 492:	ec4e                	sd	s3,24(sp)
 494:	0080                	addi	s0,sp,64
 496:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 498:	c299                	beqz	a3,49e <printint+0x16>
 49a:	0805c063          	bltz	a1,51a <printint+0x92>
  neg = 0;
 49e:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 4a0:	fc040313          	addi	t1,s0,-64
  neg = 0;
 4a4:	869a                	mv	a3,t1
  i = 0;
 4a6:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 4a8:	00000817          	auipc	a6,0x0
 4ac:	4d880813          	addi	a6,a6,1240 # 980 <digits>
 4b0:	88be                	mv	a7,a5
 4b2:	0017851b          	addiw	a0,a5,1
 4b6:	87aa                	mv	a5,a0
 4b8:	02c5f73b          	remuw	a4,a1,a2
 4bc:	1702                	slli	a4,a4,0x20
 4be:	9301                	srli	a4,a4,0x20
 4c0:	9742                	add	a4,a4,a6
 4c2:	00074703          	lbu	a4,0(a4)
 4c6:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 4ca:	872e                	mv	a4,a1
 4cc:	02c5d5bb          	divuw	a1,a1,a2
 4d0:	0685                	addi	a3,a3,1
 4d2:	fcc77fe3          	bgeu	a4,a2,4b0 <printint+0x28>
  if(neg)
 4d6:	000e0c63          	beqz	t3,4ee <printint+0x66>
    buf[i++] = '-';
 4da:	fd050793          	addi	a5,a0,-48
 4de:	00878533          	add	a0,a5,s0
 4e2:	02d00793          	li	a5,45
 4e6:	fef50823          	sb	a5,-16(a0)
 4ea:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 4ee:	fff7899b          	addiw	s3,a5,-1
 4f2:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 4f6:	fff4c583          	lbu	a1,-1(s1)
 4fa:	854a                	mv	a0,s2
 4fc:	00000097          	auipc	ra,0x0
 500:	f6a080e7          	jalr	-150(ra) # 466 <putc>
  while(--i >= 0)
 504:	39fd                	addiw	s3,s3,-1
 506:	14fd                	addi	s1,s1,-1
 508:	fe09d7e3          	bgez	s3,4f6 <printint+0x6e>
}
 50c:	70e2                	ld	ra,56(sp)
 50e:	7442                	ld	s0,48(sp)
 510:	74a2                	ld	s1,40(sp)
 512:	7902                	ld	s2,32(sp)
 514:	69e2                	ld	s3,24(sp)
 516:	6121                	addi	sp,sp,64
 518:	8082                	ret
    x = -xx;
 51a:	40b005bb          	negw	a1,a1
    neg = 1;
 51e:	4e05                	li	t3,1
    x = -xx;
 520:	b741                	j	4a0 <printint+0x18>

0000000000000522 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 522:	715d                	addi	sp,sp,-80
 524:	e486                	sd	ra,72(sp)
 526:	e0a2                	sd	s0,64(sp)
 528:	f84a                	sd	s2,48(sp)
 52a:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 52c:	0005c903          	lbu	s2,0(a1)
 530:	1a090a63          	beqz	s2,6e4 <vprintf+0x1c2>
 534:	fc26                	sd	s1,56(sp)
 536:	f44e                	sd	s3,40(sp)
 538:	f052                	sd	s4,32(sp)
 53a:	ec56                	sd	s5,24(sp)
 53c:	e85a                	sd	s6,16(sp)
 53e:	e45e                	sd	s7,8(sp)
 540:	8aaa                	mv	s5,a0
 542:	8bb2                	mv	s7,a2
 544:	00158493          	addi	s1,a1,1
  state = 0;
 548:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 54a:	02500a13          	li	s4,37
 54e:	4b55                	li	s6,21
 550:	a839                	j	56e <vprintf+0x4c>
        putc(fd, c);
 552:	85ca                	mv	a1,s2
 554:	8556                	mv	a0,s5
 556:	00000097          	auipc	ra,0x0
 55a:	f10080e7          	jalr	-240(ra) # 466 <putc>
 55e:	a019                	j	564 <vprintf+0x42>
    } else if(state == '%'){
 560:	01498d63          	beq	s3,s4,57a <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 564:	0485                	addi	s1,s1,1
 566:	fff4c903          	lbu	s2,-1(s1)
 56a:	16090763          	beqz	s2,6d8 <vprintf+0x1b6>
    if(state == 0){
 56e:	fe0999e3          	bnez	s3,560 <vprintf+0x3e>
      if(c == '%'){
 572:	ff4910e3          	bne	s2,s4,552 <vprintf+0x30>
        state = '%';
 576:	89d2                	mv	s3,s4
 578:	b7f5                	j	564 <vprintf+0x42>
      if(c == 'd'){
 57a:	13490463          	beq	s2,s4,6a2 <vprintf+0x180>
 57e:	f9d9079b          	addiw	a5,s2,-99
 582:	0ff7f793          	zext.b	a5,a5
 586:	12fb6763          	bltu	s6,a5,6b4 <vprintf+0x192>
 58a:	f9d9079b          	addiw	a5,s2,-99
 58e:	0ff7f713          	zext.b	a4,a5
 592:	12eb6163          	bltu	s6,a4,6b4 <vprintf+0x192>
 596:	00271793          	slli	a5,a4,0x2
 59a:	00000717          	auipc	a4,0x0
 59e:	38e70713          	addi	a4,a4,910 # 928 <malloc+0x150>
 5a2:	97ba                	add	a5,a5,a4
 5a4:	439c                	lw	a5,0(a5)
 5a6:	97ba                	add	a5,a5,a4
 5a8:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5aa:	008b8913          	addi	s2,s7,8
 5ae:	4685                	li	a3,1
 5b0:	4629                	li	a2,10
 5b2:	000ba583          	lw	a1,0(s7)
 5b6:	8556                	mv	a0,s5
 5b8:	00000097          	auipc	ra,0x0
 5bc:	ed0080e7          	jalr	-304(ra) # 488 <printint>
 5c0:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5c2:	4981                	li	s3,0
 5c4:	b745                	j	564 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c6:	008b8913          	addi	s2,s7,8
 5ca:	4681                	li	a3,0
 5cc:	4629                	li	a2,10
 5ce:	000ba583          	lw	a1,0(s7)
 5d2:	8556                	mv	a0,s5
 5d4:	00000097          	auipc	ra,0x0
 5d8:	eb4080e7          	jalr	-332(ra) # 488 <printint>
 5dc:	8bca                	mv	s7,s2
      state = 0;
 5de:	4981                	li	s3,0
 5e0:	b751                	j	564 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5e2:	008b8913          	addi	s2,s7,8
 5e6:	4681                	li	a3,0
 5e8:	4641                	li	a2,16
 5ea:	000ba583          	lw	a1,0(s7)
 5ee:	8556                	mv	a0,s5
 5f0:	00000097          	auipc	ra,0x0
 5f4:	e98080e7          	jalr	-360(ra) # 488 <printint>
 5f8:	8bca                	mv	s7,s2
      state = 0;
 5fa:	4981                	li	s3,0
 5fc:	b7a5                	j	564 <vprintf+0x42>
 5fe:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 600:	008b8c13          	addi	s8,s7,8
 604:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 608:	03000593          	li	a1,48
 60c:	8556                	mv	a0,s5
 60e:	00000097          	auipc	ra,0x0
 612:	e58080e7          	jalr	-424(ra) # 466 <putc>
  putc(fd, 'x');
 616:	07800593          	li	a1,120
 61a:	8556                	mv	a0,s5
 61c:	00000097          	auipc	ra,0x0
 620:	e4a080e7          	jalr	-438(ra) # 466 <putc>
 624:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 626:	00000b97          	auipc	s7,0x0
 62a:	35ab8b93          	addi	s7,s7,858 # 980 <digits>
 62e:	03c9d793          	srli	a5,s3,0x3c
 632:	97de                	add	a5,a5,s7
 634:	0007c583          	lbu	a1,0(a5)
 638:	8556                	mv	a0,s5
 63a:	00000097          	auipc	ra,0x0
 63e:	e2c080e7          	jalr	-468(ra) # 466 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 642:	0992                	slli	s3,s3,0x4
 644:	397d                	addiw	s2,s2,-1
 646:	fe0914e3          	bnez	s2,62e <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 64a:	8be2                	mv	s7,s8
      state = 0;
 64c:	4981                	li	s3,0
 64e:	6c02                	ld	s8,0(sp)
 650:	bf11                	j	564 <vprintf+0x42>
        s = va_arg(ap, char*);
 652:	008b8993          	addi	s3,s7,8
 656:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 65a:	02090163          	beqz	s2,67c <vprintf+0x15a>
        while(*s != 0){
 65e:	00094583          	lbu	a1,0(s2)
 662:	c9a5                	beqz	a1,6d2 <vprintf+0x1b0>
          putc(fd, *s);
 664:	8556                	mv	a0,s5
 666:	00000097          	auipc	ra,0x0
 66a:	e00080e7          	jalr	-512(ra) # 466 <putc>
          s++;
 66e:	0905                	addi	s2,s2,1
        while(*s != 0){
 670:	00094583          	lbu	a1,0(s2)
 674:	f9e5                	bnez	a1,664 <vprintf+0x142>
        s = va_arg(ap, char*);
 676:	8bce                	mv	s7,s3
      state = 0;
 678:	4981                	li	s3,0
 67a:	b5ed                	j	564 <vprintf+0x42>
          s = "(null)";
 67c:	00000917          	auipc	s2,0x0
 680:	2a490913          	addi	s2,s2,676 # 920 <malloc+0x148>
        while(*s != 0){
 684:	02800593          	li	a1,40
 688:	bff1                	j	664 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 68a:	008b8913          	addi	s2,s7,8
 68e:	000bc583          	lbu	a1,0(s7)
 692:	8556                	mv	a0,s5
 694:	00000097          	auipc	ra,0x0
 698:	dd2080e7          	jalr	-558(ra) # 466 <putc>
 69c:	8bca                	mv	s7,s2
      state = 0;
 69e:	4981                	li	s3,0
 6a0:	b5d1                	j	564 <vprintf+0x42>
        putc(fd, c);
 6a2:	02500593          	li	a1,37
 6a6:	8556                	mv	a0,s5
 6a8:	00000097          	auipc	ra,0x0
 6ac:	dbe080e7          	jalr	-578(ra) # 466 <putc>
      state = 0;
 6b0:	4981                	li	s3,0
 6b2:	bd4d                	j	564 <vprintf+0x42>
        putc(fd, '%');
 6b4:	02500593          	li	a1,37
 6b8:	8556                	mv	a0,s5
 6ba:	00000097          	auipc	ra,0x0
 6be:	dac080e7          	jalr	-596(ra) # 466 <putc>
        putc(fd, c);
 6c2:	85ca                	mv	a1,s2
 6c4:	8556                	mv	a0,s5
 6c6:	00000097          	auipc	ra,0x0
 6ca:	da0080e7          	jalr	-608(ra) # 466 <putc>
      state = 0;
 6ce:	4981                	li	s3,0
 6d0:	bd51                	j	564 <vprintf+0x42>
        s = va_arg(ap, char*);
 6d2:	8bce                	mv	s7,s3
      state = 0;
 6d4:	4981                	li	s3,0
 6d6:	b579                	j	564 <vprintf+0x42>
 6d8:	74e2                	ld	s1,56(sp)
 6da:	79a2                	ld	s3,40(sp)
 6dc:	7a02                	ld	s4,32(sp)
 6de:	6ae2                	ld	s5,24(sp)
 6e0:	6b42                	ld	s6,16(sp)
 6e2:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6e4:	60a6                	ld	ra,72(sp)
 6e6:	6406                	ld	s0,64(sp)
 6e8:	7942                	ld	s2,48(sp)
 6ea:	6161                	addi	sp,sp,80
 6ec:	8082                	ret

00000000000006ee <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6ee:	715d                	addi	sp,sp,-80
 6f0:	ec06                	sd	ra,24(sp)
 6f2:	e822                	sd	s0,16(sp)
 6f4:	1000                	addi	s0,sp,32
 6f6:	e010                	sd	a2,0(s0)
 6f8:	e414                	sd	a3,8(s0)
 6fa:	e818                	sd	a4,16(s0)
 6fc:	ec1c                	sd	a5,24(s0)
 6fe:	03043023          	sd	a6,32(s0)
 702:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 706:	8622                	mv	a2,s0
 708:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 70c:	00000097          	auipc	ra,0x0
 710:	e16080e7          	jalr	-490(ra) # 522 <vprintf>
}
 714:	60e2                	ld	ra,24(sp)
 716:	6442                	ld	s0,16(sp)
 718:	6161                	addi	sp,sp,80
 71a:	8082                	ret

000000000000071c <printf>:

void
printf(const char *fmt, ...)
{
 71c:	711d                	addi	sp,sp,-96
 71e:	ec06                	sd	ra,24(sp)
 720:	e822                	sd	s0,16(sp)
 722:	1000                	addi	s0,sp,32
 724:	e40c                	sd	a1,8(s0)
 726:	e810                	sd	a2,16(s0)
 728:	ec14                	sd	a3,24(s0)
 72a:	f018                	sd	a4,32(s0)
 72c:	f41c                	sd	a5,40(s0)
 72e:	03043823          	sd	a6,48(s0)
 732:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 736:	00840613          	addi	a2,s0,8
 73a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 73e:	85aa                	mv	a1,a0
 740:	4505                	li	a0,1
 742:	00000097          	auipc	ra,0x0
 746:	de0080e7          	jalr	-544(ra) # 522 <vprintf>
}
 74a:	60e2                	ld	ra,24(sp)
 74c:	6442                	ld	s0,16(sp)
 74e:	6125                	addi	sp,sp,96
 750:	8082                	ret

0000000000000752 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 752:	1141                	addi	sp,sp,-16
 754:	e406                	sd	ra,8(sp)
 756:	e022                	sd	s0,0(sp)
 758:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 75a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75e:	00001797          	auipc	a5,0x1
 762:	8a27b783          	ld	a5,-1886(a5) # 1000 <freep>
 766:	a02d                	j	790 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 768:	4618                	lw	a4,8(a2)
 76a:	9f2d                	addw	a4,a4,a1
 76c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 770:	6398                	ld	a4,0(a5)
 772:	6310                	ld	a2,0(a4)
 774:	a83d                	j	7b2 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 776:	ff852703          	lw	a4,-8(a0)
 77a:	9f31                	addw	a4,a4,a2
 77c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 77e:	ff053683          	ld	a3,-16(a0)
 782:	a091                	j	7c6 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 784:	6398                	ld	a4,0(a5)
 786:	00e7e463          	bltu	a5,a4,78e <free+0x3c>
 78a:	00e6ea63          	bltu	a3,a4,79e <free+0x4c>
{
 78e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 790:	fed7fae3          	bgeu	a5,a3,784 <free+0x32>
 794:	6398                	ld	a4,0(a5)
 796:	00e6e463          	bltu	a3,a4,79e <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79a:	fee7eae3          	bltu	a5,a4,78e <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 79e:	ff852583          	lw	a1,-8(a0)
 7a2:	6390                	ld	a2,0(a5)
 7a4:	02059813          	slli	a6,a1,0x20
 7a8:	01c85713          	srli	a4,a6,0x1c
 7ac:	9736                	add	a4,a4,a3
 7ae:	fae60de3          	beq	a2,a4,768 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 7b2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7b6:	4790                	lw	a2,8(a5)
 7b8:	02061593          	slli	a1,a2,0x20
 7bc:	01c5d713          	srli	a4,a1,0x1c
 7c0:	973e                	add	a4,a4,a5
 7c2:	fae68ae3          	beq	a3,a4,776 <free+0x24>
    p->s.ptr = bp->s.ptr;
 7c6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7c8:	00001717          	auipc	a4,0x1
 7cc:	82f73c23          	sd	a5,-1992(a4) # 1000 <freep>
}
 7d0:	60a2                	ld	ra,8(sp)
 7d2:	6402                	ld	s0,0(sp)
 7d4:	0141                	addi	sp,sp,16
 7d6:	8082                	ret

00000000000007d8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7d8:	7139                	addi	sp,sp,-64
 7da:	fc06                	sd	ra,56(sp)
 7dc:	f822                	sd	s0,48(sp)
 7de:	f04a                	sd	s2,32(sp)
 7e0:	ec4e                	sd	s3,24(sp)
 7e2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e4:	02051993          	slli	s3,a0,0x20
 7e8:	0209d993          	srli	s3,s3,0x20
 7ec:	09bd                	addi	s3,s3,15
 7ee:	0049d993          	srli	s3,s3,0x4
 7f2:	2985                	addiw	s3,s3,1
 7f4:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7f6:	00001517          	auipc	a0,0x1
 7fa:	80a53503          	ld	a0,-2038(a0) # 1000 <freep>
 7fe:	c905                	beqz	a0,82e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 800:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 802:	4798                	lw	a4,8(a5)
 804:	09377a63          	bgeu	a4,s3,898 <malloc+0xc0>
 808:	f426                	sd	s1,40(sp)
 80a:	e852                	sd	s4,16(sp)
 80c:	e456                	sd	s5,8(sp)
 80e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 810:	8a4e                	mv	s4,s3
 812:	6705                	lui	a4,0x1
 814:	00e9f363          	bgeu	s3,a4,81a <malloc+0x42>
 818:	6a05                	lui	s4,0x1
 81a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 81e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 822:	00000497          	auipc	s1,0x0
 826:	7de48493          	addi	s1,s1,2014 # 1000 <freep>
  if(p == (char*)-1)
 82a:	5afd                	li	s5,-1
 82c:	a089                	j	86e <malloc+0x96>
 82e:	f426                	sd	s1,40(sp)
 830:	e852                	sd	s4,16(sp)
 832:	e456                	sd	s5,8(sp)
 834:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 836:	00000797          	auipc	a5,0x0
 83a:	7da78793          	addi	a5,a5,2010 # 1010 <base>
 83e:	00000717          	auipc	a4,0x0
 842:	7cf73123          	sd	a5,1986(a4) # 1000 <freep>
 846:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 848:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 84c:	b7d1                	j	810 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 84e:	6398                	ld	a4,0(a5)
 850:	e118                	sd	a4,0(a0)
 852:	a8b9                	j	8b0 <malloc+0xd8>
  hp->s.size = nu;
 854:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 858:	0541                	addi	a0,a0,16
 85a:	00000097          	auipc	ra,0x0
 85e:	ef8080e7          	jalr	-264(ra) # 752 <free>
  return freep;
 862:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 864:	c135                	beqz	a0,8c8 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 866:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 868:	4798                	lw	a4,8(a5)
 86a:	03277363          	bgeu	a4,s2,890 <malloc+0xb8>
    if(p == freep)
 86e:	6098                	ld	a4,0(s1)
 870:	853e                	mv	a0,a5
 872:	fef71ae3          	bne	a4,a5,866 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 876:	8552                	mv	a0,s4
 878:	00000097          	auipc	ra,0x0
 87c:	bae080e7          	jalr	-1106(ra) # 426 <sbrk>
  if(p == (char*)-1)
 880:	fd551ae3          	bne	a0,s5,854 <malloc+0x7c>
        return 0;
 884:	4501                	li	a0,0
 886:	74a2                	ld	s1,40(sp)
 888:	6a42                	ld	s4,16(sp)
 88a:	6aa2                	ld	s5,8(sp)
 88c:	6b02                	ld	s6,0(sp)
 88e:	a03d                	j	8bc <malloc+0xe4>
 890:	74a2                	ld	s1,40(sp)
 892:	6a42                	ld	s4,16(sp)
 894:	6aa2                	ld	s5,8(sp)
 896:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 898:	fae90be3          	beq	s2,a4,84e <malloc+0x76>
        p->s.size -= nunits;
 89c:	4137073b          	subw	a4,a4,s3
 8a0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8a2:	02071693          	slli	a3,a4,0x20
 8a6:	01c6d713          	srli	a4,a3,0x1c
 8aa:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8ac:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8b0:	00000717          	auipc	a4,0x0
 8b4:	74a73823          	sd	a0,1872(a4) # 1000 <freep>
      return (void*)(p + 1);
 8b8:	01078513          	addi	a0,a5,16
  }
}
 8bc:	70e2                	ld	ra,56(sp)
 8be:	7442                	ld	s0,48(sp)
 8c0:	7902                	ld	s2,32(sp)
 8c2:	69e2                	ld	s3,24(sp)
 8c4:	6121                	addi	sp,sp,64
 8c6:	8082                	ret
 8c8:	74a2                	ld	s1,40(sp)
 8ca:	6a42                	ld	s4,16(sp)
 8cc:	6aa2                	ld	s5,8(sp)
 8ce:	6b02                	ld	s6,0(sp)
 8d0:	b7f5                	j	8bc <malloc+0xe4>
