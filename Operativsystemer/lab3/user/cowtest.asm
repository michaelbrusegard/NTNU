
user/_cowtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <testcase5>:

int global_array[16777216] = {0};
int global_var = 0;

void testcase5()
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	1800                	addi	s0,sp,48
    int pid[3];

    printf("\n----- Test case 5 -----\n");
   c:	00001517          	auipc	a0,0x1
  10:	e5450513          	addi	a0,a0,-428 # e60 <malloc+0xfc>
  14:	00001097          	auipc	ra,0x1
  18:	c94080e7          	jalr	-876(ra) # ca8 <printf>
    printf("[prnt] v1 --> ");
  1c:	00001517          	auipc	a0,0x1
  20:	e6450513          	addi	a0,a0,-412 # e80 <malloc+0x11c>
  24:	00001097          	auipc	ra,0x1
  28:	c84080e7          	jalr	-892(ra) # ca8 <printf>
    print_free_frame_cnt();
  2c:	00001097          	auipc	ra,0x1
  30:	9be080e7          	jalr	-1602(ra) # 9ea <pfreepages>

    for (int i = 0; i < 3; ++i)
  34:	fd040493          	addi	s1,s0,-48
  38:	fdc40913          	addi	s2,s0,-36
    {
        if ((pid[i] = fork()) == 0)
  3c:	00001097          	auipc	ra,0x1
  40:	8e6080e7          	jalr	-1818(ra) # 922 <fork>
  44:	c088                	sw	a0,0(s1)
  46:	c531                	beqz	a0,92 <testcase5+0x92>
            // PARENT
            break;
        }
    }

    sleep(100);
  48:	06400513          	li	a0,100
  4c:	00001097          	auipc	ra,0x1
  50:	96e080e7          	jalr	-1682(ra) # 9ba <sleep>
  54:	448d                	li	s1,3

    for (int i = 0; i < 3; ++i)
    {
        int _pid = wait(0);
  56:	4501                	li	a0,0
  58:	00001097          	auipc	ra,0x1
  5c:	8da080e7          	jalr	-1830(ra) # 932 <wait>
        for (int j = 0; j < 3; ++j)
        {
            if (pid[j] == _pid)
  60:	fd042783          	lw	a5,-48(s0)
  64:	02a78b63          	beq	a5,a0,9a <testcase5+0x9a>
  68:	fd442783          	lw	a5,-44(s0)
  6c:	02a78763          	beq	a5,a0,9a <testcase5+0x9a>
  70:	fd842783          	lw	a5,-40(s0)
  74:	02a78363          	beq	a5,a0,9a <testcase5+0x9a>
            {
                break;
            }
            if (j == 2)
            {
                printf("wait() error!");
  78:	00001517          	auipc	a0,0x1
  7c:	e1850513          	addi	a0,a0,-488 # e90 <malloc+0x12c>
  80:	00001097          	auipc	ra,0x1
  84:	c28080e7          	jalr	-984(ra) # ca8 <printf>
                exit(1);
  88:	4505                	li	a0,1
  8a:	00001097          	auipc	ra,0x1
  8e:	8a0080e7          	jalr	-1888(ra) # 92a <exit>
    for (int i = 0; i < 3; ++i)
  92:	0491                	addi	s1,s1,4
  94:	fb248ae3          	beq	s1,s2,48 <testcase5+0x48>
  98:	b755                	j	3c <testcase5+0x3c>
    for (int i = 0; i < 3; ++i)
  9a:	34fd                	addiw	s1,s1,-1
  9c:	fccd                	bnez	s1,56 <testcase5+0x56>
            }
        }
    }

    printf("[prnt] v7 --> ");
  9e:	00001517          	auipc	a0,0x1
  a2:	e0250513          	addi	a0,a0,-510 # ea0 <malloc+0x13c>
  a6:	00001097          	auipc	ra,0x1
  aa:	c02080e7          	jalr	-1022(ra) # ca8 <printf>
    print_free_frame_cnt();
  ae:	00001097          	auipc	ra,0x1
  b2:	93c080e7          	jalr	-1732(ra) # 9ea <pfreepages>
}
  b6:	70a2                	ld	ra,40(sp)
  b8:	7402                	ld	s0,32(sp)
  ba:	64e2                	ld	s1,24(sp)
  bc:	6942                	ld	s2,16(sp)
  be:	6145                	addi	sp,sp,48
  c0:	8082                	ret

00000000000000c2 <testcase4>:

