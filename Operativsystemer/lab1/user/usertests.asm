
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <r_sp>:
  return (x & SSTATUS_SIE) != 0;
}

static inline uint64
r_sp()
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	1000                	addi	s0,sp,32
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
       8:	878a                	mv	a5,sp
       a:	fef43423          	sd	a5,-24(s0)
  return x;
       e:	fe843783          	ld	a5,-24(s0)
}
      12:	853e                	mv	a0,a5
      14:	60e2                	ld	ra,24(sp)
      16:	6442                	ld	s0,16(sp)
      18:	6105                	addi	sp,sp,32
      1a:	8082                	ret

000000000000001c <copyin>:

// what if you pass ridiculous pointers to system calls
// that read user memory with copyin?
void
copyin(char *s)
{
      1c:	715d                	addi	sp,sp,-80
      1e:	e486                	sd	ra,72(sp)
      20:	e0a2                	sd	s0,64(sp)
      22:	0880                	addi	s0,sp,80
      24:	faa43c23          	sd	a0,-72(s0)
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
      28:	4785                	li	a5,1
      2a:	07fe                	slli	a5,a5,0x1f
      2c:	fcf43423          	sd	a5,-56(s0)
      30:	57fd                	li	a5,-1
      32:	fcf43823          	sd	a5,-48(s0)

  for(int ai = 0; ai < 2; ai++){
      36:	fe042623          	sw	zero,-20(s0)
      3a:	aa79                	j	1d8 <copyin+0x1bc>
    uint64 addr = addrs[ai];
      3c:	fec42703          	lw	a4,-20(s0)
      40:	fc840793          	addi	a5,s0,-56
      44:	070e                	slli	a4,a4,0x3
      46:	97ba                	add	a5,a5,a4
      48:	639c                	ld	a5,0(a5)
      4a:	fef43023          	sd	a5,-32(s0)
    
    int fd = open("copyin1", O_CREATE|O_WRONLY);
      4e:	20100593          	li	a1,513
      52:	00008517          	auipc	a0,0x8
      56:	2de50513          	addi	a0,a0,734 # 8330 <malloc+0x144>
      5a:	00008097          	auipc	ra,0x8
      5e:	ab2080e7          	jalr	-1358(ra) # 7b0c <open>
      62:	87aa                	mv	a5,a0
      64:	fcf42e23          	sw	a5,-36(s0)
    if(fd < 0){
      68:	fdc42783          	lw	a5,-36(s0)
      6c:	2781                	sext.w	a5,a5
      6e:	0007df63          	bgez	a5,8c <copyin+0x70>
      printf("open(copyin1) failed\n");
      72:	00008517          	auipc	a0,0x8
      76:	2c650513          	addi	a0,a0,710 # 8338 <malloc+0x14c>
      7a:	00008097          	auipc	ra,0x8
      7e:	f7e080e7          	jalr	-130(ra) # 7ff8 <printf>
      exit(1);
      82:	4505                	li	a0,1
      84:	00008097          	auipc	ra,0x8
      88:	a48080e7          	jalr	-1464(ra) # 7acc <exit>
    }
    int n = write(fd, (void*)addr, 8192);
      8c:	fe043703          	ld	a4,-32(s0)
      90:	fdc42783          	lw	a5,-36(s0)
      94:	6609                	lui	a2,0x2
      96:	85ba                	mv	a1,a4
      98:	853e                	mv	a0,a5
      9a:	00008097          	auipc	ra,0x8
      9e:	a52080e7          	jalr	-1454(ra) # 7aec <write>
      a2:	87aa                	mv	a5,a0
      a4:	fcf42c23          	sw	a5,-40(s0)
    if(n >= 0){
      a8:	fd842783          	lw	a5,-40(s0)
      ac:	2781                	sext.w	a5,a5
      ae:	0207c463          	bltz	a5,d6 <copyin+0xba>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
      b2:	fd842783          	lw	a5,-40(s0)
      b6:	863e                	mv	a2,a5
      b8:	fe043583          	ld	a1,-32(s0)
      bc:	00008517          	auipc	a0,0x8
      c0:	29450513          	addi	a0,a0,660 # 8350 <malloc+0x164>
      c4:	00008097          	auipc	ra,0x8
      c8:	f34080e7          	jalr	-204(ra) # 7ff8 <printf>
      exit(1);
      cc:	4505                	li	a0,1
      ce:	00008097          	auipc	ra,0x8
      d2:	9fe080e7          	jalr	-1538(ra) # 7acc <exit>
    }
    close(fd);
      d6:	fdc42783          	lw	a5,-36(s0)
      da:	853e                	mv	a0,a5
      dc:	00008097          	auipc	ra,0x8
      e0:	a18080e7          	jalr	-1512(ra) # 7af4 <close>
    unlink("copyin1");
      e4:	00008517          	auipc	a0,0x8
      e8:	24c50513          	addi	a0,a0,588 # 8330 <malloc+0x144>
      ec:	00008097          	auipc	ra,0x8
      f0:	a30080e7          	jalr	-1488(ra) # 7b1c <unlink>
    
    n = write(1, (char*)addr, 8192);
      f4:	fe043783          	ld	a5,-32(s0)
      f8:	6609                	lui	a2,0x2
      fa:	85be                	mv	a1,a5
      fc:	4505                	li	a0,1
      fe:	00008097          	auipc	ra,0x8
     102:	9ee080e7          	jalr	-1554(ra) # 7aec <write>
     106:	87aa                	mv	a5,a0
     108:	fcf42c23          	sw	a5,-40(s0)
    if(n > 0){
     10c:	fd842783          	lw	a5,-40(s0)
     110:	2781                	sext.w	a5,a5
     112:	02f05463          	blez	a5,13a <copyin+0x11e>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     116:	fd842783          	lw	a5,-40(s0)
     11a:	863e                	mv	a2,a5
     11c:	fe043583          	ld	a1,-32(s0)
     120:	00008517          	auipc	a0,0x8
     124:	26050513          	addi	a0,a0,608 # 8380 <malloc+0x194>
     128:	00008097          	auipc	ra,0x8
     12c:	ed0080e7          	jalr	-304(ra) # 7ff8 <printf>
      exit(1);
     130:	4505                	li	a0,1
     132:	00008097          	auipc	ra,0x8
     136:	99a080e7          	jalr	-1638(ra) # 7acc <exit>
    }
    
    int fds[2];
    if(pipe(fds) < 0){
     13a:	fc040793          	addi	a5,s0,-64
     13e:	853e                	mv	a0,a5
     140:	00008097          	auipc	ra,0x8
     144:	99c080e7          	jalr	-1636(ra) # 7adc <pipe>
     148:	87aa                	mv	a5,a0
     14a:	0007df63          	bgez	a5,168 <copyin+0x14c>
      printf("pipe() failed\n");
     14e:	00008517          	auipc	a0,0x8
     152:	26250513          	addi	a0,a0,610 # 83b0 <malloc+0x1c4>
     156:	00008097          	auipc	ra,0x8
     15a:	ea2080e7          	jalr	-350(ra) # 7ff8 <printf>
      exit(1);
     15e:	4505                	li	a0,1
     160:	00008097          	auipc	ra,0x8
     164:	96c080e7          	jalr	-1684(ra) # 7acc <exit>
    }
    n = write(fds[1], (char*)addr, 8192);
     168:	fc442783          	lw	a5,-60(s0)
     16c:	fe043703          	ld	a4,-32(s0)
     170:	6609                	lui	a2,0x2
     172:	85ba                	mv	a1,a4
     174:	853e                	mv	a0,a5
     176:	00008097          	auipc	ra,0x8
     17a:	976080e7          	jalr	-1674(ra) # 7aec <write>
     17e:	87aa                	mv	a5,a0
     180:	fcf42c23          	sw	a5,-40(s0)
    if(n > 0){
     184:	fd842783          	lw	a5,-40(s0)
     188:	2781                	sext.w	a5,a5
     18a:	02f05463          	blez	a5,1b2 <copyin+0x196>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     18e:	fd842783          	lw	a5,-40(s0)
     192:	863e                	mv	a2,a5
     194:	fe043583          	ld	a1,-32(s0)
     198:	00008517          	auipc	a0,0x8
     19c:	22850513          	addi	a0,a0,552 # 83c0 <malloc+0x1d4>
     1a0:	00008097          	auipc	ra,0x8
     1a4:	e58080e7          	jalr	-424(ra) # 7ff8 <printf>
      exit(1);
     1a8:	4505                	li	a0,1
     1aa:	00008097          	auipc	ra,0x8
     1ae:	922080e7          	jalr	-1758(ra) # 7acc <exit>
    }
    close(fds[0]);
     1b2:	fc042783          	lw	a5,-64(s0)
     1b6:	853e                	mv	a0,a5
     1b8:	00008097          	auipc	ra,0x8
     1bc:	93c080e7          	jalr	-1732(ra) # 7af4 <close>
    close(fds[1]);
     1c0:	fc442783          	lw	a5,-60(s0)
     1c4:	853e                	mv	a0,a5
     1c6:	00008097          	auipc	ra,0x8
     1ca:	92e080e7          	jalr	-1746(ra) # 7af4 <close>
  for(int ai = 0; ai < 2; ai++){
     1ce:	fec42783          	lw	a5,-20(s0)
     1d2:	2785                	addiw	a5,a5,1
     1d4:	fef42623          	sw	a5,-20(s0)
     1d8:	fec42783          	lw	a5,-20(s0)
     1dc:	0007871b          	sext.w	a4,a5
     1e0:	4785                	li	a5,1
     1e2:	e4e7dde3          	bge	a5,a4,3c <copyin+0x20>
  }
}
     1e6:	0001                	nop
     1e8:	0001                	nop
     1ea:	60a6                	ld	ra,72(sp)
     1ec:	6406                	ld	s0,64(sp)
     1ee:	6161                	addi	sp,sp,80
     1f0:	8082                	ret

00000000000001f2 <copyout>:

// what if you pass ridiculous pointers to system calls
// that write user memory with copyout?
void
copyout(char *s)
{
     1f2:	715d                	addi	sp,sp,-80
     1f4:	e486                	sd	ra,72(sp)
     1f6:	e0a2                	sd	s0,64(sp)
     1f8:	0880                	addi	s0,sp,80
     1fa:	faa43c23          	sd	a0,-72(s0)
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     1fe:	4785                	li	a5,1
     200:	07fe                	slli	a5,a5,0x1f
     202:	fcf43423          	sd	a5,-56(s0)
     206:	57fd                	li	a5,-1
     208:	fcf43823          	sd	a5,-48(s0)

  for(int ai = 0; ai < 2; ai++){
     20c:	fe042623          	sw	zero,-20(s0)
     210:	a271                	j	39c <copyout+0x1aa>
    uint64 addr = addrs[ai];
     212:	fec42703          	lw	a4,-20(s0)
     216:	fc840793          	addi	a5,s0,-56
     21a:	070e                	slli	a4,a4,0x3
     21c:	97ba                	add	a5,a5,a4
     21e:	639c                	ld	a5,0(a5)
     220:	fef43023          	sd	a5,-32(s0)

    int fd = open("README", 0);
     224:	4581                	li	a1,0
     226:	00008517          	auipc	a0,0x8
     22a:	1ca50513          	addi	a0,a0,458 # 83f0 <malloc+0x204>
     22e:	00008097          	auipc	ra,0x8
     232:	8de080e7          	jalr	-1826(ra) # 7b0c <open>
     236:	87aa                	mv	a5,a0
     238:	fcf42e23          	sw	a5,-36(s0)
    if(fd < 0){
     23c:	fdc42783          	lw	a5,-36(s0)
     240:	2781                	sext.w	a5,a5
     242:	0007df63          	bgez	a5,260 <copyout+0x6e>
      printf("open(README) failed\n");
     246:	00008517          	auipc	a0,0x8
     24a:	1b250513          	addi	a0,a0,434 # 83f8 <malloc+0x20c>
     24e:	00008097          	auipc	ra,0x8
     252:	daa080e7          	jalr	-598(ra) # 7ff8 <printf>
      exit(1);
     256:	4505                	li	a0,1
     258:	00008097          	auipc	ra,0x8
     25c:	874080e7          	jalr	-1932(ra) # 7acc <exit>
    }
    int n = read(fd, (void*)addr, 8192);
     260:	fe043703          	ld	a4,-32(s0)
     264:	fdc42783          	lw	a5,-36(s0)
     268:	6609                	lui	a2,0x2
     26a:	85ba                	mv	a1,a4
     26c:	853e                	mv	a0,a5
     26e:	00008097          	auipc	ra,0x8
     272:	876080e7          	jalr	-1930(ra) # 7ae4 <read>
     276:	87aa                	mv	a5,a0
     278:	fcf42c23          	sw	a5,-40(s0)
    if(n > 0){
     27c:	fd842783          	lw	a5,-40(s0)
     280:	2781                	sext.w	a5,a5
     282:	02f05463          	blez	a5,2aa <copyout+0xb8>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     286:	fd842783          	lw	a5,-40(s0)
     28a:	863e                	mv	a2,a5
     28c:	fe043583          	ld	a1,-32(s0)
     290:	00008517          	auipc	a0,0x8
     294:	18050513          	addi	a0,a0,384 # 8410 <malloc+0x224>
     298:	00008097          	auipc	ra,0x8
     29c:	d60080e7          	jalr	-672(ra) # 7ff8 <printf>
      exit(1);
     2a0:	4505                	li	a0,1
     2a2:	00008097          	auipc	ra,0x8
     2a6:	82a080e7          	jalr	-2006(ra) # 7acc <exit>
    }
    close(fd);
     2aa:	fdc42783          	lw	a5,-36(s0)
     2ae:	853e                	mv	a0,a5
     2b0:	00008097          	auipc	ra,0x8
     2b4:	844080e7          	jalr	-1980(ra) # 7af4 <close>

    int fds[2];
    if(pipe(fds) < 0){
     2b8:	fc040793          	addi	a5,s0,-64
     2bc:	853e                	mv	a0,a5
     2be:	00008097          	auipc	ra,0x8
     2c2:	81e080e7          	jalr	-2018(ra) # 7adc <pipe>
     2c6:	87aa                	mv	a5,a0
     2c8:	0007df63          	bgez	a5,2e6 <copyout+0xf4>
      printf("pipe() failed\n");
     2cc:	00008517          	auipc	a0,0x8
     2d0:	0e450513          	addi	a0,a0,228 # 83b0 <malloc+0x1c4>
     2d4:	00008097          	auipc	ra,0x8
     2d8:	d24080e7          	jalr	-732(ra) # 7ff8 <printf>
      exit(1);
     2dc:	4505                	li	a0,1
     2de:	00007097          	auipc	ra,0x7
     2e2:	7ee080e7          	jalr	2030(ra) # 7acc <exit>
    }
    n = write(fds[1], "x", 1);
     2e6:	fc442783          	lw	a5,-60(s0)
     2ea:	4605                	li	a2,1
     2ec:	00008597          	auipc	a1,0x8
     2f0:	15458593          	addi	a1,a1,340 # 8440 <malloc+0x254>
     2f4:	853e                	mv	a0,a5
     2f6:	00007097          	auipc	ra,0x7
     2fa:	7f6080e7          	jalr	2038(ra) # 7aec <write>
     2fe:	87aa                	mv	a5,a0
     300:	fcf42c23          	sw	a5,-40(s0)
    if(n != 1){
     304:	fd842783          	lw	a5,-40(s0)
     308:	0007871b          	sext.w	a4,a5
     30c:	4785                	li	a5,1
     30e:	00f70f63          	beq	a4,a5,32c <copyout+0x13a>
      printf("pipe write failed\n");
     312:	00008517          	auipc	a0,0x8
     316:	13650513          	addi	a0,a0,310 # 8448 <malloc+0x25c>
     31a:	00008097          	auipc	ra,0x8
     31e:	cde080e7          	jalr	-802(ra) # 7ff8 <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00007097          	auipc	ra,0x7
     328:	7a8080e7          	jalr	1960(ra) # 7acc <exit>
    }
    n = read(fds[0], (void*)addr, 8192);
     32c:	fc042783          	lw	a5,-64(s0)
     330:	fe043703          	ld	a4,-32(s0)
     334:	6609                	lui	a2,0x2
     336:	85ba                	mv	a1,a4
     338:	853e                	mv	a0,a5
     33a:	00007097          	auipc	ra,0x7
     33e:	7aa080e7          	jalr	1962(ra) # 7ae4 <read>
     342:	87aa                	mv	a5,a0
     344:	fcf42c23          	sw	a5,-40(s0)
    if(n > 0){
     348:	fd842783          	lw	a5,-40(s0)
     34c:	2781                	sext.w	a5,a5
     34e:	02f05463          	blez	a5,376 <copyout+0x184>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     352:	fd842783          	lw	a5,-40(s0)
     356:	863e                	mv	a2,a5
     358:	fe043583          	ld	a1,-32(s0)
     35c:	00008517          	auipc	a0,0x8
     360:	10450513          	addi	a0,a0,260 # 8460 <malloc+0x274>
     364:	00008097          	auipc	ra,0x8
     368:	c94080e7          	jalr	-876(ra) # 7ff8 <printf>
      exit(1);
     36c:	4505                	li	a0,1
     36e:	00007097          	auipc	ra,0x7
     372:	75e080e7          	jalr	1886(ra) # 7acc <exit>
    }
    close(fds[0]);
     376:	fc042783          	lw	a5,-64(s0)
     37a:	853e                	mv	a0,a5
     37c:	00007097          	auipc	ra,0x7
     380:	778080e7          	jalr	1912(ra) # 7af4 <close>
    close(fds[1]);
     384:	fc442783          	lw	a5,-60(s0)
     388:	853e                	mv	a0,a5
     38a:	00007097          	auipc	ra,0x7
     38e:	76a080e7          	jalr	1898(ra) # 7af4 <close>
  for(int ai = 0; ai < 2; ai++){
     392:	fec42783          	lw	a5,-20(s0)
     396:	2785                	addiw	a5,a5,1
     398:	fef42623          	sw	a5,-20(s0)
     39c:	fec42783          	lw	a5,-20(s0)
     3a0:	0007871b          	sext.w	a4,a5
     3a4:	4785                	li	a5,1
     3a6:	e6e7d6e3          	bge	a5,a4,212 <copyout+0x20>
  }
}
     3aa:	0001                	nop
     3ac:	0001                	nop
     3ae:	60a6                	ld	ra,72(sp)
     3b0:	6406                	ld	s0,64(sp)
     3b2:	6161                	addi	sp,sp,80
     3b4:	8082                	ret

00000000000003b6 <copyinstr1>:

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
     3b6:	715d                	addi	sp,sp,-80
     3b8:	e486                	sd	ra,72(sp)
     3ba:	e0a2                	sd	s0,64(sp)
     3bc:	0880                	addi	s0,sp,80
     3be:	faa43c23          	sd	a0,-72(s0)
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     3c2:	4785                	li	a5,1
     3c4:	07fe                	slli	a5,a5,0x1f
     3c6:	fcf43423          	sd	a5,-56(s0)
     3ca:	57fd                	li	a5,-1
     3cc:	fcf43823          	sd	a5,-48(s0)

  for(int ai = 0; ai < 2; ai++){
     3d0:	fe042623          	sw	zero,-20(s0)
     3d4:	a095                	j	438 <copyinstr1+0x82>
    uint64 addr = addrs[ai];
     3d6:	fec42703          	lw	a4,-20(s0)
     3da:	fc840793          	addi	a5,s0,-56
     3de:	070e                	slli	a4,a4,0x3
     3e0:	97ba                	add	a5,a5,a4
     3e2:	639c                	ld	a5,0(a5)
     3e4:	fef43023          	sd	a5,-32(s0)

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
     3e8:	fe043783          	ld	a5,-32(s0)
     3ec:	20100593          	li	a1,513
     3f0:	853e                	mv	a0,a5
     3f2:	00007097          	auipc	ra,0x7
     3f6:	71a080e7          	jalr	1818(ra) # 7b0c <open>
     3fa:	87aa                	mv	a5,a0
     3fc:	fcf42e23          	sw	a5,-36(s0)
    if(fd >= 0){
     400:	fdc42783          	lw	a5,-36(s0)
     404:	2781                	sext.w	a5,a5
     406:	0207c463          	bltz	a5,42e <copyinstr1+0x78>
      printf("open(%p) returned %d, not -1\n", addr, fd);
     40a:	fdc42783          	lw	a5,-36(s0)
     40e:	863e                	mv	a2,a5
     410:	fe043583          	ld	a1,-32(s0)
     414:	00008517          	auipc	a0,0x8
     418:	07c50513          	addi	a0,a0,124 # 8490 <malloc+0x2a4>
     41c:	00008097          	auipc	ra,0x8
     420:	bdc080e7          	jalr	-1060(ra) # 7ff8 <printf>
      exit(1);
     424:	4505                	li	a0,1
     426:	00007097          	auipc	ra,0x7
     42a:	6a6080e7          	jalr	1702(ra) # 7acc <exit>
  for(int ai = 0; ai < 2; ai++){
     42e:	fec42783          	lw	a5,-20(s0)
     432:	2785                	addiw	a5,a5,1
     434:	fef42623          	sw	a5,-20(s0)
     438:	fec42783          	lw	a5,-20(s0)
     43c:	0007871b          	sext.w	a4,a5
     440:	4785                	li	a5,1
     442:	f8e7dae3          	bge	a5,a4,3d6 <copyinstr1+0x20>
    }
  }
}
     446:	0001                	nop
     448:	0001                	nop
     44a:	60a6                	ld	ra,72(sp)
     44c:	6406                	ld	s0,64(sp)
     44e:	6161                	addi	sp,sp,80
     450:	8082                	ret

0000000000000452 <copyinstr2>:
// what if a string system call argument is exactly the size
// of the kernel buffer it is copied into, so that the null
// would fall just beyond the end of the kernel buffer?
void
copyinstr2(char *s)
{
     452:	7151                	addi	sp,sp,-240
     454:	f586                	sd	ra,232(sp)
     456:	f1a2                	sd	s0,224(sp)
     458:	1980                	addi	s0,sp,240
     45a:	f0a43c23          	sd	a0,-232(s0)
  char b[MAXPATH+1];

  for(int i = 0; i < MAXPATH; i++)
     45e:	fe042623          	sw	zero,-20(s0)
     462:	a831                	j	47e <copyinstr2+0x2c>
    b[i] = 'x';
     464:	fec42783          	lw	a5,-20(s0)
     468:	17c1                	addi	a5,a5,-16
     46a:	97a2                	add	a5,a5,s0
     46c:	07800713          	li	a4,120
     470:	f6e78423          	sb	a4,-152(a5)
  for(int i = 0; i < MAXPATH; i++)
     474:	fec42783          	lw	a5,-20(s0)
     478:	2785                	addiw	a5,a5,1
     47a:	fef42623          	sw	a5,-20(s0)
     47e:	fec42783          	lw	a5,-20(s0)
     482:	0007871b          	sext.w	a4,a5
     486:	07f00793          	li	a5,127
     48a:	fce7dde3          	bge	a5,a4,464 <copyinstr2+0x12>
  b[MAXPATH] = '\0';
     48e:	fc040c23          	sb	zero,-40(s0)
  
  int ret = unlink(b);
     492:	f5840793          	addi	a5,s0,-168
     496:	853e                	mv	a0,a5
     498:	00007097          	auipc	ra,0x7
     49c:	684080e7          	jalr	1668(ra) # 7b1c <unlink>
     4a0:	87aa                	mv	a5,a0
     4a2:	fef42223          	sw	a5,-28(s0)
  if(ret != -1){
     4a6:	fe442783          	lw	a5,-28(s0)
     4aa:	0007871b          	sext.w	a4,a5
     4ae:	57fd                	li	a5,-1
     4b0:	02f70563          	beq	a4,a5,4da <copyinstr2+0x88>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
     4b4:	fe442703          	lw	a4,-28(s0)
     4b8:	f5840793          	addi	a5,s0,-168
     4bc:	863a                	mv	a2,a4
     4be:	85be                	mv	a1,a5
     4c0:	00008517          	auipc	a0,0x8
     4c4:	ff050513          	addi	a0,a0,-16 # 84b0 <malloc+0x2c4>
     4c8:	00008097          	auipc	ra,0x8
     4cc:	b30080e7          	jalr	-1232(ra) # 7ff8 <printf>
    exit(1);
     4d0:	4505                	li	a0,1
     4d2:	00007097          	auipc	ra,0x7
     4d6:	5fa080e7          	jalr	1530(ra) # 7acc <exit>
  }

  int fd = open(b, O_CREATE | O_WRONLY);
     4da:	f5840793          	addi	a5,s0,-168
     4de:	20100593          	li	a1,513
     4e2:	853e                	mv	a0,a5
     4e4:	00007097          	auipc	ra,0x7
     4e8:	628080e7          	jalr	1576(ra) # 7b0c <open>
     4ec:	87aa                	mv	a5,a0
     4ee:	fef42023          	sw	a5,-32(s0)
  if(fd != -1){
     4f2:	fe042783          	lw	a5,-32(s0)
     4f6:	0007871b          	sext.w	a4,a5
     4fa:	57fd                	li	a5,-1
     4fc:	02f70563          	beq	a4,a5,526 <copyinstr2+0xd4>
    printf("open(%s) returned %d, not -1\n", b, fd);
     500:	fe042703          	lw	a4,-32(s0)
     504:	f5840793          	addi	a5,s0,-168
     508:	863a                	mv	a2,a4
     50a:	85be                	mv	a1,a5
     50c:	00008517          	auipc	a0,0x8
     510:	fc450513          	addi	a0,a0,-60 # 84d0 <malloc+0x2e4>
     514:	00008097          	auipc	ra,0x8
     518:	ae4080e7          	jalr	-1308(ra) # 7ff8 <printf>
    exit(1);
     51c:	4505                	li	a0,1
     51e:	00007097          	auipc	ra,0x7
     522:	5ae080e7          	jalr	1454(ra) # 7acc <exit>
  }

  ret = link(b, b);
     526:	f5840713          	addi	a4,s0,-168
     52a:	f5840793          	addi	a5,s0,-168
     52e:	85ba                	mv	a1,a4
     530:	853e                	mv	a0,a5
     532:	00007097          	auipc	ra,0x7
     536:	5fa080e7          	jalr	1530(ra) # 7b2c <link>
     53a:	87aa                	mv	a5,a0
     53c:	fef42223          	sw	a5,-28(s0)
  if(ret != -1){
     540:	fe442783          	lw	a5,-28(s0)
     544:	0007871b          	sext.w	a4,a5
     548:	57fd                	li	a5,-1
     54a:	02f70763          	beq	a4,a5,578 <copyinstr2+0x126>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
     54e:	fe442683          	lw	a3,-28(s0)
     552:	f5840713          	addi	a4,s0,-168
     556:	f5840793          	addi	a5,s0,-168
     55a:	863a                	mv	a2,a4
     55c:	85be                	mv	a1,a5
     55e:	00008517          	auipc	a0,0x8
     562:	f9250513          	addi	a0,a0,-110 # 84f0 <malloc+0x304>
     566:	00008097          	auipc	ra,0x8
     56a:	a92080e7          	jalr	-1390(ra) # 7ff8 <printf>
    exit(1);
     56e:	4505                	li	a0,1
     570:	00007097          	auipc	ra,0x7
     574:	55c080e7          	jalr	1372(ra) # 7acc <exit>
  }

  char *args[] = { "xx", 0 };
     578:	00008797          	auipc	a5,0x8
     57c:	fa078793          	addi	a5,a5,-96 # 8518 <malloc+0x32c>
     580:	f4f43423          	sd	a5,-184(s0)
     584:	f4043823          	sd	zero,-176(s0)
  ret = exec(b, args);
     588:	f4840713          	addi	a4,s0,-184
     58c:	f5840793          	addi	a5,s0,-168
     590:	85ba                	mv	a1,a4
     592:	853e                	mv	a0,a5
     594:	00007097          	auipc	ra,0x7
     598:	570080e7          	jalr	1392(ra) # 7b04 <exec>
     59c:	87aa                	mv	a5,a0
     59e:	fef42223          	sw	a5,-28(s0)
  if(ret != -1){
     5a2:	fe442783          	lw	a5,-28(s0)
     5a6:	0007871b          	sext.w	a4,a5
     5aa:	57fd                	li	a5,-1
     5ac:	02f70563          	beq	a4,a5,5d6 <copyinstr2+0x184>
    printf("exec(%s) returned %d, not -1\n", b, fd);
     5b0:	fe042703          	lw	a4,-32(s0)
     5b4:	f5840793          	addi	a5,s0,-168
     5b8:	863a                	mv	a2,a4
     5ba:	85be                	mv	a1,a5
     5bc:	00008517          	auipc	a0,0x8
     5c0:	f6450513          	addi	a0,a0,-156 # 8520 <malloc+0x334>
     5c4:	00008097          	auipc	ra,0x8
     5c8:	a34080e7          	jalr	-1484(ra) # 7ff8 <printf>
    exit(1);
     5cc:	4505                	li	a0,1
     5ce:	00007097          	auipc	ra,0x7
     5d2:	4fe080e7          	jalr	1278(ra) # 7acc <exit>
  }

  int pid = fork();
     5d6:	00007097          	auipc	ra,0x7
     5da:	4ee080e7          	jalr	1262(ra) # 7ac4 <fork>
     5de:	87aa                	mv	a5,a0
     5e0:	fcf42e23          	sw	a5,-36(s0)
  if(pid < 0){
     5e4:	fdc42783          	lw	a5,-36(s0)
     5e8:	2781                	sext.w	a5,a5
     5ea:	0007df63          	bgez	a5,608 <copyinstr2+0x1b6>
    printf("fork failed\n");
     5ee:	00008517          	auipc	a0,0x8
     5f2:	f5250513          	addi	a0,a0,-174 # 8540 <malloc+0x354>
     5f6:	00008097          	auipc	ra,0x8
     5fa:	a02080e7          	jalr	-1534(ra) # 7ff8 <printf>
    exit(1);
     5fe:	4505                	li	a0,1
     600:	00007097          	auipc	ra,0x7
     604:	4cc080e7          	jalr	1228(ra) # 7acc <exit>
  }
  if(pid == 0){
     608:	fdc42783          	lw	a5,-36(s0)
     60c:	2781                	sext.w	a5,a5
     60e:	efd5                	bnez	a5,6ca <copyinstr2+0x278>
    static char big[PGSIZE+1];
    for(int i = 0; i < PGSIZE; i++)
     610:	fe042423          	sw	zero,-24(s0)
     614:	a00d                	j	636 <copyinstr2+0x1e4>
      big[i] = 'x';
     616:	00010717          	auipc	a4,0x10
     61a:	56a70713          	addi	a4,a4,1386 # 10b80 <big.0>
     61e:	fe842783          	lw	a5,-24(s0)
     622:	97ba                	add	a5,a5,a4
     624:	07800713          	li	a4,120
     628:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
     62c:	fe842783          	lw	a5,-24(s0)
     630:	2785                	addiw	a5,a5,1
     632:	fef42423          	sw	a5,-24(s0)
     636:	fe842783          	lw	a5,-24(s0)
     63a:	0007871b          	sext.w	a4,a5
     63e:	6785                	lui	a5,0x1
     640:	fcf74be3          	blt	a4,a5,616 <copyinstr2+0x1c4>
    big[PGSIZE] = '\0';
     644:	00010717          	auipc	a4,0x10
     648:	53c70713          	addi	a4,a4,1340 # 10b80 <big.0>
     64c:	6785                	lui	a5,0x1
     64e:	97ba                	add	a5,a5,a4
     650:	00078023          	sb	zero,0(a5) # 1000 <truncate3+0x1b2>
    char *args2[] = { big, big, big, 0 };
     654:	00008797          	auipc	a5,0x8
     658:	f5c78793          	addi	a5,a5,-164 # 85b0 <malloc+0x3c4>
     65c:	6390                	ld	a2,0(a5)
     65e:	6794                	ld	a3,8(a5)
     660:	6b98                	ld	a4,16(a5)
     662:	6f9c                	ld	a5,24(a5)
     664:	f2c43023          	sd	a2,-224(s0)
     668:	f2d43423          	sd	a3,-216(s0)
     66c:	f2e43823          	sd	a4,-208(s0)
     670:	f2f43c23          	sd	a5,-200(s0)
    ret = exec("echo", args2);
     674:	f2040793          	addi	a5,s0,-224
     678:	85be                	mv	a1,a5
     67a:	00008517          	auipc	a0,0x8
     67e:	ed650513          	addi	a0,a0,-298 # 8550 <malloc+0x364>
     682:	00007097          	auipc	ra,0x7
     686:	482080e7          	jalr	1154(ra) # 7b04 <exec>
     68a:	87aa                	mv	a5,a0
     68c:	fef42223          	sw	a5,-28(s0)
    if(ret != -1){
     690:	fe442783          	lw	a5,-28(s0)
     694:	0007871b          	sext.w	a4,a5
     698:	57fd                	li	a5,-1
     69a:	02f70263          	beq	a4,a5,6be <copyinstr2+0x26c>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
     69e:	fe042783          	lw	a5,-32(s0)
     6a2:	85be                	mv	a1,a5
     6a4:	00008517          	auipc	a0,0x8
     6a8:	eb450513          	addi	a0,a0,-332 # 8558 <malloc+0x36c>
     6ac:	00008097          	auipc	ra,0x8
     6b0:	94c080e7          	jalr	-1716(ra) # 7ff8 <printf>
      exit(1);
     6b4:	4505                	li	a0,1
     6b6:	00007097          	auipc	ra,0x7
     6ba:	416080e7          	jalr	1046(ra) # 7acc <exit>
    }
    exit(747); // OK
     6be:	2eb00513          	li	a0,747
     6c2:	00007097          	auipc	ra,0x7
     6c6:	40a080e7          	jalr	1034(ra) # 7acc <exit>
  }

  int st = 0;
     6ca:	f4042223          	sw	zero,-188(s0)
  wait(&st);
     6ce:	f4440793          	addi	a5,s0,-188
     6d2:	853e                	mv	a0,a5
     6d4:	00007097          	auipc	ra,0x7
     6d8:	400080e7          	jalr	1024(ra) # 7ad4 <wait>
  if(st != 747){
     6dc:	f4442703          	lw	a4,-188(s0)
     6e0:	2eb00793          	li	a5,747
     6e4:	00f70f63          	beq	a4,a5,702 <copyinstr2+0x2b0>
    printf("exec(echo, BIG) succeeded, should have failed\n");
     6e8:	00008517          	auipc	a0,0x8
     6ec:	e9850513          	addi	a0,a0,-360 # 8580 <malloc+0x394>
     6f0:	00008097          	auipc	ra,0x8
     6f4:	908080e7          	jalr	-1784(ra) # 7ff8 <printf>
    exit(1);
     6f8:	4505                	li	a0,1
     6fa:	00007097          	auipc	ra,0x7
     6fe:	3d2080e7          	jalr	978(ra) # 7acc <exit>
  }
}
     702:	0001                	nop
     704:	70ae                	ld	ra,232(sp)
     706:	740e                	ld	s0,224(sp)
     708:	616d                	addi	sp,sp,240
     70a:	8082                	ret

000000000000070c <copyinstr3>:

// what if a string argument crosses over the end of last user page?
void
copyinstr3(char *s)
{
     70c:	715d                	addi	sp,sp,-80
     70e:	e486                	sd	ra,72(sp)
     710:	e0a2                	sd	s0,64(sp)
     712:	0880                	addi	s0,sp,80
     714:	faa43c23          	sd	a0,-72(s0)
  sbrk(8192);
     718:	6509                	lui	a0,0x2
     71a:	00007097          	auipc	ra,0x7
     71e:	43a080e7          	jalr	1082(ra) # 7b54 <sbrk>
  uint64 top = (uint64) sbrk(0);
     722:	4501                	li	a0,0
     724:	00007097          	auipc	ra,0x7
     728:	430080e7          	jalr	1072(ra) # 7b54 <sbrk>
     72c:	87aa                	mv	a5,a0
     72e:	fef43423          	sd	a5,-24(s0)
  if((top % PGSIZE) != 0){
     732:	fe843703          	ld	a4,-24(s0)
     736:	6785                	lui	a5,0x1
     738:	17fd                	addi	a5,a5,-1 # fff <truncate3+0x1b1>
     73a:	8ff9                	and	a5,a5,a4
     73c:	c395                	beqz	a5,760 <copyinstr3+0x54>
    sbrk(PGSIZE - (top % PGSIZE));
     73e:	fe843783          	ld	a5,-24(s0)
     742:	2781                	sext.w	a5,a5
     744:	873e                	mv	a4,a5
     746:	6785                	lui	a5,0x1
     748:	17fd                	addi	a5,a5,-1 # fff <truncate3+0x1b1>
     74a:	8ff9                	and	a5,a5,a4
     74c:	2781                	sext.w	a5,a5
     74e:	6705                	lui	a4,0x1
     750:	40f707bb          	subw	a5,a4,a5
     754:	2781                	sext.w	a5,a5
     756:	853e                	mv	a0,a5
     758:	00007097          	auipc	ra,0x7
     75c:	3fc080e7          	jalr	1020(ra) # 7b54 <sbrk>
  }
  top = (uint64) sbrk(0);
     760:	4501                	li	a0,0
     762:	00007097          	auipc	ra,0x7
     766:	3f2080e7          	jalr	1010(ra) # 7b54 <sbrk>
     76a:	87aa                	mv	a5,a0
     76c:	fef43423          	sd	a5,-24(s0)
  if(top % PGSIZE){
     770:	fe843703          	ld	a4,-24(s0)
     774:	6785                	lui	a5,0x1
     776:	17fd                	addi	a5,a5,-1 # fff <truncate3+0x1b1>
     778:	8ff9                	and	a5,a5,a4
     77a:	cf91                	beqz	a5,796 <copyinstr3+0x8a>
    printf("oops\n");
     77c:	00008517          	auipc	a0,0x8
     780:	e5450513          	addi	a0,a0,-428 # 85d0 <malloc+0x3e4>
     784:	00008097          	auipc	ra,0x8
     788:	874080e7          	jalr	-1932(ra) # 7ff8 <printf>
    exit(1);
     78c:	4505                	li	a0,1
     78e:	00007097          	auipc	ra,0x7
     792:	33e080e7          	jalr	830(ra) # 7acc <exit>
  }

  char *b = (char *) (top - 1);
     796:	fe843783          	ld	a5,-24(s0)
     79a:	17fd                	addi	a5,a5,-1
     79c:	fef43023          	sd	a5,-32(s0)
  *b = 'x';
     7a0:	fe043783          	ld	a5,-32(s0)
     7a4:	07800713          	li	a4,120
     7a8:	00e78023          	sb	a4,0(a5)

  int ret = unlink(b);
     7ac:	fe043503          	ld	a0,-32(s0)
     7b0:	00007097          	auipc	ra,0x7
     7b4:	36c080e7          	jalr	876(ra) # 7b1c <unlink>
     7b8:	87aa                	mv	a5,a0
     7ba:	fcf42e23          	sw	a5,-36(s0)
  if(ret != -1){
     7be:	fdc42783          	lw	a5,-36(s0)
     7c2:	0007871b          	sext.w	a4,a5
     7c6:	57fd                	li	a5,-1
     7c8:	02f70463          	beq	a4,a5,7f0 <copyinstr3+0xe4>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
     7cc:	fdc42783          	lw	a5,-36(s0)
     7d0:	863e                	mv	a2,a5
     7d2:	fe043583          	ld	a1,-32(s0)
     7d6:	00008517          	auipc	a0,0x8
     7da:	cda50513          	addi	a0,a0,-806 # 84b0 <malloc+0x2c4>
     7de:	00008097          	auipc	ra,0x8
     7e2:	81a080e7          	jalr	-2022(ra) # 7ff8 <printf>
    exit(1);
     7e6:	4505                	li	a0,1
     7e8:	00007097          	auipc	ra,0x7
     7ec:	2e4080e7          	jalr	740(ra) # 7acc <exit>
  }

  int fd = open(b, O_CREATE | O_WRONLY);
     7f0:	20100593          	li	a1,513
     7f4:	fe043503          	ld	a0,-32(s0)
     7f8:	00007097          	auipc	ra,0x7
     7fc:	314080e7          	jalr	788(ra) # 7b0c <open>
     800:	87aa                	mv	a5,a0
     802:	fcf42c23          	sw	a5,-40(s0)
  if(fd != -1){
     806:	fd842783          	lw	a5,-40(s0)
     80a:	0007871b          	sext.w	a4,a5
     80e:	57fd                	li	a5,-1
     810:	02f70463          	beq	a4,a5,838 <copyinstr3+0x12c>
    printf("open(%s) returned %d, not -1\n", b, fd);
     814:	fd842783          	lw	a5,-40(s0)
     818:	863e                	mv	a2,a5
     81a:	fe043583          	ld	a1,-32(s0)
     81e:	00008517          	auipc	a0,0x8
     822:	cb250513          	addi	a0,a0,-846 # 84d0 <malloc+0x2e4>
     826:	00007097          	auipc	ra,0x7
     82a:	7d2080e7          	jalr	2002(ra) # 7ff8 <printf>
    exit(1);
     82e:	4505                	li	a0,1
     830:	00007097          	auipc	ra,0x7
     834:	29c080e7          	jalr	668(ra) # 7acc <exit>
  }

  ret = link(b, b);
     838:	fe043583          	ld	a1,-32(s0)
     83c:	fe043503          	ld	a0,-32(s0)
     840:	00007097          	auipc	ra,0x7
     844:	2ec080e7          	jalr	748(ra) # 7b2c <link>
     848:	87aa                	mv	a5,a0
     84a:	fcf42e23          	sw	a5,-36(s0)
  if(ret != -1){
     84e:	fdc42783          	lw	a5,-36(s0)
     852:	0007871b          	sext.w	a4,a5
     856:	57fd                	li	a5,-1
     858:	02f70663          	beq	a4,a5,884 <copyinstr3+0x178>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
     85c:	fdc42783          	lw	a5,-36(s0)
     860:	86be                	mv	a3,a5
     862:	fe043603          	ld	a2,-32(s0)
     866:	fe043583          	ld	a1,-32(s0)
     86a:	00008517          	auipc	a0,0x8
     86e:	c8650513          	addi	a0,a0,-890 # 84f0 <malloc+0x304>
     872:	00007097          	auipc	ra,0x7
     876:	786080e7          	jalr	1926(ra) # 7ff8 <printf>
    exit(1);
     87a:	4505                	li	a0,1
     87c:	00007097          	auipc	ra,0x7
     880:	250080e7          	jalr	592(ra) # 7acc <exit>
  }

  char *args[] = { "xx", 0 };
     884:	00008797          	auipc	a5,0x8
     888:	c9478793          	addi	a5,a5,-876 # 8518 <malloc+0x32c>
     88c:	fcf43423          	sd	a5,-56(s0)
     890:	fc043823          	sd	zero,-48(s0)
  ret = exec(b, args);
     894:	fc840793          	addi	a5,s0,-56
     898:	85be                	mv	a1,a5
     89a:	fe043503          	ld	a0,-32(s0)
     89e:	00007097          	auipc	ra,0x7
     8a2:	266080e7          	jalr	614(ra) # 7b04 <exec>
     8a6:	87aa                	mv	a5,a0
     8a8:	fcf42e23          	sw	a5,-36(s0)
  if(ret != -1){
     8ac:	fdc42783          	lw	a5,-36(s0)
     8b0:	0007871b          	sext.w	a4,a5
     8b4:	57fd                	li	a5,-1
     8b6:	02f70463          	beq	a4,a5,8de <copyinstr3+0x1d2>
    printf("exec(%s) returned %d, not -1\n", b, fd);
     8ba:	fd842783          	lw	a5,-40(s0)
     8be:	863e                	mv	a2,a5
     8c0:	fe043583          	ld	a1,-32(s0)
     8c4:	00008517          	auipc	a0,0x8
     8c8:	c5c50513          	addi	a0,a0,-932 # 8520 <malloc+0x334>
     8cc:	00007097          	auipc	ra,0x7
     8d0:	72c080e7          	jalr	1836(ra) # 7ff8 <printf>
    exit(1);
     8d4:	4505                	li	a0,1
     8d6:	00007097          	auipc	ra,0x7
     8da:	1f6080e7          	jalr	502(ra) # 7acc <exit>
  }
}
     8de:	0001                	nop
     8e0:	60a6                	ld	ra,72(sp)
     8e2:	6406                	ld	s0,64(sp)
     8e4:	6161                	addi	sp,sp,80
     8e6:	8082                	ret

00000000000008e8 <rwsbrk>:

// See if the kernel refuses to read/write user memory that the
// application doesn't have anymore, because it returned it.
void
rwsbrk()
{
     8e8:	1101                	addi	sp,sp,-32
     8ea:	ec06                	sd	ra,24(sp)
     8ec:	e822                	sd	s0,16(sp)
     8ee:	1000                	addi	s0,sp,32
  int fd, n;
  
  uint64 a = (uint64) sbrk(8192);
     8f0:	6509                	lui	a0,0x2
     8f2:	00007097          	auipc	ra,0x7
     8f6:	262080e7          	jalr	610(ra) # 7b54 <sbrk>
     8fa:	87aa                	mv	a5,a0
     8fc:	fef43423          	sd	a5,-24(s0)

  if(a == 0xffffffffffffffffLL) {
     900:	fe843703          	ld	a4,-24(s0)
     904:	57fd                	li	a5,-1
     906:	00f71f63          	bne	a4,a5,924 <rwsbrk+0x3c>
    printf("sbrk(rwsbrk) failed\n");
     90a:	00008517          	auipc	a0,0x8
     90e:	cce50513          	addi	a0,a0,-818 # 85d8 <malloc+0x3ec>
     912:	00007097          	auipc	ra,0x7
     916:	6e6080e7          	jalr	1766(ra) # 7ff8 <printf>
    exit(1);
     91a:	4505                	li	a0,1
     91c:	00007097          	auipc	ra,0x7
     920:	1b0080e7          	jalr	432(ra) # 7acc <exit>
  }
  
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
     924:	7579                	lui	a0,0xffffe
     926:	00007097          	auipc	ra,0x7
     92a:	22e080e7          	jalr	558(ra) # 7b54 <sbrk>
     92e:	872a                	mv	a4,a0
     930:	57fd                	li	a5,-1
     932:	00f71f63          	bne	a4,a5,950 <rwsbrk+0x68>
    printf("sbrk(rwsbrk) shrink failed\n");
     936:	00008517          	auipc	a0,0x8
     93a:	cba50513          	addi	a0,a0,-838 # 85f0 <malloc+0x404>
     93e:	00007097          	auipc	ra,0x7
     942:	6ba080e7          	jalr	1722(ra) # 7ff8 <printf>
    exit(1);
     946:	4505                	li	a0,1
     948:	00007097          	auipc	ra,0x7
     94c:	184080e7          	jalr	388(ra) # 7acc <exit>
  }

  fd = open("rwsbrk", O_CREATE|O_WRONLY);
     950:	20100593          	li	a1,513
     954:	00008517          	auipc	a0,0x8
     958:	cbc50513          	addi	a0,a0,-836 # 8610 <malloc+0x424>
     95c:	00007097          	auipc	ra,0x7
     960:	1b0080e7          	jalr	432(ra) # 7b0c <open>
     964:	87aa                	mv	a5,a0
     966:	fef42223          	sw	a5,-28(s0)
  if(fd < 0){
     96a:	fe442783          	lw	a5,-28(s0)
     96e:	2781                	sext.w	a5,a5
     970:	0007df63          	bgez	a5,98e <rwsbrk+0xa6>
    printf("open(rwsbrk) failed\n");
     974:	00008517          	auipc	a0,0x8
     978:	ca450513          	addi	a0,a0,-860 # 8618 <malloc+0x42c>
     97c:	00007097          	auipc	ra,0x7
     980:	67c080e7          	jalr	1660(ra) # 7ff8 <printf>
    exit(1);
     984:	4505                	li	a0,1
     986:	00007097          	auipc	ra,0x7
     98a:	146080e7          	jalr	326(ra) # 7acc <exit>
  }
  n = write(fd, (void*)(a+4096), 1024);
     98e:	fe843703          	ld	a4,-24(s0)
     992:	6785                	lui	a5,0x1
     994:	97ba                	add	a5,a5,a4
     996:	873e                	mv	a4,a5
     998:	fe442783          	lw	a5,-28(s0)
     99c:	40000613          	li	a2,1024
     9a0:	85ba                	mv	a1,a4
     9a2:	853e                	mv	a0,a5
     9a4:	00007097          	auipc	ra,0x7
     9a8:	148080e7          	jalr	328(ra) # 7aec <write>
     9ac:	87aa                	mv	a5,a0
     9ae:	fef42023          	sw	a5,-32(s0)
  if(n >= 0){
     9b2:	fe042783          	lw	a5,-32(s0)
     9b6:	2781                	sext.w	a5,a5
     9b8:	0207c763          	bltz	a5,9e6 <rwsbrk+0xfe>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
     9bc:	fe843703          	ld	a4,-24(s0)
     9c0:	6785                	lui	a5,0x1
     9c2:	97ba                	add	a5,a5,a4
     9c4:	fe042703          	lw	a4,-32(s0)
     9c8:	863a                	mv	a2,a4
     9ca:	85be                	mv	a1,a5
     9cc:	00008517          	auipc	a0,0x8
     9d0:	c6450513          	addi	a0,a0,-924 # 8630 <malloc+0x444>
     9d4:	00007097          	auipc	ra,0x7
     9d8:	624080e7          	jalr	1572(ra) # 7ff8 <printf>
    exit(1);
     9dc:	4505                	li	a0,1
     9de:	00007097          	auipc	ra,0x7
     9e2:	0ee080e7          	jalr	238(ra) # 7acc <exit>
  }
  close(fd);
     9e6:	fe442783          	lw	a5,-28(s0)
     9ea:	853e                	mv	a0,a5
     9ec:	00007097          	auipc	ra,0x7
     9f0:	108080e7          	jalr	264(ra) # 7af4 <close>
  unlink("rwsbrk");
     9f4:	00008517          	auipc	a0,0x8
     9f8:	c1c50513          	addi	a0,a0,-996 # 8610 <malloc+0x424>
     9fc:	00007097          	auipc	ra,0x7
     a00:	120080e7          	jalr	288(ra) # 7b1c <unlink>

  fd = open("README", O_RDONLY);
     a04:	4581                	li	a1,0
     a06:	00008517          	auipc	a0,0x8
     a0a:	9ea50513          	addi	a0,a0,-1558 # 83f0 <malloc+0x204>
     a0e:	00007097          	auipc	ra,0x7
     a12:	0fe080e7          	jalr	254(ra) # 7b0c <open>
     a16:	87aa                	mv	a5,a0
     a18:	fef42223          	sw	a5,-28(s0)
  if(fd < 0){
     a1c:	fe442783          	lw	a5,-28(s0)
     a20:	2781                	sext.w	a5,a5
     a22:	0007df63          	bgez	a5,a40 <rwsbrk+0x158>
    printf("open(rwsbrk) failed\n");
     a26:	00008517          	auipc	a0,0x8
     a2a:	bf250513          	addi	a0,a0,-1038 # 8618 <malloc+0x42c>
     a2e:	00007097          	auipc	ra,0x7
     a32:	5ca080e7          	jalr	1482(ra) # 7ff8 <printf>
    exit(1);
     a36:	4505                	li	a0,1
     a38:	00007097          	auipc	ra,0x7
     a3c:	094080e7          	jalr	148(ra) # 7acc <exit>
  }
  n = read(fd, (void*)(a+4096), 10);
     a40:	fe843703          	ld	a4,-24(s0)
     a44:	6785                	lui	a5,0x1
     a46:	97ba                	add	a5,a5,a4
     a48:	873e                	mv	a4,a5
     a4a:	fe442783          	lw	a5,-28(s0)
     a4e:	4629                	li	a2,10
     a50:	85ba                	mv	a1,a4
     a52:	853e                	mv	a0,a5
     a54:	00007097          	auipc	ra,0x7
     a58:	090080e7          	jalr	144(ra) # 7ae4 <read>
     a5c:	87aa                	mv	a5,a0
     a5e:	fef42023          	sw	a5,-32(s0)
  if(n >= 0){
     a62:	fe042783          	lw	a5,-32(s0)
     a66:	2781                	sext.w	a5,a5
     a68:	0207c763          	bltz	a5,a96 <rwsbrk+0x1ae>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
     a6c:	fe843703          	ld	a4,-24(s0)
     a70:	6785                	lui	a5,0x1
     a72:	97ba                	add	a5,a5,a4
     a74:	fe042703          	lw	a4,-32(s0)
     a78:	863a                	mv	a2,a4
     a7a:	85be                	mv	a1,a5
     a7c:	00008517          	auipc	a0,0x8
     a80:	be450513          	addi	a0,a0,-1052 # 8660 <malloc+0x474>
     a84:	00007097          	auipc	ra,0x7
     a88:	574080e7          	jalr	1396(ra) # 7ff8 <printf>
    exit(1);
     a8c:	4505                	li	a0,1
     a8e:	00007097          	auipc	ra,0x7
     a92:	03e080e7          	jalr	62(ra) # 7acc <exit>
  }
  close(fd);
     a96:	fe442783          	lw	a5,-28(s0)
     a9a:	853e                	mv	a0,a5
     a9c:	00007097          	auipc	ra,0x7
     aa0:	058080e7          	jalr	88(ra) # 7af4 <close>
  
  exit(0);
     aa4:	4501                	li	a0,0
     aa6:	00007097          	auipc	ra,0x7
     aaa:	026080e7          	jalr	38(ra) # 7acc <exit>

0000000000000aae <truncate1>:
}

// test O_TRUNC.
void
truncate1(char *s)
{
     aae:	715d                	addi	sp,sp,-80
     ab0:	e486                	sd	ra,72(sp)
     ab2:	e0a2                	sd	s0,64(sp)
     ab4:	0880                	addi	s0,sp,80
     ab6:	faa43c23          	sd	a0,-72(s0)
  char buf[32];
  
  unlink("truncfile");
     aba:	00008517          	auipc	a0,0x8
     abe:	bce50513          	addi	a0,a0,-1074 # 8688 <malloc+0x49c>
     ac2:	00007097          	auipc	ra,0x7
     ac6:	05a080e7          	jalr	90(ra) # 7b1c <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     aca:	60100593          	li	a1,1537
     ace:	00008517          	auipc	a0,0x8
     ad2:	bba50513          	addi	a0,a0,-1094 # 8688 <malloc+0x49c>
     ad6:	00007097          	auipc	ra,0x7
     ada:	036080e7          	jalr	54(ra) # 7b0c <open>
     ade:	87aa                	mv	a5,a0
     ae0:	fef42623          	sw	a5,-20(s0)
  write(fd1, "abcd", 4);
     ae4:	fec42783          	lw	a5,-20(s0)
     ae8:	4611                	li	a2,4
     aea:	00008597          	auipc	a1,0x8
     aee:	bae58593          	addi	a1,a1,-1106 # 8698 <malloc+0x4ac>
     af2:	853e                	mv	a0,a5
     af4:	00007097          	auipc	ra,0x7
     af8:	ff8080e7          	jalr	-8(ra) # 7aec <write>
  close(fd1);
     afc:	fec42783          	lw	a5,-20(s0)
     b00:	853e                	mv	a0,a5
     b02:	00007097          	auipc	ra,0x7
     b06:	ff2080e7          	jalr	-14(ra) # 7af4 <close>

  int fd2 = open("truncfile", O_RDONLY);
     b0a:	4581                	li	a1,0
     b0c:	00008517          	auipc	a0,0x8
     b10:	b7c50513          	addi	a0,a0,-1156 # 8688 <malloc+0x49c>
     b14:	00007097          	auipc	ra,0x7
     b18:	ff8080e7          	jalr	-8(ra) # 7b0c <open>
     b1c:	87aa                	mv	a5,a0
     b1e:	fef42423          	sw	a5,-24(s0)
  int n = read(fd2, buf, sizeof(buf));
     b22:	fc040713          	addi	a4,s0,-64
     b26:	fe842783          	lw	a5,-24(s0)
     b2a:	02000613          	li	a2,32
     b2e:	85ba                	mv	a1,a4
     b30:	853e                	mv	a0,a5
     b32:	00007097          	auipc	ra,0x7
     b36:	fb2080e7          	jalr	-78(ra) # 7ae4 <read>
     b3a:	87aa                	mv	a5,a0
     b3c:	fef42223          	sw	a5,-28(s0)
  if(n != 4){
     b40:	fe442783          	lw	a5,-28(s0)
     b44:	0007871b          	sext.w	a4,a5
     b48:	4791                	li	a5,4
     b4a:	02f70463          	beq	a4,a5,b72 <truncate1+0xc4>
    printf("%s: read %d bytes, wanted 4\n", s, n);
     b4e:	fe442783          	lw	a5,-28(s0)
     b52:	863e                	mv	a2,a5
     b54:	fb843583          	ld	a1,-72(s0)
     b58:	00008517          	auipc	a0,0x8
     b5c:	b4850513          	addi	a0,a0,-1208 # 86a0 <malloc+0x4b4>
     b60:	00007097          	auipc	ra,0x7
     b64:	498080e7          	jalr	1176(ra) # 7ff8 <printf>
    exit(1);
     b68:	4505                	li	a0,1
     b6a:	00007097          	auipc	ra,0x7
     b6e:	f62080e7          	jalr	-158(ra) # 7acc <exit>
  }

  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     b72:	40100593          	li	a1,1025
     b76:	00008517          	auipc	a0,0x8
     b7a:	b1250513          	addi	a0,a0,-1262 # 8688 <malloc+0x49c>
     b7e:	00007097          	auipc	ra,0x7
     b82:	f8e080e7          	jalr	-114(ra) # 7b0c <open>
     b86:	87aa                	mv	a5,a0
     b88:	fef42623          	sw	a5,-20(s0)

  int fd3 = open("truncfile", O_RDONLY);
     b8c:	4581                	li	a1,0
     b8e:	00008517          	auipc	a0,0x8
     b92:	afa50513          	addi	a0,a0,-1286 # 8688 <malloc+0x49c>
     b96:	00007097          	auipc	ra,0x7
     b9a:	f76080e7          	jalr	-138(ra) # 7b0c <open>
     b9e:	87aa                	mv	a5,a0
     ba0:	fef42023          	sw	a5,-32(s0)
  n = read(fd3, buf, sizeof(buf));
     ba4:	fc040713          	addi	a4,s0,-64
     ba8:	fe042783          	lw	a5,-32(s0)
     bac:	02000613          	li	a2,32
     bb0:	85ba                	mv	a1,a4
     bb2:	853e                	mv	a0,a5
     bb4:	00007097          	auipc	ra,0x7
     bb8:	f30080e7          	jalr	-208(ra) # 7ae4 <read>
     bbc:	87aa                	mv	a5,a0
     bbe:	fef42223          	sw	a5,-28(s0)
  if(n != 0){
     bc2:	fe442783          	lw	a5,-28(s0)
     bc6:	2781                	sext.w	a5,a5
     bc8:	cf95                	beqz	a5,c04 <truncate1+0x156>
    printf("aaa fd3=%d\n", fd3);
     bca:	fe042783          	lw	a5,-32(s0)
     bce:	85be                	mv	a1,a5
     bd0:	00008517          	auipc	a0,0x8
     bd4:	af050513          	addi	a0,a0,-1296 # 86c0 <malloc+0x4d4>
     bd8:	00007097          	auipc	ra,0x7
     bdc:	420080e7          	jalr	1056(ra) # 7ff8 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     be0:	fe442783          	lw	a5,-28(s0)
     be4:	863e                	mv	a2,a5
     be6:	fb843583          	ld	a1,-72(s0)
     bea:	00008517          	auipc	a0,0x8
     bee:	ae650513          	addi	a0,a0,-1306 # 86d0 <malloc+0x4e4>
     bf2:	00007097          	auipc	ra,0x7
     bf6:	406080e7          	jalr	1030(ra) # 7ff8 <printf>
    exit(1);
     bfa:	4505                	li	a0,1
     bfc:	00007097          	auipc	ra,0x7
     c00:	ed0080e7          	jalr	-304(ra) # 7acc <exit>
  }

  n = read(fd2, buf, sizeof(buf));
     c04:	fc040713          	addi	a4,s0,-64
     c08:	fe842783          	lw	a5,-24(s0)
     c0c:	02000613          	li	a2,32
     c10:	85ba                	mv	a1,a4
     c12:	853e                	mv	a0,a5
     c14:	00007097          	auipc	ra,0x7
     c18:	ed0080e7          	jalr	-304(ra) # 7ae4 <read>
     c1c:	87aa                	mv	a5,a0
     c1e:	fef42223          	sw	a5,-28(s0)
  if(n != 0){
     c22:	fe442783          	lw	a5,-28(s0)
     c26:	2781                	sext.w	a5,a5
     c28:	cf95                	beqz	a5,c64 <truncate1+0x1b6>
    printf("bbb fd2=%d\n", fd2);
     c2a:	fe842783          	lw	a5,-24(s0)
     c2e:	85be                	mv	a1,a5
     c30:	00008517          	auipc	a0,0x8
     c34:	ac050513          	addi	a0,a0,-1344 # 86f0 <malloc+0x504>
     c38:	00007097          	auipc	ra,0x7
     c3c:	3c0080e7          	jalr	960(ra) # 7ff8 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     c40:	fe442783          	lw	a5,-28(s0)
     c44:	863e                	mv	a2,a5
     c46:	fb843583          	ld	a1,-72(s0)
     c4a:	00008517          	auipc	a0,0x8
     c4e:	a8650513          	addi	a0,a0,-1402 # 86d0 <malloc+0x4e4>
     c52:	00007097          	auipc	ra,0x7
     c56:	3a6080e7          	jalr	934(ra) # 7ff8 <printf>
    exit(1);
     c5a:	4505                	li	a0,1
     c5c:	00007097          	auipc	ra,0x7
     c60:	e70080e7          	jalr	-400(ra) # 7acc <exit>
  }
  
  write(fd1, "abcdef", 6);
     c64:	fec42783          	lw	a5,-20(s0)
     c68:	4619                	li	a2,6
     c6a:	00008597          	auipc	a1,0x8
     c6e:	a9658593          	addi	a1,a1,-1386 # 8700 <malloc+0x514>
     c72:	853e                	mv	a0,a5
     c74:	00007097          	auipc	ra,0x7
     c78:	e78080e7          	jalr	-392(ra) # 7aec <write>

  n = read(fd3, buf, sizeof(buf));
     c7c:	fc040713          	addi	a4,s0,-64
     c80:	fe042783          	lw	a5,-32(s0)
     c84:	02000613          	li	a2,32
     c88:	85ba                	mv	a1,a4
     c8a:	853e                	mv	a0,a5
     c8c:	00007097          	auipc	ra,0x7
     c90:	e58080e7          	jalr	-424(ra) # 7ae4 <read>
     c94:	87aa                	mv	a5,a0
     c96:	fef42223          	sw	a5,-28(s0)
  if(n != 6){
     c9a:	fe442783          	lw	a5,-28(s0)
     c9e:	0007871b          	sext.w	a4,a5
     ca2:	4799                	li	a5,6
     ca4:	02f70463          	beq	a4,a5,ccc <truncate1+0x21e>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     ca8:	fe442783          	lw	a5,-28(s0)
     cac:	863e                	mv	a2,a5
     cae:	fb843583          	ld	a1,-72(s0)
     cb2:	00008517          	auipc	a0,0x8
     cb6:	a5650513          	addi	a0,a0,-1450 # 8708 <malloc+0x51c>
     cba:	00007097          	auipc	ra,0x7
     cbe:	33e080e7          	jalr	830(ra) # 7ff8 <printf>
    exit(1);
     cc2:	4505                	li	a0,1
     cc4:	00007097          	auipc	ra,0x7
     cc8:	e08080e7          	jalr	-504(ra) # 7acc <exit>
  }

  n = read(fd2, buf, sizeof(buf));
     ccc:	fc040713          	addi	a4,s0,-64
     cd0:	fe842783          	lw	a5,-24(s0)
     cd4:	02000613          	li	a2,32
     cd8:	85ba                	mv	a1,a4
     cda:	853e                	mv	a0,a5
     cdc:	00007097          	auipc	ra,0x7
     ce0:	e08080e7          	jalr	-504(ra) # 7ae4 <read>
     ce4:	87aa                	mv	a5,a0
     ce6:	fef42223          	sw	a5,-28(s0)
  if(n != 2){
     cea:	fe442783          	lw	a5,-28(s0)
     cee:	0007871b          	sext.w	a4,a5
     cf2:	4789                	li	a5,2
     cf4:	02f70463          	beq	a4,a5,d1c <truncate1+0x26e>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     cf8:	fe442783          	lw	a5,-28(s0)
     cfc:	863e                	mv	a2,a5
     cfe:	fb843583          	ld	a1,-72(s0)
     d02:	00008517          	auipc	a0,0x8
     d06:	a2650513          	addi	a0,a0,-1498 # 8728 <malloc+0x53c>
     d0a:	00007097          	auipc	ra,0x7
     d0e:	2ee080e7          	jalr	750(ra) # 7ff8 <printf>
    exit(1);
     d12:	4505                	li	a0,1
     d14:	00007097          	auipc	ra,0x7
     d18:	db8080e7          	jalr	-584(ra) # 7acc <exit>
  }

  unlink("truncfile");
     d1c:	00008517          	auipc	a0,0x8
     d20:	96c50513          	addi	a0,a0,-1684 # 8688 <malloc+0x49c>
     d24:	00007097          	auipc	ra,0x7
     d28:	df8080e7          	jalr	-520(ra) # 7b1c <unlink>

  close(fd1);
     d2c:	fec42783          	lw	a5,-20(s0)
     d30:	853e                	mv	a0,a5
     d32:	00007097          	auipc	ra,0x7
     d36:	dc2080e7          	jalr	-574(ra) # 7af4 <close>
  close(fd2);
     d3a:	fe842783          	lw	a5,-24(s0)
     d3e:	853e                	mv	a0,a5
     d40:	00007097          	auipc	ra,0x7
     d44:	db4080e7          	jalr	-588(ra) # 7af4 <close>
  close(fd3);
     d48:	fe042783          	lw	a5,-32(s0)
     d4c:	853e                	mv	a0,a5
     d4e:	00007097          	auipc	ra,0x7
     d52:	da6080e7          	jalr	-602(ra) # 7af4 <close>
}
     d56:	0001                	nop
     d58:	60a6                	ld	ra,72(sp)
     d5a:	6406                	ld	s0,64(sp)
     d5c:	6161                	addi	sp,sp,80
     d5e:	8082                	ret

0000000000000d60 <truncate2>:
// this causes a write at an offset beyond the end of the file.
// such writes fail on xv6 (unlike POSIX) but at least
// they don't crash.
void
truncate2(char *s)
{
     d60:	7179                	addi	sp,sp,-48
     d62:	f406                	sd	ra,40(sp)
     d64:	f022                	sd	s0,32(sp)
     d66:	1800                	addi	s0,sp,48
     d68:	fca43c23          	sd	a0,-40(s0)
  unlink("truncfile");
     d6c:	00008517          	auipc	a0,0x8
     d70:	91c50513          	addi	a0,a0,-1764 # 8688 <malloc+0x49c>
     d74:	00007097          	auipc	ra,0x7
     d78:	da8080e7          	jalr	-600(ra) # 7b1c <unlink>

  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     d7c:	60100593          	li	a1,1537
     d80:	00008517          	auipc	a0,0x8
     d84:	90850513          	addi	a0,a0,-1784 # 8688 <malloc+0x49c>
     d88:	00007097          	auipc	ra,0x7
     d8c:	d84080e7          	jalr	-636(ra) # 7b0c <open>
     d90:	87aa                	mv	a5,a0
     d92:	fef42623          	sw	a5,-20(s0)
  write(fd1, "abcd", 4);
     d96:	fec42783          	lw	a5,-20(s0)
     d9a:	4611                	li	a2,4
     d9c:	00008597          	auipc	a1,0x8
     da0:	8fc58593          	addi	a1,a1,-1796 # 8698 <malloc+0x4ac>
     da4:	853e                	mv	a0,a5
     da6:	00007097          	auipc	ra,0x7
     daa:	d46080e7          	jalr	-698(ra) # 7aec <write>

  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     dae:	40100593          	li	a1,1025
     db2:	00008517          	auipc	a0,0x8
     db6:	8d650513          	addi	a0,a0,-1834 # 8688 <malloc+0x49c>
     dba:	00007097          	auipc	ra,0x7
     dbe:	d52080e7          	jalr	-686(ra) # 7b0c <open>
     dc2:	87aa                	mv	a5,a0
     dc4:	fef42423          	sw	a5,-24(s0)

  int n = write(fd1, "x", 1);
     dc8:	fec42783          	lw	a5,-20(s0)
     dcc:	4605                	li	a2,1
     dce:	00007597          	auipc	a1,0x7
     dd2:	67258593          	addi	a1,a1,1650 # 8440 <malloc+0x254>
     dd6:	853e                	mv	a0,a5
     dd8:	00007097          	auipc	ra,0x7
     ddc:	d14080e7          	jalr	-748(ra) # 7aec <write>
     de0:	87aa                	mv	a5,a0
     de2:	fef42223          	sw	a5,-28(s0)
  if(n != -1){
     de6:	fe442783          	lw	a5,-28(s0)
     dea:	0007871b          	sext.w	a4,a5
     dee:	57fd                	li	a5,-1
     df0:	02f70463          	beq	a4,a5,e18 <truncate2+0xb8>
    printf("%s: write returned %d, expected -1\n", s, n);
     df4:	fe442783          	lw	a5,-28(s0)
     df8:	863e                	mv	a2,a5
     dfa:	fd843583          	ld	a1,-40(s0)
     dfe:	00008517          	auipc	a0,0x8
     e02:	94a50513          	addi	a0,a0,-1718 # 8748 <malloc+0x55c>
     e06:	00007097          	auipc	ra,0x7
     e0a:	1f2080e7          	jalr	498(ra) # 7ff8 <printf>
    exit(1);
     e0e:	4505                	li	a0,1
     e10:	00007097          	auipc	ra,0x7
     e14:	cbc080e7          	jalr	-836(ra) # 7acc <exit>
  }

  unlink("truncfile");
     e18:	00008517          	auipc	a0,0x8
     e1c:	87050513          	addi	a0,a0,-1936 # 8688 <malloc+0x49c>
     e20:	00007097          	auipc	ra,0x7
     e24:	cfc080e7          	jalr	-772(ra) # 7b1c <unlink>
  close(fd1);
     e28:	fec42783          	lw	a5,-20(s0)
     e2c:	853e                	mv	a0,a5
     e2e:	00007097          	auipc	ra,0x7
     e32:	cc6080e7          	jalr	-826(ra) # 7af4 <close>
  close(fd2);
     e36:	fe842783          	lw	a5,-24(s0)
     e3a:	853e                	mv	a0,a5
     e3c:	00007097          	auipc	ra,0x7
     e40:	cb8080e7          	jalr	-840(ra) # 7af4 <close>
}
     e44:	0001                	nop
     e46:	70a2                	ld	ra,40(sp)
     e48:	7402                	ld	s0,32(sp)
     e4a:	6145                	addi	sp,sp,48
     e4c:	8082                	ret

0000000000000e4e <truncate3>:

void
truncate3(char *s)
{
     e4e:	711d                	addi	sp,sp,-96
     e50:	ec86                	sd	ra,88(sp)
     e52:	e8a2                	sd	s0,80(sp)
     e54:	1080                	addi	s0,sp,96
     e56:	faa43423          	sd	a0,-88(s0)
  int pid, xstatus;

  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
     e5a:	60100593          	li	a1,1537
     e5e:	00008517          	auipc	a0,0x8
     e62:	82a50513          	addi	a0,a0,-2006 # 8688 <malloc+0x49c>
     e66:	00007097          	auipc	ra,0x7
     e6a:	ca6080e7          	jalr	-858(ra) # 7b0c <open>
     e6e:	87aa                	mv	a5,a0
     e70:	853e                	mv	a0,a5
     e72:	00007097          	auipc	ra,0x7
     e76:	c82080e7          	jalr	-894(ra) # 7af4 <close>
  
  pid = fork();
     e7a:	00007097          	auipc	ra,0x7
     e7e:	c4a080e7          	jalr	-950(ra) # 7ac4 <fork>
     e82:	87aa                	mv	a5,a0
     e84:	fef42223          	sw	a5,-28(s0)
  if(pid < 0){
     e88:	fe442783          	lw	a5,-28(s0)
     e8c:	2781                	sext.w	a5,a5
     e8e:	0207d163          	bgez	a5,eb0 <truncate3+0x62>
    printf("%s: fork failed\n", s);
     e92:	fa843583          	ld	a1,-88(s0)
     e96:	00008517          	auipc	a0,0x8
     e9a:	8da50513          	addi	a0,a0,-1830 # 8770 <malloc+0x584>
     e9e:	00007097          	auipc	ra,0x7
     ea2:	15a080e7          	jalr	346(ra) # 7ff8 <printf>
    exit(1);
     ea6:	4505                	li	a0,1
     ea8:	00007097          	auipc	ra,0x7
     eac:	c24080e7          	jalr	-988(ra) # 7acc <exit>
  }

  if(pid == 0){
     eb0:	fe442783          	lw	a5,-28(s0)
     eb4:	2781                	sext.w	a5,a5
     eb6:	10079563          	bnez	a5,fc0 <truncate3+0x172>
    for(int i = 0; i < 100; i++){
     eba:	fe042623          	sw	zero,-20(s0)
     ebe:	a0e5                	j	fa6 <truncate3+0x158>
      char buf[32];
      int fd = open("truncfile", O_WRONLY);
     ec0:	4585                	li	a1,1
     ec2:	00007517          	auipc	a0,0x7
     ec6:	7c650513          	addi	a0,a0,1990 # 8688 <malloc+0x49c>
     eca:	00007097          	auipc	ra,0x7
     ece:	c42080e7          	jalr	-958(ra) # 7b0c <open>
     ed2:	87aa                	mv	a5,a0
     ed4:	fcf42c23          	sw	a5,-40(s0)
      if(fd < 0){
     ed8:	fd842783          	lw	a5,-40(s0)
     edc:	2781                	sext.w	a5,a5
     ede:	0207d163          	bgez	a5,f00 <truncate3+0xb2>
        printf("%s: open failed\n", s);
     ee2:	fa843583          	ld	a1,-88(s0)
     ee6:	00008517          	auipc	a0,0x8
     eea:	8a250513          	addi	a0,a0,-1886 # 8788 <malloc+0x59c>
     eee:	00007097          	auipc	ra,0x7
     ef2:	10a080e7          	jalr	266(ra) # 7ff8 <printf>
        exit(1);
     ef6:	4505                	li	a0,1
     ef8:	00007097          	auipc	ra,0x7
     efc:	bd4080e7          	jalr	-1068(ra) # 7acc <exit>
      }
      int n = write(fd, "1234567890", 10);
     f00:	fd842783          	lw	a5,-40(s0)
     f04:	4629                	li	a2,10
     f06:	00008597          	auipc	a1,0x8
     f0a:	89a58593          	addi	a1,a1,-1894 # 87a0 <malloc+0x5b4>
     f0e:	853e                	mv	a0,a5
     f10:	00007097          	auipc	ra,0x7
     f14:	bdc080e7          	jalr	-1060(ra) # 7aec <write>
     f18:	87aa                	mv	a5,a0
     f1a:	fcf42a23          	sw	a5,-44(s0)
      if(n != 10){
     f1e:	fd442783          	lw	a5,-44(s0)
     f22:	0007871b          	sext.w	a4,a5
     f26:	47a9                	li	a5,10
     f28:	02f70463          	beq	a4,a5,f50 <truncate3+0x102>
        printf("%s: write got %d, expected 10\n", s, n);
     f2c:	fd442783          	lw	a5,-44(s0)
     f30:	863e                	mv	a2,a5
     f32:	fa843583          	ld	a1,-88(s0)
     f36:	00008517          	auipc	a0,0x8
     f3a:	87a50513          	addi	a0,a0,-1926 # 87b0 <malloc+0x5c4>
     f3e:	00007097          	auipc	ra,0x7
     f42:	0ba080e7          	jalr	186(ra) # 7ff8 <printf>
        exit(1);
     f46:	4505                	li	a0,1
     f48:	00007097          	auipc	ra,0x7
     f4c:	b84080e7          	jalr	-1148(ra) # 7acc <exit>
      }
      close(fd);
     f50:	fd842783          	lw	a5,-40(s0)
     f54:	853e                	mv	a0,a5
     f56:	00007097          	auipc	ra,0x7
     f5a:	b9e080e7          	jalr	-1122(ra) # 7af4 <close>
      fd = open("truncfile", O_RDONLY);
     f5e:	4581                	li	a1,0
     f60:	00007517          	auipc	a0,0x7
     f64:	72850513          	addi	a0,a0,1832 # 8688 <malloc+0x49c>
     f68:	00007097          	auipc	ra,0x7
     f6c:	ba4080e7          	jalr	-1116(ra) # 7b0c <open>
     f70:	87aa                	mv	a5,a0
     f72:	fcf42c23          	sw	a5,-40(s0)
      read(fd, buf, sizeof(buf));
     f76:	fb040713          	addi	a4,s0,-80
     f7a:	fd842783          	lw	a5,-40(s0)
     f7e:	02000613          	li	a2,32
     f82:	85ba                	mv	a1,a4
     f84:	853e                	mv	a0,a5
     f86:	00007097          	auipc	ra,0x7
     f8a:	b5e080e7          	jalr	-1186(ra) # 7ae4 <read>
      close(fd);
     f8e:	fd842783          	lw	a5,-40(s0)
     f92:	853e                	mv	a0,a5
     f94:	00007097          	auipc	ra,0x7
     f98:	b60080e7          	jalr	-1184(ra) # 7af4 <close>
    for(int i = 0; i < 100; i++){
     f9c:	fec42783          	lw	a5,-20(s0)
     fa0:	2785                	addiw	a5,a5,1 # 1001 <truncate3+0x1b3>
     fa2:	fef42623          	sw	a5,-20(s0)
     fa6:	fec42783          	lw	a5,-20(s0)
     faa:	0007871b          	sext.w	a4,a5
     fae:	06300793          	li	a5,99
     fb2:	f0e7d7e3          	bge	a5,a4,ec0 <truncate3+0x72>
    }
    exit(0);
     fb6:	4501                	li	a0,0
     fb8:	00007097          	auipc	ra,0x7
     fbc:	b14080e7          	jalr	-1260(ra) # 7acc <exit>
  }

  for(int i = 0; i < 150; i++){
     fc0:	fe042423          	sw	zero,-24(s0)
     fc4:	a075                	j	1070 <truncate3+0x222>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     fc6:	60100593          	li	a1,1537
     fca:	00007517          	auipc	a0,0x7
     fce:	6be50513          	addi	a0,a0,1726 # 8688 <malloc+0x49c>
     fd2:	00007097          	auipc	ra,0x7
     fd6:	b3a080e7          	jalr	-1222(ra) # 7b0c <open>
     fda:	87aa                	mv	a5,a0
     fdc:	fef42023          	sw	a5,-32(s0)
    if(fd < 0){
     fe0:	fe042783          	lw	a5,-32(s0)
     fe4:	2781                	sext.w	a5,a5
     fe6:	0207d163          	bgez	a5,1008 <truncate3+0x1ba>
      printf("%s: open failed\n", s);
     fea:	fa843583          	ld	a1,-88(s0)
     fee:	00007517          	auipc	a0,0x7
     ff2:	79a50513          	addi	a0,a0,1946 # 8788 <malloc+0x59c>
     ff6:	00007097          	auipc	ra,0x7
     ffa:	002080e7          	jalr	2(ra) # 7ff8 <printf>
      exit(1);
     ffe:	4505                	li	a0,1
    1000:	00007097          	auipc	ra,0x7
    1004:	acc080e7          	jalr	-1332(ra) # 7acc <exit>
    }
    int n = write(fd, "xxx", 3);
    1008:	fe042783          	lw	a5,-32(s0)
    100c:	460d                	li	a2,3
    100e:	00007597          	auipc	a1,0x7
    1012:	7c258593          	addi	a1,a1,1986 # 87d0 <malloc+0x5e4>
    1016:	853e                	mv	a0,a5
    1018:	00007097          	auipc	ra,0x7
    101c:	ad4080e7          	jalr	-1324(ra) # 7aec <write>
    1020:	87aa                	mv	a5,a0
    1022:	fcf42e23          	sw	a5,-36(s0)
    if(n != 3){
    1026:	fdc42783          	lw	a5,-36(s0)
    102a:	0007871b          	sext.w	a4,a5
    102e:	478d                	li	a5,3
    1030:	02f70463          	beq	a4,a5,1058 <truncate3+0x20a>
      printf("%s: write got %d, expected 3\n", s, n);
    1034:	fdc42783          	lw	a5,-36(s0)
    1038:	863e                	mv	a2,a5
    103a:	fa843583          	ld	a1,-88(s0)
    103e:	00007517          	auipc	a0,0x7
    1042:	79a50513          	addi	a0,a0,1946 # 87d8 <malloc+0x5ec>
    1046:	00007097          	auipc	ra,0x7
    104a:	fb2080e7          	jalr	-78(ra) # 7ff8 <printf>
      exit(1);
    104e:	4505                	li	a0,1
    1050:	00007097          	auipc	ra,0x7
    1054:	a7c080e7          	jalr	-1412(ra) # 7acc <exit>
    }
    close(fd);
    1058:	fe042783          	lw	a5,-32(s0)
    105c:	853e                	mv	a0,a5
    105e:	00007097          	auipc	ra,0x7
    1062:	a96080e7          	jalr	-1386(ra) # 7af4 <close>
  for(int i = 0; i < 150; i++){
    1066:	fe842783          	lw	a5,-24(s0)
    106a:	2785                	addiw	a5,a5,1
    106c:	fef42423          	sw	a5,-24(s0)
    1070:	fe842783          	lw	a5,-24(s0)
    1074:	0007871b          	sext.w	a4,a5
    1078:	09500793          	li	a5,149
    107c:	f4e7d5e3          	bge	a5,a4,fc6 <truncate3+0x178>
  }

  wait(&xstatus);
    1080:	fd040793          	addi	a5,s0,-48
    1084:	853e                	mv	a0,a5
    1086:	00007097          	auipc	ra,0x7
    108a:	a4e080e7          	jalr	-1458(ra) # 7ad4 <wait>
  unlink("truncfile");
    108e:	00007517          	auipc	a0,0x7
    1092:	5fa50513          	addi	a0,a0,1530 # 8688 <malloc+0x49c>
    1096:	00007097          	auipc	ra,0x7
    109a:	a86080e7          	jalr	-1402(ra) # 7b1c <unlink>
  exit(xstatus);
    109e:	fd042783          	lw	a5,-48(s0)
    10a2:	853e                	mv	a0,a5
    10a4:	00007097          	auipc	ra,0x7
    10a8:	a28080e7          	jalr	-1496(ra) # 7acc <exit>

00000000000010ac <iputtest>:
  

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(char *s)
{
    10ac:	1101                	addi	sp,sp,-32
    10ae:	ec06                	sd	ra,24(sp)
    10b0:	e822                	sd	s0,16(sp)
    10b2:	1000                	addi	s0,sp,32
    10b4:	fea43423          	sd	a0,-24(s0)
  if(mkdir("iputdir") < 0){
    10b8:	00007517          	auipc	a0,0x7
    10bc:	74050513          	addi	a0,a0,1856 # 87f8 <malloc+0x60c>
    10c0:	00007097          	auipc	ra,0x7
    10c4:	a74080e7          	jalr	-1420(ra) # 7b34 <mkdir>
    10c8:	87aa                	mv	a5,a0
    10ca:	0207d163          	bgez	a5,10ec <iputtest+0x40>
    printf("%s: mkdir failed\n", s);
    10ce:	fe843583          	ld	a1,-24(s0)
    10d2:	00007517          	auipc	a0,0x7
    10d6:	72e50513          	addi	a0,a0,1838 # 8800 <malloc+0x614>
    10da:	00007097          	auipc	ra,0x7
    10de:	f1e080e7          	jalr	-226(ra) # 7ff8 <printf>
    exit(1);
    10e2:	4505                	li	a0,1
    10e4:	00007097          	auipc	ra,0x7
    10e8:	9e8080e7          	jalr	-1560(ra) # 7acc <exit>
  }
  if(chdir("iputdir") < 0){
    10ec:	00007517          	auipc	a0,0x7
    10f0:	70c50513          	addi	a0,a0,1804 # 87f8 <malloc+0x60c>
    10f4:	00007097          	auipc	ra,0x7
    10f8:	a48080e7          	jalr	-1464(ra) # 7b3c <chdir>
    10fc:	87aa                	mv	a5,a0
    10fe:	0207d163          	bgez	a5,1120 <iputtest+0x74>
    printf("%s: chdir iputdir failed\n", s);
    1102:	fe843583          	ld	a1,-24(s0)
    1106:	00007517          	auipc	a0,0x7
    110a:	71250513          	addi	a0,a0,1810 # 8818 <malloc+0x62c>
    110e:	00007097          	auipc	ra,0x7
    1112:	eea080e7          	jalr	-278(ra) # 7ff8 <printf>
    exit(1);
    1116:	4505                	li	a0,1
    1118:	00007097          	auipc	ra,0x7
    111c:	9b4080e7          	jalr	-1612(ra) # 7acc <exit>
  }
  if(unlink("../iputdir") < 0){
    1120:	00007517          	auipc	a0,0x7
    1124:	71850513          	addi	a0,a0,1816 # 8838 <malloc+0x64c>
    1128:	00007097          	auipc	ra,0x7
    112c:	9f4080e7          	jalr	-1548(ra) # 7b1c <unlink>
    1130:	87aa                	mv	a5,a0
    1132:	0207d163          	bgez	a5,1154 <iputtest+0xa8>
    printf("%s: unlink ../iputdir failed\n", s);
    1136:	fe843583          	ld	a1,-24(s0)
    113a:	00007517          	auipc	a0,0x7
    113e:	70e50513          	addi	a0,a0,1806 # 8848 <malloc+0x65c>
    1142:	00007097          	auipc	ra,0x7
    1146:	eb6080e7          	jalr	-330(ra) # 7ff8 <printf>
    exit(1);
    114a:	4505                	li	a0,1
    114c:	00007097          	auipc	ra,0x7
    1150:	980080e7          	jalr	-1664(ra) # 7acc <exit>
  }
  if(chdir("/") < 0){
    1154:	00007517          	auipc	a0,0x7
    1158:	71450513          	addi	a0,a0,1812 # 8868 <malloc+0x67c>
    115c:	00007097          	auipc	ra,0x7
    1160:	9e0080e7          	jalr	-1568(ra) # 7b3c <chdir>
    1164:	87aa                	mv	a5,a0
    1166:	0207d163          	bgez	a5,1188 <iputtest+0xdc>
    printf("%s: chdir / failed\n", s);
    116a:	fe843583          	ld	a1,-24(s0)
    116e:	00007517          	auipc	a0,0x7
    1172:	70250513          	addi	a0,a0,1794 # 8870 <malloc+0x684>
    1176:	00007097          	auipc	ra,0x7
    117a:	e82080e7          	jalr	-382(ra) # 7ff8 <printf>
    exit(1);
    117e:	4505                	li	a0,1
    1180:	00007097          	auipc	ra,0x7
    1184:	94c080e7          	jalr	-1716(ra) # 7acc <exit>
  }
}
    1188:	0001                	nop
    118a:	60e2                	ld	ra,24(sp)
    118c:	6442                	ld	s0,16(sp)
    118e:	6105                	addi	sp,sp,32
    1190:	8082                	ret

0000000000001192 <exitiputtest>:

// does exit() call iput(p->cwd) in a transaction?
void
exitiputtest(char *s)
{
    1192:	7179                	addi	sp,sp,-48
    1194:	f406                	sd	ra,40(sp)
    1196:	f022                	sd	s0,32(sp)
    1198:	1800                	addi	s0,sp,48
    119a:	fca43c23          	sd	a0,-40(s0)
  int pid, xstatus;

  pid = fork();
    119e:	00007097          	auipc	ra,0x7
    11a2:	926080e7          	jalr	-1754(ra) # 7ac4 <fork>
    11a6:	87aa                	mv	a5,a0
    11a8:	fef42623          	sw	a5,-20(s0)
  if(pid < 0){
    11ac:	fec42783          	lw	a5,-20(s0)
    11b0:	2781                	sext.w	a5,a5
    11b2:	0207d163          	bgez	a5,11d4 <exitiputtest+0x42>
    printf("%s: fork failed\n", s);
    11b6:	fd843583          	ld	a1,-40(s0)
    11ba:	00007517          	auipc	a0,0x7
    11be:	5b650513          	addi	a0,a0,1462 # 8770 <malloc+0x584>
    11c2:	00007097          	auipc	ra,0x7
    11c6:	e36080e7          	jalr	-458(ra) # 7ff8 <printf>
    exit(1);
    11ca:	4505                	li	a0,1
    11cc:	00007097          	auipc	ra,0x7
    11d0:	900080e7          	jalr	-1792(ra) # 7acc <exit>
  }
  if(pid == 0){
    11d4:	fec42783          	lw	a5,-20(s0)
    11d8:	2781                	sext.w	a5,a5
    11da:	e7c5                	bnez	a5,1282 <exitiputtest+0xf0>
    if(mkdir("iputdir") < 0){
    11dc:	00007517          	auipc	a0,0x7
    11e0:	61c50513          	addi	a0,a0,1564 # 87f8 <malloc+0x60c>
    11e4:	00007097          	auipc	ra,0x7
    11e8:	950080e7          	jalr	-1712(ra) # 7b34 <mkdir>
    11ec:	87aa                	mv	a5,a0
    11ee:	0207d163          	bgez	a5,1210 <exitiputtest+0x7e>
      printf("%s: mkdir failed\n", s);
    11f2:	fd843583          	ld	a1,-40(s0)
    11f6:	00007517          	auipc	a0,0x7
    11fa:	60a50513          	addi	a0,a0,1546 # 8800 <malloc+0x614>
    11fe:	00007097          	auipc	ra,0x7
    1202:	dfa080e7          	jalr	-518(ra) # 7ff8 <printf>
      exit(1);
    1206:	4505                	li	a0,1
    1208:	00007097          	auipc	ra,0x7
    120c:	8c4080e7          	jalr	-1852(ra) # 7acc <exit>
    }
    if(chdir("iputdir") < 0){
    1210:	00007517          	auipc	a0,0x7
    1214:	5e850513          	addi	a0,a0,1512 # 87f8 <malloc+0x60c>
    1218:	00007097          	auipc	ra,0x7
    121c:	924080e7          	jalr	-1756(ra) # 7b3c <chdir>
    1220:	87aa                	mv	a5,a0
    1222:	0207d163          	bgez	a5,1244 <exitiputtest+0xb2>
      printf("%s: child chdir failed\n", s);
    1226:	fd843583          	ld	a1,-40(s0)
    122a:	00007517          	auipc	a0,0x7
    122e:	65e50513          	addi	a0,a0,1630 # 8888 <malloc+0x69c>
    1232:	00007097          	auipc	ra,0x7
    1236:	dc6080e7          	jalr	-570(ra) # 7ff8 <printf>
      exit(1);
    123a:	4505                	li	a0,1
    123c:	00007097          	auipc	ra,0x7
    1240:	890080e7          	jalr	-1904(ra) # 7acc <exit>
    }
    if(unlink("../iputdir") < 0){
    1244:	00007517          	auipc	a0,0x7
    1248:	5f450513          	addi	a0,a0,1524 # 8838 <malloc+0x64c>
    124c:	00007097          	auipc	ra,0x7
    1250:	8d0080e7          	jalr	-1840(ra) # 7b1c <unlink>
    1254:	87aa                	mv	a5,a0
    1256:	0207d163          	bgez	a5,1278 <exitiputtest+0xe6>
      printf("%s: unlink ../iputdir failed\n", s);
    125a:	fd843583          	ld	a1,-40(s0)
    125e:	00007517          	auipc	a0,0x7
    1262:	5ea50513          	addi	a0,a0,1514 # 8848 <malloc+0x65c>
    1266:	00007097          	auipc	ra,0x7
    126a:	d92080e7          	jalr	-622(ra) # 7ff8 <printf>
      exit(1);
    126e:	4505                	li	a0,1
    1270:	00007097          	auipc	ra,0x7
    1274:	85c080e7          	jalr	-1956(ra) # 7acc <exit>
    }
    exit(0);
    1278:	4501                	li	a0,0
    127a:	00007097          	auipc	ra,0x7
    127e:	852080e7          	jalr	-1966(ra) # 7acc <exit>
  }
  wait(&xstatus);
    1282:	fe840793          	addi	a5,s0,-24
    1286:	853e                	mv	a0,a5
    1288:	00007097          	auipc	ra,0x7
    128c:	84c080e7          	jalr	-1972(ra) # 7ad4 <wait>
  exit(xstatus);
    1290:	fe842783          	lw	a5,-24(s0)
    1294:	853e                	mv	a0,a5
    1296:	00007097          	auipc	ra,0x7
    129a:	836080e7          	jalr	-1994(ra) # 7acc <exit>

000000000000129e <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(char *s)
{
    129e:	7179                	addi	sp,sp,-48
    12a0:	f406                	sd	ra,40(sp)
    12a2:	f022                	sd	s0,32(sp)
    12a4:	1800                	addi	s0,sp,48
    12a6:	fca43c23          	sd	a0,-40(s0)
  int pid, xstatus;

  if(mkdir("oidir") < 0){
    12aa:	00007517          	auipc	a0,0x7
    12ae:	5f650513          	addi	a0,a0,1526 # 88a0 <malloc+0x6b4>
    12b2:	00007097          	auipc	ra,0x7
    12b6:	882080e7          	jalr	-1918(ra) # 7b34 <mkdir>
    12ba:	87aa                	mv	a5,a0
    12bc:	0207d163          	bgez	a5,12de <openiputtest+0x40>
    printf("%s: mkdir oidir failed\n", s);
    12c0:	fd843583          	ld	a1,-40(s0)
    12c4:	00007517          	auipc	a0,0x7
    12c8:	5e450513          	addi	a0,a0,1508 # 88a8 <malloc+0x6bc>
    12cc:	00007097          	auipc	ra,0x7
    12d0:	d2c080e7          	jalr	-724(ra) # 7ff8 <printf>
    exit(1);
    12d4:	4505                	li	a0,1
    12d6:	00006097          	auipc	ra,0x6
    12da:	7f6080e7          	jalr	2038(ra) # 7acc <exit>
  }
  pid = fork();
    12de:	00006097          	auipc	ra,0x6
    12e2:	7e6080e7          	jalr	2022(ra) # 7ac4 <fork>
    12e6:	87aa                	mv	a5,a0
    12e8:	fef42623          	sw	a5,-20(s0)
  if(pid < 0){
    12ec:	fec42783          	lw	a5,-20(s0)
    12f0:	2781                	sext.w	a5,a5
    12f2:	0207d163          	bgez	a5,1314 <openiputtest+0x76>
    printf("%s: fork failed\n", s);
    12f6:	fd843583          	ld	a1,-40(s0)
    12fa:	00007517          	auipc	a0,0x7
    12fe:	47650513          	addi	a0,a0,1142 # 8770 <malloc+0x584>
    1302:	00007097          	auipc	ra,0x7
    1306:	cf6080e7          	jalr	-778(ra) # 7ff8 <printf>
    exit(1);
    130a:	4505                	li	a0,1
    130c:	00006097          	auipc	ra,0x6
    1310:	7c0080e7          	jalr	1984(ra) # 7acc <exit>
  }
  if(pid == 0){
    1314:	fec42783          	lw	a5,-20(s0)
    1318:	2781                	sext.w	a5,a5
    131a:	e7b1                	bnez	a5,1366 <openiputtest+0xc8>
    int fd = open("oidir", O_RDWR);
    131c:	4589                	li	a1,2
    131e:	00007517          	auipc	a0,0x7
    1322:	58250513          	addi	a0,a0,1410 # 88a0 <malloc+0x6b4>
    1326:	00006097          	auipc	ra,0x6
    132a:	7e6080e7          	jalr	2022(ra) # 7b0c <open>
    132e:	87aa                	mv	a5,a0
    1330:	fef42423          	sw	a5,-24(s0)
    if(fd >= 0){
    1334:	fe842783          	lw	a5,-24(s0)
    1338:	2781                	sext.w	a5,a5
    133a:	0207c163          	bltz	a5,135c <openiputtest+0xbe>
      printf("%s: open directory for write succeeded\n", s);
    133e:	fd843583          	ld	a1,-40(s0)
    1342:	00007517          	auipc	a0,0x7
    1346:	57e50513          	addi	a0,a0,1406 # 88c0 <malloc+0x6d4>
    134a:	00007097          	auipc	ra,0x7
    134e:	cae080e7          	jalr	-850(ra) # 7ff8 <printf>
      exit(1);
    1352:	4505                	li	a0,1
    1354:	00006097          	auipc	ra,0x6
    1358:	778080e7          	jalr	1912(ra) # 7acc <exit>
    }
    exit(0);
    135c:	4501                	li	a0,0
    135e:	00006097          	auipc	ra,0x6
    1362:	76e080e7          	jalr	1902(ra) # 7acc <exit>
  }
  sleep(1);
    1366:	4505                	li	a0,1
    1368:	00006097          	auipc	ra,0x6
    136c:	7f4080e7          	jalr	2036(ra) # 7b5c <sleep>
  if(unlink("oidir") != 0){
    1370:	00007517          	auipc	a0,0x7
    1374:	53050513          	addi	a0,a0,1328 # 88a0 <malloc+0x6b4>
    1378:	00006097          	auipc	ra,0x6
    137c:	7a4080e7          	jalr	1956(ra) # 7b1c <unlink>
    1380:	87aa                	mv	a5,a0
    1382:	c385                	beqz	a5,13a2 <openiputtest+0x104>
    printf("%s: unlink failed\n", s);
    1384:	fd843583          	ld	a1,-40(s0)
    1388:	00007517          	auipc	a0,0x7
    138c:	56050513          	addi	a0,a0,1376 # 88e8 <malloc+0x6fc>
    1390:	00007097          	auipc	ra,0x7
    1394:	c68080e7          	jalr	-920(ra) # 7ff8 <printf>
    exit(1);
    1398:	4505                	li	a0,1
    139a:	00006097          	auipc	ra,0x6
    139e:	732080e7          	jalr	1842(ra) # 7acc <exit>
  }
  wait(&xstatus);
    13a2:	fe440793          	addi	a5,s0,-28
    13a6:	853e                	mv	a0,a5
    13a8:	00006097          	auipc	ra,0x6
    13ac:	72c080e7          	jalr	1836(ra) # 7ad4 <wait>
  exit(xstatus);
    13b0:	fe442783          	lw	a5,-28(s0)
    13b4:	853e                	mv	a0,a5
    13b6:	00006097          	auipc	ra,0x6
    13ba:	716080e7          	jalr	1814(ra) # 7acc <exit>

00000000000013be <opentest>:

// simple file system tests

void
opentest(char *s)
{
    13be:	7179                	addi	sp,sp,-48
    13c0:	f406                	sd	ra,40(sp)
    13c2:	f022                	sd	s0,32(sp)
    13c4:	1800                	addi	s0,sp,48
    13c6:	fca43c23          	sd	a0,-40(s0)
  int fd;

  fd = open("echo", 0);
    13ca:	4581                	li	a1,0
    13cc:	00007517          	auipc	a0,0x7
    13d0:	18450513          	addi	a0,a0,388 # 8550 <malloc+0x364>
    13d4:	00006097          	auipc	ra,0x6
    13d8:	738080e7          	jalr	1848(ra) # 7b0c <open>
    13dc:	87aa                	mv	a5,a0
    13de:	fef42623          	sw	a5,-20(s0)
  if(fd < 0){
    13e2:	fec42783          	lw	a5,-20(s0)
    13e6:	2781                	sext.w	a5,a5
    13e8:	0207d163          	bgez	a5,140a <opentest+0x4c>
    printf("%s: open echo failed!\n", s);
    13ec:	fd843583          	ld	a1,-40(s0)
    13f0:	00007517          	auipc	a0,0x7
    13f4:	51050513          	addi	a0,a0,1296 # 8900 <malloc+0x714>
    13f8:	00007097          	auipc	ra,0x7
    13fc:	c00080e7          	jalr	-1024(ra) # 7ff8 <printf>
    exit(1);
    1400:	4505                	li	a0,1
    1402:	00006097          	auipc	ra,0x6
    1406:	6ca080e7          	jalr	1738(ra) # 7acc <exit>
  }
  close(fd);
    140a:	fec42783          	lw	a5,-20(s0)
    140e:	853e                	mv	a0,a5
    1410:	00006097          	auipc	ra,0x6
    1414:	6e4080e7          	jalr	1764(ra) # 7af4 <close>
  fd = open("doesnotexist", 0);
    1418:	4581                	li	a1,0
    141a:	00007517          	auipc	a0,0x7
    141e:	4fe50513          	addi	a0,a0,1278 # 8918 <malloc+0x72c>
    1422:	00006097          	auipc	ra,0x6
    1426:	6ea080e7          	jalr	1770(ra) # 7b0c <open>
    142a:	87aa                	mv	a5,a0
    142c:	fef42623          	sw	a5,-20(s0)
  if(fd >= 0){
    1430:	fec42783          	lw	a5,-20(s0)
    1434:	2781                	sext.w	a5,a5
    1436:	0207c163          	bltz	a5,1458 <opentest+0x9a>
    printf("%s: open doesnotexist succeeded!\n", s);
    143a:	fd843583          	ld	a1,-40(s0)
    143e:	00007517          	auipc	a0,0x7
    1442:	4ea50513          	addi	a0,a0,1258 # 8928 <malloc+0x73c>
    1446:	00007097          	auipc	ra,0x7
    144a:	bb2080e7          	jalr	-1102(ra) # 7ff8 <printf>
    exit(1);
    144e:	4505                	li	a0,1
    1450:	00006097          	auipc	ra,0x6
    1454:	67c080e7          	jalr	1660(ra) # 7acc <exit>
  }
}
    1458:	0001                	nop
    145a:	70a2                	ld	ra,40(sp)
    145c:	7402                	ld	s0,32(sp)
    145e:	6145                	addi	sp,sp,48
    1460:	8082                	ret

0000000000001462 <writetest>:

void
writetest(char *s)
{
    1462:	7179                	addi	sp,sp,-48
    1464:	f406                	sd	ra,40(sp)
    1466:	f022                	sd	s0,32(sp)
    1468:	1800                	addi	s0,sp,48
    146a:	fca43c23          	sd	a0,-40(s0)
  int fd;
  int i;
  enum { N=100, SZ=10 };
  
  fd = open("small", O_CREATE|O_RDWR);
    146e:	20200593          	li	a1,514
    1472:	00007517          	auipc	a0,0x7
    1476:	4de50513          	addi	a0,a0,1246 # 8950 <malloc+0x764>
    147a:	00006097          	auipc	ra,0x6
    147e:	692080e7          	jalr	1682(ra) # 7b0c <open>
    1482:	87aa                	mv	a5,a0
    1484:	fef42423          	sw	a5,-24(s0)
  if(fd < 0){
    1488:	fe842783          	lw	a5,-24(s0)
    148c:	2781                	sext.w	a5,a5
    148e:	0207d163          	bgez	a5,14b0 <writetest+0x4e>
    printf("%s: error: creat small failed!\n", s);
    1492:	fd843583          	ld	a1,-40(s0)
    1496:	00007517          	auipc	a0,0x7
    149a:	4c250513          	addi	a0,a0,1218 # 8958 <malloc+0x76c>
    149e:	00007097          	auipc	ra,0x7
    14a2:	b5a080e7          	jalr	-1190(ra) # 7ff8 <printf>
    exit(1);
    14a6:	4505                	li	a0,1
    14a8:	00006097          	auipc	ra,0x6
    14ac:	624080e7          	jalr	1572(ra) # 7acc <exit>
  }
  for(i = 0; i < N; i++){
    14b0:	fe042623          	sw	zero,-20(s0)
    14b4:	a861                	j	154c <writetest+0xea>
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
    14b6:	fe842783          	lw	a5,-24(s0)
    14ba:	4629                	li	a2,10
    14bc:	00007597          	auipc	a1,0x7
    14c0:	4bc58593          	addi	a1,a1,1212 # 8978 <malloc+0x78c>
    14c4:	853e                	mv	a0,a5
    14c6:	00006097          	auipc	ra,0x6
    14ca:	626080e7          	jalr	1574(ra) # 7aec <write>
    14ce:	87aa                	mv	a5,a0
    14d0:	873e                	mv	a4,a5
    14d2:	47a9                	li	a5,10
    14d4:	02f70463          	beq	a4,a5,14fc <writetest+0x9a>
      printf("%s: error: write aa %d new file failed\n", s, i);
    14d8:	fec42783          	lw	a5,-20(s0)
    14dc:	863e                	mv	a2,a5
    14de:	fd843583          	ld	a1,-40(s0)
    14e2:	00007517          	auipc	a0,0x7
    14e6:	4a650513          	addi	a0,a0,1190 # 8988 <malloc+0x79c>
    14ea:	00007097          	auipc	ra,0x7
    14ee:	b0e080e7          	jalr	-1266(ra) # 7ff8 <printf>
      exit(1);
    14f2:	4505                	li	a0,1
    14f4:	00006097          	auipc	ra,0x6
    14f8:	5d8080e7          	jalr	1496(ra) # 7acc <exit>
    }
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
    14fc:	fe842783          	lw	a5,-24(s0)
    1500:	4629                	li	a2,10
    1502:	00007597          	auipc	a1,0x7
    1506:	4ae58593          	addi	a1,a1,1198 # 89b0 <malloc+0x7c4>
    150a:	853e                	mv	a0,a5
    150c:	00006097          	auipc	ra,0x6
    1510:	5e0080e7          	jalr	1504(ra) # 7aec <write>
    1514:	87aa                	mv	a5,a0
    1516:	873e                	mv	a4,a5
    1518:	47a9                	li	a5,10
    151a:	02f70463          	beq	a4,a5,1542 <writetest+0xe0>
      printf("%s: error: write bb %d new file failed\n", s, i);
    151e:	fec42783          	lw	a5,-20(s0)
    1522:	863e                	mv	a2,a5
    1524:	fd843583          	ld	a1,-40(s0)
    1528:	00007517          	auipc	a0,0x7
    152c:	49850513          	addi	a0,a0,1176 # 89c0 <malloc+0x7d4>
    1530:	00007097          	auipc	ra,0x7
    1534:	ac8080e7          	jalr	-1336(ra) # 7ff8 <printf>
      exit(1);
    1538:	4505                	li	a0,1
    153a:	00006097          	auipc	ra,0x6
    153e:	592080e7          	jalr	1426(ra) # 7acc <exit>
  for(i = 0; i < N; i++){
    1542:	fec42783          	lw	a5,-20(s0)
    1546:	2785                	addiw	a5,a5,1
    1548:	fef42623          	sw	a5,-20(s0)
    154c:	fec42783          	lw	a5,-20(s0)
    1550:	0007871b          	sext.w	a4,a5
    1554:	06300793          	li	a5,99
    1558:	f4e7dfe3          	bge	a5,a4,14b6 <writetest+0x54>
    }
  }
  close(fd);
    155c:	fe842783          	lw	a5,-24(s0)
    1560:	853e                	mv	a0,a5
    1562:	00006097          	auipc	ra,0x6
    1566:	592080e7          	jalr	1426(ra) # 7af4 <close>
  fd = open("small", O_RDONLY);
    156a:	4581                	li	a1,0
    156c:	00007517          	auipc	a0,0x7
    1570:	3e450513          	addi	a0,a0,996 # 8950 <malloc+0x764>
    1574:	00006097          	auipc	ra,0x6
    1578:	598080e7          	jalr	1432(ra) # 7b0c <open>
    157c:	87aa                	mv	a5,a0
    157e:	fef42423          	sw	a5,-24(s0)
  if(fd < 0){
    1582:	fe842783          	lw	a5,-24(s0)
    1586:	2781                	sext.w	a5,a5
    1588:	0207d163          	bgez	a5,15aa <writetest+0x148>
    printf("%s: error: open small failed!\n", s);
    158c:	fd843583          	ld	a1,-40(s0)
    1590:	00007517          	auipc	a0,0x7
    1594:	45850513          	addi	a0,a0,1112 # 89e8 <malloc+0x7fc>
    1598:	00007097          	auipc	ra,0x7
    159c:	a60080e7          	jalr	-1440(ra) # 7ff8 <printf>
    exit(1);
    15a0:	4505                	li	a0,1
    15a2:	00006097          	auipc	ra,0x6
    15a6:	52a080e7          	jalr	1322(ra) # 7acc <exit>
  }
  i = read(fd, buf, N*SZ*2);
    15aa:	fe842783          	lw	a5,-24(s0)
    15ae:	7d000613          	li	a2,2000
    15b2:	0000a597          	auipc	a1,0xa
    15b6:	ebe58593          	addi	a1,a1,-322 # b470 <buf>
    15ba:	853e                	mv	a0,a5
    15bc:	00006097          	auipc	ra,0x6
    15c0:	528080e7          	jalr	1320(ra) # 7ae4 <read>
    15c4:	87aa                	mv	a5,a0
    15c6:	fef42623          	sw	a5,-20(s0)
  if(i != N*SZ*2){
    15ca:	fec42783          	lw	a5,-20(s0)
    15ce:	0007871b          	sext.w	a4,a5
    15d2:	7d000793          	li	a5,2000
    15d6:	02f70163          	beq	a4,a5,15f8 <writetest+0x196>
    printf("%s: read failed\n", s);
    15da:	fd843583          	ld	a1,-40(s0)
    15de:	00007517          	auipc	a0,0x7
    15e2:	42a50513          	addi	a0,a0,1066 # 8a08 <malloc+0x81c>
    15e6:	00007097          	auipc	ra,0x7
    15ea:	a12080e7          	jalr	-1518(ra) # 7ff8 <printf>
    exit(1);
    15ee:	4505                	li	a0,1
    15f0:	00006097          	auipc	ra,0x6
    15f4:	4dc080e7          	jalr	1244(ra) # 7acc <exit>
  }
  close(fd);
    15f8:	fe842783          	lw	a5,-24(s0)
    15fc:	853e                	mv	a0,a5
    15fe:	00006097          	auipc	ra,0x6
    1602:	4f6080e7          	jalr	1270(ra) # 7af4 <close>

  if(unlink("small") < 0){
    1606:	00007517          	auipc	a0,0x7
    160a:	34a50513          	addi	a0,a0,842 # 8950 <malloc+0x764>
    160e:	00006097          	auipc	ra,0x6
    1612:	50e080e7          	jalr	1294(ra) # 7b1c <unlink>
    1616:	87aa                	mv	a5,a0
    1618:	0207d163          	bgez	a5,163a <writetest+0x1d8>
    printf("%s: unlink small failed\n", s);
    161c:	fd843583          	ld	a1,-40(s0)
    1620:	00007517          	auipc	a0,0x7
    1624:	40050513          	addi	a0,a0,1024 # 8a20 <malloc+0x834>
    1628:	00007097          	auipc	ra,0x7
    162c:	9d0080e7          	jalr	-1584(ra) # 7ff8 <printf>
    exit(1);
    1630:	4505                	li	a0,1
    1632:	00006097          	auipc	ra,0x6
    1636:	49a080e7          	jalr	1178(ra) # 7acc <exit>
  }
}
    163a:	0001                	nop
    163c:	70a2                	ld	ra,40(sp)
    163e:	7402                	ld	s0,32(sp)
    1640:	6145                	addi	sp,sp,48
    1642:	8082                	ret

0000000000001644 <writebig>:

void
writebig(char *s)
{
    1644:	7179                	addi	sp,sp,-48
    1646:	f406                	sd	ra,40(sp)
    1648:	f022                	sd	s0,32(sp)
    164a:	1800                	addi	s0,sp,48
    164c:	fca43c23          	sd	a0,-40(s0)
  int i, fd, n;

  fd = open("big", O_CREATE|O_RDWR);
    1650:	20200593          	li	a1,514
    1654:	00007517          	auipc	a0,0x7
    1658:	3ec50513          	addi	a0,a0,1004 # 8a40 <malloc+0x854>
    165c:	00006097          	auipc	ra,0x6
    1660:	4b0080e7          	jalr	1200(ra) # 7b0c <open>
    1664:	87aa                	mv	a5,a0
    1666:	fef42223          	sw	a5,-28(s0)
  if(fd < 0){
    166a:	fe442783          	lw	a5,-28(s0)
    166e:	2781                	sext.w	a5,a5
    1670:	0207d163          	bgez	a5,1692 <writebig+0x4e>
    printf("%s: error: creat big failed!\n", s);
    1674:	fd843583          	ld	a1,-40(s0)
    1678:	00007517          	auipc	a0,0x7
    167c:	3d050513          	addi	a0,a0,976 # 8a48 <malloc+0x85c>
    1680:	00007097          	auipc	ra,0x7
    1684:	978080e7          	jalr	-1672(ra) # 7ff8 <printf>
    exit(1);
    1688:	4505                	li	a0,1
    168a:	00006097          	auipc	ra,0x6
    168e:	442080e7          	jalr	1090(ra) # 7acc <exit>
  }

  for(i = 0; i < MAXFILE; i++){
    1692:	fe042623          	sw	zero,-20(s0)
    1696:	a095                	j	16fa <writebig+0xb6>
    ((int*)buf)[0] = i;
    1698:	0000a797          	auipc	a5,0xa
    169c:	dd878793          	addi	a5,a5,-552 # b470 <buf>
    16a0:	fec42703          	lw	a4,-20(s0)
    16a4:	c398                	sw	a4,0(a5)
    if(write(fd, buf, BSIZE) != BSIZE){
    16a6:	fe442783          	lw	a5,-28(s0)
    16aa:	40000613          	li	a2,1024
    16ae:	0000a597          	auipc	a1,0xa
    16b2:	dc258593          	addi	a1,a1,-574 # b470 <buf>
    16b6:	853e                	mv	a0,a5
    16b8:	00006097          	auipc	ra,0x6
    16bc:	434080e7          	jalr	1076(ra) # 7aec <write>
    16c0:	87aa                	mv	a5,a0
    16c2:	873e                	mv	a4,a5
    16c4:	40000793          	li	a5,1024
    16c8:	02f70463          	beq	a4,a5,16f0 <writebig+0xac>
      printf("%s: error: write big file failed\n", s, i);
    16cc:	fec42783          	lw	a5,-20(s0)
    16d0:	863e                	mv	a2,a5
    16d2:	fd843583          	ld	a1,-40(s0)
    16d6:	00007517          	auipc	a0,0x7
    16da:	39250513          	addi	a0,a0,914 # 8a68 <malloc+0x87c>
    16de:	00007097          	auipc	ra,0x7
    16e2:	91a080e7          	jalr	-1766(ra) # 7ff8 <printf>
      exit(1);
    16e6:	4505                	li	a0,1
    16e8:	00006097          	auipc	ra,0x6
    16ec:	3e4080e7          	jalr	996(ra) # 7acc <exit>
  for(i = 0; i < MAXFILE; i++){
    16f0:	fec42783          	lw	a5,-20(s0)
    16f4:	2785                	addiw	a5,a5,1
    16f6:	fef42623          	sw	a5,-20(s0)
    16fa:	fec42703          	lw	a4,-20(s0)
    16fe:	10b00793          	li	a5,267
    1702:	f8e7fbe3          	bgeu	a5,a4,1698 <writebig+0x54>
    }
  }

  close(fd);
    1706:	fe442783          	lw	a5,-28(s0)
    170a:	853e                	mv	a0,a5
    170c:	00006097          	auipc	ra,0x6
    1710:	3e8080e7          	jalr	1000(ra) # 7af4 <close>

  fd = open("big", O_RDONLY);
    1714:	4581                	li	a1,0
    1716:	00007517          	auipc	a0,0x7
    171a:	32a50513          	addi	a0,a0,810 # 8a40 <malloc+0x854>
    171e:	00006097          	auipc	ra,0x6
    1722:	3ee080e7          	jalr	1006(ra) # 7b0c <open>
    1726:	87aa                	mv	a5,a0
    1728:	fef42223          	sw	a5,-28(s0)
  if(fd < 0){
    172c:	fe442783          	lw	a5,-28(s0)
    1730:	2781                	sext.w	a5,a5
    1732:	0207d163          	bgez	a5,1754 <writebig+0x110>
    printf("%s: error: open big failed!\n", s);
    1736:	fd843583          	ld	a1,-40(s0)
    173a:	00007517          	auipc	a0,0x7
    173e:	35650513          	addi	a0,a0,854 # 8a90 <malloc+0x8a4>
    1742:	00007097          	auipc	ra,0x7
    1746:	8b6080e7          	jalr	-1866(ra) # 7ff8 <printf>
    exit(1);
    174a:	4505                	li	a0,1
    174c:	00006097          	auipc	ra,0x6
    1750:	380080e7          	jalr	896(ra) # 7acc <exit>
  }

  n = 0;
    1754:	fe042423          	sw	zero,-24(s0)
  for(;;){
    i = read(fd, buf, BSIZE);
    1758:	fe442783          	lw	a5,-28(s0)
    175c:	40000613          	li	a2,1024
    1760:	0000a597          	auipc	a1,0xa
    1764:	d1058593          	addi	a1,a1,-752 # b470 <buf>
    1768:	853e                	mv	a0,a5
    176a:	00006097          	auipc	ra,0x6
    176e:	37a080e7          	jalr	890(ra) # 7ae4 <read>
    1772:	87aa                	mv	a5,a0
    1774:	fef42623          	sw	a5,-20(s0)
    if(i == 0){
    1778:	fec42783          	lw	a5,-20(s0)
    177c:	2781                	sext.w	a5,a5
    177e:	eb9d                	bnez	a5,17b4 <writebig+0x170>
      if(n == MAXFILE - 1){
    1780:	fe842783          	lw	a5,-24(s0)
    1784:	0007871b          	sext.w	a4,a5
    1788:	10b00793          	li	a5,267
    178c:	0af71663          	bne	a4,a5,1838 <writebig+0x1f4>
        printf("%s: read only %d blocks from big", s, n);
    1790:	fe842783          	lw	a5,-24(s0)
    1794:	863e                	mv	a2,a5
    1796:	fd843583          	ld	a1,-40(s0)
    179a:	00007517          	auipc	a0,0x7
    179e:	31650513          	addi	a0,a0,790 # 8ab0 <malloc+0x8c4>
    17a2:	00007097          	auipc	ra,0x7
    17a6:	856080e7          	jalr	-1962(ra) # 7ff8 <printf>
        exit(1);
    17aa:	4505                	li	a0,1
    17ac:	00006097          	auipc	ra,0x6
    17b0:	320080e7          	jalr	800(ra) # 7acc <exit>
      }
      break;
    } else if(i != BSIZE){
    17b4:	fec42783          	lw	a5,-20(s0)
    17b8:	0007871b          	sext.w	a4,a5
    17bc:	40000793          	li	a5,1024
    17c0:	02f70463          	beq	a4,a5,17e8 <writebig+0x1a4>
      printf("%s: read failed %d\n", s, i);
    17c4:	fec42783          	lw	a5,-20(s0)
    17c8:	863e                	mv	a2,a5
    17ca:	fd843583          	ld	a1,-40(s0)
    17ce:	00007517          	auipc	a0,0x7
    17d2:	30a50513          	addi	a0,a0,778 # 8ad8 <malloc+0x8ec>
    17d6:	00007097          	auipc	ra,0x7
    17da:	822080e7          	jalr	-2014(ra) # 7ff8 <printf>
      exit(1);
    17de:	4505                	li	a0,1
    17e0:	00006097          	auipc	ra,0x6
    17e4:	2ec080e7          	jalr	748(ra) # 7acc <exit>
    }
    if(((int*)buf)[0] != n){
    17e8:	0000a797          	auipc	a5,0xa
    17ec:	c8878793          	addi	a5,a5,-888 # b470 <buf>
    17f0:	439c                	lw	a5,0(a5)
    17f2:	fe842703          	lw	a4,-24(s0)
    17f6:	2701                	sext.w	a4,a4
    17f8:	02f70a63          	beq	a4,a5,182c <writebig+0x1e8>
      printf("%s: read content of block %d is %d\n", s,
             n, ((int*)buf)[0]);
    17fc:	0000a797          	auipc	a5,0xa
    1800:	c7478793          	addi	a5,a5,-908 # b470 <buf>
      printf("%s: read content of block %d is %d\n", s,
    1804:	4398                	lw	a4,0(a5)
    1806:	fe842783          	lw	a5,-24(s0)
    180a:	86ba                	mv	a3,a4
    180c:	863e                	mv	a2,a5
    180e:	fd843583          	ld	a1,-40(s0)
    1812:	00007517          	auipc	a0,0x7
    1816:	2de50513          	addi	a0,a0,734 # 8af0 <malloc+0x904>
    181a:	00006097          	auipc	ra,0x6
    181e:	7de080e7          	jalr	2014(ra) # 7ff8 <printf>
      exit(1);
    1822:	4505                	li	a0,1
    1824:	00006097          	auipc	ra,0x6
    1828:	2a8080e7          	jalr	680(ra) # 7acc <exit>
    }
    n++;
    182c:	fe842783          	lw	a5,-24(s0)
    1830:	2785                	addiw	a5,a5,1
    1832:	fef42423          	sw	a5,-24(s0)
    i = read(fd, buf, BSIZE);
    1836:	b70d                	j	1758 <writebig+0x114>
      break;
    1838:	0001                	nop
  }
  close(fd);
    183a:	fe442783          	lw	a5,-28(s0)
    183e:	853e                	mv	a0,a5
    1840:	00006097          	auipc	ra,0x6
    1844:	2b4080e7          	jalr	692(ra) # 7af4 <close>
  if(unlink("big") < 0){
    1848:	00007517          	auipc	a0,0x7
    184c:	1f850513          	addi	a0,a0,504 # 8a40 <malloc+0x854>
    1850:	00006097          	auipc	ra,0x6
    1854:	2cc080e7          	jalr	716(ra) # 7b1c <unlink>
    1858:	87aa                	mv	a5,a0
    185a:	0207d163          	bgez	a5,187c <writebig+0x238>
    printf("%s: unlink big failed\n", s);
    185e:	fd843583          	ld	a1,-40(s0)
    1862:	00007517          	auipc	a0,0x7
    1866:	2b650513          	addi	a0,a0,694 # 8b18 <malloc+0x92c>
    186a:	00006097          	auipc	ra,0x6
    186e:	78e080e7          	jalr	1934(ra) # 7ff8 <printf>
    exit(1);
    1872:	4505                	li	a0,1
    1874:	00006097          	auipc	ra,0x6
    1878:	258080e7          	jalr	600(ra) # 7acc <exit>
  }
}
    187c:	0001                	nop
    187e:	70a2                	ld	ra,40(sp)
    1880:	7402                	ld	s0,32(sp)
    1882:	6145                	addi	sp,sp,48
    1884:	8082                	ret

0000000000001886 <createtest>:

// many creates, followed by unlink test
void
createtest(char *s)
{
    1886:	7179                	addi	sp,sp,-48
    1888:	f406                	sd	ra,40(sp)
    188a:	f022                	sd	s0,32(sp)
    188c:	1800                	addi	s0,sp,48
    188e:	fca43c23          	sd	a0,-40(s0)
  int i, fd;
  enum { N=52 };

  char name[3];
  name[0] = 'a';
    1892:	06100793          	li	a5,97
    1896:	fef40023          	sb	a5,-32(s0)
  name[2] = '\0';
    189a:	fe040123          	sb	zero,-30(s0)
  for(i = 0; i < N; i++){
    189e:	fe042623          	sw	zero,-20(s0)
    18a2:	a099                	j	18e8 <createtest+0x62>
    name[1] = '0' + i;
    18a4:	fec42783          	lw	a5,-20(s0)
    18a8:	0ff7f793          	zext.b	a5,a5
    18ac:	0307879b          	addiw	a5,a5,48
    18b0:	0ff7f793          	zext.b	a5,a5
    18b4:	fef400a3          	sb	a5,-31(s0)
    fd = open(name, O_CREATE|O_RDWR);
    18b8:	fe040793          	addi	a5,s0,-32
    18bc:	20200593          	li	a1,514
    18c0:	853e                	mv	a0,a5
    18c2:	00006097          	auipc	ra,0x6
    18c6:	24a080e7          	jalr	586(ra) # 7b0c <open>
    18ca:	87aa                	mv	a5,a0
    18cc:	fef42423          	sw	a5,-24(s0)
    close(fd);
    18d0:	fe842783          	lw	a5,-24(s0)
    18d4:	853e                	mv	a0,a5
    18d6:	00006097          	auipc	ra,0x6
    18da:	21e080e7          	jalr	542(ra) # 7af4 <close>
  for(i = 0; i < N; i++){
    18de:	fec42783          	lw	a5,-20(s0)
    18e2:	2785                	addiw	a5,a5,1
    18e4:	fef42623          	sw	a5,-20(s0)
    18e8:	fec42783          	lw	a5,-20(s0)
    18ec:	0007871b          	sext.w	a4,a5
    18f0:	03300793          	li	a5,51
    18f4:	fae7d8e3          	bge	a5,a4,18a4 <createtest+0x1e>
  }
  name[0] = 'a';
    18f8:	06100793          	li	a5,97
    18fc:	fef40023          	sb	a5,-32(s0)
  name[2] = '\0';
    1900:	fe040123          	sb	zero,-30(s0)
  for(i = 0; i < N; i++){
    1904:	fe042623          	sw	zero,-20(s0)
    1908:	a03d                	j	1936 <createtest+0xb0>
    name[1] = '0' + i;
    190a:	fec42783          	lw	a5,-20(s0)
    190e:	0ff7f793          	zext.b	a5,a5
    1912:	0307879b          	addiw	a5,a5,48
    1916:	0ff7f793          	zext.b	a5,a5
    191a:	fef400a3          	sb	a5,-31(s0)
    unlink(name);
    191e:	fe040793          	addi	a5,s0,-32
    1922:	853e                	mv	a0,a5
    1924:	00006097          	auipc	ra,0x6
    1928:	1f8080e7          	jalr	504(ra) # 7b1c <unlink>
  for(i = 0; i < N; i++){
    192c:	fec42783          	lw	a5,-20(s0)
    1930:	2785                	addiw	a5,a5,1
    1932:	fef42623          	sw	a5,-20(s0)
    1936:	fec42783          	lw	a5,-20(s0)
    193a:	0007871b          	sext.w	a4,a5
    193e:	03300793          	li	a5,51
    1942:	fce7d4e3          	bge	a5,a4,190a <createtest+0x84>
  }
}
    1946:	0001                	nop
    1948:	0001                	nop
    194a:	70a2                	ld	ra,40(sp)
    194c:	7402                	ld	s0,32(sp)
    194e:	6145                	addi	sp,sp,48
    1950:	8082                	ret

0000000000001952 <dirtest>:

void dirtest(char *s)
{
    1952:	1101                	addi	sp,sp,-32
    1954:	ec06                	sd	ra,24(sp)
    1956:	e822                	sd	s0,16(sp)
    1958:	1000                	addi	s0,sp,32
    195a:	fea43423          	sd	a0,-24(s0)
  if(mkdir("dir0") < 0){
    195e:	00007517          	auipc	a0,0x7
    1962:	1d250513          	addi	a0,a0,466 # 8b30 <malloc+0x944>
    1966:	00006097          	auipc	ra,0x6
    196a:	1ce080e7          	jalr	462(ra) # 7b34 <mkdir>
    196e:	87aa                	mv	a5,a0
    1970:	0207d163          	bgez	a5,1992 <dirtest+0x40>
    printf("%s: mkdir failed\n", s);
    1974:	fe843583          	ld	a1,-24(s0)
    1978:	00007517          	auipc	a0,0x7
    197c:	e8850513          	addi	a0,a0,-376 # 8800 <malloc+0x614>
    1980:	00006097          	auipc	ra,0x6
    1984:	678080e7          	jalr	1656(ra) # 7ff8 <printf>
    exit(1);
    1988:	4505                	li	a0,1
    198a:	00006097          	auipc	ra,0x6
    198e:	142080e7          	jalr	322(ra) # 7acc <exit>
  }

  if(chdir("dir0") < 0){
    1992:	00007517          	auipc	a0,0x7
    1996:	19e50513          	addi	a0,a0,414 # 8b30 <malloc+0x944>
    199a:	00006097          	auipc	ra,0x6
    199e:	1a2080e7          	jalr	418(ra) # 7b3c <chdir>
    19a2:	87aa                	mv	a5,a0
    19a4:	0207d163          	bgez	a5,19c6 <dirtest+0x74>
    printf("%s: chdir dir0 failed\n", s);
    19a8:	fe843583          	ld	a1,-24(s0)
    19ac:	00007517          	auipc	a0,0x7
    19b0:	18c50513          	addi	a0,a0,396 # 8b38 <malloc+0x94c>
    19b4:	00006097          	auipc	ra,0x6
    19b8:	644080e7          	jalr	1604(ra) # 7ff8 <printf>
    exit(1);
    19bc:	4505                	li	a0,1
    19be:	00006097          	auipc	ra,0x6
    19c2:	10e080e7          	jalr	270(ra) # 7acc <exit>
  }

  if(chdir("..") < 0){
    19c6:	00007517          	auipc	a0,0x7
    19ca:	18a50513          	addi	a0,a0,394 # 8b50 <malloc+0x964>
    19ce:	00006097          	auipc	ra,0x6
    19d2:	16e080e7          	jalr	366(ra) # 7b3c <chdir>
    19d6:	87aa                	mv	a5,a0
    19d8:	0207d163          	bgez	a5,19fa <dirtest+0xa8>
    printf("%s: chdir .. failed\n", s);
    19dc:	fe843583          	ld	a1,-24(s0)
    19e0:	00007517          	auipc	a0,0x7
    19e4:	17850513          	addi	a0,a0,376 # 8b58 <malloc+0x96c>
    19e8:	00006097          	auipc	ra,0x6
    19ec:	610080e7          	jalr	1552(ra) # 7ff8 <printf>
    exit(1);
    19f0:	4505                	li	a0,1
    19f2:	00006097          	auipc	ra,0x6
    19f6:	0da080e7          	jalr	218(ra) # 7acc <exit>
  }

  if(unlink("dir0") < 0){
    19fa:	00007517          	auipc	a0,0x7
    19fe:	13650513          	addi	a0,a0,310 # 8b30 <malloc+0x944>
    1a02:	00006097          	auipc	ra,0x6
    1a06:	11a080e7          	jalr	282(ra) # 7b1c <unlink>
    1a0a:	87aa                	mv	a5,a0
    1a0c:	0207d163          	bgez	a5,1a2e <dirtest+0xdc>
    printf("%s: unlink dir0 failed\n", s);
    1a10:	fe843583          	ld	a1,-24(s0)
    1a14:	00007517          	auipc	a0,0x7
    1a18:	15c50513          	addi	a0,a0,348 # 8b70 <malloc+0x984>
    1a1c:	00006097          	auipc	ra,0x6
    1a20:	5dc080e7          	jalr	1500(ra) # 7ff8 <printf>
    exit(1);
    1a24:	4505                	li	a0,1
    1a26:	00006097          	auipc	ra,0x6
    1a2a:	0a6080e7          	jalr	166(ra) # 7acc <exit>
  }
}
    1a2e:	0001                	nop
    1a30:	60e2                	ld	ra,24(sp)
    1a32:	6442                	ld	s0,16(sp)
    1a34:	6105                	addi	sp,sp,32
    1a36:	8082                	ret

0000000000001a38 <exectest>:

void
exectest(char *s)
{
    1a38:	715d                	addi	sp,sp,-80
    1a3a:	e486                	sd	ra,72(sp)
    1a3c:	e0a2                	sd	s0,64(sp)
    1a3e:	0880                	addi	s0,sp,80
    1a40:	faa43c23          	sd	a0,-72(s0)
  int fd, xstatus, pid;
  char *echoargv[] = { "echo", "OK", 0 };
    1a44:	00007797          	auipc	a5,0x7
    1a48:	b0c78793          	addi	a5,a5,-1268 # 8550 <malloc+0x364>
    1a4c:	fcf43423          	sd	a5,-56(s0)
    1a50:	00007797          	auipc	a5,0x7
    1a54:	13878793          	addi	a5,a5,312 # 8b88 <malloc+0x99c>
    1a58:	fcf43823          	sd	a5,-48(s0)
    1a5c:	fc043c23          	sd	zero,-40(s0)
  char buf[3];

  unlink("echo-ok");
    1a60:	00007517          	auipc	a0,0x7
    1a64:	13050513          	addi	a0,a0,304 # 8b90 <malloc+0x9a4>
    1a68:	00006097          	auipc	ra,0x6
    1a6c:	0b4080e7          	jalr	180(ra) # 7b1c <unlink>
  pid = fork();
    1a70:	00006097          	auipc	ra,0x6
    1a74:	054080e7          	jalr	84(ra) # 7ac4 <fork>
    1a78:	87aa                	mv	a5,a0
    1a7a:	fef42623          	sw	a5,-20(s0)
  if(pid < 0) {
    1a7e:	fec42783          	lw	a5,-20(s0)
    1a82:	2781                	sext.w	a5,a5
    1a84:	0207d163          	bgez	a5,1aa6 <exectest+0x6e>
     printf("%s: fork failed\n", s);
    1a88:	fb843583          	ld	a1,-72(s0)
    1a8c:	00007517          	auipc	a0,0x7
    1a90:	ce450513          	addi	a0,a0,-796 # 8770 <malloc+0x584>
    1a94:	00006097          	auipc	ra,0x6
    1a98:	564080e7          	jalr	1380(ra) # 7ff8 <printf>
     exit(1);
    1a9c:	4505                	li	a0,1
    1a9e:	00006097          	auipc	ra,0x6
    1aa2:	02e080e7          	jalr	46(ra) # 7acc <exit>
  }
  if(pid == 0) {
    1aa6:	fec42783          	lw	a5,-20(s0)
    1aaa:	2781                	sext.w	a5,a5
    1aac:	ebd5                	bnez	a5,1b60 <exectest+0x128>
    close(1);
    1aae:	4505                	li	a0,1
    1ab0:	00006097          	auipc	ra,0x6
    1ab4:	044080e7          	jalr	68(ra) # 7af4 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    1ab8:	20100593          	li	a1,513
    1abc:	00007517          	auipc	a0,0x7
    1ac0:	0d450513          	addi	a0,a0,212 # 8b90 <malloc+0x9a4>
    1ac4:	00006097          	auipc	ra,0x6
    1ac8:	048080e7          	jalr	72(ra) # 7b0c <open>
    1acc:	87aa                	mv	a5,a0
    1ace:	fef42423          	sw	a5,-24(s0)
    if(fd < 0) {
    1ad2:	fe842783          	lw	a5,-24(s0)
    1ad6:	2781                	sext.w	a5,a5
    1ad8:	0207d163          	bgez	a5,1afa <exectest+0xc2>
      printf("%s: create failed\n", s);
    1adc:	fb843583          	ld	a1,-72(s0)
    1ae0:	00007517          	auipc	a0,0x7
    1ae4:	0b850513          	addi	a0,a0,184 # 8b98 <malloc+0x9ac>
    1ae8:	00006097          	auipc	ra,0x6
    1aec:	510080e7          	jalr	1296(ra) # 7ff8 <printf>
      exit(1);
    1af0:	4505                	li	a0,1
    1af2:	00006097          	auipc	ra,0x6
    1af6:	fda080e7          	jalr	-38(ra) # 7acc <exit>
    }
    if(fd != 1) {
    1afa:	fe842783          	lw	a5,-24(s0)
    1afe:	0007871b          	sext.w	a4,a5
    1b02:	4785                	li	a5,1
    1b04:	02f70163          	beq	a4,a5,1b26 <exectest+0xee>
      printf("%s: wrong fd\n", s);
    1b08:	fb843583          	ld	a1,-72(s0)
    1b0c:	00007517          	auipc	a0,0x7
    1b10:	0a450513          	addi	a0,a0,164 # 8bb0 <malloc+0x9c4>
    1b14:	00006097          	auipc	ra,0x6
    1b18:	4e4080e7          	jalr	1252(ra) # 7ff8 <printf>
      exit(1);
    1b1c:	4505                	li	a0,1
    1b1e:	00006097          	auipc	ra,0x6
    1b22:	fae080e7          	jalr	-82(ra) # 7acc <exit>
    }
    if(exec("echo", echoargv) < 0){
    1b26:	fc840793          	addi	a5,s0,-56
    1b2a:	85be                	mv	a1,a5
    1b2c:	00007517          	auipc	a0,0x7
    1b30:	a2450513          	addi	a0,a0,-1500 # 8550 <malloc+0x364>
    1b34:	00006097          	auipc	ra,0x6
    1b38:	fd0080e7          	jalr	-48(ra) # 7b04 <exec>
    1b3c:	87aa                	mv	a5,a0
    1b3e:	0207d163          	bgez	a5,1b60 <exectest+0x128>
      printf("%s: exec echo failed\n", s);
    1b42:	fb843583          	ld	a1,-72(s0)
    1b46:	00007517          	auipc	a0,0x7
    1b4a:	07a50513          	addi	a0,a0,122 # 8bc0 <malloc+0x9d4>
    1b4e:	00006097          	auipc	ra,0x6
    1b52:	4aa080e7          	jalr	1194(ra) # 7ff8 <printf>
      exit(1);
    1b56:	4505                	li	a0,1
    1b58:	00006097          	auipc	ra,0x6
    1b5c:	f74080e7          	jalr	-140(ra) # 7acc <exit>
    }
    // won't get to here
  }
  if (wait(&xstatus) != pid) {
    1b60:	fe440793          	addi	a5,s0,-28
    1b64:	853e                	mv	a0,a5
    1b66:	00006097          	auipc	ra,0x6
    1b6a:	f6e080e7          	jalr	-146(ra) # 7ad4 <wait>
    1b6e:	87aa                	mv	a5,a0
    1b70:	873e                	mv	a4,a5
    1b72:	fec42783          	lw	a5,-20(s0)
    1b76:	2781                	sext.w	a5,a5
    1b78:	00e78c63          	beq	a5,a4,1b90 <exectest+0x158>
    printf("%s: wait failed!\n", s);
    1b7c:	fb843583          	ld	a1,-72(s0)
    1b80:	00007517          	auipc	a0,0x7
    1b84:	05850513          	addi	a0,a0,88 # 8bd8 <malloc+0x9ec>
    1b88:	00006097          	auipc	ra,0x6
    1b8c:	470080e7          	jalr	1136(ra) # 7ff8 <printf>
  }
  if(xstatus != 0)
    1b90:	fe442783          	lw	a5,-28(s0)
    1b94:	cb81                	beqz	a5,1ba4 <exectest+0x16c>
    exit(xstatus);
    1b96:	fe442783          	lw	a5,-28(s0)
    1b9a:	853e                	mv	a0,a5
    1b9c:	00006097          	auipc	ra,0x6
    1ba0:	f30080e7          	jalr	-208(ra) # 7acc <exit>

  fd = open("echo-ok", O_RDONLY);
    1ba4:	4581                	li	a1,0
    1ba6:	00007517          	auipc	a0,0x7
    1baa:	fea50513          	addi	a0,a0,-22 # 8b90 <malloc+0x9a4>
    1bae:	00006097          	auipc	ra,0x6
    1bb2:	f5e080e7          	jalr	-162(ra) # 7b0c <open>
    1bb6:	87aa                	mv	a5,a0
    1bb8:	fef42423          	sw	a5,-24(s0)
  if(fd < 0) {
    1bbc:	fe842783          	lw	a5,-24(s0)
    1bc0:	2781                	sext.w	a5,a5
    1bc2:	0207d163          	bgez	a5,1be4 <exectest+0x1ac>
    printf("%s: open failed\n", s);
    1bc6:	fb843583          	ld	a1,-72(s0)
    1bca:	00007517          	auipc	a0,0x7
    1bce:	bbe50513          	addi	a0,a0,-1090 # 8788 <malloc+0x59c>
    1bd2:	00006097          	auipc	ra,0x6
    1bd6:	426080e7          	jalr	1062(ra) # 7ff8 <printf>
    exit(1);
    1bda:	4505                	li	a0,1
    1bdc:	00006097          	auipc	ra,0x6
    1be0:	ef0080e7          	jalr	-272(ra) # 7acc <exit>
  }
  if (read(fd, buf, 2) != 2) {
    1be4:	fc040713          	addi	a4,s0,-64
    1be8:	fe842783          	lw	a5,-24(s0)
    1bec:	4609                	li	a2,2
    1bee:	85ba                	mv	a1,a4
    1bf0:	853e                	mv	a0,a5
    1bf2:	00006097          	auipc	ra,0x6
    1bf6:	ef2080e7          	jalr	-270(ra) # 7ae4 <read>
    1bfa:	87aa                	mv	a5,a0
    1bfc:	873e                	mv	a4,a5
    1bfe:	4789                	li	a5,2
    1c00:	02f70163          	beq	a4,a5,1c22 <exectest+0x1ea>
    printf("%s: read failed\n", s);
    1c04:	fb843583          	ld	a1,-72(s0)
    1c08:	00007517          	auipc	a0,0x7
    1c0c:	e0050513          	addi	a0,a0,-512 # 8a08 <malloc+0x81c>
    1c10:	00006097          	auipc	ra,0x6
    1c14:	3e8080e7          	jalr	1000(ra) # 7ff8 <printf>
    exit(1);
    1c18:	4505                	li	a0,1
    1c1a:	00006097          	auipc	ra,0x6
    1c1e:	eb2080e7          	jalr	-334(ra) # 7acc <exit>
  }
  unlink("echo-ok");
    1c22:	00007517          	auipc	a0,0x7
    1c26:	f6e50513          	addi	a0,a0,-146 # 8b90 <malloc+0x9a4>
    1c2a:	00006097          	auipc	ra,0x6
    1c2e:	ef2080e7          	jalr	-270(ra) # 7b1c <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1c32:	fc044783          	lbu	a5,-64(s0)
    1c36:	873e                	mv	a4,a5
    1c38:	04f00793          	li	a5,79
    1c3c:	00f71e63          	bne	a4,a5,1c58 <exectest+0x220>
    1c40:	fc144783          	lbu	a5,-63(s0)
    1c44:	873e                	mv	a4,a5
    1c46:	04b00793          	li	a5,75
    1c4a:	00f71763          	bne	a4,a5,1c58 <exectest+0x220>
    exit(0);
    1c4e:	4501                	li	a0,0
    1c50:	00006097          	auipc	ra,0x6
    1c54:	e7c080e7          	jalr	-388(ra) # 7acc <exit>
  else {
    printf("%s: wrong output\n", s);
    1c58:	fb843583          	ld	a1,-72(s0)
    1c5c:	00007517          	auipc	a0,0x7
    1c60:	f9450513          	addi	a0,a0,-108 # 8bf0 <malloc+0xa04>
    1c64:	00006097          	auipc	ra,0x6
    1c68:	394080e7          	jalr	916(ra) # 7ff8 <printf>
    exit(1);
    1c6c:	4505                	li	a0,1
    1c6e:	00006097          	auipc	ra,0x6
    1c72:	e5e080e7          	jalr	-418(ra) # 7acc <exit>

0000000000001c76 <pipe1>:

// simple fork and pipe read/write

void
pipe1(char *s)
{
    1c76:	715d                	addi	sp,sp,-80
    1c78:	e486                	sd	ra,72(sp)
    1c7a:	e0a2                	sd	s0,64(sp)
    1c7c:	0880                	addi	s0,sp,80
    1c7e:	faa43c23          	sd	a0,-72(s0)
  int fds[2], pid, xstatus;
  int seq, i, n, cc, total;
  enum { N=5, SZ=1033 };
  
  if(pipe(fds) != 0){
    1c82:	fd040793          	addi	a5,s0,-48
    1c86:	853e                	mv	a0,a5
    1c88:	00006097          	auipc	ra,0x6
    1c8c:	e54080e7          	jalr	-428(ra) # 7adc <pipe>
    1c90:	87aa                	mv	a5,a0
    1c92:	c385                	beqz	a5,1cb2 <pipe1+0x3c>
    printf("%s: pipe() failed\n", s);
    1c94:	fb843583          	ld	a1,-72(s0)
    1c98:	00007517          	auipc	a0,0x7
    1c9c:	f7050513          	addi	a0,a0,-144 # 8c08 <malloc+0xa1c>
    1ca0:	00006097          	auipc	ra,0x6
    1ca4:	358080e7          	jalr	856(ra) # 7ff8 <printf>
    exit(1);
    1ca8:	4505                	li	a0,1
    1caa:	00006097          	auipc	ra,0x6
    1cae:	e22080e7          	jalr	-478(ra) # 7acc <exit>
  }
  pid = fork();
    1cb2:	00006097          	auipc	ra,0x6
    1cb6:	e12080e7          	jalr	-494(ra) # 7ac4 <fork>
    1cba:	87aa                	mv	a5,a0
    1cbc:	fcf42c23          	sw	a5,-40(s0)
  seq = 0;
    1cc0:	fe042623          	sw	zero,-20(s0)
  if(pid == 0){
    1cc4:	fd842783          	lw	a5,-40(s0)
    1cc8:	2781                	sext.w	a5,a5
    1cca:	efdd                	bnez	a5,1d88 <pipe1+0x112>
    close(fds[0]);
    1ccc:	fd042783          	lw	a5,-48(s0)
    1cd0:	853e                	mv	a0,a5
    1cd2:	00006097          	auipc	ra,0x6
    1cd6:	e22080e7          	jalr	-478(ra) # 7af4 <close>
    for(n = 0; n < N; n++){
    1cda:	fe042223          	sw	zero,-28(s0)
    1cde:	a849                	j	1d70 <pipe1+0xfa>
      for(i = 0; i < SZ; i++)
    1ce0:	fe042423          	sw	zero,-24(s0)
    1ce4:	a03d                	j	1d12 <pipe1+0x9c>
        buf[i] = seq++;
    1ce6:	fec42783          	lw	a5,-20(s0)
    1cea:	0017871b          	addiw	a4,a5,1
    1cee:	fee42623          	sw	a4,-20(s0)
    1cf2:	0ff7f713          	zext.b	a4,a5
    1cf6:	00009697          	auipc	a3,0x9
    1cfa:	77a68693          	addi	a3,a3,1914 # b470 <buf>
    1cfe:	fe842783          	lw	a5,-24(s0)
    1d02:	97b6                	add	a5,a5,a3
    1d04:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1d08:	fe842783          	lw	a5,-24(s0)
    1d0c:	2785                	addiw	a5,a5,1
    1d0e:	fef42423          	sw	a5,-24(s0)
    1d12:	fe842783          	lw	a5,-24(s0)
    1d16:	0007871b          	sext.w	a4,a5
    1d1a:	40800793          	li	a5,1032
    1d1e:	fce7d4e3          	bge	a5,a4,1ce6 <pipe1+0x70>
      if(write(fds[1], buf, SZ) != SZ){
    1d22:	fd442783          	lw	a5,-44(s0)
    1d26:	40900613          	li	a2,1033
    1d2a:	00009597          	auipc	a1,0x9
    1d2e:	74658593          	addi	a1,a1,1862 # b470 <buf>
    1d32:	853e                	mv	a0,a5
    1d34:	00006097          	auipc	ra,0x6
    1d38:	db8080e7          	jalr	-584(ra) # 7aec <write>
    1d3c:	87aa                	mv	a5,a0
    1d3e:	873e                	mv	a4,a5
    1d40:	40900793          	li	a5,1033
    1d44:	02f70163          	beq	a4,a5,1d66 <pipe1+0xf0>
        printf("%s: pipe1 oops 1\n", s);
    1d48:	fb843583          	ld	a1,-72(s0)
    1d4c:	00007517          	auipc	a0,0x7
    1d50:	ed450513          	addi	a0,a0,-300 # 8c20 <malloc+0xa34>
    1d54:	00006097          	auipc	ra,0x6
    1d58:	2a4080e7          	jalr	676(ra) # 7ff8 <printf>
        exit(1);
    1d5c:	4505                	li	a0,1
    1d5e:	00006097          	auipc	ra,0x6
    1d62:	d6e080e7          	jalr	-658(ra) # 7acc <exit>
    for(n = 0; n < N; n++){
    1d66:	fe442783          	lw	a5,-28(s0)
    1d6a:	2785                	addiw	a5,a5,1
    1d6c:	fef42223          	sw	a5,-28(s0)
    1d70:	fe442783          	lw	a5,-28(s0)
    1d74:	0007871b          	sext.w	a4,a5
    1d78:	4791                	li	a5,4
    1d7a:	f6e7d3e3          	bge	a5,a4,1ce0 <pipe1+0x6a>
      }
    }
    exit(0);
    1d7e:	4501                	li	a0,0
    1d80:	00006097          	auipc	ra,0x6
    1d84:	d4c080e7          	jalr	-692(ra) # 7acc <exit>
  } else if(pid > 0){
    1d88:	fd842783          	lw	a5,-40(s0)
    1d8c:	2781                	sext.w	a5,a5
    1d8e:	12f05b63          	blez	a5,1ec4 <pipe1+0x24e>
    close(fds[1]);
    1d92:	fd442783          	lw	a5,-44(s0)
    1d96:	853e                	mv	a0,a5
    1d98:	00006097          	auipc	ra,0x6
    1d9c:	d5c080e7          	jalr	-676(ra) # 7af4 <close>
    total = 0;
    1da0:	fc042e23          	sw	zero,-36(s0)
    cc = 1;
    1da4:	4785                	li	a5,1
    1da6:	fef42023          	sw	a5,-32(s0)
    while((n = read(fds[0], buf, cc)) > 0){
    1daa:	a849                	j	1e3c <pipe1+0x1c6>
      for(i = 0; i < n; i++){
    1dac:	fe042423          	sw	zero,-24(s0)
    1db0:	a0b9                	j	1dfe <pipe1+0x188>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1db2:	00009717          	auipc	a4,0x9
    1db6:	6be70713          	addi	a4,a4,1726 # b470 <buf>
    1dba:	fe842783          	lw	a5,-24(s0)
    1dbe:	97ba                	add	a5,a5,a4
    1dc0:	0007c783          	lbu	a5,0(a5)
    1dc4:	0007871b          	sext.w	a4,a5
    1dc8:	fec42783          	lw	a5,-20(s0)
    1dcc:	0017869b          	addiw	a3,a5,1
    1dd0:	fed42623          	sw	a3,-20(s0)
    1dd4:	0ff7f793          	zext.b	a5,a5
    1dd8:	2781                	sext.w	a5,a5
    1dda:	00f70d63          	beq	a4,a5,1df4 <pipe1+0x17e>
          printf("%s: pipe1 oops 2\n", s);
    1dde:	fb843583          	ld	a1,-72(s0)
    1de2:	00007517          	auipc	a0,0x7
    1de6:	e5650513          	addi	a0,a0,-426 # 8c38 <malloc+0xa4c>
    1dea:	00006097          	auipc	ra,0x6
    1dee:	20e080e7          	jalr	526(ra) # 7ff8 <printf>
          return;
    1df2:	a8c5                	j	1ee2 <pipe1+0x26c>
      for(i = 0; i < n; i++){
    1df4:	fe842783          	lw	a5,-24(s0)
    1df8:	2785                	addiw	a5,a5,1
    1dfa:	fef42423          	sw	a5,-24(s0)
    1dfe:	fe842783          	lw	a5,-24(s0)
    1e02:	873e                	mv	a4,a5
    1e04:	fe442783          	lw	a5,-28(s0)
    1e08:	2701                	sext.w	a4,a4
    1e0a:	2781                	sext.w	a5,a5
    1e0c:	faf743e3          	blt	a4,a5,1db2 <pipe1+0x13c>
        }
      }
      total += n;
    1e10:	fdc42783          	lw	a5,-36(s0)
    1e14:	873e                	mv	a4,a5
    1e16:	fe442783          	lw	a5,-28(s0)
    1e1a:	9fb9                	addw	a5,a5,a4
    1e1c:	fcf42e23          	sw	a5,-36(s0)
      cc = cc * 2;
    1e20:	fe042783          	lw	a5,-32(s0)
    1e24:	0017979b          	slliw	a5,a5,0x1
    1e28:	fef42023          	sw	a5,-32(s0)
      if(cc > sizeof(buf))
    1e2c:	fe042703          	lw	a4,-32(s0)
    1e30:	678d                	lui	a5,0x3
    1e32:	00e7f563          	bgeu	a5,a4,1e3c <pipe1+0x1c6>
        cc = sizeof(buf);
    1e36:	678d                	lui	a5,0x3
    1e38:	fef42023          	sw	a5,-32(s0)
    while((n = read(fds[0], buf, cc)) > 0){
    1e3c:	fd042783          	lw	a5,-48(s0)
    1e40:	fe042703          	lw	a4,-32(s0)
    1e44:	863a                	mv	a2,a4
    1e46:	00009597          	auipc	a1,0x9
    1e4a:	62a58593          	addi	a1,a1,1578 # b470 <buf>
    1e4e:	853e                	mv	a0,a5
    1e50:	00006097          	auipc	ra,0x6
    1e54:	c94080e7          	jalr	-876(ra) # 7ae4 <read>
    1e58:	87aa                	mv	a5,a0
    1e5a:	fef42223          	sw	a5,-28(s0)
    1e5e:	fe442783          	lw	a5,-28(s0)
    1e62:	2781                	sext.w	a5,a5
    1e64:	f4f044e3          	bgtz	a5,1dac <pipe1+0x136>
    }
    if(total != N * SZ){
    1e68:	fdc42783          	lw	a5,-36(s0)
    1e6c:	0007871b          	sext.w	a4,a5
    1e70:	6785                	lui	a5,0x1
    1e72:	42d78793          	addi	a5,a5,1069 # 142d <opentest+0x6f>
    1e76:	02f70263          	beq	a4,a5,1e9a <pipe1+0x224>
      printf("%s: pipe1 oops 3 total %d\n", total);
    1e7a:	fdc42783          	lw	a5,-36(s0)
    1e7e:	85be                	mv	a1,a5
    1e80:	00007517          	auipc	a0,0x7
    1e84:	dd050513          	addi	a0,a0,-560 # 8c50 <malloc+0xa64>
    1e88:	00006097          	auipc	ra,0x6
    1e8c:	170080e7          	jalr	368(ra) # 7ff8 <printf>
      exit(1);
    1e90:	4505                	li	a0,1
    1e92:	00006097          	auipc	ra,0x6
    1e96:	c3a080e7          	jalr	-966(ra) # 7acc <exit>
    }
    close(fds[0]);
    1e9a:	fd042783          	lw	a5,-48(s0)
    1e9e:	853e                	mv	a0,a5
    1ea0:	00006097          	auipc	ra,0x6
    1ea4:	c54080e7          	jalr	-940(ra) # 7af4 <close>
    wait(&xstatus);
    1ea8:	fcc40793          	addi	a5,s0,-52
    1eac:	853e                	mv	a0,a5
    1eae:	00006097          	auipc	ra,0x6
    1eb2:	c26080e7          	jalr	-986(ra) # 7ad4 <wait>
    exit(xstatus);
    1eb6:	fcc42783          	lw	a5,-52(s0)
    1eba:	853e                	mv	a0,a5
    1ebc:	00006097          	auipc	ra,0x6
    1ec0:	c10080e7          	jalr	-1008(ra) # 7acc <exit>
  } else {
    printf("%s: fork() failed\n", s);
    1ec4:	fb843583          	ld	a1,-72(s0)
    1ec8:	00007517          	auipc	a0,0x7
    1ecc:	da850513          	addi	a0,a0,-600 # 8c70 <malloc+0xa84>
    1ed0:	00006097          	auipc	ra,0x6
    1ed4:	128080e7          	jalr	296(ra) # 7ff8 <printf>
    exit(1);
    1ed8:	4505                	li	a0,1
    1eda:	00006097          	auipc	ra,0x6
    1ede:	bf2080e7          	jalr	-1038(ra) # 7acc <exit>
  }
}
    1ee2:	60a6                	ld	ra,72(sp)
    1ee4:	6406                	ld	s0,64(sp)
    1ee6:	6161                	addi	sp,sp,80
    1ee8:	8082                	ret

0000000000001eea <killstatus>:


// test if child is killed (status = -1)
void
killstatus(char *s)
{
    1eea:	7179                	addi	sp,sp,-48
    1eec:	f406                	sd	ra,40(sp)
    1eee:	f022                	sd	s0,32(sp)
    1ef0:	1800                	addi	s0,sp,48
    1ef2:	fca43c23          	sd	a0,-40(s0)
  int xst;
  
  for(int i = 0; i < 100; i++){
    1ef6:	fe042623          	sw	zero,-20(s0)
    1efa:	a04d                	j	1f9c <killstatus+0xb2>
    int pid1 = fork();
    1efc:	00006097          	auipc	ra,0x6
    1f00:	bc8080e7          	jalr	-1080(ra) # 7ac4 <fork>
    1f04:	87aa                	mv	a5,a0
    1f06:	fef42423          	sw	a5,-24(s0)
    if(pid1 < 0){
    1f0a:	fe842783          	lw	a5,-24(s0)
    1f0e:	2781                	sext.w	a5,a5
    1f10:	0207d163          	bgez	a5,1f32 <killstatus+0x48>
      printf("%s: fork failed\n", s);
    1f14:	fd843583          	ld	a1,-40(s0)
    1f18:	00007517          	auipc	a0,0x7
    1f1c:	85850513          	addi	a0,a0,-1960 # 8770 <malloc+0x584>
    1f20:	00006097          	auipc	ra,0x6
    1f24:	0d8080e7          	jalr	216(ra) # 7ff8 <printf>
      exit(1);
    1f28:	4505                	li	a0,1
    1f2a:	00006097          	auipc	ra,0x6
    1f2e:	ba2080e7          	jalr	-1118(ra) # 7acc <exit>
    }
    if(pid1 == 0){
    1f32:	fe842783          	lw	a5,-24(s0)
    1f36:	2781                	sext.w	a5,a5
    1f38:	e791                	bnez	a5,1f44 <killstatus+0x5a>
      while(1) {
        getpid();
    1f3a:	00006097          	auipc	ra,0x6
    1f3e:	c12080e7          	jalr	-1006(ra) # 7b4c <getpid>
    1f42:	bfe5                	j	1f3a <killstatus+0x50>
      }
      exit(0);
    }
    sleep(1);
    1f44:	4505                	li	a0,1
    1f46:	00006097          	auipc	ra,0x6
    1f4a:	c16080e7          	jalr	-1002(ra) # 7b5c <sleep>
    kill(pid1);
    1f4e:	fe842783          	lw	a5,-24(s0)
    1f52:	853e                	mv	a0,a5
    1f54:	00006097          	auipc	ra,0x6
    1f58:	ba8080e7          	jalr	-1112(ra) # 7afc <kill>
    wait(&xst);
    1f5c:	fe440793          	addi	a5,s0,-28
    1f60:	853e                	mv	a0,a5
    1f62:	00006097          	auipc	ra,0x6
    1f66:	b72080e7          	jalr	-1166(ra) # 7ad4 <wait>
    if(xst != -1) {
    1f6a:	fe442703          	lw	a4,-28(s0)
    1f6e:	57fd                	li	a5,-1
    1f70:	02f70163          	beq	a4,a5,1f92 <killstatus+0xa8>
       printf("%s: status should be -1\n", s);
    1f74:	fd843583          	ld	a1,-40(s0)
    1f78:	00007517          	auipc	a0,0x7
    1f7c:	d1050513          	addi	a0,a0,-752 # 8c88 <malloc+0xa9c>
    1f80:	00006097          	auipc	ra,0x6
    1f84:	078080e7          	jalr	120(ra) # 7ff8 <printf>
       exit(1);
    1f88:	4505                	li	a0,1
    1f8a:	00006097          	auipc	ra,0x6
    1f8e:	b42080e7          	jalr	-1214(ra) # 7acc <exit>
  for(int i = 0; i < 100; i++){
    1f92:	fec42783          	lw	a5,-20(s0)
    1f96:	2785                	addiw	a5,a5,1
    1f98:	fef42623          	sw	a5,-20(s0)
    1f9c:	fec42783          	lw	a5,-20(s0)
    1fa0:	0007871b          	sext.w	a4,a5
    1fa4:	06300793          	li	a5,99
    1fa8:	f4e7dae3          	bge	a5,a4,1efc <killstatus+0x12>
    }
  }
  exit(0);
    1fac:	4501                	li	a0,0
    1fae:	00006097          	auipc	ra,0x6
    1fb2:	b1e080e7          	jalr	-1250(ra) # 7acc <exit>

0000000000001fb6 <preempt>:
}

// meant to be run w/ at most two CPUs
void
preempt(char *s)
{
    1fb6:	7139                	addi	sp,sp,-64
    1fb8:	fc06                	sd	ra,56(sp)
    1fba:	f822                	sd	s0,48(sp)
    1fbc:	0080                	addi	s0,sp,64
    1fbe:	fca43423          	sd	a0,-56(s0)
  int pid1, pid2, pid3;
  int pfds[2];

  pid1 = fork();
    1fc2:	00006097          	auipc	ra,0x6
    1fc6:	b02080e7          	jalr	-1278(ra) # 7ac4 <fork>
    1fca:	87aa                	mv	a5,a0
    1fcc:	fef42623          	sw	a5,-20(s0)
  if(pid1 < 0) {
    1fd0:	fec42783          	lw	a5,-20(s0)
    1fd4:	2781                	sext.w	a5,a5
    1fd6:	0207d163          	bgez	a5,1ff8 <preempt+0x42>
    printf("%s: fork failed", s);
    1fda:	fc843583          	ld	a1,-56(s0)
    1fde:	00007517          	auipc	a0,0x7
    1fe2:	cca50513          	addi	a0,a0,-822 # 8ca8 <malloc+0xabc>
    1fe6:	00006097          	auipc	ra,0x6
    1fea:	012080e7          	jalr	18(ra) # 7ff8 <printf>
    exit(1);
    1fee:	4505                	li	a0,1
    1ff0:	00006097          	auipc	ra,0x6
    1ff4:	adc080e7          	jalr	-1316(ra) # 7acc <exit>
  }
  if(pid1 == 0)
    1ff8:	fec42783          	lw	a5,-20(s0)
    1ffc:	2781                	sext.w	a5,a5
    1ffe:	e399                	bnez	a5,2004 <preempt+0x4e>
    for(;;)
    2000:	0001                	nop
    2002:	bffd                	j	2000 <preempt+0x4a>
      ;

  pid2 = fork();
    2004:	00006097          	auipc	ra,0x6
    2008:	ac0080e7          	jalr	-1344(ra) # 7ac4 <fork>
    200c:	87aa                	mv	a5,a0
    200e:	fef42423          	sw	a5,-24(s0)
  if(pid2 < 0) {
    2012:	fe842783          	lw	a5,-24(s0)
    2016:	2781                	sext.w	a5,a5
    2018:	0207d163          	bgez	a5,203a <preempt+0x84>
    printf("%s: fork failed\n", s);
    201c:	fc843583          	ld	a1,-56(s0)
    2020:	00006517          	auipc	a0,0x6
    2024:	75050513          	addi	a0,a0,1872 # 8770 <malloc+0x584>
    2028:	00006097          	auipc	ra,0x6
    202c:	fd0080e7          	jalr	-48(ra) # 7ff8 <printf>
    exit(1);
    2030:	4505                	li	a0,1
    2032:	00006097          	auipc	ra,0x6
    2036:	a9a080e7          	jalr	-1382(ra) # 7acc <exit>
  }
  if(pid2 == 0)
    203a:	fe842783          	lw	a5,-24(s0)
    203e:	2781                	sext.w	a5,a5
    2040:	e399                	bnez	a5,2046 <preempt+0x90>
    for(;;)
    2042:	0001                	nop
    2044:	bffd                	j	2042 <preempt+0x8c>
      ;

  pipe(pfds);
    2046:	fd840793          	addi	a5,s0,-40
    204a:	853e                	mv	a0,a5
    204c:	00006097          	auipc	ra,0x6
    2050:	a90080e7          	jalr	-1392(ra) # 7adc <pipe>
  pid3 = fork();
    2054:	00006097          	auipc	ra,0x6
    2058:	a70080e7          	jalr	-1424(ra) # 7ac4 <fork>
    205c:	87aa                	mv	a5,a0
    205e:	fef42223          	sw	a5,-28(s0)
  if(pid3 < 0) {
    2062:	fe442783          	lw	a5,-28(s0)
    2066:	2781                	sext.w	a5,a5
    2068:	0207d163          	bgez	a5,208a <preempt+0xd4>
     printf("%s: fork failed\n", s);
    206c:	fc843583          	ld	a1,-56(s0)
    2070:	00006517          	auipc	a0,0x6
    2074:	70050513          	addi	a0,a0,1792 # 8770 <malloc+0x584>
    2078:	00006097          	auipc	ra,0x6
    207c:	f80080e7          	jalr	-128(ra) # 7ff8 <printf>
     exit(1);
    2080:	4505                	li	a0,1
    2082:	00006097          	auipc	ra,0x6
    2086:	a4a080e7          	jalr	-1462(ra) # 7acc <exit>
  }
  if(pid3 == 0){
    208a:	fe442783          	lw	a5,-28(s0)
    208e:	2781                	sext.w	a5,a5
    2090:	efa1                	bnez	a5,20e8 <preempt+0x132>
    close(pfds[0]);
    2092:	fd842783          	lw	a5,-40(s0)
    2096:	853e                	mv	a0,a5
    2098:	00006097          	auipc	ra,0x6
    209c:	a5c080e7          	jalr	-1444(ra) # 7af4 <close>
    if(write(pfds[1], "x", 1) != 1)
    20a0:	fdc42783          	lw	a5,-36(s0)
    20a4:	4605                	li	a2,1
    20a6:	00006597          	auipc	a1,0x6
    20aa:	39a58593          	addi	a1,a1,922 # 8440 <malloc+0x254>
    20ae:	853e                	mv	a0,a5
    20b0:	00006097          	auipc	ra,0x6
    20b4:	a3c080e7          	jalr	-1476(ra) # 7aec <write>
    20b8:	87aa                	mv	a5,a0
    20ba:	873e                	mv	a4,a5
    20bc:	4785                	li	a5,1
    20be:	00f70c63          	beq	a4,a5,20d6 <preempt+0x120>
      printf("%s: preempt write error", s);
    20c2:	fc843583          	ld	a1,-56(s0)
    20c6:	00007517          	auipc	a0,0x7
    20ca:	bf250513          	addi	a0,a0,-1038 # 8cb8 <malloc+0xacc>
    20ce:	00006097          	auipc	ra,0x6
    20d2:	f2a080e7          	jalr	-214(ra) # 7ff8 <printf>
    close(pfds[1]);
    20d6:	fdc42783          	lw	a5,-36(s0)
    20da:	853e                	mv	a0,a5
    20dc:	00006097          	auipc	ra,0x6
    20e0:	a18080e7          	jalr	-1512(ra) # 7af4 <close>
    for(;;)
    20e4:	0001                	nop
    20e6:	bffd                	j	20e4 <preempt+0x12e>
      ;
  }

  close(pfds[1]);
    20e8:	fdc42783          	lw	a5,-36(s0)
    20ec:	853e                	mv	a0,a5
    20ee:	00006097          	auipc	ra,0x6
    20f2:	a06080e7          	jalr	-1530(ra) # 7af4 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    20f6:	fd842783          	lw	a5,-40(s0)
    20fa:	660d                	lui	a2,0x3
    20fc:	00009597          	auipc	a1,0x9
    2100:	37458593          	addi	a1,a1,884 # b470 <buf>
    2104:	853e                	mv	a0,a5
    2106:	00006097          	auipc	ra,0x6
    210a:	9de080e7          	jalr	-1570(ra) # 7ae4 <read>
    210e:	87aa                	mv	a5,a0
    2110:	873e                	mv	a4,a5
    2112:	4785                	li	a5,1
    2114:	00f70d63          	beq	a4,a5,212e <preempt+0x178>
    printf("%s: preempt read error", s);
    2118:	fc843583          	ld	a1,-56(s0)
    211c:	00007517          	auipc	a0,0x7
    2120:	bb450513          	addi	a0,a0,-1100 # 8cd0 <malloc+0xae4>
    2124:	00006097          	auipc	ra,0x6
    2128:	ed4080e7          	jalr	-300(ra) # 7ff8 <printf>
    212c:	a8a5                	j	21a4 <preempt+0x1ee>
    return;
  }
  close(pfds[0]);
    212e:	fd842783          	lw	a5,-40(s0)
    2132:	853e                	mv	a0,a5
    2134:	00006097          	auipc	ra,0x6
    2138:	9c0080e7          	jalr	-1600(ra) # 7af4 <close>
  printf("kill... ");
    213c:	00007517          	auipc	a0,0x7
    2140:	bac50513          	addi	a0,a0,-1108 # 8ce8 <malloc+0xafc>
    2144:	00006097          	auipc	ra,0x6
    2148:	eb4080e7          	jalr	-332(ra) # 7ff8 <printf>
  kill(pid1);
    214c:	fec42783          	lw	a5,-20(s0)
    2150:	853e                	mv	a0,a5
    2152:	00006097          	auipc	ra,0x6
    2156:	9aa080e7          	jalr	-1622(ra) # 7afc <kill>
  kill(pid2);
    215a:	fe842783          	lw	a5,-24(s0)
    215e:	853e                	mv	a0,a5
    2160:	00006097          	auipc	ra,0x6
    2164:	99c080e7          	jalr	-1636(ra) # 7afc <kill>
  kill(pid3);
    2168:	fe442783          	lw	a5,-28(s0)
    216c:	853e                	mv	a0,a5
    216e:	00006097          	auipc	ra,0x6
    2172:	98e080e7          	jalr	-1650(ra) # 7afc <kill>
  printf("wait... ");
    2176:	00007517          	auipc	a0,0x7
    217a:	b8250513          	addi	a0,a0,-1150 # 8cf8 <malloc+0xb0c>
    217e:	00006097          	auipc	ra,0x6
    2182:	e7a080e7          	jalr	-390(ra) # 7ff8 <printf>
  wait(0);
    2186:	4501                	li	a0,0
    2188:	00006097          	auipc	ra,0x6
    218c:	94c080e7          	jalr	-1716(ra) # 7ad4 <wait>
  wait(0);
    2190:	4501                	li	a0,0
    2192:	00006097          	auipc	ra,0x6
    2196:	942080e7          	jalr	-1726(ra) # 7ad4 <wait>
  wait(0);
    219a:	4501                	li	a0,0
    219c:	00006097          	auipc	ra,0x6
    21a0:	938080e7          	jalr	-1736(ra) # 7ad4 <wait>
}
    21a4:	70e2                	ld	ra,56(sp)
    21a6:	7442                	ld	s0,48(sp)
    21a8:	6121                	addi	sp,sp,64
    21aa:	8082                	ret

00000000000021ac <exitwait>:

// try to find any races between exit and wait
void
exitwait(char *s)
{
    21ac:	7179                	addi	sp,sp,-48
    21ae:	f406                	sd	ra,40(sp)
    21b0:	f022                	sd	s0,32(sp)
    21b2:	1800                	addi	s0,sp,48
    21b4:	fca43c23          	sd	a0,-40(s0)
  int i, pid;

  for(i = 0; i < 100; i++){
    21b8:	fe042623          	sw	zero,-20(s0)
    21bc:	a87d                	j	227a <exitwait+0xce>
    pid = fork();
    21be:	00006097          	auipc	ra,0x6
    21c2:	906080e7          	jalr	-1786(ra) # 7ac4 <fork>
    21c6:	87aa                	mv	a5,a0
    21c8:	fef42423          	sw	a5,-24(s0)
    if(pid < 0){
    21cc:	fe842783          	lw	a5,-24(s0)
    21d0:	2781                	sext.w	a5,a5
    21d2:	0207d163          	bgez	a5,21f4 <exitwait+0x48>
      printf("%s: fork failed\n", s);
    21d6:	fd843583          	ld	a1,-40(s0)
    21da:	00006517          	auipc	a0,0x6
    21de:	59650513          	addi	a0,a0,1430 # 8770 <malloc+0x584>
    21e2:	00006097          	auipc	ra,0x6
    21e6:	e16080e7          	jalr	-490(ra) # 7ff8 <printf>
      exit(1);
    21ea:	4505                	li	a0,1
    21ec:	00006097          	auipc	ra,0x6
    21f0:	8e0080e7          	jalr	-1824(ra) # 7acc <exit>
    }
    if(pid){
    21f4:	fe842783          	lw	a5,-24(s0)
    21f8:	2781                	sext.w	a5,a5
    21fa:	c7a5                	beqz	a5,2262 <exitwait+0xb6>
      int xstate;
      if(wait(&xstate) != pid){
    21fc:	fe440793          	addi	a5,s0,-28
    2200:	853e                	mv	a0,a5
    2202:	00006097          	auipc	ra,0x6
    2206:	8d2080e7          	jalr	-1838(ra) # 7ad4 <wait>
    220a:	87aa                	mv	a5,a0
    220c:	873e                	mv	a4,a5
    220e:	fe842783          	lw	a5,-24(s0)
    2212:	2781                	sext.w	a5,a5
    2214:	02e78163          	beq	a5,a4,2236 <exitwait+0x8a>
        printf("%s: wait wrong pid\n", s);
    2218:	fd843583          	ld	a1,-40(s0)
    221c:	00007517          	auipc	a0,0x7
    2220:	aec50513          	addi	a0,a0,-1300 # 8d08 <malloc+0xb1c>
    2224:	00006097          	auipc	ra,0x6
    2228:	dd4080e7          	jalr	-556(ra) # 7ff8 <printf>
        exit(1);
    222c:	4505                	li	a0,1
    222e:	00006097          	auipc	ra,0x6
    2232:	89e080e7          	jalr	-1890(ra) # 7acc <exit>
      }
      if(i != xstate) {
    2236:	fe442783          	lw	a5,-28(s0)
    223a:	fec42703          	lw	a4,-20(s0)
    223e:	2701                	sext.w	a4,a4
    2240:	02f70863          	beq	a4,a5,2270 <exitwait+0xc4>
        printf("%s: wait wrong exit status\n", s);
    2244:	fd843583          	ld	a1,-40(s0)
    2248:	00007517          	auipc	a0,0x7
    224c:	ad850513          	addi	a0,a0,-1320 # 8d20 <malloc+0xb34>
    2250:	00006097          	auipc	ra,0x6
    2254:	da8080e7          	jalr	-600(ra) # 7ff8 <printf>
        exit(1);
    2258:	4505                	li	a0,1
    225a:	00006097          	auipc	ra,0x6
    225e:	872080e7          	jalr	-1934(ra) # 7acc <exit>
      }
    } else {
      exit(i);
    2262:	fec42783          	lw	a5,-20(s0)
    2266:	853e                	mv	a0,a5
    2268:	00006097          	auipc	ra,0x6
    226c:	864080e7          	jalr	-1948(ra) # 7acc <exit>
  for(i = 0; i < 100; i++){
    2270:	fec42783          	lw	a5,-20(s0)
    2274:	2785                	addiw	a5,a5,1
    2276:	fef42623          	sw	a5,-20(s0)
    227a:	fec42783          	lw	a5,-20(s0)
    227e:	0007871b          	sext.w	a4,a5
    2282:	06300793          	li	a5,99
    2286:	f2e7dce3          	bge	a5,a4,21be <exitwait+0x12>
    }
  }
}
    228a:	0001                	nop
    228c:	0001                	nop
    228e:	70a2                	ld	ra,40(sp)
    2290:	7402                	ld	s0,32(sp)
    2292:	6145                	addi	sp,sp,48
    2294:	8082                	ret

0000000000002296 <reparent>:
// try to find races in the reparenting
// code that handles a parent exiting
// when it still has live children.
void
reparent(char *s)
{
    2296:	7179                	addi	sp,sp,-48
    2298:	f406                	sd	ra,40(sp)
    229a:	f022                	sd	s0,32(sp)
    229c:	1800                	addi	s0,sp,48
    229e:	fca43c23          	sd	a0,-40(s0)
  int master_pid = getpid();
    22a2:	00006097          	auipc	ra,0x6
    22a6:	8aa080e7          	jalr	-1878(ra) # 7b4c <getpid>
    22aa:	87aa                	mv	a5,a0
    22ac:	fef42423          	sw	a5,-24(s0)
  for(int i = 0; i < 200; i++){
    22b0:	fe042623          	sw	zero,-20(s0)
    22b4:	a86d                	j	236e <reparent+0xd8>
    int pid = fork();
    22b6:	00006097          	auipc	ra,0x6
    22ba:	80e080e7          	jalr	-2034(ra) # 7ac4 <fork>
    22be:	87aa                	mv	a5,a0
    22c0:	fef42223          	sw	a5,-28(s0)
    if(pid < 0){
    22c4:	fe442783          	lw	a5,-28(s0)
    22c8:	2781                	sext.w	a5,a5
    22ca:	0207d163          	bgez	a5,22ec <reparent+0x56>
      printf("%s: fork failed\n", s);
    22ce:	fd843583          	ld	a1,-40(s0)
    22d2:	00006517          	auipc	a0,0x6
    22d6:	49e50513          	addi	a0,a0,1182 # 8770 <malloc+0x584>
    22da:	00006097          	auipc	ra,0x6
    22de:	d1e080e7          	jalr	-738(ra) # 7ff8 <printf>
      exit(1);
    22e2:	4505                	li	a0,1
    22e4:	00005097          	auipc	ra,0x5
    22e8:	7e8080e7          	jalr	2024(ra) # 7acc <exit>
    }
    if(pid){
    22ec:	fe442783          	lw	a5,-28(s0)
    22f0:	2781                	sext.w	a5,a5
    22f2:	cf85                	beqz	a5,232a <reparent+0x94>
      if(wait(0) != pid){
    22f4:	4501                	li	a0,0
    22f6:	00005097          	auipc	ra,0x5
    22fa:	7de080e7          	jalr	2014(ra) # 7ad4 <wait>
    22fe:	87aa                	mv	a5,a0
    2300:	873e                	mv	a4,a5
    2302:	fe442783          	lw	a5,-28(s0)
    2306:	2781                	sext.w	a5,a5
    2308:	04e78e63          	beq	a5,a4,2364 <reparent+0xce>
        printf("%s: wait wrong pid\n", s);
    230c:	fd843583          	ld	a1,-40(s0)
    2310:	00007517          	auipc	a0,0x7
    2314:	9f850513          	addi	a0,a0,-1544 # 8d08 <malloc+0xb1c>
    2318:	00006097          	auipc	ra,0x6
    231c:	ce0080e7          	jalr	-800(ra) # 7ff8 <printf>
        exit(1);
    2320:	4505                	li	a0,1
    2322:	00005097          	auipc	ra,0x5
    2326:	7aa080e7          	jalr	1962(ra) # 7acc <exit>
      }
    } else {
      int pid2 = fork();
    232a:	00005097          	auipc	ra,0x5
    232e:	79a080e7          	jalr	1946(ra) # 7ac4 <fork>
    2332:	87aa                	mv	a5,a0
    2334:	fef42023          	sw	a5,-32(s0)
      if(pid2 < 0){
    2338:	fe042783          	lw	a5,-32(s0)
    233c:	2781                	sext.w	a5,a5
    233e:	0007de63          	bgez	a5,235a <reparent+0xc4>
        kill(master_pid);
    2342:	fe842783          	lw	a5,-24(s0)
    2346:	853e                	mv	a0,a5
    2348:	00005097          	auipc	ra,0x5
    234c:	7b4080e7          	jalr	1972(ra) # 7afc <kill>
        exit(1);
    2350:	4505                	li	a0,1
    2352:	00005097          	auipc	ra,0x5
    2356:	77a080e7          	jalr	1914(ra) # 7acc <exit>
      }
      exit(0);
    235a:	4501                	li	a0,0
    235c:	00005097          	auipc	ra,0x5
    2360:	770080e7          	jalr	1904(ra) # 7acc <exit>
  for(int i = 0; i < 200; i++){
    2364:	fec42783          	lw	a5,-20(s0)
    2368:	2785                	addiw	a5,a5,1
    236a:	fef42623          	sw	a5,-20(s0)
    236e:	fec42783          	lw	a5,-20(s0)
    2372:	0007871b          	sext.w	a4,a5
    2376:	0c700793          	li	a5,199
    237a:	f2e7dee3          	bge	a5,a4,22b6 <reparent+0x20>
    }
  }
  exit(0);
    237e:	4501                	li	a0,0
    2380:	00005097          	auipc	ra,0x5
    2384:	74c080e7          	jalr	1868(ra) # 7acc <exit>

0000000000002388 <twochildren>:
}

// what if two children exit() at the same time?
void
twochildren(char *s)
{
    2388:	7179                	addi	sp,sp,-48
    238a:	f406                	sd	ra,40(sp)
    238c:	f022                	sd	s0,32(sp)
    238e:	1800                	addi	s0,sp,48
    2390:	fca43c23          	sd	a0,-40(s0)
  for(int i = 0; i < 1000; i++){
    2394:	fe042623          	sw	zero,-20(s0)
    2398:	a845                	j	2448 <twochildren+0xc0>
    int pid1 = fork();
    239a:	00005097          	auipc	ra,0x5
    239e:	72a080e7          	jalr	1834(ra) # 7ac4 <fork>
    23a2:	87aa                	mv	a5,a0
    23a4:	fef42423          	sw	a5,-24(s0)
    if(pid1 < 0){
    23a8:	fe842783          	lw	a5,-24(s0)
    23ac:	2781                	sext.w	a5,a5
    23ae:	0207d163          	bgez	a5,23d0 <twochildren+0x48>
      printf("%s: fork failed\n", s);
    23b2:	fd843583          	ld	a1,-40(s0)
    23b6:	00006517          	auipc	a0,0x6
    23ba:	3ba50513          	addi	a0,a0,954 # 8770 <malloc+0x584>
    23be:	00006097          	auipc	ra,0x6
    23c2:	c3a080e7          	jalr	-966(ra) # 7ff8 <printf>
      exit(1);
    23c6:	4505                	li	a0,1
    23c8:	00005097          	auipc	ra,0x5
    23cc:	704080e7          	jalr	1796(ra) # 7acc <exit>
    }
    if(pid1 == 0){
    23d0:	fe842783          	lw	a5,-24(s0)
    23d4:	2781                	sext.w	a5,a5
    23d6:	e791                	bnez	a5,23e2 <twochildren+0x5a>
      exit(0);
    23d8:	4501                	li	a0,0
    23da:	00005097          	auipc	ra,0x5
    23de:	6f2080e7          	jalr	1778(ra) # 7acc <exit>
    } else {
      int pid2 = fork();
    23e2:	00005097          	auipc	ra,0x5
    23e6:	6e2080e7          	jalr	1762(ra) # 7ac4 <fork>
    23ea:	87aa                	mv	a5,a0
    23ec:	fef42223          	sw	a5,-28(s0)
      if(pid2 < 0){
    23f0:	fe442783          	lw	a5,-28(s0)
    23f4:	2781                	sext.w	a5,a5
    23f6:	0207d163          	bgez	a5,2418 <twochildren+0x90>
        printf("%s: fork failed\n", s);
    23fa:	fd843583          	ld	a1,-40(s0)
    23fe:	00006517          	auipc	a0,0x6
    2402:	37250513          	addi	a0,a0,882 # 8770 <malloc+0x584>
    2406:	00006097          	auipc	ra,0x6
    240a:	bf2080e7          	jalr	-1038(ra) # 7ff8 <printf>
        exit(1);
    240e:	4505                	li	a0,1
    2410:	00005097          	auipc	ra,0x5
    2414:	6bc080e7          	jalr	1724(ra) # 7acc <exit>
      }
      if(pid2 == 0){
    2418:	fe442783          	lw	a5,-28(s0)
    241c:	2781                	sext.w	a5,a5
    241e:	e791                	bnez	a5,242a <twochildren+0xa2>
        exit(0);
    2420:	4501                	li	a0,0
    2422:	00005097          	auipc	ra,0x5
    2426:	6aa080e7          	jalr	1706(ra) # 7acc <exit>
      } else {
        wait(0);
    242a:	4501                	li	a0,0
    242c:	00005097          	auipc	ra,0x5
    2430:	6a8080e7          	jalr	1704(ra) # 7ad4 <wait>
        wait(0);
    2434:	4501                	li	a0,0
    2436:	00005097          	auipc	ra,0x5
    243a:	69e080e7          	jalr	1694(ra) # 7ad4 <wait>
  for(int i = 0; i < 1000; i++){
    243e:	fec42783          	lw	a5,-20(s0)
    2442:	2785                	addiw	a5,a5,1
    2444:	fef42623          	sw	a5,-20(s0)
    2448:	fec42783          	lw	a5,-20(s0)
    244c:	0007871b          	sext.w	a4,a5
    2450:	3e700793          	li	a5,999
    2454:	f4e7d3e3          	bge	a5,a4,239a <twochildren+0x12>
      }
    }
  }
}
    2458:	0001                	nop
    245a:	0001                	nop
    245c:	70a2                	ld	ra,40(sp)
    245e:	7402                	ld	s0,32(sp)
    2460:	6145                	addi	sp,sp,48
    2462:	8082                	ret

0000000000002464 <forkfork>:

// concurrent forks to try to expose locking bugs.
void
forkfork(char *s)
{
    2464:	7139                	addi	sp,sp,-64
    2466:	fc06                	sd	ra,56(sp)
    2468:	f822                	sd	s0,48(sp)
    246a:	0080                	addi	s0,sp,64
    246c:	fca43423          	sd	a0,-56(s0)
  enum { N=2 };
  
  for(int i = 0; i < N; i++){
    2470:	fe042623          	sw	zero,-20(s0)
    2474:	a84d                	j	2526 <forkfork+0xc2>
    int pid = fork();
    2476:	00005097          	auipc	ra,0x5
    247a:	64e080e7          	jalr	1614(ra) # 7ac4 <fork>
    247e:	87aa                	mv	a5,a0
    2480:	fef42023          	sw	a5,-32(s0)
    if(pid < 0){
    2484:	fe042783          	lw	a5,-32(s0)
    2488:	2781                	sext.w	a5,a5
    248a:	0207d163          	bgez	a5,24ac <forkfork+0x48>
      printf("%s: fork failed", s);
    248e:	fc843583          	ld	a1,-56(s0)
    2492:	00007517          	auipc	a0,0x7
    2496:	81650513          	addi	a0,a0,-2026 # 8ca8 <malloc+0xabc>
    249a:	00006097          	auipc	ra,0x6
    249e:	b5e080e7          	jalr	-1186(ra) # 7ff8 <printf>
      exit(1);
    24a2:	4505                	li	a0,1
    24a4:	00005097          	auipc	ra,0x5
    24a8:	628080e7          	jalr	1576(ra) # 7acc <exit>
    }
    if(pid == 0){
    24ac:	fe042783          	lw	a5,-32(s0)
    24b0:	2781                	sext.w	a5,a5
    24b2:	e7ad                	bnez	a5,251c <forkfork+0xb8>
      for(int j = 0; j < 200; j++){
    24b4:	fe042423          	sw	zero,-24(s0)
    24b8:	a0a9                	j	2502 <forkfork+0x9e>
        int pid1 = fork();
    24ba:	00005097          	auipc	ra,0x5
    24be:	60a080e7          	jalr	1546(ra) # 7ac4 <fork>
    24c2:	87aa                	mv	a5,a0
    24c4:	fcf42e23          	sw	a5,-36(s0)
        if(pid1 < 0){
    24c8:	fdc42783          	lw	a5,-36(s0)
    24cc:	2781                	sext.w	a5,a5
    24ce:	0007d763          	bgez	a5,24dc <forkfork+0x78>
          exit(1);
    24d2:	4505                	li	a0,1
    24d4:	00005097          	auipc	ra,0x5
    24d8:	5f8080e7          	jalr	1528(ra) # 7acc <exit>
        }
        if(pid1 == 0){
    24dc:	fdc42783          	lw	a5,-36(s0)
    24e0:	2781                	sext.w	a5,a5
    24e2:	e791                	bnez	a5,24ee <forkfork+0x8a>
          exit(0);
    24e4:	4501                	li	a0,0
    24e6:	00005097          	auipc	ra,0x5
    24ea:	5e6080e7          	jalr	1510(ra) # 7acc <exit>
        }
        wait(0);
    24ee:	4501                	li	a0,0
    24f0:	00005097          	auipc	ra,0x5
    24f4:	5e4080e7          	jalr	1508(ra) # 7ad4 <wait>
      for(int j = 0; j < 200; j++){
    24f8:	fe842783          	lw	a5,-24(s0)
    24fc:	2785                	addiw	a5,a5,1
    24fe:	fef42423          	sw	a5,-24(s0)
    2502:	fe842783          	lw	a5,-24(s0)
    2506:	0007871b          	sext.w	a4,a5
    250a:	0c700793          	li	a5,199
    250e:	fae7d6e3          	bge	a5,a4,24ba <forkfork+0x56>
      }
      exit(0);
    2512:	4501                	li	a0,0
    2514:	00005097          	auipc	ra,0x5
    2518:	5b8080e7          	jalr	1464(ra) # 7acc <exit>
  for(int i = 0; i < N; i++){
    251c:	fec42783          	lw	a5,-20(s0)
    2520:	2785                	addiw	a5,a5,1
    2522:	fef42623          	sw	a5,-20(s0)
    2526:	fec42783          	lw	a5,-20(s0)
    252a:	0007871b          	sext.w	a4,a5
    252e:	4785                	li	a5,1
    2530:	f4e7d3e3          	bge	a5,a4,2476 <forkfork+0x12>
    }
  }

  int xstatus;
  for(int i = 0; i < N; i++){
    2534:	fe042223          	sw	zero,-28(s0)
    2538:	a83d                	j	2576 <forkfork+0x112>
    wait(&xstatus);
    253a:	fd840793          	addi	a5,s0,-40
    253e:	853e                	mv	a0,a5
    2540:	00005097          	auipc	ra,0x5
    2544:	594080e7          	jalr	1428(ra) # 7ad4 <wait>
    if(xstatus != 0) {
    2548:	fd842783          	lw	a5,-40(s0)
    254c:	c385                	beqz	a5,256c <forkfork+0x108>
      printf("%s: fork in child failed", s);
    254e:	fc843583          	ld	a1,-56(s0)
    2552:	00006517          	auipc	a0,0x6
    2556:	7ee50513          	addi	a0,a0,2030 # 8d40 <malloc+0xb54>
    255a:	00006097          	auipc	ra,0x6
    255e:	a9e080e7          	jalr	-1378(ra) # 7ff8 <printf>
      exit(1);
    2562:	4505                	li	a0,1
    2564:	00005097          	auipc	ra,0x5
    2568:	568080e7          	jalr	1384(ra) # 7acc <exit>
  for(int i = 0; i < N; i++){
    256c:	fe442783          	lw	a5,-28(s0)
    2570:	2785                	addiw	a5,a5,1
    2572:	fef42223          	sw	a5,-28(s0)
    2576:	fe442783          	lw	a5,-28(s0)
    257a:	0007871b          	sext.w	a4,a5
    257e:	4785                	li	a5,1
    2580:	fae7dde3          	bge	a5,a4,253a <forkfork+0xd6>
    }
  }
}
    2584:	0001                	nop
    2586:	0001                	nop
    2588:	70e2                	ld	ra,56(sp)
    258a:	7442                	ld	s0,48(sp)
    258c:	6121                	addi	sp,sp,64
    258e:	8082                	ret

0000000000002590 <forkforkfork>:

void
forkforkfork(char *s)
{
    2590:	7179                	addi	sp,sp,-48
    2592:	f406                	sd	ra,40(sp)
    2594:	f022                	sd	s0,32(sp)
    2596:	1800                	addi	s0,sp,48
    2598:	fca43c23          	sd	a0,-40(s0)
  unlink("stopforking");
    259c:	00006517          	auipc	a0,0x6
    25a0:	7c450513          	addi	a0,a0,1988 # 8d60 <malloc+0xb74>
    25a4:	00005097          	auipc	ra,0x5
    25a8:	578080e7          	jalr	1400(ra) # 7b1c <unlink>

  int pid = fork();
    25ac:	00005097          	auipc	ra,0x5
    25b0:	518080e7          	jalr	1304(ra) # 7ac4 <fork>
    25b4:	87aa                	mv	a5,a0
    25b6:	fef42623          	sw	a5,-20(s0)
  if(pid < 0){
    25ba:	fec42783          	lw	a5,-20(s0)
    25be:	2781                	sext.w	a5,a5
    25c0:	0207d163          	bgez	a5,25e2 <forkforkfork+0x52>
    printf("%s: fork failed", s);
    25c4:	fd843583          	ld	a1,-40(s0)
    25c8:	00006517          	auipc	a0,0x6
    25cc:	6e050513          	addi	a0,a0,1760 # 8ca8 <malloc+0xabc>
    25d0:	00006097          	auipc	ra,0x6
    25d4:	a28080e7          	jalr	-1496(ra) # 7ff8 <printf>
    exit(1);
    25d8:	4505                	li	a0,1
    25da:	00005097          	auipc	ra,0x5
    25de:	4f2080e7          	jalr	1266(ra) # 7acc <exit>
  }
  if(pid == 0){
    25e2:	fec42783          	lw	a5,-20(s0)
    25e6:	2781                	sext.w	a5,a5
    25e8:	efb9                	bnez	a5,2646 <forkforkfork+0xb6>
    while(1){
      int fd = open("stopforking", 0);
    25ea:	4581                	li	a1,0
    25ec:	00006517          	auipc	a0,0x6
    25f0:	77450513          	addi	a0,a0,1908 # 8d60 <malloc+0xb74>
    25f4:	00005097          	auipc	ra,0x5
    25f8:	518080e7          	jalr	1304(ra) # 7b0c <open>
    25fc:	87aa                	mv	a5,a0
    25fe:	fef42423          	sw	a5,-24(s0)
      if(fd >= 0){
    2602:	fe842783          	lw	a5,-24(s0)
    2606:	2781                	sext.w	a5,a5
    2608:	0007c763          	bltz	a5,2616 <forkforkfork+0x86>
        exit(0);
    260c:	4501                	li	a0,0
    260e:	00005097          	auipc	ra,0x5
    2612:	4be080e7          	jalr	1214(ra) # 7acc <exit>
      }
      if(fork() < 0){
    2616:	00005097          	auipc	ra,0x5
    261a:	4ae080e7          	jalr	1198(ra) # 7ac4 <fork>
    261e:	87aa                	mv	a5,a0
    2620:	fc07d5e3          	bgez	a5,25ea <forkforkfork+0x5a>
        close(open("stopforking", O_CREATE|O_RDWR));
    2624:	20200593          	li	a1,514
    2628:	00006517          	auipc	a0,0x6
    262c:	73850513          	addi	a0,a0,1848 # 8d60 <malloc+0xb74>
    2630:	00005097          	auipc	ra,0x5
    2634:	4dc080e7          	jalr	1244(ra) # 7b0c <open>
    2638:	87aa                	mv	a5,a0
    263a:	853e                	mv	a0,a5
    263c:	00005097          	auipc	ra,0x5
    2640:	4b8080e7          	jalr	1208(ra) # 7af4 <close>
    while(1){
    2644:	b75d                	j	25ea <forkforkfork+0x5a>
    }

    exit(0);
  }

  sleep(20); // two seconds
    2646:	4551                	li	a0,20
    2648:	00005097          	auipc	ra,0x5
    264c:	514080e7          	jalr	1300(ra) # 7b5c <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    2650:	20200593          	li	a1,514
    2654:	00006517          	auipc	a0,0x6
    2658:	70c50513          	addi	a0,a0,1804 # 8d60 <malloc+0xb74>
    265c:	00005097          	auipc	ra,0x5
    2660:	4b0080e7          	jalr	1200(ra) # 7b0c <open>
    2664:	87aa                	mv	a5,a0
    2666:	853e                	mv	a0,a5
    2668:	00005097          	auipc	ra,0x5
    266c:	48c080e7          	jalr	1164(ra) # 7af4 <close>
  wait(0);
    2670:	4501                	li	a0,0
    2672:	00005097          	auipc	ra,0x5
    2676:	462080e7          	jalr	1122(ra) # 7ad4 <wait>
  sleep(10); // one second
    267a:	4529                	li	a0,10
    267c:	00005097          	auipc	ra,0x5
    2680:	4e0080e7          	jalr	1248(ra) # 7b5c <sleep>
}
    2684:	0001                	nop
    2686:	70a2                	ld	ra,40(sp)
    2688:	7402                	ld	s0,32(sp)
    268a:	6145                	addi	sp,sp,48
    268c:	8082                	ret

000000000000268e <reparent2>:
// deadlocks against init's wait()? also used to trigger a "panic:
// release" due to exit() releasing a different p->parent->lock than
// it acquired.
void
reparent2(char *s)
{
    268e:	7179                	addi	sp,sp,-48
    2690:	f406                	sd	ra,40(sp)
    2692:	f022                	sd	s0,32(sp)
    2694:	1800                	addi	s0,sp,48
    2696:	fca43c23          	sd	a0,-40(s0)
  for(int i = 0; i < 800; i++){
    269a:	fe042623          	sw	zero,-20(s0)
    269e:	a0ad                	j	2708 <reparent2+0x7a>
    int pid1 = fork();
    26a0:	00005097          	auipc	ra,0x5
    26a4:	424080e7          	jalr	1060(ra) # 7ac4 <fork>
    26a8:	87aa                	mv	a5,a0
    26aa:	fef42423          	sw	a5,-24(s0)
    if(pid1 < 0){
    26ae:	fe842783          	lw	a5,-24(s0)
    26b2:	2781                	sext.w	a5,a5
    26b4:	0007df63          	bgez	a5,26d2 <reparent2+0x44>
      printf("fork failed\n");
    26b8:	00006517          	auipc	a0,0x6
    26bc:	e8850513          	addi	a0,a0,-376 # 8540 <malloc+0x354>
    26c0:	00006097          	auipc	ra,0x6
    26c4:	938080e7          	jalr	-1736(ra) # 7ff8 <printf>
      exit(1);
    26c8:	4505                	li	a0,1
    26ca:	00005097          	auipc	ra,0x5
    26ce:	402080e7          	jalr	1026(ra) # 7acc <exit>
    }
    if(pid1 == 0){
    26d2:	fe842783          	lw	a5,-24(s0)
    26d6:	2781                	sext.w	a5,a5
    26d8:	ef91                	bnez	a5,26f4 <reparent2+0x66>
      fork();
    26da:	00005097          	auipc	ra,0x5
    26de:	3ea080e7          	jalr	1002(ra) # 7ac4 <fork>
      fork();
    26e2:	00005097          	auipc	ra,0x5
    26e6:	3e2080e7          	jalr	994(ra) # 7ac4 <fork>
      exit(0);
    26ea:	4501                	li	a0,0
    26ec:	00005097          	auipc	ra,0x5
    26f0:	3e0080e7          	jalr	992(ra) # 7acc <exit>
    }
    wait(0);
    26f4:	4501                	li	a0,0
    26f6:	00005097          	auipc	ra,0x5
    26fa:	3de080e7          	jalr	990(ra) # 7ad4 <wait>
  for(int i = 0; i < 800; i++){
    26fe:	fec42783          	lw	a5,-20(s0)
    2702:	2785                	addiw	a5,a5,1
    2704:	fef42623          	sw	a5,-20(s0)
    2708:	fec42783          	lw	a5,-20(s0)
    270c:	0007871b          	sext.w	a4,a5
    2710:	31f00793          	li	a5,799
    2714:	f8e7d6e3          	bge	a5,a4,26a0 <reparent2+0x12>
  }

  exit(0);
    2718:	4501                	li	a0,0
    271a:	00005097          	auipc	ra,0x5
    271e:	3b2080e7          	jalr	946(ra) # 7acc <exit>

0000000000002722 <mem>:
}

// allocate all mem, free it, and allocate again
void
mem(char *s)
{
    2722:	7139                	addi	sp,sp,-64
    2724:	fc06                	sd	ra,56(sp)
    2726:	f822                	sd	s0,48(sp)
    2728:	0080                	addi	s0,sp,64
    272a:	fca43423          	sd	a0,-56(s0)
  void *m1, *m2;
  int pid;

  if((pid = fork()) == 0){
    272e:	00005097          	auipc	ra,0x5
    2732:	396080e7          	jalr	918(ra) # 7ac4 <fork>
    2736:	87aa                	mv	a5,a0
    2738:	fef42223          	sw	a5,-28(s0)
    273c:	fe442783          	lw	a5,-28(s0)
    2740:	2781                	sext.w	a5,a5
    2742:	e3c5                	bnez	a5,27e2 <mem+0xc0>
    m1 = 0;
    2744:	fe043423          	sd	zero,-24(s0)
    while((m2 = malloc(10001)) != 0){
    2748:	a811                	j	275c <mem+0x3a>
      *(char**)m2 = m1;
    274a:	fd843783          	ld	a5,-40(s0)
    274e:	fe843703          	ld	a4,-24(s0)
    2752:	e398                	sd	a4,0(a5)
      m1 = m2;
    2754:	fd843783          	ld	a5,-40(s0)
    2758:	fef43423          	sd	a5,-24(s0)
    while((m2 = malloc(10001)) != 0){
    275c:	6789                	lui	a5,0x2
    275e:	71178513          	addi	a0,a5,1809 # 2711 <reparent2+0x83>
    2762:	00006097          	auipc	ra,0x6
    2766:	a8a080e7          	jalr	-1398(ra) # 81ec <malloc>
    276a:	fca43c23          	sd	a0,-40(s0)
    276e:	fd843783          	ld	a5,-40(s0)
    2772:	ffe1                	bnez	a5,274a <mem+0x28>
    }
    while(m1){
    2774:	a005                	j	2794 <mem+0x72>
      m2 = *(char**)m1;
    2776:	fe843783          	ld	a5,-24(s0)
    277a:	639c                	ld	a5,0(a5)
    277c:	fcf43c23          	sd	a5,-40(s0)
      free(m1);
    2780:	fe843503          	ld	a0,-24(s0)
    2784:	00006097          	auipc	ra,0x6
    2788:	8c4080e7          	jalr	-1852(ra) # 8048 <free>
      m1 = m2;
    278c:	fd843783          	ld	a5,-40(s0)
    2790:	fef43423          	sd	a5,-24(s0)
    while(m1){
    2794:	fe843783          	ld	a5,-24(s0)
    2798:	fff9                	bnez	a5,2776 <mem+0x54>
    }
    m1 = malloc(1024*20);
    279a:	6515                	lui	a0,0x5
    279c:	00006097          	auipc	ra,0x6
    27a0:	a50080e7          	jalr	-1456(ra) # 81ec <malloc>
    27a4:	fea43423          	sd	a0,-24(s0)
    if(m1 == 0){
    27a8:	fe843783          	ld	a5,-24(s0)
    27ac:	e385                	bnez	a5,27cc <mem+0xaa>
      printf("couldn't allocate mem?!!\n", s);
    27ae:	fc843583          	ld	a1,-56(s0)
    27b2:	00006517          	auipc	a0,0x6
    27b6:	5be50513          	addi	a0,a0,1470 # 8d70 <malloc+0xb84>
    27ba:	00006097          	auipc	ra,0x6
    27be:	83e080e7          	jalr	-1986(ra) # 7ff8 <printf>
      exit(1);
    27c2:	4505                	li	a0,1
    27c4:	00005097          	auipc	ra,0x5
    27c8:	308080e7          	jalr	776(ra) # 7acc <exit>
    }
    free(m1);
    27cc:	fe843503          	ld	a0,-24(s0)
    27d0:	00006097          	auipc	ra,0x6
    27d4:	878080e7          	jalr	-1928(ra) # 8048 <free>
    exit(0);
    27d8:	4501                	li	a0,0
    27da:	00005097          	auipc	ra,0x5
    27de:	2f2080e7          	jalr	754(ra) # 7acc <exit>
  } else {
    int xstatus;
    wait(&xstatus);
    27e2:	fd440793          	addi	a5,s0,-44
    27e6:	853e                	mv	a0,a5
    27e8:	00005097          	auipc	ra,0x5
    27ec:	2ec080e7          	jalr	748(ra) # 7ad4 <wait>
    if(xstatus == -1){
    27f0:	fd442703          	lw	a4,-44(s0)
    27f4:	57fd                	li	a5,-1
    27f6:	00f71763          	bne	a4,a5,2804 <mem+0xe2>
      // probably page fault, so might be lazy lab,
      // so OK.
      exit(0);
    27fa:	4501                	li	a0,0
    27fc:	00005097          	auipc	ra,0x5
    2800:	2d0080e7          	jalr	720(ra) # 7acc <exit>
    }
    exit(xstatus);
    2804:	fd442783          	lw	a5,-44(s0)
    2808:	853e                	mv	a0,a5
    280a:	00005097          	auipc	ra,0x5
    280e:	2c2080e7          	jalr	706(ra) # 7acc <exit>

0000000000002812 <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(char *s)
{
    2812:	715d                	addi	sp,sp,-80
    2814:	e486                	sd	ra,72(sp)
    2816:	e0a2                	sd	s0,64(sp)
    2818:	0880                	addi	s0,sp,80
    281a:	faa43c23          	sd	a0,-72(s0)
  int fd, pid, i, n, nc, np;
  enum { N = 1000, SZ=10};
  char buf[SZ];

  unlink("sharedfd");
    281e:	00006517          	auipc	a0,0x6
    2822:	57250513          	addi	a0,a0,1394 # 8d90 <malloc+0xba4>
    2826:	00005097          	auipc	ra,0x5
    282a:	2f6080e7          	jalr	758(ra) # 7b1c <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    282e:	20200593          	li	a1,514
    2832:	00006517          	auipc	a0,0x6
    2836:	55e50513          	addi	a0,a0,1374 # 8d90 <malloc+0xba4>
    283a:	00005097          	auipc	ra,0x5
    283e:	2d2080e7          	jalr	722(ra) # 7b0c <open>
    2842:	87aa                	mv	a5,a0
    2844:	fef42023          	sw	a5,-32(s0)
  if(fd < 0){
    2848:	fe042783          	lw	a5,-32(s0)
    284c:	2781                	sext.w	a5,a5
    284e:	0207d163          	bgez	a5,2870 <sharedfd+0x5e>
    printf("%s: cannot open sharedfd for writing", s);
    2852:	fb843583          	ld	a1,-72(s0)
    2856:	00006517          	auipc	a0,0x6
    285a:	54a50513          	addi	a0,a0,1354 # 8da0 <malloc+0xbb4>
    285e:	00005097          	auipc	ra,0x5
    2862:	79a080e7          	jalr	1946(ra) # 7ff8 <printf>
    exit(1);
    2866:	4505                	li	a0,1
    2868:	00005097          	auipc	ra,0x5
    286c:	264080e7          	jalr	612(ra) # 7acc <exit>
  }
  pid = fork();
    2870:	00005097          	auipc	ra,0x5
    2874:	254080e7          	jalr	596(ra) # 7ac4 <fork>
    2878:	87aa                	mv	a5,a0
    287a:	fcf42e23          	sw	a5,-36(s0)
  memset(buf, pid==0?'c':'p', sizeof(buf));
    287e:	fdc42783          	lw	a5,-36(s0)
    2882:	2781                	sext.w	a5,a5
    2884:	e781                	bnez	a5,288c <sharedfd+0x7a>
    2886:	06300793          	li	a5,99
    288a:	a019                	j	2890 <sharedfd+0x7e>
    288c:	07000793          	li	a5,112
    2890:	fc840713          	addi	a4,s0,-56
    2894:	4629                	li	a2,10
    2896:	85be                	mv	a1,a5
    2898:	853a                	mv	a0,a4
    289a:	00005097          	auipc	ra,0x5
    289e:	e74080e7          	jalr	-396(ra) # 770e <memset>
  for(i = 0; i < N; i++){
    28a2:	fe042623          	sw	zero,-20(s0)
    28a6:	a0a9                	j	28f0 <sharedfd+0xde>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    28a8:	fc840713          	addi	a4,s0,-56
    28ac:	fe042783          	lw	a5,-32(s0)
    28b0:	4629                	li	a2,10
    28b2:	85ba                	mv	a1,a4
    28b4:	853e                	mv	a0,a5
    28b6:	00005097          	auipc	ra,0x5
    28ba:	236080e7          	jalr	566(ra) # 7aec <write>
    28be:	87aa                	mv	a5,a0
    28c0:	873e                	mv	a4,a5
    28c2:	47a9                	li	a5,10
    28c4:	02f70163          	beq	a4,a5,28e6 <sharedfd+0xd4>
      printf("%s: write sharedfd failed\n", s);
    28c8:	fb843583          	ld	a1,-72(s0)
    28cc:	00006517          	auipc	a0,0x6
    28d0:	4fc50513          	addi	a0,a0,1276 # 8dc8 <malloc+0xbdc>
    28d4:	00005097          	auipc	ra,0x5
    28d8:	724080e7          	jalr	1828(ra) # 7ff8 <printf>
      exit(1);
    28dc:	4505                	li	a0,1
    28de:	00005097          	auipc	ra,0x5
    28e2:	1ee080e7          	jalr	494(ra) # 7acc <exit>
  for(i = 0; i < N; i++){
    28e6:	fec42783          	lw	a5,-20(s0)
    28ea:	2785                	addiw	a5,a5,1
    28ec:	fef42623          	sw	a5,-20(s0)
    28f0:	fec42783          	lw	a5,-20(s0)
    28f4:	0007871b          	sext.w	a4,a5
    28f8:	3e700793          	li	a5,999
    28fc:	fae7d6e3          	bge	a5,a4,28a8 <sharedfd+0x96>
    }
  }
  if(pid == 0) {
    2900:	fdc42783          	lw	a5,-36(s0)
    2904:	2781                	sext.w	a5,a5
    2906:	e791                	bnez	a5,2912 <sharedfd+0x100>
    exit(0);
    2908:	4501                	li	a0,0
    290a:	00005097          	auipc	ra,0x5
    290e:	1c2080e7          	jalr	450(ra) # 7acc <exit>
  } else {
    int xstatus;
    wait(&xstatus);
    2912:	fc440793          	addi	a5,s0,-60
    2916:	853e                	mv	a0,a5
    2918:	00005097          	auipc	ra,0x5
    291c:	1bc080e7          	jalr	444(ra) # 7ad4 <wait>
    if(xstatus != 0)
    2920:	fc442783          	lw	a5,-60(s0)
    2924:	cb81                	beqz	a5,2934 <sharedfd+0x122>
      exit(xstatus);
    2926:	fc442783          	lw	a5,-60(s0)
    292a:	853e                	mv	a0,a5
    292c:	00005097          	auipc	ra,0x5
    2930:	1a0080e7          	jalr	416(ra) # 7acc <exit>
  }
  
  close(fd);
    2934:	fe042783          	lw	a5,-32(s0)
    2938:	853e                	mv	a0,a5
    293a:	00005097          	auipc	ra,0x5
    293e:	1ba080e7          	jalr	442(ra) # 7af4 <close>
  fd = open("sharedfd", 0);
    2942:	4581                	li	a1,0
    2944:	00006517          	auipc	a0,0x6
    2948:	44c50513          	addi	a0,a0,1100 # 8d90 <malloc+0xba4>
    294c:	00005097          	auipc	ra,0x5
    2950:	1c0080e7          	jalr	448(ra) # 7b0c <open>
    2954:	87aa                	mv	a5,a0
    2956:	fef42023          	sw	a5,-32(s0)
  if(fd < 0){
    295a:	fe042783          	lw	a5,-32(s0)
    295e:	2781                	sext.w	a5,a5
    2960:	0207d163          	bgez	a5,2982 <sharedfd+0x170>
    printf("%s: cannot open sharedfd for reading\n", s);
    2964:	fb843583          	ld	a1,-72(s0)
    2968:	00006517          	auipc	a0,0x6
    296c:	48050513          	addi	a0,a0,1152 # 8de8 <malloc+0xbfc>
    2970:	00005097          	auipc	ra,0x5
    2974:	688080e7          	jalr	1672(ra) # 7ff8 <printf>
    exit(1);
    2978:	4505                	li	a0,1
    297a:	00005097          	auipc	ra,0x5
    297e:	152080e7          	jalr	338(ra) # 7acc <exit>
  }
  nc = np = 0;
    2982:	fe042223          	sw	zero,-28(s0)
    2986:	fe442783          	lw	a5,-28(s0)
    298a:	fef42423          	sw	a5,-24(s0)
  while((n = read(fd, buf, sizeof(buf))) > 0){
    298e:	a8b1                	j	29ea <sharedfd+0x1d8>
    for(i = 0; i < sizeof(buf); i++){
    2990:	fe042623          	sw	zero,-20(s0)
    2994:	a0b1                	j	29e0 <sharedfd+0x1ce>
      if(buf[i] == 'c')
    2996:	fec42783          	lw	a5,-20(s0)
    299a:	17c1                	addi	a5,a5,-16
    299c:	97a2                	add	a5,a5,s0
    299e:	fd87c783          	lbu	a5,-40(a5)
    29a2:	873e                	mv	a4,a5
    29a4:	06300793          	li	a5,99
    29a8:	00f71763          	bne	a4,a5,29b6 <sharedfd+0x1a4>
        nc++;
    29ac:	fe842783          	lw	a5,-24(s0)
    29b0:	2785                	addiw	a5,a5,1
    29b2:	fef42423          	sw	a5,-24(s0)
      if(buf[i] == 'p')
    29b6:	fec42783          	lw	a5,-20(s0)
    29ba:	17c1                	addi	a5,a5,-16
    29bc:	97a2                	add	a5,a5,s0
    29be:	fd87c783          	lbu	a5,-40(a5)
    29c2:	873e                	mv	a4,a5
    29c4:	07000793          	li	a5,112
    29c8:	00f71763          	bne	a4,a5,29d6 <sharedfd+0x1c4>
        np++;
    29cc:	fe442783          	lw	a5,-28(s0)
    29d0:	2785                	addiw	a5,a5,1
    29d2:	fef42223          	sw	a5,-28(s0)
    for(i = 0; i < sizeof(buf); i++){
    29d6:	fec42783          	lw	a5,-20(s0)
    29da:	2785                	addiw	a5,a5,1
    29dc:	fef42623          	sw	a5,-20(s0)
    29e0:	fec42703          	lw	a4,-20(s0)
    29e4:	47a5                	li	a5,9
    29e6:	fae7f8e3          	bgeu	a5,a4,2996 <sharedfd+0x184>
  while((n = read(fd, buf, sizeof(buf))) > 0){
    29ea:	fc840713          	addi	a4,s0,-56
    29ee:	fe042783          	lw	a5,-32(s0)
    29f2:	4629                	li	a2,10
    29f4:	85ba                	mv	a1,a4
    29f6:	853e                	mv	a0,a5
    29f8:	00005097          	auipc	ra,0x5
    29fc:	0ec080e7          	jalr	236(ra) # 7ae4 <read>
    2a00:	87aa                	mv	a5,a0
    2a02:	fcf42c23          	sw	a5,-40(s0)
    2a06:	fd842783          	lw	a5,-40(s0)
    2a0a:	2781                	sext.w	a5,a5
    2a0c:	f8f042e3          	bgtz	a5,2990 <sharedfd+0x17e>
    }
  }
  close(fd);
    2a10:	fe042783          	lw	a5,-32(s0)
    2a14:	853e                	mv	a0,a5
    2a16:	00005097          	auipc	ra,0x5
    2a1a:	0de080e7          	jalr	222(ra) # 7af4 <close>
  unlink("sharedfd");
    2a1e:	00006517          	auipc	a0,0x6
    2a22:	37250513          	addi	a0,a0,882 # 8d90 <malloc+0xba4>
    2a26:	00005097          	auipc	ra,0x5
    2a2a:	0f6080e7          	jalr	246(ra) # 7b1c <unlink>
  if(nc == N*SZ && np == N*SZ){
    2a2e:	fe842783          	lw	a5,-24(s0)
    2a32:	0007871b          	sext.w	a4,a5
    2a36:	6789                	lui	a5,0x2
    2a38:	71078793          	addi	a5,a5,1808 # 2710 <reparent2+0x82>
    2a3c:	02f71063          	bne	a4,a5,2a5c <sharedfd+0x24a>
    2a40:	fe442783          	lw	a5,-28(s0)
    2a44:	0007871b          	sext.w	a4,a5
    2a48:	6789                	lui	a5,0x2
    2a4a:	71078793          	addi	a5,a5,1808 # 2710 <reparent2+0x82>
    2a4e:	00f71763          	bne	a4,a5,2a5c <sharedfd+0x24a>
    exit(0);
    2a52:	4501                	li	a0,0
    2a54:	00005097          	auipc	ra,0x5
    2a58:	078080e7          	jalr	120(ra) # 7acc <exit>
  } else {
    printf("%s: nc/np test fails\n", s);
    2a5c:	fb843583          	ld	a1,-72(s0)
    2a60:	00006517          	auipc	a0,0x6
    2a64:	3b050513          	addi	a0,a0,944 # 8e10 <malloc+0xc24>
    2a68:	00005097          	auipc	ra,0x5
    2a6c:	590080e7          	jalr	1424(ra) # 7ff8 <printf>
    exit(1);
    2a70:	4505                	li	a0,1
    2a72:	00005097          	auipc	ra,0x5
    2a76:	05a080e7          	jalr	90(ra) # 7acc <exit>

0000000000002a7a <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(char *s)
{
    2a7a:	7159                	addi	sp,sp,-112
    2a7c:	f486                	sd	ra,104(sp)
    2a7e:	f0a2                	sd	s0,96(sp)
    2a80:	1880                	addi	s0,sp,112
    2a82:	f8a43c23          	sd	a0,-104(s0)
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
    2a86:	00006797          	auipc	a5,0x6
    2a8a:	41278793          	addi	a5,a5,1042 # 8e98 <malloc+0xcac>
    2a8e:	6390                	ld	a2,0(a5)
    2a90:	6794                	ld	a3,8(a5)
    2a92:	6b98                	ld	a4,16(a5)
    2a94:	6f9c                	ld	a5,24(a5)
    2a96:	fac43423          	sd	a2,-88(s0)
    2a9a:	fad43823          	sd	a3,-80(s0)
    2a9e:	fae43c23          	sd	a4,-72(s0)
    2aa2:	fcf43023          	sd	a5,-64(s0)
  char *fname;
  enum { N=12, NCHILD=4, SZ=500 };
  
  for(pi = 0; pi < NCHILD; pi++){
    2aa6:	fe042023          	sw	zero,-32(s0)
    2aaa:	aa3d                	j	2be8 <fourfiles+0x16e>
    fname = names[pi];
    2aac:	fe042703          	lw	a4,-32(s0)
    2ab0:	fa840793          	addi	a5,s0,-88
    2ab4:	070e                	slli	a4,a4,0x3
    2ab6:	97ba                	add	a5,a5,a4
    2ab8:	639c                	ld	a5,0(a5)
    2aba:	fcf43c23          	sd	a5,-40(s0)
    unlink(fname);
    2abe:	fd843503          	ld	a0,-40(s0)
    2ac2:	00005097          	auipc	ra,0x5
    2ac6:	05a080e7          	jalr	90(ra) # 7b1c <unlink>

    pid = fork();
    2aca:	00005097          	auipc	ra,0x5
    2ace:	ffa080e7          	jalr	-6(ra) # 7ac4 <fork>
    2ad2:	87aa                	mv	a5,a0
    2ad4:	fcf42623          	sw	a5,-52(s0)
    if(pid < 0){
    2ad8:	fcc42783          	lw	a5,-52(s0)
    2adc:	2781                	sext.w	a5,a5
    2ade:	0207d163          	bgez	a5,2b00 <fourfiles+0x86>
      printf("fork failed\n", s);
    2ae2:	f9843583          	ld	a1,-104(s0)
    2ae6:	00006517          	auipc	a0,0x6
    2aea:	a5a50513          	addi	a0,a0,-1446 # 8540 <malloc+0x354>
    2aee:	00005097          	auipc	ra,0x5
    2af2:	50a080e7          	jalr	1290(ra) # 7ff8 <printf>
      exit(1);
    2af6:	4505                	li	a0,1
    2af8:	00005097          	auipc	ra,0x5
    2afc:	fd4080e7          	jalr	-44(ra) # 7acc <exit>
    }

    if(pid == 0){
    2b00:	fcc42783          	lw	a5,-52(s0)
    2b04:	2781                	sext.w	a5,a5
    2b06:	efe1                	bnez	a5,2bde <fourfiles+0x164>
      fd = open(fname, O_CREATE | O_RDWR);
    2b08:	20200593          	li	a1,514
    2b0c:	fd843503          	ld	a0,-40(s0)
    2b10:	00005097          	auipc	ra,0x5
    2b14:	ffc080e7          	jalr	-4(ra) # 7b0c <open>
    2b18:	87aa                	mv	a5,a0
    2b1a:	fcf42a23          	sw	a5,-44(s0)
      if(fd < 0){
    2b1e:	fd442783          	lw	a5,-44(s0)
    2b22:	2781                	sext.w	a5,a5
    2b24:	0207d163          	bgez	a5,2b46 <fourfiles+0xcc>
        printf("create failed\n", s);
    2b28:	f9843583          	ld	a1,-104(s0)
    2b2c:	00006517          	auipc	a0,0x6
    2b30:	2fc50513          	addi	a0,a0,764 # 8e28 <malloc+0xc3c>
    2b34:	00005097          	auipc	ra,0x5
    2b38:	4c4080e7          	jalr	1220(ra) # 7ff8 <printf>
        exit(1);
    2b3c:	4505                	li	a0,1
    2b3e:	00005097          	auipc	ra,0x5
    2b42:	f8e080e7          	jalr	-114(ra) # 7acc <exit>
      }

      memset(buf, '0'+pi, SZ);
    2b46:	fe042783          	lw	a5,-32(s0)
    2b4a:	0307879b          	addiw	a5,a5,48
    2b4e:	2781                	sext.w	a5,a5
    2b50:	1f400613          	li	a2,500
    2b54:	85be                	mv	a1,a5
    2b56:	00009517          	auipc	a0,0x9
    2b5a:	91a50513          	addi	a0,a0,-1766 # b470 <buf>
    2b5e:	00005097          	auipc	ra,0x5
    2b62:	bb0080e7          	jalr	-1104(ra) # 770e <memset>
      for(i = 0; i < N; i++){
    2b66:	fe042623          	sw	zero,-20(s0)
    2b6a:	a8b1                	j	2bc6 <fourfiles+0x14c>
        if((n = write(fd, buf, SZ)) != SZ){
    2b6c:	fd442783          	lw	a5,-44(s0)
    2b70:	1f400613          	li	a2,500
    2b74:	00009597          	auipc	a1,0x9
    2b78:	8fc58593          	addi	a1,a1,-1796 # b470 <buf>
    2b7c:	853e                	mv	a0,a5
    2b7e:	00005097          	auipc	ra,0x5
    2b82:	f6e080e7          	jalr	-146(ra) # 7aec <write>
    2b86:	87aa                	mv	a5,a0
    2b88:	fcf42823          	sw	a5,-48(s0)
    2b8c:	fd042783          	lw	a5,-48(s0)
    2b90:	0007871b          	sext.w	a4,a5
    2b94:	1f400793          	li	a5,500
    2b98:	02f70263          	beq	a4,a5,2bbc <fourfiles+0x142>
          printf("write failed %d\n", n);
    2b9c:	fd042783          	lw	a5,-48(s0)
    2ba0:	85be                	mv	a1,a5
    2ba2:	00006517          	auipc	a0,0x6
    2ba6:	29650513          	addi	a0,a0,662 # 8e38 <malloc+0xc4c>
    2baa:	00005097          	auipc	ra,0x5
    2bae:	44e080e7          	jalr	1102(ra) # 7ff8 <printf>
          exit(1);
    2bb2:	4505                	li	a0,1
    2bb4:	00005097          	auipc	ra,0x5
    2bb8:	f18080e7          	jalr	-232(ra) # 7acc <exit>
      for(i = 0; i < N; i++){
    2bbc:	fec42783          	lw	a5,-20(s0)
    2bc0:	2785                	addiw	a5,a5,1
    2bc2:	fef42623          	sw	a5,-20(s0)
    2bc6:	fec42783          	lw	a5,-20(s0)
    2bca:	0007871b          	sext.w	a4,a5
    2bce:	47ad                	li	a5,11
    2bd0:	f8e7dee3          	bge	a5,a4,2b6c <fourfiles+0xf2>
        }
      }
      exit(0);
    2bd4:	4501                	li	a0,0
    2bd6:	00005097          	auipc	ra,0x5
    2bda:	ef6080e7          	jalr	-266(ra) # 7acc <exit>
  for(pi = 0; pi < NCHILD; pi++){
    2bde:	fe042783          	lw	a5,-32(s0)
    2be2:	2785                	addiw	a5,a5,1
    2be4:	fef42023          	sw	a5,-32(s0)
    2be8:	fe042783          	lw	a5,-32(s0)
    2bec:	0007871b          	sext.w	a4,a5
    2bf0:	478d                	li	a5,3
    2bf2:	eae7dde3          	bge	a5,a4,2aac <fourfiles+0x32>
    }
  }

  int xstatus;
  for(pi = 0; pi < NCHILD; pi++){
    2bf6:	fe042023          	sw	zero,-32(s0)
    2bfa:	a03d                	j	2c28 <fourfiles+0x1ae>
    wait(&xstatus);
    2bfc:	fa440793          	addi	a5,s0,-92
    2c00:	853e                	mv	a0,a5
    2c02:	00005097          	auipc	ra,0x5
    2c06:	ed2080e7          	jalr	-302(ra) # 7ad4 <wait>
    if(xstatus != 0)
    2c0a:	fa442783          	lw	a5,-92(s0)
    2c0e:	cb81                	beqz	a5,2c1e <fourfiles+0x1a4>
      exit(xstatus);
    2c10:	fa442783          	lw	a5,-92(s0)
    2c14:	853e                	mv	a0,a5
    2c16:	00005097          	auipc	ra,0x5
    2c1a:	eb6080e7          	jalr	-330(ra) # 7acc <exit>
  for(pi = 0; pi < NCHILD; pi++){
    2c1e:	fe042783          	lw	a5,-32(s0)
    2c22:	2785                	addiw	a5,a5,1
    2c24:	fef42023          	sw	a5,-32(s0)
    2c28:	fe042783          	lw	a5,-32(s0)
    2c2c:	0007871b          	sext.w	a4,a5
    2c30:	478d                	li	a5,3
    2c32:	fce7d5e3          	bge	a5,a4,2bfc <fourfiles+0x182>
  }

  for(i = 0; i < NCHILD; i++){
    2c36:	fe042623          	sw	zero,-20(s0)
    2c3a:	a205                	j	2d5a <fourfiles+0x2e0>
    fname = names[i];
    2c3c:	fec42703          	lw	a4,-20(s0)
    2c40:	fa840793          	addi	a5,s0,-88
    2c44:	070e                	slli	a4,a4,0x3
    2c46:	97ba                	add	a5,a5,a4
    2c48:	639c                	ld	a5,0(a5)
    2c4a:	fcf43c23          	sd	a5,-40(s0)
    fd = open(fname, 0);
    2c4e:	4581                	li	a1,0
    2c50:	fd843503          	ld	a0,-40(s0)
    2c54:	00005097          	auipc	ra,0x5
    2c58:	eb8080e7          	jalr	-328(ra) # 7b0c <open>
    2c5c:	87aa                	mv	a5,a0
    2c5e:	fcf42a23          	sw	a5,-44(s0)
    total = 0;
    2c62:	fe042223          	sw	zero,-28(s0)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    2c66:	a89d                	j	2cdc <fourfiles+0x262>
      for(j = 0; j < n; j++){
    2c68:	fe042423          	sw	zero,-24(s0)
    2c6c:	a0b9                	j	2cba <fourfiles+0x240>
        if(buf[j] != '0'+i){
    2c6e:	00009717          	auipc	a4,0x9
    2c72:	80270713          	addi	a4,a4,-2046 # b470 <buf>
    2c76:	fe842783          	lw	a5,-24(s0)
    2c7a:	97ba                	add	a5,a5,a4
    2c7c:	0007c783          	lbu	a5,0(a5)
    2c80:	0007871b          	sext.w	a4,a5
    2c84:	fec42783          	lw	a5,-20(s0)
    2c88:	0307879b          	addiw	a5,a5,48
    2c8c:	2781                	sext.w	a5,a5
    2c8e:	02f70163          	beq	a4,a5,2cb0 <fourfiles+0x236>
          printf("wrong char\n", s);
    2c92:	f9843583          	ld	a1,-104(s0)
    2c96:	00006517          	auipc	a0,0x6
    2c9a:	1ba50513          	addi	a0,a0,442 # 8e50 <malloc+0xc64>
    2c9e:	00005097          	auipc	ra,0x5
    2ca2:	35a080e7          	jalr	858(ra) # 7ff8 <printf>
          exit(1);
    2ca6:	4505                	li	a0,1
    2ca8:	00005097          	auipc	ra,0x5
    2cac:	e24080e7          	jalr	-476(ra) # 7acc <exit>
      for(j = 0; j < n; j++){
    2cb0:	fe842783          	lw	a5,-24(s0)
    2cb4:	2785                	addiw	a5,a5,1
    2cb6:	fef42423          	sw	a5,-24(s0)
    2cba:	fe842783          	lw	a5,-24(s0)
    2cbe:	873e                	mv	a4,a5
    2cc0:	fd042783          	lw	a5,-48(s0)
    2cc4:	2701                	sext.w	a4,a4
    2cc6:	2781                	sext.w	a5,a5
    2cc8:	faf743e3          	blt	a4,a5,2c6e <fourfiles+0x1f4>
        }
      }
      total += n;
    2ccc:	fe442783          	lw	a5,-28(s0)
    2cd0:	873e                	mv	a4,a5
    2cd2:	fd042783          	lw	a5,-48(s0)
    2cd6:	9fb9                	addw	a5,a5,a4
    2cd8:	fef42223          	sw	a5,-28(s0)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    2cdc:	fd442783          	lw	a5,-44(s0)
    2ce0:	660d                	lui	a2,0x3
    2ce2:	00008597          	auipc	a1,0x8
    2ce6:	78e58593          	addi	a1,a1,1934 # b470 <buf>
    2cea:	853e                	mv	a0,a5
    2cec:	00005097          	auipc	ra,0x5
    2cf0:	df8080e7          	jalr	-520(ra) # 7ae4 <read>
    2cf4:	87aa                	mv	a5,a0
    2cf6:	fcf42823          	sw	a5,-48(s0)
    2cfa:	fd042783          	lw	a5,-48(s0)
    2cfe:	2781                	sext.w	a5,a5
    2d00:	f6f044e3          	bgtz	a5,2c68 <fourfiles+0x1ee>
    }
    close(fd);
    2d04:	fd442783          	lw	a5,-44(s0)
    2d08:	853e                	mv	a0,a5
    2d0a:	00005097          	auipc	ra,0x5
    2d0e:	dea080e7          	jalr	-534(ra) # 7af4 <close>
    if(total != N*SZ){
    2d12:	fe442783          	lw	a5,-28(s0)
    2d16:	0007871b          	sext.w	a4,a5
    2d1a:	6785                	lui	a5,0x1
    2d1c:	77078793          	addi	a5,a5,1904 # 1770 <writebig+0x12c>
    2d20:	02f70263          	beq	a4,a5,2d44 <fourfiles+0x2ca>
      printf("wrong length %d\n", total);
    2d24:	fe442783          	lw	a5,-28(s0)
    2d28:	85be                	mv	a1,a5
    2d2a:	00006517          	auipc	a0,0x6
    2d2e:	13650513          	addi	a0,a0,310 # 8e60 <malloc+0xc74>
    2d32:	00005097          	auipc	ra,0x5
    2d36:	2c6080e7          	jalr	710(ra) # 7ff8 <printf>
      exit(1);
    2d3a:	4505                	li	a0,1
    2d3c:	00005097          	auipc	ra,0x5
    2d40:	d90080e7          	jalr	-624(ra) # 7acc <exit>
    }
    unlink(fname);
    2d44:	fd843503          	ld	a0,-40(s0)
    2d48:	00005097          	auipc	ra,0x5
    2d4c:	dd4080e7          	jalr	-556(ra) # 7b1c <unlink>
  for(i = 0; i < NCHILD; i++){
    2d50:	fec42783          	lw	a5,-20(s0)
    2d54:	2785                	addiw	a5,a5,1
    2d56:	fef42623          	sw	a5,-20(s0)
    2d5a:	fec42783          	lw	a5,-20(s0)
    2d5e:	0007871b          	sext.w	a4,a5
    2d62:	478d                	li	a5,3
    2d64:	ece7dce3          	bge	a5,a4,2c3c <fourfiles+0x1c2>
  }
}
    2d68:	0001                	nop
    2d6a:	0001                	nop
    2d6c:	70a6                	ld	ra,104(sp)
    2d6e:	7406                	ld	s0,96(sp)
    2d70:	6165                	addi	sp,sp,112
    2d72:	8082                	ret

0000000000002d74 <createdelete>:

// four processes create and delete different files in same directory
void
createdelete(char *s)
{
    2d74:	711d                	addi	sp,sp,-96
    2d76:	ec86                	sd	ra,88(sp)
    2d78:	e8a2                	sd	s0,80(sp)
    2d7a:	1080                	addi	s0,sp,96
    2d7c:	faa43423          	sd	a0,-88(s0)
  enum { N = 20, NCHILD=4 };
  int pid, i, fd, pi;
  char name[32];

  for(pi = 0; pi < NCHILD; pi++){
    2d80:	fe042423          	sw	zero,-24(s0)
    2d84:	aa91                	j	2ed8 <createdelete+0x164>
    pid = fork();
    2d86:	00005097          	auipc	ra,0x5
    2d8a:	d3e080e7          	jalr	-706(ra) # 7ac4 <fork>
    2d8e:	87aa                	mv	a5,a0
    2d90:	fef42023          	sw	a5,-32(s0)
    if(pid < 0){
    2d94:	fe042783          	lw	a5,-32(s0)
    2d98:	2781                	sext.w	a5,a5
    2d9a:	0207d163          	bgez	a5,2dbc <createdelete+0x48>
      printf("fork failed\n", s);
    2d9e:	fa843583          	ld	a1,-88(s0)
    2da2:	00005517          	auipc	a0,0x5
    2da6:	79e50513          	addi	a0,a0,1950 # 8540 <malloc+0x354>
    2daa:	00005097          	auipc	ra,0x5
    2dae:	24e080e7          	jalr	590(ra) # 7ff8 <printf>
      exit(1);
    2db2:	4505                	li	a0,1
    2db4:	00005097          	auipc	ra,0x5
    2db8:	d18080e7          	jalr	-744(ra) # 7acc <exit>
    }

    if(pid == 0){
    2dbc:	fe042783          	lw	a5,-32(s0)
    2dc0:	2781                	sext.w	a5,a5
    2dc2:	10079663          	bnez	a5,2ece <createdelete+0x15a>
      name[0] = 'p' + pi;
    2dc6:	fe842783          	lw	a5,-24(s0)
    2dca:	0ff7f793          	zext.b	a5,a5
    2dce:	0707879b          	addiw	a5,a5,112
    2dd2:	0ff7f793          	zext.b	a5,a5
    2dd6:	fcf40023          	sb	a5,-64(s0)
      name[2] = '\0';
    2dda:	fc040123          	sb	zero,-62(s0)
      for(i = 0; i < N; i++){
    2dde:	fe042623          	sw	zero,-20(s0)
    2de2:	a8d1                	j	2eb6 <createdelete+0x142>
        name[1] = '0' + i;
    2de4:	fec42783          	lw	a5,-20(s0)
    2de8:	0ff7f793          	zext.b	a5,a5
    2dec:	0307879b          	addiw	a5,a5,48
    2df0:	0ff7f793          	zext.b	a5,a5
    2df4:	fcf400a3          	sb	a5,-63(s0)
        fd = open(name, O_CREATE | O_RDWR);
    2df8:	fc040793          	addi	a5,s0,-64
    2dfc:	20200593          	li	a1,514
    2e00:	853e                	mv	a0,a5
    2e02:	00005097          	auipc	ra,0x5
    2e06:	d0a080e7          	jalr	-758(ra) # 7b0c <open>
    2e0a:	87aa                	mv	a5,a0
    2e0c:	fef42223          	sw	a5,-28(s0)
        if(fd < 0){
    2e10:	fe442783          	lw	a5,-28(s0)
    2e14:	2781                	sext.w	a5,a5
    2e16:	0207d163          	bgez	a5,2e38 <createdelete+0xc4>
          printf("%s: create failed\n", s);
    2e1a:	fa843583          	ld	a1,-88(s0)
    2e1e:	00006517          	auipc	a0,0x6
    2e22:	d7a50513          	addi	a0,a0,-646 # 8b98 <malloc+0x9ac>
    2e26:	00005097          	auipc	ra,0x5
    2e2a:	1d2080e7          	jalr	466(ra) # 7ff8 <printf>
          exit(1);
    2e2e:	4505                	li	a0,1
    2e30:	00005097          	auipc	ra,0x5
    2e34:	c9c080e7          	jalr	-868(ra) # 7acc <exit>
        }
        close(fd);
    2e38:	fe442783          	lw	a5,-28(s0)
    2e3c:	853e                	mv	a0,a5
    2e3e:	00005097          	auipc	ra,0x5
    2e42:	cb6080e7          	jalr	-842(ra) # 7af4 <close>
        if(i > 0 && (i % 2 ) == 0){
    2e46:	fec42783          	lw	a5,-20(s0)
    2e4a:	2781                	sext.w	a5,a5
    2e4c:	06f05063          	blez	a5,2eac <createdelete+0x138>
    2e50:	fec42783          	lw	a5,-20(s0)
    2e54:	8b85                	andi	a5,a5,1
    2e56:	2781                	sext.w	a5,a5
    2e58:	ebb1                	bnez	a5,2eac <createdelete+0x138>
          name[1] = '0' + (i / 2);
    2e5a:	fec42783          	lw	a5,-20(s0)
    2e5e:	01f7d71b          	srliw	a4,a5,0x1f
    2e62:	9fb9                	addw	a5,a5,a4
    2e64:	4017d79b          	sraiw	a5,a5,0x1
    2e68:	2781                	sext.w	a5,a5
    2e6a:	0ff7f793          	zext.b	a5,a5
    2e6e:	0307879b          	addiw	a5,a5,48
    2e72:	0ff7f793          	zext.b	a5,a5
    2e76:	fcf400a3          	sb	a5,-63(s0)
          if(unlink(name) < 0){
    2e7a:	fc040793          	addi	a5,s0,-64
    2e7e:	853e                	mv	a0,a5
    2e80:	00005097          	auipc	ra,0x5
    2e84:	c9c080e7          	jalr	-868(ra) # 7b1c <unlink>
    2e88:	87aa                	mv	a5,a0
    2e8a:	0207d163          	bgez	a5,2eac <createdelete+0x138>
            printf("%s: unlink failed\n", s);
    2e8e:	fa843583          	ld	a1,-88(s0)
    2e92:	00006517          	auipc	a0,0x6
    2e96:	a5650513          	addi	a0,a0,-1450 # 88e8 <malloc+0x6fc>
    2e9a:	00005097          	auipc	ra,0x5
    2e9e:	15e080e7          	jalr	350(ra) # 7ff8 <printf>
            exit(1);
    2ea2:	4505                	li	a0,1
    2ea4:	00005097          	auipc	ra,0x5
    2ea8:	c28080e7          	jalr	-984(ra) # 7acc <exit>
      for(i = 0; i < N; i++){
    2eac:	fec42783          	lw	a5,-20(s0)
    2eb0:	2785                	addiw	a5,a5,1
    2eb2:	fef42623          	sw	a5,-20(s0)
    2eb6:	fec42783          	lw	a5,-20(s0)
    2eba:	0007871b          	sext.w	a4,a5
    2ebe:	47cd                	li	a5,19
    2ec0:	f2e7d2e3          	bge	a5,a4,2de4 <createdelete+0x70>
          }
        }
      }
      exit(0);
    2ec4:	4501                	li	a0,0
    2ec6:	00005097          	auipc	ra,0x5
    2eca:	c06080e7          	jalr	-1018(ra) # 7acc <exit>
  for(pi = 0; pi < NCHILD; pi++){
    2ece:	fe842783          	lw	a5,-24(s0)
    2ed2:	2785                	addiw	a5,a5,1
    2ed4:	fef42423          	sw	a5,-24(s0)
    2ed8:	fe842783          	lw	a5,-24(s0)
    2edc:	0007871b          	sext.w	a4,a5
    2ee0:	478d                	li	a5,3
    2ee2:	eae7d2e3          	bge	a5,a4,2d86 <createdelete+0x12>
    }
  }

  int xstatus;
  for(pi = 0; pi < NCHILD; pi++){
    2ee6:	fe042423          	sw	zero,-24(s0)
    2eea:	a02d                	j	2f14 <createdelete+0x1a0>
    wait(&xstatus);
    2eec:	fbc40793          	addi	a5,s0,-68
    2ef0:	853e                	mv	a0,a5
    2ef2:	00005097          	auipc	ra,0x5
    2ef6:	be2080e7          	jalr	-1054(ra) # 7ad4 <wait>
    if(xstatus != 0)
    2efa:	fbc42783          	lw	a5,-68(s0)
    2efe:	c791                	beqz	a5,2f0a <createdelete+0x196>
      exit(1);
    2f00:	4505                	li	a0,1
    2f02:	00005097          	auipc	ra,0x5
    2f06:	bca080e7          	jalr	-1078(ra) # 7acc <exit>
  for(pi = 0; pi < NCHILD; pi++){
    2f0a:	fe842783          	lw	a5,-24(s0)
    2f0e:	2785                	addiw	a5,a5,1
    2f10:	fef42423          	sw	a5,-24(s0)
    2f14:	fe842783          	lw	a5,-24(s0)
    2f18:	0007871b          	sext.w	a4,a5
    2f1c:	478d                	li	a5,3
    2f1e:	fce7d7e3          	bge	a5,a4,2eec <createdelete+0x178>
  }

  name[0] = name[1] = name[2] = 0;
    2f22:	fc040123          	sb	zero,-62(s0)
    2f26:	fc244783          	lbu	a5,-62(s0)
    2f2a:	fcf400a3          	sb	a5,-63(s0)
    2f2e:	fc144783          	lbu	a5,-63(s0)
    2f32:	fcf40023          	sb	a5,-64(s0)
  for(i = 0; i < N; i++){
    2f36:	fe042623          	sw	zero,-20(s0)
    2f3a:	a229                	j	3044 <createdelete+0x2d0>
    for(pi = 0; pi < NCHILD; pi++){
    2f3c:	fe042423          	sw	zero,-24(s0)
    2f40:	a0f5                	j	302c <createdelete+0x2b8>
      name[0] = 'p' + pi;
    2f42:	fe842783          	lw	a5,-24(s0)
    2f46:	0ff7f793          	zext.b	a5,a5
    2f4a:	0707879b          	addiw	a5,a5,112
    2f4e:	0ff7f793          	zext.b	a5,a5
    2f52:	fcf40023          	sb	a5,-64(s0)
      name[1] = '0' + i;
    2f56:	fec42783          	lw	a5,-20(s0)
    2f5a:	0ff7f793          	zext.b	a5,a5
    2f5e:	0307879b          	addiw	a5,a5,48
    2f62:	0ff7f793          	zext.b	a5,a5
    2f66:	fcf400a3          	sb	a5,-63(s0)
      fd = open(name, 0);
    2f6a:	fc040793          	addi	a5,s0,-64
    2f6e:	4581                	li	a1,0
    2f70:	853e                	mv	a0,a5
    2f72:	00005097          	auipc	ra,0x5
    2f76:	b9a080e7          	jalr	-1126(ra) # 7b0c <open>
    2f7a:	87aa                	mv	a5,a0
    2f7c:	fef42223          	sw	a5,-28(s0)
      if((i == 0 || i >= N/2) && fd < 0){
    2f80:	fec42783          	lw	a5,-20(s0)
    2f84:	2781                	sext.w	a5,a5
    2f86:	cb81                	beqz	a5,2f96 <createdelete+0x222>
    2f88:	fec42783          	lw	a5,-20(s0)
    2f8c:	0007871b          	sext.w	a4,a5
    2f90:	47a5                	li	a5,9
    2f92:	02e7d963          	bge	a5,a4,2fc4 <createdelete+0x250>
    2f96:	fe442783          	lw	a5,-28(s0)
    2f9a:	2781                	sext.w	a5,a5
    2f9c:	0207d463          	bgez	a5,2fc4 <createdelete+0x250>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    2fa0:	fc040793          	addi	a5,s0,-64
    2fa4:	863e                	mv	a2,a5
    2fa6:	fa843583          	ld	a1,-88(s0)
    2faa:	00006517          	auipc	a0,0x6
    2fae:	f0e50513          	addi	a0,a0,-242 # 8eb8 <malloc+0xccc>
    2fb2:	00005097          	auipc	ra,0x5
    2fb6:	046080e7          	jalr	70(ra) # 7ff8 <printf>
        exit(1);
    2fba:	4505                	li	a0,1
    2fbc:	00005097          	auipc	ra,0x5
    2fc0:	b10080e7          	jalr	-1264(ra) # 7acc <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    2fc4:	fec42783          	lw	a5,-20(s0)
    2fc8:	2781                	sext.w	a5,a5
    2fca:	04f05063          	blez	a5,300a <createdelete+0x296>
    2fce:	fec42783          	lw	a5,-20(s0)
    2fd2:	0007871b          	sext.w	a4,a5
    2fd6:	47a5                	li	a5,9
    2fd8:	02e7c963          	blt	a5,a4,300a <createdelete+0x296>
    2fdc:	fe442783          	lw	a5,-28(s0)
    2fe0:	2781                	sext.w	a5,a5
    2fe2:	0207c463          	bltz	a5,300a <createdelete+0x296>
        printf("%s: oops createdelete %s did exist\n", s, name);
    2fe6:	fc040793          	addi	a5,s0,-64
    2fea:	863e                	mv	a2,a5
    2fec:	fa843583          	ld	a1,-88(s0)
    2ff0:	00006517          	auipc	a0,0x6
    2ff4:	ef050513          	addi	a0,a0,-272 # 8ee0 <malloc+0xcf4>
    2ff8:	00005097          	auipc	ra,0x5
    2ffc:	000080e7          	jalr	ra # 7ff8 <printf>
        exit(1);
    3000:	4505                	li	a0,1
    3002:	00005097          	auipc	ra,0x5
    3006:	aca080e7          	jalr	-1334(ra) # 7acc <exit>
      }
      if(fd >= 0)
    300a:	fe442783          	lw	a5,-28(s0)
    300e:	2781                	sext.w	a5,a5
    3010:	0007c963          	bltz	a5,3022 <createdelete+0x2ae>
        close(fd);
    3014:	fe442783          	lw	a5,-28(s0)
    3018:	853e                	mv	a0,a5
    301a:	00005097          	auipc	ra,0x5
    301e:	ada080e7          	jalr	-1318(ra) # 7af4 <close>
    for(pi = 0; pi < NCHILD; pi++){
    3022:	fe842783          	lw	a5,-24(s0)
    3026:	2785                	addiw	a5,a5,1
    3028:	fef42423          	sw	a5,-24(s0)
    302c:	fe842783          	lw	a5,-24(s0)
    3030:	0007871b          	sext.w	a4,a5
    3034:	478d                	li	a5,3
    3036:	f0e7d6e3          	bge	a5,a4,2f42 <createdelete+0x1ce>
  for(i = 0; i < N; i++){
    303a:	fec42783          	lw	a5,-20(s0)
    303e:	2785                	addiw	a5,a5,1
    3040:	fef42623          	sw	a5,-20(s0)
    3044:	fec42783          	lw	a5,-20(s0)
    3048:	0007871b          	sext.w	a4,a5
    304c:	47cd                	li	a5,19
    304e:	eee7d7e3          	bge	a5,a4,2f3c <createdelete+0x1c8>
    }
  }

  for(i = 0; i < N; i++){
    3052:	fe042623          	sw	zero,-20(s0)
    3056:	a085                	j	30b6 <createdelete+0x342>
    for(pi = 0; pi < NCHILD; pi++){
    3058:	fe042423          	sw	zero,-24(s0)
    305c:	a089                	j	309e <createdelete+0x32a>
      name[0] = 'p' + i;
    305e:	fec42783          	lw	a5,-20(s0)
    3062:	0ff7f793          	zext.b	a5,a5
    3066:	0707879b          	addiw	a5,a5,112
    306a:	0ff7f793          	zext.b	a5,a5
    306e:	fcf40023          	sb	a5,-64(s0)
      name[1] = '0' + i;
    3072:	fec42783          	lw	a5,-20(s0)
    3076:	0ff7f793          	zext.b	a5,a5
    307a:	0307879b          	addiw	a5,a5,48
    307e:	0ff7f793          	zext.b	a5,a5
    3082:	fcf400a3          	sb	a5,-63(s0)
      unlink(name);
    3086:	fc040793          	addi	a5,s0,-64
    308a:	853e                	mv	a0,a5
    308c:	00005097          	auipc	ra,0x5
    3090:	a90080e7          	jalr	-1392(ra) # 7b1c <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    3094:	fe842783          	lw	a5,-24(s0)
    3098:	2785                	addiw	a5,a5,1
    309a:	fef42423          	sw	a5,-24(s0)
    309e:	fe842783          	lw	a5,-24(s0)
    30a2:	0007871b          	sext.w	a4,a5
    30a6:	478d                	li	a5,3
    30a8:	fae7dbe3          	bge	a5,a4,305e <createdelete+0x2ea>
  for(i = 0; i < N; i++){
    30ac:	fec42783          	lw	a5,-20(s0)
    30b0:	2785                	addiw	a5,a5,1
    30b2:	fef42623          	sw	a5,-20(s0)
    30b6:	fec42783          	lw	a5,-20(s0)
    30ba:	0007871b          	sext.w	a4,a5
    30be:	47cd                	li	a5,19
    30c0:	f8e7dce3          	bge	a5,a4,3058 <createdelete+0x2e4>
    }
  }
}
    30c4:	0001                	nop
    30c6:	0001                	nop
    30c8:	60e6                	ld	ra,88(sp)
    30ca:	6446                	ld	s0,80(sp)
    30cc:	6125                	addi	sp,sp,96
    30ce:	8082                	ret

00000000000030d0 <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(char *s)
{
    30d0:	7179                	addi	sp,sp,-48
    30d2:	f406                	sd	ra,40(sp)
    30d4:	f022                	sd	s0,32(sp)
    30d6:	1800                	addi	s0,sp,48
    30d8:	fca43c23          	sd	a0,-40(s0)
  enum { SZ = 5 };
  int fd, fd1;

  fd = open("unlinkread", O_CREATE | O_RDWR);
    30dc:	20200593          	li	a1,514
    30e0:	00006517          	auipc	a0,0x6
    30e4:	e2850513          	addi	a0,a0,-472 # 8f08 <malloc+0xd1c>
    30e8:	00005097          	auipc	ra,0x5
    30ec:	a24080e7          	jalr	-1500(ra) # 7b0c <open>
    30f0:	87aa                	mv	a5,a0
    30f2:	fef42623          	sw	a5,-20(s0)
  if(fd < 0){
    30f6:	fec42783          	lw	a5,-20(s0)
    30fa:	2781                	sext.w	a5,a5
    30fc:	0207d163          	bgez	a5,311e <unlinkread+0x4e>
    printf("%s: create unlinkread failed\n", s);
    3100:	fd843583          	ld	a1,-40(s0)
    3104:	00006517          	auipc	a0,0x6
    3108:	e1450513          	addi	a0,a0,-492 # 8f18 <malloc+0xd2c>
    310c:	00005097          	auipc	ra,0x5
    3110:	eec080e7          	jalr	-276(ra) # 7ff8 <printf>
    exit(1);
    3114:	4505                	li	a0,1
    3116:	00005097          	auipc	ra,0x5
    311a:	9b6080e7          	jalr	-1610(ra) # 7acc <exit>
  }
  write(fd, "hello", SZ);
    311e:	fec42783          	lw	a5,-20(s0)
    3122:	4615                	li	a2,5
    3124:	00006597          	auipc	a1,0x6
    3128:	e1458593          	addi	a1,a1,-492 # 8f38 <malloc+0xd4c>
    312c:	853e                	mv	a0,a5
    312e:	00005097          	auipc	ra,0x5
    3132:	9be080e7          	jalr	-1602(ra) # 7aec <write>
  close(fd);
    3136:	fec42783          	lw	a5,-20(s0)
    313a:	853e                	mv	a0,a5
    313c:	00005097          	auipc	ra,0x5
    3140:	9b8080e7          	jalr	-1608(ra) # 7af4 <close>

  fd = open("unlinkread", O_RDWR);
    3144:	4589                	li	a1,2
    3146:	00006517          	auipc	a0,0x6
    314a:	dc250513          	addi	a0,a0,-574 # 8f08 <malloc+0xd1c>
    314e:	00005097          	auipc	ra,0x5
    3152:	9be080e7          	jalr	-1602(ra) # 7b0c <open>
    3156:	87aa                	mv	a5,a0
    3158:	fef42623          	sw	a5,-20(s0)
  if(fd < 0){
    315c:	fec42783          	lw	a5,-20(s0)
    3160:	2781                	sext.w	a5,a5
    3162:	0207d163          	bgez	a5,3184 <unlinkread+0xb4>
    printf("%s: open unlinkread failed\n", s);
    3166:	fd843583          	ld	a1,-40(s0)
    316a:	00006517          	auipc	a0,0x6
    316e:	dd650513          	addi	a0,a0,-554 # 8f40 <malloc+0xd54>
    3172:	00005097          	auipc	ra,0x5
    3176:	e86080e7          	jalr	-378(ra) # 7ff8 <printf>
    exit(1);
    317a:	4505                	li	a0,1
    317c:	00005097          	auipc	ra,0x5
    3180:	950080e7          	jalr	-1712(ra) # 7acc <exit>
  }
  if(unlink("unlinkread") != 0){
    3184:	00006517          	auipc	a0,0x6
    3188:	d8450513          	addi	a0,a0,-636 # 8f08 <malloc+0xd1c>
    318c:	00005097          	auipc	ra,0x5
    3190:	990080e7          	jalr	-1648(ra) # 7b1c <unlink>
    3194:	87aa                	mv	a5,a0
    3196:	c385                	beqz	a5,31b6 <unlinkread+0xe6>
    printf("%s: unlink unlinkread failed\n", s);
    3198:	fd843583          	ld	a1,-40(s0)
    319c:	00006517          	auipc	a0,0x6
    31a0:	dc450513          	addi	a0,a0,-572 # 8f60 <malloc+0xd74>
    31a4:	00005097          	auipc	ra,0x5
    31a8:	e54080e7          	jalr	-428(ra) # 7ff8 <printf>
    exit(1);
    31ac:	4505                	li	a0,1
    31ae:	00005097          	auipc	ra,0x5
    31b2:	91e080e7          	jalr	-1762(ra) # 7acc <exit>
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    31b6:	20200593          	li	a1,514
    31ba:	00006517          	auipc	a0,0x6
    31be:	d4e50513          	addi	a0,a0,-690 # 8f08 <malloc+0xd1c>
    31c2:	00005097          	auipc	ra,0x5
    31c6:	94a080e7          	jalr	-1718(ra) # 7b0c <open>
    31ca:	87aa                	mv	a5,a0
    31cc:	fef42423          	sw	a5,-24(s0)
  write(fd1, "yyy", 3);
    31d0:	fe842783          	lw	a5,-24(s0)
    31d4:	460d                	li	a2,3
    31d6:	00006597          	auipc	a1,0x6
    31da:	daa58593          	addi	a1,a1,-598 # 8f80 <malloc+0xd94>
    31de:	853e                	mv	a0,a5
    31e0:	00005097          	auipc	ra,0x5
    31e4:	90c080e7          	jalr	-1780(ra) # 7aec <write>
  close(fd1);
    31e8:	fe842783          	lw	a5,-24(s0)
    31ec:	853e                	mv	a0,a5
    31ee:	00005097          	auipc	ra,0x5
    31f2:	906080e7          	jalr	-1786(ra) # 7af4 <close>

  if(read(fd, buf, sizeof(buf)) != SZ){
    31f6:	fec42783          	lw	a5,-20(s0)
    31fa:	660d                	lui	a2,0x3
    31fc:	00008597          	auipc	a1,0x8
    3200:	27458593          	addi	a1,a1,628 # b470 <buf>
    3204:	853e                	mv	a0,a5
    3206:	00005097          	auipc	ra,0x5
    320a:	8de080e7          	jalr	-1826(ra) # 7ae4 <read>
    320e:	87aa                	mv	a5,a0
    3210:	873e                	mv	a4,a5
    3212:	4795                	li	a5,5
    3214:	02f70163          	beq	a4,a5,3236 <unlinkread+0x166>
    printf("%s: unlinkread read failed", s);
    3218:	fd843583          	ld	a1,-40(s0)
    321c:	00006517          	auipc	a0,0x6
    3220:	d6c50513          	addi	a0,a0,-660 # 8f88 <malloc+0xd9c>
    3224:	00005097          	auipc	ra,0x5
    3228:	dd4080e7          	jalr	-556(ra) # 7ff8 <printf>
    exit(1);
    322c:	4505                	li	a0,1
    322e:	00005097          	auipc	ra,0x5
    3232:	89e080e7          	jalr	-1890(ra) # 7acc <exit>
  }
  if(buf[0] != 'h'){
    3236:	00008797          	auipc	a5,0x8
    323a:	23a78793          	addi	a5,a5,570 # b470 <buf>
    323e:	0007c783          	lbu	a5,0(a5)
    3242:	873e                	mv	a4,a5
    3244:	06800793          	li	a5,104
    3248:	02f70163          	beq	a4,a5,326a <unlinkread+0x19a>
    printf("%s: unlinkread wrong data\n", s);
    324c:	fd843583          	ld	a1,-40(s0)
    3250:	00006517          	auipc	a0,0x6
    3254:	d5850513          	addi	a0,a0,-680 # 8fa8 <malloc+0xdbc>
    3258:	00005097          	auipc	ra,0x5
    325c:	da0080e7          	jalr	-608(ra) # 7ff8 <printf>
    exit(1);
    3260:	4505                	li	a0,1
    3262:	00005097          	auipc	ra,0x5
    3266:	86a080e7          	jalr	-1942(ra) # 7acc <exit>
  }
  if(write(fd, buf, 10) != 10){
    326a:	fec42783          	lw	a5,-20(s0)
    326e:	4629                	li	a2,10
    3270:	00008597          	auipc	a1,0x8
    3274:	20058593          	addi	a1,a1,512 # b470 <buf>
    3278:	853e                	mv	a0,a5
    327a:	00005097          	auipc	ra,0x5
    327e:	872080e7          	jalr	-1934(ra) # 7aec <write>
    3282:	87aa                	mv	a5,a0
    3284:	873e                	mv	a4,a5
    3286:	47a9                	li	a5,10
    3288:	02f70163          	beq	a4,a5,32aa <unlinkread+0x1da>
    printf("%s: unlinkread write failed\n", s);
    328c:	fd843583          	ld	a1,-40(s0)
    3290:	00006517          	auipc	a0,0x6
    3294:	d3850513          	addi	a0,a0,-712 # 8fc8 <malloc+0xddc>
    3298:	00005097          	auipc	ra,0x5
    329c:	d60080e7          	jalr	-672(ra) # 7ff8 <printf>
    exit(1);
    32a0:	4505                	li	a0,1
    32a2:	00005097          	auipc	ra,0x5
    32a6:	82a080e7          	jalr	-2006(ra) # 7acc <exit>
  }
  close(fd);
    32aa:	fec42783          	lw	a5,-20(s0)
    32ae:	853e                	mv	a0,a5
    32b0:	00005097          	auipc	ra,0x5
    32b4:	844080e7          	jalr	-1980(ra) # 7af4 <close>
  unlink("unlinkread");
    32b8:	00006517          	auipc	a0,0x6
    32bc:	c5050513          	addi	a0,a0,-944 # 8f08 <malloc+0xd1c>
    32c0:	00005097          	auipc	ra,0x5
    32c4:	85c080e7          	jalr	-1956(ra) # 7b1c <unlink>
}
    32c8:	0001                	nop
    32ca:	70a2                	ld	ra,40(sp)
    32cc:	7402                	ld	s0,32(sp)
    32ce:	6145                	addi	sp,sp,48
    32d0:	8082                	ret

00000000000032d2 <linktest>:

void
linktest(char *s)
{
    32d2:	7179                	addi	sp,sp,-48
    32d4:	f406                	sd	ra,40(sp)
    32d6:	f022                	sd	s0,32(sp)
    32d8:	1800                	addi	s0,sp,48
    32da:	fca43c23          	sd	a0,-40(s0)
  enum { SZ = 5 };
  int fd;

  unlink("lf1");
    32de:	00006517          	auipc	a0,0x6
    32e2:	d0a50513          	addi	a0,a0,-758 # 8fe8 <malloc+0xdfc>
    32e6:	00005097          	auipc	ra,0x5
    32ea:	836080e7          	jalr	-1994(ra) # 7b1c <unlink>
  unlink("lf2");
    32ee:	00006517          	auipc	a0,0x6
    32f2:	d0250513          	addi	a0,a0,-766 # 8ff0 <malloc+0xe04>
    32f6:	00005097          	auipc	ra,0x5
    32fa:	826080e7          	jalr	-2010(ra) # 7b1c <unlink>

  fd = open("lf1", O_CREATE|O_RDWR);
    32fe:	20200593          	li	a1,514
    3302:	00006517          	auipc	a0,0x6
    3306:	ce650513          	addi	a0,a0,-794 # 8fe8 <malloc+0xdfc>
    330a:	00005097          	auipc	ra,0x5
    330e:	802080e7          	jalr	-2046(ra) # 7b0c <open>
    3312:	87aa                	mv	a5,a0
    3314:	fef42623          	sw	a5,-20(s0)
  if(fd < 0){
    3318:	fec42783          	lw	a5,-20(s0)
    331c:	2781                	sext.w	a5,a5
    331e:	0207d163          	bgez	a5,3340 <linktest+0x6e>
    printf("%s: create lf1 failed\n", s);
    3322:	fd843583          	ld	a1,-40(s0)
    3326:	00006517          	auipc	a0,0x6
    332a:	cd250513          	addi	a0,a0,-814 # 8ff8 <malloc+0xe0c>
    332e:	00005097          	auipc	ra,0x5
    3332:	cca080e7          	jalr	-822(ra) # 7ff8 <printf>
    exit(1);
    3336:	4505                	li	a0,1
    3338:	00004097          	auipc	ra,0x4
    333c:	794080e7          	jalr	1940(ra) # 7acc <exit>
  }
  if(write(fd, "hello", SZ) != SZ){
    3340:	fec42783          	lw	a5,-20(s0)
    3344:	4615                	li	a2,5
    3346:	00006597          	auipc	a1,0x6
    334a:	bf258593          	addi	a1,a1,-1038 # 8f38 <malloc+0xd4c>
    334e:	853e                	mv	a0,a5
    3350:	00004097          	auipc	ra,0x4
    3354:	79c080e7          	jalr	1948(ra) # 7aec <write>
    3358:	87aa                	mv	a5,a0
    335a:	873e                	mv	a4,a5
    335c:	4795                	li	a5,5
    335e:	02f70163          	beq	a4,a5,3380 <linktest+0xae>
    printf("%s: write lf1 failed\n", s);
    3362:	fd843583          	ld	a1,-40(s0)
    3366:	00006517          	auipc	a0,0x6
    336a:	caa50513          	addi	a0,a0,-854 # 9010 <malloc+0xe24>
    336e:	00005097          	auipc	ra,0x5
    3372:	c8a080e7          	jalr	-886(ra) # 7ff8 <printf>
    exit(1);
    3376:	4505                	li	a0,1
    3378:	00004097          	auipc	ra,0x4
    337c:	754080e7          	jalr	1876(ra) # 7acc <exit>
  }
  close(fd);
    3380:	fec42783          	lw	a5,-20(s0)
    3384:	853e                	mv	a0,a5
    3386:	00004097          	auipc	ra,0x4
    338a:	76e080e7          	jalr	1902(ra) # 7af4 <close>

  if(link("lf1", "lf2") < 0){
    338e:	00006597          	auipc	a1,0x6
    3392:	c6258593          	addi	a1,a1,-926 # 8ff0 <malloc+0xe04>
    3396:	00006517          	auipc	a0,0x6
    339a:	c5250513          	addi	a0,a0,-942 # 8fe8 <malloc+0xdfc>
    339e:	00004097          	auipc	ra,0x4
    33a2:	78e080e7          	jalr	1934(ra) # 7b2c <link>
    33a6:	87aa                	mv	a5,a0
    33a8:	0207d163          	bgez	a5,33ca <linktest+0xf8>
    printf("%s: link lf1 lf2 failed\n", s);
    33ac:	fd843583          	ld	a1,-40(s0)
    33b0:	00006517          	auipc	a0,0x6
    33b4:	c7850513          	addi	a0,a0,-904 # 9028 <malloc+0xe3c>
    33b8:	00005097          	auipc	ra,0x5
    33bc:	c40080e7          	jalr	-960(ra) # 7ff8 <printf>
    exit(1);
    33c0:	4505                	li	a0,1
    33c2:	00004097          	auipc	ra,0x4
    33c6:	70a080e7          	jalr	1802(ra) # 7acc <exit>
  }
  unlink("lf1");
    33ca:	00006517          	auipc	a0,0x6
    33ce:	c1e50513          	addi	a0,a0,-994 # 8fe8 <malloc+0xdfc>
    33d2:	00004097          	auipc	ra,0x4
    33d6:	74a080e7          	jalr	1866(ra) # 7b1c <unlink>

  if(open("lf1", 0) >= 0){
    33da:	4581                	li	a1,0
    33dc:	00006517          	auipc	a0,0x6
    33e0:	c0c50513          	addi	a0,a0,-1012 # 8fe8 <malloc+0xdfc>
    33e4:	00004097          	auipc	ra,0x4
    33e8:	728080e7          	jalr	1832(ra) # 7b0c <open>
    33ec:	87aa                	mv	a5,a0
    33ee:	0207c163          	bltz	a5,3410 <linktest+0x13e>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    33f2:	fd843583          	ld	a1,-40(s0)
    33f6:	00006517          	auipc	a0,0x6
    33fa:	c5250513          	addi	a0,a0,-942 # 9048 <malloc+0xe5c>
    33fe:	00005097          	auipc	ra,0x5
    3402:	bfa080e7          	jalr	-1030(ra) # 7ff8 <printf>
    exit(1);
    3406:	4505                	li	a0,1
    3408:	00004097          	auipc	ra,0x4
    340c:	6c4080e7          	jalr	1732(ra) # 7acc <exit>
  }

  fd = open("lf2", 0);
    3410:	4581                	li	a1,0
    3412:	00006517          	auipc	a0,0x6
    3416:	bde50513          	addi	a0,a0,-1058 # 8ff0 <malloc+0xe04>
    341a:	00004097          	auipc	ra,0x4
    341e:	6f2080e7          	jalr	1778(ra) # 7b0c <open>
    3422:	87aa                	mv	a5,a0
    3424:	fef42623          	sw	a5,-20(s0)
  if(fd < 0){
    3428:	fec42783          	lw	a5,-20(s0)
    342c:	2781                	sext.w	a5,a5
    342e:	0207d163          	bgez	a5,3450 <linktest+0x17e>
    printf("%s: open lf2 failed\n", s);
    3432:	fd843583          	ld	a1,-40(s0)
    3436:	00006517          	auipc	a0,0x6
    343a:	c4250513          	addi	a0,a0,-958 # 9078 <malloc+0xe8c>
    343e:	00005097          	auipc	ra,0x5
    3442:	bba080e7          	jalr	-1094(ra) # 7ff8 <printf>
    exit(1);
    3446:	4505                	li	a0,1
    3448:	00004097          	auipc	ra,0x4
    344c:	684080e7          	jalr	1668(ra) # 7acc <exit>
  }
  if(read(fd, buf, sizeof(buf)) != SZ){
    3450:	fec42783          	lw	a5,-20(s0)
    3454:	660d                	lui	a2,0x3
    3456:	00008597          	auipc	a1,0x8
    345a:	01a58593          	addi	a1,a1,26 # b470 <buf>
    345e:	853e                	mv	a0,a5
    3460:	00004097          	auipc	ra,0x4
    3464:	684080e7          	jalr	1668(ra) # 7ae4 <read>
    3468:	87aa                	mv	a5,a0
    346a:	873e                	mv	a4,a5
    346c:	4795                	li	a5,5
    346e:	02f70163          	beq	a4,a5,3490 <linktest+0x1be>
    printf("%s: read lf2 failed\n", s);
    3472:	fd843583          	ld	a1,-40(s0)
    3476:	00006517          	auipc	a0,0x6
    347a:	c1a50513          	addi	a0,a0,-998 # 9090 <malloc+0xea4>
    347e:	00005097          	auipc	ra,0x5
    3482:	b7a080e7          	jalr	-1158(ra) # 7ff8 <printf>
    exit(1);
    3486:	4505                	li	a0,1
    3488:	00004097          	auipc	ra,0x4
    348c:	644080e7          	jalr	1604(ra) # 7acc <exit>
  }
  close(fd);
    3490:	fec42783          	lw	a5,-20(s0)
    3494:	853e                	mv	a0,a5
    3496:	00004097          	auipc	ra,0x4
    349a:	65e080e7          	jalr	1630(ra) # 7af4 <close>

  if(link("lf2", "lf2") >= 0){
    349e:	00006597          	auipc	a1,0x6
    34a2:	b5258593          	addi	a1,a1,-1198 # 8ff0 <malloc+0xe04>
    34a6:	00006517          	auipc	a0,0x6
    34aa:	b4a50513          	addi	a0,a0,-1206 # 8ff0 <malloc+0xe04>
    34ae:	00004097          	auipc	ra,0x4
    34b2:	67e080e7          	jalr	1662(ra) # 7b2c <link>
    34b6:	87aa                	mv	a5,a0
    34b8:	0207c163          	bltz	a5,34da <linktest+0x208>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    34bc:	fd843583          	ld	a1,-40(s0)
    34c0:	00006517          	auipc	a0,0x6
    34c4:	be850513          	addi	a0,a0,-1048 # 90a8 <malloc+0xebc>
    34c8:	00005097          	auipc	ra,0x5
    34cc:	b30080e7          	jalr	-1232(ra) # 7ff8 <printf>
    exit(1);
    34d0:	4505                	li	a0,1
    34d2:	00004097          	auipc	ra,0x4
    34d6:	5fa080e7          	jalr	1530(ra) # 7acc <exit>
  }

  unlink("lf2");
    34da:	00006517          	auipc	a0,0x6
    34de:	b1650513          	addi	a0,a0,-1258 # 8ff0 <malloc+0xe04>
    34e2:	00004097          	auipc	ra,0x4
    34e6:	63a080e7          	jalr	1594(ra) # 7b1c <unlink>
  if(link("lf2", "lf1") >= 0){
    34ea:	00006597          	auipc	a1,0x6
    34ee:	afe58593          	addi	a1,a1,-1282 # 8fe8 <malloc+0xdfc>
    34f2:	00006517          	auipc	a0,0x6
    34f6:	afe50513          	addi	a0,a0,-1282 # 8ff0 <malloc+0xe04>
    34fa:	00004097          	auipc	ra,0x4
    34fe:	632080e7          	jalr	1586(ra) # 7b2c <link>
    3502:	87aa                	mv	a5,a0
    3504:	0207c163          	bltz	a5,3526 <linktest+0x254>
    printf("%s: link non-existent succeeded! oops\n", s);
    3508:	fd843583          	ld	a1,-40(s0)
    350c:	00006517          	auipc	a0,0x6
    3510:	bc450513          	addi	a0,a0,-1084 # 90d0 <malloc+0xee4>
    3514:	00005097          	auipc	ra,0x5
    3518:	ae4080e7          	jalr	-1308(ra) # 7ff8 <printf>
    exit(1);
    351c:	4505                	li	a0,1
    351e:	00004097          	auipc	ra,0x4
    3522:	5ae080e7          	jalr	1454(ra) # 7acc <exit>
  }

  if(link(".", "lf1") >= 0){
    3526:	00006597          	auipc	a1,0x6
    352a:	ac258593          	addi	a1,a1,-1342 # 8fe8 <malloc+0xdfc>
    352e:	00006517          	auipc	a0,0x6
    3532:	bca50513          	addi	a0,a0,-1078 # 90f8 <malloc+0xf0c>
    3536:	00004097          	auipc	ra,0x4
    353a:	5f6080e7          	jalr	1526(ra) # 7b2c <link>
    353e:	87aa                	mv	a5,a0
    3540:	0207c163          	bltz	a5,3562 <linktest+0x290>
    printf("%s: link . lf1 succeeded! oops\n", s);
    3544:	fd843583          	ld	a1,-40(s0)
    3548:	00006517          	auipc	a0,0x6
    354c:	bb850513          	addi	a0,a0,-1096 # 9100 <malloc+0xf14>
    3550:	00005097          	auipc	ra,0x5
    3554:	aa8080e7          	jalr	-1368(ra) # 7ff8 <printf>
    exit(1);
    3558:	4505                	li	a0,1
    355a:	00004097          	auipc	ra,0x4
    355e:	572080e7          	jalr	1394(ra) # 7acc <exit>
  }
}
    3562:	0001                	nop
    3564:	70a2                	ld	ra,40(sp)
    3566:	7402                	ld	s0,32(sp)
    3568:	6145                	addi	sp,sp,48
    356a:	8082                	ret

000000000000356c <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(char *s)
{
    356c:	7119                	addi	sp,sp,-128
    356e:	fc86                	sd	ra,120(sp)
    3570:	f8a2                	sd	s0,112(sp)
    3572:	0100                	addi	s0,sp,128
    3574:	f8a43423          	sd	a0,-120(s0)
  struct {
    ushort inum;
    char name[DIRSIZ];
  } de;

  file[0] = 'C';
    3578:	04300793          	li	a5,67
    357c:	fcf40c23          	sb	a5,-40(s0)
  file[2] = '\0';
    3580:	fc040d23          	sb	zero,-38(s0)
  for(i = 0; i < N; i++){
    3584:	fe042623          	sw	zero,-20(s0)
    3588:	a2a5                	j	36f0 <concreate+0x184>
    file[1] = '0' + i;
    358a:	fec42783          	lw	a5,-20(s0)
    358e:	0ff7f793          	zext.b	a5,a5
    3592:	0307879b          	addiw	a5,a5,48
    3596:	0ff7f793          	zext.b	a5,a5
    359a:	fcf40ca3          	sb	a5,-39(s0)
    unlink(file);
    359e:	fd840793          	addi	a5,s0,-40
    35a2:	853e                	mv	a0,a5
    35a4:	00004097          	auipc	ra,0x4
    35a8:	578080e7          	jalr	1400(ra) # 7b1c <unlink>
    pid = fork();
    35ac:	00004097          	auipc	ra,0x4
    35b0:	518080e7          	jalr	1304(ra) # 7ac4 <fork>
    35b4:	87aa                	mv	a5,a0
    35b6:	fef42023          	sw	a5,-32(s0)
    if(pid && (i % 3) == 1){
    35ba:	fe042783          	lw	a5,-32(s0)
    35be:	2781                	sext.w	a5,a5
    35c0:	c7b1                	beqz	a5,360c <concreate+0xa0>
    35c2:	fec42783          	lw	a5,-20(s0)
    35c6:	0007869b          	sext.w	a3,a5
    35ca:	55555737          	lui	a4,0x55555
    35ce:	55670713          	addi	a4,a4,1366 # 55555556 <freep+0x555438be>
    35d2:	02e68733          	mul	a4,a3,a4
    35d6:	9301                	srli	a4,a4,0x20
    35d8:	41f7d69b          	sraiw	a3,a5,0x1f
    35dc:	9f15                	subw	a4,a4,a3
    35de:	86ba                	mv	a3,a4
    35e0:	8736                	mv	a4,a3
    35e2:	0017171b          	slliw	a4,a4,0x1
    35e6:	9f35                	addw	a4,a4,a3
    35e8:	9f99                	subw	a5,a5,a4
    35ea:	0007871b          	sext.w	a4,a5
    35ee:	4785                	li	a5,1
    35f0:	00f71e63          	bne	a4,a5,360c <concreate+0xa0>
      link("C0", file);
    35f4:	fd840793          	addi	a5,s0,-40
    35f8:	85be                	mv	a1,a5
    35fa:	00006517          	auipc	a0,0x6
    35fe:	b2650513          	addi	a0,a0,-1242 # 9120 <malloc+0xf34>
    3602:	00004097          	auipc	ra,0x4
    3606:	52a080e7          	jalr	1322(ra) # 7b2c <link>
    360a:	a075                	j	36b6 <concreate+0x14a>
    } else if(pid == 0 && (i % 5) == 1){
    360c:	fe042783          	lw	a5,-32(s0)
    3610:	2781                	sext.w	a5,a5
    3612:	ebb1                	bnez	a5,3666 <concreate+0xfa>
    3614:	fec42783          	lw	a5,-20(s0)
    3618:	0007869b          	sext.w	a3,a5
    361c:	66666737          	lui	a4,0x66666
    3620:	66770713          	addi	a4,a4,1639 # 66666667 <freep+0x666549cf>
    3624:	02e68733          	mul	a4,a3,a4
    3628:	9301                	srli	a4,a4,0x20
    362a:	4017571b          	sraiw	a4,a4,0x1
    362e:	86ba                	mv	a3,a4
    3630:	41f7d71b          	sraiw	a4,a5,0x1f
    3634:	40e6873b          	subw	a4,a3,a4
    3638:	86ba                	mv	a3,a4
    363a:	8736                	mv	a4,a3
    363c:	0027171b          	slliw	a4,a4,0x2
    3640:	9f35                	addw	a4,a4,a3
    3642:	9f99                	subw	a5,a5,a4
    3644:	0007871b          	sext.w	a4,a5
    3648:	4785                	li	a5,1
    364a:	00f71e63          	bne	a4,a5,3666 <concreate+0xfa>
      link("C0", file);
    364e:	fd840793          	addi	a5,s0,-40
    3652:	85be                	mv	a1,a5
    3654:	00006517          	auipc	a0,0x6
    3658:	acc50513          	addi	a0,a0,-1332 # 9120 <malloc+0xf34>
    365c:	00004097          	auipc	ra,0x4
    3660:	4d0080e7          	jalr	1232(ra) # 7b2c <link>
    3664:	a889                	j	36b6 <concreate+0x14a>
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    3666:	fd840793          	addi	a5,s0,-40
    366a:	20200593          	li	a1,514
    366e:	853e                	mv	a0,a5
    3670:	00004097          	auipc	ra,0x4
    3674:	49c080e7          	jalr	1180(ra) # 7b0c <open>
    3678:	87aa                	mv	a5,a0
    367a:	fef42223          	sw	a5,-28(s0)
      if(fd < 0){
    367e:	fe442783          	lw	a5,-28(s0)
    3682:	2781                	sext.w	a5,a5
    3684:	0207d263          	bgez	a5,36a8 <concreate+0x13c>
        printf("concreate create %s failed\n", file);
    3688:	fd840793          	addi	a5,s0,-40
    368c:	85be                	mv	a1,a5
    368e:	00006517          	auipc	a0,0x6
    3692:	a9a50513          	addi	a0,a0,-1382 # 9128 <malloc+0xf3c>
    3696:	00005097          	auipc	ra,0x5
    369a:	962080e7          	jalr	-1694(ra) # 7ff8 <printf>
        exit(1);
    369e:	4505                	li	a0,1
    36a0:	00004097          	auipc	ra,0x4
    36a4:	42c080e7          	jalr	1068(ra) # 7acc <exit>
      }
      close(fd);
    36a8:	fe442783          	lw	a5,-28(s0)
    36ac:	853e                	mv	a0,a5
    36ae:	00004097          	auipc	ra,0x4
    36b2:	446080e7          	jalr	1094(ra) # 7af4 <close>
    }
    if(pid == 0) {
    36b6:	fe042783          	lw	a5,-32(s0)
    36ba:	2781                	sext.w	a5,a5
    36bc:	e791                	bnez	a5,36c8 <concreate+0x15c>
      exit(0);
    36be:	4501                	li	a0,0
    36c0:	00004097          	auipc	ra,0x4
    36c4:	40c080e7          	jalr	1036(ra) # 7acc <exit>
    } else {
      int xstatus;
      wait(&xstatus);
    36c8:	f9c40793          	addi	a5,s0,-100
    36cc:	853e                	mv	a0,a5
    36ce:	00004097          	auipc	ra,0x4
    36d2:	406080e7          	jalr	1030(ra) # 7ad4 <wait>
      if(xstatus != 0)
    36d6:	f9c42783          	lw	a5,-100(s0)
    36da:	c791                	beqz	a5,36e6 <concreate+0x17a>
        exit(1);
    36dc:	4505                	li	a0,1
    36de:	00004097          	auipc	ra,0x4
    36e2:	3ee080e7          	jalr	1006(ra) # 7acc <exit>
  for(i = 0; i < N; i++){
    36e6:	fec42783          	lw	a5,-20(s0)
    36ea:	2785                	addiw	a5,a5,1
    36ec:	fef42623          	sw	a5,-20(s0)
    36f0:	fec42783          	lw	a5,-20(s0)
    36f4:	0007871b          	sext.w	a4,a5
    36f8:	02700793          	li	a5,39
    36fc:	e8e7d7e3          	bge	a5,a4,358a <concreate+0x1e>
    }
  }

  memset(fa, 0, sizeof(fa));
    3700:	fb040793          	addi	a5,s0,-80
    3704:	02800613          	li	a2,40
    3708:	4581                	li	a1,0
    370a:	853e                	mv	a0,a5
    370c:	00004097          	auipc	ra,0x4
    3710:	002080e7          	jalr	2(ra) # 770e <memset>
  fd = open(".", 0);
    3714:	4581                	li	a1,0
    3716:	00006517          	auipc	a0,0x6
    371a:	9e250513          	addi	a0,a0,-1566 # 90f8 <malloc+0xf0c>
    371e:	00004097          	auipc	ra,0x4
    3722:	3ee080e7          	jalr	1006(ra) # 7b0c <open>
    3726:	87aa                	mv	a5,a0
    3728:	fef42223          	sw	a5,-28(s0)
  n = 0;
    372c:	fe042423          	sw	zero,-24(s0)
  while(read(fd, &de, sizeof(de)) > 0){
    3730:	a85d                	j	37e6 <concreate+0x27a>
    if(de.inum == 0)
    3732:	fa045783          	lhu	a5,-96(s0)
    3736:	c7dd                	beqz	a5,37e4 <concreate+0x278>
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    3738:	fa244783          	lbu	a5,-94(s0)
    373c:	873e                	mv	a4,a5
    373e:	04300793          	li	a5,67
    3742:	0af71263          	bne	a4,a5,37e6 <concreate+0x27a>
    3746:	fa444783          	lbu	a5,-92(s0)
    374a:	efd1                	bnez	a5,37e6 <concreate+0x27a>
      i = de.name[1] - '0';
    374c:	fa344783          	lbu	a5,-93(s0)
    3750:	2781                	sext.w	a5,a5
    3752:	fd07879b          	addiw	a5,a5,-48
    3756:	fef42623          	sw	a5,-20(s0)
      if(i < 0 || i >= sizeof(fa)){
    375a:	fec42783          	lw	a5,-20(s0)
    375e:	2781                	sext.w	a5,a5
    3760:	0007c863          	bltz	a5,3770 <concreate+0x204>
    3764:	fec42703          	lw	a4,-20(s0)
    3768:	02700793          	li	a5,39
    376c:	02e7f563          	bgeu	a5,a4,3796 <concreate+0x22a>
        printf("%s: concreate weird file %s\n", s, de.name);
    3770:	fa040793          	addi	a5,s0,-96
    3774:	0789                	addi	a5,a5,2
    3776:	863e                	mv	a2,a5
    3778:	f8843583          	ld	a1,-120(s0)
    377c:	00006517          	auipc	a0,0x6
    3780:	9cc50513          	addi	a0,a0,-1588 # 9148 <malloc+0xf5c>
    3784:	00005097          	auipc	ra,0x5
    3788:	874080e7          	jalr	-1932(ra) # 7ff8 <printf>
        exit(1);
    378c:	4505                	li	a0,1
    378e:	00004097          	auipc	ra,0x4
    3792:	33e080e7          	jalr	830(ra) # 7acc <exit>
      }
      if(fa[i]){
    3796:	fec42783          	lw	a5,-20(s0)
    379a:	17c1                	addi	a5,a5,-16
    379c:	97a2                	add	a5,a5,s0
    379e:	fc07c783          	lbu	a5,-64(a5)
    37a2:	c785                	beqz	a5,37ca <concreate+0x25e>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    37a4:	fa040793          	addi	a5,s0,-96
    37a8:	0789                	addi	a5,a5,2
    37aa:	863e                	mv	a2,a5
    37ac:	f8843583          	ld	a1,-120(s0)
    37b0:	00006517          	auipc	a0,0x6
    37b4:	9b850513          	addi	a0,a0,-1608 # 9168 <malloc+0xf7c>
    37b8:	00005097          	auipc	ra,0x5
    37bc:	840080e7          	jalr	-1984(ra) # 7ff8 <printf>
        exit(1);
    37c0:	4505                	li	a0,1
    37c2:	00004097          	auipc	ra,0x4
    37c6:	30a080e7          	jalr	778(ra) # 7acc <exit>
      }
      fa[i] = 1;
    37ca:	fec42783          	lw	a5,-20(s0)
    37ce:	17c1                	addi	a5,a5,-16
    37d0:	97a2                	add	a5,a5,s0
    37d2:	4705                	li	a4,1
    37d4:	fce78023          	sb	a4,-64(a5)
      n++;
    37d8:	fe842783          	lw	a5,-24(s0)
    37dc:	2785                	addiw	a5,a5,1
    37de:	fef42423          	sw	a5,-24(s0)
    37e2:	a011                	j	37e6 <concreate+0x27a>
      continue;
    37e4:	0001                	nop
  while(read(fd, &de, sizeof(de)) > 0){
    37e6:	fa040713          	addi	a4,s0,-96
    37ea:	fe442783          	lw	a5,-28(s0)
    37ee:	4641                	li	a2,16
    37f0:	85ba                	mv	a1,a4
    37f2:	853e                	mv	a0,a5
    37f4:	00004097          	auipc	ra,0x4
    37f8:	2f0080e7          	jalr	752(ra) # 7ae4 <read>
    37fc:	87aa                	mv	a5,a0
    37fe:	f2f04ae3          	bgtz	a5,3732 <concreate+0x1c6>
    }
  }
  close(fd);
    3802:	fe442783          	lw	a5,-28(s0)
    3806:	853e                	mv	a0,a5
    3808:	00004097          	auipc	ra,0x4
    380c:	2ec080e7          	jalr	748(ra) # 7af4 <close>

  if(n != N){
    3810:	fe842783          	lw	a5,-24(s0)
    3814:	0007871b          	sext.w	a4,a5
    3818:	02800793          	li	a5,40
    381c:	02f70163          	beq	a4,a5,383e <concreate+0x2d2>
    printf("%s: concreate not enough files in directory listing\n", s);
    3820:	f8843583          	ld	a1,-120(s0)
    3824:	00006517          	auipc	a0,0x6
    3828:	96c50513          	addi	a0,a0,-1684 # 9190 <malloc+0xfa4>
    382c:	00004097          	auipc	ra,0x4
    3830:	7cc080e7          	jalr	1996(ra) # 7ff8 <printf>
    exit(1);
    3834:	4505                	li	a0,1
    3836:	00004097          	auipc	ra,0x4
    383a:	296080e7          	jalr	662(ra) # 7acc <exit>
  }

  for(i = 0; i < N; i++){
    383e:	fe042623          	sw	zero,-20(s0)
    3842:	aaf9                	j	3a20 <concreate+0x4b4>
    file[1] = '0' + i;
    3844:	fec42783          	lw	a5,-20(s0)
    3848:	0ff7f793          	zext.b	a5,a5
    384c:	0307879b          	addiw	a5,a5,48
    3850:	0ff7f793          	zext.b	a5,a5
    3854:	fcf40ca3          	sb	a5,-39(s0)
    pid = fork();
    3858:	00004097          	auipc	ra,0x4
    385c:	26c080e7          	jalr	620(ra) # 7ac4 <fork>
    3860:	87aa                	mv	a5,a0
    3862:	fef42023          	sw	a5,-32(s0)
    if(pid < 0){
    3866:	fe042783          	lw	a5,-32(s0)
    386a:	2781                	sext.w	a5,a5
    386c:	0207d163          	bgez	a5,388e <concreate+0x322>
      printf("%s: fork failed\n", s);
    3870:	f8843583          	ld	a1,-120(s0)
    3874:	00005517          	auipc	a0,0x5
    3878:	efc50513          	addi	a0,a0,-260 # 8770 <malloc+0x584>
    387c:	00004097          	auipc	ra,0x4
    3880:	77c080e7          	jalr	1916(ra) # 7ff8 <printf>
      exit(1);
    3884:	4505                	li	a0,1
    3886:	00004097          	auipc	ra,0x4
    388a:	246080e7          	jalr	582(ra) # 7acc <exit>
    }
    if(((i % 3) == 0 && pid == 0) ||
    388e:	fec42783          	lw	a5,-20(s0)
    3892:	0007869b          	sext.w	a3,a5
    3896:	55555737          	lui	a4,0x55555
    389a:	55670713          	addi	a4,a4,1366 # 55555556 <freep+0x555438be>
    389e:	02e68733          	mul	a4,a3,a4
    38a2:	9301                	srli	a4,a4,0x20
    38a4:	41f7d69b          	sraiw	a3,a5,0x1f
    38a8:	9f15                	subw	a4,a4,a3
    38aa:	86ba                	mv	a3,a4
    38ac:	8736                	mv	a4,a3
    38ae:	0017171b          	slliw	a4,a4,0x1
    38b2:	9f35                	addw	a4,a4,a3
    38b4:	9f99                	subw	a5,a5,a4
    38b6:	2781                	sext.w	a5,a5
    38b8:	e789                	bnez	a5,38c2 <concreate+0x356>
    38ba:	fe042783          	lw	a5,-32(s0)
    38be:	2781                	sext.w	a5,a5
    38c0:	cf95                	beqz	a5,38fc <concreate+0x390>
       ((i % 3) == 1 && pid != 0)){
    38c2:	fec42783          	lw	a5,-20(s0)
    38c6:	0007869b          	sext.w	a3,a5
    38ca:	55555737          	lui	a4,0x55555
    38ce:	55670713          	addi	a4,a4,1366 # 55555556 <freep+0x555438be>
    38d2:	02e68733          	mul	a4,a3,a4
    38d6:	9301                	srli	a4,a4,0x20
    38d8:	41f7d69b          	sraiw	a3,a5,0x1f
    38dc:	9f15                	subw	a4,a4,a3
    38de:	86ba                	mv	a3,a4
    38e0:	8736                	mv	a4,a3
    38e2:	0017171b          	slliw	a4,a4,0x1
    38e6:	9f35                	addw	a4,a4,a3
    38e8:	9f99                	subw	a5,a5,a4
    38ea:	0007871b          	sext.w	a4,a5
    if(((i % 3) == 0 && pid == 0) ||
    38ee:	4785                	li	a5,1
    38f0:	0af71b63          	bne	a4,a5,39a6 <concreate+0x43a>
       ((i % 3) == 1 && pid != 0)){
    38f4:	fe042783          	lw	a5,-32(s0)
    38f8:	2781                	sext.w	a5,a5
    38fa:	c7d5                	beqz	a5,39a6 <concreate+0x43a>
      close(open(file, 0));
    38fc:	fd840793          	addi	a5,s0,-40
    3900:	4581                	li	a1,0
    3902:	853e                	mv	a0,a5
    3904:	00004097          	auipc	ra,0x4
    3908:	208080e7          	jalr	520(ra) # 7b0c <open>
    390c:	87aa                	mv	a5,a0
    390e:	853e                	mv	a0,a5
    3910:	00004097          	auipc	ra,0x4
    3914:	1e4080e7          	jalr	484(ra) # 7af4 <close>
      close(open(file, 0));
    3918:	fd840793          	addi	a5,s0,-40
    391c:	4581                	li	a1,0
    391e:	853e                	mv	a0,a5
    3920:	00004097          	auipc	ra,0x4
    3924:	1ec080e7          	jalr	492(ra) # 7b0c <open>
    3928:	87aa                	mv	a5,a0
    392a:	853e                	mv	a0,a5
    392c:	00004097          	auipc	ra,0x4
    3930:	1c8080e7          	jalr	456(ra) # 7af4 <close>
      close(open(file, 0));
    3934:	fd840793          	addi	a5,s0,-40
    3938:	4581                	li	a1,0
    393a:	853e                	mv	a0,a5
    393c:	00004097          	auipc	ra,0x4
    3940:	1d0080e7          	jalr	464(ra) # 7b0c <open>
    3944:	87aa                	mv	a5,a0
    3946:	853e                	mv	a0,a5
    3948:	00004097          	auipc	ra,0x4
    394c:	1ac080e7          	jalr	428(ra) # 7af4 <close>
      close(open(file, 0));
    3950:	fd840793          	addi	a5,s0,-40
    3954:	4581                	li	a1,0
    3956:	853e                	mv	a0,a5
    3958:	00004097          	auipc	ra,0x4
    395c:	1b4080e7          	jalr	436(ra) # 7b0c <open>
    3960:	87aa                	mv	a5,a0
    3962:	853e                	mv	a0,a5
    3964:	00004097          	auipc	ra,0x4
    3968:	190080e7          	jalr	400(ra) # 7af4 <close>
      close(open(file, 0));
    396c:	fd840793          	addi	a5,s0,-40
    3970:	4581                	li	a1,0
    3972:	853e                	mv	a0,a5
    3974:	00004097          	auipc	ra,0x4
    3978:	198080e7          	jalr	408(ra) # 7b0c <open>
    397c:	87aa                	mv	a5,a0
    397e:	853e                	mv	a0,a5
    3980:	00004097          	auipc	ra,0x4
    3984:	174080e7          	jalr	372(ra) # 7af4 <close>
      close(open(file, 0));
    3988:	fd840793          	addi	a5,s0,-40
    398c:	4581                	li	a1,0
    398e:	853e                	mv	a0,a5
    3990:	00004097          	auipc	ra,0x4
    3994:	17c080e7          	jalr	380(ra) # 7b0c <open>
    3998:	87aa                	mv	a5,a0
    399a:	853e                	mv	a0,a5
    399c:	00004097          	auipc	ra,0x4
    39a0:	158080e7          	jalr	344(ra) # 7af4 <close>
    39a4:	a899                	j	39fa <concreate+0x48e>
    } else {
      unlink(file);
    39a6:	fd840793          	addi	a5,s0,-40
    39aa:	853e                	mv	a0,a5
    39ac:	00004097          	auipc	ra,0x4
    39b0:	170080e7          	jalr	368(ra) # 7b1c <unlink>
      unlink(file);
    39b4:	fd840793          	addi	a5,s0,-40
    39b8:	853e                	mv	a0,a5
    39ba:	00004097          	auipc	ra,0x4
    39be:	162080e7          	jalr	354(ra) # 7b1c <unlink>
      unlink(file);
    39c2:	fd840793          	addi	a5,s0,-40
    39c6:	853e                	mv	a0,a5
    39c8:	00004097          	auipc	ra,0x4
    39cc:	154080e7          	jalr	340(ra) # 7b1c <unlink>
      unlink(file);
    39d0:	fd840793          	addi	a5,s0,-40
    39d4:	853e                	mv	a0,a5
    39d6:	00004097          	auipc	ra,0x4
    39da:	146080e7          	jalr	326(ra) # 7b1c <unlink>
      unlink(file);
    39de:	fd840793          	addi	a5,s0,-40
    39e2:	853e                	mv	a0,a5
    39e4:	00004097          	auipc	ra,0x4
    39e8:	138080e7          	jalr	312(ra) # 7b1c <unlink>
      unlink(file);
    39ec:	fd840793          	addi	a5,s0,-40
    39f0:	853e                	mv	a0,a5
    39f2:	00004097          	auipc	ra,0x4
    39f6:	12a080e7          	jalr	298(ra) # 7b1c <unlink>
    }
    if(pid == 0)
    39fa:	fe042783          	lw	a5,-32(s0)
    39fe:	2781                	sext.w	a5,a5
    3a00:	e791                	bnez	a5,3a0c <concreate+0x4a0>
      exit(0);
    3a02:	4501                	li	a0,0
    3a04:	00004097          	auipc	ra,0x4
    3a08:	0c8080e7          	jalr	200(ra) # 7acc <exit>
    else
      wait(0);
    3a0c:	4501                	li	a0,0
    3a0e:	00004097          	auipc	ra,0x4
    3a12:	0c6080e7          	jalr	198(ra) # 7ad4 <wait>
  for(i = 0; i < N; i++){
    3a16:	fec42783          	lw	a5,-20(s0)
    3a1a:	2785                	addiw	a5,a5,1
    3a1c:	fef42623          	sw	a5,-20(s0)
    3a20:	fec42783          	lw	a5,-20(s0)
    3a24:	0007871b          	sext.w	a4,a5
    3a28:	02700793          	li	a5,39
    3a2c:	e0e7dce3          	bge	a5,a4,3844 <concreate+0x2d8>
  }
}
    3a30:	0001                	nop
    3a32:	0001                	nop
    3a34:	70e6                	ld	ra,120(sp)
    3a36:	7446                	ld	s0,112(sp)
    3a38:	6109                	addi	sp,sp,128
    3a3a:	8082                	ret

0000000000003a3c <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink(char *s)
{
    3a3c:	7179                	addi	sp,sp,-48
    3a3e:	f406                	sd	ra,40(sp)
    3a40:	f022                	sd	s0,32(sp)
    3a42:	1800                	addi	s0,sp,48
    3a44:	fca43c23          	sd	a0,-40(s0)
  int pid, i;

  unlink("x");
    3a48:	00005517          	auipc	a0,0x5
    3a4c:	9f850513          	addi	a0,a0,-1544 # 8440 <malloc+0x254>
    3a50:	00004097          	auipc	ra,0x4
    3a54:	0cc080e7          	jalr	204(ra) # 7b1c <unlink>
  pid = fork();
    3a58:	00004097          	auipc	ra,0x4
    3a5c:	06c080e7          	jalr	108(ra) # 7ac4 <fork>
    3a60:	87aa                	mv	a5,a0
    3a62:	fef42223          	sw	a5,-28(s0)
  if(pid < 0){
    3a66:	fe442783          	lw	a5,-28(s0)
    3a6a:	2781                	sext.w	a5,a5
    3a6c:	0207d163          	bgez	a5,3a8e <linkunlink+0x52>
    printf("%s: fork failed\n", s);
    3a70:	fd843583          	ld	a1,-40(s0)
    3a74:	00005517          	auipc	a0,0x5
    3a78:	cfc50513          	addi	a0,a0,-772 # 8770 <malloc+0x584>
    3a7c:	00004097          	auipc	ra,0x4
    3a80:	57c080e7          	jalr	1404(ra) # 7ff8 <printf>
    exit(1);
    3a84:	4505                	li	a0,1
    3a86:	00004097          	auipc	ra,0x4
    3a8a:	046080e7          	jalr	70(ra) # 7acc <exit>
  }

  unsigned int x = (pid ? 1 : 97);
    3a8e:	fe442783          	lw	a5,-28(s0)
    3a92:	2781                	sext.w	a5,a5
    3a94:	c399                	beqz	a5,3a9a <linkunlink+0x5e>
    3a96:	4785                	li	a5,1
    3a98:	a019                	j	3a9e <linkunlink+0x62>
    3a9a:	06100793          	li	a5,97
    3a9e:	fef42423          	sw	a5,-24(s0)
  for(i = 0; i < 100; i++){
    3aa2:	fe042623          	sw	zero,-20(s0)
    3aa6:	a0d5                	j	3b8a <linkunlink+0x14e>
    x = x * 1103515245 + 12345;
    3aa8:	fe842783          	lw	a5,-24(s0)
    3aac:	873e                	mv	a4,a5
    3aae:	41c657b7          	lui	a5,0x41c65
    3ab2:	e6d7879b          	addiw	a5,a5,-403 # 41c64e6d <freep+0x41c531d5>
    3ab6:	02f707bb          	mulw	a5,a4,a5
    3aba:	0007871b          	sext.w	a4,a5
    3abe:	678d                	lui	a5,0x3
    3ac0:	0397879b          	addiw	a5,a5,57 # 3039 <createdelete+0x2c5>
    3ac4:	9fb9                	addw	a5,a5,a4
    3ac6:	fef42423          	sw	a5,-24(s0)
    if((x % 3) == 0){
    3aca:	fe842783          	lw	a5,-24(s0)
    3ace:	86be                	mv	a3,a5
    3ad0:	02069713          	slli	a4,a3,0x20
    3ad4:	9301                	srli	a4,a4,0x20
    3ad6:	00007797          	auipc	a5,0x7
    3ada:	d2a78793          	addi	a5,a5,-726 # a800 <malloc+0x2614>
    3ade:	639c                	ld	a5,0(a5)
    3ae0:	02f707b3          	mul	a5,a4,a5
    3ae4:	9381                	srli	a5,a5,0x20
    3ae6:	0017d79b          	srliw	a5,a5,0x1
    3aea:	873e                	mv	a4,a5
    3aec:	87ba                	mv	a5,a4
    3aee:	0017979b          	slliw	a5,a5,0x1
    3af2:	9fb9                	addw	a5,a5,a4
    3af4:	40f687bb          	subw	a5,a3,a5
    3af8:	2781                	sext.w	a5,a5
    3afa:	e395                	bnez	a5,3b1e <linkunlink+0xe2>
      close(open("x", O_RDWR | O_CREATE));
    3afc:	20200593          	li	a1,514
    3b00:	00005517          	auipc	a0,0x5
    3b04:	94050513          	addi	a0,a0,-1728 # 8440 <malloc+0x254>
    3b08:	00004097          	auipc	ra,0x4
    3b0c:	004080e7          	jalr	4(ra) # 7b0c <open>
    3b10:	87aa                	mv	a5,a0
    3b12:	853e                	mv	a0,a5
    3b14:	00004097          	auipc	ra,0x4
    3b18:	fe0080e7          	jalr	-32(ra) # 7af4 <close>
    3b1c:	a095                	j	3b80 <linkunlink+0x144>
    } else if((x % 3) == 1){
    3b1e:	fe842783          	lw	a5,-24(s0)
    3b22:	86be                	mv	a3,a5
    3b24:	02069713          	slli	a4,a3,0x20
    3b28:	9301                	srli	a4,a4,0x20
    3b2a:	00007797          	auipc	a5,0x7
    3b2e:	cd678793          	addi	a5,a5,-810 # a800 <malloc+0x2614>
    3b32:	639c                	ld	a5,0(a5)
    3b34:	02f707b3          	mul	a5,a4,a5
    3b38:	9381                	srli	a5,a5,0x20
    3b3a:	0017d79b          	srliw	a5,a5,0x1
    3b3e:	873e                	mv	a4,a5
    3b40:	87ba                	mv	a5,a4
    3b42:	0017979b          	slliw	a5,a5,0x1
    3b46:	9fb9                	addw	a5,a5,a4
    3b48:	40f687bb          	subw	a5,a3,a5
    3b4c:	0007871b          	sext.w	a4,a5
    3b50:	4785                	li	a5,1
    3b52:	00f71f63          	bne	a4,a5,3b70 <linkunlink+0x134>
      link("cat", "x");
    3b56:	00005597          	auipc	a1,0x5
    3b5a:	8ea58593          	addi	a1,a1,-1814 # 8440 <malloc+0x254>
    3b5e:	00005517          	auipc	a0,0x5
    3b62:	66a50513          	addi	a0,a0,1642 # 91c8 <malloc+0xfdc>
    3b66:	00004097          	auipc	ra,0x4
    3b6a:	fc6080e7          	jalr	-58(ra) # 7b2c <link>
    3b6e:	a809                	j	3b80 <linkunlink+0x144>
    } else {
      unlink("x");
    3b70:	00005517          	auipc	a0,0x5
    3b74:	8d050513          	addi	a0,a0,-1840 # 8440 <malloc+0x254>
    3b78:	00004097          	auipc	ra,0x4
    3b7c:	fa4080e7          	jalr	-92(ra) # 7b1c <unlink>
  for(i = 0; i < 100; i++){
    3b80:	fec42783          	lw	a5,-20(s0)
    3b84:	2785                	addiw	a5,a5,1
    3b86:	fef42623          	sw	a5,-20(s0)
    3b8a:	fec42783          	lw	a5,-20(s0)
    3b8e:	0007871b          	sext.w	a4,a5
    3b92:	06300793          	li	a5,99
    3b96:	f0e7d9e3          	bge	a5,a4,3aa8 <linkunlink+0x6c>
    }
  }

  if(pid)
    3b9a:	fe442783          	lw	a5,-28(s0)
    3b9e:	2781                	sext.w	a5,a5
    3ba0:	c799                	beqz	a5,3bae <linkunlink+0x172>
    wait(0);
    3ba2:	4501                	li	a0,0
    3ba4:	00004097          	auipc	ra,0x4
    3ba8:	f30080e7          	jalr	-208(ra) # 7ad4 <wait>
  else
    exit(0);
}
    3bac:	a031                	j	3bb8 <linkunlink+0x17c>
    exit(0);
    3bae:	4501                	li	a0,0
    3bb0:	00004097          	auipc	ra,0x4
    3bb4:	f1c080e7          	jalr	-228(ra) # 7acc <exit>
}
    3bb8:	70a2                	ld	ra,40(sp)
    3bba:	7402                	ld	s0,32(sp)
    3bbc:	6145                	addi	sp,sp,48
    3bbe:	8082                	ret

0000000000003bc0 <subdir>:


void
subdir(char *s)
{
    3bc0:	7179                	addi	sp,sp,-48
    3bc2:	f406                	sd	ra,40(sp)
    3bc4:	f022                	sd	s0,32(sp)
    3bc6:	1800                	addi	s0,sp,48
    3bc8:	fca43c23          	sd	a0,-40(s0)
  int fd, cc;

  unlink("ff");
    3bcc:	00005517          	auipc	a0,0x5
    3bd0:	60450513          	addi	a0,a0,1540 # 91d0 <malloc+0xfe4>
    3bd4:	00004097          	auipc	ra,0x4
    3bd8:	f48080e7          	jalr	-184(ra) # 7b1c <unlink>
  if(mkdir("dd") != 0){
    3bdc:	00005517          	auipc	a0,0x5
    3be0:	5fc50513          	addi	a0,a0,1532 # 91d8 <malloc+0xfec>
    3be4:	00004097          	auipc	ra,0x4
    3be8:	f50080e7          	jalr	-176(ra) # 7b34 <mkdir>
    3bec:	87aa                	mv	a5,a0
    3bee:	c385                	beqz	a5,3c0e <subdir+0x4e>
    printf("%s: mkdir dd failed\n", s);
    3bf0:	fd843583          	ld	a1,-40(s0)
    3bf4:	00005517          	auipc	a0,0x5
    3bf8:	5ec50513          	addi	a0,a0,1516 # 91e0 <malloc+0xff4>
    3bfc:	00004097          	auipc	ra,0x4
    3c00:	3fc080e7          	jalr	1020(ra) # 7ff8 <printf>
    exit(1);
    3c04:	4505                	li	a0,1
    3c06:	00004097          	auipc	ra,0x4
    3c0a:	ec6080e7          	jalr	-314(ra) # 7acc <exit>
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    3c0e:	20200593          	li	a1,514
    3c12:	00005517          	auipc	a0,0x5
    3c16:	5e650513          	addi	a0,a0,1510 # 91f8 <malloc+0x100c>
    3c1a:	00004097          	auipc	ra,0x4
    3c1e:	ef2080e7          	jalr	-270(ra) # 7b0c <open>
    3c22:	87aa                	mv	a5,a0
    3c24:	fef42623          	sw	a5,-20(s0)
  if(fd < 0){
    3c28:	fec42783          	lw	a5,-20(s0)
    3c2c:	2781                	sext.w	a5,a5
    3c2e:	0207d163          	bgez	a5,3c50 <subdir+0x90>
    printf("%s: create dd/ff failed\n", s);
    3c32:	fd843583          	ld	a1,-40(s0)
    3c36:	00005517          	auipc	a0,0x5
    3c3a:	5ca50513          	addi	a0,a0,1482 # 9200 <malloc+0x1014>
    3c3e:	00004097          	auipc	ra,0x4
    3c42:	3ba080e7          	jalr	954(ra) # 7ff8 <printf>
    exit(1);
    3c46:	4505                	li	a0,1
    3c48:	00004097          	auipc	ra,0x4
    3c4c:	e84080e7          	jalr	-380(ra) # 7acc <exit>
  }
  write(fd, "ff", 2);
    3c50:	fec42783          	lw	a5,-20(s0)
    3c54:	4609                	li	a2,2
    3c56:	00005597          	auipc	a1,0x5
    3c5a:	57a58593          	addi	a1,a1,1402 # 91d0 <malloc+0xfe4>
    3c5e:	853e                	mv	a0,a5
    3c60:	00004097          	auipc	ra,0x4
    3c64:	e8c080e7          	jalr	-372(ra) # 7aec <write>
  close(fd);
    3c68:	fec42783          	lw	a5,-20(s0)
    3c6c:	853e                	mv	a0,a5
    3c6e:	00004097          	auipc	ra,0x4
    3c72:	e86080e7          	jalr	-378(ra) # 7af4 <close>

  if(unlink("dd") >= 0){
    3c76:	00005517          	auipc	a0,0x5
    3c7a:	56250513          	addi	a0,a0,1378 # 91d8 <malloc+0xfec>
    3c7e:	00004097          	auipc	ra,0x4
    3c82:	e9e080e7          	jalr	-354(ra) # 7b1c <unlink>
    3c86:	87aa                	mv	a5,a0
    3c88:	0207c163          	bltz	a5,3caa <subdir+0xea>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3c8c:	fd843583          	ld	a1,-40(s0)
    3c90:	00005517          	auipc	a0,0x5
    3c94:	59050513          	addi	a0,a0,1424 # 9220 <malloc+0x1034>
    3c98:	00004097          	auipc	ra,0x4
    3c9c:	360080e7          	jalr	864(ra) # 7ff8 <printf>
    exit(1);
    3ca0:	4505                	li	a0,1
    3ca2:	00004097          	auipc	ra,0x4
    3ca6:	e2a080e7          	jalr	-470(ra) # 7acc <exit>
  }

  if(mkdir("/dd/dd") != 0){
    3caa:	00005517          	auipc	a0,0x5
    3cae:	5a650513          	addi	a0,a0,1446 # 9250 <malloc+0x1064>
    3cb2:	00004097          	auipc	ra,0x4
    3cb6:	e82080e7          	jalr	-382(ra) # 7b34 <mkdir>
    3cba:	87aa                	mv	a5,a0
    3cbc:	c385                	beqz	a5,3cdc <subdir+0x11c>
    printf("subdir mkdir dd/dd failed\n", s);
    3cbe:	fd843583          	ld	a1,-40(s0)
    3cc2:	00005517          	auipc	a0,0x5
    3cc6:	59650513          	addi	a0,a0,1430 # 9258 <malloc+0x106c>
    3cca:	00004097          	auipc	ra,0x4
    3cce:	32e080e7          	jalr	814(ra) # 7ff8 <printf>
    exit(1);
    3cd2:	4505                	li	a0,1
    3cd4:	00004097          	auipc	ra,0x4
    3cd8:	df8080e7          	jalr	-520(ra) # 7acc <exit>
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    3cdc:	20200593          	li	a1,514
    3ce0:	00005517          	auipc	a0,0x5
    3ce4:	59850513          	addi	a0,a0,1432 # 9278 <malloc+0x108c>
    3ce8:	00004097          	auipc	ra,0x4
    3cec:	e24080e7          	jalr	-476(ra) # 7b0c <open>
    3cf0:	87aa                	mv	a5,a0
    3cf2:	fef42623          	sw	a5,-20(s0)
  if(fd < 0){
    3cf6:	fec42783          	lw	a5,-20(s0)
    3cfa:	2781                	sext.w	a5,a5
    3cfc:	0207d163          	bgez	a5,3d1e <subdir+0x15e>
    printf("%s: create dd/dd/ff failed\n", s);
    3d00:	fd843583          	ld	a1,-40(s0)
    3d04:	00005517          	auipc	a0,0x5
    3d08:	58450513          	addi	a0,a0,1412 # 9288 <malloc+0x109c>
    3d0c:	00004097          	auipc	ra,0x4
    3d10:	2ec080e7          	jalr	748(ra) # 7ff8 <printf>
    exit(1);
    3d14:	4505                	li	a0,1
    3d16:	00004097          	auipc	ra,0x4
    3d1a:	db6080e7          	jalr	-586(ra) # 7acc <exit>
  }
  write(fd, "FF", 2);
    3d1e:	fec42783          	lw	a5,-20(s0)
    3d22:	4609                	li	a2,2
    3d24:	00005597          	auipc	a1,0x5
    3d28:	58458593          	addi	a1,a1,1412 # 92a8 <malloc+0x10bc>
    3d2c:	853e                	mv	a0,a5
    3d2e:	00004097          	auipc	ra,0x4
    3d32:	dbe080e7          	jalr	-578(ra) # 7aec <write>
  close(fd);
    3d36:	fec42783          	lw	a5,-20(s0)
    3d3a:	853e                	mv	a0,a5
    3d3c:	00004097          	auipc	ra,0x4
    3d40:	db8080e7          	jalr	-584(ra) # 7af4 <close>

  fd = open("dd/dd/../ff", 0);
    3d44:	4581                	li	a1,0
    3d46:	00005517          	auipc	a0,0x5
    3d4a:	56a50513          	addi	a0,a0,1386 # 92b0 <malloc+0x10c4>
    3d4e:	00004097          	auipc	ra,0x4
    3d52:	dbe080e7          	jalr	-578(ra) # 7b0c <open>
    3d56:	87aa                	mv	a5,a0
    3d58:	fef42623          	sw	a5,-20(s0)
  if(fd < 0){
    3d5c:	fec42783          	lw	a5,-20(s0)
    3d60:	2781                	sext.w	a5,a5
    3d62:	0207d163          	bgez	a5,3d84 <subdir+0x1c4>
    printf("%s: open dd/dd/../ff failed\n", s);
    3d66:	fd843583          	ld	a1,-40(s0)
    3d6a:	00005517          	auipc	a0,0x5
    3d6e:	55650513          	addi	a0,a0,1366 # 92c0 <malloc+0x10d4>
    3d72:	00004097          	auipc	ra,0x4
    3d76:	286080e7          	jalr	646(ra) # 7ff8 <printf>
    exit(1);
    3d7a:	4505                	li	a0,1
    3d7c:	00004097          	auipc	ra,0x4
    3d80:	d50080e7          	jalr	-688(ra) # 7acc <exit>
  }
  cc = read(fd, buf, sizeof(buf));
    3d84:	fec42783          	lw	a5,-20(s0)
    3d88:	660d                	lui	a2,0x3
    3d8a:	00007597          	auipc	a1,0x7
    3d8e:	6e658593          	addi	a1,a1,1766 # b470 <buf>
    3d92:	853e                	mv	a0,a5
    3d94:	00004097          	auipc	ra,0x4
    3d98:	d50080e7          	jalr	-688(ra) # 7ae4 <read>
    3d9c:	87aa                	mv	a5,a0
    3d9e:	fef42423          	sw	a5,-24(s0)
  if(cc != 2 || buf[0] != 'f'){
    3da2:	fe842783          	lw	a5,-24(s0)
    3da6:	0007871b          	sext.w	a4,a5
    3daa:	4789                	li	a5,2
    3dac:	00f71d63          	bne	a4,a5,3dc6 <subdir+0x206>
    3db0:	00007797          	auipc	a5,0x7
    3db4:	6c078793          	addi	a5,a5,1728 # b470 <buf>
    3db8:	0007c783          	lbu	a5,0(a5)
    3dbc:	873e                	mv	a4,a5
    3dbe:	06600793          	li	a5,102
    3dc2:	02f70163          	beq	a4,a5,3de4 <subdir+0x224>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3dc6:	fd843583          	ld	a1,-40(s0)
    3dca:	00005517          	auipc	a0,0x5
    3dce:	51650513          	addi	a0,a0,1302 # 92e0 <malloc+0x10f4>
    3dd2:	00004097          	auipc	ra,0x4
    3dd6:	226080e7          	jalr	550(ra) # 7ff8 <printf>
    exit(1);
    3dda:	4505                	li	a0,1
    3ddc:	00004097          	auipc	ra,0x4
    3de0:	cf0080e7          	jalr	-784(ra) # 7acc <exit>
  }
  close(fd);
    3de4:	fec42783          	lw	a5,-20(s0)
    3de8:	853e                	mv	a0,a5
    3dea:	00004097          	auipc	ra,0x4
    3dee:	d0a080e7          	jalr	-758(ra) # 7af4 <close>

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    3df2:	00005597          	auipc	a1,0x5
    3df6:	50e58593          	addi	a1,a1,1294 # 9300 <malloc+0x1114>
    3dfa:	00005517          	auipc	a0,0x5
    3dfe:	47e50513          	addi	a0,a0,1150 # 9278 <malloc+0x108c>
    3e02:	00004097          	auipc	ra,0x4
    3e06:	d2a080e7          	jalr	-726(ra) # 7b2c <link>
    3e0a:	87aa                	mv	a5,a0
    3e0c:	c385                	beqz	a5,3e2c <subdir+0x26c>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3e0e:	fd843583          	ld	a1,-40(s0)
    3e12:	00005517          	auipc	a0,0x5
    3e16:	4fe50513          	addi	a0,a0,1278 # 9310 <malloc+0x1124>
    3e1a:	00004097          	auipc	ra,0x4
    3e1e:	1de080e7          	jalr	478(ra) # 7ff8 <printf>
    exit(1);
    3e22:	4505                	li	a0,1
    3e24:	00004097          	auipc	ra,0x4
    3e28:	ca8080e7          	jalr	-856(ra) # 7acc <exit>
  }

  if(unlink("dd/dd/ff") != 0){
    3e2c:	00005517          	auipc	a0,0x5
    3e30:	44c50513          	addi	a0,a0,1100 # 9278 <malloc+0x108c>
    3e34:	00004097          	auipc	ra,0x4
    3e38:	ce8080e7          	jalr	-792(ra) # 7b1c <unlink>
    3e3c:	87aa                	mv	a5,a0
    3e3e:	c385                	beqz	a5,3e5e <subdir+0x29e>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3e40:	fd843583          	ld	a1,-40(s0)
    3e44:	00005517          	auipc	a0,0x5
    3e48:	4f450513          	addi	a0,a0,1268 # 9338 <malloc+0x114c>
    3e4c:	00004097          	auipc	ra,0x4
    3e50:	1ac080e7          	jalr	428(ra) # 7ff8 <printf>
    exit(1);
    3e54:	4505                	li	a0,1
    3e56:	00004097          	auipc	ra,0x4
    3e5a:	c76080e7          	jalr	-906(ra) # 7acc <exit>
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3e5e:	4581                	li	a1,0
    3e60:	00005517          	auipc	a0,0x5
    3e64:	41850513          	addi	a0,a0,1048 # 9278 <malloc+0x108c>
    3e68:	00004097          	auipc	ra,0x4
    3e6c:	ca4080e7          	jalr	-860(ra) # 7b0c <open>
    3e70:	87aa                	mv	a5,a0
    3e72:	0207c163          	bltz	a5,3e94 <subdir+0x2d4>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3e76:	fd843583          	ld	a1,-40(s0)
    3e7a:	00005517          	auipc	a0,0x5
    3e7e:	4de50513          	addi	a0,a0,1246 # 9358 <malloc+0x116c>
    3e82:	00004097          	auipc	ra,0x4
    3e86:	176080e7          	jalr	374(ra) # 7ff8 <printf>
    exit(1);
    3e8a:	4505                	li	a0,1
    3e8c:	00004097          	auipc	ra,0x4
    3e90:	c40080e7          	jalr	-960(ra) # 7acc <exit>
  }

  if(chdir("dd") != 0){
    3e94:	00005517          	auipc	a0,0x5
    3e98:	34450513          	addi	a0,a0,836 # 91d8 <malloc+0xfec>
    3e9c:	00004097          	auipc	ra,0x4
    3ea0:	ca0080e7          	jalr	-864(ra) # 7b3c <chdir>
    3ea4:	87aa                	mv	a5,a0
    3ea6:	c385                	beqz	a5,3ec6 <subdir+0x306>
    printf("%s: chdir dd failed\n", s);
    3ea8:	fd843583          	ld	a1,-40(s0)
    3eac:	00005517          	auipc	a0,0x5
    3eb0:	4d450513          	addi	a0,a0,1236 # 9380 <malloc+0x1194>
    3eb4:	00004097          	auipc	ra,0x4
    3eb8:	144080e7          	jalr	324(ra) # 7ff8 <printf>
    exit(1);
    3ebc:	4505                	li	a0,1
    3ebe:	00004097          	auipc	ra,0x4
    3ec2:	c0e080e7          	jalr	-1010(ra) # 7acc <exit>
  }
  if(chdir("dd/../../dd") != 0){
    3ec6:	00005517          	auipc	a0,0x5
    3eca:	4d250513          	addi	a0,a0,1234 # 9398 <malloc+0x11ac>
    3ece:	00004097          	auipc	ra,0x4
    3ed2:	c6e080e7          	jalr	-914(ra) # 7b3c <chdir>
    3ed6:	87aa                	mv	a5,a0
    3ed8:	c385                	beqz	a5,3ef8 <subdir+0x338>
    printf("%s: chdir dd/../../dd failed\n", s);
    3eda:	fd843583          	ld	a1,-40(s0)
    3ede:	00005517          	auipc	a0,0x5
    3ee2:	4ca50513          	addi	a0,a0,1226 # 93a8 <malloc+0x11bc>
    3ee6:	00004097          	auipc	ra,0x4
    3eea:	112080e7          	jalr	274(ra) # 7ff8 <printf>
    exit(1);
    3eee:	4505                	li	a0,1
    3ef0:	00004097          	auipc	ra,0x4
    3ef4:	bdc080e7          	jalr	-1060(ra) # 7acc <exit>
  }
  if(chdir("dd/../../../dd") != 0){
    3ef8:	00005517          	auipc	a0,0x5
    3efc:	4d050513          	addi	a0,a0,1232 # 93c8 <malloc+0x11dc>
    3f00:	00004097          	auipc	ra,0x4
    3f04:	c3c080e7          	jalr	-964(ra) # 7b3c <chdir>
    3f08:	87aa                	mv	a5,a0
    3f0a:	c385                	beqz	a5,3f2a <subdir+0x36a>
    printf("chdir dd/../../dd failed\n", s);
    3f0c:	fd843583          	ld	a1,-40(s0)
    3f10:	00005517          	auipc	a0,0x5
    3f14:	4c850513          	addi	a0,a0,1224 # 93d8 <malloc+0x11ec>
    3f18:	00004097          	auipc	ra,0x4
    3f1c:	0e0080e7          	jalr	224(ra) # 7ff8 <printf>
    exit(1);
    3f20:	4505                	li	a0,1
    3f22:	00004097          	auipc	ra,0x4
    3f26:	baa080e7          	jalr	-1110(ra) # 7acc <exit>
  }
  if(chdir("./..") != 0){
    3f2a:	00005517          	auipc	a0,0x5
    3f2e:	4ce50513          	addi	a0,a0,1230 # 93f8 <malloc+0x120c>
    3f32:	00004097          	auipc	ra,0x4
    3f36:	c0a080e7          	jalr	-1014(ra) # 7b3c <chdir>
    3f3a:	87aa                	mv	a5,a0
    3f3c:	c385                	beqz	a5,3f5c <subdir+0x39c>
    printf("%s: chdir ./.. failed\n", s);
    3f3e:	fd843583          	ld	a1,-40(s0)
    3f42:	00005517          	auipc	a0,0x5
    3f46:	4be50513          	addi	a0,a0,1214 # 9400 <malloc+0x1214>
    3f4a:	00004097          	auipc	ra,0x4
    3f4e:	0ae080e7          	jalr	174(ra) # 7ff8 <printf>
    exit(1);
    3f52:	4505                	li	a0,1
    3f54:	00004097          	auipc	ra,0x4
    3f58:	b78080e7          	jalr	-1160(ra) # 7acc <exit>
  }

  fd = open("dd/dd/ffff", 0);
    3f5c:	4581                	li	a1,0
    3f5e:	00005517          	auipc	a0,0x5
    3f62:	3a250513          	addi	a0,a0,930 # 9300 <malloc+0x1114>
    3f66:	00004097          	auipc	ra,0x4
    3f6a:	ba6080e7          	jalr	-1114(ra) # 7b0c <open>
    3f6e:	87aa                	mv	a5,a0
    3f70:	fef42623          	sw	a5,-20(s0)
  if(fd < 0){
    3f74:	fec42783          	lw	a5,-20(s0)
    3f78:	2781                	sext.w	a5,a5
    3f7a:	0207d163          	bgez	a5,3f9c <subdir+0x3dc>
    printf("%s: open dd/dd/ffff failed\n", s);
    3f7e:	fd843583          	ld	a1,-40(s0)
    3f82:	00005517          	auipc	a0,0x5
    3f86:	49650513          	addi	a0,a0,1174 # 9418 <malloc+0x122c>
    3f8a:	00004097          	auipc	ra,0x4
    3f8e:	06e080e7          	jalr	110(ra) # 7ff8 <printf>
    exit(1);
    3f92:	4505                	li	a0,1
    3f94:	00004097          	auipc	ra,0x4
    3f98:	b38080e7          	jalr	-1224(ra) # 7acc <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    3f9c:	fec42783          	lw	a5,-20(s0)
    3fa0:	660d                	lui	a2,0x3
    3fa2:	00007597          	auipc	a1,0x7
    3fa6:	4ce58593          	addi	a1,a1,1230 # b470 <buf>
    3faa:	853e                	mv	a0,a5
    3fac:	00004097          	auipc	ra,0x4
    3fb0:	b38080e7          	jalr	-1224(ra) # 7ae4 <read>
    3fb4:	87aa                	mv	a5,a0
    3fb6:	873e                	mv	a4,a5
    3fb8:	4789                	li	a5,2
    3fba:	02f70163          	beq	a4,a5,3fdc <subdir+0x41c>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3fbe:	fd843583          	ld	a1,-40(s0)
    3fc2:	00005517          	auipc	a0,0x5
    3fc6:	47650513          	addi	a0,a0,1142 # 9438 <malloc+0x124c>
    3fca:	00004097          	auipc	ra,0x4
    3fce:	02e080e7          	jalr	46(ra) # 7ff8 <printf>
    exit(1);
    3fd2:	4505                	li	a0,1
    3fd4:	00004097          	auipc	ra,0x4
    3fd8:	af8080e7          	jalr	-1288(ra) # 7acc <exit>
  }
  close(fd);
    3fdc:	fec42783          	lw	a5,-20(s0)
    3fe0:	853e                	mv	a0,a5
    3fe2:	00004097          	auipc	ra,0x4
    3fe6:	b12080e7          	jalr	-1262(ra) # 7af4 <close>

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3fea:	4581                	li	a1,0
    3fec:	00005517          	auipc	a0,0x5
    3ff0:	28c50513          	addi	a0,a0,652 # 9278 <malloc+0x108c>
    3ff4:	00004097          	auipc	ra,0x4
    3ff8:	b18080e7          	jalr	-1256(ra) # 7b0c <open>
    3ffc:	87aa                	mv	a5,a0
    3ffe:	0207c163          	bltz	a5,4020 <subdir+0x460>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    4002:	fd843583          	ld	a1,-40(s0)
    4006:	00005517          	auipc	a0,0x5
    400a:	45250513          	addi	a0,a0,1106 # 9458 <malloc+0x126c>
    400e:	00004097          	auipc	ra,0x4
    4012:	fea080e7          	jalr	-22(ra) # 7ff8 <printf>
    exit(1);
    4016:	4505                	li	a0,1
    4018:	00004097          	auipc	ra,0x4
    401c:	ab4080e7          	jalr	-1356(ra) # 7acc <exit>
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    4020:	20200593          	li	a1,514
    4024:	00005517          	auipc	a0,0x5
    4028:	46450513          	addi	a0,a0,1124 # 9488 <malloc+0x129c>
    402c:	00004097          	auipc	ra,0x4
    4030:	ae0080e7          	jalr	-1312(ra) # 7b0c <open>
    4034:	87aa                	mv	a5,a0
    4036:	0207c163          	bltz	a5,4058 <subdir+0x498>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    403a:	fd843583          	ld	a1,-40(s0)
    403e:	00005517          	auipc	a0,0x5
    4042:	45a50513          	addi	a0,a0,1114 # 9498 <malloc+0x12ac>
    4046:	00004097          	auipc	ra,0x4
    404a:	fb2080e7          	jalr	-78(ra) # 7ff8 <printf>
    exit(1);
    404e:	4505                	li	a0,1
    4050:	00004097          	auipc	ra,0x4
    4054:	a7c080e7          	jalr	-1412(ra) # 7acc <exit>
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    4058:	20200593          	li	a1,514
    405c:	00005517          	auipc	a0,0x5
    4060:	45c50513          	addi	a0,a0,1116 # 94b8 <malloc+0x12cc>
    4064:	00004097          	auipc	ra,0x4
    4068:	aa8080e7          	jalr	-1368(ra) # 7b0c <open>
    406c:	87aa                	mv	a5,a0
    406e:	0207c163          	bltz	a5,4090 <subdir+0x4d0>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    4072:	fd843583          	ld	a1,-40(s0)
    4076:	00005517          	auipc	a0,0x5
    407a:	45250513          	addi	a0,a0,1106 # 94c8 <malloc+0x12dc>
    407e:	00004097          	auipc	ra,0x4
    4082:	f7a080e7          	jalr	-134(ra) # 7ff8 <printf>
    exit(1);
    4086:	4505                	li	a0,1
    4088:	00004097          	auipc	ra,0x4
    408c:	a44080e7          	jalr	-1468(ra) # 7acc <exit>
  }
  if(open("dd", O_CREATE) >= 0){
    4090:	20000593          	li	a1,512
    4094:	00005517          	auipc	a0,0x5
    4098:	14450513          	addi	a0,a0,324 # 91d8 <malloc+0xfec>
    409c:	00004097          	auipc	ra,0x4
    40a0:	a70080e7          	jalr	-1424(ra) # 7b0c <open>
    40a4:	87aa                	mv	a5,a0
    40a6:	0207c163          	bltz	a5,40c8 <subdir+0x508>
    printf("%s: create dd succeeded!\n", s);
    40aa:	fd843583          	ld	a1,-40(s0)
    40ae:	00005517          	auipc	a0,0x5
    40b2:	43a50513          	addi	a0,a0,1082 # 94e8 <malloc+0x12fc>
    40b6:	00004097          	auipc	ra,0x4
    40ba:	f42080e7          	jalr	-190(ra) # 7ff8 <printf>
    exit(1);
    40be:	4505                	li	a0,1
    40c0:	00004097          	auipc	ra,0x4
    40c4:	a0c080e7          	jalr	-1524(ra) # 7acc <exit>
  }
  if(open("dd", O_RDWR) >= 0){
    40c8:	4589                	li	a1,2
    40ca:	00005517          	auipc	a0,0x5
    40ce:	10e50513          	addi	a0,a0,270 # 91d8 <malloc+0xfec>
    40d2:	00004097          	auipc	ra,0x4
    40d6:	a3a080e7          	jalr	-1478(ra) # 7b0c <open>
    40da:	87aa                	mv	a5,a0
    40dc:	0207c163          	bltz	a5,40fe <subdir+0x53e>
    printf("%s: open dd rdwr succeeded!\n", s);
    40e0:	fd843583          	ld	a1,-40(s0)
    40e4:	00005517          	auipc	a0,0x5
    40e8:	42450513          	addi	a0,a0,1060 # 9508 <malloc+0x131c>
    40ec:	00004097          	auipc	ra,0x4
    40f0:	f0c080e7          	jalr	-244(ra) # 7ff8 <printf>
    exit(1);
    40f4:	4505                	li	a0,1
    40f6:	00004097          	auipc	ra,0x4
    40fa:	9d6080e7          	jalr	-1578(ra) # 7acc <exit>
  }
  if(open("dd", O_WRONLY) >= 0){
    40fe:	4585                	li	a1,1
    4100:	00005517          	auipc	a0,0x5
    4104:	0d850513          	addi	a0,a0,216 # 91d8 <malloc+0xfec>
    4108:	00004097          	auipc	ra,0x4
    410c:	a04080e7          	jalr	-1532(ra) # 7b0c <open>
    4110:	87aa                	mv	a5,a0
    4112:	0207c163          	bltz	a5,4134 <subdir+0x574>
    printf("%s: open dd wronly succeeded!\n", s);
    4116:	fd843583          	ld	a1,-40(s0)
    411a:	00005517          	auipc	a0,0x5
    411e:	40e50513          	addi	a0,a0,1038 # 9528 <malloc+0x133c>
    4122:	00004097          	auipc	ra,0x4
    4126:	ed6080e7          	jalr	-298(ra) # 7ff8 <printf>
    exit(1);
    412a:	4505                	li	a0,1
    412c:	00004097          	auipc	ra,0x4
    4130:	9a0080e7          	jalr	-1632(ra) # 7acc <exit>
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    4134:	00005597          	auipc	a1,0x5
    4138:	41458593          	addi	a1,a1,1044 # 9548 <malloc+0x135c>
    413c:	00005517          	auipc	a0,0x5
    4140:	34c50513          	addi	a0,a0,844 # 9488 <malloc+0x129c>
    4144:	00004097          	auipc	ra,0x4
    4148:	9e8080e7          	jalr	-1560(ra) # 7b2c <link>
    414c:	87aa                	mv	a5,a0
    414e:	e385                	bnez	a5,416e <subdir+0x5ae>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    4150:	fd843583          	ld	a1,-40(s0)
    4154:	00005517          	auipc	a0,0x5
    4158:	40450513          	addi	a0,a0,1028 # 9558 <malloc+0x136c>
    415c:	00004097          	auipc	ra,0x4
    4160:	e9c080e7          	jalr	-356(ra) # 7ff8 <printf>
    exit(1);
    4164:	4505                	li	a0,1
    4166:	00004097          	auipc	ra,0x4
    416a:	966080e7          	jalr	-1690(ra) # 7acc <exit>
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    416e:	00005597          	auipc	a1,0x5
    4172:	3da58593          	addi	a1,a1,986 # 9548 <malloc+0x135c>
    4176:	00005517          	auipc	a0,0x5
    417a:	34250513          	addi	a0,a0,834 # 94b8 <malloc+0x12cc>
    417e:	00004097          	auipc	ra,0x4
    4182:	9ae080e7          	jalr	-1618(ra) # 7b2c <link>
    4186:	87aa                	mv	a5,a0
    4188:	e385                	bnez	a5,41a8 <subdir+0x5e8>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    418a:	fd843583          	ld	a1,-40(s0)
    418e:	00005517          	auipc	a0,0x5
    4192:	3f250513          	addi	a0,a0,1010 # 9580 <malloc+0x1394>
    4196:	00004097          	auipc	ra,0x4
    419a:	e62080e7          	jalr	-414(ra) # 7ff8 <printf>
    exit(1);
    419e:	4505                	li	a0,1
    41a0:	00004097          	auipc	ra,0x4
    41a4:	92c080e7          	jalr	-1748(ra) # 7acc <exit>
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    41a8:	00005597          	auipc	a1,0x5
    41ac:	15858593          	addi	a1,a1,344 # 9300 <malloc+0x1114>
    41b0:	00005517          	auipc	a0,0x5
    41b4:	04850513          	addi	a0,a0,72 # 91f8 <malloc+0x100c>
    41b8:	00004097          	auipc	ra,0x4
    41bc:	974080e7          	jalr	-1676(ra) # 7b2c <link>
    41c0:	87aa                	mv	a5,a0
    41c2:	e385                	bnez	a5,41e2 <subdir+0x622>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    41c4:	fd843583          	ld	a1,-40(s0)
    41c8:	00005517          	auipc	a0,0x5
    41cc:	3e050513          	addi	a0,a0,992 # 95a8 <malloc+0x13bc>
    41d0:	00004097          	auipc	ra,0x4
    41d4:	e28080e7          	jalr	-472(ra) # 7ff8 <printf>
    exit(1);
    41d8:	4505                	li	a0,1
    41da:	00004097          	auipc	ra,0x4
    41de:	8f2080e7          	jalr	-1806(ra) # 7acc <exit>
  }
  if(mkdir("dd/ff/ff") == 0){
    41e2:	00005517          	auipc	a0,0x5
    41e6:	2a650513          	addi	a0,a0,678 # 9488 <malloc+0x129c>
    41ea:	00004097          	auipc	ra,0x4
    41ee:	94a080e7          	jalr	-1718(ra) # 7b34 <mkdir>
    41f2:	87aa                	mv	a5,a0
    41f4:	e385                	bnez	a5,4214 <subdir+0x654>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    41f6:	fd843583          	ld	a1,-40(s0)
    41fa:	00005517          	auipc	a0,0x5
    41fe:	3d650513          	addi	a0,a0,982 # 95d0 <malloc+0x13e4>
    4202:	00004097          	auipc	ra,0x4
    4206:	df6080e7          	jalr	-522(ra) # 7ff8 <printf>
    exit(1);
    420a:	4505                	li	a0,1
    420c:	00004097          	auipc	ra,0x4
    4210:	8c0080e7          	jalr	-1856(ra) # 7acc <exit>
  }
  if(mkdir("dd/xx/ff") == 0){
    4214:	00005517          	auipc	a0,0x5
    4218:	2a450513          	addi	a0,a0,676 # 94b8 <malloc+0x12cc>
    421c:	00004097          	auipc	ra,0x4
    4220:	918080e7          	jalr	-1768(ra) # 7b34 <mkdir>
    4224:	87aa                	mv	a5,a0
    4226:	e385                	bnez	a5,4246 <subdir+0x686>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    4228:	fd843583          	ld	a1,-40(s0)
    422c:	00005517          	auipc	a0,0x5
    4230:	3c450513          	addi	a0,a0,964 # 95f0 <malloc+0x1404>
    4234:	00004097          	auipc	ra,0x4
    4238:	dc4080e7          	jalr	-572(ra) # 7ff8 <printf>
    exit(1);
    423c:	4505                	li	a0,1
    423e:	00004097          	auipc	ra,0x4
    4242:	88e080e7          	jalr	-1906(ra) # 7acc <exit>
  }
  if(mkdir("dd/dd/ffff") == 0){
    4246:	00005517          	auipc	a0,0x5
    424a:	0ba50513          	addi	a0,a0,186 # 9300 <malloc+0x1114>
    424e:	00004097          	auipc	ra,0x4
    4252:	8e6080e7          	jalr	-1818(ra) # 7b34 <mkdir>
    4256:	87aa                	mv	a5,a0
    4258:	e385                	bnez	a5,4278 <subdir+0x6b8>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    425a:	fd843583          	ld	a1,-40(s0)
    425e:	00005517          	auipc	a0,0x5
    4262:	3b250513          	addi	a0,a0,946 # 9610 <malloc+0x1424>
    4266:	00004097          	auipc	ra,0x4
    426a:	d92080e7          	jalr	-622(ra) # 7ff8 <printf>
    exit(1);
    426e:	4505                	li	a0,1
    4270:	00004097          	auipc	ra,0x4
    4274:	85c080e7          	jalr	-1956(ra) # 7acc <exit>
  }
  if(unlink("dd/xx/ff") == 0){
    4278:	00005517          	auipc	a0,0x5
    427c:	24050513          	addi	a0,a0,576 # 94b8 <malloc+0x12cc>
    4280:	00004097          	auipc	ra,0x4
    4284:	89c080e7          	jalr	-1892(ra) # 7b1c <unlink>
    4288:	87aa                	mv	a5,a0
    428a:	e385                	bnez	a5,42aa <subdir+0x6ea>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    428c:	fd843583          	ld	a1,-40(s0)
    4290:	00005517          	auipc	a0,0x5
    4294:	3a850513          	addi	a0,a0,936 # 9638 <malloc+0x144c>
    4298:	00004097          	auipc	ra,0x4
    429c:	d60080e7          	jalr	-672(ra) # 7ff8 <printf>
    exit(1);
    42a0:	4505                	li	a0,1
    42a2:	00004097          	auipc	ra,0x4
    42a6:	82a080e7          	jalr	-2006(ra) # 7acc <exit>
  }
  if(unlink("dd/ff/ff") == 0){
    42aa:	00005517          	auipc	a0,0x5
    42ae:	1de50513          	addi	a0,a0,478 # 9488 <malloc+0x129c>
    42b2:	00004097          	auipc	ra,0x4
    42b6:	86a080e7          	jalr	-1942(ra) # 7b1c <unlink>
    42ba:	87aa                	mv	a5,a0
    42bc:	e385                	bnez	a5,42dc <subdir+0x71c>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    42be:	fd843583          	ld	a1,-40(s0)
    42c2:	00005517          	auipc	a0,0x5
    42c6:	39650513          	addi	a0,a0,918 # 9658 <malloc+0x146c>
    42ca:	00004097          	auipc	ra,0x4
    42ce:	d2e080e7          	jalr	-722(ra) # 7ff8 <printf>
    exit(1);
    42d2:	4505                	li	a0,1
    42d4:	00003097          	auipc	ra,0x3
    42d8:	7f8080e7          	jalr	2040(ra) # 7acc <exit>
  }
  if(chdir("dd/ff") == 0){
    42dc:	00005517          	auipc	a0,0x5
    42e0:	f1c50513          	addi	a0,a0,-228 # 91f8 <malloc+0x100c>
    42e4:	00004097          	auipc	ra,0x4
    42e8:	858080e7          	jalr	-1960(ra) # 7b3c <chdir>
    42ec:	87aa                	mv	a5,a0
    42ee:	e385                	bnez	a5,430e <subdir+0x74e>
    printf("%s: chdir dd/ff succeeded!\n", s);
    42f0:	fd843583          	ld	a1,-40(s0)
    42f4:	00005517          	auipc	a0,0x5
    42f8:	38450513          	addi	a0,a0,900 # 9678 <malloc+0x148c>
    42fc:	00004097          	auipc	ra,0x4
    4300:	cfc080e7          	jalr	-772(ra) # 7ff8 <printf>
    exit(1);
    4304:	4505                	li	a0,1
    4306:	00003097          	auipc	ra,0x3
    430a:	7c6080e7          	jalr	1990(ra) # 7acc <exit>
  }
  if(chdir("dd/xx") == 0){
    430e:	00005517          	auipc	a0,0x5
    4312:	38a50513          	addi	a0,a0,906 # 9698 <malloc+0x14ac>
    4316:	00004097          	auipc	ra,0x4
    431a:	826080e7          	jalr	-2010(ra) # 7b3c <chdir>
    431e:	87aa                	mv	a5,a0
    4320:	e385                	bnez	a5,4340 <subdir+0x780>
    printf("%s: chdir dd/xx succeeded!\n", s);
    4322:	fd843583          	ld	a1,-40(s0)
    4326:	00005517          	auipc	a0,0x5
    432a:	37a50513          	addi	a0,a0,890 # 96a0 <malloc+0x14b4>
    432e:	00004097          	auipc	ra,0x4
    4332:	cca080e7          	jalr	-822(ra) # 7ff8 <printf>
    exit(1);
    4336:	4505                	li	a0,1
    4338:	00003097          	auipc	ra,0x3
    433c:	794080e7          	jalr	1940(ra) # 7acc <exit>
  }

  if(unlink("dd/dd/ffff") != 0){
    4340:	00005517          	auipc	a0,0x5
    4344:	fc050513          	addi	a0,a0,-64 # 9300 <malloc+0x1114>
    4348:	00003097          	auipc	ra,0x3
    434c:	7d4080e7          	jalr	2004(ra) # 7b1c <unlink>
    4350:	87aa                	mv	a5,a0
    4352:	c385                	beqz	a5,4372 <subdir+0x7b2>
    printf("%s: unlink dd/dd/ff failed\n", s);
    4354:	fd843583          	ld	a1,-40(s0)
    4358:	00005517          	auipc	a0,0x5
    435c:	fe050513          	addi	a0,a0,-32 # 9338 <malloc+0x114c>
    4360:	00004097          	auipc	ra,0x4
    4364:	c98080e7          	jalr	-872(ra) # 7ff8 <printf>
    exit(1);
    4368:	4505                	li	a0,1
    436a:	00003097          	auipc	ra,0x3
    436e:	762080e7          	jalr	1890(ra) # 7acc <exit>
  }
  if(unlink("dd/ff") != 0){
    4372:	00005517          	auipc	a0,0x5
    4376:	e8650513          	addi	a0,a0,-378 # 91f8 <malloc+0x100c>
    437a:	00003097          	auipc	ra,0x3
    437e:	7a2080e7          	jalr	1954(ra) # 7b1c <unlink>
    4382:	87aa                	mv	a5,a0
    4384:	c385                	beqz	a5,43a4 <subdir+0x7e4>
    printf("%s: unlink dd/ff failed\n", s);
    4386:	fd843583          	ld	a1,-40(s0)
    438a:	00005517          	auipc	a0,0x5
    438e:	33650513          	addi	a0,a0,822 # 96c0 <malloc+0x14d4>
    4392:	00004097          	auipc	ra,0x4
    4396:	c66080e7          	jalr	-922(ra) # 7ff8 <printf>
    exit(1);
    439a:	4505                	li	a0,1
    439c:	00003097          	auipc	ra,0x3
    43a0:	730080e7          	jalr	1840(ra) # 7acc <exit>
  }
  if(unlink("dd") == 0){
    43a4:	00005517          	auipc	a0,0x5
    43a8:	e3450513          	addi	a0,a0,-460 # 91d8 <malloc+0xfec>
    43ac:	00003097          	auipc	ra,0x3
    43b0:	770080e7          	jalr	1904(ra) # 7b1c <unlink>
    43b4:	87aa                	mv	a5,a0
    43b6:	e385                	bnez	a5,43d6 <subdir+0x816>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    43b8:	fd843583          	ld	a1,-40(s0)
    43bc:	00005517          	auipc	a0,0x5
    43c0:	32450513          	addi	a0,a0,804 # 96e0 <malloc+0x14f4>
    43c4:	00004097          	auipc	ra,0x4
    43c8:	c34080e7          	jalr	-972(ra) # 7ff8 <printf>
    exit(1);
    43cc:	4505                	li	a0,1
    43ce:	00003097          	auipc	ra,0x3
    43d2:	6fe080e7          	jalr	1790(ra) # 7acc <exit>
  }
  if(unlink("dd/dd") < 0){
    43d6:	00005517          	auipc	a0,0x5
    43da:	33250513          	addi	a0,a0,818 # 9708 <malloc+0x151c>
    43de:	00003097          	auipc	ra,0x3
    43e2:	73e080e7          	jalr	1854(ra) # 7b1c <unlink>
    43e6:	87aa                	mv	a5,a0
    43e8:	0207d163          	bgez	a5,440a <subdir+0x84a>
    printf("%s: unlink dd/dd failed\n", s);
    43ec:	fd843583          	ld	a1,-40(s0)
    43f0:	00005517          	auipc	a0,0x5
    43f4:	32050513          	addi	a0,a0,800 # 9710 <malloc+0x1524>
    43f8:	00004097          	auipc	ra,0x4
    43fc:	c00080e7          	jalr	-1024(ra) # 7ff8 <printf>
    exit(1);
    4400:	4505                	li	a0,1
    4402:	00003097          	auipc	ra,0x3
    4406:	6ca080e7          	jalr	1738(ra) # 7acc <exit>
  }
  if(unlink("dd") < 0){
    440a:	00005517          	auipc	a0,0x5
    440e:	dce50513          	addi	a0,a0,-562 # 91d8 <malloc+0xfec>
    4412:	00003097          	auipc	ra,0x3
    4416:	70a080e7          	jalr	1802(ra) # 7b1c <unlink>
    441a:	87aa                	mv	a5,a0
    441c:	0207d163          	bgez	a5,443e <subdir+0x87e>
    printf("%s: unlink dd failed\n", s);
    4420:	fd843583          	ld	a1,-40(s0)
    4424:	00005517          	auipc	a0,0x5
    4428:	30c50513          	addi	a0,a0,780 # 9730 <malloc+0x1544>
    442c:	00004097          	auipc	ra,0x4
    4430:	bcc080e7          	jalr	-1076(ra) # 7ff8 <printf>
    exit(1);
    4434:	4505                	li	a0,1
    4436:	00003097          	auipc	ra,0x3
    443a:	696080e7          	jalr	1686(ra) # 7acc <exit>
  }
}
    443e:	0001                	nop
    4440:	70a2                	ld	ra,40(sp)
    4442:	7402                	ld	s0,32(sp)
    4444:	6145                	addi	sp,sp,48
    4446:	8082                	ret

0000000000004448 <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(char *s)
{
    4448:	7179                	addi	sp,sp,-48
    444a:	f406                	sd	ra,40(sp)
    444c:	f022                	sd	s0,32(sp)
    444e:	1800                	addi	s0,sp,48
    4450:	fca43c23          	sd	a0,-40(s0)
  int fd, sz;

  unlink("bigwrite");
    4454:	00005517          	auipc	a0,0x5
    4458:	2f450513          	addi	a0,a0,756 # 9748 <malloc+0x155c>
    445c:	00003097          	auipc	ra,0x3
    4460:	6c0080e7          	jalr	1728(ra) # 7b1c <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
    4464:	1f300793          	li	a5,499
    4468:	fef42623          	sw	a5,-20(s0)
    446c:	a0ed                	j	4556 <bigwrite+0x10e>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    446e:	20200593          	li	a1,514
    4472:	00005517          	auipc	a0,0x5
    4476:	2d650513          	addi	a0,a0,726 # 9748 <malloc+0x155c>
    447a:	00003097          	auipc	ra,0x3
    447e:	692080e7          	jalr	1682(ra) # 7b0c <open>
    4482:	87aa                	mv	a5,a0
    4484:	fef42223          	sw	a5,-28(s0)
    if(fd < 0){
    4488:	fe442783          	lw	a5,-28(s0)
    448c:	2781                	sext.w	a5,a5
    448e:	0207d163          	bgez	a5,44b0 <bigwrite+0x68>
      printf("%s: cannot create bigwrite\n", s);
    4492:	fd843583          	ld	a1,-40(s0)
    4496:	00005517          	auipc	a0,0x5
    449a:	2c250513          	addi	a0,a0,706 # 9758 <malloc+0x156c>
    449e:	00004097          	auipc	ra,0x4
    44a2:	b5a080e7          	jalr	-1190(ra) # 7ff8 <printf>
      exit(1);
    44a6:	4505                	li	a0,1
    44a8:	00003097          	auipc	ra,0x3
    44ac:	624080e7          	jalr	1572(ra) # 7acc <exit>
    }
    int i;
    for(i = 0; i < 2; i++){
    44b0:	fe042423          	sw	zero,-24(s0)
    44b4:	a0ad                	j	451e <bigwrite+0xd6>
      int cc = write(fd, buf, sz);
    44b6:	fec42703          	lw	a4,-20(s0)
    44ba:	fe442783          	lw	a5,-28(s0)
    44be:	863a                	mv	a2,a4
    44c0:	00007597          	auipc	a1,0x7
    44c4:	fb058593          	addi	a1,a1,-80 # b470 <buf>
    44c8:	853e                	mv	a0,a5
    44ca:	00003097          	auipc	ra,0x3
    44ce:	622080e7          	jalr	1570(ra) # 7aec <write>
    44d2:	87aa                	mv	a5,a0
    44d4:	fef42023          	sw	a5,-32(s0)
      if(cc != sz){
    44d8:	fe042783          	lw	a5,-32(s0)
    44dc:	873e                	mv	a4,a5
    44de:	fec42783          	lw	a5,-20(s0)
    44e2:	2701                	sext.w	a4,a4
    44e4:	2781                	sext.w	a5,a5
    44e6:	02f70763          	beq	a4,a5,4514 <bigwrite+0xcc>
        printf("%s: write(%d) ret %d\n", s, sz, cc);
    44ea:	fe042703          	lw	a4,-32(s0)
    44ee:	fec42783          	lw	a5,-20(s0)
    44f2:	86ba                	mv	a3,a4
    44f4:	863e                	mv	a2,a5
    44f6:	fd843583          	ld	a1,-40(s0)
    44fa:	00005517          	auipc	a0,0x5
    44fe:	27e50513          	addi	a0,a0,638 # 9778 <malloc+0x158c>
    4502:	00004097          	auipc	ra,0x4
    4506:	af6080e7          	jalr	-1290(ra) # 7ff8 <printf>
        exit(1);
    450a:	4505                	li	a0,1
    450c:	00003097          	auipc	ra,0x3
    4510:	5c0080e7          	jalr	1472(ra) # 7acc <exit>
    for(i = 0; i < 2; i++){
    4514:	fe842783          	lw	a5,-24(s0)
    4518:	2785                	addiw	a5,a5,1
    451a:	fef42423          	sw	a5,-24(s0)
    451e:	fe842783          	lw	a5,-24(s0)
    4522:	0007871b          	sext.w	a4,a5
    4526:	4785                	li	a5,1
    4528:	f8e7d7e3          	bge	a5,a4,44b6 <bigwrite+0x6e>
      }
    }
    close(fd);
    452c:	fe442783          	lw	a5,-28(s0)
    4530:	853e                	mv	a0,a5
    4532:	00003097          	auipc	ra,0x3
    4536:	5c2080e7          	jalr	1474(ra) # 7af4 <close>
    unlink("bigwrite");
    453a:	00005517          	auipc	a0,0x5
    453e:	20e50513          	addi	a0,a0,526 # 9748 <malloc+0x155c>
    4542:	00003097          	auipc	ra,0x3
    4546:	5da080e7          	jalr	1498(ra) # 7b1c <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
    454a:	fec42783          	lw	a5,-20(s0)
    454e:	1d77879b          	addiw	a5,a5,471
    4552:	fef42623          	sw	a5,-20(s0)
    4556:	fec42783          	lw	a5,-20(s0)
    455a:	0007871b          	sext.w	a4,a5
    455e:	678d                	lui	a5,0x3
    4560:	f0f747e3          	blt	a4,a5,446e <bigwrite+0x26>
  }
}
    4564:	0001                	nop
    4566:	0001                	nop
    4568:	70a2                	ld	ra,40(sp)
    456a:	7402                	ld	s0,32(sp)
    456c:	6145                	addi	sp,sp,48
    456e:	8082                	ret

0000000000004570 <bigfile>:


void
bigfile(char *s)
{
    4570:	7179                	addi	sp,sp,-48
    4572:	f406                	sd	ra,40(sp)
    4574:	f022                	sd	s0,32(sp)
    4576:	1800                	addi	s0,sp,48
    4578:	fca43c23          	sd	a0,-40(s0)
  enum { N = 20, SZ=600 };
  int fd, i, total, cc;

  unlink("bigfile.dat");
    457c:	00005517          	auipc	a0,0x5
    4580:	21450513          	addi	a0,a0,532 # 9790 <malloc+0x15a4>
    4584:	00003097          	auipc	ra,0x3
    4588:	598080e7          	jalr	1432(ra) # 7b1c <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    458c:	20200593          	li	a1,514
    4590:	00005517          	auipc	a0,0x5
    4594:	20050513          	addi	a0,a0,512 # 9790 <malloc+0x15a4>
    4598:	00003097          	auipc	ra,0x3
    459c:	574080e7          	jalr	1396(ra) # 7b0c <open>
    45a0:	87aa                	mv	a5,a0
    45a2:	fef42223          	sw	a5,-28(s0)
  if(fd < 0){
    45a6:	fe442783          	lw	a5,-28(s0)
    45aa:	2781                	sext.w	a5,a5
    45ac:	0207d163          	bgez	a5,45ce <bigfile+0x5e>
    printf("%s: cannot create bigfile", s);
    45b0:	fd843583          	ld	a1,-40(s0)
    45b4:	00005517          	auipc	a0,0x5
    45b8:	1ec50513          	addi	a0,a0,492 # 97a0 <malloc+0x15b4>
    45bc:	00004097          	auipc	ra,0x4
    45c0:	a3c080e7          	jalr	-1476(ra) # 7ff8 <printf>
    exit(1);
    45c4:	4505                	li	a0,1
    45c6:	00003097          	auipc	ra,0x3
    45ca:	506080e7          	jalr	1286(ra) # 7acc <exit>
  }
  for(i = 0; i < N; i++){
    45ce:	fe042623          	sw	zero,-20(s0)
    45d2:	a0ad                	j	463c <bigfile+0xcc>
    memset(buf, i, SZ);
    45d4:	fec42783          	lw	a5,-20(s0)
    45d8:	25800613          	li	a2,600
    45dc:	85be                	mv	a1,a5
    45de:	00007517          	auipc	a0,0x7
    45e2:	e9250513          	addi	a0,a0,-366 # b470 <buf>
    45e6:	00003097          	auipc	ra,0x3
    45ea:	128080e7          	jalr	296(ra) # 770e <memset>
    if(write(fd, buf, SZ) != SZ){
    45ee:	fe442783          	lw	a5,-28(s0)
    45f2:	25800613          	li	a2,600
    45f6:	00007597          	auipc	a1,0x7
    45fa:	e7a58593          	addi	a1,a1,-390 # b470 <buf>
    45fe:	853e                	mv	a0,a5
    4600:	00003097          	auipc	ra,0x3
    4604:	4ec080e7          	jalr	1260(ra) # 7aec <write>
    4608:	87aa                	mv	a5,a0
    460a:	873e                	mv	a4,a5
    460c:	25800793          	li	a5,600
    4610:	02f70163          	beq	a4,a5,4632 <bigfile+0xc2>
      printf("%s: write bigfile failed\n", s);
    4614:	fd843583          	ld	a1,-40(s0)
    4618:	00005517          	auipc	a0,0x5
    461c:	1a850513          	addi	a0,a0,424 # 97c0 <malloc+0x15d4>
    4620:	00004097          	auipc	ra,0x4
    4624:	9d8080e7          	jalr	-1576(ra) # 7ff8 <printf>
      exit(1);
    4628:	4505                	li	a0,1
    462a:	00003097          	auipc	ra,0x3
    462e:	4a2080e7          	jalr	1186(ra) # 7acc <exit>
  for(i = 0; i < N; i++){
    4632:	fec42783          	lw	a5,-20(s0)
    4636:	2785                	addiw	a5,a5,1 # 3001 <createdelete+0x28d>
    4638:	fef42623          	sw	a5,-20(s0)
    463c:	fec42783          	lw	a5,-20(s0)
    4640:	0007871b          	sext.w	a4,a5
    4644:	47cd                	li	a5,19
    4646:	f8e7d7e3          	bge	a5,a4,45d4 <bigfile+0x64>
    }
  }
  close(fd);
    464a:	fe442783          	lw	a5,-28(s0)
    464e:	853e                	mv	a0,a5
    4650:	00003097          	auipc	ra,0x3
    4654:	4a4080e7          	jalr	1188(ra) # 7af4 <close>

  fd = open("bigfile.dat", 0);
    4658:	4581                	li	a1,0
    465a:	00005517          	auipc	a0,0x5
    465e:	13650513          	addi	a0,a0,310 # 9790 <malloc+0x15a4>
    4662:	00003097          	auipc	ra,0x3
    4666:	4aa080e7          	jalr	1194(ra) # 7b0c <open>
    466a:	87aa                	mv	a5,a0
    466c:	fef42223          	sw	a5,-28(s0)
  if(fd < 0){
    4670:	fe442783          	lw	a5,-28(s0)
    4674:	2781                	sext.w	a5,a5
    4676:	0207d163          	bgez	a5,4698 <bigfile+0x128>
    printf("%s: cannot open bigfile\n", s);
    467a:	fd843583          	ld	a1,-40(s0)
    467e:	00005517          	auipc	a0,0x5
    4682:	16250513          	addi	a0,a0,354 # 97e0 <malloc+0x15f4>
    4686:	00004097          	auipc	ra,0x4
    468a:	972080e7          	jalr	-1678(ra) # 7ff8 <printf>
    exit(1);
    468e:	4505                	li	a0,1
    4690:	00003097          	auipc	ra,0x3
    4694:	43c080e7          	jalr	1084(ra) # 7acc <exit>
  }
  total = 0;
    4698:	fe042423          	sw	zero,-24(s0)
  for(i = 0; ; i++){
    469c:	fe042623          	sw	zero,-20(s0)
    cc = read(fd, buf, SZ/2);
    46a0:	fe442783          	lw	a5,-28(s0)
    46a4:	12c00613          	li	a2,300
    46a8:	00007597          	auipc	a1,0x7
    46ac:	dc858593          	addi	a1,a1,-568 # b470 <buf>
    46b0:	853e                	mv	a0,a5
    46b2:	00003097          	auipc	ra,0x3
    46b6:	432080e7          	jalr	1074(ra) # 7ae4 <read>
    46ba:	87aa                	mv	a5,a0
    46bc:	fef42023          	sw	a5,-32(s0)
    if(cc < 0){
    46c0:	fe042783          	lw	a5,-32(s0)
    46c4:	2781                	sext.w	a5,a5
    46c6:	0207d163          	bgez	a5,46e8 <bigfile+0x178>
      printf("%s: read bigfile failed\n", s);
    46ca:	fd843583          	ld	a1,-40(s0)
    46ce:	00005517          	auipc	a0,0x5
    46d2:	13250513          	addi	a0,a0,306 # 9800 <malloc+0x1614>
    46d6:	00004097          	auipc	ra,0x4
    46da:	922080e7          	jalr	-1758(ra) # 7ff8 <printf>
      exit(1);
    46de:	4505                	li	a0,1
    46e0:	00003097          	auipc	ra,0x3
    46e4:	3ec080e7          	jalr	1004(ra) # 7acc <exit>
    }
    if(cc == 0)
    46e8:	fe042783          	lw	a5,-32(s0)
    46ec:	2781                	sext.w	a5,a5
    46ee:	cbcd                	beqz	a5,47a0 <bigfile+0x230>
      break;
    if(cc != SZ/2){
    46f0:	fe042783          	lw	a5,-32(s0)
    46f4:	0007871b          	sext.w	a4,a5
    46f8:	12c00793          	li	a5,300
    46fc:	02f70163          	beq	a4,a5,471e <bigfile+0x1ae>
      printf("%s: short read bigfile\n", s);
    4700:	fd843583          	ld	a1,-40(s0)
    4704:	00005517          	auipc	a0,0x5
    4708:	11c50513          	addi	a0,a0,284 # 9820 <malloc+0x1634>
    470c:	00004097          	auipc	ra,0x4
    4710:	8ec080e7          	jalr	-1812(ra) # 7ff8 <printf>
      exit(1);
    4714:	4505                	li	a0,1
    4716:	00003097          	auipc	ra,0x3
    471a:	3b6080e7          	jalr	950(ra) # 7acc <exit>
    }
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    471e:	00007797          	auipc	a5,0x7
    4722:	d5278793          	addi	a5,a5,-686 # b470 <buf>
    4726:	0007c783          	lbu	a5,0(a5)
    472a:	0007871b          	sext.w	a4,a5
    472e:	fec42783          	lw	a5,-20(s0)
    4732:	01f7d69b          	srliw	a3,a5,0x1f
    4736:	9fb5                	addw	a5,a5,a3
    4738:	4017d79b          	sraiw	a5,a5,0x1
    473c:	2781                	sext.w	a5,a5
    473e:	02f71463          	bne	a4,a5,4766 <bigfile+0x1f6>
    4742:	00007797          	auipc	a5,0x7
    4746:	d2e78793          	addi	a5,a5,-722 # b470 <buf>
    474a:	12b7c783          	lbu	a5,299(a5)
    474e:	0007871b          	sext.w	a4,a5
    4752:	fec42783          	lw	a5,-20(s0)
    4756:	01f7d69b          	srliw	a3,a5,0x1f
    475a:	9fb5                	addw	a5,a5,a3
    475c:	4017d79b          	sraiw	a5,a5,0x1
    4760:	2781                	sext.w	a5,a5
    4762:	02f70163          	beq	a4,a5,4784 <bigfile+0x214>
      printf("%s: read bigfile wrong data\n", s);
    4766:	fd843583          	ld	a1,-40(s0)
    476a:	00005517          	auipc	a0,0x5
    476e:	0ce50513          	addi	a0,a0,206 # 9838 <malloc+0x164c>
    4772:	00004097          	auipc	ra,0x4
    4776:	886080e7          	jalr	-1914(ra) # 7ff8 <printf>
      exit(1);
    477a:	4505                	li	a0,1
    477c:	00003097          	auipc	ra,0x3
    4780:	350080e7          	jalr	848(ra) # 7acc <exit>
    }
    total += cc;
    4784:	fe842783          	lw	a5,-24(s0)
    4788:	873e                	mv	a4,a5
    478a:	fe042783          	lw	a5,-32(s0)
    478e:	9fb9                	addw	a5,a5,a4
    4790:	fef42423          	sw	a5,-24(s0)
  for(i = 0; ; i++){
    4794:	fec42783          	lw	a5,-20(s0)
    4798:	2785                	addiw	a5,a5,1
    479a:	fef42623          	sw	a5,-20(s0)
    cc = read(fd, buf, SZ/2);
    479e:	b709                	j	46a0 <bigfile+0x130>
      break;
    47a0:	0001                	nop
  }
  close(fd);
    47a2:	fe442783          	lw	a5,-28(s0)
    47a6:	853e                	mv	a0,a5
    47a8:	00003097          	auipc	ra,0x3
    47ac:	34c080e7          	jalr	844(ra) # 7af4 <close>
  if(total != N*SZ){
    47b0:	fe842783          	lw	a5,-24(s0)
    47b4:	0007871b          	sext.w	a4,a5
    47b8:	678d                	lui	a5,0x3
    47ba:	ee078793          	addi	a5,a5,-288 # 2ee0 <createdelete+0x16c>
    47be:	02f70163          	beq	a4,a5,47e0 <bigfile+0x270>
    printf("%s: read bigfile wrong total\n", s);
    47c2:	fd843583          	ld	a1,-40(s0)
    47c6:	00005517          	auipc	a0,0x5
    47ca:	09250513          	addi	a0,a0,146 # 9858 <malloc+0x166c>
    47ce:	00004097          	auipc	ra,0x4
    47d2:	82a080e7          	jalr	-2006(ra) # 7ff8 <printf>
    exit(1);
    47d6:	4505                	li	a0,1
    47d8:	00003097          	auipc	ra,0x3
    47dc:	2f4080e7          	jalr	756(ra) # 7acc <exit>
  }
  unlink("bigfile.dat");
    47e0:	00005517          	auipc	a0,0x5
    47e4:	fb050513          	addi	a0,a0,-80 # 9790 <malloc+0x15a4>
    47e8:	00003097          	auipc	ra,0x3
    47ec:	334080e7          	jalr	820(ra) # 7b1c <unlink>
}
    47f0:	0001                	nop
    47f2:	70a2                	ld	ra,40(sp)
    47f4:	7402                	ld	s0,32(sp)
    47f6:	6145                	addi	sp,sp,48
    47f8:	8082                	ret

00000000000047fa <fourteen>:

void
fourteen(char *s)
{
    47fa:	7179                	addi	sp,sp,-48
    47fc:	f406                	sd	ra,40(sp)
    47fe:	f022                	sd	s0,32(sp)
    4800:	1800                	addi	s0,sp,48
    4802:	fca43c23          	sd	a0,-40(s0)
  int fd;

  // DIRSIZ is 14.

  if(mkdir("12345678901234") != 0){
    4806:	00005517          	auipc	a0,0x5
    480a:	07250513          	addi	a0,a0,114 # 9878 <malloc+0x168c>
    480e:	00003097          	auipc	ra,0x3
    4812:	326080e7          	jalr	806(ra) # 7b34 <mkdir>
    4816:	87aa                	mv	a5,a0
    4818:	c385                	beqz	a5,4838 <fourteen+0x3e>
    printf("%s: mkdir 12345678901234 failed\n", s);
    481a:	fd843583          	ld	a1,-40(s0)
    481e:	00005517          	auipc	a0,0x5
    4822:	06a50513          	addi	a0,a0,106 # 9888 <malloc+0x169c>
    4826:	00003097          	auipc	ra,0x3
    482a:	7d2080e7          	jalr	2002(ra) # 7ff8 <printf>
    exit(1);
    482e:	4505                	li	a0,1
    4830:	00003097          	auipc	ra,0x3
    4834:	29c080e7          	jalr	668(ra) # 7acc <exit>
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    4838:	00005517          	auipc	a0,0x5
    483c:	07850513          	addi	a0,a0,120 # 98b0 <malloc+0x16c4>
    4840:	00003097          	auipc	ra,0x3
    4844:	2f4080e7          	jalr	756(ra) # 7b34 <mkdir>
    4848:	87aa                	mv	a5,a0
    484a:	c385                	beqz	a5,486a <fourteen+0x70>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    484c:	fd843583          	ld	a1,-40(s0)
    4850:	00005517          	auipc	a0,0x5
    4854:	08050513          	addi	a0,a0,128 # 98d0 <malloc+0x16e4>
    4858:	00003097          	auipc	ra,0x3
    485c:	7a0080e7          	jalr	1952(ra) # 7ff8 <printf>
    exit(1);
    4860:	4505                	li	a0,1
    4862:	00003097          	auipc	ra,0x3
    4866:	26a080e7          	jalr	618(ra) # 7acc <exit>
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    486a:	20000593          	li	a1,512
    486e:	00005517          	auipc	a0,0x5
    4872:	09a50513          	addi	a0,a0,154 # 9908 <malloc+0x171c>
    4876:	00003097          	auipc	ra,0x3
    487a:	296080e7          	jalr	662(ra) # 7b0c <open>
    487e:	87aa                	mv	a5,a0
    4880:	fef42623          	sw	a5,-20(s0)
  if(fd < 0){
    4884:	fec42783          	lw	a5,-20(s0)
    4888:	2781                	sext.w	a5,a5
    488a:	0207d163          	bgez	a5,48ac <fourteen+0xb2>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    488e:	fd843583          	ld	a1,-40(s0)
    4892:	00005517          	auipc	a0,0x5
    4896:	0a650513          	addi	a0,a0,166 # 9938 <malloc+0x174c>
    489a:	00003097          	auipc	ra,0x3
    489e:	75e080e7          	jalr	1886(ra) # 7ff8 <printf>
    exit(1);
    48a2:	4505                	li	a0,1
    48a4:	00003097          	auipc	ra,0x3
    48a8:	228080e7          	jalr	552(ra) # 7acc <exit>
  }
  close(fd);
    48ac:	fec42783          	lw	a5,-20(s0)
    48b0:	853e                	mv	a0,a5
    48b2:	00003097          	auipc	ra,0x3
    48b6:	242080e7          	jalr	578(ra) # 7af4 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    48ba:	4581                	li	a1,0
    48bc:	00005517          	auipc	a0,0x5
    48c0:	0c450513          	addi	a0,a0,196 # 9980 <malloc+0x1794>
    48c4:	00003097          	auipc	ra,0x3
    48c8:	248080e7          	jalr	584(ra) # 7b0c <open>
    48cc:	87aa                	mv	a5,a0
    48ce:	fef42623          	sw	a5,-20(s0)
  if(fd < 0){
    48d2:	fec42783          	lw	a5,-20(s0)
    48d6:	2781                	sext.w	a5,a5
    48d8:	0207d163          	bgez	a5,48fa <fourteen+0x100>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    48dc:	fd843583          	ld	a1,-40(s0)
    48e0:	00005517          	auipc	a0,0x5
    48e4:	0d050513          	addi	a0,a0,208 # 99b0 <malloc+0x17c4>
    48e8:	00003097          	auipc	ra,0x3
    48ec:	710080e7          	jalr	1808(ra) # 7ff8 <printf>
    exit(1);
    48f0:	4505                	li	a0,1
    48f2:	00003097          	auipc	ra,0x3
    48f6:	1da080e7          	jalr	474(ra) # 7acc <exit>
  }
  close(fd);
    48fa:	fec42783          	lw	a5,-20(s0)
    48fe:	853e                	mv	a0,a5
    4900:	00003097          	auipc	ra,0x3
    4904:	1f4080e7          	jalr	500(ra) # 7af4 <close>

  if(mkdir("12345678901234/12345678901234") == 0){
    4908:	00005517          	auipc	a0,0x5
    490c:	0e850513          	addi	a0,a0,232 # 99f0 <malloc+0x1804>
    4910:	00003097          	auipc	ra,0x3
    4914:	224080e7          	jalr	548(ra) # 7b34 <mkdir>
    4918:	87aa                	mv	a5,a0
    491a:	e385                	bnez	a5,493a <fourteen+0x140>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    491c:	fd843583          	ld	a1,-40(s0)
    4920:	00005517          	auipc	a0,0x5
    4924:	0f050513          	addi	a0,a0,240 # 9a10 <malloc+0x1824>
    4928:	00003097          	auipc	ra,0x3
    492c:	6d0080e7          	jalr	1744(ra) # 7ff8 <printf>
    exit(1);
    4930:	4505                	li	a0,1
    4932:	00003097          	auipc	ra,0x3
    4936:	19a080e7          	jalr	410(ra) # 7acc <exit>
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    493a:	00005517          	auipc	a0,0x5
    493e:	10e50513          	addi	a0,a0,270 # 9a48 <malloc+0x185c>
    4942:	00003097          	auipc	ra,0x3
    4946:	1f2080e7          	jalr	498(ra) # 7b34 <mkdir>
    494a:	87aa                	mv	a5,a0
    494c:	e385                	bnez	a5,496c <fourteen+0x172>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    494e:	fd843583          	ld	a1,-40(s0)
    4952:	00005517          	auipc	a0,0x5
    4956:	11650513          	addi	a0,a0,278 # 9a68 <malloc+0x187c>
    495a:	00003097          	auipc	ra,0x3
    495e:	69e080e7          	jalr	1694(ra) # 7ff8 <printf>
    exit(1);
    4962:	4505                	li	a0,1
    4964:	00003097          	auipc	ra,0x3
    4968:	168080e7          	jalr	360(ra) # 7acc <exit>
  }

  // clean up
  unlink("123456789012345/12345678901234");
    496c:	00005517          	auipc	a0,0x5
    4970:	0dc50513          	addi	a0,a0,220 # 9a48 <malloc+0x185c>
    4974:	00003097          	auipc	ra,0x3
    4978:	1a8080e7          	jalr	424(ra) # 7b1c <unlink>
  unlink("12345678901234/12345678901234");
    497c:	00005517          	auipc	a0,0x5
    4980:	07450513          	addi	a0,a0,116 # 99f0 <malloc+0x1804>
    4984:	00003097          	auipc	ra,0x3
    4988:	198080e7          	jalr	408(ra) # 7b1c <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    498c:	00005517          	auipc	a0,0x5
    4990:	ff450513          	addi	a0,a0,-12 # 9980 <malloc+0x1794>
    4994:	00003097          	auipc	ra,0x3
    4998:	188080e7          	jalr	392(ra) # 7b1c <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    499c:	00005517          	auipc	a0,0x5
    49a0:	f6c50513          	addi	a0,a0,-148 # 9908 <malloc+0x171c>
    49a4:	00003097          	auipc	ra,0x3
    49a8:	178080e7          	jalr	376(ra) # 7b1c <unlink>
  unlink("12345678901234/123456789012345");
    49ac:	00005517          	auipc	a0,0x5
    49b0:	f0450513          	addi	a0,a0,-252 # 98b0 <malloc+0x16c4>
    49b4:	00003097          	auipc	ra,0x3
    49b8:	168080e7          	jalr	360(ra) # 7b1c <unlink>
  unlink("12345678901234");
    49bc:	00005517          	auipc	a0,0x5
    49c0:	ebc50513          	addi	a0,a0,-324 # 9878 <malloc+0x168c>
    49c4:	00003097          	auipc	ra,0x3
    49c8:	158080e7          	jalr	344(ra) # 7b1c <unlink>
}
    49cc:	0001                	nop
    49ce:	70a2                	ld	ra,40(sp)
    49d0:	7402                	ld	s0,32(sp)
    49d2:	6145                	addi	sp,sp,48
    49d4:	8082                	ret

00000000000049d6 <rmdot>:

void
rmdot(char *s)
{
    49d6:	1101                	addi	sp,sp,-32
    49d8:	ec06                	sd	ra,24(sp)
    49da:	e822                	sd	s0,16(sp)
    49dc:	1000                	addi	s0,sp,32
    49de:	fea43423          	sd	a0,-24(s0)
  if(mkdir("dots") != 0){
    49e2:	00005517          	auipc	a0,0x5
    49e6:	0be50513          	addi	a0,a0,190 # 9aa0 <malloc+0x18b4>
    49ea:	00003097          	auipc	ra,0x3
    49ee:	14a080e7          	jalr	330(ra) # 7b34 <mkdir>
    49f2:	87aa                	mv	a5,a0
    49f4:	c385                	beqz	a5,4a14 <rmdot+0x3e>
    printf("%s: mkdir dots failed\n", s);
    49f6:	fe843583          	ld	a1,-24(s0)
    49fa:	00005517          	auipc	a0,0x5
    49fe:	0ae50513          	addi	a0,a0,174 # 9aa8 <malloc+0x18bc>
    4a02:	00003097          	auipc	ra,0x3
    4a06:	5f6080e7          	jalr	1526(ra) # 7ff8 <printf>
    exit(1);
    4a0a:	4505                	li	a0,1
    4a0c:	00003097          	auipc	ra,0x3
    4a10:	0c0080e7          	jalr	192(ra) # 7acc <exit>
  }
  if(chdir("dots") != 0){
    4a14:	00005517          	auipc	a0,0x5
    4a18:	08c50513          	addi	a0,a0,140 # 9aa0 <malloc+0x18b4>
    4a1c:	00003097          	auipc	ra,0x3
    4a20:	120080e7          	jalr	288(ra) # 7b3c <chdir>
    4a24:	87aa                	mv	a5,a0
    4a26:	c385                	beqz	a5,4a46 <rmdot+0x70>
    printf("%s: chdir dots failed\n", s);
    4a28:	fe843583          	ld	a1,-24(s0)
    4a2c:	00005517          	auipc	a0,0x5
    4a30:	09450513          	addi	a0,a0,148 # 9ac0 <malloc+0x18d4>
    4a34:	00003097          	auipc	ra,0x3
    4a38:	5c4080e7          	jalr	1476(ra) # 7ff8 <printf>
    exit(1);
    4a3c:	4505                	li	a0,1
    4a3e:	00003097          	auipc	ra,0x3
    4a42:	08e080e7          	jalr	142(ra) # 7acc <exit>
  }
  if(unlink(".") == 0){
    4a46:	00004517          	auipc	a0,0x4
    4a4a:	6b250513          	addi	a0,a0,1714 # 90f8 <malloc+0xf0c>
    4a4e:	00003097          	auipc	ra,0x3
    4a52:	0ce080e7          	jalr	206(ra) # 7b1c <unlink>
    4a56:	87aa                	mv	a5,a0
    4a58:	e385                	bnez	a5,4a78 <rmdot+0xa2>
    printf("%s: rm . worked!\n", s);
    4a5a:	fe843583          	ld	a1,-24(s0)
    4a5e:	00005517          	auipc	a0,0x5
    4a62:	07a50513          	addi	a0,a0,122 # 9ad8 <malloc+0x18ec>
    4a66:	00003097          	auipc	ra,0x3
    4a6a:	592080e7          	jalr	1426(ra) # 7ff8 <printf>
    exit(1);
    4a6e:	4505                	li	a0,1
    4a70:	00003097          	auipc	ra,0x3
    4a74:	05c080e7          	jalr	92(ra) # 7acc <exit>
  }
  if(unlink("..") == 0){
    4a78:	00004517          	auipc	a0,0x4
    4a7c:	0d850513          	addi	a0,a0,216 # 8b50 <malloc+0x964>
    4a80:	00003097          	auipc	ra,0x3
    4a84:	09c080e7          	jalr	156(ra) # 7b1c <unlink>
    4a88:	87aa                	mv	a5,a0
    4a8a:	e385                	bnez	a5,4aaa <rmdot+0xd4>
    printf("%s: rm .. worked!\n", s);
    4a8c:	fe843583          	ld	a1,-24(s0)
    4a90:	00005517          	auipc	a0,0x5
    4a94:	06050513          	addi	a0,a0,96 # 9af0 <malloc+0x1904>
    4a98:	00003097          	auipc	ra,0x3
    4a9c:	560080e7          	jalr	1376(ra) # 7ff8 <printf>
    exit(1);
    4aa0:	4505                	li	a0,1
    4aa2:	00003097          	auipc	ra,0x3
    4aa6:	02a080e7          	jalr	42(ra) # 7acc <exit>
  }
  if(chdir("/") != 0){
    4aaa:	00004517          	auipc	a0,0x4
    4aae:	dbe50513          	addi	a0,a0,-578 # 8868 <malloc+0x67c>
    4ab2:	00003097          	auipc	ra,0x3
    4ab6:	08a080e7          	jalr	138(ra) # 7b3c <chdir>
    4aba:	87aa                	mv	a5,a0
    4abc:	c385                	beqz	a5,4adc <rmdot+0x106>
    printf("%s: chdir / failed\n", s);
    4abe:	fe843583          	ld	a1,-24(s0)
    4ac2:	00004517          	auipc	a0,0x4
    4ac6:	dae50513          	addi	a0,a0,-594 # 8870 <malloc+0x684>
    4aca:	00003097          	auipc	ra,0x3
    4ace:	52e080e7          	jalr	1326(ra) # 7ff8 <printf>
    exit(1);
    4ad2:	4505                	li	a0,1
    4ad4:	00003097          	auipc	ra,0x3
    4ad8:	ff8080e7          	jalr	-8(ra) # 7acc <exit>
  }
  if(unlink("dots/.") == 0){
    4adc:	00005517          	auipc	a0,0x5
    4ae0:	02c50513          	addi	a0,a0,44 # 9b08 <malloc+0x191c>
    4ae4:	00003097          	auipc	ra,0x3
    4ae8:	038080e7          	jalr	56(ra) # 7b1c <unlink>
    4aec:	87aa                	mv	a5,a0
    4aee:	e385                	bnez	a5,4b0e <rmdot+0x138>
    printf("%s: unlink dots/. worked!\n", s);
    4af0:	fe843583          	ld	a1,-24(s0)
    4af4:	00005517          	auipc	a0,0x5
    4af8:	01c50513          	addi	a0,a0,28 # 9b10 <malloc+0x1924>
    4afc:	00003097          	auipc	ra,0x3
    4b00:	4fc080e7          	jalr	1276(ra) # 7ff8 <printf>
    exit(1);
    4b04:	4505                	li	a0,1
    4b06:	00003097          	auipc	ra,0x3
    4b0a:	fc6080e7          	jalr	-58(ra) # 7acc <exit>
  }
  if(unlink("dots/..") == 0){
    4b0e:	00005517          	auipc	a0,0x5
    4b12:	02250513          	addi	a0,a0,34 # 9b30 <malloc+0x1944>
    4b16:	00003097          	auipc	ra,0x3
    4b1a:	006080e7          	jalr	6(ra) # 7b1c <unlink>
    4b1e:	87aa                	mv	a5,a0
    4b20:	e385                	bnez	a5,4b40 <rmdot+0x16a>
    printf("%s: unlink dots/.. worked!\n", s);
    4b22:	fe843583          	ld	a1,-24(s0)
    4b26:	00005517          	auipc	a0,0x5
    4b2a:	01250513          	addi	a0,a0,18 # 9b38 <malloc+0x194c>
    4b2e:	00003097          	auipc	ra,0x3
    4b32:	4ca080e7          	jalr	1226(ra) # 7ff8 <printf>
    exit(1);
    4b36:	4505                	li	a0,1
    4b38:	00003097          	auipc	ra,0x3
    4b3c:	f94080e7          	jalr	-108(ra) # 7acc <exit>
  }
  if(unlink("dots") != 0){
    4b40:	00005517          	auipc	a0,0x5
    4b44:	f6050513          	addi	a0,a0,-160 # 9aa0 <malloc+0x18b4>
    4b48:	00003097          	auipc	ra,0x3
    4b4c:	fd4080e7          	jalr	-44(ra) # 7b1c <unlink>
    4b50:	87aa                	mv	a5,a0
    4b52:	c385                	beqz	a5,4b72 <rmdot+0x19c>
    printf("%s: unlink dots failed!\n", s);
    4b54:	fe843583          	ld	a1,-24(s0)
    4b58:	00005517          	auipc	a0,0x5
    4b5c:	00050513          	mv	a0,a0
    4b60:	00003097          	auipc	ra,0x3
    4b64:	498080e7          	jalr	1176(ra) # 7ff8 <printf>
    exit(1);
    4b68:	4505                	li	a0,1
    4b6a:	00003097          	auipc	ra,0x3
    4b6e:	f62080e7          	jalr	-158(ra) # 7acc <exit>
  }
}
    4b72:	0001                	nop
    4b74:	60e2                	ld	ra,24(sp)
    4b76:	6442                	ld	s0,16(sp)
    4b78:	6105                	addi	sp,sp,32
    4b7a:	8082                	ret

0000000000004b7c <dirfile>:

void
dirfile(char *s)
{
    4b7c:	7179                	addi	sp,sp,-48
    4b7e:	f406                	sd	ra,40(sp)
    4b80:	f022                	sd	s0,32(sp)
    4b82:	1800                	addi	s0,sp,48
    4b84:	fca43c23          	sd	a0,-40(s0)
  int fd;

  fd = open("dirfile", O_CREATE);
    4b88:	20000593          	li	a1,512
    4b8c:	00005517          	auipc	a0,0x5
    4b90:	fec50513          	addi	a0,a0,-20 # 9b78 <malloc+0x198c>
    4b94:	00003097          	auipc	ra,0x3
    4b98:	f78080e7          	jalr	-136(ra) # 7b0c <open>
    4b9c:	87aa                	mv	a5,a0
    4b9e:	fef42623          	sw	a5,-20(s0)
  if(fd < 0){
    4ba2:	fec42783          	lw	a5,-20(s0)
    4ba6:	2781                	sext.w	a5,a5
    4ba8:	0207d163          	bgez	a5,4bca <dirfile+0x4e>
    printf("%s: create dirfile failed\n", s);
    4bac:	fd843583          	ld	a1,-40(s0)
    4bb0:	00005517          	auipc	a0,0x5
    4bb4:	fd050513          	addi	a0,a0,-48 # 9b80 <malloc+0x1994>
    4bb8:	00003097          	auipc	ra,0x3
    4bbc:	440080e7          	jalr	1088(ra) # 7ff8 <printf>
    exit(1);
    4bc0:	4505                	li	a0,1
    4bc2:	00003097          	auipc	ra,0x3
    4bc6:	f0a080e7          	jalr	-246(ra) # 7acc <exit>
  }
  close(fd);
    4bca:	fec42783          	lw	a5,-20(s0)
    4bce:	853e                	mv	a0,a5
    4bd0:	00003097          	auipc	ra,0x3
    4bd4:	f24080e7          	jalr	-220(ra) # 7af4 <close>
  if(chdir("dirfile") == 0){
    4bd8:	00005517          	auipc	a0,0x5
    4bdc:	fa050513          	addi	a0,a0,-96 # 9b78 <malloc+0x198c>
    4be0:	00003097          	auipc	ra,0x3
    4be4:	f5c080e7          	jalr	-164(ra) # 7b3c <chdir>
    4be8:	87aa                	mv	a5,a0
    4bea:	e385                	bnez	a5,4c0a <dirfile+0x8e>
    printf("%s: chdir dirfile succeeded!\n", s);
    4bec:	fd843583          	ld	a1,-40(s0)
    4bf0:	00005517          	auipc	a0,0x5
    4bf4:	fb050513          	addi	a0,a0,-80 # 9ba0 <malloc+0x19b4>
    4bf8:	00003097          	auipc	ra,0x3
    4bfc:	400080e7          	jalr	1024(ra) # 7ff8 <printf>
    exit(1);
    4c00:	4505                	li	a0,1
    4c02:	00003097          	auipc	ra,0x3
    4c06:	eca080e7          	jalr	-310(ra) # 7acc <exit>
  }
  fd = open("dirfile/xx", 0);
    4c0a:	4581                	li	a1,0
    4c0c:	00005517          	auipc	a0,0x5
    4c10:	fb450513          	addi	a0,a0,-76 # 9bc0 <malloc+0x19d4>
    4c14:	00003097          	auipc	ra,0x3
    4c18:	ef8080e7          	jalr	-264(ra) # 7b0c <open>
    4c1c:	87aa                	mv	a5,a0
    4c1e:	fef42623          	sw	a5,-20(s0)
  if(fd >= 0){
    4c22:	fec42783          	lw	a5,-20(s0)
    4c26:	2781                	sext.w	a5,a5
    4c28:	0207c163          	bltz	a5,4c4a <dirfile+0xce>
    printf("%s: create dirfile/xx succeeded!\n", s);
    4c2c:	fd843583          	ld	a1,-40(s0)
    4c30:	00005517          	auipc	a0,0x5
    4c34:	fa050513          	addi	a0,a0,-96 # 9bd0 <malloc+0x19e4>
    4c38:	00003097          	auipc	ra,0x3
    4c3c:	3c0080e7          	jalr	960(ra) # 7ff8 <printf>
    exit(1);
    4c40:	4505                	li	a0,1
    4c42:	00003097          	auipc	ra,0x3
    4c46:	e8a080e7          	jalr	-374(ra) # 7acc <exit>
  }
  fd = open("dirfile/xx", O_CREATE);
    4c4a:	20000593          	li	a1,512
    4c4e:	00005517          	auipc	a0,0x5
    4c52:	f7250513          	addi	a0,a0,-142 # 9bc0 <malloc+0x19d4>
    4c56:	00003097          	auipc	ra,0x3
    4c5a:	eb6080e7          	jalr	-330(ra) # 7b0c <open>
    4c5e:	87aa                	mv	a5,a0
    4c60:	fef42623          	sw	a5,-20(s0)
  if(fd >= 0){
    4c64:	fec42783          	lw	a5,-20(s0)
    4c68:	2781                	sext.w	a5,a5
    4c6a:	0207c163          	bltz	a5,4c8c <dirfile+0x110>
    printf("%s: create dirfile/xx succeeded!\n", s);
    4c6e:	fd843583          	ld	a1,-40(s0)
    4c72:	00005517          	auipc	a0,0x5
    4c76:	f5e50513          	addi	a0,a0,-162 # 9bd0 <malloc+0x19e4>
    4c7a:	00003097          	auipc	ra,0x3
    4c7e:	37e080e7          	jalr	894(ra) # 7ff8 <printf>
    exit(1);
    4c82:	4505                	li	a0,1
    4c84:	00003097          	auipc	ra,0x3
    4c88:	e48080e7          	jalr	-440(ra) # 7acc <exit>
  }
  if(mkdir("dirfile/xx") == 0){
    4c8c:	00005517          	auipc	a0,0x5
    4c90:	f3450513          	addi	a0,a0,-204 # 9bc0 <malloc+0x19d4>
    4c94:	00003097          	auipc	ra,0x3
    4c98:	ea0080e7          	jalr	-352(ra) # 7b34 <mkdir>
    4c9c:	87aa                	mv	a5,a0
    4c9e:	e385                	bnez	a5,4cbe <dirfile+0x142>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    4ca0:	fd843583          	ld	a1,-40(s0)
    4ca4:	00005517          	auipc	a0,0x5
    4ca8:	f5450513          	addi	a0,a0,-172 # 9bf8 <malloc+0x1a0c>
    4cac:	00003097          	auipc	ra,0x3
    4cb0:	34c080e7          	jalr	844(ra) # 7ff8 <printf>
    exit(1);
    4cb4:	4505                	li	a0,1
    4cb6:	00003097          	auipc	ra,0x3
    4cba:	e16080e7          	jalr	-490(ra) # 7acc <exit>
  }
  if(unlink("dirfile/xx") == 0){
    4cbe:	00005517          	auipc	a0,0x5
    4cc2:	f0250513          	addi	a0,a0,-254 # 9bc0 <malloc+0x19d4>
    4cc6:	00003097          	auipc	ra,0x3
    4cca:	e56080e7          	jalr	-426(ra) # 7b1c <unlink>
    4cce:	87aa                	mv	a5,a0
    4cd0:	e385                	bnez	a5,4cf0 <dirfile+0x174>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    4cd2:	fd843583          	ld	a1,-40(s0)
    4cd6:	00005517          	auipc	a0,0x5
    4cda:	f4a50513          	addi	a0,a0,-182 # 9c20 <malloc+0x1a34>
    4cde:	00003097          	auipc	ra,0x3
    4ce2:	31a080e7          	jalr	794(ra) # 7ff8 <printf>
    exit(1);
    4ce6:	4505                	li	a0,1
    4ce8:	00003097          	auipc	ra,0x3
    4cec:	de4080e7          	jalr	-540(ra) # 7acc <exit>
  }
  if(link("README", "dirfile/xx") == 0){
    4cf0:	00005597          	auipc	a1,0x5
    4cf4:	ed058593          	addi	a1,a1,-304 # 9bc0 <malloc+0x19d4>
    4cf8:	00003517          	auipc	a0,0x3
    4cfc:	6f850513          	addi	a0,a0,1784 # 83f0 <malloc+0x204>
    4d00:	00003097          	auipc	ra,0x3
    4d04:	e2c080e7          	jalr	-468(ra) # 7b2c <link>
    4d08:	87aa                	mv	a5,a0
    4d0a:	e385                	bnez	a5,4d2a <dirfile+0x1ae>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    4d0c:	fd843583          	ld	a1,-40(s0)
    4d10:	00005517          	auipc	a0,0x5
    4d14:	f3850513          	addi	a0,a0,-200 # 9c48 <malloc+0x1a5c>
    4d18:	00003097          	auipc	ra,0x3
    4d1c:	2e0080e7          	jalr	736(ra) # 7ff8 <printf>
    exit(1);
    4d20:	4505                	li	a0,1
    4d22:	00003097          	auipc	ra,0x3
    4d26:	daa080e7          	jalr	-598(ra) # 7acc <exit>
  }
  if(unlink("dirfile") != 0){
    4d2a:	00005517          	auipc	a0,0x5
    4d2e:	e4e50513          	addi	a0,a0,-434 # 9b78 <malloc+0x198c>
    4d32:	00003097          	auipc	ra,0x3
    4d36:	dea080e7          	jalr	-534(ra) # 7b1c <unlink>
    4d3a:	87aa                	mv	a5,a0
    4d3c:	c385                	beqz	a5,4d5c <dirfile+0x1e0>
    printf("%s: unlink dirfile failed!\n", s);
    4d3e:	fd843583          	ld	a1,-40(s0)
    4d42:	00005517          	auipc	a0,0x5
    4d46:	f2e50513          	addi	a0,a0,-210 # 9c70 <malloc+0x1a84>
    4d4a:	00003097          	auipc	ra,0x3
    4d4e:	2ae080e7          	jalr	686(ra) # 7ff8 <printf>
    exit(1);
    4d52:	4505                	li	a0,1
    4d54:	00003097          	auipc	ra,0x3
    4d58:	d78080e7          	jalr	-648(ra) # 7acc <exit>
  }

  fd = open(".", O_RDWR);
    4d5c:	4589                	li	a1,2
    4d5e:	00004517          	auipc	a0,0x4
    4d62:	39a50513          	addi	a0,a0,922 # 90f8 <malloc+0xf0c>
    4d66:	00003097          	auipc	ra,0x3
    4d6a:	da6080e7          	jalr	-602(ra) # 7b0c <open>
    4d6e:	87aa                	mv	a5,a0
    4d70:	fef42623          	sw	a5,-20(s0)
  if(fd >= 0){
    4d74:	fec42783          	lw	a5,-20(s0)
    4d78:	2781                	sext.w	a5,a5
    4d7a:	0207c163          	bltz	a5,4d9c <dirfile+0x220>
    printf("%s: open . for writing succeeded!\n", s);
    4d7e:	fd843583          	ld	a1,-40(s0)
    4d82:	00005517          	auipc	a0,0x5
    4d86:	f0e50513          	addi	a0,a0,-242 # 9c90 <malloc+0x1aa4>
    4d8a:	00003097          	auipc	ra,0x3
    4d8e:	26e080e7          	jalr	622(ra) # 7ff8 <printf>
    exit(1);
    4d92:	4505                	li	a0,1
    4d94:	00003097          	auipc	ra,0x3
    4d98:	d38080e7          	jalr	-712(ra) # 7acc <exit>
  }
  fd = open(".", 0);
    4d9c:	4581                	li	a1,0
    4d9e:	00004517          	auipc	a0,0x4
    4da2:	35a50513          	addi	a0,a0,858 # 90f8 <malloc+0xf0c>
    4da6:	00003097          	auipc	ra,0x3
    4daa:	d66080e7          	jalr	-666(ra) # 7b0c <open>
    4dae:	87aa                	mv	a5,a0
    4db0:	fef42623          	sw	a5,-20(s0)
  if(write(fd, "x", 1) > 0){
    4db4:	fec42783          	lw	a5,-20(s0)
    4db8:	4605                	li	a2,1
    4dba:	00003597          	auipc	a1,0x3
    4dbe:	68658593          	addi	a1,a1,1670 # 8440 <malloc+0x254>
    4dc2:	853e                	mv	a0,a5
    4dc4:	00003097          	auipc	ra,0x3
    4dc8:	d28080e7          	jalr	-728(ra) # 7aec <write>
    4dcc:	87aa                	mv	a5,a0
    4dce:	02f05163          	blez	a5,4df0 <dirfile+0x274>
    printf("%s: write . succeeded!\n", s);
    4dd2:	fd843583          	ld	a1,-40(s0)
    4dd6:	00005517          	auipc	a0,0x5
    4dda:	ee250513          	addi	a0,a0,-286 # 9cb8 <malloc+0x1acc>
    4dde:	00003097          	auipc	ra,0x3
    4de2:	21a080e7          	jalr	538(ra) # 7ff8 <printf>
    exit(1);
    4de6:	4505                	li	a0,1
    4de8:	00003097          	auipc	ra,0x3
    4dec:	ce4080e7          	jalr	-796(ra) # 7acc <exit>
  }
  close(fd);
    4df0:	fec42783          	lw	a5,-20(s0)
    4df4:	853e                	mv	a0,a5
    4df6:	00003097          	auipc	ra,0x3
    4dfa:	cfe080e7          	jalr	-770(ra) # 7af4 <close>
}
    4dfe:	0001                	nop
    4e00:	70a2                	ld	ra,40(sp)
    4e02:	7402                	ld	s0,32(sp)
    4e04:	6145                	addi	sp,sp,48
    4e06:	8082                	ret

0000000000004e08 <iref>:

// test that iput() is called at the end of _namei().
// also tests empty file names.
void
iref(char *s)
{
    4e08:	7179                	addi	sp,sp,-48
    4e0a:	f406                	sd	ra,40(sp)
    4e0c:	f022                	sd	s0,32(sp)
    4e0e:	1800                	addi	s0,sp,48
    4e10:	fca43c23          	sd	a0,-40(s0)
  int i, fd;

  for(i = 0; i < NINODE + 1; i++){
    4e14:	fe042623          	sw	zero,-20(s0)
    4e18:	a231                	j	4f24 <iref+0x11c>
    if(mkdir("irefd") != 0){
    4e1a:	00005517          	auipc	a0,0x5
    4e1e:	eb650513          	addi	a0,a0,-330 # 9cd0 <malloc+0x1ae4>
    4e22:	00003097          	auipc	ra,0x3
    4e26:	d12080e7          	jalr	-750(ra) # 7b34 <mkdir>
    4e2a:	87aa                	mv	a5,a0
    4e2c:	c385                	beqz	a5,4e4c <iref+0x44>
      printf("%s: mkdir irefd failed\n", s);
    4e2e:	fd843583          	ld	a1,-40(s0)
    4e32:	00005517          	auipc	a0,0x5
    4e36:	ea650513          	addi	a0,a0,-346 # 9cd8 <malloc+0x1aec>
    4e3a:	00003097          	auipc	ra,0x3
    4e3e:	1be080e7          	jalr	446(ra) # 7ff8 <printf>
      exit(1);
    4e42:	4505                	li	a0,1
    4e44:	00003097          	auipc	ra,0x3
    4e48:	c88080e7          	jalr	-888(ra) # 7acc <exit>
    }
    if(chdir("irefd") != 0){
    4e4c:	00005517          	auipc	a0,0x5
    4e50:	e8450513          	addi	a0,a0,-380 # 9cd0 <malloc+0x1ae4>
    4e54:	00003097          	auipc	ra,0x3
    4e58:	ce8080e7          	jalr	-792(ra) # 7b3c <chdir>
    4e5c:	87aa                	mv	a5,a0
    4e5e:	c385                	beqz	a5,4e7e <iref+0x76>
      printf("%s: chdir irefd failed\n", s);
    4e60:	fd843583          	ld	a1,-40(s0)
    4e64:	00005517          	auipc	a0,0x5
    4e68:	e8c50513          	addi	a0,a0,-372 # 9cf0 <malloc+0x1b04>
    4e6c:	00003097          	auipc	ra,0x3
    4e70:	18c080e7          	jalr	396(ra) # 7ff8 <printf>
      exit(1);
    4e74:	4505                	li	a0,1
    4e76:	00003097          	auipc	ra,0x3
    4e7a:	c56080e7          	jalr	-938(ra) # 7acc <exit>
    }

    mkdir("");
    4e7e:	00005517          	auipc	a0,0x5
    4e82:	e8a50513          	addi	a0,a0,-374 # 9d08 <malloc+0x1b1c>
    4e86:	00003097          	auipc	ra,0x3
    4e8a:	cae080e7          	jalr	-850(ra) # 7b34 <mkdir>
    link("README", "");
    4e8e:	00005597          	auipc	a1,0x5
    4e92:	e7a58593          	addi	a1,a1,-390 # 9d08 <malloc+0x1b1c>
    4e96:	00003517          	auipc	a0,0x3
    4e9a:	55a50513          	addi	a0,a0,1370 # 83f0 <malloc+0x204>
    4e9e:	00003097          	auipc	ra,0x3
    4ea2:	c8e080e7          	jalr	-882(ra) # 7b2c <link>
    fd = open("", O_CREATE);
    4ea6:	20000593          	li	a1,512
    4eaa:	00005517          	auipc	a0,0x5
    4eae:	e5e50513          	addi	a0,a0,-418 # 9d08 <malloc+0x1b1c>
    4eb2:	00003097          	auipc	ra,0x3
    4eb6:	c5a080e7          	jalr	-934(ra) # 7b0c <open>
    4eba:	87aa                	mv	a5,a0
    4ebc:	fef42423          	sw	a5,-24(s0)
    if(fd >= 0)
    4ec0:	fe842783          	lw	a5,-24(s0)
    4ec4:	2781                	sext.w	a5,a5
    4ec6:	0007c963          	bltz	a5,4ed8 <iref+0xd0>
      close(fd);
    4eca:	fe842783          	lw	a5,-24(s0)
    4ece:	853e                	mv	a0,a5
    4ed0:	00003097          	auipc	ra,0x3
    4ed4:	c24080e7          	jalr	-988(ra) # 7af4 <close>
    fd = open("xx", O_CREATE);
    4ed8:	20000593          	li	a1,512
    4edc:	00003517          	auipc	a0,0x3
    4ee0:	63c50513          	addi	a0,a0,1596 # 8518 <malloc+0x32c>
    4ee4:	00003097          	auipc	ra,0x3
    4ee8:	c28080e7          	jalr	-984(ra) # 7b0c <open>
    4eec:	87aa                	mv	a5,a0
    4eee:	fef42423          	sw	a5,-24(s0)
    if(fd >= 0)
    4ef2:	fe842783          	lw	a5,-24(s0)
    4ef6:	2781                	sext.w	a5,a5
    4ef8:	0007c963          	bltz	a5,4f0a <iref+0x102>
      close(fd);
    4efc:	fe842783          	lw	a5,-24(s0)
    4f00:	853e                	mv	a0,a5
    4f02:	00003097          	auipc	ra,0x3
    4f06:	bf2080e7          	jalr	-1038(ra) # 7af4 <close>
    unlink("xx");
    4f0a:	00003517          	auipc	a0,0x3
    4f0e:	60e50513          	addi	a0,a0,1550 # 8518 <malloc+0x32c>
    4f12:	00003097          	auipc	ra,0x3
    4f16:	c0a080e7          	jalr	-1014(ra) # 7b1c <unlink>
  for(i = 0; i < NINODE + 1; i++){
    4f1a:	fec42783          	lw	a5,-20(s0)
    4f1e:	2785                	addiw	a5,a5,1
    4f20:	fef42623          	sw	a5,-20(s0)
    4f24:	fec42783          	lw	a5,-20(s0)
    4f28:	0007871b          	sext.w	a4,a5
    4f2c:	03200793          	li	a5,50
    4f30:	eee7d5e3          	bge	a5,a4,4e1a <iref+0x12>
  }

  // clean up
  for(i = 0; i < NINODE + 1; i++){
    4f34:	fe042623          	sw	zero,-20(s0)
    4f38:	a035                	j	4f64 <iref+0x15c>
    chdir("..");
    4f3a:	00004517          	auipc	a0,0x4
    4f3e:	c1650513          	addi	a0,a0,-1002 # 8b50 <malloc+0x964>
    4f42:	00003097          	auipc	ra,0x3
    4f46:	bfa080e7          	jalr	-1030(ra) # 7b3c <chdir>
    unlink("irefd");
    4f4a:	00005517          	auipc	a0,0x5
    4f4e:	d8650513          	addi	a0,a0,-634 # 9cd0 <malloc+0x1ae4>
    4f52:	00003097          	auipc	ra,0x3
    4f56:	bca080e7          	jalr	-1078(ra) # 7b1c <unlink>
  for(i = 0; i < NINODE + 1; i++){
    4f5a:	fec42783          	lw	a5,-20(s0)
    4f5e:	2785                	addiw	a5,a5,1
    4f60:	fef42623          	sw	a5,-20(s0)
    4f64:	fec42783          	lw	a5,-20(s0)
    4f68:	0007871b          	sext.w	a4,a5
    4f6c:	03200793          	li	a5,50
    4f70:	fce7d5e3          	bge	a5,a4,4f3a <iref+0x132>
  }

  chdir("/");
    4f74:	00004517          	auipc	a0,0x4
    4f78:	8f450513          	addi	a0,a0,-1804 # 8868 <malloc+0x67c>
    4f7c:	00003097          	auipc	ra,0x3
    4f80:	bc0080e7          	jalr	-1088(ra) # 7b3c <chdir>
}
    4f84:	0001                	nop
    4f86:	70a2                	ld	ra,40(sp)
    4f88:	7402                	ld	s0,32(sp)
    4f8a:	6145                	addi	sp,sp,48
    4f8c:	8082                	ret

0000000000004f8e <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(char *s)
{
    4f8e:	7179                	addi	sp,sp,-48
    4f90:	f406                	sd	ra,40(sp)
    4f92:	f022                	sd	s0,32(sp)
    4f94:	1800                	addi	s0,sp,48
    4f96:	fca43c23          	sd	a0,-40(s0)
  enum{ N = 1000 };
  int n, pid;

  for(n=0; n<N; n++){
    4f9a:	fe042623          	sw	zero,-20(s0)
    4f9e:	a81d                	j	4fd4 <forktest+0x46>
    pid = fork();
    4fa0:	00003097          	auipc	ra,0x3
    4fa4:	b24080e7          	jalr	-1244(ra) # 7ac4 <fork>
    4fa8:	87aa                	mv	a5,a0
    4faa:	fef42423          	sw	a5,-24(s0)
    if(pid < 0)
    4fae:	fe842783          	lw	a5,-24(s0)
    4fb2:	2781                	sext.w	a5,a5
    4fb4:	0207c963          	bltz	a5,4fe6 <forktest+0x58>
      break;
    if(pid == 0)
    4fb8:	fe842783          	lw	a5,-24(s0)
    4fbc:	2781                	sext.w	a5,a5
    4fbe:	e791                	bnez	a5,4fca <forktest+0x3c>
      exit(0);
    4fc0:	4501                	li	a0,0
    4fc2:	00003097          	auipc	ra,0x3
    4fc6:	b0a080e7          	jalr	-1270(ra) # 7acc <exit>
  for(n=0; n<N; n++){
    4fca:	fec42783          	lw	a5,-20(s0)
    4fce:	2785                	addiw	a5,a5,1
    4fd0:	fef42623          	sw	a5,-20(s0)
    4fd4:	fec42783          	lw	a5,-20(s0)
    4fd8:	0007871b          	sext.w	a4,a5
    4fdc:	3e700793          	li	a5,999
    4fe0:	fce7d0e3          	bge	a5,a4,4fa0 <forktest+0x12>
    4fe4:	a011                	j	4fe8 <forktest+0x5a>
      break;
    4fe6:	0001                	nop
  }

  if (n == 0) {
    4fe8:	fec42783          	lw	a5,-20(s0)
    4fec:	2781                	sext.w	a5,a5
    4fee:	e385                	bnez	a5,500e <forktest+0x80>
    printf("%s: no fork at all!\n", s);
    4ff0:	fd843583          	ld	a1,-40(s0)
    4ff4:	00005517          	auipc	a0,0x5
    4ff8:	d1c50513          	addi	a0,a0,-740 # 9d10 <malloc+0x1b24>
    4ffc:	00003097          	auipc	ra,0x3
    5000:	ffc080e7          	jalr	-4(ra) # 7ff8 <printf>
    exit(1);
    5004:	4505                	li	a0,1
    5006:	00003097          	auipc	ra,0x3
    500a:	ac6080e7          	jalr	-1338(ra) # 7acc <exit>
  }

  if(n == N){
    500e:	fec42783          	lw	a5,-20(s0)
    5012:	0007871b          	sext.w	a4,a5
    5016:	3e800793          	li	a5,1000
    501a:	04f71d63          	bne	a4,a5,5074 <forktest+0xe6>
    printf("%s: fork claimed to work 1000 times!\n", s);
    501e:	fd843583          	ld	a1,-40(s0)
    5022:	00005517          	auipc	a0,0x5
    5026:	d0650513          	addi	a0,a0,-762 # 9d28 <malloc+0x1b3c>
    502a:	00003097          	auipc	ra,0x3
    502e:	fce080e7          	jalr	-50(ra) # 7ff8 <printf>
    exit(1);
    5032:	4505                	li	a0,1
    5034:	00003097          	auipc	ra,0x3
    5038:	a98080e7          	jalr	-1384(ra) # 7acc <exit>
  }

  for(; n > 0; n--){
    if(wait(0) < 0){
    503c:	4501                	li	a0,0
    503e:	00003097          	auipc	ra,0x3
    5042:	a96080e7          	jalr	-1386(ra) # 7ad4 <wait>
    5046:	87aa                	mv	a5,a0
    5048:	0207d163          	bgez	a5,506a <forktest+0xdc>
      printf("%s: wait stopped early\n", s);
    504c:	fd843583          	ld	a1,-40(s0)
    5050:	00005517          	auipc	a0,0x5
    5054:	d0050513          	addi	a0,a0,-768 # 9d50 <malloc+0x1b64>
    5058:	00003097          	auipc	ra,0x3
    505c:	fa0080e7          	jalr	-96(ra) # 7ff8 <printf>
      exit(1);
    5060:	4505                	li	a0,1
    5062:	00003097          	auipc	ra,0x3
    5066:	a6a080e7          	jalr	-1430(ra) # 7acc <exit>
  for(; n > 0; n--){
    506a:	fec42783          	lw	a5,-20(s0)
    506e:	37fd                	addiw	a5,a5,-1
    5070:	fef42623          	sw	a5,-20(s0)
    5074:	fec42783          	lw	a5,-20(s0)
    5078:	2781                	sext.w	a5,a5
    507a:	fcf041e3          	bgtz	a5,503c <forktest+0xae>
    }
  }

  if(wait(0) != -1){
    507e:	4501                	li	a0,0
    5080:	00003097          	auipc	ra,0x3
    5084:	a54080e7          	jalr	-1452(ra) # 7ad4 <wait>
    5088:	87aa                	mv	a5,a0
    508a:	873e                	mv	a4,a5
    508c:	57fd                	li	a5,-1
    508e:	02f70163          	beq	a4,a5,50b0 <forktest+0x122>
    printf("%s: wait got too many\n", s);
    5092:	fd843583          	ld	a1,-40(s0)
    5096:	00005517          	auipc	a0,0x5
    509a:	cd250513          	addi	a0,a0,-814 # 9d68 <malloc+0x1b7c>
    509e:	00003097          	auipc	ra,0x3
    50a2:	f5a080e7          	jalr	-166(ra) # 7ff8 <printf>
    exit(1);
    50a6:	4505                	li	a0,1
    50a8:	00003097          	auipc	ra,0x3
    50ac:	a24080e7          	jalr	-1500(ra) # 7acc <exit>
  }
}
    50b0:	0001                	nop
    50b2:	70a2                	ld	ra,40(sp)
    50b4:	7402                	ld	s0,32(sp)
    50b6:	6145                	addi	sp,sp,48
    50b8:	8082                	ret

00000000000050ba <sbrkbasic>:

void
sbrkbasic(char *s)
{
    50ba:	715d                	addi	sp,sp,-80
    50bc:	e486                	sd	ra,72(sp)
    50be:	e0a2                	sd	s0,64(sp)
    50c0:	0880                	addi	s0,sp,80
    50c2:	faa43c23          	sd	a0,-72(s0)
  enum { TOOMUCH=1024*1024*1024};
  int i, pid, xstatus;
  char *c, *a, *b;

  // does sbrk() return the expected failure value?
  pid = fork();
    50c6:	00003097          	auipc	ra,0x3
    50ca:	9fe080e7          	jalr	-1538(ra) # 7ac4 <fork>
    50ce:	87aa                	mv	a5,a0
    50d0:	fcf42a23          	sw	a5,-44(s0)
  if(pid < 0){
    50d4:	fd442783          	lw	a5,-44(s0)
    50d8:	2781                	sext.w	a5,a5
    50da:	0007df63          	bgez	a5,50f8 <sbrkbasic+0x3e>
    printf("fork failed in sbrkbasic\n");
    50de:	00005517          	auipc	a0,0x5
    50e2:	ca250513          	addi	a0,a0,-862 # 9d80 <malloc+0x1b94>
    50e6:	00003097          	auipc	ra,0x3
    50ea:	f12080e7          	jalr	-238(ra) # 7ff8 <printf>
    exit(1);
    50ee:	4505                	li	a0,1
    50f0:	00003097          	auipc	ra,0x3
    50f4:	9dc080e7          	jalr	-1572(ra) # 7acc <exit>
  }
  if(pid == 0){
    50f8:	fd442783          	lw	a5,-44(s0)
    50fc:	2781                	sext.w	a5,a5
    50fe:	e3b5                	bnez	a5,5162 <sbrkbasic+0xa8>
    a = sbrk(TOOMUCH);
    5100:	40000537          	lui	a0,0x40000
    5104:	00003097          	auipc	ra,0x3
    5108:	a50080e7          	jalr	-1456(ra) # 7b54 <sbrk>
    510c:	fea43023          	sd	a0,-32(s0)
    if(a == (char*)0xffffffffffffffffL){
    5110:	fe043703          	ld	a4,-32(s0)
    5114:	57fd                	li	a5,-1
    5116:	00f71763          	bne	a4,a5,5124 <sbrkbasic+0x6a>
      // it's OK if this fails.
      exit(0);
    511a:	4501                	li	a0,0
    511c:	00003097          	auipc	ra,0x3
    5120:	9b0080e7          	jalr	-1616(ra) # 7acc <exit>
    }
    
    for(b = a; b < a+TOOMUCH; b += 4096){
    5124:	fe043783          	ld	a5,-32(s0)
    5128:	fcf43c23          	sd	a5,-40(s0)
    512c:	a829                	j	5146 <sbrkbasic+0x8c>
      *b = 99;
    512e:	fd843783          	ld	a5,-40(s0)
    5132:	06300713          	li	a4,99
    5136:	00e78023          	sb	a4,0(a5)
    for(b = a; b < a+TOOMUCH; b += 4096){
    513a:	fd843703          	ld	a4,-40(s0)
    513e:	6785                	lui	a5,0x1
    5140:	97ba                	add	a5,a5,a4
    5142:	fcf43c23          	sd	a5,-40(s0)
    5146:	fe043703          	ld	a4,-32(s0)
    514a:	400007b7          	lui	a5,0x40000
    514e:	97ba                	add	a5,a5,a4
    5150:	fd843703          	ld	a4,-40(s0)
    5154:	fcf76de3          	bltu	a4,a5,512e <sbrkbasic+0x74>
    }
    
    // we should not get here! either sbrk(TOOMUCH)
    // should have failed, or (with lazy allocation)
    // a pagefault should have killed this process.
    exit(1);
    5158:	4505                	li	a0,1
    515a:	00003097          	auipc	ra,0x3
    515e:	972080e7          	jalr	-1678(ra) # 7acc <exit>
  }

  wait(&xstatus);
    5162:	fc440793          	addi	a5,s0,-60
    5166:	853e                	mv	a0,a5
    5168:	00003097          	auipc	ra,0x3
    516c:	96c080e7          	jalr	-1684(ra) # 7ad4 <wait>
  if(xstatus == 1){
    5170:	fc442703          	lw	a4,-60(s0)
    5174:	4785                	li	a5,1
    5176:	02f71163          	bne	a4,a5,5198 <sbrkbasic+0xde>
    printf("%s: too much memory allocated!\n", s);
    517a:	fb843583          	ld	a1,-72(s0)
    517e:	00005517          	auipc	a0,0x5
    5182:	c2250513          	addi	a0,a0,-990 # 9da0 <malloc+0x1bb4>
    5186:	00003097          	auipc	ra,0x3
    518a:	e72080e7          	jalr	-398(ra) # 7ff8 <printf>
    exit(1);
    518e:	4505                	li	a0,1
    5190:	00003097          	auipc	ra,0x3
    5194:	93c080e7          	jalr	-1732(ra) # 7acc <exit>
  }

  // can one sbrk() less than a page?
  a = sbrk(0);
    5198:	4501                	li	a0,0
    519a:	00003097          	auipc	ra,0x3
    519e:	9ba080e7          	jalr	-1606(ra) # 7b54 <sbrk>
    51a2:	fea43023          	sd	a0,-32(s0)
  for(i = 0; i < 5000; i++){
    51a6:	fe042623          	sw	zero,-20(s0)
    51aa:	a09d                	j	5210 <sbrkbasic+0x156>
    b = sbrk(1);
    51ac:	4505                	li	a0,1
    51ae:	00003097          	auipc	ra,0x3
    51b2:	9a6080e7          	jalr	-1626(ra) # 7b54 <sbrk>
    51b6:	fca43c23          	sd	a0,-40(s0)
    if(b != a){
    51ba:	fd843703          	ld	a4,-40(s0)
    51be:	fe043783          	ld	a5,-32(s0)
    51c2:	02f70863          	beq	a4,a5,51f2 <sbrkbasic+0x138>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    51c6:	fec42783          	lw	a5,-20(s0)
    51ca:	fd843703          	ld	a4,-40(s0)
    51ce:	fe043683          	ld	a3,-32(s0)
    51d2:	863e                	mv	a2,a5
    51d4:	fb843583          	ld	a1,-72(s0)
    51d8:	00005517          	auipc	a0,0x5
    51dc:	be850513          	addi	a0,a0,-1048 # 9dc0 <malloc+0x1bd4>
    51e0:	00003097          	auipc	ra,0x3
    51e4:	e18080e7          	jalr	-488(ra) # 7ff8 <printf>
      exit(1);
    51e8:	4505                	li	a0,1
    51ea:	00003097          	auipc	ra,0x3
    51ee:	8e2080e7          	jalr	-1822(ra) # 7acc <exit>
    }
    *b = 1;
    51f2:	fd843783          	ld	a5,-40(s0)
    51f6:	4705                	li	a4,1
    51f8:	00e78023          	sb	a4,0(a5) # 40000000 <freep+0x3ffee368>
    a = b + 1;
    51fc:	fd843783          	ld	a5,-40(s0)
    5200:	0785                	addi	a5,a5,1
    5202:	fef43023          	sd	a5,-32(s0)
  for(i = 0; i < 5000; i++){
    5206:	fec42783          	lw	a5,-20(s0)
    520a:	2785                	addiw	a5,a5,1
    520c:	fef42623          	sw	a5,-20(s0)
    5210:	fec42783          	lw	a5,-20(s0)
    5214:	0007871b          	sext.w	a4,a5
    5218:	6785                	lui	a5,0x1
    521a:	38778793          	addi	a5,a5,903 # 1387 <openiputtest+0xe9>
    521e:	f8e7d7e3          	bge	a5,a4,51ac <sbrkbasic+0xf2>
  }
  pid = fork();
    5222:	00003097          	auipc	ra,0x3
    5226:	8a2080e7          	jalr	-1886(ra) # 7ac4 <fork>
    522a:	87aa                	mv	a5,a0
    522c:	fcf42a23          	sw	a5,-44(s0)
  if(pid < 0){
    5230:	fd442783          	lw	a5,-44(s0)
    5234:	2781                	sext.w	a5,a5
    5236:	0207d163          	bgez	a5,5258 <sbrkbasic+0x19e>
    printf("%s: sbrk test fork failed\n", s);
    523a:	fb843583          	ld	a1,-72(s0)
    523e:	00005517          	auipc	a0,0x5
    5242:	ba250513          	addi	a0,a0,-1118 # 9de0 <malloc+0x1bf4>
    5246:	00003097          	auipc	ra,0x3
    524a:	db2080e7          	jalr	-590(ra) # 7ff8 <printf>
    exit(1);
    524e:	4505                	li	a0,1
    5250:	00003097          	auipc	ra,0x3
    5254:	87c080e7          	jalr	-1924(ra) # 7acc <exit>
  }
  c = sbrk(1);
    5258:	4505                	li	a0,1
    525a:	00003097          	auipc	ra,0x3
    525e:	8fa080e7          	jalr	-1798(ra) # 7b54 <sbrk>
    5262:	fca43423          	sd	a0,-56(s0)
  c = sbrk(1);
    5266:	4505                	li	a0,1
    5268:	00003097          	auipc	ra,0x3
    526c:	8ec080e7          	jalr	-1812(ra) # 7b54 <sbrk>
    5270:	fca43423          	sd	a0,-56(s0)
  if(c != a + 1){
    5274:	fe043783          	ld	a5,-32(s0)
    5278:	0785                	addi	a5,a5,1
    527a:	fc843703          	ld	a4,-56(s0)
    527e:	02f70163          	beq	a4,a5,52a0 <sbrkbasic+0x1e6>
    printf("%s: sbrk test failed post-fork\n", s);
    5282:	fb843583          	ld	a1,-72(s0)
    5286:	00005517          	auipc	a0,0x5
    528a:	b7a50513          	addi	a0,a0,-1158 # 9e00 <malloc+0x1c14>
    528e:	00003097          	auipc	ra,0x3
    5292:	d6a080e7          	jalr	-662(ra) # 7ff8 <printf>
    exit(1);
    5296:	4505                	li	a0,1
    5298:	00003097          	auipc	ra,0x3
    529c:	834080e7          	jalr	-1996(ra) # 7acc <exit>
  }
  if(pid == 0)
    52a0:	fd442783          	lw	a5,-44(s0)
    52a4:	2781                	sext.w	a5,a5
    52a6:	e791                	bnez	a5,52b2 <sbrkbasic+0x1f8>
    exit(0);
    52a8:	4501                	li	a0,0
    52aa:	00003097          	auipc	ra,0x3
    52ae:	822080e7          	jalr	-2014(ra) # 7acc <exit>
  wait(&xstatus);
    52b2:	fc440793          	addi	a5,s0,-60
    52b6:	853e                	mv	a0,a5
    52b8:	00003097          	auipc	ra,0x3
    52bc:	81c080e7          	jalr	-2020(ra) # 7ad4 <wait>
  exit(xstatus);
    52c0:	fc442783          	lw	a5,-60(s0)
    52c4:	853e                	mv	a0,a5
    52c6:	00003097          	auipc	ra,0x3
    52ca:	806080e7          	jalr	-2042(ra) # 7acc <exit>

00000000000052ce <sbrkmuch>:
}

void
sbrkmuch(char *s)
{
    52ce:	711d                	addi	sp,sp,-96
    52d0:	ec86                	sd	ra,88(sp)
    52d2:	e8a2                	sd	s0,80(sp)
    52d4:	1080                	addi	s0,sp,96
    52d6:	faa43423          	sd	a0,-88(s0)
  enum { BIG=100*1024*1024 };
  char *c, *oldbrk, *a, *lastaddr, *p;
  uint64 amt;

  oldbrk = sbrk(0);
    52da:	4501                	li	a0,0
    52dc:	00003097          	auipc	ra,0x3
    52e0:	878080e7          	jalr	-1928(ra) # 7b54 <sbrk>
    52e4:	fea43023          	sd	a0,-32(s0)

  // can one grow address space to something big?
  a = sbrk(0);
    52e8:	4501                	li	a0,0
    52ea:	00003097          	auipc	ra,0x3
    52ee:	86a080e7          	jalr	-1942(ra) # 7b54 <sbrk>
    52f2:	fca43c23          	sd	a0,-40(s0)
  amt = BIG - (uint64)a;
    52f6:	fd843783          	ld	a5,-40(s0)
    52fa:	06400737          	lui	a4,0x6400
    52fe:	40f707b3          	sub	a5,a4,a5
    5302:	fcf43823          	sd	a5,-48(s0)
  p = sbrk(amt);
    5306:	fd043783          	ld	a5,-48(s0)
    530a:	2781                	sext.w	a5,a5
    530c:	853e                	mv	a0,a5
    530e:	00003097          	auipc	ra,0x3
    5312:	846080e7          	jalr	-1978(ra) # 7b54 <sbrk>
    5316:	fca43423          	sd	a0,-56(s0)
  if (p != a) {
    531a:	fc843703          	ld	a4,-56(s0)
    531e:	fd843783          	ld	a5,-40(s0)
    5322:	02f70163          	beq	a4,a5,5344 <sbrkmuch+0x76>
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    5326:	fa843583          	ld	a1,-88(s0)
    532a:	00005517          	auipc	a0,0x5
    532e:	af650513          	addi	a0,a0,-1290 # 9e20 <malloc+0x1c34>
    5332:	00003097          	auipc	ra,0x3
    5336:	cc6080e7          	jalr	-826(ra) # 7ff8 <printf>
    exit(1);
    533a:	4505                	li	a0,1
    533c:	00002097          	auipc	ra,0x2
    5340:	790080e7          	jalr	1936(ra) # 7acc <exit>
  }

  // touch each page to make sure it exists.
  char *eee = sbrk(0);
    5344:	4501                	li	a0,0
    5346:	00003097          	auipc	ra,0x3
    534a:	80e080e7          	jalr	-2034(ra) # 7b54 <sbrk>
    534e:	fca43023          	sd	a0,-64(s0)
  for(char *pp = a; pp < eee; pp += 4096)
    5352:	fd843783          	ld	a5,-40(s0)
    5356:	fef43423          	sd	a5,-24(s0)
    535a:	a821                	j	5372 <sbrkmuch+0xa4>
    *pp = 1;
    535c:	fe843783          	ld	a5,-24(s0)
    5360:	4705                	li	a4,1
    5362:	00e78023          	sb	a4,0(a5)
  for(char *pp = a; pp < eee; pp += 4096)
    5366:	fe843703          	ld	a4,-24(s0)
    536a:	6785                	lui	a5,0x1
    536c:	97ba                	add	a5,a5,a4
    536e:	fef43423          	sd	a5,-24(s0)
    5372:	fe843703          	ld	a4,-24(s0)
    5376:	fc043783          	ld	a5,-64(s0)
    537a:	fef761e3          	bltu	a4,a5,535c <sbrkmuch+0x8e>

  lastaddr = (char*) (BIG-1);
    537e:	064007b7          	lui	a5,0x6400
    5382:	17fd                	addi	a5,a5,-1 # 63fffff <freep+0x63ee367>
    5384:	faf43c23          	sd	a5,-72(s0)
  *lastaddr = 99;
    5388:	fb843783          	ld	a5,-72(s0)
    538c:	06300713          	li	a4,99
    5390:	00e78023          	sb	a4,0(a5)

  // can one de-allocate?
  a = sbrk(0);
    5394:	4501                	li	a0,0
    5396:	00002097          	auipc	ra,0x2
    539a:	7be080e7          	jalr	1982(ra) # 7b54 <sbrk>
    539e:	fca43c23          	sd	a0,-40(s0)
  c = sbrk(-PGSIZE);
    53a2:	757d                	lui	a0,0xfffff
    53a4:	00002097          	auipc	ra,0x2
    53a8:	7b0080e7          	jalr	1968(ra) # 7b54 <sbrk>
    53ac:	faa43823          	sd	a0,-80(s0)
  if(c == (char*)0xffffffffffffffffL){
    53b0:	fb043703          	ld	a4,-80(s0)
    53b4:	57fd                	li	a5,-1
    53b6:	02f71163          	bne	a4,a5,53d8 <sbrkmuch+0x10a>
    printf("%s: sbrk could not deallocate\n", s);
    53ba:	fa843583          	ld	a1,-88(s0)
    53be:	00005517          	auipc	a0,0x5
    53c2:	aaa50513          	addi	a0,a0,-1366 # 9e68 <malloc+0x1c7c>
    53c6:	00003097          	auipc	ra,0x3
    53ca:	c32080e7          	jalr	-974(ra) # 7ff8 <printf>
    exit(1);
    53ce:	4505                	li	a0,1
    53d0:	00002097          	auipc	ra,0x2
    53d4:	6fc080e7          	jalr	1788(ra) # 7acc <exit>
  }
  c = sbrk(0);
    53d8:	4501                	li	a0,0
    53da:	00002097          	auipc	ra,0x2
    53de:	77a080e7          	jalr	1914(ra) # 7b54 <sbrk>
    53e2:	faa43823          	sd	a0,-80(s0)
  if(c != a - PGSIZE){
    53e6:	fd843703          	ld	a4,-40(s0)
    53ea:	77fd                	lui	a5,0xfffff
    53ec:	97ba                	add	a5,a5,a4
    53ee:	fb043703          	ld	a4,-80(s0)
    53f2:	02f70563          	beq	a4,a5,541c <sbrkmuch+0x14e>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    53f6:	fb043683          	ld	a3,-80(s0)
    53fa:	fd843603          	ld	a2,-40(s0)
    53fe:	fa843583          	ld	a1,-88(s0)
    5402:	00005517          	auipc	a0,0x5
    5406:	a8650513          	addi	a0,a0,-1402 # 9e88 <malloc+0x1c9c>
    540a:	00003097          	auipc	ra,0x3
    540e:	bee080e7          	jalr	-1042(ra) # 7ff8 <printf>
    exit(1);
    5412:	4505                	li	a0,1
    5414:	00002097          	auipc	ra,0x2
    5418:	6b8080e7          	jalr	1720(ra) # 7acc <exit>
  }

  // can one re-allocate that page?
  a = sbrk(0);
    541c:	4501                	li	a0,0
    541e:	00002097          	auipc	ra,0x2
    5422:	736080e7          	jalr	1846(ra) # 7b54 <sbrk>
    5426:	fca43c23          	sd	a0,-40(s0)
  c = sbrk(PGSIZE);
    542a:	6505                	lui	a0,0x1
    542c:	00002097          	auipc	ra,0x2
    5430:	728080e7          	jalr	1832(ra) # 7b54 <sbrk>
    5434:	faa43823          	sd	a0,-80(s0)
  if(c != a || sbrk(0) != a + PGSIZE){
    5438:	fb043703          	ld	a4,-80(s0)
    543c:	fd843783          	ld	a5,-40(s0)
    5440:	00f71e63          	bne	a4,a5,545c <sbrkmuch+0x18e>
    5444:	4501                	li	a0,0
    5446:	00002097          	auipc	ra,0x2
    544a:	70e080e7          	jalr	1806(ra) # 7b54 <sbrk>
    544e:	86aa                	mv	a3,a0
    5450:	fd843703          	ld	a4,-40(s0)
    5454:	6785                	lui	a5,0x1
    5456:	97ba                	add	a5,a5,a4
    5458:	02f68563          	beq	a3,a5,5482 <sbrkmuch+0x1b4>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    545c:	fb043683          	ld	a3,-80(s0)
    5460:	fd843603          	ld	a2,-40(s0)
    5464:	fa843583          	ld	a1,-88(s0)
    5468:	00005517          	auipc	a0,0x5
    546c:	a6050513          	addi	a0,a0,-1440 # 9ec8 <malloc+0x1cdc>
    5470:	00003097          	auipc	ra,0x3
    5474:	b88080e7          	jalr	-1144(ra) # 7ff8 <printf>
    exit(1);
    5478:	4505                	li	a0,1
    547a:	00002097          	auipc	ra,0x2
    547e:	652080e7          	jalr	1618(ra) # 7acc <exit>
  }
  if(*lastaddr == 99){
    5482:	fb843783          	ld	a5,-72(s0)
    5486:	0007c783          	lbu	a5,0(a5) # 1000 <truncate3+0x1b2>
    548a:	873e                	mv	a4,a5
    548c:	06300793          	li	a5,99
    5490:	02f71163          	bne	a4,a5,54b2 <sbrkmuch+0x1e4>
    // should be zero
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    5494:	fa843583          	ld	a1,-88(s0)
    5498:	00005517          	auipc	a0,0x5
    549c:	a6050513          	addi	a0,a0,-1440 # 9ef8 <malloc+0x1d0c>
    54a0:	00003097          	auipc	ra,0x3
    54a4:	b58080e7          	jalr	-1192(ra) # 7ff8 <printf>
    exit(1);
    54a8:	4505                	li	a0,1
    54aa:	00002097          	auipc	ra,0x2
    54ae:	622080e7          	jalr	1570(ra) # 7acc <exit>
  }

  a = sbrk(0);
    54b2:	4501                	li	a0,0
    54b4:	00002097          	auipc	ra,0x2
    54b8:	6a0080e7          	jalr	1696(ra) # 7b54 <sbrk>
    54bc:	fca43c23          	sd	a0,-40(s0)
  c = sbrk(-(sbrk(0) - oldbrk));
    54c0:	4501                	li	a0,0
    54c2:	00002097          	auipc	ra,0x2
    54c6:	692080e7          	jalr	1682(ra) # 7b54 <sbrk>
    54ca:	872a                	mv	a4,a0
    54cc:	fe043783          	ld	a5,-32(s0)
    54d0:	8f99                	sub	a5,a5,a4
    54d2:	2781                	sext.w	a5,a5
    54d4:	853e                	mv	a0,a5
    54d6:	00002097          	auipc	ra,0x2
    54da:	67e080e7          	jalr	1662(ra) # 7b54 <sbrk>
    54de:	faa43823          	sd	a0,-80(s0)
  if(c != a){
    54e2:	fb043703          	ld	a4,-80(s0)
    54e6:	fd843783          	ld	a5,-40(s0)
    54ea:	02f70563          	beq	a4,a5,5514 <sbrkmuch+0x246>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    54ee:	fb043683          	ld	a3,-80(s0)
    54f2:	fd843603          	ld	a2,-40(s0)
    54f6:	fa843583          	ld	a1,-88(s0)
    54fa:	00005517          	auipc	a0,0x5
    54fe:	a3650513          	addi	a0,a0,-1482 # 9f30 <malloc+0x1d44>
    5502:	00003097          	auipc	ra,0x3
    5506:	af6080e7          	jalr	-1290(ra) # 7ff8 <printf>
    exit(1);
    550a:	4505                	li	a0,1
    550c:	00002097          	auipc	ra,0x2
    5510:	5c0080e7          	jalr	1472(ra) # 7acc <exit>
  }
}
    5514:	0001                	nop
    5516:	60e6                	ld	ra,88(sp)
    5518:	6446                	ld	s0,80(sp)
    551a:	6125                	addi	sp,sp,96
    551c:	8082                	ret

000000000000551e <kernmem>:

// can we read the kernel's memory?
void
kernmem(char *s)
{
    551e:	7179                	addi	sp,sp,-48
    5520:	f406                	sd	ra,40(sp)
    5522:	f022                	sd	s0,32(sp)
    5524:	1800                	addi	s0,sp,48
    5526:	fca43c23          	sd	a0,-40(s0)
  char *a;
  int pid;

  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    552a:	4785                	li	a5,1
    552c:	07fe                	slli	a5,a5,0x1f
    552e:	fef43423          	sd	a5,-24(s0)
    5532:	a045                	j	55d2 <kernmem+0xb4>
    pid = fork();
    5534:	00002097          	auipc	ra,0x2
    5538:	590080e7          	jalr	1424(ra) # 7ac4 <fork>
    553c:	87aa                	mv	a5,a0
    553e:	fef42223          	sw	a5,-28(s0)
    if(pid < 0){
    5542:	fe442783          	lw	a5,-28(s0)
    5546:	2781                	sext.w	a5,a5
    5548:	0207d163          	bgez	a5,556a <kernmem+0x4c>
      printf("%s: fork failed\n", s);
    554c:	fd843583          	ld	a1,-40(s0)
    5550:	00003517          	auipc	a0,0x3
    5554:	22050513          	addi	a0,a0,544 # 8770 <malloc+0x584>
    5558:	00003097          	auipc	ra,0x3
    555c:	aa0080e7          	jalr	-1376(ra) # 7ff8 <printf>
      exit(1);
    5560:	4505                	li	a0,1
    5562:	00002097          	auipc	ra,0x2
    5566:	56a080e7          	jalr	1386(ra) # 7acc <exit>
    }
    if(pid == 0){
    556a:	fe442783          	lw	a5,-28(s0)
    556e:	2781                	sext.w	a5,a5
    5570:	eb85                	bnez	a5,55a0 <kernmem+0x82>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    5572:	fe843783          	ld	a5,-24(s0)
    5576:	0007c783          	lbu	a5,0(a5)
    557a:	2781                	sext.w	a5,a5
    557c:	86be                	mv	a3,a5
    557e:	fe843603          	ld	a2,-24(s0)
    5582:	fd843583          	ld	a1,-40(s0)
    5586:	00005517          	auipc	a0,0x5
    558a:	9d250513          	addi	a0,a0,-1582 # 9f58 <malloc+0x1d6c>
    558e:	00003097          	auipc	ra,0x3
    5592:	a6a080e7          	jalr	-1430(ra) # 7ff8 <printf>
      exit(1);
    5596:	4505                	li	a0,1
    5598:	00002097          	auipc	ra,0x2
    559c:	534080e7          	jalr	1332(ra) # 7acc <exit>
    }
    int xstatus;
    wait(&xstatus);
    55a0:	fe040793          	addi	a5,s0,-32
    55a4:	853e                	mv	a0,a5
    55a6:	00002097          	auipc	ra,0x2
    55aa:	52e080e7          	jalr	1326(ra) # 7ad4 <wait>
    if(xstatus != -1)  // did kernel kill child?
    55ae:	fe042703          	lw	a4,-32(s0)
    55b2:	57fd                	li	a5,-1
    55b4:	00f70763          	beq	a4,a5,55c2 <kernmem+0xa4>
      exit(1);
    55b8:	4505                	li	a0,1
    55ba:	00002097          	auipc	ra,0x2
    55be:	512080e7          	jalr	1298(ra) # 7acc <exit>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    55c2:	fe843703          	ld	a4,-24(s0)
    55c6:	67b1                	lui	a5,0xc
    55c8:	35078793          	addi	a5,a5,848 # c350 <buf+0xee0>
    55cc:	97ba                	add	a5,a5,a4
    55ce:	fef43423          	sd	a5,-24(s0)
    55d2:	fe843703          	ld	a4,-24(s0)
    55d6:	1003d7b7          	lui	a5,0x1003d
    55da:	078e                	slli	a5,a5,0x3
    55dc:	47f78793          	addi	a5,a5,1151 # 1003d47f <freep+0x1002b7e7>
    55e0:	f4e7fae3          	bgeu	a5,a4,5534 <kernmem+0x16>
  }
}
    55e4:	0001                	nop
    55e6:	0001                	nop
    55e8:	70a2                	ld	ra,40(sp)
    55ea:	7402                	ld	s0,32(sp)
    55ec:	6145                	addi	sp,sp,48
    55ee:	8082                	ret

00000000000055f0 <MAXVAplus>:

// user code should not be able to write to addresses above MAXVA.
void
MAXVAplus(char *s)
{
    55f0:	7139                	addi	sp,sp,-64
    55f2:	fc06                	sd	ra,56(sp)
    55f4:	f822                	sd	s0,48(sp)
    55f6:	0080                	addi	s0,sp,64
    55f8:	fca43423          	sd	a0,-56(s0)
  volatile uint64 a = MAXVA;
    55fc:	4785                	li	a5,1
    55fe:	179a                	slli	a5,a5,0x26
    5600:	fef43023          	sd	a5,-32(s0)
  for( ; a != 0; a <<= 1){
    5604:	a879                	j	56a2 <MAXVAplus+0xb2>
    int pid;
    pid = fork();
    5606:	00002097          	auipc	ra,0x2
    560a:	4be080e7          	jalr	1214(ra) # 7ac4 <fork>
    560e:	87aa                	mv	a5,a0
    5610:	fef42623          	sw	a5,-20(s0)
    if(pid < 0){
    5614:	fec42783          	lw	a5,-20(s0)
    5618:	2781                	sext.w	a5,a5
    561a:	0207d163          	bgez	a5,563c <MAXVAplus+0x4c>
      printf("%s: fork failed\n", s);
    561e:	fc843583          	ld	a1,-56(s0)
    5622:	00003517          	auipc	a0,0x3
    5626:	14e50513          	addi	a0,a0,334 # 8770 <malloc+0x584>
    562a:	00003097          	auipc	ra,0x3
    562e:	9ce080e7          	jalr	-1586(ra) # 7ff8 <printf>
      exit(1);
    5632:	4505                	li	a0,1
    5634:	00002097          	auipc	ra,0x2
    5638:	498080e7          	jalr	1176(ra) # 7acc <exit>
    }
    if(pid == 0){
    563c:	fec42783          	lw	a5,-20(s0)
    5640:	2781                	sext.w	a5,a5
    5642:	eb95                	bnez	a5,5676 <MAXVAplus+0x86>
      *(char*)a = 99;
    5644:	fe043783          	ld	a5,-32(s0)
    5648:	873e                	mv	a4,a5
    564a:	06300793          	li	a5,99
    564e:	00f70023          	sb	a5,0(a4) # 6400000 <freep+0x63ee368>
      printf("%s: oops wrote %x\n", s, a);
    5652:	fe043783          	ld	a5,-32(s0)
    5656:	863e                	mv	a2,a5
    5658:	fc843583          	ld	a1,-56(s0)
    565c:	00005517          	auipc	a0,0x5
    5660:	91c50513          	addi	a0,a0,-1764 # 9f78 <malloc+0x1d8c>
    5664:	00003097          	auipc	ra,0x3
    5668:	994080e7          	jalr	-1644(ra) # 7ff8 <printf>
      exit(1);
    566c:	4505                	li	a0,1
    566e:	00002097          	auipc	ra,0x2
    5672:	45e080e7          	jalr	1118(ra) # 7acc <exit>
    }
    int xstatus;
    wait(&xstatus);
    5676:	fdc40793          	addi	a5,s0,-36
    567a:	853e                	mv	a0,a5
    567c:	00002097          	auipc	ra,0x2
    5680:	458080e7          	jalr	1112(ra) # 7ad4 <wait>
    if(xstatus != -1)  // did kernel kill child?
    5684:	fdc42703          	lw	a4,-36(s0)
    5688:	57fd                	li	a5,-1
    568a:	00f70763          	beq	a4,a5,5698 <MAXVAplus+0xa8>
      exit(1);
    568e:	4505                	li	a0,1
    5690:	00002097          	auipc	ra,0x2
    5694:	43c080e7          	jalr	1084(ra) # 7acc <exit>
  for( ; a != 0; a <<= 1){
    5698:	fe043783          	ld	a5,-32(s0)
    569c:	0786                	slli	a5,a5,0x1
    569e:	fef43023          	sd	a5,-32(s0)
    56a2:	fe043783          	ld	a5,-32(s0)
    56a6:	f3a5                	bnez	a5,5606 <MAXVAplus+0x16>
  }
}
    56a8:	0001                	nop
    56aa:	0001                	nop
    56ac:	70e2                	ld	ra,56(sp)
    56ae:	7442                	ld	s0,48(sp)
    56b0:	6121                	addi	sp,sp,64
    56b2:	8082                	ret

00000000000056b4 <sbrkfail>:

// if we run the system out of memory, does it clean up the last
// failed allocation?
void
sbrkfail(char *s)
{
    56b4:	7119                	addi	sp,sp,-128
    56b6:	fc86                	sd	ra,120(sp)
    56b8:	f8a2                	sd	s0,112(sp)
    56ba:	0100                	addi	s0,sp,128
    56bc:	f8a43423          	sd	a0,-120(s0)
  char scratch;
  char *c, *a;
  int pids[10];
  int pid;
 
  if(pipe(fds) != 0){
    56c0:	fc040793          	addi	a5,s0,-64
    56c4:	853e                	mv	a0,a5
    56c6:	00002097          	auipc	ra,0x2
    56ca:	416080e7          	jalr	1046(ra) # 7adc <pipe>
    56ce:	87aa                	mv	a5,a0
    56d0:	c385                	beqz	a5,56f0 <sbrkfail+0x3c>
    printf("%s: pipe() failed\n", s);
    56d2:	f8843583          	ld	a1,-120(s0)
    56d6:	00003517          	auipc	a0,0x3
    56da:	53250513          	addi	a0,a0,1330 # 8c08 <malloc+0xa1c>
    56de:	00003097          	auipc	ra,0x3
    56e2:	91a080e7          	jalr	-1766(ra) # 7ff8 <printf>
    exit(1);
    56e6:	4505                	li	a0,1
    56e8:	00002097          	auipc	ra,0x2
    56ec:	3e4080e7          	jalr	996(ra) # 7acc <exit>
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    56f0:	fe042623          	sw	zero,-20(s0)
    56f4:	a065                	j	579c <sbrkfail+0xe8>
    if((pids[i] = fork()) == 0){
    56f6:	00002097          	auipc	ra,0x2
    56fa:	3ce080e7          	jalr	974(ra) # 7ac4 <fork>
    56fe:	87aa                	mv	a5,a0
    5700:	86be                	mv	a3,a5
    5702:	fec42703          	lw	a4,-20(s0)
    5706:	f9040793          	addi	a5,s0,-112
    570a:	070a                	slli	a4,a4,0x2
    570c:	97ba                	add	a5,a5,a4
    570e:	c394                	sw	a3,0(a5)
    5710:	fec42703          	lw	a4,-20(s0)
    5714:	f9040793          	addi	a5,s0,-112
    5718:	070a                	slli	a4,a4,0x2
    571a:	97ba                	add	a5,a5,a4
    571c:	439c                	lw	a5,0(a5)
    571e:	e7a9                	bnez	a5,5768 <sbrkfail+0xb4>
      // allocate a lot of memory
      sbrk(BIG - (uint64)sbrk(0));
    5720:	4501                	li	a0,0
    5722:	00002097          	auipc	ra,0x2
    5726:	432080e7          	jalr	1074(ra) # 7b54 <sbrk>
    572a:	87aa                	mv	a5,a0
    572c:	2781                	sext.w	a5,a5
    572e:	06400737          	lui	a4,0x6400
    5732:	40f707bb          	subw	a5,a4,a5
    5736:	2781                	sext.w	a5,a5
    5738:	853e                	mv	a0,a5
    573a:	00002097          	auipc	ra,0x2
    573e:	41a080e7          	jalr	1050(ra) # 7b54 <sbrk>
      write(fds[1], "x", 1);
    5742:	fc442783          	lw	a5,-60(s0)
    5746:	4605                	li	a2,1
    5748:	00003597          	auipc	a1,0x3
    574c:	cf858593          	addi	a1,a1,-776 # 8440 <malloc+0x254>
    5750:	853e                	mv	a0,a5
    5752:	00002097          	auipc	ra,0x2
    5756:	39a080e7          	jalr	922(ra) # 7aec <write>
      // sit around until killed
      for(;;) sleep(1000);
    575a:	3e800513          	li	a0,1000
    575e:	00002097          	auipc	ra,0x2
    5762:	3fe080e7          	jalr	1022(ra) # 7b5c <sleep>
    5766:	bfd5                	j	575a <sbrkfail+0xa6>
    }
    if(pids[i] != -1)
    5768:	fec42703          	lw	a4,-20(s0)
    576c:	f9040793          	addi	a5,s0,-112
    5770:	070a                	slli	a4,a4,0x2
    5772:	97ba                	add	a5,a5,a4
    5774:	4398                	lw	a4,0(a5)
    5776:	57fd                	li	a5,-1
    5778:	00f70d63          	beq	a4,a5,5792 <sbrkfail+0xde>
      read(fds[0], &scratch, 1);
    577c:	fc042783          	lw	a5,-64(s0)
    5780:	fbf40713          	addi	a4,s0,-65
    5784:	4605                	li	a2,1
    5786:	85ba                	mv	a1,a4
    5788:	853e                	mv	a0,a5
    578a:	00002097          	auipc	ra,0x2
    578e:	35a080e7          	jalr	858(ra) # 7ae4 <read>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    5792:	fec42783          	lw	a5,-20(s0)
    5796:	2785                	addiw	a5,a5,1
    5798:	fef42623          	sw	a5,-20(s0)
    579c:	fec42703          	lw	a4,-20(s0)
    57a0:	47a5                	li	a5,9
    57a2:	f4e7fae3          	bgeu	a5,a4,56f6 <sbrkfail+0x42>
  }

  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(PGSIZE);
    57a6:	6505                	lui	a0,0x1
    57a8:	00002097          	auipc	ra,0x2
    57ac:	3ac080e7          	jalr	940(ra) # 7b54 <sbrk>
    57b0:	fea43023          	sd	a0,-32(s0)
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    57b4:	fe042623          	sw	zero,-20(s0)
    57b8:	a099                	j	57fe <sbrkfail+0x14a>
    if(pids[i] == -1)
    57ba:	fec42703          	lw	a4,-20(s0)
    57be:	f9040793          	addi	a5,s0,-112
    57c2:	070a                	slli	a4,a4,0x2
    57c4:	97ba                	add	a5,a5,a4
    57c6:	4398                	lw	a4,0(a5)
    57c8:	57fd                	li	a5,-1
    57ca:	02f70463          	beq	a4,a5,57f2 <sbrkfail+0x13e>
      continue;
    kill(pids[i]);
    57ce:	fec42703          	lw	a4,-20(s0)
    57d2:	f9040793          	addi	a5,s0,-112
    57d6:	070a                	slli	a4,a4,0x2
    57d8:	97ba                	add	a5,a5,a4
    57da:	439c                	lw	a5,0(a5)
    57dc:	853e                	mv	a0,a5
    57de:	00002097          	auipc	ra,0x2
    57e2:	31e080e7          	jalr	798(ra) # 7afc <kill>
    wait(0);
    57e6:	4501                	li	a0,0
    57e8:	00002097          	auipc	ra,0x2
    57ec:	2ec080e7          	jalr	748(ra) # 7ad4 <wait>
    57f0:	a011                	j	57f4 <sbrkfail+0x140>
      continue;
    57f2:	0001                	nop
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    57f4:	fec42783          	lw	a5,-20(s0)
    57f8:	2785                	addiw	a5,a5,1
    57fa:	fef42623          	sw	a5,-20(s0)
    57fe:	fec42703          	lw	a4,-20(s0)
    5802:	47a5                	li	a5,9
    5804:	fae7fbe3          	bgeu	a5,a4,57ba <sbrkfail+0x106>
  }
  if(c == (char*)0xffffffffffffffffL){
    5808:	fe043703          	ld	a4,-32(s0)
    580c:	57fd                	li	a5,-1
    580e:	02f71163          	bne	a4,a5,5830 <sbrkfail+0x17c>
    printf("%s: failed sbrk leaked memory\n", s);
    5812:	f8843583          	ld	a1,-120(s0)
    5816:	00004517          	auipc	a0,0x4
    581a:	77a50513          	addi	a0,a0,1914 # 9f90 <malloc+0x1da4>
    581e:	00002097          	auipc	ra,0x2
    5822:	7da080e7          	jalr	2010(ra) # 7ff8 <printf>
    exit(1);
    5826:	4505                	li	a0,1
    5828:	00002097          	auipc	ra,0x2
    582c:	2a4080e7          	jalr	676(ra) # 7acc <exit>
  }

  // test running fork with the above allocated page 
  pid = fork();
    5830:	00002097          	auipc	ra,0x2
    5834:	294080e7          	jalr	660(ra) # 7ac4 <fork>
    5838:	87aa                	mv	a5,a0
    583a:	fcf42e23          	sw	a5,-36(s0)
  if(pid < 0){
    583e:	fdc42783          	lw	a5,-36(s0)
    5842:	2781                	sext.w	a5,a5
    5844:	0207d163          	bgez	a5,5866 <sbrkfail+0x1b2>
    printf("%s: fork failed\n", s);
    5848:	f8843583          	ld	a1,-120(s0)
    584c:	00003517          	auipc	a0,0x3
    5850:	f2450513          	addi	a0,a0,-220 # 8770 <malloc+0x584>
    5854:	00002097          	auipc	ra,0x2
    5858:	7a4080e7          	jalr	1956(ra) # 7ff8 <printf>
    exit(1);
    585c:	4505                	li	a0,1
    585e:	00002097          	auipc	ra,0x2
    5862:	26e080e7          	jalr	622(ra) # 7acc <exit>
  }
  if(pid == 0){
    5866:	fdc42783          	lw	a5,-36(s0)
    586a:	2781                	sext.w	a5,a5
    586c:	e3c9                	bnez	a5,58ee <sbrkfail+0x23a>
    // allocate a lot of memory.
    // this should produce a page fault,
    // and thus not complete.
    a = sbrk(0);
    586e:	4501                	li	a0,0
    5870:	00002097          	auipc	ra,0x2
    5874:	2e4080e7          	jalr	740(ra) # 7b54 <sbrk>
    5878:	fca43823          	sd	a0,-48(s0)
    sbrk(10*BIG);
    587c:	3e800537          	lui	a0,0x3e800
    5880:	00002097          	auipc	ra,0x2
    5884:	2d4080e7          	jalr	724(ra) # 7b54 <sbrk>
    int n = 0;
    5888:	fe042423          	sw	zero,-24(s0)
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    588c:	fe042623          	sw	zero,-20(s0)
    5890:	a02d                	j	58ba <sbrkfail+0x206>
      n += *(a+i);
    5892:	fec42783          	lw	a5,-20(s0)
    5896:	fd043703          	ld	a4,-48(s0)
    589a:	97ba                	add	a5,a5,a4
    589c:	0007c783          	lbu	a5,0(a5)
    58a0:	2781                	sext.w	a5,a5
    58a2:	fe842703          	lw	a4,-24(s0)
    58a6:	9fb9                	addw	a5,a5,a4
    58a8:	fef42423          	sw	a5,-24(s0)
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    58ac:	fec42783          	lw	a5,-20(s0)
    58b0:	873e                	mv	a4,a5
    58b2:	6785                	lui	a5,0x1
    58b4:	9fb9                	addw	a5,a5,a4
    58b6:	fef42623          	sw	a5,-20(s0)
    58ba:	fec42783          	lw	a5,-20(s0)
    58be:	0007871b          	sext.w	a4,a5
    58c2:	3e8007b7          	lui	a5,0x3e800
    58c6:	fcf746e3          	blt	a4,a5,5892 <sbrkfail+0x1de>
    }
    // print n so the compiler doesn't optimize away
    // the for loop.
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    58ca:	fe842783          	lw	a5,-24(s0)
    58ce:	863e                	mv	a2,a5
    58d0:	f8843583          	ld	a1,-120(s0)
    58d4:	00004517          	auipc	a0,0x4
    58d8:	6dc50513          	addi	a0,a0,1756 # 9fb0 <malloc+0x1dc4>
    58dc:	00002097          	auipc	ra,0x2
    58e0:	71c080e7          	jalr	1820(ra) # 7ff8 <printf>
    exit(1);
    58e4:	4505                	li	a0,1
    58e6:	00002097          	auipc	ra,0x2
    58ea:	1e6080e7          	jalr	486(ra) # 7acc <exit>
  }
  wait(&xstatus);
    58ee:	fcc40793          	addi	a5,s0,-52
    58f2:	853e                	mv	a0,a5
    58f4:	00002097          	auipc	ra,0x2
    58f8:	1e0080e7          	jalr	480(ra) # 7ad4 <wait>
  if(xstatus != -1 && xstatus != 2)
    58fc:	fcc42703          	lw	a4,-52(s0)
    5900:	57fd                	li	a5,-1
    5902:	00f70c63          	beq	a4,a5,591a <sbrkfail+0x266>
    5906:	fcc42703          	lw	a4,-52(s0)
    590a:	4789                	li	a5,2
    590c:	00f70763          	beq	a4,a5,591a <sbrkfail+0x266>
    exit(1);
    5910:	4505                	li	a0,1
    5912:	00002097          	auipc	ra,0x2
    5916:	1ba080e7          	jalr	442(ra) # 7acc <exit>
}
    591a:	0001                	nop
    591c:	70e6                	ld	ra,120(sp)
    591e:	7446                	ld	s0,112(sp)
    5920:	6109                	addi	sp,sp,128
    5922:	8082                	ret

0000000000005924 <sbrkarg>:

  
// test reads/writes from/to allocated memory
void
sbrkarg(char *s)
{
    5924:	7179                	addi	sp,sp,-48
    5926:	f406                	sd	ra,40(sp)
    5928:	f022                	sd	s0,32(sp)
    592a:	1800                	addi	s0,sp,48
    592c:	fca43c23          	sd	a0,-40(s0)
  char *a;
  int fd, n;

  a = sbrk(PGSIZE);
    5930:	6505                	lui	a0,0x1
    5932:	00002097          	auipc	ra,0x2
    5936:	222080e7          	jalr	546(ra) # 7b54 <sbrk>
    593a:	fea43423          	sd	a0,-24(s0)
  fd = open("sbrk", O_CREATE|O_WRONLY);
    593e:	20100593          	li	a1,513
    5942:	00004517          	auipc	a0,0x4
    5946:	69e50513          	addi	a0,a0,1694 # 9fe0 <malloc+0x1df4>
    594a:	00002097          	auipc	ra,0x2
    594e:	1c2080e7          	jalr	450(ra) # 7b0c <open>
    5952:	87aa                	mv	a5,a0
    5954:	fef42223          	sw	a5,-28(s0)
  unlink("sbrk");
    5958:	00004517          	auipc	a0,0x4
    595c:	68850513          	addi	a0,a0,1672 # 9fe0 <malloc+0x1df4>
    5960:	00002097          	auipc	ra,0x2
    5964:	1bc080e7          	jalr	444(ra) # 7b1c <unlink>
  if(fd < 0)  {
    5968:	fe442783          	lw	a5,-28(s0)
    596c:	2781                	sext.w	a5,a5
    596e:	0207d163          	bgez	a5,5990 <sbrkarg+0x6c>
    printf("%s: open sbrk failed\n", s);
    5972:	fd843583          	ld	a1,-40(s0)
    5976:	00004517          	auipc	a0,0x4
    597a:	67250513          	addi	a0,a0,1650 # 9fe8 <malloc+0x1dfc>
    597e:	00002097          	auipc	ra,0x2
    5982:	67a080e7          	jalr	1658(ra) # 7ff8 <printf>
    exit(1);
    5986:	4505                	li	a0,1
    5988:	00002097          	auipc	ra,0x2
    598c:	144080e7          	jalr	324(ra) # 7acc <exit>
  }
  if ((n = write(fd, a, PGSIZE)) < 0) {
    5990:	fe442783          	lw	a5,-28(s0)
    5994:	6605                	lui	a2,0x1
    5996:	fe843583          	ld	a1,-24(s0)
    599a:	853e                	mv	a0,a5
    599c:	00002097          	auipc	ra,0x2
    59a0:	150080e7          	jalr	336(ra) # 7aec <write>
    59a4:	87aa                	mv	a5,a0
    59a6:	fef42023          	sw	a5,-32(s0)
    59aa:	fe042783          	lw	a5,-32(s0)
    59ae:	2781                	sext.w	a5,a5
    59b0:	0207d163          	bgez	a5,59d2 <sbrkarg+0xae>
    printf("%s: write sbrk failed\n", s);
    59b4:	fd843583          	ld	a1,-40(s0)
    59b8:	00004517          	auipc	a0,0x4
    59bc:	64850513          	addi	a0,a0,1608 # a000 <malloc+0x1e14>
    59c0:	00002097          	auipc	ra,0x2
    59c4:	638080e7          	jalr	1592(ra) # 7ff8 <printf>
    exit(1);
    59c8:	4505                	li	a0,1
    59ca:	00002097          	auipc	ra,0x2
    59ce:	102080e7          	jalr	258(ra) # 7acc <exit>
  }
  close(fd);
    59d2:	fe442783          	lw	a5,-28(s0)
    59d6:	853e                	mv	a0,a5
    59d8:	00002097          	auipc	ra,0x2
    59dc:	11c080e7          	jalr	284(ra) # 7af4 <close>

  // test writes to allocated memory
  a = sbrk(PGSIZE);
    59e0:	6505                	lui	a0,0x1
    59e2:	00002097          	auipc	ra,0x2
    59e6:	172080e7          	jalr	370(ra) # 7b54 <sbrk>
    59ea:	fea43423          	sd	a0,-24(s0)
  if(pipe((int *) a) != 0){
    59ee:	fe843503          	ld	a0,-24(s0)
    59f2:	00002097          	auipc	ra,0x2
    59f6:	0ea080e7          	jalr	234(ra) # 7adc <pipe>
    59fa:	87aa                	mv	a5,a0
    59fc:	c385                	beqz	a5,5a1c <sbrkarg+0xf8>
    printf("%s: pipe() failed\n", s);
    59fe:	fd843583          	ld	a1,-40(s0)
    5a02:	00003517          	auipc	a0,0x3
    5a06:	20650513          	addi	a0,a0,518 # 8c08 <malloc+0xa1c>
    5a0a:	00002097          	auipc	ra,0x2
    5a0e:	5ee080e7          	jalr	1518(ra) # 7ff8 <printf>
    exit(1);
    5a12:	4505                	li	a0,1
    5a14:	00002097          	auipc	ra,0x2
    5a18:	0b8080e7          	jalr	184(ra) # 7acc <exit>
  } 
}
    5a1c:	0001                	nop
    5a1e:	70a2                	ld	ra,40(sp)
    5a20:	7402                	ld	s0,32(sp)
    5a22:	6145                	addi	sp,sp,48
    5a24:	8082                	ret

0000000000005a26 <validatetest>:

void
validatetest(char *s)
{
    5a26:	7179                	addi	sp,sp,-48
    5a28:	f406                	sd	ra,40(sp)
    5a2a:	f022                	sd	s0,32(sp)
    5a2c:	1800                	addi	s0,sp,48
    5a2e:	fca43c23          	sd	a0,-40(s0)
  int hi;
  uint64 p;

  hi = 1100*1024;
    5a32:	001137b7          	lui	a5,0x113
    5a36:	fef42223          	sw	a5,-28(s0)
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    5a3a:	fe043423          	sd	zero,-24(s0)
    5a3e:	a0b1                	j	5a8a <validatetest+0x64>
    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    5a40:	fe843783          	ld	a5,-24(s0)
    5a44:	85be                	mv	a1,a5
    5a46:	00004517          	auipc	a0,0x4
    5a4a:	5d250513          	addi	a0,a0,1490 # a018 <malloc+0x1e2c>
    5a4e:	00002097          	auipc	ra,0x2
    5a52:	0de080e7          	jalr	222(ra) # 7b2c <link>
    5a56:	87aa                	mv	a5,a0
    5a58:	873e                	mv	a4,a5
    5a5a:	57fd                	li	a5,-1
    5a5c:	02f70163          	beq	a4,a5,5a7e <validatetest+0x58>
      printf("%s: link should not succeed\n", s);
    5a60:	fd843583          	ld	a1,-40(s0)
    5a64:	00004517          	auipc	a0,0x4
    5a68:	5c450513          	addi	a0,a0,1476 # a028 <malloc+0x1e3c>
    5a6c:	00002097          	auipc	ra,0x2
    5a70:	58c080e7          	jalr	1420(ra) # 7ff8 <printf>
      exit(1);
    5a74:	4505                	li	a0,1
    5a76:	00002097          	auipc	ra,0x2
    5a7a:	056080e7          	jalr	86(ra) # 7acc <exit>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    5a7e:	fe843703          	ld	a4,-24(s0)
    5a82:	6785                	lui	a5,0x1
    5a84:	97ba                	add	a5,a5,a4
    5a86:	fef43423          	sd	a5,-24(s0)
    5a8a:	fe442783          	lw	a5,-28(s0)
    5a8e:	1782                	slli	a5,a5,0x20
    5a90:	9381                	srli	a5,a5,0x20
    5a92:	fe843703          	ld	a4,-24(s0)
    5a96:	fae7f5e3          	bgeu	a5,a4,5a40 <validatetest+0x1a>
    }
  }
}
    5a9a:	0001                	nop
    5a9c:	0001                	nop
    5a9e:	70a2                	ld	ra,40(sp)
    5aa0:	7402                	ld	s0,32(sp)
    5aa2:	6145                	addi	sp,sp,48
    5aa4:	8082                	ret

0000000000005aa6 <bsstest>:

// does uninitialized data start out zero?
char uninit[10000];
void
bsstest(char *s)
{
    5aa6:	7179                	addi	sp,sp,-48
    5aa8:	f406                	sd	ra,40(sp)
    5aaa:	f022                	sd	s0,32(sp)
    5aac:	1800                	addi	s0,sp,48
    5aae:	fca43c23          	sd	a0,-40(s0)
  int i;

  for(i = 0; i < sizeof(uninit); i++){
    5ab2:	fe042623          	sw	zero,-20(s0)
    5ab6:	a83d                	j	5af4 <bsstest+0x4e>
    if(uninit[i] != '\0'){
    5ab8:	00009717          	auipc	a4,0x9
    5abc:	9b870713          	addi	a4,a4,-1608 # e470 <uninit>
    5ac0:	fec42783          	lw	a5,-20(s0)
    5ac4:	97ba                	add	a5,a5,a4
    5ac6:	0007c783          	lbu	a5,0(a5) # 1000 <truncate3+0x1b2>
    5aca:	c385                	beqz	a5,5aea <bsstest+0x44>
      printf("%s: bss test failed\n", s);
    5acc:	fd843583          	ld	a1,-40(s0)
    5ad0:	00004517          	auipc	a0,0x4
    5ad4:	57850513          	addi	a0,a0,1400 # a048 <malloc+0x1e5c>
    5ad8:	00002097          	auipc	ra,0x2
    5adc:	520080e7          	jalr	1312(ra) # 7ff8 <printf>
      exit(1);
    5ae0:	4505                	li	a0,1
    5ae2:	00002097          	auipc	ra,0x2
    5ae6:	fea080e7          	jalr	-22(ra) # 7acc <exit>
  for(i = 0; i < sizeof(uninit); i++){
    5aea:	fec42783          	lw	a5,-20(s0)
    5aee:	2785                	addiw	a5,a5,1
    5af0:	fef42623          	sw	a5,-20(s0)
    5af4:	fec42703          	lw	a4,-20(s0)
    5af8:	6789                	lui	a5,0x2
    5afa:	70f78793          	addi	a5,a5,1807 # 270f <reparent2+0x81>
    5afe:	fae7fde3          	bgeu	a5,a4,5ab8 <bsstest+0x12>
    }
  }
}
    5b02:	0001                	nop
    5b04:	0001                	nop
    5b06:	70a2                	ld	ra,40(sp)
    5b08:	7402                	ld	s0,32(sp)
    5b0a:	6145                	addi	sp,sp,48
    5b0c:	8082                	ret

0000000000005b0e <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(char *s)
{
    5b0e:	7179                	addi	sp,sp,-48
    5b10:	f406                	sd	ra,40(sp)
    5b12:	f022                	sd	s0,32(sp)
    5b14:	1800                	addi	s0,sp,48
    5b16:	fca43c23          	sd	a0,-40(s0)
  int pid, fd, xstatus;

  unlink("bigarg-ok");
    5b1a:	00004517          	auipc	a0,0x4
    5b1e:	54650513          	addi	a0,a0,1350 # a060 <malloc+0x1e74>
    5b22:	00002097          	auipc	ra,0x2
    5b26:	ffa080e7          	jalr	-6(ra) # 7b1c <unlink>
  pid = fork();
    5b2a:	00002097          	auipc	ra,0x2
    5b2e:	f9a080e7          	jalr	-102(ra) # 7ac4 <fork>
    5b32:	87aa                	mv	a5,a0
    5b34:	fef42423          	sw	a5,-24(s0)
  if(pid == 0){
    5b38:	fe842783          	lw	a5,-24(s0)
    5b3c:	2781                	sext.w	a5,a5
    5b3e:	ebc1                	bnez	a5,5bce <bigargtest+0xc0>
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    5b40:	fe042623          	sw	zero,-20(s0)
    5b44:	a01d                	j	5b6a <bigargtest+0x5c>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    5b46:	0000c717          	auipc	a4,0xc
    5b4a:	04270713          	addi	a4,a4,66 # 11b88 <args.1>
    5b4e:	fec42783          	lw	a5,-20(s0)
    5b52:	078e                	slli	a5,a5,0x3
    5b54:	97ba                	add	a5,a5,a4
    5b56:	00004717          	auipc	a4,0x4
    5b5a:	51a70713          	addi	a4,a4,1306 # a070 <malloc+0x1e84>
    5b5e:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    5b60:	fec42783          	lw	a5,-20(s0)
    5b64:	2785                	addiw	a5,a5,1
    5b66:	fef42623          	sw	a5,-20(s0)
    5b6a:	fec42783          	lw	a5,-20(s0)
    5b6e:	0007871b          	sext.w	a4,a5
    5b72:	47f9                	li	a5,30
    5b74:	fce7d9e3          	bge	a5,a4,5b46 <bigargtest+0x38>
    args[MAXARG-1] = 0;
    5b78:	0000c797          	auipc	a5,0xc
    5b7c:	01078793          	addi	a5,a5,16 # 11b88 <args.1>
    5b80:	0e07bc23          	sd	zero,248(a5)
    exec("echo", args);
    5b84:	0000c597          	auipc	a1,0xc
    5b88:	00458593          	addi	a1,a1,4 # 11b88 <args.1>
    5b8c:	00003517          	auipc	a0,0x3
    5b90:	9c450513          	addi	a0,a0,-1596 # 8550 <malloc+0x364>
    5b94:	00002097          	auipc	ra,0x2
    5b98:	f70080e7          	jalr	-144(ra) # 7b04 <exec>
    fd = open("bigarg-ok", O_CREATE);
    5b9c:	20000593          	li	a1,512
    5ba0:	00004517          	auipc	a0,0x4
    5ba4:	4c050513          	addi	a0,a0,1216 # a060 <malloc+0x1e74>
    5ba8:	00002097          	auipc	ra,0x2
    5bac:	f64080e7          	jalr	-156(ra) # 7b0c <open>
    5bb0:	87aa                	mv	a5,a0
    5bb2:	fef42223          	sw	a5,-28(s0)
    close(fd);
    5bb6:	fe442783          	lw	a5,-28(s0)
    5bba:	853e                	mv	a0,a5
    5bbc:	00002097          	auipc	ra,0x2
    5bc0:	f38080e7          	jalr	-200(ra) # 7af4 <close>
    exit(0);
    5bc4:	4501                	li	a0,0
    5bc6:	00002097          	auipc	ra,0x2
    5bca:	f06080e7          	jalr	-250(ra) # 7acc <exit>
  } else if(pid < 0){
    5bce:	fe842783          	lw	a5,-24(s0)
    5bd2:	2781                	sext.w	a5,a5
    5bd4:	0207d163          	bgez	a5,5bf6 <bigargtest+0xe8>
    printf("%s: bigargtest: fork failed\n", s);
    5bd8:	fd843583          	ld	a1,-40(s0)
    5bdc:	00004517          	auipc	a0,0x4
    5be0:	57450513          	addi	a0,a0,1396 # a150 <malloc+0x1f64>
    5be4:	00002097          	auipc	ra,0x2
    5be8:	414080e7          	jalr	1044(ra) # 7ff8 <printf>
    exit(1);
    5bec:	4505                	li	a0,1
    5bee:	00002097          	auipc	ra,0x2
    5bf2:	ede080e7          	jalr	-290(ra) # 7acc <exit>
  }
  
  wait(&xstatus);
    5bf6:	fe040793          	addi	a5,s0,-32
    5bfa:	853e                	mv	a0,a5
    5bfc:	00002097          	auipc	ra,0x2
    5c00:	ed8080e7          	jalr	-296(ra) # 7ad4 <wait>
  if(xstatus != 0)
    5c04:	fe042783          	lw	a5,-32(s0)
    5c08:	cb81                	beqz	a5,5c18 <bigargtest+0x10a>
    exit(xstatus);
    5c0a:	fe042783          	lw	a5,-32(s0)
    5c0e:	853e                	mv	a0,a5
    5c10:	00002097          	auipc	ra,0x2
    5c14:	ebc080e7          	jalr	-324(ra) # 7acc <exit>
  fd = open("bigarg-ok", 0);
    5c18:	4581                	li	a1,0
    5c1a:	00004517          	auipc	a0,0x4
    5c1e:	44650513          	addi	a0,a0,1094 # a060 <malloc+0x1e74>
    5c22:	00002097          	auipc	ra,0x2
    5c26:	eea080e7          	jalr	-278(ra) # 7b0c <open>
    5c2a:	87aa                	mv	a5,a0
    5c2c:	fef42223          	sw	a5,-28(s0)
  if(fd < 0){
    5c30:	fe442783          	lw	a5,-28(s0)
    5c34:	2781                	sext.w	a5,a5
    5c36:	0207d163          	bgez	a5,5c58 <bigargtest+0x14a>
    printf("%s: bigarg test failed!\n", s);
    5c3a:	fd843583          	ld	a1,-40(s0)
    5c3e:	00004517          	auipc	a0,0x4
    5c42:	53250513          	addi	a0,a0,1330 # a170 <malloc+0x1f84>
    5c46:	00002097          	auipc	ra,0x2
    5c4a:	3b2080e7          	jalr	946(ra) # 7ff8 <printf>
    exit(1);
    5c4e:	4505                	li	a0,1
    5c50:	00002097          	auipc	ra,0x2
    5c54:	e7c080e7          	jalr	-388(ra) # 7acc <exit>
  }
  close(fd);
    5c58:	fe442783          	lw	a5,-28(s0)
    5c5c:	853e                	mv	a0,a5
    5c5e:	00002097          	auipc	ra,0x2
    5c62:	e96080e7          	jalr	-362(ra) # 7af4 <close>
}
    5c66:	0001                	nop
    5c68:	70a2                	ld	ra,40(sp)
    5c6a:	7402                	ld	s0,32(sp)
    5c6c:	6145                	addi	sp,sp,48
    5c6e:	8082                	ret

0000000000005c70 <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    5c70:	7159                	addi	sp,sp,-112
    5c72:	f486                	sd	ra,104(sp)
    5c74:	f0a2                	sd	s0,96(sp)
    5c76:	1880                	addi	s0,sp,112
  int nfiles;
  int fsblocks = 0;
    5c78:	fe042423          	sw	zero,-24(s0)

  printf("fsfull test\n");
    5c7c:	00004517          	auipc	a0,0x4
    5c80:	51450513          	addi	a0,a0,1300 # a190 <malloc+0x1fa4>
    5c84:	00002097          	auipc	ra,0x2
    5c88:	374080e7          	jalr	884(ra) # 7ff8 <printf>

  for(nfiles = 0; ; nfiles++){
    5c8c:	fe042623          	sw	zero,-20(s0)
    char name[64];
    name[0] = 'f';
    5c90:	06600793          	li	a5,102
    5c94:	f8f40c23          	sb	a5,-104(s0)
    name[1] = '0' + nfiles / 1000;
    5c98:	fec42783          	lw	a5,-20(s0)
    5c9c:	86be                	mv	a3,a5
    5c9e:	0006871b          	sext.w	a4,a3
    5ca2:	106257b7          	lui	a5,0x10625
    5ca6:	dd378793          	addi	a5,a5,-557 # 10624dd3 <freep+0x1061313b>
    5caa:	02f707b3          	mul	a5,a4,a5
    5cae:	9381                	srli	a5,a5,0x20
    5cb0:	4067d79b          	sraiw	a5,a5,0x6
    5cb4:	873e                	mv	a4,a5
    5cb6:	41f6d79b          	sraiw	a5,a3,0x1f
    5cba:	40f707bb          	subw	a5,a4,a5
    5cbe:	2781                	sext.w	a5,a5
    5cc0:	0ff7f793          	zext.b	a5,a5
    5cc4:	0307879b          	addiw	a5,a5,48
    5cc8:	0ff7f793          	zext.b	a5,a5
    5ccc:	f8f40ca3          	sb	a5,-103(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    5cd0:	fec42783          	lw	a5,-20(s0)
    5cd4:	0007869b          	sext.w	a3,a5
    5cd8:	10625737          	lui	a4,0x10625
    5cdc:	dd370713          	addi	a4,a4,-557 # 10624dd3 <freep+0x1061313b>
    5ce0:	02e68733          	mul	a4,a3,a4
    5ce4:	9301                	srli	a4,a4,0x20
    5ce6:	4067571b          	sraiw	a4,a4,0x6
    5cea:	86ba                	mv	a3,a4
    5cec:	41f7d71b          	sraiw	a4,a5,0x1f
    5cf0:	40e6873b          	subw	a4,a3,a4
    5cf4:	86ba                	mv	a3,a4
    5cf6:	3e800713          	li	a4,1000
    5cfa:	02e6873b          	mulw	a4,a3,a4
    5cfe:	9f99                	subw	a5,a5,a4
    5d00:	2781                	sext.w	a5,a5
    5d02:	86be                	mv	a3,a5
    5d04:	0006871b          	sext.w	a4,a3
    5d08:	51eb87b7          	lui	a5,0x51eb8
    5d0c:	51f78793          	addi	a5,a5,1311 # 51eb851f <freep+0x51ea6887>
    5d10:	02f707b3          	mul	a5,a4,a5
    5d14:	9381                	srli	a5,a5,0x20
    5d16:	4057d79b          	sraiw	a5,a5,0x5
    5d1a:	873e                	mv	a4,a5
    5d1c:	41f6d79b          	sraiw	a5,a3,0x1f
    5d20:	40f707bb          	subw	a5,a4,a5
    5d24:	2781                	sext.w	a5,a5
    5d26:	0ff7f793          	zext.b	a5,a5
    5d2a:	0307879b          	addiw	a5,a5,48
    5d2e:	0ff7f793          	zext.b	a5,a5
    5d32:	f8f40d23          	sb	a5,-102(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5d36:	fec42783          	lw	a5,-20(s0)
    5d3a:	0007869b          	sext.w	a3,a5
    5d3e:	51eb8737          	lui	a4,0x51eb8
    5d42:	51f70713          	addi	a4,a4,1311 # 51eb851f <freep+0x51ea6887>
    5d46:	02e68733          	mul	a4,a3,a4
    5d4a:	9301                	srli	a4,a4,0x20
    5d4c:	4057571b          	sraiw	a4,a4,0x5
    5d50:	86ba                	mv	a3,a4
    5d52:	41f7d71b          	sraiw	a4,a5,0x1f
    5d56:	40e6873b          	subw	a4,a3,a4
    5d5a:	86ba                	mv	a3,a4
    5d5c:	06400713          	li	a4,100
    5d60:	02e6873b          	mulw	a4,a3,a4
    5d64:	9f99                	subw	a5,a5,a4
    5d66:	2781                	sext.w	a5,a5
    5d68:	86be                	mv	a3,a5
    5d6a:	0006871b          	sext.w	a4,a3
    5d6e:	666667b7          	lui	a5,0x66666
    5d72:	66778793          	addi	a5,a5,1639 # 66666667 <freep+0x666549cf>
    5d76:	02f707b3          	mul	a5,a4,a5
    5d7a:	9381                	srli	a5,a5,0x20
    5d7c:	4027d79b          	sraiw	a5,a5,0x2
    5d80:	873e                	mv	a4,a5
    5d82:	41f6d79b          	sraiw	a5,a3,0x1f
    5d86:	40f707bb          	subw	a5,a4,a5
    5d8a:	2781                	sext.w	a5,a5
    5d8c:	0ff7f793          	zext.b	a5,a5
    5d90:	0307879b          	addiw	a5,a5,48
    5d94:	0ff7f793          	zext.b	a5,a5
    5d98:	f8f40da3          	sb	a5,-101(s0)
    name[4] = '0' + (nfiles % 10);
    5d9c:	fec42783          	lw	a5,-20(s0)
    5da0:	873e                	mv	a4,a5
    5da2:	0007069b          	sext.w	a3,a4
    5da6:	666667b7          	lui	a5,0x66666
    5daa:	66778793          	addi	a5,a5,1639 # 66666667 <freep+0x666549cf>
    5dae:	02f687b3          	mul	a5,a3,a5
    5db2:	9381                	srli	a5,a5,0x20
    5db4:	4027d79b          	sraiw	a5,a5,0x2
    5db8:	86be                	mv	a3,a5
    5dba:	41f7579b          	sraiw	a5,a4,0x1f
    5dbe:	40f687bb          	subw	a5,a3,a5
    5dc2:	86be                	mv	a3,a5
    5dc4:	87b6                	mv	a5,a3
    5dc6:	0027979b          	slliw	a5,a5,0x2
    5dca:	9fb5                	addw	a5,a5,a3
    5dcc:	0017979b          	slliw	a5,a5,0x1
    5dd0:	40f707bb          	subw	a5,a4,a5
    5dd4:	2781                	sext.w	a5,a5
    5dd6:	0ff7f793          	zext.b	a5,a5
    5dda:	0307879b          	addiw	a5,a5,48
    5dde:	0ff7f793          	zext.b	a5,a5
    5de2:	f8f40e23          	sb	a5,-100(s0)
    name[5] = '\0';
    5de6:	f8040ea3          	sb	zero,-99(s0)
    printf("writing %s\n", name);
    5dea:	f9840793          	addi	a5,s0,-104
    5dee:	85be                	mv	a1,a5
    5df0:	00004517          	auipc	a0,0x4
    5df4:	3b050513          	addi	a0,a0,944 # a1a0 <malloc+0x1fb4>
    5df8:	00002097          	auipc	ra,0x2
    5dfc:	200080e7          	jalr	512(ra) # 7ff8 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    5e00:	f9840793          	addi	a5,s0,-104
    5e04:	20200593          	li	a1,514
    5e08:	853e                	mv	a0,a5
    5e0a:	00002097          	auipc	ra,0x2
    5e0e:	d02080e7          	jalr	-766(ra) # 7b0c <open>
    5e12:	87aa                	mv	a5,a0
    5e14:	fef42023          	sw	a5,-32(s0)
    if(fd < 0){
    5e18:	fe042783          	lw	a5,-32(s0)
    5e1c:	2781                	sext.w	a5,a5
    5e1e:	0007de63          	bgez	a5,5e3a <fsfull+0x1ca>
      printf("open %s failed\n", name);
    5e22:	f9840793          	addi	a5,s0,-104
    5e26:	85be                	mv	a1,a5
    5e28:	00004517          	auipc	a0,0x4
    5e2c:	38850513          	addi	a0,a0,904 # a1b0 <malloc+0x1fc4>
    5e30:	00002097          	auipc	ra,0x2
    5e34:	1c8080e7          	jalr	456(ra) # 7ff8 <printf>
      break;
    5e38:	a079                	j	5ec6 <fsfull+0x256>
    }
    int total = 0;
    5e3a:	fe042223          	sw	zero,-28(s0)
    while(1){
      int cc = write(fd, buf, BSIZE);
    5e3e:	fe042783          	lw	a5,-32(s0)
    5e42:	40000613          	li	a2,1024
    5e46:	00005597          	auipc	a1,0x5
    5e4a:	62a58593          	addi	a1,a1,1578 # b470 <buf>
    5e4e:	853e                	mv	a0,a5
    5e50:	00002097          	auipc	ra,0x2
    5e54:	c9c080e7          	jalr	-868(ra) # 7aec <write>
    5e58:	87aa                	mv	a5,a0
    5e5a:	fcf42e23          	sw	a5,-36(s0)
      if(cc < BSIZE)
    5e5e:	fdc42783          	lw	a5,-36(s0)
    5e62:	0007871b          	sext.w	a4,a5
    5e66:	3ff00793          	li	a5,1023
    5e6a:	02e7d063          	bge	a5,a4,5e8a <fsfull+0x21a>
        break;
      total += cc;
    5e6e:	fe442783          	lw	a5,-28(s0)
    5e72:	873e                	mv	a4,a5
    5e74:	fdc42783          	lw	a5,-36(s0)
    5e78:	9fb9                	addw	a5,a5,a4
    5e7a:	fef42223          	sw	a5,-28(s0)
      fsblocks++;
    5e7e:	fe842783          	lw	a5,-24(s0)
    5e82:	2785                	addiw	a5,a5,1
    5e84:	fef42423          	sw	a5,-24(s0)
    while(1){
    5e88:	bf5d                	j	5e3e <fsfull+0x1ce>
        break;
    5e8a:	0001                	nop
    }
    printf("wrote %d bytes\n", total);
    5e8c:	fe442783          	lw	a5,-28(s0)
    5e90:	85be                	mv	a1,a5
    5e92:	00004517          	auipc	a0,0x4
    5e96:	32e50513          	addi	a0,a0,814 # a1c0 <malloc+0x1fd4>
    5e9a:	00002097          	auipc	ra,0x2
    5e9e:	15e080e7          	jalr	350(ra) # 7ff8 <printf>
    close(fd);
    5ea2:	fe042783          	lw	a5,-32(s0)
    5ea6:	853e                	mv	a0,a5
    5ea8:	00002097          	auipc	ra,0x2
    5eac:	c4c080e7          	jalr	-948(ra) # 7af4 <close>
    if(total == 0)
    5eb0:	fe442783          	lw	a5,-28(s0)
    5eb4:	2781                	sext.w	a5,a5
    5eb6:	c799                	beqz	a5,5ec4 <fsfull+0x254>
  for(nfiles = 0; ; nfiles++){
    5eb8:	fec42783          	lw	a5,-20(s0)
    5ebc:	2785                	addiw	a5,a5,1
    5ebe:	fef42623          	sw	a5,-20(s0)
    5ec2:	b3f9                	j	5c90 <fsfull+0x20>
      break;
    5ec4:	0001                	nop
  }

  while(nfiles >= 0){
    5ec6:	aa95                	j	603a <fsfull+0x3ca>
    char name[64];
    name[0] = 'f';
    5ec8:	06600793          	li	a5,102
    5ecc:	f8f40c23          	sb	a5,-104(s0)
    name[1] = '0' + nfiles / 1000;
    5ed0:	fec42783          	lw	a5,-20(s0)
    5ed4:	86be                	mv	a3,a5
    5ed6:	0006871b          	sext.w	a4,a3
    5eda:	106257b7          	lui	a5,0x10625
    5ede:	dd378793          	addi	a5,a5,-557 # 10624dd3 <freep+0x1061313b>
    5ee2:	02f707b3          	mul	a5,a4,a5
    5ee6:	9381                	srli	a5,a5,0x20
    5ee8:	4067d79b          	sraiw	a5,a5,0x6
    5eec:	873e                	mv	a4,a5
    5eee:	41f6d79b          	sraiw	a5,a3,0x1f
    5ef2:	40f707bb          	subw	a5,a4,a5
    5ef6:	2781                	sext.w	a5,a5
    5ef8:	0ff7f793          	zext.b	a5,a5
    5efc:	0307879b          	addiw	a5,a5,48
    5f00:	0ff7f793          	zext.b	a5,a5
    5f04:	f8f40ca3          	sb	a5,-103(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    5f08:	fec42783          	lw	a5,-20(s0)
    5f0c:	0007869b          	sext.w	a3,a5
    5f10:	10625737          	lui	a4,0x10625
    5f14:	dd370713          	addi	a4,a4,-557 # 10624dd3 <freep+0x1061313b>
    5f18:	02e68733          	mul	a4,a3,a4
    5f1c:	9301                	srli	a4,a4,0x20
    5f1e:	4067571b          	sraiw	a4,a4,0x6
    5f22:	86ba                	mv	a3,a4
    5f24:	41f7d71b          	sraiw	a4,a5,0x1f
    5f28:	40e6873b          	subw	a4,a3,a4
    5f2c:	86ba                	mv	a3,a4
    5f2e:	3e800713          	li	a4,1000
    5f32:	02e6873b          	mulw	a4,a3,a4
    5f36:	9f99                	subw	a5,a5,a4
    5f38:	2781                	sext.w	a5,a5
    5f3a:	86be                	mv	a3,a5
    5f3c:	0006871b          	sext.w	a4,a3
    5f40:	51eb87b7          	lui	a5,0x51eb8
    5f44:	51f78793          	addi	a5,a5,1311 # 51eb851f <freep+0x51ea6887>
    5f48:	02f707b3          	mul	a5,a4,a5
    5f4c:	9381                	srli	a5,a5,0x20
    5f4e:	4057d79b          	sraiw	a5,a5,0x5
    5f52:	873e                	mv	a4,a5
    5f54:	41f6d79b          	sraiw	a5,a3,0x1f
    5f58:	40f707bb          	subw	a5,a4,a5
    5f5c:	2781                	sext.w	a5,a5
    5f5e:	0ff7f793          	zext.b	a5,a5
    5f62:	0307879b          	addiw	a5,a5,48
    5f66:	0ff7f793          	zext.b	a5,a5
    5f6a:	f8f40d23          	sb	a5,-102(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5f6e:	fec42783          	lw	a5,-20(s0)
    5f72:	0007869b          	sext.w	a3,a5
    5f76:	51eb8737          	lui	a4,0x51eb8
    5f7a:	51f70713          	addi	a4,a4,1311 # 51eb851f <freep+0x51ea6887>
    5f7e:	02e68733          	mul	a4,a3,a4
    5f82:	9301                	srli	a4,a4,0x20
    5f84:	4057571b          	sraiw	a4,a4,0x5
    5f88:	86ba                	mv	a3,a4
    5f8a:	41f7d71b          	sraiw	a4,a5,0x1f
    5f8e:	40e6873b          	subw	a4,a3,a4
    5f92:	86ba                	mv	a3,a4
    5f94:	06400713          	li	a4,100
    5f98:	02e6873b          	mulw	a4,a3,a4
    5f9c:	9f99                	subw	a5,a5,a4
    5f9e:	2781                	sext.w	a5,a5
    5fa0:	86be                	mv	a3,a5
    5fa2:	0006871b          	sext.w	a4,a3
    5fa6:	666667b7          	lui	a5,0x66666
    5faa:	66778793          	addi	a5,a5,1639 # 66666667 <freep+0x666549cf>
    5fae:	02f707b3          	mul	a5,a4,a5
    5fb2:	9381                	srli	a5,a5,0x20
    5fb4:	4027d79b          	sraiw	a5,a5,0x2
    5fb8:	873e                	mv	a4,a5
    5fba:	41f6d79b          	sraiw	a5,a3,0x1f
    5fbe:	40f707bb          	subw	a5,a4,a5
    5fc2:	2781                	sext.w	a5,a5
    5fc4:	0ff7f793          	zext.b	a5,a5
    5fc8:	0307879b          	addiw	a5,a5,48
    5fcc:	0ff7f793          	zext.b	a5,a5
    5fd0:	f8f40da3          	sb	a5,-101(s0)
    name[4] = '0' + (nfiles % 10);
    5fd4:	fec42783          	lw	a5,-20(s0)
    5fd8:	873e                	mv	a4,a5
    5fda:	0007069b          	sext.w	a3,a4
    5fde:	666667b7          	lui	a5,0x66666
    5fe2:	66778793          	addi	a5,a5,1639 # 66666667 <freep+0x666549cf>
    5fe6:	02f687b3          	mul	a5,a3,a5
    5fea:	9381                	srli	a5,a5,0x20
    5fec:	4027d79b          	sraiw	a5,a5,0x2
    5ff0:	86be                	mv	a3,a5
    5ff2:	41f7579b          	sraiw	a5,a4,0x1f
    5ff6:	40f687bb          	subw	a5,a3,a5
    5ffa:	86be                	mv	a3,a5
    5ffc:	87b6                	mv	a5,a3
    5ffe:	0027979b          	slliw	a5,a5,0x2
    6002:	9fb5                	addw	a5,a5,a3
    6004:	0017979b          	slliw	a5,a5,0x1
    6008:	40f707bb          	subw	a5,a4,a5
    600c:	2781                	sext.w	a5,a5
    600e:	0ff7f793          	zext.b	a5,a5
    6012:	0307879b          	addiw	a5,a5,48
    6016:	0ff7f793          	zext.b	a5,a5
    601a:	f8f40e23          	sb	a5,-100(s0)
    name[5] = '\0';
    601e:	f8040ea3          	sb	zero,-99(s0)
    unlink(name);
    6022:	f9840793          	addi	a5,s0,-104
    6026:	853e                	mv	a0,a5
    6028:	00002097          	auipc	ra,0x2
    602c:	af4080e7          	jalr	-1292(ra) # 7b1c <unlink>
    nfiles--;
    6030:	fec42783          	lw	a5,-20(s0)
    6034:	37fd                	addiw	a5,a5,-1
    6036:	fef42623          	sw	a5,-20(s0)
  while(nfiles >= 0){
    603a:	fec42783          	lw	a5,-20(s0)
    603e:	2781                	sext.w	a5,a5
    6040:	e807d4e3          	bgez	a5,5ec8 <fsfull+0x258>
  }

  printf("fsfull test finished\n");
    6044:	00004517          	auipc	a0,0x4
    6048:	18c50513          	addi	a0,a0,396 # a1d0 <malloc+0x1fe4>
    604c:	00002097          	auipc	ra,0x2
    6050:	fac080e7          	jalr	-84(ra) # 7ff8 <printf>
}
    6054:	0001                	nop
    6056:	70a6                	ld	ra,104(sp)
    6058:	7406                	ld	s0,96(sp)
    605a:	6165                	addi	sp,sp,112
    605c:	8082                	ret

000000000000605e <argptest>:

void argptest(char *s)
{
    605e:	7179                	addi	sp,sp,-48
    6060:	f406                	sd	ra,40(sp)
    6062:	f022                	sd	s0,32(sp)
    6064:	1800                	addi	s0,sp,48
    6066:	fca43c23          	sd	a0,-40(s0)
  int fd;
  fd = open("init", O_RDONLY);
    606a:	4581                	li	a1,0
    606c:	00004517          	auipc	a0,0x4
    6070:	17c50513          	addi	a0,a0,380 # a1e8 <malloc+0x1ffc>
    6074:	00002097          	auipc	ra,0x2
    6078:	a98080e7          	jalr	-1384(ra) # 7b0c <open>
    607c:	87aa                	mv	a5,a0
    607e:	fef42623          	sw	a5,-20(s0)
  if (fd < 0) {
    6082:	fec42783          	lw	a5,-20(s0)
    6086:	2781                	sext.w	a5,a5
    6088:	0207d163          	bgez	a5,60aa <argptest+0x4c>
    printf("%s: open failed\n", s);
    608c:	fd843583          	ld	a1,-40(s0)
    6090:	00002517          	auipc	a0,0x2
    6094:	6f850513          	addi	a0,a0,1784 # 8788 <malloc+0x59c>
    6098:	00002097          	auipc	ra,0x2
    609c:	f60080e7          	jalr	-160(ra) # 7ff8 <printf>
    exit(1);
    60a0:	4505                	li	a0,1
    60a2:	00002097          	auipc	ra,0x2
    60a6:	a2a080e7          	jalr	-1494(ra) # 7acc <exit>
  }
  read(fd, sbrk(0) - 1, -1);
    60aa:	4501                	li	a0,0
    60ac:	00002097          	auipc	ra,0x2
    60b0:	aa8080e7          	jalr	-1368(ra) # 7b54 <sbrk>
    60b4:	87aa                	mv	a5,a0
    60b6:	fff78713          	addi	a4,a5,-1
    60ba:	fec42783          	lw	a5,-20(s0)
    60be:	567d                	li	a2,-1
    60c0:	85ba                	mv	a1,a4
    60c2:	853e                	mv	a0,a5
    60c4:	00002097          	auipc	ra,0x2
    60c8:	a20080e7          	jalr	-1504(ra) # 7ae4 <read>
  close(fd);
    60cc:	fec42783          	lw	a5,-20(s0)
    60d0:	853e                	mv	a0,a5
    60d2:	00002097          	auipc	ra,0x2
    60d6:	a22080e7          	jalr	-1502(ra) # 7af4 <close>
}
    60da:	0001                	nop
    60dc:	70a2                	ld	ra,40(sp)
    60de:	7402                	ld	s0,32(sp)
    60e0:	6145                	addi	sp,sp,48
    60e2:	8082                	ret

00000000000060e4 <stacktest>:

// check that there's an invalid page beneath
// the user stack, to catch stack overflow.
void
stacktest(char *s)
{
    60e4:	7139                	addi	sp,sp,-64
    60e6:	fc06                	sd	ra,56(sp)
    60e8:	f822                	sd	s0,48(sp)
    60ea:	0080                	addi	s0,sp,64
    60ec:	fca43423          	sd	a0,-56(s0)
  int pid;
  int xstatus;
  
  pid = fork();
    60f0:	00002097          	auipc	ra,0x2
    60f4:	9d4080e7          	jalr	-1580(ra) # 7ac4 <fork>
    60f8:	87aa                	mv	a5,a0
    60fa:	fef42623          	sw	a5,-20(s0)
  if(pid == 0) {
    60fe:	fec42783          	lw	a5,-20(s0)
    6102:	2781                	sext.w	a5,a5
    6104:	e3b9                	bnez	a5,614a <stacktest+0x66>
    char *sp = (char *) r_sp();
    6106:	ffffa097          	auipc	ra,0xffffa
    610a:	efa080e7          	jalr	-262(ra) # 0 <r_sp>
    610e:	87aa                	mv	a5,a0
    6110:	fef43023          	sd	a5,-32(s0)
    sp -= PGSIZE;
    6114:	fe043703          	ld	a4,-32(s0)
    6118:	77fd                	lui	a5,0xfffff
    611a:	97ba                	add	a5,a5,a4
    611c:	fef43023          	sd	a5,-32(s0)
    // the *sp should cause a trap.
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    6120:	fe043783          	ld	a5,-32(s0)
    6124:	0007c783          	lbu	a5,0(a5) # fffffffffffff000 <freep+0xfffffffffffed368>
    6128:	2781                	sext.w	a5,a5
    612a:	863e                	mv	a2,a5
    612c:	fc843583          	ld	a1,-56(s0)
    6130:	00004517          	auipc	a0,0x4
    6134:	0c050513          	addi	a0,a0,192 # a1f0 <malloc+0x2004>
    6138:	00002097          	auipc	ra,0x2
    613c:	ec0080e7          	jalr	-320(ra) # 7ff8 <printf>
    exit(1);
    6140:	4505                	li	a0,1
    6142:	00002097          	auipc	ra,0x2
    6146:	98a080e7          	jalr	-1654(ra) # 7acc <exit>
  } else if(pid < 0){
    614a:	fec42783          	lw	a5,-20(s0)
    614e:	2781                	sext.w	a5,a5
    6150:	0207d163          	bgez	a5,6172 <stacktest+0x8e>
    printf("%s: fork failed\n", s);
    6154:	fc843583          	ld	a1,-56(s0)
    6158:	00002517          	auipc	a0,0x2
    615c:	61850513          	addi	a0,a0,1560 # 8770 <malloc+0x584>
    6160:	00002097          	auipc	ra,0x2
    6164:	e98080e7          	jalr	-360(ra) # 7ff8 <printf>
    exit(1);
    6168:	4505                	li	a0,1
    616a:	00002097          	auipc	ra,0x2
    616e:	962080e7          	jalr	-1694(ra) # 7acc <exit>
  }
  wait(&xstatus);
    6172:	fdc40793          	addi	a5,s0,-36
    6176:	853e                	mv	a0,a5
    6178:	00002097          	auipc	ra,0x2
    617c:	95c080e7          	jalr	-1700(ra) # 7ad4 <wait>
  if(xstatus == -1)  // kernel killed child?
    6180:	fdc42703          	lw	a4,-36(s0)
    6184:	57fd                	li	a5,-1
    6186:	00f71763          	bne	a4,a5,6194 <stacktest+0xb0>
    exit(0);
    618a:	4501                	li	a0,0
    618c:	00002097          	auipc	ra,0x2
    6190:	940080e7          	jalr	-1728(ra) # 7acc <exit>
  else
    exit(xstatus);
    6194:	fdc42783          	lw	a5,-36(s0)
    6198:	853e                	mv	a0,a5
    619a:	00002097          	auipc	ra,0x2
    619e:	932080e7          	jalr	-1742(ra) # 7acc <exit>

00000000000061a2 <textwrite>:
}

// check that writes to text segment fault
void
textwrite(char *s)
{
    61a2:	7139                	addi	sp,sp,-64
    61a4:	fc06                	sd	ra,56(sp)
    61a6:	f822                	sd	s0,48(sp)
    61a8:	0080                	addi	s0,sp,64
    61aa:	fca43423          	sd	a0,-56(s0)
  int pid;
  int xstatus;
  
  pid = fork();
    61ae:	00002097          	auipc	ra,0x2
    61b2:	916080e7          	jalr	-1770(ra) # 7ac4 <fork>
    61b6:	87aa                	mv	a5,a0
    61b8:	fef42623          	sw	a5,-20(s0)
  if(pid == 0) {
    61bc:	fec42783          	lw	a5,-20(s0)
    61c0:	2781                	sext.w	a5,a5
    61c2:	ef81                	bnez	a5,61da <textwrite+0x38>
    volatile int *addr = (int *) 0;
    61c4:	fe043023          	sd	zero,-32(s0)
    *addr = 10;
    61c8:	fe043783          	ld	a5,-32(s0)
    61cc:	4729                	li	a4,10
    61ce:	c398                	sw	a4,0(a5)
    exit(1);
    61d0:	4505                	li	a0,1
    61d2:	00002097          	auipc	ra,0x2
    61d6:	8fa080e7          	jalr	-1798(ra) # 7acc <exit>
  } else if(pid < 0){
    61da:	fec42783          	lw	a5,-20(s0)
    61de:	2781                	sext.w	a5,a5
    61e0:	0207d163          	bgez	a5,6202 <textwrite+0x60>
    printf("%s: fork failed\n", s);
    61e4:	fc843583          	ld	a1,-56(s0)
    61e8:	00002517          	auipc	a0,0x2
    61ec:	58850513          	addi	a0,a0,1416 # 8770 <malloc+0x584>
    61f0:	00002097          	auipc	ra,0x2
    61f4:	e08080e7          	jalr	-504(ra) # 7ff8 <printf>
    exit(1);
    61f8:	4505                	li	a0,1
    61fa:	00002097          	auipc	ra,0x2
    61fe:	8d2080e7          	jalr	-1838(ra) # 7acc <exit>
  }
  wait(&xstatus);
    6202:	fdc40793          	addi	a5,s0,-36
    6206:	853e                	mv	a0,a5
    6208:	00002097          	auipc	ra,0x2
    620c:	8cc080e7          	jalr	-1844(ra) # 7ad4 <wait>
  if(xstatus == -1)  // kernel killed child?
    6210:	fdc42703          	lw	a4,-36(s0)
    6214:	57fd                	li	a5,-1
    6216:	00f71763          	bne	a4,a5,6224 <textwrite+0x82>
    exit(0);
    621a:	4501                	li	a0,0
    621c:	00002097          	auipc	ra,0x2
    6220:	8b0080e7          	jalr	-1872(ra) # 7acc <exit>
  else
    exit(xstatus);
    6224:	fdc42783          	lw	a5,-36(s0)
    6228:	853e                	mv	a0,a5
    622a:	00002097          	auipc	ra,0x2
    622e:	8a2080e7          	jalr	-1886(ra) # 7acc <exit>

0000000000006232 <pgbug>:
// the virtual page address to uint, which (with certain wild system
// call arguments) resulted in a kernel page faults.
void *big = (void*) 0xeaeb0b5b00002f5e;
void
pgbug(char *s)
{
    6232:	7179                	addi	sp,sp,-48
    6234:	f406                	sd	ra,40(sp)
    6236:	f022                	sd	s0,32(sp)
    6238:	1800                	addi	s0,sp,48
    623a:	fca43c23          	sd	a0,-40(s0)
  char *argv[1];
  argv[0] = 0;
    623e:	fe043423          	sd	zero,-24(s0)
  exec(big, argv);
    6242:	00005797          	auipc	a5,0x5
    6246:	dbe78793          	addi	a5,a5,-578 # b000 <big>
    624a:	639c                	ld	a5,0(a5)
    624c:	fe840713          	addi	a4,s0,-24
    6250:	85ba                	mv	a1,a4
    6252:	853e                	mv	a0,a5
    6254:	00002097          	auipc	ra,0x2
    6258:	8b0080e7          	jalr	-1872(ra) # 7b04 <exec>
  pipe(big);
    625c:	00005797          	auipc	a5,0x5
    6260:	da478793          	addi	a5,a5,-604 # b000 <big>
    6264:	639c                	ld	a5,0(a5)
    6266:	853e                	mv	a0,a5
    6268:	00002097          	auipc	ra,0x2
    626c:	874080e7          	jalr	-1932(ra) # 7adc <pipe>

  exit(0);
    6270:	4501                	li	a0,0
    6272:	00002097          	auipc	ra,0x2
    6276:	85a080e7          	jalr	-1958(ra) # 7acc <exit>

000000000000627a <sbrkbugs>:
// regression test. does the kernel panic if a process sbrk()s its
// size to be less than a page, or zero, or reduces the break by an
// amount too small to cause a page to be freed?
void
sbrkbugs(char *s)
{
    627a:	7179                	addi	sp,sp,-48
    627c:	f406                	sd	ra,40(sp)
    627e:	f022                	sd	s0,32(sp)
    6280:	1800                	addi	s0,sp,48
    6282:	fca43c23          	sd	a0,-40(s0)
  int pid = fork();
    6286:	00002097          	auipc	ra,0x2
    628a:	83e080e7          	jalr	-1986(ra) # 7ac4 <fork>
    628e:	87aa                	mv	a5,a0
    6290:	fef42623          	sw	a5,-20(s0)
  if(pid < 0){
    6294:	fec42783          	lw	a5,-20(s0)
    6298:	2781                	sext.w	a5,a5
    629a:	0007df63          	bgez	a5,62b8 <sbrkbugs+0x3e>
    printf("fork failed\n");
    629e:	00002517          	auipc	a0,0x2
    62a2:	2a250513          	addi	a0,a0,674 # 8540 <malloc+0x354>
    62a6:	00002097          	auipc	ra,0x2
    62aa:	d52080e7          	jalr	-686(ra) # 7ff8 <printf>
    exit(1);
    62ae:	4505                	li	a0,1
    62b0:	00002097          	auipc	ra,0x2
    62b4:	81c080e7          	jalr	-2020(ra) # 7acc <exit>
  }
  if(pid == 0){
    62b8:	fec42783          	lw	a5,-20(s0)
    62bc:	2781                	sext.w	a5,a5
    62be:	eb85                	bnez	a5,62ee <sbrkbugs+0x74>
    int sz = (uint64) sbrk(0);
    62c0:	4501                	li	a0,0
    62c2:	00002097          	auipc	ra,0x2
    62c6:	892080e7          	jalr	-1902(ra) # 7b54 <sbrk>
    62ca:	87aa                	mv	a5,a0
    62cc:	fef42223          	sw	a5,-28(s0)
    // free all user memory; there used to be a bug that
    // would not adjust p->sz correctly in this case,
    // causing exit() to panic.
    sbrk(-sz);
    62d0:	fe442783          	lw	a5,-28(s0)
    62d4:	40f007bb          	negw	a5,a5
    62d8:	2781                	sext.w	a5,a5
    62da:	853e                	mv	a0,a5
    62dc:	00002097          	auipc	ra,0x2
    62e0:	878080e7          	jalr	-1928(ra) # 7b54 <sbrk>
    // user page fault here.
    exit(0);
    62e4:	4501                	li	a0,0
    62e6:	00001097          	auipc	ra,0x1
    62ea:	7e6080e7          	jalr	2022(ra) # 7acc <exit>
  }
  wait(0);
    62ee:	4501                	li	a0,0
    62f0:	00001097          	auipc	ra,0x1
    62f4:	7e4080e7          	jalr	2020(ra) # 7ad4 <wait>

  pid = fork();
    62f8:	00001097          	auipc	ra,0x1
    62fc:	7cc080e7          	jalr	1996(ra) # 7ac4 <fork>
    6300:	87aa                	mv	a5,a0
    6302:	fef42623          	sw	a5,-20(s0)
  if(pid < 0){
    6306:	fec42783          	lw	a5,-20(s0)
    630a:	2781                	sext.w	a5,a5
    630c:	0007df63          	bgez	a5,632a <sbrkbugs+0xb0>
    printf("fork failed\n");
    6310:	00002517          	auipc	a0,0x2
    6314:	23050513          	addi	a0,a0,560 # 8540 <malloc+0x354>
    6318:	00002097          	auipc	ra,0x2
    631c:	ce0080e7          	jalr	-800(ra) # 7ff8 <printf>
    exit(1);
    6320:	4505                	li	a0,1
    6322:	00001097          	auipc	ra,0x1
    6326:	7aa080e7          	jalr	1962(ra) # 7acc <exit>
  }
  if(pid == 0){
    632a:	fec42783          	lw	a5,-20(s0)
    632e:	2781                	sext.w	a5,a5
    6330:	eb95                	bnez	a5,6364 <sbrkbugs+0xea>
    int sz = (uint64) sbrk(0);
    6332:	4501                	li	a0,0
    6334:	00002097          	auipc	ra,0x2
    6338:	820080e7          	jalr	-2016(ra) # 7b54 <sbrk>
    633c:	87aa                	mv	a5,a0
    633e:	fef42423          	sw	a5,-24(s0)
    // set the break to somewhere in the very first
    // page; there used to be a bug that would incorrectly
    // free the first page.
    sbrk(-(sz - 3500));
    6342:	6785                	lui	a5,0x1
    6344:	dac7879b          	addiw	a5,a5,-596 # dac <truncate2+0x4c>
    6348:	fe842703          	lw	a4,-24(s0)
    634c:	9f99                	subw	a5,a5,a4
    634e:	2781                	sext.w	a5,a5
    6350:	853e                	mv	a0,a5
    6352:	00002097          	auipc	ra,0x2
    6356:	802080e7          	jalr	-2046(ra) # 7b54 <sbrk>
    exit(0);
    635a:	4501                	li	a0,0
    635c:	00001097          	auipc	ra,0x1
    6360:	770080e7          	jalr	1904(ra) # 7acc <exit>
  }
  wait(0);
    6364:	4501                	li	a0,0
    6366:	00001097          	auipc	ra,0x1
    636a:	76e080e7          	jalr	1902(ra) # 7ad4 <wait>

  pid = fork();
    636e:	00001097          	auipc	ra,0x1
    6372:	756080e7          	jalr	1878(ra) # 7ac4 <fork>
    6376:	87aa                	mv	a5,a0
    6378:	fef42623          	sw	a5,-20(s0)
  if(pid < 0){
    637c:	fec42783          	lw	a5,-20(s0)
    6380:	2781                	sext.w	a5,a5
    6382:	0007df63          	bgez	a5,63a0 <sbrkbugs+0x126>
    printf("fork failed\n");
    6386:	00002517          	auipc	a0,0x2
    638a:	1ba50513          	addi	a0,a0,442 # 8540 <malloc+0x354>
    638e:	00002097          	auipc	ra,0x2
    6392:	c6a080e7          	jalr	-918(ra) # 7ff8 <printf>
    exit(1);
    6396:	4505                	li	a0,1
    6398:	00001097          	auipc	ra,0x1
    639c:	734080e7          	jalr	1844(ra) # 7acc <exit>
  }
  if(pid == 0){
    63a0:	fec42783          	lw	a5,-20(s0)
    63a4:	2781                	sext.w	a5,a5
    63a6:	ef8d                	bnez	a5,63e0 <sbrkbugs+0x166>
    // set the break in the middle of a page.
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    63a8:	4501                	li	a0,0
    63aa:	00001097          	auipc	ra,0x1
    63ae:	7aa080e7          	jalr	1962(ra) # 7b54 <sbrk>
    63b2:	87aa                	mv	a5,a0
    63b4:	2781                	sext.w	a5,a5
    63b6:	672d                	lui	a4,0xb
    63b8:	8007071b          	addiw	a4,a4,-2048 # a800 <malloc+0x2614>
    63bc:	40f707bb          	subw	a5,a4,a5
    63c0:	2781                	sext.w	a5,a5
    63c2:	853e                	mv	a0,a5
    63c4:	00001097          	auipc	ra,0x1
    63c8:	790080e7          	jalr	1936(ra) # 7b54 <sbrk>

    // reduce the break a bit, but not enough to
    // cause a page to be freed. this used to cause
    // a panic.
    sbrk(-10);
    63cc:	5559                	li	a0,-10
    63ce:	00001097          	auipc	ra,0x1
    63d2:	786080e7          	jalr	1926(ra) # 7b54 <sbrk>

    exit(0);
    63d6:	4501                	li	a0,0
    63d8:	00001097          	auipc	ra,0x1
    63dc:	6f4080e7          	jalr	1780(ra) # 7acc <exit>
  }
  wait(0);
    63e0:	4501                	li	a0,0
    63e2:	00001097          	auipc	ra,0x1
    63e6:	6f2080e7          	jalr	1778(ra) # 7ad4 <wait>

  exit(0);
    63ea:	4501                	li	a0,0
    63ec:	00001097          	auipc	ra,0x1
    63f0:	6e0080e7          	jalr	1760(ra) # 7acc <exit>

00000000000063f4 <sbrklast>:
// if process size was somewhat more than a page boundary, and then
// shrunk to be somewhat less than that page boundary, can the kernel
// still copyin() from addresses in the last page?
void
sbrklast(char *s)
{
    63f4:	7139                	addi	sp,sp,-64
    63f6:	fc06                	sd	ra,56(sp)
    63f8:	f822                	sd	s0,48(sp)
    63fa:	0080                	addi	s0,sp,64
    63fc:	fca43423          	sd	a0,-56(s0)
  uint64 top = (uint64) sbrk(0);
    6400:	4501                	li	a0,0
    6402:	00001097          	auipc	ra,0x1
    6406:	752080e7          	jalr	1874(ra) # 7b54 <sbrk>
    640a:	87aa                	mv	a5,a0
    640c:	fef43423          	sd	a5,-24(s0)
  if((top % 4096) != 0)
    6410:	fe843703          	ld	a4,-24(s0)
    6414:	6785                	lui	a5,0x1
    6416:	17fd                	addi	a5,a5,-1 # fff <truncate3+0x1b1>
    6418:	8ff9                	and	a5,a5,a4
    641a:	c395                	beqz	a5,643e <sbrklast+0x4a>
    sbrk(4096 - (top % 4096));
    641c:	fe843783          	ld	a5,-24(s0)
    6420:	2781                	sext.w	a5,a5
    6422:	873e                	mv	a4,a5
    6424:	6785                	lui	a5,0x1
    6426:	17fd                	addi	a5,a5,-1 # fff <truncate3+0x1b1>
    6428:	8ff9                	and	a5,a5,a4
    642a:	2781                	sext.w	a5,a5
    642c:	6705                	lui	a4,0x1
    642e:	40f707bb          	subw	a5,a4,a5
    6432:	2781                	sext.w	a5,a5
    6434:	853e                	mv	a0,a5
    6436:	00001097          	auipc	ra,0x1
    643a:	71e080e7          	jalr	1822(ra) # 7b54 <sbrk>
  sbrk(4096);
    643e:	6505                	lui	a0,0x1
    6440:	00001097          	auipc	ra,0x1
    6444:	714080e7          	jalr	1812(ra) # 7b54 <sbrk>
  sbrk(10);
    6448:	4529                	li	a0,10
    644a:	00001097          	auipc	ra,0x1
    644e:	70a080e7          	jalr	1802(ra) # 7b54 <sbrk>
  sbrk(-20);
    6452:	5531                	li	a0,-20
    6454:	00001097          	auipc	ra,0x1
    6458:	700080e7          	jalr	1792(ra) # 7b54 <sbrk>
  top = (uint64) sbrk(0);
    645c:	4501                	li	a0,0
    645e:	00001097          	auipc	ra,0x1
    6462:	6f6080e7          	jalr	1782(ra) # 7b54 <sbrk>
    6466:	87aa                	mv	a5,a0
    6468:	fef43423          	sd	a5,-24(s0)
  char *p = (char *) (top - 64);
    646c:	fe843783          	ld	a5,-24(s0)
    6470:	fc078793          	addi	a5,a5,-64
    6474:	fef43023          	sd	a5,-32(s0)
  p[0] = 'x';
    6478:	fe043783          	ld	a5,-32(s0)
    647c:	07800713          	li	a4,120
    6480:	00e78023          	sb	a4,0(a5)
  p[1] = '\0';
    6484:	fe043783          	ld	a5,-32(s0)
    6488:	0785                	addi	a5,a5,1
    648a:	00078023          	sb	zero,0(a5)
  int fd = open(p, O_RDWR|O_CREATE);
    648e:	20200593          	li	a1,514
    6492:	fe043503          	ld	a0,-32(s0)
    6496:	00001097          	auipc	ra,0x1
    649a:	676080e7          	jalr	1654(ra) # 7b0c <open>
    649e:	87aa                	mv	a5,a0
    64a0:	fcf42e23          	sw	a5,-36(s0)
  write(fd, p, 1);
    64a4:	fdc42783          	lw	a5,-36(s0)
    64a8:	4605                	li	a2,1
    64aa:	fe043583          	ld	a1,-32(s0)
    64ae:	853e                	mv	a0,a5
    64b0:	00001097          	auipc	ra,0x1
    64b4:	63c080e7          	jalr	1596(ra) # 7aec <write>
  close(fd);
    64b8:	fdc42783          	lw	a5,-36(s0)
    64bc:	853e                	mv	a0,a5
    64be:	00001097          	auipc	ra,0x1
    64c2:	636080e7          	jalr	1590(ra) # 7af4 <close>
  fd = open(p, O_RDWR);
    64c6:	4589                	li	a1,2
    64c8:	fe043503          	ld	a0,-32(s0)
    64cc:	00001097          	auipc	ra,0x1
    64d0:	640080e7          	jalr	1600(ra) # 7b0c <open>
    64d4:	87aa                	mv	a5,a0
    64d6:	fcf42e23          	sw	a5,-36(s0)
  p[0] = '\0';
    64da:	fe043783          	ld	a5,-32(s0)
    64de:	00078023          	sb	zero,0(a5)
  read(fd, p, 1);
    64e2:	fdc42783          	lw	a5,-36(s0)
    64e6:	4605                	li	a2,1
    64e8:	fe043583          	ld	a1,-32(s0)
    64ec:	853e                	mv	a0,a5
    64ee:	00001097          	auipc	ra,0x1
    64f2:	5f6080e7          	jalr	1526(ra) # 7ae4 <read>
  if(p[0] != 'x')
    64f6:	fe043783          	ld	a5,-32(s0)
    64fa:	0007c783          	lbu	a5,0(a5)
    64fe:	873e                	mv	a4,a5
    6500:	07800793          	li	a5,120
    6504:	00f70763          	beq	a4,a5,6512 <sbrklast+0x11e>
    exit(1);
    6508:	4505                	li	a0,1
    650a:	00001097          	auipc	ra,0x1
    650e:	5c2080e7          	jalr	1474(ra) # 7acc <exit>
}
    6512:	0001                	nop
    6514:	70e2                	ld	ra,56(sp)
    6516:	7442                	ld	s0,48(sp)
    6518:	6121                	addi	sp,sp,64
    651a:	8082                	ret

000000000000651c <sbrk8000>:

// does sbrk handle signed int32 wrap-around with
// negative arguments?
void
sbrk8000(char *s)
{
    651c:	7179                	addi	sp,sp,-48
    651e:	f406                	sd	ra,40(sp)
    6520:	f022                	sd	s0,32(sp)
    6522:	1800                	addi	s0,sp,48
    6524:	fca43c23          	sd	a0,-40(s0)
  sbrk(0x80000004);
    6528:	800007b7          	lui	a5,0x80000
    652c:	00478513          	addi	a0,a5,4 # ffffffff80000004 <freep+0xffffffff7ffee36c>
    6530:	00001097          	auipc	ra,0x1
    6534:	624080e7          	jalr	1572(ra) # 7b54 <sbrk>
  volatile char *top = sbrk(0);
    6538:	4501                	li	a0,0
    653a:	00001097          	auipc	ra,0x1
    653e:	61a080e7          	jalr	1562(ra) # 7b54 <sbrk>
    6542:	fea43423          	sd	a0,-24(s0)
  *(top-1) = *(top-1) + 1;
    6546:	fe843783          	ld	a5,-24(s0)
    654a:	17fd                	addi	a5,a5,-1
    654c:	0007c783          	lbu	a5,0(a5)
    6550:	0ff7f713          	zext.b	a4,a5
    6554:	fe843783          	ld	a5,-24(s0)
    6558:	17fd                	addi	a5,a5,-1
    655a:	2705                	addiw	a4,a4,1 # 1001 <truncate3+0x1b3>
    655c:	0ff77713          	zext.b	a4,a4
    6560:	00e78023          	sb	a4,0(a5)
}
    6564:	0001                	nop
    6566:	70a2                	ld	ra,40(sp)
    6568:	7402                	ld	s0,32(sp)
    656a:	6145                	addi	sp,sp,48
    656c:	8082                	ret

000000000000656e <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    656e:	7139                	addi	sp,sp,-64
    6570:	fc06                	sd	ra,56(sp)
    6572:	f822                	sd	s0,48(sp)
    6574:	0080                	addi	s0,sp,64
    6576:	fca43423          	sd	a0,-56(s0)
  for(int i = 0; i < 50000; i++){
    657a:	fe042623          	sw	zero,-20(s0)
    657e:	a03d                	j	65ac <badarg+0x3e>
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    6580:	57fd                	li	a5,-1
    6582:	9381                	srli	a5,a5,0x20
    6584:	fcf43c23          	sd	a5,-40(s0)
    argv[1] = 0;
    6588:	fe043023          	sd	zero,-32(s0)
    exec("echo", argv);
    658c:	fd840793          	addi	a5,s0,-40
    6590:	85be                	mv	a1,a5
    6592:	00002517          	auipc	a0,0x2
    6596:	fbe50513          	addi	a0,a0,-66 # 8550 <malloc+0x364>
    659a:	00001097          	auipc	ra,0x1
    659e:	56a080e7          	jalr	1386(ra) # 7b04 <exec>
  for(int i = 0; i < 50000; i++){
    65a2:	fec42783          	lw	a5,-20(s0)
    65a6:	2785                	addiw	a5,a5,1
    65a8:	fef42623          	sw	a5,-20(s0)
    65ac:	fec42783          	lw	a5,-20(s0)
    65b0:	0007871b          	sext.w	a4,a5
    65b4:	67b1                	lui	a5,0xc
    65b6:	34f78793          	addi	a5,a5,847 # c34f <buf+0xedf>
    65ba:	fce7d3e3          	bge	a5,a4,6580 <badarg+0x12>
  }
  
  exit(0);
    65be:	4501                	li	a0,0
    65c0:	00001097          	auipc	ra,0x1
    65c4:	50c080e7          	jalr	1292(ra) # 7acc <exit>

00000000000065c8 <bigdir>:
//

// directory that uses indirect blocks
void
bigdir(char *s)
{
    65c8:	7139                	addi	sp,sp,-64
    65ca:	fc06                	sd	ra,56(sp)
    65cc:	f822                	sd	s0,48(sp)
    65ce:	0080                	addi	s0,sp,64
    65d0:	fca43423          	sd	a0,-56(s0)
  enum { N = 500 };
  int i, fd;
  char name[10];

  unlink("bd");
    65d4:	00004517          	auipc	a0,0x4
    65d8:	f3450513          	addi	a0,a0,-204 # a508 <malloc+0x231c>
    65dc:	00001097          	auipc	ra,0x1
    65e0:	540080e7          	jalr	1344(ra) # 7b1c <unlink>

  fd = open("bd", O_CREATE);
    65e4:	20000593          	li	a1,512
    65e8:	00004517          	auipc	a0,0x4
    65ec:	f2050513          	addi	a0,a0,-224 # a508 <malloc+0x231c>
    65f0:	00001097          	auipc	ra,0x1
    65f4:	51c080e7          	jalr	1308(ra) # 7b0c <open>
    65f8:	87aa                	mv	a5,a0
    65fa:	fef42423          	sw	a5,-24(s0)
  if(fd < 0){
    65fe:	fe842783          	lw	a5,-24(s0)
    6602:	2781                	sext.w	a5,a5
    6604:	0207d163          	bgez	a5,6626 <bigdir+0x5e>
    printf("%s: bigdir create failed\n", s);
    6608:	fc843583          	ld	a1,-56(s0)
    660c:	00004517          	auipc	a0,0x4
    6610:	f0450513          	addi	a0,a0,-252 # a510 <malloc+0x2324>
    6614:	00002097          	auipc	ra,0x2
    6618:	9e4080e7          	jalr	-1564(ra) # 7ff8 <printf>
    exit(1);
    661c:	4505                	li	a0,1
    661e:	00001097          	auipc	ra,0x1
    6622:	4ae080e7          	jalr	1198(ra) # 7acc <exit>
  }
  close(fd);
    6626:	fe842783          	lw	a5,-24(s0)
    662a:	853e                	mv	a0,a5
    662c:	00001097          	auipc	ra,0x1
    6630:	4c8080e7          	jalr	1224(ra) # 7af4 <close>

  for(i = 0; i < N; i++){
    6634:	fe042623          	sw	zero,-20(s0)
    6638:	a055                	j	66dc <bigdir+0x114>
    name[0] = 'x';
    663a:	07800793          	li	a5,120
    663e:	fcf40c23          	sb	a5,-40(s0)
    name[1] = '0' + (i / 64);
    6642:	fec42783          	lw	a5,-20(s0)
    6646:	41f7d71b          	sraiw	a4,a5,0x1f
    664a:	01a7571b          	srliw	a4,a4,0x1a
    664e:	9fb9                	addw	a5,a5,a4
    6650:	4067d79b          	sraiw	a5,a5,0x6
    6654:	2781                	sext.w	a5,a5
    6656:	0ff7f793          	zext.b	a5,a5
    665a:	0307879b          	addiw	a5,a5,48
    665e:	0ff7f793          	zext.b	a5,a5
    6662:	fcf40ca3          	sb	a5,-39(s0)
    name[2] = '0' + (i % 64);
    6666:	fec42783          	lw	a5,-20(s0)
    666a:	873e                	mv	a4,a5
    666c:	41f7579b          	sraiw	a5,a4,0x1f
    6670:	01a7d79b          	srliw	a5,a5,0x1a
    6674:	9f3d                	addw	a4,a4,a5
    6676:	03f77713          	andi	a4,a4,63
    667a:	40f707bb          	subw	a5,a4,a5
    667e:	2781                	sext.w	a5,a5
    6680:	0ff7f793          	zext.b	a5,a5
    6684:	0307879b          	addiw	a5,a5,48
    6688:	0ff7f793          	zext.b	a5,a5
    668c:	fcf40d23          	sb	a5,-38(s0)
    name[3] = '\0';
    6690:	fc040da3          	sb	zero,-37(s0)
    if(link("bd", name) != 0){
    6694:	fd840793          	addi	a5,s0,-40
    6698:	85be                	mv	a1,a5
    669a:	00004517          	auipc	a0,0x4
    669e:	e6e50513          	addi	a0,a0,-402 # a508 <malloc+0x231c>
    66a2:	00001097          	auipc	ra,0x1
    66a6:	48a080e7          	jalr	1162(ra) # 7b2c <link>
    66aa:	87aa                	mv	a5,a0
    66ac:	c39d                	beqz	a5,66d2 <bigdir+0x10a>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    66ae:	fd840793          	addi	a5,s0,-40
    66b2:	863e                	mv	a2,a5
    66b4:	fc843583          	ld	a1,-56(s0)
    66b8:	00004517          	auipc	a0,0x4
    66bc:	e7850513          	addi	a0,a0,-392 # a530 <malloc+0x2344>
    66c0:	00002097          	auipc	ra,0x2
    66c4:	938080e7          	jalr	-1736(ra) # 7ff8 <printf>
      exit(1);
    66c8:	4505                	li	a0,1
    66ca:	00001097          	auipc	ra,0x1
    66ce:	402080e7          	jalr	1026(ra) # 7acc <exit>
  for(i = 0; i < N; i++){
    66d2:	fec42783          	lw	a5,-20(s0)
    66d6:	2785                	addiw	a5,a5,1
    66d8:	fef42623          	sw	a5,-20(s0)
    66dc:	fec42783          	lw	a5,-20(s0)
    66e0:	0007871b          	sext.w	a4,a5
    66e4:	1f300793          	li	a5,499
    66e8:	f4e7d9e3          	bge	a5,a4,663a <bigdir+0x72>
    }
  }

  unlink("bd");
    66ec:	00004517          	auipc	a0,0x4
    66f0:	e1c50513          	addi	a0,a0,-484 # a508 <malloc+0x231c>
    66f4:	00001097          	auipc	ra,0x1
    66f8:	428080e7          	jalr	1064(ra) # 7b1c <unlink>
  for(i = 0; i < N; i++){
    66fc:	fe042623          	sw	zero,-20(s0)
    6700:	a859                	j	6796 <bigdir+0x1ce>
    name[0] = 'x';
    6702:	07800793          	li	a5,120
    6706:	fcf40c23          	sb	a5,-40(s0)
    name[1] = '0' + (i / 64);
    670a:	fec42783          	lw	a5,-20(s0)
    670e:	41f7d71b          	sraiw	a4,a5,0x1f
    6712:	01a7571b          	srliw	a4,a4,0x1a
    6716:	9fb9                	addw	a5,a5,a4
    6718:	4067d79b          	sraiw	a5,a5,0x6
    671c:	2781                	sext.w	a5,a5
    671e:	0ff7f793          	zext.b	a5,a5
    6722:	0307879b          	addiw	a5,a5,48
    6726:	0ff7f793          	zext.b	a5,a5
    672a:	fcf40ca3          	sb	a5,-39(s0)
    name[2] = '0' + (i % 64);
    672e:	fec42783          	lw	a5,-20(s0)
    6732:	873e                	mv	a4,a5
    6734:	41f7579b          	sraiw	a5,a4,0x1f
    6738:	01a7d79b          	srliw	a5,a5,0x1a
    673c:	9f3d                	addw	a4,a4,a5
    673e:	03f77713          	andi	a4,a4,63
    6742:	40f707bb          	subw	a5,a4,a5
    6746:	2781                	sext.w	a5,a5
    6748:	0ff7f793          	zext.b	a5,a5
    674c:	0307879b          	addiw	a5,a5,48
    6750:	0ff7f793          	zext.b	a5,a5
    6754:	fcf40d23          	sb	a5,-38(s0)
    name[3] = '\0';
    6758:	fc040da3          	sb	zero,-37(s0)
    if(unlink(name) != 0){
    675c:	fd840793          	addi	a5,s0,-40
    6760:	853e                	mv	a0,a5
    6762:	00001097          	auipc	ra,0x1
    6766:	3ba080e7          	jalr	954(ra) # 7b1c <unlink>
    676a:	87aa                	mv	a5,a0
    676c:	c385                	beqz	a5,678c <bigdir+0x1c4>
      printf("%s: bigdir unlink failed", s);
    676e:	fc843583          	ld	a1,-56(s0)
    6772:	00004517          	auipc	a0,0x4
    6776:	dde50513          	addi	a0,a0,-546 # a550 <malloc+0x2364>
    677a:	00002097          	auipc	ra,0x2
    677e:	87e080e7          	jalr	-1922(ra) # 7ff8 <printf>
      exit(1);
    6782:	4505                	li	a0,1
    6784:	00001097          	auipc	ra,0x1
    6788:	348080e7          	jalr	840(ra) # 7acc <exit>
  for(i = 0; i < N; i++){
    678c:	fec42783          	lw	a5,-20(s0)
    6790:	2785                	addiw	a5,a5,1
    6792:	fef42623          	sw	a5,-20(s0)
    6796:	fec42783          	lw	a5,-20(s0)
    679a:	0007871b          	sext.w	a4,a5
    679e:	1f300793          	li	a5,499
    67a2:	f6e7d0e3          	bge	a5,a4,6702 <bigdir+0x13a>
    }
  }
}
    67a6:	0001                	nop
    67a8:	0001                	nop
    67aa:	70e2                	ld	ra,56(sp)
    67ac:	7442                	ld	s0,48(sp)
    67ae:	6121                	addi	sp,sp,64
    67b0:	8082                	ret

00000000000067b2 <manywrites>:

// concurrent writes to try to provoke deadlock in the virtio disk
// driver.
void
manywrites(char *s)
{
    67b2:	711d                	addi	sp,sp,-96
    67b4:	ec86                	sd	ra,88(sp)
    67b6:	e8a2                	sd	s0,80(sp)
    67b8:	1080                	addi	s0,sp,96
    67ba:	faa43423          	sd	a0,-88(s0)
  int nchildren = 4;
    67be:	4791                	li	a5,4
    67c0:	fcf42e23          	sw	a5,-36(s0)
  int howmany = 30; // increase to look for deadlock
    67c4:	47f9                	li	a5,30
    67c6:	fcf42c23          	sw	a5,-40(s0)
  
  for(int ci = 0; ci < nchildren; ci++){
    67ca:	fe042623          	sw	zero,-20(s0)
    67ce:	aa61                	j	6966 <manywrites+0x1b4>
    int pid = fork();
    67d0:	00001097          	auipc	ra,0x1
    67d4:	2f4080e7          	jalr	756(ra) # 7ac4 <fork>
    67d8:	87aa                	mv	a5,a0
    67da:	fcf42a23          	sw	a5,-44(s0)
    if(pid < 0){
    67de:	fd442783          	lw	a5,-44(s0)
    67e2:	2781                	sext.w	a5,a5
    67e4:	0007df63          	bgez	a5,6802 <manywrites+0x50>
      printf("fork failed\n");
    67e8:	00002517          	auipc	a0,0x2
    67ec:	d5850513          	addi	a0,a0,-680 # 8540 <malloc+0x354>
    67f0:	00002097          	auipc	ra,0x2
    67f4:	808080e7          	jalr	-2040(ra) # 7ff8 <printf>
      exit(1);
    67f8:	4505                	li	a0,1
    67fa:	00001097          	auipc	ra,0x1
    67fe:	2d2080e7          	jalr	722(ra) # 7acc <exit>
    }

    if(pid == 0){
    6802:	fd442783          	lw	a5,-44(s0)
    6806:	2781                	sext.w	a5,a5
    6808:	14079a63          	bnez	a5,695c <manywrites+0x1aa>
      char name[3];
      name[0] = 'b';
    680c:	06200793          	li	a5,98
    6810:	fcf40023          	sb	a5,-64(s0)
      name[1] = 'a' + ci;
    6814:	fec42783          	lw	a5,-20(s0)
    6818:	0ff7f793          	zext.b	a5,a5
    681c:	0617879b          	addiw	a5,a5,97
    6820:	0ff7f793          	zext.b	a5,a5
    6824:	fcf400a3          	sb	a5,-63(s0)
      name[2] = '\0';
    6828:	fc040123          	sb	zero,-62(s0)
      unlink(name);
    682c:	fc040793          	addi	a5,s0,-64
    6830:	853e                	mv	a0,a5
    6832:	00001097          	auipc	ra,0x1
    6836:	2ea080e7          	jalr	746(ra) # 7b1c <unlink>
      
      for(int iters = 0; iters < howmany; iters++){
    683a:	fe042423          	sw	zero,-24(s0)
    683e:	a8d5                	j	6932 <manywrites+0x180>
        for(int i = 0; i < ci+1; i++){
    6840:	fe042223          	sw	zero,-28(s0)
    6844:	a0d1                	j	6908 <manywrites+0x156>
          int fd = open(name, O_CREATE | O_RDWR);
    6846:	fc040793          	addi	a5,s0,-64
    684a:	20200593          	li	a1,514
    684e:	853e                	mv	a0,a5
    6850:	00001097          	auipc	ra,0x1
    6854:	2bc080e7          	jalr	700(ra) # 7b0c <open>
    6858:	87aa                	mv	a5,a0
    685a:	fcf42823          	sw	a5,-48(s0)
          if(fd < 0){
    685e:	fd042783          	lw	a5,-48(s0)
    6862:	2781                	sext.w	a5,a5
    6864:	0207d463          	bgez	a5,688c <manywrites+0xda>
            printf("%s: cannot create %s\n", s, name);
    6868:	fc040793          	addi	a5,s0,-64
    686c:	863e                	mv	a2,a5
    686e:	fa843583          	ld	a1,-88(s0)
    6872:	00004517          	auipc	a0,0x4
    6876:	cfe50513          	addi	a0,a0,-770 # a570 <malloc+0x2384>
    687a:	00001097          	auipc	ra,0x1
    687e:	77e080e7          	jalr	1918(ra) # 7ff8 <printf>
            exit(1);
    6882:	4505                	li	a0,1
    6884:	00001097          	auipc	ra,0x1
    6888:	248080e7          	jalr	584(ra) # 7acc <exit>
          }
          int sz = sizeof(buf);
    688c:	678d                	lui	a5,0x3
    688e:	fcf42623          	sw	a5,-52(s0)
          int cc = write(fd, buf, sz);
    6892:	fcc42703          	lw	a4,-52(s0)
    6896:	fd042783          	lw	a5,-48(s0)
    689a:	863a                	mv	a2,a4
    689c:	00005597          	auipc	a1,0x5
    68a0:	bd458593          	addi	a1,a1,-1068 # b470 <buf>
    68a4:	853e                	mv	a0,a5
    68a6:	00001097          	auipc	ra,0x1
    68aa:	246080e7          	jalr	582(ra) # 7aec <write>
    68ae:	87aa                	mv	a5,a0
    68b0:	fcf42423          	sw	a5,-56(s0)
          if(cc != sz){
    68b4:	fc842783          	lw	a5,-56(s0)
    68b8:	873e                	mv	a4,a5
    68ba:	fcc42783          	lw	a5,-52(s0)
    68be:	2701                	sext.w	a4,a4
    68c0:	2781                	sext.w	a5,a5
    68c2:	02f70763          	beq	a4,a5,68f0 <manywrites+0x13e>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    68c6:	fc842703          	lw	a4,-56(s0)
    68ca:	fcc42783          	lw	a5,-52(s0)
    68ce:	86ba                	mv	a3,a4
    68d0:	863e                	mv	a2,a5
    68d2:	fa843583          	ld	a1,-88(s0)
    68d6:	00003517          	auipc	a0,0x3
    68da:	ea250513          	addi	a0,a0,-350 # 9778 <malloc+0x158c>
    68de:	00001097          	auipc	ra,0x1
    68e2:	71a080e7          	jalr	1818(ra) # 7ff8 <printf>
            exit(1);
    68e6:	4505                	li	a0,1
    68e8:	00001097          	auipc	ra,0x1
    68ec:	1e4080e7          	jalr	484(ra) # 7acc <exit>
          }
          close(fd);
    68f0:	fd042783          	lw	a5,-48(s0)
    68f4:	853e                	mv	a0,a5
    68f6:	00001097          	auipc	ra,0x1
    68fa:	1fe080e7          	jalr	510(ra) # 7af4 <close>
        for(int i = 0; i < ci+1; i++){
    68fe:	fe442783          	lw	a5,-28(s0)
    6902:	2785                	addiw	a5,a5,1 # 3001 <createdelete+0x28d>
    6904:	fef42223          	sw	a5,-28(s0)
    6908:	fec42783          	lw	a5,-20(s0)
    690c:	873e                	mv	a4,a5
    690e:	fe442783          	lw	a5,-28(s0)
    6912:	2701                	sext.w	a4,a4
    6914:	2781                	sext.w	a5,a5
    6916:	f2f758e3          	bge	a4,a5,6846 <manywrites+0x94>
        }
        unlink(name);
    691a:	fc040793          	addi	a5,s0,-64
    691e:	853e                	mv	a0,a5
    6920:	00001097          	auipc	ra,0x1
    6924:	1fc080e7          	jalr	508(ra) # 7b1c <unlink>
      for(int iters = 0; iters < howmany; iters++){
    6928:	fe842783          	lw	a5,-24(s0)
    692c:	2785                	addiw	a5,a5,1
    692e:	fef42423          	sw	a5,-24(s0)
    6932:	fe842783          	lw	a5,-24(s0)
    6936:	873e                	mv	a4,a5
    6938:	fd842783          	lw	a5,-40(s0)
    693c:	2701                	sext.w	a4,a4
    693e:	2781                	sext.w	a5,a5
    6940:	f0f740e3          	blt	a4,a5,6840 <manywrites+0x8e>
      }

      unlink(name);
    6944:	fc040793          	addi	a5,s0,-64
    6948:	853e                	mv	a0,a5
    694a:	00001097          	auipc	ra,0x1
    694e:	1d2080e7          	jalr	466(ra) # 7b1c <unlink>
      exit(0);
    6952:	4501                	li	a0,0
    6954:	00001097          	auipc	ra,0x1
    6958:	178080e7          	jalr	376(ra) # 7acc <exit>
  for(int ci = 0; ci < nchildren; ci++){
    695c:	fec42783          	lw	a5,-20(s0)
    6960:	2785                	addiw	a5,a5,1
    6962:	fef42623          	sw	a5,-20(s0)
    6966:	fec42783          	lw	a5,-20(s0)
    696a:	873e                	mv	a4,a5
    696c:	fdc42783          	lw	a5,-36(s0)
    6970:	2701                	sext.w	a4,a4
    6972:	2781                	sext.w	a5,a5
    6974:	e4f74ee3          	blt	a4,a5,67d0 <manywrites+0x1e>
    }
  }

  for(int ci = 0; ci < nchildren; ci++){
    6978:	fe042023          	sw	zero,-32(s0)
    697c:	a80d                	j	69ae <manywrites+0x1fc>
    int st = 0;
    697e:	fa042e23          	sw	zero,-68(s0)
    wait(&st);
    6982:	fbc40793          	addi	a5,s0,-68
    6986:	853e                	mv	a0,a5
    6988:	00001097          	auipc	ra,0x1
    698c:	14c080e7          	jalr	332(ra) # 7ad4 <wait>
    if(st != 0)
    6990:	fbc42783          	lw	a5,-68(s0)
    6994:	cb81                	beqz	a5,69a4 <manywrites+0x1f2>
      exit(st);
    6996:	fbc42783          	lw	a5,-68(s0)
    699a:	853e                	mv	a0,a5
    699c:	00001097          	auipc	ra,0x1
    69a0:	130080e7          	jalr	304(ra) # 7acc <exit>
  for(int ci = 0; ci < nchildren; ci++){
    69a4:	fe042783          	lw	a5,-32(s0)
    69a8:	2785                	addiw	a5,a5,1
    69aa:	fef42023          	sw	a5,-32(s0)
    69ae:	fe042783          	lw	a5,-32(s0)
    69b2:	873e                	mv	a4,a5
    69b4:	fdc42783          	lw	a5,-36(s0)
    69b8:	2701                	sext.w	a4,a4
    69ba:	2781                	sext.w	a5,a5
    69bc:	fcf741e3          	blt	a4,a5,697e <manywrites+0x1cc>
  }
  exit(0);
    69c0:	4501                	li	a0,0
    69c2:	00001097          	auipc	ra,0x1
    69c6:	10a080e7          	jalr	266(ra) # 7acc <exit>

00000000000069ca <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
    69ca:	7179                	addi	sp,sp,-48
    69cc:	f406                	sd	ra,40(sp)
    69ce:	f022                	sd	s0,32(sp)
    69d0:	1800                	addi	s0,sp,48
    69d2:	fca43c23          	sd	a0,-40(s0)
  int assumed_free = 600;
    69d6:	25800793          	li	a5,600
    69da:	fef42423          	sw	a5,-24(s0)
  
  unlink("junk");
    69de:	00004517          	auipc	a0,0x4
    69e2:	baa50513          	addi	a0,a0,-1110 # a588 <malloc+0x239c>
    69e6:	00001097          	auipc	ra,0x1
    69ea:	136080e7          	jalr	310(ra) # 7b1c <unlink>
  for(int i = 0; i < assumed_free; i++){
    69ee:	fe042623          	sw	zero,-20(s0)
    69f2:	a8bd                	j	6a70 <badwrite+0xa6>
    int fd = open("junk", O_CREATE|O_WRONLY);
    69f4:	20100593          	li	a1,513
    69f8:	00004517          	auipc	a0,0x4
    69fc:	b9050513          	addi	a0,a0,-1136 # a588 <malloc+0x239c>
    6a00:	00001097          	auipc	ra,0x1
    6a04:	10c080e7          	jalr	268(ra) # 7b0c <open>
    6a08:	87aa                	mv	a5,a0
    6a0a:	fef42023          	sw	a5,-32(s0)
    if(fd < 0){
    6a0e:	fe042783          	lw	a5,-32(s0)
    6a12:	2781                	sext.w	a5,a5
    6a14:	0007df63          	bgez	a5,6a32 <badwrite+0x68>
      printf("open junk failed\n");
    6a18:	00004517          	auipc	a0,0x4
    6a1c:	b7850513          	addi	a0,a0,-1160 # a590 <malloc+0x23a4>
    6a20:	00001097          	auipc	ra,0x1
    6a24:	5d8080e7          	jalr	1496(ra) # 7ff8 <printf>
      exit(1);
    6a28:	4505                	li	a0,1
    6a2a:	00001097          	auipc	ra,0x1
    6a2e:	0a2080e7          	jalr	162(ra) # 7acc <exit>
    }
    write(fd, (char*)0xffffffffffL, 1);
    6a32:	fe042703          	lw	a4,-32(s0)
    6a36:	4605                	li	a2,1
    6a38:	57fd                	li	a5,-1
    6a3a:	0187d593          	srli	a1,a5,0x18
    6a3e:	853a                	mv	a0,a4
    6a40:	00001097          	auipc	ra,0x1
    6a44:	0ac080e7          	jalr	172(ra) # 7aec <write>
    close(fd);
    6a48:	fe042783          	lw	a5,-32(s0)
    6a4c:	853e                	mv	a0,a5
    6a4e:	00001097          	auipc	ra,0x1
    6a52:	0a6080e7          	jalr	166(ra) # 7af4 <close>
    unlink("junk");
    6a56:	00004517          	auipc	a0,0x4
    6a5a:	b3250513          	addi	a0,a0,-1230 # a588 <malloc+0x239c>
    6a5e:	00001097          	auipc	ra,0x1
    6a62:	0be080e7          	jalr	190(ra) # 7b1c <unlink>
  for(int i = 0; i < assumed_free; i++){
    6a66:	fec42783          	lw	a5,-20(s0)
    6a6a:	2785                	addiw	a5,a5,1
    6a6c:	fef42623          	sw	a5,-20(s0)
    6a70:	fec42783          	lw	a5,-20(s0)
    6a74:	873e                	mv	a4,a5
    6a76:	fe842783          	lw	a5,-24(s0)
    6a7a:	2701                	sext.w	a4,a4
    6a7c:	2781                	sext.w	a5,a5
    6a7e:	f6f74be3          	blt	a4,a5,69f4 <badwrite+0x2a>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
    6a82:	20100593          	li	a1,513
    6a86:	00004517          	auipc	a0,0x4
    6a8a:	b0250513          	addi	a0,a0,-1278 # a588 <malloc+0x239c>
    6a8e:	00001097          	auipc	ra,0x1
    6a92:	07e080e7          	jalr	126(ra) # 7b0c <open>
    6a96:	87aa                	mv	a5,a0
    6a98:	fef42223          	sw	a5,-28(s0)
  if(fd < 0){
    6a9c:	fe442783          	lw	a5,-28(s0)
    6aa0:	2781                	sext.w	a5,a5
    6aa2:	0007df63          	bgez	a5,6ac0 <badwrite+0xf6>
    printf("open junk failed\n");
    6aa6:	00004517          	auipc	a0,0x4
    6aaa:	aea50513          	addi	a0,a0,-1302 # a590 <malloc+0x23a4>
    6aae:	00001097          	auipc	ra,0x1
    6ab2:	54a080e7          	jalr	1354(ra) # 7ff8 <printf>
    exit(1);
    6ab6:	4505                	li	a0,1
    6ab8:	00001097          	auipc	ra,0x1
    6abc:	014080e7          	jalr	20(ra) # 7acc <exit>
  }
  if(write(fd, "x", 1) != 1){
    6ac0:	fe442783          	lw	a5,-28(s0)
    6ac4:	4605                	li	a2,1
    6ac6:	00002597          	auipc	a1,0x2
    6aca:	97a58593          	addi	a1,a1,-1670 # 8440 <malloc+0x254>
    6ace:	853e                	mv	a0,a5
    6ad0:	00001097          	auipc	ra,0x1
    6ad4:	01c080e7          	jalr	28(ra) # 7aec <write>
    6ad8:	87aa                	mv	a5,a0
    6ada:	873e                	mv	a4,a5
    6adc:	4785                	li	a5,1
    6ade:	00f70f63          	beq	a4,a5,6afc <badwrite+0x132>
    printf("write failed\n");
    6ae2:	00004517          	auipc	a0,0x4
    6ae6:	ac650513          	addi	a0,a0,-1338 # a5a8 <malloc+0x23bc>
    6aea:	00001097          	auipc	ra,0x1
    6aee:	50e080e7          	jalr	1294(ra) # 7ff8 <printf>
    exit(1);
    6af2:	4505                	li	a0,1
    6af4:	00001097          	auipc	ra,0x1
    6af8:	fd8080e7          	jalr	-40(ra) # 7acc <exit>
  }
  close(fd);
    6afc:	fe442783          	lw	a5,-28(s0)
    6b00:	853e                	mv	a0,a5
    6b02:	00001097          	auipc	ra,0x1
    6b06:	ff2080e7          	jalr	-14(ra) # 7af4 <close>
  unlink("junk");
    6b0a:	00004517          	auipc	a0,0x4
    6b0e:	a7e50513          	addi	a0,a0,-1410 # a588 <malloc+0x239c>
    6b12:	00001097          	auipc	ra,0x1
    6b16:	00a080e7          	jalr	10(ra) # 7b1c <unlink>

  exit(0);
    6b1a:	4501                	li	a0,0
    6b1c:	00001097          	auipc	ra,0x1
    6b20:	fb0080e7          	jalr	-80(ra) # 7acc <exit>

0000000000006b24 <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    6b24:	715d                	addi	sp,sp,-80
    6b26:	e486                	sd	ra,72(sp)
    6b28:	e0a2                	sd	s0,64(sp)
    6b2a:	0880                	addi	s0,sp,80
    6b2c:	faa43c23          	sd	a0,-72(s0)
  for(int avail = 0; avail < 15; avail++){
    6b30:	fe042623          	sw	zero,-20(s0)
    6b34:	a8cd                	j	6c26 <execout+0x102>
    int pid = fork();
    6b36:	00001097          	auipc	ra,0x1
    6b3a:	f8e080e7          	jalr	-114(ra) # 7ac4 <fork>
    6b3e:	87aa                	mv	a5,a0
    6b40:	fef42223          	sw	a5,-28(s0)
    if(pid < 0){
    6b44:	fe442783          	lw	a5,-28(s0)
    6b48:	2781                	sext.w	a5,a5
    6b4a:	0007df63          	bgez	a5,6b68 <execout+0x44>
      printf("fork failed\n");
    6b4e:	00002517          	auipc	a0,0x2
    6b52:	9f250513          	addi	a0,a0,-1550 # 8540 <malloc+0x354>
    6b56:	00001097          	auipc	ra,0x1
    6b5a:	4a2080e7          	jalr	1186(ra) # 7ff8 <printf>
      exit(1);
    6b5e:	4505                	li	a0,1
    6b60:	00001097          	auipc	ra,0x1
    6b64:	f6c080e7          	jalr	-148(ra) # 7acc <exit>
    } else if(pid == 0){
    6b68:	fe442783          	lw	a5,-28(s0)
    6b6c:	2781                	sext.w	a5,a5
    6b6e:	e3d5                	bnez	a5,6c12 <execout+0xee>
      // allocate all of memory.
      while(1){
        uint64 a = (uint64) sbrk(4096);
    6b70:	6505                	lui	a0,0x1
    6b72:	00001097          	auipc	ra,0x1
    6b76:	fe2080e7          	jalr	-30(ra) # 7b54 <sbrk>
    6b7a:	87aa                	mv	a5,a0
    6b7c:	fcf43c23          	sd	a5,-40(s0)
        if(a == 0xffffffffffffffffLL)
    6b80:	fd843703          	ld	a4,-40(s0)
    6b84:	57fd                	li	a5,-1
    6b86:	00f70c63          	beq	a4,a5,6b9e <execout+0x7a>
          break;
        *(char*)(a + 4096 - 1) = 1;
    6b8a:	fd843703          	ld	a4,-40(s0)
    6b8e:	6785                	lui	a5,0x1
    6b90:	17fd                	addi	a5,a5,-1 # fff <truncate3+0x1b1>
    6b92:	97ba                	add	a5,a5,a4
    6b94:	873e                	mv	a4,a5
    6b96:	4785                	li	a5,1
    6b98:	00f70023          	sb	a5,0(a4)
      while(1){
    6b9c:	bfd1                	j	6b70 <execout+0x4c>
          break;
    6b9e:	0001                	nop
      }

      // free a few pages, in order to let exec() make some
      // progress.
      for(int i = 0; i < avail; i++)
    6ba0:	fe042423          	sw	zero,-24(s0)
    6ba4:	a819                	j	6bba <execout+0x96>
        sbrk(-4096);
    6ba6:	757d                	lui	a0,0xfffff
    6ba8:	00001097          	auipc	ra,0x1
    6bac:	fac080e7          	jalr	-84(ra) # 7b54 <sbrk>
      for(int i = 0; i < avail; i++)
    6bb0:	fe842783          	lw	a5,-24(s0)
    6bb4:	2785                	addiw	a5,a5,1
    6bb6:	fef42423          	sw	a5,-24(s0)
    6bba:	fe842783          	lw	a5,-24(s0)
    6bbe:	873e                	mv	a4,a5
    6bc0:	fec42783          	lw	a5,-20(s0)
    6bc4:	2701                	sext.w	a4,a4
    6bc6:	2781                	sext.w	a5,a5
    6bc8:	fcf74fe3          	blt	a4,a5,6ba6 <execout+0x82>
      
      close(1);
    6bcc:	4505                	li	a0,1
    6bce:	00001097          	auipc	ra,0x1
    6bd2:	f26080e7          	jalr	-218(ra) # 7af4 <close>
      char *args[] = { "echo", "x", 0 };
    6bd6:	00002797          	auipc	a5,0x2
    6bda:	97a78793          	addi	a5,a5,-1670 # 8550 <malloc+0x364>
    6bde:	fcf43023          	sd	a5,-64(s0)
    6be2:	00002797          	auipc	a5,0x2
    6be6:	85e78793          	addi	a5,a5,-1954 # 8440 <malloc+0x254>
    6bea:	fcf43423          	sd	a5,-56(s0)
    6bee:	fc043823          	sd	zero,-48(s0)
      exec("echo", args);
    6bf2:	fc040793          	addi	a5,s0,-64
    6bf6:	85be                	mv	a1,a5
    6bf8:	00002517          	auipc	a0,0x2
    6bfc:	95850513          	addi	a0,a0,-1704 # 8550 <malloc+0x364>
    6c00:	00001097          	auipc	ra,0x1
    6c04:	f04080e7          	jalr	-252(ra) # 7b04 <exec>
      exit(0);
    6c08:	4501                	li	a0,0
    6c0a:	00001097          	auipc	ra,0x1
    6c0e:	ec2080e7          	jalr	-318(ra) # 7acc <exit>
    } else {
      wait((int*)0);
    6c12:	4501                	li	a0,0
    6c14:	00001097          	auipc	ra,0x1
    6c18:	ec0080e7          	jalr	-320(ra) # 7ad4 <wait>
  for(int avail = 0; avail < 15; avail++){
    6c1c:	fec42783          	lw	a5,-20(s0)
    6c20:	2785                	addiw	a5,a5,1
    6c22:	fef42623          	sw	a5,-20(s0)
    6c26:	fec42783          	lw	a5,-20(s0)
    6c2a:	0007871b          	sext.w	a4,a5
    6c2e:	47b9                	li	a5,14
    6c30:	f0e7d3e3          	bge	a5,a4,6b36 <execout+0x12>
    }
  }

  exit(0);
    6c34:	4501                	li	a0,0
    6c36:	00001097          	auipc	ra,0x1
    6c3a:	e96080e7          	jalr	-362(ra) # 7acc <exit>

0000000000006c3e <diskfull>:
}

// can the kernel tolerate running out of disk space?
void
diskfull(char *s)
{
    6c3e:	b9010113          	addi	sp,sp,-1136
    6c42:	46113423          	sd	ra,1128(sp)
    6c46:	46813023          	sd	s0,1120(sp)
    6c4a:	47010413          	addi	s0,sp,1136
    6c4e:	b8a43c23          	sd	a0,-1128(s0)
  int fi;
  int done = 0;
    6c52:	fe042423          	sw	zero,-24(s0)

  unlink("diskfulldir");
    6c56:	00004517          	auipc	a0,0x4
    6c5a:	96250513          	addi	a0,a0,-1694 # a5b8 <malloc+0x23cc>
    6c5e:	00001097          	auipc	ra,0x1
    6c62:	ebe080e7          	jalr	-322(ra) # 7b1c <unlink>
  
  for(fi = 0; done == 0; fi++){
    6c66:	fe042623          	sw	zero,-20(s0)
    6c6a:	a8cd                	j	6d5c <diskfull+0x11e>
    char name[32];
    name[0] = 'b';
    6c6c:	06200793          	li	a5,98
    6c70:	baf40423          	sb	a5,-1112(s0)
    name[1] = 'i';
    6c74:	06900793          	li	a5,105
    6c78:	baf404a3          	sb	a5,-1111(s0)
    name[2] = 'g';
    6c7c:	06700793          	li	a5,103
    6c80:	baf40523          	sb	a5,-1110(s0)
    name[3] = '0' + fi;
    6c84:	fec42783          	lw	a5,-20(s0)
    6c88:	0ff7f793          	zext.b	a5,a5
    6c8c:	0307879b          	addiw	a5,a5,48
    6c90:	0ff7f793          	zext.b	a5,a5
    6c94:	baf405a3          	sb	a5,-1109(s0)
    name[4] = '\0';
    6c98:	ba040623          	sb	zero,-1108(s0)
    unlink(name);
    6c9c:	ba840793          	addi	a5,s0,-1112
    6ca0:	853e                	mv	a0,a5
    6ca2:	00001097          	auipc	ra,0x1
    6ca6:	e7a080e7          	jalr	-390(ra) # 7b1c <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    6caa:	ba840793          	addi	a5,s0,-1112
    6cae:	60200593          	li	a1,1538
    6cb2:	853e                	mv	a0,a5
    6cb4:	00001097          	auipc	ra,0x1
    6cb8:	e58080e7          	jalr	-424(ra) # 7b0c <open>
    6cbc:	87aa                	mv	a5,a0
    6cbe:	fcf42a23          	sw	a5,-44(s0)
    if(fd < 0){
    6cc2:	fd442783          	lw	a5,-44(s0)
    6cc6:	2781                	sext.w	a5,a5
    6cc8:	0207d363          	bgez	a5,6cee <diskfull+0xb0>
      // oops, ran out of inodes before running out of blocks.
      printf("%s: could not create file %s\n", s, name);
    6ccc:	ba840793          	addi	a5,s0,-1112
    6cd0:	863e                	mv	a2,a5
    6cd2:	b9843583          	ld	a1,-1128(s0)
    6cd6:	00004517          	auipc	a0,0x4
    6cda:	8f250513          	addi	a0,a0,-1806 # a5c8 <malloc+0x23dc>
    6cde:	00001097          	auipc	ra,0x1
    6ce2:	31a080e7          	jalr	794(ra) # 7ff8 <printf>
      done = 1;
    6ce6:	4785                	li	a5,1
    6ce8:	fef42423          	sw	a5,-24(s0)
    6cec:	a8a5                	j	6d64 <diskfull+0x126>
      break;
    }
    for(int i = 0; i < MAXFILE; i++){
    6cee:	fe042223          	sw	zero,-28(s0)
    6cf2:	a099                	j	6d38 <diskfull+0xfa>
      char buf[BSIZE];
      if(write(fd, buf, BSIZE) != BSIZE){
    6cf4:	bc840713          	addi	a4,s0,-1080
    6cf8:	fd442783          	lw	a5,-44(s0)
    6cfc:	40000613          	li	a2,1024
    6d00:	85ba                	mv	a1,a4
    6d02:	853e                	mv	a0,a5
    6d04:	00001097          	auipc	ra,0x1
    6d08:	de8080e7          	jalr	-536(ra) # 7aec <write>
    6d0c:	87aa                	mv	a5,a0
    6d0e:	873e                	mv	a4,a5
    6d10:	40000793          	li	a5,1024
    6d14:	00f70d63          	beq	a4,a5,6d2e <diskfull+0xf0>
        done = 1;
    6d18:	4785                	li	a5,1
    6d1a:	fef42423          	sw	a5,-24(s0)
        close(fd);
    6d1e:	fd442783          	lw	a5,-44(s0)
    6d22:	853e                	mv	a0,a5
    6d24:	00001097          	auipc	ra,0x1
    6d28:	dd0080e7          	jalr	-560(ra) # 7af4 <close>
    6d2c:	a821                	j	6d44 <diskfull+0x106>
    for(int i = 0; i < MAXFILE; i++){
    6d2e:	fe442783          	lw	a5,-28(s0)
    6d32:	2785                	addiw	a5,a5,1
    6d34:	fef42223          	sw	a5,-28(s0)
    6d38:	fe442703          	lw	a4,-28(s0)
    6d3c:	10b00793          	li	a5,267
    6d40:	fae7fae3          	bgeu	a5,a4,6cf4 <diskfull+0xb6>
        break;
      }
    }
    close(fd);
    6d44:	fd442783          	lw	a5,-44(s0)
    6d48:	853e                	mv	a0,a5
    6d4a:	00001097          	auipc	ra,0x1
    6d4e:	daa080e7          	jalr	-598(ra) # 7af4 <close>
  for(fi = 0; done == 0; fi++){
    6d52:	fec42783          	lw	a5,-20(s0)
    6d56:	2785                	addiw	a5,a5,1
    6d58:	fef42623          	sw	a5,-20(s0)
    6d5c:	fe842783          	lw	a5,-24(s0)
    6d60:	2781                	sext.w	a5,a5
    6d62:	d789                	beqz	a5,6c6c <diskfull+0x2e>

  // now that there are no free blocks, test that dirlink()
  // merely fails (doesn't panic) if it can't extend
  // directory content. one of these file creations
  // is expected to fail.
  int nzz = 128;
    6d64:	08000793          	li	a5,128
    6d68:	fcf42823          	sw	a5,-48(s0)
  for(int i = 0; i < nzz; i++){
    6d6c:	fe042023          	sw	zero,-32(s0)
    6d70:	a06d                	j	6e1a <diskfull+0x1dc>
    char name[32];
    name[0] = 'z';
    6d72:	07a00793          	li	a5,122
    6d76:	bcf40423          	sb	a5,-1080(s0)
    name[1] = 'z';
    6d7a:	07a00793          	li	a5,122
    6d7e:	bcf404a3          	sb	a5,-1079(s0)
    name[2] = '0' + (i / 32);
    6d82:	fe042783          	lw	a5,-32(s0)
    6d86:	41f7d71b          	sraiw	a4,a5,0x1f
    6d8a:	01b7571b          	srliw	a4,a4,0x1b
    6d8e:	9fb9                	addw	a5,a5,a4
    6d90:	4057d79b          	sraiw	a5,a5,0x5
    6d94:	2781                	sext.w	a5,a5
    6d96:	0ff7f793          	zext.b	a5,a5
    6d9a:	0307879b          	addiw	a5,a5,48
    6d9e:	0ff7f793          	zext.b	a5,a5
    6da2:	bcf40523          	sb	a5,-1078(s0)
    name[3] = '0' + (i % 32);
    6da6:	fe042783          	lw	a5,-32(s0)
    6daa:	873e                	mv	a4,a5
    6dac:	41f7579b          	sraiw	a5,a4,0x1f
    6db0:	01b7d79b          	srliw	a5,a5,0x1b
    6db4:	9f3d                	addw	a4,a4,a5
    6db6:	8b7d                	andi	a4,a4,31
    6db8:	40f707bb          	subw	a5,a4,a5
    6dbc:	2781                	sext.w	a5,a5
    6dbe:	0ff7f793          	zext.b	a5,a5
    6dc2:	0307879b          	addiw	a5,a5,48
    6dc6:	0ff7f793          	zext.b	a5,a5
    6dca:	bcf405a3          	sb	a5,-1077(s0)
    name[4] = '\0';
    6dce:	bc040623          	sb	zero,-1076(s0)
    unlink(name);
    6dd2:	bc840793          	addi	a5,s0,-1080
    6dd6:	853e                	mv	a0,a5
    6dd8:	00001097          	auipc	ra,0x1
    6ddc:	d44080e7          	jalr	-700(ra) # 7b1c <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    6de0:	bc840793          	addi	a5,s0,-1080
    6de4:	60200593          	li	a1,1538
    6de8:	853e                	mv	a0,a5
    6dea:	00001097          	auipc	ra,0x1
    6dee:	d22080e7          	jalr	-734(ra) # 7b0c <open>
    6df2:	87aa                	mv	a5,a0
    6df4:	fcf42623          	sw	a5,-52(s0)
    if(fd < 0)
    6df8:	fcc42783          	lw	a5,-52(s0)
    6dfc:	2781                	sext.w	a5,a5
    6dfe:	0207c863          	bltz	a5,6e2e <diskfull+0x1f0>
      break;
    close(fd);
    6e02:	fcc42783          	lw	a5,-52(s0)
    6e06:	853e                	mv	a0,a5
    6e08:	00001097          	auipc	ra,0x1
    6e0c:	cec080e7          	jalr	-788(ra) # 7af4 <close>
  for(int i = 0; i < nzz; i++){
    6e10:	fe042783          	lw	a5,-32(s0)
    6e14:	2785                	addiw	a5,a5,1
    6e16:	fef42023          	sw	a5,-32(s0)
    6e1a:	fe042783          	lw	a5,-32(s0)
    6e1e:	873e                	mv	a4,a5
    6e20:	fd042783          	lw	a5,-48(s0)
    6e24:	2701                	sext.w	a4,a4
    6e26:	2781                	sext.w	a5,a5
    6e28:	f4f745e3          	blt	a4,a5,6d72 <diskfull+0x134>
    6e2c:	a011                	j	6e30 <diskfull+0x1f2>
      break;
    6e2e:	0001                	nop
  }

  // this mkdir() is expected to fail.
  if(mkdir("diskfulldir") == 0)
    6e30:	00003517          	auipc	a0,0x3
    6e34:	78850513          	addi	a0,a0,1928 # a5b8 <malloc+0x23cc>
    6e38:	00001097          	auipc	ra,0x1
    6e3c:	cfc080e7          	jalr	-772(ra) # 7b34 <mkdir>
    6e40:	87aa                	mv	a5,a0
    6e42:	eb89                	bnez	a5,6e54 <diskfull+0x216>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n");
    6e44:	00003517          	auipc	a0,0x3
    6e48:	7a450513          	addi	a0,a0,1956 # a5e8 <malloc+0x23fc>
    6e4c:	00001097          	auipc	ra,0x1
    6e50:	1ac080e7          	jalr	428(ra) # 7ff8 <printf>

  unlink("diskfulldir");
    6e54:	00003517          	auipc	a0,0x3
    6e58:	76450513          	addi	a0,a0,1892 # a5b8 <malloc+0x23cc>
    6e5c:	00001097          	auipc	ra,0x1
    6e60:	cc0080e7          	jalr	-832(ra) # 7b1c <unlink>

  for(int i = 0; i < nzz; i++){
    6e64:	fc042e23          	sw	zero,-36(s0)
    6e68:	a8ad                	j	6ee2 <diskfull+0x2a4>
    char name[32];
    name[0] = 'z';
    6e6a:	07a00793          	li	a5,122
    6e6e:	bcf40423          	sb	a5,-1080(s0)
    name[1] = 'z';
    6e72:	07a00793          	li	a5,122
    6e76:	bcf404a3          	sb	a5,-1079(s0)
    name[2] = '0' + (i / 32);
    6e7a:	fdc42783          	lw	a5,-36(s0)
    6e7e:	41f7d71b          	sraiw	a4,a5,0x1f
    6e82:	01b7571b          	srliw	a4,a4,0x1b
    6e86:	9fb9                	addw	a5,a5,a4
    6e88:	4057d79b          	sraiw	a5,a5,0x5
    6e8c:	2781                	sext.w	a5,a5
    6e8e:	0ff7f793          	zext.b	a5,a5
    6e92:	0307879b          	addiw	a5,a5,48
    6e96:	0ff7f793          	zext.b	a5,a5
    6e9a:	bcf40523          	sb	a5,-1078(s0)
    name[3] = '0' + (i % 32);
    6e9e:	fdc42783          	lw	a5,-36(s0)
    6ea2:	873e                	mv	a4,a5
    6ea4:	41f7579b          	sraiw	a5,a4,0x1f
    6ea8:	01b7d79b          	srliw	a5,a5,0x1b
    6eac:	9f3d                	addw	a4,a4,a5
    6eae:	8b7d                	andi	a4,a4,31
    6eb0:	40f707bb          	subw	a5,a4,a5
    6eb4:	2781                	sext.w	a5,a5
    6eb6:	0ff7f793          	zext.b	a5,a5
    6eba:	0307879b          	addiw	a5,a5,48
    6ebe:	0ff7f793          	zext.b	a5,a5
    6ec2:	bcf405a3          	sb	a5,-1077(s0)
    name[4] = '\0';
    6ec6:	bc040623          	sb	zero,-1076(s0)
    unlink(name);
    6eca:	bc840793          	addi	a5,s0,-1080
    6ece:	853e                	mv	a0,a5
    6ed0:	00001097          	auipc	ra,0x1
    6ed4:	c4c080e7          	jalr	-948(ra) # 7b1c <unlink>
  for(int i = 0; i < nzz; i++){
    6ed8:	fdc42783          	lw	a5,-36(s0)
    6edc:	2785                	addiw	a5,a5,1
    6ede:	fcf42e23          	sw	a5,-36(s0)
    6ee2:	fdc42783          	lw	a5,-36(s0)
    6ee6:	873e                	mv	a4,a5
    6ee8:	fd042783          	lw	a5,-48(s0)
    6eec:	2701                	sext.w	a4,a4
    6eee:	2781                	sext.w	a5,a5
    6ef0:	f6f74de3          	blt	a4,a5,6e6a <diskfull+0x22c>
  }

  for(int i = 0; i < fi; i++){
    6ef4:	fc042c23          	sw	zero,-40(s0)
    6ef8:	a0a9                	j	6f42 <diskfull+0x304>
    char name[32];
    name[0] = 'b';
    6efa:	06200793          	li	a5,98
    6efe:	bcf40423          	sb	a5,-1080(s0)
    name[1] = 'i';
    6f02:	06900793          	li	a5,105
    6f06:	bcf404a3          	sb	a5,-1079(s0)
    name[2] = 'g';
    6f0a:	06700793          	li	a5,103
    6f0e:	bcf40523          	sb	a5,-1078(s0)
    name[3] = '0' + i;
    6f12:	fd842783          	lw	a5,-40(s0)
    6f16:	0ff7f793          	zext.b	a5,a5
    6f1a:	0307879b          	addiw	a5,a5,48
    6f1e:	0ff7f793          	zext.b	a5,a5
    6f22:	bcf405a3          	sb	a5,-1077(s0)
    name[4] = '\0';
    6f26:	bc040623          	sb	zero,-1076(s0)
    unlink(name);
    6f2a:	bc840793          	addi	a5,s0,-1080
    6f2e:	853e                	mv	a0,a5
    6f30:	00001097          	auipc	ra,0x1
    6f34:	bec080e7          	jalr	-1044(ra) # 7b1c <unlink>
  for(int i = 0; i < fi; i++){
    6f38:	fd842783          	lw	a5,-40(s0)
    6f3c:	2785                	addiw	a5,a5,1
    6f3e:	fcf42c23          	sw	a5,-40(s0)
    6f42:	fd842783          	lw	a5,-40(s0)
    6f46:	873e                	mv	a4,a5
    6f48:	fec42783          	lw	a5,-20(s0)
    6f4c:	2701                	sext.w	a4,a4
    6f4e:	2781                	sext.w	a5,a5
    6f50:	faf745e3          	blt	a4,a5,6efa <diskfull+0x2bc>
  }
}
    6f54:	0001                	nop
    6f56:	0001                	nop
    6f58:	46813083          	ld	ra,1128(sp)
    6f5c:	46013403          	ld	s0,1120(sp)
    6f60:	47010113          	addi	sp,sp,1136
    6f64:	8082                	ret

0000000000006f66 <outofinodes>:

void
outofinodes(char *s)
{
    6f66:	715d                	addi	sp,sp,-80
    6f68:	e486                	sd	ra,72(sp)
    6f6a:	e0a2                	sd	s0,64(sp)
    6f6c:	0880                	addi	s0,sp,80
    6f6e:	faa43c23          	sd	a0,-72(s0)
  int nzz = 32*32;
    6f72:	40000793          	li	a5,1024
    6f76:	fef42223          	sw	a5,-28(s0)
  for(int i = 0; i < nzz; i++){
    6f7a:	fe042623          	sw	zero,-20(s0)
    6f7e:	a06d                	j	7028 <outofinodes+0xc2>
    char name[32];
    name[0] = 'z';
    6f80:	07a00793          	li	a5,122
    6f84:	fcf40023          	sb	a5,-64(s0)
    name[1] = 'z';
    6f88:	07a00793          	li	a5,122
    6f8c:	fcf400a3          	sb	a5,-63(s0)
    name[2] = '0' + (i / 32);
    6f90:	fec42783          	lw	a5,-20(s0)
    6f94:	41f7d71b          	sraiw	a4,a5,0x1f
    6f98:	01b7571b          	srliw	a4,a4,0x1b
    6f9c:	9fb9                	addw	a5,a5,a4
    6f9e:	4057d79b          	sraiw	a5,a5,0x5
    6fa2:	2781                	sext.w	a5,a5
    6fa4:	0ff7f793          	zext.b	a5,a5
    6fa8:	0307879b          	addiw	a5,a5,48
    6fac:	0ff7f793          	zext.b	a5,a5
    6fb0:	fcf40123          	sb	a5,-62(s0)
    name[3] = '0' + (i % 32);
    6fb4:	fec42783          	lw	a5,-20(s0)
    6fb8:	873e                	mv	a4,a5
    6fba:	41f7579b          	sraiw	a5,a4,0x1f
    6fbe:	01b7d79b          	srliw	a5,a5,0x1b
    6fc2:	9f3d                	addw	a4,a4,a5
    6fc4:	8b7d                	andi	a4,a4,31
    6fc6:	40f707bb          	subw	a5,a4,a5
    6fca:	2781                	sext.w	a5,a5
    6fcc:	0ff7f793          	zext.b	a5,a5
    6fd0:	0307879b          	addiw	a5,a5,48
    6fd4:	0ff7f793          	zext.b	a5,a5
    6fd8:	fcf401a3          	sb	a5,-61(s0)
    name[4] = '\0';
    6fdc:	fc040223          	sb	zero,-60(s0)
    unlink(name);
    6fe0:	fc040793          	addi	a5,s0,-64
    6fe4:	853e                	mv	a0,a5
    6fe6:	00001097          	auipc	ra,0x1
    6fea:	b36080e7          	jalr	-1226(ra) # 7b1c <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    6fee:	fc040793          	addi	a5,s0,-64
    6ff2:	60200593          	li	a1,1538
    6ff6:	853e                	mv	a0,a5
    6ff8:	00001097          	auipc	ra,0x1
    6ffc:	b14080e7          	jalr	-1260(ra) # 7b0c <open>
    7000:	87aa                	mv	a5,a0
    7002:	fef42023          	sw	a5,-32(s0)
    if(fd < 0){
    7006:	fe042783          	lw	a5,-32(s0)
    700a:	2781                	sext.w	a5,a5
    700c:	0207c863          	bltz	a5,703c <outofinodes+0xd6>
      // failure is eventually expected.
      break;
    }
    close(fd);
    7010:	fe042783          	lw	a5,-32(s0)
    7014:	853e                	mv	a0,a5
    7016:	00001097          	auipc	ra,0x1
    701a:	ade080e7          	jalr	-1314(ra) # 7af4 <close>
  for(int i = 0; i < nzz; i++){
    701e:	fec42783          	lw	a5,-20(s0)
    7022:	2785                	addiw	a5,a5,1
    7024:	fef42623          	sw	a5,-20(s0)
    7028:	fec42783          	lw	a5,-20(s0)
    702c:	873e                	mv	a4,a5
    702e:	fe442783          	lw	a5,-28(s0)
    7032:	2701                	sext.w	a4,a4
    7034:	2781                	sext.w	a5,a5
    7036:	f4f745e3          	blt	a4,a5,6f80 <outofinodes+0x1a>
    703a:	a011                	j	703e <outofinodes+0xd8>
      break;
    703c:	0001                	nop
  }

  for(int i = 0; i < nzz; i++){
    703e:	fe042423          	sw	zero,-24(s0)
    7042:	a8ad                	j	70bc <outofinodes+0x156>
    char name[32];
    name[0] = 'z';
    7044:	07a00793          	li	a5,122
    7048:	fcf40023          	sb	a5,-64(s0)
    name[1] = 'z';
    704c:	07a00793          	li	a5,122
    7050:	fcf400a3          	sb	a5,-63(s0)
    name[2] = '0' + (i / 32);
    7054:	fe842783          	lw	a5,-24(s0)
    7058:	41f7d71b          	sraiw	a4,a5,0x1f
    705c:	01b7571b          	srliw	a4,a4,0x1b
    7060:	9fb9                	addw	a5,a5,a4
    7062:	4057d79b          	sraiw	a5,a5,0x5
    7066:	2781                	sext.w	a5,a5
    7068:	0ff7f793          	zext.b	a5,a5
    706c:	0307879b          	addiw	a5,a5,48
    7070:	0ff7f793          	zext.b	a5,a5
    7074:	fcf40123          	sb	a5,-62(s0)
    name[3] = '0' + (i % 32);
    7078:	fe842783          	lw	a5,-24(s0)
    707c:	873e                	mv	a4,a5
    707e:	41f7579b          	sraiw	a5,a4,0x1f
    7082:	01b7d79b          	srliw	a5,a5,0x1b
    7086:	9f3d                	addw	a4,a4,a5
    7088:	8b7d                	andi	a4,a4,31
    708a:	40f707bb          	subw	a5,a4,a5
    708e:	2781                	sext.w	a5,a5
    7090:	0ff7f793          	zext.b	a5,a5
    7094:	0307879b          	addiw	a5,a5,48
    7098:	0ff7f793          	zext.b	a5,a5
    709c:	fcf401a3          	sb	a5,-61(s0)
    name[4] = '\0';
    70a0:	fc040223          	sb	zero,-60(s0)
    unlink(name);
    70a4:	fc040793          	addi	a5,s0,-64
    70a8:	853e                	mv	a0,a5
    70aa:	00001097          	auipc	ra,0x1
    70ae:	a72080e7          	jalr	-1422(ra) # 7b1c <unlink>
  for(int i = 0; i < nzz; i++){
    70b2:	fe842783          	lw	a5,-24(s0)
    70b6:	2785                	addiw	a5,a5,1
    70b8:	fef42423          	sw	a5,-24(s0)
    70bc:	fe842783          	lw	a5,-24(s0)
    70c0:	873e                	mv	a4,a5
    70c2:	fe442783          	lw	a5,-28(s0)
    70c6:	2701                	sext.w	a4,a4
    70c8:	2781                	sext.w	a5,a5
    70ca:	f6f74de3          	blt	a4,a5,7044 <outofinodes+0xde>
  }
}
    70ce:	0001                	nop
    70d0:	0001                	nop
    70d2:	60a6                	ld	ra,72(sp)
    70d4:	6406                	ld	s0,64(sp)
    70d6:	6161                	addi	sp,sp,80
    70d8:	8082                	ret

00000000000070da <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    70da:	7179                	addi	sp,sp,-48
    70dc:	f406                	sd	ra,40(sp)
    70de:	f022                	sd	s0,32(sp)
    70e0:	1800                	addi	s0,sp,48
    70e2:	fca43c23          	sd	a0,-40(s0)
    70e6:	fcb43823          	sd	a1,-48(s0)
  int pid;
  int xstatus;

  printf("test %s: ", s);
    70ea:	fd043583          	ld	a1,-48(s0)
    70ee:	00003517          	auipc	a0,0x3
    70f2:	57a50513          	addi	a0,a0,1402 # a668 <malloc+0x247c>
    70f6:	00001097          	auipc	ra,0x1
    70fa:	f02080e7          	jalr	-254(ra) # 7ff8 <printf>
  if((pid = fork()) < 0) {
    70fe:	00001097          	auipc	ra,0x1
    7102:	9c6080e7          	jalr	-1594(ra) # 7ac4 <fork>
    7106:	87aa                	mv	a5,a0
    7108:	fef42623          	sw	a5,-20(s0)
    710c:	fec42783          	lw	a5,-20(s0)
    7110:	2781                	sext.w	a5,a5
    7112:	0007df63          	bgez	a5,7130 <run+0x56>
    printf("runtest: fork error\n");
    7116:	00003517          	auipc	a0,0x3
    711a:	56250513          	addi	a0,a0,1378 # a678 <malloc+0x248c>
    711e:	00001097          	auipc	ra,0x1
    7122:	eda080e7          	jalr	-294(ra) # 7ff8 <printf>
    exit(1);
    7126:	4505                	li	a0,1
    7128:	00001097          	auipc	ra,0x1
    712c:	9a4080e7          	jalr	-1628(ra) # 7acc <exit>
  }
  if(pid == 0) {
    7130:	fec42783          	lw	a5,-20(s0)
    7134:	2781                	sext.w	a5,a5
    7136:	eb99                	bnez	a5,714c <run+0x72>
    f(s);
    7138:	fd843783          	ld	a5,-40(s0)
    713c:	fd043503          	ld	a0,-48(s0)
    7140:	9782                	jalr	a5
    exit(0);
    7142:	4501                	li	a0,0
    7144:	00001097          	auipc	ra,0x1
    7148:	988080e7          	jalr	-1656(ra) # 7acc <exit>
  } else {
    wait(&xstatus);
    714c:	fe840793          	addi	a5,s0,-24
    7150:	853e                	mv	a0,a5
    7152:	00001097          	auipc	ra,0x1
    7156:	982080e7          	jalr	-1662(ra) # 7ad4 <wait>
    if(xstatus != 0) 
    715a:	fe842783          	lw	a5,-24(s0)
    715e:	cb91                	beqz	a5,7172 <run+0x98>
      printf("FAILED\n");
    7160:	00003517          	auipc	a0,0x3
    7164:	53050513          	addi	a0,a0,1328 # a690 <malloc+0x24a4>
    7168:	00001097          	auipc	ra,0x1
    716c:	e90080e7          	jalr	-368(ra) # 7ff8 <printf>
    7170:	a809                	j	7182 <run+0xa8>
    else
      printf("OK\n");
    7172:	00003517          	auipc	a0,0x3
    7176:	52650513          	addi	a0,a0,1318 # a698 <malloc+0x24ac>
    717a:	00001097          	auipc	ra,0x1
    717e:	e7e080e7          	jalr	-386(ra) # 7ff8 <printf>
    return xstatus == 0;
    7182:	fe842783          	lw	a5,-24(s0)
    7186:	0017b793          	seqz	a5,a5
    718a:	0ff7f793          	zext.b	a5,a5
    718e:	2781                	sext.w	a5,a5
  }
}
    7190:	853e                	mv	a0,a5
    7192:	70a2                	ld	ra,40(sp)
    7194:	7402                	ld	s0,32(sp)
    7196:	6145                	addi	sp,sp,48
    7198:	8082                	ret

000000000000719a <runtests>:

int
runtests(struct test *tests, char *justone) {
    719a:	7179                	addi	sp,sp,-48
    719c:	f406                	sd	ra,40(sp)
    719e:	f022                	sd	s0,32(sp)
    71a0:	1800                	addi	s0,sp,48
    71a2:	fca43c23          	sd	a0,-40(s0)
    71a6:	fcb43823          	sd	a1,-48(s0)
  for (struct test *t = tests; t->s != 0; t++) {
    71aa:	fd843783          	ld	a5,-40(s0)
    71ae:	fef43423          	sd	a5,-24(s0)
    71b2:	a8a9                	j	720c <runtests+0x72>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    71b4:	fd043783          	ld	a5,-48(s0)
    71b8:	cf89                	beqz	a5,71d2 <runtests+0x38>
    71ba:	fe843783          	ld	a5,-24(s0)
    71be:	679c                	ld	a5,8(a5)
    71c0:	fd043583          	ld	a1,-48(s0)
    71c4:	853e                	mv	a0,a5
    71c6:	00000097          	auipc	ra,0x0
    71ca:	4a4080e7          	jalr	1188(ra) # 766a <strcmp>
    71ce:	87aa                	mv	a5,a0
    71d0:	eb8d                	bnez	a5,7202 <runtests+0x68>
      if(!run(t->f, t->s)){
    71d2:	fe843783          	ld	a5,-24(s0)
    71d6:	6398                	ld	a4,0(a5)
    71d8:	fe843783          	ld	a5,-24(s0)
    71dc:	679c                	ld	a5,8(a5)
    71de:	85be                	mv	a1,a5
    71e0:	853a                	mv	a0,a4
    71e2:	00000097          	auipc	ra,0x0
    71e6:	ef8080e7          	jalr	-264(ra) # 70da <run>
    71ea:	87aa                	mv	a5,a0
    71ec:	eb99                	bnez	a5,7202 <runtests+0x68>
        printf("SOME TESTS FAILED\n");
    71ee:	00003517          	auipc	a0,0x3
    71f2:	4b250513          	addi	a0,a0,1202 # a6a0 <malloc+0x24b4>
    71f6:	00001097          	auipc	ra,0x1
    71fa:	e02080e7          	jalr	-510(ra) # 7ff8 <printf>
        return 1;
    71fe:	4785                	li	a5,1
    7200:	a819                	j	7216 <runtests+0x7c>
  for (struct test *t = tests; t->s != 0; t++) {
    7202:	fe843783          	ld	a5,-24(s0)
    7206:	07c1                	addi	a5,a5,16
    7208:	fef43423          	sd	a5,-24(s0)
    720c:	fe843783          	ld	a5,-24(s0)
    7210:	679c                	ld	a5,8(a5)
    7212:	f3cd                	bnez	a5,71b4 <runtests+0x1a>
      }
    }
  }
  return 0;
    7214:	4781                	li	a5,0
}
    7216:	853e                	mv	a0,a5
    7218:	70a2                	ld	ra,40(sp)
    721a:	7402                	ld	s0,32(sp)
    721c:	6145                	addi	sp,sp,48
    721e:	8082                	ret

0000000000007220 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    7220:	7139                	addi	sp,sp,-64
    7222:	fc06                	sd	ra,56(sp)
    7224:	f822                	sd	s0,48(sp)
    7226:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    7228:	fd040793          	addi	a5,s0,-48
    722c:	853e                	mv	a0,a5
    722e:	00001097          	auipc	ra,0x1
    7232:	8ae080e7          	jalr	-1874(ra) # 7adc <pipe>
    7236:	87aa                	mv	a5,a0
    7238:	0007df63          	bgez	a5,7256 <countfree+0x36>
    printf("pipe() failed in countfree()\n");
    723c:	00003517          	auipc	a0,0x3
    7240:	47c50513          	addi	a0,a0,1148 # a6b8 <malloc+0x24cc>
    7244:	00001097          	auipc	ra,0x1
    7248:	db4080e7          	jalr	-588(ra) # 7ff8 <printf>
    exit(1);
    724c:	4505                	li	a0,1
    724e:	00001097          	auipc	ra,0x1
    7252:	87e080e7          	jalr	-1922(ra) # 7acc <exit>
  }
  
  int pid = fork();
    7256:	00001097          	auipc	ra,0x1
    725a:	86e080e7          	jalr	-1938(ra) # 7ac4 <fork>
    725e:	87aa                	mv	a5,a0
    7260:	fef42423          	sw	a5,-24(s0)

  if(pid < 0){
    7264:	fe842783          	lw	a5,-24(s0)
    7268:	2781                	sext.w	a5,a5
    726a:	0007df63          	bgez	a5,7288 <countfree+0x68>
    printf("fork failed in countfree()\n");
    726e:	00003517          	auipc	a0,0x3
    7272:	46a50513          	addi	a0,a0,1130 # a6d8 <malloc+0x24ec>
    7276:	00001097          	auipc	ra,0x1
    727a:	d82080e7          	jalr	-638(ra) # 7ff8 <printf>
    exit(1);
    727e:	4505                	li	a0,1
    7280:	00001097          	auipc	ra,0x1
    7284:	84c080e7          	jalr	-1972(ra) # 7acc <exit>
  }

  if(pid == 0){
    7288:	fe842783          	lw	a5,-24(s0)
    728c:	2781                	sext.w	a5,a5
    728e:	e3d1                	bnez	a5,7312 <countfree+0xf2>
    close(fds[0]);
    7290:	fd042783          	lw	a5,-48(s0)
    7294:	853e                	mv	a0,a5
    7296:	00001097          	auipc	ra,0x1
    729a:	85e080e7          	jalr	-1954(ra) # 7af4 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
    729e:	6505                	lui	a0,0x1
    72a0:	00001097          	auipc	ra,0x1
    72a4:	8b4080e7          	jalr	-1868(ra) # 7b54 <sbrk>
    72a8:	87aa                	mv	a5,a0
    72aa:	fcf43c23          	sd	a5,-40(s0)
      if(a == 0xffffffffffffffff){
    72ae:	fd843703          	ld	a4,-40(s0)
    72b2:	57fd                	li	a5,-1
    72b4:	04f70963          	beq	a4,a5,7306 <countfree+0xe6>
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    72b8:	fd843703          	ld	a4,-40(s0)
    72bc:	6785                	lui	a5,0x1
    72be:	17fd                	addi	a5,a5,-1 # fff <truncate3+0x1b1>
    72c0:	97ba                	add	a5,a5,a4
    72c2:	873e                	mv	a4,a5
    72c4:	4785                	li	a5,1
    72c6:	00f70023          	sb	a5,0(a4)

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    72ca:	fd442783          	lw	a5,-44(s0)
    72ce:	4605                	li	a2,1
    72d0:	00001597          	auipc	a1,0x1
    72d4:	17058593          	addi	a1,a1,368 # 8440 <malloc+0x254>
    72d8:	853e                	mv	a0,a5
    72da:	00001097          	auipc	ra,0x1
    72de:	812080e7          	jalr	-2030(ra) # 7aec <write>
    72e2:	87aa                	mv	a5,a0
    72e4:	873e                	mv	a4,a5
    72e6:	4785                	li	a5,1
    72e8:	faf70be3          	beq	a4,a5,729e <countfree+0x7e>
        printf("write() failed in countfree()\n");
    72ec:	00003517          	auipc	a0,0x3
    72f0:	40c50513          	addi	a0,a0,1036 # a6f8 <malloc+0x250c>
    72f4:	00001097          	auipc	ra,0x1
    72f8:	d04080e7          	jalr	-764(ra) # 7ff8 <printf>
        exit(1);
    72fc:	4505                	li	a0,1
    72fe:	00000097          	auipc	ra,0x0
    7302:	7ce080e7          	jalr	1998(ra) # 7acc <exit>
        break;
    7306:	0001                	nop
      }
    }

    exit(0);
    7308:	4501                	li	a0,0
    730a:	00000097          	auipc	ra,0x0
    730e:	7c2080e7          	jalr	1986(ra) # 7acc <exit>
  }

  close(fds[1]);
    7312:	fd442783          	lw	a5,-44(s0)
    7316:	853e                	mv	a0,a5
    7318:	00000097          	auipc	ra,0x0
    731c:	7dc080e7          	jalr	2012(ra) # 7af4 <close>

  int n = 0;
    7320:	fe042623          	sw	zero,-20(s0)
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    7324:	fd042783          	lw	a5,-48(s0)
    7328:	fcf40713          	addi	a4,s0,-49
    732c:	4605                	li	a2,1
    732e:	85ba                	mv	a1,a4
    7330:	853e                	mv	a0,a5
    7332:	00000097          	auipc	ra,0x0
    7336:	7b2080e7          	jalr	1970(ra) # 7ae4 <read>
    733a:	87aa                	mv	a5,a0
    733c:	fef42223          	sw	a5,-28(s0)
    if(cc < 0){
    7340:	fe442783          	lw	a5,-28(s0)
    7344:	2781                	sext.w	a5,a5
    7346:	0007df63          	bgez	a5,7364 <countfree+0x144>
      printf("read() failed in countfree()\n");
    734a:	00003517          	auipc	a0,0x3
    734e:	3ce50513          	addi	a0,a0,974 # a718 <malloc+0x252c>
    7352:	00001097          	auipc	ra,0x1
    7356:	ca6080e7          	jalr	-858(ra) # 7ff8 <printf>
      exit(1);
    735a:	4505                	li	a0,1
    735c:	00000097          	auipc	ra,0x0
    7360:	770080e7          	jalr	1904(ra) # 7acc <exit>
    }
    if(cc == 0)
    7364:	fe442783          	lw	a5,-28(s0)
    7368:	2781                	sext.w	a5,a5
    736a:	e385                	bnez	a5,738a <countfree+0x16a>
      break;
    n += 1;
  }

  close(fds[0]);
    736c:	fd042783          	lw	a5,-48(s0)
    7370:	853e                	mv	a0,a5
    7372:	00000097          	auipc	ra,0x0
    7376:	782080e7          	jalr	1922(ra) # 7af4 <close>
  wait((int*)0);
    737a:	4501                	li	a0,0
    737c:	00000097          	auipc	ra,0x0
    7380:	758080e7          	jalr	1880(ra) # 7ad4 <wait>
  
  return n;
    7384:	fec42783          	lw	a5,-20(s0)
    7388:	a039                	j	7396 <countfree+0x176>
    n += 1;
    738a:	fec42783          	lw	a5,-20(s0)
    738e:	2785                	addiw	a5,a5,1
    7390:	fef42623          	sw	a5,-20(s0)
  while(1){
    7394:	bf41                	j	7324 <countfree+0x104>
}
    7396:	853e                	mv	a0,a5
    7398:	70e2                	ld	ra,56(sp)
    739a:	7442                	ld	s0,48(sp)
    739c:	6121                	addi	sp,sp,64
    739e:	8082                	ret

00000000000073a0 <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    73a0:	7179                	addi	sp,sp,-48
    73a2:	f406                	sd	ra,40(sp)
    73a4:	f022                	sd	s0,32(sp)
    73a6:	1800                	addi	s0,sp,48
    73a8:	87aa                	mv	a5,a0
    73aa:	872e                	mv	a4,a1
    73ac:	fcc43823          	sd	a2,-48(s0)
    73b0:	fcf42e23          	sw	a5,-36(s0)
    73b4:	87ba                	mv	a5,a4
    73b6:	fcf42c23          	sw	a5,-40(s0)
  do {
    printf("usertests starting\n");
    73ba:	00003517          	auipc	a0,0x3
    73be:	37e50513          	addi	a0,a0,894 # a738 <malloc+0x254c>
    73c2:	00001097          	auipc	ra,0x1
    73c6:	c36080e7          	jalr	-970(ra) # 7ff8 <printf>
    int free0 = countfree();
    73ca:	00000097          	auipc	ra,0x0
    73ce:	e56080e7          	jalr	-426(ra) # 7220 <countfree>
    73d2:	87aa                	mv	a5,a0
    73d4:	fef42623          	sw	a5,-20(s0)
    int free1 = 0;
    73d8:	fe042423          	sw	zero,-24(s0)
    if (runtests(quicktests, justone)) {
    73dc:	fd043583          	ld	a1,-48(s0)
    73e0:	00004517          	auipc	a0,0x4
    73e4:	c3050513          	addi	a0,a0,-976 # b010 <quicktests>
    73e8:	00000097          	auipc	ra,0x0
    73ec:	db2080e7          	jalr	-590(ra) # 719a <runtests>
    73f0:	87aa                	mv	a5,a0
    73f2:	cb91                	beqz	a5,7406 <drivetests+0x66>
      if(continuous != 2) {
    73f4:	fd842783          	lw	a5,-40(s0)
    73f8:	0007871b          	sext.w	a4,a5
    73fc:	4789                	li	a5,2
    73fe:	00f70463          	beq	a4,a5,7406 <drivetests+0x66>
        return 1;
    7402:	4785                	li	a5,1
    7404:	a04d                	j	74a6 <drivetests+0x106>
      }
    }
    if(!quick) {
    7406:	fdc42783          	lw	a5,-36(s0)
    740a:	2781                	sext.w	a5,a5
    740c:	e3a9                	bnez	a5,744e <drivetests+0xae>
      if (justone == 0)
    740e:	fd043783          	ld	a5,-48(s0)
    7412:	eb89                	bnez	a5,7424 <drivetests+0x84>
        printf("usertests slow tests starting\n");
    7414:	00003517          	auipc	a0,0x3
    7418:	33c50513          	addi	a0,a0,828 # a750 <malloc+0x2564>
    741c:	00001097          	auipc	ra,0x1
    7420:	bdc080e7          	jalr	-1060(ra) # 7ff8 <printf>
      if (runtests(slowtests, justone)) {
    7424:	fd043583          	ld	a1,-48(s0)
    7428:	00004517          	auipc	a0,0x4
    742c:	fb850513          	addi	a0,a0,-72 # b3e0 <slowtests>
    7430:	00000097          	auipc	ra,0x0
    7434:	d6a080e7          	jalr	-662(ra) # 719a <runtests>
    7438:	87aa                	mv	a5,a0
    743a:	cb91                	beqz	a5,744e <drivetests+0xae>
        if(continuous != 2) {
    743c:	fd842783          	lw	a5,-40(s0)
    7440:	0007871b          	sext.w	a4,a5
    7444:	4789                	li	a5,2
    7446:	00f70463          	beq	a4,a5,744e <drivetests+0xae>
          return 1;
    744a:	4785                	li	a5,1
    744c:	a8a9                	j	74a6 <drivetests+0x106>
        }
      }
    }
    if((free1 = countfree()) < free0) {
    744e:	00000097          	auipc	ra,0x0
    7452:	dd2080e7          	jalr	-558(ra) # 7220 <countfree>
    7456:	87aa                	mv	a5,a0
    7458:	fef42423          	sw	a5,-24(s0)
    745c:	fe842783          	lw	a5,-24(s0)
    7460:	873e                	mv	a4,a5
    7462:	fec42783          	lw	a5,-20(s0)
    7466:	2701                	sext.w	a4,a4
    7468:	2781                	sext.w	a5,a5
    746a:	02f75963          	bge	a4,a5,749c <drivetests+0xfc>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    746e:	fec42703          	lw	a4,-20(s0)
    7472:	fe842783          	lw	a5,-24(s0)
    7476:	863a                	mv	a2,a4
    7478:	85be                	mv	a1,a5
    747a:	00003517          	auipc	a0,0x3
    747e:	2f650513          	addi	a0,a0,758 # a770 <malloc+0x2584>
    7482:	00001097          	auipc	ra,0x1
    7486:	b76080e7          	jalr	-1162(ra) # 7ff8 <printf>
      if(continuous != 2) {
    748a:	fd842783          	lw	a5,-40(s0)
    748e:	0007871b          	sext.w	a4,a5
    7492:	4789                	li	a5,2
    7494:	00f70463          	beq	a4,a5,749c <drivetests+0xfc>
        return 1;
    7498:	4785                	li	a5,1
    749a:	a031                	j	74a6 <drivetests+0x106>
      }
    }
  } while(continuous);
    749c:	fd842783          	lw	a5,-40(s0)
    74a0:	2781                	sext.w	a5,a5
    74a2:	ff81                	bnez	a5,73ba <drivetests+0x1a>
  return 0;
    74a4:	4781                	li	a5,0
}
    74a6:	853e                	mv	a0,a5
    74a8:	70a2                	ld	ra,40(sp)
    74aa:	7402                	ld	s0,32(sp)
    74ac:	6145                	addi	sp,sp,48
    74ae:	8082                	ret

00000000000074b0 <main>:

int
main(int argc, char *argv[])
{
    74b0:	7179                	addi	sp,sp,-48
    74b2:	f406                	sd	ra,40(sp)
    74b4:	f022                	sd	s0,32(sp)
    74b6:	1800                	addi	s0,sp,48
    74b8:	87aa                	mv	a5,a0
    74ba:	fcb43823          	sd	a1,-48(s0)
    74be:	fcf42e23          	sw	a5,-36(s0)
  int continuous = 0;
    74c2:	fe042623          	sw	zero,-20(s0)
  int quick = 0;
    74c6:	fe042423          	sw	zero,-24(s0)
  char *justone = 0;
    74ca:	fe043023          	sd	zero,-32(s0)

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    74ce:	fdc42783          	lw	a5,-36(s0)
    74d2:	0007871b          	sext.w	a4,a5
    74d6:	4789                	li	a5,2
    74d8:	02f71563          	bne	a4,a5,7502 <main+0x52>
    74dc:	fd043783          	ld	a5,-48(s0)
    74e0:	07a1                	addi	a5,a5,8
    74e2:	639c                	ld	a5,0(a5)
    74e4:	00003597          	auipc	a1,0x3
    74e8:	2bc58593          	addi	a1,a1,700 # a7a0 <malloc+0x25b4>
    74ec:	853e                	mv	a0,a5
    74ee:	00000097          	auipc	ra,0x0
    74f2:	17c080e7          	jalr	380(ra) # 766a <strcmp>
    74f6:	87aa                	mv	a5,a0
    74f8:	e789                	bnez	a5,7502 <main+0x52>
    quick = 1;
    74fa:	4785                	li	a5,1
    74fc:	fef42423          	sw	a5,-24(s0)
    7500:	a0c9                	j	75c2 <main+0x112>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    7502:	fdc42783          	lw	a5,-36(s0)
    7506:	0007871b          	sext.w	a4,a5
    750a:	4789                	li	a5,2
    750c:	02f71563          	bne	a4,a5,7536 <main+0x86>
    7510:	fd043783          	ld	a5,-48(s0)
    7514:	07a1                	addi	a5,a5,8
    7516:	639c                	ld	a5,0(a5)
    7518:	00003597          	auipc	a1,0x3
    751c:	29058593          	addi	a1,a1,656 # a7a8 <malloc+0x25bc>
    7520:	853e                	mv	a0,a5
    7522:	00000097          	auipc	ra,0x0
    7526:	148080e7          	jalr	328(ra) # 766a <strcmp>
    752a:	87aa                	mv	a5,a0
    752c:	e789                	bnez	a5,7536 <main+0x86>
    continuous = 1;
    752e:	4785                	li	a5,1
    7530:	fef42623          	sw	a5,-20(s0)
    7534:	a079                	j	75c2 <main+0x112>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    7536:	fdc42783          	lw	a5,-36(s0)
    753a:	0007871b          	sext.w	a4,a5
    753e:	4789                	li	a5,2
    7540:	02f71563          	bne	a4,a5,756a <main+0xba>
    7544:	fd043783          	ld	a5,-48(s0)
    7548:	07a1                	addi	a5,a5,8
    754a:	639c                	ld	a5,0(a5)
    754c:	00003597          	auipc	a1,0x3
    7550:	26458593          	addi	a1,a1,612 # a7b0 <malloc+0x25c4>
    7554:	853e                	mv	a0,a5
    7556:	00000097          	auipc	ra,0x0
    755a:	114080e7          	jalr	276(ra) # 766a <strcmp>
    755e:	87aa                	mv	a5,a0
    7560:	e789                	bnez	a5,756a <main+0xba>
    continuous = 2;
    7562:	4789                	li	a5,2
    7564:	fef42623          	sw	a5,-20(s0)
    7568:	a8a9                	j	75c2 <main+0x112>
  } else if(argc == 2 && argv[1][0] != '-'){
    756a:	fdc42783          	lw	a5,-36(s0)
    756e:	0007871b          	sext.w	a4,a5
    7572:	4789                	li	a5,2
    7574:	02f71363          	bne	a4,a5,759a <main+0xea>
    7578:	fd043783          	ld	a5,-48(s0)
    757c:	07a1                	addi	a5,a5,8
    757e:	639c                	ld	a5,0(a5)
    7580:	0007c783          	lbu	a5,0(a5)
    7584:	873e                	mv	a4,a5
    7586:	02d00793          	li	a5,45
    758a:	00f70863          	beq	a4,a5,759a <main+0xea>
    justone = argv[1];
    758e:	fd043783          	ld	a5,-48(s0)
    7592:	679c                	ld	a5,8(a5)
    7594:	fef43023          	sd	a5,-32(s0)
    7598:	a02d                	j	75c2 <main+0x112>
  } else if(argc > 1){
    759a:	fdc42783          	lw	a5,-36(s0)
    759e:	0007871b          	sext.w	a4,a5
    75a2:	4785                	li	a5,1
    75a4:	00e7df63          	bge	a5,a4,75c2 <main+0x112>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    75a8:	00003517          	auipc	a0,0x3
    75ac:	21050513          	addi	a0,a0,528 # a7b8 <malloc+0x25cc>
    75b0:	00001097          	auipc	ra,0x1
    75b4:	a48080e7          	jalr	-1464(ra) # 7ff8 <printf>
    exit(1);
    75b8:	4505                	li	a0,1
    75ba:	00000097          	auipc	ra,0x0
    75be:	512080e7          	jalr	1298(ra) # 7acc <exit>
  }
  if (drivetests(quick, continuous, justone)) {
    75c2:	fec42703          	lw	a4,-20(s0)
    75c6:	fe842783          	lw	a5,-24(s0)
    75ca:	fe043603          	ld	a2,-32(s0)
    75ce:	85ba                	mv	a1,a4
    75d0:	853e                	mv	a0,a5
    75d2:	00000097          	auipc	ra,0x0
    75d6:	dce080e7          	jalr	-562(ra) # 73a0 <drivetests>
    75da:	87aa                	mv	a5,a0
    75dc:	c791                	beqz	a5,75e8 <main+0x138>
    exit(1);
    75de:	4505                	li	a0,1
    75e0:	00000097          	auipc	ra,0x0
    75e4:	4ec080e7          	jalr	1260(ra) # 7acc <exit>
  }
  printf("ALL TESTS PASSED\n");
    75e8:	00003517          	auipc	a0,0x3
    75ec:	20050513          	addi	a0,a0,512 # a7e8 <malloc+0x25fc>
    75f0:	00001097          	auipc	ra,0x1
    75f4:	a08080e7          	jalr	-1528(ra) # 7ff8 <printf>
  exit(0);
    75f8:	4501                	li	a0,0
    75fa:	00000097          	auipc	ra,0x0
    75fe:	4d2080e7          	jalr	1234(ra) # 7acc <exit>

0000000000007602 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
    7602:	1141                	addi	sp,sp,-16
    7604:	e406                	sd	ra,8(sp)
    7606:	e022                	sd	s0,0(sp)
    7608:	0800                	addi	s0,sp,16
  extern int main();
  main();
    760a:	00000097          	auipc	ra,0x0
    760e:	ea6080e7          	jalr	-346(ra) # 74b0 <main>
  exit(0);
    7612:	4501                	li	a0,0
    7614:	00000097          	auipc	ra,0x0
    7618:	4b8080e7          	jalr	1208(ra) # 7acc <exit>

000000000000761c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    761c:	7179                	addi	sp,sp,-48
    761e:	f406                	sd	ra,40(sp)
    7620:	f022                	sd	s0,32(sp)
    7622:	1800                	addi	s0,sp,48
    7624:	fca43c23          	sd	a0,-40(s0)
    7628:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
    762c:	fd843783          	ld	a5,-40(s0)
    7630:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
    7634:	0001                	nop
    7636:	fd043703          	ld	a4,-48(s0)
    763a:	00170793          	addi	a5,a4,1
    763e:	fcf43823          	sd	a5,-48(s0)
    7642:	fd843783          	ld	a5,-40(s0)
    7646:	00178693          	addi	a3,a5,1
    764a:	fcd43c23          	sd	a3,-40(s0)
    764e:	00074703          	lbu	a4,0(a4)
    7652:	00e78023          	sb	a4,0(a5)
    7656:	0007c783          	lbu	a5,0(a5)
    765a:	fff1                	bnez	a5,7636 <strcpy+0x1a>
    ;
  return os;
    765c:	fe843783          	ld	a5,-24(s0)
}
    7660:	853e                	mv	a0,a5
    7662:	70a2                	ld	ra,40(sp)
    7664:	7402                	ld	s0,32(sp)
    7666:	6145                	addi	sp,sp,48
    7668:	8082                	ret

000000000000766a <strcmp>:

int
strcmp(const char *p, const char *q)
{
    766a:	1101                	addi	sp,sp,-32
    766c:	ec06                	sd	ra,24(sp)
    766e:	e822                	sd	s0,16(sp)
    7670:	1000                	addi	s0,sp,32
    7672:	fea43423          	sd	a0,-24(s0)
    7676:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
    767a:	a819                	j	7690 <strcmp+0x26>
    p++, q++;
    767c:	fe843783          	ld	a5,-24(s0)
    7680:	0785                	addi	a5,a5,1
    7682:	fef43423          	sd	a5,-24(s0)
    7686:	fe043783          	ld	a5,-32(s0)
    768a:	0785                	addi	a5,a5,1
    768c:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
    7690:	fe843783          	ld	a5,-24(s0)
    7694:	0007c783          	lbu	a5,0(a5)
    7698:	cb99                	beqz	a5,76ae <strcmp+0x44>
    769a:	fe843783          	ld	a5,-24(s0)
    769e:	0007c703          	lbu	a4,0(a5)
    76a2:	fe043783          	ld	a5,-32(s0)
    76a6:	0007c783          	lbu	a5,0(a5)
    76aa:	fcf709e3          	beq	a4,a5,767c <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
    76ae:	fe843783          	ld	a5,-24(s0)
    76b2:	0007c783          	lbu	a5,0(a5)
    76b6:	0007871b          	sext.w	a4,a5
    76ba:	fe043783          	ld	a5,-32(s0)
    76be:	0007c783          	lbu	a5,0(a5)
    76c2:	2781                	sext.w	a5,a5
    76c4:	40f707bb          	subw	a5,a4,a5
    76c8:	2781                	sext.w	a5,a5
}
    76ca:	853e                	mv	a0,a5
    76cc:	60e2                	ld	ra,24(sp)
    76ce:	6442                	ld	s0,16(sp)
    76d0:	6105                	addi	sp,sp,32
    76d2:	8082                	ret

00000000000076d4 <strlen>:

uint
strlen(const char *s)
{
    76d4:	7179                	addi	sp,sp,-48
    76d6:	f406                	sd	ra,40(sp)
    76d8:	f022                	sd	s0,32(sp)
    76da:	1800                	addi	s0,sp,48
    76dc:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
    76e0:	fe042623          	sw	zero,-20(s0)
    76e4:	a031                	j	76f0 <strlen+0x1c>
    76e6:	fec42783          	lw	a5,-20(s0)
    76ea:	2785                	addiw	a5,a5,1
    76ec:	fef42623          	sw	a5,-20(s0)
    76f0:	fec42783          	lw	a5,-20(s0)
    76f4:	fd843703          	ld	a4,-40(s0)
    76f8:	97ba                	add	a5,a5,a4
    76fa:	0007c783          	lbu	a5,0(a5)
    76fe:	f7e5                	bnez	a5,76e6 <strlen+0x12>
    ;
  return n;
    7700:	fec42783          	lw	a5,-20(s0)
}
    7704:	853e                	mv	a0,a5
    7706:	70a2                	ld	ra,40(sp)
    7708:	7402                	ld	s0,32(sp)
    770a:	6145                	addi	sp,sp,48
    770c:	8082                	ret

000000000000770e <memset>:

void*
memset(void *dst, int c, uint n)
{
    770e:	7179                	addi	sp,sp,-48
    7710:	f406                	sd	ra,40(sp)
    7712:	f022                	sd	s0,32(sp)
    7714:	1800                	addi	s0,sp,48
    7716:	fca43c23          	sd	a0,-40(s0)
    771a:	87ae                	mv	a5,a1
    771c:	8732                	mv	a4,a2
    771e:	fcf42a23          	sw	a5,-44(s0)
    7722:	87ba                	mv	a5,a4
    7724:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
    7728:	fd843783          	ld	a5,-40(s0)
    772c:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
    7730:	fe042623          	sw	zero,-20(s0)
    7734:	a00d                	j	7756 <memset+0x48>
    cdst[i] = c;
    7736:	fec42783          	lw	a5,-20(s0)
    773a:	fe043703          	ld	a4,-32(s0)
    773e:	97ba                	add	a5,a5,a4
    7740:	fd442703          	lw	a4,-44(s0)
    7744:	0ff77713          	zext.b	a4,a4
    7748:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
    774c:	fec42783          	lw	a5,-20(s0)
    7750:	2785                	addiw	a5,a5,1
    7752:	fef42623          	sw	a5,-20(s0)
    7756:	fec42783          	lw	a5,-20(s0)
    775a:	fd042703          	lw	a4,-48(s0)
    775e:	2701                	sext.w	a4,a4
    7760:	fce7ebe3          	bltu	a5,a4,7736 <memset+0x28>
  }
  return dst;
    7764:	fd843783          	ld	a5,-40(s0)
}
    7768:	853e                	mv	a0,a5
    776a:	70a2                	ld	ra,40(sp)
    776c:	7402                	ld	s0,32(sp)
    776e:	6145                	addi	sp,sp,48
    7770:	8082                	ret

0000000000007772 <strchr>:

char*
strchr(const char *s, char c)
{
    7772:	1101                	addi	sp,sp,-32
    7774:	ec06                	sd	ra,24(sp)
    7776:	e822                	sd	s0,16(sp)
    7778:	1000                	addi	s0,sp,32
    777a:	fea43423          	sd	a0,-24(s0)
    777e:	87ae                	mv	a5,a1
    7780:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
    7784:	a01d                	j	77aa <strchr+0x38>
    if(*s == c)
    7786:	fe843783          	ld	a5,-24(s0)
    778a:	0007c703          	lbu	a4,0(a5)
    778e:	fe744783          	lbu	a5,-25(s0)
    7792:	0ff7f793          	zext.b	a5,a5
    7796:	00e79563          	bne	a5,a4,77a0 <strchr+0x2e>
      return (char*)s;
    779a:	fe843783          	ld	a5,-24(s0)
    779e:	a821                	j	77b6 <strchr+0x44>
  for(; *s; s++)
    77a0:	fe843783          	ld	a5,-24(s0)
    77a4:	0785                	addi	a5,a5,1
    77a6:	fef43423          	sd	a5,-24(s0)
    77aa:	fe843783          	ld	a5,-24(s0)
    77ae:	0007c783          	lbu	a5,0(a5)
    77b2:	fbf1                	bnez	a5,7786 <strchr+0x14>
  return 0;
    77b4:	4781                	li	a5,0
}
    77b6:	853e                	mv	a0,a5
    77b8:	60e2                	ld	ra,24(sp)
    77ba:	6442                	ld	s0,16(sp)
    77bc:	6105                	addi	sp,sp,32
    77be:	8082                	ret

00000000000077c0 <gets>:

char*
gets(char *buf, int max)
{
    77c0:	7179                	addi	sp,sp,-48
    77c2:	f406                	sd	ra,40(sp)
    77c4:	f022                	sd	s0,32(sp)
    77c6:	1800                	addi	s0,sp,48
    77c8:	fca43c23          	sd	a0,-40(s0)
    77cc:	87ae                	mv	a5,a1
    77ce:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    77d2:	fe042623          	sw	zero,-20(s0)
    77d6:	a8a1                	j	782e <gets+0x6e>
    cc = read(0, &c, 1);
    77d8:	fe740793          	addi	a5,s0,-25
    77dc:	4605                	li	a2,1
    77de:	85be                	mv	a1,a5
    77e0:	4501                	li	a0,0
    77e2:	00000097          	auipc	ra,0x0
    77e6:	302080e7          	jalr	770(ra) # 7ae4 <read>
    77ea:	87aa                	mv	a5,a0
    77ec:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
    77f0:	fe842783          	lw	a5,-24(s0)
    77f4:	2781                	sext.w	a5,a5
    77f6:	04f05663          	blez	a5,7842 <gets+0x82>
      break;
    buf[i++] = c;
    77fa:	fec42783          	lw	a5,-20(s0)
    77fe:	0017871b          	addiw	a4,a5,1
    7802:	fee42623          	sw	a4,-20(s0)
    7806:	873e                	mv	a4,a5
    7808:	fd843783          	ld	a5,-40(s0)
    780c:	97ba                	add	a5,a5,a4
    780e:	fe744703          	lbu	a4,-25(s0)
    7812:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
    7816:	fe744783          	lbu	a5,-25(s0)
    781a:	873e                	mv	a4,a5
    781c:	47a9                	li	a5,10
    781e:	02f70363          	beq	a4,a5,7844 <gets+0x84>
    7822:	fe744783          	lbu	a5,-25(s0)
    7826:	873e                	mv	a4,a5
    7828:	47b5                	li	a5,13
    782a:	00f70d63          	beq	a4,a5,7844 <gets+0x84>
  for(i=0; i+1 < max; ){
    782e:	fec42783          	lw	a5,-20(s0)
    7832:	2785                	addiw	a5,a5,1
    7834:	2781                	sext.w	a5,a5
    7836:	fd442703          	lw	a4,-44(s0)
    783a:	2701                	sext.w	a4,a4
    783c:	f8e7cee3          	blt	a5,a4,77d8 <gets+0x18>
    7840:	a011                	j	7844 <gets+0x84>
      break;
    7842:	0001                	nop
      break;
  }
  buf[i] = '\0';
    7844:	fec42783          	lw	a5,-20(s0)
    7848:	fd843703          	ld	a4,-40(s0)
    784c:	97ba                	add	a5,a5,a4
    784e:	00078023          	sb	zero,0(a5)
  return buf;
    7852:	fd843783          	ld	a5,-40(s0)
}
    7856:	853e                	mv	a0,a5
    7858:	70a2                	ld	ra,40(sp)
    785a:	7402                	ld	s0,32(sp)
    785c:	6145                	addi	sp,sp,48
    785e:	8082                	ret

0000000000007860 <stat>:

int
stat(const char *n, struct stat *st)
{
    7860:	7179                	addi	sp,sp,-48
    7862:	f406                	sd	ra,40(sp)
    7864:	f022                	sd	s0,32(sp)
    7866:	1800                	addi	s0,sp,48
    7868:	fca43c23          	sd	a0,-40(s0)
    786c:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    7870:	4581                	li	a1,0
    7872:	fd843503          	ld	a0,-40(s0)
    7876:	00000097          	auipc	ra,0x0
    787a:	296080e7          	jalr	662(ra) # 7b0c <open>
    787e:	87aa                	mv	a5,a0
    7880:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
    7884:	fec42783          	lw	a5,-20(s0)
    7888:	2781                	sext.w	a5,a5
    788a:	0007d463          	bgez	a5,7892 <stat+0x32>
    return -1;
    788e:	57fd                	li	a5,-1
    7890:	a035                	j	78bc <stat+0x5c>
  r = fstat(fd, st);
    7892:	fec42783          	lw	a5,-20(s0)
    7896:	fd043583          	ld	a1,-48(s0)
    789a:	853e                	mv	a0,a5
    789c:	00000097          	auipc	ra,0x0
    78a0:	288080e7          	jalr	648(ra) # 7b24 <fstat>
    78a4:	87aa                	mv	a5,a0
    78a6:	fef42423          	sw	a5,-24(s0)
  close(fd);
    78aa:	fec42783          	lw	a5,-20(s0)
    78ae:	853e                	mv	a0,a5
    78b0:	00000097          	auipc	ra,0x0
    78b4:	244080e7          	jalr	580(ra) # 7af4 <close>
  return r;
    78b8:	fe842783          	lw	a5,-24(s0)
}
    78bc:	853e                	mv	a0,a5
    78be:	70a2                	ld	ra,40(sp)
    78c0:	7402                	ld	s0,32(sp)
    78c2:	6145                	addi	sp,sp,48
    78c4:	8082                	ret

00000000000078c6 <atoi>:

int
atoi(const char *s)
{
    78c6:	7179                	addi	sp,sp,-48
    78c8:	f406                	sd	ra,40(sp)
    78ca:	f022                	sd	s0,32(sp)
    78cc:	1800                	addi	s0,sp,48
    78ce:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
    78d2:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
    78d6:	a81d                	j	790c <atoi+0x46>
    n = n*10 + *s++ - '0';
    78d8:	fec42783          	lw	a5,-20(s0)
    78dc:	873e                	mv	a4,a5
    78de:	87ba                	mv	a5,a4
    78e0:	0027979b          	slliw	a5,a5,0x2
    78e4:	9fb9                	addw	a5,a5,a4
    78e6:	0017979b          	slliw	a5,a5,0x1
    78ea:	0007871b          	sext.w	a4,a5
    78ee:	fd843783          	ld	a5,-40(s0)
    78f2:	00178693          	addi	a3,a5,1
    78f6:	fcd43c23          	sd	a3,-40(s0)
    78fa:	0007c783          	lbu	a5,0(a5)
    78fe:	2781                	sext.w	a5,a5
    7900:	9fb9                	addw	a5,a5,a4
    7902:	2781                	sext.w	a5,a5
    7904:	fd07879b          	addiw	a5,a5,-48
    7908:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
    790c:	fd843783          	ld	a5,-40(s0)
    7910:	0007c783          	lbu	a5,0(a5)
    7914:	873e                	mv	a4,a5
    7916:	02f00793          	li	a5,47
    791a:	00e7fb63          	bgeu	a5,a4,7930 <atoi+0x6a>
    791e:	fd843783          	ld	a5,-40(s0)
    7922:	0007c783          	lbu	a5,0(a5)
    7926:	873e                	mv	a4,a5
    7928:	03900793          	li	a5,57
    792c:	fae7f6e3          	bgeu	a5,a4,78d8 <atoi+0x12>
  return n;
    7930:	fec42783          	lw	a5,-20(s0)
}
    7934:	853e                	mv	a0,a5
    7936:	70a2                	ld	ra,40(sp)
    7938:	7402                	ld	s0,32(sp)
    793a:	6145                	addi	sp,sp,48
    793c:	8082                	ret

000000000000793e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    793e:	7139                	addi	sp,sp,-64
    7940:	fc06                	sd	ra,56(sp)
    7942:	f822                	sd	s0,48(sp)
    7944:	0080                	addi	s0,sp,64
    7946:	fca43c23          	sd	a0,-40(s0)
    794a:	fcb43823          	sd	a1,-48(s0)
    794e:	87b2                	mv	a5,a2
    7950:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
    7954:	fd843783          	ld	a5,-40(s0)
    7958:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
    795c:	fd043783          	ld	a5,-48(s0)
    7960:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
    7964:	fe043703          	ld	a4,-32(s0)
    7968:	fe843783          	ld	a5,-24(s0)
    796c:	02e7fc63          	bgeu	a5,a4,79a4 <memmove+0x66>
    while(n-- > 0)
    7970:	a00d                	j	7992 <memmove+0x54>
      *dst++ = *src++;
    7972:	fe043703          	ld	a4,-32(s0)
    7976:	00170793          	addi	a5,a4,1
    797a:	fef43023          	sd	a5,-32(s0)
    797e:	fe843783          	ld	a5,-24(s0)
    7982:	00178693          	addi	a3,a5,1
    7986:	fed43423          	sd	a3,-24(s0)
    798a:	00074703          	lbu	a4,0(a4)
    798e:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
    7992:	fcc42783          	lw	a5,-52(s0)
    7996:	fff7871b          	addiw	a4,a5,-1
    799a:	fce42623          	sw	a4,-52(s0)
    799e:	fcf04ae3          	bgtz	a5,7972 <memmove+0x34>
    79a2:	a891                	j	79f6 <memmove+0xb8>
  } else {
    dst += n;
    79a4:	fcc42783          	lw	a5,-52(s0)
    79a8:	fe843703          	ld	a4,-24(s0)
    79ac:	97ba                	add	a5,a5,a4
    79ae:	fef43423          	sd	a5,-24(s0)
    src += n;
    79b2:	fcc42783          	lw	a5,-52(s0)
    79b6:	fe043703          	ld	a4,-32(s0)
    79ba:	97ba                	add	a5,a5,a4
    79bc:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
    79c0:	a01d                	j	79e6 <memmove+0xa8>
      *--dst = *--src;
    79c2:	fe043783          	ld	a5,-32(s0)
    79c6:	17fd                	addi	a5,a5,-1
    79c8:	fef43023          	sd	a5,-32(s0)
    79cc:	fe843783          	ld	a5,-24(s0)
    79d0:	17fd                	addi	a5,a5,-1
    79d2:	fef43423          	sd	a5,-24(s0)
    79d6:	fe043783          	ld	a5,-32(s0)
    79da:	0007c703          	lbu	a4,0(a5)
    79de:	fe843783          	ld	a5,-24(s0)
    79e2:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
    79e6:	fcc42783          	lw	a5,-52(s0)
    79ea:	fff7871b          	addiw	a4,a5,-1
    79ee:	fce42623          	sw	a4,-52(s0)
    79f2:	fcf048e3          	bgtz	a5,79c2 <memmove+0x84>
  }
  return vdst;
    79f6:	fd843783          	ld	a5,-40(s0)
}
    79fa:	853e                	mv	a0,a5
    79fc:	70e2                	ld	ra,56(sp)
    79fe:	7442                	ld	s0,48(sp)
    7a00:	6121                	addi	sp,sp,64
    7a02:	8082                	ret

0000000000007a04 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    7a04:	7139                	addi	sp,sp,-64
    7a06:	fc06                	sd	ra,56(sp)
    7a08:	f822                	sd	s0,48(sp)
    7a0a:	0080                	addi	s0,sp,64
    7a0c:	fca43c23          	sd	a0,-40(s0)
    7a10:	fcb43823          	sd	a1,-48(s0)
    7a14:	87b2                	mv	a5,a2
    7a16:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
    7a1a:	fd843783          	ld	a5,-40(s0)
    7a1e:	fef43423          	sd	a5,-24(s0)
    7a22:	fd043783          	ld	a5,-48(s0)
    7a26:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
    7a2a:	a0a1                	j	7a72 <memcmp+0x6e>
    if (*p1 != *p2) {
    7a2c:	fe843783          	ld	a5,-24(s0)
    7a30:	0007c703          	lbu	a4,0(a5)
    7a34:	fe043783          	ld	a5,-32(s0)
    7a38:	0007c783          	lbu	a5,0(a5)
    7a3c:	02f70163          	beq	a4,a5,7a5e <memcmp+0x5a>
      return *p1 - *p2;
    7a40:	fe843783          	ld	a5,-24(s0)
    7a44:	0007c783          	lbu	a5,0(a5)
    7a48:	0007871b          	sext.w	a4,a5
    7a4c:	fe043783          	ld	a5,-32(s0)
    7a50:	0007c783          	lbu	a5,0(a5)
    7a54:	2781                	sext.w	a5,a5
    7a56:	40f707bb          	subw	a5,a4,a5
    7a5a:	2781                	sext.w	a5,a5
    7a5c:	a01d                	j	7a82 <memcmp+0x7e>
    }
    p1++;
    7a5e:	fe843783          	ld	a5,-24(s0)
    7a62:	0785                	addi	a5,a5,1
    7a64:	fef43423          	sd	a5,-24(s0)
    p2++;
    7a68:	fe043783          	ld	a5,-32(s0)
    7a6c:	0785                	addi	a5,a5,1
    7a6e:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
    7a72:	fcc42783          	lw	a5,-52(s0)
    7a76:	fff7871b          	addiw	a4,a5,-1
    7a7a:	fce42623          	sw	a4,-52(s0)
    7a7e:	f7dd                	bnez	a5,7a2c <memcmp+0x28>
  }
  return 0;
    7a80:	4781                	li	a5,0
}
    7a82:	853e                	mv	a0,a5
    7a84:	70e2                	ld	ra,56(sp)
    7a86:	7442                	ld	s0,48(sp)
    7a88:	6121                	addi	sp,sp,64
    7a8a:	8082                	ret

0000000000007a8c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    7a8c:	7179                	addi	sp,sp,-48
    7a8e:	f406                	sd	ra,40(sp)
    7a90:	f022                	sd	s0,32(sp)
    7a92:	1800                	addi	s0,sp,48
    7a94:	fea43423          	sd	a0,-24(s0)
    7a98:	feb43023          	sd	a1,-32(s0)
    7a9c:	87b2                	mv	a5,a2
    7a9e:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
    7aa2:	fdc42783          	lw	a5,-36(s0)
    7aa6:	863e                	mv	a2,a5
    7aa8:	fe043583          	ld	a1,-32(s0)
    7aac:	fe843503          	ld	a0,-24(s0)
    7ab0:	00000097          	auipc	ra,0x0
    7ab4:	e8e080e7          	jalr	-370(ra) # 793e <memmove>
    7ab8:	87aa                	mv	a5,a0
}
    7aba:	853e                	mv	a0,a5
    7abc:	70a2                	ld	ra,40(sp)
    7abe:	7402                	ld	s0,32(sp)
    7ac0:	6145                	addi	sp,sp,48
    7ac2:	8082                	ret

0000000000007ac4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    7ac4:	4885                	li	a7,1
 ecall
    7ac6:	00000073          	ecall
 ret
    7aca:	8082                	ret

0000000000007acc <exit>:
.global exit
exit:
 li a7, SYS_exit
    7acc:	4889                	li	a7,2
 ecall
    7ace:	00000073          	ecall
 ret
    7ad2:	8082                	ret

0000000000007ad4 <wait>:
.global wait
wait:
 li a7, SYS_wait
    7ad4:	488d                	li	a7,3
 ecall
    7ad6:	00000073          	ecall
 ret
    7ada:	8082                	ret

0000000000007adc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    7adc:	4891                	li	a7,4
 ecall
    7ade:	00000073          	ecall
 ret
    7ae2:	8082                	ret

0000000000007ae4 <read>:
.global read
read:
 li a7, SYS_read
    7ae4:	4895                	li	a7,5
 ecall
    7ae6:	00000073          	ecall
 ret
    7aea:	8082                	ret

0000000000007aec <write>:
.global write
write:
 li a7, SYS_write
    7aec:	48c1                	li	a7,16
 ecall
    7aee:	00000073          	ecall
 ret
    7af2:	8082                	ret

0000000000007af4 <close>:
.global close
close:
 li a7, SYS_close
    7af4:	48d5                	li	a7,21
 ecall
    7af6:	00000073          	ecall
 ret
    7afa:	8082                	ret

0000000000007afc <kill>:
.global kill
kill:
 li a7, SYS_kill
    7afc:	4899                	li	a7,6
 ecall
    7afe:	00000073          	ecall
 ret
    7b02:	8082                	ret

0000000000007b04 <exec>:
.global exec
exec:
 li a7, SYS_exec
    7b04:	489d                	li	a7,7
 ecall
    7b06:	00000073          	ecall
 ret
    7b0a:	8082                	ret

0000000000007b0c <open>:
.global open
open:
 li a7, SYS_open
    7b0c:	48bd                	li	a7,15
 ecall
    7b0e:	00000073          	ecall
 ret
    7b12:	8082                	ret

0000000000007b14 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    7b14:	48c5                	li	a7,17
 ecall
    7b16:	00000073          	ecall
 ret
    7b1a:	8082                	ret

0000000000007b1c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    7b1c:	48c9                	li	a7,18
 ecall
    7b1e:	00000073          	ecall
 ret
    7b22:	8082                	ret

0000000000007b24 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    7b24:	48a1                	li	a7,8
 ecall
    7b26:	00000073          	ecall
 ret
    7b2a:	8082                	ret

0000000000007b2c <link>:
.global link
link:
 li a7, SYS_link
    7b2c:	48cd                	li	a7,19
 ecall
    7b2e:	00000073          	ecall
 ret
    7b32:	8082                	ret

0000000000007b34 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    7b34:	48d1                	li	a7,20
 ecall
    7b36:	00000073          	ecall
 ret
    7b3a:	8082                	ret

0000000000007b3c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    7b3c:	48a5                	li	a7,9
 ecall
    7b3e:	00000073          	ecall
 ret
    7b42:	8082                	ret

0000000000007b44 <dup>:
.global dup
dup:
 li a7, SYS_dup
    7b44:	48a9                	li	a7,10
 ecall
    7b46:	00000073          	ecall
 ret
    7b4a:	8082                	ret

0000000000007b4c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    7b4c:	48ad                	li	a7,11
 ecall
    7b4e:	00000073          	ecall
 ret
    7b52:	8082                	ret

0000000000007b54 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    7b54:	48b1                	li	a7,12
 ecall
    7b56:	00000073          	ecall
 ret
    7b5a:	8082                	ret

0000000000007b5c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    7b5c:	48b5                	li	a7,13
 ecall
    7b5e:	00000073          	ecall
 ret
    7b62:	8082                	ret

0000000000007b64 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    7b64:	48b9                	li	a7,14
 ecall
    7b66:	00000073          	ecall
 ret
    7b6a:	8082                	ret

0000000000007b6c <ps>:
.global ps
ps:
 li a7, SYS_ps
    7b6c:	48d9                	li	a7,22
 ecall
    7b6e:	00000073          	ecall
 ret
    7b72:	8082                	ret

0000000000007b74 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    7b74:	1101                	addi	sp,sp,-32
    7b76:	ec06                	sd	ra,24(sp)
    7b78:	e822                	sd	s0,16(sp)
    7b7a:	1000                	addi	s0,sp,32
    7b7c:	87aa                	mv	a5,a0
    7b7e:	872e                	mv	a4,a1
    7b80:	fef42623          	sw	a5,-20(s0)
    7b84:	87ba                	mv	a5,a4
    7b86:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
    7b8a:	feb40713          	addi	a4,s0,-21
    7b8e:	fec42783          	lw	a5,-20(s0)
    7b92:	4605                	li	a2,1
    7b94:	85ba                	mv	a1,a4
    7b96:	853e                	mv	a0,a5
    7b98:	00000097          	auipc	ra,0x0
    7b9c:	f54080e7          	jalr	-172(ra) # 7aec <write>
}
    7ba0:	0001                	nop
    7ba2:	60e2                	ld	ra,24(sp)
    7ba4:	6442                	ld	s0,16(sp)
    7ba6:	6105                	addi	sp,sp,32
    7ba8:	8082                	ret

0000000000007baa <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    7baa:	7139                	addi	sp,sp,-64
    7bac:	fc06                	sd	ra,56(sp)
    7bae:	f822                	sd	s0,48(sp)
    7bb0:	0080                	addi	s0,sp,64
    7bb2:	87aa                	mv	a5,a0
    7bb4:	8736                	mv	a4,a3
    7bb6:	fcf42623          	sw	a5,-52(s0)
    7bba:	87ae                	mv	a5,a1
    7bbc:	fcf42423          	sw	a5,-56(s0)
    7bc0:	87b2                	mv	a5,a2
    7bc2:	fcf42223          	sw	a5,-60(s0)
    7bc6:	87ba                	mv	a5,a4
    7bc8:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    7bcc:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
    7bd0:	fc042783          	lw	a5,-64(s0)
    7bd4:	2781                	sext.w	a5,a5
    7bd6:	c38d                	beqz	a5,7bf8 <printint+0x4e>
    7bd8:	fc842783          	lw	a5,-56(s0)
    7bdc:	2781                	sext.w	a5,a5
    7bde:	0007dd63          	bgez	a5,7bf8 <printint+0x4e>
    neg = 1;
    7be2:	4785                	li	a5,1
    7be4:	fef42423          	sw	a5,-24(s0)
    x = -xx;
    7be8:	fc842783          	lw	a5,-56(s0)
    7bec:	40f007bb          	negw	a5,a5
    7bf0:	2781                	sext.w	a5,a5
    7bf2:	fef42223          	sw	a5,-28(s0)
    7bf6:	a029                	j	7c00 <printint+0x56>
  } else {
    x = xx;
    7bf8:	fc842783          	lw	a5,-56(s0)
    7bfc:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
    7c00:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
    7c04:	fc442783          	lw	a5,-60(s0)
    7c08:	fe442703          	lw	a4,-28(s0)
    7c0c:	02f777bb          	remuw	a5,a4,a5
    7c10:	0007871b          	sext.w	a4,a5
    7c14:	fec42783          	lw	a5,-20(s0)
    7c18:	0017869b          	addiw	a3,a5,1
    7c1c:	fed42623          	sw	a3,-20(s0)
    7c20:	00004697          	auipc	a3,0x4
    7c24:	83068693          	addi	a3,a3,-2000 # b450 <digits>
    7c28:	1702                	slli	a4,a4,0x20
    7c2a:	9301                	srli	a4,a4,0x20
    7c2c:	9736                	add	a4,a4,a3
    7c2e:	00074703          	lbu	a4,0(a4)
    7c32:	17c1                	addi	a5,a5,-16
    7c34:	97a2                	add	a5,a5,s0
    7c36:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
    7c3a:	fc442783          	lw	a5,-60(s0)
    7c3e:	fe442703          	lw	a4,-28(s0)
    7c42:	02f757bb          	divuw	a5,a4,a5
    7c46:	fef42223          	sw	a5,-28(s0)
    7c4a:	fe442783          	lw	a5,-28(s0)
    7c4e:	2781                	sext.w	a5,a5
    7c50:	fbd5                	bnez	a5,7c04 <printint+0x5a>
  if(neg)
    7c52:	fe842783          	lw	a5,-24(s0)
    7c56:	2781                	sext.w	a5,a5
    7c58:	cf85                	beqz	a5,7c90 <printint+0xe6>
    buf[i++] = '-';
    7c5a:	fec42783          	lw	a5,-20(s0)
    7c5e:	0017871b          	addiw	a4,a5,1
    7c62:	fee42623          	sw	a4,-20(s0)
    7c66:	17c1                	addi	a5,a5,-16
    7c68:	97a2                	add	a5,a5,s0
    7c6a:	02d00713          	li	a4,45
    7c6e:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
    7c72:	a839                	j	7c90 <printint+0xe6>
    putc(fd, buf[i]);
    7c74:	fec42783          	lw	a5,-20(s0)
    7c78:	17c1                	addi	a5,a5,-16
    7c7a:	97a2                	add	a5,a5,s0
    7c7c:	fe07c703          	lbu	a4,-32(a5)
    7c80:	fcc42783          	lw	a5,-52(s0)
    7c84:	85ba                	mv	a1,a4
    7c86:	853e                	mv	a0,a5
    7c88:	00000097          	auipc	ra,0x0
    7c8c:	eec080e7          	jalr	-276(ra) # 7b74 <putc>
  while(--i >= 0)
    7c90:	fec42783          	lw	a5,-20(s0)
    7c94:	37fd                	addiw	a5,a5,-1
    7c96:	fef42623          	sw	a5,-20(s0)
    7c9a:	fec42783          	lw	a5,-20(s0)
    7c9e:	2781                	sext.w	a5,a5
    7ca0:	fc07dae3          	bgez	a5,7c74 <printint+0xca>
}
    7ca4:	0001                	nop
    7ca6:	0001                	nop
    7ca8:	70e2                	ld	ra,56(sp)
    7caa:	7442                	ld	s0,48(sp)
    7cac:	6121                	addi	sp,sp,64
    7cae:	8082                	ret

0000000000007cb0 <printptr>:

static void
printptr(int fd, uint64 x) {
    7cb0:	7179                	addi	sp,sp,-48
    7cb2:	f406                	sd	ra,40(sp)
    7cb4:	f022                	sd	s0,32(sp)
    7cb6:	1800                	addi	s0,sp,48
    7cb8:	87aa                	mv	a5,a0
    7cba:	fcb43823          	sd	a1,-48(s0)
    7cbe:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
    7cc2:	fdc42783          	lw	a5,-36(s0)
    7cc6:	03000593          	li	a1,48
    7cca:	853e                	mv	a0,a5
    7ccc:	00000097          	auipc	ra,0x0
    7cd0:	ea8080e7          	jalr	-344(ra) # 7b74 <putc>
  putc(fd, 'x');
    7cd4:	fdc42783          	lw	a5,-36(s0)
    7cd8:	07800593          	li	a1,120
    7cdc:	853e                	mv	a0,a5
    7cde:	00000097          	auipc	ra,0x0
    7ce2:	e96080e7          	jalr	-362(ra) # 7b74 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    7ce6:	fe042623          	sw	zero,-20(s0)
    7cea:	a82d                	j	7d24 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    7cec:	fd043783          	ld	a5,-48(s0)
    7cf0:	93f1                	srli	a5,a5,0x3c
    7cf2:	00003717          	auipc	a4,0x3
    7cf6:	75e70713          	addi	a4,a4,1886 # b450 <digits>
    7cfa:	97ba                	add	a5,a5,a4
    7cfc:	0007c703          	lbu	a4,0(a5)
    7d00:	fdc42783          	lw	a5,-36(s0)
    7d04:	85ba                	mv	a1,a4
    7d06:	853e                	mv	a0,a5
    7d08:	00000097          	auipc	ra,0x0
    7d0c:	e6c080e7          	jalr	-404(ra) # 7b74 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    7d10:	fec42783          	lw	a5,-20(s0)
    7d14:	2785                	addiw	a5,a5,1
    7d16:	fef42623          	sw	a5,-20(s0)
    7d1a:	fd043783          	ld	a5,-48(s0)
    7d1e:	0792                	slli	a5,a5,0x4
    7d20:	fcf43823          	sd	a5,-48(s0)
    7d24:	fec42703          	lw	a4,-20(s0)
    7d28:	47bd                	li	a5,15
    7d2a:	fce7f1e3          	bgeu	a5,a4,7cec <printptr+0x3c>
}
    7d2e:	0001                	nop
    7d30:	0001                	nop
    7d32:	70a2                	ld	ra,40(sp)
    7d34:	7402                	ld	s0,32(sp)
    7d36:	6145                	addi	sp,sp,48
    7d38:	8082                	ret

0000000000007d3a <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    7d3a:	715d                	addi	sp,sp,-80
    7d3c:	e486                	sd	ra,72(sp)
    7d3e:	e0a2                	sd	s0,64(sp)
    7d40:	0880                	addi	s0,sp,80
    7d42:	87aa                	mv	a5,a0
    7d44:	fcb43023          	sd	a1,-64(s0)
    7d48:	fac43c23          	sd	a2,-72(s0)
    7d4c:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
    7d50:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
    7d54:	fe042223          	sw	zero,-28(s0)
    7d58:	a42d                	j	7f82 <vprintf+0x248>
    c = fmt[i] & 0xff;
    7d5a:	fe442783          	lw	a5,-28(s0)
    7d5e:	fc043703          	ld	a4,-64(s0)
    7d62:	97ba                	add	a5,a5,a4
    7d64:	0007c783          	lbu	a5,0(a5)
    7d68:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
    7d6c:	fe042783          	lw	a5,-32(s0)
    7d70:	2781                	sext.w	a5,a5
    7d72:	eb9d                	bnez	a5,7da8 <vprintf+0x6e>
      if(c == '%'){
    7d74:	fdc42783          	lw	a5,-36(s0)
    7d78:	0007871b          	sext.w	a4,a5
    7d7c:	02500793          	li	a5,37
    7d80:	00f71763          	bne	a4,a5,7d8e <vprintf+0x54>
        state = '%';
    7d84:	02500793          	li	a5,37
    7d88:	fef42023          	sw	a5,-32(s0)
    7d8c:	a2f5                	j	7f78 <vprintf+0x23e>
      } else {
        putc(fd, c);
    7d8e:	fdc42783          	lw	a5,-36(s0)
    7d92:	0ff7f713          	zext.b	a4,a5
    7d96:	fcc42783          	lw	a5,-52(s0)
    7d9a:	85ba                	mv	a1,a4
    7d9c:	853e                	mv	a0,a5
    7d9e:	00000097          	auipc	ra,0x0
    7da2:	dd6080e7          	jalr	-554(ra) # 7b74 <putc>
    7da6:	aac9                	j	7f78 <vprintf+0x23e>
      }
    } else if(state == '%'){
    7da8:	fe042783          	lw	a5,-32(s0)
    7dac:	0007871b          	sext.w	a4,a5
    7db0:	02500793          	li	a5,37
    7db4:	1cf71263          	bne	a4,a5,7f78 <vprintf+0x23e>
      if(c == 'd'){
    7db8:	fdc42783          	lw	a5,-36(s0)
    7dbc:	0007871b          	sext.w	a4,a5
    7dc0:	06400793          	li	a5,100
    7dc4:	02f71463          	bne	a4,a5,7dec <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
    7dc8:	fb843783          	ld	a5,-72(s0)
    7dcc:	00878713          	addi	a4,a5,8
    7dd0:	fae43c23          	sd	a4,-72(s0)
    7dd4:	4398                	lw	a4,0(a5)
    7dd6:	fcc42783          	lw	a5,-52(s0)
    7dda:	4685                	li	a3,1
    7ddc:	4629                	li	a2,10
    7dde:	85ba                	mv	a1,a4
    7de0:	853e                	mv	a0,a5
    7de2:	00000097          	auipc	ra,0x0
    7de6:	dc8080e7          	jalr	-568(ra) # 7baa <printint>
    7dea:	a269                	j	7f74 <vprintf+0x23a>
      } else if(c == 'l') {
    7dec:	fdc42783          	lw	a5,-36(s0)
    7df0:	0007871b          	sext.w	a4,a5
    7df4:	06c00793          	li	a5,108
    7df8:	02f71663          	bne	a4,a5,7e24 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
    7dfc:	fb843783          	ld	a5,-72(s0)
    7e00:	00878713          	addi	a4,a5,8
    7e04:	fae43c23          	sd	a4,-72(s0)
    7e08:	639c                	ld	a5,0(a5)
    7e0a:	0007871b          	sext.w	a4,a5
    7e0e:	fcc42783          	lw	a5,-52(s0)
    7e12:	4681                	li	a3,0
    7e14:	4629                	li	a2,10
    7e16:	85ba                	mv	a1,a4
    7e18:	853e                	mv	a0,a5
    7e1a:	00000097          	auipc	ra,0x0
    7e1e:	d90080e7          	jalr	-624(ra) # 7baa <printint>
    7e22:	aa89                	j	7f74 <vprintf+0x23a>
      } else if(c == 'x') {
    7e24:	fdc42783          	lw	a5,-36(s0)
    7e28:	0007871b          	sext.w	a4,a5
    7e2c:	07800793          	li	a5,120
    7e30:	02f71463          	bne	a4,a5,7e58 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
    7e34:	fb843783          	ld	a5,-72(s0)
    7e38:	00878713          	addi	a4,a5,8
    7e3c:	fae43c23          	sd	a4,-72(s0)
    7e40:	4398                	lw	a4,0(a5)
    7e42:	fcc42783          	lw	a5,-52(s0)
    7e46:	4681                	li	a3,0
    7e48:	4641                	li	a2,16
    7e4a:	85ba                	mv	a1,a4
    7e4c:	853e                	mv	a0,a5
    7e4e:	00000097          	auipc	ra,0x0
    7e52:	d5c080e7          	jalr	-676(ra) # 7baa <printint>
    7e56:	aa39                	j	7f74 <vprintf+0x23a>
      } else if(c == 'p') {
    7e58:	fdc42783          	lw	a5,-36(s0)
    7e5c:	0007871b          	sext.w	a4,a5
    7e60:	07000793          	li	a5,112
    7e64:	02f71263          	bne	a4,a5,7e88 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
    7e68:	fb843783          	ld	a5,-72(s0)
    7e6c:	00878713          	addi	a4,a5,8
    7e70:	fae43c23          	sd	a4,-72(s0)
    7e74:	6398                	ld	a4,0(a5)
    7e76:	fcc42783          	lw	a5,-52(s0)
    7e7a:	85ba                	mv	a1,a4
    7e7c:	853e                	mv	a0,a5
    7e7e:	00000097          	auipc	ra,0x0
    7e82:	e32080e7          	jalr	-462(ra) # 7cb0 <printptr>
    7e86:	a0fd                	j	7f74 <vprintf+0x23a>
      } else if(c == 's'){
    7e88:	fdc42783          	lw	a5,-36(s0)
    7e8c:	0007871b          	sext.w	a4,a5
    7e90:	07300793          	li	a5,115
    7e94:	04f71c63          	bne	a4,a5,7eec <vprintf+0x1b2>
        s = va_arg(ap, char*);
    7e98:	fb843783          	ld	a5,-72(s0)
    7e9c:	00878713          	addi	a4,a5,8
    7ea0:	fae43c23          	sd	a4,-72(s0)
    7ea4:	639c                	ld	a5,0(a5)
    7ea6:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
    7eaa:	fe843783          	ld	a5,-24(s0)
    7eae:	eb8d                	bnez	a5,7ee0 <vprintf+0x1a6>
          s = "(null)";
    7eb0:	00003797          	auipc	a5,0x3
    7eb4:	95878793          	addi	a5,a5,-1704 # a808 <malloc+0x261c>
    7eb8:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
    7ebc:	a015                	j	7ee0 <vprintf+0x1a6>
          putc(fd, *s);
    7ebe:	fe843783          	ld	a5,-24(s0)
    7ec2:	0007c703          	lbu	a4,0(a5)
    7ec6:	fcc42783          	lw	a5,-52(s0)
    7eca:	85ba                	mv	a1,a4
    7ecc:	853e                	mv	a0,a5
    7ece:	00000097          	auipc	ra,0x0
    7ed2:	ca6080e7          	jalr	-858(ra) # 7b74 <putc>
          s++;
    7ed6:	fe843783          	ld	a5,-24(s0)
    7eda:	0785                	addi	a5,a5,1
    7edc:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
    7ee0:	fe843783          	ld	a5,-24(s0)
    7ee4:	0007c783          	lbu	a5,0(a5)
    7ee8:	fbf9                	bnez	a5,7ebe <vprintf+0x184>
    7eea:	a069                	j	7f74 <vprintf+0x23a>
        }
      } else if(c == 'c'){
    7eec:	fdc42783          	lw	a5,-36(s0)
    7ef0:	0007871b          	sext.w	a4,a5
    7ef4:	06300793          	li	a5,99
    7ef8:	02f71463          	bne	a4,a5,7f20 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
    7efc:	fb843783          	ld	a5,-72(s0)
    7f00:	00878713          	addi	a4,a5,8
    7f04:	fae43c23          	sd	a4,-72(s0)
    7f08:	439c                	lw	a5,0(a5)
    7f0a:	0ff7f713          	zext.b	a4,a5
    7f0e:	fcc42783          	lw	a5,-52(s0)
    7f12:	85ba                	mv	a1,a4
    7f14:	853e                	mv	a0,a5
    7f16:	00000097          	auipc	ra,0x0
    7f1a:	c5e080e7          	jalr	-930(ra) # 7b74 <putc>
    7f1e:	a899                	j	7f74 <vprintf+0x23a>
      } else if(c == '%'){
    7f20:	fdc42783          	lw	a5,-36(s0)
    7f24:	0007871b          	sext.w	a4,a5
    7f28:	02500793          	li	a5,37
    7f2c:	00f71f63          	bne	a4,a5,7f4a <vprintf+0x210>
        putc(fd, c);
    7f30:	fdc42783          	lw	a5,-36(s0)
    7f34:	0ff7f713          	zext.b	a4,a5
    7f38:	fcc42783          	lw	a5,-52(s0)
    7f3c:	85ba                	mv	a1,a4
    7f3e:	853e                	mv	a0,a5
    7f40:	00000097          	auipc	ra,0x0
    7f44:	c34080e7          	jalr	-972(ra) # 7b74 <putc>
    7f48:	a035                	j	7f74 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    7f4a:	fcc42783          	lw	a5,-52(s0)
    7f4e:	02500593          	li	a1,37
    7f52:	853e                	mv	a0,a5
    7f54:	00000097          	auipc	ra,0x0
    7f58:	c20080e7          	jalr	-992(ra) # 7b74 <putc>
        putc(fd, c);
    7f5c:	fdc42783          	lw	a5,-36(s0)
    7f60:	0ff7f713          	zext.b	a4,a5
    7f64:	fcc42783          	lw	a5,-52(s0)
    7f68:	85ba                	mv	a1,a4
    7f6a:	853e                	mv	a0,a5
    7f6c:	00000097          	auipc	ra,0x0
    7f70:	c08080e7          	jalr	-1016(ra) # 7b74 <putc>
      }
      state = 0;
    7f74:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
    7f78:	fe442783          	lw	a5,-28(s0)
    7f7c:	2785                	addiw	a5,a5,1
    7f7e:	fef42223          	sw	a5,-28(s0)
    7f82:	fe442783          	lw	a5,-28(s0)
    7f86:	fc043703          	ld	a4,-64(s0)
    7f8a:	97ba                	add	a5,a5,a4
    7f8c:	0007c783          	lbu	a5,0(a5)
    7f90:	dc0795e3          	bnez	a5,7d5a <vprintf+0x20>
    }
  }
}
    7f94:	0001                	nop
    7f96:	0001                	nop
    7f98:	60a6                	ld	ra,72(sp)
    7f9a:	6406                	ld	s0,64(sp)
    7f9c:	6161                	addi	sp,sp,80
    7f9e:	8082                	ret

0000000000007fa0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    7fa0:	7159                	addi	sp,sp,-112
    7fa2:	fc06                	sd	ra,56(sp)
    7fa4:	f822                	sd	s0,48(sp)
    7fa6:	0080                	addi	s0,sp,64
    7fa8:	fcb43823          	sd	a1,-48(s0)
    7fac:	e010                	sd	a2,0(s0)
    7fae:	e414                	sd	a3,8(s0)
    7fb0:	e818                	sd	a4,16(s0)
    7fb2:	ec1c                	sd	a5,24(s0)
    7fb4:	03043023          	sd	a6,32(s0)
    7fb8:	03143423          	sd	a7,40(s0)
    7fbc:	87aa                	mv	a5,a0
    7fbe:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
    7fc2:	03040793          	addi	a5,s0,48
    7fc6:	fcf43423          	sd	a5,-56(s0)
    7fca:	fc843783          	ld	a5,-56(s0)
    7fce:	fd078793          	addi	a5,a5,-48
    7fd2:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
    7fd6:	fe843703          	ld	a4,-24(s0)
    7fda:	fdc42783          	lw	a5,-36(s0)
    7fde:	863a                	mv	a2,a4
    7fe0:	fd043583          	ld	a1,-48(s0)
    7fe4:	853e                	mv	a0,a5
    7fe6:	00000097          	auipc	ra,0x0
    7fea:	d54080e7          	jalr	-684(ra) # 7d3a <vprintf>
}
    7fee:	0001                	nop
    7ff0:	70e2                	ld	ra,56(sp)
    7ff2:	7442                	ld	s0,48(sp)
    7ff4:	6165                	addi	sp,sp,112
    7ff6:	8082                	ret

0000000000007ff8 <printf>:

void
printf(const char *fmt, ...)
{
    7ff8:	7159                	addi	sp,sp,-112
    7ffa:	f406                	sd	ra,40(sp)
    7ffc:	f022                	sd	s0,32(sp)
    7ffe:	1800                	addi	s0,sp,48
    8000:	fca43c23          	sd	a0,-40(s0)
    8004:	e40c                	sd	a1,8(s0)
    8006:	e810                	sd	a2,16(s0)
    8008:	ec14                	sd	a3,24(s0)
    800a:	f018                	sd	a4,32(s0)
    800c:	f41c                	sd	a5,40(s0)
    800e:	03043823          	sd	a6,48(s0)
    8012:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    8016:	04040793          	addi	a5,s0,64
    801a:	fcf43823          	sd	a5,-48(s0)
    801e:	fd043783          	ld	a5,-48(s0)
    8022:	fc878793          	addi	a5,a5,-56
    8026:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
    802a:	fe843783          	ld	a5,-24(s0)
    802e:	863e                	mv	a2,a5
    8030:	fd843583          	ld	a1,-40(s0)
    8034:	4505                	li	a0,1
    8036:	00000097          	auipc	ra,0x0
    803a:	d04080e7          	jalr	-764(ra) # 7d3a <vprintf>
}
    803e:	0001                	nop
    8040:	70a2                	ld	ra,40(sp)
    8042:	7402                	ld	s0,32(sp)
    8044:	6165                	addi	sp,sp,112
    8046:	8082                	ret

0000000000008048 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    8048:	7179                	addi	sp,sp,-48
    804a:	f406                	sd	ra,40(sp)
    804c:	f022                	sd	s0,32(sp)
    804e:	1800                	addi	s0,sp,48
    8050:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    8054:	fd843783          	ld	a5,-40(s0)
    8058:	17c1                	addi	a5,a5,-16
    805a:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    805e:	0000a797          	auipc	a5,0xa
    8062:	c3a78793          	addi	a5,a5,-966 # 11c98 <freep>
    8066:	639c                	ld	a5,0(a5)
    8068:	fef43423          	sd	a5,-24(s0)
    806c:	a815                	j	80a0 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    806e:	fe843783          	ld	a5,-24(s0)
    8072:	639c                	ld	a5,0(a5)
    8074:	fe843703          	ld	a4,-24(s0)
    8078:	00f76f63          	bltu	a4,a5,8096 <free+0x4e>
    807c:	fe043703          	ld	a4,-32(s0)
    8080:	fe843783          	ld	a5,-24(s0)
    8084:	02e7eb63          	bltu	a5,a4,80ba <free+0x72>
    8088:	fe843783          	ld	a5,-24(s0)
    808c:	639c                	ld	a5,0(a5)
    808e:	fe043703          	ld	a4,-32(s0)
    8092:	02f76463          	bltu	a4,a5,80ba <free+0x72>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    8096:	fe843783          	ld	a5,-24(s0)
    809a:	639c                	ld	a5,0(a5)
    809c:	fef43423          	sd	a5,-24(s0)
    80a0:	fe043703          	ld	a4,-32(s0)
    80a4:	fe843783          	ld	a5,-24(s0)
    80a8:	fce7f3e3          	bgeu	a5,a4,806e <free+0x26>
    80ac:	fe843783          	ld	a5,-24(s0)
    80b0:	639c                	ld	a5,0(a5)
    80b2:	fe043703          	ld	a4,-32(s0)
    80b6:	faf77ce3          	bgeu	a4,a5,806e <free+0x26>
      break;
  if(bp + bp->s.size == p->s.ptr){
    80ba:	fe043783          	ld	a5,-32(s0)
    80be:	479c                	lw	a5,8(a5)
    80c0:	1782                	slli	a5,a5,0x20
    80c2:	9381                	srli	a5,a5,0x20
    80c4:	0792                	slli	a5,a5,0x4
    80c6:	fe043703          	ld	a4,-32(s0)
    80ca:	973e                	add	a4,a4,a5
    80cc:	fe843783          	ld	a5,-24(s0)
    80d0:	639c                	ld	a5,0(a5)
    80d2:	02f71763          	bne	a4,a5,8100 <free+0xb8>
    bp->s.size += p->s.ptr->s.size;
    80d6:	fe043783          	ld	a5,-32(s0)
    80da:	4798                	lw	a4,8(a5)
    80dc:	fe843783          	ld	a5,-24(s0)
    80e0:	639c                	ld	a5,0(a5)
    80e2:	479c                	lw	a5,8(a5)
    80e4:	9fb9                	addw	a5,a5,a4
    80e6:	0007871b          	sext.w	a4,a5
    80ea:	fe043783          	ld	a5,-32(s0)
    80ee:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
    80f0:	fe843783          	ld	a5,-24(s0)
    80f4:	639c                	ld	a5,0(a5)
    80f6:	6398                	ld	a4,0(a5)
    80f8:	fe043783          	ld	a5,-32(s0)
    80fc:	e398                	sd	a4,0(a5)
    80fe:	a039                	j	810c <free+0xc4>
  } else
    bp->s.ptr = p->s.ptr;
    8100:	fe843783          	ld	a5,-24(s0)
    8104:	6398                	ld	a4,0(a5)
    8106:	fe043783          	ld	a5,-32(s0)
    810a:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
    810c:	fe843783          	ld	a5,-24(s0)
    8110:	479c                	lw	a5,8(a5)
    8112:	1782                	slli	a5,a5,0x20
    8114:	9381                	srli	a5,a5,0x20
    8116:	0792                	slli	a5,a5,0x4
    8118:	fe843703          	ld	a4,-24(s0)
    811c:	97ba                	add	a5,a5,a4
    811e:	fe043703          	ld	a4,-32(s0)
    8122:	02f71563          	bne	a4,a5,814c <free+0x104>
    p->s.size += bp->s.size;
    8126:	fe843783          	ld	a5,-24(s0)
    812a:	4798                	lw	a4,8(a5)
    812c:	fe043783          	ld	a5,-32(s0)
    8130:	479c                	lw	a5,8(a5)
    8132:	9fb9                	addw	a5,a5,a4
    8134:	0007871b          	sext.w	a4,a5
    8138:	fe843783          	ld	a5,-24(s0)
    813c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    813e:	fe043783          	ld	a5,-32(s0)
    8142:	6398                	ld	a4,0(a5)
    8144:	fe843783          	ld	a5,-24(s0)
    8148:	e398                	sd	a4,0(a5)
    814a:	a031                	j	8156 <free+0x10e>
  } else
    p->s.ptr = bp;
    814c:	fe843783          	ld	a5,-24(s0)
    8150:	fe043703          	ld	a4,-32(s0)
    8154:	e398                	sd	a4,0(a5)
  freep = p;
    8156:	0000a797          	auipc	a5,0xa
    815a:	b4278793          	addi	a5,a5,-1214 # 11c98 <freep>
    815e:	fe843703          	ld	a4,-24(s0)
    8162:	e398                	sd	a4,0(a5)
}
    8164:	0001                	nop
    8166:	70a2                	ld	ra,40(sp)
    8168:	7402                	ld	s0,32(sp)
    816a:	6145                	addi	sp,sp,48
    816c:	8082                	ret

000000000000816e <morecore>:

static Header*
morecore(uint nu)
{
    816e:	7179                	addi	sp,sp,-48
    8170:	f406                	sd	ra,40(sp)
    8172:	f022                	sd	s0,32(sp)
    8174:	1800                	addi	s0,sp,48
    8176:	87aa                	mv	a5,a0
    8178:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
    817c:	fdc42783          	lw	a5,-36(s0)
    8180:	0007871b          	sext.w	a4,a5
    8184:	6785                	lui	a5,0x1
    8186:	00f77563          	bgeu	a4,a5,8190 <morecore+0x22>
    nu = 4096;
    818a:	6785                	lui	a5,0x1
    818c:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
    8190:	fdc42783          	lw	a5,-36(s0)
    8194:	0047979b          	slliw	a5,a5,0x4
    8198:	2781                	sext.w	a5,a5
    819a:	853e                	mv	a0,a5
    819c:	00000097          	auipc	ra,0x0
    81a0:	9b8080e7          	jalr	-1608(ra) # 7b54 <sbrk>
    81a4:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
    81a8:	fe843703          	ld	a4,-24(s0)
    81ac:	57fd                	li	a5,-1
    81ae:	00f71463          	bne	a4,a5,81b6 <morecore+0x48>
    return 0;
    81b2:	4781                	li	a5,0
    81b4:	a03d                	j	81e2 <morecore+0x74>
  hp = (Header*)p;
    81b6:	fe843783          	ld	a5,-24(s0)
    81ba:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
    81be:	fe043783          	ld	a5,-32(s0)
    81c2:	fdc42703          	lw	a4,-36(s0)
    81c6:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
    81c8:	fe043783          	ld	a5,-32(s0)
    81cc:	07c1                	addi	a5,a5,16 # 1010 <truncate3+0x1c2>
    81ce:	853e                	mv	a0,a5
    81d0:	00000097          	auipc	ra,0x0
    81d4:	e78080e7          	jalr	-392(ra) # 8048 <free>
  return freep;
    81d8:	0000a797          	auipc	a5,0xa
    81dc:	ac078793          	addi	a5,a5,-1344 # 11c98 <freep>
    81e0:	639c                	ld	a5,0(a5)
}
    81e2:	853e                	mv	a0,a5
    81e4:	70a2                	ld	ra,40(sp)
    81e6:	7402                	ld	s0,32(sp)
    81e8:	6145                	addi	sp,sp,48
    81ea:	8082                	ret

00000000000081ec <malloc>:

void*
malloc(uint nbytes)
{
    81ec:	7139                	addi	sp,sp,-64
    81ee:	fc06                	sd	ra,56(sp)
    81f0:	f822                	sd	s0,48(sp)
    81f2:	0080                	addi	s0,sp,64
    81f4:	87aa                	mv	a5,a0
    81f6:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    81fa:	fcc46783          	lwu	a5,-52(s0)
    81fe:	07bd                	addi	a5,a5,15
    8200:	8391                	srli	a5,a5,0x4
    8202:	2781                	sext.w	a5,a5
    8204:	2785                	addiw	a5,a5,1
    8206:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
    820a:	0000a797          	auipc	a5,0xa
    820e:	a8e78793          	addi	a5,a5,-1394 # 11c98 <freep>
    8212:	639c                	ld	a5,0(a5)
    8214:	fef43023          	sd	a5,-32(s0)
    8218:	fe043783          	ld	a5,-32(s0)
    821c:	ef95                	bnez	a5,8258 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
    821e:	0000a797          	auipc	a5,0xa
    8222:	a6a78793          	addi	a5,a5,-1430 # 11c88 <base>
    8226:	fef43023          	sd	a5,-32(s0)
    822a:	0000a797          	auipc	a5,0xa
    822e:	a6e78793          	addi	a5,a5,-1426 # 11c98 <freep>
    8232:	fe043703          	ld	a4,-32(s0)
    8236:	e398                	sd	a4,0(a5)
    8238:	0000a797          	auipc	a5,0xa
    823c:	a6078793          	addi	a5,a5,-1440 # 11c98 <freep>
    8240:	6398                	ld	a4,0(a5)
    8242:	0000a797          	auipc	a5,0xa
    8246:	a4678793          	addi	a5,a5,-1466 # 11c88 <base>
    824a:	e398                	sd	a4,0(a5)
    base.s.size = 0;
    824c:	0000a797          	auipc	a5,0xa
    8250:	a3c78793          	addi	a5,a5,-1476 # 11c88 <base>
    8254:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    8258:	fe043783          	ld	a5,-32(s0)
    825c:	639c                	ld	a5,0(a5)
    825e:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
    8262:	fe843783          	ld	a5,-24(s0)
    8266:	479c                	lw	a5,8(a5)
    8268:	fdc42703          	lw	a4,-36(s0)
    826c:	2701                	sext.w	a4,a4
    826e:	06e7e763          	bltu	a5,a4,82dc <malloc+0xf0>
      if(p->s.size == nunits)
    8272:	fe843783          	ld	a5,-24(s0)
    8276:	479c                	lw	a5,8(a5)
    8278:	fdc42703          	lw	a4,-36(s0)
    827c:	2701                	sext.w	a4,a4
    827e:	00f71963          	bne	a4,a5,8290 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
    8282:	fe843783          	ld	a5,-24(s0)
    8286:	6398                	ld	a4,0(a5)
    8288:	fe043783          	ld	a5,-32(s0)
    828c:	e398                	sd	a4,0(a5)
    828e:	a825                	j	82c6 <malloc+0xda>
      else {
        p->s.size -= nunits;
    8290:	fe843783          	ld	a5,-24(s0)
    8294:	479c                	lw	a5,8(a5)
    8296:	fdc42703          	lw	a4,-36(s0)
    829a:	9f99                	subw	a5,a5,a4
    829c:	0007871b          	sext.w	a4,a5
    82a0:	fe843783          	ld	a5,-24(s0)
    82a4:	c798                	sw	a4,8(a5)
        p += p->s.size;
    82a6:	fe843783          	ld	a5,-24(s0)
    82aa:	479c                	lw	a5,8(a5)
    82ac:	1782                	slli	a5,a5,0x20
    82ae:	9381                	srli	a5,a5,0x20
    82b0:	0792                	slli	a5,a5,0x4
    82b2:	fe843703          	ld	a4,-24(s0)
    82b6:	97ba                	add	a5,a5,a4
    82b8:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
    82bc:	fe843783          	ld	a5,-24(s0)
    82c0:	fdc42703          	lw	a4,-36(s0)
    82c4:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
    82c6:	0000a797          	auipc	a5,0xa
    82ca:	9d278793          	addi	a5,a5,-1582 # 11c98 <freep>
    82ce:	fe043703          	ld	a4,-32(s0)
    82d2:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
    82d4:	fe843783          	ld	a5,-24(s0)
    82d8:	07c1                	addi	a5,a5,16
    82da:	a091                	j	831e <malloc+0x132>
    }
    if(p == freep)
    82dc:	0000a797          	auipc	a5,0xa
    82e0:	9bc78793          	addi	a5,a5,-1604 # 11c98 <freep>
    82e4:	639c                	ld	a5,0(a5)
    82e6:	fe843703          	ld	a4,-24(s0)
    82ea:	02f71063          	bne	a4,a5,830a <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
    82ee:	fdc42783          	lw	a5,-36(s0)
    82f2:	853e                	mv	a0,a5
    82f4:	00000097          	auipc	ra,0x0
    82f8:	e7a080e7          	jalr	-390(ra) # 816e <morecore>
    82fc:	fea43423          	sd	a0,-24(s0)
    8300:	fe843783          	ld	a5,-24(s0)
    8304:	e399                	bnez	a5,830a <malloc+0x11e>
        return 0;
    8306:	4781                	li	a5,0
    8308:	a819                	j	831e <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    830a:	fe843783          	ld	a5,-24(s0)
    830e:	fef43023          	sd	a5,-32(s0)
    8312:	fe843783          	ld	a5,-24(s0)
    8316:	639c                	ld	a5,0(a5)
    8318:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
    831c:	b799                	j	8262 <malloc+0x76>
  }
}
    831e:	853e                	mv	a0,a5
    8320:	70e2                	ld	ra,56(sp)
    8322:	7442                	ld	s0,48(sp)
    8324:	6121                	addi	sp,sp,64
    8326:	8082                	ret
