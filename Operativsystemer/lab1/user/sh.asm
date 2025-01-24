
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <runcmd>:
void runcmd(struct cmd*) __attribute__((noreturn));

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
       0:	715d                	addi	sp,sp,-80
       2:	e486                	sd	ra,72(sp)
       4:	e0a2                	sd	s0,64(sp)
       6:	0880                	addi	s0,sp,80
       8:	faa43c23          	sd	a0,-72(s0)
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
       c:	fb843783          	ld	a5,-72(s0)
      10:	e791                	bnez	a5,1c <runcmd+0x1c>
    exit(1);
      12:	4505                	li	a0,1
      14:	00001097          	auipc	ra,0x1
      18:	3fa080e7          	jalr	1018(ra) # 140e <exit>

  switch(cmd->type){
      1c:	fb843783          	ld	a5,-72(s0)
      20:	439c                	lw	a5,0(a5)
      22:	4715                	li	a4,5
      24:	02f76263          	bltu	a4,a5,48 <runcmd+0x48>
      28:	00279713          	slli	a4,a5,0x2
      2c:	00002797          	auipc	a5,0x2
      30:	c7478793          	addi	a5,a5,-908 # 1ca0 <malloc+0x172>
      34:	97ba                	add	a5,a5,a4
      36:	439c                	lw	a5,0(a5)
      38:	0007871b          	sext.w	a4,a5
      3c:	00002797          	auipc	a5,0x2
      40:	c6478793          	addi	a5,a5,-924 # 1ca0 <malloc+0x172>
      44:	97ba                	add	a5,a5,a4
      46:	8782                	jr	a5
  default:
    panic("runcmd");
      48:	00002517          	auipc	a0,0x2
      4c:	c2850513          	addi	a0,a0,-984 # 1c70 <malloc+0x142>
      50:	00000097          	auipc	ra,0x0
      54:	3d8080e7          	jalr	984(ra) # 428 <panic>

  case EXEC:
    ecmd = (struct execcmd*)cmd;
      58:	fb843783          	ld	a5,-72(s0)
      5c:	fcf43423          	sd	a5,-56(s0)
    if(ecmd->argv[0] == 0)
      60:	fc843783          	ld	a5,-56(s0)
      64:	679c                	ld	a5,8(a5)
      66:	e791                	bnez	a5,72 <runcmd+0x72>
      exit(1);
      68:	4505                	li	a0,1
      6a:	00001097          	auipc	ra,0x1
      6e:	3a4080e7          	jalr	932(ra) # 140e <exit>
    exec(ecmd->argv[0], ecmd->argv);
      72:	fc843783          	ld	a5,-56(s0)
      76:	6798                	ld	a4,8(a5)
      78:	fc843783          	ld	a5,-56(s0)
      7c:	07a1                	addi	a5,a5,8
      7e:	85be                	mv	a1,a5
      80:	853a                	mv	a0,a4
      82:	00001097          	auipc	ra,0x1
      86:	3c4080e7          	jalr	964(ra) # 1446 <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
      8a:	fc843783          	ld	a5,-56(s0)
      8e:	679c                	ld	a5,8(a5)
      90:	863e                	mv	a2,a5
      92:	00002597          	auipc	a1,0x2
      96:	be658593          	addi	a1,a1,-1050 # 1c78 <malloc+0x14a>
      9a:	4509                	li	a0,2
      9c:	00002097          	auipc	ra,0x2
      a0:	846080e7          	jalr	-1978(ra) # 18e2 <fprintf>
    break;
      a4:	a2f9                	j	272 <runcmd+0x272>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
      a6:	fb843783          	ld	a5,-72(s0)
      aa:	fcf43823          	sd	a5,-48(s0)
    close(rcmd->fd);
      ae:	fd043783          	ld	a5,-48(s0)
      b2:	53dc                	lw	a5,36(a5)
      b4:	853e                	mv	a0,a5
      b6:	00001097          	auipc	ra,0x1
      ba:	380080e7          	jalr	896(ra) # 1436 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
      be:	fd043783          	ld	a5,-48(s0)
      c2:	6b98                	ld	a4,16(a5)
      c4:	fd043783          	ld	a5,-48(s0)
      c8:	539c                	lw	a5,32(a5)
      ca:	85be                	mv	a1,a5
      cc:	853a                	mv	a0,a4
      ce:	00001097          	auipc	ra,0x1
      d2:	380080e7          	jalr	896(ra) # 144e <open>
      d6:	87aa                	mv	a5,a0
      d8:	0207d463          	bgez	a5,100 <runcmd+0x100>
      fprintf(2, "open %s failed\n", rcmd->file);
      dc:	fd043783          	ld	a5,-48(s0)
      e0:	6b9c                	ld	a5,16(a5)
      e2:	863e                	mv	a2,a5
      e4:	00002597          	auipc	a1,0x2
      e8:	ba458593          	addi	a1,a1,-1116 # 1c88 <malloc+0x15a>
      ec:	4509                	li	a0,2
      ee:	00001097          	auipc	ra,0x1
      f2:	7f4080e7          	jalr	2036(ra) # 18e2 <fprintf>
      exit(1);
      f6:	4505                	li	a0,1
      f8:	00001097          	auipc	ra,0x1
      fc:	316080e7          	jalr	790(ra) # 140e <exit>
    }
    runcmd(rcmd->cmd);
     100:	fd043783          	ld	a5,-48(s0)
     104:	679c                	ld	a5,8(a5)
     106:	853e                	mv	a0,a5
     108:	00000097          	auipc	ra,0x0
     10c:	ef8080e7          	jalr	-264(ra) # 0 <runcmd>
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
     110:	fb843783          	ld	a5,-72(s0)
     114:	fef43023          	sd	a5,-32(s0)
    if(fork1() == 0)
     118:	00000097          	auipc	ra,0x0
     11c:	33c080e7          	jalr	828(ra) # 454 <fork1>
     120:	87aa                	mv	a5,a0
     122:	eb89                	bnez	a5,134 <runcmd+0x134>
      runcmd(lcmd->left);
     124:	fe043783          	ld	a5,-32(s0)
     128:	679c                	ld	a5,8(a5)
     12a:	853e                	mv	a0,a5
     12c:	00000097          	auipc	ra,0x0
     130:	ed4080e7          	jalr	-300(ra) # 0 <runcmd>
    wait(0);
     134:	4501                	li	a0,0
     136:	00001097          	auipc	ra,0x1
     13a:	2e0080e7          	jalr	736(ra) # 1416 <wait>
    runcmd(lcmd->right);
     13e:	fe043783          	ld	a5,-32(s0)
     142:	6b9c                	ld	a5,16(a5)
     144:	853e                	mv	a0,a5
     146:	00000097          	auipc	ra,0x0
     14a:	eba080e7          	jalr	-326(ra) # 0 <runcmd>
    break;

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     14e:	fb843783          	ld	a5,-72(s0)
     152:	fcf43c23          	sd	a5,-40(s0)
    if(pipe(p) < 0)
     156:	fc040793          	addi	a5,s0,-64
     15a:	853e                	mv	a0,a5
     15c:	00001097          	auipc	ra,0x1
     160:	2c2080e7          	jalr	706(ra) # 141e <pipe>
     164:	87aa                	mv	a5,a0
     166:	0007da63          	bgez	a5,17a <runcmd+0x17a>
      panic("pipe");
     16a:	00002517          	auipc	a0,0x2
     16e:	b2e50513          	addi	a0,a0,-1234 # 1c98 <malloc+0x16a>
     172:	00000097          	auipc	ra,0x0
     176:	2b6080e7          	jalr	694(ra) # 428 <panic>
    if(fork1() == 0){
     17a:	00000097          	auipc	ra,0x0
     17e:	2da080e7          	jalr	730(ra) # 454 <fork1>
     182:	87aa                	mv	a5,a0
     184:	e3b9                	bnez	a5,1ca <runcmd+0x1ca>
      close(1);
     186:	4505                	li	a0,1
     188:	00001097          	auipc	ra,0x1
     18c:	2ae080e7          	jalr	686(ra) # 1436 <close>
      dup(p[1]);
     190:	fc442783          	lw	a5,-60(s0)
     194:	853e                	mv	a0,a5
     196:	00001097          	auipc	ra,0x1
     19a:	2f0080e7          	jalr	752(ra) # 1486 <dup>
      close(p[0]);
     19e:	fc042783          	lw	a5,-64(s0)
     1a2:	853e                	mv	a0,a5
     1a4:	00001097          	auipc	ra,0x1
     1a8:	292080e7          	jalr	658(ra) # 1436 <close>
      close(p[1]);
     1ac:	fc442783          	lw	a5,-60(s0)
     1b0:	853e                	mv	a0,a5
     1b2:	00001097          	auipc	ra,0x1
     1b6:	284080e7          	jalr	644(ra) # 1436 <close>
      runcmd(pcmd->left);
     1ba:	fd843783          	ld	a5,-40(s0)
     1be:	679c                	ld	a5,8(a5)
     1c0:	853e                	mv	a0,a5
     1c2:	00000097          	auipc	ra,0x0
     1c6:	e3e080e7          	jalr	-450(ra) # 0 <runcmd>
    }
    if(fork1() == 0){
     1ca:	00000097          	auipc	ra,0x0
     1ce:	28a080e7          	jalr	650(ra) # 454 <fork1>
     1d2:	87aa                	mv	a5,a0
     1d4:	e3b9                	bnez	a5,21a <runcmd+0x21a>
      close(0);
     1d6:	4501                	li	a0,0
     1d8:	00001097          	auipc	ra,0x1
     1dc:	25e080e7          	jalr	606(ra) # 1436 <close>
      dup(p[0]);
     1e0:	fc042783          	lw	a5,-64(s0)
     1e4:	853e                	mv	a0,a5
     1e6:	00001097          	auipc	ra,0x1
     1ea:	2a0080e7          	jalr	672(ra) # 1486 <dup>
      close(p[0]);
     1ee:	fc042783          	lw	a5,-64(s0)
     1f2:	853e                	mv	a0,a5
     1f4:	00001097          	auipc	ra,0x1
     1f8:	242080e7          	jalr	578(ra) # 1436 <close>
      close(p[1]);
     1fc:	fc442783          	lw	a5,-60(s0)
     200:	853e                	mv	a0,a5
     202:	00001097          	auipc	ra,0x1
     206:	234080e7          	jalr	564(ra) # 1436 <close>
      runcmd(pcmd->right);
     20a:	fd843783          	ld	a5,-40(s0)
     20e:	6b9c                	ld	a5,16(a5)
     210:	853e                	mv	a0,a5
     212:	00000097          	auipc	ra,0x0
     216:	dee080e7          	jalr	-530(ra) # 0 <runcmd>
    }
    close(p[0]);
     21a:	fc042783          	lw	a5,-64(s0)
     21e:	853e                	mv	a0,a5
     220:	00001097          	auipc	ra,0x1
     224:	216080e7          	jalr	534(ra) # 1436 <close>
    close(p[1]);
     228:	fc442783          	lw	a5,-60(s0)
     22c:	853e                	mv	a0,a5
     22e:	00001097          	auipc	ra,0x1
     232:	208080e7          	jalr	520(ra) # 1436 <close>
    wait(0);
     236:	4501                	li	a0,0
     238:	00001097          	auipc	ra,0x1
     23c:	1de080e7          	jalr	478(ra) # 1416 <wait>
    wait(0);
     240:	4501                	li	a0,0
     242:	00001097          	auipc	ra,0x1
     246:	1d4080e7          	jalr	468(ra) # 1416 <wait>
    break;
     24a:	a025                	j	272 <runcmd+0x272>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     24c:	fb843783          	ld	a5,-72(s0)
     250:	fef43423          	sd	a5,-24(s0)
    if(fork1() == 0)
     254:	00000097          	auipc	ra,0x0
     258:	200080e7          	jalr	512(ra) # 454 <fork1>
     25c:	87aa                	mv	a5,a0
     25e:	eb89                	bnez	a5,270 <runcmd+0x270>
      runcmd(bcmd->cmd);
     260:	fe843783          	ld	a5,-24(s0)
     264:	679c                	ld	a5,8(a5)
     266:	853e                	mv	a0,a5
     268:	00000097          	auipc	ra,0x0
     26c:	d98080e7          	jalr	-616(ra) # 0 <runcmd>
    break;
     270:	0001                	nop
  }
  exit(0);
     272:	4501                	li	a0,0
     274:	00001097          	auipc	ra,0x1
     278:	19a080e7          	jalr	410(ra) # 140e <exit>

000000000000027c <getcmd>:
}

int
getcmd(char *buf, int nbuf)
{
     27c:	1101                	addi	sp,sp,-32
     27e:	ec06                	sd	ra,24(sp)
     280:	e822                	sd	s0,16(sp)
     282:	1000                	addi	s0,sp,32
     284:	fea43423          	sd	a0,-24(s0)
     288:	87ae                	mv	a5,a1
     28a:	fef42223          	sw	a5,-28(s0)
  write(2, "$ ", 2);
     28e:	4609                	li	a2,2
     290:	00002597          	auipc	a1,0x2
     294:	a2858593          	addi	a1,a1,-1496 # 1cb8 <malloc+0x18a>
     298:	4509                	li	a0,2
     29a:	00001097          	auipc	ra,0x1
     29e:	194080e7          	jalr	404(ra) # 142e <write>
  memset(buf, 0, nbuf);
     2a2:	fe442783          	lw	a5,-28(s0)
     2a6:	863e                	mv	a2,a5
     2a8:	4581                	li	a1,0
     2aa:	fe843503          	ld	a0,-24(s0)
     2ae:	00001097          	auipc	ra,0x1
     2b2:	da2080e7          	jalr	-606(ra) # 1050 <memset>
  gets(buf, nbuf);
     2b6:	fe442783          	lw	a5,-28(s0)
     2ba:	85be                	mv	a1,a5
     2bc:	fe843503          	ld	a0,-24(s0)
     2c0:	00001097          	auipc	ra,0x1
     2c4:	e42080e7          	jalr	-446(ra) # 1102 <gets>
  if(buf[0] == 0) // EOF
     2c8:	fe843783          	ld	a5,-24(s0)
     2cc:	0007c783          	lbu	a5,0(a5)
     2d0:	e399                	bnez	a5,2d6 <getcmd+0x5a>
    return -1;
     2d2:	57fd                	li	a5,-1
     2d4:	a011                	j	2d8 <getcmd+0x5c>
  return 0;
     2d6:	4781                	li	a5,0
}
     2d8:	853e                	mv	a0,a5
     2da:	60e2                	ld	ra,24(sp)
     2dc:	6442                	ld	s0,16(sp)
     2de:	6105                	addi	sp,sp,32
     2e0:	8082                	ret

00000000000002e2 <main>:

int
main(void)
{
     2e2:	1101                	addi	sp,sp,-32
     2e4:	ec06                	sd	ra,24(sp)
     2e6:	e822                	sd	s0,16(sp)
     2e8:	1000                	addi	s0,sp,32
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
     2ea:	a005                	j	30a <main+0x28>
    if(fd >= 3){
     2ec:	fec42783          	lw	a5,-20(s0)
     2f0:	0007871b          	sext.w	a4,a5
     2f4:	4789                	li	a5,2
     2f6:	00e7da63          	bge	a5,a4,30a <main+0x28>
      close(fd);
     2fa:	fec42783          	lw	a5,-20(s0)
     2fe:	853e                	mv	a0,a5
     300:	00001097          	auipc	ra,0x1
     304:	136080e7          	jalr	310(ra) # 1436 <close>
      break;
     308:	a015                	j	32c <main+0x4a>
  while((fd = open("console", O_RDWR)) >= 0){
     30a:	4589                	li	a1,2
     30c:	00002517          	auipc	a0,0x2
     310:	9b450513          	addi	a0,a0,-1612 # 1cc0 <malloc+0x192>
     314:	00001097          	auipc	ra,0x1
     318:	13a080e7          	jalr	314(ra) # 144e <open>
     31c:	87aa                	mv	a5,a0
     31e:	fef42623          	sw	a5,-20(s0)
     322:	fec42783          	lw	a5,-20(s0)
     326:	2781                	sext.w	a5,a5
     328:	fc07d2e3          	bgez	a5,2ec <main+0xa>
    }
  }

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     32c:	a8e1                	j	404 <main+0x122>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     32e:	00002797          	auipc	a5,0x2
     332:	d0278793          	addi	a5,a5,-766 # 2030 <buf.0>
     336:	0007c783          	lbu	a5,0(a5)
     33a:	873e                	mv	a4,a5
     33c:	06300793          	li	a5,99
     340:	08f71763          	bne	a4,a5,3ce <main+0xec>
     344:	00002797          	auipc	a5,0x2
     348:	cec78793          	addi	a5,a5,-788 # 2030 <buf.0>
     34c:	0017c783          	lbu	a5,1(a5)
     350:	873e                	mv	a4,a5
     352:	06400793          	li	a5,100
     356:	06f71c63          	bne	a4,a5,3ce <main+0xec>
     35a:	00002797          	auipc	a5,0x2
     35e:	cd678793          	addi	a5,a5,-810 # 2030 <buf.0>
     362:	0027c783          	lbu	a5,2(a5)
     366:	873e                	mv	a4,a5
     368:	02000793          	li	a5,32
     36c:	06f71163          	bne	a4,a5,3ce <main+0xec>
      // Chdir must be called by the parent, not the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     370:	00002517          	auipc	a0,0x2
     374:	cc050513          	addi	a0,a0,-832 # 2030 <buf.0>
     378:	00001097          	auipc	ra,0x1
     37c:	c9e080e7          	jalr	-866(ra) # 1016 <strlen>
     380:	87aa                	mv	a5,a0
     382:	37fd                	addiw	a5,a5,-1
     384:	2781                	sext.w	a5,a5
     386:	00002717          	auipc	a4,0x2
     38a:	caa70713          	addi	a4,a4,-854 # 2030 <buf.0>
     38e:	1782                	slli	a5,a5,0x20
     390:	9381                	srli	a5,a5,0x20
     392:	97ba                	add	a5,a5,a4
     394:	00078023          	sb	zero,0(a5)
      if(chdir(buf+3) < 0)
     398:	00002797          	auipc	a5,0x2
     39c:	c9b78793          	addi	a5,a5,-869 # 2033 <buf.0+0x3>
     3a0:	853e                	mv	a0,a5
     3a2:	00001097          	auipc	ra,0x1
     3a6:	0dc080e7          	jalr	220(ra) # 147e <chdir>
     3aa:	87aa                	mv	a5,a0
     3ac:	0407db63          	bgez	a5,402 <main+0x120>
        fprintf(2, "cannot cd %s\n", buf+3);
     3b0:	00002797          	auipc	a5,0x2
     3b4:	c8378793          	addi	a5,a5,-893 # 2033 <buf.0+0x3>
     3b8:	863e                	mv	a2,a5
     3ba:	00002597          	auipc	a1,0x2
     3be:	90e58593          	addi	a1,a1,-1778 # 1cc8 <malloc+0x19a>
     3c2:	4509                	li	a0,2
     3c4:	00001097          	auipc	ra,0x1
     3c8:	51e080e7          	jalr	1310(ra) # 18e2 <fprintf>
      continue;
     3cc:	a81d                	j	402 <main+0x120>
    }
    if(fork1() == 0)
     3ce:	00000097          	auipc	ra,0x0
     3d2:	086080e7          	jalr	134(ra) # 454 <fork1>
     3d6:	87aa                	mv	a5,a0
     3d8:	ef99                	bnez	a5,3f6 <main+0x114>
      runcmd(parsecmd(buf));
     3da:	00002517          	auipc	a0,0x2
     3de:	c5650513          	addi	a0,a0,-938 # 2030 <buf.0>
     3e2:	00000097          	auipc	ra,0x0
     3e6:	4d4080e7          	jalr	1236(ra) # 8b6 <parsecmd>
     3ea:	87aa                	mv	a5,a0
     3ec:	853e                	mv	a0,a5
     3ee:	00000097          	auipc	ra,0x0
     3f2:	c12080e7          	jalr	-1006(ra) # 0 <runcmd>
    wait(0);
     3f6:	4501                	li	a0,0
     3f8:	00001097          	auipc	ra,0x1
     3fc:	01e080e7          	jalr	30(ra) # 1416 <wait>
     400:	a011                	j	404 <main+0x122>
      continue;
     402:	0001                	nop
  while(getcmd(buf, sizeof(buf)) >= 0){
     404:	06400593          	li	a1,100
     408:	00002517          	auipc	a0,0x2
     40c:	c2850513          	addi	a0,a0,-984 # 2030 <buf.0>
     410:	00000097          	auipc	ra,0x0
     414:	e6c080e7          	jalr	-404(ra) # 27c <getcmd>
     418:	87aa                	mv	a5,a0
     41a:	f007dae3          	bgez	a5,32e <main+0x4c>
  }
  exit(0);
     41e:	4501                	li	a0,0
     420:	00001097          	auipc	ra,0x1
     424:	fee080e7          	jalr	-18(ra) # 140e <exit>

0000000000000428 <panic>:
}

void
panic(char *s)
{
     428:	1101                	addi	sp,sp,-32
     42a:	ec06                	sd	ra,24(sp)
     42c:	e822                	sd	s0,16(sp)
     42e:	1000                	addi	s0,sp,32
     430:	fea43423          	sd	a0,-24(s0)
  fprintf(2, "%s\n", s);
     434:	fe843603          	ld	a2,-24(s0)
     438:	00002597          	auipc	a1,0x2
     43c:	8a058593          	addi	a1,a1,-1888 # 1cd8 <malloc+0x1aa>
     440:	4509                	li	a0,2
     442:	00001097          	auipc	ra,0x1
     446:	4a0080e7          	jalr	1184(ra) # 18e2 <fprintf>
  exit(1);
     44a:	4505                	li	a0,1
     44c:	00001097          	auipc	ra,0x1
     450:	fc2080e7          	jalr	-62(ra) # 140e <exit>

0000000000000454 <fork1>:
}

int
fork1(void)
{
     454:	1101                	addi	sp,sp,-32
     456:	ec06                	sd	ra,24(sp)
     458:	e822                	sd	s0,16(sp)
     45a:	1000                	addi	s0,sp,32
  int pid;

  pid = fork();
     45c:	00001097          	auipc	ra,0x1
     460:	faa080e7          	jalr	-86(ra) # 1406 <fork>
     464:	87aa                	mv	a5,a0
     466:	fef42623          	sw	a5,-20(s0)
  if(pid == -1)
     46a:	fec42783          	lw	a5,-20(s0)
     46e:	0007871b          	sext.w	a4,a5
     472:	57fd                	li	a5,-1
     474:	00f71a63          	bne	a4,a5,488 <fork1+0x34>
    panic("fork");
     478:	00002517          	auipc	a0,0x2
     47c:	86850513          	addi	a0,a0,-1944 # 1ce0 <malloc+0x1b2>
     480:	00000097          	auipc	ra,0x0
     484:	fa8080e7          	jalr	-88(ra) # 428 <panic>
  return pid;
     488:	fec42783          	lw	a5,-20(s0)
}
     48c:	853e                	mv	a0,a5
     48e:	60e2                	ld	ra,24(sp)
     490:	6442                	ld	s0,16(sp)
     492:	6105                	addi	sp,sp,32
     494:	8082                	ret

0000000000000496 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     496:	1101                	addi	sp,sp,-32
     498:	ec06                	sd	ra,24(sp)
     49a:	e822                	sd	s0,16(sp)
     49c:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     49e:	0a800513          	li	a0,168
     4a2:	00001097          	auipc	ra,0x1
     4a6:	68c080e7          	jalr	1676(ra) # 1b2e <malloc>
     4aa:	fea43423          	sd	a0,-24(s0)
  memset(cmd, 0, sizeof(*cmd));
     4ae:	0a800613          	li	a2,168
     4b2:	4581                	li	a1,0
     4b4:	fe843503          	ld	a0,-24(s0)
     4b8:	00001097          	auipc	ra,0x1
     4bc:	b98080e7          	jalr	-1128(ra) # 1050 <memset>
  cmd->type = EXEC;
     4c0:	fe843783          	ld	a5,-24(s0)
     4c4:	4705                	li	a4,1
     4c6:	c398                	sw	a4,0(a5)
  return (struct cmd*)cmd;
     4c8:	fe843783          	ld	a5,-24(s0)
}
     4cc:	853e                	mv	a0,a5
     4ce:	60e2                	ld	ra,24(sp)
     4d0:	6442                	ld	s0,16(sp)
     4d2:	6105                	addi	sp,sp,32
     4d4:	8082                	ret

00000000000004d6 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     4d6:	7139                	addi	sp,sp,-64
     4d8:	fc06                	sd	ra,56(sp)
     4da:	f822                	sd	s0,48(sp)
     4dc:	0080                	addi	s0,sp,64
     4de:	fca43c23          	sd	a0,-40(s0)
     4e2:	fcb43823          	sd	a1,-48(s0)
     4e6:	fcc43423          	sd	a2,-56(s0)
     4ea:	87b6                	mv	a5,a3
     4ec:	fcf42223          	sw	a5,-60(s0)
     4f0:	87ba                	mv	a5,a4
     4f2:	fcf42023          	sw	a5,-64(s0)
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4f6:	02800513          	li	a0,40
     4fa:	00001097          	auipc	ra,0x1
     4fe:	634080e7          	jalr	1588(ra) # 1b2e <malloc>
     502:	fea43423          	sd	a0,-24(s0)
  memset(cmd, 0, sizeof(*cmd));
     506:	02800613          	li	a2,40
     50a:	4581                	li	a1,0
     50c:	fe843503          	ld	a0,-24(s0)
     510:	00001097          	auipc	ra,0x1
     514:	b40080e7          	jalr	-1216(ra) # 1050 <memset>
  cmd->type = REDIR;
     518:	fe843783          	ld	a5,-24(s0)
     51c:	4709                	li	a4,2
     51e:	c398                	sw	a4,0(a5)
  cmd->cmd = subcmd;
     520:	fe843783          	ld	a5,-24(s0)
     524:	fd843703          	ld	a4,-40(s0)
     528:	e798                	sd	a4,8(a5)
  cmd->file = file;
     52a:	fe843783          	ld	a5,-24(s0)
     52e:	fd043703          	ld	a4,-48(s0)
     532:	eb98                	sd	a4,16(a5)
  cmd->efile = efile;
     534:	fe843783          	ld	a5,-24(s0)
     538:	fc843703          	ld	a4,-56(s0)
     53c:	ef98                	sd	a4,24(a5)
  cmd->mode = mode;
     53e:	fe843783          	ld	a5,-24(s0)
     542:	fc442703          	lw	a4,-60(s0)
     546:	d398                	sw	a4,32(a5)
  cmd->fd = fd;
     548:	fe843783          	ld	a5,-24(s0)
     54c:	fc042703          	lw	a4,-64(s0)
     550:	d3d8                	sw	a4,36(a5)
  return (struct cmd*)cmd;
     552:	fe843783          	ld	a5,-24(s0)
}
     556:	853e                	mv	a0,a5
     558:	70e2                	ld	ra,56(sp)
     55a:	7442                	ld	s0,48(sp)
     55c:	6121                	addi	sp,sp,64
     55e:	8082                	ret

0000000000000560 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     560:	7179                	addi	sp,sp,-48
     562:	f406                	sd	ra,40(sp)
     564:	f022                	sd	s0,32(sp)
     566:	1800                	addi	s0,sp,48
     568:	fca43c23          	sd	a0,-40(s0)
     56c:	fcb43823          	sd	a1,-48(s0)
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     570:	4561                	li	a0,24
     572:	00001097          	auipc	ra,0x1
     576:	5bc080e7          	jalr	1468(ra) # 1b2e <malloc>
     57a:	fea43423          	sd	a0,-24(s0)
  memset(cmd, 0, sizeof(*cmd));
     57e:	4661                	li	a2,24
     580:	4581                	li	a1,0
     582:	fe843503          	ld	a0,-24(s0)
     586:	00001097          	auipc	ra,0x1
     58a:	aca080e7          	jalr	-1334(ra) # 1050 <memset>
  cmd->type = PIPE;
     58e:	fe843783          	ld	a5,-24(s0)
     592:	470d                	li	a4,3
     594:	c398                	sw	a4,0(a5)
  cmd->left = left;
     596:	fe843783          	ld	a5,-24(s0)
     59a:	fd843703          	ld	a4,-40(s0)
     59e:	e798                	sd	a4,8(a5)
  cmd->right = right;
     5a0:	fe843783          	ld	a5,-24(s0)
     5a4:	fd043703          	ld	a4,-48(s0)
     5a8:	eb98                	sd	a4,16(a5)
  return (struct cmd*)cmd;
     5aa:	fe843783          	ld	a5,-24(s0)
}
     5ae:	853e                	mv	a0,a5
     5b0:	70a2                	ld	ra,40(sp)
     5b2:	7402                	ld	s0,32(sp)
     5b4:	6145                	addi	sp,sp,48
     5b6:	8082                	ret

00000000000005b8 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     5b8:	7179                	addi	sp,sp,-48
     5ba:	f406                	sd	ra,40(sp)
     5bc:	f022                	sd	s0,32(sp)
     5be:	1800                	addi	s0,sp,48
     5c0:	fca43c23          	sd	a0,-40(s0)
     5c4:	fcb43823          	sd	a1,-48(s0)
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     5c8:	4561                	li	a0,24
     5ca:	00001097          	auipc	ra,0x1
     5ce:	564080e7          	jalr	1380(ra) # 1b2e <malloc>
     5d2:	fea43423          	sd	a0,-24(s0)
  memset(cmd, 0, sizeof(*cmd));
     5d6:	4661                	li	a2,24
     5d8:	4581                	li	a1,0
     5da:	fe843503          	ld	a0,-24(s0)
     5de:	00001097          	auipc	ra,0x1
     5e2:	a72080e7          	jalr	-1422(ra) # 1050 <memset>
  cmd->type = LIST;
     5e6:	fe843783          	ld	a5,-24(s0)
     5ea:	4711                	li	a4,4
     5ec:	c398                	sw	a4,0(a5)
  cmd->left = left;
     5ee:	fe843783          	ld	a5,-24(s0)
     5f2:	fd843703          	ld	a4,-40(s0)
     5f6:	e798                	sd	a4,8(a5)
  cmd->right = right;
     5f8:	fe843783          	ld	a5,-24(s0)
     5fc:	fd043703          	ld	a4,-48(s0)
     600:	eb98                	sd	a4,16(a5)
  return (struct cmd*)cmd;
     602:	fe843783          	ld	a5,-24(s0)
}
     606:	853e                	mv	a0,a5
     608:	70a2                	ld	ra,40(sp)
     60a:	7402                	ld	s0,32(sp)
     60c:	6145                	addi	sp,sp,48
     60e:	8082                	ret

0000000000000610 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     610:	7179                	addi	sp,sp,-48
     612:	f406                	sd	ra,40(sp)
     614:	f022                	sd	s0,32(sp)
     616:	1800                	addi	s0,sp,48
     618:	fca43c23          	sd	a0,-40(s0)
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     61c:	4541                	li	a0,16
     61e:	00001097          	auipc	ra,0x1
     622:	510080e7          	jalr	1296(ra) # 1b2e <malloc>
     626:	fea43423          	sd	a0,-24(s0)
  memset(cmd, 0, sizeof(*cmd));
     62a:	4641                	li	a2,16
     62c:	4581                	li	a1,0
     62e:	fe843503          	ld	a0,-24(s0)
     632:	00001097          	auipc	ra,0x1
     636:	a1e080e7          	jalr	-1506(ra) # 1050 <memset>
  cmd->type = BACK;
     63a:	fe843783          	ld	a5,-24(s0)
     63e:	4715                	li	a4,5
     640:	c398                	sw	a4,0(a5)
  cmd->cmd = subcmd;
     642:	fe843783          	ld	a5,-24(s0)
     646:	fd843703          	ld	a4,-40(s0)
     64a:	e798                	sd	a4,8(a5)
  return (struct cmd*)cmd;
     64c:	fe843783          	ld	a5,-24(s0)
}
     650:	853e                	mv	a0,a5
     652:	70a2                	ld	ra,40(sp)
     654:	7402                	ld	s0,32(sp)
     656:	6145                	addi	sp,sp,48
     658:	8082                	ret

