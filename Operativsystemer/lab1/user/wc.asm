
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	0080                	addi	s0,sp,64
   8:	87aa                	mv	a5,a0
   a:	fcb43023          	sd	a1,-64(s0)
   e:	fcf42623          	sw	a5,-52(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  12:	fe042023          	sw	zero,-32(s0)
  16:	fe042783          	lw	a5,-32(s0)
  1a:	fef42223          	sw	a5,-28(s0)
  1e:	fe442783          	lw	a5,-28(s0)
  22:	fef42423          	sw	a5,-24(s0)
  inword = 0;
  26:	fc042e23          	sw	zero,-36(s0)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  2a:	a861                	j	c2 <wc+0xc2>
    for(i=0; i<n; i++){
  2c:	fe042623          	sw	zero,-20(s0)
  30:	a041                	j	b0 <wc+0xb0>
      c++;
  32:	fe042783          	lw	a5,-32(s0)
  36:	2785                	addiw	a5,a5,1
  38:	fef42023          	sw	a5,-32(s0)
      if(buf[i] == '\n')
  3c:	00001717          	auipc	a4,0x1
  40:	fe470713          	addi	a4,a4,-28 # 1020 <buf>
  44:	fec42783          	lw	a5,-20(s0)
  48:	97ba                	add	a5,a5,a4
  4a:	0007c783          	lbu	a5,0(a5)
  4e:	873e                	mv	a4,a5
  50:	47a9                	li	a5,10
  52:	00f71763          	bne	a4,a5,60 <wc+0x60>
        l++;
  56:	fe842783          	lw	a5,-24(s0)
  5a:	2785                	addiw	a5,a5,1
  5c:	fef42423          	sw	a5,-24(s0)
      if(strchr(" \r\t\n\v", buf[i]))
  60:	00001717          	auipc	a4,0x1
  64:	fc070713          	addi	a4,a4,-64 # 1020 <buf>
  68:	fec42783          	lw	a5,-20(s0)
  6c:	97ba                	add	a5,a5,a4
  6e:	0007c783          	lbu	a5,0(a5)
  72:	85be                	mv	a1,a5
  74:	00001517          	auipc	a0,0x1
  78:	edc50513          	addi	a0,a0,-292 # f50 <malloc+0x140>
  7c:	00000097          	auipc	ra,0x0
  80:	31a080e7          	jalr	794(ra) # 396 <strchr>
  84:	87aa                	mv	a5,a0
  86:	c781                	beqz	a5,8e <wc+0x8e>
        inword = 0;
  88:	fc042e23          	sw	zero,-36(s0)
  8c:	a829                	j	a6 <wc+0xa6>
      else if(!inword){
  8e:	fdc42783          	lw	a5,-36(s0)
  92:	2781                	sext.w	a5,a5
  94:	eb89                	bnez	a5,a6 <wc+0xa6>
        w++;
  96:	fe442783          	lw	a5,-28(s0)
  9a:	2785                	addiw	a5,a5,1
  9c:	fef42223          	sw	a5,-28(s0)
        inword = 1;
  a0:	4785                	li	a5,1
  a2:	fcf42e23          	sw	a5,-36(s0)
    for(i=0; i<n; i++){
  a6:	fec42783          	lw	a5,-20(s0)
  aa:	2785                	addiw	a5,a5,1
  ac:	fef42623          	sw	a5,-20(s0)
  b0:	fec42783          	lw	a5,-20(s0)
  b4:	873e                	mv	a4,a5
  b6:	fd842783          	lw	a5,-40(s0)
  ba:	2701                	sext.w	a4,a4
  bc:	2781                	sext.w	a5,a5
  be:	f6f74ae3          	blt	a4,a5,32 <wc+0x32>
  while((n = read(fd, buf, sizeof(buf))) > 0){
  c2:	fcc42783          	lw	a5,-52(s0)
  c6:	20000613          	li	a2,512
  ca:	00001597          	auipc	a1,0x1
  ce:	f5658593          	addi	a1,a1,-170 # 1020 <buf>
  d2:	853e                	mv	a0,a5
  d4:	00000097          	auipc	ra,0x0
  d8:	634080e7          	jalr	1588(ra) # 708 <read>
  dc:	87aa                	mv	a5,a0
  de:	fcf42c23          	sw	a5,-40(s0)
  e2:	fd842783          	lw	a5,-40(s0)
  e6:	2781                	sext.w	a5,a5
  e8:	f4f042e3          	bgtz	a5,2c <wc+0x2c>
      }
    }
  }
  if(n < 0){
  ec:	fd842783          	lw	a5,-40(s0)
  f0:	2781                	sext.w	a5,a5
  f2:	0007df63          	bgez	a5,110 <wc+0x110>
    printf("wc: read error\n");
  f6:	00001517          	auipc	a0,0x1
  fa:	e6250513          	addi	a0,a0,-414 # f58 <malloc+0x148>
  fe:	00001097          	auipc	ra,0x1
 102:	b1e080e7          	jalr	-1250(ra) # c1c <printf>
    exit(1);
 106:	4505                	li	a0,1
 108:	00000097          	auipc	ra,0x0
 10c:	5e8080e7          	jalr	1512(ra) # 6f0 <exit>
  }
  printf("%d %d %d %s\n", l, w, c, name);
 110:	fe042683          	lw	a3,-32(s0)
 114:	fe442603          	lw	a2,-28(s0)
 118:	fe842783          	lw	a5,-24(s0)
 11c:	fc043703          	ld	a4,-64(s0)
 120:	85be                	mv	a1,a5
 122:	00001517          	auipc	a0,0x1
 126:	e4650513          	addi	a0,a0,-442 # f68 <malloc+0x158>
 12a:	00001097          	auipc	ra,0x1
 12e:	af2080e7          	jalr	-1294(ra) # c1c <printf>
}
 132:	0001                	nop
 134:	70e2                	ld	ra,56(sp)
 136:	7442                	ld	s0,48(sp)
 138:	6121                	addi	sp,sp,64
 13a:	8082                	ret

000000000000013c <main>:

int
main(int argc, char *argv[])
{
 13c:	7179                	addi	sp,sp,-48
 13e:	f406                	sd	ra,40(sp)
 140:	f022                	sd	s0,32(sp)
 142:	1800                	addi	s0,sp,48
 144:	87aa                	mv	a5,a0
 146:	fcb43823          	sd	a1,-48(s0)
 14a:	fcf42e23          	sw	a5,-36(s0)
  int fd, i;

  if(argc <= 1){
 14e:	fdc42783          	lw	a5,-36(s0)
 152:	0007871b          	sext.w	a4,a5
 156:	4785                	li	a5,1
 158:	02e7c063          	blt	a5,a4,178 <main+0x3c>
    wc(0, "");
 15c:	00001597          	auipc	a1,0x1
 160:	e1c58593          	addi	a1,a1,-484 # f78 <malloc+0x168>
 164:	4501                	li	a0,0
 166:	00000097          	auipc	ra,0x0
 16a:	e9a080e7          	jalr	-358(ra) # 0 <wc>
    exit(0);
 16e:	4501                	li	a0,0
 170:	00000097          	auipc	ra,0x0
 174:	580080e7          	jalr	1408(ra) # 6f0 <exit>
  }

  for(i = 1; i < argc; i++){
 178:	4785                	li	a5,1
 17a:	fef42623          	sw	a5,-20(s0)
 17e:	a071                	j	20a <main+0xce>
    if((fd = open(argv[i], 0)) < 0){
 180:	fec42783          	lw	a5,-20(s0)
 184:	078e                	slli	a5,a5,0x3
 186:	fd043703          	ld	a4,-48(s0)
 18a:	97ba                	add	a5,a5,a4
 18c:	639c                	ld	a5,0(a5)
 18e:	4581                	li	a1,0
 190:	853e                	mv	a0,a5
 192:	00000097          	auipc	ra,0x0
 196:	59e080e7          	jalr	1438(ra) # 730 <open>
 19a:	87aa                	mv	a5,a0
 19c:	fef42423          	sw	a5,-24(s0)
 1a0:	fe842783          	lw	a5,-24(s0)
 1a4:	2781                	sext.w	a5,a5
 1a6:	0207d763          	bgez	a5,1d4 <main+0x98>
      printf("wc: cannot open %s\n", argv[i]);
 1aa:	fec42783          	lw	a5,-20(s0)
 1ae:	078e                	slli	a5,a5,0x3
 1b0:	fd043703          	ld	a4,-48(s0)
 1b4:	97ba                	add	a5,a5,a4
 1b6:	639c                	ld	a5,0(a5)
 1b8:	85be                	mv	a1,a5
 1ba:	00001517          	auipc	a0,0x1
 1be:	dc650513          	addi	a0,a0,-570 # f80 <malloc+0x170>
 1c2:	00001097          	auipc	ra,0x1
 1c6:	a5a080e7          	jalr	-1446(ra) # c1c <printf>
      exit(1);
 1ca:	4505                	li	a0,1
 1cc:	00000097          	auipc	ra,0x0
 1d0:	524080e7          	jalr	1316(ra) # 6f0 <exit>
    }
    wc(fd, argv[i]);
 1d4:	fec42783          	lw	a5,-20(s0)
 1d8:	078e                	slli	a5,a5,0x3
 1da:	fd043703          	ld	a4,-48(s0)
 1de:	97ba                	add	a5,a5,a4
 1e0:	6398                	ld	a4,0(a5)
 1e2:	fe842783          	lw	a5,-24(s0)
 1e6:	85ba                	mv	a1,a4
 1e8:	853e                	mv	a0,a5
 1ea:	00000097          	auipc	ra,0x0
 1ee:	e16080e7          	jalr	-490(ra) # 0 <wc>
    close(fd);
 1f2:	fe842783          	lw	a5,-24(s0)
 1f6:	853e                	mv	a0,a5
 1f8:	00000097          	auipc	ra,0x0
 1fc:	520080e7          	jalr	1312(ra) # 718 <close>
  for(i = 1; i < argc; i++){
 200:	fec42783          	lw	a5,-20(s0)
 204:	2785                	addiw	a5,a5,1
 206:	fef42623          	sw	a5,-20(s0)
 20a:	fec42783          	lw	a5,-20(s0)
 20e:	873e                	mv	a4,a5
 210:	fdc42783          	lw	a5,-36(s0)
 214:	2701                	sext.w	a4,a4
 216:	2781                	sext.w	a5,a5
 218:	f6f744e3          	blt	a4,a5,180 <main+0x44>
  }
  exit(0);
 21c:	4501                	li	a0,0
 21e:	00000097          	auipc	ra,0x0
 222:	4d2080e7          	jalr	1234(ra) # 6f0 <exit>

0000000000000226 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 226:	1141                	addi	sp,sp,-16
 228:	e406                	sd	ra,8(sp)
 22a:	e022                	sd	s0,0(sp)
 22c:	0800                	addi	s0,sp,16
  extern int main();
  main();
 22e:	00000097          	auipc	ra,0x0
 232:	f0e080e7          	jalr	-242(ra) # 13c <main>
  exit(0);
 236:	4501                	li	a0,0
 238:	00000097          	auipc	ra,0x0
 23c:	4b8080e7          	jalr	1208(ra) # 6f0 <exit>

0000000000000240 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 240:	7179                	addi	sp,sp,-48
 242:	f406                	sd	ra,40(sp)
 244:	f022                	sd	s0,32(sp)
 246:	1800                	addi	s0,sp,48
 248:	fca43c23          	sd	a0,-40(s0)
 24c:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
 250:	fd843783          	ld	a5,-40(s0)
 254:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
 258:	0001                	nop
 25a:	fd043703          	ld	a4,-48(s0)
 25e:	00170793          	addi	a5,a4,1
 262:	fcf43823          	sd	a5,-48(s0)
 266:	fd843783          	ld	a5,-40(s0)
 26a:	00178693          	addi	a3,a5,1
 26e:	fcd43c23          	sd	a3,-40(s0)
 272:	00074703          	lbu	a4,0(a4)
 276:	00e78023          	sb	a4,0(a5)
 27a:	0007c783          	lbu	a5,0(a5)
 27e:	fff1                	bnez	a5,25a <strcpy+0x1a>
    ;
  return os;
 280:	fe843783          	ld	a5,-24(s0)
}
 284:	853e                	mv	a0,a5
 286:	70a2                	ld	ra,40(sp)
 288:	7402                	ld	s0,32(sp)
 28a:	6145                	addi	sp,sp,48
 28c:	8082                	ret

000000000000028e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 28e:	1101                	addi	sp,sp,-32
 290:	ec06                	sd	ra,24(sp)
 292:	e822                	sd	s0,16(sp)
 294:	1000                	addi	s0,sp,32
 296:	fea43423          	sd	a0,-24(s0)
 29a:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
 29e:	a819                	j	2b4 <strcmp+0x26>
    p++, q++;
 2a0:	fe843783          	ld	a5,-24(s0)
 2a4:	0785                	addi	a5,a5,1
 2a6:	fef43423          	sd	a5,-24(s0)
 2aa:	fe043783          	ld	a5,-32(s0)
 2ae:	0785                	addi	a5,a5,1
 2b0:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
 2b4:	fe843783          	ld	a5,-24(s0)
 2b8:	0007c783          	lbu	a5,0(a5)
 2bc:	cb99                	beqz	a5,2d2 <strcmp+0x44>
 2be:	fe843783          	ld	a5,-24(s0)
 2c2:	0007c703          	lbu	a4,0(a5)
 2c6:	fe043783          	ld	a5,-32(s0)
 2ca:	0007c783          	lbu	a5,0(a5)
 2ce:	fcf709e3          	beq	a4,a5,2a0 <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
 2d2:	fe843783          	ld	a5,-24(s0)
 2d6:	0007c783          	lbu	a5,0(a5)
 2da:	0007871b          	sext.w	a4,a5
 2de:	fe043783          	ld	a5,-32(s0)
 2e2:	0007c783          	lbu	a5,0(a5)
 2e6:	2781                	sext.w	a5,a5
 2e8:	40f707bb          	subw	a5,a4,a5
 2ec:	2781                	sext.w	a5,a5
}
 2ee:	853e                	mv	a0,a5
 2f0:	60e2                	ld	ra,24(sp)
 2f2:	6442                	ld	s0,16(sp)
 2f4:	6105                	addi	sp,sp,32
 2f6:	8082                	ret

00000000000002f8 <strlen>:

uint
strlen(const char *s)
{
 2f8:	7179                	addi	sp,sp,-48
 2fa:	f406                	sd	ra,40(sp)
 2fc:	f022                	sd	s0,32(sp)
 2fe:	1800                	addi	s0,sp,48
 300:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
 304:	fe042623          	sw	zero,-20(s0)
 308:	a031                	j	314 <strlen+0x1c>
 30a:	fec42783          	lw	a5,-20(s0)
 30e:	2785                	addiw	a5,a5,1
 310:	fef42623          	sw	a5,-20(s0)
 314:	fec42783          	lw	a5,-20(s0)
 318:	fd843703          	ld	a4,-40(s0)
 31c:	97ba                	add	a5,a5,a4
 31e:	0007c783          	lbu	a5,0(a5)
 322:	f7e5                	bnez	a5,30a <strlen+0x12>
    ;
  return n;
 324:	fec42783          	lw	a5,-20(s0)
}
 328:	853e                	mv	a0,a5
 32a:	70a2                	ld	ra,40(sp)
 32c:	7402                	ld	s0,32(sp)
 32e:	6145                	addi	sp,sp,48
 330:	8082                	ret

0000000000000332 <memset>:

void*
memset(void *dst, int c, uint n)
{
 332:	7179                	addi	sp,sp,-48
 334:	f406                	sd	ra,40(sp)
 336:	f022                	sd	s0,32(sp)
 338:	1800                	addi	s0,sp,48
 33a:	fca43c23          	sd	a0,-40(s0)
 33e:	87ae                	mv	a5,a1
 340:	8732                	mv	a4,a2
 342:	fcf42a23          	sw	a5,-44(s0)
 346:	87ba                	mv	a5,a4
 348:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
 34c:	fd843783          	ld	a5,-40(s0)
 350:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
 354:	fe042623          	sw	zero,-20(s0)
 358:	a00d                	j	37a <memset+0x48>
    cdst[i] = c;
 35a:	fec42783          	lw	a5,-20(s0)
 35e:	fe043703          	ld	a4,-32(s0)
 362:	97ba                	add	a5,a5,a4
 364:	fd442703          	lw	a4,-44(s0)
 368:	0ff77713          	zext.b	a4,a4
 36c:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
 370:	fec42783          	lw	a5,-20(s0)
 374:	2785                	addiw	a5,a5,1
 376:	fef42623          	sw	a5,-20(s0)
 37a:	fec42783          	lw	a5,-20(s0)
 37e:	fd042703          	lw	a4,-48(s0)
 382:	2701                	sext.w	a4,a4
 384:	fce7ebe3          	bltu	a5,a4,35a <memset+0x28>
  }
  return dst;
 388:	fd843783          	ld	a5,-40(s0)
}
 38c:	853e                	mv	a0,a5
 38e:	70a2                	ld	ra,40(sp)
 390:	7402                	ld	s0,32(sp)
 392:	6145                	addi	sp,sp,48
 394:	8082                	ret