void testcase4()
{
  c2:	1101                	addi	sp,sp,-32
  c4:	ec06                	sd	ra,24(sp)
  c6:	e822                	sd	s0,16(sp)
  c8:	e426                	sd	s1,8(sp)
  ca:	e04a                	sd	s2,0(sp)
  cc:	1000                	addi	s0,sp,32
    int pid;

    printf("\n----- Test case 4 -----\n");
  ce:	00001517          	auipc	a0,0x1
  d2:	de250513          	addi	a0,a0,-542 # eb0 <malloc+0x14c>
  d6:	00001097          	auipc	ra,0x1
  da:	bd2080e7          	jalr	-1070(ra) # ca8 <printf>
    printf("[prnt] v1 --> ");
  de:	00001517          	auipc	a0,0x1
  e2:	da250513          	addi	a0,a0,-606 # e80 <malloc+0x11c>
  e6:	00001097          	auipc	ra,0x1
  ea:	bc2080e7          	jalr	-1086(ra) # ca8 <printf>
    print_free_frame_cnt();
  ee:	00001097          	auipc	ra,0x1
  f2:	8fc080e7          	jalr	-1796(ra) # 9ea <pfreepages>

    if ((pid = fork()) == 0)
  f6:	00001097          	auipc	ra,0x1
  fa:	82c080e7          	jalr	-2004(ra) # 922 <fork>
  fe:	c171                	beqz	a0,1c2 <testcase4+0x100>
 100:	84aa                	mv	s1,a0
        exit(0);
    }
    else
    {
        // parent
        printf("[prnt] v2 --> ");
 102:	00001517          	auipc	a0,0x1
 106:	ede50513          	addi	a0,a0,-290 # fe0 <malloc+0x27c>
 10a:	00001097          	auipc	ra,0x1
 10e:	b9e080e7          	jalr	-1122(ra) # ca8 <printf>
        print_free_frame_cnt();
 112:	00001097          	auipc	ra,0x1
 116:	8d8080e7          	jalr	-1832(ra) # 9ea <pfreepages>

        global_array[0] = 111;
 11a:	00002917          	auipc	s2,0x2
 11e:	ef690913          	addi	s2,s2,-266 # 2010 <global_array>
 122:	06f00593          	li	a1,111
 126:	00b92023          	sw	a1,0(s2)
        printf("[prnt] modified one element in the 1st page, global_array[0]=%d\n", global_array[0]);
 12a:	00001517          	auipc	a0,0x1
 12e:	ec650513          	addi	a0,a0,-314 # ff0 <malloc+0x28c>
 132:	00001097          	auipc	ra,0x1
 136:	b76080e7          	jalr	-1162(ra) # ca8 <printf>

        printf("[prnt] v3 --> ");
 13a:	00001517          	auipc	a0,0x1
 13e:	efe50513          	addi	a0,a0,-258 # 1038 <malloc+0x2d4>
 142:	00001097          	auipc	ra,0x1
 146:	b66080e7          	jalr	-1178(ra) # ca8 <printf>
        print_free_frame_cnt();
 14a:	00001097          	auipc	ra,0x1
 14e:	8a0080e7          	jalr	-1888(ra) # 9ea <pfreepages>
        printf("[prnt] pa3 --> 0x%x\n", va2pa((uint64)&global_array[0], getpid()));
 152:	00001097          	auipc	ra,0x1
 156:	858080e7          	jalr	-1960(ra) # 9aa <getpid>
 15a:	85aa                	mv	a1,a0
 15c:	854a                	mv	a0,s2
 15e:	00001097          	auipc	ra,0x1
 162:	884080e7          	jalr	-1916(ra) # 9e2 <va2pa>
 166:	85aa                	mv	a1,a0
 168:	00001517          	auipc	a0,0x1
 16c:	ee050513          	addi	a0,a0,-288 # 1048 <malloc+0x2e4>
 170:	00001097          	auipc	ra,0x1
 174:	b38080e7          	jalr	-1224(ra) # ca8 <printf>
    }

    if (wait(0) != pid)
 178:	4501                	li	a0,0
 17a:	00000097          	auipc	ra,0x0
 17e:	7b8080e7          	jalr	1976(ra) # 932 <wait>
 182:	12951b63          	bne	a0,s1,2b8 <testcase4+0x1f6>
    {
        printf("wait() error!");
        exit(1);
    }

    printf("[prnt] global_array[0] --> %d\n", global_array[0]);
 186:	00002597          	auipc	a1,0x2
 18a:	e8a5a583          	lw	a1,-374(a1) # 2010 <global_array>
 18e:	00001517          	auipc	a0,0x1
 192:	ed250513          	addi	a0,a0,-302 # 1060 <malloc+0x2fc>
 196:	00001097          	auipc	ra,0x1
 19a:	b12080e7          	jalr	-1262(ra) # ca8 <printf>

    printf("[prnt] v7 --> ");
 19e:	00001517          	auipc	a0,0x1
 1a2:	d0250513          	addi	a0,a0,-766 # ea0 <malloc+0x13c>
 1a6:	00001097          	auipc	ra,0x1
 1aa:	b02080e7          	jalr	-1278(ra) # ca8 <printf>
    print_free_frame_cnt();
 1ae:	00001097          	auipc	ra,0x1
 1b2:	83c080e7          	jalr	-1988(ra) # 9ea <pfreepages>
}
 1b6:	60e2                	ld	ra,24(sp)
 1b8:	6442                	ld	s0,16(sp)
 1ba:	64a2                	ld	s1,8(sp)
 1bc:	6902                	ld	s2,0(sp)
 1be:	6105                	addi	sp,sp,32
 1c0:	8082                	ret
        sleep(50);
 1c2:	03200513          	li	a0,50
 1c6:	00000097          	auipc	ra,0x0
 1ca:	7f4080e7          	jalr	2036(ra) # 9ba <sleep>
        printf("[chld] pa1 --> 0x%x\n", va2pa((uint64)&global_array[0], getpid()));
 1ce:	00002497          	auipc	s1,0x2
 1d2:	e4248493          	addi	s1,s1,-446 # 2010 <global_array>
 1d6:	00000097          	auipc	ra,0x0
 1da:	7d4080e7          	jalr	2004(ra) # 9aa <getpid>
 1de:	85aa                	mv	a1,a0
 1e0:	8526                	mv	a0,s1
 1e2:	00001097          	auipc	ra,0x1
 1e6:	800080e7          	jalr	-2048(ra) # 9e2 <va2pa>
 1ea:	85aa                	mv	a1,a0
 1ec:	00001517          	auipc	a0,0x1
 1f0:	ce450513          	addi	a0,a0,-796 # ed0 <malloc+0x16c>
 1f4:	00001097          	auipc	ra,0x1
 1f8:	ab4080e7          	jalr	-1356(ra) # ca8 <printf>
        printf("[chld] v4 --> ");
 1fc:	00001517          	auipc	a0,0x1
 200:	cec50513          	addi	a0,a0,-788 # ee8 <malloc+0x184>
 204:	00001097          	auipc	ra,0x1
 208:	aa4080e7          	jalr	-1372(ra) # ca8 <printf>
        print_free_frame_cnt();
 20c:	00000097          	auipc	ra,0x0
 210:	7de080e7          	jalr	2014(ra) # 9ea <pfreepages>
        global_array[0] = 222;
 214:	0de00593          	li	a1,222
 218:	c08c                	sw	a1,0(s1)
        printf("[chld] modified one element in the 1st page, global_array[0]=%d\n", global_array[0]);
 21a:	00001517          	auipc	a0,0x1
 21e:	cde50513          	addi	a0,a0,-802 # ef8 <malloc+0x194>
 222:	00001097          	auipc	ra,0x1
 226:	a86080e7          	jalr	-1402(ra) # ca8 <printf>
        printf("[chld] pa2 --> 0x%x\n", va2pa((uint64)&global_array[0], getpid()));
 22a:	00000097          	auipc	ra,0x0
 22e:	780080e7          	jalr	1920(ra) # 9aa <getpid>
 232:	85aa                	mv	a1,a0
 234:	8526                	mv	a0,s1
 236:	00000097          	auipc	ra,0x0
 23a:	7ac080e7          	jalr	1964(ra) # 9e2 <va2pa>
 23e:	85aa                	mv	a1,a0
 240:	00001517          	auipc	a0,0x1
 244:	d0050513          	addi	a0,a0,-768 # f40 <malloc+0x1dc>
 248:	00001097          	auipc	ra,0x1
 24c:	a60080e7          	jalr	-1440(ra) # ca8 <printf>
        printf("[chld] v5 --> ");
 250:	00001517          	auipc	a0,0x1
 254:	d0850513          	addi	a0,a0,-760 # f58 <malloc+0x1f4>
 258:	00001097          	auipc	ra,0x1
 25c:	a50080e7          	jalr	-1456(ra) # ca8 <printf>
        print_free_frame_cnt();
 260:	00000097          	auipc	ra,0x0
 264:	78a080e7          	jalr	1930(ra) # 9ea <pfreepages>
        global_array[2047] = 333;
 268:	14d00593          	li	a1,333
 26c:	00004797          	auipc	a5,0x4
 270:	dab7a023          	sw	a1,-608(a5) # 400c <global_array+0x1ffc>
        printf("[chld] modified two elements in the 2nd page, global_array[2047]=%d\n", global_array[2047]);
 274:	00001517          	auipc	a0,0x1
 278:	cf450513          	addi	a0,a0,-780 # f68 <malloc+0x204>
 27c:	00001097          	auipc	ra,0x1
 280:	a2c080e7          	jalr	-1492(ra) # ca8 <printf>
        printf("[chld] v6 --> ");
 284:	00001517          	auipc	a0,0x1
 288:	d2c50513          	addi	a0,a0,-724 # fb0 <malloc+0x24c>
 28c:	00001097          	auipc	ra,0x1
 290:	a1c080e7          	jalr	-1508(ra) # ca8 <printf>
        print_free_frame_cnt();
 294:	00000097          	auipc	ra,0x0
 298:	756080e7          	jalr	1878(ra) # 9ea <pfreepages>
        printf("[chld] global_array[0] --> %d\n", global_array[0]);
 29c:	408c                	lw	a1,0(s1)
 29e:	00001517          	auipc	a0,0x1
 2a2:	d2250513          	addi	a0,a0,-734 # fc0 <malloc+0x25c>
 2a6:	00001097          	auipc	ra,0x1
 2aa:	a02080e7          	jalr	-1534(ra) # ca8 <printf>
        exit(0);
 2ae:	4501                	li	a0,0
 2b0:	00000097          	auipc	ra,0x0
 2b4:	67a080e7          	jalr	1658(ra) # 92a <exit>
        printf("wait() error!");
 2b8:	00001517          	auipc	a0,0x1
 2bc:	bd850513          	addi	a0,a0,-1064 # e90 <malloc+0x12c>
 2c0:	00001097          	auipc	ra,0x1
 2c4:	9e8080e7          	jalr	-1560(ra) # ca8 <printf>
        exit(1);
 2c8:	4505                	li	a0,1
 2ca:	00000097          	auipc	ra,0x0
 2ce:	660080e7          	jalr	1632(ra) # 92a <exit>

00000000000002d2 <testcase3>:

void testcase3()
{
 2d2:	1101                	addi	sp,sp,-32
 2d4:	ec06                	sd	ra,24(sp)
 2d6:	e822                	sd	s0,16(sp)
 2d8:	e426                	sd	s1,8(sp)
 2da:	1000                	addi	s0,sp,32
    int pid;

    printf("\n----- Test case 3 -----\n");
 2dc:	00001517          	auipc	a0,0x1
 2e0:	da450513          	addi	a0,a0,-604 # 1080 <malloc+0x31c>
 2e4:	00001097          	auipc	ra,0x1
 2e8:	9c4080e7          	jalr	-1596(ra) # ca8 <printf>
    printf("[prnt] v1 --> ");
 2ec:	00001517          	auipc	a0,0x1
 2f0:	b9450513          	addi	a0,a0,-1132 # e80 <malloc+0x11c>
 2f4:	00001097          	auipc	ra,0x1
 2f8:	9b4080e7          	jalr	-1612(ra) # ca8 <printf>
    print_free_frame_cnt();
 2fc:	00000097          	auipc	ra,0x0
 300:	6ee080e7          	jalr	1774(ra) # 9ea <pfreepages>

    if ((pid = fork()) == 0)
 304:	00000097          	auipc	ra,0x0
 308:	61e080e7          	jalr	1566(ra) # 922 <fork>
 30c:	cd35                	beqz	a0,388 <testcase3+0xb6>
 30e:	84aa                	mv	s1,a0
        exit(0);
    }
    else
    {
        // parent
        printf("[prnt] v2 --> ");
 310:	00001517          	auipc	a0,0x1
 314:	cd050513          	addi	a0,a0,-816 # fe0 <malloc+0x27c>
 318:	00001097          	auipc	ra,0x1
 31c:	990080e7          	jalr	-1648(ra) # ca8 <printf>
        print_free_frame_cnt();
 320:	00000097          	auipc	ra,0x0
 324:	6ca080e7          	jalr	1738(ra) # 9ea <pfreepages>

        printf("[prnt] read global_var, global_var=%d\n", global_var);
 328:	00002597          	auipc	a1,0x2
 32c:	cd85a583          	lw	a1,-808(a1) # 2000 <global_var>
 330:	00001517          	auipc	a0,0x1
 334:	da050513          	addi	a0,a0,-608 # 10d0 <malloc+0x36c>
 338:	00001097          	auipc	ra,0x1
 33c:	970080e7          	jalr	-1680(ra) # ca8 <printf>

        printf("[prnt] v3 --> ");
 340:	00001517          	auipc	a0,0x1
 344:	cf850513          	addi	a0,a0,-776 # 1038 <malloc+0x2d4>
 348:	00001097          	auipc	ra,0x1
 34c:	960080e7          	jalr	-1696(ra) # ca8 <printf>
        print_free_frame_cnt();
 350:	00000097          	auipc	ra,0x0
 354:	69a080e7          	jalr	1690(ra) # 9ea <pfreepages>
    }

    if (wait(0) != pid)
 358:	4501                	li	a0,0
 35a:	00000097          	auipc	ra,0x0
 35e:	5d8080e7          	jalr	1496(ra) # 932 <wait>
 362:	08951463          	bne	a0,s1,3ea <testcase3+0x118>
    {
        printf("wait() error!");
        exit(1);
    }

    printf("[prnt] v6 --> ");
 366:	00001517          	auipc	a0,0x1
 36a:	d9250513          	addi	a0,a0,-622 # 10f8 <malloc+0x394>
 36e:	00001097          	auipc	ra,0x1
 372:	93a080e7          	jalr	-1734(ra) # ca8 <printf>
    print_free_frame_cnt();
 376:	00000097          	auipc	ra,0x0
 37a:	674080e7          	jalr	1652(ra) # 9ea <pfreepages>
}
 37e:	60e2                	ld	ra,24(sp)
 380:	6442                	ld	s0,16(sp)
 382:	64a2                	ld	s1,8(sp)
 384:	6105                	addi	sp,sp,32
 386:	8082                	ret
        sleep(50);
 388:	03200513          	li	a0,50
 38c:	00000097          	auipc	ra,0x0
 390:	62e080e7          	jalr	1582(ra) # 9ba <sleep>
        printf("[chld] v4 --> ");
 394:	00001517          	auipc	a0,0x1
 398:	b5450513          	addi	a0,a0,-1196 # ee8 <malloc+0x184>
 39c:	00001097          	auipc	ra,0x1
 3a0:	90c080e7          	jalr	-1780(ra) # ca8 <printf>
        print_free_frame_cnt();
 3a4:	00000097          	auipc	ra,0x0
 3a8:	646080e7          	jalr	1606(ra) # 9ea <pfreepages>
        global_var = 100;
 3ac:	06400593          	li	a1,100
 3b0:	00002797          	auipc	a5,0x2
 3b4:	c4b7a823          	sw	a1,-944(a5) # 2000 <global_var>
        printf("[chld] modified global_var, global_var=%d\n", global_var);
 3b8:	00001517          	auipc	a0,0x1
 3bc:	ce850513          	addi	a0,a0,-792 # 10a0 <malloc+0x33c>
 3c0:	00001097          	auipc	ra,0x1
 3c4:	8e8080e7          	jalr	-1816(ra) # ca8 <printf>
        printf("[chld] v5 --> ");
 3c8:	00001517          	auipc	a0,0x1
 3cc:	b9050513          	addi	a0,a0,-1136 # f58 <malloc+0x1f4>
 3d0:	00001097          	auipc	ra,0x1
 3d4:	8d8080e7          	jalr	-1832(ra) # ca8 <printf>
        print_free_frame_cnt();
 3d8:	00000097          	auipc	ra,0x0
 3dc:	612080e7          	jalr	1554(ra) # 9ea <pfreepages>
        exit(0);
 3e0:	4501                	li	a0,0
 3e2:	00000097          	auipc	ra,0x0
 3e6:	548080e7          	jalr	1352(ra) # 92a <exit>
        printf("wait() error!");
 3ea:	00001517          	auipc	a0,0x1
 3ee:	aa650513          	addi	a0,a0,-1370 # e90 <malloc+0x12c>
 3f2:	00001097          	auipc	ra,0x1
 3f6:	8b6080e7          	jalr	-1866(ra) # ca8 <printf>
        exit(1);
 3fa:	4505                	li	a0,1
 3fc:	00000097          	auipc	ra,0x0
 400:	52e080e7          	jalr	1326(ra) # 92a <exit>

