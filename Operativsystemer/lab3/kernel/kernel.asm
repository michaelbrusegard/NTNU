
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	c4010113          	addi	sp,sp,-960 # 80008c40 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	078000ef          	jal	8000008e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e406                	sd	ra,8(sp)
    80000020:	e022                	sd	s0,0(sp)
    80000022:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
    uint64 x;
    asm volatile("csrr %0, mhartid" : "=r"(x));
    80000024:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000028:	2781                	sext.w	a5,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037961b          	slliw	a2,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	963a                	add	a2,a2,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f46b7          	lui	a3,0xf4
    80000040:	24068693          	addi	a3,a3,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	9736                	add	a4,a4,a3
    80000046:	e218                	sd	a4,0(a2)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00279713          	slli	a4,a5,0x2
    8000004c:	973e                	add	a4,a4,a5
    8000004e:	070e                	slli	a4,a4,0x3
    80000050:	00009797          	auipc	a5,0x9
    80000054:	ab078793          	addi	a5,a5,-1360 # 80008b00 <timer_scratch>
    80000058:	97ba                	add	a5,a5,a4
  scratch[3] = CLINT_MTIMECMP(id);
    8000005a:	ef90                	sd	a2,24(a5)
  scratch[4] = interval;
    8000005c:	f394                	sd	a3,32(a5)
}

static inline void
w_mscratch(uint64 x)
{
    asm volatile("csrw mscratch, %0" : : "r"(x));
    8000005e:	34079073          	csrw	mscratch,a5
    asm volatile("csrw mtvec, %0" : : "r"(x));
    80000062:	00006797          	auipc	a5,0x6
    80000066:	44e78793          	addi	a5,a5,1102 # 800064b0 <timervec>
    8000006a:	30579073          	csrw	mtvec,a5
    asm volatile("csrr %0, mstatus" : "=r"(x));
    8000006e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000072:	0087e793          	ori	a5,a5,8
    asm volatile("csrw mstatus, %0" : : "r"(x));
    80000076:	30079073          	csrw	mstatus,a5
    asm volatile("csrr %0, mie" : "=r"(x));
    8000007a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000007e:	0807e793          	ori	a5,a5,128
    asm volatile("csrw mie, %0" : : "r"(x));
    80000082:	30479073          	csrw	mie,a5
}
    80000086:	60a2                	ld	ra,8(sp)
    80000088:	6402                	ld	s0,0(sp)
    8000008a:	0141                	addi	sp,sp,16
    8000008c:	8082                	ret

000000008000008e <start>:
{
    8000008e:	1141                	addi	sp,sp,-16
    80000090:	e406                	sd	ra,8(sp)
    80000092:	e022                	sd	s0,0(sp)
    80000094:	0800                	addi	s0,sp,16
    asm volatile("csrr %0, mstatus" : "=r"(x));
    80000096:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000009a:	7779                	lui	a4,0xffffe
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fb9c88f>
    800000a0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a2:	6705                	lui	a4,0x1
    800000a4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a8:	8fd9                	or	a5,a5,a4
    asm volatile("csrw mstatus, %0" : : "r"(x));
    800000aa:	30079073          	csrw	mstatus,a5
    asm volatile("csrw mepc, %0" : : "r"(x));
    800000ae:	00001797          	auipc	a5,0x1
    800000b2:	fca78793          	addi	a5,a5,-54 # 80001078 <main>
    800000b6:	34179073          	csrw	mepc,a5
    asm volatile("csrw satp, %0" : : "r"(x));
    800000ba:	4781                	li	a5,0
    800000bc:	18079073          	csrw	satp,a5
    asm volatile("csrw medeleg, %0" : : "r"(x));
    800000c0:	67c1                	lui	a5,0x10
    800000c2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000c4:	30279073          	csrw	medeleg,a5
    asm volatile("csrw mideleg, %0" : : "r"(x));
    800000c8:	30379073          	csrw	mideleg,a5
    asm volatile("csrr %0, sie" : "=r"(x));
    800000cc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000d0:	2227e793          	ori	a5,a5,546
    asm volatile("csrw sie, %0" : : "r"(x));
    800000d4:	10479073          	csrw	sie,a5
    asm volatile("csrw pmpaddr0, %0" : : "r"(x));
    800000d8:	57fd                	li	a5,-1
    800000da:	83a9                	srli	a5,a5,0xa
    800000dc:	3b079073          	csrw	pmpaddr0,a5
    asm volatile("csrw pmpcfg0, %0" : : "r"(x));
    800000e0:	47bd                	li	a5,15
    800000e2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e6:	00000097          	auipc	ra,0x0
    800000ea:	f36080e7          	jalr	-202(ra) # 8000001c <timerinit>
    asm volatile("csrr %0, mhartid" : "=r"(x));
    800000ee:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f2:	2781                	sext.w	a5,a5
}

static inline void
w_tp(uint64 x)
{
    asm volatile("mv tp, %0" : : "r"(x));
    800000f4:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f6:	30200073          	mret
}
    800000fa:	60a2                	ld	ra,8(sp)
    800000fc:	6402                	ld	s0,0(sp)
    800000fe:	0141                	addi	sp,sp,16
    80000100:	8082                	ret

0000000080000102 <consolewrite>:

//
// user write()s to the console go here.
//
int consolewrite(int user_src, uint64 src, int n)
{
    80000102:	711d                	addi	sp,sp,-96
    80000104:	ec86                	sd	ra,88(sp)
    80000106:	e8a2                	sd	s0,80(sp)
    80000108:	e0ca                	sd	s2,64(sp)
    8000010a:	1080                	addi	s0,sp,96
    int i;

    for (i = 0; i < n; i++)
    8000010c:	04c05c63          	blez	a2,80000164 <consolewrite+0x62>
    80000110:	e4a6                	sd	s1,72(sp)
    80000112:	fc4e                	sd	s3,56(sp)
    80000114:	f852                	sd	s4,48(sp)
    80000116:	f456                	sd	s5,40(sp)
    80000118:	f05a                	sd	s6,32(sp)
    8000011a:	ec5e                	sd	s7,24(sp)
    8000011c:	8a2a                	mv	s4,a0
    8000011e:	84ae                	mv	s1,a1
    80000120:	89b2                	mv	s3,a2
    80000122:	4901                	li	s2,0
    {
        char c;
        if (either_copyin(&c, user_src, src + i, 1) == -1)
    80000124:	faf40b93          	addi	s7,s0,-81
    80000128:	4b05                	li	s6,1
    8000012a:	5afd                	li	s5,-1
    8000012c:	86da                	mv	a3,s6
    8000012e:	8626                	mv	a2,s1
    80000130:	85d2                	mv	a1,s4
    80000132:	855e                	mv	a0,s7
    80000134:	00002097          	auipc	ra,0x2
    80000138:	7f6080e7          	jalr	2038(ra) # 8000292a <either_copyin>
    8000013c:	03550663          	beq	a0,s5,80000168 <consolewrite+0x66>
            break;
        uartputc(c);
    80000140:	faf44503          	lbu	a0,-81(s0)
    80000144:	00000097          	auipc	ra,0x0
    80000148:	7ec080e7          	jalr	2028(ra) # 80000930 <uartputc>
    for (i = 0; i < n; i++)
    8000014c:	2905                	addiw	s2,s2,1
    8000014e:	0485                	addi	s1,s1,1
    80000150:	fd299ee3          	bne	s3,s2,8000012c <consolewrite+0x2a>
    80000154:	894e                	mv	s2,s3
    80000156:	64a6                	ld	s1,72(sp)
    80000158:	79e2                	ld	s3,56(sp)
    8000015a:	7a42                	ld	s4,48(sp)
    8000015c:	7aa2                	ld	s5,40(sp)
    8000015e:	7b02                	ld	s6,32(sp)
    80000160:	6be2                	ld	s7,24(sp)
    80000162:	a809                	j	80000174 <consolewrite+0x72>
    80000164:	4901                	li	s2,0
    80000166:	a039                	j	80000174 <consolewrite+0x72>
    80000168:	64a6                	ld	s1,72(sp)
    8000016a:	79e2                	ld	s3,56(sp)
    8000016c:	7a42                	ld	s4,48(sp)
    8000016e:	7aa2                	ld	s5,40(sp)
    80000170:	7b02                	ld	s6,32(sp)
    80000172:	6be2                	ld	s7,24(sp)
    }

    return i;
}
    80000174:	854a                	mv	a0,s2
    80000176:	60e6                	ld	ra,88(sp)
    80000178:	6446                	ld	s0,80(sp)
    8000017a:	6906                	ld	s2,64(sp)
    8000017c:	6125                	addi	sp,sp,96
    8000017e:	8082                	ret

0000000080000180 <consoleread>:
// copy (up to) a whole input line to dst.
// user_dist indicates whether dst is a user
// or kernel address.
//
int consoleread(int user_dst, uint64 dst, int n)
{
    80000180:	711d                	addi	sp,sp,-96
    80000182:	ec86                	sd	ra,88(sp)
    80000184:	e8a2                	sd	s0,80(sp)
    80000186:	e4a6                	sd	s1,72(sp)
    80000188:	e0ca                	sd	s2,64(sp)
    8000018a:	fc4e                	sd	s3,56(sp)
    8000018c:	f852                	sd	s4,48(sp)
    8000018e:	f456                	sd	s5,40(sp)
    80000190:	f05a                	sd	s6,32(sp)
    80000192:	1080                	addi	s0,sp,96
    80000194:	8aaa                	mv	s5,a0
    80000196:	8a2e                	mv	s4,a1
    80000198:	89b2                	mv	s3,a2
    uint target;
    int c;
    char cbuf;

    target = n;
    8000019a:	8b32                	mv	s6,a2
    acquire(&cons.lock);
    8000019c:	00011517          	auipc	a0,0x11
    800001a0:	aa450513          	addi	a0,a0,-1372 # 80010c40 <cons>
    800001a4:	00001097          	auipc	ra,0x1
    800001a8:	c22080e7          	jalr	-990(ra) # 80000dc6 <acquire>
    while (n > 0)
    {
        // wait until interrupt handler has put some
        // input into cons.buffer.
        while (cons.r == cons.w)
    800001ac:	00011497          	auipc	s1,0x11
    800001b0:	a9448493          	addi	s1,s1,-1388 # 80010c40 <cons>
            if (killed(myproc()))
            {
                release(&cons.lock);
                return -1;
            }
            sleep(&cons.r, &cons.lock);
    800001b4:	00011917          	auipc	s2,0x11
    800001b8:	b2490913          	addi	s2,s2,-1244 # 80010cd8 <cons+0x98>
    while (n > 0)
    800001bc:	0d305563          	blez	s3,80000286 <consoleread+0x106>
        while (cons.r == cons.w)
    800001c0:	0984a783          	lw	a5,152(s1)
    800001c4:	09c4a703          	lw	a4,156(s1)
    800001c8:	0af71a63          	bne	a4,a5,8000027c <consoleread+0xfc>
            if (killed(myproc()))
    800001cc:	00002097          	auipc	ra,0x2
    800001d0:	b52080e7          	jalr	-1198(ra) # 80001d1e <myproc>
    800001d4:	00002097          	auipc	ra,0x2
    800001d8:	5a6080e7          	jalr	1446(ra) # 8000277a <killed>
    800001dc:	e52d                	bnez	a0,80000246 <consoleread+0xc6>
            sleep(&cons.r, &cons.lock);
    800001de:	85a6                	mv	a1,s1
    800001e0:	854a                	mv	a0,s2
    800001e2:	00002097          	auipc	ra,0x2
    800001e6:	2f0080e7          	jalr	752(ra) # 800024d2 <sleep>
        while (cons.r == cons.w)
    800001ea:	0984a783          	lw	a5,152(s1)
    800001ee:	09c4a703          	lw	a4,156(s1)
    800001f2:	fcf70de3          	beq	a4,a5,800001cc <consoleread+0x4c>
    800001f6:	ec5e                	sd	s7,24(sp)
        }

        c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001f8:	00011717          	auipc	a4,0x11
    800001fc:	a4870713          	addi	a4,a4,-1464 # 80010c40 <cons>
    80000200:	0017869b          	addiw	a3,a5,1
    80000204:	08d72c23          	sw	a3,152(a4)
    80000208:	07f7f693          	andi	a3,a5,127
    8000020c:	9736                	add	a4,a4,a3
    8000020e:	01874703          	lbu	a4,24(a4)
    80000212:	00070b9b          	sext.w	s7,a4

        if (c == C('D'))
    80000216:	4691                	li	a3,4
    80000218:	04db8a63          	beq	s7,a3,8000026c <consoleread+0xec>
            }
            break;
        }

        // copy the input byte to the user-space buffer.
        cbuf = c;
    8000021c:	fae407a3          	sb	a4,-81(s0)
        if (either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000220:	4685                	li	a3,1
    80000222:	faf40613          	addi	a2,s0,-81
    80000226:	85d2                	mv	a1,s4
    80000228:	8556                	mv	a0,s5
    8000022a:	00002097          	auipc	ra,0x2
    8000022e:	6aa080e7          	jalr	1706(ra) # 800028d4 <either_copyout>
    80000232:	57fd                	li	a5,-1
    80000234:	04f50863          	beq	a0,a5,80000284 <consoleread+0x104>
            break;

        dst++;
    80000238:	0a05                	addi	s4,s4,1
        --n;
    8000023a:	39fd                	addiw	s3,s3,-1

        if (c == '\n')
    8000023c:	47a9                	li	a5,10
    8000023e:	04fb8f63          	beq	s7,a5,8000029c <consoleread+0x11c>
    80000242:	6be2                	ld	s7,24(sp)
    80000244:	bfa5                	j	800001bc <consoleread+0x3c>
                release(&cons.lock);
    80000246:	00011517          	auipc	a0,0x11
    8000024a:	9fa50513          	addi	a0,a0,-1542 # 80010c40 <cons>
    8000024e:	00001097          	auipc	ra,0x1
    80000252:	c28080e7          	jalr	-984(ra) # 80000e76 <release>
                return -1;
    80000256:	557d                	li	a0,-1
        }
    }
    release(&cons.lock);

    return target - n;
}
    80000258:	60e6                	ld	ra,88(sp)
    8000025a:	6446                	ld	s0,80(sp)
    8000025c:	64a6                	ld	s1,72(sp)
    8000025e:	6906                	ld	s2,64(sp)
    80000260:	79e2                	ld	s3,56(sp)
    80000262:	7a42                	ld	s4,48(sp)
    80000264:	7aa2                	ld	s5,40(sp)
    80000266:	7b02                	ld	s6,32(sp)
    80000268:	6125                	addi	sp,sp,96
    8000026a:	8082                	ret
            if (n < target)
    8000026c:	0169fa63          	bgeu	s3,s6,80000280 <consoleread+0x100>
                cons.r--;
    80000270:	00011717          	auipc	a4,0x11
    80000274:	a6f72423          	sw	a5,-1432(a4) # 80010cd8 <cons+0x98>
    80000278:	6be2                	ld	s7,24(sp)
    8000027a:	a031                	j	80000286 <consoleread+0x106>
    8000027c:	ec5e                	sd	s7,24(sp)
    8000027e:	bfad                	j	800001f8 <consoleread+0x78>
    80000280:	6be2                	ld	s7,24(sp)
    80000282:	a011                	j	80000286 <consoleread+0x106>
    80000284:	6be2                	ld	s7,24(sp)
    release(&cons.lock);
    80000286:	00011517          	auipc	a0,0x11
    8000028a:	9ba50513          	addi	a0,a0,-1606 # 80010c40 <cons>
    8000028e:	00001097          	auipc	ra,0x1
    80000292:	be8080e7          	jalr	-1048(ra) # 80000e76 <release>
    return target - n;
    80000296:	413b053b          	subw	a0,s6,s3
    8000029a:	bf7d                	j	80000258 <consoleread+0xd8>
    8000029c:	6be2                	ld	s7,24(sp)
    8000029e:	b7e5                	j	80000286 <consoleread+0x106>

00000000800002a0 <consputc>:
{
    800002a0:	1141                	addi	sp,sp,-16
    800002a2:	e406                	sd	ra,8(sp)
    800002a4:	e022                	sd	s0,0(sp)
    800002a6:	0800                	addi	s0,sp,16
    if (c == BACKSPACE)
    800002a8:	10000793          	li	a5,256
    800002ac:	00f50a63          	beq	a0,a5,800002c0 <consputc+0x20>
        uartputc_sync(c);
    800002b0:	00000097          	auipc	ra,0x0
    800002b4:	5a2080e7          	jalr	1442(ra) # 80000852 <uartputc_sync>
}
    800002b8:	60a2                	ld	ra,8(sp)
    800002ba:	6402                	ld	s0,0(sp)
    800002bc:	0141                	addi	sp,sp,16
    800002be:	8082                	ret
        uartputc_sync('\b');
    800002c0:	4521                	li	a0,8
    800002c2:	00000097          	auipc	ra,0x0
    800002c6:	590080e7          	jalr	1424(ra) # 80000852 <uartputc_sync>
        uartputc_sync(' ');
    800002ca:	02000513          	li	a0,32
    800002ce:	00000097          	auipc	ra,0x0
    800002d2:	584080e7          	jalr	1412(ra) # 80000852 <uartputc_sync>
        uartputc_sync('\b');
    800002d6:	4521                	li	a0,8
    800002d8:	00000097          	auipc	ra,0x0
    800002dc:	57a080e7          	jalr	1402(ra) # 80000852 <uartputc_sync>
    800002e0:	bfe1                	j	800002b8 <consputc+0x18>

00000000800002e2 <consoleintr>:
// uartintr() calls this for input character.
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void consoleintr(int c)
{
    800002e2:	7179                	addi	sp,sp,-48
    800002e4:	f406                	sd	ra,40(sp)
    800002e6:	f022                	sd	s0,32(sp)
    800002e8:	ec26                	sd	s1,24(sp)
    800002ea:	1800                	addi	s0,sp,48
    800002ec:	84aa                	mv	s1,a0
    acquire(&cons.lock);
    800002ee:	00011517          	auipc	a0,0x11
    800002f2:	95250513          	addi	a0,a0,-1710 # 80010c40 <cons>
    800002f6:	00001097          	auipc	ra,0x1
    800002fa:	ad0080e7          	jalr	-1328(ra) # 80000dc6 <acquire>

    switch (c)
    800002fe:	47d5                	li	a5,21
    80000300:	0af48463          	beq	s1,a5,800003a8 <consoleintr+0xc6>
    80000304:	0297c963          	blt	a5,s1,80000336 <consoleintr+0x54>
    80000308:	47a1                	li	a5,8
    8000030a:	10f48063          	beq	s1,a5,8000040a <consoleintr+0x128>
    8000030e:	47c1                	li	a5,16
    80000310:	12f49363          	bne	s1,a5,80000436 <consoleintr+0x154>
    {
    case C('P'): // Print process list.
        procdump();
    80000314:	00002097          	auipc	ra,0x2
    80000318:	66c080e7          	jalr	1644(ra) # 80002980 <procdump>
            }
        }
        break;
    }

    release(&cons.lock);
    8000031c:	00011517          	auipc	a0,0x11
    80000320:	92450513          	addi	a0,a0,-1756 # 80010c40 <cons>
    80000324:	00001097          	auipc	ra,0x1
    80000328:	b52080e7          	jalr	-1198(ra) # 80000e76 <release>
}
    8000032c:	70a2                	ld	ra,40(sp)
    8000032e:	7402                	ld	s0,32(sp)
    80000330:	64e2                	ld	s1,24(sp)
    80000332:	6145                	addi	sp,sp,48
    80000334:	8082                	ret
    switch (c)
    80000336:	07f00793          	li	a5,127
    8000033a:	0cf48863          	beq	s1,a5,8000040a <consoleintr+0x128>
        if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE)
    8000033e:	00011717          	auipc	a4,0x11
    80000342:	90270713          	addi	a4,a4,-1790 # 80010c40 <cons>
    80000346:	0a072783          	lw	a5,160(a4)
    8000034a:	09872703          	lw	a4,152(a4)
    8000034e:	9f99                	subw	a5,a5,a4
    80000350:	07f00713          	li	a4,127
    80000354:	fcf764e3          	bltu	a4,a5,8000031c <consoleintr+0x3a>
            c = (c == '\r') ? '\n' : c;
    80000358:	47b5                	li	a5,13
    8000035a:	0ef48163          	beq	s1,a5,8000043c <consoleintr+0x15a>
            consputc(c);
    8000035e:	8526                	mv	a0,s1
    80000360:	00000097          	auipc	ra,0x0
    80000364:	f40080e7          	jalr	-192(ra) # 800002a0 <consputc>
            cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000368:	00011797          	auipc	a5,0x11
    8000036c:	8d878793          	addi	a5,a5,-1832 # 80010c40 <cons>
    80000370:	0a07a683          	lw	a3,160(a5)
    80000374:	0016871b          	addiw	a4,a3,1
    80000378:	863a                	mv	a2,a4
    8000037a:	0ae7a023          	sw	a4,160(a5)
    8000037e:	07f6f693          	andi	a3,a3,127
    80000382:	97b6                	add	a5,a5,a3
    80000384:	00978c23          	sb	s1,24(a5)
            if (c == '\n' || c == C('D') || cons.e - cons.r == INPUT_BUF_SIZE)
    80000388:	47a9                	li	a5,10
    8000038a:	0cf48f63          	beq	s1,a5,80000468 <consoleintr+0x186>
    8000038e:	4791                	li	a5,4
    80000390:	0cf48c63          	beq	s1,a5,80000468 <consoleintr+0x186>
    80000394:	00011797          	auipc	a5,0x11
    80000398:	9447a783          	lw	a5,-1724(a5) # 80010cd8 <cons+0x98>
    8000039c:	9f1d                	subw	a4,a4,a5
    8000039e:	08000793          	li	a5,128
    800003a2:	f6f71de3          	bne	a4,a5,8000031c <consoleintr+0x3a>
    800003a6:	a0c9                	j	80000468 <consoleintr+0x186>
    800003a8:	e84a                	sd	s2,16(sp)
    800003aa:	e44e                	sd	s3,8(sp)
        while (cons.e != cons.w &&
    800003ac:	00011717          	auipc	a4,0x11
    800003b0:	89470713          	addi	a4,a4,-1900 # 80010c40 <cons>
    800003b4:	0a072783          	lw	a5,160(a4)
    800003b8:	09c72703          	lw	a4,156(a4)
               cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n')
    800003bc:	00011497          	auipc	s1,0x11
    800003c0:	88448493          	addi	s1,s1,-1916 # 80010c40 <cons>
        while (cons.e != cons.w &&
    800003c4:	4929                	li	s2,10
            consputc(BACKSPACE);
    800003c6:	10000993          	li	s3,256
        while (cons.e != cons.w &&
    800003ca:	02f70a63          	beq	a4,a5,800003fe <consoleintr+0x11c>
               cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n')
    800003ce:	37fd                	addiw	a5,a5,-1
    800003d0:	07f7f713          	andi	a4,a5,127
    800003d4:	9726                	add	a4,a4,s1
        while (cons.e != cons.w &&
    800003d6:	01874703          	lbu	a4,24(a4)
    800003da:	03270563          	beq	a4,s2,80000404 <consoleintr+0x122>
            cons.e--;
    800003de:	0af4a023          	sw	a5,160(s1)
            consputc(BACKSPACE);
    800003e2:	854e                	mv	a0,s3
    800003e4:	00000097          	auipc	ra,0x0
    800003e8:	ebc080e7          	jalr	-324(ra) # 800002a0 <consputc>
        while (cons.e != cons.w &&
    800003ec:	0a04a783          	lw	a5,160(s1)
    800003f0:	09c4a703          	lw	a4,156(s1)
    800003f4:	fcf71de3          	bne	a4,a5,800003ce <consoleintr+0xec>
    800003f8:	6942                	ld	s2,16(sp)
    800003fa:	69a2                	ld	s3,8(sp)
    800003fc:	b705                	j	8000031c <consoleintr+0x3a>
    800003fe:	6942                	ld	s2,16(sp)
    80000400:	69a2                	ld	s3,8(sp)
    80000402:	bf29                	j	8000031c <consoleintr+0x3a>
    80000404:	6942                	ld	s2,16(sp)
    80000406:	69a2                	ld	s3,8(sp)
    80000408:	bf11                	j	8000031c <consoleintr+0x3a>
        if (cons.e != cons.w)
    8000040a:	00011717          	auipc	a4,0x11
    8000040e:	83670713          	addi	a4,a4,-1994 # 80010c40 <cons>
    80000412:	0a072783          	lw	a5,160(a4)
    80000416:	09c72703          	lw	a4,156(a4)
    8000041a:	f0f701e3          	beq	a4,a5,8000031c <consoleintr+0x3a>
            cons.e--;
    8000041e:	37fd                	addiw	a5,a5,-1
    80000420:	00011717          	auipc	a4,0x11
    80000424:	8cf72023          	sw	a5,-1856(a4) # 80010ce0 <cons+0xa0>
            consputc(BACKSPACE);
    80000428:	10000513          	li	a0,256
    8000042c:	00000097          	auipc	ra,0x0
    80000430:	e74080e7          	jalr	-396(ra) # 800002a0 <consputc>
    80000434:	b5e5                	j	8000031c <consoleintr+0x3a>
        if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE)
    80000436:	ee0483e3          	beqz	s1,8000031c <consoleintr+0x3a>
    8000043a:	b711                	j	8000033e <consoleintr+0x5c>
            consputc(c);
    8000043c:	4529                	li	a0,10
    8000043e:	00000097          	auipc	ra,0x0
    80000442:	e62080e7          	jalr	-414(ra) # 800002a0 <consputc>
            cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000446:	00010797          	auipc	a5,0x10
    8000044a:	7fa78793          	addi	a5,a5,2042 # 80010c40 <cons>
    8000044e:	0a07a703          	lw	a4,160(a5)
    80000452:	0017069b          	addiw	a3,a4,1
    80000456:	8636                	mv	a2,a3
    80000458:	0ad7a023          	sw	a3,160(a5)
    8000045c:	07f77713          	andi	a4,a4,127
    80000460:	97ba                	add	a5,a5,a4
    80000462:	4729                	li	a4,10
    80000464:	00e78c23          	sb	a4,24(a5)
                cons.w = cons.e;
    80000468:	00011797          	auipc	a5,0x11
    8000046c:	86c7aa23          	sw	a2,-1932(a5) # 80010cdc <cons+0x9c>
                wakeup(&cons.r);
    80000470:	00011517          	auipc	a0,0x11
    80000474:	86850513          	addi	a0,a0,-1944 # 80010cd8 <cons+0x98>
    80000478:	00002097          	auipc	ra,0x2
    8000047c:	0be080e7          	jalr	190(ra) # 80002536 <wakeup>
    80000480:	bd71                	j	8000031c <consoleintr+0x3a>

0000000080000482 <consoleinit>:

void consoleinit(void)
{
    80000482:	1141                	addi	sp,sp,-16
    80000484:	e406                	sd	ra,8(sp)
    80000486:	e022                	sd	s0,0(sp)
    80000488:	0800                	addi	s0,sp,16
    initlock(&cons.lock, "cons");
    8000048a:	00008597          	auipc	a1,0x8
    8000048e:	b7658593          	addi	a1,a1,-1162 # 80008000 <etext>
    80000492:	00010517          	auipc	a0,0x10
    80000496:	7ae50513          	addi	a0,a0,1966 # 80010c40 <cons>
    8000049a:	00001097          	auipc	ra,0x1
    8000049e:	898080e7          	jalr	-1896(ra) # 80000d32 <initlock>

    uartinit();
    800004a2:	00000097          	auipc	ra,0x0
    800004a6:	356080e7          	jalr	854(ra) # 800007f8 <uartinit>

    // connect read and write system calls
    // to consoleread and consolewrite.
    devsw[CONSOLE].read = consoleread;
    800004aa:	00461797          	auipc	a5,0x461
    800004ae:	92e78793          	addi	a5,a5,-1746 # 80460dd8 <devsw>
    800004b2:	00000717          	auipc	a4,0x0
    800004b6:	cce70713          	addi	a4,a4,-818 # 80000180 <consoleread>
    800004ba:	eb98                	sd	a4,16(a5)
    devsw[CONSOLE].write = consolewrite;
    800004bc:	00000717          	auipc	a4,0x0
    800004c0:	c4670713          	addi	a4,a4,-954 # 80000102 <consolewrite>
    800004c4:	ef98                	sd	a4,24(a5)
}
    800004c6:	60a2                	ld	ra,8(sp)
    800004c8:	6402                	ld	s0,0(sp)
    800004ca:	0141                	addi	sp,sp,16
    800004cc:	8082                	ret

00000000800004ce <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004ce:	7179                	addi	sp,sp,-48
    800004d0:	f406                	sd	ra,40(sp)
    800004d2:	f022                	sd	s0,32(sp)
    800004d4:	ec26                	sd	s1,24(sp)
    800004d6:	e84a                	sd	s2,16(sp)
    800004d8:	1800                	addi	s0,sp,48
    char buf[16];
    int i;
    uint x;

    if (sign && (sign = xx < 0))
    800004da:	c219                	beqz	a2,800004e0 <printint+0x12>
    800004dc:	06054e63          	bltz	a0,80000558 <printint+0x8a>
        x = -xx;
    else
        x = xx;
    800004e0:	4e01                	li	t3,0

    i = 0;
    800004e2:	fd040313          	addi	t1,s0,-48
        x = xx;
    800004e6:	869a                	mv	a3,t1
    i = 0;
    800004e8:	4781                	li	a5,0
    do
    {
        buf[i++] = digits[x % base];
    800004ea:	00008817          	auipc	a6,0x8
    800004ee:	40680813          	addi	a6,a6,1030 # 800088f0 <digits>
    800004f2:	88be                	mv	a7,a5
    800004f4:	0017861b          	addiw	a2,a5,1
    800004f8:	87b2                	mv	a5,a2
    800004fa:	02b5773b          	remuw	a4,a0,a1
    800004fe:	1702                	slli	a4,a4,0x20
    80000500:	9301                	srli	a4,a4,0x20
    80000502:	9742                	add	a4,a4,a6
    80000504:	00074703          	lbu	a4,0(a4)
    80000508:	00e68023          	sb	a4,0(a3)
    } while ((x /= base) != 0);
    8000050c:	872a                	mv	a4,a0
    8000050e:	02b5553b          	divuw	a0,a0,a1
    80000512:	0685                	addi	a3,a3,1
    80000514:	fcb77fe3          	bgeu	a4,a1,800004f2 <printint+0x24>

    if (sign)
    80000518:	000e0c63          	beqz	t3,80000530 <printint+0x62>
        buf[i++] = '-';
    8000051c:	fe060793          	addi	a5,a2,-32
    80000520:	00878633          	add	a2,a5,s0
    80000524:	02d00793          	li	a5,45
    80000528:	fef60823          	sb	a5,-16(a2)
    8000052c:	0028879b          	addiw	a5,a7,2

    while (--i >= 0)
    80000530:	fff7891b          	addiw	s2,a5,-1
    80000534:	006784b3          	add	s1,a5,t1
        consputc(buf[i]);
    80000538:	fff4c503          	lbu	a0,-1(s1)
    8000053c:	00000097          	auipc	ra,0x0
    80000540:	d64080e7          	jalr	-668(ra) # 800002a0 <consputc>
    while (--i >= 0)
    80000544:	397d                	addiw	s2,s2,-1
    80000546:	14fd                	addi	s1,s1,-1
    80000548:	fe0958e3          	bgez	s2,80000538 <printint+0x6a>
}
    8000054c:	70a2                	ld	ra,40(sp)
    8000054e:	7402                	ld	s0,32(sp)
    80000550:	64e2                	ld	s1,24(sp)
    80000552:	6942                	ld	s2,16(sp)
    80000554:	6145                	addi	sp,sp,48
    80000556:	8082                	ret
        x = -xx;
    80000558:	40a0053b          	negw	a0,a0
    if (sign && (sign = xx < 0))
    8000055c:	4e05                	li	t3,1
        x = -xx;
    8000055e:	b751                	j	800004e2 <printint+0x14>

0000000080000560 <panic>:
    if (locking)
        release(&pr.lock);
}

void panic(char *s, ...)
{
    80000560:	711d                	addi	sp,sp,-96
    80000562:	ec06                	sd	ra,24(sp)
    80000564:	e822                	sd	s0,16(sp)
    80000566:	e426                	sd	s1,8(sp)
    80000568:	1000                	addi	s0,sp,32
    8000056a:	84aa                	mv	s1,a0
    8000056c:	e40c                	sd	a1,8(s0)
    8000056e:	e810                	sd	a2,16(s0)
    80000570:	ec14                	sd	a3,24(s0)
    80000572:	f018                	sd	a4,32(s0)
    80000574:	f41c                	sd	a5,40(s0)
    80000576:	03043823          	sd	a6,48(s0)
    8000057a:	03143c23          	sd	a7,56(s0)
    pr.locking = 0;
    8000057e:	00010797          	auipc	a5,0x10
    80000582:	7807a123          	sw	zero,1922(a5) # 80010d00 <pr+0x18>
    printf("panic: ");
    80000586:	00008517          	auipc	a0,0x8
    8000058a:	a8250513          	addi	a0,a0,-1406 # 80008008 <etext+0x8>
    8000058e:	00000097          	auipc	ra,0x0
    80000592:	02e080e7          	jalr	46(ra) # 800005bc <printf>
    printf(s);
    80000596:	8526                	mv	a0,s1
    80000598:	00000097          	auipc	ra,0x0
    8000059c:	024080e7          	jalr	36(ra) # 800005bc <printf>
    printf("\n");
    800005a0:	00008517          	auipc	a0,0x8
    800005a4:	a7050513          	addi	a0,a0,-1424 # 80008010 <etext+0x10>
    800005a8:	00000097          	auipc	ra,0x0
    800005ac:	014080e7          	jalr	20(ra) # 800005bc <printf>
    panicked = 1; // freeze uart output from other CPUs
    800005b0:	4785                	li	a5,1
    800005b2:	00008717          	auipc	a4,0x8
    800005b6:	4ef72f23          	sw	a5,1278(a4) # 80008ab0 <panicked>
    for (;;)
    800005ba:	a001                	j	800005ba <panic+0x5a>

00000000800005bc <printf>:
{
    800005bc:	7131                	addi	sp,sp,-192
    800005be:	fc86                	sd	ra,120(sp)
    800005c0:	f8a2                	sd	s0,112(sp)
    800005c2:	e8d2                	sd	s4,80(sp)
    800005c4:	ec6e                	sd	s11,24(sp)
    800005c6:	0100                	addi	s0,sp,128
    800005c8:	8a2a                	mv	s4,a0
    800005ca:	e40c                	sd	a1,8(s0)
    800005cc:	e810                	sd	a2,16(s0)
    800005ce:	ec14                	sd	a3,24(s0)
    800005d0:	f018                	sd	a4,32(s0)
    800005d2:	f41c                	sd	a5,40(s0)
    800005d4:	03043823          	sd	a6,48(s0)
    800005d8:	03143c23          	sd	a7,56(s0)
    locking = pr.locking;
    800005dc:	00010d97          	auipc	s11,0x10
    800005e0:	724dad83          	lw	s11,1828(s11) # 80010d00 <pr+0x18>
    if (locking)
    800005e4:	040d9463          	bnez	s11,8000062c <printf+0x70>
    if (fmt == 0)
    800005e8:	040a0b63          	beqz	s4,8000063e <printf+0x82>
    va_start(ap, fmt);
    800005ec:	00840793          	addi	a5,s0,8
    800005f0:	f8f43423          	sd	a5,-120(s0)
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
    800005f4:	000a4503          	lbu	a0,0(s4)
    800005f8:	18050c63          	beqz	a0,80000790 <printf+0x1d4>
    800005fc:	f4a6                	sd	s1,104(sp)
    800005fe:	f0ca                	sd	s2,96(sp)
    80000600:	ecce                	sd	s3,88(sp)
    80000602:	e4d6                	sd	s5,72(sp)
    80000604:	e0da                	sd	s6,64(sp)
    80000606:	fc5e                	sd	s7,56(sp)
    80000608:	f862                	sd	s8,48(sp)
    8000060a:	f466                	sd	s9,40(sp)
    8000060c:	f06a                	sd	s10,32(sp)
    8000060e:	4981                	li	s3,0
        if (c != '%')
    80000610:	02500b13          	li	s6,37
        switch (c)
    80000614:	07000b93          	li	s7,112
    consputc('x');
    80000618:	07800c93          	li	s9,120
    8000061c:	4d41                	li	s10,16
        consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000061e:	00008a97          	auipc	s5,0x8
    80000622:	2d2a8a93          	addi	s5,s5,722 # 800088f0 <digits>
        switch (c)
    80000626:	07300c13          	li	s8,115
    8000062a:	a0b9                	j	80000678 <printf+0xbc>
        acquire(&pr.lock);
    8000062c:	00010517          	auipc	a0,0x10
    80000630:	6bc50513          	addi	a0,a0,1724 # 80010ce8 <pr>
    80000634:	00000097          	auipc	ra,0x0
    80000638:	792080e7          	jalr	1938(ra) # 80000dc6 <acquire>
    8000063c:	b775                	j	800005e8 <printf+0x2c>
    8000063e:	f4a6                	sd	s1,104(sp)
    80000640:	f0ca                	sd	s2,96(sp)
    80000642:	ecce                	sd	s3,88(sp)
    80000644:	e4d6                	sd	s5,72(sp)
    80000646:	e0da                	sd	s6,64(sp)
    80000648:	fc5e                	sd	s7,56(sp)
    8000064a:	f862                	sd	s8,48(sp)
    8000064c:	f466                	sd	s9,40(sp)
    8000064e:	f06a                	sd	s10,32(sp)
        panic("null fmt");
    80000650:	00008517          	auipc	a0,0x8
    80000654:	9d050513          	addi	a0,a0,-1584 # 80008020 <etext+0x20>
    80000658:	00000097          	auipc	ra,0x0
    8000065c:	f08080e7          	jalr	-248(ra) # 80000560 <panic>
            consputc(c);
    80000660:	00000097          	auipc	ra,0x0
    80000664:	c40080e7          	jalr	-960(ra) # 800002a0 <consputc>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
    80000668:	0019879b          	addiw	a5,s3,1
    8000066c:	89be                	mv	s3,a5
    8000066e:	97d2                	add	a5,a5,s4
    80000670:	0007c503          	lbu	a0,0(a5)
    80000674:	10050563          	beqz	a0,8000077e <printf+0x1c2>
        if (c != '%')
    80000678:	ff6514e3          	bne	a0,s6,80000660 <printf+0xa4>
        c = fmt[++i] & 0xff;
    8000067c:	0019879b          	addiw	a5,s3,1
    80000680:	89be                	mv	s3,a5
    80000682:	97d2                	add	a5,a5,s4
    80000684:	0007c783          	lbu	a5,0(a5)
    80000688:	0007849b          	sext.w	s1,a5
        if (c == 0)
    8000068c:	10078a63          	beqz	a5,800007a0 <printf+0x1e4>
        switch (c)
    80000690:	05778a63          	beq	a5,s7,800006e4 <printf+0x128>
    80000694:	02fbf463          	bgeu	s7,a5,800006bc <printf+0x100>
    80000698:	09878763          	beq	a5,s8,80000726 <printf+0x16a>
    8000069c:	0d979663          	bne	a5,s9,80000768 <printf+0x1ac>
            printint(va_arg(ap, int), 16, 1);
    800006a0:	f8843783          	ld	a5,-120(s0)
    800006a4:	00878713          	addi	a4,a5,8
    800006a8:	f8e43423          	sd	a4,-120(s0)
    800006ac:	4605                	li	a2,1
    800006ae:	85ea                	mv	a1,s10
    800006b0:	4388                	lw	a0,0(a5)
    800006b2:	00000097          	auipc	ra,0x0
    800006b6:	e1c080e7          	jalr	-484(ra) # 800004ce <printint>
            break;
    800006ba:	b77d                	j	80000668 <printf+0xac>
        switch (c)
    800006bc:	0b678063          	beq	a5,s6,8000075c <printf+0x1a0>
    800006c0:	06400713          	li	a4,100
    800006c4:	0ae79263          	bne	a5,a4,80000768 <printf+0x1ac>
            printint(va_arg(ap, int), 10, 1);
    800006c8:	f8843783          	ld	a5,-120(s0)
    800006cc:	00878713          	addi	a4,a5,8
    800006d0:	f8e43423          	sd	a4,-120(s0)
    800006d4:	4605                	li	a2,1
    800006d6:	45a9                	li	a1,10
    800006d8:	4388                	lw	a0,0(a5)
    800006da:	00000097          	auipc	ra,0x0
    800006de:	df4080e7          	jalr	-524(ra) # 800004ce <printint>
            break;
    800006e2:	b759                	j	80000668 <printf+0xac>
            printptr(va_arg(ap, uint64));
    800006e4:	f8843783          	ld	a5,-120(s0)
    800006e8:	00878713          	addi	a4,a5,8
    800006ec:	f8e43423          	sd	a4,-120(s0)
    800006f0:	0007b903          	ld	s2,0(a5)
    consputc('0');
    800006f4:	03000513          	li	a0,48
    800006f8:	00000097          	auipc	ra,0x0
    800006fc:	ba8080e7          	jalr	-1112(ra) # 800002a0 <consputc>
    consputc('x');
    80000700:	8566                	mv	a0,s9
    80000702:	00000097          	auipc	ra,0x0
    80000706:	b9e080e7          	jalr	-1122(ra) # 800002a0 <consputc>
    8000070a:	84ea                	mv	s1,s10
        consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000070c:	03c95793          	srli	a5,s2,0x3c
    80000710:	97d6                	add	a5,a5,s5
    80000712:	0007c503          	lbu	a0,0(a5)
    80000716:	00000097          	auipc	ra,0x0
    8000071a:	b8a080e7          	jalr	-1142(ra) # 800002a0 <consputc>
    for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000071e:	0912                	slli	s2,s2,0x4
    80000720:	34fd                	addiw	s1,s1,-1
    80000722:	f4ed                	bnez	s1,8000070c <printf+0x150>
    80000724:	b791                	j	80000668 <printf+0xac>
            if ((s = va_arg(ap, char *)) == 0)
    80000726:	f8843783          	ld	a5,-120(s0)
    8000072a:	00878713          	addi	a4,a5,8
    8000072e:	f8e43423          	sd	a4,-120(s0)
    80000732:	6384                	ld	s1,0(a5)
    80000734:	cc89                	beqz	s1,8000074e <printf+0x192>
            for (; *s; s++)
    80000736:	0004c503          	lbu	a0,0(s1)
    8000073a:	d51d                	beqz	a0,80000668 <printf+0xac>
                consputc(*s);
    8000073c:	00000097          	auipc	ra,0x0
    80000740:	b64080e7          	jalr	-1180(ra) # 800002a0 <consputc>
            for (; *s; s++)
    80000744:	0485                	addi	s1,s1,1
    80000746:	0004c503          	lbu	a0,0(s1)
    8000074a:	f96d                	bnez	a0,8000073c <printf+0x180>
    8000074c:	bf31                	j	80000668 <printf+0xac>
                s = "(null)";
    8000074e:	00008497          	auipc	s1,0x8
    80000752:	8ca48493          	addi	s1,s1,-1846 # 80008018 <etext+0x18>
            for (; *s; s++)
    80000756:	02800513          	li	a0,40
    8000075a:	b7cd                	j	8000073c <printf+0x180>
            consputc('%');
    8000075c:	855a                	mv	a0,s6
    8000075e:	00000097          	auipc	ra,0x0
    80000762:	b42080e7          	jalr	-1214(ra) # 800002a0 <consputc>
            break;
    80000766:	b709                	j	80000668 <printf+0xac>
            consputc('%');
    80000768:	855a                	mv	a0,s6
    8000076a:	00000097          	auipc	ra,0x0
    8000076e:	b36080e7          	jalr	-1226(ra) # 800002a0 <consputc>
            consputc(c);
    80000772:	8526                	mv	a0,s1
    80000774:	00000097          	auipc	ra,0x0
    80000778:	b2c080e7          	jalr	-1236(ra) # 800002a0 <consputc>
            break;
    8000077c:	b5f5                	j	80000668 <printf+0xac>
    8000077e:	74a6                	ld	s1,104(sp)
    80000780:	7906                	ld	s2,96(sp)
    80000782:	69e6                	ld	s3,88(sp)
    80000784:	6aa6                	ld	s5,72(sp)
    80000786:	6b06                	ld	s6,64(sp)
    80000788:	7be2                	ld	s7,56(sp)
    8000078a:	7c42                	ld	s8,48(sp)
    8000078c:	7ca2                	ld	s9,40(sp)
    8000078e:	7d02                	ld	s10,32(sp)
    if (locking)
    80000790:	020d9263          	bnez	s11,800007b4 <printf+0x1f8>
}
    80000794:	70e6                	ld	ra,120(sp)
    80000796:	7446                	ld	s0,112(sp)
    80000798:	6a46                	ld	s4,80(sp)
    8000079a:	6de2                	ld	s11,24(sp)
    8000079c:	6129                	addi	sp,sp,192
    8000079e:	8082                	ret
    800007a0:	74a6                	ld	s1,104(sp)
    800007a2:	7906                	ld	s2,96(sp)
    800007a4:	69e6                	ld	s3,88(sp)
    800007a6:	6aa6                	ld	s5,72(sp)
    800007a8:	6b06                	ld	s6,64(sp)
    800007aa:	7be2                	ld	s7,56(sp)
    800007ac:	7c42                	ld	s8,48(sp)
    800007ae:	7ca2                	ld	s9,40(sp)
    800007b0:	7d02                	ld	s10,32(sp)
    800007b2:	bff9                	j	80000790 <printf+0x1d4>
        release(&pr.lock);
    800007b4:	00010517          	auipc	a0,0x10
    800007b8:	53450513          	addi	a0,a0,1332 # 80010ce8 <pr>
    800007bc:	00000097          	auipc	ra,0x0
    800007c0:	6ba080e7          	jalr	1722(ra) # 80000e76 <release>
}
    800007c4:	bfc1                	j	80000794 <printf+0x1d8>

00000000800007c6 <printfinit>:
        ;
}

void printfinit(void)
{
    800007c6:	1101                	addi	sp,sp,-32
    800007c8:	ec06                	sd	ra,24(sp)
    800007ca:	e822                	sd	s0,16(sp)
    800007cc:	e426                	sd	s1,8(sp)
    800007ce:	1000                	addi	s0,sp,32
    initlock(&pr.lock, "pr");
    800007d0:	00010497          	auipc	s1,0x10
    800007d4:	51848493          	addi	s1,s1,1304 # 80010ce8 <pr>
    800007d8:	00008597          	auipc	a1,0x8
    800007dc:	85858593          	addi	a1,a1,-1960 # 80008030 <etext+0x30>
    800007e0:	8526                	mv	a0,s1
    800007e2:	00000097          	auipc	ra,0x0
    800007e6:	550080e7          	jalr	1360(ra) # 80000d32 <initlock>
    pr.locking = 1;
    800007ea:	4785                	li	a5,1
    800007ec:	cc9c                	sw	a5,24(s1)
}
    800007ee:	60e2                	ld	ra,24(sp)
    800007f0:	6442                	ld	s0,16(sp)
    800007f2:	64a2                	ld	s1,8(sp)
    800007f4:	6105                	addi	sp,sp,32
    800007f6:	8082                	ret

00000000800007f8 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007f8:	1141                	addi	sp,sp,-16
    800007fa:	e406                	sd	ra,8(sp)
    800007fc:	e022                	sd	s0,0(sp)
    800007fe:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80000800:	100007b7          	lui	a5,0x10000
    80000804:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80000808:	10000737          	lui	a4,0x10000
    8000080c:	f8000693          	li	a3,-128
    80000810:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000814:	468d                	li	a3,3
    80000816:	10000637          	lui	a2,0x10000
    8000081a:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000081e:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000822:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000826:	8732                	mv	a4,a2
    80000828:	461d                	li	a2,7
    8000082a:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000082e:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000832:	00008597          	auipc	a1,0x8
    80000836:	80658593          	addi	a1,a1,-2042 # 80008038 <etext+0x38>
    8000083a:	00010517          	auipc	a0,0x10
    8000083e:	4ce50513          	addi	a0,a0,1230 # 80010d08 <uart_tx_lock>
    80000842:	00000097          	auipc	ra,0x0
    80000846:	4f0080e7          	jalr	1264(ra) # 80000d32 <initlock>
}
    8000084a:	60a2                	ld	ra,8(sp)
    8000084c:	6402                	ld	s0,0(sp)
    8000084e:	0141                	addi	sp,sp,16
    80000850:	8082                	ret

0000000080000852 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000852:	1101                	addi	sp,sp,-32
    80000854:	ec06                	sd	ra,24(sp)
    80000856:	e822                	sd	s0,16(sp)
    80000858:	e426                	sd	s1,8(sp)
    8000085a:	1000                	addi	s0,sp,32
    8000085c:	84aa                	mv	s1,a0
  push_off();
    8000085e:	00000097          	auipc	ra,0x0
    80000862:	51c080e7          	jalr	1308(ra) # 80000d7a <push_off>

  if(panicked){
    80000866:	00008797          	auipc	a5,0x8
    8000086a:	24a7a783          	lw	a5,586(a5) # 80008ab0 <panicked>
    8000086e:	eb85                	bnez	a5,8000089e <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000870:	10000737          	lui	a4,0x10000
    80000874:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000876:	00074783          	lbu	a5,0(a4)
    8000087a:	0207f793          	andi	a5,a5,32
    8000087e:	dfe5                	beqz	a5,80000876 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000880:	0ff4f513          	zext.b	a0,s1
    80000884:	100007b7          	lui	a5,0x10000
    80000888:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000088c:	00000097          	auipc	ra,0x0
    80000890:	58e080e7          	jalr	1422(ra) # 80000e1a <pop_off>
}
    80000894:	60e2                	ld	ra,24(sp)
    80000896:	6442                	ld	s0,16(sp)
    80000898:	64a2                	ld	s1,8(sp)
    8000089a:	6105                	addi	sp,sp,32
    8000089c:	8082                	ret
    for(;;)
    8000089e:	a001                	j	8000089e <uartputc_sync+0x4c>

00000000800008a0 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800008a0:	00008797          	auipc	a5,0x8
    800008a4:	2187b783          	ld	a5,536(a5) # 80008ab8 <uart_tx_r>
    800008a8:	00008717          	auipc	a4,0x8
    800008ac:	21873703          	ld	a4,536(a4) # 80008ac0 <uart_tx_w>
    800008b0:	06f70f63          	beq	a4,a5,8000092e <uartstart+0x8e>
{
    800008b4:	7139                	addi	sp,sp,-64
    800008b6:	fc06                	sd	ra,56(sp)
    800008b8:	f822                	sd	s0,48(sp)
    800008ba:	f426                	sd	s1,40(sp)
    800008bc:	f04a                	sd	s2,32(sp)
    800008be:	ec4e                	sd	s3,24(sp)
    800008c0:	e852                	sd	s4,16(sp)
    800008c2:	e456                	sd	s5,8(sp)
    800008c4:	e05a                	sd	s6,0(sp)
    800008c6:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008c8:	10000937          	lui	s2,0x10000
    800008cc:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008ce:	00010a97          	auipc	s5,0x10
    800008d2:	43aa8a93          	addi	s5,s5,1082 # 80010d08 <uart_tx_lock>
    uart_tx_r += 1;
    800008d6:	00008497          	auipc	s1,0x8
    800008da:	1e248493          	addi	s1,s1,482 # 80008ab8 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008de:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008e2:	00008997          	auipc	s3,0x8
    800008e6:	1de98993          	addi	s3,s3,478 # 80008ac0 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008ea:	00094703          	lbu	a4,0(s2)
    800008ee:	02077713          	andi	a4,a4,32
    800008f2:	c705                	beqz	a4,8000091a <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008f4:	01f7f713          	andi	a4,a5,31
    800008f8:	9756                	add	a4,a4,s5
    800008fa:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800008fe:	0785                	addi	a5,a5,1
    80000900:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    80000902:	8526                	mv	a0,s1
    80000904:	00002097          	auipc	ra,0x2
    80000908:	c32080e7          	jalr	-974(ra) # 80002536 <wakeup>
    WriteReg(THR, c);
    8000090c:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80000910:	609c                	ld	a5,0(s1)
    80000912:	0009b703          	ld	a4,0(s3)
    80000916:	fcf71ae3          	bne	a4,a5,800008ea <uartstart+0x4a>
  }
}
    8000091a:	70e2                	ld	ra,56(sp)
    8000091c:	7442                	ld	s0,48(sp)
    8000091e:	74a2                	ld	s1,40(sp)
    80000920:	7902                	ld	s2,32(sp)
    80000922:	69e2                	ld	s3,24(sp)
    80000924:	6a42                	ld	s4,16(sp)
    80000926:	6aa2                	ld	s5,8(sp)
    80000928:	6b02                	ld	s6,0(sp)
    8000092a:	6121                	addi	sp,sp,64
    8000092c:	8082                	ret
    8000092e:	8082                	ret

0000000080000930 <uartputc>:
{
    80000930:	7179                	addi	sp,sp,-48
    80000932:	f406                	sd	ra,40(sp)
    80000934:	f022                	sd	s0,32(sp)
    80000936:	ec26                	sd	s1,24(sp)
    80000938:	e84a                	sd	s2,16(sp)
    8000093a:	e44e                	sd	s3,8(sp)
    8000093c:	e052                	sd	s4,0(sp)
    8000093e:	1800                	addi	s0,sp,48
    80000940:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80000942:	00010517          	auipc	a0,0x10
    80000946:	3c650513          	addi	a0,a0,966 # 80010d08 <uart_tx_lock>
    8000094a:	00000097          	auipc	ra,0x0
    8000094e:	47c080e7          	jalr	1148(ra) # 80000dc6 <acquire>
  if(panicked){
    80000952:	00008797          	auipc	a5,0x8
    80000956:	15e7a783          	lw	a5,350(a5) # 80008ab0 <panicked>
    8000095a:	e7c9                	bnez	a5,800009e4 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000095c:	00008717          	auipc	a4,0x8
    80000960:	16473703          	ld	a4,356(a4) # 80008ac0 <uart_tx_w>
    80000964:	00008797          	auipc	a5,0x8
    80000968:	1547b783          	ld	a5,340(a5) # 80008ab8 <uart_tx_r>
    8000096c:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000970:	00010997          	auipc	s3,0x10
    80000974:	39898993          	addi	s3,s3,920 # 80010d08 <uart_tx_lock>
    80000978:	00008497          	auipc	s1,0x8
    8000097c:	14048493          	addi	s1,s1,320 # 80008ab8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000980:	00008917          	auipc	s2,0x8
    80000984:	14090913          	addi	s2,s2,320 # 80008ac0 <uart_tx_w>
    80000988:	00e79f63          	bne	a5,a4,800009a6 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000098c:	85ce                	mv	a1,s3
    8000098e:	8526                	mv	a0,s1
    80000990:	00002097          	auipc	ra,0x2
    80000994:	b42080e7          	jalr	-1214(ra) # 800024d2 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000998:	00093703          	ld	a4,0(s2)
    8000099c:	609c                	ld	a5,0(s1)
    8000099e:	02078793          	addi	a5,a5,32
    800009a2:	fee785e3          	beq	a5,a4,8000098c <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800009a6:	00010497          	auipc	s1,0x10
    800009aa:	36248493          	addi	s1,s1,866 # 80010d08 <uart_tx_lock>
    800009ae:	01f77793          	andi	a5,a4,31
    800009b2:	97a6                	add	a5,a5,s1
    800009b4:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009b8:	0705                	addi	a4,a4,1
    800009ba:	00008797          	auipc	a5,0x8
    800009be:	10e7b323          	sd	a4,262(a5) # 80008ac0 <uart_tx_w>
  uartstart();
    800009c2:	00000097          	auipc	ra,0x0
    800009c6:	ede080e7          	jalr	-290(ra) # 800008a0 <uartstart>
  release(&uart_tx_lock);
    800009ca:	8526                	mv	a0,s1
    800009cc:	00000097          	auipc	ra,0x0
    800009d0:	4aa080e7          	jalr	1194(ra) # 80000e76 <release>
}
    800009d4:	70a2                	ld	ra,40(sp)
    800009d6:	7402                	ld	s0,32(sp)
    800009d8:	64e2                	ld	s1,24(sp)
    800009da:	6942                	ld	s2,16(sp)
    800009dc:	69a2                	ld	s3,8(sp)
    800009de:	6a02                	ld	s4,0(sp)
    800009e0:	6145                	addi	sp,sp,48
    800009e2:	8082                	ret
    for(;;)
    800009e4:	a001                	j	800009e4 <uartputc+0xb4>

00000000800009e6 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009e6:	1141                	addi	sp,sp,-16
    800009e8:	e406                	sd	ra,8(sp)
    800009ea:	e022                	sd	s0,0(sp)
    800009ec:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009ee:	100007b7          	lui	a5,0x10000
    800009f2:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009f6:	8b85                	andi	a5,a5,1
    800009f8:	cb89                	beqz	a5,80000a0a <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800009fa:	100007b7          	lui	a5,0x10000
    800009fe:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80000a02:	60a2                	ld	ra,8(sp)
    80000a04:	6402                	ld	s0,0(sp)
    80000a06:	0141                	addi	sp,sp,16
    80000a08:	8082                	ret
    return -1;
    80000a0a:	557d                	li	a0,-1
    80000a0c:	bfdd                	j	80000a02 <uartgetc+0x1c>

0000000080000a0e <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000a0e:	1101                	addi	sp,sp,-32
    80000a10:	ec06                	sd	ra,24(sp)
    80000a12:	e822                	sd	s0,16(sp)
    80000a14:	e426                	sd	s1,8(sp)
    80000a16:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a18:	54fd                	li	s1,-1
    int c = uartgetc();
    80000a1a:	00000097          	auipc	ra,0x0
    80000a1e:	fcc080e7          	jalr	-52(ra) # 800009e6 <uartgetc>
    if(c == -1)
    80000a22:	00950763          	beq	a0,s1,80000a30 <uartintr+0x22>
      break;
    consoleintr(c);
    80000a26:	00000097          	auipc	ra,0x0
    80000a2a:	8bc080e7          	jalr	-1860(ra) # 800002e2 <consoleintr>
  while(1){
    80000a2e:	b7f5                	j	80000a1a <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a30:	00010497          	auipc	s1,0x10
    80000a34:	2d848493          	addi	s1,s1,728 # 80010d08 <uart_tx_lock>
    80000a38:	8526                	mv	a0,s1
    80000a3a:	00000097          	auipc	ra,0x0
    80000a3e:	38c080e7          	jalr	908(ra) # 80000dc6 <acquire>
  uartstart();
    80000a42:	00000097          	auipc	ra,0x0
    80000a46:	e5e080e7          	jalr	-418(ra) # 800008a0 <uartstart>
  release(&uart_tx_lock);
    80000a4a:	8526                	mv	a0,s1
    80000a4c:	00000097          	auipc	ra,0x0
    80000a50:	42a080e7          	jalr	1066(ra) # 80000e76 <release>
}
    80000a54:	60e2                	ld	ra,24(sp)
    80000a56:	6442                	ld	s0,16(sp)
    80000a58:	64a2                	ld	s1,8(sp)
    80000a5a:	6105                	addi	sp,sp,32
    80000a5c:	8082                	ret

0000000080000a5e <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a5e:	1101                	addi	sp,sp,-32
    80000a60:	ec06                	sd	ra,24(sp)
    80000a62:	e822                	sd	s0,16(sp)
    80000a64:	e426                	sd	s1,8(sp)
    80000a66:	1000                	addi	s0,sp,32
    struct run *r;

    if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a68:	03451793          	slli	a5,a0,0x34
    80000a6c:	ebc1                	bnez	a5,80000afc <kfree+0x9e>
    80000a6e:	84aa                	mv	s1,a0
    80000a70:	00461797          	auipc	a5,0x461
    80000a74:	50078793          	addi	a5,a5,1280 # 80461f70 <end>
    80000a78:	08f56263          	bltu	a0,a5,80000afc <kfree+0x9e>
    80000a7c:	47c5                	li	a5,17
    80000a7e:	07ee                	slli	a5,a5,0x1b
    80000a80:	06f57e63          	bgeu	a0,a5,80000afc <kfree+0x9e>
      panic("kfree");

    acquire(&kmem.lock);
    80000a84:	00010517          	auipc	a0,0x10
    80000a88:	2bc50513          	addi	a0,a0,700 # 80010d40 <kmem>
    80000a8c:	00000097          	auipc	ra,0x0
    80000a90:	33a080e7          	jalr	826(ra) # 80000dc6 <acquire>
    if(kmem.ref[(uint64)pa/PGSIZE] <= 0)
    80000a94:	00c4d793          	srli	a5,s1,0xc
    80000a98:	00478693          	addi	a3,a5,4
    80000a9c:	068e                	slli	a3,a3,0x3
    80000a9e:	00010717          	auipc	a4,0x10
    80000aa2:	2a270713          	addi	a4,a4,674 # 80010d40 <kmem>
    80000aa6:	9736                	add	a4,a4,a3
    80000aa8:	6318                	ld	a4,0(a4)
    80000aaa:	c32d                	beqz	a4,80000b0c <kfree+0xae>
      panic("kfree: negative reference count");
    if(--kmem.ref[(uint64)pa/PGSIZE] > 0) {
    80000aac:	177d                	addi	a4,a4,-1
    80000aae:	0791                	addi	a5,a5,4
    80000ab0:	078e                	slli	a5,a5,0x3
    80000ab2:	00010697          	auipc	a3,0x10
    80000ab6:	28e68693          	addi	a3,a3,654 # 80010d40 <kmem>
    80000aba:	97b6                	add	a5,a5,a3
    80000abc:	e398                	sd	a4,0(a5)
    80000abe:	ef39                	bnez	a4,80000b1c <kfree+0xbe>
      release(&kmem.lock);
      return;
    }
    memset(pa, 1, PGSIZE);
    80000ac0:	6605                	lui	a2,0x1
    80000ac2:	4585                	li	a1,1
    80000ac4:	8526                	mv	a0,s1
    80000ac6:	00000097          	auipc	ra,0x0
    80000aca:	3f8080e7          	jalr	1016(ra) # 80000ebe <memset>

    r = (struct run*)pa;
    r->next = kmem.freelist;
    80000ace:	00010517          	auipc	a0,0x10
    80000ad2:	27250513          	addi	a0,a0,626 # 80010d40 <kmem>
    80000ad6:	6d1c                	ld	a5,24(a0)
    80000ad8:	e09c                	sd	a5,0(s1)
    kmem.freelist = r;
    80000ada:	ed04                	sd	s1,24(a0)
    FREE_PAGES++;
    80000adc:	00008717          	auipc	a4,0x8
    80000ae0:	fec70713          	addi	a4,a4,-20 # 80008ac8 <FREE_PAGES>
    80000ae4:	631c                	ld	a5,0(a4)
    80000ae6:	0785                	addi	a5,a5,1
    80000ae8:	e31c                	sd	a5,0(a4)
    release(&kmem.lock);
    80000aea:	00000097          	auipc	ra,0x0
    80000aee:	38c080e7          	jalr	908(ra) # 80000e76 <release>
}
    80000af2:	60e2                	ld	ra,24(sp)
    80000af4:	6442                	ld	s0,16(sp)
    80000af6:	64a2                	ld	s1,8(sp)
    80000af8:	6105                	addi	sp,sp,32
    80000afa:	8082                	ret
      panic("kfree");
    80000afc:	00007517          	auipc	a0,0x7
    80000b00:	54450513          	addi	a0,a0,1348 # 80008040 <etext+0x40>
    80000b04:	00000097          	auipc	ra,0x0
    80000b08:	a5c080e7          	jalr	-1444(ra) # 80000560 <panic>
      panic("kfree: negative reference count");
    80000b0c:	00007517          	auipc	a0,0x7
    80000b10:	53c50513          	addi	a0,a0,1340 # 80008048 <etext+0x48>
    80000b14:	00000097          	auipc	ra,0x0
    80000b18:	a4c080e7          	jalr	-1460(ra) # 80000560 <panic>
      release(&kmem.lock);
    80000b1c:	8536                	mv	a0,a3
    80000b1e:	00000097          	auipc	ra,0x0
    80000b22:	358080e7          	jalr	856(ra) # 80000e76 <release>
      return;
    80000b26:	b7f1                	j	80000af2 <kfree+0x94>

0000000080000b28 <freerange>:
{
    80000b28:	7139                	addi	sp,sp,-64
    80000b2a:	fc06                	sd	ra,56(sp)
    80000b2c:	f822                	sd	s0,48(sp)
    80000b2e:	f426                	sd	s1,40(sp)
    80000b30:	0080                	addi	s0,sp,64
    p = (char *)PGROUNDUP((uint64)pa_start);
    80000b32:	6785                	lui	a5,0x1
    80000b34:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000b38:	953a                	add	a0,a0,a4
    80000b3a:	777d                	lui	a4,0xfffff
    80000b3c:	00e574b3          	and	s1,a0,a4
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000b40:	97a6                	add	a5,a5,s1
    80000b42:	04f5e563          	bltu	a1,a5,80000b8c <freerange+0x64>
    80000b46:	f04a                	sd	s2,32(sp)
    80000b48:	ec4e                	sd	s3,24(sp)
    80000b4a:	e852                	sd	s4,16(sp)
    80000b4c:	e456                	sd	s5,8(sp)
    80000b4e:	e05a                	sd	s6,0(sp)
    80000b50:	892e                	mv	s2,a1
        kmem.ref[(uint64)p/PGSIZE] = 1;
    80000b52:	00010b17          	auipc	s6,0x10
    80000b56:	1eeb0b13          	addi	s6,s6,494 # 80010d40 <kmem>
    80000b5a:	4a85                	li	s5,1
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000b5c:	6a05                	lui	s4,0x1
    80000b5e:	6989                	lui	s3,0x2
        kmem.ref[(uint64)p/PGSIZE] = 1;
    80000b60:	00c4d793          	srli	a5,s1,0xc
    80000b64:	0791                	addi	a5,a5,4
    80000b66:	078e                	slli	a5,a5,0x3
    80000b68:	97da                	add	a5,a5,s6
    80000b6a:	0157b023          	sd	s5,0(a5)
        kfree(p);
    80000b6e:	8526                	mv	a0,s1
    80000b70:	00000097          	auipc	ra,0x0
    80000b74:	eee080e7          	jalr	-274(ra) # 80000a5e <kfree>
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000b78:	87a6                	mv	a5,s1
    80000b7a:	94d2                	add	s1,s1,s4
    80000b7c:	97ce                	add	a5,a5,s3
    80000b7e:	fef971e3          	bgeu	s2,a5,80000b60 <freerange+0x38>
    80000b82:	7902                	ld	s2,32(sp)
    80000b84:	69e2                	ld	s3,24(sp)
    80000b86:	6a42                	ld	s4,16(sp)
    80000b88:	6aa2                	ld	s5,8(sp)
    80000b8a:	6b02                	ld	s6,0(sp)
}
    80000b8c:	70e2                	ld	ra,56(sp)
    80000b8e:	7442                	ld	s0,48(sp)
    80000b90:	74a2                	ld	s1,40(sp)
    80000b92:	6121                	addi	sp,sp,64
    80000b94:	8082                	ret

0000000080000b96 <kinit>:
{
    80000b96:	1101                	addi	sp,sp,-32
    80000b98:	ec06                	sd	ra,24(sp)
    80000b9a:	e822                	sd	s0,16(sp)
    80000b9c:	e426                	sd	s1,8(sp)
    80000b9e:	1000                	addi	s0,sp,32
    initlock(&kmem.lock, "kmem");
    80000ba0:	00007597          	auipc	a1,0x7
    80000ba4:	4c858593          	addi	a1,a1,1224 # 80008068 <etext+0x68>
    80000ba8:	00010517          	auipc	a0,0x10
    80000bac:	19850513          	addi	a0,a0,408 # 80010d40 <kmem>
    80000bb0:	00000097          	auipc	ra,0x0
    80000bb4:	182080e7          	jalr	386(ra) # 80000d32 <initlock>
    memset(kmem.ref, 0, sizeof(kmem.ref));
    80000bb8:	00440637          	lui	a2,0x440
    80000bbc:	4581                	li	a1,0
    80000bbe:	00010517          	auipc	a0,0x10
    80000bc2:	1a250513          	addi	a0,a0,418 # 80010d60 <kmem+0x20>
    80000bc6:	00000097          	auipc	ra,0x0
    80000bca:	2f8080e7          	jalr	760(ra) # 80000ebe <memset>
    FREE_PAGES = 0;
    80000bce:	00008497          	auipc	s1,0x8
    80000bd2:	efa48493          	addi	s1,s1,-262 # 80008ac8 <FREE_PAGES>
    80000bd6:	0004b023          	sd	zero,0(s1)
    freerange(end, (void *)PHYSTOP);
    80000bda:	45c5                	li	a1,17
    80000bdc:	05ee                	slli	a1,a1,0x1b
    80000bde:	00461517          	auipc	a0,0x461
    80000be2:	39250513          	addi	a0,a0,914 # 80461f70 <end>
    80000be6:	00000097          	auipc	ra,0x0
    80000bea:	f42080e7          	jalr	-190(ra) # 80000b28 <freerange>
    MAX_PAGES = FREE_PAGES;
    80000bee:	609c                	ld	a5,0(s1)
    80000bf0:	00008717          	auipc	a4,0x8
    80000bf4:	eef73023          	sd	a5,-288(a4) # 80008ad0 <MAX_PAGES>
}
    80000bf8:	60e2                	ld	ra,24(sp)
    80000bfa:	6442                	ld	s0,16(sp)
    80000bfc:	64a2                	ld	s1,8(sp)
    80000bfe:	6105                	addi	sp,sp,32
    80000c00:	8082                	ret

0000000080000c02 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000c02:	1101                	addi	sp,sp,-32
    80000c04:	ec06                	sd	ra,24(sp)
    80000c06:	e822                	sd	s0,16(sp)
    80000c08:	e426                	sd	s1,8(sp)
    80000c0a:	1000                	addi	s0,sp,32
    struct run *r;

    acquire(&kmem.lock);
    80000c0c:	00010517          	auipc	a0,0x10
    80000c10:	13450513          	addi	a0,a0,308 # 80010d40 <kmem>
    80000c14:	00000097          	auipc	ra,0x0
    80000c18:	1b2080e7          	jalr	434(ra) # 80000dc6 <acquire>
    r = kmem.freelist;
    80000c1c:	00010497          	auipc	s1,0x10
    80000c20:	13c4b483          	ld	s1,316(s1) # 80010d58 <kmem+0x18>
    if(r) {
    80000c24:	c4b1                	beqz	s1,80000c70 <kalloc+0x6e>
      kmem.freelist = r->next;
    80000c26:	609c                	ld	a5,0(s1)
    80000c28:	00010517          	auipc	a0,0x10
    80000c2c:	11850513          	addi	a0,a0,280 # 80010d40 <kmem>
    80000c30:	ed1c                	sd	a5,24(a0)
      kmem.ref[(uint64)r/PGSIZE] = 1;
    80000c32:	00c4d793          	srli	a5,s1,0xc
    80000c36:	0791                	addi	a5,a5,4
    80000c38:	078e                	slli	a5,a5,0x3
    80000c3a:	97aa                	add	a5,a5,a0
    80000c3c:	4705                	li	a4,1
    80000c3e:	e398                	sd	a4,0(a5)
      FREE_PAGES--;
    80000c40:	00008717          	auipc	a4,0x8
    80000c44:	e8870713          	addi	a4,a4,-376 # 80008ac8 <FREE_PAGES>
    80000c48:	631c                	ld	a5,0(a4)
    80000c4a:	17fd                	addi	a5,a5,-1
    80000c4c:	e31c                	sd	a5,0(a4)
    }
    release(&kmem.lock);
    80000c4e:	00000097          	auipc	ra,0x0
    80000c52:	228080e7          	jalr	552(ra) # 80000e76 <release>

    if(r)
      memset((char*)r, 5, PGSIZE); // fill with junk
    80000c56:	6605                	lui	a2,0x1
    80000c58:	4595                	li	a1,5
    80000c5a:	8526                	mv	a0,s1
    80000c5c:	00000097          	auipc	ra,0x0
    80000c60:	262080e7          	jalr	610(ra) # 80000ebe <memset>
    return (void*)r;
}
    80000c64:	8526                	mv	a0,s1
    80000c66:	60e2                	ld	ra,24(sp)
    80000c68:	6442                	ld	s0,16(sp)
    80000c6a:	64a2                	ld	s1,8(sp)
    80000c6c:	6105                	addi	sp,sp,32
    80000c6e:	8082                	ret
    release(&kmem.lock);
    80000c70:	00010517          	auipc	a0,0x10
    80000c74:	0d050513          	addi	a0,a0,208 # 80010d40 <kmem>
    80000c78:	00000097          	auipc	ra,0x0
    80000c7c:	1fe080e7          	jalr	510(ra) # 80000e76 <release>
    if(r)
    80000c80:	b7d5                	j	80000c64 <kalloc+0x62>

0000000080000c82 <increment_ref>:

void
increment_ref(void *pa)
{
    80000c82:	1101                	addi	sp,sp,-32
    80000c84:	ec06                	sd	ra,24(sp)
    80000c86:	e822                	sd	s0,16(sp)
    80000c88:	e426                	sd	s1,8(sp)
    80000c8a:	1000                	addi	s0,sp,32
    if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000c8c:	03451793          	slli	a5,a0,0x34
    80000c90:	eba1                	bnez	a5,80000ce0 <increment_ref+0x5e>
    80000c92:	84aa                	mv	s1,a0
    80000c94:	00461797          	auipc	a5,0x461
    80000c98:	2dc78793          	addi	a5,a5,732 # 80461f70 <end>
    80000c9c:	04f56263          	bltu	a0,a5,80000ce0 <increment_ref+0x5e>
    80000ca0:	47c5                	li	a5,17
    80000ca2:	07ee                	slli	a5,a5,0x1b
    80000ca4:	02f57e63          	bgeu	a0,a5,80000ce0 <increment_ref+0x5e>
      panic("increment_ref");
    acquire(&kmem.lock);
    80000ca8:	00010517          	auipc	a0,0x10
    80000cac:	09850513          	addi	a0,a0,152 # 80010d40 <kmem>
    80000cb0:	00000097          	auipc	ra,0x0
    80000cb4:	116080e7          	jalr	278(ra) # 80000dc6 <acquire>
    kmem.ref[(uint64)pa/PGSIZE]++;
    80000cb8:	80b1                	srli	s1,s1,0xc
    80000cba:	00010517          	auipc	a0,0x10
    80000cbe:	08650513          	addi	a0,a0,134 # 80010d40 <kmem>
    80000cc2:	0491                	addi	s1,s1,4
    80000cc4:	048e                	slli	s1,s1,0x3
    80000cc6:	94aa                	add	s1,s1,a0
    80000cc8:	609c                	ld	a5,0(s1)
    80000cca:	0785                	addi	a5,a5,1
    80000ccc:	e09c                	sd	a5,0(s1)
    release(&kmem.lock);
    80000cce:	00000097          	auipc	ra,0x0
    80000cd2:	1a8080e7          	jalr	424(ra) # 80000e76 <release>
}
    80000cd6:	60e2                	ld	ra,24(sp)
    80000cd8:	6442                	ld	s0,16(sp)
    80000cda:	64a2                	ld	s1,8(sp)
    80000cdc:	6105                	addi	sp,sp,32
    80000cde:	8082                	ret
      panic("increment_ref");
    80000ce0:	00007517          	auipc	a0,0x7
    80000ce4:	39050513          	addi	a0,a0,912 # 80008070 <etext+0x70>
    80000ce8:	00000097          	auipc	ra,0x0
    80000cec:	878080e7          	jalr	-1928(ra) # 80000560 <panic>

0000000080000cf0 <get_ref>:

int
get_ref(void *pa)
{
    80000cf0:	1101                	addi	sp,sp,-32
    80000cf2:	ec06                	sd	ra,24(sp)
    80000cf4:	e822                	sd	s0,16(sp)
    80000cf6:	e426                	sd	s1,8(sp)
    80000cf8:	1000                	addi	s0,sp,32
    80000cfa:	84aa                	mv	s1,a0
    acquire(&kmem.lock);
    80000cfc:	00010517          	auipc	a0,0x10
    80000d00:	04450513          	addi	a0,a0,68 # 80010d40 <kmem>
    80000d04:	00000097          	auipc	ra,0x0
    80000d08:	0c2080e7          	jalr	194(ra) # 80000dc6 <acquire>
    int ref = kmem.ref[(uint64)pa/PGSIZE];
    80000d0c:	00010517          	auipc	a0,0x10
    80000d10:	03450513          	addi	a0,a0,52 # 80010d40 <kmem>
    80000d14:	80b1                	srli	s1,s1,0xc
    80000d16:	0491                	addi	s1,s1,4
    80000d18:	048e                	slli	s1,s1,0x3
    80000d1a:	94aa                	add	s1,s1,a0
    80000d1c:	4084                	lw	s1,0(s1)
    release(&kmem.lock);
    80000d1e:	00000097          	auipc	ra,0x0
    80000d22:	158080e7          	jalr	344(ra) # 80000e76 <release>
    return ref;
}
    80000d26:	8526                	mv	a0,s1
    80000d28:	60e2                	ld	ra,24(sp)
    80000d2a:	6442                	ld	s0,16(sp)
    80000d2c:	64a2                	ld	s1,8(sp)
    80000d2e:	6105                	addi	sp,sp,32
    80000d30:	8082                	ret

0000000080000d32 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000d32:	1141                	addi	sp,sp,-16
    80000d34:	e406                	sd	ra,8(sp)
    80000d36:	e022                	sd	s0,0(sp)
    80000d38:	0800                	addi	s0,sp,16
  lk->name = name;
    80000d3a:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000d3c:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000d40:	00053823          	sd	zero,16(a0)
}
    80000d44:	60a2                	ld	ra,8(sp)
    80000d46:	6402                	ld	s0,0(sp)
    80000d48:	0141                	addi	sp,sp,16
    80000d4a:	8082                	ret

0000000080000d4c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000d4c:	411c                	lw	a5,0(a0)
    80000d4e:	e399                	bnez	a5,80000d54 <holding+0x8>
    80000d50:	4501                	li	a0,0
  return r;
}
    80000d52:	8082                	ret
{
    80000d54:	1101                	addi	sp,sp,-32
    80000d56:	ec06                	sd	ra,24(sp)
    80000d58:	e822                	sd	s0,16(sp)
    80000d5a:	e426                	sd	s1,8(sp)
    80000d5c:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000d5e:	6904                	ld	s1,16(a0)
    80000d60:	00001097          	auipc	ra,0x1
    80000d64:	f9e080e7          	jalr	-98(ra) # 80001cfe <mycpu>
    80000d68:	40a48533          	sub	a0,s1,a0
    80000d6c:	00153513          	seqz	a0,a0
}
    80000d70:	60e2                	ld	ra,24(sp)
    80000d72:	6442                	ld	s0,16(sp)
    80000d74:	64a2                	ld	s1,8(sp)
    80000d76:	6105                	addi	sp,sp,32
    80000d78:	8082                	ret

0000000080000d7a <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000d7a:	1101                	addi	sp,sp,-32
    80000d7c:	ec06                	sd	ra,24(sp)
    80000d7e:	e822                	sd	s0,16(sp)
    80000d80:	e426                	sd	s1,8(sp)
    80000d82:	1000                	addi	s0,sp,32
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80000d84:	100024f3          	csrr	s1,sstatus
    80000d88:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000d8c:	9bf5                	andi	a5,a5,-3
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80000d8e:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000d92:	00001097          	auipc	ra,0x1
    80000d96:	f6c080e7          	jalr	-148(ra) # 80001cfe <mycpu>
    80000d9a:	5d3c                	lw	a5,120(a0)
    80000d9c:	cf89                	beqz	a5,80000db6 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000d9e:	00001097          	auipc	ra,0x1
    80000da2:	f60080e7          	jalr	-160(ra) # 80001cfe <mycpu>
    80000da6:	5d3c                	lw	a5,120(a0)
    80000da8:	2785                	addiw	a5,a5,1
    80000daa:	dd3c                	sw	a5,120(a0)
}
    80000dac:	60e2                	ld	ra,24(sp)
    80000dae:	6442                	ld	s0,16(sp)
    80000db0:	64a2                	ld	s1,8(sp)
    80000db2:	6105                	addi	sp,sp,32
    80000db4:	8082                	ret
    mycpu()->intena = old;
    80000db6:	00001097          	auipc	ra,0x1
    80000dba:	f48080e7          	jalr	-184(ra) # 80001cfe <mycpu>
    return (x & SSTATUS_SIE) != 0;
    80000dbe:	8085                	srli	s1,s1,0x1
    80000dc0:	8885                	andi	s1,s1,1
    80000dc2:	dd64                	sw	s1,124(a0)
    80000dc4:	bfe9                	j	80000d9e <push_off+0x24>

0000000080000dc6 <acquire>:
{
    80000dc6:	1101                	addi	sp,sp,-32
    80000dc8:	ec06                	sd	ra,24(sp)
    80000dca:	e822                	sd	s0,16(sp)
    80000dcc:	e426                	sd	s1,8(sp)
    80000dce:	1000                	addi	s0,sp,32
    80000dd0:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000dd2:	00000097          	auipc	ra,0x0
    80000dd6:	fa8080e7          	jalr	-88(ra) # 80000d7a <push_off>
  if(holding(lk))
    80000dda:	8526                	mv	a0,s1
    80000ddc:	00000097          	auipc	ra,0x0
    80000de0:	f70080e7          	jalr	-144(ra) # 80000d4c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000de4:	4705                	li	a4,1
  if(holding(lk))
    80000de6:	e115                	bnez	a0,80000e0a <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000de8:	87ba                	mv	a5,a4
    80000dea:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000dee:	2781                	sext.w	a5,a5
    80000df0:	ffe5                	bnez	a5,80000de8 <acquire+0x22>
  __sync_synchronize();
    80000df2:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000df6:	00001097          	auipc	ra,0x1
    80000dfa:	f08080e7          	jalr	-248(ra) # 80001cfe <mycpu>
    80000dfe:	e888                	sd	a0,16(s1)
}
    80000e00:	60e2                	ld	ra,24(sp)
    80000e02:	6442                	ld	s0,16(sp)
    80000e04:	64a2                	ld	s1,8(sp)
    80000e06:	6105                	addi	sp,sp,32
    80000e08:	8082                	ret
    panic("acquire");
    80000e0a:	00007517          	auipc	a0,0x7
    80000e0e:	27650513          	addi	a0,a0,630 # 80008080 <etext+0x80>
    80000e12:	fffff097          	auipc	ra,0xfffff
    80000e16:	74e080e7          	jalr	1870(ra) # 80000560 <panic>

0000000080000e1a <pop_off>:

void
pop_off(void)
{
    80000e1a:	1141                	addi	sp,sp,-16
    80000e1c:	e406                	sd	ra,8(sp)
    80000e1e:	e022                	sd	s0,0(sp)
    80000e20:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000e22:	00001097          	auipc	ra,0x1
    80000e26:	edc080e7          	jalr	-292(ra) # 80001cfe <mycpu>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80000e2a:	100027f3          	csrr	a5,sstatus
    return (x & SSTATUS_SIE) != 0;
    80000e2e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000e30:	e39d                	bnez	a5,80000e56 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000e32:	5d3c                	lw	a5,120(a0)
    80000e34:	02f05963          	blez	a5,80000e66 <pop_off+0x4c>
    panic("pop_off");
  c->noff -= 1;
    80000e38:	37fd                	addiw	a5,a5,-1
    80000e3a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000e3c:	eb89                	bnez	a5,80000e4e <pop_off+0x34>
    80000e3e:	5d7c                	lw	a5,124(a0)
    80000e40:	c799                	beqz	a5,80000e4e <pop_off+0x34>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80000e42:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000e46:	0027e793          	ori	a5,a5,2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80000e4a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000e4e:	60a2                	ld	ra,8(sp)
    80000e50:	6402                	ld	s0,0(sp)
    80000e52:	0141                	addi	sp,sp,16
    80000e54:	8082                	ret
    panic("pop_off - interruptible");
    80000e56:	00007517          	auipc	a0,0x7
    80000e5a:	23250513          	addi	a0,a0,562 # 80008088 <etext+0x88>
    80000e5e:	fffff097          	auipc	ra,0xfffff
    80000e62:	702080e7          	jalr	1794(ra) # 80000560 <panic>
    panic("pop_off");
    80000e66:	00007517          	auipc	a0,0x7
    80000e6a:	23a50513          	addi	a0,a0,570 # 800080a0 <etext+0xa0>
    80000e6e:	fffff097          	auipc	ra,0xfffff
    80000e72:	6f2080e7          	jalr	1778(ra) # 80000560 <panic>

0000000080000e76 <release>:
{
    80000e76:	1101                	addi	sp,sp,-32
    80000e78:	ec06                	sd	ra,24(sp)
    80000e7a:	e822                	sd	s0,16(sp)
    80000e7c:	e426                	sd	s1,8(sp)
    80000e7e:	1000                	addi	s0,sp,32
    80000e80:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000e82:	00000097          	auipc	ra,0x0
    80000e86:	eca080e7          	jalr	-310(ra) # 80000d4c <holding>
    80000e8a:	c115                	beqz	a0,80000eae <release+0x38>
  lk->cpu = 0;
    80000e8c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000e90:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000e94:	0310000f          	fence	rw,w
    80000e98:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000e9c:	00000097          	auipc	ra,0x0
    80000ea0:	f7e080e7          	jalr	-130(ra) # 80000e1a <pop_off>
}
    80000ea4:	60e2                	ld	ra,24(sp)
    80000ea6:	6442                	ld	s0,16(sp)
    80000ea8:	64a2                	ld	s1,8(sp)
    80000eaa:	6105                	addi	sp,sp,32
    80000eac:	8082                	ret
    panic("release");
    80000eae:	00007517          	auipc	a0,0x7
    80000eb2:	1fa50513          	addi	a0,a0,506 # 800080a8 <etext+0xa8>
    80000eb6:	fffff097          	auipc	ra,0xfffff
    80000eba:	6aa080e7          	jalr	1706(ra) # 80000560 <panic>

0000000080000ebe <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000ebe:	1141                	addi	sp,sp,-16
    80000ec0:	e406                	sd	ra,8(sp)
    80000ec2:	e022                	sd	s0,0(sp)
    80000ec4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000ec6:	ca19                	beqz	a2,80000edc <memset+0x1e>
    80000ec8:	87aa                	mv	a5,a0
    80000eca:	1602                	slli	a2,a2,0x20
    80000ecc:	9201                	srli	a2,a2,0x20
    80000ece:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000ed2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000ed6:	0785                	addi	a5,a5,1
    80000ed8:	fee79de3          	bne	a5,a4,80000ed2 <memset+0x14>
  }
  return dst;
}
    80000edc:	60a2                	ld	ra,8(sp)
    80000ede:	6402                	ld	s0,0(sp)
    80000ee0:	0141                	addi	sp,sp,16
    80000ee2:	8082                	ret

0000000080000ee4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000ee4:	1141                	addi	sp,sp,-16
    80000ee6:	e406                	sd	ra,8(sp)
    80000ee8:	e022                	sd	s0,0(sp)
    80000eea:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000eec:	ca0d                	beqz	a2,80000f1e <memcmp+0x3a>
    80000eee:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000ef2:	1682                	slli	a3,a3,0x20
    80000ef4:	9281                	srli	a3,a3,0x20
    80000ef6:	0685                	addi	a3,a3,1
    80000ef8:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000efa:	00054783          	lbu	a5,0(a0)
    80000efe:	0005c703          	lbu	a4,0(a1)
    80000f02:	00e79863          	bne	a5,a4,80000f12 <memcmp+0x2e>
      return *s1 - *s2;
    s1++, s2++;
    80000f06:	0505                	addi	a0,a0,1
    80000f08:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000f0a:	fed518e3          	bne	a0,a3,80000efa <memcmp+0x16>
  }

  return 0;
    80000f0e:	4501                	li	a0,0
    80000f10:	a019                	j	80000f16 <memcmp+0x32>
      return *s1 - *s2;
    80000f12:	40e7853b          	subw	a0,a5,a4
}
    80000f16:	60a2                	ld	ra,8(sp)
    80000f18:	6402                	ld	s0,0(sp)
    80000f1a:	0141                	addi	sp,sp,16
    80000f1c:	8082                	ret
  return 0;
    80000f1e:	4501                	li	a0,0
    80000f20:	bfdd                	j	80000f16 <memcmp+0x32>

0000000080000f22 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000f22:	1141                	addi	sp,sp,-16
    80000f24:	e406                	sd	ra,8(sp)
    80000f26:	e022                	sd	s0,0(sp)
    80000f28:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000f2a:	c205                	beqz	a2,80000f4a <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000f2c:	02a5e363          	bltu	a1,a0,80000f52 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000f30:	1602                	slli	a2,a2,0x20
    80000f32:	9201                	srli	a2,a2,0x20
    80000f34:	00c587b3          	add	a5,a1,a2
{
    80000f38:	872a                	mv	a4,a0
      *d++ = *s++;
    80000f3a:	0585                	addi	a1,a1,1
    80000f3c:	0705                	addi	a4,a4,1
    80000f3e:	fff5c683          	lbu	a3,-1(a1)
    80000f42:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000f46:	feb79ae3          	bne	a5,a1,80000f3a <memmove+0x18>

  return dst;
}
    80000f4a:	60a2                	ld	ra,8(sp)
    80000f4c:	6402                	ld	s0,0(sp)
    80000f4e:	0141                	addi	sp,sp,16
    80000f50:	8082                	ret
  if(s < d && s + n > d){
    80000f52:	02061693          	slli	a3,a2,0x20
    80000f56:	9281                	srli	a3,a3,0x20
    80000f58:	00d58733          	add	a4,a1,a3
    80000f5c:	fce57ae3          	bgeu	a0,a4,80000f30 <memmove+0xe>
    d += n;
    80000f60:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000f62:	fff6079b          	addiw	a5,a2,-1
    80000f66:	1782                	slli	a5,a5,0x20
    80000f68:	9381                	srli	a5,a5,0x20
    80000f6a:	fff7c793          	not	a5,a5
    80000f6e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000f70:	177d                	addi	a4,a4,-1
    80000f72:	16fd                	addi	a3,a3,-1
    80000f74:	00074603          	lbu	a2,0(a4)
    80000f78:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000f7c:	fee79ae3          	bne	a5,a4,80000f70 <memmove+0x4e>
    80000f80:	b7e9                	j	80000f4a <memmove+0x28>

0000000080000f82 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000f82:	1141                	addi	sp,sp,-16
    80000f84:	e406                	sd	ra,8(sp)
    80000f86:	e022                	sd	s0,0(sp)
    80000f88:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000f8a:	00000097          	auipc	ra,0x0
    80000f8e:	f98080e7          	jalr	-104(ra) # 80000f22 <memmove>
}
    80000f92:	60a2                	ld	ra,8(sp)
    80000f94:	6402                	ld	s0,0(sp)
    80000f96:	0141                	addi	sp,sp,16
    80000f98:	8082                	ret

0000000080000f9a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000f9a:	1141                	addi	sp,sp,-16
    80000f9c:	e406                	sd	ra,8(sp)
    80000f9e:	e022                	sd	s0,0(sp)
    80000fa0:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000fa2:	ce11                	beqz	a2,80000fbe <strncmp+0x24>
    80000fa4:	00054783          	lbu	a5,0(a0)
    80000fa8:	cf89                	beqz	a5,80000fc2 <strncmp+0x28>
    80000faa:	0005c703          	lbu	a4,0(a1)
    80000fae:	00f71a63          	bne	a4,a5,80000fc2 <strncmp+0x28>
    n--, p++, q++;
    80000fb2:	367d                	addiw	a2,a2,-1
    80000fb4:	0505                	addi	a0,a0,1
    80000fb6:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000fb8:	f675                	bnez	a2,80000fa4 <strncmp+0xa>
  if(n == 0)
    return 0;
    80000fba:	4501                	li	a0,0
    80000fbc:	a801                	j	80000fcc <strncmp+0x32>
    80000fbe:	4501                	li	a0,0
    80000fc0:	a031                	j	80000fcc <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    80000fc2:	00054503          	lbu	a0,0(a0)
    80000fc6:	0005c783          	lbu	a5,0(a1)
    80000fca:	9d1d                	subw	a0,a0,a5
}
    80000fcc:	60a2                	ld	ra,8(sp)
    80000fce:	6402                	ld	s0,0(sp)
    80000fd0:	0141                	addi	sp,sp,16
    80000fd2:	8082                	ret

0000000080000fd4 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000fd4:	1141                	addi	sp,sp,-16
    80000fd6:	e406                	sd	ra,8(sp)
    80000fd8:	e022                	sd	s0,0(sp)
    80000fda:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000fdc:	87aa                	mv	a5,a0
    80000fde:	86b2                	mv	a3,a2
    80000fe0:	367d                	addiw	a2,a2,-1
    80000fe2:	02d05563          	blez	a3,8000100c <strncpy+0x38>
    80000fe6:	0785                	addi	a5,a5,1
    80000fe8:	0005c703          	lbu	a4,0(a1)
    80000fec:	fee78fa3          	sb	a4,-1(a5)
    80000ff0:	0585                	addi	a1,a1,1
    80000ff2:	f775                	bnez	a4,80000fde <strncpy+0xa>
    ;
  while(n-- > 0)
    80000ff4:	873e                	mv	a4,a5
    80000ff6:	00c05b63          	blez	a2,8000100c <strncpy+0x38>
    80000ffa:	9fb5                	addw	a5,a5,a3
    80000ffc:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000ffe:	0705                	addi	a4,a4,1
    80001000:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80001004:	40e786bb          	subw	a3,a5,a4
    80001008:	fed04be3          	bgtz	a3,80000ffe <strncpy+0x2a>
  return os;
}
    8000100c:	60a2                	ld	ra,8(sp)
    8000100e:	6402                	ld	s0,0(sp)
    80001010:	0141                	addi	sp,sp,16
    80001012:	8082                	ret

0000000080001014 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80001014:	1141                	addi	sp,sp,-16
    80001016:	e406                	sd	ra,8(sp)
    80001018:	e022                	sd	s0,0(sp)
    8000101a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    8000101c:	02c05363          	blez	a2,80001042 <safestrcpy+0x2e>
    80001020:	fff6069b          	addiw	a3,a2,-1
    80001024:	1682                	slli	a3,a3,0x20
    80001026:	9281                	srli	a3,a3,0x20
    80001028:	96ae                	add	a3,a3,a1
    8000102a:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    8000102c:	00d58963          	beq	a1,a3,8000103e <safestrcpy+0x2a>
    80001030:	0585                	addi	a1,a1,1
    80001032:	0785                	addi	a5,a5,1
    80001034:	fff5c703          	lbu	a4,-1(a1)
    80001038:	fee78fa3          	sb	a4,-1(a5)
    8000103c:	fb65                	bnez	a4,8000102c <safestrcpy+0x18>
    ;
  *s = 0;
    8000103e:	00078023          	sb	zero,0(a5)
  return os;
}
    80001042:	60a2                	ld	ra,8(sp)
    80001044:	6402                	ld	s0,0(sp)
    80001046:	0141                	addi	sp,sp,16
    80001048:	8082                	ret

000000008000104a <strlen>:

int
strlen(const char *s)
{
    8000104a:	1141                	addi	sp,sp,-16
    8000104c:	e406                	sd	ra,8(sp)
    8000104e:	e022                	sd	s0,0(sp)
    80001050:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80001052:	00054783          	lbu	a5,0(a0)
    80001056:	cf99                	beqz	a5,80001074 <strlen+0x2a>
    80001058:	0505                	addi	a0,a0,1
    8000105a:	87aa                	mv	a5,a0
    8000105c:	86be                	mv	a3,a5
    8000105e:	0785                	addi	a5,a5,1
    80001060:	fff7c703          	lbu	a4,-1(a5)
    80001064:	ff65                	bnez	a4,8000105c <strlen+0x12>
    80001066:	40a6853b          	subw	a0,a3,a0
    8000106a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    8000106c:	60a2                	ld	ra,8(sp)
    8000106e:	6402                	ld	s0,0(sp)
    80001070:	0141                	addi	sp,sp,16
    80001072:	8082                	ret
  for(n = 0; s[n]; n++)
    80001074:	4501                	li	a0,0
    80001076:	bfdd                	j	8000106c <strlen+0x22>

0000000080001078 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80001078:	1141                	addi	sp,sp,-16
    8000107a:	e406                	sd	ra,8(sp)
    8000107c:	e022                	sd	s0,0(sp)
    8000107e:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80001080:	00001097          	auipc	ra,0x1
    80001084:	c6a080e7          	jalr	-918(ra) # 80001cea <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80001088:	00008717          	auipc	a4,0x8
    8000108c:	a5070713          	addi	a4,a4,-1456 # 80008ad8 <started>
  if(cpuid() == 0){
    80001090:	c139                	beqz	a0,800010d6 <main+0x5e>
    while(started == 0)
    80001092:	431c                	lw	a5,0(a4)
    80001094:	2781                	sext.w	a5,a5
    80001096:	dff5                	beqz	a5,80001092 <main+0x1a>
      ;
    __sync_synchronize();
    80001098:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    8000109c:	00001097          	auipc	ra,0x1
    800010a0:	c4e080e7          	jalr	-946(ra) # 80001cea <cpuid>
    800010a4:	85aa                	mv	a1,a0
    800010a6:	00007517          	auipc	a0,0x7
    800010aa:	02250513          	addi	a0,a0,34 # 800080c8 <etext+0xc8>
    800010ae:	fffff097          	auipc	ra,0xfffff
    800010b2:	50e080e7          	jalr	1294(ra) # 800005bc <printf>
    kvminithart();    // turn on paging
    800010b6:	00000097          	auipc	ra,0x0
    800010ba:	0d8080e7          	jalr	216(ra) # 8000118e <kvminithart>
    trapinithart();   // install kernel trap vector
    800010be:	00002097          	auipc	ra,0x2
    800010c2:	ae6080e7          	jalr	-1306(ra) # 80002ba4 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800010c6:	00005097          	auipc	ra,0x5
    800010ca:	42e080e7          	jalr	1070(ra) # 800064f4 <plicinithart>
  }

  scheduler();        
    800010ce:	00001097          	auipc	ra,0x1
    800010d2:	2e2080e7          	jalr	738(ra) # 800023b0 <scheduler>
    consoleinit();
    800010d6:	fffff097          	auipc	ra,0xfffff
    800010da:	3ac080e7          	jalr	940(ra) # 80000482 <consoleinit>
    printfinit();
    800010de:	fffff097          	auipc	ra,0xfffff
    800010e2:	6e8080e7          	jalr	1768(ra) # 800007c6 <printfinit>
    printf("\n");
    800010e6:	00007517          	auipc	a0,0x7
    800010ea:	f2a50513          	addi	a0,a0,-214 # 80008010 <etext+0x10>
    800010ee:	fffff097          	auipc	ra,0xfffff
    800010f2:	4ce080e7          	jalr	1230(ra) # 800005bc <printf>
    printf("xv6 kernel is booting\n");
    800010f6:	00007517          	auipc	a0,0x7
    800010fa:	fba50513          	addi	a0,a0,-70 # 800080b0 <etext+0xb0>
    800010fe:	fffff097          	auipc	ra,0xfffff
    80001102:	4be080e7          	jalr	1214(ra) # 800005bc <printf>
    printf("\n");
    80001106:	00007517          	auipc	a0,0x7
    8000110a:	f0a50513          	addi	a0,a0,-246 # 80008010 <etext+0x10>
    8000110e:	fffff097          	auipc	ra,0xfffff
    80001112:	4ae080e7          	jalr	1198(ra) # 800005bc <printf>
    kinit();         // physical page allocator
    80001116:	00000097          	auipc	ra,0x0
    8000111a:	a80080e7          	jalr	-1408(ra) # 80000b96 <kinit>
    kvminit();       // create kernel page table
    8000111e:	00000097          	auipc	ra,0x0
    80001122:	32a080e7          	jalr	810(ra) # 80001448 <kvminit>
    kvminithart();   // turn on paging
    80001126:	00000097          	auipc	ra,0x0
    8000112a:	068080e7          	jalr	104(ra) # 8000118e <kvminithart>
    procinit();      // process table
    8000112e:	00001097          	auipc	ra,0x1
    80001132:	ad8080e7          	jalr	-1320(ra) # 80001c06 <procinit>
    trapinit();      // trap vectors
    80001136:	00002097          	auipc	ra,0x2
    8000113a:	a46080e7          	jalr	-1466(ra) # 80002b7c <trapinit>
    trapinithart();  // install kernel trap vector
    8000113e:	00002097          	auipc	ra,0x2
    80001142:	a66080e7          	jalr	-1434(ra) # 80002ba4 <trapinithart>
    plicinit();      // set up interrupt controller
    80001146:	00005097          	auipc	ra,0x5
    8000114a:	394080e7          	jalr	916(ra) # 800064da <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000114e:	00005097          	auipc	ra,0x5
    80001152:	3a6080e7          	jalr	934(ra) # 800064f4 <plicinithart>
    binit();         // buffer cache
    80001156:	00002097          	auipc	ra,0x2
    8000115a:	428080e7          	jalr	1064(ra) # 8000357e <binit>
    iinit();         // inode table
    8000115e:	00003097          	auipc	ra,0x3
    80001162:	ab8080e7          	jalr	-1352(ra) # 80003c16 <iinit>
    fileinit();      // file table
    80001166:	00004097          	auipc	ra,0x4
    8000116a:	a8a080e7          	jalr	-1398(ra) # 80004bf0 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000116e:	00005097          	auipc	ra,0x5
    80001172:	48e080e7          	jalr	1166(ra) # 800065fc <virtio_disk_init>
    userinit();      // first user process
    80001176:	00001097          	auipc	ra,0x1
    8000117a:	e80080e7          	jalr	-384(ra) # 80001ff6 <userinit>
    __sync_synchronize();
    8000117e:	0330000f          	fence	rw,rw
    started = 1;
    80001182:	4785                	li	a5,1
    80001184:	00008717          	auipc	a4,0x8
    80001188:	94f72a23          	sw	a5,-1708(a4) # 80008ad8 <started>
    8000118c:	b789                	j	800010ce <main+0x56>

000000008000118e <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000118e:	1141                	addi	sp,sp,-16
    80001190:	e406                	sd	ra,8(sp)
    80001192:	e022                	sd	s0,0(sp)
    80001194:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
    // the zero, zero means flush all TLB entries.
    asm volatile("sfence.vma zero, zero");
    80001196:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000119a:	00008797          	auipc	a5,0x8
    8000119e:	9467b783          	ld	a5,-1722(a5) # 80008ae0 <kernel_pagetable>
    800011a2:	83b1                	srli	a5,a5,0xc
    800011a4:	577d                	li	a4,-1
    800011a6:	177e                	slli	a4,a4,0x3f
    800011a8:	8fd9                	or	a5,a5,a4
    asm volatile("csrw satp, %0" : : "r"(x));
    800011aa:	18079073          	csrw	satp,a5
    asm volatile("sfence.vma zero, zero");
    800011ae:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800011b2:	60a2                	ld	ra,8(sp)
    800011b4:	6402                	ld	s0,0(sp)
    800011b6:	0141                	addi	sp,sp,16
    800011b8:	8082                	ret

00000000800011ba <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800011ba:	7139                	addi	sp,sp,-64
    800011bc:	fc06                	sd	ra,56(sp)
    800011be:	f822                	sd	s0,48(sp)
    800011c0:	f426                	sd	s1,40(sp)
    800011c2:	f04a                	sd	s2,32(sp)
    800011c4:	ec4e                	sd	s3,24(sp)
    800011c6:	e852                	sd	s4,16(sp)
    800011c8:	e456                	sd	s5,8(sp)
    800011ca:	e05a                	sd	s6,0(sp)
    800011cc:	0080                	addi	s0,sp,64
    800011ce:	84aa                	mv	s1,a0
    800011d0:	89ae                	mv	s3,a1
    800011d2:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800011d4:	57fd                	li	a5,-1
    800011d6:	83e9                	srli	a5,a5,0x1a
    800011d8:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800011da:	4b31                	li	s6,12
  if(va >= MAXVA)
    800011dc:	04b7e263          	bltu	a5,a1,80001220 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    800011e0:	0149d933          	srl	s2,s3,s4
    800011e4:	1ff97913          	andi	s2,s2,511
    800011e8:	090e                	slli	s2,s2,0x3
    800011ea:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800011ec:	00093483          	ld	s1,0(s2)
    800011f0:	0014f793          	andi	a5,s1,1
    800011f4:	cf95                	beqz	a5,80001230 <walk+0x76>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800011f6:	80a9                	srli	s1,s1,0xa
    800011f8:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    800011fa:	3a5d                	addiw	s4,s4,-9 # ff7 <_entry-0x7ffff009>
    800011fc:	ff6a12e3          	bne	s4,s6,800011e0 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80001200:	00c9d513          	srli	a0,s3,0xc
    80001204:	1ff57513          	andi	a0,a0,511
    80001208:	050e                	slli	a0,a0,0x3
    8000120a:	9526                	add	a0,a0,s1
}
    8000120c:	70e2                	ld	ra,56(sp)
    8000120e:	7442                	ld	s0,48(sp)
    80001210:	74a2                	ld	s1,40(sp)
    80001212:	7902                	ld	s2,32(sp)
    80001214:	69e2                	ld	s3,24(sp)
    80001216:	6a42                	ld	s4,16(sp)
    80001218:	6aa2                	ld	s5,8(sp)
    8000121a:	6b02                	ld	s6,0(sp)
    8000121c:	6121                	addi	sp,sp,64
    8000121e:	8082                	ret
    panic("walk");
    80001220:	00007517          	auipc	a0,0x7
    80001224:	ec050513          	addi	a0,a0,-320 # 800080e0 <etext+0xe0>
    80001228:	fffff097          	auipc	ra,0xfffff
    8000122c:	338080e7          	jalr	824(ra) # 80000560 <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80001230:	020a8663          	beqz	s5,8000125c <walk+0xa2>
    80001234:	00000097          	auipc	ra,0x0
    80001238:	9ce080e7          	jalr	-1586(ra) # 80000c02 <kalloc>
    8000123c:	84aa                	mv	s1,a0
    8000123e:	d579                	beqz	a0,8000120c <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    80001240:	6605                	lui	a2,0x1
    80001242:	4581                	li	a1,0
    80001244:	00000097          	auipc	ra,0x0
    80001248:	c7a080e7          	jalr	-902(ra) # 80000ebe <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000124c:	00c4d793          	srli	a5,s1,0xc
    80001250:	07aa                	slli	a5,a5,0xa
    80001252:	0017e793          	ori	a5,a5,1
    80001256:	00f93023          	sd	a5,0(s2)
    8000125a:	b745                	j	800011fa <walk+0x40>
        return 0;
    8000125c:	4501                	li	a0,0
    8000125e:	b77d                	j	8000120c <walk+0x52>

0000000080001260 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80001260:	57fd                	li	a5,-1
    80001262:	83e9                	srli	a5,a5,0x1a
    80001264:	00b7f463          	bgeu	a5,a1,8000126c <walkaddr+0xc>
    return 0;
    80001268:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000126a:	8082                	ret
{
    8000126c:	1141                	addi	sp,sp,-16
    8000126e:	e406                	sd	ra,8(sp)
    80001270:	e022                	sd	s0,0(sp)
    80001272:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001274:	4601                	li	a2,0
    80001276:	00000097          	auipc	ra,0x0
    8000127a:	f44080e7          	jalr	-188(ra) # 800011ba <walk>
  if(pte == 0)
    8000127e:	c105                	beqz	a0,8000129e <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80001280:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001282:	0117f693          	andi	a3,a5,17
    80001286:	4745                	li	a4,17
    return 0;
    80001288:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000128a:	00e68663          	beq	a3,a4,80001296 <walkaddr+0x36>
}
    8000128e:	60a2                	ld	ra,8(sp)
    80001290:	6402                	ld	s0,0(sp)
    80001292:	0141                	addi	sp,sp,16
    80001294:	8082                	ret
  pa = PTE2PA(*pte);
    80001296:	83a9                	srli	a5,a5,0xa
    80001298:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000129c:	bfcd                	j	8000128e <walkaddr+0x2e>
    return 0;
    8000129e:	4501                	li	a0,0
    800012a0:	b7fd                	j	8000128e <walkaddr+0x2e>

00000000800012a2 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800012a2:	715d                	addi	sp,sp,-80
    800012a4:	e486                	sd	ra,72(sp)
    800012a6:	e0a2                	sd	s0,64(sp)
    800012a8:	fc26                	sd	s1,56(sp)
    800012aa:	f84a                	sd	s2,48(sp)
    800012ac:	f44e                	sd	s3,40(sp)
    800012ae:	f052                	sd	s4,32(sp)
    800012b0:	ec56                	sd	s5,24(sp)
    800012b2:	e85a                	sd	s6,16(sp)
    800012b4:	e45e                	sd	s7,8(sp)
    800012b6:	e062                	sd	s8,0(sp)
    800012b8:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800012ba:	ca21                	beqz	a2,8000130a <mappages+0x68>
    800012bc:	8aaa                	mv	s5,a0
    800012be:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800012c0:	777d                	lui	a4,0xfffff
    800012c2:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800012c6:	fff58993          	addi	s3,a1,-1
    800012ca:	99b2                	add	s3,s3,a2
    800012cc:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800012d0:	893e                	mv	s2,a5
    800012d2:	40f68a33          	sub	s4,a3,a5
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    800012d6:	4b85                	li	s7,1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800012d8:	6c05                	lui	s8,0x1
    800012da:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800012de:	865e                	mv	a2,s7
    800012e0:	85ca                	mv	a1,s2
    800012e2:	8556                	mv	a0,s5
    800012e4:	00000097          	auipc	ra,0x0
    800012e8:	ed6080e7          	jalr	-298(ra) # 800011ba <walk>
    800012ec:	cd1d                	beqz	a0,8000132a <mappages+0x88>
    if(*pte & PTE_V)
    800012ee:	611c                	ld	a5,0(a0)
    800012f0:	8b85                	andi	a5,a5,1
    800012f2:	e785                	bnez	a5,8000131a <mappages+0x78>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800012f4:	80b1                	srli	s1,s1,0xc
    800012f6:	04aa                	slli	s1,s1,0xa
    800012f8:	0164e4b3          	or	s1,s1,s6
    800012fc:	0014e493          	ori	s1,s1,1
    80001300:	e104                	sd	s1,0(a0)
    if(a == last)
    80001302:	05390163          	beq	s2,s3,80001344 <mappages+0xa2>
    a += PGSIZE;
    80001306:	9962                	add	s2,s2,s8
    if((pte = walk(pagetable, a, 1)) == 0)
    80001308:	bfc9                	j	800012da <mappages+0x38>
    panic("mappages: size");
    8000130a:	00007517          	auipc	a0,0x7
    8000130e:	dde50513          	addi	a0,a0,-546 # 800080e8 <etext+0xe8>
    80001312:	fffff097          	auipc	ra,0xfffff
    80001316:	24e080e7          	jalr	590(ra) # 80000560 <panic>
      panic("mappages: remap");
    8000131a:	00007517          	auipc	a0,0x7
    8000131e:	dde50513          	addi	a0,a0,-546 # 800080f8 <etext+0xf8>
    80001322:	fffff097          	auipc	ra,0xfffff
    80001326:	23e080e7          	jalr	574(ra) # 80000560 <panic>
      return -1;
    8000132a:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000132c:	60a6                	ld	ra,72(sp)
    8000132e:	6406                	ld	s0,64(sp)
    80001330:	74e2                	ld	s1,56(sp)
    80001332:	7942                	ld	s2,48(sp)
    80001334:	79a2                	ld	s3,40(sp)
    80001336:	7a02                	ld	s4,32(sp)
    80001338:	6ae2                	ld	s5,24(sp)
    8000133a:	6b42                	ld	s6,16(sp)
    8000133c:	6ba2                	ld	s7,8(sp)
    8000133e:	6c02                	ld	s8,0(sp)
    80001340:	6161                	addi	sp,sp,80
    80001342:	8082                	ret
  return 0;
    80001344:	4501                	li	a0,0
    80001346:	b7dd                	j	8000132c <mappages+0x8a>

0000000080001348 <kvmmap>:
{
    80001348:	1141                	addi	sp,sp,-16
    8000134a:	e406                	sd	ra,8(sp)
    8000134c:	e022                	sd	s0,0(sp)
    8000134e:	0800                	addi	s0,sp,16
    80001350:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001352:	86b2                	mv	a3,a2
    80001354:	863e                	mv	a2,a5
    80001356:	00000097          	auipc	ra,0x0
    8000135a:	f4c080e7          	jalr	-180(ra) # 800012a2 <mappages>
    8000135e:	e509                	bnez	a0,80001368 <kvmmap+0x20>
}
    80001360:	60a2                	ld	ra,8(sp)
    80001362:	6402                	ld	s0,0(sp)
    80001364:	0141                	addi	sp,sp,16
    80001366:	8082                	ret
    panic("kvmmap");
    80001368:	00007517          	auipc	a0,0x7
    8000136c:	da050513          	addi	a0,a0,-608 # 80008108 <etext+0x108>
    80001370:	fffff097          	auipc	ra,0xfffff
    80001374:	1f0080e7          	jalr	496(ra) # 80000560 <panic>

0000000080001378 <kvmmake>:
{
    80001378:	1101                	addi	sp,sp,-32
    8000137a:	ec06                	sd	ra,24(sp)
    8000137c:	e822                	sd	s0,16(sp)
    8000137e:	e426                	sd	s1,8(sp)
    80001380:	e04a                	sd	s2,0(sp)
    80001382:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001384:	00000097          	auipc	ra,0x0
    80001388:	87e080e7          	jalr	-1922(ra) # 80000c02 <kalloc>
    8000138c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000138e:	6605                	lui	a2,0x1
    80001390:	4581                	li	a1,0
    80001392:	00000097          	auipc	ra,0x0
    80001396:	b2c080e7          	jalr	-1236(ra) # 80000ebe <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000139a:	4719                	li	a4,6
    8000139c:	6685                	lui	a3,0x1
    8000139e:	10000637          	lui	a2,0x10000
    800013a2:	85b2                	mv	a1,a2
    800013a4:	8526                	mv	a0,s1
    800013a6:	00000097          	auipc	ra,0x0
    800013aa:	fa2080e7          	jalr	-94(ra) # 80001348 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800013ae:	4719                	li	a4,6
    800013b0:	6685                	lui	a3,0x1
    800013b2:	10001637          	lui	a2,0x10001
    800013b6:	85b2                	mv	a1,a2
    800013b8:	8526                	mv	a0,s1
    800013ba:	00000097          	auipc	ra,0x0
    800013be:	f8e080e7          	jalr	-114(ra) # 80001348 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800013c2:	4719                	li	a4,6
    800013c4:	004006b7          	lui	a3,0x400
    800013c8:	0c000637          	lui	a2,0xc000
    800013cc:	85b2                	mv	a1,a2
    800013ce:	8526                	mv	a0,s1
    800013d0:	00000097          	auipc	ra,0x0
    800013d4:	f78080e7          	jalr	-136(ra) # 80001348 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800013d8:	00007917          	auipc	s2,0x7
    800013dc:	c2890913          	addi	s2,s2,-984 # 80008000 <etext>
    800013e0:	4729                	li	a4,10
    800013e2:	80007697          	auipc	a3,0x80007
    800013e6:	c1e68693          	addi	a3,a3,-994 # 8000 <_entry-0x7fff8000>
    800013ea:	4605                	li	a2,1
    800013ec:	067e                	slli	a2,a2,0x1f
    800013ee:	85b2                	mv	a1,a2
    800013f0:	8526                	mv	a0,s1
    800013f2:	00000097          	auipc	ra,0x0
    800013f6:	f56080e7          	jalr	-170(ra) # 80001348 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800013fa:	4719                	li	a4,6
    800013fc:	46c5                	li	a3,17
    800013fe:	06ee                	slli	a3,a3,0x1b
    80001400:	412686b3          	sub	a3,a3,s2
    80001404:	864a                	mv	a2,s2
    80001406:	85ca                	mv	a1,s2
    80001408:	8526                	mv	a0,s1
    8000140a:	00000097          	auipc	ra,0x0
    8000140e:	f3e080e7          	jalr	-194(ra) # 80001348 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001412:	4729                	li	a4,10
    80001414:	6685                	lui	a3,0x1
    80001416:	00006617          	auipc	a2,0x6
    8000141a:	bea60613          	addi	a2,a2,-1046 # 80007000 <_trampoline>
    8000141e:	040005b7          	lui	a1,0x4000
    80001422:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001424:	05b2                	slli	a1,a1,0xc
    80001426:	8526                	mv	a0,s1
    80001428:	00000097          	auipc	ra,0x0
    8000142c:	f20080e7          	jalr	-224(ra) # 80001348 <kvmmap>
  proc_mapstacks(kpgtbl);
    80001430:	8526                	mv	a0,s1
    80001432:	00000097          	auipc	ra,0x0
    80001436:	72a080e7          	jalr	1834(ra) # 80001b5c <proc_mapstacks>
}
    8000143a:	8526                	mv	a0,s1
    8000143c:	60e2                	ld	ra,24(sp)
    8000143e:	6442                	ld	s0,16(sp)
    80001440:	64a2                	ld	s1,8(sp)
    80001442:	6902                	ld	s2,0(sp)
    80001444:	6105                	addi	sp,sp,32
    80001446:	8082                	ret

0000000080001448 <kvminit>:
{
    80001448:	1141                	addi	sp,sp,-16
    8000144a:	e406                	sd	ra,8(sp)
    8000144c:	e022                	sd	s0,0(sp)
    8000144e:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80001450:	00000097          	auipc	ra,0x0
    80001454:	f28080e7          	jalr	-216(ra) # 80001378 <kvmmake>
    80001458:	00007797          	auipc	a5,0x7
    8000145c:	68a7b423          	sd	a0,1672(a5) # 80008ae0 <kernel_pagetable>
}
    80001460:	60a2                	ld	ra,8(sp)
    80001462:	6402                	ld	s0,0(sp)
    80001464:	0141                	addi	sp,sp,16
    80001466:	8082                	ret

0000000080001468 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001468:	715d                	addi	sp,sp,-80
    8000146a:	e486                	sd	ra,72(sp)
    8000146c:	e0a2                	sd	s0,64(sp)
    8000146e:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001470:	03459793          	slli	a5,a1,0x34
    80001474:	e39d                	bnez	a5,8000149a <uvmunmap+0x32>
    80001476:	f84a                	sd	s2,48(sp)
    80001478:	f44e                	sd	s3,40(sp)
    8000147a:	f052                	sd	s4,32(sp)
    8000147c:	ec56                	sd	s5,24(sp)
    8000147e:	e85a                	sd	s6,16(sp)
    80001480:	e45e                	sd	s7,8(sp)
    80001482:	8a2a                	mv	s4,a0
    80001484:	892e                	mv	s2,a1
    80001486:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001488:	0632                	slli	a2,a2,0xc
    8000148a:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000148e:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001490:	6b05                	lui	s6,0x1
    80001492:	0935fb63          	bgeu	a1,s3,80001528 <uvmunmap+0xc0>
    80001496:	fc26                	sd	s1,56(sp)
    80001498:	a8a9                	j	800014f2 <uvmunmap+0x8a>
    8000149a:	fc26                	sd	s1,56(sp)
    8000149c:	f84a                	sd	s2,48(sp)
    8000149e:	f44e                	sd	s3,40(sp)
    800014a0:	f052                	sd	s4,32(sp)
    800014a2:	ec56                	sd	s5,24(sp)
    800014a4:	e85a                	sd	s6,16(sp)
    800014a6:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800014a8:	00007517          	auipc	a0,0x7
    800014ac:	c6850513          	addi	a0,a0,-920 # 80008110 <etext+0x110>
    800014b0:	fffff097          	auipc	ra,0xfffff
    800014b4:	0b0080e7          	jalr	176(ra) # 80000560 <panic>
      panic("uvmunmap: walk");
    800014b8:	00007517          	auipc	a0,0x7
    800014bc:	c7050513          	addi	a0,a0,-912 # 80008128 <etext+0x128>
    800014c0:	fffff097          	auipc	ra,0xfffff
    800014c4:	0a0080e7          	jalr	160(ra) # 80000560 <panic>
      panic("uvmunmap: not mapped");
    800014c8:	00007517          	auipc	a0,0x7
    800014cc:	c7050513          	addi	a0,a0,-912 # 80008138 <etext+0x138>
    800014d0:	fffff097          	auipc	ra,0xfffff
    800014d4:	090080e7          	jalr	144(ra) # 80000560 <panic>
      panic("uvmunmap: not a leaf");
    800014d8:	00007517          	auipc	a0,0x7
    800014dc:	c7850513          	addi	a0,a0,-904 # 80008150 <etext+0x150>
    800014e0:	fffff097          	auipc	ra,0xfffff
    800014e4:	080080e7          	jalr	128(ra) # 80000560 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800014e8:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800014ec:	995a                	add	s2,s2,s6
    800014ee:	03397c63          	bgeu	s2,s3,80001526 <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    800014f2:	4601                	li	a2,0
    800014f4:	85ca                	mv	a1,s2
    800014f6:	8552                	mv	a0,s4
    800014f8:	00000097          	auipc	ra,0x0
    800014fc:	cc2080e7          	jalr	-830(ra) # 800011ba <walk>
    80001500:	84aa                	mv	s1,a0
    80001502:	d95d                	beqz	a0,800014b8 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    80001504:	6108                	ld	a0,0(a0)
    80001506:	00157793          	andi	a5,a0,1
    8000150a:	dfdd                	beqz	a5,800014c8 <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000150c:	3ff57793          	andi	a5,a0,1023
    80001510:	fd7784e3          	beq	a5,s7,800014d8 <uvmunmap+0x70>
    if(do_free){
    80001514:	fc0a8ae3          	beqz	s5,800014e8 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    80001518:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000151a:	0532                	slli	a0,a0,0xc
    8000151c:	fffff097          	auipc	ra,0xfffff
    80001520:	542080e7          	jalr	1346(ra) # 80000a5e <kfree>
    80001524:	b7d1                	j	800014e8 <uvmunmap+0x80>
    80001526:	74e2                	ld	s1,56(sp)
    80001528:	7942                	ld	s2,48(sp)
    8000152a:	79a2                	ld	s3,40(sp)
    8000152c:	7a02                	ld	s4,32(sp)
    8000152e:	6ae2                	ld	s5,24(sp)
    80001530:	6b42                	ld	s6,16(sp)
    80001532:	6ba2                	ld	s7,8(sp)
  }
}
    80001534:	60a6                	ld	ra,72(sp)
    80001536:	6406                	ld	s0,64(sp)
    80001538:	6161                	addi	sp,sp,80
    8000153a:	8082                	ret

000000008000153c <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000153c:	1101                	addi	sp,sp,-32
    8000153e:	ec06                	sd	ra,24(sp)
    80001540:	e822                	sd	s0,16(sp)
    80001542:	e426                	sd	s1,8(sp)
    80001544:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001546:	fffff097          	auipc	ra,0xfffff
    8000154a:	6bc080e7          	jalr	1724(ra) # 80000c02 <kalloc>
    8000154e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001550:	c519                	beqz	a0,8000155e <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001552:	6605                	lui	a2,0x1
    80001554:	4581                	li	a1,0
    80001556:	00000097          	auipc	ra,0x0
    8000155a:	968080e7          	jalr	-1688(ra) # 80000ebe <memset>
  return pagetable;
}
    8000155e:	8526                	mv	a0,s1
    80001560:	60e2                	ld	ra,24(sp)
    80001562:	6442                	ld	s0,16(sp)
    80001564:	64a2                	ld	s1,8(sp)
    80001566:	6105                	addi	sp,sp,32
    80001568:	8082                	ret

000000008000156a <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000156a:	7179                	addi	sp,sp,-48
    8000156c:	f406                	sd	ra,40(sp)
    8000156e:	f022                	sd	s0,32(sp)
    80001570:	ec26                	sd	s1,24(sp)
    80001572:	e84a                	sd	s2,16(sp)
    80001574:	e44e                	sd	s3,8(sp)
    80001576:	e052                	sd	s4,0(sp)
    80001578:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000157a:	6785                	lui	a5,0x1
    8000157c:	04f67863          	bgeu	a2,a5,800015cc <uvmfirst+0x62>
    80001580:	8a2a                	mv	s4,a0
    80001582:	89ae                	mv	s3,a1
    80001584:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80001586:	fffff097          	auipc	ra,0xfffff
    8000158a:	67c080e7          	jalr	1660(ra) # 80000c02 <kalloc>
    8000158e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001590:	6605                	lui	a2,0x1
    80001592:	4581                	li	a1,0
    80001594:	00000097          	auipc	ra,0x0
    80001598:	92a080e7          	jalr	-1750(ra) # 80000ebe <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000159c:	4779                	li	a4,30
    8000159e:	86ca                	mv	a3,s2
    800015a0:	6605                	lui	a2,0x1
    800015a2:	4581                	li	a1,0
    800015a4:	8552                	mv	a0,s4
    800015a6:	00000097          	auipc	ra,0x0
    800015aa:	cfc080e7          	jalr	-772(ra) # 800012a2 <mappages>
  memmove(mem, src, sz);
    800015ae:	8626                	mv	a2,s1
    800015b0:	85ce                	mv	a1,s3
    800015b2:	854a                	mv	a0,s2
    800015b4:	00000097          	auipc	ra,0x0
    800015b8:	96e080e7          	jalr	-1682(ra) # 80000f22 <memmove>
}
    800015bc:	70a2                	ld	ra,40(sp)
    800015be:	7402                	ld	s0,32(sp)
    800015c0:	64e2                	ld	s1,24(sp)
    800015c2:	6942                	ld	s2,16(sp)
    800015c4:	69a2                	ld	s3,8(sp)
    800015c6:	6a02                	ld	s4,0(sp)
    800015c8:	6145                	addi	sp,sp,48
    800015ca:	8082                	ret
    panic("uvmfirst: more than a page");
    800015cc:	00007517          	auipc	a0,0x7
    800015d0:	b9c50513          	addi	a0,a0,-1124 # 80008168 <etext+0x168>
    800015d4:	fffff097          	auipc	ra,0xfffff
    800015d8:	f8c080e7          	jalr	-116(ra) # 80000560 <panic>

00000000800015dc <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800015dc:	1101                	addi	sp,sp,-32
    800015de:	ec06                	sd	ra,24(sp)
    800015e0:	e822                	sd	s0,16(sp)
    800015e2:	e426                	sd	s1,8(sp)
    800015e4:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800015e6:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800015e8:	00b67d63          	bgeu	a2,a1,80001602 <uvmdealloc+0x26>
    800015ec:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800015ee:	6785                	lui	a5,0x1
    800015f0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800015f2:	00f60733          	add	a4,a2,a5
    800015f6:	76fd                	lui	a3,0xfffff
    800015f8:	8f75                	and	a4,a4,a3
    800015fa:	97ae                	add	a5,a5,a1
    800015fc:	8ff5                	and	a5,a5,a3
    800015fe:	00f76863          	bltu	a4,a5,8000160e <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001602:	8526                	mv	a0,s1
    80001604:	60e2                	ld	ra,24(sp)
    80001606:	6442                	ld	s0,16(sp)
    80001608:	64a2                	ld	s1,8(sp)
    8000160a:	6105                	addi	sp,sp,32
    8000160c:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000160e:	8f99                	sub	a5,a5,a4
    80001610:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001612:	4685                	li	a3,1
    80001614:	0007861b          	sext.w	a2,a5
    80001618:	85ba                	mv	a1,a4
    8000161a:	00000097          	auipc	ra,0x0
    8000161e:	e4e080e7          	jalr	-434(ra) # 80001468 <uvmunmap>
    80001622:	b7c5                	j	80001602 <uvmdealloc+0x26>

0000000080001624 <uvmalloc>:
  if(newsz < oldsz)
    80001624:	0ab66f63          	bltu	a2,a1,800016e2 <uvmalloc+0xbe>
{
    80001628:	715d                	addi	sp,sp,-80
    8000162a:	e486                	sd	ra,72(sp)
    8000162c:	e0a2                	sd	s0,64(sp)
    8000162e:	f052                	sd	s4,32(sp)
    80001630:	ec56                	sd	s5,24(sp)
    80001632:	e85a                	sd	s6,16(sp)
    80001634:	0880                	addi	s0,sp,80
    80001636:	8b2a                	mv	s6,a0
    80001638:	8ab2                	mv	s5,a2
  oldsz = PGROUNDUP(oldsz);
    8000163a:	6785                	lui	a5,0x1
    8000163c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000163e:	95be                	add	a1,a1,a5
    80001640:	77fd                	lui	a5,0xfffff
    80001642:	00f5fa33          	and	s4,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001646:	0aca7063          	bgeu	s4,a2,800016e6 <uvmalloc+0xc2>
    8000164a:	fc26                	sd	s1,56(sp)
    8000164c:	f84a                	sd	s2,48(sp)
    8000164e:	f44e                	sd	s3,40(sp)
    80001650:	e45e                	sd	s7,8(sp)
    80001652:	8952                	mv	s2,s4
    memset(mem, 0, PGSIZE);
    80001654:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001656:	0126eb93          	ori	s7,a3,18
    mem = kalloc();
    8000165a:	fffff097          	auipc	ra,0xfffff
    8000165e:	5a8080e7          	jalr	1448(ra) # 80000c02 <kalloc>
    80001662:	84aa                	mv	s1,a0
    if(mem == 0){
    80001664:	c915                	beqz	a0,80001698 <uvmalloc+0x74>
    memset(mem, 0, PGSIZE);
    80001666:	864e                	mv	a2,s3
    80001668:	4581                	li	a1,0
    8000166a:	00000097          	auipc	ra,0x0
    8000166e:	854080e7          	jalr	-1964(ra) # 80000ebe <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001672:	875e                	mv	a4,s7
    80001674:	86a6                	mv	a3,s1
    80001676:	864e                	mv	a2,s3
    80001678:	85ca                	mv	a1,s2
    8000167a:	855a                	mv	a0,s6
    8000167c:	00000097          	auipc	ra,0x0
    80001680:	c26080e7          	jalr	-986(ra) # 800012a2 <mappages>
    80001684:	ed0d                	bnez	a0,800016be <uvmalloc+0x9a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001686:	994e                	add	s2,s2,s3
    80001688:	fd5969e3          	bltu	s2,s5,8000165a <uvmalloc+0x36>
  return newsz;
    8000168c:	8556                	mv	a0,s5
    8000168e:	74e2                	ld	s1,56(sp)
    80001690:	7942                	ld	s2,48(sp)
    80001692:	79a2                	ld	s3,40(sp)
    80001694:	6ba2                	ld	s7,8(sp)
    80001696:	a829                	j	800016b0 <uvmalloc+0x8c>
      uvmdealloc(pagetable, a, oldsz);
    80001698:	8652                	mv	a2,s4
    8000169a:	85ca                	mv	a1,s2
    8000169c:	855a                	mv	a0,s6
    8000169e:	00000097          	auipc	ra,0x0
    800016a2:	f3e080e7          	jalr	-194(ra) # 800015dc <uvmdealloc>
      return 0;
    800016a6:	4501                	li	a0,0
    800016a8:	74e2                	ld	s1,56(sp)
    800016aa:	7942                	ld	s2,48(sp)
    800016ac:	79a2                	ld	s3,40(sp)
    800016ae:	6ba2                	ld	s7,8(sp)
}
    800016b0:	60a6                	ld	ra,72(sp)
    800016b2:	6406                	ld	s0,64(sp)
    800016b4:	7a02                	ld	s4,32(sp)
    800016b6:	6ae2                	ld	s5,24(sp)
    800016b8:	6b42                	ld	s6,16(sp)
    800016ba:	6161                	addi	sp,sp,80
    800016bc:	8082                	ret
      kfree(mem);
    800016be:	8526                	mv	a0,s1
    800016c0:	fffff097          	auipc	ra,0xfffff
    800016c4:	39e080e7          	jalr	926(ra) # 80000a5e <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800016c8:	8652                	mv	a2,s4
    800016ca:	85ca                	mv	a1,s2
    800016cc:	855a                	mv	a0,s6
    800016ce:	00000097          	auipc	ra,0x0
    800016d2:	f0e080e7          	jalr	-242(ra) # 800015dc <uvmdealloc>
      return 0;
    800016d6:	4501                	li	a0,0
    800016d8:	74e2                	ld	s1,56(sp)
    800016da:	7942                	ld	s2,48(sp)
    800016dc:	79a2                	ld	s3,40(sp)
    800016de:	6ba2                	ld	s7,8(sp)
    800016e0:	bfc1                	j	800016b0 <uvmalloc+0x8c>
    return oldsz;
    800016e2:	852e                	mv	a0,a1
}
    800016e4:	8082                	ret
  return newsz;
    800016e6:	8532                	mv	a0,a2
    800016e8:	b7e1                	j	800016b0 <uvmalloc+0x8c>

00000000800016ea <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800016ea:	7179                	addi	sp,sp,-48
    800016ec:	f406                	sd	ra,40(sp)
    800016ee:	f022                	sd	s0,32(sp)
    800016f0:	ec26                	sd	s1,24(sp)
    800016f2:	e84a                	sd	s2,16(sp)
    800016f4:	e44e                	sd	s3,8(sp)
    800016f6:	e052                	sd	s4,0(sp)
    800016f8:	1800                	addi	s0,sp,48
    800016fa:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800016fc:	84aa                	mv	s1,a0
    800016fe:	6905                	lui	s2,0x1
    80001700:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001702:	4985                	li	s3,1
    80001704:	a829                	j	8000171e <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001706:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001708:	00c79513          	slli	a0,a5,0xc
    8000170c:	00000097          	auipc	ra,0x0
    80001710:	fde080e7          	jalr	-34(ra) # 800016ea <freewalk>
      pagetable[i] = 0;
    80001714:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001718:	04a1                	addi	s1,s1,8
    8000171a:	03248163          	beq	s1,s2,8000173c <freewalk+0x52>
    pte_t pte = pagetable[i];
    8000171e:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001720:	00f7f713          	andi	a4,a5,15
    80001724:	ff3701e3          	beq	a4,s3,80001706 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001728:	8b85                	andi	a5,a5,1
    8000172a:	d7fd                	beqz	a5,80001718 <freewalk+0x2e>
      panic("freewalk: leaf");
    8000172c:	00007517          	auipc	a0,0x7
    80001730:	a5c50513          	addi	a0,a0,-1444 # 80008188 <etext+0x188>
    80001734:	fffff097          	auipc	ra,0xfffff
    80001738:	e2c080e7          	jalr	-468(ra) # 80000560 <panic>
    }
  }
  kfree((void*)pagetable);
    8000173c:	8552                	mv	a0,s4
    8000173e:	fffff097          	auipc	ra,0xfffff
    80001742:	320080e7          	jalr	800(ra) # 80000a5e <kfree>
}
    80001746:	70a2                	ld	ra,40(sp)
    80001748:	7402                	ld	s0,32(sp)
    8000174a:	64e2                	ld	s1,24(sp)
    8000174c:	6942                	ld	s2,16(sp)
    8000174e:	69a2                	ld	s3,8(sp)
    80001750:	6a02                	ld	s4,0(sp)
    80001752:	6145                	addi	sp,sp,48
    80001754:	8082                	ret

0000000080001756 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001756:	1101                	addi	sp,sp,-32
    80001758:	ec06                	sd	ra,24(sp)
    8000175a:	e822                	sd	s0,16(sp)
    8000175c:	e426                	sd	s1,8(sp)
    8000175e:	1000                	addi	s0,sp,32
    80001760:	84aa                	mv	s1,a0
  if(sz > 0)
    80001762:	e999                	bnez	a1,80001778 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001764:	8526                	mv	a0,s1
    80001766:	00000097          	auipc	ra,0x0
    8000176a:	f84080e7          	jalr	-124(ra) # 800016ea <freewalk>
}
    8000176e:	60e2                	ld	ra,24(sp)
    80001770:	6442                	ld	s0,16(sp)
    80001772:	64a2                	ld	s1,8(sp)
    80001774:	6105                	addi	sp,sp,32
    80001776:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001778:	6785                	lui	a5,0x1
    8000177a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000177c:	95be                	add	a1,a1,a5
    8000177e:	4685                	li	a3,1
    80001780:	00c5d613          	srli	a2,a1,0xc
    80001784:	4581                	li	a1,0
    80001786:	00000097          	auipc	ra,0x0
    8000178a:	ce2080e7          	jalr	-798(ra) # 80001468 <uvmunmap>
    8000178e:	bfd9                	j	80001764 <uvmfree+0xe>

0000000080001790 <uvmcopy>:
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int
uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
    80001790:	715d                	addi	sp,sp,-80
    80001792:	e486                	sd	ra,72(sp)
    80001794:	e0a2                	sd	s0,64(sp)
    80001796:	f44e                	sd	s3,40(sp)
    80001798:	0880                	addi	s0,sp,80
  pte_t *pte;
  uint64 pa, i;
  uint flags;

  for(i = 0; i < sz; i += PGSIZE) {
    8000179a:	c279                	beqz	a2,80001860 <uvmcopy+0xd0>
    8000179c:	fc26                	sd	s1,56(sp)
    8000179e:	f84a                	sd	s2,48(sp)
    800017a0:	f052                	sd	s4,32(sp)
    800017a2:	ec56                	sd	s5,24(sp)
    800017a4:	e85a                	sd	s6,16(sp)
    800017a6:	e45e                	sd	s7,8(sp)
    800017a8:	8baa                	mv	s7,a0
    800017aa:	8b2e                	mv	s6,a1
    800017ac:	8ab2                	mv	s5,a2
    800017ae:	4481                	li	s1,0
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    *pte = (*pte & ~PTE_W) | PTE_COW;
    flags = (flags & ~PTE_W) | PTE_COW;
    if(mappages(new, i, PGSIZE, pa, flags) != 0){
    800017b0:	6a05                	lui	s4,0x1
    if((pte = walk(old, i, 0)) == 0)
    800017b2:	4601                	li	a2,0
    800017b4:	85a6                	mv	a1,s1
    800017b6:	855e                	mv	a0,s7
    800017b8:	00000097          	auipc	ra,0x0
    800017bc:	a02080e7          	jalr	-1534(ra) # 800011ba <walk>
    800017c0:	c931                	beqz	a0,80001814 <uvmcopy+0x84>
    if((*pte & PTE_V) == 0)
    800017c2:	6118                	ld	a4,0(a0)
    800017c4:	00177793          	andi	a5,a4,1
    800017c8:	cfb1                	beqz	a5,80001824 <uvmcopy+0x94>
    pa = PTE2PA(*pte);
    800017ca:	00a75913          	srli	s2,a4,0xa
    800017ce:	0932                	slli	s2,s2,0xc
    *pte = (*pte & ~PTE_W) | PTE_COW;
    800017d0:	f7b77793          	andi	a5,a4,-133
    800017d4:	0807e793          	ori	a5,a5,128
    800017d8:	e11c                	sd	a5,0(a0)
    if(mappages(new, i, PGSIZE, pa, flags) != 0){
    800017da:	37b77713          	andi	a4,a4,891
    800017de:	08076713          	ori	a4,a4,128
    800017e2:	86ca                	mv	a3,s2
    800017e4:	8652                	mv	a2,s4
    800017e6:	85a6                	mv	a1,s1
    800017e8:	855a                	mv	a0,s6
    800017ea:	00000097          	auipc	ra,0x0
    800017ee:	ab8080e7          	jalr	-1352(ra) # 800012a2 <mappages>
    800017f2:	89aa                	mv	s3,a0
    800017f4:	e121                	bnez	a0,80001834 <uvmcopy+0xa4>
      goto err;
    }
    increment_ref((void*)pa);
    800017f6:	854a                	mv	a0,s2
    800017f8:	fffff097          	auipc	ra,0xfffff
    800017fc:	48a080e7          	jalr	1162(ra) # 80000c82 <increment_ref>
  for(i = 0; i < sz; i += PGSIZE) {
    80001800:	94d2                	add	s1,s1,s4
    80001802:	fb54e8e3          	bltu	s1,s5,800017b2 <uvmcopy+0x22>
    80001806:	74e2                	ld	s1,56(sp)
    80001808:	7942                	ld	s2,48(sp)
    8000180a:	7a02                	ld	s4,32(sp)
    8000180c:	6ae2                	ld	s5,24(sp)
    8000180e:	6b42                	ld	s6,16(sp)
    80001810:	6ba2                	ld	s7,8(sp)
    80001812:	a089                	j	80001854 <uvmcopy+0xc4>
      panic("uvmcopy: pte should exist");
    80001814:	00007517          	auipc	a0,0x7
    80001818:	98450513          	addi	a0,a0,-1660 # 80008198 <etext+0x198>
    8000181c:	fffff097          	auipc	ra,0xfffff
    80001820:	d44080e7          	jalr	-700(ra) # 80000560 <panic>
      panic("uvmcopy: page not present");
    80001824:	00007517          	auipc	a0,0x7
    80001828:	99450513          	addi	a0,a0,-1644 # 800081b8 <etext+0x1b8>
    8000182c:	fffff097          	auipc	ra,0xfffff
    80001830:	d34080e7          	jalr	-716(ra) # 80000560 <panic>
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001834:	4685                	li	a3,1
    80001836:	00c4d613          	srli	a2,s1,0xc
    8000183a:	4581                	li	a1,0
    8000183c:	855a                	mv	a0,s6
    8000183e:	00000097          	auipc	ra,0x0
    80001842:	c2a080e7          	jalr	-982(ra) # 80001468 <uvmunmap>
  return -1;
    80001846:	59fd                	li	s3,-1
    80001848:	74e2                	ld	s1,56(sp)
    8000184a:	7942                	ld	s2,48(sp)
    8000184c:	7a02                	ld	s4,32(sp)
    8000184e:	6ae2                	ld	s5,24(sp)
    80001850:	6b42                	ld	s6,16(sp)
    80001852:	6ba2                	ld	s7,8(sp)
}
    80001854:	854e                	mv	a0,s3
    80001856:	60a6                	ld	ra,72(sp)
    80001858:	6406                	ld	s0,64(sp)
    8000185a:	79a2                	ld	s3,40(sp)
    8000185c:	6161                	addi	sp,sp,80
    8000185e:	8082                	ret
  return 0;
    80001860:	4981                	li	s3,0
    80001862:	bfcd                	j	80001854 <uvmcopy+0xc4>

0000000080001864 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001864:	1141                	addi	sp,sp,-16
    80001866:	e406                	sd	ra,8(sp)
    80001868:	e022                	sd	s0,0(sp)
    8000186a:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    8000186c:	4601                	li	a2,0
    8000186e:	00000097          	auipc	ra,0x0
    80001872:	94c080e7          	jalr	-1716(ra) # 800011ba <walk>
  if(pte == 0)
    80001876:	c901                	beqz	a0,80001886 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001878:	611c                	ld	a5,0(a0)
    8000187a:	9bbd                	andi	a5,a5,-17
    8000187c:	e11c                	sd	a5,0(a0)
}
    8000187e:	60a2                	ld	ra,8(sp)
    80001880:	6402                	ld	s0,0(sp)
    80001882:	0141                	addi	sp,sp,16
    80001884:	8082                	ret
    panic("uvmclear");
    80001886:	00007517          	auipc	a0,0x7
    8000188a:	95250513          	addi	a0,a0,-1710 # 800081d8 <etext+0x1d8>
    8000188e:	fffff097          	auipc	ra,0xfffff
    80001892:	cd2080e7          	jalr	-814(ra) # 80000560 <panic>

0000000080001896 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001896:	c6bd                	beqz	a3,80001904 <copyout+0x6e>
{
    80001898:	715d                	addi	sp,sp,-80
    8000189a:	e486                	sd	ra,72(sp)
    8000189c:	e0a2                	sd	s0,64(sp)
    8000189e:	fc26                	sd	s1,56(sp)
    800018a0:	f84a                	sd	s2,48(sp)
    800018a2:	f44e                	sd	s3,40(sp)
    800018a4:	f052                	sd	s4,32(sp)
    800018a6:	ec56                	sd	s5,24(sp)
    800018a8:	e85a                	sd	s6,16(sp)
    800018aa:	e45e                	sd	s7,8(sp)
    800018ac:	e062                	sd	s8,0(sp)
    800018ae:	0880                	addi	s0,sp,80
    800018b0:	8b2a                	mv	s6,a0
    800018b2:	8c2e                	mv	s8,a1
    800018b4:	8a32                	mv	s4,a2
    800018b6:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    800018b8:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    800018ba:	6a85                	lui	s5,0x1
    800018bc:	a015                	j	800018e0 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800018be:	9562                	add	a0,a0,s8
    800018c0:	0004861b          	sext.w	a2,s1
    800018c4:	85d2                	mv	a1,s4
    800018c6:	41250533          	sub	a0,a0,s2
    800018ca:	fffff097          	auipc	ra,0xfffff
    800018ce:	658080e7          	jalr	1624(ra) # 80000f22 <memmove>

    len -= n;
    800018d2:	409989b3          	sub	s3,s3,s1
    src += n;
    800018d6:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    800018d8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800018dc:	02098263          	beqz	s3,80001900 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    800018e0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800018e4:	85ca                	mv	a1,s2
    800018e6:	855a                	mv	a0,s6
    800018e8:	00000097          	auipc	ra,0x0
    800018ec:	978080e7          	jalr	-1672(ra) # 80001260 <walkaddr>
    if(pa0 == 0)
    800018f0:	cd01                	beqz	a0,80001908 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    800018f2:	418904b3          	sub	s1,s2,s8
    800018f6:	94d6                	add	s1,s1,s5
    if(n > len)
    800018f8:	fc99f3e3          	bgeu	s3,s1,800018be <copyout+0x28>
    800018fc:	84ce                	mv	s1,s3
    800018fe:	b7c1                	j	800018be <copyout+0x28>
  }
  return 0;
    80001900:	4501                	li	a0,0
    80001902:	a021                	j	8000190a <copyout+0x74>
    80001904:	4501                	li	a0,0
}
    80001906:	8082                	ret
      return -1;
    80001908:	557d                	li	a0,-1
}
    8000190a:	60a6                	ld	ra,72(sp)
    8000190c:	6406                	ld	s0,64(sp)
    8000190e:	74e2                	ld	s1,56(sp)
    80001910:	7942                	ld	s2,48(sp)
    80001912:	79a2                	ld	s3,40(sp)
    80001914:	7a02                	ld	s4,32(sp)
    80001916:	6ae2                	ld	s5,24(sp)
    80001918:	6b42                	ld	s6,16(sp)
    8000191a:	6ba2                	ld	s7,8(sp)
    8000191c:	6c02                	ld	s8,0(sp)
    8000191e:	6161                	addi	sp,sp,80
    80001920:	8082                	ret

0000000080001922 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001922:	caa5                	beqz	a3,80001992 <copyin+0x70>
{
    80001924:	715d                	addi	sp,sp,-80
    80001926:	e486                	sd	ra,72(sp)
    80001928:	e0a2                	sd	s0,64(sp)
    8000192a:	fc26                	sd	s1,56(sp)
    8000192c:	f84a                	sd	s2,48(sp)
    8000192e:	f44e                	sd	s3,40(sp)
    80001930:	f052                	sd	s4,32(sp)
    80001932:	ec56                	sd	s5,24(sp)
    80001934:	e85a                	sd	s6,16(sp)
    80001936:	e45e                	sd	s7,8(sp)
    80001938:	e062                	sd	s8,0(sp)
    8000193a:	0880                	addi	s0,sp,80
    8000193c:	8b2a                	mv	s6,a0
    8000193e:	8a2e                	mv	s4,a1
    80001940:	8c32                	mv	s8,a2
    80001942:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001944:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001946:	6a85                	lui	s5,0x1
    80001948:	a01d                	j	8000196e <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    8000194a:	018505b3          	add	a1,a0,s8
    8000194e:	0004861b          	sext.w	a2,s1
    80001952:	412585b3          	sub	a1,a1,s2
    80001956:	8552                	mv	a0,s4
    80001958:	fffff097          	auipc	ra,0xfffff
    8000195c:	5ca080e7          	jalr	1482(ra) # 80000f22 <memmove>

    len -= n;
    80001960:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001964:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001966:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000196a:	02098263          	beqz	s3,8000198e <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    8000196e:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001972:	85ca                	mv	a1,s2
    80001974:	855a                	mv	a0,s6
    80001976:	00000097          	auipc	ra,0x0
    8000197a:	8ea080e7          	jalr	-1814(ra) # 80001260 <walkaddr>
    if(pa0 == 0)
    8000197e:	cd01                	beqz	a0,80001996 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80001980:	418904b3          	sub	s1,s2,s8
    80001984:	94d6                	add	s1,s1,s5
    if(n > len)
    80001986:	fc99f2e3          	bgeu	s3,s1,8000194a <copyin+0x28>
    8000198a:	84ce                	mv	s1,s3
    8000198c:	bf7d                	j	8000194a <copyin+0x28>
  }
  return 0;
    8000198e:	4501                	li	a0,0
    80001990:	a021                	j	80001998 <copyin+0x76>
    80001992:	4501                	li	a0,0
}
    80001994:	8082                	ret
      return -1;
    80001996:	557d                	li	a0,-1
}
    80001998:	60a6                	ld	ra,72(sp)
    8000199a:	6406                	ld	s0,64(sp)
    8000199c:	74e2                	ld	s1,56(sp)
    8000199e:	7942                	ld	s2,48(sp)
    800019a0:	79a2                	ld	s3,40(sp)
    800019a2:	7a02                	ld	s4,32(sp)
    800019a4:	6ae2                	ld	s5,24(sp)
    800019a6:	6b42                	ld	s6,16(sp)
    800019a8:	6ba2                	ld	s7,8(sp)
    800019aa:	6c02                	ld	s8,0(sp)
    800019ac:	6161                	addi	sp,sp,80
    800019ae:	8082                	ret

00000000800019b0 <copyinstr>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    800019b0:	715d                	addi	sp,sp,-80
    800019b2:	e486                	sd	ra,72(sp)
    800019b4:	e0a2                	sd	s0,64(sp)
    800019b6:	fc26                	sd	s1,56(sp)
    800019b8:	f84a                	sd	s2,48(sp)
    800019ba:	f44e                	sd	s3,40(sp)
    800019bc:	f052                	sd	s4,32(sp)
    800019be:	ec56                	sd	s5,24(sp)
    800019c0:	e85a                	sd	s6,16(sp)
    800019c2:	e45e                	sd	s7,8(sp)
    800019c4:	0880                	addi	s0,sp,80
    800019c6:	8aaa                	mv	s5,a0
    800019c8:	89ae                	mv	s3,a1
    800019ca:	8bb2                	mv	s7,a2
    800019cc:	84b6                	mv	s1,a3
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    va0 = PGROUNDDOWN(srcva);
    800019ce:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800019d0:	6a05                	lui	s4,0x1
    800019d2:	a02d                	j	800019fc <copyinstr+0x4c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800019d4:	00078023          	sb	zero,0(a5)
    800019d8:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800019da:	0017c793          	xori	a5,a5,1
    800019de:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800019e2:	60a6                	ld	ra,72(sp)
    800019e4:	6406                	ld	s0,64(sp)
    800019e6:	74e2                	ld	s1,56(sp)
    800019e8:	7942                	ld	s2,48(sp)
    800019ea:	79a2                	ld	s3,40(sp)
    800019ec:	7a02                	ld	s4,32(sp)
    800019ee:	6ae2                	ld	s5,24(sp)
    800019f0:	6b42                	ld	s6,16(sp)
    800019f2:	6ba2                	ld	s7,8(sp)
    800019f4:	6161                	addi	sp,sp,80
    800019f6:	8082                	ret
    srcva = va0 + PGSIZE;
    800019f8:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    800019fc:	c8a1                	beqz	s1,80001a4c <copyinstr+0x9c>
    va0 = PGROUNDDOWN(srcva);
    800019fe:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    80001a02:	85ca                	mv	a1,s2
    80001a04:	8556                	mv	a0,s5
    80001a06:	00000097          	auipc	ra,0x0
    80001a0a:	85a080e7          	jalr	-1958(ra) # 80001260 <walkaddr>
    if(pa0 == 0)
    80001a0e:	c129                	beqz	a0,80001a50 <copyinstr+0xa0>
    n = PGSIZE - (srcva - va0);
    80001a10:	41790633          	sub	a2,s2,s7
    80001a14:	9652                	add	a2,a2,s4
    if(n > max)
    80001a16:	00c4f363          	bgeu	s1,a2,80001a1c <copyinstr+0x6c>
    80001a1a:	8626                	mv	a2,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80001a1c:	412b8bb3          	sub	s7,s7,s2
    80001a20:	9baa                	add	s7,s7,a0
    while(n > 0){
    80001a22:	da79                	beqz	a2,800019f8 <copyinstr+0x48>
    80001a24:	87ce                	mv	a5,s3
      if(*p == '\0'){
    80001a26:	413b86b3          	sub	a3,s7,s3
    while(n > 0){
    80001a2a:	964e                	add	a2,a2,s3
    80001a2c:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001a2e:	00f68733          	add	a4,a3,a5
    80001a32:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7fb9d090>
    80001a36:	df59                	beqz	a4,800019d4 <copyinstr+0x24>
        *dst = *p;
    80001a38:	00e78023          	sb	a4,0(a5)
      dst++;
    80001a3c:	0785                	addi	a5,a5,1
    while(n > 0){
    80001a3e:	fec797e3          	bne	a5,a2,80001a2c <copyinstr+0x7c>
    80001a42:	14fd                	addi	s1,s1,-1
    80001a44:	94ce                	add	s1,s1,s3
      --max;
    80001a46:	8c8d                	sub	s1,s1,a1
    80001a48:	89be                	mv	s3,a5
    80001a4a:	b77d                	j	800019f8 <copyinstr+0x48>
    80001a4c:	4781                	li	a5,0
    80001a4e:	b771                	j	800019da <copyinstr+0x2a>
      return -1;
    80001a50:	557d                	li	a0,-1
    80001a52:	bf41                	j	800019e2 <copyinstr+0x32>

0000000080001a54 <va2pa_helper>:

uint64
va2pa_helper(pagetable_t pagetable, uint64 va)
{
    80001a54:	1101                	addi	sp,sp,-32
    80001a56:	ec06                	sd	ra,24(sp)
    80001a58:	e822                	sd	s0,16(sp)
    80001a5a:	e426                	sd	s1,8(sp)
    80001a5c:	1000                	addi	s0,sp,32
    80001a5e:	84ae                	mv	s1,a1
    pte_t *pte;
    uint64 pa;

    pte = walk(pagetable, va, 0);
    80001a60:	4601                	li	a2,0
    80001a62:	fffff097          	auipc	ra,0xfffff
    80001a66:	758080e7          	jalr	1880(ra) # 800011ba <walk>
    if(pte == 0 || (*pte & PTE_V) == 0)
    80001a6a:	c10d                	beqz	a0,80001a8c <va2pa_helper+0x38>
    80001a6c:	611c                	ld	a5,0(a0)
    80001a6e:	0017f513          	andi	a0,a5,1
    80001a72:	c901                	beqz	a0,80001a82 <va2pa_helper+0x2e>
        return 0;
    pa = PTE2PA(*pte) | (va & 0xFFF);
    80001a74:	83a9                	srli	a5,a5,0xa
    80001a76:	07b2                	slli	a5,a5,0xc
    80001a78:	03449593          	slli	a1,s1,0x34
    80001a7c:	91d1                	srli	a1,a1,0x34
    80001a7e:	00b7e533          	or	a0,a5,a1
    return pa;
}
    80001a82:	60e2                	ld	ra,24(sp)
    80001a84:	6442                	ld	s0,16(sp)
    80001a86:	64a2                	ld	s1,8(sp)
    80001a88:	6105                	addi	sp,sp,32
    80001a8a:	8082                	ret
        return 0;
    80001a8c:	4501                	li	a0,0
    80001a8e:	bfd5                	j	80001a82 <va2pa_helper+0x2e>

0000000080001a90 <rr_scheduler>:
        (*sched_pointer)();
    }
}

void rr_scheduler(void)
{
    80001a90:	715d                	addi	sp,sp,-80
    80001a92:	e486                	sd	ra,72(sp)
    80001a94:	e0a2                	sd	s0,64(sp)
    80001a96:	fc26                	sd	s1,56(sp)
    80001a98:	f84a                	sd	s2,48(sp)
    80001a9a:	f44e                	sd	s3,40(sp)
    80001a9c:	f052                	sd	s4,32(sp)
    80001a9e:	ec56                	sd	s5,24(sp)
    80001aa0:	e85a                	sd	s6,16(sp)
    80001aa2:	e45e                	sd	s7,8(sp)
    80001aa4:	0880                	addi	s0,sp,80
    asm volatile("mv %0, tp" : "=r"(x));
    80001aa6:	8792                	mv	a5,tp
    int id = r_tp();
    80001aa8:	2781                	sext.w	a5,a5
    struct proc *p;
    struct cpu *c = mycpu();

    c->proc = 0;
    80001aaa:	0044fa17          	auipc	s4,0x44f
    80001aae:	2b6a0a13          	addi	s4,s4,694 # 80450d60 <cpus>
    80001ab2:	00779713          	slli	a4,a5,0x7
    80001ab6:	00ea06b3          	add	a3,s4,a4
    80001aba:	0006b023          	sd	zero,0(a3) # fffffffffffff000 <end+0xffffffff7fb9d090>
                // Switch to chosen process.  It is the process's job
                // to release its lock and then reacquire it
                // before jumping back to us.
                p->state = RUNNING;
                c->proc = p;
                swtch(&c->context, &p->context);
    80001abe:	0721                	addi	a4,a4,8
    80001ac0:	9a3a                	add	s4,s4,a4
            if (p->state == RUNNABLE)
    80001ac2:	498d                	li	s3,3
                p->state = RUNNING;
    80001ac4:	4b91                	li	s7,4
                c->proc = p;
    80001ac6:	8936                	mv	s2,a3
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80001ac8:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001acc:	0027e793          	ori	a5,a5,2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80001ad0:	10079073          	csrw	sstatus,a5
        for (p = proc; p < &proc[NPROC]; p++)
    80001ad4:	0044f497          	auipc	s1,0x44f
    80001ad8:	6bc48493          	addi	s1,s1,1724 # 80451190 <proc>
                // check if we are still the right scheduler (or if schedset changed)
                if (sched_pointer != &rr_scheduler)
    80001adc:	00007b17          	auipc	s6,0x7
    80001ae0:	f5cb0b13          	addi	s6,s6,-164 # 80008a38 <sched_pointer>
    80001ae4:	00000a97          	auipc	s5,0x0
    80001ae8:	faca8a93          	addi	s5,s5,-84 # 80001a90 <rr_scheduler>
    80001aec:	a835                	j	80001b28 <rr_scheduler+0x98>
                {
                    release(&p->lock);
    80001aee:	8526                	mv	a0,s1
    80001af0:	fffff097          	auipc	ra,0xfffff
    80001af4:	386080e7          	jalr	902(ra) # 80000e76 <release>
                c->proc = 0;
            }
            release(&p->lock);
        }
    }
}
    80001af8:	60a6                	ld	ra,72(sp)
    80001afa:	6406                	ld	s0,64(sp)
    80001afc:	74e2                	ld	s1,56(sp)
    80001afe:	7942                	ld	s2,48(sp)
    80001b00:	79a2                	ld	s3,40(sp)
    80001b02:	7a02                	ld	s4,32(sp)
    80001b04:	6ae2                	ld	s5,24(sp)
    80001b06:	6b42                	ld	s6,16(sp)
    80001b08:	6ba2                	ld	s7,8(sp)
    80001b0a:	6161                	addi	sp,sp,80
    80001b0c:	8082                	ret
            release(&p->lock);
    80001b0e:	8526                	mv	a0,s1
    80001b10:	fffff097          	auipc	ra,0xfffff
    80001b14:	366080e7          	jalr	870(ra) # 80000e76 <release>
        for (p = proc; p < &proc[NPROC]; p++)
    80001b18:	16848493          	addi	s1,s1,360
    80001b1c:	00455797          	auipc	a5,0x455
    80001b20:	07478793          	addi	a5,a5,116 # 80456b90 <tickslock>
    80001b24:	faf482e3          	beq	s1,a5,80001ac8 <rr_scheduler+0x38>
            acquire(&p->lock);
    80001b28:	8526                	mv	a0,s1
    80001b2a:	fffff097          	auipc	ra,0xfffff
    80001b2e:	29c080e7          	jalr	668(ra) # 80000dc6 <acquire>
            if (p->state == RUNNABLE)
    80001b32:	4c9c                	lw	a5,24(s1)
    80001b34:	fd379de3          	bne	a5,s3,80001b0e <rr_scheduler+0x7e>
                p->state = RUNNING;
    80001b38:	0174ac23          	sw	s7,24(s1)
                c->proc = p;
    80001b3c:	00993023          	sd	s1,0(s2) # 1000 <_entry-0x7ffff000>
                swtch(&c->context, &p->context);
    80001b40:	06048593          	addi	a1,s1,96
    80001b44:	8552                	mv	a0,s4
    80001b46:	00001097          	auipc	ra,0x1
    80001b4a:	fcc080e7          	jalr	-52(ra) # 80002b12 <swtch>
                if (sched_pointer != &rr_scheduler)
    80001b4e:	000b3783          	ld	a5,0(s6)
    80001b52:	f9579ee3          	bne	a5,s5,80001aee <rr_scheduler+0x5e>
                c->proc = 0;
    80001b56:	00093023          	sd	zero,0(s2)
    80001b5a:	bf55                	j	80001b0e <rr_scheduler+0x7e>

0000000080001b5c <proc_mapstacks>:
{
    80001b5c:	715d                	addi	sp,sp,-80
    80001b5e:	e486                	sd	ra,72(sp)
    80001b60:	e0a2                	sd	s0,64(sp)
    80001b62:	fc26                	sd	s1,56(sp)
    80001b64:	f84a                	sd	s2,48(sp)
    80001b66:	f44e                	sd	s3,40(sp)
    80001b68:	f052                	sd	s4,32(sp)
    80001b6a:	ec56                	sd	s5,24(sp)
    80001b6c:	e85a                	sd	s6,16(sp)
    80001b6e:	e45e                	sd	s7,8(sp)
    80001b70:	e062                	sd	s8,0(sp)
    80001b72:	0880                	addi	s0,sp,80
    80001b74:	8a2a                	mv	s4,a0
    for (p = proc; p < &proc[NPROC]; p++)
    80001b76:	0044f497          	auipc	s1,0x44f
    80001b7a:	61a48493          	addi	s1,s1,1562 # 80451190 <proc>
        uint64 va = KSTACK((int)(p - proc));
    80001b7e:	8c26                	mv	s8,s1
    80001b80:	a4fa57b7          	lui	a5,0xa4fa5
    80001b84:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff24b43035>
    80001b88:	4fa50937          	lui	s2,0x4fa50
    80001b8c:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x305b05b0>
    80001b90:	1902                	slli	s2,s2,0x20
    80001b92:	993e                	add	s2,s2,a5
    80001b94:	040009b7          	lui	s3,0x4000
    80001b98:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001b9a:	09b2                	slli	s3,s3,0xc
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001b9c:	4b99                	li	s7,6
    80001b9e:	6b05                	lui	s6,0x1
    for (p = proc; p < &proc[NPROC]; p++)
    80001ba0:	00455a97          	auipc	s5,0x455
    80001ba4:	ff0a8a93          	addi	s5,s5,-16 # 80456b90 <tickslock>
        char *pa = kalloc();
    80001ba8:	fffff097          	auipc	ra,0xfffff
    80001bac:	05a080e7          	jalr	90(ra) # 80000c02 <kalloc>
    80001bb0:	862a                	mv	a2,a0
        if (pa == 0)
    80001bb2:	c131                	beqz	a0,80001bf6 <proc_mapstacks+0x9a>
        uint64 va = KSTACK((int)(p - proc));
    80001bb4:	418485b3          	sub	a1,s1,s8
    80001bb8:	858d                	srai	a1,a1,0x3
    80001bba:	032585b3          	mul	a1,a1,s2
    80001bbe:	2585                	addiw	a1,a1,1
    80001bc0:	00d5959b          	slliw	a1,a1,0xd
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001bc4:	875e                	mv	a4,s7
    80001bc6:	86da                	mv	a3,s6
    80001bc8:	40b985b3          	sub	a1,s3,a1
    80001bcc:	8552                	mv	a0,s4
    80001bce:	fffff097          	auipc	ra,0xfffff
    80001bd2:	77a080e7          	jalr	1914(ra) # 80001348 <kvmmap>
    for (p = proc; p < &proc[NPROC]; p++)
    80001bd6:	16848493          	addi	s1,s1,360
    80001bda:	fd5497e3          	bne	s1,s5,80001ba8 <proc_mapstacks+0x4c>
}
    80001bde:	60a6                	ld	ra,72(sp)
    80001be0:	6406                	ld	s0,64(sp)
    80001be2:	74e2                	ld	s1,56(sp)
    80001be4:	7942                	ld	s2,48(sp)
    80001be6:	79a2                	ld	s3,40(sp)
    80001be8:	7a02                	ld	s4,32(sp)
    80001bea:	6ae2                	ld	s5,24(sp)
    80001bec:	6b42                	ld	s6,16(sp)
    80001bee:	6ba2                	ld	s7,8(sp)
    80001bf0:	6c02                	ld	s8,0(sp)
    80001bf2:	6161                	addi	sp,sp,80
    80001bf4:	8082                	ret
            panic("kalloc");
    80001bf6:	00006517          	auipc	a0,0x6
    80001bfa:	5f250513          	addi	a0,a0,1522 # 800081e8 <etext+0x1e8>
    80001bfe:	fffff097          	auipc	ra,0xfffff
    80001c02:	962080e7          	jalr	-1694(ra) # 80000560 <panic>

0000000080001c06 <procinit>:
{
    80001c06:	7139                	addi	sp,sp,-64
    80001c08:	fc06                	sd	ra,56(sp)
    80001c0a:	f822                	sd	s0,48(sp)
    80001c0c:	f426                	sd	s1,40(sp)
    80001c0e:	f04a                	sd	s2,32(sp)
    80001c10:	ec4e                	sd	s3,24(sp)
    80001c12:	e852                	sd	s4,16(sp)
    80001c14:	e456                	sd	s5,8(sp)
    80001c16:	e05a                	sd	s6,0(sp)
    80001c18:	0080                	addi	s0,sp,64
    initlock(&pid_lock, "nextpid");
    80001c1a:	00006597          	auipc	a1,0x6
    80001c1e:	5d658593          	addi	a1,a1,1494 # 800081f0 <etext+0x1f0>
    80001c22:	0044f517          	auipc	a0,0x44f
    80001c26:	53e50513          	addi	a0,a0,1342 # 80451160 <pid_lock>
    80001c2a:	fffff097          	auipc	ra,0xfffff
    80001c2e:	108080e7          	jalr	264(ra) # 80000d32 <initlock>
    initlock(&wait_lock, "wait_lock");
    80001c32:	00006597          	auipc	a1,0x6
    80001c36:	5c658593          	addi	a1,a1,1478 # 800081f8 <etext+0x1f8>
    80001c3a:	0044f517          	auipc	a0,0x44f
    80001c3e:	53e50513          	addi	a0,a0,1342 # 80451178 <wait_lock>
    80001c42:	fffff097          	auipc	ra,0xfffff
    80001c46:	0f0080e7          	jalr	240(ra) # 80000d32 <initlock>
    for (p = proc; p < &proc[NPROC]; p++)
    80001c4a:	0044f497          	auipc	s1,0x44f
    80001c4e:	54648493          	addi	s1,s1,1350 # 80451190 <proc>
        initlock(&p->lock, "proc");
    80001c52:	00006b17          	auipc	s6,0x6
    80001c56:	5b6b0b13          	addi	s6,s6,1462 # 80008208 <etext+0x208>
        p->kstack = KSTACK((int)(p - proc));
    80001c5a:	8aa6                	mv	s5,s1
    80001c5c:	a4fa57b7          	lui	a5,0xa4fa5
    80001c60:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff24b43035>
    80001c64:	4fa50937          	lui	s2,0x4fa50
    80001c68:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x305b05b0>
    80001c6c:	1902                	slli	s2,s2,0x20
    80001c6e:	993e                	add	s2,s2,a5
    80001c70:	040009b7          	lui	s3,0x4000
    80001c74:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001c76:	09b2                	slli	s3,s3,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    80001c78:	00455a17          	auipc	s4,0x455
    80001c7c:	f18a0a13          	addi	s4,s4,-232 # 80456b90 <tickslock>
        initlock(&p->lock, "proc");
    80001c80:	85da                	mv	a1,s6
    80001c82:	8526                	mv	a0,s1
    80001c84:	fffff097          	auipc	ra,0xfffff
    80001c88:	0ae080e7          	jalr	174(ra) # 80000d32 <initlock>
        p->state = UNUSED;
    80001c8c:	0004ac23          	sw	zero,24(s1)
        p->kstack = KSTACK((int)(p - proc));
    80001c90:	415487b3          	sub	a5,s1,s5
    80001c94:	878d                	srai	a5,a5,0x3
    80001c96:	032787b3          	mul	a5,a5,s2
    80001c9a:	2785                	addiw	a5,a5,1
    80001c9c:	00d7979b          	slliw	a5,a5,0xd
    80001ca0:	40f987b3          	sub	a5,s3,a5
    80001ca4:	e0bc                	sd	a5,64(s1)
    for (p = proc; p < &proc[NPROC]; p++)
    80001ca6:	16848493          	addi	s1,s1,360
    80001caa:	fd449be3          	bne	s1,s4,80001c80 <procinit+0x7a>
}
    80001cae:	70e2                	ld	ra,56(sp)
    80001cb0:	7442                	ld	s0,48(sp)
    80001cb2:	74a2                	ld	s1,40(sp)
    80001cb4:	7902                	ld	s2,32(sp)
    80001cb6:	69e2                	ld	s3,24(sp)
    80001cb8:	6a42                	ld	s4,16(sp)
    80001cba:	6aa2                	ld	s5,8(sp)
    80001cbc:	6b02                	ld	s6,0(sp)
    80001cbe:	6121                	addi	sp,sp,64
    80001cc0:	8082                	ret

0000000080001cc2 <copy_array>:
{
    80001cc2:	1141                	addi	sp,sp,-16
    80001cc4:	e406                	sd	ra,8(sp)
    80001cc6:	e022                	sd	s0,0(sp)
    80001cc8:	0800                	addi	s0,sp,16
    for (int i = 0; i < len; i++)
    80001cca:	00c05c63          	blez	a2,80001ce2 <copy_array+0x20>
    80001cce:	87aa                	mv	a5,a0
    80001cd0:	9532                	add	a0,a0,a2
        dst[i] = src[i];
    80001cd2:	0007c703          	lbu	a4,0(a5)
    80001cd6:	00e58023          	sb	a4,0(a1)
    for (int i = 0; i < len; i++)
    80001cda:	0785                	addi	a5,a5,1
    80001cdc:	0585                	addi	a1,a1,1
    80001cde:	fea79ae3          	bne	a5,a0,80001cd2 <copy_array+0x10>
}
    80001ce2:	60a2                	ld	ra,8(sp)
    80001ce4:	6402                	ld	s0,0(sp)
    80001ce6:	0141                	addi	sp,sp,16
    80001ce8:	8082                	ret

0000000080001cea <cpuid>:
{
    80001cea:	1141                	addi	sp,sp,-16
    80001cec:	e406                	sd	ra,8(sp)
    80001cee:	e022                	sd	s0,0(sp)
    80001cf0:	0800                	addi	s0,sp,16
    asm volatile("mv %0, tp" : "=r"(x));
    80001cf2:	8512                	mv	a0,tp
}
    80001cf4:	2501                	sext.w	a0,a0
    80001cf6:	60a2                	ld	ra,8(sp)
    80001cf8:	6402                	ld	s0,0(sp)
    80001cfa:	0141                	addi	sp,sp,16
    80001cfc:	8082                	ret

0000000080001cfe <mycpu>:
{
    80001cfe:	1141                	addi	sp,sp,-16
    80001d00:	e406                	sd	ra,8(sp)
    80001d02:	e022                	sd	s0,0(sp)
    80001d04:	0800                	addi	s0,sp,16
    80001d06:	8792                	mv	a5,tp
    struct cpu *c = &cpus[id];
    80001d08:	2781                	sext.w	a5,a5
    80001d0a:	079e                	slli	a5,a5,0x7
}
    80001d0c:	0044f517          	auipc	a0,0x44f
    80001d10:	05450513          	addi	a0,a0,84 # 80450d60 <cpus>
    80001d14:	953e                	add	a0,a0,a5
    80001d16:	60a2                	ld	ra,8(sp)
    80001d18:	6402                	ld	s0,0(sp)
    80001d1a:	0141                	addi	sp,sp,16
    80001d1c:	8082                	ret

0000000080001d1e <myproc>:
{
    80001d1e:	1101                	addi	sp,sp,-32
    80001d20:	ec06                	sd	ra,24(sp)
    80001d22:	e822                	sd	s0,16(sp)
    80001d24:	e426                	sd	s1,8(sp)
    80001d26:	1000                	addi	s0,sp,32
    push_off();
    80001d28:	fffff097          	auipc	ra,0xfffff
    80001d2c:	052080e7          	jalr	82(ra) # 80000d7a <push_off>
    80001d30:	8792                	mv	a5,tp
    struct proc *p = c->proc;
    80001d32:	2781                	sext.w	a5,a5
    80001d34:	079e                	slli	a5,a5,0x7
    80001d36:	0044f717          	auipc	a4,0x44f
    80001d3a:	02a70713          	addi	a4,a4,42 # 80450d60 <cpus>
    80001d3e:	97ba                	add	a5,a5,a4
    80001d40:	6384                	ld	s1,0(a5)
    pop_off();
    80001d42:	fffff097          	auipc	ra,0xfffff
    80001d46:	0d8080e7          	jalr	216(ra) # 80000e1a <pop_off>
}
    80001d4a:	8526                	mv	a0,s1
    80001d4c:	60e2                	ld	ra,24(sp)
    80001d4e:	6442                	ld	s0,16(sp)
    80001d50:	64a2                	ld	s1,8(sp)
    80001d52:	6105                	addi	sp,sp,32
    80001d54:	8082                	ret

0000000080001d56 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80001d56:	1141                	addi	sp,sp,-16
    80001d58:	e406                	sd	ra,8(sp)
    80001d5a:	e022                	sd	s0,0(sp)
    80001d5c:	0800                	addi	s0,sp,16
    static int first = 1;

    // Still holding p->lock from scheduler.
    release(&myproc()->lock);
    80001d5e:	00000097          	auipc	ra,0x0
    80001d62:	fc0080e7          	jalr	-64(ra) # 80001d1e <myproc>
    80001d66:	fffff097          	auipc	ra,0xfffff
    80001d6a:	110080e7          	jalr	272(ra) # 80000e76 <release>

    if (first)
    80001d6e:	00007797          	auipc	a5,0x7
    80001d72:	cc27a783          	lw	a5,-830(a5) # 80008a30 <first.1>
    80001d76:	eb89                	bnez	a5,80001d88 <forkret+0x32>
        // be run from main().
        first = 0;
        fsinit(ROOTDEV);
    }

    usertrapret();
    80001d78:	00001097          	auipc	ra,0x1
    80001d7c:	e48080e7          	jalr	-440(ra) # 80002bc0 <usertrapret>
}
    80001d80:	60a2                	ld	ra,8(sp)
    80001d82:	6402                	ld	s0,0(sp)
    80001d84:	0141                	addi	sp,sp,16
    80001d86:	8082                	ret
        first = 0;
    80001d88:	00007797          	auipc	a5,0x7
    80001d8c:	ca07a423          	sw	zero,-856(a5) # 80008a30 <first.1>
        fsinit(ROOTDEV);
    80001d90:	4505                	li	a0,1
    80001d92:	00002097          	auipc	ra,0x2
    80001d96:	e04080e7          	jalr	-508(ra) # 80003b96 <fsinit>
    80001d9a:	bff9                	j	80001d78 <forkret+0x22>

0000000080001d9c <allocpid>:
{
    80001d9c:	1101                	addi	sp,sp,-32
    80001d9e:	ec06                	sd	ra,24(sp)
    80001da0:	e822                	sd	s0,16(sp)
    80001da2:	e426                	sd	s1,8(sp)
    80001da4:	e04a                	sd	s2,0(sp)
    80001da6:	1000                	addi	s0,sp,32
    acquire(&pid_lock);
    80001da8:	0044f917          	auipc	s2,0x44f
    80001dac:	3b890913          	addi	s2,s2,952 # 80451160 <pid_lock>
    80001db0:	854a                	mv	a0,s2
    80001db2:	fffff097          	auipc	ra,0xfffff
    80001db6:	014080e7          	jalr	20(ra) # 80000dc6 <acquire>
    pid = nextpid;
    80001dba:	00007797          	auipc	a5,0x7
    80001dbe:	c8678793          	addi	a5,a5,-890 # 80008a40 <nextpid>
    80001dc2:	4384                	lw	s1,0(a5)
    nextpid = nextpid + 1;
    80001dc4:	0014871b          	addiw	a4,s1,1
    80001dc8:	c398                	sw	a4,0(a5)
    release(&pid_lock);
    80001dca:	854a                	mv	a0,s2
    80001dcc:	fffff097          	auipc	ra,0xfffff
    80001dd0:	0aa080e7          	jalr	170(ra) # 80000e76 <release>
}
    80001dd4:	8526                	mv	a0,s1
    80001dd6:	60e2                	ld	ra,24(sp)
    80001dd8:	6442                	ld	s0,16(sp)
    80001dda:	64a2                	ld	s1,8(sp)
    80001ddc:	6902                	ld	s2,0(sp)
    80001dde:	6105                	addi	sp,sp,32
    80001de0:	8082                	ret

0000000080001de2 <proc_pagetable>:
{
    80001de2:	1101                	addi	sp,sp,-32
    80001de4:	ec06                	sd	ra,24(sp)
    80001de6:	e822                	sd	s0,16(sp)
    80001de8:	e426                	sd	s1,8(sp)
    80001dea:	e04a                	sd	s2,0(sp)
    80001dec:	1000                	addi	s0,sp,32
    80001dee:	892a                	mv	s2,a0
    pagetable = uvmcreate();
    80001df0:	fffff097          	auipc	ra,0xfffff
    80001df4:	74c080e7          	jalr	1868(ra) # 8000153c <uvmcreate>
    80001df8:	84aa                	mv	s1,a0
    if (pagetable == 0)
    80001dfa:	c121                	beqz	a0,80001e3a <proc_pagetable+0x58>
    if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001dfc:	4729                	li	a4,10
    80001dfe:	00005697          	auipc	a3,0x5
    80001e02:	20268693          	addi	a3,a3,514 # 80007000 <_trampoline>
    80001e06:	6605                	lui	a2,0x1
    80001e08:	040005b7          	lui	a1,0x4000
    80001e0c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001e0e:	05b2                	slli	a1,a1,0xc
    80001e10:	fffff097          	auipc	ra,0xfffff
    80001e14:	492080e7          	jalr	1170(ra) # 800012a2 <mappages>
    80001e18:	02054863          	bltz	a0,80001e48 <proc_pagetable+0x66>
    if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80001e1c:	4719                	li	a4,6
    80001e1e:	05893683          	ld	a3,88(s2)
    80001e22:	6605                	lui	a2,0x1
    80001e24:	020005b7          	lui	a1,0x2000
    80001e28:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001e2a:	05b6                	slli	a1,a1,0xd
    80001e2c:	8526                	mv	a0,s1
    80001e2e:	fffff097          	auipc	ra,0xfffff
    80001e32:	474080e7          	jalr	1140(ra) # 800012a2 <mappages>
    80001e36:	02054163          	bltz	a0,80001e58 <proc_pagetable+0x76>
}
    80001e3a:	8526                	mv	a0,s1
    80001e3c:	60e2                	ld	ra,24(sp)
    80001e3e:	6442                	ld	s0,16(sp)
    80001e40:	64a2                	ld	s1,8(sp)
    80001e42:	6902                	ld	s2,0(sp)
    80001e44:	6105                	addi	sp,sp,32
    80001e46:	8082                	ret
        uvmfree(pagetable, 0);
    80001e48:	4581                	li	a1,0
    80001e4a:	8526                	mv	a0,s1
    80001e4c:	00000097          	auipc	ra,0x0
    80001e50:	90a080e7          	jalr	-1782(ra) # 80001756 <uvmfree>
        return 0;
    80001e54:	4481                	li	s1,0
    80001e56:	b7d5                	j	80001e3a <proc_pagetable+0x58>
        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001e58:	4681                	li	a3,0
    80001e5a:	4605                	li	a2,1
    80001e5c:	040005b7          	lui	a1,0x4000
    80001e60:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001e62:	05b2                	slli	a1,a1,0xc
    80001e64:	8526                	mv	a0,s1
    80001e66:	fffff097          	auipc	ra,0xfffff
    80001e6a:	602080e7          	jalr	1538(ra) # 80001468 <uvmunmap>
        uvmfree(pagetable, 0);
    80001e6e:	4581                	li	a1,0
    80001e70:	8526                	mv	a0,s1
    80001e72:	00000097          	auipc	ra,0x0
    80001e76:	8e4080e7          	jalr	-1820(ra) # 80001756 <uvmfree>
        return 0;
    80001e7a:	4481                	li	s1,0
    80001e7c:	bf7d                	j	80001e3a <proc_pagetable+0x58>

0000000080001e7e <proc_freepagetable>:
{
    80001e7e:	1101                	addi	sp,sp,-32
    80001e80:	ec06                	sd	ra,24(sp)
    80001e82:	e822                	sd	s0,16(sp)
    80001e84:	e426                	sd	s1,8(sp)
    80001e86:	e04a                	sd	s2,0(sp)
    80001e88:	1000                	addi	s0,sp,32
    80001e8a:	84aa                	mv	s1,a0
    80001e8c:	892e                	mv	s2,a1
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001e8e:	4681                	li	a3,0
    80001e90:	4605                	li	a2,1
    80001e92:	040005b7          	lui	a1,0x4000
    80001e96:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001e98:	05b2                	slli	a1,a1,0xc
    80001e9a:	fffff097          	auipc	ra,0xfffff
    80001e9e:	5ce080e7          	jalr	1486(ra) # 80001468 <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001ea2:	4681                	li	a3,0
    80001ea4:	4605                	li	a2,1
    80001ea6:	020005b7          	lui	a1,0x2000
    80001eaa:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001eac:	05b6                	slli	a1,a1,0xd
    80001eae:	8526                	mv	a0,s1
    80001eb0:	fffff097          	auipc	ra,0xfffff
    80001eb4:	5b8080e7          	jalr	1464(ra) # 80001468 <uvmunmap>
    uvmfree(pagetable, sz);
    80001eb8:	85ca                	mv	a1,s2
    80001eba:	8526                	mv	a0,s1
    80001ebc:	00000097          	auipc	ra,0x0
    80001ec0:	89a080e7          	jalr	-1894(ra) # 80001756 <uvmfree>
}
    80001ec4:	60e2                	ld	ra,24(sp)
    80001ec6:	6442                	ld	s0,16(sp)
    80001ec8:	64a2                	ld	s1,8(sp)
    80001eca:	6902                	ld	s2,0(sp)
    80001ecc:	6105                	addi	sp,sp,32
    80001ece:	8082                	ret

0000000080001ed0 <freeproc>:
{
    80001ed0:	1101                	addi	sp,sp,-32
    80001ed2:	ec06                	sd	ra,24(sp)
    80001ed4:	e822                	sd	s0,16(sp)
    80001ed6:	e426                	sd	s1,8(sp)
    80001ed8:	1000                	addi	s0,sp,32
    80001eda:	84aa                	mv	s1,a0
    if (p->trapframe)
    80001edc:	6d28                	ld	a0,88(a0)
    80001ede:	c509                	beqz	a0,80001ee8 <freeproc+0x18>
        kfree((void *)p->trapframe);
    80001ee0:	fffff097          	auipc	ra,0xfffff
    80001ee4:	b7e080e7          	jalr	-1154(ra) # 80000a5e <kfree>
    p->trapframe = 0;
    80001ee8:	0404bc23          	sd	zero,88(s1)
    if (p->pagetable)
    80001eec:	68a8                	ld	a0,80(s1)
    80001eee:	c511                	beqz	a0,80001efa <freeproc+0x2a>
        proc_freepagetable(p->pagetable, p->sz);
    80001ef0:	64ac                	ld	a1,72(s1)
    80001ef2:	00000097          	auipc	ra,0x0
    80001ef6:	f8c080e7          	jalr	-116(ra) # 80001e7e <proc_freepagetable>
    p->pagetable = 0;
    80001efa:	0404b823          	sd	zero,80(s1)
    p->sz = 0;
    80001efe:	0404b423          	sd	zero,72(s1)
    p->pid = 0;
    80001f02:	0204a823          	sw	zero,48(s1)
    p->parent = 0;
    80001f06:	0204bc23          	sd	zero,56(s1)
    p->name[0] = 0;
    80001f0a:	14048c23          	sb	zero,344(s1)
    p->chan = 0;
    80001f0e:	0204b023          	sd	zero,32(s1)
    p->killed = 0;
    80001f12:	0204a423          	sw	zero,40(s1)
    p->xstate = 0;
    80001f16:	0204a623          	sw	zero,44(s1)
    p->state = UNUSED;
    80001f1a:	0004ac23          	sw	zero,24(s1)
}
    80001f1e:	60e2                	ld	ra,24(sp)
    80001f20:	6442                	ld	s0,16(sp)
    80001f22:	64a2                	ld	s1,8(sp)
    80001f24:	6105                	addi	sp,sp,32
    80001f26:	8082                	ret

0000000080001f28 <allocproc>:
{
    80001f28:	1101                	addi	sp,sp,-32
    80001f2a:	ec06                	sd	ra,24(sp)
    80001f2c:	e822                	sd	s0,16(sp)
    80001f2e:	e426                	sd	s1,8(sp)
    80001f30:	e04a                	sd	s2,0(sp)
    80001f32:	1000                	addi	s0,sp,32
    for (p = proc; p < &proc[NPROC]; p++)
    80001f34:	0044f497          	auipc	s1,0x44f
    80001f38:	25c48493          	addi	s1,s1,604 # 80451190 <proc>
    80001f3c:	00455917          	auipc	s2,0x455
    80001f40:	c5490913          	addi	s2,s2,-940 # 80456b90 <tickslock>
        acquire(&p->lock);
    80001f44:	8526                	mv	a0,s1
    80001f46:	fffff097          	auipc	ra,0xfffff
    80001f4a:	e80080e7          	jalr	-384(ra) # 80000dc6 <acquire>
        if (p->state == UNUSED)
    80001f4e:	4c9c                	lw	a5,24(s1)
    80001f50:	cf81                	beqz	a5,80001f68 <allocproc+0x40>
            release(&p->lock);
    80001f52:	8526                	mv	a0,s1
    80001f54:	fffff097          	auipc	ra,0xfffff
    80001f58:	f22080e7          	jalr	-222(ra) # 80000e76 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80001f5c:	16848493          	addi	s1,s1,360
    80001f60:	ff2492e3          	bne	s1,s2,80001f44 <allocproc+0x1c>
    return 0;
    80001f64:	4481                	li	s1,0
    80001f66:	a889                	j	80001fb8 <allocproc+0x90>
    p->pid = allocpid();
    80001f68:	00000097          	auipc	ra,0x0
    80001f6c:	e34080e7          	jalr	-460(ra) # 80001d9c <allocpid>
    80001f70:	d888                	sw	a0,48(s1)
    p->state = USED;
    80001f72:	4785                	li	a5,1
    80001f74:	cc9c                	sw	a5,24(s1)
    if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    80001f76:	fffff097          	auipc	ra,0xfffff
    80001f7a:	c8c080e7          	jalr	-884(ra) # 80000c02 <kalloc>
    80001f7e:	892a                	mv	s2,a0
    80001f80:	eca8                	sd	a0,88(s1)
    80001f82:	c131                	beqz	a0,80001fc6 <allocproc+0x9e>
    p->pagetable = proc_pagetable(p);
    80001f84:	8526                	mv	a0,s1
    80001f86:	00000097          	auipc	ra,0x0
    80001f8a:	e5c080e7          	jalr	-420(ra) # 80001de2 <proc_pagetable>
    80001f8e:	892a                	mv	s2,a0
    80001f90:	e8a8                	sd	a0,80(s1)
    if (p->pagetable == 0)
    80001f92:	c531                	beqz	a0,80001fde <allocproc+0xb6>
    memset(&p->context, 0, sizeof(p->context));
    80001f94:	07000613          	li	a2,112
    80001f98:	4581                	li	a1,0
    80001f9a:	06048513          	addi	a0,s1,96
    80001f9e:	fffff097          	auipc	ra,0xfffff
    80001fa2:	f20080e7          	jalr	-224(ra) # 80000ebe <memset>
    p->context.ra = (uint64)forkret;
    80001fa6:	00000797          	auipc	a5,0x0
    80001faa:	db078793          	addi	a5,a5,-592 # 80001d56 <forkret>
    80001fae:	f0bc                	sd	a5,96(s1)
    p->context.sp = p->kstack + PGSIZE;
    80001fb0:	60bc                	ld	a5,64(s1)
    80001fb2:	6705                	lui	a4,0x1
    80001fb4:	97ba                	add	a5,a5,a4
    80001fb6:	f4bc                	sd	a5,104(s1)
}
    80001fb8:	8526                	mv	a0,s1
    80001fba:	60e2                	ld	ra,24(sp)
    80001fbc:	6442                	ld	s0,16(sp)
    80001fbe:	64a2                	ld	s1,8(sp)
    80001fc0:	6902                	ld	s2,0(sp)
    80001fc2:	6105                	addi	sp,sp,32
    80001fc4:	8082                	ret
        freeproc(p);
    80001fc6:	8526                	mv	a0,s1
    80001fc8:	00000097          	auipc	ra,0x0
    80001fcc:	f08080e7          	jalr	-248(ra) # 80001ed0 <freeproc>
        release(&p->lock);
    80001fd0:	8526                	mv	a0,s1
    80001fd2:	fffff097          	auipc	ra,0xfffff
    80001fd6:	ea4080e7          	jalr	-348(ra) # 80000e76 <release>
        return 0;
    80001fda:	84ca                	mv	s1,s2
    80001fdc:	bff1                	j	80001fb8 <allocproc+0x90>
        freeproc(p);
    80001fde:	8526                	mv	a0,s1
    80001fe0:	00000097          	auipc	ra,0x0
    80001fe4:	ef0080e7          	jalr	-272(ra) # 80001ed0 <freeproc>
        release(&p->lock);
    80001fe8:	8526                	mv	a0,s1
    80001fea:	fffff097          	auipc	ra,0xfffff
    80001fee:	e8c080e7          	jalr	-372(ra) # 80000e76 <release>
        return 0;
    80001ff2:	84ca                	mv	s1,s2
    80001ff4:	b7d1                	j	80001fb8 <allocproc+0x90>

0000000080001ff6 <userinit>:
{
    80001ff6:	1101                	addi	sp,sp,-32
    80001ff8:	ec06                	sd	ra,24(sp)
    80001ffa:	e822                	sd	s0,16(sp)
    80001ffc:	e426                	sd	s1,8(sp)
    80001ffe:	1000                	addi	s0,sp,32
    p = allocproc();
    80002000:	00000097          	auipc	ra,0x0
    80002004:	f28080e7          	jalr	-216(ra) # 80001f28 <allocproc>
    80002008:	84aa                	mv	s1,a0
    initproc = p;
    8000200a:	00007797          	auipc	a5,0x7
    8000200e:	aca7bf23          	sd	a0,-1314(a5) # 80008ae8 <initproc>
    uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80002012:	03400613          	li	a2,52
    80002016:	00007597          	auipc	a1,0x7
    8000201a:	a3a58593          	addi	a1,a1,-1478 # 80008a50 <initcode>
    8000201e:	6928                	ld	a0,80(a0)
    80002020:	fffff097          	auipc	ra,0xfffff
    80002024:	54a080e7          	jalr	1354(ra) # 8000156a <uvmfirst>
    p->sz = PGSIZE;
    80002028:	6785                	lui	a5,0x1
    8000202a:	e4bc                	sd	a5,72(s1)
    p->trapframe->epc = 0;     // user program counter
    8000202c:	6cb8                	ld	a4,88(s1)
    8000202e:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    p->trapframe->sp = PGSIZE; // user stack pointer
    80002032:	6cb8                	ld	a4,88(s1)
    80002034:	fb1c                	sd	a5,48(a4)
    safestrcpy(p->name, "initcode", sizeof(p->name));
    80002036:	4641                	li	a2,16
    80002038:	00006597          	auipc	a1,0x6
    8000203c:	1d858593          	addi	a1,a1,472 # 80008210 <etext+0x210>
    80002040:	15848513          	addi	a0,s1,344
    80002044:	fffff097          	auipc	ra,0xfffff
    80002048:	fd0080e7          	jalr	-48(ra) # 80001014 <safestrcpy>
    p->cwd = namei("/");
    8000204c:	00006517          	auipc	a0,0x6
    80002050:	1d450513          	addi	a0,a0,468 # 80008220 <etext+0x220>
    80002054:	00002097          	auipc	ra,0x2
    80002058:	5aa080e7          	jalr	1450(ra) # 800045fe <namei>
    8000205c:	14a4b823          	sd	a0,336(s1)
    p->state = RUNNABLE;
    80002060:	478d                	li	a5,3
    80002062:	cc9c                	sw	a5,24(s1)
    release(&p->lock);
    80002064:	8526                	mv	a0,s1
    80002066:	fffff097          	auipc	ra,0xfffff
    8000206a:	e10080e7          	jalr	-496(ra) # 80000e76 <release>
}
    8000206e:	60e2                	ld	ra,24(sp)
    80002070:	6442                	ld	s0,16(sp)
    80002072:	64a2                	ld	s1,8(sp)
    80002074:	6105                	addi	sp,sp,32
    80002076:	8082                	ret

0000000080002078 <growproc>:
{
    80002078:	1101                	addi	sp,sp,-32
    8000207a:	ec06                	sd	ra,24(sp)
    8000207c:	e822                	sd	s0,16(sp)
    8000207e:	e426                	sd	s1,8(sp)
    80002080:	e04a                	sd	s2,0(sp)
    80002082:	1000                	addi	s0,sp,32
    80002084:	892a                	mv	s2,a0
    struct proc *p = myproc();
    80002086:	00000097          	auipc	ra,0x0
    8000208a:	c98080e7          	jalr	-872(ra) # 80001d1e <myproc>
    8000208e:	84aa                	mv	s1,a0
    sz = p->sz;
    80002090:	652c                	ld	a1,72(a0)
    if (n > 0)
    80002092:	01204c63          	bgtz	s2,800020aa <growproc+0x32>
    else if (n < 0)
    80002096:	02094663          	bltz	s2,800020c2 <growproc+0x4a>
    p->sz = sz;
    8000209a:	e4ac                	sd	a1,72(s1)
    return 0;
    8000209c:	4501                	li	a0,0
}
    8000209e:	60e2                	ld	ra,24(sp)
    800020a0:	6442                	ld	s0,16(sp)
    800020a2:	64a2                	ld	s1,8(sp)
    800020a4:	6902                	ld	s2,0(sp)
    800020a6:	6105                	addi	sp,sp,32
    800020a8:	8082                	ret
        if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    800020aa:	4691                	li	a3,4
    800020ac:	00b90633          	add	a2,s2,a1
    800020b0:	6928                	ld	a0,80(a0)
    800020b2:	fffff097          	auipc	ra,0xfffff
    800020b6:	572080e7          	jalr	1394(ra) # 80001624 <uvmalloc>
    800020ba:	85aa                	mv	a1,a0
    800020bc:	fd79                	bnez	a0,8000209a <growproc+0x22>
            return -1;
    800020be:	557d                	li	a0,-1
    800020c0:	bff9                	j	8000209e <growproc+0x26>
        sz = uvmdealloc(p->pagetable, sz, sz + n);
    800020c2:	00b90633          	add	a2,s2,a1
    800020c6:	6928                	ld	a0,80(a0)
    800020c8:	fffff097          	auipc	ra,0xfffff
    800020cc:	514080e7          	jalr	1300(ra) # 800015dc <uvmdealloc>
    800020d0:	85aa                	mv	a1,a0
    800020d2:	b7e1                	j	8000209a <growproc+0x22>

00000000800020d4 <ps>:
{
    800020d4:	711d                	addi	sp,sp,-96
    800020d6:	ec86                	sd	ra,88(sp)
    800020d8:	e8a2                	sd	s0,80(sp)
    800020da:	e4a6                	sd	s1,72(sp)
    800020dc:	e0ca                	sd	s2,64(sp)
    800020de:	fc4e                	sd	s3,56(sp)
    800020e0:	f852                	sd	s4,48(sp)
    800020e2:	f456                	sd	s5,40(sp)
    800020e4:	f05a                	sd	s6,32(sp)
    800020e6:	ec5e                	sd	s7,24(sp)
    800020e8:	e862                	sd	s8,16(sp)
    800020ea:	e466                	sd	s9,8(sp)
    800020ec:	1080                	addi	s0,sp,96
    800020ee:	84aa                	mv	s1,a0
    800020f0:	8a2e                	mv	s4,a1
    void *result = (void *)myproc()->sz;
    800020f2:	00000097          	auipc	ra,0x0
    800020f6:	c2c080e7          	jalr	-980(ra) # 80001d1e <myproc>
        return result;
    800020fa:	4901                	li	s2,0
    if (count == 0)
    800020fc:	0c0a0563          	beqz	s4,800021c6 <ps+0xf2>
    void *result = (void *)myproc()->sz;
    80002100:	04853b83          	ld	s7,72(a0)
    if (growproc(count * sizeof(struct user_proc)) < 0)
    80002104:	003a151b          	slliw	a0,s4,0x3
    80002108:	0145053b          	addw	a0,a0,s4
    8000210c:	050a                	slli	a0,a0,0x2
    8000210e:	00000097          	auipc	ra,0x0
    80002112:	f6a080e7          	jalr	-150(ra) # 80002078 <growproc>
    80002116:	14054163          	bltz	a0,80002258 <ps+0x184>
    struct user_proc loc_result[count];
    8000211a:	003a1a93          	slli	s5,s4,0x3
    8000211e:	9ad2                	add	s5,s5,s4
    80002120:	0a8a                	slli	s5,s5,0x2
    80002122:	00fa8793          	addi	a5,s5,15
    80002126:	8391                	srli	a5,a5,0x4
    80002128:	0792                	slli	a5,a5,0x4
    8000212a:	40f10133          	sub	sp,sp,a5
    8000212e:	8b0a                	mv	s6,sp
    struct proc *p = proc + start;
    80002130:	16800793          	li	a5,360
    80002134:	02f484b3          	mul	s1,s1,a5
    80002138:	0044f797          	auipc	a5,0x44f
    8000213c:	05878793          	addi	a5,a5,88 # 80451190 <proc>
    80002140:	94be                	add	s1,s1,a5
    if (p >= &proc[NPROC])
    80002142:	00455797          	auipc	a5,0x455
    80002146:	a4e78793          	addi	a5,a5,-1458 # 80456b90 <tickslock>
        return result;
    8000214a:	4901                	li	s2,0
    if (p >= &proc[NPROC])
    8000214c:	06f4fd63          	bgeu	s1,a5,800021c6 <ps+0xf2>
    acquire(&wait_lock);
    80002150:	0044f517          	auipc	a0,0x44f
    80002154:	02850513          	addi	a0,a0,40 # 80451178 <wait_lock>
    80002158:	fffff097          	auipc	ra,0xfffff
    8000215c:	c6e080e7          	jalr	-914(ra) # 80000dc6 <acquire>
    for (; p < &proc[NPROC]; p++)
    80002160:	01410913          	addi	s2,sp,20
    uint8 localCount = 0;
    80002164:	4981                	li	s3,0
        copy_array(p->name, loc_result[localCount].name, 16);
    80002166:	4cc1                	li	s9,16
    for (; p < &proc[NPROC]; p++)
    80002168:	00455c17          	auipc	s8,0x455
    8000216c:	a28c0c13          	addi	s8,s8,-1496 # 80456b90 <tickslock>
    80002170:	a07d                	j	8000221e <ps+0x14a>
            loc_result[localCount].state = UNUSED;
    80002172:	00399793          	slli	a5,s3,0x3
    80002176:	97ce                	add	a5,a5,s3
    80002178:	078a                	slli	a5,a5,0x2
    8000217a:	97da                	add	a5,a5,s6
    8000217c:	0007a023          	sw	zero,0(a5)
            release(&p->lock);
    80002180:	8526                	mv	a0,s1
    80002182:	fffff097          	auipc	ra,0xfffff
    80002186:	cf4080e7          	jalr	-780(ra) # 80000e76 <release>
    release(&wait_lock);
    8000218a:	0044f517          	auipc	a0,0x44f
    8000218e:	fee50513          	addi	a0,a0,-18 # 80451178 <wait_lock>
    80002192:	fffff097          	auipc	ra,0xfffff
    80002196:	ce4080e7          	jalr	-796(ra) # 80000e76 <release>
    if (localCount < count)
    8000219a:	0149f963          	bgeu	s3,s4,800021ac <ps+0xd8>
        loc_result[localCount].state = UNUSED; // if we reach the end of processes
    8000219e:	00399793          	slli	a5,s3,0x3
    800021a2:	97ce                	add	a5,a5,s3
    800021a4:	078a                	slli	a5,a5,0x2
    800021a6:	97da                	add	a5,a5,s6
    800021a8:	0007a023          	sw	zero,0(a5)
    void *result = (void *)myproc()->sz;
    800021ac:	895e                	mv	s2,s7
    copyout(myproc()->pagetable, (uint64)result, (void *)loc_result, count * sizeof(struct user_proc));
    800021ae:	00000097          	auipc	ra,0x0
    800021b2:	b70080e7          	jalr	-1168(ra) # 80001d1e <myproc>
    800021b6:	86d6                	mv	a3,s5
    800021b8:	865a                	mv	a2,s6
    800021ba:	85de                	mv	a1,s7
    800021bc:	6928                	ld	a0,80(a0)
    800021be:	fffff097          	auipc	ra,0xfffff
    800021c2:	6d8080e7          	jalr	1752(ra) # 80001896 <copyout>
}
    800021c6:	854a                	mv	a0,s2
    800021c8:	fa040113          	addi	sp,s0,-96
    800021cc:	60e6                	ld	ra,88(sp)
    800021ce:	6446                	ld	s0,80(sp)
    800021d0:	64a6                	ld	s1,72(sp)
    800021d2:	6906                	ld	s2,64(sp)
    800021d4:	79e2                	ld	s3,56(sp)
    800021d6:	7a42                	ld	s4,48(sp)
    800021d8:	7aa2                	ld	s5,40(sp)
    800021da:	7b02                	ld	s6,32(sp)
    800021dc:	6be2                	ld	s7,24(sp)
    800021de:	6c42                	ld	s8,16(sp)
    800021e0:	6ca2                	ld	s9,8(sp)
    800021e2:	6125                	addi	sp,sp,96
    800021e4:	8082                	ret
            acquire(&p->parent->lock);
    800021e6:	fffff097          	auipc	ra,0xfffff
    800021ea:	be0080e7          	jalr	-1056(ra) # 80000dc6 <acquire>
            loc_result[localCount].parent_id = p->parent->pid;
    800021ee:	7c88                	ld	a0,56(s1)
    800021f0:	591c                	lw	a5,48(a0)
    800021f2:	fef92e23          	sw	a5,-4(s2)
            release(&p->parent->lock);
    800021f6:	fffff097          	auipc	ra,0xfffff
    800021fa:	c80080e7          	jalr	-896(ra) # 80000e76 <release>
        release(&p->lock);
    800021fe:	8526                	mv	a0,s1
    80002200:	fffff097          	auipc	ra,0xfffff
    80002204:	c76080e7          	jalr	-906(ra) # 80000e76 <release>
        localCount++;
    80002208:	2985                	addiw	s3,s3,1
    8000220a:	0ff9f993          	zext.b	s3,s3
    for (; p < &proc[NPROC]; p++)
    8000220e:	16848493          	addi	s1,s1,360
    80002212:	f784fce3          	bgeu	s1,s8,8000218a <ps+0xb6>
        if (localCount == count)
    80002216:	02490913          	addi	s2,s2,36
    8000221a:	053a0163          	beq	s4,s3,8000225c <ps+0x188>
        acquire(&p->lock);
    8000221e:	8526                	mv	a0,s1
    80002220:	fffff097          	auipc	ra,0xfffff
    80002224:	ba6080e7          	jalr	-1114(ra) # 80000dc6 <acquire>
        if (p->state == UNUSED)
    80002228:	4c9c                	lw	a5,24(s1)
    8000222a:	d7a1                	beqz	a5,80002172 <ps+0x9e>
        loc_result[localCount].state = p->state;
    8000222c:	fef92623          	sw	a5,-20(s2)
        loc_result[localCount].killed = p->killed;
    80002230:	549c                	lw	a5,40(s1)
    80002232:	fef92823          	sw	a5,-16(s2)
        loc_result[localCount].xstate = p->xstate;
    80002236:	54dc                	lw	a5,44(s1)
    80002238:	fef92a23          	sw	a5,-12(s2)
        loc_result[localCount].pid = p->pid;
    8000223c:	589c                	lw	a5,48(s1)
    8000223e:	fef92c23          	sw	a5,-8(s2)
        copy_array(p->name, loc_result[localCount].name, 16);
    80002242:	8666                	mv	a2,s9
    80002244:	85ca                	mv	a1,s2
    80002246:	15848513          	addi	a0,s1,344
    8000224a:	00000097          	auipc	ra,0x0
    8000224e:	a78080e7          	jalr	-1416(ra) # 80001cc2 <copy_array>
        if (p->parent != 0) // init
    80002252:	7c88                	ld	a0,56(s1)
    80002254:	f949                	bnez	a0,800021e6 <ps+0x112>
    80002256:	b765                	j	800021fe <ps+0x12a>
        return result;
    80002258:	4901                	li	s2,0
    8000225a:	b7b5                	j	800021c6 <ps+0xf2>
    release(&wait_lock);
    8000225c:	0044f517          	auipc	a0,0x44f
    80002260:	f1c50513          	addi	a0,a0,-228 # 80451178 <wait_lock>
    80002264:	fffff097          	auipc	ra,0xfffff
    80002268:	c12080e7          	jalr	-1006(ra) # 80000e76 <release>
    if (localCount < count)
    8000226c:	b781                	j	800021ac <ps+0xd8>

000000008000226e <fork>:
{
    8000226e:	7139                	addi	sp,sp,-64
    80002270:	fc06                	sd	ra,56(sp)
    80002272:	f822                	sd	s0,48(sp)
    80002274:	f04a                	sd	s2,32(sp)
    80002276:	e456                	sd	s5,8(sp)
    80002278:	0080                	addi	s0,sp,64
    struct proc *p = myproc();
    8000227a:	00000097          	auipc	ra,0x0
    8000227e:	aa4080e7          	jalr	-1372(ra) # 80001d1e <myproc>
    80002282:	8aaa                	mv	s5,a0
    if((np = allocproc()) == 0){
    80002284:	00000097          	auipc	ra,0x0
    80002288:	ca4080e7          	jalr	-860(ra) # 80001f28 <allocproc>
    8000228c:	12050063          	beqz	a0,800023ac <fork+0x13e>
    80002290:	e852                	sd	s4,16(sp)
    80002292:	8a2a                	mv	s4,a0
    if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80002294:	048ab603          	ld	a2,72(s5)
    80002298:	692c                	ld	a1,80(a0)
    8000229a:	050ab503          	ld	a0,80(s5)
    8000229e:	fffff097          	auipc	ra,0xfffff
    800022a2:	4f2080e7          	jalr	1266(ra) # 80001790 <uvmcopy>
    800022a6:	04054a63          	bltz	a0,800022fa <fork+0x8c>
    800022aa:	f426                	sd	s1,40(sp)
    800022ac:	ec4e                	sd	s3,24(sp)
    np->sz = p->sz;
    800022ae:	048ab783          	ld	a5,72(s5)
    800022b2:	04fa3423          	sd	a5,72(s4)
    *(np->trapframe) = *(p->trapframe);
    800022b6:	058ab683          	ld	a3,88(s5)
    800022ba:	87b6                	mv	a5,a3
    800022bc:	058a3703          	ld	a4,88(s4)
    800022c0:	12068693          	addi	a3,a3,288
    800022c4:	0007b803          	ld	a6,0(a5)
    800022c8:	6788                	ld	a0,8(a5)
    800022ca:	6b8c                	ld	a1,16(a5)
    800022cc:	6f90                	ld	a2,24(a5)
    800022ce:	01073023          	sd	a6,0(a4)
    800022d2:	e708                	sd	a0,8(a4)
    800022d4:	eb0c                	sd	a1,16(a4)
    800022d6:	ef10                	sd	a2,24(a4)
    800022d8:	02078793          	addi	a5,a5,32
    800022dc:	02070713          	addi	a4,a4,32
    800022e0:	fed792e3          	bne	a5,a3,800022c4 <fork+0x56>
    np->trapframe->a0 = 0;
    800022e4:	058a3783          	ld	a5,88(s4)
    800022e8:	0607b823          	sd	zero,112(a5)
    for(i = 0; i < NOFILE; i++)
    800022ec:	0d0a8493          	addi	s1,s5,208
    800022f0:	0d0a0913          	addi	s2,s4,208
    800022f4:	150a8993          	addi	s3,s5,336
    800022f8:	a015                	j	8000231c <fork+0xae>
      freeproc(np);
    800022fa:	8552                	mv	a0,s4
    800022fc:	00000097          	auipc	ra,0x0
    80002300:	bd4080e7          	jalr	-1068(ra) # 80001ed0 <freeproc>
      release(&np->lock);
    80002304:	8552                	mv	a0,s4
    80002306:	fffff097          	auipc	ra,0xfffff
    8000230a:	b70080e7          	jalr	-1168(ra) # 80000e76 <release>
      return -1;
    8000230e:	597d                	li	s2,-1
    80002310:	6a42                	ld	s4,16(sp)
    80002312:	a071                	j	8000239e <fork+0x130>
    for(i = 0; i < NOFILE; i++)
    80002314:	04a1                	addi	s1,s1,8
    80002316:	0921                	addi	s2,s2,8
    80002318:	01348b63          	beq	s1,s3,8000232e <fork+0xc0>
      if(p->ofile[i])
    8000231c:	6088                	ld	a0,0(s1)
    8000231e:	d97d                	beqz	a0,80002314 <fork+0xa6>
        np->ofile[i] = filedup(p->ofile[i]);
    80002320:	00003097          	auipc	ra,0x3
    80002324:	962080e7          	jalr	-1694(ra) # 80004c82 <filedup>
    80002328:	00a93023          	sd	a0,0(s2)
    8000232c:	b7e5                	j	80002314 <fork+0xa6>
    np->cwd = idup(p->cwd);
    8000232e:	150ab503          	ld	a0,336(s5)
    80002332:	00002097          	auipc	ra,0x2
    80002336:	aaa080e7          	jalr	-1366(ra) # 80003ddc <idup>
    8000233a:	14aa3823          	sd	a0,336(s4)
    safestrcpy(np->name, p->name, sizeof(p->name));
    8000233e:	4641                	li	a2,16
    80002340:	158a8593          	addi	a1,s5,344
    80002344:	158a0513          	addi	a0,s4,344
    80002348:	fffff097          	auipc	ra,0xfffff
    8000234c:	ccc080e7          	jalr	-820(ra) # 80001014 <safestrcpy>
    pid = np->pid;
    80002350:	030a2903          	lw	s2,48(s4)
    release(&np->lock);
    80002354:	8552                	mv	a0,s4
    80002356:	fffff097          	auipc	ra,0xfffff
    8000235a:	b20080e7          	jalr	-1248(ra) # 80000e76 <release>
    acquire(&wait_lock);
    8000235e:	0044f497          	auipc	s1,0x44f
    80002362:	e1a48493          	addi	s1,s1,-486 # 80451178 <wait_lock>
    80002366:	8526                	mv	a0,s1
    80002368:	fffff097          	auipc	ra,0xfffff
    8000236c:	a5e080e7          	jalr	-1442(ra) # 80000dc6 <acquire>
    np->parent = p;
    80002370:	035a3c23          	sd	s5,56(s4)
    release(&wait_lock);
    80002374:	8526                	mv	a0,s1
    80002376:	fffff097          	auipc	ra,0xfffff
    8000237a:	b00080e7          	jalr	-1280(ra) # 80000e76 <release>
    acquire(&np->lock);
    8000237e:	8552                	mv	a0,s4
    80002380:	fffff097          	auipc	ra,0xfffff
    80002384:	a46080e7          	jalr	-1466(ra) # 80000dc6 <acquire>
    np->state = RUNNABLE;
    80002388:	478d                	li	a5,3
    8000238a:	00fa2c23          	sw	a5,24(s4)
    release(&np->lock);
    8000238e:	8552                	mv	a0,s4
    80002390:	fffff097          	auipc	ra,0xfffff
    80002394:	ae6080e7          	jalr	-1306(ra) # 80000e76 <release>
    return pid;
    80002398:	74a2                	ld	s1,40(sp)
    8000239a:	69e2                	ld	s3,24(sp)
    8000239c:	6a42                	ld	s4,16(sp)
}
    8000239e:	854a                	mv	a0,s2
    800023a0:	70e2                	ld	ra,56(sp)
    800023a2:	7442                	ld	s0,48(sp)
    800023a4:	7902                	ld	s2,32(sp)
    800023a6:	6aa2                	ld	s5,8(sp)
    800023a8:	6121                	addi	sp,sp,64
    800023aa:	8082                	ret
      return -1;
    800023ac:	597d                	li	s2,-1
    800023ae:	bfc5                	j	8000239e <fork+0x130>

00000000800023b0 <scheduler>:
{
    800023b0:	1101                	addi	sp,sp,-32
    800023b2:	ec06                	sd	ra,24(sp)
    800023b4:	e822                	sd	s0,16(sp)
    800023b6:	e426                	sd	s1,8(sp)
    800023b8:	1000                	addi	s0,sp,32
        (*sched_pointer)();
    800023ba:	00006497          	auipc	s1,0x6
    800023be:	67e48493          	addi	s1,s1,1662 # 80008a38 <sched_pointer>
    800023c2:	609c                	ld	a5,0(s1)
    800023c4:	9782                	jalr	a5
    while (1)
    800023c6:	bff5                	j	800023c2 <scheduler+0x12>

00000000800023c8 <sched>:
{
    800023c8:	7179                	addi	sp,sp,-48
    800023ca:	f406                	sd	ra,40(sp)
    800023cc:	f022                	sd	s0,32(sp)
    800023ce:	ec26                	sd	s1,24(sp)
    800023d0:	e84a                	sd	s2,16(sp)
    800023d2:	e44e                	sd	s3,8(sp)
    800023d4:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    800023d6:	00000097          	auipc	ra,0x0
    800023da:	948080e7          	jalr	-1720(ra) # 80001d1e <myproc>
    800023de:	84aa                	mv	s1,a0
    if (!holding(&p->lock))
    800023e0:	fffff097          	auipc	ra,0xfffff
    800023e4:	96c080e7          	jalr	-1684(ra) # 80000d4c <holding>
    800023e8:	c53d                	beqz	a0,80002456 <sched+0x8e>
    800023ea:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    800023ec:	2781                	sext.w	a5,a5
    800023ee:	079e                	slli	a5,a5,0x7
    800023f0:	0044f717          	auipc	a4,0x44f
    800023f4:	97070713          	addi	a4,a4,-1680 # 80450d60 <cpus>
    800023f8:	97ba                	add	a5,a5,a4
    800023fa:	5fb8                	lw	a4,120(a5)
    800023fc:	4785                	li	a5,1
    800023fe:	06f71463          	bne	a4,a5,80002466 <sched+0x9e>
    if (p->state == RUNNING)
    80002402:	4c98                	lw	a4,24(s1)
    80002404:	4791                	li	a5,4
    80002406:	06f70863          	beq	a4,a5,80002476 <sched+0xae>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    8000240a:	100027f3          	csrr	a5,sstatus
    return (x & SSTATUS_SIE) != 0;
    8000240e:	8b89                	andi	a5,a5,2
    if (intr_get())
    80002410:	ebbd                	bnez	a5,80002486 <sched+0xbe>
    asm volatile("mv %0, tp" : "=r"(x));
    80002412:	8792                	mv	a5,tp
    intena = mycpu()->intena;
    80002414:	0044f917          	auipc	s2,0x44f
    80002418:	94c90913          	addi	s2,s2,-1716 # 80450d60 <cpus>
    8000241c:	2781                	sext.w	a5,a5
    8000241e:	079e                	slli	a5,a5,0x7
    80002420:	97ca                	add	a5,a5,s2
    80002422:	07c7a983          	lw	s3,124(a5)
    80002426:	8592                	mv	a1,tp
    swtch(&p->context, &mycpu()->context);
    80002428:	2581                	sext.w	a1,a1
    8000242a:	059e                	slli	a1,a1,0x7
    8000242c:	05a1                	addi	a1,a1,8
    8000242e:	95ca                	add	a1,a1,s2
    80002430:	06048513          	addi	a0,s1,96
    80002434:	00000097          	auipc	ra,0x0
    80002438:	6de080e7          	jalr	1758(ra) # 80002b12 <swtch>
    8000243c:	8792                	mv	a5,tp
    mycpu()->intena = intena;
    8000243e:	2781                	sext.w	a5,a5
    80002440:	079e                	slli	a5,a5,0x7
    80002442:	993e                	add	s2,s2,a5
    80002444:	07392e23          	sw	s3,124(s2)
}
    80002448:	70a2                	ld	ra,40(sp)
    8000244a:	7402                	ld	s0,32(sp)
    8000244c:	64e2                	ld	s1,24(sp)
    8000244e:	6942                	ld	s2,16(sp)
    80002450:	69a2                	ld	s3,8(sp)
    80002452:	6145                	addi	sp,sp,48
    80002454:	8082                	ret
        panic("sched p->lock");
    80002456:	00006517          	auipc	a0,0x6
    8000245a:	dd250513          	addi	a0,a0,-558 # 80008228 <etext+0x228>
    8000245e:	ffffe097          	auipc	ra,0xffffe
    80002462:	102080e7          	jalr	258(ra) # 80000560 <panic>
        panic("sched locks");
    80002466:	00006517          	auipc	a0,0x6
    8000246a:	dd250513          	addi	a0,a0,-558 # 80008238 <etext+0x238>
    8000246e:	ffffe097          	auipc	ra,0xffffe
    80002472:	0f2080e7          	jalr	242(ra) # 80000560 <panic>
        panic("sched running");
    80002476:	00006517          	auipc	a0,0x6
    8000247a:	dd250513          	addi	a0,a0,-558 # 80008248 <etext+0x248>
    8000247e:	ffffe097          	auipc	ra,0xffffe
    80002482:	0e2080e7          	jalr	226(ra) # 80000560 <panic>
        panic("sched interruptible");
    80002486:	00006517          	auipc	a0,0x6
    8000248a:	dd250513          	addi	a0,a0,-558 # 80008258 <etext+0x258>
    8000248e:	ffffe097          	auipc	ra,0xffffe
    80002492:	0d2080e7          	jalr	210(ra) # 80000560 <panic>

0000000080002496 <yield>:
{
    80002496:	1101                	addi	sp,sp,-32
    80002498:	ec06                	sd	ra,24(sp)
    8000249a:	e822                	sd	s0,16(sp)
    8000249c:	e426                	sd	s1,8(sp)
    8000249e:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    800024a0:	00000097          	auipc	ra,0x0
    800024a4:	87e080e7          	jalr	-1922(ra) # 80001d1e <myproc>
    800024a8:	84aa                	mv	s1,a0
    acquire(&p->lock);
    800024aa:	fffff097          	auipc	ra,0xfffff
    800024ae:	91c080e7          	jalr	-1764(ra) # 80000dc6 <acquire>
    p->state = RUNNABLE;
    800024b2:	478d                	li	a5,3
    800024b4:	cc9c                	sw	a5,24(s1)
    sched();
    800024b6:	00000097          	auipc	ra,0x0
    800024ba:	f12080e7          	jalr	-238(ra) # 800023c8 <sched>
    release(&p->lock);
    800024be:	8526                	mv	a0,s1
    800024c0:	fffff097          	auipc	ra,0xfffff
    800024c4:	9b6080e7          	jalr	-1610(ra) # 80000e76 <release>
}
    800024c8:	60e2                	ld	ra,24(sp)
    800024ca:	6442                	ld	s0,16(sp)
    800024cc:	64a2                	ld	s1,8(sp)
    800024ce:	6105                	addi	sp,sp,32
    800024d0:	8082                	ret

00000000800024d2 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    800024d2:	7179                	addi	sp,sp,-48
    800024d4:	f406                	sd	ra,40(sp)
    800024d6:	f022                	sd	s0,32(sp)
    800024d8:	ec26                	sd	s1,24(sp)
    800024da:	e84a                	sd	s2,16(sp)
    800024dc:	e44e                	sd	s3,8(sp)
    800024de:	1800                	addi	s0,sp,48
    800024e0:	89aa                	mv	s3,a0
    800024e2:	892e                	mv	s2,a1
    struct proc *p = myproc();
    800024e4:	00000097          	auipc	ra,0x0
    800024e8:	83a080e7          	jalr	-1990(ra) # 80001d1e <myproc>
    800024ec:	84aa                	mv	s1,a0
    // Once we hold p->lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup locks p->lock),
    // so it's okay to release lk.

    acquire(&p->lock); // DOC: sleeplock1
    800024ee:	fffff097          	auipc	ra,0xfffff
    800024f2:	8d8080e7          	jalr	-1832(ra) # 80000dc6 <acquire>
    release(lk);
    800024f6:	854a                	mv	a0,s2
    800024f8:	fffff097          	auipc	ra,0xfffff
    800024fc:	97e080e7          	jalr	-1666(ra) # 80000e76 <release>

    // Go to sleep.
    p->chan = chan;
    80002500:	0334b023          	sd	s3,32(s1)
    p->state = SLEEPING;
    80002504:	4789                	li	a5,2
    80002506:	cc9c                	sw	a5,24(s1)

    sched();
    80002508:	00000097          	auipc	ra,0x0
    8000250c:	ec0080e7          	jalr	-320(ra) # 800023c8 <sched>

    // Tidy up.
    p->chan = 0;
    80002510:	0204b023          	sd	zero,32(s1)

    // Reacquire original lock.
    release(&p->lock);
    80002514:	8526                	mv	a0,s1
    80002516:	fffff097          	auipc	ra,0xfffff
    8000251a:	960080e7          	jalr	-1696(ra) # 80000e76 <release>
    acquire(lk);
    8000251e:	854a                	mv	a0,s2
    80002520:	fffff097          	auipc	ra,0xfffff
    80002524:	8a6080e7          	jalr	-1882(ra) # 80000dc6 <acquire>
}
    80002528:	70a2                	ld	ra,40(sp)
    8000252a:	7402                	ld	s0,32(sp)
    8000252c:	64e2                	ld	s1,24(sp)
    8000252e:	6942                	ld	s2,16(sp)
    80002530:	69a2                	ld	s3,8(sp)
    80002532:	6145                	addi	sp,sp,48
    80002534:	8082                	ret

0000000080002536 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    80002536:	7139                	addi	sp,sp,-64
    80002538:	fc06                	sd	ra,56(sp)
    8000253a:	f822                	sd	s0,48(sp)
    8000253c:	f426                	sd	s1,40(sp)
    8000253e:	f04a                	sd	s2,32(sp)
    80002540:	ec4e                	sd	s3,24(sp)
    80002542:	e852                	sd	s4,16(sp)
    80002544:	e456                	sd	s5,8(sp)
    80002546:	0080                	addi	s0,sp,64
    80002548:	8a2a                	mv	s4,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    8000254a:	0044f497          	auipc	s1,0x44f
    8000254e:	c4648493          	addi	s1,s1,-954 # 80451190 <proc>
    {
        if (p != myproc())
        {
            acquire(&p->lock);
            if (p->state == SLEEPING && p->chan == chan)
    80002552:	4989                	li	s3,2
            {
                p->state = RUNNABLE;
    80002554:	4a8d                	li	s5,3
    for (p = proc; p < &proc[NPROC]; p++)
    80002556:	00454917          	auipc	s2,0x454
    8000255a:	63a90913          	addi	s2,s2,1594 # 80456b90 <tickslock>
    8000255e:	a811                	j	80002572 <wakeup+0x3c>
            }
            release(&p->lock);
    80002560:	8526                	mv	a0,s1
    80002562:	fffff097          	auipc	ra,0xfffff
    80002566:	914080e7          	jalr	-1772(ra) # 80000e76 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    8000256a:	16848493          	addi	s1,s1,360
    8000256e:	03248663          	beq	s1,s2,8000259a <wakeup+0x64>
        if (p != myproc())
    80002572:	fffff097          	auipc	ra,0xfffff
    80002576:	7ac080e7          	jalr	1964(ra) # 80001d1e <myproc>
    8000257a:	fea488e3          	beq	s1,a0,8000256a <wakeup+0x34>
            acquire(&p->lock);
    8000257e:	8526                	mv	a0,s1
    80002580:	fffff097          	auipc	ra,0xfffff
    80002584:	846080e7          	jalr	-1978(ra) # 80000dc6 <acquire>
            if (p->state == SLEEPING && p->chan == chan)
    80002588:	4c9c                	lw	a5,24(s1)
    8000258a:	fd379be3          	bne	a5,s3,80002560 <wakeup+0x2a>
    8000258e:	709c                	ld	a5,32(s1)
    80002590:	fd4798e3          	bne	a5,s4,80002560 <wakeup+0x2a>
                p->state = RUNNABLE;
    80002594:	0154ac23          	sw	s5,24(s1)
    80002598:	b7e1                	j	80002560 <wakeup+0x2a>
        }
    }
}
    8000259a:	70e2                	ld	ra,56(sp)
    8000259c:	7442                	ld	s0,48(sp)
    8000259e:	74a2                	ld	s1,40(sp)
    800025a0:	7902                	ld	s2,32(sp)
    800025a2:	69e2                	ld	s3,24(sp)
    800025a4:	6a42                	ld	s4,16(sp)
    800025a6:	6aa2                	ld	s5,8(sp)
    800025a8:	6121                	addi	sp,sp,64
    800025aa:	8082                	ret

00000000800025ac <reparent>:
{
    800025ac:	7179                	addi	sp,sp,-48
    800025ae:	f406                	sd	ra,40(sp)
    800025b0:	f022                	sd	s0,32(sp)
    800025b2:	ec26                	sd	s1,24(sp)
    800025b4:	e84a                	sd	s2,16(sp)
    800025b6:	e44e                	sd	s3,8(sp)
    800025b8:	e052                	sd	s4,0(sp)
    800025ba:	1800                	addi	s0,sp,48
    800025bc:	892a                	mv	s2,a0
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800025be:	0044f497          	auipc	s1,0x44f
    800025c2:	bd248493          	addi	s1,s1,-1070 # 80451190 <proc>
            pp->parent = initproc;
    800025c6:	00006a17          	auipc	s4,0x6
    800025ca:	522a0a13          	addi	s4,s4,1314 # 80008ae8 <initproc>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800025ce:	00454997          	auipc	s3,0x454
    800025d2:	5c298993          	addi	s3,s3,1474 # 80456b90 <tickslock>
    800025d6:	a029                	j	800025e0 <reparent+0x34>
    800025d8:	16848493          	addi	s1,s1,360
    800025dc:	01348d63          	beq	s1,s3,800025f6 <reparent+0x4a>
        if (pp->parent == p)
    800025e0:	7c9c                	ld	a5,56(s1)
    800025e2:	ff279be3          	bne	a5,s2,800025d8 <reparent+0x2c>
            pp->parent = initproc;
    800025e6:	000a3503          	ld	a0,0(s4)
    800025ea:	fc88                	sd	a0,56(s1)
            wakeup(initproc);
    800025ec:	00000097          	auipc	ra,0x0
    800025f0:	f4a080e7          	jalr	-182(ra) # 80002536 <wakeup>
    800025f4:	b7d5                	j	800025d8 <reparent+0x2c>
}
    800025f6:	70a2                	ld	ra,40(sp)
    800025f8:	7402                	ld	s0,32(sp)
    800025fa:	64e2                	ld	s1,24(sp)
    800025fc:	6942                	ld	s2,16(sp)
    800025fe:	69a2                	ld	s3,8(sp)
    80002600:	6a02                	ld	s4,0(sp)
    80002602:	6145                	addi	sp,sp,48
    80002604:	8082                	ret

0000000080002606 <exit>:
{
    80002606:	7179                	addi	sp,sp,-48
    80002608:	f406                	sd	ra,40(sp)
    8000260a:	f022                	sd	s0,32(sp)
    8000260c:	ec26                	sd	s1,24(sp)
    8000260e:	e84a                	sd	s2,16(sp)
    80002610:	e44e                	sd	s3,8(sp)
    80002612:	e052                	sd	s4,0(sp)
    80002614:	1800                	addi	s0,sp,48
    80002616:	8a2a                	mv	s4,a0
    struct proc *p = myproc();
    80002618:	fffff097          	auipc	ra,0xfffff
    8000261c:	706080e7          	jalr	1798(ra) # 80001d1e <myproc>
    80002620:	89aa                	mv	s3,a0
    if (p == initproc)
    80002622:	00006797          	auipc	a5,0x6
    80002626:	4c67b783          	ld	a5,1222(a5) # 80008ae8 <initproc>
    8000262a:	0d050493          	addi	s1,a0,208
    8000262e:	15050913          	addi	s2,a0,336
    80002632:	00a79d63          	bne	a5,a0,8000264c <exit+0x46>
        panic("init exiting");
    80002636:	00006517          	auipc	a0,0x6
    8000263a:	c3a50513          	addi	a0,a0,-966 # 80008270 <etext+0x270>
    8000263e:	ffffe097          	auipc	ra,0xffffe
    80002642:	f22080e7          	jalr	-222(ra) # 80000560 <panic>
    for (int fd = 0; fd < NOFILE; fd++)
    80002646:	04a1                	addi	s1,s1,8
    80002648:	01248b63          	beq	s1,s2,8000265e <exit+0x58>
        if (p->ofile[fd])
    8000264c:	6088                	ld	a0,0(s1)
    8000264e:	dd65                	beqz	a0,80002646 <exit+0x40>
            fileclose(f);
    80002650:	00002097          	auipc	ra,0x2
    80002654:	684080e7          	jalr	1668(ra) # 80004cd4 <fileclose>
            p->ofile[fd] = 0;
    80002658:	0004b023          	sd	zero,0(s1)
    8000265c:	b7ed                	j	80002646 <exit+0x40>
    begin_op();
    8000265e:	00002097          	auipc	ra,0x2
    80002662:	1a6080e7          	jalr	422(ra) # 80004804 <begin_op>
    iput(p->cwd);
    80002666:	1509b503          	ld	a0,336(s3)
    8000266a:	00002097          	auipc	ra,0x2
    8000266e:	96e080e7          	jalr	-1682(ra) # 80003fd8 <iput>
    end_op();
    80002672:	00002097          	auipc	ra,0x2
    80002676:	20c080e7          	jalr	524(ra) # 8000487e <end_op>
    p->cwd = 0;
    8000267a:	1409b823          	sd	zero,336(s3)
    acquire(&wait_lock);
    8000267e:	0044f497          	auipc	s1,0x44f
    80002682:	afa48493          	addi	s1,s1,-1286 # 80451178 <wait_lock>
    80002686:	8526                	mv	a0,s1
    80002688:	ffffe097          	auipc	ra,0xffffe
    8000268c:	73e080e7          	jalr	1854(ra) # 80000dc6 <acquire>
    reparent(p);
    80002690:	854e                	mv	a0,s3
    80002692:	00000097          	auipc	ra,0x0
    80002696:	f1a080e7          	jalr	-230(ra) # 800025ac <reparent>
    wakeup(p->parent);
    8000269a:	0389b503          	ld	a0,56(s3)
    8000269e:	00000097          	auipc	ra,0x0
    800026a2:	e98080e7          	jalr	-360(ra) # 80002536 <wakeup>
    acquire(&p->lock);
    800026a6:	854e                	mv	a0,s3
    800026a8:	ffffe097          	auipc	ra,0xffffe
    800026ac:	71e080e7          	jalr	1822(ra) # 80000dc6 <acquire>
    p->xstate = status;
    800026b0:	0349a623          	sw	s4,44(s3)
    p->state = ZOMBIE;
    800026b4:	4795                	li	a5,5
    800026b6:	00f9ac23          	sw	a5,24(s3)
    release(&wait_lock);
    800026ba:	8526                	mv	a0,s1
    800026bc:	ffffe097          	auipc	ra,0xffffe
    800026c0:	7ba080e7          	jalr	1978(ra) # 80000e76 <release>
    sched();
    800026c4:	00000097          	auipc	ra,0x0
    800026c8:	d04080e7          	jalr	-764(ra) # 800023c8 <sched>
    panic("zombie exit");
    800026cc:	00006517          	auipc	a0,0x6
    800026d0:	bb450513          	addi	a0,a0,-1100 # 80008280 <etext+0x280>
    800026d4:	ffffe097          	auipc	ra,0xffffe
    800026d8:	e8c080e7          	jalr	-372(ra) # 80000560 <panic>

00000000800026dc <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    800026dc:	7179                	addi	sp,sp,-48
    800026de:	f406                	sd	ra,40(sp)
    800026e0:	f022                	sd	s0,32(sp)
    800026e2:	ec26                	sd	s1,24(sp)
    800026e4:	e84a                	sd	s2,16(sp)
    800026e6:	e44e                	sd	s3,8(sp)
    800026e8:	1800                	addi	s0,sp,48
    800026ea:	892a                	mv	s2,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    800026ec:	0044f497          	auipc	s1,0x44f
    800026f0:	aa448493          	addi	s1,s1,-1372 # 80451190 <proc>
    800026f4:	00454997          	auipc	s3,0x454
    800026f8:	49c98993          	addi	s3,s3,1180 # 80456b90 <tickslock>
    {
        acquire(&p->lock);
    800026fc:	8526                	mv	a0,s1
    800026fe:	ffffe097          	auipc	ra,0xffffe
    80002702:	6c8080e7          	jalr	1736(ra) # 80000dc6 <acquire>
        if (p->pid == pid)
    80002706:	589c                	lw	a5,48(s1)
    80002708:	01278d63          	beq	a5,s2,80002722 <kill+0x46>
                p->state = RUNNABLE;
            }
            release(&p->lock);
            return 0;
        }
        release(&p->lock);
    8000270c:	8526                	mv	a0,s1
    8000270e:	ffffe097          	auipc	ra,0xffffe
    80002712:	768080e7          	jalr	1896(ra) # 80000e76 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80002716:	16848493          	addi	s1,s1,360
    8000271a:	ff3491e3          	bne	s1,s3,800026fc <kill+0x20>
    }
    return -1;
    8000271e:	557d                	li	a0,-1
    80002720:	a829                	j	8000273a <kill+0x5e>
            p->killed = 1;
    80002722:	4785                	li	a5,1
    80002724:	d49c                	sw	a5,40(s1)
            if (p->state == SLEEPING)
    80002726:	4c98                	lw	a4,24(s1)
    80002728:	4789                	li	a5,2
    8000272a:	00f70f63          	beq	a4,a5,80002748 <kill+0x6c>
            release(&p->lock);
    8000272e:	8526                	mv	a0,s1
    80002730:	ffffe097          	auipc	ra,0xffffe
    80002734:	746080e7          	jalr	1862(ra) # 80000e76 <release>
            return 0;
    80002738:	4501                	li	a0,0
}
    8000273a:	70a2                	ld	ra,40(sp)
    8000273c:	7402                	ld	s0,32(sp)
    8000273e:	64e2                	ld	s1,24(sp)
    80002740:	6942                	ld	s2,16(sp)
    80002742:	69a2                	ld	s3,8(sp)
    80002744:	6145                	addi	sp,sp,48
    80002746:	8082                	ret
                p->state = RUNNABLE;
    80002748:	478d                	li	a5,3
    8000274a:	cc9c                	sw	a5,24(s1)
    8000274c:	b7cd                	j	8000272e <kill+0x52>

000000008000274e <setkilled>:

void setkilled(struct proc *p)
{
    8000274e:	1101                	addi	sp,sp,-32
    80002750:	ec06                	sd	ra,24(sp)
    80002752:	e822                	sd	s0,16(sp)
    80002754:	e426                	sd	s1,8(sp)
    80002756:	1000                	addi	s0,sp,32
    80002758:	84aa                	mv	s1,a0
    acquire(&p->lock);
    8000275a:	ffffe097          	auipc	ra,0xffffe
    8000275e:	66c080e7          	jalr	1644(ra) # 80000dc6 <acquire>
    p->killed = 1;
    80002762:	4785                	li	a5,1
    80002764:	d49c                	sw	a5,40(s1)
    release(&p->lock);
    80002766:	8526                	mv	a0,s1
    80002768:	ffffe097          	auipc	ra,0xffffe
    8000276c:	70e080e7          	jalr	1806(ra) # 80000e76 <release>
}
    80002770:	60e2                	ld	ra,24(sp)
    80002772:	6442                	ld	s0,16(sp)
    80002774:	64a2                	ld	s1,8(sp)
    80002776:	6105                	addi	sp,sp,32
    80002778:	8082                	ret

000000008000277a <killed>:

int killed(struct proc *p)
{
    8000277a:	1101                	addi	sp,sp,-32
    8000277c:	ec06                	sd	ra,24(sp)
    8000277e:	e822                	sd	s0,16(sp)
    80002780:	e426                	sd	s1,8(sp)
    80002782:	e04a                	sd	s2,0(sp)
    80002784:	1000                	addi	s0,sp,32
    80002786:	84aa                	mv	s1,a0
    int k;

    acquire(&p->lock);
    80002788:	ffffe097          	auipc	ra,0xffffe
    8000278c:	63e080e7          	jalr	1598(ra) # 80000dc6 <acquire>
    k = p->killed;
    80002790:	0284a903          	lw	s2,40(s1)
    release(&p->lock);
    80002794:	8526                	mv	a0,s1
    80002796:	ffffe097          	auipc	ra,0xffffe
    8000279a:	6e0080e7          	jalr	1760(ra) # 80000e76 <release>
    return k;
}
    8000279e:	854a                	mv	a0,s2
    800027a0:	60e2                	ld	ra,24(sp)
    800027a2:	6442                	ld	s0,16(sp)
    800027a4:	64a2                	ld	s1,8(sp)
    800027a6:	6902                	ld	s2,0(sp)
    800027a8:	6105                	addi	sp,sp,32
    800027aa:	8082                	ret

00000000800027ac <wait>:
{
    800027ac:	715d                	addi	sp,sp,-80
    800027ae:	e486                	sd	ra,72(sp)
    800027b0:	e0a2                	sd	s0,64(sp)
    800027b2:	fc26                	sd	s1,56(sp)
    800027b4:	f84a                	sd	s2,48(sp)
    800027b6:	f44e                	sd	s3,40(sp)
    800027b8:	f052                	sd	s4,32(sp)
    800027ba:	ec56                	sd	s5,24(sp)
    800027bc:	e85a                	sd	s6,16(sp)
    800027be:	e45e                	sd	s7,8(sp)
    800027c0:	0880                	addi	s0,sp,80
    800027c2:	8b2a                	mv	s6,a0
    struct proc *p = myproc();
    800027c4:	fffff097          	auipc	ra,0xfffff
    800027c8:	55a080e7          	jalr	1370(ra) # 80001d1e <myproc>
    800027cc:	892a                	mv	s2,a0
    acquire(&wait_lock);
    800027ce:	0044f517          	auipc	a0,0x44f
    800027d2:	9aa50513          	addi	a0,a0,-1622 # 80451178 <wait_lock>
    800027d6:	ffffe097          	auipc	ra,0xffffe
    800027da:	5f0080e7          	jalr	1520(ra) # 80000dc6 <acquire>
                if (pp->state == ZOMBIE)
    800027de:	4a15                	li	s4,5
                havekids = 1;
    800027e0:	4a85                	li	s5,1
        for (pp = proc; pp < &proc[NPROC]; pp++)
    800027e2:	00454997          	auipc	s3,0x454
    800027e6:	3ae98993          	addi	s3,s3,942 # 80456b90 <tickslock>
        sleep(p, &wait_lock); // DOC: wait-sleep
    800027ea:	0044fb97          	auipc	s7,0x44f
    800027ee:	98eb8b93          	addi	s7,s7,-1650 # 80451178 <wait_lock>
    800027f2:	a0c9                	j	800028b4 <wait+0x108>
                    pid = pp->pid;
    800027f4:	0304a983          	lw	s3,48(s1)
                    if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800027f8:	000b0e63          	beqz	s6,80002814 <wait+0x68>
    800027fc:	4691                	li	a3,4
    800027fe:	02c48613          	addi	a2,s1,44
    80002802:	85da                	mv	a1,s6
    80002804:	05093503          	ld	a0,80(s2)
    80002808:	fffff097          	auipc	ra,0xfffff
    8000280c:	08e080e7          	jalr	142(ra) # 80001896 <copyout>
    80002810:	04054063          	bltz	a0,80002850 <wait+0xa4>
                    freeproc(pp);
    80002814:	8526                	mv	a0,s1
    80002816:	fffff097          	auipc	ra,0xfffff
    8000281a:	6ba080e7          	jalr	1722(ra) # 80001ed0 <freeproc>
                    release(&pp->lock);
    8000281e:	8526                	mv	a0,s1
    80002820:	ffffe097          	auipc	ra,0xffffe
    80002824:	656080e7          	jalr	1622(ra) # 80000e76 <release>
                    release(&wait_lock);
    80002828:	0044f517          	auipc	a0,0x44f
    8000282c:	95050513          	addi	a0,a0,-1712 # 80451178 <wait_lock>
    80002830:	ffffe097          	auipc	ra,0xffffe
    80002834:	646080e7          	jalr	1606(ra) # 80000e76 <release>
}
    80002838:	854e                	mv	a0,s3
    8000283a:	60a6                	ld	ra,72(sp)
    8000283c:	6406                	ld	s0,64(sp)
    8000283e:	74e2                	ld	s1,56(sp)
    80002840:	7942                	ld	s2,48(sp)
    80002842:	79a2                	ld	s3,40(sp)
    80002844:	7a02                	ld	s4,32(sp)
    80002846:	6ae2                	ld	s5,24(sp)
    80002848:	6b42                	ld	s6,16(sp)
    8000284a:	6ba2                	ld	s7,8(sp)
    8000284c:	6161                	addi	sp,sp,80
    8000284e:	8082                	ret
                        release(&pp->lock);
    80002850:	8526                	mv	a0,s1
    80002852:	ffffe097          	auipc	ra,0xffffe
    80002856:	624080e7          	jalr	1572(ra) # 80000e76 <release>
                        release(&wait_lock);
    8000285a:	0044f517          	auipc	a0,0x44f
    8000285e:	91e50513          	addi	a0,a0,-1762 # 80451178 <wait_lock>
    80002862:	ffffe097          	auipc	ra,0xffffe
    80002866:	614080e7          	jalr	1556(ra) # 80000e76 <release>
                        return -1;
    8000286a:	59fd                	li	s3,-1
    8000286c:	b7f1                	j	80002838 <wait+0x8c>
        for (pp = proc; pp < &proc[NPROC]; pp++)
    8000286e:	16848493          	addi	s1,s1,360
    80002872:	03348463          	beq	s1,s3,8000289a <wait+0xee>
            if (pp->parent == p)
    80002876:	7c9c                	ld	a5,56(s1)
    80002878:	ff279be3          	bne	a5,s2,8000286e <wait+0xc2>
                acquire(&pp->lock);
    8000287c:	8526                	mv	a0,s1
    8000287e:	ffffe097          	auipc	ra,0xffffe
    80002882:	548080e7          	jalr	1352(ra) # 80000dc6 <acquire>
                if (pp->state == ZOMBIE)
    80002886:	4c9c                	lw	a5,24(s1)
    80002888:	f74786e3          	beq	a5,s4,800027f4 <wait+0x48>
                release(&pp->lock);
    8000288c:	8526                	mv	a0,s1
    8000288e:	ffffe097          	auipc	ra,0xffffe
    80002892:	5e8080e7          	jalr	1512(ra) # 80000e76 <release>
                havekids = 1;
    80002896:	8756                	mv	a4,s5
    80002898:	bfd9                	j	8000286e <wait+0xc2>
        if (!havekids || killed(p))
    8000289a:	c31d                	beqz	a4,800028c0 <wait+0x114>
    8000289c:	854a                	mv	a0,s2
    8000289e:	00000097          	auipc	ra,0x0
    800028a2:	edc080e7          	jalr	-292(ra) # 8000277a <killed>
    800028a6:	ed09                	bnez	a0,800028c0 <wait+0x114>
        sleep(p, &wait_lock); // DOC: wait-sleep
    800028a8:	85de                	mv	a1,s7
    800028aa:	854a                	mv	a0,s2
    800028ac:	00000097          	auipc	ra,0x0
    800028b0:	c26080e7          	jalr	-986(ra) # 800024d2 <sleep>
        havekids = 0;
    800028b4:	4701                	li	a4,0
        for (pp = proc; pp < &proc[NPROC]; pp++)
    800028b6:	0044f497          	auipc	s1,0x44f
    800028ba:	8da48493          	addi	s1,s1,-1830 # 80451190 <proc>
    800028be:	bf65                	j	80002876 <wait+0xca>
            release(&wait_lock);
    800028c0:	0044f517          	auipc	a0,0x44f
    800028c4:	8b850513          	addi	a0,a0,-1864 # 80451178 <wait_lock>
    800028c8:	ffffe097          	auipc	ra,0xffffe
    800028cc:	5ae080e7          	jalr	1454(ra) # 80000e76 <release>
            return -1;
    800028d0:	59fd                	li	s3,-1
    800028d2:	b79d                	j	80002838 <wait+0x8c>

00000000800028d4 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800028d4:	7179                	addi	sp,sp,-48
    800028d6:	f406                	sd	ra,40(sp)
    800028d8:	f022                	sd	s0,32(sp)
    800028da:	ec26                	sd	s1,24(sp)
    800028dc:	e84a                	sd	s2,16(sp)
    800028de:	e44e                	sd	s3,8(sp)
    800028e0:	e052                	sd	s4,0(sp)
    800028e2:	1800                	addi	s0,sp,48
    800028e4:	84aa                	mv	s1,a0
    800028e6:	892e                	mv	s2,a1
    800028e8:	89b2                	mv	s3,a2
    800028ea:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    800028ec:	fffff097          	auipc	ra,0xfffff
    800028f0:	432080e7          	jalr	1074(ra) # 80001d1e <myproc>
    if (user_dst)
    800028f4:	c08d                	beqz	s1,80002916 <either_copyout+0x42>
    {
        return copyout(p->pagetable, dst, src, len);
    800028f6:	86d2                	mv	a3,s4
    800028f8:	864e                	mv	a2,s3
    800028fa:	85ca                	mv	a1,s2
    800028fc:	6928                	ld	a0,80(a0)
    800028fe:	fffff097          	auipc	ra,0xfffff
    80002902:	f98080e7          	jalr	-104(ra) # 80001896 <copyout>
    else
    {
        memmove((char *)dst, src, len);
        return 0;
    }
}
    80002906:	70a2                	ld	ra,40(sp)
    80002908:	7402                	ld	s0,32(sp)
    8000290a:	64e2                	ld	s1,24(sp)
    8000290c:	6942                	ld	s2,16(sp)
    8000290e:	69a2                	ld	s3,8(sp)
    80002910:	6a02                	ld	s4,0(sp)
    80002912:	6145                	addi	sp,sp,48
    80002914:	8082                	ret
        memmove((char *)dst, src, len);
    80002916:	000a061b          	sext.w	a2,s4
    8000291a:	85ce                	mv	a1,s3
    8000291c:	854a                	mv	a0,s2
    8000291e:	ffffe097          	auipc	ra,0xffffe
    80002922:	604080e7          	jalr	1540(ra) # 80000f22 <memmove>
        return 0;
    80002926:	8526                	mv	a0,s1
    80002928:	bff9                	j	80002906 <either_copyout+0x32>

000000008000292a <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000292a:	7179                	addi	sp,sp,-48
    8000292c:	f406                	sd	ra,40(sp)
    8000292e:	f022                	sd	s0,32(sp)
    80002930:	ec26                	sd	s1,24(sp)
    80002932:	e84a                	sd	s2,16(sp)
    80002934:	e44e                	sd	s3,8(sp)
    80002936:	e052                	sd	s4,0(sp)
    80002938:	1800                	addi	s0,sp,48
    8000293a:	892a                	mv	s2,a0
    8000293c:	84ae                	mv	s1,a1
    8000293e:	89b2                	mv	s3,a2
    80002940:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    80002942:	fffff097          	auipc	ra,0xfffff
    80002946:	3dc080e7          	jalr	988(ra) # 80001d1e <myproc>
    if (user_src)
    8000294a:	c08d                	beqz	s1,8000296c <either_copyin+0x42>
    {
        return copyin(p->pagetable, dst, src, len);
    8000294c:	86d2                	mv	a3,s4
    8000294e:	864e                	mv	a2,s3
    80002950:	85ca                	mv	a1,s2
    80002952:	6928                	ld	a0,80(a0)
    80002954:	fffff097          	auipc	ra,0xfffff
    80002958:	fce080e7          	jalr	-50(ra) # 80001922 <copyin>
    else
    {
        memmove(dst, (char *)src, len);
        return 0;
    }
}
    8000295c:	70a2                	ld	ra,40(sp)
    8000295e:	7402                	ld	s0,32(sp)
    80002960:	64e2                	ld	s1,24(sp)
    80002962:	6942                	ld	s2,16(sp)
    80002964:	69a2                	ld	s3,8(sp)
    80002966:	6a02                	ld	s4,0(sp)
    80002968:	6145                	addi	sp,sp,48
    8000296a:	8082                	ret
        memmove(dst, (char *)src, len);
    8000296c:	000a061b          	sext.w	a2,s4
    80002970:	85ce                	mv	a1,s3
    80002972:	854a                	mv	a0,s2
    80002974:	ffffe097          	auipc	ra,0xffffe
    80002978:	5ae080e7          	jalr	1454(ra) # 80000f22 <memmove>
        return 0;
    8000297c:	8526                	mv	a0,s1
    8000297e:	bff9                	j	8000295c <either_copyin+0x32>

0000000080002980 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    80002980:	715d                	addi	sp,sp,-80
    80002982:	e486                	sd	ra,72(sp)
    80002984:	e0a2                	sd	s0,64(sp)
    80002986:	fc26                	sd	s1,56(sp)
    80002988:	f84a                	sd	s2,48(sp)
    8000298a:	f44e                	sd	s3,40(sp)
    8000298c:	f052                	sd	s4,32(sp)
    8000298e:	ec56                	sd	s5,24(sp)
    80002990:	e85a                	sd	s6,16(sp)
    80002992:	e45e                	sd	s7,8(sp)
    80002994:	0880                	addi	s0,sp,80
        [RUNNING] "run   ",
        [ZOMBIE] "zombie"};
    struct proc *p;
    char *state;

    printf("\n");
    80002996:	00005517          	auipc	a0,0x5
    8000299a:	67a50513          	addi	a0,a0,1658 # 80008010 <etext+0x10>
    8000299e:	ffffe097          	auipc	ra,0xffffe
    800029a2:	c1e080e7          	jalr	-994(ra) # 800005bc <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    800029a6:	0044f497          	auipc	s1,0x44f
    800029aa:	94248493          	addi	s1,s1,-1726 # 804512e8 <proc+0x158>
    800029ae:	00454917          	auipc	s2,0x454
    800029b2:	33a90913          	addi	s2,s2,826 # 80456ce8 <bcache+0x140>
    {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800029b6:	4b15                	li	s6,5
            state = states[p->state];
        else
            state = "???";
    800029b8:	00006997          	auipc	s3,0x6
    800029bc:	8d898993          	addi	s3,s3,-1832 # 80008290 <etext+0x290>
        printf("%d <%s %s", p->pid, state, p->name);
    800029c0:	00006a97          	auipc	s5,0x6
    800029c4:	8d8a8a93          	addi	s5,s5,-1832 # 80008298 <etext+0x298>
        printf("\n");
    800029c8:	00005a17          	auipc	s4,0x5
    800029cc:	648a0a13          	addi	s4,s4,1608 # 80008010 <etext+0x10>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800029d0:	00006b97          	auipc	s7,0x6
    800029d4:	f38b8b93          	addi	s7,s7,-200 # 80008908 <states.0>
    800029d8:	a00d                	j	800029fa <procdump+0x7a>
        printf("%d <%s %s", p->pid, state, p->name);
    800029da:	ed86a583          	lw	a1,-296(a3)
    800029de:	8556                	mv	a0,s5
    800029e0:	ffffe097          	auipc	ra,0xffffe
    800029e4:	bdc080e7          	jalr	-1060(ra) # 800005bc <printf>
        printf("\n");
    800029e8:	8552                	mv	a0,s4
    800029ea:	ffffe097          	auipc	ra,0xffffe
    800029ee:	bd2080e7          	jalr	-1070(ra) # 800005bc <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    800029f2:	16848493          	addi	s1,s1,360
    800029f6:	03248263          	beq	s1,s2,80002a1a <procdump+0x9a>
        if (p->state == UNUSED)
    800029fa:	86a6                	mv	a3,s1
    800029fc:	ec04a783          	lw	a5,-320(s1)
    80002a00:	dbed                	beqz	a5,800029f2 <procdump+0x72>
            state = "???";
    80002a02:	864e                	mv	a2,s3
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002a04:	fcfb6be3          	bltu	s6,a5,800029da <procdump+0x5a>
    80002a08:	02079713          	slli	a4,a5,0x20
    80002a0c:	01d75793          	srli	a5,a4,0x1d
    80002a10:	97de                	add	a5,a5,s7
    80002a12:	6390                	ld	a2,0(a5)
    80002a14:	f279                	bnez	a2,800029da <procdump+0x5a>
            state = "???";
    80002a16:	864e                	mv	a2,s3
    80002a18:	b7c9                	j	800029da <procdump+0x5a>
    }
}
    80002a1a:	60a6                	ld	ra,72(sp)
    80002a1c:	6406                	ld	s0,64(sp)
    80002a1e:	74e2                	ld	s1,56(sp)
    80002a20:	7942                	ld	s2,48(sp)
    80002a22:	79a2                	ld	s3,40(sp)
    80002a24:	7a02                	ld	s4,32(sp)
    80002a26:	6ae2                	ld	s5,24(sp)
    80002a28:	6b42                	ld	s6,16(sp)
    80002a2a:	6ba2                	ld	s7,8(sp)
    80002a2c:	6161                	addi	sp,sp,80
    80002a2e:	8082                	ret

0000000080002a30 <schedls>:

void schedls()
{
    80002a30:	1141                	addi	sp,sp,-16
    80002a32:	e406                	sd	ra,8(sp)
    80002a34:	e022                	sd	s0,0(sp)
    80002a36:	0800                	addi	s0,sp,16
    printf("[ ]\tScheduler Name\tScheduler ID\n");
    80002a38:	00006517          	auipc	a0,0x6
    80002a3c:	87050513          	addi	a0,a0,-1936 # 800082a8 <etext+0x2a8>
    80002a40:	ffffe097          	auipc	ra,0xffffe
    80002a44:	b7c080e7          	jalr	-1156(ra) # 800005bc <printf>
    printf("====================================\n");
    80002a48:	00006517          	auipc	a0,0x6
    80002a4c:	88850513          	addi	a0,a0,-1912 # 800082d0 <etext+0x2d0>
    80002a50:	ffffe097          	auipc	ra,0xffffe
    80002a54:	b6c080e7          	jalr	-1172(ra) # 800005bc <printf>
    for (int i = 0; i < SCHEDC; i++)
    {
        if (available_schedulers[i].impl == sched_pointer)
    80002a58:	00006717          	auipc	a4,0x6
    80002a5c:	04073703          	ld	a4,64(a4) # 80008a98 <available_schedulers+0x10>
    80002a60:	00006797          	auipc	a5,0x6
    80002a64:	fd87b783          	ld	a5,-40(a5) # 80008a38 <sched_pointer>
    80002a68:	04f70663          	beq	a4,a5,80002ab4 <schedls+0x84>
        {
            printf("[*]\t");
        }
        else
        {
            printf("   \t");
    80002a6c:	00006517          	auipc	a0,0x6
    80002a70:	89450513          	addi	a0,a0,-1900 # 80008300 <etext+0x300>
    80002a74:	ffffe097          	auipc	ra,0xffffe
    80002a78:	b48080e7          	jalr	-1208(ra) # 800005bc <printf>
        }
        printf("%s\t%d\n", available_schedulers[i].name, available_schedulers[i].id);
    80002a7c:	00006617          	auipc	a2,0x6
    80002a80:	02462603          	lw	a2,36(a2) # 80008aa0 <available_schedulers+0x18>
    80002a84:	00006597          	auipc	a1,0x6
    80002a88:	00458593          	addi	a1,a1,4 # 80008a88 <available_schedulers>
    80002a8c:	00006517          	auipc	a0,0x6
    80002a90:	87c50513          	addi	a0,a0,-1924 # 80008308 <etext+0x308>
    80002a94:	ffffe097          	auipc	ra,0xffffe
    80002a98:	b28080e7          	jalr	-1240(ra) # 800005bc <printf>
    }
    printf("\n*: current scheduler\n\n");
    80002a9c:	00006517          	auipc	a0,0x6
    80002aa0:	87450513          	addi	a0,a0,-1932 # 80008310 <etext+0x310>
    80002aa4:	ffffe097          	auipc	ra,0xffffe
    80002aa8:	b18080e7          	jalr	-1256(ra) # 800005bc <printf>
}
    80002aac:	60a2                	ld	ra,8(sp)
    80002aae:	6402                	ld	s0,0(sp)
    80002ab0:	0141                	addi	sp,sp,16
    80002ab2:	8082                	ret
            printf("[*]\t");
    80002ab4:	00006517          	auipc	a0,0x6
    80002ab8:	84450513          	addi	a0,a0,-1980 # 800082f8 <etext+0x2f8>
    80002abc:	ffffe097          	auipc	ra,0xffffe
    80002ac0:	b00080e7          	jalr	-1280(ra) # 800005bc <printf>
    80002ac4:	bf65                	j	80002a7c <schedls+0x4c>

0000000080002ac6 <schedset>:

void schedset(int id)
{
    80002ac6:	1141                	addi	sp,sp,-16
    80002ac8:	e406                	sd	ra,8(sp)
    80002aca:	e022                	sd	s0,0(sp)
    80002acc:	0800                	addi	s0,sp,16
    if (id < 0 || SCHEDC <= id)
    80002ace:	e90d                	bnez	a0,80002b00 <schedset+0x3a>
    {
        printf("Scheduler unchanged: ID out of range\n");
        return;
    }
    sched_pointer = available_schedulers[id].impl;
    80002ad0:	00006797          	auipc	a5,0x6
    80002ad4:	fc87b783          	ld	a5,-56(a5) # 80008a98 <available_schedulers+0x10>
    80002ad8:	00006717          	auipc	a4,0x6
    80002adc:	f6f73023          	sd	a5,-160(a4) # 80008a38 <sched_pointer>
    printf("Scheduler successfully changed to %s\n", available_schedulers[id].name);
    80002ae0:	00006597          	auipc	a1,0x6
    80002ae4:	fa858593          	addi	a1,a1,-88 # 80008a88 <available_schedulers>
    80002ae8:	00006517          	auipc	a0,0x6
    80002aec:	86850513          	addi	a0,a0,-1944 # 80008350 <etext+0x350>
    80002af0:	ffffe097          	auipc	ra,0xffffe
    80002af4:	acc080e7          	jalr	-1332(ra) # 800005bc <printf>
}
    80002af8:	60a2                	ld	ra,8(sp)
    80002afa:	6402                	ld	s0,0(sp)
    80002afc:	0141                	addi	sp,sp,16
    80002afe:	8082                	ret
        printf("Scheduler unchanged: ID out of range\n");
    80002b00:	00006517          	auipc	a0,0x6
    80002b04:	82850513          	addi	a0,a0,-2008 # 80008328 <etext+0x328>
    80002b08:	ffffe097          	auipc	ra,0xffffe
    80002b0c:	ab4080e7          	jalr	-1356(ra) # 800005bc <printf>
        return;
    80002b10:	b7e5                	j	80002af8 <schedset+0x32>

0000000080002b12 <swtch>:
    80002b12:	00153023          	sd	ra,0(a0)
    80002b16:	00253423          	sd	sp,8(a0)
    80002b1a:	e900                	sd	s0,16(a0)
    80002b1c:	ed04                	sd	s1,24(a0)
    80002b1e:	03253023          	sd	s2,32(a0)
    80002b22:	03353423          	sd	s3,40(a0)
    80002b26:	03453823          	sd	s4,48(a0)
    80002b2a:	03553c23          	sd	s5,56(a0)
    80002b2e:	05653023          	sd	s6,64(a0)
    80002b32:	05753423          	sd	s7,72(a0)
    80002b36:	05853823          	sd	s8,80(a0)
    80002b3a:	05953c23          	sd	s9,88(a0)
    80002b3e:	07a53023          	sd	s10,96(a0)
    80002b42:	07b53423          	sd	s11,104(a0)
    80002b46:	0005b083          	ld	ra,0(a1)
    80002b4a:	0085b103          	ld	sp,8(a1)
    80002b4e:	6980                	ld	s0,16(a1)
    80002b50:	6d84                	ld	s1,24(a1)
    80002b52:	0205b903          	ld	s2,32(a1)
    80002b56:	0285b983          	ld	s3,40(a1)
    80002b5a:	0305ba03          	ld	s4,48(a1)
    80002b5e:	0385ba83          	ld	s5,56(a1)
    80002b62:	0405bb03          	ld	s6,64(a1)
    80002b66:	0485bb83          	ld	s7,72(a1)
    80002b6a:	0505bc03          	ld	s8,80(a1)
    80002b6e:	0585bc83          	ld	s9,88(a1)
    80002b72:	0605bd03          	ld	s10,96(a1)
    80002b76:	0685bd83          	ld	s11,104(a1)
    80002b7a:	8082                	ret

0000000080002b7c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002b7c:	1141                	addi	sp,sp,-16
    80002b7e:	e406                	sd	ra,8(sp)
    80002b80:	e022                	sd	s0,0(sp)
    80002b82:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002b84:	00006597          	auipc	a1,0x6
    80002b88:	82458593          	addi	a1,a1,-2012 # 800083a8 <etext+0x3a8>
    80002b8c:	00454517          	auipc	a0,0x454
    80002b90:	00450513          	addi	a0,a0,4 # 80456b90 <tickslock>
    80002b94:	ffffe097          	auipc	ra,0xffffe
    80002b98:	19e080e7          	jalr	414(ra) # 80000d32 <initlock>
}
    80002b9c:	60a2                	ld	ra,8(sp)
    80002b9e:	6402                	ld	s0,0(sp)
    80002ba0:	0141                	addi	sp,sp,16
    80002ba2:	8082                	ret

0000000080002ba4 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002ba4:	1141                	addi	sp,sp,-16
    80002ba6:	e406                	sd	ra,8(sp)
    80002ba8:	e022                	sd	s0,0(sp)
    80002baa:	0800                	addi	s0,sp,16
    asm volatile("csrw stvec, %0" : : "r"(x));
    80002bac:	00004797          	auipc	a5,0x4
    80002bb0:	87478793          	addi	a5,a5,-1932 # 80006420 <kernelvec>
    80002bb4:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002bb8:	60a2                	ld	ra,8(sp)
    80002bba:	6402                	ld	s0,0(sp)
    80002bbc:	0141                	addi	sp,sp,16
    80002bbe:	8082                	ret

0000000080002bc0 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002bc0:	1141                	addi	sp,sp,-16
    80002bc2:	e406                	sd	ra,8(sp)
    80002bc4:	e022                	sd	s0,0(sp)
    80002bc6:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002bc8:	fffff097          	auipc	ra,0xfffff
    80002bcc:	156080e7          	jalr	342(ra) # 80001d1e <myproc>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002bd0:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002bd4:	9bf5                	andi	a5,a5,-3
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80002bd6:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002bda:	00004697          	auipc	a3,0x4
    80002bde:	42668693          	addi	a3,a3,1062 # 80007000 <_trampoline>
    80002be2:	00004717          	auipc	a4,0x4
    80002be6:	41e70713          	addi	a4,a4,1054 # 80007000 <_trampoline>
    80002bea:	8f15                	sub	a4,a4,a3
    80002bec:	040007b7          	lui	a5,0x4000
    80002bf0:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002bf2:	07b2                	slli	a5,a5,0xc
    80002bf4:	973e                	add	a4,a4,a5
    asm volatile("csrw stvec, %0" : : "r"(x));
    80002bf6:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002bfa:	6d38                	ld	a4,88(a0)
    asm volatile("csrr %0, satp" : "=r"(x));
    80002bfc:	18002673          	csrr	a2,satp
    80002c00:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002c02:	6d30                	ld	a2,88(a0)
    80002c04:	6138                	ld	a4,64(a0)
    80002c06:	6585                	lui	a1,0x1
    80002c08:	972e                	add	a4,a4,a1
    80002c0a:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002c0c:	6d38                	ld	a4,88(a0)
    80002c0e:	00000617          	auipc	a2,0x0
    80002c12:	13860613          	addi	a2,a2,312 # 80002d46 <usertrap>
    80002c16:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002c18:	6d38                	ld	a4,88(a0)
    asm volatile("mv %0, tp" : "=r"(x));
    80002c1a:	8612                	mv	a2,tp
    80002c1c:	f310                	sd	a2,32(a4)
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002c1e:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002c22:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002c26:	02076713          	ori	a4,a4,32
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80002c2a:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002c2e:	6d38                	ld	a4,88(a0)
    asm volatile("csrw sepc, %0" : : "r"(x));
    80002c30:	6f18                	ld	a4,24(a4)
    80002c32:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002c36:	6928                	ld	a0,80(a0)
    80002c38:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002c3a:	00004717          	auipc	a4,0x4
    80002c3e:	46270713          	addi	a4,a4,1122 # 8000709c <userret>
    80002c42:	8f15                	sub	a4,a4,a3
    80002c44:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002c46:	577d                	li	a4,-1
    80002c48:	177e                	slli	a4,a4,0x3f
    80002c4a:	8d59                	or	a0,a0,a4
    80002c4c:	9782                	jalr	a5
}
    80002c4e:	60a2                	ld	ra,8(sp)
    80002c50:	6402                	ld	s0,0(sp)
    80002c52:	0141                	addi	sp,sp,16
    80002c54:	8082                	ret

0000000080002c56 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002c56:	1101                	addi	sp,sp,-32
    80002c58:	ec06                	sd	ra,24(sp)
    80002c5a:	e822                	sd	s0,16(sp)
    80002c5c:	e426                	sd	s1,8(sp)
    80002c5e:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002c60:	00454497          	auipc	s1,0x454
    80002c64:	f3048493          	addi	s1,s1,-208 # 80456b90 <tickslock>
    80002c68:	8526                	mv	a0,s1
    80002c6a:	ffffe097          	auipc	ra,0xffffe
    80002c6e:	15c080e7          	jalr	348(ra) # 80000dc6 <acquire>
  ticks++;
    80002c72:	00006517          	auipc	a0,0x6
    80002c76:	e7e50513          	addi	a0,a0,-386 # 80008af0 <ticks>
    80002c7a:	411c                	lw	a5,0(a0)
    80002c7c:	2785                	addiw	a5,a5,1
    80002c7e:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002c80:	00000097          	auipc	ra,0x0
    80002c84:	8b6080e7          	jalr	-1866(ra) # 80002536 <wakeup>
  release(&tickslock);
    80002c88:	8526                	mv	a0,s1
    80002c8a:	ffffe097          	auipc	ra,0xffffe
    80002c8e:	1ec080e7          	jalr	492(ra) # 80000e76 <release>
}
    80002c92:	60e2                	ld	ra,24(sp)
    80002c94:	6442                	ld	s0,16(sp)
    80002c96:	64a2                	ld	s1,8(sp)
    80002c98:	6105                	addi	sp,sp,32
    80002c9a:	8082                	ret

0000000080002c9c <devintr>:
    asm volatile("csrr %0, scause" : "=r"(x));
    80002c9c:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002ca0:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80002ca2:	0a07d163          	bgez	a5,80002d44 <devintr+0xa8>
{
    80002ca6:	1101                	addi	sp,sp,-32
    80002ca8:	ec06                	sd	ra,24(sp)
    80002caa:	e822                	sd	s0,16(sp)
    80002cac:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80002cae:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80002cb2:	46a5                	li	a3,9
    80002cb4:	00d70c63          	beq	a4,a3,80002ccc <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80002cb8:	577d                	li	a4,-1
    80002cba:	177e                	slli	a4,a4,0x3f
    80002cbc:	0705                	addi	a4,a4,1
    return 0;
    80002cbe:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002cc0:	06e78163          	beq	a5,a4,80002d22 <devintr+0x86>
  }
}
    80002cc4:	60e2                	ld	ra,24(sp)
    80002cc6:	6442                	ld	s0,16(sp)
    80002cc8:	6105                	addi	sp,sp,32
    80002cca:	8082                	ret
    80002ccc:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002cce:	00004097          	auipc	ra,0x4
    80002cd2:	85e080e7          	jalr	-1954(ra) # 8000652c <plic_claim>
    80002cd6:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002cd8:	47a9                	li	a5,10
    80002cda:	00f50963          	beq	a0,a5,80002cec <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80002cde:	4785                	li	a5,1
    80002ce0:	00f50b63          	beq	a0,a5,80002cf6 <devintr+0x5a>
    return 1;
    80002ce4:	4505                	li	a0,1
    } else if(irq){
    80002ce6:	ec89                	bnez	s1,80002d00 <devintr+0x64>
    80002ce8:	64a2                	ld	s1,8(sp)
    80002cea:	bfe9                	j	80002cc4 <devintr+0x28>
      uartintr();
    80002cec:	ffffe097          	auipc	ra,0xffffe
    80002cf0:	d22080e7          	jalr	-734(ra) # 80000a0e <uartintr>
    if(irq)
    80002cf4:	a839                	j	80002d12 <devintr+0x76>
      virtio_disk_intr();
    80002cf6:	00004097          	auipc	ra,0x4
    80002cfa:	d2a080e7          	jalr	-726(ra) # 80006a20 <virtio_disk_intr>
    if(irq)
    80002cfe:	a811                	j	80002d12 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80002d00:	85a6                	mv	a1,s1
    80002d02:	00005517          	auipc	a0,0x5
    80002d06:	6ae50513          	addi	a0,a0,1710 # 800083b0 <etext+0x3b0>
    80002d0a:	ffffe097          	auipc	ra,0xffffe
    80002d0e:	8b2080e7          	jalr	-1870(ra) # 800005bc <printf>
      plic_complete(irq);
    80002d12:	8526                	mv	a0,s1
    80002d14:	00004097          	auipc	ra,0x4
    80002d18:	83c080e7          	jalr	-1988(ra) # 80006550 <plic_complete>
    return 1;
    80002d1c:	4505                	li	a0,1
    80002d1e:	64a2                	ld	s1,8(sp)
    80002d20:	b755                	j	80002cc4 <devintr+0x28>
    if(cpuid() == 0){
    80002d22:	fffff097          	auipc	ra,0xfffff
    80002d26:	fc8080e7          	jalr	-56(ra) # 80001cea <cpuid>
    80002d2a:	c901                	beqz	a0,80002d3a <devintr+0x9e>
    asm volatile("csrr %0, sip" : "=r"(x));
    80002d2c:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002d30:	9bf5                	andi	a5,a5,-3
    asm volatile("csrw sip, %0" : : "r"(x));
    80002d32:	14479073          	csrw	sip,a5
    return 2;
    80002d36:	4509                	li	a0,2
    80002d38:	b771                	j	80002cc4 <devintr+0x28>
      clockintr();
    80002d3a:	00000097          	auipc	ra,0x0
    80002d3e:	f1c080e7          	jalr	-228(ra) # 80002c56 <clockintr>
    80002d42:	b7ed                	j	80002d2c <devintr+0x90>
}
    80002d44:	8082                	ret

0000000080002d46 <usertrap>:
{
    80002d46:	7139                	addi	sp,sp,-64
    80002d48:	fc06                	sd	ra,56(sp)
    80002d4a:	f822                	sd	s0,48(sp)
    80002d4c:	0080                	addi	s0,sp,64
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002d4e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002d52:	1007f793          	andi	a5,a5,256
    80002d56:	ebb9                	bnez	a5,80002dac <usertrap+0x66>
    80002d58:	f426                	sd	s1,40(sp)
    80002d5a:	f04a                	sd	s2,32(sp)
    asm volatile("csrw stvec, %0" : : "r"(x));
    80002d5c:	00003797          	auipc	a5,0x3
    80002d60:	6c478793          	addi	a5,a5,1732 # 80006420 <kernelvec>
    80002d64:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002d68:	fffff097          	auipc	ra,0xfffff
    80002d6c:	fb6080e7          	jalr	-74(ra) # 80001d1e <myproc>
    80002d70:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002d72:	6d3c                	ld	a5,88(a0)
    asm volatile("csrr %0, sepc" : "=r"(x));
    80002d74:	14102773          	csrr	a4,sepc
    80002d78:	ef98                	sd	a4,24(a5)
    asm volatile("csrr %0, scause" : "=r"(x));
    80002d7a:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002d7e:	47a1                	li	a5,8
    80002d80:	04f70363          	beq	a4,a5,80002dc6 <usertrap+0x80>
    80002d84:	14202773          	csrr	a4,scause
  } else if(r_scause() == 15) {  // Store/AMO page fault
    80002d88:	47bd                	li	a5,15
    80002d8a:	08f70863          	beq	a4,a5,80002e1a <usertrap+0xd4>
  } else if((which_dev = devintr()) != 0){
    80002d8e:	00000097          	auipc	ra,0x0
    80002d92:	f0e080e7          	jalr	-242(ra) # 80002c9c <devintr>
    80002d96:	892a                	mv	s2,a0
    80002d98:	1a050163          	beqz	a0,80002f3a <usertrap+0x1f4>
  if(killed(p))
    80002d9c:	8526                	mv	a0,s1
    80002d9e:	00000097          	auipc	ra,0x0
    80002da2:	9dc080e7          	jalr	-1572(ra) # 8000277a <killed>
    80002da6:	1c050a63          	beqz	a0,80002f7a <usertrap+0x234>
    80002daa:	a2d9                	j	80002f70 <usertrap+0x22a>
    80002dac:	f426                	sd	s1,40(sp)
    80002dae:	f04a                	sd	s2,32(sp)
    80002db0:	ec4e                	sd	s3,24(sp)
    80002db2:	e852                	sd	s4,16(sp)
    80002db4:	e456                	sd	s5,8(sp)
    panic("usertrap: not from user mode");
    80002db6:	00005517          	auipc	a0,0x5
    80002dba:	61a50513          	addi	a0,a0,1562 # 800083d0 <etext+0x3d0>
    80002dbe:	ffffd097          	auipc	ra,0xffffd
    80002dc2:	7a2080e7          	jalr	1954(ra) # 80000560 <panic>
    if(killed(p))
    80002dc6:	00000097          	auipc	ra,0x0
    80002dca:	9b4080e7          	jalr	-1612(ra) # 8000277a <killed>
    80002dce:	e121                	bnez	a0,80002e0e <usertrap+0xc8>
    p->trapframe->epc += 4;
    80002dd0:	6cb8                	ld	a4,88(s1)
    80002dd2:	6f1c                	ld	a5,24(a4)
    80002dd4:	0791                	addi	a5,a5,4
    80002dd6:	ef1c                	sd	a5,24(a4)
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002dd8:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002ddc:	0027e793          	ori	a5,a5,2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80002de0:	10079073          	csrw	sstatus,a5
    syscall();
    80002de4:	00000097          	auipc	ra,0x0
    80002de8:	3e8080e7          	jalr	1000(ra) # 800031cc <syscall>
  if(killed(p))
    80002dec:	8526                	mv	a0,s1
    80002dee:	00000097          	auipc	ra,0x0
    80002df2:	98c080e7          	jalr	-1652(ra) # 8000277a <killed>
    80002df6:	16051c63          	bnez	a0,80002f6e <usertrap+0x228>
  usertrapret();
    80002dfa:	00000097          	auipc	ra,0x0
    80002dfe:	dc6080e7          	jalr	-570(ra) # 80002bc0 <usertrapret>
    80002e02:	74a2                	ld	s1,40(sp)
    80002e04:	7902                	ld	s2,32(sp)
}
    80002e06:	70e2                	ld	ra,56(sp)
    80002e08:	7442                	ld	s0,48(sp)
    80002e0a:	6121                	addi	sp,sp,64
    80002e0c:	8082                	ret
      exit(-1);
    80002e0e:	557d                	li	a0,-1
    80002e10:	fffff097          	auipc	ra,0xfffff
    80002e14:	7f6080e7          	jalr	2038(ra) # 80002606 <exit>
    80002e18:	bf65                	j	80002dd0 <usertrap+0x8a>
    80002e1a:	e456                	sd	s5,8(sp)
    asm volatile("csrr %0, stval" : "=r"(x));
    80002e1c:	14302af3          	csrr	s5,stval
    va = PGROUNDDOWN(va);
    80002e20:	77fd                	lui	a5,0xfffff
    80002e22:	00fafab3          	and	s5,s5,a5
    pte_t *pte = walk(p->pagetable, va, 0);
    80002e26:	4601                	li	a2,0
    80002e28:	85d6                	mv	a1,s5
    80002e2a:	6928                	ld	a0,80(a0)
    80002e2c:	ffffe097          	auipc	ra,0xffffe
    80002e30:	38e080e7          	jalr	910(ra) # 800011ba <walk>
    80002e34:	892a                	mv	s2,a0
    if(pte == 0) {
    80002e36:	cd2d                	beqz	a0,80002eb0 <usertrap+0x16a>
    if((*pte & PTE_V) == 0) {
    80002e38:	611c                	ld	a5,0(a0)
    80002e3a:	0017f713          	andi	a4,a5,1
    80002e3e:	c749                	beqz	a4,80002ec8 <usertrap+0x182>
    if((*pte & PTE_COW) && (*pte & PTE_V)) {
    80002e40:	0817f713          	andi	a4,a5,129
    80002e44:	08100693          	li	a3,129
    80002e48:	0cd71d63          	bne	a4,a3,80002f22 <usertrap+0x1dc>
    80002e4c:	ec4e                	sd	s3,24(sp)
    80002e4e:	e852                	sd	s4,16(sp)
        uint64 pa = PTE2PA(*pte);
    80002e50:	83a9                	srli	a5,a5,0xa
    80002e52:	00c79993          	slli	s3,a5,0xc
        char *mem = kalloc();
    80002e56:	ffffe097          	auipc	ra,0xffffe
    80002e5a:	dac080e7          	jalr	-596(ra) # 80000c02 <kalloc>
    80002e5e:	8a2a                	mv	s4,a0
        if(mem == 0) {
    80002e60:	c141                	beqz	a0,80002ee0 <usertrap+0x19a>
        memmove(mem, (char*)pa, PGSIZE);
    80002e62:	6605                	lui	a2,0x1
    80002e64:	85ce                	mv	a1,s3
    80002e66:	ffffe097          	auipc	ra,0xffffe
    80002e6a:	0bc080e7          	jalr	188(ra) # 80000f22 <memmove>
        uint flags = (PTE_FLAGS(*pte) | PTE_W) & ~PTE_COW;
    80002e6e:	00093903          	ld	s2,0(s2)
    80002e72:	37b97913          	andi	s2,s2,891
    80002e76:	00496913          	ori	s2,s2,4
        uvmunmap(p->pagetable, va, 1, 0);
    80002e7a:	4681                	li	a3,0
    80002e7c:	4605                	li	a2,1
    80002e7e:	85d6                	mv	a1,s5
    80002e80:	68a8                	ld	a0,80(s1)
    80002e82:	ffffe097          	auipc	ra,0xffffe
    80002e86:	5e6080e7          	jalr	1510(ra) # 80001468 <uvmunmap>
        if(mappages(p->pagetable, va, PGSIZE, (uint64)mem, flags) != 0) {
    80002e8a:	874a                	mv	a4,s2
    80002e8c:	86d2                	mv	a3,s4
    80002e8e:	6605                	lui	a2,0x1
    80002e90:	85d6                	mv	a1,s5
    80002e92:	68a8                	ld	a0,80(s1)
    80002e94:	ffffe097          	auipc	ra,0xffffe
    80002e98:	40e080e7          	jalr	1038(ra) # 800012a2 <mappages>
    80002e9c:	e125                	bnez	a0,80002efc <usertrap+0x1b6>
        kfree((void*)pa);
    80002e9e:	854e                	mv	a0,s3
    80002ea0:	ffffe097          	auipc	ra,0xffffe
    80002ea4:	bbe080e7          	jalr	-1090(ra) # 80000a5e <kfree>
    80002ea8:	69e2                	ld	s3,24(sp)
    80002eaa:	6a42                	ld	s4,16(sp)
    80002eac:	6aa2                	ld	s5,8(sp)
    80002eae:	bf3d                	j	80002dec <usertrap+0xa6>
        printf("usertrap(): page fault pte == 0\n");
    80002eb0:	00005517          	auipc	a0,0x5
    80002eb4:	54050513          	addi	a0,a0,1344 # 800083f0 <etext+0x3f0>
    80002eb8:	ffffd097          	auipc	ra,0xffffd
    80002ebc:	704080e7          	jalr	1796(ra) # 800005bc <printf>
        p->killed = 1;
    80002ec0:	4785                	li	a5,1
    80002ec2:	d49c                	sw	a5,40(s1)
        goto end;
    80002ec4:	6aa2                	ld	s5,8(sp)
    80002ec6:	b71d                	j	80002dec <usertrap+0xa6>
        printf("usertrap(): page not present\n");
    80002ec8:	00005517          	auipc	a0,0x5
    80002ecc:	55050513          	addi	a0,a0,1360 # 80008418 <etext+0x418>
    80002ed0:	ffffd097          	auipc	ra,0xffffd
    80002ed4:	6ec080e7          	jalr	1772(ra) # 800005bc <printf>
        p->killed = 1;
    80002ed8:	4785                	li	a5,1
    80002eda:	d49c                	sw	a5,40(s1)
        goto end;
    80002edc:	6aa2                	ld	s5,8(sp)
    80002ede:	b739                	j	80002dec <usertrap+0xa6>
            printf("usertrap(): page fault kalloc failed\n");
    80002ee0:	00005517          	auipc	a0,0x5
    80002ee4:	55850513          	addi	a0,a0,1368 # 80008438 <etext+0x438>
    80002ee8:	ffffd097          	auipc	ra,0xffffd
    80002eec:	6d4080e7          	jalr	1748(ra) # 800005bc <printf>
            p->killed = 1;
    80002ef0:	4785                	li	a5,1
    80002ef2:	d49c                	sw	a5,40(s1)
            goto end;
    80002ef4:	69e2                	ld	s3,24(sp)
    80002ef6:	6a42                	ld	s4,16(sp)
    80002ef8:	6aa2                	ld	s5,8(sp)
    80002efa:	bdcd                	j	80002dec <usertrap+0xa6>
            kfree(mem);
    80002efc:	8552                	mv	a0,s4
    80002efe:	ffffe097          	auipc	ra,0xffffe
    80002f02:	b60080e7          	jalr	-1184(ra) # 80000a5e <kfree>
            printf("usertrap(): page fault mappages failed\n");
    80002f06:	00005517          	auipc	a0,0x5
    80002f0a:	55a50513          	addi	a0,a0,1370 # 80008460 <etext+0x460>
    80002f0e:	ffffd097          	auipc	ra,0xffffd
    80002f12:	6ae080e7          	jalr	1710(ra) # 800005bc <printf>
            p->killed = 1;
    80002f16:	4785                	li	a5,1
    80002f18:	d49c                	sw	a5,40(s1)
            goto end;
    80002f1a:	69e2                	ld	s3,24(sp)
    80002f1c:	6a42                	ld	s4,16(sp)
    80002f1e:	6aa2                	ld	s5,8(sp)
    80002f20:	b5f1                	j	80002dec <usertrap+0xa6>
        printf("usertrap(): not a COW page fault\n");
    80002f22:	00005517          	auipc	a0,0x5
    80002f26:	56650513          	addi	a0,a0,1382 # 80008488 <etext+0x488>
    80002f2a:	ffffd097          	auipc	ra,0xffffd
    80002f2e:	692080e7          	jalr	1682(ra) # 800005bc <printf>
        p->killed = 1;
    80002f32:	4785                	li	a5,1
    80002f34:	d49c                	sw	a5,40(s1)
        goto end;
    80002f36:	6aa2                	ld	s5,8(sp)
    80002f38:	bd55                	j	80002dec <usertrap+0xa6>
    asm volatile("csrr %0, scause" : "=r"(x));
    80002f3a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002f3e:	5890                	lw	a2,48(s1)
    80002f40:	00005517          	auipc	a0,0x5
    80002f44:	57050513          	addi	a0,a0,1392 # 800084b0 <etext+0x4b0>
    80002f48:	ffffd097          	auipc	ra,0xffffd
    80002f4c:	674080e7          	jalr	1652(ra) # 800005bc <printf>
    asm volatile("csrr %0, sepc" : "=r"(x));
    80002f50:	141025f3          	csrr	a1,sepc
    asm volatile("csrr %0, stval" : "=r"(x));
    80002f54:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002f58:	00005517          	auipc	a0,0x5
    80002f5c:	58850513          	addi	a0,a0,1416 # 800084e0 <etext+0x4e0>
    80002f60:	ffffd097          	auipc	ra,0xffffd
    80002f64:	65c080e7          	jalr	1628(ra) # 800005bc <printf>
    p->killed = 1;
    80002f68:	4785                	li	a5,1
    80002f6a:	d49c                	sw	a5,40(s1)
    80002f6c:	b541                	j	80002dec <usertrap+0xa6>
  if(killed(p))
    80002f6e:	4901                	li	s2,0
    exit(-1);
    80002f70:	557d                	li	a0,-1
    80002f72:	fffff097          	auipc	ra,0xfffff
    80002f76:	694080e7          	jalr	1684(ra) # 80002606 <exit>
  if(which_dev == 2)
    80002f7a:	4789                	li	a5,2
    80002f7c:	e6f91fe3          	bne	s2,a5,80002dfa <usertrap+0xb4>
    yield();
    80002f80:	fffff097          	auipc	ra,0xfffff
    80002f84:	516080e7          	jalr	1302(ra) # 80002496 <yield>
    80002f88:	bd8d                	j	80002dfa <usertrap+0xb4>

0000000080002f8a <kerneltrap>:
{
    80002f8a:	7179                	addi	sp,sp,-48
    80002f8c:	f406                	sd	ra,40(sp)
    80002f8e:	f022                	sd	s0,32(sp)
    80002f90:	ec26                	sd	s1,24(sp)
    80002f92:	e84a                	sd	s2,16(sp)
    80002f94:	e44e                	sd	s3,8(sp)
    80002f96:	1800                	addi	s0,sp,48
    asm volatile("csrr %0, sepc" : "=r"(x));
    80002f98:	14102973          	csrr	s2,sepc
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002f9c:	100024f3          	csrr	s1,sstatus
    asm volatile("csrr %0, scause" : "=r"(x));
    80002fa0:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002fa4:	1004f793          	andi	a5,s1,256
    80002fa8:	cb85                	beqz	a5,80002fd8 <kerneltrap+0x4e>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002faa:	100027f3          	csrr	a5,sstatus
    return (x & SSTATUS_SIE) != 0;
    80002fae:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002fb0:	ef85                	bnez	a5,80002fe8 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002fb2:	00000097          	auipc	ra,0x0
    80002fb6:	cea080e7          	jalr	-790(ra) # 80002c9c <devintr>
    80002fba:	cd1d                	beqz	a0,80002ff8 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002fbc:	4789                	li	a5,2
    80002fbe:	06f50a63          	beq	a0,a5,80003032 <kerneltrap+0xa8>
    asm volatile("csrw sepc, %0" : : "r"(x));
    80002fc2:	14191073          	csrw	sepc,s2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80002fc6:	10049073          	csrw	sstatus,s1
}
    80002fca:	70a2                	ld	ra,40(sp)
    80002fcc:	7402                	ld	s0,32(sp)
    80002fce:	64e2                	ld	s1,24(sp)
    80002fd0:	6942                	ld	s2,16(sp)
    80002fd2:	69a2                	ld	s3,8(sp)
    80002fd4:	6145                	addi	sp,sp,48
    80002fd6:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002fd8:	00005517          	auipc	a0,0x5
    80002fdc:	52850513          	addi	a0,a0,1320 # 80008500 <etext+0x500>
    80002fe0:	ffffd097          	auipc	ra,0xffffd
    80002fe4:	580080e7          	jalr	1408(ra) # 80000560 <panic>
    panic("kerneltrap: interrupts enabled");
    80002fe8:	00005517          	auipc	a0,0x5
    80002fec:	54050513          	addi	a0,a0,1344 # 80008528 <etext+0x528>
    80002ff0:	ffffd097          	auipc	ra,0xffffd
    80002ff4:	570080e7          	jalr	1392(ra) # 80000560 <panic>
    printf("scause %p\n", scause);
    80002ff8:	85ce                	mv	a1,s3
    80002ffa:	00005517          	auipc	a0,0x5
    80002ffe:	54e50513          	addi	a0,a0,1358 # 80008548 <etext+0x548>
    80003002:	ffffd097          	auipc	ra,0xffffd
    80003006:	5ba080e7          	jalr	1466(ra) # 800005bc <printf>
    asm volatile("csrr %0, sepc" : "=r"(x));
    8000300a:	141025f3          	csrr	a1,sepc
    asm volatile("csrr %0, stval" : "=r"(x));
    8000300e:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003012:	00005517          	auipc	a0,0x5
    80003016:	54650513          	addi	a0,a0,1350 # 80008558 <etext+0x558>
    8000301a:	ffffd097          	auipc	ra,0xffffd
    8000301e:	5a2080e7          	jalr	1442(ra) # 800005bc <printf>
    panic("kerneltrap");
    80003022:	00005517          	auipc	a0,0x5
    80003026:	54e50513          	addi	a0,a0,1358 # 80008570 <etext+0x570>
    8000302a:	ffffd097          	auipc	ra,0xffffd
    8000302e:	536080e7          	jalr	1334(ra) # 80000560 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80003032:	fffff097          	auipc	ra,0xfffff
    80003036:	cec080e7          	jalr	-788(ra) # 80001d1e <myproc>
    8000303a:	d541                	beqz	a0,80002fc2 <kerneltrap+0x38>
    8000303c:	fffff097          	auipc	ra,0xfffff
    80003040:	ce2080e7          	jalr	-798(ra) # 80001d1e <myproc>
    80003044:	4d18                	lw	a4,24(a0)
    80003046:	4791                	li	a5,4
    80003048:	f6f71de3          	bne	a4,a5,80002fc2 <kerneltrap+0x38>
    yield();
    8000304c:	fffff097          	auipc	ra,0xfffff
    80003050:	44a080e7          	jalr	1098(ra) # 80002496 <yield>
    80003054:	b7bd                	j	80002fc2 <kerneltrap+0x38>

0000000080003056 <argraw>:
    return strlen(buf);
}

static uint64
argraw(int n)
{
    80003056:	1101                	addi	sp,sp,-32
    80003058:	ec06                	sd	ra,24(sp)
    8000305a:	e822                	sd	s0,16(sp)
    8000305c:	e426                	sd	s1,8(sp)
    8000305e:	1000                	addi	s0,sp,32
    80003060:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    80003062:	fffff097          	auipc	ra,0xfffff
    80003066:	cbc080e7          	jalr	-836(ra) # 80001d1e <myproc>
    switch (n)
    8000306a:	4795                	li	a5,5
    8000306c:	0497e163          	bltu	a5,s1,800030ae <argraw+0x58>
    80003070:	048a                	slli	s1,s1,0x2
    80003072:	00006717          	auipc	a4,0x6
    80003076:	8c670713          	addi	a4,a4,-1850 # 80008938 <states.0+0x30>
    8000307a:	94ba                	add	s1,s1,a4
    8000307c:	409c                	lw	a5,0(s1)
    8000307e:	97ba                	add	a5,a5,a4
    80003080:	8782                	jr	a5
    {
    case 0:
        return p->trapframe->a0;
    80003082:	6d3c                	ld	a5,88(a0)
    80003084:	7ba8                	ld	a0,112(a5)
    case 5:
        return p->trapframe->a5;
    }
    panic("argraw");
    return -1;
}
    80003086:	60e2                	ld	ra,24(sp)
    80003088:	6442                	ld	s0,16(sp)
    8000308a:	64a2                	ld	s1,8(sp)
    8000308c:	6105                	addi	sp,sp,32
    8000308e:	8082                	ret
        return p->trapframe->a1;
    80003090:	6d3c                	ld	a5,88(a0)
    80003092:	7fa8                	ld	a0,120(a5)
    80003094:	bfcd                	j	80003086 <argraw+0x30>
        return p->trapframe->a2;
    80003096:	6d3c                	ld	a5,88(a0)
    80003098:	63c8                	ld	a0,128(a5)
    8000309a:	b7f5                	j	80003086 <argraw+0x30>
        return p->trapframe->a3;
    8000309c:	6d3c                	ld	a5,88(a0)
    8000309e:	67c8                	ld	a0,136(a5)
    800030a0:	b7dd                	j	80003086 <argraw+0x30>
        return p->trapframe->a4;
    800030a2:	6d3c                	ld	a5,88(a0)
    800030a4:	6bc8                	ld	a0,144(a5)
    800030a6:	b7c5                	j	80003086 <argraw+0x30>
        return p->trapframe->a5;
    800030a8:	6d3c                	ld	a5,88(a0)
    800030aa:	6fc8                	ld	a0,152(a5)
    800030ac:	bfe9                	j	80003086 <argraw+0x30>
    panic("argraw");
    800030ae:	00005517          	auipc	a0,0x5
    800030b2:	4d250513          	addi	a0,a0,1234 # 80008580 <etext+0x580>
    800030b6:	ffffd097          	auipc	ra,0xffffd
    800030ba:	4aa080e7          	jalr	1194(ra) # 80000560 <panic>

00000000800030be <fetchaddr>:
{
    800030be:	1101                	addi	sp,sp,-32
    800030c0:	ec06                	sd	ra,24(sp)
    800030c2:	e822                	sd	s0,16(sp)
    800030c4:	e426                	sd	s1,8(sp)
    800030c6:	e04a                	sd	s2,0(sp)
    800030c8:	1000                	addi	s0,sp,32
    800030ca:	84aa                	mv	s1,a0
    800030cc:	892e                	mv	s2,a1
    struct proc *p = myproc();
    800030ce:	fffff097          	auipc	ra,0xfffff
    800030d2:	c50080e7          	jalr	-944(ra) # 80001d1e <myproc>
    if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800030d6:	653c                	ld	a5,72(a0)
    800030d8:	02f4f863          	bgeu	s1,a5,80003108 <fetchaddr+0x4a>
    800030dc:	00848713          	addi	a4,s1,8
    800030e0:	02e7e663          	bltu	a5,a4,8000310c <fetchaddr+0x4e>
    if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800030e4:	46a1                	li	a3,8
    800030e6:	8626                	mv	a2,s1
    800030e8:	85ca                	mv	a1,s2
    800030ea:	6928                	ld	a0,80(a0)
    800030ec:	fffff097          	auipc	ra,0xfffff
    800030f0:	836080e7          	jalr	-1994(ra) # 80001922 <copyin>
    800030f4:	00a03533          	snez	a0,a0
    800030f8:	40a0053b          	negw	a0,a0
}
    800030fc:	60e2                	ld	ra,24(sp)
    800030fe:	6442                	ld	s0,16(sp)
    80003100:	64a2                	ld	s1,8(sp)
    80003102:	6902                	ld	s2,0(sp)
    80003104:	6105                	addi	sp,sp,32
    80003106:	8082                	ret
        return -1;
    80003108:	557d                	li	a0,-1
    8000310a:	bfcd                	j	800030fc <fetchaddr+0x3e>
    8000310c:	557d                	li	a0,-1
    8000310e:	b7fd                	j	800030fc <fetchaddr+0x3e>

0000000080003110 <fetchstr>:
{
    80003110:	7179                	addi	sp,sp,-48
    80003112:	f406                	sd	ra,40(sp)
    80003114:	f022                	sd	s0,32(sp)
    80003116:	ec26                	sd	s1,24(sp)
    80003118:	e84a                	sd	s2,16(sp)
    8000311a:	e44e                	sd	s3,8(sp)
    8000311c:	1800                	addi	s0,sp,48
    8000311e:	892a                	mv	s2,a0
    80003120:	84ae                	mv	s1,a1
    80003122:	89b2                	mv	s3,a2
    struct proc *p = myproc();
    80003124:	fffff097          	auipc	ra,0xfffff
    80003128:	bfa080e7          	jalr	-1030(ra) # 80001d1e <myproc>
    if (copyinstr(p->pagetable, buf, addr, max) < 0)
    8000312c:	86ce                	mv	a3,s3
    8000312e:	864a                	mv	a2,s2
    80003130:	85a6                	mv	a1,s1
    80003132:	6928                	ld	a0,80(a0)
    80003134:	fffff097          	auipc	ra,0xfffff
    80003138:	87c080e7          	jalr	-1924(ra) # 800019b0 <copyinstr>
    8000313c:	00054e63          	bltz	a0,80003158 <fetchstr+0x48>
    return strlen(buf);
    80003140:	8526                	mv	a0,s1
    80003142:	ffffe097          	auipc	ra,0xffffe
    80003146:	f08080e7          	jalr	-248(ra) # 8000104a <strlen>
}
    8000314a:	70a2                	ld	ra,40(sp)
    8000314c:	7402                	ld	s0,32(sp)
    8000314e:	64e2                	ld	s1,24(sp)
    80003150:	6942                	ld	s2,16(sp)
    80003152:	69a2                	ld	s3,8(sp)
    80003154:	6145                	addi	sp,sp,48
    80003156:	8082                	ret
        return -1;
    80003158:	557d                	li	a0,-1
    8000315a:	bfc5                	j	8000314a <fetchstr+0x3a>

000000008000315c <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip)
{
    8000315c:	1101                	addi	sp,sp,-32
    8000315e:	ec06                	sd	ra,24(sp)
    80003160:	e822                	sd	s0,16(sp)
    80003162:	e426                	sd	s1,8(sp)
    80003164:	1000                	addi	s0,sp,32
    80003166:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80003168:	00000097          	auipc	ra,0x0
    8000316c:	eee080e7          	jalr	-274(ra) # 80003056 <argraw>
    80003170:	c088                	sw	a0,0(s1)
}
    80003172:	60e2                	ld	ra,24(sp)
    80003174:	6442                	ld	s0,16(sp)
    80003176:	64a2                	ld	s1,8(sp)
    80003178:	6105                	addi	sp,sp,32
    8000317a:	8082                	ret

000000008000317c <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip)
{
    8000317c:	1101                	addi	sp,sp,-32
    8000317e:	ec06                	sd	ra,24(sp)
    80003180:	e822                	sd	s0,16(sp)
    80003182:	e426                	sd	s1,8(sp)
    80003184:	1000                	addi	s0,sp,32
    80003186:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80003188:	00000097          	auipc	ra,0x0
    8000318c:	ece080e7          	jalr	-306(ra) # 80003056 <argraw>
    80003190:	e088                	sd	a0,0(s1)
}
    80003192:	60e2                	ld	ra,24(sp)
    80003194:	6442                	ld	s0,16(sp)
    80003196:	64a2                	ld	s1,8(sp)
    80003198:	6105                	addi	sp,sp,32
    8000319a:	8082                	ret

000000008000319c <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    8000319c:	1101                	addi	sp,sp,-32
    8000319e:	ec06                	sd	ra,24(sp)
    800031a0:	e822                	sd	s0,16(sp)
    800031a2:	e426                	sd	s1,8(sp)
    800031a4:	e04a                	sd	s2,0(sp)
    800031a6:	1000                	addi	s0,sp,32
    800031a8:	84ae                	mv	s1,a1
    800031aa:	8932                	mv	s2,a2
    *ip = argraw(n);
    800031ac:	00000097          	auipc	ra,0x0
    800031b0:	eaa080e7          	jalr	-342(ra) # 80003056 <argraw>
    uint64 addr;
    argaddr(n, &addr);
    return fetchstr(addr, buf, max);
    800031b4:	864a                	mv	a2,s2
    800031b6:	85a6                	mv	a1,s1
    800031b8:	00000097          	auipc	ra,0x0
    800031bc:	f58080e7          	jalr	-168(ra) # 80003110 <fetchstr>
}
    800031c0:	60e2                	ld	ra,24(sp)
    800031c2:	6442                	ld	s0,16(sp)
    800031c4:	64a2                	ld	s1,8(sp)
    800031c6:	6902                	ld	s2,0(sp)
    800031c8:	6105                	addi	sp,sp,32
    800031ca:	8082                	ret

00000000800031cc <syscall>:
    [SYS_pfreepages] sys_pfreepages,
    [SYS_va2pa] sys_va2pa,
};

void syscall(void)
{
    800031cc:	1101                	addi	sp,sp,-32
    800031ce:	ec06                	sd	ra,24(sp)
    800031d0:	e822                	sd	s0,16(sp)
    800031d2:	e426                	sd	s1,8(sp)
    800031d4:	e04a                	sd	s2,0(sp)
    800031d6:	1000                	addi	s0,sp,32
    int num;
    struct proc *p = myproc();
    800031d8:	fffff097          	auipc	ra,0xfffff
    800031dc:	b46080e7          	jalr	-1210(ra) # 80001d1e <myproc>
    800031e0:	84aa                	mv	s1,a0

    num = p->trapframe->a7;
    800031e2:	05853903          	ld	s2,88(a0)
    800031e6:	0a893783          	ld	a5,168(s2)
    800031ea:	0007869b          	sext.w	a3,a5
    if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    800031ee:	37fd                	addiw	a5,a5,-1 # ffffffffffffefff <end+0xffffffff7fb9d08f>
    800031f0:	4765                	li	a4,25
    800031f2:	00f76f63          	bltu	a4,a5,80003210 <syscall+0x44>
    800031f6:	00369713          	slli	a4,a3,0x3
    800031fa:	00005797          	auipc	a5,0x5
    800031fe:	75678793          	addi	a5,a5,1878 # 80008950 <syscalls>
    80003202:	97ba                	add	a5,a5,a4
    80003204:	639c                	ld	a5,0(a5)
    80003206:	c789                	beqz	a5,80003210 <syscall+0x44>
    {
        // Use num to lookup the system call function for num, call it,
        // and store its return value in p->trapframe->a0
        p->trapframe->a0 = syscalls[num]();
    80003208:	9782                	jalr	a5
    8000320a:	06a93823          	sd	a0,112(s2)
    8000320e:	a839                	j	8000322c <syscall+0x60>
    }
    else
    {
        printf("%d %s: unknown sys call %d\n",
    80003210:	15848613          	addi	a2,s1,344
    80003214:	588c                	lw	a1,48(s1)
    80003216:	00005517          	auipc	a0,0x5
    8000321a:	37250513          	addi	a0,a0,882 # 80008588 <etext+0x588>
    8000321e:	ffffd097          	auipc	ra,0xffffd
    80003222:	39e080e7          	jalr	926(ra) # 800005bc <printf>
               p->pid, p->name, num);
        p->trapframe->a0 = -1;
    80003226:	6cbc                	ld	a5,88(s1)
    80003228:	577d                	li	a4,-1
    8000322a:	fbb8                	sd	a4,112(a5)
    }
}
    8000322c:	60e2                	ld	ra,24(sp)
    8000322e:	6442                	ld	s0,16(sp)
    80003230:	64a2                	ld	s1,8(sp)
    80003232:	6902                	ld	s2,0(sp)
    80003234:	6105                	addi	sp,sp,32
    80003236:	8082                	ret

0000000080003238 <sys_exit>:

extern uint64 FREE_PAGES; // kalloc.c keeps track of those

uint64
sys_exit(void)
{
    80003238:	1101                	addi	sp,sp,-32
    8000323a:	ec06                	sd	ra,24(sp)
    8000323c:	e822                	sd	s0,16(sp)
    8000323e:	1000                	addi	s0,sp,32
    int n;
    argint(0, &n);
    80003240:	fec40593          	addi	a1,s0,-20
    80003244:	4501                	li	a0,0
    80003246:	00000097          	auipc	ra,0x0
    8000324a:	f16080e7          	jalr	-234(ra) # 8000315c <argint>
    exit(n);
    8000324e:	fec42503          	lw	a0,-20(s0)
    80003252:	fffff097          	auipc	ra,0xfffff
    80003256:	3b4080e7          	jalr	948(ra) # 80002606 <exit>
    return 0; // not reached
}
    8000325a:	4501                	li	a0,0
    8000325c:	60e2                	ld	ra,24(sp)
    8000325e:	6442                	ld	s0,16(sp)
    80003260:	6105                	addi	sp,sp,32
    80003262:	8082                	ret

0000000080003264 <sys_getpid>:

uint64
sys_getpid(void)
{
    80003264:	1141                	addi	sp,sp,-16
    80003266:	e406                	sd	ra,8(sp)
    80003268:	e022                	sd	s0,0(sp)
    8000326a:	0800                	addi	s0,sp,16
    return myproc()->pid;
    8000326c:	fffff097          	auipc	ra,0xfffff
    80003270:	ab2080e7          	jalr	-1358(ra) # 80001d1e <myproc>
}
    80003274:	5908                	lw	a0,48(a0)
    80003276:	60a2                	ld	ra,8(sp)
    80003278:	6402                	ld	s0,0(sp)
    8000327a:	0141                	addi	sp,sp,16
    8000327c:	8082                	ret

000000008000327e <sys_fork>:

uint64
sys_fork(void)
{
    8000327e:	1141                	addi	sp,sp,-16
    80003280:	e406                	sd	ra,8(sp)
    80003282:	e022                	sd	s0,0(sp)
    80003284:	0800                	addi	s0,sp,16
    return fork();
    80003286:	fffff097          	auipc	ra,0xfffff
    8000328a:	fe8080e7          	jalr	-24(ra) # 8000226e <fork>
}
    8000328e:	60a2                	ld	ra,8(sp)
    80003290:	6402                	ld	s0,0(sp)
    80003292:	0141                	addi	sp,sp,16
    80003294:	8082                	ret

0000000080003296 <sys_wait>:

uint64
sys_wait(void)
{
    80003296:	1101                	addi	sp,sp,-32
    80003298:	ec06                	sd	ra,24(sp)
    8000329a:	e822                	sd	s0,16(sp)
    8000329c:	1000                	addi	s0,sp,32
    uint64 p;
    argaddr(0, &p);
    8000329e:	fe840593          	addi	a1,s0,-24
    800032a2:	4501                	li	a0,0
    800032a4:	00000097          	auipc	ra,0x0
    800032a8:	ed8080e7          	jalr	-296(ra) # 8000317c <argaddr>
    return wait(p);
    800032ac:	fe843503          	ld	a0,-24(s0)
    800032b0:	fffff097          	auipc	ra,0xfffff
    800032b4:	4fc080e7          	jalr	1276(ra) # 800027ac <wait>
}
    800032b8:	60e2                	ld	ra,24(sp)
    800032ba:	6442                	ld	s0,16(sp)
    800032bc:	6105                	addi	sp,sp,32
    800032be:	8082                	ret

00000000800032c0 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800032c0:	7179                	addi	sp,sp,-48
    800032c2:	f406                	sd	ra,40(sp)
    800032c4:	f022                	sd	s0,32(sp)
    800032c6:	ec26                	sd	s1,24(sp)
    800032c8:	1800                	addi	s0,sp,48
    uint64 addr;
    int n;

    argint(0, &n);
    800032ca:	fdc40593          	addi	a1,s0,-36
    800032ce:	4501                	li	a0,0
    800032d0:	00000097          	auipc	ra,0x0
    800032d4:	e8c080e7          	jalr	-372(ra) # 8000315c <argint>
    addr = myproc()->sz;
    800032d8:	fffff097          	auipc	ra,0xfffff
    800032dc:	a46080e7          	jalr	-1466(ra) # 80001d1e <myproc>
    800032e0:	6524                	ld	s1,72(a0)
    if (growproc(n) < 0)
    800032e2:	fdc42503          	lw	a0,-36(s0)
    800032e6:	fffff097          	auipc	ra,0xfffff
    800032ea:	d92080e7          	jalr	-622(ra) # 80002078 <growproc>
    800032ee:	00054863          	bltz	a0,800032fe <sys_sbrk+0x3e>
        return -1;
    return addr;
}
    800032f2:	8526                	mv	a0,s1
    800032f4:	70a2                	ld	ra,40(sp)
    800032f6:	7402                	ld	s0,32(sp)
    800032f8:	64e2                	ld	s1,24(sp)
    800032fa:	6145                	addi	sp,sp,48
    800032fc:	8082                	ret
        return -1;
    800032fe:	54fd                	li	s1,-1
    80003300:	bfcd                	j	800032f2 <sys_sbrk+0x32>

0000000080003302 <sys_sleep>:

uint64
sys_sleep(void)
{
    80003302:	7139                	addi	sp,sp,-64
    80003304:	fc06                	sd	ra,56(sp)
    80003306:	f822                	sd	s0,48(sp)
    80003308:	f04a                	sd	s2,32(sp)
    8000330a:	0080                	addi	s0,sp,64
    int n;
    uint ticks0;

    argint(0, &n);
    8000330c:	fcc40593          	addi	a1,s0,-52
    80003310:	4501                	li	a0,0
    80003312:	00000097          	auipc	ra,0x0
    80003316:	e4a080e7          	jalr	-438(ra) # 8000315c <argint>
    acquire(&tickslock);
    8000331a:	00454517          	auipc	a0,0x454
    8000331e:	87650513          	addi	a0,a0,-1930 # 80456b90 <tickslock>
    80003322:	ffffe097          	auipc	ra,0xffffe
    80003326:	aa4080e7          	jalr	-1372(ra) # 80000dc6 <acquire>
    ticks0 = ticks;
    8000332a:	00005917          	auipc	s2,0x5
    8000332e:	7c692903          	lw	s2,1990(s2) # 80008af0 <ticks>
    while (ticks - ticks0 < n)
    80003332:	fcc42783          	lw	a5,-52(s0)
    80003336:	c3b9                	beqz	a5,8000337c <sys_sleep+0x7a>
    80003338:	f426                	sd	s1,40(sp)
    8000333a:	ec4e                	sd	s3,24(sp)
        if (killed(myproc()))
        {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
    8000333c:	00454997          	auipc	s3,0x454
    80003340:	85498993          	addi	s3,s3,-1964 # 80456b90 <tickslock>
    80003344:	00005497          	auipc	s1,0x5
    80003348:	7ac48493          	addi	s1,s1,1964 # 80008af0 <ticks>
        if (killed(myproc()))
    8000334c:	fffff097          	auipc	ra,0xfffff
    80003350:	9d2080e7          	jalr	-1582(ra) # 80001d1e <myproc>
    80003354:	fffff097          	auipc	ra,0xfffff
    80003358:	426080e7          	jalr	1062(ra) # 8000277a <killed>
    8000335c:	ed15                	bnez	a0,80003398 <sys_sleep+0x96>
        sleep(&ticks, &tickslock);
    8000335e:	85ce                	mv	a1,s3
    80003360:	8526                	mv	a0,s1
    80003362:	fffff097          	auipc	ra,0xfffff
    80003366:	170080e7          	jalr	368(ra) # 800024d2 <sleep>
    while (ticks - ticks0 < n)
    8000336a:	409c                	lw	a5,0(s1)
    8000336c:	412787bb          	subw	a5,a5,s2
    80003370:	fcc42703          	lw	a4,-52(s0)
    80003374:	fce7ece3          	bltu	a5,a4,8000334c <sys_sleep+0x4a>
    80003378:	74a2                	ld	s1,40(sp)
    8000337a:	69e2                	ld	s3,24(sp)
    }
    release(&tickslock);
    8000337c:	00454517          	auipc	a0,0x454
    80003380:	81450513          	addi	a0,a0,-2028 # 80456b90 <tickslock>
    80003384:	ffffe097          	auipc	ra,0xffffe
    80003388:	af2080e7          	jalr	-1294(ra) # 80000e76 <release>
    return 0;
    8000338c:	4501                	li	a0,0
}
    8000338e:	70e2                	ld	ra,56(sp)
    80003390:	7442                	ld	s0,48(sp)
    80003392:	7902                	ld	s2,32(sp)
    80003394:	6121                	addi	sp,sp,64
    80003396:	8082                	ret
            release(&tickslock);
    80003398:	00453517          	auipc	a0,0x453
    8000339c:	7f850513          	addi	a0,a0,2040 # 80456b90 <tickslock>
    800033a0:	ffffe097          	auipc	ra,0xffffe
    800033a4:	ad6080e7          	jalr	-1322(ra) # 80000e76 <release>
            return -1;
    800033a8:	557d                	li	a0,-1
    800033aa:	74a2                	ld	s1,40(sp)
    800033ac:	69e2                	ld	s3,24(sp)
    800033ae:	b7c5                	j	8000338e <sys_sleep+0x8c>

00000000800033b0 <sys_kill>:

uint64
sys_kill(void)
{
    800033b0:	1101                	addi	sp,sp,-32
    800033b2:	ec06                	sd	ra,24(sp)
    800033b4:	e822                	sd	s0,16(sp)
    800033b6:	1000                	addi	s0,sp,32
    int pid;

    argint(0, &pid);
    800033b8:	fec40593          	addi	a1,s0,-20
    800033bc:	4501                	li	a0,0
    800033be:	00000097          	auipc	ra,0x0
    800033c2:	d9e080e7          	jalr	-610(ra) # 8000315c <argint>
    return kill(pid);
    800033c6:	fec42503          	lw	a0,-20(s0)
    800033ca:	fffff097          	auipc	ra,0xfffff
    800033ce:	312080e7          	jalr	786(ra) # 800026dc <kill>
}
    800033d2:	60e2                	ld	ra,24(sp)
    800033d4:	6442                	ld	s0,16(sp)
    800033d6:	6105                	addi	sp,sp,32
    800033d8:	8082                	ret

00000000800033da <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800033da:	1101                	addi	sp,sp,-32
    800033dc:	ec06                	sd	ra,24(sp)
    800033de:	e822                	sd	s0,16(sp)
    800033e0:	e426                	sd	s1,8(sp)
    800033e2:	1000                	addi	s0,sp,32
    uint xticks;

    acquire(&tickslock);
    800033e4:	00453517          	auipc	a0,0x453
    800033e8:	7ac50513          	addi	a0,a0,1964 # 80456b90 <tickslock>
    800033ec:	ffffe097          	auipc	ra,0xffffe
    800033f0:	9da080e7          	jalr	-1574(ra) # 80000dc6 <acquire>
    xticks = ticks;
    800033f4:	00005497          	auipc	s1,0x5
    800033f8:	6fc4a483          	lw	s1,1788(s1) # 80008af0 <ticks>
    release(&tickslock);
    800033fc:	00453517          	auipc	a0,0x453
    80003400:	79450513          	addi	a0,a0,1940 # 80456b90 <tickslock>
    80003404:	ffffe097          	auipc	ra,0xffffe
    80003408:	a72080e7          	jalr	-1422(ra) # 80000e76 <release>
    return xticks;
}
    8000340c:	02049513          	slli	a0,s1,0x20
    80003410:	9101                	srli	a0,a0,0x20
    80003412:	60e2                	ld	ra,24(sp)
    80003414:	6442                	ld	s0,16(sp)
    80003416:	64a2                	ld	s1,8(sp)
    80003418:	6105                	addi	sp,sp,32
    8000341a:	8082                	ret

000000008000341c <sys_ps>:

void *
sys_ps(void)
{
    8000341c:	1101                	addi	sp,sp,-32
    8000341e:	ec06                	sd	ra,24(sp)
    80003420:	e822                	sd	s0,16(sp)
    80003422:	1000                	addi	s0,sp,32
    int start = 0, count = 0;
    80003424:	fe042623          	sw	zero,-20(s0)
    80003428:	fe042423          	sw	zero,-24(s0)
    argint(0, &start);
    8000342c:	fec40593          	addi	a1,s0,-20
    80003430:	4501                	li	a0,0
    80003432:	00000097          	auipc	ra,0x0
    80003436:	d2a080e7          	jalr	-726(ra) # 8000315c <argint>
    argint(1, &count);
    8000343a:	fe840593          	addi	a1,s0,-24
    8000343e:	4505                	li	a0,1
    80003440:	00000097          	auipc	ra,0x0
    80003444:	d1c080e7          	jalr	-740(ra) # 8000315c <argint>
    return ps((uint8)start, (uint8)count);
    80003448:	fe844583          	lbu	a1,-24(s0)
    8000344c:	fec44503          	lbu	a0,-20(s0)
    80003450:	fffff097          	auipc	ra,0xfffff
    80003454:	c84080e7          	jalr	-892(ra) # 800020d4 <ps>
}
    80003458:	60e2                	ld	ra,24(sp)
    8000345a:	6442                	ld	s0,16(sp)
    8000345c:	6105                	addi	sp,sp,32
    8000345e:	8082                	ret

0000000080003460 <sys_schedls>:

uint64 sys_schedls(void)
{
    80003460:	1141                	addi	sp,sp,-16
    80003462:	e406                	sd	ra,8(sp)
    80003464:	e022                	sd	s0,0(sp)
    80003466:	0800                	addi	s0,sp,16
    schedls();
    80003468:	fffff097          	auipc	ra,0xfffff
    8000346c:	5c8080e7          	jalr	1480(ra) # 80002a30 <schedls>
    return 0;
}
    80003470:	4501                	li	a0,0
    80003472:	60a2                	ld	ra,8(sp)
    80003474:	6402                	ld	s0,0(sp)
    80003476:	0141                	addi	sp,sp,16
    80003478:	8082                	ret

000000008000347a <sys_schedset>:

uint64 sys_schedset(void)
{
    8000347a:	1101                	addi	sp,sp,-32
    8000347c:	ec06                	sd	ra,24(sp)
    8000347e:	e822                	sd	s0,16(sp)
    80003480:	1000                	addi	s0,sp,32
    int id = 0;
    80003482:	fe042623          	sw	zero,-20(s0)
    argint(0, &id);
    80003486:	fec40593          	addi	a1,s0,-20
    8000348a:	4501                	li	a0,0
    8000348c:	00000097          	auipc	ra,0x0
    80003490:	cd0080e7          	jalr	-816(ra) # 8000315c <argint>
    schedset(id - 1);
    80003494:	fec42503          	lw	a0,-20(s0)
    80003498:	357d                	addiw	a0,a0,-1
    8000349a:	fffff097          	auipc	ra,0xfffff
    8000349e:	62c080e7          	jalr	1580(ra) # 80002ac6 <schedset>
    return 0;
}
    800034a2:	4501                	li	a0,0
    800034a4:	60e2                	ld	ra,24(sp)
    800034a6:	6442                	ld	s0,16(sp)
    800034a8:	6105                	addi	sp,sp,32
    800034aa:	8082                	ret

00000000800034ac <sys_va2pa>:

uint64 sys_va2pa(void)
{
    800034ac:	7179                	addi	sp,sp,-48
    800034ae:	f406                	sd	ra,40(sp)
    800034b0:	f022                	sd	s0,32(sp)
    800034b2:	ec26                	sd	s1,24(sp)
    800034b4:	e84a                	sd	s2,16(sp)
    800034b6:	1800                	addi	s0,sp,48
    uint64 va;
    int pid;
    struct proc *p;

    argaddr(0, &va);
    800034b8:	fd840593          	addi	a1,s0,-40
    800034bc:	4501                	li	a0,0
    800034be:	00000097          	auipc	ra,0x0
    800034c2:	cbe080e7          	jalr	-834(ra) # 8000317c <argaddr>
    argint(1, &pid);
    800034c6:	fd440593          	addi	a1,s0,-44
    800034ca:	4505                	li	a0,1
    800034cc:	00000097          	auipc	ra,0x0
    800034d0:	c90080e7          	jalr	-880(ra) # 8000315c <argint>

    if(pid == 0) {
    800034d4:	fd442783          	lw	a5,-44(s0)
        p = myproc();
    } else {
        extern struct proc proc[];
        p = proc;
        for(p = proc; p < &proc[NPROC]; p++) {
    800034d8:	0044e497          	auipc	s1,0x44e
    800034dc:	cb848493          	addi	s1,s1,-840 # 80451190 <proc>
    800034e0:	00453917          	auipc	s2,0x453
    800034e4:	6b090913          	addi	s2,s2,1712 # 80456b90 <tickslock>
    if(pid == 0) {
    800034e8:	c795                	beqz	a5,80003514 <sys_va2pa+0x68>
            acquire(&p->lock);
    800034ea:	8526                	mv	a0,s1
    800034ec:	ffffe097          	auipc	ra,0xffffe
    800034f0:	8da080e7          	jalr	-1830(ra) # 80000dc6 <acquire>
            if(p->pid == pid) {
    800034f4:	5898                	lw	a4,48(s1)
    800034f6:	fd442783          	lw	a5,-44(s0)
    800034fa:	02f70363          	beq	a4,a5,80003520 <sys_va2pa+0x74>
                release(&p->lock);
                break;
            }
            release(&p->lock);
    800034fe:	8526                	mv	a0,s1
    80003500:	ffffe097          	auipc	ra,0xffffe
    80003504:	976080e7          	jalr	-1674(ra) # 80000e76 <release>
        for(p = proc; p < &proc[NPROC]; p++) {
    80003508:	16848493          	addi	s1,s1,360
    8000350c:	fd249fe3          	bne	s1,s2,800034ea <sys_va2pa+0x3e>
        }
        if(p >= &proc[NPROC])
            return 0;
    80003510:	4501                	li	a0,0
    80003512:	a80d                	j	80003544 <sys_va2pa+0x98>
        p = myproc();
    80003514:	fffff097          	auipc	ra,0xfffff
    80003518:	80a080e7          	jalr	-2038(ra) # 80001d1e <myproc>
    8000351c:	84aa                	mv	s1,a0
    8000351e:	a821                	j	80003536 <sys_va2pa+0x8a>
                release(&p->lock);
    80003520:	8526                	mv	a0,s1
    80003522:	ffffe097          	auipc	ra,0xffffe
    80003526:	954080e7          	jalr	-1708(ra) # 80000e76 <release>
        if(p >= &proc[NPROC])
    8000352a:	00453797          	auipc	a5,0x453
    8000352e:	66678793          	addi	a5,a5,1638 # 80456b90 <tickslock>
    80003532:	00f4ff63          	bgeu	s1,a5,80003550 <sys_va2pa+0xa4>
    }

    return va2pa_helper(p->pagetable, va);
    80003536:	fd843583          	ld	a1,-40(s0)
    8000353a:	68a8                	ld	a0,80(s1)
    8000353c:	ffffe097          	auipc	ra,0xffffe
    80003540:	518080e7          	jalr	1304(ra) # 80001a54 <va2pa_helper>
}
    80003544:	70a2                	ld	ra,40(sp)
    80003546:	7402                	ld	s0,32(sp)
    80003548:	64e2                	ld	s1,24(sp)
    8000354a:	6942                	ld	s2,16(sp)
    8000354c:	6145                	addi	sp,sp,48
    8000354e:	8082                	ret
            return 0;
    80003550:	4501                	li	a0,0
    80003552:	bfcd                	j	80003544 <sys_va2pa+0x98>

0000000080003554 <sys_pfreepages>:

uint64 sys_pfreepages(void)
{
    80003554:	1141                	addi	sp,sp,-16
    80003556:	e406                	sd	ra,8(sp)
    80003558:	e022                	sd	s0,0(sp)
    8000355a:	0800                	addi	s0,sp,16
    printf("%d\n", FREE_PAGES);
    8000355c:	00005597          	auipc	a1,0x5
    80003560:	56c5b583          	ld	a1,1388(a1) # 80008ac8 <FREE_PAGES>
    80003564:	00005517          	auipc	a0,0x5
    80003568:	04450513          	addi	a0,a0,68 # 800085a8 <etext+0x5a8>
    8000356c:	ffffd097          	auipc	ra,0xffffd
    80003570:	050080e7          	jalr	80(ra) # 800005bc <printf>
    return 0;
}
    80003574:	4501                	li	a0,0
    80003576:	60a2                	ld	ra,8(sp)
    80003578:	6402                	ld	s0,0(sp)
    8000357a:	0141                	addi	sp,sp,16
    8000357c:	8082                	ret

000000008000357e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000357e:	7179                	addi	sp,sp,-48
    80003580:	f406                	sd	ra,40(sp)
    80003582:	f022                	sd	s0,32(sp)
    80003584:	ec26                	sd	s1,24(sp)
    80003586:	e84a                	sd	s2,16(sp)
    80003588:	e44e                	sd	s3,8(sp)
    8000358a:	e052                	sd	s4,0(sp)
    8000358c:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000358e:	00005597          	auipc	a1,0x5
    80003592:	02258593          	addi	a1,a1,34 # 800085b0 <etext+0x5b0>
    80003596:	00453517          	auipc	a0,0x453
    8000359a:	61250513          	addi	a0,a0,1554 # 80456ba8 <bcache>
    8000359e:	ffffd097          	auipc	ra,0xffffd
    800035a2:	794080e7          	jalr	1940(ra) # 80000d32 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800035a6:	0045b797          	auipc	a5,0x45b
    800035aa:	60278793          	addi	a5,a5,1538 # 8045eba8 <bcache+0x8000>
    800035ae:	0045c717          	auipc	a4,0x45c
    800035b2:	86270713          	addi	a4,a4,-1950 # 8045ee10 <bcache+0x8268>
    800035b6:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800035ba:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800035be:	00453497          	auipc	s1,0x453
    800035c2:	60248493          	addi	s1,s1,1538 # 80456bc0 <bcache+0x18>
    b->next = bcache.head.next;
    800035c6:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800035c8:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800035ca:	00005a17          	auipc	s4,0x5
    800035ce:	feea0a13          	addi	s4,s4,-18 # 800085b8 <etext+0x5b8>
    b->next = bcache.head.next;
    800035d2:	2b893783          	ld	a5,696(s2)
    800035d6:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800035d8:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800035dc:	85d2                	mv	a1,s4
    800035de:	01048513          	addi	a0,s1,16
    800035e2:	00001097          	auipc	ra,0x1
    800035e6:	4e4080e7          	jalr	1252(ra) # 80004ac6 <initsleeplock>
    bcache.head.next->prev = b;
    800035ea:	2b893783          	ld	a5,696(s2)
    800035ee:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800035f0:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800035f4:	45848493          	addi	s1,s1,1112
    800035f8:	fd349de3          	bne	s1,s3,800035d2 <binit+0x54>
  }
}
    800035fc:	70a2                	ld	ra,40(sp)
    800035fe:	7402                	ld	s0,32(sp)
    80003600:	64e2                	ld	s1,24(sp)
    80003602:	6942                	ld	s2,16(sp)
    80003604:	69a2                	ld	s3,8(sp)
    80003606:	6a02                	ld	s4,0(sp)
    80003608:	6145                	addi	sp,sp,48
    8000360a:	8082                	ret

000000008000360c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000360c:	7179                	addi	sp,sp,-48
    8000360e:	f406                	sd	ra,40(sp)
    80003610:	f022                	sd	s0,32(sp)
    80003612:	ec26                	sd	s1,24(sp)
    80003614:	e84a                	sd	s2,16(sp)
    80003616:	e44e                	sd	s3,8(sp)
    80003618:	1800                	addi	s0,sp,48
    8000361a:	892a                	mv	s2,a0
    8000361c:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000361e:	00453517          	auipc	a0,0x453
    80003622:	58a50513          	addi	a0,a0,1418 # 80456ba8 <bcache>
    80003626:	ffffd097          	auipc	ra,0xffffd
    8000362a:	7a0080e7          	jalr	1952(ra) # 80000dc6 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000362e:	0045c497          	auipc	s1,0x45c
    80003632:	8324b483          	ld	s1,-1998(s1) # 8045ee60 <bcache+0x82b8>
    80003636:	0045b797          	auipc	a5,0x45b
    8000363a:	7da78793          	addi	a5,a5,2010 # 8045ee10 <bcache+0x8268>
    8000363e:	02f48f63          	beq	s1,a5,8000367c <bread+0x70>
    80003642:	873e                	mv	a4,a5
    80003644:	a021                	j	8000364c <bread+0x40>
    80003646:	68a4                	ld	s1,80(s1)
    80003648:	02e48a63          	beq	s1,a4,8000367c <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000364c:	449c                	lw	a5,8(s1)
    8000364e:	ff279ce3          	bne	a5,s2,80003646 <bread+0x3a>
    80003652:	44dc                	lw	a5,12(s1)
    80003654:	ff3799e3          	bne	a5,s3,80003646 <bread+0x3a>
      b->refcnt++;
    80003658:	40bc                	lw	a5,64(s1)
    8000365a:	2785                	addiw	a5,a5,1
    8000365c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000365e:	00453517          	auipc	a0,0x453
    80003662:	54a50513          	addi	a0,a0,1354 # 80456ba8 <bcache>
    80003666:	ffffe097          	auipc	ra,0xffffe
    8000366a:	810080e7          	jalr	-2032(ra) # 80000e76 <release>
      acquiresleep(&b->lock);
    8000366e:	01048513          	addi	a0,s1,16
    80003672:	00001097          	auipc	ra,0x1
    80003676:	48e080e7          	jalr	1166(ra) # 80004b00 <acquiresleep>
      return b;
    8000367a:	a8b9                	j	800036d8 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000367c:	0045b497          	auipc	s1,0x45b
    80003680:	7dc4b483          	ld	s1,2012(s1) # 8045ee58 <bcache+0x82b0>
    80003684:	0045b797          	auipc	a5,0x45b
    80003688:	78c78793          	addi	a5,a5,1932 # 8045ee10 <bcache+0x8268>
    8000368c:	00f48863          	beq	s1,a5,8000369c <bread+0x90>
    80003690:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003692:	40bc                	lw	a5,64(s1)
    80003694:	cf81                	beqz	a5,800036ac <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003696:	64a4                	ld	s1,72(s1)
    80003698:	fee49de3          	bne	s1,a4,80003692 <bread+0x86>
  panic("bget: no buffers");
    8000369c:	00005517          	auipc	a0,0x5
    800036a0:	f2450513          	addi	a0,a0,-220 # 800085c0 <etext+0x5c0>
    800036a4:	ffffd097          	auipc	ra,0xffffd
    800036a8:	ebc080e7          	jalr	-324(ra) # 80000560 <panic>
      b->dev = dev;
    800036ac:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800036b0:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800036b4:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800036b8:	4785                	li	a5,1
    800036ba:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800036bc:	00453517          	auipc	a0,0x453
    800036c0:	4ec50513          	addi	a0,a0,1260 # 80456ba8 <bcache>
    800036c4:	ffffd097          	auipc	ra,0xffffd
    800036c8:	7b2080e7          	jalr	1970(ra) # 80000e76 <release>
      acquiresleep(&b->lock);
    800036cc:	01048513          	addi	a0,s1,16
    800036d0:	00001097          	auipc	ra,0x1
    800036d4:	430080e7          	jalr	1072(ra) # 80004b00 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800036d8:	409c                	lw	a5,0(s1)
    800036da:	cb89                	beqz	a5,800036ec <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800036dc:	8526                	mv	a0,s1
    800036de:	70a2                	ld	ra,40(sp)
    800036e0:	7402                	ld	s0,32(sp)
    800036e2:	64e2                	ld	s1,24(sp)
    800036e4:	6942                	ld	s2,16(sp)
    800036e6:	69a2                	ld	s3,8(sp)
    800036e8:	6145                	addi	sp,sp,48
    800036ea:	8082                	ret
    virtio_disk_rw(b, 0);
    800036ec:	4581                	li	a1,0
    800036ee:	8526                	mv	a0,s1
    800036f0:	00003097          	auipc	ra,0x3
    800036f4:	108080e7          	jalr	264(ra) # 800067f8 <virtio_disk_rw>
    b->valid = 1;
    800036f8:	4785                	li	a5,1
    800036fa:	c09c                	sw	a5,0(s1)
  return b;
    800036fc:	b7c5                	j	800036dc <bread+0xd0>

00000000800036fe <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800036fe:	1101                	addi	sp,sp,-32
    80003700:	ec06                	sd	ra,24(sp)
    80003702:	e822                	sd	s0,16(sp)
    80003704:	e426                	sd	s1,8(sp)
    80003706:	1000                	addi	s0,sp,32
    80003708:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000370a:	0541                	addi	a0,a0,16
    8000370c:	00001097          	auipc	ra,0x1
    80003710:	48e080e7          	jalr	1166(ra) # 80004b9a <holdingsleep>
    80003714:	cd01                	beqz	a0,8000372c <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003716:	4585                	li	a1,1
    80003718:	8526                	mv	a0,s1
    8000371a:	00003097          	auipc	ra,0x3
    8000371e:	0de080e7          	jalr	222(ra) # 800067f8 <virtio_disk_rw>
}
    80003722:	60e2                	ld	ra,24(sp)
    80003724:	6442                	ld	s0,16(sp)
    80003726:	64a2                	ld	s1,8(sp)
    80003728:	6105                	addi	sp,sp,32
    8000372a:	8082                	ret
    panic("bwrite");
    8000372c:	00005517          	auipc	a0,0x5
    80003730:	eac50513          	addi	a0,a0,-340 # 800085d8 <etext+0x5d8>
    80003734:	ffffd097          	auipc	ra,0xffffd
    80003738:	e2c080e7          	jalr	-468(ra) # 80000560 <panic>

000000008000373c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000373c:	1101                	addi	sp,sp,-32
    8000373e:	ec06                	sd	ra,24(sp)
    80003740:	e822                	sd	s0,16(sp)
    80003742:	e426                	sd	s1,8(sp)
    80003744:	e04a                	sd	s2,0(sp)
    80003746:	1000                	addi	s0,sp,32
    80003748:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000374a:	01050913          	addi	s2,a0,16
    8000374e:	854a                	mv	a0,s2
    80003750:	00001097          	auipc	ra,0x1
    80003754:	44a080e7          	jalr	1098(ra) # 80004b9a <holdingsleep>
    80003758:	c535                	beqz	a0,800037c4 <brelse+0x88>
    panic("brelse");

  releasesleep(&b->lock);
    8000375a:	854a                	mv	a0,s2
    8000375c:	00001097          	auipc	ra,0x1
    80003760:	3fa080e7          	jalr	1018(ra) # 80004b56 <releasesleep>

  acquire(&bcache.lock);
    80003764:	00453517          	auipc	a0,0x453
    80003768:	44450513          	addi	a0,a0,1092 # 80456ba8 <bcache>
    8000376c:	ffffd097          	auipc	ra,0xffffd
    80003770:	65a080e7          	jalr	1626(ra) # 80000dc6 <acquire>
  b->refcnt--;
    80003774:	40bc                	lw	a5,64(s1)
    80003776:	37fd                	addiw	a5,a5,-1
    80003778:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000377a:	e79d                	bnez	a5,800037a8 <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000377c:	68b8                	ld	a4,80(s1)
    8000377e:	64bc                	ld	a5,72(s1)
    80003780:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003782:	68b8                	ld	a4,80(s1)
    80003784:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003786:	0045b797          	auipc	a5,0x45b
    8000378a:	42278793          	addi	a5,a5,1058 # 8045eba8 <bcache+0x8000>
    8000378e:	2b87b703          	ld	a4,696(a5)
    80003792:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003794:	0045b717          	auipc	a4,0x45b
    80003798:	67c70713          	addi	a4,a4,1660 # 8045ee10 <bcache+0x8268>
    8000379c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000379e:	2b87b703          	ld	a4,696(a5)
    800037a2:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800037a4:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800037a8:	00453517          	auipc	a0,0x453
    800037ac:	40050513          	addi	a0,a0,1024 # 80456ba8 <bcache>
    800037b0:	ffffd097          	auipc	ra,0xffffd
    800037b4:	6c6080e7          	jalr	1734(ra) # 80000e76 <release>
}
    800037b8:	60e2                	ld	ra,24(sp)
    800037ba:	6442                	ld	s0,16(sp)
    800037bc:	64a2                	ld	s1,8(sp)
    800037be:	6902                	ld	s2,0(sp)
    800037c0:	6105                	addi	sp,sp,32
    800037c2:	8082                	ret
    panic("brelse");
    800037c4:	00005517          	auipc	a0,0x5
    800037c8:	e1c50513          	addi	a0,a0,-484 # 800085e0 <etext+0x5e0>
    800037cc:	ffffd097          	auipc	ra,0xffffd
    800037d0:	d94080e7          	jalr	-620(ra) # 80000560 <panic>

00000000800037d4 <bpin>:

void
bpin(struct buf *b) {
    800037d4:	1101                	addi	sp,sp,-32
    800037d6:	ec06                	sd	ra,24(sp)
    800037d8:	e822                	sd	s0,16(sp)
    800037da:	e426                	sd	s1,8(sp)
    800037dc:	1000                	addi	s0,sp,32
    800037de:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800037e0:	00453517          	auipc	a0,0x453
    800037e4:	3c850513          	addi	a0,a0,968 # 80456ba8 <bcache>
    800037e8:	ffffd097          	auipc	ra,0xffffd
    800037ec:	5de080e7          	jalr	1502(ra) # 80000dc6 <acquire>
  b->refcnt++;
    800037f0:	40bc                	lw	a5,64(s1)
    800037f2:	2785                	addiw	a5,a5,1
    800037f4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800037f6:	00453517          	auipc	a0,0x453
    800037fa:	3b250513          	addi	a0,a0,946 # 80456ba8 <bcache>
    800037fe:	ffffd097          	auipc	ra,0xffffd
    80003802:	678080e7          	jalr	1656(ra) # 80000e76 <release>
}
    80003806:	60e2                	ld	ra,24(sp)
    80003808:	6442                	ld	s0,16(sp)
    8000380a:	64a2                	ld	s1,8(sp)
    8000380c:	6105                	addi	sp,sp,32
    8000380e:	8082                	ret

0000000080003810 <bunpin>:

void
bunpin(struct buf *b) {
    80003810:	1101                	addi	sp,sp,-32
    80003812:	ec06                	sd	ra,24(sp)
    80003814:	e822                	sd	s0,16(sp)
    80003816:	e426                	sd	s1,8(sp)
    80003818:	1000                	addi	s0,sp,32
    8000381a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000381c:	00453517          	auipc	a0,0x453
    80003820:	38c50513          	addi	a0,a0,908 # 80456ba8 <bcache>
    80003824:	ffffd097          	auipc	ra,0xffffd
    80003828:	5a2080e7          	jalr	1442(ra) # 80000dc6 <acquire>
  b->refcnt--;
    8000382c:	40bc                	lw	a5,64(s1)
    8000382e:	37fd                	addiw	a5,a5,-1
    80003830:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003832:	00453517          	auipc	a0,0x453
    80003836:	37650513          	addi	a0,a0,886 # 80456ba8 <bcache>
    8000383a:	ffffd097          	auipc	ra,0xffffd
    8000383e:	63c080e7          	jalr	1596(ra) # 80000e76 <release>
}
    80003842:	60e2                	ld	ra,24(sp)
    80003844:	6442                	ld	s0,16(sp)
    80003846:	64a2                	ld	s1,8(sp)
    80003848:	6105                	addi	sp,sp,32
    8000384a:	8082                	ret

000000008000384c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000384c:	1101                	addi	sp,sp,-32
    8000384e:	ec06                	sd	ra,24(sp)
    80003850:	e822                	sd	s0,16(sp)
    80003852:	e426                	sd	s1,8(sp)
    80003854:	e04a                	sd	s2,0(sp)
    80003856:	1000                	addi	s0,sp,32
    80003858:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000385a:	00d5d79b          	srliw	a5,a1,0xd
    8000385e:	0045c597          	auipc	a1,0x45c
    80003862:	a265a583          	lw	a1,-1498(a1) # 8045f284 <sb+0x1c>
    80003866:	9dbd                	addw	a1,a1,a5
    80003868:	00000097          	auipc	ra,0x0
    8000386c:	da4080e7          	jalr	-604(ra) # 8000360c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003870:	0074f713          	andi	a4,s1,7
    80003874:	4785                	li	a5,1
    80003876:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    8000387a:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    8000387c:	90d9                	srli	s1,s1,0x36
    8000387e:	00950733          	add	a4,a0,s1
    80003882:	05874703          	lbu	a4,88(a4)
    80003886:	00e7f6b3          	and	a3,a5,a4
    8000388a:	c69d                	beqz	a3,800038b8 <bfree+0x6c>
    8000388c:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000388e:	94aa                	add	s1,s1,a0
    80003890:	fff7c793          	not	a5,a5
    80003894:	8f7d                	and	a4,a4,a5
    80003896:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000389a:	00001097          	auipc	ra,0x1
    8000389e:	148080e7          	jalr	328(ra) # 800049e2 <log_write>
  brelse(bp);
    800038a2:	854a                	mv	a0,s2
    800038a4:	00000097          	auipc	ra,0x0
    800038a8:	e98080e7          	jalr	-360(ra) # 8000373c <brelse>
}
    800038ac:	60e2                	ld	ra,24(sp)
    800038ae:	6442                	ld	s0,16(sp)
    800038b0:	64a2                	ld	s1,8(sp)
    800038b2:	6902                	ld	s2,0(sp)
    800038b4:	6105                	addi	sp,sp,32
    800038b6:	8082                	ret
    panic("freeing free block");
    800038b8:	00005517          	auipc	a0,0x5
    800038bc:	d3050513          	addi	a0,a0,-720 # 800085e8 <etext+0x5e8>
    800038c0:	ffffd097          	auipc	ra,0xffffd
    800038c4:	ca0080e7          	jalr	-864(ra) # 80000560 <panic>

00000000800038c8 <balloc>:
{
    800038c8:	715d                	addi	sp,sp,-80
    800038ca:	e486                	sd	ra,72(sp)
    800038cc:	e0a2                	sd	s0,64(sp)
    800038ce:	fc26                	sd	s1,56(sp)
    800038d0:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    800038d2:	0045c797          	auipc	a5,0x45c
    800038d6:	99a7a783          	lw	a5,-1638(a5) # 8045f26c <sb+0x4>
    800038da:	10078863          	beqz	a5,800039ea <balloc+0x122>
    800038de:	f84a                	sd	s2,48(sp)
    800038e0:	f44e                	sd	s3,40(sp)
    800038e2:	f052                	sd	s4,32(sp)
    800038e4:	ec56                	sd	s5,24(sp)
    800038e6:	e85a                	sd	s6,16(sp)
    800038e8:	e45e                	sd	s7,8(sp)
    800038ea:	e062                	sd	s8,0(sp)
    800038ec:	8baa                	mv	s7,a0
    800038ee:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800038f0:	0045cb17          	auipc	s6,0x45c
    800038f4:	978b0b13          	addi	s6,s6,-1672 # 8045f268 <sb>
      m = 1 << (bi % 8);
    800038f8:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800038fa:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800038fc:	6c09                	lui	s8,0x2
    800038fe:	a049                	j	80003980 <balloc+0xb8>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003900:	97ca                	add	a5,a5,s2
    80003902:	8e55                	or	a2,a2,a3
    80003904:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003908:	854a                	mv	a0,s2
    8000390a:	00001097          	auipc	ra,0x1
    8000390e:	0d8080e7          	jalr	216(ra) # 800049e2 <log_write>
        brelse(bp);
    80003912:	854a                	mv	a0,s2
    80003914:	00000097          	auipc	ra,0x0
    80003918:	e28080e7          	jalr	-472(ra) # 8000373c <brelse>
  bp = bread(dev, bno);
    8000391c:	85a6                	mv	a1,s1
    8000391e:	855e                	mv	a0,s7
    80003920:	00000097          	auipc	ra,0x0
    80003924:	cec080e7          	jalr	-788(ra) # 8000360c <bread>
    80003928:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000392a:	40000613          	li	a2,1024
    8000392e:	4581                	li	a1,0
    80003930:	05850513          	addi	a0,a0,88
    80003934:	ffffd097          	auipc	ra,0xffffd
    80003938:	58a080e7          	jalr	1418(ra) # 80000ebe <memset>
  log_write(bp);
    8000393c:	854a                	mv	a0,s2
    8000393e:	00001097          	auipc	ra,0x1
    80003942:	0a4080e7          	jalr	164(ra) # 800049e2 <log_write>
  brelse(bp);
    80003946:	854a                	mv	a0,s2
    80003948:	00000097          	auipc	ra,0x0
    8000394c:	df4080e7          	jalr	-524(ra) # 8000373c <brelse>
}
    80003950:	7942                	ld	s2,48(sp)
    80003952:	79a2                	ld	s3,40(sp)
    80003954:	7a02                	ld	s4,32(sp)
    80003956:	6ae2                	ld	s5,24(sp)
    80003958:	6b42                	ld	s6,16(sp)
    8000395a:	6ba2                	ld	s7,8(sp)
    8000395c:	6c02                	ld	s8,0(sp)
}
    8000395e:	8526                	mv	a0,s1
    80003960:	60a6                	ld	ra,72(sp)
    80003962:	6406                	ld	s0,64(sp)
    80003964:	74e2                	ld	s1,56(sp)
    80003966:	6161                	addi	sp,sp,80
    80003968:	8082                	ret
    brelse(bp);
    8000396a:	854a                	mv	a0,s2
    8000396c:	00000097          	auipc	ra,0x0
    80003970:	dd0080e7          	jalr	-560(ra) # 8000373c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003974:	015c0abb          	addw	s5,s8,s5
    80003978:	004b2783          	lw	a5,4(s6)
    8000397c:	06faf063          	bgeu	s5,a5,800039dc <balloc+0x114>
    bp = bread(dev, BBLOCK(b, sb));
    80003980:	41fad79b          	sraiw	a5,s5,0x1f
    80003984:	0137d79b          	srliw	a5,a5,0x13
    80003988:	015787bb          	addw	a5,a5,s5
    8000398c:	40d7d79b          	sraiw	a5,a5,0xd
    80003990:	01cb2583          	lw	a1,28(s6)
    80003994:	9dbd                	addw	a1,a1,a5
    80003996:	855e                	mv	a0,s7
    80003998:	00000097          	auipc	ra,0x0
    8000399c:	c74080e7          	jalr	-908(ra) # 8000360c <bread>
    800039a0:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800039a2:	004b2503          	lw	a0,4(s6)
    800039a6:	84d6                	mv	s1,s5
    800039a8:	4701                	li	a4,0
    800039aa:	fca4f0e3          	bgeu	s1,a0,8000396a <balloc+0xa2>
      m = 1 << (bi % 8);
    800039ae:	00777693          	andi	a3,a4,7
    800039b2:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800039b6:	41f7579b          	sraiw	a5,a4,0x1f
    800039ba:	01d7d79b          	srliw	a5,a5,0x1d
    800039be:	9fb9                	addw	a5,a5,a4
    800039c0:	4037d79b          	sraiw	a5,a5,0x3
    800039c4:	00f90633          	add	a2,s2,a5
    800039c8:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    800039cc:	00c6f5b3          	and	a1,a3,a2
    800039d0:	d985                	beqz	a1,80003900 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800039d2:	2705                	addiw	a4,a4,1
    800039d4:	2485                	addiw	s1,s1,1
    800039d6:	fd471ae3          	bne	a4,s4,800039aa <balloc+0xe2>
    800039da:	bf41                	j	8000396a <balloc+0xa2>
    800039dc:	7942                	ld	s2,48(sp)
    800039de:	79a2                	ld	s3,40(sp)
    800039e0:	7a02                	ld	s4,32(sp)
    800039e2:	6ae2                	ld	s5,24(sp)
    800039e4:	6b42                	ld	s6,16(sp)
    800039e6:	6ba2                	ld	s7,8(sp)
    800039e8:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    800039ea:	00005517          	auipc	a0,0x5
    800039ee:	c1650513          	addi	a0,a0,-1002 # 80008600 <etext+0x600>
    800039f2:	ffffd097          	auipc	ra,0xffffd
    800039f6:	bca080e7          	jalr	-1078(ra) # 800005bc <printf>
  return 0;
    800039fa:	4481                	li	s1,0
    800039fc:	b78d                	j	8000395e <balloc+0x96>

00000000800039fe <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800039fe:	7179                	addi	sp,sp,-48
    80003a00:	f406                	sd	ra,40(sp)
    80003a02:	f022                	sd	s0,32(sp)
    80003a04:	ec26                	sd	s1,24(sp)
    80003a06:	e84a                	sd	s2,16(sp)
    80003a08:	e44e                	sd	s3,8(sp)
    80003a0a:	1800                	addi	s0,sp,48
    80003a0c:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003a0e:	47ad                	li	a5,11
    80003a10:	02b7e563          	bltu	a5,a1,80003a3a <bmap+0x3c>
    if((addr = ip->addrs[bn]) == 0){
    80003a14:	02059793          	slli	a5,a1,0x20
    80003a18:	01e7d593          	srli	a1,a5,0x1e
    80003a1c:	00b504b3          	add	s1,a0,a1
    80003a20:	0504a903          	lw	s2,80(s1)
    80003a24:	06091b63          	bnez	s2,80003a9a <bmap+0x9c>
      addr = balloc(ip->dev);
    80003a28:	4108                	lw	a0,0(a0)
    80003a2a:	00000097          	auipc	ra,0x0
    80003a2e:	e9e080e7          	jalr	-354(ra) # 800038c8 <balloc>
    80003a32:	892a                	mv	s2,a0
      if(addr == 0)
    80003a34:	c13d                	beqz	a0,80003a9a <bmap+0x9c>
        return 0;
      ip->addrs[bn] = addr;
    80003a36:	c8a8                	sw	a0,80(s1)
    80003a38:	a08d                	j	80003a9a <bmap+0x9c>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003a3a:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    80003a3e:	0ff00793          	li	a5,255
    80003a42:	0897e363          	bltu	a5,s1,80003ac8 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003a46:	08052903          	lw	s2,128(a0)
    80003a4a:	00091d63          	bnez	s2,80003a64 <bmap+0x66>
      addr = balloc(ip->dev);
    80003a4e:	4108                	lw	a0,0(a0)
    80003a50:	00000097          	auipc	ra,0x0
    80003a54:	e78080e7          	jalr	-392(ra) # 800038c8 <balloc>
    80003a58:	892a                	mv	s2,a0
      if(addr == 0)
    80003a5a:	c121                	beqz	a0,80003a9a <bmap+0x9c>
    80003a5c:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003a5e:	08a9a023          	sw	a0,128(s3)
    80003a62:	a011                	j	80003a66 <bmap+0x68>
    80003a64:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003a66:	85ca                	mv	a1,s2
    80003a68:	0009a503          	lw	a0,0(s3)
    80003a6c:	00000097          	auipc	ra,0x0
    80003a70:	ba0080e7          	jalr	-1120(ra) # 8000360c <bread>
    80003a74:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003a76:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003a7a:	02049713          	slli	a4,s1,0x20
    80003a7e:	01e75593          	srli	a1,a4,0x1e
    80003a82:	00b784b3          	add	s1,a5,a1
    80003a86:	0004a903          	lw	s2,0(s1)
    80003a8a:	02090063          	beqz	s2,80003aaa <bmap+0xac>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003a8e:	8552                	mv	a0,s4
    80003a90:	00000097          	auipc	ra,0x0
    80003a94:	cac080e7          	jalr	-852(ra) # 8000373c <brelse>
    return addr;
    80003a98:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003a9a:	854a                	mv	a0,s2
    80003a9c:	70a2                	ld	ra,40(sp)
    80003a9e:	7402                	ld	s0,32(sp)
    80003aa0:	64e2                	ld	s1,24(sp)
    80003aa2:	6942                	ld	s2,16(sp)
    80003aa4:	69a2                	ld	s3,8(sp)
    80003aa6:	6145                	addi	sp,sp,48
    80003aa8:	8082                	ret
      addr = balloc(ip->dev);
    80003aaa:	0009a503          	lw	a0,0(s3)
    80003aae:	00000097          	auipc	ra,0x0
    80003ab2:	e1a080e7          	jalr	-486(ra) # 800038c8 <balloc>
    80003ab6:	892a                	mv	s2,a0
      if(addr){
    80003ab8:	d979                	beqz	a0,80003a8e <bmap+0x90>
        a[bn] = addr;
    80003aba:	c088                	sw	a0,0(s1)
        log_write(bp);
    80003abc:	8552                	mv	a0,s4
    80003abe:	00001097          	auipc	ra,0x1
    80003ac2:	f24080e7          	jalr	-220(ra) # 800049e2 <log_write>
    80003ac6:	b7e1                	j	80003a8e <bmap+0x90>
    80003ac8:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003aca:	00005517          	auipc	a0,0x5
    80003ace:	b4e50513          	addi	a0,a0,-1202 # 80008618 <etext+0x618>
    80003ad2:	ffffd097          	auipc	ra,0xffffd
    80003ad6:	a8e080e7          	jalr	-1394(ra) # 80000560 <panic>

0000000080003ada <iget>:
{
    80003ada:	7179                	addi	sp,sp,-48
    80003adc:	f406                	sd	ra,40(sp)
    80003ade:	f022                	sd	s0,32(sp)
    80003ae0:	ec26                	sd	s1,24(sp)
    80003ae2:	e84a                	sd	s2,16(sp)
    80003ae4:	e44e                	sd	s3,8(sp)
    80003ae6:	e052                	sd	s4,0(sp)
    80003ae8:	1800                	addi	s0,sp,48
    80003aea:	89aa                	mv	s3,a0
    80003aec:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003aee:	0045b517          	auipc	a0,0x45b
    80003af2:	79a50513          	addi	a0,a0,1946 # 8045f288 <itable>
    80003af6:	ffffd097          	auipc	ra,0xffffd
    80003afa:	2d0080e7          	jalr	720(ra) # 80000dc6 <acquire>
  empty = 0;
    80003afe:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003b00:	0045b497          	auipc	s1,0x45b
    80003b04:	7a048493          	addi	s1,s1,1952 # 8045f2a0 <itable+0x18>
    80003b08:	0045d697          	auipc	a3,0x45d
    80003b0c:	22868693          	addi	a3,a3,552 # 80460d30 <log>
    80003b10:	a039                	j	80003b1e <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003b12:	02090b63          	beqz	s2,80003b48 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003b16:	08848493          	addi	s1,s1,136
    80003b1a:	02d48a63          	beq	s1,a3,80003b4e <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003b1e:	449c                	lw	a5,8(s1)
    80003b20:	fef059e3          	blez	a5,80003b12 <iget+0x38>
    80003b24:	4098                	lw	a4,0(s1)
    80003b26:	ff3716e3          	bne	a4,s3,80003b12 <iget+0x38>
    80003b2a:	40d8                	lw	a4,4(s1)
    80003b2c:	ff4713e3          	bne	a4,s4,80003b12 <iget+0x38>
      ip->ref++;
    80003b30:	2785                	addiw	a5,a5,1
    80003b32:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003b34:	0045b517          	auipc	a0,0x45b
    80003b38:	75450513          	addi	a0,a0,1876 # 8045f288 <itable>
    80003b3c:	ffffd097          	auipc	ra,0xffffd
    80003b40:	33a080e7          	jalr	826(ra) # 80000e76 <release>
      return ip;
    80003b44:	8926                	mv	s2,s1
    80003b46:	a03d                	j	80003b74 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003b48:	f7f9                	bnez	a5,80003b16 <iget+0x3c>
      empty = ip;
    80003b4a:	8926                	mv	s2,s1
    80003b4c:	b7e9                	j	80003b16 <iget+0x3c>
  if(empty == 0)
    80003b4e:	02090c63          	beqz	s2,80003b86 <iget+0xac>
  ip->dev = dev;
    80003b52:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003b56:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003b5a:	4785                	li	a5,1
    80003b5c:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003b60:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003b64:	0045b517          	auipc	a0,0x45b
    80003b68:	72450513          	addi	a0,a0,1828 # 8045f288 <itable>
    80003b6c:	ffffd097          	auipc	ra,0xffffd
    80003b70:	30a080e7          	jalr	778(ra) # 80000e76 <release>
}
    80003b74:	854a                	mv	a0,s2
    80003b76:	70a2                	ld	ra,40(sp)
    80003b78:	7402                	ld	s0,32(sp)
    80003b7a:	64e2                	ld	s1,24(sp)
    80003b7c:	6942                	ld	s2,16(sp)
    80003b7e:	69a2                	ld	s3,8(sp)
    80003b80:	6a02                	ld	s4,0(sp)
    80003b82:	6145                	addi	sp,sp,48
    80003b84:	8082                	ret
    panic("iget: no inodes");
    80003b86:	00005517          	auipc	a0,0x5
    80003b8a:	aaa50513          	addi	a0,a0,-1366 # 80008630 <etext+0x630>
    80003b8e:	ffffd097          	auipc	ra,0xffffd
    80003b92:	9d2080e7          	jalr	-1582(ra) # 80000560 <panic>

0000000080003b96 <fsinit>:
fsinit(int dev) {
    80003b96:	7179                	addi	sp,sp,-48
    80003b98:	f406                	sd	ra,40(sp)
    80003b9a:	f022                	sd	s0,32(sp)
    80003b9c:	ec26                	sd	s1,24(sp)
    80003b9e:	e84a                	sd	s2,16(sp)
    80003ba0:	e44e                	sd	s3,8(sp)
    80003ba2:	1800                	addi	s0,sp,48
    80003ba4:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003ba6:	4585                	li	a1,1
    80003ba8:	00000097          	auipc	ra,0x0
    80003bac:	a64080e7          	jalr	-1436(ra) # 8000360c <bread>
    80003bb0:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003bb2:	0045b997          	auipc	s3,0x45b
    80003bb6:	6b698993          	addi	s3,s3,1718 # 8045f268 <sb>
    80003bba:	02000613          	li	a2,32
    80003bbe:	05850593          	addi	a1,a0,88
    80003bc2:	854e                	mv	a0,s3
    80003bc4:	ffffd097          	auipc	ra,0xffffd
    80003bc8:	35e080e7          	jalr	862(ra) # 80000f22 <memmove>
  brelse(bp);
    80003bcc:	8526                	mv	a0,s1
    80003bce:	00000097          	auipc	ra,0x0
    80003bd2:	b6e080e7          	jalr	-1170(ra) # 8000373c <brelse>
  if(sb.magic != FSMAGIC)
    80003bd6:	0009a703          	lw	a4,0(s3)
    80003bda:	102037b7          	lui	a5,0x10203
    80003bde:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003be2:	02f71263          	bne	a4,a5,80003c06 <fsinit+0x70>
  initlog(dev, &sb);
    80003be6:	0045b597          	auipc	a1,0x45b
    80003bea:	68258593          	addi	a1,a1,1666 # 8045f268 <sb>
    80003bee:	854a                	mv	a0,s2
    80003bf0:	00001097          	auipc	ra,0x1
    80003bf4:	b7c080e7          	jalr	-1156(ra) # 8000476c <initlog>
}
    80003bf8:	70a2                	ld	ra,40(sp)
    80003bfa:	7402                	ld	s0,32(sp)
    80003bfc:	64e2                	ld	s1,24(sp)
    80003bfe:	6942                	ld	s2,16(sp)
    80003c00:	69a2                	ld	s3,8(sp)
    80003c02:	6145                	addi	sp,sp,48
    80003c04:	8082                	ret
    panic("invalid file system");
    80003c06:	00005517          	auipc	a0,0x5
    80003c0a:	a3a50513          	addi	a0,a0,-1478 # 80008640 <etext+0x640>
    80003c0e:	ffffd097          	auipc	ra,0xffffd
    80003c12:	952080e7          	jalr	-1710(ra) # 80000560 <panic>

0000000080003c16 <iinit>:
{
    80003c16:	7179                	addi	sp,sp,-48
    80003c18:	f406                	sd	ra,40(sp)
    80003c1a:	f022                	sd	s0,32(sp)
    80003c1c:	ec26                	sd	s1,24(sp)
    80003c1e:	e84a                	sd	s2,16(sp)
    80003c20:	e44e                	sd	s3,8(sp)
    80003c22:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003c24:	00005597          	auipc	a1,0x5
    80003c28:	a3458593          	addi	a1,a1,-1484 # 80008658 <etext+0x658>
    80003c2c:	0045b517          	auipc	a0,0x45b
    80003c30:	65c50513          	addi	a0,a0,1628 # 8045f288 <itable>
    80003c34:	ffffd097          	auipc	ra,0xffffd
    80003c38:	0fe080e7          	jalr	254(ra) # 80000d32 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003c3c:	0045b497          	auipc	s1,0x45b
    80003c40:	67448493          	addi	s1,s1,1652 # 8045f2b0 <itable+0x28>
    80003c44:	0045d997          	auipc	s3,0x45d
    80003c48:	0fc98993          	addi	s3,s3,252 # 80460d40 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003c4c:	00005917          	auipc	s2,0x5
    80003c50:	a1490913          	addi	s2,s2,-1516 # 80008660 <etext+0x660>
    80003c54:	85ca                	mv	a1,s2
    80003c56:	8526                	mv	a0,s1
    80003c58:	00001097          	auipc	ra,0x1
    80003c5c:	e6e080e7          	jalr	-402(ra) # 80004ac6 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003c60:	08848493          	addi	s1,s1,136
    80003c64:	ff3498e3          	bne	s1,s3,80003c54 <iinit+0x3e>
}
    80003c68:	70a2                	ld	ra,40(sp)
    80003c6a:	7402                	ld	s0,32(sp)
    80003c6c:	64e2                	ld	s1,24(sp)
    80003c6e:	6942                	ld	s2,16(sp)
    80003c70:	69a2                	ld	s3,8(sp)
    80003c72:	6145                	addi	sp,sp,48
    80003c74:	8082                	ret

0000000080003c76 <ialloc>:
{
    80003c76:	7139                	addi	sp,sp,-64
    80003c78:	fc06                	sd	ra,56(sp)
    80003c7a:	f822                	sd	s0,48(sp)
    80003c7c:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003c7e:	0045b717          	auipc	a4,0x45b
    80003c82:	5f672703          	lw	a4,1526(a4) # 8045f274 <sb+0xc>
    80003c86:	4785                	li	a5,1
    80003c88:	06e7f463          	bgeu	a5,a4,80003cf0 <ialloc+0x7a>
    80003c8c:	f426                	sd	s1,40(sp)
    80003c8e:	f04a                	sd	s2,32(sp)
    80003c90:	ec4e                	sd	s3,24(sp)
    80003c92:	e852                	sd	s4,16(sp)
    80003c94:	e456                	sd	s5,8(sp)
    80003c96:	e05a                	sd	s6,0(sp)
    80003c98:	8aaa                	mv	s5,a0
    80003c9a:	8b2e                	mv	s6,a1
    80003c9c:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80003c9e:	0045ba17          	auipc	s4,0x45b
    80003ca2:	5caa0a13          	addi	s4,s4,1482 # 8045f268 <sb>
    80003ca6:	00495593          	srli	a1,s2,0x4
    80003caa:	018a2783          	lw	a5,24(s4)
    80003cae:	9dbd                	addw	a1,a1,a5
    80003cb0:	8556                	mv	a0,s5
    80003cb2:	00000097          	auipc	ra,0x0
    80003cb6:	95a080e7          	jalr	-1702(ra) # 8000360c <bread>
    80003cba:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003cbc:	05850993          	addi	s3,a0,88
    80003cc0:	00f97793          	andi	a5,s2,15
    80003cc4:	079a                	slli	a5,a5,0x6
    80003cc6:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003cc8:	00099783          	lh	a5,0(s3)
    80003ccc:	cf9d                	beqz	a5,80003d0a <ialloc+0x94>
    brelse(bp);
    80003cce:	00000097          	auipc	ra,0x0
    80003cd2:	a6e080e7          	jalr	-1426(ra) # 8000373c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003cd6:	0905                	addi	s2,s2,1
    80003cd8:	00ca2703          	lw	a4,12(s4)
    80003cdc:	0009079b          	sext.w	a5,s2
    80003ce0:	fce7e3e3          	bltu	a5,a4,80003ca6 <ialloc+0x30>
    80003ce4:	74a2                	ld	s1,40(sp)
    80003ce6:	7902                	ld	s2,32(sp)
    80003ce8:	69e2                	ld	s3,24(sp)
    80003cea:	6a42                	ld	s4,16(sp)
    80003cec:	6aa2                	ld	s5,8(sp)
    80003cee:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003cf0:	00005517          	auipc	a0,0x5
    80003cf4:	97850513          	addi	a0,a0,-1672 # 80008668 <etext+0x668>
    80003cf8:	ffffd097          	auipc	ra,0xffffd
    80003cfc:	8c4080e7          	jalr	-1852(ra) # 800005bc <printf>
  return 0;
    80003d00:	4501                	li	a0,0
}
    80003d02:	70e2                	ld	ra,56(sp)
    80003d04:	7442                	ld	s0,48(sp)
    80003d06:	6121                	addi	sp,sp,64
    80003d08:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003d0a:	04000613          	li	a2,64
    80003d0e:	4581                	li	a1,0
    80003d10:	854e                	mv	a0,s3
    80003d12:	ffffd097          	auipc	ra,0xffffd
    80003d16:	1ac080e7          	jalr	428(ra) # 80000ebe <memset>
      dip->type = type;
    80003d1a:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003d1e:	8526                	mv	a0,s1
    80003d20:	00001097          	auipc	ra,0x1
    80003d24:	cc2080e7          	jalr	-830(ra) # 800049e2 <log_write>
      brelse(bp);
    80003d28:	8526                	mv	a0,s1
    80003d2a:	00000097          	auipc	ra,0x0
    80003d2e:	a12080e7          	jalr	-1518(ra) # 8000373c <brelse>
      return iget(dev, inum);
    80003d32:	0009059b          	sext.w	a1,s2
    80003d36:	8556                	mv	a0,s5
    80003d38:	00000097          	auipc	ra,0x0
    80003d3c:	da2080e7          	jalr	-606(ra) # 80003ada <iget>
    80003d40:	74a2                	ld	s1,40(sp)
    80003d42:	7902                	ld	s2,32(sp)
    80003d44:	69e2                	ld	s3,24(sp)
    80003d46:	6a42                	ld	s4,16(sp)
    80003d48:	6aa2                	ld	s5,8(sp)
    80003d4a:	6b02                	ld	s6,0(sp)
    80003d4c:	bf5d                	j	80003d02 <ialloc+0x8c>

0000000080003d4e <iupdate>:
{
    80003d4e:	1101                	addi	sp,sp,-32
    80003d50:	ec06                	sd	ra,24(sp)
    80003d52:	e822                	sd	s0,16(sp)
    80003d54:	e426                	sd	s1,8(sp)
    80003d56:	e04a                	sd	s2,0(sp)
    80003d58:	1000                	addi	s0,sp,32
    80003d5a:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003d5c:	415c                	lw	a5,4(a0)
    80003d5e:	0047d79b          	srliw	a5,a5,0x4
    80003d62:	0045b597          	auipc	a1,0x45b
    80003d66:	51e5a583          	lw	a1,1310(a1) # 8045f280 <sb+0x18>
    80003d6a:	9dbd                	addw	a1,a1,a5
    80003d6c:	4108                	lw	a0,0(a0)
    80003d6e:	00000097          	auipc	ra,0x0
    80003d72:	89e080e7          	jalr	-1890(ra) # 8000360c <bread>
    80003d76:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003d78:	05850793          	addi	a5,a0,88
    80003d7c:	40d8                	lw	a4,4(s1)
    80003d7e:	8b3d                	andi	a4,a4,15
    80003d80:	071a                	slli	a4,a4,0x6
    80003d82:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003d84:	04449703          	lh	a4,68(s1)
    80003d88:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003d8c:	04649703          	lh	a4,70(s1)
    80003d90:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003d94:	04849703          	lh	a4,72(s1)
    80003d98:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003d9c:	04a49703          	lh	a4,74(s1)
    80003da0:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003da4:	44f8                	lw	a4,76(s1)
    80003da6:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003da8:	03400613          	li	a2,52
    80003dac:	05048593          	addi	a1,s1,80
    80003db0:	00c78513          	addi	a0,a5,12
    80003db4:	ffffd097          	auipc	ra,0xffffd
    80003db8:	16e080e7          	jalr	366(ra) # 80000f22 <memmove>
  log_write(bp);
    80003dbc:	854a                	mv	a0,s2
    80003dbe:	00001097          	auipc	ra,0x1
    80003dc2:	c24080e7          	jalr	-988(ra) # 800049e2 <log_write>
  brelse(bp);
    80003dc6:	854a                	mv	a0,s2
    80003dc8:	00000097          	auipc	ra,0x0
    80003dcc:	974080e7          	jalr	-1676(ra) # 8000373c <brelse>
}
    80003dd0:	60e2                	ld	ra,24(sp)
    80003dd2:	6442                	ld	s0,16(sp)
    80003dd4:	64a2                	ld	s1,8(sp)
    80003dd6:	6902                	ld	s2,0(sp)
    80003dd8:	6105                	addi	sp,sp,32
    80003dda:	8082                	ret

0000000080003ddc <idup>:
{
    80003ddc:	1101                	addi	sp,sp,-32
    80003dde:	ec06                	sd	ra,24(sp)
    80003de0:	e822                	sd	s0,16(sp)
    80003de2:	e426                	sd	s1,8(sp)
    80003de4:	1000                	addi	s0,sp,32
    80003de6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003de8:	0045b517          	auipc	a0,0x45b
    80003dec:	4a050513          	addi	a0,a0,1184 # 8045f288 <itable>
    80003df0:	ffffd097          	auipc	ra,0xffffd
    80003df4:	fd6080e7          	jalr	-42(ra) # 80000dc6 <acquire>
  ip->ref++;
    80003df8:	449c                	lw	a5,8(s1)
    80003dfa:	2785                	addiw	a5,a5,1
    80003dfc:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003dfe:	0045b517          	auipc	a0,0x45b
    80003e02:	48a50513          	addi	a0,a0,1162 # 8045f288 <itable>
    80003e06:	ffffd097          	auipc	ra,0xffffd
    80003e0a:	070080e7          	jalr	112(ra) # 80000e76 <release>
}
    80003e0e:	8526                	mv	a0,s1
    80003e10:	60e2                	ld	ra,24(sp)
    80003e12:	6442                	ld	s0,16(sp)
    80003e14:	64a2                	ld	s1,8(sp)
    80003e16:	6105                	addi	sp,sp,32
    80003e18:	8082                	ret

0000000080003e1a <ilock>:
{
    80003e1a:	1101                	addi	sp,sp,-32
    80003e1c:	ec06                	sd	ra,24(sp)
    80003e1e:	e822                	sd	s0,16(sp)
    80003e20:	e426                	sd	s1,8(sp)
    80003e22:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003e24:	c10d                	beqz	a0,80003e46 <ilock+0x2c>
    80003e26:	84aa                	mv	s1,a0
    80003e28:	451c                	lw	a5,8(a0)
    80003e2a:	00f05e63          	blez	a5,80003e46 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80003e2e:	0541                	addi	a0,a0,16
    80003e30:	00001097          	auipc	ra,0x1
    80003e34:	cd0080e7          	jalr	-816(ra) # 80004b00 <acquiresleep>
  if(ip->valid == 0){
    80003e38:	40bc                	lw	a5,64(s1)
    80003e3a:	cf99                	beqz	a5,80003e58 <ilock+0x3e>
}
    80003e3c:	60e2                	ld	ra,24(sp)
    80003e3e:	6442                	ld	s0,16(sp)
    80003e40:	64a2                	ld	s1,8(sp)
    80003e42:	6105                	addi	sp,sp,32
    80003e44:	8082                	ret
    80003e46:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003e48:	00005517          	auipc	a0,0x5
    80003e4c:	83850513          	addi	a0,a0,-1992 # 80008680 <etext+0x680>
    80003e50:	ffffc097          	auipc	ra,0xffffc
    80003e54:	710080e7          	jalr	1808(ra) # 80000560 <panic>
    80003e58:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003e5a:	40dc                	lw	a5,4(s1)
    80003e5c:	0047d79b          	srliw	a5,a5,0x4
    80003e60:	0045b597          	auipc	a1,0x45b
    80003e64:	4205a583          	lw	a1,1056(a1) # 8045f280 <sb+0x18>
    80003e68:	9dbd                	addw	a1,a1,a5
    80003e6a:	4088                	lw	a0,0(s1)
    80003e6c:	fffff097          	auipc	ra,0xfffff
    80003e70:	7a0080e7          	jalr	1952(ra) # 8000360c <bread>
    80003e74:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003e76:	05850593          	addi	a1,a0,88
    80003e7a:	40dc                	lw	a5,4(s1)
    80003e7c:	8bbd                	andi	a5,a5,15
    80003e7e:	079a                	slli	a5,a5,0x6
    80003e80:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003e82:	00059783          	lh	a5,0(a1)
    80003e86:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003e8a:	00259783          	lh	a5,2(a1)
    80003e8e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003e92:	00459783          	lh	a5,4(a1)
    80003e96:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003e9a:	00659783          	lh	a5,6(a1)
    80003e9e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003ea2:	459c                	lw	a5,8(a1)
    80003ea4:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003ea6:	03400613          	li	a2,52
    80003eaa:	05b1                	addi	a1,a1,12
    80003eac:	05048513          	addi	a0,s1,80
    80003eb0:	ffffd097          	auipc	ra,0xffffd
    80003eb4:	072080e7          	jalr	114(ra) # 80000f22 <memmove>
    brelse(bp);
    80003eb8:	854a                	mv	a0,s2
    80003eba:	00000097          	auipc	ra,0x0
    80003ebe:	882080e7          	jalr	-1918(ra) # 8000373c <brelse>
    ip->valid = 1;
    80003ec2:	4785                	li	a5,1
    80003ec4:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003ec6:	04449783          	lh	a5,68(s1)
    80003eca:	c399                	beqz	a5,80003ed0 <ilock+0xb6>
    80003ecc:	6902                	ld	s2,0(sp)
    80003ece:	b7bd                	j	80003e3c <ilock+0x22>
      panic("ilock: no type");
    80003ed0:	00004517          	auipc	a0,0x4
    80003ed4:	7b850513          	addi	a0,a0,1976 # 80008688 <etext+0x688>
    80003ed8:	ffffc097          	auipc	ra,0xffffc
    80003edc:	688080e7          	jalr	1672(ra) # 80000560 <panic>

0000000080003ee0 <iunlock>:
{
    80003ee0:	1101                	addi	sp,sp,-32
    80003ee2:	ec06                	sd	ra,24(sp)
    80003ee4:	e822                	sd	s0,16(sp)
    80003ee6:	e426                	sd	s1,8(sp)
    80003ee8:	e04a                	sd	s2,0(sp)
    80003eea:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003eec:	c905                	beqz	a0,80003f1c <iunlock+0x3c>
    80003eee:	84aa                	mv	s1,a0
    80003ef0:	01050913          	addi	s2,a0,16
    80003ef4:	854a                	mv	a0,s2
    80003ef6:	00001097          	auipc	ra,0x1
    80003efa:	ca4080e7          	jalr	-860(ra) # 80004b9a <holdingsleep>
    80003efe:	cd19                	beqz	a0,80003f1c <iunlock+0x3c>
    80003f00:	449c                	lw	a5,8(s1)
    80003f02:	00f05d63          	blez	a5,80003f1c <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003f06:	854a                	mv	a0,s2
    80003f08:	00001097          	auipc	ra,0x1
    80003f0c:	c4e080e7          	jalr	-946(ra) # 80004b56 <releasesleep>
}
    80003f10:	60e2                	ld	ra,24(sp)
    80003f12:	6442                	ld	s0,16(sp)
    80003f14:	64a2                	ld	s1,8(sp)
    80003f16:	6902                	ld	s2,0(sp)
    80003f18:	6105                	addi	sp,sp,32
    80003f1a:	8082                	ret
    panic("iunlock");
    80003f1c:	00004517          	auipc	a0,0x4
    80003f20:	77c50513          	addi	a0,a0,1916 # 80008698 <etext+0x698>
    80003f24:	ffffc097          	auipc	ra,0xffffc
    80003f28:	63c080e7          	jalr	1596(ra) # 80000560 <panic>

0000000080003f2c <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003f2c:	7179                	addi	sp,sp,-48
    80003f2e:	f406                	sd	ra,40(sp)
    80003f30:	f022                	sd	s0,32(sp)
    80003f32:	ec26                	sd	s1,24(sp)
    80003f34:	e84a                	sd	s2,16(sp)
    80003f36:	e44e                	sd	s3,8(sp)
    80003f38:	1800                	addi	s0,sp,48
    80003f3a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003f3c:	05050493          	addi	s1,a0,80
    80003f40:	08050913          	addi	s2,a0,128
    80003f44:	a021                	j	80003f4c <itrunc+0x20>
    80003f46:	0491                	addi	s1,s1,4
    80003f48:	01248d63          	beq	s1,s2,80003f62 <itrunc+0x36>
    if(ip->addrs[i]){
    80003f4c:	408c                	lw	a1,0(s1)
    80003f4e:	dde5                	beqz	a1,80003f46 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003f50:	0009a503          	lw	a0,0(s3)
    80003f54:	00000097          	auipc	ra,0x0
    80003f58:	8f8080e7          	jalr	-1800(ra) # 8000384c <bfree>
      ip->addrs[i] = 0;
    80003f5c:	0004a023          	sw	zero,0(s1)
    80003f60:	b7dd                	j	80003f46 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003f62:	0809a583          	lw	a1,128(s3)
    80003f66:	ed99                	bnez	a1,80003f84 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003f68:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003f6c:	854e                	mv	a0,s3
    80003f6e:	00000097          	auipc	ra,0x0
    80003f72:	de0080e7          	jalr	-544(ra) # 80003d4e <iupdate>
}
    80003f76:	70a2                	ld	ra,40(sp)
    80003f78:	7402                	ld	s0,32(sp)
    80003f7a:	64e2                	ld	s1,24(sp)
    80003f7c:	6942                	ld	s2,16(sp)
    80003f7e:	69a2                	ld	s3,8(sp)
    80003f80:	6145                	addi	sp,sp,48
    80003f82:	8082                	ret
    80003f84:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003f86:	0009a503          	lw	a0,0(s3)
    80003f8a:	fffff097          	auipc	ra,0xfffff
    80003f8e:	682080e7          	jalr	1666(ra) # 8000360c <bread>
    80003f92:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003f94:	05850493          	addi	s1,a0,88
    80003f98:	45850913          	addi	s2,a0,1112
    80003f9c:	a021                	j	80003fa4 <itrunc+0x78>
    80003f9e:	0491                	addi	s1,s1,4
    80003fa0:	01248b63          	beq	s1,s2,80003fb6 <itrunc+0x8a>
      if(a[j])
    80003fa4:	408c                	lw	a1,0(s1)
    80003fa6:	dde5                	beqz	a1,80003f9e <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80003fa8:	0009a503          	lw	a0,0(s3)
    80003fac:	00000097          	auipc	ra,0x0
    80003fb0:	8a0080e7          	jalr	-1888(ra) # 8000384c <bfree>
    80003fb4:	b7ed                	j	80003f9e <itrunc+0x72>
    brelse(bp);
    80003fb6:	8552                	mv	a0,s4
    80003fb8:	fffff097          	auipc	ra,0xfffff
    80003fbc:	784080e7          	jalr	1924(ra) # 8000373c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003fc0:	0809a583          	lw	a1,128(s3)
    80003fc4:	0009a503          	lw	a0,0(s3)
    80003fc8:	00000097          	auipc	ra,0x0
    80003fcc:	884080e7          	jalr	-1916(ra) # 8000384c <bfree>
    ip->addrs[NDIRECT] = 0;
    80003fd0:	0809a023          	sw	zero,128(s3)
    80003fd4:	6a02                	ld	s4,0(sp)
    80003fd6:	bf49                	j	80003f68 <itrunc+0x3c>

0000000080003fd8 <iput>:
{
    80003fd8:	1101                	addi	sp,sp,-32
    80003fda:	ec06                	sd	ra,24(sp)
    80003fdc:	e822                	sd	s0,16(sp)
    80003fde:	e426                	sd	s1,8(sp)
    80003fe0:	1000                	addi	s0,sp,32
    80003fe2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003fe4:	0045b517          	auipc	a0,0x45b
    80003fe8:	2a450513          	addi	a0,a0,676 # 8045f288 <itable>
    80003fec:	ffffd097          	auipc	ra,0xffffd
    80003ff0:	dda080e7          	jalr	-550(ra) # 80000dc6 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003ff4:	4498                	lw	a4,8(s1)
    80003ff6:	4785                	li	a5,1
    80003ff8:	02f70263          	beq	a4,a5,8000401c <iput+0x44>
  ip->ref--;
    80003ffc:	449c                	lw	a5,8(s1)
    80003ffe:	37fd                	addiw	a5,a5,-1
    80004000:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80004002:	0045b517          	auipc	a0,0x45b
    80004006:	28650513          	addi	a0,a0,646 # 8045f288 <itable>
    8000400a:	ffffd097          	auipc	ra,0xffffd
    8000400e:	e6c080e7          	jalr	-404(ra) # 80000e76 <release>
}
    80004012:	60e2                	ld	ra,24(sp)
    80004014:	6442                	ld	s0,16(sp)
    80004016:	64a2                	ld	s1,8(sp)
    80004018:	6105                	addi	sp,sp,32
    8000401a:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000401c:	40bc                	lw	a5,64(s1)
    8000401e:	dff9                	beqz	a5,80003ffc <iput+0x24>
    80004020:	04a49783          	lh	a5,74(s1)
    80004024:	ffe1                	bnez	a5,80003ffc <iput+0x24>
    80004026:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80004028:	01048913          	addi	s2,s1,16
    8000402c:	854a                	mv	a0,s2
    8000402e:	00001097          	auipc	ra,0x1
    80004032:	ad2080e7          	jalr	-1326(ra) # 80004b00 <acquiresleep>
    release(&itable.lock);
    80004036:	0045b517          	auipc	a0,0x45b
    8000403a:	25250513          	addi	a0,a0,594 # 8045f288 <itable>
    8000403e:	ffffd097          	auipc	ra,0xffffd
    80004042:	e38080e7          	jalr	-456(ra) # 80000e76 <release>
    itrunc(ip);
    80004046:	8526                	mv	a0,s1
    80004048:	00000097          	auipc	ra,0x0
    8000404c:	ee4080e7          	jalr	-284(ra) # 80003f2c <itrunc>
    ip->type = 0;
    80004050:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80004054:	8526                	mv	a0,s1
    80004056:	00000097          	auipc	ra,0x0
    8000405a:	cf8080e7          	jalr	-776(ra) # 80003d4e <iupdate>
    ip->valid = 0;
    8000405e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80004062:	854a                	mv	a0,s2
    80004064:	00001097          	auipc	ra,0x1
    80004068:	af2080e7          	jalr	-1294(ra) # 80004b56 <releasesleep>
    acquire(&itable.lock);
    8000406c:	0045b517          	auipc	a0,0x45b
    80004070:	21c50513          	addi	a0,a0,540 # 8045f288 <itable>
    80004074:	ffffd097          	auipc	ra,0xffffd
    80004078:	d52080e7          	jalr	-686(ra) # 80000dc6 <acquire>
    8000407c:	6902                	ld	s2,0(sp)
    8000407e:	bfbd                	j	80003ffc <iput+0x24>

0000000080004080 <iunlockput>:
{
    80004080:	1101                	addi	sp,sp,-32
    80004082:	ec06                	sd	ra,24(sp)
    80004084:	e822                	sd	s0,16(sp)
    80004086:	e426                	sd	s1,8(sp)
    80004088:	1000                	addi	s0,sp,32
    8000408a:	84aa                	mv	s1,a0
  iunlock(ip);
    8000408c:	00000097          	auipc	ra,0x0
    80004090:	e54080e7          	jalr	-428(ra) # 80003ee0 <iunlock>
  iput(ip);
    80004094:	8526                	mv	a0,s1
    80004096:	00000097          	auipc	ra,0x0
    8000409a:	f42080e7          	jalr	-190(ra) # 80003fd8 <iput>
}
    8000409e:	60e2                	ld	ra,24(sp)
    800040a0:	6442                	ld	s0,16(sp)
    800040a2:	64a2                	ld	s1,8(sp)
    800040a4:	6105                	addi	sp,sp,32
    800040a6:	8082                	ret

00000000800040a8 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800040a8:	1141                	addi	sp,sp,-16
    800040aa:	e406                	sd	ra,8(sp)
    800040ac:	e022                	sd	s0,0(sp)
    800040ae:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800040b0:	411c                	lw	a5,0(a0)
    800040b2:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800040b4:	415c                	lw	a5,4(a0)
    800040b6:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800040b8:	04451783          	lh	a5,68(a0)
    800040bc:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800040c0:	04a51783          	lh	a5,74(a0)
    800040c4:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800040c8:	04c56783          	lwu	a5,76(a0)
    800040cc:	e99c                	sd	a5,16(a1)
}
    800040ce:	60a2                	ld	ra,8(sp)
    800040d0:	6402                	ld	s0,0(sp)
    800040d2:	0141                	addi	sp,sp,16
    800040d4:	8082                	ret

00000000800040d6 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800040d6:	457c                	lw	a5,76(a0)
    800040d8:	10d7e063          	bltu	a5,a3,800041d8 <readi+0x102>
{
    800040dc:	7159                	addi	sp,sp,-112
    800040de:	f486                	sd	ra,104(sp)
    800040e0:	f0a2                	sd	s0,96(sp)
    800040e2:	eca6                	sd	s1,88(sp)
    800040e4:	e0d2                	sd	s4,64(sp)
    800040e6:	fc56                	sd	s5,56(sp)
    800040e8:	f85a                	sd	s6,48(sp)
    800040ea:	f45e                	sd	s7,40(sp)
    800040ec:	1880                	addi	s0,sp,112
    800040ee:	8b2a                	mv	s6,a0
    800040f0:	8bae                	mv	s7,a1
    800040f2:	8a32                	mv	s4,a2
    800040f4:	84b6                	mv	s1,a3
    800040f6:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800040f8:	9f35                	addw	a4,a4,a3
    return 0;
    800040fa:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800040fc:	0cd76563          	bltu	a4,a3,800041c6 <readi+0xf0>
    80004100:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80004102:	00e7f463          	bgeu	a5,a4,8000410a <readi+0x34>
    n = ip->size - off;
    80004106:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000410a:	0a0a8563          	beqz	s5,800041b4 <readi+0xde>
    8000410e:	e8ca                	sd	s2,80(sp)
    80004110:	f062                	sd	s8,32(sp)
    80004112:	ec66                	sd	s9,24(sp)
    80004114:	e86a                	sd	s10,16(sp)
    80004116:	e46e                	sd	s11,8(sp)
    80004118:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000411a:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000411e:	5c7d                	li	s8,-1
    80004120:	a82d                	j	8000415a <readi+0x84>
    80004122:	020d1d93          	slli	s11,s10,0x20
    80004126:	020ddd93          	srli	s11,s11,0x20
    8000412a:	05890613          	addi	a2,s2,88
    8000412e:	86ee                	mv	a3,s11
    80004130:	963e                	add	a2,a2,a5
    80004132:	85d2                	mv	a1,s4
    80004134:	855e                	mv	a0,s7
    80004136:	ffffe097          	auipc	ra,0xffffe
    8000413a:	79e080e7          	jalr	1950(ra) # 800028d4 <either_copyout>
    8000413e:	05850963          	beq	a0,s8,80004190 <readi+0xba>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80004142:	854a                	mv	a0,s2
    80004144:	fffff097          	auipc	ra,0xfffff
    80004148:	5f8080e7          	jalr	1528(ra) # 8000373c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000414c:	013d09bb          	addw	s3,s10,s3
    80004150:	009d04bb          	addw	s1,s10,s1
    80004154:	9a6e                	add	s4,s4,s11
    80004156:	0559f963          	bgeu	s3,s5,800041a8 <readi+0xd2>
    uint addr = bmap(ip, off/BSIZE);
    8000415a:	00a4d59b          	srliw	a1,s1,0xa
    8000415e:	855a                	mv	a0,s6
    80004160:	00000097          	auipc	ra,0x0
    80004164:	89e080e7          	jalr	-1890(ra) # 800039fe <bmap>
    80004168:	85aa                	mv	a1,a0
    if(addr == 0)
    8000416a:	c539                	beqz	a0,800041b8 <readi+0xe2>
    bp = bread(ip->dev, addr);
    8000416c:	000b2503          	lw	a0,0(s6)
    80004170:	fffff097          	auipc	ra,0xfffff
    80004174:	49c080e7          	jalr	1180(ra) # 8000360c <bread>
    80004178:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000417a:	3ff4f793          	andi	a5,s1,1023
    8000417e:	40fc873b          	subw	a4,s9,a5
    80004182:	413a86bb          	subw	a3,s5,s3
    80004186:	8d3a                	mv	s10,a4
    80004188:	f8e6fde3          	bgeu	a3,a4,80004122 <readi+0x4c>
    8000418c:	8d36                	mv	s10,a3
    8000418e:	bf51                	j	80004122 <readi+0x4c>
      brelse(bp);
    80004190:	854a                	mv	a0,s2
    80004192:	fffff097          	auipc	ra,0xfffff
    80004196:	5aa080e7          	jalr	1450(ra) # 8000373c <brelse>
      tot = -1;
    8000419a:	59fd                	li	s3,-1
      break;
    8000419c:	6946                	ld	s2,80(sp)
    8000419e:	7c02                	ld	s8,32(sp)
    800041a0:	6ce2                	ld	s9,24(sp)
    800041a2:	6d42                	ld	s10,16(sp)
    800041a4:	6da2                	ld	s11,8(sp)
    800041a6:	a831                	j	800041c2 <readi+0xec>
    800041a8:	6946                	ld	s2,80(sp)
    800041aa:	7c02                	ld	s8,32(sp)
    800041ac:	6ce2                	ld	s9,24(sp)
    800041ae:	6d42                	ld	s10,16(sp)
    800041b0:	6da2                	ld	s11,8(sp)
    800041b2:	a801                	j	800041c2 <readi+0xec>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800041b4:	89d6                	mv	s3,s5
    800041b6:	a031                	j	800041c2 <readi+0xec>
    800041b8:	6946                	ld	s2,80(sp)
    800041ba:	7c02                	ld	s8,32(sp)
    800041bc:	6ce2                	ld	s9,24(sp)
    800041be:	6d42                	ld	s10,16(sp)
    800041c0:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800041c2:	854e                	mv	a0,s3
    800041c4:	69a6                	ld	s3,72(sp)
}
    800041c6:	70a6                	ld	ra,104(sp)
    800041c8:	7406                	ld	s0,96(sp)
    800041ca:	64e6                	ld	s1,88(sp)
    800041cc:	6a06                	ld	s4,64(sp)
    800041ce:	7ae2                	ld	s5,56(sp)
    800041d0:	7b42                	ld	s6,48(sp)
    800041d2:	7ba2                	ld	s7,40(sp)
    800041d4:	6165                	addi	sp,sp,112
    800041d6:	8082                	ret
    return 0;
    800041d8:	4501                	li	a0,0
}
    800041da:	8082                	ret

00000000800041dc <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800041dc:	457c                	lw	a5,76(a0)
    800041de:	10d7e963          	bltu	a5,a3,800042f0 <writei+0x114>
{
    800041e2:	7159                	addi	sp,sp,-112
    800041e4:	f486                	sd	ra,104(sp)
    800041e6:	f0a2                	sd	s0,96(sp)
    800041e8:	e8ca                	sd	s2,80(sp)
    800041ea:	e0d2                	sd	s4,64(sp)
    800041ec:	fc56                	sd	s5,56(sp)
    800041ee:	f85a                	sd	s6,48(sp)
    800041f0:	f45e                	sd	s7,40(sp)
    800041f2:	1880                	addi	s0,sp,112
    800041f4:	8aaa                	mv	s5,a0
    800041f6:	8bae                	mv	s7,a1
    800041f8:	8a32                	mv	s4,a2
    800041fa:	8936                	mv	s2,a3
    800041fc:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800041fe:	00e687bb          	addw	a5,a3,a4
    80004202:	0ed7e963          	bltu	a5,a3,800042f4 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80004206:	00043737          	lui	a4,0x43
    8000420a:	0ef76763          	bltu	a4,a5,800042f8 <writei+0x11c>
    8000420e:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004210:	0c0b0863          	beqz	s6,800042e0 <writei+0x104>
    80004214:	eca6                	sd	s1,88(sp)
    80004216:	f062                	sd	s8,32(sp)
    80004218:	ec66                	sd	s9,24(sp)
    8000421a:	e86a                	sd	s10,16(sp)
    8000421c:	e46e                	sd	s11,8(sp)
    8000421e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80004220:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80004224:	5c7d                	li	s8,-1
    80004226:	a091                	j	8000426a <writei+0x8e>
    80004228:	020d1d93          	slli	s11,s10,0x20
    8000422c:	020ddd93          	srli	s11,s11,0x20
    80004230:	05848513          	addi	a0,s1,88
    80004234:	86ee                	mv	a3,s11
    80004236:	8652                	mv	a2,s4
    80004238:	85de                	mv	a1,s7
    8000423a:	953e                	add	a0,a0,a5
    8000423c:	ffffe097          	auipc	ra,0xffffe
    80004240:	6ee080e7          	jalr	1774(ra) # 8000292a <either_copyin>
    80004244:	05850e63          	beq	a0,s8,800042a0 <writei+0xc4>
      brelse(bp);
      break;
    }
    log_write(bp);
    80004248:	8526                	mv	a0,s1
    8000424a:	00000097          	auipc	ra,0x0
    8000424e:	798080e7          	jalr	1944(ra) # 800049e2 <log_write>
    brelse(bp);
    80004252:	8526                	mv	a0,s1
    80004254:	fffff097          	auipc	ra,0xfffff
    80004258:	4e8080e7          	jalr	1256(ra) # 8000373c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000425c:	013d09bb          	addw	s3,s10,s3
    80004260:	012d093b          	addw	s2,s10,s2
    80004264:	9a6e                	add	s4,s4,s11
    80004266:	0569f263          	bgeu	s3,s6,800042aa <writei+0xce>
    uint addr = bmap(ip, off/BSIZE);
    8000426a:	00a9559b          	srliw	a1,s2,0xa
    8000426e:	8556                	mv	a0,s5
    80004270:	fffff097          	auipc	ra,0xfffff
    80004274:	78e080e7          	jalr	1934(ra) # 800039fe <bmap>
    80004278:	85aa                	mv	a1,a0
    if(addr == 0)
    8000427a:	c905                	beqz	a0,800042aa <writei+0xce>
    bp = bread(ip->dev, addr);
    8000427c:	000aa503          	lw	a0,0(s5)
    80004280:	fffff097          	auipc	ra,0xfffff
    80004284:	38c080e7          	jalr	908(ra) # 8000360c <bread>
    80004288:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000428a:	3ff97793          	andi	a5,s2,1023
    8000428e:	40fc873b          	subw	a4,s9,a5
    80004292:	413b06bb          	subw	a3,s6,s3
    80004296:	8d3a                	mv	s10,a4
    80004298:	f8e6f8e3          	bgeu	a3,a4,80004228 <writei+0x4c>
    8000429c:	8d36                	mv	s10,a3
    8000429e:	b769                	j	80004228 <writei+0x4c>
      brelse(bp);
    800042a0:	8526                	mv	a0,s1
    800042a2:	fffff097          	auipc	ra,0xfffff
    800042a6:	49a080e7          	jalr	1178(ra) # 8000373c <brelse>
  }

  if(off > ip->size)
    800042aa:	04caa783          	lw	a5,76(s5)
    800042ae:	0327fb63          	bgeu	a5,s2,800042e4 <writei+0x108>
    ip->size = off;
    800042b2:	052aa623          	sw	s2,76(s5)
    800042b6:	64e6                	ld	s1,88(sp)
    800042b8:	7c02                	ld	s8,32(sp)
    800042ba:	6ce2                	ld	s9,24(sp)
    800042bc:	6d42                	ld	s10,16(sp)
    800042be:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800042c0:	8556                	mv	a0,s5
    800042c2:	00000097          	auipc	ra,0x0
    800042c6:	a8c080e7          	jalr	-1396(ra) # 80003d4e <iupdate>

  return tot;
    800042ca:	854e                	mv	a0,s3
    800042cc:	69a6                	ld	s3,72(sp)
}
    800042ce:	70a6                	ld	ra,104(sp)
    800042d0:	7406                	ld	s0,96(sp)
    800042d2:	6946                	ld	s2,80(sp)
    800042d4:	6a06                	ld	s4,64(sp)
    800042d6:	7ae2                	ld	s5,56(sp)
    800042d8:	7b42                	ld	s6,48(sp)
    800042da:	7ba2                	ld	s7,40(sp)
    800042dc:	6165                	addi	sp,sp,112
    800042de:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800042e0:	89da                	mv	s3,s6
    800042e2:	bff9                	j	800042c0 <writei+0xe4>
    800042e4:	64e6                	ld	s1,88(sp)
    800042e6:	7c02                	ld	s8,32(sp)
    800042e8:	6ce2                	ld	s9,24(sp)
    800042ea:	6d42                	ld	s10,16(sp)
    800042ec:	6da2                	ld	s11,8(sp)
    800042ee:	bfc9                	j	800042c0 <writei+0xe4>
    return -1;
    800042f0:	557d                	li	a0,-1
}
    800042f2:	8082                	ret
    return -1;
    800042f4:	557d                	li	a0,-1
    800042f6:	bfe1                	j	800042ce <writei+0xf2>
    return -1;
    800042f8:	557d                	li	a0,-1
    800042fa:	bfd1                	j	800042ce <writei+0xf2>

00000000800042fc <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800042fc:	1141                	addi	sp,sp,-16
    800042fe:	e406                	sd	ra,8(sp)
    80004300:	e022                	sd	s0,0(sp)
    80004302:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80004304:	4639                	li	a2,14
    80004306:	ffffd097          	auipc	ra,0xffffd
    8000430a:	c94080e7          	jalr	-876(ra) # 80000f9a <strncmp>
}
    8000430e:	60a2                	ld	ra,8(sp)
    80004310:	6402                	ld	s0,0(sp)
    80004312:	0141                	addi	sp,sp,16
    80004314:	8082                	ret

0000000080004316 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80004316:	711d                	addi	sp,sp,-96
    80004318:	ec86                	sd	ra,88(sp)
    8000431a:	e8a2                	sd	s0,80(sp)
    8000431c:	e4a6                	sd	s1,72(sp)
    8000431e:	e0ca                	sd	s2,64(sp)
    80004320:	fc4e                	sd	s3,56(sp)
    80004322:	f852                	sd	s4,48(sp)
    80004324:	f456                	sd	s5,40(sp)
    80004326:	f05a                	sd	s6,32(sp)
    80004328:	ec5e                	sd	s7,24(sp)
    8000432a:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000432c:	04451703          	lh	a4,68(a0)
    80004330:	4785                	li	a5,1
    80004332:	00f71f63          	bne	a4,a5,80004350 <dirlookup+0x3a>
    80004336:	892a                	mv	s2,a0
    80004338:	8aae                	mv	s5,a1
    8000433a:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000433c:	457c                	lw	a5,76(a0)
    8000433e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004340:	fa040a13          	addi	s4,s0,-96
    80004344:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80004346:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000434a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000434c:	e79d                	bnez	a5,8000437a <dirlookup+0x64>
    8000434e:	a88d                	j	800043c0 <dirlookup+0xaa>
    panic("dirlookup not DIR");
    80004350:	00004517          	auipc	a0,0x4
    80004354:	35050513          	addi	a0,a0,848 # 800086a0 <etext+0x6a0>
    80004358:	ffffc097          	auipc	ra,0xffffc
    8000435c:	208080e7          	jalr	520(ra) # 80000560 <panic>
      panic("dirlookup read");
    80004360:	00004517          	auipc	a0,0x4
    80004364:	35850513          	addi	a0,a0,856 # 800086b8 <etext+0x6b8>
    80004368:	ffffc097          	auipc	ra,0xffffc
    8000436c:	1f8080e7          	jalr	504(ra) # 80000560 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004370:	24c1                	addiw	s1,s1,16
    80004372:	04c92783          	lw	a5,76(s2)
    80004376:	04f4f463          	bgeu	s1,a5,800043be <dirlookup+0xa8>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000437a:	874e                	mv	a4,s3
    8000437c:	86a6                	mv	a3,s1
    8000437e:	8652                	mv	a2,s4
    80004380:	4581                	li	a1,0
    80004382:	854a                	mv	a0,s2
    80004384:	00000097          	auipc	ra,0x0
    80004388:	d52080e7          	jalr	-686(ra) # 800040d6 <readi>
    8000438c:	fd351ae3          	bne	a0,s3,80004360 <dirlookup+0x4a>
    if(de.inum == 0)
    80004390:	fa045783          	lhu	a5,-96(s0)
    80004394:	dff1                	beqz	a5,80004370 <dirlookup+0x5a>
    if(namecmp(name, de.name) == 0){
    80004396:	85da                	mv	a1,s6
    80004398:	8556                	mv	a0,s5
    8000439a:	00000097          	auipc	ra,0x0
    8000439e:	f62080e7          	jalr	-158(ra) # 800042fc <namecmp>
    800043a2:	f579                	bnez	a0,80004370 <dirlookup+0x5a>
      if(poff)
    800043a4:	000b8463          	beqz	s7,800043ac <dirlookup+0x96>
        *poff = off;
    800043a8:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    800043ac:	fa045583          	lhu	a1,-96(s0)
    800043b0:	00092503          	lw	a0,0(s2)
    800043b4:	fffff097          	auipc	ra,0xfffff
    800043b8:	726080e7          	jalr	1830(ra) # 80003ada <iget>
    800043bc:	a011                	j	800043c0 <dirlookup+0xaa>
  return 0;
    800043be:	4501                	li	a0,0
}
    800043c0:	60e6                	ld	ra,88(sp)
    800043c2:	6446                	ld	s0,80(sp)
    800043c4:	64a6                	ld	s1,72(sp)
    800043c6:	6906                	ld	s2,64(sp)
    800043c8:	79e2                	ld	s3,56(sp)
    800043ca:	7a42                	ld	s4,48(sp)
    800043cc:	7aa2                	ld	s5,40(sp)
    800043ce:	7b02                	ld	s6,32(sp)
    800043d0:	6be2                	ld	s7,24(sp)
    800043d2:	6125                	addi	sp,sp,96
    800043d4:	8082                	ret

00000000800043d6 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800043d6:	711d                	addi	sp,sp,-96
    800043d8:	ec86                	sd	ra,88(sp)
    800043da:	e8a2                	sd	s0,80(sp)
    800043dc:	e4a6                	sd	s1,72(sp)
    800043de:	e0ca                	sd	s2,64(sp)
    800043e0:	fc4e                	sd	s3,56(sp)
    800043e2:	f852                	sd	s4,48(sp)
    800043e4:	f456                	sd	s5,40(sp)
    800043e6:	f05a                	sd	s6,32(sp)
    800043e8:	ec5e                	sd	s7,24(sp)
    800043ea:	e862                	sd	s8,16(sp)
    800043ec:	e466                	sd	s9,8(sp)
    800043ee:	e06a                	sd	s10,0(sp)
    800043f0:	1080                	addi	s0,sp,96
    800043f2:	84aa                	mv	s1,a0
    800043f4:	8b2e                	mv	s6,a1
    800043f6:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800043f8:	00054703          	lbu	a4,0(a0)
    800043fc:	02f00793          	li	a5,47
    80004400:	02f70363          	beq	a4,a5,80004426 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80004404:	ffffe097          	auipc	ra,0xffffe
    80004408:	91a080e7          	jalr	-1766(ra) # 80001d1e <myproc>
    8000440c:	15053503          	ld	a0,336(a0)
    80004410:	00000097          	auipc	ra,0x0
    80004414:	9cc080e7          	jalr	-1588(ra) # 80003ddc <idup>
    80004418:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000441a:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000441e:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80004420:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004422:	4b85                	li	s7,1
    80004424:	a87d                	j	800044e2 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80004426:	4585                	li	a1,1
    80004428:	852e                	mv	a0,a1
    8000442a:	fffff097          	auipc	ra,0xfffff
    8000442e:	6b0080e7          	jalr	1712(ra) # 80003ada <iget>
    80004432:	8a2a                	mv	s4,a0
    80004434:	b7dd                	j	8000441a <namex+0x44>
      iunlockput(ip);
    80004436:	8552                	mv	a0,s4
    80004438:	00000097          	auipc	ra,0x0
    8000443c:	c48080e7          	jalr	-952(ra) # 80004080 <iunlockput>
      return 0;
    80004440:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80004442:	8552                	mv	a0,s4
    80004444:	60e6                	ld	ra,88(sp)
    80004446:	6446                	ld	s0,80(sp)
    80004448:	64a6                	ld	s1,72(sp)
    8000444a:	6906                	ld	s2,64(sp)
    8000444c:	79e2                	ld	s3,56(sp)
    8000444e:	7a42                	ld	s4,48(sp)
    80004450:	7aa2                	ld	s5,40(sp)
    80004452:	7b02                	ld	s6,32(sp)
    80004454:	6be2                	ld	s7,24(sp)
    80004456:	6c42                	ld	s8,16(sp)
    80004458:	6ca2                	ld	s9,8(sp)
    8000445a:	6d02                	ld	s10,0(sp)
    8000445c:	6125                	addi	sp,sp,96
    8000445e:	8082                	ret
      iunlock(ip);
    80004460:	8552                	mv	a0,s4
    80004462:	00000097          	auipc	ra,0x0
    80004466:	a7e080e7          	jalr	-1410(ra) # 80003ee0 <iunlock>
      return ip;
    8000446a:	bfe1                	j	80004442 <namex+0x6c>
      iunlockput(ip);
    8000446c:	8552                	mv	a0,s4
    8000446e:	00000097          	auipc	ra,0x0
    80004472:	c12080e7          	jalr	-1006(ra) # 80004080 <iunlockput>
      return 0;
    80004476:	8a4e                	mv	s4,s3
    80004478:	b7e9                	j	80004442 <namex+0x6c>
  len = path - s;
    8000447a:	40998633          	sub	a2,s3,s1
    8000447e:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80004482:	09ac5863          	bge	s8,s10,80004512 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80004486:	8666                	mv	a2,s9
    80004488:	85a6                	mv	a1,s1
    8000448a:	8556                	mv	a0,s5
    8000448c:	ffffd097          	auipc	ra,0xffffd
    80004490:	a96080e7          	jalr	-1386(ra) # 80000f22 <memmove>
    80004494:	84ce                	mv	s1,s3
  while(*path == '/')
    80004496:	0004c783          	lbu	a5,0(s1)
    8000449a:	01279763          	bne	a5,s2,800044a8 <namex+0xd2>
    path++;
    8000449e:	0485                	addi	s1,s1,1
  while(*path == '/')
    800044a0:	0004c783          	lbu	a5,0(s1)
    800044a4:	ff278de3          	beq	a5,s2,8000449e <namex+0xc8>
    ilock(ip);
    800044a8:	8552                	mv	a0,s4
    800044aa:	00000097          	auipc	ra,0x0
    800044ae:	970080e7          	jalr	-1680(ra) # 80003e1a <ilock>
    if(ip->type != T_DIR){
    800044b2:	044a1783          	lh	a5,68(s4)
    800044b6:	f97790e3          	bne	a5,s7,80004436 <namex+0x60>
    if(nameiparent && *path == '\0'){
    800044ba:	000b0563          	beqz	s6,800044c4 <namex+0xee>
    800044be:	0004c783          	lbu	a5,0(s1)
    800044c2:	dfd9                	beqz	a5,80004460 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    800044c4:	4601                	li	a2,0
    800044c6:	85d6                	mv	a1,s5
    800044c8:	8552                	mv	a0,s4
    800044ca:	00000097          	auipc	ra,0x0
    800044ce:	e4c080e7          	jalr	-436(ra) # 80004316 <dirlookup>
    800044d2:	89aa                	mv	s3,a0
    800044d4:	dd41                	beqz	a0,8000446c <namex+0x96>
    iunlockput(ip);
    800044d6:	8552                	mv	a0,s4
    800044d8:	00000097          	auipc	ra,0x0
    800044dc:	ba8080e7          	jalr	-1112(ra) # 80004080 <iunlockput>
    ip = next;
    800044e0:	8a4e                	mv	s4,s3
  while(*path == '/')
    800044e2:	0004c783          	lbu	a5,0(s1)
    800044e6:	01279763          	bne	a5,s2,800044f4 <namex+0x11e>
    path++;
    800044ea:	0485                	addi	s1,s1,1
  while(*path == '/')
    800044ec:	0004c783          	lbu	a5,0(s1)
    800044f0:	ff278de3          	beq	a5,s2,800044ea <namex+0x114>
  if(*path == 0)
    800044f4:	cb9d                	beqz	a5,8000452a <namex+0x154>
  while(*path != '/' && *path != 0)
    800044f6:	0004c783          	lbu	a5,0(s1)
    800044fa:	89a6                	mv	s3,s1
  len = path - s;
    800044fc:	4d01                	li	s10,0
    800044fe:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80004500:	01278963          	beq	a5,s2,80004512 <namex+0x13c>
    80004504:	dbbd                	beqz	a5,8000447a <namex+0xa4>
    path++;
    80004506:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80004508:	0009c783          	lbu	a5,0(s3)
    8000450c:	ff279ce3          	bne	a5,s2,80004504 <namex+0x12e>
    80004510:	b7ad                	j	8000447a <namex+0xa4>
    memmove(name, s, len);
    80004512:	2601                	sext.w	a2,a2
    80004514:	85a6                	mv	a1,s1
    80004516:	8556                	mv	a0,s5
    80004518:	ffffd097          	auipc	ra,0xffffd
    8000451c:	a0a080e7          	jalr	-1526(ra) # 80000f22 <memmove>
    name[len] = 0;
    80004520:	9d56                	add	s10,s10,s5
    80004522:	000d0023          	sb	zero,0(s10)
    80004526:	84ce                	mv	s1,s3
    80004528:	b7bd                	j	80004496 <namex+0xc0>
  if(nameiparent){
    8000452a:	f00b0ce3          	beqz	s6,80004442 <namex+0x6c>
    iput(ip);
    8000452e:	8552                	mv	a0,s4
    80004530:	00000097          	auipc	ra,0x0
    80004534:	aa8080e7          	jalr	-1368(ra) # 80003fd8 <iput>
    return 0;
    80004538:	4a01                	li	s4,0
    8000453a:	b721                	j	80004442 <namex+0x6c>

000000008000453c <dirlink>:
{
    8000453c:	715d                	addi	sp,sp,-80
    8000453e:	e486                	sd	ra,72(sp)
    80004540:	e0a2                	sd	s0,64(sp)
    80004542:	f84a                	sd	s2,48(sp)
    80004544:	ec56                	sd	s5,24(sp)
    80004546:	e85a                	sd	s6,16(sp)
    80004548:	0880                	addi	s0,sp,80
    8000454a:	892a                	mv	s2,a0
    8000454c:	8aae                	mv	s5,a1
    8000454e:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004550:	4601                	li	a2,0
    80004552:	00000097          	auipc	ra,0x0
    80004556:	dc4080e7          	jalr	-572(ra) # 80004316 <dirlookup>
    8000455a:	e129                	bnez	a0,8000459c <dirlink+0x60>
    8000455c:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000455e:	04c92483          	lw	s1,76(s2)
    80004562:	cca9                	beqz	s1,800045bc <dirlink+0x80>
    80004564:	f44e                	sd	s3,40(sp)
    80004566:	f052                	sd	s4,32(sp)
    80004568:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000456a:	fb040a13          	addi	s4,s0,-80
    8000456e:	49c1                	li	s3,16
    80004570:	874e                	mv	a4,s3
    80004572:	86a6                	mv	a3,s1
    80004574:	8652                	mv	a2,s4
    80004576:	4581                	li	a1,0
    80004578:	854a                	mv	a0,s2
    8000457a:	00000097          	auipc	ra,0x0
    8000457e:	b5c080e7          	jalr	-1188(ra) # 800040d6 <readi>
    80004582:	03351363          	bne	a0,s3,800045a8 <dirlink+0x6c>
    if(de.inum == 0)
    80004586:	fb045783          	lhu	a5,-80(s0)
    8000458a:	c79d                	beqz	a5,800045b8 <dirlink+0x7c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000458c:	24c1                	addiw	s1,s1,16
    8000458e:	04c92783          	lw	a5,76(s2)
    80004592:	fcf4efe3          	bltu	s1,a5,80004570 <dirlink+0x34>
    80004596:	79a2                	ld	s3,40(sp)
    80004598:	7a02                	ld	s4,32(sp)
    8000459a:	a00d                	j	800045bc <dirlink+0x80>
    iput(ip);
    8000459c:	00000097          	auipc	ra,0x0
    800045a0:	a3c080e7          	jalr	-1476(ra) # 80003fd8 <iput>
    return -1;
    800045a4:	557d                	li	a0,-1
    800045a6:	a0a9                	j	800045f0 <dirlink+0xb4>
      panic("dirlink read");
    800045a8:	00004517          	auipc	a0,0x4
    800045ac:	12050513          	addi	a0,a0,288 # 800086c8 <etext+0x6c8>
    800045b0:	ffffc097          	auipc	ra,0xffffc
    800045b4:	fb0080e7          	jalr	-80(ra) # 80000560 <panic>
    800045b8:	79a2                	ld	s3,40(sp)
    800045ba:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    800045bc:	4639                	li	a2,14
    800045be:	85d6                	mv	a1,s5
    800045c0:	fb240513          	addi	a0,s0,-78
    800045c4:	ffffd097          	auipc	ra,0xffffd
    800045c8:	a10080e7          	jalr	-1520(ra) # 80000fd4 <strncpy>
  de.inum = inum;
    800045cc:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800045d0:	4741                	li	a4,16
    800045d2:	86a6                	mv	a3,s1
    800045d4:	fb040613          	addi	a2,s0,-80
    800045d8:	4581                	li	a1,0
    800045da:	854a                	mv	a0,s2
    800045dc:	00000097          	auipc	ra,0x0
    800045e0:	c00080e7          	jalr	-1024(ra) # 800041dc <writei>
    800045e4:	1541                	addi	a0,a0,-16
    800045e6:	00a03533          	snez	a0,a0
    800045ea:	40a0053b          	negw	a0,a0
    800045ee:	74e2                	ld	s1,56(sp)
}
    800045f0:	60a6                	ld	ra,72(sp)
    800045f2:	6406                	ld	s0,64(sp)
    800045f4:	7942                	ld	s2,48(sp)
    800045f6:	6ae2                	ld	s5,24(sp)
    800045f8:	6b42                	ld	s6,16(sp)
    800045fa:	6161                	addi	sp,sp,80
    800045fc:	8082                	ret

00000000800045fe <namei>:

struct inode*
namei(char *path)
{
    800045fe:	1101                	addi	sp,sp,-32
    80004600:	ec06                	sd	ra,24(sp)
    80004602:	e822                	sd	s0,16(sp)
    80004604:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004606:	fe040613          	addi	a2,s0,-32
    8000460a:	4581                	li	a1,0
    8000460c:	00000097          	auipc	ra,0x0
    80004610:	dca080e7          	jalr	-566(ra) # 800043d6 <namex>
}
    80004614:	60e2                	ld	ra,24(sp)
    80004616:	6442                	ld	s0,16(sp)
    80004618:	6105                	addi	sp,sp,32
    8000461a:	8082                	ret

000000008000461c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000461c:	1141                	addi	sp,sp,-16
    8000461e:	e406                	sd	ra,8(sp)
    80004620:	e022                	sd	s0,0(sp)
    80004622:	0800                	addi	s0,sp,16
    80004624:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004626:	4585                	li	a1,1
    80004628:	00000097          	auipc	ra,0x0
    8000462c:	dae080e7          	jalr	-594(ra) # 800043d6 <namex>
}
    80004630:	60a2                	ld	ra,8(sp)
    80004632:	6402                	ld	s0,0(sp)
    80004634:	0141                	addi	sp,sp,16
    80004636:	8082                	ret

0000000080004638 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80004638:	1101                	addi	sp,sp,-32
    8000463a:	ec06                	sd	ra,24(sp)
    8000463c:	e822                	sd	s0,16(sp)
    8000463e:	e426                	sd	s1,8(sp)
    80004640:	e04a                	sd	s2,0(sp)
    80004642:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004644:	0045c917          	auipc	s2,0x45c
    80004648:	6ec90913          	addi	s2,s2,1772 # 80460d30 <log>
    8000464c:	01892583          	lw	a1,24(s2)
    80004650:	02892503          	lw	a0,40(s2)
    80004654:	fffff097          	auipc	ra,0xfffff
    80004658:	fb8080e7          	jalr	-72(ra) # 8000360c <bread>
    8000465c:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000465e:	02c92603          	lw	a2,44(s2)
    80004662:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004664:	00c05f63          	blez	a2,80004682 <write_head+0x4a>
    80004668:	0045c717          	auipc	a4,0x45c
    8000466c:	6f870713          	addi	a4,a4,1784 # 80460d60 <log+0x30>
    80004670:	87aa                	mv	a5,a0
    80004672:	060a                	slli	a2,a2,0x2
    80004674:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80004676:	4314                	lw	a3,0(a4)
    80004678:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000467a:	0711                	addi	a4,a4,4
    8000467c:	0791                	addi	a5,a5,4
    8000467e:	fec79ce3          	bne	a5,a2,80004676 <write_head+0x3e>
  }
  bwrite(buf);
    80004682:	8526                	mv	a0,s1
    80004684:	fffff097          	auipc	ra,0xfffff
    80004688:	07a080e7          	jalr	122(ra) # 800036fe <bwrite>
  brelse(buf);
    8000468c:	8526                	mv	a0,s1
    8000468e:	fffff097          	auipc	ra,0xfffff
    80004692:	0ae080e7          	jalr	174(ra) # 8000373c <brelse>
}
    80004696:	60e2                	ld	ra,24(sp)
    80004698:	6442                	ld	s0,16(sp)
    8000469a:	64a2                	ld	s1,8(sp)
    8000469c:	6902                	ld	s2,0(sp)
    8000469e:	6105                	addi	sp,sp,32
    800046a0:	8082                	ret

00000000800046a2 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800046a2:	0045c797          	auipc	a5,0x45c
    800046a6:	6ba7a783          	lw	a5,1722(a5) # 80460d5c <log+0x2c>
    800046aa:	0cf05063          	blez	a5,8000476a <install_trans+0xc8>
{
    800046ae:	715d                	addi	sp,sp,-80
    800046b0:	e486                	sd	ra,72(sp)
    800046b2:	e0a2                	sd	s0,64(sp)
    800046b4:	fc26                	sd	s1,56(sp)
    800046b6:	f84a                	sd	s2,48(sp)
    800046b8:	f44e                	sd	s3,40(sp)
    800046ba:	f052                	sd	s4,32(sp)
    800046bc:	ec56                	sd	s5,24(sp)
    800046be:	e85a                	sd	s6,16(sp)
    800046c0:	e45e                	sd	s7,8(sp)
    800046c2:	0880                	addi	s0,sp,80
    800046c4:	8b2a                	mv	s6,a0
    800046c6:	0045ca97          	auipc	s5,0x45c
    800046ca:	69aa8a93          	addi	s5,s5,1690 # 80460d60 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800046ce:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800046d0:	0045c997          	auipc	s3,0x45c
    800046d4:	66098993          	addi	s3,s3,1632 # 80460d30 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800046d8:	40000b93          	li	s7,1024
    800046dc:	a00d                	j	800046fe <install_trans+0x5c>
    brelse(lbuf);
    800046de:	854a                	mv	a0,s2
    800046e0:	fffff097          	auipc	ra,0xfffff
    800046e4:	05c080e7          	jalr	92(ra) # 8000373c <brelse>
    brelse(dbuf);
    800046e8:	8526                	mv	a0,s1
    800046ea:	fffff097          	auipc	ra,0xfffff
    800046ee:	052080e7          	jalr	82(ra) # 8000373c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800046f2:	2a05                	addiw	s4,s4,1
    800046f4:	0a91                	addi	s5,s5,4
    800046f6:	02c9a783          	lw	a5,44(s3)
    800046fa:	04fa5d63          	bge	s4,a5,80004754 <install_trans+0xb2>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800046fe:	0189a583          	lw	a1,24(s3)
    80004702:	014585bb          	addw	a1,a1,s4
    80004706:	2585                	addiw	a1,a1,1
    80004708:	0289a503          	lw	a0,40(s3)
    8000470c:	fffff097          	auipc	ra,0xfffff
    80004710:	f00080e7          	jalr	-256(ra) # 8000360c <bread>
    80004714:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004716:	000aa583          	lw	a1,0(s5)
    8000471a:	0289a503          	lw	a0,40(s3)
    8000471e:	fffff097          	auipc	ra,0xfffff
    80004722:	eee080e7          	jalr	-274(ra) # 8000360c <bread>
    80004726:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004728:	865e                	mv	a2,s7
    8000472a:	05890593          	addi	a1,s2,88
    8000472e:	05850513          	addi	a0,a0,88
    80004732:	ffffc097          	auipc	ra,0xffffc
    80004736:	7f0080e7          	jalr	2032(ra) # 80000f22 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000473a:	8526                	mv	a0,s1
    8000473c:	fffff097          	auipc	ra,0xfffff
    80004740:	fc2080e7          	jalr	-62(ra) # 800036fe <bwrite>
    if(recovering == 0)
    80004744:	f80b1de3          	bnez	s6,800046de <install_trans+0x3c>
      bunpin(dbuf);
    80004748:	8526                	mv	a0,s1
    8000474a:	fffff097          	auipc	ra,0xfffff
    8000474e:	0c6080e7          	jalr	198(ra) # 80003810 <bunpin>
    80004752:	b771                	j	800046de <install_trans+0x3c>
}
    80004754:	60a6                	ld	ra,72(sp)
    80004756:	6406                	ld	s0,64(sp)
    80004758:	74e2                	ld	s1,56(sp)
    8000475a:	7942                	ld	s2,48(sp)
    8000475c:	79a2                	ld	s3,40(sp)
    8000475e:	7a02                	ld	s4,32(sp)
    80004760:	6ae2                	ld	s5,24(sp)
    80004762:	6b42                	ld	s6,16(sp)
    80004764:	6ba2                	ld	s7,8(sp)
    80004766:	6161                	addi	sp,sp,80
    80004768:	8082                	ret
    8000476a:	8082                	ret

000000008000476c <initlog>:
{
    8000476c:	7179                	addi	sp,sp,-48
    8000476e:	f406                	sd	ra,40(sp)
    80004770:	f022                	sd	s0,32(sp)
    80004772:	ec26                	sd	s1,24(sp)
    80004774:	e84a                	sd	s2,16(sp)
    80004776:	e44e                	sd	s3,8(sp)
    80004778:	1800                	addi	s0,sp,48
    8000477a:	892a                	mv	s2,a0
    8000477c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000477e:	0045c497          	auipc	s1,0x45c
    80004782:	5b248493          	addi	s1,s1,1458 # 80460d30 <log>
    80004786:	00004597          	auipc	a1,0x4
    8000478a:	f5258593          	addi	a1,a1,-174 # 800086d8 <etext+0x6d8>
    8000478e:	8526                	mv	a0,s1
    80004790:	ffffc097          	auipc	ra,0xffffc
    80004794:	5a2080e7          	jalr	1442(ra) # 80000d32 <initlock>
  log.start = sb->logstart;
    80004798:	0149a583          	lw	a1,20(s3)
    8000479c:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000479e:	0109a783          	lw	a5,16(s3)
    800047a2:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800047a4:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800047a8:	854a                	mv	a0,s2
    800047aa:	fffff097          	auipc	ra,0xfffff
    800047ae:	e62080e7          	jalr	-414(ra) # 8000360c <bread>
  log.lh.n = lh->n;
    800047b2:	4d30                	lw	a2,88(a0)
    800047b4:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800047b6:	00c05f63          	blez	a2,800047d4 <initlog+0x68>
    800047ba:	87aa                	mv	a5,a0
    800047bc:	0045c717          	auipc	a4,0x45c
    800047c0:	5a470713          	addi	a4,a4,1444 # 80460d60 <log+0x30>
    800047c4:	060a                	slli	a2,a2,0x2
    800047c6:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800047c8:	4ff4                	lw	a3,92(a5)
    800047ca:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800047cc:	0791                	addi	a5,a5,4
    800047ce:	0711                	addi	a4,a4,4
    800047d0:	fec79ce3          	bne	a5,a2,800047c8 <initlog+0x5c>
  brelse(buf);
    800047d4:	fffff097          	auipc	ra,0xfffff
    800047d8:	f68080e7          	jalr	-152(ra) # 8000373c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800047dc:	4505                	li	a0,1
    800047de:	00000097          	auipc	ra,0x0
    800047e2:	ec4080e7          	jalr	-316(ra) # 800046a2 <install_trans>
  log.lh.n = 0;
    800047e6:	0045c797          	auipc	a5,0x45c
    800047ea:	5607ab23          	sw	zero,1398(a5) # 80460d5c <log+0x2c>
  write_head(); // clear the log
    800047ee:	00000097          	auipc	ra,0x0
    800047f2:	e4a080e7          	jalr	-438(ra) # 80004638 <write_head>
}
    800047f6:	70a2                	ld	ra,40(sp)
    800047f8:	7402                	ld	s0,32(sp)
    800047fa:	64e2                	ld	s1,24(sp)
    800047fc:	6942                	ld	s2,16(sp)
    800047fe:	69a2                	ld	s3,8(sp)
    80004800:	6145                	addi	sp,sp,48
    80004802:	8082                	ret

0000000080004804 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004804:	1101                	addi	sp,sp,-32
    80004806:	ec06                	sd	ra,24(sp)
    80004808:	e822                	sd	s0,16(sp)
    8000480a:	e426                	sd	s1,8(sp)
    8000480c:	e04a                	sd	s2,0(sp)
    8000480e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004810:	0045c517          	auipc	a0,0x45c
    80004814:	52050513          	addi	a0,a0,1312 # 80460d30 <log>
    80004818:	ffffc097          	auipc	ra,0xffffc
    8000481c:	5ae080e7          	jalr	1454(ra) # 80000dc6 <acquire>
  while(1){
    if(log.committing){
    80004820:	0045c497          	auipc	s1,0x45c
    80004824:	51048493          	addi	s1,s1,1296 # 80460d30 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004828:	4979                	li	s2,30
    8000482a:	a039                	j	80004838 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000482c:	85a6                	mv	a1,s1
    8000482e:	8526                	mv	a0,s1
    80004830:	ffffe097          	auipc	ra,0xffffe
    80004834:	ca2080e7          	jalr	-862(ra) # 800024d2 <sleep>
    if(log.committing){
    80004838:	50dc                	lw	a5,36(s1)
    8000483a:	fbed                	bnez	a5,8000482c <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000483c:	5098                	lw	a4,32(s1)
    8000483e:	2705                	addiw	a4,a4,1
    80004840:	0027179b          	slliw	a5,a4,0x2
    80004844:	9fb9                	addw	a5,a5,a4
    80004846:	0017979b          	slliw	a5,a5,0x1
    8000484a:	54d4                	lw	a3,44(s1)
    8000484c:	9fb5                	addw	a5,a5,a3
    8000484e:	00f95963          	bge	s2,a5,80004860 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004852:	85a6                	mv	a1,s1
    80004854:	8526                	mv	a0,s1
    80004856:	ffffe097          	auipc	ra,0xffffe
    8000485a:	c7c080e7          	jalr	-900(ra) # 800024d2 <sleep>
    8000485e:	bfe9                	j	80004838 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004860:	0045c517          	auipc	a0,0x45c
    80004864:	4d050513          	addi	a0,a0,1232 # 80460d30 <log>
    80004868:	d118                	sw	a4,32(a0)
      release(&log.lock);
    8000486a:	ffffc097          	auipc	ra,0xffffc
    8000486e:	60c080e7          	jalr	1548(ra) # 80000e76 <release>
      break;
    }
  }
}
    80004872:	60e2                	ld	ra,24(sp)
    80004874:	6442                	ld	s0,16(sp)
    80004876:	64a2                	ld	s1,8(sp)
    80004878:	6902                	ld	s2,0(sp)
    8000487a:	6105                	addi	sp,sp,32
    8000487c:	8082                	ret

000000008000487e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000487e:	7139                	addi	sp,sp,-64
    80004880:	fc06                	sd	ra,56(sp)
    80004882:	f822                	sd	s0,48(sp)
    80004884:	f426                	sd	s1,40(sp)
    80004886:	f04a                	sd	s2,32(sp)
    80004888:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000488a:	0045c497          	auipc	s1,0x45c
    8000488e:	4a648493          	addi	s1,s1,1190 # 80460d30 <log>
    80004892:	8526                	mv	a0,s1
    80004894:	ffffc097          	auipc	ra,0xffffc
    80004898:	532080e7          	jalr	1330(ra) # 80000dc6 <acquire>
  log.outstanding -= 1;
    8000489c:	509c                	lw	a5,32(s1)
    8000489e:	37fd                	addiw	a5,a5,-1
    800048a0:	893e                	mv	s2,a5
    800048a2:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800048a4:	50dc                	lw	a5,36(s1)
    800048a6:	e7b9                	bnez	a5,800048f4 <end_op+0x76>
    panic("log.committing");
  if(log.outstanding == 0){
    800048a8:	06091263          	bnez	s2,8000490c <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800048ac:	0045c497          	auipc	s1,0x45c
    800048b0:	48448493          	addi	s1,s1,1156 # 80460d30 <log>
    800048b4:	4785                	li	a5,1
    800048b6:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800048b8:	8526                	mv	a0,s1
    800048ba:	ffffc097          	auipc	ra,0xffffc
    800048be:	5bc080e7          	jalr	1468(ra) # 80000e76 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800048c2:	54dc                	lw	a5,44(s1)
    800048c4:	06f04863          	bgtz	a5,80004934 <end_op+0xb6>
    acquire(&log.lock);
    800048c8:	0045c497          	auipc	s1,0x45c
    800048cc:	46848493          	addi	s1,s1,1128 # 80460d30 <log>
    800048d0:	8526                	mv	a0,s1
    800048d2:	ffffc097          	auipc	ra,0xffffc
    800048d6:	4f4080e7          	jalr	1268(ra) # 80000dc6 <acquire>
    log.committing = 0;
    800048da:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800048de:	8526                	mv	a0,s1
    800048e0:	ffffe097          	auipc	ra,0xffffe
    800048e4:	c56080e7          	jalr	-938(ra) # 80002536 <wakeup>
    release(&log.lock);
    800048e8:	8526                	mv	a0,s1
    800048ea:	ffffc097          	auipc	ra,0xffffc
    800048ee:	58c080e7          	jalr	1420(ra) # 80000e76 <release>
}
    800048f2:	a81d                	j	80004928 <end_op+0xaa>
    800048f4:	ec4e                	sd	s3,24(sp)
    800048f6:	e852                	sd	s4,16(sp)
    800048f8:	e456                	sd	s5,8(sp)
    800048fa:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    800048fc:	00004517          	auipc	a0,0x4
    80004900:	de450513          	addi	a0,a0,-540 # 800086e0 <etext+0x6e0>
    80004904:	ffffc097          	auipc	ra,0xffffc
    80004908:	c5c080e7          	jalr	-932(ra) # 80000560 <panic>
    wakeup(&log);
    8000490c:	0045c497          	auipc	s1,0x45c
    80004910:	42448493          	addi	s1,s1,1060 # 80460d30 <log>
    80004914:	8526                	mv	a0,s1
    80004916:	ffffe097          	auipc	ra,0xffffe
    8000491a:	c20080e7          	jalr	-992(ra) # 80002536 <wakeup>
  release(&log.lock);
    8000491e:	8526                	mv	a0,s1
    80004920:	ffffc097          	auipc	ra,0xffffc
    80004924:	556080e7          	jalr	1366(ra) # 80000e76 <release>
}
    80004928:	70e2                	ld	ra,56(sp)
    8000492a:	7442                	ld	s0,48(sp)
    8000492c:	74a2                	ld	s1,40(sp)
    8000492e:	7902                	ld	s2,32(sp)
    80004930:	6121                	addi	sp,sp,64
    80004932:	8082                	ret
    80004934:	ec4e                	sd	s3,24(sp)
    80004936:	e852                	sd	s4,16(sp)
    80004938:	e456                	sd	s5,8(sp)
    8000493a:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000493c:	0045ca97          	auipc	s5,0x45c
    80004940:	424a8a93          	addi	s5,s5,1060 # 80460d60 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004944:	0045ca17          	auipc	s4,0x45c
    80004948:	3eca0a13          	addi	s4,s4,1004 # 80460d30 <log>
    memmove(to->data, from->data, BSIZE);
    8000494c:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004950:	018a2583          	lw	a1,24(s4)
    80004954:	012585bb          	addw	a1,a1,s2
    80004958:	2585                	addiw	a1,a1,1
    8000495a:	028a2503          	lw	a0,40(s4)
    8000495e:	fffff097          	auipc	ra,0xfffff
    80004962:	cae080e7          	jalr	-850(ra) # 8000360c <bread>
    80004966:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004968:	000aa583          	lw	a1,0(s5)
    8000496c:	028a2503          	lw	a0,40(s4)
    80004970:	fffff097          	auipc	ra,0xfffff
    80004974:	c9c080e7          	jalr	-868(ra) # 8000360c <bread>
    80004978:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000497a:	865a                	mv	a2,s6
    8000497c:	05850593          	addi	a1,a0,88
    80004980:	05848513          	addi	a0,s1,88
    80004984:	ffffc097          	auipc	ra,0xffffc
    80004988:	59e080e7          	jalr	1438(ra) # 80000f22 <memmove>
    bwrite(to);  // write the log
    8000498c:	8526                	mv	a0,s1
    8000498e:	fffff097          	auipc	ra,0xfffff
    80004992:	d70080e7          	jalr	-656(ra) # 800036fe <bwrite>
    brelse(from);
    80004996:	854e                	mv	a0,s3
    80004998:	fffff097          	auipc	ra,0xfffff
    8000499c:	da4080e7          	jalr	-604(ra) # 8000373c <brelse>
    brelse(to);
    800049a0:	8526                	mv	a0,s1
    800049a2:	fffff097          	auipc	ra,0xfffff
    800049a6:	d9a080e7          	jalr	-614(ra) # 8000373c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800049aa:	2905                	addiw	s2,s2,1
    800049ac:	0a91                	addi	s5,s5,4
    800049ae:	02ca2783          	lw	a5,44(s4)
    800049b2:	f8f94fe3          	blt	s2,a5,80004950 <end_op+0xd2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800049b6:	00000097          	auipc	ra,0x0
    800049ba:	c82080e7          	jalr	-894(ra) # 80004638 <write_head>
    install_trans(0); // Now install writes to home locations
    800049be:	4501                	li	a0,0
    800049c0:	00000097          	auipc	ra,0x0
    800049c4:	ce2080e7          	jalr	-798(ra) # 800046a2 <install_trans>
    log.lh.n = 0;
    800049c8:	0045c797          	auipc	a5,0x45c
    800049cc:	3807aa23          	sw	zero,916(a5) # 80460d5c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800049d0:	00000097          	auipc	ra,0x0
    800049d4:	c68080e7          	jalr	-920(ra) # 80004638 <write_head>
    800049d8:	69e2                	ld	s3,24(sp)
    800049da:	6a42                	ld	s4,16(sp)
    800049dc:	6aa2                	ld	s5,8(sp)
    800049de:	6b02                	ld	s6,0(sp)
    800049e0:	b5e5                	j	800048c8 <end_op+0x4a>

00000000800049e2 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800049e2:	1101                	addi	sp,sp,-32
    800049e4:	ec06                	sd	ra,24(sp)
    800049e6:	e822                	sd	s0,16(sp)
    800049e8:	e426                	sd	s1,8(sp)
    800049ea:	e04a                	sd	s2,0(sp)
    800049ec:	1000                	addi	s0,sp,32
    800049ee:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800049f0:	0045c917          	auipc	s2,0x45c
    800049f4:	34090913          	addi	s2,s2,832 # 80460d30 <log>
    800049f8:	854a                	mv	a0,s2
    800049fa:	ffffc097          	auipc	ra,0xffffc
    800049fe:	3cc080e7          	jalr	972(ra) # 80000dc6 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004a02:	02c92603          	lw	a2,44(s2)
    80004a06:	47f5                	li	a5,29
    80004a08:	06c7c563          	blt	a5,a2,80004a72 <log_write+0x90>
    80004a0c:	0045c797          	auipc	a5,0x45c
    80004a10:	3407a783          	lw	a5,832(a5) # 80460d4c <log+0x1c>
    80004a14:	37fd                	addiw	a5,a5,-1
    80004a16:	04f65e63          	bge	a2,a5,80004a72 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004a1a:	0045c797          	auipc	a5,0x45c
    80004a1e:	3367a783          	lw	a5,822(a5) # 80460d50 <log+0x20>
    80004a22:	06f05063          	blez	a5,80004a82 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004a26:	4781                	li	a5,0
    80004a28:	06c05563          	blez	a2,80004a92 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004a2c:	44cc                	lw	a1,12(s1)
    80004a2e:	0045c717          	auipc	a4,0x45c
    80004a32:	33270713          	addi	a4,a4,818 # 80460d60 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004a36:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004a38:	4314                	lw	a3,0(a4)
    80004a3a:	04b68c63          	beq	a3,a1,80004a92 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80004a3e:	2785                	addiw	a5,a5,1
    80004a40:	0711                	addi	a4,a4,4
    80004a42:	fef61be3          	bne	a2,a5,80004a38 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004a46:	0621                	addi	a2,a2,8
    80004a48:	060a                	slli	a2,a2,0x2
    80004a4a:	0045c797          	auipc	a5,0x45c
    80004a4e:	2e678793          	addi	a5,a5,742 # 80460d30 <log>
    80004a52:	97b2                	add	a5,a5,a2
    80004a54:	44d8                	lw	a4,12(s1)
    80004a56:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004a58:	8526                	mv	a0,s1
    80004a5a:	fffff097          	auipc	ra,0xfffff
    80004a5e:	d7a080e7          	jalr	-646(ra) # 800037d4 <bpin>
    log.lh.n++;
    80004a62:	0045c717          	auipc	a4,0x45c
    80004a66:	2ce70713          	addi	a4,a4,718 # 80460d30 <log>
    80004a6a:	575c                	lw	a5,44(a4)
    80004a6c:	2785                	addiw	a5,a5,1
    80004a6e:	d75c                	sw	a5,44(a4)
    80004a70:	a82d                	j	80004aaa <log_write+0xc8>
    panic("too big a transaction");
    80004a72:	00004517          	auipc	a0,0x4
    80004a76:	c7e50513          	addi	a0,a0,-898 # 800086f0 <etext+0x6f0>
    80004a7a:	ffffc097          	auipc	ra,0xffffc
    80004a7e:	ae6080e7          	jalr	-1306(ra) # 80000560 <panic>
    panic("log_write outside of trans");
    80004a82:	00004517          	auipc	a0,0x4
    80004a86:	c8650513          	addi	a0,a0,-890 # 80008708 <etext+0x708>
    80004a8a:	ffffc097          	auipc	ra,0xffffc
    80004a8e:	ad6080e7          	jalr	-1322(ra) # 80000560 <panic>
  log.lh.block[i] = b->blockno;
    80004a92:	00878693          	addi	a3,a5,8
    80004a96:	068a                	slli	a3,a3,0x2
    80004a98:	0045c717          	auipc	a4,0x45c
    80004a9c:	29870713          	addi	a4,a4,664 # 80460d30 <log>
    80004aa0:	9736                	add	a4,a4,a3
    80004aa2:	44d4                	lw	a3,12(s1)
    80004aa4:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004aa6:	faf609e3          	beq	a2,a5,80004a58 <log_write+0x76>
  }
  release(&log.lock);
    80004aaa:	0045c517          	auipc	a0,0x45c
    80004aae:	28650513          	addi	a0,a0,646 # 80460d30 <log>
    80004ab2:	ffffc097          	auipc	ra,0xffffc
    80004ab6:	3c4080e7          	jalr	964(ra) # 80000e76 <release>
}
    80004aba:	60e2                	ld	ra,24(sp)
    80004abc:	6442                	ld	s0,16(sp)
    80004abe:	64a2                	ld	s1,8(sp)
    80004ac0:	6902                	ld	s2,0(sp)
    80004ac2:	6105                	addi	sp,sp,32
    80004ac4:	8082                	ret

0000000080004ac6 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004ac6:	1101                	addi	sp,sp,-32
    80004ac8:	ec06                	sd	ra,24(sp)
    80004aca:	e822                	sd	s0,16(sp)
    80004acc:	e426                	sd	s1,8(sp)
    80004ace:	e04a                	sd	s2,0(sp)
    80004ad0:	1000                	addi	s0,sp,32
    80004ad2:	84aa                	mv	s1,a0
    80004ad4:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004ad6:	00004597          	auipc	a1,0x4
    80004ada:	c5258593          	addi	a1,a1,-942 # 80008728 <etext+0x728>
    80004ade:	0521                	addi	a0,a0,8
    80004ae0:	ffffc097          	auipc	ra,0xffffc
    80004ae4:	252080e7          	jalr	594(ra) # 80000d32 <initlock>
  lk->name = name;
    80004ae8:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004aec:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004af0:	0204a423          	sw	zero,40(s1)
}
    80004af4:	60e2                	ld	ra,24(sp)
    80004af6:	6442                	ld	s0,16(sp)
    80004af8:	64a2                	ld	s1,8(sp)
    80004afa:	6902                	ld	s2,0(sp)
    80004afc:	6105                	addi	sp,sp,32
    80004afe:	8082                	ret

0000000080004b00 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004b00:	1101                	addi	sp,sp,-32
    80004b02:	ec06                	sd	ra,24(sp)
    80004b04:	e822                	sd	s0,16(sp)
    80004b06:	e426                	sd	s1,8(sp)
    80004b08:	e04a                	sd	s2,0(sp)
    80004b0a:	1000                	addi	s0,sp,32
    80004b0c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004b0e:	00850913          	addi	s2,a0,8
    80004b12:	854a                	mv	a0,s2
    80004b14:	ffffc097          	auipc	ra,0xffffc
    80004b18:	2b2080e7          	jalr	690(ra) # 80000dc6 <acquire>
  while (lk->locked) {
    80004b1c:	409c                	lw	a5,0(s1)
    80004b1e:	cb89                	beqz	a5,80004b30 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004b20:	85ca                	mv	a1,s2
    80004b22:	8526                	mv	a0,s1
    80004b24:	ffffe097          	auipc	ra,0xffffe
    80004b28:	9ae080e7          	jalr	-1618(ra) # 800024d2 <sleep>
  while (lk->locked) {
    80004b2c:	409c                	lw	a5,0(s1)
    80004b2e:	fbed                	bnez	a5,80004b20 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004b30:	4785                	li	a5,1
    80004b32:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004b34:	ffffd097          	auipc	ra,0xffffd
    80004b38:	1ea080e7          	jalr	490(ra) # 80001d1e <myproc>
    80004b3c:	591c                	lw	a5,48(a0)
    80004b3e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004b40:	854a                	mv	a0,s2
    80004b42:	ffffc097          	auipc	ra,0xffffc
    80004b46:	334080e7          	jalr	820(ra) # 80000e76 <release>
}
    80004b4a:	60e2                	ld	ra,24(sp)
    80004b4c:	6442                	ld	s0,16(sp)
    80004b4e:	64a2                	ld	s1,8(sp)
    80004b50:	6902                	ld	s2,0(sp)
    80004b52:	6105                	addi	sp,sp,32
    80004b54:	8082                	ret

0000000080004b56 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004b56:	1101                	addi	sp,sp,-32
    80004b58:	ec06                	sd	ra,24(sp)
    80004b5a:	e822                	sd	s0,16(sp)
    80004b5c:	e426                	sd	s1,8(sp)
    80004b5e:	e04a                	sd	s2,0(sp)
    80004b60:	1000                	addi	s0,sp,32
    80004b62:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004b64:	00850913          	addi	s2,a0,8
    80004b68:	854a                	mv	a0,s2
    80004b6a:	ffffc097          	auipc	ra,0xffffc
    80004b6e:	25c080e7          	jalr	604(ra) # 80000dc6 <acquire>
  lk->locked = 0;
    80004b72:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004b76:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004b7a:	8526                	mv	a0,s1
    80004b7c:	ffffe097          	auipc	ra,0xffffe
    80004b80:	9ba080e7          	jalr	-1606(ra) # 80002536 <wakeup>
  release(&lk->lk);
    80004b84:	854a                	mv	a0,s2
    80004b86:	ffffc097          	auipc	ra,0xffffc
    80004b8a:	2f0080e7          	jalr	752(ra) # 80000e76 <release>
}
    80004b8e:	60e2                	ld	ra,24(sp)
    80004b90:	6442                	ld	s0,16(sp)
    80004b92:	64a2                	ld	s1,8(sp)
    80004b94:	6902                	ld	s2,0(sp)
    80004b96:	6105                	addi	sp,sp,32
    80004b98:	8082                	ret

0000000080004b9a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004b9a:	7179                	addi	sp,sp,-48
    80004b9c:	f406                	sd	ra,40(sp)
    80004b9e:	f022                	sd	s0,32(sp)
    80004ba0:	ec26                	sd	s1,24(sp)
    80004ba2:	e84a                	sd	s2,16(sp)
    80004ba4:	1800                	addi	s0,sp,48
    80004ba6:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004ba8:	00850913          	addi	s2,a0,8
    80004bac:	854a                	mv	a0,s2
    80004bae:	ffffc097          	auipc	ra,0xffffc
    80004bb2:	218080e7          	jalr	536(ra) # 80000dc6 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004bb6:	409c                	lw	a5,0(s1)
    80004bb8:	ef91                	bnez	a5,80004bd4 <holdingsleep+0x3a>
    80004bba:	4481                	li	s1,0
  release(&lk->lk);
    80004bbc:	854a                	mv	a0,s2
    80004bbe:	ffffc097          	auipc	ra,0xffffc
    80004bc2:	2b8080e7          	jalr	696(ra) # 80000e76 <release>
  return r;
}
    80004bc6:	8526                	mv	a0,s1
    80004bc8:	70a2                	ld	ra,40(sp)
    80004bca:	7402                	ld	s0,32(sp)
    80004bcc:	64e2                	ld	s1,24(sp)
    80004bce:	6942                	ld	s2,16(sp)
    80004bd0:	6145                	addi	sp,sp,48
    80004bd2:	8082                	ret
    80004bd4:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004bd6:	0284a983          	lw	s3,40(s1)
    80004bda:	ffffd097          	auipc	ra,0xffffd
    80004bde:	144080e7          	jalr	324(ra) # 80001d1e <myproc>
    80004be2:	5904                	lw	s1,48(a0)
    80004be4:	413484b3          	sub	s1,s1,s3
    80004be8:	0014b493          	seqz	s1,s1
    80004bec:	69a2                	ld	s3,8(sp)
    80004bee:	b7f9                	j	80004bbc <holdingsleep+0x22>

0000000080004bf0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004bf0:	1141                	addi	sp,sp,-16
    80004bf2:	e406                	sd	ra,8(sp)
    80004bf4:	e022                	sd	s0,0(sp)
    80004bf6:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004bf8:	00004597          	auipc	a1,0x4
    80004bfc:	b4058593          	addi	a1,a1,-1216 # 80008738 <etext+0x738>
    80004c00:	0045c517          	auipc	a0,0x45c
    80004c04:	27850513          	addi	a0,a0,632 # 80460e78 <ftable>
    80004c08:	ffffc097          	auipc	ra,0xffffc
    80004c0c:	12a080e7          	jalr	298(ra) # 80000d32 <initlock>
}
    80004c10:	60a2                	ld	ra,8(sp)
    80004c12:	6402                	ld	s0,0(sp)
    80004c14:	0141                	addi	sp,sp,16
    80004c16:	8082                	ret

0000000080004c18 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004c18:	1101                	addi	sp,sp,-32
    80004c1a:	ec06                	sd	ra,24(sp)
    80004c1c:	e822                	sd	s0,16(sp)
    80004c1e:	e426                	sd	s1,8(sp)
    80004c20:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004c22:	0045c517          	auipc	a0,0x45c
    80004c26:	25650513          	addi	a0,a0,598 # 80460e78 <ftable>
    80004c2a:	ffffc097          	auipc	ra,0xffffc
    80004c2e:	19c080e7          	jalr	412(ra) # 80000dc6 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004c32:	0045c497          	auipc	s1,0x45c
    80004c36:	25e48493          	addi	s1,s1,606 # 80460e90 <ftable+0x18>
    80004c3a:	0045d717          	auipc	a4,0x45d
    80004c3e:	1f670713          	addi	a4,a4,502 # 80461e30 <disk>
    if(f->ref == 0){
    80004c42:	40dc                	lw	a5,4(s1)
    80004c44:	cf99                	beqz	a5,80004c62 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004c46:	02848493          	addi	s1,s1,40
    80004c4a:	fee49ce3          	bne	s1,a4,80004c42 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004c4e:	0045c517          	auipc	a0,0x45c
    80004c52:	22a50513          	addi	a0,a0,554 # 80460e78 <ftable>
    80004c56:	ffffc097          	auipc	ra,0xffffc
    80004c5a:	220080e7          	jalr	544(ra) # 80000e76 <release>
  return 0;
    80004c5e:	4481                	li	s1,0
    80004c60:	a819                	j	80004c76 <filealloc+0x5e>
      f->ref = 1;
    80004c62:	4785                	li	a5,1
    80004c64:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004c66:	0045c517          	auipc	a0,0x45c
    80004c6a:	21250513          	addi	a0,a0,530 # 80460e78 <ftable>
    80004c6e:	ffffc097          	auipc	ra,0xffffc
    80004c72:	208080e7          	jalr	520(ra) # 80000e76 <release>
}
    80004c76:	8526                	mv	a0,s1
    80004c78:	60e2                	ld	ra,24(sp)
    80004c7a:	6442                	ld	s0,16(sp)
    80004c7c:	64a2                	ld	s1,8(sp)
    80004c7e:	6105                	addi	sp,sp,32
    80004c80:	8082                	ret

0000000080004c82 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004c82:	1101                	addi	sp,sp,-32
    80004c84:	ec06                	sd	ra,24(sp)
    80004c86:	e822                	sd	s0,16(sp)
    80004c88:	e426                	sd	s1,8(sp)
    80004c8a:	1000                	addi	s0,sp,32
    80004c8c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004c8e:	0045c517          	auipc	a0,0x45c
    80004c92:	1ea50513          	addi	a0,a0,490 # 80460e78 <ftable>
    80004c96:	ffffc097          	auipc	ra,0xffffc
    80004c9a:	130080e7          	jalr	304(ra) # 80000dc6 <acquire>
  if(f->ref < 1)
    80004c9e:	40dc                	lw	a5,4(s1)
    80004ca0:	02f05263          	blez	a5,80004cc4 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004ca4:	2785                	addiw	a5,a5,1
    80004ca6:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004ca8:	0045c517          	auipc	a0,0x45c
    80004cac:	1d050513          	addi	a0,a0,464 # 80460e78 <ftable>
    80004cb0:	ffffc097          	auipc	ra,0xffffc
    80004cb4:	1c6080e7          	jalr	454(ra) # 80000e76 <release>
  return f;
}
    80004cb8:	8526                	mv	a0,s1
    80004cba:	60e2                	ld	ra,24(sp)
    80004cbc:	6442                	ld	s0,16(sp)
    80004cbe:	64a2                	ld	s1,8(sp)
    80004cc0:	6105                	addi	sp,sp,32
    80004cc2:	8082                	ret
    panic("filedup");
    80004cc4:	00004517          	auipc	a0,0x4
    80004cc8:	a7c50513          	addi	a0,a0,-1412 # 80008740 <etext+0x740>
    80004ccc:	ffffc097          	auipc	ra,0xffffc
    80004cd0:	894080e7          	jalr	-1900(ra) # 80000560 <panic>

0000000080004cd4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004cd4:	7139                	addi	sp,sp,-64
    80004cd6:	fc06                	sd	ra,56(sp)
    80004cd8:	f822                	sd	s0,48(sp)
    80004cda:	f426                	sd	s1,40(sp)
    80004cdc:	0080                	addi	s0,sp,64
    80004cde:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004ce0:	0045c517          	auipc	a0,0x45c
    80004ce4:	19850513          	addi	a0,a0,408 # 80460e78 <ftable>
    80004ce8:	ffffc097          	auipc	ra,0xffffc
    80004cec:	0de080e7          	jalr	222(ra) # 80000dc6 <acquire>
  if(f->ref < 1)
    80004cf0:	40dc                	lw	a5,4(s1)
    80004cf2:	04f05a63          	blez	a5,80004d46 <fileclose+0x72>
    panic("fileclose");
  if(--f->ref > 0){
    80004cf6:	37fd                	addiw	a5,a5,-1
    80004cf8:	c0dc                	sw	a5,4(s1)
    80004cfa:	06f04263          	bgtz	a5,80004d5e <fileclose+0x8a>
    80004cfe:	f04a                	sd	s2,32(sp)
    80004d00:	ec4e                	sd	s3,24(sp)
    80004d02:	e852                	sd	s4,16(sp)
    80004d04:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004d06:	0004a903          	lw	s2,0(s1)
    80004d0a:	0094ca83          	lbu	s5,9(s1)
    80004d0e:	0104ba03          	ld	s4,16(s1)
    80004d12:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004d16:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004d1a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004d1e:	0045c517          	auipc	a0,0x45c
    80004d22:	15a50513          	addi	a0,a0,346 # 80460e78 <ftable>
    80004d26:	ffffc097          	auipc	ra,0xffffc
    80004d2a:	150080e7          	jalr	336(ra) # 80000e76 <release>

  if(ff.type == FD_PIPE){
    80004d2e:	4785                	li	a5,1
    80004d30:	04f90463          	beq	s2,a5,80004d78 <fileclose+0xa4>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004d34:	3979                	addiw	s2,s2,-2
    80004d36:	4785                	li	a5,1
    80004d38:	0527fb63          	bgeu	a5,s2,80004d8e <fileclose+0xba>
    80004d3c:	7902                	ld	s2,32(sp)
    80004d3e:	69e2                	ld	s3,24(sp)
    80004d40:	6a42                	ld	s4,16(sp)
    80004d42:	6aa2                	ld	s5,8(sp)
    80004d44:	a02d                	j	80004d6e <fileclose+0x9a>
    80004d46:	f04a                	sd	s2,32(sp)
    80004d48:	ec4e                	sd	s3,24(sp)
    80004d4a:	e852                	sd	s4,16(sp)
    80004d4c:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004d4e:	00004517          	auipc	a0,0x4
    80004d52:	9fa50513          	addi	a0,a0,-1542 # 80008748 <etext+0x748>
    80004d56:	ffffc097          	auipc	ra,0xffffc
    80004d5a:	80a080e7          	jalr	-2038(ra) # 80000560 <panic>
    release(&ftable.lock);
    80004d5e:	0045c517          	auipc	a0,0x45c
    80004d62:	11a50513          	addi	a0,a0,282 # 80460e78 <ftable>
    80004d66:	ffffc097          	auipc	ra,0xffffc
    80004d6a:	110080e7          	jalr	272(ra) # 80000e76 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004d6e:	70e2                	ld	ra,56(sp)
    80004d70:	7442                	ld	s0,48(sp)
    80004d72:	74a2                	ld	s1,40(sp)
    80004d74:	6121                	addi	sp,sp,64
    80004d76:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004d78:	85d6                	mv	a1,s5
    80004d7a:	8552                	mv	a0,s4
    80004d7c:	00000097          	auipc	ra,0x0
    80004d80:	3ac080e7          	jalr	940(ra) # 80005128 <pipeclose>
    80004d84:	7902                	ld	s2,32(sp)
    80004d86:	69e2                	ld	s3,24(sp)
    80004d88:	6a42                	ld	s4,16(sp)
    80004d8a:	6aa2                	ld	s5,8(sp)
    80004d8c:	b7cd                	j	80004d6e <fileclose+0x9a>
    begin_op();
    80004d8e:	00000097          	auipc	ra,0x0
    80004d92:	a76080e7          	jalr	-1418(ra) # 80004804 <begin_op>
    iput(ff.ip);
    80004d96:	854e                	mv	a0,s3
    80004d98:	fffff097          	auipc	ra,0xfffff
    80004d9c:	240080e7          	jalr	576(ra) # 80003fd8 <iput>
    end_op();
    80004da0:	00000097          	auipc	ra,0x0
    80004da4:	ade080e7          	jalr	-1314(ra) # 8000487e <end_op>
    80004da8:	7902                	ld	s2,32(sp)
    80004daa:	69e2                	ld	s3,24(sp)
    80004dac:	6a42                	ld	s4,16(sp)
    80004dae:	6aa2                	ld	s5,8(sp)
    80004db0:	bf7d                	j	80004d6e <fileclose+0x9a>

0000000080004db2 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004db2:	715d                	addi	sp,sp,-80
    80004db4:	e486                	sd	ra,72(sp)
    80004db6:	e0a2                	sd	s0,64(sp)
    80004db8:	fc26                	sd	s1,56(sp)
    80004dba:	f44e                	sd	s3,40(sp)
    80004dbc:	0880                	addi	s0,sp,80
    80004dbe:	84aa                	mv	s1,a0
    80004dc0:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004dc2:	ffffd097          	auipc	ra,0xffffd
    80004dc6:	f5c080e7          	jalr	-164(ra) # 80001d1e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004dca:	409c                	lw	a5,0(s1)
    80004dcc:	37f9                	addiw	a5,a5,-2
    80004dce:	4705                	li	a4,1
    80004dd0:	04f76a63          	bltu	a4,a5,80004e24 <filestat+0x72>
    80004dd4:	f84a                	sd	s2,48(sp)
    80004dd6:	f052                	sd	s4,32(sp)
    80004dd8:	892a                	mv	s2,a0
    ilock(f->ip);
    80004dda:	6c88                	ld	a0,24(s1)
    80004ddc:	fffff097          	auipc	ra,0xfffff
    80004de0:	03e080e7          	jalr	62(ra) # 80003e1a <ilock>
    stati(f->ip, &st);
    80004de4:	fb840a13          	addi	s4,s0,-72
    80004de8:	85d2                	mv	a1,s4
    80004dea:	6c88                	ld	a0,24(s1)
    80004dec:	fffff097          	auipc	ra,0xfffff
    80004df0:	2bc080e7          	jalr	700(ra) # 800040a8 <stati>
    iunlock(f->ip);
    80004df4:	6c88                	ld	a0,24(s1)
    80004df6:	fffff097          	auipc	ra,0xfffff
    80004dfa:	0ea080e7          	jalr	234(ra) # 80003ee0 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004dfe:	46e1                	li	a3,24
    80004e00:	8652                	mv	a2,s4
    80004e02:	85ce                	mv	a1,s3
    80004e04:	05093503          	ld	a0,80(s2)
    80004e08:	ffffd097          	auipc	ra,0xffffd
    80004e0c:	a8e080e7          	jalr	-1394(ra) # 80001896 <copyout>
    80004e10:	41f5551b          	sraiw	a0,a0,0x1f
    80004e14:	7942                	ld	s2,48(sp)
    80004e16:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004e18:	60a6                	ld	ra,72(sp)
    80004e1a:	6406                	ld	s0,64(sp)
    80004e1c:	74e2                	ld	s1,56(sp)
    80004e1e:	79a2                	ld	s3,40(sp)
    80004e20:	6161                	addi	sp,sp,80
    80004e22:	8082                	ret
  return -1;
    80004e24:	557d                	li	a0,-1
    80004e26:	bfcd                	j	80004e18 <filestat+0x66>

0000000080004e28 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004e28:	7179                	addi	sp,sp,-48
    80004e2a:	f406                	sd	ra,40(sp)
    80004e2c:	f022                	sd	s0,32(sp)
    80004e2e:	e84a                	sd	s2,16(sp)
    80004e30:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004e32:	00854783          	lbu	a5,8(a0)
    80004e36:	cbc5                	beqz	a5,80004ee6 <fileread+0xbe>
    80004e38:	ec26                	sd	s1,24(sp)
    80004e3a:	e44e                	sd	s3,8(sp)
    80004e3c:	84aa                	mv	s1,a0
    80004e3e:	89ae                	mv	s3,a1
    80004e40:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004e42:	411c                	lw	a5,0(a0)
    80004e44:	4705                	li	a4,1
    80004e46:	04e78963          	beq	a5,a4,80004e98 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004e4a:	470d                	li	a4,3
    80004e4c:	04e78f63          	beq	a5,a4,80004eaa <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004e50:	4709                	li	a4,2
    80004e52:	08e79263          	bne	a5,a4,80004ed6 <fileread+0xae>
    ilock(f->ip);
    80004e56:	6d08                	ld	a0,24(a0)
    80004e58:	fffff097          	auipc	ra,0xfffff
    80004e5c:	fc2080e7          	jalr	-62(ra) # 80003e1a <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004e60:	874a                	mv	a4,s2
    80004e62:	5094                	lw	a3,32(s1)
    80004e64:	864e                	mv	a2,s3
    80004e66:	4585                	li	a1,1
    80004e68:	6c88                	ld	a0,24(s1)
    80004e6a:	fffff097          	auipc	ra,0xfffff
    80004e6e:	26c080e7          	jalr	620(ra) # 800040d6 <readi>
    80004e72:	892a                	mv	s2,a0
    80004e74:	00a05563          	blez	a0,80004e7e <fileread+0x56>
      f->off += r;
    80004e78:	509c                	lw	a5,32(s1)
    80004e7a:	9fa9                	addw	a5,a5,a0
    80004e7c:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004e7e:	6c88                	ld	a0,24(s1)
    80004e80:	fffff097          	auipc	ra,0xfffff
    80004e84:	060080e7          	jalr	96(ra) # 80003ee0 <iunlock>
    80004e88:	64e2                	ld	s1,24(sp)
    80004e8a:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004e8c:	854a                	mv	a0,s2
    80004e8e:	70a2                	ld	ra,40(sp)
    80004e90:	7402                	ld	s0,32(sp)
    80004e92:	6942                	ld	s2,16(sp)
    80004e94:	6145                	addi	sp,sp,48
    80004e96:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004e98:	6908                	ld	a0,16(a0)
    80004e9a:	00000097          	auipc	ra,0x0
    80004e9e:	41a080e7          	jalr	1050(ra) # 800052b4 <piperead>
    80004ea2:	892a                	mv	s2,a0
    80004ea4:	64e2                	ld	s1,24(sp)
    80004ea6:	69a2                	ld	s3,8(sp)
    80004ea8:	b7d5                	j	80004e8c <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004eaa:	02451783          	lh	a5,36(a0)
    80004eae:	03079693          	slli	a3,a5,0x30
    80004eb2:	92c1                	srli	a3,a3,0x30
    80004eb4:	4725                	li	a4,9
    80004eb6:	02d76a63          	bltu	a4,a3,80004eea <fileread+0xc2>
    80004eba:	0792                	slli	a5,a5,0x4
    80004ebc:	0045c717          	auipc	a4,0x45c
    80004ec0:	f1c70713          	addi	a4,a4,-228 # 80460dd8 <devsw>
    80004ec4:	97ba                	add	a5,a5,a4
    80004ec6:	639c                	ld	a5,0(a5)
    80004ec8:	c78d                	beqz	a5,80004ef2 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80004eca:	4505                	li	a0,1
    80004ecc:	9782                	jalr	a5
    80004ece:	892a                	mv	s2,a0
    80004ed0:	64e2                	ld	s1,24(sp)
    80004ed2:	69a2                	ld	s3,8(sp)
    80004ed4:	bf65                	j	80004e8c <fileread+0x64>
    panic("fileread");
    80004ed6:	00004517          	auipc	a0,0x4
    80004eda:	88250513          	addi	a0,a0,-1918 # 80008758 <etext+0x758>
    80004ede:	ffffb097          	auipc	ra,0xffffb
    80004ee2:	682080e7          	jalr	1666(ra) # 80000560 <panic>
    return -1;
    80004ee6:	597d                	li	s2,-1
    80004ee8:	b755                	j	80004e8c <fileread+0x64>
      return -1;
    80004eea:	597d                	li	s2,-1
    80004eec:	64e2                	ld	s1,24(sp)
    80004eee:	69a2                	ld	s3,8(sp)
    80004ef0:	bf71                	j	80004e8c <fileread+0x64>
    80004ef2:	597d                	li	s2,-1
    80004ef4:	64e2                	ld	s1,24(sp)
    80004ef6:	69a2                	ld	s3,8(sp)
    80004ef8:	bf51                	j	80004e8c <fileread+0x64>

0000000080004efa <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004efa:	00954783          	lbu	a5,9(a0)
    80004efe:	12078c63          	beqz	a5,80005036 <filewrite+0x13c>
{
    80004f02:	711d                	addi	sp,sp,-96
    80004f04:	ec86                	sd	ra,88(sp)
    80004f06:	e8a2                	sd	s0,80(sp)
    80004f08:	e0ca                	sd	s2,64(sp)
    80004f0a:	f456                	sd	s5,40(sp)
    80004f0c:	f05a                	sd	s6,32(sp)
    80004f0e:	1080                	addi	s0,sp,96
    80004f10:	892a                	mv	s2,a0
    80004f12:	8b2e                	mv	s6,a1
    80004f14:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80004f16:	411c                	lw	a5,0(a0)
    80004f18:	4705                	li	a4,1
    80004f1a:	02e78963          	beq	a5,a4,80004f4c <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004f1e:	470d                	li	a4,3
    80004f20:	02e78c63          	beq	a5,a4,80004f58 <filewrite+0x5e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004f24:	4709                	li	a4,2
    80004f26:	0ee79a63          	bne	a5,a4,8000501a <filewrite+0x120>
    80004f2a:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004f2c:	0cc05563          	blez	a2,80004ff6 <filewrite+0xfc>
    80004f30:	e4a6                	sd	s1,72(sp)
    80004f32:	fc4e                	sd	s3,56(sp)
    80004f34:	ec5e                	sd	s7,24(sp)
    80004f36:	e862                	sd	s8,16(sp)
    80004f38:	e466                	sd	s9,8(sp)
    int i = 0;
    80004f3a:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80004f3c:	6b85                	lui	s7,0x1
    80004f3e:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004f42:	6c85                	lui	s9,0x1
    80004f44:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004f48:	4c05                	li	s8,1
    80004f4a:	a849                	j	80004fdc <filewrite+0xe2>
    ret = pipewrite(f->pipe, addr, n);
    80004f4c:	6908                	ld	a0,16(a0)
    80004f4e:	00000097          	auipc	ra,0x0
    80004f52:	24a080e7          	jalr	586(ra) # 80005198 <pipewrite>
    80004f56:	a85d                	j	8000500c <filewrite+0x112>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004f58:	02451783          	lh	a5,36(a0)
    80004f5c:	03079693          	slli	a3,a5,0x30
    80004f60:	92c1                	srli	a3,a3,0x30
    80004f62:	4725                	li	a4,9
    80004f64:	0cd76b63          	bltu	a4,a3,8000503a <filewrite+0x140>
    80004f68:	0792                	slli	a5,a5,0x4
    80004f6a:	0045c717          	auipc	a4,0x45c
    80004f6e:	e6e70713          	addi	a4,a4,-402 # 80460dd8 <devsw>
    80004f72:	97ba                	add	a5,a5,a4
    80004f74:	679c                	ld	a5,8(a5)
    80004f76:	c7e1                	beqz	a5,8000503e <filewrite+0x144>
    ret = devsw[f->major].write(1, addr, n);
    80004f78:	4505                	li	a0,1
    80004f7a:	9782                	jalr	a5
    80004f7c:	a841                	j	8000500c <filewrite+0x112>
      if(n1 > max)
    80004f7e:	2981                	sext.w	s3,s3
      begin_op();
    80004f80:	00000097          	auipc	ra,0x0
    80004f84:	884080e7          	jalr	-1916(ra) # 80004804 <begin_op>
      ilock(f->ip);
    80004f88:	01893503          	ld	a0,24(s2)
    80004f8c:	fffff097          	auipc	ra,0xfffff
    80004f90:	e8e080e7          	jalr	-370(ra) # 80003e1a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004f94:	874e                	mv	a4,s3
    80004f96:	02092683          	lw	a3,32(s2)
    80004f9a:	016a0633          	add	a2,s4,s6
    80004f9e:	85e2                	mv	a1,s8
    80004fa0:	01893503          	ld	a0,24(s2)
    80004fa4:	fffff097          	auipc	ra,0xfffff
    80004fa8:	238080e7          	jalr	568(ra) # 800041dc <writei>
    80004fac:	84aa                	mv	s1,a0
    80004fae:	00a05763          	blez	a0,80004fbc <filewrite+0xc2>
        f->off += r;
    80004fb2:	02092783          	lw	a5,32(s2)
    80004fb6:	9fa9                	addw	a5,a5,a0
    80004fb8:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004fbc:	01893503          	ld	a0,24(s2)
    80004fc0:	fffff097          	auipc	ra,0xfffff
    80004fc4:	f20080e7          	jalr	-224(ra) # 80003ee0 <iunlock>
      end_op();
    80004fc8:	00000097          	auipc	ra,0x0
    80004fcc:	8b6080e7          	jalr	-1866(ra) # 8000487e <end_op>

      if(r != n1){
    80004fd0:	02999563          	bne	s3,s1,80004ffa <filewrite+0x100>
        // error from writei
        break;
      }
      i += r;
    80004fd4:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80004fd8:	015a5963          	bge	s4,s5,80004fea <filewrite+0xf0>
      int n1 = n - i;
    80004fdc:	414a87bb          	subw	a5,s5,s4
    80004fe0:	89be                	mv	s3,a5
      if(n1 > max)
    80004fe2:	f8fbdee3          	bge	s7,a5,80004f7e <filewrite+0x84>
    80004fe6:	89e6                	mv	s3,s9
    80004fe8:	bf59                	j	80004f7e <filewrite+0x84>
    80004fea:	64a6                	ld	s1,72(sp)
    80004fec:	79e2                	ld	s3,56(sp)
    80004fee:	6be2                	ld	s7,24(sp)
    80004ff0:	6c42                	ld	s8,16(sp)
    80004ff2:	6ca2                	ld	s9,8(sp)
    80004ff4:	a801                	j	80005004 <filewrite+0x10a>
    int i = 0;
    80004ff6:	4a01                	li	s4,0
    80004ff8:	a031                	j	80005004 <filewrite+0x10a>
    80004ffa:	64a6                	ld	s1,72(sp)
    80004ffc:	79e2                	ld	s3,56(sp)
    80004ffe:	6be2                	ld	s7,24(sp)
    80005000:	6c42                	ld	s8,16(sp)
    80005002:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80005004:	034a9f63          	bne	s5,s4,80005042 <filewrite+0x148>
    80005008:	8556                	mv	a0,s5
    8000500a:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000500c:	60e6                	ld	ra,88(sp)
    8000500e:	6446                	ld	s0,80(sp)
    80005010:	6906                	ld	s2,64(sp)
    80005012:	7aa2                	ld	s5,40(sp)
    80005014:	7b02                	ld	s6,32(sp)
    80005016:	6125                	addi	sp,sp,96
    80005018:	8082                	ret
    8000501a:	e4a6                	sd	s1,72(sp)
    8000501c:	fc4e                	sd	s3,56(sp)
    8000501e:	f852                	sd	s4,48(sp)
    80005020:	ec5e                	sd	s7,24(sp)
    80005022:	e862                	sd	s8,16(sp)
    80005024:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80005026:	00003517          	auipc	a0,0x3
    8000502a:	74250513          	addi	a0,a0,1858 # 80008768 <etext+0x768>
    8000502e:	ffffb097          	auipc	ra,0xffffb
    80005032:	532080e7          	jalr	1330(ra) # 80000560 <panic>
    return -1;
    80005036:	557d                	li	a0,-1
}
    80005038:	8082                	ret
      return -1;
    8000503a:	557d                	li	a0,-1
    8000503c:	bfc1                	j	8000500c <filewrite+0x112>
    8000503e:	557d                	li	a0,-1
    80005040:	b7f1                	j	8000500c <filewrite+0x112>
    ret = (i == n ? n : -1);
    80005042:	557d                	li	a0,-1
    80005044:	7a42                	ld	s4,48(sp)
    80005046:	b7d9                	j	8000500c <filewrite+0x112>

0000000080005048 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80005048:	7179                	addi	sp,sp,-48
    8000504a:	f406                	sd	ra,40(sp)
    8000504c:	f022                	sd	s0,32(sp)
    8000504e:	ec26                	sd	s1,24(sp)
    80005050:	e052                	sd	s4,0(sp)
    80005052:	1800                	addi	s0,sp,48
    80005054:	84aa                	mv	s1,a0
    80005056:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80005058:	0005b023          	sd	zero,0(a1)
    8000505c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80005060:	00000097          	auipc	ra,0x0
    80005064:	bb8080e7          	jalr	-1096(ra) # 80004c18 <filealloc>
    80005068:	e088                	sd	a0,0(s1)
    8000506a:	cd49                	beqz	a0,80005104 <pipealloc+0xbc>
    8000506c:	00000097          	auipc	ra,0x0
    80005070:	bac080e7          	jalr	-1108(ra) # 80004c18 <filealloc>
    80005074:	00aa3023          	sd	a0,0(s4)
    80005078:	c141                	beqz	a0,800050f8 <pipealloc+0xb0>
    8000507a:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000507c:	ffffc097          	auipc	ra,0xffffc
    80005080:	b86080e7          	jalr	-1146(ra) # 80000c02 <kalloc>
    80005084:	892a                	mv	s2,a0
    80005086:	c13d                	beqz	a0,800050ec <pipealloc+0xa4>
    80005088:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    8000508a:	4985                	li	s3,1
    8000508c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80005090:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80005094:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80005098:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000509c:	00003597          	auipc	a1,0x3
    800050a0:	6dc58593          	addi	a1,a1,1756 # 80008778 <etext+0x778>
    800050a4:	ffffc097          	auipc	ra,0xffffc
    800050a8:	c8e080e7          	jalr	-882(ra) # 80000d32 <initlock>
  (*f0)->type = FD_PIPE;
    800050ac:	609c                	ld	a5,0(s1)
    800050ae:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800050b2:	609c                	ld	a5,0(s1)
    800050b4:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800050b8:	609c                	ld	a5,0(s1)
    800050ba:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800050be:	609c                	ld	a5,0(s1)
    800050c0:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800050c4:	000a3783          	ld	a5,0(s4)
    800050c8:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800050cc:	000a3783          	ld	a5,0(s4)
    800050d0:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800050d4:	000a3783          	ld	a5,0(s4)
    800050d8:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800050dc:	000a3783          	ld	a5,0(s4)
    800050e0:	0127b823          	sd	s2,16(a5)
  return 0;
    800050e4:	4501                	li	a0,0
    800050e6:	6942                	ld	s2,16(sp)
    800050e8:	69a2                	ld	s3,8(sp)
    800050ea:	a03d                	j	80005118 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800050ec:	6088                	ld	a0,0(s1)
    800050ee:	c119                	beqz	a0,800050f4 <pipealloc+0xac>
    800050f0:	6942                	ld	s2,16(sp)
    800050f2:	a029                	j	800050fc <pipealloc+0xb4>
    800050f4:	6942                	ld	s2,16(sp)
    800050f6:	a039                	j	80005104 <pipealloc+0xbc>
    800050f8:	6088                	ld	a0,0(s1)
    800050fa:	c50d                	beqz	a0,80005124 <pipealloc+0xdc>
    fileclose(*f0);
    800050fc:	00000097          	auipc	ra,0x0
    80005100:	bd8080e7          	jalr	-1064(ra) # 80004cd4 <fileclose>
  if(*f1)
    80005104:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80005108:	557d                	li	a0,-1
  if(*f1)
    8000510a:	c799                	beqz	a5,80005118 <pipealloc+0xd0>
    fileclose(*f1);
    8000510c:	853e                	mv	a0,a5
    8000510e:	00000097          	auipc	ra,0x0
    80005112:	bc6080e7          	jalr	-1082(ra) # 80004cd4 <fileclose>
  return -1;
    80005116:	557d                	li	a0,-1
}
    80005118:	70a2                	ld	ra,40(sp)
    8000511a:	7402                	ld	s0,32(sp)
    8000511c:	64e2                	ld	s1,24(sp)
    8000511e:	6a02                	ld	s4,0(sp)
    80005120:	6145                	addi	sp,sp,48
    80005122:	8082                	ret
  return -1;
    80005124:	557d                	li	a0,-1
    80005126:	bfcd                	j	80005118 <pipealloc+0xd0>

0000000080005128 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80005128:	1101                	addi	sp,sp,-32
    8000512a:	ec06                	sd	ra,24(sp)
    8000512c:	e822                	sd	s0,16(sp)
    8000512e:	e426                	sd	s1,8(sp)
    80005130:	e04a                	sd	s2,0(sp)
    80005132:	1000                	addi	s0,sp,32
    80005134:	84aa                	mv	s1,a0
    80005136:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80005138:	ffffc097          	auipc	ra,0xffffc
    8000513c:	c8e080e7          	jalr	-882(ra) # 80000dc6 <acquire>
  if(writable){
    80005140:	02090d63          	beqz	s2,8000517a <pipeclose+0x52>
    pi->writeopen = 0;
    80005144:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80005148:	21848513          	addi	a0,s1,536
    8000514c:	ffffd097          	auipc	ra,0xffffd
    80005150:	3ea080e7          	jalr	1002(ra) # 80002536 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80005154:	2204b783          	ld	a5,544(s1)
    80005158:	eb95                	bnez	a5,8000518c <pipeclose+0x64>
    release(&pi->lock);
    8000515a:	8526                	mv	a0,s1
    8000515c:	ffffc097          	auipc	ra,0xffffc
    80005160:	d1a080e7          	jalr	-742(ra) # 80000e76 <release>
    kfree((char*)pi);
    80005164:	8526                	mv	a0,s1
    80005166:	ffffc097          	auipc	ra,0xffffc
    8000516a:	8f8080e7          	jalr	-1800(ra) # 80000a5e <kfree>
  } else
    release(&pi->lock);
}
    8000516e:	60e2                	ld	ra,24(sp)
    80005170:	6442                	ld	s0,16(sp)
    80005172:	64a2                	ld	s1,8(sp)
    80005174:	6902                	ld	s2,0(sp)
    80005176:	6105                	addi	sp,sp,32
    80005178:	8082                	ret
    pi->readopen = 0;
    8000517a:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000517e:	21c48513          	addi	a0,s1,540
    80005182:	ffffd097          	auipc	ra,0xffffd
    80005186:	3b4080e7          	jalr	948(ra) # 80002536 <wakeup>
    8000518a:	b7e9                	j	80005154 <pipeclose+0x2c>
    release(&pi->lock);
    8000518c:	8526                	mv	a0,s1
    8000518e:	ffffc097          	auipc	ra,0xffffc
    80005192:	ce8080e7          	jalr	-792(ra) # 80000e76 <release>
}
    80005196:	bfe1                	j	8000516e <pipeclose+0x46>

0000000080005198 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80005198:	7159                	addi	sp,sp,-112
    8000519a:	f486                	sd	ra,104(sp)
    8000519c:	f0a2                	sd	s0,96(sp)
    8000519e:	eca6                	sd	s1,88(sp)
    800051a0:	e8ca                	sd	s2,80(sp)
    800051a2:	e4ce                	sd	s3,72(sp)
    800051a4:	e0d2                	sd	s4,64(sp)
    800051a6:	fc56                	sd	s5,56(sp)
    800051a8:	1880                	addi	s0,sp,112
    800051aa:	84aa                	mv	s1,a0
    800051ac:	8aae                	mv	s5,a1
    800051ae:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800051b0:	ffffd097          	auipc	ra,0xffffd
    800051b4:	b6e080e7          	jalr	-1170(ra) # 80001d1e <myproc>
    800051b8:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800051ba:	8526                	mv	a0,s1
    800051bc:	ffffc097          	auipc	ra,0xffffc
    800051c0:	c0a080e7          	jalr	-1014(ra) # 80000dc6 <acquire>
  while(i < n){
    800051c4:	0f405063          	blez	s4,800052a4 <pipewrite+0x10c>
    800051c8:	f85a                	sd	s6,48(sp)
    800051ca:	f45e                	sd	s7,40(sp)
    800051cc:	f062                	sd	s8,32(sp)
    800051ce:	ec66                	sd	s9,24(sp)
    800051d0:	e86a                	sd	s10,16(sp)
  int i = 0;
    800051d2:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800051d4:	f9f40c13          	addi	s8,s0,-97
    800051d8:	4b85                	li	s7,1
    800051da:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800051dc:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800051e0:	21c48c93          	addi	s9,s1,540
    800051e4:	a099                	j	8000522a <pipewrite+0x92>
      release(&pi->lock);
    800051e6:	8526                	mv	a0,s1
    800051e8:	ffffc097          	auipc	ra,0xffffc
    800051ec:	c8e080e7          	jalr	-882(ra) # 80000e76 <release>
      return -1;
    800051f0:	597d                	li	s2,-1
    800051f2:	7b42                	ld	s6,48(sp)
    800051f4:	7ba2                	ld	s7,40(sp)
    800051f6:	7c02                	ld	s8,32(sp)
    800051f8:	6ce2                	ld	s9,24(sp)
    800051fa:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800051fc:	854a                	mv	a0,s2
    800051fe:	70a6                	ld	ra,104(sp)
    80005200:	7406                	ld	s0,96(sp)
    80005202:	64e6                	ld	s1,88(sp)
    80005204:	6946                	ld	s2,80(sp)
    80005206:	69a6                	ld	s3,72(sp)
    80005208:	6a06                	ld	s4,64(sp)
    8000520a:	7ae2                	ld	s5,56(sp)
    8000520c:	6165                	addi	sp,sp,112
    8000520e:	8082                	ret
      wakeup(&pi->nread);
    80005210:	856a                	mv	a0,s10
    80005212:	ffffd097          	auipc	ra,0xffffd
    80005216:	324080e7          	jalr	804(ra) # 80002536 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000521a:	85a6                	mv	a1,s1
    8000521c:	8566                	mv	a0,s9
    8000521e:	ffffd097          	auipc	ra,0xffffd
    80005222:	2b4080e7          	jalr	692(ra) # 800024d2 <sleep>
  while(i < n){
    80005226:	05495e63          	bge	s2,s4,80005282 <pipewrite+0xea>
    if(pi->readopen == 0 || killed(pr)){
    8000522a:	2204a783          	lw	a5,544(s1)
    8000522e:	dfc5                	beqz	a5,800051e6 <pipewrite+0x4e>
    80005230:	854e                	mv	a0,s3
    80005232:	ffffd097          	auipc	ra,0xffffd
    80005236:	548080e7          	jalr	1352(ra) # 8000277a <killed>
    8000523a:	f555                	bnez	a0,800051e6 <pipewrite+0x4e>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000523c:	2184a783          	lw	a5,536(s1)
    80005240:	21c4a703          	lw	a4,540(s1)
    80005244:	2007879b          	addiw	a5,a5,512
    80005248:	fcf704e3          	beq	a4,a5,80005210 <pipewrite+0x78>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000524c:	86de                	mv	a3,s7
    8000524e:	01590633          	add	a2,s2,s5
    80005252:	85e2                	mv	a1,s8
    80005254:	0509b503          	ld	a0,80(s3)
    80005258:	ffffc097          	auipc	ra,0xffffc
    8000525c:	6ca080e7          	jalr	1738(ra) # 80001922 <copyin>
    80005260:	05650463          	beq	a0,s6,800052a8 <pipewrite+0x110>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80005264:	21c4a783          	lw	a5,540(s1)
    80005268:	0017871b          	addiw	a4,a5,1
    8000526c:	20e4ae23          	sw	a4,540(s1)
    80005270:	1ff7f793          	andi	a5,a5,511
    80005274:	97a6                	add	a5,a5,s1
    80005276:	f9f44703          	lbu	a4,-97(s0)
    8000527a:	00e78c23          	sb	a4,24(a5)
      i++;
    8000527e:	2905                	addiw	s2,s2,1
    80005280:	b75d                	j	80005226 <pipewrite+0x8e>
    80005282:	7b42                	ld	s6,48(sp)
    80005284:	7ba2                	ld	s7,40(sp)
    80005286:	7c02                	ld	s8,32(sp)
    80005288:	6ce2                	ld	s9,24(sp)
    8000528a:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    8000528c:	21848513          	addi	a0,s1,536
    80005290:	ffffd097          	auipc	ra,0xffffd
    80005294:	2a6080e7          	jalr	678(ra) # 80002536 <wakeup>
  release(&pi->lock);
    80005298:	8526                	mv	a0,s1
    8000529a:	ffffc097          	auipc	ra,0xffffc
    8000529e:	bdc080e7          	jalr	-1060(ra) # 80000e76 <release>
  return i;
    800052a2:	bfa9                	j	800051fc <pipewrite+0x64>
  int i = 0;
    800052a4:	4901                	li	s2,0
    800052a6:	b7dd                	j	8000528c <pipewrite+0xf4>
    800052a8:	7b42                	ld	s6,48(sp)
    800052aa:	7ba2                	ld	s7,40(sp)
    800052ac:	7c02                	ld	s8,32(sp)
    800052ae:	6ce2                	ld	s9,24(sp)
    800052b0:	6d42                	ld	s10,16(sp)
    800052b2:	bfe9                	j	8000528c <pipewrite+0xf4>

00000000800052b4 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800052b4:	711d                	addi	sp,sp,-96
    800052b6:	ec86                	sd	ra,88(sp)
    800052b8:	e8a2                	sd	s0,80(sp)
    800052ba:	e4a6                	sd	s1,72(sp)
    800052bc:	e0ca                	sd	s2,64(sp)
    800052be:	fc4e                	sd	s3,56(sp)
    800052c0:	f852                	sd	s4,48(sp)
    800052c2:	f456                	sd	s5,40(sp)
    800052c4:	1080                	addi	s0,sp,96
    800052c6:	84aa                	mv	s1,a0
    800052c8:	892e                	mv	s2,a1
    800052ca:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800052cc:	ffffd097          	auipc	ra,0xffffd
    800052d0:	a52080e7          	jalr	-1454(ra) # 80001d1e <myproc>
    800052d4:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800052d6:	8526                	mv	a0,s1
    800052d8:	ffffc097          	auipc	ra,0xffffc
    800052dc:	aee080e7          	jalr	-1298(ra) # 80000dc6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800052e0:	2184a703          	lw	a4,536(s1)
    800052e4:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800052e8:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800052ec:	02f71b63          	bne	a4,a5,80005322 <piperead+0x6e>
    800052f0:	2244a783          	lw	a5,548(s1)
    800052f4:	c3b1                	beqz	a5,80005338 <piperead+0x84>
    if(killed(pr)){
    800052f6:	8552                	mv	a0,s4
    800052f8:	ffffd097          	auipc	ra,0xffffd
    800052fc:	482080e7          	jalr	1154(ra) # 8000277a <killed>
    80005300:	e50d                	bnez	a0,8000532a <piperead+0x76>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005302:	85a6                	mv	a1,s1
    80005304:	854e                	mv	a0,s3
    80005306:	ffffd097          	auipc	ra,0xffffd
    8000530a:	1cc080e7          	jalr	460(ra) # 800024d2 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000530e:	2184a703          	lw	a4,536(s1)
    80005312:	21c4a783          	lw	a5,540(s1)
    80005316:	fcf70de3          	beq	a4,a5,800052f0 <piperead+0x3c>
    8000531a:	f05a                	sd	s6,32(sp)
    8000531c:	ec5e                	sd	s7,24(sp)
    8000531e:	e862                	sd	s8,16(sp)
    80005320:	a839                	j	8000533e <piperead+0x8a>
    80005322:	f05a                	sd	s6,32(sp)
    80005324:	ec5e                	sd	s7,24(sp)
    80005326:	e862                	sd	s8,16(sp)
    80005328:	a819                	j	8000533e <piperead+0x8a>
      release(&pi->lock);
    8000532a:	8526                	mv	a0,s1
    8000532c:	ffffc097          	auipc	ra,0xffffc
    80005330:	b4a080e7          	jalr	-1206(ra) # 80000e76 <release>
      return -1;
    80005334:	59fd                	li	s3,-1
    80005336:	a895                	j	800053aa <piperead+0xf6>
    80005338:	f05a                	sd	s6,32(sp)
    8000533a:	ec5e                	sd	s7,24(sp)
    8000533c:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000533e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005340:	faf40c13          	addi	s8,s0,-81
    80005344:	4b85                	li	s7,1
    80005346:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005348:	05505363          	blez	s5,8000538e <piperead+0xda>
    if(pi->nread == pi->nwrite)
    8000534c:	2184a783          	lw	a5,536(s1)
    80005350:	21c4a703          	lw	a4,540(s1)
    80005354:	02f70d63          	beq	a4,a5,8000538e <piperead+0xda>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80005358:	0017871b          	addiw	a4,a5,1
    8000535c:	20e4ac23          	sw	a4,536(s1)
    80005360:	1ff7f793          	andi	a5,a5,511
    80005364:	97a6                	add	a5,a5,s1
    80005366:	0187c783          	lbu	a5,24(a5)
    8000536a:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000536e:	86de                	mv	a3,s7
    80005370:	8662                	mv	a2,s8
    80005372:	85ca                	mv	a1,s2
    80005374:	050a3503          	ld	a0,80(s4)
    80005378:	ffffc097          	auipc	ra,0xffffc
    8000537c:	51e080e7          	jalr	1310(ra) # 80001896 <copyout>
    80005380:	01650763          	beq	a0,s6,8000538e <piperead+0xda>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005384:	2985                	addiw	s3,s3,1
    80005386:	0905                	addi	s2,s2,1
    80005388:	fd3a92e3          	bne	s5,s3,8000534c <piperead+0x98>
    8000538c:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000538e:	21c48513          	addi	a0,s1,540
    80005392:	ffffd097          	auipc	ra,0xffffd
    80005396:	1a4080e7          	jalr	420(ra) # 80002536 <wakeup>
  release(&pi->lock);
    8000539a:	8526                	mv	a0,s1
    8000539c:	ffffc097          	auipc	ra,0xffffc
    800053a0:	ada080e7          	jalr	-1318(ra) # 80000e76 <release>
    800053a4:	7b02                	ld	s6,32(sp)
    800053a6:	6be2                	ld	s7,24(sp)
    800053a8:	6c42                	ld	s8,16(sp)
  return i;
}
    800053aa:	854e                	mv	a0,s3
    800053ac:	60e6                	ld	ra,88(sp)
    800053ae:	6446                	ld	s0,80(sp)
    800053b0:	64a6                	ld	s1,72(sp)
    800053b2:	6906                	ld	s2,64(sp)
    800053b4:	79e2                	ld	s3,56(sp)
    800053b6:	7a42                	ld	s4,48(sp)
    800053b8:	7aa2                	ld	s5,40(sp)
    800053ba:	6125                	addi	sp,sp,96
    800053bc:	8082                	ret

00000000800053be <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800053be:	1141                	addi	sp,sp,-16
    800053c0:	e406                	sd	ra,8(sp)
    800053c2:	e022                	sd	s0,0(sp)
    800053c4:	0800                	addi	s0,sp,16
    800053c6:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800053c8:	0035151b          	slliw	a0,a0,0x3
    800053cc:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    800053ce:	8b89                	andi	a5,a5,2
    800053d0:	c399                	beqz	a5,800053d6 <flags2perm+0x18>
      perm |= PTE_W;
    800053d2:	00456513          	ori	a0,a0,4
    return perm;
}
    800053d6:	60a2                	ld	ra,8(sp)
    800053d8:	6402                	ld	s0,0(sp)
    800053da:	0141                	addi	sp,sp,16
    800053dc:	8082                	ret

00000000800053de <exec>:

int
exec(char *path, char **argv)
{
    800053de:	de010113          	addi	sp,sp,-544
    800053e2:	20113c23          	sd	ra,536(sp)
    800053e6:	20813823          	sd	s0,528(sp)
    800053ea:	20913423          	sd	s1,520(sp)
    800053ee:	21213023          	sd	s2,512(sp)
    800053f2:	1400                	addi	s0,sp,544
    800053f4:	892a                	mv	s2,a0
    800053f6:	dea43823          	sd	a0,-528(s0)
    800053fa:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800053fe:	ffffd097          	auipc	ra,0xffffd
    80005402:	920080e7          	jalr	-1760(ra) # 80001d1e <myproc>
    80005406:	84aa                	mv	s1,a0

  begin_op();
    80005408:	fffff097          	auipc	ra,0xfffff
    8000540c:	3fc080e7          	jalr	1020(ra) # 80004804 <begin_op>

  if((ip = namei(path)) == 0){
    80005410:	854a                	mv	a0,s2
    80005412:	fffff097          	auipc	ra,0xfffff
    80005416:	1ec080e7          	jalr	492(ra) # 800045fe <namei>
    8000541a:	c525                	beqz	a0,80005482 <exec+0xa4>
    8000541c:	fbd2                	sd	s4,496(sp)
    8000541e:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80005420:	fffff097          	auipc	ra,0xfffff
    80005424:	9fa080e7          	jalr	-1542(ra) # 80003e1a <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80005428:	04000713          	li	a4,64
    8000542c:	4681                	li	a3,0
    8000542e:	e5040613          	addi	a2,s0,-432
    80005432:	4581                	li	a1,0
    80005434:	8552                	mv	a0,s4
    80005436:	fffff097          	auipc	ra,0xfffff
    8000543a:	ca0080e7          	jalr	-864(ra) # 800040d6 <readi>
    8000543e:	04000793          	li	a5,64
    80005442:	00f51a63          	bne	a0,a5,80005456 <exec+0x78>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80005446:	e5042703          	lw	a4,-432(s0)
    8000544a:	464c47b7          	lui	a5,0x464c4
    8000544e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005452:	02f70e63          	beq	a4,a5,8000548e <exec+0xb0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80005456:	8552                	mv	a0,s4
    80005458:	fffff097          	auipc	ra,0xfffff
    8000545c:	c28080e7          	jalr	-984(ra) # 80004080 <iunlockput>
    end_op();
    80005460:	fffff097          	auipc	ra,0xfffff
    80005464:	41e080e7          	jalr	1054(ra) # 8000487e <end_op>
  }
  return -1;
    80005468:	557d                	li	a0,-1
    8000546a:	7a5e                	ld	s4,496(sp)
}
    8000546c:	21813083          	ld	ra,536(sp)
    80005470:	21013403          	ld	s0,528(sp)
    80005474:	20813483          	ld	s1,520(sp)
    80005478:	20013903          	ld	s2,512(sp)
    8000547c:	22010113          	addi	sp,sp,544
    80005480:	8082                	ret
    end_op();
    80005482:	fffff097          	auipc	ra,0xfffff
    80005486:	3fc080e7          	jalr	1020(ra) # 8000487e <end_op>
    return -1;
    8000548a:	557d                	li	a0,-1
    8000548c:	b7c5                	j	8000546c <exec+0x8e>
    8000548e:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80005490:	8526                	mv	a0,s1
    80005492:	ffffd097          	auipc	ra,0xffffd
    80005496:	950080e7          	jalr	-1712(ra) # 80001de2 <proc_pagetable>
    8000549a:	8b2a                	mv	s6,a0
    8000549c:	2c050163          	beqz	a0,8000575e <exec+0x380>
    800054a0:	ffce                	sd	s3,504(sp)
    800054a2:	f7d6                	sd	s5,488(sp)
    800054a4:	efde                	sd	s7,472(sp)
    800054a6:	ebe2                	sd	s8,464(sp)
    800054a8:	e7e6                	sd	s9,456(sp)
    800054aa:	e3ea                	sd	s10,448(sp)
    800054ac:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800054ae:	e7042683          	lw	a3,-400(s0)
    800054b2:	e8845783          	lhu	a5,-376(s0)
    800054b6:	10078363          	beqz	a5,800055bc <exec+0x1de>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800054ba:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800054bc:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800054be:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    800054c2:	6c85                	lui	s9,0x1
    800054c4:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800054c8:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800054cc:	6a85                	lui	s5,0x1
    800054ce:	a0b5                	j	8000553a <exec+0x15c>
      panic("loadseg: address should exist");
    800054d0:	00003517          	auipc	a0,0x3
    800054d4:	2b050513          	addi	a0,a0,688 # 80008780 <etext+0x780>
    800054d8:	ffffb097          	auipc	ra,0xffffb
    800054dc:	088080e7          	jalr	136(ra) # 80000560 <panic>
    if(sz - i < PGSIZE)
    800054e0:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800054e2:	874a                	mv	a4,s2
    800054e4:	009c06bb          	addw	a3,s8,s1
    800054e8:	4581                	li	a1,0
    800054ea:	8552                	mv	a0,s4
    800054ec:	fffff097          	auipc	ra,0xfffff
    800054f0:	bea080e7          	jalr	-1046(ra) # 800040d6 <readi>
    800054f4:	26a91963          	bne	s2,a0,80005766 <exec+0x388>
  for(i = 0; i < sz; i += PGSIZE){
    800054f8:	009a84bb          	addw	s1,s5,s1
    800054fc:	0334f463          	bgeu	s1,s3,80005524 <exec+0x146>
    pa = walkaddr(pagetable, va + i);
    80005500:	02049593          	slli	a1,s1,0x20
    80005504:	9181                	srli	a1,a1,0x20
    80005506:	95de                	add	a1,a1,s7
    80005508:	855a                	mv	a0,s6
    8000550a:	ffffc097          	auipc	ra,0xffffc
    8000550e:	d56080e7          	jalr	-682(ra) # 80001260 <walkaddr>
    80005512:	862a                	mv	a2,a0
    if(pa == 0)
    80005514:	dd55                	beqz	a0,800054d0 <exec+0xf2>
    if(sz - i < PGSIZE)
    80005516:	409987bb          	subw	a5,s3,s1
    8000551a:	893e                	mv	s2,a5
    8000551c:	fcfcf2e3          	bgeu	s9,a5,800054e0 <exec+0x102>
    80005520:	8956                	mv	s2,s5
    80005522:	bf7d                	j	800054e0 <exec+0x102>
    sz = sz1;
    80005524:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005528:	2d05                	addiw	s10,s10,1
    8000552a:	e0843783          	ld	a5,-504(s0)
    8000552e:	0387869b          	addiw	a3,a5,56
    80005532:	e8845783          	lhu	a5,-376(s0)
    80005536:	08fd5463          	bge	s10,a5,800055be <exec+0x1e0>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000553a:	e0d43423          	sd	a3,-504(s0)
    8000553e:	876e                	mv	a4,s11
    80005540:	e1840613          	addi	a2,s0,-488
    80005544:	4581                	li	a1,0
    80005546:	8552                	mv	a0,s4
    80005548:	fffff097          	auipc	ra,0xfffff
    8000554c:	b8e080e7          	jalr	-1138(ra) # 800040d6 <readi>
    80005550:	21b51963          	bne	a0,s11,80005762 <exec+0x384>
    if(ph.type != ELF_PROG_LOAD)
    80005554:	e1842783          	lw	a5,-488(s0)
    80005558:	4705                	li	a4,1
    8000555a:	fce797e3          	bne	a5,a4,80005528 <exec+0x14a>
    if(ph.memsz < ph.filesz)
    8000555e:	e4043483          	ld	s1,-448(s0)
    80005562:	e3843783          	ld	a5,-456(s0)
    80005566:	22f4e063          	bltu	s1,a5,80005786 <exec+0x3a8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000556a:	e2843783          	ld	a5,-472(s0)
    8000556e:	94be                	add	s1,s1,a5
    80005570:	20f4ee63          	bltu	s1,a5,8000578c <exec+0x3ae>
    if(ph.vaddr % PGSIZE != 0)
    80005574:	de843703          	ld	a4,-536(s0)
    80005578:	8ff9                	and	a5,a5,a4
    8000557a:	20079c63          	bnez	a5,80005792 <exec+0x3b4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000557e:	e1c42503          	lw	a0,-484(s0)
    80005582:	00000097          	auipc	ra,0x0
    80005586:	e3c080e7          	jalr	-452(ra) # 800053be <flags2perm>
    8000558a:	86aa                	mv	a3,a0
    8000558c:	8626                	mv	a2,s1
    8000558e:	85ca                	mv	a1,s2
    80005590:	855a                	mv	a0,s6
    80005592:	ffffc097          	auipc	ra,0xffffc
    80005596:	092080e7          	jalr	146(ra) # 80001624 <uvmalloc>
    8000559a:	dea43c23          	sd	a0,-520(s0)
    8000559e:	1e050d63          	beqz	a0,80005798 <exec+0x3ba>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800055a2:	e2843b83          	ld	s7,-472(s0)
    800055a6:	e2042c03          	lw	s8,-480(s0)
    800055aa:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800055ae:	00098463          	beqz	s3,800055b6 <exec+0x1d8>
    800055b2:	4481                	li	s1,0
    800055b4:	b7b1                	j	80005500 <exec+0x122>
    sz = sz1;
    800055b6:	df843903          	ld	s2,-520(s0)
    800055ba:	b7bd                	j	80005528 <exec+0x14a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800055bc:	4901                	li	s2,0
  iunlockput(ip);
    800055be:	8552                	mv	a0,s4
    800055c0:	fffff097          	auipc	ra,0xfffff
    800055c4:	ac0080e7          	jalr	-1344(ra) # 80004080 <iunlockput>
  end_op();
    800055c8:	fffff097          	auipc	ra,0xfffff
    800055cc:	2b6080e7          	jalr	694(ra) # 8000487e <end_op>
  p = myproc();
    800055d0:	ffffc097          	auipc	ra,0xffffc
    800055d4:	74e080e7          	jalr	1870(ra) # 80001d1e <myproc>
    800055d8:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800055da:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800055de:	6985                	lui	s3,0x1
    800055e0:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800055e2:	99ca                	add	s3,s3,s2
    800055e4:	77fd                	lui	a5,0xfffff
    800055e6:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800055ea:	4691                	li	a3,4
    800055ec:	6609                	lui	a2,0x2
    800055ee:	964e                	add	a2,a2,s3
    800055f0:	85ce                	mv	a1,s3
    800055f2:	855a                	mv	a0,s6
    800055f4:	ffffc097          	auipc	ra,0xffffc
    800055f8:	030080e7          	jalr	48(ra) # 80001624 <uvmalloc>
    800055fc:	8a2a                	mv	s4,a0
    800055fe:	e115                	bnez	a0,80005622 <exec+0x244>
    proc_freepagetable(pagetable, sz);
    80005600:	85ce                	mv	a1,s3
    80005602:	855a                	mv	a0,s6
    80005604:	ffffd097          	auipc	ra,0xffffd
    80005608:	87a080e7          	jalr	-1926(ra) # 80001e7e <proc_freepagetable>
  return -1;
    8000560c:	557d                	li	a0,-1
    8000560e:	79fe                	ld	s3,504(sp)
    80005610:	7a5e                	ld	s4,496(sp)
    80005612:	7abe                	ld	s5,488(sp)
    80005614:	7b1e                	ld	s6,480(sp)
    80005616:	6bfe                	ld	s7,472(sp)
    80005618:	6c5e                	ld	s8,464(sp)
    8000561a:	6cbe                	ld	s9,456(sp)
    8000561c:	6d1e                	ld	s10,448(sp)
    8000561e:	7dfa                	ld	s11,440(sp)
    80005620:	b5b1                	j	8000546c <exec+0x8e>
  uvmclear(pagetable, sz-2*PGSIZE);
    80005622:	75f9                	lui	a1,0xffffe
    80005624:	95aa                	add	a1,a1,a0
    80005626:	855a                	mv	a0,s6
    80005628:	ffffc097          	auipc	ra,0xffffc
    8000562c:	23c080e7          	jalr	572(ra) # 80001864 <uvmclear>
  stackbase = sp - PGSIZE;
    80005630:	7bfd                	lui	s7,0xfffff
    80005632:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    80005634:	e0043783          	ld	a5,-512(s0)
    80005638:	6388                	ld	a0,0(a5)
  sp = sz;
    8000563a:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    8000563c:	4481                	li	s1,0
    ustack[argc] = sp;
    8000563e:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80005642:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80005646:	c135                	beqz	a0,800056aa <exec+0x2cc>
    sp -= strlen(argv[argc]) + 1;
    80005648:	ffffc097          	auipc	ra,0xffffc
    8000564c:	a02080e7          	jalr	-1534(ra) # 8000104a <strlen>
    80005650:	0015079b          	addiw	a5,a0,1
    80005654:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005658:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000565c:	15796163          	bltu	s2,s7,8000579e <exec+0x3c0>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005660:	e0043d83          	ld	s11,-512(s0)
    80005664:	000db983          	ld	s3,0(s11)
    80005668:	854e                	mv	a0,s3
    8000566a:	ffffc097          	auipc	ra,0xffffc
    8000566e:	9e0080e7          	jalr	-1568(ra) # 8000104a <strlen>
    80005672:	0015069b          	addiw	a3,a0,1
    80005676:	864e                	mv	a2,s3
    80005678:	85ca                	mv	a1,s2
    8000567a:	855a                	mv	a0,s6
    8000567c:	ffffc097          	auipc	ra,0xffffc
    80005680:	21a080e7          	jalr	538(ra) # 80001896 <copyout>
    80005684:	10054f63          	bltz	a0,800057a2 <exec+0x3c4>
    ustack[argc] = sp;
    80005688:	00349793          	slli	a5,s1,0x3
    8000568c:	97e6                	add	a5,a5,s9
    8000568e:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7fb9d090>
  for(argc = 0; argv[argc]; argc++) {
    80005692:	0485                	addi	s1,s1,1
    80005694:	008d8793          	addi	a5,s11,8
    80005698:	e0f43023          	sd	a5,-512(s0)
    8000569c:	008db503          	ld	a0,8(s11)
    800056a0:	c509                	beqz	a0,800056aa <exec+0x2cc>
    if(argc >= MAXARG)
    800056a2:	fb8493e3          	bne	s1,s8,80005648 <exec+0x26a>
  sz = sz1;
    800056a6:	89d2                	mv	s3,s4
    800056a8:	bfa1                	j	80005600 <exec+0x222>
  ustack[argc] = 0;
    800056aa:	00349793          	slli	a5,s1,0x3
    800056ae:	f9078793          	addi	a5,a5,-112
    800056b2:	97a2                	add	a5,a5,s0
    800056b4:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800056b8:	00148693          	addi	a3,s1,1
    800056bc:	068e                	slli	a3,a3,0x3
    800056be:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800056c2:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    800056c6:	89d2                	mv	s3,s4
  if(sp < stackbase)
    800056c8:	f3796ce3          	bltu	s2,s7,80005600 <exec+0x222>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800056cc:	e9040613          	addi	a2,s0,-368
    800056d0:	85ca                	mv	a1,s2
    800056d2:	855a                	mv	a0,s6
    800056d4:	ffffc097          	auipc	ra,0xffffc
    800056d8:	1c2080e7          	jalr	450(ra) # 80001896 <copyout>
    800056dc:	f20542e3          	bltz	a0,80005600 <exec+0x222>
  p->trapframe->a1 = sp;
    800056e0:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800056e4:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800056e8:	df043783          	ld	a5,-528(s0)
    800056ec:	0007c703          	lbu	a4,0(a5)
    800056f0:	cf11                	beqz	a4,8000570c <exec+0x32e>
    800056f2:	0785                	addi	a5,a5,1
    if(*s == '/')
    800056f4:	02f00693          	li	a3,47
    800056f8:	a029                	j	80005702 <exec+0x324>
  for(last=s=path; *s; s++)
    800056fa:	0785                	addi	a5,a5,1
    800056fc:	fff7c703          	lbu	a4,-1(a5)
    80005700:	c711                	beqz	a4,8000570c <exec+0x32e>
    if(*s == '/')
    80005702:	fed71ce3          	bne	a4,a3,800056fa <exec+0x31c>
      last = s+1;
    80005706:	def43823          	sd	a5,-528(s0)
    8000570a:	bfc5                	j	800056fa <exec+0x31c>
  safestrcpy(p->name, last, sizeof(p->name));
    8000570c:	4641                	li	a2,16
    8000570e:	df043583          	ld	a1,-528(s0)
    80005712:	158a8513          	addi	a0,s5,344
    80005716:	ffffc097          	auipc	ra,0xffffc
    8000571a:	8fe080e7          	jalr	-1794(ra) # 80001014 <safestrcpy>
  oldpagetable = p->pagetable;
    8000571e:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80005722:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80005726:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000572a:	058ab783          	ld	a5,88(s5)
    8000572e:	e6843703          	ld	a4,-408(s0)
    80005732:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80005734:	058ab783          	ld	a5,88(s5)
    80005738:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000573c:	85ea                	mv	a1,s10
    8000573e:	ffffc097          	auipc	ra,0xffffc
    80005742:	740080e7          	jalr	1856(ra) # 80001e7e <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005746:	0004851b          	sext.w	a0,s1
    8000574a:	79fe                	ld	s3,504(sp)
    8000574c:	7a5e                	ld	s4,496(sp)
    8000574e:	7abe                	ld	s5,488(sp)
    80005750:	7b1e                	ld	s6,480(sp)
    80005752:	6bfe                	ld	s7,472(sp)
    80005754:	6c5e                	ld	s8,464(sp)
    80005756:	6cbe                	ld	s9,456(sp)
    80005758:	6d1e                	ld	s10,448(sp)
    8000575a:	7dfa                	ld	s11,440(sp)
    8000575c:	bb01                	j	8000546c <exec+0x8e>
    8000575e:	7b1e                	ld	s6,480(sp)
    80005760:	b9dd                	j	80005456 <exec+0x78>
    80005762:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80005766:	df843583          	ld	a1,-520(s0)
    8000576a:	855a                	mv	a0,s6
    8000576c:	ffffc097          	auipc	ra,0xffffc
    80005770:	712080e7          	jalr	1810(ra) # 80001e7e <proc_freepagetable>
  if(ip){
    80005774:	79fe                	ld	s3,504(sp)
    80005776:	7abe                	ld	s5,488(sp)
    80005778:	7b1e                	ld	s6,480(sp)
    8000577a:	6bfe                	ld	s7,472(sp)
    8000577c:	6c5e                	ld	s8,464(sp)
    8000577e:	6cbe                	ld	s9,456(sp)
    80005780:	6d1e                	ld	s10,448(sp)
    80005782:	7dfa                	ld	s11,440(sp)
    80005784:	b9c9                	j	80005456 <exec+0x78>
    80005786:	df243c23          	sd	s2,-520(s0)
    8000578a:	bff1                	j	80005766 <exec+0x388>
    8000578c:	df243c23          	sd	s2,-520(s0)
    80005790:	bfd9                	j	80005766 <exec+0x388>
    80005792:	df243c23          	sd	s2,-520(s0)
    80005796:	bfc1                	j	80005766 <exec+0x388>
    80005798:	df243c23          	sd	s2,-520(s0)
    8000579c:	b7e9                	j	80005766 <exec+0x388>
  sz = sz1;
    8000579e:	89d2                	mv	s3,s4
    800057a0:	b585                	j	80005600 <exec+0x222>
    800057a2:	89d2                	mv	s3,s4
    800057a4:	bdb1                	j	80005600 <exec+0x222>

00000000800057a6 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800057a6:	7179                	addi	sp,sp,-48
    800057a8:	f406                	sd	ra,40(sp)
    800057aa:	f022                	sd	s0,32(sp)
    800057ac:	ec26                	sd	s1,24(sp)
    800057ae:	e84a                	sd	s2,16(sp)
    800057b0:	1800                	addi	s0,sp,48
    800057b2:	892e                	mv	s2,a1
    800057b4:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800057b6:	fdc40593          	addi	a1,s0,-36
    800057ba:	ffffe097          	auipc	ra,0xffffe
    800057be:	9a2080e7          	jalr	-1630(ra) # 8000315c <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800057c2:	fdc42703          	lw	a4,-36(s0)
    800057c6:	47bd                	li	a5,15
    800057c8:	02e7eb63          	bltu	a5,a4,800057fe <argfd+0x58>
    800057cc:	ffffc097          	auipc	ra,0xffffc
    800057d0:	552080e7          	jalr	1362(ra) # 80001d1e <myproc>
    800057d4:	fdc42703          	lw	a4,-36(s0)
    800057d8:	01a70793          	addi	a5,a4,26
    800057dc:	078e                	slli	a5,a5,0x3
    800057de:	953e                	add	a0,a0,a5
    800057e0:	611c                	ld	a5,0(a0)
    800057e2:	c385                	beqz	a5,80005802 <argfd+0x5c>
    return -1;
  if(pfd)
    800057e4:	00090463          	beqz	s2,800057ec <argfd+0x46>
    *pfd = fd;
    800057e8:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800057ec:	4501                	li	a0,0
  if(pf)
    800057ee:	c091                	beqz	s1,800057f2 <argfd+0x4c>
    *pf = f;
    800057f0:	e09c                	sd	a5,0(s1)
}
    800057f2:	70a2                	ld	ra,40(sp)
    800057f4:	7402                	ld	s0,32(sp)
    800057f6:	64e2                	ld	s1,24(sp)
    800057f8:	6942                	ld	s2,16(sp)
    800057fa:	6145                	addi	sp,sp,48
    800057fc:	8082                	ret
    return -1;
    800057fe:	557d                	li	a0,-1
    80005800:	bfcd                	j	800057f2 <argfd+0x4c>
    80005802:	557d                	li	a0,-1
    80005804:	b7fd                	j	800057f2 <argfd+0x4c>

0000000080005806 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005806:	1101                	addi	sp,sp,-32
    80005808:	ec06                	sd	ra,24(sp)
    8000580a:	e822                	sd	s0,16(sp)
    8000580c:	e426                	sd	s1,8(sp)
    8000580e:	1000                	addi	s0,sp,32
    80005810:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005812:	ffffc097          	auipc	ra,0xffffc
    80005816:	50c080e7          	jalr	1292(ra) # 80001d1e <myproc>
    8000581a:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000581c:	0d050793          	addi	a5,a0,208
    80005820:	4501                	li	a0,0
    80005822:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005824:	6398                	ld	a4,0(a5)
    80005826:	cb19                	beqz	a4,8000583c <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005828:	2505                	addiw	a0,a0,1
    8000582a:	07a1                	addi	a5,a5,8
    8000582c:	fed51ce3          	bne	a0,a3,80005824 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005830:	557d                	li	a0,-1
}
    80005832:	60e2                	ld	ra,24(sp)
    80005834:	6442                	ld	s0,16(sp)
    80005836:	64a2                	ld	s1,8(sp)
    80005838:	6105                	addi	sp,sp,32
    8000583a:	8082                	ret
      p->ofile[fd] = f;
    8000583c:	01a50793          	addi	a5,a0,26
    80005840:	078e                	slli	a5,a5,0x3
    80005842:	963e                	add	a2,a2,a5
    80005844:	e204                	sd	s1,0(a2)
      return fd;
    80005846:	b7f5                	j	80005832 <fdalloc+0x2c>

0000000080005848 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005848:	715d                	addi	sp,sp,-80
    8000584a:	e486                	sd	ra,72(sp)
    8000584c:	e0a2                	sd	s0,64(sp)
    8000584e:	fc26                	sd	s1,56(sp)
    80005850:	f84a                	sd	s2,48(sp)
    80005852:	f44e                	sd	s3,40(sp)
    80005854:	ec56                	sd	s5,24(sp)
    80005856:	e85a                	sd	s6,16(sp)
    80005858:	0880                	addi	s0,sp,80
    8000585a:	8b2e                	mv	s6,a1
    8000585c:	89b2                	mv	s3,a2
    8000585e:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005860:	fb040593          	addi	a1,s0,-80
    80005864:	fffff097          	auipc	ra,0xfffff
    80005868:	db8080e7          	jalr	-584(ra) # 8000461c <nameiparent>
    8000586c:	84aa                	mv	s1,a0
    8000586e:	14050e63          	beqz	a0,800059ca <create+0x182>
    return 0;

  ilock(dp);
    80005872:	ffffe097          	auipc	ra,0xffffe
    80005876:	5a8080e7          	jalr	1448(ra) # 80003e1a <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000587a:	4601                	li	a2,0
    8000587c:	fb040593          	addi	a1,s0,-80
    80005880:	8526                	mv	a0,s1
    80005882:	fffff097          	auipc	ra,0xfffff
    80005886:	a94080e7          	jalr	-1388(ra) # 80004316 <dirlookup>
    8000588a:	8aaa                	mv	s5,a0
    8000588c:	c539                	beqz	a0,800058da <create+0x92>
    iunlockput(dp);
    8000588e:	8526                	mv	a0,s1
    80005890:	ffffe097          	auipc	ra,0xffffe
    80005894:	7f0080e7          	jalr	2032(ra) # 80004080 <iunlockput>
    ilock(ip);
    80005898:	8556                	mv	a0,s5
    8000589a:	ffffe097          	auipc	ra,0xffffe
    8000589e:	580080e7          	jalr	1408(ra) # 80003e1a <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800058a2:	4789                	li	a5,2
    800058a4:	02fb1463          	bne	s6,a5,800058cc <create+0x84>
    800058a8:	044ad783          	lhu	a5,68(s5)
    800058ac:	37f9                	addiw	a5,a5,-2
    800058ae:	17c2                	slli	a5,a5,0x30
    800058b0:	93c1                	srli	a5,a5,0x30
    800058b2:	4705                	li	a4,1
    800058b4:	00f76c63          	bltu	a4,a5,800058cc <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800058b8:	8556                	mv	a0,s5
    800058ba:	60a6                	ld	ra,72(sp)
    800058bc:	6406                	ld	s0,64(sp)
    800058be:	74e2                	ld	s1,56(sp)
    800058c0:	7942                	ld	s2,48(sp)
    800058c2:	79a2                	ld	s3,40(sp)
    800058c4:	6ae2                	ld	s5,24(sp)
    800058c6:	6b42                	ld	s6,16(sp)
    800058c8:	6161                	addi	sp,sp,80
    800058ca:	8082                	ret
    iunlockput(ip);
    800058cc:	8556                	mv	a0,s5
    800058ce:	ffffe097          	auipc	ra,0xffffe
    800058d2:	7b2080e7          	jalr	1970(ra) # 80004080 <iunlockput>
    return 0;
    800058d6:	4a81                	li	s5,0
    800058d8:	b7c5                	j	800058b8 <create+0x70>
    800058da:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    800058dc:	85da                	mv	a1,s6
    800058de:	4088                	lw	a0,0(s1)
    800058e0:	ffffe097          	auipc	ra,0xffffe
    800058e4:	396080e7          	jalr	918(ra) # 80003c76 <ialloc>
    800058e8:	8a2a                	mv	s4,a0
    800058ea:	c531                	beqz	a0,80005936 <create+0xee>
  ilock(ip);
    800058ec:	ffffe097          	auipc	ra,0xffffe
    800058f0:	52e080e7          	jalr	1326(ra) # 80003e1a <ilock>
  ip->major = major;
    800058f4:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800058f8:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800058fc:	4905                	li	s2,1
    800058fe:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80005902:	8552                	mv	a0,s4
    80005904:	ffffe097          	auipc	ra,0xffffe
    80005908:	44a080e7          	jalr	1098(ra) # 80003d4e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000590c:	032b0d63          	beq	s6,s2,80005946 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80005910:	004a2603          	lw	a2,4(s4)
    80005914:	fb040593          	addi	a1,s0,-80
    80005918:	8526                	mv	a0,s1
    8000591a:	fffff097          	auipc	ra,0xfffff
    8000591e:	c22080e7          	jalr	-990(ra) # 8000453c <dirlink>
    80005922:	08054163          	bltz	a0,800059a4 <create+0x15c>
  iunlockput(dp);
    80005926:	8526                	mv	a0,s1
    80005928:	ffffe097          	auipc	ra,0xffffe
    8000592c:	758080e7          	jalr	1880(ra) # 80004080 <iunlockput>
  return ip;
    80005930:	8ad2                	mv	s5,s4
    80005932:	7a02                	ld	s4,32(sp)
    80005934:	b751                	j	800058b8 <create+0x70>
    iunlockput(dp);
    80005936:	8526                	mv	a0,s1
    80005938:	ffffe097          	auipc	ra,0xffffe
    8000593c:	748080e7          	jalr	1864(ra) # 80004080 <iunlockput>
    return 0;
    80005940:	8ad2                	mv	s5,s4
    80005942:	7a02                	ld	s4,32(sp)
    80005944:	bf95                	j	800058b8 <create+0x70>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005946:	004a2603          	lw	a2,4(s4)
    8000594a:	00003597          	auipc	a1,0x3
    8000594e:	e5658593          	addi	a1,a1,-426 # 800087a0 <etext+0x7a0>
    80005952:	8552                	mv	a0,s4
    80005954:	fffff097          	auipc	ra,0xfffff
    80005958:	be8080e7          	jalr	-1048(ra) # 8000453c <dirlink>
    8000595c:	04054463          	bltz	a0,800059a4 <create+0x15c>
    80005960:	40d0                	lw	a2,4(s1)
    80005962:	00003597          	auipc	a1,0x3
    80005966:	e4658593          	addi	a1,a1,-442 # 800087a8 <etext+0x7a8>
    8000596a:	8552                	mv	a0,s4
    8000596c:	fffff097          	auipc	ra,0xfffff
    80005970:	bd0080e7          	jalr	-1072(ra) # 8000453c <dirlink>
    80005974:	02054863          	bltz	a0,800059a4 <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    80005978:	004a2603          	lw	a2,4(s4)
    8000597c:	fb040593          	addi	a1,s0,-80
    80005980:	8526                	mv	a0,s1
    80005982:	fffff097          	auipc	ra,0xfffff
    80005986:	bba080e7          	jalr	-1094(ra) # 8000453c <dirlink>
    8000598a:	00054d63          	bltz	a0,800059a4 <create+0x15c>
    dp->nlink++;  // for ".."
    8000598e:	04a4d783          	lhu	a5,74(s1)
    80005992:	2785                	addiw	a5,a5,1
    80005994:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005998:	8526                	mv	a0,s1
    8000599a:	ffffe097          	auipc	ra,0xffffe
    8000599e:	3b4080e7          	jalr	948(ra) # 80003d4e <iupdate>
    800059a2:	b751                	j	80005926 <create+0xde>
  ip->nlink = 0;
    800059a4:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800059a8:	8552                	mv	a0,s4
    800059aa:	ffffe097          	auipc	ra,0xffffe
    800059ae:	3a4080e7          	jalr	932(ra) # 80003d4e <iupdate>
  iunlockput(ip);
    800059b2:	8552                	mv	a0,s4
    800059b4:	ffffe097          	auipc	ra,0xffffe
    800059b8:	6cc080e7          	jalr	1740(ra) # 80004080 <iunlockput>
  iunlockput(dp);
    800059bc:	8526                	mv	a0,s1
    800059be:	ffffe097          	auipc	ra,0xffffe
    800059c2:	6c2080e7          	jalr	1730(ra) # 80004080 <iunlockput>
  return 0;
    800059c6:	7a02                	ld	s4,32(sp)
    800059c8:	bdc5                	j	800058b8 <create+0x70>
    return 0;
    800059ca:	8aaa                	mv	s5,a0
    800059cc:	b5f5                	j	800058b8 <create+0x70>

00000000800059ce <sys_dup>:
{
    800059ce:	7179                	addi	sp,sp,-48
    800059d0:	f406                	sd	ra,40(sp)
    800059d2:	f022                	sd	s0,32(sp)
    800059d4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800059d6:	fd840613          	addi	a2,s0,-40
    800059da:	4581                	li	a1,0
    800059dc:	4501                	li	a0,0
    800059de:	00000097          	auipc	ra,0x0
    800059e2:	dc8080e7          	jalr	-568(ra) # 800057a6 <argfd>
    return -1;
    800059e6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800059e8:	02054763          	bltz	a0,80005a16 <sys_dup+0x48>
    800059ec:	ec26                	sd	s1,24(sp)
    800059ee:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800059f0:	fd843903          	ld	s2,-40(s0)
    800059f4:	854a                	mv	a0,s2
    800059f6:	00000097          	auipc	ra,0x0
    800059fa:	e10080e7          	jalr	-496(ra) # 80005806 <fdalloc>
    800059fe:	84aa                	mv	s1,a0
    return -1;
    80005a00:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005a02:	00054f63          	bltz	a0,80005a20 <sys_dup+0x52>
  filedup(f);
    80005a06:	854a                	mv	a0,s2
    80005a08:	fffff097          	auipc	ra,0xfffff
    80005a0c:	27a080e7          	jalr	634(ra) # 80004c82 <filedup>
  return fd;
    80005a10:	87a6                	mv	a5,s1
    80005a12:	64e2                	ld	s1,24(sp)
    80005a14:	6942                	ld	s2,16(sp)
}
    80005a16:	853e                	mv	a0,a5
    80005a18:	70a2                	ld	ra,40(sp)
    80005a1a:	7402                	ld	s0,32(sp)
    80005a1c:	6145                	addi	sp,sp,48
    80005a1e:	8082                	ret
    80005a20:	64e2                	ld	s1,24(sp)
    80005a22:	6942                	ld	s2,16(sp)
    80005a24:	bfcd                	j	80005a16 <sys_dup+0x48>

0000000080005a26 <sys_read>:
{
    80005a26:	7179                	addi	sp,sp,-48
    80005a28:	f406                	sd	ra,40(sp)
    80005a2a:	f022                	sd	s0,32(sp)
    80005a2c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005a2e:	fd840593          	addi	a1,s0,-40
    80005a32:	4505                	li	a0,1
    80005a34:	ffffd097          	auipc	ra,0xffffd
    80005a38:	748080e7          	jalr	1864(ra) # 8000317c <argaddr>
  argint(2, &n);
    80005a3c:	fe440593          	addi	a1,s0,-28
    80005a40:	4509                	li	a0,2
    80005a42:	ffffd097          	auipc	ra,0xffffd
    80005a46:	71a080e7          	jalr	1818(ra) # 8000315c <argint>
  if(argfd(0, 0, &f) < 0)
    80005a4a:	fe840613          	addi	a2,s0,-24
    80005a4e:	4581                	li	a1,0
    80005a50:	4501                	li	a0,0
    80005a52:	00000097          	auipc	ra,0x0
    80005a56:	d54080e7          	jalr	-684(ra) # 800057a6 <argfd>
    80005a5a:	87aa                	mv	a5,a0
    return -1;
    80005a5c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005a5e:	0007cc63          	bltz	a5,80005a76 <sys_read+0x50>
  return fileread(f, p, n);
    80005a62:	fe442603          	lw	a2,-28(s0)
    80005a66:	fd843583          	ld	a1,-40(s0)
    80005a6a:	fe843503          	ld	a0,-24(s0)
    80005a6e:	fffff097          	auipc	ra,0xfffff
    80005a72:	3ba080e7          	jalr	954(ra) # 80004e28 <fileread>
}
    80005a76:	70a2                	ld	ra,40(sp)
    80005a78:	7402                	ld	s0,32(sp)
    80005a7a:	6145                	addi	sp,sp,48
    80005a7c:	8082                	ret

0000000080005a7e <sys_write>:
{
    80005a7e:	7179                	addi	sp,sp,-48
    80005a80:	f406                	sd	ra,40(sp)
    80005a82:	f022                	sd	s0,32(sp)
    80005a84:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005a86:	fd840593          	addi	a1,s0,-40
    80005a8a:	4505                	li	a0,1
    80005a8c:	ffffd097          	auipc	ra,0xffffd
    80005a90:	6f0080e7          	jalr	1776(ra) # 8000317c <argaddr>
  argint(2, &n);
    80005a94:	fe440593          	addi	a1,s0,-28
    80005a98:	4509                	li	a0,2
    80005a9a:	ffffd097          	auipc	ra,0xffffd
    80005a9e:	6c2080e7          	jalr	1730(ra) # 8000315c <argint>
  if(argfd(0, 0, &f) < 0)
    80005aa2:	fe840613          	addi	a2,s0,-24
    80005aa6:	4581                	li	a1,0
    80005aa8:	4501                	li	a0,0
    80005aaa:	00000097          	auipc	ra,0x0
    80005aae:	cfc080e7          	jalr	-772(ra) # 800057a6 <argfd>
    80005ab2:	87aa                	mv	a5,a0
    return -1;
    80005ab4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005ab6:	0007cc63          	bltz	a5,80005ace <sys_write+0x50>
  return filewrite(f, p, n);
    80005aba:	fe442603          	lw	a2,-28(s0)
    80005abe:	fd843583          	ld	a1,-40(s0)
    80005ac2:	fe843503          	ld	a0,-24(s0)
    80005ac6:	fffff097          	auipc	ra,0xfffff
    80005aca:	434080e7          	jalr	1076(ra) # 80004efa <filewrite>
}
    80005ace:	70a2                	ld	ra,40(sp)
    80005ad0:	7402                	ld	s0,32(sp)
    80005ad2:	6145                	addi	sp,sp,48
    80005ad4:	8082                	ret

0000000080005ad6 <sys_close>:
{
    80005ad6:	1101                	addi	sp,sp,-32
    80005ad8:	ec06                	sd	ra,24(sp)
    80005ada:	e822                	sd	s0,16(sp)
    80005adc:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005ade:	fe040613          	addi	a2,s0,-32
    80005ae2:	fec40593          	addi	a1,s0,-20
    80005ae6:	4501                	li	a0,0
    80005ae8:	00000097          	auipc	ra,0x0
    80005aec:	cbe080e7          	jalr	-834(ra) # 800057a6 <argfd>
    return -1;
    80005af0:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005af2:	02054463          	bltz	a0,80005b1a <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005af6:	ffffc097          	auipc	ra,0xffffc
    80005afa:	228080e7          	jalr	552(ra) # 80001d1e <myproc>
    80005afe:	fec42783          	lw	a5,-20(s0)
    80005b02:	07e9                	addi	a5,a5,26
    80005b04:	078e                	slli	a5,a5,0x3
    80005b06:	953e                	add	a0,a0,a5
    80005b08:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80005b0c:	fe043503          	ld	a0,-32(s0)
    80005b10:	fffff097          	auipc	ra,0xfffff
    80005b14:	1c4080e7          	jalr	452(ra) # 80004cd4 <fileclose>
  return 0;
    80005b18:	4781                	li	a5,0
}
    80005b1a:	853e                	mv	a0,a5
    80005b1c:	60e2                	ld	ra,24(sp)
    80005b1e:	6442                	ld	s0,16(sp)
    80005b20:	6105                	addi	sp,sp,32
    80005b22:	8082                	ret

0000000080005b24 <sys_fstat>:
{
    80005b24:	1101                	addi	sp,sp,-32
    80005b26:	ec06                	sd	ra,24(sp)
    80005b28:	e822                	sd	s0,16(sp)
    80005b2a:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005b2c:	fe040593          	addi	a1,s0,-32
    80005b30:	4505                	li	a0,1
    80005b32:	ffffd097          	auipc	ra,0xffffd
    80005b36:	64a080e7          	jalr	1610(ra) # 8000317c <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005b3a:	fe840613          	addi	a2,s0,-24
    80005b3e:	4581                	li	a1,0
    80005b40:	4501                	li	a0,0
    80005b42:	00000097          	auipc	ra,0x0
    80005b46:	c64080e7          	jalr	-924(ra) # 800057a6 <argfd>
    80005b4a:	87aa                	mv	a5,a0
    return -1;
    80005b4c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005b4e:	0007ca63          	bltz	a5,80005b62 <sys_fstat+0x3e>
  return filestat(f, st);
    80005b52:	fe043583          	ld	a1,-32(s0)
    80005b56:	fe843503          	ld	a0,-24(s0)
    80005b5a:	fffff097          	auipc	ra,0xfffff
    80005b5e:	258080e7          	jalr	600(ra) # 80004db2 <filestat>
}
    80005b62:	60e2                	ld	ra,24(sp)
    80005b64:	6442                	ld	s0,16(sp)
    80005b66:	6105                	addi	sp,sp,32
    80005b68:	8082                	ret

0000000080005b6a <sys_link>:
{
    80005b6a:	7169                	addi	sp,sp,-304
    80005b6c:	f606                	sd	ra,296(sp)
    80005b6e:	f222                	sd	s0,288(sp)
    80005b70:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005b72:	08000613          	li	a2,128
    80005b76:	ed040593          	addi	a1,s0,-304
    80005b7a:	4501                	li	a0,0
    80005b7c:	ffffd097          	auipc	ra,0xffffd
    80005b80:	620080e7          	jalr	1568(ra) # 8000319c <argstr>
    return -1;
    80005b84:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005b86:	12054663          	bltz	a0,80005cb2 <sys_link+0x148>
    80005b8a:	08000613          	li	a2,128
    80005b8e:	f5040593          	addi	a1,s0,-176
    80005b92:	4505                	li	a0,1
    80005b94:	ffffd097          	auipc	ra,0xffffd
    80005b98:	608080e7          	jalr	1544(ra) # 8000319c <argstr>
    return -1;
    80005b9c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005b9e:	10054a63          	bltz	a0,80005cb2 <sys_link+0x148>
    80005ba2:	ee26                	sd	s1,280(sp)
  begin_op();
    80005ba4:	fffff097          	auipc	ra,0xfffff
    80005ba8:	c60080e7          	jalr	-928(ra) # 80004804 <begin_op>
  if((ip = namei(old)) == 0){
    80005bac:	ed040513          	addi	a0,s0,-304
    80005bb0:	fffff097          	auipc	ra,0xfffff
    80005bb4:	a4e080e7          	jalr	-1458(ra) # 800045fe <namei>
    80005bb8:	84aa                	mv	s1,a0
    80005bba:	c949                	beqz	a0,80005c4c <sys_link+0xe2>
  ilock(ip);
    80005bbc:	ffffe097          	auipc	ra,0xffffe
    80005bc0:	25e080e7          	jalr	606(ra) # 80003e1a <ilock>
  if(ip->type == T_DIR){
    80005bc4:	04449703          	lh	a4,68(s1)
    80005bc8:	4785                	li	a5,1
    80005bca:	08f70863          	beq	a4,a5,80005c5a <sys_link+0xf0>
    80005bce:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80005bd0:	04a4d783          	lhu	a5,74(s1)
    80005bd4:	2785                	addiw	a5,a5,1
    80005bd6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005bda:	8526                	mv	a0,s1
    80005bdc:	ffffe097          	auipc	ra,0xffffe
    80005be0:	172080e7          	jalr	370(ra) # 80003d4e <iupdate>
  iunlock(ip);
    80005be4:	8526                	mv	a0,s1
    80005be6:	ffffe097          	auipc	ra,0xffffe
    80005bea:	2fa080e7          	jalr	762(ra) # 80003ee0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005bee:	fd040593          	addi	a1,s0,-48
    80005bf2:	f5040513          	addi	a0,s0,-176
    80005bf6:	fffff097          	auipc	ra,0xfffff
    80005bfa:	a26080e7          	jalr	-1498(ra) # 8000461c <nameiparent>
    80005bfe:	892a                	mv	s2,a0
    80005c00:	cd35                	beqz	a0,80005c7c <sys_link+0x112>
  ilock(dp);
    80005c02:	ffffe097          	auipc	ra,0xffffe
    80005c06:	218080e7          	jalr	536(ra) # 80003e1a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005c0a:	00092703          	lw	a4,0(s2)
    80005c0e:	409c                	lw	a5,0(s1)
    80005c10:	06f71163          	bne	a4,a5,80005c72 <sys_link+0x108>
    80005c14:	40d0                	lw	a2,4(s1)
    80005c16:	fd040593          	addi	a1,s0,-48
    80005c1a:	854a                	mv	a0,s2
    80005c1c:	fffff097          	auipc	ra,0xfffff
    80005c20:	920080e7          	jalr	-1760(ra) # 8000453c <dirlink>
    80005c24:	04054763          	bltz	a0,80005c72 <sys_link+0x108>
  iunlockput(dp);
    80005c28:	854a                	mv	a0,s2
    80005c2a:	ffffe097          	auipc	ra,0xffffe
    80005c2e:	456080e7          	jalr	1110(ra) # 80004080 <iunlockput>
  iput(ip);
    80005c32:	8526                	mv	a0,s1
    80005c34:	ffffe097          	auipc	ra,0xffffe
    80005c38:	3a4080e7          	jalr	932(ra) # 80003fd8 <iput>
  end_op();
    80005c3c:	fffff097          	auipc	ra,0xfffff
    80005c40:	c42080e7          	jalr	-958(ra) # 8000487e <end_op>
  return 0;
    80005c44:	4781                	li	a5,0
    80005c46:	64f2                	ld	s1,280(sp)
    80005c48:	6952                	ld	s2,272(sp)
    80005c4a:	a0a5                	j	80005cb2 <sys_link+0x148>
    end_op();
    80005c4c:	fffff097          	auipc	ra,0xfffff
    80005c50:	c32080e7          	jalr	-974(ra) # 8000487e <end_op>
    return -1;
    80005c54:	57fd                	li	a5,-1
    80005c56:	64f2                	ld	s1,280(sp)
    80005c58:	a8a9                	j	80005cb2 <sys_link+0x148>
    iunlockput(ip);
    80005c5a:	8526                	mv	a0,s1
    80005c5c:	ffffe097          	auipc	ra,0xffffe
    80005c60:	424080e7          	jalr	1060(ra) # 80004080 <iunlockput>
    end_op();
    80005c64:	fffff097          	auipc	ra,0xfffff
    80005c68:	c1a080e7          	jalr	-998(ra) # 8000487e <end_op>
    return -1;
    80005c6c:	57fd                	li	a5,-1
    80005c6e:	64f2                	ld	s1,280(sp)
    80005c70:	a089                	j	80005cb2 <sys_link+0x148>
    iunlockput(dp);
    80005c72:	854a                	mv	a0,s2
    80005c74:	ffffe097          	auipc	ra,0xffffe
    80005c78:	40c080e7          	jalr	1036(ra) # 80004080 <iunlockput>
  ilock(ip);
    80005c7c:	8526                	mv	a0,s1
    80005c7e:	ffffe097          	auipc	ra,0xffffe
    80005c82:	19c080e7          	jalr	412(ra) # 80003e1a <ilock>
  ip->nlink--;
    80005c86:	04a4d783          	lhu	a5,74(s1)
    80005c8a:	37fd                	addiw	a5,a5,-1
    80005c8c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005c90:	8526                	mv	a0,s1
    80005c92:	ffffe097          	auipc	ra,0xffffe
    80005c96:	0bc080e7          	jalr	188(ra) # 80003d4e <iupdate>
  iunlockput(ip);
    80005c9a:	8526                	mv	a0,s1
    80005c9c:	ffffe097          	auipc	ra,0xffffe
    80005ca0:	3e4080e7          	jalr	996(ra) # 80004080 <iunlockput>
  end_op();
    80005ca4:	fffff097          	auipc	ra,0xfffff
    80005ca8:	bda080e7          	jalr	-1062(ra) # 8000487e <end_op>
  return -1;
    80005cac:	57fd                	li	a5,-1
    80005cae:	64f2                	ld	s1,280(sp)
    80005cb0:	6952                	ld	s2,272(sp)
}
    80005cb2:	853e                	mv	a0,a5
    80005cb4:	70b2                	ld	ra,296(sp)
    80005cb6:	7412                	ld	s0,288(sp)
    80005cb8:	6155                	addi	sp,sp,304
    80005cba:	8082                	ret

0000000080005cbc <sys_unlink>:
{
    80005cbc:	7111                	addi	sp,sp,-256
    80005cbe:	fd86                	sd	ra,248(sp)
    80005cc0:	f9a2                	sd	s0,240(sp)
    80005cc2:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    80005cc4:	08000613          	li	a2,128
    80005cc8:	f2040593          	addi	a1,s0,-224
    80005ccc:	4501                	li	a0,0
    80005cce:	ffffd097          	auipc	ra,0xffffd
    80005cd2:	4ce080e7          	jalr	1230(ra) # 8000319c <argstr>
    80005cd6:	1c054063          	bltz	a0,80005e96 <sys_unlink+0x1da>
    80005cda:	f5a6                	sd	s1,232(sp)
  begin_op();
    80005cdc:	fffff097          	auipc	ra,0xfffff
    80005ce0:	b28080e7          	jalr	-1240(ra) # 80004804 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005ce4:	fa040593          	addi	a1,s0,-96
    80005ce8:	f2040513          	addi	a0,s0,-224
    80005cec:	fffff097          	auipc	ra,0xfffff
    80005cf0:	930080e7          	jalr	-1744(ra) # 8000461c <nameiparent>
    80005cf4:	84aa                	mv	s1,a0
    80005cf6:	c165                	beqz	a0,80005dd6 <sys_unlink+0x11a>
  ilock(dp);
    80005cf8:	ffffe097          	auipc	ra,0xffffe
    80005cfc:	122080e7          	jalr	290(ra) # 80003e1a <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005d00:	00003597          	auipc	a1,0x3
    80005d04:	aa058593          	addi	a1,a1,-1376 # 800087a0 <etext+0x7a0>
    80005d08:	fa040513          	addi	a0,s0,-96
    80005d0c:	ffffe097          	auipc	ra,0xffffe
    80005d10:	5f0080e7          	jalr	1520(ra) # 800042fc <namecmp>
    80005d14:	16050263          	beqz	a0,80005e78 <sys_unlink+0x1bc>
    80005d18:	00003597          	auipc	a1,0x3
    80005d1c:	a9058593          	addi	a1,a1,-1392 # 800087a8 <etext+0x7a8>
    80005d20:	fa040513          	addi	a0,s0,-96
    80005d24:	ffffe097          	auipc	ra,0xffffe
    80005d28:	5d8080e7          	jalr	1496(ra) # 800042fc <namecmp>
    80005d2c:	14050663          	beqz	a0,80005e78 <sys_unlink+0x1bc>
    80005d30:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005d32:	f1c40613          	addi	a2,s0,-228
    80005d36:	fa040593          	addi	a1,s0,-96
    80005d3a:	8526                	mv	a0,s1
    80005d3c:	ffffe097          	auipc	ra,0xffffe
    80005d40:	5da080e7          	jalr	1498(ra) # 80004316 <dirlookup>
    80005d44:	892a                	mv	s2,a0
    80005d46:	12050863          	beqz	a0,80005e76 <sys_unlink+0x1ba>
    80005d4a:	edce                	sd	s3,216(sp)
  ilock(ip);
    80005d4c:	ffffe097          	auipc	ra,0xffffe
    80005d50:	0ce080e7          	jalr	206(ra) # 80003e1a <ilock>
  if(ip->nlink < 1)
    80005d54:	04a91783          	lh	a5,74(s2)
    80005d58:	08f05663          	blez	a5,80005de4 <sys_unlink+0x128>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005d5c:	04491703          	lh	a4,68(s2)
    80005d60:	4785                	li	a5,1
    80005d62:	08f70b63          	beq	a4,a5,80005df8 <sys_unlink+0x13c>
  memset(&de, 0, sizeof(de));
    80005d66:	fb040993          	addi	s3,s0,-80
    80005d6a:	4641                	li	a2,16
    80005d6c:	4581                	li	a1,0
    80005d6e:	854e                	mv	a0,s3
    80005d70:	ffffb097          	auipc	ra,0xffffb
    80005d74:	14e080e7          	jalr	334(ra) # 80000ebe <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005d78:	4741                	li	a4,16
    80005d7a:	f1c42683          	lw	a3,-228(s0)
    80005d7e:	864e                	mv	a2,s3
    80005d80:	4581                	li	a1,0
    80005d82:	8526                	mv	a0,s1
    80005d84:	ffffe097          	auipc	ra,0xffffe
    80005d88:	458080e7          	jalr	1112(ra) # 800041dc <writei>
    80005d8c:	47c1                	li	a5,16
    80005d8e:	0af51f63          	bne	a0,a5,80005e4c <sys_unlink+0x190>
  if(ip->type == T_DIR){
    80005d92:	04491703          	lh	a4,68(s2)
    80005d96:	4785                	li	a5,1
    80005d98:	0cf70463          	beq	a4,a5,80005e60 <sys_unlink+0x1a4>
  iunlockput(dp);
    80005d9c:	8526                	mv	a0,s1
    80005d9e:	ffffe097          	auipc	ra,0xffffe
    80005da2:	2e2080e7          	jalr	738(ra) # 80004080 <iunlockput>
  ip->nlink--;
    80005da6:	04a95783          	lhu	a5,74(s2)
    80005daa:	37fd                	addiw	a5,a5,-1
    80005dac:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005db0:	854a                	mv	a0,s2
    80005db2:	ffffe097          	auipc	ra,0xffffe
    80005db6:	f9c080e7          	jalr	-100(ra) # 80003d4e <iupdate>
  iunlockput(ip);
    80005dba:	854a                	mv	a0,s2
    80005dbc:	ffffe097          	auipc	ra,0xffffe
    80005dc0:	2c4080e7          	jalr	708(ra) # 80004080 <iunlockput>
  end_op();
    80005dc4:	fffff097          	auipc	ra,0xfffff
    80005dc8:	aba080e7          	jalr	-1350(ra) # 8000487e <end_op>
  return 0;
    80005dcc:	4501                	li	a0,0
    80005dce:	74ae                	ld	s1,232(sp)
    80005dd0:	790e                	ld	s2,224(sp)
    80005dd2:	69ee                	ld	s3,216(sp)
    80005dd4:	a86d                	j	80005e8e <sys_unlink+0x1d2>
    end_op();
    80005dd6:	fffff097          	auipc	ra,0xfffff
    80005dda:	aa8080e7          	jalr	-1368(ra) # 8000487e <end_op>
    return -1;
    80005dde:	557d                	li	a0,-1
    80005de0:	74ae                	ld	s1,232(sp)
    80005de2:	a075                	j	80005e8e <sys_unlink+0x1d2>
    80005de4:	e9d2                	sd	s4,208(sp)
    80005de6:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    80005de8:	00003517          	auipc	a0,0x3
    80005dec:	9c850513          	addi	a0,a0,-1592 # 800087b0 <etext+0x7b0>
    80005df0:	ffffa097          	auipc	ra,0xffffa
    80005df4:	770080e7          	jalr	1904(ra) # 80000560 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005df8:	04c92703          	lw	a4,76(s2)
    80005dfc:	02000793          	li	a5,32
    80005e00:	f6e7f3e3          	bgeu	a5,a4,80005d66 <sys_unlink+0xaa>
    80005e04:	e9d2                	sd	s4,208(sp)
    80005e06:	e5d6                	sd	s5,200(sp)
    80005e08:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005e0a:	f0840a93          	addi	s5,s0,-248
    80005e0e:	4a41                	li	s4,16
    80005e10:	8752                	mv	a4,s4
    80005e12:	86ce                	mv	a3,s3
    80005e14:	8656                	mv	a2,s5
    80005e16:	4581                	li	a1,0
    80005e18:	854a                	mv	a0,s2
    80005e1a:	ffffe097          	auipc	ra,0xffffe
    80005e1e:	2bc080e7          	jalr	700(ra) # 800040d6 <readi>
    80005e22:	01451d63          	bne	a0,s4,80005e3c <sys_unlink+0x180>
    if(de.inum != 0)
    80005e26:	f0845783          	lhu	a5,-248(s0)
    80005e2a:	eba5                	bnez	a5,80005e9a <sys_unlink+0x1de>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005e2c:	29c1                	addiw	s3,s3,16
    80005e2e:	04c92783          	lw	a5,76(s2)
    80005e32:	fcf9efe3          	bltu	s3,a5,80005e10 <sys_unlink+0x154>
    80005e36:	6a4e                	ld	s4,208(sp)
    80005e38:	6aae                	ld	s5,200(sp)
    80005e3a:	b735                	j	80005d66 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005e3c:	00003517          	auipc	a0,0x3
    80005e40:	98c50513          	addi	a0,a0,-1652 # 800087c8 <etext+0x7c8>
    80005e44:	ffffa097          	auipc	ra,0xffffa
    80005e48:	71c080e7          	jalr	1820(ra) # 80000560 <panic>
    80005e4c:	e9d2                	sd	s4,208(sp)
    80005e4e:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    80005e50:	00003517          	auipc	a0,0x3
    80005e54:	99050513          	addi	a0,a0,-1648 # 800087e0 <etext+0x7e0>
    80005e58:	ffffa097          	auipc	ra,0xffffa
    80005e5c:	708080e7          	jalr	1800(ra) # 80000560 <panic>
    dp->nlink--;
    80005e60:	04a4d783          	lhu	a5,74(s1)
    80005e64:	37fd                	addiw	a5,a5,-1
    80005e66:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005e6a:	8526                	mv	a0,s1
    80005e6c:	ffffe097          	auipc	ra,0xffffe
    80005e70:	ee2080e7          	jalr	-286(ra) # 80003d4e <iupdate>
    80005e74:	b725                	j	80005d9c <sys_unlink+0xe0>
    80005e76:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    80005e78:	8526                	mv	a0,s1
    80005e7a:	ffffe097          	auipc	ra,0xffffe
    80005e7e:	206080e7          	jalr	518(ra) # 80004080 <iunlockput>
  end_op();
    80005e82:	fffff097          	auipc	ra,0xfffff
    80005e86:	9fc080e7          	jalr	-1540(ra) # 8000487e <end_op>
  return -1;
    80005e8a:	557d                	li	a0,-1
    80005e8c:	74ae                	ld	s1,232(sp)
}
    80005e8e:	70ee                	ld	ra,248(sp)
    80005e90:	744e                	ld	s0,240(sp)
    80005e92:	6111                	addi	sp,sp,256
    80005e94:	8082                	ret
    return -1;
    80005e96:	557d                	li	a0,-1
    80005e98:	bfdd                	j	80005e8e <sys_unlink+0x1d2>
    iunlockput(ip);
    80005e9a:	854a                	mv	a0,s2
    80005e9c:	ffffe097          	auipc	ra,0xffffe
    80005ea0:	1e4080e7          	jalr	484(ra) # 80004080 <iunlockput>
    goto bad;
    80005ea4:	790e                	ld	s2,224(sp)
    80005ea6:	69ee                	ld	s3,216(sp)
    80005ea8:	6a4e                	ld	s4,208(sp)
    80005eaa:	6aae                	ld	s5,200(sp)
    80005eac:	b7f1                	j	80005e78 <sys_unlink+0x1bc>

0000000080005eae <sys_open>:

uint64
sys_open(void)
{
    80005eae:	7131                	addi	sp,sp,-192
    80005eb0:	fd06                	sd	ra,184(sp)
    80005eb2:	f922                	sd	s0,176(sp)
    80005eb4:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005eb6:	f4c40593          	addi	a1,s0,-180
    80005eba:	4505                	li	a0,1
    80005ebc:	ffffd097          	auipc	ra,0xffffd
    80005ec0:	2a0080e7          	jalr	672(ra) # 8000315c <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005ec4:	08000613          	li	a2,128
    80005ec8:	f5040593          	addi	a1,s0,-176
    80005ecc:	4501                	li	a0,0
    80005ece:	ffffd097          	auipc	ra,0xffffd
    80005ed2:	2ce080e7          	jalr	718(ra) # 8000319c <argstr>
    80005ed6:	87aa                	mv	a5,a0
    return -1;
    80005ed8:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005eda:	0a07cf63          	bltz	a5,80005f98 <sys_open+0xea>
    80005ede:	f526                	sd	s1,168(sp)

  begin_op();
    80005ee0:	fffff097          	auipc	ra,0xfffff
    80005ee4:	924080e7          	jalr	-1756(ra) # 80004804 <begin_op>

  if(omode & O_CREATE){
    80005ee8:	f4c42783          	lw	a5,-180(s0)
    80005eec:	2007f793          	andi	a5,a5,512
    80005ef0:	cfdd                	beqz	a5,80005fae <sys_open+0x100>
    ip = create(path, T_FILE, 0, 0);
    80005ef2:	4681                	li	a3,0
    80005ef4:	4601                	li	a2,0
    80005ef6:	4589                	li	a1,2
    80005ef8:	f5040513          	addi	a0,s0,-176
    80005efc:	00000097          	auipc	ra,0x0
    80005f00:	94c080e7          	jalr	-1716(ra) # 80005848 <create>
    80005f04:	84aa                	mv	s1,a0
    if(ip == 0){
    80005f06:	cd49                	beqz	a0,80005fa0 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005f08:	04449703          	lh	a4,68(s1)
    80005f0c:	478d                	li	a5,3
    80005f0e:	00f71763          	bne	a4,a5,80005f1c <sys_open+0x6e>
    80005f12:	0464d703          	lhu	a4,70(s1)
    80005f16:	47a5                	li	a5,9
    80005f18:	0ee7e263          	bltu	a5,a4,80005ffc <sys_open+0x14e>
    80005f1c:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005f1e:	fffff097          	auipc	ra,0xfffff
    80005f22:	cfa080e7          	jalr	-774(ra) # 80004c18 <filealloc>
    80005f26:	892a                	mv	s2,a0
    80005f28:	cd65                	beqz	a0,80006020 <sys_open+0x172>
    80005f2a:	ed4e                	sd	s3,152(sp)
    80005f2c:	00000097          	auipc	ra,0x0
    80005f30:	8da080e7          	jalr	-1830(ra) # 80005806 <fdalloc>
    80005f34:	89aa                	mv	s3,a0
    80005f36:	0c054f63          	bltz	a0,80006014 <sys_open+0x166>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005f3a:	04449703          	lh	a4,68(s1)
    80005f3e:	478d                	li	a5,3
    80005f40:	0ef70d63          	beq	a4,a5,8000603a <sys_open+0x18c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005f44:	4789                	li	a5,2
    80005f46:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005f4a:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005f4e:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005f52:	f4c42783          	lw	a5,-180(s0)
    80005f56:	0017f713          	andi	a4,a5,1
    80005f5a:	00174713          	xori	a4,a4,1
    80005f5e:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005f62:	0037f713          	andi	a4,a5,3
    80005f66:	00e03733          	snez	a4,a4
    80005f6a:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005f6e:	4007f793          	andi	a5,a5,1024
    80005f72:	c791                	beqz	a5,80005f7e <sys_open+0xd0>
    80005f74:	04449703          	lh	a4,68(s1)
    80005f78:	4789                	li	a5,2
    80005f7a:	0cf70763          	beq	a4,a5,80006048 <sys_open+0x19a>
    itrunc(ip);
  }

  iunlock(ip);
    80005f7e:	8526                	mv	a0,s1
    80005f80:	ffffe097          	auipc	ra,0xffffe
    80005f84:	f60080e7          	jalr	-160(ra) # 80003ee0 <iunlock>
  end_op();
    80005f88:	fffff097          	auipc	ra,0xfffff
    80005f8c:	8f6080e7          	jalr	-1802(ra) # 8000487e <end_op>

  return fd;
    80005f90:	854e                	mv	a0,s3
    80005f92:	74aa                	ld	s1,168(sp)
    80005f94:	790a                	ld	s2,160(sp)
    80005f96:	69ea                	ld	s3,152(sp)
}
    80005f98:	70ea                	ld	ra,184(sp)
    80005f9a:	744a                	ld	s0,176(sp)
    80005f9c:	6129                	addi	sp,sp,192
    80005f9e:	8082                	ret
      end_op();
    80005fa0:	fffff097          	auipc	ra,0xfffff
    80005fa4:	8de080e7          	jalr	-1826(ra) # 8000487e <end_op>
      return -1;
    80005fa8:	557d                	li	a0,-1
    80005faa:	74aa                	ld	s1,168(sp)
    80005fac:	b7f5                	j	80005f98 <sys_open+0xea>
    if((ip = namei(path)) == 0){
    80005fae:	f5040513          	addi	a0,s0,-176
    80005fb2:	ffffe097          	auipc	ra,0xffffe
    80005fb6:	64c080e7          	jalr	1612(ra) # 800045fe <namei>
    80005fba:	84aa                	mv	s1,a0
    80005fbc:	c90d                	beqz	a0,80005fee <sys_open+0x140>
    ilock(ip);
    80005fbe:	ffffe097          	auipc	ra,0xffffe
    80005fc2:	e5c080e7          	jalr	-420(ra) # 80003e1a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005fc6:	04449703          	lh	a4,68(s1)
    80005fca:	4785                	li	a5,1
    80005fcc:	f2f71ee3          	bne	a4,a5,80005f08 <sys_open+0x5a>
    80005fd0:	f4c42783          	lw	a5,-180(s0)
    80005fd4:	d7a1                	beqz	a5,80005f1c <sys_open+0x6e>
      iunlockput(ip);
    80005fd6:	8526                	mv	a0,s1
    80005fd8:	ffffe097          	auipc	ra,0xffffe
    80005fdc:	0a8080e7          	jalr	168(ra) # 80004080 <iunlockput>
      end_op();
    80005fe0:	fffff097          	auipc	ra,0xfffff
    80005fe4:	89e080e7          	jalr	-1890(ra) # 8000487e <end_op>
      return -1;
    80005fe8:	557d                	li	a0,-1
    80005fea:	74aa                	ld	s1,168(sp)
    80005fec:	b775                	j	80005f98 <sys_open+0xea>
      end_op();
    80005fee:	fffff097          	auipc	ra,0xfffff
    80005ff2:	890080e7          	jalr	-1904(ra) # 8000487e <end_op>
      return -1;
    80005ff6:	557d                	li	a0,-1
    80005ff8:	74aa                	ld	s1,168(sp)
    80005ffa:	bf79                	j	80005f98 <sys_open+0xea>
    iunlockput(ip);
    80005ffc:	8526                	mv	a0,s1
    80005ffe:	ffffe097          	auipc	ra,0xffffe
    80006002:	082080e7          	jalr	130(ra) # 80004080 <iunlockput>
    end_op();
    80006006:	fffff097          	auipc	ra,0xfffff
    8000600a:	878080e7          	jalr	-1928(ra) # 8000487e <end_op>
    return -1;
    8000600e:	557d                	li	a0,-1
    80006010:	74aa                	ld	s1,168(sp)
    80006012:	b759                	j	80005f98 <sys_open+0xea>
      fileclose(f);
    80006014:	854a                	mv	a0,s2
    80006016:	fffff097          	auipc	ra,0xfffff
    8000601a:	cbe080e7          	jalr	-834(ra) # 80004cd4 <fileclose>
    8000601e:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80006020:	8526                	mv	a0,s1
    80006022:	ffffe097          	auipc	ra,0xffffe
    80006026:	05e080e7          	jalr	94(ra) # 80004080 <iunlockput>
    end_op();
    8000602a:	fffff097          	auipc	ra,0xfffff
    8000602e:	854080e7          	jalr	-1964(ra) # 8000487e <end_op>
    return -1;
    80006032:	557d                	li	a0,-1
    80006034:	74aa                	ld	s1,168(sp)
    80006036:	790a                	ld	s2,160(sp)
    80006038:	b785                	j	80005f98 <sys_open+0xea>
    f->type = FD_DEVICE;
    8000603a:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    8000603e:	04649783          	lh	a5,70(s1)
    80006042:	02f91223          	sh	a5,36(s2)
    80006046:	b721                	j	80005f4e <sys_open+0xa0>
    itrunc(ip);
    80006048:	8526                	mv	a0,s1
    8000604a:	ffffe097          	auipc	ra,0xffffe
    8000604e:	ee2080e7          	jalr	-286(ra) # 80003f2c <itrunc>
    80006052:	b735                	j	80005f7e <sys_open+0xd0>

0000000080006054 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80006054:	7175                	addi	sp,sp,-144
    80006056:	e506                	sd	ra,136(sp)
    80006058:	e122                	sd	s0,128(sp)
    8000605a:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000605c:	ffffe097          	auipc	ra,0xffffe
    80006060:	7a8080e7          	jalr	1960(ra) # 80004804 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80006064:	08000613          	li	a2,128
    80006068:	f7040593          	addi	a1,s0,-144
    8000606c:	4501                	li	a0,0
    8000606e:	ffffd097          	auipc	ra,0xffffd
    80006072:	12e080e7          	jalr	302(ra) # 8000319c <argstr>
    80006076:	02054963          	bltz	a0,800060a8 <sys_mkdir+0x54>
    8000607a:	4681                	li	a3,0
    8000607c:	4601                	li	a2,0
    8000607e:	4585                	li	a1,1
    80006080:	f7040513          	addi	a0,s0,-144
    80006084:	fffff097          	auipc	ra,0xfffff
    80006088:	7c4080e7          	jalr	1988(ra) # 80005848 <create>
    8000608c:	cd11                	beqz	a0,800060a8 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000608e:	ffffe097          	auipc	ra,0xffffe
    80006092:	ff2080e7          	jalr	-14(ra) # 80004080 <iunlockput>
  end_op();
    80006096:	ffffe097          	auipc	ra,0xffffe
    8000609a:	7e8080e7          	jalr	2024(ra) # 8000487e <end_op>
  return 0;
    8000609e:	4501                	li	a0,0
}
    800060a0:	60aa                	ld	ra,136(sp)
    800060a2:	640a                	ld	s0,128(sp)
    800060a4:	6149                	addi	sp,sp,144
    800060a6:	8082                	ret
    end_op();
    800060a8:	ffffe097          	auipc	ra,0xffffe
    800060ac:	7d6080e7          	jalr	2006(ra) # 8000487e <end_op>
    return -1;
    800060b0:	557d                	li	a0,-1
    800060b2:	b7fd                	j	800060a0 <sys_mkdir+0x4c>

00000000800060b4 <sys_mknod>:

uint64
sys_mknod(void)
{
    800060b4:	7135                	addi	sp,sp,-160
    800060b6:	ed06                	sd	ra,152(sp)
    800060b8:	e922                	sd	s0,144(sp)
    800060ba:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800060bc:	ffffe097          	auipc	ra,0xffffe
    800060c0:	748080e7          	jalr	1864(ra) # 80004804 <begin_op>
  argint(1, &major);
    800060c4:	f6c40593          	addi	a1,s0,-148
    800060c8:	4505                	li	a0,1
    800060ca:	ffffd097          	auipc	ra,0xffffd
    800060ce:	092080e7          	jalr	146(ra) # 8000315c <argint>
  argint(2, &minor);
    800060d2:	f6840593          	addi	a1,s0,-152
    800060d6:	4509                	li	a0,2
    800060d8:	ffffd097          	auipc	ra,0xffffd
    800060dc:	084080e7          	jalr	132(ra) # 8000315c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800060e0:	08000613          	li	a2,128
    800060e4:	f7040593          	addi	a1,s0,-144
    800060e8:	4501                	li	a0,0
    800060ea:	ffffd097          	auipc	ra,0xffffd
    800060ee:	0b2080e7          	jalr	178(ra) # 8000319c <argstr>
    800060f2:	02054b63          	bltz	a0,80006128 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800060f6:	f6841683          	lh	a3,-152(s0)
    800060fa:	f6c41603          	lh	a2,-148(s0)
    800060fe:	458d                	li	a1,3
    80006100:	f7040513          	addi	a0,s0,-144
    80006104:	fffff097          	auipc	ra,0xfffff
    80006108:	744080e7          	jalr	1860(ra) # 80005848 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000610c:	cd11                	beqz	a0,80006128 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000610e:	ffffe097          	auipc	ra,0xffffe
    80006112:	f72080e7          	jalr	-142(ra) # 80004080 <iunlockput>
  end_op();
    80006116:	ffffe097          	auipc	ra,0xffffe
    8000611a:	768080e7          	jalr	1896(ra) # 8000487e <end_op>
  return 0;
    8000611e:	4501                	li	a0,0
}
    80006120:	60ea                	ld	ra,152(sp)
    80006122:	644a                	ld	s0,144(sp)
    80006124:	610d                	addi	sp,sp,160
    80006126:	8082                	ret
    end_op();
    80006128:	ffffe097          	auipc	ra,0xffffe
    8000612c:	756080e7          	jalr	1878(ra) # 8000487e <end_op>
    return -1;
    80006130:	557d                	li	a0,-1
    80006132:	b7fd                	j	80006120 <sys_mknod+0x6c>

0000000080006134 <sys_chdir>:

uint64
sys_chdir(void)
{
    80006134:	7135                	addi	sp,sp,-160
    80006136:	ed06                	sd	ra,152(sp)
    80006138:	e922                	sd	s0,144(sp)
    8000613a:	e14a                	sd	s2,128(sp)
    8000613c:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000613e:	ffffc097          	auipc	ra,0xffffc
    80006142:	be0080e7          	jalr	-1056(ra) # 80001d1e <myproc>
    80006146:	892a                	mv	s2,a0
  
  begin_op();
    80006148:	ffffe097          	auipc	ra,0xffffe
    8000614c:	6bc080e7          	jalr	1724(ra) # 80004804 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80006150:	08000613          	li	a2,128
    80006154:	f6040593          	addi	a1,s0,-160
    80006158:	4501                	li	a0,0
    8000615a:	ffffd097          	auipc	ra,0xffffd
    8000615e:	042080e7          	jalr	66(ra) # 8000319c <argstr>
    80006162:	04054d63          	bltz	a0,800061bc <sys_chdir+0x88>
    80006166:	e526                	sd	s1,136(sp)
    80006168:	f6040513          	addi	a0,s0,-160
    8000616c:	ffffe097          	auipc	ra,0xffffe
    80006170:	492080e7          	jalr	1170(ra) # 800045fe <namei>
    80006174:	84aa                	mv	s1,a0
    80006176:	c131                	beqz	a0,800061ba <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80006178:	ffffe097          	auipc	ra,0xffffe
    8000617c:	ca2080e7          	jalr	-862(ra) # 80003e1a <ilock>
  if(ip->type != T_DIR){
    80006180:	04449703          	lh	a4,68(s1)
    80006184:	4785                	li	a5,1
    80006186:	04f71163          	bne	a4,a5,800061c8 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000618a:	8526                	mv	a0,s1
    8000618c:	ffffe097          	auipc	ra,0xffffe
    80006190:	d54080e7          	jalr	-684(ra) # 80003ee0 <iunlock>
  iput(p->cwd);
    80006194:	15093503          	ld	a0,336(s2)
    80006198:	ffffe097          	auipc	ra,0xffffe
    8000619c:	e40080e7          	jalr	-448(ra) # 80003fd8 <iput>
  end_op();
    800061a0:	ffffe097          	auipc	ra,0xffffe
    800061a4:	6de080e7          	jalr	1758(ra) # 8000487e <end_op>
  p->cwd = ip;
    800061a8:	14993823          	sd	s1,336(s2)
  return 0;
    800061ac:	4501                	li	a0,0
    800061ae:	64aa                	ld	s1,136(sp)
}
    800061b0:	60ea                	ld	ra,152(sp)
    800061b2:	644a                	ld	s0,144(sp)
    800061b4:	690a                	ld	s2,128(sp)
    800061b6:	610d                	addi	sp,sp,160
    800061b8:	8082                	ret
    800061ba:	64aa                	ld	s1,136(sp)
    end_op();
    800061bc:	ffffe097          	auipc	ra,0xffffe
    800061c0:	6c2080e7          	jalr	1730(ra) # 8000487e <end_op>
    return -1;
    800061c4:	557d                	li	a0,-1
    800061c6:	b7ed                	j	800061b0 <sys_chdir+0x7c>
    iunlockput(ip);
    800061c8:	8526                	mv	a0,s1
    800061ca:	ffffe097          	auipc	ra,0xffffe
    800061ce:	eb6080e7          	jalr	-330(ra) # 80004080 <iunlockput>
    end_op();
    800061d2:	ffffe097          	auipc	ra,0xffffe
    800061d6:	6ac080e7          	jalr	1708(ra) # 8000487e <end_op>
    return -1;
    800061da:	557d                	li	a0,-1
    800061dc:	64aa                	ld	s1,136(sp)
    800061de:	bfc9                	j	800061b0 <sys_chdir+0x7c>

00000000800061e0 <sys_exec>:

uint64
sys_exec(void)
{
    800061e0:	7105                	addi	sp,sp,-480
    800061e2:	ef86                	sd	ra,472(sp)
    800061e4:	eba2                	sd	s0,464(sp)
    800061e6:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800061e8:	e2840593          	addi	a1,s0,-472
    800061ec:	4505                	li	a0,1
    800061ee:	ffffd097          	auipc	ra,0xffffd
    800061f2:	f8e080e7          	jalr	-114(ra) # 8000317c <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800061f6:	08000613          	li	a2,128
    800061fa:	f3040593          	addi	a1,s0,-208
    800061fe:	4501                	li	a0,0
    80006200:	ffffd097          	auipc	ra,0xffffd
    80006204:	f9c080e7          	jalr	-100(ra) # 8000319c <argstr>
    80006208:	87aa                	mv	a5,a0
    return -1;
    8000620a:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000620c:	0e07ce63          	bltz	a5,80006308 <sys_exec+0x128>
    80006210:	e7a6                	sd	s1,456(sp)
    80006212:	e3ca                	sd	s2,448(sp)
    80006214:	ff4e                	sd	s3,440(sp)
    80006216:	fb52                	sd	s4,432(sp)
    80006218:	f756                	sd	s5,424(sp)
    8000621a:	f35a                	sd	s6,416(sp)
    8000621c:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    8000621e:	e3040a13          	addi	s4,s0,-464
    80006222:	10000613          	li	a2,256
    80006226:	4581                	li	a1,0
    80006228:	8552                	mv	a0,s4
    8000622a:	ffffb097          	auipc	ra,0xffffb
    8000622e:	c94080e7          	jalr	-876(ra) # 80000ebe <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80006232:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80006234:	89d2                	mv	s3,s4
    80006236:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80006238:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000623c:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    8000623e:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80006242:	00391513          	slli	a0,s2,0x3
    80006246:	85d6                	mv	a1,s5
    80006248:	e2843783          	ld	a5,-472(s0)
    8000624c:	953e                	add	a0,a0,a5
    8000624e:	ffffd097          	auipc	ra,0xffffd
    80006252:	e70080e7          	jalr	-400(ra) # 800030be <fetchaddr>
    80006256:	02054a63          	bltz	a0,8000628a <sys_exec+0xaa>
    if(uarg == 0){
    8000625a:	e2043783          	ld	a5,-480(s0)
    8000625e:	cbb1                	beqz	a5,800062b2 <sys_exec+0xd2>
    argv[i] = kalloc();
    80006260:	ffffb097          	auipc	ra,0xffffb
    80006264:	9a2080e7          	jalr	-1630(ra) # 80000c02 <kalloc>
    80006268:	85aa                	mv	a1,a0
    8000626a:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000626e:	cd11                	beqz	a0,8000628a <sys_exec+0xaa>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80006270:	865a                	mv	a2,s6
    80006272:	e2043503          	ld	a0,-480(s0)
    80006276:	ffffd097          	auipc	ra,0xffffd
    8000627a:	e9a080e7          	jalr	-358(ra) # 80003110 <fetchstr>
    8000627e:	00054663          	bltz	a0,8000628a <sys_exec+0xaa>
    if(i >= NELEM(argv)){
    80006282:	0905                	addi	s2,s2,1
    80006284:	09a1                	addi	s3,s3,8
    80006286:	fb791ee3          	bne	s2,s7,80006242 <sys_exec+0x62>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000628a:	100a0a13          	addi	s4,s4,256
    8000628e:	6088                	ld	a0,0(s1)
    80006290:	c525                	beqz	a0,800062f8 <sys_exec+0x118>
    kfree(argv[i]);
    80006292:	ffffa097          	auipc	ra,0xffffa
    80006296:	7cc080e7          	jalr	1996(ra) # 80000a5e <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000629a:	04a1                	addi	s1,s1,8
    8000629c:	ff4499e3          	bne	s1,s4,8000628e <sys_exec+0xae>
  return -1;
    800062a0:	557d                	li	a0,-1
    800062a2:	64be                	ld	s1,456(sp)
    800062a4:	691e                	ld	s2,448(sp)
    800062a6:	79fa                	ld	s3,440(sp)
    800062a8:	7a5a                	ld	s4,432(sp)
    800062aa:	7aba                	ld	s5,424(sp)
    800062ac:	7b1a                	ld	s6,416(sp)
    800062ae:	6bfa                	ld	s7,408(sp)
    800062b0:	a8a1                	j	80006308 <sys_exec+0x128>
      argv[i] = 0;
    800062b2:	0009079b          	sext.w	a5,s2
    800062b6:	e3040593          	addi	a1,s0,-464
    800062ba:	078e                	slli	a5,a5,0x3
    800062bc:	97ae                	add	a5,a5,a1
    800062be:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    800062c2:	f3040513          	addi	a0,s0,-208
    800062c6:	fffff097          	auipc	ra,0xfffff
    800062ca:	118080e7          	jalr	280(ra) # 800053de <exec>
    800062ce:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800062d0:	100a0a13          	addi	s4,s4,256
    800062d4:	6088                	ld	a0,0(s1)
    800062d6:	c901                	beqz	a0,800062e6 <sys_exec+0x106>
    kfree(argv[i]);
    800062d8:	ffffa097          	auipc	ra,0xffffa
    800062dc:	786080e7          	jalr	1926(ra) # 80000a5e <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800062e0:	04a1                	addi	s1,s1,8
    800062e2:	ff4499e3          	bne	s1,s4,800062d4 <sys_exec+0xf4>
  return ret;
    800062e6:	854a                	mv	a0,s2
    800062e8:	64be                	ld	s1,456(sp)
    800062ea:	691e                	ld	s2,448(sp)
    800062ec:	79fa                	ld	s3,440(sp)
    800062ee:	7a5a                	ld	s4,432(sp)
    800062f0:	7aba                	ld	s5,424(sp)
    800062f2:	7b1a                	ld	s6,416(sp)
    800062f4:	6bfa                	ld	s7,408(sp)
    800062f6:	a809                	j	80006308 <sys_exec+0x128>
  return -1;
    800062f8:	557d                	li	a0,-1
    800062fa:	64be                	ld	s1,456(sp)
    800062fc:	691e                	ld	s2,448(sp)
    800062fe:	79fa                	ld	s3,440(sp)
    80006300:	7a5a                	ld	s4,432(sp)
    80006302:	7aba                	ld	s5,424(sp)
    80006304:	7b1a                	ld	s6,416(sp)
    80006306:	6bfa                	ld	s7,408(sp)
}
    80006308:	60fe                	ld	ra,472(sp)
    8000630a:	645e                	ld	s0,464(sp)
    8000630c:	613d                	addi	sp,sp,480
    8000630e:	8082                	ret

0000000080006310 <sys_pipe>:

uint64
sys_pipe(void)
{
    80006310:	7139                	addi	sp,sp,-64
    80006312:	fc06                	sd	ra,56(sp)
    80006314:	f822                	sd	s0,48(sp)
    80006316:	f426                	sd	s1,40(sp)
    80006318:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000631a:	ffffc097          	auipc	ra,0xffffc
    8000631e:	a04080e7          	jalr	-1532(ra) # 80001d1e <myproc>
    80006322:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80006324:	fd840593          	addi	a1,s0,-40
    80006328:	4501                	li	a0,0
    8000632a:	ffffd097          	auipc	ra,0xffffd
    8000632e:	e52080e7          	jalr	-430(ra) # 8000317c <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80006332:	fc840593          	addi	a1,s0,-56
    80006336:	fd040513          	addi	a0,s0,-48
    8000633a:	fffff097          	auipc	ra,0xfffff
    8000633e:	d0e080e7          	jalr	-754(ra) # 80005048 <pipealloc>
    return -1;
    80006342:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80006344:	0c054463          	bltz	a0,8000640c <sys_pipe+0xfc>
  fd0 = -1;
    80006348:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000634c:	fd043503          	ld	a0,-48(s0)
    80006350:	fffff097          	auipc	ra,0xfffff
    80006354:	4b6080e7          	jalr	1206(ra) # 80005806 <fdalloc>
    80006358:	fca42223          	sw	a0,-60(s0)
    8000635c:	08054b63          	bltz	a0,800063f2 <sys_pipe+0xe2>
    80006360:	fc843503          	ld	a0,-56(s0)
    80006364:	fffff097          	auipc	ra,0xfffff
    80006368:	4a2080e7          	jalr	1186(ra) # 80005806 <fdalloc>
    8000636c:	fca42023          	sw	a0,-64(s0)
    80006370:	06054863          	bltz	a0,800063e0 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006374:	4691                	li	a3,4
    80006376:	fc440613          	addi	a2,s0,-60
    8000637a:	fd843583          	ld	a1,-40(s0)
    8000637e:	68a8                	ld	a0,80(s1)
    80006380:	ffffb097          	auipc	ra,0xffffb
    80006384:	516080e7          	jalr	1302(ra) # 80001896 <copyout>
    80006388:	02054063          	bltz	a0,800063a8 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000638c:	4691                	li	a3,4
    8000638e:	fc040613          	addi	a2,s0,-64
    80006392:	fd843583          	ld	a1,-40(s0)
    80006396:	95b6                	add	a1,a1,a3
    80006398:	68a8                	ld	a0,80(s1)
    8000639a:	ffffb097          	auipc	ra,0xffffb
    8000639e:	4fc080e7          	jalr	1276(ra) # 80001896 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800063a2:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800063a4:	06055463          	bgez	a0,8000640c <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800063a8:	fc442783          	lw	a5,-60(s0)
    800063ac:	07e9                	addi	a5,a5,26
    800063ae:	078e                	slli	a5,a5,0x3
    800063b0:	97a6                	add	a5,a5,s1
    800063b2:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800063b6:	fc042783          	lw	a5,-64(s0)
    800063ba:	07e9                	addi	a5,a5,26
    800063bc:	078e                	slli	a5,a5,0x3
    800063be:	94be                	add	s1,s1,a5
    800063c0:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800063c4:	fd043503          	ld	a0,-48(s0)
    800063c8:	fffff097          	auipc	ra,0xfffff
    800063cc:	90c080e7          	jalr	-1780(ra) # 80004cd4 <fileclose>
    fileclose(wf);
    800063d0:	fc843503          	ld	a0,-56(s0)
    800063d4:	fffff097          	auipc	ra,0xfffff
    800063d8:	900080e7          	jalr	-1792(ra) # 80004cd4 <fileclose>
    return -1;
    800063dc:	57fd                	li	a5,-1
    800063de:	a03d                	j	8000640c <sys_pipe+0xfc>
    if(fd0 >= 0)
    800063e0:	fc442783          	lw	a5,-60(s0)
    800063e4:	0007c763          	bltz	a5,800063f2 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    800063e8:	07e9                	addi	a5,a5,26
    800063ea:	078e                	slli	a5,a5,0x3
    800063ec:	97a6                	add	a5,a5,s1
    800063ee:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800063f2:	fd043503          	ld	a0,-48(s0)
    800063f6:	fffff097          	auipc	ra,0xfffff
    800063fa:	8de080e7          	jalr	-1826(ra) # 80004cd4 <fileclose>
    fileclose(wf);
    800063fe:	fc843503          	ld	a0,-56(s0)
    80006402:	fffff097          	auipc	ra,0xfffff
    80006406:	8d2080e7          	jalr	-1838(ra) # 80004cd4 <fileclose>
    return -1;
    8000640a:	57fd                	li	a5,-1
}
    8000640c:	853e                	mv	a0,a5
    8000640e:	70e2                	ld	ra,56(sp)
    80006410:	7442                	ld	s0,48(sp)
    80006412:	74a2                	ld	s1,40(sp)
    80006414:	6121                	addi	sp,sp,64
    80006416:	8082                	ret
	...

0000000080006420 <kernelvec>:
    80006420:	7111                	addi	sp,sp,-256
    80006422:	e006                	sd	ra,0(sp)
    80006424:	e40a                	sd	sp,8(sp)
    80006426:	e80e                	sd	gp,16(sp)
    80006428:	ec12                	sd	tp,24(sp)
    8000642a:	f016                	sd	t0,32(sp)
    8000642c:	f41a                	sd	t1,40(sp)
    8000642e:	f81e                	sd	t2,48(sp)
    80006430:	fc22                	sd	s0,56(sp)
    80006432:	e0a6                	sd	s1,64(sp)
    80006434:	e4aa                	sd	a0,72(sp)
    80006436:	e8ae                	sd	a1,80(sp)
    80006438:	ecb2                	sd	a2,88(sp)
    8000643a:	f0b6                	sd	a3,96(sp)
    8000643c:	f4ba                	sd	a4,104(sp)
    8000643e:	f8be                	sd	a5,112(sp)
    80006440:	fcc2                	sd	a6,120(sp)
    80006442:	e146                	sd	a7,128(sp)
    80006444:	e54a                	sd	s2,136(sp)
    80006446:	e94e                	sd	s3,144(sp)
    80006448:	ed52                	sd	s4,152(sp)
    8000644a:	f156                	sd	s5,160(sp)
    8000644c:	f55a                	sd	s6,168(sp)
    8000644e:	f95e                	sd	s7,176(sp)
    80006450:	fd62                	sd	s8,184(sp)
    80006452:	e1e6                	sd	s9,192(sp)
    80006454:	e5ea                	sd	s10,200(sp)
    80006456:	e9ee                	sd	s11,208(sp)
    80006458:	edf2                	sd	t3,216(sp)
    8000645a:	f1f6                	sd	t4,224(sp)
    8000645c:	f5fa                	sd	t5,232(sp)
    8000645e:	f9fe                	sd	t6,240(sp)
    80006460:	b2bfc0ef          	jal	80002f8a <kerneltrap>
    80006464:	6082                	ld	ra,0(sp)
    80006466:	6122                	ld	sp,8(sp)
    80006468:	61c2                	ld	gp,16(sp)
    8000646a:	7282                	ld	t0,32(sp)
    8000646c:	7322                	ld	t1,40(sp)
    8000646e:	73c2                	ld	t2,48(sp)
    80006470:	7462                	ld	s0,56(sp)
    80006472:	6486                	ld	s1,64(sp)
    80006474:	6526                	ld	a0,72(sp)
    80006476:	65c6                	ld	a1,80(sp)
    80006478:	6666                	ld	a2,88(sp)
    8000647a:	7686                	ld	a3,96(sp)
    8000647c:	7726                	ld	a4,104(sp)
    8000647e:	77c6                	ld	a5,112(sp)
    80006480:	7866                	ld	a6,120(sp)
    80006482:	688a                	ld	a7,128(sp)
    80006484:	692a                	ld	s2,136(sp)
    80006486:	69ca                	ld	s3,144(sp)
    80006488:	6a6a                	ld	s4,152(sp)
    8000648a:	7a8a                	ld	s5,160(sp)
    8000648c:	7b2a                	ld	s6,168(sp)
    8000648e:	7bca                	ld	s7,176(sp)
    80006490:	7c6a                	ld	s8,184(sp)
    80006492:	6c8e                	ld	s9,192(sp)
    80006494:	6d2e                	ld	s10,200(sp)
    80006496:	6dce                	ld	s11,208(sp)
    80006498:	6e6e                	ld	t3,216(sp)
    8000649a:	7e8e                	ld	t4,224(sp)
    8000649c:	7f2e                	ld	t5,232(sp)
    8000649e:	7fce                	ld	t6,240(sp)
    800064a0:	6111                	addi	sp,sp,256
    800064a2:	10200073          	sret
    800064a6:	00000013          	nop
    800064aa:	00000013          	nop
    800064ae:	0001                	nop

00000000800064b0 <timervec>:
    800064b0:	34051573          	csrrw	a0,mscratch,a0
    800064b4:	e10c                	sd	a1,0(a0)
    800064b6:	e510                	sd	a2,8(a0)
    800064b8:	e914                	sd	a3,16(a0)
    800064ba:	6d0c                	ld	a1,24(a0)
    800064bc:	7110                	ld	a2,32(a0)
    800064be:	6194                	ld	a3,0(a1)
    800064c0:	96b2                	add	a3,a3,a2
    800064c2:	e194                	sd	a3,0(a1)
    800064c4:	4589                	li	a1,2
    800064c6:	14459073          	csrw	sip,a1
    800064ca:	6914                	ld	a3,16(a0)
    800064cc:	6510                	ld	a2,8(a0)
    800064ce:	610c                	ld	a1,0(a0)
    800064d0:	34051573          	csrrw	a0,mscratch,a0
    800064d4:	30200073          	mret
	...

00000000800064da <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800064da:	1141                	addi	sp,sp,-16
    800064dc:	e406                	sd	ra,8(sp)
    800064de:	e022                	sd	s0,0(sp)
    800064e0:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800064e2:	0c000737          	lui	a4,0xc000
    800064e6:	4785                	li	a5,1
    800064e8:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800064ea:	c35c                	sw	a5,4(a4)
}
    800064ec:	60a2                	ld	ra,8(sp)
    800064ee:	6402                	ld	s0,0(sp)
    800064f0:	0141                	addi	sp,sp,16
    800064f2:	8082                	ret

00000000800064f4 <plicinithart>:

void
plicinithart(void)
{
    800064f4:	1141                	addi	sp,sp,-16
    800064f6:	e406                	sd	ra,8(sp)
    800064f8:	e022                	sd	s0,0(sp)
    800064fa:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800064fc:	ffffb097          	auipc	ra,0xffffb
    80006500:	7ee080e7          	jalr	2030(ra) # 80001cea <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006504:	0085171b          	slliw	a4,a0,0x8
    80006508:	0c0027b7          	lui	a5,0xc002
    8000650c:	97ba                	add	a5,a5,a4
    8000650e:	40200713          	li	a4,1026
    80006512:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006516:	00d5151b          	slliw	a0,a0,0xd
    8000651a:	0c2017b7          	lui	a5,0xc201
    8000651e:	97aa                	add	a5,a5,a0
    80006520:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80006524:	60a2                	ld	ra,8(sp)
    80006526:	6402                	ld	s0,0(sp)
    80006528:	0141                	addi	sp,sp,16
    8000652a:	8082                	ret

000000008000652c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000652c:	1141                	addi	sp,sp,-16
    8000652e:	e406                	sd	ra,8(sp)
    80006530:	e022                	sd	s0,0(sp)
    80006532:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006534:	ffffb097          	auipc	ra,0xffffb
    80006538:	7b6080e7          	jalr	1974(ra) # 80001cea <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000653c:	00d5151b          	slliw	a0,a0,0xd
    80006540:	0c2017b7          	lui	a5,0xc201
    80006544:	97aa                	add	a5,a5,a0
  return irq;
}
    80006546:	43c8                	lw	a0,4(a5)
    80006548:	60a2                	ld	ra,8(sp)
    8000654a:	6402                	ld	s0,0(sp)
    8000654c:	0141                	addi	sp,sp,16
    8000654e:	8082                	ret

0000000080006550 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80006550:	1101                	addi	sp,sp,-32
    80006552:	ec06                	sd	ra,24(sp)
    80006554:	e822                	sd	s0,16(sp)
    80006556:	e426                	sd	s1,8(sp)
    80006558:	1000                	addi	s0,sp,32
    8000655a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000655c:	ffffb097          	auipc	ra,0xffffb
    80006560:	78e080e7          	jalr	1934(ra) # 80001cea <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006564:	00d5179b          	slliw	a5,a0,0xd
    80006568:	0c201737          	lui	a4,0xc201
    8000656c:	97ba                	add	a5,a5,a4
    8000656e:	c3c4                	sw	s1,4(a5)
}
    80006570:	60e2                	ld	ra,24(sp)
    80006572:	6442                	ld	s0,16(sp)
    80006574:	64a2                	ld	s1,8(sp)
    80006576:	6105                	addi	sp,sp,32
    80006578:	8082                	ret

000000008000657a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000657a:	1141                	addi	sp,sp,-16
    8000657c:	e406                	sd	ra,8(sp)
    8000657e:	e022                	sd	s0,0(sp)
    80006580:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80006582:	479d                	li	a5,7
    80006584:	04a7cc63          	blt	a5,a0,800065dc <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80006588:	0045c797          	auipc	a5,0x45c
    8000658c:	8a878793          	addi	a5,a5,-1880 # 80461e30 <disk>
    80006590:	97aa                	add	a5,a5,a0
    80006592:	0187c783          	lbu	a5,24(a5)
    80006596:	ebb9                	bnez	a5,800065ec <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006598:	00451693          	slli	a3,a0,0x4
    8000659c:	0045c797          	auipc	a5,0x45c
    800065a0:	89478793          	addi	a5,a5,-1900 # 80461e30 <disk>
    800065a4:	6398                	ld	a4,0(a5)
    800065a6:	9736                	add	a4,a4,a3
    800065a8:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    800065ac:	6398                	ld	a4,0(a5)
    800065ae:	9736                	add	a4,a4,a3
    800065b0:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800065b4:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800065b8:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800065bc:	97aa                	add	a5,a5,a0
    800065be:	4705                	li	a4,1
    800065c0:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800065c4:	0045c517          	auipc	a0,0x45c
    800065c8:	88450513          	addi	a0,a0,-1916 # 80461e48 <disk+0x18>
    800065cc:	ffffc097          	auipc	ra,0xffffc
    800065d0:	f6a080e7          	jalr	-150(ra) # 80002536 <wakeup>
}
    800065d4:	60a2                	ld	ra,8(sp)
    800065d6:	6402                	ld	s0,0(sp)
    800065d8:	0141                	addi	sp,sp,16
    800065da:	8082                	ret
    panic("free_desc 1");
    800065dc:	00002517          	auipc	a0,0x2
    800065e0:	21450513          	addi	a0,a0,532 # 800087f0 <etext+0x7f0>
    800065e4:	ffffa097          	auipc	ra,0xffffa
    800065e8:	f7c080e7          	jalr	-132(ra) # 80000560 <panic>
    panic("free_desc 2");
    800065ec:	00002517          	auipc	a0,0x2
    800065f0:	21450513          	addi	a0,a0,532 # 80008800 <etext+0x800>
    800065f4:	ffffa097          	auipc	ra,0xffffa
    800065f8:	f6c080e7          	jalr	-148(ra) # 80000560 <panic>

00000000800065fc <virtio_disk_init>:
{
    800065fc:	1101                	addi	sp,sp,-32
    800065fe:	ec06                	sd	ra,24(sp)
    80006600:	e822                	sd	s0,16(sp)
    80006602:	e426                	sd	s1,8(sp)
    80006604:	e04a                	sd	s2,0(sp)
    80006606:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006608:	00002597          	auipc	a1,0x2
    8000660c:	20858593          	addi	a1,a1,520 # 80008810 <etext+0x810>
    80006610:	0045c517          	auipc	a0,0x45c
    80006614:	94850513          	addi	a0,a0,-1720 # 80461f58 <disk+0x128>
    80006618:	ffffa097          	auipc	ra,0xffffa
    8000661c:	71a080e7          	jalr	1818(ra) # 80000d32 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006620:	100017b7          	lui	a5,0x10001
    80006624:	4398                	lw	a4,0(a5)
    80006626:	2701                	sext.w	a4,a4
    80006628:	747277b7          	lui	a5,0x74727
    8000662c:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006630:	16f71463          	bne	a4,a5,80006798 <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006634:	100017b7          	lui	a5,0x10001
    80006638:	43dc                	lw	a5,4(a5)
    8000663a:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000663c:	4709                	li	a4,2
    8000663e:	14e79d63          	bne	a5,a4,80006798 <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006642:	100017b7          	lui	a5,0x10001
    80006646:	479c                	lw	a5,8(a5)
    80006648:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000664a:	14e79763          	bne	a5,a4,80006798 <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000664e:	100017b7          	lui	a5,0x10001
    80006652:	47d8                	lw	a4,12(a5)
    80006654:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006656:	554d47b7          	lui	a5,0x554d4
    8000665a:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000665e:	12f71d63          	bne	a4,a5,80006798 <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006662:	100017b7          	lui	a5,0x10001
    80006666:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000666a:	4705                	li	a4,1
    8000666c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000666e:	470d                	li	a4,3
    80006670:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80006672:	10001737          	lui	a4,0x10001
    80006676:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80006678:	c7ffe6b7          	lui	a3,0xc7ffe
    8000667c:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47b9c7ef>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006680:	8f75                	and	a4,a4,a3
    80006682:	100016b7          	lui	a3,0x10001
    80006686:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006688:	472d                	li	a4,11
    8000668a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000668c:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80006690:	439c                	lw	a5,0(a5)
    80006692:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80006696:	8ba1                	andi	a5,a5,8
    80006698:	10078863          	beqz	a5,800067a8 <virtio_disk_init+0x1ac>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000669c:	100017b7          	lui	a5,0x10001
    800066a0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800066a4:	43fc                	lw	a5,68(a5)
    800066a6:	2781                	sext.w	a5,a5
    800066a8:	10079863          	bnez	a5,800067b8 <virtio_disk_init+0x1bc>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800066ac:	100017b7          	lui	a5,0x10001
    800066b0:	5bdc                	lw	a5,52(a5)
    800066b2:	2781                	sext.w	a5,a5
  if(max == 0)
    800066b4:	10078a63          	beqz	a5,800067c8 <virtio_disk_init+0x1cc>
  if(max < NUM)
    800066b8:	471d                	li	a4,7
    800066ba:	10f77f63          	bgeu	a4,a5,800067d8 <virtio_disk_init+0x1dc>
  disk.desc = kalloc();
    800066be:	ffffa097          	auipc	ra,0xffffa
    800066c2:	544080e7          	jalr	1348(ra) # 80000c02 <kalloc>
    800066c6:	0045b497          	auipc	s1,0x45b
    800066ca:	76a48493          	addi	s1,s1,1898 # 80461e30 <disk>
    800066ce:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800066d0:	ffffa097          	auipc	ra,0xffffa
    800066d4:	532080e7          	jalr	1330(ra) # 80000c02 <kalloc>
    800066d8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800066da:	ffffa097          	auipc	ra,0xffffa
    800066de:	528080e7          	jalr	1320(ra) # 80000c02 <kalloc>
    800066e2:	87aa                	mv	a5,a0
    800066e4:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800066e6:	6088                	ld	a0,0(s1)
    800066e8:	10050063          	beqz	a0,800067e8 <virtio_disk_init+0x1ec>
    800066ec:	0045b717          	auipc	a4,0x45b
    800066f0:	74c73703          	ld	a4,1868(a4) # 80461e38 <disk+0x8>
    800066f4:	cb75                	beqz	a4,800067e8 <virtio_disk_init+0x1ec>
    800066f6:	cbed                	beqz	a5,800067e8 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    800066f8:	6605                	lui	a2,0x1
    800066fa:	4581                	li	a1,0
    800066fc:	ffffa097          	auipc	ra,0xffffa
    80006700:	7c2080e7          	jalr	1986(ra) # 80000ebe <memset>
  memset(disk.avail, 0, PGSIZE);
    80006704:	0045b497          	auipc	s1,0x45b
    80006708:	72c48493          	addi	s1,s1,1836 # 80461e30 <disk>
    8000670c:	6605                	lui	a2,0x1
    8000670e:	4581                	li	a1,0
    80006710:	6488                	ld	a0,8(s1)
    80006712:	ffffa097          	auipc	ra,0xffffa
    80006716:	7ac080e7          	jalr	1964(ra) # 80000ebe <memset>
  memset(disk.used, 0, PGSIZE);
    8000671a:	6605                	lui	a2,0x1
    8000671c:	4581                	li	a1,0
    8000671e:	6888                	ld	a0,16(s1)
    80006720:	ffffa097          	auipc	ra,0xffffa
    80006724:	79e080e7          	jalr	1950(ra) # 80000ebe <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006728:	100017b7          	lui	a5,0x10001
    8000672c:	4721                	li	a4,8
    8000672e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006730:	4098                	lw	a4,0(s1)
    80006732:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006736:	40d8                	lw	a4,4(s1)
    80006738:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000673c:	649c                	ld	a5,8(s1)
    8000673e:	0007869b          	sext.w	a3,a5
    80006742:	10001737          	lui	a4,0x10001
    80006746:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    8000674a:	9781                	srai	a5,a5,0x20
    8000674c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80006750:	689c                	ld	a5,16(s1)
    80006752:	0007869b          	sext.w	a3,a5
    80006756:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000675a:	9781                	srai	a5,a5,0x20
    8000675c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80006760:	4785                	li	a5,1
    80006762:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80006764:	00f48c23          	sb	a5,24(s1)
    80006768:	00f48ca3          	sb	a5,25(s1)
    8000676c:	00f48d23          	sb	a5,26(s1)
    80006770:	00f48da3          	sb	a5,27(s1)
    80006774:	00f48e23          	sb	a5,28(s1)
    80006778:	00f48ea3          	sb	a5,29(s1)
    8000677c:	00f48f23          	sb	a5,30(s1)
    80006780:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80006784:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006788:	07272823          	sw	s2,112(a4)
}
    8000678c:	60e2                	ld	ra,24(sp)
    8000678e:	6442                	ld	s0,16(sp)
    80006790:	64a2                	ld	s1,8(sp)
    80006792:	6902                	ld	s2,0(sp)
    80006794:	6105                	addi	sp,sp,32
    80006796:	8082                	ret
    panic("could not find virtio disk");
    80006798:	00002517          	auipc	a0,0x2
    8000679c:	08850513          	addi	a0,a0,136 # 80008820 <etext+0x820>
    800067a0:	ffffa097          	auipc	ra,0xffffa
    800067a4:	dc0080e7          	jalr	-576(ra) # 80000560 <panic>
    panic("virtio disk FEATURES_OK unset");
    800067a8:	00002517          	auipc	a0,0x2
    800067ac:	09850513          	addi	a0,a0,152 # 80008840 <etext+0x840>
    800067b0:	ffffa097          	auipc	ra,0xffffa
    800067b4:	db0080e7          	jalr	-592(ra) # 80000560 <panic>
    panic("virtio disk should not be ready");
    800067b8:	00002517          	auipc	a0,0x2
    800067bc:	0a850513          	addi	a0,a0,168 # 80008860 <etext+0x860>
    800067c0:	ffffa097          	auipc	ra,0xffffa
    800067c4:	da0080e7          	jalr	-608(ra) # 80000560 <panic>
    panic("virtio disk has no queue 0");
    800067c8:	00002517          	auipc	a0,0x2
    800067cc:	0b850513          	addi	a0,a0,184 # 80008880 <etext+0x880>
    800067d0:	ffffa097          	auipc	ra,0xffffa
    800067d4:	d90080e7          	jalr	-624(ra) # 80000560 <panic>
    panic("virtio disk max queue too short");
    800067d8:	00002517          	auipc	a0,0x2
    800067dc:	0c850513          	addi	a0,a0,200 # 800088a0 <etext+0x8a0>
    800067e0:	ffffa097          	auipc	ra,0xffffa
    800067e4:	d80080e7          	jalr	-640(ra) # 80000560 <panic>
    panic("virtio disk kalloc");
    800067e8:	00002517          	auipc	a0,0x2
    800067ec:	0d850513          	addi	a0,a0,216 # 800088c0 <etext+0x8c0>
    800067f0:	ffffa097          	auipc	ra,0xffffa
    800067f4:	d70080e7          	jalr	-656(ra) # 80000560 <panic>

00000000800067f8 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800067f8:	711d                	addi	sp,sp,-96
    800067fa:	ec86                	sd	ra,88(sp)
    800067fc:	e8a2                	sd	s0,80(sp)
    800067fe:	e4a6                	sd	s1,72(sp)
    80006800:	e0ca                	sd	s2,64(sp)
    80006802:	fc4e                	sd	s3,56(sp)
    80006804:	f852                	sd	s4,48(sp)
    80006806:	f456                	sd	s5,40(sp)
    80006808:	f05a                	sd	s6,32(sp)
    8000680a:	ec5e                	sd	s7,24(sp)
    8000680c:	e862                	sd	s8,16(sp)
    8000680e:	1080                	addi	s0,sp,96
    80006810:	89aa                	mv	s3,a0
    80006812:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006814:	00c52b83          	lw	s7,12(a0)
    80006818:	001b9b9b          	slliw	s7,s7,0x1
    8000681c:	1b82                	slli	s7,s7,0x20
    8000681e:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80006822:	0045b517          	auipc	a0,0x45b
    80006826:	73650513          	addi	a0,a0,1846 # 80461f58 <disk+0x128>
    8000682a:	ffffa097          	auipc	ra,0xffffa
    8000682e:	59c080e7          	jalr	1436(ra) # 80000dc6 <acquire>
  for(int i = 0; i < NUM; i++){
    80006832:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006834:	0045ba97          	auipc	s5,0x45b
    80006838:	5fca8a93          	addi	s5,s5,1532 # 80461e30 <disk>
  for(int i = 0; i < 3; i++){
    8000683c:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    8000683e:	5c7d                	li	s8,-1
    80006840:	a885                	j	800068b0 <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    80006842:	00fa8733          	add	a4,s5,a5
    80006846:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000684a:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000684c:	0207c563          	bltz	a5,80006876 <virtio_disk_rw+0x7e>
  for(int i = 0; i < 3; i++){
    80006850:	2905                	addiw	s2,s2,1
    80006852:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80006854:	07490263          	beq	s2,s4,800068b8 <virtio_disk_rw+0xc0>
    idx[i] = alloc_desc();
    80006858:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000685a:	0045b717          	auipc	a4,0x45b
    8000685e:	5d670713          	addi	a4,a4,1494 # 80461e30 <disk>
    80006862:	4781                	li	a5,0
    if(disk.free[i]){
    80006864:	01874683          	lbu	a3,24(a4)
    80006868:	fee9                	bnez	a3,80006842 <virtio_disk_rw+0x4a>
  for(int i = 0; i < NUM; i++){
    8000686a:	2785                	addiw	a5,a5,1
    8000686c:	0705                	addi	a4,a4,1
    8000686e:	fe979be3          	bne	a5,s1,80006864 <virtio_disk_rw+0x6c>
    idx[i] = alloc_desc();
    80006872:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80006876:	03205163          	blez	s2,80006898 <virtio_disk_rw+0xa0>
        free_desc(idx[j]);
    8000687a:	fa042503          	lw	a0,-96(s0)
    8000687e:	00000097          	auipc	ra,0x0
    80006882:	cfc080e7          	jalr	-772(ra) # 8000657a <free_desc>
      for(int j = 0; j < i; j++)
    80006886:	4785                	li	a5,1
    80006888:	0127d863          	bge	a5,s2,80006898 <virtio_disk_rw+0xa0>
        free_desc(idx[j]);
    8000688c:	fa442503          	lw	a0,-92(s0)
    80006890:	00000097          	auipc	ra,0x0
    80006894:	cea080e7          	jalr	-790(ra) # 8000657a <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006898:	0045b597          	auipc	a1,0x45b
    8000689c:	6c058593          	addi	a1,a1,1728 # 80461f58 <disk+0x128>
    800068a0:	0045b517          	auipc	a0,0x45b
    800068a4:	5a850513          	addi	a0,a0,1448 # 80461e48 <disk+0x18>
    800068a8:	ffffc097          	auipc	ra,0xffffc
    800068ac:	c2a080e7          	jalr	-982(ra) # 800024d2 <sleep>
  for(int i = 0; i < 3; i++){
    800068b0:	fa040613          	addi	a2,s0,-96
    800068b4:	4901                	li	s2,0
    800068b6:	b74d                	j	80006858 <virtio_disk_rw+0x60>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800068b8:	fa042503          	lw	a0,-96(s0)
    800068bc:	00451693          	slli	a3,a0,0x4

  if(write)
    800068c0:	0045b797          	auipc	a5,0x45b
    800068c4:	57078793          	addi	a5,a5,1392 # 80461e30 <disk>
    800068c8:	00a50713          	addi	a4,a0,10
    800068cc:	0712                	slli	a4,a4,0x4
    800068ce:	973e                	add	a4,a4,a5
    800068d0:	01603633          	snez	a2,s6
    800068d4:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800068d6:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800068da:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800068de:	6398                	ld	a4,0(a5)
    800068e0:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800068e2:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    800068e6:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800068e8:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800068ea:	6390                	ld	a2,0(a5)
    800068ec:	00d605b3          	add	a1,a2,a3
    800068f0:	4741                	li	a4,16
    800068f2:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800068f4:	4805                	li	a6,1
    800068f6:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    800068fa:	fa442703          	lw	a4,-92(s0)
    800068fe:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006902:	0712                	slli	a4,a4,0x4
    80006904:	963a                	add	a2,a2,a4
    80006906:	05898593          	addi	a1,s3,88
    8000690a:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    8000690c:	0007b883          	ld	a7,0(a5)
    80006910:	9746                	add	a4,a4,a7
    80006912:	40000613          	li	a2,1024
    80006916:	c710                	sw	a2,8(a4)
  if(write)
    80006918:	001b3613          	seqz	a2,s6
    8000691c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006920:	01066633          	or	a2,a2,a6
    80006924:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80006928:	fa842583          	lw	a1,-88(s0)
    8000692c:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006930:	00250613          	addi	a2,a0,2
    80006934:	0612                	slli	a2,a2,0x4
    80006936:	963e                	add	a2,a2,a5
    80006938:	577d                	li	a4,-1
    8000693a:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000693e:	0592                	slli	a1,a1,0x4
    80006940:	98ae                	add	a7,a7,a1
    80006942:	03068713          	addi	a4,a3,48
    80006946:	973e                	add	a4,a4,a5
    80006948:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    8000694c:	6398                	ld	a4,0(a5)
    8000694e:	972e                	add	a4,a4,a1
    80006950:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006954:	4689                	li	a3,2
    80006956:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    8000695a:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000695e:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    80006962:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006966:	6794                	ld	a3,8(a5)
    80006968:	0026d703          	lhu	a4,2(a3)
    8000696c:	8b1d                	andi	a4,a4,7
    8000696e:	0706                	slli	a4,a4,0x1
    80006970:	96ba                	add	a3,a3,a4
    80006972:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80006976:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000697a:	6798                	ld	a4,8(a5)
    8000697c:	00275783          	lhu	a5,2(a4)
    80006980:	2785                	addiw	a5,a5,1
    80006982:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006986:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000698a:	100017b7          	lui	a5,0x10001
    8000698e:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006992:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80006996:	0045b917          	auipc	s2,0x45b
    8000699a:	5c290913          	addi	s2,s2,1474 # 80461f58 <disk+0x128>
  while(b->disk == 1) {
    8000699e:	84c2                	mv	s1,a6
    800069a0:	01079c63          	bne	a5,a6,800069b8 <virtio_disk_rw+0x1c0>
    sleep(b, &disk.vdisk_lock);
    800069a4:	85ca                	mv	a1,s2
    800069a6:	854e                	mv	a0,s3
    800069a8:	ffffc097          	auipc	ra,0xffffc
    800069ac:	b2a080e7          	jalr	-1238(ra) # 800024d2 <sleep>
  while(b->disk == 1) {
    800069b0:	0049a783          	lw	a5,4(s3)
    800069b4:	fe9788e3          	beq	a5,s1,800069a4 <virtio_disk_rw+0x1ac>
  }

  disk.info[idx[0]].b = 0;
    800069b8:	fa042903          	lw	s2,-96(s0)
    800069bc:	00290713          	addi	a4,s2,2
    800069c0:	0712                	slli	a4,a4,0x4
    800069c2:	0045b797          	auipc	a5,0x45b
    800069c6:	46e78793          	addi	a5,a5,1134 # 80461e30 <disk>
    800069ca:	97ba                	add	a5,a5,a4
    800069cc:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800069d0:	0045b997          	auipc	s3,0x45b
    800069d4:	46098993          	addi	s3,s3,1120 # 80461e30 <disk>
    800069d8:	00491713          	slli	a4,s2,0x4
    800069dc:	0009b783          	ld	a5,0(s3)
    800069e0:	97ba                	add	a5,a5,a4
    800069e2:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800069e6:	854a                	mv	a0,s2
    800069e8:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800069ec:	00000097          	auipc	ra,0x0
    800069f0:	b8e080e7          	jalr	-1138(ra) # 8000657a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800069f4:	8885                	andi	s1,s1,1
    800069f6:	f0ed                	bnez	s1,800069d8 <virtio_disk_rw+0x1e0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800069f8:	0045b517          	auipc	a0,0x45b
    800069fc:	56050513          	addi	a0,a0,1376 # 80461f58 <disk+0x128>
    80006a00:	ffffa097          	auipc	ra,0xffffa
    80006a04:	476080e7          	jalr	1142(ra) # 80000e76 <release>
}
    80006a08:	60e6                	ld	ra,88(sp)
    80006a0a:	6446                	ld	s0,80(sp)
    80006a0c:	64a6                	ld	s1,72(sp)
    80006a0e:	6906                	ld	s2,64(sp)
    80006a10:	79e2                	ld	s3,56(sp)
    80006a12:	7a42                	ld	s4,48(sp)
    80006a14:	7aa2                	ld	s5,40(sp)
    80006a16:	7b02                	ld	s6,32(sp)
    80006a18:	6be2                	ld	s7,24(sp)
    80006a1a:	6c42                	ld	s8,16(sp)
    80006a1c:	6125                	addi	sp,sp,96
    80006a1e:	8082                	ret

0000000080006a20 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006a20:	1101                	addi	sp,sp,-32
    80006a22:	ec06                	sd	ra,24(sp)
    80006a24:	e822                	sd	s0,16(sp)
    80006a26:	e426                	sd	s1,8(sp)
    80006a28:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006a2a:	0045b497          	auipc	s1,0x45b
    80006a2e:	40648493          	addi	s1,s1,1030 # 80461e30 <disk>
    80006a32:	0045b517          	auipc	a0,0x45b
    80006a36:	52650513          	addi	a0,a0,1318 # 80461f58 <disk+0x128>
    80006a3a:	ffffa097          	auipc	ra,0xffffa
    80006a3e:	38c080e7          	jalr	908(ra) # 80000dc6 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006a42:	100017b7          	lui	a5,0x10001
    80006a46:	53bc                	lw	a5,96(a5)
    80006a48:	8b8d                	andi	a5,a5,3
    80006a4a:	10001737          	lui	a4,0x10001
    80006a4e:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80006a50:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006a54:	689c                	ld	a5,16(s1)
    80006a56:	0204d703          	lhu	a4,32(s1)
    80006a5a:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80006a5e:	04f70863          	beq	a4,a5,80006aae <virtio_disk_intr+0x8e>
    __sync_synchronize();
    80006a62:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006a66:	6898                	ld	a4,16(s1)
    80006a68:	0204d783          	lhu	a5,32(s1)
    80006a6c:	8b9d                	andi	a5,a5,7
    80006a6e:	078e                	slli	a5,a5,0x3
    80006a70:	97ba                	add	a5,a5,a4
    80006a72:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006a74:	00278713          	addi	a4,a5,2
    80006a78:	0712                	slli	a4,a4,0x4
    80006a7a:	9726                	add	a4,a4,s1
    80006a7c:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80006a80:	e721                	bnez	a4,80006ac8 <virtio_disk_intr+0xa8>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006a82:	0789                	addi	a5,a5,2
    80006a84:	0792                	slli	a5,a5,0x4
    80006a86:	97a6                	add	a5,a5,s1
    80006a88:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80006a8a:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006a8e:	ffffc097          	auipc	ra,0xffffc
    80006a92:	aa8080e7          	jalr	-1368(ra) # 80002536 <wakeup>

    disk.used_idx += 1;
    80006a96:	0204d783          	lhu	a5,32(s1)
    80006a9a:	2785                	addiw	a5,a5,1
    80006a9c:	17c2                	slli	a5,a5,0x30
    80006a9e:	93c1                	srli	a5,a5,0x30
    80006aa0:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006aa4:	6898                	ld	a4,16(s1)
    80006aa6:	00275703          	lhu	a4,2(a4)
    80006aaa:	faf71ce3          	bne	a4,a5,80006a62 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    80006aae:	0045b517          	auipc	a0,0x45b
    80006ab2:	4aa50513          	addi	a0,a0,1194 # 80461f58 <disk+0x128>
    80006ab6:	ffffa097          	auipc	ra,0xffffa
    80006aba:	3c0080e7          	jalr	960(ra) # 80000e76 <release>
}
    80006abe:	60e2                	ld	ra,24(sp)
    80006ac0:	6442                	ld	s0,16(sp)
    80006ac2:	64a2                	ld	s1,8(sp)
    80006ac4:	6105                	addi	sp,sp,32
    80006ac6:	8082                	ret
      panic("virtio_disk_intr status");
    80006ac8:	00002517          	auipc	a0,0x2
    80006acc:	e1050513          	addi	a0,a0,-496 # 800088d8 <etext+0x8d8>
    80006ad0:	ffffa097          	auipc	ra,0xffffa
    80006ad4:	a90080e7          	jalr	-1392(ra) # 80000560 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
