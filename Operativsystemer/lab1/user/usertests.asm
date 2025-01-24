
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
      56:	2ce50513          	addi	a0,a0,718 # 8320 <malloc+0x13c>
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
      76:	2b650513          	addi	a0,a0,694 # 8328 <malloc+0x144>
      7a:	00008097          	auipc	ra,0x8
      7e:	f76080e7          	jalr	-138(ra) # 7ff0 <printf>
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
      c0:	28450513          	addi	a0,a0,644 # 8340 <malloc+0x15c>
      c4:	00008097          	auipc	ra,0x8
      c8:	f2c080e7          	jalr	-212(ra) # 7ff0 <printf>
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
      e8:	23c50513          	addi	a0,a0,572 # 8320 <malloc+0x13c>
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
     124:	25050513          	addi	a0,a0,592 # 8370 <malloc+0x18c>
     128:	00008097          	auipc	ra,0x8
     12c:	ec8080e7          	jalr	-312(ra) # 7ff0 <printf>
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
     152:	25250513          	addi	a0,a0,594 # 83a0 <malloc+0x1bc>
     156:	00008097          	auipc	ra,0x8
     15a:	e9a080e7          	jalr	-358(ra) # 7ff0 <printf>
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
     19c:	21850513          	addi	a0,a0,536 # 83b0 <malloc+0x1cc>
     1a0:	00008097          	auipc	ra,0x8
     1a4:	e50080e7          	jalr	-432(ra) # 7ff0 <printf>
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
     22a:	1ba50513          	addi	a0,a0,442 # 83e0 <malloc+0x1fc>
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
     24a:	1a250513          	addi	a0,a0,418 # 83e8 <malloc+0x204>
     24e:	00008097          	auipc	ra,0x8
     252:	da2080e7          	jalr	-606(ra) # 7ff0 <printf>
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
     294:	17050513          	addi	a0,a0,368 # 8400 <malloc+0x21c>
     298:	00008097          	auipc	ra,0x8
     29c:	d58080e7          	jalr	-680(ra) # 7ff0 <printf>
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
     2d0:	0d450513          	addi	a0,a0,212 # 83a0 <malloc+0x1bc>
     2d4:	00008097          	auipc	ra,0x8
     2d8:	d1c080e7          	jalr	-740(ra) # 7ff0 <printf>
      exit(1);
     2dc:	4505                	li	a0,1
     2de:	00007097          	auipc	ra,0x7
     2e2:	7ee080e7          	jalr	2030(ra) # 7acc <exit>
    }
    n = write(fds[1], "x", 1);
     2e6:	fc442783          	lw	a5,-60(s0)
     2ea:	4605                	li	a2,1
     2ec:	00008597          	auipc	a1,0x8
     2f0:	14458593          	addi	a1,a1,324 # 8430 <malloc+0x24c>
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
     316:	12650513          	addi	a0,a0,294 # 8438 <malloc+0x254>
     31a:	00008097          	auipc	ra,0x8
     31e:	cd6080e7          	jalr	-810(ra) # 7ff0 <printf>
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
     360:	0f450513          	addi	a0,a0,244 # 8450 <malloc+0x26c>
     364:	00008097          	auipc	ra,0x8
     368:	c8c080e7          	jalr	-884(ra) # 7ff0 <printf>
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
     418:	06c50513          	addi	a0,a0,108 # 8480 <malloc+0x29c>
     41c:	00008097          	auipc	ra,0x8
     420:	bd4080e7          	jalr	-1068(ra) # 7ff0 <printf>
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
     4c4:	fe050513          	addi	a0,a0,-32 # 84a0 <malloc+0x2bc>
     4c8:	00008097          	auipc	ra,0x8
     4cc:	b28080e7          	jalr	-1240(ra) # 7ff0 <printf>
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
     510:	fb450513          	addi	a0,a0,-76 # 84c0 <malloc+0x2dc>
     514:	00008097          	auipc	ra,0x8
     518:	adc080e7          	jalr	-1316(ra) # 7ff0 <printf>
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
     562:	f8250513          	addi	a0,a0,-126 # 84e0 <malloc+0x2fc>
     566:	00008097          	auipc	ra,0x8
     56a:	a8a080e7          	jalr	-1398(ra) # 7ff0 <printf>
    exit(1);
     56e:	4505                	li	a0,1
     570:	00007097          	auipc	ra,0x7
     574:	55c080e7          	jalr	1372(ra) # 7acc <exit>
  }

  char *args[] = { "xx", 0 };
     578:	00008797          	auipc	a5,0x8
     57c:	f9078793          	addi	a5,a5,-112 # 8508 <malloc+0x324>
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
     5c0:	f5450513          	addi	a0,a0,-172 # 8510 <malloc+0x32c>
     5c4:	00008097          	auipc	ra,0x8
     5c8:	a2c080e7          	jalr	-1492(ra) # 7ff0 <printf>
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
     5f2:	f4250513          	addi	a0,a0,-190 # 8530 <malloc+0x34c>
     5f6:	00008097          	auipc	ra,0x8
     5fa:	9fa080e7          	jalr	-1542(ra) # 7ff0 <printf>
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
     658:	f4c78793          	addi	a5,a5,-180 # 85a0 <malloc+0x3bc>
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
     67e:	ec650513          	addi	a0,a0,-314 # 8540 <malloc+0x35c>
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
     6a8:	ea450513          	addi	a0,a0,-348 # 8548 <malloc+0x364>
     6ac:	00008097          	auipc	ra,0x8
     6b0:	944080e7          	jalr	-1724(ra) # 7ff0 <printf>
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
     6ec:	e8850513          	addi	a0,a0,-376 # 8570 <malloc+0x38c>
     6f0:	00008097          	auipc	ra,0x8
     6f4:	900080e7          	jalr	-1792(ra) # 7ff0 <printf>
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
     780:	e4450513          	addi	a0,a0,-444 # 85c0 <malloc+0x3dc>
     784:	00008097          	auipc	ra,0x8
     788:	86c080e7          	jalr	-1940(ra) # 7ff0 <printf>
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
     7da:	cca50513          	addi	a0,a0,-822 # 84a0 <malloc+0x2bc>
     7de:	00008097          	auipc	ra,0x8
     7e2:	812080e7          	jalr	-2030(ra) # 7ff0 <printf>
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
     822:	ca250513          	addi	a0,a0,-862 # 84c0 <malloc+0x2dc>
     826:	00007097          	auipc	ra,0x7
     82a:	7ca080e7          	jalr	1994(ra) # 7ff0 <printf>
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
     86e:	c7650513          	addi	a0,a0,-906 # 84e0 <malloc+0x2fc>
     872:	00007097          	auipc	ra,0x7
     876:	77e080e7          	jalr	1918(ra) # 7ff0 <printf>
    exit(1);
     87a:	4505                	li	a0,1
     87c:	00007097          	auipc	ra,0x7
     880:	250080e7          	jalr	592(ra) # 7acc <exit>
  }

  char *args[] = { "xx", 0 };
     884:	00008797          	auipc	a5,0x8
     888:	c8478793          	addi	a5,a5,-892 # 8508 <malloc+0x324>
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
     8c8:	c4c50513          	addi	a0,a0,-948 # 8510 <malloc+0x32c>
     8cc:	00007097          	auipc	ra,0x7
     8d0:	724080e7          	jalr	1828(ra) # 7ff0 <printf>
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
     90e:	cbe50513          	addi	a0,a0,-834 # 85c8 <malloc+0x3e4>
     912:	00007097          	auipc	ra,0x7
     916:	6de080e7          	jalr	1758(ra) # 7ff0 <printf>
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
     93a:	caa50513          	addi	a0,a0,-854 # 85e0 <malloc+0x3fc>
     93e:	00007097          	auipc	ra,0x7
     942:	6b2080e7          	jalr	1714(ra) # 7ff0 <printf>
    exit(1);
     946:	4505                	li	a0,1
     948:	00007097          	auipc	ra,0x7
     94c:	184080e7          	jalr	388(ra) # 7acc <exit>
  }

  fd = open("rwsbrk", O_CREATE|O_WRONLY);
     950:	20100593          	li	a1,513
     954:	00008517          	auipc	a0,0x8
     958:	cac50513          	addi	a0,a0,-852 # 8600 <malloc+0x41c>
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
     978:	c9450513          	addi	a0,a0,-876 # 8608 <malloc+0x424>
     97c:	00007097          	auipc	ra,0x7
     980:	674080e7          	jalr	1652(ra) # 7ff0 <printf>
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
     9d0:	c5450513          	addi	a0,a0,-940 # 8620 <malloc+0x43c>
     9d4:	00007097          	auipc	ra,0x7
     9d8:	61c080e7          	jalr	1564(ra) # 7ff0 <printf>
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
     9f8:	c0c50513          	addi	a0,a0,-1012 # 8600 <malloc+0x41c>
     9fc:	00007097          	auipc	ra,0x7
     a00:	120080e7          	jalr	288(ra) # 7b1c <unlink>

  fd = open("README", O_RDONLY);
     a04:	4581                	li	a1,0
     a06:	00008517          	auipc	a0,0x8
     a0a:	9da50513          	addi	a0,a0,-1574 # 83e0 <malloc+0x1fc>
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
     a2a:	be250513          	addi	a0,a0,-1054 # 8608 <malloc+0x424>
     a2e:	00007097          	auipc	ra,0x7
     a32:	5c2080e7          	jalr	1474(ra) # 7ff0 <printf>
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
     a80:	bd450513          	addi	a0,a0,-1068 # 8650 <malloc+0x46c>
     a84:	00007097          	auipc	ra,0x7
     a88:	56c080e7          	jalr	1388(ra) # 7ff0 <printf>
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
     abe:	bbe50513          	addi	a0,a0,-1090 # 8678 <malloc+0x494>
     ac2:	00007097          	auipc	ra,0x7
     ac6:	05a080e7          	jalr	90(ra) # 7b1c <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     aca:	60100593          	li	a1,1537
     ace:	00008517          	auipc	a0,0x8
     ad2:	baa50513          	addi	a0,a0,-1110 # 8678 <malloc+0x494>
     ad6:	00007097          	auipc	ra,0x7
     ada:	036080e7          	jalr	54(ra) # 7b0c <open>
     ade:	87aa                	mv	a5,a0
     ae0:	fef42623          	sw	a5,-20(s0)
  write(fd1, "abcd", 4);
     ae4:	fec42783          	lw	a5,-20(s0)
     ae8:	4611                	li	a2,4
     aea:	00008597          	auipc	a1,0x8
     aee:	b9e58593          	addi	a1,a1,-1122 # 8688 <malloc+0x4a4>
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
     b10:	b6c50513          	addi	a0,a0,-1172 # 8678 <malloc+0x494>
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
     b5c:	b3850513          	addi	a0,a0,-1224 # 8690 <malloc+0x4ac>
     b60:	00007097          	auipc	ra,0x7
     b64:	490080e7          	jalr	1168(ra) # 7ff0 <printf>
    exit(1);
     b68:	4505                	li	a0,1
     b6a:	00007097          	auipc	ra,0x7
     b6e:	f62080e7          	jalr	-158(ra) # 7acc <exit>
  }

  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     b72:	40100593          	li	a1,1025
     b76:	00008517          	auipc	a0,0x8
     b7a:	b0250513          	addi	a0,a0,-1278 # 8678 <malloc+0x494>
     b7e:	00007097          	auipc	ra,0x7
     b82:	f8e080e7          	jalr	-114(ra) # 7b0c <open>
     b86:	87aa                	mv	a5,a0
     b88:	fef42623          	sw	a5,-20(s0)

  int fd3 = open("truncfile", O_RDONLY);
     b8c:	4581                	li	a1,0
     b8e:	00008517          	auipc	a0,0x8
     b92:	aea50513          	addi	a0,a0,-1302 # 8678 <malloc+0x494>
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
     bd4:	ae050513          	addi	a0,a0,-1312 # 86b0 <malloc+0x4cc>
     bd8:	00007097          	auipc	ra,0x7
     bdc:	418080e7          	jalr	1048(ra) # 7ff0 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     be0:	fe442783          	lw	a5,-28(s0)
     be4:	863e                	mv	a2,a5
     be6:	fb843583          	ld	a1,-72(s0)
     bea:	00008517          	auipc	a0,0x8
     bee:	ad650513          	addi	a0,a0,-1322 # 86c0 <malloc+0x4dc>
     bf2:	00007097          	auipc	ra,0x7
     bf6:	3fe080e7          	jalr	1022(ra) # 7ff0 <printf>
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
     c34:	ab050513          	addi	a0,a0,-1360 # 86e0 <malloc+0x4fc>
     c38:	00007097          	auipc	ra,0x7
     c3c:	3b8080e7          	jalr	952(ra) # 7ff0 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     c40:	fe442783          	lw	a5,-28(s0)
     c44:	863e                	mv	a2,a5
     c46:	fb843583          	ld	a1,-72(s0)
     c4a:	00008517          	auipc	a0,0x8
     c4e:	a7650513          	addi	a0,a0,-1418 # 86c0 <malloc+0x4dc>
     c52:	00007097          	auipc	ra,0x7
     c56:	39e080e7          	jalr	926(ra) # 7ff0 <printf>
    exit(1);
     c5a:	4505                	li	a0,1
     c5c:	00007097          	auipc	ra,0x7
     c60:	e70080e7          	jalr	-400(ra) # 7acc <exit>
  }
  
  write(fd1, "abcdef", 6);
     c64:	fec42783          	lw	a5,-20(s0)
     c68:	4619                	li	a2,6
     c6a:	00008597          	auipc	a1,0x8
     c6e:	a8658593          	addi	a1,a1,-1402 # 86f0 <malloc+0x50c>
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
     cb6:	a4650513          	addi	a0,a0,-1466 # 86f8 <malloc+0x514>
     cba:	00007097          	auipc	ra,0x7
     cbe:	336080e7          	jalr	822(ra) # 7ff0 <printf>
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
     d06:	a1650513          	addi	a0,a0,-1514 # 8718 <malloc+0x534>
     d0a:	00007097          	auipc	ra,0x7
     d0e:	2e6080e7          	jalr	742(ra) # 7ff0 <printf>
    exit(1);
     d12:	4505                	li	a0,1
     d14:	00007097          	auipc	ra,0x7
     d18:	db8080e7          	jalr	-584(ra) # 7acc <exit>
  }

  unlink("truncfile");
     d1c:	00008517          	auipc	a0,0x8
     d20:	95c50513          	addi	a0,a0,-1700 # 8678 <malloc+0x494>
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
     d70:	90c50513          	addi	a0,a0,-1780 # 8678 <malloc+0x494>
     d74:	00007097          	auipc	ra,0x7
     d78:	da8080e7          	jalr	-600(ra) # 7b1c <unlink>

  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     d7c:	60100593          	li	a1,1537
     d80:	00008517          	auipc	a0,0x8
     d84:	8f850513          	addi	a0,a0,-1800 # 8678 <malloc+0x494>
     d88:	00007097          	auipc	ra,0x7
     d8c:	d84080e7          	jalr	-636(ra) # 7b0c <open>
     d90:	87aa                	mv	a5,a0
     d92:	fef42623          	sw	a5,-20(s0)
  write(fd1, "abcd", 4);
     d96:	fec42783          	lw	a5,-20(s0)
     d9a:	4611                	li	a2,4
     d9c:	00008597          	auipc	a1,0x8
     da0:	8ec58593          	addi	a1,a1,-1812 # 8688 <malloc+0x4a4>
     da4:	853e                	mv	a0,a5
     da6:	00007097          	auipc	ra,0x7
     daa:	d46080e7          	jalr	-698(ra) # 7aec <write>

  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     dae:	40100593          	li	a1,1025
     db2:	00008517          	auipc	a0,0x8
     db6:	8c650513          	addi	a0,a0,-1850 # 8678 <malloc+0x494>
     dba:	00007097          	auipc	ra,0x7
     dbe:	d52080e7          	jalr	-686(ra) # 7b0c <open>
     dc2:	87aa                	mv	a5,a0
     dc4:	fef42423          	sw	a5,-24(s0)

  int n = write(fd1, "x", 1);
     dc8:	fec42783          	lw	a5,-20(s0)
     dcc:	4605                	li	a2,1
     dce:	00007597          	auipc	a1,0x7
     dd2:	66258593          	addi	a1,a1,1634 # 8430 <malloc+0x24c>
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
     e02:	93a50513          	addi	a0,a0,-1734 # 8738 <malloc+0x554>
     e06:	00007097          	auipc	ra,0x7
     e0a:	1ea080e7          	jalr	490(ra) # 7ff0 <printf>
    exit(1);
     e0e:	4505                	li	a0,1
     e10:	00007097          	auipc	ra,0x7
     e14:	cbc080e7          	jalr	-836(ra) # 7acc <exit>
  }

  unlink("truncfile");
     e18:	00008517          	auipc	a0,0x8
     e1c:	86050513          	addi	a0,a0,-1952 # 8678 <malloc+0x494>
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
     e62:	81a50513          	addi	a0,a0,-2022 # 8678 <malloc+0x494>
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
     e9a:	8ca50513          	addi	a0,a0,-1846 # 8760 <malloc+0x57c>
     e9e:	00007097          	auipc	ra,0x7
     ea2:	152080e7          	jalr	338(ra) # 7ff0 <printf>
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
     ec6:	7b650513          	addi	a0,a0,1974 # 8678 <malloc+0x494>
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
     eea:	89250513          	addi	a0,a0,-1902 # 8778 <malloc+0x594>
     eee:	00007097          	auipc	ra,0x7
     ef2:	102080e7          	jalr	258(ra) # 7ff0 <printf>
        exit(1);
     ef6:	4505                	li	a0,1
     ef8:	00007097          	auipc	ra,0x7
     efc:	bd4080e7          	jalr	-1068(ra) # 7acc <exit>
      }
      int n = write(fd, "1234567890", 10);
     f00:	fd842783          	lw	a5,-40(s0)
     f04:	4629                	li	a2,10
     f06:	00008597          	auipc	a1,0x8
     f0a:	88a58593          	addi	a1,a1,-1910 # 8790 <malloc+0x5ac>
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
     f3a:	86a50513          	addi	a0,a0,-1942 # 87a0 <malloc+0x5bc>
     f3e:	00007097          	auipc	ra,0x7
     f42:	0b2080e7          	jalr	178(ra) # 7ff0 <printf>
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
     f64:	71850513          	addi	a0,a0,1816 # 8678 <malloc+0x494>
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
     fce:	6ae50513          	addi	a0,a0,1710 # 8678 <malloc+0x494>
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
     ff2:	78a50513          	addi	a0,a0,1930 # 8778 <malloc+0x594>
     ff6:	00007097          	auipc	ra,0x7
     ffa:	ffa080e7          	jalr	-6(ra) # 7ff0 <printf>
      exit(1);
     ffe:	4505                	li	a0,1
    1000:	00007097          	auipc	ra,0x7
    1004:	acc080e7          	jalr	-1332(ra) # 7acc <exit>
    }
    int n = write(fd, "xxx", 3);
    1008:	fe042783          	lw	a5,-32(s0)
    100c:	460d                	li	a2,3
    100e:	00007597          	auipc	a1,0x7
    1012:	7b258593          	addi	a1,a1,1970 # 87c0 <malloc+0x5dc>
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
    1042:	78a50513          	addi	a0,a0,1930 # 87c8 <malloc+0x5e4>
    1046:	00007097          	auipc	ra,0x7
    104a:	faa080e7          	jalr	-86(ra) # 7ff0 <printf>
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
    1092:	5ea50513          	addi	a0,a0,1514 # 8678 <malloc+0x494>
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
    10bc:	73050513          	addi	a0,a0,1840 # 87e8 <malloc+0x604>
    10c0:	00007097          	auipc	ra,0x7
    10c4:	a74080e7          	jalr	-1420(ra) # 7b34 <mkdir>
    10c8:	87aa                	mv	a5,a0
    10ca:	0207d163          	bgez	a5,10ec <iputtest+0x40>
    printf("%s: mkdir failed\n", s);
    10ce:	fe843583          	ld	a1,-24(s0)
    10d2:	00007517          	auipc	a0,0x7
    10d6:	71e50513          	addi	a0,a0,1822 # 87f0 <malloc+0x60c>
    10da:	00007097          	auipc	ra,0x7
    10de:	f16080e7          	jalr	-234(ra) # 7ff0 <printf>
    exit(1);
    10e2:	4505                	li	a0,1
    10e4:	00007097          	auipc	ra,0x7
    10e8:	9e8080e7          	jalr	-1560(ra) # 7acc <exit>
  }
  if(chdir("iputdir") < 0){
    10ec:	00007517          	auipc	a0,0x7
    10f0:	6fc50513          	addi	a0,a0,1788 # 87e8 <malloc+0x604>
    10f4:	00007097          	auipc	ra,0x7
    10f8:	a48080e7          	jalr	-1464(ra) # 7b3c <chdir>
    10fc:	87aa                	mv	a5,a0
    10fe:	0207d163          	bgez	a5,1120 <iputtest+0x74>
    printf("%s: chdir iputdir failed\n", s);
    1102:	fe843583          	ld	a1,-24(s0)
    1106:	00007517          	auipc	a0,0x7
    110a:	70250513          	addi	a0,a0,1794 # 8808 <malloc+0x624>
    110e:	00007097          	auipc	ra,0x7
    1112:	ee2080e7          	jalr	-286(ra) # 7ff0 <printf>
    exit(1);
    1116:	4505                	li	a0,1
    1118:	00007097          	auipc	ra,0x7
    111c:	9b4080e7          	jalr	-1612(ra) # 7acc <exit>
  }
  if(unlink("../iputdir") < 0){
    1120:	00007517          	auipc	a0,0x7
    1124:	70850513          	addi	a0,a0,1800 # 8828 <malloc+0x644>
    1128:	00007097          	auipc	ra,0x7
    112c:	9f4080e7          	jalr	-1548(ra) # 7b1c <unlink>
    1130:	87aa                	mv	a5,a0
    1132:	0207d163          	bgez	a5,1154 <iputtest+0xa8>
    printf("%s: unlink ../iputdir failed\n", s);
    1136:	fe843583          	ld	a1,-24(s0)
    113a:	00007517          	auipc	a0,0x7
    113e:	6fe50513          	addi	a0,a0,1790 # 8838 <malloc+0x654>
    1142:	00007097          	auipc	ra,0x7
    1146:	eae080e7          	jalr	-338(ra) # 7ff0 <printf>
    exit(1);
    114a:	4505                	li	a0,1
    114c:	00007097          	auipc	ra,0x7
    1150:	980080e7          	jalr	-1664(ra) # 7acc <exit>
  }
  if(chdir("/") < 0){
    1154:	00007517          	auipc	a0,0x7
    1158:	70450513          	addi	a0,a0,1796 # 8858 <malloc+0x674>
    115c:	00007097          	auipc	ra,0x7
    1160:	9e0080e7          	jalr	-1568(ra) # 7b3c <chdir>
    1164:	87aa                	mv	a5,a0
    1166:	0207d163          	bgez	a5,1188 <iputtest+0xdc>
    printf("%s: chdir / failed\n", s);
    116a:	fe843583          	ld	a1,-24(s0)
    116e:	00007517          	auipc	a0,0x7
    1172:	6f250513          	addi	a0,a0,1778 # 8860 <malloc+0x67c>
    1176:	00007097          	auipc	ra,0x7
    117a:	e7a080e7          	jalr	-390(ra) # 7ff0 <printf>
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
    11be:	5a650513          	addi	a0,a0,1446 # 8760 <malloc+0x57c>
    11c2:	00007097          	auipc	ra,0x7
    11c6:	e2e080e7          	jalr	-466(ra) # 7ff0 <printf>
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
    11e0:	60c50513          	addi	a0,a0,1548 # 87e8 <malloc+0x604>
    11e4:	00007097          	auipc	ra,0x7
    11e8:	950080e7          	jalr	-1712(ra) # 7b34 <mkdir>
    11ec:	87aa                	mv	a5,a0
    11ee:	0207d163          	bgez	a5,1210 <exitiputtest+0x7e>
      printf("%s: mkdir failed\n", s);
    11f2:	fd843583          	ld	a1,-40(s0)
    11f6:	00007517          	auipc	a0,0x7
    11fa:	5fa50513          	addi	a0,a0,1530 # 87f0 <malloc+0x60c>
    11fe:	00007097          	auipc	ra,0x7
    1202:	df2080e7          	jalr	-526(ra) # 7ff0 <printf>
      exit(1);
    1206:	4505                	li	a0,1
    1208:	00007097          	auipc	ra,0x7
    120c:	8c4080e7          	jalr	-1852(ra) # 7acc <exit>
    }
    if(chdir("iputdir") < 0){
    1210:	00007517          	auipc	a0,0x7
    1214:	5d850513          	addi	a0,a0,1496 # 87e8 <malloc+0x604>
    1218:	00007097          	auipc	ra,0x7
    121c:	924080e7          	jalr	-1756(ra) # 7b3c <chdir>
    1220:	87aa                	mv	a5,a0
    1222:	0207d163          	bgez	a5,1244 <exitiputtest+0xb2>
      printf("%s: child chdir failed\n", s);
    1226:	fd843583          	ld	a1,-40(s0)
    122a:	00007517          	auipc	a0,0x7
    122e:	64e50513          	addi	a0,a0,1614 # 8878 <malloc+0x694>
    1232:	00007097          	auipc	ra,0x7
    1236:	dbe080e7          	jalr	-578(ra) # 7ff0 <printf>
      exit(1);
    123a:	4505                	li	a0,1
    123c:	00007097          	auipc	ra,0x7
    1240:	890080e7          	jalr	-1904(ra) # 7acc <exit>
    }
    if(unlink("../iputdir") < 0){
    1244:	00007517          	auipc	a0,0x7
    1248:	5e450513          	addi	a0,a0,1508 # 8828 <malloc+0x644>
    124c:	00007097          	auipc	ra,0x7
    1250:	8d0080e7          	jalr	-1840(ra) # 7b1c <unlink>
    1254:	87aa                	mv	a5,a0
    1256:	0207d163          	bgez	a5,1278 <exitiputtest+0xe6>
      printf("%s: unlink ../iputdir failed\n", s);
    125a:	fd843583          	ld	a1,-40(s0)
    125e:	00007517          	auipc	a0,0x7
    1262:	5da50513          	addi	a0,a0,1498 # 8838 <malloc+0x654>
    1266:	00007097          	auipc	ra,0x7
    126a:	d8a080e7          	jalr	-630(ra) # 7ff0 <printf>
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
    12ae:	5e650513          	addi	a0,a0,1510 # 8890 <malloc+0x6ac>
    12b2:	00007097          	auipc	ra,0x7
    12b6:	882080e7          	jalr	-1918(ra) # 7b34 <mkdir>
    12ba:	87aa                	mv	a5,a0
    12bc:	0207d163          	bgez	a5,12de <openiputtest+0x40>
    printf("%s: mkdir oidir failed\n", s);
    12c0:	fd843583          	ld	a1,-40(s0)
    12c4:	00007517          	auipc	a0,0x7
    12c8:	5d450513          	addi	a0,a0,1492 # 8898 <malloc+0x6b4>
    12cc:	00007097          	auipc	ra,0x7
    12d0:	d24080e7          	jalr	-732(ra) # 7ff0 <printf>
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
    12fe:	46650513          	addi	a0,a0,1126 # 8760 <malloc+0x57c>
    1302:	00007097          	auipc	ra,0x7
    1306:	cee080e7          	jalr	-786(ra) # 7ff0 <printf>
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
    1322:	57250513          	addi	a0,a0,1394 # 8890 <malloc+0x6ac>
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
    1346:	56e50513          	addi	a0,a0,1390 # 88b0 <malloc+0x6cc>
    134a:	00007097          	auipc	ra,0x7
    134e:	ca6080e7          	jalr	-858(ra) # 7ff0 <printf>
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
    1374:	52050513          	addi	a0,a0,1312 # 8890 <malloc+0x6ac>
    1378:	00006097          	auipc	ra,0x6
    137c:	7a4080e7          	jalr	1956(ra) # 7b1c <unlink>
    1380:	87aa                	mv	a5,a0
    1382:	c385                	beqz	a5,13a2 <openiputtest+0x104>
    printf("%s: unlink failed\n", s);
    1384:	fd843583          	ld	a1,-40(s0)
    1388:	00007517          	auipc	a0,0x7
    138c:	55050513          	addi	a0,a0,1360 # 88d8 <malloc+0x6f4>
    1390:	00007097          	auipc	ra,0x7
    1394:	c60080e7          	jalr	-928(ra) # 7ff0 <printf>
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
    13d0:	17450513          	addi	a0,a0,372 # 8540 <malloc+0x35c>
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
    13f4:	50050513          	addi	a0,a0,1280 # 88f0 <malloc+0x70c>
    13f8:	00007097          	auipc	ra,0x7
    13fc:	bf8080e7          	jalr	-1032(ra) # 7ff0 <printf>
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
    141e:	4ee50513          	addi	a0,a0,1262 # 8908 <malloc+0x724>
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
    1442:	4da50513          	addi	a0,a0,1242 # 8918 <malloc+0x734>
    1446:	00007097          	auipc	ra,0x7
    144a:	baa080e7          	jalr	-1110(ra) # 7ff0 <printf>
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
    1476:	4ce50513          	addi	a0,a0,1230 # 8940 <malloc+0x75c>
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
    149a:	4b250513          	addi	a0,a0,1202 # 8948 <malloc+0x764>
    149e:	00007097          	auipc	ra,0x7
    14a2:	b52080e7          	jalr	-1198(ra) # 7ff0 <printf>
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
    14c0:	4ac58593          	addi	a1,a1,1196 # 8968 <malloc+0x784>
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
    14e6:	49650513          	addi	a0,a0,1174 # 8978 <malloc+0x794>
    14ea:	00007097          	auipc	ra,0x7
    14ee:	b06080e7          	jalr	-1274(ra) # 7ff0 <printf>
      exit(1);
    14f2:	4505                	li	a0,1
    14f4:	00006097          	auipc	ra,0x6
    14f8:	5d8080e7          	jalr	1496(ra) # 7acc <exit>
    }
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
    14fc:	fe842783          	lw	a5,-24(s0)
    1500:	4629                	li	a2,10
    1502:	00007597          	auipc	a1,0x7
    1506:	49e58593          	addi	a1,a1,1182 # 89a0 <malloc+0x7bc>
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
    152c:	48850513          	addi	a0,a0,1160 # 89b0 <malloc+0x7cc>
    1530:	00007097          	auipc	ra,0x7
    1534:	ac0080e7          	jalr	-1344(ra) # 7ff0 <printf>
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
    1570:	3d450513          	addi	a0,a0,980 # 8940 <malloc+0x75c>
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
    1594:	44850513          	addi	a0,a0,1096 # 89d8 <malloc+0x7f4>
    1598:	00007097          	auipc	ra,0x7
    159c:	a58080e7          	jalr	-1448(ra) # 7ff0 <printf>
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
    15e2:	41a50513          	addi	a0,a0,1050 # 89f8 <malloc+0x814>
    15e6:	00007097          	auipc	ra,0x7
    15ea:	a0a080e7          	jalr	-1526(ra) # 7ff0 <printf>
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
    160a:	33a50513          	addi	a0,a0,826 # 8940 <malloc+0x75c>
    160e:	00006097          	auipc	ra,0x6
    1612:	50e080e7          	jalr	1294(ra) # 7b1c <unlink>
    1616:	87aa                	mv	a5,a0
    1618:	0207d163          	bgez	a5,163a <writetest+0x1d8>
    printf("%s: unlink small failed\n", s);
    161c:	fd843583          	ld	a1,-40(s0)
    1620:	00007517          	auipc	a0,0x7
    1624:	3f050513          	addi	a0,a0,1008 # 8a10 <malloc+0x82c>
    1628:	00007097          	auipc	ra,0x7
    162c:	9c8080e7          	jalr	-1592(ra) # 7ff0 <printf>
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
    1658:	3dc50513          	addi	a0,a0,988 # 8a30 <malloc+0x84c>
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
    167c:	3c050513          	addi	a0,a0,960 # 8a38 <malloc+0x854>
    1680:	00007097          	auipc	ra,0x7
    1684:	970080e7          	jalr	-1680(ra) # 7ff0 <printf>
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
    16da:	38250513          	addi	a0,a0,898 # 8a58 <malloc+0x874>
    16de:	00007097          	auipc	ra,0x7
    16e2:	912080e7          	jalr	-1774(ra) # 7ff0 <printf>
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
    171a:	31a50513          	addi	a0,a0,794 # 8a30 <malloc+0x84c>
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
    173e:	34650513          	addi	a0,a0,838 # 8a80 <malloc+0x89c>
    1742:	00007097          	auipc	ra,0x7
    1746:	8ae080e7          	jalr	-1874(ra) # 7ff0 <printf>
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
    179e:	30650513          	addi	a0,a0,774 # 8aa0 <malloc+0x8bc>
    17a2:	00007097          	auipc	ra,0x7
    17a6:	84e080e7          	jalr	-1970(ra) # 7ff0 <printf>
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
    17d2:	2fa50513          	addi	a0,a0,762 # 8ac8 <malloc+0x8e4>
    17d6:	00007097          	auipc	ra,0x7
    17da:	81a080e7          	jalr	-2022(ra) # 7ff0 <printf>
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
    1816:	2ce50513          	addi	a0,a0,718 # 8ae0 <malloc+0x8fc>
    181a:	00006097          	auipc	ra,0x6
    181e:	7d6080e7          	jalr	2006(ra) # 7ff0 <printf>
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
    184c:	1e850513          	addi	a0,a0,488 # 8a30 <malloc+0x84c>
    1850:	00006097          	auipc	ra,0x6
    1854:	2cc080e7          	jalr	716(ra) # 7b1c <unlink>
    1858:	87aa                	mv	a5,a0
    185a:	0207d163          	bgez	a5,187c <writebig+0x238>
    printf("%s: unlink big failed\n", s);
    185e:	fd843583          	ld	a1,-40(s0)
    1862:	00007517          	auipc	a0,0x7
    1866:	2a650513          	addi	a0,a0,678 # 8b08 <malloc+0x924>
    186a:	00006097          	auipc	ra,0x6
    186e:	786080e7          	jalr	1926(ra) # 7ff0 <printf>
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
    1962:	1c250513          	addi	a0,a0,450 # 8b20 <malloc+0x93c>
    1966:	00006097          	auipc	ra,0x6
    196a:	1ce080e7          	jalr	462(ra) # 7b34 <mkdir>
    196e:	87aa                	mv	a5,a0
    1970:	0207d163          	bgez	a5,1992 <dirtest+0x40>
    printf("%s: mkdir failed\n", s);
    1974:	fe843583          	ld	a1,-24(s0)
    1978:	00007517          	auipc	a0,0x7
    197c:	e7850513          	addi	a0,a0,-392 # 87f0 <malloc+0x60c>
    1980:	00006097          	auipc	ra,0x6
    1984:	670080e7          	jalr	1648(ra) # 7ff0 <printf>
    exit(1);
    1988:	4505                	li	a0,1
    198a:	00006097          	auipc	ra,0x6
    198e:	142080e7          	jalr	322(ra) # 7acc <exit>
  }

  if(chdir("dir0") < 0){
    1992:	00007517          	auipc	a0,0x7
    1996:	18e50513          	addi	a0,a0,398 # 8b20 <malloc+0x93c>
    199a:	00006097          	auipc	ra,0x6
    199e:	1a2080e7          	jalr	418(ra) # 7b3c <chdir>
    19a2:	87aa                	mv	a5,a0
    19a4:	0207d163          	bgez	a5,19c6 <dirtest+0x74>
    printf("%s: chdir dir0 failed\n", s);
    19a8:	fe843583          	ld	a1,-24(s0)
    19ac:	00007517          	auipc	a0,0x7
    19b0:	17c50513          	addi	a0,a0,380 # 8b28 <malloc+0x944>
    19b4:	00006097          	auipc	ra,0x6
    19b8:	63c080e7          	jalr	1596(ra) # 7ff0 <printf>
    exit(1);
    19bc:	4505                	li	a0,1
    19be:	00006097          	auipc	ra,0x6
    19c2:	10e080e7          	jalr	270(ra) # 7acc <exit>
  }

  if(chdir("..") < 0){
    19c6:	00007517          	auipc	a0,0x7
    19ca:	17a50513          	addi	a0,a0,378 # 8b40 <malloc+0x95c>
    19ce:	00006097          	auipc	ra,0x6
    19d2:	16e080e7          	jalr	366(ra) # 7b3c <chdir>
    19d6:	87aa                	mv	a5,a0
    19d8:	0207d163          	bgez	a5,19fa <dirtest+0xa8>
    printf("%s: chdir .. failed\n", s);
    19dc:	fe843583          	ld	a1,-24(s0)
    19e0:	00007517          	auipc	a0,0x7
    19e4:	16850513          	addi	a0,a0,360 # 8b48 <malloc+0x964>
    19e8:	00006097          	auipc	ra,0x6
    19ec:	608080e7          	jalr	1544(ra) # 7ff0 <printf>
    exit(1);
    19f0:	4505                	li	a0,1
    19f2:	00006097          	auipc	ra,0x6
    19f6:	0da080e7          	jalr	218(ra) # 7acc <exit>
  }

  if(unlink("dir0") < 0){
    19fa:	00007517          	auipc	a0,0x7
    19fe:	12650513          	addi	a0,a0,294 # 8b20 <malloc+0x93c>
    1a02:	00006097          	auipc	ra,0x6
    1a06:	11a080e7          	jalr	282(ra) # 7b1c <unlink>
    1a0a:	87aa                	mv	a5,a0
    1a0c:	0207d163          	bgez	a5,1a2e <dirtest+0xdc>
    printf("%s: unlink dir0 failed\n", s);
    1a10:	fe843583          	ld	a1,-24(s0)
    1a14:	00007517          	auipc	a0,0x7
    1a18:	14c50513          	addi	a0,a0,332 # 8b60 <malloc+0x97c>
    1a1c:	00006097          	auipc	ra,0x6
    1a20:	5d4080e7          	jalr	1492(ra) # 7ff0 <printf>
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
    1a48:	afc78793          	addi	a5,a5,-1284 # 8540 <malloc+0x35c>
    1a4c:	fcf43423          	sd	a5,-56(s0)
    1a50:	00007797          	auipc	a5,0x7
    1a54:	12878793          	addi	a5,a5,296 # 8b78 <malloc+0x994>
    1a58:	fcf43823          	sd	a5,-48(s0)
    1a5c:	fc043c23          	sd	zero,-40(s0)
  char buf[3];

  unlink("echo-ok");
    1a60:	00007517          	auipc	a0,0x7
    1a64:	12050513          	addi	a0,a0,288 # 8b80 <malloc+0x99c>
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
    1a90:	cd450513          	addi	a0,a0,-812 # 8760 <malloc+0x57c>
    1a94:	00006097          	auipc	ra,0x6
    1a98:	55c080e7          	jalr	1372(ra) # 7ff0 <printf>
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
    1ac0:	0c450513          	addi	a0,a0,196 # 8b80 <malloc+0x99c>
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
    1ae4:	0a850513          	addi	a0,a0,168 # 8b88 <malloc+0x9a4>
    1ae8:	00006097          	auipc	ra,0x6
    1aec:	508080e7          	jalr	1288(ra) # 7ff0 <printf>
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
    1b10:	09450513          	addi	a0,a0,148 # 8ba0 <malloc+0x9bc>
    1b14:	00006097          	auipc	ra,0x6
    1b18:	4dc080e7          	jalr	1244(ra) # 7ff0 <printf>
      exit(1);
    1b1c:	4505                	li	a0,1
    1b1e:	00006097          	auipc	ra,0x6
    1b22:	fae080e7          	jalr	-82(ra) # 7acc <exit>
    }
    if(exec("echo", echoargv) < 0){
    1b26:	fc840793          	addi	a5,s0,-56
    1b2a:	85be                	mv	a1,a5
    1b2c:	00007517          	auipc	a0,0x7
    1b30:	a1450513          	addi	a0,a0,-1516 # 8540 <malloc+0x35c>
    1b34:	00006097          	auipc	ra,0x6
    1b38:	fd0080e7          	jalr	-48(ra) # 7b04 <exec>
    1b3c:	87aa                	mv	a5,a0
    1b3e:	0207d163          	bgez	a5,1b60 <exectest+0x128>
      printf("%s: exec echo failed\n", s);
    1b42:	fb843583          	ld	a1,-72(s0)
    1b46:	00007517          	auipc	a0,0x7
    1b4a:	06a50513          	addi	a0,a0,106 # 8bb0 <malloc+0x9cc>
    1b4e:	00006097          	auipc	ra,0x6
    1b52:	4a2080e7          	jalr	1186(ra) # 7ff0 <printf>
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
    1b84:	04850513          	addi	a0,a0,72 # 8bc8 <malloc+0x9e4>
    1b88:	00006097          	auipc	ra,0x6
    1b8c:	468080e7          	jalr	1128(ra) # 7ff0 <printf>
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
    1baa:	fda50513          	addi	a0,a0,-38 # 8b80 <malloc+0x99c>
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
    1bce:	bae50513          	addi	a0,a0,-1106 # 8778 <malloc+0x594>
    1bd2:	00006097          	auipc	ra,0x6
    1bd6:	41e080e7          	jalr	1054(ra) # 7ff0 <printf>
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
    1c0c:	df050513          	addi	a0,a0,-528 # 89f8 <malloc+0x814>
    1c10:	00006097          	auipc	ra,0x6
    1c14:	3e0080e7          	jalr	992(ra) # 7ff0 <printf>
    exit(1);
    1c18:	4505                	li	a0,1
    1c1a:	00006097          	auipc	ra,0x6
    1c1e:	eb2080e7          	jalr	-334(ra) # 7acc <exit>
  }
  unlink("echo-ok");
    1c22:	00007517          	auipc	a0,0x7
    1c26:	f5e50513          	addi	a0,a0,-162 # 8b80 <malloc+0x99c>
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
    1c60:	f8450513          	addi	a0,a0,-124 # 8be0 <malloc+0x9fc>
    1c64:	00006097          	auipc	ra,0x6
    1c68:	38c080e7          	jalr	908(ra) # 7ff0 <printf>
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
    1c9c:	f6050513          	addi	a0,a0,-160 # 8bf8 <malloc+0xa14>
    1ca0:	00006097          	auipc	ra,0x6
    1ca4:	350080e7          	jalr	848(ra) # 7ff0 <printf>
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
    1d50:	ec450513          	addi	a0,a0,-316 # 8c10 <malloc+0xa2c>
    1d54:	00006097          	auipc	ra,0x6
    1d58:	29c080e7          	jalr	668(ra) # 7ff0 <printf>
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
    1de6:	e4650513          	addi	a0,a0,-442 # 8c28 <malloc+0xa44>
    1dea:	00006097          	auipc	ra,0x6
    1dee:	206080e7          	jalr	518(ra) # 7ff0 <printf>
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
    1e84:	dc050513          	addi	a0,a0,-576 # 8c40 <malloc+0xa5c>
    1e88:	00006097          	auipc	ra,0x6
    1e8c:	168080e7          	jalr	360(ra) # 7ff0 <printf>
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
    1ecc:	d9850513          	addi	a0,a0,-616 # 8c60 <malloc+0xa7c>
    1ed0:	00006097          	auipc	ra,0x6
    1ed4:	120080e7          	jalr	288(ra) # 7ff0 <printf>
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
    1f1c:	84850513          	addi	a0,a0,-1976 # 8760 <malloc+0x57c>
    1f20:	00006097          	auipc	ra,0x6
    1f24:	0d0080e7          	jalr	208(ra) # 7ff0 <printf>
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
    1f7c:	d0050513          	addi	a0,a0,-768 # 8c78 <malloc+0xa94>
    1f80:	00006097          	auipc	ra,0x6
    1f84:	070080e7          	jalr	112(ra) # 7ff0 <printf>
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
    1fe2:	cba50513          	addi	a0,a0,-838 # 8c98 <malloc+0xab4>
    1fe6:	00006097          	auipc	ra,0x6
    1fea:	00a080e7          	jalr	10(ra) # 7ff0 <printf>
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
    2024:	74050513          	addi	a0,a0,1856 # 8760 <malloc+0x57c>
    2028:	00006097          	auipc	ra,0x6
    202c:	fc8080e7          	jalr	-56(ra) # 7ff0 <printf>
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
    2074:	6f050513          	addi	a0,a0,1776 # 8760 <malloc+0x57c>
    2078:	00006097          	auipc	ra,0x6
    207c:	f78080e7          	jalr	-136(ra) # 7ff0 <printf>
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
    20aa:	38a58593          	addi	a1,a1,906 # 8430 <malloc+0x24c>
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
    20ca:	be250513          	addi	a0,a0,-1054 # 8ca8 <malloc+0xac4>
    20ce:	00006097          	auipc	ra,0x6
    20d2:	f22080e7          	jalr	-222(ra) # 7ff0 <printf>
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
    2120:	ba450513          	addi	a0,a0,-1116 # 8cc0 <malloc+0xadc>
    2124:	00006097          	auipc	ra,0x6
    2128:	ecc080e7          	jalr	-308(ra) # 7ff0 <printf>
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
    2140:	b9c50513          	addi	a0,a0,-1124 # 8cd8 <malloc+0xaf4>
    2144:	00006097          	auipc	ra,0x6
    2148:	eac080e7          	jalr	-340(ra) # 7ff0 <printf>
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
    217a:	b7250513          	addi	a0,a0,-1166 # 8ce8 <malloc+0xb04>
    217e:	00006097          	auipc	ra,0x6
    2182:	e72080e7          	jalr	-398(ra) # 7ff0 <printf>
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
    21de:	58650513          	addi	a0,a0,1414 # 8760 <malloc+0x57c>
    21e2:	00006097          	auipc	ra,0x6
    21e6:	e0e080e7          	jalr	-498(ra) # 7ff0 <printf>
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
    2220:	adc50513          	addi	a0,a0,-1316 # 8cf8 <malloc+0xb14>
    2224:	00006097          	auipc	ra,0x6
    2228:	dcc080e7          	jalr	-564(ra) # 7ff0 <printf>
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
    224c:	ac850513          	addi	a0,a0,-1336 # 8d10 <malloc+0xb2c>
    2250:	00006097          	auipc	ra,0x6
    2254:	da0080e7          	jalr	-608(ra) # 7ff0 <printf>
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
    22d6:	48e50513          	addi	a0,a0,1166 # 8760 <malloc+0x57c>
    22da:	00006097          	auipc	ra,0x6
    22de:	d16080e7          	jalr	-746(ra) # 7ff0 <printf>
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
    2314:	9e850513          	addi	a0,a0,-1560 # 8cf8 <malloc+0xb14>
    2318:	00006097          	auipc	ra,0x6
    231c:	cd8080e7          	jalr	-808(ra) # 7ff0 <printf>
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
    23ba:	3aa50513          	addi	a0,a0,938 # 8760 <malloc+0x57c>
    23be:	00006097          	auipc	ra,0x6
    23c2:	c32080e7          	jalr	-974(ra) # 7ff0 <printf>
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
    2402:	36250513          	addi	a0,a0,866 # 8760 <malloc+0x57c>
    2406:	00006097          	auipc	ra,0x6
    240a:	bea080e7          	jalr	-1046(ra) # 7ff0 <printf>
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
    2496:	80650513          	addi	a0,a0,-2042 # 8c98 <malloc+0xab4>
    249a:	00006097          	auipc	ra,0x6
    249e:	b56080e7          	jalr	-1194(ra) # 7ff0 <printf>
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
    2556:	7de50513          	addi	a0,a0,2014 # 8d30 <malloc+0xb4c>
    255a:	00006097          	auipc	ra,0x6
    255e:	a96080e7          	jalr	-1386(ra) # 7ff0 <printf>
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
    25a0:	7b450513          	addi	a0,a0,1972 # 8d50 <malloc+0xb6c>
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
    25cc:	6d050513          	addi	a0,a0,1744 # 8c98 <malloc+0xab4>
    25d0:	00006097          	auipc	ra,0x6
    25d4:	a20080e7          	jalr	-1504(ra) # 7ff0 <printf>
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
    25f0:	76450513          	addi	a0,a0,1892 # 8d50 <malloc+0xb6c>
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
    262c:	72850513          	addi	a0,a0,1832 # 8d50 <malloc+0xb6c>
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
    2658:	6fc50513          	addi	a0,a0,1788 # 8d50 <malloc+0xb6c>
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
    26bc:	e7850513          	addi	a0,a0,-392 # 8530 <malloc+0x34c>
    26c0:	00006097          	auipc	ra,0x6
    26c4:	930080e7          	jalr	-1744(ra) # 7ff0 <printf>
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
    2766:	a82080e7          	jalr	-1406(ra) # 81e4 <malloc>
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
    2788:	8bc080e7          	jalr	-1860(ra) # 8040 <free>
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
    27a0:	a48080e7          	jalr	-1464(ra) # 81e4 <malloc>
    27a4:	fea43423          	sd	a0,-24(s0)
    if(m1 == 0){
    27a8:	fe843783          	ld	a5,-24(s0)
    27ac:	e385                	bnez	a5,27cc <mem+0xaa>
      printf("couldn't allocate mem?!!\n", s);
    27ae:	fc843583          	ld	a1,-56(s0)
    27b2:	00006517          	auipc	a0,0x6
    27b6:	5ae50513          	addi	a0,a0,1454 # 8d60 <malloc+0xb7c>
    27ba:	00006097          	auipc	ra,0x6
    27be:	836080e7          	jalr	-1994(ra) # 7ff0 <printf>
      exit(1);
    27c2:	4505                	li	a0,1
    27c4:	00005097          	auipc	ra,0x5
    27c8:	308080e7          	jalr	776(ra) # 7acc <exit>
    }
    free(m1);
    27cc:	fe843503          	ld	a0,-24(s0)
    27d0:	00006097          	auipc	ra,0x6
    27d4:	870080e7          	jalr	-1936(ra) # 8040 <free>
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
    2822:	56250513          	addi	a0,a0,1378 # 8d80 <malloc+0xb9c>
    2826:	00005097          	auipc	ra,0x5
    282a:	2f6080e7          	jalr	758(ra) # 7b1c <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    282e:	20200593          	li	a1,514
    2832:	00006517          	auipc	a0,0x6
    2836:	54e50513          	addi	a0,a0,1358 # 8d80 <malloc+0xb9c>
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
    285a:	53a50513          	addi	a0,a0,1338 # 8d90 <malloc+0xbac>
    285e:	00005097          	auipc	ra,0x5
    2862:	792080e7          	jalr	1938(ra) # 7ff0 <printf>
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
    28d0:	4ec50513          	addi	a0,a0,1260 # 8db8 <malloc+0xbd4>
    28d4:	00005097          	auipc	ra,0x5
    28d8:	71c080e7          	jalr	1820(ra) # 7ff0 <printf>
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
    2948:	43c50513          	addi	a0,a0,1084 # 8d80 <malloc+0xb9c>
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
    296c:	47050513          	addi	a0,a0,1136 # 8dd8 <malloc+0xbf4>
    2970:	00005097          	auipc	ra,0x5
    2974:	680080e7          	jalr	1664(ra) # 7ff0 <printf>
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
    2a22:	36250513          	addi	a0,a0,866 # 8d80 <malloc+0xb9c>
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
    2a64:	3a050513          	addi	a0,a0,928 # 8e00 <malloc+0xc1c>
    2a68:	00005097          	auipc	ra,0x5
    2a6c:	588080e7          	jalr	1416(ra) # 7ff0 <printf>
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
    2a8a:	40278793          	addi	a5,a5,1026 # 8e88 <malloc+0xca4>
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
    2aea:	a4a50513          	addi	a0,a0,-1462 # 8530 <malloc+0x34c>
    2aee:	00005097          	auipc	ra,0x5
    2af2:	502080e7          	jalr	1282(ra) # 7ff0 <printf>
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
    2b30:	2ec50513          	addi	a0,a0,748 # 8e18 <malloc+0xc34>
    2b34:	00005097          	auipc	ra,0x5
    2b38:	4bc080e7          	jalr	1212(ra) # 7ff0 <printf>
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
    2ba6:	28650513          	addi	a0,a0,646 # 8e28 <malloc+0xc44>
    2baa:	00005097          	auipc	ra,0x5
    2bae:	446080e7          	jalr	1094(ra) # 7ff0 <printf>
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
    2c9a:	1aa50513          	addi	a0,a0,426 # 8e40 <malloc+0xc5c>
    2c9e:	00005097          	auipc	ra,0x5
    2ca2:	352080e7          	jalr	850(ra) # 7ff0 <printf>
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
    2d2e:	12650513          	addi	a0,a0,294 # 8e50 <malloc+0xc6c>
    2d32:	00005097          	auipc	ra,0x5
    2d36:	2be080e7          	jalr	702(ra) # 7ff0 <printf>
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
    2da6:	78e50513          	addi	a0,a0,1934 # 8530 <malloc+0x34c>
    2daa:	00005097          	auipc	ra,0x5
    2dae:	246080e7          	jalr	582(ra) # 7ff0 <printf>
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
    2e22:	d6a50513          	addi	a0,a0,-662 # 8b88 <malloc+0x9a4>
    2e26:	00005097          	auipc	ra,0x5
    2e2a:	1ca080e7          	jalr	458(ra) # 7ff0 <printf>
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
    2e96:	a4650513          	addi	a0,a0,-1466 # 88d8 <malloc+0x6f4>
    2e9a:	00005097          	auipc	ra,0x5
    2e9e:	156080e7          	jalr	342(ra) # 7ff0 <printf>
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
    2fae:	efe50513          	addi	a0,a0,-258 # 8ea8 <malloc+0xcc4>
    2fb2:	00005097          	auipc	ra,0x5
    2fb6:	03e080e7          	jalr	62(ra) # 7ff0 <printf>
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
    2ff4:	ee050513          	addi	a0,a0,-288 # 8ed0 <malloc+0xcec>
    2ff8:	00005097          	auipc	ra,0x5
    2ffc:	ff8080e7          	jalr	-8(ra) # 7ff0 <printf>
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
    30e4:	e1850513          	addi	a0,a0,-488 # 8ef8 <malloc+0xd14>
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
    3108:	e0450513          	addi	a0,a0,-508 # 8f08 <malloc+0xd24>
    310c:	00005097          	auipc	ra,0x5
    3110:	ee4080e7          	jalr	-284(ra) # 7ff0 <printf>
    exit(1);
    3114:	4505                	li	a0,1
    3116:	00005097          	auipc	ra,0x5
    311a:	9b6080e7          	jalr	-1610(ra) # 7acc <exit>
  }
  write(fd, "hello", SZ);
    311e:	fec42783          	lw	a5,-20(s0)
    3122:	4615                	li	a2,5
    3124:	00006597          	auipc	a1,0x6
    3128:	e0458593          	addi	a1,a1,-508 # 8f28 <malloc+0xd44>
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
    314a:	db250513          	addi	a0,a0,-590 # 8ef8 <malloc+0xd14>
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
    316e:	dc650513          	addi	a0,a0,-570 # 8f30 <malloc+0xd4c>
    3172:	00005097          	auipc	ra,0x5
    3176:	e7e080e7          	jalr	-386(ra) # 7ff0 <printf>
    exit(1);
    317a:	4505                	li	a0,1
    317c:	00005097          	auipc	ra,0x5
    3180:	950080e7          	jalr	-1712(ra) # 7acc <exit>
  }
  if(unlink("unlinkread") != 0){
    3184:	00006517          	auipc	a0,0x6
    3188:	d7450513          	addi	a0,a0,-652 # 8ef8 <malloc+0xd14>
    318c:	00005097          	auipc	ra,0x5
    3190:	990080e7          	jalr	-1648(ra) # 7b1c <unlink>
    3194:	87aa                	mv	a5,a0
    3196:	c385                	beqz	a5,31b6 <unlinkread+0xe6>
    printf("%s: unlink unlinkread failed\n", s);
    3198:	fd843583          	ld	a1,-40(s0)
    319c:	00006517          	auipc	a0,0x6
    31a0:	db450513          	addi	a0,a0,-588 # 8f50 <malloc+0xd6c>
    31a4:	00005097          	auipc	ra,0x5
    31a8:	e4c080e7          	jalr	-436(ra) # 7ff0 <printf>
    exit(1);
    31ac:	4505                	li	a0,1
    31ae:	00005097          	auipc	ra,0x5
    31b2:	91e080e7          	jalr	-1762(ra) # 7acc <exit>
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    31b6:	20200593          	li	a1,514
    31ba:	00006517          	auipc	a0,0x6
    31be:	d3e50513          	addi	a0,a0,-706 # 8ef8 <malloc+0xd14>
    31c2:	00005097          	auipc	ra,0x5
    31c6:	94a080e7          	jalr	-1718(ra) # 7b0c <open>
    31ca:	87aa                	mv	a5,a0
    31cc:	fef42423          	sw	a5,-24(s0)
  write(fd1, "yyy", 3);
    31d0:	fe842783          	lw	a5,-24(s0)
    31d4:	460d                	li	a2,3
    31d6:	00006597          	auipc	a1,0x6
    31da:	d9a58593          	addi	a1,a1,-614 # 8f70 <malloc+0xd8c>
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
    3220:	d5c50513          	addi	a0,a0,-676 # 8f78 <malloc+0xd94>
    3224:	00005097          	auipc	ra,0x5
    3228:	dcc080e7          	jalr	-564(ra) # 7ff0 <printf>
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
    3254:	d4850513          	addi	a0,a0,-696 # 8f98 <malloc+0xdb4>
    3258:	00005097          	auipc	ra,0x5
    325c:	d98080e7          	jalr	-616(ra) # 7ff0 <printf>
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
    3294:	d2850513          	addi	a0,a0,-728 # 8fb8 <malloc+0xdd4>
    3298:	00005097          	auipc	ra,0x5
    329c:	d58080e7          	jalr	-680(ra) # 7ff0 <printf>
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
    32bc:	c4050513          	addi	a0,a0,-960 # 8ef8 <malloc+0xd14>
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
    32e2:	cfa50513          	addi	a0,a0,-774 # 8fd8 <malloc+0xdf4>
    32e6:	00005097          	auipc	ra,0x5
    32ea:	836080e7          	jalr	-1994(ra) # 7b1c <unlink>
  unlink("lf2");
    32ee:	00006517          	auipc	a0,0x6
    32f2:	cf250513          	addi	a0,a0,-782 # 8fe0 <malloc+0xdfc>
    32f6:	00005097          	auipc	ra,0x5
    32fa:	826080e7          	jalr	-2010(ra) # 7b1c <unlink>

  fd = open("lf1", O_CREATE|O_RDWR);
    32fe:	20200593          	li	a1,514
    3302:	00006517          	auipc	a0,0x6
    3306:	cd650513          	addi	a0,a0,-810 # 8fd8 <malloc+0xdf4>
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
    332a:	cc250513          	addi	a0,a0,-830 # 8fe8 <malloc+0xe04>
    332e:	00005097          	auipc	ra,0x5
    3332:	cc2080e7          	jalr	-830(ra) # 7ff0 <printf>
    exit(1);
    3336:	4505                	li	a0,1
    3338:	00004097          	auipc	ra,0x4
    333c:	794080e7          	jalr	1940(ra) # 7acc <exit>
  }
  if(write(fd, "hello", SZ) != SZ){
    3340:	fec42783          	lw	a5,-20(s0)
    3344:	4615                	li	a2,5
    3346:	00006597          	auipc	a1,0x6
    334a:	be258593          	addi	a1,a1,-1054 # 8f28 <malloc+0xd44>
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
    336a:	c9a50513          	addi	a0,a0,-870 # 9000 <malloc+0xe1c>
    336e:	00005097          	auipc	ra,0x5
    3372:	c82080e7          	jalr	-894(ra) # 7ff0 <printf>
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
    3392:	c5258593          	addi	a1,a1,-942 # 8fe0 <malloc+0xdfc>
    3396:	00006517          	auipc	a0,0x6
    339a:	c4250513          	addi	a0,a0,-958 # 8fd8 <malloc+0xdf4>
    339e:	00004097          	auipc	ra,0x4
    33a2:	78e080e7          	jalr	1934(ra) # 7b2c <link>
    33a6:	87aa                	mv	a5,a0
    33a8:	0207d163          	bgez	a5,33ca <linktest+0xf8>
    printf("%s: link lf1 lf2 failed\n", s);
    33ac:	fd843583          	ld	a1,-40(s0)
    33b0:	00006517          	auipc	a0,0x6
    33b4:	c6850513          	addi	a0,a0,-920 # 9018 <malloc+0xe34>
    33b8:	00005097          	auipc	ra,0x5
    33bc:	c38080e7          	jalr	-968(ra) # 7ff0 <printf>
    exit(1);
    33c0:	4505                	li	a0,1
    33c2:	00004097          	auipc	ra,0x4
    33c6:	70a080e7          	jalr	1802(ra) # 7acc <exit>
  }
  unlink("lf1");
    33ca:	00006517          	auipc	a0,0x6
    33ce:	c0e50513          	addi	a0,a0,-1010 # 8fd8 <malloc+0xdf4>
    33d2:	00004097          	auipc	ra,0x4
    33d6:	74a080e7          	jalr	1866(ra) # 7b1c <unlink>

  if(open("lf1", 0) >= 0){
    33da:	4581                	li	a1,0
    33dc:	00006517          	auipc	a0,0x6
    33e0:	bfc50513          	addi	a0,a0,-1028 # 8fd8 <malloc+0xdf4>
    33e4:	00004097          	auipc	ra,0x4
    33e8:	728080e7          	jalr	1832(ra) # 7b0c <open>
    33ec:	87aa                	mv	a5,a0
    33ee:	0207c163          	bltz	a5,3410 <linktest+0x13e>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    33f2:	fd843583          	ld	a1,-40(s0)
    33f6:	00006517          	auipc	a0,0x6
    33fa:	c4250513          	addi	a0,a0,-958 # 9038 <malloc+0xe54>
    33fe:	00005097          	auipc	ra,0x5
    3402:	bf2080e7          	jalr	-1038(ra) # 7ff0 <printf>
    exit(1);
    3406:	4505                	li	a0,1
    3408:	00004097          	auipc	ra,0x4
    340c:	6c4080e7          	jalr	1732(ra) # 7acc <exit>
  }

  fd = open("lf2", 0);
    3410:	4581                	li	a1,0
    3412:	00006517          	auipc	a0,0x6
    3416:	bce50513          	addi	a0,a0,-1074 # 8fe0 <malloc+0xdfc>
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
    343a:	c3250513          	addi	a0,a0,-974 # 9068 <malloc+0xe84>
    343e:	00005097          	auipc	ra,0x5
    3442:	bb2080e7          	jalr	-1102(ra) # 7ff0 <printf>
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
    347a:	c0a50513          	addi	a0,a0,-1014 # 9080 <malloc+0xe9c>
    347e:	00005097          	auipc	ra,0x5
    3482:	b72080e7          	jalr	-1166(ra) # 7ff0 <printf>
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
    34a2:	b4258593          	addi	a1,a1,-1214 # 8fe0 <malloc+0xdfc>
    34a6:	00006517          	auipc	a0,0x6
    34aa:	b3a50513          	addi	a0,a0,-1222 # 8fe0 <malloc+0xdfc>
    34ae:	00004097          	auipc	ra,0x4
    34b2:	67e080e7          	jalr	1662(ra) # 7b2c <link>
    34b6:	87aa                	mv	a5,a0
    34b8:	0207c163          	bltz	a5,34da <linktest+0x208>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    34bc:	fd843583          	ld	a1,-40(s0)
    34c0:	00006517          	auipc	a0,0x6
    34c4:	bd850513          	addi	a0,a0,-1064 # 9098 <malloc+0xeb4>
    34c8:	00005097          	auipc	ra,0x5
    34cc:	b28080e7          	jalr	-1240(ra) # 7ff0 <printf>
    exit(1);
    34d0:	4505                	li	a0,1
    34d2:	00004097          	auipc	ra,0x4
    34d6:	5fa080e7          	jalr	1530(ra) # 7acc <exit>
  }

  unlink("lf2");
    34da:	00006517          	auipc	a0,0x6
    34de:	b0650513          	addi	a0,a0,-1274 # 8fe0 <malloc+0xdfc>
    34e2:	00004097          	auipc	ra,0x4
    34e6:	63a080e7          	jalr	1594(ra) # 7b1c <unlink>
  if(link("lf2", "lf1") >= 0){
    34ea:	00006597          	auipc	a1,0x6
    34ee:	aee58593          	addi	a1,a1,-1298 # 8fd8 <malloc+0xdf4>
    34f2:	00006517          	auipc	a0,0x6
    34f6:	aee50513          	addi	a0,a0,-1298 # 8fe0 <malloc+0xdfc>
    34fa:	00004097          	auipc	ra,0x4
    34fe:	632080e7          	jalr	1586(ra) # 7b2c <link>
    3502:	87aa                	mv	a5,a0
    3504:	0207c163          	bltz	a5,3526 <linktest+0x254>
    printf("%s: link non-existent succeeded! oops\n", s);
    3508:	fd843583          	ld	a1,-40(s0)
    350c:	00006517          	auipc	a0,0x6
    3510:	bb450513          	addi	a0,a0,-1100 # 90c0 <malloc+0xedc>
    3514:	00005097          	auipc	ra,0x5
    3518:	adc080e7          	jalr	-1316(ra) # 7ff0 <printf>
    exit(1);
    351c:	4505                	li	a0,1
    351e:	00004097          	auipc	ra,0x4
    3522:	5ae080e7          	jalr	1454(ra) # 7acc <exit>
  }

  if(link(".", "lf1") >= 0){
    3526:	00006597          	auipc	a1,0x6
    352a:	ab258593          	addi	a1,a1,-1358 # 8fd8 <malloc+0xdf4>
    352e:	00006517          	auipc	a0,0x6
    3532:	bba50513          	addi	a0,a0,-1094 # 90e8 <malloc+0xf04>
    3536:	00004097          	auipc	ra,0x4
    353a:	5f6080e7          	jalr	1526(ra) # 7b2c <link>
    353e:	87aa                	mv	a5,a0
    3540:	0207c163          	bltz	a5,3562 <linktest+0x290>
    printf("%s: link . lf1 succeeded! oops\n", s);
    3544:	fd843583          	ld	a1,-40(s0)
    3548:	00006517          	auipc	a0,0x6
    354c:	ba850513          	addi	a0,a0,-1112 # 90f0 <malloc+0xf0c>
    3550:	00005097          	auipc	ra,0x5
    3554:	aa0080e7          	jalr	-1376(ra) # 7ff0 <printf>
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
    35fe:	b1650513          	addi	a0,a0,-1258 # 9110 <malloc+0xf2c>
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
    3658:	abc50513          	addi	a0,a0,-1348 # 9110 <malloc+0xf2c>
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
    3692:	a8a50513          	addi	a0,a0,-1398 # 9118 <malloc+0xf34>
    3696:	00005097          	auipc	ra,0x5
    369a:	95a080e7          	jalr	-1702(ra) # 7ff0 <printf>
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
    371a:	9d250513          	addi	a0,a0,-1582 # 90e8 <malloc+0xf04>
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
    3780:	9bc50513          	addi	a0,a0,-1604 # 9138 <malloc+0xf54>
    3784:	00005097          	auipc	ra,0x5
    3788:	86c080e7          	jalr	-1940(ra) # 7ff0 <printf>
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
    37b4:	9a850513          	addi	a0,a0,-1624 # 9158 <malloc+0xf74>
    37b8:	00005097          	auipc	ra,0x5
    37bc:	838080e7          	jalr	-1992(ra) # 7ff0 <printf>
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
    3828:	95c50513          	addi	a0,a0,-1700 # 9180 <malloc+0xf9c>
    382c:	00004097          	auipc	ra,0x4
    3830:	7c4080e7          	jalr	1988(ra) # 7ff0 <printf>
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
    3878:	eec50513          	addi	a0,a0,-276 # 8760 <malloc+0x57c>
    387c:	00004097          	auipc	ra,0x4
    3880:	774080e7          	jalr	1908(ra) # 7ff0 <printf>
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
    3a4c:	9e850513          	addi	a0,a0,-1560 # 8430 <malloc+0x24c>
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
    3a78:	cec50513          	addi	a0,a0,-788 # 8760 <malloc+0x57c>
    3a7c:	00004097          	auipc	ra,0x4
    3a80:	574080e7          	jalr	1396(ra) # 7ff0 <printf>
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
    3ada:	d1a78793          	addi	a5,a5,-742 # a7f0 <malloc+0x260c>
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
    3b04:	93050513          	addi	a0,a0,-1744 # 8430 <malloc+0x24c>
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
    3b2e:	cc678793          	addi	a5,a5,-826 # a7f0 <malloc+0x260c>
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
    3b5a:	8da58593          	addi	a1,a1,-1830 # 8430 <malloc+0x24c>
    3b5e:	00005517          	auipc	a0,0x5
    3b62:	65a50513          	addi	a0,a0,1626 # 91b8 <malloc+0xfd4>
    3b66:	00004097          	auipc	ra,0x4
    3b6a:	fc6080e7          	jalr	-58(ra) # 7b2c <link>
    3b6e:	a809                	j	3b80 <linkunlink+0x144>
    } else {
      unlink("x");
    3b70:	00005517          	auipc	a0,0x5
    3b74:	8c050513          	addi	a0,a0,-1856 # 8430 <malloc+0x24c>
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
    3bd0:	5f450513          	addi	a0,a0,1524 # 91c0 <malloc+0xfdc>
    3bd4:	00004097          	auipc	ra,0x4
    3bd8:	f48080e7          	jalr	-184(ra) # 7b1c <unlink>
  if(mkdir("dd") != 0){
    3bdc:	00005517          	auipc	a0,0x5
    3be0:	5ec50513          	addi	a0,a0,1516 # 91c8 <malloc+0xfe4>
    3be4:	00004097          	auipc	ra,0x4
    3be8:	f50080e7          	jalr	-176(ra) # 7b34 <mkdir>
    3bec:	87aa                	mv	a5,a0
    3bee:	c385                	beqz	a5,3c0e <subdir+0x4e>
    printf("%s: mkdir dd failed\n", s);
    3bf0:	fd843583          	ld	a1,-40(s0)
    3bf4:	00005517          	auipc	a0,0x5
    3bf8:	5dc50513          	addi	a0,a0,1500 # 91d0 <malloc+0xfec>
    3bfc:	00004097          	auipc	ra,0x4
    3c00:	3f4080e7          	jalr	1012(ra) # 7ff0 <printf>
    exit(1);
    3c04:	4505                	li	a0,1
    3c06:	00004097          	auipc	ra,0x4
    3c0a:	ec6080e7          	jalr	-314(ra) # 7acc <exit>
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    3c0e:	20200593          	li	a1,514
    3c12:	00005517          	auipc	a0,0x5
    3c16:	5d650513          	addi	a0,a0,1494 # 91e8 <malloc+0x1004>
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
    3c3a:	5ba50513          	addi	a0,a0,1466 # 91f0 <malloc+0x100c>
    3c3e:	00004097          	auipc	ra,0x4
    3c42:	3b2080e7          	jalr	946(ra) # 7ff0 <printf>
    exit(1);
    3c46:	4505                	li	a0,1
    3c48:	00004097          	auipc	ra,0x4
    3c4c:	e84080e7          	jalr	-380(ra) # 7acc <exit>
  }
  write(fd, "ff", 2);
    3c50:	fec42783          	lw	a5,-20(s0)
    3c54:	4609                	li	a2,2
    3c56:	00005597          	auipc	a1,0x5
    3c5a:	56a58593          	addi	a1,a1,1386 # 91c0 <malloc+0xfdc>
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
    3c7a:	55250513          	addi	a0,a0,1362 # 91c8 <malloc+0xfe4>
    3c7e:	00004097          	auipc	ra,0x4
    3c82:	e9e080e7          	jalr	-354(ra) # 7b1c <unlink>
    3c86:	87aa                	mv	a5,a0
    3c88:	0207c163          	bltz	a5,3caa <subdir+0xea>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3c8c:	fd843583          	ld	a1,-40(s0)
    3c90:	00005517          	auipc	a0,0x5
    3c94:	58050513          	addi	a0,a0,1408 # 9210 <malloc+0x102c>
    3c98:	00004097          	auipc	ra,0x4
    3c9c:	358080e7          	jalr	856(ra) # 7ff0 <printf>
    exit(1);
    3ca0:	4505                	li	a0,1
    3ca2:	00004097          	auipc	ra,0x4
    3ca6:	e2a080e7          	jalr	-470(ra) # 7acc <exit>
  }

  if(mkdir("/dd/dd") != 0){
    3caa:	00005517          	auipc	a0,0x5
    3cae:	59650513          	addi	a0,a0,1430 # 9240 <malloc+0x105c>
    3cb2:	00004097          	auipc	ra,0x4
    3cb6:	e82080e7          	jalr	-382(ra) # 7b34 <mkdir>
    3cba:	87aa                	mv	a5,a0
    3cbc:	c385                	beqz	a5,3cdc <subdir+0x11c>
    printf("subdir mkdir dd/dd failed\n", s);
    3cbe:	fd843583          	ld	a1,-40(s0)
    3cc2:	00005517          	auipc	a0,0x5
    3cc6:	58650513          	addi	a0,a0,1414 # 9248 <malloc+0x1064>
    3cca:	00004097          	auipc	ra,0x4
    3cce:	326080e7          	jalr	806(ra) # 7ff0 <printf>
    exit(1);
    3cd2:	4505                	li	a0,1
    3cd4:	00004097          	auipc	ra,0x4
    3cd8:	df8080e7          	jalr	-520(ra) # 7acc <exit>
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    3cdc:	20200593          	li	a1,514
    3ce0:	00005517          	auipc	a0,0x5
    3ce4:	58850513          	addi	a0,a0,1416 # 9268 <malloc+0x1084>
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
    3d08:	57450513          	addi	a0,a0,1396 # 9278 <malloc+0x1094>
    3d0c:	00004097          	auipc	ra,0x4
    3d10:	2e4080e7          	jalr	740(ra) # 7ff0 <printf>
    exit(1);
    3d14:	4505                	li	a0,1
    3d16:	00004097          	auipc	ra,0x4
    3d1a:	db6080e7          	jalr	-586(ra) # 7acc <exit>
  }
  write(fd, "FF", 2);
    3d1e:	fec42783          	lw	a5,-20(s0)
    3d22:	4609                	li	a2,2
    3d24:	00005597          	auipc	a1,0x5
    3d28:	57458593          	addi	a1,a1,1396 # 9298 <malloc+0x10b4>
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
    3d4a:	55a50513          	addi	a0,a0,1370 # 92a0 <malloc+0x10bc>
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
    3d6e:	54650513          	addi	a0,a0,1350 # 92b0 <malloc+0x10cc>
    3d72:	00004097          	auipc	ra,0x4
    3d76:	27e080e7          	jalr	638(ra) # 7ff0 <printf>
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
    3dce:	50650513          	addi	a0,a0,1286 # 92d0 <malloc+0x10ec>
    3dd2:	00004097          	auipc	ra,0x4
    3dd6:	21e080e7          	jalr	542(ra) # 7ff0 <printf>
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
    3df6:	4fe58593          	addi	a1,a1,1278 # 92f0 <malloc+0x110c>
    3dfa:	00005517          	auipc	a0,0x5
    3dfe:	46e50513          	addi	a0,a0,1134 # 9268 <malloc+0x1084>
    3e02:	00004097          	auipc	ra,0x4
    3e06:	d2a080e7          	jalr	-726(ra) # 7b2c <link>
    3e0a:	87aa                	mv	a5,a0
    3e0c:	c385                	beqz	a5,3e2c <subdir+0x26c>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3e0e:	fd843583          	ld	a1,-40(s0)
    3e12:	00005517          	auipc	a0,0x5
    3e16:	4ee50513          	addi	a0,a0,1262 # 9300 <malloc+0x111c>
    3e1a:	00004097          	auipc	ra,0x4
    3e1e:	1d6080e7          	jalr	470(ra) # 7ff0 <printf>
    exit(1);
    3e22:	4505                	li	a0,1
    3e24:	00004097          	auipc	ra,0x4
    3e28:	ca8080e7          	jalr	-856(ra) # 7acc <exit>
  }

  if(unlink("dd/dd/ff") != 0){
    3e2c:	00005517          	auipc	a0,0x5
    3e30:	43c50513          	addi	a0,a0,1084 # 9268 <malloc+0x1084>
    3e34:	00004097          	auipc	ra,0x4
    3e38:	ce8080e7          	jalr	-792(ra) # 7b1c <unlink>
    3e3c:	87aa                	mv	a5,a0
    3e3e:	c385                	beqz	a5,3e5e <subdir+0x29e>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3e40:	fd843583          	ld	a1,-40(s0)
    3e44:	00005517          	auipc	a0,0x5
    3e48:	4e450513          	addi	a0,a0,1252 # 9328 <malloc+0x1144>
    3e4c:	00004097          	auipc	ra,0x4
    3e50:	1a4080e7          	jalr	420(ra) # 7ff0 <printf>
    exit(1);
    3e54:	4505                	li	a0,1
    3e56:	00004097          	auipc	ra,0x4
    3e5a:	c76080e7          	jalr	-906(ra) # 7acc <exit>
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3e5e:	4581                	li	a1,0
    3e60:	00005517          	auipc	a0,0x5
    3e64:	40850513          	addi	a0,a0,1032 # 9268 <malloc+0x1084>
    3e68:	00004097          	auipc	ra,0x4
    3e6c:	ca4080e7          	jalr	-860(ra) # 7b0c <open>
    3e70:	87aa                	mv	a5,a0
    3e72:	0207c163          	bltz	a5,3e94 <subdir+0x2d4>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3e76:	fd843583          	ld	a1,-40(s0)
    3e7a:	00005517          	auipc	a0,0x5
    3e7e:	4ce50513          	addi	a0,a0,1230 # 9348 <malloc+0x1164>
    3e82:	00004097          	auipc	ra,0x4
    3e86:	16e080e7          	jalr	366(ra) # 7ff0 <printf>
    exit(1);
    3e8a:	4505                	li	a0,1
    3e8c:	00004097          	auipc	ra,0x4
    3e90:	c40080e7          	jalr	-960(ra) # 7acc <exit>
  }

  if(chdir("dd") != 0){
    3e94:	00005517          	auipc	a0,0x5
    3e98:	33450513          	addi	a0,a0,820 # 91c8 <malloc+0xfe4>
    3e9c:	00004097          	auipc	ra,0x4
    3ea0:	ca0080e7          	jalr	-864(ra) # 7b3c <chdir>
    3ea4:	87aa                	mv	a5,a0
    3ea6:	c385                	beqz	a5,3ec6 <subdir+0x306>
    printf("%s: chdir dd failed\n", s);
    3ea8:	fd843583          	ld	a1,-40(s0)
    3eac:	00005517          	auipc	a0,0x5
    3eb0:	4c450513          	addi	a0,a0,1220 # 9370 <malloc+0x118c>
    3eb4:	00004097          	auipc	ra,0x4
    3eb8:	13c080e7          	jalr	316(ra) # 7ff0 <printf>
    exit(1);
    3ebc:	4505                	li	a0,1
    3ebe:	00004097          	auipc	ra,0x4
    3ec2:	c0e080e7          	jalr	-1010(ra) # 7acc <exit>
  }
  if(chdir("dd/../../dd") != 0){
    3ec6:	00005517          	auipc	a0,0x5
    3eca:	4c250513          	addi	a0,a0,1218 # 9388 <malloc+0x11a4>
    3ece:	00004097          	auipc	ra,0x4
    3ed2:	c6e080e7          	jalr	-914(ra) # 7b3c <chdir>
    3ed6:	87aa                	mv	a5,a0
    3ed8:	c385                	beqz	a5,3ef8 <subdir+0x338>
    printf("%s: chdir dd/../../dd failed\n", s);
    3eda:	fd843583          	ld	a1,-40(s0)
    3ede:	00005517          	auipc	a0,0x5
    3ee2:	4ba50513          	addi	a0,a0,1210 # 9398 <malloc+0x11b4>
    3ee6:	00004097          	auipc	ra,0x4
    3eea:	10a080e7          	jalr	266(ra) # 7ff0 <printf>
    exit(1);
    3eee:	4505                	li	a0,1
    3ef0:	00004097          	auipc	ra,0x4
    3ef4:	bdc080e7          	jalr	-1060(ra) # 7acc <exit>
  }
  if(chdir("dd/../../../dd") != 0){
    3ef8:	00005517          	auipc	a0,0x5
    3efc:	4c050513          	addi	a0,a0,1216 # 93b8 <malloc+0x11d4>
    3f00:	00004097          	auipc	ra,0x4
    3f04:	c3c080e7          	jalr	-964(ra) # 7b3c <chdir>
    3f08:	87aa                	mv	a5,a0
    3f0a:	c385                	beqz	a5,3f2a <subdir+0x36a>
    printf("chdir dd/../../dd failed\n", s);
    3f0c:	fd843583          	ld	a1,-40(s0)
    3f10:	00005517          	auipc	a0,0x5
    3f14:	4b850513          	addi	a0,a0,1208 # 93c8 <malloc+0x11e4>
    3f18:	00004097          	auipc	ra,0x4
    3f1c:	0d8080e7          	jalr	216(ra) # 7ff0 <printf>
    exit(1);
    3f20:	4505                	li	a0,1
    3f22:	00004097          	auipc	ra,0x4
    3f26:	baa080e7          	jalr	-1110(ra) # 7acc <exit>
  }
  if(chdir("./..") != 0){
    3f2a:	00005517          	auipc	a0,0x5
    3f2e:	4be50513          	addi	a0,a0,1214 # 93e8 <malloc+0x1204>
    3f32:	00004097          	auipc	ra,0x4
    3f36:	c0a080e7          	jalr	-1014(ra) # 7b3c <chdir>
    3f3a:	87aa                	mv	a5,a0
    3f3c:	c385                	beqz	a5,3f5c <subdir+0x39c>
    printf("%s: chdir ./.. failed\n", s);
    3f3e:	fd843583          	ld	a1,-40(s0)
    3f42:	00005517          	auipc	a0,0x5
    3f46:	4ae50513          	addi	a0,a0,1198 # 93f0 <malloc+0x120c>
    3f4a:	00004097          	auipc	ra,0x4
    3f4e:	0a6080e7          	jalr	166(ra) # 7ff0 <printf>
    exit(1);
    3f52:	4505                	li	a0,1
    3f54:	00004097          	auipc	ra,0x4
    3f58:	b78080e7          	jalr	-1160(ra) # 7acc <exit>
  }

  fd = open("dd/dd/ffff", 0);
    3f5c:	4581                	li	a1,0
    3f5e:	00005517          	auipc	a0,0x5
    3f62:	39250513          	addi	a0,a0,914 # 92f0 <malloc+0x110c>
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
    3f86:	48650513          	addi	a0,a0,1158 # 9408 <malloc+0x1224>
    3f8a:	00004097          	auipc	ra,0x4
    3f8e:	066080e7          	jalr	102(ra) # 7ff0 <printf>
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
    3fc6:	46650513          	addi	a0,a0,1126 # 9428 <malloc+0x1244>
    3fca:	00004097          	auipc	ra,0x4
    3fce:	026080e7          	jalr	38(ra) # 7ff0 <printf>
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
    3ff0:	27c50513          	addi	a0,a0,636 # 9268 <malloc+0x1084>
    3ff4:	00004097          	auipc	ra,0x4
    3ff8:	b18080e7          	jalr	-1256(ra) # 7b0c <open>
    3ffc:	87aa                	mv	a5,a0
    3ffe:	0207c163          	bltz	a5,4020 <subdir+0x460>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    4002:	fd843583          	ld	a1,-40(s0)
    4006:	00005517          	auipc	a0,0x5
    400a:	44250513          	addi	a0,a0,1090 # 9448 <malloc+0x1264>
    400e:	00004097          	auipc	ra,0x4
    4012:	fe2080e7          	jalr	-30(ra) # 7ff0 <printf>
    exit(1);
    4016:	4505                	li	a0,1
    4018:	00004097          	auipc	ra,0x4
    401c:	ab4080e7          	jalr	-1356(ra) # 7acc <exit>
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    4020:	20200593          	li	a1,514
    4024:	00005517          	auipc	a0,0x5
    4028:	45450513          	addi	a0,a0,1108 # 9478 <malloc+0x1294>
    402c:	00004097          	auipc	ra,0x4
    4030:	ae0080e7          	jalr	-1312(ra) # 7b0c <open>
    4034:	87aa                	mv	a5,a0
    4036:	0207c163          	bltz	a5,4058 <subdir+0x498>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    403a:	fd843583          	ld	a1,-40(s0)
    403e:	00005517          	auipc	a0,0x5
    4042:	44a50513          	addi	a0,a0,1098 # 9488 <malloc+0x12a4>
    4046:	00004097          	auipc	ra,0x4
    404a:	faa080e7          	jalr	-86(ra) # 7ff0 <printf>
    exit(1);
    404e:	4505                	li	a0,1
    4050:	00004097          	auipc	ra,0x4
    4054:	a7c080e7          	jalr	-1412(ra) # 7acc <exit>
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    4058:	20200593          	li	a1,514
    405c:	00005517          	auipc	a0,0x5
    4060:	44c50513          	addi	a0,a0,1100 # 94a8 <malloc+0x12c4>
    4064:	00004097          	auipc	ra,0x4
    4068:	aa8080e7          	jalr	-1368(ra) # 7b0c <open>
    406c:	87aa                	mv	a5,a0
    406e:	0207c163          	bltz	a5,4090 <subdir+0x4d0>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    4072:	fd843583          	ld	a1,-40(s0)
    4076:	00005517          	auipc	a0,0x5
    407a:	44250513          	addi	a0,a0,1090 # 94b8 <malloc+0x12d4>
    407e:	00004097          	auipc	ra,0x4
    4082:	f72080e7          	jalr	-142(ra) # 7ff0 <printf>
    exit(1);
    4086:	4505                	li	a0,1
    4088:	00004097          	auipc	ra,0x4
    408c:	a44080e7          	jalr	-1468(ra) # 7acc <exit>
  }
  if(open("dd", O_CREATE) >= 0){
    4090:	20000593          	li	a1,512
    4094:	00005517          	auipc	a0,0x5
    4098:	13450513          	addi	a0,a0,308 # 91c8 <malloc+0xfe4>
    409c:	00004097          	auipc	ra,0x4
    40a0:	a70080e7          	jalr	-1424(ra) # 7b0c <open>
    40a4:	87aa                	mv	a5,a0
    40a6:	0207c163          	bltz	a5,40c8 <subdir+0x508>
    printf("%s: create dd succeeded!\n", s);
    40aa:	fd843583          	ld	a1,-40(s0)
    40ae:	00005517          	auipc	a0,0x5
    40b2:	42a50513          	addi	a0,a0,1066 # 94d8 <malloc+0x12f4>
    40b6:	00004097          	auipc	ra,0x4
    40ba:	f3a080e7          	jalr	-198(ra) # 7ff0 <printf>
    exit(1);
    40be:	4505                	li	a0,1
    40c0:	00004097          	auipc	ra,0x4
    40c4:	a0c080e7          	jalr	-1524(ra) # 7acc <exit>
  }
  if(open("dd", O_RDWR) >= 0){
    40c8:	4589                	li	a1,2
    40ca:	00005517          	auipc	a0,0x5
    40ce:	0fe50513          	addi	a0,a0,254 # 91c8 <malloc+0xfe4>
    40d2:	00004097          	auipc	ra,0x4
    40d6:	a3a080e7          	jalr	-1478(ra) # 7b0c <open>
    40da:	87aa                	mv	a5,a0
    40dc:	0207c163          	bltz	a5,40fe <subdir+0x53e>
    printf("%s: open dd rdwr succeeded!\n", s);
    40e0:	fd843583          	ld	a1,-40(s0)
    40e4:	00005517          	auipc	a0,0x5
    40e8:	41450513          	addi	a0,a0,1044 # 94f8 <malloc+0x1314>
    40ec:	00004097          	auipc	ra,0x4
    40f0:	f04080e7          	jalr	-252(ra) # 7ff0 <printf>
    exit(1);
    40f4:	4505                	li	a0,1
    40f6:	00004097          	auipc	ra,0x4
    40fa:	9d6080e7          	jalr	-1578(ra) # 7acc <exit>
  }
  if(open("dd", O_WRONLY) >= 0){
    40fe:	4585                	li	a1,1
    4100:	00005517          	auipc	a0,0x5
    4104:	0c850513          	addi	a0,a0,200 # 91c8 <malloc+0xfe4>
    4108:	00004097          	auipc	ra,0x4
    410c:	a04080e7          	jalr	-1532(ra) # 7b0c <open>
    4110:	87aa                	mv	a5,a0
    4112:	0207c163          	bltz	a5,4134 <subdir+0x574>
    printf("%s: open dd wronly succeeded!\n", s);
    4116:	fd843583          	ld	a1,-40(s0)
    411a:	00005517          	auipc	a0,0x5
    411e:	3fe50513          	addi	a0,a0,1022 # 9518 <malloc+0x1334>
    4122:	00004097          	auipc	ra,0x4
    4126:	ece080e7          	jalr	-306(ra) # 7ff0 <printf>
    exit(1);
    412a:	4505                	li	a0,1
    412c:	00004097          	auipc	ra,0x4
    4130:	9a0080e7          	jalr	-1632(ra) # 7acc <exit>
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    4134:	00005597          	auipc	a1,0x5
    4138:	40458593          	addi	a1,a1,1028 # 9538 <malloc+0x1354>
    413c:	00005517          	auipc	a0,0x5
    4140:	33c50513          	addi	a0,a0,828 # 9478 <malloc+0x1294>
    4144:	00004097          	auipc	ra,0x4
    4148:	9e8080e7          	jalr	-1560(ra) # 7b2c <link>
    414c:	87aa                	mv	a5,a0
    414e:	e385                	bnez	a5,416e <subdir+0x5ae>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    4150:	fd843583          	ld	a1,-40(s0)
    4154:	00005517          	auipc	a0,0x5
    4158:	3f450513          	addi	a0,a0,1012 # 9548 <malloc+0x1364>
    415c:	00004097          	auipc	ra,0x4
    4160:	e94080e7          	jalr	-364(ra) # 7ff0 <printf>
    exit(1);
    4164:	4505                	li	a0,1
    4166:	00004097          	auipc	ra,0x4
    416a:	966080e7          	jalr	-1690(ra) # 7acc <exit>
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    416e:	00005597          	auipc	a1,0x5
    4172:	3ca58593          	addi	a1,a1,970 # 9538 <malloc+0x1354>
    4176:	00005517          	auipc	a0,0x5
    417a:	33250513          	addi	a0,a0,818 # 94a8 <malloc+0x12c4>
    417e:	00004097          	auipc	ra,0x4
    4182:	9ae080e7          	jalr	-1618(ra) # 7b2c <link>
    4186:	87aa                	mv	a5,a0
    4188:	e385                	bnez	a5,41a8 <subdir+0x5e8>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    418a:	fd843583          	ld	a1,-40(s0)
    418e:	00005517          	auipc	a0,0x5
    4192:	3e250513          	addi	a0,a0,994 # 9570 <malloc+0x138c>
    4196:	00004097          	auipc	ra,0x4
    419a:	e5a080e7          	jalr	-422(ra) # 7ff0 <printf>
    exit(1);
    419e:	4505                	li	a0,1
    41a0:	00004097          	auipc	ra,0x4
    41a4:	92c080e7          	jalr	-1748(ra) # 7acc <exit>
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    41a8:	00005597          	auipc	a1,0x5
    41ac:	14858593          	addi	a1,a1,328 # 92f0 <malloc+0x110c>
    41b0:	00005517          	auipc	a0,0x5
    41b4:	03850513          	addi	a0,a0,56 # 91e8 <malloc+0x1004>
    41b8:	00004097          	auipc	ra,0x4
    41bc:	974080e7          	jalr	-1676(ra) # 7b2c <link>
    41c0:	87aa                	mv	a5,a0
    41c2:	e385                	bnez	a5,41e2 <subdir+0x622>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    41c4:	fd843583          	ld	a1,-40(s0)
    41c8:	00005517          	auipc	a0,0x5
    41cc:	3d050513          	addi	a0,a0,976 # 9598 <malloc+0x13b4>
    41d0:	00004097          	auipc	ra,0x4
    41d4:	e20080e7          	jalr	-480(ra) # 7ff0 <printf>
    exit(1);
    41d8:	4505                	li	a0,1
    41da:	00004097          	auipc	ra,0x4
    41de:	8f2080e7          	jalr	-1806(ra) # 7acc <exit>
  }
  if(mkdir("dd/ff/ff") == 0){
    41e2:	00005517          	auipc	a0,0x5
    41e6:	29650513          	addi	a0,a0,662 # 9478 <malloc+0x1294>
    41ea:	00004097          	auipc	ra,0x4
    41ee:	94a080e7          	jalr	-1718(ra) # 7b34 <mkdir>
    41f2:	87aa                	mv	a5,a0
    41f4:	e385                	bnez	a5,4214 <subdir+0x654>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    41f6:	fd843583          	ld	a1,-40(s0)
    41fa:	00005517          	auipc	a0,0x5
    41fe:	3c650513          	addi	a0,a0,966 # 95c0 <malloc+0x13dc>
    4202:	00004097          	auipc	ra,0x4
    4206:	dee080e7          	jalr	-530(ra) # 7ff0 <printf>
    exit(1);
    420a:	4505                	li	a0,1
    420c:	00004097          	auipc	ra,0x4
    4210:	8c0080e7          	jalr	-1856(ra) # 7acc <exit>
  }
  if(mkdir("dd/xx/ff") == 0){
    4214:	00005517          	auipc	a0,0x5
    4218:	29450513          	addi	a0,a0,660 # 94a8 <malloc+0x12c4>
    421c:	00004097          	auipc	ra,0x4
    4220:	918080e7          	jalr	-1768(ra) # 7b34 <mkdir>
    4224:	87aa                	mv	a5,a0
    4226:	e385                	bnez	a5,4246 <subdir+0x686>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    4228:	fd843583          	ld	a1,-40(s0)
    422c:	00005517          	auipc	a0,0x5
    4230:	3b450513          	addi	a0,a0,948 # 95e0 <malloc+0x13fc>
    4234:	00004097          	auipc	ra,0x4
    4238:	dbc080e7          	jalr	-580(ra) # 7ff0 <printf>
    exit(1);
    423c:	4505                	li	a0,1
    423e:	00004097          	auipc	ra,0x4
    4242:	88e080e7          	jalr	-1906(ra) # 7acc <exit>
  }
  if(mkdir("dd/dd/ffff") == 0){
    4246:	00005517          	auipc	a0,0x5
    424a:	0aa50513          	addi	a0,a0,170 # 92f0 <malloc+0x110c>
    424e:	00004097          	auipc	ra,0x4
    4252:	8e6080e7          	jalr	-1818(ra) # 7b34 <mkdir>
    4256:	87aa                	mv	a5,a0
    4258:	e385                	bnez	a5,4278 <subdir+0x6b8>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    425a:	fd843583          	ld	a1,-40(s0)
    425e:	00005517          	auipc	a0,0x5
    4262:	3a250513          	addi	a0,a0,930 # 9600 <malloc+0x141c>
    4266:	00004097          	auipc	ra,0x4
    426a:	d8a080e7          	jalr	-630(ra) # 7ff0 <printf>
    exit(1);
    426e:	4505                	li	a0,1
    4270:	00004097          	auipc	ra,0x4
    4274:	85c080e7          	jalr	-1956(ra) # 7acc <exit>
  }
  if(unlink("dd/xx/ff") == 0){
    4278:	00005517          	auipc	a0,0x5
    427c:	23050513          	addi	a0,a0,560 # 94a8 <malloc+0x12c4>
    4280:	00004097          	auipc	ra,0x4
    4284:	89c080e7          	jalr	-1892(ra) # 7b1c <unlink>
    4288:	87aa                	mv	a5,a0
    428a:	e385                	bnez	a5,42aa <subdir+0x6ea>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    428c:	fd843583          	ld	a1,-40(s0)
    4290:	00005517          	auipc	a0,0x5
    4294:	39850513          	addi	a0,a0,920 # 9628 <malloc+0x1444>
    4298:	00004097          	auipc	ra,0x4
    429c:	d58080e7          	jalr	-680(ra) # 7ff0 <printf>
    exit(1);
    42a0:	4505                	li	a0,1
    42a2:	00004097          	auipc	ra,0x4
    42a6:	82a080e7          	jalr	-2006(ra) # 7acc <exit>
  }
  if(unlink("dd/ff/ff") == 0){
    42aa:	00005517          	auipc	a0,0x5
    42ae:	1ce50513          	addi	a0,a0,462 # 9478 <malloc+0x1294>
    42b2:	00004097          	auipc	ra,0x4
    42b6:	86a080e7          	jalr	-1942(ra) # 7b1c <unlink>
    42ba:	87aa                	mv	a5,a0
    42bc:	e385                	bnez	a5,42dc <subdir+0x71c>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    42be:	fd843583          	ld	a1,-40(s0)
    42c2:	00005517          	auipc	a0,0x5
    42c6:	38650513          	addi	a0,a0,902 # 9648 <malloc+0x1464>
    42ca:	00004097          	auipc	ra,0x4
    42ce:	d26080e7          	jalr	-730(ra) # 7ff0 <printf>
    exit(1);
    42d2:	4505                	li	a0,1
    42d4:	00003097          	auipc	ra,0x3
    42d8:	7f8080e7          	jalr	2040(ra) # 7acc <exit>
  }
  if(chdir("dd/ff") == 0){
    42dc:	00005517          	auipc	a0,0x5
    42e0:	f0c50513          	addi	a0,a0,-244 # 91e8 <malloc+0x1004>
    42e4:	00004097          	auipc	ra,0x4
    42e8:	858080e7          	jalr	-1960(ra) # 7b3c <chdir>
    42ec:	87aa                	mv	a5,a0
    42ee:	e385                	bnez	a5,430e <subdir+0x74e>
    printf("%s: chdir dd/ff succeeded!\n", s);
    42f0:	fd843583          	ld	a1,-40(s0)
    42f4:	00005517          	auipc	a0,0x5
    42f8:	37450513          	addi	a0,a0,884 # 9668 <malloc+0x1484>
    42fc:	00004097          	auipc	ra,0x4
    4300:	cf4080e7          	jalr	-780(ra) # 7ff0 <printf>
    exit(1);
    4304:	4505                	li	a0,1
    4306:	00003097          	auipc	ra,0x3
    430a:	7c6080e7          	jalr	1990(ra) # 7acc <exit>
  }
  if(chdir("dd/xx") == 0){
    430e:	00005517          	auipc	a0,0x5
    4312:	37a50513          	addi	a0,a0,890 # 9688 <malloc+0x14a4>
    4316:	00004097          	auipc	ra,0x4
    431a:	826080e7          	jalr	-2010(ra) # 7b3c <chdir>
    431e:	87aa                	mv	a5,a0
    4320:	e385                	bnez	a5,4340 <subdir+0x780>
    printf("%s: chdir dd/xx succeeded!\n", s);
    4322:	fd843583          	ld	a1,-40(s0)
    4326:	00005517          	auipc	a0,0x5
    432a:	36a50513          	addi	a0,a0,874 # 9690 <malloc+0x14ac>
    432e:	00004097          	auipc	ra,0x4
    4332:	cc2080e7          	jalr	-830(ra) # 7ff0 <printf>
    exit(1);
    4336:	4505                	li	a0,1
    4338:	00003097          	auipc	ra,0x3
    433c:	794080e7          	jalr	1940(ra) # 7acc <exit>
  }

  if(unlink("dd/dd/ffff") != 0){
    4340:	00005517          	auipc	a0,0x5
    4344:	fb050513          	addi	a0,a0,-80 # 92f0 <malloc+0x110c>
    4348:	00003097          	auipc	ra,0x3
    434c:	7d4080e7          	jalr	2004(ra) # 7b1c <unlink>
    4350:	87aa                	mv	a5,a0
    4352:	c385                	beqz	a5,4372 <subdir+0x7b2>
    printf("%s: unlink dd/dd/ff failed\n", s);
    4354:	fd843583          	ld	a1,-40(s0)
    4358:	00005517          	auipc	a0,0x5
    435c:	fd050513          	addi	a0,a0,-48 # 9328 <malloc+0x1144>
    4360:	00004097          	auipc	ra,0x4
    4364:	c90080e7          	jalr	-880(ra) # 7ff0 <printf>
    exit(1);
    4368:	4505                	li	a0,1
    436a:	00003097          	auipc	ra,0x3
    436e:	762080e7          	jalr	1890(ra) # 7acc <exit>
  }
  if(unlink("dd/ff") != 0){
    4372:	00005517          	auipc	a0,0x5
    4376:	e7650513          	addi	a0,a0,-394 # 91e8 <malloc+0x1004>
    437a:	00003097          	auipc	ra,0x3
    437e:	7a2080e7          	jalr	1954(ra) # 7b1c <unlink>
    4382:	87aa                	mv	a5,a0
    4384:	c385                	beqz	a5,43a4 <subdir+0x7e4>
    printf("%s: unlink dd/ff failed\n", s);
    4386:	fd843583          	ld	a1,-40(s0)
    438a:	00005517          	auipc	a0,0x5
    438e:	32650513          	addi	a0,a0,806 # 96b0 <malloc+0x14cc>
    4392:	00004097          	auipc	ra,0x4
    4396:	c5e080e7          	jalr	-930(ra) # 7ff0 <printf>
    exit(1);
    439a:	4505                	li	a0,1
    439c:	00003097          	auipc	ra,0x3
    43a0:	730080e7          	jalr	1840(ra) # 7acc <exit>
  }
  if(unlink("dd") == 0){
    43a4:	00005517          	auipc	a0,0x5
    43a8:	e2450513          	addi	a0,a0,-476 # 91c8 <malloc+0xfe4>
    43ac:	00003097          	auipc	ra,0x3
    43b0:	770080e7          	jalr	1904(ra) # 7b1c <unlink>
    43b4:	87aa                	mv	a5,a0
    43b6:	e385                	bnez	a5,43d6 <subdir+0x816>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    43b8:	fd843583          	ld	a1,-40(s0)
    43bc:	00005517          	auipc	a0,0x5
    43c0:	31450513          	addi	a0,a0,788 # 96d0 <malloc+0x14ec>
    43c4:	00004097          	auipc	ra,0x4
    43c8:	c2c080e7          	jalr	-980(ra) # 7ff0 <printf>
    exit(1);
    43cc:	4505                	li	a0,1
    43ce:	00003097          	auipc	ra,0x3
    43d2:	6fe080e7          	jalr	1790(ra) # 7acc <exit>
  }
  if(unlink("dd/dd") < 0){
    43d6:	00005517          	auipc	a0,0x5
    43da:	32250513          	addi	a0,a0,802 # 96f8 <malloc+0x1514>
    43de:	00003097          	auipc	ra,0x3
    43e2:	73e080e7          	jalr	1854(ra) # 7b1c <unlink>
    43e6:	87aa                	mv	a5,a0
    43e8:	0207d163          	bgez	a5,440a <subdir+0x84a>
    printf("%s: unlink dd/dd failed\n", s);
    43ec:	fd843583          	ld	a1,-40(s0)
    43f0:	00005517          	auipc	a0,0x5
    43f4:	31050513          	addi	a0,a0,784 # 9700 <malloc+0x151c>
    43f8:	00004097          	auipc	ra,0x4
    43fc:	bf8080e7          	jalr	-1032(ra) # 7ff0 <printf>
    exit(1);
    4400:	4505                	li	a0,1
    4402:	00003097          	auipc	ra,0x3
    4406:	6ca080e7          	jalr	1738(ra) # 7acc <exit>
  }
  if(unlink("dd") < 0){
    440a:	00005517          	auipc	a0,0x5
    440e:	dbe50513          	addi	a0,a0,-578 # 91c8 <malloc+0xfe4>
    4412:	00003097          	auipc	ra,0x3
    4416:	70a080e7          	jalr	1802(ra) # 7b1c <unlink>
    441a:	87aa                	mv	a5,a0
    441c:	0207d163          	bgez	a5,443e <subdir+0x87e>
    printf("%s: unlink dd failed\n", s);
    4420:	fd843583          	ld	a1,-40(s0)
    4424:	00005517          	auipc	a0,0x5
    4428:	2fc50513          	addi	a0,a0,764 # 9720 <malloc+0x153c>
    442c:	00004097          	auipc	ra,0x4
    4430:	bc4080e7          	jalr	-1084(ra) # 7ff0 <printf>
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
    4458:	2e450513          	addi	a0,a0,740 # 9738 <malloc+0x1554>
    445c:	00003097          	auipc	ra,0x3
    4460:	6c0080e7          	jalr	1728(ra) # 7b1c <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
    4464:	1f300793          	li	a5,499
    4468:	fef42623          	sw	a5,-20(s0)
    446c:	a0ed                	j	4556 <bigwrite+0x10e>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    446e:	20200593          	li	a1,514
    4472:	00005517          	auipc	a0,0x5
    4476:	2c650513          	addi	a0,a0,710 # 9738 <malloc+0x1554>
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
    449a:	2b250513          	addi	a0,a0,690 # 9748 <malloc+0x1564>
    449e:	00004097          	auipc	ra,0x4
    44a2:	b52080e7          	jalr	-1198(ra) # 7ff0 <printf>
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
    44fe:	26e50513          	addi	a0,a0,622 # 9768 <malloc+0x1584>
    4502:	00004097          	auipc	ra,0x4
    4506:	aee080e7          	jalr	-1298(ra) # 7ff0 <printf>
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
    453e:	1fe50513          	addi	a0,a0,510 # 9738 <malloc+0x1554>
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
    4580:	20450513          	addi	a0,a0,516 # 9780 <malloc+0x159c>
    4584:	00003097          	auipc	ra,0x3
    4588:	598080e7          	jalr	1432(ra) # 7b1c <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    458c:	20200593          	li	a1,514
    4590:	00005517          	auipc	a0,0x5
    4594:	1f050513          	addi	a0,a0,496 # 9780 <malloc+0x159c>
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
    45b8:	1dc50513          	addi	a0,a0,476 # 9790 <malloc+0x15ac>
    45bc:	00004097          	auipc	ra,0x4
    45c0:	a34080e7          	jalr	-1484(ra) # 7ff0 <printf>
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
    461c:	19850513          	addi	a0,a0,408 # 97b0 <malloc+0x15cc>
    4620:	00004097          	auipc	ra,0x4
    4624:	9d0080e7          	jalr	-1584(ra) # 7ff0 <printf>
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
    465e:	12650513          	addi	a0,a0,294 # 9780 <malloc+0x159c>
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
    4682:	15250513          	addi	a0,a0,338 # 97d0 <malloc+0x15ec>
    4686:	00004097          	auipc	ra,0x4
    468a:	96a080e7          	jalr	-1686(ra) # 7ff0 <printf>
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
    46d2:	12250513          	addi	a0,a0,290 # 97f0 <malloc+0x160c>
    46d6:	00004097          	auipc	ra,0x4
    46da:	91a080e7          	jalr	-1766(ra) # 7ff0 <printf>
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
    4708:	10c50513          	addi	a0,a0,268 # 9810 <malloc+0x162c>
    470c:	00004097          	auipc	ra,0x4
    4710:	8e4080e7          	jalr	-1820(ra) # 7ff0 <printf>
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
    476e:	0be50513          	addi	a0,a0,190 # 9828 <malloc+0x1644>
    4772:	00004097          	auipc	ra,0x4
    4776:	87e080e7          	jalr	-1922(ra) # 7ff0 <printf>
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
    47ca:	08250513          	addi	a0,a0,130 # 9848 <malloc+0x1664>
    47ce:	00004097          	auipc	ra,0x4
    47d2:	822080e7          	jalr	-2014(ra) # 7ff0 <printf>
    exit(1);
    47d6:	4505                	li	a0,1
    47d8:	00003097          	auipc	ra,0x3
    47dc:	2f4080e7          	jalr	756(ra) # 7acc <exit>
  }
  unlink("bigfile.dat");
    47e0:	00005517          	auipc	a0,0x5
    47e4:	fa050513          	addi	a0,a0,-96 # 9780 <malloc+0x159c>
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
    480a:	06250513          	addi	a0,a0,98 # 9868 <malloc+0x1684>
    480e:	00003097          	auipc	ra,0x3
    4812:	326080e7          	jalr	806(ra) # 7b34 <mkdir>
    4816:	87aa                	mv	a5,a0
    4818:	c385                	beqz	a5,4838 <fourteen+0x3e>
    printf("%s: mkdir 12345678901234 failed\n", s);
    481a:	fd843583          	ld	a1,-40(s0)
    481e:	00005517          	auipc	a0,0x5
    4822:	05a50513          	addi	a0,a0,90 # 9878 <malloc+0x1694>
    4826:	00003097          	auipc	ra,0x3
    482a:	7ca080e7          	jalr	1994(ra) # 7ff0 <printf>
    exit(1);
    482e:	4505                	li	a0,1
    4830:	00003097          	auipc	ra,0x3
    4834:	29c080e7          	jalr	668(ra) # 7acc <exit>
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    4838:	00005517          	auipc	a0,0x5
    483c:	06850513          	addi	a0,a0,104 # 98a0 <malloc+0x16bc>
    4840:	00003097          	auipc	ra,0x3
    4844:	2f4080e7          	jalr	756(ra) # 7b34 <mkdir>
    4848:	87aa                	mv	a5,a0
    484a:	c385                	beqz	a5,486a <fourteen+0x70>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    484c:	fd843583          	ld	a1,-40(s0)
    4850:	00005517          	auipc	a0,0x5
    4854:	07050513          	addi	a0,a0,112 # 98c0 <malloc+0x16dc>
    4858:	00003097          	auipc	ra,0x3
    485c:	798080e7          	jalr	1944(ra) # 7ff0 <printf>
    exit(1);
    4860:	4505                	li	a0,1
    4862:	00003097          	auipc	ra,0x3
    4866:	26a080e7          	jalr	618(ra) # 7acc <exit>
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    486a:	20000593          	li	a1,512
    486e:	00005517          	auipc	a0,0x5
    4872:	08a50513          	addi	a0,a0,138 # 98f8 <malloc+0x1714>
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
    4896:	09650513          	addi	a0,a0,150 # 9928 <malloc+0x1744>
    489a:	00003097          	auipc	ra,0x3
    489e:	756080e7          	jalr	1878(ra) # 7ff0 <printf>
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
    48c0:	0b450513          	addi	a0,a0,180 # 9970 <malloc+0x178c>
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
    48e4:	0c050513          	addi	a0,a0,192 # 99a0 <malloc+0x17bc>
    48e8:	00003097          	auipc	ra,0x3
    48ec:	708080e7          	jalr	1800(ra) # 7ff0 <printf>
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
    490c:	0d850513          	addi	a0,a0,216 # 99e0 <malloc+0x17fc>
    4910:	00003097          	auipc	ra,0x3
    4914:	224080e7          	jalr	548(ra) # 7b34 <mkdir>
    4918:	87aa                	mv	a5,a0
    491a:	e385                	bnez	a5,493a <fourteen+0x140>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    491c:	fd843583          	ld	a1,-40(s0)
    4920:	00005517          	auipc	a0,0x5
    4924:	0e050513          	addi	a0,a0,224 # 9a00 <malloc+0x181c>
    4928:	00003097          	auipc	ra,0x3
    492c:	6c8080e7          	jalr	1736(ra) # 7ff0 <printf>
    exit(1);
    4930:	4505                	li	a0,1
    4932:	00003097          	auipc	ra,0x3
    4936:	19a080e7          	jalr	410(ra) # 7acc <exit>
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    493a:	00005517          	auipc	a0,0x5
    493e:	0fe50513          	addi	a0,a0,254 # 9a38 <malloc+0x1854>
    4942:	00003097          	auipc	ra,0x3
    4946:	1f2080e7          	jalr	498(ra) # 7b34 <mkdir>
    494a:	87aa                	mv	a5,a0
    494c:	e385                	bnez	a5,496c <fourteen+0x172>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    494e:	fd843583          	ld	a1,-40(s0)
    4952:	00005517          	auipc	a0,0x5
    4956:	10650513          	addi	a0,a0,262 # 9a58 <malloc+0x1874>
    495a:	00003097          	auipc	ra,0x3
    495e:	696080e7          	jalr	1686(ra) # 7ff0 <printf>
    exit(1);
    4962:	4505                	li	a0,1
    4964:	00003097          	auipc	ra,0x3
    4968:	168080e7          	jalr	360(ra) # 7acc <exit>
  }

  // clean up
  unlink("123456789012345/12345678901234");
    496c:	00005517          	auipc	a0,0x5
    4970:	0cc50513          	addi	a0,a0,204 # 9a38 <malloc+0x1854>
    4974:	00003097          	auipc	ra,0x3
    4978:	1a8080e7          	jalr	424(ra) # 7b1c <unlink>
  unlink("12345678901234/12345678901234");
    497c:	00005517          	auipc	a0,0x5
    4980:	06450513          	addi	a0,a0,100 # 99e0 <malloc+0x17fc>
    4984:	00003097          	auipc	ra,0x3
    4988:	198080e7          	jalr	408(ra) # 7b1c <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    498c:	00005517          	auipc	a0,0x5
    4990:	fe450513          	addi	a0,a0,-28 # 9970 <malloc+0x178c>
    4994:	00003097          	auipc	ra,0x3
    4998:	188080e7          	jalr	392(ra) # 7b1c <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    499c:	00005517          	auipc	a0,0x5
    49a0:	f5c50513          	addi	a0,a0,-164 # 98f8 <malloc+0x1714>
    49a4:	00003097          	auipc	ra,0x3
    49a8:	178080e7          	jalr	376(ra) # 7b1c <unlink>
  unlink("12345678901234/123456789012345");
    49ac:	00005517          	auipc	a0,0x5
    49b0:	ef450513          	addi	a0,a0,-268 # 98a0 <malloc+0x16bc>
    49b4:	00003097          	auipc	ra,0x3
    49b8:	168080e7          	jalr	360(ra) # 7b1c <unlink>
  unlink("12345678901234");
    49bc:	00005517          	auipc	a0,0x5
    49c0:	eac50513          	addi	a0,a0,-340 # 9868 <malloc+0x1684>
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
    49e6:	0ae50513          	addi	a0,a0,174 # 9a90 <malloc+0x18ac>
    49ea:	00003097          	auipc	ra,0x3
    49ee:	14a080e7          	jalr	330(ra) # 7b34 <mkdir>
    49f2:	87aa                	mv	a5,a0
    49f4:	c385                	beqz	a5,4a14 <rmdot+0x3e>
    printf("%s: mkdir dots failed\n", s);
    49f6:	fe843583          	ld	a1,-24(s0)
    49fa:	00005517          	auipc	a0,0x5
    49fe:	09e50513          	addi	a0,a0,158 # 9a98 <malloc+0x18b4>
    4a02:	00003097          	auipc	ra,0x3
    4a06:	5ee080e7          	jalr	1518(ra) # 7ff0 <printf>
    exit(1);
    4a0a:	4505                	li	a0,1
    4a0c:	00003097          	auipc	ra,0x3
    4a10:	0c0080e7          	jalr	192(ra) # 7acc <exit>
  }
  if(chdir("dots") != 0){
    4a14:	00005517          	auipc	a0,0x5
    4a18:	07c50513          	addi	a0,a0,124 # 9a90 <malloc+0x18ac>
    4a1c:	00003097          	auipc	ra,0x3
    4a20:	120080e7          	jalr	288(ra) # 7b3c <chdir>
    4a24:	87aa                	mv	a5,a0
    4a26:	c385                	beqz	a5,4a46 <rmdot+0x70>
    printf("%s: chdir dots failed\n", s);
    4a28:	fe843583          	ld	a1,-24(s0)
    4a2c:	00005517          	auipc	a0,0x5
    4a30:	08450513          	addi	a0,a0,132 # 9ab0 <malloc+0x18cc>
    4a34:	00003097          	auipc	ra,0x3
    4a38:	5bc080e7          	jalr	1468(ra) # 7ff0 <printf>
    exit(1);
    4a3c:	4505                	li	a0,1
    4a3e:	00003097          	auipc	ra,0x3
    4a42:	08e080e7          	jalr	142(ra) # 7acc <exit>
  }
  if(unlink(".") == 0){
    4a46:	00004517          	auipc	a0,0x4
    4a4a:	6a250513          	addi	a0,a0,1698 # 90e8 <malloc+0xf04>
    4a4e:	00003097          	auipc	ra,0x3
    4a52:	0ce080e7          	jalr	206(ra) # 7b1c <unlink>
    4a56:	87aa                	mv	a5,a0
    4a58:	e385                	bnez	a5,4a78 <rmdot+0xa2>
    printf("%s: rm . worked!\n", s);
    4a5a:	fe843583          	ld	a1,-24(s0)
    4a5e:	00005517          	auipc	a0,0x5
    4a62:	06a50513          	addi	a0,a0,106 # 9ac8 <malloc+0x18e4>
    4a66:	00003097          	auipc	ra,0x3
    4a6a:	58a080e7          	jalr	1418(ra) # 7ff0 <printf>
    exit(1);
    4a6e:	4505                	li	a0,1
    4a70:	00003097          	auipc	ra,0x3
    4a74:	05c080e7          	jalr	92(ra) # 7acc <exit>
  }
  if(unlink("..") == 0){
    4a78:	00004517          	auipc	a0,0x4
    4a7c:	0c850513          	addi	a0,a0,200 # 8b40 <malloc+0x95c>
    4a80:	00003097          	auipc	ra,0x3
    4a84:	09c080e7          	jalr	156(ra) # 7b1c <unlink>
    4a88:	87aa                	mv	a5,a0
    4a8a:	e385                	bnez	a5,4aaa <rmdot+0xd4>
    printf("%s: rm .. worked!\n", s);
    4a8c:	fe843583          	ld	a1,-24(s0)
    4a90:	00005517          	auipc	a0,0x5
    4a94:	05050513          	addi	a0,a0,80 # 9ae0 <malloc+0x18fc>
    4a98:	00003097          	auipc	ra,0x3
    4a9c:	558080e7          	jalr	1368(ra) # 7ff0 <printf>
    exit(1);
    4aa0:	4505                	li	a0,1
    4aa2:	00003097          	auipc	ra,0x3
    4aa6:	02a080e7          	jalr	42(ra) # 7acc <exit>
  }
  if(chdir("/") != 0){
    4aaa:	00004517          	auipc	a0,0x4
    4aae:	dae50513          	addi	a0,a0,-594 # 8858 <malloc+0x674>
    4ab2:	00003097          	auipc	ra,0x3
    4ab6:	08a080e7          	jalr	138(ra) # 7b3c <chdir>
    4aba:	87aa                	mv	a5,a0
    4abc:	c385                	beqz	a5,4adc <rmdot+0x106>
    printf("%s: chdir / failed\n", s);
    4abe:	fe843583          	ld	a1,-24(s0)
    4ac2:	00004517          	auipc	a0,0x4
    4ac6:	d9e50513          	addi	a0,a0,-610 # 8860 <malloc+0x67c>
    4aca:	00003097          	auipc	ra,0x3
    4ace:	526080e7          	jalr	1318(ra) # 7ff0 <printf>
    exit(1);
    4ad2:	4505                	li	a0,1
    4ad4:	00003097          	auipc	ra,0x3
    4ad8:	ff8080e7          	jalr	-8(ra) # 7acc <exit>
  }
  if(unlink("dots/.") == 0){
    4adc:	00005517          	auipc	a0,0x5
    4ae0:	01c50513          	addi	a0,a0,28 # 9af8 <malloc+0x1914>
    4ae4:	00003097          	auipc	ra,0x3
    4ae8:	038080e7          	jalr	56(ra) # 7b1c <unlink>
    4aec:	87aa                	mv	a5,a0
    4aee:	e385                	bnez	a5,4b0e <rmdot+0x138>
    printf("%s: unlink dots/. worked!\n", s);
    4af0:	fe843583          	ld	a1,-24(s0)
    4af4:	00005517          	auipc	a0,0x5
    4af8:	00c50513          	addi	a0,a0,12 # 9b00 <malloc+0x191c>
    4afc:	00003097          	auipc	ra,0x3
    4b00:	4f4080e7          	jalr	1268(ra) # 7ff0 <printf>
    exit(1);
    4b04:	4505                	li	a0,1
    4b06:	00003097          	auipc	ra,0x3
    4b0a:	fc6080e7          	jalr	-58(ra) # 7acc <exit>
  }
  if(unlink("dots/..") == 0){
    4b0e:	00005517          	auipc	a0,0x5
    4b12:	01250513          	addi	a0,a0,18 # 9b20 <malloc+0x193c>
    4b16:	00003097          	auipc	ra,0x3
    4b1a:	006080e7          	jalr	6(ra) # 7b1c <unlink>
    4b1e:	87aa                	mv	a5,a0
    4b20:	e385                	bnez	a5,4b40 <rmdot+0x16a>
    printf("%s: unlink dots/.. worked!\n", s);
    4b22:	fe843583          	ld	a1,-24(s0)
    4b26:	00005517          	auipc	a0,0x5
    4b2a:	00250513          	addi	a0,a0,2 # 9b28 <malloc+0x1944>
    4b2e:	00003097          	auipc	ra,0x3
    4b32:	4c2080e7          	jalr	1218(ra) # 7ff0 <printf>
    exit(1);
    4b36:	4505                	li	a0,1
    4b38:	00003097          	auipc	ra,0x3
    4b3c:	f94080e7          	jalr	-108(ra) # 7acc <exit>
  }
  if(unlink("dots") != 0){
    4b40:	00005517          	auipc	a0,0x5
    4b44:	f5050513          	addi	a0,a0,-176 # 9a90 <malloc+0x18ac>
    4b48:	00003097          	auipc	ra,0x3
    4b4c:	fd4080e7          	jalr	-44(ra) # 7b1c <unlink>
    4b50:	87aa                	mv	a5,a0
    4b52:	c385                	beqz	a5,4b72 <rmdot+0x19c>
    printf("%s: unlink dots failed!\n", s);
    4b54:	fe843583          	ld	a1,-24(s0)
    4b58:	00005517          	auipc	a0,0x5
    4b5c:	ff050513          	addi	a0,a0,-16 # 9b48 <malloc+0x1964>
    4b60:	00003097          	auipc	ra,0x3
    4b64:	490080e7          	jalr	1168(ra) # 7ff0 <printf>
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
    4b90:	fdc50513          	addi	a0,a0,-36 # 9b68 <malloc+0x1984>
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
    4bb4:	fc050513          	addi	a0,a0,-64 # 9b70 <malloc+0x198c>
    4bb8:	00003097          	auipc	ra,0x3
    4bbc:	438080e7          	jalr	1080(ra) # 7ff0 <printf>
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
    4bdc:	f9050513          	addi	a0,a0,-112 # 9b68 <malloc+0x1984>
    4be0:	00003097          	auipc	ra,0x3
    4be4:	f5c080e7          	jalr	-164(ra) # 7b3c <chdir>
    4be8:	87aa                	mv	a5,a0
    4bea:	e385                	bnez	a5,4c0a <dirfile+0x8e>
    printf("%s: chdir dirfile succeeded!\n", s);
    4bec:	fd843583          	ld	a1,-40(s0)
    4bf0:	00005517          	auipc	a0,0x5
    4bf4:	fa050513          	addi	a0,a0,-96 # 9b90 <malloc+0x19ac>
    4bf8:	00003097          	auipc	ra,0x3
    4bfc:	3f8080e7          	jalr	1016(ra) # 7ff0 <printf>
    exit(1);
    4c00:	4505                	li	a0,1
    4c02:	00003097          	auipc	ra,0x3
    4c06:	eca080e7          	jalr	-310(ra) # 7acc <exit>
  }
  fd = open("dirfile/xx", 0);
    4c0a:	4581                	li	a1,0
    4c0c:	00005517          	auipc	a0,0x5
    4c10:	fa450513          	addi	a0,a0,-92 # 9bb0 <malloc+0x19cc>
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
    4c34:	f9050513          	addi	a0,a0,-112 # 9bc0 <malloc+0x19dc>
    4c38:	00003097          	auipc	ra,0x3
    4c3c:	3b8080e7          	jalr	952(ra) # 7ff0 <printf>
    exit(1);
    4c40:	4505                	li	a0,1
    4c42:	00003097          	auipc	ra,0x3
    4c46:	e8a080e7          	jalr	-374(ra) # 7acc <exit>
  }
  fd = open("dirfile/xx", O_CREATE);
    4c4a:	20000593          	li	a1,512
    4c4e:	00005517          	auipc	a0,0x5
    4c52:	f6250513          	addi	a0,a0,-158 # 9bb0 <malloc+0x19cc>
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
    4c76:	f4e50513          	addi	a0,a0,-178 # 9bc0 <malloc+0x19dc>
    4c7a:	00003097          	auipc	ra,0x3
    4c7e:	376080e7          	jalr	886(ra) # 7ff0 <printf>
    exit(1);
    4c82:	4505                	li	a0,1
    4c84:	00003097          	auipc	ra,0x3
    4c88:	e48080e7          	jalr	-440(ra) # 7acc <exit>
  }
  if(mkdir("dirfile/xx") == 0){
    4c8c:	00005517          	auipc	a0,0x5
    4c90:	f2450513          	addi	a0,a0,-220 # 9bb0 <malloc+0x19cc>
    4c94:	00003097          	auipc	ra,0x3
    4c98:	ea0080e7          	jalr	-352(ra) # 7b34 <mkdir>
    4c9c:	87aa                	mv	a5,a0
    4c9e:	e385                	bnez	a5,4cbe <dirfile+0x142>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    4ca0:	fd843583          	ld	a1,-40(s0)
    4ca4:	00005517          	auipc	a0,0x5
    4ca8:	f4450513          	addi	a0,a0,-188 # 9be8 <malloc+0x1a04>
    4cac:	00003097          	auipc	ra,0x3
    4cb0:	344080e7          	jalr	836(ra) # 7ff0 <printf>
    exit(1);
    4cb4:	4505                	li	a0,1
    4cb6:	00003097          	auipc	ra,0x3
    4cba:	e16080e7          	jalr	-490(ra) # 7acc <exit>
  }
  if(unlink("dirfile/xx") == 0){
    4cbe:	00005517          	auipc	a0,0x5
    4cc2:	ef250513          	addi	a0,a0,-270 # 9bb0 <malloc+0x19cc>
    4cc6:	00003097          	auipc	ra,0x3
    4cca:	e56080e7          	jalr	-426(ra) # 7b1c <unlink>
    4cce:	87aa                	mv	a5,a0
    4cd0:	e385                	bnez	a5,4cf0 <dirfile+0x174>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    4cd2:	fd843583          	ld	a1,-40(s0)
    4cd6:	00005517          	auipc	a0,0x5
    4cda:	f3a50513          	addi	a0,a0,-198 # 9c10 <malloc+0x1a2c>
    4cde:	00003097          	auipc	ra,0x3
    4ce2:	312080e7          	jalr	786(ra) # 7ff0 <printf>
    exit(1);
    4ce6:	4505                	li	a0,1
    4ce8:	00003097          	auipc	ra,0x3
    4cec:	de4080e7          	jalr	-540(ra) # 7acc <exit>
  }
  if(link("README", "dirfile/xx") == 0){
    4cf0:	00005597          	auipc	a1,0x5
    4cf4:	ec058593          	addi	a1,a1,-320 # 9bb0 <malloc+0x19cc>
    4cf8:	00003517          	auipc	a0,0x3
    4cfc:	6e850513          	addi	a0,a0,1768 # 83e0 <malloc+0x1fc>
    4d00:	00003097          	auipc	ra,0x3
    4d04:	e2c080e7          	jalr	-468(ra) # 7b2c <link>
    4d08:	87aa                	mv	a5,a0
    4d0a:	e385                	bnez	a5,4d2a <dirfile+0x1ae>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    4d0c:	fd843583          	ld	a1,-40(s0)
    4d10:	00005517          	auipc	a0,0x5
    4d14:	f2850513          	addi	a0,a0,-216 # 9c38 <malloc+0x1a54>
    4d18:	00003097          	auipc	ra,0x3
    4d1c:	2d8080e7          	jalr	728(ra) # 7ff0 <printf>
    exit(1);
    4d20:	4505                	li	a0,1
    4d22:	00003097          	auipc	ra,0x3
    4d26:	daa080e7          	jalr	-598(ra) # 7acc <exit>
  }
  if(unlink("dirfile") != 0){
    4d2a:	00005517          	auipc	a0,0x5
    4d2e:	e3e50513          	addi	a0,a0,-450 # 9b68 <malloc+0x1984>
    4d32:	00003097          	auipc	ra,0x3
    4d36:	dea080e7          	jalr	-534(ra) # 7b1c <unlink>
    4d3a:	87aa                	mv	a5,a0
    4d3c:	c385                	beqz	a5,4d5c <dirfile+0x1e0>
    printf("%s: unlink dirfile failed!\n", s);
    4d3e:	fd843583          	ld	a1,-40(s0)
    4d42:	00005517          	auipc	a0,0x5
    4d46:	f1e50513          	addi	a0,a0,-226 # 9c60 <malloc+0x1a7c>
    4d4a:	00003097          	auipc	ra,0x3
    4d4e:	2a6080e7          	jalr	678(ra) # 7ff0 <printf>
    exit(1);
    4d52:	4505                	li	a0,1
    4d54:	00003097          	auipc	ra,0x3
    4d58:	d78080e7          	jalr	-648(ra) # 7acc <exit>
  }

  fd = open(".", O_RDWR);
    4d5c:	4589                	li	a1,2
    4d5e:	00004517          	auipc	a0,0x4
    4d62:	38a50513          	addi	a0,a0,906 # 90e8 <malloc+0xf04>
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
    4d86:	efe50513          	addi	a0,a0,-258 # 9c80 <malloc+0x1a9c>
    4d8a:	00003097          	auipc	ra,0x3
    4d8e:	266080e7          	jalr	614(ra) # 7ff0 <printf>
    exit(1);
    4d92:	4505                	li	a0,1
    4d94:	00003097          	auipc	ra,0x3
    4d98:	d38080e7          	jalr	-712(ra) # 7acc <exit>
  }
  fd = open(".", 0);
    4d9c:	4581                	li	a1,0
    4d9e:	00004517          	auipc	a0,0x4
    4da2:	34a50513          	addi	a0,a0,842 # 90e8 <malloc+0xf04>
    4da6:	00003097          	auipc	ra,0x3
    4daa:	d66080e7          	jalr	-666(ra) # 7b0c <open>
    4dae:	87aa                	mv	a5,a0
    4db0:	fef42623          	sw	a5,-20(s0)
  if(write(fd, "x", 1) > 0){
    4db4:	fec42783          	lw	a5,-20(s0)
    4db8:	4605                	li	a2,1
    4dba:	00003597          	auipc	a1,0x3
    4dbe:	67658593          	addi	a1,a1,1654 # 8430 <malloc+0x24c>
    4dc2:	853e                	mv	a0,a5
    4dc4:	00003097          	auipc	ra,0x3
    4dc8:	d28080e7          	jalr	-728(ra) # 7aec <write>
    4dcc:	87aa                	mv	a5,a0
    4dce:	02f05163          	blez	a5,4df0 <dirfile+0x274>
    printf("%s: write . succeeded!\n", s);
    4dd2:	fd843583          	ld	a1,-40(s0)
    4dd6:	00005517          	auipc	a0,0x5
    4dda:	ed250513          	addi	a0,a0,-302 # 9ca8 <malloc+0x1ac4>
    4dde:	00003097          	auipc	ra,0x3
    4de2:	212080e7          	jalr	530(ra) # 7ff0 <printf>
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
    4e1e:	ea650513          	addi	a0,a0,-346 # 9cc0 <malloc+0x1adc>
    4e22:	00003097          	auipc	ra,0x3
    4e26:	d12080e7          	jalr	-750(ra) # 7b34 <mkdir>
    4e2a:	87aa                	mv	a5,a0
    4e2c:	c385                	beqz	a5,4e4c <iref+0x44>
      printf("%s: mkdir irefd failed\n", s);
    4e2e:	fd843583          	ld	a1,-40(s0)
    4e32:	00005517          	auipc	a0,0x5
    4e36:	e9650513          	addi	a0,a0,-362 # 9cc8 <malloc+0x1ae4>
    4e3a:	00003097          	auipc	ra,0x3
    4e3e:	1b6080e7          	jalr	438(ra) # 7ff0 <printf>
      exit(1);
    4e42:	4505                	li	a0,1
    4e44:	00003097          	auipc	ra,0x3
    4e48:	c88080e7          	jalr	-888(ra) # 7acc <exit>
    }
    if(chdir("irefd") != 0){
    4e4c:	00005517          	auipc	a0,0x5
    4e50:	e7450513          	addi	a0,a0,-396 # 9cc0 <malloc+0x1adc>
    4e54:	00003097          	auipc	ra,0x3
    4e58:	ce8080e7          	jalr	-792(ra) # 7b3c <chdir>
    4e5c:	87aa                	mv	a5,a0
    4e5e:	c385                	beqz	a5,4e7e <iref+0x76>
      printf("%s: chdir irefd failed\n", s);
    4e60:	fd843583          	ld	a1,-40(s0)
    4e64:	00005517          	auipc	a0,0x5
    4e68:	e7c50513          	addi	a0,a0,-388 # 9ce0 <malloc+0x1afc>
    4e6c:	00003097          	auipc	ra,0x3
    4e70:	184080e7          	jalr	388(ra) # 7ff0 <printf>
      exit(1);
    4e74:	4505                	li	a0,1
    4e76:	00003097          	auipc	ra,0x3
    4e7a:	c56080e7          	jalr	-938(ra) # 7acc <exit>
    }

    mkdir("");
    4e7e:	00005517          	auipc	a0,0x5
    4e82:	e7a50513          	addi	a0,a0,-390 # 9cf8 <malloc+0x1b14>
    4e86:	00003097          	auipc	ra,0x3
    4e8a:	cae080e7          	jalr	-850(ra) # 7b34 <mkdir>
    link("README", "");
    4e8e:	00005597          	auipc	a1,0x5
    4e92:	e6a58593          	addi	a1,a1,-406 # 9cf8 <malloc+0x1b14>
    4e96:	00003517          	auipc	a0,0x3
    4e9a:	54a50513          	addi	a0,a0,1354 # 83e0 <malloc+0x1fc>
    4e9e:	00003097          	auipc	ra,0x3
    4ea2:	c8e080e7          	jalr	-882(ra) # 7b2c <link>
    fd = open("", O_CREATE);
    4ea6:	20000593          	li	a1,512
    4eaa:	00005517          	auipc	a0,0x5
    4eae:	e4e50513          	addi	a0,a0,-434 # 9cf8 <malloc+0x1b14>
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
    4ee0:	62c50513          	addi	a0,a0,1580 # 8508 <malloc+0x324>
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
    4f0e:	5fe50513          	addi	a0,a0,1534 # 8508 <malloc+0x324>
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
    4f3e:	c0650513          	addi	a0,a0,-1018 # 8b40 <malloc+0x95c>
    4f42:	00003097          	auipc	ra,0x3
    4f46:	bfa080e7          	jalr	-1030(ra) # 7b3c <chdir>
    unlink("irefd");
    4f4a:	00005517          	auipc	a0,0x5
    4f4e:	d7650513          	addi	a0,a0,-650 # 9cc0 <malloc+0x1adc>
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
    4f78:	8e450513          	addi	a0,a0,-1820 # 8858 <malloc+0x674>
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
    4ff8:	d0c50513          	addi	a0,a0,-756 # 9d00 <malloc+0x1b1c>
    4ffc:	00003097          	auipc	ra,0x3
    5000:	ff4080e7          	jalr	-12(ra) # 7ff0 <printf>
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
    5026:	cf650513          	addi	a0,a0,-778 # 9d18 <malloc+0x1b34>
    502a:	00003097          	auipc	ra,0x3
    502e:	fc6080e7          	jalr	-58(ra) # 7ff0 <printf>
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
    5054:	cf050513          	addi	a0,a0,-784 # 9d40 <malloc+0x1b5c>
    5058:	00003097          	auipc	ra,0x3
    505c:	f98080e7          	jalr	-104(ra) # 7ff0 <printf>
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
    509a:	cc250513          	addi	a0,a0,-830 # 9d58 <malloc+0x1b74>
    509e:	00003097          	auipc	ra,0x3
    50a2:	f52080e7          	jalr	-174(ra) # 7ff0 <printf>
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
    50e2:	c9250513          	addi	a0,a0,-878 # 9d70 <malloc+0x1b8c>
    50e6:	00003097          	auipc	ra,0x3
    50ea:	f0a080e7          	jalr	-246(ra) # 7ff0 <printf>
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
    5182:	c1250513          	addi	a0,a0,-1006 # 9d90 <malloc+0x1bac>
    5186:	00003097          	auipc	ra,0x3
    518a:	e6a080e7          	jalr	-406(ra) # 7ff0 <printf>
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
    51dc:	bd850513          	addi	a0,a0,-1064 # 9db0 <malloc+0x1bcc>
    51e0:	00003097          	auipc	ra,0x3
    51e4:	e10080e7          	jalr	-496(ra) # 7ff0 <printf>
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
    5242:	b9250513          	addi	a0,a0,-1134 # 9dd0 <malloc+0x1bec>
    5246:	00003097          	auipc	ra,0x3
    524a:	daa080e7          	jalr	-598(ra) # 7ff0 <printf>
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
    528a:	b6a50513          	addi	a0,a0,-1174 # 9df0 <malloc+0x1c0c>
    528e:	00003097          	auipc	ra,0x3
    5292:	d62080e7          	jalr	-670(ra) # 7ff0 <printf>
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
    532e:	ae650513          	addi	a0,a0,-1306 # 9e10 <malloc+0x1c2c>
    5332:	00003097          	auipc	ra,0x3
    5336:	cbe080e7          	jalr	-834(ra) # 7ff0 <printf>
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
    53c2:	a9a50513          	addi	a0,a0,-1382 # 9e58 <malloc+0x1c74>
    53c6:	00003097          	auipc	ra,0x3
    53ca:	c2a080e7          	jalr	-982(ra) # 7ff0 <printf>
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
    5406:	a7650513          	addi	a0,a0,-1418 # 9e78 <malloc+0x1c94>
    540a:	00003097          	auipc	ra,0x3
    540e:	be6080e7          	jalr	-1050(ra) # 7ff0 <printf>
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
    546c:	a5050513          	addi	a0,a0,-1456 # 9eb8 <malloc+0x1cd4>
    5470:	00003097          	auipc	ra,0x3
    5474:	b80080e7          	jalr	-1152(ra) # 7ff0 <printf>
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
    549c:	a5050513          	addi	a0,a0,-1456 # 9ee8 <malloc+0x1d04>
    54a0:	00003097          	auipc	ra,0x3
    54a4:	b50080e7          	jalr	-1200(ra) # 7ff0 <printf>
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
    54fe:	a2650513          	addi	a0,a0,-1498 # 9f20 <malloc+0x1d3c>
    5502:	00003097          	auipc	ra,0x3
    5506:	aee080e7          	jalr	-1298(ra) # 7ff0 <printf>
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
    5554:	21050513          	addi	a0,a0,528 # 8760 <malloc+0x57c>
    5558:	00003097          	auipc	ra,0x3
    555c:	a98080e7          	jalr	-1384(ra) # 7ff0 <printf>
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
    558a:	9c250513          	addi	a0,a0,-1598 # 9f48 <malloc+0x1d64>
    558e:	00003097          	auipc	ra,0x3
    5592:	a62080e7          	jalr	-1438(ra) # 7ff0 <printf>
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
    5626:	13e50513          	addi	a0,a0,318 # 8760 <malloc+0x57c>
    562a:	00003097          	auipc	ra,0x3
    562e:	9c6080e7          	jalr	-1594(ra) # 7ff0 <printf>
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
    5660:	90c50513          	addi	a0,a0,-1780 # 9f68 <malloc+0x1d84>
    5664:	00003097          	auipc	ra,0x3
    5668:	98c080e7          	jalr	-1652(ra) # 7ff0 <printf>
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
    56da:	52250513          	addi	a0,a0,1314 # 8bf8 <malloc+0xa14>
    56de:	00003097          	auipc	ra,0x3
    56e2:	912080e7          	jalr	-1774(ra) # 7ff0 <printf>
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
    574c:	ce858593          	addi	a1,a1,-792 # 8430 <malloc+0x24c>
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
    581a:	76a50513          	addi	a0,a0,1898 # 9f80 <malloc+0x1d9c>
    581e:	00002097          	auipc	ra,0x2
    5822:	7d2080e7          	jalr	2002(ra) # 7ff0 <printf>
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
    5850:	f1450513          	addi	a0,a0,-236 # 8760 <malloc+0x57c>
    5854:	00002097          	auipc	ra,0x2
    5858:	79c080e7          	jalr	1948(ra) # 7ff0 <printf>
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
    58d8:	6cc50513          	addi	a0,a0,1740 # 9fa0 <malloc+0x1dbc>
    58dc:	00002097          	auipc	ra,0x2
    58e0:	714080e7          	jalr	1812(ra) # 7ff0 <printf>
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
    5946:	68e50513          	addi	a0,a0,1678 # 9fd0 <malloc+0x1dec>
    594a:	00002097          	auipc	ra,0x2
    594e:	1c2080e7          	jalr	450(ra) # 7b0c <open>
    5952:	87aa                	mv	a5,a0
    5954:	fef42223          	sw	a5,-28(s0)
  unlink("sbrk");
    5958:	00004517          	auipc	a0,0x4
    595c:	67850513          	addi	a0,a0,1656 # 9fd0 <malloc+0x1dec>
    5960:	00002097          	auipc	ra,0x2
    5964:	1bc080e7          	jalr	444(ra) # 7b1c <unlink>
  if(fd < 0)  {
    5968:	fe442783          	lw	a5,-28(s0)
    596c:	2781                	sext.w	a5,a5
    596e:	0207d163          	bgez	a5,5990 <sbrkarg+0x6c>
    printf("%s: open sbrk failed\n", s);
    5972:	fd843583          	ld	a1,-40(s0)
    5976:	00004517          	auipc	a0,0x4
    597a:	66250513          	addi	a0,a0,1634 # 9fd8 <malloc+0x1df4>
    597e:	00002097          	auipc	ra,0x2
    5982:	672080e7          	jalr	1650(ra) # 7ff0 <printf>
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
    59bc:	63850513          	addi	a0,a0,1592 # 9ff0 <malloc+0x1e0c>
    59c0:	00002097          	auipc	ra,0x2
    59c4:	630080e7          	jalr	1584(ra) # 7ff0 <printf>
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
    5a06:	1f650513          	addi	a0,a0,502 # 8bf8 <malloc+0xa14>
    5a0a:	00002097          	auipc	ra,0x2
    5a0e:	5e6080e7          	jalr	1510(ra) # 7ff0 <printf>
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
    5a4a:	5c250513          	addi	a0,a0,1474 # a008 <malloc+0x1e24>
    5a4e:	00002097          	auipc	ra,0x2
    5a52:	0de080e7          	jalr	222(ra) # 7b2c <link>
    5a56:	87aa                	mv	a5,a0
    5a58:	873e                	mv	a4,a5
    5a5a:	57fd                	li	a5,-1
    5a5c:	02f70163          	beq	a4,a5,5a7e <validatetest+0x58>
      printf("%s: link should not succeed\n", s);
    5a60:	fd843583          	ld	a1,-40(s0)
    5a64:	00004517          	auipc	a0,0x4
    5a68:	5b450513          	addi	a0,a0,1460 # a018 <malloc+0x1e34>
    5a6c:	00002097          	auipc	ra,0x2
    5a70:	584080e7          	jalr	1412(ra) # 7ff0 <printf>
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
    5ad4:	56850513          	addi	a0,a0,1384 # a038 <malloc+0x1e54>
    5ad8:	00002097          	auipc	ra,0x2
    5adc:	518080e7          	jalr	1304(ra) # 7ff0 <printf>
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
    5b1e:	53650513          	addi	a0,a0,1334 # a050 <malloc+0x1e6c>
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
    5b5a:	50a70713          	addi	a4,a4,1290 # a060 <malloc+0x1e7c>
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
    5b90:	9b450513          	addi	a0,a0,-1612 # 8540 <malloc+0x35c>
    5b94:	00002097          	auipc	ra,0x2
    5b98:	f70080e7          	jalr	-144(ra) # 7b04 <exec>
    fd = open("bigarg-ok", O_CREATE);
    5b9c:	20000593          	li	a1,512
    5ba0:	00004517          	auipc	a0,0x4
    5ba4:	4b050513          	addi	a0,a0,1200 # a050 <malloc+0x1e6c>
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
    5be0:	56450513          	addi	a0,a0,1380 # a140 <malloc+0x1f5c>
    5be4:	00002097          	auipc	ra,0x2
    5be8:	40c080e7          	jalr	1036(ra) # 7ff0 <printf>
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
    5c1e:	43650513          	addi	a0,a0,1078 # a050 <malloc+0x1e6c>
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
    5c42:	52250513          	addi	a0,a0,1314 # a160 <malloc+0x1f7c>
    5c46:	00002097          	auipc	ra,0x2
    5c4a:	3aa080e7          	jalr	938(ra) # 7ff0 <printf>
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
    5c80:	50450513          	addi	a0,a0,1284 # a180 <malloc+0x1f9c>
    5c84:	00002097          	auipc	ra,0x2
    5c88:	36c080e7          	jalr	876(ra) # 7ff0 <printf>

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
    5df4:	3a050513          	addi	a0,a0,928 # a190 <malloc+0x1fac>
    5df8:	00002097          	auipc	ra,0x2
    5dfc:	1f8080e7          	jalr	504(ra) # 7ff0 <printf>
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
    5e2c:	37850513          	addi	a0,a0,888 # a1a0 <malloc+0x1fbc>
    5e30:	00002097          	auipc	ra,0x2
    5e34:	1c0080e7          	jalr	448(ra) # 7ff0 <printf>
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
    5e96:	31e50513          	addi	a0,a0,798 # a1b0 <malloc+0x1fcc>
    5e9a:	00002097          	auipc	ra,0x2
    5e9e:	156080e7          	jalr	342(ra) # 7ff0 <printf>
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
    6048:	17c50513          	addi	a0,a0,380 # a1c0 <malloc+0x1fdc>
    604c:	00002097          	auipc	ra,0x2
    6050:	fa4080e7          	jalr	-92(ra) # 7ff0 <printf>
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
    6070:	16c50513          	addi	a0,a0,364 # a1d8 <malloc+0x1ff4>
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
    6094:	6e850513          	addi	a0,a0,1768 # 8778 <malloc+0x594>
    6098:	00002097          	auipc	ra,0x2
    609c:	f58080e7          	jalr	-168(ra) # 7ff0 <printf>
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
    6134:	0b050513          	addi	a0,a0,176 # a1e0 <malloc+0x1ffc>
    6138:	00002097          	auipc	ra,0x2
    613c:	eb8080e7          	jalr	-328(ra) # 7ff0 <printf>
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
    615c:	60850513          	addi	a0,a0,1544 # 8760 <malloc+0x57c>
    6160:	00002097          	auipc	ra,0x2
    6164:	e90080e7          	jalr	-368(ra) # 7ff0 <printf>
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
    61ec:	57850513          	addi	a0,a0,1400 # 8760 <malloc+0x57c>
    61f0:	00002097          	auipc	ra,0x2
    61f4:	e00080e7          	jalr	-512(ra) # 7ff0 <printf>
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
    62a2:	29250513          	addi	a0,a0,658 # 8530 <malloc+0x34c>
    62a6:	00002097          	auipc	ra,0x2
    62aa:	d4a080e7          	jalr	-694(ra) # 7ff0 <printf>
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
    6314:	22050513          	addi	a0,a0,544 # 8530 <malloc+0x34c>
    6318:	00002097          	auipc	ra,0x2
    631c:	cd8080e7          	jalr	-808(ra) # 7ff0 <printf>
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
    638a:	1aa50513          	addi	a0,a0,426 # 8530 <malloc+0x34c>
    638e:	00002097          	auipc	ra,0x2
    6392:	c62080e7          	jalr	-926(ra) # 7ff0 <printf>
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
    63b8:	8007071b          	addiw	a4,a4,-2048 # a800 <malloc+0x261c>
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
    6596:	fae50513          	addi	a0,a0,-82 # 8540 <malloc+0x35c>
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
    65d8:	f2450513          	addi	a0,a0,-220 # a4f8 <malloc+0x2314>
    65dc:	00001097          	auipc	ra,0x1
    65e0:	540080e7          	jalr	1344(ra) # 7b1c <unlink>

  fd = open("bd", O_CREATE);
    65e4:	20000593          	li	a1,512
    65e8:	00004517          	auipc	a0,0x4
    65ec:	f1050513          	addi	a0,a0,-240 # a4f8 <malloc+0x2314>
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
    6610:	ef450513          	addi	a0,a0,-268 # a500 <malloc+0x231c>
    6614:	00002097          	auipc	ra,0x2
    6618:	9dc080e7          	jalr	-1572(ra) # 7ff0 <printf>
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
    669e:	e5e50513          	addi	a0,a0,-418 # a4f8 <malloc+0x2314>
    66a2:	00001097          	auipc	ra,0x1
    66a6:	48a080e7          	jalr	1162(ra) # 7b2c <link>
    66aa:	87aa                	mv	a5,a0
    66ac:	c39d                	beqz	a5,66d2 <bigdir+0x10a>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    66ae:	fd840793          	addi	a5,s0,-40
    66b2:	863e                	mv	a2,a5
    66b4:	fc843583          	ld	a1,-56(s0)
    66b8:	00004517          	auipc	a0,0x4
    66bc:	e6850513          	addi	a0,a0,-408 # a520 <malloc+0x233c>
    66c0:	00002097          	auipc	ra,0x2
    66c4:	930080e7          	jalr	-1744(ra) # 7ff0 <printf>
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
    66f0:	e0c50513          	addi	a0,a0,-500 # a4f8 <malloc+0x2314>
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
    6776:	dce50513          	addi	a0,a0,-562 # a540 <malloc+0x235c>
    677a:	00002097          	auipc	ra,0x2
    677e:	876080e7          	jalr	-1930(ra) # 7ff0 <printf>
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
    67ec:	d4850513          	addi	a0,a0,-696 # 8530 <malloc+0x34c>
    67f0:	00002097          	auipc	ra,0x2
    67f4:	800080e7          	jalr	-2048(ra) # 7ff0 <printf>
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
    6876:	cee50513          	addi	a0,a0,-786 # a560 <malloc+0x237c>
    687a:	00001097          	auipc	ra,0x1
    687e:	776080e7          	jalr	1910(ra) # 7ff0 <printf>
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
    68da:	e9250513          	addi	a0,a0,-366 # 9768 <malloc+0x1584>
    68de:	00001097          	auipc	ra,0x1
    68e2:	712080e7          	jalr	1810(ra) # 7ff0 <printf>
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
    69e2:	b9a50513          	addi	a0,a0,-1126 # a578 <malloc+0x2394>
    69e6:	00001097          	auipc	ra,0x1
    69ea:	136080e7          	jalr	310(ra) # 7b1c <unlink>
  for(int i = 0; i < assumed_free; i++){
    69ee:	fe042623          	sw	zero,-20(s0)
    69f2:	a8bd                	j	6a70 <badwrite+0xa6>
    int fd = open("junk", O_CREATE|O_WRONLY);
    69f4:	20100593          	li	a1,513
    69f8:	00004517          	auipc	a0,0x4
    69fc:	b8050513          	addi	a0,a0,-1152 # a578 <malloc+0x2394>
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
    6a1c:	b6850513          	addi	a0,a0,-1176 # a580 <malloc+0x239c>
    6a20:	00001097          	auipc	ra,0x1
    6a24:	5d0080e7          	jalr	1488(ra) # 7ff0 <printf>
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
    6a5a:	b2250513          	addi	a0,a0,-1246 # a578 <malloc+0x2394>
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
    6a8a:	af250513          	addi	a0,a0,-1294 # a578 <malloc+0x2394>
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
    6aaa:	ada50513          	addi	a0,a0,-1318 # a580 <malloc+0x239c>
    6aae:	00001097          	auipc	ra,0x1
    6ab2:	542080e7          	jalr	1346(ra) # 7ff0 <printf>
    exit(1);
    6ab6:	4505                	li	a0,1
    6ab8:	00001097          	auipc	ra,0x1
    6abc:	014080e7          	jalr	20(ra) # 7acc <exit>
  }
  if(write(fd, "x", 1) != 1){
    6ac0:	fe442783          	lw	a5,-28(s0)
    6ac4:	4605                	li	a2,1
    6ac6:	00002597          	auipc	a1,0x2
    6aca:	96a58593          	addi	a1,a1,-1686 # 8430 <malloc+0x24c>
    6ace:	853e                	mv	a0,a5
    6ad0:	00001097          	auipc	ra,0x1
    6ad4:	01c080e7          	jalr	28(ra) # 7aec <write>
    6ad8:	87aa                	mv	a5,a0
    6ada:	873e                	mv	a4,a5
    6adc:	4785                	li	a5,1
    6ade:	00f70f63          	beq	a4,a5,6afc <badwrite+0x132>
    printf("write failed\n");
    6ae2:	00004517          	auipc	a0,0x4
    6ae6:	ab650513          	addi	a0,a0,-1354 # a598 <malloc+0x23b4>
    6aea:	00001097          	auipc	ra,0x1
    6aee:	506080e7          	jalr	1286(ra) # 7ff0 <printf>
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
    6b0e:	a6e50513          	addi	a0,a0,-1426 # a578 <malloc+0x2394>
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
    6b52:	9e250513          	addi	a0,a0,-1566 # 8530 <malloc+0x34c>
    6b56:	00001097          	auipc	ra,0x1
    6b5a:	49a080e7          	jalr	1178(ra) # 7ff0 <printf>
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
    6bda:	96a78793          	addi	a5,a5,-1686 # 8540 <malloc+0x35c>
    6bde:	fcf43023          	sd	a5,-64(s0)
    6be2:	00002797          	auipc	a5,0x2
    6be6:	84e78793          	addi	a5,a5,-1970 # 8430 <malloc+0x24c>
    6bea:	fcf43423          	sd	a5,-56(s0)
    6bee:	fc043823          	sd	zero,-48(s0)
      exec("echo", args);
    6bf2:	fc040793          	addi	a5,s0,-64
    6bf6:	85be                	mv	a1,a5
    6bf8:	00002517          	auipc	a0,0x2
    6bfc:	94850513          	addi	a0,a0,-1720 # 8540 <malloc+0x35c>
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
    6c5a:	95250513          	addi	a0,a0,-1710 # a5a8 <malloc+0x23c4>
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
    6cda:	8e250513          	addi	a0,a0,-1822 # a5b8 <malloc+0x23d4>
    6cde:	00001097          	auipc	ra,0x1
    6ce2:	312080e7          	jalr	786(ra) # 7ff0 <printf>
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
    6e34:	77850513          	addi	a0,a0,1912 # a5a8 <malloc+0x23c4>
    6e38:	00001097          	auipc	ra,0x1
    6e3c:	cfc080e7          	jalr	-772(ra) # 7b34 <mkdir>
    6e40:	87aa                	mv	a5,a0
    6e42:	eb89                	bnez	a5,6e54 <diskfull+0x216>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n");
    6e44:	00003517          	auipc	a0,0x3
    6e48:	79450513          	addi	a0,a0,1940 # a5d8 <malloc+0x23f4>
    6e4c:	00001097          	auipc	ra,0x1
    6e50:	1a4080e7          	jalr	420(ra) # 7ff0 <printf>

  unlink("diskfulldir");
    6e54:	00003517          	auipc	a0,0x3
    6e58:	75450513          	addi	a0,a0,1876 # a5a8 <malloc+0x23c4>
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
    70f2:	56a50513          	addi	a0,a0,1386 # a658 <malloc+0x2474>
    70f6:	00001097          	auipc	ra,0x1
    70fa:	efa080e7          	jalr	-262(ra) # 7ff0 <printf>
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
    711a:	55250513          	addi	a0,a0,1362 # a668 <malloc+0x2484>
    711e:	00001097          	auipc	ra,0x1
    7122:	ed2080e7          	jalr	-302(ra) # 7ff0 <printf>
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
    7164:	52050513          	addi	a0,a0,1312 # a680 <malloc+0x249c>
    7168:	00001097          	auipc	ra,0x1
    716c:	e88080e7          	jalr	-376(ra) # 7ff0 <printf>
    7170:	a809                	j	7182 <run+0xa8>
    else
      printf("OK\n");
    7172:	00003517          	auipc	a0,0x3
    7176:	51650513          	addi	a0,a0,1302 # a688 <malloc+0x24a4>
    717a:	00001097          	auipc	ra,0x1
    717e:	e76080e7          	jalr	-394(ra) # 7ff0 <printf>
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
    71f2:	4a250513          	addi	a0,a0,1186 # a690 <malloc+0x24ac>
    71f6:	00001097          	auipc	ra,0x1
    71fa:	dfa080e7          	jalr	-518(ra) # 7ff0 <printf>
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
    7240:	46c50513          	addi	a0,a0,1132 # a6a8 <malloc+0x24c4>
    7244:	00001097          	auipc	ra,0x1
    7248:	dac080e7          	jalr	-596(ra) # 7ff0 <printf>
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
    7272:	45a50513          	addi	a0,a0,1114 # a6c8 <malloc+0x24e4>
    7276:	00001097          	auipc	ra,0x1
    727a:	d7a080e7          	jalr	-646(ra) # 7ff0 <printf>
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
    72d4:	16058593          	addi	a1,a1,352 # 8430 <malloc+0x24c>
    72d8:	853e                	mv	a0,a5
    72da:	00001097          	auipc	ra,0x1
    72de:	812080e7          	jalr	-2030(ra) # 7aec <write>
    72e2:	87aa                	mv	a5,a0
    72e4:	873e                	mv	a4,a5
    72e6:	4785                	li	a5,1
    72e8:	faf70be3          	beq	a4,a5,729e <countfree+0x7e>
        printf("write() failed in countfree()\n");
    72ec:	00003517          	auipc	a0,0x3
    72f0:	3fc50513          	addi	a0,a0,1020 # a6e8 <malloc+0x2504>
    72f4:	00001097          	auipc	ra,0x1
    72f8:	cfc080e7          	jalr	-772(ra) # 7ff0 <printf>
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
    734e:	3be50513          	addi	a0,a0,958 # a708 <malloc+0x2524>
    7352:	00001097          	auipc	ra,0x1
    7356:	c9e080e7          	jalr	-866(ra) # 7ff0 <printf>
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
    73be:	36e50513          	addi	a0,a0,878 # a728 <malloc+0x2544>
    73c2:	00001097          	auipc	ra,0x1
    73c6:	c2e080e7          	jalr	-978(ra) # 7ff0 <printf>
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
    7418:	32c50513          	addi	a0,a0,812 # a740 <malloc+0x255c>
    741c:	00001097          	auipc	ra,0x1
    7420:	bd4080e7          	jalr	-1068(ra) # 7ff0 <printf>
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
    747e:	2e650513          	addi	a0,a0,742 # a760 <malloc+0x257c>
    7482:	00001097          	auipc	ra,0x1
    7486:	b6e080e7          	jalr	-1170(ra) # 7ff0 <printf>
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
    74e8:	2ac58593          	addi	a1,a1,684 # a790 <malloc+0x25ac>
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
    751c:	28058593          	addi	a1,a1,640 # a798 <malloc+0x25b4>
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
    7550:	25458593          	addi	a1,a1,596 # a7a0 <malloc+0x25bc>
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
    75ac:	20050513          	addi	a0,a0,512 # a7a8 <malloc+0x25c4>
    75b0:	00001097          	auipc	ra,0x1
    75b4:	a40080e7          	jalr	-1472(ra) # 7ff0 <printf>
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
    75ec:	1f050513          	addi	a0,a0,496 # a7d8 <malloc+0x25f4>
    75f0:	00001097          	auipc	ra,0x1
    75f4:	a00080e7          	jalr	-1536(ra) # 7ff0 <printf>
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

0000000000007b6c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    7b6c:	1101                	addi	sp,sp,-32
    7b6e:	ec06                	sd	ra,24(sp)
    7b70:	e822                	sd	s0,16(sp)
    7b72:	1000                	addi	s0,sp,32
    7b74:	87aa                	mv	a5,a0
    7b76:	872e                	mv	a4,a1
    7b78:	fef42623          	sw	a5,-20(s0)
    7b7c:	87ba                	mv	a5,a4
    7b7e:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
    7b82:	feb40713          	addi	a4,s0,-21
    7b86:	fec42783          	lw	a5,-20(s0)
    7b8a:	4605                	li	a2,1
    7b8c:	85ba                	mv	a1,a4
    7b8e:	853e                	mv	a0,a5
    7b90:	00000097          	auipc	ra,0x0
    7b94:	f5c080e7          	jalr	-164(ra) # 7aec <write>
}
    7b98:	0001                	nop
    7b9a:	60e2                	ld	ra,24(sp)
    7b9c:	6442                	ld	s0,16(sp)
    7b9e:	6105                	addi	sp,sp,32
    7ba0:	8082                	ret

0000000000007ba2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    7ba2:	7139                	addi	sp,sp,-64
    7ba4:	fc06                	sd	ra,56(sp)
    7ba6:	f822                	sd	s0,48(sp)
    7ba8:	0080                	addi	s0,sp,64
    7baa:	87aa                	mv	a5,a0
    7bac:	8736                	mv	a4,a3
    7bae:	fcf42623          	sw	a5,-52(s0)
    7bb2:	87ae                	mv	a5,a1
    7bb4:	fcf42423          	sw	a5,-56(s0)
    7bb8:	87b2                	mv	a5,a2
    7bba:	fcf42223          	sw	a5,-60(s0)
    7bbe:	87ba                	mv	a5,a4
    7bc0:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    7bc4:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
    7bc8:	fc042783          	lw	a5,-64(s0)
    7bcc:	2781                	sext.w	a5,a5
    7bce:	c38d                	beqz	a5,7bf0 <printint+0x4e>
    7bd0:	fc842783          	lw	a5,-56(s0)
    7bd4:	2781                	sext.w	a5,a5
    7bd6:	0007dd63          	bgez	a5,7bf0 <printint+0x4e>
    neg = 1;
    7bda:	4785                	li	a5,1
    7bdc:	fef42423          	sw	a5,-24(s0)
    x = -xx;
    7be0:	fc842783          	lw	a5,-56(s0)
    7be4:	40f007bb          	negw	a5,a5
    7be8:	2781                	sext.w	a5,a5
    7bea:	fef42223          	sw	a5,-28(s0)
    7bee:	a029                	j	7bf8 <printint+0x56>
  } else {
    x = xx;
    7bf0:	fc842783          	lw	a5,-56(s0)
    7bf4:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
    7bf8:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
    7bfc:	fc442783          	lw	a5,-60(s0)
    7c00:	fe442703          	lw	a4,-28(s0)
    7c04:	02f777bb          	remuw	a5,a4,a5
    7c08:	0007871b          	sext.w	a4,a5
    7c0c:	fec42783          	lw	a5,-20(s0)
    7c10:	0017869b          	addiw	a3,a5,1
    7c14:	fed42623          	sw	a3,-20(s0)
    7c18:	00004697          	auipc	a3,0x4
    7c1c:	83868693          	addi	a3,a3,-1992 # b450 <digits>
    7c20:	1702                	slli	a4,a4,0x20
    7c22:	9301                	srli	a4,a4,0x20
    7c24:	9736                	add	a4,a4,a3
    7c26:	00074703          	lbu	a4,0(a4)
    7c2a:	17c1                	addi	a5,a5,-16
    7c2c:	97a2                	add	a5,a5,s0
    7c2e:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
    7c32:	fc442783          	lw	a5,-60(s0)
    7c36:	fe442703          	lw	a4,-28(s0)
    7c3a:	02f757bb          	divuw	a5,a4,a5
    7c3e:	fef42223          	sw	a5,-28(s0)
    7c42:	fe442783          	lw	a5,-28(s0)
    7c46:	2781                	sext.w	a5,a5
    7c48:	fbd5                	bnez	a5,7bfc <printint+0x5a>
  if(neg)
    7c4a:	fe842783          	lw	a5,-24(s0)
    7c4e:	2781                	sext.w	a5,a5
    7c50:	cf85                	beqz	a5,7c88 <printint+0xe6>
    buf[i++] = '-';
    7c52:	fec42783          	lw	a5,-20(s0)
    7c56:	0017871b          	addiw	a4,a5,1
    7c5a:	fee42623          	sw	a4,-20(s0)
    7c5e:	17c1                	addi	a5,a5,-16
    7c60:	97a2                	add	a5,a5,s0
    7c62:	02d00713          	li	a4,45
    7c66:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
    7c6a:	a839                	j	7c88 <printint+0xe6>
    putc(fd, buf[i]);
    7c6c:	fec42783          	lw	a5,-20(s0)
    7c70:	17c1                	addi	a5,a5,-16
    7c72:	97a2                	add	a5,a5,s0
    7c74:	fe07c703          	lbu	a4,-32(a5)
    7c78:	fcc42783          	lw	a5,-52(s0)
    7c7c:	85ba                	mv	a1,a4
    7c7e:	853e                	mv	a0,a5
    7c80:	00000097          	auipc	ra,0x0
    7c84:	eec080e7          	jalr	-276(ra) # 7b6c <putc>
  while(--i >= 0)
    7c88:	fec42783          	lw	a5,-20(s0)
    7c8c:	37fd                	addiw	a5,a5,-1
    7c8e:	fef42623          	sw	a5,-20(s0)
    7c92:	fec42783          	lw	a5,-20(s0)
    7c96:	2781                	sext.w	a5,a5
    7c98:	fc07dae3          	bgez	a5,7c6c <printint+0xca>
}
    7c9c:	0001                	nop
    7c9e:	0001                	nop
    7ca0:	70e2                	ld	ra,56(sp)
    7ca2:	7442                	ld	s0,48(sp)
    7ca4:	6121                	addi	sp,sp,64
    7ca6:	8082                	ret

