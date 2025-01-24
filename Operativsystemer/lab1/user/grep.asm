
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
       0:	7139                	addi	sp,sp,-64
       2:	fc06                	sd	ra,56(sp)
       4:	f822                	sd	s0,48(sp)
       6:	0080                	addi	s0,sp,64
       8:	fca43423          	sd	a0,-56(s0)
       c:	87ae                	mv	a5,a1
       e:	fcf42223          	sw	a5,-60(s0)
  int n, m;
  char *p, *q;

  m = 0;
      12:	fe042623          	sw	zero,-20(s0)
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
      16:	a0c5                	j	f6 <grep+0xf6>
    m += n;
      18:	fec42783          	lw	a5,-20(s0)
      1c:	873e                	mv	a4,a5
      1e:	fdc42783          	lw	a5,-36(s0)
      22:	9fb9                	addw	a5,a5,a4
      24:	fef42623          	sw	a5,-20(s0)
    buf[m] = '\0';
      28:	00002717          	auipc	a4,0x2
      2c:	ff870713          	addi	a4,a4,-8 # 2020 <buf>
      30:	fec42783          	lw	a5,-20(s0)
      34:	97ba                	add	a5,a5,a4
      36:	00078023          	sb	zero,0(a5)
    p = buf;
      3a:	00002797          	auipc	a5,0x2
      3e:	fe678793          	addi	a5,a5,-26 # 2020 <buf>
      42:	fef43023          	sd	a5,-32(s0)
    while((q = strchr(p, '\n')) != 0){
      46:	a891                	j	9a <grep+0x9a>
      *q = 0;
      48:	fd043783          	ld	a5,-48(s0)
      4c:	00078023          	sb	zero,0(a5)
      if(match(pattern, p)){
      50:	fe043583          	ld	a1,-32(s0)
      54:	fc843503          	ld	a0,-56(s0)
      58:	00000097          	auipc	ra,0x0
      5c:	1fa080e7          	jalr	506(ra) # 252 <match>
      60:	87aa                	mv	a5,a0
      62:	c79d                	beqz	a5,90 <grep+0x90>
        *q = '\n';
      64:	fd043783          	ld	a5,-48(s0)
      68:	4729                	li	a4,10
      6a:	00e78023          	sb	a4,0(a5)
        write(1, p, q+1 - p);
      6e:	fd043783          	ld	a5,-48(s0)
      72:	00178713          	addi	a4,a5,1
      76:	fe043783          	ld	a5,-32(s0)
      7a:	40f707b3          	sub	a5,a4,a5
      7e:	2781                	sext.w	a5,a5
      80:	863e                	mv	a2,a5
      82:	fe043583          	ld	a1,-32(s0)
      86:	4505                	li	a0,1
      88:	00001097          	auipc	ra,0x1
      8c:	87a080e7          	jalr	-1926(ra) # 902 <write>
      }
      p = q+1;
      90:	fd043783          	ld	a5,-48(s0)
      94:	0785                	addi	a5,a5,1
      96:	fef43023          	sd	a5,-32(s0)
    while((q = strchr(p, '\n')) != 0){
      9a:	45a9                	li	a1,10
      9c:	fe043503          	ld	a0,-32(s0)
      a0:	00000097          	auipc	ra,0x0
      a4:	4e8080e7          	jalr	1256(ra) # 588 <strchr>
      a8:	fca43823          	sd	a0,-48(s0)
      ac:	fd043783          	ld	a5,-48(s0)
      b0:	ffc1                	bnez	a5,48 <grep+0x48>
    }
    if(m > 0){
      b2:	fec42783          	lw	a5,-20(s0)
      b6:	2781                	sext.w	a5,a5
      b8:	02f05f63          	blez	a5,f6 <grep+0xf6>
      m -= p - buf;
      bc:	fec42703          	lw	a4,-20(s0)
      c0:	fe043683          	ld	a3,-32(s0)
      c4:	00002797          	auipc	a5,0x2
      c8:	f5c78793          	addi	a5,a5,-164 # 2020 <buf>
      cc:	40f687b3          	sub	a5,a3,a5
      d0:	2781                	sext.w	a5,a5
      d2:	40f707bb          	subw	a5,a4,a5
      d6:	2781                	sext.w	a5,a5
      d8:	fef42623          	sw	a5,-20(s0)
      memmove(buf, p, m);
      dc:	fec42783          	lw	a5,-20(s0)
      e0:	863e                	mv	a2,a5
      e2:	fe043583          	ld	a1,-32(s0)
      e6:	00002517          	auipc	a0,0x2
      ea:	f3a50513          	addi	a0,a0,-198 # 2020 <buf>
      ee:	00000097          	auipc	ra,0x0
      f2:	666080e7          	jalr	1638(ra) # 754 <memmove>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
      f6:	fec42703          	lw	a4,-20(s0)
      fa:	00002797          	auipc	a5,0x2
      fe:	f2678793          	addi	a5,a5,-218 # 2020 <buf>
     102:	00f706b3          	add	a3,a4,a5
     106:	fec42783          	lw	a5,-20(s0)
     10a:	3ff00713          	li	a4,1023
     10e:	40f707bb          	subw	a5,a4,a5
     112:	2781                	sext.w	a5,a5
     114:	873e                	mv	a4,a5
     116:	fc442783          	lw	a5,-60(s0)
     11a:	863a                	mv	a2,a4
     11c:	85b6                	mv	a1,a3
     11e:	853e                	mv	a0,a5
     120:	00000097          	auipc	ra,0x0
     124:	7da080e7          	jalr	2010(ra) # 8fa <read>
     128:	87aa                	mv	a5,a0
     12a:	fcf42e23          	sw	a5,-36(s0)
     12e:	fdc42783          	lw	a5,-36(s0)
     132:	2781                	sext.w	a5,a5
     134:	eef042e3          	bgtz	a5,18 <grep+0x18>
    }
  }
}
     138:	0001                	nop
     13a:	0001                	nop
     13c:	70e2                	ld	ra,56(sp)
     13e:	7442                	ld	s0,48(sp)
     140:	6121                	addi	sp,sp,64
     142:	8082                	ret

0000000000000144 <main>:

int
main(int argc, char *argv[])
{
     144:	7139                	addi	sp,sp,-64
     146:	fc06                	sd	ra,56(sp)
     148:	f822                	sd	s0,48(sp)
     14a:	0080                	addi	s0,sp,64
     14c:	87aa                	mv	a5,a0
     14e:	fcb43023          	sd	a1,-64(s0)
     152:	fcf42623          	sw	a5,-52(s0)
  int fd, i;
  char *pattern;

  if(argc <= 1){
     156:	fcc42783          	lw	a5,-52(s0)
     15a:	0007871b          	sext.w	a4,a5
     15e:	4785                	li	a5,1
     160:	02e7c063          	blt	a5,a4,180 <main+0x3c>
    fprintf(2, "usage: grep pattern [file ...]\n");
     164:	00001597          	auipc	a1,0x1
     168:	fdc58593          	addi	a1,a1,-36 # 1140 <malloc+0x146>
     16c:	4509                	li	a0,2
     16e:	00001097          	auipc	ra,0x1
     172:	c40080e7          	jalr	-960(ra) # dae <fprintf>
    exit(1);
     176:	4505                	li	a0,1
     178:	00000097          	auipc	ra,0x0
     17c:	76a080e7          	jalr	1898(ra) # 8e2 <exit>
  }
  pattern = argv[1];
     180:	fc043783          	ld	a5,-64(s0)
     184:	679c                	ld	a5,8(a5)
     186:	fef43023          	sd	a5,-32(s0)

  if(argc <= 2){
     18a:	fcc42783          	lw	a5,-52(s0)
     18e:	0007871b          	sext.w	a4,a5
     192:	4789                	li	a5,2
     194:	00e7ce63          	blt	a5,a4,1b0 <main+0x6c>
    grep(pattern, 0);
     198:	4581                	li	a1,0
     19a:	fe043503          	ld	a0,-32(s0)
     19e:	00000097          	auipc	ra,0x0
     1a2:	e62080e7          	jalr	-414(ra) # 0 <grep>
    exit(0);
     1a6:	4501                	li	a0,0
     1a8:	00000097          	auipc	ra,0x0
     1ac:	73a080e7          	jalr	1850(ra) # 8e2 <exit>
  }

  for(i = 2; i < argc; i++){
     1b0:	4789                	li	a5,2
     1b2:	fef42623          	sw	a5,-20(s0)
     1b6:	a041                	j	236 <main+0xf2>
    if((fd = open(argv[i], 0)) < 0){
     1b8:	fec42783          	lw	a5,-20(s0)
     1bc:	078e                	slli	a5,a5,0x3
     1be:	fc043703          	ld	a4,-64(s0)
     1c2:	97ba                	add	a5,a5,a4
     1c4:	639c                	ld	a5,0(a5)
     1c6:	4581                	li	a1,0
     1c8:	853e                	mv	a0,a5
     1ca:	00000097          	auipc	ra,0x0
     1ce:	758080e7          	jalr	1880(ra) # 922 <open>
     1d2:	87aa                	mv	a5,a0
     1d4:	fcf42e23          	sw	a5,-36(s0)
     1d8:	fdc42783          	lw	a5,-36(s0)
     1dc:	2781                	sext.w	a5,a5
     1de:	0207d763          	bgez	a5,20c <main+0xc8>
      printf("grep: cannot open %s\n", argv[i]);
     1e2:	fec42783          	lw	a5,-20(s0)
     1e6:	078e                	slli	a5,a5,0x3
     1e8:	fc043703          	ld	a4,-64(s0)
     1ec:	97ba                	add	a5,a5,a4
     1ee:	639c                	ld	a5,0(a5)
     1f0:	85be                	mv	a1,a5
     1f2:	00001517          	auipc	a0,0x1
     1f6:	f6e50513          	addi	a0,a0,-146 # 1160 <malloc+0x166>
     1fa:	00001097          	auipc	ra,0x1
     1fe:	c0c080e7          	jalr	-1012(ra) # e06 <printf>
      exit(1);
     202:	4505                	li	a0,1
     204:	00000097          	auipc	ra,0x0
     208:	6de080e7          	jalr	1758(ra) # 8e2 <exit>
    }
    grep(pattern, fd);
     20c:	fdc42783          	lw	a5,-36(s0)
     210:	85be                	mv	a1,a5
     212:	fe043503          	ld	a0,-32(s0)
     216:	00000097          	auipc	ra,0x0
     21a:	dea080e7          	jalr	-534(ra) # 0 <grep>
    close(fd);
     21e:	fdc42783          	lw	a5,-36(s0)
     222:	853e                	mv	a0,a5
     224:	00000097          	auipc	ra,0x0
     228:	6e6080e7          	jalr	1766(ra) # 90a <close>
  for(i = 2; i < argc; i++){
     22c:	fec42783          	lw	a5,-20(s0)
     230:	2785                	addiw	a5,a5,1
     232:	fef42623          	sw	a5,-20(s0)
     236:	fec42783          	lw	a5,-20(s0)
     23a:	873e                	mv	a4,a5
     23c:	fcc42783          	lw	a5,-52(s0)
     240:	2701                	sext.w	a4,a4
     242:	2781                	sext.w	a5,a5
     244:	f6f74ae3          	blt	a4,a5,1b8 <main+0x74>
  }
  exit(0);
     248:	4501                	li	a0,0
     24a:	00000097          	auipc	ra,0x0
     24e:	698080e7          	jalr	1688(ra) # 8e2 <exit>

0000000000000252 <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
     252:	1101                	addi	sp,sp,-32
     254:	ec06                	sd	ra,24(sp)
     256:	e822                	sd	s0,16(sp)
     258:	1000                	addi	s0,sp,32
     25a:	fea43423          	sd	a0,-24(s0)
     25e:	feb43023          	sd	a1,-32(s0)
  if(re[0] == '^')
     262:	fe843783          	ld	a5,-24(s0)
     266:	0007c783          	lbu	a5,0(a5)
     26a:	873e                	mv	a4,a5
     26c:	05e00793          	li	a5,94
     270:	00f71e63          	bne	a4,a5,28c <match+0x3a>
    return matchhere(re+1, text);
     274:	fe843783          	ld	a5,-24(s0)
     278:	0785                	addi	a5,a5,1
     27a:	fe043583          	ld	a1,-32(s0)
     27e:	853e                	mv	a0,a5
     280:	00000097          	auipc	ra,0x0
     284:	042080e7          	jalr	66(ra) # 2c2 <matchhere>
     288:	87aa                	mv	a5,a0
     28a:	a03d                	j	2b8 <match+0x66>
  do{  // must look at empty string
    if(matchhere(re, text))
     28c:	fe043583          	ld	a1,-32(s0)
     290:	fe843503          	ld	a0,-24(s0)
     294:	00000097          	auipc	ra,0x0
     298:	02e080e7          	jalr	46(ra) # 2c2 <matchhere>
     29c:	87aa                	mv	a5,a0
     29e:	c399                	beqz	a5,2a4 <match+0x52>
      return 1;
     2a0:	4785                	li	a5,1
     2a2:	a819                	j	2b8 <match+0x66>
  }while(*text++ != '\0');
     2a4:	fe043783          	ld	a5,-32(s0)
     2a8:	00178713          	addi	a4,a5,1
     2ac:	fee43023          	sd	a4,-32(s0)
     2b0:	0007c783          	lbu	a5,0(a5)
     2b4:	ffe1                	bnez	a5,28c <match+0x3a>
  return 0;
     2b6:	4781                	li	a5,0
}
     2b8:	853e                	mv	a0,a5
     2ba:	60e2                	ld	ra,24(sp)
     2bc:	6442                	ld	s0,16(sp)
     2be:	6105                	addi	sp,sp,32
     2c0:	8082                	ret

00000000000002c2 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
     2c2:	1101                	addi	sp,sp,-32
     2c4:	ec06                	sd	ra,24(sp)
     2c6:	e822                	sd	s0,16(sp)
     2c8:	1000                	addi	s0,sp,32
     2ca:	fea43423          	sd	a0,-24(s0)
     2ce:	feb43023          	sd	a1,-32(s0)
  if(re[0] == '\0')
     2d2:	fe843783          	ld	a5,-24(s0)
     2d6:	0007c783          	lbu	a5,0(a5)
     2da:	e399                	bnez	a5,2e0 <matchhere+0x1e>
    return 1;
     2dc:	4785                	li	a5,1
     2de:	a0c1                	j	39e <matchhere+0xdc>
  if(re[1] == '*')
     2e0:	fe843783          	ld	a5,-24(s0)
     2e4:	0785                	addi	a5,a5,1
     2e6:	0007c783          	lbu	a5,0(a5)
     2ea:	873e                	mv	a4,a5
     2ec:	02a00793          	li	a5,42
     2f0:	02f71563          	bne	a4,a5,31a <matchhere+0x58>
    return matchstar(re[0], re+2, text);
     2f4:	fe843783          	ld	a5,-24(s0)
     2f8:	0007c783          	lbu	a5,0(a5)
     2fc:	0007871b          	sext.w	a4,a5
     300:	fe843783          	ld	a5,-24(s0)
     304:	0789                	addi	a5,a5,2
     306:	fe043603          	ld	a2,-32(s0)
     30a:	85be                	mv	a1,a5
     30c:	853a                	mv	a0,a4
     30e:	00000097          	auipc	ra,0x0
     312:	09a080e7          	jalr	154(ra) # 3a8 <matchstar>
     316:	87aa                	mv	a5,a0
     318:	a059                	j	39e <matchhere+0xdc>
  if(re[0] == '$' && re[1] == '\0')
     31a:	fe843783          	ld	a5,-24(s0)
     31e:	0007c783          	lbu	a5,0(a5)
     322:	873e                	mv	a4,a5
     324:	02400793          	li	a5,36
     328:	02f71363          	bne	a4,a5,34e <matchhere+0x8c>
     32c:	fe843783          	ld	a5,-24(s0)
     330:	0785                	addi	a5,a5,1
     332:	0007c783          	lbu	a5,0(a5)
     336:	ef81                	bnez	a5,34e <matchhere+0x8c>
    return *text == '\0';
     338:	fe043783          	ld	a5,-32(s0)
     33c:	0007c783          	lbu	a5,0(a5)
     340:	2781                	sext.w	a5,a5
     342:	0017b793          	seqz	a5,a5
     346:	0ff7f793          	zext.b	a5,a5
     34a:	2781                	sext.w	a5,a5
     34c:	a889                	j	39e <matchhere+0xdc>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
     34e:	fe043783          	ld	a5,-32(s0)
     352:	0007c783          	lbu	a5,0(a5)
     356:	c3b9                	beqz	a5,39c <matchhere+0xda>
     358:	fe843783          	ld	a5,-24(s0)
     35c:	0007c783          	lbu	a5,0(a5)
     360:	873e                	mv	a4,a5
     362:	02e00793          	li	a5,46
     366:	00f70c63          	beq	a4,a5,37e <matchhere+0xbc>
     36a:	fe843783          	ld	a5,-24(s0)
     36e:	0007c703          	lbu	a4,0(a5)
     372:	fe043783          	ld	a5,-32(s0)
     376:	0007c783          	lbu	a5,0(a5)
     37a:	02f71163          	bne	a4,a5,39c <matchhere+0xda>
    return matchhere(re+1, text+1);
     37e:	fe843783          	ld	a5,-24(s0)
     382:	00178713          	addi	a4,a5,1
     386:	fe043783          	ld	a5,-32(s0)
     38a:	0785                	addi	a5,a5,1
     38c:	85be                	mv	a1,a5
     38e:	853a                	mv	a0,a4
     390:	00000097          	auipc	ra,0x0
     394:	f32080e7          	jalr	-206(ra) # 2c2 <matchhere>
     398:	87aa                	mv	a5,a0
     39a:	a011                	j	39e <matchhere+0xdc>
  return 0;
     39c:	4781                	li	a5,0
}
     39e:	853e                	mv	a0,a5
     3a0:	60e2                	ld	ra,24(sp)
     3a2:	6442                	ld	s0,16(sp)
     3a4:	6105                	addi	sp,sp,32
     3a6:	8082                	ret

00000000000003a8 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
     3a8:	7179                	addi	sp,sp,-48
     3aa:	f406                	sd	ra,40(sp)
     3ac:	f022                	sd	s0,32(sp)
     3ae:	1800                	addi	s0,sp,48
     3b0:	87aa                	mv	a5,a0
     3b2:	feb43023          	sd	a1,-32(s0)
     3b6:	fcc43c23          	sd	a2,-40(s0)
     3ba:	fef42623          	sw	a5,-20(s0)
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
     3be:	fd843583          	ld	a1,-40(s0)
     3c2:	fe043503          	ld	a0,-32(s0)
     3c6:	00000097          	auipc	ra,0x0
     3ca:	efc080e7          	jalr	-260(ra) # 2c2 <matchhere>
     3ce:	87aa                	mv	a5,a0
     3d0:	c399                	beqz	a5,3d6 <matchstar+0x2e>
      return 1;
     3d2:	4785                	li	a5,1
     3d4:	a82d                	j	40e <matchstar+0x66>
  }while(*text!='\0' && (*text++==c || c=='.'));
     3d6:	fd843783          	ld	a5,-40(s0)
     3da:	0007c783          	lbu	a5,0(a5)
     3de:	c79d                	beqz	a5,40c <matchstar+0x64>
     3e0:	fd843783          	ld	a5,-40(s0)
     3e4:	00178713          	addi	a4,a5,1
     3e8:	fce43c23          	sd	a4,-40(s0)
     3ec:	0007c783          	lbu	a5,0(a5)
     3f0:	2781                	sext.w	a5,a5
     3f2:	fec42703          	lw	a4,-20(s0)
     3f6:	2701                	sext.w	a4,a4
     3f8:	fcf703e3          	beq	a4,a5,3be <matchstar+0x16>
     3fc:	fec42783          	lw	a5,-20(s0)
     400:	0007871b          	sext.w	a4,a5
     404:	02e00793          	li	a5,46
     408:	faf70be3          	beq	a4,a5,3be <matchstar+0x16>
  return 0;
     40c:	4781                	li	a5,0
}
     40e:	853e                	mv	a0,a5
     410:	70a2                	ld	ra,40(sp)
     412:	7402                	ld	s0,32(sp)
     414:	6145                	addi	sp,sp,48
     416:	8082                	ret

