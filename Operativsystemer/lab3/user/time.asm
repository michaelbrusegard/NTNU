
user/_time:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
    if (argc < 2)
   8:	4785                	li	a5,1
   a:	02a7dd63          	bge	a5,a0,44 <main+0x44>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	84ae                	mv	s1,a1
        printf("Time took 0 ticks\n");
        printf("Usage: time [exec] [arg1 arg2 ...]\n");
        exit(1);
    }

    int startticks = uptime();
  14:	00000097          	auipc	ra,0x0
  18:	3f6080e7          	jalr	1014(ra) # 40a <uptime>
  1c:	892a                	mv	s2,a0

    // we now start the program in a separate process:
    int uutPid = fork();
  1e:	00000097          	auipc	ra,0x0
  22:	34c080e7          	jalr	844(ra) # 36a <fork>

    // check if fork worked:
    if (uutPid < 0)
  26:	04054663          	bltz	a0,72 <main+0x72>
    {
        printf("fork failed... couldn't start %s", argv[1]);
        exit(1);
    }

    if (uutPid == 0)
  2a:	e135                	bnez	a0,8e <main+0x8e>
    {
        // we are the unit under test part of the program - execute the program immediately
        exec(argv[1], argv + 1); // pass rest of the command line to the executable as args
  2c:	00848593          	addi	a1,s1,8
  30:	6488                	ld	a0,8(s1)
  32:	00000097          	auipc	ra,0x0
  36:	378080e7          	jalr	888(ra) # 3aa <exec>
        // wait for the uut to finish
        wait(0);
        int endticks = uptime();
        printf("Executing %s took %d ticks\n", argv[1], endticks - startticks);
    }
    exit(0);
  3a:	4501                	li	a0,0
  3c:	00000097          	auipc	ra,0x0
  40:	336080e7          	jalr	822(ra) # 372 <exit>
  44:	e426                	sd	s1,8(sp)
  46:	e04a                	sd	s2,0(sp)
        printf("Time took 0 ticks\n");
  48:	00001517          	auipc	a0,0x1
  4c:	86850513          	addi	a0,a0,-1944 # 8b0 <malloc+0x104>
  50:	00000097          	auipc	ra,0x0
  54:	6a0080e7          	jalr	1696(ra) # 6f0 <printf>
        printf("Usage: time [exec] [arg1 arg2 ...]\n");
  58:	00001517          	auipc	a0,0x1
  5c:	87050513          	addi	a0,a0,-1936 # 8c8 <malloc+0x11c>
  60:	00000097          	auipc	ra,0x0
  64:	690080e7          	jalr	1680(ra) # 6f0 <printf>
        exit(1);
  68:	4505                	li	a0,1
  6a:	00000097          	auipc	ra,0x0
  6e:	308080e7          	jalr	776(ra) # 372 <exit>
        printf("fork failed... couldn't start %s", argv[1]);
  72:	648c                	ld	a1,8(s1)
  74:	00001517          	auipc	a0,0x1
  78:	87c50513          	addi	a0,a0,-1924 # 8f0 <malloc+0x144>
  7c:	00000097          	auipc	ra,0x0
  80:	674080e7          	jalr	1652(ra) # 6f0 <printf>
        exit(1);
  84:	4505                	li	a0,1
  86:	00000097          	auipc	ra,0x0
  8a:	2ec080e7          	jalr	748(ra) # 372 <exit>
        wait(0);
  8e:	4501                	li	a0,0
  90:	00000097          	auipc	ra,0x0
  94:	2ea080e7          	jalr	746(ra) # 37a <wait>
        int endticks = uptime();
  98:	00000097          	auipc	ra,0x0
  9c:	372080e7          	jalr	882(ra) # 40a <uptime>
        printf("Executing %s took %d ticks\n", argv[1], endticks - startticks);
  a0:	4125063b          	subw	a2,a0,s2
  a4:	648c                	ld	a1,8(s1)
  a6:	00001517          	auipc	a0,0x1
  aa:	87250513          	addi	a0,a0,-1934 # 918 <malloc+0x16c>
  ae:	00000097          	auipc	ra,0x0
  b2:	642080e7          	jalr	1602(ra) # 6f0 <printf>
  b6:	b751                	j	3a <main+0x3a>

00000000000000b8 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  b8:	1141                	addi	sp,sp,-16
  ba:	e406                	sd	ra,8(sp)
  bc:	e022                	sd	s0,0(sp)
  be:	0800                	addi	s0,sp,16
  extern int main();
  main();
  c0:	00000097          	auipc	ra,0x0
  c4:	f40080e7          	jalr	-192(ra) # 0 <main>
  exit(0);
  c8:	4501                	li	a0,0
  ca:	00000097          	auipc	ra,0x0
  ce:	2a8080e7          	jalr	680(ra) # 372 <exit>

00000000000000d2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  d2:	1141                	addi	sp,sp,-16
  d4:	e406                	sd	ra,8(sp)
  d6:	e022                	sd	s0,0(sp)
  d8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  da:	87aa                	mv	a5,a0
  dc:	0585                	addi	a1,a1,1
  de:	0785                	addi	a5,a5,1
  e0:	fff5c703          	lbu	a4,-1(a1)
  e4:	fee78fa3          	sb	a4,-1(a5)
  e8:	fb75                	bnez	a4,dc <strcpy+0xa>
    ;
  return os;
}
  ea:	60a2                	ld	ra,8(sp)
  ec:	6402                	ld	s0,0(sp)
  ee:	0141                	addi	sp,sp,16
  f0:	8082                	ret