000000000000065a <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     65a:	7139                	addi	sp,sp,-64
     65c:	fc06                	sd	ra,56(sp)
     65e:	f822                	sd	s0,48(sp)
     660:	0080                	addi	s0,sp,64
     662:	fca43c23          	sd	a0,-40(s0)
     666:	fcb43823          	sd	a1,-48(s0)
     66a:	fcc43423          	sd	a2,-56(s0)
     66e:	fcd43023          	sd	a3,-64(s0)
  char *s;
  int ret;

  s = *ps;
     672:	fd843783          	ld	a5,-40(s0)
     676:	639c                	ld	a5,0(a5)
     678:	fef43423          	sd	a5,-24(s0)
  while(s < es && strchr(whitespace, *s))
     67c:	a031                	j	688 <gettoken+0x2e>
    s++;
     67e:	fe843783          	ld	a5,-24(s0)
     682:	0785                	addi	a5,a5,1
     684:	fef43423          	sd	a5,-24(s0)
  while(s < es && strchr(whitespace, *s))
     688:	fe843703          	ld	a4,-24(s0)
     68c:	fd043783          	ld	a5,-48(s0)
     690:	02f77163          	bgeu	a4,a5,6b2 <gettoken+0x58>
     694:	fe843783          	ld	a5,-24(s0)
     698:	0007c783          	lbu	a5,0(a5)
     69c:	85be                	mv	a1,a5
     69e:	00002517          	auipc	a0,0x2
     6a2:	96250513          	addi	a0,a0,-1694 # 2000 <whitespace>
     6a6:	00001097          	auipc	ra,0x1
     6aa:	a0e080e7          	jalr	-1522(ra) # 10b4 <strchr>
     6ae:	87aa                	mv	a5,a0
     6b0:	f7f9                	bnez	a5,67e <gettoken+0x24>
  if(q)
     6b2:	fc843783          	ld	a5,-56(s0)
     6b6:	c791                	beqz	a5,6c2 <gettoken+0x68>
    *q = s;
     6b8:	fc843783          	ld	a5,-56(s0)
     6bc:	fe843703          	ld	a4,-24(s0)
     6c0:	e398                	sd	a4,0(a5)
  ret = *s;
     6c2:	fe843783          	ld	a5,-24(s0)
     6c6:	0007c783          	lbu	a5,0(a5)
     6ca:	fef42223          	sw	a5,-28(s0)
  switch(*s){
     6ce:	fe843783          	ld	a5,-24(s0)
     6d2:	0007c783          	lbu	a5,0(a5)
     6d6:	2781                	sext.w	a5,a5
     6d8:	07c00713          	li	a4,124
     6dc:	04e78363          	beq	a5,a4,722 <gettoken+0xc8>
     6e0:	07c00713          	li	a4,124
     6e4:	06f74d63          	blt	a4,a5,75e <gettoken+0x104>
     6e8:	03e00713          	li	a4,62
     6ec:	04e78163          	beq	a5,a4,72e <gettoken+0xd4>
     6f0:	03e00713          	li	a4,62
     6f4:	06f74563          	blt	a4,a5,75e <gettoken+0x104>
     6f8:	03c00713          	li	a4,60
     6fc:	06f74163          	blt	a4,a5,75e <gettoken+0x104>
     700:	03b00713          	li	a4,59
     704:	00e7df63          	bge	a5,a4,722 <gettoken+0xc8>
     708:	02900713          	li	a4,41
     70c:	04f74963          	blt	a4,a5,75e <gettoken+0x104>
     710:	02800713          	li	a4,40
     714:	00e7d763          	bge	a5,a4,722 <gettoken+0xc8>
     718:	c3d5                	beqz	a5,7bc <gettoken+0x162>
     71a:	02600713          	li	a4,38
     71e:	04e79063          	bne	a5,a4,75e <gettoken+0x104>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     722:	fe843783          	ld	a5,-24(s0)
     726:	0785                	addi	a5,a5,1
     728:	fef43423          	sd	a5,-24(s0)
    break;
     72c:	a869                	j	7c6 <gettoken+0x16c>
  case '>':
    s++;
     72e:	fe843783          	ld	a5,-24(s0)
     732:	0785                	addi	a5,a5,1
     734:	fef43423          	sd	a5,-24(s0)
    if(*s == '>'){
     738:	fe843783          	ld	a5,-24(s0)
     73c:	0007c783          	lbu	a5,0(a5)
     740:	873e                	mv	a4,a5
     742:	03e00793          	li	a5,62
     746:	06f71d63          	bne	a4,a5,7c0 <gettoken+0x166>
      ret = '+';
     74a:	02b00793          	li	a5,43
     74e:	fef42223          	sw	a5,-28(s0)
      s++;
     752:	fe843783          	ld	a5,-24(s0)
     756:	0785                	addi	a5,a5,1
     758:	fef43423          	sd	a5,-24(s0)
    }
    break;
     75c:	a095                	j	7c0 <gettoken+0x166>
  default:
    ret = 'a';
     75e:	06100793          	li	a5,97
     762:	fef42223          	sw	a5,-28(s0)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     766:	a031                	j	772 <gettoken+0x118>
      s++;
     768:	fe843783          	ld	a5,-24(s0)
     76c:	0785                	addi	a5,a5,1
     76e:	fef43423          	sd	a5,-24(s0)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     772:	fe843703          	ld	a4,-24(s0)
     776:	fd043783          	ld	a5,-48(s0)
     77a:	04f77563          	bgeu	a4,a5,7c4 <gettoken+0x16a>
     77e:	fe843783          	ld	a5,-24(s0)
     782:	0007c783          	lbu	a5,0(a5)
     786:	85be                	mv	a1,a5
     788:	00002517          	auipc	a0,0x2
     78c:	87850513          	addi	a0,a0,-1928 # 2000 <whitespace>
     790:	00001097          	auipc	ra,0x1
     794:	924080e7          	jalr	-1756(ra) # 10b4 <strchr>
     798:	87aa                	mv	a5,a0
     79a:	e78d                	bnez	a5,7c4 <gettoken+0x16a>
     79c:	fe843783          	ld	a5,-24(s0)
     7a0:	0007c783          	lbu	a5,0(a5)
     7a4:	85be                	mv	a1,a5
     7a6:	00002517          	auipc	a0,0x2
     7aa:	86250513          	addi	a0,a0,-1950 # 2008 <symbols>
     7ae:	00001097          	auipc	ra,0x1
     7b2:	906080e7          	jalr	-1786(ra) # 10b4 <strchr>
     7b6:	87aa                	mv	a5,a0
     7b8:	dbc5                	beqz	a5,768 <gettoken+0x10e>
    break;
     7ba:	a029                	j	7c4 <gettoken+0x16a>
    break;
     7bc:	0001                	nop
     7be:	a021                	j	7c6 <gettoken+0x16c>
    break;
     7c0:	0001                	nop
     7c2:	a011                	j	7c6 <gettoken+0x16c>
    break;
     7c4:	0001                	nop
  }
  if(eq)
     7c6:	fc043783          	ld	a5,-64(s0)
     7ca:	cf81                	beqz	a5,7e2 <gettoken+0x188>
    *eq = s;
     7cc:	fc043783          	ld	a5,-64(s0)
     7d0:	fe843703          	ld	a4,-24(s0)
     7d4:	e398                	sd	a4,0(a5)

  while(s < es && strchr(whitespace, *s))
     7d6:	a031                	j	7e2 <gettoken+0x188>
    s++;
     7d8:	fe843783          	ld	a5,-24(s0)
     7dc:	0785                	addi	a5,a5,1
     7de:	fef43423          	sd	a5,-24(s0)
  while(s < es && strchr(whitespace, *s))
     7e2:	fe843703          	ld	a4,-24(s0)
     7e6:	fd043783          	ld	a5,-48(s0)
     7ea:	02f77163          	bgeu	a4,a5,80c <gettoken+0x1b2>
     7ee:	fe843783          	ld	a5,-24(s0)
     7f2:	0007c783          	lbu	a5,0(a5)
     7f6:	85be                	mv	a1,a5
     7f8:	00002517          	auipc	a0,0x2
     7fc:	80850513          	addi	a0,a0,-2040 # 2000 <whitespace>
     800:	00001097          	auipc	ra,0x1
     804:	8b4080e7          	jalr	-1868(ra) # 10b4 <strchr>
     808:	87aa                	mv	a5,a0
     80a:	f7f9                	bnez	a5,7d8 <gettoken+0x17e>
  *ps = s;
     80c:	fd843783          	ld	a5,-40(s0)
     810:	fe843703          	ld	a4,-24(s0)
     814:	e398                	sd	a4,0(a5)
  return ret;
     816:	fe442783          	lw	a5,-28(s0)
}
     81a:	853e                	mv	a0,a5
     81c:	70e2                	ld	ra,56(sp)
     81e:	7442                	ld	s0,48(sp)
     820:	6121                	addi	sp,sp,64
     822:	8082                	ret

0000000000000824 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     824:	7139                	addi	sp,sp,-64
     826:	fc06                	sd	ra,56(sp)
     828:	f822                	sd	s0,48(sp)
     82a:	0080                	addi	s0,sp,64
     82c:	fca43c23          	sd	a0,-40(s0)
     830:	fcb43823          	sd	a1,-48(s0)
     834:	fcc43423          	sd	a2,-56(s0)
  char *s;

  s = *ps;
     838:	fd843783          	ld	a5,-40(s0)
     83c:	639c                	ld	a5,0(a5)
     83e:	fef43423          	sd	a5,-24(s0)
  while(s < es && strchr(whitespace, *s))
     842:	a031                	j	84e <peek+0x2a>
    s++;
     844:	fe843783          	ld	a5,-24(s0)
     848:	0785                	addi	a5,a5,1
     84a:	fef43423          	sd	a5,-24(s0)
  while(s < es && strchr(whitespace, *s))
     84e:	fe843703          	ld	a4,-24(s0)
     852:	fd043783          	ld	a5,-48(s0)
     856:	02f77163          	bgeu	a4,a5,878 <peek+0x54>
     85a:	fe843783          	ld	a5,-24(s0)
     85e:	0007c783          	lbu	a5,0(a5)
     862:	85be                	mv	a1,a5
     864:	00001517          	auipc	a0,0x1
     868:	79c50513          	addi	a0,a0,1948 # 2000 <whitespace>
     86c:	00001097          	auipc	ra,0x1
     870:	848080e7          	jalr	-1976(ra) # 10b4 <strchr>
     874:	87aa                	mv	a5,a0
     876:	f7f9                	bnez	a5,844 <peek+0x20>
  *ps = s;
     878:	fd843783          	ld	a5,-40(s0)
     87c:	fe843703          	ld	a4,-24(s0)
     880:	e398                	sd	a4,0(a5)
  return *s && strchr(toks, *s);
     882:	fe843783          	ld	a5,-24(s0)
     886:	0007c783          	lbu	a5,0(a5)
     88a:	c385                	beqz	a5,8aa <peek+0x86>
     88c:	fe843783          	ld	a5,-24(s0)
     890:	0007c783          	lbu	a5,0(a5)
     894:	85be                	mv	a1,a5
     896:	fc843503          	ld	a0,-56(s0)
     89a:	00001097          	auipc	ra,0x1
     89e:	81a080e7          	jalr	-2022(ra) # 10b4 <strchr>
     8a2:	87aa                	mv	a5,a0
     8a4:	c399                	beqz	a5,8aa <peek+0x86>
     8a6:	4785                	li	a5,1
     8a8:	a011                	j	8ac <peek+0x88>
     8aa:	4781                	li	a5,0
}
     8ac:	853e                	mv	a0,a5
     8ae:	70e2                	ld	ra,56(sp)
     8b0:	7442                	ld	s0,48(sp)
     8b2:	6121                	addi	sp,sp,64
     8b4:	8082                	ret

00000000000008b6 <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     8b6:	7139                	addi	sp,sp,-64
     8b8:	fc06                	sd	ra,56(sp)
     8ba:	f822                	sd	s0,48(sp)
     8bc:	f426                	sd	s1,40(sp)
     8be:	0080                	addi	s0,sp,64
     8c0:	fca43423          	sd	a0,-56(s0)
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     8c4:	fc843483          	ld	s1,-56(s0)
     8c8:	fc843783          	ld	a5,-56(s0)
     8cc:	853e                	mv	a0,a5
     8ce:	00000097          	auipc	ra,0x0
     8d2:	748080e7          	jalr	1864(ra) # 1016 <strlen>
     8d6:	87aa                	mv	a5,a0
     8d8:	1782                	slli	a5,a5,0x20
     8da:	9381                	srli	a5,a5,0x20
     8dc:	97a6                	add	a5,a5,s1
     8de:	fcf43c23          	sd	a5,-40(s0)
  cmd = parseline(&s, es);
     8e2:	fc840793          	addi	a5,s0,-56
     8e6:	fd843583          	ld	a1,-40(s0)
     8ea:	853e                	mv	a0,a5
     8ec:	00000097          	auipc	ra,0x0
     8f0:	076080e7          	jalr	118(ra) # 962 <parseline>
     8f4:	fca43823          	sd	a0,-48(s0)
  peek(&s, es, "");
     8f8:	fc840793          	addi	a5,s0,-56
     8fc:	00001617          	auipc	a2,0x1
     900:	3ec60613          	addi	a2,a2,1004 # 1ce8 <malloc+0x1ba>
     904:	fd843583          	ld	a1,-40(s0)
     908:	853e                	mv	a0,a5
     90a:	00000097          	auipc	ra,0x0
     90e:	f1a080e7          	jalr	-230(ra) # 824 <peek>
  if(s != es){
     912:	fc843783          	ld	a5,-56(s0)
     916:	fd843703          	ld	a4,-40(s0)
     91a:	02f70663          	beq	a4,a5,946 <parsecmd+0x90>
    fprintf(2, "leftovers: %s\n", s);
     91e:	fc843783          	ld	a5,-56(s0)
     922:	863e                	mv	a2,a5
     924:	00001597          	auipc	a1,0x1
     928:	3cc58593          	addi	a1,a1,972 # 1cf0 <malloc+0x1c2>
     92c:	4509                	li	a0,2
     92e:	00001097          	auipc	ra,0x1
     932:	fb4080e7          	jalr	-76(ra) # 18e2 <fprintf>
    panic("syntax");
     936:	00001517          	auipc	a0,0x1
     93a:	3ca50513          	addi	a0,a0,970 # 1d00 <malloc+0x1d2>
     93e:	00000097          	auipc	ra,0x0
     942:	aea080e7          	jalr	-1302(ra) # 428 <panic>
  }
  nulterminate(cmd);
     946:	fd043503          	ld	a0,-48(s0)
     94a:	00000097          	auipc	ra,0x0
     94e:	4da080e7          	jalr	1242(ra) # e24 <nulterminate>
  return cmd;
     952:	fd043783          	ld	a5,-48(s0)
}
     956:	853e                	mv	a0,a5
     958:	70e2                	ld	ra,56(sp)
     95a:	7442                	ld	s0,48(sp)
     95c:	74a2                	ld	s1,40(sp)
     95e:	6121                	addi	sp,sp,64
     960:	8082                	ret

0000000000000962 <parseline>:

struct cmd*
parseline(char **ps, char *es)
{
     962:	7179                	addi	sp,sp,-48
     964:	f406                	sd	ra,40(sp)
     966:	f022                	sd	s0,32(sp)
     968:	1800                	addi	s0,sp,48
     96a:	fca43c23          	sd	a0,-40(s0)
     96e:	fcb43823          	sd	a1,-48(s0)
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     972:	fd043583          	ld	a1,-48(s0)
     976:	fd843503          	ld	a0,-40(s0)
     97a:	00000097          	auipc	ra,0x0
     97e:	0b0080e7          	jalr	176(ra) # a2a <parsepipe>
     982:	fea43423          	sd	a0,-24(s0)
  while(peek(ps, es, "&")){
     986:	a01d                	j	9ac <parseline+0x4a>
    gettoken(ps, es, 0, 0);
     988:	4681                	li	a3,0
     98a:	4601                	li	a2,0
     98c:	fd043583          	ld	a1,-48(s0)
     990:	fd843503          	ld	a0,-40(s0)
     994:	00000097          	auipc	ra,0x0
     998:	cc6080e7          	jalr	-826(ra) # 65a <gettoken>
    cmd = backcmd(cmd);
     99c:	fe843503          	ld	a0,-24(s0)
     9a0:	00000097          	auipc	ra,0x0
     9a4:	c70080e7          	jalr	-912(ra) # 610 <backcmd>
     9a8:	fea43423          	sd	a0,-24(s0)
  while(peek(ps, es, "&")){
     9ac:	00001617          	auipc	a2,0x1
     9b0:	35c60613          	addi	a2,a2,860 # 1d08 <malloc+0x1da>
     9b4:	fd043583          	ld	a1,-48(s0)
     9b8:	fd843503          	ld	a0,-40(s0)
     9bc:	00000097          	auipc	ra,0x0
     9c0:	e68080e7          	jalr	-408(ra) # 824 <peek>
     9c4:	87aa                	mv	a5,a0
     9c6:	f3e9                	bnez	a5,988 <parseline+0x26>
  }
  if(peek(ps, es, ";")){
     9c8:	00001617          	auipc	a2,0x1
     9cc:	34860613          	addi	a2,a2,840 # 1d10 <malloc+0x1e2>
     9d0:	fd043583          	ld	a1,-48(s0)
     9d4:	fd843503          	ld	a0,-40(s0)
     9d8:	00000097          	auipc	ra,0x0
     9dc:	e4c080e7          	jalr	-436(ra) # 824 <peek>
     9e0:	87aa                	mv	a5,a0
     9e2:	cf8d                	beqz	a5,a1c <parseline+0xba>
    gettoken(ps, es, 0, 0);
     9e4:	4681                	li	a3,0
     9e6:	4601                	li	a2,0
     9e8:	fd043583          	ld	a1,-48(s0)
     9ec:	fd843503          	ld	a0,-40(s0)
     9f0:	00000097          	auipc	ra,0x0
     9f4:	c6a080e7          	jalr	-918(ra) # 65a <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     9f8:	fd043583          	ld	a1,-48(s0)
     9fc:	fd843503          	ld	a0,-40(s0)
     a00:	00000097          	auipc	ra,0x0
     a04:	f62080e7          	jalr	-158(ra) # 962 <parseline>
     a08:	87aa                	mv	a5,a0
     a0a:	85be                	mv	a1,a5
     a0c:	fe843503          	ld	a0,-24(s0)
     a10:	00000097          	auipc	ra,0x0
     a14:	ba8080e7          	jalr	-1112(ra) # 5b8 <listcmd>
     a18:	fea43423          	sd	a0,-24(s0)
  }
  return cmd;
     a1c:	fe843783          	ld	a5,-24(s0)
}
     a20:	853e                	mv	a0,a5
     a22:	70a2                	ld	ra,40(sp)
     a24:	7402                	ld	s0,32(sp)
     a26:	6145                	addi	sp,sp,48
     a28:	8082                	ret

0000000000000a2a <parsepipe>:

struct cmd*
parsepipe(char **ps, char *es)
{
     a2a:	7179                	addi	sp,sp,-48
     a2c:	f406                	sd	ra,40(sp)
     a2e:	f022                	sd	s0,32(sp)
     a30:	1800                	addi	s0,sp,48
     a32:	fca43c23          	sd	a0,-40(s0)
     a36:	fcb43823          	sd	a1,-48(s0)
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     a3a:	fd043583          	ld	a1,-48(s0)
     a3e:	fd843503          	ld	a0,-40(s0)
     a42:	00000097          	auipc	ra,0x0
     a46:	270080e7          	jalr	624(ra) # cb2 <parseexec>
     a4a:	fea43423          	sd	a0,-24(s0)
  if(peek(ps, es, "|")){
     a4e:	00001617          	auipc	a2,0x1
     a52:	2ca60613          	addi	a2,a2,714 # 1d18 <malloc+0x1ea>
     a56:	fd043583          	ld	a1,-48(s0)
     a5a:	fd843503          	ld	a0,-40(s0)
     a5e:	00000097          	auipc	ra,0x0
     a62:	dc6080e7          	jalr	-570(ra) # 824 <peek>
     a66:	87aa                	mv	a5,a0
     a68:	cf8d                	beqz	a5,aa2 <parsepipe+0x78>
    gettoken(ps, es, 0, 0);
     a6a:	4681                	li	a3,0
     a6c:	4601                	li	a2,0
     a6e:	fd043583          	ld	a1,-48(s0)
     a72:	fd843503          	ld	a0,-40(s0)
     a76:	00000097          	auipc	ra,0x0
     a7a:	be4080e7          	jalr	-1052(ra) # 65a <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     a7e:	fd043583          	ld	a1,-48(s0)
     a82:	fd843503          	ld	a0,-40(s0)
     a86:	00000097          	auipc	ra,0x0
     a8a:	fa4080e7          	jalr	-92(ra) # a2a <parsepipe>
     a8e:	87aa                	mv	a5,a0
     a90:	85be                	mv	a1,a5
     a92:	fe843503          	ld	a0,-24(s0)
     a96:	00000097          	auipc	ra,0x0
     a9a:	aca080e7          	jalr	-1334(ra) # 560 <pipecmd>
     a9e:	fea43423          	sd	a0,-24(s0)
  }
  return cmd;
     aa2:	fe843783          	ld	a5,-24(s0)
}
     aa6:	853e                	mv	a0,a5
     aa8:	70a2                	ld	ra,40(sp)
     aaa:	7402                	ld	s0,32(sp)
     aac:	6145                	addi	sp,sp,48
     aae:	8082                	ret

0000000000000ab0 <parseredirs>:

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     ab0:	715d                	addi	sp,sp,-80
     ab2:	e486                	sd	ra,72(sp)
     ab4:	e0a2                	sd	s0,64(sp)
     ab6:	0880                	addi	s0,sp,80
     ab8:	fca43423          	sd	a0,-56(s0)
     abc:	fcb43023          	sd	a1,-64(s0)
     ac0:	fac43c23          	sd	a2,-72(s0)
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     ac4:	a8e5                	j	bbc <parseredirs+0x10c>
    tok = gettoken(ps, es, 0, 0);
     ac6:	4681                	li	a3,0
     ac8:	4601                	li	a2,0
     aca:	fb843583          	ld	a1,-72(s0)
     ace:	fc043503          	ld	a0,-64(s0)
     ad2:	00000097          	auipc	ra,0x0
     ad6:	b88080e7          	jalr	-1144(ra) # 65a <gettoken>
     ada:	87aa                	mv	a5,a0
     adc:	fef42623          	sw	a5,-20(s0)
    if(gettoken(ps, es, &q, &eq) != 'a')
     ae0:	fd840713          	addi	a4,s0,-40
     ae4:	fe040793          	addi	a5,s0,-32
     ae8:	86ba                	mv	a3,a4
     aea:	863e                	mv	a2,a5
     aec:	fb843583          	ld	a1,-72(s0)
     af0:	fc043503          	ld	a0,-64(s0)
     af4:	00000097          	auipc	ra,0x0
     af8:	b66080e7          	jalr	-1178(ra) # 65a <gettoken>
     afc:	87aa                	mv	a5,a0
     afe:	873e                	mv	a4,a5
     b00:	06100793          	li	a5,97
     b04:	00f70a63          	beq	a4,a5,b18 <parseredirs+0x68>
      panic("missing file for redirection");
     b08:	00001517          	auipc	a0,0x1
     b0c:	21850513          	addi	a0,a0,536 # 1d20 <malloc+0x1f2>
     b10:	00000097          	auipc	ra,0x0
     b14:	918080e7          	jalr	-1768(ra) # 428 <panic>
    switch(tok){
     b18:	fec42783          	lw	a5,-20(s0)
     b1c:	0007871b          	sext.w	a4,a5
     b20:	03e00793          	li	a5,62
     b24:	04f70a63          	beq	a4,a5,b78 <parseredirs+0xc8>
     b28:	fec42783          	lw	a5,-20(s0)
     b2c:	0007871b          	sext.w	a4,a5
     b30:	03e00793          	li	a5,62
     b34:	08e7c463          	blt	a5,a4,bbc <parseredirs+0x10c>
     b38:	fec42783          	lw	a5,-20(s0)
     b3c:	0007871b          	sext.w	a4,a5
     b40:	02b00793          	li	a5,43
     b44:	04f70b63          	beq	a4,a5,b9a <parseredirs+0xea>
     b48:	fec42783          	lw	a5,-20(s0)
     b4c:	0007871b          	sext.w	a4,a5
     b50:	03c00793          	li	a5,60
     b54:	06f71463          	bne	a4,a5,bbc <parseredirs+0x10c>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     b58:	fe043783          	ld	a5,-32(s0)
     b5c:	fd843603          	ld	a2,-40(s0)
     b60:	4701                	li	a4,0
     b62:	4681                	li	a3,0
     b64:	85be                	mv	a1,a5
     b66:	fc843503          	ld	a0,-56(s0)
     b6a:	00000097          	auipc	ra,0x0
     b6e:	96c080e7          	jalr	-1684(ra) # 4d6 <redircmd>
     b72:	fca43423          	sd	a0,-56(s0)
      break;
     b76:	a099                	j	bbc <parseredirs+0x10c>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     b78:	fe043783          	ld	a5,-32(s0)
     b7c:	fd843603          	ld	a2,-40(s0)
     b80:	4705                	li	a4,1
     b82:	60100693          	li	a3,1537
     b86:	85be                	mv	a1,a5
     b88:	fc843503          	ld	a0,-56(s0)
     b8c:	00000097          	auipc	ra,0x0
     b90:	94a080e7          	jalr	-1718(ra) # 4d6 <redircmd>
     b94:	fca43423          	sd	a0,-56(s0)
      break;
     b98:	a015                	j	bbc <parseredirs+0x10c>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     b9a:	fe043783          	ld	a5,-32(s0)
     b9e:	fd843603          	ld	a2,-40(s0)
     ba2:	4705                	li	a4,1
     ba4:	20100693          	li	a3,513
     ba8:	85be                	mv	a1,a5
     baa:	fc843503          	ld	a0,-56(s0)
     bae:	00000097          	auipc	ra,0x0
     bb2:	928080e7          	jalr	-1752(ra) # 4d6 <redircmd>
     bb6:	fca43423          	sd	a0,-56(s0)
      break;
     bba:	0001                	nop
  while(peek(ps, es, "<>")){
     bbc:	00001617          	auipc	a2,0x1
     bc0:	18460613          	addi	a2,a2,388 # 1d40 <malloc+0x212>
     bc4:	fb843583          	ld	a1,-72(s0)
     bc8:	fc043503          	ld	a0,-64(s0)
     bcc:	00000097          	auipc	ra,0x0
     bd0:	c58080e7          	jalr	-936(ra) # 824 <peek>
     bd4:	87aa                	mv	a5,a0
     bd6:	ee0798e3          	bnez	a5,ac6 <parseredirs+0x16>
    }
  }
  return cmd;
     bda:	fc843783          	ld	a5,-56(s0)
}
     bde:	853e                	mv	a0,a5
     be0:	60a6                	ld	ra,72(sp)
     be2:	6406                	ld	s0,64(sp)
     be4:	6161                	addi	sp,sp,80
     be6:	8082                	ret

0000000000000be8 <parseblock>:

struct cmd*
parseblock(char **ps, char *es)
{
     be8:	7179                	addi	sp,sp,-48
     bea:	f406                	sd	ra,40(sp)
     bec:	f022                	sd	s0,32(sp)
     bee:	1800                	addi	s0,sp,48
     bf0:	fca43c23          	sd	a0,-40(s0)
     bf4:	fcb43823          	sd	a1,-48(s0)
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     bf8:	00001617          	auipc	a2,0x1
     bfc:	15060613          	addi	a2,a2,336 # 1d48 <malloc+0x21a>
     c00:	fd043583          	ld	a1,-48(s0)
     c04:	fd843503          	ld	a0,-40(s0)
     c08:	00000097          	auipc	ra,0x0
     c0c:	c1c080e7          	jalr	-996(ra) # 824 <peek>
     c10:	87aa                	mv	a5,a0
     c12:	eb89                	bnez	a5,c24 <parseblock+0x3c>
    panic("parseblock");
     c14:	00001517          	auipc	a0,0x1
     c18:	13c50513          	addi	a0,a0,316 # 1d50 <malloc+0x222>
     c1c:	00000097          	auipc	ra,0x0
     c20:	80c080e7          	jalr	-2036(ra) # 428 <panic>
  gettoken(ps, es, 0, 0);
     c24:	4681                	li	a3,0
     c26:	4601                	li	a2,0
     c28:	fd043583          	ld	a1,-48(s0)
     c2c:	fd843503          	ld	a0,-40(s0)
     c30:	00000097          	auipc	ra,0x0
     c34:	a2a080e7          	jalr	-1494(ra) # 65a <gettoken>
  cmd = parseline(ps, es);
     c38:	fd043583          	ld	a1,-48(s0)
     c3c:	fd843503          	ld	a0,-40(s0)
     c40:	00000097          	auipc	ra,0x0
     c44:	d22080e7          	jalr	-734(ra) # 962 <parseline>
     c48:	fea43423          	sd	a0,-24(s0)
  if(!peek(ps, es, ")"))
     c4c:	00001617          	auipc	a2,0x1
     c50:	11460613          	addi	a2,a2,276 # 1d60 <malloc+0x232>
     c54:	fd043583          	ld	a1,-48(s0)
     c58:	fd843503          	ld	a0,-40(s0)
     c5c:	00000097          	auipc	ra,0x0
     c60:	bc8080e7          	jalr	-1080(ra) # 824 <peek>
     c64:	87aa                	mv	a5,a0
     c66:	eb89                	bnez	a5,c78 <parseblock+0x90>
    panic("syntax - missing )");
     c68:	00001517          	auipc	a0,0x1
     c6c:	10050513          	addi	a0,a0,256 # 1d68 <malloc+0x23a>
     c70:	fffff097          	auipc	ra,0xfffff
     c74:	7b8080e7          	jalr	1976(ra) # 428 <panic>
  gettoken(ps, es, 0, 0);
     c78:	4681                	li	a3,0
     c7a:	4601                	li	a2,0
     c7c:	fd043583          	ld	a1,-48(s0)
     c80:	fd843503          	ld	a0,-40(s0)
     c84:	00000097          	auipc	ra,0x0
     c88:	9d6080e7          	jalr	-1578(ra) # 65a <gettoken>
  cmd = parseredirs(cmd, ps, es);
     c8c:	fd043603          	ld	a2,-48(s0)
     c90:	fd843583          	ld	a1,-40(s0)
     c94:	fe843503          	ld	a0,-24(s0)
     c98:	00000097          	auipc	ra,0x0
     c9c:	e18080e7          	jalr	-488(ra) # ab0 <parseredirs>
     ca0:	fea43423          	sd	a0,-24(s0)
  return cmd;
     ca4:	fe843783          	ld	a5,-24(s0)
}
     ca8:	853e                	mv	a0,a5
     caa:	70a2                	ld	ra,40(sp)
     cac:	7402                	ld	s0,32(sp)
     cae:	6145                	addi	sp,sp,48
     cb0:	8082                	ret

0000000000000cb2 <parseexec>:

struct cmd*
parseexec(char **ps, char *es)
{
     cb2:	715d                	addi	sp,sp,-80
     cb4:	e486                	sd	ra,72(sp)
     cb6:	e0a2                	sd	s0,64(sp)
     cb8:	0880                	addi	s0,sp,80
     cba:	faa43c23          	sd	a0,-72(s0)
     cbe:	fab43823          	sd	a1,-80(s0)
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     cc2:	00001617          	auipc	a2,0x1
     cc6:	08660613          	addi	a2,a2,134 # 1d48 <malloc+0x21a>
     cca:	fb043583          	ld	a1,-80(s0)
     cce:	fb843503          	ld	a0,-72(s0)
     cd2:	00000097          	auipc	ra,0x0
     cd6:	b52080e7          	jalr	-1198(ra) # 824 <peek>
     cda:	87aa                	mv	a5,a0
     cdc:	cb99                	beqz	a5,cf2 <parseexec+0x40>
    return parseblock(ps, es);
     cde:	fb043583          	ld	a1,-80(s0)
     ce2:	fb843503          	ld	a0,-72(s0)
     ce6:	00000097          	auipc	ra,0x0
     cea:	f02080e7          	jalr	-254(ra) # be8 <parseblock>
     cee:	87aa                	mv	a5,a0
     cf0:	a22d                	j	e1a <parseexec+0x168>

  ret = execcmd();
     cf2:	fffff097          	auipc	ra,0xfffff
     cf6:	7a4080e7          	jalr	1956(ra) # 496 <execcmd>
     cfa:	fea43023          	sd	a0,-32(s0)
  cmd = (struct execcmd*)ret;
     cfe:	fe043783          	ld	a5,-32(s0)
     d02:	fcf43c23          	sd	a5,-40(s0)

  argc = 0;
     d06:	fe042623          	sw	zero,-20(s0)
  ret = parseredirs(ret, ps, es);
     d0a:	fb043603          	ld	a2,-80(s0)
     d0e:	fb843583          	ld	a1,-72(s0)
     d12:	fe043503          	ld	a0,-32(s0)
     d16:	00000097          	auipc	ra,0x0
     d1a:	d9a080e7          	jalr	-614(ra) # ab0 <parseredirs>
     d1e:	fea43023          	sd	a0,-32(s0)
  while(!peek(ps, es, "|)&;")){
     d22:	a84d                	j	dd4 <parseexec+0x122>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     d24:	fc040713          	addi	a4,s0,-64
     d28:	fc840793          	addi	a5,s0,-56
     d2c:	86ba                	mv	a3,a4
     d2e:	863e                	mv	a2,a5
     d30:	fb043583          	ld	a1,-80(s0)
     d34:	fb843503          	ld	a0,-72(s0)
     d38:	00000097          	auipc	ra,0x0
     d3c:	922080e7          	jalr	-1758(ra) # 65a <gettoken>
     d40:	87aa                	mv	a5,a0
     d42:	fcf42a23          	sw	a5,-44(s0)
     d46:	fd442783          	lw	a5,-44(s0)
     d4a:	2781                	sext.w	a5,a5
     d4c:	c3dd                	beqz	a5,df2 <parseexec+0x140>
      break;
    if(tok != 'a')
     d4e:	fd442783          	lw	a5,-44(s0)
     d52:	0007871b          	sext.w	a4,a5
     d56:	06100793          	li	a5,97
     d5a:	00f70a63          	beq	a4,a5,d6e <parseexec+0xbc>
      panic("syntax");
     d5e:	00001517          	auipc	a0,0x1
     d62:	fa250513          	addi	a0,a0,-94 # 1d00 <malloc+0x1d2>
     d66:	fffff097          	auipc	ra,0xfffff
     d6a:	6c2080e7          	jalr	1730(ra) # 428 <panic>
    cmd->argv[argc] = q;
     d6e:	fc843703          	ld	a4,-56(s0)
     d72:	fd843683          	ld	a3,-40(s0)
     d76:	fec42783          	lw	a5,-20(s0)
     d7a:	078e                	slli	a5,a5,0x3
     d7c:	97b6                	add	a5,a5,a3
     d7e:	e798                	sd	a4,8(a5)
    cmd->eargv[argc] = eq;
     d80:	fc043703          	ld	a4,-64(s0)
     d84:	fd843683          	ld	a3,-40(s0)
     d88:	fec42783          	lw	a5,-20(s0)
     d8c:	07a9                	addi	a5,a5,10
     d8e:	078e                	slli	a5,a5,0x3
     d90:	97b6                	add	a5,a5,a3
     d92:	e798                	sd	a4,8(a5)
    argc++;
     d94:	fec42783          	lw	a5,-20(s0)
     d98:	2785                	addiw	a5,a5,1
     d9a:	fef42623          	sw	a5,-20(s0)
    if(argc >= MAXARGS)
     d9e:	fec42783          	lw	a5,-20(s0)
     da2:	0007871b          	sext.w	a4,a5
     da6:	47a5                	li	a5,9
     da8:	00e7da63          	bge	a5,a4,dbc <parseexec+0x10a>
      panic("too many args");
     dac:	00001517          	auipc	a0,0x1
     db0:	fd450513          	addi	a0,a0,-44 # 1d80 <malloc+0x252>
     db4:	fffff097          	auipc	ra,0xfffff
     db8:	674080e7          	jalr	1652(ra) # 428 <panic>
    ret = parseredirs(ret, ps, es);
     dbc:	fb043603          	ld	a2,-80(s0)
     dc0:	fb843583          	ld	a1,-72(s0)
     dc4:	fe043503          	ld	a0,-32(s0)
     dc8:	00000097          	auipc	ra,0x0
     dcc:	ce8080e7          	jalr	-792(ra) # ab0 <parseredirs>
     dd0:	fea43023          	sd	a0,-32(s0)
  while(!peek(ps, es, "|)&;")){
     dd4:	00001617          	auipc	a2,0x1
     dd8:	fbc60613          	addi	a2,a2,-68 # 1d90 <malloc+0x262>
     ddc:	fb043583          	ld	a1,-80(s0)
     de0:	fb843503          	ld	a0,-72(s0)
     de4:	00000097          	auipc	ra,0x0
     de8:	a40080e7          	jalr	-1472(ra) # 824 <peek>
     dec:	87aa                	mv	a5,a0
     dee:	db9d                	beqz	a5,d24 <parseexec+0x72>
     df0:	a011                	j	df4 <parseexec+0x142>
      break;
     df2:	0001                	nop
  }
  cmd->argv[argc] = 0;
     df4:	fd843703          	ld	a4,-40(s0)
     df8:	fec42783          	lw	a5,-20(s0)
     dfc:	078e                	slli	a5,a5,0x3
     dfe:	97ba                	add	a5,a5,a4
     e00:	0007b423          	sd	zero,8(a5)
  cmd->eargv[argc] = 0;
     e04:	fd843703          	ld	a4,-40(s0)
     e08:	fec42783          	lw	a5,-20(s0)
     e0c:	07a9                	addi	a5,a5,10
     e0e:	078e                	slli	a5,a5,0x3
     e10:	97ba                	add	a5,a5,a4
     e12:	0007b423          	sd	zero,8(a5)
  return ret;
     e16:	fe043783          	ld	a5,-32(s0)
}
     e1a:	853e                	mv	a0,a5
     e1c:	60a6                	ld	ra,72(sp)
     e1e:	6406                	ld	s0,64(sp)
     e20:	6161                	addi	sp,sp,80
     e22:	8082                	ret

0000000000000e24 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     e24:	715d                	addi	sp,sp,-80
     e26:	e486                	sd	ra,72(sp)
     e28:	e0a2                	sd	s0,64(sp)
     e2a:	0880                	addi	s0,sp,80
     e2c:	faa43c23          	sd	a0,-72(s0)
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     e30:	fb843783          	ld	a5,-72(s0)
     e34:	e399                	bnez	a5,e3a <nulterminate+0x16>
    return 0;
     e36:	4781                	li	a5,0
     e38:	a209                	j	f3a <nulterminate+0x116>

  switch(cmd->type){
     e3a:	fb843783          	ld	a5,-72(s0)
     e3e:	439c                	lw	a5,0(a5)
     e40:	4715                	li	a4,5
     e42:	0ef76a63          	bltu	a4,a5,f36 <nulterminate+0x112>
     e46:	00279713          	slli	a4,a5,0x2
     e4a:	00001797          	auipc	a5,0x1
     e4e:	f4e78793          	addi	a5,a5,-178 # 1d98 <malloc+0x26a>
     e52:	97ba                	add	a5,a5,a4
     e54:	439c                	lw	a5,0(a5)
     e56:	0007871b          	sext.w	a4,a5
     e5a:	00001797          	auipc	a5,0x1
     e5e:	f3e78793          	addi	a5,a5,-194 # 1d98 <malloc+0x26a>
     e62:	97ba                	add	a5,a5,a4
     e64:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
     e66:	fb843783          	ld	a5,-72(s0)
     e6a:	fcf43023          	sd	a5,-64(s0)
    for(i=0; ecmd->argv[i]; i++)
     e6e:	fe042623          	sw	zero,-20(s0)
     e72:	a005                	j	e92 <nulterminate+0x6e>
      *ecmd->eargv[i] = 0;
     e74:	fc043703          	ld	a4,-64(s0)
     e78:	fec42783          	lw	a5,-20(s0)
     e7c:	07a9                	addi	a5,a5,10
     e7e:	078e                	slli	a5,a5,0x3
     e80:	97ba                	add	a5,a5,a4
     e82:	679c                	ld	a5,8(a5)
     e84:	00078023          	sb	zero,0(a5)
    for(i=0; ecmd->argv[i]; i++)
     e88:	fec42783          	lw	a5,-20(s0)
     e8c:	2785                	addiw	a5,a5,1
     e8e:	fef42623          	sw	a5,-20(s0)
     e92:	fc043703          	ld	a4,-64(s0)
     e96:	fec42783          	lw	a5,-20(s0)
     e9a:	078e                	slli	a5,a5,0x3
     e9c:	97ba                	add	a5,a5,a4
     e9e:	679c                	ld	a5,8(a5)
     ea0:	fbf1                	bnez	a5,e74 <nulterminate+0x50>
    break;
     ea2:	a851                	j	f36 <nulterminate+0x112>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
     ea4:	fb843783          	ld	a5,-72(s0)
     ea8:	fcf43423          	sd	a5,-56(s0)
    nulterminate(rcmd->cmd);
     eac:	fc843783          	ld	a5,-56(s0)
     eb0:	679c                	ld	a5,8(a5)
     eb2:	853e                	mv	a0,a5
     eb4:	00000097          	auipc	ra,0x0
     eb8:	f70080e7          	jalr	-144(ra) # e24 <nulterminate>
    *rcmd->efile = 0;
     ebc:	fc843783          	ld	a5,-56(s0)
     ec0:	6f9c                	ld	a5,24(a5)
     ec2:	00078023          	sb	zero,0(a5)
    break;
     ec6:	a885                	j	f36 <nulterminate+0x112>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     ec8:	fb843783          	ld	a5,-72(s0)
     ecc:	fcf43823          	sd	a5,-48(s0)
    nulterminate(pcmd->left);
     ed0:	fd043783          	ld	a5,-48(s0)
     ed4:	679c                	ld	a5,8(a5)
     ed6:	853e                	mv	a0,a5
     ed8:	00000097          	auipc	ra,0x0
     edc:	f4c080e7          	jalr	-180(ra) # e24 <nulterminate>
    nulterminate(pcmd->right);
     ee0:	fd043783          	ld	a5,-48(s0)
     ee4:	6b9c                	ld	a5,16(a5)
     ee6:	853e                	mv	a0,a5
     ee8:	00000097          	auipc	ra,0x0
     eec:	f3c080e7          	jalr	-196(ra) # e24 <nulterminate>
    break;
     ef0:	a099                	j	f36 <nulterminate+0x112>

  case LIST:
    lcmd = (struct listcmd*)cmd;
     ef2:	fb843783          	ld	a5,-72(s0)
     ef6:	fcf43c23          	sd	a5,-40(s0)
    nulterminate(lcmd->left);
     efa:	fd843783          	ld	a5,-40(s0)
     efe:	679c                	ld	a5,8(a5)
     f00:	853e                	mv	a0,a5
     f02:	00000097          	auipc	ra,0x0
     f06:	f22080e7          	jalr	-222(ra) # e24 <nulterminate>
    nulterminate(lcmd->right);
     f0a:	fd843783          	ld	a5,-40(s0)
     f0e:	6b9c                	ld	a5,16(a5)
     f10:	853e                	mv	a0,a5
     f12:	00000097          	auipc	ra,0x0
     f16:	f12080e7          	jalr	-238(ra) # e24 <nulterminate>
    break;
     f1a:	a831                	j	f36 <nulterminate+0x112>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     f1c:	fb843783          	ld	a5,-72(s0)
     f20:	fef43023          	sd	a5,-32(s0)
    nulterminate(bcmd->cmd);
     f24:	fe043783          	ld	a5,-32(s0)
     f28:	679c                	ld	a5,8(a5)
     f2a:	853e                	mv	a0,a5
     f2c:	00000097          	auipc	ra,0x0
     f30:	ef8080e7          	jalr	-264(ra) # e24 <nulterminate>
    break;
     f34:	0001                	nop
  }
  return cmd;
     f36:	fb843783          	ld	a5,-72(s0)
}
     f3a:	853e                	mv	a0,a5
     f3c:	60a6                	ld	ra,72(sp)
     f3e:	6406                	ld	s0,64(sp)
     f40:	6161                	addi	sp,sp,80
     f42:	8082                	ret

0000000000000f44 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     f44:	1141                	addi	sp,sp,-16
     f46:	e406                	sd	ra,8(sp)
     f48:	e022                	sd	s0,0(sp)
     f4a:	0800                	addi	s0,sp,16
  extern int main();
  main();
     f4c:	fffff097          	auipc	ra,0xfffff
     f50:	396080e7          	jalr	918(ra) # 2e2 <main>
  exit(0);
     f54:	4501                	li	a0,0
     f56:	00000097          	auipc	ra,0x0
     f5a:	4b8080e7          	jalr	1208(ra) # 140e <exit>

0000000000000f5e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     f5e:	7179                	addi	sp,sp,-48
     f60:	f406                	sd	ra,40(sp)
     f62:	f022                	sd	s0,32(sp)
     f64:	1800                	addi	s0,sp,48
     f66:	fca43c23          	sd	a0,-40(s0)
     f6a:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
     f6e:	fd843783          	ld	a5,-40(s0)
     f72:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
     f76:	0001                	nop
     f78:	fd043703          	ld	a4,-48(s0)
     f7c:	00170793          	addi	a5,a4,1
     f80:	fcf43823          	sd	a5,-48(s0)
     f84:	fd843783          	ld	a5,-40(s0)
     f88:	00178693          	addi	a3,a5,1
     f8c:	fcd43c23          	sd	a3,-40(s0)
     f90:	00074703          	lbu	a4,0(a4)
     f94:	00e78023          	sb	a4,0(a5)
     f98:	0007c783          	lbu	a5,0(a5)
     f9c:	fff1                	bnez	a5,f78 <strcpy+0x1a>
    ;
  return os;
     f9e:	fe843783          	ld	a5,-24(s0)
}
     fa2:	853e                	mv	a0,a5
     fa4:	70a2                	ld	ra,40(sp)
     fa6:	7402                	ld	s0,32(sp)
     fa8:	6145                	addi	sp,sp,48
     faa:	8082                	ret

0000000000000fac <strcmp>:

int
strcmp(const char *p, const char *q)
{
     fac:	1101                	addi	sp,sp,-32
     fae:	ec06                	sd	ra,24(sp)
     fb0:	e822                	sd	s0,16(sp)
     fb2:	1000                	addi	s0,sp,32
     fb4:	fea43423          	sd	a0,-24(s0)
     fb8:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
     fbc:	a819                	j	fd2 <strcmp+0x26>
    p++, q++;
     fbe:	fe843783          	ld	a5,-24(s0)
     fc2:	0785                	addi	a5,a5,1
     fc4:	fef43423          	sd	a5,-24(s0)
     fc8:	fe043783          	ld	a5,-32(s0)
     fcc:	0785                	addi	a5,a5,1
     fce:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
     fd2:	fe843783          	ld	a5,-24(s0)
     fd6:	0007c783          	lbu	a5,0(a5)
     fda:	cb99                	beqz	a5,ff0 <strcmp+0x44>
     fdc:	fe843783          	ld	a5,-24(s0)
     fe0:	0007c703          	lbu	a4,0(a5)
     fe4:	fe043783          	ld	a5,-32(s0)
     fe8:	0007c783          	lbu	a5,0(a5)
     fec:	fcf709e3          	beq	a4,a5,fbe <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
     ff0:	fe843783          	ld	a5,-24(s0)
     ff4:	0007c783          	lbu	a5,0(a5)
     ff8:	0007871b          	sext.w	a4,a5
     ffc:	fe043783          	ld	a5,-32(s0)
    1000:	0007c783          	lbu	a5,0(a5)
    1004:	2781                	sext.w	a5,a5
    1006:	40f707bb          	subw	a5,a4,a5
    100a:	2781                	sext.w	a5,a5
}
    100c:	853e                	mv	a0,a5
    100e:	60e2                	ld	ra,24(sp)
    1010:	6442                	ld	s0,16(sp)
    1012:	6105                	addi	sp,sp,32
    1014:	8082                	ret

0000000000001016 <strlen>:

uint
strlen(const char *s)
{
    1016:	7179                	addi	sp,sp,-48
    1018:	f406                	sd	ra,40(sp)
    101a:	f022                	sd	s0,32(sp)
    101c:	1800                	addi	s0,sp,48
    101e:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
    1022:	fe042623          	sw	zero,-20(s0)
    1026:	a031                	j	1032 <strlen+0x1c>
    1028:	fec42783          	lw	a5,-20(s0)
    102c:	2785                	addiw	a5,a5,1
    102e:	fef42623          	sw	a5,-20(s0)
    1032:	fec42783          	lw	a5,-20(s0)
    1036:	fd843703          	ld	a4,-40(s0)
    103a:	97ba                	add	a5,a5,a4
    103c:	0007c783          	lbu	a5,0(a5)
    1040:	f7e5                	bnez	a5,1028 <strlen+0x12>
    ;
  return n;
    1042:	fec42783          	lw	a5,-20(s0)
}
    1046:	853e                	mv	a0,a5
    1048:	70a2                	ld	ra,40(sp)
    104a:	7402                	ld	s0,32(sp)
    104c:	6145                	addi	sp,sp,48
    104e:	8082                	ret

0000000000001050 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1050:	7179                	addi	sp,sp,-48
    1052:	f406                	sd	ra,40(sp)
    1054:	f022                	sd	s0,32(sp)
    1056:	1800                	addi	s0,sp,48
    1058:	fca43c23          	sd	a0,-40(s0)
    105c:	87ae                	mv	a5,a1
    105e:	8732                	mv	a4,a2
    1060:	fcf42a23          	sw	a5,-44(s0)
    1064:	87ba                	mv	a5,a4
    1066:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
    106a:	fd843783          	ld	a5,-40(s0)
    106e:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
    1072:	fe042623          	sw	zero,-20(s0)
    1076:	a00d                	j	1098 <memset+0x48>
    cdst[i] = c;
    1078:	fec42783          	lw	a5,-20(s0)
    107c:	fe043703          	ld	a4,-32(s0)
    1080:	97ba                	add	a5,a5,a4
    1082:	fd442703          	lw	a4,-44(s0)
    1086:	0ff77713          	zext.b	a4,a4
    108a:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
    108e:	fec42783          	lw	a5,-20(s0)
    1092:	2785                	addiw	a5,a5,1
    1094:	fef42623          	sw	a5,-20(s0)
    1098:	fec42783          	lw	a5,-20(s0)
    109c:	fd042703          	lw	a4,-48(s0)
    10a0:	2701                	sext.w	a4,a4
    10a2:	fce7ebe3          	bltu	a5,a4,1078 <memset+0x28>
  }
  return dst;
    10a6:	fd843783          	ld	a5,-40(s0)
}
    10aa:	853e                	mv	a0,a5
    10ac:	70a2                	ld	ra,40(sp)
    10ae:	7402                	ld	s0,32(sp)
    10b0:	6145                	addi	sp,sp,48
    10b2:	8082                	ret

00000000000010b4 <strchr>:

char*
strchr(const char *s, char c)
{
    10b4:	1101                	addi	sp,sp,-32
    10b6:	ec06                	sd	ra,24(sp)
    10b8:	e822                	sd	s0,16(sp)
    10ba:	1000                	addi	s0,sp,32
    10bc:	fea43423          	sd	a0,-24(s0)
    10c0:	87ae                	mv	a5,a1
    10c2:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
    10c6:	a01d                	j	10ec <strchr+0x38>
    if(*s == c)
    10c8:	fe843783          	ld	a5,-24(s0)
    10cc:	0007c703          	lbu	a4,0(a5)
    10d0:	fe744783          	lbu	a5,-25(s0)
    10d4:	0ff7f793          	zext.b	a5,a5
    10d8:	00e79563          	bne	a5,a4,10e2 <strchr+0x2e>
      return (char*)s;
    10dc:	fe843783          	ld	a5,-24(s0)
    10e0:	a821                	j	10f8 <strchr+0x44>
  for(; *s; s++)
    10e2:	fe843783          	ld	a5,-24(s0)
    10e6:	0785                	addi	a5,a5,1
    10e8:	fef43423          	sd	a5,-24(s0)
    10ec:	fe843783          	ld	a5,-24(s0)
    10f0:	0007c783          	lbu	a5,0(a5)
    10f4:	fbf1                	bnez	a5,10c8 <strchr+0x14>
  return 0;
    10f6:	4781                	li	a5,0
}
    10f8:	853e                	mv	a0,a5
    10fa:	60e2                	ld	ra,24(sp)
    10fc:	6442                	ld	s0,16(sp)
    10fe:	6105                	addi	sp,sp,32
    1100:	8082                	ret

0000000000001102 <gets>:

char*
gets(char *buf, int max)
{
    1102:	7179                	addi	sp,sp,-48
    1104:	f406                	sd	ra,40(sp)
    1106:	f022                	sd	s0,32(sp)
    1108:	1800                	addi	s0,sp,48
    110a:	fca43c23          	sd	a0,-40(s0)
    110e:	87ae                	mv	a5,a1
    1110:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1114:	fe042623          	sw	zero,-20(s0)
    1118:	a8a1                	j	1170 <gets+0x6e>
    cc = read(0, &c, 1);
    111a:	fe740793          	addi	a5,s0,-25
    111e:	4605                	li	a2,1
    1120:	85be                	mv	a1,a5
    1122:	4501                	li	a0,0
    1124:	00000097          	auipc	ra,0x0
    1128:	302080e7          	jalr	770(ra) # 1426 <read>
    112c:	87aa                	mv	a5,a0
    112e:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
    1132:	fe842783          	lw	a5,-24(s0)
    1136:	2781                	sext.w	a5,a5
    1138:	04f05663          	blez	a5,1184 <gets+0x82>
      break;
    buf[i++] = c;
    113c:	fec42783          	lw	a5,-20(s0)
    1140:	0017871b          	addiw	a4,a5,1
    1144:	fee42623          	sw	a4,-20(s0)
    1148:	873e                	mv	a4,a5
    114a:	fd843783          	ld	a5,-40(s0)
    114e:	97ba                	add	a5,a5,a4
    1150:	fe744703          	lbu	a4,-25(s0)
    1154:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
    1158:	fe744783          	lbu	a5,-25(s0)
    115c:	873e                	mv	a4,a5
    115e:	47a9                	li	a5,10
    1160:	02f70363          	beq	a4,a5,1186 <gets+0x84>
    1164:	fe744783          	lbu	a5,-25(s0)
    1168:	873e                	mv	a4,a5
    116a:	47b5                	li	a5,13
    116c:	00f70d63          	beq	a4,a5,1186 <gets+0x84>
  for(i=0; i+1 < max; ){
    1170:	fec42783          	lw	a5,-20(s0)
    1174:	2785                	addiw	a5,a5,1
    1176:	2781                	sext.w	a5,a5
    1178:	fd442703          	lw	a4,-44(s0)
    117c:	2701                	sext.w	a4,a4
    117e:	f8e7cee3          	blt	a5,a4,111a <gets+0x18>
    1182:	a011                	j	1186 <gets+0x84>
      break;
    1184:	0001                	nop
      break;
  }
  buf[i] = '\0';
    1186:	fec42783          	lw	a5,-20(s0)
    118a:	fd843703          	ld	a4,-40(s0)
    118e:	97ba                	add	a5,a5,a4
    1190:	00078023          	sb	zero,0(a5)
  return buf;
    1194:	fd843783          	ld	a5,-40(s0)
}
    1198:	853e                	mv	a0,a5
    119a:	70a2                	ld	ra,40(sp)
    119c:	7402                	ld	s0,32(sp)
    119e:	6145                	addi	sp,sp,48
    11a0:	8082                	ret

