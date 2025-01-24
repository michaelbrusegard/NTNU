
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	7139                	addi	sp,sp,-64
       2:	fc06                	sd	ra,56(sp)
       4:	f822                	sd	s0,48(sp)
       6:	0080                	addi	s0,sp,64
       8:	fca43423          	sd	a0,-56(s0)
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       c:	fc843783          	ld	a5,-56(s0)
      10:	6394                	ld	a3,0(a5)
      12:	0016d713          	srli	a4,a3,0x1
      16:	00002797          	auipc	a5,0x2
      1a:	f9a78793          	addi	a5,a5,-102 # 1fb0 <malloc+0x440>
      1e:	639c                	ld	a5,0(a5)
      20:	02f737b3          	mulhu	a5,a4,a5
      24:	01d7d713          	srli	a4,a5,0x1d
      28:	87ba                	mv	a5,a4
      2a:	07fa                	slli	a5,a5,0x1e
      2c:	8f99                	sub	a5,a5,a4
      2e:	0786                	slli	a5,a5,0x1
      30:	40f68733          	sub	a4,a3,a5
      34:	00170793          	addi	a5,a4,1
      38:	fef43423          	sd	a5,-24(s0)
    hi = x / 127773;
      3c:	fe843783          	ld	a5,-24(s0)
      40:	00002717          	auipc	a4,0x2
      44:	f7870713          	addi	a4,a4,-136 # 1fb8 <malloc+0x448>
      48:	6318                	ld	a4,0(a4)
      4a:	02e79733          	mulh	a4,a5,a4
      4e:	873d                	srai	a4,a4,0xf
      50:	97fd                	srai	a5,a5,0x3f
      52:	40f707b3          	sub	a5,a4,a5
      56:	fef43023          	sd	a5,-32(s0)
    lo = x % 127773;
      5a:	fe843783          	ld	a5,-24(s0)
      5e:	00002717          	auipc	a4,0x2
      62:	f5a70713          	addi	a4,a4,-166 # 1fb8 <malloc+0x448>
      66:	6318                	ld	a4,0(a4)
      68:	02e79733          	mulh	a4,a5,a4
      6c:	40f75693          	srai	a3,a4,0xf
      70:	43f7d713          	srai	a4,a5,0x3f
      74:	8e99                	sub	a3,a3,a4
      76:	677d                	lui	a4,0x1f
      78:	31d70713          	addi	a4,a4,797 # 1f31d <freep+0x1cef5>
      7c:	02e68733          	mul	a4,a3,a4
      80:	8f99                	sub	a5,a5,a4
      82:	fcf43c23          	sd	a5,-40(s0)
    x = 16807 * lo - 2836 * hi;
      86:	fd843703          	ld	a4,-40(s0)
      8a:	6791                	lui	a5,0x4
      8c:	1a778793          	addi	a5,a5,423 # 41a7 <freep+0x1d7f>
      90:	02f70733          	mul	a4,a4,a5
      94:	fe043683          	ld	a3,-32(s0)
      98:	77fd                	lui	a5,0xfffff
      9a:	4ec78793          	addi	a5,a5,1260 # fffffffffffff4ec <freep+0xffffffffffffd0c4>
      9e:	02f687b3          	mul	a5,a3,a5
      a2:	97ba                	add	a5,a5,a4
      a4:	fef43423          	sd	a5,-24(s0)
    if (x < 0)
      a8:	fe843783          	ld	a5,-24(s0)
      ac:	0007db63          	bgez	a5,c2 <do_rand+0xc2>
        x += 0x7fffffff;
      b0:	fe843703          	ld	a4,-24(s0)
      b4:	800007b7          	lui	a5,0x80000
      b8:	fff7c793          	not	a5,a5
      bc:	97ba                	add	a5,a5,a4
      be:	fef43423          	sd	a5,-24(s0)
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      c2:	fe843783          	ld	a5,-24(s0)
      c6:	17fd                	addi	a5,a5,-1 # ffffffff7fffffff <freep+0xffffffff7fffdbd7>
      c8:	fef43423          	sd	a5,-24(s0)
    *ctx = x;
      cc:	fe843703          	ld	a4,-24(s0)
      d0:	fc843783          	ld	a5,-56(s0)
      d4:	e398                	sd	a4,0(a5)
    return (x);
      d6:	fe843783          	ld	a5,-24(s0)
      da:	2781                	sext.w	a5,a5
}
      dc:	853e                	mv	a0,a5
      de:	70e2                	ld	ra,56(sp)
      e0:	7442                	ld	s0,48(sp)
      e2:	6121                	addi	sp,sp,64
      e4:	8082                	ret

00000000000000e6 <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      e6:	1141                	addi	sp,sp,-16
      e8:	e406                	sd	ra,8(sp)
      ea:	e022                	sd	s0,0(sp)
      ec:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
      ee:	00002517          	auipc	a0,0x2
      f2:	f1250513          	addi	a0,a0,-238 # 2000 <rand_next>
      f6:	00000097          	auipc	ra,0x0
      fa:	f0a080e7          	jalr	-246(ra) # 0 <do_rand>
      fe:	87aa                	mv	a5,a0
}
     100:	853e                	mv	a0,a5
     102:	60a2                	ld	ra,8(sp)
     104:	6402                	ld	s0,0(sp)
     106:	0141                	addi	sp,sp,16
     108:	8082                	ret

000000000000010a <go>:

void
go(int which_child)
{
     10a:	7155                	addi	sp,sp,-208
     10c:	e586                	sd	ra,200(sp)
     10e:	e1a2                	sd	s0,192(sp)
     110:	0980                	addi	s0,sp,208
     112:	87aa                	mv	a5,a0
     114:	f2f42e23          	sw	a5,-196(s0)
  int fd = -1;
     118:	57fd                	li	a5,-1
     11a:	fef42623          	sw	a5,-20(s0)
  static char buf[999];
  char *break0 = sbrk(0);
     11e:	4501                	li	a0,0
     120:	00001097          	auipc	ra,0x1
     124:	3b8080e7          	jalr	952(ra) # 14d8 <sbrk>
     128:	fca43c23          	sd	a0,-40(s0)
  uint64 iters = 0;
     12c:	fe043023          	sd	zero,-32(s0)

  mkdir("grindir");
     130:	00002517          	auipc	a0,0x2
     134:	b8050513          	addi	a0,a0,-1152 # 1cb0 <malloc+0x140>
     138:	00001097          	auipc	ra,0x1
     13c:	380080e7          	jalr	896(ra) # 14b8 <mkdir>
  if(chdir("grindir") != 0){
     140:	00002517          	auipc	a0,0x2
     144:	b7050513          	addi	a0,a0,-1168 # 1cb0 <malloc+0x140>
     148:	00001097          	auipc	ra,0x1
     14c:	378080e7          	jalr	888(ra) # 14c0 <chdir>
     150:	87aa                	mv	a5,a0
     152:	cf91                	beqz	a5,16e <go+0x64>
    printf("grind: chdir grindir failed\n");
     154:	00002517          	auipc	a0,0x2
     158:	b6450513          	addi	a0,a0,-1180 # 1cb8 <malloc+0x148>
     15c:	00002097          	auipc	ra,0x2
     160:	820080e7          	jalr	-2016(ra) # 197c <printf>
    exit(1);
     164:	4505                	li	a0,1
     166:	00001097          	auipc	ra,0x1
     16a:	2ea080e7          	jalr	746(ra) # 1450 <exit>
  }
  chdir("/");
     16e:	00002517          	auipc	a0,0x2
     172:	b6a50513          	addi	a0,a0,-1174 # 1cd8 <malloc+0x168>
     176:	00001097          	auipc	ra,0x1
     17a:	34a080e7          	jalr	842(ra) # 14c0 <chdir>
  
  while(1){
    iters++;
     17e:	fe043783          	ld	a5,-32(s0)
     182:	0785                	addi	a5,a5,1
     184:	fef43023          	sd	a5,-32(s0)
    if((iters % 500) == 0)
     188:	fe043703          	ld	a4,-32(s0)
     18c:	00275693          	srli	a3,a4,0x2
     190:	00002797          	auipc	a5,0x2
     194:	e3078793          	addi	a5,a5,-464 # 1fc0 <malloc+0x450>
     198:	639c                	ld	a5,0(a5)
     19a:	02f6b7b3          	mulhu	a5,a3,a5
     19e:	8391                	srli	a5,a5,0x4
     1a0:	1f400693          	li	a3,500
     1a4:	02d787b3          	mul	a5,a5,a3
     1a8:	40f707b3          	sub	a5,a4,a5
     1ac:	e78d                	bnez	a5,1d6 <go+0xcc>
      write(1, which_child?"B":"A", 1);
     1ae:	f3c42783          	lw	a5,-196(s0)
     1b2:	2781                	sext.w	a5,a5
     1b4:	c791                	beqz	a5,1c0 <go+0xb6>
     1b6:	00002797          	auipc	a5,0x2
     1ba:	b2a78793          	addi	a5,a5,-1238 # 1ce0 <malloc+0x170>
     1be:	a029                	j	1c8 <go+0xbe>
     1c0:	00002797          	auipc	a5,0x2
     1c4:	b2878793          	addi	a5,a5,-1240 # 1ce8 <malloc+0x178>
     1c8:	4605                	li	a2,1
     1ca:	85be                	mv	a1,a5
     1cc:	4505                	li	a0,1
     1ce:	00001097          	auipc	ra,0x1
     1d2:	2a2080e7          	jalr	674(ra) # 1470 <write>
    int what = rand() % 23;
     1d6:	00000097          	auipc	ra,0x0
     1da:	f10080e7          	jalr	-240(ra) # e6 <rand>
     1de:	87aa                	mv	a5,a0
     1e0:	0007869b          	sext.w	a3,a5
     1e4:	b2164737          	lui	a4,0xb2164
     1e8:	2c970713          	addi	a4,a4,713 # ffffffffb21642c9 <freep+0xffffffffb2161ea1>
     1ec:	02e68733          	mul	a4,a3,a4
     1f0:	9301                	srli	a4,a4,0x20
     1f2:	9f3d                	addw	a4,a4,a5
     1f4:	4047571b          	sraiw	a4,a4,0x4
     1f8:	86ba                	mv	a3,a4
     1fa:	41f7d71b          	sraiw	a4,a5,0x1f
     1fe:	40e6873b          	subw	a4,a3,a4
     202:	86ba                	mv	a3,a4
     204:	0016969b          	slliw	a3,a3,0x1
     208:	9eb9                	addw	a3,a3,a4
     20a:	0036969b          	slliw	a3,a3,0x3
     20e:	40e6873b          	subw	a4,a3,a4
     212:	9f99                	subw	a5,a5,a4
     214:	fcf42a23          	sw	a5,-44(s0)
    if(what == 1){
     218:	fd442783          	lw	a5,-44(s0)
     21c:	0007871b          	sext.w	a4,a5
     220:	4785                	li	a5,1
     222:	02f71363          	bne	a4,a5,248 <go+0x13e>
      close(open("grindir/../a", O_CREATE|O_RDWR));
     226:	20200593          	li	a1,514
     22a:	00002517          	auipc	a0,0x2
     22e:	ac650513          	addi	a0,a0,-1338 # 1cf0 <malloc+0x180>
     232:	00001097          	auipc	ra,0x1
     236:	25e080e7          	jalr	606(ra) # 1490 <open>
     23a:	87aa                	mv	a5,a0
     23c:	853e                	mv	a0,a5
     23e:	00001097          	auipc	ra,0x1
     242:	23a080e7          	jalr	570(ra) # 1478 <close>
     246:	bf25                	j	17e <go+0x74>
    } else if(what == 2){
     248:	fd442783          	lw	a5,-44(s0)
     24c:	0007871b          	sext.w	a4,a5
     250:	4789                	li	a5,2
     252:	02f71363          	bne	a4,a5,278 <go+0x16e>
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     256:	20200593          	li	a1,514
     25a:	00002517          	auipc	a0,0x2
     25e:	aa650513          	addi	a0,a0,-1370 # 1d00 <malloc+0x190>
     262:	00001097          	auipc	ra,0x1
     266:	22e080e7          	jalr	558(ra) # 1490 <open>
     26a:	87aa                	mv	a5,a0
     26c:	853e                	mv	a0,a5
     26e:	00001097          	auipc	ra,0x1
     272:	20a080e7          	jalr	522(ra) # 1478 <close>
     276:	b721                	j	17e <go+0x74>
    } else if(what == 3){
     278:	fd442783          	lw	a5,-44(s0)
     27c:	0007871b          	sext.w	a4,a5
     280:	478d                	li	a5,3
     282:	00f71b63          	bne	a4,a5,298 <go+0x18e>
      unlink("grindir/../a");
     286:	00002517          	auipc	a0,0x2
     28a:	a6a50513          	addi	a0,a0,-1430 # 1cf0 <malloc+0x180>
     28e:	00001097          	auipc	ra,0x1
     292:	212080e7          	jalr	530(ra) # 14a0 <unlink>
     296:	b5e5                	j	17e <go+0x74>
    } else if(what == 4){
     298:	fd442783          	lw	a5,-44(s0)
     29c:	0007871b          	sext.w	a4,a5
     2a0:	4791                	li	a5,4
     2a2:	04f71a63          	bne	a4,a5,2f6 <go+0x1ec>
      if(chdir("grindir") != 0){
     2a6:	00002517          	auipc	a0,0x2
     2aa:	a0a50513          	addi	a0,a0,-1526 # 1cb0 <malloc+0x140>
     2ae:	00001097          	auipc	ra,0x1
     2b2:	212080e7          	jalr	530(ra) # 14c0 <chdir>
     2b6:	87aa                	mv	a5,a0
     2b8:	cf91                	beqz	a5,2d4 <go+0x1ca>
        printf("grind: chdir grindir failed\n");
     2ba:	00002517          	auipc	a0,0x2
     2be:	9fe50513          	addi	a0,a0,-1538 # 1cb8 <malloc+0x148>
     2c2:	00001097          	auipc	ra,0x1
     2c6:	6ba080e7          	jalr	1722(ra) # 197c <printf>
        exit(1);
     2ca:	4505                	li	a0,1
     2cc:	00001097          	auipc	ra,0x1
     2d0:	184080e7          	jalr	388(ra) # 1450 <exit>
      }
      unlink("../b");
     2d4:	00002517          	auipc	a0,0x2
     2d8:	a4450513          	addi	a0,a0,-1468 # 1d18 <malloc+0x1a8>
     2dc:	00001097          	auipc	ra,0x1
     2e0:	1c4080e7          	jalr	452(ra) # 14a0 <unlink>
      chdir("/");
     2e4:	00002517          	auipc	a0,0x2
     2e8:	9f450513          	addi	a0,a0,-1548 # 1cd8 <malloc+0x168>
     2ec:	00001097          	auipc	ra,0x1
     2f0:	1d4080e7          	jalr	468(ra) # 14c0 <chdir>
     2f4:	b569                	j	17e <go+0x74>
    } else if(what == 5){
     2f6:	fd442783          	lw	a5,-44(s0)
     2fa:	0007871b          	sext.w	a4,a5
     2fe:	4795                	li	a5,5
     300:	02f71763          	bne	a4,a5,32e <go+0x224>
      close(fd);
     304:	fec42783          	lw	a5,-20(s0)
     308:	853e                	mv	a0,a5
     30a:	00001097          	auipc	ra,0x1
     30e:	16e080e7          	jalr	366(ra) # 1478 <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     312:	20200593          	li	a1,514
     316:	00002517          	auipc	a0,0x2
     31a:	a0a50513          	addi	a0,a0,-1526 # 1d20 <malloc+0x1b0>
     31e:	00001097          	auipc	ra,0x1
     322:	172080e7          	jalr	370(ra) # 1490 <open>
     326:	87aa                	mv	a5,a0
     328:	fef42623          	sw	a5,-20(s0)
     32c:	bd89                	j	17e <go+0x74>
    } else if(what == 6){
     32e:	fd442783          	lw	a5,-44(s0)
     332:	0007871b          	sext.w	a4,a5
     336:	4799                	li	a5,6
     338:	02f71763          	bne	a4,a5,366 <go+0x25c>
      close(fd);
     33c:	fec42783          	lw	a5,-20(s0)
     340:	853e                	mv	a0,a5
     342:	00001097          	auipc	ra,0x1
     346:	136080e7          	jalr	310(ra) # 1478 <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     34a:	20200593          	li	a1,514
     34e:	00002517          	auipc	a0,0x2
     352:	9e250513          	addi	a0,a0,-1566 # 1d30 <malloc+0x1c0>
     356:	00001097          	auipc	ra,0x1
     35a:	13a080e7          	jalr	314(ra) # 1490 <open>
     35e:	87aa                	mv	a5,a0
     360:	fef42623          	sw	a5,-20(s0)
     364:	bd29                	j	17e <go+0x74>
    } else if(what == 7){
     366:	fd442783          	lw	a5,-44(s0)
     36a:	0007871b          	sext.w	a4,a5
     36e:	479d                	li	a5,7
     370:	02f71063          	bne	a4,a5,390 <go+0x286>
      write(fd, buf, sizeof(buf));
     374:	fec42783          	lw	a5,-20(s0)
     378:	3e700613          	li	a2,999
     37c:	00002597          	auipc	a1,0x2
     380:	cb458593          	addi	a1,a1,-844 # 2030 <buf.0>
     384:	853e                	mv	a0,a5
     386:	00001097          	auipc	ra,0x1
     38a:	0ea080e7          	jalr	234(ra) # 1470 <write>
     38e:	bbc5                	j	17e <go+0x74>
    } else if(what == 8){
     390:	fd442783          	lw	a5,-44(s0)
     394:	0007871b          	sext.w	a4,a5
     398:	47a1                	li	a5,8
     39a:	02f71063          	bne	a4,a5,3ba <go+0x2b0>
      read(fd, buf, sizeof(buf));
     39e:	fec42783          	lw	a5,-20(s0)
     3a2:	3e700613          	li	a2,999
     3a6:	00002597          	auipc	a1,0x2
     3aa:	c8a58593          	addi	a1,a1,-886 # 2030 <buf.0>
     3ae:	853e                	mv	a0,a5
     3b0:	00001097          	auipc	ra,0x1
     3b4:	0b8080e7          	jalr	184(ra) # 1468 <read>
     3b8:	b3d9                	j	17e <go+0x74>
    } else if(what == 9){
     3ba:	fd442783          	lw	a5,-44(s0)
     3be:	0007871b          	sext.w	a4,a5
     3c2:	47a5                	li	a5,9
     3c4:	04f71363          	bne	a4,a5,40a <go+0x300>
      mkdir("grindir/../a");
     3c8:	00002517          	auipc	a0,0x2
     3cc:	92850513          	addi	a0,a0,-1752 # 1cf0 <malloc+0x180>
     3d0:	00001097          	auipc	ra,0x1
     3d4:	0e8080e7          	jalr	232(ra) # 14b8 <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     3d8:	20200593          	li	a1,514
     3dc:	00002517          	auipc	a0,0x2
     3e0:	96c50513          	addi	a0,a0,-1684 # 1d48 <malloc+0x1d8>
     3e4:	00001097          	auipc	ra,0x1
     3e8:	0ac080e7          	jalr	172(ra) # 1490 <open>
     3ec:	87aa                	mv	a5,a0
     3ee:	853e                	mv	a0,a5
     3f0:	00001097          	auipc	ra,0x1
     3f4:	088080e7          	jalr	136(ra) # 1478 <close>
      unlink("a/a");
     3f8:	00002517          	auipc	a0,0x2
     3fc:	96050513          	addi	a0,a0,-1696 # 1d58 <malloc+0x1e8>
     400:	00001097          	auipc	ra,0x1
     404:	0a0080e7          	jalr	160(ra) # 14a0 <unlink>
     408:	bb9d                	j	17e <go+0x74>
    } else if(what == 10){
     40a:	fd442783          	lw	a5,-44(s0)
     40e:	0007871b          	sext.w	a4,a5
     412:	47a9                	li	a5,10
     414:	04f71363          	bne	a4,a5,45a <go+0x350>
      mkdir("/../b");
     418:	00002517          	auipc	a0,0x2
     41c:	94850513          	addi	a0,a0,-1720 # 1d60 <malloc+0x1f0>
     420:	00001097          	auipc	ra,0x1
     424:	098080e7          	jalr	152(ra) # 14b8 <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     428:	20200593          	li	a1,514
     42c:	00002517          	auipc	a0,0x2
     430:	93c50513          	addi	a0,a0,-1732 # 1d68 <malloc+0x1f8>
     434:	00001097          	auipc	ra,0x1
     438:	05c080e7          	jalr	92(ra) # 1490 <open>
     43c:	87aa                	mv	a5,a0
     43e:	853e                	mv	a0,a5
     440:	00001097          	auipc	ra,0x1
     444:	038080e7          	jalr	56(ra) # 1478 <close>
      unlink("b/b");
     448:	00002517          	auipc	a0,0x2
     44c:	93050513          	addi	a0,a0,-1744 # 1d78 <malloc+0x208>
     450:	00001097          	auipc	ra,0x1
     454:	050080e7          	jalr	80(ra) # 14a0 <unlink>
     458:	b31d                	j	17e <go+0x74>
    } else if(what == 11){
     45a:	fd442783          	lw	a5,-44(s0)
     45e:	0007871b          	sext.w	a4,a5
     462:	47ad                	li	a5,11
     464:	02f71763          	bne	a4,a5,492 <go+0x388>
      unlink("b");
     468:	00002517          	auipc	a0,0x2
     46c:	91850513          	addi	a0,a0,-1768 # 1d80 <malloc+0x210>
     470:	00001097          	auipc	ra,0x1
     474:	030080e7          	jalr	48(ra) # 14a0 <unlink>
      link("../grindir/./../a", "../b");
     478:	00002597          	auipc	a1,0x2
     47c:	8a058593          	addi	a1,a1,-1888 # 1d18 <malloc+0x1a8>
     480:	00002517          	auipc	a0,0x2
     484:	90850513          	addi	a0,a0,-1784 # 1d88 <malloc+0x218>
     488:	00001097          	auipc	ra,0x1
     48c:	028080e7          	jalr	40(ra) # 14b0 <link>
     490:	b1fd                	j	17e <go+0x74>
    } else if(what == 12){
     492:	fd442783          	lw	a5,-44(s0)
     496:	0007871b          	sext.w	a4,a5
     49a:	47b1                	li	a5,12
     49c:	02f71763          	bne	a4,a5,4ca <go+0x3c0>
      unlink("../grindir/../a");
     4a0:	00002517          	auipc	a0,0x2
     4a4:	90050513          	addi	a0,a0,-1792 # 1da0 <malloc+0x230>
     4a8:	00001097          	auipc	ra,0x1
     4ac:	ff8080e7          	jalr	-8(ra) # 14a0 <unlink>
      link(".././b", "/grindir/../a");
     4b0:	00002597          	auipc	a1,0x2
     4b4:	87058593          	addi	a1,a1,-1936 # 1d20 <malloc+0x1b0>
     4b8:	00002517          	auipc	a0,0x2
     4bc:	8f850513          	addi	a0,a0,-1800 # 1db0 <malloc+0x240>
     4c0:	00001097          	auipc	ra,0x1
     4c4:	ff0080e7          	jalr	-16(ra) # 14b0 <link>
     4c8:	b95d                	j	17e <go+0x74>
    } else if(what == 13){
     4ca:	fd442783          	lw	a5,-44(s0)
     4ce:	0007871b          	sext.w	a4,a5
     4d2:	47b5                	li	a5,13
     4d4:	04f71a63          	bne	a4,a5,528 <go+0x41e>
      int pid = fork();
     4d8:	00001097          	auipc	ra,0x1
     4dc:	f70080e7          	jalr	-144(ra) # 1448 <fork>
     4e0:	87aa                	mv	a5,a0
     4e2:	faf42823          	sw	a5,-80(s0)
      if(pid == 0){
     4e6:	fb042783          	lw	a5,-80(s0)
     4ea:	2781                	sext.w	a5,a5
     4ec:	e791                	bnez	a5,4f8 <go+0x3ee>
        exit(0);
     4ee:	4501                	li	a0,0
     4f0:	00001097          	auipc	ra,0x1
     4f4:	f60080e7          	jalr	-160(ra) # 1450 <exit>
      } else if(pid < 0){
     4f8:	fb042783          	lw	a5,-80(s0)
     4fc:	2781                	sext.w	a5,a5
     4fe:	0007df63          	bgez	a5,51c <go+0x412>
        printf("grind: fork failed\n");
     502:	00002517          	auipc	a0,0x2
     506:	8b650513          	addi	a0,a0,-1866 # 1db8 <malloc+0x248>
     50a:	00001097          	auipc	ra,0x1
     50e:	472080e7          	jalr	1138(ra) # 197c <printf>
        exit(1);
     512:	4505                	li	a0,1
     514:	00001097          	auipc	ra,0x1
     518:	f3c080e7          	jalr	-196(ra) # 1450 <exit>
      }
      wait(0);
     51c:	4501                	li	a0,0
     51e:	00001097          	auipc	ra,0x1
     522:	f3a080e7          	jalr	-198(ra) # 1458 <wait>
     526:	b9a1                	j	17e <go+0x74>
    } else if(what == 14){
     528:	fd442783          	lw	a5,-44(s0)
     52c:	0007871b          	sext.w	a4,a5
     530:	47b9                	li	a5,14
     532:	06f71263          	bne	a4,a5,596 <go+0x48c>
      int pid = fork();
     536:	00001097          	auipc	ra,0x1
     53a:	f12080e7          	jalr	-238(ra) # 1448 <fork>
     53e:	87aa                	mv	a5,a0
     540:	faf42a23          	sw	a5,-76(s0)
      if(pid == 0){
     544:	fb442783          	lw	a5,-76(s0)
     548:	2781                	sext.w	a5,a5
     54a:	ef91                	bnez	a5,566 <go+0x45c>
        fork();
     54c:	00001097          	auipc	ra,0x1
     550:	efc080e7          	jalr	-260(ra) # 1448 <fork>
        fork();
     554:	00001097          	auipc	ra,0x1
     558:	ef4080e7          	jalr	-268(ra) # 1448 <fork>
        exit(0);
     55c:	4501                	li	a0,0
     55e:	00001097          	auipc	ra,0x1
     562:	ef2080e7          	jalr	-270(ra) # 1450 <exit>
      } else if(pid < 0){
     566:	fb442783          	lw	a5,-76(s0)
     56a:	2781                	sext.w	a5,a5
     56c:	0007df63          	bgez	a5,58a <go+0x480>
        printf("grind: fork failed\n");
     570:	00002517          	auipc	a0,0x2
     574:	84850513          	addi	a0,a0,-1976 # 1db8 <malloc+0x248>
     578:	00001097          	auipc	ra,0x1
     57c:	404080e7          	jalr	1028(ra) # 197c <printf>
        exit(1);
     580:	4505                	li	a0,1
     582:	00001097          	auipc	ra,0x1
     586:	ece080e7          	jalr	-306(ra) # 1450 <exit>
      }
      wait(0);
     58a:	4501                	li	a0,0
     58c:	00001097          	auipc	ra,0x1
     590:	ecc080e7          	jalr	-308(ra) # 1458 <wait>
     594:	b6ed                	j	17e <go+0x74>
    } else if(what == 15){
     596:	fd442783          	lw	a5,-44(s0)
     59a:	0007871b          	sext.w	a4,a5
     59e:	47bd                	li	a5,15
     5a0:	00f71a63          	bne	a4,a5,5b4 <go+0x4aa>
      sbrk(6011);
     5a4:	6785                	lui	a5,0x1
     5a6:	77b78513          	addi	a0,a5,1915 # 177b <vprintf+0xbd>
     5aa:	00001097          	auipc	ra,0x1
     5ae:	f2e080e7          	jalr	-210(ra) # 14d8 <sbrk>
     5b2:	b6f1                	j	17e <go+0x74>
    } else if(what == 16){
     5b4:	fd442783          	lw	a5,-44(s0)
     5b8:	0007871b          	sext.w	a4,a5
     5bc:	47c1                	li	a5,16
     5be:	02f71c63          	bne	a4,a5,5f6 <go+0x4ec>
      if(sbrk(0) > break0)
     5c2:	4501                	li	a0,0
     5c4:	00001097          	auipc	ra,0x1
     5c8:	f14080e7          	jalr	-236(ra) # 14d8 <sbrk>
     5cc:	872a                	mv	a4,a0
     5ce:	fd843783          	ld	a5,-40(s0)
     5d2:	bae7f6e3          	bgeu	a5,a4,17e <go+0x74>
        sbrk(-(sbrk(0) - break0));
     5d6:	4501                	li	a0,0
     5d8:	00001097          	auipc	ra,0x1
     5dc:	f00080e7          	jalr	-256(ra) # 14d8 <sbrk>
     5e0:	872a                	mv	a4,a0
     5e2:	fd843783          	ld	a5,-40(s0)
     5e6:	8f99                	sub	a5,a5,a4
     5e8:	2781                	sext.w	a5,a5
     5ea:	853e                	mv	a0,a5
     5ec:	00001097          	auipc	ra,0x1
     5f0:	eec080e7          	jalr	-276(ra) # 14d8 <sbrk>
     5f4:	b669                	j	17e <go+0x74>
    } else if(what == 17){
     5f6:	fd442783          	lw	a5,-44(s0)
     5fa:	0007871b          	sext.w	a4,a5
     5fe:	47c5                	li	a5,17
     600:	0af71863          	bne	a4,a5,6b0 <go+0x5a6>
      int pid = fork();
     604:	00001097          	auipc	ra,0x1
     608:	e44080e7          	jalr	-444(ra) # 1448 <fork>
     60c:	87aa                	mv	a5,a0
     60e:	faf42c23          	sw	a5,-72(s0)
      if(pid == 0){
     612:	fb842783          	lw	a5,-72(s0)
     616:	2781                	sext.w	a5,a5
     618:	e795                	bnez	a5,644 <go+0x53a>
        close(open("a", O_CREATE|O_RDWR));
     61a:	20200593          	li	a1,514
     61e:	00001517          	auipc	a0,0x1
     622:	7b250513          	addi	a0,a0,1970 # 1dd0 <malloc+0x260>
     626:	00001097          	auipc	ra,0x1
     62a:	e6a080e7          	jalr	-406(ra) # 1490 <open>
     62e:	87aa                	mv	a5,a0
     630:	853e                	mv	a0,a5
     632:	00001097          	auipc	ra,0x1
     636:	e46080e7          	jalr	-442(ra) # 1478 <close>
        exit(0);
     63a:	4501                	li	a0,0
     63c:	00001097          	auipc	ra,0x1
     640:	e14080e7          	jalr	-492(ra) # 1450 <exit>
      } else if(pid < 0){
     644:	fb842783          	lw	a5,-72(s0)
     648:	2781                	sext.w	a5,a5
     64a:	0007df63          	bgez	a5,668 <go+0x55e>
        printf("grind: fork failed\n");
     64e:	00001517          	auipc	a0,0x1
     652:	76a50513          	addi	a0,a0,1898 # 1db8 <malloc+0x248>
     656:	00001097          	auipc	ra,0x1
     65a:	326080e7          	jalr	806(ra) # 197c <printf>
        exit(1);
     65e:	4505                	li	a0,1
     660:	00001097          	auipc	ra,0x1
     664:	df0080e7          	jalr	-528(ra) # 1450 <exit>
      }
      if(chdir("../grindir/..") != 0){
     668:	00001517          	auipc	a0,0x1
     66c:	77050513          	addi	a0,a0,1904 # 1dd8 <malloc+0x268>
     670:	00001097          	auipc	ra,0x1
     674:	e50080e7          	jalr	-432(ra) # 14c0 <chdir>
     678:	87aa                	mv	a5,a0
     67a:	cf91                	beqz	a5,696 <go+0x58c>
        printf("grind: chdir failed\n");
     67c:	00001517          	auipc	a0,0x1
     680:	76c50513          	addi	a0,a0,1900 # 1de8 <malloc+0x278>
     684:	00001097          	auipc	ra,0x1
     688:	2f8080e7          	jalr	760(ra) # 197c <printf>
        exit(1);
     68c:	4505                	li	a0,1
     68e:	00001097          	auipc	ra,0x1
     692:	dc2080e7          	jalr	-574(ra) # 1450 <exit>
      }
      kill(pid);
     696:	fb842783          	lw	a5,-72(s0)
     69a:	853e                	mv	a0,a5
     69c:	00001097          	auipc	ra,0x1
     6a0:	de4080e7          	jalr	-540(ra) # 1480 <kill>
      wait(0);
     6a4:	4501                	li	a0,0
     6a6:	00001097          	auipc	ra,0x1
     6aa:	db2080e7          	jalr	-590(ra) # 1458 <wait>
     6ae:	bcc1                	j	17e <go+0x74>
    } else if(what == 18){
     6b0:	fd442783          	lw	a5,-44(s0)
     6b4:	0007871b          	sext.w	a4,a5
     6b8:	47c9                	li	a5,18
     6ba:	06f71463          	bne	a4,a5,722 <go+0x618>
      int pid = fork();
     6be:	00001097          	auipc	ra,0x1
     6c2:	d8a080e7          	jalr	-630(ra) # 1448 <fork>
     6c6:	87aa                	mv	a5,a0
     6c8:	faf42e23          	sw	a5,-68(s0)
      if(pid == 0){
     6cc:	fbc42783          	lw	a5,-68(s0)
     6d0:	2781                	sext.w	a5,a5
     6d2:	e385                	bnez	a5,6f2 <go+0x5e8>
        kill(getpid());
     6d4:	00001097          	auipc	ra,0x1
     6d8:	dfc080e7          	jalr	-516(ra) # 14d0 <getpid>
     6dc:	87aa                	mv	a5,a0
     6de:	853e                	mv	a0,a5
     6e0:	00001097          	auipc	ra,0x1
     6e4:	da0080e7          	jalr	-608(ra) # 1480 <kill>
        exit(0);
     6e8:	4501                	li	a0,0
     6ea:	00001097          	auipc	ra,0x1
     6ee:	d66080e7          	jalr	-666(ra) # 1450 <exit>
      } else if(pid < 0){
     6f2:	fbc42783          	lw	a5,-68(s0)
     6f6:	2781                	sext.w	a5,a5
     6f8:	0007df63          	bgez	a5,716 <go+0x60c>
        printf("grind: fork failed\n");
     6fc:	00001517          	auipc	a0,0x1
     700:	6bc50513          	addi	a0,a0,1724 # 1db8 <malloc+0x248>
     704:	00001097          	auipc	ra,0x1
     708:	278080e7          	jalr	632(ra) # 197c <printf>
        exit(1);
     70c:	4505                	li	a0,1
     70e:	00001097          	auipc	ra,0x1
     712:	d42080e7          	jalr	-702(ra) # 1450 <exit>
      }
      wait(0);
     716:	4501                	li	a0,0
     718:	00001097          	auipc	ra,0x1
     71c:	d40080e7          	jalr	-704(ra) # 1458 <wait>
     720:	bcb9                	j	17e <go+0x74>
    } else if(what == 19){
     722:	fd442783          	lw	a5,-44(s0)
     726:	0007871b          	sext.w	a4,a5
     72a:	47cd                	li	a5,19
     72c:	10f71863          	bne	a4,a5,83c <go+0x732>
      int fds[2];
      if(pipe(fds) < 0){
     730:	fa840793          	addi	a5,s0,-88
     734:	853e                	mv	a0,a5
     736:	00001097          	auipc	ra,0x1
     73a:	d2a080e7          	jalr	-726(ra) # 1460 <pipe>
     73e:	87aa                	mv	a5,a0
     740:	0007df63          	bgez	a5,75e <go+0x654>
        printf("grind: pipe failed\n");
     744:	00001517          	auipc	a0,0x1
     748:	6bc50513          	addi	a0,a0,1724 # 1e00 <malloc+0x290>
     74c:	00001097          	auipc	ra,0x1
     750:	230080e7          	jalr	560(ra) # 197c <printf>
        exit(1);
     754:	4505                	li	a0,1
     756:	00001097          	auipc	ra,0x1
     75a:	cfa080e7          	jalr	-774(ra) # 1450 <exit>
      }
      int pid = fork();
     75e:	00001097          	auipc	ra,0x1
     762:	cea080e7          	jalr	-790(ra) # 1448 <fork>
     766:	87aa                	mv	a5,a0
     768:	fcf42023          	sw	a5,-64(s0)
      if(pid == 0){
     76c:	fc042783          	lw	a5,-64(s0)
     770:	2781                	sext.w	a5,a5
     772:	efbd                	bnez	a5,7f0 <go+0x6e6>
        fork();
     774:	00001097          	auipc	ra,0x1
     778:	cd4080e7          	jalr	-812(ra) # 1448 <fork>
        fork();
     77c:	00001097          	auipc	ra,0x1
     780:	ccc080e7          	jalr	-820(ra) # 1448 <fork>
        if(write(fds[1], "x", 1) != 1)
     784:	fac42783          	lw	a5,-84(s0)
     788:	4605                	li	a2,1
     78a:	00001597          	auipc	a1,0x1
     78e:	68e58593          	addi	a1,a1,1678 # 1e18 <malloc+0x2a8>
     792:	853e                	mv	a0,a5
     794:	00001097          	auipc	ra,0x1
     798:	cdc080e7          	jalr	-804(ra) # 1470 <write>
     79c:	87aa                	mv	a5,a0
     79e:	873e                	mv	a4,a5
     7a0:	4785                	li	a5,1
     7a2:	00f70a63          	beq	a4,a5,7b6 <go+0x6ac>
          printf("grind: pipe write failed\n");
     7a6:	00001517          	auipc	a0,0x1
     7aa:	67a50513          	addi	a0,a0,1658 # 1e20 <malloc+0x2b0>
     7ae:	00001097          	auipc	ra,0x1
     7b2:	1ce080e7          	jalr	462(ra) # 197c <printf>
        char c;
        if(read(fds[0], &c, 1) != 1)
     7b6:	fa842783          	lw	a5,-88(s0)
     7ba:	fa740713          	addi	a4,s0,-89
     7be:	4605                	li	a2,1
     7c0:	85ba                	mv	a1,a4
     7c2:	853e                	mv	a0,a5
     7c4:	00001097          	auipc	ra,0x1
     7c8:	ca4080e7          	jalr	-860(ra) # 1468 <read>
     7cc:	87aa                	mv	a5,a0
     7ce:	873e                	mv	a4,a5
     7d0:	4785                	li	a5,1
     7d2:	00f70a63          	beq	a4,a5,7e6 <go+0x6dc>
          printf("grind: pipe read failed\n");
     7d6:	00001517          	auipc	a0,0x1
     7da:	66a50513          	addi	a0,a0,1642 # 1e40 <malloc+0x2d0>
     7de:	00001097          	auipc	ra,0x1
     7e2:	19e080e7          	jalr	414(ra) # 197c <printf>
        exit(0);
     7e6:	4501                	li	a0,0
     7e8:	00001097          	auipc	ra,0x1
     7ec:	c68080e7          	jalr	-920(ra) # 1450 <exit>
      } else if(pid < 0){
     7f0:	fc042783          	lw	a5,-64(s0)
     7f4:	2781                	sext.w	a5,a5
     7f6:	0007df63          	bgez	a5,814 <go+0x70a>
        printf("grind: fork failed\n");
     7fa:	00001517          	auipc	a0,0x1
     7fe:	5be50513          	addi	a0,a0,1470 # 1db8 <malloc+0x248>
     802:	00001097          	auipc	ra,0x1
     806:	17a080e7          	jalr	378(ra) # 197c <printf>
        exit(1);
     80a:	4505                	li	a0,1
     80c:	00001097          	auipc	ra,0x1
     810:	c44080e7          	jalr	-956(ra) # 1450 <exit>
      }
      close(fds[0]);
     814:	fa842783          	lw	a5,-88(s0)
     818:	853e                	mv	a0,a5
     81a:	00001097          	auipc	ra,0x1
     81e:	c5e080e7          	jalr	-930(ra) # 1478 <close>
      close(fds[1]);
     822:	fac42783          	lw	a5,-84(s0)
     826:	853e                	mv	a0,a5
     828:	00001097          	auipc	ra,0x1
     82c:	c50080e7          	jalr	-944(ra) # 1478 <close>
      wait(0);
     830:	4501                	li	a0,0
     832:	00001097          	auipc	ra,0x1
     836:	c26080e7          	jalr	-986(ra) # 1458 <wait>
     83a:	b291                	j	17e <go+0x74>
    } else if(what == 20){
     83c:	fd442783          	lw	a5,-44(s0)
     840:	0007871b          	sext.w	a4,a5
     844:	47d1                	li	a5,20
     846:	0af71f63          	bne	a4,a5,904 <go+0x7fa>
      int pid = fork();
     84a:	00001097          	auipc	ra,0x1
     84e:	bfe080e7          	jalr	-1026(ra) # 1448 <fork>
     852:	87aa                	mv	a5,a0
     854:	fcf42223          	sw	a5,-60(s0)
      if(pid == 0){
     858:	fc442783          	lw	a5,-60(s0)
     85c:	2781                	sext.w	a5,a5
     85e:	ebbd                	bnez	a5,8d4 <go+0x7ca>
        unlink("a");
     860:	00001517          	auipc	a0,0x1
     864:	57050513          	addi	a0,a0,1392 # 1dd0 <malloc+0x260>
     868:	00001097          	auipc	ra,0x1
     86c:	c38080e7          	jalr	-968(ra) # 14a0 <unlink>
        mkdir("a");
     870:	00001517          	auipc	a0,0x1
     874:	56050513          	addi	a0,a0,1376 # 1dd0 <malloc+0x260>
     878:	00001097          	auipc	ra,0x1
     87c:	c40080e7          	jalr	-960(ra) # 14b8 <mkdir>
        chdir("a");
     880:	00001517          	auipc	a0,0x1
     884:	55050513          	addi	a0,a0,1360 # 1dd0 <malloc+0x260>
     888:	00001097          	auipc	ra,0x1
     88c:	c38080e7          	jalr	-968(ra) # 14c0 <chdir>
        unlink("../a");
     890:	00001517          	auipc	a0,0x1
     894:	5d050513          	addi	a0,a0,1488 # 1e60 <malloc+0x2f0>
     898:	00001097          	auipc	ra,0x1
     89c:	c08080e7          	jalr	-1016(ra) # 14a0 <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     8a0:	20200593          	li	a1,514
     8a4:	00001517          	auipc	a0,0x1
     8a8:	57450513          	addi	a0,a0,1396 # 1e18 <malloc+0x2a8>
     8ac:	00001097          	auipc	ra,0x1
     8b0:	be4080e7          	jalr	-1052(ra) # 1490 <open>
     8b4:	87aa                	mv	a5,a0
     8b6:	fef42623          	sw	a5,-20(s0)
        unlink("x");
     8ba:	00001517          	auipc	a0,0x1
     8be:	55e50513          	addi	a0,a0,1374 # 1e18 <malloc+0x2a8>
     8c2:	00001097          	auipc	ra,0x1
     8c6:	bde080e7          	jalr	-1058(ra) # 14a0 <unlink>
        exit(0);
     8ca:	4501                	li	a0,0
     8cc:	00001097          	auipc	ra,0x1
     8d0:	b84080e7          	jalr	-1148(ra) # 1450 <exit>
      } else if(pid < 0){
     8d4:	fc442783          	lw	a5,-60(s0)
     8d8:	2781                	sext.w	a5,a5
     8da:	0007df63          	bgez	a5,8f8 <go+0x7ee>
        printf("grind: fork failed\n");
     8de:	00001517          	auipc	a0,0x1
     8e2:	4da50513          	addi	a0,a0,1242 # 1db8 <malloc+0x248>
     8e6:	00001097          	auipc	ra,0x1
     8ea:	096080e7          	jalr	150(ra) # 197c <printf>
        exit(1);
     8ee:	4505                	li	a0,1
     8f0:	00001097          	auipc	ra,0x1
     8f4:	b60080e7          	jalr	-1184(ra) # 1450 <exit>
      }
      wait(0);
     8f8:	4501                	li	a0,0
     8fa:	00001097          	auipc	ra,0x1
     8fe:	b5e080e7          	jalr	-1186(ra) # 1458 <wait>
     902:	b8b5                	j	17e <go+0x74>
    } else if(what == 21){
     904:	fd442783          	lw	a5,-44(s0)
     908:	0007871b          	sext.w	a4,a5
     90c:	47d5                	li	a5,21
     90e:	12f71d63          	bne	a4,a5,a48 <go+0x93e>
      unlink("c");
     912:	00001517          	auipc	a0,0x1
     916:	55650513          	addi	a0,a0,1366 # 1e68 <malloc+0x2f8>
     91a:	00001097          	auipc	ra,0x1
     91e:	b86080e7          	jalr	-1146(ra) # 14a0 <unlink>
      // should always succeed. check that there are free i-nodes,
      // file descriptors, blocks.
      int fd1 = open("c", O_CREATE|O_RDWR);
     922:	20200593          	li	a1,514
     926:	00001517          	auipc	a0,0x1
     92a:	54250513          	addi	a0,a0,1346 # 1e68 <malloc+0x2f8>
     92e:	00001097          	auipc	ra,0x1
     932:	b62080e7          	jalr	-1182(ra) # 1490 <open>
     936:	87aa                	mv	a5,a0
     938:	fcf42423          	sw	a5,-56(s0)
      if(fd1 < 0){
     93c:	fc842783          	lw	a5,-56(s0)
     940:	2781                	sext.w	a5,a5
     942:	0007df63          	bgez	a5,960 <go+0x856>
        printf("grind: create c failed\n");
     946:	00001517          	auipc	a0,0x1
     94a:	52a50513          	addi	a0,a0,1322 # 1e70 <malloc+0x300>
     94e:	00001097          	auipc	ra,0x1
     952:	02e080e7          	jalr	46(ra) # 197c <printf>
        exit(1);
     956:	4505                	li	a0,1
     958:	00001097          	auipc	ra,0x1
     95c:	af8080e7          	jalr	-1288(ra) # 1450 <exit>
      }
      if(write(fd1, "x", 1) != 1){
     960:	fc842783          	lw	a5,-56(s0)
     964:	4605                	li	a2,1
     966:	00001597          	auipc	a1,0x1
     96a:	4b258593          	addi	a1,a1,1202 # 1e18 <malloc+0x2a8>
     96e:	853e                	mv	a0,a5
     970:	00001097          	auipc	ra,0x1
     974:	b00080e7          	jalr	-1280(ra) # 1470 <write>
     978:	87aa                	mv	a5,a0
     97a:	873e                	mv	a4,a5
     97c:	4785                	li	a5,1
     97e:	00f70f63          	beq	a4,a5,99c <go+0x892>
        printf("grind: write c failed\n");
     982:	00001517          	auipc	a0,0x1
     986:	50650513          	addi	a0,a0,1286 # 1e88 <malloc+0x318>
     98a:	00001097          	auipc	ra,0x1
     98e:	ff2080e7          	jalr	-14(ra) # 197c <printf>
        exit(1);
     992:	4505                	li	a0,1
     994:	00001097          	auipc	ra,0x1
     998:	abc080e7          	jalr	-1348(ra) # 1450 <exit>
      }
      struct stat st;
      if(fstat(fd1, &st) != 0){
     99c:	f8840713          	addi	a4,s0,-120
     9a0:	fc842783          	lw	a5,-56(s0)
     9a4:	85ba                	mv	a1,a4
     9a6:	853e                	mv	a0,a5
     9a8:	00001097          	auipc	ra,0x1
     9ac:	b00080e7          	jalr	-1280(ra) # 14a8 <fstat>
     9b0:	87aa                	mv	a5,a0
     9b2:	cf91                	beqz	a5,9ce <go+0x8c4>
        printf("grind: fstat failed\n");
     9b4:	00001517          	auipc	a0,0x1
     9b8:	4ec50513          	addi	a0,a0,1260 # 1ea0 <malloc+0x330>
     9bc:	00001097          	auipc	ra,0x1
     9c0:	fc0080e7          	jalr	-64(ra) # 197c <printf>
        exit(1);
     9c4:	4505                	li	a0,1
     9c6:	00001097          	auipc	ra,0x1
     9ca:	a8a080e7          	jalr	-1398(ra) # 1450 <exit>
      }
      if(st.size != 1){
     9ce:	f9843703          	ld	a4,-104(s0)
     9d2:	4785                	li	a5,1
     9d4:	02f70363          	beq	a4,a5,9fa <go+0x8f0>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     9d8:	f9843783          	ld	a5,-104(s0)
     9dc:	2781                	sext.w	a5,a5
     9de:	85be                	mv	a1,a5
     9e0:	00001517          	auipc	a0,0x1
     9e4:	4d850513          	addi	a0,a0,1240 # 1eb8 <malloc+0x348>
     9e8:	00001097          	auipc	ra,0x1
     9ec:	f94080e7          	jalr	-108(ra) # 197c <printf>
        exit(1);
     9f0:	4505                	li	a0,1
     9f2:	00001097          	auipc	ra,0x1
     9f6:	a5e080e7          	jalr	-1442(ra) # 1450 <exit>
      }
      if(st.ino > 200){
     9fa:	f8c42703          	lw	a4,-116(s0)
     9fe:	0c800793          	li	a5,200
     a02:	02e7f263          	bgeu	a5,a4,a26 <go+0x91c>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     a06:	f8c42783          	lw	a5,-116(s0)
     a0a:	85be                	mv	a1,a5
     a0c:	00001517          	auipc	a0,0x1
     a10:	4d450513          	addi	a0,a0,1236 # 1ee0 <malloc+0x370>
     a14:	00001097          	auipc	ra,0x1
     a18:	f68080e7          	jalr	-152(ra) # 197c <printf>
        exit(1);
     a1c:	4505                	li	a0,1
     a1e:	00001097          	auipc	ra,0x1
     a22:	a32080e7          	jalr	-1486(ra) # 1450 <exit>
      }
      close(fd1);
     a26:	fc842783          	lw	a5,-56(s0)
     a2a:	853e                	mv	a0,a5
     a2c:	00001097          	auipc	ra,0x1
     a30:	a4c080e7          	jalr	-1460(ra) # 1478 <close>
      unlink("c");
     a34:	00001517          	auipc	a0,0x1
     a38:	43450513          	addi	a0,a0,1076 # 1e68 <malloc+0x2f8>
     a3c:	00001097          	auipc	ra,0x1
     a40:	a64080e7          	jalr	-1436(ra) # 14a0 <unlink>
     a44:	f3aff06f          	j	17e <go+0x74>
    } else if(what == 22){
     a48:	fd442783          	lw	a5,-44(s0)
     a4c:	0007871b          	sext.w	a4,a5
     a50:	47d9                	li	a5,22
     a52:	f2f71663          	bne	a4,a5,17e <go+0x74>
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     a56:	f8040793          	addi	a5,s0,-128
     a5a:	853e                	mv	a0,a5
     a5c:	00001097          	auipc	ra,0x1
     a60:	a04080e7          	jalr	-1532(ra) # 1460 <pipe>
     a64:	87aa                	mv	a5,a0
     a66:	0207d063          	bgez	a5,a86 <go+0x97c>
        fprintf(2, "grind: pipe failed\n");
     a6a:	00001597          	auipc	a1,0x1
     a6e:	39658593          	addi	a1,a1,918 # 1e00 <malloc+0x290>
     a72:	4509                	li	a0,2
     a74:	00001097          	auipc	ra,0x1
     a78:	eb0080e7          	jalr	-336(ra) # 1924 <fprintf>
        exit(1);
     a7c:	4505                	li	a0,1
     a7e:	00001097          	auipc	ra,0x1
     a82:	9d2080e7          	jalr	-1582(ra) # 1450 <exit>
      }
      if(pipe(bb) < 0){
     a86:	f7840793          	addi	a5,s0,-136
     a8a:	853e                	mv	a0,a5
     a8c:	00001097          	auipc	ra,0x1
     a90:	9d4080e7          	jalr	-1580(ra) # 1460 <pipe>
     a94:	87aa                	mv	a5,a0
     a96:	0207d063          	bgez	a5,ab6 <go+0x9ac>
        fprintf(2, "grind: pipe failed\n");
     a9a:	00001597          	auipc	a1,0x1
     a9e:	36658593          	addi	a1,a1,870 # 1e00 <malloc+0x290>
     aa2:	4509                	li	a0,2
     aa4:	00001097          	auipc	ra,0x1
     aa8:	e80080e7          	jalr	-384(ra) # 1924 <fprintf>
        exit(1);
     aac:	4505                	li	a0,1
     aae:	00001097          	auipc	ra,0x1
     ab2:	9a2080e7          	jalr	-1630(ra) # 1450 <exit>
      }
      int pid1 = fork();
     ab6:	00001097          	auipc	ra,0x1
     aba:	992080e7          	jalr	-1646(ra) # 1448 <fork>
     abe:	87aa                	mv	a5,a0
     ac0:	fcf42823          	sw	a5,-48(s0)
      if(pid1 == 0){
     ac4:	fd042783          	lw	a5,-48(s0)
     ac8:	2781                	sext.w	a5,a5
     aca:	e3f9                	bnez	a5,b90 <go+0xa86>
        close(bb[0]);
     acc:	f7842783          	lw	a5,-136(s0)
     ad0:	853e                	mv	a0,a5
     ad2:	00001097          	auipc	ra,0x1
     ad6:	9a6080e7          	jalr	-1626(ra) # 1478 <close>
        close(bb[1]);
     ada:	f7c42783          	lw	a5,-132(s0)
     ade:	853e                	mv	a0,a5
     ae0:	00001097          	auipc	ra,0x1
     ae4:	998080e7          	jalr	-1640(ra) # 1478 <close>
        close(aa[0]);
     ae8:	f8042783          	lw	a5,-128(s0)
     aec:	853e                	mv	a0,a5
     aee:	00001097          	auipc	ra,0x1
     af2:	98a080e7          	jalr	-1654(ra) # 1478 <close>
        close(1);
     af6:	4505                	li	a0,1
     af8:	00001097          	auipc	ra,0x1
     afc:	980080e7          	jalr	-1664(ra) # 1478 <close>
        if(dup(aa[1]) != 1){
     b00:	f8442783          	lw	a5,-124(s0)
     b04:	853e                	mv	a0,a5
     b06:	00001097          	auipc	ra,0x1
     b0a:	9c2080e7          	jalr	-1598(ra) # 14c8 <dup>
     b0e:	87aa                	mv	a5,a0
     b10:	873e                	mv	a4,a5
     b12:	4785                	li	a5,1
     b14:	02f70063          	beq	a4,a5,b34 <go+0xa2a>
          fprintf(2, "grind: dup failed\n");
     b18:	00001597          	auipc	a1,0x1
     b1c:	3f058593          	addi	a1,a1,1008 # 1f08 <malloc+0x398>
     b20:	4509                	li	a0,2
     b22:	00001097          	auipc	ra,0x1
     b26:	e02080e7          	jalr	-510(ra) # 1924 <fprintf>
          exit(1);
     b2a:	4505                	li	a0,1
     b2c:	00001097          	auipc	ra,0x1
     b30:	924080e7          	jalr	-1756(ra) # 1450 <exit>
        }
        close(aa[1]);
     b34:	f8442783          	lw	a5,-124(s0)
     b38:	853e                	mv	a0,a5
     b3a:	00001097          	auipc	ra,0x1
     b3e:	93e080e7          	jalr	-1730(ra) # 1478 <close>
        char *args[3] = { "echo", "hi", 0 };
     b42:	00001797          	auipc	a5,0x1
     b46:	3de78793          	addi	a5,a5,990 # 1f20 <malloc+0x3b0>
     b4a:	f4f43823          	sd	a5,-176(s0)
     b4e:	00001797          	auipc	a5,0x1
     b52:	3da78793          	addi	a5,a5,986 # 1f28 <malloc+0x3b8>
     b56:	f4f43c23          	sd	a5,-168(s0)
     b5a:	f6043023          	sd	zero,-160(s0)
        exec("grindir/../echo", args);
     b5e:	f5040793          	addi	a5,s0,-176
     b62:	85be                	mv	a1,a5
     b64:	00001517          	auipc	a0,0x1
     b68:	3cc50513          	addi	a0,a0,972 # 1f30 <malloc+0x3c0>
     b6c:	00001097          	auipc	ra,0x1
     b70:	91c080e7          	jalr	-1764(ra) # 1488 <exec>
        fprintf(2, "grind: echo: not found\n");
     b74:	00001597          	auipc	a1,0x1
     b78:	3cc58593          	addi	a1,a1,972 # 1f40 <malloc+0x3d0>
     b7c:	4509                	li	a0,2
     b7e:	00001097          	auipc	ra,0x1
     b82:	da6080e7          	jalr	-602(ra) # 1924 <fprintf>
        exit(2);
     b86:	4509                	li	a0,2
     b88:	00001097          	auipc	ra,0x1
     b8c:	8c8080e7          	jalr	-1848(ra) # 1450 <exit>
      } else if(pid1 < 0){
     b90:	fd042783          	lw	a5,-48(s0)
     b94:	2781                	sext.w	a5,a5
     b96:	0207d063          	bgez	a5,bb6 <go+0xaac>
        fprintf(2, "grind: fork failed\n");
     b9a:	00001597          	auipc	a1,0x1
     b9e:	21e58593          	addi	a1,a1,542 # 1db8 <malloc+0x248>
     ba2:	4509                	li	a0,2
     ba4:	00001097          	auipc	ra,0x1
     ba8:	d80080e7          	jalr	-640(ra) # 1924 <fprintf>
        exit(3);
     bac:	450d                	li	a0,3
     bae:	00001097          	auipc	ra,0x1
     bb2:	8a2080e7          	jalr	-1886(ra) # 1450 <exit>
      }
      int pid2 = fork();
     bb6:	00001097          	auipc	ra,0x1
     bba:	892080e7          	jalr	-1902(ra) # 1448 <fork>
     bbe:	87aa                	mv	a5,a0
     bc0:	fcf42623          	sw	a5,-52(s0)
      if(pid2 == 0){
     bc4:	fcc42783          	lw	a5,-52(s0)
     bc8:	2781                	sext.w	a5,a5
     bca:	ebed                	bnez	a5,cbc <go+0xbb2>
        close(aa[1]);
     bcc:	f8442783          	lw	a5,-124(s0)
     bd0:	853e                	mv	a0,a5
     bd2:	00001097          	auipc	ra,0x1
     bd6:	8a6080e7          	jalr	-1882(ra) # 1478 <close>
        close(bb[0]);
     bda:	f7842783          	lw	a5,-136(s0)
     bde:	853e                	mv	a0,a5
     be0:	00001097          	auipc	ra,0x1
     be4:	898080e7          	jalr	-1896(ra) # 1478 <close>
        close(0);
     be8:	4501                	li	a0,0
     bea:	00001097          	auipc	ra,0x1
     bee:	88e080e7          	jalr	-1906(ra) # 1478 <close>
        if(dup(aa[0]) != 0){
     bf2:	f8042783          	lw	a5,-128(s0)
     bf6:	853e                	mv	a0,a5
     bf8:	00001097          	auipc	ra,0x1
     bfc:	8d0080e7          	jalr	-1840(ra) # 14c8 <dup>
     c00:	87aa                	mv	a5,a0
     c02:	cf99                	beqz	a5,c20 <go+0xb16>
          fprintf(2, "grind: dup failed\n");
     c04:	00001597          	auipc	a1,0x1
     c08:	30458593          	addi	a1,a1,772 # 1f08 <malloc+0x398>
     c0c:	4509                	li	a0,2
     c0e:	00001097          	auipc	ra,0x1
     c12:	d16080e7          	jalr	-746(ra) # 1924 <fprintf>
          exit(4);
     c16:	4511                	li	a0,4
     c18:	00001097          	auipc	ra,0x1
     c1c:	838080e7          	jalr	-1992(ra) # 1450 <exit>
        }
        close(aa[0]);
     c20:	f8042783          	lw	a5,-128(s0)
     c24:	853e                	mv	a0,a5
     c26:	00001097          	auipc	ra,0x1
     c2a:	852080e7          	jalr	-1966(ra) # 1478 <close>
        close(1);
     c2e:	4505                	li	a0,1
     c30:	00001097          	auipc	ra,0x1
     c34:	848080e7          	jalr	-1976(ra) # 1478 <close>
        if(dup(bb[1]) != 1){
     c38:	f7c42783          	lw	a5,-132(s0)
     c3c:	853e                	mv	a0,a5
     c3e:	00001097          	auipc	ra,0x1
     c42:	88a080e7          	jalr	-1910(ra) # 14c8 <dup>
     c46:	87aa                	mv	a5,a0
     c48:	873e                	mv	a4,a5
     c4a:	4785                	li	a5,1
     c4c:	02f70063          	beq	a4,a5,c6c <go+0xb62>
          fprintf(2, "grind: dup failed\n");
     c50:	00001597          	auipc	a1,0x1
     c54:	2b858593          	addi	a1,a1,696 # 1f08 <malloc+0x398>
     c58:	4509                	li	a0,2
     c5a:	00001097          	auipc	ra,0x1
     c5e:	cca080e7          	jalr	-822(ra) # 1924 <fprintf>
          exit(5);
     c62:	4515                	li	a0,5
     c64:	00000097          	auipc	ra,0x0
     c68:	7ec080e7          	jalr	2028(ra) # 1450 <exit>
        }
        close(bb[1]);
     c6c:	f7c42783          	lw	a5,-132(s0)
     c70:	853e                	mv	a0,a5
     c72:	00001097          	auipc	ra,0x1
     c76:	806080e7          	jalr	-2042(ra) # 1478 <close>
        char *args[2] = { "cat", 0 };
     c7a:	00001797          	auipc	a5,0x1
     c7e:	2de78793          	addi	a5,a5,734 # 1f58 <malloc+0x3e8>
     c82:	f4f43023          	sd	a5,-192(s0)
     c86:	f4043423          	sd	zero,-184(s0)
        exec("/cat", args);
     c8a:	f4040793          	addi	a5,s0,-192
     c8e:	85be                	mv	a1,a5
     c90:	00001517          	auipc	a0,0x1
     c94:	2d050513          	addi	a0,a0,720 # 1f60 <malloc+0x3f0>
     c98:	00000097          	auipc	ra,0x0
     c9c:	7f0080e7          	jalr	2032(ra) # 1488 <exec>
        fprintf(2, "grind: cat: not found\n");
     ca0:	00001597          	auipc	a1,0x1
     ca4:	2c858593          	addi	a1,a1,712 # 1f68 <malloc+0x3f8>
     ca8:	4509                	li	a0,2
     caa:	00001097          	auipc	ra,0x1
     cae:	c7a080e7          	jalr	-902(ra) # 1924 <fprintf>
        exit(6);
     cb2:	4519                	li	a0,6
     cb4:	00000097          	auipc	ra,0x0
     cb8:	79c080e7          	jalr	1948(ra) # 1450 <exit>
      } else if(pid2 < 0){
     cbc:	fcc42783          	lw	a5,-52(s0)
     cc0:	2781                	sext.w	a5,a5
     cc2:	0207d063          	bgez	a5,ce2 <go+0xbd8>
        fprintf(2, "grind: fork failed\n");
     cc6:	00001597          	auipc	a1,0x1
     cca:	0f258593          	addi	a1,a1,242 # 1db8 <malloc+0x248>
     cce:	4509                	li	a0,2
     cd0:	00001097          	auipc	ra,0x1
     cd4:	c54080e7          	jalr	-940(ra) # 1924 <fprintf>
        exit(7);
     cd8:	451d                	li	a0,7
     cda:	00000097          	auipc	ra,0x0
     cde:	776080e7          	jalr	1910(ra) # 1450 <exit>
      }
      close(aa[0]);
     ce2:	f8042783          	lw	a5,-128(s0)
     ce6:	853e                	mv	a0,a5
     ce8:	00000097          	auipc	ra,0x0
     cec:	790080e7          	jalr	1936(ra) # 1478 <close>
      close(aa[1]);
     cf0:	f8442783          	lw	a5,-124(s0)
     cf4:	853e                	mv	a0,a5
     cf6:	00000097          	auipc	ra,0x0
     cfa:	782080e7          	jalr	1922(ra) # 1478 <close>
      close(bb[1]);
     cfe:	f7c42783          	lw	a5,-132(s0)
     d02:	853e                	mv	a0,a5
     d04:	00000097          	auipc	ra,0x0
     d08:	774080e7          	jalr	1908(ra) # 1478 <close>
      char buf[4] = { 0, 0, 0, 0 };
     d0c:	f6042823          	sw	zero,-144(s0)
      read(bb[0], buf+0, 1);
     d10:	f7842783          	lw	a5,-136(s0)
     d14:	f7040713          	addi	a4,s0,-144
     d18:	4605                	li	a2,1
     d1a:	85ba                	mv	a1,a4
     d1c:	853e                	mv	a0,a5
     d1e:	00000097          	auipc	ra,0x0
     d22:	74a080e7          	jalr	1866(ra) # 1468 <read>
      read(bb[0], buf+1, 1);
     d26:	f7842703          	lw	a4,-136(s0)
     d2a:	f7040793          	addi	a5,s0,-144
     d2e:	0785                	addi	a5,a5,1
     d30:	4605                	li	a2,1
     d32:	85be                	mv	a1,a5
     d34:	853a                	mv	a0,a4
     d36:	00000097          	auipc	ra,0x0
     d3a:	732080e7          	jalr	1842(ra) # 1468 <read>
      read(bb[0], buf+2, 1);
     d3e:	f7842703          	lw	a4,-136(s0)
     d42:	f7040793          	addi	a5,s0,-144
     d46:	0789                	addi	a5,a5,2
     d48:	4605                	li	a2,1
     d4a:	85be                	mv	a1,a5
     d4c:	853a                	mv	a0,a4
     d4e:	00000097          	auipc	ra,0x0
     d52:	71a080e7          	jalr	1818(ra) # 1468 <read>
      close(bb[0]);
     d56:	f7842783          	lw	a5,-136(s0)
     d5a:	853e                	mv	a0,a5
     d5c:	00000097          	auipc	ra,0x0
     d60:	71c080e7          	jalr	1820(ra) # 1478 <close>
      int st1, st2;
      wait(&st1);
     d64:	f6c40793          	addi	a5,s0,-148
     d68:	853e                	mv	a0,a5
     d6a:	00000097          	auipc	ra,0x0
     d6e:	6ee080e7          	jalr	1774(ra) # 1458 <wait>
      wait(&st2);
     d72:	f6840793          	addi	a5,s0,-152
     d76:	853e                	mv	a0,a5
     d78:	00000097          	auipc	ra,0x0
     d7c:	6e0080e7          	jalr	1760(ra) # 1458 <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     d80:	f6c42783          	lw	a5,-148(s0)
     d84:	e395                	bnez	a5,da8 <go+0xc9e>
     d86:	f6842783          	lw	a5,-152(s0)
     d8a:	ef99                	bnez	a5,da8 <go+0xc9e>
     d8c:	f7040793          	addi	a5,s0,-144
     d90:	00001597          	auipc	a1,0x1
     d94:	1f058593          	addi	a1,a1,496 # 1f80 <malloc+0x410>
     d98:	853e                	mv	a0,a5
     d9a:	00000097          	auipc	ra,0x0
     d9e:	254080e7          	jalr	596(ra) # fee <strcmp>
     da2:	87aa                	mv	a5,a0
     da4:	bc078d63          	beqz	a5,17e <go+0x74>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     da8:	f6c42783          	lw	a5,-148(s0)
     dac:	f6842703          	lw	a4,-152(s0)
     db0:	f7040693          	addi	a3,s0,-144
     db4:	863a                	mv	a2,a4
     db6:	85be                	mv	a1,a5
     db8:	00001517          	auipc	a0,0x1
     dbc:	1d050513          	addi	a0,a0,464 # 1f88 <malloc+0x418>
     dc0:	00001097          	auipc	ra,0x1
     dc4:	bbc080e7          	jalr	-1092(ra) # 197c <printf>
        exit(1);
     dc8:	4505                	li	a0,1
     dca:	00000097          	auipc	ra,0x0
     dce:	686080e7          	jalr	1670(ra) # 1450 <exit>

0000000000000dd2 <iter>:
  }
}

