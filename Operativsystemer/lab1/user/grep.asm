
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
     168:	fdc58593          	addi	a1,a1,-36 # 1140 <malloc+0x13e>
     16c:	4509                	li	a0,2
     16e:	00001097          	auipc	ra,0x1
     172:	c48080e7          	jalr	-952(ra) # db6 <fprintf>
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
     1f6:	f6e50513          	addi	a0,a0,-146 # 1160 <malloc+0x15e>
     1fa:	00001097          	auipc	ra,0x1
     1fe:	c14080e7          	jalr	-1004(ra) # e0e <printf>
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

0000000000000982 <ps>:
.global ps
ps:
 li a7, SYS_ps
     982:	48d9                	li	a7,22
 ecall
     984:	00000073          	ecall
 ret
     988:	8082                	ret

000000000000098a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     98a:	1101                	addi	sp,sp,-32
     98c:	ec06                	sd	ra,24(sp)
     98e:	e822                	sd	s0,16(sp)
     990:	1000                	addi	s0,sp,32
     992:	87aa                	mv	a5,a0
     994:	872e                	mv	a4,a1
     996:	fef42623          	sw	a5,-20(s0)
     99a:	87ba                	mv	a5,a4
     99c:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
     9a0:	feb40713          	addi	a4,s0,-21
     9a4:	fec42783          	lw	a5,-20(s0)
     9a8:	4605                	li	a2,1
     9aa:	85ba                	mv	a1,a4
     9ac:	853e                	mv	a0,a5
     9ae:	00000097          	auipc	ra,0x0
     9b2:	f54080e7          	jalr	-172(ra) # 902 <write>
}
     9b6:	0001                	nop
     9b8:	60e2                	ld	ra,24(sp)
     9ba:	6442                	ld	s0,16(sp)
     9bc:	6105                	addi	sp,sp,32
     9be:	8082                	ret

00000000000009c0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     9c0:	7139                	addi	sp,sp,-64
     9c2:	fc06                	sd	ra,56(sp)
     9c4:	f822                	sd	s0,48(sp)
     9c6:	0080                	addi	s0,sp,64
     9c8:	87aa                	mv	a5,a0
     9ca:	8736                	mv	a4,a3
     9cc:	fcf42623          	sw	a5,-52(s0)
     9d0:	87ae                	mv	a5,a1
     9d2:	fcf42423          	sw	a5,-56(s0)
     9d6:	87b2                	mv	a5,a2
     9d8:	fcf42223          	sw	a5,-60(s0)
     9dc:	87ba                	mv	a5,a4
     9de:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     9e2:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
     9e6:	fc042783          	lw	a5,-64(s0)
     9ea:	2781                	sext.w	a5,a5
     9ec:	c38d                	beqz	a5,a0e <printint+0x4e>
     9ee:	fc842783          	lw	a5,-56(s0)
     9f2:	2781                	sext.w	a5,a5
     9f4:	0007dd63          	bgez	a5,a0e <printint+0x4e>
    neg = 1;
     9f8:	4785                	li	a5,1
     9fa:	fef42423          	sw	a5,-24(s0)
    x = -xx;
     9fe:	fc842783          	lw	a5,-56(s0)
     a02:	40f007bb          	negw	a5,a5
     a06:	2781                	sext.w	a5,a5
     a08:	fef42223          	sw	a5,-28(s0)
     a0c:	a029                	j	a16 <printint+0x56>
  } else {
    x = xx;
     a0e:	fc842783          	lw	a5,-56(s0)
     a12:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
     a16:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
     a1a:	fc442783          	lw	a5,-60(s0)
     a1e:	fe442703          	lw	a4,-28(s0)
     a22:	02f777bb          	remuw	a5,a4,a5
     a26:	0007871b          	sext.w	a4,a5
     a2a:	fec42783          	lw	a5,-20(s0)
     a2e:	0017869b          	addiw	a3,a5,1
     a32:	fed42623          	sw	a3,-20(s0)
     a36:	00001697          	auipc	a3,0x1
     a3a:	5ca68693          	addi	a3,a3,1482 # 2000 <digits>
     a3e:	1702                	slli	a4,a4,0x20
     a40:	9301                	srli	a4,a4,0x20
     a42:	9736                	add	a4,a4,a3
     a44:	00074703          	lbu	a4,0(a4)
     a48:	17c1                	addi	a5,a5,-16
     a4a:	97a2                	add	a5,a5,s0
     a4c:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
     a50:	fc442783          	lw	a5,-60(s0)
     a54:	fe442703          	lw	a4,-28(s0)
     a58:	02f757bb          	divuw	a5,a4,a5
     a5c:	fef42223          	sw	a5,-28(s0)
     a60:	fe442783          	lw	a5,-28(s0)
     a64:	2781                	sext.w	a5,a5
     a66:	fbd5                	bnez	a5,a1a <printint+0x5a>
  if(neg)
     a68:	fe842783          	lw	a5,-24(s0)
     a6c:	2781                	sext.w	a5,a5
     a6e:	cf85                	beqz	a5,aa6 <printint+0xe6>
    buf[i++] = '-';
     a70:	fec42783          	lw	a5,-20(s0)
     a74:	0017871b          	addiw	a4,a5,1
     a78:	fee42623          	sw	a4,-20(s0)
     a7c:	17c1                	addi	a5,a5,-16
     a7e:	97a2                	add	a5,a5,s0
     a80:	02d00713          	li	a4,45
     a84:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
     a88:	a839                	j	aa6 <printint+0xe6>
    putc(fd, buf[i]);
     a8a:	fec42783          	lw	a5,-20(s0)
     a8e:	17c1                	addi	a5,a5,-16
     a90:	97a2                	add	a5,a5,s0
     a92:	fe07c703          	lbu	a4,-32(a5)
     a96:	fcc42783          	lw	a5,-52(s0)
     a9a:	85ba                	mv	a1,a4
     a9c:	853e                	mv	a0,a5
     a9e:	00000097          	auipc	ra,0x0
     aa2:	eec080e7          	jalr	-276(ra) # 98a <putc>
  while(--i >= 0)
     aa6:	fec42783          	lw	a5,-20(s0)
     aaa:	37fd                	addiw	a5,a5,-1
     aac:	fef42623          	sw	a5,-20(s0)
     ab0:	fec42783          	lw	a5,-20(s0)
     ab4:	2781                	sext.w	a5,a5
     ab6:	fc07dae3          	bgez	a5,a8a <printint+0xca>
}
     aba:	0001                	nop
     abc:	0001                	nop
     abe:	70e2                	ld	ra,56(sp)
     ac0:	7442                	ld	s0,48(sp)
     ac2:	6121                	addi	sp,sp,64
     ac4:	8082                	ret

