
user/_congen:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print>:
#include "user/user.h"

#define N 32

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
  10:	144080e7          	jalr	324(ra) # 150 <strlen>
  14:	862a                	mv	a2,a0
  16:	85a6                	mv	a1,s1
  18:	4505                	li	a0,1
  1a:	00000097          	auipc	ra,0x0
  1e:	3a6080e7          	jalr	934(ra) # 3c0 <write>
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
  44:	89050513          	addi	a0,a0,-1904 # 8d0 <malloc+0xfe>
  48:	00000097          	auipc	ra,0x0
  4c:	fb8080e7          	jalr	-72(ra) # 0 <print>

    for (n = 0; n < N; n++)
  50:	4981                	li	s3,0
  52:	02000493          	li	s1,32
    {
        pid = fork();
  56:	00000097          	auipc	ra,0x0
  5a:	342080e7          	jalr	834(ra) # 398 <fork>
  5e:	892a                	mv	s2,a0
        if (pid < 0)
            break;
        if (pid == 0)
  60:	00a05563          	blez	a0,6a <forktest+0x3e>
    for (n = 0; n < N; n++)
  64:	2985                	addiw	s3,s3,1
  66:	fe9998e3          	bne	s3,s1,56 <forktest+0x2a>
            break;
    }

    for (unsigned long long i = 0; i < 50; i++)
  6a:	4481                	li	s1,0
        {
            printf("CHILD %d: %d\n", n, i);
        }
        else
        {
            printf("PARENT: %d\n", i);
  6c:	00001b17          	auipc	s6,0x1
  70:	884b0b13          	addi	s6,s6,-1916 # 8f0 <malloc+0x11e>
            printf("CHILD %d: %d\n", n, i);
  74:	00001a97          	auipc	s5,0x1
  78:	86ca8a93          	addi	s5,s5,-1940 # 8e0 <malloc+0x10e>
    for (unsigned long long i = 0; i < 50; i++)
  7c:	03200a13          	li	s4,50
  80:	a811                	j	94 <forktest+0x68>
            printf("PARENT: %d\n", i);
  82:	85a6                	mv	a1,s1
  84:	855a                	mv	a0,s6
  86:	00000097          	auipc	ra,0x0
  8a:	690080e7          	jalr	1680(ra) # 716 <printf>
    for (unsigned long long i = 0; i < 50; i++)
  8e:	0485                	addi	s1,s1,1
  90:	01448c63          	beq	s1,s4,a8 <forktest+0x7c>
        if (pid == 0)
  94:	fe0917e3          	bnez	s2,82 <forktest+0x56>
            printf("CHILD %d: %d\n", n, i);
  98:	8626                	mv	a2,s1
  9a:	85ce                	mv	a1,s3
  9c:	8556                	mv	a0,s5
  9e:	00000097          	auipc	ra,0x0
  a2:	678080e7          	jalr	1656(ra) # 716 <printf>
  a6:	b7e5                	j	8e <forktest+0x62>
        }
    }

    print("fork test OK\n");
  a8:	00001517          	auipc	a0,0x1
  ac:	85850513          	addi	a0,a0,-1960 # 900 <malloc+0x12e>
  b0:	00000097          	auipc	ra,0x0
  b4:	f50080e7          	jalr	-176(ra) # 0 <print>
}
  b8:	70e2                	ld	ra,56(sp)
  ba:	7442                	ld	s0,48(sp)
  bc:	74a2                	ld	s1,40(sp)
  be:	7902                	ld	s2,32(sp)
  c0:	69e2                	ld	s3,24(sp)
  c2:	6a42                	ld	s4,16(sp)
  c4:	6aa2                	ld	s5,8(sp)
  c6:	6b02                	ld	s6,0(sp)
  c8:	6121                	addi	sp,sp,64
  ca:	8082                	ret

00000000000000cc <main>:

int main(void)
{
  cc:	1141                	addi	sp,sp,-16
  ce:	e406                	sd	ra,8(sp)
  d0:	e022                	sd	s0,0(sp)
  d2:	0800                	addi	s0,sp,16
    forktest();
  d4:	00000097          	auipc	ra,0x0
  d8:	f58080e7          	jalr	-168(ra) # 2c <forktest>
    exit(0);
  dc:	4501                	li	a0,0
  de:	00000097          	auipc	ra,0x0
  e2:	2c2080e7          	jalr	706(ra) # 3a0 <exit>

00000000000000e6 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  e6:	1141                	addi	sp,sp,-16
  e8:	e406                	sd	ra,8(sp)
  ea:	e022                	sd	s0,0(sp)
  ec:	0800                	addi	s0,sp,16
  extern int main();
  main();
  ee:	00000097          	auipc	ra,0x0
  f2:	fde080e7          	jalr	-34(ra) # cc <main>
  exit(0);
  f6:	4501                	li	a0,0
  f8:	00000097          	auipc	ra,0x0
  fc:	2a8080e7          	jalr	680(ra) # 3a0 <exit>

0000000000000100 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 100:	1141                	addi	sp,sp,-16
 102:	e406                	sd	ra,8(sp)
 104:	e022                	sd	s0,0(sp)
 106:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 108:	87aa                	mv	a5,a0
 10a:	0585                	addi	a1,a1,1
 10c:	0785                	addi	a5,a5,1
 10e:	fff5c703          	lbu	a4,-1(a1)
 112:	fee78fa3          	sb	a4,-1(a5)
 116:	fb75                	bnez	a4,10a <strcpy+0xa>
    ;
  return os;
}
 118:	60a2                	ld	ra,8(sp)
 11a:	6402                	ld	s0,0(sp)
 11c:	0141                	addi	sp,sp,16
 11e:	8082                	ret