0000000000000404 <testcase2>:

void testcase2()
{
 404:	1101                	addi	sp,sp,-32
 406:	ec06                	sd	ra,24(sp)
 408:	e822                	sd	s0,16(sp)
 40a:	e426                	sd	s1,8(sp)
 40c:	1000                	addi	s0,sp,32
    int pid;

    printf("\n----- Test case 2 -----\n");
 40e:	00001517          	auipc	a0,0x1
 412:	cfa50513          	addi	a0,a0,-774 # 1108 <malloc+0x3a4>
 416:	00001097          	auipc	ra,0x1
 41a:	892080e7          	jalr	-1902(ra) # ca8 <printf>
    printf("[prnt] v1 --> ");
 41e:	00001517          	auipc	a0,0x1
 422:	a6250513          	addi	a0,a0,-1438 # e80 <malloc+0x11c>
 426:	00001097          	auipc	ra,0x1
 42a:	882080e7          	jalr	-1918(ra) # ca8 <printf>
    print_free_frame_cnt();
 42e:	00000097          	auipc	ra,0x0
 432:	5bc080e7          	jalr	1468(ra) # 9ea <pfreepages>

    if ((pid = fork()) == 0)
 436:	00000097          	auipc	ra,0x0
 43a:	4ec080e7          	jalr	1260(ra) # 922 <fork>
 43e:	c531                	beqz	a0,48a <testcase2+0x86>
 440:	84aa                	mv	s1,a0
        exit(0);
    }
    else
    {
        // parent
        printf("[prnt] v2 --> ");
 442:	00001517          	auipc	a0,0x1
 446:	b9e50513          	addi	a0,a0,-1122 # fe0 <malloc+0x27c>
 44a:	00001097          	auipc	ra,0x1
 44e:	85e080e7          	jalr	-1954(ra) # ca8 <printf>
        print_free_frame_cnt();
 452:	00000097          	auipc	ra,0x0
 456:	598080e7          	jalr	1432(ra) # 9ea <pfreepages>
    }

    if (wait(0) != pid)
 45a:	4501                	li	a0,0
 45c:	00000097          	auipc	ra,0x0
 460:	4d6080e7          	jalr	1238(ra) # 932 <wait>
 464:	08951263          	bne	a0,s1,4e8 <testcase2+0xe4>
    {
        printf("wait() error!");
        exit(1);
    }

    printf("[prnt] v5 --> ");
 468:	00001517          	auipc	a0,0x1
 46c:	cf850513          	addi	a0,a0,-776 # 1160 <malloc+0x3fc>
 470:	00001097          	auipc	ra,0x1
 474:	838080e7          	jalr	-1992(ra) # ca8 <printf>
    print_free_frame_cnt();
 478:	00000097          	auipc	ra,0x0
 47c:	572080e7          	jalr	1394(ra) # 9ea <pfreepages>
}
 480:	60e2                	ld	ra,24(sp)
 482:	6442                	ld	s0,16(sp)
 484:	64a2                	ld	s1,8(sp)
 486:	6105                	addi	sp,sp,32
 488:	8082                	ret
        sleep(50);
 48a:	03200513          	li	a0,50
 48e:	00000097          	auipc	ra,0x0
 492:	52c080e7          	jalr	1324(ra) # 9ba <sleep>
        printf("[chld] v3 --> ");
 496:	00001517          	auipc	a0,0x1
 49a:	c9250513          	addi	a0,a0,-878 # 1128 <malloc+0x3c4>
 49e:	00001097          	auipc	ra,0x1
 4a2:	80a080e7          	jalr	-2038(ra) # ca8 <printf>
        print_free_frame_cnt();
 4a6:	00000097          	auipc	ra,0x0
 4aa:	544080e7          	jalr	1348(ra) # 9ea <pfreepages>
        printf("[chld] read global_var, global_var=%d\n", global_var);
 4ae:	00002597          	auipc	a1,0x2
 4b2:	b525a583          	lw	a1,-1198(a1) # 2000 <global_var>
 4b6:	00001517          	auipc	a0,0x1
 4ba:	c8250513          	addi	a0,a0,-894 # 1138 <malloc+0x3d4>
 4be:	00000097          	auipc	ra,0x0
 4c2:	7ea080e7          	jalr	2026(ra) # ca8 <printf>
        printf("[chld] v4 --> ");
 4c6:	00001517          	auipc	a0,0x1
 4ca:	a2250513          	addi	a0,a0,-1502 # ee8 <malloc+0x184>
 4ce:	00000097          	auipc	ra,0x0
 4d2:	7da080e7          	jalr	2010(ra) # ca8 <printf>
        print_free_frame_cnt();
 4d6:	00000097          	auipc	ra,0x0
 4da:	514080e7          	jalr	1300(ra) # 9ea <pfreepages>
        exit(0);
 4de:	4501                	li	a0,0
 4e0:	00000097          	auipc	ra,0x0
 4e4:	44a080e7          	jalr	1098(ra) # 92a <exit>
        printf("wait() error!");
 4e8:	00001517          	auipc	a0,0x1
 4ec:	9a850513          	addi	a0,a0,-1624 # e90 <malloc+0x12c>
 4f0:	00000097          	auipc	ra,0x0
 4f4:	7b8080e7          	jalr	1976(ra) # ca8 <printf>
        exit(1);
 4f8:	4505                	li	a0,1
 4fa:	00000097          	auipc	ra,0x0
 4fe:	430080e7          	jalr	1072(ra) # 92a <exit>

0000000000000502 <testcase1>:

void testcase1()
{
 502:	1101                	addi	sp,sp,-32
 504:	ec06                	sd	ra,24(sp)
 506:	e822                	sd	s0,16(sp)
 508:	e426                	sd	s1,8(sp)
 50a:	1000                	addi	s0,sp,32
    int pid;

    printf("\n----- Test case 1 -----\n");
 50c:	00001517          	auipc	a0,0x1
 510:	c6450513          	addi	a0,a0,-924 # 1170 <malloc+0x40c>
 514:	00000097          	auipc	ra,0x0
 518:	794080e7          	jalr	1940(ra) # ca8 <printf>
    printf("[prnt] v1 --> ");
 51c:	00001517          	auipc	a0,0x1
 520:	96450513          	addi	a0,a0,-1692 # e80 <malloc+0x11c>
 524:	00000097          	auipc	ra,0x0
 528:	784080e7          	jalr	1924(ra) # ca8 <printf>
    print_free_frame_cnt();
 52c:	00000097          	auipc	ra,0x0
 530:	4be080e7          	jalr	1214(ra) # 9ea <pfreepages>

    if ((pid = fork()) == 0)
 534:	00000097          	auipc	ra,0x0
 538:	3ee080e7          	jalr	1006(ra) # 922 <fork>
 53c:	c531                	beqz	a0,588 <testcase1+0x86>
 53e:	84aa                	mv	s1,a0
        exit(0);
    }
    else
    {
        // parent
        printf("[prnt] v3 --> ");
 540:	00001517          	auipc	a0,0x1
 544:	af850513          	addi	a0,a0,-1288 # 1038 <malloc+0x2d4>
 548:	00000097          	auipc	ra,0x0
 54c:	760080e7          	jalr	1888(ra) # ca8 <printf>
        print_free_frame_cnt();
 550:	00000097          	auipc	ra,0x0
 554:	49a080e7          	jalr	1178(ra) # 9ea <pfreepages>
    }

    if (wait(0) != pid)
 558:	4501                	li	a0,0
 55a:	00000097          	auipc	ra,0x0
 55e:	3d8080e7          	jalr	984(ra) # 932 <wait>
 562:	04951a63          	bne	a0,s1,5b6 <testcase1+0xb4>
    {
        printf("wait() error!");
        exit(1);
    }

    printf("[prnt] v4 --> ");
 566:	00001517          	auipc	a0,0x1
 56a:	c3a50513          	addi	a0,a0,-966 # 11a0 <malloc+0x43c>
 56e:	00000097          	auipc	ra,0x0
 572:	73a080e7          	jalr	1850(ra) # ca8 <printf>
    print_free_frame_cnt();
 576:	00000097          	auipc	ra,0x0
 57a:	474080e7          	jalr	1140(ra) # 9ea <pfreepages>
}
 57e:	60e2                	ld	ra,24(sp)
 580:	6442                	ld	s0,16(sp)
 582:	64a2                	ld	s1,8(sp)
 584:	6105                	addi	sp,sp,32
 586:	8082                	ret
        sleep(50);
 588:	03200513          	li	a0,50
 58c:	00000097          	auipc	ra,0x0
 590:	42e080e7          	jalr	1070(ra) # 9ba <sleep>
        printf("[chld] v2 --> ");
 594:	00001517          	auipc	a0,0x1
 598:	bfc50513          	addi	a0,a0,-1028 # 1190 <malloc+0x42c>
 59c:	00000097          	auipc	ra,0x0
 5a0:	70c080e7          	jalr	1804(ra) # ca8 <printf>
        print_free_frame_cnt();
 5a4:	00000097          	auipc	ra,0x0
 5a8:	446080e7          	jalr	1094(ra) # 9ea <pfreepages>
        exit(0);
 5ac:	4501                	li	a0,0
 5ae:	00000097          	auipc	ra,0x0
 5b2:	37c080e7          	jalr	892(ra) # 92a <exit>
        printf("wait() error!");
 5b6:	00001517          	auipc	a0,0x1
 5ba:	8da50513          	addi	a0,a0,-1830 # e90 <malloc+0x12c>
 5be:	00000097          	auipc	ra,0x0
 5c2:	6ea080e7          	jalr	1770(ra) # ca8 <printf>
        exit(1);
 5c6:	4505                	li	a0,1
 5c8:	00000097          	auipc	ra,0x0
 5cc:	362080e7          	jalr	866(ra) # 92a <exit>

00000000000005d0 <main>:

int main(int argc, char *argv[])
{
 5d0:	1101                	addi	sp,sp,-32
 5d2:	ec06                	sd	ra,24(sp)
 5d4:	e822                	sd	s0,16(sp)
 5d6:	e426                	sd	s1,8(sp)
 5d8:	1000                	addi	s0,sp,32
    if (argc < 2)
 5da:	4785                	li	a5,1
 5dc:	02a7d963          	bge	a5,a0,60e <main+0x3e>
 5e0:	84ae                	mv	s1,a1
    {
        printf("Usage: cowtest test_id\n");
        exit(-1);
    }
    switch (atoi(argv[1]))
 5e2:	6588                	ld	a0,8(a1)
 5e4:	00000097          	auipc	ra,0x0
 5e8:	240080e7          	jalr	576(ra) # 824 <atoi>
 5ec:	478d                	li	a5,3
 5ee:	06f50063          	beq	a0,a5,64e <main+0x7e>
 5f2:	02a7cb63          	blt	a5,a0,628 <main+0x58>
 5f6:	4785                	li	a5,1
 5f8:	04f50163          	beq	a0,a5,63a <main+0x6a>
 5fc:	4789                	li	a5,2
 5fe:	04f51e63          	bne	a0,a5,65a <main+0x8a>
    case 1:
        testcase1();
        break;

    case 2:
        testcase2();
 602:	00000097          	auipc	ra,0x0
 606:	e02080e7          	jalr	-510(ra) # 404 <testcase2>

    default:
        printf("Error: No test with index %s\n", argv[1]);
        return 1;
    }
    return 0;
 60a:	4501                	li	a0,0
        break;
 60c:	a825                	j	644 <main+0x74>
        printf("Usage: cowtest test_id\n");
 60e:	00001517          	auipc	a0,0x1
 612:	ba250513          	addi	a0,a0,-1118 # 11b0 <malloc+0x44c>
 616:	00000097          	auipc	ra,0x0
 61a:	692080e7          	jalr	1682(ra) # ca8 <printf>
        exit(-1);
 61e:	557d                	li	a0,-1
 620:	00000097          	auipc	ra,0x0
 624:	30a080e7          	jalr	778(ra) # 92a <exit>
    switch (atoi(argv[1]))
 628:	4791                	li	a5,4
 62a:	02f51863          	bne	a0,a5,65a <main+0x8a>
        testcase4();
 62e:	00000097          	auipc	ra,0x0
 632:	a94080e7          	jalr	-1388(ra) # c2 <testcase4>
    return 0;
 636:	4501                	li	a0,0
        break;
 638:	a031                	j	644 <main+0x74>
        testcase1();
 63a:	00000097          	auipc	ra,0x0
 63e:	ec8080e7          	jalr	-312(ra) # 502 <testcase1>
    return 0;
 642:	4501                	li	a0,0
 644:	60e2                	ld	ra,24(sp)
 646:	6442                	ld	s0,16(sp)
 648:	64a2                	ld	s1,8(sp)
 64a:	6105                	addi	sp,sp,32
 64c:	8082                	ret
        testcase3();
 64e:	00000097          	auipc	ra,0x0
 652:	c84080e7          	jalr	-892(ra) # 2d2 <testcase3>
    return 0;
 656:	4501                	li	a0,0
        break;
 658:	b7f5                	j	644 <main+0x74>
        printf("Error: No test with index %s\n", argv[1]);
 65a:	648c                	ld	a1,8(s1)
 65c:	00001517          	auipc	a0,0x1
 660:	b6c50513          	addi	a0,a0,-1172 # 11c8 <malloc+0x464>
 664:	00000097          	auipc	ra,0x0
 668:	644080e7          	jalr	1604(ra) # ca8 <printf>
        return 1;
 66c:	4505                	li	a0,1
 66e:	bfd9                	j	644 <main+0x74>

0000000000000670 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 670:	1141                	addi	sp,sp,-16
 672:	e406                	sd	ra,8(sp)
 674:	e022                	sd	s0,0(sp)
 676:	0800                	addi	s0,sp,16
  extern int main();
  main();
 678:	00000097          	auipc	ra,0x0
 67c:	f58080e7          	jalr	-168(ra) # 5d0 <main>
  exit(0);
 680:	4501                	li	a0,0
 682:	00000097          	auipc	ra,0x0
 686:	2a8080e7          	jalr	680(ra) # 92a <exit>

000000000000068a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 68a:	1141                	addi	sp,sp,-16
 68c:	e406                	sd	ra,8(sp)
 68e:	e022                	sd	s0,0(sp)
 690:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 692:	87aa                	mv	a5,a0
 694:	0585                	addi	a1,a1,1
 696:	0785                	addi	a5,a5,1
 698:	fff5c703          	lbu	a4,-1(a1)
 69c:	fee78fa3          	sb	a4,-1(a5)
 6a0:	fb75                	bnez	a4,694 <strcpy+0xa>
    ;
  return os;
}
 6a2:	60a2                	ld	ra,8(sp)
 6a4:	6402                	ld	s0,0(sp)
 6a6:	0141                	addi	sp,sp,16
 6a8:	8082                	ret

00000000000006aa <strcmp>:

int
strcmp(const char *p, const char *q)
{
 6aa:	1141                	addi	sp,sp,-16
 6ac:	e406                	sd	ra,8(sp)
 6ae:	e022                	sd	s0,0(sp)
 6b0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 6b2:	00054783          	lbu	a5,0(a0)
 6b6:	cb91                	beqz	a5,6ca <strcmp+0x20>
 6b8:	0005c703          	lbu	a4,0(a1)
 6bc:	00f71763          	bne	a4,a5,6ca <strcmp+0x20>
    p++, q++;
 6c0:	0505                	addi	a0,a0,1
 6c2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 6c4:	00054783          	lbu	a5,0(a0)
 6c8:	fbe5                	bnez	a5,6b8 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 6ca:	0005c503          	lbu	a0,0(a1)
}
 6ce:	40a7853b          	subw	a0,a5,a0
 6d2:	60a2                	ld	ra,8(sp)
 6d4:	6402                	ld	s0,0(sp)
 6d6:	0141                	addi	sp,sp,16
 6d8:	8082                	ret

00000000000006da <strlen>:

uint
strlen(const char *s)
{
 6da:	1141                	addi	sp,sp,-16
 6dc:	e406                	sd	ra,8(sp)
 6de:	e022                	sd	s0,0(sp)
 6e0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 6e2:	00054783          	lbu	a5,0(a0)
 6e6:	cf99                	beqz	a5,704 <strlen+0x2a>
 6e8:	0505                	addi	a0,a0,1
 6ea:	87aa                	mv	a5,a0
 6ec:	86be                	mv	a3,a5
 6ee:	0785                	addi	a5,a5,1
 6f0:	fff7c703          	lbu	a4,-1(a5)
 6f4:	ff65                	bnez	a4,6ec <strlen+0x12>
 6f6:	40a6853b          	subw	a0,a3,a0
 6fa:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 6fc:	60a2                	ld	ra,8(sp)
 6fe:	6402                	ld	s0,0(sp)
 700:	0141                	addi	sp,sp,16
 702:	8082                	ret
  for(n = 0; s[n]; n++)
 704:	4501                	li	a0,0
 706:	bfdd                	j	6fc <strlen+0x22>

0000000000000708 <memset>:

void*
memset(void *dst, int c, uint n)
{
 708:	1141                	addi	sp,sp,-16
 70a:	e406                	sd	ra,8(sp)
 70c:	e022                	sd	s0,0(sp)
 70e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 710:	ca19                	beqz	a2,726 <memset+0x1e>
 712:	87aa                	mv	a5,a0
 714:	1602                	slli	a2,a2,0x20
 716:	9201                	srli	a2,a2,0x20
 718:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 71c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 720:	0785                	addi	a5,a5,1
 722:	fee79de3          	bne	a5,a4,71c <memset+0x14>
  }
  return dst;
}
 726:	60a2                	ld	ra,8(sp)
 728:	6402                	ld	s0,0(sp)
 72a:	0141                	addi	sp,sp,16
 72c:	8082                	ret

