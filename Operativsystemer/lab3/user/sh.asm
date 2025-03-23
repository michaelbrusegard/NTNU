
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
    }
    exit(0);
}

int getcmd(char *buf, int nbuf)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
    write(2, "$ ", 2);
      10:	4609                	li	a2,2
      12:	00001597          	auipc	a1,0x1
      16:	42e58593          	addi	a1,a1,1070 # 1440 <malloc+0x108>
      1a:	8532                	mv	a0,a2
      1c:	00001097          	auipc	ra,0x1
      20:	f02080e7          	jalr	-254(ra) # f1e <write>
    memset(buf, 0, nbuf);
      24:	864a                	mv	a2,s2
      26:	4581                	li	a1,0
      28:	8526                	mv	a0,s1
      2a:	00001097          	auipc	ra,0x1
      2e:	cb2080e7          	jalr	-846(ra) # cdc <memset>
    gets(buf, nbuf);
      32:	85ca                	mv	a1,s2
      34:	8526                	mv	a0,s1
      36:	00001097          	auipc	ra,0x1
      3a:	cf4080e7          	jalr	-780(ra) # d2a <gets>
    if (buf[0] == 0) // EOF
      3e:	0004c503          	lbu	a0,0(s1)
      42:	00153513          	seqz	a0,a0
        return -1;
    return 0;
}
      46:	40a0053b          	negw	a0,a0
      4a:	60e2                	ld	ra,24(sp)
      4c:	6442                	ld	s0,16(sp)
      4e:	64a2                	ld	s1,8(sp)
      50:	6902                	ld	s2,0(sp)
      52:	6105                	addi	sp,sp,32
      54:	8082                	ret

0000000000000056 <panic>:
    }
    exit(0);
}

void panic(char *s)
{
      56:	1141                	addi	sp,sp,-16
      58:	e406                	sd	ra,8(sp)
      5a:	e022                	sd	s0,0(sp)
      5c:	0800                	addi	s0,sp,16
      5e:	862a                	mv	a2,a0
    fprintf(2, "%s\n", s);
      60:	00001597          	auipc	a1,0x1
      64:	3f058593          	addi	a1,a1,1008 # 1450 <malloc+0x118>
      68:	4509                	li	a0,2
      6a:	00001097          	auipc	ra,0x1
      6e:	1e4080e7          	jalr	484(ra) # 124e <fprintf>
    exit(1);
      72:	4505                	li	a0,1
      74:	00001097          	auipc	ra,0x1
      78:	e8a080e7          	jalr	-374(ra) # efe <exit>

000000000000007c <fork1>:
}

int fork1(void)
{
      7c:	1141                	addi	sp,sp,-16
      7e:	e406                	sd	ra,8(sp)
      80:	e022                	sd	s0,0(sp)
      82:	0800                	addi	s0,sp,16
    int pid;

    pid = fork();
      84:	00001097          	auipc	ra,0x1
      88:	e72080e7          	jalr	-398(ra) # ef6 <fork>
    if (pid == -1)
      8c:	57fd                	li	a5,-1
      8e:	00f50663          	beq	a0,a5,9a <fork1+0x1e>
        panic("fork");
    return pid;
}
      92:	60a2                	ld	ra,8(sp)
      94:	6402                	ld	s0,0(sp)
      96:	0141                	addi	sp,sp,16
      98:	8082                	ret
        panic("fork");
      9a:	00001517          	auipc	a0,0x1
      9e:	3be50513          	addi	a0,a0,958 # 1458 <malloc+0x120>
      a2:	00000097          	auipc	ra,0x0
      a6:	fb4080e7          	jalr	-76(ra) # 56 <panic>

00000000000000aa <runcmd>:
{
      aa:	7179                	addi	sp,sp,-48
      ac:	f406                	sd	ra,40(sp)
      ae:	f022                	sd	s0,32(sp)
      b0:	1800                	addi	s0,sp,48
    if (cmd == 0)
      b2:	c115                	beqz	a0,d6 <runcmd+0x2c>
      b4:	ec26                	sd	s1,24(sp)
      b6:	84aa                	mv	s1,a0
    switch (cmd->type)
      b8:	4118                	lw	a4,0(a0)
      ba:	4795                	li	a5,5
      bc:	02e7e363          	bltu	a5,a4,e2 <runcmd+0x38>
      c0:	00056783          	lwu	a5,0(a0)
      c4:	078a                	slli	a5,a5,0x2
      c6:	00001717          	auipc	a4,0x1
      ca:	4aa70713          	addi	a4,a4,1194 # 1570 <malloc+0x238>
      ce:	97ba                	add	a5,a5,a4
      d0:	439c                	lw	a5,0(a5)
      d2:	97ba                	add	a5,a5,a4
      d4:	8782                	jr	a5
      d6:	ec26                	sd	s1,24(sp)
        exit(1);
      d8:	4505                	li	a0,1
      da:	00001097          	auipc	ra,0x1
      de:	e24080e7          	jalr	-476(ra) # efe <exit>
        panic("runcmd");
      e2:	00001517          	auipc	a0,0x1
      e6:	37e50513          	addi	a0,a0,894 # 1460 <malloc+0x128>
      ea:	00000097          	auipc	ra,0x0
      ee:	f6c080e7          	jalr	-148(ra) # 56 <panic>
        if (ecmd->argv[0] == 0)
      f2:	6508                	ld	a0,8(a0)
      f4:	c515                	beqz	a0,120 <runcmd+0x76>
        exec(ecmd->argv[0], ecmd->argv);
      f6:	00848593          	addi	a1,s1,8
      fa:	00001097          	auipc	ra,0x1
      fe:	e3c080e7          	jalr	-452(ra) # f36 <exec>
        fprintf(2, "exec %s failed\n", ecmd->argv[0]);
     102:	6490                	ld	a2,8(s1)
     104:	00001597          	auipc	a1,0x1
     108:	36458593          	addi	a1,a1,868 # 1468 <malloc+0x130>
     10c:	4509                	li	a0,2
     10e:	00001097          	auipc	ra,0x1
     112:	140080e7          	jalr	320(ra) # 124e <fprintf>
    exit(0);
     116:	4501                	li	a0,0
     118:	00001097          	auipc	ra,0x1
     11c:	de6080e7          	jalr	-538(ra) # efe <exit>
            exit(1);
     120:	4505                	li	a0,1
     122:	00001097          	auipc	ra,0x1
     126:	ddc080e7          	jalr	-548(ra) # efe <exit>
        close(rcmd->fd);
     12a:	5148                	lw	a0,36(a0)
     12c:	00001097          	auipc	ra,0x1
     130:	dfa080e7          	jalr	-518(ra) # f26 <close>
        if (open(rcmd->file, rcmd->mode) < 0)
     134:	508c                	lw	a1,32(s1)
     136:	6888                	ld	a0,16(s1)
     138:	00001097          	auipc	ra,0x1
     13c:	e06080e7          	jalr	-506(ra) # f3e <open>
     140:	00054763          	bltz	a0,14e <runcmd+0xa4>
        runcmd(rcmd->cmd);
     144:	6488                	ld	a0,8(s1)
     146:	00000097          	auipc	ra,0x0
     14a:	f64080e7          	jalr	-156(ra) # aa <runcmd>
            fprintf(2, "open %s failed\n", rcmd->file);
     14e:	6890                	ld	a2,16(s1)
     150:	00001597          	auipc	a1,0x1
     154:	32858593          	addi	a1,a1,808 # 1478 <malloc+0x140>
     158:	4509                	li	a0,2
     15a:	00001097          	auipc	ra,0x1
     15e:	0f4080e7          	jalr	244(ra) # 124e <fprintf>
            exit(1);
     162:	4505                	li	a0,1
     164:	00001097          	auipc	ra,0x1
     168:	d9a080e7          	jalr	-614(ra) # efe <exit>
        if (fork1() == 0)
     16c:	00000097          	auipc	ra,0x0
     170:	f10080e7          	jalr	-240(ra) # 7c <fork1>
     174:	e511                	bnez	a0,180 <runcmd+0xd6>
            runcmd(lcmd->left);
     176:	6488                	ld	a0,8(s1)
     178:	00000097          	auipc	ra,0x0
     17c:	f32080e7          	jalr	-206(ra) # aa <runcmd>
        wait(0);
     180:	4501                	li	a0,0
     182:	00001097          	auipc	ra,0x1
     186:	d84080e7          	jalr	-636(ra) # f06 <wait>
        runcmd(lcmd->right);
     18a:	6888                	ld	a0,16(s1)
     18c:	00000097          	auipc	ra,0x0
     190:	f1e080e7          	jalr	-226(ra) # aa <runcmd>
        if (pipe(p) < 0)
     194:	fd840513          	addi	a0,s0,-40
     198:	00001097          	auipc	ra,0x1
     19c:	d76080e7          	jalr	-650(ra) # f0e <pipe>
     1a0:	04054363          	bltz	a0,1e6 <runcmd+0x13c>
        if (fork1() == 0)
     1a4:	00000097          	auipc	ra,0x0
     1a8:	ed8080e7          	jalr	-296(ra) # 7c <fork1>
     1ac:	e529                	bnez	a0,1f6 <runcmd+0x14c>
            close(1);
     1ae:	4505                	li	a0,1
     1b0:	00001097          	auipc	ra,0x1
     1b4:	d76080e7          	jalr	-650(ra) # f26 <close>
            dup(p[1]);
     1b8:	fdc42503          	lw	a0,-36(s0)
     1bc:	00001097          	auipc	ra,0x1
     1c0:	dba080e7          	jalr	-582(ra) # f76 <dup>
            close(p[0]);
     1c4:	fd842503          	lw	a0,-40(s0)
     1c8:	00001097          	auipc	ra,0x1
     1cc:	d5e080e7          	jalr	-674(ra) # f26 <close>
            close(p[1]);
     1d0:	fdc42503          	lw	a0,-36(s0)
     1d4:	00001097          	auipc	ra,0x1
     1d8:	d52080e7          	jalr	-686(ra) # f26 <close>
            runcmd(pcmd->left);
     1dc:	6488                	ld	a0,8(s1)
     1de:	00000097          	auipc	ra,0x0
     1e2:	ecc080e7          	jalr	-308(ra) # aa <runcmd>
            panic("pipe");
     1e6:	00001517          	auipc	a0,0x1
     1ea:	2a250513          	addi	a0,a0,674 # 1488 <malloc+0x150>
     1ee:	00000097          	auipc	ra,0x0
     1f2:	e68080e7          	jalr	-408(ra) # 56 <panic>
        if (fork1() == 0)
     1f6:	00000097          	auipc	ra,0x0
     1fa:	e86080e7          	jalr	-378(ra) # 7c <fork1>
     1fe:	ed05                	bnez	a0,236 <runcmd+0x18c>
            close(0);
     200:	00001097          	auipc	ra,0x1
     204:	d26080e7          	jalr	-730(ra) # f26 <close>
            dup(p[0]);
     208:	fd842503          	lw	a0,-40(s0)
     20c:	00001097          	auipc	ra,0x1
     210:	d6a080e7          	jalr	-662(ra) # f76 <dup>
            close(p[0]);
     214:	fd842503          	lw	a0,-40(s0)
     218:	00001097          	auipc	ra,0x1
     21c:	d0e080e7          	jalr	-754(ra) # f26 <close>
            close(p[1]);
     220:	fdc42503          	lw	a0,-36(s0)
     224:	00001097          	auipc	ra,0x1
     228:	d02080e7          	jalr	-766(ra) # f26 <close>
            runcmd(pcmd->right);
     22c:	6888                	ld	a0,16(s1)
     22e:	00000097          	auipc	ra,0x0
     232:	e7c080e7          	jalr	-388(ra) # aa <runcmd>
        close(p[0]);
     236:	fd842503          	lw	a0,-40(s0)
     23a:	00001097          	auipc	ra,0x1
     23e:	cec080e7          	jalr	-788(ra) # f26 <close>
        close(p[1]);
     242:	fdc42503          	lw	a0,-36(s0)
     246:	00001097          	auipc	ra,0x1
     24a:	ce0080e7          	jalr	-800(ra) # f26 <close>
        wait(0);
     24e:	4501                	li	a0,0
     250:	00001097          	auipc	ra,0x1
     254:	cb6080e7          	jalr	-842(ra) # f06 <wait>
        wait(0);
     258:	4501                	li	a0,0
     25a:	00001097          	auipc	ra,0x1
     25e:	cac080e7          	jalr	-852(ra) # f06 <wait>
        break;
     262:	bd55                	j	116 <runcmd+0x6c>
        if (fork1() == 0)
     264:	00000097          	auipc	ra,0x0
     268:	e18080e7          	jalr	-488(ra) # 7c <fork1>
     26c:	ea0515e3          	bnez	a0,116 <runcmd+0x6c>
            runcmd(bcmd->cmd);
     270:	6488                	ld	a0,8(s1)
     272:	00000097          	auipc	ra,0x0
     276:	e38080e7          	jalr	-456(ra) # aa <runcmd>

000000000000027a <execcmd>:
// PAGEBREAK!
//  Constructors

struct cmd *
execcmd(void)
{
     27a:	1101                	addi	sp,sp,-32
     27c:	ec06                	sd	ra,24(sp)
     27e:	e822                	sd	s0,16(sp)
     280:	e426                	sd	s1,8(sp)
     282:	1000                	addi	s0,sp,32
    struct execcmd *cmd;

    cmd = malloc(sizeof(*cmd));
     284:	0a800513          	li	a0,168
     288:	00001097          	auipc	ra,0x1
     28c:	0b0080e7          	jalr	176(ra) # 1338 <malloc>
     290:	84aa                	mv	s1,a0
    memset(cmd, 0, sizeof(*cmd));
     292:	0a800613          	li	a2,168
     296:	4581                	li	a1,0
     298:	00001097          	auipc	ra,0x1
     29c:	a44080e7          	jalr	-1468(ra) # cdc <memset>
    cmd->type = EXEC;
     2a0:	4785                	li	a5,1
     2a2:	c09c                	sw	a5,0(s1)
    return (struct cmd *)cmd;
}
     2a4:	8526                	mv	a0,s1
     2a6:	60e2                	ld	ra,24(sp)
     2a8:	6442                	ld	s0,16(sp)
     2aa:	64a2                	ld	s1,8(sp)
     2ac:	6105                	addi	sp,sp,32
     2ae:	8082                	ret

00000000000002b0 <redircmd>:

struct cmd *
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     2b0:	7139                	addi	sp,sp,-64
     2b2:	fc06                	sd	ra,56(sp)
     2b4:	f822                	sd	s0,48(sp)
     2b6:	f426                	sd	s1,40(sp)
     2b8:	f04a                	sd	s2,32(sp)
     2ba:	ec4e                	sd	s3,24(sp)
     2bc:	e852                	sd	s4,16(sp)
     2be:	e456                	sd	s5,8(sp)
     2c0:	e05a                	sd	s6,0(sp)
     2c2:	0080                	addi	s0,sp,64
     2c4:	8b2a                	mv	s6,a0
     2c6:	8aae                	mv	s5,a1
     2c8:	8a32                	mv	s4,a2
     2ca:	89b6                	mv	s3,a3
     2cc:	893a                	mv	s2,a4
    struct redircmd *cmd;

    cmd = malloc(sizeof(*cmd));
     2ce:	02800513          	li	a0,40
     2d2:	00001097          	auipc	ra,0x1
     2d6:	066080e7          	jalr	102(ra) # 1338 <malloc>
     2da:	84aa                	mv	s1,a0
    memset(cmd, 0, sizeof(*cmd));
     2dc:	02800613          	li	a2,40
     2e0:	4581                	li	a1,0
     2e2:	00001097          	auipc	ra,0x1
     2e6:	9fa080e7          	jalr	-1542(ra) # cdc <memset>
    cmd->type = REDIR;
     2ea:	4789                	li	a5,2
     2ec:	c09c                	sw	a5,0(s1)
    cmd->cmd = subcmd;
     2ee:	0164b423          	sd	s6,8(s1)
    cmd->file = file;
     2f2:	0154b823          	sd	s5,16(s1)
    cmd->efile = efile;
     2f6:	0144bc23          	sd	s4,24(s1)
    cmd->mode = mode;
     2fa:	0334a023          	sw	s3,32(s1)
    cmd->fd = fd;
     2fe:	0324a223          	sw	s2,36(s1)
    return (struct cmd *)cmd;
}
     302:	8526                	mv	a0,s1
     304:	70e2                	ld	ra,56(sp)
     306:	7442                	ld	s0,48(sp)
     308:	74a2                	ld	s1,40(sp)
     30a:	7902                	ld	s2,32(sp)
     30c:	69e2                	ld	s3,24(sp)
     30e:	6a42                	ld	s4,16(sp)
     310:	6aa2                	ld	s5,8(sp)
     312:	6b02                	ld	s6,0(sp)
     314:	6121                	addi	sp,sp,64
     316:	8082                	ret

