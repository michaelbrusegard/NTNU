
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
  3a:	e6a58593          	addi	a1,a1,-406 # ea0 <malloc+0x13e>
  3e:	4509                	li	a0,2
  40:	00001097          	auipc	ra,0x1
  44:	ad6080e7          	jalr	-1322(ra) # b16 <fprintf>
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
  8a:	e3258593          	addi	a1,a1,-462 # eb8 <malloc+0x156>
  8e:	4509                	li	a0,2
  90:	00001097          	auipc	ra,0x1
  94:	a86080e7          	jalr	-1402(ra) # b16 <fprintf>
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
 126:	dae58593          	addi	a1,a1,-594 # ed0 <malloc+0x16e>
 12a:	4509                	li	a0,2
 12c:	00001097          	auipc	ra,0x1
 130:	9ea080e7          	jalr	-1558(ra) # b16 <fprintf>
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

00000000000006ea <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6ea:	1101                	addi	sp,sp,-32
 6ec:	ec06                	sd	ra,24(sp)
 6ee:	e822                	sd	s0,16(sp)
 6f0:	1000                	addi	s0,sp,32
 6f2:	87aa                	mv	a5,a0
 6f4:	872e                	mv	a4,a1
 6f6:	fef42623          	sw	a5,-20(s0)
 6fa:	87ba                	mv	a5,a4
 6fc:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 700:	feb40713          	addi	a4,s0,-21
 704:	fec42783          	lw	a5,-20(s0)
 708:	4605                	li	a2,1
 70a:	85ba                	mv	a1,a4
 70c:	853e                	mv	a0,a5
 70e:	00000097          	auipc	ra,0x0
 712:	f5c080e7          	jalr	-164(ra) # 66a <write>
}
 716:	0001                	nop
 718:	60e2                	ld	ra,24(sp)
 71a:	6442                	ld	s0,16(sp)
 71c:	6105                	addi	sp,sp,32
 71e:	8082                	ret

0000000000000720 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 720:	7139                	addi	sp,sp,-64
 722:	fc06                	sd	ra,56(sp)
 724:	f822                	sd	s0,48(sp)
 726:	0080                	addi	s0,sp,64
 728:	87aa                	mv	a5,a0
 72a:	8736                	mv	a4,a3
 72c:	fcf42623          	sw	a5,-52(s0)
 730:	87ae                	mv	a5,a1
 732:	fcf42423          	sw	a5,-56(s0)
 736:	87b2                	mv	a5,a2
 738:	fcf42223          	sw	a5,-60(s0)
 73c:	87ba                	mv	a5,a4
 73e:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 742:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 746:	fc042783          	lw	a5,-64(s0)
 74a:	2781                	sext.w	a5,a5
 74c:	c38d                	beqz	a5,76e <printint+0x4e>
 74e:	fc842783          	lw	a5,-56(s0)
 752:	2781                	sext.w	a5,a5
 754:	0007dd63          	bgez	a5,76e <printint+0x4e>
    neg = 1;
 758:	4785                	li	a5,1
 75a:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 75e:	fc842783          	lw	a5,-56(s0)
 762:	40f007bb          	negw	a5,a5
 766:	2781                	sext.w	a5,a5
 768:	fef42223          	sw	a5,-28(s0)
 76c:	a029                	j	776 <printint+0x56>
  } else {
    x = xx;
 76e:	fc842783          	lw	a5,-56(s0)
 772:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 776:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 77a:	fc442783          	lw	a5,-60(s0)
 77e:	fe442703          	lw	a4,-28(s0)
 782:	02f777bb          	remuw	a5,a4,a5
 786:	0007871b          	sext.w	a4,a5
 78a:	fec42783          	lw	a5,-20(s0)
 78e:	0017869b          	addiw	a3,a5,1
 792:	fed42623          	sw	a3,-20(s0)
 796:	00001697          	auipc	a3,0x1
 79a:	86a68693          	addi	a3,a3,-1942 # 1000 <digits>
 79e:	1702                	slli	a4,a4,0x20
 7a0:	9301                	srli	a4,a4,0x20
 7a2:	9736                	add	a4,a4,a3
 7a4:	00074703          	lbu	a4,0(a4)
 7a8:	17c1                	addi	a5,a5,-16
 7aa:	97a2                	add	a5,a5,s0
 7ac:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 7b0:	fc442783          	lw	a5,-60(s0)
 7b4:	fe442703          	lw	a4,-28(s0)
 7b8:	02f757bb          	divuw	a5,a4,a5
 7bc:	fef42223          	sw	a5,-28(s0)
 7c0:	fe442783          	lw	a5,-28(s0)
 7c4:	2781                	sext.w	a5,a5
 7c6:	fbd5                	bnez	a5,77a <printint+0x5a>
  if(neg)
 7c8:	fe842783          	lw	a5,-24(s0)
 7cc:	2781                	sext.w	a5,a5
 7ce:	cf85                	beqz	a5,806 <printint+0xe6>
    buf[i++] = '-';
 7d0:	fec42783          	lw	a5,-20(s0)
 7d4:	0017871b          	addiw	a4,a5,1
 7d8:	fee42623          	sw	a4,-20(s0)
 7dc:	17c1                	addi	a5,a5,-16
 7de:	97a2                	add	a5,a5,s0
 7e0:	02d00713          	li	a4,45
 7e4:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 7e8:	a839                	j	806 <printint+0xe6>
    putc(fd, buf[i]);
 7ea:	fec42783          	lw	a5,-20(s0)
 7ee:	17c1                	addi	a5,a5,-16
 7f0:	97a2                	add	a5,a5,s0
 7f2:	fe07c703          	lbu	a4,-32(a5)
 7f6:	fcc42783          	lw	a5,-52(s0)
 7fa:	85ba                	mv	a1,a4
 7fc:	853e                	mv	a0,a5
 7fe:	00000097          	auipc	ra,0x0
 802:	eec080e7          	jalr	-276(ra) # 6ea <putc>
  while(--i >= 0)
 806:	fec42783          	lw	a5,-20(s0)
 80a:	37fd                	addiw	a5,a5,-1
 80c:	fef42623          	sw	a5,-20(s0)
 810:	fec42783          	lw	a5,-20(s0)
 814:	2781                	sext.w	a5,a5
 816:	fc07dae3          	bgez	a5,7ea <printint+0xca>
}
 81a:	0001                	nop
 81c:	0001                	nop
 81e:	70e2                	ld	ra,56(sp)
 820:	7442                	ld	s0,48(sp)
 822:	6121                	addi	sp,sp,64
 824:	8082                	ret

