
user/_ps:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

int main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
    uint16 proc_idx = 0;
  10:	4901                	li	s2,0
    while (1)
    {
        struct user_proc *procs = ps(proc_idx, 2);
  12:	4a09                	li	s4,2

        for (int i = 0; i < 2; i++)
        {
            if (procs[i].state == UNUSED)
                exit(0);
            printf("%s (%d): %d\n", procs[i].name, procs[i].pid, procs[i].state);
  14:	00001997          	auipc	s3,0x1
  18:	87c98993          	addi	s3,s3,-1924 # 890 <malloc+0x118>
  1c:	a815                	j	50 <main+0x50>
            printf("SYSCALL FAILED");
  1e:	00001517          	auipc	a0,0x1
  22:	86250513          	addi	a0,a0,-1950 # 880 <malloc+0x108>
  26:	00000097          	auipc	ra,0x0
  2a:	696080e7          	jalr	1686(ra) # 6bc <printf>
            exit(-1);
  2e:	557d                	li	a0,-1
  30:	00000097          	auipc	ra,0x0
  34:	30e080e7          	jalr	782(ra) # 33e <exit>
            printf("%s (%d): %d\n", procs[i].name, procs[i].pid, procs[i].state);
  38:	5890                	lw	a2,48(s1)
  3a:	03848593          	addi	a1,s1,56
  3e:	854e                	mv	a0,s3
  40:	00000097          	auipc	ra,0x0
  44:	67c080e7          	jalr	1660(ra) # 6bc <printf>
        }
        proc_idx += 2;
  48:	2909                	addiw	s2,s2,2
  4a:	1942                	slli	s2,s2,0x30
  4c:	03095913          	srli	s2,s2,0x30
        struct user_proc *procs = ps(proc_idx, 2);
  50:	85d2                	mv	a1,s4
  52:	0ff97513          	zext.b	a0,s2
  56:	00000097          	auipc	ra,0x0
  5a:	388080e7          	jalr	904(ra) # 3de <ps>
  5e:	84aa                	mv	s1,a0
        if (procs == 0)
  60:	dd5d                	beqz	a0,1e <main+0x1e>
            if (procs[i].state == UNUSED)
  62:	4114                	lw	a3,0(a0)
  64:	ca99                	beqz	a3,7a <main+0x7a>
            printf("%s (%d): %d\n", procs[i].name, procs[i].pid, procs[i].state);
  66:	4550                	lw	a2,12(a0)
  68:	01450593          	addi	a1,a0,20
  6c:	854e                	mv	a0,s3
  6e:	00000097          	auipc	ra,0x0
  72:	64e080e7          	jalr	1614(ra) # 6bc <printf>
            if (procs[i].state == UNUSED)
  76:	50d4                	lw	a3,36(s1)
  78:	f2e1                	bnez	a3,38 <main+0x38>
                exit(0);
  7a:	4501                	li	a0,0
  7c:	00000097          	auipc	ra,0x0
  80:	2c2080e7          	jalr	706(ra) # 33e <exit>

0000000000000084 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  84:	1141                	addi	sp,sp,-16
  86:	e406                	sd	ra,8(sp)
  88:	e022                	sd	s0,0(sp)
  8a:	0800                	addi	s0,sp,16
  extern int main();
  main();
  8c:	00000097          	auipc	ra,0x0
  90:	f74080e7          	jalr	-140(ra) # 0 <main>
  exit(0);
  94:	4501                	li	a0,0
  96:	00000097          	auipc	ra,0x0
  9a:	2a8080e7          	jalr	680(ra) # 33e <exit>

000000000000009e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  9e:	1141                	addi	sp,sp,-16
  a0:	e406                	sd	ra,8(sp)
  a2:	e022                	sd	s0,0(sp)
  a4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  a6:	87aa                	mv	a5,a0
  a8:	0585                	addi	a1,a1,1
  aa:	0785                	addi	a5,a5,1
  ac:	fff5c703          	lbu	a4,-1(a1)
  b0:	fee78fa3          	sb	a4,-1(a5)
  b4:	fb75                	bnez	a4,a8 <strcpy+0xa>
    ;
  return os;
}
  b6:	60a2                	ld	ra,8(sp)
  b8:	6402                	ld	s0,0(sp)
  ba:	0141                	addi	sp,sp,16
  bc:	8082                	ret

00000000000000be <strcmp>:

int
strcmp(const char *p, const char *q)
{
  be:	1141                	addi	sp,sp,-16
  c0:	e406                	sd	ra,8(sp)
  c2:	e022                	sd	s0,0(sp)
  c4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  c6:	00054783          	lbu	a5,0(a0)
  ca:	cb91                	beqz	a5,de <strcmp+0x20>
  cc:	0005c703          	lbu	a4,0(a1)
  d0:	00f71763          	bne	a4,a5,de <strcmp+0x20>
    p++, q++;
  d4:	0505                	addi	a0,a0,1
  d6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  d8:	00054783          	lbu	a5,0(a0)
  dc:	fbe5                	bnez	a5,cc <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  de:	0005c503          	lbu	a0,0(a1)
}
  e2:	40a7853b          	subw	a0,a5,a0
  e6:	60a2                	ld	ra,8(sp)
  e8:	6402                	ld	s0,0(sp)
  ea:	0141                	addi	sp,sp,16
  ec:	8082                	ret