void
iter()
{
     dd2:	1101                	addi	sp,sp,-32
     dd4:	ec06                	sd	ra,24(sp)
     dd6:	e822                	sd	s0,16(sp)
     dd8:	1000                	addi	s0,sp,32
  unlink("a");
     dda:	00001517          	auipc	a0,0x1
     dde:	ff650513          	addi	a0,a0,-10 # 1dd0 <malloc+0x260>
     de2:	00000097          	auipc	ra,0x0
     de6:	6be080e7          	jalr	1726(ra) # 14a0 <unlink>
  unlink("b");
     dea:	00001517          	auipc	a0,0x1
     dee:	f9650513          	addi	a0,a0,-106 # 1d80 <malloc+0x210>
     df2:	00000097          	auipc	ra,0x0
     df6:	6ae080e7          	jalr	1710(ra) # 14a0 <unlink>
  
  int pid1 = fork();
     dfa:	00000097          	auipc	ra,0x0
     dfe:	64e080e7          	jalr	1614(ra) # 1448 <fork>
     e02:	87aa                	mv	a5,a0
     e04:	fef42623          	sw	a5,-20(s0)
  if(pid1 < 0){
     e08:	fec42783          	lw	a5,-20(s0)
     e0c:	2781                	sext.w	a5,a5
     e0e:	0007df63          	bgez	a5,e2c <iter+0x5a>
    printf("grind: fork failed\n");
     e12:	00001517          	auipc	a0,0x1
     e16:	fa650513          	addi	a0,a0,-90 # 1db8 <malloc+0x248>
     e1a:	00001097          	auipc	ra,0x1
     e1e:	b62080e7          	jalr	-1182(ra) # 197c <printf>
    exit(1);
     e22:	4505                	li	a0,1
     e24:	00000097          	auipc	ra,0x0
     e28:	62c080e7          	jalr	1580(ra) # 1450 <exit>
  }
  if(pid1 == 0){
     e2c:	fec42783          	lw	a5,-20(s0)
     e30:	2781                	sext.w	a5,a5
     e32:	e79d                	bnez	a5,e60 <iter+0x8e>
    rand_next ^= 31;
     e34:	00001797          	auipc	a5,0x1
     e38:	1cc78793          	addi	a5,a5,460 # 2000 <rand_next>
     e3c:	639c                	ld	a5,0(a5)
     e3e:	01f7c713          	xori	a4,a5,31
     e42:	00001797          	auipc	a5,0x1
     e46:	1be78793          	addi	a5,a5,446 # 2000 <rand_next>
     e4a:	e398                	sd	a4,0(a5)
    go(0);
     e4c:	4501                	li	a0,0
     e4e:	fffff097          	auipc	ra,0xfffff
     e52:	2bc080e7          	jalr	700(ra) # 10a <go>
    exit(0);
     e56:	4501                	li	a0,0
     e58:	00000097          	auipc	ra,0x0
     e5c:	5f8080e7          	jalr	1528(ra) # 1450 <exit>
  }

  int pid2 = fork();
     e60:	00000097          	auipc	ra,0x0
     e64:	5e8080e7          	jalr	1512(ra) # 1448 <fork>
     e68:	87aa                	mv	a5,a0
     e6a:	fef42423          	sw	a5,-24(s0)
  if(pid2 < 0){
     e6e:	fe842783          	lw	a5,-24(s0)
     e72:	2781                	sext.w	a5,a5
     e74:	0007df63          	bgez	a5,e92 <iter+0xc0>
    printf("grind: fork failed\n");
     e78:	00001517          	auipc	a0,0x1
     e7c:	f4050513          	addi	a0,a0,-192 # 1db8 <malloc+0x248>
     e80:	00001097          	auipc	ra,0x1
     e84:	afc080e7          	jalr	-1284(ra) # 197c <printf>
    exit(1);
     e88:	4505                	li	a0,1
     e8a:	00000097          	auipc	ra,0x0
     e8e:	5c6080e7          	jalr	1478(ra) # 1450 <exit>
  }
  if(pid2 == 0){
     e92:	fe842783          	lw	a5,-24(s0)
     e96:	2781                	sext.w	a5,a5
     e98:	eb8d                	bnez	a5,eca <iter+0xf8>
    rand_next ^= 7177;
     e9a:	00001797          	auipc	a5,0x1
     e9e:	16678793          	addi	a5,a5,358 # 2000 <rand_next>
     ea2:	6398                	ld	a4,0(a5)
     ea4:	6789                	lui	a5,0x2
     ea6:	c0978793          	addi	a5,a5,-1015 # 1c09 <malloc+0x99>
     eaa:	8f3d                	xor	a4,a4,a5
     eac:	00001797          	auipc	a5,0x1
     eb0:	15478793          	addi	a5,a5,340 # 2000 <rand_next>
     eb4:	e398                	sd	a4,0(a5)
    go(1);
     eb6:	4505                	li	a0,1
     eb8:	fffff097          	auipc	ra,0xfffff
     ebc:	252080e7          	jalr	594(ra) # 10a <go>
    exit(0);
     ec0:	4501                	li	a0,0
     ec2:	00000097          	auipc	ra,0x0
     ec6:	58e080e7          	jalr	1422(ra) # 1450 <exit>
  }

  int st1 = -1;
     eca:	57fd                	li	a5,-1
     ecc:	fef42223          	sw	a5,-28(s0)
  wait(&st1);
     ed0:	fe440793          	addi	a5,s0,-28
     ed4:	853e                	mv	a0,a5
     ed6:	00000097          	auipc	ra,0x0
     eda:	582080e7          	jalr	1410(ra) # 1458 <wait>
  if(st1 != 0){
     ede:	fe442783          	lw	a5,-28(s0)
     ee2:	cf99                	beqz	a5,f00 <iter+0x12e>
    kill(pid1);
     ee4:	fec42783          	lw	a5,-20(s0)
     ee8:	853e                	mv	a0,a5
     eea:	00000097          	auipc	ra,0x0
     eee:	596080e7          	jalr	1430(ra) # 1480 <kill>
    kill(pid2);
     ef2:	fe842783          	lw	a5,-24(s0)
     ef6:	853e                	mv	a0,a5
     ef8:	00000097          	auipc	ra,0x0
     efc:	588080e7          	jalr	1416(ra) # 1480 <kill>
  }
  int st2 = -1;
     f00:	57fd                	li	a5,-1
     f02:	fef42023          	sw	a5,-32(s0)
  wait(&st2);
     f06:	fe040793          	addi	a5,s0,-32
     f0a:	853e                	mv	a0,a5
     f0c:	00000097          	auipc	ra,0x0
     f10:	54c080e7          	jalr	1356(ra) # 1458 <wait>

  exit(0);
     f14:	4501                	li	a0,0
     f16:	00000097          	auipc	ra,0x0
     f1a:	53a080e7          	jalr	1338(ra) # 1450 <exit>

0000000000000f1e <main>:
}

