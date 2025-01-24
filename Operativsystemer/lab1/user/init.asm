
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
   e:	e3e50513          	addi	a0,a0,-450 # e48 <malloc+0x146>
  12:	00000097          	auipc	ra,0x0
  16:	618080e7          	jalr	1560(ra) # 62a <open>
  1a:	87aa                	mv	a5,a0
  1c:	0207d563          	bgez	a5,46 <main+0x46>
    mknod("console", CONSOLE, 0);
  20:	4601                	li	a2,0
  22:	4585                	li	a1,1
  24:	00001517          	auipc	a0,0x1
  28:	e2450513          	addi	a0,a0,-476 # e48 <malloc+0x146>
  2c:	00000097          	auipc	ra,0x0
  30:	606080e7          	jalr	1542(ra) # 632 <mknod>
    open("console", O_RDWR);
  34:	4589                	li	a1,2
  36:	00001517          	auipc	a0,0x1
  3a:	e1250513          	addi	a0,a0,-494 # e48 <malloc+0x146>
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
  5e:	df650513          	addi	a0,a0,-522 # e50 <malloc+0x14e>
  62:	00001097          	auipc	ra,0x1
  66:	aac080e7          	jalr	-1364(ra) # b0e <printf>
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
  86:	de650513          	addi	a0,a0,-538 # e68 <malloc+0x166>
  8a:	00001097          	auipc	ra,0x1
  8e:	a84080e7          	jalr	-1404(ra) # b0e <printf>
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
  b0:	d9450513          	addi	a0,a0,-620 # e40 <malloc+0x13e>
  b4:	00000097          	auipc	ra,0x0
  b8:	56e080e7          	jalr	1390(ra) # 622 <exec>
      printf("init: exec sh failed\n");
  bc:	00001517          	auipc	a0,0x1
  c0:	dc450513          	addi	a0,a0,-572 # e80 <malloc+0x17e>
  c4:	00001097          	auipc	ra,0x1
  c8:	a4a080e7          	jalr	-1462(ra) # b0e <printf>
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
 106:	d9650513          	addi	a0,a0,-618 # e98 <malloc+0x196>
 10a:	00001097          	auipc	ra,0x1
 10e:	a04080e7          	jalr	-1532(ra) # b0e <printf>
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

000000000000068a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 68a:	1101                	addi	sp,sp,-32
 68c:	ec06                	sd	ra,24(sp)
 68e:	e822                	sd	s0,16(sp)
 690:	1000                	addi	s0,sp,32
 692:	87aa                	mv	a5,a0
 694:	872e                	mv	a4,a1
 696:	fef42623          	sw	a5,-20(s0)
 69a:	87ba                	mv	a5,a4
 69c:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 6a0:	feb40713          	addi	a4,s0,-21
 6a4:	fec42783          	lw	a5,-20(s0)
 6a8:	4605                	li	a2,1
 6aa:	85ba                	mv	a1,a4
 6ac:	853e                	mv	a0,a5
 6ae:	00000097          	auipc	ra,0x0
 6b2:	f5c080e7          	jalr	-164(ra) # 60a <write>
}
 6b6:	0001                	nop
 6b8:	60e2                	ld	ra,24(sp)
 6ba:	6442                	ld	s0,16(sp)
 6bc:	6105                	addi	sp,sp,32
 6be:	8082                	ret

