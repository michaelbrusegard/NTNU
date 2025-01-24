
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
       0:	7139                	addi	sp,sp,-64
       2:	fc06                	sd	ra,56(sp)
       4:	f822                	sd	s0,48(sp)
       6:	f426                	sd	s1,40(sp)
       8:	0080                	addi	s0,sp,64
       a:	fca43423          	sd	a0,-56(s0)
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
       e:	fc843503          	ld	a0,-56(s0)
      12:	00000097          	auipc	ra,0x0
      16:	448080e7          	jalr	1096(ra) # 45a <strlen>
      1a:	87aa                	mv	a5,a0
      1c:	1782                	slli	a5,a5,0x20
      1e:	9381                	srli	a5,a5,0x20
      20:	fc843703          	ld	a4,-56(s0)
      24:	97ba                	add	a5,a5,a4
      26:	fcf43c23          	sd	a5,-40(s0)
      2a:	a031                	j	36 <fmtname+0x36>
      2c:	fd843783          	ld	a5,-40(s0)
      30:	17fd                	addi	a5,a5,-1
      32:	fcf43c23          	sd	a5,-40(s0)
      36:	fd843703          	ld	a4,-40(s0)
      3a:	fc843783          	ld	a5,-56(s0)
      3e:	00f76b63          	bltu	a4,a5,54 <fmtname+0x54>
      42:	fd843783          	ld	a5,-40(s0)
      46:	0007c783          	lbu	a5,0(a5)
      4a:	873e                	mv	a4,a5
      4c:	02f00793          	li	a5,47
      50:	fcf71ee3          	bne	a4,a5,2c <fmtname+0x2c>
    ;
  p++;
      54:	fd843783          	ld	a5,-40(s0)
      58:	0785                	addi	a5,a5,1
      5a:	fcf43c23          	sd	a5,-40(s0)

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
      5e:	fd843503          	ld	a0,-40(s0)
      62:	00000097          	auipc	ra,0x0
      66:	3f8080e7          	jalr	1016(ra) # 45a <strlen>
      6a:	87aa                	mv	a5,a0
      6c:	873e                	mv	a4,a5
      6e:	47b5                	li	a5,13
      70:	00e7f563          	bgeu	a5,a4,7a <fmtname+0x7a>
    return p;
      74:	fd843783          	ld	a5,-40(s0)
      78:	a895                	j	ec <fmtname+0xec>
  memmove(buf, p, strlen(p));
      7a:	fd843503          	ld	a0,-40(s0)
      7e:	00000097          	auipc	ra,0x0
      82:	3dc080e7          	jalr	988(ra) # 45a <strlen>
      86:	87aa                	mv	a5,a0
      88:	863e                	mv	a2,a5
      8a:	fd843583          	ld	a1,-40(s0)
      8e:	00002517          	auipc	a0,0x2
      92:	f9250513          	addi	a0,a0,-110 # 2020 <buf.0>
      96:	00000097          	auipc	ra,0x0
      9a:	62e080e7          	jalr	1582(ra) # 6c4 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
      9e:	fd843503          	ld	a0,-40(s0)
      a2:	00000097          	auipc	ra,0x0
      a6:	3b8080e7          	jalr	952(ra) # 45a <strlen>
      aa:	87aa                	mv	a5,a0
      ac:	02079713          	slli	a4,a5,0x20
      b0:	9301                	srli	a4,a4,0x20
      b2:	00002797          	auipc	a5,0x2
      b6:	f6e78793          	addi	a5,a5,-146 # 2020 <buf.0>
      ba:	00f704b3          	add	s1,a4,a5
      be:	fd843503          	ld	a0,-40(s0)
      c2:	00000097          	auipc	ra,0x0
      c6:	398080e7          	jalr	920(ra) # 45a <strlen>
      ca:	87aa                	mv	a5,a0
      cc:	873e                	mv	a4,a5
      ce:	47b9                	li	a5,14
      d0:	9f99                	subw	a5,a5,a4
      d2:	2781                	sext.w	a5,a5
      d4:	863e                	mv	a2,a5
      d6:	02000593          	li	a1,32
      da:	8526                	mv	a0,s1
      dc:	00000097          	auipc	ra,0x0
      e0:	3b8080e7          	jalr	952(ra) # 494 <memset>
  return buf;
      e4:	00002797          	auipc	a5,0x2
      e8:	f3c78793          	addi	a5,a5,-196 # 2020 <buf.0>
}
      ec:	853e                	mv	a0,a5
      ee:	70e2                	ld	ra,56(sp)
      f0:	7442                	ld	s0,48(sp)
      f2:	74a2                	ld	s1,40(sp)
      f4:	6121                	addi	sp,sp,64
      f6:	8082                	ret

00000000000000f8 <ls>:

void
ls(char *path)
{
      f8:	da010113          	addi	sp,sp,-608
      fc:	24113c23          	sd	ra,600(sp)
     100:	24813823          	sd	s0,592(sp)
     104:	1480                	addi	s0,sp,608
     106:	daa43423          	sd	a0,-600(s0)
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
     10a:	4581                	li	a1,0
     10c:	da843503          	ld	a0,-600(s0)
     110:	00000097          	auipc	ra,0x0
     114:	782080e7          	jalr	1922(ra) # 892 <open>
     118:	87aa                	mv	a5,a0
     11a:	fef42623          	sw	a5,-20(s0)
     11e:	fec42783          	lw	a5,-20(s0)
     122:	2781                	sext.w	a5,a5
     124:	0007de63          	bgez	a5,140 <ls+0x48>
    fprintf(2, "ls: cannot open %s\n", path);
     128:	da843603          	ld	a2,-600(s0)
     12c:	00001597          	auipc	a1,0x1
     130:	f8458593          	addi	a1,a1,-124 # 10b0 <malloc+0x13e>
     134:	4509                	li	a0,2
     136:	00001097          	auipc	ra,0x1
     13a:	bf0080e7          	jalr	-1040(ra) # d26 <fprintf>
    return;
     13e:	aa75                	j	2fa <ls+0x202>
  }

  if(fstat(fd, &st) < 0){
     140:	db840713          	addi	a4,s0,-584
     144:	fec42783          	lw	a5,-20(s0)
     148:	85ba                	mv	a1,a4
     14a:	853e                	mv	a0,a5
     14c:	00000097          	auipc	ra,0x0
     150:	75e080e7          	jalr	1886(ra) # 8aa <fstat>
     154:	87aa                	mv	a5,a0
     156:	0207d563          	bgez	a5,180 <ls+0x88>
    fprintf(2, "ls: cannot stat %s\n", path);
     15a:	da843603          	ld	a2,-600(s0)
     15e:	00001597          	auipc	a1,0x1
     162:	f6a58593          	addi	a1,a1,-150 # 10c8 <malloc+0x156>
     166:	4509                	li	a0,2
     168:	00001097          	auipc	ra,0x1
     16c:	bbe080e7          	jalr	-1090(ra) # d26 <fprintf>
    close(fd);
     170:	fec42783          	lw	a5,-20(s0)
     174:	853e                	mv	a0,a5
     176:	00000097          	auipc	ra,0x0
     17a:	704080e7          	jalr	1796(ra) # 87a <close>
    return;
     17e:	aab5                	j	2fa <ls+0x202>
  }

  switch(st.type){
     180:	dc041783          	lh	a5,-576(s0)
     184:	4705                	li	a4,1
     186:	04e78263          	beq	a5,a4,1ca <ls+0xd2>
     18a:	16f05163          	blez	a5,2ec <ls+0x1f4>
     18e:	37f9                	addiw	a5,a5,-2
     190:	0007871b          	sext.w	a4,a5
     194:	4785                	li	a5,1
     196:	14e7eb63          	bltu	a5,a4,2ec <ls+0x1f4>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %l\n", fmtname(path), st.type, st.ino, st.size);
     19a:	da843503          	ld	a0,-600(s0)
     19e:	00000097          	auipc	ra,0x0
     1a2:	e62080e7          	jalr	-414(ra) # 0 <fmtname>
     1a6:	85aa                	mv	a1,a0
     1a8:	dc041783          	lh	a5,-576(s0)
     1ac:	863e                	mv	a2,a5
     1ae:	dbc42783          	lw	a5,-580(s0)
     1b2:	dc843703          	ld	a4,-568(s0)
     1b6:	86be                	mv	a3,a5
     1b8:	00001517          	auipc	a0,0x1
     1bc:	f2850513          	addi	a0,a0,-216 # 10e0 <malloc+0x16e>
     1c0:	00001097          	auipc	ra,0x1
     1c4:	bbe080e7          	jalr	-1090(ra) # d7e <printf>
    break;
     1c8:	a215                	j	2ec <ls+0x1f4>

  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
     1ca:	da843503          	ld	a0,-600(s0)
     1ce:	00000097          	auipc	ra,0x0
     1d2:	28c080e7          	jalr	652(ra) # 45a <strlen>
     1d6:	87aa                	mv	a5,a0
     1d8:	27c1                	addiw	a5,a5,16
     1da:	0007871b          	sext.w	a4,a5
     1de:	20000793          	li	a5,512
     1e2:	00e7fb63          	bgeu	a5,a4,1f8 <ls+0x100>
      printf("ls: path too long\n");
     1e6:	00001517          	auipc	a0,0x1
     1ea:	f0a50513          	addi	a0,a0,-246 # 10f0 <malloc+0x17e>
     1ee:	00001097          	auipc	ra,0x1
     1f2:	b90080e7          	jalr	-1136(ra) # d7e <printf>
      break;
     1f6:	a8dd                	j	2ec <ls+0x1f4>
    }
    strcpy(buf, path);
     1f8:	de040793          	addi	a5,s0,-544
     1fc:	da843583          	ld	a1,-600(s0)
     200:	853e                	mv	a0,a5
     202:	00000097          	auipc	ra,0x0
     206:	1a0080e7          	jalr	416(ra) # 3a2 <strcpy>
    p = buf+strlen(buf);
     20a:	de040793          	addi	a5,s0,-544
     20e:	853e                	mv	a0,a5
     210:	00000097          	auipc	ra,0x0
     214:	24a080e7          	jalr	586(ra) # 45a <strlen>
     218:	87aa                	mv	a5,a0
     21a:	1782                	slli	a5,a5,0x20
     21c:	9381                	srli	a5,a5,0x20
     21e:	de040713          	addi	a4,s0,-544
     222:	97ba                	add	a5,a5,a4
     224:	fef43023          	sd	a5,-32(s0)
    *p++ = '/';
     228:	fe043783          	ld	a5,-32(s0)
     22c:	00178713          	addi	a4,a5,1
     230:	fee43023          	sd	a4,-32(s0)
     234:	02f00713          	li	a4,47
     238:	00e78023          	sb	a4,0(a5)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
     23c:	a079                	j	2ca <ls+0x1d2>
      if(de.inum == 0)
     23e:	dd045783          	lhu	a5,-560(s0)
     242:	c3d9                	beqz	a5,2c8 <ls+0x1d0>
        continue;
      memmove(p, de.name, DIRSIZ);
     244:	dd040793          	addi	a5,s0,-560
     248:	0789                	addi	a5,a5,2
     24a:	4639                	li	a2,14
     24c:	85be                	mv	a1,a5
     24e:	fe043503          	ld	a0,-32(s0)
     252:	00000097          	auipc	ra,0x0
     256:	472080e7          	jalr	1138(ra) # 6c4 <memmove>
      p[DIRSIZ] = 0;
     25a:	fe043783          	ld	a5,-32(s0)
     25e:	07b9                	addi	a5,a5,14
     260:	00078023          	sb	zero,0(a5)
      if(stat(buf, &st) < 0){
     264:	db840713          	addi	a4,s0,-584
     268:	de040793          	addi	a5,s0,-544
     26c:	85ba                	mv	a1,a4
     26e:	853e                	mv	a0,a5
     270:	00000097          	auipc	ra,0x0
     274:	376080e7          	jalr	886(ra) # 5e6 <stat>
     278:	87aa                	mv	a5,a0
     27a:	0007de63          	bgez	a5,296 <ls+0x19e>
        printf("ls: cannot stat %s\n", buf);
     27e:	de040793          	addi	a5,s0,-544
     282:	85be                	mv	a1,a5
     284:	00001517          	auipc	a0,0x1
     288:	e4450513          	addi	a0,a0,-444 # 10c8 <malloc+0x156>
     28c:	00001097          	auipc	ra,0x1
     290:	af2080e7          	jalr	-1294(ra) # d7e <printf>
        continue;
     294:	a81d                	j	2ca <ls+0x1d2>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
     296:	de040793          	addi	a5,s0,-544
     29a:	853e                	mv	a0,a5
     29c:	00000097          	auipc	ra,0x0
     2a0:	d64080e7          	jalr	-668(ra) # 0 <fmtname>
     2a4:	85aa                	mv	a1,a0
     2a6:	dc041783          	lh	a5,-576(s0)
     2aa:	863e                	mv	a2,a5
     2ac:	dbc42783          	lw	a5,-580(s0)
     2b0:	dc843703          	ld	a4,-568(s0)
     2b4:	86be                	mv	a3,a5
     2b6:	00001517          	auipc	a0,0x1
     2ba:	e5250513          	addi	a0,a0,-430 # 1108 <malloc+0x196>
     2be:	00001097          	auipc	ra,0x1
     2c2:	ac0080e7          	jalr	-1344(ra) # d7e <printf>
     2c6:	a011                	j	2ca <ls+0x1d2>
        continue;
     2c8:	0001                	nop
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
     2ca:	dd040713          	addi	a4,s0,-560
     2ce:	fec42783          	lw	a5,-20(s0)
     2d2:	4641                	li	a2,16
     2d4:	85ba                	mv	a1,a4
     2d6:	853e                	mv	a0,a5
     2d8:	00000097          	auipc	ra,0x0
     2dc:	592080e7          	jalr	1426(ra) # 86a <read>
     2e0:	87aa                	mv	a5,a0
     2e2:	873e                	mv	a4,a5
     2e4:	47c1                	li	a5,16
     2e6:	f4f70ce3          	beq	a4,a5,23e <ls+0x146>
    }
    break;
     2ea:	0001                	nop
  }
  close(fd);
     2ec:	fec42783          	lw	a5,-20(s0)
     2f0:	853e                	mv	a0,a5
     2f2:	00000097          	auipc	ra,0x0
     2f6:	588080e7          	jalr	1416(ra) # 87a <close>
}
     2fa:	25813083          	ld	ra,600(sp)
     2fe:	25013403          	ld	s0,592(sp)
     302:	26010113          	addi	sp,sp,608
     306:	8082                	ret

