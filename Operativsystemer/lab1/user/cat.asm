
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	1800                	addi	s0,sp,48
   8:	87aa                	mv	a5,a0
   a:	fcf42e23          	sw	a5,-36(s0)
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
   e:	a091                	j	52 <cat+0x52>
    if (write(1, buf, n) != n) {
  10:	fec42783          	lw	a5,-20(s0)
  14:	863e                	mv	a2,a5
  16:	00001597          	auipc	a1,0x1
  1a:	00a58593          	addi	a1,a1,10 # 1020 <buf>
  1e:	4505                	li	a0,1
  20:	00000097          	auipc	ra,0x0
  24:	64a080e7          	jalr	1610(ra) # 66a <write>
  28:	87aa                	mv	a5,a0
  2a:	873e                	mv	a4,a5
  2c:	fec42783          	lw	a5,-20(s0)
  30:	2781                	sext.w	a5,a5
  32:	02e78063          	beq	a5,a4,52 <cat+0x52>
      fprintf(2, "cat: write error\n");
  36:	00001597          	auipc	a1,0x1
  3a:	e7a58593          	addi	a1,a1,-390 # eb0 <malloc+0x146>
  3e:	4509                	li	a0,2
  40:	00001097          	auipc	ra,0x1
  44:	ade080e7          	jalr	-1314(ra) # b1e <fprintf>
      exit(1);
  48:	4505                	li	a0,1
  4a:	00000097          	auipc	ra,0x0
  4e:	600080e7          	jalr	1536(ra) # 64a <exit>
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  52:	fdc42783          	lw	a5,-36(s0)
  56:	20000613          	li	a2,512
  5a:	00001597          	auipc	a1,0x1
  5e:	fc658593          	addi	a1,a1,-58 # 1020 <buf>
  62:	853e                	mv	a0,a5
  64:	00000097          	auipc	ra,0x0
  68:	5fe080e7          	jalr	1534(ra) # 662 <read>
  6c:	87aa                	mv	a5,a0
  6e:	fef42623          	sw	a5,-20(s0)
  72:	fec42783          	lw	a5,-20(s0)
  76:	2781                	sext.w	a5,a5
  78:	f8f04ce3          	bgtz	a5,10 <cat+0x10>
    }
  }
  if(n < 0){
  7c:	fec42783          	lw	a5,-20(s0)
  80:	2781                	sext.w	a5,a5
  82:	0207d063          	bgez	a5,a2 <cat+0xa2>
    fprintf(2, "cat: read error\n");
  86:	00001597          	auipc	a1,0x1
  8a:	e4258593          	addi	a1,a1,-446 # ec8 <malloc+0x15e>
  8e:	4509                	li	a0,2
  90:	00001097          	auipc	ra,0x1
  94:	a8e080e7          	jalr	-1394(ra) # b1e <fprintf>
    exit(1);
  98:	4505                	li	a0,1
  9a:	00000097          	auipc	ra,0x0
  9e:	5b0080e7          	jalr	1456(ra) # 64a <exit>
  }
}
  a2:	0001                	nop
  a4:	70a2                	ld	ra,40(sp)
  a6:	7402                	ld	s0,32(sp)
  a8:	6145                	addi	sp,sp,48
  aa:	8082                	ret

00000000000000ac <main>:

int
main(int argc, char *argv[])
{
  ac:	7179                	addi	sp,sp,-48
  ae:	f406                	sd	ra,40(sp)
  b0:	f022                	sd	s0,32(sp)
  b2:	1800                	addi	s0,sp,48
  b4:	87aa                	mv	a5,a0
  b6:	fcb43823          	sd	a1,-48(s0)
  ba:	fcf42e23          	sw	a5,-36(s0)
  int fd, i;

  if(argc <= 1){
  be:	fdc42783          	lw	a5,-36(s0)
  c2:	0007871b          	sext.w	a4,a5
  c6:	4785                	li	a5,1
  c8:	00e7cc63          	blt	a5,a4,e0 <main+0x34>
    cat(0);
  cc:	4501                	li	a0,0
  ce:	00000097          	auipc	ra,0x0
  d2:	f32080e7          	jalr	-206(ra) # 0 <cat>
    exit(0);
  d6:	4501                	li	a0,0
  d8:	00000097          	auipc	ra,0x0
  dc:	572080e7          	jalr	1394(ra) # 64a <exit>
  }

  for(i = 1; i < argc; i++){
  e0:	4785                	li	a5,1
  e2:	fef42623          	sw	a5,-20(s0)
  e6:	a8bd                	j	164 <main+0xb8>
    if((fd = open(argv[i], 0)) < 0){
  e8:	fec42783          	lw	a5,-20(s0)
  ec:	078e                	slli	a5,a5,0x3
  ee:	fd043703          	ld	a4,-48(s0)
  f2:	97ba                	add	a5,a5,a4
  f4:	639c                	ld	a5,0(a5)
  f6:	4581                	li	a1,0
  f8:	853e                	mv	a0,a5
  fa:	00000097          	auipc	ra,0x0
  fe:	590080e7          	jalr	1424(ra) # 68a <open>
 102:	87aa                	mv	a5,a0
 104:	fef42423          	sw	a5,-24(s0)
 108:	fe842783          	lw	a5,-24(s0)
 10c:	2781                	sext.w	a5,a5
 10e:	0207d863          	bgez	a5,13e <main+0x92>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
 112:	fec42783          	lw	a5,-20(s0)
 116:	078e                	slli	a5,a5,0x3
 118:	fd043703          	ld	a4,-48(s0)
 11c:	97ba                	add	a5,a5,a4
 11e:	639c                	ld	a5,0(a5)
 120:	863e                	mv	a2,a5
 122:	00001597          	auipc	a1,0x1
 126:	dbe58593          	addi	a1,a1,-578 # ee0 <malloc+0x176>
 12a:	4509                	li	a0,2
 12c:	00001097          	auipc	ra,0x1
 130:	9f2080e7          	jalr	-1550(ra) # b1e <fprintf>
      exit(1);
 134:	4505                	li	a0,1
 136:	00000097          	auipc	ra,0x0
 13a:	514080e7          	jalr	1300(ra) # 64a <exit>
    }
    cat(fd);
 13e:	fe842783          	lw	a5,-24(s0)
 142:	853e                	mv	a0,a5
 144:	00000097          	auipc	ra,0x0
 148:	ebc080e7          	jalr	-324(ra) # 0 <cat>
    close(fd);
 14c:	fe842783          	lw	a5,-24(s0)
 150:	853e                	mv	a0,a5
 152:	00000097          	auipc	ra,0x0
 156:	520080e7          	jalr	1312(ra) # 672 <close>
  for(i = 1; i < argc; i++){
 15a:	fec42783          	lw	a5,-20(s0)
 15e:	2785                	addiw	a5,a5,1
 160:	fef42623          	sw	a5,-20(s0)
 164:	fec42783          	lw	a5,-20(s0)
 168:	873e                	mv	a4,a5
 16a:	fdc42783          	lw	a5,-36(s0)
 16e:	2701                	sext.w	a4,a4
 170:	2781                	sext.w	a5,a5
 172:	f6f74be3          	blt	a4,a5,e8 <main+0x3c>
  }
  exit(0);
 176:	4501                	li	a0,0
 178:	00000097          	auipc	ra,0x0
 17c:	4d2080e7          	jalr	1234(ra) # 64a <exit>

0000000000000180 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 180:	1141                	addi	sp,sp,-16
 182:	e406                	sd	ra,8(sp)
 184:	e022                	sd	s0,0(sp)
 186:	0800                	addi	s0,sp,16
  extern int main();
  main();
 188:	00000097          	auipc	ra,0x0
 18c:	f24080e7          	jalr	-220(ra) # ac <main>
  exit(0);
 190:	4501                	li	a0,0
 192:	00000097          	auipc	ra,0x0
 196:	4b8080e7          	jalr	1208(ra) # 64a <exit>

000000000000019a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 19a:	7179                	addi	sp,sp,-48
 19c:	f406                	sd	ra,40(sp)
 19e:	f022                	sd	s0,32(sp)
 1a0:	1800                	addi	s0,sp,48
 1a2:	fca43c23          	sd	a0,-40(s0)
 1a6:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
 1aa:	fd843783          	ld	a5,-40(s0)
 1ae:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
 1b2:	0001                	nop
 1b4:	fd043703          	ld	a4,-48(s0)
 1b8:	00170793          	addi	a5,a4,1
 1bc:	fcf43823          	sd	a5,-48(s0)
 1c0:	fd843783          	ld	a5,-40(s0)
 1c4:	00178693          	addi	a3,a5,1
 1c8:	fcd43c23          	sd	a3,-40(s0)
 1cc:	00074703          	lbu	a4,0(a4)
 1d0:	00e78023          	sb	a4,0(a5)
 1d4:	0007c783          	lbu	a5,0(a5)
 1d8:	fff1                	bnez	a5,1b4 <strcpy+0x1a>
    ;
  return os;
 1da:	fe843783          	ld	a5,-24(s0)
}
 1de:	853e                	mv	a0,a5
 1e0:	70a2                	ld	ra,40(sp)
 1e2:	7402                	ld	s0,32(sp)
 1e4:	6145                	addi	sp,sp,48
 1e6:	8082                	ret

00000000000001e8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1e8:	1101                	addi	sp,sp,-32
 1ea:	ec06                	sd	ra,24(sp)
 1ec:	e822                	sd	s0,16(sp)
 1ee:	1000                	addi	s0,sp,32
 1f0:	fea43423          	sd	a0,-24(s0)
 1f4:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
 1f8:	a819                	j	20e <strcmp+0x26>
    p++, q++;
 1fa:	fe843783          	ld	a5,-24(s0)
 1fe:	0785                	addi	a5,a5,1
 200:	fef43423          	sd	a5,-24(s0)
 204:	fe043783          	ld	a5,-32(s0)
 208:	0785                	addi	a5,a5,1
 20a:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
 20e:	fe843783          	ld	a5,-24(s0)
 212:	0007c783          	lbu	a5,0(a5)
 216:	cb99                	beqz	a5,22c <strcmp+0x44>
 218:	fe843783          	ld	a5,-24(s0)
 21c:	0007c703          	lbu	a4,0(a5)
 220:	fe043783          	ld	a5,-32(s0)
 224:	0007c783          	lbu	a5,0(a5)
 228:	fcf709e3          	beq	a4,a5,1fa <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
 22c:	fe843783          	ld	a5,-24(s0)
 230:	0007c783          	lbu	a5,0(a5)
 234:	0007871b          	sext.w	a4,a5
 238:	fe043783          	ld	a5,-32(s0)
 23c:	0007c783          	lbu	a5,0(a5)
 240:	2781                	sext.w	a5,a5
 242:	40f707bb          	subw	a5,a4,a5
 246:	2781                	sext.w	a5,a5
}
 248:	853e                	mv	a0,a5
 24a:	60e2                	ld	ra,24(sp)
 24c:	6442                	ld	s0,16(sp)
 24e:	6105                	addi	sp,sp,32
 250:	8082                	ret

