
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
     130:	f8458593          	addi	a1,a1,-124 # 10b0 <malloc+0x146>
     134:	4509                	li	a0,2
     136:	00001097          	auipc	ra,0x1
     13a:	be8080e7          	jalr	-1048(ra) # d1e <fprintf>
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
     162:	f6a58593          	addi	a1,a1,-150 # 10c8 <malloc+0x15e>
     166:	4509                	li	a0,2
     168:	00001097          	auipc	ra,0x1
     16c:	bb6080e7          	jalr	-1098(ra) # d1e <fprintf>
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
     1bc:	f2850513          	addi	a0,a0,-216 # 10e0 <malloc+0x176>
     1c0:	00001097          	auipc	ra,0x1
     1c4:	bb6080e7          	jalr	-1098(ra) # d76 <printf>
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
     1ea:	f0a50513          	addi	a0,a0,-246 # 10f0 <malloc+0x186>
     1ee:	00001097          	auipc	ra,0x1
     1f2:	b88080e7          	jalr	-1144(ra) # d76 <printf>
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
     288:	e4450513          	addi	a0,a0,-444 # 10c8 <malloc+0x15e>
     28c:	00001097          	auipc	ra,0x1
     290:	aea080e7          	jalr	-1302(ra) # d76 <printf>
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
     2ba:	e5250513          	addi	a0,a0,-430 # 1108 <malloc+0x19e>
     2be:	00001097          	auipc	ra,0x1
     2c2:	ab8080e7          	jalr	-1352(ra) # d76 <printf>
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
     32c:	df050513          	addi	a0,a0,-528 # 1118 <malloc+0x1ae>
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

00000000000008f2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     8f2:	1101                	addi	sp,sp,-32
     8f4:	ec06                	sd	ra,24(sp)
     8f6:	e822                	sd	s0,16(sp)
     8f8:	1000                	addi	s0,sp,32
     8fa:	87aa                	mv	a5,a0
     8fc:	872e                	mv	a4,a1
     8fe:	fef42623          	sw	a5,-20(s0)
     902:	87ba                	mv	a5,a4
     904:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
     908:	feb40713          	addi	a4,s0,-21
     90c:	fec42783          	lw	a5,-20(s0)
     910:	4605                	li	a2,1
     912:	85ba                	mv	a1,a4
     914:	853e                	mv	a0,a5
     916:	00000097          	auipc	ra,0x0
     91a:	f5c080e7          	jalr	-164(ra) # 872 <write>
}
     91e:	0001                	nop
     920:	60e2                	ld	ra,24(sp)
     922:	6442                	ld	s0,16(sp)
     924:	6105                	addi	sp,sp,32
     926:	8082                	ret