0000000000000396 <strchr>:

char*
strchr(const char *s, char c)
{
 396:	1101                	addi	sp,sp,-32
 398:	ec06                	sd	ra,24(sp)
 39a:	e822                	sd	s0,16(sp)
 39c:	1000                	addi	s0,sp,32
 39e:	fea43423          	sd	a0,-24(s0)
 3a2:	87ae                	mv	a5,a1
 3a4:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
 3a8:	a01d                	j	3ce <strchr+0x38>
    if(*s == c)
 3aa:	fe843783          	ld	a5,-24(s0)
 3ae:	0007c703          	lbu	a4,0(a5)
 3b2:	fe744783          	lbu	a5,-25(s0)
 3b6:	0ff7f793          	zext.b	a5,a5
 3ba:	00e79563          	bne	a5,a4,3c4 <strchr+0x2e>
      return (char*)s;
 3be:	fe843783          	ld	a5,-24(s0)
 3c2:	a821                	j	3da <strchr+0x44>
  for(; *s; s++)
 3c4:	fe843783          	ld	a5,-24(s0)
 3c8:	0785                	addi	a5,a5,1
 3ca:	fef43423          	sd	a5,-24(s0)
 3ce:	fe843783          	ld	a5,-24(s0)
 3d2:	0007c783          	lbu	a5,0(a5)
 3d6:	fbf1                	bnez	a5,3aa <strchr+0x14>
  return 0;
 3d8:	4781                	li	a5,0
}
 3da:	853e                	mv	a0,a5
 3dc:	60e2                	ld	ra,24(sp)
 3de:	6442                	ld	s0,16(sp)
 3e0:	6105                	addi	sp,sp,32
 3e2:	8082                	ret