0000000000007ca8 <printptr>:

static void
printptr(int fd, uint64 x) {
    7ca8:	7179                	addi	sp,sp,-48
    7caa:	f406                	sd	ra,40(sp)
    7cac:	f022                	sd	s0,32(sp)
    7cae:	1800                	addi	s0,sp,48
    7cb0:	87aa                	mv	a5,a0
    7cb2:	fcb43823          	sd	a1,-48(s0)
    7cb6:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
    7cba:	fdc42783          	lw	a5,-36(s0)
    7cbe:	03000593          	li	a1,48
    7cc2:	853e                	mv	a0,a5
    7cc4:	00000097          	auipc	ra,0x0
    7cc8:	ea8080e7          	jalr	-344(ra) # 7b6c <putc>
  putc(fd, 'x');
    7ccc:	fdc42783          	lw	a5,-36(s0)
    7cd0:	07800593          	li	a1,120
    7cd4:	853e                	mv	a0,a5
    7cd6:	00000097          	auipc	ra,0x0
    7cda:	e96080e7          	jalr	-362(ra) # 7b6c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    7cde:	fe042623          	sw	zero,-20(s0)
    7ce2:	a82d                	j	7d1c <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    7ce4:	fd043783          	ld	a5,-48(s0)
    7ce8:	93f1                	srli	a5,a5,0x3c
    7cea:	00003717          	auipc	a4,0x3
    7cee:	76670713          	addi	a4,a4,1894 # b450 <digits>
    7cf2:	97ba                	add	a5,a5,a4
    7cf4:	0007c703          	lbu	a4,0(a5)
    7cf8:	fdc42783          	lw	a5,-36(s0)
    7cfc:	85ba                	mv	a1,a4
    7cfe:	853e                	mv	a0,a5
    7d00:	00000097          	auipc	ra,0x0
    7d04:	e6c080e7          	jalr	-404(ra) # 7b6c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    7d08:	fec42783          	lw	a5,-20(s0)
    7d0c:	2785                	addiw	a5,a5,1
    7d0e:	fef42623          	sw	a5,-20(s0)
    7d12:	fd043783          	ld	a5,-48(s0)
    7d16:	0792                	slli	a5,a5,0x4
    7d18:	fcf43823          	sd	a5,-48(s0)
    7d1c:	fec42703          	lw	a4,-20(s0)
    7d20:	47bd                	li	a5,15
    7d22:	fce7f1e3          	bgeu	a5,a4,7ce4 <printptr+0x3c>
}
    7d26:	0001                	nop
    7d28:	0001                	nop
    7d2a:	70a2                	ld	ra,40(sp)
    7d2c:	7402                	ld	s0,32(sp)
    7d2e:	6145                	addi	sp,sp,48
    7d30:	8082                	ret