000000000000072e <strchr>:

char*
strchr(const char *s, char c)
{
 72e:	1141                	addi	sp,sp,-16
 730:	e406                	sd	ra,8(sp)
 732:	e022                	sd	s0,0(sp)
 734:	0800                	addi	s0,sp,16
  for(; *s; s++)
 736:	00054783          	lbu	a5,0(a0)
 73a:	cf81                	beqz	a5,752 <strchr+0x24>
    if(*s == c)
 73c:	00f58763          	beq	a1,a5,74a <strchr+0x1c>
  for(; *s; s++)
 740:	0505                	addi	a0,a0,1
 742:	00054783          	lbu	a5,0(a0)
 746:	fbfd                	bnez	a5,73c <strchr+0xe>
      return (char*)s;
  return 0;
 748:	4501                	li	a0,0
}
 74a:	60a2                	ld	ra,8(sp)
 74c:	6402                	ld	s0,0(sp)
 74e:	0141                	addi	sp,sp,16
 750:	8082                	ret
  return 0;
 752:	4501                	li	a0,0
 754:	bfdd                	j	74a <strchr+0x1c>

0000000000000756 <gets>:

char*
gets(char *buf, int max)
{
 756:	7159                	addi	sp,sp,-112
 758:	f486                	sd	ra,104(sp)
 75a:	f0a2                	sd	s0,96(sp)
 75c:	eca6                	sd	s1,88(sp)
 75e:	e8ca                	sd	s2,80(sp)
 760:	e4ce                	sd	s3,72(sp)
 762:	e0d2                	sd	s4,64(sp)
 764:	fc56                	sd	s5,56(sp)
 766:	f85a                	sd	s6,48(sp)
 768:	f45e                	sd	s7,40(sp)
 76a:	f062                	sd	s8,32(sp)
 76c:	ec66                	sd	s9,24(sp)
 76e:	e86a                	sd	s10,16(sp)
 770:	1880                	addi	s0,sp,112
 772:	8caa                	mv	s9,a0
 774:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 776:	892a                	mv	s2,a0
 778:	4481                	li	s1,0
    cc = read(0, &c, 1);
 77a:	f9f40b13          	addi	s6,s0,-97
 77e:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 780:	4ba9                	li	s7,10
 782:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 784:	8d26                	mv	s10,s1
 786:	0014899b          	addiw	s3,s1,1
 78a:	84ce                	mv	s1,s3
 78c:	0349d763          	bge	s3,s4,7ba <gets+0x64>
    cc = read(0, &c, 1);
 790:	8656                	mv	a2,s5
 792:	85da                	mv	a1,s6
 794:	4501                	li	a0,0
 796:	00000097          	auipc	ra,0x0
 79a:	1ac080e7          	jalr	428(ra) # 942 <read>
    if(cc < 1)
 79e:	00a05e63          	blez	a0,7ba <gets+0x64>
    buf[i++] = c;
 7a2:	f9f44783          	lbu	a5,-97(s0)
 7a6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 7aa:	01778763          	beq	a5,s7,7b8 <gets+0x62>
 7ae:	0905                	addi	s2,s2,1
 7b0:	fd879ae3          	bne	a5,s8,784 <gets+0x2e>
    buf[i++] = c;
 7b4:	8d4e                	mv	s10,s3
 7b6:	a011                	j	7ba <gets+0x64>
 7b8:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 7ba:	9d66                	add	s10,s10,s9
 7bc:	000d0023          	sb	zero,0(s10)
  return buf;
}
 7c0:	8566                	mv	a0,s9
 7c2:	70a6                	ld	ra,104(sp)
 7c4:	7406                	ld	s0,96(sp)
 7c6:	64e6                	ld	s1,88(sp)
 7c8:	6946                	ld	s2,80(sp)
 7ca:	69a6                	ld	s3,72(sp)
 7cc:	6a06                	ld	s4,64(sp)
 7ce:	7ae2                	ld	s5,56(sp)
 7d0:	7b42                	ld	s6,48(sp)
 7d2:	7ba2                	ld	s7,40(sp)
 7d4:	7c02                	ld	s8,32(sp)
 7d6:	6ce2                	ld	s9,24(sp)
 7d8:	6d42                	ld	s10,16(sp)
 7da:	6165                	addi	sp,sp,112
 7dc:	8082                	ret

00000000000007de <stat>:

int
stat(const char *n, struct stat *st)
{
 7de:	1101                	addi	sp,sp,-32
 7e0:	ec06                	sd	ra,24(sp)
 7e2:	e822                	sd	s0,16(sp)
 7e4:	e04a                	sd	s2,0(sp)
 7e6:	1000                	addi	s0,sp,32
 7e8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 7ea:	4581                	li	a1,0
 7ec:	00000097          	auipc	ra,0x0
 7f0:	17e080e7          	jalr	382(ra) # 96a <open>
  if(fd < 0)
 7f4:	02054663          	bltz	a0,820 <stat+0x42>
 7f8:	e426                	sd	s1,8(sp)
 7fa:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 7fc:	85ca                	mv	a1,s2
 7fe:	00000097          	auipc	ra,0x0
 802:	184080e7          	jalr	388(ra) # 982 <fstat>
 806:	892a                	mv	s2,a0
  close(fd);
 808:	8526                	mv	a0,s1
 80a:	00000097          	auipc	ra,0x0
 80e:	148080e7          	jalr	328(ra) # 952 <close>
  return r;
 812:	64a2                	ld	s1,8(sp)
}
 814:	854a                	mv	a0,s2
 816:	60e2                	ld	ra,24(sp)
 818:	6442                	ld	s0,16(sp)
 81a:	6902                	ld	s2,0(sp)
 81c:	6105                	addi	sp,sp,32
 81e:	8082                	ret
    return -1;
 820:	597d                	li	s2,-1
 822:	bfcd                	j	814 <stat+0x36>

0000000000000824 <atoi>:

int
atoi(const char *s)
{
 824:	1141                	addi	sp,sp,-16
 826:	e406                	sd	ra,8(sp)
 828:	e022                	sd	s0,0(sp)
 82a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 82c:	00054683          	lbu	a3,0(a0)
 830:	fd06879b          	addiw	a5,a3,-48
 834:	0ff7f793          	zext.b	a5,a5
 838:	4625                	li	a2,9
 83a:	02f66963          	bltu	a2,a5,86c <atoi+0x48>
 83e:	872a                	mv	a4,a0
  n = 0;
 840:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 842:	0705                	addi	a4,a4,1
 844:	0025179b          	slliw	a5,a0,0x2
 848:	9fa9                	addw	a5,a5,a0
 84a:	0017979b          	slliw	a5,a5,0x1
 84e:	9fb5                	addw	a5,a5,a3
 850:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 854:	00074683          	lbu	a3,0(a4)
 858:	fd06879b          	addiw	a5,a3,-48
 85c:	0ff7f793          	zext.b	a5,a5
 860:	fef671e3          	bgeu	a2,a5,842 <atoi+0x1e>
  return n;
}
 864:	60a2                	ld	ra,8(sp)
 866:	6402                	ld	s0,0(sp)
 868:	0141                	addi	sp,sp,16
 86a:	8082                	ret
  n = 0;
 86c:	4501                	li	a0,0
 86e:	bfdd                	j	864 <atoi+0x40>

0000000000000870 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 870:	1141                	addi	sp,sp,-16
 872:	e406                	sd	ra,8(sp)
 874:	e022                	sd	s0,0(sp)
 876:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 878:	02b57563          	bgeu	a0,a1,8a2 <memmove+0x32>
    while(n-- > 0)
 87c:	00c05f63          	blez	a2,89a <memmove+0x2a>
 880:	1602                	slli	a2,a2,0x20
 882:	9201                	srli	a2,a2,0x20
 884:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 888:	872a                	mv	a4,a0
      *dst++ = *src++;
 88a:	0585                	addi	a1,a1,1
 88c:	0705                	addi	a4,a4,1
 88e:	fff5c683          	lbu	a3,-1(a1)
 892:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 896:	fee79ae3          	bne	a5,a4,88a <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 89a:	60a2                	ld	ra,8(sp)
 89c:	6402                	ld	s0,0(sp)
 89e:	0141                	addi	sp,sp,16
 8a0:	8082                	ret
    dst += n;
 8a2:	00c50733          	add	a4,a0,a2
    src += n;
 8a6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 8a8:	fec059e3          	blez	a2,89a <memmove+0x2a>
 8ac:	fff6079b          	addiw	a5,a2,-1
 8b0:	1782                	slli	a5,a5,0x20
 8b2:	9381                	srli	a5,a5,0x20
 8b4:	fff7c793          	not	a5,a5
 8b8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 8ba:	15fd                	addi	a1,a1,-1
 8bc:	177d                	addi	a4,a4,-1
 8be:	0005c683          	lbu	a3,0(a1)
 8c2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 8c6:	fef71ae3          	bne	a4,a5,8ba <memmove+0x4a>
 8ca:	bfc1                	j	89a <memmove+0x2a>