0000000000000308 <main>:

int
main(int argc, char *argv[])
{
     308:	7179                	addi	sp,sp,-48
     30a:	f406                	sd	ra,40(sp)
     30c:	f022                	sd	s0,32(sp)
     30e:	1800                	addi	s0,sp,48
     310:	87aa                	mv	a5,a0
     312:	fcb43823          	sd	a1,-48(s0)
     316:	fcf42e23          	sw	a5,-36(s0)
  int i;

  if(argc < 2){
     31a:	fdc42783          	lw	a5,-36(s0)
     31e:	0007871b          	sext.w	a4,a5
     322:	4785                	li	a5,1
     324:	00e7cf63          	blt	a5,a4,342 <main+0x3a>
    ls(".");
     328:	00001517          	auipc	a0,0x1
     32c:	df050513          	addi	a0,a0,-528 # 1118 <malloc+0x1a6>
     330:	00000097          	auipc	ra,0x0
     334:	dc8080e7          	jalr	-568(ra) # f8 <ls>
    exit(0);
     338:	4501                	li	a0,0
     33a:	00000097          	auipc	ra,0x0
     33e:	518080e7          	jalr	1304(ra) # 852 <exit>
  }
  for(i=1; i<argc; i++)
     342:	4785                	li	a5,1
     344:	fef42623          	sw	a5,-20(s0)
     348:	a015                	j	36c <main+0x64>
    ls(argv[i]);
     34a:	fec42783          	lw	a5,-20(s0)
     34e:	078e                	slli	a5,a5,0x3
     350:	fd043703          	ld	a4,-48(s0)
     354:	97ba                	add	a5,a5,a4
     356:	639c                	ld	a5,0(a5)
     358:	853e                	mv	a0,a5
     35a:	00000097          	auipc	ra,0x0
     35e:	d9e080e7          	jalr	-610(ra) # f8 <ls>
  for(i=1; i<argc; i++)
     362:	fec42783          	lw	a5,-20(s0)
     366:	2785                	addiw	a5,a5,1
     368:	fef42623          	sw	a5,-20(s0)
     36c:	fec42783          	lw	a5,-20(s0)
     370:	873e                	mv	a4,a5
     372:	fdc42783          	lw	a5,-36(s0)
     376:	2701                	sext.w	a4,a4
     378:	2781                	sext.w	a5,a5
     37a:	fcf748e3          	blt	a4,a5,34a <main+0x42>
  exit(0);
     37e:	4501                	li	a0,0
     380:	00000097          	auipc	ra,0x0
     384:	4d2080e7          	jalr	1234(ra) # 852 <exit>

0000000000000388 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     388:	1141                	addi	sp,sp,-16
     38a:	e406                	sd	ra,8(sp)
     38c:	e022                	sd	s0,0(sp)
     38e:	0800                	addi	s0,sp,16
  extern int main();
  main();
     390:	00000097          	auipc	ra,0x0
     394:	f78080e7          	jalr	-136(ra) # 308 <main>
  exit(0);
     398:	4501                	li	a0,0
     39a:	00000097          	auipc	ra,0x0
     39e:	4b8080e7          	jalr	1208(ra) # 852 <exit>

00000000000003a2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     3a2:	7179                	addi	sp,sp,-48
     3a4:	f406                	sd	ra,40(sp)
     3a6:	f022                	sd	s0,32(sp)
     3a8:	1800                	addi	s0,sp,48
     3aa:	fca43c23          	sd	a0,-40(s0)
     3ae:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
     3b2:	fd843783          	ld	a5,-40(s0)
     3b6:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
     3ba:	0001                	nop
     3bc:	fd043703          	ld	a4,-48(s0)
     3c0:	00170793          	addi	a5,a4,1
     3c4:	fcf43823          	sd	a5,-48(s0)
     3c8:	fd843783          	ld	a5,-40(s0)
     3cc:	00178693          	addi	a3,a5,1
     3d0:	fcd43c23          	sd	a3,-40(s0)
     3d4:	00074703          	lbu	a4,0(a4)
     3d8:	00e78023          	sb	a4,0(a5)
     3dc:	0007c783          	lbu	a5,0(a5)
     3e0:	fff1                	bnez	a5,3bc <strcpy+0x1a>
    ;
  return os;
     3e2:	fe843783          	ld	a5,-24(s0)
}
     3e6:	853e                	mv	a0,a5
     3e8:	70a2                	ld	ra,40(sp)
     3ea:	7402                	ld	s0,32(sp)
     3ec:	6145                	addi	sp,sp,48
     3ee:	8082                	ret