00000000000000f2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f2:	1141                	addi	sp,sp,-16
  f4:	e406                	sd	ra,8(sp)
  f6:	e022                	sd	s0,0(sp)
  f8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  fa:	00054783          	lbu	a5,0(a0)
  fe:	cb91                	beqz	a5,112 <strcmp+0x20>
 100:	0005c703          	lbu	a4,0(a1)
 104:	00f71763          	bne	a4,a5,112 <strcmp+0x20>
    p++, q++;
 108:	0505                	addi	a0,a0,1
 10a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 10c:	00054783          	lbu	a5,0(a0)
 110:	fbe5                	bnez	a5,100 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 112:	0005c503          	lbu	a0,0(a1)
}
 116:	40a7853b          	subw	a0,a5,a0
 11a:	60a2                	ld	ra,8(sp)
 11c:	6402                	ld	s0,0(sp)
 11e:	0141                	addi	sp,sp,16
 120:	8082                	ret

0000000000000122 <strlen>:

uint
strlen(const char *s)
{
 122:	1141                	addi	sp,sp,-16
 124:	e406                	sd	ra,8(sp)
 126:	e022                	sd	s0,0(sp)
 128:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 12a:	00054783          	lbu	a5,0(a0)
 12e:	cf99                	beqz	a5,14c <strlen+0x2a>
 130:	0505                	addi	a0,a0,1
 132:	87aa                	mv	a5,a0
 134:	86be                	mv	a3,a5
 136:	0785                	addi	a5,a5,1
 138:	fff7c703          	lbu	a4,-1(a5)
 13c:	ff65                	bnez	a4,134 <strlen+0x12>
 13e:	40a6853b          	subw	a0,a3,a0
 142:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 144:	60a2                	ld	ra,8(sp)
 146:	6402                	ld	s0,0(sp)
 148:	0141                	addi	sp,sp,16
 14a:	8082                	ret
  for(n = 0; s[n]; n++)
 14c:	4501                	li	a0,0
 14e:	bfdd                	j	144 <strlen+0x22>

0000000000000150 <memset>:

void*
memset(void *dst, int c, uint n)
{
 150:	1141                	addi	sp,sp,-16
 152:	e406                	sd	ra,8(sp)
 154:	e022                	sd	s0,0(sp)
 156:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 158:	ca19                	beqz	a2,16e <memset+0x1e>
 15a:	87aa                	mv	a5,a0
 15c:	1602                	slli	a2,a2,0x20
 15e:	9201                	srli	a2,a2,0x20
 160:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 164:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 168:	0785                	addi	a5,a5,1
 16a:	fee79de3          	bne	a5,a4,164 <memset+0x14>
  }
  return dst;
}
 16e:	60a2                	ld	ra,8(sp)
 170:	6402                	ld	s0,0(sp)
 172:	0141                	addi	sp,sp,16
 174:	8082                	ret

0000000000000176 <strchr>:

char*
strchr(const char *s, char c)
{
 176:	1141                	addi	sp,sp,-16
 178:	e406                	sd	ra,8(sp)
 17a:	e022                	sd	s0,0(sp)
 17c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 17e:	00054783          	lbu	a5,0(a0)
 182:	cf81                	beqz	a5,19a <strchr+0x24>
    if(*s == c)
 184:	00f58763          	beq	a1,a5,192 <strchr+0x1c>
  for(; *s; s++)
 188:	0505                	addi	a0,a0,1
 18a:	00054783          	lbu	a5,0(a0)
 18e:	fbfd                	bnez	a5,184 <strchr+0xe>
      return (char*)s;
  return 0;
 190:	4501                	li	a0,0
}
 192:	60a2                	ld	ra,8(sp)
 194:	6402                	ld	s0,0(sp)
 196:	0141                	addi	sp,sp,16
 198:	8082                	ret
  return 0;
 19a:	4501                	li	a0,0
 19c:	bfdd                	j	192 <strchr+0x1c>

000000000000019e <gets>:

char*
gets(char *buf, int max)
{
 19e:	7159                	addi	sp,sp,-112
 1a0:	f486                	sd	ra,104(sp)
 1a2:	f0a2                	sd	s0,96(sp)
 1a4:	eca6                	sd	s1,88(sp)
 1a6:	e8ca                	sd	s2,80(sp)
 1a8:	e4ce                	sd	s3,72(sp)
 1aa:	e0d2                	sd	s4,64(sp)
 1ac:	fc56                	sd	s5,56(sp)
 1ae:	f85a                	sd	s6,48(sp)
 1b0:	f45e                	sd	s7,40(sp)
 1b2:	f062                	sd	s8,32(sp)
 1b4:	ec66                	sd	s9,24(sp)
 1b6:	e86a                	sd	s10,16(sp)
 1b8:	1880                	addi	s0,sp,112
 1ba:	8caa                	mv	s9,a0
 1bc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1be:	892a                	mv	s2,a0
 1c0:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1c2:	f9f40b13          	addi	s6,s0,-97
 1c6:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1c8:	4ba9                	li	s7,10
 1ca:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 1cc:	8d26                	mv	s10,s1
 1ce:	0014899b          	addiw	s3,s1,1
 1d2:	84ce                	mv	s1,s3
 1d4:	0349d763          	bge	s3,s4,202 <gets+0x64>
    cc = read(0, &c, 1);
 1d8:	8656                	mv	a2,s5
 1da:	85da                	mv	a1,s6
 1dc:	4501                	li	a0,0
 1de:	00000097          	auipc	ra,0x0
 1e2:	1ac080e7          	jalr	428(ra) # 38a <read>
    if(cc < 1)
 1e6:	00a05e63          	blez	a0,202 <gets+0x64>
    buf[i++] = c;
 1ea:	f9f44783          	lbu	a5,-97(s0)
 1ee:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1f2:	01778763          	beq	a5,s7,200 <gets+0x62>
 1f6:	0905                	addi	s2,s2,1
 1f8:	fd879ae3          	bne	a5,s8,1cc <gets+0x2e>
    buf[i++] = c;
 1fc:	8d4e                	mv	s10,s3
 1fe:	a011                	j	202 <gets+0x64>
 200:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 202:	9d66                	add	s10,s10,s9
 204:	000d0023          	sb	zero,0(s10)
  return buf;
}
 208:	8566                	mv	a0,s9
 20a:	70a6                	ld	ra,104(sp)
 20c:	7406                	ld	s0,96(sp)
 20e:	64e6                	ld	s1,88(sp)
 210:	6946                	ld	s2,80(sp)
 212:	69a6                	ld	s3,72(sp)
 214:	6a06                	ld	s4,64(sp)
 216:	7ae2                	ld	s5,56(sp)
 218:	7b42                	ld	s6,48(sp)
 21a:	7ba2                	ld	s7,40(sp)
 21c:	7c02                	ld	s8,32(sp)
 21e:	6ce2                	ld	s9,24(sp)
 220:	6d42                	ld	s10,16(sp)
 222:	6165                	addi	sp,sp,112
 224:	8082                	ret

0000000000000226 <stat>:

int
stat(const char *n, struct stat *st)
{
 226:	1101                	addi	sp,sp,-32
 228:	ec06                	sd	ra,24(sp)
 22a:	e822                	sd	s0,16(sp)
 22c:	e04a                	sd	s2,0(sp)
 22e:	1000                	addi	s0,sp,32
 230:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 232:	4581                	li	a1,0
 234:	00000097          	auipc	ra,0x0
 238:	17e080e7          	jalr	382(ra) # 3b2 <open>
  if(fd < 0)
 23c:	02054663          	bltz	a0,268 <stat+0x42>
 240:	e426                	sd	s1,8(sp)
 242:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 244:	85ca                	mv	a1,s2
 246:	00000097          	auipc	ra,0x0
 24a:	184080e7          	jalr	388(ra) # 3ca <fstat>
 24e:	892a                	mv	s2,a0
  close(fd);
 250:	8526                	mv	a0,s1
 252:	00000097          	auipc	ra,0x0
 256:	148080e7          	jalr	328(ra) # 39a <close>
  return r;
 25a:	64a2                	ld	s1,8(sp)
}
 25c:	854a                	mv	a0,s2
 25e:	60e2                	ld	ra,24(sp)
 260:	6442                	ld	s0,16(sp)
 262:	6902                	ld	s2,0(sp)
 264:	6105                	addi	sp,sp,32
 266:	8082                	ret
    return -1;
 268:	597d                	li	s2,-1
 26a:	bfcd                	j	25c <stat+0x36>

000000000000026c <atoi>:

int
atoi(const char *s)
{
 26c:	1141                	addi	sp,sp,-16
 26e:	e406                	sd	ra,8(sp)
 270:	e022                	sd	s0,0(sp)
 272:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 274:	00054683          	lbu	a3,0(a0)
 278:	fd06879b          	addiw	a5,a3,-48
 27c:	0ff7f793          	zext.b	a5,a5
 280:	4625                	li	a2,9
 282:	02f66963          	bltu	a2,a5,2b4 <atoi+0x48>
 286:	872a                	mv	a4,a0
  n = 0;
 288:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 28a:	0705                	addi	a4,a4,1
 28c:	0025179b          	slliw	a5,a0,0x2
 290:	9fa9                	addw	a5,a5,a0
 292:	0017979b          	slliw	a5,a5,0x1
 296:	9fb5                	addw	a5,a5,a3
 298:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 29c:	00074683          	lbu	a3,0(a4)
 2a0:	fd06879b          	addiw	a5,a3,-48
 2a4:	0ff7f793          	zext.b	a5,a5
 2a8:	fef671e3          	bgeu	a2,a5,28a <atoi+0x1e>
  return n;
}
 2ac:	60a2                	ld	ra,8(sp)
 2ae:	6402                	ld	s0,0(sp)
 2b0:	0141                	addi	sp,sp,16
 2b2:	8082                	ret
  n = 0;
 2b4:	4501                	li	a0,0
 2b6:	bfdd                	j	2ac <atoi+0x40>