00000000000003e4 <gets>:

char*
gets(char *buf, int max)
{
 3e4:	7179                	addi	sp,sp,-48
 3e6:	f406                	sd	ra,40(sp)
 3e8:	f022                	sd	s0,32(sp)
 3ea:	1800                	addi	s0,sp,48
 3ec:	fca43c23          	sd	a0,-40(s0)
 3f0:	87ae                	mv	a5,a1
 3f2:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3f6:	fe042623          	sw	zero,-20(s0)
 3fa:	a8a1                	j	452 <gets+0x6e>
    cc = read(0, &c, 1);
 3fc:	fe740793          	addi	a5,s0,-25
 400:	4605                	li	a2,1
 402:	85be                	mv	a1,a5
 404:	4501                	li	a0,0
 406:	00000097          	auipc	ra,0x0
 40a:	302080e7          	jalr	770(ra) # 708 <read>
 40e:	87aa                	mv	a5,a0
 410:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
 414:	fe842783          	lw	a5,-24(s0)
 418:	2781                	sext.w	a5,a5
 41a:	04f05663          	blez	a5,466 <gets+0x82>
      break;
    buf[i++] = c;
 41e:	fec42783          	lw	a5,-20(s0)
 422:	0017871b          	addiw	a4,a5,1
 426:	fee42623          	sw	a4,-20(s0)
 42a:	873e                	mv	a4,a5
 42c:	fd843783          	ld	a5,-40(s0)
 430:	97ba                	add	a5,a5,a4
 432:	fe744703          	lbu	a4,-25(s0)
 436:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
 43a:	fe744783          	lbu	a5,-25(s0)
 43e:	873e                	mv	a4,a5
 440:	47a9                	li	a5,10
 442:	02f70363          	beq	a4,a5,468 <gets+0x84>
 446:	fe744783          	lbu	a5,-25(s0)
 44a:	873e                	mv	a4,a5
 44c:	47b5                	li	a5,13
 44e:	00f70d63          	beq	a4,a5,468 <gets+0x84>
  for(i=0; i+1 < max; ){
 452:	fec42783          	lw	a5,-20(s0)
 456:	2785                	addiw	a5,a5,1
 458:	2781                	sext.w	a5,a5
 45a:	fd442703          	lw	a4,-44(s0)
 45e:	2701                	sext.w	a4,a4
 460:	f8e7cee3          	blt	a5,a4,3fc <gets+0x18>
 464:	a011                	j	468 <gets+0x84>
      break;
 466:	0001                	nop
      break;
  }
  buf[i] = '\0';
 468:	fec42783          	lw	a5,-20(s0)
 46c:	fd843703          	ld	a4,-40(s0)
 470:	97ba                	add	a5,a5,a4
 472:	00078023          	sb	zero,0(a5)
  return buf;
 476:	fd843783          	ld	a5,-40(s0)
}
 47a:	853e                	mv	a0,a5
 47c:	70a2                	ld	ra,40(sp)
 47e:	7402                	ld	s0,32(sp)
 480:	6145                	addi	sp,sp,48
 482:	8082                	ret

0000000000000484 <stat>:

int
stat(const char *n, struct stat *st)
{
 484:	7179                	addi	sp,sp,-48
 486:	f406                	sd	ra,40(sp)
 488:	f022                	sd	s0,32(sp)
 48a:	1800                	addi	s0,sp,48
 48c:	fca43c23          	sd	a0,-40(s0)
 490:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 494:	4581                	li	a1,0
 496:	fd843503          	ld	a0,-40(s0)
 49a:	00000097          	auipc	ra,0x0
 49e:	296080e7          	jalr	662(ra) # 730 <open>
 4a2:	87aa                	mv	a5,a0
 4a4:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
 4a8:	fec42783          	lw	a5,-20(s0)
 4ac:	2781                	sext.w	a5,a5
 4ae:	0007d463          	bgez	a5,4b6 <stat+0x32>
    return -1;
 4b2:	57fd                	li	a5,-1
 4b4:	a035                	j	4e0 <stat+0x5c>
  r = fstat(fd, st);
 4b6:	fec42783          	lw	a5,-20(s0)
 4ba:	fd043583          	ld	a1,-48(s0)
 4be:	853e                	mv	a0,a5
 4c0:	00000097          	auipc	ra,0x0
 4c4:	288080e7          	jalr	648(ra) # 748 <fstat>
 4c8:	87aa                	mv	a5,a0
 4ca:	fef42423          	sw	a5,-24(s0)
  close(fd);
 4ce:	fec42783          	lw	a5,-20(s0)
 4d2:	853e                	mv	a0,a5
 4d4:	00000097          	auipc	ra,0x0
 4d8:	244080e7          	jalr	580(ra) # 718 <close>
  return r;
 4dc:	fe842783          	lw	a5,-24(s0)
}
 4e0:	853e                	mv	a0,a5
 4e2:	70a2                	ld	ra,40(sp)
 4e4:	7402                	ld	s0,32(sp)
 4e6:	6145                	addi	sp,sp,48
 4e8:	8082                	ret

00000000000004ea <atoi>:

int
atoi(const char *s)
{
 4ea:	7179                	addi	sp,sp,-48
 4ec:	f406                	sd	ra,40(sp)
 4ee:	f022                	sd	s0,32(sp)
 4f0:	1800                	addi	s0,sp,48
 4f2:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
 4f6:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
 4fa:	a81d                	j	530 <atoi+0x46>
    n = n*10 + *s++ - '0';
 4fc:	fec42783          	lw	a5,-20(s0)
 500:	873e                	mv	a4,a5
 502:	87ba                	mv	a5,a4
 504:	0027979b          	slliw	a5,a5,0x2
 508:	9fb9                	addw	a5,a5,a4
 50a:	0017979b          	slliw	a5,a5,0x1
 50e:	0007871b          	sext.w	a4,a5
 512:	fd843783          	ld	a5,-40(s0)
 516:	00178693          	addi	a3,a5,1
 51a:	fcd43c23          	sd	a3,-40(s0)
 51e:	0007c783          	lbu	a5,0(a5)
 522:	2781                	sext.w	a5,a5
 524:	9fb9                	addw	a5,a5,a4
 526:	2781                	sext.w	a5,a5
 528:	fd07879b          	addiw	a5,a5,-48
 52c:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
 530:	fd843783          	ld	a5,-40(s0)
 534:	0007c783          	lbu	a5,0(a5)
 538:	873e                	mv	a4,a5
 53a:	02f00793          	li	a5,47
 53e:	00e7fb63          	bgeu	a5,a4,554 <atoi+0x6a>
 542:	fd843783          	ld	a5,-40(s0)
 546:	0007c783          	lbu	a5,0(a5)
 54a:	873e                	mv	a4,a5
 54c:	03900793          	li	a5,57
 550:	fae7f6e3          	bgeu	a5,a4,4fc <atoi+0x12>
  return n;
 554:	fec42783          	lw	a5,-20(s0)
}
 558:	853e                	mv	a0,a5
 55a:	70a2                	ld	ra,40(sp)
 55c:	7402                	ld	s0,32(sp)
 55e:	6145                	addi	sp,sp,48
 560:	8082                	ret

