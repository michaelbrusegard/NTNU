
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   8:	4589                	li	a1,2
   a:	00001517          	auipc	a0,0x1
   e:	e4e50513          	addi	a0,a0,-434 # e58 <malloc+0x14e>
  12:	00000097          	auipc	ra,0x0
  16:	618080e7          	jalr	1560(ra) # 62a <open>
  1a:	87aa                	mv	a5,a0
  1c:	0207d563          	bgez	a5,46 <main+0x46>
    mknod("console", CONSOLE, 0);
  20:	4601                	li	a2,0
  22:	4585                	li	a1,1
  24:	00001517          	auipc	a0,0x1
  28:	e3450513          	addi	a0,a0,-460 # e58 <malloc+0x14e>
  2c:	00000097          	auipc	ra,0x0
  30:	606080e7          	jalr	1542(ra) # 632 <mknod>
    open("console", O_RDWR);
  34:	4589                	li	a1,2
  36:	00001517          	auipc	a0,0x1
  3a:	e2250513          	addi	a0,a0,-478 # e58 <malloc+0x14e>
  3e:	00000097          	auipc	ra,0x0
  42:	5ec080e7          	jalr	1516(ra) # 62a <open>
  }
  dup(0);  // stdout
  46:	4501                	li	a0,0
  48:	00000097          	auipc	ra,0x0
  4c:	61a080e7          	jalr	1562(ra) # 662 <dup>
  dup(0);  // stderr
  50:	4501                	li	a0,0
  52:	00000097          	auipc	ra,0x0
  56:	610080e7          	jalr	1552(ra) # 662 <dup>

  for(;;){
    printf("init: starting sh\n");
  5a:	00001517          	auipc	a0,0x1
  5e:	e0650513          	addi	a0,a0,-506 # e60 <malloc+0x156>
  62:	00001097          	auipc	ra,0x1
  66:	ab4080e7          	jalr	-1356(ra) # b16 <printf>
    pid = fork();
  6a:	00000097          	auipc	ra,0x0
  6e:	578080e7          	jalr	1400(ra) # 5e2 <fork>
  72:	87aa                	mv	a5,a0
  74:	fef42623          	sw	a5,-20(s0)
    if(pid < 0){
  78:	fec42783          	lw	a5,-20(s0)
  7c:	2781                	sext.w	a5,a5
  7e:	0007df63          	bgez	a5,9c <main+0x9c>
      printf("init: fork failed\n");
  82:	00001517          	auipc	a0,0x1
  86:	df650513          	addi	a0,a0,-522 # e78 <malloc+0x16e>
  8a:	00001097          	auipc	ra,0x1
  8e:	a8c080e7          	jalr	-1396(ra) # b16 <printf>
      exit(1);
  92:	4505                	li	a0,1
  94:	00000097          	auipc	ra,0x0
  98:	556080e7          	jalr	1366(ra) # 5ea <exit>
    }
    if(pid == 0){
  9c:	fec42783          	lw	a5,-20(s0)
  a0:	2781                	sext.w	a5,a5
  a2:	eb95                	bnez	a5,d6 <main+0xd6>
      exec("sh", argv);
  a4:	00001597          	auipc	a1,0x1
  a8:	f5c58593          	addi	a1,a1,-164 # 1000 <argv>
  ac:	00001517          	auipc	a0,0x1
  b0:	da450513          	addi	a0,a0,-604 # e50 <malloc+0x146>
  b4:	00000097          	auipc	ra,0x0
  b8:	56e080e7          	jalr	1390(ra) # 622 <exec>
      printf("init: exec sh failed\n");
  bc:	00001517          	auipc	a0,0x1
  c0:	dd450513          	addi	a0,a0,-556 # e90 <malloc+0x186>
  c4:	00001097          	auipc	ra,0x1
  c8:	a52080e7          	jalr	-1454(ra) # b16 <printf>
      exit(1);
  cc:	4505                	li	a0,1
  ce:	00000097          	auipc	ra,0x0
  d2:	51c080e7          	jalr	1308(ra) # 5ea <exit>
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0);
  d6:	4501                	li	a0,0
  d8:	00000097          	auipc	ra,0x0
  dc:	51a080e7          	jalr	1306(ra) # 5f2 <wait>
  e0:	87aa                	mv	a5,a0
  e2:	fef42423          	sw	a5,-24(s0)
      if(wpid == pid){
  e6:	fe842783          	lw	a5,-24(s0)
  ea:	873e                	mv	a4,a5
  ec:	fec42783          	lw	a5,-20(s0)
  f0:	2701                	sext.w	a4,a4
  f2:	2781                	sext.w	a5,a5
  f4:	02f70463          	beq	a4,a5,11c <main+0x11c>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  f8:	fe842783          	lw	a5,-24(s0)
  fc:	2781                	sext.w	a5,a5
  fe:	fc07dce3          	bgez	a5,d6 <main+0xd6>
        printf("init: wait returned an error\n");
 102:	00001517          	auipc	a0,0x1
 106:	da650513          	addi	a0,a0,-602 # ea8 <malloc+0x19e>
 10a:	00001097          	auipc	ra,0x1
 10e:	a0c080e7          	jalr	-1524(ra) # b16 <printf>
        exit(1);
 112:	4505                	li	a0,1
 114:	00000097          	auipc	ra,0x0
 118:	4d6080e7          	jalr	1238(ra) # 5ea <exit>
        break;
 11c:	0001                	nop
    printf("init: starting sh\n");
 11e:	bf35                	j	5a <main+0x5a>

0000000000000120 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 120:	1141                	addi	sp,sp,-16
 122:	e406                	sd	ra,8(sp)
 124:	e022                	sd	s0,0(sp)
 126:	0800                	addi	s0,sp,16
  extern int main();
  main();
 128:	00000097          	auipc	ra,0x0
 12c:	ed8080e7          	jalr	-296(ra) # 0 <main>
  exit(0);
 130:	4501                	li	a0,0
 132:	00000097          	auipc	ra,0x0
 136:	4b8080e7          	jalr	1208(ra) # 5ea <exit>

000000000000013a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 13a:	7179                	addi	sp,sp,-48
 13c:	f406                	sd	ra,40(sp)
 13e:	f022                	sd	s0,32(sp)
 140:	1800                	addi	s0,sp,48
 142:	fca43c23          	sd	a0,-40(s0)
 146:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
 14a:	fd843783          	ld	a5,-40(s0)
 14e:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
 152:	0001                	nop
 154:	fd043703          	ld	a4,-48(s0)
 158:	00170793          	addi	a5,a4,1
 15c:	fcf43823          	sd	a5,-48(s0)
 160:	fd843783          	ld	a5,-40(s0)
 164:	00178693          	addi	a3,a5,1
 168:	fcd43c23          	sd	a3,-40(s0)
 16c:	00074703          	lbu	a4,0(a4)
 170:	00e78023          	sb	a4,0(a5)
 174:	0007c783          	lbu	a5,0(a5)
 178:	fff1                	bnez	a5,154 <strcpy+0x1a>
    ;
  return os;
 17a:	fe843783          	ld	a5,-24(s0)
}
 17e:	853e                	mv	a0,a5
 180:	70a2                	ld	ra,40(sp)
 182:	7402                	ld	s0,32(sp)
 184:	6145                	addi	sp,sp,48
 186:	8082                	ret

0000000000000188 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 188:	1101                	addi	sp,sp,-32
 18a:	ec06                	sd	ra,24(sp)
 18c:	e822                	sd	s0,16(sp)
 18e:	1000                	addi	s0,sp,32
 190:	fea43423          	sd	a0,-24(s0)
 194:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
 198:	a819                	j	1ae <strcmp+0x26>
    p++, q++;
 19a:	fe843783          	ld	a5,-24(s0)
 19e:	0785                	addi	a5,a5,1
 1a0:	fef43423          	sd	a5,-24(s0)
 1a4:	fe043783          	ld	a5,-32(s0)
 1a8:	0785                	addi	a5,a5,1
 1aa:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
 1ae:	fe843783          	ld	a5,-24(s0)
 1b2:	0007c783          	lbu	a5,0(a5)
 1b6:	cb99                	beqz	a5,1cc <strcmp+0x44>
 1b8:	fe843783          	ld	a5,-24(s0)
 1bc:	0007c703          	lbu	a4,0(a5)
 1c0:	fe043783          	ld	a5,-32(s0)
 1c4:	0007c783          	lbu	a5,0(a5)
 1c8:	fcf709e3          	beq	a4,a5,19a <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
 1cc:	fe843783          	ld	a5,-24(s0)
 1d0:	0007c783          	lbu	a5,0(a5)
 1d4:	0007871b          	sext.w	a4,a5
 1d8:	fe043783          	ld	a5,-32(s0)
 1dc:	0007c783          	lbu	a5,0(a5)
 1e0:	2781                	sext.w	a5,a5
 1e2:	40f707bb          	subw	a5,a4,a5
 1e6:	2781                	sext.w	a5,a5
}
 1e8:	853e                	mv	a0,a5
 1ea:	60e2                	ld	ra,24(sp)
 1ec:	6442                	ld	s0,16(sp)
 1ee:	6105                	addi	sp,sp,32
 1f0:	8082                	ret