00000000000006c0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6c0:	7139                	addi	sp,sp,-64
 6c2:	fc06                	sd	ra,56(sp)
 6c4:	f822                	sd	s0,48(sp)
 6c6:	0080                	addi	s0,sp,64
 6c8:	87aa                	mv	a5,a0
 6ca:	8736                	mv	a4,a3
 6cc:	fcf42623          	sw	a5,-52(s0)
 6d0:	87ae                	mv	a5,a1
 6d2:	fcf42423          	sw	a5,-56(s0)
 6d6:	87b2                	mv	a5,a2
 6d8:	fcf42223          	sw	a5,-60(s0)
 6dc:	87ba                	mv	a5,a4
 6de:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6e2:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 6e6:	fc042783          	lw	a5,-64(s0)
 6ea:	2781                	sext.w	a5,a5
 6ec:	c38d                	beqz	a5,70e <printint+0x4e>
 6ee:	fc842783          	lw	a5,-56(s0)
 6f2:	2781                	sext.w	a5,a5
 6f4:	0007dd63          	bgez	a5,70e <printint+0x4e>
    neg = 1;
 6f8:	4785                	li	a5,1
 6fa:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 6fe:	fc842783          	lw	a5,-56(s0)
 702:	40f007bb          	negw	a5,a5
 706:	2781                	sext.w	a5,a5
 708:	fef42223          	sw	a5,-28(s0)
 70c:	a029                	j	716 <printint+0x56>
  } else {
    x = xx;
 70e:	fc842783          	lw	a5,-56(s0)
 712:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 716:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 71a:	fc442783          	lw	a5,-60(s0)
 71e:	fe442703          	lw	a4,-28(s0)
 722:	02f777bb          	remuw	a5,a4,a5
 726:	0007871b          	sext.w	a4,a5
 72a:	fec42783          	lw	a5,-20(s0)
 72e:	0017869b          	addiw	a3,a5,1
 732:	fed42623          	sw	a3,-20(s0)
 736:	00001697          	auipc	a3,0x1
 73a:	8da68693          	addi	a3,a3,-1830 # 1010 <digits>
 73e:	1702                	slli	a4,a4,0x20
 740:	9301                	srli	a4,a4,0x20
 742:	9736                	add	a4,a4,a3
 744:	00074703          	lbu	a4,0(a4)
 748:	17c1                	addi	a5,a5,-16
 74a:	97a2                	add	a5,a5,s0
 74c:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 750:	fc442783          	lw	a5,-60(s0)
 754:	fe442703          	lw	a4,-28(s0)
 758:	02f757bb          	divuw	a5,a4,a5
 75c:	fef42223          	sw	a5,-28(s0)
 760:	fe442783          	lw	a5,-28(s0)
 764:	2781                	sext.w	a5,a5
 766:	fbd5                	bnez	a5,71a <printint+0x5a>
  if(neg)
 768:	fe842783          	lw	a5,-24(s0)
 76c:	2781                	sext.w	a5,a5
 76e:	cf85                	beqz	a5,7a6 <printint+0xe6>
    buf[i++] = '-';
 770:	fec42783          	lw	a5,-20(s0)
 774:	0017871b          	addiw	a4,a5,1
 778:	fee42623          	sw	a4,-20(s0)
 77c:	17c1                	addi	a5,a5,-16
 77e:	97a2                	add	a5,a5,s0
 780:	02d00713          	li	a4,45
 784:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 788:	a839                	j	7a6 <printint+0xe6>
    putc(fd, buf[i]);
 78a:	fec42783          	lw	a5,-20(s0)
 78e:	17c1                	addi	a5,a5,-16
 790:	97a2                	add	a5,a5,s0
 792:	fe07c703          	lbu	a4,-32(a5)
 796:	fcc42783          	lw	a5,-52(s0)
 79a:	85ba                	mv	a1,a4
 79c:	853e                	mv	a0,a5
 79e:	00000097          	auipc	ra,0x0
 7a2:	eec080e7          	jalr	-276(ra) # 68a <putc>
  while(--i >= 0)
 7a6:	fec42783          	lw	a5,-20(s0)
 7aa:	37fd                	addiw	a5,a5,-1
 7ac:	fef42623          	sw	a5,-20(s0)
 7b0:	fec42783          	lw	a5,-20(s0)
 7b4:	2781                	sext.w	a5,a5
 7b6:	fc07dae3          	bgez	a5,78a <printint+0xca>
}
 7ba:	0001                	nop
 7bc:	0001                	nop
 7be:	70e2                	ld	ra,56(sp)
 7c0:	7442                	ld	s0,48(sp)
 7c2:	6121                	addi	sp,sp,64
 7c4:	8082                	ret

00000000000007c6 <printptr>:

static void
printptr(int fd, uint64 x) {
 7c6:	7179                	addi	sp,sp,-48
 7c8:	f406                	sd	ra,40(sp)
 7ca:	f022                	sd	s0,32(sp)
 7cc:	1800                	addi	s0,sp,48
 7ce:	87aa                	mv	a5,a0
 7d0:	fcb43823          	sd	a1,-48(s0)
 7d4:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 7d8:	fdc42783          	lw	a5,-36(s0)
 7dc:	03000593          	li	a1,48
 7e0:	853e                	mv	a0,a5
 7e2:	00000097          	auipc	ra,0x0
 7e6:	ea8080e7          	jalr	-344(ra) # 68a <putc>
  putc(fd, 'x');
 7ea:	fdc42783          	lw	a5,-36(s0)
 7ee:	07800593          	li	a1,120
 7f2:	853e                	mv	a0,a5
 7f4:	00000097          	auipc	ra,0x0
 7f8:	e96080e7          	jalr	-362(ra) # 68a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7fc:	fe042623          	sw	zero,-20(s0)
 800:	a82d                	j	83a <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 802:	fd043783          	ld	a5,-48(s0)
 806:	93f1                	srli	a5,a5,0x3c
 808:	00001717          	auipc	a4,0x1
 80c:	80870713          	addi	a4,a4,-2040 # 1010 <digits>
 810:	97ba                	add	a5,a5,a4
 812:	0007c703          	lbu	a4,0(a5)
 816:	fdc42783          	lw	a5,-36(s0)
 81a:	85ba                	mv	a1,a4
 81c:	853e                	mv	a0,a5
 81e:	00000097          	auipc	ra,0x0
 822:	e6c080e7          	jalr	-404(ra) # 68a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 826:	fec42783          	lw	a5,-20(s0)
 82a:	2785                	addiw	a5,a5,1
 82c:	fef42623          	sw	a5,-20(s0)
 830:	fd043783          	ld	a5,-48(s0)
 834:	0792                	slli	a5,a5,0x4
 836:	fcf43823          	sd	a5,-48(s0)
 83a:	fec42703          	lw	a4,-20(s0)
 83e:	47bd                	li	a5,15
 840:	fce7f1e3          	bgeu	a5,a4,802 <printptr+0x3c>
}
 844:	0001                	nop
 846:	0001                	nop
 848:	70a2                	ld	ra,40(sp)
 84a:	7402                	ld	s0,32(sp)
 84c:	6145                	addi	sp,sp,48
 84e:	8082                	ret