00000000000000ee <strlen>:

uint
strlen(const char *s)
{
  ee:	1141                	addi	sp,sp,-16
  f0:	e406                	sd	ra,8(sp)
  f2:	e022                	sd	s0,0(sp)
  f4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  f6:	00054783          	lbu	a5,0(a0)
  fa:	cf99                	beqz	a5,118 <strlen+0x2a>
  fc:	0505                	addi	a0,a0,1
  fe:	87aa                	mv	a5,a0
 100:	86be                	mv	a3,a5
 102:	0785                	addi	a5,a5,1
 104:	fff7c703          	lbu	a4,-1(a5)
 108:	ff65                	bnez	a4,100 <strlen+0x12>
 10a:	40a6853b          	subw	a0,a3,a0
 10e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 110:	60a2                	ld	ra,8(sp)
 112:	6402                	ld	s0,0(sp)
 114:	0141                	addi	sp,sp,16
 116:	8082                	ret
  for(n = 0; s[n]; n++)
 118:	4501                	li	a0,0
 11a:	bfdd                	j	110 <strlen+0x22>

000000000000011c <memset>:

void*
memset(void *dst, int c, uint n)
{
 11c:	1141                	addi	sp,sp,-16
 11e:	e406                	sd	ra,8(sp)
 120:	e022                	sd	s0,0(sp)
 122:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 124:	ca19                	beqz	a2,13a <memset+0x1e>
 126:	87aa                	mv	a5,a0
 128:	1602                	slli	a2,a2,0x20
 12a:	9201                	srli	a2,a2,0x20
 12c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 130:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 134:	0785                	addi	a5,a5,1
 136:	fee79de3          	bne	a5,a4,130 <memset+0x14>
  }
  return dst;
}
 13a:	60a2                	ld	ra,8(sp)
 13c:	6402                	ld	s0,0(sp)
 13e:	0141                	addi	sp,sp,16
 140:	8082                	ret

0000000000000142 <strchr>:

char*
strchr(const char *s, char c)
{
 142:	1141                	addi	sp,sp,-16
 144:	e406                	sd	ra,8(sp)
 146:	e022                	sd	s0,0(sp)
 148:	0800                	addi	s0,sp,16
  for(; *s; s++)
 14a:	00054783          	lbu	a5,0(a0)
 14e:	cf81                	beqz	a5,166 <strchr+0x24>
    if(*s == c)
 150:	00f58763          	beq	a1,a5,15e <strchr+0x1c>
  for(; *s; s++)
 154:	0505                	addi	a0,a0,1
 156:	00054783          	lbu	a5,0(a0)
 15a:	fbfd                	bnez	a5,150 <strchr+0xe>
      return (char*)s;
  return 0;
 15c:	4501                	li	a0,0
}
 15e:	60a2                	ld	ra,8(sp)
 160:	6402                	ld	s0,0(sp)
 162:	0141                	addi	sp,sp,16
 164:	8082                	ret
  return 0;
 166:	4501                	li	a0,0
 168:	bfdd                	j	15e <strchr+0x1c>

000000000000016a <gets>:

char*
gets(char *buf, int max)
{
 16a:	7159                	addi	sp,sp,-112
 16c:	f486                	sd	ra,104(sp)
 16e:	f0a2                	sd	s0,96(sp)
 170:	eca6                	sd	s1,88(sp)
 172:	e8ca                	sd	s2,80(sp)
 174:	e4ce                	sd	s3,72(sp)
 176:	e0d2                	sd	s4,64(sp)
 178:	fc56                	sd	s5,56(sp)
 17a:	f85a                	sd	s6,48(sp)
 17c:	f45e                	sd	s7,40(sp)
 17e:	f062                	sd	s8,32(sp)
 180:	ec66                	sd	s9,24(sp)
 182:	e86a                	sd	s10,16(sp)
 184:	1880                	addi	s0,sp,112
 186:	8caa                	mv	s9,a0
 188:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 18a:	892a                	mv	s2,a0
 18c:	4481                	li	s1,0
    cc = read(0, &c, 1);
 18e:	f9f40b13          	addi	s6,s0,-97
 192:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 194:	4ba9                	li	s7,10
 196:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 198:	8d26                	mv	s10,s1
 19a:	0014899b          	addiw	s3,s1,1
 19e:	84ce                	mv	s1,s3
 1a0:	0349d763          	bge	s3,s4,1ce <gets+0x64>
    cc = read(0, &c, 1);
 1a4:	8656                	mv	a2,s5
 1a6:	85da                	mv	a1,s6
 1a8:	4501                	li	a0,0
 1aa:	00000097          	auipc	ra,0x0
 1ae:	1ac080e7          	jalr	428(ra) # 356 <read>
    if(cc < 1)
 1b2:	00a05e63          	blez	a0,1ce <gets+0x64>
    buf[i++] = c;
 1b6:	f9f44783          	lbu	a5,-97(s0)
 1ba:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1be:	01778763          	beq	a5,s7,1cc <gets+0x62>
 1c2:	0905                	addi	s2,s2,1
 1c4:	fd879ae3          	bne	a5,s8,198 <gets+0x2e>
    buf[i++] = c;
 1c8:	8d4e                	mv	s10,s3
 1ca:	a011                	j	1ce <gets+0x64>
 1cc:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1ce:	9d66                	add	s10,s10,s9
 1d0:	000d0023          	sb	zero,0(s10)
  return buf;
}
 1d4:	8566                	mv	a0,s9
 1d6:	70a6                	ld	ra,104(sp)
 1d8:	7406                	ld	s0,96(sp)
 1da:	64e6                	ld	s1,88(sp)
 1dc:	6946                	ld	s2,80(sp)
 1de:	69a6                	ld	s3,72(sp)
 1e0:	6a06                	ld	s4,64(sp)
 1e2:	7ae2                	ld	s5,56(sp)
 1e4:	7b42                	ld	s6,48(sp)
 1e6:	7ba2                	ld	s7,40(sp)
 1e8:	7c02                	ld	s8,32(sp)
 1ea:	6ce2                	ld	s9,24(sp)
 1ec:	6d42                	ld	s10,16(sp)
 1ee:	6165                	addi	sp,sp,112
 1f0:	8082                	ret