0000000000000252 <strlen>:

uint
strlen(const char *s)
{
 252:	7179                	addi	sp,sp,-48
 254:	f406                	sd	ra,40(sp)
 256:	f022                	sd	s0,32(sp)
 258:	1800                	addi	s0,sp,48
 25a:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
 25e:	fe042623          	sw	zero,-20(s0)
 262:	a031                	j	26e <strlen+0x1c>
 264:	fec42783          	lw	a5,-20(s0)
 268:	2785                	addiw	a5,a5,1
 26a:	fef42623          	sw	a5,-20(s0)
 26e:	fec42783          	lw	a5,-20(s0)
 272:	fd843703          	ld	a4,-40(s0)
 276:	97ba                	add	a5,a5,a4
 278:	0007c783          	lbu	a5,0(a5)
 27c:	f7e5                	bnez	a5,264 <strlen+0x12>
    ;
  return n;
 27e:	fec42783          	lw	a5,-20(s0)
}
 282:	853e                	mv	a0,a5
 284:	70a2                	ld	ra,40(sp)
 286:	7402                	ld	s0,32(sp)
 288:	6145                	addi	sp,sp,48
 28a:	8082                	ret

000000000000028c <memset>:

void*
memset(void *dst, int c, uint n)
{
 28c:	7179                	addi	sp,sp,-48
 28e:	f406                	sd	ra,40(sp)
 290:	f022                	sd	s0,32(sp)
 292:	1800                	addi	s0,sp,48
 294:	fca43c23          	sd	a0,-40(s0)
 298:	87ae                	mv	a5,a1
 29a:	8732                	mv	a4,a2
 29c:	fcf42a23          	sw	a5,-44(s0)
 2a0:	87ba                	mv	a5,a4
 2a2:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
 2a6:	fd843783          	ld	a5,-40(s0)
 2aa:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
 2ae:	fe042623          	sw	zero,-20(s0)
 2b2:	a00d                	j	2d4 <memset+0x48>
    cdst[i] = c;
 2b4:	fec42783          	lw	a5,-20(s0)
 2b8:	fe043703          	ld	a4,-32(s0)
 2bc:	97ba                	add	a5,a5,a4
 2be:	fd442703          	lw	a4,-44(s0)
 2c2:	0ff77713          	zext.b	a4,a4
 2c6:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
 2ca:	fec42783          	lw	a5,-20(s0)
 2ce:	2785                	addiw	a5,a5,1
 2d0:	fef42623          	sw	a5,-20(s0)
 2d4:	fec42783          	lw	a5,-20(s0)
 2d8:	fd042703          	lw	a4,-48(s0)
 2dc:	2701                	sext.w	a4,a4
 2de:	fce7ebe3          	bltu	a5,a4,2b4 <memset+0x28>
  }
  return dst;
 2e2:	fd843783          	ld	a5,-40(s0)
}
 2e6:	853e                	mv	a0,a5
 2e8:	70a2                	ld	ra,40(sp)
 2ea:	7402                	ld	s0,32(sp)
 2ec:	6145                	addi	sp,sp,48
 2ee:	8082                	ret

00000000000002f0 <strchr>:

char*
strchr(const char *s, char c)
{
 2f0:	1101                	addi	sp,sp,-32
 2f2:	ec06                	sd	ra,24(sp)
 2f4:	e822                	sd	s0,16(sp)
 2f6:	1000                	addi	s0,sp,32
 2f8:	fea43423          	sd	a0,-24(s0)
 2fc:	87ae                	mv	a5,a1
 2fe:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
 302:	a01d                	j	328 <strchr+0x38>
    if(*s == c)
 304:	fe843783          	ld	a5,-24(s0)
 308:	0007c703          	lbu	a4,0(a5)
 30c:	fe744783          	lbu	a5,-25(s0)
 310:	0ff7f793          	zext.b	a5,a5
 314:	00e79563          	bne	a5,a4,31e <strchr+0x2e>
      return (char*)s;
 318:	fe843783          	ld	a5,-24(s0)
 31c:	a821                	j	334 <strchr+0x44>
  for(; *s; s++)
 31e:	fe843783          	ld	a5,-24(s0)
 322:	0785                	addi	a5,a5,1
 324:	fef43423          	sd	a5,-24(s0)
 328:	fe843783          	ld	a5,-24(s0)
 32c:	0007c783          	lbu	a5,0(a5)
 330:	fbf1                	bnez	a5,304 <strchr+0x14>
  return 0;
 332:	4781                	li	a5,0
}
 334:	853e                	mv	a0,a5
 336:	60e2                	ld	ra,24(sp)
 338:	6442                	ld	s0,16(sp)
 33a:	6105                	addi	sp,sp,32
 33c:	8082                	ret

000000000000033e <gets>:

char*
gets(char *buf, int max)
{
 33e:	7179                	addi	sp,sp,-48
 340:	f406                	sd	ra,40(sp)
 342:	f022                	sd	s0,32(sp)
 344:	1800                	addi	s0,sp,48
 346:	fca43c23          	sd	a0,-40(s0)
 34a:	87ae                	mv	a5,a1
 34c:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 350:	fe042623          	sw	zero,-20(s0)
 354:	a8a1                	j	3ac <gets+0x6e>
    cc = read(0, &c, 1);
 356:	fe740793          	addi	a5,s0,-25
 35a:	4605                	li	a2,1
 35c:	85be                	mv	a1,a5
 35e:	4501                	li	a0,0
 360:	00000097          	auipc	ra,0x0
 364:	302080e7          	jalr	770(ra) # 662 <read>
 368:	87aa                	mv	a5,a0
 36a:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
 36e:	fe842783          	lw	a5,-24(s0)
 372:	2781                	sext.w	a5,a5
 374:	04f05663          	blez	a5,3c0 <gets+0x82>
      break;
    buf[i++] = c;
 378:	fec42783          	lw	a5,-20(s0)
 37c:	0017871b          	addiw	a4,a5,1
 380:	fee42623          	sw	a4,-20(s0)
 384:	873e                	mv	a4,a5
 386:	fd843783          	ld	a5,-40(s0)
 38a:	97ba                	add	a5,a5,a4
 38c:	fe744703          	lbu	a4,-25(s0)
 390:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
 394:	fe744783          	lbu	a5,-25(s0)
 398:	873e                	mv	a4,a5
 39a:	47a9                	li	a5,10
 39c:	02f70363          	beq	a4,a5,3c2 <gets+0x84>
 3a0:	fe744783          	lbu	a5,-25(s0)
 3a4:	873e                	mv	a4,a5
 3a6:	47b5                	li	a5,13
 3a8:	00f70d63          	beq	a4,a5,3c2 <gets+0x84>
  for(i=0; i+1 < max; ){
 3ac:	fec42783          	lw	a5,-20(s0)
 3b0:	2785                	addiw	a5,a5,1
 3b2:	2781                	sext.w	a5,a5
 3b4:	fd442703          	lw	a4,-44(s0)
 3b8:	2701                	sext.w	a4,a4
 3ba:	f8e7cee3          	blt	a5,a4,356 <gets+0x18>
 3be:	a011                	j	3c2 <gets+0x84>
      break;
 3c0:	0001                	nop
      break;
  }
  buf[i] = '\0';
 3c2:	fec42783          	lw	a5,-20(s0)
 3c6:	fd843703          	ld	a4,-40(s0)
 3ca:	97ba                	add	a5,a5,a4
 3cc:	00078023          	sb	zero,0(a5)
  return buf;
 3d0:	fd843783          	ld	a5,-40(s0)
}
 3d4:	853e                	mv	a0,a5
 3d6:	70a2                	ld	ra,40(sp)
 3d8:	7402                	ld	s0,32(sp)
 3da:	6145                	addi	sp,sp,48
 3dc:	8082                	ret