0000000000000418 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     418:	1141                	addi	sp,sp,-16
     41a:	e406                	sd	ra,8(sp)
     41c:	e022                	sd	s0,0(sp)
     41e:	0800                	addi	s0,sp,16
  extern int main();
  main();
     420:	00000097          	auipc	ra,0x0
     424:	d24080e7          	jalr	-732(ra) # 144 <main>
  exit(0);
     428:	4501                	li	a0,0
     42a:	00000097          	auipc	ra,0x0
     42e:	4b8080e7          	jalr	1208(ra) # 8e2 <exit>

0000000000000432 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     432:	7179                	addi	sp,sp,-48
     434:	f406                	sd	ra,40(sp)
     436:	f022                	sd	s0,32(sp)
     438:	1800                	addi	s0,sp,48
     43a:	fca43c23          	sd	a0,-40(s0)
     43e:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
     442:	fd843783          	ld	a5,-40(s0)
     446:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
     44a:	0001                	nop
     44c:	fd043703          	ld	a4,-48(s0)
     450:	00170793          	addi	a5,a4,1
     454:	fcf43823          	sd	a5,-48(s0)
     458:	fd843783          	ld	a5,-40(s0)
     45c:	00178693          	addi	a3,a5,1
     460:	fcd43c23          	sd	a3,-40(s0)
     464:	00074703          	lbu	a4,0(a4)
     468:	00e78023          	sb	a4,0(a5)
     46c:	0007c783          	lbu	a5,0(a5)
     470:	fff1                	bnez	a5,44c <strcpy+0x1a>
    ;
  return os;
     472:	fe843783          	ld	a5,-24(s0)
}
     476:	853e                	mv	a0,a5
     478:	70a2                	ld	ra,40(sp)
     47a:	7402                	ld	s0,32(sp)
     47c:	6145                	addi	sp,sp,48
     47e:	8082                	ret

0000000000000480 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     480:	1101                	addi	sp,sp,-32
     482:	ec06                	sd	ra,24(sp)
     484:	e822                	sd	s0,16(sp)
     486:	1000                	addi	s0,sp,32
     488:	fea43423          	sd	a0,-24(s0)
     48c:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
     490:	a819                	j	4a6 <strcmp+0x26>
    p++, q++;
     492:	fe843783          	ld	a5,-24(s0)
     496:	0785                	addi	a5,a5,1
     498:	fef43423          	sd	a5,-24(s0)
     49c:	fe043783          	ld	a5,-32(s0)
     4a0:	0785                	addi	a5,a5,1
     4a2:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
     4a6:	fe843783          	ld	a5,-24(s0)
     4aa:	0007c783          	lbu	a5,0(a5)
     4ae:	cb99                	beqz	a5,4c4 <strcmp+0x44>
     4b0:	fe843783          	ld	a5,-24(s0)
     4b4:	0007c703          	lbu	a4,0(a5)
     4b8:	fe043783          	ld	a5,-32(s0)
     4bc:	0007c783          	lbu	a5,0(a5)
     4c0:	fcf709e3          	beq	a4,a5,492 <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
     4c4:	fe843783          	ld	a5,-24(s0)
     4c8:	0007c783          	lbu	a5,0(a5)
     4cc:	0007871b          	sext.w	a4,a5
     4d0:	fe043783          	ld	a5,-32(s0)
     4d4:	0007c783          	lbu	a5,0(a5)
     4d8:	2781                	sext.w	a5,a5
     4da:	40f707bb          	subw	a5,a4,a5
     4de:	2781                	sext.w	a5,a5
}
     4e0:	853e                	mv	a0,a5
     4e2:	60e2                	ld	ra,24(sp)
     4e4:	6442                	ld	s0,16(sp)
     4e6:	6105                	addi	sp,sp,32
     4e8:	8082                	ret

00000000000004ea <strlen>:

uint
strlen(const char *s)
{
     4ea:	7179                	addi	sp,sp,-48
     4ec:	f406                	sd	ra,40(sp)
     4ee:	f022                	sd	s0,32(sp)
     4f0:	1800                	addi	s0,sp,48
     4f2:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
     4f6:	fe042623          	sw	zero,-20(s0)
     4fa:	a031                	j	506 <strlen+0x1c>
     4fc:	fec42783          	lw	a5,-20(s0)
     500:	2785                	addiw	a5,a5,1
     502:	fef42623          	sw	a5,-20(s0)
     506:	fec42783          	lw	a5,-20(s0)
     50a:	fd843703          	ld	a4,-40(s0)
     50e:	97ba                	add	a5,a5,a4
     510:	0007c783          	lbu	a5,0(a5)
     514:	f7e5                	bnez	a5,4fc <strlen+0x12>
    ;
  return n;
     516:	fec42783          	lw	a5,-20(s0)
}
     51a:	853e                	mv	a0,a5
     51c:	70a2                	ld	ra,40(sp)
     51e:	7402                	ld	s0,32(sp)
     520:	6145                	addi	sp,sp,48
     522:	8082                	ret

0000000000000524 <memset>:

void*
memset(void *dst, int c, uint n)
{
     524:	7179                	addi	sp,sp,-48
     526:	f406                	sd	ra,40(sp)
     528:	f022                	sd	s0,32(sp)
     52a:	1800                	addi	s0,sp,48
     52c:	fca43c23          	sd	a0,-40(s0)
     530:	87ae                	mv	a5,a1
     532:	8732                	mv	a4,a2
     534:	fcf42a23          	sw	a5,-44(s0)
     538:	87ba                	mv	a5,a4
     53a:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
     53e:	fd843783          	ld	a5,-40(s0)
     542:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
     546:	fe042623          	sw	zero,-20(s0)
     54a:	a00d                	j	56c <memset+0x48>
    cdst[i] = c;
     54c:	fec42783          	lw	a5,-20(s0)
     550:	fe043703          	ld	a4,-32(s0)
     554:	97ba                	add	a5,a5,a4
     556:	fd442703          	lw	a4,-44(s0)
     55a:	0ff77713          	zext.b	a4,a4
     55e:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
     562:	fec42783          	lw	a5,-20(s0)
     566:	2785                	addiw	a5,a5,1
     568:	fef42623          	sw	a5,-20(s0)
     56c:	fec42783          	lw	a5,-20(s0)
     570:	fd042703          	lw	a4,-48(s0)
     574:	2701                	sext.w	a4,a4
     576:	fce7ebe3          	bltu	a5,a4,54c <memset+0x28>
  }
  return dst;
     57a:	fd843783          	ld	a5,-40(s0)
}
     57e:	853e                	mv	a0,a5
     580:	70a2                	ld	ra,40(sp)
     582:	7402                	ld	s0,32(sp)
     584:	6145                	addi	sp,sp,48
     586:	8082                	ret

0000000000000588 <strchr>:

char*
strchr(const char *s, char c)
{
     588:	1101                	addi	sp,sp,-32
     58a:	ec06                	sd	ra,24(sp)
     58c:	e822                	sd	s0,16(sp)
     58e:	1000                	addi	s0,sp,32
     590:	fea43423          	sd	a0,-24(s0)
     594:	87ae                	mv	a5,a1
     596:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
     59a:	a01d                	j	5c0 <strchr+0x38>
    if(*s == c)
     59c:	fe843783          	ld	a5,-24(s0)
     5a0:	0007c703          	lbu	a4,0(a5)
     5a4:	fe744783          	lbu	a5,-25(s0)
     5a8:	0ff7f793          	zext.b	a5,a5
     5ac:	00e79563          	bne	a5,a4,5b6 <strchr+0x2e>
      return (char*)s;
     5b0:	fe843783          	ld	a5,-24(s0)
     5b4:	a821                	j	5cc <strchr+0x44>
  for(; *s; s++)
     5b6:	fe843783          	ld	a5,-24(s0)
     5ba:	0785                	addi	a5,a5,1
     5bc:	fef43423          	sd	a5,-24(s0)
     5c0:	fe843783          	ld	a5,-24(s0)
     5c4:	0007c783          	lbu	a5,0(a5)
     5c8:	fbf1                	bnez	a5,59c <strchr+0x14>
  return 0;
     5ca:	4781                	li	a5,0
}
     5cc:	853e                	mv	a0,a5
     5ce:	60e2                	ld	ra,24(sp)
     5d0:	6442                	ld	s0,16(sp)
     5d2:	6105                	addi	sp,sp,32
     5d4:	8082                	ret

00000000000005d6 <gets>:

char*
gets(char *buf, int max)
{
     5d6:	7179                	addi	sp,sp,-48
     5d8:	f406                	sd	ra,40(sp)
     5da:	f022                	sd	s0,32(sp)
     5dc:	1800                	addi	s0,sp,48
     5de:	fca43c23          	sd	a0,-40(s0)
     5e2:	87ae                	mv	a5,a1
     5e4:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     5e8:	fe042623          	sw	zero,-20(s0)
     5ec:	a8a1                	j	644 <gets+0x6e>
    cc = read(0, &c, 1);
     5ee:	fe740793          	addi	a5,s0,-25
     5f2:	4605                	li	a2,1
     5f4:	85be                	mv	a1,a5
     5f6:	4501                	li	a0,0
     5f8:	00000097          	auipc	ra,0x0
     5fc:	302080e7          	jalr	770(ra) # 8fa <read>
     600:	87aa                	mv	a5,a0
     602:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
     606:	fe842783          	lw	a5,-24(s0)
     60a:	2781                	sext.w	a5,a5
     60c:	04f05663          	blez	a5,658 <gets+0x82>
      break;
    buf[i++] = c;
     610:	fec42783          	lw	a5,-20(s0)
     614:	0017871b          	addiw	a4,a5,1
     618:	fee42623          	sw	a4,-20(s0)
     61c:	873e                	mv	a4,a5
     61e:	fd843783          	ld	a5,-40(s0)
     622:	97ba                	add	a5,a5,a4
     624:	fe744703          	lbu	a4,-25(s0)
     628:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
     62c:	fe744783          	lbu	a5,-25(s0)
     630:	873e                	mv	a4,a5
     632:	47a9                	li	a5,10
     634:	02f70363          	beq	a4,a5,65a <gets+0x84>
     638:	fe744783          	lbu	a5,-25(s0)
     63c:	873e                	mv	a4,a5
     63e:	47b5                	li	a5,13
     640:	00f70d63          	beq	a4,a5,65a <gets+0x84>
  for(i=0; i+1 < max; ){
     644:	fec42783          	lw	a5,-20(s0)
     648:	2785                	addiw	a5,a5,1
     64a:	2781                	sext.w	a5,a5
     64c:	fd442703          	lw	a4,-44(s0)
     650:	2701                	sext.w	a4,a4
     652:	f8e7cee3          	blt	a5,a4,5ee <gets+0x18>
     656:	a011                	j	65a <gets+0x84>
      break;
     658:	0001                	nop
      break;
  }
  buf[i] = '\0';
     65a:	fec42783          	lw	a5,-20(s0)
     65e:	fd843703          	ld	a4,-40(s0)
     662:	97ba                	add	a5,a5,a4
     664:	00078023          	sb	zero,0(a5)
  return buf;
     668:	fd843783          	ld	a5,-40(s0)
}
     66c:	853e                	mv	a0,a5
     66e:	70a2                	ld	ra,40(sp)
     670:	7402                	ld	s0,32(sp)
     672:	6145                	addi	sp,sp,48
     674:	8082                	ret

