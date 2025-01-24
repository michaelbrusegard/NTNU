
user/_forktest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print>:

#define N  1000

void
print(const char *s)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
   8:	fea43423          	sd	a0,-24(s0)
  write(1, s, strlen(s));
   c:	fe843503          	ld	a0,-24(s0)
  10:	00000097          	auipc	ra,0x0
  14:	226080e7          	jalr	550(ra) # 236 <strlen>
  18:	87aa                	mv	a5,a0
  1a:	863e                	mv	a2,a5
  1c:	fe843583          	ld	a1,-24(s0)
  20:	4505                	li	a0,1
  22:	00000097          	auipc	ra,0x0
  26:	62c080e7          	jalr	1580(ra) # 64e <write>
}
  2a:	0001                	nop
  2c:	60e2                	ld	ra,24(sp)
  2e:	6442                	ld	s0,16(sp)
  30:	6105                	addi	sp,sp,32
  32:	8082                	ret

0000000000000034 <forktest>:

void
forktest(void)
{
  34:	1101                	addi	sp,sp,-32
  36:	ec06                	sd	ra,24(sp)
  38:	e822                	sd	s0,16(sp)
  3a:	1000                	addi	s0,sp,32
  int n, pid;

  print("fork test\n");
  3c:	00000517          	auipc	a0,0x0
  40:	69c50513          	addi	a0,a0,1692 # 6d8 <ps+0xa>
  44:	00000097          	auipc	ra,0x0
  48:	fbc080e7          	jalr	-68(ra) # 0 <print>

  for(n=0; n<N; n++){
  4c:	fe042623          	sw	zero,-20(s0)
  50:	a81d                	j	86 <forktest+0x52>
    pid = fork();
  52:	00000097          	auipc	ra,0x0
  56:	5d4080e7          	jalr	1492(ra) # 626 <fork>
  5a:	87aa                	mv	a5,a0
  5c:	fef42423          	sw	a5,-24(s0)
    if(pid < 0)
  60:	fe842783          	lw	a5,-24(s0)
  64:	2781                	sext.w	a5,a5
  66:	0207c963          	bltz	a5,98 <forktest+0x64>
      break;
    if(pid == 0)
  6a:	fe842783          	lw	a5,-24(s0)
  6e:	2781                	sext.w	a5,a5
  70:	e791                	bnez	a5,7c <forktest+0x48>
      exit(0);
  72:	4501                	li	a0,0
  74:	00000097          	auipc	ra,0x0
  78:	5ba080e7          	jalr	1466(ra) # 62e <exit>
  for(n=0; n<N; n++){
  7c:	fec42783          	lw	a5,-20(s0)
  80:	2785                	addiw	a5,a5,1
  82:	fef42623          	sw	a5,-20(s0)
  86:	fec42783          	lw	a5,-20(s0)
  8a:	0007871b          	sext.w	a4,a5
  8e:	3e700793          	li	a5,999
  92:	fce7d0e3          	bge	a5,a4,52 <forktest+0x1e>
  96:	a011                	j	9a <forktest+0x66>
      break;
  98:	0001                	nop
  }

  if(n == N){
  9a:	fec42783          	lw	a5,-20(s0)
  9e:	0007871b          	sext.w	a4,a5
  a2:	3e800793          	li	a5,1000
  a6:	04f71963          	bne	a4,a5,f8 <forktest+0xc4>
    print("fork claimed to work N times!\n");
  aa:	00000517          	auipc	a0,0x0
  ae:	63e50513          	addi	a0,a0,1598 # 6e8 <ps+0x1a>
  b2:	00000097          	auipc	ra,0x0
  b6:	f4e080e7          	jalr	-178(ra) # 0 <print>
    exit(1);
  ba:	4505                	li	a0,1
  bc:	00000097          	auipc	ra,0x0
  c0:	572080e7          	jalr	1394(ra) # 62e <exit>
  }

  for(; n > 0; n--){
    if(wait(0) < 0){
  c4:	4501                	li	a0,0
  c6:	00000097          	auipc	ra,0x0
  ca:	570080e7          	jalr	1392(ra) # 636 <wait>
  ce:	87aa                	mv	a5,a0
  d0:	0007df63          	bgez	a5,ee <forktest+0xba>
      print("wait stopped early\n");
  d4:	00000517          	auipc	a0,0x0
  d8:	63450513          	addi	a0,a0,1588 # 708 <ps+0x3a>
  dc:	00000097          	auipc	ra,0x0
  e0:	f24080e7          	jalr	-220(ra) # 0 <print>
      exit(1);
  e4:	4505                	li	a0,1
  e6:	00000097          	auipc	ra,0x0
  ea:	548080e7          	jalr	1352(ra) # 62e <exit>
  for(; n > 0; n--){
  ee:	fec42783          	lw	a5,-20(s0)
  f2:	37fd                	addiw	a5,a5,-1
  f4:	fef42623          	sw	a5,-20(s0)
  f8:	fec42783          	lw	a5,-20(s0)
  fc:	2781                	sext.w	a5,a5
  fe:	fcf043e3          	bgtz	a5,c4 <forktest+0x90>
    }
  }

  if(wait(0) != -1){
 102:	4501                	li	a0,0
 104:	00000097          	auipc	ra,0x0
 108:	532080e7          	jalr	1330(ra) # 636 <wait>
 10c:	87aa                	mv	a5,a0
 10e:	873e                	mv	a4,a5
 110:	57fd                	li	a5,-1
 112:	00f70f63          	beq	a4,a5,130 <forktest+0xfc>
    print("wait got too many\n");
 116:	00000517          	auipc	a0,0x0
 11a:	60a50513          	addi	a0,a0,1546 # 720 <ps+0x52>
 11e:	00000097          	auipc	ra,0x0
 122:	ee2080e7          	jalr	-286(ra) # 0 <print>
    exit(1);
 126:	4505                	li	a0,1
 128:	00000097          	auipc	ra,0x0
 12c:	506080e7          	jalr	1286(ra) # 62e <exit>
  }

  print("fork test OK\n");
 130:	00000517          	auipc	a0,0x0
 134:	60850513          	addi	a0,a0,1544 # 738 <ps+0x6a>
 138:	00000097          	auipc	ra,0x0
 13c:	ec8080e7          	jalr	-312(ra) # 0 <print>
}
 140:	0001                	nop
 142:	60e2                	ld	ra,24(sp)
 144:	6442                	ld	s0,16(sp)
 146:	6105                	addi	sp,sp,32
 148:	8082                	ret

000000000000014a <main>:

int
main(void)
{
 14a:	1141                	addi	sp,sp,-16
 14c:	e406                	sd	ra,8(sp)
 14e:	e022                	sd	s0,0(sp)
 150:	0800                	addi	s0,sp,16
  forktest();
 152:	00000097          	auipc	ra,0x0
 156:	ee2080e7          	jalr	-286(ra) # 34 <forktest>
  exit(0);
 15a:	4501                	li	a0,0
 15c:	00000097          	auipc	ra,0x0
 160:	4d2080e7          	jalr	1234(ra) # 62e <exit>

0000000000000164 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 164:	1141                	addi	sp,sp,-16
 166:	e406                	sd	ra,8(sp)
 168:	e022                	sd	s0,0(sp)
 16a:	0800                	addi	s0,sp,16
  extern int main();
  main();
 16c:	00000097          	auipc	ra,0x0
 170:	fde080e7          	jalr	-34(ra) # 14a <main>
  exit(0);
 174:	4501                	li	a0,0
 176:	00000097          	auipc	ra,0x0
 17a:	4b8080e7          	jalr	1208(ra) # 62e <exit>

000000000000017e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 17e:	7179                	addi	sp,sp,-48
 180:	f406                	sd	ra,40(sp)
 182:	f022                	sd	s0,32(sp)
 184:	1800                	addi	s0,sp,48
 186:	fca43c23          	sd	a0,-40(s0)
 18a:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
 18e:	fd843783          	ld	a5,-40(s0)
 192:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
 196:	0001                	nop
 198:	fd043703          	ld	a4,-48(s0)
 19c:	00170793          	addi	a5,a4,1
 1a0:	fcf43823          	sd	a5,-48(s0)
 1a4:	fd843783          	ld	a5,-40(s0)
 1a8:	00178693          	addi	a3,a5,1
 1ac:	fcd43c23          	sd	a3,-40(s0)
 1b0:	00074703          	lbu	a4,0(a4)
 1b4:	00e78023          	sb	a4,0(a5)
 1b8:	0007c783          	lbu	a5,0(a5)
 1bc:	fff1                	bnez	a5,198 <strcpy+0x1a>
    ;
  return os;
 1be:	fe843783          	ld	a5,-24(s0)
}
 1c2:	853e                	mv	a0,a5
 1c4:	70a2                	ld	ra,40(sp)
 1c6:	7402                	ld	s0,32(sp)
 1c8:	6145                	addi	sp,sp,48
 1ca:	8082                	ret

00000000000001cc <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1cc:	1101                	addi	sp,sp,-32
 1ce:	ec06                	sd	ra,24(sp)
 1d0:	e822                	sd	s0,16(sp)
 1d2:	1000                	addi	s0,sp,32
 1d4:	fea43423          	sd	a0,-24(s0)
 1d8:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
 1dc:	a819                	j	1f2 <strcmp+0x26>
    p++, q++;
 1de:	fe843783          	ld	a5,-24(s0)
 1e2:	0785                	addi	a5,a5,1
 1e4:	fef43423          	sd	a5,-24(s0)
 1e8:	fe043783          	ld	a5,-32(s0)
 1ec:	0785                	addi	a5,a5,1
 1ee:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
 1f2:	fe843783          	ld	a5,-24(s0)
 1f6:	0007c783          	lbu	a5,0(a5)
 1fa:	cb99                	beqz	a5,210 <strcmp+0x44>
 1fc:	fe843783          	ld	a5,-24(s0)
 200:	0007c703          	lbu	a4,0(a5)
 204:	fe043783          	ld	a5,-32(s0)
 208:	0007c783          	lbu	a5,0(a5)
 20c:	fcf709e3          	beq	a4,a5,1de <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
 210:	fe843783          	ld	a5,-24(s0)
 214:	0007c783          	lbu	a5,0(a5)
 218:	0007871b          	sext.w	a4,a5
 21c:	fe043783          	ld	a5,-32(s0)
 220:	0007c783          	lbu	a5,0(a5)
 224:	2781                	sext.w	a5,a5
 226:	40f707bb          	subw	a5,a4,a5
 22a:	2781                	sext.w	a5,a5
}
 22c:	853e                	mv	a0,a5
 22e:	60e2                	ld	ra,24(sp)
 230:	6442                	ld	s0,16(sp)
 232:	6105                	addi	sp,sp,32
 234:	8082                	ret

0000000000000236 <strlen>:

uint
strlen(const char *s)
{
 236:	7179                	addi	sp,sp,-48
 238:	f406                	sd	ra,40(sp)
 23a:	f022                	sd	s0,32(sp)
 23c:	1800                	addi	s0,sp,48
 23e:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
 242:	fe042623          	sw	zero,-20(s0)
 246:	a031                	j	252 <strlen+0x1c>
 248:	fec42783          	lw	a5,-20(s0)
 24c:	2785                	addiw	a5,a5,1
 24e:	fef42623          	sw	a5,-20(s0)
 252:	fec42783          	lw	a5,-20(s0)
 256:	fd843703          	ld	a4,-40(s0)
 25a:	97ba                	add	a5,a5,a4
 25c:	0007c783          	lbu	a5,0(a5)
 260:	f7e5                	bnez	a5,248 <strlen+0x12>
    ;
  return n;
 262:	fec42783          	lw	a5,-20(s0)
}
 266:	853e                	mv	a0,a5
 268:	70a2                	ld	ra,40(sp)
 26a:	7402                	ld	s0,32(sp)
 26c:	6145                	addi	sp,sp,48
 26e:	8082                	ret

0000000000000270 <memset>:

void*
memset(void *dst, int c, uint n)
{
 270:	7179                	addi	sp,sp,-48
 272:	f406                	sd	ra,40(sp)
 274:	f022                	sd	s0,32(sp)
 276:	1800                	addi	s0,sp,48
 278:	fca43c23          	sd	a0,-40(s0)
 27c:	87ae                	mv	a5,a1
 27e:	8732                	mv	a4,a2
 280:	fcf42a23          	sw	a5,-44(s0)
 284:	87ba                	mv	a5,a4
 286:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
 28a:	fd843783          	ld	a5,-40(s0)
 28e:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
 292:	fe042623          	sw	zero,-20(s0)
 296:	a00d                	j	2b8 <memset+0x48>
    cdst[i] = c;
 298:	fec42783          	lw	a5,-20(s0)
 29c:	fe043703          	ld	a4,-32(s0)
 2a0:	97ba                	add	a5,a5,a4
 2a2:	fd442703          	lw	a4,-44(s0)
 2a6:	0ff77713          	zext.b	a4,a4
 2aa:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
 2ae:	fec42783          	lw	a5,-20(s0)
 2b2:	2785                	addiw	a5,a5,1
 2b4:	fef42623          	sw	a5,-20(s0)
 2b8:	fec42783          	lw	a5,-20(s0)
 2bc:	fd042703          	lw	a4,-48(s0)
 2c0:	2701                	sext.w	a4,a4
 2c2:	fce7ebe3          	bltu	a5,a4,298 <memset+0x28>
  }
  return dst;
 2c6:	fd843783          	ld	a5,-40(s0)
}
 2ca:	853e                	mv	a0,a5
 2cc:	70a2                	ld	ra,40(sp)
 2ce:	7402                	ld	s0,32(sp)
 2d0:	6145                	addi	sp,sp,48
 2d2:	8082                	ret