0000000000000318 <pipecmd>:

struct cmd *
pipecmd(struct cmd *left, struct cmd *right)
{
     318:	7179                	addi	sp,sp,-48
     31a:	f406                	sd	ra,40(sp)
     31c:	f022                	sd	s0,32(sp)
     31e:	ec26                	sd	s1,24(sp)
     320:	e84a                	sd	s2,16(sp)
     322:	e44e                	sd	s3,8(sp)
     324:	1800                	addi	s0,sp,48
     326:	89aa                	mv	s3,a0
     328:	892e                	mv	s2,a1
    struct pipecmd *cmd;

    cmd = malloc(sizeof(*cmd));
     32a:	4561                	li	a0,24
     32c:	00001097          	auipc	ra,0x1
     330:	00c080e7          	jalr	12(ra) # 1338 <malloc>
     334:	84aa                	mv	s1,a0
    memset(cmd, 0, sizeof(*cmd));
     336:	4661                	li	a2,24
     338:	4581                	li	a1,0
     33a:	00001097          	auipc	ra,0x1
     33e:	9a2080e7          	jalr	-1630(ra) # cdc <memset>
    cmd->type = PIPE;
     342:	478d                	li	a5,3
     344:	c09c                	sw	a5,0(s1)
    cmd->left = left;
     346:	0134b423          	sd	s3,8(s1)
    cmd->right = right;
     34a:	0124b823          	sd	s2,16(s1)
    return (struct cmd *)cmd;
}
     34e:	8526                	mv	a0,s1
     350:	70a2                	ld	ra,40(sp)
     352:	7402                	ld	s0,32(sp)
     354:	64e2                	ld	s1,24(sp)
     356:	6942                	ld	s2,16(sp)
     358:	69a2                	ld	s3,8(sp)
     35a:	6145                	addi	sp,sp,48
     35c:	8082                	ret

000000000000035e <listcmd>:

struct cmd *
listcmd(struct cmd *left, struct cmd *right)
{
     35e:	7179                	addi	sp,sp,-48
     360:	f406                	sd	ra,40(sp)
     362:	f022                	sd	s0,32(sp)
     364:	ec26                	sd	s1,24(sp)
     366:	e84a                	sd	s2,16(sp)
     368:	e44e                	sd	s3,8(sp)
     36a:	1800                	addi	s0,sp,48
     36c:	89aa                	mv	s3,a0
     36e:	892e                	mv	s2,a1
    struct listcmd *cmd;

    cmd = malloc(sizeof(*cmd));
     370:	4561                	li	a0,24
     372:	00001097          	auipc	ra,0x1
     376:	fc6080e7          	jalr	-58(ra) # 1338 <malloc>
     37a:	84aa                	mv	s1,a0
    memset(cmd, 0, sizeof(*cmd));
     37c:	4661                	li	a2,24
     37e:	4581                	li	a1,0
     380:	00001097          	auipc	ra,0x1
     384:	95c080e7          	jalr	-1700(ra) # cdc <memset>
    cmd->type = LIST;
     388:	4791                	li	a5,4
     38a:	c09c                	sw	a5,0(s1)
    cmd->left = left;
     38c:	0134b423          	sd	s3,8(s1)
    cmd->right = right;
     390:	0124b823          	sd	s2,16(s1)
    return (struct cmd *)cmd;
}
     394:	8526                	mv	a0,s1
     396:	70a2                	ld	ra,40(sp)
     398:	7402                	ld	s0,32(sp)
     39a:	64e2                	ld	s1,24(sp)
     39c:	6942                	ld	s2,16(sp)
     39e:	69a2                	ld	s3,8(sp)
     3a0:	6145                	addi	sp,sp,48
     3a2:	8082                	ret

00000000000003a4 <backcmd>:

struct cmd *
backcmd(struct cmd *subcmd)
{
     3a4:	1101                	addi	sp,sp,-32
     3a6:	ec06                	sd	ra,24(sp)
     3a8:	e822                	sd	s0,16(sp)
     3aa:	e426                	sd	s1,8(sp)
     3ac:	e04a                	sd	s2,0(sp)
     3ae:	1000                	addi	s0,sp,32
     3b0:	892a                	mv	s2,a0
    struct backcmd *cmd;

    cmd = malloc(sizeof(*cmd));
     3b2:	4541                	li	a0,16
     3b4:	00001097          	auipc	ra,0x1
     3b8:	f84080e7          	jalr	-124(ra) # 1338 <malloc>
     3bc:	84aa                	mv	s1,a0
    memset(cmd, 0, sizeof(*cmd));
     3be:	4641                	li	a2,16
     3c0:	4581                	li	a1,0
     3c2:	00001097          	auipc	ra,0x1
     3c6:	91a080e7          	jalr	-1766(ra) # cdc <memset>
    cmd->type = BACK;
     3ca:	4795                	li	a5,5
     3cc:	c09c                	sw	a5,0(s1)
    cmd->cmd = subcmd;
     3ce:	0124b423          	sd	s2,8(s1)
    return (struct cmd *)cmd;
}
     3d2:	8526                	mv	a0,s1
     3d4:	60e2                	ld	ra,24(sp)
     3d6:	6442                	ld	s0,16(sp)
     3d8:	64a2                	ld	s1,8(sp)
     3da:	6902                	ld	s2,0(sp)
     3dc:	6105                	addi	sp,sp,32
     3de:	8082                	ret

00000000000003e0 <gettoken>:

char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int gettoken(char **ps, char *es, char **q, char **eq)
{
     3e0:	7139                	addi	sp,sp,-64
     3e2:	fc06                	sd	ra,56(sp)
     3e4:	f822                	sd	s0,48(sp)
     3e6:	f426                	sd	s1,40(sp)
     3e8:	f04a                	sd	s2,32(sp)
     3ea:	ec4e                	sd	s3,24(sp)
     3ec:	e852                	sd	s4,16(sp)
     3ee:	e456                	sd	s5,8(sp)
     3f0:	e05a                	sd	s6,0(sp)
     3f2:	0080                	addi	s0,sp,64
     3f4:	8a2a                	mv	s4,a0
     3f6:	892e                	mv	s2,a1
     3f8:	8ab2                	mv	s5,a2
     3fa:	8b36                	mv	s6,a3
    char *s;
    int ret;

    s = *ps;
     3fc:	6104                	ld	s1,0(a0)
    while (s < es && strchr(whitespace, *s))
     3fe:	00002997          	auipc	s3,0x2
     402:	c0a98993          	addi	s3,s3,-1014 # 2008 <whitespace>
     406:	00b4fe63          	bgeu	s1,a1,422 <gettoken+0x42>
     40a:	0004c583          	lbu	a1,0(s1)
     40e:	854e                	mv	a0,s3
     410:	00001097          	auipc	ra,0x1
     414:	8f2080e7          	jalr	-1806(ra) # d02 <strchr>
     418:	c509                	beqz	a0,422 <gettoken+0x42>
        s++;
     41a:	0485                	addi	s1,s1,1
    while (s < es && strchr(whitespace, *s))
     41c:	fe9917e3          	bne	s2,s1,40a <gettoken+0x2a>
     420:	84ca                	mv	s1,s2
    if (q)
     422:	000a8463          	beqz	s5,42a <gettoken+0x4a>
        *q = s;
     426:	009ab023          	sd	s1,0(s5)
    ret = *s;
     42a:	0004c783          	lbu	a5,0(s1)
     42e:	00078a9b          	sext.w	s5,a5
    switch (*s)
     432:	03c00713          	li	a4,60
     436:	06f76663          	bltu	a4,a5,4a2 <gettoken+0xc2>
     43a:	03a00713          	li	a4,58
     43e:	00f76e63          	bltu	a4,a5,45a <gettoken+0x7a>
     442:	cf89                	beqz	a5,45c <gettoken+0x7c>
     444:	02600713          	li	a4,38
     448:	00e78963          	beq	a5,a4,45a <gettoken+0x7a>
     44c:	fd87879b          	addiw	a5,a5,-40
     450:	0ff7f793          	zext.b	a5,a5
     454:	4705                	li	a4,1
     456:	06f76d63          	bltu	a4,a5,4d0 <gettoken+0xf0>
    case '(':
    case ')':
    case ';':
    case '&':
    case '<':
        s++;
     45a:	0485                	addi	s1,s1,1
        ret = 'a';
        while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
            s++;
        break;
    }
    if (eq)
     45c:	000b0463          	beqz	s6,464 <gettoken+0x84>
        *eq = s;
     460:	009b3023          	sd	s1,0(s6)

    while (s < es && strchr(whitespace, *s))
     464:	00002997          	auipc	s3,0x2
     468:	ba498993          	addi	s3,s3,-1116 # 2008 <whitespace>
     46c:	0124fe63          	bgeu	s1,s2,488 <gettoken+0xa8>
     470:	0004c583          	lbu	a1,0(s1)
     474:	854e                	mv	a0,s3
     476:	00001097          	auipc	ra,0x1
     47a:	88c080e7          	jalr	-1908(ra) # d02 <strchr>
     47e:	c509                	beqz	a0,488 <gettoken+0xa8>
        s++;
     480:	0485                	addi	s1,s1,1
    while (s < es && strchr(whitespace, *s))
     482:	fe9917e3          	bne	s2,s1,470 <gettoken+0x90>
     486:	84ca                	mv	s1,s2
    *ps = s;
     488:	009a3023          	sd	s1,0(s4)
    return ret;
}
     48c:	8556                	mv	a0,s5
     48e:	70e2                	ld	ra,56(sp)
     490:	7442                	ld	s0,48(sp)
     492:	74a2                	ld	s1,40(sp)
     494:	7902                	ld	s2,32(sp)
     496:	69e2                	ld	s3,24(sp)
     498:	6a42                	ld	s4,16(sp)
     49a:	6aa2                	ld	s5,8(sp)
     49c:	6b02                	ld	s6,0(sp)
     49e:	6121                	addi	sp,sp,64
     4a0:	8082                	ret
    switch (*s)
     4a2:	03e00713          	li	a4,62
     4a6:	02e79163          	bne	a5,a4,4c8 <gettoken+0xe8>
        s++;
     4aa:	00148693          	addi	a3,s1,1
        if (*s == '>')
     4ae:	0014c703          	lbu	a4,1(s1)
     4b2:	03e00793          	li	a5,62
            s++;
     4b6:	0489                	addi	s1,s1,2
            ret = '+';
     4b8:	02b00a93          	li	s5,43
        if (*s == '>')
     4bc:	faf700e3          	beq	a4,a5,45c <gettoken+0x7c>
        s++;
     4c0:	84b6                	mv	s1,a3
    ret = *s;
     4c2:	03e00a93          	li	s5,62
     4c6:	bf59                	j	45c <gettoken+0x7c>
    switch (*s)
     4c8:	07c00713          	li	a4,124
     4cc:	f8e787e3          	beq	a5,a4,45a <gettoken+0x7a>
        while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     4d0:	00002997          	auipc	s3,0x2
     4d4:	b3898993          	addi	s3,s3,-1224 # 2008 <whitespace>
     4d8:	00002a97          	auipc	s5,0x2
     4dc:	b28a8a93          	addi	s5,s5,-1240 # 2000 <symbols>
     4e0:	0524f163          	bgeu	s1,s2,522 <gettoken+0x142>
     4e4:	0004c583          	lbu	a1,0(s1)
     4e8:	854e                	mv	a0,s3
     4ea:	00001097          	auipc	ra,0x1
     4ee:	818080e7          	jalr	-2024(ra) # d02 <strchr>
     4f2:	e50d                	bnez	a0,51c <gettoken+0x13c>
     4f4:	0004c583          	lbu	a1,0(s1)
     4f8:	8556                	mv	a0,s5
     4fa:	00001097          	auipc	ra,0x1
     4fe:	808080e7          	jalr	-2040(ra) # d02 <strchr>
     502:	e911                	bnez	a0,516 <gettoken+0x136>
            s++;
     504:	0485                	addi	s1,s1,1
        while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     506:	fc991fe3          	bne	s2,s1,4e4 <gettoken+0x104>
    if (eq)
     50a:	84ca                	mv	s1,s2
        ret = 'a';
     50c:	06100a93          	li	s5,97
    if (eq)
     510:	f40b18e3          	bnez	s6,460 <gettoken+0x80>
     514:	bf95                	j	488 <gettoken+0xa8>
        ret = 'a';
     516:	06100a93          	li	s5,97
     51a:	b789                	j	45c <gettoken+0x7c>
     51c:	06100a93          	li	s5,97
     520:	bf35                	j	45c <gettoken+0x7c>
     522:	06100a93          	li	s5,97
    if (eq)
     526:	f20b1de3          	bnez	s6,460 <gettoken+0x80>
     52a:	bfb9                	j	488 <gettoken+0xa8>