00000000000003de <stat>:

int
stat(const char *n, struct stat *st)
{
 3de:	7179                	addi	sp,sp,-48
 3e0:	f406                	sd	ra,40(sp)
 3e2:	f022                	sd	s0,32(sp)
 3e4:	1800                	addi	s0,sp,48
 3e6:	fca43c23          	sd	a0,-40(s0)
 3ea:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3ee:	4581                	li	a1,0
 3f0:	fd843503          	ld	a0,-40(s0)
 3f4:	00000097          	auipc	ra,0x0
 3f8:	296080e7          	jalr	662(ra) # 68a <open>
 3fc:	87aa                	mv	a5,a0
 3fe:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
 402:	fec42783          	lw	a5,-20(s0)
 406:	2781                	sext.w	a5,a5
 408:	0007d463          	bgez	a5,410 <stat+0x32>
    return -1;
 40c:	57fd                	li	a5,-1
 40e:	a035                	j	43a <stat+0x5c>
  r = fstat(fd, st);
 410:	fec42783          	lw	a5,-20(s0)
 414:	fd043583          	ld	a1,-48(s0)
 418:	853e                	mv	a0,a5
 41a:	00000097          	auipc	ra,0x0
 41e:	288080e7          	jalr	648(ra) # 6a2 <fstat>
 422:	87aa                	mv	a5,a0
 424:	fef42423          	sw	a5,-24(s0)
  close(fd);
 428:	fec42783          	lw	a5,-20(s0)
 42c:	853e                	mv	a0,a5
 42e:	00000097          	auipc	ra,0x0
 432:	244080e7          	jalr	580(ra) # 672 <close>
  return r;
 436:	fe842783          	lw	a5,-24(s0)
}
 43a:	853e                	mv	a0,a5
 43c:	70a2                	ld	ra,40(sp)
 43e:	7402                	ld	s0,32(sp)
 440:	6145                	addi	sp,sp,48
 442:	8082                	ret

0000000000000444 <atoi>:

int
atoi(const char *s)
{
 444:	7179                	addi	sp,sp,-48
 446:	f406                	sd	ra,40(sp)
 448:	f022                	sd	s0,32(sp)
 44a:	1800                	addi	s0,sp,48
 44c:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
 450:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
 454:	a81d                	j	48a <atoi+0x46>
    n = n*10 + *s++ - '0';
 456:	fec42783          	lw	a5,-20(s0)
 45a:	873e                	mv	a4,a5
 45c:	87ba                	mv	a5,a4
 45e:	0027979b          	slliw	a5,a5,0x2
 462:	9fb9                	addw	a5,a5,a4
 464:	0017979b          	slliw	a5,a5,0x1
 468:	0007871b          	sext.w	a4,a5
 46c:	fd843783          	ld	a5,-40(s0)
 470:	00178693          	addi	a3,a5,1
 474:	fcd43c23          	sd	a3,-40(s0)
 478:	0007c783          	lbu	a5,0(a5)
 47c:	2781                	sext.w	a5,a5
 47e:	9fb9                	addw	a5,a5,a4
 480:	2781                	sext.w	a5,a5
 482:	fd07879b          	addiw	a5,a5,-48
 486:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
 48a:	fd843783          	ld	a5,-40(s0)
 48e:	0007c783          	lbu	a5,0(a5)
 492:	873e                	mv	a4,a5
 494:	02f00793          	li	a5,47
 498:	00e7fb63          	bgeu	a5,a4,4ae <atoi+0x6a>
 49c:	fd843783          	ld	a5,-40(s0)
 4a0:	0007c783          	lbu	a5,0(a5)
 4a4:	873e                	mv	a4,a5
 4a6:	03900793          	li	a5,57
 4aa:	fae7f6e3          	bgeu	a5,a4,456 <atoi+0x12>
  return n;
 4ae:	fec42783          	lw	a5,-20(s0)
}
 4b2:	853e                	mv	a0,a5
 4b4:	70a2                	ld	ra,40(sp)
 4b6:	7402                	ld	s0,32(sp)
 4b8:	6145                	addi	sp,sp,48
 4ba:	8082                	ret

00000000000004bc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4bc:	7139                	addi	sp,sp,-64
 4be:	fc06                	sd	ra,56(sp)
 4c0:	f822                	sd	s0,48(sp)
 4c2:	0080                	addi	s0,sp,64
 4c4:	fca43c23          	sd	a0,-40(s0)
 4c8:	fcb43823          	sd	a1,-48(s0)
 4cc:	87b2                	mv	a5,a2
 4ce:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
 4d2:	fd843783          	ld	a5,-40(s0)
 4d6:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
 4da:	fd043783          	ld	a5,-48(s0)
 4de:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
 4e2:	fe043703          	ld	a4,-32(s0)
 4e6:	fe843783          	ld	a5,-24(s0)
 4ea:	02e7fc63          	bgeu	a5,a4,522 <memmove+0x66>
    while(n-- > 0)
 4ee:	a00d                	j	510 <memmove+0x54>
      *dst++ = *src++;
 4f0:	fe043703          	ld	a4,-32(s0)
 4f4:	00170793          	addi	a5,a4,1
 4f8:	fef43023          	sd	a5,-32(s0)
 4fc:	fe843783          	ld	a5,-24(s0)
 500:	00178693          	addi	a3,a5,1
 504:	fed43423          	sd	a3,-24(s0)
 508:	00074703          	lbu	a4,0(a4)
 50c:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 510:	fcc42783          	lw	a5,-52(s0)
 514:	fff7871b          	addiw	a4,a5,-1
 518:	fce42623          	sw	a4,-52(s0)
 51c:	fcf04ae3          	bgtz	a5,4f0 <memmove+0x34>
 520:	a891                	j	574 <memmove+0xb8>
  } else {
    dst += n;
 522:	fcc42783          	lw	a5,-52(s0)
 526:	fe843703          	ld	a4,-24(s0)
 52a:	97ba                	add	a5,a5,a4
 52c:	fef43423          	sd	a5,-24(s0)
    src += n;
 530:	fcc42783          	lw	a5,-52(s0)
 534:	fe043703          	ld	a4,-32(s0)
 538:	97ba                	add	a5,a5,a4
 53a:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
 53e:	a01d                	j	564 <memmove+0xa8>
      *--dst = *--src;
 540:	fe043783          	ld	a5,-32(s0)
 544:	17fd                	addi	a5,a5,-1
 546:	fef43023          	sd	a5,-32(s0)
 54a:	fe843783          	ld	a5,-24(s0)
 54e:	17fd                	addi	a5,a5,-1
 550:	fef43423          	sd	a5,-24(s0)
 554:	fe043783          	ld	a5,-32(s0)
 558:	0007c703          	lbu	a4,0(a5)
 55c:	fe843783          	ld	a5,-24(s0)
 560:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 564:	fcc42783          	lw	a5,-52(s0)
 568:	fff7871b          	addiw	a4,a5,-1
 56c:	fce42623          	sw	a4,-52(s0)
 570:	fcf048e3          	bgtz	a5,540 <memmove+0x84>
  }
  return vdst;
 574:	fd843783          	ld	a5,-40(s0)
}
 578:	853e                	mv	a0,a5
 57a:	70e2                	ld	ra,56(sp)
 57c:	7442                	ld	s0,48(sp)
 57e:	6121                	addi	sp,sp,64
 580:	8082                	ret