0000000000000120 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 120:	1141                	addi	sp,sp,-16
 122:	e406                	sd	ra,8(sp)
 124:	e022                	sd	s0,0(sp)
 126:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 128:	00054783          	lbu	a5,0(a0)
 12c:	cb91                	beqz	a5,140 <strcmp+0x20>
 12e:	0005c703          	lbu	a4,0(a1)
 132:	00f71763          	bne	a4,a5,140 <strcmp+0x20>
    p++, q++;
 136:	0505                	addi	a0,a0,1
 138:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 13a:	00054783          	lbu	a5,0(a0)
 13e:	fbe5                	bnez	a5,12e <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 140:	0005c503          	lbu	a0,0(a1)
}
 144:	40a7853b          	subw	a0,a5,a0
 148:	60a2                	ld	ra,8(sp)
 14a:	6402                	ld	s0,0(sp)
 14c:	0141                	addi	sp,sp,16
 14e:	8082                	ret

0000000000000150 <strlen>:

uint
strlen(const char *s)
{
 150:	1141                	addi	sp,sp,-16
 152:	e406                	sd	ra,8(sp)
 154:	e022                	sd	s0,0(sp)
 156:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 158:	00054783          	lbu	a5,0(a0)
 15c:	cf99                	beqz	a5,17a <strlen+0x2a>
 15e:	0505                	addi	a0,a0,1
 160:	87aa                	mv	a5,a0
 162:	86be                	mv	a3,a5
 164:	0785                	addi	a5,a5,1
 166:	fff7c703          	lbu	a4,-1(a5)
 16a:	ff65                	bnez	a4,162 <strlen+0x12>
 16c:	40a6853b          	subw	a0,a3,a0
 170:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 172:	60a2                	ld	ra,8(sp)
 174:	6402                	ld	s0,0(sp)
 176:	0141                	addi	sp,sp,16
 178:	8082                	ret
  for(n = 0; s[n]; n++)
 17a:	4501                	li	a0,0
 17c:	bfdd                	j	172 <strlen+0x22>

000000000000017e <memset>:

void*
memset(void *dst, int c, uint n)
{
 17e:	1141                	addi	sp,sp,-16
 180:	e406                	sd	ra,8(sp)
 182:	e022                	sd	s0,0(sp)
 184:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 186:	ca19                	beqz	a2,19c <memset+0x1e>
 188:	87aa                	mv	a5,a0
 18a:	1602                	slli	a2,a2,0x20
 18c:	9201                	srli	a2,a2,0x20
 18e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 192:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 196:	0785                	addi	a5,a5,1
 198:	fee79de3          	bne	a5,a4,192 <memset+0x14>
  }
  return dst;
}
 19c:	60a2                	ld	ra,8(sp)
 19e:	6402                	ld	s0,0(sp)
 1a0:	0141                	addi	sp,sp,16
 1a2:	8082                	ret

00000000000001a4 <strchr>:

char*
strchr(const char *s, char c)
{
 1a4:	1141                	addi	sp,sp,-16
 1a6:	e406                	sd	ra,8(sp)
 1a8:	e022                	sd	s0,0(sp)
 1aa:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1ac:	00054783          	lbu	a5,0(a0)
 1b0:	cf81                	beqz	a5,1c8 <strchr+0x24>
    if(*s == c)
 1b2:	00f58763          	beq	a1,a5,1c0 <strchr+0x1c>
  for(; *s; s++)
 1b6:	0505                	addi	a0,a0,1
 1b8:	00054783          	lbu	a5,0(a0)
 1bc:	fbfd                	bnez	a5,1b2 <strchr+0xe>
      return (char*)s;
  return 0;
 1be:	4501                	li	a0,0
}
 1c0:	60a2                	ld	ra,8(sp)
 1c2:	6402                	ld	s0,0(sp)
 1c4:	0141                	addi	sp,sp,16
 1c6:	8082                	ret
  return 0;
 1c8:	4501                	li	a0,0
 1ca:	bfdd                	j	1c0 <strchr+0x1c>

00000000000001cc <gets>:

char*
gets(char *buf, int max)
{
 1cc:	7159                	addi	sp,sp,-112
 1ce:	f486                	sd	ra,104(sp)
 1d0:	f0a2                	sd	s0,96(sp)
 1d2:	eca6                	sd	s1,88(sp)
 1d4:	e8ca                	sd	s2,80(sp)
 1d6:	e4ce                	sd	s3,72(sp)
 1d8:	e0d2                	sd	s4,64(sp)
 1da:	fc56                	sd	s5,56(sp)
 1dc:	f85a                	sd	s6,48(sp)
 1de:	f45e                	sd	s7,40(sp)
 1e0:	f062                	sd	s8,32(sp)
 1e2:	ec66                	sd	s9,24(sp)
 1e4:	e86a                	sd	s10,16(sp)
 1e6:	1880                	addi	s0,sp,112
 1e8:	8caa                	mv	s9,a0
 1ea:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ec:	892a                	mv	s2,a0
 1ee:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1f0:	f9f40b13          	addi	s6,s0,-97
 1f4:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1f6:	4ba9                	li	s7,10
 1f8:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 1fa:	8d26                	mv	s10,s1
 1fc:	0014899b          	addiw	s3,s1,1
 200:	84ce                	mv	s1,s3
 202:	0349d763          	bge	s3,s4,230 <gets+0x64>
    cc = read(0, &c, 1);
 206:	8656                	mv	a2,s5
 208:	85da                	mv	a1,s6
 20a:	4501                	li	a0,0
 20c:	00000097          	auipc	ra,0x0
 210:	1ac080e7          	jalr	428(ra) # 3b8 <read>
    if(cc < 1)
 214:	00a05e63          	blez	a0,230 <gets+0x64>
    buf[i++] = c;
 218:	f9f44783          	lbu	a5,-97(s0)
 21c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 220:	01778763          	beq	a5,s7,22e <gets+0x62>
 224:	0905                	addi	s2,s2,1
 226:	fd879ae3          	bne	a5,s8,1fa <gets+0x2e>
    buf[i++] = c;
 22a:	8d4e                	mv	s10,s3
 22c:	a011                	j	230 <gets+0x64>
 22e:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 230:	9d66                	add	s10,s10,s9
 232:	000d0023          	sb	zero,0(s10)
  return buf;
}
 236:	8566                	mv	a0,s9
 238:	70a6                	ld	ra,104(sp)
 23a:	7406                	ld	s0,96(sp)
 23c:	64e6                	ld	s1,88(sp)
 23e:	6946                	ld	s2,80(sp)
 240:	69a6                	ld	s3,72(sp)
 242:	6a06                	ld	s4,64(sp)
 244:	7ae2                	ld	s5,56(sp)
 246:	7b42                	ld	s6,48(sp)
 248:	7ba2                	ld	s7,40(sp)
 24a:	7c02                	ld	s8,32(sp)
 24c:	6ce2                	ld	s9,24(sp)
 24e:	6d42                	ld	s10,16(sp)
 250:	6165                	addi	sp,sp,112
 252:	8082                	ret

0000000000000254 <stat>:

int
stat(const char *n, struct stat *st)
{
 254:	1101                	addi	sp,sp,-32
 256:	ec06                	sd	ra,24(sp)
 258:	e822                	sd	s0,16(sp)
 25a:	e04a                	sd	s2,0(sp)
 25c:	1000                	addi	s0,sp,32
 25e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 260:	4581                	li	a1,0
 262:	00000097          	auipc	ra,0x0
 266:	17e080e7          	jalr	382(ra) # 3e0 <open>
  if(fd < 0)
 26a:	02054663          	bltz	a0,296 <stat+0x42>
 26e:	e426                	sd	s1,8(sp)
 270:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 272:	85ca                	mv	a1,s2
 274:	00000097          	auipc	ra,0x0
 278:	184080e7          	jalr	388(ra) # 3f8 <fstat>
 27c:	892a                	mv	s2,a0
  close(fd);
 27e:	8526                	mv	a0,s1
 280:	00000097          	auipc	ra,0x0
 284:	148080e7          	jalr	328(ra) # 3c8 <close>
  return r;
 288:	64a2                	ld	s1,8(sp)
}
 28a:	854a                	mv	a0,s2
 28c:	60e2                	ld	ra,24(sp)
 28e:	6442                	ld	s0,16(sp)
 290:	6902                	ld	s2,0(sp)
 292:	6105                	addi	sp,sp,32
 294:	8082                	ret
    return -1;
 296:	597d                	li	s2,-1
 298:	bfcd                	j	28a <stat+0x36>

000000000000029a <atoi>:

int
atoi(const char *s)
{
 29a:	1141                	addi	sp,sp,-16
 29c:	e406                	sd	ra,8(sp)
 29e:	e022                	sd	s0,0(sp)
 2a0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2a2:	00054683          	lbu	a3,0(a0)
 2a6:	fd06879b          	addiw	a5,a3,-48
 2aa:	0ff7f793          	zext.b	a5,a5
 2ae:	4625                	li	a2,9
 2b0:	02f66963          	bltu	a2,a5,2e2 <atoi+0x48>
 2b4:	872a                	mv	a4,a0
  n = 0;
 2b6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2b8:	0705                	addi	a4,a4,1
 2ba:	0025179b          	slliw	a5,a0,0x2
 2be:	9fa9                	addw	a5,a5,a0
 2c0:	0017979b          	slliw	a5,a5,0x1
 2c4:	9fb5                	addw	a5,a5,a3
 2c6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2ca:	00074683          	lbu	a3,0(a4)
 2ce:	fd06879b          	addiw	a5,a3,-48
 2d2:	0ff7f793          	zext.b	a5,a5
 2d6:	fef671e3          	bgeu	a2,a5,2b8 <atoi+0x1e>
  return n;
}
 2da:	60a2                	ld	ra,8(sp)
 2dc:	6402                	ld	s0,0(sp)
 2de:	0141                	addi	sp,sp,16
 2e0:	8082                	ret
  n = 0;
 2e2:	4501                	li	a0,0
 2e4:	bfdd                	j	2da <atoi+0x40>