000000000000052c <peek>:

int peek(char **ps, char *es, char *toks)
{
     52c:	7139                	addi	sp,sp,-64
     52e:	fc06                	sd	ra,56(sp)
     530:	f822                	sd	s0,48(sp)
     532:	f426                	sd	s1,40(sp)
     534:	f04a                	sd	s2,32(sp)
     536:	ec4e                	sd	s3,24(sp)
     538:	e852                	sd	s4,16(sp)
     53a:	e456                	sd	s5,8(sp)
     53c:	0080                	addi	s0,sp,64
     53e:	8a2a                	mv	s4,a0
     540:	892e                	mv	s2,a1
     542:	8ab2                	mv	s5,a2
    char *s;

    s = *ps;
     544:	6104                	ld	s1,0(a0)
    while (s < es && strchr(whitespace, *s))
     546:	00002997          	auipc	s3,0x2
     54a:	ac298993          	addi	s3,s3,-1342 # 2008 <whitespace>
     54e:	00b4fe63          	bgeu	s1,a1,56a <peek+0x3e>
     552:	0004c583          	lbu	a1,0(s1)
     556:	854e                	mv	a0,s3
     558:	00000097          	auipc	ra,0x0
     55c:	7aa080e7          	jalr	1962(ra) # d02 <strchr>
     560:	c509                	beqz	a0,56a <peek+0x3e>
        s++;
     562:	0485                	addi	s1,s1,1
    while (s < es && strchr(whitespace, *s))
     564:	fe9917e3          	bne	s2,s1,552 <peek+0x26>
     568:	84ca                	mv	s1,s2
    *ps = s;
     56a:	009a3023          	sd	s1,0(s4)
    return *s && strchr(toks, *s);
     56e:	0004c583          	lbu	a1,0(s1)
     572:	4501                	li	a0,0
     574:	e991                	bnez	a1,588 <peek+0x5c>
}
     576:	70e2                	ld	ra,56(sp)
     578:	7442                	ld	s0,48(sp)
     57a:	74a2                	ld	s1,40(sp)
     57c:	7902                	ld	s2,32(sp)
     57e:	69e2                	ld	s3,24(sp)
     580:	6a42                	ld	s4,16(sp)
     582:	6aa2                	ld	s5,8(sp)
     584:	6121                	addi	sp,sp,64
     586:	8082                	ret
    return *s && strchr(toks, *s);
     588:	8556                	mv	a0,s5
     58a:	00000097          	auipc	ra,0x0
     58e:	778080e7          	jalr	1912(ra) # d02 <strchr>
     592:	00a03533          	snez	a0,a0
     596:	b7c5                	j	576 <peek+0x4a>

0000000000000598 <parseredirs>:
    return cmd;
}

struct cmd *
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     598:	7159                	addi	sp,sp,-112
     59a:	f486                	sd	ra,104(sp)
     59c:	f0a2                	sd	s0,96(sp)
     59e:	eca6                	sd	s1,88(sp)
     5a0:	e8ca                	sd	s2,80(sp)
     5a2:	e4ce                	sd	s3,72(sp)
     5a4:	e0d2                	sd	s4,64(sp)
     5a6:	fc56                	sd	s5,56(sp)
     5a8:	f85a                	sd	s6,48(sp)
     5aa:	f45e                	sd	s7,40(sp)
     5ac:	f062                	sd	s8,32(sp)
     5ae:	ec66                	sd	s9,24(sp)
     5b0:	1880                	addi	s0,sp,112
     5b2:	8a2a                	mv	s4,a0
     5b4:	89ae                	mv	s3,a1
     5b6:	8932                	mv	s2,a2
    int tok;
    char *q, *eq;

    while (peek(ps, es, "<>"))
     5b8:	00001b17          	auipc	s6,0x1
     5bc:	ef8b0b13          	addi	s6,s6,-264 # 14b0 <malloc+0x178>
    {
        tok = gettoken(ps, es, 0, 0);
        if (gettoken(ps, es, &q, &eq) != 'a')
     5c0:	f9040c93          	addi	s9,s0,-112
     5c4:	f9840c13          	addi	s8,s0,-104
     5c8:	06100b93          	li	s7,97
    while (peek(ps, es, "<>"))
     5cc:	a02d                	j	5f6 <parseredirs+0x5e>
            panic("missing file for redirection");
     5ce:	00001517          	auipc	a0,0x1
     5d2:	ec250513          	addi	a0,a0,-318 # 1490 <malloc+0x158>
     5d6:	00000097          	auipc	ra,0x0
     5da:	a80080e7          	jalr	-1408(ra) # 56 <panic>
        switch (tok)
        {
        case '<':
            cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     5de:	4701                	li	a4,0
     5e0:	4681                	li	a3,0
     5e2:	f9043603          	ld	a2,-112(s0)
     5e6:	f9843583          	ld	a1,-104(s0)
     5ea:	8552                	mv	a0,s4
     5ec:	00000097          	auipc	ra,0x0
     5f0:	cc4080e7          	jalr	-828(ra) # 2b0 <redircmd>
     5f4:	8a2a                	mv	s4,a0
        switch (tok)
     5f6:	03c00a93          	li	s5,60
    while (peek(ps, es, "<>"))
     5fa:	865a                	mv	a2,s6
     5fc:	85ca                	mv	a1,s2
     5fe:	854e                	mv	a0,s3
     600:	00000097          	auipc	ra,0x0
     604:	f2c080e7          	jalr	-212(ra) # 52c <peek>
     608:	c935                	beqz	a0,67c <parseredirs+0xe4>
        tok = gettoken(ps, es, 0, 0);
     60a:	4681                	li	a3,0
     60c:	4601                	li	a2,0
     60e:	85ca                	mv	a1,s2
     610:	854e                	mv	a0,s3
     612:	00000097          	auipc	ra,0x0
     616:	dce080e7          	jalr	-562(ra) # 3e0 <gettoken>
     61a:	84aa                	mv	s1,a0
        if (gettoken(ps, es, &q, &eq) != 'a')
     61c:	86e6                	mv	a3,s9
     61e:	8662                	mv	a2,s8
     620:	85ca                	mv	a1,s2
     622:	854e                	mv	a0,s3
     624:	00000097          	auipc	ra,0x0
     628:	dbc080e7          	jalr	-580(ra) # 3e0 <gettoken>
     62c:	fb7511e3          	bne	a0,s7,5ce <parseredirs+0x36>
        switch (tok)
     630:	fb5487e3          	beq	s1,s5,5de <parseredirs+0x46>
     634:	03e00793          	li	a5,62
     638:	02f48463          	beq	s1,a5,660 <parseredirs+0xc8>
     63c:	02b00793          	li	a5,43
     640:	faf49de3          	bne	s1,a5,5fa <parseredirs+0x62>
            break;
        case '>':
            cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE | O_TRUNC, 1);
            break;
        case '+': // >>
            cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE, 1);
     644:	4705                	li	a4,1
     646:	20100693          	li	a3,513
     64a:	f9043603          	ld	a2,-112(s0)
     64e:	f9843583          	ld	a1,-104(s0)
     652:	8552                	mv	a0,s4
     654:	00000097          	auipc	ra,0x0
     658:	c5c080e7          	jalr	-932(ra) # 2b0 <redircmd>
     65c:	8a2a                	mv	s4,a0
            break;
     65e:	bf61                	j	5f6 <parseredirs+0x5e>
            cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE | O_TRUNC, 1);
     660:	4705                	li	a4,1
     662:	60100693          	li	a3,1537
     666:	f9043603          	ld	a2,-112(s0)
     66a:	f9843583          	ld	a1,-104(s0)
     66e:	8552                	mv	a0,s4
     670:	00000097          	auipc	ra,0x0
     674:	c40080e7          	jalr	-960(ra) # 2b0 <redircmd>
     678:	8a2a                	mv	s4,a0
            break;
     67a:	bfb5                	j	5f6 <parseredirs+0x5e>
        }
    }
    return cmd;
}
     67c:	8552                	mv	a0,s4
     67e:	70a6                	ld	ra,104(sp)
     680:	7406                	ld	s0,96(sp)
     682:	64e6                	ld	s1,88(sp)
     684:	6946                	ld	s2,80(sp)
     686:	69a6                	ld	s3,72(sp)
     688:	6a06                	ld	s4,64(sp)
     68a:	7ae2                	ld	s5,56(sp)
     68c:	7b42                	ld	s6,48(sp)
     68e:	7ba2                	ld	s7,40(sp)
     690:	7c02                	ld	s8,32(sp)
     692:	6ce2                	ld	s9,24(sp)
     694:	6165                	addi	sp,sp,112
     696:	8082                	ret

0000000000000698 <parseexec>:
    return cmd;
}

struct cmd *
parseexec(char **ps, char *es)
{
     698:	7119                	addi	sp,sp,-128
     69a:	fc86                	sd	ra,120(sp)
     69c:	f8a2                	sd	s0,112(sp)
     69e:	f4a6                	sd	s1,104(sp)
     6a0:	e8d2                	sd	s4,80(sp)
     6a2:	e4d6                	sd	s5,72(sp)
     6a4:	0100                	addi	s0,sp,128
     6a6:	8a2a                	mv	s4,a0
     6a8:	8aae                	mv	s5,a1
    char *q, *eq;
    int tok, argc;
    struct execcmd *cmd;
    struct cmd *ret;

    if (peek(ps, es, "("))
     6aa:	00001617          	auipc	a2,0x1
     6ae:	e0e60613          	addi	a2,a2,-498 # 14b8 <malloc+0x180>
     6b2:	00000097          	auipc	ra,0x0
     6b6:	e7a080e7          	jalr	-390(ra) # 52c <peek>
     6ba:	e521                	bnez	a0,702 <parseexec+0x6a>
     6bc:	f0ca                	sd	s2,96(sp)
     6be:	ecce                	sd	s3,88(sp)
     6c0:	e0da                	sd	s6,64(sp)
     6c2:	fc5e                	sd	s7,56(sp)
     6c4:	f862                	sd	s8,48(sp)
     6c6:	f466                	sd	s9,40(sp)
     6c8:	f06a                	sd	s10,32(sp)
     6ca:	ec6e                	sd	s11,24(sp)
     6cc:	89aa                	mv	s3,a0
        return parseblock(ps, es);

    ret = execcmd();
     6ce:	00000097          	auipc	ra,0x0
     6d2:	bac080e7          	jalr	-1108(ra) # 27a <execcmd>
     6d6:	8daa                	mv	s11,a0
    cmd = (struct execcmd *)ret;

    argc = 0;
    ret = parseredirs(ret, ps, es);
     6d8:	8656                	mv	a2,s5
     6da:	85d2                	mv	a1,s4
     6dc:	00000097          	auipc	ra,0x0
     6e0:	ebc080e7          	jalr	-324(ra) # 598 <parseredirs>
     6e4:	84aa                	mv	s1,a0
    while (!peek(ps, es, "|)&;"))
     6e6:	008d8913          	addi	s2,s11,8
     6ea:	00001b17          	auipc	s6,0x1
     6ee:	deeb0b13          	addi	s6,s6,-530 # 14d8 <malloc+0x1a0>
    {
        if ((tok = gettoken(ps, es, &q, &eq)) == 0)
     6f2:	f8040c13          	addi	s8,s0,-128
     6f6:	f8840b93          	addi	s7,s0,-120
            break;
        if (tok != 'a')
     6fa:	06100d13          	li	s10,97
            panic("syntax");
        cmd->argv[argc] = q;
        cmd->eargv[argc] = eq;
        argc++;
        if (argc >= MAXARGS)
     6fe:	4ca9                	li	s9,10
    while (!peek(ps, es, "|)&;"))
     700:	a081                	j	740 <parseexec+0xa8>
        return parseblock(ps, es);
     702:	85d6                	mv	a1,s5
     704:	8552                	mv	a0,s4
     706:	00000097          	auipc	ra,0x0
     70a:	1bc080e7          	jalr	444(ra) # 8c2 <parseblock>
     70e:	84aa                	mv	s1,a0
        ret = parseredirs(ret, ps, es);
    }
    cmd->argv[argc] = 0;
    cmd->eargv[argc] = 0;
    return ret;
}
     710:	8526                	mv	a0,s1
     712:	70e6                	ld	ra,120(sp)
     714:	7446                	ld	s0,112(sp)
     716:	74a6                	ld	s1,104(sp)
     718:	6a46                	ld	s4,80(sp)
     71a:	6aa6                	ld	s5,72(sp)
     71c:	6109                	addi	sp,sp,128
     71e:	8082                	ret
            panic("syntax");
     720:	00001517          	auipc	a0,0x1
     724:	da050513          	addi	a0,a0,-608 # 14c0 <malloc+0x188>
     728:	00000097          	auipc	ra,0x0
     72c:	92e080e7          	jalr	-1746(ra) # 56 <panic>
        ret = parseredirs(ret, ps, es);
     730:	8656                	mv	a2,s5
     732:	85d2                	mv	a1,s4
     734:	8526                	mv	a0,s1
     736:	00000097          	auipc	ra,0x0
     73a:	e62080e7          	jalr	-414(ra) # 598 <parseredirs>
     73e:	84aa                	mv	s1,a0
    while (!peek(ps, es, "|)&;"))
     740:	865a                	mv	a2,s6
     742:	85d6                	mv	a1,s5
     744:	8552                	mv	a0,s4
     746:	00000097          	auipc	ra,0x0
     74a:	de6080e7          	jalr	-538(ra) # 52c <peek>
     74e:	e121                	bnez	a0,78e <parseexec+0xf6>
        if ((tok = gettoken(ps, es, &q, &eq)) == 0)
     750:	86e2                	mv	a3,s8
     752:	865e                	mv	a2,s7
     754:	85d6                	mv	a1,s5
     756:	8552                	mv	a0,s4
     758:	00000097          	auipc	ra,0x0
     75c:	c88080e7          	jalr	-888(ra) # 3e0 <gettoken>
     760:	c51d                	beqz	a0,78e <parseexec+0xf6>
        if (tok != 'a')
     762:	fba51fe3          	bne	a0,s10,720 <parseexec+0x88>
        cmd->argv[argc] = q;
     766:	f8843783          	ld	a5,-120(s0)
     76a:	00f93023          	sd	a5,0(s2)
        cmd->eargv[argc] = eq;
     76e:	f8043783          	ld	a5,-128(s0)
     772:	04f93823          	sd	a5,80(s2)
        argc++;
     776:	2985                	addiw	s3,s3,1
        if (argc >= MAXARGS)
     778:	0921                	addi	s2,s2,8
     77a:	fb999be3          	bne	s3,s9,730 <parseexec+0x98>
            panic("too many args");
     77e:	00001517          	auipc	a0,0x1
     782:	d4a50513          	addi	a0,a0,-694 # 14c8 <malloc+0x190>
     786:	00000097          	auipc	ra,0x0
     78a:	8d0080e7          	jalr	-1840(ra) # 56 <panic>
    cmd->argv[argc] = 0;
     78e:	098e                	slli	s3,s3,0x3
     790:	9dce                	add	s11,s11,s3
     792:	000db423          	sd	zero,8(s11)
    cmd->eargv[argc] = 0;
     796:	040dbc23          	sd	zero,88(s11)
     79a:	7906                	ld	s2,96(sp)
     79c:	69e6                	ld	s3,88(sp)
     79e:	6b06                	ld	s6,64(sp)
     7a0:	7be2                	ld	s7,56(sp)
     7a2:	7c42                	ld	s8,48(sp)
     7a4:	7ca2                	ld	s9,40(sp)
     7a6:	7d02                	ld	s10,32(sp)
     7a8:	6de2                	ld	s11,24(sp)
    return ret;
     7aa:	b79d                	j	710 <parseexec+0x78>