0000000000000826 <printptr>:

static void
printptr(int fd, uint64 x) {
 826:	7179                	addi	sp,sp,-48
 828:	f406                	sd	ra,40(sp)
 82a:	f022                	sd	s0,32(sp)
 82c:	1800                	addi	s0,sp,48
 82e:	87aa                	mv	a5,a0
 830:	fcb43823          	sd	a1,-48(s0)
 834:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 838:	fdc42783          	lw	a5,-36(s0)
 83c:	03000593          	li	a1,48
 840:	853e                	mv	a0,a5
 842:	00000097          	auipc	ra,0x0
 846:	ea8080e7          	jalr	-344(ra) # 6ea <putc>
  putc(fd, 'x');
 84a:	fdc42783          	lw	a5,-36(s0)
 84e:	07800593          	li	a1,120
 852:	853e                	mv	a0,a5
 854:	00000097          	auipc	ra,0x0
 858:	e96080e7          	jalr	-362(ra) # 6ea <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 85c:	fe042623          	sw	zero,-20(s0)
 860:	a82d                	j	89a <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 862:	fd043783          	ld	a5,-48(s0)
 866:	93f1                	srli	a5,a5,0x3c
 868:	00000717          	auipc	a4,0x0
 86c:	79870713          	addi	a4,a4,1944 # 1000 <digits>
 870:	97ba                	add	a5,a5,a4
 872:	0007c703          	lbu	a4,0(a5)
 876:	fdc42783          	lw	a5,-36(s0)
 87a:	85ba                	mv	a1,a4
 87c:	853e                	mv	a0,a5
 87e:	00000097          	auipc	ra,0x0
 882:	e6c080e7          	jalr	-404(ra) # 6ea <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 886:	fec42783          	lw	a5,-20(s0)
 88a:	2785                	addiw	a5,a5,1
 88c:	fef42623          	sw	a5,-20(s0)
 890:	fd043783          	ld	a5,-48(s0)
 894:	0792                	slli	a5,a5,0x4
 896:	fcf43823          	sd	a5,-48(s0)
 89a:	fec42703          	lw	a4,-20(s0)
 89e:	47bd                	li	a5,15
 8a0:	fce7f1e3          	bgeu	a5,a4,862 <printptr+0x3c>
}
 8a4:	0001                	nop
 8a6:	0001                	nop
 8a8:	70a2                	ld	ra,40(sp)
 8aa:	7402                	ld	s0,32(sp)
 8ac:	6145                	addi	sp,sp,48
 8ae:	8082                	ret

