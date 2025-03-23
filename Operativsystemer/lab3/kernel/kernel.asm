
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	b9010113          	addi	sp,sp,-1136 # 80008b90 <stack0>
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
    80000054:	a0078793          	addi	a5,a5,-1536 # 80008a50 <timer_scratch>
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
    80000066:	25e78793          	addi	a5,a5,606 # 800062c0 <timervec>
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
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc93f>
    800000a0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a2:	6705                	lui	a4,0x1
    800000a4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a8:	8fd9                	or	a5,a5,a4
    asm volatile("csrw mstatus, %0" : : "r"(x));
    800000aa:	30079073          	csrw	mstatus,a5
    asm volatile("csrw mepc, %0" : : "r"(x));
    800000ae:	00001797          	auipc	a5,0x1
    800000b2:	f0a78793          	addi	a5,a5,-246 # 80000fb8 <main>
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
    80000138:	738080e7          	jalr	1848(ra) # 8000286c <either_copyin>
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
    800001a0:	9f450513          	addi	a0,a0,-1548 # 80010b90 <cons>
    800001a4:	00001097          	auipc	ra,0x1
    800001a8:	b62080e7          	jalr	-1182(ra) # 80000d06 <acquire>
    while (n > 0)
    {
        // wait until interrupt handler has put some
        // input into cons.buffer.
        while (cons.r == cons.w)
    800001ac:	00011497          	auipc	s1,0x11
    800001b0:	9e448493          	addi	s1,s1,-1564 # 80010b90 <cons>
            if (killed(myproc()))
            {
                release(&cons.lock);
                return -1;
            }
            sleep(&cons.r, &cons.lock);
    800001b4:	00011917          	auipc	s2,0x11
    800001b8:	a7490913          	addi	s2,s2,-1420 # 80010c28 <cons+0x98>
    while (n > 0)
    800001bc:	0d305563          	blez	s3,80000286 <consoleread+0x106>
        while (cons.r == cons.w)
    800001c0:	0984a783          	lw	a5,152(s1)
    800001c4:	09c4a703          	lw	a4,156(s1)
    800001c8:	0af71a63          	bne	a4,a5,8000027c <consoleread+0xfc>
            if (killed(myproc()))
    800001cc:	00002097          	auipc	ra,0x2
    800001d0:	a94080e7          	jalr	-1388(ra) # 80001c60 <myproc>
    800001d4:	00002097          	auipc	ra,0x2
    800001d8:	4e8080e7          	jalr	1256(ra) # 800026bc <killed>
    800001dc:	e52d                	bnez	a0,80000246 <consoleread+0xc6>
            sleep(&cons.r, &cons.lock);
    800001de:	85a6                	mv	a1,s1
    800001e0:	854a                	mv	a0,s2
    800001e2:	00002097          	auipc	ra,0x2
    800001e6:	232080e7          	jalr	562(ra) # 80002414 <sleep>
        while (cons.r == cons.w)
    800001ea:	0984a783          	lw	a5,152(s1)
    800001ee:	09c4a703          	lw	a4,156(s1)
    800001f2:	fcf70de3          	beq	a4,a5,800001cc <consoleread+0x4c>
    800001f6:	ec5e                	sd	s7,24(sp)
        }

        c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001f8:	00011717          	auipc	a4,0x11
    800001fc:	99870713          	addi	a4,a4,-1640 # 80010b90 <cons>
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
    8000022e:	5ec080e7          	jalr	1516(ra) # 80002816 <either_copyout>
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
    8000024a:	94a50513          	addi	a0,a0,-1718 # 80010b90 <cons>
    8000024e:	00001097          	auipc	ra,0x1
    80000252:	b68080e7          	jalr	-1176(ra) # 80000db6 <release>
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
    80000274:	9af72c23          	sw	a5,-1608(a4) # 80010c28 <cons+0x98>
    80000278:	6be2                	ld	s7,24(sp)
    8000027a:	a031                	j	80000286 <consoleread+0x106>
    8000027c:	ec5e                	sd	s7,24(sp)
    8000027e:	bfad                	j	800001f8 <consoleread+0x78>
    80000280:	6be2                	ld	s7,24(sp)
    80000282:	a011                	j	80000286 <consoleread+0x106>
    80000284:	6be2                	ld	s7,24(sp)
    release(&cons.lock);
    80000286:	00011517          	auipc	a0,0x11
    8000028a:	90a50513          	addi	a0,a0,-1782 # 80010b90 <cons>
    8000028e:	00001097          	auipc	ra,0x1
    80000292:	b28080e7          	jalr	-1240(ra) # 80000db6 <release>
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
    800002f2:	8a250513          	addi	a0,a0,-1886 # 80010b90 <cons>
    800002f6:	00001097          	auipc	ra,0x1
    800002fa:	a10080e7          	jalr	-1520(ra) # 80000d06 <acquire>

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
    80000318:	5ae080e7          	jalr	1454(ra) # 800028c2 <procdump>
            }
        }
        break;
    }

    release(&cons.lock);
    8000031c:	00011517          	auipc	a0,0x11
    80000320:	87450513          	addi	a0,a0,-1932 # 80010b90 <cons>
    80000324:	00001097          	auipc	ra,0x1
    80000328:	a92080e7          	jalr	-1390(ra) # 80000db6 <release>
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
    80000342:	85270713          	addi	a4,a4,-1966 # 80010b90 <cons>
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
    8000036c:	82878793          	addi	a5,a5,-2008 # 80010b90 <cons>
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
    80000398:	8947a783          	lw	a5,-1900(a5) # 80010c28 <cons+0x98>
    8000039c:	9f1d                	subw	a4,a4,a5
    8000039e:	08000793          	li	a5,128
    800003a2:	f6f71de3          	bne	a4,a5,8000031c <consoleintr+0x3a>
    800003a6:	a0c9                	j	80000468 <consoleintr+0x186>
    800003a8:	e84a                	sd	s2,16(sp)
    800003aa:	e44e                	sd	s3,8(sp)
        while (cons.e != cons.w &&
    800003ac:	00010717          	auipc	a4,0x10
    800003b0:	7e470713          	addi	a4,a4,2020 # 80010b90 <cons>
    800003b4:	0a072783          	lw	a5,160(a4)
    800003b8:	09c72703          	lw	a4,156(a4)
               cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n')
    800003bc:	00010497          	auipc	s1,0x10
    800003c0:	7d448493          	addi	s1,s1,2004 # 80010b90 <cons>
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
    8000040a:	00010717          	auipc	a4,0x10
    8000040e:	78670713          	addi	a4,a4,1926 # 80010b90 <cons>
    80000412:	0a072783          	lw	a5,160(a4)
    80000416:	09c72703          	lw	a4,156(a4)
    8000041a:	f0f701e3          	beq	a4,a5,8000031c <consoleintr+0x3a>
            cons.e--;
    8000041e:	37fd                	addiw	a5,a5,-1
    80000420:	00011717          	auipc	a4,0x11
    80000424:	80f72823          	sw	a5,-2032(a4) # 80010c30 <cons+0xa0>
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
    8000044a:	74a78793          	addi	a5,a5,1866 # 80010b90 <cons>
    8000044e:	0a07a703          	lw	a4,160(a5)
    80000452:	0017069b          	addiw	a3,a4,1
    80000456:	8636                	mv	a2,a3
    80000458:	0ad7a023          	sw	a3,160(a5)
    8000045c:	07f77713          	andi	a4,a4,127
    80000460:	97ba                	add	a5,a5,a4
    80000462:	4729                	li	a4,10
    80000464:	00e78c23          	sb	a4,24(a5)
                cons.w = cons.e;
    80000468:	00010797          	auipc	a5,0x10
    8000046c:	7cc7a223          	sw	a2,1988(a5) # 80010c2c <cons+0x9c>
                wakeup(&cons.r);
    80000470:	00010517          	auipc	a0,0x10
    80000474:	7b850513          	addi	a0,a0,1976 # 80010c28 <cons+0x98>
    80000478:	00002097          	auipc	ra,0x2
    8000047c:	000080e7          	jalr	ra # 80002478 <wakeup>
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
    8000048e:	b8658593          	addi	a1,a1,-1146 # 80008010 <__func__.1+0x8>
    80000492:	00010517          	auipc	a0,0x10
    80000496:	6fe50513          	addi	a0,a0,1790 # 80010b90 <cons>
    8000049a:	00000097          	auipc	ra,0x0
    8000049e:	7d8080e7          	jalr	2008(ra) # 80000c72 <initlock>

    uartinit();
    800004a2:	00000097          	auipc	ra,0x0
    800004a6:	356080e7          	jalr	854(ra) # 800007f8 <uartinit>

    // connect read and write system calls
    // to consoleread and consolewrite.
    devsw[CONSOLE].read = consoleread;
    800004aa:	00021797          	auipc	a5,0x21
    800004ae:	87e78793          	addi	a5,a5,-1922 # 80020d28 <devsw>
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
    800004ee:	35680813          	addi	a6,a6,854 # 80008840 <digits>
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
    80000582:	6c07a923          	sw	zero,1746(a5) # 80010c50 <pr+0x18>
    printf("panic: ");
    80000586:	00008517          	auipc	a0,0x8
    8000058a:	a9250513          	addi	a0,a0,-1390 # 80008018 <__func__.1+0x10>
    8000058e:	00000097          	auipc	ra,0x0
    80000592:	02e080e7          	jalr	46(ra) # 800005bc <printf>
    printf(s);
    80000596:	8526                	mv	a0,s1
    80000598:	00000097          	auipc	ra,0x0
    8000059c:	024080e7          	jalr	36(ra) # 800005bc <printf>
    printf("\n");
    800005a0:	00008517          	auipc	a0,0x8
    800005a4:	a8050513          	addi	a0,a0,-1408 # 80008020 <__func__.1+0x18>
    800005a8:	00000097          	auipc	ra,0x0
    800005ac:	014080e7          	jalr	20(ra) # 800005bc <printf>
    panicked = 1; // freeze uart output from other CPUs
    800005b0:	4785                	li	a5,1
    800005b2:	00008717          	auipc	a4,0x8
    800005b6:	44f72723          	sw	a5,1102(a4) # 80008a00 <panicked>
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
    800005e0:	674dad83          	lw	s11,1652(s11) # 80010c50 <pr+0x18>
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
    80000622:	222a8a93          	addi	s5,s5,546 # 80008840 <digits>
        switch (c)
    80000626:	07300c13          	li	s8,115
    8000062a:	a0b9                	j	80000678 <printf+0xbc>
        acquire(&pr.lock);
    8000062c:	00010517          	auipc	a0,0x10
    80000630:	60c50513          	addi	a0,a0,1548 # 80010c38 <pr>
    80000634:	00000097          	auipc	ra,0x0
    80000638:	6d2080e7          	jalr	1746(ra) # 80000d06 <acquire>
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
    80000654:	9e050513          	addi	a0,a0,-1568 # 80008030 <__func__.1+0x28>
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
    80000752:	8da48493          	addi	s1,s1,-1830 # 80008028 <__func__.1+0x20>
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
    800007b8:	48450513          	addi	a0,a0,1156 # 80010c38 <pr>
    800007bc:	00000097          	auipc	ra,0x0
    800007c0:	5fa080e7          	jalr	1530(ra) # 80000db6 <release>
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
    800007d4:	46848493          	addi	s1,s1,1128 # 80010c38 <pr>
    800007d8:	00008597          	auipc	a1,0x8
    800007dc:	86858593          	addi	a1,a1,-1944 # 80008040 <__func__.1+0x38>
    800007e0:	8526                	mv	a0,s1
    800007e2:	00000097          	auipc	ra,0x0
    800007e6:	490080e7          	jalr	1168(ra) # 80000c72 <initlock>
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
    80000836:	81658593          	addi	a1,a1,-2026 # 80008048 <__func__.1+0x40>
    8000083a:	00010517          	auipc	a0,0x10
    8000083e:	41e50513          	addi	a0,a0,1054 # 80010c58 <uart_tx_lock>
    80000842:	00000097          	auipc	ra,0x0
    80000846:	430080e7          	jalr	1072(ra) # 80000c72 <initlock>
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
    80000862:	45c080e7          	jalr	1116(ra) # 80000cba <push_off>

  if(panicked){
    80000866:	00008797          	auipc	a5,0x8
    8000086a:	19a7a783          	lw	a5,410(a5) # 80008a00 <panicked>
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
    80000890:	4ce080e7          	jalr	1230(ra) # 80000d5a <pop_off>
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
    800008a4:	1687b783          	ld	a5,360(a5) # 80008a08 <uart_tx_r>
    800008a8:	00008717          	auipc	a4,0x8
    800008ac:	16873703          	ld	a4,360(a4) # 80008a10 <uart_tx_w>
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
    800008d2:	38aa8a93          	addi	s5,s5,906 # 80010c58 <uart_tx_lock>
    uart_tx_r += 1;
    800008d6:	00008497          	auipc	s1,0x8
    800008da:	13248493          	addi	s1,s1,306 # 80008a08 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008de:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008e2:	00008997          	auipc	s3,0x8
    800008e6:	12e98993          	addi	s3,s3,302 # 80008a10 <uart_tx_w>
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
    80000908:	b74080e7          	jalr	-1164(ra) # 80002478 <wakeup>
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
    80000946:	31650513          	addi	a0,a0,790 # 80010c58 <uart_tx_lock>
    8000094a:	00000097          	auipc	ra,0x0
    8000094e:	3bc080e7          	jalr	956(ra) # 80000d06 <acquire>
  if(panicked){
    80000952:	00008797          	auipc	a5,0x8
    80000956:	0ae7a783          	lw	a5,174(a5) # 80008a00 <panicked>
    8000095a:	e7c9                	bnez	a5,800009e4 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000095c:	00008717          	auipc	a4,0x8
    80000960:	0b473703          	ld	a4,180(a4) # 80008a10 <uart_tx_w>
    80000964:	00008797          	auipc	a5,0x8
    80000968:	0a47b783          	ld	a5,164(a5) # 80008a08 <uart_tx_r>
    8000096c:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000970:	00010997          	auipc	s3,0x10
    80000974:	2e898993          	addi	s3,s3,744 # 80010c58 <uart_tx_lock>
    80000978:	00008497          	auipc	s1,0x8
    8000097c:	09048493          	addi	s1,s1,144 # 80008a08 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000980:	00008917          	auipc	s2,0x8
    80000984:	09090913          	addi	s2,s2,144 # 80008a10 <uart_tx_w>
    80000988:	00e79f63          	bne	a5,a4,800009a6 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000098c:	85ce                	mv	a1,s3
    8000098e:	8526                	mv	a0,s1
    80000990:	00002097          	auipc	ra,0x2
    80000994:	a84080e7          	jalr	-1404(ra) # 80002414 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000998:	00093703          	ld	a4,0(s2)
    8000099c:	609c                	ld	a5,0(s1)
    8000099e:	02078793          	addi	a5,a5,32
    800009a2:	fee785e3          	beq	a5,a4,8000098c <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800009a6:	00010497          	auipc	s1,0x10
    800009aa:	2b248493          	addi	s1,s1,690 # 80010c58 <uart_tx_lock>
    800009ae:	01f77793          	andi	a5,a4,31
    800009b2:	97a6                	add	a5,a5,s1
    800009b4:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009b8:	0705                	addi	a4,a4,1
    800009ba:	00008797          	auipc	a5,0x8
    800009be:	04e7bb23          	sd	a4,86(a5) # 80008a10 <uart_tx_w>
  uartstart();
    800009c2:	00000097          	auipc	ra,0x0
    800009c6:	ede080e7          	jalr	-290(ra) # 800008a0 <uartstart>
  release(&uart_tx_lock);
    800009ca:	8526                	mv	a0,s1
    800009cc:	00000097          	auipc	ra,0x0
    800009d0:	3ea080e7          	jalr	1002(ra) # 80000db6 <release>
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
    80000a34:	22848493          	addi	s1,s1,552 # 80010c58 <uart_tx_lock>
    80000a38:	8526                	mv	a0,s1
    80000a3a:	00000097          	auipc	ra,0x0
    80000a3e:	2cc080e7          	jalr	716(ra) # 80000d06 <acquire>
  uartstart();
    80000a42:	00000097          	auipc	ra,0x0
    80000a46:	e5e080e7          	jalr	-418(ra) # 800008a0 <uartstart>
  release(&uart_tx_lock);
    80000a4a:	8526                	mv	a0,s1
    80000a4c:	00000097          	auipc	ra,0x0
    80000a50:	36a080e7          	jalr	874(ra) # 80000db6 <release>
}
    80000a54:	60e2                	ld	ra,24(sp)
    80000a56:	6442                	ld	s0,16(sp)
    80000a58:	64a2                	ld	s1,8(sp)
    80000a5a:	6105                	addi	sp,sp,32
    80000a5c:	8082                	ret

0000000080000a5e <kfree>:
// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa)
{
    80000a5e:	1101                	addi	sp,sp,-32
    80000a60:	ec06                	sd	ra,24(sp)
    80000a62:	e822                	sd	s0,16(sp)
    80000a64:	e426                	sd	s1,8(sp)
    80000a66:	e04a                	sd	s2,0(sp)
    80000a68:	1000                	addi	s0,sp,32
    80000a6a:	84aa                	mv	s1,a0
    if (MAX_PAGES != 0)
    80000a6c:	00008797          	auipc	a5,0x8
    80000a70:	fb47b783          	ld	a5,-76(a5) # 80008a20 <MAX_PAGES>
    80000a74:	c799                	beqz	a5,80000a82 <kfree+0x24>
        assert(FREE_PAGES < MAX_PAGES);
    80000a76:	00008717          	auipc	a4,0x8
    80000a7a:	fa273703          	ld	a4,-94(a4) # 80008a18 <FREE_PAGES>
    80000a7e:	06f77663          	bgeu	a4,a5,80000aea <kfree+0x8c>
    struct run *r;

    if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000a82:	03449793          	slli	a5,s1,0x34
    80000a86:	efc1                	bnez	a5,80000b1e <kfree+0xc0>
    80000a88:	00021797          	auipc	a5,0x21
    80000a8c:	43878793          	addi	a5,a5,1080 # 80021ec0 <end>
    80000a90:	08f4e763          	bltu	s1,a5,80000b1e <kfree+0xc0>
    80000a94:	47c5                	li	a5,17
    80000a96:	07ee                	slli	a5,a5,0x1b
    80000a98:	08f4f363          	bgeu	s1,a5,80000b1e <kfree+0xc0>
        panic("kfree");

    // Fill with junk to catch dangling refs.
    memset(pa, 1, PGSIZE);
    80000a9c:	6605                	lui	a2,0x1
    80000a9e:	4585                	li	a1,1
    80000aa0:	8526                	mv	a0,s1
    80000aa2:	00000097          	auipc	ra,0x0
    80000aa6:	35c080e7          	jalr	860(ra) # 80000dfe <memset>

    r = (struct run *)pa;

    acquire(&kmem.lock);
    80000aaa:	00010917          	auipc	s2,0x10
    80000aae:	1e690913          	addi	s2,s2,486 # 80010c90 <kmem>
    80000ab2:	854a                	mv	a0,s2
    80000ab4:	00000097          	auipc	ra,0x0
    80000ab8:	252080e7          	jalr	594(ra) # 80000d06 <acquire>
    r->next = kmem.freelist;
    80000abc:	01893783          	ld	a5,24(s2)
    80000ac0:	e09c                	sd	a5,0(s1)
    kmem.freelist = r;
    80000ac2:	00993c23          	sd	s1,24(s2)
    FREE_PAGES++;
    80000ac6:	00008717          	auipc	a4,0x8
    80000aca:	f5270713          	addi	a4,a4,-174 # 80008a18 <FREE_PAGES>
    80000ace:	631c                	ld	a5,0(a4)
    80000ad0:	0785                	addi	a5,a5,1
    80000ad2:	e31c                	sd	a5,0(a4)
    release(&kmem.lock);
    80000ad4:	854a                	mv	a0,s2
    80000ad6:	00000097          	auipc	ra,0x0
    80000ada:	2e0080e7          	jalr	736(ra) # 80000db6 <release>
}
    80000ade:	60e2                	ld	ra,24(sp)
    80000ae0:	6442                	ld	s0,16(sp)
    80000ae2:	64a2                	ld	s1,8(sp)
    80000ae4:	6902                	ld	s2,0(sp)
    80000ae6:	6105                	addi	sp,sp,32
    80000ae8:	8082                	ret
        assert(FREE_PAGES < MAX_PAGES);
    80000aea:	03700693          	li	a3,55
    80000aee:	00007617          	auipc	a2,0x7
    80000af2:	51a60613          	addi	a2,a2,1306 # 80008008 <__func__.1>
    80000af6:	00007597          	auipc	a1,0x7
    80000afa:	55a58593          	addi	a1,a1,1370 # 80008050 <__func__.1+0x48>
    80000afe:	00007517          	auipc	a0,0x7
    80000b02:	56250513          	addi	a0,a0,1378 # 80008060 <__func__.1+0x58>
    80000b06:	00000097          	auipc	ra,0x0
    80000b0a:	ab6080e7          	jalr	-1354(ra) # 800005bc <printf>
    80000b0e:	00007517          	auipc	a0,0x7
    80000b12:	56250513          	addi	a0,a0,1378 # 80008070 <__func__.1+0x68>
    80000b16:	00000097          	auipc	ra,0x0
    80000b1a:	a4a080e7          	jalr	-1462(ra) # 80000560 <panic>
        panic("kfree");
    80000b1e:	00007517          	auipc	a0,0x7
    80000b22:	56250513          	addi	a0,a0,1378 # 80008080 <__func__.1+0x78>
    80000b26:	00000097          	auipc	ra,0x0
    80000b2a:	a3a080e7          	jalr	-1478(ra) # 80000560 <panic>

0000000080000b2e <freerange>:
{
    80000b2e:	7179                	addi	sp,sp,-48
    80000b30:	f406                	sd	ra,40(sp)
    80000b32:	f022                	sd	s0,32(sp)
    80000b34:	ec26                	sd	s1,24(sp)
    80000b36:	1800                	addi	s0,sp,48
    p = (char *)PGROUNDUP((uint64)pa_start);
    80000b38:	6785                	lui	a5,0x1
    80000b3a:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000b3e:	00e504b3          	add	s1,a0,a4
    80000b42:	777d                	lui	a4,0xfffff
    80000b44:	8cf9                	and	s1,s1,a4
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000b46:	94be                	add	s1,s1,a5
    80000b48:	0295e463          	bltu	a1,s1,80000b70 <freerange+0x42>
    80000b4c:	e84a                	sd	s2,16(sp)
    80000b4e:	e44e                	sd	s3,8(sp)
    80000b50:	e052                	sd	s4,0(sp)
    80000b52:	892e                	mv	s2,a1
        kfree(p);
    80000b54:	8a3a                	mv	s4,a4
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000b56:	89be                	mv	s3,a5
        kfree(p);
    80000b58:	01448533          	add	a0,s1,s4
    80000b5c:	00000097          	auipc	ra,0x0
    80000b60:	f02080e7          	jalr	-254(ra) # 80000a5e <kfree>
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000b64:	94ce                	add	s1,s1,s3
    80000b66:	fe9979e3          	bgeu	s2,s1,80000b58 <freerange+0x2a>
    80000b6a:	6942                	ld	s2,16(sp)
    80000b6c:	69a2                	ld	s3,8(sp)
    80000b6e:	6a02                	ld	s4,0(sp)
}
    80000b70:	70a2                	ld	ra,40(sp)
    80000b72:	7402                	ld	s0,32(sp)
    80000b74:	64e2                	ld	s1,24(sp)
    80000b76:	6145                	addi	sp,sp,48
    80000b78:	8082                	ret

0000000080000b7a <kinit>:
{
    80000b7a:	1141                	addi	sp,sp,-16
    80000b7c:	e406                	sd	ra,8(sp)
    80000b7e:	e022                	sd	s0,0(sp)
    80000b80:	0800                	addi	s0,sp,16
    initlock(&kmem.lock, "kmem");
    80000b82:	00007597          	auipc	a1,0x7
    80000b86:	50658593          	addi	a1,a1,1286 # 80008088 <__func__.1+0x80>
    80000b8a:	00010517          	auipc	a0,0x10
    80000b8e:	10650513          	addi	a0,a0,262 # 80010c90 <kmem>
    80000b92:	00000097          	auipc	ra,0x0
    80000b96:	0e0080e7          	jalr	224(ra) # 80000c72 <initlock>
    freerange(end, (void *)PHYSTOP);
    80000b9a:	45c5                	li	a1,17
    80000b9c:	05ee                	slli	a1,a1,0x1b
    80000b9e:	00021517          	auipc	a0,0x21
    80000ba2:	32250513          	addi	a0,a0,802 # 80021ec0 <end>
    80000ba6:	00000097          	auipc	ra,0x0
    80000baa:	f88080e7          	jalr	-120(ra) # 80000b2e <freerange>
    MAX_PAGES = FREE_PAGES;
    80000bae:	00008797          	auipc	a5,0x8
    80000bb2:	e6a7b783          	ld	a5,-406(a5) # 80008a18 <FREE_PAGES>
    80000bb6:	00008717          	auipc	a4,0x8
    80000bba:	e6f73523          	sd	a5,-406(a4) # 80008a20 <MAX_PAGES>
}
    80000bbe:	60a2                	ld	ra,8(sp)
    80000bc0:	6402                	ld	s0,0(sp)
    80000bc2:	0141                	addi	sp,sp,16
    80000bc4:	8082                	ret

0000000080000bc6 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000bc6:	1101                	addi	sp,sp,-32
    80000bc8:	ec06                	sd	ra,24(sp)
    80000bca:	e822                	sd	s0,16(sp)
    80000bcc:	e426                	sd	s1,8(sp)
    80000bce:	1000                	addi	s0,sp,32
    assert(FREE_PAGES > 0);
    80000bd0:	00008797          	auipc	a5,0x8
    80000bd4:	e487b783          	ld	a5,-440(a5) # 80008a18 <FREE_PAGES>
    80000bd8:	cbb1                	beqz	a5,80000c2c <kalloc+0x66>
    struct run *r;

    acquire(&kmem.lock);
    80000bda:	00010497          	auipc	s1,0x10
    80000bde:	0b648493          	addi	s1,s1,182 # 80010c90 <kmem>
    80000be2:	8526                	mv	a0,s1
    80000be4:	00000097          	auipc	ra,0x0
    80000be8:	122080e7          	jalr	290(ra) # 80000d06 <acquire>
    r = kmem.freelist;
    80000bec:	6c84                	ld	s1,24(s1)
    if (r)
    80000bee:	c8ad                	beqz	s1,80000c60 <kalloc+0x9a>
        kmem.freelist = r->next;
    80000bf0:	609c                	ld	a5,0(s1)
    80000bf2:	00010517          	auipc	a0,0x10
    80000bf6:	09e50513          	addi	a0,a0,158 # 80010c90 <kmem>
    80000bfa:	ed1c                	sd	a5,24(a0)
    release(&kmem.lock);
    80000bfc:	00000097          	auipc	ra,0x0
    80000c00:	1ba080e7          	jalr	442(ra) # 80000db6 <release>

    if (r)
        memset((char *)r, 5, PGSIZE); // fill with junk
    80000c04:	6605                	lui	a2,0x1
    80000c06:	4595                	li	a1,5
    80000c08:	8526                	mv	a0,s1
    80000c0a:	00000097          	auipc	ra,0x0
    80000c0e:	1f4080e7          	jalr	500(ra) # 80000dfe <memset>
    FREE_PAGES--;
    80000c12:	00008717          	auipc	a4,0x8
    80000c16:	e0670713          	addi	a4,a4,-506 # 80008a18 <FREE_PAGES>
    80000c1a:	631c                	ld	a5,0(a4)
    80000c1c:	17fd                	addi	a5,a5,-1
    80000c1e:	e31c                	sd	a5,0(a4)
    return (void *)r;
}
    80000c20:	8526                	mv	a0,s1
    80000c22:	60e2                	ld	ra,24(sp)
    80000c24:	6442                	ld	s0,16(sp)
    80000c26:	64a2                	ld	s1,8(sp)
    80000c28:	6105                	addi	sp,sp,32
    80000c2a:	8082                	ret
    assert(FREE_PAGES > 0);
    80000c2c:	04f00693          	li	a3,79
    80000c30:	00007617          	auipc	a2,0x7
    80000c34:	3d060613          	addi	a2,a2,976 # 80008000 <etext>
    80000c38:	00007597          	auipc	a1,0x7
    80000c3c:	41858593          	addi	a1,a1,1048 # 80008050 <__func__.1+0x48>
    80000c40:	00007517          	auipc	a0,0x7
    80000c44:	42050513          	addi	a0,a0,1056 # 80008060 <__func__.1+0x58>
    80000c48:	00000097          	auipc	ra,0x0
    80000c4c:	974080e7          	jalr	-1676(ra) # 800005bc <printf>
    80000c50:	00007517          	auipc	a0,0x7
    80000c54:	42050513          	addi	a0,a0,1056 # 80008070 <__func__.1+0x68>
    80000c58:	00000097          	auipc	ra,0x0
    80000c5c:	908080e7          	jalr	-1784(ra) # 80000560 <panic>
    release(&kmem.lock);
    80000c60:	00010517          	auipc	a0,0x10
    80000c64:	03050513          	addi	a0,a0,48 # 80010c90 <kmem>
    80000c68:	00000097          	auipc	ra,0x0
    80000c6c:	14e080e7          	jalr	334(ra) # 80000db6 <release>
    if (r)
    80000c70:	b74d                	j	80000c12 <kalloc+0x4c>

0000000080000c72 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000c72:	1141                	addi	sp,sp,-16
    80000c74:	e406                	sd	ra,8(sp)
    80000c76:	e022                	sd	s0,0(sp)
    80000c78:	0800                	addi	s0,sp,16
  lk->name = name;
    80000c7a:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000c7c:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000c80:	00053823          	sd	zero,16(a0)
}
    80000c84:	60a2                	ld	ra,8(sp)
    80000c86:	6402                	ld	s0,0(sp)
    80000c88:	0141                	addi	sp,sp,16
    80000c8a:	8082                	ret

0000000080000c8c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000c8c:	411c                	lw	a5,0(a0)
    80000c8e:	e399                	bnez	a5,80000c94 <holding+0x8>
    80000c90:	4501                	li	a0,0
  return r;
}
    80000c92:	8082                	ret
{
    80000c94:	1101                	addi	sp,sp,-32
    80000c96:	ec06                	sd	ra,24(sp)
    80000c98:	e822                	sd	s0,16(sp)
    80000c9a:	e426                	sd	s1,8(sp)
    80000c9c:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000c9e:	6904                	ld	s1,16(a0)
    80000ca0:	00001097          	auipc	ra,0x1
    80000ca4:	fa0080e7          	jalr	-96(ra) # 80001c40 <mycpu>
    80000ca8:	40a48533          	sub	a0,s1,a0
    80000cac:	00153513          	seqz	a0,a0
}
    80000cb0:	60e2                	ld	ra,24(sp)
    80000cb2:	6442                	ld	s0,16(sp)
    80000cb4:	64a2                	ld	s1,8(sp)
    80000cb6:	6105                	addi	sp,sp,32
    80000cb8:	8082                	ret

0000000080000cba <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000cba:	1101                	addi	sp,sp,-32
    80000cbc:	ec06                	sd	ra,24(sp)
    80000cbe:	e822                	sd	s0,16(sp)
    80000cc0:	e426                	sd	s1,8(sp)
    80000cc2:	1000                	addi	s0,sp,32
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80000cc4:	100024f3          	csrr	s1,sstatus
    80000cc8:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000ccc:	9bf5                	andi	a5,a5,-3
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80000cce:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000cd2:	00001097          	auipc	ra,0x1
    80000cd6:	f6e080e7          	jalr	-146(ra) # 80001c40 <mycpu>
    80000cda:	5d3c                	lw	a5,120(a0)
    80000cdc:	cf89                	beqz	a5,80000cf6 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000cde:	00001097          	auipc	ra,0x1
    80000ce2:	f62080e7          	jalr	-158(ra) # 80001c40 <mycpu>
    80000ce6:	5d3c                	lw	a5,120(a0)
    80000ce8:	2785                	addiw	a5,a5,1
    80000cea:	dd3c                	sw	a5,120(a0)
}
    80000cec:	60e2                	ld	ra,24(sp)
    80000cee:	6442                	ld	s0,16(sp)
    80000cf0:	64a2                	ld	s1,8(sp)
    80000cf2:	6105                	addi	sp,sp,32
    80000cf4:	8082                	ret
    mycpu()->intena = old;
    80000cf6:	00001097          	auipc	ra,0x1
    80000cfa:	f4a080e7          	jalr	-182(ra) # 80001c40 <mycpu>
    return (x & SSTATUS_SIE) != 0;
    80000cfe:	8085                	srli	s1,s1,0x1
    80000d00:	8885                	andi	s1,s1,1
    80000d02:	dd64                	sw	s1,124(a0)
    80000d04:	bfe9                	j	80000cde <push_off+0x24>

0000000080000d06 <acquire>:
{
    80000d06:	1101                	addi	sp,sp,-32
    80000d08:	ec06                	sd	ra,24(sp)
    80000d0a:	e822                	sd	s0,16(sp)
    80000d0c:	e426                	sd	s1,8(sp)
    80000d0e:	1000                	addi	s0,sp,32
    80000d10:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000d12:	00000097          	auipc	ra,0x0
    80000d16:	fa8080e7          	jalr	-88(ra) # 80000cba <push_off>
  if(holding(lk))
    80000d1a:	8526                	mv	a0,s1
    80000d1c:	00000097          	auipc	ra,0x0
    80000d20:	f70080e7          	jalr	-144(ra) # 80000c8c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000d24:	4705                	li	a4,1
  if(holding(lk))
    80000d26:	e115                	bnez	a0,80000d4a <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000d28:	87ba                	mv	a5,a4
    80000d2a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000d2e:	2781                	sext.w	a5,a5
    80000d30:	ffe5                	bnez	a5,80000d28 <acquire+0x22>
  __sync_synchronize();
    80000d32:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000d36:	00001097          	auipc	ra,0x1
    80000d3a:	f0a080e7          	jalr	-246(ra) # 80001c40 <mycpu>
    80000d3e:	e888                	sd	a0,16(s1)
}
    80000d40:	60e2                	ld	ra,24(sp)
    80000d42:	6442                	ld	s0,16(sp)
    80000d44:	64a2                	ld	s1,8(sp)
    80000d46:	6105                	addi	sp,sp,32
    80000d48:	8082                	ret
    panic("acquire");
    80000d4a:	00007517          	auipc	a0,0x7
    80000d4e:	34650513          	addi	a0,a0,838 # 80008090 <__func__.1+0x88>
    80000d52:	00000097          	auipc	ra,0x0
    80000d56:	80e080e7          	jalr	-2034(ra) # 80000560 <panic>

0000000080000d5a <pop_off>:

void
pop_off(void)
{
    80000d5a:	1141                	addi	sp,sp,-16
    80000d5c:	e406                	sd	ra,8(sp)
    80000d5e:	e022                	sd	s0,0(sp)
    80000d60:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000d62:	00001097          	auipc	ra,0x1
    80000d66:	ede080e7          	jalr	-290(ra) # 80001c40 <mycpu>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80000d6a:	100027f3          	csrr	a5,sstatus
    return (x & SSTATUS_SIE) != 0;
    80000d6e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000d70:	e39d                	bnez	a5,80000d96 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000d72:	5d3c                	lw	a5,120(a0)
    80000d74:	02f05963          	blez	a5,80000da6 <pop_off+0x4c>
    panic("pop_off");
  c->noff -= 1;
    80000d78:	37fd                	addiw	a5,a5,-1
    80000d7a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000d7c:	eb89                	bnez	a5,80000d8e <pop_off+0x34>
    80000d7e:	5d7c                	lw	a5,124(a0)
    80000d80:	c799                	beqz	a5,80000d8e <pop_off+0x34>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80000d82:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000d86:	0027e793          	ori	a5,a5,2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80000d8a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000d8e:	60a2                	ld	ra,8(sp)
    80000d90:	6402                	ld	s0,0(sp)
    80000d92:	0141                	addi	sp,sp,16
    80000d94:	8082                	ret
    panic("pop_off - interruptible");
    80000d96:	00007517          	auipc	a0,0x7
    80000d9a:	30250513          	addi	a0,a0,770 # 80008098 <__func__.1+0x90>
    80000d9e:	fffff097          	auipc	ra,0xfffff
    80000da2:	7c2080e7          	jalr	1986(ra) # 80000560 <panic>
    panic("pop_off");
    80000da6:	00007517          	auipc	a0,0x7
    80000daa:	30a50513          	addi	a0,a0,778 # 800080b0 <__func__.1+0xa8>
    80000dae:	fffff097          	auipc	ra,0xfffff
    80000db2:	7b2080e7          	jalr	1970(ra) # 80000560 <panic>

0000000080000db6 <release>:
{
    80000db6:	1101                	addi	sp,sp,-32
    80000db8:	ec06                	sd	ra,24(sp)
    80000dba:	e822                	sd	s0,16(sp)
    80000dbc:	e426                	sd	s1,8(sp)
    80000dbe:	1000                	addi	s0,sp,32
    80000dc0:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000dc2:	00000097          	auipc	ra,0x0
    80000dc6:	eca080e7          	jalr	-310(ra) # 80000c8c <holding>
    80000dca:	c115                	beqz	a0,80000dee <release+0x38>
  lk->cpu = 0;
    80000dcc:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000dd0:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000dd4:	0310000f          	fence	rw,w
    80000dd8:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000ddc:	00000097          	auipc	ra,0x0
    80000de0:	f7e080e7          	jalr	-130(ra) # 80000d5a <pop_off>
}
    80000de4:	60e2                	ld	ra,24(sp)
    80000de6:	6442                	ld	s0,16(sp)
    80000de8:	64a2                	ld	s1,8(sp)
    80000dea:	6105                	addi	sp,sp,32
    80000dec:	8082                	ret
    panic("release");
    80000dee:	00007517          	auipc	a0,0x7
    80000df2:	2ca50513          	addi	a0,a0,714 # 800080b8 <__func__.1+0xb0>
    80000df6:	fffff097          	auipc	ra,0xfffff
    80000dfa:	76a080e7          	jalr	1898(ra) # 80000560 <panic>

0000000080000dfe <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000dfe:	1141                	addi	sp,sp,-16
    80000e00:	e406                	sd	ra,8(sp)
    80000e02:	e022                	sd	s0,0(sp)
    80000e04:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000e06:	ca19                	beqz	a2,80000e1c <memset+0x1e>
    80000e08:	87aa                	mv	a5,a0
    80000e0a:	1602                	slli	a2,a2,0x20
    80000e0c:	9201                	srli	a2,a2,0x20
    80000e0e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000e12:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000e16:	0785                	addi	a5,a5,1
    80000e18:	fee79de3          	bne	a5,a4,80000e12 <memset+0x14>
  }
  return dst;
}
    80000e1c:	60a2                	ld	ra,8(sp)
    80000e1e:	6402                	ld	s0,0(sp)
    80000e20:	0141                	addi	sp,sp,16
    80000e22:	8082                	ret

0000000080000e24 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000e24:	1141                	addi	sp,sp,-16
    80000e26:	e406                	sd	ra,8(sp)
    80000e28:	e022                	sd	s0,0(sp)
    80000e2a:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000e2c:	ca0d                	beqz	a2,80000e5e <memcmp+0x3a>
    80000e2e:	fff6069b          	addiw	a3,a2,-1
    80000e32:	1682                	slli	a3,a3,0x20
    80000e34:	9281                	srli	a3,a3,0x20
    80000e36:	0685                	addi	a3,a3,1
    80000e38:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000e3a:	00054783          	lbu	a5,0(a0)
    80000e3e:	0005c703          	lbu	a4,0(a1)
    80000e42:	00e79863          	bne	a5,a4,80000e52 <memcmp+0x2e>
      return *s1 - *s2;
    s1++, s2++;
    80000e46:	0505                	addi	a0,a0,1
    80000e48:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000e4a:	fed518e3          	bne	a0,a3,80000e3a <memcmp+0x16>
  }

  return 0;
    80000e4e:	4501                	li	a0,0
    80000e50:	a019                	j	80000e56 <memcmp+0x32>
      return *s1 - *s2;
    80000e52:	40e7853b          	subw	a0,a5,a4
}
    80000e56:	60a2                	ld	ra,8(sp)
    80000e58:	6402                	ld	s0,0(sp)
    80000e5a:	0141                	addi	sp,sp,16
    80000e5c:	8082                	ret
  return 0;
    80000e5e:	4501                	li	a0,0
    80000e60:	bfdd                	j	80000e56 <memcmp+0x32>

0000000080000e62 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000e62:	1141                	addi	sp,sp,-16
    80000e64:	e406                	sd	ra,8(sp)
    80000e66:	e022                	sd	s0,0(sp)
    80000e68:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000e6a:	c205                	beqz	a2,80000e8a <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000e6c:	02a5e363          	bltu	a1,a0,80000e92 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000e70:	1602                	slli	a2,a2,0x20
    80000e72:	9201                	srli	a2,a2,0x20
    80000e74:	00c587b3          	add	a5,a1,a2
{
    80000e78:	872a                	mv	a4,a0
      *d++ = *s++;
    80000e7a:	0585                	addi	a1,a1,1
    80000e7c:	0705                	addi	a4,a4,1
    80000e7e:	fff5c683          	lbu	a3,-1(a1)
    80000e82:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000e86:	feb79ae3          	bne	a5,a1,80000e7a <memmove+0x18>

  return dst;
}
    80000e8a:	60a2                	ld	ra,8(sp)
    80000e8c:	6402                	ld	s0,0(sp)
    80000e8e:	0141                	addi	sp,sp,16
    80000e90:	8082                	ret
  if(s < d && s + n > d){
    80000e92:	02061693          	slli	a3,a2,0x20
    80000e96:	9281                	srli	a3,a3,0x20
    80000e98:	00d58733          	add	a4,a1,a3
    80000e9c:	fce57ae3          	bgeu	a0,a4,80000e70 <memmove+0xe>
    d += n;
    80000ea0:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000ea2:	fff6079b          	addiw	a5,a2,-1
    80000ea6:	1782                	slli	a5,a5,0x20
    80000ea8:	9381                	srli	a5,a5,0x20
    80000eaa:	fff7c793          	not	a5,a5
    80000eae:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000eb0:	177d                	addi	a4,a4,-1
    80000eb2:	16fd                	addi	a3,a3,-1
    80000eb4:	00074603          	lbu	a2,0(a4)
    80000eb8:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000ebc:	fee79ae3          	bne	a5,a4,80000eb0 <memmove+0x4e>
    80000ec0:	b7e9                	j	80000e8a <memmove+0x28>

0000000080000ec2 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000ec2:	1141                	addi	sp,sp,-16
    80000ec4:	e406                	sd	ra,8(sp)
    80000ec6:	e022                	sd	s0,0(sp)
    80000ec8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000eca:	00000097          	auipc	ra,0x0
    80000ece:	f98080e7          	jalr	-104(ra) # 80000e62 <memmove>
}
    80000ed2:	60a2                	ld	ra,8(sp)
    80000ed4:	6402                	ld	s0,0(sp)
    80000ed6:	0141                	addi	sp,sp,16
    80000ed8:	8082                	ret

0000000080000eda <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000eda:	1141                	addi	sp,sp,-16
    80000edc:	e406                	sd	ra,8(sp)
    80000ede:	e022                	sd	s0,0(sp)
    80000ee0:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000ee2:	ce11                	beqz	a2,80000efe <strncmp+0x24>
    80000ee4:	00054783          	lbu	a5,0(a0)
    80000ee8:	cf89                	beqz	a5,80000f02 <strncmp+0x28>
    80000eea:	0005c703          	lbu	a4,0(a1)
    80000eee:	00f71a63          	bne	a4,a5,80000f02 <strncmp+0x28>
    n--, p++, q++;
    80000ef2:	367d                	addiw	a2,a2,-1
    80000ef4:	0505                	addi	a0,a0,1
    80000ef6:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000ef8:	f675                	bnez	a2,80000ee4 <strncmp+0xa>
  if(n == 0)
    return 0;
    80000efa:	4501                	li	a0,0
    80000efc:	a801                	j	80000f0c <strncmp+0x32>
    80000efe:	4501                	li	a0,0
    80000f00:	a031                	j	80000f0c <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    80000f02:	00054503          	lbu	a0,0(a0)
    80000f06:	0005c783          	lbu	a5,0(a1)
    80000f0a:	9d1d                	subw	a0,a0,a5
}
    80000f0c:	60a2                	ld	ra,8(sp)
    80000f0e:	6402                	ld	s0,0(sp)
    80000f10:	0141                	addi	sp,sp,16
    80000f12:	8082                	ret

0000000080000f14 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000f14:	1141                	addi	sp,sp,-16
    80000f16:	e406                	sd	ra,8(sp)
    80000f18:	e022                	sd	s0,0(sp)
    80000f1a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000f1c:	87aa                	mv	a5,a0
    80000f1e:	86b2                	mv	a3,a2
    80000f20:	367d                	addiw	a2,a2,-1
    80000f22:	02d05563          	blez	a3,80000f4c <strncpy+0x38>
    80000f26:	0785                	addi	a5,a5,1
    80000f28:	0005c703          	lbu	a4,0(a1)
    80000f2c:	fee78fa3          	sb	a4,-1(a5)
    80000f30:	0585                	addi	a1,a1,1
    80000f32:	f775                	bnez	a4,80000f1e <strncpy+0xa>
    ;
  while(n-- > 0)
    80000f34:	873e                	mv	a4,a5
    80000f36:	00c05b63          	blez	a2,80000f4c <strncpy+0x38>
    80000f3a:	9fb5                	addw	a5,a5,a3
    80000f3c:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000f3e:	0705                	addi	a4,a4,1
    80000f40:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000f44:	40e786bb          	subw	a3,a5,a4
    80000f48:	fed04be3          	bgtz	a3,80000f3e <strncpy+0x2a>
  return os;
}
    80000f4c:	60a2                	ld	ra,8(sp)
    80000f4e:	6402                	ld	s0,0(sp)
    80000f50:	0141                	addi	sp,sp,16
    80000f52:	8082                	ret

0000000080000f54 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000f54:	1141                	addi	sp,sp,-16
    80000f56:	e406                	sd	ra,8(sp)
    80000f58:	e022                	sd	s0,0(sp)
    80000f5a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000f5c:	02c05363          	blez	a2,80000f82 <safestrcpy+0x2e>
    80000f60:	fff6069b          	addiw	a3,a2,-1
    80000f64:	1682                	slli	a3,a3,0x20
    80000f66:	9281                	srli	a3,a3,0x20
    80000f68:	96ae                	add	a3,a3,a1
    80000f6a:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000f6c:	00d58963          	beq	a1,a3,80000f7e <safestrcpy+0x2a>
    80000f70:	0585                	addi	a1,a1,1
    80000f72:	0785                	addi	a5,a5,1
    80000f74:	fff5c703          	lbu	a4,-1(a1)
    80000f78:	fee78fa3          	sb	a4,-1(a5)
    80000f7c:	fb65                	bnez	a4,80000f6c <safestrcpy+0x18>
    ;
  *s = 0;
    80000f7e:	00078023          	sb	zero,0(a5)
  return os;
}
    80000f82:	60a2                	ld	ra,8(sp)
    80000f84:	6402                	ld	s0,0(sp)
    80000f86:	0141                	addi	sp,sp,16
    80000f88:	8082                	ret

0000000080000f8a <strlen>:

int
strlen(const char *s)
{
    80000f8a:	1141                	addi	sp,sp,-16
    80000f8c:	e406                	sd	ra,8(sp)
    80000f8e:	e022                	sd	s0,0(sp)
    80000f90:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000f92:	00054783          	lbu	a5,0(a0)
    80000f96:	cf99                	beqz	a5,80000fb4 <strlen+0x2a>
    80000f98:	0505                	addi	a0,a0,1
    80000f9a:	87aa                	mv	a5,a0
    80000f9c:	86be                	mv	a3,a5
    80000f9e:	0785                	addi	a5,a5,1
    80000fa0:	fff7c703          	lbu	a4,-1(a5)
    80000fa4:	ff65                	bnez	a4,80000f9c <strlen+0x12>
    80000fa6:	40a6853b          	subw	a0,a3,a0
    80000faa:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000fac:	60a2                	ld	ra,8(sp)
    80000fae:	6402                	ld	s0,0(sp)
    80000fb0:	0141                	addi	sp,sp,16
    80000fb2:	8082                	ret
  for(n = 0; s[n]; n++)
    80000fb4:	4501                	li	a0,0
    80000fb6:	bfdd                	j	80000fac <strlen+0x22>

0000000080000fb8 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000fb8:	1141                	addi	sp,sp,-16
    80000fba:	e406                	sd	ra,8(sp)
    80000fbc:	e022                	sd	s0,0(sp)
    80000fbe:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000fc0:	00001097          	auipc	ra,0x1
    80000fc4:	c6c080e7          	jalr	-916(ra) # 80001c2c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000fc8:	00008717          	auipc	a4,0x8
    80000fcc:	a6070713          	addi	a4,a4,-1440 # 80008a28 <started>
  if(cpuid() == 0){
    80000fd0:	c139                	beqz	a0,80001016 <main+0x5e>
    while(started == 0)
    80000fd2:	431c                	lw	a5,0(a4)
    80000fd4:	2781                	sext.w	a5,a5
    80000fd6:	dff5                	beqz	a5,80000fd2 <main+0x1a>
      ;
    __sync_synchronize();
    80000fd8:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000fdc:	00001097          	auipc	ra,0x1
    80000fe0:	c50080e7          	jalr	-944(ra) # 80001c2c <cpuid>
    80000fe4:	85aa                	mv	a1,a0
    80000fe6:	00007517          	auipc	a0,0x7
    80000fea:	0f250513          	addi	a0,a0,242 # 800080d8 <__func__.1+0xd0>
    80000fee:	fffff097          	auipc	ra,0xfffff
    80000ff2:	5ce080e7          	jalr	1486(ra) # 800005bc <printf>
    kvminithart();    // turn on paging
    80000ff6:	00000097          	auipc	ra,0x0
    80000ffa:	0d8080e7          	jalr	216(ra) # 800010ce <kvminithart>
    trapinithart();   // install kernel trap vector
    80000ffe:	00002097          	auipc	ra,0x2
    80001002:	ae8080e7          	jalr	-1304(ra) # 80002ae6 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80001006:	00005097          	auipc	ra,0x5
    8000100a:	2fe080e7          	jalr	766(ra) # 80006304 <plicinithart>
  }

  scheduler();        
    8000100e:	00001097          	auipc	ra,0x1
    80001012:	2e4080e7          	jalr	740(ra) # 800022f2 <scheduler>
    consoleinit();
    80001016:	fffff097          	auipc	ra,0xfffff
    8000101a:	46c080e7          	jalr	1132(ra) # 80000482 <consoleinit>
    printfinit();
    8000101e:	fffff097          	auipc	ra,0xfffff
    80001022:	7a8080e7          	jalr	1960(ra) # 800007c6 <printfinit>
    printf("\n");
    80001026:	00007517          	auipc	a0,0x7
    8000102a:	ffa50513          	addi	a0,a0,-6 # 80008020 <__func__.1+0x18>
    8000102e:	fffff097          	auipc	ra,0xfffff
    80001032:	58e080e7          	jalr	1422(ra) # 800005bc <printf>
    printf("xv6 kernel is booting\n");
    80001036:	00007517          	auipc	a0,0x7
    8000103a:	08a50513          	addi	a0,a0,138 # 800080c0 <__func__.1+0xb8>
    8000103e:	fffff097          	auipc	ra,0xfffff
    80001042:	57e080e7          	jalr	1406(ra) # 800005bc <printf>
    printf("\n");
    80001046:	00007517          	auipc	a0,0x7
    8000104a:	fda50513          	addi	a0,a0,-38 # 80008020 <__func__.1+0x18>
    8000104e:	fffff097          	auipc	ra,0xfffff
    80001052:	56e080e7          	jalr	1390(ra) # 800005bc <printf>
    kinit();         // physical page allocator
    80001056:	00000097          	auipc	ra,0x0
    8000105a:	b24080e7          	jalr	-1244(ra) # 80000b7a <kinit>
    kvminit();       // create kernel page table
    8000105e:	00000097          	auipc	ra,0x0
    80001062:	32a080e7          	jalr	810(ra) # 80001388 <kvminit>
    kvminithart();   // turn on paging
    80001066:	00000097          	auipc	ra,0x0
    8000106a:	068080e7          	jalr	104(ra) # 800010ce <kvminithart>
    procinit();      // process table
    8000106e:	00001097          	auipc	ra,0x1
    80001072:	ada080e7          	jalr	-1318(ra) # 80001b48 <procinit>
    trapinit();      // trap vectors
    80001076:	00002097          	auipc	ra,0x2
    8000107a:	a48080e7          	jalr	-1464(ra) # 80002abe <trapinit>
    trapinithart();  // install kernel trap vector
    8000107e:	00002097          	auipc	ra,0x2
    80001082:	a68080e7          	jalr	-1432(ra) # 80002ae6 <trapinithart>
    plicinit();      // set up interrupt controller
    80001086:	00005097          	auipc	ra,0x5
    8000108a:	264080e7          	jalr	612(ra) # 800062ea <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000108e:	00005097          	auipc	ra,0x5
    80001092:	276080e7          	jalr	630(ra) # 80006304 <plicinithart>
    binit();         // buffer cache
    80001096:	00002097          	auipc	ra,0x2
    8000109a:	2f6080e7          	jalr	758(ra) # 8000338c <binit>
    iinit();         // inode table
    8000109e:	00003097          	auipc	ra,0x3
    800010a2:	986080e7          	jalr	-1658(ra) # 80003a24 <iinit>
    fileinit();      // file table
    800010a6:	00004097          	auipc	ra,0x4
    800010aa:	958080e7          	jalr	-1704(ra) # 800049fe <fileinit>
    virtio_disk_init(); // emulated hard disk
    800010ae:	00005097          	auipc	ra,0x5
    800010b2:	35e080e7          	jalr	862(ra) # 8000640c <virtio_disk_init>
    userinit();      // first user process
    800010b6:	00001097          	auipc	ra,0x1
    800010ba:	e82080e7          	jalr	-382(ra) # 80001f38 <userinit>
    __sync_synchronize();
    800010be:	0330000f          	fence	rw,rw
    started = 1;
    800010c2:	4785                	li	a5,1
    800010c4:	00008717          	auipc	a4,0x8
    800010c8:	96f72223          	sw	a5,-1692(a4) # 80008a28 <started>
    800010cc:	b789                	j	8000100e <main+0x56>

00000000800010ce <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800010ce:	1141                	addi	sp,sp,-16
    800010d0:	e406                	sd	ra,8(sp)
    800010d2:	e022                	sd	s0,0(sp)
    800010d4:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
    // the zero, zero means flush all TLB entries.
    asm volatile("sfence.vma zero, zero");
    800010d6:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800010da:	00008797          	auipc	a5,0x8
    800010de:	9567b783          	ld	a5,-1706(a5) # 80008a30 <kernel_pagetable>
    800010e2:	83b1                	srli	a5,a5,0xc
    800010e4:	577d                	li	a4,-1
    800010e6:	177e                	slli	a4,a4,0x3f
    800010e8:	8fd9                	or	a5,a5,a4
    asm volatile("csrw satp, %0" : : "r"(x));
    800010ea:	18079073          	csrw	satp,a5
    asm volatile("sfence.vma zero, zero");
    800010ee:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800010f2:	60a2                	ld	ra,8(sp)
    800010f4:	6402                	ld	s0,0(sp)
    800010f6:	0141                	addi	sp,sp,16
    800010f8:	8082                	ret

00000000800010fa <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800010fa:	7139                	addi	sp,sp,-64
    800010fc:	fc06                	sd	ra,56(sp)
    800010fe:	f822                	sd	s0,48(sp)
    80001100:	f426                	sd	s1,40(sp)
    80001102:	f04a                	sd	s2,32(sp)
    80001104:	ec4e                	sd	s3,24(sp)
    80001106:	e852                	sd	s4,16(sp)
    80001108:	e456                	sd	s5,8(sp)
    8000110a:	e05a                	sd	s6,0(sp)
    8000110c:	0080                	addi	s0,sp,64
    8000110e:	84aa                	mv	s1,a0
    80001110:	89ae                	mv	s3,a1
    80001112:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80001114:	57fd                	li	a5,-1
    80001116:	83e9                	srli	a5,a5,0x1a
    80001118:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000111a:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000111c:	04b7e263          	bltu	a5,a1,80001160 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    80001120:	0149d933          	srl	s2,s3,s4
    80001124:	1ff97913          	andi	s2,s2,511
    80001128:	090e                	slli	s2,s2,0x3
    8000112a:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000112c:	00093483          	ld	s1,0(s2)
    80001130:	0014f793          	andi	a5,s1,1
    80001134:	cf95                	beqz	a5,80001170 <walk+0x76>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001136:	80a9                	srli	s1,s1,0xa
    80001138:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    8000113a:	3a5d                	addiw	s4,s4,-9
    8000113c:	ff6a12e3          	bne	s4,s6,80001120 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80001140:	00c9d513          	srli	a0,s3,0xc
    80001144:	1ff57513          	andi	a0,a0,511
    80001148:	050e                	slli	a0,a0,0x3
    8000114a:	9526                	add	a0,a0,s1
}
    8000114c:	70e2                	ld	ra,56(sp)
    8000114e:	7442                	ld	s0,48(sp)
    80001150:	74a2                	ld	s1,40(sp)
    80001152:	7902                	ld	s2,32(sp)
    80001154:	69e2                	ld	s3,24(sp)
    80001156:	6a42                	ld	s4,16(sp)
    80001158:	6aa2                	ld	s5,8(sp)
    8000115a:	6b02                	ld	s6,0(sp)
    8000115c:	6121                	addi	sp,sp,64
    8000115e:	8082                	ret
    panic("walk");
    80001160:	00007517          	auipc	a0,0x7
    80001164:	f9050513          	addi	a0,a0,-112 # 800080f0 <__func__.1+0xe8>
    80001168:	fffff097          	auipc	ra,0xfffff
    8000116c:	3f8080e7          	jalr	1016(ra) # 80000560 <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80001170:	020a8663          	beqz	s5,8000119c <walk+0xa2>
    80001174:	00000097          	auipc	ra,0x0
    80001178:	a52080e7          	jalr	-1454(ra) # 80000bc6 <kalloc>
    8000117c:	84aa                	mv	s1,a0
    8000117e:	d579                	beqz	a0,8000114c <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    80001180:	6605                	lui	a2,0x1
    80001182:	4581                	li	a1,0
    80001184:	00000097          	auipc	ra,0x0
    80001188:	c7a080e7          	jalr	-902(ra) # 80000dfe <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000118c:	00c4d793          	srli	a5,s1,0xc
    80001190:	07aa                	slli	a5,a5,0xa
    80001192:	0017e793          	ori	a5,a5,1
    80001196:	00f93023          	sd	a5,0(s2)
    8000119a:	b745                	j	8000113a <walk+0x40>
        return 0;
    8000119c:	4501                	li	a0,0
    8000119e:	b77d                	j	8000114c <walk+0x52>

00000000800011a0 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800011a0:	57fd                	li	a5,-1
    800011a2:	83e9                	srli	a5,a5,0x1a
    800011a4:	00b7f463          	bgeu	a5,a1,800011ac <walkaddr+0xc>
    return 0;
    800011a8:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800011aa:	8082                	ret
{
    800011ac:	1141                	addi	sp,sp,-16
    800011ae:	e406                	sd	ra,8(sp)
    800011b0:	e022                	sd	s0,0(sp)
    800011b2:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800011b4:	4601                	li	a2,0
    800011b6:	00000097          	auipc	ra,0x0
    800011ba:	f44080e7          	jalr	-188(ra) # 800010fa <walk>
  if(pte == 0)
    800011be:	c105                	beqz	a0,800011de <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800011c0:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800011c2:	0117f693          	andi	a3,a5,17
    800011c6:	4745                	li	a4,17
    return 0;
    800011c8:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800011ca:	00e68663          	beq	a3,a4,800011d6 <walkaddr+0x36>
}
    800011ce:	60a2                	ld	ra,8(sp)
    800011d0:	6402                	ld	s0,0(sp)
    800011d2:	0141                	addi	sp,sp,16
    800011d4:	8082                	ret
  pa = PTE2PA(*pte);
    800011d6:	83a9                	srli	a5,a5,0xa
    800011d8:	00c79513          	slli	a0,a5,0xc
  return pa;
    800011dc:	bfcd                	j	800011ce <walkaddr+0x2e>
    return 0;
    800011de:	4501                	li	a0,0
    800011e0:	b7fd                	j	800011ce <walkaddr+0x2e>

00000000800011e2 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800011e2:	715d                	addi	sp,sp,-80
    800011e4:	e486                	sd	ra,72(sp)
    800011e6:	e0a2                	sd	s0,64(sp)
    800011e8:	fc26                	sd	s1,56(sp)
    800011ea:	f84a                	sd	s2,48(sp)
    800011ec:	f44e                	sd	s3,40(sp)
    800011ee:	f052                	sd	s4,32(sp)
    800011f0:	ec56                	sd	s5,24(sp)
    800011f2:	e85a                	sd	s6,16(sp)
    800011f4:	e45e                	sd	s7,8(sp)
    800011f6:	e062                	sd	s8,0(sp)
    800011f8:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800011fa:	ca21                	beqz	a2,8000124a <mappages+0x68>
    800011fc:	8aaa                	mv	s5,a0
    800011fe:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80001200:	777d                	lui	a4,0xfffff
    80001202:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80001206:	fff58993          	addi	s3,a1,-1
    8000120a:	99b2                	add	s3,s3,a2
    8000120c:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80001210:	893e                	mv	s2,a5
    80001212:	40f68a33          	sub	s4,a3,a5
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    80001216:	4b85                	li	s7,1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001218:	6c05                	lui	s8,0x1
    8000121a:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    8000121e:	865e                	mv	a2,s7
    80001220:	85ca                	mv	a1,s2
    80001222:	8556                	mv	a0,s5
    80001224:	00000097          	auipc	ra,0x0
    80001228:	ed6080e7          	jalr	-298(ra) # 800010fa <walk>
    8000122c:	cd1d                	beqz	a0,8000126a <mappages+0x88>
    if(*pte & PTE_V)
    8000122e:	611c                	ld	a5,0(a0)
    80001230:	8b85                	andi	a5,a5,1
    80001232:	e785                	bnez	a5,8000125a <mappages+0x78>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001234:	80b1                	srli	s1,s1,0xc
    80001236:	04aa                	slli	s1,s1,0xa
    80001238:	0164e4b3          	or	s1,s1,s6
    8000123c:	0014e493          	ori	s1,s1,1
    80001240:	e104                	sd	s1,0(a0)
    if(a == last)
    80001242:	05390163          	beq	s2,s3,80001284 <mappages+0xa2>
    a += PGSIZE;
    80001246:	9962                	add	s2,s2,s8
    if((pte = walk(pagetable, a, 1)) == 0)
    80001248:	bfc9                	j	8000121a <mappages+0x38>
    panic("mappages: size");
    8000124a:	00007517          	auipc	a0,0x7
    8000124e:	eae50513          	addi	a0,a0,-338 # 800080f8 <__func__.1+0xf0>
    80001252:	fffff097          	auipc	ra,0xfffff
    80001256:	30e080e7          	jalr	782(ra) # 80000560 <panic>
      panic("mappages: remap");
    8000125a:	00007517          	auipc	a0,0x7
    8000125e:	eae50513          	addi	a0,a0,-338 # 80008108 <__func__.1+0x100>
    80001262:	fffff097          	auipc	ra,0xfffff
    80001266:	2fe080e7          	jalr	766(ra) # 80000560 <panic>
      return -1;
    8000126a:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000126c:	60a6                	ld	ra,72(sp)
    8000126e:	6406                	ld	s0,64(sp)
    80001270:	74e2                	ld	s1,56(sp)
    80001272:	7942                	ld	s2,48(sp)
    80001274:	79a2                	ld	s3,40(sp)
    80001276:	7a02                	ld	s4,32(sp)
    80001278:	6ae2                	ld	s5,24(sp)
    8000127a:	6b42                	ld	s6,16(sp)
    8000127c:	6ba2                	ld	s7,8(sp)
    8000127e:	6c02                	ld	s8,0(sp)
    80001280:	6161                	addi	sp,sp,80
    80001282:	8082                	ret
  return 0;
    80001284:	4501                	li	a0,0
    80001286:	b7dd                	j	8000126c <mappages+0x8a>

0000000080001288 <kvmmap>:
{
    80001288:	1141                	addi	sp,sp,-16
    8000128a:	e406                	sd	ra,8(sp)
    8000128c:	e022                	sd	s0,0(sp)
    8000128e:	0800                	addi	s0,sp,16
    80001290:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001292:	86b2                	mv	a3,a2
    80001294:	863e                	mv	a2,a5
    80001296:	00000097          	auipc	ra,0x0
    8000129a:	f4c080e7          	jalr	-180(ra) # 800011e2 <mappages>
    8000129e:	e509                	bnez	a0,800012a8 <kvmmap+0x20>
}
    800012a0:	60a2                	ld	ra,8(sp)
    800012a2:	6402                	ld	s0,0(sp)
    800012a4:	0141                	addi	sp,sp,16
    800012a6:	8082                	ret
    panic("kvmmap");
    800012a8:	00007517          	auipc	a0,0x7
    800012ac:	e7050513          	addi	a0,a0,-400 # 80008118 <__func__.1+0x110>
    800012b0:	fffff097          	auipc	ra,0xfffff
    800012b4:	2b0080e7          	jalr	688(ra) # 80000560 <panic>

00000000800012b8 <kvmmake>:
{
    800012b8:	1101                	addi	sp,sp,-32
    800012ba:	ec06                	sd	ra,24(sp)
    800012bc:	e822                	sd	s0,16(sp)
    800012be:	e426                	sd	s1,8(sp)
    800012c0:	e04a                	sd	s2,0(sp)
    800012c2:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800012c4:	00000097          	auipc	ra,0x0
    800012c8:	902080e7          	jalr	-1790(ra) # 80000bc6 <kalloc>
    800012cc:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800012ce:	6605                	lui	a2,0x1
    800012d0:	4581                	li	a1,0
    800012d2:	00000097          	auipc	ra,0x0
    800012d6:	b2c080e7          	jalr	-1236(ra) # 80000dfe <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800012da:	4719                	li	a4,6
    800012dc:	6685                	lui	a3,0x1
    800012de:	10000637          	lui	a2,0x10000
    800012e2:	85b2                	mv	a1,a2
    800012e4:	8526                	mv	a0,s1
    800012e6:	00000097          	auipc	ra,0x0
    800012ea:	fa2080e7          	jalr	-94(ra) # 80001288 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800012ee:	4719                	li	a4,6
    800012f0:	6685                	lui	a3,0x1
    800012f2:	10001637          	lui	a2,0x10001
    800012f6:	85b2                	mv	a1,a2
    800012f8:	8526                	mv	a0,s1
    800012fa:	00000097          	auipc	ra,0x0
    800012fe:	f8e080e7          	jalr	-114(ra) # 80001288 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001302:	4719                	li	a4,6
    80001304:	004006b7          	lui	a3,0x400
    80001308:	0c000637          	lui	a2,0xc000
    8000130c:	85b2                	mv	a1,a2
    8000130e:	8526                	mv	a0,s1
    80001310:	00000097          	auipc	ra,0x0
    80001314:	f78080e7          	jalr	-136(ra) # 80001288 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001318:	00007917          	auipc	s2,0x7
    8000131c:	ce890913          	addi	s2,s2,-792 # 80008000 <etext>
    80001320:	4729                	li	a4,10
    80001322:	80007697          	auipc	a3,0x80007
    80001326:	cde68693          	addi	a3,a3,-802 # 8000 <_entry-0x7fff8000>
    8000132a:	4605                	li	a2,1
    8000132c:	067e                	slli	a2,a2,0x1f
    8000132e:	85b2                	mv	a1,a2
    80001330:	8526                	mv	a0,s1
    80001332:	00000097          	auipc	ra,0x0
    80001336:	f56080e7          	jalr	-170(ra) # 80001288 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000133a:	4719                	li	a4,6
    8000133c:	46c5                	li	a3,17
    8000133e:	06ee                	slli	a3,a3,0x1b
    80001340:	412686b3          	sub	a3,a3,s2
    80001344:	864a                	mv	a2,s2
    80001346:	85ca                	mv	a1,s2
    80001348:	8526                	mv	a0,s1
    8000134a:	00000097          	auipc	ra,0x0
    8000134e:	f3e080e7          	jalr	-194(ra) # 80001288 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001352:	4729                	li	a4,10
    80001354:	6685                	lui	a3,0x1
    80001356:	00006617          	auipc	a2,0x6
    8000135a:	caa60613          	addi	a2,a2,-854 # 80007000 <_trampoline>
    8000135e:	040005b7          	lui	a1,0x4000
    80001362:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001364:	05b2                	slli	a1,a1,0xc
    80001366:	8526                	mv	a0,s1
    80001368:	00000097          	auipc	ra,0x0
    8000136c:	f20080e7          	jalr	-224(ra) # 80001288 <kvmmap>
  proc_mapstacks(kpgtbl);
    80001370:	8526                	mv	a0,s1
    80001372:	00000097          	auipc	ra,0x0
    80001376:	72c080e7          	jalr	1836(ra) # 80001a9e <proc_mapstacks>
}
    8000137a:	8526                	mv	a0,s1
    8000137c:	60e2                	ld	ra,24(sp)
    8000137e:	6442                	ld	s0,16(sp)
    80001380:	64a2                	ld	s1,8(sp)
    80001382:	6902                	ld	s2,0(sp)
    80001384:	6105                	addi	sp,sp,32
    80001386:	8082                	ret

0000000080001388 <kvminit>:
{
    80001388:	1141                	addi	sp,sp,-16
    8000138a:	e406                	sd	ra,8(sp)
    8000138c:	e022                	sd	s0,0(sp)
    8000138e:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80001390:	00000097          	auipc	ra,0x0
    80001394:	f28080e7          	jalr	-216(ra) # 800012b8 <kvmmake>
    80001398:	00007797          	auipc	a5,0x7
    8000139c:	68a7bc23          	sd	a0,1688(a5) # 80008a30 <kernel_pagetable>
}
    800013a0:	60a2                	ld	ra,8(sp)
    800013a2:	6402                	ld	s0,0(sp)
    800013a4:	0141                	addi	sp,sp,16
    800013a6:	8082                	ret

00000000800013a8 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800013a8:	715d                	addi	sp,sp,-80
    800013aa:	e486                	sd	ra,72(sp)
    800013ac:	e0a2                	sd	s0,64(sp)
    800013ae:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800013b0:	03459793          	slli	a5,a1,0x34
    800013b4:	e39d                	bnez	a5,800013da <uvmunmap+0x32>
    800013b6:	f84a                	sd	s2,48(sp)
    800013b8:	f44e                	sd	s3,40(sp)
    800013ba:	f052                	sd	s4,32(sp)
    800013bc:	ec56                	sd	s5,24(sp)
    800013be:	e85a                	sd	s6,16(sp)
    800013c0:	e45e                	sd	s7,8(sp)
    800013c2:	8a2a                	mv	s4,a0
    800013c4:	892e                	mv	s2,a1
    800013c6:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800013c8:	0632                	slli	a2,a2,0xc
    800013ca:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800013ce:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800013d0:	6b05                	lui	s6,0x1
    800013d2:	0935fb63          	bgeu	a1,s3,80001468 <uvmunmap+0xc0>
    800013d6:	fc26                	sd	s1,56(sp)
    800013d8:	a8a9                	j	80001432 <uvmunmap+0x8a>
    800013da:	fc26                	sd	s1,56(sp)
    800013dc:	f84a                	sd	s2,48(sp)
    800013de:	f44e                	sd	s3,40(sp)
    800013e0:	f052                	sd	s4,32(sp)
    800013e2:	ec56                	sd	s5,24(sp)
    800013e4:	e85a                	sd	s6,16(sp)
    800013e6:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800013e8:	00007517          	auipc	a0,0x7
    800013ec:	d3850513          	addi	a0,a0,-712 # 80008120 <__func__.1+0x118>
    800013f0:	fffff097          	auipc	ra,0xfffff
    800013f4:	170080e7          	jalr	368(ra) # 80000560 <panic>
      panic("uvmunmap: walk");
    800013f8:	00007517          	auipc	a0,0x7
    800013fc:	d4050513          	addi	a0,a0,-704 # 80008138 <__func__.1+0x130>
    80001400:	fffff097          	auipc	ra,0xfffff
    80001404:	160080e7          	jalr	352(ra) # 80000560 <panic>
      panic("uvmunmap: not mapped");
    80001408:	00007517          	auipc	a0,0x7
    8000140c:	d4050513          	addi	a0,a0,-704 # 80008148 <__func__.1+0x140>
    80001410:	fffff097          	auipc	ra,0xfffff
    80001414:	150080e7          	jalr	336(ra) # 80000560 <panic>
      panic("uvmunmap: not a leaf");
    80001418:	00007517          	auipc	a0,0x7
    8000141c:	d4850513          	addi	a0,a0,-696 # 80008160 <__func__.1+0x158>
    80001420:	fffff097          	auipc	ra,0xfffff
    80001424:	140080e7          	jalr	320(ra) # 80000560 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80001428:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000142c:	995a                	add	s2,s2,s6
    8000142e:	03397c63          	bgeu	s2,s3,80001466 <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001432:	4601                	li	a2,0
    80001434:	85ca                	mv	a1,s2
    80001436:	8552                	mv	a0,s4
    80001438:	00000097          	auipc	ra,0x0
    8000143c:	cc2080e7          	jalr	-830(ra) # 800010fa <walk>
    80001440:	84aa                	mv	s1,a0
    80001442:	d95d                	beqz	a0,800013f8 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    80001444:	6108                	ld	a0,0(a0)
    80001446:	00157793          	andi	a5,a0,1
    8000144a:	dfdd                	beqz	a5,80001408 <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000144c:	3ff57793          	andi	a5,a0,1023
    80001450:	fd7784e3          	beq	a5,s7,80001418 <uvmunmap+0x70>
    if(do_free){
    80001454:	fc0a8ae3          	beqz	s5,80001428 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    80001458:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000145a:	0532                	slli	a0,a0,0xc
    8000145c:	fffff097          	auipc	ra,0xfffff
    80001460:	602080e7          	jalr	1538(ra) # 80000a5e <kfree>
    80001464:	b7d1                	j	80001428 <uvmunmap+0x80>
    80001466:	74e2                	ld	s1,56(sp)
    80001468:	7942                	ld	s2,48(sp)
    8000146a:	79a2                	ld	s3,40(sp)
    8000146c:	7a02                	ld	s4,32(sp)
    8000146e:	6ae2                	ld	s5,24(sp)
    80001470:	6b42                	ld	s6,16(sp)
    80001472:	6ba2                	ld	s7,8(sp)
  }
}
    80001474:	60a6                	ld	ra,72(sp)
    80001476:	6406                	ld	s0,64(sp)
    80001478:	6161                	addi	sp,sp,80
    8000147a:	8082                	ret

000000008000147c <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000147c:	1101                	addi	sp,sp,-32
    8000147e:	ec06                	sd	ra,24(sp)
    80001480:	e822                	sd	s0,16(sp)
    80001482:	e426                	sd	s1,8(sp)
    80001484:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001486:	fffff097          	auipc	ra,0xfffff
    8000148a:	740080e7          	jalr	1856(ra) # 80000bc6 <kalloc>
    8000148e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001490:	c519                	beqz	a0,8000149e <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001492:	6605                	lui	a2,0x1
    80001494:	4581                	li	a1,0
    80001496:	00000097          	auipc	ra,0x0
    8000149a:	968080e7          	jalr	-1688(ra) # 80000dfe <memset>
  return pagetable;
}
    8000149e:	8526                	mv	a0,s1
    800014a0:	60e2                	ld	ra,24(sp)
    800014a2:	6442                	ld	s0,16(sp)
    800014a4:	64a2                	ld	s1,8(sp)
    800014a6:	6105                	addi	sp,sp,32
    800014a8:	8082                	ret

00000000800014aa <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800014aa:	7179                	addi	sp,sp,-48
    800014ac:	f406                	sd	ra,40(sp)
    800014ae:	f022                	sd	s0,32(sp)
    800014b0:	ec26                	sd	s1,24(sp)
    800014b2:	e84a                	sd	s2,16(sp)
    800014b4:	e44e                	sd	s3,8(sp)
    800014b6:	e052                	sd	s4,0(sp)
    800014b8:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800014ba:	6785                	lui	a5,0x1
    800014bc:	04f67863          	bgeu	a2,a5,8000150c <uvmfirst+0x62>
    800014c0:	8a2a                	mv	s4,a0
    800014c2:	89ae                	mv	s3,a1
    800014c4:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800014c6:	fffff097          	auipc	ra,0xfffff
    800014ca:	700080e7          	jalr	1792(ra) # 80000bc6 <kalloc>
    800014ce:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800014d0:	6605                	lui	a2,0x1
    800014d2:	4581                	li	a1,0
    800014d4:	00000097          	auipc	ra,0x0
    800014d8:	92a080e7          	jalr	-1750(ra) # 80000dfe <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800014dc:	4779                	li	a4,30
    800014de:	86ca                	mv	a3,s2
    800014e0:	6605                	lui	a2,0x1
    800014e2:	4581                	li	a1,0
    800014e4:	8552                	mv	a0,s4
    800014e6:	00000097          	auipc	ra,0x0
    800014ea:	cfc080e7          	jalr	-772(ra) # 800011e2 <mappages>
  memmove(mem, src, sz);
    800014ee:	8626                	mv	a2,s1
    800014f0:	85ce                	mv	a1,s3
    800014f2:	854a                	mv	a0,s2
    800014f4:	00000097          	auipc	ra,0x0
    800014f8:	96e080e7          	jalr	-1682(ra) # 80000e62 <memmove>
}
    800014fc:	70a2                	ld	ra,40(sp)
    800014fe:	7402                	ld	s0,32(sp)
    80001500:	64e2                	ld	s1,24(sp)
    80001502:	6942                	ld	s2,16(sp)
    80001504:	69a2                	ld	s3,8(sp)
    80001506:	6a02                	ld	s4,0(sp)
    80001508:	6145                	addi	sp,sp,48
    8000150a:	8082                	ret
    panic("uvmfirst: more than a page");
    8000150c:	00007517          	auipc	a0,0x7
    80001510:	c6c50513          	addi	a0,a0,-916 # 80008178 <__func__.1+0x170>
    80001514:	fffff097          	auipc	ra,0xfffff
    80001518:	04c080e7          	jalr	76(ra) # 80000560 <panic>

000000008000151c <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000151c:	1101                	addi	sp,sp,-32
    8000151e:	ec06                	sd	ra,24(sp)
    80001520:	e822                	sd	s0,16(sp)
    80001522:	e426                	sd	s1,8(sp)
    80001524:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001526:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001528:	00b67d63          	bgeu	a2,a1,80001542 <uvmdealloc+0x26>
    8000152c:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000152e:	6785                	lui	a5,0x1
    80001530:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001532:	00f60733          	add	a4,a2,a5
    80001536:	76fd                	lui	a3,0xfffff
    80001538:	8f75                	and	a4,a4,a3
    8000153a:	97ae                	add	a5,a5,a1
    8000153c:	8ff5                	and	a5,a5,a3
    8000153e:	00f76863          	bltu	a4,a5,8000154e <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001542:	8526                	mv	a0,s1
    80001544:	60e2                	ld	ra,24(sp)
    80001546:	6442                	ld	s0,16(sp)
    80001548:	64a2                	ld	s1,8(sp)
    8000154a:	6105                	addi	sp,sp,32
    8000154c:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000154e:	8f99                	sub	a5,a5,a4
    80001550:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001552:	4685                	li	a3,1
    80001554:	0007861b          	sext.w	a2,a5
    80001558:	85ba                	mv	a1,a4
    8000155a:	00000097          	auipc	ra,0x0
    8000155e:	e4e080e7          	jalr	-434(ra) # 800013a8 <uvmunmap>
    80001562:	b7c5                	j	80001542 <uvmdealloc+0x26>

0000000080001564 <uvmalloc>:
  if(newsz < oldsz)
    80001564:	0ab66f63          	bltu	a2,a1,80001622 <uvmalloc+0xbe>
{
    80001568:	715d                	addi	sp,sp,-80
    8000156a:	e486                	sd	ra,72(sp)
    8000156c:	e0a2                	sd	s0,64(sp)
    8000156e:	f052                	sd	s4,32(sp)
    80001570:	ec56                	sd	s5,24(sp)
    80001572:	e85a                	sd	s6,16(sp)
    80001574:	0880                	addi	s0,sp,80
    80001576:	8b2a                	mv	s6,a0
    80001578:	8ab2                	mv	s5,a2
  oldsz = PGROUNDUP(oldsz);
    8000157a:	6785                	lui	a5,0x1
    8000157c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000157e:	95be                	add	a1,a1,a5
    80001580:	77fd                	lui	a5,0xfffff
    80001582:	00f5fa33          	and	s4,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001586:	0aca7063          	bgeu	s4,a2,80001626 <uvmalloc+0xc2>
    8000158a:	fc26                	sd	s1,56(sp)
    8000158c:	f84a                	sd	s2,48(sp)
    8000158e:	f44e                	sd	s3,40(sp)
    80001590:	e45e                	sd	s7,8(sp)
    80001592:	8952                	mv	s2,s4
    memset(mem, 0, PGSIZE);
    80001594:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001596:	0126eb93          	ori	s7,a3,18
    mem = kalloc();
    8000159a:	fffff097          	auipc	ra,0xfffff
    8000159e:	62c080e7          	jalr	1580(ra) # 80000bc6 <kalloc>
    800015a2:	84aa                	mv	s1,a0
    if(mem == 0){
    800015a4:	c915                	beqz	a0,800015d8 <uvmalloc+0x74>
    memset(mem, 0, PGSIZE);
    800015a6:	864e                	mv	a2,s3
    800015a8:	4581                	li	a1,0
    800015aa:	00000097          	auipc	ra,0x0
    800015ae:	854080e7          	jalr	-1964(ra) # 80000dfe <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800015b2:	875e                	mv	a4,s7
    800015b4:	86a6                	mv	a3,s1
    800015b6:	864e                	mv	a2,s3
    800015b8:	85ca                	mv	a1,s2
    800015ba:	855a                	mv	a0,s6
    800015bc:	00000097          	auipc	ra,0x0
    800015c0:	c26080e7          	jalr	-986(ra) # 800011e2 <mappages>
    800015c4:	ed0d                	bnez	a0,800015fe <uvmalloc+0x9a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800015c6:	994e                	add	s2,s2,s3
    800015c8:	fd5969e3          	bltu	s2,s5,8000159a <uvmalloc+0x36>
  return newsz;
    800015cc:	8556                	mv	a0,s5
    800015ce:	74e2                	ld	s1,56(sp)
    800015d0:	7942                	ld	s2,48(sp)
    800015d2:	79a2                	ld	s3,40(sp)
    800015d4:	6ba2                	ld	s7,8(sp)
    800015d6:	a829                	j	800015f0 <uvmalloc+0x8c>
      uvmdealloc(pagetable, a, oldsz);
    800015d8:	8652                	mv	a2,s4
    800015da:	85ca                	mv	a1,s2
    800015dc:	855a                	mv	a0,s6
    800015de:	00000097          	auipc	ra,0x0
    800015e2:	f3e080e7          	jalr	-194(ra) # 8000151c <uvmdealloc>
      return 0;
    800015e6:	4501                	li	a0,0
    800015e8:	74e2                	ld	s1,56(sp)
    800015ea:	7942                	ld	s2,48(sp)
    800015ec:	79a2                	ld	s3,40(sp)
    800015ee:	6ba2                	ld	s7,8(sp)
}
    800015f0:	60a6                	ld	ra,72(sp)
    800015f2:	6406                	ld	s0,64(sp)
    800015f4:	7a02                	ld	s4,32(sp)
    800015f6:	6ae2                	ld	s5,24(sp)
    800015f8:	6b42                	ld	s6,16(sp)
    800015fa:	6161                	addi	sp,sp,80
    800015fc:	8082                	ret
      kfree(mem);
    800015fe:	8526                	mv	a0,s1
    80001600:	fffff097          	auipc	ra,0xfffff
    80001604:	45e080e7          	jalr	1118(ra) # 80000a5e <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001608:	8652                	mv	a2,s4
    8000160a:	85ca                	mv	a1,s2
    8000160c:	855a                	mv	a0,s6
    8000160e:	00000097          	auipc	ra,0x0
    80001612:	f0e080e7          	jalr	-242(ra) # 8000151c <uvmdealloc>
      return 0;
    80001616:	4501                	li	a0,0
    80001618:	74e2                	ld	s1,56(sp)
    8000161a:	7942                	ld	s2,48(sp)
    8000161c:	79a2                	ld	s3,40(sp)
    8000161e:	6ba2                	ld	s7,8(sp)
    80001620:	bfc1                	j	800015f0 <uvmalloc+0x8c>
    return oldsz;
    80001622:	852e                	mv	a0,a1
}
    80001624:	8082                	ret
  return newsz;
    80001626:	8532                	mv	a0,a2
    80001628:	b7e1                	j	800015f0 <uvmalloc+0x8c>

000000008000162a <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000162a:	7179                	addi	sp,sp,-48
    8000162c:	f406                	sd	ra,40(sp)
    8000162e:	f022                	sd	s0,32(sp)
    80001630:	ec26                	sd	s1,24(sp)
    80001632:	e84a                	sd	s2,16(sp)
    80001634:	e44e                	sd	s3,8(sp)
    80001636:	e052                	sd	s4,0(sp)
    80001638:	1800                	addi	s0,sp,48
    8000163a:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000163c:	84aa                	mv	s1,a0
    8000163e:	6905                	lui	s2,0x1
    80001640:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001642:	4985                	li	s3,1
    80001644:	a829                	j	8000165e <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001646:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001648:	00c79513          	slli	a0,a5,0xc
    8000164c:	00000097          	auipc	ra,0x0
    80001650:	fde080e7          	jalr	-34(ra) # 8000162a <freewalk>
      pagetable[i] = 0;
    80001654:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001658:	04a1                	addi	s1,s1,8
    8000165a:	03248163          	beq	s1,s2,8000167c <freewalk+0x52>
    pte_t pte = pagetable[i];
    8000165e:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001660:	00f7f713          	andi	a4,a5,15
    80001664:	ff3701e3          	beq	a4,s3,80001646 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001668:	8b85                	andi	a5,a5,1
    8000166a:	d7fd                	beqz	a5,80001658 <freewalk+0x2e>
      panic("freewalk: leaf");
    8000166c:	00007517          	auipc	a0,0x7
    80001670:	b2c50513          	addi	a0,a0,-1236 # 80008198 <__func__.1+0x190>
    80001674:	fffff097          	auipc	ra,0xfffff
    80001678:	eec080e7          	jalr	-276(ra) # 80000560 <panic>
    }
  }
  kfree((void*)pagetable);
    8000167c:	8552                	mv	a0,s4
    8000167e:	fffff097          	auipc	ra,0xfffff
    80001682:	3e0080e7          	jalr	992(ra) # 80000a5e <kfree>
}
    80001686:	70a2                	ld	ra,40(sp)
    80001688:	7402                	ld	s0,32(sp)
    8000168a:	64e2                	ld	s1,24(sp)
    8000168c:	6942                	ld	s2,16(sp)
    8000168e:	69a2                	ld	s3,8(sp)
    80001690:	6a02                	ld	s4,0(sp)
    80001692:	6145                	addi	sp,sp,48
    80001694:	8082                	ret

0000000080001696 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001696:	1101                	addi	sp,sp,-32
    80001698:	ec06                	sd	ra,24(sp)
    8000169a:	e822                	sd	s0,16(sp)
    8000169c:	e426                	sd	s1,8(sp)
    8000169e:	1000                	addi	s0,sp,32
    800016a0:	84aa                	mv	s1,a0
  if(sz > 0)
    800016a2:	e999                	bnez	a1,800016b8 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800016a4:	8526                	mv	a0,s1
    800016a6:	00000097          	auipc	ra,0x0
    800016aa:	f84080e7          	jalr	-124(ra) # 8000162a <freewalk>
}
    800016ae:	60e2                	ld	ra,24(sp)
    800016b0:	6442                	ld	s0,16(sp)
    800016b2:	64a2                	ld	s1,8(sp)
    800016b4:	6105                	addi	sp,sp,32
    800016b6:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800016b8:	6785                	lui	a5,0x1
    800016ba:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800016bc:	95be                	add	a1,a1,a5
    800016be:	4685                	li	a3,1
    800016c0:	00c5d613          	srli	a2,a1,0xc
    800016c4:	4581                	li	a1,0
    800016c6:	00000097          	auipc	ra,0x0
    800016ca:	ce2080e7          	jalr	-798(ra) # 800013a8 <uvmunmap>
    800016ce:	bfd9                	j	800016a4 <uvmfree+0xe>

00000000800016d0 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800016d0:	ca69                	beqz	a2,800017a2 <uvmcopy+0xd2>
{
    800016d2:	715d                	addi	sp,sp,-80
    800016d4:	e486                	sd	ra,72(sp)
    800016d6:	e0a2                	sd	s0,64(sp)
    800016d8:	fc26                	sd	s1,56(sp)
    800016da:	f84a                	sd	s2,48(sp)
    800016dc:	f44e                	sd	s3,40(sp)
    800016de:	f052                	sd	s4,32(sp)
    800016e0:	ec56                	sd	s5,24(sp)
    800016e2:	e85a                	sd	s6,16(sp)
    800016e4:	e45e                	sd	s7,8(sp)
    800016e6:	e062                	sd	s8,0(sp)
    800016e8:	0880                	addi	s0,sp,80
    800016ea:	8baa                	mv	s7,a0
    800016ec:	8b2e                	mv	s6,a1
    800016ee:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; i += PGSIZE){
    800016f0:	4981                	li	s3,0
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800016f2:	6a05                	lui	s4,0x1
    if((pte = walk(old, i, 0)) == 0)
    800016f4:	4601                	li	a2,0
    800016f6:	85ce                	mv	a1,s3
    800016f8:	855e                	mv	a0,s7
    800016fa:	00000097          	auipc	ra,0x0
    800016fe:	a00080e7          	jalr	-1536(ra) # 800010fa <walk>
    80001702:	c529                	beqz	a0,8000174c <uvmcopy+0x7c>
    if((*pte & PTE_V) == 0)
    80001704:	6118                	ld	a4,0(a0)
    80001706:	00177793          	andi	a5,a4,1
    8000170a:	cba9                	beqz	a5,8000175c <uvmcopy+0x8c>
    pa = PTE2PA(*pte);
    8000170c:	00a75593          	srli	a1,a4,0xa
    80001710:	00c59c13          	slli	s8,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001714:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80001718:	fffff097          	auipc	ra,0xfffff
    8000171c:	4ae080e7          	jalr	1198(ra) # 80000bc6 <kalloc>
    80001720:	892a                	mv	s2,a0
    80001722:	c931                	beqz	a0,80001776 <uvmcopy+0xa6>
    memmove(mem, (char*)pa, PGSIZE);
    80001724:	8652                	mv	a2,s4
    80001726:	85e2                	mv	a1,s8
    80001728:	fffff097          	auipc	ra,0xfffff
    8000172c:	73a080e7          	jalr	1850(ra) # 80000e62 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001730:	8726                	mv	a4,s1
    80001732:	86ca                	mv	a3,s2
    80001734:	8652                	mv	a2,s4
    80001736:	85ce                	mv	a1,s3
    80001738:	855a                	mv	a0,s6
    8000173a:	00000097          	auipc	ra,0x0
    8000173e:	aa8080e7          	jalr	-1368(ra) # 800011e2 <mappages>
    80001742:	e50d                	bnez	a0,8000176c <uvmcopy+0x9c>
  for(i = 0; i < sz; i += PGSIZE){
    80001744:	99d2                	add	s3,s3,s4
    80001746:	fb59e7e3          	bltu	s3,s5,800016f4 <uvmcopy+0x24>
    8000174a:	a081                	j	8000178a <uvmcopy+0xba>
      panic("uvmcopy: pte should exist");
    8000174c:	00007517          	auipc	a0,0x7
    80001750:	a5c50513          	addi	a0,a0,-1444 # 800081a8 <__func__.1+0x1a0>
    80001754:	fffff097          	auipc	ra,0xfffff
    80001758:	e0c080e7          	jalr	-500(ra) # 80000560 <panic>
      panic("uvmcopy: page not present");
    8000175c:	00007517          	auipc	a0,0x7
    80001760:	a6c50513          	addi	a0,a0,-1428 # 800081c8 <__func__.1+0x1c0>
    80001764:	fffff097          	auipc	ra,0xfffff
    80001768:	dfc080e7          	jalr	-516(ra) # 80000560 <panic>
      kfree(mem);
    8000176c:	854a                	mv	a0,s2
    8000176e:	fffff097          	auipc	ra,0xfffff
    80001772:	2f0080e7          	jalr	752(ra) # 80000a5e <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001776:	4685                	li	a3,1
    80001778:	00c9d613          	srli	a2,s3,0xc
    8000177c:	4581                	li	a1,0
    8000177e:	855a                	mv	a0,s6
    80001780:	00000097          	auipc	ra,0x0
    80001784:	c28080e7          	jalr	-984(ra) # 800013a8 <uvmunmap>
  return -1;
    80001788:	557d                	li	a0,-1
}
    8000178a:	60a6                	ld	ra,72(sp)
    8000178c:	6406                	ld	s0,64(sp)
    8000178e:	74e2                	ld	s1,56(sp)
    80001790:	7942                	ld	s2,48(sp)
    80001792:	79a2                	ld	s3,40(sp)
    80001794:	7a02                	ld	s4,32(sp)
    80001796:	6ae2                	ld	s5,24(sp)
    80001798:	6b42                	ld	s6,16(sp)
    8000179a:	6ba2                	ld	s7,8(sp)
    8000179c:	6c02                	ld	s8,0(sp)
    8000179e:	6161                	addi	sp,sp,80
    800017a0:	8082                	ret
  return 0;
    800017a2:	4501                	li	a0,0
}
    800017a4:	8082                	ret

00000000800017a6 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800017a6:	1141                	addi	sp,sp,-16
    800017a8:	e406                	sd	ra,8(sp)
    800017aa:	e022                	sd	s0,0(sp)
    800017ac:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800017ae:	4601                	li	a2,0
    800017b0:	00000097          	auipc	ra,0x0
    800017b4:	94a080e7          	jalr	-1718(ra) # 800010fa <walk>
  if(pte == 0)
    800017b8:	c901                	beqz	a0,800017c8 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800017ba:	611c                	ld	a5,0(a0)
    800017bc:	9bbd                	andi	a5,a5,-17
    800017be:	e11c                	sd	a5,0(a0)
}
    800017c0:	60a2                	ld	ra,8(sp)
    800017c2:	6402                	ld	s0,0(sp)
    800017c4:	0141                	addi	sp,sp,16
    800017c6:	8082                	ret
    panic("uvmclear");
    800017c8:	00007517          	auipc	a0,0x7
    800017cc:	a2050513          	addi	a0,a0,-1504 # 800081e8 <__func__.1+0x1e0>
    800017d0:	fffff097          	auipc	ra,0xfffff
    800017d4:	d90080e7          	jalr	-624(ra) # 80000560 <panic>

00000000800017d8 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800017d8:	c6bd                	beqz	a3,80001846 <copyout+0x6e>
{
    800017da:	715d                	addi	sp,sp,-80
    800017dc:	e486                	sd	ra,72(sp)
    800017de:	e0a2                	sd	s0,64(sp)
    800017e0:	fc26                	sd	s1,56(sp)
    800017e2:	f84a                	sd	s2,48(sp)
    800017e4:	f44e                	sd	s3,40(sp)
    800017e6:	f052                	sd	s4,32(sp)
    800017e8:	ec56                	sd	s5,24(sp)
    800017ea:	e85a                	sd	s6,16(sp)
    800017ec:	e45e                	sd	s7,8(sp)
    800017ee:	e062                	sd	s8,0(sp)
    800017f0:	0880                	addi	s0,sp,80
    800017f2:	8b2a                	mv	s6,a0
    800017f4:	8c2e                	mv	s8,a1
    800017f6:	8a32                	mv	s4,a2
    800017f8:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    800017fa:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    800017fc:	6a85                	lui	s5,0x1
    800017fe:	a015                	j	80001822 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001800:	9562                	add	a0,a0,s8
    80001802:	0004861b          	sext.w	a2,s1
    80001806:	85d2                	mv	a1,s4
    80001808:	41250533          	sub	a0,a0,s2
    8000180c:	fffff097          	auipc	ra,0xfffff
    80001810:	656080e7          	jalr	1622(ra) # 80000e62 <memmove>

    len -= n;
    80001814:	409989b3          	sub	s3,s3,s1
    src += n;
    80001818:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    8000181a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000181e:	02098263          	beqz	s3,80001842 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80001822:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001826:	85ca                	mv	a1,s2
    80001828:	855a                	mv	a0,s6
    8000182a:	00000097          	auipc	ra,0x0
    8000182e:	976080e7          	jalr	-1674(ra) # 800011a0 <walkaddr>
    if(pa0 == 0)
    80001832:	cd01                	beqz	a0,8000184a <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80001834:	418904b3          	sub	s1,s2,s8
    80001838:	94d6                	add	s1,s1,s5
    if(n > len)
    8000183a:	fc99f3e3          	bgeu	s3,s1,80001800 <copyout+0x28>
    8000183e:	84ce                	mv	s1,s3
    80001840:	b7c1                	j	80001800 <copyout+0x28>
  }
  return 0;
    80001842:	4501                	li	a0,0
    80001844:	a021                	j	8000184c <copyout+0x74>
    80001846:	4501                	li	a0,0
}
    80001848:	8082                	ret
      return -1;
    8000184a:	557d                	li	a0,-1
}
    8000184c:	60a6                	ld	ra,72(sp)
    8000184e:	6406                	ld	s0,64(sp)
    80001850:	74e2                	ld	s1,56(sp)
    80001852:	7942                	ld	s2,48(sp)
    80001854:	79a2                	ld	s3,40(sp)
    80001856:	7a02                	ld	s4,32(sp)
    80001858:	6ae2                	ld	s5,24(sp)
    8000185a:	6b42                	ld	s6,16(sp)
    8000185c:	6ba2                	ld	s7,8(sp)
    8000185e:	6c02                	ld	s8,0(sp)
    80001860:	6161                	addi	sp,sp,80
    80001862:	8082                	ret

0000000080001864 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001864:	caa5                	beqz	a3,800018d4 <copyin+0x70>
{
    80001866:	715d                	addi	sp,sp,-80
    80001868:	e486                	sd	ra,72(sp)
    8000186a:	e0a2                	sd	s0,64(sp)
    8000186c:	fc26                	sd	s1,56(sp)
    8000186e:	f84a                	sd	s2,48(sp)
    80001870:	f44e                	sd	s3,40(sp)
    80001872:	f052                	sd	s4,32(sp)
    80001874:	ec56                	sd	s5,24(sp)
    80001876:	e85a                	sd	s6,16(sp)
    80001878:	e45e                	sd	s7,8(sp)
    8000187a:	e062                	sd	s8,0(sp)
    8000187c:	0880                	addi	s0,sp,80
    8000187e:	8b2a                	mv	s6,a0
    80001880:	8a2e                	mv	s4,a1
    80001882:	8c32                	mv	s8,a2
    80001884:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001886:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001888:	6a85                	lui	s5,0x1
    8000188a:	a01d                	j	800018b0 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    8000188c:	018505b3          	add	a1,a0,s8
    80001890:	0004861b          	sext.w	a2,s1
    80001894:	412585b3          	sub	a1,a1,s2
    80001898:	8552                	mv	a0,s4
    8000189a:	fffff097          	auipc	ra,0xfffff
    8000189e:	5c8080e7          	jalr	1480(ra) # 80000e62 <memmove>

    len -= n;
    800018a2:	409989b3          	sub	s3,s3,s1
    dst += n;
    800018a6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    800018a8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800018ac:	02098263          	beqz	s3,800018d0 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    800018b0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800018b4:	85ca                	mv	a1,s2
    800018b6:	855a                	mv	a0,s6
    800018b8:	00000097          	auipc	ra,0x0
    800018bc:	8e8080e7          	jalr	-1816(ra) # 800011a0 <walkaddr>
    if(pa0 == 0)
    800018c0:	cd01                	beqz	a0,800018d8 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    800018c2:	418904b3          	sub	s1,s2,s8
    800018c6:	94d6                	add	s1,s1,s5
    if(n > len)
    800018c8:	fc99f2e3          	bgeu	s3,s1,8000188c <copyin+0x28>
    800018cc:	84ce                	mv	s1,s3
    800018ce:	bf7d                	j	8000188c <copyin+0x28>
  }
  return 0;
    800018d0:	4501                	li	a0,0
    800018d2:	a021                	j	800018da <copyin+0x76>
    800018d4:	4501                	li	a0,0
}
    800018d6:	8082                	ret
      return -1;
    800018d8:	557d                	li	a0,-1
}
    800018da:	60a6                	ld	ra,72(sp)
    800018dc:	6406                	ld	s0,64(sp)
    800018de:	74e2                	ld	s1,56(sp)
    800018e0:	7942                	ld	s2,48(sp)
    800018e2:	79a2                	ld	s3,40(sp)
    800018e4:	7a02                	ld	s4,32(sp)
    800018e6:	6ae2                	ld	s5,24(sp)
    800018e8:	6b42                	ld	s6,16(sp)
    800018ea:	6ba2                	ld	s7,8(sp)
    800018ec:	6c02                	ld	s8,0(sp)
    800018ee:	6161                	addi	sp,sp,80
    800018f0:	8082                	ret

00000000800018f2 <copyinstr>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    800018f2:	715d                	addi	sp,sp,-80
    800018f4:	e486                	sd	ra,72(sp)
    800018f6:	e0a2                	sd	s0,64(sp)
    800018f8:	fc26                	sd	s1,56(sp)
    800018fa:	f84a                	sd	s2,48(sp)
    800018fc:	f44e                	sd	s3,40(sp)
    800018fe:	f052                	sd	s4,32(sp)
    80001900:	ec56                	sd	s5,24(sp)
    80001902:	e85a                	sd	s6,16(sp)
    80001904:	e45e                	sd	s7,8(sp)
    80001906:	0880                	addi	s0,sp,80
    80001908:	8aaa                	mv	s5,a0
    8000190a:	89ae                	mv	s3,a1
    8000190c:	8bb2                	mv	s7,a2
    8000190e:	84b6                	mv	s1,a3
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    va0 = PGROUNDDOWN(srcva);
    80001910:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001912:	6a05                	lui	s4,0x1
    80001914:	a02d                	j	8000193e <copyinstr+0x4c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001916:	00078023          	sb	zero,0(a5)
    8000191a:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    8000191c:	0017c793          	xori	a5,a5,1
    80001920:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001924:	60a6                	ld	ra,72(sp)
    80001926:	6406                	ld	s0,64(sp)
    80001928:	74e2                	ld	s1,56(sp)
    8000192a:	7942                	ld	s2,48(sp)
    8000192c:	79a2                	ld	s3,40(sp)
    8000192e:	7a02                	ld	s4,32(sp)
    80001930:	6ae2                	ld	s5,24(sp)
    80001932:	6b42                	ld	s6,16(sp)
    80001934:	6ba2                	ld	s7,8(sp)
    80001936:	6161                	addi	sp,sp,80
    80001938:	8082                	ret
    srcva = va0 + PGSIZE;
    8000193a:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    8000193e:	c8a1                	beqz	s1,8000198e <copyinstr+0x9c>
    va0 = PGROUNDDOWN(srcva);
    80001940:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    80001944:	85ca                	mv	a1,s2
    80001946:	8556                	mv	a0,s5
    80001948:	00000097          	auipc	ra,0x0
    8000194c:	858080e7          	jalr	-1960(ra) # 800011a0 <walkaddr>
    if(pa0 == 0)
    80001950:	c129                	beqz	a0,80001992 <copyinstr+0xa0>
    n = PGSIZE - (srcva - va0);
    80001952:	41790633          	sub	a2,s2,s7
    80001956:	9652                	add	a2,a2,s4
    if(n > max)
    80001958:	00c4f363          	bgeu	s1,a2,8000195e <copyinstr+0x6c>
    8000195c:	8626                	mv	a2,s1
    char *p = (char *) (pa0 + (srcva - va0));
    8000195e:	412b8bb3          	sub	s7,s7,s2
    80001962:	9baa                	add	s7,s7,a0
    while(n > 0){
    80001964:	da79                	beqz	a2,8000193a <copyinstr+0x48>
    80001966:	87ce                	mv	a5,s3
      if(*p == '\0'){
    80001968:	413b86b3          	sub	a3,s7,s3
    while(n > 0){
    8000196c:	964e                	add	a2,a2,s3
    8000196e:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001970:	00f68733          	add	a4,a3,a5
    80001974:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdd140>
    80001978:	df59                	beqz	a4,80001916 <copyinstr+0x24>
        *dst = *p;
    8000197a:	00e78023          	sb	a4,0(a5)
      dst++;
    8000197e:	0785                	addi	a5,a5,1
    while(n > 0){
    80001980:	fec797e3          	bne	a5,a2,8000196e <copyinstr+0x7c>
    80001984:	14fd                	addi	s1,s1,-1
    80001986:	94ce                	add	s1,s1,s3
      --max;
    80001988:	8c8d                	sub	s1,s1,a1
    8000198a:	89be                	mv	s3,a5
    8000198c:	b77d                	j	8000193a <copyinstr+0x48>
    8000198e:	4781                	li	a5,0
    80001990:	b771                	j	8000191c <copyinstr+0x2a>
      return -1;
    80001992:	557d                	li	a0,-1
    80001994:	bf41                	j	80001924 <copyinstr+0x32>

0000000080001996 <va2pa_helper>:

uint64
va2pa_helper(pagetable_t pagetable, uint64 va)
{
    80001996:	1101                	addi	sp,sp,-32
    80001998:	ec06                	sd	ra,24(sp)
    8000199a:	e822                	sd	s0,16(sp)
    8000199c:	e426                	sd	s1,8(sp)
    8000199e:	1000                	addi	s0,sp,32
    800019a0:	84ae                	mv	s1,a1
    pte_t *pte;
    uint64 pa;

    pte = walk(pagetable, va, 0);
    800019a2:	4601                	li	a2,0
    800019a4:	fffff097          	auipc	ra,0xfffff
    800019a8:	756080e7          	jalr	1878(ra) # 800010fa <walk>
    if(pte == 0 || (*pte & PTE_V) == 0)
    800019ac:	c10d                	beqz	a0,800019ce <va2pa_helper+0x38>
    800019ae:	611c                	ld	a5,0(a0)
    800019b0:	0017f513          	andi	a0,a5,1
    800019b4:	c901                	beqz	a0,800019c4 <va2pa_helper+0x2e>
        return 0;
    pa = PTE2PA(*pte) | (va & 0xFFF);
    800019b6:	83a9                	srli	a5,a5,0xa
    800019b8:	07b2                	slli	a5,a5,0xc
    800019ba:	03449593          	slli	a1,s1,0x34
    800019be:	91d1                	srli	a1,a1,0x34
    800019c0:	00b7e533          	or	a0,a5,a1
    return pa;
}
    800019c4:	60e2                	ld	ra,24(sp)
    800019c6:	6442                	ld	s0,16(sp)
    800019c8:	64a2                	ld	s1,8(sp)
    800019ca:	6105                	addi	sp,sp,32
    800019cc:	8082                	ret
        return 0;
    800019ce:	4501                	li	a0,0
    800019d0:	bfd5                	j	800019c4 <va2pa_helper+0x2e>

00000000800019d2 <rr_scheduler>:
        (*sched_pointer)();
    }
}

void rr_scheduler(void)
{
    800019d2:	715d                	addi	sp,sp,-80
    800019d4:	e486                	sd	ra,72(sp)
    800019d6:	e0a2                	sd	s0,64(sp)
    800019d8:	fc26                	sd	s1,56(sp)
    800019da:	f84a                	sd	s2,48(sp)
    800019dc:	f44e                	sd	s3,40(sp)
    800019de:	f052                	sd	s4,32(sp)
    800019e0:	ec56                	sd	s5,24(sp)
    800019e2:	e85a                	sd	s6,16(sp)
    800019e4:	e45e                	sd	s7,8(sp)
    800019e6:	0880                	addi	s0,sp,80
    asm volatile("mv %0, tp" : "=r"(x));
    800019e8:	8792                	mv	a5,tp
    int id = r_tp();
    800019ea:	2781                	sext.w	a5,a5
    struct proc *p;
    struct cpu *c = mycpu();

    c->proc = 0;
    800019ec:	0000fa17          	auipc	s4,0xf
    800019f0:	2c4a0a13          	addi	s4,s4,708 # 80010cb0 <cpus>
    800019f4:	00779713          	slli	a4,a5,0x7
    800019f8:	00ea06b3          	add	a3,s4,a4
    800019fc:	0006b023          	sd	zero,0(a3) # fffffffffffff000 <end+0xffffffff7ffdd140>
                // Switch to chosen process.  It is the process's job
                // to release its lock and then reacquire it
                // before jumping back to us.
                p->state = RUNNING;
                c->proc = p;
                swtch(&c->context, &p->context);
    80001a00:	0721                	addi	a4,a4,8
    80001a02:	9a3a                	add	s4,s4,a4
            if (p->state == RUNNABLE)
    80001a04:	498d                	li	s3,3
                p->state = RUNNING;
    80001a06:	4b91                	li	s7,4
                c->proc = p;
    80001a08:	8936                	mv	s2,a3
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80001a0a:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001a0e:	0027e793          	ori	a5,a5,2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80001a12:	10079073          	csrw	sstatus,a5
        for (p = proc; p < &proc[NPROC]; p++)
    80001a16:	0000f497          	auipc	s1,0xf
    80001a1a:	6ca48493          	addi	s1,s1,1738 # 800110e0 <proc>
                // check if we are still the right scheduler (or if schedset changed)
                if (sched_pointer != &rr_scheduler)
    80001a1e:	00007b17          	auipc	s6,0x7
    80001a22:	f6ab0b13          	addi	s6,s6,-150 # 80008988 <sched_pointer>
    80001a26:	00000a97          	auipc	s5,0x0
    80001a2a:	faca8a93          	addi	s5,s5,-84 # 800019d2 <rr_scheduler>
    80001a2e:	a835                	j	80001a6a <rr_scheduler+0x98>
                {
                    release(&p->lock);
    80001a30:	8526                	mv	a0,s1
    80001a32:	fffff097          	auipc	ra,0xfffff
    80001a36:	384080e7          	jalr	900(ra) # 80000db6 <release>
                c->proc = 0;
            }
            release(&p->lock);
        }
    }
}
    80001a3a:	60a6                	ld	ra,72(sp)
    80001a3c:	6406                	ld	s0,64(sp)
    80001a3e:	74e2                	ld	s1,56(sp)
    80001a40:	7942                	ld	s2,48(sp)
    80001a42:	79a2                	ld	s3,40(sp)
    80001a44:	7a02                	ld	s4,32(sp)
    80001a46:	6ae2                	ld	s5,24(sp)
    80001a48:	6b42                	ld	s6,16(sp)
    80001a4a:	6ba2                	ld	s7,8(sp)
    80001a4c:	6161                	addi	sp,sp,80
    80001a4e:	8082                	ret
            release(&p->lock);
    80001a50:	8526                	mv	a0,s1
    80001a52:	fffff097          	auipc	ra,0xfffff
    80001a56:	364080e7          	jalr	868(ra) # 80000db6 <release>
        for (p = proc; p < &proc[NPROC]; p++)
    80001a5a:	16848493          	addi	s1,s1,360
    80001a5e:	00015797          	auipc	a5,0x15
    80001a62:	08278793          	addi	a5,a5,130 # 80016ae0 <tickslock>
    80001a66:	faf482e3          	beq	s1,a5,80001a0a <rr_scheduler+0x38>
            acquire(&p->lock);
    80001a6a:	8526                	mv	a0,s1
    80001a6c:	fffff097          	auipc	ra,0xfffff
    80001a70:	29a080e7          	jalr	666(ra) # 80000d06 <acquire>
            if (p->state == RUNNABLE)
    80001a74:	4c9c                	lw	a5,24(s1)
    80001a76:	fd379de3          	bne	a5,s3,80001a50 <rr_scheduler+0x7e>
                p->state = RUNNING;
    80001a7a:	0174ac23          	sw	s7,24(s1)
                c->proc = p;
    80001a7e:	00993023          	sd	s1,0(s2) # 1000 <_entry-0x7ffff000>
                swtch(&c->context, &p->context);
    80001a82:	06048593          	addi	a1,s1,96
    80001a86:	8552                	mv	a0,s4
    80001a88:	00001097          	auipc	ra,0x1
    80001a8c:	fcc080e7          	jalr	-52(ra) # 80002a54 <swtch>
                if (sched_pointer != &rr_scheduler)
    80001a90:	000b3783          	ld	a5,0(s6)
    80001a94:	f9579ee3          	bne	a5,s5,80001a30 <rr_scheduler+0x5e>
                c->proc = 0;
    80001a98:	00093023          	sd	zero,0(s2)
    80001a9c:	bf55                	j	80001a50 <rr_scheduler+0x7e>

0000000080001a9e <proc_mapstacks>:
{
    80001a9e:	715d                	addi	sp,sp,-80
    80001aa0:	e486                	sd	ra,72(sp)
    80001aa2:	e0a2                	sd	s0,64(sp)
    80001aa4:	fc26                	sd	s1,56(sp)
    80001aa6:	f84a                	sd	s2,48(sp)
    80001aa8:	f44e                	sd	s3,40(sp)
    80001aaa:	f052                	sd	s4,32(sp)
    80001aac:	ec56                	sd	s5,24(sp)
    80001aae:	e85a                	sd	s6,16(sp)
    80001ab0:	e45e                	sd	s7,8(sp)
    80001ab2:	e062                	sd	s8,0(sp)
    80001ab4:	0880                	addi	s0,sp,80
    80001ab6:	8a2a                	mv	s4,a0
    for (p = proc; p < &proc[NPROC]; p++)
    80001ab8:	0000f497          	auipc	s1,0xf
    80001abc:	62848493          	addi	s1,s1,1576 # 800110e0 <proc>
        uint64 va = KSTACK((int)(p - proc));
    80001ac0:	8c26                	mv	s8,s1
    80001ac2:	a4fa57b7          	lui	a5,0xa4fa5
    80001ac6:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff24f830e5>
    80001aca:	4fa50937          	lui	s2,0x4fa50
    80001ace:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x305b05b0>
    80001ad2:	1902                	slli	s2,s2,0x20
    80001ad4:	993e                	add	s2,s2,a5
    80001ad6:	040009b7          	lui	s3,0x4000
    80001ada:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001adc:	09b2                	slli	s3,s3,0xc
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001ade:	4b99                	li	s7,6
    80001ae0:	6b05                	lui	s6,0x1
    for (p = proc; p < &proc[NPROC]; p++)
    80001ae2:	00015a97          	auipc	s5,0x15
    80001ae6:	ffea8a93          	addi	s5,s5,-2 # 80016ae0 <tickslock>
        char *pa = kalloc();
    80001aea:	fffff097          	auipc	ra,0xfffff
    80001aee:	0dc080e7          	jalr	220(ra) # 80000bc6 <kalloc>
    80001af2:	862a                	mv	a2,a0
        if (pa == 0)
    80001af4:	c131                	beqz	a0,80001b38 <proc_mapstacks+0x9a>
        uint64 va = KSTACK((int)(p - proc));
    80001af6:	418485b3          	sub	a1,s1,s8
    80001afa:	858d                	srai	a1,a1,0x3
    80001afc:	032585b3          	mul	a1,a1,s2
    80001b00:	2585                	addiw	a1,a1,1
    80001b02:	00d5959b          	slliw	a1,a1,0xd
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001b06:	875e                	mv	a4,s7
    80001b08:	86da                	mv	a3,s6
    80001b0a:	40b985b3          	sub	a1,s3,a1
    80001b0e:	8552                	mv	a0,s4
    80001b10:	fffff097          	auipc	ra,0xfffff
    80001b14:	778080e7          	jalr	1912(ra) # 80001288 <kvmmap>
    for (p = proc; p < &proc[NPROC]; p++)
    80001b18:	16848493          	addi	s1,s1,360
    80001b1c:	fd5497e3          	bne	s1,s5,80001aea <proc_mapstacks+0x4c>
}
    80001b20:	60a6                	ld	ra,72(sp)
    80001b22:	6406                	ld	s0,64(sp)
    80001b24:	74e2                	ld	s1,56(sp)
    80001b26:	7942                	ld	s2,48(sp)
    80001b28:	79a2                	ld	s3,40(sp)
    80001b2a:	7a02                	ld	s4,32(sp)
    80001b2c:	6ae2                	ld	s5,24(sp)
    80001b2e:	6b42                	ld	s6,16(sp)
    80001b30:	6ba2                	ld	s7,8(sp)
    80001b32:	6c02                	ld	s8,0(sp)
    80001b34:	6161                	addi	sp,sp,80
    80001b36:	8082                	ret
            panic("kalloc");
    80001b38:	00006517          	auipc	a0,0x6
    80001b3c:	6c050513          	addi	a0,a0,1728 # 800081f8 <__func__.1+0x1f0>
    80001b40:	fffff097          	auipc	ra,0xfffff
    80001b44:	a20080e7          	jalr	-1504(ra) # 80000560 <panic>

0000000080001b48 <procinit>:
{
    80001b48:	7139                	addi	sp,sp,-64
    80001b4a:	fc06                	sd	ra,56(sp)
    80001b4c:	f822                	sd	s0,48(sp)
    80001b4e:	f426                	sd	s1,40(sp)
    80001b50:	f04a                	sd	s2,32(sp)
    80001b52:	ec4e                	sd	s3,24(sp)
    80001b54:	e852                	sd	s4,16(sp)
    80001b56:	e456                	sd	s5,8(sp)
    80001b58:	e05a                	sd	s6,0(sp)
    80001b5a:	0080                	addi	s0,sp,64
    initlock(&pid_lock, "nextpid");
    80001b5c:	00006597          	auipc	a1,0x6
    80001b60:	6a458593          	addi	a1,a1,1700 # 80008200 <__func__.1+0x1f8>
    80001b64:	0000f517          	auipc	a0,0xf
    80001b68:	54c50513          	addi	a0,a0,1356 # 800110b0 <pid_lock>
    80001b6c:	fffff097          	auipc	ra,0xfffff
    80001b70:	106080e7          	jalr	262(ra) # 80000c72 <initlock>
    initlock(&wait_lock, "wait_lock");
    80001b74:	00006597          	auipc	a1,0x6
    80001b78:	69458593          	addi	a1,a1,1684 # 80008208 <__func__.1+0x200>
    80001b7c:	0000f517          	auipc	a0,0xf
    80001b80:	54c50513          	addi	a0,a0,1356 # 800110c8 <wait_lock>
    80001b84:	fffff097          	auipc	ra,0xfffff
    80001b88:	0ee080e7          	jalr	238(ra) # 80000c72 <initlock>
    for (p = proc; p < &proc[NPROC]; p++)
    80001b8c:	0000f497          	auipc	s1,0xf
    80001b90:	55448493          	addi	s1,s1,1364 # 800110e0 <proc>
        initlock(&p->lock, "proc");
    80001b94:	00006b17          	auipc	s6,0x6
    80001b98:	684b0b13          	addi	s6,s6,1668 # 80008218 <__func__.1+0x210>
        p->kstack = KSTACK((int)(p - proc));
    80001b9c:	8aa6                	mv	s5,s1
    80001b9e:	a4fa57b7          	lui	a5,0xa4fa5
    80001ba2:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff24f830e5>
    80001ba6:	4fa50937          	lui	s2,0x4fa50
    80001baa:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x305b05b0>
    80001bae:	1902                	slli	s2,s2,0x20
    80001bb0:	993e                	add	s2,s2,a5
    80001bb2:	040009b7          	lui	s3,0x4000
    80001bb6:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001bb8:	09b2                	slli	s3,s3,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    80001bba:	00015a17          	auipc	s4,0x15
    80001bbe:	f26a0a13          	addi	s4,s4,-218 # 80016ae0 <tickslock>
        initlock(&p->lock, "proc");
    80001bc2:	85da                	mv	a1,s6
    80001bc4:	8526                	mv	a0,s1
    80001bc6:	fffff097          	auipc	ra,0xfffff
    80001bca:	0ac080e7          	jalr	172(ra) # 80000c72 <initlock>
        p->state = UNUSED;
    80001bce:	0004ac23          	sw	zero,24(s1)
        p->kstack = KSTACK((int)(p - proc));
    80001bd2:	415487b3          	sub	a5,s1,s5
    80001bd6:	878d                	srai	a5,a5,0x3
    80001bd8:	032787b3          	mul	a5,a5,s2
    80001bdc:	2785                	addiw	a5,a5,1
    80001bde:	00d7979b          	slliw	a5,a5,0xd
    80001be2:	40f987b3          	sub	a5,s3,a5
    80001be6:	e0bc                	sd	a5,64(s1)
    for (p = proc; p < &proc[NPROC]; p++)
    80001be8:	16848493          	addi	s1,s1,360
    80001bec:	fd449be3          	bne	s1,s4,80001bc2 <procinit+0x7a>
}
    80001bf0:	70e2                	ld	ra,56(sp)
    80001bf2:	7442                	ld	s0,48(sp)
    80001bf4:	74a2                	ld	s1,40(sp)
    80001bf6:	7902                	ld	s2,32(sp)
    80001bf8:	69e2                	ld	s3,24(sp)
    80001bfa:	6a42                	ld	s4,16(sp)
    80001bfc:	6aa2                	ld	s5,8(sp)
    80001bfe:	6b02                	ld	s6,0(sp)
    80001c00:	6121                	addi	sp,sp,64
    80001c02:	8082                	ret

0000000080001c04 <copy_array>:
{
    80001c04:	1141                	addi	sp,sp,-16
    80001c06:	e406                	sd	ra,8(sp)
    80001c08:	e022                	sd	s0,0(sp)
    80001c0a:	0800                	addi	s0,sp,16
    for (int i = 0; i < len; i++)
    80001c0c:	00c05c63          	blez	a2,80001c24 <copy_array+0x20>
    80001c10:	87aa                	mv	a5,a0
    80001c12:	9532                	add	a0,a0,a2
        dst[i] = src[i];
    80001c14:	0007c703          	lbu	a4,0(a5)
    80001c18:	00e58023          	sb	a4,0(a1)
    for (int i = 0; i < len; i++)
    80001c1c:	0785                	addi	a5,a5,1
    80001c1e:	0585                	addi	a1,a1,1
    80001c20:	fea79ae3          	bne	a5,a0,80001c14 <copy_array+0x10>
}
    80001c24:	60a2                	ld	ra,8(sp)
    80001c26:	6402                	ld	s0,0(sp)
    80001c28:	0141                	addi	sp,sp,16
    80001c2a:	8082                	ret

0000000080001c2c <cpuid>:
{
    80001c2c:	1141                	addi	sp,sp,-16
    80001c2e:	e406                	sd	ra,8(sp)
    80001c30:	e022                	sd	s0,0(sp)
    80001c32:	0800                	addi	s0,sp,16
    asm volatile("mv %0, tp" : "=r"(x));
    80001c34:	8512                	mv	a0,tp
}
    80001c36:	2501                	sext.w	a0,a0
    80001c38:	60a2                	ld	ra,8(sp)
    80001c3a:	6402                	ld	s0,0(sp)
    80001c3c:	0141                	addi	sp,sp,16
    80001c3e:	8082                	ret

0000000080001c40 <mycpu>:
{
    80001c40:	1141                	addi	sp,sp,-16
    80001c42:	e406                	sd	ra,8(sp)
    80001c44:	e022                	sd	s0,0(sp)
    80001c46:	0800                	addi	s0,sp,16
    80001c48:	8792                	mv	a5,tp
    struct cpu *c = &cpus[id];
    80001c4a:	2781                	sext.w	a5,a5
    80001c4c:	079e                	slli	a5,a5,0x7
}
    80001c4e:	0000f517          	auipc	a0,0xf
    80001c52:	06250513          	addi	a0,a0,98 # 80010cb0 <cpus>
    80001c56:	953e                	add	a0,a0,a5
    80001c58:	60a2                	ld	ra,8(sp)
    80001c5a:	6402                	ld	s0,0(sp)
    80001c5c:	0141                	addi	sp,sp,16
    80001c5e:	8082                	ret

0000000080001c60 <myproc>:
{
    80001c60:	1101                	addi	sp,sp,-32
    80001c62:	ec06                	sd	ra,24(sp)
    80001c64:	e822                	sd	s0,16(sp)
    80001c66:	e426                	sd	s1,8(sp)
    80001c68:	1000                	addi	s0,sp,32
    push_off();
    80001c6a:	fffff097          	auipc	ra,0xfffff
    80001c6e:	050080e7          	jalr	80(ra) # 80000cba <push_off>
    80001c72:	8792                	mv	a5,tp
    struct proc *p = c->proc;
    80001c74:	2781                	sext.w	a5,a5
    80001c76:	079e                	slli	a5,a5,0x7
    80001c78:	0000f717          	auipc	a4,0xf
    80001c7c:	03870713          	addi	a4,a4,56 # 80010cb0 <cpus>
    80001c80:	97ba                	add	a5,a5,a4
    80001c82:	6384                	ld	s1,0(a5)
    pop_off();
    80001c84:	fffff097          	auipc	ra,0xfffff
    80001c88:	0d6080e7          	jalr	214(ra) # 80000d5a <pop_off>
}
    80001c8c:	8526                	mv	a0,s1
    80001c8e:	60e2                	ld	ra,24(sp)
    80001c90:	6442                	ld	s0,16(sp)
    80001c92:	64a2                	ld	s1,8(sp)
    80001c94:	6105                	addi	sp,sp,32
    80001c96:	8082                	ret

0000000080001c98 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80001c98:	1141                	addi	sp,sp,-16
    80001c9a:	e406                	sd	ra,8(sp)
    80001c9c:	e022                	sd	s0,0(sp)
    80001c9e:	0800                	addi	s0,sp,16
    static int first = 1;

    // Still holding p->lock from scheduler.
    release(&myproc()->lock);
    80001ca0:	00000097          	auipc	ra,0x0
    80001ca4:	fc0080e7          	jalr	-64(ra) # 80001c60 <myproc>
    80001ca8:	fffff097          	auipc	ra,0xfffff
    80001cac:	10e080e7          	jalr	270(ra) # 80000db6 <release>

    if (first)
    80001cb0:	00007797          	auipc	a5,0x7
    80001cb4:	cd07a783          	lw	a5,-816(a5) # 80008980 <first.1>
    80001cb8:	eb89                	bnez	a5,80001cca <forkret+0x32>
        // be run from main().
        first = 0;
        fsinit(ROOTDEV);
    }

    usertrapret();
    80001cba:	00001097          	auipc	ra,0x1
    80001cbe:	e48080e7          	jalr	-440(ra) # 80002b02 <usertrapret>
}
    80001cc2:	60a2                	ld	ra,8(sp)
    80001cc4:	6402                	ld	s0,0(sp)
    80001cc6:	0141                	addi	sp,sp,16
    80001cc8:	8082                	ret
        first = 0;
    80001cca:	00007797          	auipc	a5,0x7
    80001cce:	ca07ab23          	sw	zero,-842(a5) # 80008980 <first.1>
        fsinit(ROOTDEV);
    80001cd2:	4505                	li	a0,1
    80001cd4:	00002097          	auipc	ra,0x2
    80001cd8:	cd0080e7          	jalr	-816(ra) # 800039a4 <fsinit>
    80001cdc:	bff9                	j	80001cba <forkret+0x22>

0000000080001cde <allocpid>:
{
    80001cde:	1101                	addi	sp,sp,-32
    80001ce0:	ec06                	sd	ra,24(sp)
    80001ce2:	e822                	sd	s0,16(sp)
    80001ce4:	e426                	sd	s1,8(sp)
    80001ce6:	e04a                	sd	s2,0(sp)
    80001ce8:	1000                	addi	s0,sp,32
    acquire(&pid_lock);
    80001cea:	0000f917          	auipc	s2,0xf
    80001cee:	3c690913          	addi	s2,s2,966 # 800110b0 <pid_lock>
    80001cf2:	854a                	mv	a0,s2
    80001cf4:	fffff097          	auipc	ra,0xfffff
    80001cf8:	012080e7          	jalr	18(ra) # 80000d06 <acquire>
    pid = nextpid;
    80001cfc:	00007797          	auipc	a5,0x7
    80001d00:	c9478793          	addi	a5,a5,-876 # 80008990 <nextpid>
    80001d04:	4384                	lw	s1,0(a5)
    nextpid = nextpid + 1;
    80001d06:	0014871b          	addiw	a4,s1,1
    80001d0a:	c398                	sw	a4,0(a5)
    release(&pid_lock);
    80001d0c:	854a                	mv	a0,s2
    80001d0e:	fffff097          	auipc	ra,0xfffff
    80001d12:	0a8080e7          	jalr	168(ra) # 80000db6 <release>
}
    80001d16:	8526                	mv	a0,s1
    80001d18:	60e2                	ld	ra,24(sp)
    80001d1a:	6442                	ld	s0,16(sp)
    80001d1c:	64a2                	ld	s1,8(sp)
    80001d1e:	6902                	ld	s2,0(sp)
    80001d20:	6105                	addi	sp,sp,32
    80001d22:	8082                	ret

0000000080001d24 <proc_pagetable>:
{
    80001d24:	1101                	addi	sp,sp,-32
    80001d26:	ec06                	sd	ra,24(sp)
    80001d28:	e822                	sd	s0,16(sp)
    80001d2a:	e426                	sd	s1,8(sp)
    80001d2c:	e04a                	sd	s2,0(sp)
    80001d2e:	1000                	addi	s0,sp,32
    80001d30:	892a                	mv	s2,a0
    pagetable = uvmcreate();
    80001d32:	fffff097          	auipc	ra,0xfffff
    80001d36:	74a080e7          	jalr	1866(ra) # 8000147c <uvmcreate>
    80001d3a:	84aa                	mv	s1,a0
    if (pagetable == 0)
    80001d3c:	c121                	beqz	a0,80001d7c <proc_pagetable+0x58>
    if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001d3e:	4729                	li	a4,10
    80001d40:	00005697          	auipc	a3,0x5
    80001d44:	2c068693          	addi	a3,a3,704 # 80007000 <_trampoline>
    80001d48:	6605                	lui	a2,0x1
    80001d4a:	040005b7          	lui	a1,0x4000
    80001d4e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001d50:	05b2                	slli	a1,a1,0xc
    80001d52:	fffff097          	auipc	ra,0xfffff
    80001d56:	490080e7          	jalr	1168(ra) # 800011e2 <mappages>
    80001d5a:	02054863          	bltz	a0,80001d8a <proc_pagetable+0x66>
    if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80001d5e:	4719                	li	a4,6
    80001d60:	05893683          	ld	a3,88(s2)
    80001d64:	6605                	lui	a2,0x1
    80001d66:	020005b7          	lui	a1,0x2000
    80001d6a:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001d6c:	05b6                	slli	a1,a1,0xd
    80001d6e:	8526                	mv	a0,s1
    80001d70:	fffff097          	auipc	ra,0xfffff
    80001d74:	472080e7          	jalr	1138(ra) # 800011e2 <mappages>
    80001d78:	02054163          	bltz	a0,80001d9a <proc_pagetable+0x76>
}
    80001d7c:	8526                	mv	a0,s1
    80001d7e:	60e2                	ld	ra,24(sp)
    80001d80:	6442                	ld	s0,16(sp)
    80001d82:	64a2                	ld	s1,8(sp)
    80001d84:	6902                	ld	s2,0(sp)
    80001d86:	6105                	addi	sp,sp,32
    80001d88:	8082                	ret
        uvmfree(pagetable, 0);
    80001d8a:	4581                	li	a1,0
    80001d8c:	8526                	mv	a0,s1
    80001d8e:	00000097          	auipc	ra,0x0
    80001d92:	908080e7          	jalr	-1784(ra) # 80001696 <uvmfree>
        return 0;
    80001d96:	4481                	li	s1,0
    80001d98:	b7d5                	j	80001d7c <proc_pagetable+0x58>
        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001d9a:	4681                	li	a3,0
    80001d9c:	4605                	li	a2,1
    80001d9e:	040005b7          	lui	a1,0x4000
    80001da2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001da4:	05b2                	slli	a1,a1,0xc
    80001da6:	8526                	mv	a0,s1
    80001da8:	fffff097          	auipc	ra,0xfffff
    80001dac:	600080e7          	jalr	1536(ra) # 800013a8 <uvmunmap>
        uvmfree(pagetable, 0);
    80001db0:	4581                	li	a1,0
    80001db2:	8526                	mv	a0,s1
    80001db4:	00000097          	auipc	ra,0x0
    80001db8:	8e2080e7          	jalr	-1822(ra) # 80001696 <uvmfree>
        return 0;
    80001dbc:	4481                	li	s1,0
    80001dbe:	bf7d                	j	80001d7c <proc_pagetable+0x58>

0000000080001dc0 <proc_freepagetable>:
{
    80001dc0:	1101                	addi	sp,sp,-32
    80001dc2:	ec06                	sd	ra,24(sp)
    80001dc4:	e822                	sd	s0,16(sp)
    80001dc6:	e426                	sd	s1,8(sp)
    80001dc8:	e04a                	sd	s2,0(sp)
    80001dca:	1000                	addi	s0,sp,32
    80001dcc:	84aa                	mv	s1,a0
    80001dce:	892e                	mv	s2,a1
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001dd0:	4681                	li	a3,0
    80001dd2:	4605                	li	a2,1
    80001dd4:	040005b7          	lui	a1,0x4000
    80001dd8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001dda:	05b2                	slli	a1,a1,0xc
    80001ddc:	fffff097          	auipc	ra,0xfffff
    80001de0:	5cc080e7          	jalr	1484(ra) # 800013a8 <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001de4:	4681                	li	a3,0
    80001de6:	4605                	li	a2,1
    80001de8:	020005b7          	lui	a1,0x2000
    80001dec:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001dee:	05b6                	slli	a1,a1,0xd
    80001df0:	8526                	mv	a0,s1
    80001df2:	fffff097          	auipc	ra,0xfffff
    80001df6:	5b6080e7          	jalr	1462(ra) # 800013a8 <uvmunmap>
    uvmfree(pagetable, sz);
    80001dfa:	85ca                	mv	a1,s2
    80001dfc:	8526                	mv	a0,s1
    80001dfe:	00000097          	auipc	ra,0x0
    80001e02:	898080e7          	jalr	-1896(ra) # 80001696 <uvmfree>
}
    80001e06:	60e2                	ld	ra,24(sp)
    80001e08:	6442                	ld	s0,16(sp)
    80001e0a:	64a2                	ld	s1,8(sp)
    80001e0c:	6902                	ld	s2,0(sp)
    80001e0e:	6105                	addi	sp,sp,32
    80001e10:	8082                	ret

0000000080001e12 <freeproc>:
{
    80001e12:	1101                	addi	sp,sp,-32
    80001e14:	ec06                	sd	ra,24(sp)
    80001e16:	e822                	sd	s0,16(sp)
    80001e18:	e426                	sd	s1,8(sp)
    80001e1a:	1000                	addi	s0,sp,32
    80001e1c:	84aa                	mv	s1,a0
    if (p->trapframe)
    80001e1e:	6d28                	ld	a0,88(a0)
    80001e20:	c509                	beqz	a0,80001e2a <freeproc+0x18>
        kfree((void *)p->trapframe);
    80001e22:	fffff097          	auipc	ra,0xfffff
    80001e26:	c3c080e7          	jalr	-964(ra) # 80000a5e <kfree>
    p->trapframe = 0;
    80001e2a:	0404bc23          	sd	zero,88(s1)
    if (p->pagetable)
    80001e2e:	68a8                	ld	a0,80(s1)
    80001e30:	c511                	beqz	a0,80001e3c <freeproc+0x2a>
        proc_freepagetable(p->pagetable, p->sz);
    80001e32:	64ac                	ld	a1,72(s1)
    80001e34:	00000097          	auipc	ra,0x0
    80001e38:	f8c080e7          	jalr	-116(ra) # 80001dc0 <proc_freepagetable>
    p->pagetable = 0;
    80001e3c:	0404b823          	sd	zero,80(s1)
    p->sz = 0;
    80001e40:	0404b423          	sd	zero,72(s1)
    p->pid = 0;
    80001e44:	0204a823          	sw	zero,48(s1)
    p->parent = 0;
    80001e48:	0204bc23          	sd	zero,56(s1)
    p->name[0] = 0;
    80001e4c:	14048c23          	sb	zero,344(s1)
    p->chan = 0;
    80001e50:	0204b023          	sd	zero,32(s1)
    p->killed = 0;
    80001e54:	0204a423          	sw	zero,40(s1)
    p->xstate = 0;
    80001e58:	0204a623          	sw	zero,44(s1)
    p->state = UNUSED;
    80001e5c:	0004ac23          	sw	zero,24(s1)
}
    80001e60:	60e2                	ld	ra,24(sp)
    80001e62:	6442                	ld	s0,16(sp)
    80001e64:	64a2                	ld	s1,8(sp)
    80001e66:	6105                	addi	sp,sp,32
    80001e68:	8082                	ret

0000000080001e6a <allocproc>:
{
    80001e6a:	1101                	addi	sp,sp,-32
    80001e6c:	ec06                	sd	ra,24(sp)
    80001e6e:	e822                	sd	s0,16(sp)
    80001e70:	e426                	sd	s1,8(sp)
    80001e72:	e04a                	sd	s2,0(sp)
    80001e74:	1000                	addi	s0,sp,32
    for (p = proc; p < &proc[NPROC]; p++)
    80001e76:	0000f497          	auipc	s1,0xf
    80001e7a:	26a48493          	addi	s1,s1,618 # 800110e0 <proc>
    80001e7e:	00015917          	auipc	s2,0x15
    80001e82:	c6290913          	addi	s2,s2,-926 # 80016ae0 <tickslock>
        acquire(&p->lock);
    80001e86:	8526                	mv	a0,s1
    80001e88:	fffff097          	auipc	ra,0xfffff
    80001e8c:	e7e080e7          	jalr	-386(ra) # 80000d06 <acquire>
        if (p->state == UNUSED)
    80001e90:	4c9c                	lw	a5,24(s1)
    80001e92:	cf81                	beqz	a5,80001eaa <allocproc+0x40>
            release(&p->lock);
    80001e94:	8526                	mv	a0,s1
    80001e96:	fffff097          	auipc	ra,0xfffff
    80001e9a:	f20080e7          	jalr	-224(ra) # 80000db6 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80001e9e:	16848493          	addi	s1,s1,360
    80001ea2:	ff2492e3          	bne	s1,s2,80001e86 <allocproc+0x1c>
    return 0;
    80001ea6:	4481                	li	s1,0
    80001ea8:	a889                	j	80001efa <allocproc+0x90>
    p->pid = allocpid();
    80001eaa:	00000097          	auipc	ra,0x0
    80001eae:	e34080e7          	jalr	-460(ra) # 80001cde <allocpid>
    80001eb2:	d888                	sw	a0,48(s1)
    p->state = USED;
    80001eb4:	4785                	li	a5,1
    80001eb6:	cc9c                	sw	a5,24(s1)
    if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    80001eb8:	fffff097          	auipc	ra,0xfffff
    80001ebc:	d0e080e7          	jalr	-754(ra) # 80000bc6 <kalloc>
    80001ec0:	892a                	mv	s2,a0
    80001ec2:	eca8                	sd	a0,88(s1)
    80001ec4:	c131                	beqz	a0,80001f08 <allocproc+0x9e>
    p->pagetable = proc_pagetable(p);
    80001ec6:	8526                	mv	a0,s1
    80001ec8:	00000097          	auipc	ra,0x0
    80001ecc:	e5c080e7          	jalr	-420(ra) # 80001d24 <proc_pagetable>
    80001ed0:	892a                	mv	s2,a0
    80001ed2:	e8a8                	sd	a0,80(s1)
    if (p->pagetable == 0)
    80001ed4:	c531                	beqz	a0,80001f20 <allocproc+0xb6>
    memset(&p->context, 0, sizeof(p->context));
    80001ed6:	07000613          	li	a2,112
    80001eda:	4581                	li	a1,0
    80001edc:	06048513          	addi	a0,s1,96
    80001ee0:	fffff097          	auipc	ra,0xfffff
    80001ee4:	f1e080e7          	jalr	-226(ra) # 80000dfe <memset>
    p->context.ra = (uint64)forkret;
    80001ee8:	00000797          	auipc	a5,0x0
    80001eec:	db078793          	addi	a5,a5,-592 # 80001c98 <forkret>
    80001ef0:	f0bc                	sd	a5,96(s1)
    p->context.sp = p->kstack + PGSIZE;
    80001ef2:	60bc                	ld	a5,64(s1)
    80001ef4:	6705                	lui	a4,0x1
    80001ef6:	97ba                	add	a5,a5,a4
    80001ef8:	f4bc                	sd	a5,104(s1)
}
    80001efa:	8526                	mv	a0,s1
    80001efc:	60e2                	ld	ra,24(sp)
    80001efe:	6442                	ld	s0,16(sp)
    80001f00:	64a2                	ld	s1,8(sp)
    80001f02:	6902                	ld	s2,0(sp)
    80001f04:	6105                	addi	sp,sp,32
    80001f06:	8082                	ret
        freeproc(p);
    80001f08:	8526                	mv	a0,s1
    80001f0a:	00000097          	auipc	ra,0x0
    80001f0e:	f08080e7          	jalr	-248(ra) # 80001e12 <freeproc>
        release(&p->lock);
    80001f12:	8526                	mv	a0,s1
    80001f14:	fffff097          	auipc	ra,0xfffff
    80001f18:	ea2080e7          	jalr	-350(ra) # 80000db6 <release>
        return 0;
    80001f1c:	84ca                	mv	s1,s2
    80001f1e:	bff1                	j	80001efa <allocproc+0x90>
        freeproc(p);
    80001f20:	8526                	mv	a0,s1
    80001f22:	00000097          	auipc	ra,0x0
    80001f26:	ef0080e7          	jalr	-272(ra) # 80001e12 <freeproc>
        release(&p->lock);
    80001f2a:	8526                	mv	a0,s1
    80001f2c:	fffff097          	auipc	ra,0xfffff
    80001f30:	e8a080e7          	jalr	-374(ra) # 80000db6 <release>
        return 0;
    80001f34:	84ca                	mv	s1,s2
    80001f36:	b7d1                	j	80001efa <allocproc+0x90>

0000000080001f38 <userinit>:
{
    80001f38:	1101                	addi	sp,sp,-32
    80001f3a:	ec06                	sd	ra,24(sp)
    80001f3c:	e822                	sd	s0,16(sp)
    80001f3e:	e426                	sd	s1,8(sp)
    80001f40:	1000                	addi	s0,sp,32
    p = allocproc();
    80001f42:	00000097          	auipc	ra,0x0
    80001f46:	f28080e7          	jalr	-216(ra) # 80001e6a <allocproc>
    80001f4a:	84aa                	mv	s1,a0
    initproc = p;
    80001f4c:	00007797          	auipc	a5,0x7
    80001f50:	aea7b623          	sd	a0,-1300(a5) # 80008a38 <initproc>
    uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001f54:	03400613          	li	a2,52
    80001f58:	00007597          	auipc	a1,0x7
    80001f5c:	a4858593          	addi	a1,a1,-1464 # 800089a0 <initcode>
    80001f60:	6928                	ld	a0,80(a0)
    80001f62:	fffff097          	auipc	ra,0xfffff
    80001f66:	548080e7          	jalr	1352(ra) # 800014aa <uvmfirst>
    p->sz = PGSIZE;
    80001f6a:	6785                	lui	a5,0x1
    80001f6c:	e4bc                	sd	a5,72(s1)
    p->trapframe->epc = 0;     // user program counter
    80001f6e:	6cb8                	ld	a4,88(s1)
    80001f70:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    p->trapframe->sp = PGSIZE; // user stack pointer
    80001f74:	6cb8                	ld	a4,88(s1)
    80001f76:	fb1c                	sd	a5,48(a4)
    safestrcpy(p->name, "initcode", sizeof(p->name));
    80001f78:	4641                	li	a2,16
    80001f7a:	00006597          	auipc	a1,0x6
    80001f7e:	2a658593          	addi	a1,a1,678 # 80008220 <__func__.1+0x218>
    80001f82:	15848513          	addi	a0,s1,344
    80001f86:	fffff097          	auipc	ra,0xfffff
    80001f8a:	fce080e7          	jalr	-50(ra) # 80000f54 <safestrcpy>
    p->cwd = namei("/");
    80001f8e:	00006517          	auipc	a0,0x6
    80001f92:	2a250513          	addi	a0,a0,674 # 80008230 <__func__.1+0x228>
    80001f96:	00002097          	auipc	ra,0x2
    80001f9a:	476080e7          	jalr	1142(ra) # 8000440c <namei>
    80001f9e:	14a4b823          	sd	a0,336(s1)
    p->state = RUNNABLE;
    80001fa2:	478d                	li	a5,3
    80001fa4:	cc9c                	sw	a5,24(s1)
    release(&p->lock);
    80001fa6:	8526                	mv	a0,s1
    80001fa8:	fffff097          	auipc	ra,0xfffff
    80001fac:	e0e080e7          	jalr	-498(ra) # 80000db6 <release>
}
    80001fb0:	60e2                	ld	ra,24(sp)
    80001fb2:	6442                	ld	s0,16(sp)
    80001fb4:	64a2                	ld	s1,8(sp)
    80001fb6:	6105                	addi	sp,sp,32
    80001fb8:	8082                	ret

0000000080001fba <growproc>:
{
    80001fba:	1101                	addi	sp,sp,-32
    80001fbc:	ec06                	sd	ra,24(sp)
    80001fbe:	e822                	sd	s0,16(sp)
    80001fc0:	e426                	sd	s1,8(sp)
    80001fc2:	e04a                	sd	s2,0(sp)
    80001fc4:	1000                	addi	s0,sp,32
    80001fc6:	892a                	mv	s2,a0
    struct proc *p = myproc();
    80001fc8:	00000097          	auipc	ra,0x0
    80001fcc:	c98080e7          	jalr	-872(ra) # 80001c60 <myproc>
    80001fd0:	84aa                	mv	s1,a0
    sz = p->sz;
    80001fd2:	652c                	ld	a1,72(a0)
    if (n > 0)
    80001fd4:	01204c63          	bgtz	s2,80001fec <growproc+0x32>
    else if (n < 0)
    80001fd8:	02094663          	bltz	s2,80002004 <growproc+0x4a>
    p->sz = sz;
    80001fdc:	e4ac                	sd	a1,72(s1)
    return 0;
    80001fde:	4501                	li	a0,0
}
    80001fe0:	60e2                	ld	ra,24(sp)
    80001fe2:	6442                	ld	s0,16(sp)
    80001fe4:	64a2                	ld	s1,8(sp)
    80001fe6:	6902                	ld	s2,0(sp)
    80001fe8:	6105                	addi	sp,sp,32
    80001fea:	8082                	ret
        if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    80001fec:	4691                	li	a3,4
    80001fee:	00b90633          	add	a2,s2,a1
    80001ff2:	6928                	ld	a0,80(a0)
    80001ff4:	fffff097          	auipc	ra,0xfffff
    80001ff8:	570080e7          	jalr	1392(ra) # 80001564 <uvmalloc>
    80001ffc:	85aa                	mv	a1,a0
    80001ffe:	fd79                	bnez	a0,80001fdc <growproc+0x22>
            return -1;
    80002000:	557d                	li	a0,-1
    80002002:	bff9                	j	80001fe0 <growproc+0x26>
        sz = uvmdealloc(p->pagetable, sz, sz + n);
    80002004:	00b90633          	add	a2,s2,a1
    80002008:	6928                	ld	a0,80(a0)
    8000200a:	fffff097          	auipc	ra,0xfffff
    8000200e:	512080e7          	jalr	1298(ra) # 8000151c <uvmdealloc>
    80002012:	85aa                	mv	a1,a0
    80002014:	b7e1                	j	80001fdc <growproc+0x22>

0000000080002016 <ps>:
{
    80002016:	711d                	addi	sp,sp,-96
    80002018:	ec86                	sd	ra,88(sp)
    8000201a:	e8a2                	sd	s0,80(sp)
    8000201c:	e4a6                	sd	s1,72(sp)
    8000201e:	e0ca                	sd	s2,64(sp)
    80002020:	fc4e                	sd	s3,56(sp)
    80002022:	f852                	sd	s4,48(sp)
    80002024:	f456                	sd	s5,40(sp)
    80002026:	f05a                	sd	s6,32(sp)
    80002028:	ec5e                	sd	s7,24(sp)
    8000202a:	e862                	sd	s8,16(sp)
    8000202c:	e466                	sd	s9,8(sp)
    8000202e:	1080                	addi	s0,sp,96
    80002030:	84aa                	mv	s1,a0
    80002032:	8a2e                	mv	s4,a1
    void *result = (void *)myproc()->sz;
    80002034:	00000097          	auipc	ra,0x0
    80002038:	c2c080e7          	jalr	-980(ra) # 80001c60 <myproc>
        return result;
    8000203c:	4901                	li	s2,0
    if (count == 0)
    8000203e:	0c0a0563          	beqz	s4,80002108 <ps+0xf2>
    void *result = (void *)myproc()->sz;
    80002042:	04853b83          	ld	s7,72(a0)
    if (growproc(count * sizeof(struct user_proc)) < 0)
    80002046:	003a151b          	slliw	a0,s4,0x3
    8000204a:	0145053b          	addw	a0,a0,s4
    8000204e:	050a                	slli	a0,a0,0x2
    80002050:	00000097          	auipc	ra,0x0
    80002054:	f6a080e7          	jalr	-150(ra) # 80001fba <growproc>
    80002058:	14054163          	bltz	a0,8000219a <ps+0x184>
    struct user_proc loc_result[count];
    8000205c:	003a1a93          	slli	s5,s4,0x3
    80002060:	9ad2                	add	s5,s5,s4
    80002062:	0a8a                	slli	s5,s5,0x2
    80002064:	00fa8793          	addi	a5,s5,15
    80002068:	8391                	srli	a5,a5,0x4
    8000206a:	0792                	slli	a5,a5,0x4
    8000206c:	40f10133          	sub	sp,sp,a5
    80002070:	8b0a                	mv	s6,sp
    struct proc *p = proc + start;
    80002072:	16800793          	li	a5,360
    80002076:	02f484b3          	mul	s1,s1,a5
    8000207a:	0000f797          	auipc	a5,0xf
    8000207e:	06678793          	addi	a5,a5,102 # 800110e0 <proc>
    80002082:	94be                	add	s1,s1,a5
    if (p >= &proc[NPROC])
    80002084:	00015797          	auipc	a5,0x15
    80002088:	a5c78793          	addi	a5,a5,-1444 # 80016ae0 <tickslock>
        return result;
    8000208c:	4901                	li	s2,0
    if (p >= &proc[NPROC])
    8000208e:	06f4fd63          	bgeu	s1,a5,80002108 <ps+0xf2>
    acquire(&wait_lock);
    80002092:	0000f517          	auipc	a0,0xf
    80002096:	03650513          	addi	a0,a0,54 # 800110c8 <wait_lock>
    8000209a:	fffff097          	auipc	ra,0xfffff
    8000209e:	c6c080e7          	jalr	-916(ra) # 80000d06 <acquire>
    for (; p < &proc[NPROC]; p++)
    800020a2:	01410913          	addi	s2,sp,20
    uint8 localCount = 0;
    800020a6:	4981                	li	s3,0
        copy_array(p->name, loc_result[localCount].name, 16);
    800020a8:	4cc1                	li	s9,16
    for (; p < &proc[NPROC]; p++)
    800020aa:	00015c17          	auipc	s8,0x15
    800020ae:	a36c0c13          	addi	s8,s8,-1482 # 80016ae0 <tickslock>
    800020b2:	a07d                	j	80002160 <ps+0x14a>
            loc_result[localCount].state = UNUSED;
    800020b4:	00399793          	slli	a5,s3,0x3
    800020b8:	97ce                	add	a5,a5,s3
    800020ba:	078a                	slli	a5,a5,0x2
    800020bc:	97da                	add	a5,a5,s6
    800020be:	0007a023          	sw	zero,0(a5)
            release(&p->lock);
    800020c2:	8526                	mv	a0,s1
    800020c4:	fffff097          	auipc	ra,0xfffff
    800020c8:	cf2080e7          	jalr	-782(ra) # 80000db6 <release>
    release(&wait_lock);
    800020cc:	0000f517          	auipc	a0,0xf
    800020d0:	ffc50513          	addi	a0,a0,-4 # 800110c8 <wait_lock>
    800020d4:	fffff097          	auipc	ra,0xfffff
    800020d8:	ce2080e7          	jalr	-798(ra) # 80000db6 <release>
    if (localCount < count)
    800020dc:	0149f963          	bgeu	s3,s4,800020ee <ps+0xd8>
        loc_result[localCount].state = UNUSED; // if we reach the end of processes
    800020e0:	00399793          	slli	a5,s3,0x3
    800020e4:	97ce                	add	a5,a5,s3
    800020e6:	078a                	slli	a5,a5,0x2
    800020e8:	97da                	add	a5,a5,s6
    800020ea:	0007a023          	sw	zero,0(a5)
    void *result = (void *)myproc()->sz;
    800020ee:	895e                	mv	s2,s7
    copyout(myproc()->pagetable, (uint64)result, (void *)loc_result, count * sizeof(struct user_proc));
    800020f0:	00000097          	auipc	ra,0x0
    800020f4:	b70080e7          	jalr	-1168(ra) # 80001c60 <myproc>
    800020f8:	86d6                	mv	a3,s5
    800020fa:	865a                	mv	a2,s6
    800020fc:	85de                	mv	a1,s7
    800020fe:	6928                	ld	a0,80(a0)
    80002100:	fffff097          	auipc	ra,0xfffff
    80002104:	6d8080e7          	jalr	1752(ra) # 800017d8 <copyout>
}
    80002108:	854a                	mv	a0,s2
    8000210a:	fa040113          	addi	sp,s0,-96
    8000210e:	60e6                	ld	ra,88(sp)
    80002110:	6446                	ld	s0,80(sp)
    80002112:	64a6                	ld	s1,72(sp)
    80002114:	6906                	ld	s2,64(sp)
    80002116:	79e2                	ld	s3,56(sp)
    80002118:	7a42                	ld	s4,48(sp)
    8000211a:	7aa2                	ld	s5,40(sp)
    8000211c:	7b02                	ld	s6,32(sp)
    8000211e:	6be2                	ld	s7,24(sp)
    80002120:	6c42                	ld	s8,16(sp)
    80002122:	6ca2                	ld	s9,8(sp)
    80002124:	6125                	addi	sp,sp,96
    80002126:	8082                	ret
            acquire(&p->parent->lock);
    80002128:	fffff097          	auipc	ra,0xfffff
    8000212c:	bde080e7          	jalr	-1058(ra) # 80000d06 <acquire>
            loc_result[localCount].parent_id = p->parent->pid;
    80002130:	7c88                	ld	a0,56(s1)
    80002132:	591c                	lw	a5,48(a0)
    80002134:	fef92e23          	sw	a5,-4(s2)
            release(&p->parent->lock);
    80002138:	fffff097          	auipc	ra,0xfffff
    8000213c:	c7e080e7          	jalr	-898(ra) # 80000db6 <release>
        release(&p->lock);
    80002140:	8526                	mv	a0,s1
    80002142:	fffff097          	auipc	ra,0xfffff
    80002146:	c74080e7          	jalr	-908(ra) # 80000db6 <release>
        localCount++;
    8000214a:	2985                	addiw	s3,s3,1
    8000214c:	0ff9f993          	zext.b	s3,s3
    for (; p < &proc[NPROC]; p++)
    80002150:	16848493          	addi	s1,s1,360
    80002154:	f784fce3          	bgeu	s1,s8,800020cc <ps+0xb6>
        if (localCount == count)
    80002158:	02490913          	addi	s2,s2,36
    8000215c:	053a0163          	beq	s4,s3,8000219e <ps+0x188>
        acquire(&p->lock);
    80002160:	8526                	mv	a0,s1
    80002162:	fffff097          	auipc	ra,0xfffff
    80002166:	ba4080e7          	jalr	-1116(ra) # 80000d06 <acquire>
        if (p->state == UNUSED)
    8000216a:	4c9c                	lw	a5,24(s1)
    8000216c:	d7a1                	beqz	a5,800020b4 <ps+0x9e>
        loc_result[localCount].state = p->state;
    8000216e:	fef92623          	sw	a5,-20(s2)
        loc_result[localCount].killed = p->killed;
    80002172:	549c                	lw	a5,40(s1)
    80002174:	fef92823          	sw	a5,-16(s2)
        loc_result[localCount].xstate = p->xstate;
    80002178:	54dc                	lw	a5,44(s1)
    8000217a:	fef92a23          	sw	a5,-12(s2)
        loc_result[localCount].pid = p->pid;
    8000217e:	589c                	lw	a5,48(s1)
    80002180:	fef92c23          	sw	a5,-8(s2)
        copy_array(p->name, loc_result[localCount].name, 16);
    80002184:	8666                	mv	a2,s9
    80002186:	85ca                	mv	a1,s2
    80002188:	15848513          	addi	a0,s1,344
    8000218c:	00000097          	auipc	ra,0x0
    80002190:	a78080e7          	jalr	-1416(ra) # 80001c04 <copy_array>
        if (p->parent != 0) // init
    80002194:	7c88                	ld	a0,56(s1)
    80002196:	f949                	bnez	a0,80002128 <ps+0x112>
    80002198:	b765                	j	80002140 <ps+0x12a>
        return result;
    8000219a:	4901                	li	s2,0
    8000219c:	b7b5                	j	80002108 <ps+0xf2>
    release(&wait_lock);
    8000219e:	0000f517          	auipc	a0,0xf
    800021a2:	f2a50513          	addi	a0,a0,-214 # 800110c8 <wait_lock>
    800021a6:	fffff097          	auipc	ra,0xfffff
    800021aa:	c10080e7          	jalr	-1008(ra) # 80000db6 <release>
    if (localCount < count)
    800021ae:	b781                	j	800020ee <ps+0xd8>

00000000800021b0 <fork>:
{
    800021b0:	7139                	addi	sp,sp,-64
    800021b2:	fc06                	sd	ra,56(sp)
    800021b4:	f822                	sd	s0,48(sp)
    800021b6:	f04a                	sd	s2,32(sp)
    800021b8:	e456                	sd	s5,8(sp)
    800021ba:	0080                	addi	s0,sp,64
    struct proc *p = myproc();
    800021bc:	00000097          	auipc	ra,0x0
    800021c0:	aa4080e7          	jalr	-1372(ra) # 80001c60 <myproc>
    800021c4:	8aaa                	mv	s5,a0
    if ((np = allocproc()) == 0)
    800021c6:	00000097          	auipc	ra,0x0
    800021ca:	ca4080e7          	jalr	-860(ra) # 80001e6a <allocproc>
    800021ce:	12050063          	beqz	a0,800022ee <fork+0x13e>
    800021d2:	e852                	sd	s4,16(sp)
    800021d4:	8a2a                	mv	s4,a0
    if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    800021d6:	048ab603          	ld	a2,72(s5)
    800021da:	692c                	ld	a1,80(a0)
    800021dc:	050ab503          	ld	a0,80(s5)
    800021e0:	fffff097          	auipc	ra,0xfffff
    800021e4:	4f0080e7          	jalr	1264(ra) # 800016d0 <uvmcopy>
    800021e8:	04054a63          	bltz	a0,8000223c <fork+0x8c>
    800021ec:	f426                	sd	s1,40(sp)
    800021ee:	ec4e                	sd	s3,24(sp)
    np->sz = p->sz;
    800021f0:	048ab783          	ld	a5,72(s5)
    800021f4:	04fa3423          	sd	a5,72(s4)
    *(np->trapframe) = *(p->trapframe);
    800021f8:	058ab683          	ld	a3,88(s5)
    800021fc:	87b6                	mv	a5,a3
    800021fe:	058a3703          	ld	a4,88(s4)
    80002202:	12068693          	addi	a3,a3,288
    80002206:	0007b803          	ld	a6,0(a5)
    8000220a:	6788                	ld	a0,8(a5)
    8000220c:	6b8c                	ld	a1,16(a5)
    8000220e:	6f90                	ld	a2,24(a5)
    80002210:	01073023          	sd	a6,0(a4)
    80002214:	e708                	sd	a0,8(a4)
    80002216:	eb0c                	sd	a1,16(a4)
    80002218:	ef10                	sd	a2,24(a4)
    8000221a:	02078793          	addi	a5,a5,32
    8000221e:	02070713          	addi	a4,a4,32
    80002222:	fed792e3          	bne	a5,a3,80002206 <fork+0x56>
    np->trapframe->a0 = 0;
    80002226:	058a3783          	ld	a5,88(s4)
    8000222a:	0607b823          	sd	zero,112(a5)
    for (i = 0; i < NOFILE; i++)
    8000222e:	0d0a8493          	addi	s1,s5,208
    80002232:	0d0a0913          	addi	s2,s4,208
    80002236:	150a8993          	addi	s3,s5,336
    8000223a:	a015                	j	8000225e <fork+0xae>
        freeproc(np);
    8000223c:	8552                	mv	a0,s4
    8000223e:	00000097          	auipc	ra,0x0
    80002242:	bd4080e7          	jalr	-1068(ra) # 80001e12 <freeproc>
        release(&np->lock);
    80002246:	8552                	mv	a0,s4
    80002248:	fffff097          	auipc	ra,0xfffff
    8000224c:	b6e080e7          	jalr	-1170(ra) # 80000db6 <release>
        return -1;
    80002250:	597d                	li	s2,-1
    80002252:	6a42                	ld	s4,16(sp)
    80002254:	a071                	j	800022e0 <fork+0x130>
    for (i = 0; i < NOFILE; i++)
    80002256:	04a1                	addi	s1,s1,8
    80002258:	0921                	addi	s2,s2,8
    8000225a:	01348b63          	beq	s1,s3,80002270 <fork+0xc0>
        if (p->ofile[i])
    8000225e:	6088                	ld	a0,0(s1)
    80002260:	d97d                	beqz	a0,80002256 <fork+0xa6>
            np->ofile[i] = filedup(p->ofile[i]);
    80002262:	00003097          	auipc	ra,0x3
    80002266:	82e080e7          	jalr	-2002(ra) # 80004a90 <filedup>
    8000226a:	00a93023          	sd	a0,0(s2)
    8000226e:	b7e5                	j	80002256 <fork+0xa6>
    np->cwd = idup(p->cwd);
    80002270:	150ab503          	ld	a0,336(s5)
    80002274:	00002097          	auipc	ra,0x2
    80002278:	976080e7          	jalr	-1674(ra) # 80003bea <idup>
    8000227c:	14aa3823          	sd	a0,336(s4)
    safestrcpy(np->name, p->name, sizeof(p->name));
    80002280:	4641                	li	a2,16
    80002282:	158a8593          	addi	a1,s5,344
    80002286:	158a0513          	addi	a0,s4,344
    8000228a:	fffff097          	auipc	ra,0xfffff
    8000228e:	cca080e7          	jalr	-822(ra) # 80000f54 <safestrcpy>
    pid = np->pid;
    80002292:	030a2903          	lw	s2,48(s4)
    release(&np->lock);
    80002296:	8552                	mv	a0,s4
    80002298:	fffff097          	auipc	ra,0xfffff
    8000229c:	b1e080e7          	jalr	-1250(ra) # 80000db6 <release>
    acquire(&wait_lock);
    800022a0:	0000f497          	auipc	s1,0xf
    800022a4:	e2848493          	addi	s1,s1,-472 # 800110c8 <wait_lock>
    800022a8:	8526                	mv	a0,s1
    800022aa:	fffff097          	auipc	ra,0xfffff
    800022ae:	a5c080e7          	jalr	-1444(ra) # 80000d06 <acquire>
    np->parent = p;
    800022b2:	035a3c23          	sd	s5,56(s4)
    release(&wait_lock);
    800022b6:	8526                	mv	a0,s1
    800022b8:	fffff097          	auipc	ra,0xfffff
    800022bc:	afe080e7          	jalr	-1282(ra) # 80000db6 <release>
    acquire(&np->lock);
    800022c0:	8552                	mv	a0,s4
    800022c2:	fffff097          	auipc	ra,0xfffff
    800022c6:	a44080e7          	jalr	-1468(ra) # 80000d06 <acquire>
    np->state = RUNNABLE;
    800022ca:	478d                	li	a5,3
    800022cc:	00fa2c23          	sw	a5,24(s4)
    release(&np->lock);
    800022d0:	8552                	mv	a0,s4
    800022d2:	fffff097          	auipc	ra,0xfffff
    800022d6:	ae4080e7          	jalr	-1308(ra) # 80000db6 <release>
    return pid;
    800022da:	74a2                	ld	s1,40(sp)
    800022dc:	69e2                	ld	s3,24(sp)
    800022de:	6a42                	ld	s4,16(sp)
}
    800022e0:	854a                	mv	a0,s2
    800022e2:	70e2                	ld	ra,56(sp)
    800022e4:	7442                	ld	s0,48(sp)
    800022e6:	7902                	ld	s2,32(sp)
    800022e8:	6aa2                	ld	s5,8(sp)
    800022ea:	6121                	addi	sp,sp,64
    800022ec:	8082                	ret
        return -1;
    800022ee:	597d                	li	s2,-1
    800022f0:	bfc5                	j	800022e0 <fork+0x130>

00000000800022f2 <scheduler>:
{
    800022f2:	1101                	addi	sp,sp,-32
    800022f4:	ec06                	sd	ra,24(sp)
    800022f6:	e822                	sd	s0,16(sp)
    800022f8:	e426                	sd	s1,8(sp)
    800022fa:	1000                	addi	s0,sp,32
        (*sched_pointer)();
    800022fc:	00006497          	auipc	s1,0x6
    80002300:	68c48493          	addi	s1,s1,1676 # 80008988 <sched_pointer>
    80002304:	609c                	ld	a5,0(s1)
    80002306:	9782                	jalr	a5
    while (1)
    80002308:	bff5                	j	80002304 <scheduler+0x12>

000000008000230a <sched>:
{
    8000230a:	7179                	addi	sp,sp,-48
    8000230c:	f406                	sd	ra,40(sp)
    8000230e:	f022                	sd	s0,32(sp)
    80002310:	ec26                	sd	s1,24(sp)
    80002312:	e84a                	sd	s2,16(sp)
    80002314:	e44e                	sd	s3,8(sp)
    80002316:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80002318:	00000097          	auipc	ra,0x0
    8000231c:	948080e7          	jalr	-1720(ra) # 80001c60 <myproc>
    80002320:	84aa                	mv	s1,a0
    if (!holding(&p->lock))
    80002322:	fffff097          	auipc	ra,0xfffff
    80002326:	96a080e7          	jalr	-1686(ra) # 80000c8c <holding>
    8000232a:	c53d                	beqz	a0,80002398 <sched+0x8e>
    8000232c:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    8000232e:	2781                	sext.w	a5,a5
    80002330:	079e                	slli	a5,a5,0x7
    80002332:	0000f717          	auipc	a4,0xf
    80002336:	97e70713          	addi	a4,a4,-1666 # 80010cb0 <cpus>
    8000233a:	97ba                	add	a5,a5,a4
    8000233c:	5fb8                	lw	a4,120(a5)
    8000233e:	4785                	li	a5,1
    80002340:	06f71463          	bne	a4,a5,800023a8 <sched+0x9e>
    if (p->state == RUNNING)
    80002344:	4c98                	lw	a4,24(s1)
    80002346:	4791                	li	a5,4
    80002348:	06f70863          	beq	a4,a5,800023b8 <sched+0xae>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    8000234c:	100027f3          	csrr	a5,sstatus
    return (x & SSTATUS_SIE) != 0;
    80002350:	8b89                	andi	a5,a5,2
    if (intr_get())
    80002352:	ebbd                	bnez	a5,800023c8 <sched+0xbe>
    asm volatile("mv %0, tp" : "=r"(x));
    80002354:	8792                	mv	a5,tp
    intena = mycpu()->intena;
    80002356:	0000f917          	auipc	s2,0xf
    8000235a:	95a90913          	addi	s2,s2,-1702 # 80010cb0 <cpus>
    8000235e:	2781                	sext.w	a5,a5
    80002360:	079e                	slli	a5,a5,0x7
    80002362:	97ca                	add	a5,a5,s2
    80002364:	07c7a983          	lw	s3,124(a5)
    80002368:	8592                	mv	a1,tp
    swtch(&p->context, &mycpu()->context);
    8000236a:	2581                	sext.w	a1,a1
    8000236c:	059e                	slli	a1,a1,0x7
    8000236e:	05a1                	addi	a1,a1,8
    80002370:	95ca                	add	a1,a1,s2
    80002372:	06048513          	addi	a0,s1,96
    80002376:	00000097          	auipc	ra,0x0
    8000237a:	6de080e7          	jalr	1758(ra) # 80002a54 <swtch>
    8000237e:	8792                	mv	a5,tp
    mycpu()->intena = intena;
    80002380:	2781                	sext.w	a5,a5
    80002382:	079e                	slli	a5,a5,0x7
    80002384:	993e                	add	s2,s2,a5
    80002386:	07392e23          	sw	s3,124(s2)
}
    8000238a:	70a2                	ld	ra,40(sp)
    8000238c:	7402                	ld	s0,32(sp)
    8000238e:	64e2                	ld	s1,24(sp)
    80002390:	6942                	ld	s2,16(sp)
    80002392:	69a2                	ld	s3,8(sp)
    80002394:	6145                	addi	sp,sp,48
    80002396:	8082                	ret
        panic("sched p->lock");
    80002398:	00006517          	auipc	a0,0x6
    8000239c:	ea050513          	addi	a0,a0,-352 # 80008238 <__func__.1+0x230>
    800023a0:	ffffe097          	auipc	ra,0xffffe
    800023a4:	1c0080e7          	jalr	448(ra) # 80000560 <panic>
        panic("sched locks");
    800023a8:	00006517          	auipc	a0,0x6
    800023ac:	ea050513          	addi	a0,a0,-352 # 80008248 <__func__.1+0x240>
    800023b0:	ffffe097          	auipc	ra,0xffffe
    800023b4:	1b0080e7          	jalr	432(ra) # 80000560 <panic>
        panic("sched running");
    800023b8:	00006517          	auipc	a0,0x6
    800023bc:	ea050513          	addi	a0,a0,-352 # 80008258 <__func__.1+0x250>
    800023c0:	ffffe097          	auipc	ra,0xffffe
    800023c4:	1a0080e7          	jalr	416(ra) # 80000560 <panic>
        panic("sched interruptible");
    800023c8:	00006517          	auipc	a0,0x6
    800023cc:	ea050513          	addi	a0,a0,-352 # 80008268 <__func__.1+0x260>
    800023d0:	ffffe097          	auipc	ra,0xffffe
    800023d4:	190080e7          	jalr	400(ra) # 80000560 <panic>

00000000800023d8 <yield>:
{
    800023d8:	1101                	addi	sp,sp,-32
    800023da:	ec06                	sd	ra,24(sp)
    800023dc:	e822                	sd	s0,16(sp)
    800023de:	e426                	sd	s1,8(sp)
    800023e0:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    800023e2:	00000097          	auipc	ra,0x0
    800023e6:	87e080e7          	jalr	-1922(ra) # 80001c60 <myproc>
    800023ea:	84aa                	mv	s1,a0
    acquire(&p->lock);
    800023ec:	fffff097          	auipc	ra,0xfffff
    800023f0:	91a080e7          	jalr	-1766(ra) # 80000d06 <acquire>
    p->state = RUNNABLE;
    800023f4:	478d                	li	a5,3
    800023f6:	cc9c                	sw	a5,24(s1)
    sched();
    800023f8:	00000097          	auipc	ra,0x0
    800023fc:	f12080e7          	jalr	-238(ra) # 8000230a <sched>
    release(&p->lock);
    80002400:	8526                	mv	a0,s1
    80002402:	fffff097          	auipc	ra,0xfffff
    80002406:	9b4080e7          	jalr	-1612(ra) # 80000db6 <release>
}
    8000240a:	60e2                	ld	ra,24(sp)
    8000240c:	6442                	ld	s0,16(sp)
    8000240e:	64a2                	ld	s1,8(sp)
    80002410:	6105                	addi	sp,sp,32
    80002412:	8082                	ret

0000000080002414 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    80002414:	7179                	addi	sp,sp,-48
    80002416:	f406                	sd	ra,40(sp)
    80002418:	f022                	sd	s0,32(sp)
    8000241a:	ec26                	sd	s1,24(sp)
    8000241c:	e84a                	sd	s2,16(sp)
    8000241e:	e44e                	sd	s3,8(sp)
    80002420:	1800                	addi	s0,sp,48
    80002422:	89aa                	mv	s3,a0
    80002424:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80002426:	00000097          	auipc	ra,0x0
    8000242a:	83a080e7          	jalr	-1990(ra) # 80001c60 <myproc>
    8000242e:	84aa                	mv	s1,a0
    // Once we hold p->lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup locks p->lock),
    // so it's okay to release lk.

    acquire(&p->lock); // DOC: sleeplock1
    80002430:	fffff097          	auipc	ra,0xfffff
    80002434:	8d6080e7          	jalr	-1834(ra) # 80000d06 <acquire>
    release(lk);
    80002438:	854a                	mv	a0,s2
    8000243a:	fffff097          	auipc	ra,0xfffff
    8000243e:	97c080e7          	jalr	-1668(ra) # 80000db6 <release>

    // Go to sleep.
    p->chan = chan;
    80002442:	0334b023          	sd	s3,32(s1)
    p->state = SLEEPING;
    80002446:	4789                	li	a5,2
    80002448:	cc9c                	sw	a5,24(s1)

    sched();
    8000244a:	00000097          	auipc	ra,0x0
    8000244e:	ec0080e7          	jalr	-320(ra) # 8000230a <sched>

    // Tidy up.
    p->chan = 0;
    80002452:	0204b023          	sd	zero,32(s1)

    // Reacquire original lock.
    release(&p->lock);
    80002456:	8526                	mv	a0,s1
    80002458:	fffff097          	auipc	ra,0xfffff
    8000245c:	95e080e7          	jalr	-1698(ra) # 80000db6 <release>
    acquire(lk);
    80002460:	854a                	mv	a0,s2
    80002462:	fffff097          	auipc	ra,0xfffff
    80002466:	8a4080e7          	jalr	-1884(ra) # 80000d06 <acquire>
}
    8000246a:	70a2                	ld	ra,40(sp)
    8000246c:	7402                	ld	s0,32(sp)
    8000246e:	64e2                	ld	s1,24(sp)
    80002470:	6942                	ld	s2,16(sp)
    80002472:	69a2                	ld	s3,8(sp)
    80002474:	6145                	addi	sp,sp,48
    80002476:	8082                	ret

0000000080002478 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    80002478:	7139                	addi	sp,sp,-64
    8000247a:	fc06                	sd	ra,56(sp)
    8000247c:	f822                	sd	s0,48(sp)
    8000247e:	f426                	sd	s1,40(sp)
    80002480:	f04a                	sd	s2,32(sp)
    80002482:	ec4e                	sd	s3,24(sp)
    80002484:	e852                	sd	s4,16(sp)
    80002486:	e456                	sd	s5,8(sp)
    80002488:	0080                	addi	s0,sp,64
    8000248a:	8a2a                	mv	s4,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    8000248c:	0000f497          	auipc	s1,0xf
    80002490:	c5448493          	addi	s1,s1,-940 # 800110e0 <proc>
    {
        if (p != myproc())
        {
            acquire(&p->lock);
            if (p->state == SLEEPING && p->chan == chan)
    80002494:	4989                	li	s3,2
            {
                p->state = RUNNABLE;
    80002496:	4a8d                	li	s5,3
    for (p = proc; p < &proc[NPROC]; p++)
    80002498:	00014917          	auipc	s2,0x14
    8000249c:	64890913          	addi	s2,s2,1608 # 80016ae0 <tickslock>
    800024a0:	a811                	j	800024b4 <wakeup+0x3c>
            }
            release(&p->lock);
    800024a2:	8526                	mv	a0,s1
    800024a4:	fffff097          	auipc	ra,0xfffff
    800024a8:	912080e7          	jalr	-1774(ra) # 80000db6 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    800024ac:	16848493          	addi	s1,s1,360
    800024b0:	03248663          	beq	s1,s2,800024dc <wakeup+0x64>
        if (p != myproc())
    800024b4:	fffff097          	auipc	ra,0xfffff
    800024b8:	7ac080e7          	jalr	1964(ra) # 80001c60 <myproc>
    800024bc:	fea488e3          	beq	s1,a0,800024ac <wakeup+0x34>
            acquire(&p->lock);
    800024c0:	8526                	mv	a0,s1
    800024c2:	fffff097          	auipc	ra,0xfffff
    800024c6:	844080e7          	jalr	-1980(ra) # 80000d06 <acquire>
            if (p->state == SLEEPING && p->chan == chan)
    800024ca:	4c9c                	lw	a5,24(s1)
    800024cc:	fd379be3          	bne	a5,s3,800024a2 <wakeup+0x2a>
    800024d0:	709c                	ld	a5,32(s1)
    800024d2:	fd4798e3          	bne	a5,s4,800024a2 <wakeup+0x2a>
                p->state = RUNNABLE;
    800024d6:	0154ac23          	sw	s5,24(s1)
    800024da:	b7e1                	j	800024a2 <wakeup+0x2a>
        }
    }
}
    800024dc:	70e2                	ld	ra,56(sp)
    800024de:	7442                	ld	s0,48(sp)
    800024e0:	74a2                	ld	s1,40(sp)
    800024e2:	7902                	ld	s2,32(sp)
    800024e4:	69e2                	ld	s3,24(sp)
    800024e6:	6a42                	ld	s4,16(sp)
    800024e8:	6aa2                	ld	s5,8(sp)
    800024ea:	6121                	addi	sp,sp,64
    800024ec:	8082                	ret

00000000800024ee <reparent>:
{
    800024ee:	7179                	addi	sp,sp,-48
    800024f0:	f406                	sd	ra,40(sp)
    800024f2:	f022                	sd	s0,32(sp)
    800024f4:	ec26                	sd	s1,24(sp)
    800024f6:	e84a                	sd	s2,16(sp)
    800024f8:	e44e                	sd	s3,8(sp)
    800024fa:	e052                	sd	s4,0(sp)
    800024fc:	1800                	addi	s0,sp,48
    800024fe:	892a                	mv	s2,a0
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80002500:	0000f497          	auipc	s1,0xf
    80002504:	be048493          	addi	s1,s1,-1056 # 800110e0 <proc>
            pp->parent = initproc;
    80002508:	00006a17          	auipc	s4,0x6
    8000250c:	530a0a13          	addi	s4,s4,1328 # 80008a38 <initproc>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80002510:	00014997          	auipc	s3,0x14
    80002514:	5d098993          	addi	s3,s3,1488 # 80016ae0 <tickslock>
    80002518:	a029                	j	80002522 <reparent+0x34>
    8000251a:	16848493          	addi	s1,s1,360
    8000251e:	01348d63          	beq	s1,s3,80002538 <reparent+0x4a>
        if (pp->parent == p)
    80002522:	7c9c                	ld	a5,56(s1)
    80002524:	ff279be3          	bne	a5,s2,8000251a <reparent+0x2c>
            pp->parent = initproc;
    80002528:	000a3503          	ld	a0,0(s4)
    8000252c:	fc88                	sd	a0,56(s1)
            wakeup(initproc);
    8000252e:	00000097          	auipc	ra,0x0
    80002532:	f4a080e7          	jalr	-182(ra) # 80002478 <wakeup>
    80002536:	b7d5                	j	8000251a <reparent+0x2c>
}
    80002538:	70a2                	ld	ra,40(sp)
    8000253a:	7402                	ld	s0,32(sp)
    8000253c:	64e2                	ld	s1,24(sp)
    8000253e:	6942                	ld	s2,16(sp)
    80002540:	69a2                	ld	s3,8(sp)
    80002542:	6a02                	ld	s4,0(sp)
    80002544:	6145                	addi	sp,sp,48
    80002546:	8082                	ret

0000000080002548 <exit>:
{
    80002548:	7179                	addi	sp,sp,-48
    8000254a:	f406                	sd	ra,40(sp)
    8000254c:	f022                	sd	s0,32(sp)
    8000254e:	ec26                	sd	s1,24(sp)
    80002550:	e84a                	sd	s2,16(sp)
    80002552:	e44e                	sd	s3,8(sp)
    80002554:	e052                	sd	s4,0(sp)
    80002556:	1800                	addi	s0,sp,48
    80002558:	8a2a                	mv	s4,a0
    struct proc *p = myproc();
    8000255a:	fffff097          	auipc	ra,0xfffff
    8000255e:	706080e7          	jalr	1798(ra) # 80001c60 <myproc>
    80002562:	89aa                	mv	s3,a0
    if (p == initproc)
    80002564:	00006797          	auipc	a5,0x6
    80002568:	4d47b783          	ld	a5,1236(a5) # 80008a38 <initproc>
    8000256c:	0d050493          	addi	s1,a0,208
    80002570:	15050913          	addi	s2,a0,336
    80002574:	00a79d63          	bne	a5,a0,8000258e <exit+0x46>
        panic("init exiting");
    80002578:	00006517          	auipc	a0,0x6
    8000257c:	d0850513          	addi	a0,a0,-760 # 80008280 <__func__.1+0x278>
    80002580:	ffffe097          	auipc	ra,0xffffe
    80002584:	fe0080e7          	jalr	-32(ra) # 80000560 <panic>
    for (int fd = 0; fd < NOFILE; fd++)
    80002588:	04a1                	addi	s1,s1,8
    8000258a:	01248b63          	beq	s1,s2,800025a0 <exit+0x58>
        if (p->ofile[fd])
    8000258e:	6088                	ld	a0,0(s1)
    80002590:	dd65                	beqz	a0,80002588 <exit+0x40>
            fileclose(f);
    80002592:	00002097          	auipc	ra,0x2
    80002596:	550080e7          	jalr	1360(ra) # 80004ae2 <fileclose>
            p->ofile[fd] = 0;
    8000259a:	0004b023          	sd	zero,0(s1)
    8000259e:	b7ed                	j	80002588 <exit+0x40>
    begin_op();
    800025a0:	00002097          	auipc	ra,0x2
    800025a4:	072080e7          	jalr	114(ra) # 80004612 <begin_op>
    iput(p->cwd);
    800025a8:	1509b503          	ld	a0,336(s3)
    800025ac:	00002097          	auipc	ra,0x2
    800025b0:	83a080e7          	jalr	-1990(ra) # 80003de6 <iput>
    end_op();
    800025b4:	00002097          	auipc	ra,0x2
    800025b8:	0d8080e7          	jalr	216(ra) # 8000468c <end_op>
    p->cwd = 0;
    800025bc:	1409b823          	sd	zero,336(s3)
    acquire(&wait_lock);
    800025c0:	0000f497          	auipc	s1,0xf
    800025c4:	b0848493          	addi	s1,s1,-1272 # 800110c8 <wait_lock>
    800025c8:	8526                	mv	a0,s1
    800025ca:	ffffe097          	auipc	ra,0xffffe
    800025ce:	73c080e7          	jalr	1852(ra) # 80000d06 <acquire>
    reparent(p);
    800025d2:	854e                	mv	a0,s3
    800025d4:	00000097          	auipc	ra,0x0
    800025d8:	f1a080e7          	jalr	-230(ra) # 800024ee <reparent>
    wakeup(p->parent);
    800025dc:	0389b503          	ld	a0,56(s3)
    800025e0:	00000097          	auipc	ra,0x0
    800025e4:	e98080e7          	jalr	-360(ra) # 80002478 <wakeup>
    acquire(&p->lock);
    800025e8:	854e                	mv	a0,s3
    800025ea:	ffffe097          	auipc	ra,0xffffe
    800025ee:	71c080e7          	jalr	1820(ra) # 80000d06 <acquire>
    p->xstate = status;
    800025f2:	0349a623          	sw	s4,44(s3)
    p->state = ZOMBIE;
    800025f6:	4795                	li	a5,5
    800025f8:	00f9ac23          	sw	a5,24(s3)
    release(&wait_lock);
    800025fc:	8526                	mv	a0,s1
    800025fe:	ffffe097          	auipc	ra,0xffffe
    80002602:	7b8080e7          	jalr	1976(ra) # 80000db6 <release>
    sched();
    80002606:	00000097          	auipc	ra,0x0
    8000260a:	d04080e7          	jalr	-764(ra) # 8000230a <sched>
    panic("zombie exit");
    8000260e:	00006517          	auipc	a0,0x6
    80002612:	c8250513          	addi	a0,a0,-894 # 80008290 <__func__.1+0x288>
    80002616:	ffffe097          	auipc	ra,0xffffe
    8000261a:	f4a080e7          	jalr	-182(ra) # 80000560 <panic>

000000008000261e <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    8000261e:	7179                	addi	sp,sp,-48
    80002620:	f406                	sd	ra,40(sp)
    80002622:	f022                	sd	s0,32(sp)
    80002624:	ec26                	sd	s1,24(sp)
    80002626:	e84a                	sd	s2,16(sp)
    80002628:	e44e                	sd	s3,8(sp)
    8000262a:	1800                	addi	s0,sp,48
    8000262c:	892a                	mv	s2,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    8000262e:	0000f497          	auipc	s1,0xf
    80002632:	ab248493          	addi	s1,s1,-1358 # 800110e0 <proc>
    80002636:	00014997          	auipc	s3,0x14
    8000263a:	4aa98993          	addi	s3,s3,1194 # 80016ae0 <tickslock>
    {
        acquire(&p->lock);
    8000263e:	8526                	mv	a0,s1
    80002640:	ffffe097          	auipc	ra,0xffffe
    80002644:	6c6080e7          	jalr	1734(ra) # 80000d06 <acquire>
        if (p->pid == pid)
    80002648:	589c                	lw	a5,48(s1)
    8000264a:	01278d63          	beq	a5,s2,80002664 <kill+0x46>
                p->state = RUNNABLE;
            }
            release(&p->lock);
            return 0;
        }
        release(&p->lock);
    8000264e:	8526                	mv	a0,s1
    80002650:	ffffe097          	auipc	ra,0xffffe
    80002654:	766080e7          	jalr	1894(ra) # 80000db6 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80002658:	16848493          	addi	s1,s1,360
    8000265c:	ff3491e3          	bne	s1,s3,8000263e <kill+0x20>
    }
    return -1;
    80002660:	557d                	li	a0,-1
    80002662:	a829                	j	8000267c <kill+0x5e>
            p->killed = 1;
    80002664:	4785                	li	a5,1
    80002666:	d49c                	sw	a5,40(s1)
            if (p->state == SLEEPING)
    80002668:	4c98                	lw	a4,24(s1)
    8000266a:	4789                	li	a5,2
    8000266c:	00f70f63          	beq	a4,a5,8000268a <kill+0x6c>
            release(&p->lock);
    80002670:	8526                	mv	a0,s1
    80002672:	ffffe097          	auipc	ra,0xffffe
    80002676:	744080e7          	jalr	1860(ra) # 80000db6 <release>
            return 0;
    8000267a:	4501                	li	a0,0
}
    8000267c:	70a2                	ld	ra,40(sp)
    8000267e:	7402                	ld	s0,32(sp)
    80002680:	64e2                	ld	s1,24(sp)
    80002682:	6942                	ld	s2,16(sp)
    80002684:	69a2                	ld	s3,8(sp)
    80002686:	6145                	addi	sp,sp,48
    80002688:	8082                	ret
                p->state = RUNNABLE;
    8000268a:	478d                	li	a5,3
    8000268c:	cc9c                	sw	a5,24(s1)
    8000268e:	b7cd                	j	80002670 <kill+0x52>

0000000080002690 <setkilled>:

void setkilled(struct proc *p)
{
    80002690:	1101                	addi	sp,sp,-32
    80002692:	ec06                	sd	ra,24(sp)
    80002694:	e822                	sd	s0,16(sp)
    80002696:	e426                	sd	s1,8(sp)
    80002698:	1000                	addi	s0,sp,32
    8000269a:	84aa                	mv	s1,a0
    acquire(&p->lock);
    8000269c:	ffffe097          	auipc	ra,0xffffe
    800026a0:	66a080e7          	jalr	1642(ra) # 80000d06 <acquire>
    p->killed = 1;
    800026a4:	4785                	li	a5,1
    800026a6:	d49c                	sw	a5,40(s1)
    release(&p->lock);
    800026a8:	8526                	mv	a0,s1
    800026aa:	ffffe097          	auipc	ra,0xffffe
    800026ae:	70c080e7          	jalr	1804(ra) # 80000db6 <release>
}
    800026b2:	60e2                	ld	ra,24(sp)
    800026b4:	6442                	ld	s0,16(sp)
    800026b6:	64a2                	ld	s1,8(sp)
    800026b8:	6105                	addi	sp,sp,32
    800026ba:	8082                	ret

00000000800026bc <killed>:

int killed(struct proc *p)
{
    800026bc:	1101                	addi	sp,sp,-32
    800026be:	ec06                	sd	ra,24(sp)
    800026c0:	e822                	sd	s0,16(sp)
    800026c2:	e426                	sd	s1,8(sp)
    800026c4:	e04a                	sd	s2,0(sp)
    800026c6:	1000                	addi	s0,sp,32
    800026c8:	84aa                	mv	s1,a0
    int k;

    acquire(&p->lock);
    800026ca:	ffffe097          	auipc	ra,0xffffe
    800026ce:	63c080e7          	jalr	1596(ra) # 80000d06 <acquire>
    k = p->killed;
    800026d2:	0284a903          	lw	s2,40(s1)
    release(&p->lock);
    800026d6:	8526                	mv	a0,s1
    800026d8:	ffffe097          	auipc	ra,0xffffe
    800026dc:	6de080e7          	jalr	1758(ra) # 80000db6 <release>
    return k;
}
    800026e0:	854a                	mv	a0,s2
    800026e2:	60e2                	ld	ra,24(sp)
    800026e4:	6442                	ld	s0,16(sp)
    800026e6:	64a2                	ld	s1,8(sp)
    800026e8:	6902                	ld	s2,0(sp)
    800026ea:	6105                	addi	sp,sp,32
    800026ec:	8082                	ret

00000000800026ee <wait>:
{
    800026ee:	715d                	addi	sp,sp,-80
    800026f0:	e486                	sd	ra,72(sp)
    800026f2:	e0a2                	sd	s0,64(sp)
    800026f4:	fc26                	sd	s1,56(sp)
    800026f6:	f84a                	sd	s2,48(sp)
    800026f8:	f44e                	sd	s3,40(sp)
    800026fa:	f052                	sd	s4,32(sp)
    800026fc:	ec56                	sd	s5,24(sp)
    800026fe:	e85a                	sd	s6,16(sp)
    80002700:	e45e                	sd	s7,8(sp)
    80002702:	0880                	addi	s0,sp,80
    80002704:	8b2a                	mv	s6,a0
    struct proc *p = myproc();
    80002706:	fffff097          	auipc	ra,0xfffff
    8000270a:	55a080e7          	jalr	1370(ra) # 80001c60 <myproc>
    8000270e:	892a                	mv	s2,a0
    acquire(&wait_lock);
    80002710:	0000f517          	auipc	a0,0xf
    80002714:	9b850513          	addi	a0,a0,-1608 # 800110c8 <wait_lock>
    80002718:	ffffe097          	auipc	ra,0xffffe
    8000271c:	5ee080e7          	jalr	1518(ra) # 80000d06 <acquire>
                if (pp->state == ZOMBIE)
    80002720:	4a15                	li	s4,5
                havekids = 1;
    80002722:	4a85                	li	s5,1
        for (pp = proc; pp < &proc[NPROC]; pp++)
    80002724:	00014997          	auipc	s3,0x14
    80002728:	3bc98993          	addi	s3,s3,956 # 80016ae0 <tickslock>
        sleep(p, &wait_lock); // DOC: wait-sleep
    8000272c:	0000fb97          	auipc	s7,0xf
    80002730:	99cb8b93          	addi	s7,s7,-1636 # 800110c8 <wait_lock>
    80002734:	a0c9                	j	800027f6 <wait+0x108>
                    pid = pp->pid;
    80002736:	0304a983          	lw	s3,48(s1)
                    if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000273a:	000b0e63          	beqz	s6,80002756 <wait+0x68>
    8000273e:	4691                	li	a3,4
    80002740:	02c48613          	addi	a2,s1,44
    80002744:	85da                	mv	a1,s6
    80002746:	05093503          	ld	a0,80(s2)
    8000274a:	fffff097          	auipc	ra,0xfffff
    8000274e:	08e080e7          	jalr	142(ra) # 800017d8 <copyout>
    80002752:	04054063          	bltz	a0,80002792 <wait+0xa4>
                    freeproc(pp);
    80002756:	8526                	mv	a0,s1
    80002758:	fffff097          	auipc	ra,0xfffff
    8000275c:	6ba080e7          	jalr	1722(ra) # 80001e12 <freeproc>
                    release(&pp->lock);
    80002760:	8526                	mv	a0,s1
    80002762:	ffffe097          	auipc	ra,0xffffe
    80002766:	654080e7          	jalr	1620(ra) # 80000db6 <release>
                    release(&wait_lock);
    8000276a:	0000f517          	auipc	a0,0xf
    8000276e:	95e50513          	addi	a0,a0,-1698 # 800110c8 <wait_lock>
    80002772:	ffffe097          	auipc	ra,0xffffe
    80002776:	644080e7          	jalr	1604(ra) # 80000db6 <release>
}
    8000277a:	854e                	mv	a0,s3
    8000277c:	60a6                	ld	ra,72(sp)
    8000277e:	6406                	ld	s0,64(sp)
    80002780:	74e2                	ld	s1,56(sp)
    80002782:	7942                	ld	s2,48(sp)
    80002784:	79a2                	ld	s3,40(sp)
    80002786:	7a02                	ld	s4,32(sp)
    80002788:	6ae2                	ld	s5,24(sp)
    8000278a:	6b42                	ld	s6,16(sp)
    8000278c:	6ba2                	ld	s7,8(sp)
    8000278e:	6161                	addi	sp,sp,80
    80002790:	8082                	ret
                        release(&pp->lock);
    80002792:	8526                	mv	a0,s1
    80002794:	ffffe097          	auipc	ra,0xffffe
    80002798:	622080e7          	jalr	1570(ra) # 80000db6 <release>
                        release(&wait_lock);
    8000279c:	0000f517          	auipc	a0,0xf
    800027a0:	92c50513          	addi	a0,a0,-1748 # 800110c8 <wait_lock>
    800027a4:	ffffe097          	auipc	ra,0xffffe
    800027a8:	612080e7          	jalr	1554(ra) # 80000db6 <release>
                        return -1;
    800027ac:	59fd                	li	s3,-1
    800027ae:	b7f1                	j	8000277a <wait+0x8c>
        for (pp = proc; pp < &proc[NPROC]; pp++)
    800027b0:	16848493          	addi	s1,s1,360
    800027b4:	03348463          	beq	s1,s3,800027dc <wait+0xee>
            if (pp->parent == p)
    800027b8:	7c9c                	ld	a5,56(s1)
    800027ba:	ff279be3          	bne	a5,s2,800027b0 <wait+0xc2>
                acquire(&pp->lock);
    800027be:	8526                	mv	a0,s1
    800027c0:	ffffe097          	auipc	ra,0xffffe
    800027c4:	546080e7          	jalr	1350(ra) # 80000d06 <acquire>
                if (pp->state == ZOMBIE)
    800027c8:	4c9c                	lw	a5,24(s1)
    800027ca:	f74786e3          	beq	a5,s4,80002736 <wait+0x48>
                release(&pp->lock);
    800027ce:	8526                	mv	a0,s1
    800027d0:	ffffe097          	auipc	ra,0xffffe
    800027d4:	5e6080e7          	jalr	1510(ra) # 80000db6 <release>
                havekids = 1;
    800027d8:	8756                	mv	a4,s5
    800027da:	bfd9                	j	800027b0 <wait+0xc2>
        if (!havekids || killed(p))
    800027dc:	c31d                	beqz	a4,80002802 <wait+0x114>
    800027de:	854a                	mv	a0,s2
    800027e0:	00000097          	auipc	ra,0x0
    800027e4:	edc080e7          	jalr	-292(ra) # 800026bc <killed>
    800027e8:	ed09                	bnez	a0,80002802 <wait+0x114>
        sleep(p, &wait_lock); // DOC: wait-sleep
    800027ea:	85de                	mv	a1,s7
    800027ec:	854a                	mv	a0,s2
    800027ee:	00000097          	auipc	ra,0x0
    800027f2:	c26080e7          	jalr	-986(ra) # 80002414 <sleep>
        havekids = 0;
    800027f6:	4701                	li	a4,0
        for (pp = proc; pp < &proc[NPROC]; pp++)
    800027f8:	0000f497          	auipc	s1,0xf
    800027fc:	8e848493          	addi	s1,s1,-1816 # 800110e0 <proc>
    80002800:	bf65                	j	800027b8 <wait+0xca>
            release(&wait_lock);
    80002802:	0000f517          	auipc	a0,0xf
    80002806:	8c650513          	addi	a0,a0,-1850 # 800110c8 <wait_lock>
    8000280a:	ffffe097          	auipc	ra,0xffffe
    8000280e:	5ac080e7          	jalr	1452(ra) # 80000db6 <release>
            return -1;
    80002812:	59fd                	li	s3,-1
    80002814:	b79d                	j	8000277a <wait+0x8c>

0000000080002816 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002816:	7179                	addi	sp,sp,-48
    80002818:	f406                	sd	ra,40(sp)
    8000281a:	f022                	sd	s0,32(sp)
    8000281c:	ec26                	sd	s1,24(sp)
    8000281e:	e84a                	sd	s2,16(sp)
    80002820:	e44e                	sd	s3,8(sp)
    80002822:	e052                	sd	s4,0(sp)
    80002824:	1800                	addi	s0,sp,48
    80002826:	84aa                	mv	s1,a0
    80002828:	892e                	mv	s2,a1
    8000282a:	89b2                	mv	s3,a2
    8000282c:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    8000282e:	fffff097          	auipc	ra,0xfffff
    80002832:	432080e7          	jalr	1074(ra) # 80001c60 <myproc>
    if (user_dst)
    80002836:	c08d                	beqz	s1,80002858 <either_copyout+0x42>
    {
        return copyout(p->pagetable, dst, src, len);
    80002838:	86d2                	mv	a3,s4
    8000283a:	864e                	mv	a2,s3
    8000283c:	85ca                	mv	a1,s2
    8000283e:	6928                	ld	a0,80(a0)
    80002840:	fffff097          	auipc	ra,0xfffff
    80002844:	f98080e7          	jalr	-104(ra) # 800017d8 <copyout>
    else
    {
        memmove((char *)dst, src, len);
        return 0;
    }
}
    80002848:	70a2                	ld	ra,40(sp)
    8000284a:	7402                	ld	s0,32(sp)
    8000284c:	64e2                	ld	s1,24(sp)
    8000284e:	6942                	ld	s2,16(sp)
    80002850:	69a2                	ld	s3,8(sp)
    80002852:	6a02                	ld	s4,0(sp)
    80002854:	6145                	addi	sp,sp,48
    80002856:	8082                	ret
        memmove((char *)dst, src, len);
    80002858:	000a061b          	sext.w	a2,s4
    8000285c:	85ce                	mv	a1,s3
    8000285e:	854a                	mv	a0,s2
    80002860:	ffffe097          	auipc	ra,0xffffe
    80002864:	602080e7          	jalr	1538(ra) # 80000e62 <memmove>
        return 0;
    80002868:	8526                	mv	a0,s1
    8000286a:	bff9                	j	80002848 <either_copyout+0x32>

000000008000286c <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000286c:	7179                	addi	sp,sp,-48
    8000286e:	f406                	sd	ra,40(sp)
    80002870:	f022                	sd	s0,32(sp)
    80002872:	ec26                	sd	s1,24(sp)
    80002874:	e84a                	sd	s2,16(sp)
    80002876:	e44e                	sd	s3,8(sp)
    80002878:	e052                	sd	s4,0(sp)
    8000287a:	1800                	addi	s0,sp,48
    8000287c:	892a                	mv	s2,a0
    8000287e:	84ae                	mv	s1,a1
    80002880:	89b2                	mv	s3,a2
    80002882:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    80002884:	fffff097          	auipc	ra,0xfffff
    80002888:	3dc080e7          	jalr	988(ra) # 80001c60 <myproc>
    if (user_src)
    8000288c:	c08d                	beqz	s1,800028ae <either_copyin+0x42>
    {
        return copyin(p->pagetable, dst, src, len);
    8000288e:	86d2                	mv	a3,s4
    80002890:	864e                	mv	a2,s3
    80002892:	85ca                	mv	a1,s2
    80002894:	6928                	ld	a0,80(a0)
    80002896:	fffff097          	auipc	ra,0xfffff
    8000289a:	fce080e7          	jalr	-50(ra) # 80001864 <copyin>
    else
    {
        memmove(dst, (char *)src, len);
        return 0;
    }
}
    8000289e:	70a2                	ld	ra,40(sp)
    800028a0:	7402                	ld	s0,32(sp)
    800028a2:	64e2                	ld	s1,24(sp)
    800028a4:	6942                	ld	s2,16(sp)
    800028a6:	69a2                	ld	s3,8(sp)
    800028a8:	6a02                	ld	s4,0(sp)
    800028aa:	6145                	addi	sp,sp,48
    800028ac:	8082                	ret
        memmove(dst, (char *)src, len);
    800028ae:	000a061b          	sext.w	a2,s4
    800028b2:	85ce                	mv	a1,s3
    800028b4:	854a                	mv	a0,s2
    800028b6:	ffffe097          	auipc	ra,0xffffe
    800028ba:	5ac080e7          	jalr	1452(ra) # 80000e62 <memmove>
        return 0;
    800028be:	8526                	mv	a0,s1
    800028c0:	bff9                	j	8000289e <either_copyin+0x32>

00000000800028c2 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    800028c2:	715d                	addi	sp,sp,-80
    800028c4:	e486                	sd	ra,72(sp)
    800028c6:	e0a2                	sd	s0,64(sp)
    800028c8:	fc26                	sd	s1,56(sp)
    800028ca:	f84a                	sd	s2,48(sp)
    800028cc:	f44e                	sd	s3,40(sp)
    800028ce:	f052                	sd	s4,32(sp)
    800028d0:	ec56                	sd	s5,24(sp)
    800028d2:	e85a                	sd	s6,16(sp)
    800028d4:	e45e                	sd	s7,8(sp)
    800028d6:	0880                	addi	s0,sp,80
        [RUNNING] "run   ",
        [ZOMBIE] "zombie"};
    struct proc *p;
    char *state;

    printf("\n");
    800028d8:	00005517          	auipc	a0,0x5
    800028dc:	74850513          	addi	a0,a0,1864 # 80008020 <__func__.1+0x18>
    800028e0:	ffffe097          	auipc	ra,0xffffe
    800028e4:	cdc080e7          	jalr	-804(ra) # 800005bc <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    800028e8:	0000f497          	auipc	s1,0xf
    800028ec:	95048493          	addi	s1,s1,-1712 # 80011238 <proc+0x158>
    800028f0:	00014917          	auipc	s2,0x14
    800028f4:	34890913          	addi	s2,s2,840 # 80016c38 <bcache+0x140>
    {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800028f8:	4b15                	li	s6,5
            state = states[p->state];
        else
            state = "???";
    800028fa:	00006997          	auipc	s3,0x6
    800028fe:	9a698993          	addi	s3,s3,-1626 # 800082a0 <__func__.1+0x298>
        printf("%d <%s %s", p->pid, state, p->name);
    80002902:	00006a97          	auipc	s5,0x6
    80002906:	9a6a8a93          	addi	s5,s5,-1626 # 800082a8 <__func__.1+0x2a0>
        printf("\n");
    8000290a:	00005a17          	auipc	s4,0x5
    8000290e:	716a0a13          	addi	s4,s4,1814 # 80008020 <__func__.1+0x18>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002912:	00006b97          	auipc	s7,0x6
    80002916:	f46b8b93          	addi	s7,s7,-186 # 80008858 <states.0>
    8000291a:	a00d                	j	8000293c <procdump+0x7a>
        printf("%d <%s %s", p->pid, state, p->name);
    8000291c:	ed86a583          	lw	a1,-296(a3)
    80002920:	8556                	mv	a0,s5
    80002922:	ffffe097          	auipc	ra,0xffffe
    80002926:	c9a080e7          	jalr	-870(ra) # 800005bc <printf>
        printf("\n");
    8000292a:	8552                	mv	a0,s4
    8000292c:	ffffe097          	auipc	ra,0xffffe
    80002930:	c90080e7          	jalr	-880(ra) # 800005bc <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80002934:	16848493          	addi	s1,s1,360
    80002938:	03248263          	beq	s1,s2,8000295c <procdump+0x9a>
        if (p->state == UNUSED)
    8000293c:	86a6                	mv	a3,s1
    8000293e:	ec04a783          	lw	a5,-320(s1)
    80002942:	dbed                	beqz	a5,80002934 <procdump+0x72>
            state = "???";
    80002944:	864e                	mv	a2,s3
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002946:	fcfb6be3          	bltu	s6,a5,8000291c <procdump+0x5a>
    8000294a:	02079713          	slli	a4,a5,0x20
    8000294e:	01d75793          	srli	a5,a4,0x1d
    80002952:	97de                	add	a5,a5,s7
    80002954:	6390                	ld	a2,0(a5)
    80002956:	f279                	bnez	a2,8000291c <procdump+0x5a>
            state = "???";
    80002958:	864e                	mv	a2,s3
    8000295a:	b7c9                	j	8000291c <procdump+0x5a>
    }
}
    8000295c:	60a6                	ld	ra,72(sp)
    8000295e:	6406                	ld	s0,64(sp)
    80002960:	74e2                	ld	s1,56(sp)
    80002962:	7942                	ld	s2,48(sp)
    80002964:	79a2                	ld	s3,40(sp)
    80002966:	7a02                	ld	s4,32(sp)
    80002968:	6ae2                	ld	s5,24(sp)
    8000296a:	6b42                	ld	s6,16(sp)
    8000296c:	6ba2                	ld	s7,8(sp)
    8000296e:	6161                	addi	sp,sp,80
    80002970:	8082                	ret

0000000080002972 <schedls>:

void schedls()
{
    80002972:	1141                	addi	sp,sp,-16
    80002974:	e406                	sd	ra,8(sp)
    80002976:	e022                	sd	s0,0(sp)
    80002978:	0800                	addi	s0,sp,16
    printf("[ ]\tScheduler Name\tScheduler ID\n");
    8000297a:	00006517          	auipc	a0,0x6
    8000297e:	93e50513          	addi	a0,a0,-1730 # 800082b8 <__func__.1+0x2b0>
    80002982:	ffffe097          	auipc	ra,0xffffe
    80002986:	c3a080e7          	jalr	-966(ra) # 800005bc <printf>
    printf("====================================\n");
    8000298a:	00006517          	auipc	a0,0x6
    8000298e:	95650513          	addi	a0,a0,-1706 # 800082e0 <__func__.1+0x2d8>
    80002992:	ffffe097          	auipc	ra,0xffffe
    80002996:	c2a080e7          	jalr	-982(ra) # 800005bc <printf>
    for (int i = 0; i < SCHEDC; i++)
    {
        if (available_schedulers[i].impl == sched_pointer)
    8000299a:	00006717          	auipc	a4,0x6
    8000299e:	04e73703          	ld	a4,78(a4) # 800089e8 <available_schedulers+0x10>
    800029a2:	00006797          	auipc	a5,0x6
    800029a6:	fe67b783          	ld	a5,-26(a5) # 80008988 <sched_pointer>
    800029aa:	04f70663          	beq	a4,a5,800029f6 <schedls+0x84>
        {
            printf("[*]\t");
        }
        else
        {
            printf("   \t");
    800029ae:	00006517          	auipc	a0,0x6
    800029b2:	96250513          	addi	a0,a0,-1694 # 80008310 <__func__.1+0x308>
    800029b6:	ffffe097          	auipc	ra,0xffffe
    800029ba:	c06080e7          	jalr	-1018(ra) # 800005bc <printf>
        }
        printf("%s\t%d\n", available_schedulers[i].name, available_schedulers[i].id);
    800029be:	00006617          	auipc	a2,0x6
    800029c2:	03262603          	lw	a2,50(a2) # 800089f0 <available_schedulers+0x18>
    800029c6:	00006597          	auipc	a1,0x6
    800029ca:	01258593          	addi	a1,a1,18 # 800089d8 <available_schedulers>
    800029ce:	00006517          	auipc	a0,0x6
    800029d2:	94a50513          	addi	a0,a0,-1718 # 80008318 <__func__.1+0x310>
    800029d6:	ffffe097          	auipc	ra,0xffffe
    800029da:	be6080e7          	jalr	-1050(ra) # 800005bc <printf>
    }
    printf("\n*: current scheduler\n\n");
    800029de:	00006517          	auipc	a0,0x6
    800029e2:	94250513          	addi	a0,a0,-1726 # 80008320 <__func__.1+0x318>
    800029e6:	ffffe097          	auipc	ra,0xffffe
    800029ea:	bd6080e7          	jalr	-1066(ra) # 800005bc <printf>
}
    800029ee:	60a2                	ld	ra,8(sp)
    800029f0:	6402                	ld	s0,0(sp)
    800029f2:	0141                	addi	sp,sp,16
    800029f4:	8082                	ret
            printf("[*]\t");
    800029f6:	00006517          	auipc	a0,0x6
    800029fa:	91250513          	addi	a0,a0,-1774 # 80008308 <__func__.1+0x300>
    800029fe:	ffffe097          	auipc	ra,0xffffe
    80002a02:	bbe080e7          	jalr	-1090(ra) # 800005bc <printf>
    80002a06:	bf65                	j	800029be <schedls+0x4c>

0000000080002a08 <schedset>:

void schedset(int id)
{
    80002a08:	1141                	addi	sp,sp,-16
    80002a0a:	e406                	sd	ra,8(sp)
    80002a0c:	e022                	sd	s0,0(sp)
    80002a0e:	0800                	addi	s0,sp,16
    if (id < 0 || SCHEDC <= id)
    80002a10:	e90d                	bnez	a0,80002a42 <schedset+0x3a>
    {
        printf("Scheduler unchanged: ID out of range\n");
        return;
    }
    sched_pointer = available_schedulers[id].impl;
    80002a12:	00006797          	auipc	a5,0x6
    80002a16:	fd67b783          	ld	a5,-42(a5) # 800089e8 <available_schedulers+0x10>
    80002a1a:	00006717          	auipc	a4,0x6
    80002a1e:	f6f73723          	sd	a5,-146(a4) # 80008988 <sched_pointer>
    printf("Scheduler successfully changed to %s\n", available_schedulers[id].name);
    80002a22:	00006597          	auipc	a1,0x6
    80002a26:	fb658593          	addi	a1,a1,-74 # 800089d8 <available_schedulers>
    80002a2a:	00006517          	auipc	a0,0x6
    80002a2e:	93650513          	addi	a0,a0,-1738 # 80008360 <__func__.1+0x358>
    80002a32:	ffffe097          	auipc	ra,0xffffe
    80002a36:	b8a080e7          	jalr	-1142(ra) # 800005bc <printf>
    80002a3a:	60a2                	ld	ra,8(sp)
    80002a3c:	6402                	ld	s0,0(sp)
    80002a3e:	0141                	addi	sp,sp,16
    80002a40:	8082                	ret
        printf("Scheduler unchanged: ID out of range\n");
    80002a42:	00006517          	auipc	a0,0x6
    80002a46:	8f650513          	addi	a0,a0,-1802 # 80008338 <__func__.1+0x330>
    80002a4a:	ffffe097          	auipc	ra,0xffffe
    80002a4e:	b72080e7          	jalr	-1166(ra) # 800005bc <printf>
        return;
    80002a52:	b7e5                	j	80002a3a <schedset+0x32>

0000000080002a54 <swtch>:
    80002a54:	00153023          	sd	ra,0(a0)
    80002a58:	00253423          	sd	sp,8(a0)
    80002a5c:	e900                	sd	s0,16(a0)
    80002a5e:	ed04                	sd	s1,24(a0)
    80002a60:	03253023          	sd	s2,32(a0)
    80002a64:	03353423          	sd	s3,40(a0)
    80002a68:	03453823          	sd	s4,48(a0)
    80002a6c:	03553c23          	sd	s5,56(a0)
    80002a70:	05653023          	sd	s6,64(a0)
    80002a74:	05753423          	sd	s7,72(a0)
    80002a78:	05853823          	sd	s8,80(a0)
    80002a7c:	05953c23          	sd	s9,88(a0)
    80002a80:	07a53023          	sd	s10,96(a0)
    80002a84:	07b53423          	sd	s11,104(a0)
    80002a88:	0005b083          	ld	ra,0(a1)
    80002a8c:	0085b103          	ld	sp,8(a1)
    80002a90:	6980                	ld	s0,16(a1)
    80002a92:	6d84                	ld	s1,24(a1)
    80002a94:	0205b903          	ld	s2,32(a1)
    80002a98:	0285b983          	ld	s3,40(a1)
    80002a9c:	0305ba03          	ld	s4,48(a1)
    80002aa0:	0385ba83          	ld	s5,56(a1)
    80002aa4:	0405bb03          	ld	s6,64(a1)
    80002aa8:	0485bb83          	ld	s7,72(a1)
    80002aac:	0505bc03          	ld	s8,80(a1)
    80002ab0:	0585bc83          	ld	s9,88(a1)
    80002ab4:	0605bd03          	ld	s10,96(a1)
    80002ab8:	0685bd83          	ld	s11,104(a1)
    80002abc:	8082                	ret

0000000080002abe <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002abe:	1141                	addi	sp,sp,-16
    80002ac0:	e406                	sd	ra,8(sp)
    80002ac2:	e022                	sd	s0,0(sp)
    80002ac4:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002ac6:	00006597          	auipc	a1,0x6
    80002aca:	8f258593          	addi	a1,a1,-1806 # 800083b8 <__func__.1+0x3b0>
    80002ace:	00014517          	auipc	a0,0x14
    80002ad2:	01250513          	addi	a0,a0,18 # 80016ae0 <tickslock>
    80002ad6:	ffffe097          	auipc	ra,0xffffe
    80002ada:	19c080e7          	jalr	412(ra) # 80000c72 <initlock>
}
    80002ade:	60a2                	ld	ra,8(sp)
    80002ae0:	6402                	ld	s0,0(sp)
    80002ae2:	0141                	addi	sp,sp,16
    80002ae4:	8082                	ret

0000000080002ae6 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002ae6:	1141                	addi	sp,sp,-16
    80002ae8:	e406                	sd	ra,8(sp)
    80002aea:	e022                	sd	s0,0(sp)
    80002aec:	0800                	addi	s0,sp,16
    asm volatile("csrw stvec, %0" : : "r"(x));
    80002aee:	00003797          	auipc	a5,0x3
    80002af2:	74278793          	addi	a5,a5,1858 # 80006230 <kernelvec>
    80002af6:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002afa:	60a2                	ld	ra,8(sp)
    80002afc:	6402                	ld	s0,0(sp)
    80002afe:	0141                	addi	sp,sp,16
    80002b00:	8082                	ret

0000000080002b02 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002b02:	1141                	addi	sp,sp,-16
    80002b04:	e406                	sd	ra,8(sp)
    80002b06:	e022                	sd	s0,0(sp)
    80002b08:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002b0a:	fffff097          	auipc	ra,0xfffff
    80002b0e:	156080e7          	jalr	342(ra) # 80001c60 <myproc>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002b12:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002b16:	9bf5                	andi	a5,a5,-3
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80002b18:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002b1c:	00004697          	auipc	a3,0x4
    80002b20:	4e468693          	addi	a3,a3,1252 # 80007000 <_trampoline>
    80002b24:	00004717          	auipc	a4,0x4
    80002b28:	4dc70713          	addi	a4,a4,1244 # 80007000 <_trampoline>
    80002b2c:	8f15                	sub	a4,a4,a3
    80002b2e:	040007b7          	lui	a5,0x4000
    80002b32:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002b34:	07b2                	slli	a5,a5,0xc
    80002b36:	973e                	add	a4,a4,a5
    asm volatile("csrw stvec, %0" : : "r"(x));
    80002b38:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002b3c:	6d38                	ld	a4,88(a0)
    asm volatile("csrr %0, satp" : "=r"(x));
    80002b3e:	18002673          	csrr	a2,satp
    80002b42:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002b44:	6d30                	ld	a2,88(a0)
    80002b46:	6138                	ld	a4,64(a0)
    80002b48:	6585                	lui	a1,0x1
    80002b4a:	972e                	add	a4,a4,a1
    80002b4c:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002b4e:	6d38                	ld	a4,88(a0)
    80002b50:	00000617          	auipc	a2,0x0
    80002b54:	13860613          	addi	a2,a2,312 # 80002c88 <usertrap>
    80002b58:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002b5a:	6d38                	ld	a4,88(a0)
    asm volatile("mv %0, tp" : "=r"(x));
    80002b5c:	8612                	mv	a2,tp
    80002b5e:	f310                	sd	a2,32(a4)
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002b60:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002b64:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002b68:	02076713          	ori	a4,a4,32
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80002b6c:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002b70:	6d38                	ld	a4,88(a0)
    asm volatile("csrw sepc, %0" : : "r"(x));
    80002b72:	6f18                	ld	a4,24(a4)
    80002b74:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002b78:	6928                	ld	a0,80(a0)
    80002b7a:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002b7c:	00004717          	auipc	a4,0x4
    80002b80:	52070713          	addi	a4,a4,1312 # 8000709c <userret>
    80002b84:	8f15                	sub	a4,a4,a3
    80002b86:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002b88:	577d                	li	a4,-1
    80002b8a:	177e                	slli	a4,a4,0x3f
    80002b8c:	8d59                	or	a0,a0,a4
    80002b8e:	9782                	jalr	a5
}
    80002b90:	60a2                	ld	ra,8(sp)
    80002b92:	6402                	ld	s0,0(sp)
    80002b94:	0141                	addi	sp,sp,16
    80002b96:	8082                	ret

0000000080002b98 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002b98:	1101                	addi	sp,sp,-32
    80002b9a:	ec06                	sd	ra,24(sp)
    80002b9c:	e822                	sd	s0,16(sp)
    80002b9e:	e426                	sd	s1,8(sp)
    80002ba0:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002ba2:	00014497          	auipc	s1,0x14
    80002ba6:	f3e48493          	addi	s1,s1,-194 # 80016ae0 <tickslock>
    80002baa:	8526                	mv	a0,s1
    80002bac:	ffffe097          	auipc	ra,0xffffe
    80002bb0:	15a080e7          	jalr	346(ra) # 80000d06 <acquire>
  ticks++;
    80002bb4:	00006517          	auipc	a0,0x6
    80002bb8:	e8c50513          	addi	a0,a0,-372 # 80008a40 <ticks>
    80002bbc:	411c                	lw	a5,0(a0)
    80002bbe:	2785                	addiw	a5,a5,1
    80002bc0:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002bc2:	00000097          	auipc	ra,0x0
    80002bc6:	8b6080e7          	jalr	-1866(ra) # 80002478 <wakeup>
  release(&tickslock);
    80002bca:	8526                	mv	a0,s1
    80002bcc:	ffffe097          	auipc	ra,0xffffe
    80002bd0:	1ea080e7          	jalr	490(ra) # 80000db6 <release>
}
    80002bd4:	60e2                	ld	ra,24(sp)
    80002bd6:	6442                	ld	s0,16(sp)
    80002bd8:	64a2                	ld	s1,8(sp)
    80002bda:	6105                	addi	sp,sp,32
    80002bdc:	8082                	ret

0000000080002bde <devintr>:
    asm volatile("csrr %0, scause" : "=r"(x));
    80002bde:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002be2:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80002be4:	0a07d163          	bgez	a5,80002c86 <devintr+0xa8>
{
    80002be8:	1101                	addi	sp,sp,-32
    80002bea:	ec06                	sd	ra,24(sp)
    80002bec:	e822                	sd	s0,16(sp)
    80002bee:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80002bf0:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80002bf4:	46a5                	li	a3,9
    80002bf6:	00d70c63          	beq	a4,a3,80002c0e <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80002bfa:	577d                	li	a4,-1
    80002bfc:	177e                	slli	a4,a4,0x3f
    80002bfe:	0705                	addi	a4,a4,1
    return 0;
    80002c00:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002c02:	06e78163          	beq	a5,a4,80002c64 <devintr+0x86>
  }
}
    80002c06:	60e2                	ld	ra,24(sp)
    80002c08:	6442                	ld	s0,16(sp)
    80002c0a:	6105                	addi	sp,sp,32
    80002c0c:	8082                	ret
    80002c0e:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002c10:	00003097          	auipc	ra,0x3
    80002c14:	72c080e7          	jalr	1836(ra) # 8000633c <plic_claim>
    80002c18:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002c1a:	47a9                	li	a5,10
    80002c1c:	00f50963          	beq	a0,a5,80002c2e <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80002c20:	4785                	li	a5,1
    80002c22:	00f50b63          	beq	a0,a5,80002c38 <devintr+0x5a>
    return 1;
    80002c26:	4505                	li	a0,1
    } else if(irq){
    80002c28:	ec89                	bnez	s1,80002c42 <devintr+0x64>
    80002c2a:	64a2                	ld	s1,8(sp)
    80002c2c:	bfe9                	j	80002c06 <devintr+0x28>
      uartintr();
    80002c2e:	ffffe097          	auipc	ra,0xffffe
    80002c32:	de0080e7          	jalr	-544(ra) # 80000a0e <uartintr>
    if(irq)
    80002c36:	a839                	j	80002c54 <devintr+0x76>
      virtio_disk_intr();
    80002c38:	00004097          	auipc	ra,0x4
    80002c3c:	bf8080e7          	jalr	-1032(ra) # 80006830 <virtio_disk_intr>
    if(irq)
    80002c40:	a811                	j	80002c54 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80002c42:	85a6                	mv	a1,s1
    80002c44:	00005517          	auipc	a0,0x5
    80002c48:	77c50513          	addi	a0,a0,1916 # 800083c0 <__func__.1+0x3b8>
    80002c4c:	ffffe097          	auipc	ra,0xffffe
    80002c50:	970080e7          	jalr	-1680(ra) # 800005bc <printf>
      plic_complete(irq);
    80002c54:	8526                	mv	a0,s1
    80002c56:	00003097          	auipc	ra,0x3
    80002c5a:	70a080e7          	jalr	1802(ra) # 80006360 <plic_complete>
    return 1;
    80002c5e:	4505                	li	a0,1
    80002c60:	64a2                	ld	s1,8(sp)
    80002c62:	b755                	j	80002c06 <devintr+0x28>
    if(cpuid() == 0){
    80002c64:	fffff097          	auipc	ra,0xfffff
    80002c68:	fc8080e7          	jalr	-56(ra) # 80001c2c <cpuid>
    80002c6c:	c901                	beqz	a0,80002c7c <devintr+0x9e>
    asm volatile("csrr %0, sip" : "=r"(x));
    80002c6e:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002c72:	9bf5                	andi	a5,a5,-3
    asm volatile("csrw sip, %0" : : "r"(x));
    80002c74:	14479073          	csrw	sip,a5
    return 2;
    80002c78:	4509                	li	a0,2
    80002c7a:	b771                	j	80002c06 <devintr+0x28>
      clockintr();
    80002c7c:	00000097          	auipc	ra,0x0
    80002c80:	f1c080e7          	jalr	-228(ra) # 80002b98 <clockintr>
    80002c84:	b7ed                	j	80002c6e <devintr+0x90>
}
    80002c86:	8082                	ret

0000000080002c88 <usertrap>:
{
    80002c88:	1101                	addi	sp,sp,-32
    80002c8a:	ec06                	sd	ra,24(sp)
    80002c8c:	e822                	sd	s0,16(sp)
    80002c8e:	e426                	sd	s1,8(sp)
    80002c90:	e04a                	sd	s2,0(sp)
    80002c92:	1000                	addi	s0,sp,32
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002c94:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002c98:	1007f793          	andi	a5,a5,256
    80002c9c:	e3b1                	bnez	a5,80002ce0 <usertrap+0x58>
    asm volatile("csrw stvec, %0" : : "r"(x));
    80002c9e:	00003797          	auipc	a5,0x3
    80002ca2:	59278793          	addi	a5,a5,1426 # 80006230 <kernelvec>
    80002ca6:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002caa:	fffff097          	auipc	ra,0xfffff
    80002cae:	fb6080e7          	jalr	-74(ra) # 80001c60 <myproc>
    80002cb2:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002cb4:	6d3c                	ld	a5,88(a0)
    asm volatile("csrr %0, sepc" : "=r"(x));
    80002cb6:	14102773          	csrr	a4,sepc
    80002cba:	ef98                	sd	a4,24(a5)
    asm volatile("csrr %0, scause" : "=r"(x));
    80002cbc:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002cc0:	47a1                	li	a5,8
    80002cc2:	02f70763          	beq	a4,a5,80002cf0 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80002cc6:	00000097          	auipc	ra,0x0
    80002cca:	f18080e7          	jalr	-232(ra) # 80002bde <devintr>
    80002cce:	892a                	mv	s2,a0
    80002cd0:	c151                	beqz	a0,80002d54 <usertrap+0xcc>
  if(killed(p))
    80002cd2:	8526                	mv	a0,s1
    80002cd4:	00000097          	auipc	ra,0x0
    80002cd8:	9e8080e7          	jalr	-1560(ra) # 800026bc <killed>
    80002cdc:	c929                	beqz	a0,80002d2e <usertrap+0xa6>
    80002cde:	a099                	j	80002d24 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80002ce0:	00005517          	auipc	a0,0x5
    80002ce4:	70050513          	addi	a0,a0,1792 # 800083e0 <__func__.1+0x3d8>
    80002ce8:	ffffe097          	auipc	ra,0xffffe
    80002cec:	878080e7          	jalr	-1928(ra) # 80000560 <panic>
    if(killed(p))
    80002cf0:	00000097          	auipc	ra,0x0
    80002cf4:	9cc080e7          	jalr	-1588(ra) # 800026bc <killed>
    80002cf8:	e921                	bnez	a0,80002d48 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80002cfa:	6cb8                	ld	a4,88(s1)
    80002cfc:	6f1c                	ld	a5,24(a4)
    80002cfe:	0791                	addi	a5,a5,4
    80002d00:	ef1c                	sd	a5,24(a4)
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002d02:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002d06:	0027e793          	ori	a5,a5,2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80002d0a:	10079073          	csrw	sstatus,a5
    syscall();
    80002d0e:	00000097          	auipc	ra,0x0
    80002d12:	2cc080e7          	jalr	716(ra) # 80002fda <syscall>
  if(killed(p))
    80002d16:	8526                	mv	a0,s1
    80002d18:	00000097          	auipc	ra,0x0
    80002d1c:	9a4080e7          	jalr	-1628(ra) # 800026bc <killed>
    80002d20:	c911                	beqz	a0,80002d34 <usertrap+0xac>
    80002d22:	4901                	li	s2,0
    exit(-1);
    80002d24:	557d                	li	a0,-1
    80002d26:	00000097          	auipc	ra,0x0
    80002d2a:	822080e7          	jalr	-2014(ra) # 80002548 <exit>
  if(which_dev == 2)
    80002d2e:	4789                	li	a5,2
    80002d30:	04f90f63          	beq	s2,a5,80002d8e <usertrap+0x106>
  usertrapret();
    80002d34:	00000097          	auipc	ra,0x0
    80002d38:	dce080e7          	jalr	-562(ra) # 80002b02 <usertrapret>
}
    80002d3c:	60e2                	ld	ra,24(sp)
    80002d3e:	6442                	ld	s0,16(sp)
    80002d40:	64a2                	ld	s1,8(sp)
    80002d42:	6902                	ld	s2,0(sp)
    80002d44:	6105                	addi	sp,sp,32
    80002d46:	8082                	ret
      exit(-1);
    80002d48:	557d                	li	a0,-1
    80002d4a:	fffff097          	auipc	ra,0xfffff
    80002d4e:	7fe080e7          	jalr	2046(ra) # 80002548 <exit>
    80002d52:	b765                	j	80002cfa <usertrap+0x72>
    asm volatile("csrr %0, scause" : "=r"(x));
    80002d54:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002d58:	5890                	lw	a2,48(s1)
    80002d5a:	00005517          	auipc	a0,0x5
    80002d5e:	6a650513          	addi	a0,a0,1702 # 80008400 <__func__.1+0x3f8>
    80002d62:	ffffe097          	auipc	ra,0xffffe
    80002d66:	85a080e7          	jalr	-1958(ra) # 800005bc <printf>
    asm volatile("csrr %0, sepc" : "=r"(x));
    80002d6a:	141025f3          	csrr	a1,sepc
    asm volatile("csrr %0, stval" : "=r"(x));
    80002d6e:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002d72:	00005517          	auipc	a0,0x5
    80002d76:	6be50513          	addi	a0,a0,1726 # 80008430 <__func__.1+0x428>
    80002d7a:	ffffe097          	auipc	ra,0xffffe
    80002d7e:	842080e7          	jalr	-1982(ra) # 800005bc <printf>
    setkilled(p);
    80002d82:	8526                	mv	a0,s1
    80002d84:	00000097          	auipc	ra,0x0
    80002d88:	90c080e7          	jalr	-1780(ra) # 80002690 <setkilled>
    80002d8c:	b769                	j	80002d16 <usertrap+0x8e>
    yield();
    80002d8e:	fffff097          	auipc	ra,0xfffff
    80002d92:	64a080e7          	jalr	1610(ra) # 800023d8 <yield>
    80002d96:	bf79                	j	80002d34 <usertrap+0xac>

0000000080002d98 <kerneltrap>:
{
    80002d98:	7179                	addi	sp,sp,-48
    80002d9a:	f406                	sd	ra,40(sp)
    80002d9c:	f022                	sd	s0,32(sp)
    80002d9e:	ec26                	sd	s1,24(sp)
    80002da0:	e84a                	sd	s2,16(sp)
    80002da2:	e44e                	sd	s3,8(sp)
    80002da4:	1800                	addi	s0,sp,48
    asm volatile("csrr %0, sepc" : "=r"(x));
    80002da6:	14102973          	csrr	s2,sepc
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002daa:	100024f3          	csrr	s1,sstatus
    asm volatile("csrr %0, scause" : "=r"(x));
    80002dae:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002db2:	1004f793          	andi	a5,s1,256
    80002db6:	cb85                	beqz	a5,80002de6 <kerneltrap+0x4e>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002db8:	100027f3          	csrr	a5,sstatus
    return (x & SSTATUS_SIE) != 0;
    80002dbc:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002dbe:	ef85                	bnez	a5,80002df6 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002dc0:	00000097          	auipc	ra,0x0
    80002dc4:	e1e080e7          	jalr	-482(ra) # 80002bde <devintr>
    80002dc8:	cd1d                	beqz	a0,80002e06 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002dca:	4789                	li	a5,2
    80002dcc:	06f50a63          	beq	a0,a5,80002e40 <kerneltrap+0xa8>
    asm volatile("csrw sepc, %0" : : "r"(x));
    80002dd0:	14191073          	csrw	sepc,s2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80002dd4:	10049073          	csrw	sstatus,s1
}
    80002dd8:	70a2                	ld	ra,40(sp)
    80002dda:	7402                	ld	s0,32(sp)
    80002ddc:	64e2                	ld	s1,24(sp)
    80002dde:	6942                	ld	s2,16(sp)
    80002de0:	69a2                	ld	s3,8(sp)
    80002de2:	6145                	addi	sp,sp,48
    80002de4:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002de6:	00005517          	auipc	a0,0x5
    80002dea:	66a50513          	addi	a0,a0,1642 # 80008450 <__func__.1+0x448>
    80002dee:	ffffd097          	auipc	ra,0xffffd
    80002df2:	772080e7          	jalr	1906(ra) # 80000560 <panic>
    panic("kerneltrap: interrupts enabled");
    80002df6:	00005517          	auipc	a0,0x5
    80002dfa:	68250513          	addi	a0,a0,1666 # 80008478 <__func__.1+0x470>
    80002dfe:	ffffd097          	auipc	ra,0xffffd
    80002e02:	762080e7          	jalr	1890(ra) # 80000560 <panic>
    printf("scause %p\n", scause);
    80002e06:	85ce                	mv	a1,s3
    80002e08:	00005517          	auipc	a0,0x5
    80002e0c:	69050513          	addi	a0,a0,1680 # 80008498 <__func__.1+0x490>
    80002e10:	ffffd097          	auipc	ra,0xffffd
    80002e14:	7ac080e7          	jalr	1964(ra) # 800005bc <printf>
    asm volatile("csrr %0, sepc" : "=r"(x));
    80002e18:	141025f3          	csrr	a1,sepc
    asm volatile("csrr %0, stval" : "=r"(x));
    80002e1c:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002e20:	00005517          	auipc	a0,0x5
    80002e24:	68850513          	addi	a0,a0,1672 # 800084a8 <__func__.1+0x4a0>
    80002e28:	ffffd097          	auipc	ra,0xffffd
    80002e2c:	794080e7          	jalr	1940(ra) # 800005bc <printf>
    panic("kerneltrap");
    80002e30:	00005517          	auipc	a0,0x5
    80002e34:	69050513          	addi	a0,a0,1680 # 800084c0 <__func__.1+0x4b8>
    80002e38:	ffffd097          	auipc	ra,0xffffd
    80002e3c:	728080e7          	jalr	1832(ra) # 80000560 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002e40:	fffff097          	auipc	ra,0xfffff
    80002e44:	e20080e7          	jalr	-480(ra) # 80001c60 <myproc>
    80002e48:	d541                	beqz	a0,80002dd0 <kerneltrap+0x38>
    80002e4a:	fffff097          	auipc	ra,0xfffff
    80002e4e:	e16080e7          	jalr	-490(ra) # 80001c60 <myproc>
    80002e52:	4d18                	lw	a4,24(a0)
    80002e54:	4791                	li	a5,4
    80002e56:	f6f71de3          	bne	a4,a5,80002dd0 <kerneltrap+0x38>
    yield();
    80002e5a:	fffff097          	auipc	ra,0xfffff
    80002e5e:	57e080e7          	jalr	1406(ra) # 800023d8 <yield>
    80002e62:	b7bd                	j	80002dd0 <kerneltrap+0x38>

0000000080002e64 <argraw>:
    return strlen(buf);
}

static uint64
argraw(int n)
{
    80002e64:	1101                	addi	sp,sp,-32
    80002e66:	ec06                	sd	ra,24(sp)
    80002e68:	e822                	sd	s0,16(sp)
    80002e6a:	e426                	sd	s1,8(sp)
    80002e6c:	1000                	addi	s0,sp,32
    80002e6e:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    80002e70:	fffff097          	auipc	ra,0xfffff
    80002e74:	df0080e7          	jalr	-528(ra) # 80001c60 <myproc>
    switch (n)
    80002e78:	4795                	li	a5,5
    80002e7a:	0497e163          	bltu	a5,s1,80002ebc <argraw+0x58>
    80002e7e:	048a                	slli	s1,s1,0x2
    80002e80:	00006717          	auipc	a4,0x6
    80002e84:	a0870713          	addi	a4,a4,-1528 # 80008888 <states.0+0x30>
    80002e88:	94ba                	add	s1,s1,a4
    80002e8a:	409c                	lw	a5,0(s1)
    80002e8c:	97ba                	add	a5,a5,a4
    80002e8e:	8782                	jr	a5
    {
    case 0:
        return p->trapframe->a0;
    80002e90:	6d3c                	ld	a5,88(a0)
    80002e92:	7ba8                	ld	a0,112(a5)
    case 5:
        return p->trapframe->a5;
    }
    panic("argraw");
    return -1;
}
    80002e94:	60e2                	ld	ra,24(sp)
    80002e96:	6442                	ld	s0,16(sp)
    80002e98:	64a2                	ld	s1,8(sp)
    80002e9a:	6105                	addi	sp,sp,32
    80002e9c:	8082                	ret
        return p->trapframe->a1;
    80002e9e:	6d3c                	ld	a5,88(a0)
    80002ea0:	7fa8                	ld	a0,120(a5)
    80002ea2:	bfcd                	j	80002e94 <argraw+0x30>
        return p->trapframe->a2;
    80002ea4:	6d3c                	ld	a5,88(a0)
    80002ea6:	63c8                	ld	a0,128(a5)
    80002ea8:	b7f5                	j	80002e94 <argraw+0x30>
        return p->trapframe->a3;
    80002eaa:	6d3c                	ld	a5,88(a0)
    80002eac:	67c8                	ld	a0,136(a5)
    80002eae:	b7dd                	j	80002e94 <argraw+0x30>
        return p->trapframe->a4;
    80002eb0:	6d3c                	ld	a5,88(a0)
    80002eb2:	6bc8                	ld	a0,144(a5)
    80002eb4:	b7c5                	j	80002e94 <argraw+0x30>
        return p->trapframe->a5;
    80002eb6:	6d3c                	ld	a5,88(a0)
    80002eb8:	6fc8                	ld	a0,152(a5)
    80002eba:	bfe9                	j	80002e94 <argraw+0x30>
    panic("argraw");
    80002ebc:	00005517          	auipc	a0,0x5
    80002ec0:	61450513          	addi	a0,a0,1556 # 800084d0 <__func__.1+0x4c8>
    80002ec4:	ffffd097          	auipc	ra,0xffffd
    80002ec8:	69c080e7          	jalr	1692(ra) # 80000560 <panic>

0000000080002ecc <fetchaddr>:
{
    80002ecc:	1101                	addi	sp,sp,-32
    80002ece:	ec06                	sd	ra,24(sp)
    80002ed0:	e822                	sd	s0,16(sp)
    80002ed2:	e426                	sd	s1,8(sp)
    80002ed4:	e04a                	sd	s2,0(sp)
    80002ed6:	1000                	addi	s0,sp,32
    80002ed8:	84aa                	mv	s1,a0
    80002eda:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80002edc:	fffff097          	auipc	ra,0xfffff
    80002ee0:	d84080e7          	jalr	-636(ra) # 80001c60 <myproc>
    if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002ee4:	653c                	ld	a5,72(a0)
    80002ee6:	02f4f863          	bgeu	s1,a5,80002f16 <fetchaddr+0x4a>
    80002eea:	00848713          	addi	a4,s1,8
    80002eee:	02e7e663          	bltu	a5,a4,80002f1a <fetchaddr+0x4e>
    if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002ef2:	46a1                	li	a3,8
    80002ef4:	8626                	mv	a2,s1
    80002ef6:	85ca                	mv	a1,s2
    80002ef8:	6928                	ld	a0,80(a0)
    80002efa:	fffff097          	auipc	ra,0xfffff
    80002efe:	96a080e7          	jalr	-1686(ra) # 80001864 <copyin>
    80002f02:	00a03533          	snez	a0,a0
    80002f06:	40a0053b          	negw	a0,a0
}
    80002f0a:	60e2                	ld	ra,24(sp)
    80002f0c:	6442                	ld	s0,16(sp)
    80002f0e:	64a2                	ld	s1,8(sp)
    80002f10:	6902                	ld	s2,0(sp)
    80002f12:	6105                	addi	sp,sp,32
    80002f14:	8082                	ret
        return -1;
    80002f16:	557d                	li	a0,-1
    80002f18:	bfcd                	j	80002f0a <fetchaddr+0x3e>
    80002f1a:	557d                	li	a0,-1
    80002f1c:	b7fd                	j	80002f0a <fetchaddr+0x3e>

0000000080002f1e <fetchstr>:
{
    80002f1e:	7179                	addi	sp,sp,-48
    80002f20:	f406                	sd	ra,40(sp)
    80002f22:	f022                	sd	s0,32(sp)
    80002f24:	ec26                	sd	s1,24(sp)
    80002f26:	e84a                	sd	s2,16(sp)
    80002f28:	e44e                	sd	s3,8(sp)
    80002f2a:	1800                	addi	s0,sp,48
    80002f2c:	892a                	mv	s2,a0
    80002f2e:	84ae                	mv	s1,a1
    80002f30:	89b2                	mv	s3,a2
    struct proc *p = myproc();
    80002f32:	fffff097          	auipc	ra,0xfffff
    80002f36:	d2e080e7          	jalr	-722(ra) # 80001c60 <myproc>
    if (copyinstr(p->pagetable, buf, addr, max) < 0)
    80002f3a:	86ce                	mv	a3,s3
    80002f3c:	864a                	mv	a2,s2
    80002f3e:	85a6                	mv	a1,s1
    80002f40:	6928                	ld	a0,80(a0)
    80002f42:	fffff097          	auipc	ra,0xfffff
    80002f46:	9b0080e7          	jalr	-1616(ra) # 800018f2 <copyinstr>
    80002f4a:	00054e63          	bltz	a0,80002f66 <fetchstr+0x48>
    return strlen(buf);
    80002f4e:	8526                	mv	a0,s1
    80002f50:	ffffe097          	auipc	ra,0xffffe
    80002f54:	03a080e7          	jalr	58(ra) # 80000f8a <strlen>
}
    80002f58:	70a2                	ld	ra,40(sp)
    80002f5a:	7402                	ld	s0,32(sp)
    80002f5c:	64e2                	ld	s1,24(sp)
    80002f5e:	6942                	ld	s2,16(sp)
    80002f60:	69a2                	ld	s3,8(sp)
    80002f62:	6145                	addi	sp,sp,48
    80002f64:	8082                	ret
        return -1;
    80002f66:	557d                	li	a0,-1
    80002f68:	bfc5                	j	80002f58 <fetchstr+0x3a>

0000000080002f6a <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip)
{
    80002f6a:	1101                	addi	sp,sp,-32
    80002f6c:	ec06                	sd	ra,24(sp)
    80002f6e:	e822                	sd	s0,16(sp)
    80002f70:	e426                	sd	s1,8(sp)
    80002f72:	1000                	addi	s0,sp,32
    80002f74:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80002f76:	00000097          	auipc	ra,0x0
    80002f7a:	eee080e7          	jalr	-274(ra) # 80002e64 <argraw>
    80002f7e:	c088                	sw	a0,0(s1)
}
    80002f80:	60e2                	ld	ra,24(sp)
    80002f82:	6442                	ld	s0,16(sp)
    80002f84:	64a2                	ld	s1,8(sp)
    80002f86:	6105                	addi	sp,sp,32
    80002f88:	8082                	ret

0000000080002f8a <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip)
{
    80002f8a:	1101                	addi	sp,sp,-32
    80002f8c:	ec06                	sd	ra,24(sp)
    80002f8e:	e822                	sd	s0,16(sp)
    80002f90:	e426                	sd	s1,8(sp)
    80002f92:	1000                	addi	s0,sp,32
    80002f94:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80002f96:	00000097          	auipc	ra,0x0
    80002f9a:	ece080e7          	jalr	-306(ra) # 80002e64 <argraw>
    80002f9e:	e088                	sd	a0,0(s1)
}
    80002fa0:	60e2                	ld	ra,24(sp)
    80002fa2:	6442                	ld	s0,16(sp)
    80002fa4:	64a2                	ld	s1,8(sp)
    80002fa6:	6105                	addi	sp,sp,32
    80002fa8:	8082                	ret

0000000080002faa <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    80002faa:	1101                	addi	sp,sp,-32
    80002fac:	ec06                	sd	ra,24(sp)
    80002fae:	e822                	sd	s0,16(sp)
    80002fb0:	e426                	sd	s1,8(sp)
    80002fb2:	e04a                	sd	s2,0(sp)
    80002fb4:	1000                	addi	s0,sp,32
    80002fb6:	84ae                	mv	s1,a1
    80002fb8:	8932                	mv	s2,a2
    *ip = argraw(n);
    80002fba:	00000097          	auipc	ra,0x0
    80002fbe:	eaa080e7          	jalr	-342(ra) # 80002e64 <argraw>
    uint64 addr;
    argaddr(n, &addr);
    return fetchstr(addr, buf, max);
    80002fc2:	864a                	mv	a2,s2
    80002fc4:	85a6                	mv	a1,s1
    80002fc6:	00000097          	auipc	ra,0x0
    80002fca:	f58080e7          	jalr	-168(ra) # 80002f1e <fetchstr>
}
    80002fce:	60e2                	ld	ra,24(sp)
    80002fd0:	6442                	ld	s0,16(sp)
    80002fd2:	64a2                	ld	s1,8(sp)
    80002fd4:	6902                	ld	s2,0(sp)
    80002fd6:	6105                	addi	sp,sp,32
    80002fd8:	8082                	ret

0000000080002fda <syscall>:
    [SYS_pfreepages] sys_pfreepages,
    [SYS_va2pa] sys_va2pa,
};

void syscall(void)
{
    80002fda:	1101                	addi	sp,sp,-32
    80002fdc:	ec06                	sd	ra,24(sp)
    80002fde:	e822                	sd	s0,16(sp)
    80002fe0:	e426                	sd	s1,8(sp)
    80002fe2:	e04a                	sd	s2,0(sp)
    80002fe4:	1000                	addi	s0,sp,32
    int num;
    struct proc *p = myproc();
    80002fe6:	fffff097          	auipc	ra,0xfffff
    80002fea:	c7a080e7          	jalr	-902(ra) # 80001c60 <myproc>
    80002fee:	84aa                	mv	s1,a0

    num = p->trapframe->a7;
    80002ff0:	05853903          	ld	s2,88(a0)
    80002ff4:	0a893783          	ld	a5,168(s2)
    80002ff8:	0007869b          	sext.w	a3,a5
    if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    80002ffc:	37fd                	addiw	a5,a5,-1
    80002ffe:	4765                	li	a4,25
    80003000:	00f76f63          	bltu	a4,a5,8000301e <syscall+0x44>
    80003004:	00369713          	slli	a4,a3,0x3
    80003008:	00006797          	auipc	a5,0x6
    8000300c:	89878793          	addi	a5,a5,-1896 # 800088a0 <syscalls>
    80003010:	97ba                	add	a5,a5,a4
    80003012:	639c                	ld	a5,0(a5)
    80003014:	c789                	beqz	a5,8000301e <syscall+0x44>
    {
        // Use num to lookup the system call function for num, call it,
        // and store its return value in p->trapframe->a0
        p->trapframe->a0 = syscalls[num]();
    80003016:	9782                	jalr	a5
    80003018:	06a93823          	sd	a0,112(s2)
    8000301c:	a839                	j	8000303a <syscall+0x60>
    }
    else
    {
        printf("%d %s: unknown sys call %d\n",
    8000301e:	15848613          	addi	a2,s1,344
    80003022:	588c                	lw	a1,48(s1)
    80003024:	00005517          	auipc	a0,0x5
    80003028:	4b450513          	addi	a0,a0,1204 # 800084d8 <__func__.1+0x4d0>
    8000302c:	ffffd097          	auipc	ra,0xffffd
    80003030:	590080e7          	jalr	1424(ra) # 800005bc <printf>
               p->pid, p->name, num);
        p->trapframe->a0 = -1;
    80003034:	6cbc                	ld	a5,88(s1)
    80003036:	577d                	li	a4,-1
    80003038:	fbb8                	sd	a4,112(a5)
    }
}
    8000303a:	60e2                	ld	ra,24(sp)
    8000303c:	6442                	ld	s0,16(sp)
    8000303e:	64a2                	ld	s1,8(sp)
    80003040:	6902                	ld	s2,0(sp)
    80003042:	6105                	addi	sp,sp,32
    80003044:	8082                	ret

0000000080003046 <sys_exit>:

extern uint64 FREE_PAGES; // kalloc.c keeps track of those

uint64
sys_exit(void)
{
    80003046:	1101                	addi	sp,sp,-32
    80003048:	ec06                	sd	ra,24(sp)
    8000304a:	e822                	sd	s0,16(sp)
    8000304c:	1000                	addi	s0,sp,32
    int n;
    argint(0, &n);
    8000304e:	fec40593          	addi	a1,s0,-20
    80003052:	4501                	li	a0,0
    80003054:	00000097          	auipc	ra,0x0
    80003058:	f16080e7          	jalr	-234(ra) # 80002f6a <argint>
    exit(n);
    8000305c:	fec42503          	lw	a0,-20(s0)
    80003060:	fffff097          	auipc	ra,0xfffff
    80003064:	4e8080e7          	jalr	1256(ra) # 80002548 <exit>
    return 0; // not reached
}
    80003068:	4501                	li	a0,0
    8000306a:	60e2                	ld	ra,24(sp)
    8000306c:	6442                	ld	s0,16(sp)
    8000306e:	6105                	addi	sp,sp,32
    80003070:	8082                	ret

0000000080003072 <sys_getpid>:

uint64
sys_getpid(void)
{
    80003072:	1141                	addi	sp,sp,-16
    80003074:	e406                	sd	ra,8(sp)
    80003076:	e022                	sd	s0,0(sp)
    80003078:	0800                	addi	s0,sp,16
    return myproc()->pid;
    8000307a:	fffff097          	auipc	ra,0xfffff
    8000307e:	be6080e7          	jalr	-1050(ra) # 80001c60 <myproc>
}
    80003082:	5908                	lw	a0,48(a0)
    80003084:	60a2                	ld	ra,8(sp)
    80003086:	6402                	ld	s0,0(sp)
    80003088:	0141                	addi	sp,sp,16
    8000308a:	8082                	ret

000000008000308c <sys_fork>:

uint64
sys_fork(void)
{
    8000308c:	1141                	addi	sp,sp,-16
    8000308e:	e406                	sd	ra,8(sp)
    80003090:	e022                	sd	s0,0(sp)
    80003092:	0800                	addi	s0,sp,16
    return fork();
    80003094:	fffff097          	auipc	ra,0xfffff
    80003098:	11c080e7          	jalr	284(ra) # 800021b0 <fork>
}
    8000309c:	60a2                	ld	ra,8(sp)
    8000309e:	6402                	ld	s0,0(sp)
    800030a0:	0141                	addi	sp,sp,16
    800030a2:	8082                	ret

00000000800030a4 <sys_wait>:

uint64
sys_wait(void)
{
    800030a4:	1101                	addi	sp,sp,-32
    800030a6:	ec06                	sd	ra,24(sp)
    800030a8:	e822                	sd	s0,16(sp)
    800030aa:	1000                	addi	s0,sp,32
    uint64 p;
    argaddr(0, &p);
    800030ac:	fe840593          	addi	a1,s0,-24
    800030b0:	4501                	li	a0,0
    800030b2:	00000097          	auipc	ra,0x0
    800030b6:	ed8080e7          	jalr	-296(ra) # 80002f8a <argaddr>
    return wait(p);
    800030ba:	fe843503          	ld	a0,-24(s0)
    800030be:	fffff097          	auipc	ra,0xfffff
    800030c2:	630080e7          	jalr	1584(ra) # 800026ee <wait>
}
    800030c6:	60e2                	ld	ra,24(sp)
    800030c8:	6442                	ld	s0,16(sp)
    800030ca:	6105                	addi	sp,sp,32
    800030cc:	8082                	ret

00000000800030ce <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800030ce:	7179                	addi	sp,sp,-48
    800030d0:	f406                	sd	ra,40(sp)
    800030d2:	f022                	sd	s0,32(sp)
    800030d4:	ec26                	sd	s1,24(sp)
    800030d6:	1800                	addi	s0,sp,48
    uint64 addr;
    int n;

    argint(0, &n);
    800030d8:	fdc40593          	addi	a1,s0,-36
    800030dc:	4501                	li	a0,0
    800030de:	00000097          	auipc	ra,0x0
    800030e2:	e8c080e7          	jalr	-372(ra) # 80002f6a <argint>
    addr = myproc()->sz;
    800030e6:	fffff097          	auipc	ra,0xfffff
    800030ea:	b7a080e7          	jalr	-1158(ra) # 80001c60 <myproc>
    800030ee:	6524                	ld	s1,72(a0)
    if (growproc(n) < 0)
    800030f0:	fdc42503          	lw	a0,-36(s0)
    800030f4:	fffff097          	auipc	ra,0xfffff
    800030f8:	ec6080e7          	jalr	-314(ra) # 80001fba <growproc>
    800030fc:	00054863          	bltz	a0,8000310c <sys_sbrk+0x3e>
        return -1;
    return addr;
}
    80003100:	8526                	mv	a0,s1
    80003102:	70a2                	ld	ra,40(sp)
    80003104:	7402                	ld	s0,32(sp)
    80003106:	64e2                	ld	s1,24(sp)
    80003108:	6145                	addi	sp,sp,48
    8000310a:	8082                	ret
        return -1;
    8000310c:	54fd                	li	s1,-1
    8000310e:	bfcd                	j	80003100 <sys_sbrk+0x32>

0000000080003110 <sys_sleep>:

uint64
sys_sleep(void)
{
    80003110:	7139                	addi	sp,sp,-64
    80003112:	fc06                	sd	ra,56(sp)
    80003114:	f822                	sd	s0,48(sp)
    80003116:	f04a                	sd	s2,32(sp)
    80003118:	0080                	addi	s0,sp,64
    int n;
    uint ticks0;

    argint(0, &n);
    8000311a:	fcc40593          	addi	a1,s0,-52
    8000311e:	4501                	li	a0,0
    80003120:	00000097          	auipc	ra,0x0
    80003124:	e4a080e7          	jalr	-438(ra) # 80002f6a <argint>
    acquire(&tickslock);
    80003128:	00014517          	auipc	a0,0x14
    8000312c:	9b850513          	addi	a0,a0,-1608 # 80016ae0 <tickslock>
    80003130:	ffffe097          	auipc	ra,0xffffe
    80003134:	bd6080e7          	jalr	-1066(ra) # 80000d06 <acquire>
    ticks0 = ticks;
    80003138:	00006917          	auipc	s2,0x6
    8000313c:	90892903          	lw	s2,-1784(s2) # 80008a40 <ticks>
    while (ticks - ticks0 < n)
    80003140:	fcc42783          	lw	a5,-52(s0)
    80003144:	c3b9                	beqz	a5,8000318a <sys_sleep+0x7a>
    80003146:	f426                	sd	s1,40(sp)
    80003148:	ec4e                	sd	s3,24(sp)
        if (killed(myproc()))
        {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
    8000314a:	00014997          	auipc	s3,0x14
    8000314e:	99698993          	addi	s3,s3,-1642 # 80016ae0 <tickslock>
    80003152:	00006497          	auipc	s1,0x6
    80003156:	8ee48493          	addi	s1,s1,-1810 # 80008a40 <ticks>
        if (killed(myproc()))
    8000315a:	fffff097          	auipc	ra,0xfffff
    8000315e:	b06080e7          	jalr	-1274(ra) # 80001c60 <myproc>
    80003162:	fffff097          	auipc	ra,0xfffff
    80003166:	55a080e7          	jalr	1370(ra) # 800026bc <killed>
    8000316a:	ed15                	bnez	a0,800031a6 <sys_sleep+0x96>
        sleep(&ticks, &tickslock);
    8000316c:	85ce                	mv	a1,s3
    8000316e:	8526                	mv	a0,s1
    80003170:	fffff097          	auipc	ra,0xfffff
    80003174:	2a4080e7          	jalr	676(ra) # 80002414 <sleep>
    while (ticks - ticks0 < n)
    80003178:	409c                	lw	a5,0(s1)
    8000317a:	412787bb          	subw	a5,a5,s2
    8000317e:	fcc42703          	lw	a4,-52(s0)
    80003182:	fce7ece3          	bltu	a5,a4,8000315a <sys_sleep+0x4a>
    80003186:	74a2                	ld	s1,40(sp)
    80003188:	69e2                	ld	s3,24(sp)
    }
    release(&tickslock);
    8000318a:	00014517          	auipc	a0,0x14
    8000318e:	95650513          	addi	a0,a0,-1706 # 80016ae0 <tickslock>
    80003192:	ffffe097          	auipc	ra,0xffffe
    80003196:	c24080e7          	jalr	-988(ra) # 80000db6 <release>
    return 0;
    8000319a:	4501                	li	a0,0
}
    8000319c:	70e2                	ld	ra,56(sp)
    8000319e:	7442                	ld	s0,48(sp)
    800031a0:	7902                	ld	s2,32(sp)
    800031a2:	6121                	addi	sp,sp,64
    800031a4:	8082                	ret
            release(&tickslock);
    800031a6:	00014517          	auipc	a0,0x14
    800031aa:	93a50513          	addi	a0,a0,-1734 # 80016ae0 <tickslock>
    800031ae:	ffffe097          	auipc	ra,0xffffe
    800031b2:	c08080e7          	jalr	-1016(ra) # 80000db6 <release>
            return -1;
    800031b6:	557d                	li	a0,-1
    800031b8:	74a2                	ld	s1,40(sp)
    800031ba:	69e2                	ld	s3,24(sp)
    800031bc:	b7c5                	j	8000319c <sys_sleep+0x8c>

00000000800031be <sys_kill>:

uint64
sys_kill(void)
{
    800031be:	1101                	addi	sp,sp,-32
    800031c0:	ec06                	sd	ra,24(sp)
    800031c2:	e822                	sd	s0,16(sp)
    800031c4:	1000                	addi	s0,sp,32
    int pid;

    argint(0, &pid);
    800031c6:	fec40593          	addi	a1,s0,-20
    800031ca:	4501                	li	a0,0
    800031cc:	00000097          	auipc	ra,0x0
    800031d0:	d9e080e7          	jalr	-610(ra) # 80002f6a <argint>
    return kill(pid);
    800031d4:	fec42503          	lw	a0,-20(s0)
    800031d8:	fffff097          	auipc	ra,0xfffff
    800031dc:	446080e7          	jalr	1094(ra) # 8000261e <kill>
}
    800031e0:	60e2                	ld	ra,24(sp)
    800031e2:	6442                	ld	s0,16(sp)
    800031e4:	6105                	addi	sp,sp,32
    800031e6:	8082                	ret

00000000800031e8 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800031e8:	1101                	addi	sp,sp,-32
    800031ea:	ec06                	sd	ra,24(sp)
    800031ec:	e822                	sd	s0,16(sp)
    800031ee:	e426                	sd	s1,8(sp)
    800031f0:	1000                	addi	s0,sp,32
    uint xticks;

    acquire(&tickslock);
    800031f2:	00014517          	auipc	a0,0x14
    800031f6:	8ee50513          	addi	a0,a0,-1810 # 80016ae0 <tickslock>
    800031fa:	ffffe097          	auipc	ra,0xffffe
    800031fe:	b0c080e7          	jalr	-1268(ra) # 80000d06 <acquire>
    xticks = ticks;
    80003202:	00006497          	auipc	s1,0x6
    80003206:	83e4a483          	lw	s1,-1986(s1) # 80008a40 <ticks>
    release(&tickslock);
    8000320a:	00014517          	auipc	a0,0x14
    8000320e:	8d650513          	addi	a0,a0,-1834 # 80016ae0 <tickslock>
    80003212:	ffffe097          	auipc	ra,0xffffe
    80003216:	ba4080e7          	jalr	-1116(ra) # 80000db6 <release>
    return xticks;
}
    8000321a:	02049513          	slli	a0,s1,0x20
    8000321e:	9101                	srli	a0,a0,0x20
    80003220:	60e2                	ld	ra,24(sp)
    80003222:	6442                	ld	s0,16(sp)
    80003224:	64a2                	ld	s1,8(sp)
    80003226:	6105                	addi	sp,sp,32
    80003228:	8082                	ret

000000008000322a <sys_ps>:

void *
sys_ps(void)
{
    8000322a:	1101                	addi	sp,sp,-32
    8000322c:	ec06                	sd	ra,24(sp)
    8000322e:	e822                	sd	s0,16(sp)
    80003230:	1000                	addi	s0,sp,32
    int start = 0, count = 0;
    80003232:	fe042623          	sw	zero,-20(s0)
    80003236:	fe042423          	sw	zero,-24(s0)
    argint(0, &start);
    8000323a:	fec40593          	addi	a1,s0,-20
    8000323e:	4501                	li	a0,0
    80003240:	00000097          	auipc	ra,0x0
    80003244:	d2a080e7          	jalr	-726(ra) # 80002f6a <argint>
    argint(1, &count);
    80003248:	fe840593          	addi	a1,s0,-24
    8000324c:	4505                	li	a0,1
    8000324e:	00000097          	auipc	ra,0x0
    80003252:	d1c080e7          	jalr	-740(ra) # 80002f6a <argint>
    return ps((uint8)start, (uint8)count);
    80003256:	fe844583          	lbu	a1,-24(s0)
    8000325a:	fec44503          	lbu	a0,-20(s0)
    8000325e:	fffff097          	auipc	ra,0xfffff
    80003262:	db8080e7          	jalr	-584(ra) # 80002016 <ps>
}
    80003266:	60e2                	ld	ra,24(sp)
    80003268:	6442                	ld	s0,16(sp)
    8000326a:	6105                	addi	sp,sp,32
    8000326c:	8082                	ret

000000008000326e <sys_schedls>:

uint64 sys_schedls(void)
{
    8000326e:	1141                	addi	sp,sp,-16
    80003270:	e406                	sd	ra,8(sp)
    80003272:	e022                	sd	s0,0(sp)
    80003274:	0800                	addi	s0,sp,16
    schedls();
    80003276:	fffff097          	auipc	ra,0xfffff
    8000327a:	6fc080e7          	jalr	1788(ra) # 80002972 <schedls>
    return 0;
}
    8000327e:	4501                	li	a0,0
    80003280:	60a2                	ld	ra,8(sp)
    80003282:	6402                	ld	s0,0(sp)
    80003284:	0141                	addi	sp,sp,16
    80003286:	8082                	ret

0000000080003288 <sys_schedset>:

uint64 sys_schedset(void)
{
    80003288:	1101                	addi	sp,sp,-32
    8000328a:	ec06                	sd	ra,24(sp)
    8000328c:	e822                	sd	s0,16(sp)
    8000328e:	1000                	addi	s0,sp,32
    int id = 0;
    80003290:	fe042623          	sw	zero,-20(s0)
    argint(0, &id);
    80003294:	fec40593          	addi	a1,s0,-20
    80003298:	4501                	li	a0,0
    8000329a:	00000097          	auipc	ra,0x0
    8000329e:	cd0080e7          	jalr	-816(ra) # 80002f6a <argint>
    schedset(id - 1);
    800032a2:	fec42503          	lw	a0,-20(s0)
    800032a6:	357d                	addiw	a0,a0,-1
    800032a8:	fffff097          	auipc	ra,0xfffff
    800032ac:	760080e7          	jalr	1888(ra) # 80002a08 <schedset>
    return 0;
}
    800032b0:	4501                	li	a0,0
    800032b2:	60e2                	ld	ra,24(sp)
    800032b4:	6442                	ld	s0,16(sp)
    800032b6:	6105                	addi	sp,sp,32
    800032b8:	8082                	ret

00000000800032ba <sys_va2pa>:

uint64 sys_va2pa(void)
{
    800032ba:	7179                	addi	sp,sp,-48
    800032bc:	f406                	sd	ra,40(sp)
    800032be:	f022                	sd	s0,32(sp)
    800032c0:	ec26                	sd	s1,24(sp)
    800032c2:	e84a                	sd	s2,16(sp)
    800032c4:	1800                	addi	s0,sp,48
    uint64 va;
    int pid;
    struct proc *p;
    
    argaddr(0, &va);   // Just call these without checking return
    800032c6:	fd840593          	addi	a1,s0,-40
    800032ca:	4501                	li	a0,0
    800032cc:	00000097          	auipc	ra,0x0
    800032d0:	cbe080e7          	jalr	-834(ra) # 80002f8a <argaddr>
    argint(1, &pid);   // since they're void functions
    800032d4:	fd440593          	addi	a1,s0,-44
    800032d8:	4505                	li	a0,1
    800032da:	00000097          	auipc	ra,0x0
    800032de:	c90080e7          	jalr	-880(ra) # 80002f6a <argint>
    
    if(pid == 0) {
    800032e2:	fd442783          	lw	a5,-44(s0)
        p = myproc();
    } else {
        extern struct proc proc[];
        p = proc;
        for(p = proc; p < &proc[NPROC]; p++) {
    800032e6:	0000e497          	auipc	s1,0xe
    800032ea:	dfa48493          	addi	s1,s1,-518 # 800110e0 <proc>
    800032ee:	00013917          	auipc	s2,0x13
    800032f2:	7f290913          	addi	s2,s2,2034 # 80016ae0 <tickslock>
    if(pid == 0) {
    800032f6:	c795                	beqz	a5,80003322 <sys_va2pa+0x68>
            acquire(&p->lock);
    800032f8:	8526                	mv	a0,s1
    800032fa:	ffffe097          	auipc	ra,0xffffe
    800032fe:	a0c080e7          	jalr	-1524(ra) # 80000d06 <acquire>
            if(p->pid == pid) {
    80003302:	5898                	lw	a4,48(s1)
    80003304:	fd442783          	lw	a5,-44(s0)
    80003308:	02f70363          	beq	a4,a5,8000332e <sys_va2pa+0x74>
                release(&p->lock);
                break;
            }
            release(&p->lock);
    8000330c:	8526                	mv	a0,s1
    8000330e:	ffffe097          	auipc	ra,0xffffe
    80003312:	aa8080e7          	jalr	-1368(ra) # 80000db6 <release>
        for(p = proc; p < &proc[NPROC]; p++) {
    80003316:	16848493          	addi	s1,s1,360
    8000331a:	fd249fe3          	bne	s1,s2,800032f8 <sys_va2pa+0x3e>
        }
        if(p >= &proc[NPROC])
            return 0;
    8000331e:	4501                	li	a0,0
    80003320:	a80d                	j	80003352 <sys_va2pa+0x98>
        p = myproc();
    80003322:	fffff097          	auipc	ra,0xfffff
    80003326:	93e080e7          	jalr	-1730(ra) # 80001c60 <myproc>
    8000332a:	84aa                	mv	s1,a0
    8000332c:	a821                	j	80003344 <sys_va2pa+0x8a>
                release(&p->lock);
    8000332e:	8526                	mv	a0,s1
    80003330:	ffffe097          	auipc	ra,0xffffe
    80003334:	a86080e7          	jalr	-1402(ra) # 80000db6 <release>
        if(p >= &proc[NPROC])
    80003338:	00013797          	auipc	a5,0x13
    8000333c:	7a878793          	addi	a5,a5,1960 # 80016ae0 <tickslock>
    80003340:	00f4ff63          	bgeu	s1,a5,8000335e <sys_va2pa+0xa4>
    }
    
    return va2pa_helper(p->pagetable, va);
    80003344:	fd843583          	ld	a1,-40(s0)
    80003348:	68a8                	ld	a0,80(s1)
    8000334a:	ffffe097          	auipc	ra,0xffffe
    8000334e:	64c080e7          	jalr	1612(ra) # 80001996 <va2pa_helper>
}
    80003352:	70a2                	ld	ra,40(sp)
    80003354:	7402                	ld	s0,32(sp)
    80003356:	64e2                	ld	s1,24(sp)
    80003358:	6942                	ld	s2,16(sp)
    8000335a:	6145                	addi	sp,sp,48
    8000335c:	8082                	ret
            return 0;
    8000335e:	4501                	li	a0,0
    80003360:	bfcd                	j	80003352 <sys_va2pa+0x98>

0000000080003362 <sys_pfreepages>:

uint64 sys_pfreepages(void)
{
    80003362:	1141                	addi	sp,sp,-16
    80003364:	e406                	sd	ra,8(sp)
    80003366:	e022                	sd	s0,0(sp)
    80003368:	0800                	addi	s0,sp,16
    printf("%d\n", FREE_PAGES);
    8000336a:	00005597          	auipc	a1,0x5
    8000336e:	6ae5b583          	ld	a1,1710(a1) # 80008a18 <FREE_PAGES>
    80003372:	00005517          	auipc	a0,0x5
    80003376:	18650513          	addi	a0,a0,390 # 800084f8 <__func__.1+0x4f0>
    8000337a:	ffffd097          	auipc	ra,0xffffd
    8000337e:	242080e7          	jalr	578(ra) # 800005bc <printf>
    return 0;
}
    80003382:	4501                	li	a0,0
    80003384:	60a2                	ld	ra,8(sp)
    80003386:	6402                	ld	s0,0(sp)
    80003388:	0141                	addi	sp,sp,16
    8000338a:	8082                	ret

000000008000338c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000338c:	7179                	addi	sp,sp,-48
    8000338e:	f406                	sd	ra,40(sp)
    80003390:	f022                	sd	s0,32(sp)
    80003392:	ec26                	sd	s1,24(sp)
    80003394:	e84a                	sd	s2,16(sp)
    80003396:	e44e                	sd	s3,8(sp)
    80003398:	e052                	sd	s4,0(sp)
    8000339a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000339c:	00005597          	auipc	a1,0x5
    800033a0:	16458593          	addi	a1,a1,356 # 80008500 <__func__.1+0x4f8>
    800033a4:	00013517          	auipc	a0,0x13
    800033a8:	75450513          	addi	a0,a0,1876 # 80016af8 <bcache>
    800033ac:	ffffe097          	auipc	ra,0xffffe
    800033b0:	8c6080e7          	jalr	-1850(ra) # 80000c72 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800033b4:	0001b797          	auipc	a5,0x1b
    800033b8:	74478793          	addi	a5,a5,1860 # 8001eaf8 <bcache+0x8000>
    800033bc:	0001c717          	auipc	a4,0x1c
    800033c0:	9a470713          	addi	a4,a4,-1628 # 8001ed60 <bcache+0x8268>
    800033c4:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800033c8:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800033cc:	00013497          	auipc	s1,0x13
    800033d0:	74448493          	addi	s1,s1,1860 # 80016b10 <bcache+0x18>
    b->next = bcache.head.next;
    800033d4:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800033d6:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800033d8:	00005a17          	auipc	s4,0x5
    800033dc:	130a0a13          	addi	s4,s4,304 # 80008508 <__func__.1+0x500>
    b->next = bcache.head.next;
    800033e0:	2b893783          	ld	a5,696(s2)
    800033e4:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800033e6:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800033ea:	85d2                	mv	a1,s4
    800033ec:	01048513          	addi	a0,s1,16
    800033f0:	00001097          	auipc	ra,0x1
    800033f4:	4e4080e7          	jalr	1252(ra) # 800048d4 <initsleeplock>
    bcache.head.next->prev = b;
    800033f8:	2b893783          	ld	a5,696(s2)
    800033fc:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800033fe:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003402:	45848493          	addi	s1,s1,1112
    80003406:	fd349de3          	bne	s1,s3,800033e0 <binit+0x54>
  }
}
    8000340a:	70a2                	ld	ra,40(sp)
    8000340c:	7402                	ld	s0,32(sp)
    8000340e:	64e2                	ld	s1,24(sp)
    80003410:	6942                	ld	s2,16(sp)
    80003412:	69a2                	ld	s3,8(sp)
    80003414:	6a02                	ld	s4,0(sp)
    80003416:	6145                	addi	sp,sp,48
    80003418:	8082                	ret

000000008000341a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000341a:	7179                	addi	sp,sp,-48
    8000341c:	f406                	sd	ra,40(sp)
    8000341e:	f022                	sd	s0,32(sp)
    80003420:	ec26                	sd	s1,24(sp)
    80003422:	e84a                	sd	s2,16(sp)
    80003424:	e44e                	sd	s3,8(sp)
    80003426:	1800                	addi	s0,sp,48
    80003428:	892a                	mv	s2,a0
    8000342a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000342c:	00013517          	auipc	a0,0x13
    80003430:	6cc50513          	addi	a0,a0,1740 # 80016af8 <bcache>
    80003434:	ffffe097          	auipc	ra,0xffffe
    80003438:	8d2080e7          	jalr	-1838(ra) # 80000d06 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000343c:	0001c497          	auipc	s1,0x1c
    80003440:	9744b483          	ld	s1,-1676(s1) # 8001edb0 <bcache+0x82b8>
    80003444:	0001c797          	auipc	a5,0x1c
    80003448:	91c78793          	addi	a5,a5,-1764 # 8001ed60 <bcache+0x8268>
    8000344c:	02f48f63          	beq	s1,a5,8000348a <bread+0x70>
    80003450:	873e                	mv	a4,a5
    80003452:	a021                	j	8000345a <bread+0x40>
    80003454:	68a4                	ld	s1,80(s1)
    80003456:	02e48a63          	beq	s1,a4,8000348a <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000345a:	449c                	lw	a5,8(s1)
    8000345c:	ff279ce3          	bne	a5,s2,80003454 <bread+0x3a>
    80003460:	44dc                	lw	a5,12(s1)
    80003462:	ff3799e3          	bne	a5,s3,80003454 <bread+0x3a>
      b->refcnt++;
    80003466:	40bc                	lw	a5,64(s1)
    80003468:	2785                	addiw	a5,a5,1
    8000346a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000346c:	00013517          	auipc	a0,0x13
    80003470:	68c50513          	addi	a0,a0,1676 # 80016af8 <bcache>
    80003474:	ffffe097          	auipc	ra,0xffffe
    80003478:	942080e7          	jalr	-1726(ra) # 80000db6 <release>
      acquiresleep(&b->lock);
    8000347c:	01048513          	addi	a0,s1,16
    80003480:	00001097          	auipc	ra,0x1
    80003484:	48e080e7          	jalr	1166(ra) # 8000490e <acquiresleep>
      return b;
    80003488:	a8b9                	j	800034e6 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000348a:	0001c497          	auipc	s1,0x1c
    8000348e:	91e4b483          	ld	s1,-1762(s1) # 8001eda8 <bcache+0x82b0>
    80003492:	0001c797          	auipc	a5,0x1c
    80003496:	8ce78793          	addi	a5,a5,-1842 # 8001ed60 <bcache+0x8268>
    8000349a:	00f48863          	beq	s1,a5,800034aa <bread+0x90>
    8000349e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800034a0:	40bc                	lw	a5,64(s1)
    800034a2:	cf81                	beqz	a5,800034ba <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800034a4:	64a4                	ld	s1,72(s1)
    800034a6:	fee49de3          	bne	s1,a4,800034a0 <bread+0x86>
  panic("bget: no buffers");
    800034aa:	00005517          	auipc	a0,0x5
    800034ae:	06650513          	addi	a0,a0,102 # 80008510 <__func__.1+0x508>
    800034b2:	ffffd097          	auipc	ra,0xffffd
    800034b6:	0ae080e7          	jalr	174(ra) # 80000560 <panic>
      b->dev = dev;
    800034ba:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800034be:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800034c2:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800034c6:	4785                	li	a5,1
    800034c8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800034ca:	00013517          	auipc	a0,0x13
    800034ce:	62e50513          	addi	a0,a0,1582 # 80016af8 <bcache>
    800034d2:	ffffe097          	auipc	ra,0xffffe
    800034d6:	8e4080e7          	jalr	-1820(ra) # 80000db6 <release>
      acquiresleep(&b->lock);
    800034da:	01048513          	addi	a0,s1,16
    800034de:	00001097          	auipc	ra,0x1
    800034e2:	430080e7          	jalr	1072(ra) # 8000490e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800034e6:	409c                	lw	a5,0(s1)
    800034e8:	cb89                	beqz	a5,800034fa <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800034ea:	8526                	mv	a0,s1
    800034ec:	70a2                	ld	ra,40(sp)
    800034ee:	7402                	ld	s0,32(sp)
    800034f0:	64e2                	ld	s1,24(sp)
    800034f2:	6942                	ld	s2,16(sp)
    800034f4:	69a2                	ld	s3,8(sp)
    800034f6:	6145                	addi	sp,sp,48
    800034f8:	8082                	ret
    virtio_disk_rw(b, 0);
    800034fa:	4581                	li	a1,0
    800034fc:	8526                	mv	a0,s1
    800034fe:	00003097          	auipc	ra,0x3
    80003502:	10a080e7          	jalr	266(ra) # 80006608 <virtio_disk_rw>
    b->valid = 1;
    80003506:	4785                	li	a5,1
    80003508:	c09c                	sw	a5,0(s1)
  return b;
    8000350a:	b7c5                	j	800034ea <bread+0xd0>

000000008000350c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000350c:	1101                	addi	sp,sp,-32
    8000350e:	ec06                	sd	ra,24(sp)
    80003510:	e822                	sd	s0,16(sp)
    80003512:	e426                	sd	s1,8(sp)
    80003514:	1000                	addi	s0,sp,32
    80003516:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003518:	0541                	addi	a0,a0,16
    8000351a:	00001097          	auipc	ra,0x1
    8000351e:	48e080e7          	jalr	1166(ra) # 800049a8 <holdingsleep>
    80003522:	cd01                	beqz	a0,8000353a <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003524:	4585                	li	a1,1
    80003526:	8526                	mv	a0,s1
    80003528:	00003097          	auipc	ra,0x3
    8000352c:	0e0080e7          	jalr	224(ra) # 80006608 <virtio_disk_rw>
}
    80003530:	60e2                	ld	ra,24(sp)
    80003532:	6442                	ld	s0,16(sp)
    80003534:	64a2                	ld	s1,8(sp)
    80003536:	6105                	addi	sp,sp,32
    80003538:	8082                	ret
    panic("bwrite");
    8000353a:	00005517          	auipc	a0,0x5
    8000353e:	fee50513          	addi	a0,a0,-18 # 80008528 <__func__.1+0x520>
    80003542:	ffffd097          	auipc	ra,0xffffd
    80003546:	01e080e7          	jalr	30(ra) # 80000560 <panic>

000000008000354a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000354a:	1101                	addi	sp,sp,-32
    8000354c:	ec06                	sd	ra,24(sp)
    8000354e:	e822                	sd	s0,16(sp)
    80003550:	e426                	sd	s1,8(sp)
    80003552:	e04a                	sd	s2,0(sp)
    80003554:	1000                	addi	s0,sp,32
    80003556:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003558:	01050913          	addi	s2,a0,16
    8000355c:	854a                	mv	a0,s2
    8000355e:	00001097          	auipc	ra,0x1
    80003562:	44a080e7          	jalr	1098(ra) # 800049a8 <holdingsleep>
    80003566:	c535                	beqz	a0,800035d2 <brelse+0x88>
    panic("brelse");

  releasesleep(&b->lock);
    80003568:	854a                	mv	a0,s2
    8000356a:	00001097          	auipc	ra,0x1
    8000356e:	3fa080e7          	jalr	1018(ra) # 80004964 <releasesleep>

  acquire(&bcache.lock);
    80003572:	00013517          	auipc	a0,0x13
    80003576:	58650513          	addi	a0,a0,1414 # 80016af8 <bcache>
    8000357a:	ffffd097          	auipc	ra,0xffffd
    8000357e:	78c080e7          	jalr	1932(ra) # 80000d06 <acquire>
  b->refcnt--;
    80003582:	40bc                	lw	a5,64(s1)
    80003584:	37fd                	addiw	a5,a5,-1
    80003586:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003588:	e79d                	bnez	a5,800035b6 <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000358a:	68b8                	ld	a4,80(s1)
    8000358c:	64bc                	ld	a5,72(s1)
    8000358e:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003590:	68b8                	ld	a4,80(s1)
    80003592:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003594:	0001b797          	auipc	a5,0x1b
    80003598:	56478793          	addi	a5,a5,1380 # 8001eaf8 <bcache+0x8000>
    8000359c:	2b87b703          	ld	a4,696(a5)
    800035a0:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800035a2:	0001b717          	auipc	a4,0x1b
    800035a6:	7be70713          	addi	a4,a4,1982 # 8001ed60 <bcache+0x8268>
    800035aa:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800035ac:	2b87b703          	ld	a4,696(a5)
    800035b0:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800035b2:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800035b6:	00013517          	auipc	a0,0x13
    800035ba:	54250513          	addi	a0,a0,1346 # 80016af8 <bcache>
    800035be:	ffffd097          	auipc	ra,0xffffd
    800035c2:	7f8080e7          	jalr	2040(ra) # 80000db6 <release>
}
    800035c6:	60e2                	ld	ra,24(sp)
    800035c8:	6442                	ld	s0,16(sp)
    800035ca:	64a2                	ld	s1,8(sp)
    800035cc:	6902                	ld	s2,0(sp)
    800035ce:	6105                	addi	sp,sp,32
    800035d0:	8082                	ret
    panic("brelse");
    800035d2:	00005517          	auipc	a0,0x5
    800035d6:	f5e50513          	addi	a0,a0,-162 # 80008530 <__func__.1+0x528>
    800035da:	ffffd097          	auipc	ra,0xffffd
    800035de:	f86080e7          	jalr	-122(ra) # 80000560 <panic>

00000000800035e2 <bpin>:

void
bpin(struct buf *b) {
    800035e2:	1101                	addi	sp,sp,-32
    800035e4:	ec06                	sd	ra,24(sp)
    800035e6:	e822                	sd	s0,16(sp)
    800035e8:	e426                	sd	s1,8(sp)
    800035ea:	1000                	addi	s0,sp,32
    800035ec:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800035ee:	00013517          	auipc	a0,0x13
    800035f2:	50a50513          	addi	a0,a0,1290 # 80016af8 <bcache>
    800035f6:	ffffd097          	auipc	ra,0xffffd
    800035fa:	710080e7          	jalr	1808(ra) # 80000d06 <acquire>
  b->refcnt++;
    800035fe:	40bc                	lw	a5,64(s1)
    80003600:	2785                	addiw	a5,a5,1
    80003602:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003604:	00013517          	auipc	a0,0x13
    80003608:	4f450513          	addi	a0,a0,1268 # 80016af8 <bcache>
    8000360c:	ffffd097          	auipc	ra,0xffffd
    80003610:	7aa080e7          	jalr	1962(ra) # 80000db6 <release>
}
    80003614:	60e2                	ld	ra,24(sp)
    80003616:	6442                	ld	s0,16(sp)
    80003618:	64a2                	ld	s1,8(sp)
    8000361a:	6105                	addi	sp,sp,32
    8000361c:	8082                	ret

000000008000361e <bunpin>:

void
bunpin(struct buf *b) {
    8000361e:	1101                	addi	sp,sp,-32
    80003620:	ec06                	sd	ra,24(sp)
    80003622:	e822                	sd	s0,16(sp)
    80003624:	e426                	sd	s1,8(sp)
    80003626:	1000                	addi	s0,sp,32
    80003628:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000362a:	00013517          	auipc	a0,0x13
    8000362e:	4ce50513          	addi	a0,a0,1230 # 80016af8 <bcache>
    80003632:	ffffd097          	auipc	ra,0xffffd
    80003636:	6d4080e7          	jalr	1748(ra) # 80000d06 <acquire>
  b->refcnt--;
    8000363a:	40bc                	lw	a5,64(s1)
    8000363c:	37fd                	addiw	a5,a5,-1
    8000363e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003640:	00013517          	auipc	a0,0x13
    80003644:	4b850513          	addi	a0,a0,1208 # 80016af8 <bcache>
    80003648:	ffffd097          	auipc	ra,0xffffd
    8000364c:	76e080e7          	jalr	1902(ra) # 80000db6 <release>
}
    80003650:	60e2                	ld	ra,24(sp)
    80003652:	6442                	ld	s0,16(sp)
    80003654:	64a2                	ld	s1,8(sp)
    80003656:	6105                	addi	sp,sp,32
    80003658:	8082                	ret

000000008000365a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000365a:	1101                	addi	sp,sp,-32
    8000365c:	ec06                	sd	ra,24(sp)
    8000365e:	e822                	sd	s0,16(sp)
    80003660:	e426                	sd	s1,8(sp)
    80003662:	e04a                	sd	s2,0(sp)
    80003664:	1000                	addi	s0,sp,32
    80003666:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003668:	00d5d79b          	srliw	a5,a1,0xd
    8000366c:	0001c597          	auipc	a1,0x1c
    80003670:	b685a583          	lw	a1,-1176(a1) # 8001f1d4 <sb+0x1c>
    80003674:	9dbd                	addw	a1,a1,a5
    80003676:	00000097          	auipc	ra,0x0
    8000367a:	da4080e7          	jalr	-604(ra) # 8000341a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000367e:	0074f713          	andi	a4,s1,7
    80003682:	4785                	li	a5,1
    80003684:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80003688:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    8000368a:	90d9                	srli	s1,s1,0x36
    8000368c:	00950733          	add	a4,a0,s1
    80003690:	05874703          	lbu	a4,88(a4)
    80003694:	00e7f6b3          	and	a3,a5,a4
    80003698:	c69d                	beqz	a3,800036c6 <bfree+0x6c>
    8000369a:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000369c:	94aa                	add	s1,s1,a0
    8000369e:	fff7c793          	not	a5,a5
    800036a2:	8f7d                	and	a4,a4,a5
    800036a4:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800036a8:	00001097          	auipc	ra,0x1
    800036ac:	148080e7          	jalr	328(ra) # 800047f0 <log_write>
  brelse(bp);
    800036b0:	854a                	mv	a0,s2
    800036b2:	00000097          	auipc	ra,0x0
    800036b6:	e98080e7          	jalr	-360(ra) # 8000354a <brelse>
}
    800036ba:	60e2                	ld	ra,24(sp)
    800036bc:	6442                	ld	s0,16(sp)
    800036be:	64a2                	ld	s1,8(sp)
    800036c0:	6902                	ld	s2,0(sp)
    800036c2:	6105                	addi	sp,sp,32
    800036c4:	8082                	ret
    panic("freeing free block");
    800036c6:	00005517          	auipc	a0,0x5
    800036ca:	e7250513          	addi	a0,a0,-398 # 80008538 <__func__.1+0x530>
    800036ce:	ffffd097          	auipc	ra,0xffffd
    800036d2:	e92080e7          	jalr	-366(ra) # 80000560 <panic>

00000000800036d6 <balloc>:
{
    800036d6:	715d                	addi	sp,sp,-80
    800036d8:	e486                	sd	ra,72(sp)
    800036da:	e0a2                	sd	s0,64(sp)
    800036dc:	fc26                	sd	s1,56(sp)
    800036de:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    800036e0:	0001c797          	auipc	a5,0x1c
    800036e4:	adc7a783          	lw	a5,-1316(a5) # 8001f1bc <sb+0x4>
    800036e8:	10078863          	beqz	a5,800037f8 <balloc+0x122>
    800036ec:	f84a                	sd	s2,48(sp)
    800036ee:	f44e                	sd	s3,40(sp)
    800036f0:	f052                	sd	s4,32(sp)
    800036f2:	ec56                	sd	s5,24(sp)
    800036f4:	e85a                	sd	s6,16(sp)
    800036f6:	e45e                	sd	s7,8(sp)
    800036f8:	e062                	sd	s8,0(sp)
    800036fa:	8baa                	mv	s7,a0
    800036fc:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800036fe:	0001cb17          	auipc	s6,0x1c
    80003702:	abab0b13          	addi	s6,s6,-1350 # 8001f1b8 <sb>
      m = 1 << (bi % 8);
    80003706:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003708:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000370a:	6c09                	lui	s8,0x2
    8000370c:	a049                	j	8000378e <balloc+0xb8>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000370e:	97ca                	add	a5,a5,s2
    80003710:	8e55                	or	a2,a2,a3
    80003712:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003716:	854a                	mv	a0,s2
    80003718:	00001097          	auipc	ra,0x1
    8000371c:	0d8080e7          	jalr	216(ra) # 800047f0 <log_write>
        brelse(bp);
    80003720:	854a                	mv	a0,s2
    80003722:	00000097          	auipc	ra,0x0
    80003726:	e28080e7          	jalr	-472(ra) # 8000354a <brelse>
  bp = bread(dev, bno);
    8000372a:	85a6                	mv	a1,s1
    8000372c:	855e                	mv	a0,s7
    8000372e:	00000097          	auipc	ra,0x0
    80003732:	cec080e7          	jalr	-788(ra) # 8000341a <bread>
    80003736:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003738:	40000613          	li	a2,1024
    8000373c:	4581                	li	a1,0
    8000373e:	05850513          	addi	a0,a0,88
    80003742:	ffffd097          	auipc	ra,0xffffd
    80003746:	6bc080e7          	jalr	1724(ra) # 80000dfe <memset>
  log_write(bp);
    8000374a:	854a                	mv	a0,s2
    8000374c:	00001097          	auipc	ra,0x1
    80003750:	0a4080e7          	jalr	164(ra) # 800047f0 <log_write>
  brelse(bp);
    80003754:	854a                	mv	a0,s2
    80003756:	00000097          	auipc	ra,0x0
    8000375a:	df4080e7          	jalr	-524(ra) # 8000354a <brelse>
}
    8000375e:	7942                	ld	s2,48(sp)
    80003760:	79a2                	ld	s3,40(sp)
    80003762:	7a02                	ld	s4,32(sp)
    80003764:	6ae2                	ld	s5,24(sp)
    80003766:	6b42                	ld	s6,16(sp)
    80003768:	6ba2                	ld	s7,8(sp)
    8000376a:	6c02                	ld	s8,0(sp)
}
    8000376c:	8526                	mv	a0,s1
    8000376e:	60a6                	ld	ra,72(sp)
    80003770:	6406                	ld	s0,64(sp)
    80003772:	74e2                	ld	s1,56(sp)
    80003774:	6161                	addi	sp,sp,80
    80003776:	8082                	ret
    brelse(bp);
    80003778:	854a                	mv	a0,s2
    8000377a:	00000097          	auipc	ra,0x0
    8000377e:	dd0080e7          	jalr	-560(ra) # 8000354a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003782:	015c0abb          	addw	s5,s8,s5
    80003786:	004b2783          	lw	a5,4(s6)
    8000378a:	06faf063          	bgeu	s5,a5,800037ea <balloc+0x114>
    bp = bread(dev, BBLOCK(b, sb));
    8000378e:	41fad79b          	sraiw	a5,s5,0x1f
    80003792:	0137d79b          	srliw	a5,a5,0x13
    80003796:	015787bb          	addw	a5,a5,s5
    8000379a:	40d7d79b          	sraiw	a5,a5,0xd
    8000379e:	01cb2583          	lw	a1,28(s6)
    800037a2:	9dbd                	addw	a1,a1,a5
    800037a4:	855e                	mv	a0,s7
    800037a6:	00000097          	auipc	ra,0x0
    800037aa:	c74080e7          	jalr	-908(ra) # 8000341a <bread>
    800037ae:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800037b0:	004b2503          	lw	a0,4(s6)
    800037b4:	84d6                	mv	s1,s5
    800037b6:	4701                	li	a4,0
    800037b8:	fca4f0e3          	bgeu	s1,a0,80003778 <balloc+0xa2>
      m = 1 << (bi % 8);
    800037bc:	00777693          	andi	a3,a4,7
    800037c0:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800037c4:	41f7579b          	sraiw	a5,a4,0x1f
    800037c8:	01d7d79b          	srliw	a5,a5,0x1d
    800037cc:	9fb9                	addw	a5,a5,a4
    800037ce:	4037d79b          	sraiw	a5,a5,0x3
    800037d2:	00f90633          	add	a2,s2,a5
    800037d6:	05864603          	lbu	a2,88(a2)
    800037da:	00c6f5b3          	and	a1,a3,a2
    800037de:	d985                	beqz	a1,8000370e <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800037e0:	2705                	addiw	a4,a4,1
    800037e2:	2485                	addiw	s1,s1,1
    800037e4:	fd471ae3          	bne	a4,s4,800037b8 <balloc+0xe2>
    800037e8:	bf41                	j	80003778 <balloc+0xa2>
    800037ea:	7942                	ld	s2,48(sp)
    800037ec:	79a2                	ld	s3,40(sp)
    800037ee:	7a02                	ld	s4,32(sp)
    800037f0:	6ae2                	ld	s5,24(sp)
    800037f2:	6b42                	ld	s6,16(sp)
    800037f4:	6ba2                	ld	s7,8(sp)
    800037f6:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    800037f8:	00005517          	auipc	a0,0x5
    800037fc:	d5850513          	addi	a0,a0,-680 # 80008550 <__func__.1+0x548>
    80003800:	ffffd097          	auipc	ra,0xffffd
    80003804:	dbc080e7          	jalr	-580(ra) # 800005bc <printf>
  return 0;
    80003808:	4481                	li	s1,0
    8000380a:	b78d                	j	8000376c <balloc+0x96>

000000008000380c <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000380c:	7179                	addi	sp,sp,-48
    8000380e:	f406                	sd	ra,40(sp)
    80003810:	f022                	sd	s0,32(sp)
    80003812:	ec26                	sd	s1,24(sp)
    80003814:	e84a                	sd	s2,16(sp)
    80003816:	e44e                	sd	s3,8(sp)
    80003818:	1800                	addi	s0,sp,48
    8000381a:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000381c:	47ad                	li	a5,11
    8000381e:	02b7e563          	bltu	a5,a1,80003848 <bmap+0x3c>
    if((addr = ip->addrs[bn]) == 0){
    80003822:	02059793          	slli	a5,a1,0x20
    80003826:	01e7d593          	srli	a1,a5,0x1e
    8000382a:	00b504b3          	add	s1,a0,a1
    8000382e:	0504a903          	lw	s2,80(s1)
    80003832:	06091b63          	bnez	s2,800038a8 <bmap+0x9c>
      addr = balloc(ip->dev);
    80003836:	4108                	lw	a0,0(a0)
    80003838:	00000097          	auipc	ra,0x0
    8000383c:	e9e080e7          	jalr	-354(ra) # 800036d6 <balloc>
    80003840:	892a                	mv	s2,a0
      if(addr == 0)
    80003842:	c13d                	beqz	a0,800038a8 <bmap+0x9c>
        return 0;
      ip->addrs[bn] = addr;
    80003844:	c8a8                	sw	a0,80(s1)
    80003846:	a08d                	j	800038a8 <bmap+0x9c>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003848:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    8000384c:	0ff00793          	li	a5,255
    80003850:	0897e363          	bltu	a5,s1,800038d6 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003854:	08052903          	lw	s2,128(a0)
    80003858:	00091d63          	bnez	s2,80003872 <bmap+0x66>
      addr = balloc(ip->dev);
    8000385c:	4108                	lw	a0,0(a0)
    8000385e:	00000097          	auipc	ra,0x0
    80003862:	e78080e7          	jalr	-392(ra) # 800036d6 <balloc>
    80003866:	892a                	mv	s2,a0
      if(addr == 0)
    80003868:	c121                	beqz	a0,800038a8 <bmap+0x9c>
    8000386a:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000386c:	08a9a023          	sw	a0,128(s3)
    80003870:	a011                	j	80003874 <bmap+0x68>
    80003872:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003874:	85ca                	mv	a1,s2
    80003876:	0009a503          	lw	a0,0(s3)
    8000387a:	00000097          	auipc	ra,0x0
    8000387e:	ba0080e7          	jalr	-1120(ra) # 8000341a <bread>
    80003882:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003884:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003888:	02049713          	slli	a4,s1,0x20
    8000388c:	01e75593          	srli	a1,a4,0x1e
    80003890:	00b784b3          	add	s1,a5,a1
    80003894:	0004a903          	lw	s2,0(s1)
    80003898:	02090063          	beqz	s2,800038b8 <bmap+0xac>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000389c:	8552                	mv	a0,s4
    8000389e:	00000097          	auipc	ra,0x0
    800038a2:	cac080e7          	jalr	-852(ra) # 8000354a <brelse>
    return addr;
    800038a6:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800038a8:	854a                	mv	a0,s2
    800038aa:	70a2                	ld	ra,40(sp)
    800038ac:	7402                	ld	s0,32(sp)
    800038ae:	64e2                	ld	s1,24(sp)
    800038b0:	6942                	ld	s2,16(sp)
    800038b2:	69a2                	ld	s3,8(sp)
    800038b4:	6145                	addi	sp,sp,48
    800038b6:	8082                	ret
      addr = balloc(ip->dev);
    800038b8:	0009a503          	lw	a0,0(s3)
    800038bc:	00000097          	auipc	ra,0x0
    800038c0:	e1a080e7          	jalr	-486(ra) # 800036d6 <balloc>
    800038c4:	892a                	mv	s2,a0
      if(addr){
    800038c6:	d979                	beqz	a0,8000389c <bmap+0x90>
        a[bn] = addr;
    800038c8:	c088                	sw	a0,0(s1)
        log_write(bp);
    800038ca:	8552                	mv	a0,s4
    800038cc:	00001097          	auipc	ra,0x1
    800038d0:	f24080e7          	jalr	-220(ra) # 800047f0 <log_write>
    800038d4:	b7e1                	j	8000389c <bmap+0x90>
    800038d6:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800038d8:	00005517          	auipc	a0,0x5
    800038dc:	c9050513          	addi	a0,a0,-880 # 80008568 <__func__.1+0x560>
    800038e0:	ffffd097          	auipc	ra,0xffffd
    800038e4:	c80080e7          	jalr	-896(ra) # 80000560 <panic>

00000000800038e8 <iget>:
{
    800038e8:	7179                	addi	sp,sp,-48
    800038ea:	f406                	sd	ra,40(sp)
    800038ec:	f022                	sd	s0,32(sp)
    800038ee:	ec26                	sd	s1,24(sp)
    800038f0:	e84a                	sd	s2,16(sp)
    800038f2:	e44e                	sd	s3,8(sp)
    800038f4:	e052                	sd	s4,0(sp)
    800038f6:	1800                	addi	s0,sp,48
    800038f8:	89aa                	mv	s3,a0
    800038fa:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800038fc:	0001c517          	auipc	a0,0x1c
    80003900:	8dc50513          	addi	a0,a0,-1828 # 8001f1d8 <itable>
    80003904:	ffffd097          	auipc	ra,0xffffd
    80003908:	402080e7          	jalr	1026(ra) # 80000d06 <acquire>
  empty = 0;
    8000390c:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000390e:	0001c497          	auipc	s1,0x1c
    80003912:	8e248493          	addi	s1,s1,-1822 # 8001f1f0 <itable+0x18>
    80003916:	0001d697          	auipc	a3,0x1d
    8000391a:	36a68693          	addi	a3,a3,874 # 80020c80 <log>
    8000391e:	a039                	j	8000392c <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003920:	02090b63          	beqz	s2,80003956 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003924:	08848493          	addi	s1,s1,136
    80003928:	02d48a63          	beq	s1,a3,8000395c <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000392c:	449c                	lw	a5,8(s1)
    8000392e:	fef059e3          	blez	a5,80003920 <iget+0x38>
    80003932:	4098                	lw	a4,0(s1)
    80003934:	ff3716e3          	bne	a4,s3,80003920 <iget+0x38>
    80003938:	40d8                	lw	a4,4(s1)
    8000393a:	ff4713e3          	bne	a4,s4,80003920 <iget+0x38>
      ip->ref++;
    8000393e:	2785                	addiw	a5,a5,1
    80003940:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003942:	0001c517          	auipc	a0,0x1c
    80003946:	89650513          	addi	a0,a0,-1898 # 8001f1d8 <itable>
    8000394a:	ffffd097          	auipc	ra,0xffffd
    8000394e:	46c080e7          	jalr	1132(ra) # 80000db6 <release>
      return ip;
    80003952:	8926                	mv	s2,s1
    80003954:	a03d                	j	80003982 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003956:	f7f9                	bnez	a5,80003924 <iget+0x3c>
      empty = ip;
    80003958:	8926                	mv	s2,s1
    8000395a:	b7e9                	j	80003924 <iget+0x3c>
  if(empty == 0)
    8000395c:	02090c63          	beqz	s2,80003994 <iget+0xac>
  ip->dev = dev;
    80003960:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003964:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003968:	4785                	li	a5,1
    8000396a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000396e:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003972:	0001c517          	auipc	a0,0x1c
    80003976:	86650513          	addi	a0,a0,-1946 # 8001f1d8 <itable>
    8000397a:	ffffd097          	auipc	ra,0xffffd
    8000397e:	43c080e7          	jalr	1084(ra) # 80000db6 <release>
}
    80003982:	854a                	mv	a0,s2
    80003984:	70a2                	ld	ra,40(sp)
    80003986:	7402                	ld	s0,32(sp)
    80003988:	64e2                	ld	s1,24(sp)
    8000398a:	6942                	ld	s2,16(sp)
    8000398c:	69a2                	ld	s3,8(sp)
    8000398e:	6a02                	ld	s4,0(sp)
    80003990:	6145                	addi	sp,sp,48
    80003992:	8082                	ret
    panic("iget: no inodes");
    80003994:	00005517          	auipc	a0,0x5
    80003998:	bec50513          	addi	a0,a0,-1044 # 80008580 <__func__.1+0x578>
    8000399c:	ffffd097          	auipc	ra,0xffffd
    800039a0:	bc4080e7          	jalr	-1084(ra) # 80000560 <panic>

00000000800039a4 <fsinit>:
fsinit(int dev) {
    800039a4:	7179                	addi	sp,sp,-48
    800039a6:	f406                	sd	ra,40(sp)
    800039a8:	f022                	sd	s0,32(sp)
    800039aa:	ec26                	sd	s1,24(sp)
    800039ac:	e84a                	sd	s2,16(sp)
    800039ae:	e44e                	sd	s3,8(sp)
    800039b0:	1800                	addi	s0,sp,48
    800039b2:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800039b4:	4585                	li	a1,1
    800039b6:	00000097          	auipc	ra,0x0
    800039ba:	a64080e7          	jalr	-1436(ra) # 8000341a <bread>
    800039be:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800039c0:	0001b997          	auipc	s3,0x1b
    800039c4:	7f898993          	addi	s3,s3,2040 # 8001f1b8 <sb>
    800039c8:	02000613          	li	a2,32
    800039cc:	05850593          	addi	a1,a0,88
    800039d0:	854e                	mv	a0,s3
    800039d2:	ffffd097          	auipc	ra,0xffffd
    800039d6:	490080e7          	jalr	1168(ra) # 80000e62 <memmove>
  brelse(bp);
    800039da:	8526                	mv	a0,s1
    800039dc:	00000097          	auipc	ra,0x0
    800039e0:	b6e080e7          	jalr	-1170(ra) # 8000354a <brelse>
  if(sb.magic != FSMAGIC)
    800039e4:	0009a703          	lw	a4,0(s3)
    800039e8:	102037b7          	lui	a5,0x10203
    800039ec:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800039f0:	02f71263          	bne	a4,a5,80003a14 <fsinit+0x70>
  initlog(dev, &sb);
    800039f4:	0001b597          	auipc	a1,0x1b
    800039f8:	7c458593          	addi	a1,a1,1988 # 8001f1b8 <sb>
    800039fc:	854a                	mv	a0,s2
    800039fe:	00001097          	auipc	ra,0x1
    80003a02:	b7c080e7          	jalr	-1156(ra) # 8000457a <initlog>
}
    80003a06:	70a2                	ld	ra,40(sp)
    80003a08:	7402                	ld	s0,32(sp)
    80003a0a:	64e2                	ld	s1,24(sp)
    80003a0c:	6942                	ld	s2,16(sp)
    80003a0e:	69a2                	ld	s3,8(sp)
    80003a10:	6145                	addi	sp,sp,48
    80003a12:	8082                	ret
    panic("invalid file system");
    80003a14:	00005517          	auipc	a0,0x5
    80003a18:	b7c50513          	addi	a0,a0,-1156 # 80008590 <__func__.1+0x588>
    80003a1c:	ffffd097          	auipc	ra,0xffffd
    80003a20:	b44080e7          	jalr	-1212(ra) # 80000560 <panic>

0000000080003a24 <iinit>:
{
    80003a24:	7179                	addi	sp,sp,-48
    80003a26:	f406                	sd	ra,40(sp)
    80003a28:	f022                	sd	s0,32(sp)
    80003a2a:	ec26                	sd	s1,24(sp)
    80003a2c:	e84a                	sd	s2,16(sp)
    80003a2e:	e44e                	sd	s3,8(sp)
    80003a30:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003a32:	00005597          	auipc	a1,0x5
    80003a36:	b7658593          	addi	a1,a1,-1162 # 800085a8 <__func__.1+0x5a0>
    80003a3a:	0001b517          	auipc	a0,0x1b
    80003a3e:	79e50513          	addi	a0,a0,1950 # 8001f1d8 <itable>
    80003a42:	ffffd097          	auipc	ra,0xffffd
    80003a46:	230080e7          	jalr	560(ra) # 80000c72 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003a4a:	0001b497          	auipc	s1,0x1b
    80003a4e:	7b648493          	addi	s1,s1,1974 # 8001f200 <itable+0x28>
    80003a52:	0001d997          	auipc	s3,0x1d
    80003a56:	23e98993          	addi	s3,s3,574 # 80020c90 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003a5a:	00005917          	auipc	s2,0x5
    80003a5e:	b5690913          	addi	s2,s2,-1194 # 800085b0 <__func__.1+0x5a8>
    80003a62:	85ca                	mv	a1,s2
    80003a64:	8526                	mv	a0,s1
    80003a66:	00001097          	auipc	ra,0x1
    80003a6a:	e6e080e7          	jalr	-402(ra) # 800048d4 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003a6e:	08848493          	addi	s1,s1,136
    80003a72:	ff3498e3          	bne	s1,s3,80003a62 <iinit+0x3e>
}
    80003a76:	70a2                	ld	ra,40(sp)
    80003a78:	7402                	ld	s0,32(sp)
    80003a7a:	64e2                	ld	s1,24(sp)
    80003a7c:	6942                	ld	s2,16(sp)
    80003a7e:	69a2                	ld	s3,8(sp)
    80003a80:	6145                	addi	sp,sp,48
    80003a82:	8082                	ret

0000000080003a84 <ialloc>:
{
    80003a84:	7139                	addi	sp,sp,-64
    80003a86:	fc06                	sd	ra,56(sp)
    80003a88:	f822                	sd	s0,48(sp)
    80003a8a:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003a8c:	0001b717          	auipc	a4,0x1b
    80003a90:	73872703          	lw	a4,1848(a4) # 8001f1c4 <sb+0xc>
    80003a94:	4785                	li	a5,1
    80003a96:	06e7f463          	bgeu	a5,a4,80003afe <ialloc+0x7a>
    80003a9a:	f426                	sd	s1,40(sp)
    80003a9c:	f04a                	sd	s2,32(sp)
    80003a9e:	ec4e                	sd	s3,24(sp)
    80003aa0:	e852                	sd	s4,16(sp)
    80003aa2:	e456                	sd	s5,8(sp)
    80003aa4:	e05a                	sd	s6,0(sp)
    80003aa6:	8aaa                	mv	s5,a0
    80003aa8:	8b2e                	mv	s6,a1
    80003aaa:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80003aac:	0001ba17          	auipc	s4,0x1b
    80003ab0:	70ca0a13          	addi	s4,s4,1804 # 8001f1b8 <sb>
    80003ab4:	00495593          	srli	a1,s2,0x4
    80003ab8:	018a2783          	lw	a5,24(s4)
    80003abc:	9dbd                	addw	a1,a1,a5
    80003abe:	8556                	mv	a0,s5
    80003ac0:	00000097          	auipc	ra,0x0
    80003ac4:	95a080e7          	jalr	-1702(ra) # 8000341a <bread>
    80003ac8:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003aca:	05850993          	addi	s3,a0,88
    80003ace:	00f97793          	andi	a5,s2,15
    80003ad2:	079a                	slli	a5,a5,0x6
    80003ad4:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003ad6:	00099783          	lh	a5,0(s3)
    80003ada:	cf9d                	beqz	a5,80003b18 <ialloc+0x94>
    brelse(bp);
    80003adc:	00000097          	auipc	ra,0x0
    80003ae0:	a6e080e7          	jalr	-1426(ra) # 8000354a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003ae4:	0905                	addi	s2,s2,1
    80003ae6:	00ca2703          	lw	a4,12(s4)
    80003aea:	0009079b          	sext.w	a5,s2
    80003aee:	fce7e3e3          	bltu	a5,a4,80003ab4 <ialloc+0x30>
    80003af2:	74a2                	ld	s1,40(sp)
    80003af4:	7902                	ld	s2,32(sp)
    80003af6:	69e2                	ld	s3,24(sp)
    80003af8:	6a42                	ld	s4,16(sp)
    80003afa:	6aa2                	ld	s5,8(sp)
    80003afc:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003afe:	00005517          	auipc	a0,0x5
    80003b02:	aba50513          	addi	a0,a0,-1350 # 800085b8 <__func__.1+0x5b0>
    80003b06:	ffffd097          	auipc	ra,0xffffd
    80003b0a:	ab6080e7          	jalr	-1354(ra) # 800005bc <printf>
  return 0;
    80003b0e:	4501                	li	a0,0
}
    80003b10:	70e2                	ld	ra,56(sp)
    80003b12:	7442                	ld	s0,48(sp)
    80003b14:	6121                	addi	sp,sp,64
    80003b16:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003b18:	04000613          	li	a2,64
    80003b1c:	4581                	li	a1,0
    80003b1e:	854e                	mv	a0,s3
    80003b20:	ffffd097          	auipc	ra,0xffffd
    80003b24:	2de080e7          	jalr	734(ra) # 80000dfe <memset>
      dip->type = type;
    80003b28:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003b2c:	8526                	mv	a0,s1
    80003b2e:	00001097          	auipc	ra,0x1
    80003b32:	cc2080e7          	jalr	-830(ra) # 800047f0 <log_write>
      brelse(bp);
    80003b36:	8526                	mv	a0,s1
    80003b38:	00000097          	auipc	ra,0x0
    80003b3c:	a12080e7          	jalr	-1518(ra) # 8000354a <brelse>
      return iget(dev, inum);
    80003b40:	0009059b          	sext.w	a1,s2
    80003b44:	8556                	mv	a0,s5
    80003b46:	00000097          	auipc	ra,0x0
    80003b4a:	da2080e7          	jalr	-606(ra) # 800038e8 <iget>
    80003b4e:	74a2                	ld	s1,40(sp)
    80003b50:	7902                	ld	s2,32(sp)
    80003b52:	69e2                	ld	s3,24(sp)
    80003b54:	6a42                	ld	s4,16(sp)
    80003b56:	6aa2                	ld	s5,8(sp)
    80003b58:	6b02                	ld	s6,0(sp)
    80003b5a:	bf5d                	j	80003b10 <ialloc+0x8c>

0000000080003b5c <iupdate>:
{
    80003b5c:	1101                	addi	sp,sp,-32
    80003b5e:	ec06                	sd	ra,24(sp)
    80003b60:	e822                	sd	s0,16(sp)
    80003b62:	e426                	sd	s1,8(sp)
    80003b64:	e04a                	sd	s2,0(sp)
    80003b66:	1000                	addi	s0,sp,32
    80003b68:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003b6a:	415c                	lw	a5,4(a0)
    80003b6c:	0047d79b          	srliw	a5,a5,0x4
    80003b70:	0001b597          	auipc	a1,0x1b
    80003b74:	6605a583          	lw	a1,1632(a1) # 8001f1d0 <sb+0x18>
    80003b78:	9dbd                	addw	a1,a1,a5
    80003b7a:	4108                	lw	a0,0(a0)
    80003b7c:	00000097          	auipc	ra,0x0
    80003b80:	89e080e7          	jalr	-1890(ra) # 8000341a <bread>
    80003b84:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003b86:	05850793          	addi	a5,a0,88
    80003b8a:	40d8                	lw	a4,4(s1)
    80003b8c:	8b3d                	andi	a4,a4,15
    80003b8e:	071a                	slli	a4,a4,0x6
    80003b90:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003b92:	04449703          	lh	a4,68(s1)
    80003b96:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003b9a:	04649703          	lh	a4,70(s1)
    80003b9e:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003ba2:	04849703          	lh	a4,72(s1)
    80003ba6:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003baa:	04a49703          	lh	a4,74(s1)
    80003bae:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003bb2:	44f8                	lw	a4,76(s1)
    80003bb4:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003bb6:	03400613          	li	a2,52
    80003bba:	05048593          	addi	a1,s1,80
    80003bbe:	00c78513          	addi	a0,a5,12
    80003bc2:	ffffd097          	auipc	ra,0xffffd
    80003bc6:	2a0080e7          	jalr	672(ra) # 80000e62 <memmove>
  log_write(bp);
    80003bca:	854a                	mv	a0,s2
    80003bcc:	00001097          	auipc	ra,0x1
    80003bd0:	c24080e7          	jalr	-988(ra) # 800047f0 <log_write>
  brelse(bp);
    80003bd4:	854a                	mv	a0,s2
    80003bd6:	00000097          	auipc	ra,0x0
    80003bda:	974080e7          	jalr	-1676(ra) # 8000354a <brelse>
}
    80003bde:	60e2                	ld	ra,24(sp)
    80003be0:	6442                	ld	s0,16(sp)
    80003be2:	64a2                	ld	s1,8(sp)
    80003be4:	6902                	ld	s2,0(sp)
    80003be6:	6105                	addi	sp,sp,32
    80003be8:	8082                	ret

0000000080003bea <idup>:
{
    80003bea:	1101                	addi	sp,sp,-32
    80003bec:	ec06                	sd	ra,24(sp)
    80003bee:	e822                	sd	s0,16(sp)
    80003bf0:	e426                	sd	s1,8(sp)
    80003bf2:	1000                	addi	s0,sp,32
    80003bf4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003bf6:	0001b517          	auipc	a0,0x1b
    80003bfa:	5e250513          	addi	a0,a0,1506 # 8001f1d8 <itable>
    80003bfe:	ffffd097          	auipc	ra,0xffffd
    80003c02:	108080e7          	jalr	264(ra) # 80000d06 <acquire>
  ip->ref++;
    80003c06:	449c                	lw	a5,8(s1)
    80003c08:	2785                	addiw	a5,a5,1
    80003c0a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003c0c:	0001b517          	auipc	a0,0x1b
    80003c10:	5cc50513          	addi	a0,a0,1484 # 8001f1d8 <itable>
    80003c14:	ffffd097          	auipc	ra,0xffffd
    80003c18:	1a2080e7          	jalr	418(ra) # 80000db6 <release>
}
    80003c1c:	8526                	mv	a0,s1
    80003c1e:	60e2                	ld	ra,24(sp)
    80003c20:	6442                	ld	s0,16(sp)
    80003c22:	64a2                	ld	s1,8(sp)
    80003c24:	6105                	addi	sp,sp,32
    80003c26:	8082                	ret

0000000080003c28 <ilock>:
{
    80003c28:	1101                	addi	sp,sp,-32
    80003c2a:	ec06                	sd	ra,24(sp)
    80003c2c:	e822                	sd	s0,16(sp)
    80003c2e:	e426                	sd	s1,8(sp)
    80003c30:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003c32:	c10d                	beqz	a0,80003c54 <ilock+0x2c>
    80003c34:	84aa                	mv	s1,a0
    80003c36:	451c                	lw	a5,8(a0)
    80003c38:	00f05e63          	blez	a5,80003c54 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80003c3c:	0541                	addi	a0,a0,16
    80003c3e:	00001097          	auipc	ra,0x1
    80003c42:	cd0080e7          	jalr	-816(ra) # 8000490e <acquiresleep>
  if(ip->valid == 0){
    80003c46:	40bc                	lw	a5,64(s1)
    80003c48:	cf99                	beqz	a5,80003c66 <ilock+0x3e>
}
    80003c4a:	60e2                	ld	ra,24(sp)
    80003c4c:	6442                	ld	s0,16(sp)
    80003c4e:	64a2                	ld	s1,8(sp)
    80003c50:	6105                	addi	sp,sp,32
    80003c52:	8082                	ret
    80003c54:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003c56:	00005517          	auipc	a0,0x5
    80003c5a:	97a50513          	addi	a0,a0,-1670 # 800085d0 <__func__.1+0x5c8>
    80003c5e:	ffffd097          	auipc	ra,0xffffd
    80003c62:	902080e7          	jalr	-1790(ra) # 80000560 <panic>
    80003c66:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003c68:	40dc                	lw	a5,4(s1)
    80003c6a:	0047d79b          	srliw	a5,a5,0x4
    80003c6e:	0001b597          	auipc	a1,0x1b
    80003c72:	5625a583          	lw	a1,1378(a1) # 8001f1d0 <sb+0x18>
    80003c76:	9dbd                	addw	a1,a1,a5
    80003c78:	4088                	lw	a0,0(s1)
    80003c7a:	fffff097          	auipc	ra,0xfffff
    80003c7e:	7a0080e7          	jalr	1952(ra) # 8000341a <bread>
    80003c82:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003c84:	05850593          	addi	a1,a0,88
    80003c88:	40dc                	lw	a5,4(s1)
    80003c8a:	8bbd                	andi	a5,a5,15
    80003c8c:	079a                	slli	a5,a5,0x6
    80003c8e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003c90:	00059783          	lh	a5,0(a1)
    80003c94:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003c98:	00259783          	lh	a5,2(a1)
    80003c9c:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003ca0:	00459783          	lh	a5,4(a1)
    80003ca4:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003ca8:	00659783          	lh	a5,6(a1)
    80003cac:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003cb0:	459c                	lw	a5,8(a1)
    80003cb2:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003cb4:	03400613          	li	a2,52
    80003cb8:	05b1                	addi	a1,a1,12
    80003cba:	05048513          	addi	a0,s1,80
    80003cbe:	ffffd097          	auipc	ra,0xffffd
    80003cc2:	1a4080e7          	jalr	420(ra) # 80000e62 <memmove>
    brelse(bp);
    80003cc6:	854a                	mv	a0,s2
    80003cc8:	00000097          	auipc	ra,0x0
    80003ccc:	882080e7          	jalr	-1918(ra) # 8000354a <brelse>
    ip->valid = 1;
    80003cd0:	4785                	li	a5,1
    80003cd2:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003cd4:	04449783          	lh	a5,68(s1)
    80003cd8:	c399                	beqz	a5,80003cde <ilock+0xb6>
    80003cda:	6902                	ld	s2,0(sp)
    80003cdc:	b7bd                	j	80003c4a <ilock+0x22>
      panic("ilock: no type");
    80003cde:	00005517          	auipc	a0,0x5
    80003ce2:	8fa50513          	addi	a0,a0,-1798 # 800085d8 <__func__.1+0x5d0>
    80003ce6:	ffffd097          	auipc	ra,0xffffd
    80003cea:	87a080e7          	jalr	-1926(ra) # 80000560 <panic>

0000000080003cee <iunlock>:
{
    80003cee:	1101                	addi	sp,sp,-32
    80003cf0:	ec06                	sd	ra,24(sp)
    80003cf2:	e822                	sd	s0,16(sp)
    80003cf4:	e426                	sd	s1,8(sp)
    80003cf6:	e04a                	sd	s2,0(sp)
    80003cf8:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003cfa:	c905                	beqz	a0,80003d2a <iunlock+0x3c>
    80003cfc:	84aa                	mv	s1,a0
    80003cfe:	01050913          	addi	s2,a0,16
    80003d02:	854a                	mv	a0,s2
    80003d04:	00001097          	auipc	ra,0x1
    80003d08:	ca4080e7          	jalr	-860(ra) # 800049a8 <holdingsleep>
    80003d0c:	cd19                	beqz	a0,80003d2a <iunlock+0x3c>
    80003d0e:	449c                	lw	a5,8(s1)
    80003d10:	00f05d63          	blez	a5,80003d2a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003d14:	854a                	mv	a0,s2
    80003d16:	00001097          	auipc	ra,0x1
    80003d1a:	c4e080e7          	jalr	-946(ra) # 80004964 <releasesleep>
}
    80003d1e:	60e2                	ld	ra,24(sp)
    80003d20:	6442                	ld	s0,16(sp)
    80003d22:	64a2                	ld	s1,8(sp)
    80003d24:	6902                	ld	s2,0(sp)
    80003d26:	6105                	addi	sp,sp,32
    80003d28:	8082                	ret
    panic("iunlock");
    80003d2a:	00005517          	auipc	a0,0x5
    80003d2e:	8be50513          	addi	a0,a0,-1858 # 800085e8 <__func__.1+0x5e0>
    80003d32:	ffffd097          	auipc	ra,0xffffd
    80003d36:	82e080e7          	jalr	-2002(ra) # 80000560 <panic>

0000000080003d3a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003d3a:	7179                	addi	sp,sp,-48
    80003d3c:	f406                	sd	ra,40(sp)
    80003d3e:	f022                	sd	s0,32(sp)
    80003d40:	ec26                	sd	s1,24(sp)
    80003d42:	e84a                	sd	s2,16(sp)
    80003d44:	e44e                	sd	s3,8(sp)
    80003d46:	1800                	addi	s0,sp,48
    80003d48:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003d4a:	05050493          	addi	s1,a0,80
    80003d4e:	08050913          	addi	s2,a0,128
    80003d52:	a021                	j	80003d5a <itrunc+0x20>
    80003d54:	0491                	addi	s1,s1,4
    80003d56:	01248d63          	beq	s1,s2,80003d70 <itrunc+0x36>
    if(ip->addrs[i]){
    80003d5a:	408c                	lw	a1,0(s1)
    80003d5c:	dde5                	beqz	a1,80003d54 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003d5e:	0009a503          	lw	a0,0(s3)
    80003d62:	00000097          	auipc	ra,0x0
    80003d66:	8f8080e7          	jalr	-1800(ra) # 8000365a <bfree>
      ip->addrs[i] = 0;
    80003d6a:	0004a023          	sw	zero,0(s1)
    80003d6e:	b7dd                	j	80003d54 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003d70:	0809a583          	lw	a1,128(s3)
    80003d74:	ed99                	bnez	a1,80003d92 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003d76:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003d7a:	854e                	mv	a0,s3
    80003d7c:	00000097          	auipc	ra,0x0
    80003d80:	de0080e7          	jalr	-544(ra) # 80003b5c <iupdate>
}
    80003d84:	70a2                	ld	ra,40(sp)
    80003d86:	7402                	ld	s0,32(sp)
    80003d88:	64e2                	ld	s1,24(sp)
    80003d8a:	6942                	ld	s2,16(sp)
    80003d8c:	69a2                	ld	s3,8(sp)
    80003d8e:	6145                	addi	sp,sp,48
    80003d90:	8082                	ret
    80003d92:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003d94:	0009a503          	lw	a0,0(s3)
    80003d98:	fffff097          	auipc	ra,0xfffff
    80003d9c:	682080e7          	jalr	1666(ra) # 8000341a <bread>
    80003da0:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003da2:	05850493          	addi	s1,a0,88
    80003da6:	45850913          	addi	s2,a0,1112
    80003daa:	a021                	j	80003db2 <itrunc+0x78>
    80003dac:	0491                	addi	s1,s1,4
    80003dae:	01248b63          	beq	s1,s2,80003dc4 <itrunc+0x8a>
      if(a[j])
    80003db2:	408c                	lw	a1,0(s1)
    80003db4:	dde5                	beqz	a1,80003dac <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80003db6:	0009a503          	lw	a0,0(s3)
    80003dba:	00000097          	auipc	ra,0x0
    80003dbe:	8a0080e7          	jalr	-1888(ra) # 8000365a <bfree>
    80003dc2:	b7ed                	j	80003dac <itrunc+0x72>
    brelse(bp);
    80003dc4:	8552                	mv	a0,s4
    80003dc6:	fffff097          	auipc	ra,0xfffff
    80003dca:	784080e7          	jalr	1924(ra) # 8000354a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003dce:	0809a583          	lw	a1,128(s3)
    80003dd2:	0009a503          	lw	a0,0(s3)
    80003dd6:	00000097          	auipc	ra,0x0
    80003dda:	884080e7          	jalr	-1916(ra) # 8000365a <bfree>
    ip->addrs[NDIRECT] = 0;
    80003dde:	0809a023          	sw	zero,128(s3)
    80003de2:	6a02                	ld	s4,0(sp)
    80003de4:	bf49                	j	80003d76 <itrunc+0x3c>

0000000080003de6 <iput>:
{
    80003de6:	1101                	addi	sp,sp,-32
    80003de8:	ec06                	sd	ra,24(sp)
    80003dea:	e822                	sd	s0,16(sp)
    80003dec:	e426                	sd	s1,8(sp)
    80003dee:	1000                	addi	s0,sp,32
    80003df0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003df2:	0001b517          	auipc	a0,0x1b
    80003df6:	3e650513          	addi	a0,a0,998 # 8001f1d8 <itable>
    80003dfa:	ffffd097          	auipc	ra,0xffffd
    80003dfe:	f0c080e7          	jalr	-244(ra) # 80000d06 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003e02:	4498                	lw	a4,8(s1)
    80003e04:	4785                	li	a5,1
    80003e06:	02f70263          	beq	a4,a5,80003e2a <iput+0x44>
  ip->ref--;
    80003e0a:	449c                	lw	a5,8(s1)
    80003e0c:	37fd                	addiw	a5,a5,-1
    80003e0e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003e10:	0001b517          	auipc	a0,0x1b
    80003e14:	3c850513          	addi	a0,a0,968 # 8001f1d8 <itable>
    80003e18:	ffffd097          	auipc	ra,0xffffd
    80003e1c:	f9e080e7          	jalr	-98(ra) # 80000db6 <release>
}
    80003e20:	60e2                	ld	ra,24(sp)
    80003e22:	6442                	ld	s0,16(sp)
    80003e24:	64a2                	ld	s1,8(sp)
    80003e26:	6105                	addi	sp,sp,32
    80003e28:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003e2a:	40bc                	lw	a5,64(s1)
    80003e2c:	dff9                	beqz	a5,80003e0a <iput+0x24>
    80003e2e:	04a49783          	lh	a5,74(s1)
    80003e32:	ffe1                	bnez	a5,80003e0a <iput+0x24>
    80003e34:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003e36:	01048913          	addi	s2,s1,16
    80003e3a:	854a                	mv	a0,s2
    80003e3c:	00001097          	auipc	ra,0x1
    80003e40:	ad2080e7          	jalr	-1326(ra) # 8000490e <acquiresleep>
    release(&itable.lock);
    80003e44:	0001b517          	auipc	a0,0x1b
    80003e48:	39450513          	addi	a0,a0,916 # 8001f1d8 <itable>
    80003e4c:	ffffd097          	auipc	ra,0xffffd
    80003e50:	f6a080e7          	jalr	-150(ra) # 80000db6 <release>
    itrunc(ip);
    80003e54:	8526                	mv	a0,s1
    80003e56:	00000097          	auipc	ra,0x0
    80003e5a:	ee4080e7          	jalr	-284(ra) # 80003d3a <itrunc>
    ip->type = 0;
    80003e5e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003e62:	8526                	mv	a0,s1
    80003e64:	00000097          	auipc	ra,0x0
    80003e68:	cf8080e7          	jalr	-776(ra) # 80003b5c <iupdate>
    ip->valid = 0;
    80003e6c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003e70:	854a                	mv	a0,s2
    80003e72:	00001097          	auipc	ra,0x1
    80003e76:	af2080e7          	jalr	-1294(ra) # 80004964 <releasesleep>
    acquire(&itable.lock);
    80003e7a:	0001b517          	auipc	a0,0x1b
    80003e7e:	35e50513          	addi	a0,a0,862 # 8001f1d8 <itable>
    80003e82:	ffffd097          	auipc	ra,0xffffd
    80003e86:	e84080e7          	jalr	-380(ra) # 80000d06 <acquire>
    80003e8a:	6902                	ld	s2,0(sp)
    80003e8c:	bfbd                	j	80003e0a <iput+0x24>

0000000080003e8e <iunlockput>:
{
    80003e8e:	1101                	addi	sp,sp,-32
    80003e90:	ec06                	sd	ra,24(sp)
    80003e92:	e822                	sd	s0,16(sp)
    80003e94:	e426                	sd	s1,8(sp)
    80003e96:	1000                	addi	s0,sp,32
    80003e98:	84aa                	mv	s1,a0
  iunlock(ip);
    80003e9a:	00000097          	auipc	ra,0x0
    80003e9e:	e54080e7          	jalr	-428(ra) # 80003cee <iunlock>
  iput(ip);
    80003ea2:	8526                	mv	a0,s1
    80003ea4:	00000097          	auipc	ra,0x0
    80003ea8:	f42080e7          	jalr	-190(ra) # 80003de6 <iput>
}
    80003eac:	60e2                	ld	ra,24(sp)
    80003eae:	6442                	ld	s0,16(sp)
    80003eb0:	64a2                	ld	s1,8(sp)
    80003eb2:	6105                	addi	sp,sp,32
    80003eb4:	8082                	ret

0000000080003eb6 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003eb6:	1141                	addi	sp,sp,-16
    80003eb8:	e406                	sd	ra,8(sp)
    80003eba:	e022                	sd	s0,0(sp)
    80003ebc:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003ebe:	411c                	lw	a5,0(a0)
    80003ec0:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003ec2:	415c                	lw	a5,4(a0)
    80003ec4:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003ec6:	04451783          	lh	a5,68(a0)
    80003eca:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003ece:	04a51783          	lh	a5,74(a0)
    80003ed2:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003ed6:	04c56783          	lwu	a5,76(a0)
    80003eda:	e99c                	sd	a5,16(a1)
}
    80003edc:	60a2                	ld	ra,8(sp)
    80003ede:	6402                	ld	s0,0(sp)
    80003ee0:	0141                	addi	sp,sp,16
    80003ee2:	8082                	ret

0000000080003ee4 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003ee4:	457c                	lw	a5,76(a0)
    80003ee6:	10d7e063          	bltu	a5,a3,80003fe6 <readi+0x102>
{
    80003eea:	7159                	addi	sp,sp,-112
    80003eec:	f486                	sd	ra,104(sp)
    80003eee:	f0a2                	sd	s0,96(sp)
    80003ef0:	eca6                	sd	s1,88(sp)
    80003ef2:	e0d2                	sd	s4,64(sp)
    80003ef4:	fc56                	sd	s5,56(sp)
    80003ef6:	f85a                	sd	s6,48(sp)
    80003ef8:	f45e                	sd	s7,40(sp)
    80003efa:	1880                	addi	s0,sp,112
    80003efc:	8b2a                	mv	s6,a0
    80003efe:	8bae                	mv	s7,a1
    80003f00:	8a32                	mv	s4,a2
    80003f02:	84b6                	mv	s1,a3
    80003f04:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003f06:	9f35                	addw	a4,a4,a3
    return 0;
    80003f08:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003f0a:	0cd76563          	bltu	a4,a3,80003fd4 <readi+0xf0>
    80003f0e:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003f10:	00e7f463          	bgeu	a5,a4,80003f18 <readi+0x34>
    n = ip->size - off;
    80003f14:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003f18:	0a0a8563          	beqz	s5,80003fc2 <readi+0xde>
    80003f1c:	e8ca                	sd	s2,80(sp)
    80003f1e:	f062                	sd	s8,32(sp)
    80003f20:	ec66                	sd	s9,24(sp)
    80003f22:	e86a                	sd	s10,16(sp)
    80003f24:	e46e                	sd	s11,8(sp)
    80003f26:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003f28:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003f2c:	5c7d                	li	s8,-1
    80003f2e:	a82d                	j	80003f68 <readi+0x84>
    80003f30:	020d1d93          	slli	s11,s10,0x20
    80003f34:	020ddd93          	srli	s11,s11,0x20
    80003f38:	05890613          	addi	a2,s2,88
    80003f3c:	86ee                	mv	a3,s11
    80003f3e:	963e                	add	a2,a2,a5
    80003f40:	85d2                	mv	a1,s4
    80003f42:	855e                	mv	a0,s7
    80003f44:	fffff097          	auipc	ra,0xfffff
    80003f48:	8d2080e7          	jalr	-1838(ra) # 80002816 <either_copyout>
    80003f4c:	05850963          	beq	a0,s8,80003f9e <readi+0xba>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003f50:	854a                	mv	a0,s2
    80003f52:	fffff097          	auipc	ra,0xfffff
    80003f56:	5f8080e7          	jalr	1528(ra) # 8000354a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003f5a:	013d09bb          	addw	s3,s10,s3
    80003f5e:	009d04bb          	addw	s1,s10,s1
    80003f62:	9a6e                	add	s4,s4,s11
    80003f64:	0559f963          	bgeu	s3,s5,80003fb6 <readi+0xd2>
    uint addr = bmap(ip, off/BSIZE);
    80003f68:	00a4d59b          	srliw	a1,s1,0xa
    80003f6c:	855a                	mv	a0,s6
    80003f6e:	00000097          	auipc	ra,0x0
    80003f72:	89e080e7          	jalr	-1890(ra) # 8000380c <bmap>
    80003f76:	85aa                	mv	a1,a0
    if(addr == 0)
    80003f78:	c539                	beqz	a0,80003fc6 <readi+0xe2>
    bp = bread(ip->dev, addr);
    80003f7a:	000b2503          	lw	a0,0(s6)
    80003f7e:	fffff097          	auipc	ra,0xfffff
    80003f82:	49c080e7          	jalr	1180(ra) # 8000341a <bread>
    80003f86:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003f88:	3ff4f793          	andi	a5,s1,1023
    80003f8c:	40fc873b          	subw	a4,s9,a5
    80003f90:	413a86bb          	subw	a3,s5,s3
    80003f94:	8d3a                	mv	s10,a4
    80003f96:	f8e6fde3          	bgeu	a3,a4,80003f30 <readi+0x4c>
    80003f9a:	8d36                	mv	s10,a3
    80003f9c:	bf51                	j	80003f30 <readi+0x4c>
      brelse(bp);
    80003f9e:	854a                	mv	a0,s2
    80003fa0:	fffff097          	auipc	ra,0xfffff
    80003fa4:	5aa080e7          	jalr	1450(ra) # 8000354a <brelse>
      tot = -1;
    80003fa8:	59fd                	li	s3,-1
      break;
    80003faa:	6946                	ld	s2,80(sp)
    80003fac:	7c02                	ld	s8,32(sp)
    80003fae:	6ce2                	ld	s9,24(sp)
    80003fb0:	6d42                	ld	s10,16(sp)
    80003fb2:	6da2                	ld	s11,8(sp)
    80003fb4:	a831                	j	80003fd0 <readi+0xec>
    80003fb6:	6946                	ld	s2,80(sp)
    80003fb8:	7c02                	ld	s8,32(sp)
    80003fba:	6ce2                	ld	s9,24(sp)
    80003fbc:	6d42                	ld	s10,16(sp)
    80003fbe:	6da2                	ld	s11,8(sp)
    80003fc0:	a801                	j	80003fd0 <readi+0xec>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003fc2:	89d6                	mv	s3,s5
    80003fc4:	a031                	j	80003fd0 <readi+0xec>
    80003fc6:	6946                	ld	s2,80(sp)
    80003fc8:	7c02                	ld	s8,32(sp)
    80003fca:	6ce2                	ld	s9,24(sp)
    80003fcc:	6d42                	ld	s10,16(sp)
    80003fce:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003fd0:	854e                	mv	a0,s3
    80003fd2:	69a6                	ld	s3,72(sp)
}
    80003fd4:	70a6                	ld	ra,104(sp)
    80003fd6:	7406                	ld	s0,96(sp)
    80003fd8:	64e6                	ld	s1,88(sp)
    80003fda:	6a06                	ld	s4,64(sp)
    80003fdc:	7ae2                	ld	s5,56(sp)
    80003fde:	7b42                	ld	s6,48(sp)
    80003fe0:	7ba2                	ld	s7,40(sp)
    80003fe2:	6165                	addi	sp,sp,112
    80003fe4:	8082                	ret
    return 0;
    80003fe6:	4501                	li	a0,0
}
    80003fe8:	8082                	ret

0000000080003fea <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003fea:	457c                	lw	a5,76(a0)
    80003fec:	10d7e963          	bltu	a5,a3,800040fe <writei+0x114>
{
    80003ff0:	7159                	addi	sp,sp,-112
    80003ff2:	f486                	sd	ra,104(sp)
    80003ff4:	f0a2                	sd	s0,96(sp)
    80003ff6:	e8ca                	sd	s2,80(sp)
    80003ff8:	e0d2                	sd	s4,64(sp)
    80003ffa:	fc56                	sd	s5,56(sp)
    80003ffc:	f85a                	sd	s6,48(sp)
    80003ffe:	f45e                	sd	s7,40(sp)
    80004000:	1880                	addi	s0,sp,112
    80004002:	8aaa                	mv	s5,a0
    80004004:	8bae                	mv	s7,a1
    80004006:	8a32                	mv	s4,a2
    80004008:	8936                	mv	s2,a3
    8000400a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000400c:	00e687bb          	addw	a5,a3,a4
    80004010:	0ed7e963          	bltu	a5,a3,80004102 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80004014:	00043737          	lui	a4,0x43
    80004018:	0ef76763          	bltu	a4,a5,80004106 <writei+0x11c>
    8000401c:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000401e:	0c0b0863          	beqz	s6,800040ee <writei+0x104>
    80004022:	eca6                	sd	s1,88(sp)
    80004024:	f062                	sd	s8,32(sp)
    80004026:	ec66                	sd	s9,24(sp)
    80004028:	e86a                	sd	s10,16(sp)
    8000402a:	e46e                	sd	s11,8(sp)
    8000402c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000402e:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80004032:	5c7d                	li	s8,-1
    80004034:	a091                	j	80004078 <writei+0x8e>
    80004036:	020d1d93          	slli	s11,s10,0x20
    8000403a:	020ddd93          	srli	s11,s11,0x20
    8000403e:	05848513          	addi	a0,s1,88
    80004042:	86ee                	mv	a3,s11
    80004044:	8652                	mv	a2,s4
    80004046:	85de                	mv	a1,s7
    80004048:	953e                	add	a0,a0,a5
    8000404a:	fffff097          	auipc	ra,0xfffff
    8000404e:	822080e7          	jalr	-2014(ra) # 8000286c <either_copyin>
    80004052:	05850e63          	beq	a0,s8,800040ae <writei+0xc4>
      brelse(bp);
      break;
    }
    log_write(bp);
    80004056:	8526                	mv	a0,s1
    80004058:	00000097          	auipc	ra,0x0
    8000405c:	798080e7          	jalr	1944(ra) # 800047f0 <log_write>
    brelse(bp);
    80004060:	8526                	mv	a0,s1
    80004062:	fffff097          	auipc	ra,0xfffff
    80004066:	4e8080e7          	jalr	1256(ra) # 8000354a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000406a:	013d09bb          	addw	s3,s10,s3
    8000406e:	012d093b          	addw	s2,s10,s2
    80004072:	9a6e                	add	s4,s4,s11
    80004074:	0569f263          	bgeu	s3,s6,800040b8 <writei+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80004078:	00a9559b          	srliw	a1,s2,0xa
    8000407c:	8556                	mv	a0,s5
    8000407e:	fffff097          	auipc	ra,0xfffff
    80004082:	78e080e7          	jalr	1934(ra) # 8000380c <bmap>
    80004086:	85aa                	mv	a1,a0
    if(addr == 0)
    80004088:	c905                	beqz	a0,800040b8 <writei+0xce>
    bp = bread(ip->dev, addr);
    8000408a:	000aa503          	lw	a0,0(s5)
    8000408e:	fffff097          	auipc	ra,0xfffff
    80004092:	38c080e7          	jalr	908(ra) # 8000341a <bread>
    80004096:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004098:	3ff97793          	andi	a5,s2,1023
    8000409c:	40fc873b          	subw	a4,s9,a5
    800040a0:	413b06bb          	subw	a3,s6,s3
    800040a4:	8d3a                	mv	s10,a4
    800040a6:	f8e6f8e3          	bgeu	a3,a4,80004036 <writei+0x4c>
    800040aa:	8d36                	mv	s10,a3
    800040ac:	b769                	j	80004036 <writei+0x4c>
      brelse(bp);
    800040ae:	8526                	mv	a0,s1
    800040b0:	fffff097          	auipc	ra,0xfffff
    800040b4:	49a080e7          	jalr	1178(ra) # 8000354a <brelse>
  }

  if(off > ip->size)
    800040b8:	04caa783          	lw	a5,76(s5)
    800040bc:	0327fb63          	bgeu	a5,s2,800040f2 <writei+0x108>
    ip->size = off;
    800040c0:	052aa623          	sw	s2,76(s5)
    800040c4:	64e6                	ld	s1,88(sp)
    800040c6:	7c02                	ld	s8,32(sp)
    800040c8:	6ce2                	ld	s9,24(sp)
    800040ca:	6d42                	ld	s10,16(sp)
    800040cc:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800040ce:	8556                	mv	a0,s5
    800040d0:	00000097          	auipc	ra,0x0
    800040d4:	a8c080e7          	jalr	-1396(ra) # 80003b5c <iupdate>

  return tot;
    800040d8:	854e                	mv	a0,s3
    800040da:	69a6                	ld	s3,72(sp)
}
    800040dc:	70a6                	ld	ra,104(sp)
    800040de:	7406                	ld	s0,96(sp)
    800040e0:	6946                	ld	s2,80(sp)
    800040e2:	6a06                	ld	s4,64(sp)
    800040e4:	7ae2                	ld	s5,56(sp)
    800040e6:	7b42                	ld	s6,48(sp)
    800040e8:	7ba2                	ld	s7,40(sp)
    800040ea:	6165                	addi	sp,sp,112
    800040ec:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800040ee:	89da                	mv	s3,s6
    800040f0:	bff9                	j	800040ce <writei+0xe4>
    800040f2:	64e6                	ld	s1,88(sp)
    800040f4:	7c02                	ld	s8,32(sp)
    800040f6:	6ce2                	ld	s9,24(sp)
    800040f8:	6d42                	ld	s10,16(sp)
    800040fa:	6da2                	ld	s11,8(sp)
    800040fc:	bfc9                	j	800040ce <writei+0xe4>
    return -1;
    800040fe:	557d                	li	a0,-1
}
    80004100:	8082                	ret
    return -1;
    80004102:	557d                	li	a0,-1
    80004104:	bfe1                	j	800040dc <writei+0xf2>
    return -1;
    80004106:	557d                	li	a0,-1
    80004108:	bfd1                	j	800040dc <writei+0xf2>

000000008000410a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000410a:	1141                	addi	sp,sp,-16
    8000410c:	e406                	sd	ra,8(sp)
    8000410e:	e022                	sd	s0,0(sp)
    80004110:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80004112:	4639                	li	a2,14
    80004114:	ffffd097          	auipc	ra,0xffffd
    80004118:	dc6080e7          	jalr	-570(ra) # 80000eda <strncmp>
}
    8000411c:	60a2                	ld	ra,8(sp)
    8000411e:	6402                	ld	s0,0(sp)
    80004120:	0141                	addi	sp,sp,16
    80004122:	8082                	ret

0000000080004124 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80004124:	711d                	addi	sp,sp,-96
    80004126:	ec86                	sd	ra,88(sp)
    80004128:	e8a2                	sd	s0,80(sp)
    8000412a:	e4a6                	sd	s1,72(sp)
    8000412c:	e0ca                	sd	s2,64(sp)
    8000412e:	fc4e                	sd	s3,56(sp)
    80004130:	f852                	sd	s4,48(sp)
    80004132:	f456                	sd	s5,40(sp)
    80004134:	f05a                	sd	s6,32(sp)
    80004136:	ec5e                	sd	s7,24(sp)
    80004138:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000413a:	04451703          	lh	a4,68(a0)
    8000413e:	4785                	li	a5,1
    80004140:	00f71f63          	bne	a4,a5,8000415e <dirlookup+0x3a>
    80004144:	892a                	mv	s2,a0
    80004146:	8aae                	mv	s5,a1
    80004148:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000414a:	457c                	lw	a5,76(a0)
    8000414c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000414e:	fa040a13          	addi	s4,s0,-96
    80004152:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80004154:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80004158:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000415a:	e79d                	bnez	a5,80004188 <dirlookup+0x64>
    8000415c:	a88d                	j	800041ce <dirlookup+0xaa>
    panic("dirlookup not DIR");
    8000415e:	00004517          	auipc	a0,0x4
    80004162:	49250513          	addi	a0,a0,1170 # 800085f0 <__func__.1+0x5e8>
    80004166:	ffffc097          	auipc	ra,0xffffc
    8000416a:	3fa080e7          	jalr	1018(ra) # 80000560 <panic>
      panic("dirlookup read");
    8000416e:	00004517          	auipc	a0,0x4
    80004172:	49a50513          	addi	a0,a0,1178 # 80008608 <__func__.1+0x600>
    80004176:	ffffc097          	auipc	ra,0xffffc
    8000417a:	3ea080e7          	jalr	1002(ra) # 80000560 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000417e:	24c1                	addiw	s1,s1,16
    80004180:	04c92783          	lw	a5,76(s2)
    80004184:	04f4f463          	bgeu	s1,a5,800041cc <dirlookup+0xa8>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004188:	874e                	mv	a4,s3
    8000418a:	86a6                	mv	a3,s1
    8000418c:	8652                	mv	a2,s4
    8000418e:	4581                	li	a1,0
    80004190:	854a                	mv	a0,s2
    80004192:	00000097          	auipc	ra,0x0
    80004196:	d52080e7          	jalr	-686(ra) # 80003ee4 <readi>
    8000419a:	fd351ae3          	bne	a0,s3,8000416e <dirlookup+0x4a>
    if(de.inum == 0)
    8000419e:	fa045783          	lhu	a5,-96(s0)
    800041a2:	dff1                	beqz	a5,8000417e <dirlookup+0x5a>
    if(namecmp(name, de.name) == 0){
    800041a4:	85da                	mv	a1,s6
    800041a6:	8556                	mv	a0,s5
    800041a8:	00000097          	auipc	ra,0x0
    800041ac:	f62080e7          	jalr	-158(ra) # 8000410a <namecmp>
    800041b0:	f579                	bnez	a0,8000417e <dirlookup+0x5a>
      if(poff)
    800041b2:	000b8463          	beqz	s7,800041ba <dirlookup+0x96>
        *poff = off;
    800041b6:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    800041ba:	fa045583          	lhu	a1,-96(s0)
    800041be:	00092503          	lw	a0,0(s2)
    800041c2:	fffff097          	auipc	ra,0xfffff
    800041c6:	726080e7          	jalr	1830(ra) # 800038e8 <iget>
    800041ca:	a011                	j	800041ce <dirlookup+0xaa>
  return 0;
    800041cc:	4501                	li	a0,0
}
    800041ce:	60e6                	ld	ra,88(sp)
    800041d0:	6446                	ld	s0,80(sp)
    800041d2:	64a6                	ld	s1,72(sp)
    800041d4:	6906                	ld	s2,64(sp)
    800041d6:	79e2                	ld	s3,56(sp)
    800041d8:	7a42                	ld	s4,48(sp)
    800041da:	7aa2                	ld	s5,40(sp)
    800041dc:	7b02                	ld	s6,32(sp)
    800041de:	6be2                	ld	s7,24(sp)
    800041e0:	6125                	addi	sp,sp,96
    800041e2:	8082                	ret

00000000800041e4 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800041e4:	711d                	addi	sp,sp,-96
    800041e6:	ec86                	sd	ra,88(sp)
    800041e8:	e8a2                	sd	s0,80(sp)
    800041ea:	e4a6                	sd	s1,72(sp)
    800041ec:	e0ca                	sd	s2,64(sp)
    800041ee:	fc4e                	sd	s3,56(sp)
    800041f0:	f852                	sd	s4,48(sp)
    800041f2:	f456                	sd	s5,40(sp)
    800041f4:	f05a                	sd	s6,32(sp)
    800041f6:	ec5e                	sd	s7,24(sp)
    800041f8:	e862                	sd	s8,16(sp)
    800041fa:	e466                	sd	s9,8(sp)
    800041fc:	e06a                	sd	s10,0(sp)
    800041fe:	1080                	addi	s0,sp,96
    80004200:	84aa                	mv	s1,a0
    80004202:	8b2e                	mv	s6,a1
    80004204:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80004206:	00054703          	lbu	a4,0(a0)
    8000420a:	02f00793          	li	a5,47
    8000420e:	02f70363          	beq	a4,a5,80004234 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80004212:	ffffe097          	auipc	ra,0xffffe
    80004216:	a4e080e7          	jalr	-1458(ra) # 80001c60 <myproc>
    8000421a:	15053503          	ld	a0,336(a0)
    8000421e:	00000097          	auipc	ra,0x0
    80004222:	9cc080e7          	jalr	-1588(ra) # 80003bea <idup>
    80004226:	8a2a                	mv	s4,a0
  while(*path == '/')
    80004228:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000422c:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    8000422e:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004230:	4b85                	li	s7,1
    80004232:	a87d                	j	800042f0 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80004234:	4585                	li	a1,1
    80004236:	852e                	mv	a0,a1
    80004238:	fffff097          	auipc	ra,0xfffff
    8000423c:	6b0080e7          	jalr	1712(ra) # 800038e8 <iget>
    80004240:	8a2a                	mv	s4,a0
    80004242:	b7dd                	j	80004228 <namex+0x44>
      iunlockput(ip);
    80004244:	8552                	mv	a0,s4
    80004246:	00000097          	auipc	ra,0x0
    8000424a:	c48080e7          	jalr	-952(ra) # 80003e8e <iunlockput>
      return 0;
    8000424e:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80004250:	8552                	mv	a0,s4
    80004252:	60e6                	ld	ra,88(sp)
    80004254:	6446                	ld	s0,80(sp)
    80004256:	64a6                	ld	s1,72(sp)
    80004258:	6906                	ld	s2,64(sp)
    8000425a:	79e2                	ld	s3,56(sp)
    8000425c:	7a42                	ld	s4,48(sp)
    8000425e:	7aa2                	ld	s5,40(sp)
    80004260:	7b02                	ld	s6,32(sp)
    80004262:	6be2                	ld	s7,24(sp)
    80004264:	6c42                	ld	s8,16(sp)
    80004266:	6ca2                	ld	s9,8(sp)
    80004268:	6d02                	ld	s10,0(sp)
    8000426a:	6125                	addi	sp,sp,96
    8000426c:	8082                	ret
      iunlock(ip);
    8000426e:	8552                	mv	a0,s4
    80004270:	00000097          	auipc	ra,0x0
    80004274:	a7e080e7          	jalr	-1410(ra) # 80003cee <iunlock>
      return ip;
    80004278:	bfe1                	j	80004250 <namex+0x6c>
      iunlockput(ip);
    8000427a:	8552                	mv	a0,s4
    8000427c:	00000097          	auipc	ra,0x0
    80004280:	c12080e7          	jalr	-1006(ra) # 80003e8e <iunlockput>
      return 0;
    80004284:	8a4e                	mv	s4,s3
    80004286:	b7e9                	j	80004250 <namex+0x6c>
  len = path - s;
    80004288:	40998633          	sub	a2,s3,s1
    8000428c:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80004290:	09ac5863          	bge	s8,s10,80004320 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80004294:	8666                	mv	a2,s9
    80004296:	85a6                	mv	a1,s1
    80004298:	8556                	mv	a0,s5
    8000429a:	ffffd097          	auipc	ra,0xffffd
    8000429e:	bc8080e7          	jalr	-1080(ra) # 80000e62 <memmove>
    800042a2:	84ce                	mv	s1,s3
  while(*path == '/')
    800042a4:	0004c783          	lbu	a5,0(s1)
    800042a8:	01279763          	bne	a5,s2,800042b6 <namex+0xd2>
    path++;
    800042ac:	0485                	addi	s1,s1,1
  while(*path == '/')
    800042ae:	0004c783          	lbu	a5,0(s1)
    800042b2:	ff278de3          	beq	a5,s2,800042ac <namex+0xc8>
    ilock(ip);
    800042b6:	8552                	mv	a0,s4
    800042b8:	00000097          	auipc	ra,0x0
    800042bc:	970080e7          	jalr	-1680(ra) # 80003c28 <ilock>
    if(ip->type != T_DIR){
    800042c0:	044a1783          	lh	a5,68(s4)
    800042c4:	f97790e3          	bne	a5,s7,80004244 <namex+0x60>
    if(nameiparent && *path == '\0'){
    800042c8:	000b0563          	beqz	s6,800042d2 <namex+0xee>
    800042cc:	0004c783          	lbu	a5,0(s1)
    800042d0:	dfd9                	beqz	a5,8000426e <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    800042d2:	4601                	li	a2,0
    800042d4:	85d6                	mv	a1,s5
    800042d6:	8552                	mv	a0,s4
    800042d8:	00000097          	auipc	ra,0x0
    800042dc:	e4c080e7          	jalr	-436(ra) # 80004124 <dirlookup>
    800042e0:	89aa                	mv	s3,a0
    800042e2:	dd41                	beqz	a0,8000427a <namex+0x96>
    iunlockput(ip);
    800042e4:	8552                	mv	a0,s4
    800042e6:	00000097          	auipc	ra,0x0
    800042ea:	ba8080e7          	jalr	-1112(ra) # 80003e8e <iunlockput>
    ip = next;
    800042ee:	8a4e                	mv	s4,s3
  while(*path == '/')
    800042f0:	0004c783          	lbu	a5,0(s1)
    800042f4:	01279763          	bne	a5,s2,80004302 <namex+0x11e>
    path++;
    800042f8:	0485                	addi	s1,s1,1
  while(*path == '/')
    800042fa:	0004c783          	lbu	a5,0(s1)
    800042fe:	ff278de3          	beq	a5,s2,800042f8 <namex+0x114>
  if(*path == 0)
    80004302:	cb9d                	beqz	a5,80004338 <namex+0x154>
  while(*path != '/' && *path != 0)
    80004304:	0004c783          	lbu	a5,0(s1)
    80004308:	89a6                	mv	s3,s1
  len = path - s;
    8000430a:	4d01                	li	s10,0
    8000430c:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    8000430e:	01278963          	beq	a5,s2,80004320 <namex+0x13c>
    80004312:	dbbd                	beqz	a5,80004288 <namex+0xa4>
    path++;
    80004314:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80004316:	0009c783          	lbu	a5,0(s3)
    8000431a:	ff279ce3          	bne	a5,s2,80004312 <namex+0x12e>
    8000431e:	b7ad                	j	80004288 <namex+0xa4>
    memmove(name, s, len);
    80004320:	2601                	sext.w	a2,a2
    80004322:	85a6                	mv	a1,s1
    80004324:	8556                	mv	a0,s5
    80004326:	ffffd097          	auipc	ra,0xffffd
    8000432a:	b3c080e7          	jalr	-1220(ra) # 80000e62 <memmove>
    name[len] = 0;
    8000432e:	9d56                	add	s10,s10,s5
    80004330:	000d0023          	sb	zero,0(s10)
    80004334:	84ce                	mv	s1,s3
    80004336:	b7bd                	j	800042a4 <namex+0xc0>
  if(nameiparent){
    80004338:	f00b0ce3          	beqz	s6,80004250 <namex+0x6c>
    iput(ip);
    8000433c:	8552                	mv	a0,s4
    8000433e:	00000097          	auipc	ra,0x0
    80004342:	aa8080e7          	jalr	-1368(ra) # 80003de6 <iput>
    return 0;
    80004346:	4a01                	li	s4,0
    80004348:	b721                	j	80004250 <namex+0x6c>

000000008000434a <dirlink>:
{
    8000434a:	715d                	addi	sp,sp,-80
    8000434c:	e486                	sd	ra,72(sp)
    8000434e:	e0a2                	sd	s0,64(sp)
    80004350:	f84a                	sd	s2,48(sp)
    80004352:	ec56                	sd	s5,24(sp)
    80004354:	e85a                	sd	s6,16(sp)
    80004356:	0880                	addi	s0,sp,80
    80004358:	892a                	mv	s2,a0
    8000435a:	8aae                	mv	s5,a1
    8000435c:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000435e:	4601                	li	a2,0
    80004360:	00000097          	auipc	ra,0x0
    80004364:	dc4080e7          	jalr	-572(ra) # 80004124 <dirlookup>
    80004368:	e129                	bnez	a0,800043aa <dirlink+0x60>
    8000436a:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000436c:	04c92483          	lw	s1,76(s2)
    80004370:	cca9                	beqz	s1,800043ca <dirlink+0x80>
    80004372:	f44e                	sd	s3,40(sp)
    80004374:	f052                	sd	s4,32(sp)
    80004376:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004378:	fb040a13          	addi	s4,s0,-80
    8000437c:	49c1                	li	s3,16
    8000437e:	874e                	mv	a4,s3
    80004380:	86a6                	mv	a3,s1
    80004382:	8652                	mv	a2,s4
    80004384:	4581                	li	a1,0
    80004386:	854a                	mv	a0,s2
    80004388:	00000097          	auipc	ra,0x0
    8000438c:	b5c080e7          	jalr	-1188(ra) # 80003ee4 <readi>
    80004390:	03351363          	bne	a0,s3,800043b6 <dirlink+0x6c>
    if(de.inum == 0)
    80004394:	fb045783          	lhu	a5,-80(s0)
    80004398:	c79d                	beqz	a5,800043c6 <dirlink+0x7c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000439a:	24c1                	addiw	s1,s1,16
    8000439c:	04c92783          	lw	a5,76(s2)
    800043a0:	fcf4efe3          	bltu	s1,a5,8000437e <dirlink+0x34>
    800043a4:	79a2                	ld	s3,40(sp)
    800043a6:	7a02                	ld	s4,32(sp)
    800043a8:	a00d                	j	800043ca <dirlink+0x80>
    iput(ip);
    800043aa:	00000097          	auipc	ra,0x0
    800043ae:	a3c080e7          	jalr	-1476(ra) # 80003de6 <iput>
    return -1;
    800043b2:	557d                	li	a0,-1
    800043b4:	a0a9                	j	800043fe <dirlink+0xb4>
      panic("dirlink read");
    800043b6:	00004517          	auipc	a0,0x4
    800043ba:	26250513          	addi	a0,a0,610 # 80008618 <__func__.1+0x610>
    800043be:	ffffc097          	auipc	ra,0xffffc
    800043c2:	1a2080e7          	jalr	418(ra) # 80000560 <panic>
    800043c6:	79a2                	ld	s3,40(sp)
    800043c8:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    800043ca:	4639                	li	a2,14
    800043cc:	85d6                	mv	a1,s5
    800043ce:	fb240513          	addi	a0,s0,-78
    800043d2:	ffffd097          	auipc	ra,0xffffd
    800043d6:	b42080e7          	jalr	-1214(ra) # 80000f14 <strncpy>
  de.inum = inum;
    800043da:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800043de:	4741                	li	a4,16
    800043e0:	86a6                	mv	a3,s1
    800043e2:	fb040613          	addi	a2,s0,-80
    800043e6:	4581                	li	a1,0
    800043e8:	854a                	mv	a0,s2
    800043ea:	00000097          	auipc	ra,0x0
    800043ee:	c00080e7          	jalr	-1024(ra) # 80003fea <writei>
    800043f2:	1541                	addi	a0,a0,-16
    800043f4:	00a03533          	snez	a0,a0
    800043f8:	40a0053b          	negw	a0,a0
    800043fc:	74e2                	ld	s1,56(sp)
}
    800043fe:	60a6                	ld	ra,72(sp)
    80004400:	6406                	ld	s0,64(sp)
    80004402:	7942                	ld	s2,48(sp)
    80004404:	6ae2                	ld	s5,24(sp)
    80004406:	6b42                	ld	s6,16(sp)
    80004408:	6161                	addi	sp,sp,80
    8000440a:	8082                	ret

000000008000440c <namei>:

struct inode*
namei(char *path)
{
    8000440c:	1101                	addi	sp,sp,-32
    8000440e:	ec06                	sd	ra,24(sp)
    80004410:	e822                	sd	s0,16(sp)
    80004412:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004414:	fe040613          	addi	a2,s0,-32
    80004418:	4581                	li	a1,0
    8000441a:	00000097          	auipc	ra,0x0
    8000441e:	dca080e7          	jalr	-566(ra) # 800041e4 <namex>
}
    80004422:	60e2                	ld	ra,24(sp)
    80004424:	6442                	ld	s0,16(sp)
    80004426:	6105                	addi	sp,sp,32
    80004428:	8082                	ret

000000008000442a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000442a:	1141                	addi	sp,sp,-16
    8000442c:	e406                	sd	ra,8(sp)
    8000442e:	e022                	sd	s0,0(sp)
    80004430:	0800                	addi	s0,sp,16
    80004432:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004434:	4585                	li	a1,1
    80004436:	00000097          	auipc	ra,0x0
    8000443a:	dae080e7          	jalr	-594(ra) # 800041e4 <namex>
}
    8000443e:	60a2                	ld	ra,8(sp)
    80004440:	6402                	ld	s0,0(sp)
    80004442:	0141                	addi	sp,sp,16
    80004444:	8082                	ret

0000000080004446 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80004446:	1101                	addi	sp,sp,-32
    80004448:	ec06                	sd	ra,24(sp)
    8000444a:	e822                	sd	s0,16(sp)
    8000444c:	e426                	sd	s1,8(sp)
    8000444e:	e04a                	sd	s2,0(sp)
    80004450:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004452:	0001d917          	auipc	s2,0x1d
    80004456:	82e90913          	addi	s2,s2,-2002 # 80020c80 <log>
    8000445a:	01892583          	lw	a1,24(s2)
    8000445e:	02892503          	lw	a0,40(s2)
    80004462:	fffff097          	auipc	ra,0xfffff
    80004466:	fb8080e7          	jalr	-72(ra) # 8000341a <bread>
    8000446a:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000446c:	02c92603          	lw	a2,44(s2)
    80004470:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004472:	00c05f63          	blez	a2,80004490 <write_head+0x4a>
    80004476:	0001d717          	auipc	a4,0x1d
    8000447a:	83a70713          	addi	a4,a4,-1990 # 80020cb0 <log+0x30>
    8000447e:	87aa                	mv	a5,a0
    80004480:	060a                	slli	a2,a2,0x2
    80004482:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80004484:	4314                	lw	a3,0(a4)
    80004486:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80004488:	0711                	addi	a4,a4,4
    8000448a:	0791                	addi	a5,a5,4
    8000448c:	fec79ce3          	bne	a5,a2,80004484 <write_head+0x3e>
  }
  bwrite(buf);
    80004490:	8526                	mv	a0,s1
    80004492:	fffff097          	auipc	ra,0xfffff
    80004496:	07a080e7          	jalr	122(ra) # 8000350c <bwrite>
  brelse(buf);
    8000449a:	8526                	mv	a0,s1
    8000449c:	fffff097          	auipc	ra,0xfffff
    800044a0:	0ae080e7          	jalr	174(ra) # 8000354a <brelse>
}
    800044a4:	60e2                	ld	ra,24(sp)
    800044a6:	6442                	ld	s0,16(sp)
    800044a8:	64a2                	ld	s1,8(sp)
    800044aa:	6902                	ld	s2,0(sp)
    800044ac:	6105                	addi	sp,sp,32
    800044ae:	8082                	ret

00000000800044b0 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800044b0:	0001c797          	auipc	a5,0x1c
    800044b4:	7fc7a783          	lw	a5,2044(a5) # 80020cac <log+0x2c>
    800044b8:	0cf05063          	blez	a5,80004578 <install_trans+0xc8>
{
    800044bc:	715d                	addi	sp,sp,-80
    800044be:	e486                	sd	ra,72(sp)
    800044c0:	e0a2                	sd	s0,64(sp)
    800044c2:	fc26                	sd	s1,56(sp)
    800044c4:	f84a                	sd	s2,48(sp)
    800044c6:	f44e                	sd	s3,40(sp)
    800044c8:	f052                	sd	s4,32(sp)
    800044ca:	ec56                	sd	s5,24(sp)
    800044cc:	e85a                	sd	s6,16(sp)
    800044ce:	e45e                	sd	s7,8(sp)
    800044d0:	0880                	addi	s0,sp,80
    800044d2:	8b2a                	mv	s6,a0
    800044d4:	0001ca97          	auipc	s5,0x1c
    800044d8:	7dca8a93          	addi	s5,s5,2012 # 80020cb0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800044dc:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800044de:	0001c997          	auipc	s3,0x1c
    800044e2:	7a298993          	addi	s3,s3,1954 # 80020c80 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800044e6:	40000b93          	li	s7,1024
    800044ea:	a00d                	j	8000450c <install_trans+0x5c>
    brelse(lbuf);
    800044ec:	854a                	mv	a0,s2
    800044ee:	fffff097          	auipc	ra,0xfffff
    800044f2:	05c080e7          	jalr	92(ra) # 8000354a <brelse>
    brelse(dbuf);
    800044f6:	8526                	mv	a0,s1
    800044f8:	fffff097          	auipc	ra,0xfffff
    800044fc:	052080e7          	jalr	82(ra) # 8000354a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004500:	2a05                	addiw	s4,s4,1
    80004502:	0a91                	addi	s5,s5,4
    80004504:	02c9a783          	lw	a5,44(s3)
    80004508:	04fa5d63          	bge	s4,a5,80004562 <install_trans+0xb2>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000450c:	0189a583          	lw	a1,24(s3)
    80004510:	014585bb          	addw	a1,a1,s4
    80004514:	2585                	addiw	a1,a1,1
    80004516:	0289a503          	lw	a0,40(s3)
    8000451a:	fffff097          	auipc	ra,0xfffff
    8000451e:	f00080e7          	jalr	-256(ra) # 8000341a <bread>
    80004522:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004524:	000aa583          	lw	a1,0(s5)
    80004528:	0289a503          	lw	a0,40(s3)
    8000452c:	fffff097          	auipc	ra,0xfffff
    80004530:	eee080e7          	jalr	-274(ra) # 8000341a <bread>
    80004534:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004536:	865e                	mv	a2,s7
    80004538:	05890593          	addi	a1,s2,88
    8000453c:	05850513          	addi	a0,a0,88
    80004540:	ffffd097          	auipc	ra,0xffffd
    80004544:	922080e7          	jalr	-1758(ra) # 80000e62 <memmove>
    bwrite(dbuf);  // write dst to disk
    80004548:	8526                	mv	a0,s1
    8000454a:	fffff097          	auipc	ra,0xfffff
    8000454e:	fc2080e7          	jalr	-62(ra) # 8000350c <bwrite>
    if(recovering == 0)
    80004552:	f80b1de3          	bnez	s6,800044ec <install_trans+0x3c>
      bunpin(dbuf);
    80004556:	8526                	mv	a0,s1
    80004558:	fffff097          	auipc	ra,0xfffff
    8000455c:	0c6080e7          	jalr	198(ra) # 8000361e <bunpin>
    80004560:	b771                	j	800044ec <install_trans+0x3c>
}
    80004562:	60a6                	ld	ra,72(sp)
    80004564:	6406                	ld	s0,64(sp)
    80004566:	74e2                	ld	s1,56(sp)
    80004568:	7942                	ld	s2,48(sp)
    8000456a:	79a2                	ld	s3,40(sp)
    8000456c:	7a02                	ld	s4,32(sp)
    8000456e:	6ae2                	ld	s5,24(sp)
    80004570:	6b42                	ld	s6,16(sp)
    80004572:	6ba2                	ld	s7,8(sp)
    80004574:	6161                	addi	sp,sp,80
    80004576:	8082                	ret
    80004578:	8082                	ret

000000008000457a <initlog>:
{
    8000457a:	7179                	addi	sp,sp,-48
    8000457c:	f406                	sd	ra,40(sp)
    8000457e:	f022                	sd	s0,32(sp)
    80004580:	ec26                	sd	s1,24(sp)
    80004582:	e84a                	sd	s2,16(sp)
    80004584:	e44e                	sd	s3,8(sp)
    80004586:	1800                	addi	s0,sp,48
    80004588:	892a                	mv	s2,a0
    8000458a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000458c:	0001c497          	auipc	s1,0x1c
    80004590:	6f448493          	addi	s1,s1,1780 # 80020c80 <log>
    80004594:	00004597          	auipc	a1,0x4
    80004598:	09458593          	addi	a1,a1,148 # 80008628 <__func__.1+0x620>
    8000459c:	8526                	mv	a0,s1
    8000459e:	ffffc097          	auipc	ra,0xffffc
    800045a2:	6d4080e7          	jalr	1748(ra) # 80000c72 <initlock>
  log.start = sb->logstart;
    800045a6:	0149a583          	lw	a1,20(s3)
    800045aa:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800045ac:	0109a783          	lw	a5,16(s3)
    800045b0:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800045b2:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800045b6:	854a                	mv	a0,s2
    800045b8:	fffff097          	auipc	ra,0xfffff
    800045bc:	e62080e7          	jalr	-414(ra) # 8000341a <bread>
  log.lh.n = lh->n;
    800045c0:	4d30                	lw	a2,88(a0)
    800045c2:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800045c4:	00c05f63          	blez	a2,800045e2 <initlog+0x68>
    800045c8:	87aa                	mv	a5,a0
    800045ca:	0001c717          	auipc	a4,0x1c
    800045ce:	6e670713          	addi	a4,a4,1766 # 80020cb0 <log+0x30>
    800045d2:	060a                	slli	a2,a2,0x2
    800045d4:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800045d6:	4ff4                	lw	a3,92(a5)
    800045d8:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800045da:	0791                	addi	a5,a5,4
    800045dc:	0711                	addi	a4,a4,4
    800045de:	fec79ce3          	bne	a5,a2,800045d6 <initlog+0x5c>
  brelse(buf);
    800045e2:	fffff097          	auipc	ra,0xfffff
    800045e6:	f68080e7          	jalr	-152(ra) # 8000354a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800045ea:	4505                	li	a0,1
    800045ec:	00000097          	auipc	ra,0x0
    800045f0:	ec4080e7          	jalr	-316(ra) # 800044b0 <install_trans>
  log.lh.n = 0;
    800045f4:	0001c797          	auipc	a5,0x1c
    800045f8:	6a07ac23          	sw	zero,1720(a5) # 80020cac <log+0x2c>
  write_head(); // clear the log
    800045fc:	00000097          	auipc	ra,0x0
    80004600:	e4a080e7          	jalr	-438(ra) # 80004446 <write_head>
}
    80004604:	70a2                	ld	ra,40(sp)
    80004606:	7402                	ld	s0,32(sp)
    80004608:	64e2                	ld	s1,24(sp)
    8000460a:	6942                	ld	s2,16(sp)
    8000460c:	69a2                	ld	s3,8(sp)
    8000460e:	6145                	addi	sp,sp,48
    80004610:	8082                	ret

0000000080004612 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004612:	1101                	addi	sp,sp,-32
    80004614:	ec06                	sd	ra,24(sp)
    80004616:	e822                	sd	s0,16(sp)
    80004618:	e426                	sd	s1,8(sp)
    8000461a:	e04a                	sd	s2,0(sp)
    8000461c:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000461e:	0001c517          	auipc	a0,0x1c
    80004622:	66250513          	addi	a0,a0,1634 # 80020c80 <log>
    80004626:	ffffc097          	auipc	ra,0xffffc
    8000462a:	6e0080e7          	jalr	1760(ra) # 80000d06 <acquire>
  while(1){
    if(log.committing){
    8000462e:	0001c497          	auipc	s1,0x1c
    80004632:	65248493          	addi	s1,s1,1618 # 80020c80 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004636:	4979                	li	s2,30
    80004638:	a039                	j	80004646 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000463a:	85a6                	mv	a1,s1
    8000463c:	8526                	mv	a0,s1
    8000463e:	ffffe097          	auipc	ra,0xffffe
    80004642:	dd6080e7          	jalr	-554(ra) # 80002414 <sleep>
    if(log.committing){
    80004646:	50dc                	lw	a5,36(s1)
    80004648:	fbed                	bnez	a5,8000463a <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000464a:	5098                	lw	a4,32(s1)
    8000464c:	2705                	addiw	a4,a4,1
    8000464e:	0027179b          	slliw	a5,a4,0x2
    80004652:	9fb9                	addw	a5,a5,a4
    80004654:	0017979b          	slliw	a5,a5,0x1
    80004658:	54d4                	lw	a3,44(s1)
    8000465a:	9fb5                	addw	a5,a5,a3
    8000465c:	00f95963          	bge	s2,a5,8000466e <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004660:	85a6                	mv	a1,s1
    80004662:	8526                	mv	a0,s1
    80004664:	ffffe097          	auipc	ra,0xffffe
    80004668:	db0080e7          	jalr	-592(ra) # 80002414 <sleep>
    8000466c:	bfe9                	j	80004646 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000466e:	0001c517          	auipc	a0,0x1c
    80004672:	61250513          	addi	a0,a0,1554 # 80020c80 <log>
    80004676:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80004678:	ffffc097          	auipc	ra,0xffffc
    8000467c:	73e080e7          	jalr	1854(ra) # 80000db6 <release>
      break;
    }
  }
}
    80004680:	60e2                	ld	ra,24(sp)
    80004682:	6442                	ld	s0,16(sp)
    80004684:	64a2                	ld	s1,8(sp)
    80004686:	6902                	ld	s2,0(sp)
    80004688:	6105                	addi	sp,sp,32
    8000468a:	8082                	ret

000000008000468c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000468c:	7139                	addi	sp,sp,-64
    8000468e:	fc06                	sd	ra,56(sp)
    80004690:	f822                	sd	s0,48(sp)
    80004692:	f426                	sd	s1,40(sp)
    80004694:	f04a                	sd	s2,32(sp)
    80004696:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004698:	0001c497          	auipc	s1,0x1c
    8000469c:	5e848493          	addi	s1,s1,1512 # 80020c80 <log>
    800046a0:	8526                	mv	a0,s1
    800046a2:	ffffc097          	auipc	ra,0xffffc
    800046a6:	664080e7          	jalr	1636(ra) # 80000d06 <acquire>
  log.outstanding -= 1;
    800046aa:	509c                	lw	a5,32(s1)
    800046ac:	37fd                	addiw	a5,a5,-1
    800046ae:	893e                	mv	s2,a5
    800046b0:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800046b2:	50dc                	lw	a5,36(s1)
    800046b4:	e7b9                	bnez	a5,80004702 <end_op+0x76>
    panic("log.committing");
  if(log.outstanding == 0){
    800046b6:	06091263          	bnez	s2,8000471a <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800046ba:	0001c497          	auipc	s1,0x1c
    800046be:	5c648493          	addi	s1,s1,1478 # 80020c80 <log>
    800046c2:	4785                	li	a5,1
    800046c4:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800046c6:	8526                	mv	a0,s1
    800046c8:	ffffc097          	auipc	ra,0xffffc
    800046cc:	6ee080e7          	jalr	1774(ra) # 80000db6 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800046d0:	54dc                	lw	a5,44(s1)
    800046d2:	06f04863          	bgtz	a5,80004742 <end_op+0xb6>
    acquire(&log.lock);
    800046d6:	0001c497          	auipc	s1,0x1c
    800046da:	5aa48493          	addi	s1,s1,1450 # 80020c80 <log>
    800046de:	8526                	mv	a0,s1
    800046e0:	ffffc097          	auipc	ra,0xffffc
    800046e4:	626080e7          	jalr	1574(ra) # 80000d06 <acquire>
    log.committing = 0;
    800046e8:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800046ec:	8526                	mv	a0,s1
    800046ee:	ffffe097          	auipc	ra,0xffffe
    800046f2:	d8a080e7          	jalr	-630(ra) # 80002478 <wakeup>
    release(&log.lock);
    800046f6:	8526                	mv	a0,s1
    800046f8:	ffffc097          	auipc	ra,0xffffc
    800046fc:	6be080e7          	jalr	1726(ra) # 80000db6 <release>
}
    80004700:	a81d                	j	80004736 <end_op+0xaa>
    80004702:	ec4e                	sd	s3,24(sp)
    80004704:	e852                	sd	s4,16(sp)
    80004706:	e456                	sd	s5,8(sp)
    80004708:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    8000470a:	00004517          	auipc	a0,0x4
    8000470e:	f2650513          	addi	a0,a0,-218 # 80008630 <__func__.1+0x628>
    80004712:	ffffc097          	auipc	ra,0xffffc
    80004716:	e4e080e7          	jalr	-434(ra) # 80000560 <panic>
    wakeup(&log);
    8000471a:	0001c497          	auipc	s1,0x1c
    8000471e:	56648493          	addi	s1,s1,1382 # 80020c80 <log>
    80004722:	8526                	mv	a0,s1
    80004724:	ffffe097          	auipc	ra,0xffffe
    80004728:	d54080e7          	jalr	-684(ra) # 80002478 <wakeup>
  release(&log.lock);
    8000472c:	8526                	mv	a0,s1
    8000472e:	ffffc097          	auipc	ra,0xffffc
    80004732:	688080e7          	jalr	1672(ra) # 80000db6 <release>
}
    80004736:	70e2                	ld	ra,56(sp)
    80004738:	7442                	ld	s0,48(sp)
    8000473a:	74a2                	ld	s1,40(sp)
    8000473c:	7902                	ld	s2,32(sp)
    8000473e:	6121                	addi	sp,sp,64
    80004740:	8082                	ret
    80004742:	ec4e                	sd	s3,24(sp)
    80004744:	e852                	sd	s4,16(sp)
    80004746:	e456                	sd	s5,8(sp)
    80004748:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000474a:	0001ca97          	auipc	s5,0x1c
    8000474e:	566a8a93          	addi	s5,s5,1382 # 80020cb0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004752:	0001ca17          	auipc	s4,0x1c
    80004756:	52ea0a13          	addi	s4,s4,1326 # 80020c80 <log>
    memmove(to->data, from->data, BSIZE);
    8000475a:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000475e:	018a2583          	lw	a1,24(s4)
    80004762:	012585bb          	addw	a1,a1,s2
    80004766:	2585                	addiw	a1,a1,1
    80004768:	028a2503          	lw	a0,40(s4)
    8000476c:	fffff097          	auipc	ra,0xfffff
    80004770:	cae080e7          	jalr	-850(ra) # 8000341a <bread>
    80004774:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004776:	000aa583          	lw	a1,0(s5)
    8000477a:	028a2503          	lw	a0,40(s4)
    8000477e:	fffff097          	auipc	ra,0xfffff
    80004782:	c9c080e7          	jalr	-868(ra) # 8000341a <bread>
    80004786:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004788:	865a                	mv	a2,s6
    8000478a:	05850593          	addi	a1,a0,88
    8000478e:	05848513          	addi	a0,s1,88
    80004792:	ffffc097          	auipc	ra,0xffffc
    80004796:	6d0080e7          	jalr	1744(ra) # 80000e62 <memmove>
    bwrite(to);  // write the log
    8000479a:	8526                	mv	a0,s1
    8000479c:	fffff097          	auipc	ra,0xfffff
    800047a0:	d70080e7          	jalr	-656(ra) # 8000350c <bwrite>
    brelse(from);
    800047a4:	854e                	mv	a0,s3
    800047a6:	fffff097          	auipc	ra,0xfffff
    800047aa:	da4080e7          	jalr	-604(ra) # 8000354a <brelse>
    brelse(to);
    800047ae:	8526                	mv	a0,s1
    800047b0:	fffff097          	auipc	ra,0xfffff
    800047b4:	d9a080e7          	jalr	-614(ra) # 8000354a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800047b8:	2905                	addiw	s2,s2,1
    800047ba:	0a91                	addi	s5,s5,4
    800047bc:	02ca2783          	lw	a5,44(s4)
    800047c0:	f8f94fe3          	blt	s2,a5,8000475e <end_op+0xd2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800047c4:	00000097          	auipc	ra,0x0
    800047c8:	c82080e7          	jalr	-894(ra) # 80004446 <write_head>
    install_trans(0); // Now install writes to home locations
    800047cc:	4501                	li	a0,0
    800047ce:	00000097          	auipc	ra,0x0
    800047d2:	ce2080e7          	jalr	-798(ra) # 800044b0 <install_trans>
    log.lh.n = 0;
    800047d6:	0001c797          	auipc	a5,0x1c
    800047da:	4c07ab23          	sw	zero,1238(a5) # 80020cac <log+0x2c>
    write_head();    // Erase the transaction from the log
    800047de:	00000097          	auipc	ra,0x0
    800047e2:	c68080e7          	jalr	-920(ra) # 80004446 <write_head>
    800047e6:	69e2                	ld	s3,24(sp)
    800047e8:	6a42                	ld	s4,16(sp)
    800047ea:	6aa2                	ld	s5,8(sp)
    800047ec:	6b02                	ld	s6,0(sp)
    800047ee:	b5e5                	j	800046d6 <end_op+0x4a>

00000000800047f0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800047f0:	1101                	addi	sp,sp,-32
    800047f2:	ec06                	sd	ra,24(sp)
    800047f4:	e822                	sd	s0,16(sp)
    800047f6:	e426                	sd	s1,8(sp)
    800047f8:	e04a                	sd	s2,0(sp)
    800047fa:	1000                	addi	s0,sp,32
    800047fc:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800047fe:	0001c917          	auipc	s2,0x1c
    80004802:	48290913          	addi	s2,s2,1154 # 80020c80 <log>
    80004806:	854a                	mv	a0,s2
    80004808:	ffffc097          	auipc	ra,0xffffc
    8000480c:	4fe080e7          	jalr	1278(ra) # 80000d06 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004810:	02c92603          	lw	a2,44(s2)
    80004814:	47f5                	li	a5,29
    80004816:	06c7c563          	blt	a5,a2,80004880 <log_write+0x90>
    8000481a:	0001c797          	auipc	a5,0x1c
    8000481e:	4827a783          	lw	a5,1154(a5) # 80020c9c <log+0x1c>
    80004822:	37fd                	addiw	a5,a5,-1
    80004824:	04f65e63          	bge	a2,a5,80004880 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004828:	0001c797          	auipc	a5,0x1c
    8000482c:	4787a783          	lw	a5,1144(a5) # 80020ca0 <log+0x20>
    80004830:	06f05063          	blez	a5,80004890 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004834:	4781                	li	a5,0
    80004836:	06c05563          	blez	a2,800048a0 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000483a:	44cc                	lw	a1,12(s1)
    8000483c:	0001c717          	auipc	a4,0x1c
    80004840:	47470713          	addi	a4,a4,1140 # 80020cb0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004844:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004846:	4314                	lw	a3,0(a4)
    80004848:	04b68c63          	beq	a3,a1,800048a0 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000484c:	2785                	addiw	a5,a5,1
    8000484e:	0711                	addi	a4,a4,4
    80004850:	fef61be3          	bne	a2,a5,80004846 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004854:	0621                	addi	a2,a2,8
    80004856:	060a                	slli	a2,a2,0x2
    80004858:	0001c797          	auipc	a5,0x1c
    8000485c:	42878793          	addi	a5,a5,1064 # 80020c80 <log>
    80004860:	97b2                	add	a5,a5,a2
    80004862:	44d8                	lw	a4,12(s1)
    80004864:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004866:	8526                	mv	a0,s1
    80004868:	fffff097          	auipc	ra,0xfffff
    8000486c:	d7a080e7          	jalr	-646(ra) # 800035e2 <bpin>
    log.lh.n++;
    80004870:	0001c717          	auipc	a4,0x1c
    80004874:	41070713          	addi	a4,a4,1040 # 80020c80 <log>
    80004878:	575c                	lw	a5,44(a4)
    8000487a:	2785                	addiw	a5,a5,1
    8000487c:	d75c                	sw	a5,44(a4)
    8000487e:	a82d                	j	800048b8 <log_write+0xc8>
    panic("too big a transaction");
    80004880:	00004517          	auipc	a0,0x4
    80004884:	dc050513          	addi	a0,a0,-576 # 80008640 <__func__.1+0x638>
    80004888:	ffffc097          	auipc	ra,0xffffc
    8000488c:	cd8080e7          	jalr	-808(ra) # 80000560 <panic>
    panic("log_write outside of trans");
    80004890:	00004517          	auipc	a0,0x4
    80004894:	dc850513          	addi	a0,a0,-568 # 80008658 <__func__.1+0x650>
    80004898:	ffffc097          	auipc	ra,0xffffc
    8000489c:	cc8080e7          	jalr	-824(ra) # 80000560 <panic>
  log.lh.block[i] = b->blockno;
    800048a0:	00878693          	addi	a3,a5,8
    800048a4:	068a                	slli	a3,a3,0x2
    800048a6:	0001c717          	auipc	a4,0x1c
    800048aa:	3da70713          	addi	a4,a4,986 # 80020c80 <log>
    800048ae:	9736                	add	a4,a4,a3
    800048b0:	44d4                	lw	a3,12(s1)
    800048b2:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800048b4:	faf609e3          	beq	a2,a5,80004866 <log_write+0x76>
  }
  release(&log.lock);
    800048b8:	0001c517          	auipc	a0,0x1c
    800048bc:	3c850513          	addi	a0,a0,968 # 80020c80 <log>
    800048c0:	ffffc097          	auipc	ra,0xffffc
    800048c4:	4f6080e7          	jalr	1270(ra) # 80000db6 <release>
}
    800048c8:	60e2                	ld	ra,24(sp)
    800048ca:	6442                	ld	s0,16(sp)
    800048cc:	64a2                	ld	s1,8(sp)
    800048ce:	6902                	ld	s2,0(sp)
    800048d0:	6105                	addi	sp,sp,32
    800048d2:	8082                	ret

00000000800048d4 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800048d4:	1101                	addi	sp,sp,-32
    800048d6:	ec06                	sd	ra,24(sp)
    800048d8:	e822                	sd	s0,16(sp)
    800048da:	e426                	sd	s1,8(sp)
    800048dc:	e04a                	sd	s2,0(sp)
    800048de:	1000                	addi	s0,sp,32
    800048e0:	84aa                	mv	s1,a0
    800048e2:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800048e4:	00004597          	auipc	a1,0x4
    800048e8:	d9458593          	addi	a1,a1,-620 # 80008678 <__func__.1+0x670>
    800048ec:	0521                	addi	a0,a0,8
    800048ee:	ffffc097          	auipc	ra,0xffffc
    800048f2:	384080e7          	jalr	900(ra) # 80000c72 <initlock>
  lk->name = name;
    800048f6:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800048fa:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800048fe:	0204a423          	sw	zero,40(s1)
}
    80004902:	60e2                	ld	ra,24(sp)
    80004904:	6442                	ld	s0,16(sp)
    80004906:	64a2                	ld	s1,8(sp)
    80004908:	6902                	ld	s2,0(sp)
    8000490a:	6105                	addi	sp,sp,32
    8000490c:	8082                	ret

000000008000490e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000490e:	1101                	addi	sp,sp,-32
    80004910:	ec06                	sd	ra,24(sp)
    80004912:	e822                	sd	s0,16(sp)
    80004914:	e426                	sd	s1,8(sp)
    80004916:	e04a                	sd	s2,0(sp)
    80004918:	1000                	addi	s0,sp,32
    8000491a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000491c:	00850913          	addi	s2,a0,8
    80004920:	854a                	mv	a0,s2
    80004922:	ffffc097          	auipc	ra,0xffffc
    80004926:	3e4080e7          	jalr	996(ra) # 80000d06 <acquire>
  while (lk->locked) {
    8000492a:	409c                	lw	a5,0(s1)
    8000492c:	cb89                	beqz	a5,8000493e <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000492e:	85ca                	mv	a1,s2
    80004930:	8526                	mv	a0,s1
    80004932:	ffffe097          	auipc	ra,0xffffe
    80004936:	ae2080e7          	jalr	-1310(ra) # 80002414 <sleep>
  while (lk->locked) {
    8000493a:	409c                	lw	a5,0(s1)
    8000493c:	fbed                	bnez	a5,8000492e <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000493e:	4785                	li	a5,1
    80004940:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004942:	ffffd097          	auipc	ra,0xffffd
    80004946:	31e080e7          	jalr	798(ra) # 80001c60 <myproc>
    8000494a:	591c                	lw	a5,48(a0)
    8000494c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000494e:	854a                	mv	a0,s2
    80004950:	ffffc097          	auipc	ra,0xffffc
    80004954:	466080e7          	jalr	1126(ra) # 80000db6 <release>
}
    80004958:	60e2                	ld	ra,24(sp)
    8000495a:	6442                	ld	s0,16(sp)
    8000495c:	64a2                	ld	s1,8(sp)
    8000495e:	6902                	ld	s2,0(sp)
    80004960:	6105                	addi	sp,sp,32
    80004962:	8082                	ret

0000000080004964 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004964:	1101                	addi	sp,sp,-32
    80004966:	ec06                	sd	ra,24(sp)
    80004968:	e822                	sd	s0,16(sp)
    8000496a:	e426                	sd	s1,8(sp)
    8000496c:	e04a                	sd	s2,0(sp)
    8000496e:	1000                	addi	s0,sp,32
    80004970:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004972:	00850913          	addi	s2,a0,8
    80004976:	854a                	mv	a0,s2
    80004978:	ffffc097          	auipc	ra,0xffffc
    8000497c:	38e080e7          	jalr	910(ra) # 80000d06 <acquire>
  lk->locked = 0;
    80004980:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004984:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004988:	8526                	mv	a0,s1
    8000498a:	ffffe097          	auipc	ra,0xffffe
    8000498e:	aee080e7          	jalr	-1298(ra) # 80002478 <wakeup>
  release(&lk->lk);
    80004992:	854a                	mv	a0,s2
    80004994:	ffffc097          	auipc	ra,0xffffc
    80004998:	422080e7          	jalr	1058(ra) # 80000db6 <release>
}
    8000499c:	60e2                	ld	ra,24(sp)
    8000499e:	6442                	ld	s0,16(sp)
    800049a0:	64a2                	ld	s1,8(sp)
    800049a2:	6902                	ld	s2,0(sp)
    800049a4:	6105                	addi	sp,sp,32
    800049a6:	8082                	ret

00000000800049a8 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800049a8:	7179                	addi	sp,sp,-48
    800049aa:	f406                	sd	ra,40(sp)
    800049ac:	f022                	sd	s0,32(sp)
    800049ae:	ec26                	sd	s1,24(sp)
    800049b0:	e84a                	sd	s2,16(sp)
    800049b2:	1800                	addi	s0,sp,48
    800049b4:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800049b6:	00850913          	addi	s2,a0,8
    800049ba:	854a                	mv	a0,s2
    800049bc:	ffffc097          	auipc	ra,0xffffc
    800049c0:	34a080e7          	jalr	842(ra) # 80000d06 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800049c4:	409c                	lw	a5,0(s1)
    800049c6:	ef91                	bnez	a5,800049e2 <holdingsleep+0x3a>
    800049c8:	4481                	li	s1,0
  release(&lk->lk);
    800049ca:	854a                	mv	a0,s2
    800049cc:	ffffc097          	auipc	ra,0xffffc
    800049d0:	3ea080e7          	jalr	1002(ra) # 80000db6 <release>
  return r;
}
    800049d4:	8526                	mv	a0,s1
    800049d6:	70a2                	ld	ra,40(sp)
    800049d8:	7402                	ld	s0,32(sp)
    800049da:	64e2                	ld	s1,24(sp)
    800049dc:	6942                	ld	s2,16(sp)
    800049de:	6145                	addi	sp,sp,48
    800049e0:	8082                	ret
    800049e2:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800049e4:	0284a983          	lw	s3,40(s1)
    800049e8:	ffffd097          	auipc	ra,0xffffd
    800049ec:	278080e7          	jalr	632(ra) # 80001c60 <myproc>
    800049f0:	5904                	lw	s1,48(a0)
    800049f2:	413484b3          	sub	s1,s1,s3
    800049f6:	0014b493          	seqz	s1,s1
    800049fa:	69a2                	ld	s3,8(sp)
    800049fc:	b7f9                	j	800049ca <holdingsleep+0x22>

00000000800049fe <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800049fe:	1141                	addi	sp,sp,-16
    80004a00:	e406                	sd	ra,8(sp)
    80004a02:	e022                	sd	s0,0(sp)
    80004a04:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004a06:	00004597          	auipc	a1,0x4
    80004a0a:	c8258593          	addi	a1,a1,-894 # 80008688 <__func__.1+0x680>
    80004a0e:	0001c517          	auipc	a0,0x1c
    80004a12:	3ba50513          	addi	a0,a0,954 # 80020dc8 <ftable>
    80004a16:	ffffc097          	auipc	ra,0xffffc
    80004a1a:	25c080e7          	jalr	604(ra) # 80000c72 <initlock>
}
    80004a1e:	60a2                	ld	ra,8(sp)
    80004a20:	6402                	ld	s0,0(sp)
    80004a22:	0141                	addi	sp,sp,16
    80004a24:	8082                	ret

0000000080004a26 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004a26:	1101                	addi	sp,sp,-32
    80004a28:	ec06                	sd	ra,24(sp)
    80004a2a:	e822                	sd	s0,16(sp)
    80004a2c:	e426                	sd	s1,8(sp)
    80004a2e:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004a30:	0001c517          	auipc	a0,0x1c
    80004a34:	39850513          	addi	a0,a0,920 # 80020dc8 <ftable>
    80004a38:	ffffc097          	auipc	ra,0xffffc
    80004a3c:	2ce080e7          	jalr	718(ra) # 80000d06 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004a40:	0001c497          	auipc	s1,0x1c
    80004a44:	3a048493          	addi	s1,s1,928 # 80020de0 <ftable+0x18>
    80004a48:	0001d717          	auipc	a4,0x1d
    80004a4c:	33870713          	addi	a4,a4,824 # 80021d80 <disk>
    if(f->ref == 0){
    80004a50:	40dc                	lw	a5,4(s1)
    80004a52:	cf99                	beqz	a5,80004a70 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004a54:	02848493          	addi	s1,s1,40
    80004a58:	fee49ce3          	bne	s1,a4,80004a50 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004a5c:	0001c517          	auipc	a0,0x1c
    80004a60:	36c50513          	addi	a0,a0,876 # 80020dc8 <ftable>
    80004a64:	ffffc097          	auipc	ra,0xffffc
    80004a68:	352080e7          	jalr	850(ra) # 80000db6 <release>
  return 0;
    80004a6c:	4481                	li	s1,0
    80004a6e:	a819                	j	80004a84 <filealloc+0x5e>
      f->ref = 1;
    80004a70:	4785                	li	a5,1
    80004a72:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004a74:	0001c517          	auipc	a0,0x1c
    80004a78:	35450513          	addi	a0,a0,852 # 80020dc8 <ftable>
    80004a7c:	ffffc097          	auipc	ra,0xffffc
    80004a80:	33a080e7          	jalr	826(ra) # 80000db6 <release>
}
    80004a84:	8526                	mv	a0,s1
    80004a86:	60e2                	ld	ra,24(sp)
    80004a88:	6442                	ld	s0,16(sp)
    80004a8a:	64a2                	ld	s1,8(sp)
    80004a8c:	6105                	addi	sp,sp,32
    80004a8e:	8082                	ret

0000000080004a90 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004a90:	1101                	addi	sp,sp,-32
    80004a92:	ec06                	sd	ra,24(sp)
    80004a94:	e822                	sd	s0,16(sp)
    80004a96:	e426                	sd	s1,8(sp)
    80004a98:	1000                	addi	s0,sp,32
    80004a9a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004a9c:	0001c517          	auipc	a0,0x1c
    80004aa0:	32c50513          	addi	a0,a0,812 # 80020dc8 <ftable>
    80004aa4:	ffffc097          	auipc	ra,0xffffc
    80004aa8:	262080e7          	jalr	610(ra) # 80000d06 <acquire>
  if(f->ref < 1)
    80004aac:	40dc                	lw	a5,4(s1)
    80004aae:	02f05263          	blez	a5,80004ad2 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004ab2:	2785                	addiw	a5,a5,1
    80004ab4:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004ab6:	0001c517          	auipc	a0,0x1c
    80004aba:	31250513          	addi	a0,a0,786 # 80020dc8 <ftable>
    80004abe:	ffffc097          	auipc	ra,0xffffc
    80004ac2:	2f8080e7          	jalr	760(ra) # 80000db6 <release>
  return f;
}
    80004ac6:	8526                	mv	a0,s1
    80004ac8:	60e2                	ld	ra,24(sp)
    80004aca:	6442                	ld	s0,16(sp)
    80004acc:	64a2                	ld	s1,8(sp)
    80004ace:	6105                	addi	sp,sp,32
    80004ad0:	8082                	ret
    panic("filedup");
    80004ad2:	00004517          	auipc	a0,0x4
    80004ad6:	bbe50513          	addi	a0,a0,-1090 # 80008690 <__func__.1+0x688>
    80004ada:	ffffc097          	auipc	ra,0xffffc
    80004ade:	a86080e7          	jalr	-1402(ra) # 80000560 <panic>

0000000080004ae2 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004ae2:	7139                	addi	sp,sp,-64
    80004ae4:	fc06                	sd	ra,56(sp)
    80004ae6:	f822                	sd	s0,48(sp)
    80004ae8:	f426                	sd	s1,40(sp)
    80004aea:	0080                	addi	s0,sp,64
    80004aec:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004aee:	0001c517          	auipc	a0,0x1c
    80004af2:	2da50513          	addi	a0,a0,730 # 80020dc8 <ftable>
    80004af6:	ffffc097          	auipc	ra,0xffffc
    80004afa:	210080e7          	jalr	528(ra) # 80000d06 <acquire>
  if(f->ref < 1)
    80004afe:	40dc                	lw	a5,4(s1)
    80004b00:	04f05a63          	blez	a5,80004b54 <fileclose+0x72>
    panic("fileclose");
  if(--f->ref > 0){
    80004b04:	37fd                	addiw	a5,a5,-1
    80004b06:	c0dc                	sw	a5,4(s1)
    80004b08:	06f04263          	bgtz	a5,80004b6c <fileclose+0x8a>
    80004b0c:	f04a                	sd	s2,32(sp)
    80004b0e:	ec4e                	sd	s3,24(sp)
    80004b10:	e852                	sd	s4,16(sp)
    80004b12:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004b14:	0004a903          	lw	s2,0(s1)
    80004b18:	0094ca83          	lbu	s5,9(s1)
    80004b1c:	0104ba03          	ld	s4,16(s1)
    80004b20:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004b24:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004b28:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004b2c:	0001c517          	auipc	a0,0x1c
    80004b30:	29c50513          	addi	a0,a0,668 # 80020dc8 <ftable>
    80004b34:	ffffc097          	auipc	ra,0xffffc
    80004b38:	282080e7          	jalr	642(ra) # 80000db6 <release>

  if(ff.type == FD_PIPE){
    80004b3c:	4785                	li	a5,1
    80004b3e:	04f90463          	beq	s2,a5,80004b86 <fileclose+0xa4>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004b42:	3979                	addiw	s2,s2,-2
    80004b44:	4785                	li	a5,1
    80004b46:	0527fb63          	bgeu	a5,s2,80004b9c <fileclose+0xba>
    80004b4a:	7902                	ld	s2,32(sp)
    80004b4c:	69e2                	ld	s3,24(sp)
    80004b4e:	6a42                	ld	s4,16(sp)
    80004b50:	6aa2                	ld	s5,8(sp)
    80004b52:	a02d                	j	80004b7c <fileclose+0x9a>
    80004b54:	f04a                	sd	s2,32(sp)
    80004b56:	ec4e                	sd	s3,24(sp)
    80004b58:	e852                	sd	s4,16(sp)
    80004b5a:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004b5c:	00004517          	auipc	a0,0x4
    80004b60:	b3c50513          	addi	a0,a0,-1220 # 80008698 <__func__.1+0x690>
    80004b64:	ffffc097          	auipc	ra,0xffffc
    80004b68:	9fc080e7          	jalr	-1540(ra) # 80000560 <panic>
    release(&ftable.lock);
    80004b6c:	0001c517          	auipc	a0,0x1c
    80004b70:	25c50513          	addi	a0,a0,604 # 80020dc8 <ftable>
    80004b74:	ffffc097          	auipc	ra,0xffffc
    80004b78:	242080e7          	jalr	578(ra) # 80000db6 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004b7c:	70e2                	ld	ra,56(sp)
    80004b7e:	7442                	ld	s0,48(sp)
    80004b80:	74a2                	ld	s1,40(sp)
    80004b82:	6121                	addi	sp,sp,64
    80004b84:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004b86:	85d6                	mv	a1,s5
    80004b88:	8552                	mv	a0,s4
    80004b8a:	00000097          	auipc	ra,0x0
    80004b8e:	3ac080e7          	jalr	940(ra) # 80004f36 <pipeclose>
    80004b92:	7902                	ld	s2,32(sp)
    80004b94:	69e2                	ld	s3,24(sp)
    80004b96:	6a42                	ld	s4,16(sp)
    80004b98:	6aa2                	ld	s5,8(sp)
    80004b9a:	b7cd                	j	80004b7c <fileclose+0x9a>
    begin_op();
    80004b9c:	00000097          	auipc	ra,0x0
    80004ba0:	a76080e7          	jalr	-1418(ra) # 80004612 <begin_op>
    iput(ff.ip);
    80004ba4:	854e                	mv	a0,s3
    80004ba6:	fffff097          	auipc	ra,0xfffff
    80004baa:	240080e7          	jalr	576(ra) # 80003de6 <iput>
    end_op();
    80004bae:	00000097          	auipc	ra,0x0
    80004bb2:	ade080e7          	jalr	-1314(ra) # 8000468c <end_op>
    80004bb6:	7902                	ld	s2,32(sp)
    80004bb8:	69e2                	ld	s3,24(sp)
    80004bba:	6a42                	ld	s4,16(sp)
    80004bbc:	6aa2                	ld	s5,8(sp)
    80004bbe:	bf7d                	j	80004b7c <fileclose+0x9a>

0000000080004bc0 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004bc0:	715d                	addi	sp,sp,-80
    80004bc2:	e486                	sd	ra,72(sp)
    80004bc4:	e0a2                	sd	s0,64(sp)
    80004bc6:	fc26                	sd	s1,56(sp)
    80004bc8:	f44e                	sd	s3,40(sp)
    80004bca:	0880                	addi	s0,sp,80
    80004bcc:	84aa                	mv	s1,a0
    80004bce:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004bd0:	ffffd097          	auipc	ra,0xffffd
    80004bd4:	090080e7          	jalr	144(ra) # 80001c60 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004bd8:	409c                	lw	a5,0(s1)
    80004bda:	37f9                	addiw	a5,a5,-2
    80004bdc:	4705                	li	a4,1
    80004bde:	04f76a63          	bltu	a4,a5,80004c32 <filestat+0x72>
    80004be2:	f84a                	sd	s2,48(sp)
    80004be4:	f052                	sd	s4,32(sp)
    80004be6:	892a                	mv	s2,a0
    ilock(f->ip);
    80004be8:	6c88                	ld	a0,24(s1)
    80004bea:	fffff097          	auipc	ra,0xfffff
    80004bee:	03e080e7          	jalr	62(ra) # 80003c28 <ilock>
    stati(f->ip, &st);
    80004bf2:	fb840a13          	addi	s4,s0,-72
    80004bf6:	85d2                	mv	a1,s4
    80004bf8:	6c88                	ld	a0,24(s1)
    80004bfa:	fffff097          	auipc	ra,0xfffff
    80004bfe:	2bc080e7          	jalr	700(ra) # 80003eb6 <stati>
    iunlock(f->ip);
    80004c02:	6c88                	ld	a0,24(s1)
    80004c04:	fffff097          	auipc	ra,0xfffff
    80004c08:	0ea080e7          	jalr	234(ra) # 80003cee <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004c0c:	46e1                	li	a3,24
    80004c0e:	8652                	mv	a2,s4
    80004c10:	85ce                	mv	a1,s3
    80004c12:	05093503          	ld	a0,80(s2)
    80004c16:	ffffd097          	auipc	ra,0xffffd
    80004c1a:	bc2080e7          	jalr	-1086(ra) # 800017d8 <copyout>
    80004c1e:	41f5551b          	sraiw	a0,a0,0x1f
    80004c22:	7942                	ld	s2,48(sp)
    80004c24:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004c26:	60a6                	ld	ra,72(sp)
    80004c28:	6406                	ld	s0,64(sp)
    80004c2a:	74e2                	ld	s1,56(sp)
    80004c2c:	79a2                	ld	s3,40(sp)
    80004c2e:	6161                	addi	sp,sp,80
    80004c30:	8082                	ret
  return -1;
    80004c32:	557d                	li	a0,-1
    80004c34:	bfcd                	j	80004c26 <filestat+0x66>

0000000080004c36 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004c36:	7179                	addi	sp,sp,-48
    80004c38:	f406                	sd	ra,40(sp)
    80004c3a:	f022                	sd	s0,32(sp)
    80004c3c:	e84a                	sd	s2,16(sp)
    80004c3e:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004c40:	00854783          	lbu	a5,8(a0)
    80004c44:	cbc5                	beqz	a5,80004cf4 <fileread+0xbe>
    80004c46:	ec26                	sd	s1,24(sp)
    80004c48:	e44e                	sd	s3,8(sp)
    80004c4a:	84aa                	mv	s1,a0
    80004c4c:	89ae                	mv	s3,a1
    80004c4e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004c50:	411c                	lw	a5,0(a0)
    80004c52:	4705                	li	a4,1
    80004c54:	04e78963          	beq	a5,a4,80004ca6 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004c58:	470d                	li	a4,3
    80004c5a:	04e78f63          	beq	a5,a4,80004cb8 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004c5e:	4709                	li	a4,2
    80004c60:	08e79263          	bne	a5,a4,80004ce4 <fileread+0xae>
    ilock(f->ip);
    80004c64:	6d08                	ld	a0,24(a0)
    80004c66:	fffff097          	auipc	ra,0xfffff
    80004c6a:	fc2080e7          	jalr	-62(ra) # 80003c28 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004c6e:	874a                	mv	a4,s2
    80004c70:	5094                	lw	a3,32(s1)
    80004c72:	864e                	mv	a2,s3
    80004c74:	4585                	li	a1,1
    80004c76:	6c88                	ld	a0,24(s1)
    80004c78:	fffff097          	auipc	ra,0xfffff
    80004c7c:	26c080e7          	jalr	620(ra) # 80003ee4 <readi>
    80004c80:	892a                	mv	s2,a0
    80004c82:	00a05563          	blez	a0,80004c8c <fileread+0x56>
      f->off += r;
    80004c86:	509c                	lw	a5,32(s1)
    80004c88:	9fa9                	addw	a5,a5,a0
    80004c8a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004c8c:	6c88                	ld	a0,24(s1)
    80004c8e:	fffff097          	auipc	ra,0xfffff
    80004c92:	060080e7          	jalr	96(ra) # 80003cee <iunlock>
    80004c96:	64e2                	ld	s1,24(sp)
    80004c98:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004c9a:	854a                	mv	a0,s2
    80004c9c:	70a2                	ld	ra,40(sp)
    80004c9e:	7402                	ld	s0,32(sp)
    80004ca0:	6942                	ld	s2,16(sp)
    80004ca2:	6145                	addi	sp,sp,48
    80004ca4:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004ca6:	6908                	ld	a0,16(a0)
    80004ca8:	00000097          	auipc	ra,0x0
    80004cac:	41a080e7          	jalr	1050(ra) # 800050c2 <piperead>
    80004cb0:	892a                	mv	s2,a0
    80004cb2:	64e2                	ld	s1,24(sp)
    80004cb4:	69a2                	ld	s3,8(sp)
    80004cb6:	b7d5                	j	80004c9a <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004cb8:	02451783          	lh	a5,36(a0)
    80004cbc:	03079693          	slli	a3,a5,0x30
    80004cc0:	92c1                	srli	a3,a3,0x30
    80004cc2:	4725                	li	a4,9
    80004cc4:	02d76a63          	bltu	a4,a3,80004cf8 <fileread+0xc2>
    80004cc8:	0792                	slli	a5,a5,0x4
    80004cca:	0001c717          	auipc	a4,0x1c
    80004cce:	05e70713          	addi	a4,a4,94 # 80020d28 <devsw>
    80004cd2:	97ba                	add	a5,a5,a4
    80004cd4:	639c                	ld	a5,0(a5)
    80004cd6:	c78d                	beqz	a5,80004d00 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80004cd8:	4505                	li	a0,1
    80004cda:	9782                	jalr	a5
    80004cdc:	892a                	mv	s2,a0
    80004cde:	64e2                	ld	s1,24(sp)
    80004ce0:	69a2                	ld	s3,8(sp)
    80004ce2:	bf65                	j	80004c9a <fileread+0x64>
    panic("fileread");
    80004ce4:	00004517          	auipc	a0,0x4
    80004ce8:	9c450513          	addi	a0,a0,-1596 # 800086a8 <__func__.1+0x6a0>
    80004cec:	ffffc097          	auipc	ra,0xffffc
    80004cf0:	874080e7          	jalr	-1932(ra) # 80000560 <panic>
    return -1;
    80004cf4:	597d                	li	s2,-1
    80004cf6:	b755                	j	80004c9a <fileread+0x64>
      return -1;
    80004cf8:	597d                	li	s2,-1
    80004cfa:	64e2                	ld	s1,24(sp)
    80004cfc:	69a2                	ld	s3,8(sp)
    80004cfe:	bf71                	j	80004c9a <fileread+0x64>
    80004d00:	597d                	li	s2,-1
    80004d02:	64e2                	ld	s1,24(sp)
    80004d04:	69a2                	ld	s3,8(sp)
    80004d06:	bf51                	j	80004c9a <fileread+0x64>

0000000080004d08 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004d08:	00954783          	lbu	a5,9(a0)
    80004d0c:	12078c63          	beqz	a5,80004e44 <filewrite+0x13c>
{
    80004d10:	711d                	addi	sp,sp,-96
    80004d12:	ec86                	sd	ra,88(sp)
    80004d14:	e8a2                	sd	s0,80(sp)
    80004d16:	e0ca                	sd	s2,64(sp)
    80004d18:	f456                	sd	s5,40(sp)
    80004d1a:	f05a                	sd	s6,32(sp)
    80004d1c:	1080                	addi	s0,sp,96
    80004d1e:	892a                	mv	s2,a0
    80004d20:	8b2e                	mv	s6,a1
    80004d22:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80004d24:	411c                	lw	a5,0(a0)
    80004d26:	4705                	li	a4,1
    80004d28:	02e78963          	beq	a5,a4,80004d5a <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004d2c:	470d                	li	a4,3
    80004d2e:	02e78c63          	beq	a5,a4,80004d66 <filewrite+0x5e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004d32:	4709                	li	a4,2
    80004d34:	0ee79a63          	bne	a5,a4,80004e28 <filewrite+0x120>
    80004d38:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004d3a:	0cc05563          	blez	a2,80004e04 <filewrite+0xfc>
    80004d3e:	e4a6                	sd	s1,72(sp)
    80004d40:	fc4e                	sd	s3,56(sp)
    80004d42:	ec5e                	sd	s7,24(sp)
    80004d44:	e862                	sd	s8,16(sp)
    80004d46:	e466                	sd	s9,8(sp)
    int i = 0;
    80004d48:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80004d4a:	6b85                	lui	s7,0x1
    80004d4c:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004d50:	6c85                	lui	s9,0x1
    80004d52:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004d56:	4c05                	li	s8,1
    80004d58:	a849                	j	80004dea <filewrite+0xe2>
    ret = pipewrite(f->pipe, addr, n);
    80004d5a:	6908                	ld	a0,16(a0)
    80004d5c:	00000097          	auipc	ra,0x0
    80004d60:	24a080e7          	jalr	586(ra) # 80004fa6 <pipewrite>
    80004d64:	a85d                	j	80004e1a <filewrite+0x112>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004d66:	02451783          	lh	a5,36(a0)
    80004d6a:	03079693          	slli	a3,a5,0x30
    80004d6e:	92c1                	srli	a3,a3,0x30
    80004d70:	4725                	li	a4,9
    80004d72:	0cd76b63          	bltu	a4,a3,80004e48 <filewrite+0x140>
    80004d76:	0792                	slli	a5,a5,0x4
    80004d78:	0001c717          	auipc	a4,0x1c
    80004d7c:	fb070713          	addi	a4,a4,-80 # 80020d28 <devsw>
    80004d80:	97ba                	add	a5,a5,a4
    80004d82:	679c                	ld	a5,8(a5)
    80004d84:	c7e1                	beqz	a5,80004e4c <filewrite+0x144>
    ret = devsw[f->major].write(1, addr, n);
    80004d86:	4505                	li	a0,1
    80004d88:	9782                	jalr	a5
    80004d8a:	a841                	j	80004e1a <filewrite+0x112>
      if(n1 > max)
    80004d8c:	2981                	sext.w	s3,s3
      begin_op();
    80004d8e:	00000097          	auipc	ra,0x0
    80004d92:	884080e7          	jalr	-1916(ra) # 80004612 <begin_op>
      ilock(f->ip);
    80004d96:	01893503          	ld	a0,24(s2)
    80004d9a:	fffff097          	auipc	ra,0xfffff
    80004d9e:	e8e080e7          	jalr	-370(ra) # 80003c28 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004da2:	874e                	mv	a4,s3
    80004da4:	02092683          	lw	a3,32(s2)
    80004da8:	016a0633          	add	a2,s4,s6
    80004dac:	85e2                	mv	a1,s8
    80004dae:	01893503          	ld	a0,24(s2)
    80004db2:	fffff097          	auipc	ra,0xfffff
    80004db6:	238080e7          	jalr	568(ra) # 80003fea <writei>
    80004dba:	84aa                	mv	s1,a0
    80004dbc:	00a05763          	blez	a0,80004dca <filewrite+0xc2>
        f->off += r;
    80004dc0:	02092783          	lw	a5,32(s2)
    80004dc4:	9fa9                	addw	a5,a5,a0
    80004dc6:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004dca:	01893503          	ld	a0,24(s2)
    80004dce:	fffff097          	auipc	ra,0xfffff
    80004dd2:	f20080e7          	jalr	-224(ra) # 80003cee <iunlock>
      end_op();
    80004dd6:	00000097          	auipc	ra,0x0
    80004dda:	8b6080e7          	jalr	-1866(ra) # 8000468c <end_op>

      if(r != n1){
    80004dde:	02999563          	bne	s3,s1,80004e08 <filewrite+0x100>
        // error from writei
        break;
      }
      i += r;
    80004de2:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80004de6:	015a5963          	bge	s4,s5,80004df8 <filewrite+0xf0>
      int n1 = n - i;
    80004dea:	414a87bb          	subw	a5,s5,s4
    80004dee:	89be                	mv	s3,a5
      if(n1 > max)
    80004df0:	f8fbdee3          	bge	s7,a5,80004d8c <filewrite+0x84>
    80004df4:	89e6                	mv	s3,s9
    80004df6:	bf59                	j	80004d8c <filewrite+0x84>
    80004df8:	64a6                	ld	s1,72(sp)
    80004dfa:	79e2                	ld	s3,56(sp)
    80004dfc:	6be2                	ld	s7,24(sp)
    80004dfe:	6c42                	ld	s8,16(sp)
    80004e00:	6ca2                	ld	s9,8(sp)
    80004e02:	a801                	j	80004e12 <filewrite+0x10a>
    int i = 0;
    80004e04:	4a01                	li	s4,0
    80004e06:	a031                	j	80004e12 <filewrite+0x10a>
    80004e08:	64a6                	ld	s1,72(sp)
    80004e0a:	79e2                	ld	s3,56(sp)
    80004e0c:	6be2                	ld	s7,24(sp)
    80004e0e:	6c42                	ld	s8,16(sp)
    80004e10:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80004e12:	034a9f63          	bne	s5,s4,80004e50 <filewrite+0x148>
    80004e16:	8556                	mv	a0,s5
    80004e18:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004e1a:	60e6                	ld	ra,88(sp)
    80004e1c:	6446                	ld	s0,80(sp)
    80004e1e:	6906                	ld	s2,64(sp)
    80004e20:	7aa2                	ld	s5,40(sp)
    80004e22:	7b02                	ld	s6,32(sp)
    80004e24:	6125                	addi	sp,sp,96
    80004e26:	8082                	ret
    80004e28:	e4a6                	sd	s1,72(sp)
    80004e2a:	fc4e                	sd	s3,56(sp)
    80004e2c:	f852                	sd	s4,48(sp)
    80004e2e:	ec5e                	sd	s7,24(sp)
    80004e30:	e862                	sd	s8,16(sp)
    80004e32:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80004e34:	00004517          	auipc	a0,0x4
    80004e38:	88450513          	addi	a0,a0,-1916 # 800086b8 <__func__.1+0x6b0>
    80004e3c:	ffffb097          	auipc	ra,0xffffb
    80004e40:	724080e7          	jalr	1828(ra) # 80000560 <panic>
    return -1;
    80004e44:	557d                	li	a0,-1
}
    80004e46:	8082                	ret
      return -1;
    80004e48:	557d                	li	a0,-1
    80004e4a:	bfc1                	j	80004e1a <filewrite+0x112>
    80004e4c:	557d                	li	a0,-1
    80004e4e:	b7f1                	j	80004e1a <filewrite+0x112>
    ret = (i == n ? n : -1);
    80004e50:	557d                	li	a0,-1
    80004e52:	7a42                	ld	s4,48(sp)
    80004e54:	b7d9                	j	80004e1a <filewrite+0x112>

0000000080004e56 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004e56:	7179                	addi	sp,sp,-48
    80004e58:	f406                	sd	ra,40(sp)
    80004e5a:	f022                	sd	s0,32(sp)
    80004e5c:	ec26                	sd	s1,24(sp)
    80004e5e:	e052                	sd	s4,0(sp)
    80004e60:	1800                	addi	s0,sp,48
    80004e62:	84aa                	mv	s1,a0
    80004e64:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004e66:	0005b023          	sd	zero,0(a1)
    80004e6a:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004e6e:	00000097          	auipc	ra,0x0
    80004e72:	bb8080e7          	jalr	-1096(ra) # 80004a26 <filealloc>
    80004e76:	e088                	sd	a0,0(s1)
    80004e78:	cd49                	beqz	a0,80004f12 <pipealloc+0xbc>
    80004e7a:	00000097          	auipc	ra,0x0
    80004e7e:	bac080e7          	jalr	-1108(ra) # 80004a26 <filealloc>
    80004e82:	00aa3023          	sd	a0,0(s4)
    80004e86:	c141                	beqz	a0,80004f06 <pipealloc+0xb0>
    80004e88:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004e8a:	ffffc097          	auipc	ra,0xffffc
    80004e8e:	d3c080e7          	jalr	-708(ra) # 80000bc6 <kalloc>
    80004e92:	892a                	mv	s2,a0
    80004e94:	c13d                	beqz	a0,80004efa <pipealloc+0xa4>
    80004e96:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004e98:	4985                	li	s3,1
    80004e9a:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004e9e:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004ea2:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004ea6:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004eaa:	00004597          	auipc	a1,0x4
    80004eae:	81e58593          	addi	a1,a1,-2018 # 800086c8 <__func__.1+0x6c0>
    80004eb2:	ffffc097          	auipc	ra,0xffffc
    80004eb6:	dc0080e7          	jalr	-576(ra) # 80000c72 <initlock>
  (*f0)->type = FD_PIPE;
    80004eba:	609c                	ld	a5,0(s1)
    80004ebc:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004ec0:	609c                	ld	a5,0(s1)
    80004ec2:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004ec6:	609c                	ld	a5,0(s1)
    80004ec8:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004ecc:	609c                	ld	a5,0(s1)
    80004ece:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004ed2:	000a3783          	ld	a5,0(s4)
    80004ed6:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004eda:	000a3783          	ld	a5,0(s4)
    80004ede:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004ee2:	000a3783          	ld	a5,0(s4)
    80004ee6:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004eea:	000a3783          	ld	a5,0(s4)
    80004eee:	0127b823          	sd	s2,16(a5)
  return 0;
    80004ef2:	4501                	li	a0,0
    80004ef4:	6942                	ld	s2,16(sp)
    80004ef6:	69a2                	ld	s3,8(sp)
    80004ef8:	a03d                	j	80004f26 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004efa:	6088                	ld	a0,0(s1)
    80004efc:	c119                	beqz	a0,80004f02 <pipealloc+0xac>
    80004efe:	6942                	ld	s2,16(sp)
    80004f00:	a029                	j	80004f0a <pipealloc+0xb4>
    80004f02:	6942                	ld	s2,16(sp)
    80004f04:	a039                	j	80004f12 <pipealloc+0xbc>
    80004f06:	6088                	ld	a0,0(s1)
    80004f08:	c50d                	beqz	a0,80004f32 <pipealloc+0xdc>
    fileclose(*f0);
    80004f0a:	00000097          	auipc	ra,0x0
    80004f0e:	bd8080e7          	jalr	-1064(ra) # 80004ae2 <fileclose>
  if(*f1)
    80004f12:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004f16:	557d                	li	a0,-1
  if(*f1)
    80004f18:	c799                	beqz	a5,80004f26 <pipealloc+0xd0>
    fileclose(*f1);
    80004f1a:	853e                	mv	a0,a5
    80004f1c:	00000097          	auipc	ra,0x0
    80004f20:	bc6080e7          	jalr	-1082(ra) # 80004ae2 <fileclose>
  return -1;
    80004f24:	557d                	li	a0,-1
}
    80004f26:	70a2                	ld	ra,40(sp)
    80004f28:	7402                	ld	s0,32(sp)
    80004f2a:	64e2                	ld	s1,24(sp)
    80004f2c:	6a02                	ld	s4,0(sp)
    80004f2e:	6145                	addi	sp,sp,48
    80004f30:	8082                	ret
  return -1;
    80004f32:	557d                	li	a0,-1
    80004f34:	bfcd                	j	80004f26 <pipealloc+0xd0>

0000000080004f36 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004f36:	1101                	addi	sp,sp,-32
    80004f38:	ec06                	sd	ra,24(sp)
    80004f3a:	e822                	sd	s0,16(sp)
    80004f3c:	e426                	sd	s1,8(sp)
    80004f3e:	e04a                	sd	s2,0(sp)
    80004f40:	1000                	addi	s0,sp,32
    80004f42:	84aa                	mv	s1,a0
    80004f44:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004f46:	ffffc097          	auipc	ra,0xffffc
    80004f4a:	dc0080e7          	jalr	-576(ra) # 80000d06 <acquire>
  if(writable){
    80004f4e:	02090d63          	beqz	s2,80004f88 <pipeclose+0x52>
    pi->writeopen = 0;
    80004f52:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004f56:	21848513          	addi	a0,s1,536
    80004f5a:	ffffd097          	auipc	ra,0xffffd
    80004f5e:	51e080e7          	jalr	1310(ra) # 80002478 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004f62:	2204b783          	ld	a5,544(s1)
    80004f66:	eb95                	bnez	a5,80004f9a <pipeclose+0x64>
    release(&pi->lock);
    80004f68:	8526                	mv	a0,s1
    80004f6a:	ffffc097          	auipc	ra,0xffffc
    80004f6e:	e4c080e7          	jalr	-436(ra) # 80000db6 <release>
    kfree((char*)pi);
    80004f72:	8526                	mv	a0,s1
    80004f74:	ffffc097          	auipc	ra,0xffffc
    80004f78:	aea080e7          	jalr	-1302(ra) # 80000a5e <kfree>
  } else
    release(&pi->lock);
}
    80004f7c:	60e2                	ld	ra,24(sp)
    80004f7e:	6442                	ld	s0,16(sp)
    80004f80:	64a2                	ld	s1,8(sp)
    80004f82:	6902                	ld	s2,0(sp)
    80004f84:	6105                	addi	sp,sp,32
    80004f86:	8082                	ret
    pi->readopen = 0;
    80004f88:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004f8c:	21c48513          	addi	a0,s1,540
    80004f90:	ffffd097          	auipc	ra,0xffffd
    80004f94:	4e8080e7          	jalr	1256(ra) # 80002478 <wakeup>
    80004f98:	b7e9                	j	80004f62 <pipeclose+0x2c>
    release(&pi->lock);
    80004f9a:	8526                	mv	a0,s1
    80004f9c:	ffffc097          	auipc	ra,0xffffc
    80004fa0:	e1a080e7          	jalr	-486(ra) # 80000db6 <release>
}
    80004fa4:	bfe1                	j	80004f7c <pipeclose+0x46>

0000000080004fa6 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004fa6:	7159                	addi	sp,sp,-112
    80004fa8:	f486                	sd	ra,104(sp)
    80004faa:	f0a2                	sd	s0,96(sp)
    80004fac:	eca6                	sd	s1,88(sp)
    80004fae:	e8ca                	sd	s2,80(sp)
    80004fb0:	e4ce                	sd	s3,72(sp)
    80004fb2:	e0d2                	sd	s4,64(sp)
    80004fb4:	fc56                	sd	s5,56(sp)
    80004fb6:	1880                	addi	s0,sp,112
    80004fb8:	84aa                	mv	s1,a0
    80004fba:	8aae                	mv	s5,a1
    80004fbc:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004fbe:	ffffd097          	auipc	ra,0xffffd
    80004fc2:	ca2080e7          	jalr	-862(ra) # 80001c60 <myproc>
    80004fc6:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004fc8:	8526                	mv	a0,s1
    80004fca:	ffffc097          	auipc	ra,0xffffc
    80004fce:	d3c080e7          	jalr	-708(ra) # 80000d06 <acquire>
  while(i < n){
    80004fd2:	0f405063          	blez	s4,800050b2 <pipewrite+0x10c>
    80004fd6:	f85a                	sd	s6,48(sp)
    80004fd8:	f45e                	sd	s7,40(sp)
    80004fda:	f062                	sd	s8,32(sp)
    80004fdc:	ec66                	sd	s9,24(sp)
    80004fde:	e86a                	sd	s10,16(sp)
  int i = 0;
    80004fe0:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004fe2:	f9f40c13          	addi	s8,s0,-97
    80004fe6:	4b85                	li	s7,1
    80004fe8:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004fea:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004fee:	21c48c93          	addi	s9,s1,540
    80004ff2:	a099                	j	80005038 <pipewrite+0x92>
      release(&pi->lock);
    80004ff4:	8526                	mv	a0,s1
    80004ff6:	ffffc097          	auipc	ra,0xffffc
    80004ffa:	dc0080e7          	jalr	-576(ra) # 80000db6 <release>
      return -1;
    80004ffe:	597d                	li	s2,-1
    80005000:	7b42                	ld	s6,48(sp)
    80005002:	7ba2                	ld	s7,40(sp)
    80005004:	7c02                	ld	s8,32(sp)
    80005006:	6ce2                	ld	s9,24(sp)
    80005008:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000500a:	854a                	mv	a0,s2
    8000500c:	70a6                	ld	ra,104(sp)
    8000500e:	7406                	ld	s0,96(sp)
    80005010:	64e6                	ld	s1,88(sp)
    80005012:	6946                	ld	s2,80(sp)
    80005014:	69a6                	ld	s3,72(sp)
    80005016:	6a06                	ld	s4,64(sp)
    80005018:	7ae2                	ld	s5,56(sp)
    8000501a:	6165                	addi	sp,sp,112
    8000501c:	8082                	ret
      wakeup(&pi->nread);
    8000501e:	856a                	mv	a0,s10
    80005020:	ffffd097          	auipc	ra,0xffffd
    80005024:	458080e7          	jalr	1112(ra) # 80002478 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80005028:	85a6                	mv	a1,s1
    8000502a:	8566                	mv	a0,s9
    8000502c:	ffffd097          	auipc	ra,0xffffd
    80005030:	3e8080e7          	jalr	1000(ra) # 80002414 <sleep>
  while(i < n){
    80005034:	05495e63          	bge	s2,s4,80005090 <pipewrite+0xea>
    if(pi->readopen == 0 || killed(pr)){
    80005038:	2204a783          	lw	a5,544(s1)
    8000503c:	dfc5                	beqz	a5,80004ff4 <pipewrite+0x4e>
    8000503e:	854e                	mv	a0,s3
    80005040:	ffffd097          	auipc	ra,0xffffd
    80005044:	67c080e7          	jalr	1660(ra) # 800026bc <killed>
    80005048:	f555                	bnez	a0,80004ff4 <pipewrite+0x4e>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000504a:	2184a783          	lw	a5,536(s1)
    8000504e:	21c4a703          	lw	a4,540(s1)
    80005052:	2007879b          	addiw	a5,a5,512
    80005056:	fcf704e3          	beq	a4,a5,8000501e <pipewrite+0x78>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000505a:	86de                	mv	a3,s7
    8000505c:	01590633          	add	a2,s2,s5
    80005060:	85e2                	mv	a1,s8
    80005062:	0509b503          	ld	a0,80(s3)
    80005066:	ffffc097          	auipc	ra,0xffffc
    8000506a:	7fe080e7          	jalr	2046(ra) # 80001864 <copyin>
    8000506e:	05650463          	beq	a0,s6,800050b6 <pipewrite+0x110>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80005072:	21c4a783          	lw	a5,540(s1)
    80005076:	0017871b          	addiw	a4,a5,1
    8000507a:	20e4ae23          	sw	a4,540(s1)
    8000507e:	1ff7f793          	andi	a5,a5,511
    80005082:	97a6                	add	a5,a5,s1
    80005084:	f9f44703          	lbu	a4,-97(s0)
    80005088:	00e78c23          	sb	a4,24(a5)
      i++;
    8000508c:	2905                	addiw	s2,s2,1
    8000508e:	b75d                	j	80005034 <pipewrite+0x8e>
    80005090:	7b42                	ld	s6,48(sp)
    80005092:	7ba2                	ld	s7,40(sp)
    80005094:	7c02                	ld	s8,32(sp)
    80005096:	6ce2                	ld	s9,24(sp)
    80005098:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    8000509a:	21848513          	addi	a0,s1,536
    8000509e:	ffffd097          	auipc	ra,0xffffd
    800050a2:	3da080e7          	jalr	986(ra) # 80002478 <wakeup>
  release(&pi->lock);
    800050a6:	8526                	mv	a0,s1
    800050a8:	ffffc097          	auipc	ra,0xffffc
    800050ac:	d0e080e7          	jalr	-754(ra) # 80000db6 <release>
  return i;
    800050b0:	bfa9                	j	8000500a <pipewrite+0x64>
  int i = 0;
    800050b2:	4901                	li	s2,0
    800050b4:	b7dd                	j	8000509a <pipewrite+0xf4>
    800050b6:	7b42                	ld	s6,48(sp)
    800050b8:	7ba2                	ld	s7,40(sp)
    800050ba:	7c02                	ld	s8,32(sp)
    800050bc:	6ce2                	ld	s9,24(sp)
    800050be:	6d42                	ld	s10,16(sp)
    800050c0:	bfe9                	j	8000509a <pipewrite+0xf4>

00000000800050c2 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800050c2:	711d                	addi	sp,sp,-96
    800050c4:	ec86                	sd	ra,88(sp)
    800050c6:	e8a2                	sd	s0,80(sp)
    800050c8:	e4a6                	sd	s1,72(sp)
    800050ca:	e0ca                	sd	s2,64(sp)
    800050cc:	fc4e                	sd	s3,56(sp)
    800050ce:	f852                	sd	s4,48(sp)
    800050d0:	f456                	sd	s5,40(sp)
    800050d2:	1080                	addi	s0,sp,96
    800050d4:	84aa                	mv	s1,a0
    800050d6:	892e                	mv	s2,a1
    800050d8:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800050da:	ffffd097          	auipc	ra,0xffffd
    800050de:	b86080e7          	jalr	-1146(ra) # 80001c60 <myproc>
    800050e2:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800050e4:	8526                	mv	a0,s1
    800050e6:	ffffc097          	auipc	ra,0xffffc
    800050ea:	c20080e7          	jalr	-992(ra) # 80000d06 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800050ee:	2184a703          	lw	a4,536(s1)
    800050f2:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800050f6:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800050fa:	02f71b63          	bne	a4,a5,80005130 <piperead+0x6e>
    800050fe:	2244a783          	lw	a5,548(s1)
    80005102:	c3b1                	beqz	a5,80005146 <piperead+0x84>
    if(killed(pr)){
    80005104:	8552                	mv	a0,s4
    80005106:	ffffd097          	auipc	ra,0xffffd
    8000510a:	5b6080e7          	jalr	1462(ra) # 800026bc <killed>
    8000510e:	e50d                	bnez	a0,80005138 <piperead+0x76>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005110:	85a6                	mv	a1,s1
    80005112:	854e                	mv	a0,s3
    80005114:	ffffd097          	auipc	ra,0xffffd
    80005118:	300080e7          	jalr	768(ra) # 80002414 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000511c:	2184a703          	lw	a4,536(s1)
    80005120:	21c4a783          	lw	a5,540(s1)
    80005124:	fcf70de3          	beq	a4,a5,800050fe <piperead+0x3c>
    80005128:	f05a                	sd	s6,32(sp)
    8000512a:	ec5e                	sd	s7,24(sp)
    8000512c:	e862                	sd	s8,16(sp)
    8000512e:	a839                	j	8000514c <piperead+0x8a>
    80005130:	f05a                	sd	s6,32(sp)
    80005132:	ec5e                	sd	s7,24(sp)
    80005134:	e862                	sd	s8,16(sp)
    80005136:	a819                	j	8000514c <piperead+0x8a>
      release(&pi->lock);
    80005138:	8526                	mv	a0,s1
    8000513a:	ffffc097          	auipc	ra,0xffffc
    8000513e:	c7c080e7          	jalr	-900(ra) # 80000db6 <release>
      return -1;
    80005142:	59fd                	li	s3,-1
    80005144:	a895                	j	800051b8 <piperead+0xf6>
    80005146:	f05a                	sd	s6,32(sp)
    80005148:	ec5e                	sd	s7,24(sp)
    8000514a:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000514c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000514e:	faf40c13          	addi	s8,s0,-81
    80005152:	4b85                	li	s7,1
    80005154:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005156:	05505363          	blez	s5,8000519c <piperead+0xda>
    if(pi->nread == pi->nwrite)
    8000515a:	2184a783          	lw	a5,536(s1)
    8000515e:	21c4a703          	lw	a4,540(s1)
    80005162:	02f70d63          	beq	a4,a5,8000519c <piperead+0xda>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80005166:	0017871b          	addiw	a4,a5,1
    8000516a:	20e4ac23          	sw	a4,536(s1)
    8000516e:	1ff7f793          	andi	a5,a5,511
    80005172:	97a6                	add	a5,a5,s1
    80005174:	0187c783          	lbu	a5,24(a5)
    80005178:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000517c:	86de                	mv	a3,s7
    8000517e:	8662                	mv	a2,s8
    80005180:	85ca                	mv	a1,s2
    80005182:	050a3503          	ld	a0,80(s4)
    80005186:	ffffc097          	auipc	ra,0xffffc
    8000518a:	652080e7          	jalr	1618(ra) # 800017d8 <copyout>
    8000518e:	01650763          	beq	a0,s6,8000519c <piperead+0xda>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005192:	2985                	addiw	s3,s3,1
    80005194:	0905                	addi	s2,s2,1
    80005196:	fd3a92e3          	bne	s5,s3,8000515a <piperead+0x98>
    8000519a:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000519c:	21c48513          	addi	a0,s1,540
    800051a0:	ffffd097          	auipc	ra,0xffffd
    800051a4:	2d8080e7          	jalr	728(ra) # 80002478 <wakeup>
  release(&pi->lock);
    800051a8:	8526                	mv	a0,s1
    800051aa:	ffffc097          	auipc	ra,0xffffc
    800051ae:	c0c080e7          	jalr	-1012(ra) # 80000db6 <release>
    800051b2:	7b02                	ld	s6,32(sp)
    800051b4:	6be2                	ld	s7,24(sp)
    800051b6:	6c42                	ld	s8,16(sp)
  return i;
}
    800051b8:	854e                	mv	a0,s3
    800051ba:	60e6                	ld	ra,88(sp)
    800051bc:	6446                	ld	s0,80(sp)
    800051be:	64a6                	ld	s1,72(sp)
    800051c0:	6906                	ld	s2,64(sp)
    800051c2:	79e2                	ld	s3,56(sp)
    800051c4:	7a42                	ld	s4,48(sp)
    800051c6:	7aa2                	ld	s5,40(sp)
    800051c8:	6125                	addi	sp,sp,96
    800051ca:	8082                	ret

00000000800051cc <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800051cc:	1141                	addi	sp,sp,-16
    800051ce:	e406                	sd	ra,8(sp)
    800051d0:	e022                	sd	s0,0(sp)
    800051d2:	0800                	addi	s0,sp,16
    800051d4:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800051d6:	0035151b          	slliw	a0,a0,0x3
    800051da:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    800051dc:	8b89                	andi	a5,a5,2
    800051de:	c399                	beqz	a5,800051e4 <flags2perm+0x18>
      perm |= PTE_W;
    800051e0:	00456513          	ori	a0,a0,4
    return perm;
}
    800051e4:	60a2                	ld	ra,8(sp)
    800051e6:	6402                	ld	s0,0(sp)
    800051e8:	0141                	addi	sp,sp,16
    800051ea:	8082                	ret

00000000800051ec <exec>:

int
exec(char *path, char **argv)
{
    800051ec:	de010113          	addi	sp,sp,-544
    800051f0:	20113c23          	sd	ra,536(sp)
    800051f4:	20813823          	sd	s0,528(sp)
    800051f8:	20913423          	sd	s1,520(sp)
    800051fc:	21213023          	sd	s2,512(sp)
    80005200:	1400                	addi	s0,sp,544
    80005202:	892a                	mv	s2,a0
    80005204:	dea43823          	sd	a0,-528(s0)
    80005208:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000520c:	ffffd097          	auipc	ra,0xffffd
    80005210:	a54080e7          	jalr	-1452(ra) # 80001c60 <myproc>
    80005214:	84aa                	mv	s1,a0

  begin_op();
    80005216:	fffff097          	auipc	ra,0xfffff
    8000521a:	3fc080e7          	jalr	1020(ra) # 80004612 <begin_op>

  if((ip = namei(path)) == 0){
    8000521e:	854a                	mv	a0,s2
    80005220:	fffff097          	auipc	ra,0xfffff
    80005224:	1ec080e7          	jalr	492(ra) # 8000440c <namei>
    80005228:	c525                	beqz	a0,80005290 <exec+0xa4>
    8000522a:	fbd2                	sd	s4,496(sp)
    8000522c:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000522e:	fffff097          	auipc	ra,0xfffff
    80005232:	9fa080e7          	jalr	-1542(ra) # 80003c28 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80005236:	04000713          	li	a4,64
    8000523a:	4681                	li	a3,0
    8000523c:	e5040613          	addi	a2,s0,-432
    80005240:	4581                	li	a1,0
    80005242:	8552                	mv	a0,s4
    80005244:	fffff097          	auipc	ra,0xfffff
    80005248:	ca0080e7          	jalr	-864(ra) # 80003ee4 <readi>
    8000524c:	04000793          	li	a5,64
    80005250:	00f51a63          	bne	a0,a5,80005264 <exec+0x78>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80005254:	e5042703          	lw	a4,-432(s0)
    80005258:	464c47b7          	lui	a5,0x464c4
    8000525c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005260:	02f70e63          	beq	a4,a5,8000529c <exec+0xb0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80005264:	8552                	mv	a0,s4
    80005266:	fffff097          	auipc	ra,0xfffff
    8000526a:	c28080e7          	jalr	-984(ra) # 80003e8e <iunlockput>
    end_op();
    8000526e:	fffff097          	auipc	ra,0xfffff
    80005272:	41e080e7          	jalr	1054(ra) # 8000468c <end_op>
  }
  return -1;
    80005276:	557d                	li	a0,-1
    80005278:	7a5e                	ld	s4,496(sp)
}
    8000527a:	21813083          	ld	ra,536(sp)
    8000527e:	21013403          	ld	s0,528(sp)
    80005282:	20813483          	ld	s1,520(sp)
    80005286:	20013903          	ld	s2,512(sp)
    8000528a:	22010113          	addi	sp,sp,544
    8000528e:	8082                	ret
    end_op();
    80005290:	fffff097          	auipc	ra,0xfffff
    80005294:	3fc080e7          	jalr	1020(ra) # 8000468c <end_op>
    return -1;
    80005298:	557d                	li	a0,-1
    8000529a:	b7c5                	j	8000527a <exec+0x8e>
    8000529c:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    8000529e:	8526                	mv	a0,s1
    800052a0:	ffffd097          	auipc	ra,0xffffd
    800052a4:	a84080e7          	jalr	-1404(ra) # 80001d24 <proc_pagetable>
    800052a8:	8b2a                	mv	s6,a0
    800052aa:	2c050163          	beqz	a0,8000556c <exec+0x380>
    800052ae:	ffce                	sd	s3,504(sp)
    800052b0:	f7d6                	sd	s5,488(sp)
    800052b2:	efde                	sd	s7,472(sp)
    800052b4:	ebe2                	sd	s8,464(sp)
    800052b6:	e7e6                	sd	s9,456(sp)
    800052b8:	e3ea                	sd	s10,448(sp)
    800052ba:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800052bc:	e7042683          	lw	a3,-400(s0)
    800052c0:	e8845783          	lhu	a5,-376(s0)
    800052c4:	10078363          	beqz	a5,800053ca <exec+0x1de>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800052c8:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800052ca:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800052cc:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    800052d0:	6c85                	lui	s9,0x1
    800052d2:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800052d6:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800052da:	6a85                	lui	s5,0x1
    800052dc:	a0b5                	j	80005348 <exec+0x15c>
      panic("loadseg: address should exist");
    800052de:	00003517          	auipc	a0,0x3
    800052e2:	3f250513          	addi	a0,a0,1010 # 800086d0 <__func__.1+0x6c8>
    800052e6:	ffffb097          	auipc	ra,0xffffb
    800052ea:	27a080e7          	jalr	634(ra) # 80000560 <panic>
    if(sz - i < PGSIZE)
    800052ee:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800052f0:	874a                	mv	a4,s2
    800052f2:	009c06bb          	addw	a3,s8,s1
    800052f6:	4581                	li	a1,0
    800052f8:	8552                	mv	a0,s4
    800052fa:	fffff097          	auipc	ra,0xfffff
    800052fe:	bea080e7          	jalr	-1046(ra) # 80003ee4 <readi>
    80005302:	26a91963          	bne	s2,a0,80005574 <exec+0x388>
  for(i = 0; i < sz; i += PGSIZE){
    80005306:	009a84bb          	addw	s1,s5,s1
    8000530a:	0334f463          	bgeu	s1,s3,80005332 <exec+0x146>
    pa = walkaddr(pagetable, va + i);
    8000530e:	02049593          	slli	a1,s1,0x20
    80005312:	9181                	srli	a1,a1,0x20
    80005314:	95de                	add	a1,a1,s7
    80005316:	855a                	mv	a0,s6
    80005318:	ffffc097          	auipc	ra,0xffffc
    8000531c:	e88080e7          	jalr	-376(ra) # 800011a0 <walkaddr>
    80005320:	862a                	mv	a2,a0
    if(pa == 0)
    80005322:	dd55                	beqz	a0,800052de <exec+0xf2>
    if(sz - i < PGSIZE)
    80005324:	409987bb          	subw	a5,s3,s1
    80005328:	893e                	mv	s2,a5
    8000532a:	fcfcf2e3          	bgeu	s9,a5,800052ee <exec+0x102>
    8000532e:	8956                	mv	s2,s5
    80005330:	bf7d                	j	800052ee <exec+0x102>
    sz = sz1;
    80005332:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005336:	2d05                	addiw	s10,s10,1
    80005338:	e0843783          	ld	a5,-504(s0)
    8000533c:	0387869b          	addiw	a3,a5,56
    80005340:	e8845783          	lhu	a5,-376(s0)
    80005344:	08fd5463          	bge	s10,a5,800053cc <exec+0x1e0>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005348:	e0d43423          	sd	a3,-504(s0)
    8000534c:	876e                	mv	a4,s11
    8000534e:	e1840613          	addi	a2,s0,-488
    80005352:	4581                	li	a1,0
    80005354:	8552                	mv	a0,s4
    80005356:	fffff097          	auipc	ra,0xfffff
    8000535a:	b8e080e7          	jalr	-1138(ra) # 80003ee4 <readi>
    8000535e:	21b51963          	bne	a0,s11,80005570 <exec+0x384>
    if(ph.type != ELF_PROG_LOAD)
    80005362:	e1842783          	lw	a5,-488(s0)
    80005366:	4705                	li	a4,1
    80005368:	fce797e3          	bne	a5,a4,80005336 <exec+0x14a>
    if(ph.memsz < ph.filesz)
    8000536c:	e4043483          	ld	s1,-448(s0)
    80005370:	e3843783          	ld	a5,-456(s0)
    80005374:	22f4e063          	bltu	s1,a5,80005594 <exec+0x3a8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005378:	e2843783          	ld	a5,-472(s0)
    8000537c:	94be                	add	s1,s1,a5
    8000537e:	20f4ee63          	bltu	s1,a5,8000559a <exec+0x3ae>
    if(ph.vaddr % PGSIZE != 0)
    80005382:	de843703          	ld	a4,-536(s0)
    80005386:	8ff9                	and	a5,a5,a4
    80005388:	20079c63          	bnez	a5,800055a0 <exec+0x3b4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000538c:	e1c42503          	lw	a0,-484(s0)
    80005390:	00000097          	auipc	ra,0x0
    80005394:	e3c080e7          	jalr	-452(ra) # 800051cc <flags2perm>
    80005398:	86aa                	mv	a3,a0
    8000539a:	8626                	mv	a2,s1
    8000539c:	85ca                	mv	a1,s2
    8000539e:	855a                	mv	a0,s6
    800053a0:	ffffc097          	auipc	ra,0xffffc
    800053a4:	1c4080e7          	jalr	452(ra) # 80001564 <uvmalloc>
    800053a8:	dea43c23          	sd	a0,-520(s0)
    800053ac:	1e050d63          	beqz	a0,800055a6 <exec+0x3ba>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800053b0:	e2843b83          	ld	s7,-472(s0)
    800053b4:	e2042c03          	lw	s8,-480(s0)
    800053b8:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800053bc:	00098463          	beqz	s3,800053c4 <exec+0x1d8>
    800053c0:	4481                	li	s1,0
    800053c2:	b7b1                	j	8000530e <exec+0x122>
    sz = sz1;
    800053c4:	df843903          	ld	s2,-520(s0)
    800053c8:	b7bd                	j	80005336 <exec+0x14a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800053ca:	4901                	li	s2,0
  iunlockput(ip);
    800053cc:	8552                	mv	a0,s4
    800053ce:	fffff097          	auipc	ra,0xfffff
    800053d2:	ac0080e7          	jalr	-1344(ra) # 80003e8e <iunlockput>
  end_op();
    800053d6:	fffff097          	auipc	ra,0xfffff
    800053da:	2b6080e7          	jalr	694(ra) # 8000468c <end_op>
  p = myproc();
    800053de:	ffffd097          	auipc	ra,0xffffd
    800053e2:	882080e7          	jalr	-1918(ra) # 80001c60 <myproc>
    800053e6:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800053e8:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800053ec:	6985                	lui	s3,0x1
    800053ee:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800053f0:	99ca                	add	s3,s3,s2
    800053f2:	77fd                	lui	a5,0xfffff
    800053f4:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800053f8:	4691                	li	a3,4
    800053fa:	6609                	lui	a2,0x2
    800053fc:	964e                	add	a2,a2,s3
    800053fe:	85ce                	mv	a1,s3
    80005400:	855a                	mv	a0,s6
    80005402:	ffffc097          	auipc	ra,0xffffc
    80005406:	162080e7          	jalr	354(ra) # 80001564 <uvmalloc>
    8000540a:	8a2a                	mv	s4,a0
    8000540c:	e115                	bnez	a0,80005430 <exec+0x244>
    proc_freepagetable(pagetable, sz);
    8000540e:	85ce                	mv	a1,s3
    80005410:	855a                	mv	a0,s6
    80005412:	ffffd097          	auipc	ra,0xffffd
    80005416:	9ae080e7          	jalr	-1618(ra) # 80001dc0 <proc_freepagetable>
  return -1;
    8000541a:	557d                	li	a0,-1
    8000541c:	79fe                	ld	s3,504(sp)
    8000541e:	7a5e                	ld	s4,496(sp)
    80005420:	7abe                	ld	s5,488(sp)
    80005422:	7b1e                	ld	s6,480(sp)
    80005424:	6bfe                	ld	s7,472(sp)
    80005426:	6c5e                	ld	s8,464(sp)
    80005428:	6cbe                	ld	s9,456(sp)
    8000542a:	6d1e                	ld	s10,448(sp)
    8000542c:	7dfa                	ld	s11,440(sp)
    8000542e:	b5b1                	j	8000527a <exec+0x8e>
  uvmclear(pagetable, sz-2*PGSIZE);
    80005430:	75f9                	lui	a1,0xffffe
    80005432:	95aa                	add	a1,a1,a0
    80005434:	855a                	mv	a0,s6
    80005436:	ffffc097          	auipc	ra,0xffffc
    8000543a:	370080e7          	jalr	880(ra) # 800017a6 <uvmclear>
  stackbase = sp - PGSIZE;
    8000543e:	7bfd                	lui	s7,0xfffff
    80005440:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    80005442:	e0043783          	ld	a5,-512(s0)
    80005446:	6388                	ld	a0,0(a5)
  sp = sz;
    80005448:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    8000544a:	4481                	li	s1,0
    ustack[argc] = sp;
    8000544c:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80005450:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80005454:	c135                	beqz	a0,800054b8 <exec+0x2cc>
    sp -= strlen(argv[argc]) + 1;
    80005456:	ffffc097          	auipc	ra,0xffffc
    8000545a:	b34080e7          	jalr	-1228(ra) # 80000f8a <strlen>
    8000545e:	0015079b          	addiw	a5,a0,1
    80005462:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005466:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000546a:	15796163          	bltu	s2,s7,800055ac <exec+0x3c0>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000546e:	e0043d83          	ld	s11,-512(s0)
    80005472:	000db983          	ld	s3,0(s11)
    80005476:	854e                	mv	a0,s3
    80005478:	ffffc097          	auipc	ra,0xffffc
    8000547c:	b12080e7          	jalr	-1262(ra) # 80000f8a <strlen>
    80005480:	0015069b          	addiw	a3,a0,1
    80005484:	864e                	mv	a2,s3
    80005486:	85ca                	mv	a1,s2
    80005488:	855a                	mv	a0,s6
    8000548a:	ffffc097          	auipc	ra,0xffffc
    8000548e:	34e080e7          	jalr	846(ra) # 800017d8 <copyout>
    80005492:	10054f63          	bltz	a0,800055b0 <exec+0x3c4>
    ustack[argc] = sp;
    80005496:	00349793          	slli	a5,s1,0x3
    8000549a:	97e6                	add	a5,a5,s9
    8000549c:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffdd140>
  for(argc = 0; argv[argc]; argc++) {
    800054a0:	0485                	addi	s1,s1,1
    800054a2:	008d8793          	addi	a5,s11,8
    800054a6:	e0f43023          	sd	a5,-512(s0)
    800054aa:	008db503          	ld	a0,8(s11)
    800054ae:	c509                	beqz	a0,800054b8 <exec+0x2cc>
    if(argc >= MAXARG)
    800054b0:	fb8493e3          	bne	s1,s8,80005456 <exec+0x26a>
  sz = sz1;
    800054b4:	89d2                	mv	s3,s4
    800054b6:	bfa1                	j	8000540e <exec+0x222>
  ustack[argc] = 0;
    800054b8:	00349793          	slli	a5,s1,0x3
    800054bc:	f9078793          	addi	a5,a5,-112
    800054c0:	97a2                	add	a5,a5,s0
    800054c2:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800054c6:	00148693          	addi	a3,s1,1
    800054ca:	068e                	slli	a3,a3,0x3
    800054cc:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800054d0:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    800054d4:	89d2                	mv	s3,s4
  if(sp < stackbase)
    800054d6:	f3796ce3          	bltu	s2,s7,8000540e <exec+0x222>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800054da:	e9040613          	addi	a2,s0,-368
    800054de:	85ca                	mv	a1,s2
    800054e0:	855a                	mv	a0,s6
    800054e2:	ffffc097          	auipc	ra,0xffffc
    800054e6:	2f6080e7          	jalr	758(ra) # 800017d8 <copyout>
    800054ea:	f20542e3          	bltz	a0,8000540e <exec+0x222>
  p->trapframe->a1 = sp;
    800054ee:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800054f2:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800054f6:	df043783          	ld	a5,-528(s0)
    800054fa:	0007c703          	lbu	a4,0(a5)
    800054fe:	cf11                	beqz	a4,8000551a <exec+0x32e>
    80005500:	0785                	addi	a5,a5,1
    if(*s == '/')
    80005502:	02f00693          	li	a3,47
    80005506:	a029                	j	80005510 <exec+0x324>
  for(last=s=path; *s; s++)
    80005508:	0785                	addi	a5,a5,1
    8000550a:	fff7c703          	lbu	a4,-1(a5)
    8000550e:	c711                	beqz	a4,8000551a <exec+0x32e>
    if(*s == '/')
    80005510:	fed71ce3          	bne	a4,a3,80005508 <exec+0x31c>
      last = s+1;
    80005514:	def43823          	sd	a5,-528(s0)
    80005518:	bfc5                	j	80005508 <exec+0x31c>
  safestrcpy(p->name, last, sizeof(p->name));
    8000551a:	4641                	li	a2,16
    8000551c:	df043583          	ld	a1,-528(s0)
    80005520:	158a8513          	addi	a0,s5,344
    80005524:	ffffc097          	auipc	ra,0xffffc
    80005528:	a30080e7          	jalr	-1488(ra) # 80000f54 <safestrcpy>
  oldpagetable = p->pagetable;
    8000552c:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80005530:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80005534:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005538:	058ab783          	ld	a5,88(s5)
    8000553c:	e6843703          	ld	a4,-408(s0)
    80005540:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80005542:	058ab783          	ld	a5,88(s5)
    80005546:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000554a:	85ea                	mv	a1,s10
    8000554c:	ffffd097          	auipc	ra,0xffffd
    80005550:	874080e7          	jalr	-1932(ra) # 80001dc0 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005554:	0004851b          	sext.w	a0,s1
    80005558:	79fe                	ld	s3,504(sp)
    8000555a:	7a5e                	ld	s4,496(sp)
    8000555c:	7abe                	ld	s5,488(sp)
    8000555e:	7b1e                	ld	s6,480(sp)
    80005560:	6bfe                	ld	s7,472(sp)
    80005562:	6c5e                	ld	s8,464(sp)
    80005564:	6cbe                	ld	s9,456(sp)
    80005566:	6d1e                	ld	s10,448(sp)
    80005568:	7dfa                	ld	s11,440(sp)
    8000556a:	bb01                	j	8000527a <exec+0x8e>
    8000556c:	7b1e                	ld	s6,480(sp)
    8000556e:	b9dd                	j	80005264 <exec+0x78>
    80005570:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80005574:	df843583          	ld	a1,-520(s0)
    80005578:	855a                	mv	a0,s6
    8000557a:	ffffd097          	auipc	ra,0xffffd
    8000557e:	846080e7          	jalr	-1978(ra) # 80001dc0 <proc_freepagetable>
  if(ip){
    80005582:	79fe                	ld	s3,504(sp)
    80005584:	7abe                	ld	s5,488(sp)
    80005586:	7b1e                	ld	s6,480(sp)
    80005588:	6bfe                	ld	s7,472(sp)
    8000558a:	6c5e                	ld	s8,464(sp)
    8000558c:	6cbe                	ld	s9,456(sp)
    8000558e:	6d1e                	ld	s10,448(sp)
    80005590:	7dfa                	ld	s11,440(sp)
    80005592:	b9c9                	j	80005264 <exec+0x78>
    80005594:	df243c23          	sd	s2,-520(s0)
    80005598:	bff1                	j	80005574 <exec+0x388>
    8000559a:	df243c23          	sd	s2,-520(s0)
    8000559e:	bfd9                	j	80005574 <exec+0x388>
    800055a0:	df243c23          	sd	s2,-520(s0)
    800055a4:	bfc1                	j	80005574 <exec+0x388>
    800055a6:	df243c23          	sd	s2,-520(s0)
    800055aa:	b7e9                	j	80005574 <exec+0x388>
  sz = sz1;
    800055ac:	89d2                	mv	s3,s4
    800055ae:	b585                	j	8000540e <exec+0x222>
    800055b0:	89d2                	mv	s3,s4
    800055b2:	bdb1                	j	8000540e <exec+0x222>

00000000800055b4 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800055b4:	7179                	addi	sp,sp,-48
    800055b6:	f406                	sd	ra,40(sp)
    800055b8:	f022                	sd	s0,32(sp)
    800055ba:	ec26                	sd	s1,24(sp)
    800055bc:	e84a                	sd	s2,16(sp)
    800055be:	1800                	addi	s0,sp,48
    800055c0:	892e                	mv	s2,a1
    800055c2:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800055c4:	fdc40593          	addi	a1,s0,-36
    800055c8:	ffffe097          	auipc	ra,0xffffe
    800055cc:	9a2080e7          	jalr	-1630(ra) # 80002f6a <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800055d0:	fdc42703          	lw	a4,-36(s0)
    800055d4:	47bd                	li	a5,15
    800055d6:	02e7eb63          	bltu	a5,a4,8000560c <argfd+0x58>
    800055da:	ffffc097          	auipc	ra,0xffffc
    800055de:	686080e7          	jalr	1670(ra) # 80001c60 <myproc>
    800055e2:	fdc42703          	lw	a4,-36(s0)
    800055e6:	01a70793          	addi	a5,a4,26
    800055ea:	078e                	slli	a5,a5,0x3
    800055ec:	953e                	add	a0,a0,a5
    800055ee:	611c                	ld	a5,0(a0)
    800055f0:	c385                	beqz	a5,80005610 <argfd+0x5c>
    return -1;
  if(pfd)
    800055f2:	00090463          	beqz	s2,800055fa <argfd+0x46>
    *pfd = fd;
    800055f6:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800055fa:	4501                	li	a0,0
  if(pf)
    800055fc:	c091                	beqz	s1,80005600 <argfd+0x4c>
    *pf = f;
    800055fe:	e09c                	sd	a5,0(s1)
}
    80005600:	70a2                	ld	ra,40(sp)
    80005602:	7402                	ld	s0,32(sp)
    80005604:	64e2                	ld	s1,24(sp)
    80005606:	6942                	ld	s2,16(sp)
    80005608:	6145                	addi	sp,sp,48
    8000560a:	8082                	ret
    return -1;
    8000560c:	557d                	li	a0,-1
    8000560e:	bfcd                	j	80005600 <argfd+0x4c>
    80005610:	557d                	li	a0,-1
    80005612:	b7fd                	j	80005600 <argfd+0x4c>

0000000080005614 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005614:	1101                	addi	sp,sp,-32
    80005616:	ec06                	sd	ra,24(sp)
    80005618:	e822                	sd	s0,16(sp)
    8000561a:	e426                	sd	s1,8(sp)
    8000561c:	1000                	addi	s0,sp,32
    8000561e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005620:	ffffc097          	auipc	ra,0xffffc
    80005624:	640080e7          	jalr	1600(ra) # 80001c60 <myproc>
    80005628:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000562a:	0d050793          	addi	a5,a0,208
    8000562e:	4501                	li	a0,0
    80005630:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005632:	6398                	ld	a4,0(a5)
    80005634:	cb19                	beqz	a4,8000564a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005636:	2505                	addiw	a0,a0,1
    80005638:	07a1                	addi	a5,a5,8
    8000563a:	fed51ce3          	bne	a0,a3,80005632 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000563e:	557d                	li	a0,-1
}
    80005640:	60e2                	ld	ra,24(sp)
    80005642:	6442                	ld	s0,16(sp)
    80005644:	64a2                	ld	s1,8(sp)
    80005646:	6105                	addi	sp,sp,32
    80005648:	8082                	ret
      p->ofile[fd] = f;
    8000564a:	01a50793          	addi	a5,a0,26
    8000564e:	078e                	slli	a5,a5,0x3
    80005650:	963e                	add	a2,a2,a5
    80005652:	e204                	sd	s1,0(a2)
      return fd;
    80005654:	b7f5                	j	80005640 <fdalloc+0x2c>

0000000080005656 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005656:	715d                	addi	sp,sp,-80
    80005658:	e486                	sd	ra,72(sp)
    8000565a:	e0a2                	sd	s0,64(sp)
    8000565c:	fc26                	sd	s1,56(sp)
    8000565e:	f84a                	sd	s2,48(sp)
    80005660:	f44e                	sd	s3,40(sp)
    80005662:	ec56                	sd	s5,24(sp)
    80005664:	e85a                	sd	s6,16(sp)
    80005666:	0880                	addi	s0,sp,80
    80005668:	8b2e                	mv	s6,a1
    8000566a:	89b2                	mv	s3,a2
    8000566c:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000566e:	fb040593          	addi	a1,s0,-80
    80005672:	fffff097          	auipc	ra,0xfffff
    80005676:	db8080e7          	jalr	-584(ra) # 8000442a <nameiparent>
    8000567a:	84aa                	mv	s1,a0
    8000567c:	14050e63          	beqz	a0,800057d8 <create+0x182>
    return 0;

  ilock(dp);
    80005680:	ffffe097          	auipc	ra,0xffffe
    80005684:	5a8080e7          	jalr	1448(ra) # 80003c28 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005688:	4601                	li	a2,0
    8000568a:	fb040593          	addi	a1,s0,-80
    8000568e:	8526                	mv	a0,s1
    80005690:	fffff097          	auipc	ra,0xfffff
    80005694:	a94080e7          	jalr	-1388(ra) # 80004124 <dirlookup>
    80005698:	8aaa                	mv	s5,a0
    8000569a:	c539                	beqz	a0,800056e8 <create+0x92>
    iunlockput(dp);
    8000569c:	8526                	mv	a0,s1
    8000569e:	ffffe097          	auipc	ra,0xffffe
    800056a2:	7f0080e7          	jalr	2032(ra) # 80003e8e <iunlockput>
    ilock(ip);
    800056a6:	8556                	mv	a0,s5
    800056a8:	ffffe097          	auipc	ra,0xffffe
    800056ac:	580080e7          	jalr	1408(ra) # 80003c28 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800056b0:	4789                	li	a5,2
    800056b2:	02fb1463          	bne	s6,a5,800056da <create+0x84>
    800056b6:	044ad783          	lhu	a5,68(s5)
    800056ba:	37f9                	addiw	a5,a5,-2
    800056bc:	17c2                	slli	a5,a5,0x30
    800056be:	93c1                	srli	a5,a5,0x30
    800056c0:	4705                	li	a4,1
    800056c2:	00f76c63          	bltu	a4,a5,800056da <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800056c6:	8556                	mv	a0,s5
    800056c8:	60a6                	ld	ra,72(sp)
    800056ca:	6406                	ld	s0,64(sp)
    800056cc:	74e2                	ld	s1,56(sp)
    800056ce:	7942                	ld	s2,48(sp)
    800056d0:	79a2                	ld	s3,40(sp)
    800056d2:	6ae2                	ld	s5,24(sp)
    800056d4:	6b42                	ld	s6,16(sp)
    800056d6:	6161                	addi	sp,sp,80
    800056d8:	8082                	ret
    iunlockput(ip);
    800056da:	8556                	mv	a0,s5
    800056dc:	ffffe097          	auipc	ra,0xffffe
    800056e0:	7b2080e7          	jalr	1970(ra) # 80003e8e <iunlockput>
    return 0;
    800056e4:	4a81                	li	s5,0
    800056e6:	b7c5                	j	800056c6 <create+0x70>
    800056e8:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    800056ea:	85da                	mv	a1,s6
    800056ec:	4088                	lw	a0,0(s1)
    800056ee:	ffffe097          	auipc	ra,0xffffe
    800056f2:	396080e7          	jalr	918(ra) # 80003a84 <ialloc>
    800056f6:	8a2a                	mv	s4,a0
    800056f8:	c531                	beqz	a0,80005744 <create+0xee>
  ilock(ip);
    800056fa:	ffffe097          	auipc	ra,0xffffe
    800056fe:	52e080e7          	jalr	1326(ra) # 80003c28 <ilock>
  ip->major = major;
    80005702:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80005706:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000570a:	4905                	li	s2,1
    8000570c:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80005710:	8552                	mv	a0,s4
    80005712:	ffffe097          	auipc	ra,0xffffe
    80005716:	44a080e7          	jalr	1098(ra) # 80003b5c <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000571a:	032b0d63          	beq	s6,s2,80005754 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    8000571e:	004a2603          	lw	a2,4(s4)
    80005722:	fb040593          	addi	a1,s0,-80
    80005726:	8526                	mv	a0,s1
    80005728:	fffff097          	auipc	ra,0xfffff
    8000572c:	c22080e7          	jalr	-990(ra) # 8000434a <dirlink>
    80005730:	08054163          	bltz	a0,800057b2 <create+0x15c>
  iunlockput(dp);
    80005734:	8526                	mv	a0,s1
    80005736:	ffffe097          	auipc	ra,0xffffe
    8000573a:	758080e7          	jalr	1880(ra) # 80003e8e <iunlockput>
  return ip;
    8000573e:	8ad2                	mv	s5,s4
    80005740:	7a02                	ld	s4,32(sp)
    80005742:	b751                	j	800056c6 <create+0x70>
    iunlockput(dp);
    80005744:	8526                	mv	a0,s1
    80005746:	ffffe097          	auipc	ra,0xffffe
    8000574a:	748080e7          	jalr	1864(ra) # 80003e8e <iunlockput>
    return 0;
    8000574e:	8ad2                	mv	s5,s4
    80005750:	7a02                	ld	s4,32(sp)
    80005752:	bf95                	j	800056c6 <create+0x70>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005754:	004a2603          	lw	a2,4(s4)
    80005758:	00003597          	auipc	a1,0x3
    8000575c:	f9858593          	addi	a1,a1,-104 # 800086f0 <__func__.1+0x6e8>
    80005760:	8552                	mv	a0,s4
    80005762:	fffff097          	auipc	ra,0xfffff
    80005766:	be8080e7          	jalr	-1048(ra) # 8000434a <dirlink>
    8000576a:	04054463          	bltz	a0,800057b2 <create+0x15c>
    8000576e:	40d0                	lw	a2,4(s1)
    80005770:	00003597          	auipc	a1,0x3
    80005774:	f8858593          	addi	a1,a1,-120 # 800086f8 <__func__.1+0x6f0>
    80005778:	8552                	mv	a0,s4
    8000577a:	fffff097          	auipc	ra,0xfffff
    8000577e:	bd0080e7          	jalr	-1072(ra) # 8000434a <dirlink>
    80005782:	02054863          	bltz	a0,800057b2 <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    80005786:	004a2603          	lw	a2,4(s4)
    8000578a:	fb040593          	addi	a1,s0,-80
    8000578e:	8526                	mv	a0,s1
    80005790:	fffff097          	auipc	ra,0xfffff
    80005794:	bba080e7          	jalr	-1094(ra) # 8000434a <dirlink>
    80005798:	00054d63          	bltz	a0,800057b2 <create+0x15c>
    dp->nlink++;  // for ".."
    8000579c:	04a4d783          	lhu	a5,74(s1)
    800057a0:	2785                	addiw	a5,a5,1
    800057a2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800057a6:	8526                	mv	a0,s1
    800057a8:	ffffe097          	auipc	ra,0xffffe
    800057ac:	3b4080e7          	jalr	948(ra) # 80003b5c <iupdate>
    800057b0:	b751                	j	80005734 <create+0xde>
  ip->nlink = 0;
    800057b2:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800057b6:	8552                	mv	a0,s4
    800057b8:	ffffe097          	auipc	ra,0xffffe
    800057bc:	3a4080e7          	jalr	932(ra) # 80003b5c <iupdate>
  iunlockput(ip);
    800057c0:	8552                	mv	a0,s4
    800057c2:	ffffe097          	auipc	ra,0xffffe
    800057c6:	6cc080e7          	jalr	1740(ra) # 80003e8e <iunlockput>
  iunlockput(dp);
    800057ca:	8526                	mv	a0,s1
    800057cc:	ffffe097          	auipc	ra,0xffffe
    800057d0:	6c2080e7          	jalr	1730(ra) # 80003e8e <iunlockput>
  return 0;
    800057d4:	7a02                	ld	s4,32(sp)
    800057d6:	bdc5                	j	800056c6 <create+0x70>
    return 0;
    800057d8:	8aaa                	mv	s5,a0
    800057da:	b5f5                	j	800056c6 <create+0x70>

00000000800057dc <sys_dup>:
{
    800057dc:	7179                	addi	sp,sp,-48
    800057de:	f406                	sd	ra,40(sp)
    800057e0:	f022                	sd	s0,32(sp)
    800057e2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800057e4:	fd840613          	addi	a2,s0,-40
    800057e8:	4581                	li	a1,0
    800057ea:	4501                	li	a0,0
    800057ec:	00000097          	auipc	ra,0x0
    800057f0:	dc8080e7          	jalr	-568(ra) # 800055b4 <argfd>
    return -1;
    800057f4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800057f6:	02054763          	bltz	a0,80005824 <sys_dup+0x48>
    800057fa:	ec26                	sd	s1,24(sp)
    800057fc:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800057fe:	fd843903          	ld	s2,-40(s0)
    80005802:	854a                	mv	a0,s2
    80005804:	00000097          	auipc	ra,0x0
    80005808:	e10080e7          	jalr	-496(ra) # 80005614 <fdalloc>
    8000580c:	84aa                	mv	s1,a0
    return -1;
    8000580e:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005810:	00054f63          	bltz	a0,8000582e <sys_dup+0x52>
  filedup(f);
    80005814:	854a                	mv	a0,s2
    80005816:	fffff097          	auipc	ra,0xfffff
    8000581a:	27a080e7          	jalr	634(ra) # 80004a90 <filedup>
  return fd;
    8000581e:	87a6                	mv	a5,s1
    80005820:	64e2                	ld	s1,24(sp)
    80005822:	6942                	ld	s2,16(sp)
}
    80005824:	853e                	mv	a0,a5
    80005826:	70a2                	ld	ra,40(sp)
    80005828:	7402                	ld	s0,32(sp)
    8000582a:	6145                	addi	sp,sp,48
    8000582c:	8082                	ret
    8000582e:	64e2                	ld	s1,24(sp)
    80005830:	6942                	ld	s2,16(sp)
    80005832:	bfcd                	j	80005824 <sys_dup+0x48>

0000000080005834 <sys_read>:
{
    80005834:	7179                	addi	sp,sp,-48
    80005836:	f406                	sd	ra,40(sp)
    80005838:	f022                	sd	s0,32(sp)
    8000583a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000583c:	fd840593          	addi	a1,s0,-40
    80005840:	4505                	li	a0,1
    80005842:	ffffd097          	auipc	ra,0xffffd
    80005846:	748080e7          	jalr	1864(ra) # 80002f8a <argaddr>
  argint(2, &n);
    8000584a:	fe440593          	addi	a1,s0,-28
    8000584e:	4509                	li	a0,2
    80005850:	ffffd097          	auipc	ra,0xffffd
    80005854:	71a080e7          	jalr	1818(ra) # 80002f6a <argint>
  if(argfd(0, 0, &f) < 0)
    80005858:	fe840613          	addi	a2,s0,-24
    8000585c:	4581                	li	a1,0
    8000585e:	4501                	li	a0,0
    80005860:	00000097          	auipc	ra,0x0
    80005864:	d54080e7          	jalr	-684(ra) # 800055b4 <argfd>
    80005868:	87aa                	mv	a5,a0
    return -1;
    8000586a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000586c:	0007cc63          	bltz	a5,80005884 <sys_read+0x50>
  return fileread(f, p, n);
    80005870:	fe442603          	lw	a2,-28(s0)
    80005874:	fd843583          	ld	a1,-40(s0)
    80005878:	fe843503          	ld	a0,-24(s0)
    8000587c:	fffff097          	auipc	ra,0xfffff
    80005880:	3ba080e7          	jalr	954(ra) # 80004c36 <fileread>
}
    80005884:	70a2                	ld	ra,40(sp)
    80005886:	7402                	ld	s0,32(sp)
    80005888:	6145                	addi	sp,sp,48
    8000588a:	8082                	ret

000000008000588c <sys_write>:
{
    8000588c:	7179                	addi	sp,sp,-48
    8000588e:	f406                	sd	ra,40(sp)
    80005890:	f022                	sd	s0,32(sp)
    80005892:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005894:	fd840593          	addi	a1,s0,-40
    80005898:	4505                	li	a0,1
    8000589a:	ffffd097          	auipc	ra,0xffffd
    8000589e:	6f0080e7          	jalr	1776(ra) # 80002f8a <argaddr>
  argint(2, &n);
    800058a2:	fe440593          	addi	a1,s0,-28
    800058a6:	4509                	li	a0,2
    800058a8:	ffffd097          	auipc	ra,0xffffd
    800058ac:	6c2080e7          	jalr	1730(ra) # 80002f6a <argint>
  if(argfd(0, 0, &f) < 0)
    800058b0:	fe840613          	addi	a2,s0,-24
    800058b4:	4581                	li	a1,0
    800058b6:	4501                	li	a0,0
    800058b8:	00000097          	auipc	ra,0x0
    800058bc:	cfc080e7          	jalr	-772(ra) # 800055b4 <argfd>
    800058c0:	87aa                	mv	a5,a0
    return -1;
    800058c2:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800058c4:	0007cc63          	bltz	a5,800058dc <sys_write+0x50>
  return filewrite(f, p, n);
    800058c8:	fe442603          	lw	a2,-28(s0)
    800058cc:	fd843583          	ld	a1,-40(s0)
    800058d0:	fe843503          	ld	a0,-24(s0)
    800058d4:	fffff097          	auipc	ra,0xfffff
    800058d8:	434080e7          	jalr	1076(ra) # 80004d08 <filewrite>
}
    800058dc:	70a2                	ld	ra,40(sp)
    800058de:	7402                	ld	s0,32(sp)
    800058e0:	6145                	addi	sp,sp,48
    800058e2:	8082                	ret

00000000800058e4 <sys_close>:
{
    800058e4:	1101                	addi	sp,sp,-32
    800058e6:	ec06                	sd	ra,24(sp)
    800058e8:	e822                	sd	s0,16(sp)
    800058ea:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800058ec:	fe040613          	addi	a2,s0,-32
    800058f0:	fec40593          	addi	a1,s0,-20
    800058f4:	4501                	li	a0,0
    800058f6:	00000097          	auipc	ra,0x0
    800058fa:	cbe080e7          	jalr	-834(ra) # 800055b4 <argfd>
    return -1;
    800058fe:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005900:	02054463          	bltz	a0,80005928 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005904:	ffffc097          	auipc	ra,0xffffc
    80005908:	35c080e7          	jalr	860(ra) # 80001c60 <myproc>
    8000590c:	fec42783          	lw	a5,-20(s0)
    80005910:	07e9                	addi	a5,a5,26
    80005912:	078e                	slli	a5,a5,0x3
    80005914:	953e                	add	a0,a0,a5
    80005916:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000591a:	fe043503          	ld	a0,-32(s0)
    8000591e:	fffff097          	auipc	ra,0xfffff
    80005922:	1c4080e7          	jalr	452(ra) # 80004ae2 <fileclose>
  return 0;
    80005926:	4781                	li	a5,0
}
    80005928:	853e                	mv	a0,a5
    8000592a:	60e2                	ld	ra,24(sp)
    8000592c:	6442                	ld	s0,16(sp)
    8000592e:	6105                	addi	sp,sp,32
    80005930:	8082                	ret

0000000080005932 <sys_fstat>:
{
    80005932:	1101                	addi	sp,sp,-32
    80005934:	ec06                	sd	ra,24(sp)
    80005936:	e822                	sd	s0,16(sp)
    80005938:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000593a:	fe040593          	addi	a1,s0,-32
    8000593e:	4505                	li	a0,1
    80005940:	ffffd097          	auipc	ra,0xffffd
    80005944:	64a080e7          	jalr	1610(ra) # 80002f8a <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005948:	fe840613          	addi	a2,s0,-24
    8000594c:	4581                	li	a1,0
    8000594e:	4501                	li	a0,0
    80005950:	00000097          	auipc	ra,0x0
    80005954:	c64080e7          	jalr	-924(ra) # 800055b4 <argfd>
    80005958:	87aa                	mv	a5,a0
    return -1;
    8000595a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000595c:	0007ca63          	bltz	a5,80005970 <sys_fstat+0x3e>
  return filestat(f, st);
    80005960:	fe043583          	ld	a1,-32(s0)
    80005964:	fe843503          	ld	a0,-24(s0)
    80005968:	fffff097          	auipc	ra,0xfffff
    8000596c:	258080e7          	jalr	600(ra) # 80004bc0 <filestat>
}
    80005970:	60e2                	ld	ra,24(sp)
    80005972:	6442                	ld	s0,16(sp)
    80005974:	6105                	addi	sp,sp,32
    80005976:	8082                	ret

0000000080005978 <sys_link>:
{
    80005978:	7169                	addi	sp,sp,-304
    8000597a:	f606                	sd	ra,296(sp)
    8000597c:	f222                	sd	s0,288(sp)
    8000597e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005980:	08000613          	li	a2,128
    80005984:	ed040593          	addi	a1,s0,-304
    80005988:	4501                	li	a0,0
    8000598a:	ffffd097          	auipc	ra,0xffffd
    8000598e:	620080e7          	jalr	1568(ra) # 80002faa <argstr>
    return -1;
    80005992:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005994:	12054663          	bltz	a0,80005ac0 <sys_link+0x148>
    80005998:	08000613          	li	a2,128
    8000599c:	f5040593          	addi	a1,s0,-176
    800059a0:	4505                	li	a0,1
    800059a2:	ffffd097          	auipc	ra,0xffffd
    800059a6:	608080e7          	jalr	1544(ra) # 80002faa <argstr>
    return -1;
    800059aa:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800059ac:	10054a63          	bltz	a0,80005ac0 <sys_link+0x148>
    800059b0:	ee26                	sd	s1,280(sp)
  begin_op();
    800059b2:	fffff097          	auipc	ra,0xfffff
    800059b6:	c60080e7          	jalr	-928(ra) # 80004612 <begin_op>
  if((ip = namei(old)) == 0){
    800059ba:	ed040513          	addi	a0,s0,-304
    800059be:	fffff097          	auipc	ra,0xfffff
    800059c2:	a4e080e7          	jalr	-1458(ra) # 8000440c <namei>
    800059c6:	84aa                	mv	s1,a0
    800059c8:	c949                	beqz	a0,80005a5a <sys_link+0xe2>
  ilock(ip);
    800059ca:	ffffe097          	auipc	ra,0xffffe
    800059ce:	25e080e7          	jalr	606(ra) # 80003c28 <ilock>
  if(ip->type == T_DIR){
    800059d2:	04449703          	lh	a4,68(s1)
    800059d6:	4785                	li	a5,1
    800059d8:	08f70863          	beq	a4,a5,80005a68 <sys_link+0xf0>
    800059dc:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800059de:	04a4d783          	lhu	a5,74(s1)
    800059e2:	2785                	addiw	a5,a5,1
    800059e4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800059e8:	8526                	mv	a0,s1
    800059ea:	ffffe097          	auipc	ra,0xffffe
    800059ee:	172080e7          	jalr	370(ra) # 80003b5c <iupdate>
  iunlock(ip);
    800059f2:	8526                	mv	a0,s1
    800059f4:	ffffe097          	auipc	ra,0xffffe
    800059f8:	2fa080e7          	jalr	762(ra) # 80003cee <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800059fc:	fd040593          	addi	a1,s0,-48
    80005a00:	f5040513          	addi	a0,s0,-176
    80005a04:	fffff097          	auipc	ra,0xfffff
    80005a08:	a26080e7          	jalr	-1498(ra) # 8000442a <nameiparent>
    80005a0c:	892a                	mv	s2,a0
    80005a0e:	cd35                	beqz	a0,80005a8a <sys_link+0x112>
  ilock(dp);
    80005a10:	ffffe097          	auipc	ra,0xffffe
    80005a14:	218080e7          	jalr	536(ra) # 80003c28 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005a18:	00092703          	lw	a4,0(s2)
    80005a1c:	409c                	lw	a5,0(s1)
    80005a1e:	06f71163          	bne	a4,a5,80005a80 <sys_link+0x108>
    80005a22:	40d0                	lw	a2,4(s1)
    80005a24:	fd040593          	addi	a1,s0,-48
    80005a28:	854a                	mv	a0,s2
    80005a2a:	fffff097          	auipc	ra,0xfffff
    80005a2e:	920080e7          	jalr	-1760(ra) # 8000434a <dirlink>
    80005a32:	04054763          	bltz	a0,80005a80 <sys_link+0x108>
  iunlockput(dp);
    80005a36:	854a                	mv	a0,s2
    80005a38:	ffffe097          	auipc	ra,0xffffe
    80005a3c:	456080e7          	jalr	1110(ra) # 80003e8e <iunlockput>
  iput(ip);
    80005a40:	8526                	mv	a0,s1
    80005a42:	ffffe097          	auipc	ra,0xffffe
    80005a46:	3a4080e7          	jalr	932(ra) # 80003de6 <iput>
  end_op();
    80005a4a:	fffff097          	auipc	ra,0xfffff
    80005a4e:	c42080e7          	jalr	-958(ra) # 8000468c <end_op>
  return 0;
    80005a52:	4781                	li	a5,0
    80005a54:	64f2                	ld	s1,280(sp)
    80005a56:	6952                	ld	s2,272(sp)
    80005a58:	a0a5                	j	80005ac0 <sys_link+0x148>
    end_op();
    80005a5a:	fffff097          	auipc	ra,0xfffff
    80005a5e:	c32080e7          	jalr	-974(ra) # 8000468c <end_op>
    return -1;
    80005a62:	57fd                	li	a5,-1
    80005a64:	64f2                	ld	s1,280(sp)
    80005a66:	a8a9                	j	80005ac0 <sys_link+0x148>
    iunlockput(ip);
    80005a68:	8526                	mv	a0,s1
    80005a6a:	ffffe097          	auipc	ra,0xffffe
    80005a6e:	424080e7          	jalr	1060(ra) # 80003e8e <iunlockput>
    end_op();
    80005a72:	fffff097          	auipc	ra,0xfffff
    80005a76:	c1a080e7          	jalr	-998(ra) # 8000468c <end_op>
    return -1;
    80005a7a:	57fd                	li	a5,-1
    80005a7c:	64f2                	ld	s1,280(sp)
    80005a7e:	a089                	j	80005ac0 <sys_link+0x148>
    iunlockput(dp);
    80005a80:	854a                	mv	a0,s2
    80005a82:	ffffe097          	auipc	ra,0xffffe
    80005a86:	40c080e7          	jalr	1036(ra) # 80003e8e <iunlockput>
  ilock(ip);
    80005a8a:	8526                	mv	a0,s1
    80005a8c:	ffffe097          	auipc	ra,0xffffe
    80005a90:	19c080e7          	jalr	412(ra) # 80003c28 <ilock>
  ip->nlink--;
    80005a94:	04a4d783          	lhu	a5,74(s1)
    80005a98:	37fd                	addiw	a5,a5,-1
    80005a9a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005a9e:	8526                	mv	a0,s1
    80005aa0:	ffffe097          	auipc	ra,0xffffe
    80005aa4:	0bc080e7          	jalr	188(ra) # 80003b5c <iupdate>
  iunlockput(ip);
    80005aa8:	8526                	mv	a0,s1
    80005aaa:	ffffe097          	auipc	ra,0xffffe
    80005aae:	3e4080e7          	jalr	996(ra) # 80003e8e <iunlockput>
  end_op();
    80005ab2:	fffff097          	auipc	ra,0xfffff
    80005ab6:	bda080e7          	jalr	-1062(ra) # 8000468c <end_op>
  return -1;
    80005aba:	57fd                	li	a5,-1
    80005abc:	64f2                	ld	s1,280(sp)
    80005abe:	6952                	ld	s2,272(sp)
}
    80005ac0:	853e                	mv	a0,a5
    80005ac2:	70b2                	ld	ra,296(sp)
    80005ac4:	7412                	ld	s0,288(sp)
    80005ac6:	6155                	addi	sp,sp,304
    80005ac8:	8082                	ret

0000000080005aca <sys_unlink>:
{
    80005aca:	7111                	addi	sp,sp,-256
    80005acc:	fd86                	sd	ra,248(sp)
    80005ace:	f9a2                	sd	s0,240(sp)
    80005ad0:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    80005ad2:	08000613          	li	a2,128
    80005ad6:	f2040593          	addi	a1,s0,-224
    80005ada:	4501                	li	a0,0
    80005adc:	ffffd097          	auipc	ra,0xffffd
    80005ae0:	4ce080e7          	jalr	1230(ra) # 80002faa <argstr>
    80005ae4:	1c054063          	bltz	a0,80005ca4 <sys_unlink+0x1da>
    80005ae8:	f5a6                	sd	s1,232(sp)
  begin_op();
    80005aea:	fffff097          	auipc	ra,0xfffff
    80005aee:	b28080e7          	jalr	-1240(ra) # 80004612 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005af2:	fa040593          	addi	a1,s0,-96
    80005af6:	f2040513          	addi	a0,s0,-224
    80005afa:	fffff097          	auipc	ra,0xfffff
    80005afe:	930080e7          	jalr	-1744(ra) # 8000442a <nameiparent>
    80005b02:	84aa                	mv	s1,a0
    80005b04:	c165                	beqz	a0,80005be4 <sys_unlink+0x11a>
  ilock(dp);
    80005b06:	ffffe097          	auipc	ra,0xffffe
    80005b0a:	122080e7          	jalr	290(ra) # 80003c28 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005b0e:	00003597          	auipc	a1,0x3
    80005b12:	be258593          	addi	a1,a1,-1054 # 800086f0 <__func__.1+0x6e8>
    80005b16:	fa040513          	addi	a0,s0,-96
    80005b1a:	ffffe097          	auipc	ra,0xffffe
    80005b1e:	5f0080e7          	jalr	1520(ra) # 8000410a <namecmp>
    80005b22:	16050263          	beqz	a0,80005c86 <sys_unlink+0x1bc>
    80005b26:	00003597          	auipc	a1,0x3
    80005b2a:	bd258593          	addi	a1,a1,-1070 # 800086f8 <__func__.1+0x6f0>
    80005b2e:	fa040513          	addi	a0,s0,-96
    80005b32:	ffffe097          	auipc	ra,0xffffe
    80005b36:	5d8080e7          	jalr	1496(ra) # 8000410a <namecmp>
    80005b3a:	14050663          	beqz	a0,80005c86 <sys_unlink+0x1bc>
    80005b3e:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005b40:	f1c40613          	addi	a2,s0,-228
    80005b44:	fa040593          	addi	a1,s0,-96
    80005b48:	8526                	mv	a0,s1
    80005b4a:	ffffe097          	auipc	ra,0xffffe
    80005b4e:	5da080e7          	jalr	1498(ra) # 80004124 <dirlookup>
    80005b52:	892a                	mv	s2,a0
    80005b54:	12050863          	beqz	a0,80005c84 <sys_unlink+0x1ba>
    80005b58:	edce                	sd	s3,216(sp)
  ilock(ip);
    80005b5a:	ffffe097          	auipc	ra,0xffffe
    80005b5e:	0ce080e7          	jalr	206(ra) # 80003c28 <ilock>
  if(ip->nlink < 1)
    80005b62:	04a91783          	lh	a5,74(s2)
    80005b66:	08f05663          	blez	a5,80005bf2 <sys_unlink+0x128>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005b6a:	04491703          	lh	a4,68(s2)
    80005b6e:	4785                	li	a5,1
    80005b70:	08f70b63          	beq	a4,a5,80005c06 <sys_unlink+0x13c>
  memset(&de, 0, sizeof(de));
    80005b74:	fb040993          	addi	s3,s0,-80
    80005b78:	4641                	li	a2,16
    80005b7a:	4581                	li	a1,0
    80005b7c:	854e                	mv	a0,s3
    80005b7e:	ffffb097          	auipc	ra,0xffffb
    80005b82:	280080e7          	jalr	640(ra) # 80000dfe <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005b86:	4741                	li	a4,16
    80005b88:	f1c42683          	lw	a3,-228(s0)
    80005b8c:	864e                	mv	a2,s3
    80005b8e:	4581                	li	a1,0
    80005b90:	8526                	mv	a0,s1
    80005b92:	ffffe097          	auipc	ra,0xffffe
    80005b96:	458080e7          	jalr	1112(ra) # 80003fea <writei>
    80005b9a:	47c1                	li	a5,16
    80005b9c:	0af51f63          	bne	a0,a5,80005c5a <sys_unlink+0x190>
  if(ip->type == T_DIR){
    80005ba0:	04491703          	lh	a4,68(s2)
    80005ba4:	4785                	li	a5,1
    80005ba6:	0cf70463          	beq	a4,a5,80005c6e <sys_unlink+0x1a4>
  iunlockput(dp);
    80005baa:	8526                	mv	a0,s1
    80005bac:	ffffe097          	auipc	ra,0xffffe
    80005bb0:	2e2080e7          	jalr	738(ra) # 80003e8e <iunlockput>
  ip->nlink--;
    80005bb4:	04a95783          	lhu	a5,74(s2)
    80005bb8:	37fd                	addiw	a5,a5,-1
    80005bba:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005bbe:	854a                	mv	a0,s2
    80005bc0:	ffffe097          	auipc	ra,0xffffe
    80005bc4:	f9c080e7          	jalr	-100(ra) # 80003b5c <iupdate>
  iunlockput(ip);
    80005bc8:	854a                	mv	a0,s2
    80005bca:	ffffe097          	auipc	ra,0xffffe
    80005bce:	2c4080e7          	jalr	708(ra) # 80003e8e <iunlockput>
  end_op();
    80005bd2:	fffff097          	auipc	ra,0xfffff
    80005bd6:	aba080e7          	jalr	-1350(ra) # 8000468c <end_op>
  return 0;
    80005bda:	4501                	li	a0,0
    80005bdc:	74ae                	ld	s1,232(sp)
    80005bde:	790e                	ld	s2,224(sp)
    80005be0:	69ee                	ld	s3,216(sp)
    80005be2:	a86d                	j	80005c9c <sys_unlink+0x1d2>
    end_op();
    80005be4:	fffff097          	auipc	ra,0xfffff
    80005be8:	aa8080e7          	jalr	-1368(ra) # 8000468c <end_op>
    return -1;
    80005bec:	557d                	li	a0,-1
    80005bee:	74ae                	ld	s1,232(sp)
    80005bf0:	a075                	j	80005c9c <sys_unlink+0x1d2>
    80005bf2:	e9d2                	sd	s4,208(sp)
    80005bf4:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    80005bf6:	00003517          	auipc	a0,0x3
    80005bfa:	b0a50513          	addi	a0,a0,-1270 # 80008700 <__func__.1+0x6f8>
    80005bfe:	ffffb097          	auipc	ra,0xffffb
    80005c02:	962080e7          	jalr	-1694(ra) # 80000560 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005c06:	04c92703          	lw	a4,76(s2)
    80005c0a:	02000793          	li	a5,32
    80005c0e:	f6e7f3e3          	bgeu	a5,a4,80005b74 <sys_unlink+0xaa>
    80005c12:	e9d2                	sd	s4,208(sp)
    80005c14:	e5d6                	sd	s5,200(sp)
    80005c16:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005c18:	f0840a93          	addi	s5,s0,-248
    80005c1c:	4a41                	li	s4,16
    80005c1e:	8752                	mv	a4,s4
    80005c20:	86ce                	mv	a3,s3
    80005c22:	8656                	mv	a2,s5
    80005c24:	4581                	li	a1,0
    80005c26:	854a                	mv	a0,s2
    80005c28:	ffffe097          	auipc	ra,0xffffe
    80005c2c:	2bc080e7          	jalr	700(ra) # 80003ee4 <readi>
    80005c30:	01451d63          	bne	a0,s4,80005c4a <sys_unlink+0x180>
    if(de.inum != 0)
    80005c34:	f0845783          	lhu	a5,-248(s0)
    80005c38:	eba5                	bnez	a5,80005ca8 <sys_unlink+0x1de>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005c3a:	29c1                	addiw	s3,s3,16
    80005c3c:	04c92783          	lw	a5,76(s2)
    80005c40:	fcf9efe3          	bltu	s3,a5,80005c1e <sys_unlink+0x154>
    80005c44:	6a4e                	ld	s4,208(sp)
    80005c46:	6aae                	ld	s5,200(sp)
    80005c48:	b735                	j	80005b74 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005c4a:	00003517          	auipc	a0,0x3
    80005c4e:	ace50513          	addi	a0,a0,-1330 # 80008718 <__func__.1+0x710>
    80005c52:	ffffb097          	auipc	ra,0xffffb
    80005c56:	90e080e7          	jalr	-1778(ra) # 80000560 <panic>
    80005c5a:	e9d2                	sd	s4,208(sp)
    80005c5c:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    80005c5e:	00003517          	auipc	a0,0x3
    80005c62:	ad250513          	addi	a0,a0,-1326 # 80008730 <__func__.1+0x728>
    80005c66:	ffffb097          	auipc	ra,0xffffb
    80005c6a:	8fa080e7          	jalr	-1798(ra) # 80000560 <panic>
    dp->nlink--;
    80005c6e:	04a4d783          	lhu	a5,74(s1)
    80005c72:	37fd                	addiw	a5,a5,-1
    80005c74:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005c78:	8526                	mv	a0,s1
    80005c7a:	ffffe097          	auipc	ra,0xffffe
    80005c7e:	ee2080e7          	jalr	-286(ra) # 80003b5c <iupdate>
    80005c82:	b725                	j	80005baa <sys_unlink+0xe0>
    80005c84:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    80005c86:	8526                	mv	a0,s1
    80005c88:	ffffe097          	auipc	ra,0xffffe
    80005c8c:	206080e7          	jalr	518(ra) # 80003e8e <iunlockput>
  end_op();
    80005c90:	fffff097          	auipc	ra,0xfffff
    80005c94:	9fc080e7          	jalr	-1540(ra) # 8000468c <end_op>
  return -1;
    80005c98:	557d                	li	a0,-1
    80005c9a:	74ae                	ld	s1,232(sp)
}
    80005c9c:	70ee                	ld	ra,248(sp)
    80005c9e:	744e                	ld	s0,240(sp)
    80005ca0:	6111                	addi	sp,sp,256
    80005ca2:	8082                	ret
    return -1;
    80005ca4:	557d                	li	a0,-1
    80005ca6:	bfdd                	j	80005c9c <sys_unlink+0x1d2>
    iunlockput(ip);
    80005ca8:	854a                	mv	a0,s2
    80005caa:	ffffe097          	auipc	ra,0xffffe
    80005cae:	1e4080e7          	jalr	484(ra) # 80003e8e <iunlockput>
    goto bad;
    80005cb2:	790e                	ld	s2,224(sp)
    80005cb4:	69ee                	ld	s3,216(sp)
    80005cb6:	6a4e                	ld	s4,208(sp)
    80005cb8:	6aae                	ld	s5,200(sp)
    80005cba:	b7f1                	j	80005c86 <sys_unlink+0x1bc>

0000000080005cbc <sys_open>:

uint64
sys_open(void)
{
    80005cbc:	7131                	addi	sp,sp,-192
    80005cbe:	fd06                	sd	ra,184(sp)
    80005cc0:	f922                	sd	s0,176(sp)
    80005cc2:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005cc4:	f4c40593          	addi	a1,s0,-180
    80005cc8:	4505                	li	a0,1
    80005cca:	ffffd097          	auipc	ra,0xffffd
    80005cce:	2a0080e7          	jalr	672(ra) # 80002f6a <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005cd2:	08000613          	li	a2,128
    80005cd6:	f5040593          	addi	a1,s0,-176
    80005cda:	4501                	li	a0,0
    80005cdc:	ffffd097          	auipc	ra,0xffffd
    80005ce0:	2ce080e7          	jalr	718(ra) # 80002faa <argstr>
    80005ce4:	87aa                	mv	a5,a0
    return -1;
    80005ce6:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005ce8:	0a07cf63          	bltz	a5,80005da6 <sys_open+0xea>
    80005cec:	f526                	sd	s1,168(sp)

  begin_op();
    80005cee:	fffff097          	auipc	ra,0xfffff
    80005cf2:	924080e7          	jalr	-1756(ra) # 80004612 <begin_op>

  if(omode & O_CREATE){
    80005cf6:	f4c42783          	lw	a5,-180(s0)
    80005cfa:	2007f793          	andi	a5,a5,512
    80005cfe:	cfdd                	beqz	a5,80005dbc <sys_open+0x100>
    ip = create(path, T_FILE, 0, 0);
    80005d00:	4681                	li	a3,0
    80005d02:	4601                	li	a2,0
    80005d04:	4589                	li	a1,2
    80005d06:	f5040513          	addi	a0,s0,-176
    80005d0a:	00000097          	auipc	ra,0x0
    80005d0e:	94c080e7          	jalr	-1716(ra) # 80005656 <create>
    80005d12:	84aa                	mv	s1,a0
    if(ip == 0){
    80005d14:	cd49                	beqz	a0,80005dae <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005d16:	04449703          	lh	a4,68(s1)
    80005d1a:	478d                	li	a5,3
    80005d1c:	00f71763          	bne	a4,a5,80005d2a <sys_open+0x6e>
    80005d20:	0464d703          	lhu	a4,70(s1)
    80005d24:	47a5                	li	a5,9
    80005d26:	0ee7e263          	bltu	a5,a4,80005e0a <sys_open+0x14e>
    80005d2a:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005d2c:	fffff097          	auipc	ra,0xfffff
    80005d30:	cfa080e7          	jalr	-774(ra) # 80004a26 <filealloc>
    80005d34:	892a                	mv	s2,a0
    80005d36:	cd65                	beqz	a0,80005e2e <sys_open+0x172>
    80005d38:	ed4e                	sd	s3,152(sp)
    80005d3a:	00000097          	auipc	ra,0x0
    80005d3e:	8da080e7          	jalr	-1830(ra) # 80005614 <fdalloc>
    80005d42:	89aa                	mv	s3,a0
    80005d44:	0c054f63          	bltz	a0,80005e22 <sys_open+0x166>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005d48:	04449703          	lh	a4,68(s1)
    80005d4c:	478d                	li	a5,3
    80005d4e:	0ef70d63          	beq	a4,a5,80005e48 <sys_open+0x18c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005d52:	4789                	li	a5,2
    80005d54:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005d58:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005d5c:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005d60:	f4c42783          	lw	a5,-180(s0)
    80005d64:	0017f713          	andi	a4,a5,1
    80005d68:	00174713          	xori	a4,a4,1
    80005d6c:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005d70:	0037f713          	andi	a4,a5,3
    80005d74:	00e03733          	snez	a4,a4
    80005d78:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005d7c:	4007f793          	andi	a5,a5,1024
    80005d80:	c791                	beqz	a5,80005d8c <sys_open+0xd0>
    80005d82:	04449703          	lh	a4,68(s1)
    80005d86:	4789                	li	a5,2
    80005d88:	0cf70763          	beq	a4,a5,80005e56 <sys_open+0x19a>
    itrunc(ip);
  }

  iunlock(ip);
    80005d8c:	8526                	mv	a0,s1
    80005d8e:	ffffe097          	auipc	ra,0xffffe
    80005d92:	f60080e7          	jalr	-160(ra) # 80003cee <iunlock>
  end_op();
    80005d96:	fffff097          	auipc	ra,0xfffff
    80005d9a:	8f6080e7          	jalr	-1802(ra) # 8000468c <end_op>

  return fd;
    80005d9e:	854e                	mv	a0,s3
    80005da0:	74aa                	ld	s1,168(sp)
    80005da2:	790a                	ld	s2,160(sp)
    80005da4:	69ea                	ld	s3,152(sp)
}
    80005da6:	70ea                	ld	ra,184(sp)
    80005da8:	744a                	ld	s0,176(sp)
    80005daa:	6129                	addi	sp,sp,192
    80005dac:	8082                	ret
      end_op();
    80005dae:	fffff097          	auipc	ra,0xfffff
    80005db2:	8de080e7          	jalr	-1826(ra) # 8000468c <end_op>
      return -1;
    80005db6:	557d                	li	a0,-1
    80005db8:	74aa                	ld	s1,168(sp)
    80005dba:	b7f5                	j	80005da6 <sys_open+0xea>
    if((ip = namei(path)) == 0){
    80005dbc:	f5040513          	addi	a0,s0,-176
    80005dc0:	ffffe097          	auipc	ra,0xffffe
    80005dc4:	64c080e7          	jalr	1612(ra) # 8000440c <namei>
    80005dc8:	84aa                	mv	s1,a0
    80005dca:	c90d                	beqz	a0,80005dfc <sys_open+0x140>
    ilock(ip);
    80005dcc:	ffffe097          	auipc	ra,0xffffe
    80005dd0:	e5c080e7          	jalr	-420(ra) # 80003c28 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005dd4:	04449703          	lh	a4,68(s1)
    80005dd8:	4785                	li	a5,1
    80005dda:	f2f71ee3          	bne	a4,a5,80005d16 <sys_open+0x5a>
    80005dde:	f4c42783          	lw	a5,-180(s0)
    80005de2:	d7a1                	beqz	a5,80005d2a <sys_open+0x6e>
      iunlockput(ip);
    80005de4:	8526                	mv	a0,s1
    80005de6:	ffffe097          	auipc	ra,0xffffe
    80005dea:	0a8080e7          	jalr	168(ra) # 80003e8e <iunlockput>
      end_op();
    80005dee:	fffff097          	auipc	ra,0xfffff
    80005df2:	89e080e7          	jalr	-1890(ra) # 8000468c <end_op>
      return -1;
    80005df6:	557d                	li	a0,-1
    80005df8:	74aa                	ld	s1,168(sp)
    80005dfa:	b775                	j	80005da6 <sys_open+0xea>
      end_op();
    80005dfc:	fffff097          	auipc	ra,0xfffff
    80005e00:	890080e7          	jalr	-1904(ra) # 8000468c <end_op>
      return -1;
    80005e04:	557d                	li	a0,-1
    80005e06:	74aa                	ld	s1,168(sp)
    80005e08:	bf79                	j	80005da6 <sys_open+0xea>
    iunlockput(ip);
    80005e0a:	8526                	mv	a0,s1
    80005e0c:	ffffe097          	auipc	ra,0xffffe
    80005e10:	082080e7          	jalr	130(ra) # 80003e8e <iunlockput>
    end_op();
    80005e14:	fffff097          	auipc	ra,0xfffff
    80005e18:	878080e7          	jalr	-1928(ra) # 8000468c <end_op>
    return -1;
    80005e1c:	557d                	li	a0,-1
    80005e1e:	74aa                	ld	s1,168(sp)
    80005e20:	b759                	j	80005da6 <sys_open+0xea>
      fileclose(f);
    80005e22:	854a                	mv	a0,s2
    80005e24:	fffff097          	auipc	ra,0xfffff
    80005e28:	cbe080e7          	jalr	-834(ra) # 80004ae2 <fileclose>
    80005e2c:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005e2e:	8526                	mv	a0,s1
    80005e30:	ffffe097          	auipc	ra,0xffffe
    80005e34:	05e080e7          	jalr	94(ra) # 80003e8e <iunlockput>
    end_op();
    80005e38:	fffff097          	auipc	ra,0xfffff
    80005e3c:	854080e7          	jalr	-1964(ra) # 8000468c <end_op>
    return -1;
    80005e40:	557d                	li	a0,-1
    80005e42:	74aa                	ld	s1,168(sp)
    80005e44:	790a                	ld	s2,160(sp)
    80005e46:	b785                	j	80005da6 <sys_open+0xea>
    f->type = FD_DEVICE;
    80005e48:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005e4c:	04649783          	lh	a5,70(s1)
    80005e50:	02f91223          	sh	a5,36(s2)
    80005e54:	b721                	j	80005d5c <sys_open+0xa0>
    itrunc(ip);
    80005e56:	8526                	mv	a0,s1
    80005e58:	ffffe097          	auipc	ra,0xffffe
    80005e5c:	ee2080e7          	jalr	-286(ra) # 80003d3a <itrunc>
    80005e60:	b735                	j	80005d8c <sys_open+0xd0>

0000000080005e62 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005e62:	7175                	addi	sp,sp,-144
    80005e64:	e506                	sd	ra,136(sp)
    80005e66:	e122                	sd	s0,128(sp)
    80005e68:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005e6a:	ffffe097          	auipc	ra,0xffffe
    80005e6e:	7a8080e7          	jalr	1960(ra) # 80004612 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005e72:	08000613          	li	a2,128
    80005e76:	f7040593          	addi	a1,s0,-144
    80005e7a:	4501                	li	a0,0
    80005e7c:	ffffd097          	auipc	ra,0xffffd
    80005e80:	12e080e7          	jalr	302(ra) # 80002faa <argstr>
    80005e84:	02054963          	bltz	a0,80005eb6 <sys_mkdir+0x54>
    80005e88:	4681                	li	a3,0
    80005e8a:	4601                	li	a2,0
    80005e8c:	4585                	li	a1,1
    80005e8e:	f7040513          	addi	a0,s0,-144
    80005e92:	fffff097          	auipc	ra,0xfffff
    80005e96:	7c4080e7          	jalr	1988(ra) # 80005656 <create>
    80005e9a:	cd11                	beqz	a0,80005eb6 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005e9c:	ffffe097          	auipc	ra,0xffffe
    80005ea0:	ff2080e7          	jalr	-14(ra) # 80003e8e <iunlockput>
  end_op();
    80005ea4:	ffffe097          	auipc	ra,0xffffe
    80005ea8:	7e8080e7          	jalr	2024(ra) # 8000468c <end_op>
  return 0;
    80005eac:	4501                	li	a0,0
}
    80005eae:	60aa                	ld	ra,136(sp)
    80005eb0:	640a                	ld	s0,128(sp)
    80005eb2:	6149                	addi	sp,sp,144
    80005eb4:	8082                	ret
    end_op();
    80005eb6:	ffffe097          	auipc	ra,0xffffe
    80005eba:	7d6080e7          	jalr	2006(ra) # 8000468c <end_op>
    return -1;
    80005ebe:	557d                	li	a0,-1
    80005ec0:	b7fd                	j	80005eae <sys_mkdir+0x4c>

0000000080005ec2 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005ec2:	7135                	addi	sp,sp,-160
    80005ec4:	ed06                	sd	ra,152(sp)
    80005ec6:	e922                	sd	s0,144(sp)
    80005ec8:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005eca:	ffffe097          	auipc	ra,0xffffe
    80005ece:	748080e7          	jalr	1864(ra) # 80004612 <begin_op>
  argint(1, &major);
    80005ed2:	f6c40593          	addi	a1,s0,-148
    80005ed6:	4505                	li	a0,1
    80005ed8:	ffffd097          	auipc	ra,0xffffd
    80005edc:	092080e7          	jalr	146(ra) # 80002f6a <argint>
  argint(2, &minor);
    80005ee0:	f6840593          	addi	a1,s0,-152
    80005ee4:	4509                	li	a0,2
    80005ee6:	ffffd097          	auipc	ra,0xffffd
    80005eea:	084080e7          	jalr	132(ra) # 80002f6a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005eee:	08000613          	li	a2,128
    80005ef2:	f7040593          	addi	a1,s0,-144
    80005ef6:	4501                	li	a0,0
    80005ef8:	ffffd097          	auipc	ra,0xffffd
    80005efc:	0b2080e7          	jalr	178(ra) # 80002faa <argstr>
    80005f00:	02054b63          	bltz	a0,80005f36 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005f04:	f6841683          	lh	a3,-152(s0)
    80005f08:	f6c41603          	lh	a2,-148(s0)
    80005f0c:	458d                	li	a1,3
    80005f0e:	f7040513          	addi	a0,s0,-144
    80005f12:	fffff097          	auipc	ra,0xfffff
    80005f16:	744080e7          	jalr	1860(ra) # 80005656 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005f1a:	cd11                	beqz	a0,80005f36 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005f1c:	ffffe097          	auipc	ra,0xffffe
    80005f20:	f72080e7          	jalr	-142(ra) # 80003e8e <iunlockput>
  end_op();
    80005f24:	ffffe097          	auipc	ra,0xffffe
    80005f28:	768080e7          	jalr	1896(ra) # 8000468c <end_op>
  return 0;
    80005f2c:	4501                	li	a0,0
}
    80005f2e:	60ea                	ld	ra,152(sp)
    80005f30:	644a                	ld	s0,144(sp)
    80005f32:	610d                	addi	sp,sp,160
    80005f34:	8082                	ret
    end_op();
    80005f36:	ffffe097          	auipc	ra,0xffffe
    80005f3a:	756080e7          	jalr	1878(ra) # 8000468c <end_op>
    return -1;
    80005f3e:	557d                	li	a0,-1
    80005f40:	b7fd                	j	80005f2e <sys_mknod+0x6c>

0000000080005f42 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005f42:	7135                	addi	sp,sp,-160
    80005f44:	ed06                	sd	ra,152(sp)
    80005f46:	e922                	sd	s0,144(sp)
    80005f48:	e14a                	sd	s2,128(sp)
    80005f4a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005f4c:	ffffc097          	auipc	ra,0xffffc
    80005f50:	d14080e7          	jalr	-748(ra) # 80001c60 <myproc>
    80005f54:	892a                	mv	s2,a0
  
  begin_op();
    80005f56:	ffffe097          	auipc	ra,0xffffe
    80005f5a:	6bc080e7          	jalr	1724(ra) # 80004612 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005f5e:	08000613          	li	a2,128
    80005f62:	f6040593          	addi	a1,s0,-160
    80005f66:	4501                	li	a0,0
    80005f68:	ffffd097          	auipc	ra,0xffffd
    80005f6c:	042080e7          	jalr	66(ra) # 80002faa <argstr>
    80005f70:	04054d63          	bltz	a0,80005fca <sys_chdir+0x88>
    80005f74:	e526                	sd	s1,136(sp)
    80005f76:	f6040513          	addi	a0,s0,-160
    80005f7a:	ffffe097          	auipc	ra,0xffffe
    80005f7e:	492080e7          	jalr	1170(ra) # 8000440c <namei>
    80005f82:	84aa                	mv	s1,a0
    80005f84:	c131                	beqz	a0,80005fc8 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005f86:	ffffe097          	auipc	ra,0xffffe
    80005f8a:	ca2080e7          	jalr	-862(ra) # 80003c28 <ilock>
  if(ip->type != T_DIR){
    80005f8e:	04449703          	lh	a4,68(s1)
    80005f92:	4785                	li	a5,1
    80005f94:	04f71163          	bne	a4,a5,80005fd6 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005f98:	8526                	mv	a0,s1
    80005f9a:	ffffe097          	auipc	ra,0xffffe
    80005f9e:	d54080e7          	jalr	-684(ra) # 80003cee <iunlock>
  iput(p->cwd);
    80005fa2:	15093503          	ld	a0,336(s2)
    80005fa6:	ffffe097          	auipc	ra,0xffffe
    80005faa:	e40080e7          	jalr	-448(ra) # 80003de6 <iput>
  end_op();
    80005fae:	ffffe097          	auipc	ra,0xffffe
    80005fb2:	6de080e7          	jalr	1758(ra) # 8000468c <end_op>
  p->cwd = ip;
    80005fb6:	14993823          	sd	s1,336(s2)
  return 0;
    80005fba:	4501                	li	a0,0
    80005fbc:	64aa                	ld	s1,136(sp)
}
    80005fbe:	60ea                	ld	ra,152(sp)
    80005fc0:	644a                	ld	s0,144(sp)
    80005fc2:	690a                	ld	s2,128(sp)
    80005fc4:	610d                	addi	sp,sp,160
    80005fc6:	8082                	ret
    80005fc8:	64aa                	ld	s1,136(sp)
    end_op();
    80005fca:	ffffe097          	auipc	ra,0xffffe
    80005fce:	6c2080e7          	jalr	1730(ra) # 8000468c <end_op>
    return -1;
    80005fd2:	557d                	li	a0,-1
    80005fd4:	b7ed                	j	80005fbe <sys_chdir+0x7c>
    iunlockput(ip);
    80005fd6:	8526                	mv	a0,s1
    80005fd8:	ffffe097          	auipc	ra,0xffffe
    80005fdc:	eb6080e7          	jalr	-330(ra) # 80003e8e <iunlockput>
    end_op();
    80005fe0:	ffffe097          	auipc	ra,0xffffe
    80005fe4:	6ac080e7          	jalr	1708(ra) # 8000468c <end_op>
    return -1;
    80005fe8:	557d                	li	a0,-1
    80005fea:	64aa                	ld	s1,136(sp)
    80005fec:	bfc9                	j	80005fbe <sys_chdir+0x7c>

0000000080005fee <sys_exec>:

uint64
sys_exec(void)
{
    80005fee:	7105                	addi	sp,sp,-480
    80005ff0:	ef86                	sd	ra,472(sp)
    80005ff2:	eba2                	sd	s0,464(sp)
    80005ff4:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005ff6:	e2840593          	addi	a1,s0,-472
    80005ffa:	4505                	li	a0,1
    80005ffc:	ffffd097          	auipc	ra,0xffffd
    80006000:	f8e080e7          	jalr	-114(ra) # 80002f8a <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80006004:	08000613          	li	a2,128
    80006008:	f3040593          	addi	a1,s0,-208
    8000600c:	4501                	li	a0,0
    8000600e:	ffffd097          	auipc	ra,0xffffd
    80006012:	f9c080e7          	jalr	-100(ra) # 80002faa <argstr>
    80006016:	87aa                	mv	a5,a0
    return -1;
    80006018:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000601a:	0e07ce63          	bltz	a5,80006116 <sys_exec+0x128>
    8000601e:	e7a6                	sd	s1,456(sp)
    80006020:	e3ca                	sd	s2,448(sp)
    80006022:	ff4e                	sd	s3,440(sp)
    80006024:	fb52                	sd	s4,432(sp)
    80006026:	f756                	sd	s5,424(sp)
    80006028:	f35a                	sd	s6,416(sp)
    8000602a:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    8000602c:	e3040a13          	addi	s4,s0,-464
    80006030:	10000613          	li	a2,256
    80006034:	4581                	li	a1,0
    80006036:	8552                	mv	a0,s4
    80006038:	ffffb097          	auipc	ra,0xffffb
    8000603c:	dc6080e7          	jalr	-570(ra) # 80000dfe <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80006040:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80006042:	89d2                	mv	s3,s4
    80006044:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80006046:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000604a:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    8000604c:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80006050:	00391513          	slli	a0,s2,0x3
    80006054:	85d6                	mv	a1,s5
    80006056:	e2843783          	ld	a5,-472(s0)
    8000605a:	953e                	add	a0,a0,a5
    8000605c:	ffffd097          	auipc	ra,0xffffd
    80006060:	e70080e7          	jalr	-400(ra) # 80002ecc <fetchaddr>
    80006064:	02054a63          	bltz	a0,80006098 <sys_exec+0xaa>
    if(uarg == 0){
    80006068:	e2043783          	ld	a5,-480(s0)
    8000606c:	cbb1                	beqz	a5,800060c0 <sys_exec+0xd2>
    argv[i] = kalloc();
    8000606e:	ffffb097          	auipc	ra,0xffffb
    80006072:	b58080e7          	jalr	-1192(ra) # 80000bc6 <kalloc>
    80006076:	85aa                	mv	a1,a0
    80006078:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000607c:	cd11                	beqz	a0,80006098 <sys_exec+0xaa>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000607e:	865a                	mv	a2,s6
    80006080:	e2043503          	ld	a0,-480(s0)
    80006084:	ffffd097          	auipc	ra,0xffffd
    80006088:	e9a080e7          	jalr	-358(ra) # 80002f1e <fetchstr>
    8000608c:	00054663          	bltz	a0,80006098 <sys_exec+0xaa>
    if(i >= NELEM(argv)){
    80006090:	0905                	addi	s2,s2,1
    80006092:	09a1                	addi	s3,s3,8
    80006094:	fb791ee3          	bne	s2,s7,80006050 <sys_exec+0x62>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006098:	100a0a13          	addi	s4,s4,256
    8000609c:	6088                	ld	a0,0(s1)
    8000609e:	c525                	beqz	a0,80006106 <sys_exec+0x118>
    kfree(argv[i]);
    800060a0:	ffffb097          	auipc	ra,0xffffb
    800060a4:	9be080e7          	jalr	-1602(ra) # 80000a5e <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800060a8:	04a1                	addi	s1,s1,8
    800060aa:	ff4499e3          	bne	s1,s4,8000609c <sys_exec+0xae>
  return -1;
    800060ae:	557d                	li	a0,-1
    800060b0:	64be                	ld	s1,456(sp)
    800060b2:	691e                	ld	s2,448(sp)
    800060b4:	79fa                	ld	s3,440(sp)
    800060b6:	7a5a                	ld	s4,432(sp)
    800060b8:	7aba                	ld	s5,424(sp)
    800060ba:	7b1a                	ld	s6,416(sp)
    800060bc:	6bfa                	ld	s7,408(sp)
    800060be:	a8a1                	j	80006116 <sys_exec+0x128>
      argv[i] = 0;
    800060c0:	0009079b          	sext.w	a5,s2
    800060c4:	e3040593          	addi	a1,s0,-464
    800060c8:	078e                	slli	a5,a5,0x3
    800060ca:	97ae                	add	a5,a5,a1
    800060cc:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    800060d0:	f3040513          	addi	a0,s0,-208
    800060d4:	fffff097          	auipc	ra,0xfffff
    800060d8:	118080e7          	jalr	280(ra) # 800051ec <exec>
    800060dc:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800060de:	100a0a13          	addi	s4,s4,256
    800060e2:	6088                	ld	a0,0(s1)
    800060e4:	c901                	beqz	a0,800060f4 <sys_exec+0x106>
    kfree(argv[i]);
    800060e6:	ffffb097          	auipc	ra,0xffffb
    800060ea:	978080e7          	jalr	-1672(ra) # 80000a5e <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800060ee:	04a1                	addi	s1,s1,8
    800060f0:	ff4499e3          	bne	s1,s4,800060e2 <sys_exec+0xf4>
  return ret;
    800060f4:	854a                	mv	a0,s2
    800060f6:	64be                	ld	s1,456(sp)
    800060f8:	691e                	ld	s2,448(sp)
    800060fa:	79fa                	ld	s3,440(sp)
    800060fc:	7a5a                	ld	s4,432(sp)
    800060fe:	7aba                	ld	s5,424(sp)
    80006100:	7b1a                	ld	s6,416(sp)
    80006102:	6bfa                	ld	s7,408(sp)
    80006104:	a809                	j	80006116 <sys_exec+0x128>
  return -1;
    80006106:	557d                	li	a0,-1
    80006108:	64be                	ld	s1,456(sp)
    8000610a:	691e                	ld	s2,448(sp)
    8000610c:	79fa                	ld	s3,440(sp)
    8000610e:	7a5a                	ld	s4,432(sp)
    80006110:	7aba                	ld	s5,424(sp)
    80006112:	7b1a                	ld	s6,416(sp)
    80006114:	6bfa                	ld	s7,408(sp)
}
    80006116:	60fe                	ld	ra,472(sp)
    80006118:	645e                	ld	s0,464(sp)
    8000611a:	613d                	addi	sp,sp,480
    8000611c:	8082                	ret

000000008000611e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000611e:	7139                	addi	sp,sp,-64
    80006120:	fc06                	sd	ra,56(sp)
    80006122:	f822                	sd	s0,48(sp)
    80006124:	f426                	sd	s1,40(sp)
    80006126:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80006128:	ffffc097          	auipc	ra,0xffffc
    8000612c:	b38080e7          	jalr	-1224(ra) # 80001c60 <myproc>
    80006130:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80006132:	fd840593          	addi	a1,s0,-40
    80006136:	4501                	li	a0,0
    80006138:	ffffd097          	auipc	ra,0xffffd
    8000613c:	e52080e7          	jalr	-430(ra) # 80002f8a <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80006140:	fc840593          	addi	a1,s0,-56
    80006144:	fd040513          	addi	a0,s0,-48
    80006148:	fffff097          	auipc	ra,0xfffff
    8000614c:	d0e080e7          	jalr	-754(ra) # 80004e56 <pipealloc>
    return -1;
    80006150:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80006152:	0c054463          	bltz	a0,8000621a <sys_pipe+0xfc>
  fd0 = -1;
    80006156:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000615a:	fd043503          	ld	a0,-48(s0)
    8000615e:	fffff097          	auipc	ra,0xfffff
    80006162:	4b6080e7          	jalr	1206(ra) # 80005614 <fdalloc>
    80006166:	fca42223          	sw	a0,-60(s0)
    8000616a:	08054b63          	bltz	a0,80006200 <sys_pipe+0xe2>
    8000616e:	fc843503          	ld	a0,-56(s0)
    80006172:	fffff097          	auipc	ra,0xfffff
    80006176:	4a2080e7          	jalr	1186(ra) # 80005614 <fdalloc>
    8000617a:	fca42023          	sw	a0,-64(s0)
    8000617e:	06054863          	bltz	a0,800061ee <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006182:	4691                	li	a3,4
    80006184:	fc440613          	addi	a2,s0,-60
    80006188:	fd843583          	ld	a1,-40(s0)
    8000618c:	68a8                	ld	a0,80(s1)
    8000618e:	ffffb097          	auipc	ra,0xffffb
    80006192:	64a080e7          	jalr	1610(ra) # 800017d8 <copyout>
    80006196:	02054063          	bltz	a0,800061b6 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000619a:	4691                	li	a3,4
    8000619c:	fc040613          	addi	a2,s0,-64
    800061a0:	fd843583          	ld	a1,-40(s0)
    800061a4:	95b6                	add	a1,a1,a3
    800061a6:	68a8                	ld	a0,80(s1)
    800061a8:	ffffb097          	auipc	ra,0xffffb
    800061ac:	630080e7          	jalr	1584(ra) # 800017d8 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800061b0:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800061b2:	06055463          	bgez	a0,8000621a <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800061b6:	fc442783          	lw	a5,-60(s0)
    800061ba:	07e9                	addi	a5,a5,26
    800061bc:	078e                	slli	a5,a5,0x3
    800061be:	97a6                	add	a5,a5,s1
    800061c0:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800061c4:	fc042783          	lw	a5,-64(s0)
    800061c8:	07e9                	addi	a5,a5,26
    800061ca:	078e                	slli	a5,a5,0x3
    800061cc:	94be                	add	s1,s1,a5
    800061ce:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800061d2:	fd043503          	ld	a0,-48(s0)
    800061d6:	fffff097          	auipc	ra,0xfffff
    800061da:	90c080e7          	jalr	-1780(ra) # 80004ae2 <fileclose>
    fileclose(wf);
    800061de:	fc843503          	ld	a0,-56(s0)
    800061e2:	fffff097          	auipc	ra,0xfffff
    800061e6:	900080e7          	jalr	-1792(ra) # 80004ae2 <fileclose>
    return -1;
    800061ea:	57fd                	li	a5,-1
    800061ec:	a03d                	j	8000621a <sys_pipe+0xfc>
    if(fd0 >= 0)
    800061ee:	fc442783          	lw	a5,-60(s0)
    800061f2:	0007c763          	bltz	a5,80006200 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    800061f6:	07e9                	addi	a5,a5,26
    800061f8:	078e                	slli	a5,a5,0x3
    800061fa:	97a6                	add	a5,a5,s1
    800061fc:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80006200:	fd043503          	ld	a0,-48(s0)
    80006204:	fffff097          	auipc	ra,0xfffff
    80006208:	8de080e7          	jalr	-1826(ra) # 80004ae2 <fileclose>
    fileclose(wf);
    8000620c:	fc843503          	ld	a0,-56(s0)
    80006210:	fffff097          	auipc	ra,0xfffff
    80006214:	8d2080e7          	jalr	-1838(ra) # 80004ae2 <fileclose>
    return -1;
    80006218:	57fd                	li	a5,-1
}
    8000621a:	853e                	mv	a0,a5
    8000621c:	70e2                	ld	ra,56(sp)
    8000621e:	7442                	ld	s0,48(sp)
    80006220:	74a2                	ld	s1,40(sp)
    80006222:	6121                	addi	sp,sp,64
    80006224:	8082                	ret
	...

0000000080006230 <kernelvec>:
    80006230:	7111                	addi	sp,sp,-256
    80006232:	e006                	sd	ra,0(sp)
    80006234:	e40a                	sd	sp,8(sp)
    80006236:	e80e                	sd	gp,16(sp)
    80006238:	ec12                	sd	tp,24(sp)
    8000623a:	f016                	sd	t0,32(sp)
    8000623c:	f41a                	sd	t1,40(sp)
    8000623e:	f81e                	sd	t2,48(sp)
    80006240:	fc22                	sd	s0,56(sp)
    80006242:	e0a6                	sd	s1,64(sp)
    80006244:	e4aa                	sd	a0,72(sp)
    80006246:	e8ae                	sd	a1,80(sp)
    80006248:	ecb2                	sd	a2,88(sp)
    8000624a:	f0b6                	sd	a3,96(sp)
    8000624c:	f4ba                	sd	a4,104(sp)
    8000624e:	f8be                	sd	a5,112(sp)
    80006250:	fcc2                	sd	a6,120(sp)
    80006252:	e146                	sd	a7,128(sp)
    80006254:	e54a                	sd	s2,136(sp)
    80006256:	e94e                	sd	s3,144(sp)
    80006258:	ed52                	sd	s4,152(sp)
    8000625a:	f156                	sd	s5,160(sp)
    8000625c:	f55a                	sd	s6,168(sp)
    8000625e:	f95e                	sd	s7,176(sp)
    80006260:	fd62                	sd	s8,184(sp)
    80006262:	e1e6                	sd	s9,192(sp)
    80006264:	e5ea                	sd	s10,200(sp)
    80006266:	e9ee                	sd	s11,208(sp)
    80006268:	edf2                	sd	t3,216(sp)
    8000626a:	f1f6                	sd	t4,224(sp)
    8000626c:	f5fa                	sd	t5,232(sp)
    8000626e:	f9fe                	sd	t6,240(sp)
    80006270:	b29fc0ef          	jal	80002d98 <kerneltrap>
    80006274:	6082                	ld	ra,0(sp)
    80006276:	6122                	ld	sp,8(sp)
    80006278:	61c2                	ld	gp,16(sp)
    8000627a:	7282                	ld	t0,32(sp)
    8000627c:	7322                	ld	t1,40(sp)
    8000627e:	73c2                	ld	t2,48(sp)
    80006280:	7462                	ld	s0,56(sp)
    80006282:	6486                	ld	s1,64(sp)
    80006284:	6526                	ld	a0,72(sp)
    80006286:	65c6                	ld	a1,80(sp)
    80006288:	6666                	ld	a2,88(sp)
    8000628a:	7686                	ld	a3,96(sp)
    8000628c:	7726                	ld	a4,104(sp)
    8000628e:	77c6                	ld	a5,112(sp)
    80006290:	7866                	ld	a6,120(sp)
    80006292:	688a                	ld	a7,128(sp)
    80006294:	692a                	ld	s2,136(sp)
    80006296:	69ca                	ld	s3,144(sp)
    80006298:	6a6a                	ld	s4,152(sp)
    8000629a:	7a8a                	ld	s5,160(sp)
    8000629c:	7b2a                	ld	s6,168(sp)
    8000629e:	7bca                	ld	s7,176(sp)
    800062a0:	7c6a                	ld	s8,184(sp)
    800062a2:	6c8e                	ld	s9,192(sp)
    800062a4:	6d2e                	ld	s10,200(sp)
    800062a6:	6dce                	ld	s11,208(sp)
    800062a8:	6e6e                	ld	t3,216(sp)
    800062aa:	7e8e                	ld	t4,224(sp)
    800062ac:	7f2e                	ld	t5,232(sp)
    800062ae:	7fce                	ld	t6,240(sp)
    800062b0:	6111                	addi	sp,sp,256
    800062b2:	10200073          	sret
    800062b6:	00000013          	nop
    800062ba:	00000013          	nop
    800062be:	0001                	nop

00000000800062c0 <timervec>:
    800062c0:	34051573          	csrrw	a0,mscratch,a0
    800062c4:	e10c                	sd	a1,0(a0)
    800062c6:	e510                	sd	a2,8(a0)
    800062c8:	e914                	sd	a3,16(a0)
    800062ca:	6d0c                	ld	a1,24(a0)
    800062cc:	7110                	ld	a2,32(a0)
    800062ce:	6194                	ld	a3,0(a1)
    800062d0:	96b2                	add	a3,a3,a2
    800062d2:	e194                	sd	a3,0(a1)
    800062d4:	4589                	li	a1,2
    800062d6:	14459073          	csrw	sip,a1
    800062da:	6914                	ld	a3,16(a0)
    800062dc:	6510                	ld	a2,8(a0)
    800062de:	610c                	ld	a1,0(a0)
    800062e0:	34051573          	csrrw	a0,mscratch,a0
    800062e4:	30200073          	mret
	...

00000000800062ea <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800062ea:	1141                	addi	sp,sp,-16
    800062ec:	e406                	sd	ra,8(sp)
    800062ee:	e022                	sd	s0,0(sp)
    800062f0:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800062f2:	0c000737          	lui	a4,0xc000
    800062f6:	4785                	li	a5,1
    800062f8:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800062fa:	c35c                	sw	a5,4(a4)
}
    800062fc:	60a2                	ld	ra,8(sp)
    800062fe:	6402                	ld	s0,0(sp)
    80006300:	0141                	addi	sp,sp,16
    80006302:	8082                	ret

0000000080006304 <plicinithart>:

void
plicinithart(void)
{
    80006304:	1141                	addi	sp,sp,-16
    80006306:	e406                	sd	ra,8(sp)
    80006308:	e022                	sd	s0,0(sp)
    8000630a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000630c:	ffffc097          	auipc	ra,0xffffc
    80006310:	920080e7          	jalr	-1760(ra) # 80001c2c <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006314:	0085171b          	slliw	a4,a0,0x8
    80006318:	0c0027b7          	lui	a5,0xc002
    8000631c:	97ba                	add	a5,a5,a4
    8000631e:	40200713          	li	a4,1026
    80006322:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006326:	00d5151b          	slliw	a0,a0,0xd
    8000632a:	0c2017b7          	lui	a5,0xc201
    8000632e:	97aa                	add	a5,a5,a0
    80006330:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80006334:	60a2                	ld	ra,8(sp)
    80006336:	6402                	ld	s0,0(sp)
    80006338:	0141                	addi	sp,sp,16
    8000633a:	8082                	ret

000000008000633c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000633c:	1141                	addi	sp,sp,-16
    8000633e:	e406                	sd	ra,8(sp)
    80006340:	e022                	sd	s0,0(sp)
    80006342:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006344:	ffffc097          	auipc	ra,0xffffc
    80006348:	8e8080e7          	jalr	-1816(ra) # 80001c2c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000634c:	00d5151b          	slliw	a0,a0,0xd
    80006350:	0c2017b7          	lui	a5,0xc201
    80006354:	97aa                	add	a5,a5,a0
  return irq;
}
    80006356:	43c8                	lw	a0,4(a5)
    80006358:	60a2                	ld	ra,8(sp)
    8000635a:	6402                	ld	s0,0(sp)
    8000635c:	0141                	addi	sp,sp,16
    8000635e:	8082                	ret

0000000080006360 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80006360:	1101                	addi	sp,sp,-32
    80006362:	ec06                	sd	ra,24(sp)
    80006364:	e822                	sd	s0,16(sp)
    80006366:	e426                	sd	s1,8(sp)
    80006368:	1000                	addi	s0,sp,32
    8000636a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000636c:	ffffc097          	auipc	ra,0xffffc
    80006370:	8c0080e7          	jalr	-1856(ra) # 80001c2c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006374:	00d5179b          	slliw	a5,a0,0xd
    80006378:	0c201737          	lui	a4,0xc201
    8000637c:	97ba                	add	a5,a5,a4
    8000637e:	c3c4                	sw	s1,4(a5)
}
    80006380:	60e2                	ld	ra,24(sp)
    80006382:	6442                	ld	s0,16(sp)
    80006384:	64a2                	ld	s1,8(sp)
    80006386:	6105                	addi	sp,sp,32
    80006388:	8082                	ret

000000008000638a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000638a:	1141                	addi	sp,sp,-16
    8000638c:	e406                	sd	ra,8(sp)
    8000638e:	e022                	sd	s0,0(sp)
    80006390:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80006392:	479d                	li	a5,7
    80006394:	04a7cc63          	blt	a5,a0,800063ec <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80006398:	0001c797          	auipc	a5,0x1c
    8000639c:	9e878793          	addi	a5,a5,-1560 # 80021d80 <disk>
    800063a0:	97aa                	add	a5,a5,a0
    800063a2:	0187c783          	lbu	a5,24(a5)
    800063a6:	ebb9                	bnez	a5,800063fc <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800063a8:	00451693          	slli	a3,a0,0x4
    800063ac:	0001c797          	auipc	a5,0x1c
    800063b0:	9d478793          	addi	a5,a5,-1580 # 80021d80 <disk>
    800063b4:	6398                	ld	a4,0(a5)
    800063b6:	9736                	add	a4,a4,a3
    800063b8:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    800063bc:	6398                	ld	a4,0(a5)
    800063be:	9736                	add	a4,a4,a3
    800063c0:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800063c4:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800063c8:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800063cc:	97aa                	add	a5,a5,a0
    800063ce:	4705                	li	a4,1
    800063d0:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800063d4:	0001c517          	auipc	a0,0x1c
    800063d8:	9c450513          	addi	a0,a0,-1596 # 80021d98 <disk+0x18>
    800063dc:	ffffc097          	auipc	ra,0xffffc
    800063e0:	09c080e7          	jalr	156(ra) # 80002478 <wakeup>
}
    800063e4:	60a2                	ld	ra,8(sp)
    800063e6:	6402                	ld	s0,0(sp)
    800063e8:	0141                	addi	sp,sp,16
    800063ea:	8082                	ret
    panic("free_desc 1");
    800063ec:	00002517          	auipc	a0,0x2
    800063f0:	35450513          	addi	a0,a0,852 # 80008740 <__func__.1+0x738>
    800063f4:	ffffa097          	auipc	ra,0xffffa
    800063f8:	16c080e7          	jalr	364(ra) # 80000560 <panic>
    panic("free_desc 2");
    800063fc:	00002517          	auipc	a0,0x2
    80006400:	35450513          	addi	a0,a0,852 # 80008750 <__func__.1+0x748>
    80006404:	ffffa097          	auipc	ra,0xffffa
    80006408:	15c080e7          	jalr	348(ra) # 80000560 <panic>

000000008000640c <virtio_disk_init>:
{
    8000640c:	1101                	addi	sp,sp,-32
    8000640e:	ec06                	sd	ra,24(sp)
    80006410:	e822                	sd	s0,16(sp)
    80006412:	e426                	sd	s1,8(sp)
    80006414:	e04a                	sd	s2,0(sp)
    80006416:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006418:	00002597          	auipc	a1,0x2
    8000641c:	34858593          	addi	a1,a1,840 # 80008760 <__func__.1+0x758>
    80006420:	0001c517          	auipc	a0,0x1c
    80006424:	a8850513          	addi	a0,a0,-1400 # 80021ea8 <disk+0x128>
    80006428:	ffffb097          	auipc	ra,0xffffb
    8000642c:	84a080e7          	jalr	-1974(ra) # 80000c72 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006430:	100017b7          	lui	a5,0x10001
    80006434:	4398                	lw	a4,0(a5)
    80006436:	2701                	sext.w	a4,a4
    80006438:	747277b7          	lui	a5,0x74727
    8000643c:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006440:	16f71463          	bne	a4,a5,800065a8 <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006444:	100017b7          	lui	a5,0x10001
    80006448:	43dc                	lw	a5,4(a5)
    8000644a:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000644c:	4709                	li	a4,2
    8000644e:	14e79d63          	bne	a5,a4,800065a8 <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006452:	100017b7          	lui	a5,0x10001
    80006456:	479c                	lw	a5,8(a5)
    80006458:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000645a:	14e79763          	bne	a5,a4,800065a8 <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000645e:	100017b7          	lui	a5,0x10001
    80006462:	47d8                	lw	a4,12(a5)
    80006464:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006466:	554d47b7          	lui	a5,0x554d4
    8000646a:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000646e:	12f71d63          	bne	a4,a5,800065a8 <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006472:	100017b7          	lui	a5,0x10001
    80006476:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000647a:	4705                	li	a4,1
    8000647c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000647e:	470d                	li	a4,3
    80006480:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80006482:	10001737          	lui	a4,0x10001
    80006486:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80006488:	c7ffe6b7          	lui	a3,0xc7ffe
    8000648c:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc89f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006490:	8f75                	and	a4,a4,a3
    80006492:	100016b7          	lui	a3,0x10001
    80006496:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006498:	472d                	li	a4,11
    8000649a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000649c:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    800064a0:	439c                	lw	a5,0(a5)
    800064a2:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800064a6:	8ba1                	andi	a5,a5,8
    800064a8:	10078863          	beqz	a5,800065b8 <virtio_disk_init+0x1ac>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800064ac:	100017b7          	lui	a5,0x10001
    800064b0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800064b4:	43fc                	lw	a5,68(a5)
    800064b6:	2781                	sext.w	a5,a5
    800064b8:	10079863          	bnez	a5,800065c8 <virtio_disk_init+0x1bc>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800064bc:	100017b7          	lui	a5,0x10001
    800064c0:	5bdc                	lw	a5,52(a5)
    800064c2:	2781                	sext.w	a5,a5
  if(max == 0)
    800064c4:	10078a63          	beqz	a5,800065d8 <virtio_disk_init+0x1cc>
  if(max < NUM)
    800064c8:	471d                	li	a4,7
    800064ca:	10f77f63          	bgeu	a4,a5,800065e8 <virtio_disk_init+0x1dc>
  disk.desc = kalloc();
    800064ce:	ffffa097          	auipc	ra,0xffffa
    800064d2:	6f8080e7          	jalr	1784(ra) # 80000bc6 <kalloc>
    800064d6:	0001c497          	auipc	s1,0x1c
    800064da:	8aa48493          	addi	s1,s1,-1878 # 80021d80 <disk>
    800064de:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800064e0:	ffffa097          	auipc	ra,0xffffa
    800064e4:	6e6080e7          	jalr	1766(ra) # 80000bc6 <kalloc>
    800064e8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800064ea:	ffffa097          	auipc	ra,0xffffa
    800064ee:	6dc080e7          	jalr	1756(ra) # 80000bc6 <kalloc>
    800064f2:	87aa                	mv	a5,a0
    800064f4:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800064f6:	6088                	ld	a0,0(s1)
    800064f8:	10050063          	beqz	a0,800065f8 <virtio_disk_init+0x1ec>
    800064fc:	0001c717          	auipc	a4,0x1c
    80006500:	88c73703          	ld	a4,-1908(a4) # 80021d88 <disk+0x8>
    80006504:	cb75                	beqz	a4,800065f8 <virtio_disk_init+0x1ec>
    80006506:	cbed                	beqz	a5,800065f8 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80006508:	6605                	lui	a2,0x1
    8000650a:	4581                	li	a1,0
    8000650c:	ffffb097          	auipc	ra,0xffffb
    80006510:	8f2080e7          	jalr	-1806(ra) # 80000dfe <memset>
  memset(disk.avail, 0, PGSIZE);
    80006514:	0001c497          	auipc	s1,0x1c
    80006518:	86c48493          	addi	s1,s1,-1940 # 80021d80 <disk>
    8000651c:	6605                	lui	a2,0x1
    8000651e:	4581                	li	a1,0
    80006520:	6488                	ld	a0,8(s1)
    80006522:	ffffb097          	auipc	ra,0xffffb
    80006526:	8dc080e7          	jalr	-1828(ra) # 80000dfe <memset>
  memset(disk.used, 0, PGSIZE);
    8000652a:	6605                	lui	a2,0x1
    8000652c:	4581                	li	a1,0
    8000652e:	6888                	ld	a0,16(s1)
    80006530:	ffffb097          	auipc	ra,0xffffb
    80006534:	8ce080e7          	jalr	-1842(ra) # 80000dfe <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006538:	100017b7          	lui	a5,0x10001
    8000653c:	4721                	li	a4,8
    8000653e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006540:	4098                	lw	a4,0(s1)
    80006542:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006546:	40d8                	lw	a4,4(s1)
    80006548:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000654c:	649c                	ld	a5,8(s1)
    8000654e:	0007869b          	sext.w	a3,a5
    80006552:	10001737          	lui	a4,0x10001
    80006556:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    8000655a:	9781                	srai	a5,a5,0x20
    8000655c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80006560:	689c                	ld	a5,16(s1)
    80006562:	0007869b          	sext.w	a3,a5
    80006566:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000656a:	9781                	srai	a5,a5,0x20
    8000656c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80006570:	4785                	li	a5,1
    80006572:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80006574:	00f48c23          	sb	a5,24(s1)
    80006578:	00f48ca3          	sb	a5,25(s1)
    8000657c:	00f48d23          	sb	a5,26(s1)
    80006580:	00f48da3          	sb	a5,27(s1)
    80006584:	00f48e23          	sb	a5,28(s1)
    80006588:	00f48ea3          	sb	a5,29(s1)
    8000658c:	00f48f23          	sb	a5,30(s1)
    80006590:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80006594:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006598:	07272823          	sw	s2,112(a4)
}
    8000659c:	60e2                	ld	ra,24(sp)
    8000659e:	6442                	ld	s0,16(sp)
    800065a0:	64a2                	ld	s1,8(sp)
    800065a2:	6902                	ld	s2,0(sp)
    800065a4:	6105                	addi	sp,sp,32
    800065a6:	8082                	ret
    panic("could not find virtio disk");
    800065a8:	00002517          	auipc	a0,0x2
    800065ac:	1c850513          	addi	a0,a0,456 # 80008770 <__func__.1+0x768>
    800065b0:	ffffa097          	auipc	ra,0xffffa
    800065b4:	fb0080e7          	jalr	-80(ra) # 80000560 <panic>
    panic("virtio disk FEATURES_OK unset");
    800065b8:	00002517          	auipc	a0,0x2
    800065bc:	1d850513          	addi	a0,a0,472 # 80008790 <__func__.1+0x788>
    800065c0:	ffffa097          	auipc	ra,0xffffa
    800065c4:	fa0080e7          	jalr	-96(ra) # 80000560 <panic>
    panic("virtio disk should not be ready");
    800065c8:	00002517          	auipc	a0,0x2
    800065cc:	1e850513          	addi	a0,a0,488 # 800087b0 <__func__.1+0x7a8>
    800065d0:	ffffa097          	auipc	ra,0xffffa
    800065d4:	f90080e7          	jalr	-112(ra) # 80000560 <panic>
    panic("virtio disk has no queue 0");
    800065d8:	00002517          	auipc	a0,0x2
    800065dc:	1f850513          	addi	a0,a0,504 # 800087d0 <__func__.1+0x7c8>
    800065e0:	ffffa097          	auipc	ra,0xffffa
    800065e4:	f80080e7          	jalr	-128(ra) # 80000560 <panic>
    panic("virtio disk max queue too short");
    800065e8:	00002517          	auipc	a0,0x2
    800065ec:	20850513          	addi	a0,a0,520 # 800087f0 <__func__.1+0x7e8>
    800065f0:	ffffa097          	auipc	ra,0xffffa
    800065f4:	f70080e7          	jalr	-144(ra) # 80000560 <panic>
    panic("virtio disk kalloc");
    800065f8:	00002517          	auipc	a0,0x2
    800065fc:	21850513          	addi	a0,a0,536 # 80008810 <__func__.1+0x808>
    80006600:	ffffa097          	auipc	ra,0xffffa
    80006604:	f60080e7          	jalr	-160(ra) # 80000560 <panic>

0000000080006608 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006608:	711d                	addi	sp,sp,-96
    8000660a:	ec86                	sd	ra,88(sp)
    8000660c:	e8a2                	sd	s0,80(sp)
    8000660e:	e4a6                	sd	s1,72(sp)
    80006610:	e0ca                	sd	s2,64(sp)
    80006612:	fc4e                	sd	s3,56(sp)
    80006614:	f852                	sd	s4,48(sp)
    80006616:	f456                	sd	s5,40(sp)
    80006618:	f05a                	sd	s6,32(sp)
    8000661a:	ec5e                	sd	s7,24(sp)
    8000661c:	e862                	sd	s8,16(sp)
    8000661e:	1080                	addi	s0,sp,96
    80006620:	89aa                	mv	s3,a0
    80006622:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006624:	00c52b83          	lw	s7,12(a0)
    80006628:	001b9b9b          	slliw	s7,s7,0x1
    8000662c:	1b82                	slli	s7,s7,0x20
    8000662e:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80006632:	0001c517          	auipc	a0,0x1c
    80006636:	87650513          	addi	a0,a0,-1930 # 80021ea8 <disk+0x128>
    8000663a:	ffffa097          	auipc	ra,0xffffa
    8000663e:	6cc080e7          	jalr	1740(ra) # 80000d06 <acquire>
  for(int i = 0; i < NUM; i++){
    80006642:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006644:	0001ba97          	auipc	s5,0x1b
    80006648:	73ca8a93          	addi	s5,s5,1852 # 80021d80 <disk>
  for(int i = 0; i < 3; i++){
    8000664c:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    8000664e:	5c7d                	li	s8,-1
    80006650:	a885                	j	800066c0 <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    80006652:	00fa8733          	add	a4,s5,a5
    80006656:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000665a:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000665c:	0207c563          	bltz	a5,80006686 <virtio_disk_rw+0x7e>
  for(int i = 0; i < 3; i++){
    80006660:	2905                	addiw	s2,s2,1
    80006662:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80006664:	07490263          	beq	s2,s4,800066c8 <virtio_disk_rw+0xc0>
    idx[i] = alloc_desc();
    80006668:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000666a:	0001b717          	auipc	a4,0x1b
    8000666e:	71670713          	addi	a4,a4,1814 # 80021d80 <disk>
    80006672:	4781                	li	a5,0
    if(disk.free[i]){
    80006674:	01874683          	lbu	a3,24(a4)
    80006678:	fee9                	bnez	a3,80006652 <virtio_disk_rw+0x4a>
  for(int i = 0; i < NUM; i++){
    8000667a:	2785                	addiw	a5,a5,1
    8000667c:	0705                	addi	a4,a4,1
    8000667e:	fe979be3          	bne	a5,s1,80006674 <virtio_disk_rw+0x6c>
    idx[i] = alloc_desc();
    80006682:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80006686:	03205163          	blez	s2,800066a8 <virtio_disk_rw+0xa0>
        free_desc(idx[j]);
    8000668a:	fa042503          	lw	a0,-96(s0)
    8000668e:	00000097          	auipc	ra,0x0
    80006692:	cfc080e7          	jalr	-772(ra) # 8000638a <free_desc>
      for(int j = 0; j < i; j++)
    80006696:	4785                	li	a5,1
    80006698:	0127d863          	bge	a5,s2,800066a8 <virtio_disk_rw+0xa0>
        free_desc(idx[j]);
    8000669c:	fa442503          	lw	a0,-92(s0)
    800066a0:	00000097          	auipc	ra,0x0
    800066a4:	cea080e7          	jalr	-790(ra) # 8000638a <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800066a8:	0001c597          	auipc	a1,0x1c
    800066ac:	80058593          	addi	a1,a1,-2048 # 80021ea8 <disk+0x128>
    800066b0:	0001b517          	auipc	a0,0x1b
    800066b4:	6e850513          	addi	a0,a0,1768 # 80021d98 <disk+0x18>
    800066b8:	ffffc097          	auipc	ra,0xffffc
    800066bc:	d5c080e7          	jalr	-676(ra) # 80002414 <sleep>
  for(int i = 0; i < 3; i++){
    800066c0:	fa040613          	addi	a2,s0,-96
    800066c4:	4901                	li	s2,0
    800066c6:	b74d                	j	80006668 <virtio_disk_rw+0x60>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800066c8:	fa042503          	lw	a0,-96(s0)
    800066cc:	00451693          	slli	a3,a0,0x4

  if(write)
    800066d0:	0001b797          	auipc	a5,0x1b
    800066d4:	6b078793          	addi	a5,a5,1712 # 80021d80 <disk>
    800066d8:	00a50713          	addi	a4,a0,10
    800066dc:	0712                	slli	a4,a4,0x4
    800066de:	973e                	add	a4,a4,a5
    800066e0:	01603633          	snez	a2,s6
    800066e4:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800066e6:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800066ea:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800066ee:	6398                	ld	a4,0(a5)
    800066f0:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800066f2:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    800066f6:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800066f8:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800066fa:	6390                	ld	a2,0(a5)
    800066fc:	00d605b3          	add	a1,a2,a3
    80006700:	4741                	li	a4,16
    80006702:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006704:	4805                	li	a6,1
    80006706:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    8000670a:	fa442703          	lw	a4,-92(s0)
    8000670e:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006712:	0712                	slli	a4,a4,0x4
    80006714:	963a                	add	a2,a2,a4
    80006716:	05898593          	addi	a1,s3,88
    8000671a:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    8000671c:	0007b883          	ld	a7,0(a5)
    80006720:	9746                	add	a4,a4,a7
    80006722:	40000613          	li	a2,1024
    80006726:	c710                	sw	a2,8(a4)
  if(write)
    80006728:	001b3613          	seqz	a2,s6
    8000672c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006730:	01066633          	or	a2,a2,a6
    80006734:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80006738:	fa842583          	lw	a1,-88(s0)
    8000673c:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006740:	00250613          	addi	a2,a0,2
    80006744:	0612                	slli	a2,a2,0x4
    80006746:	963e                	add	a2,a2,a5
    80006748:	577d                	li	a4,-1
    8000674a:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000674e:	0592                	slli	a1,a1,0x4
    80006750:	98ae                	add	a7,a7,a1
    80006752:	03068713          	addi	a4,a3,48
    80006756:	973e                	add	a4,a4,a5
    80006758:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    8000675c:	6398                	ld	a4,0(a5)
    8000675e:	972e                	add	a4,a4,a1
    80006760:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006764:	4689                	li	a3,2
    80006766:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    8000676a:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000676e:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    80006772:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006776:	6794                	ld	a3,8(a5)
    80006778:	0026d703          	lhu	a4,2(a3)
    8000677c:	8b1d                	andi	a4,a4,7
    8000677e:	0706                	slli	a4,a4,0x1
    80006780:	96ba                	add	a3,a3,a4
    80006782:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80006786:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000678a:	6798                	ld	a4,8(a5)
    8000678c:	00275783          	lhu	a5,2(a4)
    80006790:	2785                	addiw	a5,a5,1
    80006792:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006796:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000679a:	100017b7          	lui	a5,0x10001
    8000679e:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800067a2:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    800067a6:	0001b917          	auipc	s2,0x1b
    800067aa:	70290913          	addi	s2,s2,1794 # 80021ea8 <disk+0x128>
  while(b->disk == 1) {
    800067ae:	84c2                	mv	s1,a6
    800067b0:	01079c63          	bne	a5,a6,800067c8 <virtio_disk_rw+0x1c0>
    sleep(b, &disk.vdisk_lock);
    800067b4:	85ca                	mv	a1,s2
    800067b6:	854e                	mv	a0,s3
    800067b8:	ffffc097          	auipc	ra,0xffffc
    800067bc:	c5c080e7          	jalr	-932(ra) # 80002414 <sleep>
  while(b->disk == 1) {
    800067c0:	0049a783          	lw	a5,4(s3)
    800067c4:	fe9788e3          	beq	a5,s1,800067b4 <virtio_disk_rw+0x1ac>
  }

  disk.info[idx[0]].b = 0;
    800067c8:	fa042903          	lw	s2,-96(s0)
    800067cc:	00290713          	addi	a4,s2,2
    800067d0:	0712                	slli	a4,a4,0x4
    800067d2:	0001b797          	auipc	a5,0x1b
    800067d6:	5ae78793          	addi	a5,a5,1454 # 80021d80 <disk>
    800067da:	97ba                	add	a5,a5,a4
    800067dc:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800067e0:	0001b997          	auipc	s3,0x1b
    800067e4:	5a098993          	addi	s3,s3,1440 # 80021d80 <disk>
    800067e8:	00491713          	slli	a4,s2,0x4
    800067ec:	0009b783          	ld	a5,0(s3)
    800067f0:	97ba                	add	a5,a5,a4
    800067f2:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800067f6:	854a                	mv	a0,s2
    800067f8:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800067fc:	00000097          	auipc	ra,0x0
    80006800:	b8e080e7          	jalr	-1138(ra) # 8000638a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006804:	8885                	andi	s1,s1,1
    80006806:	f0ed                	bnez	s1,800067e8 <virtio_disk_rw+0x1e0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006808:	0001b517          	auipc	a0,0x1b
    8000680c:	6a050513          	addi	a0,a0,1696 # 80021ea8 <disk+0x128>
    80006810:	ffffa097          	auipc	ra,0xffffa
    80006814:	5a6080e7          	jalr	1446(ra) # 80000db6 <release>
}
    80006818:	60e6                	ld	ra,88(sp)
    8000681a:	6446                	ld	s0,80(sp)
    8000681c:	64a6                	ld	s1,72(sp)
    8000681e:	6906                	ld	s2,64(sp)
    80006820:	79e2                	ld	s3,56(sp)
    80006822:	7a42                	ld	s4,48(sp)
    80006824:	7aa2                	ld	s5,40(sp)
    80006826:	7b02                	ld	s6,32(sp)
    80006828:	6be2                	ld	s7,24(sp)
    8000682a:	6c42                	ld	s8,16(sp)
    8000682c:	6125                	addi	sp,sp,96
    8000682e:	8082                	ret

0000000080006830 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006830:	1101                	addi	sp,sp,-32
    80006832:	ec06                	sd	ra,24(sp)
    80006834:	e822                	sd	s0,16(sp)
    80006836:	e426                	sd	s1,8(sp)
    80006838:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000683a:	0001b497          	auipc	s1,0x1b
    8000683e:	54648493          	addi	s1,s1,1350 # 80021d80 <disk>
    80006842:	0001b517          	auipc	a0,0x1b
    80006846:	66650513          	addi	a0,a0,1638 # 80021ea8 <disk+0x128>
    8000684a:	ffffa097          	auipc	ra,0xffffa
    8000684e:	4bc080e7          	jalr	1212(ra) # 80000d06 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006852:	100017b7          	lui	a5,0x10001
    80006856:	53bc                	lw	a5,96(a5)
    80006858:	8b8d                	andi	a5,a5,3
    8000685a:	10001737          	lui	a4,0x10001
    8000685e:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80006860:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006864:	689c                	ld	a5,16(s1)
    80006866:	0204d703          	lhu	a4,32(s1)
    8000686a:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    8000686e:	04f70863          	beq	a4,a5,800068be <virtio_disk_intr+0x8e>
    __sync_synchronize();
    80006872:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006876:	6898                	ld	a4,16(s1)
    80006878:	0204d783          	lhu	a5,32(s1)
    8000687c:	8b9d                	andi	a5,a5,7
    8000687e:	078e                	slli	a5,a5,0x3
    80006880:	97ba                	add	a5,a5,a4
    80006882:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006884:	00278713          	addi	a4,a5,2
    80006888:	0712                	slli	a4,a4,0x4
    8000688a:	9726                	add	a4,a4,s1
    8000688c:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80006890:	e721                	bnez	a4,800068d8 <virtio_disk_intr+0xa8>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006892:	0789                	addi	a5,a5,2
    80006894:	0792                	slli	a5,a5,0x4
    80006896:	97a6                	add	a5,a5,s1
    80006898:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000689a:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000689e:	ffffc097          	auipc	ra,0xffffc
    800068a2:	bda080e7          	jalr	-1062(ra) # 80002478 <wakeup>

    disk.used_idx += 1;
    800068a6:	0204d783          	lhu	a5,32(s1)
    800068aa:	2785                	addiw	a5,a5,1
    800068ac:	17c2                	slli	a5,a5,0x30
    800068ae:	93c1                	srli	a5,a5,0x30
    800068b0:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800068b4:	6898                	ld	a4,16(s1)
    800068b6:	00275703          	lhu	a4,2(a4)
    800068ba:	faf71ce3          	bne	a4,a5,80006872 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    800068be:	0001b517          	auipc	a0,0x1b
    800068c2:	5ea50513          	addi	a0,a0,1514 # 80021ea8 <disk+0x128>
    800068c6:	ffffa097          	auipc	ra,0xffffa
    800068ca:	4f0080e7          	jalr	1264(ra) # 80000db6 <release>
}
    800068ce:	60e2                	ld	ra,24(sp)
    800068d0:	6442                	ld	s0,16(sp)
    800068d2:	64a2                	ld	s1,8(sp)
    800068d4:	6105                	addi	sp,sp,32
    800068d6:	8082                	ret
      panic("virtio_disk_intr status");
    800068d8:	00002517          	auipc	a0,0x2
    800068dc:	f5050513          	addi	a0,a0,-176 # 80008828 <__func__.1+0x820>
    800068e0:	ffffa097          	auipc	ra,0xffffa
    800068e4:	c80080e7          	jalr	-896(ra) # 80000560 <panic>
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