0000000000000582 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 582:	7139                	addi	sp,sp,-64
 584:	fc06                	sd	ra,56(sp)
 586:	f822                	sd	s0,48(sp)
 588:	0080                	addi	s0,sp,64
 58a:	fca43c23          	sd	a0,-40(s0)
 58e:	fcb43823          	sd	a1,-48(s0)
 592:	87b2                	mv	a5,a2
 594:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
 598:	fd843783          	ld	a5,-40(s0)
 59c:	fef43423          	sd	a5,-24(s0)
 5a0:	fd043783          	ld	a5,-48(s0)
 5a4:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 5a8:	a0a1                	j	5f0 <memcmp+0x6e>
    if (*p1 != *p2) {
 5aa:	fe843783          	ld	a5,-24(s0)
 5ae:	0007c703          	lbu	a4,0(a5)
 5b2:	fe043783          	ld	a5,-32(s0)
 5b6:	0007c783          	lbu	a5,0(a5)
 5ba:	02f70163          	beq	a4,a5,5dc <memcmp+0x5a>
      return *p1 - *p2;
 5be:	fe843783          	ld	a5,-24(s0)
 5c2:	0007c783          	lbu	a5,0(a5)
 5c6:	0007871b          	sext.w	a4,a5
 5ca:	fe043783          	ld	a5,-32(s0)
 5ce:	0007c783          	lbu	a5,0(a5)
 5d2:	2781                	sext.w	a5,a5
 5d4:	40f707bb          	subw	a5,a4,a5
 5d8:	2781                	sext.w	a5,a5
 5da:	a01d                	j	600 <memcmp+0x7e>
    }
    p1++;
 5dc:	fe843783          	ld	a5,-24(s0)
 5e0:	0785                	addi	a5,a5,1
 5e2:	fef43423          	sd	a5,-24(s0)
    p2++;
 5e6:	fe043783          	ld	a5,-32(s0)
 5ea:	0785                	addi	a5,a5,1
 5ec:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 5f0:	fcc42783          	lw	a5,-52(s0)
 5f4:	fff7871b          	addiw	a4,a5,-1
 5f8:	fce42623          	sw	a4,-52(s0)
 5fc:	f7dd                	bnez	a5,5aa <memcmp+0x28>
  }
  return 0;
 5fe:	4781                	li	a5,0
}
 600:	853e                	mv	a0,a5
 602:	70e2                	ld	ra,56(sp)
 604:	7442                	ld	s0,48(sp)
 606:	6121                	addi	sp,sp,64
 608:	8082                	ret

000000000000060a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 60a:	7179                	addi	sp,sp,-48
 60c:	f406                	sd	ra,40(sp)
 60e:	f022                	sd	s0,32(sp)
 610:	1800                	addi	s0,sp,48
 612:	fea43423          	sd	a0,-24(s0)
 616:	feb43023          	sd	a1,-32(s0)
 61a:	87b2                	mv	a5,a2
 61c:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
 620:	fdc42783          	lw	a5,-36(s0)
 624:	863e                	mv	a2,a5
 626:	fe043583          	ld	a1,-32(s0)
 62a:	fe843503          	ld	a0,-24(s0)
 62e:	00000097          	auipc	ra,0x0
 632:	e8e080e7          	jalr	-370(ra) # 4bc <memmove>
 636:	87aa                	mv	a5,a0
}
 638:	853e                	mv	a0,a5
 63a:	70a2                	ld	ra,40(sp)
 63c:	7402                	ld	s0,32(sp)
 63e:	6145                	addi	sp,sp,48
 640:	8082                	ret

0000000000000642 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 642:	4885                	li	a7,1
 ecall
 644:	00000073          	ecall
 ret
 648:	8082                	ret

000000000000064a <exit>:
.global exit
exit:
 li a7, SYS_exit
 64a:	4889                	li	a7,2
 ecall
 64c:	00000073          	ecall
 ret
 650:	8082                	ret

0000000000000652 <wait>:
.global wait
wait:
 li a7, SYS_wait
 652:	488d                	li	a7,3
 ecall
 654:	00000073          	ecall
 ret
 658:	8082                	ret

000000000000065a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 65a:	4891                	li	a7,4
 ecall
 65c:	00000073          	ecall
 ret
 660:	8082                	ret

0000000000000662 <read>:
.global read
read:
 li a7, SYS_read
 662:	4895                	li	a7,5
 ecall
 664:	00000073          	ecall
 ret
 668:	8082                	ret

000000000000066a <write>:
.global write
write:
 li a7, SYS_write
 66a:	48c1                	li	a7,16
 ecall
 66c:	00000073          	ecall
 ret
 670:	8082                	ret

0000000000000672 <close>:
.global close
close:
 li a7, SYS_close
 672:	48d5                	li	a7,21
 ecall
 674:	00000073          	ecall
 ret
 678:	8082                	ret

000000000000067a <kill>:
.global kill
kill:
 li a7, SYS_kill
 67a:	4899                	li	a7,6
 ecall
 67c:	00000073          	ecall
 ret
 680:	8082                	ret

0000000000000682 <exec>:
.global exec
exec:
 li a7, SYS_exec
 682:	489d                	li	a7,7
 ecall
 684:	00000073          	ecall
 ret
 688:	8082                	ret

000000000000068a <open>:
.global open
open:
 li a7, SYS_open
 68a:	48bd                	li	a7,15
 ecall
 68c:	00000073          	ecall
 ret
 690:	8082                	ret

0000000000000692 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 692:	48c5                	li	a7,17
 ecall
 694:	00000073          	ecall
 ret
 698:	8082                	ret

000000000000069a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 69a:	48c9                	li	a7,18
 ecall
 69c:	00000073          	ecall
 ret
 6a0:	8082                	ret

00000000000006a2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 6a2:	48a1                	li	a7,8
 ecall
 6a4:	00000073          	ecall
 ret
 6a8:	8082                	ret

00000000000006aa <link>:
.global link
link:
 li a7, SYS_link
 6aa:	48cd                	li	a7,19
 ecall
 6ac:	00000073          	ecall
 ret
 6b0:	8082                	ret

00000000000006b2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 6b2:	48d1                	li	a7,20
 ecall
 6b4:	00000073          	ecall
 ret
 6b8:	8082                	ret

00000000000006ba <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 6ba:	48a5                	li	a7,9
 ecall
 6bc:	00000073          	ecall
 ret
 6c0:	8082                	ret

00000000000006c2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 6c2:	48a9                	li	a7,10
 ecall
 6c4:	00000073          	ecall
 ret
 6c8:	8082                	ret

00000000000006ca <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6ca:	48ad                	li	a7,11
 ecall
 6cc:	00000073          	ecall
 ret
 6d0:	8082                	ret

00000000000006d2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6d2:	48b1                	li	a7,12
 ecall
 6d4:	00000073          	ecall
 ret
 6d8:	8082                	ret

00000000000006da <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6da:	48b5                	li	a7,13
 ecall
 6dc:	00000073          	ecall
 ret
 6e0:	8082                	ret

00000000000006e2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6e2:	48b9                	li	a7,14
 ecall
 6e4:	00000073          	ecall
 ret
 6e8:	8082                	ret

00000000000006ea <ps>:
.global ps
ps:
 li a7, SYS_ps
 6ea:	48d9                	li	a7,22
 ecall
 6ec:	00000073          	ecall
 ret
 6f0:	8082                	ret

00000000000006f2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6f2:	1101                	addi	sp,sp,-32
 6f4:	ec06                	sd	ra,24(sp)
 6f6:	e822                	sd	s0,16(sp)
 6f8:	1000                	addi	s0,sp,32
 6fa:	87aa                	mv	a5,a0
 6fc:	872e                	mv	a4,a1
 6fe:	fef42623          	sw	a5,-20(s0)
 702:	87ba                	mv	a5,a4
 704:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 708:	feb40713          	addi	a4,s0,-21
 70c:	fec42783          	lw	a5,-20(s0)
 710:	4605                	li	a2,1
 712:	85ba                	mv	a1,a4
 714:	853e                	mv	a0,a5
 716:	00000097          	auipc	ra,0x0
 71a:	f54080e7          	jalr	-172(ra) # 66a <write>
}
 71e:	0001                	nop
 720:	60e2                	ld	ra,24(sp)
 722:	6442                	ld	s0,16(sp)
 724:	6105                	addi	sp,sp,32
 726:	8082                	ret