00000000000008b0 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 8b0:	715d                	addi	sp,sp,-80
 8b2:	e486                	sd	ra,72(sp)
 8b4:	e0a2                	sd	s0,64(sp)
 8b6:	0880                	addi	s0,sp,80
 8b8:	87aa                	mv	a5,a0
 8ba:	fcb43023          	sd	a1,-64(s0)
 8be:	fac43c23          	sd	a2,-72(s0)
 8c2:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 8c6:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 8ca:	fe042223          	sw	zero,-28(s0)
 8ce:	a42d                	j	af8 <vprintf+0x248>
    c = fmt[i] & 0xff;
 8d0:	fe442783          	lw	a5,-28(s0)
 8d4:	fc043703          	ld	a4,-64(s0)
 8d8:	97ba                	add	a5,a5,a4
 8da:	0007c783          	lbu	a5,0(a5)
 8de:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 8e2:	fe042783          	lw	a5,-32(s0)
 8e6:	2781                	sext.w	a5,a5
 8e8:	eb9d                	bnez	a5,91e <vprintf+0x6e>
      if(c == '%'){
 8ea:	fdc42783          	lw	a5,-36(s0)
 8ee:	0007871b          	sext.w	a4,a5
 8f2:	02500793          	li	a5,37
 8f6:	00f71763          	bne	a4,a5,904 <vprintf+0x54>
        state = '%';
 8fa:	02500793          	li	a5,37
 8fe:	fef42023          	sw	a5,-32(s0)
 902:	a2f5                	j	aee <vprintf+0x23e>
      } else {
        putc(fd, c);
 904:	fdc42783          	lw	a5,-36(s0)
 908:	0ff7f713          	zext.b	a4,a5
 90c:	fcc42783          	lw	a5,-52(s0)
 910:	85ba                	mv	a1,a4
 912:	853e                	mv	a0,a5
 914:	00000097          	auipc	ra,0x0
 918:	dd6080e7          	jalr	-554(ra) # 6ea <putc>
 91c:	aac9                	j	aee <vprintf+0x23e>
      }
    } else if(state == '%'){
 91e:	fe042783          	lw	a5,-32(s0)
 922:	0007871b          	sext.w	a4,a5
 926:	02500793          	li	a5,37
 92a:	1cf71263          	bne	a4,a5,aee <vprintf+0x23e>
      if(c == 'd'){
 92e:	fdc42783          	lw	a5,-36(s0)
 932:	0007871b          	sext.w	a4,a5
 936:	06400793          	li	a5,100
 93a:	02f71463          	bne	a4,a5,962 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 93e:	fb843783          	ld	a5,-72(s0)
 942:	00878713          	addi	a4,a5,8
 946:	fae43c23          	sd	a4,-72(s0)
 94a:	4398                	lw	a4,0(a5)
 94c:	fcc42783          	lw	a5,-52(s0)
 950:	4685                	li	a3,1
 952:	4629                	li	a2,10
 954:	85ba                	mv	a1,a4
 956:	853e                	mv	a0,a5
 958:	00000097          	auipc	ra,0x0
 95c:	dc8080e7          	jalr	-568(ra) # 720 <printint>
 960:	a269                	j	aea <vprintf+0x23a>
      } else if(c == 'l') {
 962:	fdc42783          	lw	a5,-36(s0)
 966:	0007871b          	sext.w	a4,a5
 96a:	06c00793          	li	a5,108
 96e:	02f71663          	bne	a4,a5,99a <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 972:	fb843783          	ld	a5,-72(s0)
 976:	00878713          	addi	a4,a5,8
 97a:	fae43c23          	sd	a4,-72(s0)
 97e:	639c                	ld	a5,0(a5)
 980:	0007871b          	sext.w	a4,a5
 984:	fcc42783          	lw	a5,-52(s0)
 988:	4681                	li	a3,0
 98a:	4629                	li	a2,10
 98c:	85ba                	mv	a1,a4
 98e:	853e                	mv	a0,a5
 990:	00000097          	auipc	ra,0x0
 994:	d90080e7          	jalr	-624(ra) # 720 <printint>
 998:	aa89                	j	aea <vprintf+0x23a>
      } else if(c == 'x') {
 99a:	fdc42783          	lw	a5,-36(s0)
 99e:	0007871b          	sext.w	a4,a5
 9a2:	07800793          	li	a5,120
 9a6:	02f71463          	bne	a4,a5,9ce <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 9aa:	fb843783          	ld	a5,-72(s0)
 9ae:	00878713          	addi	a4,a5,8
 9b2:	fae43c23          	sd	a4,-72(s0)
 9b6:	4398                	lw	a4,0(a5)
 9b8:	fcc42783          	lw	a5,-52(s0)
 9bc:	4681                	li	a3,0
 9be:	4641                	li	a2,16
 9c0:	85ba                	mv	a1,a4
 9c2:	853e                	mv	a0,a5
 9c4:	00000097          	auipc	ra,0x0
 9c8:	d5c080e7          	jalr	-676(ra) # 720 <printint>
 9cc:	aa39                	j	aea <vprintf+0x23a>
      } else if(c == 'p') {
 9ce:	fdc42783          	lw	a5,-36(s0)
 9d2:	0007871b          	sext.w	a4,a5
 9d6:	07000793          	li	a5,112
 9da:	02f71263          	bne	a4,a5,9fe <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 9de:	fb843783          	ld	a5,-72(s0)
 9e2:	00878713          	addi	a4,a5,8
 9e6:	fae43c23          	sd	a4,-72(s0)
 9ea:	6398                	ld	a4,0(a5)
 9ec:	fcc42783          	lw	a5,-52(s0)
 9f0:	85ba                	mv	a1,a4
 9f2:	853e                	mv	a0,a5
 9f4:	00000097          	auipc	ra,0x0
 9f8:	e32080e7          	jalr	-462(ra) # 826 <printptr>
 9fc:	a0fd                	j	aea <vprintf+0x23a>
      } else if(c == 's'){
 9fe:	fdc42783          	lw	a5,-36(s0)
 a02:	0007871b          	sext.w	a4,a5
 a06:	07300793          	li	a5,115
 a0a:	04f71c63          	bne	a4,a5,a62 <vprintf+0x1b2>
        s = va_arg(ap, char*);
 a0e:	fb843783          	ld	a5,-72(s0)
 a12:	00878713          	addi	a4,a5,8
 a16:	fae43c23          	sd	a4,-72(s0)
 a1a:	639c                	ld	a5,0(a5)
 a1c:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 a20:	fe843783          	ld	a5,-24(s0)
 a24:	eb8d                	bnez	a5,a56 <vprintf+0x1a6>
          s = "(null)";
 a26:	00000797          	auipc	a5,0x0
 a2a:	4c278793          	addi	a5,a5,1218 # ee8 <malloc+0x186>
 a2e:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 a32:	a015                	j	a56 <vprintf+0x1a6>
          putc(fd, *s);
 a34:	fe843783          	ld	a5,-24(s0)
 a38:	0007c703          	lbu	a4,0(a5)
 a3c:	fcc42783          	lw	a5,-52(s0)
 a40:	85ba                	mv	a1,a4
 a42:	853e                	mv	a0,a5
 a44:	00000097          	auipc	ra,0x0
 a48:	ca6080e7          	jalr	-858(ra) # 6ea <putc>
          s++;
 a4c:	fe843783          	ld	a5,-24(s0)
 a50:	0785                	addi	a5,a5,1
 a52:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 a56:	fe843783          	ld	a5,-24(s0)
 a5a:	0007c783          	lbu	a5,0(a5)
 a5e:	fbf9                	bnez	a5,a34 <vprintf+0x184>
 a60:	a069                	j	aea <vprintf+0x23a>
        }
      } else if(c == 'c'){
 a62:	fdc42783          	lw	a5,-36(s0)
 a66:	0007871b          	sext.w	a4,a5
 a6a:	06300793          	li	a5,99
 a6e:	02f71463          	bne	a4,a5,a96 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 a72:	fb843783          	ld	a5,-72(s0)
 a76:	00878713          	addi	a4,a5,8
 a7a:	fae43c23          	sd	a4,-72(s0)
 a7e:	439c                	lw	a5,0(a5)
 a80:	0ff7f713          	zext.b	a4,a5
 a84:	fcc42783          	lw	a5,-52(s0)
 a88:	85ba                	mv	a1,a4
 a8a:	853e                	mv	a0,a5
 a8c:	00000097          	auipc	ra,0x0
 a90:	c5e080e7          	jalr	-930(ra) # 6ea <putc>
 a94:	a899                	j	aea <vprintf+0x23a>
      } else if(c == '%'){
 a96:	fdc42783          	lw	a5,-36(s0)
 a9a:	0007871b          	sext.w	a4,a5
 a9e:	02500793          	li	a5,37
 aa2:	00f71f63          	bne	a4,a5,ac0 <vprintf+0x210>
        putc(fd, c);
 aa6:	fdc42783          	lw	a5,-36(s0)
 aaa:	0ff7f713          	zext.b	a4,a5
 aae:	fcc42783          	lw	a5,-52(s0)
 ab2:	85ba                	mv	a1,a4
 ab4:	853e                	mv	a0,a5
 ab6:	00000097          	auipc	ra,0x0
 aba:	c34080e7          	jalr	-972(ra) # 6ea <putc>
 abe:	a035                	j	aea <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 ac0:	fcc42783          	lw	a5,-52(s0)
 ac4:	02500593          	li	a1,37
 ac8:	853e                	mv	a0,a5
 aca:	00000097          	auipc	ra,0x0
 ace:	c20080e7          	jalr	-992(ra) # 6ea <putc>
        putc(fd, c);
 ad2:	fdc42783          	lw	a5,-36(s0)
 ad6:	0ff7f713          	zext.b	a4,a5
 ada:	fcc42783          	lw	a5,-52(s0)
 ade:	85ba                	mv	a1,a4
 ae0:	853e                	mv	a0,a5
 ae2:	00000097          	auipc	ra,0x0
 ae6:	c08080e7          	jalr	-1016(ra) # 6ea <putc>
      }
      state = 0;
 aea:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 aee:	fe442783          	lw	a5,-28(s0)
 af2:	2785                	addiw	a5,a5,1
 af4:	fef42223          	sw	a5,-28(s0)
 af8:	fe442783          	lw	a5,-28(s0)
 afc:	fc043703          	ld	a4,-64(s0)
 b00:	97ba                	add	a5,a5,a4
 b02:	0007c783          	lbu	a5,0(a5)
 b06:	dc0795e3          	bnez	a5,8d0 <vprintf+0x20>
    }
  }
}
 b0a:	0001                	nop
 b0c:	0001                	nop
 b0e:	60a6                	ld	ra,72(sp)
 b10:	6406                	ld	s0,64(sp)
 b12:	6161                	addi	sp,sp,80
 b14:	8082                	ret