00000000000001f2 <stat>:

int
stat(const char *n, struct stat *st)
{
 1f2:	1101                	addi	sp,sp,-32
 1f4:	ec06                	sd	ra,24(sp)
 1f6:	e822                	sd	s0,16(sp)
 1f8:	e04a                	sd	s2,0(sp)
 1fa:	1000                	addi	s0,sp,32
 1fc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1fe:	4581                	li	a1,0
 200:	00000097          	auipc	ra,0x0
 204:	17e080e7          	jalr	382(ra) # 37e <open>
  if(fd < 0)
 208:	02054663          	bltz	a0,234 <stat+0x42>
 20c:	e426                	sd	s1,8(sp)
 20e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 210:	85ca                	mv	a1,s2
 212:	00000097          	auipc	ra,0x0
 216:	184080e7          	jalr	388(ra) # 396 <fstat>
 21a:	892a                	mv	s2,a0
  close(fd);
 21c:	8526                	mv	a0,s1
 21e:	00000097          	auipc	ra,0x0
 222:	148080e7          	jalr	328(ra) # 366 <close>
  return r;
 226:	64a2                	ld	s1,8(sp)
}
 228:	854a                	mv	a0,s2
 22a:	60e2                	ld	ra,24(sp)
 22c:	6442                	ld	s0,16(sp)
 22e:	6902                	ld	s2,0(sp)
 230:	6105                	addi	sp,sp,32
 232:	8082                	ret
    return -1;
 234:	597d                	li	s2,-1
 236:	bfcd                	j	228 <stat+0x36>

0000000000000238 <atoi>:

int
atoi(const char *s)
{
 238:	1141                	addi	sp,sp,-16
 23a:	e406                	sd	ra,8(sp)
 23c:	e022                	sd	s0,0(sp)
 23e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 240:	00054683          	lbu	a3,0(a0)
 244:	fd06879b          	addiw	a5,a3,-48
 248:	0ff7f793          	zext.b	a5,a5
 24c:	4625                	li	a2,9
 24e:	02f66963          	bltu	a2,a5,280 <atoi+0x48>
 252:	872a                	mv	a4,a0
  n = 0;
 254:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 256:	0705                	addi	a4,a4,1
 258:	0025179b          	slliw	a5,a0,0x2
 25c:	9fa9                	addw	a5,a5,a0
 25e:	0017979b          	slliw	a5,a5,0x1
 262:	9fb5                	addw	a5,a5,a3
 264:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 268:	00074683          	lbu	a3,0(a4)
 26c:	fd06879b          	addiw	a5,a3,-48
 270:	0ff7f793          	zext.b	a5,a5
 274:	fef671e3          	bgeu	a2,a5,256 <atoi+0x1e>
  return n;
}
 278:	60a2                	ld	ra,8(sp)
 27a:	6402                	ld	s0,0(sp)
 27c:	0141                	addi	sp,sp,16
 27e:	8082                	ret
  n = 0;
 280:	4501                	li	a0,0
 282:	bfdd                	j	278 <atoi+0x40>

0000000000000284 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 284:	1141                	addi	sp,sp,-16
 286:	e406                	sd	ra,8(sp)
 288:	e022                	sd	s0,0(sp)
 28a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 28c:	02b57563          	bgeu	a0,a1,2b6 <memmove+0x32>
    while(n-- > 0)
 290:	00c05f63          	blez	a2,2ae <memmove+0x2a>
 294:	1602                	slli	a2,a2,0x20
 296:	9201                	srli	a2,a2,0x20
 298:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 29c:	872a                	mv	a4,a0
      *dst++ = *src++;
 29e:	0585                	addi	a1,a1,1
 2a0:	0705                	addi	a4,a4,1
 2a2:	fff5c683          	lbu	a3,-1(a1)
 2a6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2aa:	fee79ae3          	bne	a5,a4,29e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2ae:	60a2                	ld	ra,8(sp)
 2b0:	6402                	ld	s0,0(sp)
 2b2:	0141                	addi	sp,sp,16
 2b4:	8082                	ret
    dst += n;
 2b6:	00c50733          	add	a4,a0,a2
    src += n;
 2ba:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2bc:	fec059e3          	blez	a2,2ae <memmove+0x2a>
 2c0:	fff6079b          	addiw	a5,a2,-1
 2c4:	1782                	slli	a5,a5,0x20
 2c6:	9381                	srli	a5,a5,0x20
 2c8:	fff7c793          	not	a5,a5
 2cc:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2ce:	15fd                	addi	a1,a1,-1
 2d0:	177d                	addi	a4,a4,-1
 2d2:	0005c683          	lbu	a3,0(a1)
 2d6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2da:	fef71ae3          	bne	a4,a5,2ce <memmove+0x4a>
 2de:	bfc1                	j	2ae <memmove+0x2a>