00000000000003f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     3f0:	1101                	addi	sp,sp,-32
     3f2:	ec06                	sd	ra,24(sp)
     3f4:	e822                	sd	s0,16(sp)
     3f6:	1000                	addi	s0,sp,32
     3f8:	fea43423          	sd	a0,-24(s0)
     3fc:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
     400:	a819                	j	416 <strcmp+0x26>
    p++, q++;
     402:	fe843783          	ld	a5,-24(s0)
     406:	0785                	addi	a5,a5,1
     408:	fef43423          	sd	a5,-24(s0)
     40c:	fe043783          	ld	a5,-32(s0)
     410:	0785                	addi	a5,a5,1
     412:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
     416:	fe843783          	ld	a5,-24(s0)
     41a:	0007c783          	lbu	a5,0(a5)
     41e:	cb99                	beqz	a5,434 <strcmp+0x44>
     420:	fe843783          	ld	a5,-24(s0)
     424:	0007c703          	lbu	a4,0(a5)
     428:	fe043783          	ld	a5,-32(s0)
     42c:	0007c783          	lbu	a5,0(a5)
     430:	fcf709e3          	beq	a4,a5,402 <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
     434:	fe843783          	ld	a5,-24(s0)
     438:	0007c783          	lbu	a5,0(a5)
     43c:	0007871b          	sext.w	a4,a5
     440:	fe043783          	ld	a5,-32(s0)
     444:	0007c783          	lbu	a5,0(a5)
     448:	2781                	sext.w	a5,a5
     44a:	40f707bb          	subw	a5,a4,a5
     44e:	2781                	sext.w	a5,a5
}
     450:	853e                	mv	a0,a5
     452:	60e2                	ld	ra,24(sp)
     454:	6442                	ld	s0,16(sp)
     456:	6105                	addi	sp,sp,32
     458:	8082                	ret

000000000000045a <strlen>:

uint
strlen(const char *s)
{
     45a:	7179                	addi	sp,sp,-48
     45c:	f406                	sd	ra,40(sp)
     45e:	f022                	sd	s0,32(sp)
     460:	1800                	addi	s0,sp,48
     462:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
     466:	fe042623          	sw	zero,-20(s0)
     46a:	a031                	j	476 <strlen+0x1c>
     46c:	fec42783          	lw	a5,-20(s0)
     470:	2785                	addiw	a5,a5,1
     472:	fef42623          	sw	a5,-20(s0)
     476:	fec42783          	lw	a5,-20(s0)
     47a:	fd843703          	ld	a4,-40(s0)
     47e:	97ba                	add	a5,a5,a4
     480:	0007c783          	lbu	a5,0(a5)
     484:	f7e5                	bnez	a5,46c <strlen+0x12>
    ;
  return n;
     486:	fec42783          	lw	a5,-20(s0)
}
     48a:	853e                	mv	a0,a5
     48c:	70a2                	ld	ra,40(sp)
     48e:	7402                	ld	s0,32(sp)
     490:	6145                	addi	sp,sp,48
     492:	8082                	ret

0000000000000494 <memset>:

void*
memset(void *dst, int c, uint n)
{
     494:	7179                	addi	sp,sp,-48
     496:	f406                	sd	ra,40(sp)
     498:	f022                	sd	s0,32(sp)
     49a:	1800                	addi	s0,sp,48
     49c:	fca43c23          	sd	a0,-40(s0)
     4a0:	87ae                	mv	a5,a1
     4a2:	8732                	mv	a4,a2
     4a4:	fcf42a23          	sw	a5,-44(s0)
     4a8:	87ba                	mv	a5,a4
     4aa:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
     4ae:	fd843783          	ld	a5,-40(s0)
     4b2:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
     4b6:	fe042623          	sw	zero,-20(s0)
     4ba:	a00d                	j	4dc <memset+0x48>
    cdst[i] = c;
     4bc:	fec42783          	lw	a5,-20(s0)
     4c0:	fe043703          	ld	a4,-32(s0)
     4c4:	97ba                	add	a5,a5,a4
     4c6:	fd442703          	lw	a4,-44(s0)
     4ca:	0ff77713          	zext.b	a4,a4
     4ce:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
     4d2:	fec42783          	lw	a5,-20(s0)
     4d6:	2785                	addiw	a5,a5,1
     4d8:	fef42623          	sw	a5,-20(s0)
     4dc:	fec42783          	lw	a5,-20(s0)
     4e0:	fd042703          	lw	a4,-48(s0)
     4e4:	2701                	sext.w	a4,a4
     4e6:	fce7ebe3          	bltu	a5,a4,4bc <memset+0x28>
  }
  return dst;
     4ea:	fd843783          	ld	a5,-40(s0)
}
     4ee:	853e                	mv	a0,a5
     4f0:	70a2                	ld	ra,40(sp)
     4f2:	7402                	ld	s0,32(sp)
     4f4:	6145                	addi	sp,sp,48
     4f6:	8082                	ret

00000000000004f8 <strchr>:

char*
strchr(const char *s, char c)
{
     4f8:	1101                	addi	sp,sp,-32
     4fa:	ec06                	sd	ra,24(sp)
     4fc:	e822                	sd	s0,16(sp)
     4fe:	1000                	addi	s0,sp,32
     500:	fea43423          	sd	a0,-24(s0)
     504:	87ae                	mv	a5,a1
     506:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
     50a:	a01d                	j	530 <strchr+0x38>
    if(*s == c)
     50c:	fe843783          	ld	a5,-24(s0)
     510:	0007c703          	lbu	a4,0(a5)
     514:	fe744783          	lbu	a5,-25(s0)
     518:	0ff7f793          	zext.b	a5,a5
     51c:	00e79563          	bne	a5,a4,526 <strchr+0x2e>
      return (char*)s;
     520:	fe843783          	ld	a5,-24(s0)
     524:	a821                	j	53c <strchr+0x44>
  for(; *s; s++)
     526:	fe843783          	ld	a5,-24(s0)
     52a:	0785                	addi	a5,a5,1
     52c:	fef43423          	sd	a5,-24(s0)
     530:	fe843783          	ld	a5,-24(s0)
     534:	0007c783          	lbu	a5,0(a5)
     538:	fbf1                	bnez	a5,50c <strchr+0x14>
  return 0;
     53a:	4781                	li	a5,0
}
     53c:	853e                	mv	a0,a5
     53e:	60e2                	ld	ra,24(sp)
     540:	6442                	ld	s0,16(sp)
     542:	6105                	addi	sp,sp,32
     544:	8082                	ret

0000000000000546 <gets>:

char*
gets(char *buf, int max)
{
     546:	7179                	addi	sp,sp,-48
     548:	f406                	sd	ra,40(sp)
     54a:	f022                	sd	s0,32(sp)
     54c:	1800                	addi	s0,sp,48
     54e:	fca43c23          	sd	a0,-40(s0)
     552:	87ae                	mv	a5,a1
     554:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     558:	fe042623          	sw	zero,-20(s0)
     55c:	a8a1                	j	5b4 <gets+0x6e>
    cc = read(0, &c, 1);
     55e:	fe740793          	addi	a5,s0,-25
     562:	4605                	li	a2,1
     564:	85be                	mv	a1,a5
     566:	4501                	li	a0,0
     568:	00000097          	auipc	ra,0x0
     56c:	302080e7          	jalr	770(ra) # 86a <read>
     570:	87aa                	mv	a5,a0
     572:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
     576:	fe842783          	lw	a5,-24(s0)
     57a:	2781                	sext.w	a5,a5
     57c:	04f05663          	blez	a5,5c8 <gets+0x82>
      break;
    buf[i++] = c;
     580:	fec42783          	lw	a5,-20(s0)
     584:	0017871b          	addiw	a4,a5,1
     588:	fee42623          	sw	a4,-20(s0)
     58c:	873e                	mv	a4,a5
     58e:	fd843783          	ld	a5,-40(s0)
     592:	97ba                	add	a5,a5,a4
     594:	fe744703          	lbu	a4,-25(s0)
     598:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
     59c:	fe744783          	lbu	a5,-25(s0)
     5a0:	873e                	mv	a4,a5
     5a2:	47a9                	li	a5,10
     5a4:	02f70363          	beq	a4,a5,5ca <gets+0x84>
     5a8:	fe744783          	lbu	a5,-25(s0)
     5ac:	873e                	mv	a4,a5
     5ae:	47b5                	li	a5,13
     5b0:	00f70d63          	beq	a4,a5,5ca <gets+0x84>
  for(i=0; i+1 < max; ){
     5b4:	fec42783          	lw	a5,-20(s0)
     5b8:	2785                	addiw	a5,a5,1
     5ba:	2781                	sext.w	a5,a5
     5bc:	fd442703          	lw	a4,-44(s0)
     5c0:	2701                	sext.w	a4,a4
     5c2:	f8e7cee3          	blt	a5,a4,55e <gets+0x18>
     5c6:	a011                	j	5ca <gets+0x84>
      break;
     5c8:	0001                	nop
      break;
  }
  buf[i] = '\0';
     5ca:	fec42783          	lw	a5,-20(s0)
     5ce:	fd843703          	ld	a4,-40(s0)
     5d2:	97ba                	add	a5,a5,a4
     5d4:	00078023          	sb	zero,0(a5)
  return buf;
     5d8:	fd843783          	ld	a5,-40(s0)
}
     5dc:	853e                	mv	a0,a5
     5de:	70a2                	ld	ra,40(sp)
     5e0:	7402                	ld	s0,32(sp)
     5e2:	6145                	addi	sp,sp,48
     5e4:	8082                	ret

00000000000005e6 <stat>:

int
stat(const char *n, struct stat *st)
{
     5e6:	7179                	addi	sp,sp,-48
     5e8:	f406                	sd	ra,40(sp)
     5ea:	f022                	sd	s0,32(sp)
     5ec:	1800                	addi	s0,sp,48
     5ee:	fca43c23          	sd	a0,-40(s0)
     5f2:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     5f6:	4581                	li	a1,0
     5f8:	fd843503          	ld	a0,-40(s0)
     5fc:	00000097          	auipc	ra,0x0
     600:	296080e7          	jalr	662(ra) # 892 <open>
     604:	87aa                	mv	a5,a0
     606:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
     60a:	fec42783          	lw	a5,-20(s0)
     60e:	2781                	sext.w	a5,a5
     610:	0007d463          	bgez	a5,618 <stat+0x32>
    return -1;
     614:	57fd                	li	a5,-1
     616:	a035                	j	642 <stat+0x5c>
  r = fstat(fd, st);
     618:	fec42783          	lw	a5,-20(s0)
     61c:	fd043583          	ld	a1,-48(s0)
     620:	853e                	mv	a0,a5
     622:	00000097          	auipc	ra,0x0
     626:	288080e7          	jalr	648(ra) # 8aa <fstat>
     62a:	87aa                	mv	a5,a0
     62c:	fef42423          	sw	a5,-24(s0)
  close(fd);
     630:	fec42783          	lw	a5,-20(s0)
     634:	853e                	mv	a0,a5
     636:	00000097          	auipc	ra,0x0
     63a:	244080e7          	jalr	580(ra) # 87a <close>
  return r;
     63e:	fe842783          	lw	a5,-24(s0)
}
     642:	853e                	mv	a0,a5
     644:	70a2                	ld	ra,40(sp)
     646:	7402                	ld	s0,32(sp)
     648:	6145                	addi	sp,sp,48
     64a:	8082                	ret

