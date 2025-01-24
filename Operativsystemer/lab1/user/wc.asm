
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
  78:	edc50513          	addi	a0,a0,-292 # f50 <malloc+0x148>
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
  fa:	e6250513          	addi	a0,a0,-414 # f58 <malloc+0x150>
  fe:	00001097          	auipc	ra,0x1
 102:	b16080e7          	jalr	-1258(ra) # c14 <printf>
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
 126:	e4650513          	addi	a0,a0,-442 # f68 <malloc+0x160>
 12a:	00001097          	auipc	ra,0x1
 12e:	aea080e7          	jalr	-1302(ra) # c14 <printf>
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
 160:	e1c58593          	addi	a1,a1,-484 # f78 <malloc+0x170>
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
 1be:	dc650513          	addi	a0,a0,-570 # f80 <malloc+0x178>
 1c2:	00001097          	auipc	ra,0x1
 1c6:	a52080e7          	jalr	-1454(ra) # c14 <printf>
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

0000000000000790 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 790:	1101                	addi	sp,sp,-32
 792:	ec06                	sd	ra,24(sp)
 794:	e822                	sd	s0,16(sp)
 796:	1000                	addi	s0,sp,32
 798:	87aa                	mv	a5,a0
 79a:	872e                	mv	a4,a1
 79c:	fef42623          	sw	a5,-20(s0)
 7a0:	87ba                	mv	a5,a4
 7a2:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 7a6:	feb40713          	addi	a4,s0,-21
 7aa:	fec42783          	lw	a5,-20(s0)
 7ae:	4605                	li	a2,1
 7b0:	85ba                	mv	a1,a4
 7b2:	853e                	mv	a0,a5
 7b4:	00000097          	auipc	ra,0x0
 7b8:	f5c080e7          	jalr	-164(ra) # 710 <write>
}
 7bc:	0001                	nop
 7be:	60e2                	ld	ra,24(sp)
 7c0:	6442                	ld	s0,16(sp)
 7c2:	6105                	addi	sp,sp,32
 7c4:	8082                	ret

00000000000007c6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7c6:	7139                	addi	sp,sp,-64
 7c8:	fc06                	sd	ra,56(sp)
 7ca:	f822                	sd	s0,48(sp)
 7cc:	0080                	addi	s0,sp,64
 7ce:	87aa                	mv	a5,a0
 7d0:	8736                	mv	a4,a3
 7d2:	fcf42623          	sw	a5,-52(s0)
 7d6:	87ae                	mv	a5,a1
 7d8:	fcf42423          	sw	a5,-56(s0)
 7dc:	87b2                	mv	a5,a2
 7de:	fcf42223          	sw	a5,-60(s0)
 7e2:	87ba                	mv	a5,a4
 7e4:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 7e8:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 7ec:	fc042783          	lw	a5,-64(s0)
 7f0:	2781                	sext.w	a5,a5
 7f2:	c38d                	beqz	a5,814 <printint+0x4e>
 7f4:	fc842783          	lw	a5,-56(s0)
 7f8:	2781                	sext.w	a5,a5
 7fa:	0007dd63          	bgez	a5,814 <printint+0x4e>
    neg = 1;
 7fe:	4785                	li	a5,1
 800:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 804:	fc842783          	lw	a5,-56(s0)
 808:	40f007bb          	negw	a5,a5
 80c:	2781                	sext.w	a5,a5
 80e:	fef42223          	sw	a5,-28(s0)
 812:	a029                	j	81c <printint+0x56>
  } else {
    x = xx;
 814:	fc842783          	lw	a5,-56(s0)
 818:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 81c:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 820:	fc442783          	lw	a5,-60(s0)
 824:	fe442703          	lw	a4,-28(s0)
 828:	02f777bb          	remuw	a5,a4,a5
 82c:	0007871b          	sext.w	a4,a5
 830:	fec42783          	lw	a5,-20(s0)
 834:	0017869b          	addiw	a3,a5,1
 838:	fed42623          	sw	a3,-20(s0)
 83c:	00000697          	auipc	a3,0x0
 840:	7c468693          	addi	a3,a3,1988 # 1000 <digits>
 844:	1702                	slli	a4,a4,0x20
 846:	9301                	srli	a4,a4,0x20
 848:	9736                	add	a4,a4,a3
 84a:	00074703          	lbu	a4,0(a4)
 84e:	17c1                	addi	a5,a5,-16
 850:	97a2                	add	a5,a5,s0
 852:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 856:	fc442783          	lw	a5,-60(s0)
 85a:	fe442703          	lw	a4,-28(s0)
 85e:	02f757bb          	divuw	a5,a4,a5
 862:	fef42223          	sw	a5,-28(s0)
 866:	fe442783          	lw	a5,-28(s0)
 86a:	2781                	sext.w	a5,a5
 86c:	fbd5                	bnez	a5,820 <printint+0x5a>
  if(neg)
 86e:	fe842783          	lw	a5,-24(s0)
 872:	2781                	sext.w	a5,a5
 874:	cf85                	beqz	a5,8ac <printint+0xe6>
    buf[i++] = '-';
 876:	fec42783          	lw	a5,-20(s0)
 87a:	0017871b          	addiw	a4,a5,1
 87e:	fee42623          	sw	a4,-20(s0)
 882:	17c1                	addi	a5,a5,-16
 884:	97a2                	add	a5,a5,s0
 886:	02d00713          	li	a4,45
 88a:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 88e:	a839                	j	8ac <printint+0xe6>
    putc(fd, buf[i]);
 890:	fec42783          	lw	a5,-20(s0)
 894:	17c1                	addi	a5,a5,-16
 896:	97a2                	add	a5,a5,s0
 898:	fe07c703          	lbu	a4,-32(a5)
 89c:	fcc42783          	lw	a5,-52(s0)
 8a0:	85ba                	mv	a1,a4
 8a2:	853e                	mv	a0,a5
 8a4:	00000097          	auipc	ra,0x0
 8a8:	eec080e7          	jalr	-276(ra) # 790 <putc>
  while(--i >= 0)
 8ac:	fec42783          	lw	a5,-20(s0)
 8b0:	37fd                	addiw	a5,a5,-1
 8b2:	fef42623          	sw	a5,-20(s0)
 8b6:	fec42783          	lw	a5,-20(s0)
 8ba:	2781                	sext.w	a5,a5
 8bc:	fc07dae3          	bgez	a5,890 <printint+0xca>
}
 8c0:	0001                	nop
 8c2:	0001                	nop
 8c4:	70e2                	ld	ra,56(sp)
 8c6:	7442                	ld	s0,48(sp)
 8c8:	6121                	addi	sp,sp,64
 8ca:	8082                	ret