00000000000002e6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2e6:	1141                	addi	sp,sp,-16
 2e8:	e406                	sd	ra,8(sp)
 2ea:	e022                	sd	s0,0(sp)
 2ec:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2ee:	02b57563          	bgeu	a0,a1,318 <memmove+0x32>
    while(n-- > 0)
 2f2:	00c05f63          	blez	a2,310 <memmove+0x2a>
 2f6:	1602                	slli	a2,a2,0x20
 2f8:	9201                	srli	a2,a2,0x20
 2fa:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2fe:	872a                	mv	a4,a0
      *dst++ = *src++;
 300:	0585                	addi	a1,a1,1
 302:	0705                	addi	a4,a4,1
 304:	fff5c683          	lbu	a3,-1(a1)
 308:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 30c:	fee79ae3          	bne	a5,a4,300 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 310:	60a2                	ld	ra,8(sp)
 312:	6402                	ld	s0,0(sp)
 314:	0141                	addi	sp,sp,16
 316:	8082                	ret
    dst += n;
 318:	00c50733          	add	a4,a0,a2
    src += n;
 31c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 31e:	fec059e3          	blez	a2,310 <memmove+0x2a>
 322:	fff6079b          	addiw	a5,a2,-1
 326:	1782                	slli	a5,a5,0x20
 328:	9381                	srli	a5,a5,0x20
 32a:	fff7c793          	not	a5,a5
 32e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 330:	15fd                	addi	a1,a1,-1
 332:	177d                	addi	a4,a4,-1
 334:	0005c683          	lbu	a3,0(a1)
 338:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 33c:	fef71ae3          	bne	a4,a5,330 <memmove+0x4a>
 340:	bfc1                	j	310 <memmove+0x2a>

0000000000000342 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 342:	1141                	addi	sp,sp,-16
 344:	e406                	sd	ra,8(sp)
 346:	e022                	sd	s0,0(sp)
 348:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 34a:	ca0d                	beqz	a2,37c <memcmp+0x3a>
 34c:	fff6069b          	addiw	a3,a2,-1
 350:	1682                	slli	a3,a3,0x20
 352:	9281                	srli	a3,a3,0x20
 354:	0685                	addi	a3,a3,1
 356:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 358:	00054783          	lbu	a5,0(a0)
 35c:	0005c703          	lbu	a4,0(a1)
 360:	00e79863          	bne	a5,a4,370 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 364:	0505                	addi	a0,a0,1
    p2++;
 366:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 368:	fed518e3          	bne	a0,a3,358 <memcmp+0x16>
  }
  return 0;
 36c:	4501                	li	a0,0
 36e:	a019                	j	374 <memcmp+0x32>
      return *p1 - *p2;
 370:	40e7853b          	subw	a0,a5,a4
}
 374:	60a2                	ld	ra,8(sp)
 376:	6402                	ld	s0,0(sp)
 378:	0141                	addi	sp,sp,16
 37a:	8082                	ret
  return 0;
 37c:	4501                	li	a0,0
 37e:	bfdd                	j	374 <memcmp+0x32>

0000000000000380 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 380:	1141                	addi	sp,sp,-16
 382:	e406                	sd	ra,8(sp)
 384:	e022                	sd	s0,0(sp)
 386:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 388:	00000097          	auipc	ra,0x0
 38c:	f5e080e7          	jalr	-162(ra) # 2e6 <memmove>
}
 390:	60a2                	ld	ra,8(sp)
 392:	6402                	ld	s0,0(sp)
 394:	0141                	addi	sp,sp,16
 396:	8082                	ret

0000000000000398 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 398:	4885                	li	a7,1
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3a0:	4889                	li	a7,2
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3a8:	488d                	li	a7,3
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3b0:	4891                	li	a7,4
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <read>:
.global read
read:
 li a7, SYS_read
 3b8:	4895                	li	a7,5
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <write>:
.global write
write:
 li a7, SYS_write
 3c0:	48c1                	li	a7,16
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <close>:
.global close
close:
 li a7, SYS_close
 3c8:	48d5                	li	a7,21
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3d0:	4899                	li	a7,6
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3d8:	489d                	li	a7,7
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <open>:
.global open
open:
 li a7, SYS_open
 3e0:	48bd                	li	a7,15
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3e8:	48c5                	li	a7,17
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3f0:	48c9                	li	a7,18
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3f8:	48a1                	li	a7,8
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <link>:
.global link
link:
 li a7, SYS_link
 400:	48cd                	li	a7,19
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 408:	48d1                	li	a7,20
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 410:	48a5                	li	a7,9
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <dup>:
.global dup
dup:
 li a7, SYS_dup
 418:	48a9                	li	a7,10
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 420:	48ad                	li	a7,11
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 428:	48b1                	li	a7,12
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 430:	48b5                	li	a7,13
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 438:	48b9                	li	a7,14
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <ps>:
.global ps
ps:
 li a7, SYS_ps
 440:	48d9                	li	a7,22
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
 448:	48dd                	li	a7,23
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
 450:	48e1                	li	a7,24
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <yield>:
.global yield
yield:
 li a7, SYS_yield
 458:	48e5                	li	a7,25
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 460:	1101                	addi	sp,sp,-32
 462:	ec06                	sd	ra,24(sp)
 464:	e822                	sd	s0,16(sp)
 466:	1000                	addi	s0,sp,32
 468:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 46c:	4605                	li	a2,1
 46e:	fef40593          	addi	a1,s0,-17
 472:	00000097          	auipc	ra,0x0
 476:	f4e080e7          	jalr	-178(ra) # 3c0 <write>
}
 47a:	60e2                	ld	ra,24(sp)
 47c:	6442                	ld	s0,16(sp)
 47e:	6105                	addi	sp,sp,32
 480:	8082                	ret