0000000000000676 <stat>:

int
stat(const char *n, struct stat *st)
{
     676:	7179                	addi	sp,sp,-48
     678:	f406                	sd	ra,40(sp)
     67a:	f022                	sd	s0,32(sp)
     67c:	1800                	addi	s0,sp,48
     67e:	fca43c23          	sd	a0,-40(s0)
     682:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     686:	4581                	li	a1,0
     688:	fd843503          	ld	a0,-40(s0)
     68c:	00000097          	auipc	ra,0x0
     690:	296080e7          	jalr	662(ra) # 922 <open>
     694:	87aa                	mv	a5,a0
     696:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
     69a:	fec42783          	lw	a5,-20(s0)
     69e:	2781                	sext.w	a5,a5
     6a0:	0007d463          	bgez	a5,6a8 <stat+0x32>
    return -1;
     6a4:	57fd                	li	a5,-1
     6a6:	a035                	j	6d2 <stat+0x5c>
  r = fstat(fd, st);
     6a8:	fec42783          	lw	a5,-20(s0)
     6ac:	fd043583          	ld	a1,-48(s0)
     6b0:	853e                	mv	a0,a5
     6b2:	00000097          	auipc	ra,0x0
     6b6:	288080e7          	jalr	648(ra) # 93a <fstat>
     6ba:	87aa                	mv	a5,a0
     6bc:	fef42423          	sw	a5,-24(s0)
  close(fd);
     6c0:	fec42783          	lw	a5,-20(s0)
     6c4:	853e                	mv	a0,a5
     6c6:	00000097          	auipc	ra,0x0
     6ca:	244080e7          	jalr	580(ra) # 90a <close>
  return r;
     6ce:	fe842783          	lw	a5,-24(s0)
}
     6d2:	853e                	mv	a0,a5
     6d4:	70a2                	ld	ra,40(sp)
     6d6:	7402                	ld	s0,32(sp)
     6d8:	6145                	addi	sp,sp,48
     6da:	8082                	ret

00000000000006dc <atoi>:

int
atoi(const char *s)
{
     6dc:	7179                	addi	sp,sp,-48
     6de:	f406                	sd	ra,40(sp)
     6e0:	f022                	sd	s0,32(sp)
     6e2:	1800                	addi	s0,sp,48
     6e4:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
     6e8:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
     6ec:	a81d                	j	722 <atoi+0x46>
    n = n*10 + *s++ - '0';
     6ee:	fec42783          	lw	a5,-20(s0)
     6f2:	873e                	mv	a4,a5
     6f4:	87ba                	mv	a5,a4
     6f6:	0027979b          	slliw	a5,a5,0x2
     6fa:	9fb9                	addw	a5,a5,a4
     6fc:	0017979b          	slliw	a5,a5,0x1
     700:	0007871b          	sext.w	a4,a5
     704:	fd843783          	ld	a5,-40(s0)
     708:	00178693          	addi	a3,a5,1
     70c:	fcd43c23          	sd	a3,-40(s0)
     710:	0007c783          	lbu	a5,0(a5)
     714:	2781                	sext.w	a5,a5
     716:	9fb9                	addw	a5,a5,a4
     718:	2781                	sext.w	a5,a5
     71a:	fd07879b          	addiw	a5,a5,-48
     71e:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
     722:	fd843783          	ld	a5,-40(s0)
     726:	0007c783          	lbu	a5,0(a5)
     72a:	873e                	mv	a4,a5
     72c:	02f00793          	li	a5,47
     730:	00e7fb63          	bgeu	a5,a4,746 <atoi+0x6a>
     734:	fd843783          	ld	a5,-40(s0)
     738:	0007c783          	lbu	a5,0(a5)
     73c:	873e                	mv	a4,a5
     73e:	03900793          	li	a5,57
     742:	fae7f6e3          	bgeu	a5,a4,6ee <atoi+0x12>
  return n;
     746:	fec42783          	lw	a5,-20(s0)
}
     74a:	853e                	mv	a0,a5
     74c:	70a2                	ld	ra,40(sp)
     74e:	7402                	ld	s0,32(sp)
     750:	6145                	addi	sp,sp,48
     752:	8082                	ret

0000000000000754 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     754:	7139                	addi	sp,sp,-64
     756:	fc06                	sd	ra,56(sp)
     758:	f822                	sd	s0,48(sp)
     75a:	0080                	addi	s0,sp,64
     75c:	fca43c23          	sd	a0,-40(s0)
     760:	fcb43823          	sd	a1,-48(s0)
     764:	87b2                	mv	a5,a2
     766:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
     76a:	fd843783          	ld	a5,-40(s0)
     76e:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
     772:	fd043783          	ld	a5,-48(s0)
     776:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
     77a:	fe043703          	ld	a4,-32(s0)
     77e:	fe843783          	ld	a5,-24(s0)
     782:	02e7fc63          	bgeu	a5,a4,7ba <memmove+0x66>
    while(n-- > 0)
     786:	a00d                	j	7a8 <memmove+0x54>
      *dst++ = *src++;
     788:	fe043703          	ld	a4,-32(s0)
     78c:	00170793          	addi	a5,a4,1
     790:	fef43023          	sd	a5,-32(s0)
     794:	fe843783          	ld	a5,-24(s0)
     798:	00178693          	addi	a3,a5,1
     79c:	fed43423          	sd	a3,-24(s0)
     7a0:	00074703          	lbu	a4,0(a4)
     7a4:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
     7a8:	fcc42783          	lw	a5,-52(s0)
     7ac:	fff7871b          	addiw	a4,a5,-1
     7b0:	fce42623          	sw	a4,-52(s0)
     7b4:	fcf04ae3          	bgtz	a5,788 <memmove+0x34>
     7b8:	a891                	j	80c <memmove+0xb8>
  } else {
    dst += n;
     7ba:	fcc42783          	lw	a5,-52(s0)
     7be:	fe843703          	ld	a4,-24(s0)
     7c2:	97ba                	add	a5,a5,a4
     7c4:	fef43423          	sd	a5,-24(s0)
    src += n;
     7c8:	fcc42783          	lw	a5,-52(s0)
     7cc:	fe043703          	ld	a4,-32(s0)
     7d0:	97ba                	add	a5,a5,a4
     7d2:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
     7d6:	a01d                	j	7fc <memmove+0xa8>
      *--dst = *--src;
     7d8:	fe043783          	ld	a5,-32(s0)
     7dc:	17fd                	addi	a5,a5,-1
     7de:	fef43023          	sd	a5,-32(s0)
     7e2:	fe843783          	ld	a5,-24(s0)
     7e6:	17fd                	addi	a5,a5,-1
     7e8:	fef43423          	sd	a5,-24(s0)
     7ec:	fe043783          	ld	a5,-32(s0)
     7f0:	0007c703          	lbu	a4,0(a5)
     7f4:	fe843783          	ld	a5,-24(s0)
     7f8:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
     7fc:	fcc42783          	lw	a5,-52(s0)
     800:	fff7871b          	addiw	a4,a5,-1
     804:	fce42623          	sw	a4,-52(s0)
     808:	fcf048e3          	bgtz	a5,7d8 <memmove+0x84>
  }
  return vdst;
     80c:	fd843783          	ld	a5,-40(s0)
}
     810:	853e                	mv	a0,a5
     812:	70e2                	ld	ra,56(sp)
     814:	7442                	ld	s0,48(sp)
     816:	6121                	addi	sp,sp,64
     818:	8082                	ret

000000000000081a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     81a:	7139                	addi	sp,sp,-64
     81c:	fc06                	sd	ra,56(sp)
     81e:	f822                	sd	s0,48(sp)
     820:	0080                	addi	s0,sp,64
     822:	fca43c23          	sd	a0,-40(s0)
     826:	fcb43823          	sd	a1,-48(s0)
     82a:	87b2                	mv	a5,a2
     82c:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
     830:	fd843783          	ld	a5,-40(s0)
     834:	fef43423          	sd	a5,-24(s0)
     838:	fd043783          	ld	a5,-48(s0)
     83c:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
     840:	a0a1                	j	888 <memcmp+0x6e>
    if (*p1 != *p2) {
     842:	fe843783          	ld	a5,-24(s0)
     846:	0007c703          	lbu	a4,0(a5)
     84a:	fe043783          	ld	a5,-32(s0)
     84e:	0007c783          	lbu	a5,0(a5)
     852:	02f70163          	beq	a4,a5,874 <memcmp+0x5a>
      return *p1 - *p2;
     856:	fe843783          	ld	a5,-24(s0)
     85a:	0007c783          	lbu	a5,0(a5)
     85e:	0007871b          	sext.w	a4,a5
     862:	fe043783          	ld	a5,-32(s0)
     866:	0007c783          	lbu	a5,0(a5)
     86a:	2781                	sext.w	a5,a5
     86c:	40f707bb          	subw	a5,a4,a5
     870:	2781                	sext.w	a5,a5
     872:	a01d                	j	898 <memcmp+0x7e>
    }
    p1++;
     874:	fe843783          	ld	a5,-24(s0)
     878:	0785                	addi	a5,a5,1
     87a:	fef43423          	sd	a5,-24(s0)
    p2++;
     87e:	fe043783          	ld	a5,-32(s0)
     882:	0785                	addi	a5,a5,1
     884:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
     888:	fcc42783          	lw	a5,-52(s0)
     88c:	fff7871b          	addiw	a4,a5,-1
     890:	fce42623          	sw	a4,-52(s0)
     894:	f7dd                	bnez	a5,842 <memcmp+0x28>
  }
  return 0;
     896:	4781                	li	a5,0
}
     898:	853e                	mv	a0,a5
     89a:	70e2                	ld	ra,56(sp)
     89c:	7442                	ld	s0,48(sp)
     89e:	6121                	addi	sp,sp,64
     8a0:	8082                	ret