00000000000007ac <parsepipe>:
{
     7ac:	7179                	addi	sp,sp,-48
     7ae:	f406                	sd	ra,40(sp)
     7b0:	f022                	sd	s0,32(sp)
     7b2:	ec26                	sd	s1,24(sp)
     7b4:	e84a                	sd	s2,16(sp)
     7b6:	e44e                	sd	s3,8(sp)
     7b8:	1800                	addi	s0,sp,48
     7ba:	892a                	mv	s2,a0
     7bc:	89ae                	mv	s3,a1
    cmd = parseexec(ps, es);
     7be:	00000097          	auipc	ra,0x0
     7c2:	eda080e7          	jalr	-294(ra) # 698 <parseexec>
     7c6:	84aa                	mv	s1,a0
    if (peek(ps, es, "|"))
     7c8:	00001617          	auipc	a2,0x1
     7cc:	d1860613          	addi	a2,a2,-744 # 14e0 <malloc+0x1a8>
     7d0:	85ce                	mv	a1,s3
     7d2:	854a                	mv	a0,s2
     7d4:	00000097          	auipc	ra,0x0
     7d8:	d58080e7          	jalr	-680(ra) # 52c <peek>
     7dc:	e909                	bnez	a0,7ee <parsepipe+0x42>
}
     7de:	8526                	mv	a0,s1
     7e0:	70a2                	ld	ra,40(sp)
     7e2:	7402                	ld	s0,32(sp)
     7e4:	64e2                	ld	s1,24(sp)
     7e6:	6942                	ld	s2,16(sp)
     7e8:	69a2                	ld	s3,8(sp)
     7ea:	6145                	addi	sp,sp,48
     7ec:	8082                	ret
        gettoken(ps, es, 0, 0);
     7ee:	4681                	li	a3,0
     7f0:	4601                	li	a2,0
     7f2:	85ce                	mv	a1,s3
     7f4:	854a                	mv	a0,s2
     7f6:	00000097          	auipc	ra,0x0
     7fa:	bea080e7          	jalr	-1046(ra) # 3e0 <gettoken>
        cmd = pipecmd(cmd, parsepipe(ps, es));
     7fe:	85ce                	mv	a1,s3
     800:	854a                	mv	a0,s2
     802:	00000097          	auipc	ra,0x0
     806:	faa080e7          	jalr	-86(ra) # 7ac <parsepipe>
     80a:	85aa                	mv	a1,a0
     80c:	8526                	mv	a0,s1
     80e:	00000097          	auipc	ra,0x0
     812:	b0a080e7          	jalr	-1270(ra) # 318 <pipecmd>
     816:	84aa                	mv	s1,a0
    return cmd;
     818:	b7d9                	j	7de <parsepipe+0x32>

000000000000081a <parseline>:
{
     81a:	7179                	addi	sp,sp,-48
     81c:	f406                	sd	ra,40(sp)
     81e:	f022                	sd	s0,32(sp)
     820:	ec26                	sd	s1,24(sp)
     822:	e84a                	sd	s2,16(sp)
     824:	e44e                	sd	s3,8(sp)
     826:	e052                	sd	s4,0(sp)
     828:	1800                	addi	s0,sp,48
     82a:	892a                	mv	s2,a0
     82c:	89ae                	mv	s3,a1
    cmd = parsepipe(ps, es);
     82e:	00000097          	auipc	ra,0x0
     832:	f7e080e7          	jalr	-130(ra) # 7ac <parsepipe>
     836:	84aa                	mv	s1,a0
    while (peek(ps, es, "&"))
     838:	00001a17          	auipc	s4,0x1
     83c:	cb0a0a13          	addi	s4,s4,-848 # 14e8 <malloc+0x1b0>
     840:	a839                	j	85e <parseline+0x44>
        gettoken(ps, es, 0, 0);
     842:	4681                	li	a3,0
     844:	4601                	li	a2,0
     846:	85ce                	mv	a1,s3
     848:	854a                	mv	a0,s2
     84a:	00000097          	auipc	ra,0x0
     84e:	b96080e7          	jalr	-1130(ra) # 3e0 <gettoken>
        cmd = backcmd(cmd);
     852:	8526                	mv	a0,s1
     854:	00000097          	auipc	ra,0x0
     858:	b50080e7          	jalr	-1200(ra) # 3a4 <backcmd>
     85c:	84aa                	mv	s1,a0
    while (peek(ps, es, "&"))
     85e:	8652                	mv	a2,s4
     860:	85ce                	mv	a1,s3
     862:	854a                	mv	a0,s2
     864:	00000097          	auipc	ra,0x0
     868:	cc8080e7          	jalr	-824(ra) # 52c <peek>
     86c:	f979                	bnez	a0,842 <parseline+0x28>
    if (peek(ps, es, ";"))
     86e:	00001617          	auipc	a2,0x1
     872:	c8260613          	addi	a2,a2,-894 # 14f0 <malloc+0x1b8>
     876:	85ce                	mv	a1,s3
     878:	854a                	mv	a0,s2
     87a:	00000097          	auipc	ra,0x0
     87e:	cb2080e7          	jalr	-846(ra) # 52c <peek>
     882:	e911                	bnez	a0,896 <parseline+0x7c>
}
     884:	8526                	mv	a0,s1
     886:	70a2                	ld	ra,40(sp)
     888:	7402                	ld	s0,32(sp)
     88a:	64e2                	ld	s1,24(sp)
     88c:	6942                	ld	s2,16(sp)
     88e:	69a2                	ld	s3,8(sp)
     890:	6a02                	ld	s4,0(sp)
     892:	6145                	addi	sp,sp,48
     894:	8082                	ret
        gettoken(ps, es, 0, 0);
     896:	4681                	li	a3,0
     898:	4601                	li	a2,0
     89a:	85ce                	mv	a1,s3
     89c:	854a                	mv	a0,s2
     89e:	00000097          	auipc	ra,0x0
     8a2:	b42080e7          	jalr	-1214(ra) # 3e0 <gettoken>
        cmd = listcmd(cmd, parseline(ps, es));
     8a6:	85ce                	mv	a1,s3
     8a8:	854a                	mv	a0,s2
     8aa:	00000097          	auipc	ra,0x0
     8ae:	f70080e7          	jalr	-144(ra) # 81a <parseline>
     8b2:	85aa                	mv	a1,a0
     8b4:	8526                	mv	a0,s1
     8b6:	00000097          	auipc	ra,0x0
     8ba:	aa8080e7          	jalr	-1368(ra) # 35e <listcmd>
     8be:	84aa                	mv	s1,a0
    return cmd;
     8c0:	b7d1                	j	884 <parseline+0x6a>

00000000000008c2 <parseblock>:
{
     8c2:	7179                	addi	sp,sp,-48
     8c4:	f406                	sd	ra,40(sp)
     8c6:	f022                	sd	s0,32(sp)
     8c8:	ec26                	sd	s1,24(sp)
     8ca:	e84a                	sd	s2,16(sp)
     8cc:	e44e                	sd	s3,8(sp)
     8ce:	1800                	addi	s0,sp,48
     8d0:	84aa                	mv	s1,a0
     8d2:	892e                	mv	s2,a1
    if (!peek(ps, es, "("))
     8d4:	00001617          	auipc	a2,0x1
     8d8:	be460613          	addi	a2,a2,-1052 # 14b8 <malloc+0x180>
     8dc:	00000097          	auipc	ra,0x0
     8e0:	c50080e7          	jalr	-944(ra) # 52c <peek>
     8e4:	c12d                	beqz	a0,946 <parseblock+0x84>
    gettoken(ps, es, 0, 0);
     8e6:	4681                	li	a3,0
     8e8:	4601                	li	a2,0
     8ea:	85ca                	mv	a1,s2
     8ec:	8526                	mv	a0,s1
     8ee:	00000097          	auipc	ra,0x0
     8f2:	af2080e7          	jalr	-1294(ra) # 3e0 <gettoken>
    cmd = parseline(ps, es);
     8f6:	85ca                	mv	a1,s2
     8f8:	8526                	mv	a0,s1
     8fa:	00000097          	auipc	ra,0x0
     8fe:	f20080e7          	jalr	-224(ra) # 81a <parseline>
     902:	89aa                	mv	s3,a0
    if (!peek(ps, es, ")"))
     904:	00001617          	auipc	a2,0x1
     908:	c0460613          	addi	a2,a2,-1020 # 1508 <malloc+0x1d0>
     90c:	85ca                	mv	a1,s2
     90e:	8526                	mv	a0,s1
     910:	00000097          	auipc	ra,0x0
     914:	c1c080e7          	jalr	-996(ra) # 52c <peek>
     918:	cd1d                	beqz	a0,956 <parseblock+0x94>
    gettoken(ps, es, 0, 0);
     91a:	4681                	li	a3,0
     91c:	4601                	li	a2,0
     91e:	85ca                	mv	a1,s2
     920:	8526                	mv	a0,s1
     922:	00000097          	auipc	ra,0x0
     926:	abe080e7          	jalr	-1346(ra) # 3e0 <gettoken>
    cmd = parseredirs(cmd, ps, es);
     92a:	864a                	mv	a2,s2
     92c:	85a6                	mv	a1,s1
     92e:	854e                	mv	a0,s3
     930:	00000097          	auipc	ra,0x0
     934:	c68080e7          	jalr	-920(ra) # 598 <parseredirs>
}
     938:	70a2                	ld	ra,40(sp)
     93a:	7402                	ld	s0,32(sp)
     93c:	64e2                	ld	s1,24(sp)
     93e:	6942                	ld	s2,16(sp)
     940:	69a2                	ld	s3,8(sp)
     942:	6145                	addi	sp,sp,48
     944:	8082                	ret
        panic("parseblock");
     946:	00001517          	auipc	a0,0x1
     94a:	bb250513          	addi	a0,a0,-1102 # 14f8 <malloc+0x1c0>
     94e:	fffff097          	auipc	ra,0xfffff
     952:	708080e7          	jalr	1800(ra) # 56 <panic>
        panic("syntax - missing )");
     956:	00001517          	auipc	a0,0x1
     95a:	bba50513          	addi	a0,a0,-1094 # 1510 <malloc+0x1d8>
     95e:	fffff097          	auipc	ra,0xfffff
     962:	6f8080e7          	jalr	1784(ra) # 56 <panic>