00000000000002b8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2b8:	1141                	addi	sp,sp,-16
 2ba:	e406                	sd	ra,8(sp)
 2bc:	e022                	sd	s0,0(sp)
 2be:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2c0:	02b57563          	bgeu	a0,a1,2ea <memmove+0x32>
    while(n-- > 0)
 2c4:	00c05f63          	blez	a2,2e2 <memmove+0x2a>
 2c8:	1602                	slli	a2,a2,0x20
 2ca:	9201                	srli	a2,a2,0x20
 2cc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2d0:	872a                	mv	a4,a0
      *dst++ = *src++;
 2d2:	0585                	addi	a1,a1,1
 2d4:	0705                	addi	a4,a4,1
 2d6:	fff5c683          	lbu	a3,-1(a1)
 2da:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2de:	fee79ae3          	bne	a5,a4,2d2 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2e2:	60a2                	ld	ra,8(sp)
 2e4:	6402                	ld	s0,0(sp)
 2e6:	0141                	addi	sp,sp,16
 2e8:	8082                	ret
    dst += n;
 2ea:	00c50733          	add	a4,a0,a2
    src += n;
 2ee:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2f0:	fec059e3          	blez	a2,2e2 <memmove+0x2a>
 2f4:	fff6079b          	addiw	a5,a2,-1
 2f8:	1782                	slli	a5,a5,0x20
 2fa:	9381                	srli	a5,a5,0x20
 2fc:	fff7c793          	not	a5,a5
 300:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 302:	15fd                	addi	a1,a1,-1
 304:	177d                	addi	a4,a4,-1
 306:	0005c683          	lbu	a3,0(a1)
 30a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 30e:	fef71ae3          	bne	a4,a5,302 <memmove+0x4a>
 312:	bfc1                	j	2e2 <memmove+0x2a>

0000000000000314 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 314:	1141                	addi	sp,sp,-16
 316:	e406                	sd	ra,8(sp)
 318:	e022                	sd	s0,0(sp)
 31a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 31c:	ca0d                	beqz	a2,34e <memcmp+0x3a>
 31e:	fff6069b          	addiw	a3,a2,-1
 322:	1682                	slli	a3,a3,0x20
 324:	9281                	srli	a3,a3,0x20
 326:	0685                	addi	a3,a3,1
 328:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 32a:	00054783          	lbu	a5,0(a0)
 32e:	0005c703          	lbu	a4,0(a1)
 332:	00e79863          	bne	a5,a4,342 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 336:	0505                	addi	a0,a0,1
    p2++;
 338:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 33a:	fed518e3          	bne	a0,a3,32a <memcmp+0x16>
  }
  return 0;
 33e:	4501                	li	a0,0
 340:	a019                	j	346 <memcmp+0x32>
      return *p1 - *p2;
 342:	40e7853b          	subw	a0,a5,a4
}
 346:	60a2                	ld	ra,8(sp)
 348:	6402                	ld	s0,0(sp)
 34a:	0141                	addi	sp,sp,16
 34c:	8082                	ret
  return 0;
 34e:	4501                	li	a0,0
 350:	bfdd                	j	346 <memcmp+0x32>

0000000000000352 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 352:	1141                	addi	sp,sp,-16
 354:	e406                	sd	ra,8(sp)
 356:	e022                	sd	s0,0(sp)
 358:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 35a:	00000097          	auipc	ra,0x0
 35e:	f5e080e7          	jalr	-162(ra) # 2b8 <memmove>
}
 362:	60a2                	ld	ra,8(sp)
 364:	6402                	ld	s0,0(sp)
 366:	0141                	addi	sp,sp,16
 368:	8082                	ret

000000000000036a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 36a:	4885                	li	a7,1
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <exit>:
.global exit
exit:
 li a7, SYS_exit
 372:	4889                	li	a7,2
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <wait>:
.global wait
wait:
 li a7, SYS_wait
 37a:	488d                	li	a7,3
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 382:	4891                	li	a7,4
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <read>:
.global read
read:
 li a7, SYS_read
 38a:	4895                	li	a7,5
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <write>:
.global write
write:
 li a7, SYS_write
 392:	48c1                	li	a7,16
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <close>:
.global close
close:
 li a7, SYS_close
 39a:	48d5                	li	a7,21
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3a2:	4899                	li	a7,6
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <exec>:
.global exec
exec:
 li a7, SYS_exec
 3aa:	489d                	li	a7,7
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <open>:
.global open
open:
 li a7, SYS_open
 3b2:	48bd                	li	a7,15
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3ba:	48c5                	li	a7,17
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3c2:	48c9                	li	a7,18
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3ca:	48a1                	li	a7,8
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <link>:
.global link
link:
 li a7, SYS_link
 3d2:	48cd                	li	a7,19
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3da:	48d1                	li	a7,20
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3e2:	48a5                	li	a7,9
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <dup>:
.global dup
dup:
 li a7, SYS_dup
 3ea:	48a9                	li	a7,10
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3f2:	48ad                	li	a7,11
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3fa:	48b1                	li	a7,12
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 402:	48b5                	li	a7,13
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 40a:	48b9                	li	a7,14
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <ps>:
.global ps
ps:
 li a7, SYS_ps
 412:	48d9                	li	a7,22
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
 41a:	48dd                	li	a7,23
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
 422:	48e1                	li	a7,24
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <va2pa>:
.global va2pa
va2pa:
 li a7, SYS_va2pa
 42a:	48e9                	li	a7,26
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <pfreepages>:
.global pfreepages
pfreepages:
 li a7, SYS_pfreepages
 432:	48e5                	li	a7,25
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 43a:	1101                	addi	sp,sp,-32
 43c:	ec06                	sd	ra,24(sp)
 43e:	e822                	sd	s0,16(sp)
 440:	1000                	addi	s0,sp,32
 442:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 446:	4605                	li	a2,1
 448:	fef40593          	addi	a1,s0,-17
 44c:	00000097          	auipc	ra,0x0
 450:	f46080e7          	jalr	-186(ra) # 392 <write>
}
 454:	60e2                	ld	ra,24(sp)
 456:	6442                	ld	s0,16(sp)
 458:	6105                	addi	sp,sp,32
 45a:	8082                	ret