00000000000001f2 <strlen>:

uint
strlen(const char *s)
{
 1f2:	7179                	addi	sp,sp,-48
 1f4:	f406                	sd	ra,40(sp)
 1f6:	f022                	sd	s0,32(sp)
 1f8:	1800                	addi	s0,sp,48
 1fa:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
 1fe:	fe042623          	sw	zero,-20(s0)
 202:	a031                	j	20e <strlen+0x1c>
 204:	fec42783          	lw	a5,-20(s0)
 208:	2785                	addiw	a5,a5,1
 20a:	fef42623          	sw	a5,-20(s0)
 20e:	fec42783          	lw	a5,-20(s0)
 212:	fd843703          	ld	a4,-40(s0)
 216:	97ba                	add	a5,a5,a4
 218:	0007c783          	lbu	a5,0(a5)
 21c:	f7e5                	bnez	a5,204 <strlen+0x12>
    ;
  return n;
 21e:	fec42783          	lw	a5,-20(s0)
}
 222:	853e                	mv	a0,a5
 224:	70a2                	ld	ra,40(sp)
 226:	7402                	ld	s0,32(sp)
 228:	6145                	addi	sp,sp,48
 22a:	8082                	ret

000000000000022c <memset>:

void*
memset(void *dst, int c, uint n)
{
 22c:	7179                	addi	sp,sp,-48
 22e:	f406                	sd	ra,40(sp)
 230:	f022                	sd	s0,32(sp)
 232:	1800                	addi	s0,sp,48
 234:	fca43c23          	sd	a0,-40(s0)
 238:	87ae                	mv	a5,a1
 23a:	8732                	mv	a4,a2
 23c:	fcf42a23          	sw	a5,-44(s0)
 240:	87ba                	mv	a5,a4
 242:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
 246:	fd843783          	ld	a5,-40(s0)
 24a:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
 24e:	fe042623          	sw	zero,-20(s0)
 252:	a00d                	j	274 <memset+0x48>
    cdst[i] = c;
 254:	fec42783          	lw	a5,-20(s0)
 258:	fe043703          	ld	a4,-32(s0)
 25c:	97ba                	add	a5,a5,a4
 25e:	fd442703          	lw	a4,-44(s0)
 262:	0ff77713          	zext.b	a4,a4
 266:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
 26a:	fec42783          	lw	a5,-20(s0)
 26e:	2785                	addiw	a5,a5,1
 270:	fef42623          	sw	a5,-20(s0)
 274:	fec42783          	lw	a5,-20(s0)
 278:	fd042703          	lw	a4,-48(s0)
 27c:	2701                	sext.w	a4,a4
 27e:	fce7ebe3          	bltu	a5,a4,254 <memset+0x28>
  }
  return dst;
 282:	fd843783          	ld	a5,-40(s0)
}
 286:	853e                	mv	a0,a5
 288:	70a2                	ld	ra,40(sp)
 28a:	7402                	ld	s0,32(sp)
 28c:	6145                	addi	sp,sp,48
 28e:	8082                	ret

0000000000000290 <strchr>:

char*
strchr(const char *s, char c)
{
 290:	1101                	addi	sp,sp,-32
 292:	ec06                	sd	ra,24(sp)
 294:	e822                	sd	s0,16(sp)
 296:	1000                	addi	s0,sp,32
 298:	fea43423          	sd	a0,-24(s0)
 29c:	87ae                	mv	a5,a1
 29e:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
 2a2:	a01d                	j	2c8 <strchr+0x38>
    if(*s == c)
 2a4:	fe843783          	ld	a5,-24(s0)
 2a8:	0007c703          	lbu	a4,0(a5)
 2ac:	fe744783          	lbu	a5,-25(s0)
 2b0:	0ff7f793          	zext.b	a5,a5
 2b4:	00e79563          	bne	a5,a4,2be <strchr+0x2e>
      return (char*)s;
 2b8:	fe843783          	ld	a5,-24(s0)
 2bc:	a821                	j	2d4 <strchr+0x44>
  for(; *s; s++)
 2be:	fe843783          	ld	a5,-24(s0)
 2c2:	0785                	addi	a5,a5,1
 2c4:	fef43423          	sd	a5,-24(s0)
 2c8:	fe843783          	ld	a5,-24(s0)
 2cc:	0007c783          	lbu	a5,0(a5)
 2d0:	fbf1                	bnez	a5,2a4 <strchr+0x14>
  return 0;
 2d2:	4781                	li	a5,0
}
 2d4:	853e                	mv	a0,a5
 2d6:	60e2                	ld	ra,24(sp)
 2d8:	6442                	ld	s0,16(sp)
 2da:	6105                	addi	sp,sp,32
 2dc:	8082                	ret

00000000000002de <gets>:

char*
gets(char *buf, int max)
{
 2de:	7179                	addi	sp,sp,-48
 2e0:	f406                	sd	ra,40(sp)
 2e2:	f022                	sd	s0,32(sp)
 2e4:	1800                	addi	s0,sp,48
 2e6:	fca43c23          	sd	a0,-40(s0)
 2ea:	87ae                	mv	a5,a1
 2ec:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2f0:	fe042623          	sw	zero,-20(s0)
 2f4:	a8a1                	j	34c <gets+0x6e>
    cc = read(0, &c, 1);
 2f6:	fe740793          	addi	a5,s0,-25
 2fa:	4605                	li	a2,1
 2fc:	85be                	mv	a1,a5
 2fe:	4501                	li	a0,0
 300:	00000097          	auipc	ra,0x0
 304:	302080e7          	jalr	770(ra) # 602 <read>
 308:	87aa                	mv	a5,a0
 30a:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
 30e:	fe842783          	lw	a5,-24(s0)
 312:	2781                	sext.w	a5,a5
 314:	04f05663          	blez	a5,360 <gets+0x82>
      break;
    buf[i++] = c;
 318:	fec42783          	lw	a5,-20(s0)
 31c:	0017871b          	addiw	a4,a5,1
 320:	fee42623          	sw	a4,-20(s0)
 324:	873e                	mv	a4,a5
 326:	fd843783          	ld	a5,-40(s0)
 32a:	97ba                	add	a5,a5,a4
 32c:	fe744703          	lbu	a4,-25(s0)
 330:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
 334:	fe744783          	lbu	a5,-25(s0)
 338:	873e                	mv	a4,a5
 33a:	47a9                	li	a5,10
 33c:	02f70363          	beq	a4,a5,362 <gets+0x84>
 340:	fe744783          	lbu	a5,-25(s0)
 344:	873e                	mv	a4,a5
 346:	47b5                	li	a5,13
 348:	00f70d63          	beq	a4,a5,362 <gets+0x84>
  for(i=0; i+1 < max; ){
 34c:	fec42783          	lw	a5,-20(s0)
 350:	2785                	addiw	a5,a5,1
 352:	2781                	sext.w	a5,a5
 354:	fd442703          	lw	a4,-44(s0)
 358:	2701                	sext.w	a4,a4
 35a:	f8e7cee3          	blt	a5,a4,2f6 <gets+0x18>
 35e:	a011                	j	362 <gets+0x84>
      break;
 360:	0001                	nop
      break;
  }
  buf[i] = '\0';
 362:	fec42783          	lw	a5,-20(s0)
 366:	fd843703          	ld	a4,-40(s0)
 36a:	97ba                	add	a5,a5,a4
 36c:	00078023          	sb	zero,0(a5)
  return buf;
 370:	fd843783          	ld	a5,-40(s0)
}
 374:	853e                	mv	a0,a5
 376:	70a2                	ld	ra,40(sp)
 378:	7402                	ld	s0,32(sp)
 37a:	6145                	addi	sp,sp,48
 37c:	8082                	ret