0000000000000850 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 850:	715d                	addi	sp,sp,-80
 852:	e486                	sd	ra,72(sp)
 854:	e0a2                	sd	s0,64(sp)
 856:	0880                	addi	s0,sp,80
 858:	87aa                	mv	a5,a0
 85a:	fcb43023          	sd	a1,-64(s0)
 85e:	fac43c23          	sd	a2,-72(s0)
 862:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 866:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 86a:	fe042223          	sw	zero,-28(s0)
 86e:	a42d                	j	a98 <vprintf+0x248>
    c = fmt[i] & 0xff;
 870:	fe442783          	lw	a5,-28(s0)
 874:	fc043703          	ld	a4,-64(s0)
 878:	97ba                	add	a5,a5,a4
 87a:	0007c783          	lbu	a5,0(a5)
 87e:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 882:	fe042783          	lw	a5,-32(s0)
 886:	2781                	sext.w	a5,a5
 888:	eb9d                	bnez	a5,8be <vprintf+0x6e>
      if(c == '%'){
 88a:	fdc42783          	lw	a5,-36(s0)
 88e:	0007871b          	sext.w	a4,a5
 892:	02500793          	li	a5,37
 896:	00f71763          	bne	a4,a5,8a4 <vprintf+0x54>
        state = '%';
 89a:	02500793          	li	a5,37
 89e:	fef42023          	sw	a5,-32(s0)
 8a2:	a2f5                	j	a8e <vprintf+0x23e>
      } else {
        putc(fd, c);
 8a4:	fdc42783          	lw	a5,-36(s0)
 8a8:	0ff7f713          	zext.b	a4,a5
 8ac:	fcc42783          	lw	a5,-52(s0)
 8b0:	85ba                	mv	a1,a4
 8b2:	853e                	mv	a0,a5
 8b4:	00000097          	auipc	ra,0x0
 8b8:	dd6080e7          	jalr	-554(ra) # 68a <putc>
 8bc:	aac9                	j	a8e <vprintf+0x23e>
      }
    } else if(state == '%'){
 8be:	fe042783          	lw	a5,-32(s0)
 8c2:	0007871b          	sext.w	a4,a5
 8c6:	02500793          	li	a5,37
 8ca:	1cf71263          	bne	a4,a5,a8e <vprintf+0x23e>
      if(c == 'd'){
 8ce:	fdc42783          	lw	a5,-36(s0)
 8d2:	0007871b          	sext.w	a4,a5
 8d6:	06400793          	li	a5,100
 8da:	02f71463          	bne	a4,a5,902 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 8de:	fb843783          	ld	a5,-72(s0)
 8e2:	00878713          	addi	a4,a5,8
 8e6:	fae43c23          	sd	a4,-72(s0)
 8ea:	4398                	lw	a4,0(a5)
 8ec:	fcc42783          	lw	a5,-52(s0)
 8f0:	4685                	li	a3,1
 8f2:	4629                	li	a2,10
 8f4:	85ba                	mv	a1,a4
 8f6:	853e                	mv	a0,a5
 8f8:	00000097          	auipc	ra,0x0
 8fc:	dc8080e7          	jalr	-568(ra) # 6c0 <printint>
 900:	a269                	j	a8a <vprintf+0x23a>
      } else if(c == 'l') {
 902:	fdc42783          	lw	a5,-36(s0)
 906:	0007871b          	sext.w	a4,a5
 90a:	06c00793          	li	a5,108
 90e:	02f71663          	bne	a4,a5,93a <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 912:	fb843783          	ld	a5,-72(s0)
 916:	00878713          	addi	a4,a5,8
 91a:	fae43c23          	sd	a4,-72(s0)
 91e:	639c                	ld	a5,0(a5)
 920:	0007871b          	sext.w	a4,a5
 924:	fcc42783          	lw	a5,-52(s0)
 928:	4681                	li	a3,0
 92a:	4629                	li	a2,10
 92c:	85ba                	mv	a1,a4
 92e:	853e                	mv	a0,a5
 930:	00000097          	auipc	ra,0x0
 934:	d90080e7          	jalr	-624(ra) # 6c0 <printint>
 938:	aa89                	j	a8a <vprintf+0x23a>
      } else if(c == 'x') {
 93a:	fdc42783          	lw	a5,-36(s0)
 93e:	0007871b          	sext.w	a4,a5
 942:	07800793          	li	a5,120
 946:	02f71463          	bne	a4,a5,96e <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 94a:	fb843783          	ld	a5,-72(s0)
 94e:	00878713          	addi	a4,a5,8
 952:	fae43c23          	sd	a4,-72(s0)
 956:	4398                	lw	a4,0(a5)
 958:	fcc42783          	lw	a5,-52(s0)
 95c:	4681                	li	a3,0
 95e:	4641                	li	a2,16
 960:	85ba                	mv	a1,a4
 962:	853e                	mv	a0,a5
 964:	00000097          	auipc	ra,0x0
 968:	d5c080e7          	jalr	-676(ra) # 6c0 <printint>
 96c:	aa39                	j	a8a <vprintf+0x23a>
      } else if(c == 'p') {
 96e:	fdc42783          	lw	a5,-36(s0)
 972:	0007871b          	sext.w	a4,a5
 976:	07000793          	li	a5,112
 97a:	02f71263          	bne	a4,a5,99e <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 97e:	fb843783          	ld	a5,-72(s0)
 982:	00878713          	addi	a4,a5,8
 986:	fae43c23          	sd	a4,-72(s0)
 98a:	6398                	ld	a4,0(a5)
 98c:	fcc42783          	lw	a5,-52(s0)
 990:	85ba                	mv	a1,a4
 992:	853e                	mv	a0,a5
 994:	00000097          	auipc	ra,0x0
 998:	e32080e7          	jalr	-462(ra) # 7c6 <printptr>
 99c:	a0fd                	j	a8a <vprintf+0x23a>
      } else if(c == 's'){
 99e:	fdc42783          	lw	a5,-36(s0)
 9a2:	0007871b          	sext.w	a4,a5
 9a6:	07300793          	li	a5,115
 9aa:	04f71c63          	bne	a4,a5,a02 <vprintf+0x1b2>
        s = va_arg(ap, char*);
 9ae:	fb843783          	ld	a5,-72(s0)
 9b2:	00878713          	addi	a4,a5,8
 9b6:	fae43c23          	sd	a4,-72(s0)
 9ba:	639c                	ld	a5,0(a5)
 9bc:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 9c0:	fe843783          	ld	a5,-24(s0)
 9c4:	eb8d                	bnez	a5,9f6 <vprintf+0x1a6>
          s = "(null)";
 9c6:	00000797          	auipc	a5,0x0
 9ca:	4f278793          	addi	a5,a5,1266 # eb8 <malloc+0x1b6>
 9ce:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 9d2:	a015                	j	9f6 <vprintf+0x1a6>
          putc(fd, *s);
 9d4:	fe843783          	ld	a5,-24(s0)
 9d8:	0007c703          	lbu	a4,0(a5)
 9dc:	fcc42783          	lw	a5,-52(s0)
 9e0:	85ba                	mv	a1,a4
 9e2:	853e                	mv	a0,a5
 9e4:	00000097          	auipc	ra,0x0
 9e8:	ca6080e7          	jalr	-858(ra) # 68a <putc>
          s++;
 9ec:	fe843783          	ld	a5,-24(s0)
 9f0:	0785                	addi	a5,a5,1
 9f2:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 9f6:	fe843783          	ld	a5,-24(s0)
 9fa:	0007c783          	lbu	a5,0(a5)
 9fe:	fbf9                	bnez	a5,9d4 <vprintf+0x184>
 a00:	a069                	j	a8a <vprintf+0x23a>
        }
      } else if(c == 'c'){
 a02:	fdc42783          	lw	a5,-36(s0)
 a06:	0007871b          	sext.w	a4,a5
 a0a:	06300793          	li	a5,99
 a0e:	02f71463          	bne	a4,a5,a36 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 a12:	fb843783          	ld	a5,-72(s0)
 a16:	00878713          	addi	a4,a5,8
 a1a:	fae43c23          	sd	a4,-72(s0)
 a1e:	439c                	lw	a5,0(a5)
 a20:	0ff7f713          	zext.b	a4,a5
 a24:	fcc42783          	lw	a5,-52(s0)
 a28:	85ba                	mv	a1,a4
 a2a:	853e                	mv	a0,a5
 a2c:	00000097          	auipc	ra,0x0
 a30:	c5e080e7          	jalr	-930(ra) # 68a <putc>
 a34:	a899                	j	a8a <vprintf+0x23a>
      } else if(c == '%'){
 a36:	fdc42783          	lw	a5,-36(s0)
 a3a:	0007871b          	sext.w	a4,a5
 a3e:	02500793          	li	a5,37
 a42:	00f71f63          	bne	a4,a5,a60 <vprintf+0x210>
        putc(fd, c);
 a46:	fdc42783          	lw	a5,-36(s0)
 a4a:	0ff7f713          	zext.b	a4,a5
 a4e:	fcc42783          	lw	a5,-52(s0)
 a52:	85ba                	mv	a1,a4
 a54:	853e                	mv	a0,a5
 a56:	00000097          	auipc	ra,0x0
 a5a:	c34080e7          	jalr	-972(ra) # 68a <putc>
 a5e:	a035                	j	a8a <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 a60:	fcc42783          	lw	a5,-52(s0)
 a64:	02500593          	li	a1,37
 a68:	853e                	mv	a0,a5
 a6a:	00000097          	auipc	ra,0x0
 a6e:	c20080e7          	jalr	-992(ra) # 68a <putc>
        putc(fd, c);
 a72:	fdc42783          	lw	a5,-36(s0)
 a76:	0ff7f713          	zext.b	a4,a5
 a7a:	fcc42783          	lw	a5,-52(s0)
 a7e:	85ba                	mv	a1,a4
 a80:	853e                	mv	a0,a5
 a82:	00000097          	auipc	ra,0x0
 a86:	c08080e7          	jalr	-1016(ra) # 68a <putc>
      }
      state = 0;
 a8a:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 a8e:	fe442783          	lw	a5,-28(s0)
 a92:	2785                	addiw	a5,a5,1
 a94:	fef42223          	sw	a5,-28(s0)
 a98:	fe442783          	lw	a5,-28(s0)
 a9c:	fc043703          	ld	a4,-64(s0)
 aa0:	97ba                	add	a5,a5,a4
 aa2:	0007c783          	lbu	a5,0(a5)
 aa6:	dc0795e3          	bnez	a5,870 <vprintf+0x20>
    }
  }
}
 aaa:	0001                	nop
 aac:	0001                	nop
 aae:	60a6                	ld	ra,72(sp)
 ab0:	6406                	ld	s0,64(sp)
 ab2:	6161                	addi	sp,sp,80
 ab4:	8082                	ret