0000000000000928 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     928:	7139                	addi	sp,sp,-64
     92a:	fc06                	sd	ra,56(sp)
     92c:	f822                	sd	s0,48(sp)
     92e:	0080                	addi	s0,sp,64
     930:	87aa                	mv	a5,a0
     932:	8736                	mv	a4,a3
     934:	fcf42623          	sw	a5,-52(s0)
     938:	87ae                	mv	a5,a1
     93a:	fcf42423          	sw	a5,-56(s0)
     93e:	87b2                	mv	a5,a2
     940:	fcf42223          	sw	a5,-60(s0)
     944:	87ba                	mv	a5,a4
     946:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     94a:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
     94e:	fc042783          	lw	a5,-64(s0)
     952:	2781                	sext.w	a5,a5
     954:	c38d                	beqz	a5,976 <printint+0x4e>
     956:	fc842783          	lw	a5,-56(s0)
     95a:	2781                	sext.w	a5,a5
     95c:	0007dd63          	bgez	a5,976 <printint+0x4e>
    neg = 1;
     960:	4785                	li	a5,1
     962:	fef42423          	sw	a5,-24(s0)
    x = -xx;
     966:	fc842783          	lw	a5,-56(s0)
     96a:	40f007bb          	negw	a5,a5
     96e:	2781                	sext.w	a5,a5
     970:	fef42223          	sw	a5,-28(s0)
     974:	a029                	j	97e <printint+0x56>
  } else {
    x = xx;
     976:	fc842783          	lw	a5,-56(s0)
     97a:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
     97e:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
     982:	fc442783          	lw	a5,-60(s0)
     986:	fe442703          	lw	a4,-28(s0)
     98a:	02f777bb          	remuw	a5,a4,a5
     98e:	0007871b          	sext.w	a4,a5
     992:	fec42783          	lw	a5,-20(s0)
     996:	0017869b          	addiw	a3,a5,1
     99a:	fed42623          	sw	a3,-20(s0)
     99e:	00001697          	auipc	a3,0x1
     9a2:	66268693          	addi	a3,a3,1634 # 2000 <digits>
     9a6:	1702                	slli	a4,a4,0x20
     9a8:	9301                	srli	a4,a4,0x20
     9aa:	9736                	add	a4,a4,a3
     9ac:	00074703          	lbu	a4,0(a4)
     9b0:	17c1                	addi	a5,a5,-16
     9b2:	97a2                	add	a5,a5,s0
     9b4:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
     9b8:	fc442783          	lw	a5,-60(s0)
     9bc:	fe442703          	lw	a4,-28(s0)
     9c0:	02f757bb          	divuw	a5,a4,a5
     9c4:	fef42223          	sw	a5,-28(s0)
     9c8:	fe442783          	lw	a5,-28(s0)
     9cc:	2781                	sext.w	a5,a5
     9ce:	fbd5                	bnez	a5,982 <printint+0x5a>
  if(neg)
     9d0:	fe842783          	lw	a5,-24(s0)
     9d4:	2781                	sext.w	a5,a5
     9d6:	cf85                	beqz	a5,a0e <printint+0xe6>
    buf[i++] = '-';
     9d8:	fec42783          	lw	a5,-20(s0)
     9dc:	0017871b          	addiw	a4,a5,1
     9e0:	fee42623          	sw	a4,-20(s0)
     9e4:	17c1                	addi	a5,a5,-16
     9e6:	97a2                	add	a5,a5,s0
     9e8:	02d00713          	li	a4,45
     9ec:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
     9f0:	a839                	j	a0e <printint+0xe6>
    putc(fd, buf[i]);
     9f2:	fec42783          	lw	a5,-20(s0)
     9f6:	17c1                	addi	a5,a5,-16
     9f8:	97a2                	add	a5,a5,s0
     9fa:	fe07c703          	lbu	a4,-32(a5)
     9fe:	fcc42783          	lw	a5,-52(s0)
     a02:	85ba                	mv	a1,a4
     a04:	853e                	mv	a0,a5
     a06:	00000097          	auipc	ra,0x0
     a0a:	eec080e7          	jalr	-276(ra) # 8f2 <putc>
  while(--i >= 0)
     a0e:	fec42783          	lw	a5,-20(s0)
     a12:	37fd                	addiw	a5,a5,-1
     a14:	fef42623          	sw	a5,-20(s0)
     a18:	fec42783          	lw	a5,-20(s0)
     a1c:	2781                	sext.w	a5,a5
     a1e:	fc07dae3          	bgez	a5,9f2 <printint+0xca>
}
     a22:	0001                	nop
     a24:	0001                	nop
     a26:	70e2                	ld	ra,56(sp)
     a28:	7442                	ld	s0,48(sp)
     a2a:	6121                	addi	sp,sp,64
     a2c:	8082                	ret

0000000000000a2e <printptr>:

static void
printptr(int fd, uint64 x) {
     a2e:	7179                	addi	sp,sp,-48
     a30:	f406                	sd	ra,40(sp)
     a32:	f022                	sd	s0,32(sp)
     a34:	1800                	addi	s0,sp,48
     a36:	87aa                	mv	a5,a0
     a38:	fcb43823          	sd	a1,-48(s0)
     a3c:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
     a40:	fdc42783          	lw	a5,-36(s0)
     a44:	03000593          	li	a1,48
     a48:	853e                	mv	a0,a5
     a4a:	00000097          	auipc	ra,0x0
     a4e:	ea8080e7          	jalr	-344(ra) # 8f2 <putc>
  putc(fd, 'x');
     a52:	fdc42783          	lw	a5,-36(s0)
     a56:	07800593          	li	a1,120
     a5a:	853e                	mv	a0,a5
     a5c:	00000097          	auipc	ra,0x0
     a60:	e96080e7          	jalr	-362(ra) # 8f2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     a64:	fe042623          	sw	zero,-20(s0)
     a68:	a82d                	j	aa2 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     a6a:	fd043783          	ld	a5,-48(s0)
     a6e:	93f1                	srli	a5,a5,0x3c
     a70:	00001717          	auipc	a4,0x1
     a74:	59070713          	addi	a4,a4,1424 # 2000 <digits>
     a78:	97ba                	add	a5,a5,a4
     a7a:	0007c703          	lbu	a4,0(a5)
     a7e:	fdc42783          	lw	a5,-36(s0)
     a82:	85ba                	mv	a1,a4
     a84:	853e                	mv	a0,a5
     a86:	00000097          	auipc	ra,0x0
     a8a:	e6c080e7          	jalr	-404(ra) # 8f2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     a8e:	fec42783          	lw	a5,-20(s0)
     a92:	2785                	addiw	a5,a5,1
     a94:	fef42623          	sw	a5,-20(s0)
     a98:	fd043783          	ld	a5,-48(s0)
     a9c:	0792                	slli	a5,a5,0x4
     a9e:	fcf43823          	sd	a5,-48(s0)
     aa2:	fec42703          	lw	a4,-20(s0)
     aa6:	47bd                	li	a5,15
     aa8:	fce7f1e3          	bgeu	a5,a4,a6a <printptr+0x3c>
}
     aac:	0001                	nop
     aae:	0001                	nop
     ab0:	70a2                	ld	ra,40(sp)
     ab2:	7402                	ld	s0,32(sp)
     ab4:	6145                	addi	sp,sp,48
     ab6:	8082                	ret