000000000000037e <stat>:

int
stat(const char *n, struct stat *st)
{
 37e:	7179                	addi	sp,sp,-48
 380:	f406                	sd	ra,40(sp)
 382:	f022                	sd	s0,32(sp)
 384:	1800                	addi	s0,sp,48
 386:	fca43c23          	sd	a0,-40(s0)
 38a:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 38e:	4581                	li	a1,0
 390:	fd843503          	ld	a0,-40(s0)
 394:	00000097          	auipc	ra,0x0
 398:	296080e7          	jalr	662(ra) # 62a <open>
 39c:	87aa                	mv	a5,a0
 39e:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
 3a2:	fec42783          	lw	a5,-20(s0)
 3a6:	2781                	sext.w	a5,a5
 3a8:	0007d463          	bgez	a5,3b0 <stat+0x32>
    return -1;
 3ac:	57fd                	li	a5,-1
 3ae:	a035                	j	3da <stat+0x5c>
  r = fstat(fd, st);
 3b0:	fec42783          	lw	a5,-20(s0)
 3b4:	fd043583          	ld	a1,-48(s0)
 3b8:	853e                	mv	a0,a5
 3ba:	00000097          	auipc	ra,0x0
 3be:	288080e7          	jalr	648(ra) # 642 <fstat>
 3c2:	87aa                	mv	a5,a0
 3c4:	fef42423          	sw	a5,-24(s0)
  close(fd);
 3c8:	fec42783          	lw	a5,-20(s0)
 3cc:	853e                	mv	a0,a5
 3ce:	00000097          	auipc	ra,0x0
 3d2:	244080e7          	jalr	580(ra) # 612 <close>
  return r;
 3d6:	fe842783          	lw	a5,-24(s0)
}
 3da:	853e                	mv	a0,a5
 3dc:	70a2                	ld	ra,40(sp)
 3de:	7402                	ld	s0,32(sp)
 3e0:	6145                	addi	sp,sp,48
 3e2:	8082                	ret

00000000000003e4 <atoi>:

int
atoi(const char *s)
{
 3e4:	7179                	addi	sp,sp,-48
 3e6:	f406                	sd	ra,40(sp)
 3e8:	f022                	sd	s0,32(sp)
 3ea:	1800                	addi	s0,sp,48
 3ec:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
 3f0:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
 3f4:	a81d                	j	42a <atoi+0x46>
    n = n*10 + *s++ - '0';
 3f6:	fec42783          	lw	a5,-20(s0)
 3fa:	873e                	mv	a4,a5
 3fc:	87ba                	mv	a5,a4
 3fe:	0027979b          	slliw	a5,a5,0x2
 402:	9fb9                	addw	a5,a5,a4
 404:	0017979b          	slliw	a5,a5,0x1
 408:	0007871b          	sext.w	a4,a5
 40c:	fd843783          	ld	a5,-40(s0)
 410:	00178693          	addi	a3,a5,1
 414:	fcd43c23          	sd	a3,-40(s0)
 418:	0007c783          	lbu	a5,0(a5)
 41c:	2781                	sext.w	a5,a5
 41e:	9fb9                	addw	a5,a5,a4
 420:	2781                	sext.w	a5,a5
 422:	fd07879b          	addiw	a5,a5,-48
 426:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
 42a:	fd843783          	ld	a5,-40(s0)
 42e:	0007c783          	lbu	a5,0(a5)
 432:	873e                	mv	a4,a5
 434:	02f00793          	li	a5,47
 438:	00e7fb63          	bgeu	a5,a4,44e <atoi+0x6a>
 43c:	fd843783          	ld	a5,-40(s0)
 440:	0007c783          	lbu	a5,0(a5)
 444:	873e                	mv	a4,a5
 446:	03900793          	li	a5,57
 44a:	fae7f6e3          	bgeu	a5,a4,3f6 <atoi+0x12>
  return n;
 44e:	fec42783          	lw	a5,-20(s0)
}
 452:	853e                	mv	a0,a5
 454:	70a2                	ld	ra,40(sp)
 456:	7402                	ld	s0,32(sp)
 458:	6145                	addi	sp,sp,48
 45a:	8082                	ret

000000000000045c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 45c:	7139                	addi	sp,sp,-64
 45e:	fc06                	sd	ra,56(sp)
 460:	f822                	sd	s0,48(sp)
 462:	0080                	addi	s0,sp,64
 464:	fca43c23          	sd	a0,-40(s0)
 468:	fcb43823          	sd	a1,-48(s0)
 46c:	87b2                	mv	a5,a2
 46e:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
 472:	fd843783          	ld	a5,-40(s0)
 476:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
 47a:	fd043783          	ld	a5,-48(s0)
 47e:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
 482:	fe043703          	ld	a4,-32(s0)
 486:	fe843783          	ld	a5,-24(s0)
 48a:	02e7fc63          	bgeu	a5,a4,4c2 <memmove+0x66>
    while(n-- > 0)
 48e:	a00d                	j	4b0 <memmove+0x54>
      *dst++ = *src++;
 490:	fe043703          	ld	a4,-32(s0)
 494:	00170793          	addi	a5,a4,1
 498:	fef43023          	sd	a5,-32(s0)
 49c:	fe843783          	ld	a5,-24(s0)
 4a0:	00178693          	addi	a3,a5,1
 4a4:	fed43423          	sd	a3,-24(s0)
 4a8:	00074703          	lbu	a4,0(a4)
 4ac:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 4b0:	fcc42783          	lw	a5,-52(s0)
 4b4:	fff7871b          	addiw	a4,a5,-1
 4b8:	fce42623          	sw	a4,-52(s0)
 4bc:	fcf04ae3          	bgtz	a5,490 <memmove+0x34>
 4c0:	a891                	j	514 <memmove+0xb8>
  } else {
    dst += n;
 4c2:	fcc42783          	lw	a5,-52(s0)
 4c6:	fe843703          	ld	a4,-24(s0)
 4ca:	97ba                	add	a5,a5,a4
 4cc:	fef43423          	sd	a5,-24(s0)
    src += n;
 4d0:	fcc42783          	lw	a5,-52(s0)
 4d4:	fe043703          	ld	a4,-32(s0)
 4d8:	97ba                	add	a5,a5,a4
 4da:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
 4de:	a01d                	j	504 <memmove+0xa8>
      *--dst = *--src;
 4e0:	fe043783          	ld	a5,-32(s0)
 4e4:	17fd                	addi	a5,a5,-1
 4e6:	fef43023          	sd	a5,-32(s0)
 4ea:	fe843783          	ld	a5,-24(s0)
 4ee:	17fd                	addi	a5,a5,-1
 4f0:	fef43423          	sd	a5,-24(s0)
 4f4:	fe043783          	ld	a5,-32(s0)
 4f8:	0007c703          	lbu	a4,0(a5)
 4fc:	fe843783          	ld	a5,-24(s0)
 500:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 504:	fcc42783          	lw	a5,-52(s0)
 508:	fff7871b          	addiw	a4,a5,-1
 50c:	fce42623          	sw	a4,-52(s0)
 510:	fcf048e3          	bgtz	a5,4e0 <memmove+0x84>
  }
  return vdst;
 514:	fd843783          	ld	a5,-40(s0)
}
 518:	853e                	mv	a0,a5
 51a:	70e2                	ld	ra,56(sp)
 51c:	7442                	ld	s0,48(sp)
 51e:	6121                	addi	sp,sp,64
 520:	8082                	ret