int
main()
{
     f1e:	1101                	addi	sp,sp,-32
     f20:	ec06                	sd	ra,24(sp)
     f22:	e822                	sd	s0,16(sp)
     f24:	1000                	addi	s0,sp,32
  while(1){
    int pid = fork();
     f26:	00000097          	auipc	ra,0x0
     f2a:	522080e7          	jalr	1314(ra) # 1448 <fork>
     f2e:	87aa                	mv	a5,a0
     f30:	fef42623          	sw	a5,-20(s0)
    if(pid == 0){
     f34:	fec42783          	lw	a5,-20(s0)
     f38:	2781                	sext.w	a5,a5
     f3a:	eb91                	bnez	a5,f4e <main+0x30>
      iter();
     f3c:	00000097          	auipc	ra,0x0
     f40:	e96080e7          	jalr	-362(ra) # dd2 <iter>
      exit(0);
     f44:	4501                	li	a0,0
     f46:	00000097          	auipc	ra,0x0
     f4a:	50a080e7          	jalr	1290(ra) # 1450 <exit>
    }
    if(pid > 0){
     f4e:	fec42783          	lw	a5,-20(s0)
     f52:	2781                	sext.w	a5,a5
     f54:	00f05763          	blez	a5,f62 <main+0x44>
      wait(0);
     f58:	4501                	li	a0,0
     f5a:	00000097          	auipc	ra,0x0
     f5e:	4fe080e7          	jalr	1278(ra) # 1458 <wait>
    }
    sleep(20);
     f62:	4551                	li	a0,20
     f64:	00000097          	auipc	ra,0x0
     f68:	57c080e7          	jalr	1404(ra) # 14e0 <sleep>
    rand_next += 1;
     f6c:	00001797          	auipc	a5,0x1
     f70:	09478793          	addi	a5,a5,148 # 2000 <rand_next>
     f74:	639c                	ld	a5,0(a5)
     f76:	00178713          	addi	a4,a5,1
     f7a:	00001797          	auipc	a5,0x1
     f7e:	08678793          	addi	a5,a5,134 # 2000 <rand_next>
     f82:	e398                	sd	a4,0(a5)
  while(1){
     f84:	b74d                	j	f26 <main+0x8>

0000000000000f86 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     f86:	1141                	addi	sp,sp,-16
     f88:	e406                	sd	ra,8(sp)
     f8a:	e022                	sd	s0,0(sp)
     f8c:	0800                	addi	s0,sp,16
  extern int main();
  main();
     f8e:	00000097          	auipc	ra,0x0
     f92:	f90080e7          	jalr	-112(ra) # f1e <main>
  exit(0);
     f96:	4501                	li	a0,0
     f98:	00000097          	auipc	ra,0x0
     f9c:	4b8080e7          	jalr	1208(ra) # 1450 <exit>

0000000000000fa0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     fa0:	7179                	addi	sp,sp,-48
     fa2:	f406                	sd	ra,40(sp)
     fa4:	f022                	sd	s0,32(sp)
     fa6:	1800                	addi	s0,sp,48
     fa8:	fca43c23          	sd	a0,-40(s0)
     fac:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
     fb0:	fd843783          	ld	a5,-40(s0)
     fb4:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
     fb8:	0001                	nop
     fba:	fd043703          	ld	a4,-48(s0)
     fbe:	00170793          	addi	a5,a4,1
     fc2:	fcf43823          	sd	a5,-48(s0)
     fc6:	fd843783          	ld	a5,-40(s0)
     fca:	00178693          	addi	a3,a5,1
     fce:	fcd43c23          	sd	a3,-40(s0)
     fd2:	00074703          	lbu	a4,0(a4)
     fd6:	00e78023          	sb	a4,0(a5)
     fda:	0007c783          	lbu	a5,0(a5)
     fde:	fff1                	bnez	a5,fba <strcpy+0x1a>
    ;
  return os;
     fe0:	fe843783          	ld	a5,-24(s0)
}
     fe4:	853e                	mv	a0,a5
     fe6:	70a2                	ld	ra,40(sp)
     fe8:	7402                	ld	s0,32(sp)
     fea:	6145                	addi	sp,sp,48
     fec:	8082                	ret

0000000000000fee <strcmp>:

int
strcmp(const char *p, const char *q)
{
     fee:	1101                	addi	sp,sp,-32
     ff0:	ec06                	sd	ra,24(sp)
     ff2:	e822                	sd	s0,16(sp)
     ff4:	1000                	addi	s0,sp,32
     ff6:	fea43423          	sd	a0,-24(s0)
     ffa:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
     ffe:	a819                	j	1014 <strcmp+0x26>
    p++, q++;
    1000:	fe843783          	ld	a5,-24(s0)
    1004:	0785                	addi	a5,a5,1
    1006:	fef43423          	sd	a5,-24(s0)
    100a:	fe043783          	ld	a5,-32(s0)
    100e:	0785                	addi	a5,a5,1
    1010:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
    1014:	fe843783          	ld	a5,-24(s0)
    1018:	0007c783          	lbu	a5,0(a5)
    101c:	cb99                	beqz	a5,1032 <strcmp+0x44>
    101e:	fe843783          	ld	a5,-24(s0)
    1022:	0007c703          	lbu	a4,0(a5)
    1026:	fe043783          	ld	a5,-32(s0)
    102a:	0007c783          	lbu	a5,0(a5)
    102e:	fcf709e3          	beq	a4,a5,1000 <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
    1032:	fe843783          	ld	a5,-24(s0)
    1036:	0007c783          	lbu	a5,0(a5)
    103a:	0007871b          	sext.w	a4,a5
    103e:	fe043783          	ld	a5,-32(s0)
    1042:	0007c783          	lbu	a5,0(a5)
    1046:	2781                	sext.w	a5,a5
    1048:	40f707bb          	subw	a5,a4,a5
    104c:	2781                	sext.w	a5,a5
}
    104e:	853e                	mv	a0,a5
    1050:	60e2                	ld	ra,24(sp)
    1052:	6442                	ld	s0,16(sp)
    1054:	6105                	addi	sp,sp,32
    1056:	8082                	ret

0000000000001058 <strlen>:

uint
strlen(const char *s)
{
    1058:	7179                	addi	sp,sp,-48
    105a:	f406                	sd	ra,40(sp)
    105c:	f022                	sd	s0,32(sp)
    105e:	1800                	addi	s0,sp,48
    1060:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
    1064:	fe042623          	sw	zero,-20(s0)
    1068:	a031                	j	1074 <strlen+0x1c>
    106a:	fec42783          	lw	a5,-20(s0)
    106e:	2785                	addiw	a5,a5,1
    1070:	fef42623          	sw	a5,-20(s0)
    1074:	fec42783          	lw	a5,-20(s0)
    1078:	fd843703          	ld	a4,-40(s0)
    107c:	97ba                	add	a5,a5,a4
    107e:	0007c783          	lbu	a5,0(a5)
    1082:	f7e5                	bnez	a5,106a <strlen+0x12>
    ;
  return n;
    1084:	fec42783          	lw	a5,-20(s0)
}
    1088:	853e                	mv	a0,a5
    108a:	70a2                	ld	ra,40(sp)
    108c:	7402                	ld	s0,32(sp)
    108e:	6145                	addi	sp,sp,48
    1090:	8082                	ret

0000000000001092 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1092:	7179                	addi	sp,sp,-48
    1094:	f406                	sd	ra,40(sp)
    1096:	f022                	sd	s0,32(sp)
    1098:	1800                	addi	s0,sp,48
    109a:	fca43c23          	sd	a0,-40(s0)
    109e:	87ae                	mv	a5,a1
    10a0:	8732                	mv	a4,a2
    10a2:	fcf42a23          	sw	a5,-44(s0)
    10a6:	87ba                	mv	a5,a4
    10a8:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
    10ac:	fd843783          	ld	a5,-40(s0)
    10b0:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
    10b4:	fe042623          	sw	zero,-20(s0)
    10b8:	a00d                	j	10da <memset+0x48>
    cdst[i] = c;
    10ba:	fec42783          	lw	a5,-20(s0)
    10be:	fe043703          	ld	a4,-32(s0)
    10c2:	97ba                	add	a5,a5,a4
    10c4:	fd442703          	lw	a4,-44(s0)
    10c8:	0ff77713          	zext.b	a4,a4
    10cc:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
    10d0:	fec42783          	lw	a5,-20(s0)
    10d4:	2785                	addiw	a5,a5,1
    10d6:	fef42623          	sw	a5,-20(s0)
    10da:	fec42783          	lw	a5,-20(s0)
    10de:	fd042703          	lw	a4,-48(s0)
    10e2:	2701                	sext.w	a4,a4
    10e4:	fce7ebe3          	bltu	a5,a4,10ba <memset+0x28>
  }
  return dst;
    10e8:	fd843783          	ld	a5,-40(s0)
}
    10ec:	853e                	mv	a0,a5
    10ee:	70a2                	ld	ra,40(sp)
    10f0:	7402                	ld	s0,32(sp)
    10f2:	6145                	addi	sp,sp,48
    10f4:	8082                	ret