0000000000000ab8 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     ab8:	715d                	addi	sp,sp,-80
     aba:	e486                	sd	ra,72(sp)
     abc:	e0a2                	sd	s0,64(sp)
     abe:	0880                	addi	s0,sp,80
     ac0:	87aa                	mv	a5,a0
     ac2:	fcb43023          	sd	a1,-64(s0)
     ac6:	fac43c23          	sd	a2,-72(s0)
     aca:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
     ace:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
     ad2:	fe042223          	sw	zero,-28(s0)
     ad6:	a42d                	j	d00 <vprintf+0x248>
    c = fmt[i] & 0xff;
     ad8:	fe442783          	lw	a5,-28(s0)
     adc:	fc043703          	ld	a4,-64(s0)
     ae0:	97ba                	add	a5,a5,a4
     ae2:	0007c783          	lbu	a5,0(a5)
     ae6:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
     aea:	fe042783          	lw	a5,-32(s0)
     aee:	2781                	sext.w	a5,a5
     af0:	eb9d                	bnez	a5,b26 <vprintf+0x6e>
      if(c == '%'){
     af2:	fdc42783          	lw	a5,-36(s0)
     af6:	0007871b          	sext.w	a4,a5
     afa:	02500793          	li	a5,37
     afe:	00f71763          	bne	a4,a5,b0c <vprintf+0x54>
        state = '%';
     b02:	02500793          	li	a5,37
     b06:	fef42023          	sw	a5,-32(s0)
     b0a:	a2f5                	j	cf6 <vprintf+0x23e>
      } else {
        putc(fd, c);
     b0c:	fdc42783          	lw	a5,-36(s0)
     b10:	0ff7f713          	zext.b	a4,a5
     b14:	fcc42783          	lw	a5,-52(s0)
     b18:	85ba                	mv	a1,a4
     b1a:	853e                	mv	a0,a5
     b1c:	00000097          	auipc	ra,0x0
     b20:	dd6080e7          	jalr	-554(ra) # 8f2 <putc>
     b24:	aac9                	j	cf6 <vprintf+0x23e>
      }
    } else if(state == '%'){
     b26:	fe042783          	lw	a5,-32(s0)
     b2a:	0007871b          	sext.w	a4,a5
     b2e:	02500793          	li	a5,37
     b32:	1cf71263          	bne	a4,a5,cf6 <vprintf+0x23e>
      if(c == 'd'){
     b36:	fdc42783          	lw	a5,-36(s0)
     b3a:	0007871b          	sext.w	a4,a5
     b3e:	06400793          	li	a5,100
     b42:	02f71463          	bne	a4,a5,b6a <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
     b46:	fb843783          	ld	a5,-72(s0)
     b4a:	00878713          	addi	a4,a5,8
     b4e:	fae43c23          	sd	a4,-72(s0)
     b52:	4398                	lw	a4,0(a5)
     b54:	fcc42783          	lw	a5,-52(s0)
     b58:	4685                	li	a3,1
     b5a:	4629                	li	a2,10
     b5c:	85ba                	mv	a1,a4
     b5e:	853e                	mv	a0,a5
     b60:	00000097          	auipc	ra,0x0
     b64:	dc8080e7          	jalr	-568(ra) # 928 <printint>
     b68:	a269                	j	cf2 <vprintf+0x23a>
      } else if(c == 'l') {
     b6a:	fdc42783          	lw	a5,-36(s0)
     b6e:	0007871b          	sext.w	a4,a5
     b72:	06c00793          	li	a5,108
     b76:	02f71663          	bne	a4,a5,ba2 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
     b7a:	fb843783          	ld	a5,-72(s0)
     b7e:	00878713          	addi	a4,a5,8
     b82:	fae43c23          	sd	a4,-72(s0)
     b86:	639c                	ld	a5,0(a5)
     b88:	0007871b          	sext.w	a4,a5
     b8c:	fcc42783          	lw	a5,-52(s0)
     b90:	4681                	li	a3,0
     b92:	4629                	li	a2,10
     b94:	85ba                	mv	a1,a4
     b96:	853e                	mv	a0,a5
     b98:	00000097          	auipc	ra,0x0
     b9c:	d90080e7          	jalr	-624(ra) # 928 <printint>
     ba0:	aa89                	j	cf2 <vprintf+0x23a>
      } else if(c == 'x') {
     ba2:	fdc42783          	lw	a5,-36(s0)
     ba6:	0007871b          	sext.w	a4,a5
     baa:	07800793          	li	a5,120
     bae:	02f71463          	bne	a4,a5,bd6 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
     bb2:	fb843783          	ld	a5,-72(s0)
     bb6:	00878713          	addi	a4,a5,8
     bba:	fae43c23          	sd	a4,-72(s0)
     bbe:	4398                	lw	a4,0(a5)
     bc0:	fcc42783          	lw	a5,-52(s0)
     bc4:	4681                	li	a3,0
     bc6:	4641                	li	a2,16
     bc8:	85ba                	mv	a1,a4
     bca:	853e                	mv	a0,a5
     bcc:	00000097          	auipc	ra,0x0
     bd0:	d5c080e7          	jalr	-676(ra) # 928 <printint>
     bd4:	aa39                	j	cf2 <vprintf+0x23a>
      } else if(c == 'p') {
     bd6:	fdc42783          	lw	a5,-36(s0)
     bda:	0007871b          	sext.w	a4,a5
     bde:	07000793          	li	a5,112
     be2:	02f71263          	bne	a4,a5,c06 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
     be6:	fb843783          	ld	a5,-72(s0)
     bea:	00878713          	addi	a4,a5,8
     bee:	fae43c23          	sd	a4,-72(s0)
     bf2:	6398                	ld	a4,0(a5)
     bf4:	fcc42783          	lw	a5,-52(s0)
     bf8:	85ba                	mv	a1,a4
     bfa:	853e                	mv	a0,a5
     bfc:	00000097          	auipc	ra,0x0
     c00:	e32080e7          	jalr	-462(ra) # a2e <printptr>
     c04:	a0fd                	j	cf2 <vprintf+0x23a>
      } else if(c == 's'){
     c06:	fdc42783          	lw	a5,-36(s0)
     c0a:	0007871b          	sext.w	a4,a5
     c0e:	07300793          	li	a5,115
     c12:	04f71c63          	bne	a4,a5,c6a <vprintf+0x1b2>
        s = va_arg(ap, char*);
     c16:	fb843783          	ld	a5,-72(s0)
     c1a:	00878713          	addi	a4,a5,8
     c1e:	fae43c23          	sd	a4,-72(s0)
     c22:	639c                	ld	a5,0(a5)
     c24:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
     c28:	fe843783          	ld	a5,-24(s0)
     c2c:	eb8d                	bnez	a5,c5e <vprintf+0x1a6>
          s = "(null)";
     c2e:	00000797          	auipc	a5,0x0
     c32:	4f278793          	addi	a5,a5,1266 # 1120 <malloc+0x1b6>
     c36:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
     c3a:	a015                	j	c5e <vprintf+0x1a6>
          putc(fd, *s);
     c3c:	fe843783          	ld	a5,-24(s0)
     c40:	0007c703          	lbu	a4,0(a5)
     c44:	fcc42783          	lw	a5,-52(s0)
     c48:	85ba                	mv	a1,a4
     c4a:	853e                	mv	a0,a5
     c4c:	00000097          	auipc	ra,0x0
     c50:	ca6080e7          	jalr	-858(ra) # 8f2 <putc>
          s++;
     c54:	fe843783          	ld	a5,-24(s0)
     c58:	0785                	addi	a5,a5,1
     c5a:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
     c5e:	fe843783          	ld	a5,-24(s0)
     c62:	0007c783          	lbu	a5,0(a5)
     c66:	fbf9                	bnez	a5,c3c <vprintf+0x184>
     c68:	a069                	j	cf2 <vprintf+0x23a>
        }
      } else if(c == 'c'){
     c6a:	fdc42783          	lw	a5,-36(s0)
     c6e:	0007871b          	sext.w	a4,a5
     c72:	06300793          	li	a5,99
     c76:	02f71463          	bne	a4,a5,c9e <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
     c7a:	fb843783          	ld	a5,-72(s0)
     c7e:	00878713          	addi	a4,a5,8
     c82:	fae43c23          	sd	a4,-72(s0)
     c86:	439c                	lw	a5,0(a5)
     c88:	0ff7f713          	zext.b	a4,a5
     c8c:	fcc42783          	lw	a5,-52(s0)
     c90:	85ba                	mv	a1,a4
     c92:	853e                	mv	a0,a5
     c94:	00000097          	auipc	ra,0x0
     c98:	c5e080e7          	jalr	-930(ra) # 8f2 <putc>
     c9c:	a899                	j	cf2 <vprintf+0x23a>
      } else if(c == '%'){
     c9e:	fdc42783          	lw	a5,-36(s0)
     ca2:	0007871b          	sext.w	a4,a5
     ca6:	02500793          	li	a5,37
     caa:	00f71f63          	bne	a4,a5,cc8 <vprintf+0x210>
        putc(fd, c);
     cae:	fdc42783          	lw	a5,-36(s0)
     cb2:	0ff7f713          	zext.b	a4,a5
     cb6:	fcc42783          	lw	a5,-52(s0)
     cba:	85ba                	mv	a1,a4
     cbc:	853e                	mv	a0,a5
     cbe:	00000097          	auipc	ra,0x0
     cc2:	c34080e7          	jalr	-972(ra) # 8f2 <putc>
     cc6:	a035                	j	cf2 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     cc8:	fcc42783          	lw	a5,-52(s0)
     ccc:	02500593          	li	a1,37
     cd0:	853e                	mv	a0,a5
     cd2:	00000097          	auipc	ra,0x0
     cd6:	c20080e7          	jalr	-992(ra) # 8f2 <putc>
        putc(fd, c);
     cda:	fdc42783          	lw	a5,-36(s0)
     cde:	0ff7f713          	zext.b	a4,a5
     ce2:	fcc42783          	lw	a5,-52(s0)
     ce6:	85ba                	mv	a1,a4
     ce8:	853e                	mv	a0,a5
     cea:	00000097          	auipc	ra,0x0
     cee:	c08080e7          	jalr	-1016(ra) # 8f2 <putc>
      }
      state = 0;
     cf2:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
     cf6:	fe442783          	lw	a5,-28(s0)
     cfa:	2785                	addiw	a5,a5,1
     cfc:	fef42223          	sw	a5,-28(s0)
     d00:	fe442783          	lw	a5,-28(s0)
     d04:	fc043703          	ld	a4,-64(s0)
     d08:	97ba                	add	a5,a5,a4
     d0a:	0007c783          	lbu	a5,0(a5)
     d0e:	dc0795e3          	bnez	a5,ad8 <vprintf+0x20>
    }
  }
}
     d12:	0001                	nop
     d14:	0001                	nop
     d16:	60a6                	ld	ra,72(sp)
     d18:	6406                	ld	s0,64(sp)
     d1a:	6161                	addi	sp,sp,80
     d1c:	8082                	ret