00000000000008cc <printptr>:

static void
printptr(int fd, uint64 x) {
 8cc:	7179                	addi	sp,sp,-48
 8ce:	f406                	sd	ra,40(sp)
 8d0:	f022                	sd	s0,32(sp)
 8d2:	1800                	addi	s0,sp,48
 8d4:	87aa                	mv	a5,a0
 8d6:	fcb43823          	sd	a1,-48(s0)
 8da:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 8de:	fdc42783          	lw	a5,-36(s0)
 8e2:	03000593          	li	a1,48
 8e6:	853e                	mv	a0,a5
 8e8:	00000097          	auipc	ra,0x0
 8ec:	ea8080e7          	jalr	-344(ra) # 790 <putc>
  putc(fd, 'x');
 8f0:	fdc42783          	lw	a5,-36(s0)
 8f4:	07800593          	li	a1,120
 8f8:	853e                	mv	a0,a5
 8fa:	00000097          	auipc	ra,0x0
 8fe:	e96080e7          	jalr	-362(ra) # 790 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 902:	fe042623          	sw	zero,-20(s0)
 906:	a82d                	j	940 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 908:	fd043783          	ld	a5,-48(s0)
 90c:	93f1                	srli	a5,a5,0x3c
 90e:	00000717          	auipc	a4,0x0
 912:	6f270713          	addi	a4,a4,1778 # 1000 <digits>
 916:	97ba                	add	a5,a5,a4
 918:	0007c703          	lbu	a4,0(a5)
 91c:	fdc42783          	lw	a5,-36(s0)
 920:	85ba                	mv	a1,a4
 922:	853e                	mv	a0,a5
 924:	00000097          	auipc	ra,0x0
 928:	e6c080e7          	jalr	-404(ra) # 790 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 92c:	fec42783          	lw	a5,-20(s0)
 930:	2785                	addiw	a5,a5,1
 932:	fef42623          	sw	a5,-20(s0)
 936:	fd043783          	ld	a5,-48(s0)
 93a:	0792                	slli	a5,a5,0x4
 93c:	fcf43823          	sd	a5,-48(s0)
 940:	fec42703          	lw	a4,-20(s0)
 944:	47bd                	li	a5,15
 946:	fce7f1e3          	bgeu	a5,a4,908 <printptr+0x3c>
}
 94a:	0001                	nop
 94c:	0001                	nop
 94e:	70a2                	ld	ra,40(sp)
 950:	7402                	ld	s0,32(sp)
 952:	6145                	addi	sp,sp,48
 954:	8082                	ret