00000000000008a2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     8a2:	7179                	addi	sp,sp,-48
     8a4:	f406                	sd	ra,40(sp)
     8a6:	f022                	sd	s0,32(sp)
     8a8:	1800                	addi	s0,sp,48
     8aa:	fea43423          	sd	a0,-24(s0)
     8ae:	feb43023          	sd	a1,-32(s0)
     8b2:	87b2                	mv	a5,a2
     8b4:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
     8b8:	fdc42783          	lw	a5,-36(s0)
     8bc:	863e                	mv	a2,a5
     8be:	fe043583          	ld	a1,-32(s0)
     8c2:	fe843503          	ld	a0,-24(s0)
     8c6:	00000097          	auipc	ra,0x0
     8ca:	e8e080e7          	jalr	-370(ra) # 754 <memmove>
     8ce:	87aa                	mv	a5,a0
}
     8d0:	853e                	mv	a0,a5
     8d2:	70a2                	ld	ra,40(sp)
     8d4:	7402                	ld	s0,32(sp)
     8d6:	6145                	addi	sp,sp,48
     8d8:	8082                	ret

00000000000008da <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     8da:	4885                	li	a7,1
 ecall
     8dc:	00000073          	ecall
 ret
     8e0:	8082                	ret

00000000000008e2 <exit>:
.global exit
exit:
 li a7, SYS_exit
     8e2:	4889                	li	a7,2
 ecall
     8e4:	00000073          	ecall
 ret
     8e8:	8082                	ret

00000000000008ea <wait>:
.global wait
wait:
 li a7, SYS_wait
     8ea:	488d                	li	a7,3
 ecall
     8ec:	00000073          	ecall
 ret
     8f0:	8082                	ret

00000000000008f2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     8f2:	4891                	li	a7,4
 ecall
     8f4:	00000073          	ecall
 ret
     8f8:	8082                	ret

00000000000008fa <read>:
.global read
read:
 li a7, SYS_read
     8fa:	4895                	li	a7,5
 ecall
     8fc:	00000073          	ecall
 ret
     900:	8082                	ret

0000000000000902 <write>:
.global write
write:
 li a7, SYS_write
     902:	48c1                	li	a7,16
 ecall
     904:	00000073          	ecall
 ret
     908:	8082                	ret

000000000000090a <close>:
.global close
close:
 li a7, SYS_close
     90a:	48d5                	li	a7,21
 ecall
     90c:	00000073          	ecall
 ret
     910:	8082                	ret

0000000000000912 <kill>:
.global kill
kill:
 li a7, SYS_kill
     912:	4899                	li	a7,6
 ecall
     914:	00000073          	ecall
 ret
     918:	8082                	ret

000000000000091a <exec>:
.global exec
exec:
 li a7, SYS_exec
     91a:	489d                	li	a7,7
 ecall
     91c:	00000073          	ecall
 ret
     920:	8082                	ret

0000000000000922 <open>:
.global open
open:
 li a7, SYS_open
     922:	48bd                	li	a7,15
 ecall
     924:	00000073          	ecall
 ret
     928:	8082                	ret

000000000000092a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     92a:	48c5                	li	a7,17
 ecall
     92c:	00000073          	ecall
 ret
     930:	8082                	ret

0000000000000932 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     932:	48c9                	li	a7,18
 ecall
     934:	00000073          	ecall
 ret
     938:	8082                	ret

000000000000093a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     93a:	48a1                	li	a7,8
 ecall
     93c:	00000073          	ecall
 ret
     940:	8082                	ret

0000000000000942 <link>:
.global link
link:
 li a7, SYS_link
     942:	48cd                	li	a7,19
 ecall
     944:	00000073          	ecall
 ret
     948:	8082                	ret

000000000000094a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     94a:	48d1                	li	a7,20
 ecall
     94c:	00000073          	ecall
 ret
     950:	8082                	ret

0000000000000952 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     952:	48a5                	li	a7,9
 ecall
     954:	00000073          	ecall
 ret
     958:	8082                	ret

000000000000095a <dup>:
.global dup
dup:
 li a7, SYS_dup
     95a:	48a9                	li	a7,10
 ecall
     95c:	00000073          	ecall
 ret
     960:	8082                	ret

0000000000000962 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     962:	48ad                	li	a7,11
 ecall
     964:	00000073          	ecall
 ret
     968:	8082                	ret

000000000000096a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     96a:	48b1                	li	a7,12
 ecall
     96c:	00000073          	ecall
 ret
     970:	8082                	ret

0000000000000972 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     972:	48b5                	li	a7,13
 ecall
     974:	00000073          	ecall
 ret
     978:	8082                	ret

000000000000097a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     97a:	48b9                	li	a7,14
 ecall
     97c:	00000073          	ecall
 ret
     980:	8082                	ret

0000000000000982 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     982:	1101                	addi	sp,sp,-32
     984:	ec06                	sd	ra,24(sp)
     986:	e822                	sd	s0,16(sp)
     988:	1000                	addi	s0,sp,32
     98a:	87aa                	mv	a5,a0
     98c:	872e                	mv	a4,a1
     98e:	fef42623          	sw	a5,-20(s0)
     992:	87ba                	mv	a5,a4
     994:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
     998:	feb40713          	addi	a4,s0,-21
     99c:	fec42783          	lw	a5,-20(s0)
     9a0:	4605                	li	a2,1
     9a2:	85ba                	mv	a1,a4
     9a4:	853e                	mv	a0,a5
     9a6:	00000097          	auipc	ra,0x0
     9aa:	f5c080e7          	jalr	-164(ra) # 902 <write>
}
     9ae:	0001                	nop
     9b0:	60e2                	ld	ra,24(sp)
     9b2:	6442                	ld	s0,16(sp)
     9b4:	6105                	addi	sp,sp,32
     9b6:	8082                	ret

00000000000009b8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     9b8:	7139                	addi	sp,sp,-64
     9ba:	fc06                	sd	ra,56(sp)
     9bc:	f822                	sd	s0,48(sp)
     9be:	0080                	addi	s0,sp,64
     9c0:	87aa                	mv	a5,a0
     9c2:	8736                	mv	a4,a3
     9c4:	fcf42623          	sw	a5,-52(s0)
     9c8:	87ae                	mv	a5,a1
     9ca:	fcf42423          	sw	a5,-56(s0)
     9ce:	87b2                	mv	a5,a2
     9d0:	fcf42223          	sw	a5,-60(s0)
     9d4:	87ba                	mv	a5,a4
     9d6:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     9da:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
     9de:	fc042783          	lw	a5,-64(s0)
     9e2:	2781                	sext.w	a5,a5
     9e4:	c38d                	beqz	a5,a06 <printint+0x4e>
     9e6:	fc842783          	lw	a5,-56(s0)
     9ea:	2781                	sext.w	a5,a5
     9ec:	0007dd63          	bgez	a5,a06 <printint+0x4e>
    neg = 1;
     9f0:	4785                	li	a5,1
     9f2:	fef42423          	sw	a5,-24(s0)
    x = -xx;
     9f6:	fc842783          	lw	a5,-56(s0)
     9fa:	40f007bb          	negw	a5,a5
     9fe:	2781                	sext.w	a5,a5
     a00:	fef42223          	sw	a5,-28(s0)
     a04:	a029                	j	a0e <printint+0x56>
  } else {
    x = xx;
     a06:	fc842783          	lw	a5,-56(s0)
     a0a:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
     a0e:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
     a12:	fc442783          	lw	a5,-60(s0)
     a16:	fe442703          	lw	a4,-28(s0)
     a1a:	02f777bb          	remuw	a5,a4,a5
     a1e:	0007871b          	sext.w	a4,a5
     a22:	fec42783          	lw	a5,-20(s0)
     a26:	0017869b          	addiw	a3,a5,1
     a2a:	fed42623          	sw	a3,-20(s0)
     a2e:	00001697          	auipc	a3,0x1
     a32:	5d268693          	addi	a3,a3,1490 # 2000 <digits>
     a36:	1702                	slli	a4,a4,0x20
     a38:	9301                	srli	a4,a4,0x20
     a3a:	9736                	add	a4,a4,a3
     a3c:	00074703          	lbu	a4,0(a4)
     a40:	17c1                	addi	a5,a5,-16
     a42:	97a2                	add	a5,a5,s0
     a44:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
     a48:	fc442783          	lw	a5,-60(s0)
     a4c:	fe442703          	lw	a4,-28(s0)
     a50:	02f757bb          	divuw	a5,a4,a5
     a54:	fef42223          	sw	a5,-28(s0)
     a58:	fe442783          	lw	a5,-28(s0)
     a5c:	2781                	sext.w	a5,a5
     a5e:	fbd5                	bnez	a5,a12 <printint+0x5a>
  if(neg)
     a60:	fe842783          	lw	a5,-24(s0)
     a64:	2781                	sext.w	a5,a5
     a66:	cf85                	beqz	a5,a9e <printint+0xe6>
    buf[i++] = '-';
     a68:	fec42783          	lw	a5,-20(s0)
     a6c:	0017871b          	addiw	a4,a5,1
     a70:	fee42623          	sw	a4,-20(s0)
     a74:	17c1                	addi	a5,a5,-16
     a76:	97a2                	add	a5,a5,s0
     a78:	02d00713          	li	a4,45
     a7c:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
     a80:	a839                	j	a9e <printint+0xe6>
    putc(fd, buf[i]);
     a82:	fec42783          	lw	a5,-20(s0)
     a86:	17c1                	addi	a5,a5,-16
     a88:	97a2                	add	a5,a5,s0
     a8a:	fe07c703          	lbu	a4,-32(a5)
     a8e:	fcc42783          	lw	a5,-52(s0)
     a92:	85ba                	mv	a1,a4
     a94:	853e                	mv	a0,a5
     a96:	00000097          	auipc	ra,0x0
     a9a:	eec080e7          	jalr	-276(ra) # 982 <putc>
  while(--i >= 0)
     a9e:	fec42783          	lw	a5,-20(s0)
     aa2:	37fd                	addiw	a5,a5,-1
     aa4:	fef42623          	sw	a5,-20(s0)
     aa8:	fec42783          	lw	a5,-20(s0)
     aac:	2781                	sext.w	a5,a5
     aae:	fc07dae3          	bgez	a5,a82 <printint+0xca>
}
     ab2:	0001                	nop
     ab4:	0001                	nop
     ab6:	70e2                	ld	ra,56(sp)
     ab8:	7442                	ld	s0,48(sp)
     aba:	6121                	addi	sp,sp,64
     abc:	8082                	ret