000000000000064c <atoi>:

int
atoi(const char *s)
{
     64c:	7179                	addi	sp,sp,-48
     64e:	f406                	sd	ra,40(sp)
     650:	f022                	sd	s0,32(sp)
     652:	1800                	addi	s0,sp,48
     654:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
     658:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
     65c:	a81d                	j	692 <atoi+0x46>
    n = n*10 + *s++ - '0';
     65e:	fec42783          	lw	a5,-20(s0)
     662:	873e                	mv	a4,a5
     664:	87ba                	mv	a5,a4
     666:	0027979b          	slliw	a5,a5,0x2
     66a:	9fb9                	addw	a5,a5,a4
     66c:	0017979b          	slliw	a5,a5,0x1
     670:	0007871b          	sext.w	a4,a5
     674:	fd843783          	ld	a5,-40(s0)
     678:	00178693          	addi	a3,a5,1
     67c:	fcd43c23          	sd	a3,-40(s0)
     680:	0007c783          	lbu	a5,0(a5)
     684:	2781                	sext.w	a5,a5
     686:	9fb9                	addw	a5,a5,a4
     688:	2781                	sext.w	a5,a5
     68a:	fd07879b          	addiw	a5,a5,-48
     68e:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
     692:	fd843783          	ld	a5,-40(s0)
     696:	0007c783          	lbu	a5,0(a5)
     69a:	873e                	mv	a4,a5
     69c:	02f00793          	li	a5,47
     6a0:	00e7fb63          	bgeu	a5,a4,6b6 <atoi+0x6a>
     6a4:	fd843783          	ld	a5,-40(s0)
     6a8:	0007c783          	lbu	a5,0(a5)
     6ac:	873e                	mv	a4,a5
     6ae:	03900793          	li	a5,57
     6b2:	fae7f6e3          	bgeu	a5,a4,65e <atoi+0x12>
  return n;
     6b6:	fec42783          	lw	a5,-20(s0)
}
     6ba:	853e                	mv	a0,a5
     6bc:	70a2                	ld	ra,40(sp)
     6be:	7402                	ld	s0,32(sp)
     6c0:	6145                	addi	sp,sp,48
     6c2:	8082                	ret

00000000000006c4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     6c4:	7139                	addi	sp,sp,-64
     6c6:	fc06                	sd	ra,56(sp)
     6c8:	f822                	sd	s0,48(sp)
     6ca:	0080                	addi	s0,sp,64
     6cc:	fca43c23          	sd	a0,-40(s0)
     6d0:	fcb43823          	sd	a1,-48(s0)
     6d4:	87b2                	mv	a5,a2
     6d6:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
     6da:	fd843783          	ld	a5,-40(s0)
     6de:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
     6e2:	fd043783          	ld	a5,-48(s0)
     6e6:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
     6ea:	fe043703          	ld	a4,-32(s0)
     6ee:	fe843783          	ld	a5,-24(s0)
     6f2:	02e7fc63          	bgeu	a5,a4,72a <memmove+0x66>
    while(n-- > 0)
     6f6:	a00d                	j	718 <memmove+0x54>
      *dst++ = *src++;
     6f8:	fe043703          	ld	a4,-32(s0)
     6fc:	00170793          	addi	a5,a4,1
     700:	fef43023          	sd	a5,-32(s0)
     704:	fe843783          	ld	a5,-24(s0)
     708:	00178693          	addi	a3,a5,1
     70c:	fed43423          	sd	a3,-24(s0)
     710:	00074703          	lbu	a4,0(a4)
     714:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
     718:	fcc42783          	lw	a5,-52(s0)
     71c:	fff7871b          	addiw	a4,a5,-1
     720:	fce42623          	sw	a4,-52(s0)
     724:	fcf04ae3          	bgtz	a5,6f8 <memmove+0x34>
     728:	a891                	j	77c <memmove+0xb8>
  } else {
    dst += n;
     72a:	fcc42783          	lw	a5,-52(s0)
     72e:	fe843703          	ld	a4,-24(s0)
     732:	97ba                	add	a5,a5,a4
     734:	fef43423          	sd	a5,-24(s0)
    src += n;
     738:	fcc42783          	lw	a5,-52(s0)
     73c:	fe043703          	ld	a4,-32(s0)
     740:	97ba                	add	a5,a5,a4
     742:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
     746:	a01d                	j	76c <memmove+0xa8>
      *--dst = *--src;
     748:	fe043783          	ld	a5,-32(s0)
     74c:	17fd                	addi	a5,a5,-1
     74e:	fef43023          	sd	a5,-32(s0)
     752:	fe843783          	ld	a5,-24(s0)
     756:	17fd                	addi	a5,a5,-1
     758:	fef43423          	sd	a5,-24(s0)
     75c:	fe043783          	ld	a5,-32(s0)
     760:	0007c703          	lbu	a4,0(a5)
     764:	fe843783          	ld	a5,-24(s0)
     768:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
     76c:	fcc42783          	lw	a5,-52(s0)
     770:	fff7871b          	addiw	a4,a5,-1
     774:	fce42623          	sw	a4,-52(s0)
     778:	fcf048e3          	bgtz	a5,748 <memmove+0x84>
  }
  return vdst;
     77c:	fd843783          	ld	a5,-40(s0)
}
     780:	853e                	mv	a0,a5
     782:	70e2                	ld	ra,56(sp)
     784:	7442                	ld	s0,48(sp)
     786:	6121                	addi	sp,sp,64
     788:	8082                	ret

000000000000078a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     78a:	7139                	addi	sp,sp,-64
     78c:	fc06                	sd	ra,56(sp)
     78e:	f822                	sd	s0,48(sp)
     790:	0080                	addi	s0,sp,64
     792:	fca43c23          	sd	a0,-40(s0)
     796:	fcb43823          	sd	a1,-48(s0)
     79a:	87b2                	mv	a5,a2
     79c:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
     7a0:	fd843783          	ld	a5,-40(s0)
     7a4:	fef43423          	sd	a5,-24(s0)
     7a8:	fd043783          	ld	a5,-48(s0)
     7ac:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
     7b0:	a0a1                	j	7f8 <memcmp+0x6e>
    if (*p1 != *p2) {
     7b2:	fe843783          	ld	a5,-24(s0)
     7b6:	0007c703          	lbu	a4,0(a5)
     7ba:	fe043783          	ld	a5,-32(s0)
     7be:	0007c783          	lbu	a5,0(a5)
     7c2:	02f70163          	beq	a4,a5,7e4 <memcmp+0x5a>
      return *p1 - *p2;
     7c6:	fe843783          	ld	a5,-24(s0)
     7ca:	0007c783          	lbu	a5,0(a5)
     7ce:	0007871b          	sext.w	a4,a5
     7d2:	fe043783          	ld	a5,-32(s0)
     7d6:	0007c783          	lbu	a5,0(a5)
     7da:	2781                	sext.w	a5,a5
     7dc:	40f707bb          	subw	a5,a4,a5
     7e0:	2781                	sext.w	a5,a5
     7e2:	a01d                	j	808 <memcmp+0x7e>
    }
    p1++;
     7e4:	fe843783          	ld	a5,-24(s0)
     7e8:	0785                	addi	a5,a5,1
     7ea:	fef43423          	sd	a5,-24(s0)
    p2++;
     7ee:	fe043783          	ld	a5,-32(s0)
     7f2:	0785                	addi	a5,a5,1
     7f4:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
     7f8:	fcc42783          	lw	a5,-52(s0)
     7fc:	fff7871b          	addiw	a4,a5,-1
     800:	fce42623          	sw	a4,-52(s0)
     804:	f7dd                	bnez	a5,7b2 <memcmp+0x28>
  }
  return 0;
     806:	4781                	li	a5,0
}
     808:	853e                	mv	a0,a5
     80a:	70e2                	ld	ra,56(sp)
     80c:	7442                	ld	s0,48(sp)
     80e:	6121                	addi	sp,sp,64
     810:	8082                	ret

0000000000000812 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     812:	7179                	addi	sp,sp,-48
     814:	f406                	sd	ra,40(sp)
     816:	f022                	sd	s0,32(sp)
     818:	1800                	addi	s0,sp,48
     81a:	fea43423          	sd	a0,-24(s0)
     81e:	feb43023          	sd	a1,-32(s0)
     822:	87b2                	mv	a5,a2
     824:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
     828:	fdc42783          	lw	a5,-36(s0)
     82c:	863e                	mv	a2,a5
     82e:	fe043583          	ld	a1,-32(s0)
     832:	fe843503          	ld	a0,-24(s0)
     836:	00000097          	auipc	ra,0x0
     83a:	e8e080e7          	jalr	-370(ra) # 6c4 <memmove>
     83e:	87aa                	mv	a5,a0
}
     840:	853e                	mv	a0,a5
     842:	70a2                	ld	ra,40(sp)
     844:	7402                	ld	s0,32(sp)
     846:	6145                	addi	sp,sp,48
     848:	8082                	ret

000000000000084a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     84a:	4885                	li	a7,1
 ecall
     84c:	00000073          	ecall
 ret
     850:	8082                	ret

0000000000000852 <exit>:
.global exit
exit:
 li a7, SYS_exit
     852:	4889                	li	a7,2
 ecall
     854:	00000073          	ecall
 ret
     858:	8082                	ret