0000000000000966 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd *
nulterminate(struct cmd *cmd)
{
     966:	1101                	addi	sp,sp,-32
     968:	ec06                	sd	ra,24(sp)
     96a:	e822                	sd	s0,16(sp)
     96c:	e426                	sd	s1,8(sp)
     96e:	1000                	addi	s0,sp,32
     970:	84aa                	mv	s1,a0
    struct execcmd *ecmd;
    struct listcmd *lcmd;
    struct pipecmd *pcmd;
    struct redircmd *rcmd;

    if (cmd == 0)
     972:	c521                	beqz	a0,9ba <nulterminate+0x54>
        return 0;

    switch (cmd->type)
     974:	4118                	lw	a4,0(a0)
     976:	4795                	li	a5,5
     978:	04e7e163          	bltu	a5,a4,9ba <nulterminate+0x54>
     97c:	00056783          	lwu	a5,0(a0)
     980:	078a                	slli	a5,a5,0x2
     982:	00001717          	auipc	a4,0x1
     986:	c0670713          	addi	a4,a4,-1018 # 1588 <malloc+0x250>
     98a:	97ba                	add	a5,a5,a4
     98c:	439c                	lw	a5,0(a5)
     98e:	97ba                	add	a5,a5,a4
     990:	8782                	jr	a5
    {
    case EXEC:
        ecmd = (struct execcmd *)cmd;
        for (i = 0; ecmd->argv[i]; i++)
     992:	651c                	ld	a5,8(a0)
     994:	c39d                	beqz	a5,9ba <nulterminate+0x54>
     996:	01050793          	addi	a5,a0,16
            *ecmd->eargv[i] = 0;
     99a:	67b8                	ld	a4,72(a5)
     99c:	00070023          	sb	zero,0(a4)
        for (i = 0; ecmd->argv[i]; i++)
     9a0:	07a1                	addi	a5,a5,8
     9a2:	ff87b703          	ld	a4,-8(a5)
     9a6:	fb75                	bnez	a4,99a <nulterminate+0x34>
     9a8:	a809                	j	9ba <nulterminate+0x54>
        break;

    case REDIR:
        rcmd = (struct redircmd *)cmd;
        nulterminate(rcmd->cmd);
     9aa:	6508                	ld	a0,8(a0)
     9ac:	00000097          	auipc	ra,0x0
     9b0:	fba080e7          	jalr	-70(ra) # 966 <nulterminate>
        *rcmd->efile = 0;
     9b4:	6c9c                	ld	a5,24(s1)
     9b6:	00078023          	sb	zero,0(a5)
        bcmd = (struct backcmd *)cmd;
        nulterminate(bcmd->cmd);
        break;
    }
    return cmd;
}
     9ba:	8526                	mv	a0,s1
     9bc:	60e2                	ld	ra,24(sp)
     9be:	6442                	ld	s0,16(sp)
     9c0:	64a2                	ld	s1,8(sp)
     9c2:	6105                	addi	sp,sp,32
     9c4:	8082                	ret
        nulterminate(pcmd->left);
     9c6:	6508                	ld	a0,8(a0)
     9c8:	00000097          	auipc	ra,0x0
     9cc:	f9e080e7          	jalr	-98(ra) # 966 <nulterminate>
        nulterminate(pcmd->right);
     9d0:	6888                	ld	a0,16(s1)
     9d2:	00000097          	auipc	ra,0x0
     9d6:	f94080e7          	jalr	-108(ra) # 966 <nulterminate>
        break;
     9da:	b7c5                	j	9ba <nulterminate+0x54>
        nulterminate(lcmd->left);
     9dc:	6508                	ld	a0,8(a0)
     9de:	00000097          	auipc	ra,0x0
     9e2:	f88080e7          	jalr	-120(ra) # 966 <nulterminate>
        nulterminate(lcmd->right);
     9e6:	6888                	ld	a0,16(s1)
     9e8:	00000097          	auipc	ra,0x0
     9ec:	f7e080e7          	jalr	-130(ra) # 966 <nulterminate>
        break;
     9f0:	b7e9                	j	9ba <nulterminate+0x54>
        nulterminate(bcmd->cmd);
     9f2:	6508                	ld	a0,8(a0)
     9f4:	00000097          	auipc	ra,0x0
     9f8:	f72080e7          	jalr	-142(ra) # 966 <nulterminate>
        break;
     9fc:	bf7d                	j	9ba <nulterminate+0x54>

00000000000009fe <parsecmd>:
{
     9fe:	7139                	addi	sp,sp,-64
     a00:	fc06                	sd	ra,56(sp)
     a02:	f822                	sd	s0,48(sp)
     a04:	f426                	sd	s1,40(sp)
     a06:	f04a                	sd	s2,32(sp)
     a08:	ec4e                	sd	s3,24(sp)
     a0a:	0080                	addi	s0,sp,64
     a0c:	fca43423          	sd	a0,-56(s0)
    es = s + strlen(s);
     a10:	84aa                	mv	s1,a0
     a12:	00000097          	auipc	ra,0x0
     a16:	29c080e7          	jalr	668(ra) # cae <strlen>
     a1a:	1502                	slli	a0,a0,0x20
     a1c:	9101                	srli	a0,a0,0x20
     a1e:	94aa                	add	s1,s1,a0
    cmd = parseline(&s, es);
     a20:	fc840993          	addi	s3,s0,-56
     a24:	85a6                	mv	a1,s1
     a26:	854e                	mv	a0,s3
     a28:	00000097          	auipc	ra,0x0
     a2c:	df2080e7          	jalr	-526(ra) # 81a <parseline>
     a30:	892a                	mv	s2,a0
    peek(&s, es, "");
     a32:	00001617          	auipc	a2,0x1
     a36:	a1660613          	addi	a2,a2,-1514 # 1448 <malloc+0x110>
     a3a:	85a6                	mv	a1,s1
     a3c:	854e                	mv	a0,s3
     a3e:	00000097          	auipc	ra,0x0
     a42:	aee080e7          	jalr	-1298(ra) # 52c <peek>
    if (s != es)
     a46:	fc843603          	ld	a2,-56(s0)
     a4a:	00961f63          	bne	a2,s1,a68 <parsecmd+0x6a>
    nulterminate(cmd);
     a4e:	854a                	mv	a0,s2
     a50:	00000097          	auipc	ra,0x0
     a54:	f16080e7          	jalr	-234(ra) # 966 <nulterminate>
}
     a58:	854a                	mv	a0,s2
     a5a:	70e2                	ld	ra,56(sp)
     a5c:	7442                	ld	s0,48(sp)
     a5e:	74a2                	ld	s1,40(sp)
     a60:	7902                	ld	s2,32(sp)
     a62:	69e2                	ld	s3,24(sp)
     a64:	6121                	addi	sp,sp,64
     a66:	8082                	ret
        fprintf(2, "leftovers: %s\n", s);
     a68:	00001597          	auipc	a1,0x1
     a6c:	ac058593          	addi	a1,a1,-1344 # 1528 <malloc+0x1f0>
     a70:	4509                	li	a0,2
     a72:	00000097          	auipc	ra,0x0
     a76:	7dc080e7          	jalr	2012(ra) # 124e <fprintf>
        panic("syntax");
     a7a:	00001517          	auipc	a0,0x1
     a7e:	a4650513          	addi	a0,a0,-1466 # 14c0 <malloc+0x188>
     a82:	fffff097          	auipc	ra,0xfffff
     a86:	5d4080e7          	jalr	1492(ra) # 56 <panic>

0000000000000a8a <parse_buffer>:
{
     a8a:	1101                	addi	sp,sp,-32
     a8c:	ec06                	sd	ra,24(sp)
     a8e:	e822                	sd	s0,16(sp)
     a90:	e426                	sd	s1,8(sp)
     a92:	1000                	addi	s0,sp,32
     a94:	84aa                	mv	s1,a0
    if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ')
     a96:	00054783          	lbu	a5,0(a0)
     a9a:	06300713          	li	a4,99
     a9e:	02e78b63          	beq	a5,a4,ad4 <parse_buffer+0x4a>
    if (buf[0] == 'e' &&
     aa2:	06500713          	li	a4,101
     aa6:	00e79863          	bne	a5,a4,ab6 <parse_buffer+0x2c>
     aaa:	00154703          	lbu	a4,1(a0)
     aae:	07800793          	li	a5,120
     ab2:	06f70b63          	beq	a4,a5,b28 <parse_buffer+0x9e>
    if (fork1() == 0)
     ab6:	fffff097          	auipc	ra,0xfffff
     aba:	5c6080e7          	jalr	1478(ra) # 7c <fork1>
     abe:	c551                	beqz	a0,b4a <parse_buffer+0xc0>
    wait(0);
     ac0:	4501                	li	a0,0
     ac2:	00000097          	auipc	ra,0x0
     ac6:	444080e7          	jalr	1092(ra) # f06 <wait>
}
     aca:	60e2                	ld	ra,24(sp)
     acc:	6442                	ld	s0,16(sp)
     ace:	64a2                	ld	s1,8(sp)
     ad0:	6105                	addi	sp,sp,32
     ad2:	8082                	ret
    if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ')
     ad4:	00154703          	lbu	a4,1(a0)
     ad8:	06400793          	li	a5,100
     adc:	fcf71de3          	bne	a4,a5,ab6 <parse_buffer+0x2c>
     ae0:	00254703          	lbu	a4,2(a0)
     ae4:	02000793          	li	a5,32
     ae8:	fcf717e3          	bne	a4,a5,ab6 <parse_buffer+0x2c>
        buf[strlen(buf) - 1] = 0; // chop \n
     aec:	00000097          	auipc	ra,0x0
     af0:	1c2080e7          	jalr	450(ra) # cae <strlen>
     af4:	fff5079b          	addiw	a5,a0,-1
     af8:	1782                	slli	a5,a5,0x20
     afa:	9381                	srli	a5,a5,0x20
     afc:	97a6                	add	a5,a5,s1
     afe:	00078023          	sb	zero,0(a5)
        if (chdir(buf + 3) < 0)
     b02:	048d                	addi	s1,s1,3
     b04:	8526                	mv	a0,s1
     b06:	00000097          	auipc	ra,0x0
     b0a:	468080e7          	jalr	1128(ra) # f6e <chdir>
     b0e:	fa055ee3          	bgez	a0,aca <parse_buffer+0x40>
            fprintf(2, "cannot cd %s\n", buf + 3);
     b12:	8626                	mv	a2,s1
     b14:	00001597          	auipc	a1,0x1
     b18:	a2458593          	addi	a1,a1,-1500 # 1538 <malloc+0x200>
     b1c:	4509                	li	a0,2
     b1e:	00000097          	auipc	ra,0x0
     b22:	730080e7          	jalr	1840(ra) # 124e <fprintf>
     b26:	b755                	j	aca <parse_buffer+0x40>
        buf[1] == 'x' &&
     b28:	00254703          	lbu	a4,2(a0)
     b2c:	06900793          	li	a5,105
     b30:	f8f713e3          	bne	a4,a5,ab6 <parse_buffer+0x2c>
        buf[2] == 'i' &&
     b34:	00354703          	lbu	a4,3(a0)
     b38:	07400793          	li	a5,116
     b3c:	f6f71de3          	bne	a4,a5,ab6 <parse_buffer+0x2c>
        exit(0);
     b40:	4501                	li	a0,0
     b42:	00000097          	auipc	ra,0x0
     b46:	3bc080e7          	jalr	956(ra) # efe <exit>
        runcmd(parsecmd(buf));
     b4a:	8526                	mv	a0,s1
     b4c:	00000097          	auipc	ra,0x0
     b50:	eb2080e7          	jalr	-334(ra) # 9fe <parsecmd>
     b54:	fffff097          	auipc	ra,0xfffff
     b58:	556080e7          	jalr	1366(ra) # aa <runcmd>

0000000000000b5c <main>:
{
     b5c:	7179                	addi	sp,sp,-48
     b5e:	f406                	sd	ra,40(sp)
     b60:	f022                	sd	s0,32(sp)
     b62:	ec26                	sd	s1,24(sp)
     b64:	e84a                	sd	s2,16(sp)
     b66:	e44e                	sd	s3,8(sp)
     b68:	e052                	sd	s4,0(sp)
     b6a:	1800                	addi	s0,sp,48
     b6c:	89aa                	mv	s3,a0
     b6e:	8a2e                	mv	s4,a1
    while ((fd = open("console", O_RDWR)) >= 0)
     b70:	4489                	li	s1,2
     b72:	00001917          	auipc	s2,0x1
     b76:	9d690913          	addi	s2,s2,-1578 # 1548 <malloc+0x210>
     b7a:	85a6                	mv	a1,s1
     b7c:	854a                	mv	a0,s2
     b7e:	00000097          	auipc	ra,0x0
     b82:	3c0080e7          	jalr	960(ra) # f3e <open>
     b86:	00054863          	bltz	a0,b96 <main+0x3a>
        if (fd >= 3)
     b8a:	fea4d8e3          	bge	s1,a0,b7a <main+0x1e>
            close(fd);
     b8e:	00000097          	auipc	ra,0x0
     b92:	398080e7          	jalr	920(ra) # f26 <close>
    if (argc == 2)
     b96:	4789                	li	a5,2
    while (getcmd(buf, sizeof(buf)) >= 0)
     b98:	00001497          	auipc	s1,0x1
     b9c:	48848493          	addi	s1,s1,1160 # 2020 <buf.0>
     ba0:	07800913          	li	s2,120
    if (argc == 2)
     ba4:	08f99363          	bne	s3,a5,c2a <main+0xce>
        char *shell_script_file = argv[1];
     ba8:	008a3483          	ld	s1,8(s4)
        int shfd = open(shell_script_file, O_RDWR);
     bac:	85be                	mv	a1,a5
     bae:	8526                	mv	a0,s1
     bb0:	00000097          	auipc	ra,0x0
     bb4:	38e080e7          	jalr	910(ra) # f3e <open>
     bb8:	89aa                	mv	s3,a0
        if (shfd < 0)
     bba:	04054563          	bltz	a0,c04 <main+0xa8>
        read(shfd, buf, sizeof(buf));
     bbe:	07800613          	li	a2,120
     bc2:	00001597          	auipc	a1,0x1
     bc6:	45e58593          	addi	a1,a1,1118 # 2020 <buf.0>
     bca:	00000097          	auipc	ra,0x0
     bce:	34c080e7          	jalr	844(ra) # f16 <read>
            parse_buffer(buf);
     bd2:	00001917          	auipc	s2,0x1
     bd6:	44e90913          	addi	s2,s2,1102 # 2020 <buf.0>
        } while (read(shfd, buf, sizeof(buf)) == sizeof(buf));
     bda:	07800493          	li	s1,120
            parse_buffer(buf);
     bde:	854a                	mv	a0,s2
     be0:	00000097          	auipc	ra,0x0
     be4:	eaa080e7          	jalr	-342(ra) # a8a <parse_buffer>
        } while (read(shfd, buf, sizeof(buf)) == sizeof(buf));
     be8:	8626                	mv	a2,s1
     bea:	85ca                	mv	a1,s2
     bec:	854e                	mv	a0,s3
     bee:	00000097          	auipc	ra,0x0
     bf2:	328080e7          	jalr	808(ra) # f16 <read>
     bf6:	fe9504e3          	beq	a0,s1,bde <main+0x82>
        exit(0);
     bfa:	4501                	li	a0,0
     bfc:	00000097          	auipc	ra,0x0
     c00:	302080e7          	jalr	770(ra) # efe <exit>
            printf("Failed to open %s\n", shell_script_file);
     c04:	85a6                	mv	a1,s1
     c06:	00001517          	auipc	a0,0x1
     c0a:	94a50513          	addi	a0,a0,-1718 # 1550 <malloc+0x218>
     c0e:	00000097          	auipc	ra,0x0
     c12:	66e080e7          	jalr	1646(ra) # 127c <printf>
            exit(1);
     c16:	4505                	li	a0,1
     c18:	00000097          	auipc	ra,0x0
     c1c:	2e6080e7          	jalr	742(ra) # efe <exit>
        parse_buffer(buf);
     c20:	8526                	mv	a0,s1
     c22:	00000097          	auipc	ra,0x0
     c26:	e68080e7          	jalr	-408(ra) # a8a <parse_buffer>
    while (getcmd(buf, sizeof(buf)) >= 0)
     c2a:	85ca                	mv	a1,s2
     c2c:	8526                	mv	a0,s1
     c2e:	fffff097          	auipc	ra,0xfffff
     c32:	3d2080e7          	jalr	978(ra) # 0 <getcmd>
     c36:	fe0555e3          	bgez	a0,c20 <main+0xc4>
    exit(0);
     c3a:	4501                	li	a0,0
     c3c:	00000097          	auipc	ra,0x0
     c40:	2c2080e7          	jalr	706(ra) # efe <exit>