0000000000000522 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 522:	7139                	addi	sp,sp,-64
 524:	fc06                	sd	ra,56(sp)
 526:	f822                	sd	s0,48(sp)
 528:	0080                	addi	s0,sp,64
 52a:	fca43c23          	sd	a0,-40(s0)
 52e:	fcb43823          	sd	a1,-48(s0)
 532:	87b2                	mv	a5,a2
 534:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
 538:	fd843783          	ld	a5,-40(s0)
 53c:	fef43423          	sd	a5,-24(s0)
 540:	fd043783          	ld	a5,-48(s0)
 544:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 548:	a0a1                	j	590 <memcmp+0x6e>
    if (*p1 != *p2) {
 54a:	fe843783          	ld	a5,-24(s0)
 54e:	0007c703          	lbu	a4,0(a5)
 552:	fe043783          	ld	a5,-32(s0)
 556:	0007c783          	lbu	a5,0(a5)
 55a:	02f70163          	beq	a4,a5,57c <memcmp+0x5a>
      return *p1 - *p2;
 55e:	fe843783          	ld	a5,-24(s0)
 562:	0007c783          	lbu	a5,0(a5)
 566:	0007871b          	sext.w	a4,a5
 56a:	fe043783          	ld	a5,-32(s0)
 56e:	0007c783          	lbu	a5,0(a5)
 572:	2781                	sext.w	a5,a5
 574:	40f707bb          	subw	a5,a4,a5
 578:	2781                	sext.w	a5,a5
 57a:	a01d                	j	5a0 <memcmp+0x7e>
    }
    p1++;
 57c:	fe843783          	ld	a5,-24(s0)
 580:	0785                	addi	a5,a5,1
 582:	fef43423          	sd	a5,-24(s0)
    p2++;
 586:	fe043783          	ld	a5,-32(s0)
 58a:	0785                	addi	a5,a5,1
 58c:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 590:	fcc42783          	lw	a5,-52(s0)
 594:	fff7871b          	addiw	a4,a5,-1
 598:	fce42623          	sw	a4,-52(s0)
 59c:	f7dd                	bnez	a5,54a <memcmp+0x28>
  }
  return 0;
 59e:	4781                	li	a5,0
}
 5a0:	853e                	mv	a0,a5
 5a2:	70e2                	ld	ra,56(sp)
 5a4:	7442                	ld	s0,48(sp)
 5a6:	6121                	addi	sp,sp,64
 5a8:	8082                	ret

00000000000005aa <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 5aa:	7179                	addi	sp,sp,-48
 5ac:	f406                	sd	ra,40(sp)
 5ae:	f022                	sd	s0,32(sp)
 5b0:	1800                	addi	s0,sp,48
 5b2:	fea43423          	sd	a0,-24(s0)
 5b6:	feb43023          	sd	a1,-32(s0)
 5ba:	87b2                	mv	a5,a2
 5bc:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
 5c0:	fdc42783          	lw	a5,-36(s0)
 5c4:	863e                	mv	a2,a5
 5c6:	fe043583          	ld	a1,-32(s0)
 5ca:	fe843503          	ld	a0,-24(s0)
 5ce:	00000097          	auipc	ra,0x0
 5d2:	e8e080e7          	jalr	-370(ra) # 45c <memmove>
 5d6:	87aa                	mv	a5,a0
}
 5d8:	853e                	mv	a0,a5
 5da:	70a2                	ld	ra,40(sp)
 5dc:	7402                	ld	s0,32(sp)
 5de:	6145                	addi	sp,sp,48
 5e0:	8082                	ret

00000000000005e2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 5e2:	4885                	li	a7,1
 ecall
 5e4:	00000073          	ecall
 ret
 5e8:	8082                	ret

00000000000005ea <exit>:
.global exit
exit:
 li a7, SYS_exit
 5ea:	4889                	li	a7,2
 ecall
 5ec:	00000073          	ecall
 ret
 5f0:	8082                	ret

00000000000005f2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 5f2:	488d                	li	a7,3
 ecall
 5f4:	00000073          	ecall
 ret
 5f8:	8082                	ret

00000000000005fa <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5fa:	4891                	li	a7,4
 ecall
 5fc:	00000073          	ecall
 ret
 600:	8082                	ret

0000000000000602 <read>:
.global read
read:
 li a7, SYS_read
 602:	4895                	li	a7,5
 ecall
 604:	00000073          	ecall
 ret
 608:	8082                	ret

000000000000060a <write>:
.global write
write:
 li a7, SYS_write
 60a:	48c1                	li	a7,16
 ecall
 60c:	00000073          	ecall
 ret
 610:	8082                	ret

0000000000000612 <close>:
.global close
close:
 li a7, SYS_close
 612:	48d5                	li	a7,21
 ecall
 614:	00000073          	ecall
 ret
 618:	8082                	ret

000000000000061a <kill>:
.global kill
kill:
 li a7, SYS_kill
 61a:	4899                	li	a7,6
 ecall
 61c:	00000073          	ecall
 ret
 620:	8082                	ret

0000000000000622 <exec>:
.global exec
exec:
 li a7, SYS_exec
 622:	489d                	li	a7,7
 ecall
 624:	00000073          	ecall
 ret
 628:	8082                	ret

000000000000062a <open>:
.global open
open:
 li a7, SYS_open
 62a:	48bd                	li	a7,15
 ecall
 62c:	00000073          	ecall
 ret
 630:	8082                	ret

0000000000000632 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 632:	48c5                	li	a7,17
 ecall
 634:	00000073          	ecall
 ret
 638:	8082                	ret

000000000000063a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 63a:	48c9                	li	a7,18
 ecall
 63c:	00000073          	ecall
 ret
 640:	8082                	ret

0000000000000642 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 642:	48a1                	li	a7,8
 ecall
 644:	00000073          	ecall
 ret
 648:	8082                	ret

000000000000064a <link>:
.global link
link:
 li a7, SYS_link
 64a:	48cd                	li	a7,19
 ecall
 64c:	00000073          	ecall
 ret
 650:	8082                	ret

0000000000000652 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 652:	48d1                	li	a7,20
 ecall
 654:	00000073          	ecall
 ret
 658:	8082                	ret

000000000000065a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 65a:	48a5                	li	a7,9
 ecall
 65c:	00000073          	ecall
 ret
 660:	8082                	ret

0000000000000662 <dup>:
.global dup
dup:
 li a7, SYS_dup
 662:	48a9                	li	a7,10
 ecall
 664:	00000073          	ecall
 ret
 668:	8082                	ret

000000000000066a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 66a:	48ad                	li	a7,11
 ecall
 66c:	00000073          	ecall
 ret
 670:	8082                	ret

0000000000000672 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 672:	48b1                	li	a7,12
 ecall
 674:	00000073          	ecall
 ret
 678:	8082                	ret

000000000000067a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 67a:	48b5                	li	a7,13
 ecall
 67c:	00000073          	ecall
 ret
 680:	8082                	ret

0000000000000682 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 682:	48b9                	li	a7,14
 ecall
 684:	00000073          	ecall
 ret
 688:	8082                	ret

000000000000068a <ps>:
.global ps
ps:
 li a7, SYS_ps
 68a:	48d9                	li	a7,22
 ecall
 68c:	00000073          	ecall
 ret
 690:	8082                	ret

0000000000000692 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 692:	1101                	addi	sp,sp,-32
 694:	ec06                	sd	ra,24(sp)
 696:	e822                	sd	s0,16(sp)
 698:	1000                	addi	s0,sp,32
 69a:	87aa                	mv	a5,a0
 69c:	872e                	mv	a4,a1
 69e:	fef42623          	sw	a5,-20(s0)
 6a2:	87ba                	mv	a5,a4
 6a4:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 6a8:	feb40713          	addi	a4,s0,-21
 6ac:	fec42783          	lw	a5,-20(s0)
 6b0:	4605                	li	a2,1
 6b2:	85ba                	mv	a1,a4
 6b4:	853e                	mv	a0,a5
 6b6:	00000097          	auipc	ra,0x0
 6ba:	f54080e7          	jalr	-172(ra) # 60a <write>
}
 6be:	0001                	nop
 6c0:	60e2                	ld	ra,24(sp)
 6c2:	6442                	ld	s0,16(sp)
 6c4:	6105                	addi	sp,sp,32
 6c6:	8082                	ret