0000000000000956 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 956:	715d                	addi	sp,sp,-80
 958:	e486                	sd	ra,72(sp)
 95a:	e0a2                	sd	s0,64(sp)
 95c:	0880                	addi	s0,sp,80
 95e:	87aa                	mv	a5,a0
 960:	fcb43023          	sd	a1,-64(s0)
 964:	fac43c23          	sd	a2,-72(s0)
 968:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 96c:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 970:	fe042223          	sw	zero,-28(s0)
 974:	a42d                	j	b9e <vprintf+0x248>
    c = fmt[i] & 0xff;
 976:	fe442783          	lw	a5,-28(s0)
 97a:	fc043703          	ld	a4,-64(s0)
 97e:	97ba                	add	a5,a5,a4
 980:	0007c783          	lbu	a5,0(a5)
 984:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 988:	fe042783          	lw	a5,-32(s0)
 98c:	2781                	sext.w	a5,a5
 98e:	eb9d                	bnez	a5,9c4 <vprintf+0x6e>
      if(c == '%'){
 990:	fdc42783          	lw	a5,-36(s0)
 994:	0007871b          	sext.w	a4,a5
 998:	02500793          	li	a5,37
 99c:	00f71763          	bne	a4,a5,9aa <vprintf+0x54>
        state = '%';
 9a0:	02500793          	li	a5,37
 9a4:	fef42023          	sw	a5,-32(s0)
 9a8:	a2f5                	j	b94 <vprintf+0x23e>
      } else {
        putc(fd, c);
 9aa:	fdc42783          	lw	a5,-36(s0)
 9ae:	0ff7f713          	zext.b	a4,a5
 9b2:	fcc42783          	lw	a5,-52(s0)
 9b6:	85ba                	mv	a1,a4
 9b8:	853e                	mv	a0,a5
 9ba:	00000097          	auipc	ra,0x0
 9be:	dd6080e7          	jalr	-554(ra) # 790 <putc>
 9c2:	aac9                	j	b94 <vprintf+0x23e>
      }
    } else if(state == '%'){
 9c4:	fe042783          	lw	a5,-32(s0)
 9c8:	0007871b          	sext.w	a4,a5
 9cc:	02500793          	li	a5,37
 9d0:	1cf71263          	bne	a4,a5,b94 <vprintf+0x23e>
      if(c == 'd'){
 9d4:	fdc42783          	lw	a5,-36(s0)
 9d8:	0007871b          	sext.w	a4,a5
 9dc:	06400793          	li	a5,100
 9e0:	02f71463          	bne	a4,a5,a08 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 9e4:	fb843783          	ld	a5,-72(s0)
 9e8:	00878713          	addi	a4,a5,8
 9ec:	fae43c23          	sd	a4,-72(s0)
 9f0:	4398                	lw	a4,0(a5)
 9f2:	fcc42783          	lw	a5,-52(s0)
 9f6:	4685                	li	a3,1
 9f8:	4629                	li	a2,10
 9fa:	85ba                	mv	a1,a4
 9fc:	853e                	mv	a0,a5
 9fe:	00000097          	auipc	ra,0x0
 a02:	dc8080e7          	jalr	-568(ra) # 7c6 <printint>
 a06:	a269                	j	b90 <vprintf+0x23a>
      } else if(c == 'l') {
 a08:	fdc42783          	lw	a5,-36(s0)
 a0c:	0007871b          	sext.w	a4,a5
 a10:	06c00793          	li	a5,108
 a14:	02f71663          	bne	a4,a5,a40 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a18:	fb843783          	ld	a5,-72(s0)
 a1c:	00878713          	addi	a4,a5,8
 a20:	fae43c23          	sd	a4,-72(s0)
 a24:	639c                	ld	a5,0(a5)
 a26:	0007871b          	sext.w	a4,a5
 a2a:	fcc42783          	lw	a5,-52(s0)
 a2e:	4681                	li	a3,0
 a30:	4629                	li	a2,10
 a32:	85ba                	mv	a1,a4
 a34:	853e                	mv	a0,a5
 a36:	00000097          	auipc	ra,0x0
 a3a:	d90080e7          	jalr	-624(ra) # 7c6 <printint>
 a3e:	aa89                	j	b90 <vprintf+0x23a>
      } else if(c == 'x') {
 a40:	fdc42783          	lw	a5,-36(s0)
 a44:	0007871b          	sext.w	a4,a5
 a48:	07800793          	li	a5,120
 a4c:	02f71463          	bne	a4,a5,a74 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 a50:	fb843783          	ld	a5,-72(s0)
 a54:	00878713          	addi	a4,a5,8
 a58:	fae43c23          	sd	a4,-72(s0)
 a5c:	4398                	lw	a4,0(a5)
 a5e:	fcc42783          	lw	a5,-52(s0)
 a62:	4681                	li	a3,0
 a64:	4641                	li	a2,16
 a66:	85ba                	mv	a1,a4
 a68:	853e                	mv	a0,a5
 a6a:	00000097          	auipc	ra,0x0
 a6e:	d5c080e7          	jalr	-676(ra) # 7c6 <printint>
 a72:	aa39                	j	b90 <vprintf+0x23a>
      } else if(c == 'p') {
 a74:	fdc42783          	lw	a5,-36(s0)
 a78:	0007871b          	sext.w	a4,a5
 a7c:	07000793          	li	a5,112
 a80:	02f71263          	bne	a4,a5,aa4 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 a84:	fb843783          	ld	a5,-72(s0)
 a88:	00878713          	addi	a4,a5,8
 a8c:	fae43c23          	sd	a4,-72(s0)
 a90:	6398                	ld	a4,0(a5)
 a92:	fcc42783          	lw	a5,-52(s0)
 a96:	85ba                	mv	a1,a4
 a98:	853e                	mv	a0,a5
 a9a:	00000097          	auipc	ra,0x0
 a9e:	e32080e7          	jalr	-462(ra) # 8cc <printptr>
 aa2:	a0fd                	j	b90 <vprintf+0x23a>
      } else if(c == 's'){
 aa4:	fdc42783          	lw	a5,-36(s0)
 aa8:	0007871b          	sext.w	a4,a5
 aac:	07300793          	li	a5,115
 ab0:	04f71c63          	bne	a4,a5,b08 <vprintf+0x1b2>
        s = va_arg(ap, char*);
 ab4:	fb843783          	ld	a5,-72(s0)
 ab8:	00878713          	addi	a4,a5,8
 abc:	fae43c23          	sd	a4,-72(s0)
 ac0:	639c                	ld	a5,0(a5)
 ac2:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 ac6:	fe843783          	ld	a5,-24(s0)
 aca:	eb8d                	bnez	a5,afc <vprintf+0x1a6>
          s = "(null)";
 acc:	00000797          	auipc	a5,0x0
 ad0:	4cc78793          	addi	a5,a5,1228 # f98 <malloc+0x190>
 ad4:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 ad8:	a015                	j	afc <vprintf+0x1a6>
          putc(fd, *s);
 ada:	fe843783          	ld	a5,-24(s0)
 ade:	0007c703          	lbu	a4,0(a5)
 ae2:	fcc42783          	lw	a5,-52(s0)
 ae6:	85ba                	mv	a1,a4
 ae8:	853e                	mv	a0,a5
 aea:	00000097          	auipc	ra,0x0
 aee:	ca6080e7          	jalr	-858(ra) # 790 <putc>
          s++;
 af2:	fe843783          	ld	a5,-24(s0)
 af6:	0785                	addi	a5,a5,1
 af8:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 afc:	fe843783          	ld	a5,-24(s0)
 b00:	0007c783          	lbu	a5,0(a5)
 b04:	fbf9                	bnez	a5,ada <vprintf+0x184>
 b06:	a069                	j	b90 <vprintf+0x23a>
        }
      } else if(c == 'c'){
 b08:	fdc42783          	lw	a5,-36(s0)
 b0c:	0007871b          	sext.w	a4,a5
 b10:	06300793          	li	a5,99
 b14:	02f71463          	bne	a4,a5,b3c <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 b18:	fb843783          	ld	a5,-72(s0)
 b1c:	00878713          	addi	a4,a5,8
 b20:	fae43c23          	sd	a4,-72(s0)
 b24:	439c                	lw	a5,0(a5)
 b26:	0ff7f713          	zext.b	a4,a5
 b2a:	fcc42783          	lw	a5,-52(s0)
 b2e:	85ba                	mv	a1,a4
 b30:	853e                	mv	a0,a5
 b32:	00000097          	auipc	ra,0x0
 b36:	c5e080e7          	jalr	-930(ra) # 790 <putc>
 b3a:	a899                	j	b90 <vprintf+0x23a>
      } else if(c == '%'){
 b3c:	fdc42783          	lw	a5,-36(s0)
 b40:	0007871b          	sext.w	a4,a5
 b44:	02500793          	li	a5,37
 b48:	00f71f63          	bne	a4,a5,b66 <vprintf+0x210>
        putc(fd, c);
 b4c:	fdc42783          	lw	a5,-36(s0)
 b50:	0ff7f713          	zext.b	a4,a5
 b54:	fcc42783          	lw	a5,-52(s0)
 b58:	85ba                	mv	a1,a4
 b5a:	853e                	mv	a0,a5
 b5c:	00000097          	auipc	ra,0x0
 b60:	c34080e7          	jalr	-972(ra) # 790 <putc>
 b64:	a035                	j	b90 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 b66:	fcc42783          	lw	a5,-52(s0)
 b6a:	02500593          	li	a1,37
 b6e:	853e                	mv	a0,a5
 b70:	00000097          	auipc	ra,0x0
 b74:	c20080e7          	jalr	-992(ra) # 790 <putc>
        putc(fd, c);
 b78:	fdc42783          	lw	a5,-36(s0)
 b7c:	0ff7f713          	zext.b	a4,a5
 b80:	fcc42783          	lw	a5,-52(s0)
 b84:	85ba                	mv	a1,a4
 b86:	853e                	mv	a0,a5
 b88:	00000097          	auipc	ra,0x0
 b8c:	c08080e7          	jalr	-1016(ra) # 790 <putc>
      }
      state = 0;
 b90:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 b94:	fe442783          	lw	a5,-28(s0)
 b98:	2785                	addiw	a5,a5,1
 b9a:	fef42223          	sw	a5,-28(s0)
 b9e:	fe442783          	lw	a5,-28(s0)
 ba2:	fc043703          	ld	a4,-64(s0)
 ba6:	97ba                	add	a5,a5,a4
 ba8:	0007c783          	lbu	a5,0(a5)
 bac:	dc0795e3          	bnez	a5,976 <vprintf+0x20>
    }
  }
}
 bb0:	0001                	nop
 bb2:	0001                	nop
 bb4:	60a6                	ld	ra,72(sp)
 bb6:	6406                	ld	s0,64(sp)
 bb8:	6161                	addi	sp,sp,80
 bba:	8082                	ret