0000000000000b16 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b16:	7159                	addi	sp,sp,-112
 b18:	fc06                	sd	ra,56(sp)
 b1a:	f822                	sd	s0,48(sp)
 b1c:	0080                	addi	s0,sp,64
 b1e:	fcb43823          	sd	a1,-48(s0)
 b22:	e010                	sd	a2,0(s0)
 b24:	e414                	sd	a3,8(s0)
 b26:	e818                	sd	a4,16(s0)
 b28:	ec1c                	sd	a5,24(s0)
 b2a:	03043023          	sd	a6,32(s0)
 b2e:	03143423          	sd	a7,40(s0)
 b32:	87aa                	mv	a5,a0
 b34:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 b38:	03040793          	addi	a5,s0,48
 b3c:	fcf43423          	sd	a5,-56(s0)
 b40:	fc843783          	ld	a5,-56(s0)
 b44:	fd078793          	addi	a5,a5,-48
 b48:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 b4c:	fe843703          	ld	a4,-24(s0)
 b50:	fdc42783          	lw	a5,-36(s0)
 b54:	863a                	mv	a2,a4
 b56:	fd043583          	ld	a1,-48(s0)
 b5a:	853e                	mv	a0,a5
 b5c:	00000097          	auipc	ra,0x0
 b60:	d54080e7          	jalr	-684(ra) # 8b0 <vprintf>
}
 b64:	0001                	nop
 b66:	70e2                	ld	ra,56(sp)
 b68:	7442                	ld	s0,48(sp)
 b6a:	6165                	addi	sp,sp,112
 b6c:	8082                	ret