00000000000006c8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6c8:	7139                	addi	sp,sp,-64
 6ca:	fc06                	sd	ra,56(sp)
 6cc:	f822                	sd	s0,48(sp)
 6ce:	0080                	addi	s0,sp,64
 6d0:	87aa                	mv	a5,a0
 6d2:	8736                	mv	a4,a3
 6d4:	fcf42623          	sw	a5,-52(s0)
 6d8:	87ae                	mv	a5,a1
 6da:	fcf42423          	sw	a5,-56(s0)
 6de:	87b2                	mv	a5,a2
 6e0:	fcf42223          	sw	a5,-60(s0)
 6e4:	87ba                	mv	a5,a4
 6e6:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6ea:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 6ee:	fc042783          	lw	a5,-64(s0)
 6f2:	2781                	sext.w	a5,a5
 6f4:	c38d                	beqz	a5,716 <printint+0x4e>
 6f6:	fc842783          	lw	a5,-56(s0)
 6fa:	2781                	sext.w	a5,a5
 6fc:	0007dd63          	bgez	a5,716 <printint+0x4e>
    neg = 1;
 700:	4785                	li	a5,1
 702:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 706:	fc842783          	lw	a5,-56(s0)
 70a:	40f007bb          	negw	a5,a5
 70e:	2781                	sext.w	a5,a5
 710:	fef42223          	sw	a5,-28(s0)
 714:	a029                	j	71e <printint+0x56>
  } else {
    x = xx;
 716:	fc842783          	lw	a5,-56(s0)
 71a:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 71e:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 722:	fc442783          	lw	a5,-60(s0)
 726:	fe442703          	lw	a4,-28(s0)
 72a:	02f777bb          	remuw	a5,a4,a5
 72e:	0007871b          	sext.w	a4,a5
 732:	fec42783          	lw	a5,-20(s0)
 736:	0017869b          	addiw	a3,a5,1
 73a:	fed42623          	sw	a3,-20(s0)
 73e:	00001697          	auipc	a3,0x1
 742:	8d268693          	addi	a3,a3,-1838 # 1010 <digits>
 746:	1702                	slli	a4,a4,0x20
 748:	9301                	srli	a4,a4,0x20
 74a:	9736                	add	a4,a4,a3
 74c:	00074703          	lbu	a4,0(a4)
 750:	17c1                	addi	a5,a5,-16
 752:	97a2                	add	a5,a5,s0
 754:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 758:	fc442783          	lw	a5,-60(s0)
 75c:	fe442703          	lw	a4,-28(s0)
 760:	02f757bb          	divuw	a5,a4,a5
 764:	fef42223          	sw	a5,-28(s0)
 768:	fe442783          	lw	a5,-28(s0)
 76c:	2781                	sext.w	a5,a5
 76e:	fbd5                	bnez	a5,722 <printint+0x5a>
  if(neg)
 770:	fe842783          	lw	a5,-24(s0)
 774:	2781                	sext.w	a5,a5
 776:	cf85                	beqz	a5,7ae <printint+0xe6>
    buf[i++] = '-';
 778:	fec42783          	lw	a5,-20(s0)
 77c:	0017871b          	addiw	a4,a5,1
 780:	fee42623          	sw	a4,-20(s0)
 784:	17c1                	addi	a5,a5,-16
 786:	97a2                	add	a5,a5,s0
 788:	02d00713          	li	a4,45
 78c:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 790:	a839                	j	7ae <printint+0xe6>
    putc(fd, buf[i]);
 792:	fec42783          	lw	a5,-20(s0)
 796:	17c1                	addi	a5,a5,-16
 798:	97a2                	add	a5,a5,s0
 79a:	fe07c703          	lbu	a4,-32(a5)
 79e:	fcc42783          	lw	a5,-52(s0)
 7a2:	85ba                	mv	a1,a4
 7a4:	853e                	mv	a0,a5
 7a6:	00000097          	auipc	ra,0x0
 7aa:	eec080e7          	jalr	-276(ra) # 692 <putc>
  while(--i >= 0)
 7ae:	fec42783          	lw	a5,-20(s0)
 7b2:	37fd                	addiw	a5,a5,-1
 7b4:	fef42623          	sw	a5,-20(s0)
 7b8:	fec42783          	lw	a5,-20(s0)
 7bc:	2781                	sext.w	a5,a5
 7be:	fc07dae3          	bgez	a5,792 <printint+0xca>
}
 7c2:	0001                	nop
 7c4:	0001                	nop
 7c6:	70e2                	ld	ra,56(sp)
 7c8:	7442                	ld	s0,48(sp)
 7ca:	6121                	addi	sp,sp,64
 7cc:	8082                	ret

00000000000007ce <printptr>:

static void
printptr(int fd, uint64 x) {
 7ce:	7179                	addi	sp,sp,-48
 7d0:	f406                	sd	ra,40(sp)
 7d2:	f022                	sd	s0,32(sp)
 7d4:	1800                	addi	s0,sp,48
 7d6:	87aa                	mv	a5,a0
 7d8:	fcb43823          	sd	a1,-48(s0)
 7dc:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 7e0:	fdc42783          	lw	a5,-36(s0)
 7e4:	03000593          	li	a1,48
 7e8:	853e                	mv	a0,a5
 7ea:	00000097          	auipc	ra,0x0
 7ee:	ea8080e7          	jalr	-344(ra) # 692 <putc>
  putc(fd, 'x');
 7f2:	fdc42783          	lw	a5,-36(s0)
 7f6:	07800593          	li	a1,120
 7fa:	853e                	mv	a0,a5
 7fc:	00000097          	auipc	ra,0x0
 800:	e96080e7          	jalr	-362(ra) # 692 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 804:	fe042623          	sw	zero,-20(s0)
 808:	a82d                	j	842 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 80a:	fd043783          	ld	a5,-48(s0)
 80e:	93f1                	srli	a5,a5,0x3c
 810:	00001717          	auipc	a4,0x1
 814:	80070713          	addi	a4,a4,-2048 # 1010 <digits>
 818:	97ba                	add	a5,a5,a4
 81a:	0007c703          	lbu	a4,0(a5)
 81e:	fdc42783          	lw	a5,-36(s0)
 822:	85ba                	mv	a1,a4
 824:	853e                	mv	a0,a5
 826:	00000097          	auipc	ra,0x0
 82a:	e6c080e7          	jalr	-404(ra) # 692 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 82e:	fec42783          	lw	a5,-20(s0)
 832:	2785                	addiw	a5,a5,1
 834:	fef42623          	sw	a5,-20(s0)
 838:	fd043783          	ld	a5,-48(s0)
 83c:	0792                	slli	a5,a5,0x4
 83e:	fcf43823          	sd	a5,-48(s0)
 842:	fec42703          	lw	a4,-20(s0)
 846:	47bd                	li	a5,15
 848:	fce7f1e3          	bgeu	a5,a4,80a <printptr+0x3c>
}
 84c:	0001                	nop
 84e:	0001                	nop
 850:	70a2                	ld	ra,40(sp)
 852:	7402                	ld	s0,32(sp)
 854:	6145                	addi	sp,sp,48
 856:	8082                	ret