0000000000000ac6 <printptr>:

static void
printptr(int fd, uint64 x) {
     ac6:	7179                	addi	sp,sp,-48
     ac8:	f406                	sd	ra,40(sp)
     aca:	f022                	sd	s0,32(sp)
     acc:	1800                	addi	s0,sp,48
     ace:	87aa                	mv	a5,a0
     ad0:	fcb43823          	sd	a1,-48(s0)
     ad4:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
     ad8:	fdc42783          	lw	a5,-36(s0)
     adc:	03000593          	li	a1,48
     ae0:	853e                	mv	a0,a5
     ae2:	00000097          	auipc	ra,0x0
     ae6:	ea8080e7          	jalr	-344(ra) # 98a <putc>
  putc(fd, 'x');
     aea:	fdc42783          	lw	a5,-36(s0)
     aee:	07800593          	li	a1,120
     af2:	853e                	mv	a0,a5
     af4:	00000097          	auipc	ra,0x0
     af8:	e96080e7          	jalr	-362(ra) # 98a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     afc:	fe042623          	sw	zero,-20(s0)
     b00:	a82d                	j	b3a <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     b02:	fd043783          	ld	a5,-48(s0)
     b06:	93f1                	srli	a5,a5,0x3c
     b08:	00001717          	auipc	a4,0x1
     b0c:	4f870713          	addi	a4,a4,1272 # 2000 <digits>
     b10:	97ba                	add	a5,a5,a4
     b12:	0007c703          	lbu	a4,0(a5)
     b16:	fdc42783          	lw	a5,-36(s0)
     b1a:	85ba                	mv	a1,a4
     b1c:	853e                	mv	a0,a5
     b1e:	00000097          	auipc	ra,0x0
     b22:	e6c080e7          	jalr	-404(ra) # 98a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     b26:	fec42783          	lw	a5,-20(s0)
     b2a:	2785                	addiw	a5,a5,1
     b2c:	fef42623          	sw	a5,-20(s0)
     b30:	fd043783          	ld	a5,-48(s0)
     b34:	0792                	slli	a5,a5,0x4
     b36:	fcf43823          	sd	a5,-48(s0)
     b3a:	fec42703          	lw	a4,-20(s0)
     b3e:	47bd                	li	a5,15
     b40:	fce7f1e3          	bgeu	a5,a4,b02 <printptr+0x3c>
}
     b44:	0001                	nop
     b46:	0001                	nop
     b48:	70a2                	ld	ra,40(sp)
     b4a:	7402                	ld	s0,32(sp)
     b4c:	6145                	addi	sp,sp,48
     b4e:	8082                	ret