0000000000000562 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 562:	7139                	addi	sp,sp,-64
 564:	fc06                	sd	ra,56(sp)
 566:	f822                	sd	s0,48(sp)
 568:	0080                	addi	s0,sp,64
 56a:	fca43c23          	sd	a0,-40(s0)
 56e:	fcb43823          	sd	a1,-48(s0)
 572:	87b2                	mv	a5,a2
 574:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
 578:	fd843783          	ld	a5,-40(s0)
 57c:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
 580:	fd043783          	ld	a5,-48(s0)
 584:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
 588:	fe043703          	ld	a4,-32(s0)
 58c:	fe843783          	ld	a5,-24(s0)
 590:	02e7fc63          	bgeu	a5,a4,5c8 <memmove+0x66>
    while(n-- > 0)
 594:	a00d                	j	5b6 <memmove+0x54>
      *dst++ = *src++;
 596:	fe043703          	ld	a4,-32(s0)
 59a:	00170793          	addi	a5,a4,1
 59e:	fef43023          	sd	a5,-32(s0)
 5a2:	fe843783          	ld	a5,-24(s0)
 5a6:	00178693          	addi	a3,a5,1
 5aa:	fed43423          	sd	a3,-24(s0)
 5ae:	00074703          	lbu	a4,0(a4)
 5b2:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 5b6:	fcc42783          	lw	a5,-52(s0)
 5ba:	fff7871b          	addiw	a4,a5,-1
 5be:	fce42623          	sw	a4,-52(s0)
 5c2:	fcf04ae3          	bgtz	a5,596 <memmove+0x34>
 5c6:	a891                	j	61a <memmove+0xb8>
  } else {
    dst += n;
 5c8:	fcc42783          	lw	a5,-52(s0)
 5cc:	fe843703          	ld	a4,-24(s0)
 5d0:	97ba                	add	a5,a5,a4
 5d2:	fef43423          	sd	a5,-24(s0)
    src += n;
 5d6:	fcc42783          	lw	a5,-52(s0)
 5da:	fe043703          	ld	a4,-32(s0)
 5de:	97ba                	add	a5,a5,a4
 5e0:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
 5e4:	a01d                	j	60a <memmove+0xa8>
      *--dst = *--src;
 5e6:	fe043783          	ld	a5,-32(s0)
 5ea:	17fd                	addi	a5,a5,-1
 5ec:	fef43023          	sd	a5,-32(s0)
 5f0:	fe843783          	ld	a5,-24(s0)
 5f4:	17fd                	addi	a5,a5,-1
 5f6:	fef43423          	sd	a5,-24(s0)
 5fa:	fe043783          	ld	a5,-32(s0)
 5fe:	0007c703          	lbu	a4,0(a5)
 602:	fe843783          	ld	a5,-24(s0)
 606:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 60a:	fcc42783          	lw	a5,-52(s0)
 60e:	fff7871b          	addiw	a4,a5,-1
 612:	fce42623          	sw	a4,-52(s0)
 616:	fcf048e3          	bgtz	a5,5e6 <memmove+0x84>
  }
  return vdst;
 61a:	fd843783          	ld	a5,-40(s0)
}
 61e:	853e                	mv	a0,a5
 620:	70e2                	ld	ra,56(sp)
 622:	7442                	ld	s0,48(sp)
 624:	6121                	addi	sp,sp,64
 626:	8082                	ret

0000000000000628 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 628:	7139                	addi	sp,sp,-64
 62a:	fc06                	sd	ra,56(sp)
 62c:	f822                	sd	s0,48(sp)
 62e:	0080                	addi	s0,sp,64
 630:	fca43c23          	sd	a0,-40(s0)
 634:	fcb43823          	sd	a1,-48(s0)
 638:	87b2                	mv	a5,a2
 63a:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
 63e:	fd843783          	ld	a5,-40(s0)
 642:	fef43423          	sd	a5,-24(s0)
 646:	fd043783          	ld	a5,-48(s0)
 64a:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 64e:	a0a1                	j	696 <memcmp+0x6e>
    if (*p1 != *p2) {
 650:	fe843783          	ld	a5,-24(s0)
 654:	0007c703          	lbu	a4,0(a5)
 658:	fe043783          	ld	a5,-32(s0)
 65c:	0007c783          	lbu	a5,0(a5)
 660:	02f70163          	beq	a4,a5,682 <memcmp+0x5a>
      return *p1 - *p2;
 664:	fe843783          	ld	a5,-24(s0)
 668:	0007c783          	lbu	a5,0(a5)
 66c:	0007871b          	sext.w	a4,a5
 670:	fe043783          	ld	a5,-32(s0)
 674:	0007c783          	lbu	a5,0(a5)
 678:	2781                	sext.w	a5,a5
 67a:	40f707bb          	subw	a5,a4,a5
 67e:	2781                	sext.w	a5,a5
 680:	a01d                	j	6a6 <memcmp+0x7e>
    }
    p1++;
 682:	fe843783          	ld	a5,-24(s0)
 686:	0785                	addi	a5,a5,1
 688:	fef43423          	sd	a5,-24(s0)
    p2++;
 68c:	fe043783          	ld	a5,-32(s0)
 690:	0785                	addi	a5,a5,1
 692:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 696:	fcc42783          	lw	a5,-52(s0)
 69a:	fff7871b          	addiw	a4,a5,-1
 69e:	fce42623          	sw	a4,-52(s0)
 6a2:	f7dd                	bnez	a5,650 <memcmp+0x28>
  }
  return 0;
 6a4:	4781                	li	a5,0
}
 6a6:	853e                	mv	a0,a5
 6a8:	70e2                	ld	ra,56(sp)
 6aa:	7442                	ld	s0,48(sp)
 6ac:	6121                	addi	sp,sp,64
 6ae:	8082                	ret

00000000000006b0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 6b0:	7179                	addi	sp,sp,-48
 6b2:	f406                	sd	ra,40(sp)
 6b4:	f022                	sd	s0,32(sp)
 6b6:	1800                	addi	s0,sp,48
 6b8:	fea43423          	sd	a0,-24(s0)
 6bc:	feb43023          	sd	a1,-32(s0)
 6c0:	87b2                	mv	a5,a2
 6c2:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
 6c6:	fdc42783          	lw	a5,-36(s0)
 6ca:	863e                	mv	a2,a5
 6cc:	fe043583          	ld	a1,-32(s0)
 6d0:	fe843503          	ld	a0,-24(s0)
 6d4:	00000097          	auipc	ra,0x0
 6d8:	e8e080e7          	jalr	-370(ra) # 562 <memmove>
 6dc:	87aa                	mv	a5,a0
}
 6de:	853e                	mv	a0,a5
 6e0:	70a2                	ld	ra,40(sp)
 6e2:	7402                	ld	s0,32(sp)
 6e4:	6145                	addi	sp,sp,48
 6e6:	8082                	ret

00000000000006e8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6e8:	4885                	li	a7,1
 ecall
 6ea:	00000073          	ecall
 ret
 6ee:	8082                	ret

00000000000006f0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 6f0:	4889                	li	a7,2
 ecall
 6f2:	00000073          	ecall
 ret
 6f6:	8082                	ret

00000000000006f8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 6f8:	488d                	li	a7,3
 ecall
 6fa:	00000073          	ecall
 ret
 6fe:	8082                	ret

0000000000000700 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 700:	4891                	li	a7,4
 ecall
 702:	00000073          	ecall
 ret
 706:	8082                	ret

0000000000000708 <read>:
.global read
read:
 li a7, SYS_read
 708:	4895                	li	a7,5
 ecall
 70a:	00000073          	ecall
 ret
 70e:	8082                	ret

0000000000000710 <write>:
.global write
write:
 li a7, SYS_write
 710:	48c1                	li	a7,16
 ecall
 712:	00000073          	ecall
 ret
 716:	8082                	ret

0000000000000718 <close>:
.global close
close:
 li a7, SYS_close
 718:	48d5                	li	a7,21
 ecall
 71a:	00000073          	ecall
 ret
 71e:	8082                	ret

0000000000000720 <kill>:
.global kill
kill:
 li a7, SYS_kill
 720:	4899                	li	a7,6
 ecall
 722:	00000073          	ecall
 ret
 726:	8082                	ret

0000000000000728 <exec>:
.global exec
exec:
 li a7, SYS_exec
 728:	489d                	li	a7,7
 ecall
 72a:	00000073          	ecall
 ret
 72e:	8082                	ret

0000000000000730 <open>:
.global open
open:
 li a7, SYS_open
 730:	48bd                	li	a7,15
 ecall
 732:	00000073          	ecall
 ret
 736:	8082                	ret

0000000000000738 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 738:	48c5                	li	a7,17
 ecall
 73a:	00000073          	ecall
 ret
 73e:	8082                	ret

0000000000000740 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 740:	48c9                	li	a7,18
 ecall
 742:	00000073          	ecall
 ret
 746:	8082                	ret

0000000000000748 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 748:	48a1                	li	a7,8
 ecall
 74a:	00000073          	ecall
 ret
 74e:	8082                	ret

0000000000000750 <link>:
.global link
link:
 li a7, SYS_link
 750:	48cd                	li	a7,19
 ecall
 752:	00000073          	ecall
 ret
 756:	8082                	ret

0000000000000758 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 758:	48d1                	li	a7,20
 ecall
 75a:	00000073          	ecall
 ret
 75e:	8082                	ret

0000000000000760 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 760:	48a5                	li	a7,9
 ecall
 762:	00000073          	ecall
 ret
 766:	8082                	ret

0000000000000768 <dup>:
.global dup
dup:
 li a7, SYS_dup
 768:	48a9                	li	a7,10
 ecall
 76a:	00000073          	ecall
 ret
 76e:	8082                	ret

0000000000000770 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 770:	48ad                	li	a7,11
 ecall
 772:	00000073          	ecall
 ret
 776:	8082                	ret

0000000000000778 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 778:	48b1                	li	a7,12
 ecall
 77a:	00000073          	ecall
 ret
 77e:	8082                	ret

0000000000000780 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 780:	48b5                	li	a7,13
 ecall
 782:	00000073          	ecall
 ret
 786:	8082                	ret