00000000000002d4 <strchr>:

char*
strchr(const char *s, char c)
{
 2d4:	1101                	addi	sp,sp,-32
 2d6:	ec06                	sd	ra,24(sp)
 2d8:	e822                	sd	s0,16(sp)
 2da:	1000                	addi	s0,sp,32
 2dc:	fea43423          	sd	a0,-24(s0)
 2e0:	87ae                	mv	a5,a1
 2e2:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
 2e6:	a01d                	j	30c <strchr+0x38>
    if(*s == c)
 2e8:	fe843783          	ld	a5,-24(s0)
 2ec:	0007c703          	lbu	a4,0(a5)
 2f0:	fe744783          	lbu	a5,-25(s0)
 2f4:	0ff7f793          	zext.b	a5,a5
 2f8:	00e79563          	bne	a5,a4,302 <strchr+0x2e>
      return (char*)s;
 2fc:	fe843783          	ld	a5,-24(s0)
 300:	a821                	j	318 <strchr+0x44>
  for(; *s; s++)
 302:	fe843783          	ld	a5,-24(s0)
 306:	0785                	addi	a5,a5,1
 308:	fef43423          	sd	a5,-24(s0)
 30c:	fe843783          	ld	a5,-24(s0)
 310:	0007c783          	lbu	a5,0(a5)
 314:	fbf1                	bnez	a5,2e8 <strchr+0x14>
  return 0;
 316:	4781                	li	a5,0
}
 318:	853e                	mv	a0,a5
 31a:	60e2                	ld	ra,24(sp)
 31c:	6442                	ld	s0,16(sp)
 31e:	6105                	addi	sp,sp,32
 320:	8082                	ret