000000000000085a <wait>:
.global wait
wait:
 li a7, SYS_wait
     85a:	488d                	li	a7,3
 ecall
     85c:	00000073          	ecall
 ret
     860:	8082                	ret

0000000000000862 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     862:	4891                	li	a7,4
 ecall
     864:	00000073          	ecall
 ret
     868:	8082                	ret

000000000000086a <read>:
.global read
read:
 li a7, SYS_read
     86a:	4895                	li	a7,5
 ecall
     86c:	00000073          	ecall
 ret
     870:	8082                	ret

0000000000000872 <write>:
.global write
write:
 li a7, SYS_write
     872:	48c1                	li	a7,16
 ecall
     874:	00000073          	ecall
 ret
     878:	8082                	ret

000000000000087a <close>:
.global close
close:
 li a7, SYS_close
     87a:	48d5                	li	a7,21
 ecall
     87c:	00000073          	ecall
 ret
     880:	8082                	ret

0000000000000882 <kill>:
.global kill
kill:
 li a7, SYS_kill
     882:	4899                	li	a7,6
 ecall
     884:	00000073          	ecall
 ret
     888:	8082                	ret

000000000000088a <exec>:
.global exec
exec:
 li a7, SYS_exec
     88a:	489d                	li	a7,7
 ecall
     88c:	00000073          	ecall
 ret
     890:	8082                	ret

0000000000000892 <open>:
.global open
open:
 li a7, SYS_open
     892:	48bd                	li	a7,15
 ecall
     894:	00000073          	ecall
 ret
     898:	8082                	ret

000000000000089a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     89a:	48c5                	li	a7,17
 ecall
     89c:	00000073          	ecall
 ret
     8a0:	8082                	ret

00000000000008a2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     8a2:	48c9                	li	a7,18
 ecall
     8a4:	00000073          	ecall
 ret
     8a8:	8082                	ret

00000000000008aa <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     8aa:	48a1                	li	a7,8
 ecall
     8ac:	00000073          	ecall
 ret
     8b0:	8082                	ret

00000000000008b2 <link>:
.global link
link:
 li a7, SYS_link
     8b2:	48cd                	li	a7,19
 ecall
     8b4:	00000073          	ecall
 ret
     8b8:	8082                	ret

00000000000008ba <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     8ba:	48d1                	li	a7,20
 ecall
     8bc:	00000073          	ecall
 ret
     8c0:	8082                	ret

00000000000008c2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     8c2:	48a5                	li	a7,9
 ecall
     8c4:	00000073          	ecall
 ret
     8c8:	8082                	ret

00000000000008ca <dup>:
.global dup
dup:
 li a7, SYS_dup
     8ca:	48a9                	li	a7,10
 ecall
     8cc:	00000073          	ecall
 ret
     8d0:	8082                	ret

00000000000008d2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     8d2:	48ad                	li	a7,11
 ecall
     8d4:	00000073          	ecall
 ret
     8d8:	8082                	ret

00000000000008da <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     8da:	48b1                	li	a7,12
 ecall
     8dc:	00000073          	ecall
 ret
     8e0:	8082                	ret

00000000000008e2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     8e2:	48b5                	li	a7,13
 ecall
     8e4:	00000073          	ecall
 ret
     8e8:	8082                	ret

00000000000008ea <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     8ea:	48b9                	li	a7,14
 ecall
     8ec:	00000073          	ecall
 ret
     8f0:	8082                	ret

00000000000008f2 <ps>:
.global ps
ps:
 li a7, SYS_ps
     8f2:	48d9                	li	a7,22
 ecall
     8f4:	00000073          	ecall
 ret
     8f8:	8082                	ret

00000000000008fa <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     8fa:	1101                	addi	sp,sp,-32
     8fc:	ec06                	sd	ra,24(sp)
     8fe:	e822                	sd	s0,16(sp)
     900:	1000                	addi	s0,sp,32
     902:	87aa                	mv	a5,a0
     904:	872e                	mv	a4,a1
     906:	fef42623          	sw	a5,-20(s0)
     90a:	87ba                	mv	a5,a4
     90c:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
     910:	feb40713          	addi	a4,s0,-21
     914:	fec42783          	lw	a5,-20(s0)
     918:	4605                	li	a2,1
     91a:	85ba                	mv	a1,a4
     91c:	853e                	mv	a0,a5
     91e:	00000097          	auipc	ra,0x0
     922:	f54080e7          	jalr	-172(ra) # 872 <write>
}
     926:	0001                	nop
     928:	60e2                	ld	ra,24(sp)
     92a:	6442                	ld	s0,16(sp)
     92c:	6105                	addi	sp,sp,32
     92e:	8082                	ret

0000000000000930 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     930:	7139                	addi	sp,sp,-64
     932:	fc06                	sd	ra,56(sp)
     934:	f822                	sd	s0,48(sp)
     936:	0080                	addi	s0,sp,64
     938:	87aa                	mv	a5,a0
     93a:	8736                	mv	a4,a3
     93c:	fcf42623          	sw	a5,-52(s0)
     940:	87ae                	mv	a5,a1
     942:	fcf42423          	sw	a5,-56(s0)
     946:	87b2                	mv	a5,a2
     948:	fcf42223          	sw	a5,-60(s0)
     94c:	87ba                	mv	a5,a4
     94e:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     952:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
     956:	fc042783          	lw	a5,-64(s0)
     95a:	2781                	sext.w	a5,a5
     95c:	c38d                	beqz	a5,97e <printint+0x4e>
     95e:	fc842783          	lw	a5,-56(s0)
     962:	2781                	sext.w	a5,a5
     964:	0007dd63          	bgez	a5,97e <printint+0x4e>
    neg = 1;
     968:	4785                	li	a5,1
     96a:	fef42423          	sw	a5,-24(s0)
    x = -xx;
     96e:	fc842783          	lw	a5,-56(s0)
     972:	40f007bb          	negw	a5,a5
     976:	2781                	sext.w	a5,a5
     978:	fef42223          	sw	a5,-28(s0)
     97c:	a029                	j	986 <printint+0x56>
  } else {
    x = xx;
     97e:	fc842783          	lw	a5,-56(s0)
     982:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
     986:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
     98a:	fc442783          	lw	a5,-60(s0)
     98e:	fe442703          	lw	a4,-28(s0)
     992:	02f777bb          	remuw	a5,a4,a5
     996:	0007871b          	sext.w	a4,a5
     99a:	fec42783          	lw	a5,-20(s0)
     99e:	0017869b          	addiw	a3,a5,1
     9a2:	fed42623          	sw	a3,-20(s0)
     9a6:	00001697          	auipc	a3,0x1
     9aa:	65a68693          	addi	a3,a3,1626 # 2000 <digits>
     9ae:	1702                	slli	a4,a4,0x20
     9b0:	9301                	srli	a4,a4,0x20
     9b2:	9736                	add	a4,a4,a3
     9b4:	00074703          	lbu	a4,0(a4)
     9b8:	17c1                	addi	a5,a5,-16
     9ba:	97a2                	add	a5,a5,s0
     9bc:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
     9c0:	fc442783          	lw	a5,-60(s0)
     9c4:	fe442703          	lw	a4,-28(s0)
     9c8:	02f757bb          	divuw	a5,a4,a5
     9cc:	fef42223          	sw	a5,-28(s0)
     9d0:	fe442783          	lw	a5,-28(s0)
     9d4:	2781                	sext.w	a5,a5
     9d6:	fbd5                	bnez	a5,98a <printint+0x5a>
  if(neg)
     9d8:	fe842783          	lw	a5,-24(s0)
     9dc:	2781                	sext.w	a5,a5
     9de:	cf85                	beqz	a5,a16 <printint+0xe6>
    buf[i++] = '-';
     9e0:	fec42783          	lw	a5,-20(s0)
     9e4:	0017871b          	addiw	a4,a5,1
     9e8:	fee42623          	sw	a4,-20(s0)
     9ec:	17c1                	addi	a5,a5,-16
     9ee:	97a2                	add	a5,a5,s0
     9f0:	02d00713          	li	a4,45
     9f4:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
     9f8:	a839                	j	a16 <printint+0xe6>
    putc(fd, buf[i]);
     9fa:	fec42783          	lw	a5,-20(s0)
     9fe:	17c1                	addi	a5,a5,-16
     a00:	97a2                	add	a5,a5,s0
     a02:	fe07c703          	lbu	a4,-32(a5)
     a06:	fcc42783          	lw	a5,-52(s0)
     a0a:	85ba                	mv	a1,a4
     a0c:	853e                	mv	a0,a5
     a0e:	00000097          	auipc	ra,0x0
     a12:	eec080e7          	jalr	-276(ra) # 8fa <putc>
  while(--i >= 0)
     a16:	fec42783          	lw	a5,-20(s0)
     a1a:	37fd                	addiw	a5,a5,-1
     a1c:	fef42623          	sw	a5,-20(s0)
     a20:	fec42783          	lw	a5,-20(s0)
     a24:	2781                	sext.w	a5,a5
     a26:	fc07dae3          	bgez	a5,9fa <printint+0xca>
}
     a2a:	0001                	nop
     a2c:	0001                	nop
     a2e:	70e2                	ld	ra,56(sp)
     a30:	7442                	ld	s0,48(sp)
     a32:	6121                	addi	sp,sp,64
     a34:	8082                	ret

0000000000000a36 <printptr>:

static void
printptr(int fd, uint64 x) {
     a36:	7179                	addi	sp,sp,-48
     a38:	f406                	sd	ra,40(sp)
     a3a:	f022                	sd	s0,32(sp)
     a3c:	1800                	addi	s0,sp,48
     a3e:	87aa                	mv	a5,a0
     a40:	fcb43823          	sd	a1,-48(s0)
     a44:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
     a48:	fdc42783          	lw	a5,-36(s0)
     a4c:	03000593          	li	a1,48
     a50:	853e                	mv	a0,a5
     a52:	00000097          	auipc	ra,0x0
     a56:	ea8080e7          	jalr	-344(ra) # 8fa <putc>
  putc(fd, 'x');
     a5a:	fdc42783          	lw	a5,-36(s0)
     a5e:	07800593          	li	a1,120
     a62:	853e                	mv	a0,a5
     a64:	00000097          	auipc	ra,0x0
     a68:	e96080e7          	jalr	-362(ra) # 8fa <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     a6c:	fe042623          	sw	zero,-20(s0)
     a70:	a82d                	j	aaa <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     a72:	fd043783          	ld	a5,-48(s0)
     a76:	93f1                	srli	a5,a5,0x3c
     a78:	00001717          	auipc	a4,0x1
     a7c:	58870713          	addi	a4,a4,1416 # 2000 <digits>
     a80:	97ba                	add	a5,a5,a4
     a82:	0007c703          	lbu	a4,0(a5)
     a86:	fdc42783          	lw	a5,-36(s0)
     a8a:	85ba                	mv	a1,a4
     a8c:	853e                	mv	a0,a5
     a8e:	00000097          	auipc	ra,0x0
     a92:	e6c080e7          	jalr	-404(ra) # 8fa <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     a96:	fec42783          	lw	a5,-20(s0)
     a9a:	2785                	addiw	a5,a5,1
     a9c:	fef42623          	sw	a5,-20(s0)
     aa0:	fd043783          	ld	a5,-48(s0)
     aa4:	0792                	slli	a5,a5,0x4
     aa6:	fcf43823          	sd	a5,-48(s0)
     aaa:	fec42703          	lw	a4,-20(s0)
     aae:	47bd                	li	a5,15
     ab0:	fce7f1e3          	bgeu	a5,a4,a72 <printptr+0x3c>
}
     ab4:	0001                	nop
     ab6:	0001                	nop
     ab8:	70a2                	ld	ra,40(sp)
     aba:	7402                	ld	s0,32(sp)
     abc:	6145                	addi	sp,sp,48
     abe:	8082                	ret

0000000000000ac0 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     ac0:	715d                	addi	sp,sp,-80
     ac2:	e486                	sd	ra,72(sp)
     ac4:	e0a2                	sd	s0,64(sp)
     ac6:	0880                	addi	s0,sp,80
     ac8:	87aa                	mv	a5,a0
     aca:	fcb43023          	sd	a1,-64(s0)
     ace:	fac43c23          	sd	a2,-72(s0)
     ad2:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
     ad6:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
     ada:	fe042223          	sw	zero,-28(s0)
     ade:	a42d                	j	d08 <vprintf+0x248>
    c = fmt[i] & 0xff;
     ae0:	fe442783          	lw	a5,-28(s0)
     ae4:	fc043703          	ld	a4,-64(s0)
     ae8:	97ba                	add	a5,a5,a4
     aea:	0007c783          	lbu	a5,0(a5)
     aee:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
     af2:	fe042783          	lw	a5,-32(s0)
     af6:	2781                	sext.w	a5,a5
     af8:	eb9d                	bnez	a5,b2e <vprintf+0x6e>
      if(c == '%'){
     afa:	fdc42783          	lw	a5,-36(s0)
     afe:	0007871b          	sext.w	a4,a5
     b02:	02500793          	li	a5,37
     b06:	00f71763          	bne	a4,a5,b14 <vprintf+0x54>
        state = '%';
     b0a:	02500793          	li	a5,37
     b0e:	fef42023          	sw	a5,-32(s0)
     b12:	a2f5                	j	cfe <vprintf+0x23e>
      } else {
        putc(fd, c);
     b14:	fdc42783          	lw	a5,-36(s0)
     b18:	0ff7f713          	zext.b	a4,a5
     b1c:	fcc42783          	lw	a5,-52(s0)
     b20:	85ba                	mv	a1,a4
     b22:	853e                	mv	a0,a5
     b24:	00000097          	auipc	ra,0x0
     b28:	dd6080e7          	jalr	-554(ra) # 8fa <putc>
     b2c:	aac9                	j	cfe <vprintf+0x23e>
      }
    } else if(state == '%'){
     b2e:	fe042783          	lw	a5,-32(s0)
     b32:	0007871b          	sext.w	a4,a5
     b36:	02500793          	li	a5,37
     b3a:	1cf71263          	bne	a4,a5,cfe <vprintf+0x23e>
      if(c == 'd'){
     b3e:	fdc42783          	lw	a5,-36(s0)
     b42:	0007871b          	sext.w	a4,a5
     b46:	06400793          	li	a5,100
     b4a:	02f71463          	bne	a4,a5,b72 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
     b4e:	fb843783          	ld	a5,-72(s0)
     b52:	00878713          	addi	a4,a5,8
     b56:	fae43c23          	sd	a4,-72(s0)
     b5a:	4398                	lw	a4,0(a5)
     b5c:	fcc42783          	lw	a5,-52(s0)
     b60:	4685                	li	a3,1
     b62:	4629                	li	a2,10
     b64:	85ba                	mv	a1,a4
     b66:	853e                	mv	a0,a5
     b68:	00000097          	auipc	ra,0x0
     b6c:	dc8080e7          	jalr	-568(ra) # 930 <printint>
     b70:	a269                	j	cfa <vprintf+0x23a>
      } else if(c == 'l') {
     b72:	fdc42783          	lw	a5,-36(s0)
     b76:	0007871b          	sext.w	a4,a5
     b7a:	06c00793          	li	a5,108
     b7e:	02f71663          	bne	a4,a5,baa <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
     b82:	fb843783          	ld	a5,-72(s0)
     b86:	00878713          	addi	a4,a5,8
     b8a:	fae43c23          	sd	a4,-72(s0)
     b8e:	639c                	ld	a5,0(a5)
     b90:	0007871b          	sext.w	a4,a5
     b94:	fcc42783          	lw	a5,-52(s0)
     b98:	4681                	li	a3,0
     b9a:	4629                	li	a2,10
     b9c:	85ba                	mv	a1,a4
     b9e:	853e                	mv	a0,a5
     ba0:	00000097          	auipc	ra,0x0
     ba4:	d90080e7          	jalr	-624(ra) # 930 <printint>
     ba8:	aa89                	j	cfa <vprintf+0x23a>
      } else if(c == 'x') {
     baa:	fdc42783          	lw	a5,-36(s0)
     bae:	0007871b          	sext.w	a4,a5
     bb2:	07800793          	li	a5,120
     bb6:	02f71463          	bne	a4,a5,bde <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
     bba:	fb843783          	ld	a5,-72(s0)
     bbe:	00878713          	addi	a4,a5,8
     bc2:	fae43c23          	sd	a4,-72(s0)
     bc6:	4398                	lw	a4,0(a5)
     bc8:	fcc42783          	lw	a5,-52(s0)
     bcc:	4681                	li	a3,0
     bce:	4641                	li	a2,16
     bd0:	85ba                	mv	a1,a4
     bd2:	853e                	mv	a0,a5
     bd4:	00000097          	auipc	ra,0x0
     bd8:	d5c080e7          	jalr	-676(ra) # 930 <printint>
     bdc:	aa39                	j	cfa <vprintf+0x23a>
      } else if(c == 'p') {
     bde:	fdc42783          	lw	a5,-36(s0)
     be2:	0007871b          	sext.w	a4,a5
     be6:	07000793          	li	a5,112
     bea:	02f71263          	bne	a4,a5,c0e <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
     bee:	fb843783          	ld	a5,-72(s0)
     bf2:	00878713          	addi	a4,a5,8
     bf6:	fae43c23          	sd	a4,-72(s0)
     bfa:	6398                	ld	a4,0(a5)
     bfc:	fcc42783          	lw	a5,-52(s0)
     c00:	85ba                	mv	a1,a4
     c02:	853e                	mv	a0,a5
     c04:	00000097          	auipc	ra,0x0
     c08:	e32080e7          	jalr	-462(ra) # a36 <printptr>
     c0c:	a0fd                	j	cfa <vprintf+0x23a>
      } else if(c == 's'){
     c0e:	fdc42783          	lw	a5,-36(s0)
     c12:	0007871b          	sext.w	a4,a5
     c16:	07300793          	li	a5,115
     c1a:	04f71c63          	bne	a4,a5,c72 <vprintf+0x1b2>
        s = va_arg(ap, char*);
     c1e:	fb843783          	ld	a5,-72(s0)
     c22:	00878713          	addi	a4,a5,8
     c26:	fae43c23          	sd	a4,-72(s0)
     c2a:	639c                	ld	a5,0(a5)
     c2c:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
     c30:	fe843783          	ld	a5,-24(s0)
     c34:	eb8d                	bnez	a5,c66 <vprintf+0x1a6>
          s = "(null)";
     c36:	00000797          	auipc	a5,0x0
     c3a:	4ea78793          	addi	a5,a5,1258 # 1120 <malloc+0x1ae>
     c3e:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
     c42:	a015                	j	c66 <vprintf+0x1a6>
          putc(fd, *s);
     c44:	fe843783          	ld	a5,-24(s0)
     c48:	0007c703          	lbu	a4,0(a5)
     c4c:	fcc42783          	lw	a5,-52(s0)
     c50:	85ba                	mv	a1,a4
     c52:	853e                	mv	a0,a5
     c54:	00000097          	auipc	ra,0x0
     c58:	ca6080e7          	jalr	-858(ra) # 8fa <putc>
          s++;
     c5c:	fe843783          	ld	a5,-24(s0)
     c60:	0785                	addi	a5,a5,1
     c62:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
     c66:	fe843783          	ld	a5,-24(s0)
     c6a:	0007c783          	lbu	a5,0(a5)
     c6e:	fbf9                	bnez	a5,c44 <vprintf+0x184>
     c70:	a069                	j	cfa <vprintf+0x23a>
        }
      } else if(c == 'c'){
     c72:	fdc42783          	lw	a5,-36(s0)
     c76:	0007871b          	sext.w	a4,a5
     c7a:	06300793          	li	a5,99
     c7e:	02f71463          	bne	a4,a5,ca6 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
     c82:	fb843783          	ld	a5,-72(s0)
     c86:	00878713          	addi	a4,a5,8
     c8a:	fae43c23          	sd	a4,-72(s0)
     c8e:	439c                	lw	a5,0(a5)
     c90:	0ff7f713          	zext.b	a4,a5
     c94:	fcc42783          	lw	a5,-52(s0)
     c98:	85ba                	mv	a1,a4
     c9a:	853e                	mv	a0,a5
     c9c:	00000097          	auipc	ra,0x0
     ca0:	c5e080e7          	jalr	-930(ra) # 8fa <putc>
     ca4:	a899                	j	cfa <vprintf+0x23a>
      } else if(c == '%'){
     ca6:	fdc42783          	lw	a5,-36(s0)
     caa:	0007871b          	sext.w	a4,a5
     cae:	02500793          	li	a5,37
     cb2:	00f71f63          	bne	a4,a5,cd0 <vprintf+0x210>
        putc(fd, c);
     cb6:	fdc42783          	lw	a5,-36(s0)
     cba:	0ff7f713          	zext.b	a4,a5
     cbe:	fcc42783          	lw	a5,-52(s0)
     cc2:	85ba                	mv	a1,a4
     cc4:	853e                	mv	a0,a5
     cc6:	00000097          	auipc	ra,0x0
     cca:	c34080e7          	jalr	-972(ra) # 8fa <putc>
     cce:	a035                	j	cfa <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     cd0:	fcc42783          	lw	a5,-52(s0)
     cd4:	02500593          	li	a1,37
     cd8:	853e                	mv	a0,a5
     cda:	00000097          	auipc	ra,0x0
     cde:	c20080e7          	jalr	-992(ra) # 8fa <putc>
        putc(fd, c);
     ce2:	fdc42783          	lw	a5,-36(s0)
     ce6:	0ff7f713          	zext.b	a4,a5
     cea:	fcc42783          	lw	a5,-52(s0)
     cee:	85ba                	mv	a1,a4
     cf0:	853e                	mv	a0,a5
     cf2:	00000097          	auipc	ra,0x0
     cf6:	c08080e7          	jalr	-1016(ra) # 8fa <putc>
      }
      state = 0;
     cfa:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
     cfe:	fe442783          	lw	a5,-28(s0)
     d02:	2785                	addiw	a5,a5,1
     d04:	fef42223          	sw	a5,-28(s0)
     d08:	fe442783          	lw	a5,-28(s0)
     d0c:	fc043703          	ld	a4,-64(s0)
     d10:	97ba                	add	a5,a5,a4
     d12:	0007c783          	lbu	a5,0(a5)
     d16:	dc0795e3          	bnez	a5,ae0 <vprintf+0x20>
    }
  }
}
     d1a:	0001                	nop
     d1c:	0001                	nop
     d1e:	60a6                	ld	ra,72(sp)
     d20:	6406                	ld	s0,64(sp)
     d22:	6161                	addi	sp,sp,80
     d24:	8082                	ret