0000000000000bbc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 bbc:	7159                	addi	sp,sp,-112
 bbe:	fc06                	sd	ra,56(sp)
 bc0:	f822                	sd	s0,48(sp)
 bc2:	0080                	addi	s0,sp,64
 bc4:	fcb43823          	sd	a1,-48(s0)
 bc8:	e010                	sd	a2,0(s0)
 bca:	e414                	sd	a3,8(s0)
 bcc:	e818                	sd	a4,16(s0)
 bce:	ec1c                	sd	a5,24(s0)
 bd0:	03043023          	sd	a6,32(s0)
 bd4:	03143423          	sd	a7,40(s0)
 bd8:	87aa                	mv	a5,a0
 bda:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 bde:	03040793          	addi	a5,s0,48
 be2:	fcf43423          	sd	a5,-56(s0)
 be6:	fc843783          	ld	a5,-56(s0)
 bea:	fd078793          	addi	a5,a5,-48
 bee:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 bf2:	fe843703          	ld	a4,-24(s0)
 bf6:	fdc42783          	lw	a5,-36(s0)
 bfa:	863a                	mv	a2,a4
 bfc:	fd043583          	ld	a1,-48(s0)
 c00:	853e                	mv	a0,a5
 c02:	00000097          	auipc	ra,0x0
 c06:	d54080e7          	jalr	-684(ra) # 956 <vprintf>
}
 c0a:	0001                	nop
 c0c:	70e2                	ld	ra,56(sp)
 c0e:	7442                	ld	s0,48(sp)
 c10:	6165                	addi	sp,sp,112
 c12:	8082                	ret