0000000000000858 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 858:	715d                	addi	sp,sp,-80
 85a:	e486                	sd	ra,72(sp)
 85c:	e0a2                	sd	s0,64(sp)
 85e:	0880                	addi	s0,sp,80
 860:	87aa                	mv	a5,a0
 862:	fcb43023          	sd	a1,-64(s0)
 866:	fac43c23          	sd	a2,-72(s0)
 86a:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 86e:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 872:	fe042223          	sw	zero,-28(s0)
 876:	a42d                	j	aa0 <vprintf+0x248>
    c = fmt[i] & 0xff;
 878:	fe442783          	lw	a5,-28(s0)
 87c:	fc043703          	ld	a4,-64(s0)
 880:	97ba                	add	a5,a5,a4
 882:	0007c783          	lbu	a5,0(a5)
 886:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 88a:	fe042783          	lw	a5,-32(s0)
 88e:	2781                	sext.w	a5,a5
 890:	eb9d                	bnez	a5,8c6 <vprintf+0x6e>
      if(c == '%'){
 892:	fdc42783          	lw	a5,-36(s0)
 896:	0007871b          	sext.w	a4,a5
 89a:	02500793          	li	a5,37
 89e:	00f71763          	bne	a4,a5,8ac <vprintf+0x54>
        state = '%';
 8a2:	02500793          	li	a5,37
 8a6:	fef42023          	sw	a5,-32(s0)
 8aa:	a2f5                	j	a96 <vprintf+0x23e>
      } else {
        putc(fd, c);
 8ac:	fdc42783          	lw	a5,-36(s0)
 8b0:	0ff7f713          	zext.b	a4,a5
 8b4:	fcc42783          	lw	a5,-52(s0)
 8b8:	85ba                	mv	a1,a4
 8ba:	853e                	mv	a0,a5
 8bc:	00000097          	auipc	ra,0x0
 8c0:	dd6080e7          	jalr	-554(ra) # 692 <putc>
 8c4:	aac9                	j	a96 <vprintf+0x23e>
      }
    } else if(state == '%'){
 8c6:	fe042783          	lw	a5,-32(s0)
 8ca:	0007871b          	sext.w	a4,a5
 8ce:	02500793          	li	a5,37
 8d2:	1cf71263          	bne	a4,a5,a96 <vprintf+0x23e>
      if(c == 'd'){
 8d6:	fdc42783          	lw	a5,-36(s0)
 8da:	0007871b          	sext.w	a4,a5
 8de:	06400793          	li	a5,100
 8e2:	02f71463          	bne	a4,a5,90a <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 8e6:	fb843783          	ld	a5,-72(s0)
 8ea:	00878713          	addi	a4,a5,8
 8ee:	fae43c23          	sd	a4,-72(s0)
 8f2:	4398                	lw	a4,0(a5)
 8f4:	fcc42783          	lw	a5,-52(s0)
 8f8:	4685                	li	a3,1
 8fa:	4629                	li	a2,10
 8fc:	85ba                	mv	a1,a4
 8fe:	853e                	mv	a0,a5
 900:	00000097          	auipc	ra,0x0
 904:	dc8080e7          	jalr	-568(ra) # 6c8 <printint>
 908:	a269                	j	a92 <vprintf+0x23a>
      } else if(c == 'l') {
 90a:	fdc42783          	lw	a5,-36(s0)
 90e:	0007871b          	sext.w	a4,a5
 912:	06c00793          	li	a5,108
 916:	02f71663          	bne	a4,a5,942 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 91a:	fb843783          	ld	a5,-72(s0)
 91e:	00878713          	addi	a4,a5,8
 922:	fae43c23          	sd	a4,-72(s0)
 926:	639c                	ld	a5,0(a5)
 928:	0007871b          	sext.w	a4,a5
 92c:	fcc42783          	lw	a5,-52(s0)
 930:	4681                	li	a3,0
 932:	4629                	li	a2,10
 934:	85ba                	mv	a1,a4
 936:	853e                	mv	a0,a5
 938:	00000097          	auipc	ra,0x0
 93c:	d90080e7          	jalr	-624(ra) # 6c8 <printint>
 940:	aa89                	j	a92 <vprintf+0x23a>
      } else if(c == 'x') {
 942:	fdc42783          	lw	a5,-36(s0)
 946:	0007871b          	sext.w	a4,a5
 94a:	07800793          	li	a5,120
 94e:	02f71463          	bne	a4,a5,976 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 952:	fb843783          	ld	a5,-72(s0)
 956:	00878713          	addi	a4,a5,8
 95a:	fae43c23          	sd	a4,-72(s0)
 95e:	4398                	lw	a4,0(a5)
 960:	fcc42783          	lw	a5,-52(s0)
 964:	4681                	li	a3,0
 966:	4641                	li	a2,16
 968:	85ba                	mv	a1,a4
 96a:	853e                	mv	a0,a5
 96c:	00000097          	auipc	ra,0x0
 970:	d5c080e7          	jalr	-676(ra) # 6c8 <printint>
 974:	aa39                	j	a92 <vprintf+0x23a>
      } else if(c == 'p') {
 976:	fdc42783          	lw	a5,-36(s0)
 97a:	0007871b          	sext.w	a4,a5
 97e:	07000793          	li	a5,112
 982:	02f71263          	bne	a4,a5,9a6 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 986:	fb843783          	ld	a5,-72(s0)
 98a:	00878713          	addi	a4,a5,8
 98e:	fae43c23          	sd	a4,-72(s0)
 992:	6398                	ld	a4,0(a5)
 994:	fcc42783          	lw	a5,-52(s0)
 998:	85ba                	mv	a1,a4
 99a:	853e                	mv	a0,a5
 99c:	00000097          	auipc	ra,0x0
 9a0:	e32080e7          	jalr	-462(ra) # 7ce <printptr>
 9a4:	a0fd                	j	a92 <vprintf+0x23a>
      } else if(c == 's'){
 9a6:	fdc42783          	lw	a5,-36(s0)
 9aa:	0007871b          	sext.w	a4,a5
 9ae:	07300793          	li	a5,115
 9b2:	04f71c63          	bne	a4,a5,a0a <vprintf+0x1b2>
        s = va_arg(ap, char*);
 9b6:	fb843783          	ld	a5,-72(s0)
 9ba:	00878713          	addi	a4,a5,8
 9be:	fae43c23          	sd	a4,-72(s0)
 9c2:	639c                	ld	a5,0(a5)
 9c4:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 9c8:	fe843783          	ld	a5,-24(s0)
 9cc:	eb8d                	bnez	a5,9fe <vprintf+0x1a6>
          s = "(null)";
 9ce:	00000797          	auipc	a5,0x0
 9d2:	4fa78793          	addi	a5,a5,1274 # ec8 <malloc+0x1be>
 9d6:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 9da:	a015                	j	9fe <vprintf+0x1a6>
          putc(fd, *s);
 9dc:	fe843783          	ld	a5,-24(s0)
 9e0:	0007c703          	lbu	a4,0(a5)
 9e4:	fcc42783          	lw	a5,-52(s0)
 9e8:	85ba                	mv	a1,a4
 9ea:	853e                	mv	a0,a5
 9ec:	00000097          	auipc	ra,0x0
 9f0:	ca6080e7          	jalr	-858(ra) # 692 <putc>
          s++;
 9f4:	fe843783          	ld	a5,-24(s0)
 9f8:	0785                	addi	a5,a5,1
 9fa:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 9fe:	fe843783          	ld	a5,-24(s0)
 a02:	0007c783          	lbu	a5,0(a5)
 a06:	fbf9                	bnez	a5,9dc <vprintf+0x184>
 a08:	a069                	j	a92 <vprintf+0x23a>
        }
      } else if(c == 'c'){
 a0a:	fdc42783          	lw	a5,-36(s0)
 a0e:	0007871b          	sext.w	a4,a5
 a12:	06300793          	li	a5,99
 a16:	02f71463          	bne	a4,a5,a3e <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 a1a:	fb843783          	ld	a5,-72(s0)
 a1e:	00878713          	addi	a4,a5,8
 a22:	fae43c23          	sd	a4,-72(s0)
 a26:	439c                	lw	a5,0(a5)
 a28:	0ff7f713          	zext.b	a4,a5
 a2c:	fcc42783          	lw	a5,-52(s0)
 a30:	85ba                	mv	a1,a4
 a32:	853e                	mv	a0,a5
 a34:	00000097          	auipc	ra,0x0
 a38:	c5e080e7          	jalr	-930(ra) # 692 <putc>
 a3c:	a899                	j	a92 <vprintf+0x23a>
      } else if(c == '%'){
 a3e:	fdc42783          	lw	a5,-36(s0)
 a42:	0007871b          	sext.w	a4,a5
 a46:	02500793          	li	a5,37
 a4a:	00f71f63          	bne	a4,a5,a68 <vprintf+0x210>
        putc(fd, c);
 a4e:	fdc42783          	lw	a5,-36(s0)
 a52:	0ff7f713          	zext.b	a4,a5
 a56:	fcc42783          	lw	a5,-52(s0)
 a5a:	85ba                	mv	a1,a4
 a5c:	853e                	mv	a0,a5
 a5e:	00000097          	auipc	ra,0x0
 a62:	c34080e7          	jalr	-972(ra) # 692 <putc>
 a66:	a035                	j	a92 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 a68:	fcc42783          	lw	a5,-52(s0)
 a6c:	02500593          	li	a1,37
 a70:	853e                	mv	a0,a5
 a72:	00000097          	auipc	ra,0x0
 a76:	c20080e7          	jalr	-992(ra) # 692 <putc>
        putc(fd, c);
 a7a:	fdc42783          	lw	a5,-36(s0)
 a7e:	0ff7f713          	zext.b	a4,a5
 a82:	fcc42783          	lw	a5,-52(s0)
 a86:	85ba                	mv	a1,a4
 a88:	853e                	mv	a0,a5
 a8a:	00000097          	auipc	ra,0x0
 a8e:	c08080e7          	jalr	-1016(ra) # 692 <putc>
      }
      state = 0;
 a92:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 a96:	fe442783          	lw	a5,-28(s0)
 a9a:	2785                	addiw	a5,a5,1
 a9c:	fef42223          	sw	a5,-28(s0)
 aa0:	fe442783          	lw	a5,-28(s0)
 aa4:	fc043703          	ld	a4,-64(s0)
 aa8:	97ba                	add	a5,a5,a4
 aaa:	0007c783          	lbu	a5,0(a5)
 aae:	dc0795e3          	bnez	a5,878 <vprintf+0x20>
    }
  }
}
 ab2:	0001                	nop
 ab4:	0001                	nop
 ab6:	60a6                	ld	ra,72(sp)
 ab8:	6406                	ld	s0,64(sp)
 aba:	6161                	addi	sp,sp,80
 abc:	8082                	ret