0000000000000c44 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     c44:	1141                	addi	sp,sp,-16
     c46:	e406                	sd	ra,8(sp)
     c48:	e022                	sd	s0,0(sp)
     c4a:	0800                	addi	s0,sp,16
  extern int main();
  main();
     c4c:	00000097          	auipc	ra,0x0
     c50:	f10080e7          	jalr	-240(ra) # b5c <main>
  exit(0);
     c54:	4501                	li	a0,0
     c56:	00000097          	auipc	ra,0x0
     c5a:	2a8080e7          	jalr	680(ra) # efe <exit>

0000000000000c5e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     c5e:	1141                	addi	sp,sp,-16
     c60:	e406                	sd	ra,8(sp)
     c62:	e022                	sd	s0,0(sp)
     c64:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     c66:	87aa                	mv	a5,a0
     c68:	0585                	addi	a1,a1,1
     c6a:	0785                	addi	a5,a5,1
     c6c:	fff5c703          	lbu	a4,-1(a1)
     c70:	fee78fa3          	sb	a4,-1(a5)
     c74:	fb75                	bnez	a4,c68 <strcpy+0xa>
    ;
  return os;
}
     c76:	60a2                	ld	ra,8(sp)
     c78:	6402                	ld	s0,0(sp)
     c7a:	0141                	addi	sp,sp,16
     c7c:	8082                	ret

0000000000000c7e <strcmp>:

int
strcmp(const char *p, const char *q)
{
     c7e:	1141                	addi	sp,sp,-16
     c80:	e406                	sd	ra,8(sp)
     c82:	e022                	sd	s0,0(sp)
     c84:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     c86:	00054783          	lbu	a5,0(a0)
     c8a:	cb91                	beqz	a5,c9e <strcmp+0x20>
     c8c:	0005c703          	lbu	a4,0(a1)
     c90:	00f71763          	bne	a4,a5,c9e <strcmp+0x20>
    p++, q++;
     c94:	0505                	addi	a0,a0,1
     c96:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     c98:	00054783          	lbu	a5,0(a0)
     c9c:	fbe5                	bnez	a5,c8c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     c9e:	0005c503          	lbu	a0,0(a1)
}
     ca2:	40a7853b          	subw	a0,a5,a0
     ca6:	60a2                	ld	ra,8(sp)
     ca8:	6402                	ld	s0,0(sp)
     caa:	0141                	addi	sp,sp,16
     cac:	8082                	ret

0000000000000cae <strlen>:

uint
strlen(const char *s)
{
     cae:	1141                	addi	sp,sp,-16
     cb0:	e406                	sd	ra,8(sp)
     cb2:	e022                	sd	s0,0(sp)
     cb4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     cb6:	00054783          	lbu	a5,0(a0)
     cba:	cf99                	beqz	a5,cd8 <strlen+0x2a>
     cbc:	0505                	addi	a0,a0,1
     cbe:	87aa                	mv	a5,a0
     cc0:	86be                	mv	a3,a5
     cc2:	0785                	addi	a5,a5,1
     cc4:	fff7c703          	lbu	a4,-1(a5)
     cc8:	ff65                	bnez	a4,cc0 <strlen+0x12>
     cca:	40a6853b          	subw	a0,a3,a0
     cce:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     cd0:	60a2                	ld	ra,8(sp)
     cd2:	6402                	ld	s0,0(sp)
     cd4:	0141                	addi	sp,sp,16
     cd6:	8082                	ret
  for(n = 0; s[n]; n++)
     cd8:	4501                	li	a0,0
     cda:	bfdd                	j	cd0 <strlen+0x22>

0000000000000cdc <memset>:

void*
memset(void *dst, int c, uint n)
{
     cdc:	1141                	addi	sp,sp,-16
     cde:	e406                	sd	ra,8(sp)
     ce0:	e022                	sd	s0,0(sp)
     ce2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     ce4:	ca19                	beqz	a2,cfa <memset+0x1e>
     ce6:	87aa                	mv	a5,a0
     ce8:	1602                	slli	a2,a2,0x20
     cea:	9201                	srli	a2,a2,0x20
     cec:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     cf0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     cf4:	0785                	addi	a5,a5,1
     cf6:	fee79de3          	bne	a5,a4,cf0 <memset+0x14>
  }
  return dst;
}
     cfa:	60a2                	ld	ra,8(sp)
     cfc:	6402                	ld	s0,0(sp)
     cfe:	0141                	addi	sp,sp,16
     d00:	8082                	ret

0000000000000d02 <strchr>:

char*
strchr(const char *s, char c)
{
     d02:	1141                	addi	sp,sp,-16
     d04:	e406                	sd	ra,8(sp)
     d06:	e022                	sd	s0,0(sp)
     d08:	0800                	addi	s0,sp,16
  for(; *s; s++)
     d0a:	00054783          	lbu	a5,0(a0)
     d0e:	cf81                	beqz	a5,d26 <strchr+0x24>
    if(*s == c)
     d10:	00f58763          	beq	a1,a5,d1e <strchr+0x1c>
  for(; *s; s++)
     d14:	0505                	addi	a0,a0,1
     d16:	00054783          	lbu	a5,0(a0)
     d1a:	fbfd                	bnez	a5,d10 <strchr+0xe>
      return (char*)s;
  return 0;
     d1c:	4501                	li	a0,0
}
     d1e:	60a2                	ld	ra,8(sp)
     d20:	6402                	ld	s0,0(sp)
     d22:	0141                	addi	sp,sp,16
     d24:	8082                	ret
  return 0;
     d26:	4501                	li	a0,0
     d28:	bfdd                	j	d1e <strchr+0x1c>

0000000000000d2a <gets>:

char*
gets(char *buf, int max)
{
     d2a:	7159                	addi	sp,sp,-112
     d2c:	f486                	sd	ra,104(sp)
     d2e:	f0a2                	sd	s0,96(sp)
     d30:	eca6                	sd	s1,88(sp)
     d32:	e8ca                	sd	s2,80(sp)
     d34:	e4ce                	sd	s3,72(sp)
     d36:	e0d2                	sd	s4,64(sp)
     d38:	fc56                	sd	s5,56(sp)
     d3a:	f85a                	sd	s6,48(sp)
     d3c:	f45e                	sd	s7,40(sp)
     d3e:	f062                	sd	s8,32(sp)
     d40:	ec66                	sd	s9,24(sp)
     d42:	e86a                	sd	s10,16(sp)
     d44:	1880                	addi	s0,sp,112
     d46:	8caa                	mv	s9,a0
     d48:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     d4a:	892a                	mv	s2,a0
     d4c:	4481                	li	s1,0
    cc = read(0, &c, 1);
     d4e:	f9f40b13          	addi	s6,s0,-97
     d52:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     d54:	4ba9                	li	s7,10
     d56:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
     d58:	8d26                	mv	s10,s1
     d5a:	0014899b          	addiw	s3,s1,1
     d5e:	84ce                	mv	s1,s3
     d60:	0349d763          	bge	s3,s4,d8e <gets+0x64>
    cc = read(0, &c, 1);
     d64:	8656                	mv	a2,s5
     d66:	85da                	mv	a1,s6
     d68:	4501                	li	a0,0
     d6a:	00000097          	auipc	ra,0x0
     d6e:	1ac080e7          	jalr	428(ra) # f16 <read>
    if(cc < 1)
     d72:	00a05e63          	blez	a0,d8e <gets+0x64>
    buf[i++] = c;
     d76:	f9f44783          	lbu	a5,-97(s0)
     d7a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     d7e:	01778763          	beq	a5,s7,d8c <gets+0x62>
     d82:	0905                	addi	s2,s2,1
     d84:	fd879ae3          	bne	a5,s8,d58 <gets+0x2e>
    buf[i++] = c;
     d88:	8d4e                	mv	s10,s3
     d8a:	a011                	j	d8e <gets+0x64>
     d8c:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
     d8e:	9d66                	add	s10,s10,s9
     d90:	000d0023          	sb	zero,0(s10)
  return buf;
}
     d94:	8566                	mv	a0,s9
     d96:	70a6                	ld	ra,104(sp)
     d98:	7406                	ld	s0,96(sp)
     d9a:	64e6                	ld	s1,88(sp)
     d9c:	6946                	ld	s2,80(sp)
     d9e:	69a6                	ld	s3,72(sp)
     da0:	6a06                	ld	s4,64(sp)
     da2:	7ae2                	ld	s5,56(sp)
     da4:	7b42                	ld	s6,48(sp)
     da6:	7ba2                	ld	s7,40(sp)
     da8:	7c02                	ld	s8,32(sp)
     daa:	6ce2                	ld	s9,24(sp)
     dac:	6d42                	ld	s10,16(sp)
     dae:	6165                	addi	sp,sp,112
     db0:	8082                	ret

0000000000000db2 <stat>:

int
stat(const char *n, struct stat *st)
{
     db2:	1101                	addi	sp,sp,-32
     db4:	ec06                	sd	ra,24(sp)
     db6:	e822                	sd	s0,16(sp)
     db8:	e04a                	sd	s2,0(sp)
     dba:	1000                	addi	s0,sp,32
     dbc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     dbe:	4581                	li	a1,0
     dc0:	00000097          	auipc	ra,0x0
     dc4:	17e080e7          	jalr	382(ra) # f3e <open>
  if(fd < 0)
     dc8:	02054663          	bltz	a0,df4 <stat+0x42>
     dcc:	e426                	sd	s1,8(sp)
     dce:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     dd0:	85ca                	mv	a1,s2
     dd2:	00000097          	auipc	ra,0x0
     dd6:	184080e7          	jalr	388(ra) # f56 <fstat>
     dda:	892a                	mv	s2,a0
  close(fd);
     ddc:	8526                	mv	a0,s1
     dde:	00000097          	auipc	ra,0x0
     de2:	148080e7          	jalr	328(ra) # f26 <close>
  return r;
     de6:	64a2                	ld	s1,8(sp)
}
     de8:	854a                	mv	a0,s2
     dea:	60e2                	ld	ra,24(sp)
     dec:	6442                	ld	s0,16(sp)
     dee:	6902                	ld	s2,0(sp)
     df0:	6105                	addi	sp,sp,32
     df2:	8082                	ret
    return -1;
     df4:	597d                	li	s2,-1
     df6:	bfcd                	j	de8 <stat+0x36>

0000000000000df8 <atoi>:

int
atoi(const char *s)
{
     df8:	1141                	addi	sp,sp,-16
     dfa:	e406                	sd	ra,8(sp)
     dfc:	e022                	sd	s0,0(sp)
     dfe:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     e00:	00054683          	lbu	a3,0(a0)
     e04:	fd06879b          	addiw	a5,a3,-48
     e08:	0ff7f793          	zext.b	a5,a5
     e0c:	4625                	li	a2,9
     e0e:	02f66963          	bltu	a2,a5,e40 <atoi+0x48>
     e12:	872a                	mv	a4,a0
  n = 0;
     e14:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     e16:	0705                	addi	a4,a4,1
     e18:	0025179b          	slliw	a5,a0,0x2
     e1c:	9fa9                	addw	a5,a5,a0
     e1e:	0017979b          	slliw	a5,a5,0x1
     e22:	9fb5                	addw	a5,a5,a3
     e24:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     e28:	00074683          	lbu	a3,0(a4)
     e2c:	fd06879b          	addiw	a5,a3,-48
     e30:	0ff7f793          	zext.b	a5,a5
     e34:	fef671e3          	bgeu	a2,a5,e16 <atoi+0x1e>
  return n;
}
     e38:	60a2                	ld	ra,8(sp)
     e3a:	6402                	ld	s0,0(sp)
     e3c:	0141                	addi	sp,sp,16
     e3e:	8082                	ret
  n = 0;
     e40:	4501                	li	a0,0
     e42:	bfdd                	j	e38 <atoi+0x40>

0000000000000e44 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     e44:	1141                	addi	sp,sp,-16
     e46:	e406                	sd	ra,8(sp)
     e48:	e022                	sd	s0,0(sp)
     e4a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     e4c:	02b57563          	bgeu	a0,a1,e76 <memmove+0x32>
    while(n-- > 0)
     e50:	00c05f63          	blez	a2,e6e <memmove+0x2a>
     e54:	1602                	slli	a2,a2,0x20
     e56:	9201                	srli	a2,a2,0x20
     e58:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     e5c:	872a                	mv	a4,a0
      *dst++ = *src++;
     e5e:	0585                	addi	a1,a1,1
     e60:	0705                	addi	a4,a4,1
     e62:	fff5c683          	lbu	a3,-1(a1)
     e66:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     e6a:	fee79ae3          	bne	a5,a4,e5e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     e6e:	60a2                	ld	ra,8(sp)
     e70:	6402                	ld	s0,0(sp)
     e72:	0141                	addi	sp,sp,16
     e74:	8082                	ret
    dst += n;
     e76:	00c50733          	add	a4,a0,a2
    src += n;
     e7a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     e7c:	fec059e3          	blez	a2,e6e <memmove+0x2a>
     e80:	fff6079b          	addiw	a5,a2,-1
     e84:	1782                	slli	a5,a5,0x20
     e86:	9381                	srli	a5,a5,0x20
     e88:	fff7c793          	not	a5,a5
     e8c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     e8e:	15fd                	addi	a1,a1,-1
     e90:	177d                	addi	a4,a4,-1
     e92:	0005c683          	lbu	a3,0(a1)
     e96:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     e9a:	fef71ae3          	bne	a4,a5,e8e <memmove+0x4a>
     e9e:	bfc1                	j	e6e <memmove+0x2a>