0000000000000728 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 728:	7139                	addi	sp,sp,-64
 72a:	fc06                	sd	ra,56(sp)
 72c:	f822                	sd	s0,48(sp)
 72e:	0080                	addi	s0,sp,64
 730:	87aa                	mv	a5,a0
 732:	8736                	mv	a4,a3
 734:	fcf42623          	sw	a5,-52(s0)
 738:	87ae                	mv	a5,a1
 73a:	fcf42423          	sw	a5,-56(s0)
 73e:	87b2                	mv	a5,a2
 740:	fcf42223          	sw	a5,-60(s0)
 744:	87ba                	mv	a5,a4
 746:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 74a:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 74e:	fc042783          	lw	a5,-64(s0)
 752:	2781                	sext.w	a5,a5
 754:	c38d                	beqz	a5,776 <printint+0x4e>
 756:	fc842783          	lw	a5,-56(s0)
 75a:	2781                	sext.w	a5,a5
 75c:	0007dd63          	bgez	a5,776 <printint+0x4e>
    neg = 1;
 760:	4785                	li	a5,1
 762:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 766:	fc842783          	lw	a5,-56(s0)
 76a:	40f007bb          	negw	a5,a5
 76e:	2781                	sext.w	a5,a5
 770:	fef42223          	sw	a5,-28(s0)
 774:	a029                	j	77e <printint+0x56>
  } else {
    x = xx;
 776:	fc842783          	lw	a5,-56(s0)
 77a:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 77e:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 782:	fc442783          	lw	a5,-60(s0)
 786:	fe442703          	lw	a4,-28(s0)
 78a:	02f777bb          	remuw	a5,a4,a5
 78e:	0007871b          	sext.w	a4,a5
 792:	fec42783          	lw	a5,-20(s0)
 796:	0017869b          	addiw	a3,a5,1
 79a:	fed42623          	sw	a3,-20(s0)
 79e:	00001697          	auipc	a3,0x1
 7a2:	86268693          	addi	a3,a3,-1950 # 1000 <digits>
 7a6:	1702                	slli	a4,a4,0x20
 7a8:	9301                	srli	a4,a4,0x20
 7aa:	9736                	add	a4,a4,a3
 7ac:	00074703          	lbu	a4,0(a4)
 7b0:	17c1                	addi	a5,a5,-16
 7b2:	97a2                	add	a5,a5,s0
 7b4:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 7b8:	fc442783          	lw	a5,-60(s0)
 7bc:	fe442703          	lw	a4,-28(s0)
 7c0:	02f757bb          	divuw	a5,a4,a5
 7c4:	fef42223          	sw	a5,-28(s0)
 7c8:	fe442783          	lw	a5,-28(s0)
 7cc:	2781                	sext.w	a5,a5
 7ce:	fbd5                	bnez	a5,782 <printint+0x5a>
  if(neg)
 7d0:	fe842783          	lw	a5,-24(s0)
 7d4:	2781                	sext.w	a5,a5
 7d6:	cf85                	beqz	a5,80e <printint+0xe6>
    buf[i++] = '-';
 7d8:	fec42783          	lw	a5,-20(s0)
 7dc:	0017871b          	addiw	a4,a5,1
 7e0:	fee42623          	sw	a4,-20(s0)
 7e4:	17c1                	addi	a5,a5,-16
 7e6:	97a2                	add	a5,a5,s0
 7e8:	02d00713          	li	a4,45
 7ec:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 7f0:	a839                	j	80e <printint+0xe6>
    putc(fd, buf[i]);
 7f2:	fec42783          	lw	a5,-20(s0)
 7f6:	17c1                	addi	a5,a5,-16
 7f8:	97a2                	add	a5,a5,s0
 7fa:	fe07c703          	lbu	a4,-32(a5)
 7fe:	fcc42783          	lw	a5,-52(s0)
 802:	85ba                	mv	a1,a4
 804:	853e                	mv	a0,a5
 806:	00000097          	auipc	ra,0x0
 80a:	eec080e7          	jalr	-276(ra) # 6f2 <putc>
  while(--i >= 0)
 80e:	fec42783          	lw	a5,-20(s0)
 812:	37fd                	addiw	a5,a5,-1
 814:	fef42623          	sw	a5,-20(s0)
 818:	fec42783          	lw	a5,-20(s0)
 81c:	2781                	sext.w	a5,a5
 81e:	fc07dae3          	bgez	a5,7f2 <printint+0xca>
}
 822:	0001                	nop
 824:	0001                	nop
 826:	70e2                	ld	ra,56(sp)
 828:	7442                	ld	s0,48(sp)
 82a:	6121                	addi	sp,sp,64
 82c:	8082                	ret

000000000000082e <printptr>:

static void
printptr(int fd, uint64 x) {
 82e:	7179                	addi	sp,sp,-48
 830:	f406                	sd	ra,40(sp)
 832:	f022                	sd	s0,32(sp)
 834:	1800                	addi	s0,sp,48
 836:	87aa                	mv	a5,a0
 838:	fcb43823          	sd	a1,-48(s0)
 83c:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 840:	fdc42783          	lw	a5,-36(s0)
 844:	03000593          	li	a1,48
 848:	853e                	mv	a0,a5
 84a:	00000097          	auipc	ra,0x0
 84e:	ea8080e7          	jalr	-344(ra) # 6f2 <putc>
  putc(fd, 'x');
 852:	fdc42783          	lw	a5,-36(s0)
 856:	07800593          	li	a1,120
 85a:	853e                	mv	a0,a5
 85c:	00000097          	auipc	ra,0x0
 860:	e96080e7          	jalr	-362(ra) # 6f2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 864:	fe042623          	sw	zero,-20(s0)
 868:	a82d                	j	8a2 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 86a:	fd043783          	ld	a5,-48(s0)
 86e:	93f1                	srli	a5,a5,0x3c
 870:	00000717          	auipc	a4,0x0
 874:	79070713          	addi	a4,a4,1936 # 1000 <digits>
 878:	97ba                	add	a5,a5,a4
 87a:	0007c703          	lbu	a4,0(a5)
 87e:	fdc42783          	lw	a5,-36(s0)
 882:	85ba                	mv	a1,a4
 884:	853e                	mv	a0,a5
 886:	00000097          	auipc	ra,0x0
 88a:	e6c080e7          	jalr	-404(ra) # 6f2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 88e:	fec42783          	lw	a5,-20(s0)
 892:	2785                	addiw	a5,a5,1
 894:	fef42623          	sw	a5,-20(s0)
 898:	fd043783          	ld	a5,-48(s0)
 89c:	0792                	slli	a5,a5,0x4
 89e:	fcf43823          	sd	a5,-48(s0)
 8a2:	fec42703          	lw	a4,-20(s0)
 8a6:	47bd                	li	a5,15
 8a8:	fce7f1e3          	bgeu	a5,a4,86a <printptr+0x3c>
}
 8ac:	0001                	nop
 8ae:	0001                	nop
 8b0:	70a2                	ld	ra,40(sp)
 8b2:	7402                	ld	s0,32(sp)
 8b4:	6145                	addi	sp,sp,48
 8b6:	8082                	ret