0000000000000abe <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 abe:	7159                	addi	sp,sp,-112
 ac0:	fc06                	sd	ra,56(sp)
 ac2:	f822                	sd	s0,48(sp)
 ac4:	0080                	addi	s0,sp,64
 ac6:	fcb43823          	sd	a1,-48(s0)
 aca:	e010                	sd	a2,0(s0)
 acc:	e414                	sd	a3,8(s0)
 ace:	e818                	sd	a4,16(s0)
 ad0:	ec1c                	sd	a5,24(s0)
 ad2:	03043023          	sd	a6,32(s0)
 ad6:	03143423          	sd	a7,40(s0)
 ada:	87aa                	mv	a5,a0
 adc:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 ae0:	03040793          	addi	a5,s0,48
 ae4:	fcf43423          	sd	a5,-56(s0)
 ae8:	fc843783          	ld	a5,-56(s0)
 aec:	fd078793          	addi	a5,a5,-48
 af0:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 af4:	fe843703          	ld	a4,-24(s0)
 af8:	fdc42783          	lw	a5,-36(s0)
 afc:	863a                	mv	a2,a4
 afe:	fd043583          	ld	a1,-48(s0)
 b02:	853e                	mv	a0,a5
 b04:	00000097          	auipc	ra,0x0
 b08:	d54080e7          	jalr	-684(ra) # 858 <vprintf>
}
 b0c:	0001                	nop
 b0e:	70e2                	ld	ra,56(sp)
 b10:	7442                	ld	s0,48(sp)
 b12:	6165                	addi	sp,sp,112
 b14:	8082                	ret

0000000000000b16 <printf>:

void
printf(const char *fmt, ...)
{
 b16:	7159                	addi	sp,sp,-112
 b18:	f406                	sd	ra,40(sp)
 b1a:	f022                	sd	s0,32(sp)
 b1c:	1800                	addi	s0,sp,48
 b1e:	fca43c23          	sd	a0,-40(s0)
 b22:	e40c                	sd	a1,8(s0)
 b24:	e810                	sd	a2,16(s0)
 b26:	ec14                	sd	a3,24(s0)
 b28:	f018                	sd	a4,32(s0)
 b2a:	f41c                	sd	a5,40(s0)
 b2c:	03043823          	sd	a6,48(s0)
 b30:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b34:	04040793          	addi	a5,s0,64
 b38:	fcf43823          	sd	a5,-48(s0)
 b3c:	fd043783          	ld	a5,-48(s0)
 b40:	fc878793          	addi	a5,a5,-56
 b44:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 b48:	fe843783          	ld	a5,-24(s0)
 b4c:	863e                	mv	a2,a5
 b4e:	fd843583          	ld	a1,-40(s0)
 b52:	4505                	li	a0,1
 b54:	00000097          	auipc	ra,0x0
 b58:	d04080e7          	jalr	-764(ra) # 858 <vprintf>
}
 b5c:	0001                	nop
 b5e:	70a2                	ld	ra,40(sp)
 b60:	7402                	ld	s0,32(sp)
 b62:	6165                	addi	sp,sp,112
 b64:	8082                	ret

0000000000000b66 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b66:	7179                	addi	sp,sp,-48
 b68:	f406                	sd	ra,40(sp)
 b6a:	f022                	sd	s0,32(sp)
 b6c:	1800                	addi	s0,sp,48
 b6e:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b72:	fd843783          	ld	a5,-40(s0)
 b76:	17c1                	addi	a5,a5,-16
 b78:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b7c:	00000797          	auipc	a5,0x0
 b80:	4c478793          	addi	a5,a5,1220 # 1040 <freep>
 b84:	639c                	ld	a5,0(a5)
 b86:	fef43423          	sd	a5,-24(s0)
 b8a:	a815                	j	bbe <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b8c:	fe843783          	ld	a5,-24(s0)
 b90:	639c                	ld	a5,0(a5)
 b92:	fe843703          	ld	a4,-24(s0)
 b96:	00f76f63          	bltu	a4,a5,bb4 <free+0x4e>
 b9a:	fe043703          	ld	a4,-32(s0)
 b9e:	fe843783          	ld	a5,-24(s0)
 ba2:	02e7eb63          	bltu	a5,a4,bd8 <free+0x72>
 ba6:	fe843783          	ld	a5,-24(s0)
 baa:	639c                	ld	a5,0(a5)
 bac:	fe043703          	ld	a4,-32(s0)
 bb0:	02f76463          	bltu	a4,a5,bd8 <free+0x72>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bb4:	fe843783          	ld	a5,-24(s0)
 bb8:	639c                	ld	a5,0(a5)
 bba:	fef43423          	sd	a5,-24(s0)
 bbe:	fe043703          	ld	a4,-32(s0)
 bc2:	fe843783          	ld	a5,-24(s0)
 bc6:	fce7f3e3          	bgeu	a5,a4,b8c <free+0x26>
 bca:	fe843783          	ld	a5,-24(s0)
 bce:	639c                	ld	a5,0(a5)
 bd0:	fe043703          	ld	a4,-32(s0)
 bd4:	faf77ce3          	bgeu	a4,a5,b8c <free+0x26>
      break;
  if(bp + bp->s.size == p->s.ptr){
 bd8:	fe043783          	ld	a5,-32(s0)
 bdc:	479c                	lw	a5,8(a5)
 bde:	1782                	slli	a5,a5,0x20
 be0:	9381                	srli	a5,a5,0x20
 be2:	0792                	slli	a5,a5,0x4
 be4:	fe043703          	ld	a4,-32(s0)
 be8:	973e                	add	a4,a4,a5
 bea:	fe843783          	ld	a5,-24(s0)
 bee:	639c                	ld	a5,0(a5)
 bf0:	02f71763          	bne	a4,a5,c1e <free+0xb8>
    bp->s.size += p->s.ptr->s.size;
 bf4:	fe043783          	ld	a5,-32(s0)
 bf8:	4798                	lw	a4,8(a5)
 bfa:	fe843783          	ld	a5,-24(s0)
 bfe:	639c                	ld	a5,0(a5)
 c00:	479c                	lw	a5,8(a5)
 c02:	9fb9                	addw	a5,a5,a4
 c04:	0007871b          	sext.w	a4,a5
 c08:	fe043783          	ld	a5,-32(s0)
 c0c:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 c0e:	fe843783          	ld	a5,-24(s0)
 c12:	639c                	ld	a5,0(a5)
 c14:	6398                	ld	a4,0(a5)
 c16:	fe043783          	ld	a5,-32(s0)
 c1a:	e398                	sd	a4,0(a5)
 c1c:	a039                	j	c2a <free+0xc4>
  } else
    bp->s.ptr = p->s.ptr;
 c1e:	fe843783          	ld	a5,-24(s0)
 c22:	6398                	ld	a4,0(a5)
 c24:	fe043783          	ld	a5,-32(s0)
 c28:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 c2a:	fe843783          	ld	a5,-24(s0)
 c2e:	479c                	lw	a5,8(a5)
 c30:	1782                	slli	a5,a5,0x20
 c32:	9381                	srli	a5,a5,0x20
 c34:	0792                	slli	a5,a5,0x4
 c36:	fe843703          	ld	a4,-24(s0)
 c3a:	97ba                	add	a5,a5,a4
 c3c:	fe043703          	ld	a4,-32(s0)
 c40:	02f71563          	bne	a4,a5,c6a <free+0x104>
    p->s.size += bp->s.size;
 c44:	fe843783          	ld	a5,-24(s0)
 c48:	4798                	lw	a4,8(a5)
 c4a:	fe043783          	ld	a5,-32(s0)
 c4e:	479c                	lw	a5,8(a5)
 c50:	9fb9                	addw	a5,a5,a4
 c52:	0007871b          	sext.w	a4,a5
 c56:	fe843783          	ld	a5,-24(s0)
 c5a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 c5c:	fe043783          	ld	a5,-32(s0)
 c60:	6398                	ld	a4,0(a5)
 c62:	fe843783          	ld	a5,-24(s0)
 c66:	e398                	sd	a4,0(a5)
 c68:	a031                	j	c74 <free+0x10e>
  } else
    p->s.ptr = bp;
 c6a:	fe843783          	ld	a5,-24(s0)
 c6e:	fe043703          	ld	a4,-32(s0)
 c72:	e398                	sd	a4,0(a5)
  freep = p;
 c74:	00000797          	auipc	a5,0x0
 c78:	3cc78793          	addi	a5,a5,972 # 1040 <freep>
 c7c:	fe843703          	ld	a4,-24(s0)
 c80:	e398                	sd	a4,0(a5)
}
 c82:	0001                	nop
 c84:	70a2                	ld	ra,40(sp)
 c86:	7402                	ld	s0,32(sp)
 c88:	6145                	addi	sp,sp,48
 c8a:	8082                	ret