00000000000002e0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2e0:	1141                	addi	sp,sp,-16
 2e2:	e406                	sd	ra,8(sp)
 2e4:	e022                	sd	s0,0(sp)
 2e6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2e8:	ca0d                	beqz	a2,31a <memcmp+0x3a>
 2ea:	fff6069b          	addiw	a3,a2,-1
 2ee:	1682                	slli	a3,a3,0x20
 2f0:	9281                	srli	a3,a3,0x20
 2f2:	0685                	addi	a3,a3,1
 2f4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2f6:	00054783          	lbu	a5,0(a0)
 2fa:	0005c703          	lbu	a4,0(a1)
 2fe:	00e79863          	bne	a5,a4,30e <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 302:	0505                	addi	a0,a0,1
    p2++;
 304:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 306:	fed518e3          	bne	a0,a3,2f6 <memcmp+0x16>
  }
  return 0;
 30a:	4501                	li	a0,0
 30c:	a019                	j	312 <memcmp+0x32>
      return *p1 - *p2;
 30e:	40e7853b          	subw	a0,a5,a4
}
 312:	60a2                	ld	ra,8(sp)
 314:	6402                	ld	s0,0(sp)
 316:	0141                	addi	sp,sp,16
 318:	8082                	ret
  return 0;
 31a:	4501                	li	a0,0
 31c:	bfdd                	j	312 <memcmp+0x32>

000000000000031e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 31e:	1141                	addi	sp,sp,-16
 320:	e406                	sd	ra,8(sp)
 322:	e022                	sd	s0,0(sp)
 324:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 326:	00000097          	auipc	ra,0x0
 32a:	f5e080e7          	jalr	-162(ra) # 284 <memmove>
}
 32e:	60a2                	ld	ra,8(sp)
 330:	6402                	ld	s0,0(sp)
 332:	0141                	addi	sp,sp,16
 334:	8082                	ret

0000000000000336 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 336:	4885                	li	a7,1
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <exit>:
.global exit
exit:
 li a7, SYS_exit
 33e:	4889                	li	a7,2
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <wait>:
.global wait
wait:
 li a7, SYS_wait
 346:	488d                	li	a7,3
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 34e:	4891                	li	a7,4
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <read>:
.global read
read:
 li a7, SYS_read
 356:	4895                	li	a7,5
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <write>:
.global write
write:
 li a7, SYS_write
 35e:	48c1                	li	a7,16
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <close>:
.global close
close:
 li a7, SYS_close
 366:	48d5                	li	a7,21
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <kill>:
.global kill
kill:
 li a7, SYS_kill
 36e:	4899                	li	a7,6
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <exec>:
.global exec
exec:
 li a7, SYS_exec
 376:	489d                	li	a7,7
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <open>:
.global open
open:
 li a7, SYS_open
 37e:	48bd                	li	a7,15
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 386:	48c5                	li	a7,17
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 38e:	48c9                	li	a7,18
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 396:	48a1                	li	a7,8
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <link>:
.global link
link:
 li a7, SYS_link
 39e:	48cd                	li	a7,19
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3a6:	48d1                	li	a7,20
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3ae:	48a5                	li	a7,9
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3b6:	48a9                	li	a7,10
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3be:	48ad                	li	a7,11
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3c6:	48b1                	li	a7,12
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3ce:	48b5                	li	a7,13
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3d6:	48b9                	li	a7,14
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <ps>:
.global ps
ps:
 li a7, SYS_ps
 3de:	48d9                	li	a7,22
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
 3e6:	48dd                	li	a7,23
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
 3ee:	48e1                	li	a7,24
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <va2pa>:
.global va2pa
va2pa:
 li a7, SYS_va2pa
 3f6:	48e9                	li	a7,26
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <pfreepages>:
.global pfreepages
pfreepages:
 li a7, SYS_pfreepages
 3fe:	48e5                	li	a7,25
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 406:	1101                	addi	sp,sp,-32
 408:	ec06                	sd	ra,24(sp)
 40a:	e822                	sd	s0,16(sp)
 40c:	1000                	addi	s0,sp,32
 40e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 412:	4605                	li	a2,1
 414:	fef40593          	addi	a1,s0,-17
 418:	00000097          	auipc	ra,0x0
 41c:	f46080e7          	jalr	-186(ra) # 35e <write>
}
 420:	60e2                	ld	ra,24(sp)
 422:	6442                	ld	s0,16(sp)
 424:	6105                	addi	sp,sp,32
 426:	8082                	ret