0000000000007d32 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    7d32:	715d                	addi	sp,sp,-80
    7d34:	e486                	sd	ra,72(sp)
    7d36:	e0a2                	sd	s0,64(sp)
    7d38:	0880                	addi	s0,sp,80
    7d3a:	87aa                	mv	a5,a0
    7d3c:	fcb43023          	sd	a1,-64(s0)
    7d40:	fac43c23          	sd	a2,-72(s0)
    7d44:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
    7d48:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
    7d4c:	fe042223          	sw	zero,-28(s0)
    7d50:	a42d                	j	7f7a <vprintf+0x248>
    c = fmt[i] & 0xff;
    7d52:	fe442783          	lw	a5,-28(s0)
    7d56:	fc043703          	ld	a4,-64(s0)
    7d5a:	97ba                	add	a5,a5,a4
    7d5c:	0007c783          	lbu	a5,0(a5)
    7d60:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
    7d64:	fe042783          	lw	a5,-32(s0)
    7d68:	2781                	sext.w	a5,a5
    7d6a:	eb9d                	bnez	a5,7da0 <vprintf+0x6e>
      if(c == '%'){
    7d6c:	fdc42783          	lw	a5,-36(s0)
    7d70:	0007871b          	sext.w	a4,a5
    7d74:	02500793          	li	a5,37
    7d78:	00f71763          	bne	a4,a5,7d86 <vprintf+0x54>
        state = '%';
    7d7c:	02500793          	li	a5,37
    7d80:	fef42023          	sw	a5,-32(s0)
    7d84:	a2f5                	j	7f70 <vprintf+0x23e>
      } else {
        putc(fd, c);
    7d86:	fdc42783          	lw	a5,-36(s0)
    7d8a:	0ff7f713          	zext.b	a4,a5
    7d8e:	fcc42783          	lw	a5,-52(s0)
    7d92:	85ba                	mv	a1,a4
    7d94:	853e                	mv	a0,a5
    7d96:	00000097          	auipc	ra,0x0
    7d9a:	dd6080e7          	jalr	-554(ra) # 7b6c <putc>
    7d9e:	aac9                	j	7f70 <vprintf+0x23e>
      }
    } else if(state == '%'){
    7da0:	fe042783          	lw	a5,-32(s0)
    7da4:	0007871b          	sext.w	a4,a5
    7da8:	02500793          	li	a5,37
    7dac:	1cf71263          	bne	a4,a5,7f70 <vprintf+0x23e>
      if(c == 'd'){
    7db0:	fdc42783          	lw	a5,-36(s0)
    7db4:	0007871b          	sext.w	a4,a5
    7db8:	06400793          	li	a5,100
    7dbc:	02f71463          	bne	a4,a5,7de4 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
    7dc0:	fb843783          	ld	a5,-72(s0)
    7dc4:	00878713          	addi	a4,a5,8
    7dc8:	fae43c23          	sd	a4,-72(s0)
    7dcc:	4398                	lw	a4,0(a5)
    7dce:	fcc42783          	lw	a5,-52(s0)
    7dd2:	4685                	li	a3,1
    7dd4:	4629                	li	a2,10
    7dd6:	85ba                	mv	a1,a4
    7dd8:	853e                	mv	a0,a5
    7dda:	00000097          	auipc	ra,0x0
    7dde:	dc8080e7          	jalr	-568(ra) # 7ba2 <printint>
    7de2:	a269                	j	7f6c <vprintf+0x23a>
      } else if(c == 'l') {
    7de4:	fdc42783          	lw	a5,-36(s0)
    7de8:	0007871b          	sext.w	a4,a5
    7dec:	06c00793          	li	a5,108
    7df0:	02f71663          	bne	a4,a5,7e1c <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
    7df4:	fb843783          	ld	a5,-72(s0)
    7df8:	00878713          	addi	a4,a5,8
    7dfc:	fae43c23          	sd	a4,-72(s0)
    7e00:	639c                	ld	a5,0(a5)
    7e02:	0007871b          	sext.w	a4,a5
    7e06:	fcc42783          	lw	a5,-52(s0)
    7e0a:	4681                	li	a3,0
    7e0c:	4629                	li	a2,10
    7e0e:	85ba                	mv	a1,a4
    7e10:	853e                	mv	a0,a5
    7e12:	00000097          	auipc	ra,0x0
    7e16:	d90080e7          	jalr	-624(ra) # 7ba2 <printint>
    7e1a:	aa89                	j	7f6c <vprintf+0x23a>
      } else if(c == 'x') {
    7e1c:	fdc42783          	lw	a5,-36(s0)
    7e20:	0007871b          	sext.w	a4,a5
    7e24:	07800793          	li	a5,120
    7e28:	02f71463          	bne	a4,a5,7e50 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
    7e2c:	fb843783          	ld	a5,-72(s0)
    7e30:	00878713          	addi	a4,a5,8
    7e34:	fae43c23          	sd	a4,-72(s0)
    7e38:	4398                	lw	a4,0(a5)
    7e3a:	fcc42783          	lw	a5,-52(s0)
    7e3e:	4681                	li	a3,0
    7e40:	4641                	li	a2,16
    7e42:	85ba                	mv	a1,a4
    7e44:	853e                	mv	a0,a5
    7e46:	00000097          	auipc	ra,0x0
    7e4a:	d5c080e7          	jalr	-676(ra) # 7ba2 <printint>
    7e4e:	aa39                	j	7f6c <vprintf+0x23a>
      } else if(c == 'p') {
    7e50:	fdc42783          	lw	a5,-36(s0)
    7e54:	0007871b          	sext.w	a4,a5
    7e58:	07000793          	li	a5,112
    7e5c:	02f71263          	bne	a4,a5,7e80 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
    7e60:	fb843783          	ld	a5,-72(s0)
    7e64:	00878713          	addi	a4,a5,8
    7e68:	fae43c23          	sd	a4,-72(s0)
    7e6c:	6398                	ld	a4,0(a5)
    7e6e:	fcc42783          	lw	a5,-52(s0)
    7e72:	85ba                	mv	a1,a4
    7e74:	853e                	mv	a0,a5
    7e76:	00000097          	auipc	ra,0x0
    7e7a:	e32080e7          	jalr	-462(ra) # 7ca8 <printptr>
    7e7e:	a0fd                	j	7f6c <vprintf+0x23a>
      } else if(c == 's'){
    7e80:	fdc42783          	lw	a5,-36(s0)
    7e84:	0007871b          	sext.w	a4,a5
    7e88:	07300793          	li	a5,115
    7e8c:	04f71c63          	bne	a4,a5,7ee4 <vprintf+0x1b2>
        s = va_arg(ap, char*);
    7e90:	fb843783          	ld	a5,-72(s0)
    7e94:	00878713          	addi	a4,a5,8
    7e98:	fae43c23          	sd	a4,-72(s0)
    7e9c:	639c                	ld	a5,0(a5)
    7e9e:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
    7ea2:	fe843783          	ld	a5,-24(s0)
    7ea6:	eb8d                	bnez	a5,7ed8 <vprintf+0x1a6>
          s = "(null)";
    7ea8:	00003797          	auipc	a5,0x3
    7eac:	95078793          	addi	a5,a5,-1712 # a7f8 <malloc+0x2614>
    7eb0:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
    7eb4:	a015                	j	7ed8 <vprintf+0x1a6>
          putc(fd, *s);
    7eb6:	fe843783          	ld	a5,-24(s0)
    7eba:	0007c703          	lbu	a4,0(a5)
    7ebe:	fcc42783          	lw	a5,-52(s0)
    7ec2:	85ba                	mv	a1,a4
    7ec4:	853e                	mv	a0,a5
    7ec6:	00000097          	auipc	ra,0x0
    7eca:	ca6080e7          	jalr	-858(ra) # 7b6c <putc>
          s++;
    7ece:	fe843783          	ld	a5,-24(s0)
    7ed2:	0785                	addi	a5,a5,1
    7ed4:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
    7ed8:	fe843783          	ld	a5,-24(s0)
    7edc:	0007c783          	lbu	a5,0(a5)
    7ee0:	fbf9                	bnez	a5,7eb6 <vprintf+0x184>
    7ee2:	a069                	j	7f6c <vprintf+0x23a>
        }
      } else if(c == 'c'){
    7ee4:	fdc42783          	lw	a5,-36(s0)
    7ee8:	0007871b          	sext.w	a4,a5
    7eec:	06300793          	li	a5,99
    7ef0:	02f71463          	bne	a4,a5,7f18 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
    7ef4:	fb843783          	ld	a5,-72(s0)
    7ef8:	00878713          	addi	a4,a5,8
    7efc:	fae43c23          	sd	a4,-72(s0)
    7f00:	439c                	lw	a5,0(a5)
    7f02:	0ff7f713          	zext.b	a4,a5
    7f06:	fcc42783          	lw	a5,-52(s0)
    7f0a:	85ba                	mv	a1,a4
    7f0c:	853e                	mv	a0,a5
    7f0e:	00000097          	auipc	ra,0x0
    7f12:	c5e080e7          	jalr	-930(ra) # 7b6c <putc>
    7f16:	a899                	j	7f6c <vprintf+0x23a>
      } else if(c == '%'){
    7f18:	fdc42783          	lw	a5,-36(s0)
    7f1c:	0007871b          	sext.w	a4,a5
    7f20:	02500793          	li	a5,37
    7f24:	00f71f63          	bne	a4,a5,7f42 <vprintf+0x210>
        putc(fd, c);
    7f28:	fdc42783          	lw	a5,-36(s0)
    7f2c:	0ff7f713          	zext.b	a4,a5
    7f30:	fcc42783          	lw	a5,-52(s0)
    7f34:	85ba                	mv	a1,a4
    7f36:	853e                	mv	a0,a5
    7f38:	00000097          	auipc	ra,0x0
    7f3c:	c34080e7          	jalr	-972(ra) # 7b6c <putc>
    7f40:	a035                	j	7f6c <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    7f42:	fcc42783          	lw	a5,-52(s0)
    7f46:	02500593          	li	a1,37
    7f4a:	853e                	mv	a0,a5
    7f4c:	00000097          	auipc	ra,0x0
    7f50:	c20080e7          	jalr	-992(ra) # 7b6c <putc>
        putc(fd, c);
    7f54:	fdc42783          	lw	a5,-36(s0)
    7f58:	0ff7f713          	zext.b	a4,a5
    7f5c:	fcc42783          	lw	a5,-52(s0)
    7f60:	85ba                	mv	a1,a4
    7f62:	853e                	mv	a0,a5
    7f64:	00000097          	auipc	ra,0x0
    7f68:	c08080e7          	jalr	-1016(ra) # 7b6c <putc>
      }
      state = 0;
    7f6c:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
    7f70:	fe442783          	lw	a5,-28(s0)
    7f74:	2785                	addiw	a5,a5,1
    7f76:	fef42223          	sw	a5,-28(s0)
    7f7a:	fe442783          	lw	a5,-28(s0)
    7f7e:	fc043703          	ld	a4,-64(s0)
    7f82:	97ba                	add	a5,a5,a4
    7f84:	0007c783          	lbu	a5,0(a5)
    7f88:	dc0795e3          	bnez	a5,7d52 <vprintf+0x20>
    }
  }
}
    7f8c:	0001                	nop
    7f8e:	0001                	nop
    7f90:	60a6                	ld	ra,72(sp)
    7f92:	6406                	ld	s0,64(sp)
    7f94:	6161                	addi	sp,sp,80
    7f96:	8082                	ret