0000000000000d1e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     d1e:	7159                	addi	sp,sp,-112
     d20:	fc06                	sd	ra,56(sp)
     d22:	f822                	sd	s0,48(sp)
     d24:	0080                	addi	s0,sp,64
     d26:	fcb43823          	sd	a1,-48(s0)
     d2a:	e010                	sd	a2,0(s0)
     d2c:	e414                	sd	a3,8(s0)
     d2e:	e818                	sd	a4,16(s0)
     d30:	ec1c                	sd	a5,24(s0)
     d32:	03043023          	sd	a6,32(s0)
     d36:	03143423          	sd	a7,40(s0)
     d3a:	87aa                	mv	a5,a0
     d3c:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
     d40:	03040793          	addi	a5,s0,48
     d44:	fcf43423          	sd	a5,-56(s0)
     d48:	fc843783          	ld	a5,-56(s0)
     d4c:	fd078793          	addi	a5,a5,-48
     d50:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
     d54:	fe843703          	ld	a4,-24(s0)
     d58:	fdc42783          	lw	a5,-36(s0)
     d5c:	863a                	mv	a2,a4
     d5e:	fd043583          	ld	a1,-48(s0)
     d62:	853e                	mv	a0,a5
     d64:	00000097          	auipc	ra,0x0
     d68:	d54080e7          	jalr	-684(ra) # ab8 <vprintf>
}
     d6c:	0001                	nop
     d6e:	70e2                	ld	ra,56(sp)
     d70:	7442                	ld	s0,48(sp)
     d72:	6165                	addi	sp,sp,112
     d74:	8082                	ret