0000000000000482 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 482:	7139                	addi	sp,sp,-64
 484:	fc06                	sd	ra,56(sp)
 486:	f822                	sd	s0,48(sp)
 488:	f426                	sd	s1,40(sp)
 48a:	f04a                	sd	s2,32(sp)
 48c:	ec4e                	sd	s3,24(sp)
 48e:	0080                	addi	s0,sp,64
 490:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 492:	c299                	beqz	a3,498 <printint+0x16>
 494:	0805c063          	bltz	a1,514 <printint+0x92>
  neg = 0;
 498:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 49a:	fc040313          	addi	t1,s0,-64
  neg = 0;
 49e:	869a                	mv	a3,t1
  i = 0;
 4a0:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 4a2:	00000817          	auipc	a6,0x0
 4a6:	4ce80813          	addi	a6,a6,1230 # 970 <digits>
 4aa:	88be                	mv	a7,a5
 4ac:	0017851b          	addiw	a0,a5,1
 4b0:	87aa                	mv	a5,a0
 4b2:	02c5f73b          	remuw	a4,a1,a2
 4b6:	1702                	slli	a4,a4,0x20
 4b8:	9301                	srli	a4,a4,0x20
 4ba:	9742                	add	a4,a4,a6
 4bc:	00074703          	lbu	a4,0(a4)
 4c0:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 4c4:	872e                	mv	a4,a1
 4c6:	02c5d5bb          	divuw	a1,a1,a2
 4ca:	0685                	addi	a3,a3,1
 4cc:	fcc77fe3          	bgeu	a4,a2,4aa <printint+0x28>
  if(neg)
 4d0:	000e0c63          	beqz	t3,4e8 <printint+0x66>
    buf[i++] = '-';
 4d4:	fd050793          	addi	a5,a0,-48
 4d8:	00878533          	add	a0,a5,s0
 4dc:	02d00793          	li	a5,45
 4e0:	fef50823          	sb	a5,-16(a0)
 4e4:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 4e8:	fff7899b          	addiw	s3,a5,-1
 4ec:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 4f0:	fff4c583          	lbu	a1,-1(s1)
 4f4:	854a                	mv	a0,s2
 4f6:	00000097          	auipc	ra,0x0
 4fa:	f6a080e7          	jalr	-150(ra) # 460 <putc>
  while(--i >= 0)
 4fe:	39fd                	addiw	s3,s3,-1
 500:	14fd                	addi	s1,s1,-1
 502:	fe09d7e3          	bgez	s3,4f0 <printint+0x6e>
}
 506:	70e2                	ld	ra,56(sp)
 508:	7442                	ld	s0,48(sp)
 50a:	74a2                	ld	s1,40(sp)
 50c:	7902                	ld	s2,32(sp)
 50e:	69e2                	ld	s3,24(sp)
 510:	6121                	addi	sp,sp,64
 512:	8082                	ret
    x = -xx;
 514:	40b005bb          	negw	a1,a1
    neg = 1;
 518:	4e05                	li	t3,1
    x = -xx;
 51a:	b741                	j	49a <printint+0x18>