00000000000010f6 <strchr>:

char*
strchr(const char *s, char c)
{
    10f6:	1101                	addi	sp,sp,-32
    10f8:	ec06                	sd	ra,24(sp)
    10fa:	e822                	sd	s0,16(sp)
    10fc:	1000                	addi	s0,sp,32
    10fe:	fea43423          	sd	a0,-24(s0)
    1102:	87ae                	mv	a5,a1
    1104:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
    1108:	a01d                	j	112e <strchr+0x38>
    if(*s == c)
    110a:	fe843783          	ld	a5,-24(s0)
    110e:	0007c703          	lbu	a4,0(a5)
    1112:	fe744783          	lbu	a5,-25(s0)
    1116:	0ff7f793          	zext.b	a5,a5
    111a:	00e79563          	bne	a5,a4,1124 <strchr+0x2e>
      return (char*)s;
    111e:	fe843783          	ld	a5,-24(s0)
    1122:	a821                	j	113a <strchr+0x44>
  for(; *s; s++)
    1124:	fe843783          	ld	a5,-24(s0)
    1128:	0785                	addi	a5,a5,1
    112a:	fef43423          	sd	a5,-24(s0)
    112e:	fe843783          	ld	a5,-24(s0)
    1132:	0007c783          	lbu	a5,0(a5)
    1136:	fbf1                	bnez	a5,110a <strchr+0x14>
  return 0;
    1138:	4781                	li	a5,0
}
    113a:	853e                	mv	a0,a5
    113c:	60e2                	ld	ra,24(sp)
    113e:	6442                	ld	s0,16(sp)
    1140:	6105                	addi	sp,sp,32
    1142:	8082                	ret

0000000000001144 <gets>:

char*
gets(char *buf, int max)
{
    1144:	7179                	addi	sp,sp,-48
    1146:	f406                	sd	ra,40(sp)
    1148:	f022                	sd	s0,32(sp)
    114a:	1800                	addi	s0,sp,48
    114c:	fca43c23          	sd	a0,-40(s0)
    1150:	87ae                	mv	a5,a1
    1152:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1156:	fe042623          	sw	zero,-20(s0)
    115a:	a8a1                	j	11b2 <gets+0x6e>
    cc = read(0, &c, 1);
    115c:	fe740793          	addi	a5,s0,-25
    1160:	4605                	li	a2,1
    1162:	85be                	mv	a1,a5
    1164:	4501                	li	a0,0
    1166:	00000097          	auipc	ra,0x0
    116a:	302080e7          	jalr	770(ra) # 1468 <read>
    116e:	87aa                	mv	a5,a0
    1170:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
    1174:	fe842783          	lw	a5,-24(s0)
    1178:	2781                	sext.w	a5,a5
    117a:	04f05663          	blez	a5,11c6 <gets+0x82>
      break;
    buf[i++] = c;
    117e:	fec42783          	lw	a5,-20(s0)
    1182:	0017871b          	addiw	a4,a5,1
    1186:	fee42623          	sw	a4,-20(s0)
    118a:	873e                	mv	a4,a5
    118c:	fd843783          	ld	a5,-40(s0)
    1190:	97ba                	add	a5,a5,a4
    1192:	fe744703          	lbu	a4,-25(s0)
    1196:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
    119a:	fe744783          	lbu	a5,-25(s0)
    119e:	873e                	mv	a4,a5
    11a0:	47a9                	li	a5,10
    11a2:	02f70363          	beq	a4,a5,11c8 <gets+0x84>
    11a6:	fe744783          	lbu	a5,-25(s0)
    11aa:	873e                	mv	a4,a5
    11ac:	47b5                	li	a5,13
    11ae:	00f70d63          	beq	a4,a5,11c8 <gets+0x84>
  for(i=0; i+1 < max; ){
    11b2:	fec42783          	lw	a5,-20(s0)
    11b6:	2785                	addiw	a5,a5,1
    11b8:	2781                	sext.w	a5,a5
    11ba:	fd442703          	lw	a4,-44(s0)
    11be:	2701                	sext.w	a4,a4
    11c0:	f8e7cee3          	blt	a5,a4,115c <gets+0x18>
    11c4:	a011                	j	11c8 <gets+0x84>
      break;
    11c6:	0001                	nop
      break;
  }
  buf[i] = '\0';
    11c8:	fec42783          	lw	a5,-20(s0)
    11cc:	fd843703          	ld	a4,-40(s0)
    11d0:	97ba                	add	a5,a5,a4
    11d2:	00078023          	sb	zero,0(a5)
  return buf;
    11d6:	fd843783          	ld	a5,-40(s0)
}
    11da:	853e                	mv	a0,a5
    11dc:	70a2                	ld	ra,40(sp)
    11de:	7402                	ld	s0,32(sp)
    11e0:	6145                	addi	sp,sp,48
    11e2:	8082                	ret