0000000000000d76 <printf>:

void
printf(const char *fmt, ...)
{
     d76:	7159                	addi	sp,sp,-112
     d78:	f406                	sd	ra,40(sp)
     d7a:	f022                	sd	s0,32(sp)
     d7c:	1800                	addi	s0,sp,48
     d7e:	fca43c23          	sd	a0,-40(s0)
     d82:	e40c                	sd	a1,8(s0)
     d84:	e810                	sd	a2,16(s0)
     d86:	ec14                	sd	a3,24(s0)
     d88:	f018                	sd	a4,32(s0)
     d8a:	f41c                	sd	a5,40(s0)
     d8c:	03043823          	sd	a6,48(s0)
     d90:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     d94:	04040793          	addi	a5,s0,64
     d98:	fcf43823          	sd	a5,-48(s0)
     d9c:	fd043783          	ld	a5,-48(s0)
     da0:	fc878793          	addi	a5,a5,-56
     da4:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
     da8:	fe843783          	ld	a5,-24(s0)
     dac:	863e                	mv	a2,a5
     dae:	fd843583          	ld	a1,-40(s0)
     db2:	4505                	li	a0,1
     db4:	00000097          	auipc	ra,0x0
     db8:	d04080e7          	jalr	-764(ra) # ab8 <vprintf>
}
     dbc:	0001                	nop
     dbe:	70a2                	ld	ra,40(sp)
     dc0:	7402                	ld	s0,32(sp)
     dc2:	6165                	addi	sp,sp,112
     dc4:	8082                	ret