0000000000000b50 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     b50:	715d                	addi	sp,sp,-80
     b52:	e486                	sd	ra,72(sp)
     b54:	e0a2                	sd	s0,64(sp)
     b56:	0880                	addi	s0,sp,80
     b58:	87aa                	mv	a5,a0
     b5a:	fcb43023          	sd	a1,-64(s0)
     b5e:	fac43c23          	sd	a2,-72(s0)
     b62:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
     b66:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
     b6a:	fe042223          	sw	zero,-28(s0)
     b6e:	a42d                	j	d98 <vprintf+0x248>
    c = fmt[i] & 0xff;
     b70:	fe442783          	lw	a5,-28(s0)
     b74:	fc043703          	ld	a4,-64(s0)
     b78:	97ba                	add	a5,a5,a4
     b7a:	0007c783          	lbu	a5,0(a5)
     b7e:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
     b82:	fe042783          	lw	a5,-32(s0)
     b86:	2781                	sext.w	a5,a5
     b88:	eb9d                	bnez	a5,bbe <vprintf+0x6e>
      if(c == '%'){
     b8a:	fdc42783          	lw	a5,-36(s0)
     b8e:	0007871b          	sext.w	a4,a5
     b92:	02500793          	li	a5,37
     b96:	00f71763          	bne	a4,a5,ba4 <vprintf+0x54>
        state = '%';
     b9a:	02500793          	li	a5,37
     b9e:	fef42023          	sw	a5,-32(s0)
     ba2:	a2f5                	j	d8e <vprintf+0x23e>
      } else {
        putc(fd, c);
     ba4:	fdc42783          	lw	a5,-36(s0)
     ba8:	0ff7f713          	zext.b	a4,a5
     bac:	fcc42783          	lw	a5,-52(s0)
     bb0:	85ba                	mv	a1,a4
     bb2:	853e                	mv	a0,a5
     bb4:	00000097          	auipc	ra,0x0
     bb8:	dd6080e7          	jalr	-554(ra) # 98a <putc>
     bbc:	aac9                	j	d8e <vprintf+0x23e>
      }
    } else if(state == '%'){
     bbe:	fe042783          	lw	a5,-32(s0)
     bc2:	0007871b          	sext.w	a4,a5
     bc6:	02500793          	li	a5,37
     bca:	1cf71263          	bne	a4,a5,d8e <vprintf+0x23e>
      if(c == 'd'){
     bce:	fdc42783          	lw	a5,-36(s0)
     bd2:	0007871b          	sext.w	a4,a5
     bd6:	06400793          	li	a5,100
     bda:	02f71463          	bne	a4,a5,c02 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
     bde:	fb843783          	ld	a5,-72(s0)
     be2:	00878713          	addi	a4,a5,8
     be6:	fae43c23          	sd	a4,-72(s0)
     bea:	4398                	lw	a4,0(a5)
     bec:	fcc42783          	lw	a5,-52(s0)
     bf0:	4685                	li	a3,1
     bf2:	4629                	li	a2,10
     bf4:	85ba                	mv	a1,a4
     bf6:	853e                	mv	a0,a5
     bf8:	00000097          	auipc	ra,0x0
     bfc:	dc8080e7          	jalr	-568(ra) # 9c0 <printint>
     c00:	a269                	j	d8a <vprintf+0x23a>
      } else if(c == 'l') {
     c02:	fdc42783          	lw	a5,-36(s0)
     c06:	0007871b          	sext.w	a4,a5
     c0a:	06c00793          	li	a5,108
     c0e:	02f71663          	bne	a4,a5,c3a <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
     c12:	fb843783          	ld	a5,-72(s0)
     c16:	00878713          	addi	a4,a5,8
     c1a:	fae43c23          	sd	a4,-72(s0)
     c1e:	639c                	ld	a5,0(a5)
     c20:	0007871b          	sext.w	a4,a5
     c24:	fcc42783          	lw	a5,-52(s0)
     c28:	4681                	li	a3,0
     c2a:	4629                	li	a2,10
     c2c:	85ba                	mv	a1,a4
     c2e:	853e                	mv	a0,a5
     c30:	00000097          	auipc	ra,0x0
     c34:	d90080e7          	jalr	-624(ra) # 9c0 <printint>
     c38:	aa89                	j	d8a <vprintf+0x23a>
      } else if(c == 'x') {
     c3a:	fdc42783          	lw	a5,-36(s0)
     c3e:	0007871b          	sext.w	a4,a5
     c42:	07800793          	li	a5,120
     c46:	02f71463          	bne	a4,a5,c6e <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
     c4a:	fb843783          	ld	a5,-72(s0)
     c4e:	00878713          	addi	a4,a5,8
     c52:	fae43c23          	sd	a4,-72(s0)
     c56:	4398                	lw	a4,0(a5)
     c58:	fcc42783          	lw	a5,-52(s0)
     c5c:	4681                	li	a3,0
     c5e:	4641                	li	a2,16
     c60:	85ba                	mv	a1,a4
     c62:	853e                	mv	a0,a5
     c64:	00000097          	auipc	ra,0x0
     c68:	d5c080e7          	jalr	-676(ra) # 9c0 <printint>
     c6c:	aa39                	j	d8a <vprintf+0x23a>
      } else if(c == 'p') {
     c6e:	fdc42783          	lw	a5,-36(s0)
     c72:	0007871b          	sext.w	a4,a5
     c76:	07000793          	li	a5,112
     c7a:	02f71263          	bne	a4,a5,c9e <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
     c7e:	fb843783          	ld	a5,-72(s0)
     c82:	00878713          	addi	a4,a5,8
     c86:	fae43c23          	sd	a4,-72(s0)
     c8a:	6398                	ld	a4,0(a5)
     c8c:	fcc42783          	lw	a5,-52(s0)
     c90:	85ba                	mv	a1,a4
     c92:	853e                	mv	a0,a5
     c94:	00000097          	auipc	ra,0x0
     c98:	e32080e7          	jalr	-462(ra) # ac6 <printptr>
     c9c:	a0fd                	j	d8a <vprintf+0x23a>
      } else if(c == 's'){
     c9e:	fdc42783          	lw	a5,-36(s0)
     ca2:	0007871b          	sext.w	a4,a5
     ca6:	07300793          	li	a5,115
     caa:	04f71c63          	bne	a4,a5,d02 <vprintf+0x1b2>
        s = va_arg(ap, char*);
     cae:	fb843783          	ld	a5,-72(s0)
     cb2:	00878713          	addi	a4,a5,8
     cb6:	fae43c23          	sd	a4,-72(s0)
     cba:	639c                	ld	a5,0(a5)
     cbc:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
     cc0:	fe843783          	ld	a5,-24(s0)
     cc4:	eb8d                	bnez	a5,cf6 <vprintf+0x1a6>
          s = "(null)";
     cc6:	00000797          	auipc	a5,0x0
     cca:	4b278793          	addi	a5,a5,1202 # 1178 <malloc+0x176>
     cce:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
     cd2:	a015                	j	cf6 <vprintf+0x1a6>
          putc(fd, *s);
     cd4:	fe843783          	ld	a5,-24(s0)
     cd8:	0007c703          	lbu	a4,0(a5)
     cdc:	fcc42783          	lw	a5,-52(s0)
     ce0:	85ba                	mv	a1,a4
     ce2:	853e                	mv	a0,a5
     ce4:	00000097          	auipc	ra,0x0
     ce8:	ca6080e7          	jalr	-858(ra) # 98a <putc>
          s++;
     cec:	fe843783          	ld	a5,-24(s0)
     cf0:	0785                	addi	a5,a5,1
     cf2:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
     cf6:	fe843783          	ld	a5,-24(s0)
     cfa:	0007c783          	lbu	a5,0(a5)
     cfe:	fbf9                	bnez	a5,cd4 <vprintf+0x184>
     d00:	a069                	j	d8a <vprintf+0x23a>
        }
      } else if(c == 'c'){
     d02:	fdc42783          	lw	a5,-36(s0)
     d06:	0007871b          	sext.w	a4,a5
     d0a:	06300793          	li	a5,99
     d0e:	02f71463          	bne	a4,a5,d36 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
     d12:	fb843783          	ld	a5,-72(s0)
     d16:	00878713          	addi	a4,a5,8
     d1a:	fae43c23          	sd	a4,-72(s0)
     d1e:	439c                	lw	a5,0(a5)
     d20:	0ff7f713          	zext.b	a4,a5
     d24:	fcc42783          	lw	a5,-52(s0)
     d28:	85ba                	mv	a1,a4
     d2a:	853e                	mv	a0,a5
     d2c:	00000097          	auipc	ra,0x0
     d30:	c5e080e7          	jalr	-930(ra) # 98a <putc>
     d34:	a899                	j	d8a <vprintf+0x23a>
      } else if(c == '%'){
     d36:	fdc42783          	lw	a5,-36(s0)
     d3a:	0007871b          	sext.w	a4,a5
     d3e:	02500793          	li	a5,37
     d42:	00f71f63          	bne	a4,a5,d60 <vprintf+0x210>
        putc(fd, c);
     d46:	fdc42783          	lw	a5,-36(s0)
     d4a:	0ff7f713          	zext.b	a4,a5
     d4e:	fcc42783          	lw	a5,-52(s0)
     d52:	85ba                	mv	a1,a4
     d54:	853e                	mv	a0,a5
     d56:	00000097          	auipc	ra,0x0
     d5a:	c34080e7          	jalr	-972(ra) # 98a <putc>
     d5e:	a035                	j	d8a <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     d60:	fcc42783          	lw	a5,-52(s0)
     d64:	02500593          	li	a1,37
     d68:	853e                	mv	a0,a5
     d6a:	00000097          	auipc	ra,0x0
     d6e:	c20080e7          	jalr	-992(ra) # 98a <putc>
        putc(fd, c);
     d72:	fdc42783          	lw	a5,-36(s0)
     d76:	0ff7f713          	zext.b	a4,a5
     d7a:	fcc42783          	lw	a5,-52(s0)
     d7e:	85ba                	mv	a1,a4
     d80:	853e                	mv	a0,a5
     d82:	00000097          	auipc	ra,0x0
     d86:	c08080e7          	jalr	-1016(ra) # 98a <putc>
      }
      state = 0;
     d8a:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
     d8e:	fe442783          	lw	a5,-28(s0)
     d92:	2785                	addiw	a5,a5,1
     d94:	fef42223          	sw	a5,-28(s0)
     d98:	fe442783          	lw	a5,-28(s0)
     d9c:	fc043703          	ld	a4,-64(s0)
     da0:	97ba                	add	a5,a5,a4
     da2:	0007c783          	lbu	a5,0(a5)
     da6:	dc0795e3          	bnez	a5,b70 <vprintf+0x20>
    }
  }
}
     daa:	0001                	nop
     dac:	0001                	nop
     dae:	60a6                	ld	ra,72(sp)
     db0:	6406                	ld	s0,64(sp)
     db2:	6161                	addi	sp,sp,80
     db4:	8082                	ret