0000000000000ea0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     ea0:	1141                	addi	sp,sp,-16
     ea2:	e406                	sd	ra,8(sp)
     ea4:	e022                	sd	s0,0(sp)
     ea6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     ea8:	ca0d                	beqz	a2,eda <memcmp+0x3a>
     eaa:	fff6069b          	addiw	a3,a2,-1
     eae:	1682                	slli	a3,a3,0x20
     eb0:	9281                	srli	a3,a3,0x20
     eb2:	0685                	addi	a3,a3,1
     eb4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     eb6:	00054783          	lbu	a5,0(a0)
     eba:	0005c703          	lbu	a4,0(a1)
     ebe:	00e79863          	bne	a5,a4,ece <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
     ec2:	0505                	addi	a0,a0,1
    p2++;
     ec4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     ec6:	fed518e3          	bne	a0,a3,eb6 <memcmp+0x16>
  }
  return 0;
     eca:	4501                	li	a0,0
     ecc:	a019                	j	ed2 <memcmp+0x32>
      return *p1 - *p2;
     ece:	40e7853b          	subw	a0,a5,a4
}
     ed2:	60a2                	ld	ra,8(sp)
     ed4:	6402                	ld	s0,0(sp)
     ed6:	0141                	addi	sp,sp,16
     ed8:	8082                	ret
  return 0;
     eda:	4501                	li	a0,0
     edc:	bfdd                	j	ed2 <memcmp+0x32>

0000000000000ede <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     ede:	1141                	addi	sp,sp,-16
     ee0:	e406                	sd	ra,8(sp)
     ee2:	e022                	sd	s0,0(sp)
     ee4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     ee6:	00000097          	auipc	ra,0x0
     eea:	f5e080e7          	jalr	-162(ra) # e44 <memmove>
}
     eee:	60a2                	ld	ra,8(sp)
     ef0:	6402                	ld	s0,0(sp)
     ef2:	0141                	addi	sp,sp,16
     ef4:	8082                	ret

0000000000000ef6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     ef6:	4885                	li	a7,1
 ecall
     ef8:	00000073          	ecall
 ret
     efc:	8082                	ret

0000000000000efe <exit>:
.global exit
exit:
 li a7, SYS_exit
     efe:	4889                	li	a7,2
 ecall
     f00:	00000073          	ecall
 ret
     f04:	8082                	ret

0000000000000f06 <wait>:
.global wait
wait:
 li a7, SYS_wait
     f06:	488d                	li	a7,3
 ecall
     f08:	00000073          	ecall
 ret
     f0c:	8082                	ret

0000000000000f0e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     f0e:	4891                	li	a7,4
 ecall
     f10:	00000073          	ecall
 ret
     f14:	8082                	ret

0000000000000f16 <read>:
.global read
read:
 li a7, SYS_read
     f16:	4895                	li	a7,5
 ecall
     f18:	00000073          	ecall
 ret
     f1c:	8082                	ret

0000000000000f1e <write>:
.global write
write:
 li a7, SYS_write
     f1e:	48c1                	li	a7,16
 ecall
     f20:	00000073          	ecall
 ret
     f24:	8082                	ret

0000000000000f26 <close>:
.global close
close:
 li a7, SYS_close
     f26:	48d5                	li	a7,21
 ecall
     f28:	00000073          	ecall
 ret
     f2c:	8082                	ret

0000000000000f2e <kill>:
.global kill
kill:
 li a7, SYS_kill
     f2e:	4899                	li	a7,6
 ecall
     f30:	00000073          	ecall
 ret
     f34:	8082                	ret

0000000000000f36 <exec>:
.global exec
exec:
 li a7, SYS_exec
     f36:	489d                	li	a7,7
 ecall
     f38:	00000073          	ecall
 ret
     f3c:	8082                	ret

0000000000000f3e <open>:
.global open
open:
 li a7, SYS_open
     f3e:	48bd                	li	a7,15
 ecall
     f40:	00000073          	ecall
 ret
     f44:	8082                	ret

0000000000000f46 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     f46:	48c5                	li	a7,17
 ecall
     f48:	00000073          	ecall
 ret
     f4c:	8082                	ret

0000000000000f4e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     f4e:	48c9                	li	a7,18
 ecall
     f50:	00000073          	ecall
 ret
     f54:	8082                	ret

0000000000000f56 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     f56:	48a1                	li	a7,8
 ecall
     f58:	00000073          	ecall
 ret
     f5c:	8082                	ret

0000000000000f5e <link>:
.global link
link:
 li a7, SYS_link
     f5e:	48cd                	li	a7,19
 ecall
     f60:	00000073          	ecall
 ret
     f64:	8082                	ret

0000000000000f66 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     f66:	48d1                	li	a7,20
 ecall
     f68:	00000073          	ecall
 ret
     f6c:	8082                	ret

0000000000000f6e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     f6e:	48a5                	li	a7,9
 ecall
     f70:	00000073          	ecall
 ret
     f74:	8082                	ret

0000000000000f76 <dup>:
.global dup
dup:
 li a7, SYS_dup
     f76:	48a9                	li	a7,10
 ecall
     f78:	00000073          	ecall
 ret
     f7c:	8082                	ret

0000000000000f7e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     f7e:	48ad                	li	a7,11
 ecall
     f80:	00000073          	ecall
 ret
     f84:	8082                	ret

0000000000000f86 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     f86:	48b1                	li	a7,12
 ecall
     f88:	00000073          	ecall
 ret
     f8c:	8082                	ret

0000000000000f8e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     f8e:	48b5                	li	a7,13
 ecall
     f90:	00000073          	ecall
 ret
     f94:	8082                	ret

0000000000000f96 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     f96:	48b9                	li	a7,14
 ecall
     f98:	00000073          	ecall
 ret
     f9c:	8082                	ret

0000000000000f9e <ps>:
.global ps
ps:
 li a7, SYS_ps
     f9e:	48d9                	li	a7,22
 ecall
     fa0:	00000073          	ecall
 ret
     fa4:	8082                	ret

0000000000000fa6 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
     fa6:	48dd                	li	a7,23
 ecall
     fa8:	00000073          	ecall
 ret
     fac:	8082                	ret

0000000000000fae <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
     fae:	48e1                	li	a7,24
 ecall
     fb0:	00000073          	ecall
 ret
     fb4:	8082                	ret

0000000000000fb6 <va2pa>:
.global va2pa
va2pa:
 li a7, SYS_va2pa
     fb6:	48e9                	li	a7,26
 ecall
     fb8:	00000073          	ecall
 ret
     fbc:	8082                	ret

0000000000000fbe <pfreepages>:
.global pfreepages
pfreepages:
 li a7, SYS_pfreepages
     fbe:	48e5                	li	a7,25
 ecall
     fc0:	00000073          	ecall
 ret
     fc4:	8082                	ret

0000000000000fc6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     fc6:	1101                	addi	sp,sp,-32
     fc8:	ec06                	sd	ra,24(sp)
     fca:	e822                	sd	s0,16(sp)
     fcc:	1000                	addi	s0,sp,32
     fce:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     fd2:	4605                	li	a2,1
     fd4:	fef40593          	addi	a1,s0,-17
     fd8:	00000097          	auipc	ra,0x0
     fdc:	f46080e7          	jalr	-186(ra) # f1e <write>
}
     fe0:	60e2                	ld	ra,24(sp)
     fe2:	6442                	ld	s0,16(sp)
     fe4:	6105                	addi	sp,sp,32
     fe6:	8082                	ret

0000000000000fe8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     fe8:	7139                	addi	sp,sp,-64
     fea:	fc06                	sd	ra,56(sp)
     fec:	f822                	sd	s0,48(sp)
     fee:	f426                	sd	s1,40(sp)
     ff0:	f04a                	sd	s2,32(sp)
     ff2:	ec4e                	sd	s3,24(sp)
     ff4:	0080                	addi	s0,sp,64
     ff6:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     ff8:	c299                	beqz	a3,ffe <printint+0x16>
     ffa:	0805c063          	bltz	a1,107a <printint+0x92>
  neg = 0;
     ffe:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
    1000:	fc040313          	addi	t1,s0,-64
  neg = 0;
    1004:	869a                	mv	a3,t1
  i = 0;
    1006:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
    1008:	00000817          	auipc	a6,0x0
    100c:	5f080813          	addi	a6,a6,1520 # 15f8 <digits>
    1010:	88be                	mv	a7,a5
    1012:	0017851b          	addiw	a0,a5,1
    1016:	87aa                	mv	a5,a0
    1018:	02c5f73b          	remuw	a4,a1,a2
    101c:	1702                	slli	a4,a4,0x20
    101e:	9301                	srli	a4,a4,0x20
    1020:	9742                	add	a4,a4,a6
    1022:	00074703          	lbu	a4,0(a4)
    1026:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
    102a:	872e                	mv	a4,a1
    102c:	02c5d5bb          	divuw	a1,a1,a2
    1030:	0685                	addi	a3,a3,1
    1032:	fcc77fe3          	bgeu	a4,a2,1010 <printint+0x28>
  if(neg)
    1036:	000e0c63          	beqz	t3,104e <printint+0x66>
    buf[i++] = '-';
    103a:	fd050793          	addi	a5,a0,-48
    103e:	00878533          	add	a0,a5,s0
    1042:	02d00793          	li	a5,45
    1046:	fef50823          	sb	a5,-16(a0)
    104a:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    104e:	fff7899b          	addiw	s3,a5,-1
    1052:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
    1056:	fff4c583          	lbu	a1,-1(s1)
    105a:	854a                	mv	a0,s2
    105c:	00000097          	auipc	ra,0x0
    1060:	f6a080e7          	jalr	-150(ra) # fc6 <putc>
  while(--i >= 0)
    1064:	39fd                	addiw	s3,s3,-1
    1066:	14fd                	addi	s1,s1,-1
    1068:	fe09d7e3          	bgez	s3,1056 <printint+0x6e>
}
    106c:	70e2                	ld	ra,56(sp)
    106e:	7442                	ld	s0,48(sp)
    1070:	74a2                	ld	s1,40(sp)
    1072:	7902                	ld	s2,32(sp)
    1074:	69e2                	ld	s3,24(sp)
    1076:	6121                	addi	sp,sp,64
    1078:	8082                	ret
    x = -xx;
    107a:	40b005bb          	negw	a1,a1
    neg = 1;
    107e:	4e05                	li	t3,1
    x = -xx;
    1080:	b741                	j	1000 <printint+0x18>