0000000000000d26 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     d26:	7159                	addi	sp,sp,-112
     d28:	fc06                	sd	ra,56(sp)
     d2a:	f822                	sd	s0,48(sp)
     d2c:	0080                	addi	s0,sp,64
     d2e:	fcb43823          	sd	a1,-48(s0)
     d32:	e010                	sd	a2,0(s0)
     d34:	e414                	sd	a3,8(s0)
     d36:	e818                	sd	a4,16(s0)
     d38:	ec1c                	sd	a5,24(s0)
     d3a:	03043023          	sd	a6,32(s0)
     d3e:	03143423          	sd	a7,40(s0)
     d42:	87aa                	mv	a5,a0
     d44:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
     d48:	03040793          	addi	a5,s0,48
     d4c:	fcf43423          	sd	a5,-56(s0)
     d50:	fc843783          	ld	a5,-56(s0)
     d54:	fd078793          	addi	a5,a5,-48
     d58:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
     d5c:	fe843703          	ld	a4,-24(s0)
     d60:	fdc42783          	lw	a5,-36(s0)
     d64:	863a                	mv	a2,a4
     d66:	fd043583          	ld	a1,-48(s0)
     d6a:	853e                	mv	a0,a5
     d6c:	00000097          	auipc	ra,0x0
     d70:	d54080e7          	jalr	-684(ra) # ac0 <vprintf>
}
     d74:	0001                	nop
     d76:	70e2                	ld	ra,56(sp)
     d78:	7442                	ld	s0,48(sp)
     d7a:	6165                	addi	sp,sp,112
     d7c:	8082                	ret

0000000000000d7e <printf>:

void
printf(const char *fmt, ...)
{
     d7e:	7159                	addi	sp,sp,-112
     d80:	f406                	sd	ra,40(sp)
     d82:	f022                	sd	s0,32(sp)
     d84:	1800                	addi	s0,sp,48
     d86:	fca43c23          	sd	a0,-40(s0)
     d8a:	e40c                	sd	a1,8(s0)
     d8c:	e810                	sd	a2,16(s0)
     d8e:	ec14                	sd	a3,24(s0)
     d90:	f018                	sd	a4,32(s0)
     d92:	f41c                	sd	a5,40(s0)
     d94:	03043823          	sd	a6,48(s0)
     d98:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     d9c:	04040793          	addi	a5,s0,64
     da0:	fcf43823          	sd	a5,-48(s0)
     da4:	fd043783          	ld	a5,-48(s0)
     da8:	fc878793          	addi	a5,a5,-56
     dac:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
     db0:	fe843783          	ld	a5,-24(s0)
     db4:	863e                	mv	a2,a5
     db6:	fd843583          	ld	a1,-40(s0)
     dba:	4505                	li	a0,1
     dbc:	00000097          	auipc	ra,0x0
     dc0:	d04080e7          	jalr	-764(ra) # ac0 <vprintf>
}
     dc4:	0001                	nop
     dc6:	70a2                	ld	ra,40(sp)
     dc8:	7402                	ld	s0,32(sp)
     dca:	6165                	addi	sp,sp,112
     dcc:	8082                	ret

0000000000000dce <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     dce:	7179                	addi	sp,sp,-48
     dd0:	f406                	sd	ra,40(sp)
     dd2:	f022                	sd	s0,32(sp)
     dd4:	1800                	addi	s0,sp,48
     dd6:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
     dda:	fd843783          	ld	a5,-40(s0)
     dde:	17c1                	addi	a5,a5,-16
     de0:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     de4:	00001797          	auipc	a5,0x1
     de8:	25c78793          	addi	a5,a5,604 # 2040 <freep>
     dec:	639c                	ld	a5,0(a5)
     dee:	fef43423          	sd	a5,-24(s0)
     df2:	a815                	j	e26 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     df4:	fe843783          	ld	a5,-24(s0)
     df8:	639c                	ld	a5,0(a5)
     dfa:	fe843703          	ld	a4,-24(s0)
     dfe:	00f76f63          	bltu	a4,a5,e1c <free+0x4e>
     e02:	fe043703          	ld	a4,-32(s0)
     e06:	fe843783          	ld	a5,-24(s0)
     e0a:	02e7eb63          	bltu	a5,a4,e40 <free+0x72>
     e0e:	fe843783          	ld	a5,-24(s0)
     e12:	639c                	ld	a5,0(a5)
     e14:	fe043703          	ld	a4,-32(s0)
     e18:	02f76463          	bltu	a4,a5,e40 <free+0x72>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     e1c:	fe843783          	ld	a5,-24(s0)
     e20:	639c                	ld	a5,0(a5)
     e22:	fef43423          	sd	a5,-24(s0)
     e26:	fe043703          	ld	a4,-32(s0)
     e2a:	fe843783          	ld	a5,-24(s0)
     e2e:	fce7f3e3          	bgeu	a5,a4,df4 <free+0x26>
     e32:	fe843783          	ld	a5,-24(s0)
     e36:	639c                	ld	a5,0(a5)
     e38:	fe043703          	ld	a4,-32(s0)
     e3c:	faf77ce3          	bgeu	a4,a5,df4 <free+0x26>
      break;
  if(bp + bp->s.size == p->s.ptr){
     e40:	fe043783          	ld	a5,-32(s0)
     e44:	479c                	lw	a5,8(a5)
     e46:	1782                	slli	a5,a5,0x20
     e48:	9381                	srli	a5,a5,0x20
     e4a:	0792                	slli	a5,a5,0x4
     e4c:	fe043703          	ld	a4,-32(s0)
     e50:	973e                	add	a4,a4,a5
     e52:	fe843783          	ld	a5,-24(s0)
     e56:	639c                	ld	a5,0(a5)
     e58:	02f71763          	bne	a4,a5,e86 <free+0xb8>
    bp->s.size += p->s.ptr->s.size;
     e5c:	fe043783          	ld	a5,-32(s0)
     e60:	4798                	lw	a4,8(a5)
     e62:	fe843783          	ld	a5,-24(s0)
     e66:	639c                	ld	a5,0(a5)
     e68:	479c                	lw	a5,8(a5)
     e6a:	9fb9                	addw	a5,a5,a4
     e6c:	0007871b          	sext.w	a4,a5
     e70:	fe043783          	ld	a5,-32(s0)
     e74:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
     e76:	fe843783          	ld	a5,-24(s0)
     e7a:	639c                	ld	a5,0(a5)
     e7c:	6398                	ld	a4,0(a5)
     e7e:	fe043783          	ld	a5,-32(s0)
     e82:	e398                	sd	a4,0(a5)
     e84:	a039                	j	e92 <free+0xc4>
  } else
    bp->s.ptr = p->s.ptr;
     e86:	fe843783          	ld	a5,-24(s0)
     e8a:	6398                	ld	a4,0(a5)
     e8c:	fe043783          	ld	a5,-32(s0)
     e90:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
     e92:	fe843783          	ld	a5,-24(s0)
     e96:	479c                	lw	a5,8(a5)
     e98:	1782                	slli	a5,a5,0x20
     e9a:	9381                	srli	a5,a5,0x20
     e9c:	0792                	slli	a5,a5,0x4
     e9e:	fe843703          	ld	a4,-24(s0)
     ea2:	97ba                	add	a5,a5,a4
     ea4:	fe043703          	ld	a4,-32(s0)
     ea8:	02f71563          	bne	a4,a5,ed2 <free+0x104>
    p->s.size += bp->s.size;
     eac:	fe843783          	ld	a5,-24(s0)
     eb0:	4798                	lw	a4,8(a5)
     eb2:	fe043783          	ld	a5,-32(s0)
     eb6:	479c                	lw	a5,8(a5)
     eb8:	9fb9                	addw	a5,a5,a4
     eba:	0007871b          	sext.w	a4,a5
     ebe:	fe843783          	ld	a5,-24(s0)
     ec2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
     ec4:	fe043783          	ld	a5,-32(s0)
     ec8:	6398                	ld	a4,0(a5)
     eca:	fe843783          	ld	a5,-24(s0)
     ece:	e398                	sd	a4,0(a5)
     ed0:	a031                	j	edc <free+0x10e>
  } else
    p->s.ptr = bp;
     ed2:	fe843783          	ld	a5,-24(s0)
     ed6:	fe043703          	ld	a4,-32(s0)
     eda:	e398                	sd	a4,0(a5)
  freep = p;
     edc:	00001797          	auipc	a5,0x1
     ee0:	16478793          	addi	a5,a5,356 # 2040 <freep>
     ee4:	fe843703          	ld	a4,-24(s0)
     ee8:	e398                	sd	a4,0(a5)
}
     eea:	0001                	nop
     eec:	70a2                	ld	ra,40(sp)
     eee:	7402                	ld	s0,32(sp)
     ef0:	6145                	addi	sp,sp,48
     ef2:	8082                	ret