0000000000007f98 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    7f98:	7159                	addi	sp,sp,-112
    7f9a:	fc06                	sd	ra,56(sp)
    7f9c:	f822                	sd	s0,48(sp)
    7f9e:	0080                	addi	s0,sp,64
    7fa0:	fcb43823          	sd	a1,-48(s0)
    7fa4:	e010                	sd	a2,0(s0)
    7fa6:	e414                	sd	a3,8(s0)
    7fa8:	e818                	sd	a4,16(s0)
    7faa:	ec1c                	sd	a5,24(s0)
    7fac:	03043023          	sd	a6,32(s0)
    7fb0:	03143423          	sd	a7,40(s0)
    7fb4:	87aa                	mv	a5,a0
    7fb6:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
    7fba:	03040793          	addi	a5,s0,48
    7fbe:	fcf43423          	sd	a5,-56(s0)
    7fc2:	fc843783          	ld	a5,-56(s0)
    7fc6:	fd078793          	addi	a5,a5,-48
    7fca:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
    7fce:	fe843703          	ld	a4,-24(s0)
    7fd2:	fdc42783          	lw	a5,-36(s0)
    7fd6:	863a                	mv	a2,a4
    7fd8:	fd043583          	ld	a1,-48(s0)
    7fdc:	853e                	mv	a0,a5
    7fde:	00000097          	auipc	ra,0x0
    7fe2:	d54080e7          	jalr	-684(ra) # 7d32 <vprintf>
}
    7fe6:	0001                	nop
    7fe8:	70e2                	ld	ra,56(sp)
    7fea:	7442                	ld	s0,48(sp)
    7fec:	6165                	addi	sp,sp,112
    7fee:	8082                	ret