0000000000000c14 <printf>:

void
printf(const char *fmt, ...)
{
 c14:	7159                	addi	sp,sp,-112
 c16:	f406                	sd	ra,40(sp)
 c18:	f022                	sd	s0,32(sp)
 c1a:	1800                	addi	s0,sp,48
 c1c:	fca43c23          	sd	a0,-40(s0)
 c20:	e40c                	sd	a1,8(s0)
 c22:	e810                	sd	a2,16(s0)
 c24:	ec14                	sd	a3,24(s0)
 c26:	f018                	sd	a4,32(s0)
 c28:	f41c                	sd	a5,40(s0)
 c2a:	03043823          	sd	a6,48(s0)
 c2e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 c32:	04040793          	addi	a5,s0,64
 c36:	fcf43823          	sd	a5,-48(s0)
 c3a:	fd043783          	ld	a5,-48(s0)
 c3e:	fc878793          	addi	a5,a5,-56
 c42:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 c46:	fe843783          	ld	a5,-24(s0)
 c4a:	863e                	mv	a2,a5
 c4c:	fd843583          	ld	a1,-40(s0)
 c50:	4505                	li	a0,1
 c52:	00000097          	auipc	ra,0x0
 c56:	d04080e7          	jalr	-764(ra) # 956 <vprintf>
}
 c5a:	0001                	nop
 c5c:	70a2                	ld	ra,40(sp)
 c5e:	7402                	ld	s0,32(sp)
 c60:	6165                	addi	sp,sp,112
 c62:	8082                	ret