000000000000051c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 51c:	715d                	addi	sp,sp,-80
 51e:	e486                	sd	ra,72(sp)
 520:	e0a2                	sd	s0,64(sp)
 522:	f84a                	sd	s2,48(sp)
 524:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 526:	0005c903          	lbu	s2,0(a1)
 52a:	1a090a63          	beqz	s2,6de <vprintf+0x1c2>
 52e:	fc26                	sd	s1,56(sp)
 530:	f44e                	sd	s3,40(sp)
 532:	f052                	sd	s4,32(sp)
 534:	ec56                	sd	s5,24(sp)
 536:	e85a                	sd	s6,16(sp)
 538:	e45e                	sd	s7,8(sp)
 53a:	8aaa                	mv	s5,a0
 53c:	8bb2                	mv	s7,a2
 53e:	00158493          	addi	s1,a1,1
  state = 0;
 542:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 544:	02500a13          	li	s4,37
 548:	4b55                	li	s6,21
 54a:	a839                	j	568 <vprintf+0x4c>
        putc(fd, c);
 54c:	85ca                	mv	a1,s2
 54e:	8556                	mv	a0,s5
 550:	00000097          	auipc	ra,0x0
 554:	f10080e7          	jalr	-240(ra) # 460 <putc>
 558:	a019                	j	55e <vprintf+0x42>
    } else if(state == '%'){
 55a:	01498d63          	beq	s3,s4,574 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 55e:	0485                	addi	s1,s1,1
 560:	fff4c903          	lbu	s2,-1(s1)
 564:	16090763          	beqz	s2,6d2 <vprintf+0x1b6>
    if(state == 0){
 568:	fe0999e3          	bnez	s3,55a <vprintf+0x3e>
      if(c == '%'){
 56c:	ff4910e3          	bne	s2,s4,54c <vprintf+0x30>
        state = '%';
 570:	89d2                	mv	s3,s4
 572:	b7f5                	j	55e <vprintf+0x42>
      if(c == 'd'){
 574:	13490463          	beq	s2,s4,69c <vprintf+0x180>
 578:	f9d9079b          	addiw	a5,s2,-99
 57c:	0ff7f793          	zext.b	a5,a5
 580:	12fb6763          	bltu	s6,a5,6ae <vprintf+0x192>
 584:	f9d9079b          	addiw	a5,s2,-99
 588:	0ff7f713          	zext.b	a4,a5
 58c:	12eb6163          	bltu	s6,a4,6ae <vprintf+0x192>
 590:	00271793          	slli	a5,a4,0x2
 594:	00000717          	auipc	a4,0x0
 598:	38470713          	addi	a4,a4,900 # 918 <malloc+0x146>
 59c:	97ba                	add	a5,a5,a4
 59e:	439c                	lw	a5,0(a5)
 5a0:	97ba                	add	a5,a5,a4
 5a2:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5a4:	008b8913          	addi	s2,s7,8
 5a8:	4685                	li	a3,1
 5aa:	4629                	li	a2,10
 5ac:	000ba583          	lw	a1,0(s7)
 5b0:	8556                	mv	a0,s5
 5b2:	00000097          	auipc	ra,0x0
 5b6:	ed0080e7          	jalr	-304(ra) # 482 <printint>
 5ba:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5bc:	4981                	li	s3,0
 5be:	b745                	j	55e <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c0:	008b8913          	addi	s2,s7,8
 5c4:	4681                	li	a3,0
 5c6:	4629                	li	a2,10
 5c8:	000ba583          	lw	a1,0(s7)
 5cc:	8556                	mv	a0,s5
 5ce:	00000097          	auipc	ra,0x0
 5d2:	eb4080e7          	jalr	-332(ra) # 482 <printint>
 5d6:	8bca                	mv	s7,s2
      state = 0;
 5d8:	4981                	li	s3,0
 5da:	b751                	j	55e <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5dc:	008b8913          	addi	s2,s7,8
 5e0:	4681                	li	a3,0
 5e2:	4641                	li	a2,16
 5e4:	000ba583          	lw	a1,0(s7)
 5e8:	8556                	mv	a0,s5
 5ea:	00000097          	auipc	ra,0x0
 5ee:	e98080e7          	jalr	-360(ra) # 482 <printint>
 5f2:	8bca                	mv	s7,s2
      state = 0;
 5f4:	4981                	li	s3,0
 5f6:	b7a5                	j	55e <vprintf+0x42>
 5f8:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5fa:	008b8c13          	addi	s8,s7,8
 5fe:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 602:	03000593          	li	a1,48
 606:	8556                	mv	a0,s5
 608:	00000097          	auipc	ra,0x0
 60c:	e58080e7          	jalr	-424(ra) # 460 <putc>
  putc(fd, 'x');
 610:	07800593          	li	a1,120
 614:	8556                	mv	a0,s5
 616:	00000097          	auipc	ra,0x0
 61a:	e4a080e7          	jalr	-438(ra) # 460 <putc>
 61e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 620:	00000b97          	auipc	s7,0x0
 624:	350b8b93          	addi	s7,s7,848 # 970 <digits>
 628:	03c9d793          	srli	a5,s3,0x3c
 62c:	97de                	add	a5,a5,s7
 62e:	0007c583          	lbu	a1,0(a5)
 632:	8556                	mv	a0,s5
 634:	00000097          	auipc	ra,0x0
 638:	e2c080e7          	jalr	-468(ra) # 460 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 63c:	0992                	slli	s3,s3,0x4
 63e:	397d                	addiw	s2,s2,-1
 640:	fe0914e3          	bnez	s2,628 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 644:	8be2                	mv	s7,s8
      state = 0;
 646:	4981                	li	s3,0
 648:	6c02                	ld	s8,0(sp)
 64a:	bf11                	j	55e <vprintf+0x42>
        s = va_arg(ap, char*);
 64c:	008b8993          	addi	s3,s7,8
 650:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 654:	02090163          	beqz	s2,676 <vprintf+0x15a>
        while(*s != 0){
 658:	00094583          	lbu	a1,0(s2)
 65c:	c9a5                	beqz	a1,6cc <vprintf+0x1b0>
          putc(fd, *s);
 65e:	8556                	mv	a0,s5
 660:	00000097          	auipc	ra,0x0
 664:	e00080e7          	jalr	-512(ra) # 460 <putc>
          s++;
 668:	0905                	addi	s2,s2,1
        while(*s != 0){
 66a:	00094583          	lbu	a1,0(s2)
 66e:	f9e5                	bnez	a1,65e <vprintf+0x142>
        s = va_arg(ap, char*);
 670:	8bce                	mv	s7,s3
      state = 0;
 672:	4981                	li	s3,0
 674:	b5ed                	j	55e <vprintf+0x42>
          s = "(null)";
 676:	00000917          	auipc	s2,0x0
 67a:	29a90913          	addi	s2,s2,666 # 910 <malloc+0x13e>
        while(*s != 0){
 67e:	02800593          	li	a1,40
 682:	bff1                	j	65e <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 684:	008b8913          	addi	s2,s7,8
 688:	000bc583          	lbu	a1,0(s7)
 68c:	8556                	mv	a0,s5
 68e:	00000097          	auipc	ra,0x0
 692:	dd2080e7          	jalr	-558(ra) # 460 <putc>
 696:	8bca                	mv	s7,s2
      state = 0;
 698:	4981                	li	s3,0
 69a:	b5d1                	j	55e <vprintf+0x42>
        putc(fd, c);
 69c:	02500593          	li	a1,37
 6a0:	8556                	mv	a0,s5
 6a2:	00000097          	auipc	ra,0x0
 6a6:	dbe080e7          	jalr	-578(ra) # 460 <putc>
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	bd4d                	j	55e <vprintf+0x42>
        putc(fd, '%');
 6ae:	02500593          	li	a1,37
 6b2:	8556                	mv	a0,s5
 6b4:	00000097          	auipc	ra,0x0
 6b8:	dac080e7          	jalr	-596(ra) # 460 <putc>
        putc(fd, c);
 6bc:	85ca                	mv	a1,s2
 6be:	8556                	mv	a0,s5
 6c0:	00000097          	auipc	ra,0x0
 6c4:	da0080e7          	jalr	-608(ra) # 460 <putc>
      state = 0;
 6c8:	4981                	li	s3,0
 6ca:	bd51                	j	55e <vprintf+0x42>
        s = va_arg(ap, char*);
 6cc:	8bce                	mv	s7,s3
      state = 0;
 6ce:	4981                	li	s3,0
 6d0:	b579                	j	55e <vprintf+0x42>
 6d2:	74e2                	ld	s1,56(sp)
 6d4:	79a2                	ld	s3,40(sp)
 6d6:	7a02                	ld	s4,32(sp)
 6d8:	6ae2                	ld	s5,24(sp)
 6da:	6b42                	ld	s6,16(sp)
 6dc:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6de:	60a6                	ld	ra,72(sp)
 6e0:	6406                	ld	s0,64(sp)
 6e2:	7942                	ld	s2,48(sp)
 6e4:	6161                	addi	sp,sp,80
 6e6:	8082                	ret

00000000000006e8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6e8:	715d                	addi	sp,sp,-80
 6ea:	ec06                	sd	ra,24(sp)
 6ec:	e822                	sd	s0,16(sp)
 6ee:	1000                	addi	s0,sp,32
 6f0:	e010                	sd	a2,0(s0)
 6f2:	e414                	sd	a3,8(s0)
 6f4:	e818                	sd	a4,16(s0)
 6f6:	ec1c                	sd	a5,24(s0)
 6f8:	03043023          	sd	a6,32(s0)
 6fc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 700:	8622                	mv	a2,s0
 702:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 706:	00000097          	auipc	ra,0x0
 70a:	e16080e7          	jalr	-490(ra) # 51c <vprintf>
}
 70e:	60e2                	ld	ra,24(sp)
 710:	6442                	ld	s0,16(sp)
 712:	6161                	addi	sp,sp,80
 714:	8082                	ret

0000000000000716 <printf>:

void
printf(const char *fmt, ...)
{
 716:	711d                	addi	sp,sp,-96
 718:	ec06                	sd	ra,24(sp)
 71a:	e822                	sd	s0,16(sp)
 71c:	1000                	addi	s0,sp,32
 71e:	e40c                	sd	a1,8(s0)
 720:	e810                	sd	a2,16(s0)
 722:	ec14                	sd	a3,24(s0)
 724:	f018                	sd	a4,32(s0)
 726:	f41c                	sd	a5,40(s0)
 728:	03043823          	sd	a6,48(s0)
 72c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 730:	00840613          	addi	a2,s0,8
 734:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 738:	85aa                	mv	a1,a0
 73a:	4505                	li	a0,1
 73c:	00000097          	auipc	ra,0x0
 740:	de0080e7          	jalr	-544(ra) # 51c <vprintf>
}
 744:	60e2                	ld	ra,24(sp)
 746:	6442                	ld	s0,16(sp)
 748:	6125                	addi	sp,sp,96
 74a:	8082                	ret

000000000000074c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 74c:	1141                	addi	sp,sp,-16
 74e:	e406                	sd	ra,8(sp)
 750:	e022                	sd	s0,0(sp)
 752:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 754:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 758:	00001797          	auipc	a5,0x1
 75c:	8a87b783          	ld	a5,-1880(a5) # 1000 <freep>
 760:	a02d                	j	78a <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 762:	4618                	lw	a4,8(a2)
 764:	9f2d                	addw	a4,a4,a1
 766:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 76a:	6398                	ld	a4,0(a5)
 76c:	6310                	ld	a2,0(a4)
 76e:	a83d                	j	7ac <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 770:	ff852703          	lw	a4,-8(a0)
 774:	9f31                	addw	a4,a4,a2
 776:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 778:	ff053683          	ld	a3,-16(a0)
 77c:	a091                	j	7c0 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 77e:	6398                	ld	a4,0(a5)
 780:	00e7e463          	bltu	a5,a4,788 <free+0x3c>
 784:	00e6ea63          	bltu	a3,a4,798 <free+0x4c>
{
 788:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78a:	fed7fae3          	bgeu	a5,a3,77e <free+0x32>
 78e:	6398                	ld	a4,0(a5)
 790:	00e6e463          	bltu	a3,a4,798 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 794:	fee7eae3          	bltu	a5,a4,788 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 798:	ff852583          	lw	a1,-8(a0)
 79c:	6390                	ld	a2,0(a5)
 79e:	02059813          	slli	a6,a1,0x20
 7a2:	01c85713          	srli	a4,a6,0x1c
 7a6:	9736                	add	a4,a4,a3
 7a8:	fae60de3          	beq	a2,a4,762 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 7ac:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7b0:	4790                	lw	a2,8(a5)
 7b2:	02061593          	slli	a1,a2,0x20
 7b6:	01c5d713          	srli	a4,a1,0x1c
 7ba:	973e                	add	a4,a4,a5
 7bc:	fae68ae3          	beq	a3,a4,770 <free+0x24>
    p->s.ptr = bp->s.ptr;
 7c0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7c2:	00001717          	auipc	a4,0x1
 7c6:	82f73f23          	sd	a5,-1986(a4) # 1000 <freep>
}
 7ca:	60a2                	ld	ra,8(sp)
 7cc:	6402                	ld	s0,0(sp)
 7ce:	0141                	addi	sp,sp,16
 7d0:	8082                	ret

00000000000007d2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7d2:	7139                	addi	sp,sp,-64
 7d4:	fc06                	sd	ra,56(sp)
 7d6:	f822                	sd	s0,48(sp)
 7d8:	f04a                	sd	s2,32(sp)
 7da:	ec4e                	sd	s3,24(sp)
 7dc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7de:	02051993          	slli	s3,a0,0x20
 7e2:	0209d993          	srli	s3,s3,0x20
 7e6:	09bd                	addi	s3,s3,15
 7e8:	0049d993          	srli	s3,s3,0x4
 7ec:	2985                	addiw	s3,s3,1
 7ee:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7f0:	00001517          	auipc	a0,0x1
 7f4:	81053503          	ld	a0,-2032(a0) # 1000 <freep>
 7f8:	c905                	beqz	a0,828 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7fa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7fc:	4798                	lw	a4,8(a5)
 7fe:	09377a63          	bgeu	a4,s3,892 <malloc+0xc0>
 802:	f426                	sd	s1,40(sp)
 804:	e852                	sd	s4,16(sp)
 806:	e456                	sd	s5,8(sp)
 808:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 80a:	8a4e                	mv	s4,s3
 80c:	6705                	lui	a4,0x1
 80e:	00e9f363          	bgeu	s3,a4,814 <malloc+0x42>
 812:	6a05                	lui	s4,0x1
 814:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 818:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 81c:	00000497          	auipc	s1,0x0
 820:	7e448493          	addi	s1,s1,2020 # 1000 <freep>
  if(p == (char*)-1)
 824:	5afd                	li	s5,-1
 826:	a089                	j	868 <malloc+0x96>
 828:	f426                	sd	s1,40(sp)
 82a:	e852                	sd	s4,16(sp)
 82c:	e456                	sd	s5,8(sp)
 82e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 830:	00000797          	auipc	a5,0x0
 834:	7e078793          	addi	a5,a5,2016 # 1010 <base>
 838:	00000717          	auipc	a4,0x0
 83c:	7cf73423          	sd	a5,1992(a4) # 1000 <freep>
 840:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 842:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 846:	b7d1                	j	80a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 848:	6398                	ld	a4,0(a5)
 84a:	e118                	sd	a4,0(a0)
 84c:	a8b9                	j	8aa <malloc+0xd8>
  hp->s.size = nu;
 84e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 852:	0541                	addi	a0,a0,16
 854:	00000097          	auipc	ra,0x0
 858:	ef8080e7          	jalr	-264(ra) # 74c <free>
  return freep;
 85c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 85e:	c135                	beqz	a0,8c2 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 860:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 862:	4798                	lw	a4,8(a5)
 864:	03277363          	bgeu	a4,s2,88a <malloc+0xb8>
    if(p == freep)
 868:	6098                	ld	a4,0(s1)
 86a:	853e                	mv	a0,a5
 86c:	fef71ae3          	bne	a4,a5,860 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 870:	8552                	mv	a0,s4
 872:	00000097          	auipc	ra,0x0
 876:	bb6080e7          	jalr	-1098(ra) # 428 <sbrk>
  if(p == (char*)-1)
 87a:	fd551ae3          	bne	a0,s5,84e <malloc+0x7c>
        return 0;
 87e:	4501                	li	a0,0
 880:	74a2                	ld	s1,40(sp)
 882:	6a42                	ld	s4,16(sp)
 884:	6aa2                	ld	s5,8(sp)
 886:	6b02                	ld	s6,0(sp)
 888:	a03d                	j	8b6 <malloc+0xe4>
 88a:	74a2                	ld	s1,40(sp)
 88c:	6a42                	ld	s4,16(sp)
 88e:	6aa2                	ld	s5,8(sp)
 890:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 892:	fae90be3          	beq	s2,a4,848 <malloc+0x76>
        p->s.size -= nunits;
 896:	4137073b          	subw	a4,a4,s3
 89a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 89c:	02071693          	slli	a3,a4,0x20
 8a0:	01c6d713          	srli	a4,a3,0x1c
 8a4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8a6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8aa:	00000717          	auipc	a4,0x0
 8ae:	74a73b23          	sd	a0,1878(a4) # 1000 <freep>
      return (void*)(p + 1);
 8b2:	01078513          	addi	a0,a5,16
  }
}
 8b6:	70e2                	ld	ra,56(sp)
 8b8:	7442                	ld	s0,48(sp)
 8ba:	7902                	ld	s2,32(sp)
 8bc:	69e2                	ld	s3,24(sp)
 8be:	6121                	addi	sp,sp,64
 8c0:	8082                	ret
 8c2:	74a2                	ld	s1,40(sp)
 8c4:	6a42                	ld	s4,16(sp)
 8c6:	6aa2                	ld	s5,8(sp)
 8c8:	6b02                	ld	s6,0(sp)
 8ca:	b7f5                	j	8b6 <malloc+0xe4>