0000000000007ff0 <printf>:

void
printf(const char *fmt, ...)
{
    7ff0:	7159                	addi	sp,sp,-112
    7ff2:	f406                	sd	ra,40(sp)
    7ff4:	f022                	sd	s0,32(sp)
    7ff6:	1800                	addi	s0,sp,48
    7ff8:	fca43c23          	sd	a0,-40(s0)
    7ffc:	e40c                	sd	a1,8(s0)
    7ffe:	e810                	sd	a2,16(s0)
    8000:	ec14                	sd	a3,24(s0)
    8002:	f018                	sd	a4,32(s0)
    8004:	f41c                	sd	a5,40(s0)
    8006:	03043823          	sd	a6,48(s0)
    800a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    800e:	04040793          	addi	a5,s0,64
    8012:	fcf43823          	sd	a5,-48(s0)
    8016:	fd043783          	ld	a5,-48(s0)
    801a:	fc878793          	addi	a5,a5,-56
    801e:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
    8022:	fe843783          	ld	a5,-24(s0)
    8026:	863e                	mv	a2,a5
    8028:	fd843583          	ld	a1,-40(s0)
    802c:	4505                	li	a0,1
    802e:	00000097          	auipc	ra,0x0
    8032:	d04080e7          	jalr	-764(ra) # 7d32 <vprintf>
}
    8036:	0001                	nop
    8038:	70a2                	ld	ra,40(sp)
    803a:	7402                	ld	s0,32(sp)
    803c:	6165                	addi	sp,sp,112
    803e:	8082                	ret