00000000000011a2 <stat>:

int
stat(const char *n, struct stat *st)
{
    11a2:	7179                	addi	sp,sp,-48
    11a4:	f406                	sd	ra,40(sp)
    11a6:	f022                	sd	s0,32(sp)
    11a8:	1800                	addi	s0,sp,48
    11aa:	fca43c23          	sd	a0,-40(s0)
    11ae:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11b2:	4581                	li	a1,0
    11b4:	fd843503          	ld	a0,-40(s0)
    11b8:	00000097          	auipc	ra,0x0
    11bc:	296080e7          	jalr	662(ra) # 144e <open>
    11c0:	87aa                	mv	a5,a0
    11c2:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
    11c6:	fec42783          	lw	a5,-20(s0)
    11ca:	2781                	sext.w	a5,a5
    11cc:	0007d463          	bgez	a5,11d4 <stat+0x32>
    return -1;
    11d0:	57fd                	li	a5,-1
    11d2:	a035                	j	11fe <stat+0x5c>
  r = fstat(fd, st);
    11d4:	fec42783          	lw	a5,-20(s0)
    11d8:	fd043583          	ld	a1,-48(s0)
    11dc:	853e                	mv	a0,a5
    11de:	00000097          	auipc	ra,0x0
    11e2:	288080e7          	jalr	648(ra) # 1466 <fstat>
    11e6:	87aa                	mv	a5,a0
    11e8:	fef42423          	sw	a5,-24(s0)
  close(fd);
    11ec:	fec42783          	lw	a5,-20(s0)
    11f0:	853e                	mv	a0,a5
    11f2:	00000097          	auipc	ra,0x0
    11f6:	244080e7          	jalr	580(ra) # 1436 <close>
  return r;
    11fa:	fe842783          	lw	a5,-24(s0)
}
    11fe:	853e                	mv	a0,a5
    1200:	70a2                	ld	ra,40(sp)
    1202:	7402                	ld	s0,32(sp)
    1204:	6145                	addi	sp,sp,48
    1206:	8082                	ret

0000000000001208 <atoi>:

int
atoi(const char *s)
{
    1208:	7179                	addi	sp,sp,-48
    120a:	f406                	sd	ra,40(sp)
    120c:	f022                	sd	s0,32(sp)
    120e:	1800                	addi	s0,sp,48
    1210:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
    1214:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
    1218:	a81d                	j	124e <atoi+0x46>
    n = n*10 + *s++ - '0';
    121a:	fec42783          	lw	a5,-20(s0)
    121e:	873e                	mv	a4,a5
    1220:	87ba                	mv	a5,a4
    1222:	0027979b          	slliw	a5,a5,0x2
    1226:	9fb9                	addw	a5,a5,a4
    1228:	0017979b          	slliw	a5,a5,0x1
    122c:	0007871b          	sext.w	a4,a5
    1230:	fd843783          	ld	a5,-40(s0)
    1234:	00178693          	addi	a3,a5,1
    1238:	fcd43c23          	sd	a3,-40(s0)
    123c:	0007c783          	lbu	a5,0(a5)
    1240:	2781                	sext.w	a5,a5
    1242:	9fb9                	addw	a5,a5,a4
    1244:	2781                	sext.w	a5,a5
    1246:	fd07879b          	addiw	a5,a5,-48
    124a:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
    124e:	fd843783          	ld	a5,-40(s0)
    1252:	0007c783          	lbu	a5,0(a5)
    1256:	873e                	mv	a4,a5
    1258:	02f00793          	li	a5,47
    125c:	00e7fb63          	bgeu	a5,a4,1272 <atoi+0x6a>
    1260:	fd843783          	ld	a5,-40(s0)
    1264:	0007c783          	lbu	a5,0(a5)
    1268:	873e                	mv	a4,a5
    126a:	03900793          	li	a5,57
    126e:	fae7f6e3          	bgeu	a5,a4,121a <atoi+0x12>
  return n;
    1272:	fec42783          	lw	a5,-20(s0)
}
    1276:	853e                	mv	a0,a5
    1278:	70a2                	ld	ra,40(sp)
    127a:	7402                	ld	s0,32(sp)
    127c:	6145                	addi	sp,sp,48
    127e:	8082                	ret

0000000000001280 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1280:	7139                	addi	sp,sp,-64
    1282:	fc06                	sd	ra,56(sp)
    1284:	f822                	sd	s0,48(sp)
    1286:	0080                	addi	s0,sp,64
    1288:	fca43c23          	sd	a0,-40(s0)
    128c:	fcb43823          	sd	a1,-48(s0)
    1290:	87b2                	mv	a5,a2
    1292:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
    1296:	fd843783          	ld	a5,-40(s0)
    129a:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
    129e:	fd043783          	ld	a5,-48(s0)
    12a2:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
    12a6:	fe043703          	ld	a4,-32(s0)
    12aa:	fe843783          	ld	a5,-24(s0)
    12ae:	02e7fc63          	bgeu	a5,a4,12e6 <memmove+0x66>
    while(n-- > 0)
    12b2:	a00d                	j	12d4 <memmove+0x54>
      *dst++ = *src++;
    12b4:	fe043703          	ld	a4,-32(s0)
    12b8:	00170793          	addi	a5,a4,1
    12bc:	fef43023          	sd	a5,-32(s0)
    12c0:	fe843783          	ld	a5,-24(s0)
    12c4:	00178693          	addi	a3,a5,1
    12c8:	fed43423          	sd	a3,-24(s0)
    12cc:	00074703          	lbu	a4,0(a4)
    12d0:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
    12d4:	fcc42783          	lw	a5,-52(s0)
    12d8:	fff7871b          	addiw	a4,a5,-1
    12dc:	fce42623          	sw	a4,-52(s0)
    12e0:	fcf04ae3          	bgtz	a5,12b4 <memmove+0x34>
    12e4:	a891                	j	1338 <memmove+0xb8>
  } else {
    dst += n;
    12e6:	fcc42783          	lw	a5,-52(s0)
    12ea:	fe843703          	ld	a4,-24(s0)
    12ee:	97ba                	add	a5,a5,a4
    12f0:	fef43423          	sd	a5,-24(s0)
    src += n;
    12f4:	fcc42783          	lw	a5,-52(s0)
    12f8:	fe043703          	ld	a4,-32(s0)
    12fc:	97ba                	add	a5,a5,a4
    12fe:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
    1302:	a01d                	j	1328 <memmove+0xa8>
      *--dst = *--src;
    1304:	fe043783          	ld	a5,-32(s0)
    1308:	17fd                	addi	a5,a5,-1
    130a:	fef43023          	sd	a5,-32(s0)
    130e:	fe843783          	ld	a5,-24(s0)
    1312:	17fd                	addi	a5,a5,-1
    1314:	fef43423          	sd	a5,-24(s0)
    1318:	fe043783          	ld	a5,-32(s0)
    131c:	0007c703          	lbu	a4,0(a5)
    1320:	fe843783          	ld	a5,-24(s0)
    1324:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
    1328:	fcc42783          	lw	a5,-52(s0)
    132c:	fff7871b          	addiw	a4,a5,-1
    1330:	fce42623          	sw	a4,-52(s0)
    1334:	fcf048e3          	bgtz	a5,1304 <memmove+0x84>
  }
  return vdst;
    1338:	fd843783          	ld	a5,-40(s0)
}
    133c:	853e                	mv	a0,a5
    133e:	70e2                	ld	ra,56(sp)
    1340:	7442                	ld	s0,48(sp)
    1342:	6121                	addi	sp,sp,64
    1344:	8082                	ret

0000000000001346 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    1346:	7139                	addi	sp,sp,-64
    1348:	fc06                	sd	ra,56(sp)
    134a:	f822                	sd	s0,48(sp)
    134c:	0080                	addi	s0,sp,64
    134e:	fca43c23          	sd	a0,-40(s0)
    1352:	fcb43823          	sd	a1,-48(s0)
    1356:	87b2                	mv	a5,a2
    1358:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
    135c:	fd843783          	ld	a5,-40(s0)
    1360:	fef43423          	sd	a5,-24(s0)
    1364:	fd043783          	ld	a5,-48(s0)
    1368:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
    136c:	a0a1                	j	13b4 <memcmp+0x6e>
    if (*p1 != *p2) {
    136e:	fe843783          	ld	a5,-24(s0)
    1372:	0007c703          	lbu	a4,0(a5)
    1376:	fe043783          	ld	a5,-32(s0)
    137a:	0007c783          	lbu	a5,0(a5)
    137e:	02f70163          	beq	a4,a5,13a0 <memcmp+0x5a>
      return *p1 - *p2;
    1382:	fe843783          	ld	a5,-24(s0)
    1386:	0007c783          	lbu	a5,0(a5)
    138a:	0007871b          	sext.w	a4,a5
    138e:	fe043783          	ld	a5,-32(s0)
    1392:	0007c783          	lbu	a5,0(a5)
    1396:	2781                	sext.w	a5,a5
    1398:	40f707bb          	subw	a5,a4,a5
    139c:	2781                	sext.w	a5,a5
    139e:	a01d                	j	13c4 <memcmp+0x7e>
    }
    p1++;
    13a0:	fe843783          	ld	a5,-24(s0)
    13a4:	0785                	addi	a5,a5,1
    13a6:	fef43423          	sd	a5,-24(s0)
    p2++;
    13aa:	fe043783          	ld	a5,-32(s0)
    13ae:	0785                	addi	a5,a5,1
    13b0:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
    13b4:	fcc42783          	lw	a5,-52(s0)
    13b8:	fff7871b          	addiw	a4,a5,-1
    13bc:	fce42623          	sw	a4,-52(s0)
    13c0:	f7dd                	bnez	a5,136e <memcmp+0x28>
  }
  return 0;
    13c2:	4781                	li	a5,0
}
    13c4:	853e                	mv	a0,a5
    13c6:	70e2                	ld	ra,56(sp)
    13c8:	7442                	ld	s0,48(sp)
    13ca:	6121                	addi	sp,sp,64
    13cc:	8082                	ret

00000000000013ce <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    13ce:	7179                	addi	sp,sp,-48
    13d0:	f406                	sd	ra,40(sp)
    13d2:	f022                	sd	s0,32(sp)
    13d4:	1800                	addi	s0,sp,48
    13d6:	fea43423          	sd	a0,-24(s0)
    13da:	feb43023          	sd	a1,-32(s0)
    13de:	87b2                	mv	a5,a2
    13e0:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
    13e4:	fdc42783          	lw	a5,-36(s0)
    13e8:	863e                	mv	a2,a5
    13ea:	fe043583          	ld	a1,-32(s0)
    13ee:	fe843503          	ld	a0,-24(s0)
    13f2:	00000097          	auipc	ra,0x0
    13f6:	e8e080e7          	jalr	-370(ra) # 1280 <memmove>
    13fa:	87aa                	mv	a5,a0
}
    13fc:	853e                	mv	a0,a5
    13fe:	70a2                	ld	ra,40(sp)
    1400:	7402                	ld	s0,32(sp)
    1402:	6145                	addi	sp,sp,48
    1404:	8082                	ret

0000000000001406 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    1406:	4885                	li	a7,1
 ecall
    1408:	00000073          	ecall
 ret
    140c:	8082                	ret

000000000000140e <exit>:
.global exit
exit:
 li a7, SYS_exit
    140e:	4889                	li	a7,2
 ecall
    1410:	00000073          	ecall
 ret
    1414:	8082                	ret

0000000000001416 <wait>:
.global wait
wait:
 li a7, SYS_wait
    1416:	488d                	li	a7,3
 ecall
    1418:	00000073          	ecall
 ret
    141c:	8082                	ret

000000000000141e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    141e:	4891                	li	a7,4
 ecall
    1420:	00000073          	ecall
 ret
    1424:	8082                	ret

0000000000001426 <read>:
.global read
read:
 li a7, SYS_read
    1426:	4895                	li	a7,5
 ecall
    1428:	00000073          	ecall
 ret
    142c:	8082                	ret

000000000000142e <write>:
.global write
write:
 li a7, SYS_write
    142e:	48c1                	li	a7,16
 ecall
    1430:	00000073          	ecall
 ret
    1434:	8082                	ret

0000000000001436 <close>:
.global close
close:
 li a7, SYS_close
    1436:	48d5                	li	a7,21
 ecall
    1438:	00000073          	ecall
 ret
    143c:	8082                	ret

000000000000143e <kill>:
.global kill
kill:
 li a7, SYS_kill
    143e:	4899                	li	a7,6
 ecall
    1440:	00000073          	ecall
 ret
    1444:	8082                	ret

0000000000001446 <exec>:
.global exec
exec:
 li a7, SYS_exec
    1446:	489d                	li	a7,7
 ecall
    1448:	00000073          	ecall
 ret
    144c:	8082                	ret

000000000000144e <open>:
.global open
open:
 li a7, SYS_open
    144e:	48bd                	li	a7,15
 ecall
    1450:	00000073          	ecall
 ret
    1454:	8082                	ret

0000000000001456 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    1456:	48c5                	li	a7,17
 ecall
    1458:	00000073          	ecall
 ret
    145c:	8082                	ret

000000000000145e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    145e:	48c9                	li	a7,18
 ecall
    1460:	00000073          	ecall
 ret
    1464:	8082                	ret

0000000000001466 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    1466:	48a1                	li	a7,8
 ecall
    1468:	00000073          	ecall
 ret
    146c:	8082                	ret

000000000000146e <link>:
.global link
link:
 li a7, SYS_link
    146e:	48cd                	li	a7,19
 ecall
    1470:	00000073          	ecall
 ret
    1474:	8082                	ret

0000000000001476 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    1476:	48d1                	li	a7,20
 ecall
    1478:	00000073          	ecall
 ret
    147c:	8082                	ret

000000000000147e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    147e:	48a5                	li	a7,9
 ecall
    1480:	00000073          	ecall
 ret
    1484:	8082                	ret

0000000000001486 <dup>:
.global dup
dup:
 li a7, SYS_dup
    1486:	48a9                	li	a7,10
 ecall
    1488:	00000073          	ecall
 ret
    148c:	8082                	ret

000000000000148e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    148e:	48ad                	li	a7,11
 ecall
    1490:	00000073          	ecall
 ret
    1494:	8082                	ret

0000000000001496 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    1496:	48b1                	li	a7,12
 ecall
    1498:	00000073          	ecall
 ret
    149c:	8082                	ret

000000000000149e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    149e:	48b5                	li	a7,13
 ecall
    14a0:	00000073          	ecall
 ret
    14a4:	8082                	ret

00000000000014a6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    14a6:	48b9                	li	a7,14
 ecall
    14a8:	00000073          	ecall
 ret
    14ac:	8082                	ret

00000000000014ae <ps>:
.global ps
ps:
 li a7, SYS_ps
    14ae:	48d9                	li	a7,22
 ecall
    14b0:	00000073          	ecall
 ret
    14b4:	8082                	ret

00000000000014b6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    14b6:	1101                	addi	sp,sp,-32
    14b8:	ec06                	sd	ra,24(sp)
    14ba:	e822                	sd	s0,16(sp)
    14bc:	1000                	addi	s0,sp,32
    14be:	87aa                	mv	a5,a0
    14c0:	872e                	mv	a4,a1
    14c2:	fef42623          	sw	a5,-20(s0)
    14c6:	87ba                	mv	a5,a4
    14c8:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
    14cc:	feb40713          	addi	a4,s0,-21
    14d0:	fec42783          	lw	a5,-20(s0)
    14d4:	4605                	li	a2,1
    14d6:	85ba                	mv	a1,a4
    14d8:	853e                	mv	a0,a5
    14da:	00000097          	auipc	ra,0x0
    14de:	f54080e7          	jalr	-172(ra) # 142e <write>
}
    14e2:	0001                	nop
    14e4:	60e2                	ld	ra,24(sp)
    14e6:	6442                	ld	s0,16(sp)
    14e8:	6105                	addi	sp,sp,32
    14ea:	8082                	ret