00000000000008cc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 8cc:	1141                	addi	sp,sp,-16
 8ce:	e406                	sd	ra,8(sp)
 8d0:	e022                	sd	s0,0(sp)
 8d2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 8d4:	ca0d                	beqz	a2,906 <memcmp+0x3a>
 8d6:	fff6069b          	addiw	a3,a2,-1
 8da:	1682                	slli	a3,a3,0x20
 8dc:	9281                	srli	a3,a3,0x20
 8de:	0685                	addi	a3,a3,1
 8e0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 8e2:	00054783          	lbu	a5,0(a0)
 8e6:	0005c703          	lbu	a4,0(a1)
 8ea:	00e79863          	bne	a5,a4,8fa <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 8ee:	0505                	addi	a0,a0,1
    p2++;
 8f0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 8f2:	fed518e3          	bne	a0,a3,8e2 <memcmp+0x16>
  }
  return 0;
 8f6:	4501                	li	a0,0
 8f8:	a019                	j	8fe <memcmp+0x32>
      return *p1 - *p2;
 8fa:	40e7853b          	subw	a0,a5,a4
}
 8fe:	60a2                	ld	ra,8(sp)
 900:	6402                	ld	s0,0(sp)
 902:	0141                	addi	sp,sp,16
 904:	8082                	ret
  return 0;
 906:	4501                	li	a0,0
 908:	bfdd                	j	8fe <memcmp+0x32>

000000000000090a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 90a:	1141                	addi	sp,sp,-16
 90c:	e406                	sd	ra,8(sp)
 90e:	e022                	sd	s0,0(sp)
 910:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 912:	00000097          	auipc	ra,0x0
 916:	f5e080e7          	jalr	-162(ra) # 870 <memmove>
}
 91a:	60a2                	ld	ra,8(sp)
 91c:	6402                	ld	s0,0(sp)
 91e:	0141                	addi	sp,sp,16
 920:	8082                	ret

0000000000000922 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 922:	4885                	li	a7,1
 ecall
 924:	00000073          	ecall
 ret
 928:	8082                	ret

000000000000092a <exit>:
.global exit
exit:
 li a7, SYS_exit
 92a:	4889                	li	a7,2
 ecall
 92c:	00000073          	ecall
 ret
 930:	8082                	ret

0000000000000932 <wait>:
.global wait
wait:
 li a7, SYS_wait
 932:	488d                	li	a7,3
 ecall
 934:	00000073          	ecall
 ret
 938:	8082                	ret

000000000000093a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 93a:	4891                	li	a7,4
 ecall
 93c:	00000073          	ecall
 ret
 940:	8082                	ret

0000000000000942 <read>:
.global read
read:
 li a7, SYS_read
 942:	4895                	li	a7,5
 ecall
 944:	00000073          	ecall
 ret
 948:	8082                	ret

000000000000094a <write>:
.global write
write:
 li a7, SYS_write
 94a:	48c1                	li	a7,16
 ecall
 94c:	00000073          	ecall
 ret
 950:	8082                	ret

0000000000000952 <close>:
.global close
close:
 li a7, SYS_close
 952:	48d5                	li	a7,21
 ecall
 954:	00000073          	ecall
 ret
 958:	8082                	ret

000000000000095a <kill>:
.global kill
kill:
 li a7, SYS_kill
 95a:	4899                	li	a7,6
 ecall
 95c:	00000073          	ecall
 ret
 960:	8082                	ret

0000000000000962 <exec>:
.global exec
exec:
 li a7, SYS_exec
 962:	489d                	li	a7,7
 ecall
 964:	00000073          	ecall
 ret
 968:	8082                	ret

000000000000096a <open>:
.global open
open:
 li a7, SYS_open
 96a:	48bd                	li	a7,15
 ecall
 96c:	00000073          	ecall
 ret
 970:	8082                	ret

0000000000000972 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 972:	48c5                	li	a7,17
 ecall
 974:	00000073          	ecall
 ret
 978:	8082                	ret

000000000000097a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 97a:	48c9                	li	a7,18
 ecall
 97c:	00000073          	ecall
 ret
 980:	8082                	ret

0000000000000982 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 982:	48a1                	li	a7,8
 ecall
 984:	00000073          	ecall
 ret
 988:	8082                	ret

000000000000098a <link>:
.global link
link:
 li a7, SYS_link
 98a:	48cd                	li	a7,19
 ecall
 98c:	00000073          	ecall
 ret
 990:	8082                	ret

0000000000000992 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 992:	48d1                	li	a7,20
 ecall
 994:	00000073          	ecall
 ret
 998:	8082                	ret

000000000000099a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 99a:	48a5                	li	a7,9
 ecall
 99c:	00000073          	ecall
 ret
 9a0:	8082                	ret

00000000000009a2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 9a2:	48a9                	li	a7,10
 ecall
 9a4:	00000073          	ecall
 ret
 9a8:	8082                	ret

00000000000009aa <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 9aa:	48ad                	li	a7,11
 ecall
 9ac:	00000073          	ecall
 ret
 9b0:	8082                	ret

00000000000009b2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 9b2:	48b1                	li	a7,12
 ecall
 9b4:	00000073          	ecall
 ret
 9b8:	8082                	ret

00000000000009ba <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 9ba:	48b5                	li	a7,13
 ecall
 9bc:	00000073          	ecall
 ret
 9c0:	8082                	ret

00000000000009c2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 9c2:	48b9                	li	a7,14
 ecall
 9c4:	00000073          	ecall
 ret
 9c8:	8082                	ret

00000000000009ca <ps>:
.global ps
ps:
 li a7, SYS_ps
 9ca:	48d9                	li	a7,22
 ecall
 9cc:	00000073          	ecall
 ret
 9d0:	8082                	ret

00000000000009d2 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
 9d2:	48dd                	li	a7,23
 ecall
 9d4:	00000073          	ecall
 ret
 9d8:	8082                	ret

00000000000009da <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
 9da:	48e1                	li	a7,24
 ecall
 9dc:	00000073          	ecall
 ret
 9e0:	8082                	ret

00000000000009e2 <va2pa>:
.global va2pa
va2pa:
 li a7, SYS_va2pa
 9e2:	48e9                	li	a7,26
 ecall
 9e4:	00000073          	ecall
 ret
 9e8:	8082                	ret

00000000000009ea <pfreepages>:
.global pfreepages
pfreepages:
 li a7, SYS_pfreepages
 9ea:	48e5                	li	a7,25
 ecall
 9ec:	00000073          	ecall
 ret
 9f0:	8082                	ret

00000000000009f2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 9f2:	1101                	addi	sp,sp,-32
 9f4:	ec06                	sd	ra,24(sp)
 9f6:	e822                	sd	s0,16(sp)
 9f8:	1000                	addi	s0,sp,32
 9fa:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 9fe:	4605                	li	a2,1
 a00:	fef40593          	addi	a1,s0,-17
 a04:	00000097          	auipc	ra,0x0
 a08:	f46080e7          	jalr	-186(ra) # 94a <write>
}
 a0c:	60e2                	ld	ra,24(sp)
 a0e:	6442                	ld	s0,16(sp)
 a10:	6105                	addi	sp,sp,32
 a12:	8082                	ret

0000000000000a14 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 a14:	7139                	addi	sp,sp,-64
 a16:	fc06                	sd	ra,56(sp)
 a18:	f822                	sd	s0,48(sp)
 a1a:	f426                	sd	s1,40(sp)
 a1c:	f04a                	sd	s2,32(sp)
 a1e:	ec4e                	sd	s3,24(sp)
 a20:	0080                	addi	s0,sp,64
 a22:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 a24:	c299                	beqz	a3,a2a <printint+0x16>
 a26:	0805c063          	bltz	a1,aa6 <printint+0x92>
  neg = 0;
 a2a:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 a2c:	fc040313          	addi	t1,s0,-64
  neg = 0;
 a30:	869a                	mv	a3,t1
  i = 0;
 a32:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 a34:	00001817          	auipc	a6,0x1
 a38:	81480813          	addi	a6,a6,-2028 # 1248 <digits>
 a3c:	88be                	mv	a7,a5
 a3e:	0017851b          	addiw	a0,a5,1
 a42:	87aa                	mv	a5,a0
 a44:	02c5f73b          	remuw	a4,a1,a2
 a48:	1702                	slli	a4,a4,0x20
 a4a:	9301                	srli	a4,a4,0x20
 a4c:	9742                	add	a4,a4,a6
 a4e:	00074703          	lbu	a4,0(a4)
 a52:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 a56:	872e                	mv	a4,a1
 a58:	02c5d5bb          	divuw	a1,a1,a2
 a5c:	0685                	addi	a3,a3,1
 a5e:	fcc77fe3          	bgeu	a4,a2,a3c <printint+0x28>
  if(neg)
 a62:	000e0c63          	beqz	t3,a7a <printint+0x66>
    buf[i++] = '-';
 a66:	fd050793          	addi	a5,a0,-48
 a6a:	00878533          	add	a0,a5,s0
 a6e:	02d00793          	li	a5,45
 a72:	fef50823          	sb	a5,-16(a0)
 a76:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 a7a:	fff7899b          	addiw	s3,a5,-1
 a7e:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 a82:	fff4c583          	lbu	a1,-1(s1)
 a86:	854a                	mv	a0,s2
 a88:	00000097          	auipc	ra,0x0
 a8c:	f6a080e7          	jalr	-150(ra) # 9f2 <putc>
  while(--i >= 0)
 a90:	39fd                	addiw	s3,s3,-1
 a92:	14fd                	addi	s1,s1,-1
 a94:	fe09d7e3          	bgez	s3,a82 <printint+0x6e>
}
 a98:	70e2                	ld	ra,56(sp)
 a9a:	7442                	ld	s0,48(sp)
 a9c:	74a2                	ld	s1,40(sp)
 a9e:	7902                	ld	s2,32(sp)
 aa0:	69e2                	ld	s3,24(sp)
 aa2:	6121                	addi	sp,sp,64
 aa4:	8082                	ret
    x = -xx;
 aa6:	40b005bb          	negw	a1,a1
    neg = 1;
 aaa:	4e05                	li	t3,1
    x = -xx;
 aac:	b741                	j	a2c <printint+0x18>