0000000000000322 <gets>:

char*
gets(char *buf, int max)
{
 322:	7179                	addi	sp,sp,-48
 324:	f406                	sd	ra,40(sp)
 326:	f022                	sd	s0,32(sp)
 328:	1800                	addi	s0,sp,48
 32a:	fca43c23          	sd	a0,-40(s0)
 32e:	87ae                	mv	a5,a1
 330:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 334:	fe042623          	sw	zero,-20(s0)
 338:	a8a1                	j	390 <gets+0x6e>
    cc = read(0, &c, 1);
 33a:	fe740793          	addi	a5,s0,-25
 33e:	4605                	li	a2,1
 340:	85be                	mv	a1,a5
 342:	4501                	li	a0,0
 344:	00000097          	auipc	ra,0x0
 348:	302080e7          	jalr	770(ra) # 646 <read>
 34c:	87aa                	mv	a5,a0
 34e:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
 352:	fe842783          	lw	a5,-24(s0)
 356:	2781                	sext.w	a5,a5
 358:	04f05663          	blez	a5,3a4 <gets+0x82>
      break;
    buf[i++] = c;
 35c:	fec42783          	lw	a5,-20(s0)
 360:	0017871b          	addiw	a4,a5,1
 364:	fee42623          	sw	a4,-20(s0)
 368:	873e                	mv	a4,a5
 36a:	fd843783          	ld	a5,-40(s0)
 36e:	97ba                	add	a5,a5,a4
 370:	fe744703          	lbu	a4,-25(s0)
 374:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
 378:	fe744783          	lbu	a5,-25(s0)
 37c:	873e                	mv	a4,a5
 37e:	47a9                	li	a5,10
 380:	02f70363          	beq	a4,a5,3a6 <gets+0x84>
 384:	fe744783          	lbu	a5,-25(s0)
 388:	873e                	mv	a4,a5
 38a:	47b5                	li	a5,13
 38c:	00f70d63          	beq	a4,a5,3a6 <gets+0x84>
  for(i=0; i+1 < max; ){
 390:	fec42783          	lw	a5,-20(s0)
 394:	2785                	addiw	a5,a5,1
 396:	2781                	sext.w	a5,a5
 398:	fd442703          	lw	a4,-44(s0)
 39c:	2701                	sext.w	a4,a4
 39e:	f8e7cee3          	blt	a5,a4,33a <gets+0x18>
 3a2:	a011                	j	3a6 <gets+0x84>
      break;
 3a4:	0001                	nop
      break;
  }
  buf[i] = '\0';
 3a6:	fec42783          	lw	a5,-20(s0)
 3aa:	fd843703          	ld	a4,-40(s0)
 3ae:	97ba                	add	a5,a5,a4
 3b0:	00078023          	sb	zero,0(a5)
  return buf;
 3b4:	fd843783          	ld	a5,-40(s0)
}
 3b8:	853e                	mv	a0,a5
 3ba:	70a2                	ld	ra,40(sp)
 3bc:	7402                	ld	s0,32(sp)
 3be:	6145                	addi	sp,sp,48
 3c0:	8082                	ret