0000000000000c64 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 c64:	7179                	addi	sp,sp,-48
 c66:	f406                	sd	ra,40(sp)
 c68:	f022                	sd	s0,32(sp)
 c6a:	1800                	addi	s0,sp,48
 c6c:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 c70:	fd843783          	ld	a5,-40(s0)
 c74:	17c1                	addi	a5,a5,-16
 c76:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c7a:	00000797          	auipc	a5,0x0
 c7e:	5b678793          	addi	a5,a5,1462 # 1230 <freep>
 c82:	639c                	ld	a5,0(a5)
 c84:	fef43423          	sd	a5,-24(s0)
 c88:	a815                	j	cbc <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c8a:	fe843783          	ld	a5,-24(s0)
 c8e:	639c                	ld	a5,0(a5)
 c90:	fe843703          	ld	a4,-24(s0)
 c94:	00f76f63          	bltu	a4,a5,cb2 <free+0x4e>
 c98:	fe043703          	ld	a4,-32(s0)
 c9c:	fe843783          	ld	a5,-24(s0)
 ca0:	02e7eb63          	bltu	a5,a4,cd6 <free+0x72>
 ca4:	fe843783          	ld	a5,-24(s0)
 ca8:	639c                	ld	a5,0(a5)
 caa:	fe043703          	ld	a4,-32(s0)
 cae:	02f76463          	bltu	a4,a5,cd6 <free+0x72>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cb2:	fe843783          	ld	a5,-24(s0)
 cb6:	639c                	ld	a5,0(a5)
 cb8:	fef43423          	sd	a5,-24(s0)
 cbc:	fe043703          	ld	a4,-32(s0)
 cc0:	fe843783          	ld	a5,-24(s0)
 cc4:	fce7f3e3          	bgeu	a5,a4,c8a <free+0x26>
 cc8:	fe843783          	ld	a5,-24(s0)
 ccc:	639c                	ld	a5,0(a5)
 cce:	fe043703          	ld	a4,-32(s0)
 cd2:	faf77ce3          	bgeu	a4,a5,c8a <free+0x26>
      break;
  if(bp + bp->s.size == p->s.ptr){
 cd6:	fe043783          	ld	a5,-32(s0)
 cda:	479c                	lw	a5,8(a5)
 cdc:	1782                	slli	a5,a5,0x20
 cde:	9381                	srli	a5,a5,0x20
 ce0:	0792                	slli	a5,a5,0x4
 ce2:	fe043703          	ld	a4,-32(s0)
 ce6:	973e                	add	a4,a4,a5
 ce8:	fe843783          	ld	a5,-24(s0)
 cec:	639c                	ld	a5,0(a5)
 cee:	02f71763          	bne	a4,a5,d1c <free+0xb8>
    bp->s.size += p->s.ptr->s.size;
 cf2:	fe043783          	ld	a5,-32(s0)
 cf6:	4798                	lw	a4,8(a5)
 cf8:	fe843783          	ld	a5,-24(s0)
 cfc:	639c                	ld	a5,0(a5)
 cfe:	479c                	lw	a5,8(a5)
 d00:	9fb9                	addw	a5,a5,a4
 d02:	0007871b          	sext.w	a4,a5
 d06:	fe043783          	ld	a5,-32(s0)
 d0a:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 d0c:	fe843783          	ld	a5,-24(s0)
 d10:	639c                	ld	a5,0(a5)
 d12:	6398                	ld	a4,0(a5)
 d14:	fe043783          	ld	a5,-32(s0)
 d18:	e398                	sd	a4,0(a5)
 d1a:	a039                	j	d28 <free+0xc4>
  } else
    bp->s.ptr = p->s.ptr;
 d1c:	fe843783          	ld	a5,-24(s0)
 d20:	6398                	ld	a4,0(a5)
 d22:	fe043783          	ld	a5,-32(s0)
 d26:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 d28:	fe843783          	ld	a5,-24(s0)
 d2c:	479c                	lw	a5,8(a5)
 d2e:	1782                	slli	a5,a5,0x20
 d30:	9381                	srli	a5,a5,0x20
 d32:	0792                	slli	a5,a5,0x4
 d34:	fe843703          	ld	a4,-24(s0)
 d38:	97ba                	add	a5,a5,a4
 d3a:	fe043703          	ld	a4,-32(s0)
 d3e:	02f71563          	bne	a4,a5,d68 <free+0x104>
    p->s.size += bp->s.size;
 d42:	fe843783          	ld	a5,-24(s0)
 d46:	4798                	lw	a4,8(a5)
 d48:	fe043783          	ld	a5,-32(s0)
 d4c:	479c                	lw	a5,8(a5)
 d4e:	9fb9                	addw	a5,a5,a4
 d50:	0007871b          	sext.w	a4,a5
 d54:	fe843783          	ld	a5,-24(s0)
 d58:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 d5a:	fe043783          	ld	a5,-32(s0)
 d5e:	6398                	ld	a4,0(a5)
 d60:	fe843783          	ld	a5,-24(s0)
 d64:	e398                	sd	a4,0(a5)
 d66:	a031                	j	d72 <free+0x10e>
  } else
    p->s.ptr = bp;
 d68:	fe843783          	ld	a5,-24(s0)
 d6c:	fe043703          	ld	a4,-32(s0)
 d70:	e398                	sd	a4,0(a5)
  freep = p;
 d72:	00000797          	auipc	a5,0x0
 d76:	4be78793          	addi	a5,a5,1214 # 1230 <freep>
 d7a:	fe843703          	ld	a4,-24(s0)
 d7e:	e398                	sd	a4,0(a5)
}
 d80:	0001                	nop
 d82:	70a2                	ld	ra,40(sp)
 d84:	7402                	ld	s0,32(sp)
 d86:	6145                	addi	sp,sp,48
 d88:	8082                	ret