00000000000011e4 <stat>:

int
stat(const char *n, struct stat *st)
{
    11e4:	7179                	addi	sp,sp,-48
    11e6:	f406                	sd	ra,40(sp)
    11e8:	f022                	sd	s0,32(sp)
    11ea:	1800                	addi	s0,sp,48
    11ec:	fca43c23          	sd	a0,-40(s0)
    11f0:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11f4:	4581                	li	a1,0
    11f6:	fd843503          	ld	a0,-40(s0)
    11fa:	00000097          	auipc	ra,0x0
    11fe:	296080e7          	jalr	662(ra) # 1490 <open>
    1202:	87aa                	mv	a5,a0
    1204:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
    1208:	fec42783          	lw	a5,-20(s0)
    120c:	2781                	sext.w	a5,a5
    120e:	0007d463          	bgez	a5,1216 <stat+0x32>
    return -1;
    1212:	57fd                	li	a5,-1
    1214:	a035                	j	1240 <stat+0x5c>
  r = fstat(fd, st);
    1216:	fec42783          	lw	a5,-20(s0)
    121a:	fd043583          	ld	a1,-48(s0)
    121e:	853e                	mv	a0,a5
    1220:	00000097          	auipc	ra,0x0
    1224:	288080e7          	jalr	648(ra) # 14a8 <fstat>
    1228:	87aa                	mv	a5,a0
    122a:	fef42423          	sw	a5,-24(s0)
  close(fd);
    122e:	fec42783          	lw	a5,-20(s0)
    1232:	853e                	mv	a0,a5
    1234:	00000097          	auipc	ra,0x0
    1238:	244080e7          	jalr	580(ra) # 1478 <close>
  return r;
    123c:	fe842783          	lw	a5,-24(s0)
}
    1240:	853e                	mv	a0,a5
    1242:	70a2                	ld	ra,40(sp)
    1244:	7402                	ld	s0,32(sp)
    1246:	6145                	addi	sp,sp,48
    1248:	8082                	ret

000000000000124a <atoi>:

int
atoi(const char *s)
{
    124a:	7179                	addi	sp,sp,-48
    124c:	f406                	sd	ra,40(sp)
    124e:	f022                	sd	s0,32(sp)
    1250:	1800                	addi	s0,sp,48
    1252:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
    1256:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
    125a:	a81d                	j	1290 <atoi+0x46>
    n = n*10 + *s++ - '0';
    125c:	fec42783          	lw	a5,-20(s0)
    1260:	873e                	mv	a4,a5
    1262:	87ba                	mv	a5,a4
    1264:	0027979b          	slliw	a5,a5,0x2
    1268:	9fb9                	addw	a5,a5,a4
    126a:	0017979b          	slliw	a5,a5,0x1
    126e:	0007871b          	sext.w	a4,a5
    1272:	fd843783          	ld	a5,-40(s0)
    1276:	00178693          	addi	a3,a5,1
    127a:	fcd43c23          	sd	a3,-40(s0)
    127e:	0007c783          	lbu	a5,0(a5)
    1282:	2781                	sext.w	a5,a5
    1284:	9fb9                	addw	a5,a5,a4
    1286:	2781                	sext.w	a5,a5
    1288:	fd07879b          	addiw	a5,a5,-48
    128c:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
    1290:	fd843783          	ld	a5,-40(s0)
    1294:	0007c783          	lbu	a5,0(a5)
    1298:	873e                	mv	a4,a5
    129a:	02f00793          	li	a5,47
    129e:	00e7fb63          	bgeu	a5,a4,12b4 <atoi+0x6a>
    12a2:	fd843783          	ld	a5,-40(s0)
    12a6:	0007c783          	lbu	a5,0(a5)
    12aa:	873e                	mv	a4,a5
    12ac:	03900793          	li	a5,57
    12b0:	fae7f6e3          	bgeu	a5,a4,125c <atoi+0x12>
  return n;
    12b4:	fec42783          	lw	a5,-20(s0)
}
    12b8:	853e                	mv	a0,a5
    12ba:	70a2                	ld	ra,40(sp)
    12bc:	7402                	ld	s0,32(sp)
    12be:	6145                	addi	sp,sp,48
    12c0:	8082                	ret

00000000000012c2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    12c2:	7139                	addi	sp,sp,-64
    12c4:	fc06                	sd	ra,56(sp)
    12c6:	f822                	sd	s0,48(sp)
    12c8:	0080                	addi	s0,sp,64
    12ca:	fca43c23          	sd	a0,-40(s0)
    12ce:	fcb43823          	sd	a1,-48(s0)
    12d2:	87b2                	mv	a5,a2
    12d4:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
    12d8:	fd843783          	ld	a5,-40(s0)
    12dc:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
    12e0:	fd043783          	ld	a5,-48(s0)
    12e4:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
    12e8:	fe043703          	ld	a4,-32(s0)
    12ec:	fe843783          	ld	a5,-24(s0)
    12f0:	02e7fc63          	bgeu	a5,a4,1328 <memmove+0x66>
    while(n-- > 0)
    12f4:	a00d                	j	1316 <memmove+0x54>
      *dst++ = *src++;
    12f6:	fe043703          	ld	a4,-32(s0)
    12fa:	00170793          	addi	a5,a4,1
    12fe:	fef43023          	sd	a5,-32(s0)
    1302:	fe843783          	ld	a5,-24(s0)
    1306:	00178693          	addi	a3,a5,1
    130a:	fed43423          	sd	a3,-24(s0)
    130e:	00074703          	lbu	a4,0(a4)
    1312:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
    1316:	fcc42783          	lw	a5,-52(s0)
    131a:	fff7871b          	addiw	a4,a5,-1
    131e:	fce42623          	sw	a4,-52(s0)
    1322:	fcf04ae3          	bgtz	a5,12f6 <memmove+0x34>
    1326:	a891                	j	137a <memmove+0xb8>
  } else {
    dst += n;
    1328:	fcc42783          	lw	a5,-52(s0)
    132c:	fe843703          	ld	a4,-24(s0)
    1330:	97ba                	add	a5,a5,a4
    1332:	fef43423          	sd	a5,-24(s0)
    src += n;
    1336:	fcc42783          	lw	a5,-52(s0)
    133a:	fe043703          	ld	a4,-32(s0)
    133e:	97ba                	add	a5,a5,a4
    1340:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
    1344:	a01d                	j	136a <memmove+0xa8>
      *--dst = *--src;
    1346:	fe043783          	ld	a5,-32(s0)
    134a:	17fd                	addi	a5,a5,-1
    134c:	fef43023          	sd	a5,-32(s0)
    1350:	fe843783          	ld	a5,-24(s0)
    1354:	17fd                	addi	a5,a5,-1
    1356:	fef43423          	sd	a5,-24(s0)
    135a:	fe043783          	ld	a5,-32(s0)
    135e:	0007c703          	lbu	a4,0(a5)
    1362:	fe843783          	ld	a5,-24(s0)
    1366:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
    136a:	fcc42783          	lw	a5,-52(s0)
    136e:	fff7871b          	addiw	a4,a5,-1
    1372:	fce42623          	sw	a4,-52(s0)
    1376:	fcf048e3          	bgtz	a5,1346 <memmove+0x84>
  }
  return vdst;
    137a:	fd843783          	ld	a5,-40(s0)
}
    137e:	853e                	mv	a0,a5
    1380:	70e2                	ld	ra,56(sp)
    1382:	7442                	ld	s0,48(sp)
    1384:	6121                	addi	sp,sp,64
    1386:	8082                	ret

0000000000001388 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    1388:	7139                	addi	sp,sp,-64
    138a:	fc06                	sd	ra,56(sp)
    138c:	f822                	sd	s0,48(sp)
    138e:	0080                	addi	s0,sp,64
    1390:	fca43c23          	sd	a0,-40(s0)
    1394:	fcb43823          	sd	a1,-48(s0)
    1398:	87b2                	mv	a5,a2
    139a:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
    139e:	fd843783          	ld	a5,-40(s0)
    13a2:	fef43423          	sd	a5,-24(s0)
    13a6:	fd043783          	ld	a5,-48(s0)
    13aa:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
    13ae:	a0a1                	j	13f6 <memcmp+0x6e>
    if (*p1 != *p2) {
    13b0:	fe843783          	ld	a5,-24(s0)
    13b4:	0007c703          	lbu	a4,0(a5)
    13b8:	fe043783          	ld	a5,-32(s0)
    13bc:	0007c783          	lbu	a5,0(a5)
    13c0:	02f70163          	beq	a4,a5,13e2 <memcmp+0x5a>
      return *p1 - *p2;
    13c4:	fe843783          	ld	a5,-24(s0)
    13c8:	0007c783          	lbu	a5,0(a5)
    13cc:	0007871b          	sext.w	a4,a5
    13d0:	fe043783          	ld	a5,-32(s0)
    13d4:	0007c783          	lbu	a5,0(a5)
    13d8:	2781                	sext.w	a5,a5
    13da:	40f707bb          	subw	a5,a4,a5
    13de:	2781                	sext.w	a5,a5
    13e0:	a01d                	j	1406 <memcmp+0x7e>
    }
    p1++;
    13e2:	fe843783          	ld	a5,-24(s0)
    13e6:	0785                	addi	a5,a5,1
    13e8:	fef43423          	sd	a5,-24(s0)
    p2++;
    13ec:	fe043783          	ld	a5,-32(s0)
    13f0:	0785                	addi	a5,a5,1
    13f2:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
    13f6:	fcc42783          	lw	a5,-52(s0)
    13fa:	fff7871b          	addiw	a4,a5,-1
    13fe:	fce42623          	sw	a4,-52(s0)
    1402:	f7dd                	bnez	a5,13b0 <memcmp+0x28>
  }
  return 0;
    1404:	4781                	li	a5,0
}
    1406:	853e                	mv	a0,a5
    1408:	70e2                	ld	ra,56(sp)
    140a:	7442                	ld	s0,48(sp)
    140c:	6121                	addi	sp,sp,64
    140e:	8082                	ret

0000000000001410 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    1410:	7179                	addi	sp,sp,-48
    1412:	f406                	sd	ra,40(sp)
    1414:	f022                	sd	s0,32(sp)
    1416:	1800                	addi	s0,sp,48
    1418:	fea43423          	sd	a0,-24(s0)
    141c:	feb43023          	sd	a1,-32(s0)
    1420:	87b2                	mv	a5,a2
    1422:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
    1426:	fdc42783          	lw	a5,-36(s0)
    142a:	863e                	mv	a2,a5
    142c:	fe043583          	ld	a1,-32(s0)
    1430:	fe843503          	ld	a0,-24(s0)
    1434:	00000097          	auipc	ra,0x0
    1438:	e8e080e7          	jalr	-370(ra) # 12c2 <memmove>
    143c:	87aa                	mv	a5,a0
}
    143e:	853e                	mv	a0,a5
    1440:	70a2                	ld	ra,40(sp)
    1442:	7402                	ld	s0,32(sp)
    1444:	6145                	addi	sp,sp,48
    1446:	8082                	ret

0000000000001448 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    1448:	4885                	li	a7,1
 ecall
    144a:	00000073          	ecall
 ret
    144e:	8082                	ret

0000000000001450 <exit>:
.global exit
exit:
 li a7, SYS_exit
    1450:	4889                	li	a7,2
 ecall
    1452:	00000073          	ecall
 ret
    1456:	8082                	ret

0000000000001458 <wait>:
.global wait
wait:
 li a7, SYS_wait
    1458:	488d                	li	a7,3
 ecall
    145a:	00000073          	ecall
 ret
    145e:	8082                	ret

0000000000001460 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    1460:	4891                	li	a7,4
 ecall
    1462:	00000073          	ecall
 ret
    1466:	8082                	ret

0000000000001468 <read>:
.global read
read:
 li a7, SYS_read
    1468:	4895                	li	a7,5
 ecall
    146a:	00000073          	ecall
 ret
    146e:	8082                	ret

0000000000001470 <write>:
.global write
write:
 li a7, SYS_write
    1470:	48c1                	li	a7,16
 ecall
    1472:	00000073          	ecall
 ret
    1476:	8082                	ret

0000000000001478 <close>:
.global close
close:
 li a7, SYS_close
    1478:	48d5                	li	a7,21
 ecall
    147a:	00000073          	ecall
 ret
    147e:	8082                	ret

0000000000001480 <kill>:
.global kill
kill:
 li a7, SYS_kill
    1480:	4899                	li	a7,6
 ecall
    1482:	00000073          	ecall
 ret
    1486:	8082                	ret

0000000000001488 <exec>:
.global exec
exec:
 li a7, SYS_exec
    1488:	489d                	li	a7,7
 ecall
    148a:	00000073          	ecall
 ret
    148e:	8082                	ret

0000000000001490 <open>:
.global open
open:
 li a7, SYS_open
    1490:	48bd                	li	a7,15
 ecall
    1492:	00000073          	ecall
 ret
    1496:	8082                	ret

0000000000001498 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    1498:	48c5                	li	a7,17
 ecall
    149a:	00000073          	ecall
 ret
    149e:	8082                	ret

00000000000014a0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    14a0:	48c9                	li	a7,18
 ecall
    14a2:	00000073          	ecall
 ret
    14a6:	8082                	ret

00000000000014a8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    14a8:	48a1                	li	a7,8
 ecall
    14aa:	00000073          	ecall
 ret
    14ae:	8082                	ret

00000000000014b0 <link>:
.global link
link:
 li a7, SYS_link
    14b0:	48cd                	li	a7,19
 ecall
    14b2:	00000073          	ecall
 ret
    14b6:	8082                	ret

00000000000014b8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    14b8:	48d1                	li	a7,20
 ecall
    14ba:	00000073          	ecall
 ret
    14be:	8082                	ret

00000000000014c0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    14c0:	48a5                	li	a7,9
 ecall
    14c2:	00000073          	ecall
 ret
    14c6:	8082                	ret

00000000000014c8 <dup>:
.global dup
dup:
 li a7, SYS_dup
    14c8:	48a9                	li	a7,10
 ecall
    14ca:	00000073          	ecall
 ret
    14ce:	8082                	ret

00000000000014d0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    14d0:	48ad                	li	a7,11
 ecall
    14d2:	00000073          	ecall
 ret
    14d6:	8082                	ret

00000000000014d8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    14d8:	48b1                	li	a7,12
 ecall
    14da:	00000073          	ecall
 ret
    14de:	8082                	ret

00000000000014e0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    14e0:	48b5                	li	a7,13
 ecall
    14e2:	00000073          	ecall
 ret
    14e6:	8082                	ret

00000000000014e8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    14e8:	48b9                	li	a7,14
 ecall
    14ea:	00000073          	ecall
 ret
    14ee:	8082                	ret

00000000000014f0 <ps>:
.global ps
ps:
 li a7, SYS_ps
    14f0:	48d9                	li	a7,22
 ecall
    14f2:	00000073          	ecall
 ret
    14f6:	8082                	ret

00000000000014f8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    14f8:	1101                	addi	sp,sp,-32
    14fa:	ec06                	sd	ra,24(sp)
    14fc:	e822                	sd	s0,16(sp)
    14fe:	1000                	addi	s0,sp,32
    1500:	87aa                	mv	a5,a0
    1502:	872e                	mv	a4,a1
    1504:	fef42623          	sw	a5,-20(s0)
    1508:	87ba                	mv	a5,a4
    150a:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
    150e:	feb40713          	addi	a4,s0,-21
    1512:	fec42783          	lw	a5,-20(s0)
    1516:	4605                	li	a2,1
    1518:	85ba                	mv	a1,a4
    151a:	853e                	mv	a0,a5
    151c:	00000097          	auipc	ra,0x0
    1520:	f54080e7          	jalr	-172(ra) # 1470 <write>
}
    1524:	0001                	nop
    1526:	60e2                	ld	ra,24(sp)
    1528:	6442                	ld	s0,16(sp)
    152a:	6105                	addi	sp,sp,32
    152c:	8082                	ret