00000000000003c2 <stat>:

int
stat(const char *n, struct stat *st)
{
 3c2:	7179                	addi	sp,sp,-48
 3c4:	f406                	sd	ra,40(sp)
 3c6:	f022                	sd	s0,32(sp)
 3c8:	1800                	addi	s0,sp,48
 3ca:	fca43c23          	sd	a0,-40(s0)
 3ce:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3d2:	4581                	li	a1,0
 3d4:	fd843503          	ld	a0,-40(s0)
 3d8:	00000097          	auipc	ra,0x0
 3dc:	296080e7          	jalr	662(ra) # 66e <open>
 3e0:	87aa                	mv	a5,a0
 3e2:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
 3e6:	fec42783          	lw	a5,-20(s0)
 3ea:	2781                	sext.w	a5,a5
 3ec:	0007d463          	bgez	a5,3f4 <stat+0x32>
    return -1;
 3f0:	57fd                	li	a5,-1
 3f2:	a035                	j	41e <stat+0x5c>
  r = fstat(fd, st);
 3f4:	fec42783          	lw	a5,-20(s0)
 3f8:	fd043583          	ld	a1,-48(s0)
 3fc:	853e                	mv	a0,a5
 3fe:	00000097          	auipc	ra,0x0
 402:	288080e7          	jalr	648(ra) # 686 <fstat>
 406:	87aa                	mv	a5,a0
 408:	fef42423          	sw	a5,-24(s0)
  close(fd);
 40c:	fec42783          	lw	a5,-20(s0)
 410:	853e                	mv	a0,a5
 412:	00000097          	auipc	ra,0x0
 416:	244080e7          	jalr	580(ra) # 656 <close>
  return r;
 41a:	fe842783          	lw	a5,-24(s0)
}
 41e:	853e                	mv	a0,a5
 420:	70a2                	ld	ra,40(sp)
 422:	7402                	ld	s0,32(sp)
 424:	6145                	addi	sp,sp,48
 426:	8082                	ret