0000000000000ab6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 ab6:	7159                	addi	sp,sp,-112
 ab8:	fc06                	sd	ra,56(sp)
 aba:	f822                	sd	s0,48(sp)
 abc:	0080                	addi	s0,sp,64
 abe:	fcb43823          	sd	a1,-48(s0)
 ac2:	e010                	sd	a2,0(s0)
 ac4:	e414                	sd	a3,8(s0)
 ac6:	e818                	sd	a4,16(s0)
 ac8:	ec1c                	sd	a5,24(s0)
 aca:	03043023          	sd	a6,32(s0)
 ace:	03143423          	sd	a7,40(s0)
 ad2:	87aa                	mv	a5,a0
 ad4:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 ad8:	03040793          	addi	a5,s0,48
 adc:	fcf43423          	sd	a5,-56(s0)
 ae0:	fc843783          	ld	a5,-56(s0)
 ae4:	fd078793          	addi	a5,a5,-48
 ae8:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 aec:	fe843703          	ld	a4,-24(s0)
 af0:	fdc42783          	lw	a5,-36(s0)
 af4:	863a                	mv	a2,a4
 af6:	fd043583          	ld	a1,-48(s0)
 afa:	853e                	mv	a0,a5
 afc:	00000097          	auipc	ra,0x0
 b00:	d54080e7          	jalr	-684(ra) # 850 <vprintf>
}
 b04:	0001                	nop
 b06:	70e2                	ld	ra,56(sp)
 b08:	7442                	ld	s0,48(sp)
 b0a:	6165                	addi	sp,sp,112
 b0c:	8082                	ret