0000000000008040 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    8040:	7179                	addi	sp,sp,-48
    8042:	f406                	sd	ra,40(sp)
    8044:	f022                	sd	s0,32(sp)
    8046:	1800                	addi	s0,sp,48
    8048:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    804c:	fd843783          	ld	a5,-40(s0)
    8050:	17c1                	addi	a5,a5,-16
    8052:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    8056:	0000a797          	auipc	a5,0xa
    805a:	c4278793          	addi	a5,a5,-958 # 11c98 <freep>
    805e:	639c                	ld	a5,0(a5)
    8060:	fef43423          	sd	a5,-24(s0)
    8064:	a815                	j	8098 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    8066:	fe843783          	ld	a5,-24(s0)
    806a:	639c                	ld	a5,0(a5)
    806c:	fe843703          	ld	a4,-24(s0)
    8070:	00f76f63          	bltu	a4,a5,808e <free+0x4e>
    8074:	fe043703          	ld	a4,-32(s0)
    8078:	fe843783          	ld	a5,-24(s0)
    807c:	02e7eb63          	bltu	a5,a4,80b2 <free+0x72>
    8080:	fe843783          	ld	a5,-24(s0)
    8084:	639c                	ld	a5,0(a5)
    8086:	fe043703          	ld	a4,-32(s0)
    808a:	02f76463          	bltu	a4,a5,80b2 <free+0x72>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    808e:	fe843783          	ld	a5,-24(s0)
    8092:	639c                	ld	a5,0(a5)
    8094:	fef43423          	sd	a5,-24(s0)
    8098:	fe043703          	ld	a4,-32(s0)
    809c:	fe843783          	ld	a5,-24(s0)
    80a0:	fce7f3e3          	bgeu	a5,a4,8066 <free+0x26>
    80a4:	fe843783          	ld	a5,-24(s0)
    80a8:	639c                	ld	a5,0(a5)
    80aa:	fe043703          	ld	a4,-32(s0)
    80ae:	faf77ce3          	bgeu	a4,a5,8066 <free+0x26>
      break;
  if(bp + bp->s.size == p->s.ptr){
    80b2:	fe043783          	ld	a5,-32(s0)
    80b6:	479c                	lw	a5,8(a5)
    80b8:	1782                	slli	a5,a5,0x20
    80ba:	9381                	srli	a5,a5,0x20
    80bc:	0792                	slli	a5,a5,0x4
    80be:	fe043703          	ld	a4,-32(s0)
    80c2:	973e                	add	a4,a4,a5
    80c4:	fe843783          	ld	a5,-24(s0)
    80c8:	639c                	ld	a5,0(a5)
    80ca:	02f71763          	bne	a4,a5,80f8 <free+0xb8>
    bp->s.size += p->s.ptr->s.size;
    80ce:	fe043783          	ld	a5,-32(s0)
    80d2:	4798                	lw	a4,8(a5)
    80d4:	fe843783          	ld	a5,-24(s0)
    80d8:	639c                	ld	a5,0(a5)
    80da:	479c                	lw	a5,8(a5)
    80dc:	9fb9                	addw	a5,a5,a4
    80de:	0007871b          	sext.w	a4,a5
    80e2:	fe043783          	ld	a5,-32(s0)
    80e6:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
    80e8:	fe843783          	ld	a5,-24(s0)
    80ec:	639c                	ld	a5,0(a5)
    80ee:	6398                	ld	a4,0(a5)
    80f0:	fe043783          	ld	a5,-32(s0)
    80f4:	e398                	sd	a4,0(a5)
    80f6:	a039                	j	8104 <free+0xc4>
  } else
    bp->s.ptr = p->s.ptr;
    80f8:	fe843783          	ld	a5,-24(s0)
    80fc:	6398                	ld	a4,0(a5)
    80fe:	fe043783          	ld	a5,-32(s0)
    8102:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
    8104:	fe843783          	ld	a5,-24(s0)
    8108:	479c                	lw	a5,8(a5)
    810a:	1782                	slli	a5,a5,0x20
    810c:	9381                	srli	a5,a5,0x20
    810e:	0792                	slli	a5,a5,0x4
    8110:	fe843703          	ld	a4,-24(s0)
    8114:	97ba                	add	a5,a5,a4
    8116:	fe043703          	ld	a4,-32(s0)
    811a:	02f71563          	bne	a4,a5,8144 <free+0x104>
    p->s.size += bp->s.size;
    811e:	fe843783          	ld	a5,-24(s0)
    8122:	4798                	lw	a4,8(a5)
    8124:	fe043783          	ld	a5,-32(s0)
    8128:	479c                	lw	a5,8(a5)
    812a:	9fb9                	addw	a5,a5,a4
    812c:	0007871b          	sext.w	a4,a5
    8130:	fe843783          	ld	a5,-24(s0)
    8134:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    8136:	fe043783          	ld	a5,-32(s0)
    813a:	6398                	ld	a4,0(a5)
    813c:	fe843783          	ld	a5,-24(s0)
    8140:	e398                	sd	a4,0(a5)
    8142:	a031                	j	814e <free+0x10e>
  } else
    p->s.ptr = bp;
    8144:	fe843783          	ld	a5,-24(s0)
    8148:	fe043703          	ld	a4,-32(s0)
    814c:	e398                	sd	a4,0(a5)
  freep = p;
    814e:	0000a797          	auipc	a5,0xa
    8152:	b4a78793          	addi	a5,a5,-1206 # 11c98 <freep>
    8156:	fe843703          	ld	a4,-24(s0)
    815a:	e398                	sd	a4,0(a5)
}
    815c:	0001                	nop
    815e:	70a2                	ld	ra,40(sp)
    8160:	7402                	ld	s0,32(sp)
    8162:	6145                	addi	sp,sp,48
    8164:	8082                	ret