0000000000000d8a <morecore>:

static Header*
morecore(uint nu)
{
 d8a:	7179                	addi	sp,sp,-48
 d8c:	f406                	sd	ra,40(sp)
 d8e:	f022                	sd	s0,32(sp)
 d90:	1800                	addi	s0,sp,48
 d92:	87aa                	mv	a5,a0
 d94:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 d98:	fdc42783          	lw	a5,-36(s0)
 d9c:	0007871b          	sext.w	a4,a5
 da0:	6785                	lui	a5,0x1
 da2:	00f77563          	bgeu	a4,a5,dac <morecore+0x22>
    nu = 4096;
 da6:	6785                	lui	a5,0x1
 da8:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 dac:	fdc42783          	lw	a5,-36(s0)
 db0:	0047979b          	slliw	a5,a5,0x4
 db4:	2781                	sext.w	a5,a5
 db6:	853e                	mv	a0,a5
 db8:	00000097          	auipc	ra,0x0
 dbc:	9c0080e7          	jalr	-1600(ra) # 778 <sbrk>
 dc0:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 dc4:	fe843703          	ld	a4,-24(s0)
 dc8:	57fd                	li	a5,-1
 dca:	00f71463          	bne	a4,a5,dd2 <morecore+0x48>
    return 0;
 dce:	4781                	li	a5,0
 dd0:	a03d                	j	dfe <morecore+0x74>
  hp = (Header*)p;
 dd2:	fe843783          	ld	a5,-24(s0)
 dd6:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 dda:	fe043783          	ld	a5,-32(s0)
 dde:	fdc42703          	lw	a4,-36(s0)
 de2:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 de4:	fe043783          	ld	a5,-32(s0)
 de8:	07c1                	addi	a5,a5,16 # 1010 <digits+0x10>
 dea:	853e                	mv	a0,a5
 dec:	00000097          	auipc	ra,0x0
 df0:	e78080e7          	jalr	-392(ra) # c64 <free>
  return freep;
 df4:	00000797          	auipc	a5,0x0
 df8:	43c78793          	addi	a5,a5,1084 # 1230 <freep>
 dfc:	639c                	ld	a5,0(a5)
}
 dfe:	853e                	mv	a0,a5
 e00:	70a2                	ld	ra,40(sp)
 e02:	7402                	ld	s0,32(sp)
 e04:	6145                	addi	sp,sp,48
 e06:	8082                	ret

0000000000000e08 <malloc>:

void*
malloc(uint nbytes)
{
 e08:	7139                	addi	sp,sp,-64
 e0a:	fc06                	sd	ra,56(sp)
 e0c:	f822                	sd	s0,48(sp)
 e0e:	0080                	addi	s0,sp,64
 e10:	87aa                	mv	a5,a0
 e12:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 e16:	fcc46783          	lwu	a5,-52(s0)
 e1a:	07bd                	addi	a5,a5,15
 e1c:	8391                	srli	a5,a5,0x4
 e1e:	2781                	sext.w	a5,a5
 e20:	2785                	addiw	a5,a5,1
 e22:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 e26:	00000797          	auipc	a5,0x0
 e2a:	40a78793          	addi	a5,a5,1034 # 1230 <freep>
 e2e:	639c                	ld	a5,0(a5)
 e30:	fef43023          	sd	a5,-32(s0)
 e34:	fe043783          	ld	a5,-32(s0)
 e38:	ef95                	bnez	a5,e74 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 e3a:	00000797          	auipc	a5,0x0
 e3e:	3e678793          	addi	a5,a5,998 # 1220 <base>
 e42:	fef43023          	sd	a5,-32(s0)
 e46:	00000797          	auipc	a5,0x0
 e4a:	3ea78793          	addi	a5,a5,1002 # 1230 <freep>
 e4e:	fe043703          	ld	a4,-32(s0)
 e52:	e398                	sd	a4,0(a5)
 e54:	00000797          	auipc	a5,0x0
 e58:	3dc78793          	addi	a5,a5,988 # 1230 <freep>
 e5c:	6398                	ld	a4,0(a5)
 e5e:	00000797          	auipc	a5,0x0
 e62:	3c278793          	addi	a5,a5,962 # 1220 <base>
 e66:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 e68:	00000797          	auipc	a5,0x0
 e6c:	3b878793          	addi	a5,a5,952 # 1220 <base>
 e70:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e74:	fe043783          	ld	a5,-32(s0)
 e78:	639c                	ld	a5,0(a5)
 e7a:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 e7e:	fe843783          	ld	a5,-24(s0)
 e82:	479c                	lw	a5,8(a5)
 e84:	fdc42703          	lw	a4,-36(s0)
 e88:	2701                	sext.w	a4,a4
 e8a:	06e7e763          	bltu	a5,a4,ef8 <malloc+0xf0>
      if(p->s.size == nunits)
 e8e:	fe843783          	ld	a5,-24(s0)
 e92:	479c                	lw	a5,8(a5)
 e94:	fdc42703          	lw	a4,-36(s0)
 e98:	2701                	sext.w	a4,a4
 e9a:	00f71963          	bne	a4,a5,eac <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 e9e:	fe843783          	ld	a5,-24(s0)
 ea2:	6398                	ld	a4,0(a5)
 ea4:	fe043783          	ld	a5,-32(s0)
 ea8:	e398                	sd	a4,0(a5)
 eaa:	a825                	j	ee2 <malloc+0xda>
      else {
        p->s.size -= nunits;
 eac:	fe843783          	ld	a5,-24(s0)
 eb0:	479c                	lw	a5,8(a5)
 eb2:	fdc42703          	lw	a4,-36(s0)
 eb6:	9f99                	subw	a5,a5,a4
 eb8:	0007871b          	sext.w	a4,a5
 ebc:	fe843783          	ld	a5,-24(s0)
 ec0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ec2:	fe843783          	ld	a5,-24(s0)
 ec6:	479c                	lw	a5,8(a5)
 ec8:	1782                	slli	a5,a5,0x20
 eca:	9381                	srli	a5,a5,0x20
 ecc:	0792                	slli	a5,a5,0x4
 ece:	fe843703          	ld	a4,-24(s0)
 ed2:	97ba                	add	a5,a5,a4
 ed4:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 ed8:	fe843783          	ld	a5,-24(s0)
 edc:	fdc42703          	lw	a4,-36(s0)
 ee0:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 ee2:	00000797          	auipc	a5,0x0
 ee6:	34e78793          	addi	a5,a5,846 # 1230 <freep>
 eea:	fe043703          	ld	a4,-32(s0)
 eee:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 ef0:	fe843783          	ld	a5,-24(s0)
 ef4:	07c1                	addi	a5,a5,16
 ef6:	a091                	j	f3a <malloc+0x132>
    }
    if(p == freep)
 ef8:	00000797          	auipc	a5,0x0
 efc:	33878793          	addi	a5,a5,824 # 1230 <freep>
 f00:	639c                	ld	a5,0(a5)
 f02:	fe843703          	ld	a4,-24(s0)
 f06:	02f71063          	bne	a4,a5,f26 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 f0a:	fdc42783          	lw	a5,-36(s0)
 f0e:	853e                	mv	a0,a5
 f10:	00000097          	auipc	ra,0x0
 f14:	e7a080e7          	jalr	-390(ra) # d8a <morecore>
 f18:	fea43423          	sd	a0,-24(s0)
 f1c:	fe843783          	ld	a5,-24(s0)
 f20:	e399                	bnez	a5,f26 <malloc+0x11e>
        return 0;
 f22:	4781                	li	a5,0
 f24:	a819                	j	f3a <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 f26:	fe843783          	ld	a5,-24(s0)
 f2a:	fef43023          	sd	a5,-32(s0)
 f2e:	fe843783          	ld	a5,-24(s0)
 f32:	639c                	ld	a5,0(a5)
 f34:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 f38:	b799                	j	e7e <malloc+0x76>
  }
}
 f3a:	853e                	mv	a0,a5
 f3c:	70e2                	ld	ra,56(sp)
 f3e:	7442                	ld	s0,48(sp)
 f40:	6121                	addi	sp,sp,64
 f42:	8082                	ret