000000000000152e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    152e:	7139                	addi	sp,sp,-64
    1530:	fc06                	sd	ra,56(sp)
    1532:	f822                	sd	s0,48(sp)
    1534:	0080                	addi	s0,sp,64
    1536:	87aa                	mv	a5,a0
    1538:	8736                	mv	a4,a3
    153a:	fcf42623          	sw	a5,-52(s0)
    153e:	87ae                	mv	a5,a1
    1540:	fcf42423          	sw	a5,-56(s0)
    1544:	87b2                	mv	a5,a2
    1546:	fcf42223          	sw	a5,-60(s0)
    154a:	87ba                	mv	a5,a4
    154c:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1550:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
    1554:	fc042783          	lw	a5,-64(s0)
    1558:	2781                	sext.w	a5,a5
    155a:	c38d                	beqz	a5,157c <printint+0x4e>
    155c:	fc842783          	lw	a5,-56(s0)
    1560:	2781                	sext.w	a5,a5
    1562:	0007dd63          	bgez	a5,157c <printint+0x4e>
    neg = 1;
    1566:	4785                	li	a5,1
    1568:	fef42423          	sw	a5,-24(s0)
    x = -xx;
    156c:	fc842783          	lw	a5,-56(s0)
    1570:	40f007bb          	negw	a5,a5
    1574:	2781                	sext.w	a5,a5
    1576:	fef42223          	sw	a5,-28(s0)
    157a:	a029                	j	1584 <printint+0x56>
  } else {
    x = xx;
    157c:	fc842783          	lw	a5,-56(s0)
    1580:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
    1584:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
    1588:	fc442783          	lw	a5,-60(s0)
    158c:	fe442703          	lw	a4,-28(s0)
    1590:	02f777bb          	remuw	a5,a4,a5
    1594:	0007871b          	sext.w	a4,a5
    1598:	fec42783          	lw	a5,-20(s0)
    159c:	0017869b          	addiw	a3,a5,1
    15a0:	fed42623          	sw	a3,-20(s0)
    15a4:	00001697          	auipc	a3,0x1
    15a8:	a6c68693          	addi	a3,a3,-1428 # 2010 <digits>
    15ac:	1702                	slli	a4,a4,0x20
    15ae:	9301                	srli	a4,a4,0x20
    15b0:	9736                	add	a4,a4,a3
    15b2:	00074703          	lbu	a4,0(a4)
    15b6:	17c1                	addi	a5,a5,-16
    15b8:	97a2                	add	a5,a5,s0
    15ba:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
    15be:	fc442783          	lw	a5,-60(s0)
    15c2:	fe442703          	lw	a4,-28(s0)
    15c6:	02f757bb          	divuw	a5,a4,a5
    15ca:	fef42223          	sw	a5,-28(s0)
    15ce:	fe442783          	lw	a5,-28(s0)
    15d2:	2781                	sext.w	a5,a5
    15d4:	fbd5                	bnez	a5,1588 <printint+0x5a>
  if(neg)
    15d6:	fe842783          	lw	a5,-24(s0)
    15da:	2781                	sext.w	a5,a5
    15dc:	cf85                	beqz	a5,1614 <printint+0xe6>
    buf[i++] = '-';
    15de:	fec42783          	lw	a5,-20(s0)
    15e2:	0017871b          	addiw	a4,a5,1
    15e6:	fee42623          	sw	a4,-20(s0)
    15ea:	17c1                	addi	a5,a5,-16
    15ec:	97a2                	add	a5,a5,s0
    15ee:	02d00713          	li	a4,45
    15f2:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
    15f6:	a839                	j	1614 <printint+0xe6>
    putc(fd, buf[i]);
    15f8:	fec42783          	lw	a5,-20(s0)
    15fc:	17c1                	addi	a5,a5,-16
    15fe:	97a2                	add	a5,a5,s0
    1600:	fe07c703          	lbu	a4,-32(a5)
    1604:	fcc42783          	lw	a5,-52(s0)
    1608:	85ba                	mv	a1,a4
    160a:	853e                	mv	a0,a5
    160c:	00000097          	auipc	ra,0x0
    1610:	eec080e7          	jalr	-276(ra) # 14f8 <putc>
  while(--i >= 0)
    1614:	fec42783          	lw	a5,-20(s0)
    1618:	37fd                	addiw	a5,a5,-1
    161a:	fef42623          	sw	a5,-20(s0)
    161e:	fec42783          	lw	a5,-20(s0)
    1622:	2781                	sext.w	a5,a5
    1624:	fc07dae3          	bgez	a5,15f8 <printint+0xca>
}
    1628:	0001                	nop
    162a:	0001                	nop
    162c:	70e2                	ld	ra,56(sp)
    162e:	7442                	ld	s0,48(sp)
    1630:	6121                	addi	sp,sp,64
    1632:	8082                	ret

0000000000001634 <printptr>:

static void
printptr(int fd, uint64 x) {
    1634:	7179                	addi	sp,sp,-48
    1636:	f406                	sd	ra,40(sp)
    1638:	f022                	sd	s0,32(sp)
    163a:	1800                	addi	s0,sp,48
    163c:	87aa                	mv	a5,a0
    163e:	fcb43823          	sd	a1,-48(s0)
    1642:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
    1646:	fdc42783          	lw	a5,-36(s0)
    164a:	03000593          	li	a1,48
    164e:	853e                	mv	a0,a5
    1650:	00000097          	auipc	ra,0x0
    1654:	ea8080e7          	jalr	-344(ra) # 14f8 <putc>
  putc(fd, 'x');
    1658:	fdc42783          	lw	a5,-36(s0)
    165c:	07800593          	li	a1,120
    1660:	853e                	mv	a0,a5
    1662:	00000097          	auipc	ra,0x0
    1666:	e96080e7          	jalr	-362(ra) # 14f8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    166a:	fe042623          	sw	zero,-20(s0)
    166e:	a82d                	j	16a8 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1670:	fd043783          	ld	a5,-48(s0)
    1674:	93f1                	srli	a5,a5,0x3c
    1676:	00001717          	auipc	a4,0x1
    167a:	99a70713          	addi	a4,a4,-1638 # 2010 <digits>
    167e:	97ba                	add	a5,a5,a4
    1680:	0007c703          	lbu	a4,0(a5)
    1684:	fdc42783          	lw	a5,-36(s0)
    1688:	85ba                	mv	a1,a4
    168a:	853e                	mv	a0,a5
    168c:	00000097          	auipc	ra,0x0
    1690:	e6c080e7          	jalr	-404(ra) # 14f8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1694:	fec42783          	lw	a5,-20(s0)
    1698:	2785                	addiw	a5,a5,1
    169a:	fef42623          	sw	a5,-20(s0)
    169e:	fd043783          	ld	a5,-48(s0)
    16a2:	0792                	slli	a5,a5,0x4
    16a4:	fcf43823          	sd	a5,-48(s0)
    16a8:	fec42703          	lw	a4,-20(s0)
    16ac:	47bd                	li	a5,15
    16ae:	fce7f1e3          	bgeu	a5,a4,1670 <printptr+0x3c>
}
    16b2:	0001                	nop
    16b4:	0001                	nop
    16b6:	70a2                	ld	ra,40(sp)
    16b8:	7402                	ld	s0,32(sp)
    16ba:	6145                	addi	sp,sp,48
    16bc:	8082                	ret

00000000000016be <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    16be:	715d                	addi	sp,sp,-80
    16c0:	e486                	sd	ra,72(sp)
    16c2:	e0a2                	sd	s0,64(sp)
    16c4:	0880                	addi	s0,sp,80
    16c6:	87aa                	mv	a5,a0
    16c8:	fcb43023          	sd	a1,-64(s0)
    16cc:	fac43c23          	sd	a2,-72(s0)
    16d0:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
    16d4:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
    16d8:	fe042223          	sw	zero,-28(s0)
    16dc:	a42d                	j	1906 <vprintf+0x248>
    c = fmt[i] & 0xff;
    16de:	fe442783          	lw	a5,-28(s0)
    16e2:	fc043703          	ld	a4,-64(s0)
    16e6:	97ba                	add	a5,a5,a4
    16e8:	0007c783          	lbu	a5,0(a5)
    16ec:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
    16f0:	fe042783          	lw	a5,-32(s0)
    16f4:	2781                	sext.w	a5,a5
    16f6:	eb9d                	bnez	a5,172c <vprintf+0x6e>
      if(c == '%'){
    16f8:	fdc42783          	lw	a5,-36(s0)
    16fc:	0007871b          	sext.w	a4,a5
    1700:	02500793          	li	a5,37
    1704:	00f71763          	bne	a4,a5,1712 <vprintf+0x54>
        state = '%';
    1708:	02500793          	li	a5,37
    170c:	fef42023          	sw	a5,-32(s0)
    1710:	a2f5                	j	18fc <vprintf+0x23e>
      } else {
        putc(fd, c);
    1712:	fdc42783          	lw	a5,-36(s0)
    1716:	0ff7f713          	zext.b	a4,a5
    171a:	fcc42783          	lw	a5,-52(s0)
    171e:	85ba                	mv	a1,a4
    1720:	853e                	mv	a0,a5
    1722:	00000097          	auipc	ra,0x0
    1726:	dd6080e7          	jalr	-554(ra) # 14f8 <putc>
    172a:	aac9                	j	18fc <vprintf+0x23e>
      }
    } else if(state == '%'){
    172c:	fe042783          	lw	a5,-32(s0)
    1730:	0007871b          	sext.w	a4,a5
    1734:	02500793          	li	a5,37
    1738:	1cf71263          	bne	a4,a5,18fc <vprintf+0x23e>
      if(c == 'd'){
    173c:	fdc42783          	lw	a5,-36(s0)
    1740:	0007871b          	sext.w	a4,a5
    1744:	06400793          	li	a5,100
    1748:	02f71463          	bne	a4,a5,1770 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
    174c:	fb843783          	ld	a5,-72(s0)
    1750:	00878713          	addi	a4,a5,8
    1754:	fae43c23          	sd	a4,-72(s0)
    1758:	4398                	lw	a4,0(a5)
    175a:	fcc42783          	lw	a5,-52(s0)
    175e:	4685                	li	a3,1
    1760:	4629                	li	a2,10
    1762:	85ba                	mv	a1,a4
    1764:	853e                	mv	a0,a5
    1766:	00000097          	auipc	ra,0x0
    176a:	dc8080e7          	jalr	-568(ra) # 152e <printint>
    176e:	a269                	j	18f8 <vprintf+0x23a>
      } else if(c == 'l') {
    1770:	fdc42783          	lw	a5,-36(s0)
    1774:	0007871b          	sext.w	a4,a5
    1778:	06c00793          	li	a5,108
    177c:	02f71663          	bne	a4,a5,17a8 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1780:	fb843783          	ld	a5,-72(s0)
    1784:	00878713          	addi	a4,a5,8
    1788:	fae43c23          	sd	a4,-72(s0)
    178c:	639c                	ld	a5,0(a5)
    178e:	0007871b          	sext.w	a4,a5
    1792:	fcc42783          	lw	a5,-52(s0)
    1796:	4681                	li	a3,0
    1798:	4629                	li	a2,10
    179a:	85ba                	mv	a1,a4
    179c:	853e                	mv	a0,a5
    179e:	00000097          	auipc	ra,0x0
    17a2:	d90080e7          	jalr	-624(ra) # 152e <printint>
    17a6:	aa89                	j	18f8 <vprintf+0x23a>
      } else if(c == 'x') {
    17a8:	fdc42783          	lw	a5,-36(s0)
    17ac:	0007871b          	sext.w	a4,a5
    17b0:	07800793          	li	a5,120
    17b4:	02f71463          	bne	a4,a5,17dc <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
    17b8:	fb843783          	ld	a5,-72(s0)
    17bc:	00878713          	addi	a4,a5,8
    17c0:	fae43c23          	sd	a4,-72(s0)
    17c4:	4398                	lw	a4,0(a5)
    17c6:	fcc42783          	lw	a5,-52(s0)
    17ca:	4681                	li	a3,0
    17cc:	4641                	li	a2,16
    17ce:	85ba                	mv	a1,a4
    17d0:	853e                	mv	a0,a5
    17d2:	00000097          	auipc	ra,0x0
    17d6:	d5c080e7          	jalr	-676(ra) # 152e <printint>
    17da:	aa39                	j	18f8 <vprintf+0x23a>
      } else if(c == 'p') {
    17dc:	fdc42783          	lw	a5,-36(s0)
    17e0:	0007871b          	sext.w	a4,a5
    17e4:	07000793          	li	a5,112
    17e8:	02f71263          	bne	a4,a5,180c <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
    17ec:	fb843783          	ld	a5,-72(s0)
    17f0:	00878713          	addi	a4,a5,8
    17f4:	fae43c23          	sd	a4,-72(s0)
    17f8:	6398                	ld	a4,0(a5)
    17fa:	fcc42783          	lw	a5,-52(s0)
    17fe:	85ba                	mv	a1,a4
    1800:	853e                	mv	a0,a5
    1802:	00000097          	auipc	ra,0x0
    1806:	e32080e7          	jalr	-462(ra) # 1634 <printptr>
    180a:	a0fd                	j	18f8 <vprintf+0x23a>
      } else if(c == 's'){
    180c:	fdc42783          	lw	a5,-36(s0)
    1810:	0007871b          	sext.w	a4,a5
    1814:	07300793          	li	a5,115
    1818:	04f71c63          	bne	a4,a5,1870 <vprintf+0x1b2>
        s = va_arg(ap, char*);
    181c:	fb843783          	ld	a5,-72(s0)
    1820:	00878713          	addi	a4,a5,8
    1824:	fae43c23          	sd	a4,-72(s0)
    1828:	639c                	ld	a5,0(a5)
    182a:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
    182e:	fe843783          	ld	a5,-24(s0)
    1832:	eb8d                	bnez	a5,1864 <vprintf+0x1a6>
          s = "(null)";
    1834:	00000797          	auipc	a5,0x0
    1838:	79478793          	addi	a5,a5,1940 # 1fc8 <malloc+0x458>
    183c:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
    1840:	a015                	j	1864 <vprintf+0x1a6>
          putc(fd, *s);
    1842:	fe843783          	ld	a5,-24(s0)
    1846:	0007c703          	lbu	a4,0(a5)
    184a:	fcc42783          	lw	a5,-52(s0)
    184e:	85ba                	mv	a1,a4
    1850:	853e                	mv	a0,a5
    1852:	00000097          	auipc	ra,0x0
    1856:	ca6080e7          	jalr	-858(ra) # 14f8 <putc>
          s++;
    185a:	fe843783          	ld	a5,-24(s0)
    185e:	0785                	addi	a5,a5,1
    1860:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
    1864:	fe843783          	ld	a5,-24(s0)
    1868:	0007c783          	lbu	a5,0(a5)
    186c:	fbf9                	bnez	a5,1842 <vprintf+0x184>
    186e:	a069                	j	18f8 <vprintf+0x23a>
        }
      } else if(c == 'c'){
    1870:	fdc42783          	lw	a5,-36(s0)
    1874:	0007871b          	sext.w	a4,a5
    1878:	06300793          	li	a5,99
    187c:	02f71463          	bne	a4,a5,18a4 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
    1880:	fb843783          	ld	a5,-72(s0)
    1884:	00878713          	addi	a4,a5,8
    1888:	fae43c23          	sd	a4,-72(s0)
    188c:	439c                	lw	a5,0(a5)
    188e:	0ff7f713          	zext.b	a4,a5
    1892:	fcc42783          	lw	a5,-52(s0)
    1896:	85ba                	mv	a1,a4
    1898:	853e                	mv	a0,a5
    189a:	00000097          	auipc	ra,0x0
    189e:	c5e080e7          	jalr	-930(ra) # 14f8 <putc>
    18a2:	a899                	j	18f8 <vprintf+0x23a>
      } else if(c == '%'){
    18a4:	fdc42783          	lw	a5,-36(s0)
    18a8:	0007871b          	sext.w	a4,a5
    18ac:	02500793          	li	a5,37
    18b0:	00f71f63          	bne	a4,a5,18ce <vprintf+0x210>
        putc(fd, c);
    18b4:	fdc42783          	lw	a5,-36(s0)
    18b8:	0ff7f713          	zext.b	a4,a5
    18bc:	fcc42783          	lw	a5,-52(s0)
    18c0:	85ba                	mv	a1,a4
    18c2:	853e                	mv	a0,a5
    18c4:	00000097          	auipc	ra,0x0
    18c8:	c34080e7          	jalr	-972(ra) # 14f8 <putc>
    18cc:	a035                	j	18f8 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    18ce:	fcc42783          	lw	a5,-52(s0)
    18d2:	02500593          	li	a1,37
    18d6:	853e                	mv	a0,a5
    18d8:	00000097          	auipc	ra,0x0
    18dc:	c20080e7          	jalr	-992(ra) # 14f8 <putc>
        putc(fd, c);
    18e0:	fdc42783          	lw	a5,-36(s0)
    18e4:	0ff7f713          	zext.b	a4,a5
    18e8:	fcc42783          	lw	a5,-52(s0)
    18ec:	85ba                	mv	a1,a4
    18ee:	853e                	mv	a0,a5
    18f0:	00000097          	auipc	ra,0x0
    18f4:	c08080e7          	jalr	-1016(ra) # 14f8 <putc>
      }
      state = 0;
    18f8:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
    18fc:	fe442783          	lw	a5,-28(s0)
    1900:	2785                	addiw	a5,a5,1
    1902:	fef42223          	sw	a5,-28(s0)
    1906:	fe442783          	lw	a5,-28(s0)
    190a:	fc043703          	ld	a4,-64(s0)
    190e:	97ba                	add	a5,a5,a4
    1910:	0007c783          	lbu	a5,0(a5)
    1914:	dc0795e3          	bnez	a5,16de <vprintf+0x20>
    }
  }
}
    1918:	0001                	nop
    191a:	0001                	nop
    191c:	60a6                	ld	ra,72(sp)
    191e:	6406                	ld	s0,64(sp)
    1920:	6161                	addi	sp,sp,80
    1922:	8082                	ret