0000000000000b0e <printf>:

void
printf(const char *fmt, ...)
{
 b0e:	7159                	addi	sp,sp,-112
 b10:	f406                	sd	ra,40(sp)
 b12:	f022                	sd	s0,32(sp)
 b14:	1800                	addi	s0,sp,48
 b16:	fca43c23          	sd	a0,-40(s0)
 b1a:	e40c                	sd	a1,8(s0)
 b1c:	e810                	sd	a2,16(s0)
 b1e:	ec14                	sd	a3,24(s0)
 b20:	f018                	sd	a4,32(s0)
 b22:	f41c                	sd	a5,40(s0)
 b24:	03043823          	sd	a6,48(s0)
 b28:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b2c:	04040793          	addi	a5,s0,64
 b30:	fcf43823          	sd	a5,-48(s0)
 b34:	fd043783          	ld	a5,-48(s0)
 b38:	fc878793          	addi	a5,a5,-56
 b3c:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 b40:	fe843783          	ld	a5,-24(s0)
 b44:	863e                	mv	a2,a5
 b46:	fd843583          	ld	a1,-40(s0)
 b4a:	4505                	li	a0,1
 b4c:	00000097          	auipc	ra,0x0
 b50:	d04080e7          	jalr	-764(ra) # 850 <vprintf>
}
 b54:	0001                	nop
 b56:	70a2                	ld	ra,40(sp)
 b58:	7402                	ld	s0,32(sp)
 b5a:	6165                	addi	sp,sp,112
 b5c:	8082                	ret