0000000000000abe <printptr>:

static void
printptr(int fd, uint64 x) {
     abe:	7179                	addi	sp,sp,-48
     ac0:	f406                	sd	ra,40(sp)
     ac2:	f022                	sd	s0,32(sp)
     ac4:	1800                	addi	s0,sp,48
     ac6:	87aa                	mv	a5,a0
     ac8:	fcb43823          	sd	a1,-48(s0)
     acc:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
     ad0:	fdc42783          	lw	a5,-36(s0)
     ad4:	03000593          	li	a1,48
     ad8:	853e                	mv	a0,a5
     ada:	00000097          	auipc	ra,0x0
     ade:	ea8080e7          	jalr	-344(ra) # 982 <putc>
  putc(fd, 'x');
     ae2:	fdc42783          	lw	a5,-36(s0)
     ae6:	07800593          	li	a1,120
     aea:	853e                	mv	a0,a5
     aec:	00000097          	auipc	ra,0x0
     af0:	e96080e7          	jalr	-362(ra) # 982 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     af4:	fe042623          	sw	zero,-20(s0)
     af8:	a82d                	j	b32 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     afa:	fd043783          	ld	a5,-48(s0)
     afe:	93f1                	srli	a5,a5,0x3c
     b00:	00001717          	auipc	a4,0x1
     b04:	50070713          	addi	a4,a4,1280 # 2000 <digits>
     b08:	97ba                	add	a5,a5,a4
     b0a:	0007c703          	lbu	a4,0(a5)
     b0e:	fdc42783          	lw	a5,-36(s0)
     b12:	85ba                	mv	a1,a4
     b14:	853e                	mv	a0,a5
     b16:	00000097          	auipc	ra,0x0
     b1a:	e6c080e7          	jalr	-404(ra) # 982 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     b1e:	fec42783          	lw	a5,-20(s0)
     b22:	2785                	addiw	a5,a5,1
     b24:	fef42623          	sw	a5,-20(s0)
     b28:	fd043783          	ld	a5,-48(s0)
     b2c:	0792                	slli	a5,a5,0x4
     b2e:	fcf43823          	sd	a5,-48(s0)
     b32:	fec42703          	lw	a4,-20(s0)
     b36:	47bd                	li	a5,15
     b38:	fce7f1e3          	bgeu	a5,a4,afa <printptr+0x3c>
}
     b3c:	0001                	nop
     b3e:	0001                	nop
     b40:	70a2                	ld	ra,40(sp)
     b42:	7402                	ld	s0,32(sp)
     b44:	6145                	addi	sp,sp,48
     b46:	8082                	ret

0000000000000b48 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     b48:	715d                	addi	sp,sp,-80
     b4a:	e486                	sd	ra,72(sp)
     b4c:	e0a2                	sd	s0,64(sp)
     b4e:	0880                	addi	s0,sp,80
     b50:	87aa                	mv	a5,a0
     b52:	fcb43023          	sd	a1,-64(s0)
     b56:	fac43c23          	sd	a2,-72(s0)
     b5a:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
     b5e:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
     b62:	fe042223          	sw	zero,-28(s0)
     b66:	a42d                	j	d90 <vprintf+0x248>
    c = fmt[i] & 0xff;
     b68:	fe442783          	lw	a5,-28(s0)
     b6c:	fc043703          	ld	a4,-64(s0)
     b70:	97ba                	add	a5,a5,a4
     b72:	0007c783          	lbu	a5,0(a5)
     b76:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
     b7a:	fe042783          	lw	a5,-32(s0)
     b7e:	2781                	sext.w	a5,a5
     b80:	eb9d                	bnez	a5,bb6 <vprintf+0x6e>
      if(c == '%'){
     b82:	fdc42783          	lw	a5,-36(s0)
     b86:	0007871b          	sext.w	a4,a5
     b8a:	02500793          	li	a5,37
     b8e:	00f71763          	bne	a4,a5,b9c <vprintf+0x54>
        state = '%';
     b92:	02500793          	li	a5,37
     b96:	fef42023          	sw	a5,-32(s0)
     b9a:	a2f5                	j	d86 <vprintf+0x23e>
      } else {
        putc(fd, c);
     b9c:	fdc42783          	lw	a5,-36(s0)
     ba0:	0ff7f713          	zext.b	a4,a5
     ba4:	fcc42783          	lw	a5,-52(s0)
     ba8:	85ba                	mv	a1,a4
     baa:	853e                	mv	a0,a5
     bac:	00000097          	auipc	ra,0x0
     bb0:	dd6080e7          	jalr	-554(ra) # 982 <putc>
     bb4:	aac9                	j	d86 <vprintf+0x23e>
      }
    } else if(state == '%'){
     bb6:	fe042783          	lw	a5,-32(s0)
     bba:	0007871b          	sext.w	a4,a5
     bbe:	02500793          	li	a5,37
     bc2:	1cf71263          	bne	a4,a5,d86 <vprintf+0x23e>
      if(c == 'd'){
     bc6:	fdc42783          	lw	a5,-36(s0)
     bca:	0007871b          	sext.w	a4,a5
     bce:	06400793          	li	a5,100
     bd2:	02f71463          	bne	a4,a5,bfa <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
     bd6:	fb843783          	ld	a5,-72(s0)
     bda:	00878713          	addi	a4,a5,8
     bde:	fae43c23          	sd	a4,-72(s0)
     be2:	4398                	lw	a4,0(a5)
     be4:	fcc42783          	lw	a5,-52(s0)
     be8:	4685                	li	a3,1
     bea:	4629                	li	a2,10
     bec:	85ba                	mv	a1,a4
     bee:	853e                	mv	a0,a5
     bf0:	00000097          	auipc	ra,0x0
     bf4:	dc8080e7          	jalr	-568(ra) # 9b8 <printint>
     bf8:	a269                	j	d82 <vprintf+0x23a>
      } else if(c == 'l') {
     bfa:	fdc42783          	lw	a5,-36(s0)
     bfe:	0007871b          	sext.w	a4,a5
     c02:	06c00793          	li	a5,108
     c06:	02f71663          	bne	a4,a5,c32 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
     c0a:	fb843783          	ld	a5,-72(s0)
     c0e:	00878713          	addi	a4,a5,8
     c12:	fae43c23          	sd	a4,-72(s0)
     c16:	639c                	ld	a5,0(a5)
     c18:	0007871b          	sext.w	a4,a5
     c1c:	fcc42783          	lw	a5,-52(s0)
     c20:	4681                	li	a3,0
     c22:	4629                	li	a2,10
     c24:	85ba                	mv	a1,a4
     c26:	853e                	mv	a0,a5
     c28:	00000097          	auipc	ra,0x0
     c2c:	d90080e7          	jalr	-624(ra) # 9b8 <printint>
     c30:	aa89                	j	d82 <vprintf+0x23a>
      } else if(c == 'x') {
     c32:	fdc42783          	lw	a5,-36(s0)
     c36:	0007871b          	sext.w	a4,a5
     c3a:	07800793          	li	a5,120
     c3e:	02f71463          	bne	a4,a5,c66 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
     c42:	fb843783          	ld	a5,-72(s0)
     c46:	00878713          	addi	a4,a5,8
     c4a:	fae43c23          	sd	a4,-72(s0)
     c4e:	4398                	lw	a4,0(a5)
     c50:	fcc42783          	lw	a5,-52(s0)
     c54:	4681                	li	a3,0
     c56:	4641                	li	a2,16
     c58:	85ba                	mv	a1,a4
     c5a:	853e                	mv	a0,a5
     c5c:	00000097          	auipc	ra,0x0
     c60:	d5c080e7          	jalr	-676(ra) # 9b8 <printint>
     c64:	aa39                	j	d82 <vprintf+0x23a>
      } else if(c == 'p') {
     c66:	fdc42783          	lw	a5,-36(s0)
     c6a:	0007871b          	sext.w	a4,a5
     c6e:	07000793          	li	a5,112
     c72:	02f71263          	bne	a4,a5,c96 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
     c76:	fb843783          	ld	a5,-72(s0)
     c7a:	00878713          	addi	a4,a5,8
     c7e:	fae43c23          	sd	a4,-72(s0)
     c82:	6398                	ld	a4,0(a5)
     c84:	fcc42783          	lw	a5,-52(s0)
     c88:	85ba                	mv	a1,a4
     c8a:	853e                	mv	a0,a5
     c8c:	00000097          	auipc	ra,0x0
     c90:	e32080e7          	jalr	-462(ra) # abe <printptr>
     c94:	a0fd                	j	d82 <vprintf+0x23a>
      } else if(c == 's'){
     c96:	fdc42783          	lw	a5,-36(s0)
     c9a:	0007871b          	sext.w	a4,a5
     c9e:	07300793          	li	a5,115
     ca2:	04f71c63          	bne	a4,a5,cfa <vprintf+0x1b2>
        s = va_arg(ap, char*);
     ca6:	fb843783          	ld	a5,-72(s0)
     caa:	00878713          	addi	a4,a5,8
     cae:	fae43c23          	sd	a4,-72(s0)
     cb2:	639c                	ld	a5,0(a5)
     cb4:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
     cb8:	fe843783          	ld	a5,-24(s0)
     cbc:	eb8d                	bnez	a5,cee <vprintf+0x1a6>
          s = "(null)";
     cbe:	00000797          	auipc	a5,0x0
     cc2:	4ba78793          	addi	a5,a5,1210 # 1178 <malloc+0x17e>
     cc6:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
     cca:	a015                	j	cee <vprintf+0x1a6>
          putc(fd, *s);
     ccc:	fe843783          	ld	a5,-24(s0)
     cd0:	0007c703          	lbu	a4,0(a5)
     cd4:	fcc42783          	lw	a5,-52(s0)
     cd8:	85ba                	mv	a1,a4
     cda:	853e                	mv	a0,a5
     cdc:	00000097          	auipc	ra,0x0
     ce0:	ca6080e7          	jalr	-858(ra) # 982 <putc>
          s++;
     ce4:	fe843783          	ld	a5,-24(s0)
     ce8:	0785                	addi	a5,a5,1
     cea:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
     cee:	fe843783          	ld	a5,-24(s0)
     cf2:	0007c783          	lbu	a5,0(a5)
     cf6:	fbf9                	bnez	a5,ccc <vprintf+0x184>
     cf8:	a069                	j	d82 <vprintf+0x23a>
        }
      } else if(c == 'c'){
     cfa:	fdc42783          	lw	a5,-36(s0)
     cfe:	0007871b          	sext.w	a4,a5
     d02:	06300793          	li	a5,99
     d06:	02f71463          	bne	a4,a5,d2e <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
     d0a:	fb843783          	ld	a5,-72(s0)
     d0e:	00878713          	addi	a4,a5,8
     d12:	fae43c23          	sd	a4,-72(s0)
     d16:	439c                	lw	a5,0(a5)
     d18:	0ff7f713          	zext.b	a4,a5
     d1c:	fcc42783          	lw	a5,-52(s0)
     d20:	85ba                	mv	a1,a4
     d22:	853e                	mv	a0,a5
     d24:	00000097          	auipc	ra,0x0
     d28:	c5e080e7          	jalr	-930(ra) # 982 <putc>
     d2c:	a899                	j	d82 <vprintf+0x23a>
      } else if(c == '%'){
     d2e:	fdc42783          	lw	a5,-36(s0)
     d32:	0007871b          	sext.w	a4,a5
     d36:	02500793          	li	a5,37
     d3a:	00f71f63          	bne	a4,a5,d58 <vprintf+0x210>
        putc(fd, c);
     d3e:	fdc42783          	lw	a5,-36(s0)
     d42:	0ff7f713          	zext.b	a4,a5
     d46:	fcc42783          	lw	a5,-52(s0)
     d4a:	85ba                	mv	a1,a4
     d4c:	853e                	mv	a0,a5
     d4e:	00000097          	auipc	ra,0x0
     d52:	c34080e7          	jalr	-972(ra) # 982 <putc>
     d56:	a035                	j	d82 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     d58:	fcc42783          	lw	a5,-52(s0)
     d5c:	02500593          	li	a1,37
     d60:	853e                	mv	a0,a5
     d62:	00000097          	auipc	ra,0x0
     d66:	c20080e7          	jalr	-992(ra) # 982 <putc>
        putc(fd, c);
     d6a:	fdc42783          	lw	a5,-36(s0)
     d6e:	0ff7f713          	zext.b	a4,a5
     d72:	fcc42783          	lw	a5,-52(s0)
     d76:	85ba                	mv	a1,a4
     d78:	853e                	mv	a0,a5
     d7a:	00000097          	auipc	ra,0x0
     d7e:	c08080e7          	jalr	-1016(ra) # 982 <putc>
      }
      state = 0;
     d82:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
     d86:	fe442783          	lw	a5,-28(s0)
     d8a:	2785                	addiw	a5,a5,1
     d8c:	fef42223          	sw	a5,-28(s0)
     d90:	fe442783          	lw	a5,-28(s0)
     d94:	fc043703          	ld	a4,-64(s0)
     d98:	97ba                	add	a5,a5,a4
     d9a:	0007c783          	lbu	a5,0(a5)
     d9e:	dc0795e3          	bnez	a5,b68 <vprintf+0x20>
    }
  }
}
     da2:	0001                	nop
     da4:	0001                	nop
     da6:	60a6                	ld	ra,72(sp)
     da8:	6406                	ld	s0,64(sp)
     daa:	6161                	addi	sp,sp,80
     dac:	8082                	ret