0000000000001924 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1924:	7159                	addi	sp,sp,-112
    1926:	fc06                	sd	ra,56(sp)
    1928:	f822                	sd	s0,48(sp)
    192a:	0080                	addi	s0,sp,64
    192c:	fcb43823          	sd	a1,-48(s0)
    1930:	e010                	sd	a2,0(s0)
    1932:	e414                	sd	a3,8(s0)
    1934:	e818                	sd	a4,16(s0)
    1936:	ec1c                	sd	a5,24(s0)
    1938:	03043023          	sd	a6,32(s0)
    193c:	03143423          	sd	a7,40(s0)
    1940:	87aa                	mv	a5,a0
    1942:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
    1946:	03040793          	addi	a5,s0,48
    194a:	fcf43423          	sd	a5,-56(s0)
    194e:	fc843783          	ld	a5,-56(s0)
    1952:	fd078793          	addi	a5,a5,-48
    1956:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
    195a:	fe843703          	ld	a4,-24(s0)
    195e:	fdc42783          	lw	a5,-36(s0)
    1962:	863a                	mv	a2,a4
    1964:	fd043583          	ld	a1,-48(s0)
    1968:	853e                	mv	a0,a5
    196a:	00000097          	auipc	ra,0x0
    196e:	d54080e7          	jalr	-684(ra) # 16be <vprintf>
}
    1972:	0001                	nop
    1974:	70e2                	ld	ra,56(sp)
    1976:	7442                	ld	s0,48(sp)
    1978:	6165                	addi	sp,sp,112
    197a:	8082                	ret

000000000000197c <printf>:

void
printf(const char *fmt, ...)
{
    197c:	7159                	addi	sp,sp,-112
    197e:	f406                	sd	ra,40(sp)
    1980:	f022                	sd	s0,32(sp)
    1982:	1800                	addi	s0,sp,48
    1984:	fca43c23          	sd	a0,-40(s0)
    1988:	e40c                	sd	a1,8(s0)
    198a:	e810                	sd	a2,16(s0)
    198c:	ec14                	sd	a3,24(s0)
    198e:	f018                	sd	a4,32(s0)
    1990:	f41c                	sd	a5,40(s0)
    1992:	03043823          	sd	a6,48(s0)
    1996:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    199a:	04040793          	addi	a5,s0,64
    199e:	fcf43823          	sd	a5,-48(s0)
    19a2:	fd043783          	ld	a5,-48(s0)
    19a6:	fc878793          	addi	a5,a5,-56
    19aa:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
    19ae:	fe843783          	ld	a5,-24(s0)
    19b2:	863e                	mv	a2,a5
    19b4:	fd843583          	ld	a1,-40(s0)
    19b8:	4505                	li	a0,1
    19ba:	00000097          	auipc	ra,0x0
    19be:	d04080e7          	jalr	-764(ra) # 16be <vprintf>
}
    19c2:	0001                	nop
    19c4:	70a2                	ld	ra,40(sp)
    19c6:	7402                	ld	s0,32(sp)
    19c8:	6165                	addi	sp,sp,112
    19ca:	8082                	ret

00000000000019cc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    19cc:	7179                	addi	sp,sp,-48
    19ce:	f406                	sd	ra,40(sp)
    19d0:	f022                	sd	s0,32(sp)
    19d2:	1800                	addi	s0,sp,48
    19d4:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    19d8:	fd843783          	ld	a5,-40(s0)
    19dc:	17c1                	addi	a5,a5,-16
    19de:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    19e2:	00001797          	auipc	a5,0x1
    19e6:	a4678793          	addi	a5,a5,-1466 # 2428 <freep>
    19ea:	639c                	ld	a5,0(a5)
    19ec:	fef43423          	sd	a5,-24(s0)
    19f0:	a815                	j	1a24 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    19f2:	fe843783          	ld	a5,-24(s0)
    19f6:	639c                	ld	a5,0(a5)
    19f8:	fe843703          	ld	a4,-24(s0)
    19fc:	00f76f63          	bltu	a4,a5,1a1a <free+0x4e>
    1a00:	fe043703          	ld	a4,-32(s0)
    1a04:	fe843783          	ld	a5,-24(s0)
    1a08:	02e7eb63          	bltu	a5,a4,1a3e <free+0x72>
    1a0c:	fe843783          	ld	a5,-24(s0)
    1a10:	639c                	ld	a5,0(a5)
    1a12:	fe043703          	ld	a4,-32(s0)
    1a16:	02f76463          	bltu	a4,a5,1a3e <free+0x72>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1a1a:	fe843783          	ld	a5,-24(s0)
    1a1e:	639c                	ld	a5,0(a5)
    1a20:	fef43423          	sd	a5,-24(s0)
    1a24:	fe043703          	ld	a4,-32(s0)
    1a28:	fe843783          	ld	a5,-24(s0)
    1a2c:	fce7f3e3          	bgeu	a5,a4,19f2 <free+0x26>
    1a30:	fe843783          	ld	a5,-24(s0)
    1a34:	639c                	ld	a5,0(a5)
    1a36:	fe043703          	ld	a4,-32(s0)
    1a3a:	faf77ce3          	bgeu	a4,a5,19f2 <free+0x26>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1a3e:	fe043783          	ld	a5,-32(s0)
    1a42:	479c                	lw	a5,8(a5)
    1a44:	1782                	slli	a5,a5,0x20
    1a46:	9381                	srli	a5,a5,0x20
    1a48:	0792                	slli	a5,a5,0x4
    1a4a:	fe043703          	ld	a4,-32(s0)
    1a4e:	973e                	add	a4,a4,a5
    1a50:	fe843783          	ld	a5,-24(s0)
    1a54:	639c                	ld	a5,0(a5)
    1a56:	02f71763          	bne	a4,a5,1a84 <free+0xb8>
    bp->s.size += p->s.ptr->s.size;
    1a5a:	fe043783          	ld	a5,-32(s0)
    1a5e:	4798                	lw	a4,8(a5)
    1a60:	fe843783          	ld	a5,-24(s0)
    1a64:	639c                	ld	a5,0(a5)
    1a66:	479c                	lw	a5,8(a5)
    1a68:	9fb9                	addw	a5,a5,a4
    1a6a:	0007871b          	sext.w	a4,a5
    1a6e:	fe043783          	ld	a5,-32(s0)
    1a72:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
    1a74:	fe843783          	ld	a5,-24(s0)
    1a78:	639c                	ld	a5,0(a5)
    1a7a:	6398                	ld	a4,0(a5)
    1a7c:	fe043783          	ld	a5,-32(s0)
    1a80:	e398                	sd	a4,0(a5)
    1a82:	a039                	j	1a90 <free+0xc4>
  } else
    bp->s.ptr = p->s.ptr;
    1a84:	fe843783          	ld	a5,-24(s0)
    1a88:	6398                	ld	a4,0(a5)
    1a8a:	fe043783          	ld	a5,-32(s0)
    1a8e:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
    1a90:	fe843783          	ld	a5,-24(s0)
    1a94:	479c                	lw	a5,8(a5)
    1a96:	1782                	slli	a5,a5,0x20
    1a98:	9381                	srli	a5,a5,0x20
    1a9a:	0792                	slli	a5,a5,0x4
    1a9c:	fe843703          	ld	a4,-24(s0)
    1aa0:	97ba                	add	a5,a5,a4
    1aa2:	fe043703          	ld	a4,-32(s0)
    1aa6:	02f71563          	bne	a4,a5,1ad0 <free+0x104>
    p->s.size += bp->s.size;
    1aaa:	fe843783          	ld	a5,-24(s0)
    1aae:	4798                	lw	a4,8(a5)
    1ab0:	fe043783          	ld	a5,-32(s0)
    1ab4:	479c                	lw	a5,8(a5)
    1ab6:	9fb9                	addw	a5,a5,a4
    1ab8:	0007871b          	sext.w	a4,a5
    1abc:	fe843783          	ld	a5,-24(s0)
    1ac0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1ac2:	fe043783          	ld	a5,-32(s0)
    1ac6:	6398                	ld	a4,0(a5)
    1ac8:	fe843783          	ld	a5,-24(s0)
    1acc:	e398                	sd	a4,0(a5)
    1ace:	a031                	j	1ada <free+0x10e>
  } else
    p->s.ptr = bp;
    1ad0:	fe843783          	ld	a5,-24(s0)
    1ad4:	fe043703          	ld	a4,-32(s0)
    1ad8:	e398                	sd	a4,0(a5)
  freep = p;
    1ada:	00001797          	auipc	a5,0x1
    1ade:	94e78793          	addi	a5,a5,-1714 # 2428 <freep>
    1ae2:	fe843703          	ld	a4,-24(s0)
    1ae6:	e398                	sd	a4,0(a5)
}
    1ae8:	0001                	nop
    1aea:	70a2                	ld	ra,40(sp)
    1aec:	7402                	ld	s0,32(sp)
    1aee:	6145                	addi	sp,sp,48
    1af0:	8082                	ret

0000000000001af2 <morecore>:

static Header*
morecore(uint nu)
{
    1af2:	7179                	addi	sp,sp,-48
    1af4:	f406                	sd	ra,40(sp)
    1af6:	f022                	sd	s0,32(sp)
    1af8:	1800                	addi	s0,sp,48
    1afa:	87aa                	mv	a5,a0
    1afc:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
    1b00:	fdc42783          	lw	a5,-36(s0)
    1b04:	0007871b          	sext.w	a4,a5
    1b08:	6785                	lui	a5,0x1
    1b0a:	00f77563          	bgeu	a4,a5,1b14 <morecore+0x22>
    nu = 4096;
    1b0e:	6785                	lui	a5,0x1
    1b10:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
    1b14:	fdc42783          	lw	a5,-36(s0)
    1b18:	0047979b          	slliw	a5,a5,0x4
    1b1c:	2781                	sext.w	a5,a5
    1b1e:	853e                	mv	a0,a5
    1b20:	00000097          	auipc	ra,0x0
    1b24:	9b8080e7          	jalr	-1608(ra) # 14d8 <sbrk>
    1b28:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
    1b2c:	fe843703          	ld	a4,-24(s0)
    1b30:	57fd                	li	a5,-1
    1b32:	00f71463          	bne	a4,a5,1b3a <morecore+0x48>
    return 0;
    1b36:	4781                	li	a5,0
    1b38:	a03d                	j	1b66 <morecore+0x74>
  hp = (Header*)p;
    1b3a:	fe843783          	ld	a5,-24(s0)
    1b3e:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
    1b42:	fe043783          	ld	a5,-32(s0)
    1b46:	fdc42703          	lw	a4,-36(s0)
    1b4a:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
    1b4c:	fe043783          	ld	a5,-32(s0)
    1b50:	07c1                	addi	a5,a5,16 # 1010 <strcmp+0x22>
    1b52:	853e                	mv	a0,a5
    1b54:	00000097          	auipc	ra,0x0
    1b58:	e78080e7          	jalr	-392(ra) # 19cc <free>
  return freep;
    1b5c:	00001797          	auipc	a5,0x1
    1b60:	8cc78793          	addi	a5,a5,-1844 # 2428 <freep>
    1b64:	639c                	ld	a5,0(a5)
}
    1b66:	853e                	mv	a0,a5
    1b68:	70a2                	ld	ra,40(sp)
    1b6a:	7402                	ld	s0,32(sp)
    1b6c:	6145                	addi	sp,sp,48
    1b6e:	8082                	ret

0000000000001b70 <malloc>:

void*
malloc(uint nbytes)
{
    1b70:	7139                	addi	sp,sp,-64
    1b72:	fc06                	sd	ra,56(sp)
    1b74:	f822                	sd	s0,48(sp)
    1b76:	0080                	addi	s0,sp,64
    1b78:	87aa                	mv	a5,a0
    1b7a:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1b7e:	fcc46783          	lwu	a5,-52(s0)
    1b82:	07bd                	addi	a5,a5,15
    1b84:	8391                	srli	a5,a5,0x4
    1b86:	2781                	sext.w	a5,a5
    1b88:	2785                	addiw	a5,a5,1
    1b8a:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
    1b8e:	00001797          	auipc	a5,0x1
    1b92:	89a78793          	addi	a5,a5,-1894 # 2428 <freep>
    1b96:	639c                	ld	a5,0(a5)
    1b98:	fef43023          	sd	a5,-32(s0)
    1b9c:	fe043783          	ld	a5,-32(s0)
    1ba0:	ef95                	bnez	a5,1bdc <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
    1ba2:	00001797          	auipc	a5,0x1
    1ba6:	87678793          	addi	a5,a5,-1930 # 2418 <base>
    1baa:	fef43023          	sd	a5,-32(s0)
    1bae:	00001797          	auipc	a5,0x1
    1bb2:	87a78793          	addi	a5,a5,-1926 # 2428 <freep>
    1bb6:	fe043703          	ld	a4,-32(s0)
    1bba:	e398                	sd	a4,0(a5)
    1bbc:	00001797          	auipc	a5,0x1
    1bc0:	86c78793          	addi	a5,a5,-1940 # 2428 <freep>
    1bc4:	6398                	ld	a4,0(a5)
    1bc6:	00001797          	auipc	a5,0x1
    1bca:	85278793          	addi	a5,a5,-1966 # 2418 <base>
    1bce:	e398                	sd	a4,0(a5)
    base.s.size = 0;
    1bd0:	00001797          	auipc	a5,0x1
    1bd4:	84878793          	addi	a5,a5,-1976 # 2418 <base>
    1bd8:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1bdc:	fe043783          	ld	a5,-32(s0)
    1be0:	639c                	ld	a5,0(a5)
    1be2:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
    1be6:	fe843783          	ld	a5,-24(s0)
    1bea:	479c                	lw	a5,8(a5)
    1bec:	fdc42703          	lw	a4,-36(s0)
    1bf0:	2701                	sext.w	a4,a4
    1bf2:	06e7e763          	bltu	a5,a4,1c60 <malloc+0xf0>
      if(p->s.size == nunits)
    1bf6:	fe843783          	ld	a5,-24(s0)
    1bfa:	479c                	lw	a5,8(a5)
    1bfc:	fdc42703          	lw	a4,-36(s0)
    1c00:	2701                	sext.w	a4,a4
    1c02:	00f71963          	bne	a4,a5,1c14 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
    1c06:	fe843783          	ld	a5,-24(s0)
    1c0a:	6398                	ld	a4,0(a5)
    1c0c:	fe043783          	ld	a5,-32(s0)
    1c10:	e398                	sd	a4,0(a5)
    1c12:	a825                	j	1c4a <malloc+0xda>
      else {
        p->s.size -= nunits;
    1c14:	fe843783          	ld	a5,-24(s0)
    1c18:	479c                	lw	a5,8(a5)
    1c1a:	fdc42703          	lw	a4,-36(s0)
    1c1e:	9f99                	subw	a5,a5,a4
    1c20:	0007871b          	sext.w	a4,a5
    1c24:	fe843783          	ld	a5,-24(s0)
    1c28:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1c2a:	fe843783          	ld	a5,-24(s0)
    1c2e:	479c                	lw	a5,8(a5)
    1c30:	1782                	slli	a5,a5,0x20
    1c32:	9381                	srli	a5,a5,0x20
    1c34:	0792                	slli	a5,a5,0x4
    1c36:	fe843703          	ld	a4,-24(s0)
    1c3a:	97ba                	add	a5,a5,a4
    1c3c:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
    1c40:	fe843783          	ld	a5,-24(s0)
    1c44:	fdc42703          	lw	a4,-36(s0)
    1c48:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
    1c4a:	00000797          	auipc	a5,0x0
    1c4e:	7de78793          	addi	a5,a5,2014 # 2428 <freep>
    1c52:	fe043703          	ld	a4,-32(s0)
    1c56:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
    1c58:	fe843783          	ld	a5,-24(s0)
    1c5c:	07c1                	addi	a5,a5,16
    1c5e:	a091                	j	1ca2 <malloc+0x132>
    }
    if(p == freep)
    1c60:	00000797          	auipc	a5,0x0
    1c64:	7c878793          	addi	a5,a5,1992 # 2428 <freep>
    1c68:	639c                	ld	a5,0(a5)
    1c6a:	fe843703          	ld	a4,-24(s0)
    1c6e:	02f71063          	bne	a4,a5,1c8e <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
    1c72:	fdc42783          	lw	a5,-36(s0)
    1c76:	853e                	mv	a0,a5
    1c78:	00000097          	auipc	ra,0x0
    1c7c:	e7a080e7          	jalr	-390(ra) # 1af2 <morecore>
    1c80:	fea43423          	sd	a0,-24(s0)
    1c84:	fe843783          	ld	a5,-24(s0)
    1c88:	e399                	bnez	a5,1c8e <malloc+0x11e>
        return 0;
    1c8a:	4781                	li	a5,0
    1c8c:	a819                	j	1ca2 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1c8e:	fe843783          	ld	a5,-24(s0)
    1c92:	fef43023          	sd	a5,-32(s0)
    1c96:	fe843783          	ld	a5,-24(s0)
    1c9a:	639c                	ld	a5,0(a5)
    1c9c:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
    1ca0:	b799                	j	1be6 <malloc+0x76>
  }
}
    1ca2:	853e                	mv	a0,a5
    1ca4:	70e2                	ld	ra,56(sp)
    1ca6:	7442                	ld	s0,48(sp)
    1ca8:	6121                	addi	sp,sp,64
    1caa:	8082                	ret