0000000000000428 <atoi>:

int
atoi(const char *s)
{
 428:	7179                	addi	sp,sp,-48
 42a:	f406                	sd	ra,40(sp)
 42c:	f022                	sd	s0,32(sp)
 42e:	1800                	addi	s0,sp,48
 430:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
 434:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
 438:	a81d                	j	46e <atoi+0x46>
    n = n*10 + *s++ - '0';
 43a:	fec42783          	lw	a5,-20(s0)
 43e:	873e                	mv	a4,a5
 440:	87ba                	mv	a5,a4
 442:	0027979b          	slliw	a5,a5,0x2
 446:	9fb9                	addw	a5,a5,a4
 448:	0017979b          	slliw	a5,a5,0x1
 44c:	0007871b          	sext.w	a4,a5
 450:	fd843783          	ld	a5,-40(s0)
 454:	00178693          	addi	a3,a5,1
 458:	fcd43c23          	sd	a3,-40(s0)
 45c:	0007c783          	lbu	a5,0(a5)
 460:	2781                	sext.w	a5,a5
 462:	9fb9                	addw	a5,a5,a4
 464:	2781                	sext.w	a5,a5
 466:	fd07879b          	addiw	a5,a5,-48
 46a:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
 46e:	fd843783          	ld	a5,-40(s0)
 472:	0007c783          	lbu	a5,0(a5)
 476:	873e                	mv	a4,a5
 478:	02f00793          	li	a5,47
 47c:	00e7fb63          	bgeu	a5,a4,492 <atoi+0x6a>
 480:	fd843783          	ld	a5,-40(s0)
 484:	0007c783          	lbu	a5,0(a5)
 488:	873e                	mv	a4,a5
 48a:	03900793          	li	a5,57
 48e:	fae7f6e3          	bgeu	a5,a4,43a <atoi+0x12>
  return n;
 492:	fec42783          	lw	a5,-20(s0)
}
 496:	853e                	mv	a0,a5
 498:	70a2                	ld	ra,40(sp)
 49a:	7402                	ld	s0,32(sp)
 49c:	6145                	addi	sp,sp,48
 49e:	8082                	ret