0000000000000db6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     db6:	7159                	addi	sp,sp,-112
     db8:	fc06                	sd	ra,56(sp)
     dba:	f822                	sd	s0,48(sp)
     dbc:	0080                	addi	s0,sp,64
     dbe:	fcb43823          	sd	a1,-48(s0)
     dc2:	e010                	sd	a2,0(s0)
     dc4:	e414                	sd	a3,8(s0)
     dc6:	e818                	sd	a4,16(s0)
     dc8:	ec1c                	sd	a5,24(s0)
     dca:	03043023          	sd	a6,32(s0)
     dce:	03143423          	sd	a7,40(s0)
     dd2:	87aa                	mv	a5,a0
     dd4:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
     dd8:	03040793          	addi	a5,s0,48
     ddc:	fcf43423          	sd	a5,-56(s0)
     de0:	fc843783          	ld	a5,-56(s0)
     de4:	fd078793          	addi	a5,a5,-48
     de8:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
     dec:	fe843703          	ld	a4,-24(s0)
     df0:	fdc42783          	lw	a5,-36(s0)
     df4:	863a                	mv	a2,a4
     df6:	fd043583          	ld	a1,-48(s0)
     dfa:	853e                	mv	a0,a5
     dfc:	00000097          	auipc	ra,0x0
     e00:	d54080e7          	jalr	-684(ra) # b50 <vprintf>
}
     e04:	0001                	nop
     e06:	70e2                	ld	ra,56(sp)
     e08:	7442                	ld	s0,48(sp)
     e0a:	6165                	addi	sp,sp,112
     e0c:	8082                	ret