0000000000008166 <morecore>:

static Header*
morecore(uint nu)
{
    8166:	7179                	addi	sp,sp,-48
    8168:	f406                	sd	ra,40(sp)
    816a:	f022                	sd	s0,32(sp)
    816c:	1800                	addi	s0,sp,48
    816e:	87aa                	mv	a5,a0
    8170:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
    8174:	fdc42783          	lw	a5,-36(s0)
    8178:	0007871b          	sext.w	a4,a5
    817c:	6785                	lui	a5,0x1
    817e:	00f77563          	bgeu	a4,a5,8188 <morecore+0x22>
    nu = 4096;
    8182:	6785                	lui	a5,0x1
    8184:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
    8188:	fdc42783          	lw	a5,-36(s0)
    818c:	0047979b          	slliw	a5,a5,0x4
    8190:	2781                	sext.w	a5,a5
    8192:	853e                	mv	a0,a5
    8194:	00000097          	auipc	ra,0x0
    8198:	9c0080e7          	jalr	-1600(ra) # 7b54 <sbrk>
    819c:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
    81a0:	fe843703          	ld	a4,-24(s0)
    81a4:	57fd                	li	a5,-1
    81a6:	00f71463          	bne	a4,a5,81ae <morecore+0x48>
    return 0;
    81aa:	4781                	li	a5,0
    81ac:	a03d                	j	81da <morecore+0x74>
  hp = (Header*)p;
    81ae:	fe843783          	ld	a5,-24(s0)
    81b2:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
    81b6:	fe043783          	ld	a5,-32(s0)
    81ba:	fdc42703          	lw	a4,-36(s0)
    81be:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
    81c0:	fe043783          	ld	a5,-32(s0)
    81c4:	07c1                	addi	a5,a5,16 # 1010 <truncate3+0x1c2>
    81c6:	853e                	mv	a0,a5
    81c8:	00000097          	auipc	ra,0x0
    81cc:	e78080e7          	jalr	-392(ra) # 8040 <free>
  return freep;
    81d0:	0000a797          	auipc	a5,0xa
    81d4:	ac878793          	addi	a5,a5,-1336 # 11c98 <freep>
    81d8:	639c                	ld	a5,0(a5)
}
    81da:	853e                	mv	a0,a5
    81dc:	70a2                	ld	ra,40(sp)
    81de:	7402                	ld	s0,32(sp)
    81e0:	6145                	addi	sp,sp,48
    81e2:	8082                	ret