0000000000000c8c <morecore>:

static Header*
morecore(uint nu)
{
 c8c:	7179                	addi	sp,sp,-48
 c8e:	f406                	sd	ra,40(sp)
 c90:	f022                	sd	s0,32(sp)
 c92:	1800                	addi	s0,sp,48
 c94:	87aa                	mv	a5,a0
 c96:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 c9a:	fdc42783          	lw	a5,-36(s0)
 c9e:	0007871b          	sext.w	a4,a5
 ca2:	6785                	lui	a5,0x1
 ca4:	00f77563          	bgeu	a4,a5,cae <morecore+0x22>
    nu = 4096;
 ca8:	6785                	lui	a5,0x1
 caa:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 cae:	fdc42783          	lw	a5,-36(s0)
 cb2:	0047979b          	slliw	a5,a5,0x4
 cb6:	2781                	sext.w	a5,a5
 cb8:	853e                	mv	a0,a5
 cba:	00000097          	auipc	ra,0x0
 cbe:	9b8080e7          	jalr	-1608(ra) # 672 <sbrk>
 cc2:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 cc6:	fe843703          	ld	a4,-24(s0)
 cca:	57fd                	li	a5,-1
 ccc:	00f71463          	bne	a4,a5,cd4 <morecore+0x48>
    return 0;
 cd0:	4781                	li	a5,0
 cd2:	a03d                	j	d00 <morecore+0x74>
  hp = (Header*)p;
 cd4:	fe843783          	ld	a5,-24(s0)
 cd8:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 cdc:	fe043783          	ld	a5,-32(s0)
 ce0:	fdc42703          	lw	a4,-36(s0)
 ce4:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 ce6:	fe043783          	ld	a5,-32(s0)
 cea:	07c1                	addi	a5,a5,16 # 1010 <digits>
 cec:	853e                	mv	a0,a5
 cee:	00000097          	auipc	ra,0x0
 cf2:	e78080e7          	jalr	-392(ra) # b66 <free>
  return freep;
 cf6:	00000797          	auipc	a5,0x0
 cfa:	34a78793          	addi	a5,a5,842 # 1040 <freep>
 cfe:	639c                	ld	a5,0(a5)
}
 d00:	853e                	mv	a0,a5
 d02:	70a2                	ld	ra,40(sp)
 d04:	7402                	ld	s0,32(sp)
 d06:	6145                	addi	sp,sp,48
 d08:	8082                	ret

0000000000000d0a <malloc>:

void*
malloc(uint nbytes)
{
 d0a:	7139                	addi	sp,sp,-64
 d0c:	fc06                	sd	ra,56(sp)
 d0e:	f822                	sd	s0,48(sp)
 d10:	0080                	addi	s0,sp,64
 d12:	87aa                	mv	a5,a0
 d14:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d18:	fcc46783          	lwu	a5,-52(s0)
 d1c:	07bd                	addi	a5,a5,15
 d1e:	8391                	srli	a5,a5,0x4
 d20:	2781                	sext.w	a5,a5
 d22:	2785                	addiw	a5,a5,1
 d24:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 d28:	00000797          	auipc	a5,0x0
 d2c:	31878793          	addi	a5,a5,792 # 1040 <freep>
 d30:	639c                	ld	a5,0(a5)
 d32:	fef43023          	sd	a5,-32(s0)
 d36:	fe043783          	ld	a5,-32(s0)
 d3a:	ef95                	bnez	a5,d76 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 d3c:	00000797          	auipc	a5,0x0
 d40:	2f478793          	addi	a5,a5,756 # 1030 <base>
 d44:	fef43023          	sd	a5,-32(s0)
 d48:	00000797          	auipc	a5,0x0
 d4c:	2f878793          	addi	a5,a5,760 # 1040 <freep>
 d50:	fe043703          	ld	a4,-32(s0)
 d54:	e398                	sd	a4,0(a5)
 d56:	00000797          	auipc	a5,0x0
 d5a:	2ea78793          	addi	a5,a5,746 # 1040 <freep>
 d5e:	6398                	ld	a4,0(a5)
 d60:	00000797          	auipc	a5,0x0
 d64:	2d078793          	addi	a5,a5,720 # 1030 <base>
 d68:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 d6a:	00000797          	auipc	a5,0x0
 d6e:	2c678793          	addi	a5,a5,710 # 1030 <base>
 d72:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d76:	fe043783          	ld	a5,-32(s0)
 d7a:	639c                	ld	a5,0(a5)
 d7c:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 d80:	fe843783          	ld	a5,-24(s0)
 d84:	479c                	lw	a5,8(a5)
 d86:	fdc42703          	lw	a4,-36(s0)
 d8a:	2701                	sext.w	a4,a4
 d8c:	06e7e763          	bltu	a5,a4,dfa <malloc+0xf0>
      if(p->s.size == nunits)
 d90:	fe843783          	ld	a5,-24(s0)
 d94:	479c                	lw	a5,8(a5)
 d96:	fdc42703          	lw	a4,-36(s0)
 d9a:	2701                	sext.w	a4,a4
 d9c:	00f71963          	bne	a4,a5,dae <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 da0:	fe843783          	ld	a5,-24(s0)
 da4:	6398                	ld	a4,0(a5)
 da6:	fe043783          	ld	a5,-32(s0)
 daa:	e398                	sd	a4,0(a5)
 dac:	a825                	j	de4 <malloc+0xda>
      else {
        p->s.size -= nunits;
 dae:	fe843783          	ld	a5,-24(s0)
 db2:	479c                	lw	a5,8(a5)
 db4:	fdc42703          	lw	a4,-36(s0)
 db8:	9f99                	subw	a5,a5,a4
 dba:	0007871b          	sext.w	a4,a5
 dbe:	fe843783          	ld	a5,-24(s0)
 dc2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 dc4:	fe843783          	ld	a5,-24(s0)
 dc8:	479c                	lw	a5,8(a5)
 dca:	1782                	slli	a5,a5,0x20
 dcc:	9381                	srli	a5,a5,0x20
 dce:	0792                	slli	a5,a5,0x4
 dd0:	fe843703          	ld	a4,-24(s0)
 dd4:	97ba                	add	a5,a5,a4
 dd6:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 dda:	fe843783          	ld	a5,-24(s0)
 dde:	fdc42703          	lw	a4,-36(s0)
 de2:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 de4:	00000797          	auipc	a5,0x0
 de8:	25c78793          	addi	a5,a5,604 # 1040 <freep>
 dec:	fe043703          	ld	a4,-32(s0)
 df0:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 df2:	fe843783          	ld	a5,-24(s0)
 df6:	07c1                	addi	a5,a5,16
 df8:	a091                	j	e3c <malloc+0x132>
    }
    if(p == freep)
 dfa:	00000797          	auipc	a5,0x0
 dfe:	24678793          	addi	a5,a5,582 # 1040 <freep>
 e02:	639c                	ld	a5,0(a5)
 e04:	fe843703          	ld	a4,-24(s0)
 e08:	02f71063          	bne	a4,a5,e28 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 e0c:	fdc42783          	lw	a5,-36(s0)
 e10:	853e                	mv	a0,a5
 e12:	00000097          	auipc	ra,0x0
 e16:	e7a080e7          	jalr	-390(ra) # c8c <morecore>
 e1a:	fea43423          	sd	a0,-24(s0)
 e1e:	fe843783          	ld	a5,-24(s0)
 e22:	e399                	bnez	a5,e28 <malloc+0x11e>
        return 0;
 e24:	4781                	li	a5,0
 e26:	a819                	j	e3c <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e28:	fe843783          	ld	a5,-24(s0)
 e2c:	fef43023          	sd	a5,-32(s0)
 e30:	fe843783          	ld	a5,-24(s0)
 e34:	639c                	ld	a5,0(a5)
 e36:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 e3a:	b799                	j	d80 <malloc+0x76>
  }
}
 e3c:	853e                	mv	a0,a5
 e3e:	70e2                	ld	ra,56(sp)
 e40:	7442                	ld	s0,48(sp)
 e42:	6121                	addi	sp,sp,64
 e44:	8082                	ret