0000000000000e0e <printf>:

void
printf(const char *fmt, ...)
{
     e0e:	7159                	addi	sp,sp,-112
     e10:	f406                	sd	ra,40(sp)
     e12:	f022                	sd	s0,32(sp)
     e14:	1800                	addi	s0,sp,48
     e16:	fca43c23          	sd	a0,-40(s0)
     e1a:	e40c                	sd	a1,8(s0)
     e1c:	e810                	sd	a2,16(s0)
     e1e:	ec14                	sd	a3,24(s0)
     e20:	f018                	sd	a4,32(s0)
     e22:	f41c                	sd	a5,40(s0)
     e24:	03043823          	sd	a6,48(s0)
     e28:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     e2c:	04040793          	addi	a5,s0,64
     e30:	fcf43823          	sd	a5,-48(s0)
     e34:	fd043783          	ld	a5,-48(s0)
     e38:	fc878793          	addi	a5,a5,-56
     e3c:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
     e40:	fe843783          	ld	a5,-24(s0)
     e44:	863e                	mv	a2,a5
     e46:	fd843583          	ld	a1,-40(s0)
     e4a:	4505                	li	a0,1
     e4c:	00000097          	auipc	ra,0x0
     e50:	d04080e7          	jalr	-764(ra) # b50 <vprintf>
}
     e54:	0001                	nop
     e56:	70a2                	ld	ra,40(sp)
     e58:	7402                	ld	s0,32(sp)
     e5a:	6165                	addi	sp,sp,112
     e5c:	8082                	ret