00000000000014ec <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    14ec:	7139                	addi	sp,sp,-64
    14ee:	fc06                	sd	ra,56(sp)
    14f0:	f822                	sd	s0,48(sp)
    14f2:	0080                	addi	s0,sp,64
    14f4:	87aa                	mv	a5,a0
    14f6:	8736                	mv	a4,a3
    14f8:	fcf42623          	sw	a5,-52(s0)
    14fc:	87ae                	mv	a5,a1
    14fe:	fcf42423          	sw	a5,-56(s0)
    1502:	87b2                	mv	a5,a2
    1504:	fcf42223          	sw	a5,-60(s0)
    1508:	87ba                	mv	a5,a4
    150a:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    150e:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
    1512:	fc042783          	lw	a5,-64(s0)
    1516:	2781                	sext.w	a5,a5
    1518:	c38d                	beqz	a5,153a <printint+0x4e>
    151a:	fc842783          	lw	a5,-56(s0)
    151e:	2781                	sext.w	a5,a5
    1520:	0007dd63          	bgez	a5,153a <printint+0x4e>
    neg = 1;
    1524:	4785                	li	a5,1
    1526:	fef42423          	sw	a5,-24(s0)
    x = -xx;
    152a:	fc842783          	lw	a5,-56(s0)
    152e:	40f007bb          	negw	a5,a5
    1532:	2781                	sext.w	a5,a5
    1534:	fef42223          	sw	a5,-28(s0)
    1538:	a029                	j	1542 <printint+0x56>
  } else {
    x = xx;
    153a:	fc842783          	lw	a5,-56(s0)
    153e:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
    1542:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
    1546:	fc442783          	lw	a5,-60(s0)
    154a:	fe442703          	lw	a4,-28(s0)
    154e:	02f777bb          	remuw	a5,a4,a5
    1552:	0007871b          	sext.w	a4,a5
    1556:	fec42783          	lw	a5,-20(s0)
    155a:	0017869b          	addiw	a3,a5,1
    155e:	fed42623          	sw	a3,-20(s0)
    1562:	00001697          	auipc	a3,0x1
    1566:	aae68693          	addi	a3,a3,-1362 # 2010 <digits>
    156a:	1702                	slli	a4,a4,0x20
    156c:	9301                	srli	a4,a4,0x20
    156e:	9736                	add	a4,a4,a3
    1570:	00074703          	lbu	a4,0(a4)
    1574:	17c1                	addi	a5,a5,-16
    1576:	97a2                	add	a5,a5,s0
    1578:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
    157c:	fc442783          	lw	a5,-60(s0)
    1580:	fe442703          	lw	a4,-28(s0)
    1584:	02f757bb          	divuw	a5,a4,a5
    1588:	fef42223          	sw	a5,-28(s0)
    158c:	fe442783          	lw	a5,-28(s0)
    1590:	2781                	sext.w	a5,a5
    1592:	fbd5                	bnez	a5,1546 <printint+0x5a>
  if(neg)
    1594:	fe842783          	lw	a5,-24(s0)
    1598:	2781                	sext.w	a5,a5
    159a:	cf85                	beqz	a5,15d2 <printint+0xe6>
    buf[i++] = '-';
    159c:	fec42783          	lw	a5,-20(s0)
    15a0:	0017871b          	addiw	a4,a5,1
    15a4:	fee42623          	sw	a4,-20(s0)
    15a8:	17c1                	addi	a5,a5,-16
    15aa:	97a2                	add	a5,a5,s0
    15ac:	02d00713          	li	a4,45
    15b0:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
    15b4:	a839                	j	15d2 <printint+0xe6>
    putc(fd, buf[i]);
    15b6:	fec42783          	lw	a5,-20(s0)
    15ba:	17c1                	addi	a5,a5,-16
    15bc:	97a2                	add	a5,a5,s0
    15be:	fe07c703          	lbu	a4,-32(a5)
    15c2:	fcc42783          	lw	a5,-52(s0)
    15c6:	85ba                	mv	a1,a4
    15c8:	853e                	mv	a0,a5
    15ca:	00000097          	auipc	ra,0x0
    15ce:	eec080e7          	jalr	-276(ra) # 14b6 <putc>
  while(--i >= 0)
    15d2:	fec42783          	lw	a5,-20(s0)
    15d6:	37fd                	addiw	a5,a5,-1
    15d8:	fef42623          	sw	a5,-20(s0)
    15dc:	fec42783          	lw	a5,-20(s0)
    15e0:	2781                	sext.w	a5,a5
    15e2:	fc07dae3          	bgez	a5,15b6 <printint+0xca>
}
    15e6:	0001                	nop
    15e8:	0001                	nop
    15ea:	70e2                	ld	ra,56(sp)
    15ec:	7442                	ld	s0,48(sp)
    15ee:	6121                	addi	sp,sp,64
    15f0:	8082                	ret

00000000000015f2 <printptr>:

static void
printptr(int fd, uint64 x) {
    15f2:	7179                	addi	sp,sp,-48
    15f4:	f406                	sd	ra,40(sp)
    15f6:	f022                	sd	s0,32(sp)
    15f8:	1800                	addi	s0,sp,48
    15fa:	87aa                	mv	a5,a0
    15fc:	fcb43823          	sd	a1,-48(s0)
    1600:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
    1604:	fdc42783          	lw	a5,-36(s0)
    1608:	03000593          	li	a1,48
    160c:	853e                	mv	a0,a5
    160e:	00000097          	auipc	ra,0x0
    1612:	ea8080e7          	jalr	-344(ra) # 14b6 <putc>
  putc(fd, 'x');
    1616:	fdc42783          	lw	a5,-36(s0)
    161a:	07800593          	li	a1,120
    161e:	853e                	mv	a0,a5
    1620:	00000097          	auipc	ra,0x0
    1624:	e96080e7          	jalr	-362(ra) # 14b6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1628:	fe042623          	sw	zero,-20(s0)
    162c:	a82d                	j	1666 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    162e:	fd043783          	ld	a5,-48(s0)
    1632:	93f1                	srli	a5,a5,0x3c
    1634:	00001717          	auipc	a4,0x1
    1638:	9dc70713          	addi	a4,a4,-1572 # 2010 <digits>
    163c:	97ba                	add	a5,a5,a4
    163e:	0007c703          	lbu	a4,0(a5)
    1642:	fdc42783          	lw	a5,-36(s0)
    1646:	85ba                	mv	a1,a4
    1648:	853e                	mv	a0,a5
    164a:	00000097          	auipc	ra,0x0
    164e:	e6c080e7          	jalr	-404(ra) # 14b6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1652:	fec42783          	lw	a5,-20(s0)
    1656:	2785                	addiw	a5,a5,1
    1658:	fef42623          	sw	a5,-20(s0)
    165c:	fd043783          	ld	a5,-48(s0)
    1660:	0792                	slli	a5,a5,0x4
    1662:	fcf43823          	sd	a5,-48(s0)
    1666:	fec42703          	lw	a4,-20(s0)
    166a:	47bd                	li	a5,15
    166c:	fce7f1e3          	bgeu	a5,a4,162e <printptr+0x3c>
}
    1670:	0001                	nop
    1672:	0001                	nop
    1674:	70a2                	ld	ra,40(sp)
    1676:	7402                	ld	s0,32(sp)
    1678:	6145                	addi	sp,sp,48
    167a:	8082                	ret

000000000000167c <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    167c:	715d                	addi	sp,sp,-80
    167e:	e486                	sd	ra,72(sp)
    1680:	e0a2                	sd	s0,64(sp)
    1682:	0880                	addi	s0,sp,80
    1684:	87aa                	mv	a5,a0
    1686:	fcb43023          	sd	a1,-64(s0)
    168a:	fac43c23          	sd	a2,-72(s0)
    168e:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
    1692:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
    1696:	fe042223          	sw	zero,-28(s0)
    169a:	a42d                	j	18c4 <vprintf+0x248>
    c = fmt[i] & 0xff;
    169c:	fe442783          	lw	a5,-28(s0)
    16a0:	fc043703          	ld	a4,-64(s0)
    16a4:	97ba                	add	a5,a5,a4
    16a6:	0007c783          	lbu	a5,0(a5)
    16aa:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
    16ae:	fe042783          	lw	a5,-32(s0)
    16b2:	2781                	sext.w	a5,a5
    16b4:	eb9d                	bnez	a5,16ea <vprintf+0x6e>
      if(c == '%'){
    16b6:	fdc42783          	lw	a5,-36(s0)
    16ba:	0007871b          	sext.w	a4,a5
    16be:	02500793          	li	a5,37
    16c2:	00f71763          	bne	a4,a5,16d0 <vprintf+0x54>
        state = '%';
    16c6:	02500793          	li	a5,37
    16ca:	fef42023          	sw	a5,-32(s0)
    16ce:	a2f5                	j	18ba <vprintf+0x23e>
      } else {
        putc(fd, c);
    16d0:	fdc42783          	lw	a5,-36(s0)
    16d4:	0ff7f713          	zext.b	a4,a5
    16d8:	fcc42783          	lw	a5,-52(s0)
    16dc:	85ba                	mv	a1,a4
    16de:	853e                	mv	a0,a5
    16e0:	00000097          	auipc	ra,0x0
    16e4:	dd6080e7          	jalr	-554(ra) # 14b6 <putc>
    16e8:	aac9                	j	18ba <vprintf+0x23e>
      }
    } else if(state == '%'){
    16ea:	fe042783          	lw	a5,-32(s0)
    16ee:	0007871b          	sext.w	a4,a5
    16f2:	02500793          	li	a5,37
    16f6:	1cf71263          	bne	a4,a5,18ba <vprintf+0x23e>
      if(c == 'd'){
    16fa:	fdc42783          	lw	a5,-36(s0)
    16fe:	0007871b          	sext.w	a4,a5
    1702:	06400793          	li	a5,100
    1706:	02f71463          	bne	a4,a5,172e <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
    170a:	fb843783          	ld	a5,-72(s0)
    170e:	00878713          	addi	a4,a5,8
    1712:	fae43c23          	sd	a4,-72(s0)
    1716:	4398                	lw	a4,0(a5)
    1718:	fcc42783          	lw	a5,-52(s0)
    171c:	4685                	li	a3,1
    171e:	4629                	li	a2,10
    1720:	85ba                	mv	a1,a4
    1722:	853e                	mv	a0,a5
    1724:	00000097          	auipc	ra,0x0
    1728:	dc8080e7          	jalr	-568(ra) # 14ec <printint>
    172c:	a269                	j	18b6 <vprintf+0x23a>
      } else if(c == 'l') {
    172e:	fdc42783          	lw	a5,-36(s0)
    1732:	0007871b          	sext.w	a4,a5
    1736:	06c00793          	li	a5,108
    173a:	02f71663          	bne	a4,a5,1766 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
    173e:	fb843783          	ld	a5,-72(s0)
    1742:	00878713          	addi	a4,a5,8
    1746:	fae43c23          	sd	a4,-72(s0)
    174a:	639c                	ld	a5,0(a5)
    174c:	0007871b          	sext.w	a4,a5
    1750:	fcc42783          	lw	a5,-52(s0)
    1754:	4681                	li	a3,0
    1756:	4629                	li	a2,10
    1758:	85ba                	mv	a1,a4
    175a:	853e                	mv	a0,a5
    175c:	00000097          	auipc	ra,0x0
    1760:	d90080e7          	jalr	-624(ra) # 14ec <printint>
    1764:	aa89                	j	18b6 <vprintf+0x23a>
      } else if(c == 'x') {
    1766:	fdc42783          	lw	a5,-36(s0)
    176a:	0007871b          	sext.w	a4,a5
    176e:	07800793          	li	a5,120
    1772:	02f71463          	bne	a4,a5,179a <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
    1776:	fb843783          	ld	a5,-72(s0)
    177a:	00878713          	addi	a4,a5,8
    177e:	fae43c23          	sd	a4,-72(s0)
    1782:	4398                	lw	a4,0(a5)
    1784:	fcc42783          	lw	a5,-52(s0)
    1788:	4681                	li	a3,0
    178a:	4641                	li	a2,16
    178c:	85ba                	mv	a1,a4
    178e:	853e                	mv	a0,a5
    1790:	00000097          	auipc	ra,0x0
    1794:	d5c080e7          	jalr	-676(ra) # 14ec <printint>
    1798:	aa39                	j	18b6 <vprintf+0x23a>
      } else if(c == 'p') {
    179a:	fdc42783          	lw	a5,-36(s0)
    179e:	0007871b          	sext.w	a4,a5
    17a2:	07000793          	li	a5,112
    17a6:	02f71263          	bne	a4,a5,17ca <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
    17aa:	fb843783          	ld	a5,-72(s0)
    17ae:	00878713          	addi	a4,a5,8
    17b2:	fae43c23          	sd	a4,-72(s0)
    17b6:	6398                	ld	a4,0(a5)
    17b8:	fcc42783          	lw	a5,-52(s0)
    17bc:	85ba                	mv	a1,a4
    17be:	853e                	mv	a0,a5
    17c0:	00000097          	auipc	ra,0x0
    17c4:	e32080e7          	jalr	-462(ra) # 15f2 <printptr>
    17c8:	a0fd                	j	18b6 <vprintf+0x23a>
      } else if(c == 's'){
    17ca:	fdc42783          	lw	a5,-36(s0)
    17ce:	0007871b          	sext.w	a4,a5
    17d2:	07300793          	li	a5,115
    17d6:	04f71c63          	bne	a4,a5,182e <vprintf+0x1b2>
        s = va_arg(ap, char*);
    17da:	fb843783          	ld	a5,-72(s0)
    17de:	00878713          	addi	a4,a5,8
    17e2:	fae43c23          	sd	a4,-72(s0)
    17e6:	639c                	ld	a5,0(a5)
    17e8:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
    17ec:	fe843783          	ld	a5,-24(s0)
    17f0:	eb8d                	bnez	a5,1822 <vprintf+0x1a6>
          s = "(null)";
    17f2:	00000797          	auipc	a5,0x0
    17f6:	5be78793          	addi	a5,a5,1470 # 1db0 <malloc+0x282>
    17fa:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
    17fe:	a015                	j	1822 <vprintf+0x1a6>
          putc(fd, *s);
    1800:	fe843783          	ld	a5,-24(s0)
    1804:	0007c703          	lbu	a4,0(a5)
    1808:	fcc42783          	lw	a5,-52(s0)
    180c:	85ba                	mv	a1,a4
    180e:	853e                	mv	a0,a5
    1810:	00000097          	auipc	ra,0x0
    1814:	ca6080e7          	jalr	-858(ra) # 14b6 <putc>
          s++;
    1818:	fe843783          	ld	a5,-24(s0)
    181c:	0785                	addi	a5,a5,1
    181e:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
    1822:	fe843783          	ld	a5,-24(s0)
    1826:	0007c783          	lbu	a5,0(a5)
    182a:	fbf9                	bnez	a5,1800 <vprintf+0x184>
    182c:	a069                	j	18b6 <vprintf+0x23a>
        }
      } else if(c == 'c'){
    182e:	fdc42783          	lw	a5,-36(s0)
    1832:	0007871b          	sext.w	a4,a5
    1836:	06300793          	li	a5,99
    183a:	02f71463          	bne	a4,a5,1862 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
    183e:	fb843783          	ld	a5,-72(s0)
    1842:	00878713          	addi	a4,a5,8
    1846:	fae43c23          	sd	a4,-72(s0)
    184a:	439c                	lw	a5,0(a5)
    184c:	0ff7f713          	zext.b	a4,a5
    1850:	fcc42783          	lw	a5,-52(s0)
    1854:	85ba                	mv	a1,a4
    1856:	853e                	mv	a0,a5
    1858:	00000097          	auipc	ra,0x0
    185c:	c5e080e7          	jalr	-930(ra) # 14b6 <putc>
    1860:	a899                	j	18b6 <vprintf+0x23a>
      } else if(c == '%'){
    1862:	fdc42783          	lw	a5,-36(s0)
    1866:	0007871b          	sext.w	a4,a5
    186a:	02500793          	li	a5,37
    186e:	00f71f63          	bne	a4,a5,188c <vprintf+0x210>
        putc(fd, c);
    1872:	fdc42783          	lw	a5,-36(s0)
    1876:	0ff7f713          	zext.b	a4,a5
    187a:	fcc42783          	lw	a5,-52(s0)
    187e:	85ba                	mv	a1,a4
    1880:	853e                	mv	a0,a5
    1882:	00000097          	auipc	ra,0x0
    1886:	c34080e7          	jalr	-972(ra) # 14b6 <putc>
    188a:	a035                	j	18b6 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    188c:	fcc42783          	lw	a5,-52(s0)
    1890:	02500593          	li	a1,37
    1894:	853e                	mv	a0,a5
    1896:	00000097          	auipc	ra,0x0
    189a:	c20080e7          	jalr	-992(ra) # 14b6 <putc>
        putc(fd, c);
    189e:	fdc42783          	lw	a5,-36(s0)
    18a2:	0ff7f713          	zext.b	a4,a5
    18a6:	fcc42783          	lw	a5,-52(s0)
    18aa:	85ba                	mv	a1,a4
    18ac:	853e                	mv	a0,a5
    18ae:	00000097          	auipc	ra,0x0
    18b2:	c08080e7          	jalr	-1016(ra) # 14b6 <putc>
      }
      state = 0;
    18b6:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
    18ba:	fe442783          	lw	a5,-28(s0)
    18be:	2785                	addiw	a5,a5,1
    18c0:	fef42223          	sw	a5,-28(s0)
    18c4:	fe442783          	lw	a5,-28(s0)
    18c8:	fc043703          	ld	a4,-64(s0)
    18cc:	97ba                	add	a5,a5,a4
    18ce:	0007c783          	lbu	a5,0(a5)
    18d2:	dc0795e3          	bnez	a5,169c <vprintf+0x20>
    }
  }
}
    18d6:	0001                	nop
    18d8:	0001                	nop
    18da:	60a6                	ld	ra,72(sp)
    18dc:	6406                	ld	s0,64(sp)
    18de:	6161                	addi	sp,sp,80
    18e0:	8082                	ret