0000000000000dc6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     dc6:	7179                	addi	sp,sp,-48
     dc8:	f406                	sd	ra,40(sp)
     dca:	f022                	sd	s0,32(sp)
     dcc:	1800                	addi	s0,sp,48
     dce:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
     dd2:	fd843783          	ld	a5,-40(s0)
     dd6:	17c1                	addi	a5,a5,-16
     dd8:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     ddc:	00001797          	auipc	a5,0x1
     de0:	26478793          	addi	a5,a5,612 # 2040 <freep>
     de4:	639c                	ld	a5,0(a5)
     de6:	fef43423          	sd	a5,-24(s0)
     dea:	a815                	j	e1e <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     dec:	fe843783          	ld	a5,-24(s0)
     df0:	639c                	ld	a5,0(a5)
     df2:	fe843703          	ld	a4,-24(s0)
     df6:	00f76f63          	bltu	a4,a5,e14 <free+0x4e>
     dfa:	fe043703          	ld	a4,-32(s0)
     dfe:	fe843783          	ld	a5,-24(s0)
     e02:	02e7eb63          	bltu	a5,a4,e38 <free+0x72>
     e06:	fe843783          	ld	a5,-24(s0)
     e0a:	639c                	ld	a5,0(a5)
     e0c:	fe043703          	ld	a4,-32(s0)
     e10:	02f76463          	bltu	a4,a5,e38 <free+0x72>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     e14:	fe843783          	ld	a5,-24(s0)
     e18:	639c                	ld	a5,0(a5)
     e1a:	fef43423          	sd	a5,-24(s0)
     e1e:	fe043703          	ld	a4,-32(s0)
     e22:	fe843783          	ld	a5,-24(s0)
     e26:	fce7f3e3          	bgeu	a5,a4,dec <free+0x26>
     e2a:	fe843783          	ld	a5,-24(s0)
     e2e:	639c                	ld	a5,0(a5)
     e30:	fe043703          	ld	a4,-32(s0)
     e34:	faf77ce3          	bgeu	a4,a5,dec <free+0x26>
      break;
  if(bp + bp->s.size == p->s.ptr){
     e38:	fe043783          	ld	a5,-32(s0)
     e3c:	479c                	lw	a5,8(a5)
     e3e:	1782                	slli	a5,a5,0x20
     e40:	9381                	srli	a5,a5,0x20
     e42:	0792                	slli	a5,a5,0x4
     e44:	fe043703          	ld	a4,-32(s0)
     e48:	973e                	add	a4,a4,a5
     e4a:	fe843783          	ld	a5,-24(s0)
     e4e:	639c                	ld	a5,0(a5)
     e50:	02f71763          	bne	a4,a5,e7e <free+0xb8>
    bp->s.size += p->s.ptr->s.size;
     e54:	fe043783          	ld	a5,-32(s0)
     e58:	4798                	lw	a4,8(a5)
     e5a:	fe843783          	ld	a5,-24(s0)
     e5e:	639c                	ld	a5,0(a5)
     e60:	479c                	lw	a5,8(a5)
     e62:	9fb9                	addw	a5,a5,a4
     e64:	0007871b          	sext.w	a4,a5
     e68:	fe043783          	ld	a5,-32(s0)
     e6c:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
     e6e:	fe843783          	ld	a5,-24(s0)
     e72:	639c                	ld	a5,0(a5)
     e74:	6398                	ld	a4,0(a5)
     e76:	fe043783          	ld	a5,-32(s0)
     e7a:	e398                	sd	a4,0(a5)
     e7c:	a039                	j	e8a <free+0xc4>
  } else
    bp->s.ptr = p->s.ptr;
     e7e:	fe843783          	ld	a5,-24(s0)
     e82:	6398                	ld	a4,0(a5)
     e84:	fe043783          	ld	a5,-32(s0)
     e88:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
     e8a:	fe843783          	ld	a5,-24(s0)
     e8e:	479c                	lw	a5,8(a5)
     e90:	1782                	slli	a5,a5,0x20
     e92:	9381                	srli	a5,a5,0x20
     e94:	0792                	slli	a5,a5,0x4
     e96:	fe843703          	ld	a4,-24(s0)
     e9a:	97ba                	add	a5,a5,a4
     e9c:	fe043703          	ld	a4,-32(s0)
     ea0:	02f71563          	bne	a4,a5,eca <free+0x104>
    p->s.size += bp->s.size;
     ea4:	fe843783          	ld	a5,-24(s0)
     ea8:	4798                	lw	a4,8(a5)
     eaa:	fe043783          	ld	a5,-32(s0)
     eae:	479c                	lw	a5,8(a5)
     eb0:	9fb9                	addw	a5,a5,a4
     eb2:	0007871b          	sext.w	a4,a5
     eb6:	fe843783          	ld	a5,-24(s0)
     eba:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
     ebc:	fe043783          	ld	a5,-32(s0)
     ec0:	6398                	ld	a4,0(a5)
     ec2:	fe843783          	ld	a5,-24(s0)
     ec6:	e398                	sd	a4,0(a5)
     ec8:	a031                	j	ed4 <free+0x10e>
  } else
    p->s.ptr = bp;
     eca:	fe843783          	ld	a5,-24(s0)
     ece:	fe043703          	ld	a4,-32(s0)
     ed2:	e398                	sd	a4,0(a5)
  freep = p;
     ed4:	00001797          	auipc	a5,0x1
     ed8:	16c78793          	addi	a5,a5,364 # 2040 <freep>
     edc:	fe843703          	ld	a4,-24(s0)
     ee0:	e398                	sd	a4,0(a5)
}
     ee2:	0001                	nop
     ee4:	70a2                	ld	ra,40(sp)
     ee6:	7402                	ld	s0,32(sp)
     ee8:	6145                	addi	sp,sp,48
     eea:	8082                	ret