0000000000000e5e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     e5e:	7179                	addi	sp,sp,-48
     e60:	f406                	sd	ra,40(sp)
     e62:	f022                	sd	s0,32(sp)
     e64:	1800                	addi	s0,sp,48
     e66:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
     e6a:	fd843783          	ld	a5,-40(s0)
     e6e:	17c1                	addi	a5,a5,-16
     e70:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     e74:	00001797          	auipc	a5,0x1
     e78:	5bc78793          	addi	a5,a5,1468 # 2430 <freep>
     e7c:	639c                	ld	a5,0(a5)
     e7e:	fef43423          	sd	a5,-24(s0)
     e82:	a815                	j	eb6 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     e84:	fe843783          	ld	a5,-24(s0)
     e88:	639c                	ld	a5,0(a5)
     e8a:	fe843703          	ld	a4,-24(s0)
     e8e:	00f76f63          	bltu	a4,a5,eac <free+0x4e>
     e92:	fe043703          	ld	a4,-32(s0)
     e96:	fe843783          	ld	a5,-24(s0)
     e9a:	02e7eb63          	bltu	a5,a4,ed0 <free+0x72>
     e9e:	fe843783          	ld	a5,-24(s0)
     ea2:	639c                	ld	a5,0(a5)
     ea4:	fe043703          	ld	a4,-32(s0)
     ea8:	02f76463          	bltu	a4,a5,ed0 <free+0x72>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     eac:	fe843783          	ld	a5,-24(s0)
     eb0:	639c                	ld	a5,0(a5)
     eb2:	fef43423          	sd	a5,-24(s0)
     eb6:	fe043703          	ld	a4,-32(s0)
     eba:	fe843783          	ld	a5,-24(s0)
     ebe:	fce7f3e3          	bgeu	a5,a4,e84 <free+0x26>
     ec2:	fe843783          	ld	a5,-24(s0)
     ec6:	639c                	ld	a5,0(a5)
     ec8:	fe043703          	ld	a4,-32(s0)
     ecc:	faf77ce3          	bgeu	a4,a5,e84 <free+0x26>
      break;
  if(bp + bp->s.size == p->s.ptr){
     ed0:	fe043783          	ld	a5,-32(s0)
     ed4:	479c                	lw	a5,8(a5)
     ed6:	1782                	slli	a5,a5,0x20
     ed8:	9381                	srli	a5,a5,0x20
     eda:	0792                	slli	a5,a5,0x4
     edc:	fe043703          	ld	a4,-32(s0)
     ee0:	973e                	add	a4,a4,a5
     ee2:	fe843783          	ld	a5,-24(s0)
     ee6:	639c                	ld	a5,0(a5)
     ee8:	02f71763          	bne	a4,a5,f16 <free+0xb8>
    bp->s.size += p->s.ptr->s.size;
     eec:	fe043783          	ld	a5,-32(s0)
     ef0:	4798                	lw	a4,8(a5)
     ef2:	fe843783          	ld	a5,-24(s0)
     ef6:	639c                	ld	a5,0(a5)
     ef8:	479c                	lw	a5,8(a5)
     efa:	9fb9                	addw	a5,a5,a4
     efc:	0007871b          	sext.w	a4,a5
     f00:	fe043783          	ld	a5,-32(s0)
     f04:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
     f06:	fe843783          	ld	a5,-24(s0)
     f0a:	639c                	ld	a5,0(a5)
     f0c:	6398                	ld	a4,0(a5)
     f0e:	fe043783          	ld	a5,-32(s0)
     f12:	e398                	sd	a4,0(a5)
     f14:	a039                	j	f22 <free+0xc4>
  } else
    bp->s.ptr = p->s.ptr;
     f16:	fe843783          	ld	a5,-24(s0)
     f1a:	6398                	ld	a4,0(a5)
     f1c:	fe043783          	ld	a5,-32(s0)
     f20:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
     f22:	fe843783          	ld	a5,-24(s0)
     f26:	479c                	lw	a5,8(a5)
     f28:	1782                	slli	a5,a5,0x20
     f2a:	9381                	srli	a5,a5,0x20
     f2c:	0792                	slli	a5,a5,0x4
     f2e:	fe843703          	ld	a4,-24(s0)
     f32:	97ba                	add	a5,a5,a4
     f34:	fe043703          	ld	a4,-32(s0)
     f38:	02f71563          	bne	a4,a5,f62 <free+0x104>
    p->s.size += bp->s.size;
     f3c:	fe843783          	ld	a5,-24(s0)
     f40:	4798                	lw	a4,8(a5)
     f42:	fe043783          	ld	a5,-32(s0)
     f46:	479c                	lw	a5,8(a5)
     f48:	9fb9                	addw	a5,a5,a4
     f4a:	0007871b          	sext.w	a4,a5
     f4e:	fe843783          	ld	a5,-24(s0)
     f52:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
     f54:	fe043783          	ld	a5,-32(s0)
     f58:	6398                	ld	a4,0(a5)
     f5a:	fe843783          	ld	a5,-24(s0)
     f5e:	e398                	sd	a4,0(a5)
     f60:	a031                	j	f6c <free+0x10e>
  } else
    p->s.ptr = bp;
     f62:	fe843783          	ld	a5,-24(s0)
     f66:	fe043703          	ld	a4,-32(s0)
     f6a:	e398                	sd	a4,0(a5)
  freep = p;
     f6c:	00001797          	auipc	a5,0x1
     f70:	4c478793          	addi	a5,a5,1220 # 2430 <freep>
     f74:	fe843703          	ld	a4,-24(s0)
     f78:	e398                	sd	a4,0(a5)
}
     f7a:	0001                	nop
     f7c:	70a2                	ld	ra,40(sp)
     f7e:	7402                	ld	s0,32(sp)
     f80:	6145                	addi	sp,sp,48
     f82:	8082                	ret