0000000000000b6e <printf>:

void
printf(const char *fmt, ...)
{
 b6e:	7159                	addi	sp,sp,-112
 b70:	f406                	sd	ra,40(sp)
 b72:	f022                	sd	s0,32(sp)
 b74:	1800                	addi	s0,sp,48
 b76:	fca43c23          	sd	a0,-40(s0)
 b7a:	e40c                	sd	a1,8(s0)
 b7c:	e810                	sd	a2,16(s0)
 b7e:	ec14                	sd	a3,24(s0)
 b80:	f018                	sd	a4,32(s0)
 b82:	f41c                	sd	a5,40(s0)
 b84:	03043823          	sd	a6,48(s0)
 b88:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b8c:	04040793          	addi	a5,s0,64
 b90:	fcf43823          	sd	a5,-48(s0)
 b94:	fd043783          	ld	a5,-48(s0)
 b98:	fc878793          	addi	a5,a5,-56
 b9c:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 ba0:	fe843783          	ld	a5,-24(s0)
 ba4:	863e                	mv	a2,a5
 ba6:	fd843583          	ld	a1,-40(s0)
 baa:	4505                	li	a0,1
 bac:	00000097          	auipc	ra,0x0
 bb0:	d04080e7          	jalr	-764(ra) # 8b0 <vprintf>
}
 bb4:	0001                	nop
 bb6:	70a2                	ld	ra,40(sp)
 bb8:	7402                	ld	s0,32(sp)
 bba:	6165                	addi	sp,sp,112
 bbc:	8082                	ret