0000000000000b5e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b5e:	7179                	addi	sp,sp,-48
 b60:	f406                	sd	ra,40(sp)
 b62:	f022                	sd	s0,32(sp)
 b64:	1800                	addi	s0,sp,48
 b66:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b6a:	fd843783          	ld	a5,-40(s0)
 b6e:	17c1                	addi	a5,a5,-16
 b70:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b74:	00000797          	auipc	a5,0x0
 b78:	4cc78793          	addi	a5,a5,1228 # 1040 <freep>
 b7c:	639c                	ld	a5,0(a5)
 b7e:	fef43423          	sd	a5,-24(s0)
 b82:	a815                	j	bb6 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b84:	fe843783          	ld	a5,-24(s0)
 b88:	639c                	ld	a5,0(a5)
 b8a:	fe843703          	ld	a4,-24(s0)
 b8e:	00f76f63          	bltu	a4,a5,bac <free+0x4e>
 b92:	fe043703          	ld	a4,-32(s0)
 b96:	fe843783          	ld	a5,-24(s0)
 b9a:	02e7eb63          	bltu	a5,a4,bd0 <free+0x72>
 b9e:	fe843783          	ld	a5,-24(s0)
 ba2:	639c                	ld	a5,0(a5)
 ba4:	fe043703          	ld	a4,-32(s0)
 ba8:	02f76463          	bltu	a4,a5,bd0 <free+0x72>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bac:	fe843783          	ld	a5,-24(s0)
 bb0:	639c                	ld	a5,0(a5)
 bb2:	fef43423          	sd	a5,-24(s0)
 bb6:	fe043703          	ld	a4,-32(s0)
 bba:	fe843783          	ld	a5,-24(s0)
 bbe:	fce7f3e3          	bgeu	a5,a4,b84 <free+0x26>
 bc2:	fe843783          	ld	a5,-24(s0)
 bc6:	639c                	ld	a5,0(a5)
 bc8:	fe043703          	ld	a4,-32(s0)
 bcc:	faf77ce3          	bgeu	a4,a5,b84 <free+0x26>
      break;
  if(bp + bp->s.size == p->s.ptr){
 bd0:	fe043783          	ld	a5,-32(s0)
 bd4:	479c                	lw	a5,8(a5)
 bd6:	1782                	slli	a5,a5,0x20
 bd8:	9381                	srli	a5,a5,0x20
 bda:	0792                	slli	a5,a5,0x4
 bdc:	fe043703          	ld	a4,-32(s0)
 be0:	973e                	add	a4,a4,a5
 be2:	fe843783          	ld	a5,-24(s0)
 be6:	639c                	ld	a5,0(a5)
 be8:	02f71763          	bne	a4,a5,c16 <free+0xb8>
    bp->s.size += p->s.ptr->s.size;
 bec:	fe043783          	ld	a5,-32(s0)
 bf0:	4798                	lw	a4,8(a5)
 bf2:	fe843783          	ld	a5,-24(s0)
 bf6:	639c                	ld	a5,0(a5)
 bf8:	479c                	lw	a5,8(a5)
 bfa:	9fb9                	addw	a5,a5,a4
 bfc:	0007871b          	sext.w	a4,a5
 c00:	fe043783          	ld	a5,-32(s0)
 c04:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 c06:	fe843783          	ld	a5,-24(s0)
 c0a:	639c                	ld	a5,0(a5)
 c0c:	6398                	ld	a4,0(a5)
 c0e:	fe043783          	ld	a5,-32(s0)
 c12:	e398                	sd	a4,0(a5)
 c14:	a039                	j	c22 <free+0xc4>
  } else
    bp->s.ptr = p->s.ptr;
 c16:	fe843783          	ld	a5,-24(s0)
 c1a:	6398                	ld	a4,0(a5)
 c1c:	fe043783          	ld	a5,-32(s0)
 c20:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 c22:	fe843783          	ld	a5,-24(s0)
 c26:	479c                	lw	a5,8(a5)
 c28:	1782                	slli	a5,a5,0x20
 c2a:	9381                	srli	a5,a5,0x20
 c2c:	0792                	slli	a5,a5,0x4
 c2e:	fe843703          	ld	a4,-24(s0)
 c32:	97ba                	add	a5,a5,a4
 c34:	fe043703          	ld	a4,-32(s0)
 c38:	02f71563          	bne	a4,a5,c62 <free+0x104>
    p->s.size += bp->s.size;
 c3c:	fe843783          	ld	a5,-24(s0)
 c40:	4798                	lw	a4,8(a5)
 c42:	fe043783          	ld	a5,-32(s0)
 c46:	479c                	lw	a5,8(a5)
 c48:	9fb9                	addw	a5,a5,a4
 c4a:	0007871b          	sext.w	a4,a5
 c4e:	fe843783          	ld	a5,-24(s0)
 c52:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 c54:	fe043783          	ld	a5,-32(s0)
 c58:	6398                	ld	a4,0(a5)
 c5a:	fe843783          	ld	a5,-24(s0)
 c5e:	e398                	sd	a4,0(a5)
 c60:	a031                	j	c6c <free+0x10e>
  } else
    p->s.ptr = bp;
 c62:	fe843783          	ld	a5,-24(s0)
 c66:	fe043703          	ld	a4,-32(s0)
 c6a:	e398                	sd	a4,0(a5)
  freep = p;
 c6c:	00000797          	auipc	a5,0x0
 c70:	3d478793          	addi	a5,a5,980 # 1040 <freep>
 c74:	fe843703          	ld	a4,-24(s0)
 c78:	e398                	sd	a4,0(a5)
}
 c7a:	0001                	nop
 c7c:	70a2                	ld	ra,40(sp)
 c7e:	7402                	ld	s0,32(sp)
 c80:	6145                	addi	sp,sp,48
 c82:	8082                	ret