00000000000008b8 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 8b8:	715d                	addi	sp,sp,-80
 8ba:	e486                	sd	ra,72(sp)
 8bc:	e0a2                	sd	s0,64(sp)
 8be:	0880                	addi	s0,sp,80
 8c0:	87aa                	mv	a5,a0
 8c2:	fcb43023          	sd	a1,-64(s0)
 8c6:	fac43c23          	sd	a2,-72(s0)
 8ca:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 8ce:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 8d2:	fe042223          	sw	zero,-28(s0)
 8d6:	a42d                	j	b00 <vprintf+0x248>
    c = fmt[i] & 0xff;
 8d8:	fe442783          	lw	a5,-28(s0)
 8dc:	fc043703          	ld	a4,-64(s0)
 8e0:	97ba                	add	a5,a5,a4
 8e2:	0007c783          	lbu	a5,0(a5)
 8e6:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 8ea:	fe042783          	lw	a5,-32(s0)
 8ee:	2781                	sext.w	a5,a5
 8f0:	eb9d                	bnez	a5,926 <vprintf+0x6e>
      if(c == '%'){
 8f2:	fdc42783          	lw	a5,-36(s0)
 8f6:	0007871b          	sext.w	a4,a5
 8fa:	02500793          	li	a5,37
 8fe:	00f71763          	bne	a4,a5,90c <vprintf+0x54>
        state = '%';
 902:	02500793          	li	a5,37
 906:	fef42023          	sw	a5,-32(s0)
 90a:	a2f5                	j	af6 <vprintf+0x23e>
      } else {
        putc(fd, c);
 90c:	fdc42783          	lw	a5,-36(s0)
 910:	0ff7f713          	zext.b	a4,a5
 914:	fcc42783          	lw	a5,-52(s0)
 918:	85ba                	mv	a1,a4
 91a:	853e                	mv	a0,a5
 91c:	00000097          	auipc	ra,0x0
 920:	dd6080e7          	jalr	-554(ra) # 6f2 <putc>
 924:	aac9                	j	af6 <vprintf+0x23e>
      }
    } else if(state == '%'){
 926:	fe042783          	lw	a5,-32(s0)
 92a:	0007871b          	sext.w	a4,a5
 92e:	02500793          	li	a5,37
 932:	1cf71263          	bne	a4,a5,af6 <vprintf+0x23e>
      if(c == 'd'){
 936:	fdc42783          	lw	a5,-36(s0)
 93a:	0007871b          	sext.w	a4,a5
 93e:	06400793          	li	a5,100
 942:	02f71463          	bne	a4,a5,96a <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 946:	fb843783          	ld	a5,-72(s0)
 94a:	00878713          	addi	a4,a5,8
 94e:	fae43c23          	sd	a4,-72(s0)
 952:	4398                	lw	a4,0(a5)
 954:	fcc42783          	lw	a5,-52(s0)
 958:	4685                	li	a3,1
 95a:	4629                	li	a2,10
 95c:	85ba                	mv	a1,a4
 95e:	853e                	mv	a0,a5
 960:	00000097          	auipc	ra,0x0
 964:	dc8080e7          	jalr	-568(ra) # 728 <printint>
 968:	a269                	j	af2 <vprintf+0x23a>
      } else if(c == 'l') {
 96a:	fdc42783          	lw	a5,-36(s0)
 96e:	0007871b          	sext.w	a4,a5
 972:	06c00793          	li	a5,108
 976:	02f71663          	bne	a4,a5,9a2 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 97a:	fb843783          	ld	a5,-72(s0)
 97e:	00878713          	addi	a4,a5,8
 982:	fae43c23          	sd	a4,-72(s0)
 986:	639c                	ld	a5,0(a5)
 988:	0007871b          	sext.w	a4,a5
 98c:	fcc42783          	lw	a5,-52(s0)
 990:	4681                	li	a3,0
 992:	4629                	li	a2,10
 994:	85ba                	mv	a1,a4
 996:	853e                	mv	a0,a5
 998:	00000097          	auipc	ra,0x0
 99c:	d90080e7          	jalr	-624(ra) # 728 <printint>
 9a0:	aa89                	j	af2 <vprintf+0x23a>
      } else if(c == 'x') {
 9a2:	fdc42783          	lw	a5,-36(s0)
 9a6:	0007871b          	sext.w	a4,a5
 9aa:	07800793          	li	a5,120
 9ae:	02f71463          	bne	a4,a5,9d6 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 9b2:	fb843783          	ld	a5,-72(s0)
 9b6:	00878713          	addi	a4,a5,8
 9ba:	fae43c23          	sd	a4,-72(s0)
 9be:	4398                	lw	a4,0(a5)
 9c0:	fcc42783          	lw	a5,-52(s0)
 9c4:	4681                	li	a3,0
 9c6:	4641                	li	a2,16
 9c8:	85ba                	mv	a1,a4
 9ca:	853e                	mv	a0,a5
 9cc:	00000097          	auipc	ra,0x0
 9d0:	d5c080e7          	jalr	-676(ra) # 728 <printint>
 9d4:	aa39                	j	af2 <vprintf+0x23a>
      } else if(c == 'p') {
 9d6:	fdc42783          	lw	a5,-36(s0)
 9da:	0007871b          	sext.w	a4,a5
 9de:	07000793          	li	a5,112
 9e2:	02f71263          	bne	a4,a5,a06 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 9e6:	fb843783          	ld	a5,-72(s0)
 9ea:	00878713          	addi	a4,a5,8
 9ee:	fae43c23          	sd	a4,-72(s0)
 9f2:	6398                	ld	a4,0(a5)
 9f4:	fcc42783          	lw	a5,-52(s0)
 9f8:	85ba                	mv	a1,a4
 9fa:	853e                	mv	a0,a5
 9fc:	00000097          	auipc	ra,0x0
 a00:	e32080e7          	jalr	-462(ra) # 82e <printptr>
 a04:	a0fd                	j	af2 <vprintf+0x23a>
      } else if(c == 's'){
 a06:	fdc42783          	lw	a5,-36(s0)
 a0a:	0007871b          	sext.w	a4,a5
 a0e:	07300793          	li	a5,115
 a12:	04f71c63          	bne	a4,a5,a6a <vprintf+0x1b2>
        s = va_arg(ap, char*);
 a16:	fb843783          	ld	a5,-72(s0)
 a1a:	00878713          	addi	a4,a5,8
 a1e:	fae43c23          	sd	a4,-72(s0)
 a22:	639c                	ld	a5,0(a5)
 a24:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 a28:	fe843783          	ld	a5,-24(s0)
 a2c:	eb8d                	bnez	a5,a5e <vprintf+0x1a6>
          s = "(null)";
 a2e:	00000797          	auipc	a5,0x0
 a32:	4ca78793          	addi	a5,a5,1226 # ef8 <malloc+0x18e>
 a36:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 a3a:	a015                	j	a5e <vprintf+0x1a6>
          putc(fd, *s);
 a3c:	fe843783          	ld	a5,-24(s0)
 a40:	0007c703          	lbu	a4,0(a5)
 a44:	fcc42783          	lw	a5,-52(s0)
 a48:	85ba                	mv	a1,a4
 a4a:	853e                	mv	a0,a5
 a4c:	00000097          	auipc	ra,0x0
 a50:	ca6080e7          	jalr	-858(ra) # 6f2 <putc>
          s++;
 a54:	fe843783          	ld	a5,-24(s0)
 a58:	0785                	addi	a5,a5,1
 a5a:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 a5e:	fe843783          	ld	a5,-24(s0)
 a62:	0007c783          	lbu	a5,0(a5)
 a66:	fbf9                	bnez	a5,a3c <vprintf+0x184>
 a68:	a069                	j	af2 <vprintf+0x23a>
        }
      } else if(c == 'c'){
 a6a:	fdc42783          	lw	a5,-36(s0)
 a6e:	0007871b          	sext.w	a4,a5
 a72:	06300793          	li	a5,99
 a76:	02f71463          	bne	a4,a5,a9e <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 a7a:	fb843783          	ld	a5,-72(s0)
 a7e:	00878713          	addi	a4,a5,8
 a82:	fae43c23          	sd	a4,-72(s0)
 a86:	439c                	lw	a5,0(a5)
 a88:	0ff7f713          	zext.b	a4,a5
 a8c:	fcc42783          	lw	a5,-52(s0)
 a90:	85ba                	mv	a1,a4
 a92:	853e                	mv	a0,a5
 a94:	00000097          	auipc	ra,0x0
 a98:	c5e080e7          	jalr	-930(ra) # 6f2 <putc>
 a9c:	a899                	j	af2 <vprintf+0x23a>
      } else if(c == '%'){
 a9e:	fdc42783          	lw	a5,-36(s0)
 aa2:	0007871b          	sext.w	a4,a5
 aa6:	02500793          	li	a5,37
 aaa:	00f71f63          	bne	a4,a5,ac8 <vprintf+0x210>
        putc(fd, c);
 aae:	fdc42783          	lw	a5,-36(s0)
 ab2:	0ff7f713          	zext.b	a4,a5
 ab6:	fcc42783          	lw	a5,-52(s0)
 aba:	85ba                	mv	a1,a4
 abc:	853e                	mv	a0,a5
 abe:	00000097          	auipc	ra,0x0
 ac2:	c34080e7          	jalr	-972(ra) # 6f2 <putc>
 ac6:	a035                	j	af2 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 ac8:	fcc42783          	lw	a5,-52(s0)
 acc:	02500593          	li	a1,37
 ad0:	853e                	mv	a0,a5
 ad2:	00000097          	auipc	ra,0x0
 ad6:	c20080e7          	jalr	-992(ra) # 6f2 <putc>
        putc(fd, c);
 ada:	fdc42783          	lw	a5,-36(s0)
 ade:	0ff7f713          	zext.b	a4,a5
 ae2:	fcc42783          	lw	a5,-52(s0)
 ae6:	85ba                	mv	a1,a4
 ae8:	853e                	mv	a0,a5
 aea:	00000097          	auipc	ra,0x0
 aee:	c08080e7          	jalr	-1016(ra) # 6f2 <putc>
      }
      state = 0;
 af2:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 af6:	fe442783          	lw	a5,-28(s0)
 afa:	2785                	addiw	a5,a5,1
 afc:	fef42223          	sw	a5,-28(s0)
 b00:	fe442783          	lw	a5,-28(s0)
 b04:	fc043703          	ld	a4,-64(s0)
 b08:	97ba                	add	a5,a5,a4
 b0a:	0007c783          	lbu	a5,0(a5)
 b0e:	dc0795e3          	bnez	a5,8d8 <vprintf+0x20>
    }
  }
}
 b12:	0001                	nop
 b14:	0001                	nop
 b16:	60a6                	ld	ra,72(sp)
 b18:	6406                	ld	s0,64(sp)
 b1a:	6161                	addi	sp,sp,80
 b1c:	8082                	ret