00000000000004a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4a0:	7139                	addi	sp,sp,-64
 4a2:	fc06                	sd	ra,56(sp)
 4a4:	f822                	sd	s0,48(sp)
 4a6:	0080                	addi	s0,sp,64
 4a8:	fca43c23          	sd	a0,-40(s0)
 4ac:	fcb43823          	sd	a1,-48(s0)
 4b0:	87b2                	mv	a5,a2
 4b2:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
 4b6:	fd843783          	ld	a5,-40(s0)
 4ba:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
 4be:	fd043783          	ld	a5,-48(s0)
 4c2:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
 4c6:	fe043703          	ld	a4,-32(s0)
 4ca:	fe843783          	ld	a5,-24(s0)
 4ce:	02e7fc63          	bgeu	a5,a4,506 <memmove+0x66>
    while(n-- > 0)
 4d2:	a00d                	j	4f4 <memmove+0x54>
      *dst++ = *src++;
 4d4:	fe043703          	ld	a4,-32(s0)
 4d8:	00170793          	addi	a5,a4,1
 4dc:	fef43023          	sd	a5,-32(s0)
 4e0:	fe843783          	ld	a5,-24(s0)
 4e4:	00178693          	addi	a3,a5,1
 4e8:	fed43423          	sd	a3,-24(s0)
 4ec:	00074703          	lbu	a4,0(a4)
 4f0:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 4f4:	fcc42783          	lw	a5,-52(s0)
 4f8:	fff7871b          	addiw	a4,a5,-1
 4fc:	fce42623          	sw	a4,-52(s0)
 500:	fcf04ae3          	bgtz	a5,4d4 <memmove+0x34>
 504:	a891                	j	558 <memmove+0xb8>
  } else {
    dst += n;
 506:	fcc42783          	lw	a5,-52(s0)
 50a:	fe843703          	ld	a4,-24(s0)
 50e:	97ba                	add	a5,a5,a4
 510:	fef43423          	sd	a5,-24(s0)
    src += n;
 514:	fcc42783          	lw	a5,-52(s0)
 518:	fe043703          	ld	a4,-32(s0)
 51c:	97ba                	add	a5,a5,a4
 51e:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
 522:	a01d                	j	548 <memmove+0xa8>
      *--dst = *--src;
 524:	fe043783          	ld	a5,-32(s0)
 528:	17fd                	addi	a5,a5,-1
 52a:	fef43023          	sd	a5,-32(s0)
 52e:	fe843783          	ld	a5,-24(s0)
 532:	17fd                	addi	a5,a5,-1
 534:	fef43423          	sd	a5,-24(s0)
 538:	fe043783          	ld	a5,-32(s0)
 53c:	0007c703          	lbu	a4,0(a5)
 540:	fe843783          	ld	a5,-24(s0)
 544:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 548:	fcc42783          	lw	a5,-52(s0)
 54c:	fff7871b          	addiw	a4,a5,-1
 550:	fce42623          	sw	a4,-52(s0)
 554:	fcf048e3          	bgtz	a5,524 <memmove+0x84>
  }
  return vdst;
 558:	fd843783          	ld	a5,-40(s0)
}
 55c:	853e                	mv	a0,a5
 55e:	70e2                	ld	ra,56(sp)
 560:	7442                	ld	s0,48(sp)
 562:	6121                	addi	sp,sp,64
 564:	8082                	ret