0000000000000eec <morecore>:

static Header*
morecore(uint nu)
{
     eec:	7179                	addi	sp,sp,-48
     eee:	f406                	sd	ra,40(sp)
     ef0:	f022                	sd	s0,32(sp)
     ef2:	1800                	addi	s0,sp,48
     ef4:	87aa                	mv	a5,a0
     ef6:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
     efa:	fdc42783          	lw	a5,-36(s0)
     efe:	0007871b          	sext.w	a4,a5
     f02:	6785                	lui	a5,0x1
     f04:	00f77563          	bgeu	a4,a5,f0e <morecore+0x22>
    nu = 4096;
     f08:	6785                	lui	a5,0x1
     f0a:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
     f0e:	fdc42783          	lw	a5,-36(s0)
     f12:	0047979b          	slliw	a5,a5,0x4
     f16:	2781                	sext.w	a5,a5
     f18:	853e                	mv	a0,a5
     f1a:	00000097          	auipc	ra,0x0
     f1e:	9c0080e7          	jalr	-1600(ra) # 8da <sbrk>
     f22:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
     f26:	fe843703          	ld	a4,-24(s0)
     f2a:	57fd                	li	a5,-1
     f2c:	00f71463          	bne	a4,a5,f34 <morecore+0x48>
    return 0;
     f30:	4781                	li	a5,0
     f32:	a03d                	j	f60 <morecore+0x74>
  hp = (Header*)p;
     f34:	fe843783          	ld	a5,-24(s0)
     f38:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
     f3c:	fe043783          	ld	a5,-32(s0)
     f40:	fdc42703          	lw	a4,-36(s0)
     f44:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
     f46:	fe043783          	ld	a5,-32(s0)
     f4a:	07c1                	addi	a5,a5,16 # 1010 <malloc+0xa6>
     f4c:	853e                	mv	a0,a5
     f4e:	00000097          	auipc	ra,0x0
     f52:	e78080e7          	jalr	-392(ra) # dc6 <free>
  return freep;
     f56:	00001797          	auipc	a5,0x1
     f5a:	0ea78793          	addi	a5,a5,234 # 2040 <freep>
     f5e:	639c                	ld	a5,0(a5)
}
     f60:	853e                	mv	a0,a5
     f62:	70a2                	ld	ra,40(sp)
     f64:	7402                	ld	s0,32(sp)
     f66:	6145                	addi	sp,sp,48
     f68:	8082                	ret

0000000000000f6a <malloc>:

void*
malloc(uint nbytes)
{
     f6a:	7139                	addi	sp,sp,-64
     f6c:	fc06                	sd	ra,56(sp)
     f6e:	f822                	sd	s0,48(sp)
     f70:	0080                	addi	s0,sp,64
     f72:	87aa                	mv	a5,a0
     f74:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     f78:	fcc46783          	lwu	a5,-52(s0)
     f7c:	07bd                	addi	a5,a5,15
     f7e:	8391                	srli	a5,a5,0x4
     f80:	2781                	sext.w	a5,a5
     f82:	2785                	addiw	a5,a5,1
     f84:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
     f88:	00001797          	auipc	a5,0x1
     f8c:	0b878793          	addi	a5,a5,184 # 2040 <freep>
     f90:	639c                	ld	a5,0(a5)
     f92:	fef43023          	sd	a5,-32(s0)
     f96:	fe043783          	ld	a5,-32(s0)
     f9a:	ef95                	bnez	a5,fd6 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
     f9c:	00001797          	auipc	a5,0x1
     fa0:	09478793          	addi	a5,a5,148 # 2030 <base>
     fa4:	fef43023          	sd	a5,-32(s0)
     fa8:	00001797          	auipc	a5,0x1
     fac:	09878793          	addi	a5,a5,152 # 2040 <freep>
     fb0:	fe043703          	ld	a4,-32(s0)
     fb4:	e398                	sd	a4,0(a5)
     fb6:	00001797          	auipc	a5,0x1
     fba:	08a78793          	addi	a5,a5,138 # 2040 <freep>
     fbe:	6398                	ld	a4,0(a5)
     fc0:	00001797          	auipc	a5,0x1
     fc4:	07078793          	addi	a5,a5,112 # 2030 <base>
     fc8:	e398                	sd	a4,0(a5)
    base.s.size = 0;
     fca:	00001797          	auipc	a5,0x1
     fce:	06678793          	addi	a5,a5,102 # 2030 <base>
     fd2:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     fd6:	fe043783          	ld	a5,-32(s0)
     fda:	639c                	ld	a5,0(a5)
     fdc:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
     fe0:	fe843783          	ld	a5,-24(s0)
     fe4:	479c                	lw	a5,8(a5)
     fe6:	fdc42703          	lw	a4,-36(s0)
     fea:	2701                	sext.w	a4,a4
     fec:	06e7e763          	bltu	a5,a4,105a <malloc+0xf0>
      if(p->s.size == nunits)
     ff0:	fe843783          	ld	a5,-24(s0)
     ff4:	479c                	lw	a5,8(a5)
     ff6:	fdc42703          	lw	a4,-36(s0)
     ffa:	2701                	sext.w	a4,a4
     ffc:	00f71963          	bne	a4,a5,100e <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
    1000:	fe843783          	ld	a5,-24(s0)
    1004:	6398                	ld	a4,0(a5)
    1006:	fe043783          	ld	a5,-32(s0)
    100a:	e398                	sd	a4,0(a5)
    100c:	a825                	j	1044 <malloc+0xda>
      else {
        p->s.size -= nunits;
    100e:	fe843783          	ld	a5,-24(s0)
    1012:	479c                	lw	a5,8(a5)
    1014:	fdc42703          	lw	a4,-36(s0)
    1018:	9f99                	subw	a5,a5,a4
    101a:	0007871b          	sext.w	a4,a5
    101e:	fe843783          	ld	a5,-24(s0)
    1022:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1024:	fe843783          	ld	a5,-24(s0)
    1028:	479c                	lw	a5,8(a5)
    102a:	1782                	slli	a5,a5,0x20
    102c:	9381                	srli	a5,a5,0x20
    102e:	0792                	slli	a5,a5,0x4
    1030:	fe843703          	ld	a4,-24(s0)
    1034:	97ba                	add	a5,a5,a4
    1036:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
    103a:	fe843783          	ld	a5,-24(s0)
    103e:	fdc42703          	lw	a4,-36(s0)
    1042:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
    1044:	00001797          	auipc	a5,0x1
    1048:	ffc78793          	addi	a5,a5,-4 # 2040 <freep>
    104c:	fe043703          	ld	a4,-32(s0)
    1050:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
    1052:	fe843783          	ld	a5,-24(s0)
    1056:	07c1                	addi	a5,a5,16
    1058:	a091                	j	109c <malloc+0x132>
    }
    if(p == freep)
    105a:	00001797          	auipc	a5,0x1
    105e:	fe678793          	addi	a5,a5,-26 # 2040 <freep>
    1062:	639c                	ld	a5,0(a5)
    1064:	fe843703          	ld	a4,-24(s0)
    1068:	02f71063          	bne	a4,a5,1088 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
    106c:	fdc42783          	lw	a5,-36(s0)
    1070:	853e                	mv	a0,a5
    1072:	00000097          	auipc	ra,0x0
    1076:	e7a080e7          	jalr	-390(ra) # eec <morecore>
    107a:	fea43423          	sd	a0,-24(s0)
    107e:	fe843783          	ld	a5,-24(s0)
    1082:	e399                	bnez	a5,1088 <malloc+0x11e>
        return 0;
    1084:	4781                	li	a5,0
    1086:	a819                	j	109c <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1088:	fe843783          	ld	a5,-24(s0)
    108c:	fef43023          	sd	a5,-32(s0)
    1090:	fe843783          	ld	a5,-24(s0)
    1094:	639c                	ld	a5,0(a5)
    1096:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
    109a:	b799                	j	fe0 <malloc+0x76>
  }
}
    109c:	853e                	mv	a0,a5
    109e:	70e2                	ld	ra,56(sp)
    10a0:	7442                	ld	s0,48(sp)
    10a2:	6121                	addi	sp,sp,64
    10a4:	8082                	ret