0000000000000aae <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 aae:	715d                	addi	sp,sp,-80
 ab0:	e486                	sd	ra,72(sp)
 ab2:	e0a2                	sd	s0,64(sp)
 ab4:	f84a                	sd	s2,48(sp)
 ab6:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 ab8:	0005c903          	lbu	s2,0(a1)
 abc:	1a090a63          	beqz	s2,c70 <vprintf+0x1c2>
 ac0:	fc26                	sd	s1,56(sp)
 ac2:	f44e                	sd	s3,40(sp)
 ac4:	f052                	sd	s4,32(sp)
 ac6:	ec56                	sd	s5,24(sp)
 ac8:	e85a                	sd	s6,16(sp)
 aca:	e45e                	sd	s7,8(sp)
 acc:	8aaa                	mv	s5,a0
 ace:	8bb2                	mv	s7,a2
 ad0:	00158493          	addi	s1,a1,1
  state = 0;
 ad4:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 ad6:	02500a13          	li	s4,37
 ada:	4b55                	li	s6,21
 adc:	a839                	j	afa <vprintf+0x4c>
        putc(fd, c);
 ade:	85ca                	mv	a1,s2
 ae0:	8556                	mv	a0,s5
 ae2:	00000097          	auipc	ra,0x0
 ae6:	f10080e7          	jalr	-240(ra) # 9f2 <putc>
 aea:	a019                	j	af0 <vprintf+0x42>
    } else if(state == '%'){
 aec:	01498d63          	beq	s3,s4,b06 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 af0:	0485                	addi	s1,s1,1
 af2:	fff4c903          	lbu	s2,-1(s1)
 af6:	16090763          	beqz	s2,c64 <vprintf+0x1b6>
    if(state == 0){
 afa:	fe0999e3          	bnez	s3,aec <vprintf+0x3e>
      if(c == '%'){
 afe:	ff4910e3          	bne	s2,s4,ade <vprintf+0x30>
        state = '%';
 b02:	89d2                	mv	s3,s4
 b04:	b7f5                	j	af0 <vprintf+0x42>
      if(c == 'd'){
 b06:	13490463          	beq	s2,s4,c2e <vprintf+0x180>
 b0a:	f9d9079b          	addiw	a5,s2,-99
 b0e:	0ff7f793          	zext.b	a5,a5
 b12:	12fb6763          	bltu	s6,a5,c40 <vprintf+0x192>
 b16:	f9d9079b          	addiw	a5,s2,-99
 b1a:	0ff7f713          	zext.b	a4,a5
 b1e:	12eb6163          	bltu	s6,a4,c40 <vprintf+0x192>
 b22:	00271793          	slli	a5,a4,0x2
 b26:	00000717          	auipc	a4,0x0
 b2a:	6ca70713          	addi	a4,a4,1738 # 11f0 <malloc+0x48c>
 b2e:	97ba                	add	a5,a5,a4
 b30:	439c                	lw	a5,0(a5)
 b32:	97ba                	add	a5,a5,a4
 b34:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 b36:	008b8913          	addi	s2,s7,8
 b3a:	4685                	li	a3,1
 b3c:	4629                	li	a2,10
 b3e:	000ba583          	lw	a1,0(s7)
 b42:	8556                	mv	a0,s5
 b44:	00000097          	auipc	ra,0x0
 b48:	ed0080e7          	jalr	-304(ra) # a14 <printint>
 b4c:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 b4e:	4981                	li	s3,0
 b50:	b745                	j	af0 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 b52:	008b8913          	addi	s2,s7,8
 b56:	4681                	li	a3,0
 b58:	4629                	li	a2,10
 b5a:	000ba583          	lw	a1,0(s7)
 b5e:	8556                	mv	a0,s5
 b60:	00000097          	auipc	ra,0x0
 b64:	eb4080e7          	jalr	-332(ra) # a14 <printint>
 b68:	8bca                	mv	s7,s2
      state = 0;
 b6a:	4981                	li	s3,0
 b6c:	b751                	j	af0 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 b6e:	008b8913          	addi	s2,s7,8
 b72:	4681                	li	a3,0
 b74:	4641                	li	a2,16
 b76:	000ba583          	lw	a1,0(s7)
 b7a:	8556                	mv	a0,s5
 b7c:	00000097          	auipc	ra,0x0
 b80:	e98080e7          	jalr	-360(ra) # a14 <printint>
 b84:	8bca                	mv	s7,s2
      state = 0;
 b86:	4981                	li	s3,0
 b88:	b7a5                	j	af0 <vprintf+0x42>
 b8a:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 b8c:	008b8c13          	addi	s8,s7,8
 b90:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 b94:	03000593          	li	a1,48
 b98:	8556                	mv	a0,s5
 b9a:	00000097          	auipc	ra,0x0
 b9e:	e58080e7          	jalr	-424(ra) # 9f2 <putc>
  putc(fd, 'x');
 ba2:	07800593          	li	a1,120
 ba6:	8556                	mv	a0,s5
 ba8:	00000097          	auipc	ra,0x0
 bac:	e4a080e7          	jalr	-438(ra) # 9f2 <putc>
 bb0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 bb2:	00000b97          	auipc	s7,0x0
 bb6:	696b8b93          	addi	s7,s7,1686 # 1248 <digits>
 bba:	03c9d793          	srli	a5,s3,0x3c
 bbe:	97de                	add	a5,a5,s7
 bc0:	0007c583          	lbu	a1,0(a5)
 bc4:	8556                	mv	a0,s5
 bc6:	00000097          	auipc	ra,0x0
 bca:	e2c080e7          	jalr	-468(ra) # 9f2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 bce:	0992                	slli	s3,s3,0x4
 bd0:	397d                	addiw	s2,s2,-1
 bd2:	fe0914e3          	bnez	s2,bba <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 bd6:	8be2                	mv	s7,s8
      state = 0;
 bd8:	4981                	li	s3,0
 bda:	6c02                	ld	s8,0(sp)
 bdc:	bf11                	j	af0 <vprintf+0x42>
        s = va_arg(ap, char*);
 bde:	008b8993          	addi	s3,s7,8
 be2:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 be6:	02090163          	beqz	s2,c08 <vprintf+0x15a>
        while(*s != 0){
 bea:	00094583          	lbu	a1,0(s2)
 bee:	c9a5                	beqz	a1,c5e <vprintf+0x1b0>
          putc(fd, *s);
 bf0:	8556                	mv	a0,s5
 bf2:	00000097          	auipc	ra,0x0
 bf6:	e00080e7          	jalr	-512(ra) # 9f2 <putc>
          s++;
 bfa:	0905                	addi	s2,s2,1
        while(*s != 0){
 bfc:	00094583          	lbu	a1,0(s2)
 c00:	f9e5                	bnez	a1,bf0 <vprintf+0x142>
        s = va_arg(ap, char*);
 c02:	8bce                	mv	s7,s3
      state = 0;
 c04:	4981                	li	s3,0
 c06:	b5ed                	j	af0 <vprintf+0x42>
          s = "(null)";
 c08:	00000917          	auipc	s2,0x0
 c0c:	5e090913          	addi	s2,s2,1504 # 11e8 <malloc+0x484>
        while(*s != 0){
 c10:	02800593          	li	a1,40
 c14:	bff1                	j	bf0 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 c16:	008b8913          	addi	s2,s7,8
 c1a:	000bc583          	lbu	a1,0(s7)
 c1e:	8556                	mv	a0,s5
 c20:	00000097          	auipc	ra,0x0
 c24:	dd2080e7          	jalr	-558(ra) # 9f2 <putc>
 c28:	8bca                	mv	s7,s2
      state = 0;
 c2a:	4981                	li	s3,0
 c2c:	b5d1                	j	af0 <vprintf+0x42>
        putc(fd, c);
 c2e:	02500593          	li	a1,37
 c32:	8556                	mv	a0,s5
 c34:	00000097          	auipc	ra,0x0
 c38:	dbe080e7          	jalr	-578(ra) # 9f2 <putc>
      state = 0;
 c3c:	4981                	li	s3,0
 c3e:	bd4d                	j	af0 <vprintf+0x42>
        putc(fd, '%');
 c40:	02500593          	li	a1,37
 c44:	8556                	mv	a0,s5
 c46:	00000097          	auipc	ra,0x0
 c4a:	dac080e7          	jalr	-596(ra) # 9f2 <putc>
        putc(fd, c);
 c4e:	85ca                	mv	a1,s2
 c50:	8556                	mv	a0,s5
 c52:	00000097          	auipc	ra,0x0
 c56:	da0080e7          	jalr	-608(ra) # 9f2 <putc>
      state = 0;
 c5a:	4981                	li	s3,0
 c5c:	bd51                	j	af0 <vprintf+0x42>
        s = va_arg(ap, char*);
 c5e:	8bce                	mv	s7,s3
      state = 0;
 c60:	4981                	li	s3,0
 c62:	b579                	j	af0 <vprintf+0x42>
 c64:	74e2                	ld	s1,56(sp)
 c66:	79a2                	ld	s3,40(sp)
 c68:	7a02                	ld	s4,32(sp)
 c6a:	6ae2                	ld	s5,24(sp)
 c6c:	6b42                	ld	s6,16(sp)
 c6e:	6ba2                	ld	s7,8(sp)
    }
  }
}
 c70:	60a6                	ld	ra,72(sp)
 c72:	6406                	ld	s0,64(sp)
 c74:	7942                	ld	s2,48(sp)
 c76:	6161                	addi	sp,sp,80
 c78:	8082                	ret

0000000000000c7a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 c7a:	715d                	addi	sp,sp,-80
 c7c:	ec06                	sd	ra,24(sp)
 c7e:	e822                	sd	s0,16(sp)
 c80:	1000                	addi	s0,sp,32
 c82:	e010                	sd	a2,0(s0)
 c84:	e414                	sd	a3,8(s0)
 c86:	e818                	sd	a4,16(s0)
 c88:	ec1c                	sd	a5,24(s0)
 c8a:	03043023          	sd	a6,32(s0)
 c8e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 c92:	8622                	mv	a2,s0
 c94:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 c98:	00000097          	auipc	ra,0x0
 c9c:	e16080e7          	jalr	-490(ra) # aae <vprintf>
}
 ca0:	60e2                	ld	ra,24(sp)
 ca2:	6442                	ld	s0,16(sp)
 ca4:	6161                	addi	sp,sp,80
 ca6:	8082                	ret

0000000000000ca8 <printf>:

void
printf(const char *fmt, ...)
{
 ca8:	711d                	addi	sp,sp,-96
 caa:	ec06                	sd	ra,24(sp)
 cac:	e822                	sd	s0,16(sp)
 cae:	1000                	addi	s0,sp,32
 cb0:	e40c                	sd	a1,8(s0)
 cb2:	e810                	sd	a2,16(s0)
 cb4:	ec14                	sd	a3,24(s0)
 cb6:	f018                	sd	a4,32(s0)
 cb8:	f41c                	sd	a5,40(s0)
 cba:	03043823          	sd	a6,48(s0)
 cbe:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 cc2:	00840613          	addi	a2,s0,8
 cc6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 cca:	85aa                	mv	a1,a0
 ccc:	4505                	li	a0,1
 cce:	00000097          	auipc	ra,0x0
 cd2:	de0080e7          	jalr	-544(ra) # aae <vprintf>
}
 cd6:	60e2                	ld	ra,24(sp)
 cd8:	6442                	ld	s0,16(sp)
 cda:	6125                	addi	sp,sp,96
 cdc:	8082                	ret

0000000000000cde <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 cde:	1141                	addi	sp,sp,-16
 ce0:	e406                	sd	ra,8(sp)
 ce2:	e022                	sd	s0,0(sp)
 ce4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 ce6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cea:	00001797          	auipc	a5,0x1
 cee:	31e7b783          	ld	a5,798(a5) # 2008 <freep>
 cf2:	a02d                	j	d1c <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 cf4:	4618                	lw	a4,8(a2)
 cf6:	9f2d                	addw	a4,a4,a1
 cf8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 cfc:	6398                	ld	a4,0(a5)
 cfe:	6310                	ld	a2,0(a4)
 d00:	a83d                	j	d3e <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 d02:	ff852703          	lw	a4,-8(a0)
 d06:	9f31                	addw	a4,a4,a2
 d08:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 d0a:	ff053683          	ld	a3,-16(a0)
 d0e:	a091                	j	d52 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d10:	6398                	ld	a4,0(a5)
 d12:	00e7e463          	bltu	a5,a4,d1a <free+0x3c>
 d16:	00e6ea63          	bltu	a3,a4,d2a <free+0x4c>
{
 d1a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d1c:	fed7fae3          	bgeu	a5,a3,d10 <free+0x32>
 d20:	6398                	ld	a4,0(a5)
 d22:	00e6e463          	bltu	a3,a4,d2a <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d26:	fee7eae3          	bltu	a5,a4,d1a <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 d2a:	ff852583          	lw	a1,-8(a0)
 d2e:	6390                	ld	a2,0(a5)
 d30:	02059813          	slli	a6,a1,0x20
 d34:	01c85713          	srli	a4,a6,0x1c
 d38:	9736                	add	a4,a4,a3
 d3a:	fae60de3          	beq	a2,a4,cf4 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 d3e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 d42:	4790                	lw	a2,8(a5)
 d44:	02061593          	slli	a1,a2,0x20
 d48:	01c5d713          	srli	a4,a1,0x1c
 d4c:	973e                	add	a4,a4,a5
 d4e:	fae68ae3          	beq	a3,a4,d02 <free+0x24>
    p->s.ptr = bp->s.ptr;
 d52:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 d54:	00001717          	auipc	a4,0x1
 d58:	2af73a23          	sd	a5,692(a4) # 2008 <freep>
}
 d5c:	60a2                	ld	ra,8(sp)
 d5e:	6402                	ld	s0,0(sp)
 d60:	0141                	addi	sp,sp,16
 d62:	8082                	ret

0000000000000d64 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 d64:	7139                	addi	sp,sp,-64
 d66:	fc06                	sd	ra,56(sp)
 d68:	f822                	sd	s0,48(sp)
 d6a:	f04a                	sd	s2,32(sp)
 d6c:	ec4e                	sd	s3,24(sp)
 d6e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d70:	02051993          	slli	s3,a0,0x20
 d74:	0209d993          	srli	s3,s3,0x20
 d78:	09bd                	addi	s3,s3,15
 d7a:	0049d993          	srli	s3,s3,0x4
 d7e:	2985                	addiw	s3,s3,1
 d80:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 d82:	00001517          	auipc	a0,0x1
 d86:	28653503          	ld	a0,646(a0) # 2008 <freep>
 d8a:	c905                	beqz	a0,dba <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d8c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 d8e:	4798                	lw	a4,8(a5)
 d90:	09377a63          	bgeu	a4,s3,e24 <malloc+0xc0>
 d94:	f426                	sd	s1,40(sp)
 d96:	e852                	sd	s4,16(sp)
 d98:	e456                	sd	s5,8(sp)
 d9a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 d9c:	8a4e                	mv	s4,s3
 d9e:	6705                	lui	a4,0x1
 da0:	00e9f363          	bgeu	s3,a4,da6 <malloc+0x42>
 da4:	6a05                	lui	s4,0x1
 da6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 daa:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 dae:	00001497          	auipc	s1,0x1
 db2:	25a48493          	addi	s1,s1,602 # 2008 <freep>
  if(p == (char*)-1)
 db6:	5afd                	li	s5,-1
 db8:	a089                	j	dfa <malloc+0x96>
 dba:	f426                	sd	s1,40(sp)
 dbc:	e852                	sd	s4,16(sp)
 dbe:	e456                	sd	s5,8(sp)
 dc0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 dc2:	04001797          	auipc	a5,0x4001
 dc6:	24e78793          	addi	a5,a5,590 # 4002010 <base>
 dca:	00001717          	auipc	a4,0x1
 dce:	22f73f23          	sd	a5,574(a4) # 2008 <freep>
 dd2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 dd4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 dd8:	b7d1                	j	d9c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 dda:	6398                	ld	a4,0(a5)
 ddc:	e118                	sd	a4,0(a0)
 dde:	a8b9                	j	e3c <malloc+0xd8>
  hp->s.size = nu;
 de0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 de4:	0541                	addi	a0,a0,16
 de6:	00000097          	auipc	ra,0x0
 dea:	ef8080e7          	jalr	-264(ra) # cde <free>
  return freep;
 dee:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 df0:	c135                	beqz	a0,e54 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 df2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 df4:	4798                	lw	a4,8(a5)
 df6:	03277363          	bgeu	a4,s2,e1c <malloc+0xb8>
    if(p == freep)
 dfa:	6098                	ld	a4,0(s1)
 dfc:	853e                	mv	a0,a5
 dfe:	fef71ae3          	bne	a4,a5,df2 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 e02:	8552                	mv	a0,s4
 e04:	00000097          	auipc	ra,0x0
 e08:	bae080e7          	jalr	-1106(ra) # 9b2 <sbrk>
  if(p == (char*)-1)
 e0c:	fd551ae3          	bne	a0,s5,de0 <malloc+0x7c>
        return 0;
 e10:	4501                	li	a0,0
 e12:	74a2                	ld	s1,40(sp)
 e14:	6a42                	ld	s4,16(sp)
 e16:	6aa2                	ld	s5,8(sp)
 e18:	6b02                	ld	s6,0(sp)
 e1a:	a03d                	j	e48 <malloc+0xe4>
 e1c:	74a2                	ld	s1,40(sp)
 e1e:	6a42                	ld	s4,16(sp)
 e20:	6aa2                	ld	s5,8(sp)
 e22:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 e24:	fae90be3          	beq	s2,a4,dda <malloc+0x76>
        p->s.size -= nunits;
 e28:	4137073b          	subw	a4,a4,s3
 e2c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 e2e:	02071693          	slli	a3,a4,0x20
 e32:	01c6d713          	srli	a4,a3,0x1c
 e36:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 e38:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 e3c:	00001717          	auipc	a4,0x1
 e40:	1ca73623          	sd	a0,460(a4) # 2008 <freep>
      return (void*)(p + 1);
 e44:	01078513          	addi	a0,a5,16
  }
}
 e48:	70e2                	ld	ra,56(sp)
 e4a:	7442                	ld	s0,48(sp)
 e4c:	7902                	ld	s2,32(sp)
 e4e:	69e2                	ld	s3,24(sp)
 e50:	6121                	addi	sp,sp,64
 e52:	8082                	ret
 e54:	74a2                	ld	s1,40(sp)
 e56:	6a42                	ld	s4,16(sp)
 e58:	6aa2                	ld	s5,8(sp)
 e5a:	6b02                	ld	s6,0(sp)
 e5c:	b7f5                	j	e48 <malloc+0xe4>