0000000000000dae <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     dae:	7159                	addi	sp,sp,-112
     db0:	fc06                	sd	ra,56(sp)
     db2:	f822                	sd	s0,48(sp)
     db4:	0080                	addi	s0,sp,64
     db6:	fcb43823          	sd	a1,-48(s0)
     dba:	e010                	sd	a2,0(s0)
     dbc:	e414                	sd	a3,8(s0)
     dbe:	e818                	sd	a4,16(s0)
     dc0:	ec1c                	sd	a5,24(s0)
     dc2:	03043023          	sd	a6,32(s0)
     dc6:	03143423          	sd	a7,40(s0)
     dca:	87aa                	mv	a5,a0
     dcc:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
     dd0:	03040793          	addi	a5,s0,48
     dd4:	fcf43423          	sd	a5,-56(s0)
     dd8:	fc843783          	ld	a5,-56(s0)
     ddc:	fd078793          	addi	a5,a5,-48
     de0:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
     de4:	fe843703          	ld	a4,-24(s0)
     de8:	fdc42783          	lw	a5,-36(s0)
     dec:	863a                	mv	a2,a4
     dee:	fd043583          	ld	a1,-48(s0)
     df2:	853e                	mv	a0,a5
     df4:	00000097          	auipc	ra,0x0
     df8:	d54080e7          	jalr	-684(ra) # b48 <vprintf>
}
     dfc:	0001                	nop
     dfe:	70e2                	ld	ra,56(sp)
     e00:	7442                	ld	s0,48(sp)
     e02:	6165                	addi	sp,sp,112
     e04:	8082                	ret

0000000000000e06 <printf>:

void
printf(const char *fmt, ...)
{
     e06:	7159                	addi	sp,sp,-112
     e08:	f406                	sd	ra,40(sp)
     e0a:	f022                	sd	s0,32(sp)
     e0c:	1800                	addi	s0,sp,48
     e0e:	fca43c23          	sd	a0,-40(s0)
     e12:	e40c                	sd	a1,8(s0)
     e14:	e810                	sd	a2,16(s0)
     e16:	ec14                	sd	a3,24(s0)
     e18:	f018                	sd	a4,32(s0)
     e1a:	f41c                	sd	a5,40(s0)
     e1c:	03043823          	sd	a6,48(s0)
     e20:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     e24:	04040793          	addi	a5,s0,64
     e28:	fcf43823          	sd	a5,-48(s0)
     e2c:	fd043783          	ld	a5,-48(s0)
     e30:	fc878793          	addi	a5,a5,-56
     e34:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
     e38:	fe843783          	ld	a5,-24(s0)
     e3c:	863e                	mv	a2,a5
     e3e:	fd843583          	ld	a1,-40(s0)
     e42:	4505                	li	a0,1
     e44:	00000097          	auipc	ra,0x0
     e48:	d04080e7          	jalr	-764(ra) # b48 <vprintf>
}
     e4c:	0001                	nop
     e4e:	70a2                	ld	ra,40(sp)
     e50:	7402                	ld	s0,32(sp)
     e52:	6165                	addi	sp,sp,112
     e54:	8082                	ret

0000000000000e56 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     e56:	7179                	addi	sp,sp,-48
     e58:	f406                	sd	ra,40(sp)
     e5a:	f022                	sd	s0,32(sp)
     e5c:	1800                	addi	s0,sp,48
     e5e:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
     e62:	fd843783          	ld	a5,-40(s0)
     e66:	17c1                	addi	a5,a5,-16
     e68:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     e6c:	00001797          	auipc	a5,0x1
     e70:	5c478793          	addi	a5,a5,1476 # 2430 <freep>
     e74:	639c                	ld	a5,0(a5)
     e76:	fef43423          	sd	a5,-24(s0)
     e7a:	a815                	j	eae <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     e7c:	fe843783          	ld	a5,-24(s0)
     e80:	639c                	ld	a5,0(a5)
     e82:	fe843703          	ld	a4,-24(s0)
     e86:	00f76f63          	bltu	a4,a5,ea4 <free+0x4e>
     e8a:	fe043703          	ld	a4,-32(s0)
     e8e:	fe843783          	ld	a5,-24(s0)
     e92:	02e7eb63          	bltu	a5,a4,ec8 <free+0x72>
     e96:	fe843783          	ld	a5,-24(s0)
     e9a:	639c                	ld	a5,0(a5)
     e9c:	fe043703          	ld	a4,-32(s0)
     ea0:	02f76463          	bltu	a4,a5,ec8 <free+0x72>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     ea4:	fe843783          	ld	a5,-24(s0)
     ea8:	639c                	ld	a5,0(a5)
     eaa:	fef43423          	sd	a5,-24(s0)
     eae:	fe043703          	ld	a4,-32(s0)
     eb2:	fe843783          	ld	a5,-24(s0)
     eb6:	fce7f3e3          	bgeu	a5,a4,e7c <free+0x26>
     eba:	fe843783          	ld	a5,-24(s0)
     ebe:	639c                	ld	a5,0(a5)
     ec0:	fe043703          	ld	a4,-32(s0)
     ec4:	faf77ce3          	bgeu	a4,a5,e7c <free+0x26>
      break;
  if(bp + bp->s.size == p->s.ptr){
     ec8:	fe043783          	ld	a5,-32(s0)
     ecc:	479c                	lw	a5,8(a5)
     ece:	1782                	slli	a5,a5,0x20
     ed0:	9381                	srli	a5,a5,0x20
     ed2:	0792                	slli	a5,a5,0x4
     ed4:	fe043703          	ld	a4,-32(s0)
     ed8:	973e                	add	a4,a4,a5
     eda:	fe843783          	ld	a5,-24(s0)
     ede:	639c                	ld	a5,0(a5)
     ee0:	02f71763          	bne	a4,a5,f0e <free+0xb8>
    bp->s.size += p->s.ptr->s.size;
     ee4:	fe043783          	ld	a5,-32(s0)
     ee8:	4798                	lw	a4,8(a5)
     eea:	fe843783          	ld	a5,-24(s0)
     eee:	639c                	ld	a5,0(a5)
     ef0:	479c                	lw	a5,8(a5)
     ef2:	9fb9                	addw	a5,a5,a4
     ef4:	0007871b          	sext.w	a4,a5
     ef8:	fe043783          	ld	a5,-32(s0)
     efc:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
     efe:	fe843783          	ld	a5,-24(s0)
     f02:	639c                	ld	a5,0(a5)
     f04:	6398                	ld	a4,0(a5)
     f06:	fe043783          	ld	a5,-32(s0)
     f0a:	e398                	sd	a4,0(a5)
     f0c:	a039                	j	f1a <free+0xc4>
  } else
    bp->s.ptr = p->s.ptr;
     f0e:	fe843783          	ld	a5,-24(s0)
     f12:	6398                	ld	a4,0(a5)
     f14:	fe043783          	ld	a5,-32(s0)
     f18:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
     f1a:	fe843783          	ld	a5,-24(s0)
     f1e:	479c                	lw	a5,8(a5)
     f20:	1782                	slli	a5,a5,0x20
     f22:	9381                	srli	a5,a5,0x20
     f24:	0792                	slli	a5,a5,0x4
     f26:	fe843703          	ld	a4,-24(s0)
     f2a:	97ba                	add	a5,a5,a4
     f2c:	fe043703          	ld	a4,-32(s0)
     f30:	02f71563          	bne	a4,a5,f5a <free+0x104>
    p->s.size += bp->s.size;
     f34:	fe843783          	ld	a5,-24(s0)
     f38:	4798                	lw	a4,8(a5)
     f3a:	fe043783          	ld	a5,-32(s0)
     f3e:	479c                	lw	a5,8(a5)
     f40:	9fb9                	addw	a5,a5,a4
     f42:	0007871b          	sext.w	a4,a5
     f46:	fe843783          	ld	a5,-24(s0)
     f4a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
     f4c:	fe043783          	ld	a5,-32(s0)
     f50:	6398                	ld	a4,0(a5)
     f52:	fe843783          	ld	a5,-24(s0)
     f56:	e398                	sd	a4,0(a5)
     f58:	a031                	j	f64 <free+0x10e>
  } else
    p->s.ptr = bp;
     f5a:	fe843783          	ld	a5,-24(s0)
     f5e:	fe043703          	ld	a4,-32(s0)
     f62:	e398                	sd	a4,0(a5)
  freep = p;
     f64:	00001797          	auipc	a5,0x1
     f68:	4cc78793          	addi	a5,a5,1228 # 2430 <freep>
     f6c:	fe843703          	ld	a4,-24(s0)
     f70:	e398                	sd	a4,0(a5)
}
     f72:	0001                	nop
     f74:	70a2                	ld	ra,40(sp)
     f76:	7402                	ld	s0,32(sp)
     f78:	6145                	addi	sp,sp,48
     f7a:	8082                	ret