0000000000000bbe <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 bbe:	7179                	addi	sp,sp,-48
 bc0:	f406                	sd	ra,40(sp)
 bc2:	f022                	sd	s0,32(sp)
 bc4:	1800                	addi	s0,sp,48
 bc6:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 bca:	fd843783          	ld	a5,-40(s0)
 bce:	17c1                	addi	a5,a5,-16
 bd0:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bd4:	00000797          	auipc	a5,0x0
 bd8:	65c78793          	addi	a5,a5,1628 # 1230 <freep>
 bdc:	639c                	ld	a5,0(a5)
 bde:	fef43423          	sd	a5,-24(s0)
 be2:	a815                	j	c16 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 be4:	fe843783          	ld	a5,-24(s0)
 be8:	639c                	ld	a5,0(a5)
 bea:	fe843703          	ld	a4,-24(s0)
 bee:	00f76f63          	bltu	a4,a5,c0c <free+0x4e>
 bf2:	fe043703          	ld	a4,-32(s0)
 bf6:	fe843783          	ld	a5,-24(s0)
 bfa:	02e7eb63          	bltu	a5,a4,c30 <free+0x72>
 bfe:	fe843783          	ld	a5,-24(s0)
 c02:	639c                	ld	a5,0(a5)
 c04:	fe043703          	ld	a4,-32(s0)
 c08:	02f76463          	bltu	a4,a5,c30 <free+0x72>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c0c:	fe843783          	ld	a5,-24(s0)
 c10:	639c                	ld	a5,0(a5)
 c12:	fef43423          	sd	a5,-24(s0)
 c16:	fe043703          	ld	a4,-32(s0)
 c1a:	fe843783          	ld	a5,-24(s0)
 c1e:	fce7f3e3          	bgeu	a5,a4,be4 <free+0x26>
 c22:	fe843783          	ld	a5,-24(s0)
 c26:	639c                	ld	a5,0(a5)
 c28:	fe043703          	ld	a4,-32(s0)
 c2c:	faf77ce3          	bgeu	a4,a5,be4 <free+0x26>
      break;
  if(bp + bp->s.size == p->s.ptr){
 c30:	fe043783          	ld	a5,-32(s0)
 c34:	479c                	lw	a5,8(a5)
 c36:	1782                	slli	a5,a5,0x20
 c38:	9381                	srli	a5,a5,0x20
 c3a:	0792                	slli	a5,a5,0x4
 c3c:	fe043703          	ld	a4,-32(s0)
 c40:	973e                	add	a4,a4,a5
 c42:	fe843783          	ld	a5,-24(s0)
 c46:	639c                	ld	a5,0(a5)
 c48:	02f71763          	bne	a4,a5,c76 <free+0xb8>
    bp->s.size += p->s.ptr->s.size;
 c4c:	fe043783          	ld	a5,-32(s0)
 c50:	4798                	lw	a4,8(a5)
 c52:	fe843783          	ld	a5,-24(s0)
 c56:	639c                	ld	a5,0(a5)
 c58:	479c                	lw	a5,8(a5)
 c5a:	9fb9                	addw	a5,a5,a4
 c5c:	0007871b          	sext.w	a4,a5
 c60:	fe043783          	ld	a5,-32(s0)
 c64:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 c66:	fe843783          	ld	a5,-24(s0)
 c6a:	639c                	ld	a5,0(a5)
 c6c:	6398                	ld	a4,0(a5)
 c6e:	fe043783          	ld	a5,-32(s0)
 c72:	e398                	sd	a4,0(a5)
 c74:	a039                	j	c82 <free+0xc4>
  } else
    bp->s.ptr = p->s.ptr;
 c76:	fe843783          	ld	a5,-24(s0)
 c7a:	6398                	ld	a4,0(a5)
 c7c:	fe043783          	ld	a5,-32(s0)
 c80:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 c82:	fe843783          	ld	a5,-24(s0)
 c86:	479c                	lw	a5,8(a5)
 c88:	1782                	slli	a5,a5,0x20
 c8a:	9381                	srli	a5,a5,0x20
 c8c:	0792                	slli	a5,a5,0x4
 c8e:	fe843703          	ld	a4,-24(s0)
 c92:	97ba                	add	a5,a5,a4
 c94:	fe043703          	ld	a4,-32(s0)
 c98:	02f71563          	bne	a4,a5,cc2 <free+0x104>
    p->s.size += bp->s.size;
 c9c:	fe843783          	ld	a5,-24(s0)
 ca0:	4798                	lw	a4,8(a5)
 ca2:	fe043783          	ld	a5,-32(s0)
 ca6:	479c                	lw	a5,8(a5)
 ca8:	9fb9                	addw	a5,a5,a4
 caa:	0007871b          	sext.w	a4,a5
 cae:	fe843783          	ld	a5,-24(s0)
 cb2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 cb4:	fe043783          	ld	a5,-32(s0)
 cb8:	6398                	ld	a4,0(a5)
 cba:	fe843783          	ld	a5,-24(s0)
 cbe:	e398                	sd	a4,0(a5)
 cc0:	a031                	j	ccc <free+0x10e>
  } else
    p->s.ptr = bp;
 cc2:	fe843783          	ld	a5,-24(s0)
 cc6:	fe043703          	ld	a4,-32(s0)
 cca:	e398                	sd	a4,0(a5)
  freep = p;
 ccc:	00000797          	auipc	a5,0x0
 cd0:	56478793          	addi	a5,a5,1380 # 1230 <freep>
 cd4:	fe843703          	ld	a4,-24(s0)
 cd8:	e398                	sd	a4,0(a5)
}
 cda:	0001                	nop
 cdc:	70a2                	ld	ra,40(sp)
 cde:	7402                	ld	s0,32(sp)
 ce0:	6145                	addi	sp,sp,48
 ce2:	8082                	ret