0000000000001082 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    1082:	715d                	addi	sp,sp,-80
    1084:	e486                	sd	ra,72(sp)
    1086:	e0a2                	sd	s0,64(sp)
    1088:	f84a                	sd	s2,48(sp)
    108a:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    108c:	0005c903          	lbu	s2,0(a1)
    1090:	1a090a63          	beqz	s2,1244 <vprintf+0x1c2>
    1094:	fc26                	sd	s1,56(sp)
    1096:	f44e                	sd	s3,40(sp)
    1098:	f052                	sd	s4,32(sp)
    109a:	ec56                	sd	s5,24(sp)
    109c:	e85a                	sd	s6,16(sp)
    109e:	e45e                	sd	s7,8(sp)
    10a0:	8aaa                	mv	s5,a0
    10a2:	8bb2                	mv	s7,a2
    10a4:	00158493          	addi	s1,a1,1
  state = 0;
    10a8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    10aa:	02500a13          	li	s4,37
    10ae:	4b55                	li	s6,21
    10b0:	a839                	j	10ce <vprintf+0x4c>
        putc(fd, c);
    10b2:	85ca                	mv	a1,s2
    10b4:	8556                	mv	a0,s5
    10b6:	00000097          	auipc	ra,0x0
    10ba:	f10080e7          	jalr	-240(ra) # fc6 <putc>
    10be:	a019                	j	10c4 <vprintf+0x42>
    } else if(state == '%'){
    10c0:	01498d63          	beq	s3,s4,10da <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
    10c4:	0485                	addi	s1,s1,1
    10c6:	fff4c903          	lbu	s2,-1(s1)
    10ca:	16090763          	beqz	s2,1238 <vprintf+0x1b6>
    if(state == 0){
    10ce:	fe0999e3          	bnez	s3,10c0 <vprintf+0x3e>
      if(c == '%'){
    10d2:	ff4910e3          	bne	s2,s4,10b2 <vprintf+0x30>
        state = '%';
    10d6:	89d2                	mv	s3,s4
    10d8:	b7f5                	j	10c4 <vprintf+0x42>
      if(c == 'd'){
    10da:	13490463          	beq	s2,s4,1202 <vprintf+0x180>
    10de:	f9d9079b          	addiw	a5,s2,-99
    10e2:	0ff7f793          	zext.b	a5,a5
    10e6:	12fb6763          	bltu	s6,a5,1214 <vprintf+0x192>
    10ea:	f9d9079b          	addiw	a5,s2,-99
    10ee:	0ff7f713          	zext.b	a4,a5
    10f2:	12eb6163          	bltu	s6,a4,1214 <vprintf+0x192>
    10f6:	00271793          	slli	a5,a4,0x2
    10fa:	00000717          	auipc	a4,0x0
    10fe:	4a670713          	addi	a4,a4,1190 # 15a0 <malloc+0x268>
    1102:	97ba                	add	a5,a5,a4
    1104:	439c                	lw	a5,0(a5)
    1106:	97ba                	add	a5,a5,a4
    1108:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    110a:	008b8913          	addi	s2,s7,8
    110e:	4685                	li	a3,1
    1110:	4629                	li	a2,10
    1112:	000ba583          	lw	a1,0(s7)
    1116:	8556                	mv	a0,s5
    1118:	00000097          	auipc	ra,0x0
    111c:	ed0080e7          	jalr	-304(ra) # fe8 <printint>
    1120:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1122:	4981                	li	s3,0
    1124:	b745                	j	10c4 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1126:	008b8913          	addi	s2,s7,8
    112a:	4681                	li	a3,0
    112c:	4629                	li	a2,10
    112e:	000ba583          	lw	a1,0(s7)
    1132:	8556                	mv	a0,s5
    1134:	00000097          	auipc	ra,0x0
    1138:	eb4080e7          	jalr	-332(ra) # fe8 <printint>
    113c:	8bca                	mv	s7,s2
      state = 0;
    113e:	4981                	li	s3,0
    1140:	b751                	j	10c4 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
    1142:	008b8913          	addi	s2,s7,8
    1146:	4681                	li	a3,0
    1148:	4641                	li	a2,16
    114a:	000ba583          	lw	a1,0(s7)
    114e:	8556                	mv	a0,s5
    1150:	00000097          	auipc	ra,0x0
    1154:	e98080e7          	jalr	-360(ra) # fe8 <printint>
    1158:	8bca                	mv	s7,s2
      state = 0;
    115a:	4981                	li	s3,0
    115c:	b7a5                	j	10c4 <vprintf+0x42>
    115e:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    1160:	008b8c13          	addi	s8,s7,8
    1164:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    1168:	03000593          	li	a1,48
    116c:	8556                	mv	a0,s5
    116e:	00000097          	auipc	ra,0x0
    1172:	e58080e7          	jalr	-424(ra) # fc6 <putc>
  putc(fd, 'x');
    1176:	07800593          	li	a1,120
    117a:	8556                	mv	a0,s5
    117c:	00000097          	auipc	ra,0x0
    1180:	e4a080e7          	jalr	-438(ra) # fc6 <putc>
    1184:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1186:	00000b97          	auipc	s7,0x0
    118a:	472b8b93          	addi	s7,s7,1138 # 15f8 <digits>
    118e:	03c9d793          	srli	a5,s3,0x3c
    1192:	97de                	add	a5,a5,s7
    1194:	0007c583          	lbu	a1,0(a5)
    1198:	8556                	mv	a0,s5
    119a:	00000097          	auipc	ra,0x0
    119e:	e2c080e7          	jalr	-468(ra) # fc6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    11a2:	0992                	slli	s3,s3,0x4
    11a4:	397d                	addiw	s2,s2,-1
    11a6:	fe0914e3          	bnez	s2,118e <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    11aa:	8be2                	mv	s7,s8
      state = 0;
    11ac:	4981                	li	s3,0
    11ae:	6c02                	ld	s8,0(sp)
    11b0:	bf11                	j	10c4 <vprintf+0x42>
        s = va_arg(ap, char*);
    11b2:	008b8993          	addi	s3,s7,8
    11b6:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    11ba:	02090163          	beqz	s2,11dc <vprintf+0x15a>
        while(*s != 0){
    11be:	00094583          	lbu	a1,0(s2)
    11c2:	c9a5                	beqz	a1,1232 <vprintf+0x1b0>
          putc(fd, *s);
    11c4:	8556                	mv	a0,s5
    11c6:	00000097          	auipc	ra,0x0
    11ca:	e00080e7          	jalr	-512(ra) # fc6 <putc>
          s++;
    11ce:	0905                	addi	s2,s2,1
        while(*s != 0){
    11d0:	00094583          	lbu	a1,0(s2)
    11d4:	f9e5                	bnez	a1,11c4 <vprintf+0x142>
        s = va_arg(ap, char*);
    11d6:	8bce                	mv	s7,s3
      state = 0;
    11d8:	4981                	li	s3,0
    11da:	b5ed                	j	10c4 <vprintf+0x42>
          s = "(null)";
    11dc:	00000917          	auipc	s2,0x0
    11e0:	38c90913          	addi	s2,s2,908 # 1568 <malloc+0x230>
        while(*s != 0){
    11e4:	02800593          	li	a1,40
    11e8:	bff1                	j	11c4 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
    11ea:	008b8913          	addi	s2,s7,8
    11ee:	000bc583          	lbu	a1,0(s7)
    11f2:	8556                	mv	a0,s5
    11f4:	00000097          	auipc	ra,0x0
    11f8:	dd2080e7          	jalr	-558(ra) # fc6 <putc>
    11fc:	8bca                	mv	s7,s2
      state = 0;
    11fe:	4981                	li	s3,0
    1200:	b5d1                	j	10c4 <vprintf+0x42>
        putc(fd, c);
    1202:	02500593          	li	a1,37
    1206:	8556                	mv	a0,s5
    1208:	00000097          	auipc	ra,0x0
    120c:	dbe080e7          	jalr	-578(ra) # fc6 <putc>
      state = 0;
    1210:	4981                	li	s3,0
    1212:	bd4d                	j	10c4 <vprintf+0x42>
        putc(fd, '%');
    1214:	02500593          	li	a1,37
    1218:	8556                	mv	a0,s5
    121a:	00000097          	auipc	ra,0x0
    121e:	dac080e7          	jalr	-596(ra) # fc6 <putc>
        putc(fd, c);
    1222:	85ca                	mv	a1,s2
    1224:	8556                	mv	a0,s5
    1226:	00000097          	auipc	ra,0x0
    122a:	da0080e7          	jalr	-608(ra) # fc6 <putc>
      state = 0;
    122e:	4981                	li	s3,0
    1230:	bd51                	j	10c4 <vprintf+0x42>
        s = va_arg(ap, char*);
    1232:	8bce                	mv	s7,s3
      state = 0;
    1234:	4981                	li	s3,0
    1236:	b579                	j	10c4 <vprintf+0x42>
    1238:	74e2                	ld	s1,56(sp)
    123a:	79a2                	ld	s3,40(sp)
    123c:	7a02                	ld	s4,32(sp)
    123e:	6ae2                	ld	s5,24(sp)
    1240:	6b42                	ld	s6,16(sp)
    1242:	6ba2                	ld	s7,8(sp)
    }
  }
}
    1244:	60a6                	ld	ra,72(sp)
    1246:	6406                	ld	s0,64(sp)
    1248:	7942                	ld	s2,48(sp)
    124a:	6161                	addi	sp,sp,80
    124c:	8082                	ret

000000000000124e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    124e:	715d                	addi	sp,sp,-80
    1250:	ec06                	sd	ra,24(sp)
    1252:	e822                	sd	s0,16(sp)
    1254:	1000                	addi	s0,sp,32
    1256:	e010                	sd	a2,0(s0)
    1258:	e414                	sd	a3,8(s0)
    125a:	e818                	sd	a4,16(s0)
    125c:	ec1c                	sd	a5,24(s0)
    125e:	03043023          	sd	a6,32(s0)
    1262:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1266:	8622                	mv	a2,s0
    1268:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    126c:	00000097          	auipc	ra,0x0
    1270:	e16080e7          	jalr	-490(ra) # 1082 <vprintf>
}
    1274:	60e2                	ld	ra,24(sp)
    1276:	6442                	ld	s0,16(sp)
    1278:	6161                	addi	sp,sp,80
    127a:	8082                	ret

000000000000127c <printf>:

void
printf(const char *fmt, ...)
{
    127c:	711d                	addi	sp,sp,-96
    127e:	ec06                	sd	ra,24(sp)
    1280:	e822                	sd	s0,16(sp)
    1282:	1000                	addi	s0,sp,32
    1284:	e40c                	sd	a1,8(s0)
    1286:	e810                	sd	a2,16(s0)
    1288:	ec14                	sd	a3,24(s0)
    128a:	f018                	sd	a4,32(s0)
    128c:	f41c                	sd	a5,40(s0)
    128e:	03043823          	sd	a6,48(s0)
    1292:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1296:	00840613          	addi	a2,s0,8
    129a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    129e:	85aa                	mv	a1,a0
    12a0:	4505                	li	a0,1
    12a2:	00000097          	auipc	ra,0x0
    12a6:	de0080e7          	jalr	-544(ra) # 1082 <vprintf>
}
    12aa:	60e2                	ld	ra,24(sp)
    12ac:	6442                	ld	s0,16(sp)
    12ae:	6125                	addi	sp,sp,96
    12b0:	8082                	ret

00000000000012b2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    12b2:	1141                	addi	sp,sp,-16
    12b4:	e406                	sd	ra,8(sp)
    12b6:	e022                	sd	s0,0(sp)
    12b8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    12ba:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    12be:	00001797          	auipc	a5,0x1
    12c2:	d527b783          	ld	a5,-686(a5) # 2010 <freep>
    12c6:	a02d                	j	12f0 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    12c8:	4618                	lw	a4,8(a2)
    12ca:	9f2d                	addw	a4,a4,a1
    12cc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    12d0:	6398                	ld	a4,0(a5)
    12d2:	6310                	ld	a2,0(a4)
    12d4:	a83d                	j	1312 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    12d6:	ff852703          	lw	a4,-8(a0)
    12da:	9f31                	addw	a4,a4,a2
    12dc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    12de:	ff053683          	ld	a3,-16(a0)
    12e2:	a091                	j	1326 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    12e4:	6398                	ld	a4,0(a5)
    12e6:	00e7e463          	bltu	a5,a4,12ee <free+0x3c>
    12ea:	00e6ea63          	bltu	a3,a4,12fe <free+0x4c>
{
    12ee:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    12f0:	fed7fae3          	bgeu	a5,a3,12e4 <free+0x32>
    12f4:	6398                	ld	a4,0(a5)
    12f6:	00e6e463          	bltu	a3,a4,12fe <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    12fa:	fee7eae3          	bltu	a5,a4,12ee <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
    12fe:	ff852583          	lw	a1,-8(a0)
    1302:	6390                	ld	a2,0(a5)
    1304:	02059813          	slli	a6,a1,0x20
    1308:	01c85713          	srli	a4,a6,0x1c
    130c:	9736                	add	a4,a4,a3
    130e:	fae60de3          	beq	a2,a4,12c8 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
    1312:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1316:	4790                	lw	a2,8(a5)
    1318:	02061593          	slli	a1,a2,0x20
    131c:	01c5d713          	srli	a4,a1,0x1c
    1320:	973e                	add	a4,a4,a5
    1322:	fae68ae3          	beq	a3,a4,12d6 <free+0x24>
    p->s.ptr = bp->s.ptr;
    1326:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1328:	00001717          	auipc	a4,0x1
    132c:	cef73423          	sd	a5,-792(a4) # 2010 <freep>
}
    1330:	60a2                	ld	ra,8(sp)
    1332:	6402                	ld	s0,0(sp)
    1334:	0141                	addi	sp,sp,16
    1336:	8082                	ret

0000000000001338 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1338:	7139                	addi	sp,sp,-64
    133a:	fc06                	sd	ra,56(sp)
    133c:	f822                	sd	s0,48(sp)
    133e:	f04a                	sd	s2,32(sp)
    1340:	ec4e                	sd	s3,24(sp)
    1342:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1344:	02051993          	slli	s3,a0,0x20
    1348:	0209d993          	srli	s3,s3,0x20
    134c:	09bd                	addi	s3,s3,15
    134e:	0049d993          	srli	s3,s3,0x4
    1352:	2985                	addiw	s3,s3,1
    1354:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    1356:	00001517          	auipc	a0,0x1
    135a:	cba53503          	ld	a0,-838(a0) # 2010 <freep>
    135e:	c905                	beqz	a0,138e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1360:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1362:	4798                	lw	a4,8(a5)
    1364:	09377a63          	bgeu	a4,s3,13f8 <malloc+0xc0>
    1368:	f426                	sd	s1,40(sp)
    136a:	e852                	sd	s4,16(sp)
    136c:	e456                	sd	s5,8(sp)
    136e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1370:	8a4e                	mv	s4,s3
    1372:	6705                	lui	a4,0x1
    1374:	00e9f363          	bgeu	s3,a4,137a <malloc+0x42>
    1378:	6a05                	lui	s4,0x1
    137a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    137e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1382:	00001497          	auipc	s1,0x1
    1386:	c8e48493          	addi	s1,s1,-882 # 2010 <freep>
  if(p == (char*)-1)
    138a:	5afd                	li	s5,-1
    138c:	a089                	j	13ce <malloc+0x96>
    138e:	f426                	sd	s1,40(sp)
    1390:	e852                	sd	s4,16(sp)
    1392:	e456                	sd	s5,8(sp)
    1394:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    1396:	00001797          	auipc	a5,0x1
    139a:	d0278793          	addi	a5,a5,-766 # 2098 <base>
    139e:	00001717          	auipc	a4,0x1
    13a2:	c6f73923          	sd	a5,-910(a4) # 2010 <freep>
    13a6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    13a8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    13ac:	b7d1                	j	1370 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    13ae:	6398                	ld	a4,0(a5)
    13b0:	e118                	sd	a4,0(a0)
    13b2:	a8b9                	j	1410 <malloc+0xd8>
  hp->s.size = nu;
    13b4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    13b8:	0541                	addi	a0,a0,16
    13ba:	00000097          	auipc	ra,0x0
    13be:	ef8080e7          	jalr	-264(ra) # 12b2 <free>
  return freep;
    13c2:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    13c4:	c135                	beqz	a0,1428 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    13c6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    13c8:	4798                	lw	a4,8(a5)
    13ca:	03277363          	bgeu	a4,s2,13f0 <malloc+0xb8>
    if(p == freep)
    13ce:	6098                	ld	a4,0(s1)
    13d0:	853e                	mv	a0,a5
    13d2:	fef71ae3          	bne	a4,a5,13c6 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    13d6:	8552                	mv	a0,s4
    13d8:	00000097          	auipc	ra,0x0
    13dc:	bae080e7          	jalr	-1106(ra) # f86 <sbrk>
  if(p == (char*)-1)
    13e0:	fd551ae3          	bne	a0,s5,13b4 <malloc+0x7c>
        return 0;
    13e4:	4501                	li	a0,0
    13e6:	74a2                	ld	s1,40(sp)
    13e8:	6a42                	ld	s4,16(sp)
    13ea:	6aa2                	ld	s5,8(sp)
    13ec:	6b02                	ld	s6,0(sp)
    13ee:	a03d                	j	141c <malloc+0xe4>
    13f0:	74a2                	ld	s1,40(sp)
    13f2:	6a42                	ld	s4,16(sp)
    13f4:	6aa2                	ld	s5,8(sp)
    13f6:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    13f8:	fae90be3          	beq	s2,a4,13ae <malloc+0x76>
        p->s.size -= nunits;
    13fc:	4137073b          	subw	a4,a4,s3
    1400:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1402:	02071693          	slli	a3,a4,0x20
    1406:	01c6d713          	srli	a4,a3,0x1c
    140a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    140c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1410:	00001717          	auipc	a4,0x1
    1414:	c0a73023          	sd	a0,-1024(a4) # 2010 <freep>
      return (void*)(p + 1);
    1418:	01078513          	addi	a0,a5,16
  }
}
    141c:	70e2                	ld	ra,56(sp)
    141e:	7442                	ld	s0,48(sp)
    1420:	7902                	ld	s2,32(sp)
    1422:	69e2                	ld	s3,24(sp)
    1424:	6121                	addi	sp,sp,64
    1426:	8082                	ret
    1428:	74a2                	ld	s1,40(sp)
    142a:	6a42                	ld	s4,16(sp)
    142c:	6aa2                	ld	s5,8(sp)
    142e:	6b02                	ld	s6,0(sp)
    1430:	b7f5                	j	141c <malloc+0xe4>