0000000000000b1e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b1e:	7159                	addi	sp,sp,-112
 b20:	fc06                	sd	ra,56(sp)
 b22:	f822                	sd	s0,48(sp)
 b24:	0080                	addi	s0,sp,64
 b26:	fcb43823          	sd	a1,-48(s0)
 b2a:	e010                	sd	a2,0(s0)
 b2c:	e414                	sd	a3,8(s0)
 b2e:	e818                	sd	a4,16(s0)
 b30:	ec1c                	sd	a5,24(s0)
 b32:	03043023          	sd	a6,32(s0)
 b36:	03143423          	sd	a7,40(s0)
 b3a:	87aa                	mv	a5,a0
 b3c:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 b40:	03040793          	addi	a5,s0,48
 b44:	fcf43423          	sd	a5,-56(s0)
 b48:	fc843783          	ld	a5,-56(s0)
 b4c:	fd078793          	addi	a5,a5,-48
 b50:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 b54:	fe843703          	ld	a4,-24(s0)
 b58:	fdc42783          	lw	a5,-36(s0)
 b5c:	863a                	mv	a2,a4
 b5e:	fd043583          	ld	a1,-48(s0)
 b62:	853e                	mv	a0,a5
 b64:	00000097          	auipc	ra,0x0
 b68:	d54080e7          	jalr	-684(ra) # 8b8 <vprintf>
}
 b6c:	0001                	nop
 b6e:	70e2                	ld	ra,56(sp)
 b70:	7442                	ld	s0,48(sp)
 b72:	6165                	addi	sp,sp,112
 b74:	8082                	ret

0000000000000b76 <printf>:

void
printf(const char *fmt, ...)
{
 b76:	7159                	addi	sp,sp,-112
 b78:	f406                	sd	ra,40(sp)
 b7a:	f022                	sd	s0,32(sp)
 b7c:	1800                	addi	s0,sp,48
 b7e:	fca43c23          	sd	a0,-40(s0)
 b82:	e40c                	sd	a1,8(s0)
 b84:	e810                	sd	a2,16(s0)
 b86:	ec14                	sd	a3,24(s0)
 b88:	f018                	sd	a4,32(s0)
 b8a:	f41c                	sd	a5,40(s0)
 b8c:	03043823          	sd	a6,48(s0)
 b90:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b94:	04040793          	addi	a5,s0,64
 b98:	fcf43823          	sd	a5,-48(s0)
 b9c:	fd043783          	ld	a5,-48(s0)
 ba0:	fc878793          	addi	a5,a5,-56
 ba4:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 ba8:	fe843783          	ld	a5,-24(s0)
 bac:	863e                	mv	a2,a5
 bae:	fd843583          	ld	a1,-40(s0)
 bb2:	4505                	li	a0,1
 bb4:	00000097          	auipc	ra,0x0
 bb8:	d04080e7          	jalr	-764(ra) # 8b8 <vprintf>
}
 bbc:	0001                	nop
 bbe:	70a2                	ld	ra,40(sp)
 bc0:	7402                	ld	s0,32(sp)
 bc2:	6165                	addi	sp,sp,112
 bc4:	8082                	ret

0000000000000bc6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 bc6:	7179                	addi	sp,sp,-48
 bc8:	f406                	sd	ra,40(sp)
 bca:	f022                	sd	s0,32(sp)
 bcc:	1800                	addi	s0,sp,48
 bce:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 bd2:	fd843783          	ld	a5,-40(s0)
 bd6:	17c1                	addi	a5,a5,-16
 bd8:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bdc:	00000797          	auipc	a5,0x0
 be0:	65478793          	addi	a5,a5,1620 # 1230 <freep>
 be4:	639c                	ld	a5,0(a5)
 be6:	fef43423          	sd	a5,-24(s0)
 bea:	a815                	j	c1e <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bec:	fe843783          	ld	a5,-24(s0)
 bf0:	639c                	ld	a5,0(a5)
 bf2:	fe843703          	ld	a4,-24(s0)
 bf6:	00f76f63          	bltu	a4,a5,c14 <free+0x4e>
 bfa:	fe043703          	ld	a4,-32(s0)
 bfe:	fe843783          	ld	a5,-24(s0)
 c02:	02e7eb63          	bltu	a5,a4,c38 <free+0x72>
 c06:	fe843783          	ld	a5,-24(s0)
 c0a:	639c                	ld	a5,0(a5)
 c0c:	fe043703          	ld	a4,-32(s0)
 c10:	02f76463          	bltu	a4,a5,c38 <free+0x72>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c14:	fe843783          	ld	a5,-24(s0)
 c18:	639c                	ld	a5,0(a5)
 c1a:	fef43423          	sd	a5,-24(s0)
 c1e:	fe043703          	ld	a4,-32(s0)
 c22:	fe843783          	ld	a5,-24(s0)
 c26:	fce7f3e3          	bgeu	a5,a4,bec <free+0x26>
 c2a:	fe843783          	ld	a5,-24(s0)
 c2e:	639c                	ld	a5,0(a5)
 c30:	fe043703          	ld	a4,-32(s0)
 c34:	faf77ce3          	bgeu	a4,a5,bec <free+0x26>
      break;
  if(bp + bp->s.size == p->s.ptr){
 c38:	fe043783          	ld	a5,-32(s0)
 c3c:	479c                	lw	a5,8(a5)
 c3e:	1782                	slli	a5,a5,0x20
 c40:	9381                	srli	a5,a5,0x20
 c42:	0792                	slli	a5,a5,0x4
 c44:	fe043703          	ld	a4,-32(s0)
 c48:	973e                	add	a4,a4,a5
 c4a:	fe843783          	ld	a5,-24(s0)
 c4e:	639c                	ld	a5,0(a5)
 c50:	02f71763          	bne	a4,a5,c7e <free+0xb8>
    bp->s.size += p->s.ptr->s.size;
 c54:	fe043783          	ld	a5,-32(s0)
 c58:	4798                	lw	a4,8(a5)
 c5a:	fe843783          	ld	a5,-24(s0)
 c5e:	639c                	ld	a5,0(a5)
 c60:	479c                	lw	a5,8(a5)
 c62:	9fb9                	addw	a5,a5,a4
 c64:	0007871b          	sext.w	a4,a5
 c68:	fe043783          	ld	a5,-32(s0)
 c6c:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 c6e:	fe843783          	ld	a5,-24(s0)
 c72:	639c                	ld	a5,0(a5)
 c74:	6398                	ld	a4,0(a5)
 c76:	fe043783          	ld	a5,-32(s0)
 c7a:	e398                	sd	a4,0(a5)
 c7c:	a039                	j	c8a <free+0xc4>
  } else
    bp->s.ptr = p->s.ptr;
 c7e:	fe843783          	ld	a5,-24(s0)
 c82:	6398                	ld	a4,0(a5)
 c84:	fe043783          	ld	a5,-32(s0)
 c88:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 c8a:	fe843783          	ld	a5,-24(s0)
 c8e:	479c                	lw	a5,8(a5)
 c90:	1782                	slli	a5,a5,0x20
 c92:	9381                	srli	a5,a5,0x20
 c94:	0792                	slli	a5,a5,0x4
 c96:	fe843703          	ld	a4,-24(s0)
 c9a:	97ba                	add	a5,a5,a4
 c9c:	fe043703          	ld	a4,-32(s0)
 ca0:	02f71563          	bne	a4,a5,cca <free+0x104>
    p->s.size += bp->s.size;
 ca4:	fe843783          	ld	a5,-24(s0)
 ca8:	4798                	lw	a4,8(a5)
 caa:	fe043783          	ld	a5,-32(s0)
 cae:	479c                	lw	a5,8(a5)
 cb0:	9fb9                	addw	a5,a5,a4
 cb2:	0007871b          	sext.w	a4,a5
 cb6:	fe843783          	ld	a5,-24(s0)
 cba:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 cbc:	fe043783          	ld	a5,-32(s0)
 cc0:	6398                	ld	a4,0(a5)
 cc2:	fe843783          	ld	a5,-24(s0)
 cc6:	e398                	sd	a4,0(a5)
 cc8:	a031                	j	cd4 <free+0x10e>
  } else
    p->s.ptr = bp;
 cca:	fe843783          	ld	a5,-24(s0)
 cce:	fe043703          	ld	a4,-32(s0)
 cd2:	e398                	sd	a4,0(a5)
  freep = p;
 cd4:	00000797          	auipc	a5,0x0
 cd8:	55c78793          	addi	a5,a5,1372 # 1230 <freep>
 cdc:	fe843703          	ld	a4,-24(s0)
 ce0:	e398                	sd	a4,0(a5)
}
 ce2:	0001                	nop
 ce4:	70a2                	ld	ra,40(sp)
 ce6:	7402                	ld	s0,32(sp)
 ce8:	6145                	addi	sp,sp,48
 cea:	8082                	ret