0000000000000788 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 788:	48b9                	li	a7,14
 ecall
 78a:	00000073          	ecall
 ret
 78e:	8082                	ret

0000000000000790 <ps>:
.global ps
ps:
 li a7, SYS_ps
 790:	48d9                	li	a7,22
 ecall
 792:	00000073          	ecall
 ret
 796:	8082                	ret

0000000000000798 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 798:	1101                	addi	sp,sp,-32
 79a:	ec06                	sd	ra,24(sp)
 79c:	e822                	sd	s0,16(sp)
 79e:	1000                	addi	s0,sp,32
 7a0:	87aa                	mv	a5,a0
 7a2:	872e                	mv	a4,a1
 7a4:	fef42623          	sw	a5,-20(s0)
 7a8:	87ba                	mv	a5,a4
 7aa:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 7ae:	feb40713          	addi	a4,s0,-21
 7b2:	fec42783          	lw	a5,-20(s0)
 7b6:	4605                	li	a2,1
 7b8:	85ba                	mv	a1,a4
 7ba:	853e                	mv	a0,a5
 7bc:	00000097          	auipc	ra,0x0
 7c0:	f54080e7          	jalr	-172(ra) # 710 <write>
}
 7c4:	0001                	nop
 7c6:	60e2                	ld	ra,24(sp)
 7c8:	6442                	ld	s0,16(sp)
 7ca:	6105                	addi	sp,sp,32
 7cc:	8082                	ret

00000000000007ce <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7ce:	7139                	addi	sp,sp,-64
 7d0:	fc06                	sd	ra,56(sp)
 7d2:	f822                	sd	s0,48(sp)
 7d4:	0080                	addi	s0,sp,64
 7d6:	87aa                	mv	a5,a0
 7d8:	8736                	mv	a4,a3
 7da:	fcf42623          	sw	a5,-52(s0)
 7de:	87ae                	mv	a5,a1
 7e0:	fcf42423          	sw	a5,-56(s0)
 7e4:	87b2                	mv	a5,a2
 7e6:	fcf42223          	sw	a5,-60(s0)
 7ea:	87ba                	mv	a5,a4
 7ec:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 7f0:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 7f4:	fc042783          	lw	a5,-64(s0)
 7f8:	2781                	sext.w	a5,a5
 7fa:	c38d                	beqz	a5,81c <printint+0x4e>
 7fc:	fc842783          	lw	a5,-56(s0)
 800:	2781                	sext.w	a5,a5
 802:	0007dd63          	bgez	a5,81c <printint+0x4e>
    neg = 1;
 806:	4785                	li	a5,1
 808:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 80c:	fc842783          	lw	a5,-56(s0)
 810:	40f007bb          	negw	a5,a5
 814:	2781                	sext.w	a5,a5
 816:	fef42223          	sw	a5,-28(s0)
 81a:	a029                	j	824 <printint+0x56>
  } else {
    x = xx;
 81c:	fc842783          	lw	a5,-56(s0)
 820:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 824:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 828:	fc442783          	lw	a5,-60(s0)
 82c:	fe442703          	lw	a4,-28(s0)
 830:	02f777bb          	remuw	a5,a4,a5
 834:	0007871b          	sext.w	a4,a5
 838:	fec42783          	lw	a5,-20(s0)
 83c:	0017869b          	addiw	a3,a5,1
 840:	fed42623          	sw	a3,-20(s0)
 844:	00000697          	auipc	a3,0x0
 848:	7bc68693          	addi	a3,a3,1980 # 1000 <digits>
 84c:	1702                	slli	a4,a4,0x20
 84e:	9301                	srli	a4,a4,0x20
 850:	9736                	add	a4,a4,a3
 852:	00074703          	lbu	a4,0(a4)
 856:	17c1                	addi	a5,a5,-16
 858:	97a2                	add	a5,a5,s0
 85a:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 85e:	fc442783          	lw	a5,-60(s0)
 862:	fe442703          	lw	a4,-28(s0)
 866:	02f757bb          	divuw	a5,a4,a5
 86a:	fef42223          	sw	a5,-28(s0)
 86e:	fe442783          	lw	a5,-28(s0)
 872:	2781                	sext.w	a5,a5
 874:	fbd5                	bnez	a5,828 <printint+0x5a>
  if(neg)
 876:	fe842783          	lw	a5,-24(s0)
 87a:	2781                	sext.w	a5,a5
 87c:	cf85                	beqz	a5,8b4 <printint+0xe6>
    buf[i++] = '-';
 87e:	fec42783          	lw	a5,-20(s0)
 882:	0017871b          	addiw	a4,a5,1
 886:	fee42623          	sw	a4,-20(s0)
 88a:	17c1                	addi	a5,a5,-16
 88c:	97a2                	add	a5,a5,s0
 88e:	02d00713          	li	a4,45
 892:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 896:	a839                	j	8b4 <printint+0xe6>
    putc(fd, buf[i]);
 898:	fec42783          	lw	a5,-20(s0)
 89c:	17c1                	addi	a5,a5,-16
 89e:	97a2                	add	a5,a5,s0
 8a0:	fe07c703          	lbu	a4,-32(a5)
 8a4:	fcc42783          	lw	a5,-52(s0)
 8a8:	85ba                	mv	a1,a4
 8aa:	853e                	mv	a0,a5
 8ac:	00000097          	auipc	ra,0x0
 8b0:	eec080e7          	jalr	-276(ra) # 798 <putc>
  while(--i >= 0)
 8b4:	fec42783          	lw	a5,-20(s0)
 8b8:	37fd                	addiw	a5,a5,-1
 8ba:	fef42623          	sw	a5,-20(s0)
 8be:	fec42783          	lw	a5,-20(s0)
 8c2:	2781                	sext.w	a5,a5
 8c4:	fc07dae3          	bgez	a5,898 <printint+0xca>
}
 8c8:	0001                	nop
 8ca:	0001                	nop
 8cc:	70e2                	ld	ra,56(sp)
 8ce:	7442                	ld	s0,48(sp)
 8d0:	6121                	addi	sp,sp,64
 8d2:	8082                	ret

00000000000008d4 <printptr>:

static void
printptr(int fd, uint64 x) {
 8d4:	7179                	addi	sp,sp,-48
 8d6:	f406                	sd	ra,40(sp)
 8d8:	f022                	sd	s0,32(sp)
 8da:	1800                	addi	s0,sp,48
 8dc:	87aa                	mv	a5,a0
 8de:	fcb43823          	sd	a1,-48(s0)
 8e2:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 8e6:	fdc42783          	lw	a5,-36(s0)
 8ea:	03000593          	li	a1,48
 8ee:	853e                	mv	a0,a5
 8f0:	00000097          	auipc	ra,0x0
 8f4:	ea8080e7          	jalr	-344(ra) # 798 <putc>
  putc(fd, 'x');
 8f8:	fdc42783          	lw	a5,-36(s0)
 8fc:	07800593          	li	a1,120
 900:	853e                	mv	a0,a5
 902:	00000097          	auipc	ra,0x0
 906:	e96080e7          	jalr	-362(ra) # 798 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 90a:	fe042623          	sw	zero,-20(s0)
 90e:	a82d                	j	948 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 910:	fd043783          	ld	a5,-48(s0)
 914:	93f1                	srli	a5,a5,0x3c
 916:	00000717          	auipc	a4,0x0
 91a:	6ea70713          	addi	a4,a4,1770 # 1000 <digits>
 91e:	97ba                	add	a5,a5,a4
 920:	0007c703          	lbu	a4,0(a5)
 924:	fdc42783          	lw	a5,-36(s0)
 928:	85ba                	mv	a1,a4
 92a:	853e                	mv	a0,a5
 92c:	00000097          	auipc	ra,0x0
 930:	e6c080e7          	jalr	-404(ra) # 798 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 934:	fec42783          	lw	a5,-20(s0)
 938:	2785                	addiw	a5,a5,1
 93a:	fef42623          	sw	a5,-20(s0)
 93e:	fd043783          	ld	a5,-48(s0)
 942:	0792                	slli	a5,a5,0x4
 944:	fcf43823          	sd	a5,-48(s0)
 948:	fec42703          	lw	a4,-20(s0)
 94c:	47bd                	li	a5,15
 94e:	fce7f1e3          	bgeu	a5,a4,910 <printptr+0x3c>
}
 952:	0001                	nop
 954:	0001                	nop
 956:	70a2                	ld	ra,40(sp)
 958:	7402                	ld	s0,32(sp)
 95a:	6145                	addi	sp,sp,48
 95c:	8082                	ret