0000000000000c84 <morecore>:

static Header*
morecore(uint nu)
{
 c84:	7179                	addi	sp,sp,-48
 c86:	f406                	sd	ra,40(sp)
 c88:	f022                	sd	s0,32(sp)
 c8a:	1800                	addi	s0,sp,48
 c8c:	87aa                	mv	a5,a0
 c8e:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 c92:	fdc42783          	lw	a5,-36(s0)
 c96:	0007871b          	sext.w	a4,a5
 c9a:	6785                	lui	a5,0x1
 c9c:	00f77563          	bgeu	a4,a5,ca6 <morecore+0x22>
    nu = 4096;
 ca0:	6785                	lui	a5,0x1
 ca2:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 ca6:	fdc42783          	lw	a5,-36(s0)
 caa:	0047979b          	slliw	a5,a5,0x4
 cae:	2781                	sext.w	a5,a5
 cb0:	853e                	mv	a0,a5
 cb2:	00000097          	auipc	ra,0x0
 cb6:	9c0080e7          	jalr	-1600(ra) # 672 <sbrk>
 cba:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 cbe:	fe843703          	ld	a4,-24(s0)
 cc2:	57fd                	li	a5,-1
 cc4:	00f71463          	bne	a4,a5,ccc <morecore+0x48>
    return 0;
 cc8:	4781                	li	a5,0
 cca:	a03d                	j	cf8 <morecore+0x74>
  hp = (Header*)p;
 ccc:	fe843783          	ld	a5,-24(s0)
 cd0:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 cd4:	fe043783          	ld	a5,-32(s0)
 cd8:	fdc42703          	lw	a4,-36(s0)
 cdc:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 cde:	fe043783          	ld	a5,-32(s0)
 ce2:	07c1                	addi	a5,a5,16 # 1010 <digits>
 ce4:	853e                	mv	a0,a5
 ce6:	00000097          	auipc	ra,0x0
 cea:	e78080e7          	jalr	-392(ra) # b5e <free>
  return freep;
 cee:	00000797          	auipc	a5,0x0
 cf2:	35278793          	addi	a5,a5,850 # 1040 <freep>
 cf6:	639c                	ld	a5,0(a5)
}
 cf8:	853e                	mv	a0,a5
 cfa:	70a2                	ld	ra,40(sp)
 cfc:	7402                	ld	s0,32(sp)
 cfe:	6145                	addi	sp,sp,48
 d00:	8082                	ret

0000000000000d02 <malloc>:

void*
malloc(uint nbytes)
{
 d02:	7139                	addi	sp,sp,-64
 d04:	fc06                	sd	ra,56(sp)
 d06:	f822                	sd	s0,48(sp)
 d08:	0080                	addi	s0,sp,64
 d0a:	87aa                	mv	a5,a0
 d0c:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d10:	fcc46783          	lwu	a5,-52(s0)
 d14:	07bd                	addi	a5,a5,15
 d16:	8391                	srli	a5,a5,0x4
 d18:	2781                	sext.w	a5,a5
 d1a:	2785                	addiw	a5,a5,1
 d1c:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 d20:	00000797          	auipc	a5,0x0
 d24:	32078793          	addi	a5,a5,800 # 1040 <freep>
 d28:	639c                	ld	a5,0(a5)
 d2a:	fef43023          	sd	a5,-32(s0)
 d2e:	fe043783          	ld	a5,-32(s0)
 d32:	ef95                	bnez	a5,d6e <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 d34:	00000797          	auipc	a5,0x0
 d38:	2fc78793          	addi	a5,a5,764 # 1030 <base>
 d3c:	fef43023          	sd	a5,-32(s0)
 d40:	00000797          	auipc	a5,0x0
 d44:	30078793          	addi	a5,a5,768 # 1040 <freep>
 d48:	fe043703          	ld	a4,-32(s0)
 d4c:	e398                	sd	a4,0(a5)
 d4e:	00000797          	auipc	a5,0x0
 d52:	2f278793          	addi	a5,a5,754 # 1040 <freep>
 d56:	6398                	ld	a4,0(a5)
 d58:	00000797          	auipc	a5,0x0
 d5c:	2d878793          	addi	a5,a5,728 # 1030 <base>
 d60:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 d62:	00000797          	auipc	a5,0x0
 d66:	2ce78793          	addi	a5,a5,718 # 1030 <base>
 d6a:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d6e:	fe043783          	ld	a5,-32(s0)
 d72:	639c                	ld	a5,0(a5)
 d74:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 d78:	fe843783          	ld	a5,-24(s0)
 d7c:	479c                	lw	a5,8(a5)
 d7e:	fdc42703          	lw	a4,-36(s0)
 d82:	2701                	sext.w	a4,a4
 d84:	06e7e763          	bltu	a5,a4,df2 <malloc+0xf0>
      if(p->s.size == nunits)
 d88:	fe843783          	ld	a5,-24(s0)
 d8c:	479c                	lw	a5,8(a5)
 d8e:	fdc42703          	lw	a4,-36(s0)
 d92:	2701                	sext.w	a4,a4
 d94:	00f71963          	bne	a4,a5,da6 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 d98:	fe843783          	ld	a5,-24(s0)
 d9c:	6398                	ld	a4,0(a5)
 d9e:	fe043783          	ld	a5,-32(s0)
 da2:	e398                	sd	a4,0(a5)
 da4:	a825                	j	ddc <malloc+0xda>
      else {
        p->s.size -= nunits;
 da6:	fe843783          	ld	a5,-24(s0)
 daa:	479c                	lw	a5,8(a5)
 dac:	fdc42703          	lw	a4,-36(s0)
 db0:	9f99                	subw	a5,a5,a4
 db2:	0007871b          	sext.w	a4,a5
 db6:	fe843783          	ld	a5,-24(s0)
 dba:	c798                	sw	a4,8(a5)
        p += p->s.size;
 dbc:	fe843783          	ld	a5,-24(s0)
 dc0:	479c                	lw	a5,8(a5)
 dc2:	1782                	slli	a5,a5,0x20
 dc4:	9381                	srli	a5,a5,0x20
 dc6:	0792                	slli	a5,a5,0x4
 dc8:	fe843703          	ld	a4,-24(s0)
 dcc:	97ba                	add	a5,a5,a4
 dce:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 dd2:	fe843783          	ld	a5,-24(s0)
 dd6:	fdc42703          	lw	a4,-36(s0)
 dda:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 ddc:	00000797          	auipc	a5,0x0
 de0:	26478793          	addi	a5,a5,612 # 1040 <freep>
 de4:	fe043703          	ld	a4,-32(s0)
 de8:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 dea:	fe843783          	ld	a5,-24(s0)
 dee:	07c1                	addi	a5,a5,16
 df0:	a091                	j	e34 <malloc+0x132>
    }
    if(p == freep)
 df2:	00000797          	auipc	a5,0x0
 df6:	24e78793          	addi	a5,a5,590 # 1040 <freep>
 dfa:	639c                	ld	a5,0(a5)
 dfc:	fe843703          	ld	a4,-24(s0)
 e00:	02f71063          	bne	a4,a5,e20 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 e04:	fdc42783          	lw	a5,-36(s0)
 e08:	853e                	mv	a0,a5
 e0a:	00000097          	auipc	ra,0x0
 e0e:	e7a080e7          	jalr	-390(ra) # c84 <morecore>
 e12:	fea43423          	sd	a0,-24(s0)
 e16:	fe843783          	ld	a5,-24(s0)
 e1a:	e399                	bnez	a5,e20 <malloc+0x11e>
        return 0;
 e1c:	4781                	li	a5,0
 e1e:	a819                	j	e34 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e20:	fe843783          	ld	a5,-24(s0)
 e24:	fef43023          	sd	a5,-32(s0)
 e28:	fe843783          	ld	a5,-24(s0)
 e2c:	639c                	ld	a5,0(a5)
 e2e:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 e32:	b799                	j	d78 <malloc+0x76>
  }
}
 e34:	853e                	mv	a0,a5
 e36:	70e2                	ld	ra,56(sp)
 e38:	7442                	ld	s0,48(sp)
 e3a:	6121                	addi	sp,sp,64
 e3c:	8082                	ret