000000000000045c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 45c:	7139                	addi	sp,sp,-64
 45e:	fc06                	sd	ra,56(sp)
 460:	f822                	sd	s0,48(sp)
 462:	f426                	sd	s1,40(sp)
 464:	f04a                	sd	s2,32(sp)
 466:	ec4e                	sd	s3,24(sp)
 468:	0080                	addi	s0,sp,64
 46a:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 46c:	c299                	beqz	a3,472 <printint+0x16>
 46e:	0805c063          	bltz	a1,4ee <printint+0x92>
  neg = 0;
 472:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 474:	fc040313          	addi	t1,s0,-64
  neg = 0;
 478:	869a                	mv	a3,t1
  i = 0;
 47a:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 47c:	00000817          	auipc	a6,0x0
 480:	51c80813          	addi	a6,a6,1308 # 998 <digits>
 484:	88be                	mv	a7,a5
 486:	0017851b          	addiw	a0,a5,1
 48a:	87aa                	mv	a5,a0
 48c:	02c5f73b          	remuw	a4,a1,a2
 490:	1702                	slli	a4,a4,0x20
 492:	9301                	srli	a4,a4,0x20
 494:	9742                	add	a4,a4,a6
 496:	00074703          	lbu	a4,0(a4)
 49a:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 49e:	872e                	mv	a4,a1
 4a0:	02c5d5bb          	divuw	a1,a1,a2
 4a4:	0685                	addi	a3,a3,1
 4a6:	fcc77fe3          	bgeu	a4,a2,484 <printint+0x28>
  if(neg)
 4aa:	000e0c63          	beqz	t3,4c2 <printint+0x66>
    buf[i++] = '-';
 4ae:	fd050793          	addi	a5,a0,-48
 4b2:	00878533          	add	a0,a5,s0
 4b6:	02d00793          	li	a5,45
 4ba:	fef50823          	sb	a5,-16(a0)
 4be:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 4c2:	fff7899b          	addiw	s3,a5,-1
 4c6:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 4ca:	fff4c583          	lbu	a1,-1(s1)
 4ce:	854a                	mv	a0,s2
 4d0:	00000097          	auipc	ra,0x0
 4d4:	f6a080e7          	jalr	-150(ra) # 43a <putc>
  while(--i >= 0)
 4d8:	39fd                	addiw	s3,s3,-1
 4da:	14fd                	addi	s1,s1,-1
 4dc:	fe09d7e3          	bgez	s3,4ca <printint+0x6e>
}
 4e0:	70e2                	ld	ra,56(sp)
 4e2:	7442                	ld	s0,48(sp)
 4e4:	74a2                	ld	s1,40(sp)
 4e6:	7902                	ld	s2,32(sp)
 4e8:	69e2                	ld	s3,24(sp)
 4ea:	6121                	addi	sp,sp,64
 4ec:	8082                	ret
    x = -xx;
 4ee:	40b005bb          	negw	a1,a1
    neg = 1;
 4f2:	4e05                	li	t3,1
    x = -xx;
 4f4:	b741                	j	474 <printint+0x18>