00000000000081e4 <malloc>:

void*
malloc(uint nbytes)
{
    81e4:	7139                	addi	sp,sp,-64
    81e6:	fc06                	sd	ra,56(sp)
    81e8:	f822                	sd	s0,48(sp)
    81ea:	0080                	addi	s0,sp,64
    81ec:	87aa                	mv	a5,a0
    81ee:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    81f2:	fcc46783          	lwu	a5,-52(s0)
    81f6:	07bd                	addi	a5,a5,15
    81f8:	8391                	srli	a5,a5,0x4
    81fa:	2781                	sext.w	a5,a5
    81fc:	2785                	addiw	a5,a5,1
    81fe:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
    8202:	0000a797          	auipc	a5,0xa
    8206:	a9678793          	addi	a5,a5,-1386 # 11c98 <freep>
    820a:	639c                	ld	a5,0(a5)
    820c:	fef43023          	sd	a5,-32(s0)
    8210:	fe043783          	ld	a5,-32(s0)
    8214:	ef95                	bnez	a5,8250 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
    8216:	0000a797          	auipc	a5,0xa
    821a:	a7278793          	addi	a5,a5,-1422 # 11c88 <base>
    821e:	fef43023          	sd	a5,-32(s0)
    8222:	0000a797          	auipc	a5,0xa
    8226:	a7678793          	addi	a5,a5,-1418 # 11c98 <freep>
    822a:	fe043703          	ld	a4,-32(s0)
    822e:	e398                	sd	a4,0(a5)
    8230:	0000a797          	auipc	a5,0xa
    8234:	a6878793          	addi	a5,a5,-1432 # 11c98 <freep>
    8238:	6398                	ld	a4,0(a5)
    823a:	0000a797          	auipc	a5,0xa
    823e:	a4e78793          	addi	a5,a5,-1458 # 11c88 <base>
    8242:	e398                	sd	a4,0(a5)
    base.s.size = 0;
    8244:	0000a797          	auipc	a5,0xa
    8248:	a4478793          	addi	a5,a5,-1468 # 11c88 <base>
    824c:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    8250:	fe043783          	ld	a5,-32(s0)
    8254:	639c                	ld	a5,0(a5)
    8256:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
    825a:	fe843783          	ld	a5,-24(s0)
    825e:	479c                	lw	a5,8(a5)
    8260:	fdc42703          	lw	a4,-36(s0)
    8264:	2701                	sext.w	a4,a4
    8266:	06e7e763          	bltu	a5,a4,82d4 <malloc+0xf0>
      if(p->s.size == nunits)
    826a:	fe843783          	ld	a5,-24(s0)
    826e:	479c                	lw	a5,8(a5)
    8270:	fdc42703          	lw	a4,-36(s0)
    8274:	2701                	sext.w	a4,a4
    8276:	00f71963          	bne	a4,a5,8288 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
    827a:	fe843783          	ld	a5,-24(s0)
    827e:	6398                	ld	a4,0(a5)
    8280:	fe043783          	ld	a5,-32(s0)
    8284:	e398                	sd	a4,0(a5)
    8286:	a825                	j	82be <malloc+0xda>
      else {
        p->s.size -= nunits;
    8288:	fe843783          	ld	a5,-24(s0)
    828c:	479c                	lw	a5,8(a5)
    828e:	fdc42703          	lw	a4,-36(s0)
    8292:	9f99                	subw	a5,a5,a4
    8294:	0007871b          	sext.w	a4,a5
    8298:	fe843783          	ld	a5,-24(s0)
    829c:	c798                	sw	a4,8(a5)
        p += p->s.size;
    829e:	fe843783          	ld	a5,-24(s0)
    82a2:	479c                	lw	a5,8(a5)
    82a4:	1782                	slli	a5,a5,0x20
    82a6:	9381                	srli	a5,a5,0x20
    82a8:	0792                	slli	a5,a5,0x4
    82aa:	fe843703          	ld	a4,-24(s0)
    82ae:	97ba                	add	a5,a5,a4
    82b0:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
    82b4:	fe843783          	ld	a5,-24(s0)
    82b8:	fdc42703          	lw	a4,-36(s0)
    82bc:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
    82be:	0000a797          	auipc	a5,0xa
    82c2:	9da78793          	addi	a5,a5,-1574 # 11c98 <freep>
    82c6:	fe043703          	ld	a4,-32(s0)
    82ca:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
    82cc:	fe843783          	ld	a5,-24(s0)
    82d0:	07c1                	addi	a5,a5,16
    82d2:	a091                	j	8316 <malloc+0x132>
    }
    if(p == freep)
    82d4:	0000a797          	auipc	a5,0xa
    82d8:	9c478793          	addi	a5,a5,-1596 # 11c98 <freep>
    82dc:	639c                	ld	a5,0(a5)
    82de:	fe843703          	ld	a4,-24(s0)
    82e2:	02f71063          	bne	a4,a5,8302 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
    82e6:	fdc42783          	lw	a5,-36(s0)
    82ea:	853e                	mv	a0,a5
    82ec:	00000097          	auipc	ra,0x0
    82f0:	e7a080e7          	jalr	-390(ra) # 8166 <morecore>
    82f4:	fea43423          	sd	a0,-24(s0)
    82f8:	fe843783          	ld	a5,-24(s0)
    82fc:	e399                	bnez	a5,8302 <malloc+0x11e>
        return 0;
    82fe:	4781                	li	a5,0
    8300:	a819                	j	8316 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    8302:	fe843783          	ld	a5,-24(s0)
    8306:	fef43023          	sd	a5,-32(s0)
    830a:	fe843783          	ld	a5,-24(s0)
    830e:	639c                	ld	a5,0(a5)
    8310:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
    8314:	b799                	j	825a <malloc+0x76>
  }
}
    8316:	853e                	mv	a0,a5
    8318:	70e2                	ld	ra,56(sp)
    831a:	7442                	ld	s0,48(sp)
    831c:	6121                	addi	sp,sp,64
    831e:	8082                	ret