00000000000018e2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    18e2:	7159                	addi	sp,sp,-112
    18e4:	fc06                	sd	ra,56(sp)
    18e6:	f822                	sd	s0,48(sp)
    18e8:	0080                	addi	s0,sp,64
    18ea:	fcb43823          	sd	a1,-48(s0)
    18ee:	e010                	sd	a2,0(s0)
    18f0:	e414                	sd	a3,8(s0)
    18f2:	e818                	sd	a4,16(s0)
    18f4:	ec1c                	sd	a5,24(s0)
    18f6:	03043023          	sd	a6,32(s0)
    18fa:	03143423          	sd	a7,40(s0)
    18fe:	87aa                	mv	a5,a0
    1900:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
    1904:	03040793          	addi	a5,s0,48
    1908:	fcf43423          	sd	a5,-56(s0)
    190c:	fc843783          	ld	a5,-56(s0)
    1910:	fd078793          	addi	a5,a5,-48
    1914:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
    1918:	fe843703          	ld	a4,-24(s0)
    191c:	fdc42783          	lw	a5,-36(s0)
    1920:	863a                	mv	a2,a4
    1922:	fd043583          	ld	a1,-48(s0)
    1926:	853e                	mv	a0,a5
    1928:	00000097          	auipc	ra,0x0
    192c:	d54080e7          	jalr	-684(ra) # 167c <vprintf>
}
    1930:	0001                	nop
    1932:	70e2                	ld	ra,56(sp)
    1934:	7442                	ld	s0,48(sp)
    1936:	6165                	addi	sp,sp,112
    1938:	8082                	ret

000000000000193a <printf>:

void
printf(const char *fmt, ...)
{
    193a:	7159                	addi	sp,sp,-112
    193c:	f406                	sd	ra,40(sp)
    193e:	f022                	sd	s0,32(sp)
    1940:	1800                	addi	s0,sp,48
    1942:	fca43c23          	sd	a0,-40(s0)
    1946:	e40c                	sd	a1,8(s0)
    1948:	e810                	sd	a2,16(s0)
    194a:	ec14                	sd	a3,24(s0)
    194c:	f018                	sd	a4,32(s0)
    194e:	f41c                	sd	a5,40(s0)
    1950:	03043823          	sd	a6,48(s0)
    1954:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1958:	04040793          	addi	a5,s0,64
    195c:	fcf43823          	sd	a5,-48(s0)
    1960:	fd043783          	ld	a5,-48(s0)
    1964:	fc878793          	addi	a5,a5,-56
    1968:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
    196c:	fe843783          	ld	a5,-24(s0)
    1970:	863e                	mv	a2,a5
    1972:	fd843583          	ld	a1,-40(s0)
    1976:	4505                	li	a0,1
    1978:	00000097          	auipc	ra,0x0
    197c:	d04080e7          	jalr	-764(ra) # 167c <vprintf>
}
    1980:	0001                	nop
    1982:	70a2                	ld	ra,40(sp)
    1984:	7402                	ld	s0,32(sp)
    1986:	6165                	addi	sp,sp,112
    1988:	8082                	ret

000000000000198a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    198a:	7179                	addi	sp,sp,-48
    198c:	f406                	sd	ra,40(sp)
    198e:	f022                	sd	s0,32(sp)
    1990:	1800                	addi	s0,sp,48
    1992:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1996:	fd843783          	ld	a5,-40(s0)
    199a:	17c1                	addi	a5,a5,-16
    199c:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    19a0:	00000797          	auipc	a5,0x0
    19a4:	70878793          	addi	a5,a5,1800 # 20a8 <freep>
    19a8:	639c                	ld	a5,0(a5)
    19aa:	fef43423          	sd	a5,-24(s0)
    19ae:	a815                	j	19e2 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    19b0:	fe843783          	ld	a5,-24(s0)
    19b4:	639c                	ld	a5,0(a5)
    19b6:	fe843703          	ld	a4,-24(s0)
    19ba:	00f76f63          	bltu	a4,a5,19d8 <free+0x4e>
    19be:	fe043703          	ld	a4,-32(s0)
    19c2:	fe843783          	ld	a5,-24(s0)
    19c6:	02e7eb63          	bltu	a5,a4,19fc <free+0x72>
    19ca:	fe843783          	ld	a5,-24(s0)
    19ce:	639c                	ld	a5,0(a5)
    19d0:	fe043703          	ld	a4,-32(s0)
    19d4:	02f76463          	bltu	a4,a5,19fc <free+0x72>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    19d8:	fe843783          	ld	a5,-24(s0)
    19dc:	639c                	ld	a5,0(a5)
    19de:	fef43423          	sd	a5,-24(s0)
    19e2:	fe043703          	ld	a4,-32(s0)
    19e6:	fe843783          	ld	a5,-24(s0)
    19ea:	fce7f3e3          	bgeu	a5,a4,19b0 <free+0x26>
    19ee:	fe843783          	ld	a5,-24(s0)
    19f2:	639c                	ld	a5,0(a5)
    19f4:	fe043703          	ld	a4,-32(s0)
    19f8:	faf77ce3          	bgeu	a4,a5,19b0 <free+0x26>
      break;
  if(bp + bp->s.size == p->s.ptr){
    19fc:	fe043783          	ld	a5,-32(s0)
    1a00:	479c                	lw	a5,8(a5)
    1a02:	1782                	slli	a5,a5,0x20
    1a04:	9381                	srli	a5,a5,0x20
    1a06:	0792                	slli	a5,a5,0x4
    1a08:	fe043703          	ld	a4,-32(s0)
    1a0c:	973e                	add	a4,a4,a5
    1a0e:	fe843783          	ld	a5,-24(s0)
    1a12:	639c                	ld	a5,0(a5)
    1a14:	02f71763          	bne	a4,a5,1a42 <free+0xb8>
    bp->s.size += p->s.ptr->s.size;
    1a18:	fe043783          	ld	a5,-32(s0)
    1a1c:	4798                	lw	a4,8(a5)
    1a1e:	fe843783          	ld	a5,-24(s0)
    1a22:	639c                	ld	a5,0(a5)
    1a24:	479c                	lw	a5,8(a5)
    1a26:	9fb9                	addw	a5,a5,a4
    1a28:	0007871b          	sext.w	a4,a5
    1a2c:	fe043783          	ld	a5,-32(s0)
    1a30:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
    1a32:	fe843783          	ld	a5,-24(s0)
    1a36:	639c                	ld	a5,0(a5)
    1a38:	6398                	ld	a4,0(a5)
    1a3a:	fe043783          	ld	a5,-32(s0)
    1a3e:	e398                	sd	a4,0(a5)
    1a40:	a039                	j	1a4e <free+0xc4>
  } else
    bp->s.ptr = p->s.ptr;
    1a42:	fe843783          	ld	a5,-24(s0)
    1a46:	6398                	ld	a4,0(a5)
    1a48:	fe043783          	ld	a5,-32(s0)
    1a4c:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
    1a4e:	fe843783          	ld	a5,-24(s0)
    1a52:	479c                	lw	a5,8(a5)
    1a54:	1782                	slli	a5,a5,0x20
    1a56:	9381                	srli	a5,a5,0x20
    1a58:	0792                	slli	a5,a5,0x4
    1a5a:	fe843703          	ld	a4,-24(s0)
    1a5e:	97ba                	add	a5,a5,a4
    1a60:	fe043703          	ld	a4,-32(s0)
    1a64:	02f71563          	bne	a4,a5,1a8e <free+0x104>
    p->s.size += bp->s.size;
    1a68:	fe843783          	ld	a5,-24(s0)
    1a6c:	4798                	lw	a4,8(a5)
    1a6e:	fe043783          	ld	a5,-32(s0)
    1a72:	479c                	lw	a5,8(a5)
    1a74:	9fb9                	addw	a5,a5,a4
    1a76:	0007871b          	sext.w	a4,a5
    1a7a:	fe843783          	ld	a5,-24(s0)
    1a7e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1a80:	fe043783          	ld	a5,-32(s0)
    1a84:	6398                	ld	a4,0(a5)
    1a86:	fe843783          	ld	a5,-24(s0)
    1a8a:	e398                	sd	a4,0(a5)
    1a8c:	a031                	j	1a98 <free+0x10e>
  } else
    p->s.ptr = bp;
    1a8e:	fe843783          	ld	a5,-24(s0)
    1a92:	fe043703          	ld	a4,-32(s0)
    1a96:	e398                	sd	a4,0(a5)
  freep = p;
    1a98:	00000797          	auipc	a5,0x0
    1a9c:	61078793          	addi	a5,a5,1552 # 20a8 <freep>
    1aa0:	fe843703          	ld	a4,-24(s0)
    1aa4:	e398                	sd	a4,0(a5)
}
    1aa6:	0001                	nop
    1aa8:	70a2                	ld	ra,40(sp)
    1aaa:	7402                	ld	s0,32(sp)
    1aac:	6145                	addi	sp,sp,48
    1aae:	8082                	ret

0000000000001ab0 <morecore>:

static Header*
morecore(uint nu)
{
    1ab0:	7179                	addi	sp,sp,-48
    1ab2:	f406                	sd	ra,40(sp)
    1ab4:	f022                	sd	s0,32(sp)
    1ab6:	1800                	addi	s0,sp,48
    1ab8:	87aa                	mv	a5,a0
    1aba:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
    1abe:	fdc42783          	lw	a5,-36(s0)
    1ac2:	0007871b          	sext.w	a4,a5
    1ac6:	6785                	lui	a5,0x1
    1ac8:	00f77563          	bgeu	a4,a5,1ad2 <morecore+0x22>
    nu = 4096;
    1acc:	6785                	lui	a5,0x1
    1ace:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
    1ad2:	fdc42783          	lw	a5,-36(s0)
    1ad6:	0047979b          	slliw	a5,a5,0x4
    1ada:	2781                	sext.w	a5,a5
    1adc:	853e                	mv	a0,a5
    1ade:	00000097          	auipc	ra,0x0
    1ae2:	9b8080e7          	jalr	-1608(ra) # 1496 <sbrk>
    1ae6:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
    1aea:	fe843703          	ld	a4,-24(s0)
    1aee:	57fd                	li	a5,-1
    1af0:	00f71463          	bne	a4,a5,1af8 <morecore+0x48>
    return 0;
    1af4:	4781                	li	a5,0
    1af6:	a03d                	j	1b24 <morecore+0x74>
  hp = (Header*)p;
    1af8:	fe843783          	ld	a5,-24(s0)
    1afc:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
    1b00:	fe043783          	ld	a5,-32(s0)
    1b04:	fdc42703          	lw	a4,-36(s0)
    1b08:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
    1b0a:	fe043783          	ld	a5,-32(s0)
    1b0e:	07c1                	addi	a5,a5,16 # 1010 <strcmp+0x64>
    1b10:	853e                	mv	a0,a5
    1b12:	00000097          	auipc	ra,0x0
    1b16:	e78080e7          	jalr	-392(ra) # 198a <free>
  return freep;
    1b1a:	00000797          	auipc	a5,0x0
    1b1e:	58e78793          	addi	a5,a5,1422 # 20a8 <freep>
    1b22:	639c                	ld	a5,0(a5)
}
    1b24:	853e                	mv	a0,a5
    1b26:	70a2                	ld	ra,40(sp)
    1b28:	7402                	ld	s0,32(sp)
    1b2a:	6145                	addi	sp,sp,48
    1b2c:	8082                	ret

0000000000001b2e <malloc>:

void*
malloc(uint nbytes)
{
    1b2e:	7139                	addi	sp,sp,-64
    1b30:	fc06                	sd	ra,56(sp)
    1b32:	f822                	sd	s0,48(sp)
    1b34:	0080                	addi	s0,sp,64
    1b36:	87aa                	mv	a5,a0
    1b38:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1b3c:	fcc46783          	lwu	a5,-52(s0)
    1b40:	07bd                	addi	a5,a5,15
    1b42:	8391                	srli	a5,a5,0x4
    1b44:	2781                	sext.w	a5,a5
    1b46:	2785                	addiw	a5,a5,1
    1b48:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
    1b4c:	00000797          	auipc	a5,0x0
    1b50:	55c78793          	addi	a5,a5,1372 # 20a8 <freep>
    1b54:	639c                	ld	a5,0(a5)
    1b56:	fef43023          	sd	a5,-32(s0)
    1b5a:	fe043783          	ld	a5,-32(s0)
    1b5e:	ef95                	bnez	a5,1b9a <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
    1b60:	00000797          	auipc	a5,0x0
    1b64:	53878793          	addi	a5,a5,1336 # 2098 <base>
    1b68:	fef43023          	sd	a5,-32(s0)
    1b6c:	00000797          	auipc	a5,0x0
    1b70:	53c78793          	addi	a5,a5,1340 # 20a8 <freep>
    1b74:	fe043703          	ld	a4,-32(s0)
    1b78:	e398                	sd	a4,0(a5)
    1b7a:	00000797          	auipc	a5,0x0
    1b7e:	52e78793          	addi	a5,a5,1326 # 20a8 <freep>
    1b82:	6398                	ld	a4,0(a5)
    1b84:	00000797          	auipc	a5,0x0
    1b88:	51478793          	addi	a5,a5,1300 # 2098 <base>
    1b8c:	e398                	sd	a4,0(a5)
    base.s.size = 0;
    1b8e:	00000797          	auipc	a5,0x0
    1b92:	50a78793          	addi	a5,a5,1290 # 2098 <base>
    1b96:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1b9a:	fe043783          	ld	a5,-32(s0)
    1b9e:	639c                	ld	a5,0(a5)
    1ba0:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
    1ba4:	fe843783          	ld	a5,-24(s0)
    1ba8:	479c                	lw	a5,8(a5)
    1baa:	fdc42703          	lw	a4,-36(s0)
    1bae:	2701                	sext.w	a4,a4
    1bb0:	06e7e763          	bltu	a5,a4,1c1e <malloc+0xf0>
      if(p->s.size == nunits)
    1bb4:	fe843783          	ld	a5,-24(s0)
    1bb8:	479c                	lw	a5,8(a5)
    1bba:	fdc42703          	lw	a4,-36(s0)
    1bbe:	2701                	sext.w	a4,a4
    1bc0:	00f71963          	bne	a4,a5,1bd2 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
    1bc4:	fe843783          	ld	a5,-24(s0)
    1bc8:	6398                	ld	a4,0(a5)
    1bca:	fe043783          	ld	a5,-32(s0)
    1bce:	e398                	sd	a4,0(a5)
    1bd0:	a825                	j	1c08 <malloc+0xda>
      else {
        p->s.size -= nunits;
    1bd2:	fe843783          	ld	a5,-24(s0)
    1bd6:	479c                	lw	a5,8(a5)
    1bd8:	fdc42703          	lw	a4,-36(s0)
    1bdc:	9f99                	subw	a5,a5,a4
    1bde:	0007871b          	sext.w	a4,a5
    1be2:	fe843783          	ld	a5,-24(s0)
    1be6:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1be8:	fe843783          	ld	a5,-24(s0)
    1bec:	479c                	lw	a5,8(a5)
    1bee:	1782                	slli	a5,a5,0x20
    1bf0:	9381                	srli	a5,a5,0x20
    1bf2:	0792                	slli	a5,a5,0x4
    1bf4:	fe843703          	ld	a4,-24(s0)
    1bf8:	97ba                	add	a5,a5,a4
    1bfa:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
    1bfe:	fe843783          	ld	a5,-24(s0)
    1c02:	fdc42703          	lw	a4,-36(s0)
    1c06:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
    1c08:	00000797          	auipc	a5,0x0
    1c0c:	4a078793          	addi	a5,a5,1184 # 20a8 <freep>
    1c10:	fe043703          	ld	a4,-32(s0)
    1c14:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
    1c16:	fe843783          	ld	a5,-24(s0)
    1c1a:	07c1                	addi	a5,a5,16
    1c1c:	a091                	j	1c60 <malloc+0x132>
    }
    if(p == freep)
    1c1e:	00000797          	auipc	a5,0x0
    1c22:	48a78793          	addi	a5,a5,1162 # 20a8 <freep>
    1c26:	639c                	ld	a5,0(a5)
    1c28:	fe843703          	ld	a4,-24(s0)
    1c2c:	02f71063          	bne	a4,a5,1c4c <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
    1c30:	fdc42783          	lw	a5,-36(s0)
    1c34:	853e                	mv	a0,a5
    1c36:	00000097          	auipc	ra,0x0
    1c3a:	e7a080e7          	jalr	-390(ra) # 1ab0 <morecore>
    1c3e:	fea43423          	sd	a0,-24(s0)
    1c42:	fe843783          	ld	a5,-24(s0)
    1c46:	e399                	bnez	a5,1c4c <malloc+0x11e>
        return 0;
    1c48:	4781                	li	a5,0
    1c4a:	a819                	j	1c60 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1c4c:	fe843783          	ld	a5,-24(s0)
    1c50:	fef43023          	sd	a5,-32(s0)
    1c54:	fe843783          	ld	a5,-24(s0)
    1c58:	639c                	ld	a5,0(a5)
    1c5a:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
    1c5e:	b799                	j	1ba4 <malloc+0x76>
  }
}
    1c60:	853e                	mv	a0,a5
    1c62:	70e2                	ld	ra,56(sp)
    1c64:	7442                	ld	s0,48(sp)
    1c66:	6121                	addi	sp,sp,64
    1c68:	8082                	ret