00000000000004f6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4f6:	715d                	addi	sp,sp,-80
 4f8:	e486                	sd	ra,72(sp)
 4fa:	e0a2                	sd	s0,64(sp)
 4fc:	f84a                	sd	s2,48(sp)
 4fe:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 500:	0005c903          	lbu	s2,0(a1)
 504:	1a090a63          	beqz	s2,6b8 <vprintf+0x1c2>
 508:	fc26                	sd	s1,56(sp)
 50a:	f44e                	sd	s3,40(sp)
 50c:	f052                	sd	s4,32(sp)
 50e:	ec56                	sd	s5,24(sp)
 510:	e85a                	sd	s6,16(sp)
 512:	e45e                	sd	s7,8(sp)
 514:	8aaa                	mv	s5,a0
 516:	8bb2                	mv	s7,a2
 518:	00158493          	addi	s1,a1,1
  state = 0;
 51c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 51e:	02500a13          	li	s4,37
 522:	4b55                	li	s6,21
 524:	a839                	j	542 <vprintf+0x4c>
        putc(fd, c);
 526:	85ca                	mv	a1,s2
 528:	8556                	mv	a0,s5
 52a:	00000097          	auipc	ra,0x0
 52e:	f10080e7          	jalr	-240(ra) # 43a <putc>
 532:	a019                	j	538 <vprintf+0x42>
    } else if(state == '%'){
 534:	01498d63          	beq	s3,s4,54e <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 538:	0485                	addi	s1,s1,1
 53a:	fff4c903          	lbu	s2,-1(s1)
 53e:	16090763          	beqz	s2,6ac <vprintf+0x1b6>
    if(state == 0){
 542:	fe0999e3          	bnez	s3,534 <vprintf+0x3e>
      if(c == '%'){
 546:	ff4910e3          	bne	s2,s4,526 <vprintf+0x30>
        state = '%';
 54a:	89d2                	mv	s3,s4
 54c:	b7f5                	j	538 <vprintf+0x42>
      if(c == 'd'){
 54e:	13490463          	beq	s2,s4,676 <vprintf+0x180>
 552:	f9d9079b          	addiw	a5,s2,-99
 556:	0ff7f793          	zext.b	a5,a5
 55a:	12fb6763          	bltu	s6,a5,688 <vprintf+0x192>
 55e:	f9d9079b          	addiw	a5,s2,-99
 562:	0ff7f713          	zext.b	a4,a5
 566:	12eb6163          	bltu	s6,a4,688 <vprintf+0x192>
 56a:	00271793          	slli	a5,a4,0x2
 56e:	00000717          	auipc	a4,0x0
 572:	3d270713          	addi	a4,a4,978 # 940 <malloc+0x194>
 576:	97ba                	add	a5,a5,a4
 578:	439c                	lw	a5,0(a5)
 57a:	97ba                	add	a5,a5,a4
 57c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 57e:	008b8913          	addi	s2,s7,8
 582:	4685                	li	a3,1
 584:	4629                	li	a2,10
 586:	000ba583          	lw	a1,0(s7)
 58a:	8556                	mv	a0,s5
 58c:	00000097          	auipc	ra,0x0
 590:	ed0080e7          	jalr	-304(ra) # 45c <printint>
 594:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 596:	4981                	li	s3,0
 598:	b745                	j	538 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 59a:	008b8913          	addi	s2,s7,8
 59e:	4681                	li	a3,0
 5a0:	4629                	li	a2,10
 5a2:	000ba583          	lw	a1,0(s7)
 5a6:	8556                	mv	a0,s5
 5a8:	00000097          	auipc	ra,0x0
 5ac:	eb4080e7          	jalr	-332(ra) # 45c <printint>
 5b0:	8bca                	mv	s7,s2
      state = 0;
 5b2:	4981                	li	s3,0
 5b4:	b751                	j	538 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5b6:	008b8913          	addi	s2,s7,8
 5ba:	4681                	li	a3,0
 5bc:	4641                	li	a2,16
 5be:	000ba583          	lw	a1,0(s7)
 5c2:	8556                	mv	a0,s5
 5c4:	00000097          	auipc	ra,0x0
 5c8:	e98080e7          	jalr	-360(ra) # 45c <printint>
 5cc:	8bca                	mv	s7,s2
      state = 0;
 5ce:	4981                	li	s3,0
 5d0:	b7a5                	j	538 <vprintf+0x42>
 5d2:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5d4:	008b8c13          	addi	s8,s7,8
 5d8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5dc:	03000593          	li	a1,48
 5e0:	8556                	mv	a0,s5
 5e2:	00000097          	auipc	ra,0x0
 5e6:	e58080e7          	jalr	-424(ra) # 43a <putc>
  putc(fd, 'x');
 5ea:	07800593          	li	a1,120
 5ee:	8556                	mv	a0,s5
 5f0:	00000097          	auipc	ra,0x0
 5f4:	e4a080e7          	jalr	-438(ra) # 43a <putc>
 5f8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5fa:	00000b97          	auipc	s7,0x0
 5fe:	39eb8b93          	addi	s7,s7,926 # 998 <digits>
 602:	03c9d793          	srli	a5,s3,0x3c
 606:	97de                	add	a5,a5,s7
 608:	0007c583          	lbu	a1,0(a5)
 60c:	8556                	mv	a0,s5
 60e:	00000097          	auipc	ra,0x0
 612:	e2c080e7          	jalr	-468(ra) # 43a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 616:	0992                	slli	s3,s3,0x4
 618:	397d                	addiw	s2,s2,-1
 61a:	fe0914e3          	bnez	s2,602 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 61e:	8be2                	mv	s7,s8
      state = 0;
 620:	4981                	li	s3,0
 622:	6c02                	ld	s8,0(sp)
 624:	bf11                	j	538 <vprintf+0x42>
        s = va_arg(ap, char*);
 626:	008b8993          	addi	s3,s7,8
 62a:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 62e:	02090163          	beqz	s2,650 <vprintf+0x15a>
        while(*s != 0){
 632:	00094583          	lbu	a1,0(s2)
 636:	c9a5                	beqz	a1,6a6 <vprintf+0x1b0>
          putc(fd, *s);
 638:	8556                	mv	a0,s5
 63a:	00000097          	auipc	ra,0x0
 63e:	e00080e7          	jalr	-512(ra) # 43a <putc>
          s++;
 642:	0905                	addi	s2,s2,1
        while(*s != 0){
 644:	00094583          	lbu	a1,0(s2)
 648:	f9e5                	bnez	a1,638 <vprintf+0x142>
        s = va_arg(ap, char*);
 64a:	8bce                	mv	s7,s3
      state = 0;
 64c:	4981                	li	s3,0
 64e:	b5ed                	j	538 <vprintf+0x42>
          s = "(null)";
 650:	00000917          	auipc	s2,0x0
 654:	2e890913          	addi	s2,s2,744 # 938 <malloc+0x18c>
        while(*s != 0){
 658:	02800593          	li	a1,40
 65c:	bff1                	j	638 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 65e:	008b8913          	addi	s2,s7,8
 662:	000bc583          	lbu	a1,0(s7)
 666:	8556                	mv	a0,s5
 668:	00000097          	auipc	ra,0x0
 66c:	dd2080e7          	jalr	-558(ra) # 43a <putc>
 670:	8bca                	mv	s7,s2
      state = 0;
 672:	4981                	li	s3,0
 674:	b5d1                	j	538 <vprintf+0x42>
        putc(fd, c);
 676:	02500593          	li	a1,37
 67a:	8556                	mv	a0,s5
 67c:	00000097          	auipc	ra,0x0
 680:	dbe080e7          	jalr	-578(ra) # 43a <putc>
      state = 0;
 684:	4981                	li	s3,0
 686:	bd4d                	j	538 <vprintf+0x42>
        putc(fd, '%');
 688:	02500593          	li	a1,37
 68c:	8556                	mv	a0,s5
 68e:	00000097          	auipc	ra,0x0
 692:	dac080e7          	jalr	-596(ra) # 43a <putc>
        putc(fd, c);
 696:	85ca                	mv	a1,s2
 698:	8556                	mv	a0,s5
 69a:	00000097          	auipc	ra,0x0
 69e:	da0080e7          	jalr	-608(ra) # 43a <putc>
      state = 0;
 6a2:	4981                	li	s3,0
 6a4:	bd51                	j	538 <vprintf+0x42>
        s = va_arg(ap, char*);
 6a6:	8bce                	mv	s7,s3
      state = 0;
 6a8:	4981                	li	s3,0
 6aa:	b579                	j	538 <vprintf+0x42>
 6ac:	74e2                	ld	s1,56(sp)
 6ae:	79a2                	ld	s3,40(sp)
 6b0:	7a02                	ld	s4,32(sp)
 6b2:	6ae2                	ld	s5,24(sp)
 6b4:	6b42                	ld	s6,16(sp)
 6b6:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6b8:	60a6                	ld	ra,72(sp)
 6ba:	6406                	ld	s0,64(sp)
 6bc:	7942                	ld	s2,48(sp)
 6be:	6161                	addi	sp,sp,80
 6c0:	8082                	ret

00000000000006c2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6c2:	715d                	addi	sp,sp,-80
 6c4:	ec06                	sd	ra,24(sp)
 6c6:	e822                	sd	s0,16(sp)
 6c8:	1000                	addi	s0,sp,32
 6ca:	e010                	sd	a2,0(s0)
 6cc:	e414                	sd	a3,8(s0)
 6ce:	e818                	sd	a4,16(s0)
 6d0:	ec1c                	sd	a5,24(s0)
 6d2:	03043023          	sd	a6,32(s0)
 6d6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6da:	8622                	mv	a2,s0
 6dc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6e0:	00000097          	auipc	ra,0x0
 6e4:	e16080e7          	jalr	-490(ra) # 4f6 <vprintf>
}
 6e8:	60e2                	ld	ra,24(sp)
 6ea:	6442                	ld	s0,16(sp)
 6ec:	6161                	addi	sp,sp,80
 6ee:	8082                	ret

00000000000006f0 <printf>:

void
printf(const char *fmt, ...)
{
 6f0:	711d                	addi	sp,sp,-96
 6f2:	ec06                	sd	ra,24(sp)
 6f4:	e822                	sd	s0,16(sp)
 6f6:	1000                	addi	s0,sp,32
 6f8:	e40c                	sd	a1,8(s0)
 6fa:	e810                	sd	a2,16(s0)
 6fc:	ec14                	sd	a3,24(s0)
 6fe:	f018                	sd	a4,32(s0)
 700:	f41c                	sd	a5,40(s0)
 702:	03043823          	sd	a6,48(s0)
 706:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 70a:	00840613          	addi	a2,s0,8
 70e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 712:	85aa                	mv	a1,a0
 714:	4505                	li	a0,1
 716:	00000097          	auipc	ra,0x0
 71a:	de0080e7          	jalr	-544(ra) # 4f6 <vprintf>
}
 71e:	60e2                	ld	ra,24(sp)
 720:	6442                	ld	s0,16(sp)
 722:	6125                	addi	sp,sp,96
 724:	8082                	ret

0000000000000726 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 726:	1141                	addi	sp,sp,-16
 728:	e406                	sd	ra,8(sp)
 72a:	e022                	sd	s0,0(sp)
 72c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 72e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 732:	00001797          	auipc	a5,0x1
 736:	8ce7b783          	ld	a5,-1842(a5) # 1000 <freep>
 73a:	a02d                	j	764 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 73c:	4618                	lw	a4,8(a2)
 73e:	9f2d                	addw	a4,a4,a1
 740:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 744:	6398                	ld	a4,0(a5)
 746:	6310                	ld	a2,0(a4)
 748:	a83d                	j	786 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 74a:	ff852703          	lw	a4,-8(a0)
 74e:	9f31                	addw	a4,a4,a2
 750:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 752:	ff053683          	ld	a3,-16(a0)
 756:	a091                	j	79a <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 758:	6398                	ld	a4,0(a5)
 75a:	00e7e463          	bltu	a5,a4,762 <free+0x3c>
 75e:	00e6ea63          	bltu	a3,a4,772 <free+0x4c>
{
 762:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 764:	fed7fae3          	bgeu	a5,a3,758 <free+0x32>
 768:	6398                	ld	a4,0(a5)
 76a:	00e6e463          	bltu	a3,a4,772 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 76e:	fee7eae3          	bltu	a5,a4,762 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 772:	ff852583          	lw	a1,-8(a0)
 776:	6390                	ld	a2,0(a5)
 778:	02059813          	slli	a6,a1,0x20
 77c:	01c85713          	srli	a4,a6,0x1c
 780:	9736                	add	a4,a4,a3
 782:	fae60de3          	beq	a2,a4,73c <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 786:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 78a:	4790                	lw	a2,8(a5)
 78c:	02061593          	slli	a1,a2,0x20
 790:	01c5d713          	srli	a4,a1,0x1c
 794:	973e                	add	a4,a4,a5
 796:	fae68ae3          	beq	a3,a4,74a <free+0x24>
    p->s.ptr = bp->s.ptr;
 79a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 79c:	00001717          	auipc	a4,0x1
 7a0:	86f73223          	sd	a5,-1948(a4) # 1000 <freep>
}
 7a4:	60a2                	ld	ra,8(sp)
 7a6:	6402                	ld	s0,0(sp)
 7a8:	0141                	addi	sp,sp,16
 7aa:	8082                	ret

00000000000007ac <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7ac:	7139                	addi	sp,sp,-64
 7ae:	fc06                	sd	ra,56(sp)
 7b0:	f822                	sd	s0,48(sp)
 7b2:	f04a                	sd	s2,32(sp)
 7b4:	ec4e                	sd	s3,24(sp)
 7b6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b8:	02051993          	slli	s3,a0,0x20
 7bc:	0209d993          	srli	s3,s3,0x20
 7c0:	09bd                	addi	s3,s3,15
 7c2:	0049d993          	srli	s3,s3,0x4
 7c6:	2985                	addiw	s3,s3,1
 7c8:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7ca:	00001517          	auipc	a0,0x1
 7ce:	83653503          	ld	a0,-1994(a0) # 1000 <freep>
 7d2:	c905                	beqz	a0,802 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7d6:	4798                	lw	a4,8(a5)
 7d8:	09377a63          	bgeu	a4,s3,86c <malloc+0xc0>
 7dc:	f426                	sd	s1,40(sp)
 7de:	e852                	sd	s4,16(sp)
 7e0:	e456                	sd	s5,8(sp)
 7e2:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7e4:	8a4e                	mv	s4,s3
 7e6:	6705                	lui	a4,0x1
 7e8:	00e9f363          	bgeu	s3,a4,7ee <malloc+0x42>
 7ec:	6a05                	lui	s4,0x1
 7ee:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7f2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7f6:	00001497          	auipc	s1,0x1
 7fa:	80a48493          	addi	s1,s1,-2038 # 1000 <freep>
  if(p == (char*)-1)
 7fe:	5afd                	li	s5,-1
 800:	a089                	j	842 <malloc+0x96>
 802:	f426                	sd	s1,40(sp)
 804:	e852                	sd	s4,16(sp)
 806:	e456                	sd	s5,8(sp)
 808:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 80a:	00001797          	auipc	a5,0x1
 80e:	80678793          	addi	a5,a5,-2042 # 1010 <base>
 812:	00000717          	auipc	a4,0x0
 816:	7ef73723          	sd	a5,2030(a4) # 1000 <freep>
 81a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 81c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 820:	b7d1                	j	7e4 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 822:	6398                	ld	a4,0(a5)
 824:	e118                	sd	a4,0(a0)
 826:	a8b9                	j	884 <malloc+0xd8>
  hp->s.size = nu;
 828:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 82c:	0541                	addi	a0,a0,16
 82e:	00000097          	auipc	ra,0x0
 832:	ef8080e7          	jalr	-264(ra) # 726 <free>
  return freep;
 836:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 838:	c135                	beqz	a0,89c <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 83c:	4798                	lw	a4,8(a5)
 83e:	03277363          	bgeu	a4,s2,864 <malloc+0xb8>
    if(p == freep)
 842:	6098                	ld	a4,0(s1)
 844:	853e                	mv	a0,a5
 846:	fef71ae3          	bne	a4,a5,83a <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 84a:	8552                	mv	a0,s4
 84c:	00000097          	auipc	ra,0x0
 850:	bae080e7          	jalr	-1106(ra) # 3fa <sbrk>
  if(p == (char*)-1)
 854:	fd551ae3          	bne	a0,s5,828 <malloc+0x7c>
        return 0;
 858:	4501                	li	a0,0
 85a:	74a2                	ld	s1,40(sp)
 85c:	6a42                	ld	s4,16(sp)
 85e:	6aa2                	ld	s5,8(sp)
 860:	6b02                	ld	s6,0(sp)
 862:	a03d                	j	890 <malloc+0xe4>
 864:	74a2                	ld	s1,40(sp)
 866:	6a42                	ld	s4,16(sp)
 868:	6aa2                	ld	s5,8(sp)
 86a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 86c:	fae90be3          	beq	s2,a4,822 <malloc+0x76>
        p->s.size -= nunits;
 870:	4137073b          	subw	a4,a4,s3
 874:	c798                	sw	a4,8(a5)
        p += p->s.size;
 876:	02071693          	slli	a3,a4,0x20
 87a:	01c6d713          	srli	a4,a3,0x1c
 87e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 880:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 884:	00000717          	auipc	a4,0x0
 888:	76a73e23          	sd	a0,1916(a4) # 1000 <freep>
      return (void*)(p + 1);
 88c:	01078513          	addi	a0,a5,16
  }
}
 890:	70e2                	ld	ra,56(sp)
 892:	7442                	ld	s0,48(sp)
 894:	7902                	ld	s2,32(sp)
 896:	69e2                	ld	s3,24(sp)
 898:	6121                	addi	sp,sp,64
 89a:	8082                	ret
 89c:	74a2                	ld	s1,40(sp)
 89e:	6a42                	ld	s4,16(sp)
 8a0:	6aa2                	ld	s5,8(sp)
 8a2:	6b02                	ld	s6,0(sp)
 8a4:	b7f5                	j	890 <malloc+0xe4>