000000000000095e <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 95e:	715d                	addi	sp,sp,-80
 960:	e486                	sd	ra,72(sp)
 962:	e0a2                	sd	s0,64(sp)
 964:	0880                	addi	s0,sp,80
 966:	87aa                	mv	a5,a0
 968:	fcb43023          	sd	a1,-64(s0)
 96c:	fac43c23          	sd	a2,-72(s0)
 970:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 974:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 978:	fe042223          	sw	zero,-28(s0)
 97c:	a42d                	j	ba6 <vprintf+0x248>
    c = fmt[i] & 0xff;
 97e:	fe442783          	lw	a5,-28(s0)
 982:	fc043703          	ld	a4,-64(s0)
 986:	97ba                	add	a5,a5,a4
 988:	0007c783          	lbu	a5,0(a5)
 98c:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 990:	fe042783          	lw	a5,-32(s0)
 994:	2781                	sext.w	a5,a5
 996:	eb9d                	bnez	a5,9cc <vprintf+0x6e>
      if(c == '%'){
 998:	fdc42783          	lw	a5,-36(s0)
 99c:	0007871b          	sext.w	a4,a5
 9a0:	02500793          	li	a5,37
 9a4:	00f71763          	bne	a4,a5,9b2 <vprintf+0x54>
        state = '%';
 9a8:	02500793          	li	a5,37
 9ac:	fef42023          	sw	a5,-32(s0)
 9b0:	a2f5                	j	b9c <vprintf+0x23e>
      } else {
        putc(fd, c);
 9b2:	fdc42783          	lw	a5,-36(s0)
 9b6:	0ff7f713          	zext.b	a4,a5
 9ba:	fcc42783          	lw	a5,-52(s0)
 9be:	85ba                	mv	a1,a4
 9c0:	853e                	mv	a0,a5
 9c2:	00000097          	auipc	ra,0x0
 9c6:	dd6080e7          	jalr	-554(ra) # 798 <putc>
 9ca:	aac9                	j	b9c <vprintf+0x23e>
      }
    } else if(state == '%'){
 9cc:	fe042783          	lw	a5,-32(s0)
 9d0:	0007871b          	sext.w	a4,a5
 9d4:	02500793          	li	a5,37
 9d8:	1cf71263          	bne	a4,a5,b9c <vprintf+0x23e>
      if(c == 'd'){
 9dc:	fdc42783          	lw	a5,-36(s0)
 9e0:	0007871b          	sext.w	a4,a5
 9e4:	06400793          	li	a5,100
 9e8:	02f71463          	bne	a4,a5,a10 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 9ec:	fb843783          	ld	a5,-72(s0)
 9f0:	00878713          	addi	a4,a5,8
 9f4:	fae43c23          	sd	a4,-72(s0)
 9f8:	4398                	lw	a4,0(a5)
 9fa:	fcc42783          	lw	a5,-52(s0)
 9fe:	4685                	li	a3,1
 a00:	4629                	li	a2,10
 a02:	85ba                	mv	a1,a4
 a04:	853e                	mv	a0,a5
 a06:	00000097          	auipc	ra,0x0
 a0a:	dc8080e7          	jalr	-568(ra) # 7ce <printint>
 a0e:	a269                	j	b98 <vprintf+0x23a>
      } else if(c == 'l') {
 a10:	fdc42783          	lw	a5,-36(s0)
 a14:	0007871b          	sext.w	a4,a5
 a18:	06c00793          	li	a5,108
 a1c:	02f71663          	bne	a4,a5,a48 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a20:	fb843783          	ld	a5,-72(s0)
 a24:	00878713          	addi	a4,a5,8
 a28:	fae43c23          	sd	a4,-72(s0)
 a2c:	639c                	ld	a5,0(a5)
 a2e:	0007871b          	sext.w	a4,a5
 a32:	fcc42783          	lw	a5,-52(s0)
 a36:	4681                	li	a3,0
 a38:	4629                	li	a2,10
 a3a:	85ba                	mv	a1,a4
 a3c:	853e                	mv	a0,a5
 a3e:	00000097          	auipc	ra,0x0
 a42:	d90080e7          	jalr	-624(ra) # 7ce <printint>
 a46:	aa89                	j	b98 <vprintf+0x23a>
      } else if(c == 'x') {
 a48:	fdc42783          	lw	a5,-36(s0)
 a4c:	0007871b          	sext.w	a4,a5
 a50:	07800793          	li	a5,120
 a54:	02f71463          	bne	a4,a5,a7c <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 a58:	fb843783          	ld	a5,-72(s0)
 a5c:	00878713          	addi	a4,a5,8
 a60:	fae43c23          	sd	a4,-72(s0)
 a64:	4398                	lw	a4,0(a5)
 a66:	fcc42783          	lw	a5,-52(s0)
 a6a:	4681                	li	a3,0
 a6c:	4641                	li	a2,16
 a6e:	85ba                	mv	a1,a4
 a70:	853e                	mv	a0,a5
 a72:	00000097          	auipc	ra,0x0
 a76:	d5c080e7          	jalr	-676(ra) # 7ce <printint>
 a7a:	aa39                	j	b98 <vprintf+0x23a>
      } else if(c == 'p') {
 a7c:	fdc42783          	lw	a5,-36(s0)
 a80:	0007871b          	sext.w	a4,a5
 a84:	07000793          	li	a5,112
 a88:	02f71263          	bne	a4,a5,aac <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 a8c:	fb843783          	ld	a5,-72(s0)
 a90:	00878713          	addi	a4,a5,8
 a94:	fae43c23          	sd	a4,-72(s0)
 a98:	6398                	ld	a4,0(a5)
 a9a:	fcc42783          	lw	a5,-52(s0)
 a9e:	85ba                	mv	a1,a4
 aa0:	853e                	mv	a0,a5
 aa2:	00000097          	auipc	ra,0x0
 aa6:	e32080e7          	jalr	-462(ra) # 8d4 <printptr>
 aaa:	a0fd                	j	b98 <vprintf+0x23a>
      } else if(c == 's'){
 aac:	fdc42783          	lw	a5,-36(s0)
 ab0:	0007871b          	sext.w	a4,a5
 ab4:	07300793          	li	a5,115
 ab8:	04f71c63          	bne	a4,a5,b10 <vprintf+0x1b2>
        s = va_arg(ap, char*);
 abc:	fb843783          	ld	a5,-72(s0)
 ac0:	00878713          	addi	a4,a5,8
 ac4:	fae43c23          	sd	a4,-72(s0)
 ac8:	639c                	ld	a5,0(a5)
 aca:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 ace:	fe843783          	ld	a5,-24(s0)
 ad2:	eb8d                	bnez	a5,b04 <vprintf+0x1a6>
          s = "(null)";
 ad4:	00000797          	auipc	a5,0x0
 ad8:	4c478793          	addi	a5,a5,1220 # f98 <malloc+0x188>
 adc:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 ae0:	a015                	j	b04 <vprintf+0x1a6>
          putc(fd, *s);
 ae2:	fe843783          	ld	a5,-24(s0)
 ae6:	0007c703          	lbu	a4,0(a5)
 aea:	fcc42783          	lw	a5,-52(s0)
 aee:	85ba                	mv	a1,a4
 af0:	853e                	mv	a0,a5
 af2:	00000097          	auipc	ra,0x0
 af6:	ca6080e7          	jalr	-858(ra) # 798 <putc>
          s++;
 afa:	fe843783          	ld	a5,-24(s0)
 afe:	0785                	addi	a5,a5,1
 b00:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 b04:	fe843783          	ld	a5,-24(s0)
 b08:	0007c783          	lbu	a5,0(a5)
 b0c:	fbf9                	bnez	a5,ae2 <vprintf+0x184>
 b0e:	a069                	j	b98 <vprintf+0x23a>
        }
      } else if(c == 'c'){
 b10:	fdc42783          	lw	a5,-36(s0)
 b14:	0007871b          	sext.w	a4,a5
 b18:	06300793          	li	a5,99
 b1c:	02f71463          	bne	a4,a5,b44 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 b20:	fb843783          	ld	a5,-72(s0)
 b24:	00878713          	addi	a4,a5,8
 b28:	fae43c23          	sd	a4,-72(s0)
 b2c:	439c                	lw	a5,0(a5)
 b2e:	0ff7f713          	zext.b	a4,a5
 b32:	fcc42783          	lw	a5,-52(s0)
 b36:	85ba                	mv	a1,a4
 b38:	853e                	mv	a0,a5
 b3a:	00000097          	auipc	ra,0x0
 b3e:	c5e080e7          	jalr	-930(ra) # 798 <putc>
 b42:	a899                	j	b98 <vprintf+0x23a>
      } else if(c == '%'){
 b44:	fdc42783          	lw	a5,-36(s0)
 b48:	0007871b          	sext.w	a4,a5
 b4c:	02500793          	li	a5,37
 b50:	00f71f63          	bne	a4,a5,b6e <vprintf+0x210>
        putc(fd, c);
 b54:	fdc42783          	lw	a5,-36(s0)
 b58:	0ff7f713          	zext.b	a4,a5
 b5c:	fcc42783          	lw	a5,-52(s0)
 b60:	85ba                	mv	a1,a4
 b62:	853e                	mv	a0,a5
 b64:	00000097          	auipc	ra,0x0
 b68:	c34080e7          	jalr	-972(ra) # 798 <putc>
 b6c:	a035                	j	b98 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 b6e:	fcc42783          	lw	a5,-52(s0)
 b72:	02500593          	li	a1,37
 b76:	853e                	mv	a0,a5
 b78:	00000097          	auipc	ra,0x0
 b7c:	c20080e7          	jalr	-992(ra) # 798 <putc>
        putc(fd, c);
 b80:	fdc42783          	lw	a5,-36(s0)
 b84:	0ff7f713          	zext.b	a4,a5
 b88:	fcc42783          	lw	a5,-52(s0)
 b8c:	85ba                	mv	a1,a4
 b8e:	853e                	mv	a0,a5
 b90:	00000097          	auipc	ra,0x0
 b94:	c08080e7          	jalr	-1016(ra) # 798 <putc>
      }
      state = 0;
 b98:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 b9c:	fe442783          	lw	a5,-28(s0)
 ba0:	2785                	addiw	a5,a5,1
 ba2:	fef42223          	sw	a5,-28(s0)
 ba6:	fe442783          	lw	a5,-28(s0)
 baa:	fc043703          	ld	a4,-64(s0)
 bae:	97ba                	add	a5,a5,a4
 bb0:	0007c783          	lbu	a5,0(a5)
 bb4:	dc0795e3          	bnez	a5,97e <vprintf+0x20>
    }
  }
}
 bb8:	0001                	nop
 bba:	0001                	nop
 bbc:	60a6                	ld	ra,72(sp)
 bbe:	6406                	ld	s0,64(sp)
 bc0:	6161                	addi	sp,sp,80
 bc2:	8082                	ret