0000000000000ef4 <morecore>:

static Header*
morecore(uint nu)
{
     ef4:	7179                	addi	sp,sp,-48
     ef6:	f406                	sd	ra,40(sp)
     ef8:	f022                	sd	s0,32(sp)
     efa:	1800                	addi	s0,sp,48
     efc:	87aa                	mv	a5,a0
     efe:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
     f02:	fdc42783          	lw	a5,-36(s0)
     f06:	0007871b          	sext.w	a4,a5
     f0a:	6785                	lui	a5,0x1
     f0c:	00f77563          	bgeu	a4,a5,f16 <morecore+0x22>
    nu = 4096;
     f10:	6785                	lui	a5,0x1
     f12:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
     f16:	fdc42783          	lw	a5,-36(s0)
     f1a:	0047979b          	slliw	a5,a5,0x4
     f1e:	2781                	sext.w	a5,a5
     f20:	853e                	mv	a0,a5
     f22:	00000097          	auipc	ra,0x0
     f26:	9b8080e7          	jalr	-1608(ra) # 8da <sbrk>
     f2a:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
     f2e:	fe843703          	ld	a4,-24(s0)
     f32:	57fd                	li	a5,-1
     f34:	00f71463          	bne	a4,a5,f3c <morecore+0x48>
    return 0;
     f38:	4781                	li	a5,0
     f3a:	a03d                	j	f68 <morecore+0x74>
  hp = (Header*)p;
     f3c:	fe843783          	ld	a5,-24(s0)
     f40:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
     f44:	fe043783          	ld	a5,-32(s0)
     f48:	fdc42703          	lw	a4,-36(s0)
     f4c:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
     f4e:	fe043783          	ld	a5,-32(s0)
     f52:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x9e>
     f54:	853e                	mv	a0,a5
     f56:	00000097          	auipc	ra,0x0
     f5a:	e78080e7          	jalr	-392(ra) # dce <free>
  return freep;
     f5e:	00001797          	auipc	a5,0x1
     f62:	0e278793          	addi	a5,a5,226 # 2040 <freep>
     f66:	639c                	ld	a5,0(a5)
}
     f68:	853e                	mv	a0,a5
     f6a:	70a2                	ld	ra,40(sp)
     f6c:	7402                	ld	s0,32(sp)
     f6e:	6145                	addi	sp,sp,48
     f70:	8082                	ret

0000000000000f72 <malloc>:

void*
malloc(uint nbytes)
{
     f72:	7139                	addi	sp,sp,-64
     f74:	fc06                	sd	ra,56(sp)
     f76:	f822                	sd	s0,48(sp)
     f78:	0080                	addi	s0,sp,64
     f7a:	87aa                	mv	a5,a0
     f7c:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     f80:	fcc46783          	lwu	a5,-52(s0)
     f84:	07bd                	addi	a5,a5,15
     f86:	8391                	srli	a5,a5,0x4
     f88:	2781                	sext.w	a5,a5
     f8a:	2785                	addiw	a5,a5,1
     f8c:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
     f90:	00001797          	auipc	a5,0x1
     f94:	0b078793          	addi	a5,a5,176 # 2040 <freep>
     f98:	639c                	ld	a5,0(a5)
     f9a:	fef43023          	sd	a5,-32(s0)
     f9e:	fe043783          	ld	a5,-32(s0)
     fa2:	ef95                	bnez	a5,fde <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
     fa4:	00001797          	auipc	a5,0x1
     fa8:	08c78793          	addi	a5,a5,140 # 2030 <base>
     fac:	fef43023          	sd	a5,-32(s0)
     fb0:	00001797          	auipc	a5,0x1
     fb4:	09078793          	addi	a5,a5,144 # 2040 <freep>
     fb8:	fe043703          	ld	a4,-32(s0)
     fbc:	e398                	sd	a4,0(a5)
     fbe:	00001797          	auipc	a5,0x1
     fc2:	08278793          	addi	a5,a5,130 # 2040 <freep>
     fc6:	6398                	ld	a4,0(a5)
     fc8:	00001797          	auipc	a5,0x1
     fcc:	06878793          	addi	a5,a5,104 # 2030 <base>
     fd0:	e398                	sd	a4,0(a5)
    base.s.size = 0;
     fd2:	00001797          	auipc	a5,0x1
     fd6:	05e78793          	addi	a5,a5,94 # 2030 <base>
     fda:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     fde:	fe043783          	ld	a5,-32(s0)
     fe2:	639c                	ld	a5,0(a5)
     fe4:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
     fe8:	fe843783          	ld	a5,-24(s0)
     fec:	479c                	lw	a5,8(a5)
     fee:	fdc42703          	lw	a4,-36(s0)
     ff2:	2701                	sext.w	a4,a4
     ff4:	06e7e763          	bltu	a5,a4,1062 <malloc+0xf0>
      if(p->s.size == nunits)
     ff8:	fe843783          	ld	a5,-24(s0)
     ffc:	479c                	lw	a5,8(a5)
     ffe:	fdc42703          	lw	a4,-36(s0)
    1002:	2701                	sext.w	a4,a4
    1004:	00f71963          	bne	a4,a5,1016 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
    1008:	fe843783          	ld	a5,-24(s0)
    100c:	6398                	ld	a4,0(a5)
    100e:	fe043783          	ld	a5,-32(s0)
    1012:	e398                	sd	a4,0(a5)
    1014:	a825                	j	104c <malloc+0xda>
      else {
        p->s.size -= nunits;
    1016:	fe843783          	ld	a5,-24(s0)
    101a:	479c                	lw	a5,8(a5)
    101c:	fdc42703          	lw	a4,-36(s0)
    1020:	9f99                	subw	a5,a5,a4
    1022:	0007871b          	sext.w	a4,a5
    1026:	fe843783          	ld	a5,-24(s0)
    102a:	c798                	sw	a4,8(a5)
        p += p->s.size;
    102c:	fe843783          	ld	a5,-24(s0)
    1030:	479c                	lw	a5,8(a5)
    1032:	1782                	slli	a5,a5,0x20
    1034:	9381                	srli	a5,a5,0x20
    1036:	0792                	slli	a5,a5,0x4
    1038:	fe843703          	ld	a4,-24(s0)
    103c:	97ba                	add	a5,a5,a4
    103e:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
    1042:	fe843783          	ld	a5,-24(s0)
    1046:	fdc42703          	lw	a4,-36(s0)
    104a:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
    104c:	00001797          	auipc	a5,0x1
    1050:	ff478793          	addi	a5,a5,-12 # 2040 <freep>
    1054:	fe043703          	ld	a4,-32(s0)
    1058:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
    105a:	fe843783          	ld	a5,-24(s0)
    105e:	07c1                	addi	a5,a5,16
    1060:	a091                	j	10a4 <malloc+0x132>
    }
    if(p == freep)
    1062:	00001797          	auipc	a5,0x1
    1066:	fde78793          	addi	a5,a5,-34 # 2040 <freep>
    106a:	639c                	ld	a5,0(a5)
    106c:	fe843703          	ld	a4,-24(s0)
    1070:	02f71063          	bne	a4,a5,1090 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
    1074:	fdc42783          	lw	a5,-36(s0)
    1078:	853e                	mv	a0,a5
    107a:	00000097          	auipc	ra,0x0
    107e:	e7a080e7          	jalr	-390(ra) # ef4 <morecore>
    1082:	fea43423          	sd	a0,-24(s0)
    1086:	fe843783          	ld	a5,-24(s0)
    108a:	e399                	bnez	a5,1090 <malloc+0x11e>
        return 0;
    108c:	4781                	li	a5,0
    108e:	a819                	j	10a4 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1090:	fe843783          	ld	a5,-24(s0)
    1094:	fef43023          	sd	a5,-32(s0)
    1098:	fe843783          	ld	a5,-24(s0)
    109c:	639c                	ld	a5,0(a5)
    109e:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
    10a2:	b799                	j	fe8 <malloc+0x76>
  }
}
    10a4:	853e                	mv	a0,a5
    10a6:	70e2                	ld	ra,56(sp)
    10a8:	7442                	ld	s0,48(sp)
    10aa:	6121                	addi	sp,sp,64
    10ac:	8082                	ret