0000000000000cec <morecore>:

static Header*
morecore(uint nu)
{
 cec:	7179                	addi	sp,sp,-48
 cee:	f406                	sd	ra,40(sp)
 cf0:	f022                	sd	s0,32(sp)
 cf2:	1800                	addi	s0,sp,48
 cf4:	87aa                	mv	a5,a0
 cf6:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 cfa:	fdc42783          	lw	a5,-36(s0)
 cfe:	0007871b          	sext.w	a4,a5
 d02:	6785                	lui	a5,0x1
 d04:	00f77563          	bgeu	a4,a5,d0e <morecore+0x22>
    nu = 4096;
 d08:	6785                	lui	a5,0x1
 d0a:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 d0e:	fdc42783          	lw	a5,-36(s0)
 d12:	0047979b          	slliw	a5,a5,0x4
 d16:	2781                	sext.w	a5,a5
 d18:	853e                	mv	a0,a5
 d1a:	00000097          	auipc	ra,0x0
 d1e:	9b8080e7          	jalr	-1608(ra) # 6d2 <sbrk>
 d22:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 d26:	fe843703          	ld	a4,-24(s0)
 d2a:	57fd                	li	a5,-1
 d2c:	00f71463          	bne	a4,a5,d34 <morecore+0x48>
    return 0;
 d30:	4781                	li	a5,0
 d32:	a03d                	j	d60 <morecore+0x74>
  hp = (Header*)p;
 d34:	fe843783          	ld	a5,-24(s0)
 d38:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 d3c:	fe043783          	ld	a5,-32(s0)
 d40:	fdc42703          	lw	a4,-36(s0)
 d44:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 d46:	fe043783          	ld	a5,-32(s0)
 d4a:	07c1                	addi	a5,a5,16 # 1010 <digits+0x10>
 d4c:	853e                	mv	a0,a5
 d4e:	00000097          	auipc	ra,0x0
 d52:	e78080e7          	jalr	-392(ra) # bc6 <free>
  return freep;
 d56:	00000797          	auipc	a5,0x0
 d5a:	4da78793          	addi	a5,a5,1242 # 1230 <freep>
 d5e:	639c                	ld	a5,0(a5)
}
 d60:	853e                	mv	a0,a5
 d62:	70a2                	ld	ra,40(sp)
 d64:	7402                	ld	s0,32(sp)
 d66:	6145                	addi	sp,sp,48
 d68:	8082                	ret

0000000000000d6a <malloc>:

void*
malloc(uint nbytes)
{
 d6a:	7139                	addi	sp,sp,-64
 d6c:	fc06                	sd	ra,56(sp)
 d6e:	f822                	sd	s0,48(sp)
 d70:	0080                	addi	s0,sp,64
 d72:	87aa                	mv	a5,a0
 d74:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d78:	fcc46783          	lwu	a5,-52(s0)
 d7c:	07bd                	addi	a5,a5,15
 d7e:	8391                	srli	a5,a5,0x4
 d80:	2781                	sext.w	a5,a5
 d82:	2785                	addiw	a5,a5,1
 d84:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 d88:	00000797          	auipc	a5,0x0
 d8c:	4a878793          	addi	a5,a5,1192 # 1230 <freep>
 d90:	639c                	ld	a5,0(a5)
 d92:	fef43023          	sd	a5,-32(s0)
 d96:	fe043783          	ld	a5,-32(s0)
 d9a:	ef95                	bnez	a5,dd6 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 d9c:	00000797          	auipc	a5,0x0
 da0:	48478793          	addi	a5,a5,1156 # 1220 <base>
 da4:	fef43023          	sd	a5,-32(s0)
 da8:	00000797          	auipc	a5,0x0
 dac:	48878793          	addi	a5,a5,1160 # 1230 <freep>
 db0:	fe043703          	ld	a4,-32(s0)
 db4:	e398                	sd	a4,0(a5)
 db6:	00000797          	auipc	a5,0x0
 dba:	47a78793          	addi	a5,a5,1146 # 1230 <freep>
 dbe:	6398                	ld	a4,0(a5)
 dc0:	00000797          	auipc	a5,0x0
 dc4:	46078793          	addi	a5,a5,1120 # 1220 <base>
 dc8:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 dca:	00000797          	auipc	a5,0x0
 dce:	45678793          	addi	a5,a5,1110 # 1220 <base>
 dd2:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 dd6:	fe043783          	ld	a5,-32(s0)
 dda:	639c                	ld	a5,0(a5)
 ddc:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 de0:	fe843783          	ld	a5,-24(s0)
 de4:	479c                	lw	a5,8(a5)
 de6:	fdc42703          	lw	a4,-36(s0)
 dea:	2701                	sext.w	a4,a4
 dec:	06e7e763          	bltu	a5,a4,e5a <malloc+0xf0>
      if(p->s.size == nunits)
 df0:	fe843783          	ld	a5,-24(s0)
 df4:	479c                	lw	a5,8(a5)
 df6:	fdc42703          	lw	a4,-36(s0)
 dfa:	2701                	sext.w	a4,a4
 dfc:	00f71963          	bne	a4,a5,e0e <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 e00:	fe843783          	ld	a5,-24(s0)
 e04:	6398                	ld	a4,0(a5)
 e06:	fe043783          	ld	a5,-32(s0)
 e0a:	e398                	sd	a4,0(a5)
 e0c:	a825                	j	e44 <malloc+0xda>
      else {
        p->s.size -= nunits;
 e0e:	fe843783          	ld	a5,-24(s0)
 e12:	479c                	lw	a5,8(a5)
 e14:	fdc42703          	lw	a4,-36(s0)
 e18:	9f99                	subw	a5,a5,a4
 e1a:	0007871b          	sext.w	a4,a5
 e1e:	fe843783          	ld	a5,-24(s0)
 e22:	c798                	sw	a4,8(a5)
        p += p->s.size;
 e24:	fe843783          	ld	a5,-24(s0)
 e28:	479c                	lw	a5,8(a5)
 e2a:	1782                	slli	a5,a5,0x20
 e2c:	9381                	srli	a5,a5,0x20
 e2e:	0792                	slli	a5,a5,0x4
 e30:	fe843703          	ld	a4,-24(s0)
 e34:	97ba                	add	a5,a5,a4
 e36:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 e3a:	fe843783          	ld	a5,-24(s0)
 e3e:	fdc42703          	lw	a4,-36(s0)
 e42:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 e44:	00000797          	auipc	a5,0x0
 e48:	3ec78793          	addi	a5,a5,1004 # 1230 <freep>
 e4c:	fe043703          	ld	a4,-32(s0)
 e50:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 e52:	fe843783          	ld	a5,-24(s0)
 e56:	07c1                	addi	a5,a5,16
 e58:	a091                	j	e9c <malloc+0x132>
    }
    if(p == freep)
 e5a:	00000797          	auipc	a5,0x0
 e5e:	3d678793          	addi	a5,a5,982 # 1230 <freep>
 e62:	639c                	ld	a5,0(a5)
 e64:	fe843703          	ld	a4,-24(s0)
 e68:	02f71063          	bne	a4,a5,e88 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 e6c:	fdc42783          	lw	a5,-36(s0)
 e70:	853e                	mv	a0,a5
 e72:	00000097          	auipc	ra,0x0
 e76:	e7a080e7          	jalr	-390(ra) # cec <morecore>
 e7a:	fea43423          	sd	a0,-24(s0)
 e7e:	fe843783          	ld	a5,-24(s0)
 e82:	e399                	bnez	a5,e88 <malloc+0x11e>
        return 0;
 e84:	4781                	li	a5,0
 e86:	a819                	j	e9c <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e88:	fe843783          	ld	a5,-24(s0)
 e8c:	fef43023          	sd	a5,-32(s0)
 e90:	fe843783          	ld	a5,-24(s0)
 e94:	639c                	ld	a5,0(a5)
 e96:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 e9a:	b799                	j	de0 <malloc+0x76>
  }
}
 e9c:	853e                	mv	a0,a5
 e9e:	70e2                	ld	ra,56(sp)
 ea0:	7442                	ld	s0,48(sp)
 ea2:	6121                	addi	sp,sp,64
 ea4:	8082                	ret