0000000000000bc4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 bc4:	7159                	addi	sp,sp,-112
 bc6:	fc06                	sd	ra,56(sp)
 bc8:	f822                	sd	s0,48(sp)
 bca:	0080                	addi	s0,sp,64
 bcc:	fcb43823          	sd	a1,-48(s0)
 bd0:	e010                	sd	a2,0(s0)
 bd2:	e414                	sd	a3,8(s0)
 bd4:	e818                	sd	a4,16(s0)
 bd6:	ec1c                	sd	a5,24(s0)
 bd8:	03043023          	sd	a6,32(s0)
 bdc:	03143423          	sd	a7,40(s0)
 be0:	87aa                	mv	a5,a0
 be2:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 be6:	03040793          	addi	a5,s0,48
 bea:	fcf43423          	sd	a5,-56(s0)
 bee:	fc843783          	ld	a5,-56(s0)
 bf2:	fd078793          	addi	a5,a5,-48
 bf6:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 bfa:	fe843703          	ld	a4,-24(s0)
 bfe:	fdc42783          	lw	a5,-36(s0)
 c02:	863a                	mv	a2,a4
 c04:	fd043583          	ld	a1,-48(s0)
 c08:	853e                	mv	a0,a5
 c0a:	00000097          	auipc	ra,0x0
 c0e:	d54080e7          	jalr	-684(ra) # 95e <vprintf>
}
 c12:	0001                	nop
 c14:	70e2                	ld	ra,56(sp)
 c16:	7442                	ld	s0,48(sp)
 c18:	6165                	addi	sp,sp,112
 c1a:	8082                	ret

0000000000000c1c <printf>:

void
printf(const char *fmt, ...)
{
 c1c:	7159                	addi	sp,sp,-112
 c1e:	f406                	sd	ra,40(sp)
 c20:	f022                	sd	s0,32(sp)
 c22:	1800                	addi	s0,sp,48
 c24:	fca43c23          	sd	a0,-40(s0)
 c28:	e40c                	sd	a1,8(s0)
 c2a:	e810                	sd	a2,16(s0)
 c2c:	ec14                	sd	a3,24(s0)
 c2e:	f018                	sd	a4,32(s0)
 c30:	f41c                	sd	a5,40(s0)
 c32:	03043823          	sd	a6,48(s0)
 c36:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 c3a:	04040793          	addi	a5,s0,64
 c3e:	fcf43823          	sd	a5,-48(s0)
 c42:	fd043783          	ld	a5,-48(s0)
 c46:	fc878793          	addi	a5,a5,-56
 c4a:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 c4e:	fe843783          	ld	a5,-24(s0)
 c52:	863e                	mv	a2,a5
 c54:	fd843583          	ld	a1,-40(s0)
 c58:	4505                	li	a0,1
 c5a:	00000097          	auipc	ra,0x0
 c5e:	d04080e7          	jalr	-764(ra) # 95e <vprintf>
}
 c62:	0001                	nop
 c64:	70a2                	ld	ra,40(sp)
 c66:	7402                	ld	s0,32(sp)
 c68:	6165                	addi	sp,sp,112
 c6a:	8082                	ret

0000000000000c6c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 c6c:	7179                	addi	sp,sp,-48
 c6e:	f406                	sd	ra,40(sp)
 c70:	f022                	sd	s0,32(sp)
 c72:	1800                	addi	s0,sp,48
 c74:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 c78:	fd843783          	ld	a5,-40(s0)
 c7c:	17c1                	addi	a5,a5,-16
 c7e:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c82:	00000797          	auipc	a5,0x0
 c86:	5ae78793          	addi	a5,a5,1454 # 1230 <freep>
 c8a:	639c                	ld	a5,0(a5)
 c8c:	fef43423          	sd	a5,-24(s0)
 c90:	a815                	j	cc4 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c92:	fe843783          	ld	a5,-24(s0)
 c96:	639c                	ld	a5,0(a5)
 c98:	fe843703          	ld	a4,-24(s0)
 c9c:	00f76f63          	bltu	a4,a5,cba <free+0x4e>
 ca0:	fe043703          	ld	a4,-32(s0)
 ca4:	fe843783          	ld	a5,-24(s0)
 ca8:	02e7eb63          	bltu	a5,a4,cde <free+0x72>
 cac:	fe843783          	ld	a5,-24(s0)
 cb0:	639c                	ld	a5,0(a5)
 cb2:	fe043703          	ld	a4,-32(s0)
 cb6:	02f76463          	bltu	a4,a5,cde <free+0x72>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cba:	fe843783          	ld	a5,-24(s0)
 cbe:	639c                	ld	a5,0(a5)
 cc0:	fef43423          	sd	a5,-24(s0)
 cc4:	fe043703          	ld	a4,-32(s0)
 cc8:	fe843783          	ld	a5,-24(s0)
 ccc:	fce7f3e3          	bgeu	a5,a4,c92 <free+0x26>
 cd0:	fe843783          	ld	a5,-24(s0)
 cd4:	639c                	ld	a5,0(a5)
 cd6:	fe043703          	ld	a4,-32(s0)
 cda:	faf77ce3          	bgeu	a4,a5,c92 <free+0x26>
      break;
  if(bp + bp->s.size == p->s.ptr){
 cde:	fe043783          	ld	a5,-32(s0)
 ce2:	479c                	lw	a5,8(a5)
 ce4:	1782                	slli	a5,a5,0x20
 ce6:	9381                	srli	a5,a5,0x20
 ce8:	0792                	slli	a5,a5,0x4
 cea:	fe043703          	ld	a4,-32(s0)
 cee:	973e                	add	a4,a4,a5
 cf0:	fe843783          	ld	a5,-24(s0)
 cf4:	639c                	ld	a5,0(a5)
 cf6:	02f71763          	bne	a4,a5,d24 <free+0xb8>
    bp->s.size += p->s.ptr->s.size;
 cfa:	fe043783          	ld	a5,-32(s0)
 cfe:	4798                	lw	a4,8(a5)
 d00:	fe843783          	ld	a5,-24(s0)
 d04:	639c                	ld	a5,0(a5)
 d06:	479c                	lw	a5,8(a5)
 d08:	9fb9                	addw	a5,a5,a4
 d0a:	0007871b          	sext.w	a4,a5
 d0e:	fe043783          	ld	a5,-32(s0)
 d12:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 d14:	fe843783          	ld	a5,-24(s0)
 d18:	639c                	ld	a5,0(a5)
 d1a:	6398                	ld	a4,0(a5)
 d1c:	fe043783          	ld	a5,-32(s0)
 d20:	e398                	sd	a4,0(a5)
 d22:	a039                	j	d30 <free+0xc4>
  } else
    bp->s.ptr = p->s.ptr;
 d24:	fe843783          	ld	a5,-24(s0)
 d28:	6398                	ld	a4,0(a5)
 d2a:	fe043783          	ld	a5,-32(s0)
 d2e:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 d30:	fe843783          	ld	a5,-24(s0)
 d34:	479c                	lw	a5,8(a5)
 d36:	1782                	slli	a5,a5,0x20
 d38:	9381                	srli	a5,a5,0x20
 d3a:	0792                	slli	a5,a5,0x4
 d3c:	fe843703          	ld	a4,-24(s0)
 d40:	97ba                	add	a5,a5,a4
 d42:	fe043703          	ld	a4,-32(s0)
 d46:	02f71563          	bne	a4,a5,d70 <free+0x104>
    p->s.size += bp->s.size;
 d4a:	fe843783          	ld	a5,-24(s0)
 d4e:	4798                	lw	a4,8(a5)
 d50:	fe043783          	ld	a5,-32(s0)
 d54:	479c                	lw	a5,8(a5)
 d56:	9fb9                	addw	a5,a5,a4
 d58:	0007871b          	sext.w	a4,a5
 d5c:	fe843783          	ld	a5,-24(s0)
 d60:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 d62:	fe043783          	ld	a5,-32(s0)
 d66:	6398                	ld	a4,0(a5)
 d68:	fe843783          	ld	a5,-24(s0)
 d6c:	e398                	sd	a4,0(a5)
 d6e:	a031                	j	d7a <free+0x10e>
  } else
    p->s.ptr = bp;
 d70:	fe843783          	ld	a5,-24(s0)
 d74:	fe043703          	ld	a4,-32(s0)
 d78:	e398                	sd	a4,0(a5)
  freep = p;
 d7a:	00000797          	auipc	a5,0x0
 d7e:	4b678793          	addi	a5,a5,1206 # 1230 <freep>
 d82:	fe843703          	ld	a4,-24(s0)
 d86:	e398                	sd	a4,0(a5)
}
 d88:	0001                	nop
 d8a:	70a2                	ld	ra,40(sp)
 d8c:	7402                	ld	s0,32(sp)
 d8e:	6145                	addi	sp,sp,48
 d90:	8082                	ret