0000000000000428 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 428:	7139                	addi	sp,sp,-64
 42a:	fc06                	sd	ra,56(sp)
 42c:	f822                	sd	s0,48(sp)
 42e:	f426                	sd	s1,40(sp)
 430:	f04a                	sd	s2,32(sp)
 432:	ec4e                	sd	s3,24(sp)
 434:	0080                	addi	s0,sp,64
 436:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 438:	c299                	beqz	a3,43e <printint+0x16>
 43a:	0805c063          	bltz	a1,4ba <printint+0x92>
  neg = 0;
 43e:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 440:	fc040313          	addi	t1,s0,-64
  neg = 0;
 444:	869a                	mv	a3,t1
  i = 0;
 446:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 448:	00000817          	auipc	a6,0x0
 44c:	4b880813          	addi	a6,a6,1208 # 900 <digits>
 450:	88be                	mv	a7,a5
 452:	0017851b          	addiw	a0,a5,1
 456:	87aa                	mv	a5,a0
 458:	02c5f73b          	remuw	a4,a1,a2
 45c:	1702                	slli	a4,a4,0x20
 45e:	9301                	srli	a4,a4,0x20
 460:	9742                	add	a4,a4,a6
 462:	00074703          	lbu	a4,0(a4)
 466:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 46a:	872e                	mv	a4,a1
 46c:	02c5d5bb          	divuw	a1,a1,a2
 470:	0685                	addi	a3,a3,1
 472:	fcc77fe3          	bgeu	a4,a2,450 <printint+0x28>
  if(neg)
 476:	000e0c63          	beqz	t3,48e <printint+0x66>
    buf[i++] = '-';
 47a:	fd050793          	addi	a5,a0,-48
 47e:	00878533          	add	a0,a5,s0
 482:	02d00793          	li	a5,45
 486:	fef50823          	sb	a5,-16(a0)
 48a:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 48e:	fff7899b          	addiw	s3,a5,-1
 492:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 496:	fff4c583          	lbu	a1,-1(s1)
 49a:	854a                	mv	a0,s2
 49c:	00000097          	auipc	ra,0x0
 4a0:	f6a080e7          	jalr	-150(ra) # 406 <putc>
  while(--i >= 0)
 4a4:	39fd                	addiw	s3,s3,-1
 4a6:	14fd                	addi	s1,s1,-1
 4a8:	fe09d7e3          	bgez	s3,496 <printint+0x6e>
}
 4ac:	70e2                	ld	ra,56(sp)
 4ae:	7442                	ld	s0,48(sp)
 4b0:	74a2                	ld	s1,40(sp)
 4b2:	7902                	ld	s2,32(sp)
 4b4:	69e2                	ld	s3,24(sp)
 4b6:	6121                	addi	sp,sp,64
 4b8:	8082                	ret
    x = -xx;
 4ba:	40b005bb          	negw	a1,a1
    neg = 1;
 4be:	4e05                	li	t3,1
    x = -xx;
 4c0:	b741                	j	440 <printint+0x18>