0000000000000f7c <morecore>:

static Header*
morecore(uint nu)
{
     f7c:	7179                	addi	sp,sp,-48
     f7e:	f406                	sd	ra,40(sp)
     f80:	f022                	sd	s0,32(sp)
     f82:	1800                	addi	s0,sp,48
     f84:	87aa                	mv	a5,a0
     f86:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
     f8a:	fdc42783          	lw	a5,-36(s0)
     f8e:	0007871b          	sext.w	a4,a5
     f92:	6785                	lui	a5,0x1
     f94:	00f77563          	bgeu	a4,a5,f9e <morecore+0x22>
    nu = 4096;
     f98:	6785                	lui	a5,0x1
     f9a:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
     f9e:	fdc42783          	lw	a5,-36(s0)
     fa2:	0047979b          	slliw	a5,a5,0x4
     fa6:	2781                	sext.w	a5,a5
     fa8:	853e                	mv	a0,a5
     faa:	00000097          	auipc	ra,0x0
     fae:	9c0080e7          	jalr	-1600(ra) # 96a <sbrk>
     fb2:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
     fb6:	fe843703          	ld	a4,-24(s0)
     fba:	57fd                	li	a5,-1
     fbc:	00f71463          	bne	a4,a5,fc4 <morecore+0x48>
    return 0;
     fc0:	4781                	li	a5,0
     fc2:	a03d                	j	ff0 <morecore+0x74>
  hp = (Header*)p;
     fc4:	fe843783          	ld	a5,-24(s0)
     fc8:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
     fcc:	fe043783          	ld	a5,-32(s0)
     fd0:	fdc42703          	lw	a4,-36(s0)
     fd4:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
     fd6:	fe043783          	ld	a5,-32(s0)
     fda:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x16>
     fdc:	853e                	mv	a0,a5
     fde:	00000097          	auipc	ra,0x0
     fe2:	e78080e7          	jalr	-392(ra) # e56 <free>
  return freep;
     fe6:	00001797          	auipc	a5,0x1
     fea:	44a78793          	addi	a5,a5,1098 # 2430 <freep>
     fee:	639c                	ld	a5,0(a5)
}
     ff0:	853e                	mv	a0,a5
     ff2:	70a2                	ld	ra,40(sp)
     ff4:	7402                	ld	s0,32(sp)
     ff6:	6145                	addi	sp,sp,48
     ff8:	8082                	ret

0000000000000ffa <malloc>:

void*
malloc(uint nbytes)
{
     ffa:	7139                	addi	sp,sp,-64
     ffc:	fc06                	sd	ra,56(sp)
     ffe:	f822                	sd	s0,48(sp)
    1000:	0080                	addi	s0,sp,64
    1002:	87aa                	mv	a5,a0
    1004:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1008:	fcc46783          	lwu	a5,-52(s0)
    100c:	07bd                	addi	a5,a5,15
    100e:	8391                	srli	a5,a5,0x4
    1010:	2781                	sext.w	a5,a5
    1012:	2785                	addiw	a5,a5,1
    1014:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
    1018:	00001797          	auipc	a5,0x1
    101c:	41878793          	addi	a5,a5,1048 # 2430 <freep>
    1020:	639c                	ld	a5,0(a5)
    1022:	fef43023          	sd	a5,-32(s0)
    1026:	fe043783          	ld	a5,-32(s0)
    102a:	ef95                	bnez	a5,1066 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
    102c:	00001797          	auipc	a5,0x1
    1030:	3f478793          	addi	a5,a5,1012 # 2420 <base>
    1034:	fef43023          	sd	a5,-32(s0)
    1038:	00001797          	auipc	a5,0x1
    103c:	3f878793          	addi	a5,a5,1016 # 2430 <freep>
    1040:	fe043703          	ld	a4,-32(s0)
    1044:	e398                	sd	a4,0(a5)
    1046:	00001797          	auipc	a5,0x1
    104a:	3ea78793          	addi	a5,a5,1002 # 2430 <freep>
    104e:	6398                	ld	a4,0(a5)
    1050:	00001797          	auipc	a5,0x1
    1054:	3d078793          	addi	a5,a5,976 # 2420 <base>
    1058:	e398                	sd	a4,0(a5)
    base.s.size = 0;
    105a:	00001797          	auipc	a5,0x1
    105e:	3c678793          	addi	a5,a5,966 # 2420 <base>
    1062:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1066:	fe043783          	ld	a5,-32(s0)
    106a:	639c                	ld	a5,0(a5)
    106c:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
    1070:	fe843783          	ld	a5,-24(s0)
    1074:	479c                	lw	a5,8(a5)
    1076:	fdc42703          	lw	a4,-36(s0)
    107a:	2701                	sext.w	a4,a4
    107c:	06e7e763          	bltu	a5,a4,10ea <malloc+0xf0>
      if(p->s.size == nunits)
    1080:	fe843783          	ld	a5,-24(s0)
    1084:	479c                	lw	a5,8(a5)
    1086:	fdc42703          	lw	a4,-36(s0)
    108a:	2701                	sext.w	a4,a4
    108c:	00f71963          	bne	a4,a5,109e <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
    1090:	fe843783          	ld	a5,-24(s0)
    1094:	6398                	ld	a4,0(a5)
    1096:	fe043783          	ld	a5,-32(s0)
    109a:	e398                	sd	a4,0(a5)
    109c:	a825                	j	10d4 <malloc+0xda>
      else {
        p->s.size -= nunits;
    109e:	fe843783          	ld	a5,-24(s0)
    10a2:	479c                	lw	a5,8(a5)
    10a4:	fdc42703          	lw	a4,-36(s0)
    10a8:	9f99                	subw	a5,a5,a4
    10aa:	0007871b          	sext.w	a4,a5
    10ae:	fe843783          	ld	a5,-24(s0)
    10b2:	c798                	sw	a4,8(a5)
        p += p->s.size;
    10b4:	fe843783          	ld	a5,-24(s0)
    10b8:	479c                	lw	a5,8(a5)
    10ba:	1782                	slli	a5,a5,0x20
    10bc:	9381                	srli	a5,a5,0x20
    10be:	0792                	slli	a5,a5,0x4
    10c0:	fe843703          	ld	a4,-24(s0)
    10c4:	97ba                	add	a5,a5,a4
    10c6:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
    10ca:	fe843783          	ld	a5,-24(s0)
    10ce:	fdc42703          	lw	a4,-36(s0)
    10d2:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
    10d4:	00001797          	auipc	a5,0x1
    10d8:	35c78793          	addi	a5,a5,860 # 2430 <freep>
    10dc:	fe043703          	ld	a4,-32(s0)
    10e0:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
    10e2:	fe843783          	ld	a5,-24(s0)
    10e6:	07c1                	addi	a5,a5,16
    10e8:	a091                	j	112c <malloc+0x132>
    }
    if(p == freep)
    10ea:	00001797          	auipc	a5,0x1
    10ee:	34678793          	addi	a5,a5,838 # 2430 <freep>
    10f2:	639c                	ld	a5,0(a5)
    10f4:	fe843703          	ld	a4,-24(s0)
    10f8:	02f71063          	bne	a4,a5,1118 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
    10fc:	fdc42783          	lw	a5,-36(s0)
    1100:	853e                	mv	a0,a5
    1102:	00000097          	auipc	ra,0x0
    1106:	e7a080e7          	jalr	-390(ra) # f7c <morecore>
    110a:	fea43423          	sd	a0,-24(s0)
    110e:	fe843783          	ld	a5,-24(s0)
    1112:	e399                	bnez	a5,1118 <malloc+0x11e>
        return 0;
    1114:	4781                	li	a5,0
    1116:	a819                	j	112c <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1118:	fe843783          	ld	a5,-24(s0)
    111c:	fef43023          	sd	a5,-32(s0)
    1120:	fe843783          	ld	a5,-24(s0)
    1124:	639c                	ld	a5,0(a5)
    1126:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
    112a:	b799                	j	1070 <malloc+0x76>
  }
}
    112c:	853e                	mv	a0,a5
    112e:	70e2                	ld	ra,56(sp)
    1130:	7442                	ld	s0,48(sp)
    1132:	6121                	addi	sp,sp,64
    1134:	8082                	ret