0000000000000566 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 566:	7139                	addi	sp,sp,-64
 568:	fc06                	sd	ra,56(sp)
 56a:	f822                	sd	s0,48(sp)
 56c:	0080                	addi	s0,sp,64
 56e:	fca43c23          	sd	a0,-40(s0)
 572:	fcb43823          	sd	a1,-48(s0)
 576:	87b2                	mv	a5,a2
 578:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
 57c:	fd843783          	ld	a5,-40(s0)
 580:	fef43423          	sd	a5,-24(s0)
 584:	fd043783          	ld	a5,-48(s0)
 588:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 58c:	a0a1                	j	5d4 <memcmp+0x6e>
    if (*p1 != *p2) {
 58e:	fe843783          	ld	a5,-24(s0)
 592:	0007c703          	lbu	a4,0(a5)
 596:	fe043783          	ld	a5,-32(s0)
 59a:	0007c783          	lbu	a5,0(a5)
 59e:	02f70163          	beq	a4,a5,5c0 <memcmp+0x5a>
      return *p1 - *p2;
 5a2:	fe843783          	ld	a5,-24(s0)
 5a6:	0007c783          	lbu	a5,0(a5)
 5aa:	0007871b          	sext.w	a4,a5
 5ae:	fe043783          	ld	a5,-32(s0)
 5b2:	0007c783          	lbu	a5,0(a5)
 5b6:	2781                	sext.w	a5,a5
 5b8:	40f707bb          	subw	a5,a4,a5
 5bc:	2781                	sext.w	a5,a5
 5be:	a01d                	j	5e4 <memcmp+0x7e>
    }
    p1++;
 5c0:	fe843783          	ld	a5,-24(s0)
 5c4:	0785                	addi	a5,a5,1
 5c6:	fef43423          	sd	a5,-24(s0)
    p2++;
 5ca:	fe043783          	ld	a5,-32(s0)
 5ce:	0785                	addi	a5,a5,1
 5d0:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 5d4:	fcc42783          	lw	a5,-52(s0)
 5d8:	fff7871b          	addiw	a4,a5,-1
 5dc:	fce42623          	sw	a4,-52(s0)
 5e0:	f7dd                	bnez	a5,58e <memcmp+0x28>
  }
  return 0;
 5e2:	4781                	li	a5,0
}
 5e4:	853e                	mv	a0,a5
 5e6:	70e2                	ld	ra,56(sp)
 5e8:	7442                	ld	s0,48(sp)
 5ea:	6121                	addi	sp,sp,64
 5ec:	8082                	ret

00000000000005ee <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 5ee:	7179                	addi	sp,sp,-48
 5f0:	f406                	sd	ra,40(sp)
 5f2:	f022                	sd	s0,32(sp)
 5f4:	1800                	addi	s0,sp,48
 5f6:	fea43423          	sd	a0,-24(s0)
 5fa:	feb43023          	sd	a1,-32(s0)
 5fe:	87b2                	mv	a5,a2
 600:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
 604:	fdc42783          	lw	a5,-36(s0)
 608:	863e                	mv	a2,a5
 60a:	fe043583          	ld	a1,-32(s0)
 60e:	fe843503          	ld	a0,-24(s0)
 612:	00000097          	auipc	ra,0x0
 616:	e8e080e7          	jalr	-370(ra) # 4a0 <memmove>
 61a:	87aa                	mv	a5,a0
}
 61c:	853e                	mv	a0,a5
 61e:	70a2                	ld	ra,40(sp)
 620:	7402                	ld	s0,32(sp)
 622:	6145                	addi	sp,sp,48
 624:	8082                	ret