0000000000000f84 <morecore>:

static Header*
morecore(uint nu)
{
     f84:	7179                	addi	sp,sp,-48
     f86:	f406                	sd	ra,40(sp)
     f88:	f022                	sd	s0,32(sp)
     f8a:	1800                	addi	s0,sp,48
     f8c:	87aa                	mv	a5,a0
     f8e:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
     f92:	fdc42783          	lw	a5,-36(s0)
     f96:	0007871b          	sext.w	a4,a5
     f9a:	6785                	lui	a5,0x1
     f9c:	00f77563          	bgeu	a4,a5,fa6 <morecore+0x22>
    nu = 4096;
     fa0:	6785                	lui	a5,0x1
     fa2:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
     fa6:	fdc42783          	lw	a5,-36(s0)
     faa:	0047979b          	slliw	a5,a5,0x4
     fae:	2781                	sext.w	a5,a5
     fb0:	853e                	mv	a0,a5
     fb2:	00000097          	auipc	ra,0x0
     fb6:	9b8080e7          	jalr	-1608(ra) # 96a <sbrk>
     fba:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
     fbe:	fe843703          	ld	a4,-24(s0)
     fc2:	57fd                	li	a5,-1
     fc4:	00f71463          	bne	a4,a5,fcc <morecore+0x48>
    return 0;
     fc8:	4781                	li	a5,0
     fca:	a03d                	j	ff8 <morecore+0x74>
  hp = (Header*)p;
     fcc:	fe843783          	ld	a5,-24(s0)
     fd0:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
     fd4:	fe043783          	ld	a5,-32(s0)
     fd8:	fdc42703          	lw	a4,-36(s0)
     fdc:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
     fde:	fe043783          	ld	a5,-32(s0)
     fe2:	07c1                	addi	a5,a5,16 # 1010 <malloc+0xe>
     fe4:	853e                	mv	a0,a5
     fe6:	00000097          	auipc	ra,0x0
     fea:	e78080e7          	jalr	-392(ra) # e5e <free>
  return freep;
     fee:	00001797          	auipc	a5,0x1
     ff2:	44278793          	addi	a5,a5,1090 # 2430 <freep>
     ff6:	639c                	ld	a5,0(a5)
}
     ff8:	853e                	mv	a0,a5
     ffa:	70a2                	ld	ra,40(sp)
     ffc:	7402                	ld	s0,32(sp)
     ffe:	6145                	addi	sp,sp,48
    1000:	8082                	ret

0000000000001002 <malloc>:

void*
malloc(uint nbytes)
{
    1002:	7139                	addi	sp,sp,-64
    1004:	fc06                	sd	ra,56(sp)
    1006:	f822                	sd	s0,48(sp)
    1008:	0080                	addi	s0,sp,64
    100a:	87aa                	mv	a5,a0
    100c:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1010:	fcc46783          	lwu	a5,-52(s0)
    1014:	07bd                	addi	a5,a5,15
    1016:	8391                	srli	a5,a5,0x4
    1018:	2781                	sext.w	a5,a5
    101a:	2785                	addiw	a5,a5,1
    101c:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
    1020:	00001797          	auipc	a5,0x1
    1024:	41078793          	addi	a5,a5,1040 # 2430 <freep>
    1028:	639c                	ld	a5,0(a5)
    102a:	fef43023          	sd	a5,-32(s0)
    102e:	fe043783          	ld	a5,-32(s0)
    1032:	ef95                	bnez	a5,106e <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
    1034:	00001797          	auipc	a5,0x1
    1038:	3ec78793          	addi	a5,a5,1004 # 2420 <base>
    103c:	fef43023          	sd	a5,-32(s0)
    1040:	00001797          	auipc	a5,0x1
    1044:	3f078793          	addi	a5,a5,1008 # 2430 <freep>
    1048:	fe043703          	ld	a4,-32(s0)
    104c:	e398                	sd	a4,0(a5)
    104e:	00001797          	auipc	a5,0x1
    1052:	3e278793          	addi	a5,a5,994 # 2430 <freep>
    1056:	6398                	ld	a4,0(a5)
    1058:	00001797          	auipc	a5,0x1
    105c:	3c878793          	addi	a5,a5,968 # 2420 <base>
    1060:	e398                	sd	a4,0(a5)
    base.s.size = 0;
    1062:	00001797          	auipc	a5,0x1
    1066:	3be78793          	addi	a5,a5,958 # 2420 <base>
    106a:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    106e:	fe043783          	ld	a5,-32(s0)
    1072:	639c                	ld	a5,0(a5)
    1074:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
    1078:	fe843783          	ld	a5,-24(s0)
    107c:	479c                	lw	a5,8(a5)
    107e:	fdc42703          	lw	a4,-36(s0)
    1082:	2701                	sext.w	a4,a4
    1084:	06e7e763          	bltu	a5,a4,10f2 <malloc+0xf0>
      if(p->s.size == nunits)
    1088:	fe843783          	ld	a5,-24(s0)
    108c:	479c                	lw	a5,8(a5)
    108e:	fdc42703          	lw	a4,-36(s0)
    1092:	2701                	sext.w	a4,a4
    1094:	00f71963          	bne	a4,a5,10a6 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
    1098:	fe843783          	ld	a5,-24(s0)
    109c:	6398                	ld	a4,0(a5)
    109e:	fe043783          	ld	a5,-32(s0)
    10a2:	e398                	sd	a4,0(a5)
    10a4:	a825                	j	10dc <malloc+0xda>
      else {
        p->s.size -= nunits;
    10a6:	fe843783          	ld	a5,-24(s0)
    10aa:	479c                	lw	a5,8(a5)
    10ac:	fdc42703          	lw	a4,-36(s0)
    10b0:	9f99                	subw	a5,a5,a4
    10b2:	0007871b          	sext.w	a4,a5
    10b6:	fe843783          	ld	a5,-24(s0)
    10ba:	c798                	sw	a4,8(a5)
        p += p->s.size;
    10bc:	fe843783          	ld	a5,-24(s0)
    10c0:	479c                	lw	a5,8(a5)
    10c2:	1782                	slli	a5,a5,0x20
    10c4:	9381                	srli	a5,a5,0x20
    10c6:	0792                	slli	a5,a5,0x4
    10c8:	fe843703          	ld	a4,-24(s0)
    10cc:	97ba                	add	a5,a5,a4
    10ce:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
    10d2:	fe843783          	ld	a5,-24(s0)
    10d6:	fdc42703          	lw	a4,-36(s0)
    10da:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
    10dc:	00001797          	auipc	a5,0x1
    10e0:	35478793          	addi	a5,a5,852 # 2430 <freep>
    10e4:	fe043703          	ld	a4,-32(s0)
    10e8:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
    10ea:	fe843783          	ld	a5,-24(s0)
    10ee:	07c1                	addi	a5,a5,16
    10f0:	a091                	j	1134 <malloc+0x132>
    }
    if(p == freep)
    10f2:	00001797          	auipc	a5,0x1
    10f6:	33e78793          	addi	a5,a5,830 # 2430 <freep>
    10fa:	639c                	ld	a5,0(a5)
    10fc:	fe843703          	ld	a4,-24(s0)
    1100:	02f71063          	bne	a4,a5,1120 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
    1104:	fdc42783          	lw	a5,-36(s0)
    1108:	853e                	mv	a0,a5
    110a:	00000097          	auipc	ra,0x0
    110e:	e7a080e7          	jalr	-390(ra) # f84 <morecore>
    1112:	fea43423          	sd	a0,-24(s0)
    1116:	fe843783          	ld	a5,-24(s0)
    111a:	e399                	bnez	a5,1120 <malloc+0x11e>
        return 0;
    111c:	4781                	li	a5,0
    111e:	a819                	j	1134 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1120:	fe843783          	ld	a5,-24(s0)
    1124:	fef43023          	sd	a5,-32(s0)
    1128:	fe843783          	ld	a5,-24(s0)
    112c:	639c                	ld	a5,0(a5)
    112e:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
    1132:	b799                	j	1078 <malloc+0x76>
  }
}
    1134:	853e                	mv	a0,a5
    1136:	70e2                	ld	ra,56(sp)
    1138:	7442                	ld	s0,48(sp)
    113a:	6121                	addi	sp,sp,64
    113c:	8082                	ret