0000000000000ce4 <morecore>:

static Header*
morecore(uint nu)
{
 ce4:	7179                	addi	sp,sp,-48
 ce6:	f406                	sd	ra,40(sp)
 ce8:	f022                	sd	s0,32(sp)
 cea:	1800                	addi	s0,sp,48
 cec:	87aa                	mv	a5,a0
 cee:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 cf2:	fdc42783          	lw	a5,-36(s0)
 cf6:	0007871b          	sext.w	a4,a5
 cfa:	6785                	lui	a5,0x1
 cfc:	00f77563          	bgeu	a4,a5,d06 <morecore+0x22>
    nu = 4096;
 d00:	6785                	lui	a5,0x1
 d02:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 d06:	fdc42783          	lw	a5,-36(s0)
 d0a:	0047979b          	slliw	a5,a5,0x4
 d0e:	2781                	sext.w	a5,a5
 d10:	853e                	mv	a0,a5
 d12:	00000097          	auipc	ra,0x0
 d16:	9c0080e7          	jalr	-1600(ra) # 6d2 <sbrk>
 d1a:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 d1e:	fe843703          	ld	a4,-24(s0)
 d22:	57fd                	li	a5,-1
 d24:	00f71463          	bne	a4,a5,d2c <morecore+0x48>
    return 0;
 d28:	4781                	li	a5,0
 d2a:	a03d                	j	d58 <morecore+0x74>
  hp = (Header*)p;
 d2c:	fe843783          	ld	a5,-24(s0)
 d30:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 d34:	fe043783          	ld	a5,-32(s0)
 d38:	fdc42703          	lw	a4,-36(s0)
 d3c:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 d3e:	fe043783          	ld	a5,-32(s0)
 d42:	07c1                	addi	a5,a5,16 # 1010 <digits+0x10>
 d44:	853e                	mv	a0,a5
 d46:	00000097          	auipc	ra,0x0
 d4a:	e78080e7          	jalr	-392(ra) # bbe <free>
  return freep;
 d4e:	00000797          	auipc	a5,0x0
 d52:	4e278793          	addi	a5,a5,1250 # 1230 <freep>
 d56:	639c                	ld	a5,0(a5)
}
 d58:	853e                	mv	a0,a5
 d5a:	70a2                	ld	ra,40(sp)
 d5c:	7402                	ld	s0,32(sp)
 d5e:	6145                	addi	sp,sp,48
 d60:	8082                	ret

0000000000000d62 <malloc>:

void*
malloc(uint nbytes)
{
 d62:	7139                	addi	sp,sp,-64
 d64:	fc06                	sd	ra,56(sp)
 d66:	f822                	sd	s0,48(sp)
 d68:	0080                	addi	s0,sp,64
 d6a:	87aa                	mv	a5,a0
 d6c:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d70:	fcc46783          	lwu	a5,-52(s0)
 d74:	07bd                	addi	a5,a5,15
 d76:	8391                	srli	a5,a5,0x4
 d78:	2781                	sext.w	a5,a5
 d7a:	2785                	addiw	a5,a5,1
 d7c:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 d80:	00000797          	auipc	a5,0x0
 d84:	4b078793          	addi	a5,a5,1200 # 1230 <freep>
 d88:	639c                	ld	a5,0(a5)
 d8a:	fef43023          	sd	a5,-32(s0)
 d8e:	fe043783          	ld	a5,-32(s0)
 d92:	ef95                	bnez	a5,dce <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 d94:	00000797          	auipc	a5,0x0
 d98:	48c78793          	addi	a5,a5,1164 # 1220 <base>
 d9c:	fef43023          	sd	a5,-32(s0)
 da0:	00000797          	auipc	a5,0x0
 da4:	49078793          	addi	a5,a5,1168 # 1230 <freep>
 da8:	fe043703          	ld	a4,-32(s0)
 dac:	e398                	sd	a4,0(a5)
 dae:	00000797          	auipc	a5,0x0
 db2:	48278793          	addi	a5,a5,1154 # 1230 <freep>
 db6:	6398                	ld	a4,0(a5)
 db8:	00000797          	auipc	a5,0x0
 dbc:	46878793          	addi	a5,a5,1128 # 1220 <base>
 dc0:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 dc2:	00000797          	auipc	a5,0x0
 dc6:	45e78793          	addi	a5,a5,1118 # 1220 <base>
 dca:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 dce:	fe043783          	ld	a5,-32(s0)
 dd2:	639c                	ld	a5,0(a5)
 dd4:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 dd8:	fe843783          	ld	a5,-24(s0)
 ddc:	479c                	lw	a5,8(a5)
 dde:	fdc42703          	lw	a4,-36(s0)
 de2:	2701                	sext.w	a4,a4
 de4:	06e7e763          	bltu	a5,a4,e52 <malloc+0xf0>
      if(p->s.size == nunits)
 de8:	fe843783          	ld	a5,-24(s0)
 dec:	479c                	lw	a5,8(a5)
 dee:	fdc42703          	lw	a4,-36(s0)
 df2:	2701                	sext.w	a4,a4
 df4:	00f71963          	bne	a4,a5,e06 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 df8:	fe843783          	ld	a5,-24(s0)
 dfc:	6398                	ld	a4,0(a5)
 dfe:	fe043783          	ld	a5,-32(s0)
 e02:	e398                	sd	a4,0(a5)
 e04:	a825                	j	e3c <malloc+0xda>
      else {
        p->s.size -= nunits;
 e06:	fe843783          	ld	a5,-24(s0)
 e0a:	479c                	lw	a5,8(a5)
 e0c:	fdc42703          	lw	a4,-36(s0)
 e10:	9f99                	subw	a5,a5,a4
 e12:	0007871b          	sext.w	a4,a5
 e16:	fe843783          	ld	a5,-24(s0)
 e1a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 e1c:	fe843783          	ld	a5,-24(s0)
 e20:	479c                	lw	a5,8(a5)
 e22:	1782                	slli	a5,a5,0x20
 e24:	9381                	srli	a5,a5,0x20
 e26:	0792                	slli	a5,a5,0x4
 e28:	fe843703          	ld	a4,-24(s0)
 e2c:	97ba                	add	a5,a5,a4
 e2e:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 e32:	fe843783          	ld	a5,-24(s0)
 e36:	fdc42703          	lw	a4,-36(s0)
 e3a:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 e3c:	00000797          	auipc	a5,0x0
 e40:	3f478793          	addi	a5,a5,1012 # 1230 <freep>
 e44:	fe043703          	ld	a4,-32(s0)
 e48:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 e4a:	fe843783          	ld	a5,-24(s0)
 e4e:	07c1                	addi	a5,a5,16
 e50:	a091                	j	e94 <malloc+0x132>
    }
    if(p == freep)
 e52:	00000797          	auipc	a5,0x0
 e56:	3de78793          	addi	a5,a5,990 # 1230 <freep>
 e5a:	639c                	ld	a5,0(a5)
 e5c:	fe843703          	ld	a4,-24(s0)
 e60:	02f71063          	bne	a4,a5,e80 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 e64:	fdc42783          	lw	a5,-36(s0)
 e68:	853e                	mv	a0,a5
 e6a:	00000097          	auipc	ra,0x0
 e6e:	e7a080e7          	jalr	-390(ra) # ce4 <morecore>
 e72:	fea43423          	sd	a0,-24(s0)
 e76:	fe843783          	ld	a5,-24(s0)
 e7a:	e399                	bnez	a5,e80 <malloc+0x11e>
        return 0;
 e7c:	4781                	li	a5,0
 e7e:	a819                	j	e94 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e80:	fe843783          	ld	a5,-24(s0)
 e84:	fef43023          	sd	a5,-32(s0)
 e88:	fe843783          	ld	a5,-24(s0)
 e8c:	639c                	ld	a5,0(a5)
 e8e:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 e92:	b799                	j	dd8 <malloc+0x76>
  }
}
 e94:	853e                	mv	a0,a5
 e96:	70e2                	ld	ra,56(sp)
 e98:	7442                	ld	s0,48(sp)
 e9a:	6121                	addi	sp,sp,64
 e9c:	8082                	ret