0000000000000626 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 626:	4885                	li	a7,1
 ecall
 628:	00000073          	ecall
 ret
 62c:	8082                	ret

000000000000062e <exit>:
.global exit
exit:
 li a7, SYS_exit
 62e:	4889                	li	a7,2
 ecall
 630:	00000073          	ecall
 ret
 634:	8082                	ret

0000000000000636 <wait>:
.global wait
wait:
 li a7, SYS_wait
 636:	488d                	li	a7,3
 ecall
 638:	00000073          	ecall
 ret
 63c:	8082                	ret

000000000000063e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 63e:	4891                	li	a7,4
 ecall
 640:	00000073          	ecall
 ret
 644:	8082                	ret

0000000000000646 <read>:
.global read
read:
 li a7, SYS_read
 646:	4895                	li	a7,5
 ecall
 648:	00000073          	ecall
 ret
 64c:	8082                	ret

000000000000064e <write>:
.global write
write:
 li a7, SYS_write
 64e:	48c1                	li	a7,16
 ecall
 650:	00000073          	ecall
 ret
 654:	8082                	ret

0000000000000656 <close>:
.global close
close:
 li a7, SYS_close
 656:	48d5                	li	a7,21
 ecall
 658:	00000073          	ecall
 ret
 65c:	8082                	ret

000000000000065e <kill>:
.global kill
kill:
 li a7, SYS_kill
 65e:	4899                	li	a7,6
 ecall
 660:	00000073          	ecall
 ret
 664:	8082                	ret

0000000000000666 <exec>:
.global exec
exec:
 li a7, SYS_exec
 666:	489d                	li	a7,7
 ecall
 668:	00000073          	ecall
 ret
 66c:	8082                	ret

000000000000066e <open>:
.global open
open:
 li a7, SYS_open
 66e:	48bd                	li	a7,15
 ecall
 670:	00000073          	ecall
 ret
 674:	8082                	ret

0000000000000676 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 676:	48c5                	li	a7,17
 ecall
 678:	00000073          	ecall
 ret
 67c:	8082                	ret

000000000000067e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 67e:	48c9                	li	a7,18
 ecall
 680:	00000073          	ecall
 ret
 684:	8082                	ret

0000000000000686 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 686:	48a1                	li	a7,8
 ecall
 688:	00000073          	ecall
 ret
 68c:	8082                	ret

000000000000068e <link>:
.global link
link:
 li a7, SYS_link
 68e:	48cd                	li	a7,19
 ecall
 690:	00000073          	ecall
 ret
 694:	8082                	ret

0000000000000696 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 696:	48d1                	li	a7,20
 ecall
 698:	00000073          	ecall
 ret
 69c:	8082                	ret

000000000000069e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 69e:	48a5                	li	a7,9
 ecall
 6a0:	00000073          	ecall
 ret
 6a4:	8082                	ret

00000000000006a6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 6a6:	48a9                	li	a7,10
 ecall
 6a8:	00000073          	ecall
 ret
 6ac:	8082                	ret

00000000000006ae <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6ae:	48ad                	li	a7,11
 ecall
 6b0:	00000073          	ecall
 ret
 6b4:	8082                	ret

00000000000006b6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6b6:	48b1                	li	a7,12
 ecall
 6b8:	00000073          	ecall
 ret
 6bc:	8082                	ret

00000000000006be <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6be:	48b5                	li	a7,13
 ecall
 6c0:	00000073          	ecall
 ret
 6c4:	8082                	ret

00000000000006c6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6c6:	48b9                	li	a7,14
 ecall
 6c8:	00000073          	ecall
 ret
 6cc:	8082                	ret

00000000000006ce <ps>:
.global ps
ps:
 li a7, SYS_ps
 6ce:	48d9                	li	a7,22
 ecall
 6d0:	00000073          	ecall
 ret
 6d4:	8082                	ret