0000000000000d92 <morecore>:

static Header*
morecore(uint nu)
{
 d92:	7179                	addi	sp,sp,-48
 d94:	f406                	sd	ra,40(sp)
 d96:	f022                	sd	s0,32(sp)
 d98:	1800                	addi	s0,sp,48
 d9a:	87aa                	mv	a5,a0
 d9c:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 da0:	fdc42783          	lw	a5,-36(s0)
 da4:	0007871b          	sext.w	a4,a5
 da8:	6785                	lui	a5,0x1
 daa:	00f77563          	bgeu	a4,a5,db4 <morecore+0x22>
    nu = 4096;
 dae:	6785                	lui	a5,0x1
 db0:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 db4:	fdc42783          	lw	a5,-36(s0)
 db8:	0047979b          	slliw	a5,a5,0x4
 dbc:	2781                	sext.w	a5,a5
 dbe:	853e                	mv	a0,a5
 dc0:	00000097          	auipc	ra,0x0
 dc4:	9b8080e7          	jalr	-1608(ra) # 778 <sbrk>
 dc8:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 dcc:	fe843703          	ld	a4,-24(s0)
 dd0:	57fd                	li	a5,-1
 dd2:	00f71463          	bne	a4,a5,dda <morecore+0x48>
    return 0;
 dd6:	4781                	li	a5,0
 dd8:	a03d                	j	e06 <morecore+0x74>
  hp = (Header*)p;
 dda:	fe843783          	ld	a5,-24(s0)
 dde:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 de2:	fe043783          	ld	a5,-32(s0)
 de6:	fdc42703          	lw	a4,-36(s0)
 dea:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 dec:	fe043783          	ld	a5,-32(s0)
 df0:	07c1                	addi	a5,a5,16 # 1010 <digits+0x10>
 df2:	853e                	mv	a0,a5
 df4:	00000097          	auipc	ra,0x0
 df8:	e78080e7          	jalr	-392(ra) # c6c <free>
  return freep;
 dfc:	00000797          	auipc	a5,0x0
 e00:	43478793          	addi	a5,a5,1076 # 1230 <freep>
 e04:	639c                	ld	a5,0(a5)
}
 e06:	853e                	mv	a0,a5
 e08:	70a2                	ld	ra,40(sp)
 e0a:	7402                	ld	s0,32(sp)
 e0c:	6145                	addi	sp,sp,48
 e0e:	8082                	ret

0000000000000e10 <malloc>:

void*
malloc(uint nbytes)
{
 e10:	7139                	addi	sp,sp,-64
 e12:	fc06                	sd	ra,56(sp)
 e14:	f822                	sd	s0,48(sp)
 e16:	0080                	addi	s0,sp,64
 e18:	87aa                	mv	a5,a0
 e1a:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 e1e:	fcc46783          	lwu	a5,-52(s0)
 e22:	07bd                	addi	a5,a5,15
 e24:	8391                	srli	a5,a5,0x4
 e26:	2781                	sext.w	a5,a5
 e28:	2785                	addiw	a5,a5,1
 e2a:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 e2e:	00000797          	auipc	a5,0x0
 e32:	40278793          	addi	a5,a5,1026 # 1230 <freep>
 e36:	639c                	ld	a5,0(a5)
 e38:	fef43023          	sd	a5,-32(s0)
 e3c:	fe043783          	ld	a5,-32(s0)
 e40:	ef95                	bnez	a5,e7c <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 e42:	00000797          	auipc	a5,0x0
 e46:	3de78793          	addi	a5,a5,990 # 1220 <base>
 e4a:	fef43023          	sd	a5,-32(s0)
 e4e:	00000797          	auipc	a5,0x0
 e52:	3e278793          	addi	a5,a5,994 # 1230 <freep>
 e56:	fe043703          	ld	a4,-32(s0)
 e5a:	e398                	sd	a4,0(a5)
 e5c:	00000797          	auipc	a5,0x0
 e60:	3d478793          	addi	a5,a5,980 # 1230 <freep>
 e64:	6398                	ld	a4,0(a5)
 e66:	00000797          	auipc	a5,0x0
 e6a:	3ba78793          	addi	a5,a5,954 # 1220 <base>
 e6e:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 e70:	00000797          	auipc	a5,0x0
 e74:	3b078793          	addi	a5,a5,944 # 1220 <base>
 e78:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e7c:	fe043783          	ld	a5,-32(s0)
 e80:	639c                	ld	a5,0(a5)
 e82:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 e86:	fe843783          	ld	a5,-24(s0)
 e8a:	479c                	lw	a5,8(a5)
 e8c:	fdc42703          	lw	a4,-36(s0)
 e90:	2701                	sext.w	a4,a4
 e92:	06e7e763          	bltu	a5,a4,f00 <malloc+0xf0>
      if(p->s.size == nunits)
 e96:	fe843783          	ld	a5,-24(s0)
 e9a:	479c                	lw	a5,8(a5)
 e9c:	fdc42703          	lw	a4,-36(s0)
 ea0:	2701                	sext.w	a4,a4
 ea2:	00f71963          	bne	a4,a5,eb4 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 ea6:	fe843783          	ld	a5,-24(s0)
 eaa:	6398                	ld	a4,0(a5)
 eac:	fe043783          	ld	a5,-32(s0)
 eb0:	e398                	sd	a4,0(a5)
 eb2:	a825                	j	eea <malloc+0xda>
      else {
        p->s.size -= nunits;
 eb4:	fe843783          	ld	a5,-24(s0)
 eb8:	479c                	lw	a5,8(a5)
 eba:	fdc42703          	lw	a4,-36(s0)
 ebe:	9f99                	subw	a5,a5,a4
 ec0:	0007871b          	sext.w	a4,a5
 ec4:	fe843783          	ld	a5,-24(s0)
 ec8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 eca:	fe843783          	ld	a5,-24(s0)
 ece:	479c                	lw	a5,8(a5)
 ed0:	1782                	slli	a5,a5,0x20
 ed2:	9381                	srli	a5,a5,0x20
 ed4:	0792                	slli	a5,a5,0x4
 ed6:	fe843703          	ld	a4,-24(s0)
 eda:	97ba                	add	a5,a5,a4
 edc:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 ee0:	fe843783          	ld	a5,-24(s0)
 ee4:	fdc42703          	lw	a4,-36(s0)
 ee8:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 eea:	00000797          	auipc	a5,0x0
 eee:	34678793          	addi	a5,a5,838 # 1230 <freep>
 ef2:	fe043703          	ld	a4,-32(s0)
 ef6:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 ef8:	fe843783          	ld	a5,-24(s0)
 efc:	07c1                	addi	a5,a5,16
 efe:	a091                	j	f42 <malloc+0x132>
    }
    if(p == freep)
 f00:	00000797          	auipc	a5,0x0
 f04:	33078793          	addi	a5,a5,816 # 1230 <freep>
 f08:	639c                	ld	a5,0(a5)
 f0a:	fe843703          	ld	a4,-24(s0)
 f0e:	02f71063          	bne	a4,a5,f2e <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 f12:	fdc42783          	lw	a5,-36(s0)
 f16:	853e                	mv	a0,a5
 f18:	00000097          	auipc	ra,0x0
 f1c:	e7a080e7          	jalr	-390(ra) # d92 <morecore>
 f20:	fea43423          	sd	a0,-24(s0)
 f24:	fe843783          	ld	a5,-24(s0)
 f28:	e399                	bnez	a5,f2e <malloc+0x11e>
        return 0;
 f2a:	4781                	li	a5,0
 f2c:	a819                	j	f42 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 f2e:	fe843783          	ld	a5,-24(s0)
 f32:	fef43023          	sd	a5,-32(s0)
 f36:	fe843783          	ld	a5,-24(s0)
 f3a:	639c                	ld	a5,0(a5)
 f3c:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 f40:	b799                	j	e86 <malloc+0x76>
  }
}
 f42:	853e                	mv	a0,a5
 f44:	70e2                	ld	ra,56(sp)
 f46:	7442                	ld	s0,48(sp)
 f48:	6121                	addi	sp,sp,64
 f4a:	8082                	ret