00000000000004c2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4c2:	715d                	addi	sp,sp,-80
 4c4:	e486                	sd	ra,72(sp)
 4c6:	e0a2                	sd	s0,64(sp)
 4c8:	f84a                	sd	s2,48(sp)
 4ca:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4cc:	0005c903          	lbu	s2,0(a1)
 4d0:	1a090a63          	beqz	s2,684 <vprintf+0x1c2>
 4d4:	fc26                	sd	s1,56(sp)
 4d6:	f44e                	sd	s3,40(sp)
 4d8:	f052                	sd	s4,32(sp)
 4da:	ec56                	sd	s5,24(sp)
 4dc:	e85a                	sd	s6,16(sp)
 4de:	e45e                	sd	s7,8(sp)
 4e0:	8aaa                	mv	s5,a0
 4e2:	8bb2                	mv	s7,a2
 4e4:	00158493          	addi	s1,a1,1
  state = 0;
 4e8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4ea:	02500a13          	li	s4,37
 4ee:	4b55                	li	s6,21
 4f0:	a839                	j	50e <vprintf+0x4c>
        putc(fd, c);
 4f2:	85ca                	mv	a1,s2
 4f4:	8556                	mv	a0,s5
 4f6:	00000097          	auipc	ra,0x0
 4fa:	f10080e7          	jalr	-240(ra) # 406 <putc>
 4fe:	a019                	j	504 <vprintf+0x42>
    } else if(state == '%'){
 500:	01498d63          	beq	s3,s4,51a <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 504:	0485                	addi	s1,s1,1
 506:	fff4c903          	lbu	s2,-1(s1)
 50a:	16090763          	beqz	s2,678 <vprintf+0x1b6>
    if(state == 0){
 50e:	fe0999e3          	bnez	s3,500 <vprintf+0x3e>
      if(c == '%'){
 512:	ff4910e3          	bne	s2,s4,4f2 <vprintf+0x30>
        state = '%';
 516:	89d2                	mv	s3,s4
 518:	b7f5                	j	504 <vprintf+0x42>
      if(c == 'd'){
 51a:	13490463          	beq	s2,s4,642 <vprintf+0x180>
 51e:	f9d9079b          	addiw	a5,s2,-99
 522:	0ff7f793          	zext.b	a5,a5
 526:	12fb6763          	bltu	s6,a5,654 <vprintf+0x192>
 52a:	f9d9079b          	addiw	a5,s2,-99
 52e:	0ff7f713          	zext.b	a4,a5
 532:	12eb6163          	bltu	s6,a4,654 <vprintf+0x192>
 536:	00271793          	slli	a5,a4,0x2
 53a:	00000717          	auipc	a4,0x0
 53e:	36e70713          	addi	a4,a4,878 # 8a8 <malloc+0x130>
 542:	97ba                	add	a5,a5,a4
 544:	439c                	lw	a5,0(a5)
 546:	97ba                	add	a5,a5,a4
 548:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 54a:	008b8913          	addi	s2,s7,8
 54e:	4685                	li	a3,1
 550:	4629                	li	a2,10
 552:	000ba583          	lw	a1,0(s7)
 556:	8556                	mv	a0,s5
 558:	00000097          	auipc	ra,0x0
 55c:	ed0080e7          	jalr	-304(ra) # 428 <printint>
 560:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 562:	4981                	li	s3,0
 564:	b745                	j	504 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 566:	008b8913          	addi	s2,s7,8
 56a:	4681                	li	a3,0
 56c:	4629                	li	a2,10
 56e:	000ba583          	lw	a1,0(s7)
 572:	8556                	mv	a0,s5
 574:	00000097          	auipc	ra,0x0
 578:	eb4080e7          	jalr	-332(ra) # 428 <printint>
 57c:	8bca                	mv	s7,s2
      state = 0;
 57e:	4981                	li	s3,0
 580:	b751                	j	504 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 582:	008b8913          	addi	s2,s7,8
 586:	4681                	li	a3,0
 588:	4641                	li	a2,16
 58a:	000ba583          	lw	a1,0(s7)
 58e:	8556                	mv	a0,s5
 590:	00000097          	auipc	ra,0x0
 594:	e98080e7          	jalr	-360(ra) # 428 <printint>
 598:	8bca                	mv	s7,s2
      state = 0;
 59a:	4981                	li	s3,0
 59c:	b7a5                	j	504 <vprintf+0x42>
 59e:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5a0:	008b8c13          	addi	s8,s7,8
 5a4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5a8:	03000593          	li	a1,48
 5ac:	8556                	mv	a0,s5
 5ae:	00000097          	auipc	ra,0x0
 5b2:	e58080e7          	jalr	-424(ra) # 406 <putc>
  putc(fd, 'x');
 5b6:	07800593          	li	a1,120
 5ba:	8556                	mv	a0,s5
 5bc:	00000097          	auipc	ra,0x0
 5c0:	e4a080e7          	jalr	-438(ra) # 406 <putc>
 5c4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5c6:	00000b97          	auipc	s7,0x0
 5ca:	33ab8b93          	addi	s7,s7,826 # 900 <digits>
 5ce:	03c9d793          	srli	a5,s3,0x3c
 5d2:	97de                	add	a5,a5,s7
 5d4:	0007c583          	lbu	a1,0(a5)
 5d8:	8556                	mv	a0,s5
 5da:	00000097          	auipc	ra,0x0
 5de:	e2c080e7          	jalr	-468(ra) # 406 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5e2:	0992                	slli	s3,s3,0x4
 5e4:	397d                	addiw	s2,s2,-1
 5e6:	fe0914e3          	bnez	s2,5ce <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 5ea:	8be2                	mv	s7,s8
      state = 0;
 5ec:	4981                	li	s3,0
 5ee:	6c02                	ld	s8,0(sp)
 5f0:	bf11                	j	504 <vprintf+0x42>
        s = va_arg(ap, char*);
 5f2:	008b8993          	addi	s3,s7,8
 5f6:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5fa:	02090163          	beqz	s2,61c <vprintf+0x15a>
        while(*s != 0){
 5fe:	00094583          	lbu	a1,0(s2)
 602:	c9a5                	beqz	a1,672 <vprintf+0x1b0>
          putc(fd, *s);
 604:	8556                	mv	a0,s5
 606:	00000097          	auipc	ra,0x0
 60a:	e00080e7          	jalr	-512(ra) # 406 <putc>
          s++;
 60e:	0905                	addi	s2,s2,1
        while(*s != 0){
 610:	00094583          	lbu	a1,0(s2)
 614:	f9e5                	bnez	a1,604 <vprintf+0x142>
        s = va_arg(ap, char*);
 616:	8bce                	mv	s7,s3
      state = 0;
 618:	4981                	li	s3,0
 61a:	b5ed                	j	504 <vprintf+0x42>
          s = "(null)";
 61c:	00000917          	auipc	s2,0x0
 620:	28490913          	addi	s2,s2,644 # 8a0 <malloc+0x128>
        while(*s != 0){
 624:	02800593          	li	a1,40
 628:	bff1                	j	604 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 62a:	008b8913          	addi	s2,s7,8
 62e:	000bc583          	lbu	a1,0(s7)
 632:	8556                	mv	a0,s5
 634:	00000097          	auipc	ra,0x0
 638:	dd2080e7          	jalr	-558(ra) # 406 <putc>
 63c:	8bca                	mv	s7,s2
      state = 0;
 63e:	4981                	li	s3,0
 640:	b5d1                	j	504 <vprintf+0x42>
        putc(fd, c);
 642:	02500593          	li	a1,37
 646:	8556                	mv	a0,s5
 648:	00000097          	auipc	ra,0x0
 64c:	dbe080e7          	jalr	-578(ra) # 406 <putc>
      state = 0;
 650:	4981                	li	s3,0
 652:	bd4d                	j	504 <vprintf+0x42>
        putc(fd, '%');
 654:	02500593          	li	a1,37
 658:	8556                	mv	a0,s5
 65a:	00000097          	auipc	ra,0x0
 65e:	dac080e7          	jalr	-596(ra) # 406 <putc>
        putc(fd, c);
 662:	85ca                	mv	a1,s2
 664:	8556                	mv	a0,s5
 666:	00000097          	auipc	ra,0x0
 66a:	da0080e7          	jalr	-608(ra) # 406 <putc>
      state = 0;
 66e:	4981                	li	s3,0
 670:	bd51                	j	504 <vprintf+0x42>
        s = va_arg(ap, char*);
 672:	8bce                	mv	s7,s3
      state = 0;
 674:	4981                	li	s3,0
 676:	b579                	j	504 <vprintf+0x42>
 678:	74e2                	ld	s1,56(sp)
 67a:	79a2                	ld	s3,40(sp)
 67c:	7a02                	ld	s4,32(sp)
 67e:	6ae2                	ld	s5,24(sp)
 680:	6b42                	ld	s6,16(sp)
 682:	6ba2                	ld	s7,8(sp)
    }
  }
}
 684:	60a6                	ld	ra,72(sp)
 686:	6406                	ld	s0,64(sp)
 688:	7942                	ld	s2,48(sp)
 68a:	6161                	addi	sp,sp,80
 68c:	8082                	ret

000000000000068e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 68e:	715d                	addi	sp,sp,-80
 690:	ec06                	sd	ra,24(sp)
 692:	e822                	sd	s0,16(sp)
 694:	1000                	addi	s0,sp,32
 696:	e010                	sd	a2,0(s0)
 698:	e414                	sd	a3,8(s0)
 69a:	e818                	sd	a4,16(s0)
 69c:	ec1c                	sd	a5,24(s0)
 69e:	03043023          	sd	a6,32(s0)
 6a2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6a6:	8622                	mv	a2,s0
 6a8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6ac:	00000097          	auipc	ra,0x0
 6b0:	e16080e7          	jalr	-490(ra) # 4c2 <vprintf>
}
 6b4:	60e2                	ld	ra,24(sp)
 6b6:	6442                	ld	s0,16(sp)
 6b8:	6161                	addi	sp,sp,80
 6ba:	8082                	ret

00000000000006bc <printf>:

void
printf(const char *fmt, ...)
{
 6bc:	711d                	addi	sp,sp,-96
 6be:	ec06                	sd	ra,24(sp)
 6c0:	e822                	sd	s0,16(sp)
 6c2:	1000                	addi	s0,sp,32
 6c4:	e40c                	sd	a1,8(s0)
 6c6:	e810                	sd	a2,16(s0)
 6c8:	ec14                	sd	a3,24(s0)
 6ca:	f018                	sd	a4,32(s0)
 6cc:	f41c                	sd	a5,40(s0)
 6ce:	03043823          	sd	a6,48(s0)
 6d2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6d6:	00840613          	addi	a2,s0,8
 6da:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6de:	85aa                	mv	a1,a0
 6e0:	4505                	li	a0,1
 6e2:	00000097          	auipc	ra,0x0
 6e6:	de0080e7          	jalr	-544(ra) # 4c2 <vprintf>
}
 6ea:	60e2                	ld	ra,24(sp)
 6ec:	6442                	ld	s0,16(sp)
 6ee:	6125                	addi	sp,sp,96
 6f0:	8082                	ret

00000000000006f2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6f2:	1141                	addi	sp,sp,-16
 6f4:	e406                	sd	ra,8(sp)
 6f6:	e022                	sd	s0,0(sp)
 6f8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6fa:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6fe:	00001797          	auipc	a5,0x1
 702:	9027b783          	ld	a5,-1790(a5) # 1000 <freep>
 706:	a02d                	j	730 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 708:	4618                	lw	a4,8(a2)
 70a:	9f2d                	addw	a4,a4,a1
 70c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 710:	6398                	ld	a4,0(a5)
 712:	6310                	ld	a2,0(a4)
 714:	a83d                	j	752 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 716:	ff852703          	lw	a4,-8(a0)
 71a:	9f31                	addw	a4,a4,a2
 71c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 71e:	ff053683          	ld	a3,-16(a0)
 722:	a091                	j	766 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 724:	6398                	ld	a4,0(a5)
 726:	00e7e463          	bltu	a5,a4,72e <free+0x3c>
 72a:	00e6ea63          	bltu	a3,a4,73e <free+0x4c>
{
 72e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 730:	fed7fae3          	bgeu	a5,a3,724 <free+0x32>
 734:	6398                	ld	a4,0(a5)
 736:	00e6e463          	bltu	a3,a4,73e <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 73a:	fee7eae3          	bltu	a5,a4,72e <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 73e:	ff852583          	lw	a1,-8(a0)
 742:	6390                	ld	a2,0(a5)
 744:	02059813          	slli	a6,a1,0x20
 748:	01c85713          	srli	a4,a6,0x1c
 74c:	9736                	add	a4,a4,a3
 74e:	fae60de3          	beq	a2,a4,708 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 752:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 756:	4790                	lw	a2,8(a5)
 758:	02061593          	slli	a1,a2,0x20
 75c:	01c5d713          	srli	a4,a1,0x1c
 760:	973e                	add	a4,a4,a5
 762:	fae68ae3          	beq	a3,a4,716 <free+0x24>
    p->s.ptr = bp->s.ptr;
 766:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 768:	00001717          	auipc	a4,0x1
 76c:	88f73c23          	sd	a5,-1896(a4) # 1000 <freep>
}
 770:	60a2                	ld	ra,8(sp)
 772:	6402                	ld	s0,0(sp)
 774:	0141                	addi	sp,sp,16
 776:	8082                	ret

0000000000000778 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 778:	7139                	addi	sp,sp,-64
 77a:	fc06                	sd	ra,56(sp)
 77c:	f822                	sd	s0,48(sp)
 77e:	f04a                	sd	s2,32(sp)
 780:	ec4e                	sd	s3,24(sp)
 782:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 784:	02051993          	slli	s3,a0,0x20
 788:	0209d993          	srli	s3,s3,0x20
 78c:	09bd                	addi	s3,s3,15
 78e:	0049d993          	srli	s3,s3,0x4
 792:	2985                	addiw	s3,s3,1
 794:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 796:	00001517          	auipc	a0,0x1
 79a:	86a53503          	ld	a0,-1942(a0) # 1000 <freep>
 79e:	c905                	beqz	a0,7ce <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7a2:	4798                	lw	a4,8(a5)
 7a4:	09377a63          	bgeu	a4,s3,838 <malloc+0xc0>
 7a8:	f426                	sd	s1,40(sp)
 7aa:	e852                	sd	s4,16(sp)
 7ac:	e456                	sd	s5,8(sp)
 7ae:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7b0:	8a4e                	mv	s4,s3
 7b2:	6705                	lui	a4,0x1
 7b4:	00e9f363          	bgeu	s3,a4,7ba <malloc+0x42>
 7b8:	6a05                	lui	s4,0x1
 7ba:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7be:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7c2:	00001497          	auipc	s1,0x1
 7c6:	83e48493          	addi	s1,s1,-1986 # 1000 <freep>
  if(p == (char*)-1)
 7ca:	5afd                	li	s5,-1
 7cc:	a089                	j	80e <malloc+0x96>
 7ce:	f426                	sd	s1,40(sp)
 7d0:	e852                	sd	s4,16(sp)
 7d2:	e456                	sd	s5,8(sp)
 7d4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7d6:	00001797          	auipc	a5,0x1
 7da:	83a78793          	addi	a5,a5,-1990 # 1010 <base>
 7de:	00001717          	auipc	a4,0x1
 7e2:	82f73123          	sd	a5,-2014(a4) # 1000 <freep>
 7e6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7e8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7ec:	b7d1                	j	7b0 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 7ee:	6398                	ld	a4,0(a5)
 7f0:	e118                	sd	a4,0(a0)
 7f2:	a8b9                	j	850 <malloc+0xd8>
  hp->s.size = nu;
 7f4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7f8:	0541                	addi	a0,a0,16
 7fa:	00000097          	auipc	ra,0x0
 7fe:	ef8080e7          	jalr	-264(ra) # 6f2 <free>
  return freep;
 802:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 804:	c135                	beqz	a0,868 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 806:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 808:	4798                	lw	a4,8(a5)
 80a:	03277363          	bgeu	a4,s2,830 <malloc+0xb8>
    if(p == freep)
 80e:	6098                	ld	a4,0(s1)
 810:	853e                	mv	a0,a5
 812:	fef71ae3          	bne	a4,a5,806 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 816:	8552                	mv	a0,s4
 818:	00000097          	auipc	ra,0x0
 81c:	bae080e7          	jalr	-1106(ra) # 3c6 <sbrk>
  if(p == (char*)-1)
 820:	fd551ae3          	bne	a0,s5,7f4 <malloc+0x7c>
        return 0;
 824:	4501                	li	a0,0
 826:	74a2                	ld	s1,40(sp)
 828:	6a42                	ld	s4,16(sp)
 82a:	6aa2                	ld	s5,8(sp)
 82c:	6b02                	ld	s6,0(sp)
 82e:	a03d                	j	85c <malloc+0xe4>
 830:	74a2                	ld	s1,40(sp)
 832:	6a42                	ld	s4,16(sp)
 834:	6aa2                	ld	s5,8(sp)
 836:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 838:	fae90be3          	beq	s2,a4,7ee <malloc+0x76>
        p->s.size -= nunits;
 83c:	4137073b          	subw	a4,a4,s3
 840:	c798                	sw	a4,8(a5)
        p += p->s.size;
 842:	02071693          	slli	a3,a4,0x20
 846:	01c6d713          	srli	a4,a3,0x1c
 84a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 84c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 850:	00000717          	auipc	a4,0x0
 854:	7aa73823          	sd	a0,1968(a4) # 1000 <freep>
      return (void*)(p + 1);
 858:	01078513          	addi	a0,a5,16
  }
}
 85c:	70e2                	ld	ra,56(sp)
 85e:	7442                	ld	s0,48(sp)
 860:	7902                	ld	s2,32(sp)
 862:	69e2                	ld	s3,24(sp)
 864:	6121                	addi	sp,sp,64
 866:	8082                	ret
 868:	74a2                	ld	s1,40(sp)
 86a:	6a42                	ld	s4,16(sp)
 86c:	6aa2                	ld	s5,8(sp)
 86e:	6b02                	ld	s6,0(sp)
 870:	b7f5                	j	85c <malloc+0xe4>
