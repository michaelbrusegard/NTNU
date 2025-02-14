
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	b4010113          	addi	sp,sp,-1216 # 80008b40 <stack0>
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
  asm volatile("csrr %0, mhartid" : "=r" (x) );
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
    80000054:	9b078793          	addi	a5,a5,-1616 # 80008a00 <timer_scratch>
    80000058:	97ba                	add	a5,a5,a4
  scratch[3] = CLINT_MTIMECMP(id);
    8000005a:	ef90                	sd	a2,24(a5)
  scratch[4] = interval;
    8000005c:	f394                	sd	a3,32(a5)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000005e:	34079073          	csrw	mscratch,a5
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000062:	00006797          	auipc	a5,0x6
    80000066:	0ae78793          	addi	a5,a5,174 # 80006110 <timervec>
    8000006a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000072:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000076:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000007e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
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
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000096:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000009a:	7779                	lui	a4,0xffffe
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc98f>
    800000a0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a2:	6705                	lui	a4,0x1
    800000a4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000aa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ae:	00001797          	auipc	a5,0x1
    800000b2:	e4278793          	addi	a5,a5,-446 # 80000ef0 <main>
    800000b6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000ba:	4781                	li	a5,0
    800000bc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000c0:	67c1                	lui	a5,0x10
    800000c2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000c4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000cc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000d0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d8:	57fd                	li	a5,-1
    800000da:	83a9                	srli	a5,a5,0xa
    800000dc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000e0:	47bd                	li	a5,15
    800000e2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e6:	00000097          	auipc	ra,0x0
    800000ea:	f36080e7          	jalr	-202(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ee:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f2:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
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
    80000138:	63e080e7          	jalr	1598(ra) # 80002772 <either_copyin>
    8000013c:	03550663          	beq	a0,s5,80000168 <consolewrite+0x66>
            break;
        uartputc(c);
    80000140:	faf44503          	lbu	a0,-81(s0)
    80000144:	00000097          	auipc	ra,0x0
    80000148:	7da080e7          	jalr	2010(ra) # 8000091e <uartputc>
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
    800001a0:	9a450513          	addi	a0,a0,-1628 # 80010b40 <cons>
    800001a4:	00001097          	auipc	ra,0x1
    800001a8:	a9a080e7          	jalr	-1382(ra) # 80000c3e <acquire>
    while (n > 0)
    {
        // wait until interrupt handler has put some
        // input into cons.buffer.
        while (cons.r == cons.w)
    800001ac:	00011497          	auipc	s1,0x11
    800001b0:	99448493          	addi	s1,s1,-1644 # 80010b40 <cons>
            if (killed(myproc()))
            {
                release(&cons.lock);
                return -1;
            }
            sleep(&cons.r, &cons.lock);
    800001b4:	00011917          	auipc	s2,0x11
    800001b8:	a2490913          	addi	s2,s2,-1500 # 80010bd8 <cons+0x98>
    while (n > 0)
    800001bc:	0d305563          	blez	s3,80000286 <consoleread+0x106>
        while (cons.r == cons.w)
    800001c0:	0984a783          	lw	a5,152(s1)
    800001c4:	09c4a703          	lw	a4,156(s1)
    800001c8:	0af71a63          	bne	a4,a5,8000027c <consoleread+0xfc>
            if (killed(myproc()))
    800001cc:	00002097          	auipc	ra,0x2
    800001d0:	974080e7          	jalr	-1676(ra) # 80001b40 <myproc>
    800001d4:	00002097          	auipc	ra,0x2
    800001d8:	3ee080e7          	jalr	1006(ra) # 800025c2 <killed>
    800001dc:	e52d                	bnez	a0,80000246 <consoleread+0xc6>
            sleep(&cons.r, &cons.lock);
    800001de:	85a6                	mv	a1,s1
    800001e0:	854a                	mv	a0,s2
    800001e2:	00002097          	auipc	ra,0x2
    800001e6:	138080e7          	jalr	312(ra) # 8000231a <sleep>
        while (cons.r == cons.w)
    800001ea:	0984a783          	lw	a5,152(s1)
    800001ee:	09c4a703          	lw	a4,156(s1)
    800001f2:	fcf70de3          	beq	a4,a5,800001cc <consoleread+0x4c>
    800001f6:	ec5e                	sd	s7,24(sp)
        }

        c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001f8:	00011717          	auipc	a4,0x11
    800001fc:	94870713          	addi	a4,a4,-1720 # 80010b40 <cons>
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
    8000022e:	4f2080e7          	jalr	1266(ra) # 8000271c <either_copyout>
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
    8000024a:	8fa50513          	addi	a0,a0,-1798 # 80010b40 <cons>
    8000024e:	00001097          	auipc	ra,0x1
    80000252:	aa0080e7          	jalr	-1376(ra) # 80000cee <release>
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
    80000274:	96f72423          	sw	a5,-1688(a4) # 80010bd8 <cons+0x98>
    80000278:	6be2                	ld	s7,24(sp)
    8000027a:	a031                	j	80000286 <consoleread+0x106>
    8000027c:	ec5e                	sd	s7,24(sp)
    8000027e:	bfad                	j	800001f8 <consoleread+0x78>
    80000280:	6be2                	ld	s7,24(sp)
    80000282:	a011                	j	80000286 <consoleread+0x106>
    80000284:	6be2                	ld	s7,24(sp)
    release(&cons.lock);
    80000286:	00011517          	auipc	a0,0x11
    8000028a:	8ba50513          	addi	a0,a0,-1862 # 80010b40 <cons>
    8000028e:	00001097          	auipc	ra,0x1
    80000292:	a60080e7          	jalr	-1440(ra) # 80000cee <release>
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
    800002b4:	590080e7          	jalr	1424(ra) # 80000840 <uartputc_sync>
}
    800002b8:	60a2                	ld	ra,8(sp)
    800002ba:	6402                	ld	s0,0(sp)
    800002bc:	0141                	addi	sp,sp,16
    800002be:	8082                	ret
        uartputc_sync('\b');
    800002c0:	4521                	li	a0,8
    800002c2:	00000097          	auipc	ra,0x0
    800002c6:	57e080e7          	jalr	1406(ra) # 80000840 <uartputc_sync>
        uartputc_sync(' ');
    800002ca:	02000513          	li	a0,32
    800002ce:	00000097          	auipc	ra,0x0
    800002d2:	572080e7          	jalr	1394(ra) # 80000840 <uartputc_sync>
        uartputc_sync('\b');
    800002d6:	4521                	li	a0,8
    800002d8:	00000097          	auipc	ra,0x0
    800002dc:	568080e7          	jalr	1384(ra) # 80000840 <uartputc_sync>
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
    800002f2:	85250513          	addi	a0,a0,-1966 # 80010b40 <cons>
    800002f6:	00001097          	auipc	ra,0x1
    800002fa:	948080e7          	jalr	-1720(ra) # 80000c3e <acquire>

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
    80000318:	4b4080e7          	jalr	1204(ra) # 800027c8 <procdump>
            }
        }
        break;
    }

    release(&cons.lock);
    8000031c:	00011517          	auipc	a0,0x11
    80000320:	82450513          	addi	a0,a0,-2012 # 80010b40 <cons>
    80000324:	00001097          	auipc	ra,0x1
    80000328:	9ca080e7          	jalr	-1590(ra) # 80000cee <release>
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
    80000342:	80270713          	addi	a4,a4,-2046 # 80010b40 <cons>
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
    80000368:	00010797          	auipc	a5,0x10
    8000036c:	7d878793          	addi	a5,a5,2008 # 80010b40 <cons>
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
    80000398:	8447a783          	lw	a5,-1980(a5) # 80010bd8 <cons+0x98>
    8000039c:	9f1d                	subw	a4,a4,a5
    8000039e:	08000793          	li	a5,128
    800003a2:	f6f71de3          	bne	a4,a5,8000031c <consoleintr+0x3a>
    800003a6:	a0c9                	j	80000468 <consoleintr+0x186>
    800003a8:	e84a                	sd	s2,16(sp)
    800003aa:	e44e                	sd	s3,8(sp)
        while (cons.e != cons.w &&
    800003ac:	00010717          	auipc	a4,0x10
    800003b0:	79470713          	addi	a4,a4,1940 # 80010b40 <cons>
    800003b4:	0a072783          	lw	a5,160(a4)
    800003b8:	09c72703          	lw	a4,156(a4)
               cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n')
    800003bc:	00010497          	auipc	s1,0x10
    800003c0:	78448493          	addi	s1,s1,1924 # 80010b40 <cons>
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
    8000040e:	73670713          	addi	a4,a4,1846 # 80010b40 <cons>
    80000412:	0a072783          	lw	a5,160(a4)
    80000416:	09c72703          	lw	a4,156(a4)
    8000041a:	f0f701e3          	beq	a4,a5,8000031c <consoleintr+0x3a>
            cons.e--;
    8000041e:	37fd                	addiw	a5,a5,-1
    80000420:	00010717          	auipc	a4,0x10
    80000424:	7cf72023          	sw	a5,1984(a4) # 80010be0 <cons+0xa0>
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
    8000044a:	6fa78793          	addi	a5,a5,1786 # 80010b40 <cons>
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
    8000046c:	76c7aa23          	sw	a2,1908(a5) # 80010bdc <cons+0x9c>
                wakeup(&cons.r);
    80000470:	00010517          	auipc	a0,0x10
    80000474:	76850513          	addi	a0,a0,1896 # 80010bd8 <cons+0x98>
    80000478:	00002097          	auipc	ra,0x2
    8000047c:	f06080e7          	jalr	-250(ra) # 8000237e <wakeup>
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
    80000496:	6ae50513          	addi	a0,a0,1710 # 80010b40 <cons>
    8000049a:	00000097          	auipc	ra,0x0
    8000049e:	710080e7          	jalr	1808(ra) # 80000baa <initlock>

    uartinit();
    800004a2:	00000097          	auipc	ra,0x0
    800004a6:	344080e7          	jalr	836(ra) # 800007e6 <uartinit>

    // connect read and write system calls
    // to consoleread and consolewrite.
    devsw[CONSOLE].read = consoleread;
    800004aa:	00021797          	auipc	a5,0x21
    800004ae:	82e78793          	addi	a5,a5,-2002 # 80020cd8 <devsw>
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

  if(sign && (sign = xx < 0))
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
  do {
    buf[i++] = digits[x % base];
    800004ea:	00008817          	auipc	a6,0x8
    800004ee:	32680813          	addi	a6,a6,806 # 80008810 <digits>
    800004f2:	88be                	mv	a7,a5
    800004f4:	0017861b          	addiw	a2,a5,1
    800004f8:	87b2                	mv	a5,a2
    800004fa:	02b5773b          	remuw	a4,a0,a1
    800004fe:	1702                	slli	a4,a4,0x20
    80000500:	9301                	srli	a4,a4,0x20
    80000502:	9742                	add	a4,a4,a6
    80000504:	00074703          	lbu	a4,0(a4)
    80000508:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    8000050c:	872a                	mv	a4,a0
    8000050e:	02b5553b          	divuw	a0,a0,a1
    80000512:	0685                	addi	a3,a3,1
    80000514:	fcb77fe3          	bgeu	a4,a1,800004f2 <printint+0x24>

  if(sign)
    80000518:	000e0c63          	beqz	t3,80000530 <printint+0x62>
    buf[i++] = '-';
    8000051c:	fe060793          	addi	a5,a2,-32
    80000520:	00878633          	add	a2,a5,s0
    80000524:	02d00793          	li	a5,45
    80000528:	fef60823          	sb	a5,-16(a2)
    8000052c:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    80000530:	fff7891b          	addiw	s2,a5,-1
    80000534:	006784b3          	add	s1,a5,t1
    consputc(buf[i]);
    80000538:	fff4c503          	lbu	a0,-1(s1)
    8000053c:	00000097          	auipc	ra,0x0
    80000540:	d64080e7          	jalr	-668(ra) # 800002a0 <consputc>
  while(--i >= 0)
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
  if(sign && (sign = xx < 0))
    8000055c:	4e05                	li	t3,1
    x = -xx;
    8000055e:	b751                	j	800004e2 <printint+0x14>

0000000080000560 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80000560:	1101                	addi	sp,sp,-32
    80000562:	ec06                	sd	ra,24(sp)
    80000564:	e822                	sd	s0,16(sp)
    80000566:	e426                	sd	s1,8(sp)
    80000568:	1000                	addi	s0,sp,32
    8000056a:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000056c:	00010797          	auipc	a5,0x10
    80000570:	6807aa23          	sw	zero,1684(a5) # 80010c00 <pr+0x18>
  printf("panic: ");
    80000574:	00008517          	auipc	a0,0x8
    80000578:	a9450513          	addi	a0,a0,-1388 # 80008008 <etext+0x8>
    8000057c:	00000097          	auipc	ra,0x0
    80000580:	02e080e7          	jalr	46(ra) # 800005aa <printf>
  printf(s);
    80000584:	8526                	mv	a0,s1
    80000586:	00000097          	auipc	ra,0x0
    8000058a:	024080e7          	jalr	36(ra) # 800005aa <printf>
  printf("\n");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	a8250513          	addi	a0,a0,-1406 # 80008010 <etext+0x10>
    80000596:	00000097          	auipc	ra,0x0
    8000059a:	014080e7          	jalr	20(ra) # 800005aa <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000059e:	4785                	li	a5,1
    800005a0:	00008717          	auipc	a4,0x8
    800005a4:	42f72023          	sw	a5,1056(a4) # 800089c0 <panicked>
  for(;;)
    800005a8:	a001                	j	800005a8 <panic+0x48>

00000000800005aa <printf>:
{
    800005aa:	7131                	addi	sp,sp,-192
    800005ac:	fc86                	sd	ra,120(sp)
    800005ae:	f8a2                	sd	s0,112(sp)
    800005b0:	e8d2                	sd	s4,80(sp)
    800005b2:	ec6e                	sd	s11,24(sp)
    800005b4:	0100                	addi	s0,sp,128
    800005b6:	8a2a                	mv	s4,a0
    800005b8:	e40c                	sd	a1,8(s0)
    800005ba:	e810                	sd	a2,16(s0)
    800005bc:	ec14                	sd	a3,24(s0)
    800005be:	f018                	sd	a4,32(s0)
    800005c0:	f41c                	sd	a5,40(s0)
    800005c2:	03043823          	sd	a6,48(s0)
    800005c6:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005ca:	00010d97          	auipc	s11,0x10
    800005ce:	636dad83          	lw	s11,1590(s11) # 80010c00 <pr+0x18>
  if(locking)
    800005d2:	040d9463          	bnez	s11,8000061a <printf+0x70>
  if (fmt == 0)
    800005d6:	040a0b63          	beqz	s4,8000062c <printf+0x82>
  va_start(ap, fmt);
    800005da:	00840793          	addi	a5,s0,8
    800005de:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005e2:	000a4503          	lbu	a0,0(s4)
    800005e6:	18050c63          	beqz	a0,8000077e <printf+0x1d4>
    800005ea:	f4a6                	sd	s1,104(sp)
    800005ec:	f0ca                	sd	s2,96(sp)
    800005ee:	ecce                	sd	s3,88(sp)
    800005f0:	e4d6                	sd	s5,72(sp)
    800005f2:	e0da                	sd	s6,64(sp)
    800005f4:	fc5e                	sd	s7,56(sp)
    800005f6:	f862                	sd	s8,48(sp)
    800005f8:	f466                	sd	s9,40(sp)
    800005fa:	f06a                	sd	s10,32(sp)
    800005fc:	4981                	li	s3,0
    if(c != '%'){
    800005fe:	02500b13          	li	s6,37
    switch(c){
    80000602:	07000b93          	li	s7,112
  consputc('x');
    80000606:	07800c93          	li	s9,120
    8000060a:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000060c:	00008a97          	auipc	s5,0x8
    80000610:	204a8a93          	addi	s5,s5,516 # 80008810 <digits>
    switch(c){
    80000614:	07300c13          	li	s8,115
    80000618:	a0b9                	j	80000666 <printf+0xbc>
    acquire(&pr.lock);
    8000061a:	00010517          	auipc	a0,0x10
    8000061e:	5ce50513          	addi	a0,a0,1486 # 80010be8 <pr>
    80000622:	00000097          	auipc	ra,0x0
    80000626:	61c080e7          	jalr	1564(ra) # 80000c3e <acquire>
    8000062a:	b775                	j	800005d6 <printf+0x2c>
    8000062c:	f4a6                	sd	s1,104(sp)
    8000062e:	f0ca                	sd	s2,96(sp)
    80000630:	ecce                	sd	s3,88(sp)
    80000632:	e4d6                	sd	s5,72(sp)
    80000634:	e0da                	sd	s6,64(sp)
    80000636:	fc5e                	sd	s7,56(sp)
    80000638:	f862                	sd	s8,48(sp)
    8000063a:	f466                	sd	s9,40(sp)
    8000063c:	f06a                	sd	s10,32(sp)
    panic("null fmt");
    8000063e:	00008517          	auipc	a0,0x8
    80000642:	9e250513          	addi	a0,a0,-1566 # 80008020 <etext+0x20>
    80000646:	00000097          	auipc	ra,0x0
    8000064a:	f1a080e7          	jalr	-230(ra) # 80000560 <panic>
      consputc(c);
    8000064e:	00000097          	auipc	ra,0x0
    80000652:	c52080e7          	jalr	-942(ra) # 800002a0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000656:	0019879b          	addiw	a5,s3,1
    8000065a:	89be                	mv	s3,a5
    8000065c:	97d2                	add	a5,a5,s4
    8000065e:	0007c503          	lbu	a0,0(a5)
    80000662:	10050563          	beqz	a0,8000076c <printf+0x1c2>
    if(c != '%'){
    80000666:	ff6514e3          	bne	a0,s6,8000064e <printf+0xa4>
    c = fmt[++i] & 0xff;
    8000066a:	0019879b          	addiw	a5,s3,1
    8000066e:	89be                	mv	s3,a5
    80000670:	97d2                	add	a5,a5,s4
    80000672:	0007c783          	lbu	a5,0(a5)
    80000676:	0007849b          	sext.w	s1,a5
    if(c == 0)
    8000067a:	10078a63          	beqz	a5,8000078e <printf+0x1e4>
    switch(c){
    8000067e:	05778a63          	beq	a5,s7,800006d2 <printf+0x128>
    80000682:	02fbf463          	bgeu	s7,a5,800006aa <printf+0x100>
    80000686:	09878763          	beq	a5,s8,80000714 <printf+0x16a>
    8000068a:	0d979663          	bne	a5,s9,80000756 <printf+0x1ac>
      printint(va_arg(ap, int), 16, 1);
    8000068e:	f8843783          	ld	a5,-120(s0)
    80000692:	00878713          	addi	a4,a5,8
    80000696:	f8e43423          	sd	a4,-120(s0)
    8000069a:	4605                	li	a2,1
    8000069c:	85ea                	mv	a1,s10
    8000069e:	4388                	lw	a0,0(a5)
    800006a0:	00000097          	auipc	ra,0x0
    800006a4:	e2e080e7          	jalr	-466(ra) # 800004ce <printint>
      break;
    800006a8:	b77d                	j	80000656 <printf+0xac>
    switch(c){
    800006aa:	0b678063          	beq	a5,s6,8000074a <printf+0x1a0>
    800006ae:	06400713          	li	a4,100
    800006b2:	0ae79263          	bne	a5,a4,80000756 <printf+0x1ac>
      printint(va_arg(ap, int), 10, 1);
    800006b6:	f8843783          	ld	a5,-120(s0)
    800006ba:	00878713          	addi	a4,a5,8
    800006be:	f8e43423          	sd	a4,-120(s0)
    800006c2:	4605                	li	a2,1
    800006c4:	45a9                	li	a1,10
    800006c6:	4388                	lw	a0,0(a5)
    800006c8:	00000097          	auipc	ra,0x0
    800006cc:	e06080e7          	jalr	-506(ra) # 800004ce <printint>
      break;
    800006d0:	b759                	j	80000656 <printf+0xac>
      printptr(va_arg(ap, uint64));
    800006d2:	f8843783          	ld	a5,-120(s0)
    800006d6:	00878713          	addi	a4,a5,8
    800006da:	f8e43423          	sd	a4,-120(s0)
    800006de:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006e2:	03000513          	li	a0,48
    800006e6:	00000097          	auipc	ra,0x0
    800006ea:	bba080e7          	jalr	-1094(ra) # 800002a0 <consputc>
  consputc('x');
    800006ee:	8566                	mv	a0,s9
    800006f0:	00000097          	auipc	ra,0x0
    800006f4:	bb0080e7          	jalr	-1104(ra) # 800002a0 <consputc>
    800006f8:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006fa:	03c95793          	srli	a5,s2,0x3c
    800006fe:	97d6                	add	a5,a5,s5
    80000700:	0007c503          	lbu	a0,0(a5)
    80000704:	00000097          	auipc	ra,0x0
    80000708:	b9c080e7          	jalr	-1124(ra) # 800002a0 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000070c:	0912                	slli	s2,s2,0x4
    8000070e:	34fd                	addiw	s1,s1,-1
    80000710:	f4ed                	bnez	s1,800006fa <printf+0x150>
    80000712:	b791                	j	80000656 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80000714:	f8843783          	ld	a5,-120(s0)
    80000718:	00878713          	addi	a4,a5,8
    8000071c:	f8e43423          	sd	a4,-120(s0)
    80000720:	6384                	ld	s1,0(a5)
    80000722:	cc89                	beqz	s1,8000073c <printf+0x192>
      for(; *s; s++)
    80000724:	0004c503          	lbu	a0,0(s1)
    80000728:	d51d                	beqz	a0,80000656 <printf+0xac>
        consputc(*s);
    8000072a:	00000097          	auipc	ra,0x0
    8000072e:	b76080e7          	jalr	-1162(ra) # 800002a0 <consputc>
      for(; *s; s++)
    80000732:	0485                	addi	s1,s1,1
    80000734:	0004c503          	lbu	a0,0(s1)
    80000738:	f96d                	bnez	a0,8000072a <printf+0x180>
    8000073a:	bf31                	j	80000656 <printf+0xac>
        s = "(null)";
    8000073c:	00008497          	auipc	s1,0x8
    80000740:	8dc48493          	addi	s1,s1,-1828 # 80008018 <etext+0x18>
      for(; *s; s++)
    80000744:	02800513          	li	a0,40
    80000748:	b7cd                	j	8000072a <printf+0x180>
      consputc('%');
    8000074a:	855a                	mv	a0,s6
    8000074c:	00000097          	auipc	ra,0x0
    80000750:	b54080e7          	jalr	-1196(ra) # 800002a0 <consputc>
      break;
    80000754:	b709                	j	80000656 <printf+0xac>
      consputc('%');
    80000756:	855a                	mv	a0,s6
    80000758:	00000097          	auipc	ra,0x0
    8000075c:	b48080e7          	jalr	-1208(ra) # 800002a0 <consputc>
      consputc(c);
    80000760:	8526                	mv	a0,s1
    80000762:	00000097          	auipc	ra,0x0
    80000766:	b3e080e7          	jalr	-1218(ra) # 800002a0 <consputc>
      break;
    8000076a:	b5f5                	j	80000656 <printf+0xac>
    8000076c:	74a6                	ld	s1,104(sp)
    8000076e:	7906                	ld	s2,96(sp)
    80000770:	69e6                	ld	s3,88(sp)
    80000772:	6aa6                	ld	s5,72(sp)
    80000774:	6b06                	ld	s6,64(sp)
    80000776:	7be2                	ld	s7,56(sp)
    80000778:	7c42                	ld	s8,48(sp)
    8000077a:	7ca2                	ld	s9,40(sp)
    8000077c:	7d02                	ld	s10,32(sp)
  if(locking)
    8000077e:	020d9263          	bnez	s11,800007a2 <printf+0x1f8>
}
    80000782:	70e6                	ld	ra,120(sp)
    80000784:	7446                	ld	s0,112(sp)
    80000786:	6a46                	ld	s4,80(sp)
    80000788:	6de2                	ld	s11,24(sp)
    8000078a:	6129                	addi	sp,sp,192
    8000078c:	8082                	ret
    8000078e:	74a6                	ld	s1,104(sp)
    80000790:	7906                	ld	s2,96(sp)
    80000792:	69e6                	ld	s3,88(sp)
    80000794:	6aa6                	ld	s5,72(sp)
    80000796:	6b06                	ld	s6,64(sp)
    80000798:	7be2                	ld	s7,56(sp)
    8000079a:	7c42                	ld	s8,48(sp)
    8000079c:	7ca2                	ld	s9,40(sp)
    8000079e:	7d02                	ld	s10,32(sp)
    800007a0:	bff9                	j	8000077e <printf+0x1d4>
    release(&pr.lock);
    800007a2:	00010517          	auipc	a0,0x10
    800007a6:	44650513          	addi	a0,a0,1094 # 80010be8 <pr>
    800007aa:	00000097          	auipc	ra,0x0
    800007ae:	544080e7          	jalr	1348(ra) # 80000cee <release>
}
    800007b2:	bfc1                	j	80000782 <printf+0x1d8>

00000000800007b4 <printfinit>:
    ;
}

void
printfinit(void)
{
    800007b4:	1101                	addi	sp,sp,-32
    800007b6:	ec06                	sd	ra,24(sp)
    800007b8:	e822                	sd	s0,16(sp)
    800007ba:	e426                	sd	s1,8(sp)
    800007bc:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800007be:	00010497          	auipc	s1,0x10
    800007c2:	42a48493          	addi	s1,s1,1066 # 80010be8 <pr>
    800007c6:	00008597          	auipc	a1,0x8
    800007ca:	86a58593          	addi	a1,a1,-1942 # 80008030 <etext+0x30>
    800007ce:	8526                	mv	a0,s1
    800007d0:	00000097          	auipc	ra,0x0
    800007d4:	3da080e7          	jalr	986(ra) # 80000baa <initlock>
  pr.locking = 1;
    800007d8:	4785                	li	a5,1
    800007da:	cc9c                	sw	a5,24(s1)
}
    800007dc:	60e2                	ld	ra,24(sp)
    800007de:	6442                	ld	s0,16(sp)
    800007e0:	64a2                	ld	s1,8(sp)
    800007e2:	6105                	addi	sp,sp,32
    800007e4:	8082                	ret

00000000800007e6 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007e6:	1141                	addi	sp,sp,-16
    800007e8:	e406                	sd	ra,8(sp)
    800007ea:	e022                	sd	s0,0(sp)
    800007ec:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007ee:	100007b7          	lui	a5,0x10000
    800007f2:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007f6:	10000737          	lui	a4,0x10000
    800007fa:	f8000693          	li	a3,-128
    800007fe:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000802:	468d                	li	a3,3
    80000804:	10000637          	lui	a2,0x10000
    80000808:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000080c:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000810:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000814:	8732                	mv	a4,a2
    80000816:	461d                	li	a2,7
    80000818:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000081c:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000820:	00008597          	auipc	a1,0x8
    80000824:	81858593          	addi	a1,a1,-2024 # 80008038 <etext+0x38>
    80000828:	00010517          	auipc	a0,0x10
    8000082c:	3e050513          	addi	a0,a0,992 # 80010c08 <uart_tx_lock>
    80000830:	00000097          	auipc	ra,0x0
    80000834:	37a080e7          	jalr	890(ra) # 80000baa <initlock>
}
    80000838:	60a2                	ld	ra,8(sp)
    8000083a:	6402                	ld	s0,0(sp)
    8000083c:	0141                	addi	sp,sp,16
    8000083e:	8082                	ret

0000000080000840 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000840:	1101                	addi	sp,sp,-32
    80000842:	ec06                	sd	ra,24(sp)
    80000844:	e822                	sd	s0,16(sp)
    80000846:	e426                	sd	s1,8(sp)
    80000848:	1000                	addi	s0,sp,32
    8000084a:	84aa                	mv	s1,a0
  push_off();
    8000084c:	00000097          	auipc	ra,0x0
    80000850:	3a6080e7          	jalr	934(ra) # 80000bf2 <push_off>

  if(panicked){
    80000854:	00008797          	auipc	a5,0x8
    80000858:	16c7a783          	lw	a5,364(a5) # 800089c0 <panicked>
    8000085c:	eb85                	bnez	a5,8000088c <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000085e:	10000737          	lui	a4,0x10000
    80000862:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000864:	00074783          	lbu	a5,0(a4)
    80000868:	0207f793          	andi	a5,a5,32
    8000086c:	dfe5                	beqz	a5,80000864 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000086e:	0ff4f513          	zext.b	a0,s1
    80000872:	100007b7          	lui	a5,0x10000
    80000876:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000087a:	00000097          	auipc	ra,0x0
    8000087e:	418080e7          	jalr	1048(ra) # 80000c92 <pop_off>
}
    80000882:	60e2                	ld	ra,24(sp)
    80000884:	6442                	ld	s0,16(sp)
    80000886:	64a2                	ld	s1,8(sp)
    80000888:	6105                	addi	sp,sp,32
    8000088a:	8082                	ret
    for(;;)
    8000088c:	a001                	j	8000088c <uartputc_sync+0x4c>

000000008000088e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000088e:	00008797          	auipc	a5,0x8
    80000892:	13a7b783          	ld	a5,314(a5) # 800089c8 <uart_tx_r>
    80000896:	00008717          	auipc	a4,0x8
    8000089a:	13a73703          	ld	a4,314(a4) # 800089d0 <uart_tx_w>
    8000089e:	06f70f63          	beq	a4,a5,8000091c <uartstart+0x8e>
{
    800008a2:	7139                	addi	sp,sp,-64
    800008a4:	fc06                	sd	ra,56(sp)
    800008a6:	f822                	sd	s0,48(sp)
    800008a8:	f426                	sd	s1,40(sp)
    800008aa:	f04a                	sd	s2,32(sp)
    800008ac:	ec4e                	sd	s3,24(sp)
    800008ae:	e852                	sd	s4,16(sp)
    800008b0:	e456                	sd	s5,8(sp)
    800008b2:	e05a                	sd	s6,0(sp)
    800008b4:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008b6:	10000937          	lui	s2,0x10000
    800008ba:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008bc:	00010a97          	auipc	s5,0x10
    800008c0:	34ca8a93          	addi	s5,s5,844 # 80010c08 <uart_tx_lock>
    uart_tx_r += 1;
    800008c4:	00008497          	auipc	s1,0x8
    800008c8:	10448493          	addi	s1,s1,260 # 800089c8 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008cc:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008d0:	00008997          	auipc	s3,0x8
    800008d4:	10098993          	addi	s3,s3,256 # 800089d0 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008d8:	00094703          	lbu	a4,0(s2)
    800008dc:	02077713          	andi	a4,a4,32
    800008e0:	c705                	beqz	a4,80000908 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008e2:	01f7f713          	andi	a4,a5,31
    800008e6:	9756                	add	a4,a4,s5
    800008e8:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800008ec:	0785                	addi	a5,a5,1
    800008ee:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800008f0:	8526                	mv	a0,s1
    800008f2:	00002097          	auipc	ra,0x2
    800008f6:	a8c080e7          	jalr	-1396(ra) # 8000237e <wakeup>
    WriteReg(THR, c);
    800008fa:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800008fe:	609c                	ld	a5,0(s1)
    80000900:	0009b703          	ld	a4,0(s3)
    80000904:	fcf71ae3          	bne	a4,a5,800008d8 <uartstart+0x4a>
  }
}
    80000908:	70e2                	ld	ra,56(sp)
    8000090a:	7442                	ld	s0,48(sp)
    8000090c:	74a2                	ld	s1,40(sp)
    8000090e:	7902                	ld	s2,32(sp)
    80000910:	69e2                	ld	s3,24(sp)
    80000912:	6a42                	ld	s4,16(sp)
    80000914:	6aa2                	ld	s5,8(sp)
    80000916:	6b02                	ld	s6,0(sp)
    80000918:	6121                	addi	sp,sp,64
    8000091a:	8082                	ret
    8000091c:	8082                	ret

000000008000091e <uartputc>:
{
    8000091e:	7179                	addi	sp,sp,-48
    80000920:	f406                	sd	ra,40(sp)
    80000922:	f022                	sd	s0,32(sp)
    80000924:	ec26                	sd	s1,24(sp)
    80000926:	e84a                	sd	s2,16(sp)
    80000928:	e44e                	sd	s3,8(sp)
    8000092a:	e052                	sd	s4,0(sp)
    8000092c:	1800                	addi	s0,sp,48
    8000092e:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80000930:	00010517          	auipc	a0,0x10
    80000934:	2d850513          	addi	a0,a0,728 # 80010c08 <uart_tx_lock>
    80000938:	00000097          	auipc	ra,0x0
    8000093c:	306080e7          	jalr	774(ra) # 80000c3e <acquire>
  if(panicked){
    80000940:	00008797          	auipc	a5,0x8
    80000944:	0807a783          	lw	a5,128(a5) # 800089c0 <panicked>
    80000948:	e7c9                	bnez	a5,800009d2 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000094a:	00008717          	auipc	a4,0x8
    8000094e:	08673703          	ld	a4,134(a4) # 800089d0 <uart_tx_w>
    80000952:	00008797          	auipc	a5,0x8
    80000956:	0767b783          	ld	a5,118(a5) # 800089c8 <uart_tx_r>
    8000095a:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000095e:	00010997          	auipc	s3,0x10
    80000962:	2aa98993          	addi	s3,s3,682 # 80010c08 <uart_tx_lock>
    80000966:	00008497          	auipc	s1,0x8
    8000096a:	06248493          	addi	s1,s1,98 # 800089c8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000096e:	00008917          	auipc	s2,0x8
    80000972:	06290913          	addi	s2,s2,98 # 800089d0 <uart_tx_w>
    80000976:	00e79f63          	bne	a5,a4,80000994 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000097a:	85ce                	mv	a1,s3
    8000097c:	8526                	mv	a0,s1
    8000097e:	00002097          	auipc	ra,0x2
    80000982:	99c080e7          	jalr	-1636(ra) # 8000231a <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000986:	00093703          	ld	a4,0(s2)
    8000098a:	609c                	ld	a5,0(s1)
    8000098c:	02078793          	addi	a5,a5,32
    80000990:	fee785e3          	beq	a5,a4,8000097a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000994:	00010497          	auipc	s1,0x10
    80000998:	27448493          	addi	s1,s1,628 # 80010c08 <uart_tx_lock>
    8000099c:	01f77793          	andi	a5,a4,31
    800009a0:	97a6                	add	a5,a5,s1
    800009a2:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009a6:	0705                	addi	a4,a4,1
    800009a8:	00008797          	auipc	a5,0x8
    800009ac:	02e7b423          	sd	a4,40(a5) # 800089d0 <uart_tx_w>
  uartstart();
    800009b0:	00000097          	auipc	ra,0x0
    800009b4:	ede080e7          	jalr	-290(ra) # 8000088e <uartstart>
  release(&uart_tx_lock);
    800009b8:	8526                	mv	a0,s1
    800009ba:	00000097          	auipc	ra,0x0
    800009be:	334080e7          	jalr	820(ra) # 80000cee <release>
}
    800009c2:	70a2                	ld	ra,40(sp)
    800009c4:	7402                	ld	s0,32(sp)
    800009c6:	64e2                	ld	s1,24(sp)
    800009c8:	6942                	ld	s2,16(sp)
    800009ca:	69a2                	ld	s3,8(sp)
    800009cc:	6a02                	ld	s4,0(sp)
    800009ce:	6145                	addi	sp,sp,48
    800009d0:	8082                	ret
    for(;;)
    800009d2:	a001                	j	800009d2 <uartputc+0xb4>

00000000800009d4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009d4:	1141                	addi	sp,sp,-16
    800009d6:	e406                	sd	ra,8(sp)
    800009d8:	e022                	sd	s0,0(sp)
    800009da:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009dc:	100007b7          	lui	a5,0x10000
    800009e0:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009e4:	8b85                	andi	a5,a5,1
    800009e6:	cb89                	beqz	a5,800009f8 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800009e8:	100007b7          	lui	a5,0x10000
    800009ec:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009f0:	60a2                	ld	ra,8(sp)
    800009f2:	6402                	ld	s0,0(sp)
    800009f4:	0141                	addi	sp,sp,16
    800009f6:	8082                	ret
    return -1;
    800009f8:	557d                	li	a0,-1
    800009fa:	bfdd                	j	800009f0 <uartgetc+0x1c>

00000000800009fc <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009fc:	1101                	addi	sp,sp,-32
    800009fe:	ec06                	sd	ra,24(sp)
    80000a00:	e822                	sd	s0,16(sp)
    80000a02:	e426                	sd	s1,8(sp)
    80000a04:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a06:	54fd                	li	s1,-1
    int c = uartgetc();
    80000a08:	00000097          	auipc	ra,0x0
    80000a0c:	fcc080e7          	jalr	-52(ra) # 800009d4 <uartgetc>
    if(c == -1)
    80000a10:	00950763          	beq	a0,s1,80000a1e <uartintr+0x22>
      break;
    consoleintr(c);
    80000a14:	00000097          	auipc	ra,0x0
    80000a18:	8ce080e7          	jalr	-1842(ra) # 800002e2 <consoleintr>
  while(1){
    80000a1c:	b7f5                	j	80000a08 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a1e:	00010497          	auipc	s1,0x10
    80000a22:	1ea48493          	addi	s1,s1,490 # 80010c08 <uart_tx_lock>
    80000a26:	8526                	mv	a0,s1
    80000a28:	00000097          	auipc	ra,0x0
    80000a2c:	216080e7          	jalr	534(ra) # 80000c3e <acquire>
  uartstart();
    80000a30:	00000097          	auipc	ra,0x0
    80000a34:	e5e080e7          	jalr	-418(ra) # 8000088e <uartstart>
  release(&uart_tx_lock);
    80000a38:	8526                	mv	a0,s1
    80000a3a:	00000097          	auipc	ra,0x0
    80000a3e:	2b4080e7          	jalr	692(ra) # 80000cee <release>
}
    80000a42:	60e2                	ld	ra,24(sp)
    80000a44:	6442                	ld	s0,16(sp)
    80000a46:	64a2                	ld	s1,8(sp)
    80000a48:	6105                	addi	sp,sp,32
    80000a4a:	8082                	ret

0000000080000a4c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a4c:	1101                	addi	sp,sp,-32
    80000a4e:	ec06                	sd	ra,24(sp)
    80000a50:	e822                	sd	s0,16(sp)
    80000a52:	e426                	sd	s1,8(sp)
    80000a54:	e04a                	sd	s2,0(sp)
    80000a56:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a58:	03451793          	slli	a5,a0,0x34
    80000a5c:	ebb9                	bnez	a5,80000ab2 <kfree+0x66>
    80000a5e:	84aa                	mv	s1,a0
    80000a60:	00021797          	auipc	a5,0x21
    80000a64:	41078793          	addi	a5,a5,1040 # 80021e70 <end>
    80000a68:	04f56563          	bltu	a0,a5,80000ab2 <kfree+0x66>
    80000a6c:	47c5                	li	a5,17
    80000a6e:	07ee                	slli	a5,a5,0x1b
    80000a70:	04f57163          	bgeu	a0,a5,80000ab2 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a74:	6605                	lui	a2,0x1
    80000a76:	4585                	li	a1,1
    80000a78:	00000097          	auipc	ra,0x0
    80000a7c:	2be080e7          	jalr	702(ra) # 80000d36 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a80:	00010917          	auipc	s2,0x10
    80000a84:	1c090913          	addi	s2,s2,448 # 80010c40 <kmem>
    80000a88:	854a                	mv	a0,s2
    80000a8a:	00000097          	auipc	ra,0x0
    80000a8e:	1b4080e7          	jalr	436(ra) # 80000c3e <acquire>
  r->next = kmem.freelist;
    80000a92:	01893783          	ld	a5,24(s2)
    80000a96:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a98:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a9c:	854a                	mv	a0,s2
    80000a9e:	00000097          	auipc	ra,0x0
    80000aa2:	250080e7          	jalr	592(ra) # 80000cee <release>
}
    80000aa6:	60e2                	ld	ra,24(sp)
    80000aa8:	6442                	ld	s0,16(sp)
    80000aaa:	64a2                	ld	s1,8(sp)
    80000aac:	6902                	ld	s2,0(sp)
    80000aae:	6105                	addi	sp,sp,32
    80000ab0:	8082                	ret
    panic("kfree");
    80000ab2:	00007517          	auipc	a0,0x7
    80000ab6:	58e50513          	addi	a0,a0,1422 # 80008040 <etext+0x40>
    80000aba:	00000097          	auipc	ra,0x0
    80000abe:	aa6080e7          	jalr	-1370(ra) # 80000560 <panic>

0000000080000ac2 <freerange>:
{
    80000ac2:	7179                	addi	sp,sp,-48
    80000ac4:	f406                	sd	ra,40(sp)
    80000ac6:	f022                	sd	s0,32(sp)
    80000ac8:	ec26                	sd	s1,24(sp)
    80000aca:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000acc:	6785                	lui	a5,0x1
    80000ace:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ad2:	00e504b3          	add	s1,a0,a4
    80000ad6:	777d                	lui	a4,0xfffff
    80000ad8:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ada:	94be                	add	s1,s1,a5
    80000adc:	0295e463          	bltu	a1,s1,80000b04 <freerange+0x42>
    80000ae0:	e84a                	sd	s2,16(sp)
    80000ae2:	e44e                	sd	s3,8(sp)
    80000ae4:	e052                	sd	s4,0(sp)
    80000ae6:	892e                	mv	s2,a1
    kfree(p);
    80000ae8:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000aea:	89be                	mv	s3,a5
    kfree(p);
    80000aec:	01448533          	add	a0,s1,s4
    80000af0:	00000097          	auipc	ra,0x0
    80000af4:	f5c080e7          	jalr	-164(ra) # 80000a4c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000af8:	94ce                	add	s1,s1,s3
    80000afa:	fe9979e3          	bgeu	s2,s1,80000aec <freerange+0x2a>
    80000afe:	6942                	ld	s2,16(sp)
    80000b00:	69a2                	ld	s3,8(sp)
    80000b02:	6a02                	ld	s4,0(sp)
}
    80000b04:	70a2                	ld	ra,40(sp)
    80000b06:	7402                	ld	s0,32(sp)
    80000b08:	64e2                	ld	s1,24(sp)
    80000b0a:	6145                	addi	sp,sp,48
    80000b0c:	8082                	ret

0000000080000b0e <kinit>:
{
    80000b0e:	1141                	addi	sp,sp,-16
    80000b10:	e406                	sd	ra,8(sp)
    80000b12:	e022                	sd	s0,0(sp)
    80000b14:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000b16:	00007597          	auipc	a1,0x7
    80000b1a:	53258593          	addi	a1,a1,1330 # 80008048 <etext+0x48>
    80000b1e:	00010517          	auipc	a0,0x10
    80000b22:	12250513          	addi	a0,a0,290 # 80010c40 <kmem>
    80000b26:	00000097          	auipc	ra,0x0
    80000b2a:	084080e7          	jalr	132(ra) # 80000baa <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b2e:	45c5                	li	a1,17
    80000b30:	05ee                	slli	a1,a1,0x1b
    80000b32:	00021517          	auipc	a0,0x21
    80000b36:	33e50513          	addi	a0,a0,830 # 80021e70 <end>
    80000b3a:	00000097          	auipc	ra,0x0
    80000b3e:	f88080e7          	jalr	-120(ra) # 80000ac2 <freerange>
}
    80000b42:	60a2                	ld	ra,8(sp)
    80000b44:	6402                	ld	s0,0(sp)
    80000b46:	0141                	addi	sp,sp,16
    80000b48:	8082                	ret

0000000080000b4a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b4a:	1101                	addi	sp,sp,-32
    80000b4c:	ec06                	sd	ra,24(sp)
    80000b4e:	e822                	sd	s0,16(sp)
    80000b50:	e426                	sd	s1,8(sp)
    80000b52:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b54:	00010497          	auipc	s1,0x10
    80000b58:	0ec48493          	addi	s1,s1,236 # 80010c40 <kmem>
    80000b5c:	8526                	mv	a0,s1
    80000b5e:	00000097          	auipc	ra,0x0
    80000b62:	0e0080e7          	jalr	224(ra) # 80000c3e <acquire>
  r = kmem.freelist;
    80000b66:	6c84                	ld	s1,24(s1)
  if(r)
    80000b68:	c885                	beqz	s1,80000b98 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b6a:	609c                	ld	a5,0(s1)
    80000b6c:	00010517          	auipc	a0,0x10
    80000b70:	0d450513          	addi	a0,a0,212 # 80010c40 <kmem>
    80000b74:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b76:	00000097          	auipc	ra,0x0
    80000b7a:	178080e7          	jalr	376(ra) # 80000cee <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b7e:	6605                	lui	a2,0x1
    80000b80:	4595                	li	a1,5
    80000b82:	8526                	mv	a0,s1
    80000b84:	00000097          	auipc	ra,0x0
    80000b88:	1b2080e7          	jalr	434(ra) # 80000d36 <memset>
  return (void*)r;
}
    80000b8c:	8526                	mv	a0,s1
    80000b8e:	60e2                	ld	ra,24(sp)
    80000b90:	6442                	ld	s0,16(sp)
    80000b92:	64a2                	ld	s1,8(sp)
    80000b94:	6105                	addi	sp,sp,32
    80000b96:	8082                	ret
  release(&kmem.lock);
    80000b98:	00010517          	auipc	a0,0x10
    80000b9c:	0a850513          	addi	a0,a0,168 # 80010c40 <kmem>
    80000ba0:	00000097          	auipc	ra,0x0
    80000ba4:	14e080e7          	jalr	334(ra) # 80000cee <release>
  if(r)
    80000ba8:	b7d5                	j	80000b8c <kalloc+0x42>

0000000080000baa <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000baa:	1141                	addi	sp,sp,-16
    80000bac:	e406                	sd	ra,8(sp)
    80000bae:	e022                	sd	s0,0(sp)
    80000bb0:	0800                	addi	s0,sp,16
  lk->name = name;
    80000bb2:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000bb4:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000bb8:	00053823          	sd	zero,16(a0)
}
    80000bbc:	60a2                	ld	ra,8(sp)
    80000bbe:	6402                	ld	s0,0(sp)
    80000bc0:	0141                	addi	sp,sp,16
    80000bc2:	8082                	ret

0000000080000bc4 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000bc4:	411c                	lw	a5,0(a0)
    80000bc6:	e399                	bnez	a5,80000bcc <holding+0x8>
    80000bc8:	4501                	li	a0,0
  return r;
}
    80000bca:	8082                	ret
{
    80000bcc:	1101                	addi	sp,sp,-32
    80000bce:	ec06                	sd	ra,24(sp)
    80000bd0:	e822                	sd	s0,16(sp)
    80000bd2:	e426                	sd	s1,8(sp)
    80000bd4:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000bd6:	6904                	ld	s1,16(a0)
    80000bd8:	00001097          	auipc	ra,0x1
    80000bdc:	f48080e7          	jalr	-184(ra) # 80001b20 <mycpu>
    80000be0:	40a48533          	sub	a0,s1,a0
    80000be4:	00153513          	seqz	a0,a0
}
    80000be8:	60e2                	ld	ra,24(sp)
    80000bea:	6442                	ld	s0,16(sp)
    80000bec:	64a2                	ld	s1,8(sp)
    80000bee:	6105                	addi	sp,sp,32
    80000bf0:	8082                	ret

0000000080000bf2 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bf2:	1101                	addi	sp,sp,-32
    80000bf4:	ec06                	sd	ra,24(sp)
    80000bf6:	e822                	sd	s0,16(sp)
    80000bf8:	e426                	sd	s1,8(sp)
    80000bfa:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bfc:	100024f3          	csrr	s1,sstatus
    80000c00:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000c04:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c06:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000c0a:	00001097          	auipc	ra,0x1
    80000c0e:	f16080e7          	jalr	-234(ra) # 80001b20 <mycpu>
    80000c12:	5d3c                	lw	a5,120(a0)
    80000c14:	cf89                	beqz	a5,80000c2e <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c16:	00001097          	auipc	ra,0x1
    80000c1a:	f0a080e7          	jalr	-246(ra) # 80001b20 <mycpu>
    80000c1e:	5d3c                	lw	a5,120(a0)
    80000c20:	2785                	addiw	a5,a5,1
    80000c22:	dd3c                	sw	a5,120(a0)
}
    80000c24:	60e2                	ld	ra,24(sp)
    80000c26:	6442                	ld	s0,16(sp)
    80000c28:	64a2                	ld	s1,8(sp)
    80000c2a:	6105                	addi	sp,sp,32
    80000c2c:	8082                	ret
    mycpu()->intena = old;
    80000c2e:	00001097          	auipc	ra,0x1
    80000c32:	ef2080e7          	jalr	-270(ra) # 80001b20 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000c36:	8085                	srli	s1,s1,0x1
    80000c38:	8885                	andi	s1,s1,1
    80000c3a:	dd64                	sw	s1,124(a0)
    80000c3c:	bfe9                	j	80000c16 <push_off+0x24>

0000000080000c3e <acquire>:
{
    80000c3e:	1101                	addi	sp,sp,-32
    80000c40:	ec06                	sd	ra,24(sp)
    80000c42:	e822                	sd	s0,16(sp)
    80000c44:	e426                	sd	s1,8(sp)
    80000c46:	1000                	addi	s0,sp,32
    80000c48:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c4a:	00000097          	auipc	ra,0x0
    80000c4e:	fa8080e7          	jalr	-88(ra) # 80000bf2 <push_off>
  if(holding(lk))
    80000c52:	8526                	mv	a0,s1
    80000c54:	00000097          	auipc	ra,0x0
    80000c58:	f70080e7          	jalr	-144(ra) # 80000bc4 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c5c:	4705                	li	a4,1
  if(holding(lk))
    80000c5e:	e115                	bnez	a0,80000c82 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c60:	87ba                	mv	a5,a4
    80000c62:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c66:	2781                	sext.w	a5,a5
    80000c68:	ffe5                	bnez	a5,80000c60 <acquire+0x22>
  __sync_synchronize();
    80000c6a:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000c6e:	00001097          	auipc	ra,0x1
    80000c72:	eb2080e7          	jalr	-334(ra) # 80001b20 <mycpu>
    80000c76:	e888                	sd	a0,16(s1)
}
    80000c78:	60e2                	ld	ra,24(sp)
    80000c7a:	6442                	ld	s0,16(sp)
    80000c7c:	64a2                	ld	s1,8(sp)
    80000c7e:	6105                	addi	sp,sp,32
    80000c80:	8082                	ret
    panic("acquire");
    80000c82:	00007517          	auipc	a0,0x7
    80000c86:	3ce50513          	addi	a0,a0,974 # 80008050 <etext+0x50>
    80000c8a:	00000097          	auipc	ra,0x0
    80000c8e:	8d6080e7          	jalr	-1834(ra) # 80000560 <panic>

0000000080000c92 <pop_off>:

void
pop_off(void)
{
    80000c92:	1141                	addi	sp,sp,-16
    80000c94:	e406                	sd	ra,8(sp)
    80000c96:	e022                	sd	s0,0(sp)
    80000c98:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c9a:	00001097          	auipc	ra,0x1
    80000c9e:	e86080e7          	jalr	-378(ra) # 80001b20 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000ca2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000ca6:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000ca8:	e39d                	bnez	a5,80000cce <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000caa:	5d3c                	lw	a5,120(a0)
    80000cac:	02f05963          	blez	a5,80000cde <pop_off+0x4c>
    panic("pop_off");
  c->noff -= 1;
    80000cb0:	37fd                	addiw	a5,a5,-1
    80000cb2:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000cb4:	eb89                	bnez	a5,80000cc6 <pop_off+0x34>
    80000cb6:	5d7c                	lw	a5,124(a0)
    80000cb8:	c799                	beqz	a5,80000cc6 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000cba:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000cbe:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000cc2:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000cc6:	60a2                	ld	ra,8(sp)
    80000cc8:	6402                	ld	s0,0(sp)
    80000cca:	0141                	addi	sp,sp,16
    80000ccc:	8082                	ret
    panic("pop_off - interruptible");
    80000cce:	00007517          	auipc	a0,0x7
    80000cd2:	38a50513          	addi	a0,a0,906 # 80008058 <etext+0x58>
    80000cd6:	00000097          	auipc	ra,0x0
    80000cda:	88a080e7          	jalr	-1910(ra) # 80000560 <panic>
    panic("pop_off");
    80000cde:	00007517          	auipc	a0,0x7
    80000ce2:	39250513          	addi	a0,a0,914 # 80008070 <etext+0x70>
    80000ce6:	00000097          	auipc	ra,0x0
    80000cea:	87a080e7          	jalr	-1926(ra) # 80000560 <panic>

0000000080000cee <release>:
{
    80000cee:	1101                	addi	sp,sp,-32
    80000cf0:	ec06                	sd	ra,24(sp)
    80000cf2:	e822                	sd	s0,16(sp)
    80000cf4:	e426                	sd	s1,8(sp)
    80000cf6:	1000                	addi	s0,sp,32
    80000cf8:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000cfa:	00000097          	auipc	ra,0x0
    80000cfe:	eca080e7          	jalr	-310(ra) # 80000bc4 <holding>
    80000d02:	c115                	beqz	a0,80000d26 <release+0x38>
  lk->cpu = 0;
    80000d04:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000d08:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000d0c:	0310000f          	fence	rw,w
    80000d10:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000d14:	00000097          	auipc	ra,0x0
    80000d18:	f7e080e7          	jalr	-130(ra) # 80000c92 <pop_off>
}
    80000d1c:	60e2                	ld	ra,24(sp)
    80000d1e:	6442                	ld	s0,16(sp)
    80000d20:	64a2                	ld	s1,8(sp)
    80000d22:	6105                	addi	sp,sp,32
    80000d24:	8082                	ret
    panic("release");
    80000d26:	00007517          	auipc	a0,0x7
    80000d2a:	35250513          	addi	a0,a0,850 # 80008078 <etext+0x78>
    80000d2e:	00000097          	auipc	ra,0x0
    80000d32:	832080e7          	jalr	-1998(ra) # 80000560 <panic>

0000000080000d36 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000d36:	1141                	addi	sp,sp,-16
    80000d38:	e406                	sd	ra,8(sp)
    80000d3a:	e022                	sd	s0,0(sp)
    80000d3c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000d3e:	ca19                	beqz	a2,80000d54 <memset+0x1e>
    80000d40:	87aa                	mv	a5,a0
    80000d42:	1602                	slli	a2,a2,0x20
    80000d44:	9201                	srli	a2,a2,0x20
    80000d46:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000d4a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000d4e:	0785                	addi	a5,a5,1
    80000d50:	fee79de3          	bne	a5,a4,80000d4a <memset+0x14>
  }
  return dst;
}
    80000d54:	60a2                	ld	ra,8(sp)
    80000d56:	6402                	ld	s0,0(sp)
    80000d58:	0141                	addi	sp,sp,16
    80000d5a:	8082                	ret

0000000080000d5c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d5c:	1141                	addi	sp,sp,-16
    80000d5e:	e406                	sd	ra,8(sp)
    80000d60:	e022                	sd	s0,0(sp)
    80000d62:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d64:	ca0d                	beqz	a2,80000d96 <memcmp+0x3a>
    80000d66:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000d6a:	1682                	slli	a3,a3,0x20
    80000d6c:	9281                	srli	a3,a3,0x20
    80000d6e:	0685                	addi	a3,a3,1
    80000d70:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d72:	00054783          	lbu	a5,0(a0)
    80000d76:	0005c703          	lbu	a4,0(a1)
    80000d7a:	00e79863          	bne	a5,a4,80000d8a <memcmp+0x2e>
      return *s1 - *s2;
    s1++, s2++;
    80000d7e:	0505                	addi	a0,a0,1
    80000d80:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d82:	fed518e3          	bne	a0,a3,80000d72 <memcmp+0x16>
  }

  return 0;
    80000d86:	4501                	li	a0,0
    80000d88:	a019                	j	80000d8e <memcmp+0x32>
      return *s1 - *s2;
    80000d8a:	40e7853b          	subw	a0,a5,a4
}
    80000d8e:	60a2                	ld	ra,8(sp)
    80000d90:	6402                	ld	s0,0(sp)
    80000d92:	0141                	addi	sp,sp,16
    80000d94:	8082                	ret
  return 0;
    80000d96:	4501                	li	a0,0
    80000d98:	bfdd                	j	80000d8e <memcmp+0x32>

0000000080000d9a <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d9a:	1141                	addi	sp,sp,-16
    80000d9c:	e406                	sd	ra,8(sp)
    80000d9e:	e022                	sd	s0,0(sp)
    80000da0:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000da2:	c205                	beqz	a2,80000dc2 <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000da4:	02a5e363          	bltu	a1,a0,80000dca <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000da8:	1602                	slli	a2,a2,0x20
    80000daa:	9201                	srli	a2,a2,0x20
    80000dac:	00c587b3          	add	a5,a1,a2
{
    80000db0:	872a                	mv	a4,a0
      *d++ = *s++;
    80000db2:	0585                	addi	a1,a1,1
    80000db4:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdd191>
    80000db6:	fff5c683          	lbu	a3,-1(a1)
    80000dba:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000dbe:	feb79ae3          	bne	a5,a1,80000db2 <memmove+0x18>

  return dst;
}
    80000dc2:	60a2                	ld	ra,8(sp)
    80000dc4:	6402                	ld	s0,0(sp)
    80000dc6:	0141                	addi	sp,sp,16
    80000dc8:	8082                	ret
  if(s < d && s + n > d){
    80000dca:	02061693          	slli	a3,a2,0x20
    80000dce:	9281                	srli	a3,a3,0x20
    80000dd0:	00d58733          	add	a4,a1,a3
    80000dd4:	fce57ae3          	bgeu	a0,a4,80000da8 <memmove+0xe>
    d += n;
    80000dd8:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000dda:	fff6079b          	addiw	a5,a2,-1
    80000dde:	1782                	slli	a5,a5,0x20
    80000de0:	9381                	srli	a5,a5,0x20
    80000de2:	fff7c793          	not	a5,a5
    80000de6:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000de8:	177d                	addi	a4,a4,-1
    80000dea:	16fd                	addi	a3,a3,-1
    80000dec:	00074603          	lbu	a2,0(a4)
    80000df0:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000df4:	fee79ae3          	bne	a5,a4,80000de8 <memmove+0x4e>
    80000df8:	b7e9                	j	80000dc2 <memmove+0x28>

0000000080000dfa <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000dfa:	1141                	addi	sp,sp,-16
    80000dfc:	e406                	sd	ra,8(sp)
    80000dfe:	e022                	sd	s0,0(sp)
    80000e00:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000e02:	00000097          	auipc	ra,0x0
    80000e06:	f98080e7          	jalr	-104(ra) # 80000d9a <memmove>
}
    80000e0a:	60a2                	ld	ra,8(sp)
    80000e0c:	6402                	ld	s0,0(sp)
    80000e0e:	0141                	addi	sp,sp,16
    80000e10:	8082                	ret

0000000080000e12 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000e12:	1141                	addi	sp,sp,-16
    80000e14:	e406                	sd	ra,8(sp)
    80000e16:	e022                	sd	s0,0(sp)
    80000e18:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000e1a:	ce11                	beqz	a2,80000e36 <strncmp+0x24>
    80000e1c:	00054783          	lbu	a5,0(a0)
    80000e20:	cf89                	beqz	a5,80000e3a <strncmp+0x28>
    80000e22:	0005c703          	lbu	a4,0(a1)
    80000e26:	00f71a63          	bne	a4,a5,80000e3a <strncmp+0x28>
    n--, p++, q++;
    80000e2a:	367d                	addiw	a2,a2,-1
    80000e2c:	0505                	addi	a0,a0,1
    80000e2e:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000e30:	f675                	bnez	a2,80000e1c <strncmp+0xa>
  if(n == 0)
    return 0;
    80000e32:	4501                	li	a0,0
    80000e34:	a801                	j	80000e44 <strncmp+0x32>
    80000e36:	4501                	li	a0,0
    80000e38:	a031                	j	80000e44 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    80000e3a:	00054503          	lbu	a0,0(a0)
    80000e3e:	0005c783          	lbu	a5,0(a1)
    80000e42:	9d1d                	subw	a0,a0,a5
}
    80000e44:	60a2                	ld	ra,8(sp)
    80000e46:	6402                	ld	s0,0(sp)
    80000e48:	0141                	addi	sp,sp,16
    80000e4a:	8082                	ret

0000000080000e4c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e4c:	1141                	addi	sp,sp,-16
    80000e4e:	e406                	sd	ra,8(sp)
    80000e50:	e022                	sd	s0,0(sp)
    80000e52:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e54:	87aa                	mv	a5,a0
    80000e56:	86b2                	mv	a3,a2
    80000e58:	367d                	addiw	a2,a2,-1
    80000e5a:	02d05563          	blez	a3,80000e84 <strncpy+0x38>
    80000e5e:	0785                	addi	a5,a5,1
    80000e60:	0005c703          	lbu	a4,0(a1)
    80000e64:	fee78fa3          	sb	a4,-1(a5)
    80000e68:	0585                	addi	a1,a1,1
    80000e6a:	f775                	bnez	a4,80000e56 <strncpy+0xa>
    ;
  while(n-- > 0)
    80000e6c:	873e                	mv	a4,a5
    80000e6e:	00c05b63          	blez	a2,80000e84 <strncpy+0x38>
    80000e72:	9fb5                	addw	a5,a5,a3
    80000e74:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000e76:	0705                	addi	a4,a4,1
    80000e78:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000e7c:	40e786bb          	subw	a3,a5,a4
    80000e80:	fed04be3          	bgtz	a3,80000e76 <strncpy+0x2a>
  return os;
}
    80000e84:	60a2                	ld	ra,8(sp)
    80000e86:	6402                	ld	s0,0(sp)
    80000e88:	0141                	addi	sp,sp,16
    80000e8a:	8082                	ret

0000000080000e8c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e8c:	1141                	addi	sp,sp,-16
    80000e8e:	e406                	sd	ra,8(sp)
    80000e90:	e022                	sd	s0,0(sp)
    80000e92:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e94:	02c05363          	blez	a2,80000eba <safestrcpy+0x2e>
    80000e98:	fff6069b          	addiw	a3,a2,-1
    80000e9c:	1682                	slli	a3,a3,0x20
    80000e9e:	9281                	srli	a3,a3,0x20
    80000ea0:	96ae                	add	a3,a3,a1
    80000ea2:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000ea4:	00d58963          	beq	a1,a3,80000eb6 <safestrcpy+0x2a>
    80000ea8:	0585                	addi	a1,a1,1
    80000eaa:	0785                	addi	a5,a5,1
    80000eac:	fff5c703          	lbu	a4,-1(a1)
    80000eb0:	fee78fa3          	sb	a4,-1(a5)
    80000eb4:	fb65                	bnez	a4,80000ea4 <safestrcpy+0x18>
    ;
  *s = 0;
    80000eb6:	00078023          	sb	zero,0(a5)
  return os;
}
    80000eba:	60a2                	ld	ra,8(sp)
    80000ebc:	6402                	ld	s0,0(sp)
    80000ebe:	0141                	addi	sp,sp,16
    80000ec0:	8082                	ret

0000000080000ec2 <strlen>:

int
strlen(const char *s)
{
    80000ec2:	1141                	addi	sp,sp,-16
    80000ec4:	e406                	sd	ra,8(sp)
    80000ec6:	e022                	sd	s0,0(sp)
    80000ec8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000eca:	00054783          	lbu	a5,0(a0)
    80000ece:	cf99                	beqz	a5,80000eec <strlen+0x2a>
    80000ed0:	0505                	addi	a0,a0,1
    80000ed2:	87aa                	mv	a5,a0
    80000ed4:	86be                	mv	a3,a5
    80000ed6:	0785                	addi	a5,a5,1
    80000ed8:	fff7c703          	lbu	a4,-1(a5)
    80000edc:	ff65                	bnez	a4,80000ed4 <strlen+0x12>
    80000ede:	40a6853b          	subw	a0,a3,a0
    80000ee2:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000ee4:	60a2                	ld	ra,8(sp)
    80000ee6:	6402                	ld	s0,0(sp)
    80000ee8:	0141                	addi	sp,sp,16
    80000eea:	8082                	ret
  for(n = 0; s[n]; n++)
    80000eec:	4501                	li	a0,0
    80000eee:	bfdd                	j	80000ee4 <strlen+0x22>

0000000080000ef0 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000ef0:	1141                	addi	sp,sp,-16
    80000ef2:	e406                	sd	ra,8(sp)
    80000ef4:	e022                	sd	s0,0(sp)
    80000ef6:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000ef8:	00001097          	auipc	ra,0x1
    80000efc:	c14080e7          	jalr	-1004(ra) # 80001b0c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000f00:	00008717          	auipc	a4,0x8
    80000f04:	ad870713          	addi	a4,a4,-1320 # 800089d8 <started>
  if(cpuid() == 0){
    80000f08:	c139                	beqz	a0,80000f4e <main+0x5e>
    while(started == 0)
    80000f0a:	431c                	lw	a5,0(a4)
    80000f0c:	2781                	sext.w	a5,a5
    80000f0e:	dff5                	beqz	a5,80000f0a <main+0x1a>
      ;
    __sync_synchronize();
    80000f10:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000f14:	00001097          	auipc	ra,0x1
    80000f18:	bf8080e7          	jalr	-1032(ra) # 80001b0c <cpuid>
    80000f1c:	85aa                	mv	a1,a0
    80000f1e:	00007517          	auipc	a0,0x7
    80000f22:	17a50513          	addi	a0,a0,378 # 80008098 <etext+0x98>
    80000f26:	fffff097          	auipc	ra,0xfffff
    80000f2a:	684080e7          	jalr	1668(ra) # 800005aa <printf>
    kvminithart();    // turn on paging
    80000f2e:	00000097          	auipc	ra,0x0
    80000f32:	0d8080e7          	jalr	216(ra) # 80001006 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000f36:	00002097          	auipc	ra,0x2
    80000f3a:	ab6080e7          	jalr	-1354(ra) # 800029ec <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f3e:	00005097          	auipc	ra,0x5
    80000f42:	216080e7          	jalr	534(ra) # 80006154 <plicinithart>
  }

  scheduler();        
    80000f46:	00001097          	auipc	ra,0x1
    80000f4a:	28c080e7          	jalr	652(ra) # 800021d2 <scheduler>
    consoleinit();
    80000f4e:	fffff097          	auipc	ra,0xfffff
    80000f52:	534080e7          	jalr	1332(ra) # 80000482 <consoleinit>
    printfinit();
    80000f56:	00000097          	auipc	ra,0x0
    80000f5a:	85e080e7          	jalr	-1954(ra) # 800007b4 <printfinit>
    printf("\n");
    80000f5e:	00007517          	auipc	a0,0x7
    80000f62:	0b250513          	addi	a0,a0,178 # 80008010 <etext+0x10>
    80000f66:	fffff097          	auipc	ra,0xfffff
    80000f6a:	644080e7          	jalr	1604(ra) # 800005aa <printf>
    printf("xv6 kernel is booting\n");
    80000f6e:	00007517          	auipc	a0,0x7
    80000f72:	11250513          	addi	a0,a0,274 # 80008080 <etext+0x80>
    80000f76:	fffff097          	auipc	ra,0xfffff
    80000f7a:	634080e7          	jalr	1588(ra) # 800005aa <printf>
    printf("\n");
    80000f7e:	00007517          	auipc	a0,0x7
    80000f82:	09250513          	addi	a0,a0,146 # 80008010 <etext+0x10>
    80000f86:	fffff097          	auipc	ra,0xfffff
    80000f8a:	624080e7          	jalr	1572(ra) # 800005aa <printf>
    kinit();         // physical page allocator
    80000f8e:	00000097          	auipc	ra,0x0
    80000f92:	b80080e7          	jalr	-1152(ra) # 80000b0e <kinit>
    kvminit();       // create kernel page table
    80000f96:	00000097          	auipc	ra,0x0
    80000f9a:	32a080e7          	jalr	810(ra) # 800012c0 <kvminit>
    kvminithart();   // turn on paging
    80000f9e:	00000097          	auipc	ra,0x0
    80000fa2:	068080e7          	jalr	104(ra) # 80001006 <kvminithart>
    procinit();      // process table
    80000fa6:	00001097          	auipc	ra,0x1
    80000faa:	a82080e7          	jalr	-1406(ra) # 80001a28 <procinit>
    trapinit();      // trap vectors
    80000fae:	00002097          	auipc	ra,0x2
    80000fb2:	a16080e7          	jalr	-1514(ra) # 800029c4 <trapinit>
    trapinithart();  // install kernel trap vector
    80000fb6:	00002097          	auipc	ra,0x2
    80000fba:	a36080e7          	jalr	-1482(ra) # 800029ec <trapinithart>
    plicinit();      // set up interrupt controller
    80000fbe:	00005097          	auipc	ra,0x5
    80000fc2:	17c080e7          	jalr	380(ra) # 8000613a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000fc6:	00005097          	auipc	ra,0x5
    80000fca:	18e080e7          	jalr	398(ra) # 80006154 <plicinithart>
    binit();         // buffer cache
    80000fce:	00002097          	auipc	ra,0x2
    80000fd2:	212080e7          	jalr	530(ra) # 800031e0 <binit>
    iinit();         // inode table
    80000fd6:	00003097          	auipc	ra,0x3
    80000fda:	8a2080e7          	jalr	-1886(ra) # 80003878 <iinit>
    fileinit();      // file table
    80000fde:	00004097          	auipc	ra,0x4
    80000fe2:	874080e7          	jalr	-1932(ra) # 80004852 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000fe6:	00005097          	auipc	ra,0x5
    80000fea:	276080e7          	jalr	630(ra) # 8000625c <virtio_disk_init>
    userinit();      // first user process
    80000fee:	00001097          	auipc	ra,0x1
    80000ff2:	e2a080e7          	jalr	-470(ra) # 80001e18 <userinit>
    __sync_synchronize();
    80000ff6:	0330000f          	fence	rw,rw
    started = 1;
    80000ffa:	4785                	li	a5,1
    80000ffc:	00008717          	auipc	a4,0x8
    80001000:	9cf72e23          	sw	a5,-1572(a4) # 800089d8 <started>
    80001004:	b789                	j	80000f46 <main+0x56>

0000000080001006 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80001006:	1141                	addi	sp,sp,-16
    80001008:	e406                	sd	ra,8(sp)
    8000100a:	e022                	sd	s0,0(sp)
    8000100c:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000100e:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80001012:	00008797          	auipc	a5,0x8
    80001016:	9ce7b783          	ld	a5,-1586(a5) # 800089e0 <kernel_pagetable>
    8000101a:	83b1                	srli	a5,a5,0xc
    8000101c:	577d                	li	a4,-1
    8000101e:	177e                	slli	a4,a4,0x3f
    80001020:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80001022:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80001026:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    8000102a:	60a2                	ld	ra,8(sp)
    8000102c:	6402                	ld	s0,0(sp)
    8000102e:	0141                	addi	sp,sp,16
    80001030:	8082                	ret

0000000080001032 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80001032:	7139                	addi	sp,sp,-64
    80001034:	fc06                	sd	ra,56(sp)
    80001036:	f822                	sd	s0,48(sp)
    80001038:	f426                	sd	s1,40(sp)
    8000103a:	f04a                	sd	s2,32(sp)
    8000103c:	ec4e                	sd	s3,24(sp)
    8000103e:	e852                	sd	s4,16(sp)
    80001040:	e456                	sd	s5,8(sp)
    80001042:	e05a                	sd	s6,0(sp)
    80001044:	0080                	addi	s0,sp,64
    80001046:	84aa                	mv	s1,a0
    80001048:	89ae                	mv	s3,a1
    8000104a:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000104c:	57fd                	li	a5,-1
    8000104e:	83e9                	srli	a5,a5,0x1a
    80001050:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80001052:	4b31                	li	s6,12
  if(va >= MAXVA)
    80001054:	04b7e263          	bltu	a5,a1,80001098 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    80001058:	0149d933          	srl	s2,s3,s4
    8000105c:	1ff97913          	andi	s2,s2,511
    80001060:	090e                	slli	s2,s2,0x3
    80001062:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001064:	00093483          	ld	s1,0(s2)
    80001068:	0014f793          	andi	a5,s1,1
    8000106c:	cf95                	beqz	a5,800010a8 <walk+0x76>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000106e:	80a9                	srli	s1,s1,0xa
    80001070:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    80001072:	3a5d                	addiw	s4,s4,-9
    80001074:	ff6a12e3          	bne	s4,s6,80001058 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80001078:	00c9d513          	srli	a0,s3,0xc
    8000107c:	1ff57513          	andi	a0,a0,511
    80001080:	050e                	slli	a0,a0,0x3
    80001082:	9526                	add	a0,a0,s1
}
    80001084:	70e2                	ld	ra,56(sp)
    80001086:	7442                	ld	s0,48(sp)
    80001088:	74a2                	ld	s1,40(sp)
    8000108a:	7902                	ld	s2,32(sp)
    8000108c:	69e2                	ld	s3,24(sp)
    8000108e:	6a42                	ld	s4,16(sp)
    80001090:	6aa2                	ld	s5,8(sp)
    80001092:	6b02                	ld	s6,0(sp)
    80001094:	6121                	addi	sp,sp,64
    80001096:	8082                	ret
    panic("walk");
    80001098:	00007517          	auipc	a0,0x7
    8000109c:	01850513          	addi	a0,a0,24 # 800080b0 <etext+0xb0>
    800010a0:	fffff097          	auipc	ra,0xfffff
    800010a4:	4c0080e7          	jalr	1216(ra) # 80000560 <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800010a8:	020a8663          	beqz	s5,800010d4 <walk+0xa2>
    800010ac:	00000097          	auipc	ra,0x0
    800010b0:	a9e080e7          	jalr	-1378(ra) # 80000b4a <kalloc>
    800010b4:	84aa                	mv	s1,a0
    800010b6:	d579                	beqz	a0,80001084 <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    800010b8:	6605                	lui	a2,0x1
    800010ba:	4581                	li	a1,0
    800010bc:	00000097          	auipc	ra,0x0
    800010c0:	c7a080e7          	jalr	-902(ra) # 80000d36 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800010c4:	00c4d793          	srli	a5,s1,0xc
    800010c8:	07aa                	slli	a5,a5,0xa
    800010ca:	0017e793          	ori	a5,a5,1
    800010ce:	00f93023          	sd	a5,0(s2)
    800010d2:	b745                	j	80001072 <walk+0x40>
        return 0;
    800010d4:	4501                	li	a0,0
    800010d6:	b77d                	j	80001084 <walk+0x52>

00000000800010d8 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800010d8:	57fd                	li	a5,-1
    800010da:	83e9                	srli	a5,a5,0x1a
    800010dc:	00b7f463          	bgeu	a5,a1,800010e4 <walkaddr+0xc>
    return 0;
    800010e0:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800010e2:	8082                	ret
{
    800010e4:	1141                	addi	sp,sp,-16
    800010e6:	e406                	sd	ra,8(sp)
    800010e8:	e022                	sd	s0,0(sp)
    800010ea:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800010ec:	4601                	li	a2,0
    800010ee:	00000097          	auipc	ra,0x0
    800010f2:	f44080e7          	jalr	-188(ra) # 80001032 <walk>
  if(pte == 0)
    800010f6:	c105                	beqz	a0,80001116 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800010f8:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800010fa:	0117f693          	andi	a3,a5,17
    800010fe:	4745                	li	a4,17
    return 0;
    80001100:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001102:	00e68663          	beq	a3,a4,8000110e <walkaddr+0x36>
}
    80001106:	60a2                	ld	ra,8(sp)
    80001108:	6402                	ld	s0,0(sp)
    8000110a:	0141                	addi	sp,sp,16
    8000110c:	8082                	ret
  pa = PTE2PA(*pte);
    8000110e:	83a9                	srli	a5,a5,0xa
    80001110:	00c79513          	slli	a0,a5,0xc
  return pa;
    80001114:	bfcd                	j	80001106 <walkaddr+0x2e>
    return 0;
    80001116:	4501                	li	a0,0
    80001118:	b7fd                	j	80001106 <walkaddr+0x2e>

000000008000111a <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000111a:	715d                	addi	sp,sp,-80
    8000111c:	e486                	sd	ra,72(sp)
    8000111e:	e0a2                	sd	s0,64(sp)
    80001120:	fc26                	sd	s1,56(sp)
    80001122:	f84a                	sd	s2,48(sp)
    80001124:	f44e                	sd	s3,40(sp)
    80001126:	f052                	sd	s4,32(sp)
    80001128:	ec56                	sd	s5,24(sp)
    8000112a:	e85a                	sd	s6,16(sp)
    8000112c:	e45e                	sd	s7,8(sp)
    8000112e:	e062                	sd	s8,0(sp)
    80001130:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80001132:	ca21                	beqz	a2,80001182 <mappages+0x68>
    80001134:	8aaa                	mv	s5,a0
    80001136:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80001138:	777d                	lui	a4,0xfffff
    8000113a:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000113e:	fff58993          	addi	s3,a1,-1
    80001142:	99b2                	add	s3,s3,a2
    80001144:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80001148:	893e                	mv	s2,a5
    8000114a:	40f68a33          	sub	s4,a3,a5
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    8000114e:	4b85                	li	s7,1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001150:	6c05                	lui	s8,0x1
    80001152:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80001156:	865e                	mv	a2,s7
    80001158:	85ca                	mv	a1,s2
    8000115a:	8556                	mv	a0,s5
    8000115c:	00000097          	auipc	ra,0x0
    80001160:	ed6080e7          	jalr	-298(ra) # 80001032 <walk>
    80001164:	cd1d                	beqz	a0,800011a2 <mappages+0x88>
    if(*pte & PTE_V)
    80001166:	611c                	ld	a5,0(a0)
    80001168:	8b85                	andi	a5,a5,1
    8000116a:	e785                	bnez	a5,80001192 <mappages+0x78>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000116c:	80b1                	srli	s1,s1,0xc
    8000116e:	04aa                	slli	s1,s1,0xa
    80001170:	0164e4b3          	or	s1,s1,s6
    80001174:	0014e493          	ori	s1,s1,1
    80001178:	e104                	sd	s1,0(a0)
    if(a == last)
    8000117a:	05390163          	beq	s2,s3,800011bc <mappages+0xa2>
    a += PGSIZE;
    8000117e:	9962                	add	s2,s2,s8
    if((pte = walk(pagetable, a, 1)) == 0)
    80001180:	bfc9                	j	80001152 <mappages+0x38>
    panic("mappages: size");
    80001182:	00007517          	auipc	a0,0x7
    80001186:	f3650513          	addi	a0,a0,-202 # 800080b8 <etext+0xb8>
    8000118a:	fffff097          	auipc	ra,0xfffff
    8000118e:	3d6080e7          	jalr	982(ra) # 80000560 <panic>
      panic("mappages: remap");
    80001192:	00007517          	auipc	a0,0x7
    80001196:	f3650513          	addi	a0,a0,-202 # 800080c8 <etext+0xc8>
    8000119a:	fffff097          	auipc	ra,0xfffff
    8000119e:	3c6080e7          	jalr	966(ra) # 80000560 <panic>
      return -1;
    800011a2:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800011a4:	60a6                	ld	ra,72(sp)
    800011a6:	6406                	ld	s0,64(sp)
    800011a8:	74e2                	ld	s1,56(sp)
    800011aa:	7942                	ld	s2,48(sp)
    800011ac:	79a2                	ld	s3,40(sp)
    800011ae:	7a02                	ld	s4,32(sp)
    800011b0:	6ae2                	ld	s5,24(sp)
    800011b2:	6b42                	ld	s6,16(sp)
    800011b4:	6ba2                	ld	s7,8(sp)
    800011b6:	6c02                	ld	s8,0(sp)
    800011b8:	6161                	addi	sp,sp,80
    800011ba:	8082                	ret
  return 0;
    800011bc:	4501                	li	a0,0
    800011be:	b7dd                	j	800011a4 <mappages+0x8a>

00000000800011c0 <kvmmap>:
{
    800011c0:	1141                	addi	sp,sp,-16
    800011c2:	e406                	sd	ra,8(sp)
    800011c4:	e022                	sd	s0,0(sp)
    800011c6:	0800                	addi	s0,sp,16
    800011c8:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800011ca:	86b2                	mv	a3,a2
    800011cc:	863e                	mv	a2,a5
    800011ce:	00000097          	auipc	ra,0x0
    800011d2:	f4c080e7          	jalr	-180(ra) # 8000111a <mappages>
    800011d6:	e509                	bnez	a0,800011e0 <kvmmap+0x20>
}
    800011d8:	60a2                	ld	ra,8(sp)
    800011da:	6402                	ld	s0,0(sp)
    800011dc:	0141                	addi	sp,sp,16
    800011de:	8082                	ret
    panic("kvmmap");
    800011e0:	00007517          	auipc	a0,0x7
    800011e4:	ef850513          	addi	a0,a0,-264 # 800080d8 <etext+0xd8>
    800011e8:	fffff097          	auipc	ra,0xfffff
    800011ec:	378080e7          	jalr	888(ra) # 80000560 <panic>

00000000800011f0 <kvmmake>:
{
    800011f0:	1101                	addi	sp,sp,-32
    800011f2:	ec06                	sd	ra,24(sp)
    800011f4:	e822                	sd	s0,16(sp)
    800011f6:	e426                	sd	s1,8(sp)
    800011f8:	e04a                	sd	s2,0(sp)
    800011fa:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800011fc:	00000097          	auipc	ra,0x0
    80001200:	94e080e7          	jalr	-1714(ra) # 80000b4a <kalloc>
    80001204:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001206:	6605                	lui	a2,0x1
    80001208:	4581                	li	a1,0
    8000120a:	00000097          	auipc	ra,0x0
    8000120e:	b2c080e7          	jalr	-1236(ra) # 80000d36 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001212:	4719                	li	a4,6
    80001214:	6685                	lui	a3,0x1
    80001216:	10000637          	lui	a2,0x10000
    8000121a:	85b2                	mv	a1,a2
    8000121c:	8526                	mv	a0,s1
    8000121e:	00000097          	auipc	ra,0x0
    80001222:	fa2080e7          	jalr	-94(ra) # 800011c0 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001226:	4719                	li	a4,6
    80001228:	6685                	lui	a3,0x1
    8000122a:	10001637          	lui	a2,0x10001
    8000122e:	85b2                	mv	a1,a2
    80001230:	8526                	mv	a0,s1
    80001232:	00000097          	auipc	ra,0x0
    80001236:	f8e080e7          	jalr	-114(ra) # 800011c0 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000123a:	4719                	li	a4,6
    8000123c:	004006b7          	lui	a3,0x400
    80001240:	0c000637          	lui	a2,0xc000
    80001244:	85b2                	mv	a1,a2
    80001246:	8526                	mv	a0,s1
    80001248:	00000097          	auipc	ra,0x0
    8000124c:	f78080e7          	jalr	-136(ra) # 800011c0 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001250:	00007917          	auipc	s2,0x7
    80001254:	db090913          	addi	s2,s2,-592 # 80008000 <etext>
    80001258:	4729                	li	a4,10
    8000125a:	80007697          	auipc	a3,0x80007
    8000125e:	da668693          	addi	a3,a3,-602 # 8000 <_entry-0x7fff8000>
    80001262:	4605                	li	a2,1
    80001264:	067e                	slli	a2,a2,0x1f
    80001266:	85b2                	mv	a1,a2
    80001268:	8526                	mv	a0,s1
    8000126a:	00000097          	auipc	ra,0x0
    8000126e:	f56080e7          	jalr	-170(ra) # 800011c0 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001272:	4719                	li	a4,6
    80001274:	46c5                	li	a3,17
    80001276:	06ee                	slli	a3,a3,0x1b
    80001278:	412686b3          	sub	a3,a3,s2
    8000127c:	864a                	mv	a2,s2
    8000127e:	85ca                	mv	a1,s2
    80001280:	8526                	mv	a0,s1
    80001282:	00000097          	auipc	ra,0x0
    80001286:	f3e080e7          	jalr	-194(ra) # 800011c0 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000128a:	4729                	li	a4,10
    8000128c:	6685                	lui	a3,0x1
    8000128e:	00006617          	auipc	a2,0x6
    80001292:	d7260613          	addi	a2,a2,-654 # 80007000 <_trampoline>
    80001296:	040005b7          	lui	a1,0x4000
    8000129a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000129c:	05b2                	slli	a1,a1,0xc
    8000129e:	8526                	mv	a0,s1
    800012a0:	00000097          	auipc	ra,0x0
    800012a4:	f20080e7          	jalr	-224(ra) # 800011c0 <kvmmap>
  proc_mapstacks(kpgtbl);
    800012a8:	8526                	mv	a0,s1
    800012aa:	00000097          	auipc	ra,0x0
    800012ae:	6d4080e7          	jalr	1748(ra) # 8000197e <proc_mapstacks>
}
    800012b2:	8526                	mv	a0,s1
    800012b4:	60e2                	ld	ra,24(sp)
    800012b6:	6442                	ld	s0,16(sp)
    800012b8:	64a2                	ld	s1,8(sp)
    800012ba:	6902                	ld	s2,0(sp)
    800012bc:	6105                	addi	sp,sp,32
    800012be:	8082                	ret

00000000800012c0 <kvminit>:
{
    800012c0:	1141                	addi	sp,sp,-16
    800012c2:	e406                	sd	ra,8(sp)
    800012c4:	e022                	sd	s0,0(sp)
    800012c6:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800012c8:	00000097          	auipc	ra,0x0
    800012cc:	f28080e7          	jalr	-216(ra) # 800011f0 <kvmmake>
    800012d0:	00007797          	auipc	a5,0x7
    800012d4:	70a7b823          	sd	a0,1808(a5) # 800089e0 <kernel_pagetable>
}
    800012d8:	60a2                	ld	ra,8(sp)
    800012da:	6402                	ld	s0,0(sp)
    800012dc:	0141                	addi	sp,sp,16
    800012de:	8082                	ret

00000000800012e0 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800012e0:	715d                	addi	sp,sp,-80
    800012e2:	e486                	sd	ra,72(sp)
    800012e4:	e0a2                	sd	s0,64(sp)
    800012e6:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800012e8:	03459793          	slli	a5,a1,0x34
    800012ec:	e39d                	bnez	a5,80001312 <uvmunmap+0x32>
    800012ee:	f84a                	sd	s2,48(sp)
    800012f0:	f44e                	sd	s3,40(sp)
    800012f2:	f052                	sd	s4,32(sp)
    800012f4:	ec56                	sd	s5,24(sp)
    800012f6:	e85a                	sd	s6,16(sp)
    800012f8:	e45e                	sd	s7,8(sp)
    800012fa:	8a2a                	mv	s4,a0
    800012fc:	892e                	mv	s2,a1
    800012fe:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001300:	0632                	slli	a2,a2,0xc
    80001302:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001306:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001308:	6b05                	lui	s6,0x1
    8000130a:	0935fb63          	bgeu	a1,s3,800013a0 <uvmunmap+0xc0>
    8000130e:	fc26                	sd	s1,56(sp)
    80001310:	a8a9                	j	8000136a <uvmunmap+0x8a>
    80001312:	fc26                	sd	s1,56(sp)
    80001314:	f84a                	sd	s2,48(sp)
    80001316:	f44e                	sd	s3,40(sp)
    80001318:	f052                	sd	s4,32(sp)
    8000131a:	ec56                	sd	s5,24(sp)
    8000131c:	e85a                	sd	s6,16(sp)
    8000131e:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80001320:	00007517          	auipc	a0,0x7
    80001324:	dc050513          	addi	a0,a0,-576 # 800080e0 <etext+0xe0>
    80001328:	fffff097          	auipc	ra,0xfffff
    8000132c:	238080e7          	jalr	568(ra) # 80000560 <panic>
      panic("uvmunmap: walk");
    80001330:	00007517          	auipc	a0,0x7
    80001334:	dc850513          	addi	a0,a0,-568 # 800080f8 <etext+0xf8>
    80001338:	fffff097          	auipc	ra,0xfffff
    8000133c:	228080e7          	jalr	552(ra) # 80000560 <panic>
      panic("uvmunmap: not mapped");
    80001340:	00007517          	auipc	a0,0x7
    80001344:	dc850513          	addi	a0,a0,-568 # 80008108 <etext+0x108>
    80001348:	fffff097          	auipc	ra,0xfffff
    8000134c:	218080e7          	jalr	536(ra) # 80000560 <panic>
      panic("uvmunmap: not a leaf");
    80001350:	00007517          	auipc	a0,0x7
    80001354:	dd050513          	addi	a0,a0,-560 # 80008120 <etext+0x120>
    80001358:	fffff097          	auipc	ra,0xfffff
    8000135c:	208080e7          	jalr	520(ra) # 80000560 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80001360:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001364:	995a                	add	s2,s2,s6
    80001366:	03397c63          	bgeu	s2,s3,8000139e <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000136a:	4601                	li	a2,0
    8000136c:	85ca                	mv	a1,s2
    8000136e:	8552                	mv	a0,s4
    80001370:	00000097          	auipc	ra,0x0
    80001374:	cc2080e7          	jalr	-830(ra) # 80001032 <walk>
    80001378:	84aa                	mv	s1,a0
    8000137a:	d95d                	beqz	a0,80001330 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    8000137c:	6108                	ld	a0,0(a0)
    8000137e:	00157793          	andi	a5,a0,1
    80001382:	dfdd                	beqz	a5,80001340 <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001384:	3ff57793          	andi	a5,a0,1023
    80001388:	fd7784e3          	beq	a5,s7,80001350 <uvmunmap+0x70>
    if(do_free){
    8000138c:	fc0a8ae3          	beqz	s5,80001360 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    80001390:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001392:	0532                	slli	a0,a0,0xc
    80001394:	fffff097          	auipc	ra,0xfffff
    80001398:	6b8080e7          	jalr	1720(ra) # 80000a4c <kfree>
    8000139c:	b7d1                	j	80001360 <uvmunmap+0x80>
    8000139e:	74e2                	ld	s1,56(sp)
    800013a0:	7942                	ld	s2,48(sp)
    800013a2:	79a2                	ld	s3,40(sp)
    800013a4:	7a02                	ld	s4,32(sp)
    800013a6:	6ae2                	ld	s5,24(sp)
    800013a8:	6b42                	ld	s6,16(sp)
    800013aa:	6ba2                	ld	s7,8(sp)
  }
}
    800013ac:	60a6                	ld	ra,72(sp)
    800013ae:	6406                	ld	s0,64(sp)
    800013b0:	6161                	addi	sp,sp,80
    800013b2:	8082                	ret

00000000800013b4 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800013b4:	1101                	addi	sp,sp,-32
    800013b6:	ec06                	sd	ra,24(sp)
    800013b8:	e822                	sd	s0,16(sp)
    800013ba:	e426                	sd	s1,8(sp)
    800013bc:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800013be:	fffff097          	auipc	ra,0xfffff
    800013c2:	78c080e7          	jalr	1932(ra) # 80000b4a <kalloc>
    800013c6:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800013c8:	c519                	beqz	a0,800013d6 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800013ca:	6605                	lui	a2,0x1
    800013cc:	4581                	li	a1,0
    800013ce:	00000097          	auipc	ra,0x0
    800013d2:	968080e7          	jalr	-1688(ra) # 80000d36 <memset>
  return pagetable;
}
    800013d6:	8526                	mv	a0,s1
    800013d8:	60e2                	ld	ra,24(sp)
    800013da:	6442                	ld	s0,16(sp)
    800013dc:	64a2                	ld	s1,8(sp)
    800013de:	6105                	addi	sp,sp,32
    800013e0:	8082                	ret

00000000800013e2 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800013e2:	7179                	addi	sp,sp,-48
    800013e4:	f406                	sd	ra,40(sp)
    800013e6:	f022                	sd	s0,32(sp)
    800013e8:	ec26                	sd	s1,24(sp)
    800013ea:	e84a                	sd	s2,16(sp)
    800013ec:	e44e                	sd	s3,8(sp)
    800013ee:	e052                	sd	s4,0(sp)
    800013f0:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800013f2:	6785                	lui	a5,0x1
    800013f4:	04f67863          	bgeu	a2,a5,80001444 <uvmfirst+0x62>
    800013f8:	8a2a                	mv	s4,a0
    800013fa:	89ae                	mv	s3,a1
    800013fc:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800013fe:	fffff097          	auipc	ra,0xfffff
    80001402:	74c080e7          	jalr	1868(ra) # 80000b4a <kalloc>
    80001406:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001408:	6605                	lui	a2,0x1
    8000140a:	4581                	li	a1,0
    8000140c:	00000097          	auipc	ra,0x0
    80001410:	92a080e7          	jalr	-1750(ra) # 80000d36 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001414:	4779                	li	a4,30
    80001416:	86ca                	mv	a3,s2
    80001418:	6605                	lui	a2,0x1
    8000141a:	4581                	li	a1,0
    8000141c:	8552                	mv	a0,s4
    8000141e:	00000097          	auipc	ra,0x0
    80001422:	cfc080e7          	jalr	-772(ra) # 8000111a <mappages>
  memmove(mem, src, sz);
    80001426:	8626                	mv	a2,s1
    80001428:	85ce                	mv	a1,s3
    8000142a:	854a                	mv	a0,s2
    8000142c:	00000097          	auipc	ra,0x0
    80001430:	96e080e7          	jalr	-1682(ra) # 80000d9a <memmove>
}
    80001434:	70a2                	ld	ra,40(sp)
    80001436:	7402                	ld	s0,32(sp)
    80001438:	64e2                	ld	s1,24(sp)
    8000143a:	6942                	ld	s2,16(sp)
    8000143c:	69a2                	ld	s3,8(sp)
    8000143e:	6a02                	ld	s4,0(sp)
    80001440:	6145                	addi	sp,sp,48
    80001442:	8082                	ret
    panic("uvmfirst: more than a page");
    80001444:	00007517          	auipc	a0,0x7
    80001448:	cf450513          	addi	a0,a0,-780 # 80008138 <etext+0x138>
    8000144c:	fffff097          	auipc	ra,0xfffff
    80001450:	114080e7          	jalr	276(ra) # 80000560 <panic>

0000000080001454 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001454:	1101                	addi	sp,sp,-32
    80001456:	ec06                	sd	ra,24(sp)
    80001458:	e822                	sd	s0,16(sp)
    8000145a:	e426                	sd	s1,8(sp)
    8000145c:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000145e:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001460:	00b67d63          	bgeu	a2,a1,8000147a <uvmdealloc+0x26>
    80001464:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001466:	6785                	lui	a5,0x1
    80001468:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000146a:	00f60733          	add	a4,a2,a5
    8000146e:	76fd                	lui	a3,0xfffff
    80001470:	8f75                	and	a4,a4,a3
    80001472:	97ae                	add	a5,a5,a1
    80001474:	8ff5                	and	a5,a5,a3
    80001476:	00f76863          	bltu	a4,a5,80001486 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000147a:	8526                	mv	a0,s1
    8000147c:	60e2                	ld	ra,24(sp)
    8000147e:	6442                	ld	s0,16(sp)
    80001480:	64a2                	ld	s1,8(sp)
    80001482:	6105                	addi	sp,sp,32
    80001484:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001486:	8f99                	sub	a5,a5,a4
    80001488:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000148a:	4685                	li	a3,1
    8000148c:	0007861b          	sext.w	a2,a5
    80001490:	85ba                	mv	a1,a4
    80001492:	00000097          	auipc	ra,0x0
    80001496:	e4e080e7          	jalr	-434(ra) # 800012e0 <uvmunmap>
    8000149a:	b7c5                	j	8000147a <uvmdealloc+0x26>

000000008000149c <uvmalloc>:
  if(newsz < oldsz)
    8000149c:	0ab66f63          	bltu	a2,a1,8000155a <uvmalloc+0xbe>
{
    800014a0:	715d                	addi	sp,sp,-80
    800014a2:	e486                	sd	ra,72(sp)
    800014a4:	e0a2                	sd	s0,64(sp)
    800014a6:	f052                	sd	s4,32(sp)
    800014a8:	ec56                	sd	s5,24(sp)
    800014aa:	e85a                	sd	s6,16(sp)
    800014ac:	0880                	addi	s0,sp,80
    800014ae:	8b2a                	mv	s6,a0
    800014b0:	8ab2                	mv	s5,a2
  oldsz = PGROUNDUP(oldsz);
    800014b2:	6785                	lui	a5,0x1
    800014b4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800014b6:	95be                	add	a1,a1,a5
    800014b8:	77fd                	lui	a5,0xfffff
    800014ba:	00f5fa33          	and	s4,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800014be:	0aca7063          	bgeu	s4,a2,8000155e <uvmalloc+0xc2>
    800014c2:	fc26                	sd	s1,56(sp)
    800014c4:	f84a                	sd	s2,48(sp)
    800014c6:	f44e                	sd	s3,40(sp)
    800014c8:	e45e                	sd	s7,8(sp)
    800014ca:	8952                	mv	s2,s4
    memset(mem, 0, PGSIZE);
    800014cc:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800014ce:	0126eb93          	ori	s7,a3,18
    mem = kalloc();
    800014d2:	fffff097          	auipc	ra,0xfffff
    800014d6:	678080e7          	jalr	1656(ra) # 80000b4a <kalloc>
    800014da:	84aa                	mv	s1,a0
    if(mem == 0){
    800014dc:	c915                	beqz	a0,80001510 <uvmalloc+0x74>
    memset(mem, 0, PGSIZE);
    800014de:	864e                	mv	a2,s3
    800014e0:	4581                	li	a1,0
    800014e2:	00000097          	auipc	ra,0x0
    800014e6:	854080e7          	jalr	-1964(ra) # 80000d36 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800014ea:	875e                	mv	a4,s7
    800014ec:	86a6                	mv	a3,s1
    800014ee:	864e                	mv	a2,s3
    800014f0:	85ca                	mv	a1,s2
    800014f2:	855a                	mv	a0,s6
    800014f4:	00000097          	auipc	ra,0x0
    800014f8:	c26080e7          	jalr	-986(ra) # 8000111a <mappages>
    800014fc:	ed0d                	bnez	a0,80001536 <uvmalloc+0x9a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800014fe:	994e                	add	s2,s2,s3
    80001500:	fd5969e3          	bltu	s2,s5,800014d2 <uvmalloc+0x36>
  return newsz;
    80001504:	8556                	mv	a0,s5
    80001506:	74e2                	ld	s1,56(sp)
    80001508:	7942                	ld	s2,48(sp)
    8000150a:	79a2                	ld	s3,40(sp)
    8000150c:	6ba2                	ld	s7,8(sp)
    8000150e:	a829                	j	80001528 <uvmalloc+0x8c>
      uvmdealloc(pagetable, a, oldsz);
    80001510:	8652                	mv	a2,s4
    80001512:	85ca                	mv	a1,s2
    80001514:	855a                	mv	a0,s6
    80001516:	00000097          	auipc	ra,0x0
    8000151a:	f3e080e7          	jalr	-194(ra) # 80001454 <uvmdealloc>
      return 0;
    8000151e:	4501                	li	a0,0
    80001520:	74e2                	ld	s1,56(sp)
    80001522:	7942                	ld	s2,48(sp)
    80001524:	79a2                	ld	s3,40(sp)
    80001526:	6ba2                	ld	s7,8(sp)
}
    80001528:	60a6                	ld	ra,72(sp)
    8000152a:	6406                	ld	s0,64(sp)
    8000152c:	7a02                	ld	s4,32(sp)
    8000152e:	6ae2                	ld	s5,24(sp)
    80001530:	6b42                	ld	s6,16(sp)
    80001532:	6161                	addi	sp,sp,80
    80001534:	8082                	ret
      kfree(mem);
    80001536:	8526                	mv	a0,s1
    80001538:	fffff097          	auipc	ra,0xfffff
    8000153c:	514080e7          	jalr	1300(ra) # 80000a4c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001540:	8652                	mv	a2,s4
    80001542:	85ca                	mv	a1,s2
    80001544:	855a                	mv	a0,s6
    80001546:	00000097          	auipc	ra,0x0
    8000154a:	f0e080e7          	jalr	-242(ra) # 80001454 <uvmdealloc>
      return 0;
    8000154e:	4501                	li	a0,0
    80001550:	74e2                	ld	s1,56(sp)
    80001552:	7942                	ld	s2,48(sp)
    80001554:	79a2                	ld	s3,40(sp)
    80001556:	6ba2                	ld	s7,8(sp)
    80001558:	bfc1                	j	80001528 <uvmalloc+0x8c>
    return oldsz;
    8000155a:	852e                	mv	a0,a1
}
    8000155c:	8082                	ret
  return newsz;
    8000155e:	8532                	mv	a0,a2
    80001560:	b7e1                	j	80001528 <uvmalloc+0x8c>

0000000080001562 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001562:	7179                	addi	sp,sp,-48
    80001564:	f406                	sd	ra,40(sp)
    80001566:	f022                	sd	s0,32(sp)
    80001568:	ec26                	sd	s1,24(sp)
    8000156a:	e84a                	sd	s2,16(sp)
    8000156c:	e44e                	sd	s3,8(sp)
    8000156e:	e052                	sd	s4,0(sp)
    80001570:	1800                	addi	s0,sp,48
    80001572:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001574:	84aa                	mv	s1,a0
    80001576:	6905                	lui	s2,0x1
    80001578:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000157a:	4985                	li	s3,1
    8000157c:	a829                	j	80001596 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000157e:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001580:	00c79513          	slli	a0,a5,0xc
    80001584:	00000097          	auipc	ra,0x0
    80001588:	fde080e7          	jalr	-34(ra) # 80001562 <freewalk>
      pagetable[i] = 0;
    8000158c:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001590:	04a1                	addi	s1,s1,8
    80001592:	03248163          	beq	s1,s2,800015b4 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80001596:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001598:	00f7f713          	andi	a4,a5,15
    8000159c:	ff3701e3          	beq	a4,s3,8000157e <freewalk+0x1c>
    } else if(pte & PTE_V){
    800015a0:	8b85                	andi	a5,a5,1
    800015a2:	d7fd                	beqz	a5,80001590 <freewalk+0x2e>
      panic("freewalk: leaf");
    800015a4:	00007517          	auipc	a0,0x7
    800015a8:	bb450513          	addi	a0,a0,-1100 # 80008158 <etext+0x158>
    800015ac:	fffff097          	auipc	ra,0xfffff
    800015b0:	fb4080e7          	jalr	-76(ra) # 80000560 <panic>
    }
  }
  kfree((void*)pagetable);
    800015b4:	8552                	mv	a0,s4
    800015b6:	fffff097          	auipc	ra,0xfffff
    800015ba:	496080e7          	jalr	1174(ra) # 80000a4c <kfree>
}
    800015be:	70a2                	ld	ra,40(sp)
    800015c0:	7402                	ld	s0,32(sp)
    800015c2:	64e2                	ld	s1,24(sp)
    800015c4:	6942                	ld	s2,16(sp)
    800015c6:	69a2                	ld	s3,8(sp)
    800015c8:	6a02                	ld	s4,0(sp)
    800015ca:	6145                	addi	sp,sp,48
    800015cc:	8082                	ret

00000000800015ce <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800015ce:	1101                	addi	sp,sp,-32
    800015d0:	ec06                	sd	ra,24(sp)
    800015d2:	e822                	sd	s0,16(sp)
    800015d4:	e426                	sd	s1,8(sp)
    800015d6:	1000                	addi	s0,sp,32
    800015d8:	84aa                	mv	s1,a0
  if(sz > 0)
    800015da:	e999                	bnez	a1,800015f0 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800015dc:	8526                	mv	a0,s1
    800015de:	00000097          	auipc	ra,0x0
    800015e2:	f84080e7          	jalr	-124(ra) # 80001562 <freewalk>
}
    800015e6:	60e2                	ld	ra,24(sp)
    800015e8:	6442                	ld	s0,16(sp)
    800015ea:	64a2                	ld	s1,8(sp)
    800015ec:	6105                	addi	sp,sp,32
    800015ee:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800015f0:	6785                	lui	a5,0x1
    800015f2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800015f4:	95be                	add	a1,a1,a5
    800015f6:	4685                	li	a3,1
    800015f8:	00c5d613          	srli	a2,a1,0xc
    800015fc:	4581                	li	a1,0
    800015fe:	00000097          	auipc	ra,0x0
    80001602:	ce2080e7          	jalr	-798(ra) # 800012e0 <uvmunmap>
    80001606:	bfd9                	j	800015dc <uvmfree+0xe>

0000000080001608 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001608:	ca69                	beqz	a2,800016da <uvmcopy+0xd2>
{
    8000160a:	715d                	addi	sp,sp,-80
    8000160c:	e486                	sd	ra,72(sp)
    8000160e:	e0a2                	sd	s0,64(sp)
    80001610:	fc26                	sd	s1,56(sp)
    80001612:	f84a                	sd	s2,48(sp)
    80001614:	f44e                	sd	s3,40(sp)
    80001616:	f052                	sd	s4,32(sp)
    80001618:	ec56                	sd	s5,24(sp)
    8000161a:	e85a                	sd	s6,16(sp)
    8000161c:	e45e                	sd	s7,8(sp)
    8000161e:	e062                	sd	s8,0(sp)
    80001620:	0880                	addi	s0,sp,80
    80001622:	8baa                	mv	s7,a0
    80001624:	8b2e                	mv	s6,a1
    80001626:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001628:	4981                	li	s3,0
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    8000162a:	6a05                	lui	s4,0x1
    if((pte = walk(old, i, 0)) == 0)
    8000162c:	4601                	li	a2,0
    8000162e:	85ce                	mv	a1,s3
    80001630:	855e                	mv	a0,s7
    80001632:	00000097          	auipc	ra,0x0
    80001636:	a00080e7          	jalr	-1536(ra) # 80001032 <walk>
    8000163a:	c529                	beqz	a0,80001684 <uvmcopy+0x7c>
    if((*pte & PTE_V) == 0)
    8000163c:	6118                	ld	a4,0(a0)
    8000163e:	00177793          	andi	a5,a4,1
    80001642:	cba9                	beqz	a5,80001694 <uvmcopy+0x8c>
    pa = PTE2PA(*pte);
    80001644:	00a75593          	srli	a1,a4,0xa
    80001648:	00c59c13          	slli	s8,a1,0xc
    flags = PTE_FLAGS(*pte);
    8000164c:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80001650:	fffff097          	auipc	ra,0xfffff
    80001654:	4fa080e7          	jalr	1274(ra) # 80000b4a <kalloc>
    80001658:	892a                	mv	s2,a0
    8000165a:	c931                	beqz	a0,800016ae <uvmcopy+0xa6>
    memmove(mem, (char*)pa, PGSIZE);
    8000165c:	8652                	mv	a2,s4
    8000165e:	85e2                	mv	a1,s8
    80001660:	fffff097          	auipc	ra,0xfffff
    80001664:	73a080e7          	jalr	1850(ra) # 80000d9a <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001668:	8726                	mv	a4,s1
    8000166a:	86ca                	mv	a3,s2
    8000166c:	8652                	mv	a2,s4
    8000166e:	85ce                	mv	a1,s3
    80001670:	855a                	mv	a0,s6
    80001672:	00000097          	auipc	ra,0x0
    80001676:	aa8080e7          	jalr	-1368(ra) # 8000111a <mappages>
    8000167a:	e50d                	bnez	a0,800016a4 <uvmcopy+0x9c>
  for(i = 0; i < sz; i += PGSIZE){
    8000167c:	99d2                	add	s3,s3,s4
    8000167e:	fb59e7e3          	bltu	s3,s5,8000162c <uvmcopy+0x24>
    80001682:	a081                	j	800016c2 <uvmcopy+0xba>
      panic("uvmcopy: pte should exist");
    80001684:	00007517          	auipc	a0,0x7
    80001688:	ae450513          	addi	a0,a0,-1308 # 80008168 <etext+0x168>
    8000168c:	fffff097          	auipc	ra,0xfffff
    80001690:	ed4080e7          	jalr	-300(ra) # 80000560 <panic>
      panic("uvmcopy: page not present");
    80001694:	00007517          	auipc	a0,0x7
    80001698:	af450513          	addi	a0,a0,-1292 # 80008188 <etext+0x188>
    8000169c:	fffff097          	auipc	ra,0xfffff
    800016a0:	ec4080e7          	jalr	-316(ra) # 80000560 <panic>
      kfree(mem);
    800016a4:	854a                	mv	a0,s2
    800016a6:	fffff097          	auipc	ra,0xfffff
    800016aa:	3a6080e7          	jalr	934(ra) # 80000a4c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800016ae:	4685                	li	a3,1
    800016b0:	00c9d613          	srli	a2,s3,0xc
    800016b4:	4581                	li	a1,0
    800016b6:	855a                	mv	a0,s6
    800016b8:	00000097          	auipc	ra,0x0
    800016bc:	c28080e7          	jalr	-984(ra) # 800012e0 <uvmunmap>
  return -1;
    800016c0:	557d                	li	a0,-1
}
    800016c2:	60a6                	ld	ra,72(sp)
    800016c4:	6406                	ld	s0,64(sp)
    800016c6:	74e2                	ld	s1,56(sp)
    800016c8:	7942                	ld	s2,48(sp)
    800016ca:	79a2                	ld	s3,40(sp)
    800016cc:	7a02                	ld	s4,32(sp)
    800016ce:	6ae2                	ld	s5,24(sp)
    800016d0:	6b42                	ld	s6,16(sp)
    800016d2:	6ba2                	ld	s7,8(sp)
    800016d4:	6c02                	ld	s8,0(sp)
    800016d6:	6161                	addi	sp,sp,80
    800016d8:	8082                	ret
  return 0;
    800016da:	4501                	li	a0,0
}
    800016dc:	8082                	ret

00000000800016de <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800016de:	1141                	addi	sp,sp,-16
    800016e0:	e406                	sd	ra,8(sp)
    800016e2:	e022                	sd	s0,0(sp)
    800016e4:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800016e6:	4601                	li	a2,0
    800016e8:	00000097          	auipc	ra,0x0
    800016ec:	94a080e7          	jalr	-1718(ra) # 80001032 <walk>
  if(pte == 0)
    800016f0:	c901                	beqz	a0,80001700 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800016f2:	611c                	ld	a5,0(a0)
    800016f4:	9bbd                	andi	a5,a5,-17
    800016f6:	e11c                	sd	a5,0(a0)
}
    800016f8:	60a2                	ld	ra,8(sp)
    800016fa:	6402                	ld	s0,0(sp)
    800016fc:	0141                	addi	sp,sp,16
    800016fe:	8082                	ret
    panic("uvmclear");
    80001700:	00007517          	auipc	a0,0x7
    80001704:	aa850513          	addi	a0,a0,-1368 # 800081a8 <etext+0x1a8>
    80001708:	fffff097          	auipc	ra,0xfffff
    8000170c:	e58080e7          	jalr	-424(ra) # 80000560 <panic>

0000000080001710 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001710:	c6bd                	beqz	a3,8000177e <copyout+0x6e>
{
    80001712:	715d                	addi	sp,sp,-80
    80001714:	e486                	sd	ra,72(sp)
    80001716:	e0a2                	sd	s0,64(sp)
    80001718:	fc26                	sd	s1,56(sp)
    8000171a:	f84a                	sd	s2,48(sp)
    8000171c:	f44e                	sd	s3,40(sp)
    8000171e:	f052                	sd	s4,32(sp)
    80001720:	ec56                	sd	s5,24(sp)
    80001722:	e85a                	sd	s6,16(sp)
    80001724:	e45e                	sd	s7,8(sp)
    80001726:	e062                	sd	s8,0(sp)
    80001728:	0880                	addi	s0,sp,80
    8000172a:	8b2a                	mv	s6,a0
    8000172c:	8c2e                	mv	s8,a1
    8000172e:	8a32                	mv	s4,a2
    80001730:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001732:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001734:	6a85                	lui	s5,0x1
    80001736:	a015                	j	8000175a <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001738:	9562                	add	a0,a0,s8
    8000173a:	0004861b          	sext.w	a2,s1
    8000173e:	85d2                	mv	a1,s4
    80001740:	41250533          	sub	a0,a0,s2
    80001744:	fffff097          	auipc	ra,0xfffff
    80001748:	656080e7          	jalr	1622(ra) # 80000d9a <memmove>

    len -= n;
    8000174c:	409989b3          	sub	s3,s3,s1
    src += n;
    80001750:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80001752:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001756:	02098263          	beqz	s3,8000177a <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    8000175a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000175e:	85ca                	mv	a1,s2
    80001760:	855a                	mv	a0,s6
    80001762:	00000097          	auipc	ra,0x0
    80001766:	976080e7          	jalr	-1674(ra) # 800010d8 <walkaddr>
    if(pa0 == 0)
    8000176a:	cd01                	beqz	a0,80001782 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    8000176c:	418904b3          	sub	s1,s2,s8
    80001770:	94d6                	add	s1,s1,s5
    if(n > len)
    80001772:	fc99f3e3          	bgeu	s3,s1,80001738 <copyout+0x28>
    80001776:	84ce                	mv	s1,s3
    80001778:	b7c1                	j	80001738 <copyout+0x28>
  }
  return 0;
    8000177a:	4501                	li	a0,0
    8000177c:	a021                	j	80001784 <copyout+0x74>
    8000177e:	4501                	li	a0,0
}
    80001780:	8082                	ret
      return -1;
    80001782:	557d                	li	a0,-1
}
    80001784:	60a6                	ld	ra,72(sp)
    80001786:	6406                	ld	s0,64(sp)
    80001788:	74e2                	ld	s1,56(sp)
    8000178a:	7942                	ld	s2,48(sp)
    8000178c:	79a2                	ld	s3,40(sp)
    8000178e:	7a02                	ld	s4,32(sp)
    80001790:	6ae2                	ld	s5,24(sp)
    80001792:	6b42                	ld	s6,16(sp)
    80001794:	6ba2                	ld	s7,8(sp)
    80001796:	6c02                	ld	s8,0(sp)
    80001798:	6161                	addi	sp,sp,80
    8000179a:	8082                	ret

000000008000179c <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000179c:	caa5                	beqz	a3,8000180c <copyin+0x70>
{
    8000179e:	715d                	addi	sp,sp,-80
    800017a0:	e486                	sd	ra,72(sp)
    800017a2:	e0a2                	sd	s0,64(sp)
    800017a4:	fc26                	sd	s1,56(sp)
    800017a6:	f84a                	sd	s2,48(sp)
    800017a8:	f44e                	sd	s3,40(sp)
    800017aa:	f052                	sd	s4,32(sp)
    800017ac:	ec56                	sd	s5,24(sp)
    800017ae:	e85a                	sd	s6,16(sp)
    800017b0:	e45e                	sd	s7,8(sp)
    800017b2:	e062                	sd	s8,0(sp)
    800017b4:	0880                	addi	s0,sp,80
    800017b6:	8b2a                	mv	s6,a0
    800017b8:	8a2e                	mv	s4,a1
    800017ba:	8c32                	mv	s8,a2
    800017bc:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800017be:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800017c0:	6a85                	lui	s5,0x1
    800017c2:	a01d                	j	800017e8 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800017c4:	018505b3          	add	a1,a0,s8
    800017c8:	0004861b          	sext.w	a2,s1
    800017cc:	412585b3          	sub	a1,a1,s2
    800017d0:	8552                	mv	a0,s4
    800017d2:	fffff097          	auipc	ra,0xfffff
    800017d6:	5c8080e7          	jalr	1480(ra) # 80000d9a <memmove>

    len -= n;
    800017da:	409989b3          	sub	s3,s3,s1
    dst += n;
    800017de:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    800017e0:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800017e4:	02098263          	beqz	s3,80001808 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    800017e8:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800017ec:	85ca                	mv	a1,s2
    800017ee:	855a                	mv	a0,s6
    800017f0:	00000097          	auipc	ra,0x0
    800017f4:	8e8080e7          	jalr	-1816(ra) # 800010d8 <walkaddr>
    if(pa0 == 0)
    800017f8:	cd01                	beqz	a0,80001810 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    800017fa:	418904b3          	sub	s1,s2,s8
    800017fe:	94d6                	add	s1,s1,s5
    if(n > len)
    80001800:	fc99f2e3          	bgeu	s3,s1,800017c4 <copyin+0x28>
    80001804:	84ce                	mv	s1,s3
    80001806:	bf7d                	j	800017c4 <copyin+0x28>
  }
  return 0;
    80001808:	4501                	li	a0,0
    8000180a:	a021                	j	80001812 <copyin+0x76>
    8000180c:	4501                	li	a0,0
}
    8000180e:	8082                	ret
      return -1;
    80001810:	557d                	li	a0,-1
}
    80001812:	60a6                	ld	ra,72(sp)
    80001814:	6406                	ld	s0,64(sp)
    80001816:	74e2                	ld	s1,56(sp)
    80001818:	7942                	ld	s2,48(sp)
    8000181a:	79a2                	ld	s3,40(sp)
    8000181c:	7a02                	ld	s4,32(sp)
    8000181e:	6ae2                	ld	s5,24(sp)
    80001820:	6b42                	ld	s6,16(sp)
    80001822:	6ba2                	ld	s7,8(sp)
    80001824:	6c02                	ld	s8,0(sp)
    80001826:	6161                	addi	sp,sp,80
    80001828:	8082                	ret

000000008000182a <copyinstr>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    8000182a:	715d                	addi	sp,sp,-80
    8000182c:	e486                	sd	ra,72(sp)
    8000182e:	e0a2                	sd	s0,64(sp)
    80001830:	fc26                	sd	s1,56(sp)
    80001832:	f84a                	sd	s2,48(sp)
    80001834:	f44e                	sd	s3,40(sp)
    80001836:	f052                	sd	s4,32(sp)
    80001838:	ec56                	sd	s5,24(sp)
    8000183a:	e85a                	sd	s6,16(sp)
    8000183c:	e45e                	sd	s7,8(sp)
    8000183e:	0880                	addi	s0,sp,80
    80001840:	8aaa                	mv	s5,a0
    80001842:	89ae                	mv	s3,a1
    80001844:	8bb2                	mv	s7,a2
    80001846:	84b6                	mv	s1,a3
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    va0 = PGROUNDDOWN(srcva);
    80001848:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000184a:	6a05                	lui	s4,0x1
    8000184c:	a02d                	j	80001876 <copyinstr+0x4c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    8000184e:	00078023          	sb	zero,0(a5)
    80001852:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001854:	0017c793          	xori	a5,a5,1
    80001858:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    8000185c:	60a6                	ld	ra,72(sp)
    8000185e:	6406                	ld	s0,64(sp)
    80001860:	74e2                	ld	s1,56(sp)
    80001862:	7942                	ld	s2,48(sp)
    80001864:	79a2                	ld	s3,40(sp)
    80001866:	7a02                	ld	s4,32(sp)
    80001868:	6ae2                	ld	s5,24(sp)
    8000186a:	6b42                	ld	s6,16(sp)
    8000186c:	6ba2                	ld	s7,8(sp)
    8000186e:	6161                	addi	sp,sp,80
    80001870:	8082                	ret
    srcva = va0 + PGSIZE;
    80001872:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    80001876:	c8a1                	beqz	s1,800018c6 <copyinstr+0x9c>
    va0 = PGROUNDDOWN(srcva);
    80001878:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    8000187c:	85ca                	mv	a1,s2
    8000187e:	8556                	mv	a0,s5
    80001880:	00000097          	auipc	ra,0x0
    80001884:	858080e7          	jalr	-1960(ra) # 800010d8 <walkaddr>
    if(pa0 == 0)
    80001888:	c129                	beqz	a0,800018ca <copyinstr+0xa0>
    n = PGSIZE - (srcva - va0);
    8000188a:	41790633          	sub	a2,s2,s7
    8000188e:	9652                	add	a2,a2,s4
    if(n > max)
    80001890:	00c4f363          	bgeu	s1,a2,80001896 <copyinstr+0x6c>
    80001894:	8626                	mv	a2,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80001896:	412b8bb3          	sub	s7,s7,s2
    8000189a:	9baa                	add	s7,s7,a0
    while(n > 0){
    8000189c:	da79                	beqz	a2,80001872 <copyinstr+0x48>
    8000189e:	87ce                	mv	a5,s3
      if(*p == '\0'){
    800018a0:	413b86b3          	sub	a3,s7,s3
    while(n > 0){
    800018a4:	964e                	add	a2,a2,s3
    800018a6:	85be                	mv	a1,a5
      if(*p == '\0'){
    800018a8:	00f68733          	add	a4,a3,a5
    800018ac:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdd190>
    800018b0:	df59                	beqz	a4,8000184e <copyinstr+0x24>
        *dst = *p;
    800018b2:	00e78023          	sb	a4,0(a5)
      dst++;
    800018b6:	0785                	addi	a5,a5,1
    while(n > 0){
    800018b8:	fec797e3          	bne	a5,a2,800018a6 <copyinstr+0x7c>
    800018bc:	14fd                	addi	s1,s1,-1
    800018be:	94ce                	add	s1,s1,s3
      --max;
    800018c0:	8c8d                	sub	s1,s1,a1
    800018c2:	89be                	mv	s3,a5
    800018c4:	b77d                	j	80001872 <copyinstr+0x48>
    800018c6:	4781                	li	a5,0
    800018c8:	b771                	j	80001854 <copyinstr+0x2a>
      return -1;
    800018ca:	557d                	li	a0,-1
    800018cc:	bf41                	j	8000185c <copyinstr+0x32>

00000000800018ce <rr_scheduler>:
        old_scheduler = sched_pointer;
    }
}

void rr_scheduler(void)
{
    800018ce:	7139                	addi	sp,sp,-64
    800018d0:	fc06                	sd	ra,56(sp)
    800018d2:	f822                	sd	s0,48(sp)
    800018d4:	f426                	sd	s1,40(sp)
    800018d6:	f04a                	sd	s2,32(sp)
    800018d8:	ec4e                	sd	s3,24(sp)
    800018da:	e852                	sd	s4,16(sp)
    800018dc:	e456                	sd	s5,8(sp)
    800018de:	e05a                	sd	s6,0(sp)
    800018e0:	0080                	addi	s0,sp,64
  asm volatile("mv %0, tp" : "=r" (x) );
    800018e2:	8792                	mv	a5,tp
    int id = r_tp();
    800018e4:	2781                	sext.w	a5,a5
    struct proc *p;
    struct cpu *c = mycpu();

    c->proc = 0;
    800018e6:	0000fa97          	auipc	s5,0xf
    800018ea:	37aa8a93          	addi	s5,s5,890 # 80010c60 <cpus>
    800018ee:	00779713          	slli	a4,a5,0x7
    800018f2:	00ea86b3          	add	a3,s5,a4
    800018f6:	0006b023          	sd	zero,0(a3) # fffffffffffff000 <end+0xffffffff7ffdd190>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018fa:	100026f3          	csrr	a3,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800018fe:	0026e693          	ori	a3,a3,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001902:	10069073          	csrw	sstatus,a3
            // Switch to chosen process.  It is the process's job
            // to release its lock and then reacquire it
            // before jumping back to us.
            p->state = RUNNING;
            c->proc = p;
            swtch(&c->context, &p->context);
    80001906:	0721                	addi	a4,a4,8
    80001908:	9aba                	add	s5,s5,a4
    for (p = proc; p < &proc[NPROC]; p++)
    8000190a:	0000f497          	auipc	s1,0xf
    8000190e:	78648493          	addi	s1,s1,1926 # 80011090 <proc>
        if (p->state == RUNNABLE)
    80001912:	498d                	li	s3,3
            p->state = RUNNING;
    80001914:	4b11                	li	s6,4
            c->proc = p;
    80001916:	079e                	slli	a5,a5,0x7
    80001918:	0000fa17          	auipc	s4,0xf
    8000191c:	348a0a13          	addi	s4,s4,840 # 80010c60 <cpus>
    80001920:	9a3e                	add	s4,s4,a5
    for (p = proc; p < &proc[NPROC]; p++)
    80001922:	00015917          	auipc	s2,0x15
    80001926:	16e90913          	addi	s2,s2,366 # 80016a90 <tickslock>
    8000192a:	a811                	j	8000193e <rr_scheduler+0x70>

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            c->proc = 0;
        }
        release(&p->lock);
    8000192c:	8526                	mv	a0,s1
    8000192e:	fffff097          	auipc	ra,0xfffff
    80001932:	3c0080e7          	jalr	960(ra) # 80000cee <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80001936:	16848493          	addi	s1,s1,360
    8000193a:	03248863          	beq	s1,s2,8000196a <rr_scheduler+0x9c>
        acquire(&p->lock);
    8000193e:	8526                	mv	a0,s1
    80001940:	fffff097          	auipc	ra,0xfffff
    80001944:	2fe080e7          	jalr	766(ra) # 80000c3e <acquire>
        if (p->state == RUNNABLE)
    80001948:	4c9c                	lw	a5,24(s1)
    8000194a:	ff3791e3          	bne	a5,s3,8000192c <rr_scheduler+0x5e>
            p->state = RUNNING;
    8000194e:	0164ac23          	sw	s6,24(s1)
            c->proc = p;
    80001952:	009a3023          	sd	s1,0(s4)
            swtch(&c->context, &p->context);
    80001956:	06048593          	addi	a1,s1,96
    8000195a:	8556                	mv	a0,s5
    8000195c:	00001097          	auipc	ra,0x1
    80001960:	ffe080e7          	jalr	-2(ra) # 8000295a <swtch>
            c->proc = 0;
    80001964:	000a3023          	sd	zero,0(s4)
    80001968:	b7d1                	j	8000192c <rr_scheduler+0x5e>
    }
    // In case a setsched happened, we will switch to the new scheduler after one
    // Round Robin round has completed.
}
    8000196a:	70e2                	ld	ra,56(sp)
    8000196c:	7442                	ld	s0,48(sp)
    8000196e:	74a2                	ld	s1,40(sp)
    80001970:	7902                	ld	s2,32(sp)
    80001972:	69e2                	ld	s3,24(sp)
    80001974:	6a42                	ld	s4,16(sp)
    80001976:	6aa2                	ld	s5,8(sp)
    80001978:	6b02                	ld	s6,0(sp)
    8000197a:	6121                	addi	sp,sp,64
    8000197c:	8082                	ret

000000008000197e <proc_mapstacks>:
{
    8000197e:	715d                	addi	sp,sp,-80
    80001980:	e486                	sd	ra,72(sp)
    80001982:	e0a2                	sd	s0,64(sp)
    80001984:	fc26                	sd	s1,56(sp)
    80001986:	f84a                	sd	s2,48(sp)
    80001988:	f44e                	sd	s3,40(sp)
    8000198a:	f052                	sd	s4,32(sp)
    8000198c:	ec56                	sd	s5,24(sp)
    8000198e:	e85a                	sd	s6,16(sp)
    80001990:	e45e                	sd	s7,8(sp)
    80001992:	e062                	sd	s8,0(sp)
    80001994:	0880                	addi	s0,sp,80
    80001996:	8a2a                	mv	s4,a0
    for (p = proc; p < &proc[NPROC]; p++)
    80001998:	0000f497          	auipc	s1,0xf
    8000199c:	6f848493          	addi	s1,s1,1784 # 80011090 <proc>
        uint64 va = KSTACK((int)(p - proc));
    800019a0:	8c26                	mv	s8,s1
    800019a2:	a4fa57b7          	lui	a5,0xa4fa5
    800019a6:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff24f83135>
    800019aa:	4fa50937          	lui	s2,0x4fa50
    800019ae:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x305b05b0>
    800019b2:	1902                	slli	s2,s2,0x20
    800019b4:	993e                	add	s2,s2,a5
    800019b6:	040009b7          	lui	s3,0x4000
    800019ba:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800019bc:	09b2                	slli	s3,s3,0xc
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800019be:	4b99                	li	s7,6
    800019c0:	6b05                	lui	s6,0x1
    for (p = proc; p < &proc[NPROC]; p++)
    800019c2:	00015a97          	auipc	s5,0x15
    800019c6:	0cea8a93          	addi	s5,s5,206 # 80016a90 <tickslock>
        char *pa = kalloc();
    800019ca:	fffff097          	auipc	ra,0xfffff
    800019ce:	180080e7          	jalr	384(ra) # 80000b4a <kalloc>
    800019d2:	862a                	mv	a2,a0
        if (pa == 0)
    800019d4:	c131                	beqz	a0,80001a18 <proc_mapstacks+0x9a>
        uint64 va = KSTACK((int)(p - proc));
    800019d6:	418485b3          	sub	a1,s1,s8
    800019da:	858d                	srai	a1,a1,0x3
    800019dc:	032585b3          	mul	a1,a1,s2
    800019e0:	2585                	addiw	a1,a1,1
    800019e2:	00d5959b          	slliw	a1,a1,0xd
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800019e6:	875e                	mv	a4,s7
    800019e8:	86da                	mv	a3,s6
    800019ea:	40b985b3          	sub	a1,s3,a1
    800019ee:	8552                	mv	a0,s4
    800019f0:	fffff097          	auipc	ra,0xfffff
    800019f4:	7d0080e7          	jalr	2000(ra) # 800011c0 <kvmmap>
    for (p = proc; p < &proc[NPROC]; p++)
    800019f8:	16848493          	addi	s1,s1,360
    800019fc:	fd5497e3          	bne	s1,s5,800019ca <proc_mapstacks+0x4c>
}
    80001a00:	60a6                	ld	ra,72(sp)
    80001a02:	6406                	ld	s0,64(sp)
    80001a04:	74e2                	ld	s1,56(sp)
    80001a06:	7942                	ld	s2,48(sp)
    80001a08:	79a2                	ld	s3,40(sp)
    80001a0a:	7a02                	ld	s4,32(sp)
    80001a0c:	6ae2                	ld	s5,24(sp)
    80001a0e:	6b42                	ld	s6,16(sp)
    80001a10:	6ba2                	ld	s7,8(sp)
    80001a12:	6c02                	ld	s8,0(sp)
    80001a14:	6161                	addi	sp,sp,80
    80001a16:	8082                	ret
            panic("kalloc");
    80001a18:	00006517          	auipc	a0,0x6
    80001a1c:	7a050513          	addi	a0,a0,1952 # 800081b8 <etext+0x1b8>
    80001a20:	fffff097          	auipc	ra,0xfffff
    80001a24:	b40080e7          	jalr	-1216(ra) # 80000560 <panic>

0000000080001a28 <procinit>:
{
    80001a28:	7139                	addi	sp,sp,-64
    80001a2a:	fc06                	sd	ra,56(sp)
    80001a2c:	f822                	sd	s0,48(sp)
    80001a2e:	f426                	sd	s1,40(sp)
    80001a30:	f04a                	sd	s2,32(sp)
    80001a32:	ec4e                	sd	s3,24(sp)
    80001a34:	e852                	sd	s4,16(sp)
    80001a36:	e456                	sd	s5,8(sp)
    80001a38:	e05a                	sd	s6,0(sp)
    80001a3a:	0080                	addi	s0,sp,64
    initlock(&pid_lock, "nextpid");
    80001a3c:	00006597          	auipc	a1,0x6
    80001a40:	78458593          	addi	a1,a1,1924 # 800081c0 <etext+0x1c0>
    80001a44:	0000f517          	auipc	a0,0xf
    80001a48:	61c50513          	addi	a0,a0,1564 # 80011060 <pid_lock>
    80001a4c:	fffff097          	auipc	ra,0xfffff
    80001a50:	15e080e7          	jalr	350(ra) # 80000baa <initlock>
    initlock(&wait_lock, "wait_lock");
    80001a54:	00006597          	auipc	a1,0x6
    80001a58:	77458593          	addi	a1,a1,1908 # 800081c8 <etext+0x1c8>
    80001a5c:	0000f517          	auipc	a0,0xf
    80001a60:	61c50513          	addi	a0,a0,1564 # 80011078 <wait_lock>
    80001a64:	fffff097          	auipc	ra,0xfffff
    80001a68:	146080e7          	jalr	326(ra) # 80000baa <initlock>
    for (p = proc; p < &proc[NPROC]; p++)
    80001a6c:	0000f497          	auipc	s1,0xf
    80001a70:	62448493          	addi	s1,s1,1572 # 80011090 <proc>
        initlock(&p->lock, "proc");
    80001a74:	00006b17          	auipc	s6,0x6
    80001a78:	764b0b13          	addi	s6,s6,1892 # 800081d8 <etext+0x1d8>
        p->kstack = KSTACK((int)(p - proc));
    80001a7c:	8aa6                	mv	s5,s1
    80001a7e:	a4fa57b7          	lui	a5,0xa4fa5
    80001a82:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff24f83135>
    80001a86:	4fa50937          	lui	s2,0x4fa50
    80001a8a:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x305b05b0>
    80001a8e:	1902                	slli	s2,s2,0x20
    80001a90:	993e                	add	s2,s2,a5
    80001a92:	040009b7          	lui	s3,0x4000
    80001a96:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001a98:	09b2                	slli	s3,s3,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    80001a9a:	00015a17          	auipc	s4,0x15
    80001a9e:	ff6a0a13          	addi	s4,s4,-10 # 80016a90 <tickslock>
        initlock(&p->lock, "proc");
    80001aa2:	85da                	mv	a1,s6
    80001aa4:	8526                	mv	a0,s1
    80001aa6:	fffff097          	auipc	ra,0xfffff
    80001aaa:	104080e7          	jalr	260(ra) # 80000baa <initlock>
        p->state = UNUSED;
    80001aae:	0004ac23          	sw	zero,24(s1)
        p->kstack = KSTACK((int)(p - proc));
    80001ab2:	415487b3          	sub	a5,s1,s5
    80001ab6:	878d                	srai	a5,a5,0x3
    80001ab8:	032787b3          	mul	a5,a5,s2
    80001abc:	2785                	addiw	a5,a5,1
    80001abe:	00d7979b          	slliw	a5,a5,0xd
    80001ac2:	40f987b3          	sub	a5,s3,a5
    80001ac6:	e0bc                	sd	a5,64(s1)
    for (p = proc; p < &proc[NPROC]; p++)
    80001ac8:	16848493          	addi	s1,s1,360
    80001acc:	fd449be3          	bne	s1,s4,80001aa2 <procinit+0x7a>
}
    80001ad0:	70e2                	ld	ra,56(sp)
    80001ad2:	7442                	ld	s0,48(sp)
    80001ad4:	74a2                	ld	s1,40(sp)
    80001ad6:	7902                	ld	s2,32(sp)
    80001ad8:	69e2                	ld	s3,24(sp)
    80001ada:	6a42                	ld	s4,16(sp)
    80001adc:	6aa2                	ld	s5,8(sp)
    80001ade:	6b02                	ld	s6,0(sp)
    80001ae0:	6121                	addi	sp,sp,64
    80001ae2:	8082                	ret

0000000080001ae4 <copy_array>:
{
    80001ae4:	1141                	addi	sp,sp,-16
    80001ae6:	e406                	sd	ra,8(sp)
    80001ae8:	e022                	sd	s0,0(sp)
    80001aea:	0800                	addi	s0,sp,16
    for (int i = 0; i < len; i++)
    80001aec:	00c05c63          	blez	a2,80001b04 <copy_array+0x20>
    80001af0:	87aa                	mv	a5,a0
    80001af2:	9532                	add	a0,a0,a2
        dst[i] = src[i];
    80001af4:	0007c703          	lbu	a4,0(a5)
    80001af8:	00e58023          	sb	a4,0(a1)
    for (int i = 0; i < len; i++)
    80001afc:	0785                	addi	a5,a5,1
    80001afe:	0585                	addi	a1,a1,1
    80001b00:	fea79ae3          	bne	a5,a0,80001af4 <copy_array+0x10>
}
    80001b04:	60a2                	ld	ra,8(sp)
    80001b06:	6402                	ld	s0,0(sp)
    80001b08:	0141                	addi	sp,sp,16
    80001b0a:	8082                	ret

0000000080001b0c <cpuid>:
{
    80001b0c:	1141                	addi	sp,sp,-16
    80001b0e:	e406                	sd	ra,8(sp)
    80001b10:	e022                	sd	s0,0(sp)
    80001b12:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b14:	8512                	mv	a0,tp
}
    80001b16:	2501                	sext.w	a0,a0
    80001b18:	60a2                	ld	ra,8(sp)
    80001b1a:	6402                	ld	s0,0(sp)
    80001b1c:	0141                	addi	sp,sp,16
    80001b1e:	8082                	ret

0000000080001b20 <mycpu>:
{
    80001b20:	1141                	addi	sp,sp,-16
    80001b22:	e406                	sd	ra,8(sp)
    80001b24:	e022                	sd	s0,0(sp)
    80001b26:	0800                	addi	s0,sp,16
    80001b28:	8792                	mv	a5,tp
    struct cpu *c = &cpus[id];
    80001b2a:	2781                	sext.w	a5,a5
    80001b2c:	079e                	slli	a5,a5,0x7
}
    80001b2e:	0000f517          	auipc	a0,0xf
    80001b32:	13250513          	addi	a0,a0,306 # 80010c60 <cpus>
    80001b36:	953e                	add	a0,a0,a5
    80001b38:	60a2                	ld	ra,8(sp)
    80001b3a:	6402                	ld	s0,0(sp)
    80001b3c:	0141                	addi	sp,sp,16
    80001b3e:	8082                	ret

0000000080001b40 <myproc>:
{
    80001b40:	1101                	addi	sp,sp,-32
    80001b42:	ec06                	sd	ra,24(sp)
    80001b44:	e822                	sd	s0,16(sp)
    80001b46:	e426                	sd	s1,8(sp)
    80001b48:	1000                	addi	s0,sp,32
    push_off();
    80001b4a:	fffff097          	auipc	ra,0xfffff
    80001b4e:	0a8080e7          	jalr	168(ra) # 80000bf2 <push_off>
    80001b52:	8792                	mv	a5,tp
    struct proc *p = c->proc;
    80001b54:	2781                	sext.w	a5,a5
    80001b56:	079e                	slli	a5,a5,0x7
    80001b58:	0000f717          	auipc	a4,0xf
    80001b5c:	10870713          	addi	a4,a4,264 # 80010c60 <cpus>
    80001b60:	97ba                	add	a5,a5,a4
    80001b62:	6384                	ld	s1,0(a5)
    pop_off();
    80001b64:	fffff097          	auipc	ra,0xfffff
    80001b68:	12e080e7          	jalr	302(ra) # 80000c92 <pop_off>
}
    80001b6c:	8526                	mv	a0,s1
    80001b6e:	60e2                	ld	ra,24(sp)
    80001b70:	6442                	ld	s0,16(sp)
    80001b72:	64a2                	ld	s1,8(sp)
    80001b74:	6105                	addi	sp,sp,32
    80001b76:	8082                	ret

0000000080001b78 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80001b78:	1141                	addi	sp,sp,-16
    80001b7a:	e406                	sd	ra,8(sp)
    80001b7c:	e022                	sd	s0,0(sp)
    80001b7e:	0800                	addi	s0,sp,16
    static int first = 1;

    // Still holding p->lock from scheduler.
    release(&myproc()->lock);
    80001b80:	00000097          	auipc	ra,0x0
    80001b84:	fc0080e7          	jalr	-64(ra) # 80001b40 <myproc>
    80001b88:	fffff097          	auipc	ra,0xfffff
    80001b8c:	166080e7          	jalr	358(ra) # 80000cee <release>

    if (first)
    80001b90:	00007797          	auipc	a5,0x7
    80001b94:	db07a783          	lw	a5,-592(a5) # 80008940 <first.1>
    80001b98:	eb89                	bnez	a5,80001baa <forkret+0x32>
        // be run from main().
        first = 0;
        fsinit(ROOTDEV);
    }

    usertrapret();
    80001b9a:	00001097          	auipc	ra,0x1
    80001b9e:	e6e080e7          	jalr	-402(ra) # 80002a08 <usertrapret>
}
    80001ba2:	60a2                	ld	ra,8(sp)
    80001ba4:	6402                	ld	s0,0(sp)
    80001ba6:	0141                	addi	sp,sp,16
    80001ba8:	8082                	ret
        first = 0;
    80001baa:	00007797          	auipc	a5,0x7
    80001bae:	d807ab23          	sw	zero,-618(a5) # 80008940 <first.1>
        fsinit(ROOTDEV);
    80001bb2:	4505                	li	a0,1
    80001bb4:	00002097          	auipc	ra,0x2
    80001bb8:	c44080e7          	jalr	-956(ra) # 800037f8 <fsinit>
    80001bbc:	bff9                	j	80001b9a <forkret+0x22>

0000000080001bbe <allocpid>:
{
    80001bbe:	1101                	addi	sp,sp,-32
    80001bc0:	ec06                	sd	ra,24(sp)
    80001bc2:	e822                	sd	s0,16(sp)
    80001bc4:	e426                	sd	s1,8(sp)
    80001bc6:	e04a                	sd	s2,0(sp)
    80001bc8:	1000                	addi	s0,sp,32
    acquire(&pid_lock);
    80001bca:	0000f917          	auipc	s2,0xf
    80001bce:	49690913          	addi	s2,s2,1174 # 80011060 <pid_lock>
    80001bd2:	854a                	mv	a0,s2
    80001bd4:	fffff097          	auipc	ra,0xfffff
    80001bd8:	06a080e7          	jalr	106(ra) # 80000c3e <acquire>
    pid = nextpid;
    80001bdc:	00007797          	auipc	a5,0x7
    80001be0:	d7478793          	addi	a5,a5,-652 # 80008950 <nextpid>
    80001be4:	4384                	lw	s1,0(a5)
    nextpid = nextpid + 1;
    80001be6:	0014871b          	addiw	a4,s1,1
    80001bea:	c398                	sw	a4,0(a5)
    release(&pid_lock);
    80001bec:	854a                	mv	a0,s2
    80001bee:	fffff097          	auipc	ra,0xfffff
    80001bf2:	100080e7          	jalr	256(ra) # 80000cee <release>
}
    80001bf6:	8526                	mv	a0,s1
    80001bf8:	60e2                	ld	ra,24(sp)
    80001bfa:	6442                	ld	s0,16(sp)
    80001bfc:	64a2                	ld	s1,8(sp)
    80001bfe:	6902                	ld	s2,0(sp)
    80001c00:	6105                	addi	sp,sp,32
    80001c02:	8082                	ret

0000000080001c04 <proc_pagetable>:
{
    80001c04:	1101                	addi	sp,sp,-32
    80001c06:	ec06                	sd	ra,24(sp)
    80001c08:	e822                	sd	s0,16(sp)
    80001c0a:	e426                	sd	s1,8(sp)
    80001c0c:	e04a                	sd	s2,0(sp)
    80001c0e:	1000                	addi	s0,sp,32
    80001c10:	892a                	mv	s2,a0
    pagetable = uvmcreate();
    80001c12:	fffff097          	auipc	ra,0xfffff
    80001c16:	7a2080e7          	jalr	1954(ra) # 800013b4 <uvmcreate>
    80001c1a:	84aa                	mv	s1,a0
    if (pagetable == 0)
    80001c1c:	c121                	beqz	a0,80001c5c <proc_pagetable+0x58>
    if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001c1e:	4729                	li	a4,10
    80001c20:	00005697          	auipc	a3,0x5
    80001c24:	3e068693          	addi	a3,a3,992 # 80007000 <_trampoline>
    80001c28:	6605                	lui	a2,0x1
    80001c2a:	040005b7          	lui	a1,0x4000
    80001c2e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001c30:	05b2                	slli	a1,a1,0xc
    80001c32:	fffff097          	auipc	ra,0xfffff
    80001c36:	4e8080e7          	jalr	1256(ra) # 8000111a <mappages>
    80001c3a:	02054863          	bltz	a0,80001c6a <proc_pagetable+0x66>
    if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80001c3e:	4719                	li	a4,6
    80001c40:	05893683          	ld	a3,88(s2)
    80001c44:	6605                	lui	a2,0x1
    80001c46:	020005b7          	lui	a1,0x2000
    80001c4a:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001c4c:	05b6                	slli	a1,a1,0xd
    80001c4e:	8526                	mv	a0,s1
    80001c50:	fffff097          	auipc	ra,0xfffff
    80001c54:	4ca080e7          	jalr	1226(ra) # 8000111a <mappages>
    80001c58:	02054163          	bltz	a0,80001c7a <proc_pagetable+0x76>
}
    80001c5c:	8526                	mv	a0,s1
    80001c5e:	60e2                	ld	ra,24(sp)
    80001c60:	6442                	ld	s0,16(sp)
    80001c62:	64a2                	ld	s1,8(sp)
    80001c64:	6902                	ld	s2,0(sp)
    80001c66:	6105                	addi	sp,sp,32
    80001c68:	8082                	ret
        uvmfree(pagetable, 0);
    80001c6a:	4581                	li	a1,0
    80001c6c:	8526                	mv	a0,s1
    80001c6e:	00000097          	auipc	ra,0x0
    80001c72:	960080e7          	jalr	-1696(ra) # 800015ce <uvmfree>
        return 0;
    80001c76:	4481                	li	s1,0
    80001c78:	b7d5                	j	80001c5c <proc_pagetable+0x58>
        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001c7a:	4681                	li	a3,0
    80001c7c:	4605                	li	a2,1
    80001c7e:	040005b7          	lui	a1,0x4000
    80001c82:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001c84:	05b2                	slli	a1,a1,0xc
    80001c86:	8526                	mv	a0,s1
    80001c88:	fffff097          	auipc	ra,0xfffff
    80001c8c:	658080e7          	jalr	1624(ra) # 800012e0 <uvmunmap>
        uvmfree(pagetable, 0);
    80001c90:	4581                	li	a1,0
    80001c92:	8526                	mv	a0,s1
    80001c94:	00000097          	auipc	ra,0x0
    80001c98:	93a080e7          	jalr	-1734(ra) # 800015ce <uvmfree>
        return 0;
    80001c9c:	4481                	li	s1,0
    80001c9e:	bf7d                	j	80001c5c <proc_pagetable+0x58>

0000000080001ca0 <proc_freepagetable>:
{
    80001ca0:	1101                	addi	sp,sp,-32
    80001ca2:	ec06                	sd	ra,24(sp)
    80001ca4:	e822                	sd	s0,16(sp)
    80001ca6:	e426                	sd	s1,8(sp)
    80001ca8:	e04a                	sd	s2,0(sp)
    80001caa:	1000                	addi	s0,sp,32
    80001cac:	84aa                	mv	s1,a0
    80001cae:	892e                	mv	s2,a1
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001cb0:	4681                	li	a3,0
    80001cb2:	4605                	li	a2,1
    80001cb4:	040005b7          	lui	a1,0x4000
    80001cb8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001cba:	05b2                	slli	a1,a1,0xc
    80001cbc:	fffff097          	auipc	ra,0xfffff
    80001cc0:	624080e7          	jalr	1572(ra) # 800012e0 <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001cc4:	4681                	li	a3,0
    80001cc6:	4605                	li	a2,1
    80001cc8:	020005b7          	lui	a1,0x2000
    80001ccc:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001cce:	05b6                	slli	a1,a1,0xd
    80001cd0:	8526                	mv	a0,s1
    80001cd2:	fffff097          	auipc	ra,0xfffff
    80001cd6:	60e080e7          	jalr	1550(ra) # 800012e0 <uvmunmap>
    uvmfree(pagetable, sz);
    80001cda:	85ca                	mv	a1,s2
    80001cdc:	8526                	mv	a0,s1
    80001cde:	00000097          	auipc	ra,0x0
    80001ce2:	8f0080e7          	jalr	-1808(ra) # 800015ce <uvmfree>
}
    80001ce6:	60e2                	ld	ra,24(sp)
    80001ce8:	6442                	ld	s0,16(sp)
    80001cea:	64a2                	ld	s1,8(sp)
    80001cec:	6902                	ld	s2,0(sp)
    80001cee:	6105                	addi	sp,sp,32
    80001cf0:	8082                	ret

0000000080001cf2 <freeproc>:
{
    80001cf2:	1101                	addi	sp,sp,-32
    80001cf4:	ec06                	sd	ra,24(sp)
    80001cf6:	e822                	sd	s0,16(sp)
    80001cf8:	e426                	sd	s1,8(sp)
    80001cfa:	1000                	addi	s0,sp,32
    80001cfc:	84aa                	mv	s1,a0
    if (p->trapframe)
    80001cfe:	6d28                	ld	a0,88(a0)
    80001d00:	c509                	beqz	a0,80001d0a <freeproc+0x18>
        kfree((void *)p->trapframe);
    80001d02:	fffff097          	auipc	ra,0xfffff
    80001d06:	d4a080e7          	jalr	-694(ra) # 80000a4c <kfree>
    p->trapframe = 0;
    80001d0a:	0404bc23          	sd	zero,88(s1)
    if (p->pagetable)
    80001d0e:	68a8                	ld	a0,80(s1)
    80001d10:	c511                	beqz	a0,80001d1c <freeproc+0x2a>
        proc_freepagetable(p->pagetable, p->sz);
    80001d12:	64ac                	ld	a1,72(s1)
    80001d14:	00000097          	auipc	ra,0x0
    80001d18:	f8c080e7          	jalr	-116(ra) # 80001ca0 <proc_freepagetable>
    p->pagetable = 0;
    80001d1c:	0404b823          	sd	zero,80(s1)
    p->sz = 0;
    80001d20:	0404b423          	sd	zero,72(s1)
    p->pid = 0;
    80001d24:	0204a823          	sw	zero,48(s1)
    p->parent = 0;
    80001d28:	0204bc23          	sd	zero,56(s1)
    p->name[0] = 0;
    80001d2c:	14048c23          	sb	zero,344(s1)
    p->chan = 0;
    80001d30:	0204b023          	sd	zero,32(s1)
    p->killed = 0;
    80001d34:	0204a423          	sw	zero,40(s1)
    p->xstate = 0;
    80001d38:	0204a623          	sw	zero,44(s1)
    p->state = UNUSED;
    80001d3c:	0004ac23          	sw	zero,24(s1)
}
    80001d40:	60e2                	ld	ra,24(sp)
    80001d42:	6442                	ld	s0,16(sp)
    80001d44:	64a2                	ld	s1,8(sp)
    80001d46:	6105                	addi	sp,sp,32
    80001d48:	8082                	ret

0000000080001d4a <allocproc>:
{
    80001d4a:	1101                	addi	sp,sp,-32
    80001d4c:	ec06                	sd	ra,24(sp)
    80001d4e:	e822                	sd	s0,16(sp)
    80001d50:	e426                	sd	s1,8(sp)
    80001d52:	e04a                	sd	s2,0(sp)
    80001d54:	1000                	addi	s0,sp,32
    for (p = proc; p < &proc[NPROC]; p++)
    80001d56:	0000f497          	auipc	s1,0xf
    80001d5a:	33a48493          	addi	s1,s1,826 # 80011090 <proc>
    80001d5e:	00015917          	auipc	s2,0x15
    80001d62:	d3290913          	addi	s2,s2,-718 # 80016a90 <tickslock>
        acquire(&p->lock);
    80001d66:	8526                	mv	a0,s1
    80001d68:	fffff097          	auipc	ra,0xfffff
    80001d6c:	ed6080e7          	jalr	-298(ra) # 80000c3e <acquire>
        if (p->state == UNUSED)
    80001d70:	4c9c                	lw	a5,24(s1)
    80001d72:	cf81                	beqz	a5,80001d8a <allocproc+0x40>
            release(&p->lock);
    80001d74:	8526                	mv	a0,s1
    80001d76:	fffff097          	auipc	ra,0xfffff
    80001d7a:	f78080e7          	jalr	-136(ra) # 80000cee <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80001d7e:	16848493          	addi	s1,s1,360
    80001d82:	ff2492e3          	bne	s1,s2,80001d66 <allocproc+0x1c>
    return 0;
    80001d86:	4481                	li	s1,0
    80001d88:	a889                	j	80001dda <allocproc+0x90>
    p->pid = allocpid();
    80001d8a:	00000097          	auipc	ra,0x0
    80001d8e:	e34080e7          	jalr	-460(ra) # 80001bbe <allocpid>
    80001d92:	d888                	sw	a0,48(s1)
    p->state = USED;
    80001d94:	4785                	li	a5,1
    80001d96:	cc9c                	sw	a5,24(s1)
    if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    80001d98:	fffff097          	auipc	ra,0xfffff
    80001d9c:	db2080e7          	jalr	-590(ra) # 80000b4a <kalloc>
    80001da0:	892a                	mv	s2,a0
    80001da2:	eca8                	sd	a0,88(s1)
    80001da4:	c131                	beqz	a0,80001de8 <allocproc+0x9e>
    p->pagetable = proc_pagetable(p);
    80001da6:	8526                	mv	a0,s1
    80001da8:	00000097          	auipc	ra,0x0
    80001dac:	e5c080e7          	jalr	-420(ra) # 80001c04 <proc_pagetable>
    80001db0:	892a                	mv	s2,a0
    80001db2:	e8a8                	sd	a0,80(s1)
    if (p->pagetable == 0)
    80001db4:	c531                	beqz	a0,80001e00 <allocproc+0xb6>
    memset(&p->context, 0, sizeof(p->context));
    80001db6:	07000613          	li	a2,112
    80001dba:	4581                	li	a1,0
    80001dbc:	06048513          	addi	a0,s1,96
    80001dc0:	fffff097          	auipc	ra,0xfffff
    80001dc4:	f76080e7          	jalr	-138(ra) # 80000d36 <memset>
    p->context.ra = (uint64)forkret;
    80001dc8:	00000797          	auipc	a5,0x0
    80001dcc:	db078793          	addi	a5,a5,-592 # 80001b78 <forkret>
    80001dd0:	f0bc                	sd	a5,96(s1)
    p->context.sp = p->kstack + PGSIZE;
    80001dd2:	60bc                	ld	a5,64(s1)
    80001dd4:	6705                	lui	a4,0x1
    80001dd6:	97ba                	add	a5,a5,a4
    80001dd8:	f4bc                	sd	a5,104(s1)
}
    80001dda:	8526                	mv	a0,s1
    80001ddc:	60e2                	ld	ra,24(sp)
    80001dde:	6442                	ld	s0,16(sp)
    80001de0:	64a2                	ld	s1,8(sp)
    80001de2:	6902                	ld	s2,0(sp)
    80001de4:	6105                	addi	sp,sp,32
    80001de6:	8082                	ret
        freeproc(p);
    80001de8:	8526                	mv	a0,s1
    80001dea:	00000097          	auipc	ra,0x0
    80001dee:	f08080e7          	jalr	-248(ra) # 80001cf2 <freeproc>
        release(&p->lock);
    80001df2:	8526                	mv	a0,s1
    80001df4:	fffff097          	auipc	ra,0xfffff
    80001df8:	efa080e7          	jalr	-262(ra) # 80000cee <release>
        return 0;
    80001dfc:	84ca                	mv	s1,s2
    80001dfe:	bff1                	j	80001dda <allocproc+0x90>
        freeproc(p);
    80001e00:	8526                	mv	a0,s1
    80001e02:	00000097          	auipc	ra,0x0
    80001e06:	ef0080e7          	jalr	-272(ra) # 80001cf2 <freeproc>
        release(&p->lock);
    80001e0a:	8526                	mv	a0,s1
    80001e0c:	fffff097          	auipc	ra,0xfffff
    80001e10:	ee2080e7          	jalr	-286(ra) # 80000cee <release>
        return 0;
    80001e14:	84ca                	mv	s1,s2
    80001e16:	b7d1                	j	80001dda <allocproc+0x90>

0000000080001e18 <userinit>:
{
    80001e18:	1101                	addi	sp,sp,-32
    80001e1a:	ec06                	sd	ra,24(sp)
    80001e1c:	e822                	sd	s0,16(sp)
    80001e1e:	e426                	sd	s1,8(sp)
    80001e20:	1000                	addi	s0,sp,32
    p = allocproc();
    80001e22:	00000097          	auipc	ra,0x0
    80001e26:	f28080e7          	jalr	-216(ra) # 80001d4a <allocproc>
    80001e2a:	84aa                	mv	s1,a0
    initproc = p;
    80001e2c:	00007797          	auipc	a5,0x7
    80001e30:	baa7be23          	sd	a0,-1092(a5) # 800089e8 <initproc>
    uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001e34:	03400613          	li	a2,52
    80001e38:	00007597          	auipc	a1,0x7
    80001e3c:	b2858593          	addi	a1,a1,-1240 # 80008960 <initcode>
    80001e40:	6928                	ld	a0,80(a0)
    80001e42:	fffff097          	auipc	ra,0xfffff
    80001e46:	5a0080e7          	jalr	1440(ra) # 800013e2 <uvmfirst>
    p->sz = PGSIZE;
    80001e4a:	6785                	lui	a5,0x1
    80001e4c:	e4bc                	sd	a5,72(s1)
    p->trapframe->epc = 0;     // user program counter
    80001e4e:	6cb8                	ld	a4,88(s1)
    80001e50:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    p->trapframe->sp = PGSIZE; // user stack pointer
    80001e54:	6cb8                	ld	a4,88(s1)
    80001e56:	fb1c                	sd	a5,48(a4)
    safestrcpy(p->name, "initcode", sizeof(p->name));
    80001e58:	4641                	li	a2,16
    80001e5a:	00006597          	auipc	a1,0x6
    80001e5e:	38658593          	addi	a1,a1,902 # 800081e0 <etext+0x1e0>
    80001e62:	15848513          	addi	a0,s1,344
    80001e66:	fffff097          	auipc	ra,0xfffff
    80001e6a:	026080e7          	jalr	38(ra) # 80000e8c <safestrcpy>
    p->cwd = namei("/");
    80001e6e:	00006517          	auipc	a0,0x6
    80001e72:	38250513          	addi	a0,a0,898 # 800081f0 <etext+0x1f0>
    80001e76:	00002097          	auipc	ra,0x2
    80001e7a:	3ea080e7          	jalr	1002(ra) # 80004260 <namei>
    80001e7e:	14a4b823          	sd	a0,336(s1)
    p->state = RUNNABLE;
    80001e82:	478d                	li	a5,3
    80001e84:	cc9c                	sw	a5,24(s1)
    release(&p->lock);
    80001e86:	8526                	mv	a0,s1
    80001e88:	fffff097          	auipc	ra,0xfffff
    80001e8c:	e66080e7          	jalr	-410(ra) # 80000cee <release>
}
    80001e90:	60e2                	ld	ra,24(sp)
    80001e92:	6442                	ld	s0,16(sp)
    80001e94:	64a2                	ld	s1,8(sp)
    80001e96:	6105                	addi	sp,sp,32
    80001e98:	8082                	ret

0000000080001e9a <growproc>:
{
    80001e9a:	1101                	addi	sp,sp,-32
    80001e9c:	ec06                	sd	ra,24(sp)
    80001e9e:	e822                	sd	s0,16(sp)
    80001ea0:	e426                	sd	s1,8(sp)
    80001ea2:	e04a                	sd	s2,0(sp)
    80001ea4:	1000                	addi	s0,sp,32
    80001ea6:	892a                	mv	s2,a0
    struct proc *p = myproc();
    80001ea8:	00000097          	auipc	ra,0x0
    80001eac:	c98080e7          	jalr	-872(ra) # 80001b40 <myproc>
    80001eb0:	84aa                	mv	s1,a0
    sz = p->sz;
    80001eb2:	652c                	ld	a1,72(a0)
    if (n > 0)
    80001eb4:	01204c63          	bgtz	s2,80001ecc <growproc+0x32>
    else if (n < 0)
    80001eb8:	02094663          	bltz	s2,80001ee4 <growproc+0x4a>
    p->sz = sz;
    80001ebc:	e4ac                	sd	a1,72(s1)
    return 0;
    80001ebe:	4501                	li	a0,0
}
    80001ec0:	60e2                	ld	ra,24(sp)
    80001ec2:	6442                	ld	s0,16(sp)
    80001ec4:	64a2                	ld	s1,8(sp)
    80001ec6:	6902                	ld	s2,0(sp)
    80001ec8:	6105                	addi	sp,sp,32
    80001eca:	8082                	ret
        if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    80001ecc:	4691                	li	a3,4
    80001ece:	00b90633          	add	a2,s2,a1
    80001ed2:	6928                	ld	a0,80(a0)
    80001ed4:	fffff097          	auipc	ra,0xfffff
    80001ed8:	5c8080e7          	jalr	1480(ra) # 8000149c <uvmalloc>
    80001edc:	85aa                	mv	a1,a0
    80001ede:	fd79                	bnez	a0,80001ebc <growproc+0x22>
            return -1;
    80001ee0:	557d                	li	a0,-1
    80001ee2:	bff9                	j	80001ec0 <growproc+0x26>
        sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001ee4:	00b90633          	add	a2,s2,a1
    80001ee8:	6928                	ld	a0,80(a0)
    80001eea:	fffff097          	auipc	ra,0xfffff
    80001eee:	56a080e7          	jalr	1386(ra) # 80001454 <uvmdealloc>
    80001ef2:	85aa                	mv	a1,a0
    80001ef4:	b7e1                	j	80001ebc <growproc+0x22>

0000000080001ef6 <ps>:
{
    80001ef6:	711d                	addi	sp,sp,-96
    80001ef8:	ec86                	sd	ra,88(sp)
    80001efa:	e8a2                	sd	s0,80(sp)
    80001efc:	e4a6                	sd	s1,72(sp)
    80001efe:	e0ca                	sd	s2,64(sp)
    80001f00:	fc4e                	sd	s3,56(sp)
    80001f02:	f852                	sd	s4,48(sp)
    80001f04:	f456                	sd	s5,40(sp)
    80001f06:	f05a                	sd	s6,32(sp)
    80001f08:	ec5e                	sd	s7,24(sp)
    80001f0a:	e862                	sd	s8,16(sp)
    80001f0c:	e466                	sd	s9,8(sp)
    80001f0e:	1080                	addi	s0,sp,96
    80001f10:	84aa                	mv	s1,a0
    80001f12:	8a2e                	mv	s4,a1
    void *result = (void *)myproc()->sz;
    80001f14:	00000097          	auipc	ra,0x0
    80001f18:	c2c080e7          	jalr	-980(ra) # 80001b40 <myproc>
        return result;
    80001f1c:	4901                	li	s2,0
    if (count == 0)
    80001f1e:	0c0a0563          	beqz	s4,80001fe8 <ps+0xf2>
    void *result = (void *)myproc()->sz;
    80001f22:	04853b83          	ld	s7,72(a0)
    if (growproc(count * sizeof(struct user_proc)) < 0)
    80001f26:	003a151b          	slliw	a0,s4,0x3
    80001f2a:	0145053b          	addw	a0,a0,s4
    80001f2e:	050a                	slli	a0,a0,0x2
    80001f30:	00000097          	auipc	ra,0x0
    80001f34:	f6a080e7          	jalr	-150(ra) # 80001e9a <growproc>
    80001f38:	14054163          	bltz	a0,8000207a <ps+0x184>
    struct user_proc loc_result[count];
    80001f3c:	003a1a93          	slli	s5,s4,0x3
    80001f40:	9ad2                	add	s5,s5,s4
    80001f42:	0a8a                	slli	s5,s5,0x2
    80001f44:	00fa8793          	addi	a5,s5,15
    80001f48:	8391                	srli	a5,a5,0x4
    80001f4a:	0792                	slli	a5,a5,0x4
    80001f4c:	40f10133          	sub	sp,sp,a5
    80001f50:	8b0a                	mv	s6,sp
    struct proc *p = proc + start;
    80001f52:	16800793          	li	a5,360
    80001f56:	02f484b3          	mul	s1,s1,a5
    80001f5a:	0000f797          	auipc	a5,0xf
    80001f5e:	13678793          	addi	a5,a5,310 # 80011090 <proc>
    80001f62:	94be                	add	s1,s1,a5
    if (p >= &proc[NPROC])
    80001f64:	00015797          	auipc	a5,0x15
    80001f68:	b2c78793          	addi	a5,a5,-1236 # 80016a90 <tickslock>
        return result;
    80001f6c:	4901                	li	s2,0
    if (p >= &proc[NPROC])
    80001f6e:	06f4fd63          	bgeu	s1,a5,80001fe8 <ps+0xf2>
    acquire(&wait_lock);
    80001f72:	0000f517          	auipc	a0,0xf
    80001f76:	10650513          	addi	a0,a0,262 # 80011078 <wait_lock>
    80001f7a:	fffff097          	auipc	ra,0xfffff
    80001f7e:	cc4080e7          	jalr	-828(ra) # 80000c3e <acquire>
    for (; p < &proc[NPROC]; p++)
    80001f82:	01410913          	addi	s2,sp,20
    uint8 localCount = 0;
    80001f86:	4981                	li	s3,0
        copy_array(p->name, loc_result[localCount].name, 16);
    80001f88:	4cc1                	li	s9,16
    for (; p < &proc[NPROC]; p++)
    80001f8a:	00015c17          	auipc	s8,0x15
    80001f8e:	b06c0c13          	addi	s8,s8,-1274 # 80016a90 <tickslock>
    80001f92:	a07d                	j	80002040 <ps+0x14a>
            loc_result[localCount].state = UNUSED;
    80001f94:	00399793          	slli	a5,s3,0x3
    80001f98:	97ce                	add	a5,a5,s3
    80001f9a:	078a                	slli	a5,a5,0x2
    80001f9c:	97da                	add	a5,a5,s6
    80001f9e:	0007a023          	sw	zero,0(a5)
            release(&p->lock);
    80001fa2:	8526                	mv	a0,s1
    80001fa4:	fffff097          	auipc	ra,0xfffff
    80001fa8:	d4a080e7          	jalr	-694(ra) # 80000cee <release>
    release(&wait_lock);
    80001fac:	0000f517          	auipc	a0,0xf
    80001fb0:	0cc50513          	addi	a0,a0,204 # 80011078 <wait_lock>
    80001fb4:	fffff097          	auipc	ra,0xfffff
    80001fb8:	d3a080e7          	jalr	-710(ra) # 80000cee <release>
    if (localCount < count)
    80001fbc:	0149f963          	bgeu	s3,s4,80001fce <ps+0xd8>
        loc_result[localCount].state = UNUSED; // if we reach the end of processes
    80001fc0:	00399793          	slli	a5,s3,0x3
    80001fc4:	97ce                	add	a5,a5,s3
    80001fc6:	078a                	slli	a5,a5,0x2
    80001fc8:	97da                	add	a5,a5,s6
    80001fca:	0007a023          	sw	zero,0(a5)
    void *result = (void *)myproc()->sz;
    80001fce:	895e                	mv	s2,s7
    copyout(myproc()->pagetable, (uint64)result, (void *)loc_result, count * sizeof(struct user_proc));
    80001fd0:	00000097          	auipc	ra,0x0
    80001fd4:	b70080e7          	jalr	-1168(ra) # 80001b40 <myproc>
    80001fd8:	86d6                	mv	a3,s5
    80001fda:	865a                	mv	a2,s6
    80001fdc:	85de                	mv	a1,s7
    80001fde:	6928                	ld	a0,80(a0)
    80001fe0:	fffff097          	auipc	ra,0xfffff
    80001fe4:	730080e7          	jalr	1840(ra) # 80001710 <copyout>
}
    80001fe8:	854a                	mv	a0,s2
    80001fea:	fa040113          	addi	sp,s0,-96
    80001fee:	60e6                	ld	ra,88(sp)
    80001ff0:	6446                	ld	s0,80(sp)
    80001ff2:	64a6                	ld	s1,72(sp)
    80001ff4:	6906                	ld	s2,64(sp)
    80001ff6:	79e2                	ld	s3,56(sp)
    80001ff8:	7a42                	ld	s4,48(sp)
    80001ffa:	7aa2                	ld	s5,40(sp)
    80001ffc:	7b02                	ld	s6,32(sp)
    80001ffe:	6be2                	ld	s7,24(sp)
    80002000:	6c42                	ld	s8,16(sp)
    80002002:	6ca2                	ld	s9,8(sp)
    80002004:	6125                	addi	sp,sp,96
    80002006:	8082                	ret
            acquire(&p->parent->lock);
    80002008:	fffff097          	auipc	ra,0xfffff
    8000200c:	c36080e7          	jalr	-970(ra) # 80000c3e <acquire>
            loc_result[localCount].parent_id = p->parent->pid;
    80002010:	7c88                	ld	a0,56(s1)
    80002012:	591c                	lw	a5,48(a0)
    80002014:	fef92e23          	sw	a5,-4(s2)
            release(&p->parent->lock);
    80002018:	fffff097          	auipc	ra,0xfffff
    8000201c:	cd6080e7          	jalr	-810(ra) # 80000cee <release>
        release(&p->lock);
    80002020:	8526                	mv	a0,s1
    80002022:	fffff097          	auipc	ra,0xfffff
    80002026:	ccc080e7          	jalr	-820(ra) # 80000cee <release>
        localCount++;
    8000202a:	2985                	addiw	s3,s3,1
    8000202c:	0ff9f993          	zext.b	s3,s3
    for (; p < &proc[NPROC]; p++)
    80002030:	16848493          	addi	s1,s1,360
    80002034:	f784fce3          	bgeu	s1,s8,80001fac <ps+0xb6>
        if (localCount == count)
    80002038:	02490913          	addi	s2,s2,36
    8000203c:	053a0163          	beq	s4,s3,8000207e <ps+0x188>
        acquire(&p->lock);
    80002040:	8526                	mv	a0,s1
    80002042:	fffff097          	auipc	ra,0xfffff
    80002046:	bfc080e7          	jalr	-1028(ra) # 80000c3e <acquire>
        if (p->state == UNUSED)
    8000204a:	4c9c                	lw	a5,24(s1)
    8000204c:	d7a1                	beqz	a5,80001f94 <ps+0x9e>
        loc_result[localCount].state = p->state;
    8000204e:	fef92623          	sw	a5,-20(s2)
        loc_result[localCount].killed = p->killed;
    80002052:	549c                	lw	a5,40(s1)
    80002054:	fef92823          	sw	a5,-16(s2)
        loc_result[localCount].xstate = p->xstate;
    80002058:	54dc                	lw	a5,44(s1)
    8000205a:	fef92a23          	sw	a5,-12(s2)
        loc_result[localCount].pid = p->pid;
    8000205e:	589c                	lw	a5,48(s1)
    80002060:	fef92c23          	sw	a5,-8(s2)
        copy_array(p->name, loc_result[localCount].name, 16);
    80002064:	8666                	mv	a2,s9
    80002066:	85ca                	mv	a1,s2
    80002068:	15848513          	addi	a0,s1,344
    8000206c:	00000097          	auipc	ra,0x0
    80002070:	a78080e7          	jalr	-1416(ra) # 80001ae4 <copy_array>
        if (p->parent != 0) // init
    80002074:	7c88                	ld	a0,56(s1)
    80002076:	f949                	bnez	a0,80002008 <ps+0x112>
    80002078:	b765                	j	80002020 <ps+0x12a>
        return result;
    8000207a:	4901                	li	s2,0
    8000207c:	b7b5                	j	80001fe8 <ps+0xf2>
    release(&wait_lock);
    8000207e:	0000f517          	auipc	a0,0xf
    80002082:	ffa50513          	addi	a0,a0,-6 # 80011078 <wait_lock>
    80002086:	fffff097          	auipc	ra,0xfffff
    8000208a:	c68080e7          	jalr	-920(ra) # 80000cee <release>
    if (localCount < count)
    8000208e:	b781                	j	80001fce <ps+0xd8>

0000000080002090 <fork>:
{
    80002090:	7139                	addi	sp,sp,-64
    80002092:	fc06                	sd	ra,56(sp)
    80002094:	f822                	sd	s0,48(sp)
    80002096:	f04a                	sd	s2,32(sp)
    80002098:	e456                	sd	s5,8(sp)
    8000209a:	0080                	addi	s0,sp,64
    struct proc *p = myproc();
    8000209c:	00000097          	auipc	ra,0x0
    800020a0:	aa4080e7          	jalr	-1372(ra) # 80001b40 <myproc>
    800020a4:	8aaa                	mv	s5,a0
    if ((np = allocproc()) == 0)
    800020a6:	00000097          	auipc	ra,0x0
    800020aa:	ca4080e7          	jalr	-860(ra) # 80001d4a <allocproc>
    800020ae:	12050063          	beqz	a0,800021ce <fork+0x13e>
    800020b2:	e852                	sd	s4,16(sp)
    800020b4:	8a2a                	mv	s4,a0
    if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    800020b6:	048ab603          	ld	a2,72(s5)
    800020ba:	692c                	ld	a1,80(a0)
    800020bc:	050ab503          	ld	a0,80(s5)
    800020c0:	fffff097          	auipc	ra,0xfffff
    800020c4:	548080e7          	jalr	1352(ra) # 80001608 <uvmcopy>
    800020c8:	04054a63          	bltz	a0,8000211c <fork+0x8c>
    800020cc:	f426                	sd	s1,40(sp)
    800020ce:	ec4e                	sd	s3,24(sp)
    np->sz = p->sz;
    800020d0:	048ab783          	ld	a5,72(s5)
    800020d4:	04fa3423          	sd	a5,72(s4)
    *(np->trapframe) = *(p->trapframe);
    800020d8:	058ab683          	ld	a3,88(s5)
    800020dc:	87b6                	mv	a5,a3
    800020de:	058a3703          	ld	a4,88(s4)
    800020e2:	12068693          	addi	a3,a3,288
    800020e6:	0007b803          	ld	a6,0(a5)
    800020ea:	6788                	ld	a0,8(a5)
    800020ec:	6b8c                	ld	a1,16(a5)
    800020ee:	6f90                	ld	a2,24(a5)
    800020f0:	01073023          	sd	a6,0(a4)
    800020f4:	e708                	sd	a0,8(a4)
    800020f6:	eb0c                	sd	a1,16(a4)
    800020f8:	ef10                	sd	a2,24(a4)
    800020fa:	02078793          	addi	a5,a5,32
    800020fe:	02070713          	addi	a4,a4,32
    80002102:	fed792e3          	bne	a5,a3,800020e6 <fork+0x56>
    np->trapframe->a0 = 0;
    80002106:	058a3783          	ld	a5,88(s4)
    8000210a:	0607b823          	sd	zero,112(a5)
    for (i = 0; i < NOFILE; i++)
    8000210e:	0d0a8493          	addi	s1,s5,208
    80002112:	0d0a0913          	addi	s2,s4,208
    80002116:	150a8993          	addi	s3,s5,336
    8000211a:	a015                	j	8000213e <fork+0xae>
        freeproc(np);
    8000211c:	8552                	mv	a0,s4
    8000211e:	00000097          	auipc	ra,0x0
    80002122:	bd4080e7          	jalr	-1068(ra) # 80001cf2 <freeproc>
        release(&np->lock);
    80002126:	8552                	mv	a0,s4
    80002128:	fffff097          	auipc	ra,0xfffff
    8000212c:	bc6080e7          	jalr	-1082(ra) # 80000cee <release>
        return -1;
    80002130:	597d                	li	s2,-1
    80002132:	6a42                	ld	s4,16(sp)
    80002134:	a071                	j	800021c0 <fork+0x130>
    for (i = 0; i < NOFILE; i++)
    80002136:	04a1                	addi	s1,s1,8
    80002138:	0921                	addi	s2,s2,8
    8000213a:	01348b63          	beq	s1,s3,80002150 <fork+0xc0>
        if (p->ofile[i])
    8000213e:	6088                	ld	a0,0(s1)
    80002140:	d97d                	beqz	a0,80002136 <fork+0xa6>
            np->ofile[i] = filedup(p->ofile[i]);
    80002142:	00002097          	auipc	ra,0x2
    80002146:	7a2080e7          	jalr	1954(ra) # 800048e4 <filedup>
    8000214a:	00a93023          	sd	a0,0(s2)
    8000214e:	b7e5                	j	80002136 <fork+0xa6>
    np->cwd = idup(p->cwd);
    80002150:	150ab503          	ld	a0,336(s5)
    80002154:	00002097          	auipc	ra,0x2
    80002158:	8ea080e7          	jalr	-1814(ra) # 80003a3e <idup>
    8000215c:	14aa3823          	sd	a0,336(s4)
    safestrcpy(np->name, p->name, sizeof(p->name));
    80002160:	4641                	li	a2,16
    80002162:	158a8593          	addi	a1,s5,344
    80002166:	158a0513          	addi	a0,s4,344
    8000216a:	fffff097          	auipc	ra,0xfffff
    8000216e:	d22080e7          	jalr	-734(ra) # 80000e8c <safestrcpy>
    pid = np->pid;
    80002172:	030a2903          	lw	s2,48(s4)
    release(&np->lock);
    80002176:	8552                	mv	a0,s4
    80002178:	fffff097          	auipc	ra,0xfffff
    8000217c:	b76080e7          	jalr	-1162(ra) # 80000cee <release>
    acquire(&wait_lock);
    80002180:	0000f497          	auipc	s1,0xf
    80002184:	ef848493          	addi	s1,s1,-264 # 80011078 <wait_lock>
    80002188:	8526                	mv	a0,s1
    8000218a:	fffff097          	auipc	ra,0xfffff
    8000218e:	ab4080e7          	jalr	-1356(ra) # 80000c3e <acquire>
    np->parent = p;
    80002192:	035a3c23          	sd	s5,56(s4)
    release(&wait_lock);
    80002196:	8526                	mv	a0,s1
    80002198:	fffff097          	auipc	ra,0xfffff
    8000219c:	b56080e7          	jalr	-1194(ra) # 80000cee <release>
    acquire(&np->lock);
    800021a0:	8552                	mv	a0,s4
    800021a2:	fffff097          	auipc	ra,0xfffff
    800021a6:	a9c080e7          	jalr	-1380(ra) # 80000c3e <acquire>
    np->state = RUNNABLE;
    800021aa:	478d                	li	a5,3
    800021ac:	00fa2c23          	sw	a5,24(s4)
    release(&np->lock);
    800021b0:	8552                	mv	a0,s4
    800021b2:	fffff097          	auipc	ra,0xfffff
    800021b6:	b3c080e7          	jalr	-1220(ra) # 80000cee <release>
    return pid;
    800021ba:	74a2                	ld	s1,40(sp)
    800021bc:	69e2                	ld	s3,24(sp)
    800021be:	6a42                	ld	s4,16(sp)
}
    800021c0:	854a                	mv	a0,s2
    800021c2:	70e2                	ld	ra,56(sp)
    800021c4:	7442                	ld	s0,48(sp)
    800021c6:	7902                	ld	s2,32(sp)
    800021c8:	6aa2                	ld	s5,8(sp)
    800021ca:	6121                	addi	sp,sp,64
    800021cc:	8082                	ret
        return -1;
    800021ce:	597d                	li	s2,-1
    800021d0:	bfc5                	j	800021c0 <fork+0x130>

00000000800021d2 <scheduler>:
{
    800021d2:	1101                	addi	sp,sp,-32
    800021d4:	ec06                	sd	ra,24(sp)
    800021d6:	e822                	sd	s0,16(sp)
    800021d8:	e426                	sd	s1,8(sp)
    800021da:	e04a                	sd	s2,0(sp)
    800021dc:	1000                	addi	s0,sp,32
    void (*old_scheduler)(void) = sched_pointer;
    800021de:	00006797          	auipc	a5,0x6
    800021e2:	76a7b783          	ld	a5,1898(a5) # 80008948 <sched_pointer>
        if (old_scheduler != sched_pointer)
    800021e6:	00006497          	auipc	s1,0x6
    800021ea:	76248493          	addi	s1,s1,1890 # 80008948 <sched_pointer>
            printf("Scheduler switched\n");
    800021ee:	00006917          	auipc	s2,0x6
    800021f2:	00a90913          	addi	s2,s2,10 # 800081f8 <etext+0x1f8>
    800021f6:	a021                	j	800021fe <scheduler+0x2c>
        (*sched_pointer)();
    800021f8:	609c                	ld	a5,0(s1)
    800021fa:	9782                	jalr	a5
        old_scheduler = sched_pointer;
    800021fc:	609c                	ld	a5,0(s1)
        if (old_scheduler != sched_pointer)
    800021fe:	6098                	ld	a4,0(s1)
    80002200:	fef70ce3          	beq	a4,a5,800021f8 <scheduler+0x26>
            printf("Scheduler switched\n");
    80002204:	854a                	mv	a0,s2
    80002206:	ffffe097          	auipc	ra,0xffffe
    8000220a:	3a4080e7          	jalr	932(ra) # 800005aa <printf>
    8000220e:	b7ed                	j	800021f8 <scheduler+0x26>

0000000080002210 <sched>:
{
    80002210:	7179                	addi	sp,sp,-48
    80002212:	f406                	sd	ra,40(sp)
    80002214:	f022                	sd	s0,32(sp)
    80002216:	ec26                	sd	s1,24(sp)
    80002218:	e84a                	sd	s2,16(sp)
    8000221a:	e44e                	sd	s3,8(sp)
    8000221c:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    8000221e:	00000097          	auipc	ra,0x0
    80002222:	922080e7          	jalr	-1758(ra) # 80001b40 <myproc>
    80002226:	84aa                	mv	s1,a0
    if (!holding(&p->lock))
    80002228:	fffff097          	auipc	ra,0xfffff
    8000222c:	99c080e7          	jalr	-1636(ra) # 80000bc4 <holding>
    80002230:	c53d                	beqz	a0,8000229e <sched+0x8e>
    80002232:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    80002234:	2781                	sext.w	a5,a5
    80002236:	079e                	slli	a5,a5,0x7
    80002238:	0000f717          	auipc	a4,0xf
    8000223c:	a2870713          	addi	a4,a4,-1496 # 80010c60 <cpus>
    80002240:	97ba                	add	a5,a5,a4
    80002242:	5fb8                	lw	a4,120(a5)
    80002244:	4785                	li	a5,1
    80002246:	06f71463          	bne	a4,a5,800022ae <sched+0x9e>
    if (p->state == RUNNING)
    8000224a:	4c98                	lw	a4,24(s1)
    8000224c:	4791                	li	a5,4
    8000224e:	06f70863          	beq	a4,a5,800022be <sched+0xae>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002252:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002256:	8b89                	andi	a5,a5,2
    if (intr_get())
    80002258:	ebbd                	bnez	a5,800022ce <sched+0xbe>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000225a:	8792                	mv	a5,tp
    intena = mycpu()->intena;
    8000225c:	0000f917          	auipc	s2,0xf
    80002260:	a0490913          	addi	s2,s2,-1532 # 80010c60 <cpus>
    80002264:	2781                	sext.w	a5,a5
    80002266:	079e                	slli	a5,a5,0x7
    80002268:	97ca                	add	a5,a5,s2
    8000226a:	07c7a983          	lw	s3,124(a5)
    8000226e:	8592                	mv	a1,tp
    swtch(&p->context, &mycpu()->context);
    80002270:	2581                	sext.w	a1,a1
    80002272:	059e                	slli	a1,a1,0x7
    80002274:	05a1                	addi	a1,a1,8
    80002276:	95ca                	add	a1,a1,s2
    80002278:	06048513          	addi	a0,s1,96
    8000227c:	00000097          	auipc	ra,0x0
    80002280:	6de080e7          	jalr	1758(ra) # 8000295a <swtch>
    80002284:	8792                	mv	a5,tp
    mycpu()->intena = intena;
    80002286:	2781                	sext.w	a5,a5
    80002288:	079e                	slli	a5,a5,0x7
    8000228a:	993e                	add	s2,s2,a5
    8000228c:	07392e23          	sw	s3,124(s2)
}
    80002290:	70a2                	ld	ra,40(sp)
    80002292:	7402                	ld	s0,32(sp)
    80002294:	64e2                	ld	s1,24(sp)
    80002296:	6942                	ld	s2,16(sp)
    80002298:	69a2                	ld	s3,8(sp)
    8000229a:	6145                	addi	sp,sp,48
    8000229c:	8082                	ret
        panic("sched p->lock");
    8000229e:	00006517          	auipc	a0,0x6
    800022a2:	f7250513          	addi	a0,a0,-142 # 80008210 <etext+0x210>
    800022a6:	ffffe097          	auipc	ra,0xffffe
    800022aa:	2ba080e7          	jalr	698(ra) # 80000560 <panic>
        panic("sched locks");
    800022ae:	00006517          	auipc	a0,0x6
    800022b2:	f7250513          	addi	a0,a0,-142 # 80008220 <etext+0x220>
    800022b6:	ffffe097          	auipc	ra,0xffffe
    800022ba:	2aa080e7          	jalr	682(ra) # 80000560 <panic>
        panic("sched running");
    800022be:	00006517          	auipc	a0,0x6
    800022c2:	f7250513          	addi	a0,a0,-142 # 80008230 <etext+0x230>
    800022c6:	ffffe097          	auipc	ra,0xffffe
    800022ca:	29a080e7          	jalr	666(ra) # 80000560 <panic>
        panic("sched interruptible");
    800022ce:	00006517          	auipc	a0,0x6
    800022d2:	f7250513          	addi	a0,a0,-142 # 80008240 <etext+0x240>
    800022d6:	ffffe097          	auipc	ra,0xffffe
    800022da:	28a080e7          	jalr	650(ra) # 80000560 <panic>

00000000800022de <yield>:
{
    800022de:	1101                	addi	sp,sp,-32
    800022e0:	ec06                	sd	ra,24(sp)
    800022e2:	e822                	sd	s0,16(sp)
    800022e4:	e426                	sd	s1,8(sp)
    800022e6:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    800022e8:	00000097          	auipc	ra,0x0
    800022ec:	858080e7          	jalr	-1960(ra) # 80001b40 <myproc>
    800022f0:	84aa                	mv	s1,a0
    acquire(&p->lock);
    800022f2:	fffff097          	auipc	ra,0xfffff
    800022f6:	94c080e7          	jalr	-1716(ra) # 80000c3e <acquire>
    p->state = RUNNABLE;
    800022fa:	478d                	li	a5,3
    800022fc:	cc9c                	sw	a5,24(s1)
    sched();
    800022fe:	00000097          	auipc	ra,0x0
    80002302:	f12080e7          	jalr	-238(ra) # 80002210 <sched>
    release(&p->lock);
    80002306:	8526                	mv	a0,s1
    80002308:	fffff097          	auipc	ra,0xfffff
    8000230c:	9e6080e7          	jalr	-1562(ra) # 80000cee <release>
}
    80002310:	60e2                	ld	ra,24(sp)
    80002312:	6442                	ld	s0,16(sp)
    80002314:	64a2                	ld	s1,8(sp)
    80002316:	6105                	addi	sp,sp,32
    80002318:	8082                	ret

000000008000231a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    8000231a:	7179                	addi	sp,sp,-48
    8000231c:	f406                	sd	ra,40(sp)
    8000231e:	f022                	sd	s0,32(sp)
    80002320:	ec26                	sd	s1,24(sp)
    80002322:	e84a                	sd	s2,16(sp)
    80002324:	e44e                	sd	s3,8(sp)
    80002326:	1800                	addi	s0,sp,48
    80002328:	89aa                	mv	s3,a0
    8000232a:	892e                	mv	s2,a1
    struct proc *p = myproc();
    8000232c:	00000097          	auipc	ra,0x0
    80002330:	814080e7          	jalr	-2028(ra) # 80001b40 <myproc>
    80002334:	84aa                	mv	s1,a0
    // Once we hold p->lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup locks p->lock),
    // so it's okay to release lk.

    acquire(&p->lock); // DOC: sleeplock1
    80002336:	fffff097          	auipc	ra,0xfffff
    8000233a:	908080e7          	jalr	-1784(ra) # 80000c3e <acquire>
    release(lk);
    8000233e:	854a                	mv	a0,s2
    80002340:	fffff097          	auipc	ra,0xfffff
    80002344:	9ae080e7          	jalr	-1618(ra) # 80000cee <release>

    // Go to sleep.
    p->chan = chan;
    80002348:	0334b023          	sd	s3,32(s1)
    p->state = SLEEPING;
    8000234c:	4789                	li	a5,2
    8000234e:	cc9c                	sw	a5,24(s1)

    sched();
    80002350:	00000097          	auipc	ra,0x0
    80002354:	ec0080e7          	jalr	-320(ra) # 80002210 <sched>

    // Tidy up.
    p->chan = 0;
    80002358:	0204b023          	sd	zero,32(s1)

    // Reacquire original lock.
    release(&p->lock);
    8000235c:	8526                	mv	a0,s1
    8000235e:	fffff097          	auipc	ra,0xfffff
    80002362:	990080e7          	jalr	-1648(ra) # 80000cee <release>
    acquire(lk);
    80002366:	854a                	mv	a0,s2
    80002368:	fffff097          	auipc	ra,0xfffff
    8000236c:	8d6080e7          	jalr	-1834(ra) # 80000c3e <acquire>
}
    80002370:	70a2                	ld	ra,40(sp)
    80002372:	7402                	ld	s0,32(sp)
    80002374:	64e2                	ld	s1,24(sp)
    80002376:	6942                	ld	s2,16(sp)
    80002378:	69a2                	ld	s3,8(sp)
    8000237a:	6145                	addi	sp,sp,48
    8000237c:	8082                	ret

000000008000237e <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    8000237e:	7139                	addi	sp,sp,-64
    80002380:	fc06                	sd	ra,56(sp)
    80002382:	f822                	sd	s0,48(sp)
    80002384:	f426                	sd	s1,40(sp)
    80002386:	f04a                	sd	s2,32(sp)
    80002388:	ec4e                	sd	s3,24(sp)
    8000238a:	e852                	sd	s4,16(sp)
    8000238c:	e456                	sd	s5,8(sp)
    8000238e:	0080                	addi	s0,sp,64
    80002390:	8a2a                	mv	s4,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    80002392:	0000f497          	auipc	s1,0xf
    80002396:	cfe48493          	addi	s1,s1,-770 # 80011090 <proc>
    {
        if (p != myproc())
        {
            acquire(&p->lock);
            if (p->state == SLEEPING && p->chan == chan)
    8000239a:	4989                	li	s3,2
            {
                p->state = RUNNABLE;
    8000239c:	4a8d                	li	s5,3
    for (p = proc; p < &proc[NPROC]; p++)
    8000239e:	00014917          	auipc	s2,0x14
    800023a2:	6f290913          	addi	s2,s2,1778 # 80016a90 <tickslock>
    800023a6:	a811                	j	800023ba <wakeup+0x3c>
            }
            release(&p->lock);
    800023a8:	8526                	mv	a0,s1
    800023aa:	fffff097          	auipc	ra,0xfffff
    800023ae:	944080e7          	jalr	-1724(ra) # 80000cee <release>
    for (p = proc; p < &proc[NPROC]; p++)
    800023b2:	16848493          	addi	s1,s1,360
    800023b6:	03248663          	beq	s1,s2,800023e2 <wakeup+0x64>
        if (p != myproc())
    800023ba:	fffff097          	auipc	ra,0xfffff
    800023be:	786080e7          	jalr	1926(ra) # 80001b40 <myproc>
    800023c2:	fea488e3          	beq	s1,a0,800023b2 <wakeup+0x34>
            acquire(&p->lock);
    800023c6:	8526                	mv	a0,s1
    800023c8:	fffff097          	auipc	ra,0xfffff
    800023cc:	876080e7          	jalr	-1930(ra) # 80000c3e <acquire>
            if (p->state == SLEEPING && p->chan == chan)
    800023d0:	4c9c                	lw	a5,24(s1)
    800023d2:	fd379be3          	bne	a5,s3,800023a8 <wakeup+0x2a>
    800023d6:	709c                	ld	a5,32(s1)
    800023d8:	fd4798e3          	bne	a5,s4,800023a8 <wakeup+0x2a>
                p->state = RUNNABLE;
    800023dc:	0154ac23          	sw	s5,24(s1)
    800023e0:	b7e1                	j	800023a8 <wakeup+0x2a>
        }
    }
}
    800023e2:	70e2                	ld	ra,56(sp)
    800023e4:	7442                	ld	s0,48(sp)
    800023e6:	74a2                	ld	s1,40(sp)
    800023e8:	7902                	ld	s2,32(sp)
    800023ea:	69e2                	ld	s3,24(sp)
    800023ec:	6a42                	ld	s4,16(sp)
    800023ee:	6aa2                	ld	s5,8(sp)
    800023f0:	6121                	addi	sp,sp,64
    800023f2:	8082                	ret

00000000800023f4 <reparent>:
{
    800023f4:	7179                	addi	sp,sp,-48
    800023f6:	f406                	sd	ra,40(sp)
    800023f8:	f022                	sd	s0,32(sp)
    800023fa:	ec26                	sd	s1,24(sp)
    800023fc:	e84a                	sd	s2,16(sp)
    800023fe:	e44e                	sd	s3,8(sp)
    80002400:	e052                	sd	s4,0(sp)
    80002402:	1800                	addi	s0,sp,48
    80002404:	892a                	mv	s2,a0
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80002406:	0000f497          	auipc	s1,0xf
    8000240a:	c8a48493          	addi	s1,s1,-886 # 80011090 <proc>
            pp->parent = initproc;
    8000240e:	00006a17          	auipc	s4,0x6
    80002412:	5daa0a13          	addi	s4,s4,1498 # 800089e8 <initproc>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80002416:	00014997          	auipc	s3,0x14
    8000241a:	67a98993          	addi	s3,s3,1658 # 80016a90 <tickslock>
    8000241e:	a029                	j	80002428 <reparent+0x34>
    80002420:	16848493          	addi	s1,s1,360
    80002424:	01348d63          	beq	s1,s3,8000243e <reparent+0x4a>
        if (pp->parent == p)
    80002428:	7c9c                	ld	a5,56(s1)
    8000242a:	ff279be3          	bne	a5,s2,80002420 <reparent+0x2c>
            pp->parent = initproc;
    8000242e:	000a3503          	ld	a0,0(s4)
    80002432:	fc88                	sd	a0,56(s1)
            wakeup(initproc);
    80002434:	00000097          	auipc	ra,0x0
    80002438:	f4a080e7          	jalr	-182(ra) # 8000237e <wakeup>
    8000243c:	b7d5                	j	80002420 <reparent+0x2c>
}
    8000243e:	70a2                	ld	ra,40(sp)
    80002440:	7402                	ld	s0,32(sp)
    80002442:	64e2                	ld	s1,24(sp)
    80002444:	6942                	ld	s2,16(sp)
    80002446:	69a2                	ld	s3,8(sp)
    80002448:	6a02                	ld	s4,0(sp)
    8000244a:	6145                	addi	sp,sp,48
    8000244c:	8082                	ret

000000008000244e <exit>:
{
    8000244e:	7179                	addi	sp,sp,-48
    80002450:	f406                	sd	ra,40(sp)
    80002452:	f022                	sd	s0,32(sp)
    80002454:	ec26                	sd	s1,24(sp)
    80002456:	e84a                	sd	s2,16(sp)
    80002458:	e44e                	sd	s3,8(sp)
    8000245a:	e052                	sd	s4,0(sp)
    8000245c:	1800                	addi	s0,sp,48
    8000245e:	8a2a                	mv	s4,a0
    struct proc *p = myproc();
    80002460:	fffff097          	auipc	ra,0xfffff
    80002464:	6e0080e7          	jalr	1760(ra) # 80001b40 <myproc>
    80002468:	89aa                	mv	s3,a0
    if (p == initproc)
    8000246a:	00006797          	auipc	a5,0x6
    8000246e:	57e7b783          	ld	a5,1406(a5) # 800089e8 <initproc>
    80002472:	0d050493          	addi	s1,a0,208
    80002476:	15050913          	addi	s2,a0,336
    8000247a:	00a79d63          	bne	a5,a0,80002494 <exit+0x46>
        panic("init exiting");
    8000247e:	00006517          	auipc	a0,0x6
    80002482:	dda50513          	addi	a0,a0,-550 # 80008258 <etext+0x258>
    80002486:	ffffe097          	auipc	ra,0xffffe
    8000248a:	0da080e7          	jalr	218(ra) # 80000560 <panic>
    for (int fd = 0; fd < NOFILE; fd++)
    8000248e:	04a1                	addi	s1,s1,8
    80002490:	01248b63          	beq	s1,s2,800024a6 <exit+0x58>
        if (p->ofile[fd])
    80002494:	6088                	ld	a0,0(s1)
    80002496:	dd65                	beqz	a0,8000248e <exit+0x40>
            fileclose(f);
    80002498:	00002097          	auipc	ra,0x2
    8000249c:	49e080e7          	jalr	1182(ra) # 80004936 <fileclose>
            p->ofile[fd] = 0;
    800024a0:	0004b023          	sd	zero,0(s1)
    800024a4:	b7ed                	j	8000248e <exit+0x40>
    begin_op();
    800024a6:	00002097          	auipc	ra,0x2
    800024aa:	fc0080e7          	jalr	-64(ra) # 80004466 <begin_op>
    iput(p->cwd);
    800024ae:	1509b503          	ld	a0,336(s3)
    800024b2:	00001097          	auipc	ra,0x1
    800024b6:	788080e7          	jalr	1928(ra) # 80003c3a <iput>
    end_op();
    800024ba:	00002097          	auipc	ra,0x2
    800024be:	026080e7          	jalr	38(ra) # 800044e0 <end_op>
    p->cwd = 0;
    800024c2:	1409b823          	sd	zero,336(s3)
    acquire(&wait_lock);
    800024c6:	0000f497          	auipc	s1,0xf
    800024ca:	bb248493          	addi	s1,s1,-1102 # 80011078 <wait_lock>
    800024ce:	8526                	mv	a0,s1
    800024d0:	ffffe097          	auipc	ra,0xffffe
    800024d4:	76e080e7          	jalr	1902(ra) # 80000c3e <acquire>
    reparent(p);
    800024d8:	854e                	mv	a0,s3
    800024da:	00000097          	auipc	ra,0x0
    800024de:	f1a080e7          	jalr	-230(ra) # 800023f4 <reparent>
    wakeup(p->parent);
    800024e2:	0389b503          	ld	a0,56(s3)
    800024e6:	00000097          	auipc	ra,0x0
    800024ea:	e98080e7          	jalr	-360(ra) # 8000237e <wakeup>
    acquire(&p->lock);
    800024ee:	854e                	mv	a0,s3
    800024f0:	ffffe097          	auipc	ra,0xffffe
    800024f4:	74e080e7          	jalr	1870(ra) # 80000c3e <acquire>
    p->xstate = status;
    800024f8:	0349a623          	sw	s4,44(s3)
    p->state = ZOMBIE;
    800024fc:	4795                	li	a5,5
    800024fe:	00f9ac23          	sw	a5,24(s3)
    release(&wait_lock);
    80002502:	8526                	mv	a0,s1
    80002504:	ffffe097          	auipc	ra,0xffffe
    80002508:	7ea080e7          	jalr	2026(ra) # 80000cee <release>
    sched();
    8000250c:	00000097          	auipc	ra,0x0
    80002510:	d04080e7          	jalr	-764(ra) # 80002210 <sched>
    panic("zombie exit");
    80002514:	00006517          	auipc	a0,0x6
    80002518:	d5450513          	addi	a0,a0,-684 # 80008268 <etext+0x268>
    8000251c:	ffffe097          	auipc	ra,0xffffe
    80002520:	044080e7          	jalr	68(ra) # 80000560 <panic>

0000000080002524 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    80002524:	7179                	addi	sp,sp,-48
    80002526:	f406                	sd	ra,40(sp)
    80002528:	f022                	sd	s0,32(sp)
    8000252a:	ec26                	sd	s1,24(sp)
    8000252c:	e84a                	sd	s2,16(sp)
    8000252e:	e44e                	sd	s3,8(sp)
    80002530:	1800                	addi	s0,sp,48
    80002532:	892a                	mv	s2,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    80002534:	0000f497          	auipc	s1,0xf
    80002538:	b5c48493          	addi	s1,s1,-1188 # 80011090 <proc>
    8000253c:	00014997          	auipc	s3,0x14
    80002540:	55498993          	addi	s3,s3,1364 # 80016a90 <tickslock>
    {
        acquire(&p->lock);
    80002544:	8526                	mv	a0,s1
    80002546:	ffffe097          	auipc	ra,0xffffe
    8000254a:	6f8080e7          	jalr	1784(ra) # 80000c3e <acquire>
        if (p->pid == pid)
    8000254e:	589c                	lw	a5,48(s1)
    80002550:	01278d63          	beq	a5,s2,8000256a <kill+0x46>
                p->state = RUNNABLE;
            }
            release(&p->lock);
            return 0;
        }
        release(&p->lock);
    80002554:	8526                	mv	a0,s1
    80002556:	ffffe097          	auipc	ra,0xffffe
    8000255a:	798080e7          	jalr	1944(ra) # 80000cee <release>
    for (p = proc; p < &proc[NPROC]; p++)
    8000255e:	16848493          	addi	s1,s1,360
    80002562:	ff3491e3          	bne	s1,s3,80002544 <kill+0x20>
    }
    return -1;
    80002566:	557d                	li	a0,-1
    80002568:	a829                	j	80002582 <kill+0x5e>
            p->killed = 1;
    8000256a:	4785                	li	a5,1
    8000256c:	d49c                	sw	a5,40(s1)
            if (p->state == SLEEPING)
    8000256e:	4c98                	lw	a4,24(s1)
    80002570:	4789                	li	a5,2
    80002572:	00f70f63          	beq	a4,a5,80002590 <kill+0x6c>
            release(&p->lock);
    80002576:	8526                	mv	a0,s1
    80002578:	ffffe097          	auipc	ra,0xffffe
    8000257c:	776080e7          	jalr	1910(ra) # 80000cee <release>
            return 0;
    80002580:	4501                	li	a0,0
}
    80002582:	70a2                	ld	ra,40(sp)
    80002584:	7402                	ld	s0,32(sp)
    80002586:	64e2                	ld	s1,24(sp)
    80002588:	6942                	ld	s2,16(sp)
    8000258a:	69a2                	ld	s3,8(sp)
    8000258c:	6145                	addi	sp,sp,48
    8000258e:	8082                	ret
                p->state = RUNNABLE;
    80002590:	478d                	li	a5,3
    80002592:	cc9c                	sw	a5,24(s1)
    80002594:	b7cd                	j	80002576 <kill+0x52>

0000000080002596 <setkilled>:

void setkilled(struct proc *p)
{
    80002596:	1101                	addi	sp,sp,-32
    80002598:	ec06                	sd	ra,24(sp)
    8000259a:	e822                	sd	s0,16(sp)
    8000259c:	e426                	sd	s1,8(sp)
    8000259e:	1000                	addi	s0,sp,32
    800025a0:	84aa                	mv	s1,a0
    acquire(&p->lock);
    800025a2:	ffffe097          	auipc	ra,0xffffe
    800025a6:	69c080e7          	jalr	1692(ra) # 80000c3e <acquire>
    p->killed = 1;
    800025aa:	4785                	li	a5,1
    800025ac:	d49c                	sw	a5,40(s1)
    release(&p->lock);
    800025ae:	8526                	mv	a0,s1
    800025b0:	ffffe097          	auipc	ra,0xffffe
    800025b4:	73e080e7          	jalr	1854(ra) # 80000cee <release>
}
    800025b8:	60e2                	ld	ra,24(sp)
    800025ba:	6442                	ld	s0,16(sp)
    800025bc:	64a2                	ld	s1,8(sp)
    800025be:	6105                	addi	sp,sp,32
    800025c0:	8082                	ret

00000000800025c2 <killed>:

int killed(struct proc *p)
{
    800025c2:	1101                	addi	sp,sp,-32
    800025c4:	ec06                	sd	ra,24(sp)
    800025c6:	e822                	sd	s0,16(sp)
    800025c8:	e426                	sd	s1,8(sp)
    800025ca:	e04a                	sd	s2,0(sp)
    800025cc:	1000                	addi	s0,sp,32
    800025ce:	84aa                	mv	s1,a0
    int k;

    acquire(&p->lock);
    800025d0:	ffffe097          	auipc	ra,0xffffe
    800025d4:	66e080e7          	jalr	1646(ra) # 80000c3e <acquire>
    k = p->killed;
    800025d8:	0284a903          	lw	s2,40(s1)
    release(&p->lock);
    800025dc:	8526                	mv	a0,s1
    800025de:	ffffe097          	auipc	ra,0xffffe
    800025e2:	710080e7          	jalr	1808(ra) # 80000cee <release>
    return k;
}
    800025e6:	854a                	mv	a0,s2
    800025e8:	60e2                	ld	ra,24(sp)
    800025ea:	6442                	ld	s0,16(sp)
    800025ec:	64a2                	ld	s1,8(sp)
    800025ee:	6902                	ld	s2,0(sp)
    800025f0:	6105                	addi	sp,sp,32
    800025f2:	8082                	ret

00000000800025f4 <wait>:
{
    800025f4:	715d                	addi	sp,sp,-80
    800025f6:	e486                	sd	ra,72(sp)
    800025f8:	e0a2                	sd	s0,64(sp)
    800025fa:	fc26                	sd	s1,56(sp)
    800025fc:	f84a                	sd	s2,48(sp)
    800025fe:	f44e                	sd	s3,40(sp)
    80002600:	f052                	sd	s4,32(sp)
    80002602:	ec56                	sd	s5,24(sp)
    80002604:	e85a                	sd	s6,16(sp)
    80002606:	e45e                	sd	s7,8(sp)
    80002608:	0880                	addi	s0,sp,80
    8000260a:	8b2a                	mv	s6,a0
    struct proc *p = myproc();
    8000260c:	fffff097          	auipc	ra,0xfffff
    80002610:	534080e7          	jalr	1332(ra) # 80001b40 <myproc>
    80002614:	892a                	mv	s2,a0
    acquire(&wait_lock);
    80002616:	0000f517          	auipc	a0,0xf
    8000261a:	a6250513          	addi	a0,a0,-1438 # 80011078 <wait_lock>
    8000261e:	ffffe097          	auipc	ra,0xffffe
    80002622:	620080e7          	jalr	1568(ra) # 80000c3e <acquire>
                if (pp->state == ZOMBIE)
    80002626:	4a15                	li	s4,5
                havekids = 1;
    80002628:	4a85                	li	s5,1
        for (pp = proc; pp < &proc[NPROC]; pp++)
    8000262a:	00014997          	auipc	s3,0x14
    8000262e:	46698993          	addi	s3,s3,1126 # 80016a90 <tickslock>
        sleep(p, &wait_lock); // DOC: wait-sleep
    80002632:	0000fb97          	auipc	s7,0xf
    80002636:	a46b8b93          	addi	s7,s7,-1466 # 80011078 <wait_lock>
    8000263a:	a0c9                	j	800026fc <wait+0x108>
                    pid = pp->pid;
    8000263c:	0304a983          	lw	s3,48(s1)
                    if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002640:	000b0e63          	beqz	s6,8000265c <wait+0x68>
    80002644:	4691                	li	a3,4
    80002646:	02c48613          	addi	a2,s1,44
    8000264a:	85da                	mv	a1,s6
    8000264c:	05093503          	ld	a0,80(s2)
    80002650:	fffff097          	auipc	ra,0xfffff
    80002654:	0c0080e7          	jalr	192(ra) # 80001710 <copyout>
    80002658:	04054063          	bltz	a0,80002698 <wait+0xa4>
                    freeproc(pp);
    8000265c:	8526                	mv	a0,s1
    8000265e:	fffff097          	auipc	ra,0xfffff
    80002662:	694080e7          	jalr	1684(ra) # 80001cf2 <freeproc>
                    release(&pp->lock);
    80002666:	8526                	mv	a0,s1
    80002668:	ffffe097          	auipc	ra,0xffffe
    8000266c:	686080e7          	jalr	1670(ra) # 80000cee <release>
                    release(&wait_lock);
    80002670:	0000f517          	auipc	a0,0xf
    80002674:	a0850513          	addi	a0,a0,-1528 # 80011078 <wait_lock>
    80002678:	ffffe097          	auipc	ra,0xffffe
    8000267c:	676080e7          	jalr	1654(ra) # 80000cee <release>
}
    80002680:	854e                	mv	a0,s3
    80002682:	60a6                	ld	ra,72(sp)
    80002684:	6406                	ld	s0,64(sp)
    80002686:	74e2                	ld	s1,56(sp)
    80002688:	7942                	ld	s2,48(sp)
    8000268a:	79a2                	ld	s3,40(sp)
    8000268c:	7a02                	ld	s4,32(sp)
    8000268e:	6ae2                	ld	s5,24(sp)
    80002690:	6b42                	ld	s6,16(sp)
    80002692:	6ba2                	ld	s7,8(sp)
    80002694:	6161                	addi	sp,sp,80
    80002696:	8082                	ret
                        release(&pp->lock);
    80002698:	8526                	mv	a0,s1
    8000269a:	ffffe097          	auipc	ra,0xffffe
    8000269e:	654080e7          	jalr	1620(ra) # 80000cee <release>
                        release(&wait_lock);
    800026a2:	0000f517          	auipc	a0,0xf
    800026a6:	9d650513          	addi	a0,a0,-1578 # 80011078 <wait_lock>
    800026aa:	ffffe097          	auipc	ra,0xffffe
    800026ae:	644080e7          	jalr	1604(ra) # 80000cee <release>
                        return -1;
    800026b2:	59fd                	li	s3,-1
    800026b4:	b7f1                	j	80002680 <wait+0x8c>
        for (pp = proc; pp < &proc[NPROC]; pp++)
    800026b6:	16848493          	addi	s1,s1,360
    800026ba:	03348463          	beq	s1,s3,800026e2 <wait+0xee>
            if (pp->parent == p)
    800026be:	7c9c                	ld	a5,56(s1)
    800026c0:	ff279be3          	bne	a5,s2,800026b6 <wait+0xc2>
                acquire(&pp->lock);
    800026c4:	8526                	mv	a0,s1
    800026c6:	ffffe097          	auipc	ra,0xffffe
    800026ca:	578080e7          	jalr	1400(ra) # 80000c3e <acquire>
                if (pp->state == ZOMBIE)
    800026ce:	4c9c                	lw	a5,24(s1)
    800026d0:	f74786e3          	beq	a5,s4,8000263c <wait+0x48>
                release(&pp->lock);
    800026d4:	8526                	mv	a0,s1
    800026d6:	ffffe097          	auipc	ra,0xffffe
    800026da:	618080e7          	jalr	1560(ra) # 80000cee <release>
                havekids = 1;
    800026de:	8756                	mv	a4,s5
    800026e0:	bfd9                	j	800026b6 <wait+0xc2>
        if (!havekids || killed(p))
    800026e2:	c31d                	beqz	a4,80002708 <wait+0x114>
    800026e4:	854a                	mv	a0,s2
    800026e6:	00000097          	auipc	ra,0x0
    800026ea:	edc080e7          	jalr	-292(ra) # 800025c2 <killed>
    800026ee:	ed09                	bnez	a0,80002708 <wait+0x114>
        sleep(p, &wait_lock); // DOC: wait-sleep
    800026f0:	85de                	mv	a1,s7
    800026f2:	854a                	mv	a0,s2
    800026f4:	00000097          	auipc	ra,0x0
    800026f8:	c26080e7          	jalr	-986(ra) # 8000231a <sleep>
        havekids = 0;
    800026fc:	4701                	li	a4,0
        for (pp = proc; pp < &proc[NPROC]; pp++)
    800026fe:	0000f497          	auipc	s1,0xf
    80002702:	99248493          	addi	s1,s1,-1646 # 80011090 <proc>
    80002706:	bf65                	j	800026be <wait+0xca>
            release(&wait_lock);
    80002708:	0000f517          	auipc	a0,0xf
    8000270c:	97050513          	addi	a0,a0,-1680 # 80011078 <wait_lock>
    80002710:	ffffe097          	auipc	ra,0xffffe
    80002714:	5de080e7          	jalr	1502(ra) # 80000cee <release>
            return -1;
    80002718:	59fd                	li	s3,-1
    8000271a:	b79d                	j	80002680 <wait+0x8c>

000000008000271c <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000271c:	7179                	addi	sp,sp,-48
    8000271e:	f406                	sd	ra,40(sp)
    80002720:	f022                	sd	s0,32(sp)
    80002722:	ec26                	sd	s1,24(sp)
    80002724:	e84a                	sd	s2,16(sp)
    80002726:	e44e                	sd	s3,8(sp)
    80002728:	e052                	sd	s4,0(sp)
    8000272a:	1800                	addi	s0,sp,48
    8000272c:	84aa                	mv	s1,a0
    8000272e:	892e                	mv	s2,a1
    80002730:	89b2                	mv	s3,a2
    80002732:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    80002734:	fffff097          	auipc	ra,0xfffff
    80002738:	40c080e7          	jalr	1036(ra) # 80001b40 <myproc>
    if (user_dst)
    8000273c:	c08d                	beqz	s1,8000275e <either_copyout+0x42>
    {
        return copyout(p->pagetable, dst, src, len);
    8000273e:	86d2                	mv	a3,s4
    80002740:	864e                	mv	a2,s3
    80002742:	85ca                	mv	a1,s2
    80002744:	6928                	ld	a0,80(a0)
    80002746:	fffff097          	auipc	ra,0xfffff
    8000274a:	fca080e7          	jalr	-54(ra) # 80001710 <copyout>
    else
    {
        memmove((char *)dst, src, len);
        return 0;
    }
}
    8000274e:	70a2                	ld	ra,40(sp)
    80002750:	7402                	ld	s0,32(sp)
    80002752:	64e2                	ld	s1,24(sp)
    80002754:	6942                	ld	s2,16(sp)
    80002756:	69a2                	ld	s3,8(sp)
    80002758:	6a02                	ld	s4,0(sp)
    8000275a:	6145                	addi	sp,sp,48
    8000275c:	8082                	ret
        memmove((char *)dst, src, len);
    8000275e:	000a061b          	sext.w	a2,s4
    80002762:	85ce                	mv	a1,s3
    80002764:	854a                	mv	a0,s2
    80002766:	ffffe097          	auipc	ra,0xffffe
    8000276a:	634080e7          	jalr	1588(ra) # 80000d9a <memmove>
        return 0;
    8000276e:	8526                	mv	a0,s1
    80002770:	bff9                	j	8000274e <either_copyout+0x32>

0000000080002772 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002772:	7179                	addi	sp,sp,-48
    80002774:	f406                	sd	ra,40(sp)
    80002776:	f022                	sd	s0,32(sp)
    80002778:	ec26                	sd	s1,24(sp)
    8000277a:	e84a                	sd	s2,16(sp)
    8000277c:	e44e                	sd	s3,8(sp)
    8000277e:	e052                	sd	s4,0(sp)
    80002780:	1800                	addi	s0,sp,48
    80002782:	892a                	mv	s2,a0
    80002784:	84ae                	mv	s1,a1
    80002786:	89b2                	mv	s3,a2
    80002788:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    8000278a:	fffff097          	auipc	ra,0xfffff
    8000278e:	3b6080e7          	jalr	950(ra) # 80001b40 <myproc>
    if (user_src)
    80002792:	c08d                	beqz	s1,800027b4 <either_copyin+0x42>
    {
        return copyin(p->pagetable, dst, src, len);
    80002794:	86d2                	mv	a3,s4
    80002796:	864e                	mv	a2,s3
    80002798:	85ca                	mv	a1,s2
    8000279a:	6928                	ld	a0,80(a0)
    8000279c:	fffff097          	auipc	ra,0xfffff
    800027a0:	000080e7          	jalr	ra # 8000179c <copyin>
    else
    {
        memmove(dst, (char *)src, len);
        return 0;
    }
}
    800027a4:	70a2                	ld	ra,40(sp)
    800027a6:	7402                	ld	s0,32(sp)
    800027a8:	64e2                	ld	s1,24(sp)
    800027aa:	6942                	ld	s2,16(sp)
    800027ac:	69a2                	ld	s3,8(sp)
    800027ae:	6a02                	ld	s4,0(sp)
    800027b0:	6145                	addi	sp,sp,48
    800027b2:	8082                	ret
        memmove(dst, (char *)src, len);
    800027b4:	000a061b          	sext.w	a2,s4
    800027b8:	85ce                	mv	a1,s3
    800027ba:	854a                	mv	a0,s2
    800027bc:	ffffe097          	auipc	ra,0xffffe
    800027c0:	5de080e7          	jalr	1502(ra) # 80000d9a <memmove>
        return 0;
    800027c4:	8526                	mv	a0,s1
    800027c6:	bff9                	j	800027a4 <either_copyin+0x32>

00000000800027c8 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    800027c8:	715d                	addi	sp,sp,-80
    800027ca:	e486                	sd	ra,72(sp)
    800027cc:	e0a2                	sd	s0,64(sp)
    800027ce:	fc26                	sd	s1,56(sp)
    800027d0:	f84a                	sd	s2,48(sp)
    800027d2:	f44e                	sd	s3,40(sp)
    800027d4:	f052                	sd	s4,32(sp)
    800027d6:	ec56                	sd	s5,24(sp)
    800027d8:	e85a                	sd	s6,16(sp)
    800027da:	e45e                	sd	s7,8(sp)
    800027dc:	0880                	addi	s0,sp,80
        [RUNNING] "run   ",
        [ZOMBIE] "zombie"};
    struct proc *p;
    char *state;

    printf("\n");
    800027de:	00006517          	auipc	a0,0x6
    800027e2:	83250513          	addi	a0,a0,-1998 # 80008010 <etext+0x10>
    800027e6:	ffffe097          	auipc	ra,0xffffe
    800027ea:	dc4080e7          	jalr	-572(ra) # 800005aa <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    800027ee:	0000f497          	auipc	s1,0xf
    800027f2:	9fa48493          	addi	s1,s1,-1542 # 800111e8 <proc+0x158>
    800027f6:	00014917          	auipc	s2,0x14
    800027fa:	3f290913          	addi	s2,s2,1010 # 80016be8 <bcache+0x140>
    {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800027fe:	4b15                	li	s6,5
            state = states[p->state];
        else
            state = "???";
    80002800:	00006997          	auipc	s3,0x6
    80002804:	a7898993          	addi	s3,s3,-1416 # 80008278 <etext+0x278>
        printf("%d <%s %s", p->pid, state, p->name);
    80002808:	00006a97          	auipc	s5,0x6
    8000280c:	a78a8a93          	addi	s5,s5,-1416 # 80008280 <etext+0x280>
        printf("\n");
    80002810:	00006a17          	auipc	s4,0x6
    80002814:	800a0a13          	addi	s4,s4,-2048 # 80008010 <etext+0x10>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002818:	00006b97          	auipc	s7,0x6
    8000281c:	010b8b93          	addi	s7,s7,16 # 80008828 <states.0>
    80002820:	a00d                	j	80002842 <procdump+0x7a>
        printf("%d <%s %s", p->pid, state, p->name);
    80002822:	ed86a583          	lw	a1,-296(a3)
    80002826:	8556                	mv	a0,s5
    80002828:	ffffe097          	auipc	ra,0xffffe
    8000282c:	d82080e7          	jalr	-638(ra) # 800005aa <printf>
        printf("\n");
    80002830:	8552                	mv	a0,s4
    80002832:	ffffe097          	auipc	ra,0xffffe
    80002836:	d78080e7          	jalr	-648(ra) # 800005aa <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    8000283a:	16848493          	addi	s1,s1,360
    8000283e:	03248263          	beq	s1,s2,80002862 <procdump+0x9a>
        if (p->state == UNUSED)
    80002842:	86a6                	mv	a3,s1
    80002844:	ec04a783          	lw	a5,-320(s1)
    80002848:	dbed                	beqz	a5,8000283a <procdump+0x72>
            state = "???";
    8000284a:	864e                	mv	a2,s3
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000284c:	fcfb6be3          	bltu	s6,a5,80002822 <procdump+0x5a>
    80002850:	02079713          	slli	a4,a5,0x20
    80002854:	01d75793          	srli	a5,a4,0x1d
    80002858:	97de                	add	a5,a5,s7
    8000285a:	6390                	ld	a2,0(a5)
    8000285c:	f279                	bnez	a2,80002822 <procdump+0x5a>
            state = "???";
    8000285e:	864e                	mv	a2,s3
    80002860:	b7c9                	j	80002822 <procdump+0x5a>
    }
}
    80002862:	60a6                	ld	ra,72(sp)
    80002864:	6406                	ld	s0,64(sp)
    80002866:	74e2                	ld	s1,56(sp)
    80002868:	7942                	ld	s2,48(sp)
    8000286a:	79a2                	ld	s3,40(sp)
    8000286c:	7a02                	ld	s4,32(sp)
    8000286e:	6ae2                	ld	s5,24(sp)
    80002870:	6b42                	ld	s6,16(sp)
    80002872:	6ba2                	ld	s7,8(sp)
    80002874:	6161                	addi	sp,sp,80
    80002876:	8082                	ret

0000000080002878 <schedls>:

void schedls()
{
    80002878:	1141                	addi	sp,sp,-16
    8000287a:	e406                	sd	ra,8(sp)
    8000287c:	e022                	sd	s0,0(sp)
    8000287e:	0800                	addi	s0,sp,16
    printf("[ ]\tScheduler Name\tScheduler ID\n");
    80002880:	00006517          	auipc	a0,0x6
    80002884:	a1050513          	addi	a0,a0,-1520 # 80008290 <etext+0x290>
    80002888:	ffffe097          	auipc	ra,0xffffe
    8000288c:	d22080e7          	jalr	-734(ra) # 800005aa <printf>
    printf("====================================\n");
    80002890:	00006517          	auipc	a0,0x6
    80002894:	a2850513          	addi	a0,a0,-1496 # 800082b8 <etext+0x2b8>
    80002898:	ffffe097          	auipc	ra,0xffffe
    8000289c:	d12080e7          	jalr	-750(ra) # 800005aa <printf>
    for (int i = 0; i < SCHEDC; i++)
    {
        if (available_schedulers[i].impl == sched_pointer)
    800028a0:	00006717          	auipc	a4,0x6
    800028a4:	10873703          	ld	a4,264(a4) # 800089a8 <available_schedulers+0x10>
    800028a8:	00006797          	auipc	a5,0x6
    800028ac:	0a07b783          	ld	a5,160(a5) # 80008948 <sched_pointer>
    800028b0:	04f70663          	beq	a4,a5,800028fc <schedls+0x84>
        {
            printf("[*]\t");
        }
        else
        {
            printf("   \t");
    800028b4:	00006517          	auipc	a0,0x6
    800028b8:	a3450513          	addi	a0,a0,-1484 # 800082e8 <etext+0x2e8>
    800028bc:	ffffe097          	auipc	ra,0xffffe
    800028c0:	cee080e7          	jalr	-786(ra) # 800005aa <printf>
        }
        printf("%s\t%d\n", available_schedulers[i].name, available_schedulers[i].id);
    800028c4:	00006617          	auipc	a2,0x6
    800028c8:	0ec62603          	lw	a2,236(a2) # 800089b0 <available_schedulers+0x18>
    800028cc:	00006597          	auipc	a1,0x6
    800028d0:	0cc58593          	addi	a1,a1,204 # 80008998 <available_schedulers>
    800028d4:	00006517          	auipc	a0,0x6
    800028d8:	a1c50513          	addi	a0,a0,-1508 # 800082f0 <etext+0x2f0>
    800028dc:	ffffe097          	auipc	ra,0xffffe
    800028e0:	cce080e7          	jalr	-818(ra) # 800005aa <printf>
    }
    printf("\n*: current scheduler\n\n");
    800028e4:	00006517          	auipc	a0,0x6
    800028e8:	a1450513          	addi	a0,a0,-1516 # 800082f8 <etext+0x2f8>
    800028ec:	ffffe097          	auipc	ra,0xffffe
    800028f0:	cbe080e7          	jalr	-834(ra) # 800005aa <printf>
}
    800028f4:	60a2                	ld	ra,8(sp)
    800028f6:	6402                	ld	s0,0(sp)
    800028f8:	0141                	addi	sp,sp,16
    800028fa:	8082                	ret
            printf("[*]\t");
    800028fc:	00006517          	auipc	a0,0x6
    80002900:	9e450513          	addi	a0,a0,-1564 # 800082e0 <etext+0x2e0>
    80002904:	ffffe097          	auipc	ra,0xffffe
    80002908:	ca6080e7          	jalr	-858(ra) # 800005aa <printf>
    8000290c:	bf65                	j	800028c4 <schedls+0x4c>

000000008000290e <schedset>:

void schedset(int id)
{
    8000290e:	1141                	addi	sp,sp,-16
    80002910:	e406                	sd	ra,8(sp)
    80002912:	e022                	sd	s0,0(sp)
    80002914:	0800                	addi	s0,sp,16
    if (id < 0 || SCHEDC <= id)
    80002916:	e90d                	bnez	a0,80002948 <schedset+0x3a>
    {
        printf("Scheduler unchanged: ID out of range\n");
        return;
    }
    sched_pointer = available_schedulers[id].impl;
    80002918:	00006797          	auipc	a5,0x6
    8000291c:	0907b783          	ld	a5,144(a5) # 800089a8 <available_schedulers+0x10>
    80002920:	00006717          	auipc	a4,0x6
    80002924:	02f73423          	sd	a5,40(a4) # 80008948 <sched_pointer>
    printf("Scheduler successfully changed to %s\n", available_schedulers[id].name);
    80002928:	00006597          	auipc	a1,0x6
    8000292c:	07058593          	addi	a1,a1,112 # 80008998 <available_schedulers>
    80002930:	00006517          	auipc	a0,0x6
    80002934:	a0850513          	addi	a0,a0,-1528 # 80008338 <etext+0x338>
    80002938:	ffffe097          	auipc	ra,0xffffe
    8000293c:	c72080e7          	jalr	-910(ra) # 800005aa <printf>
    80002940:	60a2                	ld	ra,8(sp)
    80002942:	6402                	ld	s0,0(sp)
    80002944:	0141                	addi	sp,sp,16
    80002946:	8082                	ret
        printf("Scheduler unchanged: ID out of range\n");
    80002948:	00006517          	auipc	a0,0x6
    8000294c:	9c850513          	addi	a0,a0,-1592 # 80008310 <etext+0x310>
    80002950:	ffffe097          	auipc	ra,0xffffe
    80002954:	c5a080e7          	jalr	-934(ra) # 800005aa <printf>
        return;
    80002958:	b7e5                	j	80002940 <schedset+0x32>

000000008000295a <swtch>:
    8000295a:	00153023          	sd	ra,0(a0)
    8000295e:	00253423          	sd	sp,8(a0)
    80002962:	e900                	sd	s0,16(a0)
    80002964:	ed04                	sd	s1,24(a0)
    80002966:	03253023          	sd	s2,32(a0)
    8000296a:	03353423          	sd	s3,40(a0)
    8000296e:	03453823          	sd	s4,48(a0)
    80002972:	03553c23          	sd	s5,56(a0)
    80002976:	05653023          	sd	s6,64(a0)
    8000297a:	05753423          	sd	s7,72(a0)
    8000297e:	05853823          	sd	s8,80(a0)
    80002982:	05953c23          	sd	s9,88(a0)
    80002986:	07a53023          	sd	s10,96(a0)
    8000298a:	07b53423          	sd	s11,104(a0)
    8000298e:	0005b083          	ld	ra,0(a1)
    80002992:	0085b103          	ld	sp,8(a1)
    80002996:	6980                	ld	s0,16(a1)
    80002998:	6d84                	ld	s1,24(a1)
    8000299a:	0205b903          	ld	s2,32(a1)
    8000299e:	0285b983          	ld	s3,40(a1)
    800029a2:	0305ba03          	ld	s4,48(a1)
    800029a6:	0385ba83          	ld	s5,56(a1)
    800029aa:	0405bb03          	ld	s6,64(a1)
    800029ae:	0485bb83          	ld	s7,72(a1)
    800029b2:	0505bc03          	ld	s8,80(a1)
    800029b6:	0585bc83          	ld	s9,88(a1)
    800029ba:	0605bd03          	ld	s10,96(a1)
    800029be:	0685bd83          	ld	s11,104(a1)
    800029c2:	8082                	ret

00000000800029c4 <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    800029c4:	1141                	addi	sp,sp,-16
    800029c6:	e406                	sd	ra,8(sp)
    800029c8:	e022                	sd	s0,0(sp)
    800029ca:	0800                	addi	s0,sp,16
    initlock(&tickslock, "time");
    800029cc:	00006597          	auipc	a1,0x6
    800029d0:	9c458593          	addi	a1,a1,-1596 # 80008390 <etext+0x390>
    800029d4:	00014517          	auipc	a0,0x14
    800029d8:	0bc50513          	addi	a0,a0,188 # 80016a90 <tickslock>
    800029dc:	ffffe097          	auipc	ra,0xffffe
    800029e0:	1ce080e7          	jalr	462(ra) # 80000baa <initlock>
}
    800029e4:	60a2                	ld	ra,8(sp)
    800029e6:	6402                	ld	s0,0(sp)
    800029e8:	0141                	addi	sp,sp,16
    800029ea:	8082                	ret

00000000800029ec <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    800029ec:	1141                	addi	sp,sp,-16
    800029ee:	e406                	sd	ra,8(sp)
    800029f0:	e022                	sd	s0,0(sp)
    800029f2:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800029f4:	00003797          	auipc	a5,0x3
    800029f8:	68c78793          	addi	a5,a5,1676 # 80006080 <kernelvec>
    800029fc:	10579073          	csrw	stvec,a5
    w_stvec((uint64)kernelvec);
}
    80002a00:	60a2                	ld	ra,8(sp)
    80002a02:	6402                	ld	s0,0(sp)
    80002a04:	0141                	addi	sp,sp,16
    80002a06:	8082                	ret

0000000080002a08 <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80002a08:	1141                	addi	sp,sp,-16
    80002a0a:	e406                	sd	ra,8(sp)
    80002a0c:	e022                	sd	s0,0(sp)
    80002a0e:	0800                	addi	s0,sp,16
    struct proc *p = myproc();
    80002a10:	fffff097          	auipc	ra,0xfffff
    80002a14:	130080e7          	jalr	304(ra) # 80001b40 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a18:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002a1c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a1e:	10079073          	csrw	sstatus,a5
    // kerneltrap() to usertrap(), so turn off interrupts until
    // we're back in user space, where usertrap() is correct.
    intr_off();

    // send syscalls, interrupts, and exceptions to uservec in trampoline.S
    uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002a22:	00004697          	auipc	a3,0x4
    80002a26:	5de68693          	addi	a3,a3,1502 # 80007000 <_trampoline>
    80002a2a:	00004717          	auipc	a4,0x4
    80002a2e:	5d670713          	addi	a4,a4,1494 # 80007000 <_trampoline>
    80002a32:	8f15                	sub	a4,a4,a3
    80002a34:	040007b7          	lui	a5,0x4000
    80002a38:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002a3a:	07b2                	slli	a5,a5,0xc
    80002a3c:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002a3e:	10571073          	csrw	stvec,a4
    w_stvec(trampoline_uservec);

    // set up trapframe values that uservec will need when
    // the process next traps into the kernel.
    p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002a42:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002a44:	18002673          	csrr	a2,satp
    80002a48:	e310                	sd	a2,0(a4)
    p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002a4a:	6d30                	ld	a2,88(a0)
    80002a4c:	6138                	ld	a4,64(a0)
    80002a4e:	6585                	lui	a1,0x1
    80002a50:	972e                	add	a4,a4,a1
    80002a52:	e618                	sd	a4,8(a2)
    p->trapframe->kernel_trap = (uint64)usertrap;
    80002a54:	6d38                	ld	a4,88(a0)
    80002a56:	00000617          	auipc	a2,0x0
    80002a5a:	13860613          	addi	a2,a2,312 # 80002b8e <usertrap>
    80002a5e:	eb10                	sd	a2,16(a4)
    p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002a60:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002a62:	8612                	mv	a2,tp
    80002a64:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a66:	10002773          	csrr	a4,sstatus
    // set up the registers that trampoline.S's sret will use
    // to get to user space.

    // set S Previous Privilege mode to User.
    unsigned long x = r_sstatus();
    x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002a6a:	eff77713          	andi	a4,a4,-257
    x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002a6e:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a72:	10071073          	csrw	sstatus,a4
    w_sstatus(x);

    // set S Exception Program Counter to the saved user pc.
    w_sepc(p->trapframe->epc);
    80002a76:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002a78:	6f18                	ld	a4,24(a4)
    80002a7a:	14171073          	csrw	sepc,a4

    // tell trampoline.S the user page table to switch to.
    uint64 satp = MAKE_SATP(p->pagetable);
    80002a7e:	6928                	ld	a0,80(a0)
    80002a80:	8131                	srli	a0,a0,0xc

    // jump to userret in trampoline.S at the top of memory, which
    // switches to the user page table, restores user registers,
    // and switches to user mode with sret.
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002a82:	00004717          	auipc	a4,0x4
    80002a86:	61a70713          	addi	a4,a4,1562 # 8000709c <userret>
    80002a8a:	8f15                	sub	a4,a4,a3
    80002a8c:	97ba                	add	a5,a5,a4
    ((void (*)(uint64))trampoline_userret)(satp);
    80002a8e:	577d                	li	a4,-1
    80002a90:	177e                	slli	a4,a4,0x3f
    80002a92:	8d59                	or	a0,a0,a4
    80002a94:	9782                	jalr	a5
}
    80002a96:	60a2                	ld	ra,8(sp)
    80002a98:	6402                	ld	s0,0(sp)
    80002a9a:	0141                	addi	sp,sp,16
    80002a9c:	8082                	ret

0000000080002a9e <clockintr>:
    w_sepc(sepc);
    w_sstatus(sstatus);
}

void clockintr()
{
    80002a9e:	1101                	addi	sp,sp,-32
    80002aa0:	ec06                	sd	ra,24(sp)
    80002aa2:	e822                	sd	s0,16(sp)
    80002aa4:	e426                	sd	s1,8(sp)
    80002aa6:	1000                	addi	s0,sp,32
    acquire(&tickslock);
    80002aa8:	00014497          	auipc	s1,0x14
    80002aac:	fe848493          	addi	s1,s1,-24 # 80016a90 <tickslock>
    80002ab0:	8526                	mv	a0,s1
    80002ab2:	ffffe097          	auipc	ra,0xffffe
    80002ab6:	18c080e7          	jalr	396(ra) # 80000c3e <acquire>
    ticks++;
    80002aba:	00006517          	auipc	a0,0x6
    80002abe:	f3650513          	addi	a0,a0,-202 # 800089f0 <ticks>
    80002ac2:	411c                	lw	a5,0(a0)
    80002ac4:	2785                	addiw	a5,a5,1
    80002ac6:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80002ac8:	00000097          	auipc	ra,0x0
    80002acc:	8b6080e7          	jalr	-1866(ra) # 8000237e <wakeup>
    release(&tickslock);
    80002ad0:	8526                	mv	a0,s1
    80002ad2:	ffffe097          	auipc	ra,0xffffe
    80002ad6:	21c080e7          	jalr	540(ra) # 80000cee <release>
}
    80002ada:	60e2                	ld	ra,24(sp)
    80002adc:	6442                	ld	s0,16(sp)
    80002ade:	64a2                	ld	s1,8(sp)
    80002ae0:	6105                	addi	sp,sp,32
    80002ae2:	8082                	ret

0000000080002ae4 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002ae4:	142027f3          	csrr	a5,scause

        return 2;
    }
    else
    {
        return 0;
    80002ae8:	4501                	li	a0,0
    if ((scause & 0x8000000000000000L) &&
    80002aea:	0a07d163          	bgez	a5,80002b8c <devintr+0xa8>
{
    80002aee:	1101                	addi	sp,sp,-32
    80002af0:	ec06                	sd	ra,24(sp)
    80002af2:	e822                	sd	s0,16(sp)
    80002af4:	1000                	addi	s0,sp,32
        (scause & 0xff) == 9)
    80002af6:	0ff7f713          	zext.b	a4,a5
    if ((scause & 0x8000000000000000L) &&
    80002afa:	46a5                	li	a3,9
    80002afc:	00d70c63          	beq	a4,a3,80002b14 <devintr+0x30>
    else if (scause == 0x8000000000000001L)
    80002b00:	577d                	li	a4,-1
    80002b02:	177e                	slli	a4,a4,0x3f
    80002b04:	0705                	addi	a4,a4,1
        return 0;
    80002b06:	4501                	li	a0,0
    else if (scause == 0x8000000000000001L)
    80002b08:	06e78163          	beq	a5,a4,80002b6a <devintr+0x86>
    }
}
    80002b0c:	60e2                	ld	ra,24(sp)
    80002b0e:	6442                	ld	s0,16(sp)
    80002b10:	6105                	addi	sp,sp,32
    80002b12:	8082                	ret
    80002b14:	e426                	sd	s1,8(sp)
        int irq = plic_claim();
    80002b16:	00003097          	auipc	ra,0x3
    80002b1a:	676080e7          	jalr	1654(ra) # 8000618c <plic_claim>
    80002b1e:	84aa                	mv	s1,a0
        if (irq == UART0_IRQ)
    80002b20:	47a9                	li	a5,10
    80002b22:	00f50963          	beq	a0,a5,80002b34 <devintr+0x50>
        else if (irq == VIRTIO0_IRQ)
    80002b26:	4785                	li	a5,1
    80002b28:	00f50b63          	beq	a0,a5,80002b3e <devintr+0x5a>
        return 1;
    80002b2c:	4505                	li	a0,1
        else if (irq)
    80002b2e:	ec89                	bnez	s1,80002b48 <devintr+0x64>
    80002b30:	64a2                	ld	s1,8(sp)
    80002b32:	bfe9                	j	80002b0c <devintr+0x28>
            uartintr();
    80002b34:	ffffe097          	auipc	ra,0xffffe
    80002b38:	ec8080e7          	jalr	-312(ra) # 800009fc <uartintr>
        if (irq)
    80002b3c:	a839                	j	80002b5a <devintr+0x76>
            virtio_disk_intr();
    80002b3e:	00004097          	auipc	ra,0x4
    80002b42:	b42080e7          	jalr	-1214(ra) # 80006680 <virtio_disk_intr>
        if (irq)
    80002b46:	a811                	j	80002b5a <devintr+0x76>
            printf("unexpected interrupt irq=%d\n", irq);
    80002b48:	85a6                	mv	a1,s1
    80002b4a:	00006517          	auipc	a0,0x6
    80002b4e:	84e50513          	addi	a0,a0,-1970 # 80008398 <etext+0x398>
    80002b52:	ffffe097          	auipc	ra,0xffffe
    80002b56:	a58080e7          	jalr	-1448(ra) # 800005aa <printf>
            plic_complete(irq);
    80002b5a:	8526                	mv	a0,s1
    80002b5c:	00003097          	auipc	ra,0x3
    80002b60:	654080e7          	jalr	1620(ra) # 800061b0 <plic_complete>
        return 1;
    80002b64:	4505                	li	a0,1
    80002b66:	64a2                	ld	s1,8(sp)
    80002b68:	b755                	j	80002b0c <devintr+0x28>
        if (cpuid() == 0)
    80002b6a:	fffff097          	auipc	ra,0xfffff
    80002b6e:	fa2080e7          	jalr	-94(ra) # 80001b0c <cpuid>
    80002b72:	c901                	beqz	a0,80002b82 <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002b74:	144027f3          	csrr	a5,sip
        w_sip(r_sip() & ~2);
    80002b78:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002b7a:	14479073          	csrw	sip,a5
        return 2;
    80002b7e:	4509                	li	a0,2
    80002b80:	b771                	j	80002b0c <devintr+0x28>
            clockintr();
    80002b82:	00000097          	auipc	ra,0x0
    80002b86:	f1c080e7          	jalr	-228(ra) # 80002a9e <clockintr>
    80002b8a:	b7ed                	j	80002b74 <devintr+0x90>
}
    80002b8c:	8082                	ret

0000000080002b8e <usertrap>:
{
    80002b8e:	1101                	addi	sp,sp,-32
    80002b90:	ec06                	sd	ra,24(sp)
    80002b92:	e822                	sd	s0,16(sp)
    80002b94:	e426                	sd	s1,8(sp)
    80002b96:	e04a                	sd	s2,0(sp)
    80002b98:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b9a:	100027f3          	csrr	a5,sstatus
    if ((r_sstatus() & SSTATUS_SPP) != 0)
    80002b9e:	1007f793          	andi	a5,a5,256
    80002ba2:	e3b1                	bnez	a5,80002be6 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002ba4:	00003797          	auipc	a5,0x3
    80002ba8:	4dc78793          	addi	a5,a5,1244 # 80006080 <kernelvec>
    80002bac:	10579073          	csrw	stvec,a5
    struct proc *p = myproc();
    80002bb0:	fffff097          	auipc	ra,0xfffff
    80002bb4:	f90080e7          	jalr	-112(ra) # 80001b40 <myproc>
    80002bb8:	84aa                	mv	s1,a0
    p->trapframe->epc = r_sepc();
    80002bba:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002bbc:	14102773          	csrr	a4,sepc
    80002bc0:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002bc2:	14202773          	csrr	a4,scause
    if (r_scause() == 8)
    80002bc6:	47a1                	li	a5,8
    80002bc8:	02f70763          	beq	a4,a5,80002bf6 <usertrap+0x68>
    else if ((which_dev = devintr()) != 0)
    80002bcc:	00000097          	auipc	ra,0x0
    80002bd0:	f18080e7          	jalr	-232(ra) # 80002ae4 <devintr>
    80002bd4:	892a                	mv	s2,a0
    80002bd6:	c151                	beqz	a0,80002c5a <usertrap+0xcc>
    if (killed(p))
    80002bd8:	8526                	mv	a0,s1
    80002bda:	00000097          	auipc	ra,0x0
    80002bde:	9e8080e7          	jalr	-1560(ra) # 800025c2 <killed>
    80002be2:	c929                	beqz	a0,80002c34 <usertrap+0xa6>
    80002be4:	a099                	j	80002c2a <usertrap+0x9c>
        panic("usertrap: not from user mode");
    80002be6:	00005517          	auipc	a0,0x5
    80002bea:	7d250513          	addi	a0,a0,2002 # 800083b8 <etext+0x3b8>
    80002bee:	ffffe097          	auipc	ra,0xffffe
    80002bf2:	972080e7          	jalr	-1678(ra) # 80000560 <panic>
        if (killed(p))
    80002bf6:	00000097          	auipc	ra,0x0
    80002bfa:	9cc080e7          	jalr	-1588(ra) # 800025c2 <killed>
    80002bfe:	e921                	bnez	a0,80002c4e <usertrap+0xc0>
        p->trapframe->epc += 4;
    80002c00:	6cb8                	ld	a4,88(s1)
    80002c02:	6f1c                	ld	a5,24(a4)
    80002c04:	0791                	addi	a5,a5,4
    80002c06:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002c08:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002c0c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002c10:	10079073          	csrw	sstatus,a5
        syscall();
    80002c14:	00000097          	auipc	ra,0x0
    80002c18:	2d0080e7          	jalr	720(ra) # 80002ee4 <syscall>
    if (killed(p))
    80002c1c:	8526                	mv	a0,s1
    80002c1e:	00000097          	auipc	ra,0x0
    80002c22:	9a4080e7          	jalr	-1628(ra) # 800025c2 <killed>
    80002c26:	c911                	beqz	a0,80002c3a <usertrap+0xac>
    80002c28:	4901                	li	s2,0
        exit(-1);
    80002c2a:	557d                	li	a0,-1
    80002c2c:	00000097          	auipc	ra,0x0
    80002c30:	822080e7          	jalr	-2014(ra) # 8000244e <exit>
    if (which_dev == 2)
    80002c34:	4789                	li	a5,2
    80002c36:	04f90f63          	beq	s2,a5,80002c94 <usertrap+0x106>
    usertrapret();
    80002c3a:	00000097          	auipc	ra,0x0
    80002c3e:	dce080e7          	jalr	-562(ra) # 80002a08 <usertrapret>
}
    80002c42:	60e2                	ld	ra,24(sp)
    80002c44:	6442                	ld	s0,16(sp)
    80002c46:	64a2                	ld	s1,8(sp)
    80002c48:	6902                	ld	s2,0(sp)
    80002c4a:	6105                	addi	sp,sp,32
    80002c4c:	8082                	ret
            exit(-1);
    80002c4e:	557d                	li	a0,-1
    80002c50:	fffff097          	auipc	ra,0xfffff
    80002c54:	7fe080e7          	jalr	2046(ra) # 8000244e <exit>
    80002c58:	b765                	j	80002c00 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002c5a:	142025f3          	csrr	a1,scause
        printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002c5e:	5890                	lw	a2,48(s1)
    80002c60:	00005517          	auipc	a0,0x5
    80002c64:	77850513          	addi	a0,a0,1912 # 800083d8 <etext+0x3d8>
    80002c68:	ffffe097          	auipc	ra,0xffffe
    80002c6c:	942080e7          	jalr	-1726(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002c70:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002c74:	14302673          	csrr	a2,stval
        printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002c78:	00005517          	auipc	a0,0x5
    80002c7c:	79050513          	addi	a0,a0,1936 # 80008408 <etext+0x408>
    80002c80:	ffffe097          	auipc	ra,0xffffe
    80002c84:	92a080e7          	jalr	-1750(ra) # 800005aa <printf>
        setkilled(p);
    80002c88:	8526                	mv	a0,s1
    80002c8a:	00000097          	auipc	ra,0x0
    80002c8e:	90c080e7          	jalr	-1780(ra) # 80002596 <setkilled>
    80002c92:	b769                	j	80002c1c <usertrap+0x8e>
        yield(YIELD_TIMER);
    80002c94:	4505                	li	a0,1
    80002c96:	fffff097          	auipc	ra,0xfffff
    80002c9a:	648080e7          	jalr	1608(ra) # 800022de <yield>
    80002c9e:	bf71                	j	80002c3a <usertrap+0xac>

0000000080002ca0 <kerneltrap>:
{
    80002ca0:	7179                	addi	sp,sp,-48
    80002ca2:	f406                	sd	ra,40(sp)
    80002ca4:	f022                	sd	s0,32(sp)
    80002ca6:	ec26                	sd	s1,24(sp)
    80002ca8:	e84a                	sd	s2,16(sp)
    80002caa:	e44e                	sd	s3,8(sp)
    80002cac:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002cae:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002cb2:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002cb6:	142029f3          	csrr	s3,scause
    if ((sstatus & SSTATUS_SPP) == 0)
    80002cba:	1004f793          	andi	a5,s1,256
    80002cbe:	cb85                	beqz	a5,80002cee <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002cc0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002cc4:	8b89                	andi	a5,a5,2
    if (intr_get() != 0)
    80002cc6:	ef85                	bnez	a5,80002cfe <kerneltrap+0x5e>
    if ((which_dev = devintr()) == 0)
    80002cc8:	00000097          	auipc	ra,0x0
    80002ccc:	e1c080e7          	jalr	-484(ra) # 80002ae4 <devintr>
    80002cd0:	cd1d                	beqz	a0,80002d0e <kerneltrap+0x6e>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002cd2:	4789                	li	a5,2
    80002cd4:	06f50a63          	beq	a0,a5,80002d48 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002cd8:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002cdc:	10049073          	csrw	sstatus,s1
}
    80002ce0:	70a2                	ld	ra,40(sp)
    80002ce2:	7402                	ld	s0,32(sp)
    80002ce4:	64e2                	ld	s1,24(sp)
    80002ce6:	6942                	ld	s2,16(sp)
    80002ce8:	69a2                	ld	s3,8(sp)
    80002cea:	6145                	addi	sp,sp,48
    80002cec:	8082                	ret
        panic("kerneltrap: not from supervisor mode");
    80002cee:	00005517          	auipc	a0,0x5
    80002cf2:	73a50513          	addi	a0,a0,1850 # 80008428 <etext+0x428>
    80002cf6:	ffffe097          	auipc	ra,0xffffe
    80002cfa:	86a080e7          	jalr	-1942(ra) # 80000560 <panic>
        panic("kerneltrap: interrupts enabled");
    80002cfe:	00005517          	auipc	a0,0x5
    80002d02:	75250513          	addi	a0,a0,1874 # 80008450 <etext+0x450>
    80002d06:	ffffe097          	auipc	ra,0xffffe
    80002d0a:	85a080e7          	jalr	-1958(ra) # 80000560 <panic>
        printf("scause %p\n", scause);
    80002d0e:	85ce                	mv	a1,s3
    80002d10:	00005517          	auipc	a0,0x5
    80002d14:	76050513          	addi	a0,a0,1888 # 80008470 <etext+0x470>
    80002d18:	ffffe097          	auipc	ra,0xffffe
    80002d1c:	892080e7          	jalr	-1902(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002d20:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002d24:	14302673          	csrr	a2,stval
        printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002d28:	00005517          	auipc	a0,0x5
    80002d2c:	75850513          	addi	a0,a0,1880 # 80008480 <etext+0x480>
    80002d30:	ffffe097          	auipc	ra,0xffffe
    80002d34:	87a080e7          	jalr	-1926(ra) # 800005aa <printf>
        panic("kerneltrap");
    80002d38:	00005517          	auipc	a0,0x5
    80002d3c:	76050513          	addi	a0,a0,1888 # 80008498 <etext+0x498>
    80002d40:	ffffe097          	auipc	ra,0xffffe
    80002d44:	820080e7          	jalr	-2016(ra) # 80000560 <panic>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002d48:	fffff097          	auipc	ra,0xfffff
    80002d4c:	df8080e7          	jalr	-520(ra) # 80001b40 <myproc>
    80002d50:	d541                	beqz	a0,80002cd8 <kerneltrap+0x38>
    80002d52:	fffff097          	auipc	ra,0xfffff
    80002d56:	dee080e7          	jalr	-530(ra) # 80001b40 <myproc>
    80002d5a:	4d18                	lw	a4,24(a0)
    80002d5c:	4791                	li	a5,4
    80002d5e:	f6f71de3          	bne	a4,a5,80002cd8 <kerneltrap+0x38>
        yield(YIELD_OTHER);
    80002d62:	4509                	li	a0,2
    80002d64:	fffff097          	auipc	ra,0xfffff
    80002d68:	57a080e7          	jalr	1402(ra) # 800022de <yield>
    80002d6c:	b7b5                	j	80002cd8 <kerneltrap+0x38>

0000000080002d6e <argraw>:
    return strlen(buf);
}

static uint64
argraw(int n)
{
    80002d6e:	1101                	addi	sp,sp,-32
    80002d70:	ec06                	sd	ra,24(sp)
    80002d72:	e822                	sd	s0,16(sp)
    80002d74:	e426                	sd	s1,8(sp)
    80002d76:	1000                	addi	s0,sp,32
    80002d78:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    80002d7a:	fffff097          	auipc	ra,0xfffff
    80002d7e:	dc6080e7          	jalr	-570(ra) # 80001b40 <myproc>
    switch (n)
    80002d82:	4795                	li	a5,5
    80002d84:	0497e163          	bltu	a5,s1,80002dc6 <argraw+0x58>
    80002d88:	048a                	slli	s1,s1,0x2
    80002d8a:	00006717          	auipc	a4,0x6
    80002d8e:	ace70713          	addi	a4,a4,-1330 # 80008858 <states.0+0x30>
    80002d92:	94ba                	add	s1,s1,a4
    80002d94:	409c                	lw	a5,0(s1)
    80002d96:	97ba                	add	a5,a5,a4
    80002d98:	8782                	jr	a5
    {
    case 0:
        return p->trapframe->a0;
    80002d9a:	6d3c                	ld	a5,88(a0)
    80002d9c:	7ba8                	ld	a0,112(a5)
    case 5:
        return p->trapframe->a5;
    }
    panic("argraw");
    return -1;
}
    80002d9e:	60e2                	ld	ra,24(sp)
    80002da0:	6442                	ld	s0,16(sp)
    80002da2:	64a2                	ld	s1,8(sp)
    80002da4:	6105                	addi	sp,sp,32
    80002da6:	8082                	ret
        return p->trapframe->a1;
    80002da8:	6d3c                	ld	a5,88(a0)
    80002daa:	7fa8                	ld	a0,120(a5)
    80002dac:	bfcd                	j	80002d9e <argraw+0x30>
        return p->trapframe->a2;
    80002dae:	6d3c                	ld	a5,88(a0)
    80002db0:	63c8                	ld	a0,128(a5)
    80002db2:	b7f5                	j	80002d9e <argraw+0x30>
        return p->trapframe->a3;
    80002db4:	6d3c                	ld	a5,88(a0)
    80002db6:	67c8                	ld	a0,136(a5)
    80002db8:	b7dd                	j	80002d9e <argraw+0x30>
        return p->trapframe->a4;
    80002dba:	6d3c                	ld	a5,88(a0)
    80002dbc:	6bc8                	ld	a0,144(a5)
    80002dbe:	b7c5                	j	80002d9e <argraw+0x30>
        return p->trapframe->a5;
    80002dc0:	6d3c                	ld	a5,88(a0)
    80002dc2:	6fc8                	ld	a0,152(a5)
    80002dc4:	bfe9                	j	80002d9e <argraw+0x30>
    panic("argraw");
    80002dc6:	00005517          	auipc	a0,0x5
    80002dca:	6e250513          	addi	a0,a0,1762 # 800084a8 <etext+0x4a8>
    80002dce:	ffffd097          	auipc	ra,0xffffd
    80002dd2:	792080e7          	jalr	1938(ra) # 80000560 <panic>

0000000080002dd6 <fetchaddr>:
{
    80002dd6:	1101                	addi	sp,sp,-32
    80002dd8:	ec06                	sd	ra,24(sp)
    80002dda:	e822                	sd	s0,16(sp)
    80002ddc:	e426                	sd	s1,8(sp)
    80002dde:	e04a                	sd	s2,0(sp)
    80002de0:	1000                	addi	s0,sp,32
    80002de2:	84aa                	mv	s1,a0
    80002de4:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80002de6:	fffff097          	auipc	ra,0xfffff
    80002dea:	d5a080e7          	jalr	-678(ra) # 80001b40 <myproc>
    if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002dee:	653c                	ld	a5,72(a0)
    80002df0:	02f4f863          	bgeu	s1,a5,80002e20 <fetchaddr+0x4a>
    80002df4:	00848713          	addi	a4,s1,8
    80002df8:	02e7e663          	bltu	a5,a4,80002e24 <fetchaddr+0x4e>
    if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002dfc:	46a1                	li	a3,8
    80002dfe:	8626                	mv	a2,s1
    80002e00:	85ca                	mv	a1,s2
    80002e02:	6928                	ld	a0,80(a0)
    80002e04:	fffff097          	auipc	ra,0xfffff
    80002e08:	998080e7          	jalr	-1640(ra) # 8000179c <copyin>
    80002e0c:	00a03533          	snez	a0,a0
    80002e10:	40a0053b          	negw	a0,a0
}
    80002e14:	60e2                	ld	ra,24(sp)
    80002e16:	6442                	ld	s0,16(sp)
    80002e18:	64a2                	ld	s1,8(sp)
    80002e1a:	6902                	ld	s2,0(sp)
    80002e1c:	6105                	addi	sp,sp,32
    80002e1e:	8082                	ret
        return -1;
    80002e20:	557d                	li	a0,-1
    80002e22:	bfcd                	j	80002e14 <fetchaddr+0x3e>
    80002e24:	557d                	li	a0,-1
    80002e26:	b7fd                	j	80002e14 <fetchaddr+0x3e>

0000000080002e28 <fetchstr>:
{
    80002e28:	7179                	addi	sp,sp,-48
    80002e2a:	f406                	sd	ra,40(sp)
    80002e2c:	f022                	sd	s0,32(sp)
    80002e2e:	ec26                	sd	s1,24(sp)
    80002e30:	e84a                	sd	s2,16(sp)
    80002e32:	e44e                	sd	s3,8(sp)
    80002e34:	1800                	addi	s0,sp,48
    80002e36:	892a                	mv	s2,a0
    80002e38:	84ae                	mv	s1,a1
    80002e3a:	89b2                	mv	s3,a2
    struct proc *p = myproc();
    80002e3c:	fffff097          	auipc	ra,0xfffff
    80002e40:	d04080e7          	jalr	-764(ra) # 80001b40 <myproc>
    if (copyinstr(p->pagetable, buf, addr, max) < 0)
    80002e44:	86ce                	mv	a3,s3
    80002e46:	864a                	mv	a2,s2
    80002e48:	85a6                	mv	a1,s1
    80002e4a:	6928                	ld	a0,80(a0)
    80002e4c:	fffff097          	auipc	ra,0xfffff
    80002e50:	9de080e7          	jalr	-1570(ra) # 8000182a <copyinstr>
    80002e54:	00054e63          	bltz	a0,80002e70 <fetchstr+0x48>
    return strlen(buf);
    80002e58:	8526                	mv	a0,s1
    80002e5a:	ffffe097          	auipc	ra,0xffffe
    80002e5e:	068080e7          	jalr	104(ra) # 80000ec2 <strlen>
}
    80002e62:	70a2                	ld	ra,40(sp)
    80002e64:	7402                	ld	s0,32(sp)
    80002e66:	64e2                	ld	s1,24(sp)
    80002e68:	6942                	ld	s2,16(sp)
    80002e6a:	69a2                	ld	s3,8(sp)
    80002e6c:	6145                	addi	sp,sp,48
    80002e6e:	8082                	ret
        return -1;
    80002e70:	557d                	li	a0,-1
    80002e72:	bfc5                	j	80002e62 <fetchstr+0x3a>

0000000080002e74 <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip)
{
    80002e74:	1101                	addi	sp,sp,-32
    80002e76:	ec06                	sd	ra,24(sp)
    80002e78:	e822                	sd	s0,16(sp)
    80002e7a:	e426                	sd	s1,8(sp)
    80002e7c:	1000                	addi	s0,sp,32
    80002e7e:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80002e80:	00000097          	auipc	ra,0x0
    80002e84:	eee080e7          	jalr	-274(ra) # 80002d6e <argraw>
    80002e88:	c088                	sw	a0,0(s1)
}
    80002e8a:	60e2                	ld	ra,24(sp)
    80002e8c:	6442                	ld	s0,16(sp)
    80002e8e:	64a2                	ld	s1,8(sp)
    80002e90:	6105                	addi	sp,sp,32
    80002e92:	8082                	ret

0000000080002e94 <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip)
{
    80002e94:	1101                	addi	sp,sp,-32
    80002e96:	ec06                	sd	ra,24(sp)
    80002e98:	e822                	sd	s0,16(sp)
    80002e9a:	e426                	sd	s1,8(sp)
    80002e9c:	1000                	addi	s0,sp,32
    80002e9e:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80002ea0:	00000097          	auipc	ra,0x0
    80002ea4:	ece080e7          	jalr	-306(ra) # 80002d6e <argraw>
    80002ea8:	e088                	sd	a0,0(s1)
}
    80002eaa:	60e2                	ld	ra,24(sp)
    80002eac:	6442                	ld	s0,16(sp)
    80002eae:	64a2                	ld	s1,8(sp)
    80002eb0:	6105                	addi	sp,sp,32
    80002eb2:	8082                	ret

0000000080002eb4 <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    80002eb4:	1101                	addi	sp,sp,-32
    80002eb6:	ec06                	sd	ra,24(sp)
    80002eb8:	e822                	sd	s0,16(sp)
    80002eba:	e426                	sd	s1,8(sp)
    80002ebc:	e04a                	sd	s2,0(sp)
    80002ebe:	1000                	addi	s0,sp,32
    80002ec0:	84ae                	mv	s1,a1
    80002ec2:	8932                	mv	s2,a2
    *ip = argraw(n);
    80002ec4:	00000097          	auipc	ra,0x0
    80002ec8:	eaa080e7          	jalr	-342(ra) # 80002d6e <argraw>
    uint64 addr;
    argaddr(n, &addr);
    return fetchstr(addr, buf, max);
    80002ecc:	864a                	mv	a2,s2
    80002ece:	85a6                	mv	a1,s1
    80002ed0:	00000097          	auipc	ra,0x0
    80002ed4:	f58080e7          	jalr	-168(ra) # 80002e28 <fetchstr>
}
    80002ed8:	60e2                	ld	ra,24(sp)
    80002eda:	6442                	ld	s0,16(sp)
    80002edc:	64a2                	ld	s1,8(sp)
    80002ede:	6902                	ld	s2,0(sp)
    80002ee0:	6105                	addi	sp,sp,32
    80002ee2:	8082                	ret

0000000080002ee4 <syscall>:
    [SYS_schedset] sys_schedset,
    [SYS_yield] sys_yield,
};

void syscall(void)
{
    80002ee4:	1101                	addi	sp,sp,-32
    80002ee6:	ec06                	sd	ra,24(sp)
    80002ee8:	e822                	sd	s0,16(sp)
    80002eea:	e426                	sd	s1,8(sp)
    80002eec:	e04a                	sd	s2,0(sp)
    80002eee:	1000                	addi	s0,sp,32
    int num;
    struct proc *p = myproc();
    80002ef0:	fffff097          	auipc	ra,0xfffff
    80002ef4:	c50080e7          	jalr	-944(ra) # 80001b40 <myproc>
    80002ef8:	84aa                	mv	s1,a0

    num = p->trapframe->a7;
    80002efa:	05853903          	ld	s2,88(a0)
    80002efe:	0a893783          	ld	a5,168(s2)
    80002f02:	0007869b          	sext.w	a3,a5
    if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    80002f06:	37fd                	addiw	a5,a5,-1
    80002f08:	4761                	li	a4,24
    80002f0a:	00f76f63          	bltu	a4,a5,80002f28 <syscall+0x44>
    80002f0e:	00369713          	slli	a4,a3,0x3
    80002f12:	00006797          	auipc	a5,0x6
    80002f16:	95e78793          	addi	a5,a5,-1698 # 80008870 <syscalls>
    80002f1a:	97ba                	add	a5,a5,a4
    80002f1c:	639c                	ld	a5,0(a5)
    80002f1e:	c789                	beqz	a5,80002f28 <syscall+0x44>
    {
        // Use num to lookup the system call function for num, call it,
        // and store its return value in p->trapframe->a0
        p->trapframe->a0 = syscalls[num]();
    80002f20:	9782                	jalr	a5
    80002f22:	06a93823          	sd	a0,112(s2)
    80002f26:	a839                	j	80002f44 <syscall+0x60>
    }
    else
    {
        printf("%d %s: unknown sys call %d\n",
    80002f28:	15848613          	addi	a2,s1,344
    80002f2c:	588c                	lw	a1,48(s1)
    80002f2e:	00005517          	auipc	a0,0x5
    80002f32:	58250513          	addi	a0,a0,1410 # 800084b0 <etext+0x4b0>
    80002f36:	ffffd097          	auipc	ra,0xffffd
    80002f3a:	674080e7          	jalr	1652(ra) # 800005aa <printf>
               p->pid, p->name, num);
        p->trapframe->a0 = -1;
    80002f3e:	6cbc                	ld	a5,88(s1)
    80002f40:	577d                	li	a4,-1
    80002f42:	fbb8                	sd	a4,112(a5)
    }
}
    80002f44:	60e2                	ld	ra,24(sp)
    80002f46:	6442                	ld	s0,16(sp)
    80002f48:	64a2                	ld	s1,8(sp)
    80002f4a:	6902                	ld	s2,0(sp)
    80002f4c:	6105                	addi	sp,sp,32
    80002f4e:	8082                	ret

0000000080002f50 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002f50:	1101                	addi	sp,sp,-32
    80002f52:	ec06                	sd	ra,24(sp)
    80002f54:	e822                	sd	s0,16(sp)
    80002f56:	1000                	addi	s0,sp,32
    int n;
    argint(0, &n);
    80002f58:	fec40593          	addi	a1,s0,-20
    80002f5c:	4501                	li	a0,0
    80002f5e:	00000097          	auipc	ra,0x0
    80002f62:	f16080e7          	jalr	-234(ra) # 80002e74 <argint>
    exit(n);
    80002f66:	fec42503          	lw	a0,-20(s0)
    80002f6a:	fffff097          	auipc	ra,0xfffff
    80002f6e:	4e4080e7          	jalr	1252(ra) # 8000244e <exit>
    return 0; // not reached
}
    80002f72:	4501                	li	a0,0
    80002f74:	60e2                	ld	ra,24(sp)
    80002f76:	6442                	ld	s0,16(sp)
    80002f78:	6105                	addi	sp,sp,32
    80002f7a:	8082                	ret

0000000080002f7c <sys_getpid>:

uint64
sys_getpid(void)
{
    80002f7c:	1141                	addi	sp,sp,-16
    80002f7e:	e406                	sd	ra,8(sp)
    80002f80:	e022                	sd	s0,0(sp)
    80002f82:	0800                	addi	s0,sp,16
    return myproc()->pid;
    80002f84:	fffff097          	auipc	ra,0xfffff
    80002f88:	bbc080e7          	jalr	-1092(ra) # 80001b40 <myproc>
}
    80002f8c:	5908                	lw	a0,48(a0)
    80002f8e:	60a2                	ld	ra,8(sp)
    80002f90:	6402                	ld	s0,0(sp)
    80002f92:	0141                	addi	sp,sp,16
    80002f94:	8082                	ret

0000000080002f96 <sys_fork>:

uint64
sys_fork(void)
{
    80002f96:	1141                	addi	sp,sp,-16
    80002f98:	e406                	sd	ra,8(sp)
    80002f9a:	e022                	sd	s0,0(sp)
    80002f9c:	0800                	addi	s0,sp,16
    return fork();
    80002f9e:	fffff097          	auipc	ra,0xfffff
    80002fa2:	0f2080e7          	jalr	242(ra) # 80002090 <fork>
}
    80002fa6:	60a2                	ld	ra,8(sp)
    80002fa8:	6402                	ld	s0,0(sp)
    80002faa:	0141                	addi	sp,sp,16
    80002fac:	8082                	ret

0000000080002fae <sys_wait>:

uint64
sys_wait(void)
{
    80002fae:	1101                	addi	sp,sp,-32
    80002fb0:	ec06                	sd	ra,24(sp)
    80002fb2:	e822                	sd	s0,16(sp)
    80002fb4:	1000                	addi	s0,sp,32
    uint64 p;
    argaddr(0, &p);
    80002fb6:	fe840593          	addi	a1,s0,-24
    80002fba:	4501                	li	a0,0
    80002fbc:	00000097          	auipc	ra,0x0
    80002fc0:	ed8080e7          	jalr	-296(ra) # 80002e94 <argaddr>
    return wait(p);
    80002fc4:	fe843503          	ld	a0,-24(s0)
    80002fc8:	fffff097          	auipc	ra,0xfffff
    80002fcc:	62c080e7          	jalr	1580(ra) # 800025f4 <wait>
}
    80002fd0:	60e2                	ld	ra,24(sp)
    80002fd2:	6442                	ld	s0,16(sp)
    80002fd4:	6105                	addi	sp,sp,32
    80002fd6:	8082                	ret

0000000080002fd8 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002fd8:	7179                	addi	sp,sp,-48
    80002fda:	f406                	sd	ra,40(sp)
    80002fdc:	f022                	sd	s0,32(sp)
    80002fde:	ec26                	sd	s1,24(sp)
    80002fe0:	1800                	addi	s0,sp,48
    uint64 addr;
    int n;

    argint(0, &n);
    80002fe2:	fdc40593          	addi	a1,s0,-36
    80002fe6:	4501                	li	a0,0
    80002fe8:	00000097          	auipc	ra,0x0
    80002fec:	e8c080e7          	jalr	-372(ra) # 80002e74 <argint>
    addr = myproc()->sz;
    80002ff0:	fffff097          	auipc	ra,0xfffff
    80002ff4:	b50080e7          	jalr	-1200(ra) # 80001b40 <myproc>
    80002ff8:	6524                	ld	s1,72(a0)
    if (growproc(n) < 0)
    80002ffa:	fdc42503          	lw	a0,-36(s0)
    80002ffe:	fffff097          	auipc	ra,0xfffff
    80003002:	e9c080e7          	jalr	-356(ra) # 80001e9a <growproc>
    80003006:	00054863          	bltz	a0,80003016 <sys_sbrk+0x3e>
        return -1;
    return addr;
}
    8000300a:	8526                	mv	a0,s1
    8000300c:	70a2                	ld	ra,40(sp)
    8000300e:	7402                	ld	s0,32(sp)
    80003010:	64e2                	ld	s1,24(sp)
    80003012:	6145                	addi	sp,sp,48
    80003014:	8082                	ret
        return -1;
    80003016:	54fd                	li	s1,-1
    80003018:	bfcd                	j	8000300a <sys_sbrk+0x32>

000000008000301a <sys_sleep>:

uint64
sys_sleep(void)
{
    8000301a:	7139                	addi	sp,sp,-64
    8000301c:	fc06                	sd	ra,56(sp)
    8000301e:	f822                	sd	s0,48(sp)
    80003020:	f04a                	sd	s2,32(sp)
    80003022:	0080                	addi	s0,sp,64
    int n;
    uint ticks0;

    argint(0, &n);
    80003024:	fcc40593          	addi	a1,s0,-52
    80003028:	4501                	li	a0,0
    8000302a:	00000097          	auipc	ra,0x0
    8000302e:	e4a080e7          	jalr	-438(ra) # 80002e74 <argint>
    acquire(&tickslock);
    80003032:	00014517          	auipc	a0,0x14
    80003036:	a5e50513          	addi	a0,a0,-1442 # 80016a90 <tickslock>
    8000303a:	ffffe097          	auipc	ra,0xffffe
    8000303e:	c04080e7          	jalr	-1020(ra) # 80000c3e <acquire>
    ticks0 = ticks;
    80003042:	00006917          	auipc	s2,0x6
    80003046:	9ae92903          	lw	s2,-1618(s2) # 800089f0 <ticks>
    while (ticks - ticks0 < n)
    8000304a:	fcc42783          	lw	a5,-52(s0)
    8000304e:	c3b9                	beqz	a5,80003094 <sys_sleep+0x7a>
    80003050:	f426                	sd	s1,40(sp)
    80003052:	ec4e                	sd	s3,24(sp)
        if (killed(myproc()))
        {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
    80003054:	00014997          	auipc	s3,0x14
    80003058:	a3c98993          	addi	s3,s3,-1476 # 80016a90 <tickslock>
    8000305c:	00006497          	auipc	s1,0x6
    80003060:	99448493          	addi	s1,s1,-1644 # 800089f0 <ticks>
        if (killed(myproc()))
    80003064:	fffff097          	auipc	ra,0xfffff
    80003068:	adc080e7          	jalr	-1316(ra) # 80001b40 <myproc>
    8000306c:	fffff097          	auipc	ra,0xfffff
    80003070:	556080e7          	jalr	1366(ra) # 800025c2 <killed>
    80003074:	ed15                	bnez	a0,800030b0 <sys_sleep+0x96>
        sleep(&ticks, &tickslock);
    80003076:	85ce                	mv	a1,s3
    80003078:	8526                	mv	a0,s1
    8000307a:	fffff097          	auipc	ra,0xfffff
    8000307e:	2a0080e7          	jalr	672(ra) # 8000231a <sleep>
    while (ticks - ticks0 < n)
    80003082:	409c                	lw	a5,0(s1)
    80003084:	412787bb          	subw	a5,a5,s2
    80003088:	fcc42703          	lw	a4,-52(s0)
    8000308c:	fce7ece3          	bltu	a5,a4,80003064 <sys_sleep+0x4a>
    80003090:	74a2                	ld	s1,40(sp)
    80003092:	69e2                	ld	s3,24(sp)
    }
    release(&tickslock);
    80003094:	00014517          	auipc	a0,0x14
    80003098:	9fc50513          	addi	a0,a0,-1540 # 80016a90 <tickslock>
    8000309c:	ffffe097          	auipc	ra,0xffffe
    800030a0:	c52080e7          	jalr	-942(ra) # 80000cee <release>
    return 0;
    800030a4:	4501                	li	a0,0
}
    800030a6:	70e2                	ld	ra,56(sp)
    800030a8:	7442                	ld	s0,48(sp)
    800030aa:	7902                	ld	s2,32(sp)
    800030ac:	6121                	addi	sp,sp,64
    800030ae:	8082                	ret
            release(&tickslock);
    800030b0:	00014517          	auipc	a0,0x14
    800030b4:	9e050513          	addi	a0,a0,-1568 # 80016a90 <tickslock>
    800030b8:	ffffe097          	auipc	ra,0xffffe
    800030bc:	c36080e7          	jalr	-970(ra) # 80000cee <release>
            return -1;
    800030c0:	557d                	li	a0,-1
    800030c2:	74a2                	ld	s1,40(sp)
    800030c4:	69e2                	ld	s3,24(sp)
    800030c6:	b7c5                	j	800030a6 <sys_sleep+0x8c>

00000000800030c8 <sys_kill>:

uint64
sys_kill(void)
{
    800030c8:	1101                	addi	sp,sp,-32
    800030ca:	ec06                	sd	ra,24(sp)
    800030cc:	e822                	sd	s0,16(sp)
    800030ce:	1000                	addi	s0,sp,32
    int pid;

    argint(0, &pid);
    800030d0:	fec40593          	addi	a1,s0,-20
    800030d4:	4501                	li	a0,0
    800030d6:	00000097          	auipc	ra,0x0
    800030da:	d9e080e7          	jalr	-610(ra) # 80002e74 <argint>
    return kill(pid);
    800030de:	fec42503          	lw	a0,-20(s0)
    800030e2:	fffff097          	auipc	ra,0xfffff
    800030e6:	442080e7          	jalr	1090(ra) # 80002524 <kill>
}
    800030ea:	60e2                	ld	ra,24(sp)
    800030ec:	6442                	ld	s0,16(sp)
    800030ee:	6105                	addi	sp,sp,32
    800030f0:	8082                	ret

00000000800030f2 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800030f2:	1101                	addi	sp,sp,-32
    800030f4:	ec06                	sd	ra,24(sp)
    800030f6:	e822                	sd	s0,16(sp)
    800030f8:	e426                	sd	s1,8(sp)
    800030fa:	1000                	addi	s0,sp,32
    uint xticks;

    acquire(&tickslock);
    800030fc:	00014517          	auipc	a0,0x14
    80003100:	99450513          	addi	a0,a0,-1644 # 80016a90 <tickslock>
    80003104:	ffffe097          	auipc	ra,0xffffe
    80003108:	b3a080e7          	jalr	-1222(ra) # 80000c3e <acquire>
    xticks = ticks;
    8000310c:	00006497          	auipc	s1,0x6
    80003110:	8e44a483          	lw	s1,-1820(s1) # 800089f0 <ticks>
    release(&tickslock);
    80003114:	00014517          	auipc	a0,0x14
    80003118:	97c50513          	addi	a0,a0,-1668 # 80016a90 <tickslock>
    8000311c:	ffffe097          	auipc	ra,0xffffe
    80003120:	bd2080e7          	jalr	-1070(ra) # 80000cee <release>
    return xticks;
}
    80003124:	02049513          	slli	a0,s1,0x20
    80003128:	9101                	srli	a0,a0,0x20
    8000312a:	60e2                	ld	ra,24(sp)
    8000312c:	6442                	ld	s0,16(sp)
    8000312e:	64a2                	ld	s1,8(sp)
    80003130:	6105                	addi	sp,sp,32
    80003132:	8082                	ret

0000000080003134 <sys_ps>:

void *
sys_ps(void)
{
    80003134:	1101                	addi	sp,sp,-32
    80003136:	ec06                	sd	ra,24(sp)
    80003138:	e822                	sd	s0,16(sp)
    8000313a:	1000                	addi	s0,sp,32
    int start = 0, count = 0;
    8000313c:	fe042623          	sw	zero,-20(s0)
    80003140:	fe042423          	sw	zero,-24(s0)
    argint(0, &start);
    80003144:	fec40593          	addi	a1,s0,-20
    80003148:	4501                	li	a0,0
    8000314a:	00000097          	auipc	ra,0x0
    8000314e:	d2a080e7          	jalr	-726(ra) # 80002e74 <argint>
    argint(1, &count);
    80003152:	fe840593          	addi	a1,s0,-24
    80003156:	4505                	li	a0,1
    80003158:	00000097          	auipc	ra,0x0
    8000315c:	d1c080e7          	jalr	-740(ra) # 80002e74 <argint>
    return ps((uint8)start, (uint8)count);
    80003160:	fe844583          	lbu	a1,-24(s0)
    80003164:	fec44503          	lbu	a0,-20(s0)
    80003168:	fffff097          	auipc	ra,0xfffff
    8000316c:	d8e080e7          	jalr	-626(ra) # 80001ef6 <ps>
}
    80003170:	60e2                	ld	ra,24(sp)
    80003172:	6442                	ld	s0,16(sp)
    80003174:	6105                	addi	sp,sp,32
    80003176:	8082                	ret

0000000080003178 <sys_schedls>:

uint64 sys_schedls(void)
{
    80003178:	1141                	addi	sp,sp,-16
    8000317a:	e406                	sd	ra,8(sp)
    8000317c:	e022                	sd	s0,0(sp)
    8000317e:	0800                	addi	s0,sp,16
    schedls();
    80003180:	fffff097          	auipc	ra,0xfffff
    80003184:	6f8080e7          	jalr	1784(ra) # 80002878 <schedls>
    return 0;
}
    80003188:	4501                	li	a0,0
    8000318a:	60a2                	ld	ra,8(sp)
    8000318c:	6402                	ld	s0,0(sp)
    8000318e:	0141                	addi	sp,sp,16
    80003190:	8082                	ret

0000000080003192 <sys_schedset>:

uint64 sys_schedset(void)
{
    80003192:	1101                	addi	sp,sp,-32
    80003194:	ec06                	sd	ra,24(sp)
    80003196:	e822                	sd	s0,16(sp)
    80003198:	1000                	addi	s0,sp,32
    int id = 0;
    8000319a:	fe042623          	sw	zero,-20(s0)
    argint(0, &id);
    8000319e:	fec40593          	addi	a1,s0,-20
    800031a2:	4501                	li	a0,0
    800031a4:	00000097          	auipc	ra,0x0
    800031a8:	cd0080e7          	jalr	-816(ra) # 80002e74 <argint>
    schedset(id - 1);
    800031ac:	fec42503          	lw	a0,-20(s0)
    800031b0:	357d                	addiw	a0,a0,-1
    800031b2:	fffff097          	auipc	ra,0xfffff
    800031b6:	75c080e7          	jalr	1884(ra) # 8000290e <schedset>
    return 0;
}
    800031ba:	4501                	li	a0,0
    800031bc:	60e2                	ld	ra,24(sp)
    800031be:	6442                	ld	s0,16(sp)
    800031c0:	6105                	addi	sp,sp,32
    800031c2:	8082                	ret

00000000800031c4 <sys_yield>:

uint64 sys_yield(void)
{
    800031c4:	1141                	addi	sp,sp,-16
    800031c6:	e406                	sd	ra,8(sp)
    800031c8:	e022                	sd	s0,0(sp)
    800031ca:	0800                	addi	s0,sp,16
    yield(YIELD_OTHER);
    800031cc:	4509                	li	a0,2
    800031ce:	fffff097          	auipc	ra,0xfffff
    800031d2:	110080e7          	jalr	272(ra) # 800022de <yield>
    return 0;
    800031d6:	4501                	li	a0,0
    800031d8:	60a2                	ld	ra,8(sp)
    800031da:	6402                	ld	s0,0(sp)
    800031dc:	0141                	addi	sp,sp,16
    800031de:	8082                	ret

00000000800031e0 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800031e0:	7179                	addi	sp,sp,-48
    800031e2:	f406                	sd	ra,40(sp)
    800031e4:	f022                	sd	s0,32(sp)
    800031e6:	ec26                	sd	s1,24(sp)
    800031e8:	e84a                	sd	s2,16(sp)
    800031ea:	e44e                	sd	s3,8(sp)
    800031ec:	e052                	sd	s4,0(sp)
    800031ee:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800031f0:	00005597          	auipc	a1,0x5
    800031f4:	2e058593          	addi	a1,a1,736 # 800084d0 <etext+0x4d0>
    800031f8:	00014517          	auipc	a0,0x14
    800031fc:	8b050513          	addi	a0,a0,-1872 # 80016aa8 <bcache>
    80003200:	ffffe097          	auipc	ra,0xffffe
    80003204:	9aa080e7          	jalr	-1622(ra) # 80000baa <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003208:	0001c797          	auipc	a5,0x1c
    8000320c:	8a078793          	addi	a5,a5,-1888 # 8001eaa8 <bcache+0x8000>
    80003210:	0001c717          	auipc	a4,0x1c
    80003214:	b0070713          	addi	a4,a4,-1280 # 8001ed10 <bcache+0x8268>
    80003218:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000321c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003220:	00014497          	auipc	s1,0x14
    80003224:	8a048493          	addi	s1,s1,-1888 # 80016ac0 <bcache+0x18>
    b->next = bcache.head.next;
    80003228:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000322a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000322c:	00005a17          	auipc	s4,0x5
    80003230:	2aca0a13          	addi	s4,s4,684 # 800084d8 <etext+0x4d8>
    b->next = bcache.head.next;
    80003234:	2b893783          	ld	a5,696(s2)
    80003238:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000323a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000323e:	85d2                	mv	a1,s4
    80003240:	01048513          	addi	a0,s1,16
    80003244:	00001097          	auipc	ra,0x1
    80003248:	4e4080e7          	jalr	1252(ra) # 80004728 <initsleeplock>
    bcache.head.next->prev = b;
    8000324c:	2b893783          	ld	a5,696(s2)
    80003250:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003252:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003256:	45848493          	addi	s1,s1,1112
    8000325a:	fd349de3          	bne	s1,s3,80003234 <binit+0x54>
  }
}
    8000325e:	70a2                	ld	ra,40(sp)
    80003260:	7402                	ld	s0,32(sp)
    80003262:	64e2                	ld	s1,24(sp)
    80003264:	6942                	ld	s2,16(sp)
    80003266:	69a2                	ld	s3,8(sp)
    80003268:	6a02                	ld	s4,0(sp)
    8000326a:	6145                	addi	sp,sp,48
    8000326c:	8082                	ret

000000008000326e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000326e:	7179                	addi	sp,sp,-48
    80003270:	f406                	sd	ra,40(sp)
    80003272:	f022                	sd	s0,32(sp)
    80003274:	ec26                	sd	s1,24(sp)
    80003276:	e84a                	sd	s2,16(sp)
    80003278:	e44e                	sd	s3,8(sp)
    8000327a:	1800                	addi	s0,sp,48
    8000327c:	892a                	mv	s2,a0
    8000327e:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003280:	00014517          	auipc	a0,0x14
    80003284:	82850513          	addi	a0,a0,-2008 # 80016aa8 <bcache>
    80003288:	ffffe097          	auipc	ra,0xffffe
    8000328c:	9b6080e7          	jalr	-1610(ra) # 80000c3e <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003290:	0001c497          	auipc	s1,0x1c
    80003294:	ad04b483          	ld	s1,-1328(s1) # 8001ed60 <bcache+0x82b8>
    80003298:	0001c797          	auipc	a5,0x1c
    8000329c:	a7878793          	addi	a5,a5,-1416 # 8001ed10 <bcache+0x8268>
    800032a0:	02f48f63          	beq	s1,a5,800032de <bread+0x70>
    800032a4:	873e                	mv	a4,a5
    800032a6:	a021                	j	800032ae <bread+0x40>
    800032a8:	68a4                	ld	s1,80(s1)
    800032aa:	02e48a63          	beq	s1,a4,800032de <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800032ae:	449c                	lw	a5,8(s1)
    800032b0:	ff279ce3          	bne	a5,s2,800032a8 <bread+0x3a>
    800032b4:	44dc                	lw	a5,12(s1)
    800032b6:	ff3799e3          	bne	a5,s3,800032a8 <bread+0x3a>
      b->refcnt++;
    800032ba:	40bc                	lw	a5,64(s1)
    800032bc:	2785                	addiw	a5,a5,1
    800032be:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800032c0:	00013517          	auipc	a0,0x13
    800032c4:	7e850513          	addi	a0,a0,2024 # 80016aa8 <bcache>
    800032c8:	ffffe097          	auipc	ra,0xffffe
    800032cc:	a26080e7          	jalr	-1498(ra) # 80000cee <release>
      acquiresleep(&b->lock);
    800032d0:	01048513          	addi	a0,s1,16
    800032d4:	00001097          	auipc	ra,0x1
    800032d8:	48e080e7          	jalr	1166(ra) # 80004762 <acquiresleep>
      return b;
    800032dc:	a8b9                	j	8000333a <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800032de:	0001c497          	auipc	s1,0x1c
    800032e2:	a7a4b483          	ld	s1,-1414(s1) # 8001ed58 <bcache+0x82b0>
    800032e6:	0001c797          	auipc	a5,0x1c
    800032ea:	a2a78793          	addi	a5,a5,-1494 # 8001ed10 <bcache+0x8268>
    800032ee:	00f48863          	beq	s1,a5,800032fe <bread+0x90>
    800032f2:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800032f4:	40bc                	lw	a5,64(s1)
    800032f6:	cf81                	beqz	a5,8000330e <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800032f8:	64a4                	ld	s1,72(s1)
    800032fa:	fee49de3          	bne	s1,a4,800032f4 <bread+0x86>
  panic("bget: no buffers");
    800032fe:	00005517          	auipc	a0,0x5
    80003302:	1e250513          	addi	a0,a0,482 # 800084e0 <etext+0x4e0>
    80003306:	ffffd097          	auipc	ra,0xffffd
    8000330a:	25a080e7          	jalr	602(ra) # 80000560 <panic>
      b->dev = dev;
    8000330e:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003312:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003316:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000331a:	4785                	li	a5,1
    8000331c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000331e:	00013517          	auipc	a0,0x13
    80003322:	78a50513          	addi	a0,a0,1930 # 80016aa8 <bcache>
    80003326:	ffffe097          	auipc	ra,0xffffe
    8000332a:	9c8080e7          	jalr	-1592(ra) # 80000cee <release>
      acquiresleep(&b->lock);
    8000332e:	01048513          	addi	a0,s1,16
    80003332:	00001097          	auipc	ra,0x1
    80003336:	430080e7          	jalr	1072(ra) # 80004762 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000333a:	409c                	lw	a5,0(s1)
    8000333c:	cb89                	beqz	a5,8000334e <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000333e:	8526                	mv	a0,s1
    80003340:	70a2                	ld	ra,40(sp)
    80003342:	7402                	ld	s0,32(sp)
    80003344:	64e2                	ld	s1,24(sp)
    80003346:	6942                	ld	s2,16(sp)
    80003348:	69a2                	ld	s3,8(sp)
    8000334a:	6145                	addi	sp,sp,48
    8000334c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000334e:	4581                	li	a1,0
    80003350:	8526                	mv	a0,s1
    80003352:	00003097          	auipc	ra,0x3
    80003356:	106080e7          	jalr	262(ra) # 80006458 <virtio_disk_rw>
    b->valid = 1;
    8000335a:	4785                	li	a5,1
    8000335c:	c09c                	sw	a5,0(s1)
  return b;
    8000335e:	b7c5                	j	8000333e <bread+0xd0>

0000000080003360 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003360:	1101                	addi	sp,sp,-32
    80003362:	ec06                	sd	ra,24(sp)
    80003364:	e822                	sd	s0,16(sp)
    80003366:	e426                	sd	s1,8(sp)
    80003368:	1000                	addi	s0,sp,32
    8000336a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000336c:	0541                	addi	a0,a0,16
    8000336e:	00001097          	auipc	ra,0x1
    80003372:	48e080e7          	jalr	1166(ra) # 800047fc <holdingsleep>
    80003376:	cd01                	beqz	a0,8000338e <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003378:	4585                	li	a1,1
    8000337a:	8526                	mv	a0,s1
    8000337c:	00003097          	auipc	ra,0x3
    80003380:	0dc080e7          	jalr	220(ra) # 80006458 <virtio_disk_rw>
}
    80003384:	60e2                	ld	ra,24(sp)
    80003386:	6442                	ld	s0,16(sp)
    80003388:	64a2                	ld	s1,8(sp)
    8000338a:	6105                	addi	sp,sp,32
    8000338c:	8082                	ret
    panic("bwrite");
    8000338e:	00005517          	auipc	a0,0x5
    80003392:	16a50513          	addi	a0,a0,362 # 800084f8 <etext+0x4f8>
    80003396:	ffffd097          	auipc	ra,0xffffd
    8000339a:	1ca080e7          	jalr	458(ra) # 80000560 <panic>

000000008000339e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000339e:	1101                	addi	sp,sp,-32
    800033a0:	ec06                	sd	ra,24(sp)
    800033a2:	e822                	sd	s0,16(sp)
    800033a4:	e426                	sd	s1,8(sp)
    800033a6:	e04a                	sd	s2,0(sp)
    800033a8:	1000                	addi	s0,sp,32
    800033aa:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800033ac:	01050913          	addi	s2,a0,16
    800033b0:	854a                	mv	a0,s2
    800033b2:	00001097          	auipc	ra,0x1
    800033b6:	44a080e7          	jalr	1098(ra) # 800047fc <holdingsleep>
    800033ba:	c535                	beqz	a0,80003426 <brelse+0x88>
    panic("brelse");

  releasesleep(&b->lock);
    800033bc:	854a                	mv	a0,s2
    800033be:	00001097          	auipc	ra,0x1
    800033c2:	3fa080e7          	jalr	1018(ra) # 800047b8 <releasesleep>

  acquire(&bcache.lock);
    800033c6:	00013517          	auipc	a0,0x13
    800033ca:	6e250513          	addi	a0,a0,1762 # 80016aa8 <bcache>
    800033ce:	ffffe097          	auipc	ra,0xffffe
    800033d2:	870080e7          	jalr	-1936(ra) # 80000c3e <acquire>
  b->refcnt--;
    800033d6:	40bc                	lw	a5,64(s1)
    800033d8:	37fd                	addiw	a5,a5,-1
    800033da:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800033dc:	e79d                	bnez	a5,8000340a <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800033de:	68b8                	ld	a4,80(s1)
    800033e0:	64bc                	ld	a5,72(s1)
    800033e2:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800033e4:	68b8                	ld	a4,80(s1)
    800033e6:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800033e8:	0001b797          	auipc	a5,0x1b
    800033ec:	6c078793          	addi	a5,a5,1728 # 8001eaa8 <bcache+0x8000>
    800033f0:	2b87b703          	ld	a4,696(a5)
    800033f4:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800033f6:	0001c717          	auipc	a4,0x1c
    800033fa:	91a70713          	addi	a4,a4,-1766 # 8001ed10 <bcache+0x8268>
    800033fe:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003400:	2b87b703          	ld	a4,696(a5)
    80003404:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003406:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000340a:	00013517          	auipc	a0,0x13
    8000340e:	69e50513          	addi	a0,a0,1694 # 80016aa8 <bcache>
    80003412:	ffffe097          	auipc	ra,0xffffe
    80003416:	8dc080e7          	jalr	-1828(ra) # 80000cee <release>
}
    8000341a:	60e2                	ld	ra,24(sp)
    8000341c:	6442                	ld	s0,16(sp)
    8000341e:	64a2                	ld	s1,8(sp)
    80003420:	6902                	ld	s2,0(sp)
    80003422:	6105                	addi	sp,sp,32
    80003424:	8082                	ret
    panic("brelse");
    80003426:	00005517          	auipc	a0,0x5
    8000342a:	0da50513          	addi	a0,a0,218 # 80008500 <etext+0x500>
    8000342e:	ffffd097          	auipc	ra,0xffffd
    80003432:	132080e7          	jalr	306(ra) # 80000560 <panic>

0000000080003436 <bpin>:

void
bpin(struct buf *b) {
    80003436:	1101                	addi	sp,sp,-32
    80003438:	ec06                	sd	ra,24(sp)
    8000343a:	e822                	sd	s0,16(sp)
    8000343c:	e426                	sd	s1,8(sp)
    8000343e:	1000                	addi	s0,sp,32
    80003440:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003442:	00013517          	auipc	a0,0x13
    80003446:	66650513          	addi	a0,a0,1638 # 80016aa8 <bcache>
    8000344a:	ffffd097          	auipc	ra,0xffffd
    8000344e:	7f4080e7          	jalr	2036(ra) # 80000c3e <acquire>
  b->refcnt++;
    80003452:	40bc                	lw	a5,64(s1)
    80003454:	2785                	addiw	a5,a5,1
    80003456:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003458:	00013517          	auipc	a0,0x13
    8000345c:	65050513          	addi	a0,a0,1616 # 80016aa8 <bcache>
    80003460:	ffffe097          	auipc	ra,0xffffe
    80003464:	88e080e7          	jalr	-1906(ra) # 80000cee <release>
}
    80003468:	60e2                	ld	ra,24(sp)
    8000346a:	6442                	ld	s0,16(sp)
    8000346c:	64a2                	ld	s1,8(sp)
    8000346e:	6105                	addi	sp,sp,32
    80003470:	8082                	ret

0000000080003472 <bunpin>:

void
bunpin(struct buf *b) {
    80003472:	1101                	addi	sp,sp,-32
    80003474:	ec06                	sd	ra,24(sp)
    80003476:	e822                	sd	s0,16(sp)
    80003478:	e426                	sd	s1,8(sp)
    8000347a:	1000                	addi	s0,sp,32
    8000347c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000347e:	00013517          	auipc	a0,0x13
    80003482:	62a50513          	addi	a0,a0,1578 # 80016aa8 <bcache>
    80003486:	ffffd097          	auipc	ra,0xffffd
    8000348a:	7b8080e7          	jalr	1976(ra) # 80000c3e <acquire>
  b->refcnt--;
    8000348e:	40bc                	lw	a5,64(s1)
    80003490:	37fd                	addiw	a5,a5,-1
    80003492:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003494:	00013517          	auipc	a0,0x13
    80003498:	61450513          	addi	a0,a0,1556 # 80016aa8 <bcache>
    8000349c:	ffffe097          	auipc	ra,0xffffe
    800034a0:	852080e7          	jalr	-1966(ra) # 80000cee <release>
}
    800034a4:	60e2                	ld	ra,24(sp)
    800034a6:	6442                	ld	s0,16(sp)
    800034a8:	64a2                	ld	s1,8(sp)
    800034aa:	6105                	addi	sp,sp,32
    800034ac:	8082                	ret

00000000800034ae <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800034ae:	1101                	addi	sp,sp,-32
    800034b0:	ec06                	sd	ra,24(sp)
    800034b2:	e822                	sd	s0,16(sp)
    800034b4:	e426                	sd	s1,8(sp)
    800034b6:	e04a                	sd	s2,0(sp)
    800034b8:	1000                	addi	s0,sp,32
    800034ba:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800034bc:	00d5d79b          	srliw	a5,a1,0xd
    800034c0:	0001c597          	auipc	a1,0x1c
    800034c4:	cc45a583          	lw	a1,-828(a1) # 8001f184 <sb+0x1c>
    800034c8:	9dbd                	addw	a1,a1,a5
    800034ca:	00000097          	auipc	ra,0x0
    800034ce:	da4080e7          	jalr	-604(ra) # 8000326e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800034d2:	0074f713          	andi	a4,s1,7
    800034d6:	4785                	li	a5,1
    800034d8:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    800034dc:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    800034de:	90d9                	srli	s1,s1,0x36
    800034e0:	00950733          	add	a4,a0,s1
    800034e4:	05874703          	lbu	a4,88(a4)
    800034e8:	00e7f6b3          	and	a3,a5,a4
    800034ec:	c69d                	beqz	a3,8000351a <bfree+0x6c>
    800034ee:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800034f0:	94aa                	add	s1,s1,a0
    800034f2:	fff7c793          	not	a5,a5
    800034f6:	8f7d                	and	a4,a4,a5
    800034f8:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800034fc:	00001097          	auipc	ra,0x1
    80003500:	148080e7          	jalr	328(ra) # 80004644 <log_write>
  brelse(bp);
    80003504:	854a                	mv	a0,s2
    80003506:	00000097          	auipc	ra,0x0
    8000350a:	e98080e7          	jalr	-360(ra) # 8000339e <brelse>
}
    8000350e:	60e2                	ld	ra,24(sp)
    80003510:	6442                	ld	s0,16(sp)
    80003512:	64a2                	ld	s1,8(sp)
    80003514:	6902                	ld	s2,0(sp)
    80003516:	6105                	addi	sp,sp,32
    80003518:	8082                	ret
    panic("freeing free block");
    8000351a:	00005517          	auipc	a0,0x5
    8000351e:	fee50513          	addi	a0,a0,-18 # 80008508 <etext+0x508>
    80003522:	ffffd097          	auipc	ra,0xffffd
    80003526:	03e080e7          	jalr	62(ra) # 80000560 <panic>

000000008000352a <balloc>:
{
    8000352a:	715d                	addi	sp,sp,-80
    8000352c:	e486                	sd	ra,72(sp)
    8000352e:	e0a2                	sd	s0,64(sp)
    80003530:	fc26                	sd	s1,56(sp)
    80003532:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    80003534:	0001c797          	auipc	a5,0x1c
    80003538:	c387a783          	lw	a5,-968(a5) # 8001f16c <sb+0x4>
    8000353c:	10078863          	beqz	a5,8000364c <balloc+0x122>
    80003540:	f84a                	sd	s2,48(sp)
    80003542:	f44e                	sd	s3,40(sp)
    80003544:	f052                	sd	s4,32(sp)
    80003546:	ec56                	sd	s5,24(sp)
    80003548:	e85a                	sd	s6,16(sp)
    8000354a:	e45e                	sd	s7,8(sp)
    8000354c:	e062                	sd	s8,0(sp)
    8000354e:	8baa                	mv	s7,a0
    80003550:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003552:	0001cb17          	auipc	s6,0x1c
    80003556:	c16b0b13          	addi	s6,s6,-1002 # 8001f168 <sb>
      m = 1 << (bi % 8);
    8000355a:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000355c:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000355e:	6c09                	lui	s8,0x2
    80003560:	a049                	j	800035e2 <balloc+0xb8>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003562:	97ca                	add	a5,a5,s2
    80003564:	8e55                	or	a2,a2,a3
    80003566:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000356a:	854a                	mv	a0,s2
    8000356c:	00001097          	auipc	ra,0x1
    80003570:	0d8080e7          	jalr	216(ra) # 80004644 <log_write>
        brelse(bp);
    80003574:	854a                	mv	a0,s2
    80003576:	00000097          	auipc	ra,0x0
    8000357a:	e28080e7          	jalr	-472(ra) # 8000339e <brelse>
  bp = bread(dev, bno);
    8000357e:	85a6                	mv	a1,s1
    80003580:	855e                	mv	a0,s7
    80003582:	00000097          	auipc	ra,0x0
    80003586:	cec080e7          	jalr	-788(ra) # 8000326e <bread>
    8000358a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000358c:	40000613          	li	a2,1024
    80003590:	4581                	li	a1,0
    80003592:	05850513          	addi	a0,a0,88
    80003596:	ffffd097          	auipc	ra,0xffffd
    8000359a:	7a0080e7          	jalr	1952(ra) # 80000d36 <memset>
  log_write(bp);
    8000359e:	854a                	mv	a0,s2
    800035a0:	00001097          	auipc	ra,0x1
    800035a4:	0a4080e7          	jalr	164(ra) # 80004644 <log_write>
  brelse(bp);
    800035a8:	854a                	mv	a0,s2
    800035aa:	00000097          	auipc	ra,0x0
    800035ae:	df4080e7          	jalr	-524(ra) # 8000339e <brelse>
}
    800035b2:	7942                	ld	s2,48(sp)
    800035b4:	79a2                	ld	s3,40(sp)
    800035b6:	7a02                	ld	s4,32(sp)
    800035b8:	6ae2                	ld	s5,24(sp)
    800035ba:	6b42                	ld	s6,16(sp)
    800035bc:	6ba2                	ld	s7,8(sp)
    800035be:	6c02                	ld	s8,0(sp)
}
    800035c0:	8526                	mv	a0,s1
    800035c2:	60a6                	ld	ra,72(sp)
    800035c4:	6406                	ld	s0,64(sp)
    800035c6:	74e2                	ld	s1,56(sp)
    800035c8:	6161                	addi	sp,sp,80
    800035ca:	8082                	ret
    brelse(bp);
    800035cc:	854a                	mv	a0,s2
    800035ce:	00000097          	auipc	ra,0x0
    800035d2:	dd0080e7          	jalr	-560(ra) # 8000339e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800035d6:	015c0abb          	addw	s5,s8,s5
    800035da:	004b2783          	lw	a5,4(s6)
    800035de:	06faf063          	bgeu	s5,a5,8000363e <balloc+0x114>
    bp = bread(dev, BBLOCK(b, sb));
    800035e2:	41fad79b          	sraiw	a5,s5,0x1f
    800035e6:	0137d79b          	srliw	a5,a5,0x13
    800035ea:	015787bb          	addw	a5,a5,s5
    800035ee:	40d7d79b          	sraiw	a5,a5,0xd
    800035f2:	01cb2583          	lw	a1,28(s6)
    800035f6:	9dbd                	addw	a1,a1,a5
    800035f8:	855e                	mv	a0,s7
    800035fa:	00000097          	auipc	ra,0x0
    800035fe:	c74080e7          	jalr	-908(ra) # 8000326e <bread>
    80003602:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003604:	004b2503          	lw	a0,4(s6)
    80003608:	84d6                	mv	s1,s5
    8000360a:	4701                	li	a4,0
    8000360c:	fca4f0e3          	bgeu	s1,a0,800035cc <balloc+0xa2>
      m = 1 << (bi % 8);
    80003610:	00777693          	andi	a3,a4,7
    80003614:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003618:	41f7579b          	sraiw	a5,a4,0x1f
    8000361c:	01d7d79b          	srliw	a5,a5,0x1d
    80003620:	9fb9                	addw	a5,a5,a4
    80003622:	4037d79b          	sraiw	a5,a5,0x3
    80003626:	00f90633          	add	a2,s2,a5
    8000362a:	05864603          	lbu	a2,88(a2)
    8000362e:	00c6f5b3          	and	a1,a3,a2
    80003632:	d985                	beqz	a1,80003562 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003634:	2705                	addiw	a4,a4,1
    80003636:	2485                	addiw	s1,s1,1
    80003638:	fd471ae3          	bne	a4,s4,8000360c <balloc+0xe2>
    8000363c:	bf41                	j	800035cc <balloc+0xa2>
    8000363e:	7942                	ld	s2,48(sp)
    80003640:	79a2                	ld	s3,40(sp)
    80003642:	7a02                	ld	s4,32(sp)
    80003644:	6ae2                	ld	s5,24(sp)
    80003646:	6b42                	ld	s6,16(sp)
    80003648:	6ba2                	ld	s7,8(sp)
    8000364a:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    8000364c:	00005517          	auipc	a0,0x5
    80003650:	ed450513          	addi	a0,a0,-300 # 80008520 <etext+0x520>
    80003654:	ffffd097          	auipc	ra,0xffffd
    80003658:	f56080e7          	jalr	-170(ra) # 800005aa <printf>
  return 0;
    8000365c:	4481                	li	s1,0
    8000365e:	b78d                	j	800035c0 <balloc+0x96>

0000000080003660 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003660:	7179                	addi	sp,sp,-48
    80003662:	f406                	sd	ra,40(sp)
    80003664:	f022                	sd	s0,32(sp)
    80003666:	ec26                	sd	s1,24(sp)
    80003668:	e84a                	sd	s2,16(sp)
    8000366a:	e44e                	sd	s3,8(sp)
    8000366c:	1800                	addi	s0,sp,48
    8000366e:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003670:	47ad                	li	a5,11
    80003672:	02b7e563          	bltu	a5,a1,8000369c <bmap+0x3c>
    if((addr = ip->addrs[bn]) == 0){
    80003676:	02059793          	slli	a5,a1,0x20
    8000367a:	01e7d593          	srli	a1,a5,0x1e
    8000367e:	00b504b3          	add	s1,a0,a1
    80003682:	0504a903          	lw	s2,80(s1)
    80003686:	06091b63          	bnez	s2,800036fc <bmap+0x9c>
      addr = balloc(ip->dev);
    8000368a:	4108                	lw	a0,0(a0)
    8000368c:	00000097          	auipc	ra,0x0
    80003690:	e9e080e7          	jalr	-354(ra) # 8000352a <balloc>
    80003694:	892a                	mv	s2,a0
      if(addr == 0)
    80003696:	c13d                	beqz	a0,800036fc <bmap+0x9c>
        return 0;
      ip->addrs[bn] = addr;
    80003698:	c8a8                	sw	a0,80(s1)
    8000369a:	a08d                	j	800036fc <bmap+0x9c>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000369c:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    800036a0:	0ff00793          	li	a5,255
    800036a4:	0897e363          	bltu	a5,s1,8000372a <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800036a8:	08052903          	lw	s2,128(a0)
    800036ac:	00091d63          	bnez	s2,800036c6 <bmap+0x66>
      addr = balloc(ip->dev);
    800036b0:	4108                	lw	a0,0(a0)
    800036b2:	00000097          	auipc	ra,0x0
    800036b6:	e78080e7          	jalr	-392(ra) # 8000352a <balloc>
    800036ba:	892a                	mv	s2,a0
      if(addr == 0)
    800036bc:	c121                	beqz	a0,800036fc <bmap+0x9c>
    800036be:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800036c0:	08a9a023          	sw	a0,128(s3)
    800036c4:	a011                	j	800036c8 <bmap+0x68>
    800036c6:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800036c8:	85ca                	mv	a1,s2
    800036ca:	0009a503          	lw	a0,0(s3)
    800036ce:	00000097          	auipc	ra,0x0
    800036d2:	ba0080e7          	jalr	-1120(ra) # 8000326e <bread>
    800036d6:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800036d8:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800036dc:	02049713          	slli	a4,s1,0x20
    800036e0:	01e75593          	srli	a1,a4,0x1e
    800036e4:	00b784b3          	add	s1,a5,a1
    800036e8:	0004a903          	lw	s2,0(s1)
    800036ec:	02090063          	beqz	s2,8000370c <bmap+0xac>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800036f0:	8552                	mv	a0,s4
    800036f2:	00000097          	auipc	ra,0x0
    800036f6:	cac080e7          	jalr	-852(ra) # 8000339e <brelse>
    return addr;
    800036fa:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800036fc:	854a                	mv	a0,s2
    800036fe:	70a2                	ld	ra,40(sp)
    80003700:	7402                	ld	s0,32(sp)
    80003702:	64e2                	ld	s1,24(sp)
    80003704:	6942                	ld	s2,16(sp)
    80003706:	69a2                	ld	s3,8(sp)
    80003708:	6145                	addi	sp,sp,48
    8000370a:	8082                	ret
      addr = balloc(ip->dev);
    8000370c:	0009a503          	lw	a0,0(s3)
    80003710:	00000097          	auipc	ra,0x0
    80003714:	e1a080e7          	jalr	-486(ra) # 8000352a <balloc>
    80003718:	892a                	mv	s2,a0
      if(addr){
    8000371a:	d979                	beqz	a0,800036f0 <bmap+0x90>
        a[bn] = addr;
    8000371c:	c088                	sw	a0,0(s1)
        log_write(bp);
    8000371e:	8552                	mv	a0,s4
    80003720:	00001097          	auipc	ra,0x1
    80003724:	f24080e7          	jalr	-220(ra) # 80004644 <log_write>
    80003728:	b7e1                	j	800036f0 <bmap+0x90>
    8000372a:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    8000372c:	00005517          	auipc	a0,0x5
    80003730:	e0c50513          	addi	a0,a0,-500 # 80008538 <etext+0x538>
    80003734:	ffffd097          	auipc	ra,0xffffd
    80003738:	e2c080e7          	jalr	-468(ra) # 80000560 <panic>

000000008000373c <iget>:
{
    8000373c:	7179                	addi	sp,sp,-48
    8000373e:	f406                	sd	ra,40(sp)
    80003740:	f022                	sd	s0,32(sp)
    80003742:	ec26                	sd	s1,24(sp)
    80003744:	e84a                	sd	s2,16(sp)
    80003746:	e44e                	sd	s3,8(sp)
    80003748:	e052                	sd	s4,0(sp)
    8000374a:	1800                	addi	s0,sp,48
    8000374c:	89aa                	mv	s3,a0
    8000374e:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003750:	0001c517          	auipc	a0,0x1c
    80003754:	a3850513          	addi	a0,a0,-1480 # 8001f188 <itable>
    80003758:	ffffd097          	auipc	ra,0xffffd
    8000375c:	4e6080e7          	jalr	1254(ra) # 80000c3e <acquire>
  empty = 0;
    80003760:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003762:	0001c497          	auipc	s1,0x1c
    80003766:	a3e48493          	addi	s1,s1,-1474 # 8001f1a0 <itable+0x18>
    8000376a:	0001d697          	auipc	a3,0x1d
    8000376e:	4c668693          	addi	a3,a3,1222 # 80020c30 <log>
    80003772:	a039                	j	80003780 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003774:	02090b63          	beqz	s2,800037aa <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003778:	08848493          	addi	s1,s1,136
    8000377c:	02d48a63          	beq	s1,a3,800037b0 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003780:	449c                	lw	a5,8(s1)
    80003782:	fef059e3          	blez	a5,80003774 <iget+0x38>
    80003786:	4098                	lw	a4,0(s1)
    80003788:	ff3716e3          	bne	a4,s3,80003774 <iget+0x38>
    8000378c:	40d8                	lw	a4,4(s1)
    8000378e:	ff4713e3          	bne	a4,s4,80003774 <iget+0x38>
      ip->ref++;
    80003792:	2785                	addiw	a5,a5,1
    80003794:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003796:	0001c517          	auipc	a0,0x1c
    8000379a:	9f250513          	addi	a0,a0,-1550 # 8001f188 <itable>
    8000379e:	ffffd097          	auipc	ra,0xffffd
    800037a2:	550080e7          	jalr	1360(ra) # 80000cee <release>
      return ip;
    800037a6:	8926                	mv	s2,s1
    800037a8:	a03d                	j	800037d6 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800037aa:	f7f9                	bnez	a5,80003778 <iget+0x3c>
      empty = ip;
    800037ac:	8926                	mv	s2,s1
    800037ae:	b7e9                	j	80003778 <iget+0x3c>
  if(empty == 0)
    800037b0:	02090c63          	beqz	s2,800037e8 <iget+0xac>
  ip->dev = dev;
    800037b4:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800037b8:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800037bc:	4785                	li	a5,1
    800037be:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800037c2:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800037c6:	0001c517          	auipc	a0,0x1c
    800037ca:	9c250513          	addi	a0,a0,-1598 # 8001f188 <itable>
    800037ce:	ffffd097          	auipc	ra,0xffffd
    800037d2:	520080e7          	jalr	1312(ra) # 80000cee <release>
}
    800037d6:	854a                	mv	a0,s2
    800037d8:	70a2                	ld	ra,40(sp)
    800037da:	7402                	ld	s0,32(sp)
    800037dc:	64e2                	ld	s1,24(sp)
    800037de:	6942                	ld	s2,16(sp)
    800037e0:	69a2                	ld	s3,8(sp)
    800037e2:	6a02                	ld	s4,0(sp)
    800037e4:	6145                	addi	sp,sp,48
    800037e6:	8082                	ret
    panic("iget: no inodes");
    800037e8:	00005517          	auipc	a0,0x5
    800037ec:	d6850513          	addi	a0,a0,-664 # 80008550 <etext+0x550>
    800037f0:	ffffd097          	auipc	ra,0xffffd
    800037f4:	d70080e7          	jalr	-656(ra) # 80000560 <panic>

00000000800037f8 <fsinit>:
fsinit(int dev) {
    800037f8:	7179                	addi	sp,sp,-48
    800037fa:	f406                	sd	ra,40(sp)
    800037fc:	f022                	sd	s0,32(sp)
    800037fe:	ec26                	sd	s1,24(sp)
    80003800:	e84a                	sd	s2,16(sp)
    80003802:	e44e                	sd	s3,8(sp)
    80003804:	1800                	addi	s0,sp,48
    80003806:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003808:	4585                	li	a1,1
    8000380a:	00000097          	auipc	ra,0x0
    8000380e:	a64080e7          	jalr	-1436(ra) # 8000326e <bread>
    80003812:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003814:	0001c997          	auipc	s3,0x1c
    80003818:	95498993          	addi	s3,s3,-1708 # 8001f168 <sb>
    8000381c:	02000613          	li	a2,32
    80003820:	05850593          	addi	a1,a0,88
    80003824:	854e                	mv	a0,s3
    80003826:	ffffd097          	auipc	ra,0xffffd
    8000382a:	574080e7          	jalr	1396(ra) # 80000d9a <memmove>
  brelse(bp);
    8000382e:	8526                	mv	a0,s1
    80003830:	00000097          	auipc	ra,0x0
    80003834:	b6e080e7          	jalr	-1170(ra) # 8000339e <brelse>
  if(sb.magic != FSMAGIC)
    80003838:	0009a703          	lw	a4,0(s3)
    8000383c:	102037b7          	lui	a5,0x10203
    80003840:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003844:	02f71263          	bne	a4,a5,80003868 <fsinit+0x70>
  initlog(dev, &sb);
    80003848:	0001c597          	auipc	a1,0x1c
    8000384c:	92058593          	addi	a1,a1,-1760 # 8001f168 <sb>
    80003850:	854a                	mv	a0,s2
    80003852:	00001097          	auipc	ra,0x1
    80003856:	b7c080e7          	jalr	-1156(ra) # 800043ce <initlog>
}
    8000385a:	70a2                	ld	ra,40(sp)
    8000385c:	7402                	ld	s0,32(sp)
    8000385e:	64e2                	ld	s1,24(sp)
    80003860:	6942                	ld	s2,16(sp)
    80003862:	69a2                	ld	s3,8(sp)
    80003864:	6145                	addi	sp,sp,48
    80003866:	8082                	ret
    panic("invalid file system");
    80003868:	00005517          	auipc	a0,0x5
    8000386c:	cf850513          	addi	a0,a0,-776 # 80008560 <etext+0x560>
    80003870:	ffffd097          	auipc	ra,0xffffd
    80003874:	cf0080e7          	jalr	-784(ra) # 80000560 <panic>

0000000080003878 <iinit>:
{
    80003878:	7179                	addi	sp,sp,-48
    8000387a:	f406                	sd	ra,40(sp)
    8000387c:	f022                	sd	s0,32(sp)
    8000387e:	ec26                	sd	s1,24(sp)
    80003880:	e84a                	sd	s2,16(sp)
    80003882:	e44e                	sd	s3,8(sp)
    80003884:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003886:	00005597          	auipc	a1,0x5
    8000388a:	cf258593          	addi	a1,a1,-782 # 80008578 <etext+0x578>
    8000388e:	0001c517          	auipc	a0,0x1c
    80003892:	8fa50513          	addi	a0,a0,-1798 # 8001f188 <itable>
    80003896:	ffffd097          	auipc	ra,0xffffd
    8000389a:	314080e7          	jalr	788(ra) # 80000baa <initlock>
  for(i = 0; i < NINODE; i++) {
    8000389e:	0001c497          	auipc	s1,0x1c
    800038a2:	91248493          	addi	s1,s1,-1774 # 8001f1b0 <itable+0x28>
    800038a6:	0001d997          	auipc	s3,0x1d
    800038aa:	39a98993          	addi	s3,s3,922 # 80020c40 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800038ae:	00005917          	auipc	s2,0x5
    800038b2:	cd290913          	addi	s2,s2,-814 # 80008580 <etext+0x580>
    800038b6:	85ca                	mv	a1,s2
    800038b8:	8526                	mv	a0,s1
    800038ba:	00001097          	auipc	ra,0x1
    800038be:	e6e080e7          	jalr	-402(ra) # 80004728 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800038c2:	08848493          	addi	s1,s1,136
    800038c6:	ff3498e3          	bne	s1,s3,800038b6 <iinit+0x3e>
}
    800038ca:	70a2                	ld	ra,40(sp)
    800038cc:	7402                	ld	s0,32(sp)
    800038ce:	64e2                	ld	s1,24(sp)
    800038d0:	6942                	ld	s2,16(sp)
    800038d2:	69a2                	ld	s3,8(sp)
    800038d4:	6145                	addi	sp,sp,48
    800038d6:	8082                	ret

00000000800038d8 <ialloc>:
{
    800038d8:	7139                	addi	sp,sp,-64
    800038da:	fc06                	sd	ra,56(sp)
    800038dc:	f822                	sd	s0,48(sp)
    800038de:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800038e0:	0001c717          	auipc	a4,0x1c
    800038e4:	89472703          	lw	a4,-1900(a4) # 8001f174 <sb+0xc>
    800038e8:	4785                	li	a5,1
    800038ea:	06e7f463          	bgeu	a5,a4,80003952 <ialloc+0x7a>
    800038ee:	f426                	sd	s1,40(sp)
    800038f0:	f04a                	sd	s2,32(sp)
    800038f2:	ec4e                	sd	s3,24(sp)
    800038f4:	e852                	sd	s4,16(sp)
    800038f6:	e456                	sd	s5,8(sp)
    800038f8:	e05a                	sd	s6,0(sp)
    800038fa:	8aaa                	mv	s5,a0
    800038fc:	8b2e                	mv	s6,a1
    800038fe:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80003900:	0001ca17          	auipc	s4,0x1c
    80003904:	868a0a13          	addi	s4,s4,-1944 # 8001f168 <sb>
    80003908:	00495593          	srli	a1,s2,0x4
    8000390c:	018a2783          	lw	a5,24(s4)
    80003910:	9dbd                	addw	a1,a1,a5
    80003912:	8556                	mv	a0,s5
    80003914:	00000097          	auipc	ra,0x0
    80003918:	95a080e7          	jalr	-1702(ra) # 8000326e <bread>
    8000391c:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000391e:	05850993          	addi	s3,a0,88
    80003922:	00f97793          	andi	a5,s2,15
    80003926:	079a                	slli	a5,a5,0x6
    80003928:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000392a:	00099783          	lh	a5,0(s3)
    8000392e:	cf9d                	beqz	a5,8000396c <ialloc+0x94>
    brelse(bp);
    80003930:	00000097          	auipc	ra,0x0
    80003934:	a6e080e7          	jalr	-1426(ra) # 8000339e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003938:	0905                	addi	s2,s2,1
    8000393a:	00ca2703          	lw	a4,12(s4)
    8000393e:	0009079b          	sext.w	a5,s2
    80003942:	fce7e3e3          	bltu	a5,a4,80003908 <ialloc+0x30>
    80003946:	74a2                	ld	s1,40(sp)
    80003948:	7902                	ld	s2,32(sp)
    8000394a:	69e2                	ld	s3,24(sp)
    8000394c:	6a42                	ld	s4,16(sp)
    8000394e:	6aa2                	ld	s5,8(sp)
    80003950:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003952:	00005517          	auipc	a0,0x5
    80003956:	c3650513          	addi	a0,a0,-970 # 80008588 <etext+0x588>
    8000395a:	ffffd097          	auipc	ra,0xffffd
    8000395e:	c50080e7          	jalr	-944(ra) # 800005aa <printf>
  return 0;
    80003962:	4501                	li	a0,0
}
    80003964:	70e2                	ld	ra,56(sp)
    80003966:	7442                	ld	s0,48(sp)
    80003968:	6121                	addi	sp,sp,64
    8000396a:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000396c:	04000613          	li	a2,64
    80003970:	4581                	li	a1,0
    80003972:	854e                	mv	a0,s3
    80003974:	ffffd097          	auipc	ra,0xffffd
    80003978:	3c2080e7          	jalr	962(ra) # 80000d36 <memset>
      dip->type = type;
    8000397c:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003980:	8526                	mv	a0,s1
    80003982:	00001097          	auipc	ra,0x1
    80003986:	cc2080e7          	jalr	-830(ra) # 80004644 <log_write>
      brelse(bp);
    8000398a:	8526                	mv	a0,s1
    8000398c:	00000097          	auipc	ra,0x0
    80003990:	a12080e7          	jalr	-1518(ra) # 8000339e <brelse>
      return iget(dev, inum);
    80003994:	0009059b          	sext.w	a1,s2
    80003998:	8556                	mv	a0,s5
    8000399a:	00000097          	auipc	ra,0x0
    8000399e:	da2080e7          	jalr	-606(ra) # 8000373c <iget>
    800039a2:	74a2                	ld	s1,40(sp)
    800039a4:	7902                	ld	s2,32(sp)
    800039a6:	69e2                	ld	s3,24(sp)
    800039a8:	6a42                	ld	s4,16(sp)
    800039aa:	6aa2                	ld	s5,8(sp)
    800039ac:	6b02                	ld	s6,0(sp)
    800039ae:	bf5d                	j	80003964 <ialloc+0x8c>

00000000800039b0 <iupdate>:
{
    800039b0:	1101                	addi	sp,sp,-32
    800039b2:	ec06                	sd	ra,24(sp)
    800039b4:	e822                	sd	s0,16(sp)
    800039b6:	e426                	sd	s1,8(sp)
    800039b8:	e04a                	sd	s2,0(sp)
    800039ba:	1000                	addi	s0,sp,32
    800039bc:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800039be:	415c                	lw	a5,4(a0)
    800039c0:	0047d79b          	srliw	a5,a5,0x4
    800039c4:	0001b597          	auipc	a1,0x1b
    800039c8:	7bc5a583          	lw	a1,1980(a1) # 8001f180 <sb+0x18>
    800039cc:	9dbd                	addw	a1,a1,a5
    800039ce:	4108                	lw	a0,0(a0)
    800039d0:	00000097          	auipc	ra,0x0
    800039d4:	89e080e7          	jalr	-1890(ra) # 8000326e <bread>
    800039d8:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800039da:	05850793          	addi	a5,a0,88
    800039de:	40d8                	lw	a4,4(s1)
    800039e0:	8b3d                	andi	a4,a4,15
    800039e2:	071a                	slli	a4,a4,0x6
    800039e4:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800039e6:	04449703          	lh	a4,68(s1)
    800039ea:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800039ee:	04649703          	lh	a4,70(s1)
    800039f2:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800039f6:	04849703          	lh	a4,72(s1)
    800039fa:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800039fe:	04a49703          	lh	a4,74(s1)
    80003a02:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003a06:	44f8                	lw	a4,76(s1)
    80003a08:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003a0a:	03400613          	li	a2,52
    80003a0e:	05048593          	addi	a1,s1,80
    80003a12:	00c78513          	addi	a0,a5,12
    80003a16:	ffffd097          	auipc	ra,0xffffd
    80003a1a:	384080e7          	jalr	900(ra) # 80000d9a <memmove>
  log_write(bp);
    80003a1e:	854a                	mv	a0,s2
    80003a20:	00001097          	auipc	ra,0x1
    80003a24:	c24080e7          	jalr	-988(ra) # 80004644 <log_write>
  brelse(bp);
    80003a28:	854a                	mv	a0,s2
    80003a2a:	00000097          	auipc	ra,0x0
    80003a2e:	974080e7          	jalr	-1676(ra) # 8000339e <brelse>
}
    80003a32:	60e2                	ld	ra,24(sp)
    80003a34:	6442                	ld	s0,16(sp)
    80003a36:	64a2                	ld	s1,8(sp)
    80003a38:	6902                	ld	s2,0(sp)
    80003a3a:	6105                	addi	sp,sp,32
    80003a3c:	8082                	ret

0000000080003a3e <idup>:
{
    80003a3e:	1101                	addi	sp,sp,-32
    80003a40:	ec06                	sd	ra,24(sp)
    80003a42:	e822                	sd	s0,16(sp)
    80003a44:	e426                	sd	s1,8(sp)
    80003a46:	1000                	addi	s0,sp,32
    80003a48:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003a4a:	0001b517          	auipc	a0,0x1b
    80003a4e:	73e50513          	addi	a0,a0,1854 # 8001f188 <itable>
    80003a52:	ffffd097          	auipc	ra,0xffffd
    80003a56:	1ec080e7          	jalr	492(ra) # 80000c3e <acquire>
  ip->ref++;
    80003a5a:	449c                	lw	a5,8(s1)
    80003a5c:	2785                	addiw	a5,a5,1
    80003a5e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003a60:	0001b517          	auipc	a0,0x1b
    80003a64:	72850513          	addi	a0,a0,1832 # 8001f188 <itable>
    80003a68:	ffffd097          	auipc	ra,0xffffd
    80003a6c:	286080e7          	jalr	646(ra) # 80000cee <release>
}
    80003a70:	8526                	mv	a0,s1
    80003a72:	60e2                	ld	ra,24(sp)
    80003a74:	6442                	ld	s0,16(sp)
    80003a76:	64a2                	ld	s1,8(sp)
    80003a78:	6105                	addi	sp,sp,32
    80003a7a:	8082                	ret

0000000080003a7c <ilock>:
{
    80003a7c:	1101                	addi	sp,sp,-32
    80003a7e:	ec06                	sd	ra,24(sp)
    80003a80:	e822                	sd	s0,16(sp)
    80003a82:	e426                	sd	s1,8(sp)
    80003a84:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003a86:	c10d                	beqz	a0,80003aa8 <ilock+0x2c>
    80003a88:	84aa                	mv	s1,a0
    80003a8a:	451c                	lw	a5,8(a0)
    80003a8c:	00f05e63          	blez	a5,80003aa8 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80003a90:	0541                	addi	a0,a0,16
    80003a92:	00001097          	auipc	ra,0x1
    80003a96:	cd0080e7          	jalr	-816(ra) # 80004762 <acquiresleep>
  if(ip->valid == 0){
    80003a9a:	40bc                	lw	a5,64(s1)
    80003a9c:	cf99                	beqz	a5,80003aba <ilock+0x3e>
}
    80003a9e:	60e2                	ld	ra,24(sp)
    80003aa0:	6442                	ld	s0,16(sp)
    80003aa2:	64a2                	ld	s1,8(sp)
    80003aa4:	6105                	addi	sp,sp,32
    80003aa6:	8082                	ret
    80003aa8:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003aaa:	00005517          	auipc	a0,0x5
    80003aae:	af650513          	addi	a0,a0,-1290 # 800085a0 <etext+0x5a0>
    80003ab2:	ffffd097          	auipc	ra,0xffffd
    80003ab6:	aae080e7          	jalr	-1362(ra) # 80000560 <panic>
    80003aba:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003abc:	40dc                	lw	a5,4(s1)
    80003abe:	0047d79b          	srliw	a5,a5,0x4
    80003ac2:	0001b597          	auipc	a1,0x1b
    80003ac6:	6be5a583          	lw	a1,1726(a1) # 8001f180 <sb+0x18>
    80003aca:	9dbd                	addw	a1,a1,a5
    80003acc:	4088                	lw	a0,0(s1)
    80003ace:	fffff097          	auipc	ra,0xfffff
    80003ad2:	7a0080e7          	jalr	1952(ra) # 8000326e <bread>
    80003ad6:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003ad8:	05850593          	addi	a1,a0,88
    80003adc:	40dc                	lw	a5,4(s1)
    80003ade:	8bbd                	andi	a5,a5,15
    80003ae0:	079a                	slli	a5,a5,0x6
    80003ae2:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003ae4:	00059783          	lh	a5,0(a1)
    80003ae8:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003aec:	00259783          	lh	a5,2(a1)
    80003af0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003af4:	00459783          	lh	a5,4(a1)
    80003af8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003afc:	00659783          	lh	a5,6(a1)
    80003b00:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003b04:	459c                	lw	a5,8(a1)
    80003b06:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003b08:	03400613          	li	a2,52
    80003b0c:	05b1                	addi	a1,a1,12
    80003b0e:	05048513          	addi	a0,s1,80
    80003b12:	ffffd097          	auipc	ra,0xffffd
    80003b16:	288080e7          	jalr	648(ra) # 80000d9a <memmove>
    brelse(bp);
    80003b1a:	854a                	mv	a0,s2
    80003b1c:	00000097          	auipc	ra,0x0
    80003b20:	882080e7          	jalr	-1918(ra) # 8000339e <brelse>
    ip->valid = 1;
    80003b24:	4785                	li	a5,1
    80003b26:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003b28:	04449783          	lh	a5,68(s1)
    80003b2c:	c399                	beqz	a5,80003b32 <ilock+0xb6>
    80003b2e:	6902                	ld	s2,0(sp)
    80003b30:	b7bd                	j	80003a9e <ilock+0x22>
      panic("ilock: no type");
    80003b32:	00005517          	auipc	a0,0x5
    80003b36:	a7650513          	addi	a0,a0,-1418 # 800085a8 <etext+0x5a8>
    80003b3a:	ffffd097          	auipc	ra,0xffffd
    80003b3e:	a26080e7          	jalr	-1498(ra) # 80000560 <panic>

0000000080003b42 <iunlock>:
{
    80003b42:	1101                	addi	sp,sp,-32
    80003b44:	ec06                	sd	ra,24(sp)
    80003b46:	e822                	sd	s0,16(sp)
    80003b48:	e426                	sd	s1,8(sp)
    80003b4a:	e04a                	sd	s2,0(sp)
    80003b4c:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003b4e:	c905                	beqz	a0,80003b7e <iunlock+0x3c>
    80003b50:	84aa                	mv	s1,a0
    80003b52:	01050913          	addi	s2,a0,16
    80003b56:	854a                	mv	a0,s2
    80003b58:	00001097          	auipc	ra,0x1
    80003b5c:	ca4080e7          	jalr	-860(ra) # 800047fc <holdingsleep>
    80003b60:	cd19                	beqz	a0,80003b7e <iunlock+0x3c>
    80003b62:	449c                	lw	a5,8(s1)
    80003b64:	00f05d63          	blez	a5,80003b7e <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003b68:	854a                	mv	a0,s2
    80003b6a:	00001097          	auipc	ra,0x1
    80003b6e:	c4e080e7          	jalr	-946(ra) # 800047b8 <releasesleep>
}
    80003b72:	60e2                	ld	ra,24(sp)
    80003b74:	6442                	ld	s0,16(sp)
    80003b76:	64a2                	ld	s1,8(sp)
    80003b78:	6902                	ld	s2,0(sp)
    80003b7a:	6105                	addi	sp,sp,32
    80003b7c:	8082                	ret
    panic("iunlock");
    80003b7e:	00005517          	auipc	a0,0x5
    80003b82:	a3a50513          	addi	a0,a0,-1478 # 800085b8 <etext+0x5b8>
    80003b86:	ffffd097          	auipc	ra,0xffffd
    80003b8a:	9da080e7          	jalr	-1574(ra) # 80000560 <panic>

0000000080003b8e <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003b8e:	7179                	addi	sp,sp,-48
    80003b90:	f406                	sd	ra,40(sp)
    80003b92:	f022                	sd	s0,32(sp)
    80003b94:	ec26                	sd	s1,24(sp)
    80003b96:	e84a                	sd	s2,16(sp)
    80003b98:	e44e                	sd	s3,8(sp)
    80003b9a:	1800                	addi	s0,sp,48
    80003b9c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003b9e:	05050493          	addi	s1,a0,80
    80003ba2:	08050913          	addi	s2,a0,128
    80003ba6:	a021                	j	80003bae <itrunc+0x20>
    80003ba8:	0491                	addi	s1,s1,4
    80003baa:	01248d63          	beq	s1,s2,80003bc4 <itrunc+0x36>
    if(ip->addrs[i]){
    80003bae:	408c                	lw	a1,0(s1)
    80003bb0:	dde5                	beqz	a1,80003ba8 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003bb2:	0009a503          	lw	a0,0(s3)
    80003bb6:	00000097          	auipc	ra,0x0
    80003bba:	8f8080e7          	jalr	-1800(ra) # 800034ae <bfree>
      ip->addrs[i] = 0;
    80003bbe:	0004a023          	sw	zero,0(s1)
    80003bc2:	b7dd                	j	80003ba8 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003bc4:	0809a583          	lw	a1,128(s3)
    80003bc8:	ed99                	bnez	a1,80003be6 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003bca:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003bce:	854e                	mv	a0,s3
    80003bd0:	00000097          	auipc	ra,0x0
    80003bd4:	de0080e7          	jalr	-544(ra) # 800039b0 <iupdate>
}
    80003bd8:	70a2                	ld	ra,40(sp)
    80003bda:	7402                	ld	s0,32(sp)
    80003bdc:	64e2                	ld	s1,24(sp)
    80003bde:	6942                	ld	s2,16(sp)
    80003be0:	69a2                	ld	s3,8(sp)
    80003be2:	6145                	addi	sp,sp,48
    80003be4:	8082                	ret
    80003be6:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003be8:	0009a503          	lw	a0,0(s3)
    80003bec:	fffff097          	auipc	ra,0xfffff
    80003bf0:	682080e7          	jalr	1666(ra) # 8000326e <bread>
    80003bf4:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003bf6:	05850493          	addi	s1,a0,88
    80003bfa:	45850913          	addi	s2,a0,1112
    80003bfe:	a021                	j	80003c06 <itrunc+0x78>
    80003c00:	0491                	addi	s1,s1,4
    80003c02:	01248b63          	beq	s1,s2,80003c18 <itrunc+0x8a>
      if(a[j])
    80003c06:	408c                	lw	a1,0(s1)
    80003c08:	dde5                	beqz	a1,80003c00 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80003c0a:	0009a503          	lw	a0,0(s3)
    80003c0e:	00000097          	auipc	ra,0x0
    80003c12:	8a0080e7          	jalr	-1888(ra) # 800034ae <bfree>
    80003c16:	b7ed                	j	80003c00 <itrunc+0x72>
    brelse(bp);
    80003c18:	8552                	mv	a0,s4
    80003c1a:	fffff097          	auipc	ra,0xfffff
    80003c1e:	784080e7          	jalr	1924(ra) # 8000339e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003c22:	0809a583          	lw	a1,128(s3)
    80003c26:	0009a503          	lw	a0,0(s3)
    80003c2a:	00000097          	auipc	ra,0x0
    80003c2e:	884080e7          	jalr	-1916(ra) # 800034ae <bfree>
    ip->addrs[NDIRECT] = 0;
    80003c32:	0809a023          	sw	zero,128(s3)
    80003c36:	6a02                	ld	s4,0(sp)
    80003c38:	bf49                	j	80003bca <itrunc+0x3c>

0000000080003c3a <iput>:
{
    80003c3a:	1101                	addi	sp,sp,-32
    80003c3c:	ec06                	sd	ra,24(sp)
    80003c3e:	e822                	sd	s0,16(sp)
    80003c40:	e426                	sd	s1,8(sp)
    80003c42:	1000                	addi	s0,sp,32
    80003c44:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003c46:	0001b517          	auipc	a0,0x1b
    80003c4a:	54250513          	addi	a0,a0,1346 # 8001f188 <itable>
    80003c4e:	ffffd097          	auipc	ra,0xffffd
    80003c52:	ff0080e7          	jalr	-16(ra) # 80000c3e <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003c56:	4498                	lw	a4,8(s1)
    80003c58:	4785                	li	a5,1
    80003c5a:	02f70263          	beq	a4,a5,80003c7e <iput+0x44>
  ip->ref--;
    80003c5e:	449c                	lw	a5,8(s1)
    80003c60:	37fd                	addiw	a5,a5,-1
    80003c62:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003c64:	0001b517          	auipc	a0,0x1b
    80003c68:	52450513          	addi	a0,a0,1316 # 8001f188 <itable>
    80003c6c:	ffffd097          	auipc	ra,0xffffd
    80003c70:	082080e7          	jalr	130(ra) # 80000cee <release>
}
    80003c74:	60e2                	ld	ra,24(sp)
    80003c76:	6442                	ld	s0,16(sp)
    80003c78:	64a2                	ld	s1,8(sp)
    80003c7a:	6105                	addi	sp,sp,32
    80003c7c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003c7e:	40bc                	lw	a5,64(s1)
    80003c80:	dff9                	beqz	a5,80003c5e <iput+0x24>
    80003c82:	04a49783          	lh	a5,74(s1)
    80003c86:	ffe1                	bnez	a5,80003c5e <iput+0x24>
    80003c88:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003c8a:	01048913          	addi	s2,s1,16
    80003c8e:	854a                	mv	a0,s2
    80003c90:	00001097          	auipc	ra,0x1
    80003c94:	ad2080e7          	jalr	-1326(ra) # 80004762 <acquiresleep>
    release(&itable.lock);
    80003c98:	0001b517          	auipc	a0,0x1b
    80003c9c:	4f050513          	addi	a0,a0,1264 # 8001f188 <itable>
    80003ca0:	ffffd097          	auipc	ra,0xffffd
    80003ca4:	04e080e7          	jalr	78(ra) # 80000cee <release>
    itrunc(ip);
    80003ca8:	8526                	mv	a0,s1
    80003caa:	00000097          	auipc	ra,0x0
    80003cae:	ee4080e7          	jalr	-284(ra) # 80003b8e <itrunc>
    ip->type = 0;
    80003cb2:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003cb6:	8526                	mv	a0,s1
    80003cb8:	00000097          	auipc	ra,0x0
    80003cbc:	cf8080e7          	jalr	-776(ra) # 800039b0 <iupdate>
    ip->valid = 0;
    80003cc0:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003cc4:	854a                	mv	a0,s2
    80003cc6:	00001097          	auipc	ra,0x1
    80003cca:	af2080e7          	jalr	-1294(ra) # 800047b8 <releasesleep>
    acquire(&itable.lock);
    80003cce:	0001b517          	auipc	a0,0x1b
    80003cd2:	4ba50513          	addi	a0,a0,1210 # 8001f188 <itable>
    80003cd6:	ffffd097          	auipc	ra,0xffffd
    80003cda:	f68080e7          	jalr	-152(ra) # 80000c3e <acquire>
    80003cde:	6902                	ld	s2,0(sp)
    80003ce0:	bfbd                	j	80003c5e <iput+0x24>

0000000080003ce2 <iunlockput>:
{
    80003ce2:	1101                	addi	sp,sp,-32
    80003ce4:	ec06                	sd	ra,24(sp)
    80003ce6:	e822                	sd	s0,16(sp)
    80003ce8:	e426                	sd	s1,8(sp)
    80003cea:	1000                	addi	s0,sp,32
    80003cec:	84aa                	mv	s1,a0
  iunlock(ip);
    80003cee:	00000097          	auipc	ra,0x0
    80003cf2:	e54080e7          	jalr	-428(ra) # 80003b42 <iunlock>
  iput(ip);
    80003cf6:	8526                	mv	a0,s1
    80003cf8:	00000097          	auipc	ra,0x0
    80003cfc:	f42080e7          	jalr	-190(ra) # 80003c3a <iput>
}
    80003d00:	60e2                	ld	ra,24(sp)
    80003d02:	6442                	ld	s0,16(sp)
    80003d04:	64a2                	ld	s1,8(sp)
    80003d06:	6105                	addi	sp,sp,32
    80003d08:	8082                	ret

0000000080003d0a <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003d0a:	1141                	addi	sp,sp,-16
    80003d0c:	e406                	sd	ra,8(sp)
    80003d0e:	e022                	sd	s0,0(sp)
    80003d10:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003d12:	411c                	lw	a5,0(a0)
    80003d14:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003d16:	415c                	lw	a5,4(a0)
    80003d18:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003d1a:	04451783          	lh	a5,68(a0)
    80003d1e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003d22:	04a51783          	lh	a5,74(a0)
    80003d26:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003d2a:	04c56783          	lwu	a5,76(a0)
    80003d2e:	e99c                	sd	a5,16(a1)
}
    80003d30:	60a2                	ld	ra,8(sp)
    80003d32:	6402                	ld	s0,0(sp)
    80003d34:	0141                	addi	sp,sp,16
    80003d36:	8082                	ret

0000000080003d38 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003d38:	457c                	lw	a5,76(a0)
    80003d3a:	10d7e063          	bltu	a5,a3,80003e3a <readi+0x102>
{
    80003d3e:	7159                	addi	sp,sp,-112
    80003d40:	f486                	sd	ra,104(sp)
    80003d42:	f0a2                	sd	s0,96(sp)
    80003d44:	eca6                	sd	s1,88(sp)
    80003d46:	e0d2                	sd	s4,64(sp)
    80003d48:	fc56                	sd	s5,56(sp)
    80003d4a:	f85a                	sd	s6,48(sp)
    80003d4c:	f45e                	sd	s7,40(sp)
    80003d4e:	1880                	addi	s0,sp,112
    80003d50:	8b2a                	mv	s6,a0
    80003d52:	8bae                	mv	s7,a1
    80003d54:	8a32                	mv	s4,a2
    80003d56:	84b6                	mv	s1,a3
    80003d58:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003d5a:	9f35                	addw	a4,a4,a3
    return 0;
    80003d5c:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003d5e:	0cd76563          	bltu	a4,a3,80003e28 <readi+0xf0>
    80003d62:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003d64:	00e7f463          	bgeu	a5,a4,80003d6c <readi+0x34>
    n = ip->size - off;
    80003d68:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003d6c:	0a0a8563          	beqz	s5,80003e16 <readi+0xde>
    80003d70:	e8ca                	sd	s2,80(sp)
    80003d72:	f062                	sd	s8,32(sp)
    80003d74:	ec66                	sd	s9,24(sp)
    80003d76:	e86a                	sd	s10,16(sp)
    80003d78:	e46e                	sd	s11,8(sp)
    80003d7a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003d7c:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003d80:	5c7d                	li	s8,-1
    80003d82:	a82d                	j	80003dbc <readi+0x84>
    80003d84:	020d1d93          	slli	s11,s10,0x20
    80003d88:	020ddd93          	srli	s11,s11,0x20
    80003d8c:	05890613          	addi	a2,s2,88
    80003d90:	86ee                	mv	a3,s11
    80003d92:	963e                	add	a2,a2,a5
    80003d94:	85d2                	mv	a1,s4
    80003d96:	855e                	mv	a0,s7
    80003d98:	fffff097          	auipc	ra,0xfffff
    80003d9c:	984080e7          	jalr	-1660(ra) # 8000271c <either_copyout>
    80003da0:	05850963          	beq	a0,s8,80003df2 <readi+0xba>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003da4:	854a                	mv	a0,s2
    80003da6:	fffff097          	auipc	ra,0xfffff
    80003daa:	5f8080e7          	jalr	1528(ra) # 8000339e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003dae:	013d09bb          	addw	s3,s10,s3
    80003db2:	009d04bb          	addw	s1,s10,s1
    80003db6:	9a6e                	add	s4,s4,s11
    80003db8:	0559f963          	bgeu	s3,s5,80003e0a <readi+0xd2>
    uint addr = bmap(ip, off/BSIZE);
    80003dbc:	00a4d59b          	srliw	a1,s1,0xa
    80003dc0:	855a                	mv	a0,s6
    80003dc2:	00000097          	auipc	ra,0x0
    80003dc6:	89e080e7          	jalr	-1890(ra) # 80003660 <bmap>
    80003dca:	85aa                	mv	a1,a0
    if(addr == 0)
    80003dcc:	c539                	beqz	a0,80003e1a <readi+0xe2>
    bp = bread(ip->dev, addr);
    80003dce:	000b2503          	lw	a0,0(s6)
    80003dd2:	fffff097          	auipc	ra,0xfffff
    80003dd6:	49c080e7          	jalr	1180(ra) # 8000326e <bread>
    80003dda:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003ddc:	3ff4f793          	andi	a5,s1,1023
    80003de0:	40fc873b          	subw	a4,s9,a5
    80003de4:	413a86bb          	subw	a3,s5,s3
    80003de8:	8d3a                	mv	s10,a4
    80003dea:	f8e6fde3          	bgeu	a3,a4,80003d84 <readi+0x4c>
    80003dee:	8d36                	mv	s10,a3
    80003df0:	bf51                	j	80003d84 <readi+0x4c>
      brelse(bp);
    80003df2:	854a                	mv	a0,s2
    80003df4:	fffff097          	auipc	ra,0xfffff
    80003df8:	5aa080e7          	jalr	1450(ra) # 8000339e <brelse>
      tot = -1;
    80003dfc:	59fd                	li	s3,-1
      break;
    80003dfe:	6946                	ld	s2,80(sp)
    80003e00:	7c02                	ld	s8,32(sp)
    80003e02:	6ce2                	ld	s9,24(sp)
    80003e04:	6d42                	ld	s10,16(sp)
    80003e06:	6da2                	ld	s11,8(sp)
    80003e08:	a831                	j	80003e24 <readi+0xec>
    80003e0a:	6946                	ld	s2,80(sp)
    80003e0c:	7c02                	ld	s8,32(sp)
    80003e0e:	6ce2                	ld	s9,24(sp)
    80003e10:	6d42                	ld	s10,16(sp)
    80003e12:	6da2                	ld	s11,8(sp)
    80003e14:	a801                	j	80003e24 <readi+0xec>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003e16:	89d6                	mv	s3,s5
    80003e18:	a031                	j	80003e24 <readi+0xec>
    80003e1a:	6946                	ld	s2,80(sp)
    80003e1c:	7c02                	ld	s8,32(sp)
    80003e1e:	6ce2                	ld	s9,24(sp)
    80003e20:	6d42                	ld	s10,16(sp)
    80003e22:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003e24:	854e                	mv	a0,s3
    80003e26:	69a6                	ld	s3,72(sp)
}
    80003e28:	70a6                	ld	ra,104(sp)
    80003e2a:	7406                	ld	s0,96(sp)
    80003e2c:	64e6                	ld	s1,88(sp)
    80003e2e:	6a06                	ld	s4,64(sp)
    80003e30:	7ae2                	ld	s5,56(sp)
    80003e32:	7b42                	ld	s6,48(sp)
    80003e34:	7ba2                	ld	s7,40(sp)
    80003e36:	6165                	addi	sp,sp,112
    80003e38:	8082                	ret
    return 0;
    80003e3a:	4501                	li	a0,0
}
    80003e3c:	8082                	ret

0000000080003e3e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003e3e:	457c                	lw	a5,76(a0)
    80003e40:	10d7e963          	bltu	a5,a3,80003f52 <writei+0x114>
{
    80003e44:	7159                	addi	sp,sp,-112
    80003e46:	f486                	sd	ra,104(sp)
    80003e48:	f0a2                	sd	s0,96(sp)
    80003e4a:	e8ca                	sd	s2,80(sp)
    80003e4c:	e0d2                	sd	s4,64(sp)
    80003e4e:	fc56                	sd	s5,56(sp)
    80003e50:	f85a                	sd	s6,48(sp)
    80003e52:	f45e                	sd	s7,40(sp)
    80003e54:	1880                	addi	s0,sp,112
    80003e56:	8aaa                	mv	s5,a0
    80003e58:	8bae                	mv	s7,a1
    80003e5a:	8a32                	mv	s4,a2
    80003e5c:	8936                	mv	s2,a3
    80003e5e:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003e60:	00e687bb          	addw	a5,a3,a4
    80003e64:	0ed7e963          	bltu	a5,a3,80003f56 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003e68:	00043737          	lui	a4,0x43
    80003e6c:	0ef76763          	bltu	a4,a5,80003f5a <writei+0x11c>
    80003e70:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003e72:	0c0b0863          	beqz	s6,80003f42 <writei+0x104>
    80003e76:	eca6                	sd	s1,88(sp)
    80003e78:	f062                	sd	s8,32(sp)
    80003e7a:	ec66                	sd	s9,24(sp)
    80003e7c:	e86a                	sd	s10,16(sp)
    80003e7e:	e46e                	sd	s11,8(sp)
    80003e80:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003e82:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003e86:	5c7d                	li	s8,-1
    80003e88:	a091                	j	80003ecc <writei+0x8e>
    80003e8a:	020d1d93          	slli	s11,s10,0x20
    80003e8e:	020ddd93          	srli	s11,s11,0x20
    80003e92:	05848513          	addi	a0,s1,88
    80003e96:	86ee                	mv	a3,s11
    80003e98:	8652                	mv	a2,s4
    80003e9a:	85de                	mv	a1,s7
    80003e9c:	953e                	add	a0,a0,a5
    80003e9e:	fffff097          	auipc	ra,0xfffff
    80003ea2:	8d4080e7          	jalr	-1836(ra) # 80002772 <either_copyin>
    80003ea6:	05850e63          	beq	a0,s8,80003f02 <writei+0xc4>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003eaa:	8526                	mv	a0,s1
    80003eac:	00000097          	auipc	ra,0x0
    80003eb0:	798080e7          	jalr	1944(ra) # 80004644 <log_write>
    brelse(bp);
    80003eb4:	8526                	mv	a0,s1
    80003eb6:	fffff097          	auipc	ra,0xfffff
    80003eba:	4e8080e7          	jalr	1256(ra) # 8000339e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003ebe:	013d09bb          	addw	s3,s10,s3
    80003ec2:	012d093b          	addw	s2,s10,s2
    80003ec6:	9a6e                	add	s4,s4,s11
    80003ec8:	0569f263          	bgeu	s3,s6,80003f0c <writei+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80003ecc:	00a9559b          	srliw	a1,s2,0xa
    80003ed0:	8556                	mv	a0,s5
    80003ed2:	fffff097          	auipc	ra,0xfffff
    80003ed6:	78e080e7          	jalr	1934(ra) # 80003660 <bmap>
    80003eda:	85aa                	mv	a1,a0
    if(addr == 0)
    80003edc:	c905                	beqz	a0,80003f0c <writei+0xce>
    bp = bread(ip->dev, addr);
    80003ede:	000aa503          	lw	a0,0(s5)
    80003ee2:	fffff097          	auipc	ra,0xfffff
    80003ee6:	38c080e7          	jalr	908(ra) # 8000326e <bread>
    80003eea:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003eec:	3ff97793          	andi	a5,s2,1023
    80003ef0:	40fc873b          	subw	a4,s9,a5
    80003ef4:	413b06bb          	subw	a3,s6,s3
    80003ef8:	8d3a                	mv	s10,a4
    80003efa:	f8e6f8e3          	bgeu	a3,a4,80003e8a <writei+0x4c>
    80003efe:	8d36                	mv	s10,a3
    80003f00:	b769                	j	80003e8a <writei+0x4c>
      brelse(bp);
    80003f02:	8526                	mv	a0,s1
    80003f04:	fffff097          	auipc	ra,0xfffff
    80003f08:	49a080e7          	jalr	1178(ra) # 8000339e <brelse>
  }

  if(off > ip->size)
    80003f0c:	04caa783          	lw	a5,76(s5)
    80003f10:	0327fb63          	bgeu	a5,s2,80003f46 <writei+0x108>
    ip->size = off;
    80003f14:	052aa623          	sw	s2,76(s5)
    80003f18:	64e6                	ld	s1,88(sp)
    80003f1a:	7c02                	ld	s8,32(sp)
    80003f1c:	6ce2                	ld	s9,24(sp)
    80003f1e:	6d42                	ld	s10,16(sp)
    80003f20:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003f22:	8556                	mv	a0,s5
    80003f24:	00000097          	auipc	ra,0x0
    80003f28:	a8c080e7          	jalr	-1396(ra) # 800039b0 <iupdate>

  return tot;
    80003f2c:	854e                	mv	a0,s3
    80003f2e:	69a6                	ld	s3,72(sp)
}
    80003f30:	70a6                	ld	ra,104(sp)
    80003f32:	7406                	ld	s0,96(sp)
    80003f34:	6946                	ld	s2,80(sp)
    80003f36:	6a06                	ld	s4,64(sp)
    80003f38:	7ae2                	ld	s5,56(sp)
    80003f3a:	7b42                	ld	s6,48(sp)
    80003f3c:	7ba2                	ld	s7,40(sp)
    80003f3e:	6165                	addi	sp,sp,112
    80003f40:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003f42:	89da                	mv	s3,s6
    80003f44:	bff9                	j	80003f22 <writei+0xe4>
    80003f46:	64e6                	ld	s1,88(sp)
    80003f48:	7c02                	ld	s8,32(sp)
    80003f4a:	6ce2                	ld	s9,24(sp)
    80003f4c:	6d42                	ld	s10,16(sp)
    80003f4e:	6da2                	ld	s11,8(sp)
    80003f50:	bfc9                	j	80003f22 <writei+0xe4>
    return -1;
    80003f52:	557d                	li	a0,-1
}
    80003f54:	8082                	ret
    return -1;
    80003f56:	557d                	li	a0,-1
    80003f58:	bfe1                	j	80003f30 <writei+0xf2>
    return -1;
    80003f5a:	557d                	li	a0,-1
    80003f5c:	bfd1                	j	80003f30 <writei+0xf2>

0000000080003f5e <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003f5e:	1141                	addi	sp,sp,-16
    80003f60:	e406                	sd	ra,8(sp)
    80003f62:	e022                	sd	s0,0(sp)
    80003f64:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003f66:	4639                	li	a2,14
    80003f68:	ffffd097          	auipc	ra,0xffffd
    80003f6c:	eaa080e7          	jalr	-342(ra) # 80000e12 <strncmp>
}
    80003f70:	60a2                	ld	ra,8(sp)
    80003f72:	6402                	ld	s0,0(sp)
    80003f74:	0141                	addi	sp,sp,16
    80003f76:	8082                	ret

0000000080003f78 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003f78:	711d                	addi	sp,sp,-96
    80003f7a:	ec86                	sd	ra,88(sp)
    80003f7c:	e8a2                	sd	s0,80(sp)
    80003f7e:	e4a6                	sd	s1,72(sp)
    80003f80:	e0ca                	sd	s2,64(sp)
    80003f82:	fc4e                	sd	s3,56(sp)
    80003f84:	f852                	sd	s4,48(sp)
    80003f86:	f456                	sd	s5,40(sp)
    80003f88:	f05a                	sd	s6,32(sp)
    80003f8a:	ec5e                	sd	s7,24(sp)
    80003f8c:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003f8e:	04451703          	lh	a4,68(a0)
    80003f92:	4785                	li	a5,1
    80003f94:	00f71f63          	bne	a4,a5,80003fb2 <dirlookup+0x3a>
    80003f98:	892a                	mv	s2,a0
    80003f9a:	8aae                	mv	s5,a1
    80003f9c:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003f9e:	457c                	lw	a5,76(a0)
    80003fa0:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003fa2:	fa040a13          	addi	s4,s0,-96
    80003fa6:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80003fa8:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003fac:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003fae:	e79d                	bnez	a5,80003fdc <dirlookup+0x64>
    80003fb0:	a88d                	j	80004022 <dirlookup+0xaa>
    panic("dirlookup not DIR");
    80003fb2:	00004517          	auipc	a0,0x4
    80003fb6:	60e50513          	addi	a0,a0,1550 # 800085c0 <etext+0x5c0>
    80003fba:	ffffc097          	auipc	ra,0xffffc
    80003fbe:	5a6080e7          	jalr	1446(ra) # 80000560 <panic>
      panic("dirlookup read");
    80003fc2:	00004517          	auipc	a0,0x4
    80003fc6:	61650513          	addi	a0,a0,1558 # 800085d8 <etext+0x5d8>
    80003fca:	ffffc097          	auipc	ra,0xffffc
    80003fce:	596080e7          	jalr	1430(ra) # 80000560 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003fd2:	24c1                	addiw	s1,s1,16
    80003fd4:	04c92783          	lw	a5,76(s2)
    80003fd8:	04f4f463          	bgeu	s1,a5,80004020 <dirlookup+0xa8>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003fdc:	874e                	mv	a4,s3
    80003fde:	86a6                	mv	a3,s1
    80003fe0:	8652                	mv	a2,s4
    80003fe2:	4581                	li	a1,0
    80003fe4:	854a                	mv	a0,s2
    80003fe6:	00000097          	auipc	ra,0x0
    80003fea:	d52080e7          	jalr	-686(ra) # 80003d38 <readi>
    80003fee:	fd351ae3          	bne	a0,s3,80003fc2 <dirlookup+0x4a>
    if(de.inum == 0)
    80003ff2:	fa045783          	lhu	a5,-96(s0)
    80003ff6:	dff1                	beqz	a5,80003fd2 <dirlookup+0x5a>
    if(namecmp(name, de.name) == 0){
    80003ff8:	85da                	mv	a1,s6
    80003ffa:	8556                	mv	a0,s5
    80003ffc:	00000097          	auipc	ra,0x0
    80004000:	f62080e7          	jalr	-158(ra) # 80003f5e <namecmp>
    80004004:	f579                	bnez	a0,80003fd2 <dirlookup+0x5a>
      if(poff)
    80004006:	000b8463          	beqz	s7,8000400e <dirlookup+0x96>
        *poff = off;
    8000400a:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    8000400e:	fa045583          	lhu	a1,-96(s0)
    80004012:	00092503          	lw	a0,0(s2)
    80004016:	fffff097          	auipc	ra,0xfffff
    8000401a:	726080e7          	jalr	1830(ra) # 8000373c <iget>
    8000401e:	a011                	j	80004022 <dirlookup+0xaa>
  return 0;
    80004020:	4501                	li	a0,0
}
    80004022:	60e6                	ld	ra,88(sp)
    80004024:	6446                	ld	s0,80(sp)
    80004026:	64a6                	ld	s1,72(sp)
    80004028:	6906                	ld	s2,64(sp)
    8000402a:	79e2                	ld	s3,56(sp)
    8000402c:	7a42                	ld	s4,48(sp)
    8000402e:	7aa2                	ld	s5,40(sp)
    80004030:	7b02                	ld	s6,32(sp)
    80004032:	6be2                	ld	s7,24(sp)
    80004034:	6125                	addi	sp,sp,96
    80004036:	8082                	ret

0000000080004038 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80004038:	711d                	addi	sp,sp,-96
    8000403a:	ec86                	sd	ra,88(sp)
    8000403c:	e8a2                	sd	s0,80(sp)
    8000403e:	e4a6                	sd	s1,72(sp)
    80004040:	e0ca                	sd	s2,64(sp)
    80004042:	fc4e                	sd	s3,56(sp)
    80004044:	f852                	sd	s4,48(sp)
    80004046:	f456                	sd	s5,40(sp)
    80004048:	f05a                	sd	s6,32(sp)
    8000404a:	ec5e                	sd	s7,24(sp)
    8000404c:	e862                	sd	s8,16(sp)
    8000404e:	e466                	sd	s9,8(sp)
    80004050:	e06a                	sd	s10,0(sp)
    80004052:	1080                	addi	s0,sp,96
    80004054:	84aa                	mv	s1,a0
    80004056:	8b2e                	mv	s6,a1
    80004058:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000405a:	00054703          	lbu	a4,0(a0)
    8000405e:	02f00793          	li	a5,47
    80004062:	02f70363          	beq	a4,a5,80004088 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80004066:	ffffe097          	auipc	ra,0xffffe
    8000406a:	ada080e7          	jalr	-1318(ra) # 80001b40 <myproc>
    8000406e:	15053503          	ld	a0,336(a0)
    80004072:	00000097          	auipc	ra,0x0
    80004076:	9cc080e7          	jalr	-1588(ra) # 80003a3e <idup>
    8000407a:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000407c:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80004080:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80004082:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004084:	4b85                	li	s7,1
    80004086:	a87d                	j	80004144 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80004088:	4585                	li	a1,1
    8000408a:	852e                	mv	a0,a1
    8000408c:	fffff097          	auipc	ra,0xfffff
    80004090:	6b0080e7          	jalr	1712(ra) # 8000373c <iget>
    80004094:	8a2a                	mv	s4,a0
    80004096:	b7dd                	j	8000407c <namex+0x44>
      iunlockput(ip);
    80004098:	8552                	mv	a0,s4
    8000409a:	00000097          	auipc	ra,0x0
    8000409e:	c48080e7          	jalr	-952(ra) # 80003ce2 <iunlockput>
      return 0;
    800040a2:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800040a4:	8552                	mv	a0,s4
    800040a6:	60e6                	ld	ra,88(sp)
    800040a8:	6446                	ld	s0,80(sp)
    800040aa:	64a6                	ld	s1,72(sp)
    800040ac:	6906                	ld	s2,64(sp)
    800040ae:	79e2                	ld	s3,56(sp)
    800040b0:	7a42                	ld	s4,48(sp)
    800040b2:	7aa2                	ld	s5,40(sp)
    800040b4:	7b02                	ld	s6,32(sp)
    800040b6:	6be2                	ld	s7,24(sp)
    800040b8:	6c42                	ld	s8,16(sp)
    800040ba:	6ca2                	ld	s9,8(sp)
    800040bc:	6d02                	ld	s10,0(sp)
    800040be:	6125                	addi	sp,sp,96
    800040c0:	8082                	ret
      iunlock(ip);
    800040c2:	8552                	mv	a0,s4
    800040c4:	00000097          	auipc	ra,0x0
    800040c8:	a7e080e7          	jalr	-1410(ra) # 80003b42 <iunlock>
      return ip;
    800040cc:	bfe1                	j	800040a4 <namex+0x6c>
      iunlockput(ip);
    800040ce:	8552                	mv	a0,s4
    800040d0:	00000097          	auipc	ra,0x0
    800040d4:	c12080e7          	jalr	-1006(ra) # 80003ce2 <iunlockput>
      return 0;
    800040d8:	8a4e                	mv	s4,s3
    800040da:	b7e9                	j	800040a4 <namex+0x6c>
  len = path - s;
    800040dc:	40998633          	sub	a2,s3,s1
    800040e0:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    800040e4:	09ac5863          	bge	s8,s10,80004174 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    800040e8:	8666                	mv	a2,s9
    800040ea:	85a6                	mv	a1,s1
    800040ec:	8556                	mv	a0,s5
    800040ee:	ffffd097          	auipc	ra,0xffffd
    800040f2:	cac080e7          	jalr	-852(ra) # 80000d9a <memmove>
    800040f6:	84ce                	mv	s1,s3
  while(*path == '/')
    800040f8:	0004c783          	lbu	a5,0(s1)
    800040fc:	01279763          	bne	a5,s2,8000410a <namex+0xd2>
    path++;
    80004100:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004102:	0004c783          	lbu	a5,0(s1)
    80004106:	ff278de3          	beq	a5,s2,80004100 <namex+0xc8>
    ilock(ip);
    8000410a:	8552                	mv	a0,s4
    8000410c:	00000097          	auipc	ra,0x0
    80004110:	970080e7          	jalr	-1680(ra) # 80003a7c <ilock>
    if(ip->type != T_DIR){
    80004114:	044a1783          	lh	a5,68(s4)
    80004118:	f97790e3          	bne	a5,s7,80004098 <namex+0x60>
    if(nameiparent && *path == '\0'){
    8000411c:	000b0563          	beqz	s6,80004126 <namex+0xee>
    80004120:	0004c783          	lbu	a5,0(s1)
    80004124:	dfd9                	beqz	a5,800040c2 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004126:	4601                	li	a2,0
    80004128:	85d6                	mv	a1,s5
    8000412a:	8552                	mv	a0,s4
    8000412c:	00000097          	auipc	ra,0x0
    80004130:	e4c080e7          	jalr	-436(ra) # 80003f78 <dirlookup>
    80004134:	89aa                	mv	s3,a0
    80004136:	dd41                	beqz	a0,800040ce <namex+0x96>
    iunlockput(ip);
    80004138:	8552                	mv	a0,s4
    8000413a:	00000097          	auipc	ra,0x0
    8000413e:	ba8080e7          	jalr	-1112(ra) # 80003ce2 <iunlockput>
    ip = next;
    80004142:	8a4e                	mv	s4,s3
  while(*path == '/')
    80004144:	0004c783          	lbu	a5,0(s1)
    80004148:	01279763          	bne	a5,s2,80004156 <namex+0x11e>
    path++;
    8000414c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000414e:	0004c783          	lbu	a5,0(s1)
    80004152:	ff278de3          	beq	a5,s2,8000414c <namex+0x114>
  if(*path == 0)
    80004156:	cb9d                	beqz	a5,8000418c <namex+0x154>
  while(*path != '/' && *path != 0)
    80004158:	0004c783          	lbu	a5,0(s1)
    8000415c:	89a6                	mv	s3,s1
  len = path - s;
    8000415e:	4d01                	li	s10,0
    80004160:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80004162:	01278963          	beq	a5,s2,80004174 <namex+0x13c>
    80004166:	dbbd                	beqz	a5,800040dc <namex+0xa4>
    path++;
    80004168:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    8000416a:	0009c783          	lbu	a5,0(s3)
    8000416e:	ff279ce3          	bne	a5,s2,80004166 <namex+0x12e>
    80004172:	b7ad                	j	800040dc <namex+0xa4>
    memmove(name, s, len);
    80004174:	2601                	sext.w	a2,a2
    80004176:	85a6                	mv	a1,s1
    80004178:	8556                	mv	a0,s5
    8000417a:	ffffd097          	auipc	ra,0xffffd
    8000417e:	c20080e7          	jalr	-992(ra) # 80000d9a <memmove>
    name[len] = 0;
    80004182:	9d56                	add	s10,s10,s5
    80004184:	000d0023          	sb	zero,0(s10)
    80004188:	84ce                	mv	s1,s3
    8000418a:	b7bd                	j	800040f8 <namex+0xc0>
  if(nameiparent){
    8000418c:	f00b0ce3          	beqz	s6,800040a4 <namex+0x6c>
    iput(ip);
    80004190:	8552                	mv	a0,s4
    80004192:	00000097          	auipc	ra,0x0
    80004196:	aa8080e7          	jalr	-1368(ra) # 80003c3a <iput>
    return 0;
    8000419a:	4a01                	li	s4,0
    8000419c:	b721                	j	800040a4 <namex+0x6c>

000000008000419e <dirlink>:
{
    8000419e:	715d                	addi	sp,sp,-80
    800041a0:	e486                	sd	ra,72(sp)
    800041a2:	e0a2                	sd	s0,64(sp)
    800041a4:	f84a                	sd	s2,48(sp)
    800041a6:	ec56                	sd	s5,24(sp)
    800041a8:	e85a                	sd	s6,16(sp)
    800041aa:	0880                	addi	s0,sp,80
    800041ac:	892a                	mv	s2,a0
    800041ae:	8aae                	mv	s5,a1
    800041b0:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800041b2:	4601                	li	a2,0
    800041b4:	00000097          	auipc	ra,0x0
    800041b8:	dc4080e7          	jalr	-572(ra) # 80003f78 <dirlookup>
    800041bc:	e129                	bnez	a0,800041fe <dirlink+0x60>
    800041be:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800041c0:	04c92483          	lw	s1,76(s2)
    800041c4:	cca9                	beqz	s1,8000421e <dirlink+0x80>
    800041c6:	f44e                	sd	s3,40(sp)
    800041c8:	f052                	sd	s4,32(sp)
    800041ca:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800041cc:	fb040a13          	addi	s4,s0,-80
    800041d0:	49c1                	li	s3,16
    800041d2:	874e                	mv	a4,s3
    800041d4:	86a6                	mv	a3,s1
    800041d6:	8652                	mv	a2,s4
    800041d8:	4581                	li	a1,0
    800041da:	854a                	mv	a0,s2
    800041dc:	00000097          	auipc	ra,0x0
    800041e0:	b5c080e7          	jalr	-1188(ra) # 80003d38 <readi>
    800041e4:	03351363          	bne	a0,s3,8000420a <dirlink+0x6c>
    if(de.inum == 0)
    800041e8:	fb045783          	lhu	a5,-80(s0)
    800041ec:	c79d                	beqz	a5,8000421a <dirlink+0x7c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800041ee:	24c1                	addiw	s1,s1,16
    800041f0:	04c92783          	lw	a5,76(s2)
    800041f4:	fcf4efe3          	bltu	s1,a5,800041d2 <dirlink+0x34>
    800041f8:	79a2                	ld	s3,40(sp)
    800041fa:	7a02                	ld	s4,32(sp)
    800041fc:	a00d                	j	8000421e <dirlink+0x80>
    iput(ip);
    800041fe:	00000097          	auipc	ra,0x0
    80004202:	a3c080e7          	jalr	-1476(ra) # 80003c3a <iput>
    return -1;
    80004206:	557d                	li	a0,-1
    80004208:	a0a9                	j	80004252 <dirlink+0xb4>
      panic("dirlink read");
    8000420a:	00004517          	auipc	a0,0x4
    8000420e:	3de50513          	addi	a0,a0,990 # 800085e8 <etext+0x5e8>
    80004212:	ffffc097          	auipc	ra,0xffffc
    80004216:	34e080e7          	jalr	846(ra) # 80000560 <panic>
    8000421a:	79a2                	ld	s3,40(sp)
    8000421c:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    8000421e:	4639                	li	a2,14
    80004220:	85d6                	mv	a1,s5
    80004222:	fb240513          	addi	a0,s0,-78
    80004226:	ffffd097          	auipc	ra,0xffffd
    8000422a:	c26080e7          	jalr	-986(ra) # 80000e4c <strncpy>
  de.inum = inum;
    8000422e:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004232:	4741                	li	a4,16
    80004234:	86a6                	mv	a3,s1
    80004236:	fb040613          	addi	a2,s0,-80
    8000423a:	4581                	li	a1,0
    8000423c:	854a                	mv	a0,s2
    8000423e:	00000097          	auipc	ra,0x0
    80004242:	c00080e7          	jalr	-1024(ra) # 80003e3e <writei>
    80004246:	1541                	addi	a0,a0,-16
    80004248:	00a03533          	snez	a0,a0
    8000424c:	40a0053b          	negw	a0,a0
    80004250:	74e2                	ld	s1,56(sp)
}
    80004252:	60a6                	ld	ra,72(sp)
    80004254:	6406                	ld	s0,64(sp)
    80004256:	7942                	ld	s2,48(sp)
    80004258:	6ae2                	ld	s5,24(sp)
    8000425a:	6b42                	ld	s6,16(sp)
    8000425c:	6161                	addi	sp,sp,80
    8000425e:	8082                	ret

0000000080004260 <namei>:

struct inode*
namei(char *path)
{
    80004260:	1101                	addi	sp,sp,-32
    80004262:	ec06                	sd	ra,24(sp)
    80004264:	e822                	sd	s0,16(sp)
    80004266:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004268:	fe040613          	addi	a2,s0,-32
    8000426c:	4581                	li	a1,0
    8000426e:	00000097          	auipc	ra,0x0
    80004272:	dca080e7          	jalr	-566(ra) # 80004038 <namex>
}
    80004276:	60e2                	ld	ra,24(sp)
    80004278:	6442                	ld	s0,16(sp)
    8000427a:	6105                	addi	sp,sp,32
    8000427c:	8082                	ret

000000008000427e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000427e:	1141                	addi	sp,sp,-16
    80004280:	e406                	sd	ra,8(sp)
    80004282:	e022                	sd	s0,0(sp)
    80004284:	0800                	addi	s0,sp,16
    80004286:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004288:	4585                	li	a1,1
    8000428a:	00000097          	auipc	ra,0x0
    8000428e:	dae080e7          	jalr	-594(ra) # 80004038 <namex>
}
    80004292:	60a2                	ld	ra,8(sp)
    80004294:	6402                	ld	s0,0(sp)
    80004296:	0141                	addi	sp,sp,16
    80004298:	8082                	ret

000000008000429a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000429a:	1101                	addi	sp,sp,-32
    8000429c:	ec06                	sd	ra,24(sp)
    8000429e:	e822                	sd	s0,16(sp)
    800042a0:	e426                	sd	s1,8(sp)
    800042a2:	e04a                	sd	s2,0(sp)
    800042a4:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800042a6:	0001d917          	auipc	s2,0x1d
    800042aa:	98a90913          	addi	s2,s2,-1654 # 80020c30 <log>
    800042ae:	01892583          	lw	a1,24(s2)
    800042b2:	02892503          	lw	a0,40(s2)
    800042b6:	fffff097          	auipc	ra,0xfffff
    800042ba:	fb8080e7          	jalr	-72(ra) # 8000326e <bread>
    800042be:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800042c0:	02c92603          	lw	a2,44(s2)
    800042c4:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800042c6:	00c05f63          	blez	a2,800042e4 <write_head+0x4a>
    800042ca:	0001d717          	auipc	a4,0x1d
    800042ce:	99670713          	addi	a4,a4,-1642 # 80020c60 <log+0x30>
    800042d2:	87aa                	mv	a5,a0
    800042d4:	060a                	slli	a2,a2,0x2
    800042d6:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800042d8:	4314                	lw	a3,0(a4)
    800042da:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800042dc:	0711                	addi	a4,a4,4
    800042de:	0791                	addi	a5,a5,4
    800042e0:	fec79ce3          	bne	a5,a2,800042d8 <write_head+0x3e>
  }
  bwrite(buf);
    800042e4:	8526                	mv	a0,s1
    800042e6:	fffff097          	auipc	ra,0xfffff
    800042ea:	07a080e7          	jalr	122(ra) # 80003360 <bwrite>
  brelse(buf);
    800042ee:	8526                	mv	a0,s1
    800042f0:	fffff097          	auipc	ra,0xfffff
    800042f4:	0ae080e7          	jalr	174(ra) # 8000339e <brelse>
}
    800042f8:	60e2                	ld	ra,24(sp)
    800042fa:	6442                	ld	s0,16(sp)
    800042fc:	64a2                	ld	s1,8(sp)
    800042fe:	6902                	ld	s2,0(sp)
    80004300:	6105                	addi	sp,sp,32
    80004302:	8082                	ret

0000000080004304 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004304:	0001d797          	auipc	a5,0x1d
    80004308:	9587a783          	lw	a5,-1704(a5) # 80020c5c <log+0x2c>
    8000430c:	0cf05063          	blez	a5,800043cc <install_trans+0xc8>
{
    80004310:	715d                	addi	sp,sp,-80
    80004312:	e486                	sd	ra,72(sp)
    80004314:	e0a2                	sd	s0,64(sp)
    80004316:	fc26                	sd	s1,56(sp)
    80004318:	f84a                	sd	s2,48(sp)
    8000431a:	f44e                	sd	s3,40(sp)
    8000431c:	f052                	sd	s4,32(sp)
    8000431e:	ec56                	sd	s5,24(sp)
    80004320:	e85a                	sd	s6,16(sp)
    80004322:	e45e                	sd	s7,8(sp)
    80004324:	0880                	addi	s0,sp,80
    80004326:	8b2a                	mv	s6,a0
    80004328:	0001da97          	auipc	s5,0x1d
    8000432c:	938a8a93          	addi	s5,s5,-1736 # 80020c60 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004330:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004332:	0001d997          	auipc	s3,0x1d
    80004336:	8fe98993          	addi	s3,s3,-1794 # 80020c30 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000433a:	40000b93          	li	s7,1024
    8000433e:	a00d                	j	80004360 <install_trans+0x5c>
    brelse(lbuf);
    80004340:	854a                	mv	a0,s2
    80004342:	fffff097          	auipc	ra,0xfffff
    80004346:	05c080e7          	jalr	92(ra) # 8000339e <brelse>
    brelse(dbuf);
    8000434a:	8526                	mv	a0,s1
    8000434c:	fffff097          	auipc	ra,0xfffff
    80004350:	052080e7          	jalr	82(ra) # 8000339e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004354:	2a05                	addiw	s4,s4,1
    80004356:	0a91                	addi	s5,s5,4
    80004358:	02c9a783          	lw	a5,44(s3)
    8000435c:	04fa5d63          	bge	s4,a5,800043b6 <install_trans+0xb2>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004360:	0189a583          	lw	a1,24(s3)
    80004364:	014585bb          	addw	a1,a1,s4
    80004368:	2585                	addiw	a1,a1,1
    8000436a:	0289a503          	lw	a0,40(s3)
    8000436e:	fffff097          	auipc	ra,0xfffff
    80004372:	f00080e7          	jalr	-256(ra) # 8000326e <bread>
    80004376:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004378:	000aa583          	lw	a1,0(s5)
    8000437c:	0289a503          	lw	a0,40(s3)
    80004380:	fffff097          	auipc	ra,0xfffff
    80004384:	eee080e7          	jalr	-274(ra) # 8000326e <bread>
    80004388:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000438a:	865e                	mv	a2,s7
    8000438c:	05890593          	addi	a1,s2,88
    80004390:	05850513          	addi	a0,a0,88
    80004394:	ffffd097          	auipc	ra,0xffffd
    80004398:	a06080e7          	jalr	-1530(ra) # 80000d9a <memmove>
    bwrite(dbuf);  // write dst to disk
    8000439c:	8526                	mv	a0,s1
    8000439e:	fffff097          	auipc	ra,0xfffff
    800043a2:	fc2080e7          	jalr	-62(ra) # 80003360 <bwrite>
    if(recovering == 0)
    800043a6:	f80b1de3          	bnez	s6,80004340 <install_trans+0x3c>
      bunpin(dbuf);
    800043aa:	8526                	mv	a0,s1
    800043ac:	fffff097          	auipc	ra,0xfffff
    800043b0:	0c6080e7          	jalr	198(ra) # 80003472 <bunpin>
    800043b4:	b771                	j	80004340 <install_trans+0x3c>
}
    800043b6:	60a6                	ld	ra,72(sp)
    800043b8:	6406                	ld	s0,64(sp)
    800043ba:	74e2                	ld	s1,56(sp)
    800043bc:	7942                	ld	s2,48(sp)
    800043be:	79a2                	ld	s3,40(sp)
    800043c0:	7a02                	ld	s4,32(sp)
    800043c2:	6ae2                	ld	s5,24(sp)
    800043c4:	6b42                	ld	s6,16(sp)
    800043c6:	6ba2                	ld	s7,8(sp)
    800043c8:	6161                	addi	sp,sp,80
    800043ca:	8082                	ret
    800043cc:	8082                	ret

00000000800043ce <initlog>:
{
    800043ce:	7179                	addi	sp,sp,-48
    800043d0:	f406                	sd	ra,40(sp)
    800043d2:	f022                	sd	s0,32(sp)
    800043d4:	ec26                	sd	s1,24(sp)
    800043d6:	e84a                	sd	s2,16(sp)
    800043d8:	e44e                	sd	s3,8(sp)
    800043da:	1800                	addi	s0,sp,48
    800043dc:	892a                	mv	s2,a0
    800043de:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800043e0:	0001d497          	auipc	s1,0x1d
    800043e4:	85048493          	addi	s1,s1,-1968 # 80020c30 <log>
    800043e8:	00004597          	auipc	a1,0x4
    800043ec:	21058593          	addi	a1,a1,528 # 800085f8 <etext+0x5f8>
    800043f0:	8526                	mv	a0,s1
    800043f2:	ffffc097          	auipc	ra,0xffffc
    800043f6:	7b8080e7          	jalr	1976(ra) # 80000baa <initlock>
  log.start = sb->logstart;
    800043fa:	0149a583          	lw	a1,20(s3)
    800043fe:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004400:	0109a783          	lw	a5,16(s3)
    80004404:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004406:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000440a:	854a                	mv	a0,s2
    8000440c:	fffff097          	auipc	ra,0xfffff
    80004410:	e62080e7          	jalr	-414(ra) # 8000326e <bread>
  log.lh.n = lh->n;
    80004414:	4d30                	lw	a2,88(a0)
    80004416:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004418:	00c05f63          	blez	a2,80004436 <initlog+0x68>
    8000441c:	87aa                	mv	a5,a0
    8000441e:	0001d717          	auipc	a4,0x1d
    80004422:	84270713          	addi	a4,a4,-1982 # 80020c60 <log+0x30>
    80004426:	060a                	slli	a2,a2,0x2
    80004428:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000442a:	4ff4                	lw	a3,92(a5)
    8000442c:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000442e:	0791                	addi	a5,a5,4
    80004430:	0711                	addi	a4,a4,4
    80004432:	fec79ce3          	bne	a5,a2,8000442a <initlog+0x5c>
  brelse(buf);
    80004436:	fffff097          	auipc	ra,0xfffff
    8000443a:	f68080e7          	jalr	-152(ra) # 8000339e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000443e:	4505                	li	a0,1
    80004440:	00000097          	auipc	ra,0x0
    80004444:	ec4080e7          	jalr	-316(ra) # 80004304 <install_trans>
  log.lh.n = 0;
    80004448:	0001d797          	auipc	a5,0x1d
    8000444c:	8007aa23          	sw	zero,-2028(a5) # 80020c5c <log+0x2c>
  write_head(); // clear the log
    80004450:	00000097          	auipc	ra,0x0
    80004454:	e4a080e7          	jalr	-438(ra) # 8000429a <write_head>
}
    80004458:	70a2                	ld	ra,40(sp)
    8000445a:	7402                	ld	s0,32(sp)
    8000445c:	64e2                	ld	s1,24(sp)
    8000445e:	6942                	ld	s2,16(sp)
    80004460:	69a2                	ld	s3,8(sp)
    80004462:	6145                	addi	sp,sp,48
    80004464:	8082                	ret

0000000080004466 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004466:	1101                	addi	sp,sp,-32
    80004468:	ec06                	sd	ra,24(sp)
    8000446a:	e822                	sd	s0,16(sp)
    8000446c:	e426                	sd	s1,8(sp)
    8000446e:	e04a                	sd	s2,0(sp)
    80004470:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004472:	0001c517          	auipc	a0,0x1c
    80004476:	7be50513          	addi	a0,a0,1982 # 80020c30 <log>
    8000447a:	ffffc097          	auipc	ra,0xffffc
    8000447e:	7c4080e7          	jalr	1988(ra) # 80000c3e <acquire>
  while(1){
    if(log.committing){
    80004482:	0001c497          	auipc	s1,0x1c
    80004486:	7ae48493          	addi	s1,s1,1966 # 80020c30 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000448a:	4979                	li	s2,30
    8000448c:	a039                	j	8000449a <begin_op+0x34>
      sleep(&log, &log.lock);
    8000448e:	85a6                	mv	a1,s1
    80004490:	8526                	mv	a0,s1
    80004492:	ffffe097          	auipc	ra,0xffffe
    80004496:	e88080e7          	jalr	-376(ra) # 8000231a <sleep>
    if(log.committing){
    8000449a:	50dc                	lw	a5,36(s1)
    8000449c:	fbed                	bnez	a5,8000448e <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000449e:	5098                	lw	a4,32(s1)
    800044a0:	2705                	addiw	a4,a4,1
    800044a2:	0027179b          	slliw	a5,a4,0x2
    800044a6:	9fb9                	addw	a5,a5,a4
    800044a8:	0017979b          	slliw	a5,a5,0x1
    800044ac:	54d4                	lw	a3,44(s1)
    800044ae:	9fb5                	addw	a5,a5,a3
    800044b0:	00f95963          	bge	s2,a5,800044c2 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800044b4:	85a6                	mv	a1,s1
    800044b6:	8526                	mv	a0,s1
    800044b8:	ffffe097          	auipc	ra,0xffffe
    800044bc:	e62080e7          	jalr	-414(ra) # 8000231a <sleep>
    800044c0:	bfe9                	j	8000449a <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800044c2:	0001c517          	auipc	a0,0x1c
    800044c6:	76e50513          	addi	a0,a0,1902 # 80020c30 <log>
    800044ca:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800044cc:	ffffd097          	auipc	ra,0xffffd
    800044d0:	822080e7          	jalr	-2014(ra) # 80000cee <release>
      break;
    }
  }
}
    800044d4:	60e2                	ld	ra,24(sp)
    800044d6:	6442                	ld	s0,16(sp)
    800044d8:	64a2                	ld	s1,8(sp)
    800044da:	6902                	ld	s2,0(sp)
    800044dc:	6105                	addi	sp,sp,32
    800044de:	8082                	ret

00000000800044e0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800044e0:	7139                	addi	sp,sp,-64
    800044e2:	fc06                	sd	ra,56(sp)
    800044e4:	f822                	sd	s0,48(sp)
    800044e6:	f426                	sd	s1,40(sp)
    800044e8:	f04a                	sd	s2,32(sp)
    800044ea:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800044ec:	0001c497          	auipc	s1,0x1c
    800044f0:	74448493          	addi	s1,s1,1860 # 80020c30 <log>
    800044f4:	8526                	mv	a0,s1
    800044f6:	ffffc097          	auipc	ra,0xffffc
    800044fa:	748080e7          	jalr	1864(ra) # 80000c3e <acquire>
  log.outstanding -= 1;
    800044fe:	509c                	lw	a5,32(s1)
    80004500:	37fd                	addiw	a5,a5,-1
    80004502:	893e                	mv	s2,a5
    80004504:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004506:	50dc                	lw	a5,36(s1)
    80004508:	e7b9                	bnez	a5,80004556 <end_op+0x76>
    panic("log.committing");
  if(log.outstanding == 0){
    8000450a:	06091263          	bnez	s2,8000456e <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000450e:	0001c497          	auipc	s1,0x1c
    80004512:	72248493          	addi	s1,s1,1826 # 80020c30 <log>
    80004516:	4785                	li	a5,1
    80004518:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000451a:	8526                	mv	a0,s1
    8000451c:	ffffc097          	auipc	ra,0xffffc
    80004520:	7d2080e7          	jalr	2002(ra) # 80000cee <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004524:	54dc                	lw	a5,44(s1)
    80004526:	06f04863          	bgtz	a5,80004596 <end_op+0xb6>
    acquire(&log.lock);
    8000452a:	0001c497          	auipc	s1,0x1c
    8000452e:	70648493          	addi	s1,s1,1798 # 80020c30 <log>
    80004532:	8526                	mv	a0,s1
    80004534:	ffffc097          	auipc	ra,0xffffc
    80004538:	70a080e7          	jalr	1802(ra) # 80000c3e <acquire>
    log.committing = 0;
    8000453c:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004540:	8526                	mv	a0,s1
    80004542:	ffffe097          	auipc	ra,0xffffe
    80004546:	e3c080e7          	jalr	-452(ra) # 8000237e <wakeup>
    release(&log.lock);
    8000454a:	8526                	mv	a0,s1
    8000454c:	ffffc097          	auipc	ra,0xffffc
    80004550:	7a2080e7          	jalr	1954(ra) # 80000cee <release>
}
    80004554:	a81d                	j	8000458a <end_op+0xaa>
    80004556:	ec4e                	sd	s3,24(sp)
    80004558:	e852                	sd	s4,16(sp)
    8000455a:	e456                	sd	s5,8(sp)
    8000455c:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    8000455e:	00004517          	auipc	a0,0x4
    80004562:	0a250513          	addi	a0,a0,162 # 80008600 <etext+0x600>
    80004566:	ffffc097          	auipc	ra,0xffffc
    8000456a:	ffa080e7          	jalr	-6(ra) # 80000560 <panic>
    wakeup(&log);
    8000456e:	0001c497          	auipc	s1,0x1c
    80004572:	6c248493          	addi	s1,s1,1730 # 80020c30 <log>
    80004576:	8526                	mv	a0,s1
    80004578:	ffffe097          	auipc	ra,0xffffe
    8000457c:	e06080e7          	jalr	-506(ra) # 8000237e <wakeup>
  release(&log.lock);
    80004580:	8526                	mv	a0,s1
    80004582:	ffffc097          	auipc	ra,0xffffc
    80004586:	76c080e7          	jalr	1900(ra) # 80000cee <release>
}
    8000458a:	70e2                	ld	ra,56(sp)
    8000458c:	7442                	ld	s0,48(sp)
    8000458e:	74a2                	ld	s1,40(sp)
    80004590:	7902                	ld	s2,32(sp)
    80004592:	6121                	addi	sp,sp,64
    80004594:	8082                	ret
    80004596:	ec4e                	sd	s3,24(sp)
    80004598:	e852                	sd	s4,16(sp)
    8000459a:	e456                	sd	s5,8(sp)
    8000459c:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000459e:	0001ca97          	auipc	s5,0x1c
    800045a2:	6c2a8a93          	addi	s5,s5,1730 # 80020c60 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800045a6:	0001ca17          	auipc	s4,0x1c
    800045aa:	68aa0a13          	addi	s4,s4,1674 # 80020c30 <log>
    memmove(to->data, from->data, BSIZE);
    800045ae:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800045b2:	018a2583          	lw	a1,24(s4)
    800045b6:	012585bb          	addw	a1,a1,s2
    800045ba:	2585                	addiw	a1,a1,1
    800045bc:	028a2503          	lw	a0,40(s4)
    800045c0:	fffff097          	auipc	ra,0xfffff
    800045c4:	cae080e7          	jalr	-850(ra) # 8000326e <bread>
    800045c8:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800045ca:	000aa583          	lw	a1,0(s5)
    800045ce:	028a2503          	lw	a0,40(s4)
    800045d2:	fffff097          	auipc	ra,0xfffff
    800045d6:	c9c080e7          	jalr	-868(ra) # 8000326e <bread>
    800045da:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800045dc:	865a                	mv	a2,s6
    800045de:	05850593          	addi	a1,a0,88
    800045e2:	05848513          	addi	a0,s1,88
    800045e6:	ffffc097          	auipc	ra,0xffffc
    800045ea:	7b4080e7          	jalr	1972(ra) # 80000d9a <memmove>
    bwrite(to);  // write the log
    800045ee:	8526                	mv	a0,s1
    800045f0:	fffff097          	auipc	ra,0xfffff
    800045f4:	d70080e7          	jalr	-656(ra) # 80003360 <bwrite>
    brelse(from);
    800045f8:	854e                	mv	a0,s3
    800045fa:	fffff097          	auipc	ra,0xfffff
    800045fe:	da4080e7          	jalr	-604(ra) # 8000339e <brelse>
    brelse(to);
    80004602:	8526                	mv	a0,s1
    80004604:	fffff097          	auipc	ra,0xfffff
    80004608:	d9a080e7          	jalr	-614(ra) # 8000339e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000460c:	2905                	addiw	s2,s2,1
    8000460e:	0a91                	addi	s5,s5,4
    80004610:	02ca2783          	lw	a5,44(s4)
    80004614:	f8f94fe3          	blt	s2,a5,800045b2 <end_op+0xd2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004618:	00000097          	auipc	ra,0x0
    8000461c:	c82080e7          	jalr	-894(ra) # 8000429a <write_head>
    install_trans(0); // Now install writes to home locations
    80004620:	4501                	li	a0,0
    80004622:	00000097          	auipc	ra,0x0
    80004626:	ce2080e7          	jalr	-798(ra) # 80004304 <install_trans>
    log.lh.n = 0;
    8000462a:	0001c797          	auipc	a5,0x1c
    8000462e:	6207a923          	sw	zero,1586(a5) # 80020c5c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004632:	00000097          	auipc	ra,0x0
    80004636:	c68080e7          	jalr	-920(ra) # 8000429a <write_head>
    8000463a:	69e2                	ld	s3,24(sp)
    8000463c:	6a42                	ld	s4,16(sp)
    8000463e:	6aa2                	ld	s5,8(sp)
    80004640:	6b02                	ld	s6,0(sp)
    80004642:	b5e5                	j	8000452a <end_op+0x4a>

0000000080004644 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004644:	1101                	addi	sp,sp,-32
    80004646:	ec06                	sd	ra,24(sp)
    80004648:	e822                	sd	s0,16(sp)
    8000464a:	e426                	sd	s1,8(sp)
    8000464c:	e04a                	sd	s2,0(sp)
    8000464e:	1000                	addi	s0,sp,32
    80004650:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004652:	0001c917          	auipc	s2,0x1c
    80004656:	5de90913          	addi	s2,s2,1502 # 80020c30 <log>
    8000465a:	854a                	mv	a0,s2
    8000465c:	ffffc097          	auipc	ra,0xffffc
    80004660:	5e2080e7          	jalr	1506(ra) # 80000c3e <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004664:	02c92603          	lw	a2,44(s2)
    80004668:	47f5                	li	a5,29
    8000466a:	06c7c563          	blt	a5,a2,800046d4 <log_write+0x90>
    8000466e:	0001c797          	auipc	a5,0x1c
    80004672:	5de7a783          	lw	a5,1502(a5) # 80020c4c <log+0x1c>
    80004676:	37fd                	addiw	a5,a5,-1
    80004678:	04f65e63          	bge	a2,a5,800046d4 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000467c:	0001c797          	auipc	a5,0x1c
    80004680:	5d47a783          	lw	a5,1492(a5) # 80020c50 <log+0x20>
    80004684:	06f05063          	blez	a5,800046e4 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004688:	4781                	li	a5,0
    8000468a:	06c05563          	blez	a2,800046f4 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000468e:	44cc                	lw	a1,12(s1)
    80004690:	0001c717          	auipc	a4,0x1c
    80004694:	5d070713          	addi	a4,a4,1488 # 80020c60 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004698:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000469a:	4314                	lw	a3,0(a4)
    8000469c:	04b68c63          	beq	a3,a1,800046f4 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800046a0:	2785                	addiw	a5,a5,1
    800046a2:	0711                	addi	a4,a4,4
    800046a4:	fef61be3          	bne	a2,a5,8000469a <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800046a8:	0621                	addi	a2,a2,8
    800046aa:	060a                	slli	a2,a2,0x2
    800046ac:	0001c797          	auipc	a5,0x1c
    800046b0:	58478793          	addi	a5,a5,1412 # 80020c30 <log>
    800046b4:	97b2                	add	a5,a5,a2
    800046b6:	44d8                	lw	a4,12(s1)
    800046b8:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800046ba:	8526                	mv	a0,s1
    800046bc:	fffff097          	auipc	ra,0xfffff
    800046c0:	d7a080e7          	jalr	-646(ra) # 80003436 <bpin>
    log.lh.n++;
    800046c4:	0001c717          	auipc	a4,0x1c
    800046c8:	56c70713          	addi	a4,a4,1388 # 80020c30 <log>
    800046cc:	575c                	lw	a5,44(a4)
    800046ce:	2785                	addiw	a5,a5,1
    800046d0:	d75c                	sw	a5,44(a4)
    800046d2:	a82d                	j	8000470c <log_write+0xc8>
    panic("too big a transaction");
    800046d4:	00004517          	auipc	a0,0x4
    800046d8:	f3c50513          	addi	a0,a0,-196 # 80008610 <etext+0x610>
    800046dc:	ffffc097          	auipc	ra,0xffffc
    800046e0:	e84080e7          	jalr	-380(ra) # 80000560 <panic>
    panic("log_write outside of trans");
    800046e4:	00004517          	auipc	a0,0x4
    800046e8:	f4450513          	addi	a0,a0,-188 # 80008628 <etext+0x628>
    800046ec:	ffffc097          	auipc	ra,0xffffc
    800046f0:	e74080e7          	jalr	-396(ra) # 80000560 <panic>
  log.lh.block[i] = b->blockno;
    800046f4:	00878693          	addi	a3,a5,8
    800046f8:	068a                	slli	a3,a3,0x2
    800046fa:	0001c717          	auipc	a4,0x1c
    800046fe:	53670713          	addi	a4,a4,1334 # 80020c30 <log>
    80004702:	9736                	add	a4,a4,a3
    80004704:	44d4                	lw	a3,12(s1)
    80004706:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004708:	faf609e3          	beq	a2,a5,800046ba <log_write+0x76>
  }
  release(&log.lock);
    8000470c:	0001c517          	auipc	a0,0x1c
    80004710:	52450513          	addi	a0,a0,1316 # 80020c30 <log>
    80004714:	ffffc097          	auipc	ra,0xffffc
    80004718:	5da080e7          	jalr	1498(ra) # 80000cee <release>
}
    8000471c:	60e2                	ld	ra,24(sp)
    8000471e:	6442                	ld	s0,16(sp)
    80004720:	64a2                	ld	s1,8(sp)
    80004722:	6902                	ld	s2,0(sp)
    80004724:	6105                	addi	sp,sp,32
    80004726:	8082                	ret

0000000080004728 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004728:	1101                	addi	sp,sp,-32
    8000472a:	ec06                	sd	ra,24(sp)
    8000472c:	e822                	sd	s0,16(sp)
    8000472e:	e426                	sd	s1,8(sp)
    80004730:	e04a                	sd	s2,0(sp)
    80004732:	1000                	addi	s0,sp,32
    80004734:	84aa                	mv	s1,a0
    80004736:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004738:	00004597          	auipc	a1,0x4
    8000473c:	f1058593          	addi	a1,a1,-240 # 80008648 <etext+0x648>
    80004740:	0521                	addi	a0,a0,8
    80004742:	ffffc097          	auipc	ra,0xffffc
    80004746:	468080e7          	jalr	1128(ra) # 80000baa <initlock>
  lk->name = name;
    8000474a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000474e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004752:	0204a423          	sw	zero,40(s1)
}
    80004756:	60e2                	ld	ra,24(sp)
    80004758:	6442                	ld	s0,16(sp)
    8000475a:	64a2                	ld	s1,8(sp)
    8000475c:	6902                	ld	s2,0(sp)
    8000475e:	6105                	addi	sp,sp,32
    80004760:	8082                	ret

0000000080004762 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004762:	1101                	addi	sp,sp,-32
    80004764:	ec06                	sd	ra,24(sp)
    80004766:	e822                	sd	s0,16(sp)
    80004768:	e426                	sd	s1,8(sp)
    8000476a:	e04a                	sd	s2,0(sp)
    8000476c:	1000                	addi	s0,sp,32
    8000476e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004770:	00850913          	addi	s2,a0,8
    80004774:	854a                	mv	a0,s2
    80004776:	ffffc097          	auipc	ra,0xffffc
    8000477a:	4c8080e7          	jalr	1224(ra) # 80000c3e <acquire>
  while (lk->locked) {
    8000477e:	409c                	lw	a5,0(s1)
    80004780:	cb89                	beqz	a5,80004792 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004782:	85ca                	mv	a1,s2
    80004784:	8526                	mv	a0,s1
    80004786:	ffffe097          	auipc	ra,0xffffe
    8000478a:	b94080e7          	jalr	-1132(ra) # 8000231a <sleep>
  while (lk->locked) {
    8000478e:	409c                	lw	a5,0(s1)
    80004790:	fbed                	bnez	a5,80004782 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004792:	4785                	li	a5,1
    80004794:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004796:	ffffd097          	auipc	ra,0xffffd
    8000479a:	3aa080e7          	jalr	938(ra) # 80001b40 <myproc>
    8000479e:	591c                	lw	a5,48(a0)
    800047a0:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800047a2:	854a                	mv	a0,s2
    800047a4:	ffffc097          	auipc	ra,0xffffc
    800047a8:	54a080e7          	jalr	1354(ra) # 80000cee <release>
}
    800047ac:	60e2                	ld	ra,24(sp)
    800047ae:	6442                	ld	s0,16(sp)
    800047b0:	64a2                	ld	s1,8(sp)
    800047b2:	6902                	ld	s2,0(sp)
    800047b4:	6105                	addi	sp,sp,32
    800047b6:	8082                	ret

00000000800047b8 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800047b8:	1101                	addi	sp,sp,-32
    800047ba:	ec06                	sd	ra,24(sp)
    800047bc:	e822                	sd	s0,16(sp)
    800047be:	e426                	sd	s1,8(sp)
    800047c0:	e04a                	sd	s2,0(sp)
    800047c2:	1000                	addi	s0,sp,32
    800047c4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800047c6:	00850913          	addi	s2,a0,8
    800047ca:	854a                	mv	a0,s2
    800047cc:	ffffc097          	auipc	ra,0xffffc
    800047d0:	472080e7          	jalr	1138(ra) # 80000c3e <acquire>
  lk->locked = 0;
    800047d4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800047d8:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800047dc:	8526                	mv	a0,s1
    800047de:	ffffe097          	auipc	ra,0xffffe
    800047e2:	ba0080e7          	jalr	-1120(ra) # 8000237e <wakeup>
  release(&lk->lk);
    800047e6:	854a                	mv	a0,s2
    800047e8:	ffffc097          	auipc	ra,0xffffc
    800047ec:	506080e7          	jalr	1286(ra) # 80000cee <release>
}
    800047f0:	60e2                	ld	ra,24(sp)
    800047f2:	6442                	ld	s0,16(sp)
    800047f4:	64a2                	ld	s1,8(sp)
    800047f6:	6902                	ld	s2,0(sp)
    800047f8:	6105                	addi	sp,sp,32
    800047fa:	8082                	ret

00000000800047fc <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800047fc:	7179                	addi	sp,sp,-48
    800047fe:	f406                	sd	ra,40(sp)
    80004800:	f022                	sd	s0,32(sp)
    80004802:	ec26                	sd	s1,24(sp)
    80004804:	e84a                	sd	s2,16(sp)
    80004806:	1800                	addi	s0,sp,48
    80004808:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000480a:	00850913          	addi	s2,a0,8
    8000480e:	854a                	mv	a0,s2
    80004810:	ffffc097          	auipc	ra,0xffffc
    80004814:	42e080e7          	jalr	1070(ra) # 80000c3e <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004818:	409c                	lw	a5,0(s1)
    8000481a:	ef91                	bnez	a5,80004836 <holdingsleep+0x3a>
    8000481c:	4481                	li	s1,0
  release(&lk->lk);
    8000481e:	854a                	mv	a0,s2
    80004820:	ffffc097          	auipc	ra,0xffffc
    80004824:	4ce080e7          	jalr	1230(ra) # 80000cee <release>
  return r;
}
    80004828:	8526                	mv	a0,s1
    8000482a:	70a2                	ld	ra,40(sp)
    8000482c:	7402                	ld	s0,32(sp)
    8000482e:	64e2                	ld	s1,24(sp)
    80004830:	6942                	ld	s2,16(sp)
    80004832:	6145                	addi	sp,sp,48
    80004834:	8082                	ret
    80004836:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004838:	0284a983          	lw	s3,40(s1)
    8000483c:	ffffd097          	auipc	ra,0xffffd
    80004840:	304080e7          	jalr	772(ra) # 80001b40 <myproc>
    80004844:	5904                	lw	s1,48(a0)
    80004846:	413484b3          	sub	s1,s1,s3
    8000484a:	0014b493          	seqz	s1,s1
    8000484e:	69a2                	ld	s3,8(sp)
    80004850:	b7f9                	j	8000481e <holdingsleep+0x22>

0000000080004852 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004852:	1141                	addi	sp,sp,-16
    80004854:	e406                	sd	ra,8(sp)
    80004856:	e022                	sd	s0,0(sp)
    80004858:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000485a:	00004597          	auipc	a1,0x4
    8000485e:	dfe58593          	addi	a1,a1,-514 # 80008658 <etext+0x658>
    80004862:	0001c517          	auipc	a0,0x1c
    80004866:	51650513          	addi	a0,a0,1302 # 80020d78 <ftable>
    8000486a:	ffffc097          	auipc	ra,0xffffc
    8000486e:	340080e7          	jalr	832(ra) # 80000baa <initlock>
}
    80004872:	60a2                	ld	ra,8(sp)
    80004874:	6402                	ld	s0,0(sp)
    80004876:	0141                	addi	sp,sp,16
    80004878:	8082                	ret

000000008000487a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000487a:	1101                	addi	sp,sp,-32
    8000487c:	ec06                	sd	ra,24(sp)
    8000487e:	e822                	sd	s0,16(sp)
    80004880:	e426                	sd	s1,8(sp)
    80004882:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004884:	0001c517          	auipc	a0,0x1c
    80004888:	4f450513          	addi	a0,a0,1268 # 80020d78 <ftable>
    8000488c:	ffffc097          	auipc	ra,0xffffc
    80004890:	3b2080e7          	jalr	946(ra) # 80000c3e <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004894:	0001c497          	auipc	s1,0x1c
    80004898:	4fc48493          	addi	s1,s1,1276 # 80020d90 <ftable+0x18>
    8000489c:	0001d717          	auipc	a4,0x1d
    800048a0:	49470713          	addi	a4,a4,1172 # 80021d30 <disk>
    if(f->ref == 0){
    800048a4:	40dc                	lw	a5,4(s1)
    800048a6:	cf99                	beqz	a5,800048c4 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800048a8:	02848493          	addi	s1,s1,40
    800048ac:	fee49ce3          	bne	s1,a4,800048a4 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800048b0:	0001c517          	auipc	a0,0x1c
    800048b4:	4c850513          	addi	a0,a0,1224 # 80020d78 <ftable>
    800048b8:	ffffc097          	auipc	ra,0xffffc
    800048bc:	436080e7          	jalr	1078(ra) # 80000cee <release>
  return 0;
    800048c0:	4481                	li	s1,0
    800048c2:	a819                	j	800048d8 <filealloc+0x5e>
      f->ref = 1;
    800048c4:	4785                	li	a5,1
    800048c6:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800048c8:	0001c517          	auipc	a0,0x1c
    800048cc:	4b050513          	addi	a0,a0,1200 # 80020d78 <ftable>
    800048d0:	ffffc097          	auipc	ra,0xffffc
    800048d4:	41e080e7          	jalr	1054(ra) # 80000cee <release>
}
    800048d8:	8526                	mv	a0,s1
    800048da:	60e2                	ld	ra,24(sp)
    800048dc:	6442                	ld	s0,16(sp)
    800048de:	64a2                	ld	s1,8(sp)
    800048e0:	6105                	addi	sp,sp,32
    800048e2:	8082                	ret

00000000800048e4 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800048e4:	1101                	addi	sp,sp,-32
    800048e6:	ec06                	sd	ra,24(sp)
    800048e8:	e822                	sd	s0,16(sp)
    800048ea:	e426                	sd	s1,8(sp)
    800048ec:	1000                	addi	s0,sp,32
    800048ee:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800048f0:	0001c517          	auipc	a0,0x1c
    800048f4:	48850513          	addi	a0,a0,1160 # 80020d78 <ftable>
    800048f8:	ffffc097          	auipc	ra,0xffffc
    800048fc:	346080e7          	jalr	838(ra) # 80000c3e <acquire>
  if(f->ref < 1)
    80004900:	40dc                	lw	a5,4(s1)
    80004902:	02f05263          	blez	a5,80004926 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004906:	2785                	addiw	a5,a5,1
    80004908:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000490a:	0001c517          	auipc	a0,0x1c
    8000490e:	46e50513          	addi	a0,a0,1134 # 80020d78 <ftable>
    80004912:	ffffc097          	auipc	ra,0xffffc
    80004916:	3dc080e7          	jalr	988(ra) # 80000cee <release>
  return f;
}
    8000491a:	8526                	mv	a0,s1
    8000491c:	60e2                	ld	ra,24(sp)
    8000491e:	6442                	ld	s0,16(sp)
    80004920:	64a2                	ld	s1,8(sp)
    80004922:	6105                	addi	sp,sp,32
    80004924:	8082                	ret
    panic("filedup");
    80004926:	00004517          	auipc	a0,0x4
    8000492a:	d3a50513          	addi	a0,a0,-710 # 80008660 <etext+0x660>
    8000492e:	ffffc097          	auipc	ra,0xffffc
    80004932:	c32080e7          	jalr	-974(ra) # 80000560 <panic>

0000000080004936 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004936:	7139                	addi	sp,sp,-64
    80004938:	fc06                	sd	ra,56(sp)
    8000493a:	f822                	sd	s0,48(sp)
    8000493c:	f426                	sd	s1,40(sp)
    8000493e:	0080                	addi	s0,sp,64
    80004940:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004942:	0001c517          	auipc	a0,0x1c
    80004946:	43650513          	addi	a0,a0,1078 # 80020d78 <ftable>
    8000494a:	ffffc097          	auipc	ra,0xffffc
    8000494e:	2f4080e7          	jalr	756(ra) # 80000c3e <acquire>
  if(f->ref < 1)
    80004952:	40dc                	lw	a5,4(s1)
    80004954:	04f05a63          	blez	a5,800049a8 <fileclose+0x72>
    panic("fileclose");
  if(--f->ref > 0){
    80004958:	37fd                	addiw	a5,a5,-1
    8000495a:	c0dc                	sw	a5,4(s1)
    8000495c:	06f04263          	bgtz	a5,800049c0 <fileclose+0x8a>
    80004960:	f04a                	sd	s2,32(sp)
    80004962:	ec4e                	sd	s3,24(sp)
    80004964:	e852                	sd	s4,16(sp)
    80004966:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004968:	0004a903          	lw	s2,0(s1)
    8000496c:	0094ca83          	lbu	s5,9(s1)
    80004970:	0104ba03          	ld	s4,16(s1)
    80004974:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004978:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000497c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004980:	0001c517          	auipc	a0,0x1c
    80004984:	3f850513          	addi	a0,a0,1016 # 80020d78 <ftable>
    80004988:	ffffc097          	auipc	ra,0xffffc
    8000498c:	366080e7          	jalr	870(ra) # 80000cee <release>

  if(ff.type == FD_PIPE){
    80004990:	4785                	li	a5,1
    80004992:	04f90463          	beq	s2,a5,800049da <fileclose+0xa4>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004996:	3979                	addiw	s2,s2,-2
    80004998:	4785                	li	a5,1
    8000499a:	0527fb63          	bgeu	a5,s2,800049f0 <fileclose+0xba>
    8000499e:	7902                	ld	s2,32(sp)
    800049a0:	69e2                	ld	s3,24(sp)
    800049a2:	6a42                	ld	s4,16(sp)
    800049a4:	6aa2                	ld	s5,8(sp)
    800049a6:	a02d                	j	800049d0 <fileclose+0x9a>
    800049a8:	f04a                	sd	s2,32(sp)
    800049aa:	ec4e                	sd	s3,24(sp)
    800049ac:	e852                	sd	s4,16(sp)
    800049ae:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800049b0:	00004517          	auipc	a0,0x4
    800049b4:	cb850513          	addi	a0,a0,-840 # 80008668 <etext+0x668>
    800049b8:	ffffc097          	auipc	ra,0xffffc
    800049bc:	ba8080e7          	jalr	-1112(ra) # 80000560 <panic>
    release(&ftable.lock);
    800049c0:	0001c517          	auipc	a0,0x1c
    800049c4:	3b850513          	addi	a0,a0,952 # 80020d78 <ftable>
    800049c8:	ffffc097          	auipc	ra,0xffffc
    800049cc:	326080e7          	jalr	806(ra) # 80000cee <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800049d0:	70e2                	ld	ra,56(sp)
    800049d2:	7442                	ld	s0,48(sp)
    800049d4:	74a2                	ld	s1,40(sp)
    800049d6:	6121                	addi	sp,sp,64
    800049d8:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800049da:	85d6                	mv	a1,s5
    800049dc:	8552                	mv	a0,s4
    800049de:	00000097          	auipc	ra,0x0
    800049e2:	3ac080e7          	jalr	940(ra) # 80004d8a <pipeclose>
    800049e6:	7902                	ld	s2,32(sp)
    800049e8:	69e2                	ld	s3,24(sp)
    800049ea:	6a42                	ld	s4,16(sp)
    800049ec:	6aa2                	ld	s5,8(sp)
    800049ee:	b7cd                	j	800049d0 <fileclose+0x9a>
    begin_op();
    800049f0:	00000097          	auipc	ra,0x0
    800049f4:	a76080e7          	jalr	-1418(ra) # 80004466 <begin_op>
    iput(ff.ip);
    800049f8:	854e                	mv	a0,s3
    800049fa:	fffff097          	auipc	ra,0xfffff
    800049fe:	240080e7          	jalr	576(ra) # 80003c3a <iput>
    end_op();
    80004a02:	00000097          	auipc	ra,0x0
    80004a06:	ade080e7          	jalr	-1314(ra) # 800044e0 <end_op>
    80004a0a:	7902                	ld	s2,32(sp)
    80004a0c:	69e2                	ld	s3,24(sp)
    80004a0e:	6a42                	ld	s4,16(sp)
    80004a10:	6aa2                	ld	s5,8(sp)
    80004a12:	bf7d                	j	800049d0 <fileclose+0x9a>

0000000080004a14 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004a14:	715d                	addi	sp,sp,-80
    80004a16:	e486                	sd	ra,72(sp)
    80004a18:	e0a2                	sd	s0,64(sp)
    80004a1a:	fc26                	sd	s1,56(sp)
    80004a1c:	f44e                	sd	s3,40(sp)
    80004a1e:	0880                	addi	s0,sp,80
    80004a20:	84aa                	mv	s1,a0
    80004a22:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004a24:	ffffd097          	auipc	ra,0xffffd
    80004a28:	11c080e7          	jalr	284(ra) # 80001b40 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004a2c:	409c                	lw	a5,0(s1)
    80004a2e:	37f9                	addiw	a5,a5,-2
    80004a30:	4705                	li	a4,1
    80004a32:	04f76a63          	bltu	a4,a5,80004a86 <filestat+0x72>
    80004a36:	f84a                	sd	s2,48(sp)
    80004a38:	f052                	sd	s4,32(sp)
    80004a3a:	892a                	mv	s2,a0
    ilock(f->ip);
    80004a3c:	6c88                	ld	a0,24(s1)
    80004a3e:	fffff097          	auipc	ra,0xfffff
    80004a42:	03e080e7          	jalr	62(ra) # 80003a7c <ilock>
    stati(f->ip, &st);
    80004a46:	fb840a13          	addi	s4,s0,-72
    80004a4a:	85d2                	mv	a1,s4
    80004a4c:	6c88                	ld	a0,24(s1)
    80004a4e:	fffff097          	auipc	ra,0xfffff
    80004a52:	2bc080e7          	jalr	700(ra) # 80003d0a <stati>
    iunlock(f->ip);
    80004a56:	6c88                	ld	a0,24(s1)
    80004a58:	fffff097          	auipc	ra,0xfffff
    80004a5c:	0ea080e7          	jalr	234(ra) # 80003b42 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004a60:	46e1                	li	a3,24
    80004a62:	8652                	mv	a2,s4
    80004a64:	85ce                	mv	a1,s3
    80004a66:	05093503          	ld	a0,80(s2)
    80004a6a:	ffffd097          	auipc	ra,0xffffd
    80004a6e:	ca6080e7          	jalr	-858(ra) # 80001710 <copyout>
    80004a72:	41f5551b          	sraiw	a0,a0,0x1f
    80004a76:	7942                	ld	s2,48(sp)
    80004a78:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004a7a:	60a6                	ld	ra,72(sp)
    80004a7c:	6406                	ld	s0,64(sp)
    80004a7e:	74e2                	ld	s1,56(sp)
    80004a80:	79a2                	ld	s3,40(sp)
    80004a82:	6161                	addi	sp,sp,80
    80004a84:	8082                	ret
  return -1;
    80004a86:	557d                	li	a0,-1
    80004a88:	bfcd                	j	80004a7a <filestat+0x66>

0000000080004a8a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004a8a:	7179                	addi	sp,sp,-48
    80004a8c:	f406                	sd	ra,40(sp)
    80004a8e:	f022                	sd	s0,32(sp)
    80004a90:	e84a                	sd	s2,16(sp)
    80004a92:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004a94:	00854783          	lbu	a5,8(a0)
    80004a98:	cbc5                	beqz	a5,80004b48 <fileread+0xbe>
    80004a9a:	ec26                	sd	s1,24(sp)
    80004a9c:	e44e                	sd	s3,8(sp)
    80004a9e:	84aa                	mv	s1,a0
    80004aa0:	89ae                	mv	s3,a1
    80004aa2:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004aa4:	411c                	lw	a5,0(a0)
    80004aa6:	4705                	li	a4,1
    80004aa8:	04e78963          	beq	a5,a4,80004afa <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004aac:	470d                	li	a4,3
    80004aae:	04e78f63          	beq	a5,a4,80004b0c <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004ab2:	4709                	li	a4,2
    80004ab4:	08e79263          	bne	a5,a4,80004b38 <fileread+0xae>
    ilock(f->ip);
    80004ab8:	6d08                	ld	a0,24(a0)
    80004aba:	fffff097          	auipc	ra,0xfffff
    80004abe:	fc2080e7          	jalr	-62(ra) # 80003a7c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004ac2:	874a                	mv	a4,s2
    80004ac4:	5094                	lw	a3,32(s1)
    80004ac6:	864e                	mv	a2,s3
    80004ac8:	4585                	li	a1,1
    80004aca:	6c88                	ld	a0,24(s1)
    80004acc:	fffff097          	auipc	ra,0xfffff
    80004ad0:	26c080e7          	jalr	620(ra) # 80003d38 <readi>
    80004ad4:	892a                	mv	s2,a0
    80004ad6:	00a05563          	blez	a0,80004ae0 <fileread+0x56>
      f->off += r;
    80004ada:	509c                	lw	a5,32(s1)
    80004adc:	9fa9                	addw	a5,a5,a0
    80004ade:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004ae0:	6c88                	ld	a0,24(s1)
    80004ae2:	fffff097          	auipc	ra,0xfffff
    80004ae6:	060080e7          	jalr	96(ra) # 80003b42 <iunlock>
    80004aea:	64e2                	ld	s1,24(sp)
    80004aec:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004aee:	854a                	mv	a0,s2
    80004af0:	70a2                	ld	ra,40(sp)
    80004af2:	7402                	ld	s0,32(sp)
    80004af4:	6942                	ld	s2,16(sp)
    80004af6:	6145                	addi	sp,sp,48
    80004af8:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004afa:	6908                	ld	a0,16(a0)
    80004afc:	00000097          	auipc	ra,0x0
    80004b00:	41a080e7          	jalr	1050(ra) # 80004f16 <piperead>
    80004b04:	892a                	mv	s2,a0
    80004b06:	64e2                	ld	s1,24(sp)
    80004b08:	69a2                	ld	s3,8(sp)
    80004b0a:	b7d5                	j	80004aee <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004b0c:	02451783          	lh	a5,36(a0)
    80004b10:	03079693          	slli	a3,a5,0x30
    80004b14:	92c1                	srli	a3,a3,0x30
    80004b16:	4725                	li	a4,9
    80004b18:	02d76a63          	bltu	a4,a3,80004b4c <fileread+0xc2>
    80004b1c:	0792                	slli	a5,a5,0x4
    80004b1e:	0001c717          	auipc	a4,0x1c
    80004b22:	1ba70713          	addi	a4,a4,442 # 80020cd8 <devsw>
    80004b26:	97ba                	add	a5,a5,a4
    80004b28:	639c                	ld	a5,0(a5)
    80004b2a:	c78d                	beqz	a5,80004b54 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80004b2c:	4505                	li	a0,1
    80004b2e:	9782                	jalr	a5
    80004b30:	892a                	mv	s2,a0
    80004b32:	64e2                	ld	s1,24(sp)
    80004b34:	69a2                	ld	s3,8(sp)
    80004b36:	bf65                	j	80004aee <fileread+0x64>
    panic("fileread");
    80004b38:	00004517          	auipc	a0,0x4
    80004b3c:	b4050513          	addi	a0,a0,-1216 # 80008678 <etext+0x678>
    80004b40:	ffffc097          	auipc	ra,0xffffc
    80004b44:	a20080e7          	jalr	-1504(ra) # 80000560 <panic>
    return -1;
    80004b48:	597d                	li	s2,-1
    80004b4a:	b755                	j	80004aee <fileread+0x64>
      return -1;
    80004b4c:	597d                	li	s2,-1
    80004b4e:	64e2                	ld	s1,24(sp)
    80004b50:	69a2                	ld	s3,8(sp)
    80004b52:	bf71                	j	80004aee <fileread+0x64>
    80004b54:	597d                	li	s2,-1
    80004b56:	64e2                	ld	s1,24(sp)
    80004b58:	69a2                	ld	s3,8(sp)
    80004b5a:	bf51                	j	80004aee <fileread+0x64>

0000000080004b5c <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004b5c:	00954783          	lbu	a5,9(a0)
    80004b60:	12078c63          	beqz	a5,80004c98 <filewrite+0x13c>
{
    80004b64:	711d                	addi	sp,sp,-96
    80004b66:	ec86                	sd	ra,88(sp)
    80004b68:	e8a2                	sd	s0,80(sp)
    80004b6a:	e0ca                	sd	s2,64(sp)
    80004b6c:	f456                	sd	s5,40(sp)
    80004b6e:	f05a                	sd	s6,32(sp)
    80004b70:	1080                	addi	s0,sp,96
    80004b72:	892a                	mv	s2,a0
    80004b74:	8b2e                	mv	s6,a1
    80004b76:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80004b78:	411c                	lw	a5,0(a0)
    80004b7a:	4705                	li	a4,1
    80004b7c:	02e78963          	beq	a5,a4,80004bae <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004b80:	470d                	li	a4,3
    80004b82:	02e78c63          	beq	a5,a4,80004bba <filewrite+0x5e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004b86:	4709                	li	a4,2
    80004b88:	0ee79a63          	bne	a5,a4,80004c7c <filewrite+0x120>
    80004b8c:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004b8e:	0cc05563          	blez	a2,80004c58 <filewrite+0xfc>
    80004b92:	e4a6                	sd	s1,72(sp)
    80004b94:	fc4e                	sd	s3,56(sp)
    80004b96:	ec5e                	sd	s7,24(sp)
    80004b98:	e862                	sd	s8,16(sp)
    80004b9a:	e466                	sd	s9,8(sp)
    int i = 0;
    80004b9c:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80004b9e:	6b85                	lui	s7,0x1
    80004ba0:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004ba4:	6c85                	lui	s9,0x1
    80004ba6:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004baa:	4c05                	li	s8,1
    80004bac:	a849                	j	80004c3e <filewrite+0xe2>
    ret = pipewrite(f->pipe, addr, n);
    80004bae:	6908                	ld	a0,16(a0)
    80004bb0:	00000097          	auipc	ra,0x0
    80004bb4:	24a080e7          	jalr	586(ra) # 80004dfa <pipewrite>
    80004bb8:	a85d                	j	80004c6e <filewrite+0x112>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004bba:	02451783          	lh	a5,36(a0)
    80004bbe:	03079693          	slli	a3,a5,0x30
    80004bc2:	92c1                	srli	a3,a3,0x30
    80004bc4:	4725                	li	a4,9
    80004bc6:	0cd76b63          	bltu	a4,a3,80004c9c <filewrite+0x140>
    80004bca:	0792                	slli	a5,a5,0x4
    80004bcc:	0001c717          	auipc	a4,0x1c
    80004bd0:	10c70713          	addi	a4,a4,268 # 80020cd8 <devsw>
    80004bd4:	97ba                	add	a5,a5,a4
    80004bd6:	679c                	ld	a5,8(a5)
    80004bd8:	c7e1                	beqz	a5,80004ca0 <filewrite+0x144>
    ret = devsw[f->major].write(1, addr, n);
    80004bda:	4505                	li	a0,1
    80004bdc:	9782                	jalr	a5
    80004bde:	a841                	j	80004c6e <filewrite+0x112>
      if(n1 > max)
    80004be0:	2981                	sext.w	s3,s3
      begin_op();
    80004be2:	00000097          	auipc	ra,0x0
    80004be6:	884080e7          	jalr	-1916(ra) # 80004466 <begin_op>
      ilock(f->ip);
    80004bea:	01893503          	ld	a0,24(s2)
    80004bee:	fffff097          	auipc	ra,0xfffff
    80004bf2:	e8e080e7          	jalr	-370(ra) # 80003a7c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004bf6:	874e                	mv	a4,s3
    80004bf8:	02092683          	lw	a3,32(s2)
    80004bfc:	016a0633          	add	a2,s4,s6
    80004c00:	85e2                	mv	a1,s8
    80004c02:	01893503          	ld	a0,24(s2)
    80004c06:	fffff097          	auipc	ra,0xfffff
    80004c0a:	238080e7          	jalr	568(ra) # 80003e3e <writei>
    80004c0e:	84aa                	mv	s1,a0
    80004c10:	00a05763          	blez	a0,80004c1e <filewrite+0xc2>
        f->off += r;
    80004c14:	02092783          	lw	a5,32(s2)
    80004c18:	9fa9                	addw	a5,a5,a0
    80004c1a:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004c1e:	01893503          	ld	a0,24(s2)
    80004c22:	fffff097          	auipc	ra,0xfffff
    80004c26:	f20080e7          	jalr	-224(ra) # 80003b42 <iunlock>
      end_op();
    80004c2a:	00000097          	auipc	ra,0x0
    80004c2e:	8b6080e7          	jalr	-1866(ra) # 800044e0 <end_op>

      if(r != n1){
    80004c32:	02999563          	bne	s3,s1,80004c5c <filewrite+0x100>
        // error from writei
        break;
      }
      i += r;
    80004c36:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80004c3a:	015a5963          	bge	s4,s5,80004c4c <filewrite+0xf0>
      int n1 = n - i;
    80004c3e:	414a87bb          	subw	a5,s5,s4
    80004c42:	89be                	mv	s3,a5
      if(n1 > max)
    80004c44:	f8fbdee3          	bge	s7,a5,80004be0 <filewrite+0x84>
    80004c48:	89e6                	mv	s3,s9
    80004c4a:	bf59                	j	80004be0 <filewrite+0x84>
    80004c4c:	64a6                	ld	s1,72(sp)
    80004c4e:	79e2                	ld	s3,56(sp)
    80004c50:	6be2                	ld	s7,24(sp)
    80004c52:	6c42                	ld	s8,16(sp)
    80004c54:	6ca2                	ld	s9,8(sp)
    80004c56:	a801                	j	80004c66 <filewrite+0x10a>
    int i = 0;
    80004c58:	4a01                	li	s4,0
    80004c5a:	a031                	j	80004c66 <filewrite+0x10a>
    80004c5c:	64a6                	ld	s1,72(sp)
    80004c5e:	79e2                	ld	s3,56(sp)
    80004c60:	6be2                	ld	s7,24(sp)
    80004c62:	6c42                	ld	s8,16(sp)
    80004c64:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80004c66:	034a9f63          	bne	s5,s4,80004ca4 <filewrite+0x148>
    80004c6a:	8556                	mv	a0,s5
    80004c6c:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004c6e:	60e6                	ld	ra,88(sp)
    80004c70:	6446                	ld	s0,80(sp)
    80004c72:	6906                	ld	s2,64(sp)
    80004c74:	7aa2                	ld	s5,40(sp)
    80004c76:	7b02                	ld	s6,32(sp)
    80004c78:	6125                	addi	sp,sp,96
    80004c7a:	8082                	ret
    80004c7c:	e4a6                	sd	s1,72(sp)
    80004c7e:	fc4e                	sd	s3,56(sp)
    80004c80:	f852                	sd	s4,48(sp)
    80004c82:	ec5e                	sd	s7,24(sp)
    80004c84:	e862                	sd	s8,16(sp)
    80004c86:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80004c88:	00004517          	auipc	a0,0x4
    80004c8c:	a0050513          	addi	a0,a0,-1536 # 80008688 <etext+0x688>
    80004c90:	ffffc097          	auipc	ra,0xffffc
    80004c94:	8d0080e7          	jalr	-1840(ra) # 80000560 <panic>
    return -1;
    80004c98:	557d                	li	a0,-1
}
    80004c9a:	8082                	ret
      return -1;
    80004c9c:	557d                	li	a0,-1
    80004c9e:	bfc1                	j	80004c6e <filewrite+0x112>
    80004ca0:	557d                	li	a0,-1
    80004ca2:	b7f1                	j	80004c6e <filewrite+0x112>
    ret = (i == n ? n : -1);
    80004ca4:	557d                	li	a0,-1
    80004ca6:	7a42                	ld	s4,48(sp)
    80004ca8:	b7d9                	j	80004c6e <filewrite+0x112>

0000000080004caa <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004caa:	7179                	addi	sp,sp,-48
    80004cac:	f406                	sd	ra,40(sp)
    80004cae:	f022                	sd	s0,32(sp)
    80004cb0:	ec26                	sd	s1,24(sp)
    80004cb2:	e052                	sd	s4,0(sp)
    80004cb4:	1800                	addi	s0,sp,48
    80004cb6:	84aa                	mv	s1,a0
    80004cb8:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004cba:	0005b023          	sd	zero,0(a1)
    80004cbe:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004cc2:	00000097          	auipc	ra,0x0
    80004cc6:	bb8080e7          	jalr	-1096(ra) # 8000487a <filealloc>
    80004cca:	e088                	sd	a0,0(s1)
    80004ccc:	cd49                	beqz	a0,80004d66 <pipealloc+0xbc>
    80004cce:	00000097          	auipc	ra,0x0
    80004cd2:	bac080e7          	jalr	-1108(ra) # 8000487a <filealloc>
    80004cd6:	00aa3023          	sd	a0,0(s4)
    80004cda:	c141                	beqz	a0,80004d5a <pipealloc+0xb0>
    80004cdc:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004cde:	ffffc097          	auipc	ra,0xffffc
    80004ce2:	e6c080e7          	jalr	-404(ra) # 80000b4a <kalloc>
    80004ce6:	892a                	mv	s2,a0
    80004ce8:	c13d                	beqz	a0,80004d4e <pipealloc+0xa4>
    80004cea:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004cec:	4985                	li	s3,1
    80004cee:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004cf2:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004cf6:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004cfa:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004cfe:	00004597          	auipc	a1,0x4
    80004d02:	99a58593          	addi	a1,a1,-1638 # 80008698 <etext+0x698>
    80004d06:	ffffc097          	auipc	ra,0xffffc
    80004d0a:	ea4080e7          	jalr	-348(ra) # 80000baa <initlock>
  (*f0)->type = FD_PIPE;
    80004d0e:	609c                	ld	a5,0(s1)
    80004d10:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004d14:	609c                	ld	a5,0(s1)
    80004d16:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004d1a:	609c                	ld	a5,0(s1)
    80004d1c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004d20:	609c                	ld	a5,0(s1)
    80004d22:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004d26:	000a3783          	ld	a5,0(s4)
    80004d2a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004d2e:	000a3783          	ld	a5,0(s4)
    80004d32:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004d36:	000a3783          	ld	a5,0(s4)
    80004d3a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004d3e:	000a3783          	ld	a5,0(s4)
    80004d42:	0127b823          	sd	s2,16(a5)
  return 0;
    80004d46:	4501                	li	a0,0
    80004d48:	6942                	ld	s2,16(sp)
    80004d4a:	69a2                	ld	s3,8(sp)
    80004d4c:	a03d                	j	80004d7a <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004d4e:	6088                	ld	a0,0(s1)
    80004d50:	c119                	beqz	a0,80004d56 <pipealloc+0xac>
    80004d52:	6942                	ld	s2,16(sp)
    80004d54:	a029                	j	80004d5e <pipealloc+0xb4>
    80004d56:	6942                	ld	s2,16(sp)
    80004d58:	a039                	j	80004d66 <pipealloc+0xbc>
    80004d5a:	6088                	ld	a0,0(s1)
    80004d5c:	c50d                	beqz	a0,80004d86 <pipealloc+0xdc>
    fileclose(*f0);
    80004d5e:	00000097          	auipc	ra,0x0
    80004d62:	bd8080e7          	jalr	-1064(ra) # 80004936 <fileclose>
  if(*f1)
    80004d66:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004d6a:	557d                	li	a0,-1
  if(*f1)
    80004d6c:	c799                	beqz	a5,80004d7a <pipealloc+0xd0>
    fileclose(*f1);
    80004d6e:	853e                	mv	a0,a5
    80004d70:	00000097          	auipc	ra,0x0
    80004d74:	bc6080e7          	jalr	-1082(ra) # 80004936 <fileclose>
  return -1;
    80004d78:	557d                	li	a0,-1
}
    80004d7a:	70a2                	ld	ra,40(sp)
    80004d7c:	7402                	ld	s0,32(sp)
    80004d7e:	64e2                	ld	s1,24(sp)
    80004d80:	6a02                	ld	s4,0(sp)
    80004d82:	6145                	addi	sp,sp,48
    80004d84:	8082                	ret
  return -1;
    80004d86:	557d                	li	a0,-1
    80004d88:	bfcd                	j	80004d7a <pipealloc+0xd0>

0000000080004d8a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004d8a:	1101                	addi	sp,sp,-32
    80004d8c:	ec06                	sd	ra,24(sp)
    80004d8e:	e822                	sd	s0,16(sp)
    80004d90:	e426                	sd	s1,8(sp)
    80004d92:	e04a                	sd	s2,0(sp)
    80004d94:	1000                	addi	s0,sp,32
    80004d96:	84aa                	mv	s1,a0
    80004d98:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004d9a:	ffffc097          	auipc	ra,0xffffc
    80004d9e:	ea4080e7          	jalr	-348(ra) # 80000c3e <acquire>
  if(writable){
    80004da2:	02090d63          	beqz	s2,80004ddc <pipeclose+0x52>
    pi->writeopen = 0;
    80004da6:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004daa:	21848513          	addi	a0,s1,536
    80004dae:	ffffd097          	auipc	ra,0xffffd
    80004db2:	5d0080e7          	jalr	1488(ra) # 8000237e <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004db6:	2204b783          	ld	a5,544(s1)
    80004dba:	eb95                	bnez	a5,80004dee <pipeclose+0x64>
    release(&pi->lock);
    80004dbc:	8526                	mv	a0,s1
    80004dbe:	ffffc097          	auipc	ra,0xffffc
    80004dc2:	f30080e7          	jalr	-208(ra) # 80000cee <release>
    kfree((char*)pi);
    80004dc6:	8526                	mv	a0,s1
    80004dc8:	ffffc097          	auipc	ra,0xffffc
    80004dcc:	c84080e7          	jalr	-892(ra) # 80000a4c <kfree>
  } else
    release(&pi->lock);
}
    80004dd0:	60e2                	ld	ra,24(sp)
    80004dd2:	6442                	ld	s0,16(sp)
    80004dd4:	64a2                	ld	s1,8(sp)
    80004dd6:	6902                	ld	s2,0(sp)
    80004dd8:	6105                	addi	sp,sp,32
    80004dda:	8082                	ret
    pi->readopen = 0;
    80004ddc:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004de0:	21c48513          	addi	a0,s1,540
    80004de4:	ffffd097          	auipc	ra,0xffffd
    80004de8:	59a080e7          	jalr	1434(ra) # 8000237e <wakeup>
    80004dec:	b7e9                	j	80004db6 <pipeclose+0x2c>
    release(&pi->lock);
    80004dee:	8526                	mv	a0,s1
    80004df0:	ffffc097          	auipc	ra,0xffffc
    80004df4:	efe080e7          	jalr	-258(ra) # 80000cee <release>
}
    80004df8:	bfe1                	j	80004dd0 <pipeclose+0x46>

0000000080004dfa <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004dfa:	7159                	addi	sp,sp,-112
    80004dfc:	f486                	sd	ra,104(sp)
    80004dfe:	f0a2                	sd	s0,96(sp)
    80004e00:	eca6                	sd	s1,88(sp)
    80004e02:	e8ca                	sd	s2,80(sp)
    80004e04:	e4ce                	sd	s3,72(sp)
    80004e06:	e0d2                	sd	s4,64(sp)
    80004e08:	fc56                	sd	s5,56(sp)
    80004e0a:	1880                	addi	s0,sp,112
    80004e0c:	84aa                	mv	s1,a0
    80004e0e:	8aae                	mv	s5,a1
    80004e10:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004e12:	ffffd097          	auipc	ra,0xffffd
    80004e16:	d2e080e7          	jalr	-722(ra) # 80001b40 <myproc>
    80004e1a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004e1c:	8526                	mv	a0,s1
    80004e1e:	ffffc097          	auipc	ra,0xffffc
    80004e22:	e20080e7          	jalr	-480(ra) # 80000c3e <acquire>
  while(i < n){
    80004e26:	0f405063          	blez	s4,80004f06 <pipewrite+0x10c>
    80004e2a:	f85a                	sd	s6,48(sp)
    80004e2c:	f45e                	sd	s7,40(sp)
    80004e2e:	f062                	sd	s8,32(sp)
    80004e30:	ec66                	sd	s9,24(sp)
    80004e32:	e86a                	sd	s10,16(sp)
  int i = 0;
    80004e34:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004e36:	f9f40c13          	addi	s8,s0,-97
    80004e3a:	4b85                	li	s7,1
    80004e3c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004e3e:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004e42:	21c48c93          	addi	s9,s1,540
    80004e46:	a099                	j	80004e8c <pipewrite+0x92>
      release(&pi->lock);
    80004e48:	8526                	mv	a0,s1
    80004e4a:	ffffc097          	auipc	ra,0xffffc
    80004e4e:	ea4080e7          	jalr	-348(ra) # 80000cee <release>
      return -1;
    80004e52:	597d                	li	s2,-1
    80004e54:	7b42                	ld	s6,48(sp)
    80004e56:	7ba2                	ld	s7,40(sp)
    80004e58:	7c02                	ld	s8,32(sp)
    80004e5a:	6ce2                	ld	s9,24(sp)
    80004e5c:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004e5e:	854a                	mv	a0,s2
    80004e60:	70a6                	ld	ra,104(sp)
    80004e62:	7406                	ld	s0,96(sp)
    80004e64:	64e6                	ld	s1,88(sp)
    80004e66:	6946                	ld	s2,80(sp)
    80004e68:	69a6                	ld	s3,72(sp)
    80004e6a:	6a06                	ld	s4,64(sp)
    80004e6c:	7ae2                	ld	s5,56(sp)
    80004e6e:	6165                	addi	sp,sp,112
    80004e70:	8082                	ret
      wakeup(&pi->nread);
    80004e72:	856a                	mv	a0,s10
    80004e74:	ffffd097          	auipc	ra,0xffffd
    80004e78:	50a080e7          	jalr	1290(ra) # 8000237e <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004e7c:	85a6                	mv	a1,s1
    80004e7e:	8566                	mv	a0,s9
    80004e80:	ffffd097          	auipc	ra,0xffffd
    80004e84:	49a080e7          	jalr	1178(ra) # 8000231a <sleep>
  while(i < n){
    80004e88:	05495e63          	bge	s2,s4,80004ee4 <pipewrite+0xea>
    if(pi->readopen == 0 || killed(pr)){
    80004e8c:	2204a783          	lw	a5,544(s1)
    80004e90:	dfc5                	beqz	a5,80004e48 <pipewrite+0x4e>
    80004e92:	854e                	mv	a0,s3
    80004e94:	ffffd097          	auipc	ra,0xffffd
    80004e98:	72e080e7          	jalr	1838(ra) # 800025c2 <killed>
    80004e9c:	f555                	bnez	a0,80004e48 <pipewrite+0x4e>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004e9e:	2184a783          	lw	a5,536(s1)
    80004ea2:	21c4a703          	lw	a4,540(s1)
    80004ea6:	2007879b          	addiw	a5,a5,512
    80004eaa:	fcf704e3          	beq	a4,a5,80004e72 <pipewrite+0x78>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004eae:	86de                	mv	a3,s7
    80004eb0:	01590633          	add	a2,s2,s5
    80004eb4:	85e2                	mv	a1,s8
    80004eb6:	0509b503          	ld	a0,80(s3)
    80004eba:	ffffd097          	auipc	ra,0xffffd
    80004ebe:	8e2080e7          	jalr	-1822(ra) # 8000179c <copyin>
    80004ec2:	05650463          	beq	a0,s6,80004f0a <pipewrite+0x110>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004ec6:	21c4a783          	lw	a5,540(s1)
    80004eca:	0017871b          	addiw	a4,a5,1
    80004ece:	20e4ae23          	sw	a4,540(s1)
    80004ed2:	1ff7f793          	andi	a5,a5,511
    80004ed6:	97a6                	add	a5,a5,s1
    80004ed8:	f9f44703          	lbu	a4,-97(s0)
    80004edc:	00e78c23          	sb	a4,24(a5)
      i++;
    80004ee0:	2905                	addiw	s2,s2,1
    80004ee2:	b75d                	j	80004e88 <pipewrite+0x8e>
    80004ee4:	7b42                	ld	s6,48(sp)
    80004ee6:	7ba2                	ld	s7,40(sp)
    80004ee8:	7c02                	ld	s8,32(sp)
    80004eea:	6ce2                	ld	s9,24(sp)
    80004eec:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80004eee:	21848513          	addi	a0,s1,536
    80004ef2:	ffffd097          	auipc	ra,0xffffd
    80004ef6:	48c080e7          	jalr	1164(ra) # 8000237e <wakeup>
  release(&pi->lock);
    80004efa:	8526                	mv	a0,s1
    80004efc:	ffffc097          	auipc	ra,0xffffc
    80004f00:	df2080e7          	jalr	-526(ra) # 80000cee <release>
  return i;
    80004f04:	bfa9                	j	80004e5e <pipewrite+0x64>
  int i = 0;
    80004f06:	4901                	li	s2,0
    80004f08:	b7dd                	j	80004eee <pipewrite+0xf4>
    80004f0a:	7b42                	ld	s6,48(sp)
    80004f0c:	7ba2                	ld	s7,40(sp)
    80004f0e:	7c02                	ld	s8,32(sp)
    80004f10:	6ce2                	ld	s9,24(sp)
    80004f12:	6d42                	ld	s10,16(sp)
    80004f14:	bfe9                	j	80004eee <pipewrite+0xf4>

0000000080004f16 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004f16:	711d                	addi	sp,sp,-96
    80004f18:	ec86                	sd	ra,88(sp)
    80004f1a:	e8a2                	sd	s0,80(sp)
    80004f1c:	e4a6                	sd	s1,72(sp)
    80004f1e:	e0ca                	sd	s2,64(sp)
    80004f20:	fc4e                	sd	s3,56(sp)
    80004f22:	f852                	sd	s4,48(sp)
    80004f24:	f456                	sd	s5,40(sp)
    80004f26:	1080                	addi	s0,sp,96
    80004f28:	84aa                	mv	s1,a0
    80004f2a:	892e                	mv	s2,a1
    80004f2c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004f2e:	ffffd097          	auipc	ra,0xffffd
    80004f32:	c12080e7          	jalr	-1006(ra) # 80001b40 <myproc>
    80004f36:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004f38:	8526                	mv	a0,s1
    80004f3a:	ffffc097          	auipc	ra,0xffffc
    80004f3e:	d04080e7          	jalr	-764(ra) # 80000c3e <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004f42:	2184a703          	lw	a4,536(s1)
    80004f46:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004f4a:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004f4e:	02f71b63          	bne	a4,a5,80004f84 <piperead+0x6e>
    80004f52:	2244a783          	lw	a5,548(s1)
    80004f56:	c3b1                	beqz	a5,80004f9a <piperead+0x84>
    if(killed(pr)){
    80004f58:	8552                	mv	a0,s4
    80004f5a:	ffffd097          	auipc	ra,0xffffd
    80004f5e:	668080e7          	jalr	1640(ra) # 800025c2 <killed>
    80004f62:	e50d                	bnez	a0,80004f8c <piperead+0x76>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004f64:	85a6                	mv	a1,s1
    80004f66:	854e                	mv	a0,s3
    80004f68:	ffffd097          	auipc	ra,0xffffd
    80004f6c:	3b2080e7          	jalr	946(ra) # 8000231a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004f70:	2184a703          	lw	a4,536(s1)
    80004f74:	21c4a783          	lw	a5,540(s1)
    80004f78:	fcf70de3          	beq	a4,a5,80004f52 <piperead+0x3c>
    80004f7c:	f05a                	sd	s6,32(sp)
    80004f7e:	ec5e                	sd	s7,24(sp)
    80004f80:	e862                	sd	s8,16(sp)
    80004f82:	a839                	j	80004fa0 <piperead+0x8a>
    80004f84:	f05a                	sd	s6,32(sp)
    80004f86:	ec5e                	sd	s7,24(sp)
    80004f88:	e862                	sd	s8,16(sp)
    80004f8a:	a819                	j	80004fa0 <piperead+0x8a>
      release(&pi->lock);
    80004f8c:	8526                	mv	a0,s1
    80004f8e:	ffffc097          	auipc	ra,0xffffc
    80004f92:	d60080e7          	jalr	-672(ra) # 80000cee <release>
      return -1;
    80004f96:	59fd                	li	s3,-1
    80004f98:	a895                	j	8000500c <piperead+0xf6>
    80004f9a:	f05a                	sd	s6,32(sp)
    80004f9c:	ec5e                	sd	s7,24(sp)
    80004f9e:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004fa0:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004fa2:	faf40c13          	addi	s8,s0,-81
    80004fa6:	4b85                	li	s7,1
    80004fa8:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004faa:	05505363          	blez	s5,80004ff0 <piperead+0xda>
    if(pi->nread == pi->nwrite)
    80004fae:	2184a783          	lw	a5,536(s1)
    80004fb2:	21c4a703          	lw	a4,540(s1)
    80004fb6:	02f70d63          	beq	a4,a5,80004ff0 <piperead+0xda>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004fba:	0017871b          	addiw	a4,a5,1
    80004fbe:	20e4ac23          	sw	a4,536(s1)
    80004fc2:	1ff7f793          	andi	a5,a5,511
    80004fc6:	97a6                	add	a5,a5,s1
    80004fc8:	0187c783          	lbu	a5,24(a5)
    80004fcc:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004fd0:	86de                	mv	a3,s7
    80004fd2:	8662                	mv	a2,s8
    80004fd4:	85ca                	mv	a1,s2
    80004fd6:	050a3503          	ld	a0,80(s4)
    80004fda:	ffffc097          	auipc	ra,0xffffc
    80004fde:	736080e7          	jalr	1846(ra) # 80001710 <copyout>
    80004fe2:	01650763          	beq	a0,s6,80004ff0 <piperead+0xda>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004fe6:	2985                	addiw	s3,s3,1
    80004fe8:	0905                	addi	s2,s2,1
    80004fea:	fd3a92e3          	bne	s5,s3,80004fae <piperead+0x98>
    80004fee:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004ff0:	21c48513          	addi	a0,s1,540
    80004ff4:	ffffd097          	auipc	ra,0xffffd
    80004ff8:	38a080e7          	jalr	906(ra) # 8000237e <wakeup>
  release(&pi->lock);
    80004ffc:	8526                	mv	a0,s1
    80004ffe:	ffffc097          	auipc	ra,0xffffc
    80005002:	cf0080e7          	jalr	-784(ra) # 80000cee <release>
    80005006:	7b02                	ld	s6,32(sp)
    80005008:	6be2                	ld	s7,24(sp)
    8000500a:	6c42                	ld	s8,16(sp)
  return i;
}
    8000500c:	854e                	mv	a0,s3
    8000500e:	60e6                	ld	ra,88(sp)
    80005010:	6446                	ld	s0,80(sp)
    80005012:	64a6                	ld	s1,72(sp)
    80005014:	6906                	ld	s2,64(sp)
    80005016:	79e2                	ld	s3,56(sp)
    80005018:	7a42                	ld	s4,48(sp)
    8000501a:	7aa2                	ld	s5,40(sp)
    8000501c:	6125                	addi	sp,sp,96
    8000501e:	8082                	ret

0000000080005020 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80005020:	1141                	addi	sp,sp,-16
    80005022:	e406                	sd	ra,8(sp)
    80005024:	e022                	sd	s0,0(sp)
    80005026:	0800                	addi	s0,sp,16
    80005028:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000502a:	0035151b          	slliw	a0,a0,0x3
    8000502e:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80005030:	8b89                	andi	a5,a5,2
    80005032:	c399                	beqz	a5,80005038 <flags2perm+0x18>
      perm |= PTE_W;
    80005034:	00456513          	ori	a0,a0,4
    return perm;
}
    80005038:	60a2                	ld	ra,8(sp)
    8000503a:	6402                	ld	s0,0(sp)
    8000503c:	0141                	addi	sp,sp,16
    8000503e:	8082                	ret

0000000080005040 <exec>:

int
exec(char *path, char **argv)
{
    80005040:	de010113          	addi	sp,sp,-544
    80005044:	20113c23          	sd	ra,536(sp)
    80005048:	20813823          	sd	s0,528(sp)
    8000504c:	20913423          	sd	s1,520(sp)
    80005050:	21213023          	sd	s2,512(sp)
    80005054:	1400                	addi	s0,sp,544
    80005056:	892a                	mv	s2,a0
    80005058:	dea43823          	sd	a0,-528(s0)
    8000505c:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80005060:	ffffd097          	auipc	ra,0xffffd
    80005064:	ae0080e7          	jalr	-1312(ra) # 80001b40 <myproc>
    80005068:	84aa                	mv	s1,a0

  begin_op();
    8000506a:	fffff097          	auipc	ra,0xfffff
    8000506e:	3fc080e7          	jalr	1020(ra) # 80004466 <begin_op>

  if((ip = namei(path)) == 0){
    80005072:	854a                	mv	a0,s2
    80005074:	fffff097          	auipc	ra,0xfffff
    80005078:	1ec080e7          	jalr	492(ra) # 80004260 <namei>
    8000507c:	c525                	beqz	a0,800050e4 <exec+0xa4>
    8000507e:	fbd2                	sd	s4,496(sp)
    80005080:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80005082:	fffff097          	auipc	ra,0xfffff
    80005086:	9fa080e7          	jalr	-1542(ra) # 80003a7c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000508a:	04000713          	li	a4,64
    8000508e:	4681                	li	a3,0
    80005090:	e5040613          	addi	a2,s0,-432
    80005094:	4581                	li	a1,0
    80005096:	8552                	mv	a0,s4
    80005098:	fffff097          	auipc	ra,0xfffff
    8000509c:	ca0080e7          	jalr	-864(ra) # 80003d38 <readi>
    800050a0:	04000793          	li	a5,64
    800050a4:	00f51a63          	bne	a0,a5,800050b8 <exec+0x78>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800050a8:	e5042703          	lw	a4,-432(s0)
    800050ac:	464c47b7          	lui	a5,0x464c4
    800050b0:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800050b4:	02f70e63          	beq	a4,a5,800050f0 <exec+0xb0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800050b8:	8552                	mv	a0,s4
    800050ba:	fffff097          	auipc	ra,0xfffff
    800050be:	c28080e7          	jalr	-984(ra) # 80003ce2 <iunlockput>
    end_op();
    800050c2:	fffff097          	auipc	ra,0xfffff
    800050c6:	41e080e7          	jalr	1054(ra) # 800044e0 <end_op>
  }
  return -1;
    800050ca:	557d                	li	a0,-1
    800050cc:	7a5e                	ld	s4,496(sp)
}
    800050ce:	21813083          	ld	ra,536(sp)
    800050d2:	21013403          	ld	s0,528(sp)
    800050d6:	20813483          	ld	s1,520(sp)
    800050da:	20013903          	ld	s2,512(sp)
    800050de:	22010113          	addi	sp,sp,544
    800050e2:	8082                	ret
    end_op();
    800050e4:	fffff097          	auipc	ra,0xfffff
    800050e8:	3fc080e7          	jalr	1020(ra) # 800044e0 <end_op>
    return -1;
    800050ec:	557d                	li	a0,-1
    800050ee:	b7c5                	j	800050ce <exec+0x8e>
    800050f0:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    800050f2:	8526                	mv	a0,s1
    800050f4:	ffffd097          	auipc	ra,0xffffd
    800050f8:	b10080e7          	jalr	-1264(ra) # 80001c04 <proc_pagetable>
    800050fc:	8b2a                	mv	s6,a0
    800050fe:	2c050163          	beqz	a0,800053c0 <exec+0x380>
    80005102:	ffce                	sd	s3,504(sp)
    80005104:	f7d6                	sd	s5,488(sp)
    80005106:	efde                	sd	s7,472(sp)
    80005108:	ebe2                	sd	s8,464(sp)
    8000510a:	e7e6                	sd	s9,456(sp)
    8000510c:	e3ea                	sd	s10,448(sp)
    8000510e:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005110:	e7042683          	lw	a3,-400(s0)
    80005114:	e8845783          	lhu	a5,-376(s0)
    80005118:	10078363          	beqz	a5,8000521e <exec+0x1de>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000511c:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000511e:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005120:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80005124:	6c85                	lui	s9,0x1
    80005126:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000512a:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    8000512e:	6a85                	lui	s5,0x1
    80005130:	a0b5                	j	8000519c <exec+0x15c>
      panic("loadseg: address should exist");
    80005132:	00003517          	auipc	a0,0x3
    80005136:	56e50513          	addi	a0,a0,1390 # 800086a0 <etext+0x6a0>
    8000513a:	ffffb097          	auipc	ra,0xffffb
    8000513e:	426080e7          	jalr	1062(ra) # 80000560 <panic>
    if(sz - i < PGSIZE)
    80005142:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80005144:	874a                	mv	a4,s2
    80005146:	009c06bb          	addw	a3,s8,s1
    8000514a:	4581                	li	a1,0
    8000514c:	8552                	mv	a0,s4
    8000514e:	fffff097          	auipc	ra,0xfffff
    80005152:	bea080e7          	jalr	-1046(ra) # 80003d38 <readi>
    80005156:	26a91963          	bne	s2,a0,800053c8 <exec+0x388>
  for(i = 0; i < sz; i += PGSIZE){
    8000515a:	009a84bb          	addw	s1,s5,s1
    8000515e:	0334f463          	bgeu	s1,s3,80005186 <exec+0x146>
    pa = walkaddr(pagetable, va + i);
    80005162:	02049593          	slli	a1,s1,0x20
    80005166:	9181                	srli	a1,a1,0x20
    80005168:	95de                	add	a1,a1,s7
    8000516a:	855a                	mv	a0,s6
    8000516c:	ffffc097          	auipc	ra,0xffffc
    80005170:	f6c080e7          	jalr	-148(ra) # 800010d8 <walkaddr>
    80005174:	862a                	mv	a2,a0
    if(pa == 0)
    80005176:	dd55                	beqz	a0,80005132 <exec+0xf2>
    if(sz - i < PGSIZE)
    80005178:	409987bb          	subw	a5,s3,s1
    8000517c:	893e                	mv	s2,a5
    8000517e:	fcfcf2e3          	bgeu	s9,a5,80005142 <exec+0x102>
    80005182:	8956                	mv	s2,s5
    80005184:	bf7d                	j	80005142 <exec+0x102>
    sz = sz1;
    80005186:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000518a:	2d05                	addiw	s10,s10,1
    8000518c:	e0843783          	ld	a5,-504(s0)
    80005190:	0387869b          	addiw	a3,a5,56
    80005194:	e8845783          	lhu	a5,-376(s0)
    80005198:	08fd5463          	bge	s10,a5,80005220 <exec+0x1e0>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000519c:	e0d43423          	sd	a3,-504(s0)
    800051a0:	876e                	mv	a4,s11
    800051a2:	e1840613          	addi	a2,s0,-488
    800051a6:	4581                	li	a1,0
    800051a8:	8552                	mv	a0,s4
    800051aa:	fffff097          	auipc	ra,0xfffff
    800051ae:	b8e080e7          	jalr	-1138(ra) # 80003d38 <readi>
    800051b2:	21b51963          	bne	a0,s11,800053c4 <exec+0x384>
    if(ph.type != ELF_PROG_LOAD)
    800051b6:	e1842783          	lw	a5,-488(s0)
    800051ba:	4705                	li	a4,1
    800051bc:	fce797e3          	bne	a5,a4,8000518a <exec+0x14a>
    if(ph.memsz < ph.filesz)
    800051c0:	e4043483          	ld	s1,-448(s0)
    800051c4:	e3843783          	ld	a5,-456(s0)
    800051c8:	22f4e063          	bltu	s1,a5,800053e8 <exec+0x3a8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800051cc:	e2843783          	ld	a5,-472(s0)
    800051d0:	94be                	add	s1,s1,a5
    800051d2:	20f4ee63          	bltu	s1,a5,800053ee <exec+0x3ae>
    if(ph.vaddr % PGSIZE != 0)
    800051d6:	de843703          	ld	a4,-536(s0)
    800051da:	8ff9                	and	a5,a5,a4
    800051dc:	20079c63          	bnez	a5,800053f4 <exec+0x3b4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800051e0:	e1c42503          	lw	a0,-484(s0)
    800051e4:	00000097          	auipc	ra,0x0
    800051e8:	e3c080e7          	jalr	-452(ra) # 80005020 <flags2perm>
    800051ec:	86aa                	mv	a3,a0
    800051ee:	8626                	mv	a2,s1
    800051f0:	85ca                	mv	a1,s2
    800051f2:	855a                	mv	a0,s6
    800051f4:	ffffc097          	auipc	ra,0xffffc
    800051f8:	2a8080e7          	jalr	680(ra) # 8000149c <uvmalloc>
    800051fc:	dea43c23          	sd	a0,-520(s0)
    80005200:	1e050d63          	beqz	a0,800053fa <exec+0x3ba>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005204:	e2843b83          	ld	s7,-472(s0)
    80005208:	e2042c03          	lw	s8,-480(s0)
    8000520c:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005210:	00098463          	beqz	s3,80005218 <exec+0x1d8>
    80005214:	4481                	li	s1,0
    80005216:	b7b1                	j	80005162 <exec+0x122>
    sz = sz1;
    80005218:	df843903          	ld	s2,-520(s0)
    8000521c:	b7bd                	j	8000518a <exec+0x14a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000521e:	4901                	li	s2,0
  iunlockput(ip);
    80005220:	8552                	mv	a0,s4
    80005222:	fffff097          	auipc	ra,0xfffff
    80005226:	ac0080e7          	jalr	-1344(ra) # 80003ce2 <iunlockput>
  end_op();
    8000522a:	fffff097          	auipc	ra,0xfffff
    8000522e:	2b6080e7          	jalr	694(ra) # 800044e0 <end_op>
  p = myproc();
    80005232:	ffffd097          	auipc	ra,0xffffd
    80005236:	90e080e7          	jalr	-1778(ra) # 80001b40 <myproc>
    8000523a:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000523c:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80005240:	6985                	lui	s3,0x1
    80005242:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80005244:	99ca                	add	s3,s3,s2
    80005246:	77fd                	lui	a5,0xfffff
    80005248:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000524c:	4691                	li	a3,4
    8000524e:	6609                	lui	a2,0x2
    80005250:	964e                	add	a2,a2,s3
    80005252:	85ce                	mv	a1,s3
    80005254:	855a                	mv	a0,s6
    80005256:	ffffc097          	auipc	ra,0xffffc
    8000525a:	246080e7          	jalr	582(ra) # 8000149c <uvmalloc>
    8000525e:	8a2a                	mv	s4,a0
    80005260:	e115                	bnez	a0,80005284 <exec+0x244>
    proc_freepagetable(pagetable, sz);
    80005262:	85ce                	mv	a1,s3
    80005264:	855a                	mv	a0,s6
    80005266:	ffffd097          	auipc	ra,0xffffd
    8000526a:	a3a080e7          	jalr	-1478(ra) # 80001ca0 <proc_freepagetable>
  return -1;
    8000526e:	557d                	li	a0,-1
    80005270:	79fe                	ld	s3,504(sp)
    80005272:	7a5e                	ld	s4,496(sp)
    80005274:	7abe                	ld	s5,488(sp)
    80005276:	7b1e                	ld	s6,480(sp)
    80005278:	6bfe                	ld	s7,472(sp)
    8000527a:	6c5e                	ld	s8,464(sp)
    8000527c:	6cbe                	ld	s9,456(sp)
    8000527e:	6d1e                	ld	s10,448(sp)
    80005280:	7dfa                	ld	s11,440(sp)
    80005282:	b5b1                	j	800050ce <exec+0x8e>
  uvmclear(pagetable, sz-2*PGSIZE);
    80005284:	75f9                	lui	a1,0xffffe
    80005286:	95aa                	add	a1,a1,a0
    80005288:	855a                	mv	a0,s6
    8000528a:	ffffc097          	auipc	ra,0xffffc
    8000528e:	454080e7          	jalr	1108(ra) # 800016de <uvmclear>
  stackbase = sp - PGSIZE;
    80005292:	7bfd                	lui	s7,0xfffff
    80005294:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    80005296:	e0043783          	ld	a5,-512(s0)
    8000529a:	6388                	ld	a0,0(a5)
  sp = sz;
    8000529c:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    8000529e:	4481                	li	s1,0
    ustack[argc] = sp;
    800052a0:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    800052a4:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    800052a8:	c135                	beqz	a0,8000530c <exec+0x2cc>
    sp -= strlen(argv[argc]) + 1;
    800052aa:	ffffc097          	auipc	ra,0xffffc
    800052ae:	c18080e7          	jalr	-1000(ra) # 80000ec2 <strlen>
    800052b2:	0015079b          	addiw	a5,a0,1
    800052b6:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800052ba:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800052be:	15796163          	bltu	s2,s7,80005400 <exec+0x3c0>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800052c2:	e0043d83          	ld	s11,-512(s0)
    800052c6:	000db983          	ld	s3,0(s11)
    800052ca:	854e                	mv	a0,s3
    800052cc:	ffffc097          	auipc	ra,0xffffc
    800052d0:	bf6080e7          	jalr	-1034(ra) # 80000ec2 <strlen>
    800052d4:	0015069b          	addiw	a3,a0,1
    800052d8:	864e                	mv	a2,s3
    800052da:	85ca                	mv	a1,s2
    800052dc:	855a                	mv	a0,s6
    800052de:	ffffc097          	auipc	ra,0xffffc
    800052e2:	432080e7          	jalr	1074(ra) # 80001710 <copyout>
    800052e6:	10054f63          	bltz	a0,80005404 <exec+0x3c4>
    ustack[argc] = sp;
    800052ea:	00349793          	slli	a5,s1,0x3
    800052ee:	97e6                	add	a5,a5,s9
    800052f0:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffdd190>
  for(argc = 0; argv[argc]; argc++) {
    800052f4:	0485                	addi	s1,s1,1
    800052f6:	008d8793          	addi	a5,s11,8
    800052fa:	e0f43023          	sd	a5,-512(s0)
    800052fe:	008db503          	ld	a0,8(s11)
    80005302:	c509                	beqz	a0,8000530c <exec+0x2cc>
    if(argc >= MAXARG)
    80005304:	fb8493e3          	bne	s1,s8,800052aa <exec+0x26a>
  sz = sz1;
    80005308:	89d2                	mv	s3,s4
    8000530a:	bfa1                	j	80005262 <exec+0x222>
  ustack[argc] = 0;
    8000530c:	00349793          	slli	a5,s1,0x3
    80005310:	f9078793          	addi	a5,a5,-112
    80005314:	97a2                	add	a5,a5,s0
    80005316:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000531a:	00148693          	addi	a3,s1,1
    8000531e:	068e                	slli	a3,a3,0x3
    80005320:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005324:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80005328:	89d2                	mv	s3,s4
  if(sp < stackbase)
    8000532a:	f3796ce3          	bltu	s2,s7,80005262 <exec+0x222>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000532e:	e9040613          	addi	a2,s0,-368
    80005332:	85ca                	mv	a1,s2
    80005334:	855a                	mv	a0,s6
    80005336:	ffffc097          	auipc	ra,0xffffc
    8000533a:	3da080e7          	jalr	986(ra) # 80001710 <copyout>
    8000533e:	f20542e3          	bltz	a0,80005262 <exec+0x222>
  p->trapframe->a1 = sp;
    80005342:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80005346:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000534a:	df043783          	ld	a5,-528(s0)
    8000534e:	0007c703          	lbu	a4,0(a5)
    80005352:	cf11                	beqz	a4,8000536e <exec+0x32e>
    80005354:	0785                	addi	a5,a5,1
    if(*s == '/')
    80005356:	02f00693          	li	a3,47
    8000535a:	a029                	j	80005364 <exec+0x324>
  for(last=s=path; *s; s++)
    8000535c:	0785                	addi	a5,a5,1
    8000535e:	fff7c703          	lbu	a4,-1(a5)
    80005362:	c711                	beqz	a4,8000536e <exec+0x32e>
    if(*s == '/')
    80005364:	fed71ce3          	bne	a4,a3,8000535c <exec+0x31c>
      last = s+1;
    80005368:	def43823          	sd	a5,-528(s0)
    8000536c:	bfc5                	j	8000535c <exec+0x31c>
  safestrcpy(p->name, last, sizeof(p->name));
    8000536e:	4641                	li	a2,16
    80005370:	df043583          	ld	a1,-528(s0)
    80005374:	158a8513          	addi	a0,s5,344
    80005378:	ffffc097          	auipc	ra,0xffffc
    8000537c:	b14080e7          	jalr	-1260(ra) # 80000e8c <safestrcpy>
  oldpagetable = p->pagetable;
    80005380:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80005384:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80005388:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000538c:	058ab783          	ld	a5,88(s5)
    80005390:	e6843703          	ld	a4,-408(s0)
    80005394:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80005396:	058ab783          	ld	a5,88(s5)
    8000539a:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000539e:	85ea                	mv	a1,s10
    800053a0:	ffffd097          	auipc	ra,0xffffd
    800053a4:	900080e7          	jalr	-1792(ra) # 80001ca0 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800053a8:	0004851b          	sext.w	a0,s1
    800053ac:	79fe                	ld	s3,504(sp)
    800053ae:	7a5e                	ld	s4,496(sp)
    800053b0:	7abe                	ld	s5,488(sp)
    800053b2:	7b1e                	ld	s6,480(sp)
    800053b4:	6bfe                	ld	s7,472(sp)
    800053b6:	6c5e                	ld	s8,464(sp)
    800053b8:	6cbe                	ld	s9,456(sp)
    800053ba:	6d1e                	ld	s10,448(sp)
    800053bc:	7dfa                	ld	s11,440(sp)
    800053be:	bb01                	j	800050ce <exec+0x8e>
    800053c0:	7b1e                	ld	s6,480(sp)
    800053c2:	b9dd                	j	800050b8 <exec+0x78>
    800053c4:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    800053c8:	df843583          	ld	a1,-520(s0)
    800053cc:	855a                	mv	a0,s6
    800053ce:	ffffd097          	auipc	ra,0xffffd
    800053d2:	8d2080e7          	jalr	-1838(ra) # 80001ca0 <proc_freepagetable>
  if(ip){
    800053d6:	79fe                	ld	s3,504(sp)
    800053d8:	7abe                	ld	s5,488(sp)
    800053da:	7b1e                	ld	s6,480(sp)
    800053dc:	6bfe                	ld	s7,472(sp)
    800053de:	6c5e                	ld	s8,464(sp)
    800053e0:	6cbe                	ld	s9,456(sp)
    800053e2:	6d1e                	ld	s10,448(sp)
    800053e4:	7dfa                	ld	s11,440(sp)
    800053e6:	b9c9                	j	800050b8 <exec+0x78>
    800053e8:	df243c23          	sd	s2,-520(s0)
    800053ec:	bff1                	j	800053c8 <exec+0x388>
    800053ee:	df243c23          	sd	s2,-520(s0)
    800053f2:	bfd9                	j	800053c8 <exec+0x388>
    800053f4:	df243c23          	sd	s2,-520(s0)
    800053f8:	bfc1                	j	800053c8 <exec+0x388>
    800053fa:	df243c23          	sd	s2,-520(s0)
    800053fe:	b7e9                	j	800053c8 <exec+0x388>
  sz = sz1;
    80005400:	89d2                	mv	s3,s4
    80005402:	b585                	j	80005262 <exec+0x222>
    80005404:	89d2                	mv	s3,s4
    80005406:	bdb1                	j	80005262 <exec+0x222>

0000000080005408 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005408:	7179                	addi	sp,sp,-48
    8000540a:	f406                	sd	ra,40(sp)
    8000540c:	f022                	sd	s0,32(sp)
    8000540e:	ec26                	sd	s1,24(sp)
    80005410:	e84a                	sd	s2,16(sp)
    80005412:	1800                	addi	s0,sp,48
    80005414:	892e                	mv	s2,a1
    80005416:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005418:	fdc40593          	addi	a1,s0,-36
    8000541c:	ffffe097          	auipc	ra,0xffffe
    80005420:	a58080e7          	jalr	-1448(ra) # 80002e74 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005424:	fdc42703          	lw	a4,-36(s0)
    80005428:	47bd                	li	a5,15
    8000542a:	02e7eb63          	bltu	a5,a4,80005460 <argfd+0x58>
    8000542e:	ffffc097          	auipc	ra,0xffffc
    80005432:	712080e7          	jalr	1810(ra) # 80001b40 <myproc>
    80005436:	fdc42703          	lw	a4,-36(s0)
    8000543a:	01a70793          	addi	a5,a4,26
    8000543e:	078e                	slli	a5,a5,0x3
    80005440:	953e                	add	a0,a0,a5
    80005442:	611c                	ld	a5,0(a0)
    80005444:	c385                	beqz	a5,80005464 <argfd+0x5c>
    return -1;
  if(pfd)
    80005446:	00090463          	beqz	s2,8000544e <argfd+0x46>
    *pfd = fd;
    8000544a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000544e:	4501                	li	a0,0
  if(pf)
    80005450:	c091                	beqz	s1,80005454 <argfd+0x4c>
    *pf = f;
    80005452:	e09c                	sd	a5,0(s1)
}
    80005454:	70a2                	ld	ra,40(sp)
    80005456:	7402                	ld	s0,32(sp)
    80005458:	64e2                	ld	s1,24(sp)
    8000545a:	6942                	ld	s2,16(sp)
    8000545c:	6145                	addi	sp,sp,48
    8000545e:	8082                	ret
    return -1;
    80005460:	557d                	li	a0,-1
    80005462:	bfcd                	j	80005454 <argfd+0x4c>
    80005464:	557d                	li	a0,-1
    80005466:	b7fd                	j	80005454 <argfd+0x4c>

0000000080005468 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005468:	1101                	addi	sp,sp,-32
    8000546a:	ec06                	sd	ra,24(sp)
    8000546c:	e822                	sd	s0,16(sp)
    8000546e:	e426                	sd	s1,8(sp)
    80005470:	1000                	addi	s0,sp,32
    80005472:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005474:	ffffc097          	auipc	ra,0xffffc
    80005478:	6cc080e7          	jalr	1740(ra) # 80001b40 <myproc>
    8000547c:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000547e:	0d050793          	addi	a5,a0,208
    80005482:	4501                	li	a0,0
    80005484:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005486:	6398                	ld	a4,0(a5)
    80005488:	cb19                	beqz	a4,8000549e <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000548a:	2505                	addiw	a0,a0,1
    8000548c:	07a1                	addi	a5,a5,8
    8000548e:	fed51ce3          	bne	a0,a3,80005486 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005492:	557d                	li	a0,-1
}
    80005494:	60e2                	ld	ra,24(sp)
    80005496:	6442                	ld	s0,16(sp)
    80005498:	64a2                	ld	s1,8(sp)
    8000549a:	6105                	addi	sp,sp,32
    8000549c:	8082                	ret
      p->ofile[fd] = f;
    8000549e:	01a50793          	addi	a5,a0,26
    800054a2:	078e                	slli	a5,a5,0x3
    800054a4:	963e                	add	a2,a2,a5
    800054a6:	e204                	sd	s1,0(a2)
      return fd;
    800054a8:	b7f5                	j	80005494 <fdalloc+0x2c>

00000000800054aa <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800054aa:	715d                	addi	sp,sp,-80
    800054ac:	e486                	sd	ra,72(sp)
    800054ae:	e0a2                	sd	s0,64(sp)
    800054b0:	fc26                	sd	s1,56(sp)
    800054b2:	f84a                	sd	s2,48(sp)
    800054b4:	f44e                	sd	s3,40(sp)
    800054b6:	ec56                	sd	s5,24(sp)
    800054b8:	e85a                	sd	s6,16(sp)
    800054ba:	0880                	addi	s0,sp,80
    800054bc:	8b2e                	mv	s6,a1
    800054be:	89b2                	mv	s3,a2
    800054c0:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800054c2:	fb040593          	addi	a1,s0,-80
    800054c6:	fffff097          	auipc	ra,0xfffff
    800054ca:	db8080e7          	jalr	-584(ra) # 8000427e <nameiparent>
    800054ce:	84aa                	mv	s1,a0
    800054d0:	14050e63          	beqz	a0,8000562c <create+0x182>
    return 0;

  ilock(dp);
    800054d4:	ffffe097          	auipc	ra,0xffffe
    800054d8:	5a8080e7          	jalr	1448(ra) # 80003a7c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800054dc:	4601                	li	a2,0
    800054de:	fb040593          	addi	a1,s0,-80
    800054e2:	8526                	mv	a0,s1
    800054e4:	fffff097          	auipc	ra,0xfffff
    800054e8:	a94080e7          	jalr	-1388(ra) # 80003f78 <dirlookup>
    800054ec:	8aaa                	mv	s5,a0
    800054ee:	c539                	beqz	a0,8000553c <create+0x92>
    iunlockput(dp);
    800054f0:	8526                	mv	a0,s1
    800054f2:	ffffe097          	auipc	ra,0xffffe
    800054f6:	7f0080e7          	jalr	2032(ra) # 80003ce2 <iunlockput>
    ilock(ip);
    800054fa:	8556                	mv	a0,s5
    800054fc:	ffffe097          	auipc	ra,0xffffe
    80005500:	580080e7          	jalr	1408(ra) # 80003a7c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005504:	4789                	li	a5,2
    80005506:	02fb1463          	bne	s6,a5,8000552e <create+0x84>
    8000550a:	044ad783          	lhu	a5,68(s5)
    8000550e:	37f9                	addiw	a5,a5,-2
    80005510:	17c2                	slli	a5,a5,0x30
    80005512:	93c1                	srli	a5,a5,0x30
    80005514:	4705                	li	a4,1
    80005516:	00f76c63          	bltu	a4,a5,8000552e <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000551a:	8556                	mv	a0,s5
    8000551c:	60a6                	ld	ra,72(sp)
    8000551e:	6406                	ld	s0,64(sp)
    80005520:	74e2                	ld	s1,56(sp)
    80005522:	7942                	ld	s2,48(sp)
    80005524:	79a2                	ld	s3,40(sp)
    80005526:	6ae2                	ld	s5,24(sp)
    80005528:	6b42                	ld	s6,16(sp)
    8000552a:	6161                	addi	sp,sp,80
    8000552c:	8082                	ret
    iunlockput(ip);
    8000552e:	8556                	mv	a0,s5
    80005530:	ffffe097          	auipc	ra,0xffffe
    80005534:	7b2080e7          	jalr	1970(ra) # 80003ce2 <iunlockput>
    return 0;
    80005538:	4a81                	li	s5,0
    8000553a:	b7c5                	j	8000551a <create+0x70>
    8000553c:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    8000553e:	85da                	mv	a1,s6
    80005540:	4088                	lw	a0,0(s1)
    80005542:	ffffe097          	auipc	ra,0xffffe
    80005546:	396080e7          	jalr	918(ra) # 800038d8 <ialloc>
    8000554a:	8a2a                	mv	s4,a0
    8000554c:	c531                	beqz	a0,80005598 <create+0xee>
  ilock(ip);
    8000554e:	ffffe097          	auipc	ra,0xffffe
    80005552:	52e080e7          	jalr	1326(ra) # 80003a7c <ilock>
  ip->major = major;
    80005556:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000555a:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000555e:	4905                	li	s2,1
    80005560:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80005564:	8552                	mv	a0,s4
    80005566:	ffffe097          	auipc	ra,0xffffe
    8000556a:	44a080e7          	jalr	1098(ra) # 800039b0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000556e:	032b0d63          	beq	s6,s2,800055a8 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80005572:	004a2603          	lw	a2,4(s4)
    80005576:	fb040593          	addi	a1,s0,-80
    8000557a:	8526                	mv	a0,s1
    8000557c:	fffff097          	auipc	ra,0xfffff
    80005580:	c22080e7          	jalr	-990(ra) # 8000419e <dirlink>
    80005584:	08054163          	bltz	a0,80005606 <create+0x15c>
  iunlockput(dp);
    80005588:	8526                	mv	a0,s1
    8000558a:	ffffe097          	auipc	ra,0xffffe
    8000558e:	758080e7          	jalr	1880(ra) # 80003ce2 <iunlockput>
  return ip;
    80005592:	8ad2                	mv	s5,s4
    80005594:	7a02                	ld	s4,32(sp)
    80005596:	b751                	j	8000551a <create+0x70>
    iunlockput(dp);
    80005598:	8526                	mv	a0,s1
    8000559a:	ffffe097          	auipc	ra,0xffffe
    8000559e:	748080e7          	jalr	1864(ra) # 80003ce2 <iunlockput>
    return 0;
    800055a2:	8ad2                	mv	s5,s4
    800055a4:	7a02                	ld	s4,32(sp)
    800055a6:	bf95                	j	8000551a <create+0x70>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800055a8:	004a2603          	lw	a2,4(s4)
    800055ac:	00003597          	auipc	a1,0x3
    800055b0:	11458593          	addi	a1,a1,276 # 800086c0 <etext+0x6c0>
    800055b4:	8552                	mv	a0,s4
    800055b6:	fffff097          	auipc	ra,0xfffff
    800055ba:	be8080e7          	jalr	-1048(ra) # 8000419e <dirlink>
    800055be:	04054463          	bltz	a0,80005606 <create+0x15c>
    800055c2:	40d0                	lw	a2,4(s1)
    800055c4:	00003597          	auipc	a1,0x3
    800055c8:	10458593          	addi	a1,a1,260 # 800086c8 <etext+0x6c8>
    800055cc:	8552                	mv	a0,s4
    800055ce:	fffff097          	auipc	ra,0xfffff
    800055d2:	bd0080e7          	jalr	-1072(ra) # 8000419e <dirlink>
    800055d6:	02054863          	bltz	a0,80005606 <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    800055da:	004a2603          	lw	a2,4(s4)
    800055de:	fb040593          	addi	a1,s0,-80
    800055e2:	8526                	mv	a0,s1
    800055e4:	fffff097          	auipc	ra,0xfffff
    800055e8:	bba080e7          	jalr	-1094(ra) # 8000419e <dirlink>
    800055ec:	00054d63          	bltz	a0,80005606 <create+0x15c>
    dp->nlink++;  // for ".."
    800055f0:	04a4d783          	lhu	a5,74(s1)
    800055f4:	2785                	addiw	a5,a5,1
    800055f6:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800055fa:	8526                	mv	a0,s1
    800055fc:	ffffe097          	auipc	ra,0xffffe
    80005600:	3b4080e7          	jalr	948(ra) # 800039b0 <iupdate>
    80005604:	b751                	j	80005588 <create+0xde>
  ip->nlink = 0;
    80005606:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000560a:	8552                	mv	a0,s4
    8000560c:	ffffe097          	auipc	ra,0xffffe
    80005610:	3a4080e7          	jalr	932(ra) # 800039b0 <iupdate>
  iunlockput(ip);
    80005614:	8552                	mv	a0,s4
    80005616:	ffffe097          	auipc	ra,0xffffe
    8000561a:	6cc080e7          	jalr	1740(ra) # 80003ce2 <iunlockput>
  iunlockput(dp);
    8000561e:	8526                	mv	a0,s1
    80005620:	ffffe097          	auipc	ra,0xffffe
    80005624:	6c2080e7          	jalr	1730(ra) # 80003ce2 <iunlockput>
  return 0;
    80005628:	7a02                	ld	s4,32(sp)
    8000562a:	bdc5                	j	8000551a <create+0x70>
    return 0;
    8000562c:	8aaa                	mv	s5,a0
    8000562e:	b5f5                	j	8000551a <create+0x70>

0000000080005630 <sys_dup>:
{
    80005630:	7179                	addi	sp,sp,-48
    80005632:	f406                	sd	ra,40(sp)
    80005634:	f022                	sd	s0,32(sp)
    80005636:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005638:	fd840613          	addi	a2,s0,-40
    8000563c:	4581                	li	a1,0
    8000563e:	4501                	li	a0,0
    80005640:	00000097          	auipc	ra,0x0
    80005644:	dc8080e7          	jalr	-568(ra) # 80005408 <argfd>
    return -1;
    80005648:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000564a:	02054763          	bltz	a0,80005678 <sys_dup+0x48>
    8000564e:	ec26                	sd	s1,24(sp)
    80005650:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80005652:	fd843903          	ld	s2,-40(s0)
    80005656:	854a                	mv	a0,s2
    80005658:	00000097          	auipc	ra,0x0
    8000565c:	e10080e7          	jalr	-496(ra) # 80005468 <fdalloc>
    80005660:	84aa                	mv	s1,a0
    return -1;
    80005662:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005664:	00054f63          	bltz	a0,80005682 <sys_dup+0x52>
  filedup(f);
    80005668:	854a                	mv	a0,s2
    8000566a:	fffff097          	auipc	ra,0xfffff
    8000566e:	27a080e7          	jalr	634(ra) # 800048e4 <filedup>
  return fd;
    80005672:	87a6                	mv	a5,s1
    80005674:	64e2                	ld	s1,24(sp)
    80005676:	6942                	ld	s2,16(sp)
}
    80005678:	853e                	mv	a0,a5
    8000567a:	70a2                	ld	ra,40(sp)
    8000567c:	7402                	ld	s0,32(sp)
    8000567e:	6145                	addi	sp,sp,48
    80005680:	8082                	ret
    80005682:	64e2                	ld	s1,24(sp)
    80005684:	6942                	ld	s2,16(sp)
    80005686:	bfcd                	j	80005678 <sys_dup+0x48>

0000000080005688 <sys_read>:
{
    80005688:	7179                	addi	sp,sp,-48
    8000568a:	f406                	sd	ra,40(sp)
    8000568c:	f022                	sd	s0,32(sp)
    8000568e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005690:	fd840593          	addi	a1,s0,-40
    80005694:	4505                	li	a0,1
    80005696:	ffffd097          	auipc	ra,0xffffd
    8000569a:	7fe080e7          	jalr	2046(ra) # 80002e94 <argaddr>
  argint(2, &n);
    8000569e:	fe440593          	addi	a1,s0,-28
    800056a2:	4509                	li	a0,2
    800056a4:	ffffd097          	auipc	ra,0xffffd
    800056a8:	7d0080e7          	jalr	2000(ra) # 80002e74 <argint>
  if(argfd(0, 0, &f) < 0)
    800056ac:	fe840613          	addi	a2,s0,-24
    800056b0:	4581                	li	a1,0
    800056b2:	4501                	li	a0,0
    800056b4:	00000097          	auipc	ra,0x0
    800056b8:	d54080e7          	jalr	-684(ra) # 80005408 <argfd>
    800056bc:	87aa                	mv	a5,a0
    return -1;
    800056be:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800056c0:	0007cc63          	bltz	a5,800056d8 <sys_read+0x50>
  return fileread(f, p, n);
    800056c4:	fe442603          	lw	a2,-28(s0)
    800056c8:	fd843583          	ld	a1,-40(s0)
    800056cc:	fe843503          	ld	a0,-24(s0)
    800056d0:	fffff097          	auipc	ra,0xfffff
    800056d4:	3ba080e7          	jalr	954(ra) # 80004a8a <fileread>
}
    800056d8:	70a2                	ld	ra,40(sp)
    800056da:	7402                	ld	s0,32(sp)
    800056dc:	6145                	addi	sp,sp,48
    800056de:	8082                	ret

00000000800056e0 <sys_write>:
{
    800056e0:	7179                	addi	sp,sp,-48
    800056e2:	f406                	sd	ra,40(sp)
    800056e4:	f022                	sd	s0,32(sp)
    800056e6:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800056e8:	fd840593          	addi	a1,s0,-40
    800056ec:	4505                	li	a0,1
    800056ee:	ffffd097          	auipc	ra,0xffffd
    800056f2:	7a6080e7          	jalr	1958(ra) # 80002e94 <argaddr>
  argint(2, &n);
    800056f6:	fe440593          	addi	a1,s0,-28
    800056fa:	4509                	li	a0,2
    800056fc:	ffffd097          	auipc	ra,0xffffd
    80005700:	778080e7          	jalr	1912(ra) # 80002e74 <argint>
  if(argfd(0, 0, &f) < 0)
    80005704:	fe840613          	addi	a2,s0,-24
    80005708:	4581                	li	a1,0
    8000570a:	4501                	li	a0,0
    8000570c:	00000097          	auipc	ra,0x0
    80005710:	cfc080e7          	jalr	-772(ra) # 80005408 <argfd>
    80005714:	87aa                	mv	a5,a0
    return -1;
    80005716:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005718:	0007cc63          	bltz	a5,80005730 <sys_write+0x50>
  return filewrite(f, p, n);
    8000571c:	fe442603          	lw	a2,-28(s0)
    80005720:	fd843583          	ld	a1,-40(s0)
    80005724:	fe843503          	ld	a0,-24(s0)
    80005728:	fffff097          	auipc	ra,0xfffff
    8000572c:	434080e7          	jalr	1076(ra) # 80004b5c <filewrite>
}
    80005730:	70a2                	ld	ra,40(sp)
    80005732:	7402                	ld	s0,32(sp)
    80005734:	6145                	addi	sp,sp,48
    80005736:	8082                	ret

0000000080005738 <sys_close>:
{
    80005738:	1101                	addi	sp,sp,-32
    8000573a:	ec06                	sd	ra,24(sp)
    8000573c:	e822                	sd	s0,16(sp)
    8000573e:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005740:	fe040613          	addi	a2,s0,-32
    80005744:	fec40593          	addi	a1,s0,-20
    80005748:	4501                	li	a0,0
    8000574a:	00000097          	auipc	ra,0x0
    8000574e:	cbe080e7          	jalr	-834(ra) # 80005408 <argfd>
    return -1;
    80005752:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005754:	02054463          	bltz	a0,8000577c <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005758:	ffffc097          	auipc	ra,0xffffc
    8000575c:	3e8080e7          	jalr	1000(ra) # 80001b40 <myproc>
    80005760:	fec42783          	lw	a5,-20(s0)
    80005764:	07e9                	addi	a5,a5,26
    80005766:	078e                	slli	a5,a5,0x3
    80005768:	953e                	add	a0,a0,a5
    8000576a:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000576e:	fe043503          	ld	a0,-32(s0)
    80005772:	fffff097          	auipc	ra,0xfffff
    80005776:	1c4080e7          	jalr	452(ra) # 80004936 <fileclose>
  return 0;
    8000577a:	4781                	li	a5,0
}
    8000577c:	853e                	mv	a0,a5
    8000577e:	60e2                	ld	ra,24(sp)
    80005780:	6442                	ld	s0,16(sp)
    80005782:	6105                	addi	sp,sp,32
    80005784:	8082                	ret

0000000080005786 <sys_fstat>:
{
    80005786:	1101                	addi	sp,sp,-32
    80005788:	ec06                	sd	ra,24(sp)
    8000578a:	e822                	sd	s0,16(sp)
    8000578c:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000578e:	fe040593          	addi	a1,s0,-32
    80005792:	4505                	li	a0,1
    80005794:	ffffd097          	auipc	ra,0xffffd
    80005798:	700080e7          	jalr	1792(ra) # 80002e94 <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000579c:	fe840613          	addi	a2,s0,-24
    800057a0:	4581                	li	a1,0
    800057a2:	4501                	li	a0,0
    800057a4:	00000097          	auipc	ra,0x0
    800057a8:	c64080e7          	jalr	-924(ra) # 80005408 <argfd>
    800057ac:	87aa                	mv	a5,a0
    return -1;
    800057ae:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800057b0:	0007ca63          	bltz	a5,800057c4 <sys_fstat+0x3e>
  return filestat(f, st);
    800057b4:	fe043583          	ld	a1,-32(s0)
    800057b8:	fe843503          	ld	a0,-24(s0)
    800057bc:	fffff097          	auipc	ra,0xfffff
    800057c0:	258080e7          	jalr	600(ra) # 80004a14 <filestat>
}
    800057c4:	60e2                	ld	ra,24(sp)
    800057c6:	6442                	ld	s0,16(sp)
    800057c8:	6105                	addi	sp,sp,32
    800057ca:	8082                	ret

00000000800057cc <sys_link>:
{
    800057cc:	7169                	addi	sp,sp,-304
    800057ce:	f606                	sd	ra,296(sp)
    800057d0:	f222                	sd	s0,288(sp)
    800057d2:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800057d4:	08000613          	li	a2,128
    800057d8:	ed040593          	addi	a1,s0,-304
    800057dc:	4501                	li	a0,0
    800057de:	ffffd097          	auipc	ra,0xffffd
    800057e2:	6d6080e7          	jalr	1750(ra) # 80002eb4 <argstr>
    return -1;
    800057e6:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800057e8:	12054663          	bltz	a0,80005914 <sys_link+0x148>
    800057ec:	08000613          	li	a2,128
    800057f0:	f5040593          	addi	a1,s0,-176
    800057f4:	4505                	li	a0,1
    800057f6:	ffffd097          	auipc	ra,0xffffd
    800057fa:	6be080e7          	jalr	1726(ra) # 80002eb4 <argstr>
    return -1;
    800057fe:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005800:	10054a63          	bltz	a0,80005914 <sys_link+0x148>
    80005804:	ee26                	sd	s1,280(sp)
  begin_op();
    80005806:	fffff097          	auipc	ra,0xfffff
    8000580a:	c60080e7          	jalr	-928(ra) # 80004466 <begin_op>
  if((ip = namei(old)) == 0){
    8000580e:	ed040513          	addi	a0,s0,-304
    80005812:	fffff097          	auipc	ra,0xfffff
    80005816:	a4e080e7          	jalr	-1458(ra) # 80004260 <namei>
    8000581a:	84aa                	mv	s1,a0
    8000581c:	c949                	beqz	a0,800058ae <sys_link+0xe2>
  ilock(ip);
    8000581e:	ffffe097          	auipc	ra,0xffffe
    80005822:	25e080e7          	jalr	606(ra) # 80003a7c <ilock>
  if(ip->type == T_DIR){
    80005826:	04449703          	lh	a4,68(s1)
    8000582a:	4785                	li	a5,1
    8000582c:	08f70863          	beq	a4,a5,800058bc <sys_link+0xf0>
    80005830:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80005832:	04a4d783          	lhu	a5,74(s1)
    80005836:	2785                	addiw	a5,a5,1
    80005838:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000583c:	8526                	mv	a0,s1
    8000583e:	ffffe097          	auipc	ra,0xffffe
    80005842:	172080e7          	jalr	370(ra) # 800039b0 <iupdate>
  iunlock(ip);
    80005846:	8526                	mv	a0,s1
    80005848:	ffffe097          	auipc	ra,0xffffe
    8000584c:	2fa080e7          	jalr	762(ra) # 80003b42 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005850:	fd040593          	addi	a1,s0,-48
    80005854:	f5040513          	addi	a0,s0,-176
    80005858:	fffff097          	auipc	ra,0xfffff
    8000585c:	a26080e7          	jalr	-1498(ra) # 8000427e <nameiparent>
    80005860:	892a                	mv	s2,a0
    80005862:	cd35                	beqz	a0,800058de <sys_link+0x112>
  ilock(dp);
    80005864:	ffffe097          	auipc	ra,0xffffe
    80005868:	218080e7          	jalr	536(ra) # 80003a7c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000586c:	00092703          	lw	a4,0(s2)
    80005870:	409c                	lw	a5,0(s1)
    80005872:	06f71163          	bne	a4,a5,800058d4 <sys_link+0x108>
    80005876:	40d0                	lw	a2,4(s1)
    80005878:	fd040593          	addi	a1,s0,-48
    8000587c:	854a                	mv	a0,s2
    8000587e:	fffff097          	auipc	ra,0xfffff
    80005882:	920080e7          	jalr	-1760(ra) # 8000419e <dirlink>
    80005886:	04054763          	bltz	a0,800058d4 <sys_link+0x108>
  iunlockput(dp);
    8000588a:	854a                	mv	a0,s2
    8000588c:	ffffe097          	auipc	ra,0xffffe
    80005890:	456080e7          	jalr	1110(ra) # 80003ce2 <iunlockput>
  iput(ip);
    80005894:	8526                	mv	a0,s1
    80005896:	ffffe097          	auipc	ra,0xffffe
    8000589a:	3a4080e7          	jalr	932(ra) # 80003c3a <iput>
  end_op();
    8000589e:	fffff097          	auipc	ra,0xfffff
    800058a2:	c42080e7          	jalr	-958(ra) # 800044e0 <end_op>
  return 0;
    800058a6:	4781                	li	a5,0
    800058a8:	64f2                	ld	s1,280(sp)
    800058aa:	6952                	ld	s2,272(sp)
    800058ac:	a0a5                	j	80005914 <sys_link+0x148>
    end_op();
    800058ae:	fffff097          	auipc	ra,0xfffff
    800058b2:	c32080e7          	jalr	-974(ra) # 800044e0 <end_op>
    return -1;
    800058b6:	57fd                	li	a5,-1
    800058b8:	64f2                	ld	s1,280(sp)
    800058ba:	a8a9                	j	80005914 <sys_link+0x148>
    iunlockput(ip);
    800058bc:	8526                	mv	a0,s1
    800058be:	ffffe097          	auipc	ra,0xffffe
    800058c2:	424080e7          	jalr	1060(ra) # 80003ce2 <iunlockput>
    end_op();
    800058c6:	fffff097          	auipc	ra,0xfffff
    800058ca:	c1a080e7          	jalr	-998(ra) # 800044e0 <end_op>
    return -1;
    800058ce:	57fd                	li	a5,-1
    800058d0:	64f2                	ld	s1,280(sp)
    800058d2:	a089                	j	80005914 <sys_link+0x148>
    iunlockput(dp);
    800058d4:	854a                	mv	a0,s2
    800058d6:	ffffe097          	auipc	ra,0xffffe
    800058da:	40c080e7          	jalr	1036(ra) # 80003ce2 <iunlockput>
  ilock(ip);
    800058de:	8526                	mv	a0,s1
    800058e0:	ffffe097          	auipc	ra,0xffffe
    800058e4:	19c080e7          	jalr	412(ra) # 80003a7c <ilock>
  ip->nlink--;
    800058e8:	04a4d783          	lhu	a5,74(s1)
    800058ec:	37fd                	addiw	a5,a5,-1
    800058ee:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800058f2:	8526                	mv	a0,s1
    800058f4:	ffffe097          	auipc	ra,0xffffe
    800058f8:	0bc080e7          	jalr	188(ra) # 800039b0 <iupdate>
  iunlockput(ip);
    800058fc:	8526                	mv	a0,s1
    800058fe:	ffffe097          	auipc	ra,0xffffe
    80005902:	3e4080e7          	jalr	996(ra) # 80003ce2 <iunlockput>
  end_op();
    80005906:	fffff097          	auipc	ra,0xfffff
    8000590a:	bda080e7          	jalr	-1062(ra) # 800044e0 <end_op>
  return -1;
    8000590e:	57fd                	li	a5,-1
    80005910:	64f2                	ld	s1,280(sp)
    80005912:	6952                	ld	s2,272(sp)
}
    80005914:	853e                	mv	a0,a5
    80005916:	70b2                	ld	ra,296(sp)
    80005918:	7412                	ld	s0,288(sp)
    8000591a:	6155                	addi	sp,sp,304
    8000591c:	8082                	ret

000000008000591e <sys_unlink>:
{
    8000591e:	7111                	addi	sp,sp,-256
    80005920:	fd86                	sd	ra,248(sp)
    80005922:	f9a2                	sd	s0,240(sp)
    80005924:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    80005926:	08000613          	li	a2,128
    8000592a:	f2040593          	addi	a1,s0,-224
    8000592e:	4501                	li	a0,0
    80005930:	ffffd097          	auipc	ra,0xffffd
    80005934:	584080e7          	jalr	1412(ra) # 80002eb4 <argstr>
    80005938:	1c054063          	bltz	a0,80005af8 <sys_unlink+0x1da>
    8000593c:	f5a6                	sd	s1,232(sp)
  begin_op();
    8000593e:	fffff097          	auipc	ra,0xfffff
    80005942:	b28080e7          	jalr	-1240(ra) # 80004466 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005946:	fa040593          	addi	a1,s0,-96
    8000594a:	f2040513          	addi	a0,s0,-224
    8000594e:	fffff097          	auipc	ra,0xfffff
    80005952:	930080e7          	jalr	-1744(ra) # 8000427e <nameiparent>
    80005956:	84aa                	mv	s1,a0
    80005958:	c165                	beqz	a0,80005a38 <sys_unlink+0x11a>
  ilock(dp);
    8000595a:	ffffe097          	auipc	ra,0xffffe
    8000595e:	122080e7          	jalr	290(ra) # 80003a7c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005962:	00003597          	auipc	a1,0x3
    80005966:	d5e58593          	addi	a1,a1,-674 # 800086c0 <etext+0x6c0>
    8000596a:	fa040513          	addi	a0,s0,-96
    8000596e:	ffffe097          	auipc	ra,0xffffe
    80005972:	5f0080e7          	jalr	1520(ra) # 80003f5e <namecmp>
    80005976:	16050263          	beqz	a0,80005ada <sys_unlink+0x1bc>
    8000597a:	00003597          	auipc	a1,0x3
    8000597e:	d4e58593          	addi	a1,a1,-690 # 800086c8 <etext+0x6c8>
    80005982:	fa040513          	addi	a0,s0,-96
    80005986:	ffffe097          	auipc	ra,0xffffe
    8000598a:	5d8080e7          	jalr	1496(ra) # 80003f5e <namecmp>
    8000598e:	14050663          	beqz	a0,80005ada <sys_unlink+0x1bc>
    80005992:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005994:	f1c40613          	addi	a2,s0,-228
    80005998:	fa040593          	addi	a1,s0,-96
    8000599c:	8526                	mv	a0,s1
    8000599e:	ffffe097          	auipc	ra,0xffffe
    800059a2:	5da080e7          	jalr	1498(ra) # 80003f78 <dirlookup>
    800059a6:	892a                	mv	s2,a0
    800059a8:	12050863          	beqz	a0,80005ad8 <sys_unlink+0x1ba>
    800059ac:	edce                	sd	s3,216(sp)
  ilock(ip);
    800059ae:	ffffe097          	auipc	ra,0xffffe
    800059b2:	0ce080e7          	jalr	206(ra) # 80003a7c <ilock>
  if(ip->nlink < 1)
    800059b6:	04a91783          	lh	a5,74(s2)
    800059ba:	08f05663          	blez	a5,80005a46 <sys_unlink+0x128>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800059be:	04491703          	lh	a4,68(s2)
    800059c2:	4785                	li	a5,1
    800059c4:	08f70b63          	beq	a4,a5,80005a5a <sys_unlink+0x13c>
  memset(&de, 0, sizeof(de));
    800059c8:	fb040993          	addi	s3,s0,-80
    800059cc:	4641                	li	a2,16
    800059ce:	4581                	li	a1,0
    800059d0:	854e                	mv	a0,s3
    800059d2:	ffffb097          	auipc	ra,0xffffb
    800059d6:	364080e7          	jalr	868(ra) # 80000d36 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800059da:	4741                	li	a4,16
    800059dc:	f1c42683          	lw	a3,-228(s0)
    800059e0:	864e                	mv	a2,s3
    800059e2:	4581                	li	a1,0
    800059e4:	8526                	mv	a0,s1
    800059e6:	ffffe097          	auipc	ra,0xffffe
    800059ea:	458080e7          	jalr	1112(ra) # 80003e3e <writei>
    800059ee:	47c1                	li	a5,16
    800059f0:	0af51f63          	bne	a0,a5,80005aae <sys_unlink+0x190>
  if(ip->type == T_DIR){
    800059f4:	04491703          	lh	a4,68(s2)
    800059f8:	4785                	li	a5,1
    800059fa:	0cf70463          	beq	a4,a5,80005ac2 <sys_unlink+0x1a4>
  iunlockput(dp);
    800059fe:	8526                	mv	a0,s1
    80005a00:	ffffe097          	auipc	ra,0xffffe
    80005a04:	2e2080e7          	jalr	738(ra) # 80003ce2 <iunlockput>
  ip->nlink--;
    80005a08:	04a95783          	lhu	a5,74(s2)
    80005a0c:	37fd                	addiw	a5,a5,-1
    80005a0e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005a12:	854a                	mv	a0,s2
    80005a14:	ffffe097          	auipc	ra,0xffffe
    80005a18:	f9c080e7          	jalr	-100(ra) # 800039b0 <iupdate>
  iunlockput(ip);
    80005a1c:	854a                	mv	a0,s2
    80005a1e:	ffffe097          	auipc	ra,0xffffe
    80005a22:	2c4080e7          	jalr	708(ra) # 80003ce2 <iunlockput>
  end_op();
    80005a26:	fffff097          	auipc	ra,0xfffff
    80005a2a:	aba080e7          	jalr	-1350(ra) # 800044e0 <end_op>
  return 0;
    80005a2e:	4501                	li	a0,0
    80005a30:	74ae                	ld	s1,232(sp)
    80005a32:	790e                	ld	s2,224(sp)
    80005a34:	69ee                	ld	s3,216(sp)
    80005a36:	a86d                	j	80005af0 <sys_unlink+0x1d2>
    end_op();
    80005a38:	fffff097          	auipc	ra,0xfffff
    80005a3c:	aa8080e7          	jalr	-1368(ra) # 800044e0 <end_op>
    return -1;
    80005a40:	557d                	li	a0,-1
    80005a42:	74ae                	ld	s1,232(sp)
    80005a44:	a075                	j	80005af0 <sys_unlink+0x1d2>
    80005a46:	e9d2                	sd	s4,208(sp)
    80005a48:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    80005a4a:	00003517          	auipc	a0,0x3
    80005a4e:	c8650513          	addi	a0,a0,-890 # 800086d0 <etext+0x6d0>
    80005a52:	ffffb097          	auipc	ra,0xffffb
    80005a56:	b0e080e7          	jalr	-1266(ra) # 80000560 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005a5a:	04c92703          	lw	a4,76(s2)
    80005a5e:	02000793          	li	a5,32
    80005a62:	f6e7f3e3          	bgeu	a5,a4,800059c8 <sys_unlink+0xaa>
    80005a66:	e9d2                	sd	s4,208(sp)
    80005a68:	e5d6                	sd	s5,200(sp)
    80005a6a:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005a6c:	f0840a93          	addi	s5,s0,-248
    80005a70:	4a41                	li	s4,16
    80005a72:	8752                	mv	a4,s4
    80005a74:	86ce                	mv	a3,s3
    80005a76:	8656                	mv	a2,s5
    80005a78:	4581                	li	a1,0
    80005a7a:	854a                	mv	a0,s2
    80005a7c:	ffffe097          	auipc	ra,0xffffe
    80005a80:	2bc080e7          	jalr	700(ra) # 80003d38 <readi>
    80005a84:	01451d63          	bne	a0,s4,80005a9e <sys_unlink+0x180>
    if(de.inum != 0)
    80005a88:	f0845783          	lhu	a5,-248(s0)
    80005a8c:	eba5                	bnez	a5,80005afc <sys_unlink+0x1de>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005a8e:	29c1                	addiw	s3,s3,16
    80005a90:	04c92783          	lw	a5,76(s2)
    80005a94:	fcf9efe3          	bltu	s3,a5,80005a72 <sys_unlink+0x154>
    80005a98:	6a4e                	ld	s4,208(sp)
    80005a9a:	6aae                	ld	s5,200(sp)
    80005a9c:	b735                	j	800059c8 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005a9e:	00003517          	auipc	a0,0x3
    80005aa2:	c4a50513          	addi	a0,a0,-950 # 800086e8 <etext+0x6e8>
    80005aa6:	ffffb097          	auipc	ra,0xffffb
    80005aaa:	aba080e7          	jalr	-1350(ra) # 80000560 <panic>
    80005aae:	e9d2                	sd	s4,208(sp)
    80005ab0:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    80005ab2:	00003517          	auipc	a0,0x3
    80005ab6:	c4e50513          	addi	a0,a0,-946 # 80008700 <etext+0x700>
    80005aba:	ffffb097          	auipc	ra,0xffffb
    80005abe:	aa6080e7          	jalr	-1370(ra) # 80000560 <panic>
    dp->nlink--;
    80005ac2:	04a4d783          	lhu	a5,74(s1)
    80005ac6:	37fd                	addiw	a5,a5,-1
    80005ac8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005acc:	8526                	mv	a0,s1
    80005ace:	ffffe097          	auipc	ra,0xffffe
    80005ad2:	ee2080e7          	jalr	-286(ra) # 800039b0 <iupdate>
    80005ad6:	b725                	j	800059fe <sys_unlink+0xe0>
    80005ad8:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    80005ada:	8526                	mv	a0,s1
    80005adc:	ffffe097          	auipc	ra,0xffffe
    80005ae0:	206080e7          	jalr	518(ra) # 80003ce2 <iunlockput>
  end_op();
    80005ae4:	fffff097          	auipc	ra,0xfffff
    80005ae8:	9fc080e7          	jalr	-1540(ra) # 800044e0 <end_op>
  return -1;
    80005aec:	557d                	li	a0,-1
    80005aee:	74ae                	ld	s1,232(sp)
}
    80005af0:	70ee                	ld	ra,248(sp)
    80005af2:	744e                	ld	s0,240(sp)
    80005af4:	6111                	addi	sp,sp,256
    80005af6:	8082                	ret
    return -1;
    80005af8:	557d                	li	a0,-1
    80005afa:	bfdd                	j	80005af0 <sys_unlink+0x1d2>
    iunlockput(ip);
    80005afc:	854a                	mv	a0,s2
    80005afe:	ffffe097          	auipc	ra,0xffffe
    80005b02:	1e4080e7          	jalr	484(ra) # 80003ce2 <iunlockput>
    goto bad;
    80005b06:	790e                	ld	s2,224(sp)
    80005b08:	69ee                	ld	s3,216(sp)
    80005b0a:	6a4e                	ld	s4,208(sp)
    80005b0c:	6aae                	ld	s5,200(sp)
    80005b0e:	b7f1                	j	80005ada <sys_unlink+0x1bc>

0000000080005b10 <sys_open>:

uint64
sys_open(void)
{
    80005b10:	7131                	addi	sp,sp,-192
    80005b12:	fd06                	sd	ra,184(sp)
    80005b14:	f922                	sd	s0,176(sp)
    80005b16:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005b18:	f4c40593          	addi	a1,s0,-180
    80005b1c:	4505                	li	a0,1
    80005b1e:	ffffd097          	auipc	ra,0xffffd
    80005b22:	356080e7          	jalr	854(ra) # 80002e74 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005b26:	08000613          	li	a2,128
    80005b2a:	f5040593          	addi	a1,s0,-176
    80005b2e:	4501                	li	a0,0
    80005b30:	ffffd097          	auipc	ra,0xffffd
    80005b34:	384080e7          	jalr	900(ra) # 80002eb4 <argstr>
    80005b38:	87aa                	mv	a5,a0
    return -1;
    80005b3a:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005b3c:	0a07cf63          	bltz	a5,80005bfa <sys_open+0xea>
    80005b40:	f526                	sd	s1,168(sp)

  begin_op();
    80005b42:	fffff097          	auipc	ra,0xfffff
    80005b46:	924080e7          	jalr	-1756(ra) # 80004466 <begin_op>

  if(omode & O_CREATE){
    80005b4a:	f4c42783          	lw	a5,-180(s0)
    80005b4e:	2007f793          	andi	a5,a5,512
    80005b52:	cfdd                	beqz	a5,80005c10 <sys_open+0x100>
    ip = create(path, T_FILE, 0, 0);
    80005b54:	4681                	li	a3,0
    80005b56:	4601                	li	a2,0
    80005b58:	4589                	li	a1,2
    80005b5a:	f5040513          	addi	a0,s0,-176
    80005b5e:	00000097          	auipc	ra,0x0
    80005b62:	94c080e7          	jalr	-1716(ra) # 800054aa <create>
    80005b66:	84aa                	mv	s1,a0
    if(ip == 0){
    80005b68:	cd49                	beqz	a0,80005c02 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005b6a:	04449703          	lh	a4,68(s1)
    80005b6e:	478d                	li	a5,3
    80005b70:	00f71763          	bne	a4,a5,80005b7e <sys_open+0x6e>
    80005b74:	0464d703          	lhu	a4,70(s1)
    80005b78:	47a5                	li	a5,9
    80005b7a:	0ee7e263          	bltu	a5,a4,80005c5e <sys_open+0x14e>
    80005b7e:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005b80:	fffff097          	auipc	ra,0xfffff
    80005b84:	cfa080e7          	jalr	-774(ra) # 8000487a <filealloc>
    80005b88:	892a                	mv	s2,a0
    80005b8a:	cd65                	beqz	a0,80005c82 <sys_open+0x172>
    80005b8c:	ed4e                	sd	s3,152(sp)
    80005b8e:	00000097          	auipc	ra,0x0
    80005b92:	8da080e7          	jalr	-1830(ra) # 80005468 <fdalloc>
    80005b96:	89aa                	mv	s3,a0
    80005b98:	0c054f63          	bltz	a0,80005c76 <sys_open+0x166>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005b9c:	04449703          	lh	a4,68(s1)
    80005ba0:	478d                	li	a5,3
    80005ba2:	0ef70d63          	beq	a4,a5,80005c9c <sys_open+0x18c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005ba6:	4789                	li	a5,2
    80005ba8:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005bac:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005bb0:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005bb4:	f4c42783          	lw	a5,-180(s0)
    80005bb8:	0017f713          	andi	a4,a5,1
    80005bbc:	00174713          	xori	a4,a4,1
    80005bc0:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005bc4:	0037f713          	andi	a4,a5,3
    80005bc8:	00e03733          	snez	a4,a4
    80005bcc:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005bd0:	4007f793          	andi	a5,a5,1024
    80005bd4:	c791                	beqz	a5,80005be0 <sys_open+0xd0>
    80005bd6:	04449703          	lh	a4,68(s1)
    80005bda:	4789                	li	a5,2
    80005bdc:	0cf70763          	beq	a4,a5,80005caa <sys_open+0x19a>
    itrunc(ip);
  }

  iunlock(ip);
    80005be0:	8526                	mv	a0,s1
    80005be2:	ffffe097          	auipc	ra,0xffffe
    80005be6:	f60080e7          	jalr	-160(ra) # 80003b42 <iunlock>
  end_op();
    80005bea:	fffff097          	auipc	ra,0xfffff
    80005bee:	8f6080e7          	jalr	-1802(ra) # 800044e0 <end_op>

  return fd;
    80005bf2:	854e                	mv	a0,s3
    80005bf4:	74aa                	ld	s1,168(sp)
    80005bf6:	790a                	ld	s2,160(sp)
    80005bf8:	69ea                	ld	s3,152(sp)
}
    80005bfa:	70ea                	ld	ra,184(sp)
    80005bfc:	744a                	ld	s0,176(sp)
    80005bfe:	6129                	addi	sp,sp,192
    80005c00:	8082                	ret
      end_op();
    80005c02:	fffff097          	auipc	ra,0xfffff
    80005c06:	8de080e7          	jalr	-1826(ra) # 800044e0 <end_op>
      return -1;
    80005c0a:	557d                	li	a0,-1
    80005c0c:	74aa                	ld	s1,168(sp)
    80005c0e:	b7f5                	j	80005bfa <sys_open+0xea>
    if((ip = namei(path)) == 0){
    80005c10:	f5040513          	addi	a0,s0,-176
    80005c14:	ffffe097          	auipc	ra,0xffffe
    80005c18:	64c080e7          	jalr	1612(ra) # 80004260 <namei>
    80005c1c:	84aa                	mv	s1,a0
    80005c1e:	c90d                	beqz	a0,80005c50 <sys_open+0x140>
    ilock(ip);
    80005c20:	ffffe097          	auipc	ra,0xffffe
    80005c24:	e5c080e7          	jalr	-420(ra) # 80003a7c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005c28:	04449703          	lh	a4,68(s1)
    80005c2c:	4785                	li	a5,1
    80005c2e:	f2f71ee3          	bne	a4,a5,80005b6a <sys_open+0x5a>
    80005c32:	f4c42783          	lw	a5,-180(s0)
    80005c36:	d7a1                	beqz	a5,80005b7e <sys_open+0x6e>
      iunlockput(ip);
    80005c38:	8526                	mv	a0,s1
    80005c3a:	ffffe097          	auipc	ra,0xffffe
    80005c3e:	0a8080e7          	jalr	168(ra) # 80003ce2 <iunlockput>
      end_op();
    80005c42:	fffff097          	auipc	ra,0xfffff
    80005c46:	89e080e7          	jalr	-1890(ra) # 800044e0 <end_op>
      return -1;
    80005c4a:	557d                	li	a0,-1
    80005c4c:	74aa                	ld	s1,168(sp)
    80005c4e:	b775                	j	80005bfa <sys_open+0xea>
      end_op();
    80005c50:	fffff097          	auipc	ra,0xfffff
    80005c54:	890080e7          	jalr	-1904(ra) # 800044e0 <end_op>
      return -1;
    80005c58:	557d                	li	a0,-1
    80005c5a:	74aa                	ld	s1,168(sp)
    80005c5c:	bf79                	j	80005bfa <sys_open+0xea>
    iunlockput(ip);
    80005c5e:	8526                	mv	a0,s1
    80005c60:	ffffe097          	auipc	ra,0xffffe
    80005c64:	082080e7          	jalr	130(ra) # 80003ce2 <iunlockput>
    end_op();
    80005c68:	fffff097          	auipc	ra,0xfffff
    80005c6c:	878080e7          	jalr	-1928(ra) # 800044e0 <end_op>
    return -1;
    80005c70:	557d                	li	a0,-1
    80005c72:	74aa                	ld	s1,168(sp)
    80005c74:	b759                	j	80005bfa <sys_open+0xea>
      fileclose(f);
    80005c76:	854a                	mv	a0,s2
    80005c78:	fffff097          	auipc	ra,0xfffff
    80005c7c:	cbe080e7          	jalr	-834(ra) # 80004936 <fileclose>
    80005c80:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005c82:	8526                	mv	a0,s1
    80005c84:	ffffe097          	auipc	ra,0xffffe
    80005c88:	05e080e7          	jalr	94(ra) # 80003ce2 <iunlockput>
    end_op();
    80005c8c:	fffff097          	auipc	ra,0xfffff
    80005c90:	854080e7          	jalr	-1964(ra) # 800044e0 <end_op>
    return -1;
    80005c94:	557d                	li	a0,-1
    80005c96:	74aa                	ld	s1,168(sp)
    80005c98:	790a                	ld	s2,160(sp)
    80005c9a:	b785                	j	80005bfa <sys_open+0xea>
    f->type = FD_DEVICE;
    80005c9c:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005ca0:	04649783          	lh	a5,70(s1)
    80005ca4:	02f91223          	sh	a5,36(s2)
    80005ca8:	b721                	j	80005bb0 <sys_open+0xa0>
    itrunc(ip);
    80005caa:	8526                	mv	a0,s1
    80005cac:	ffffe097          	auipc	ra,0xffffe
    80005cb0:	ee2080e7          	jalr	-286(ra) # 80003b8e <itrunc>
    80005cb4:	b735                	j	80005be0 <sys_open+0xd0>

0000000080005cb6 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005cb6:	7175                	addi	sp,sp,-144
    80005cb8:	e506                	sd	ra,136(sp)
    80005cba:	e122                	sd	s0,128(sp)
    80005cbc:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005cbe:	ffffe097          	auipc	ra,0xffffe
    80005cc2:	7a8080e7          	jalr	1960(ra) # 80004466 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005cc6:	08000613          	li	a2,128
    80005cca:	f7040593          	addi	a1,s0,-144
    80005cce:	4501                	li	a0,0
    80005cd0:	ffffd097          	auipc	ra,0xffffd
    80005cd4:	1e4080e7          	jalr	484(ra) # 80002eb4 <argstr>
    80005cd8:	02054963          	bltz	a0,80005d0a <sys_mkdir+0x54>
    80005cdc:	4681                	li	a3,0
    80005cde:	4601                	li	a2,0
    80005ce0:	4585                	li	a1,1
    80005ce2:	f7040513          	addi	a0,s0,-144
    80005ce6:	fffff097          	auipc	ra,0xfffff
    80005cea:	7c4080e7          	jalr	1988(ra) # 800054aa <create>
    80005cee:	cd11                	beqz	a0,80005d0a <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005cf0:	ffffe097          	auipc	ra,0xffffe
    80005cf4:	ff2080e7          	jalr	-14(ra) # 80003ce2 <iunlockput>
  end_op();
    80005cf8:	ffffe097          	auipc	ra,0xffffe
    80005cfc:	7e8080e7          	jalr	2024(ra) # 800044e0 <end_op>
  return 0;
    80005d00:	4501                	li	a0,0
}
    80005d02:	60aa                	ld	ra,136(sp)
    80005d04:	640a                	ld	s0,128(sp)
    80005d06:	6149                	addi	sp,sp,144
    80005d08:	8082                	ret
    end_op();
    80005d0a:	ffffe097          	auipc	ra,0xffffe
    80005d0e:	7d6080e7          	jalr	2006(ra) # 800044e0 <end_op>
    return -1;
    80005d12:	557d                	li	a0,-1
    80005d14:	b7fd                	j	80005d02 <sys_mkdir+0x4c>

0000000080005d16 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005d16:	7135                	addi	sp,sp,-160
    80005d18:	ed06                	sd	ra,152(sp)
    80005d1a:	e922                	sd	s0,144(sp)
    80005d1c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005d1e:	ffffe097          	auipc	ra,0xffffe
    80005d22:	748080e7          	jalr	1864(ra) # 80004466 <begin_op>
  argint(1, &major);
    80005d26:	f6c40593          	addi	a1,s0,-148
    80005d2a:	4505                	li	a0,1
    80005d2c:	ffffd097          	auipc	ra,0xffffd
    80005d30:	148080e7          	jalr	328(ra) # 80002e74 <argint>
  argint(2, &minor);
    80005d34:	f6840593          	addi	a1,s0,-152
    80005d38:	4509                	li	a0,2
    80005d3a:	ffffd097          	auipc	ra,0xffffd
    80005d3e:	13a080e7          	jalr	314(ra) # 80002e74 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005d42:	08000613          	li	a2,128
    80005d46:	f7040593          	addi	a1,s0,-144
    80005d4a:	4501                	li	a0,0
    80005d4c:	ffffd097          	auipc	ra,0xffffd
    80005d50:	168080e7          	jalr	360(ra) # 80002eb4 <argstr>
    80005d54:	02054b63          	bltz	a0,80005d8a <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005d58:	f6841683          	lh	a3,-152(s0)
    80005d5c:	f6c41603          	lh	a2,-148(s0)
    80005d60:	458d                	li	a1,3
    80005d62:	f7040513          	addi	a0,s0,-144
    80005d66:	fffff097          	auipc	ra,0xfffff
    80005d6a:	744080e7          	jalr	1860(ra) # 800054aa <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005d6e:	cd11                	beqz	a0,80005d8a <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005d70:	ffffe097          	auipc	ra,0xffffe
    80005d74:	f72080e7          	jalr	-142(ra) # 80003ce2 <iunlockput>
  end_op();
    80005d78:	ffffe097          	auipc	ra,0xffffe
    80005d7c:	768080e7          	jalr	1896(ra) # 800044e0 <end_op>
  return 0;
    80005d80:	4501                	li	a0,0
}
    80005d82:	60ea                	ld	ra,152(sp)
    80005d84:	644a                	ld	s0,144(sp)
    80005d86:	610d                	addi	sp,sp,160
    80005d88:	8082                	ret
    end_op();
    80005d8a:	ffffe097          	auipc	ra,0xffffe
    80005d8e:	756080e7          	jalr	1878(ra) # 800044e0 <end_op>
    return -1;
    80005d92:	557d                	li	a0,-1
    80005d94:	b7fd                	j	80005d82 <sys_mknod+0x6c>

0000000080005d96 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005d96:	7135                	addi	sp,sp,-160
    80005d98:	ed06                	sd	ra,152(sp)
    80005d9a:	e922                	sd	s0,144(sp)
    80005d9c:	e14a                	sd	s2,128(sp)
    80005d9e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005da0:	ffffc097          	auipc	ra,0xffffc
    80005da4:	da0080e7          	jalr	-608(ra) # 80001b40 <myproc>
    80005da8:	892a                	mv	s2,a0
  
  begin_op();
    80005daa:	ffffe097          	auipc	ra,0xffffe
    80005dae:	6bc080e7          	jalr	1724(ra) # 80004466 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005db2:	08000613          	li	a2,128
    80005db6:	f6040593          	addi	a1,s0,-160
    80005dba:	4501                	li	a0,0
    80005dbc:	ffffd097          	auipc	ra,0xffffd
    80005dc0:	0f8080e7          	jalr	248(ra) # 80002eb4 <argstr>
    80005dc4:	04054d63          	bltz	a0,80005e1e <sys_chdir+0x88>
    80005dc8:	e526                	sd	s1,136(sp)
    80005dca:	f6040513          	addi	a0,s0,-160
    80005dce:	ffffe097          	auipc	ra,0xffffe
    80005dd2:	492080e7          	jalr	1170(ra) # 80004260 <namei>
    80005dd6:	84aa                	mv	s1,a0
    80005dd8:	c131                	beqz	a0,80005e1c <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005dda:	ffffe097          	auipc	ra,0xffffe
    80005dde:	ca2080e7          	jalr	-862(ra) # 80003a7c <ilock>
  if(ip->type != T_DIR){
    80005de2:	04449703          	lh	a4,68(s1)
    80005de6:	4785                	li	a5,1
    80005de8:	04f71163          	bne	a4,a5,80005e2a <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005dec:	8526                	mv	a0,s1
    80005dee:	ffffe097          	auipc	ra,0xffffe
    80005df2:	d54080e7          	jalr	-684(ra) # 80003b42 <iunlock>
  iput(p->cwd);
    80005df6:	15093503          	ld	a0,336(s2)
    80005dfa:	ffffe097          	auipc	ra,0xffffe
    80005dfe:	e40080e7          	jalr	-448(ra) # 80003c3a <iput>
  end_op();
    80005e02:	ffffe097          	auipc	ra,0xffffe
    80005e06:	6de080e7          	jalr	1758(ra) # 800044e0 <end_op>
  p->cwd = ip;
    80005e0a:	14993823          	sd	s1,336(s2)
  return 0;
    80005e0e:	4501                	li	a0,0
    80005e10:	64aa                	ld	s1,136(sp)
}
    80005e12:	60ea                	ld	ra,152(sp)
    80005e14:	644a                	ld	s0,144(sp)
    80005e16:	690a                	ld	s2,128(sp)
    80005e18:	610d                	addi	sp,sp,160
    80005e1a:	8082                	ret
    80005e1c:	64aa                	ld	s1,136(sp)
    end_op();
    80005e1e:	ffffe097          	auipc	ra,0xffffe
    80005e22:	6c2080e7          	jalr	1730(ra) # 800044e0 <end_op>
    return -1;
    80005e26:	557d                	li	a0,-1
    80005e28:	b7ed                	j	80005e12 <sys_chdir+0x7c>
    iunlockput(ip);
    80005e2a:	8526                	mv	a0,s1
    80005e2c:	ffffe097          	auipc	ra,0xffffe
    80005e30:	eb6080e7          	jalr	-330(ra) # 80003ce2 <iunlockput>
    end_op();
    80005e34:	ffffe097          	auipc	ra,0xffffe
    80005e38:	6ac080e7          	jalr	1708(ra) # 800044e0 <end_op>
    return -1;
    80005e3c:	557d                	li	a0,-1
    80005e3e:	64aa                	ld	s1,136(sp)
    80005e40:	bfc9                	j	80005e12 <sys_chdir+0x7c>

0000000080005e42 <sys_exec>:

uint64
sys_exec(void)
{
    80005e42:	7105                	addi	sp,sp,-480
    80005e44:	ef86                	sd	ra,472(sp)
    80005e46:	eba2                	sd	s0,464(sp)
    80005e48:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005e4a:	e2840593          	addi	a1,s0,-472
    80005e4e:	4505                	li	a0,1
    80005e50:	ffffd097          	auipc	ra,0xffffd
    80005e54:	044080e7          	jalr	68(ra) # 80002e94 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005e58:	08000613          	li	a2,128
    80005e5c:	f3040593          	addi	a1,s0,-208
    80005e60:	4501                	li	a0,0
    80005e62:	ffffd097          	auipc	ra,0xffffd
    80005e66:	052080e7          	jalr	82(ra) # 80002eb4 <argstr>
    80005e6a:	87aa                	mv	a5,a0
    return -1;
    80005e6c:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005e6e:	0e07ce63          	bltz	a5,80005f6a <sys_exec+0x128>
    80005e72:	e7a6                	sd	s1,456(sp)
    80005e74:	e3ca                	sd	s2,448(sp)
    80005e76:	ff4e                	sd	s3,440(sp)
    80005e78:	fb52                	sd	s4,432(sp)
    80005e7a:	f756                	sd	s5,424(sp)
    80005e7c:	f35a                	sd	s6,416(sp)
    80005e7e:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005e80:	e3040a13          	addi	s4,s0,-464
    80005e84:	10000613          	li	a2,256
    80005e88:	4581                	li	a1,0
    80005e8a:	8552                	mv	a0,s4
    80005e8c:	ffffb097          	auipc	ra,0xffffb
    80005e90:	eaa080e7          	jalr	-342(ra) # 80000d36 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005e94:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80005e96:	89d2                	mv	s3,s4
    80005e98:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005e9a:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005e9e:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    80005ea0:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005ea4:	00391513          	slli	a0,s2,0x3
    80005ea8:	85d6                	mv	a1,s5
    80005eaa:	e2843783          	ld	a5,-472(s0)
    80005eae:	953e                	add	a0,a0,a5
    80005eb0:	ffffd097          	auipc	ra,0xffffd
    80005eb4:	f26080e7          	jalr	-218(ra) # 80002dd6 <fetchaddr>
    80005eb8:	02054a63          	bltz	a0,80005eec <sys_exec+0xaa>
    if(uarg == 0){
    80005ebc:	e2043783          	ld	a5,-480(s0)
    80005ec0:	cbb1                	beqz	a5,80005f14 <sys_exec+0xd2>
    argv[i] = kalloc();
    80005ec2:	ffffb097          	auipc	ra,0xffffb
    80005ec6:	c88080e7          	jalr	-888(ra) # 80000b4a <kalloc>
    80005eca:	85aa                	mv	a1,a0
    80005ecc:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005ed0:	cd11                	beqz	a0,80005eec <sys_exec+0xaa>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005ed2:	865a                	mv	a2,s6
    80005ed4:	e2043503          	ld	a0,-480(s0)
    80005ed8:	ffffd097          	auipc	ra,0xffffd
    80005edc:	f50080e7          	jalr	-176(ra) # 80002e28 <fetchstr>
    80005ee0:	00054663          	bltz	a0,80005eec <sys_exec+0xaa>
    if(i >= NELEM(argv)){
    80005ee4:	0905                	addi	s2,s2,1
    80005ee6:	09a1                	addi	s3,s3,8
    80005ee8:	fb791ee3          	bne	s2,s7,80005ea4 <sys_exec+0x62>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005eec:	100a0a13          	addi	s4,s4,256
    80005ef0:	6088                	ld	a0,0(s1)
    80005ef2:	c525                	beqz	a0,80005f5a <sys_exec+0x118>
    kfree(argv[i]);
    80005ef4:	ffffb097          	auipc	ra,0xffffb
    80005ef8:	b58080e7          	jalr	-1192(ra) # 80000a4c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005efc:	04a1                	addi	s1,s1,8
    80005efe:	ff4499e3          	bne	s1,s4,80005ef0 <sys_exec+0xae>
  return -1;
    80005f02:	557d                	li	a0,-1
    80005f04:	64be                	ld	s1,456(sp)
    80005f06:	691e                	ld	s2,448(sp)
    80005f08:	79fa                	ld	s3,440(sp)
    80005f0a:	7a5a                	ld	s4,432(sp)
    80005f0c:	7aba                	ld	s5,424(sp)
    80005f0e:	7b1a                	ld	s6,416(sp)
    80005f10:	6bfa                	ld	s7,408(sp)
    80005f12:	a8a1                	j	80005f6a <sys_exec+0x128>
      argv[i] = 0;
    80005f14:	0009079b          	sext.w	a5,s2
    80005f18:	e3040593          	addi	a1,s0,-464
    80005f1c:	078e                	slli	a5,a5,0x3
    80005f1e:	97ae                	add	a5,a5,a1
    80005f20:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    80005f24:	f3040513          	addi	a0,s0,-208
    80005f28:	fffff097          	auipc	ra,0xfffff
    80005f2c:	118080e7          	jalr	280(ra) # 80005040 <exec>
    80005f30:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005f32:	100a0a13          	addi	s4,s4,256
    80005f36:	6088                	ld	a0,0(s1)
    80005f38:	c901                	beqz	a0,80005f48 <sys_exec+0x106>
    kfree(argv[i]);
    80005f3a:	ffffb097          	auipc	ra,0xffffb
    80005f3e:	b12080e7          	jalr	-1262(ra) # 80000a4c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005f42:	04a1                	addi	s1,s1,8
    80005f44:	ff4499e3          	bne	s1,s4,80005f36 <sys_exec+0xf4>
  return ret;
    80005f48:	854a                	mv	a0,s2
    80005f4a:	64be                	ld	s1,456(sp)
    80005f4c:	691e                	ld	s2,448(sp)
    80005f4e:	79fa                	ld	s3,440(sp)
    80005f50:	7a5a                	ld	s4,432(sp)
    80005f52:	7aba                	ld	s5,424(sp)
    80005f54:	7b1a                	ld	s6,416(sp)
    80005f56:	6bfa                	ld	s7,408(sp)
    80005f58:	a809                	j	80005f6a <sys_exec+0x128>
  return -1;
    80005f5a:	557d                	li	a0,-1
    80005f5c:	64be                	ld	s1,456(sp)
    80005f5e:	691e                	ld	s2,448(sp)
    80005f60:	79fa                	ld	s3,440(sp)
    80005f62:	7a5a                	ld	s4,432(sp)
    80005f64:	7aba                	ld	s5,424(sp)
    80005f66:	7b1a                	ld	s6,416(sp)
    80005f68:	6bfa                	ld	s7,408(sp)
}
    80005f6a:	60fe                	ld	ra,472(sp)
    80005f6c:	645e                	ld	s0,464(sp)
    80005f6e:	613d                	addi	sp,sp,480
    80005f70:	8082                	ret

0000000080005f72 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005f72:	7139                	addi	sp,sp,-64
    80005f74:	fc06                	sd	ra,56(sp)
    80005f76:	f822                	sd	s0,48(sp)
    80005f78:	f426                	sd	s1,40(sp)
    80005f7a:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005f7c:	ffffc097          	auipc	ra,0xffffc
    80005f80:	bc4080e7          	jalr	-1084(ra) # 80001b40 <myproc>
    80005f84:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005f86:	fd840593          	addi	a1,s0,-40
    80005f8a:	4501                	li	a0,0
    80005f8c:	ffffd097          	auipc	ra,0xffffd
    80005f90:	f08080e7          	jalr	-248(ra) # 80002e94 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005f94:	fc840593          	addi	a1,s0,-56
    80005f98:	fd040513          	addi	a0,s0,-48
    80005f9c:	fffff097          	auipc	ra,0xfffff
    80005fa0:	d0e080e7          	jalr	-754(ra) # 80004caa <pipealloc>
    return -1;
    80005fa4:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005fa6:	0c054463          	bltz	a0,8000606e <sys_pipe+0xfc>
  fd0 = -1;
    80005faa:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005fae:	fd043503          	ld	a0,-48(s0)
    80005fb2:	fffff097          	auipc	ra,0xfffff
    80005fb6:	4b6080e7          	jalr	1206(ra) # 80005468 <fdalloc>
    80005fba:	fca42223          	sw	a0,-60(s0)
    80005fbe:	08054b63          	bltz	a0,80006054 <sys_pipe+0xe2>
    80005fc2:	fc843503          	ld	a0,-56(s0)
    80005fc6:	fffff097          	auipc	ra,0xfffff
    80005fca:	4a2080e7          	jalr	1186(ra) # 80005468 <fdalloc>
    80005fce:	fca42023          	sw	a0,-64(s0)
    80005fd2:	06054863          	bltz	a0,80006042 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005fd6:	4691                	li	a3,4
    80005fd8:	fc440613          	addi	a2,s0,-60
    80005fdc:	fd843583          	ld	a1,-40(s0)
    80005fe0:	68a8                	ld	a0,80(s1)
    80005fe2:	ffffb097          	auipc	ra,0xffffb
    80005fe6:	72e080e7          	jalr	1838(ra) # 80001710 <copyout>
    80005fea:	02054063          	bltz	a0,8000600a <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005fee:	4691                	li	a3,4
    80005ff0:	fc040613          	addi	a2,s0,-64
    80005ff4:	fd843583          	ld	a1,-40(s0)
    80005ff8:	95b6                	add	a1,a1,a3
    80005ffa:	68a8                	ld	a0,80(s1)
    80005ffc:	ffffb097          	auipc	ra,0xffffb
    80006000:	714080e7          	jalr	1812(ra) # 80001710 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80006004:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006006:	06055463          	bgez	a0,8000606e <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    8000600a:	fc442783          	lw	a5,-60(s0)
    8000600e:	07e9                	addi	a5,a5,26
    80006010:	078e                	slli	a5,a5,0x3
    80006012:	97a6                	add	a5,a5,s1
    80006014:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80006018:	fc042783          	lw	a5,-64(s0)
    8000601c:	07e9                	addi	a5,a5,26
    8000601e:	078e                	slli	a5,a5,0x3
    80006020:	94be                	add	s1,s1,a5
    80006022:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80006026:	fd043503          	ld	a0,-48(s0)
    8000602a:	fffff097          	auipc	ra,0xfffff
    8000602e:	90c080e7          	jalr	-1780(ra) # 80004936 <fileclose>
    fileclose(wf);
    80006032:	fc843503          	ld	a0,-56(s0)
    80006036:	fffff097          	auipc	ra,0xfffff
    8000603a:	900080e7          	jalr	-1792(ra) # 80004936 <fileclose>
    return -1;
    8000603e:	57fd                	li	a5,-1
    80006040:	a03d                	j	8000606e <sys_pipe+0xfc>
    if(fd0 >= 0)
    80006042:	fc442783          	lw	a5,-60(s0)
    80006046:	0007c763          	bltz	a5,80006054 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    8000604a:	07e9                	addi	a5,a5,26
    8000604c:	078e                	slli	a5,a5,0x3
    8000604e:	97a6                	add	a5,a5,s1
    80006050:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80006054:	fd043503          	ld	a0,-48(s0)
    80006058:	fffff097          	auipc	ra,0xfffff
    8000605c:	8de080e7          	jalr	-1826(ra) # 80004936 <fileclose>
    fileclose(wf);
    80006060:	fc843503          	ld	a0,-56(s0)
    80006064:	fffff097          	auipc	ra,0xfffff
    80006068:	8d2080e7          	jalr	-1838(ra) # 80004936 <fileclose>
    return -1;
    8000606c:	57fd                	li	a5,-1
}
    8000606e:	853e                	mv	a0,a5
    80006070:	70e2                	ld	ra,56(sp)
    80006072:	7442                	ld	s0,48(sp)
    80006074:	74a2                	ld	s1,40(sp)
    80006076:	6121                	addi	sp,sp,64
    80006078:	8082                	ret
    8000607a:	0000                	unimp
    8000607c:	0000                	unimp
	...

0000000080006080 <kernelvec>:
    80006080:	7111                	addi	sp,sp,-256
    80006082:	e006                	sd	ra,0(sp)
    80006084:	e40a                	sd	sp,8(sp)
    80006086:	e80e                	sd	gp,16(sp)
    80006088:	ec12                	sd	tp,24(sp)
    8000608a:	f016                	sd	t0,32(sp)
    8000608c:	f41a                	sd	t1,40(sp)
    8000608e:	f81e                	sd	t2,48(sp)
    80006090:	fc22                	sd	s0,56(sp)
    80006092:	e0a6                	sd	s1,64(sp)
    80006094:	e4aa                	sd	a0,72(sp)
    80006096:	e8ae                	sd	a1,80(sp)
    80006098:	ecb2                	sd	a2,88(sp)
    8000609a:	f0b6                	sd	a3,96(sp)
    8000609c:	f4ba                	sd	a4,104(sp)
    8000609e:	f8be                	sd	a5,112(sp)
    800060a0:	fcc2                	sd	a6,120(sp)
    800060a2:	e146                	sd	a7,128(sp)
    800060a4:	e54a                	sd	s2,136(sp)
    800060a6:	e94e                	sd	s3,144(sp)
    800060a8:	ed52                	sd	s4,152(sp)
    800060aa:	f156                	sd	s5,160(sp)
    800060ac:	f55a                	sd	s6,168(sp)
    800060ae:	f95e                	sd	s7,176(sp)
    800060b0:	fd62                	sd	s8,184(sp)
    800060b2:	e1e6                	sd	s9,192(sp)
    800060b4:	e5ea                	sd	s10,200(sp)
    800060b6:	e9ee                	sd	s11,208(sp)
    800060b8:	edf2                	sd	t3,216(sp)
    800060ba:	f1f6                	sd	t4,224(sp)
    800060bc:	f5fa                	sd	t5,232(sp)
    800060be:	f9fe                	sd	t6,240(sp)
    800060c0:	be1fc0ef          	jal	80002ca0 <kerneltrap>
    800060c4:	6082                	ld	ra,0(sp)
    800060c6:	6122                	ld	sp,8(sp)
    800060c8:	61c2                	ld	gp,16(sp)
    800060ca:	7282                	ld	t0,32(sp)
    800060cc:	7322                	ld	t1,40(sp)
    800060ce:	73c2                	ld	t2,48(sp)
    800060d0:	7462                	ld	s0,56(sp)
    800060d2:	6486                	ld	s1,64(sp)
    800060d4:	6526                	ld	a0,72(sp)
    800060d6:	65c6                	ld	a1,80(sp)
    800060d8:	6666                	ld	a2,88(sp)
    800060da:	7686                	ld	a3,96(sp)
    800060dc:	7726                	ld	a4,104(sp)
    800060de:	77c6                	ld	a5,112(sp)
    800060e0:	7866                	ld	a6,120(sp)
    800060e2:	688a                	ld	a7,128(sp)
    800060e4:	692a                	ld	s2,136(sp)
    800060e6:	69ca                	ld	s3,144(sp)
    800060e8:	6a6a                	ld	s4,152(sp)
    800060ea:	7a8a                	ld	s5,160(sp)
    800060ec:	7b2a                	ld	s6,168(sp)
    800060ee:	7bca                	ld	s7,176(sp)
    800060f0:	7c6a                	ld	s8,184(sp)
    800060f2:	6c8e                	ld	s9,192(sp)
    800060f4:	6d2e                	ld	s10,200(sp)
    800060f6:	6dce                	ld	s11,208(sp)
    800060f8:	6e6e                	ld	t3,216(sp)
    800060fa:	7e8e                	ld	t4,224(sp)
    800060fc:	7f2e                	ld	t5,232(sp)
    800060fe:	7fce                	ld	t6,240(sp)
    80006100:	6111                	addi	sp,sp,256
    80006102:	10200073          	sret
    80006106:	00000013          	nop
    8000610a:	00000013          	nop
    8000610e:	0001                	nop

0000000080006110 <timervec>:
    80006110:	34051573          	csrrw	a0,mscratch,a0
    80006114:	e10c                	sd	a1,0(a0)
    80006116:	e510                	sd	a2,8(a0)
    80006118:	e914                	sd	a3,16(a0)
    8000611a:	6d0c                	ld	a1,24(a0)
    8000611c:	7110                	ld	a2,32(a0)
    8000611e:	6194                	ld	a3,0(a1)
    80006120:	96b2                	add	a3,a3,a2
    80006122:	e194                	sd	a3,0(a1)
    80006124:	4589                	li	a1,2
    80006126:	14459073          	csrw	sip,a1
    8000612a:	6914                	ld	a3,16(a0)
    8000612c:	6510                	ld	a2,8(a0)
    8000612e:	610c                	ld	a1,0(a0)
    80006130:	34051573          	csrrw	a0,mscratch,a0
    80006134:	30200073          	mret
	...

000000008000613a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000613a:	1141                	addi	sp,sp,-16
    8000613c:	e406                	sd	ra,8(sp)
    8000613e:	e022                	sd	s0,0(sp)
    80006140:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006142:	0c000737          	lui	a4,0xc000
    80006146:	4785                	li	a5,1
    80006148:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000614a:	c35c                	sw	a5,4(a4)
}
    8000614c:	60a2                	ld	ra,8(sp)
    8000614e:	6402                	ld	s0,0(sp)
    80006150:	0141                	addi	sp,sp,16
    80006152:	8082                	ret

0000000080006154 <plicinithart>:

void
plicinithart(void)
{
    80006154:	1141                	addi	sp,sp,-16
    80006156:	e406                	sd	ra,8(sp)
    80006158:	e022                	sd	s0,0(sp)
    8000615a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000615c:	ffffc097          	auipc	ra,0xffffc
    80006160:	9b0080e7          	jalr	-1616(ra) # 80001b0c <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006164:	0085171b          	slliw	a4,a0,0x8
    80006168:	0c0027b7          	lui	a5,0xc002
    8000616c:	97ba                	add	a5,a5,a4
    8000616e:	40200713          	li	a4,1026
    80006172:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006176:	00d5151b          	slliw	a0,a0,0xd
    8000617a:	0c2017b7          	lui	a5,0xc201
    8000617e:	97aa                	add	a5,a5,a0
    80006180:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80006184:	60a2                	ld	ra,8(sp)
    80006186:	6402                	ld	s0,0(sp)
    80006188:	0141                	addi	sp,sp,16
    8000618a:	8082                	ret

000000008000618c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000618c:	1141                	addi	sp,sp,-16
    8000618e:	e406                	sd	ra,8(sp)
    80006190:	e022                	sd	s0,0(sp)
    80006192:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006194:	ffffc097          	auipc	ra,0xffffc
    80006198:	978080e7          	jalr	-1672(ra) # 80001b0c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000619c:	00d5151b          	slliw	a0,a0,0xd
    800061a0:	0c2017b7          	lui	a5,0xc201
    800061a4:	97aa                	add	a5,a5,a0
  return irq;
}
    800061a6:	43c8                	lw	a0,4(a5)
    800061a8:	60a2                	ld	ra,8(sp)
    800061aa:	6402                	ld	s0,0(sp)
    800061ac:	0141                	addi	sp,sp,16
    800061ae:	8082                	ret

00000000800061b0 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800061b0:	1101                	addi	sp,sp,-32
    800061b2:	ec06                	sd	ra,24(sp)
    800061b4:	e822                	sd	s0,16(sp)
    800061b6:	e426                	sd	s1,8(sp)
    800061b8:	1000                	addi	s0,sp,32
    800061ba:	84aa                	mv	s1,a0
  int hart = cpuid();
    800061bc:	ffffc097          	auipc	ra,0xffffc
    800061c0:	950080e7          	jalr	-1712(ra) # 80001b0c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800061c4:	00d5179b          	slliw	a5,a0,0xd
    800061c8:	0c201737          	lui	a4,0xc201
    800061cc:	97ba                	add	a5,a5,a4
    800061ce:	c3c4                	sw	s1,4(a5)
}
    800061d0:	60e2                	ld	ra,24(sp)
    800061d2:	6442                	ld	s0,16(sp)
    800061d4:	64a2                	ld	s1,8(sp)
    800061d6:	6105                	addi	sp,sp,32
    800061d8:	8082                	ret

00000000800061da <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800061da:	1141                	addi	sp,sp,-16
    800061dc:	e406                	sd	ra,8(sp)
    800061de:	e022                	sd	s0,0(sp)
    800061e0:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800061e2:	479d                	li	a5,7
    800061e4:	04a7cc63          	blt	a5,a0,8000623c <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800061e8:	0001c797          	auipc	a5,0x1c
    800061ec:	b4878793          	addi	a5,a5,-1208 # 80021d30 <disk>
    800061f0:	97aa                	add	a5,a5,a0
    800061f2:	0187c783          	lbu	a5,24(a5)
    800061f6:	ebb9                	bnez	a5,8000624c <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800061f8:	00451693          	slli	a3,a0,0x4
    800061fc:	0001c797          	auipc	a5,0x1c
    80006200:	b3478793          	addi	a5,a5,-1228 # 80021d30 <disk>
    80006204:	6398                	ld	a4,0(a5)
    80006206:	9736                	add	a4,a4,a3
    80006208:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    8000620c:	6398                	ld	a4,0(a5)
    8000620e:	9736                	add	a4,a4,a3
    80006210:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80006214:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006218:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    8000621c:	97aa                	add	a5,a5,a0
    8000621e:	4705                	li	a4,1
    80006220:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80006224:	0001c517          	auipc	a0,0x1c
    80006228:	b2450513          	addi	a0,a0,-1244 # 80021d48 <disk+0x18>
    8000622c:	ffffc097          	auipc	ra,0xffffc
    80006230:	152080e7          	jalr	338(ra) # 8000237e <wakeup>
}
    80006234:	60a2                	ld	ra,8(sp)
    80006236:	6402                	ld	s0,0(sp)
    80006238:	0141                	addi	sp,sp,16
    8000623a:	8082                	ret
    panic("free_desc 1");
    8000623c:	00002517          	auipc	a0,0x2
    80006240:	4d450513          	addi	a0,a0,1236 # 80008710 <etext+0x710>
    80006244:	ffffa097          	auipc	ra,0xffffa
    80006248:	31c080e7          	jalr	796(ra) # 80000560 <panic>
    panic("free_desc 2");
    8000624c:	00002517          	auipc	a0,0x2
    80006250:	4d450513          	addi	a0,a0,1236 # 80008720 <etext+0x720>
    80006254:	ffffa097          	auipc	ra,0xffffa
    80006258:	30c080e7          	jalr	780(ra) # 80000560 <panic>

000000008000625c <virtio_disk_init>:
{
    8000625c:	1101                	addi	sp,sp,-32
    8000625e:	ec06                	sd	ra,24(sp)
    80006260:	e822                	sd	s0,16(sp)
    80006262:	e426                	sd	s1,8(sp)
    80006264:	e04a                	sd	s2,0(sp)
    80006266:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006268:	00002597          	auipc	a1,0x2
    8000626c:	4c858593          	addi	a1,a1,1224 # 80008730 <etext+0x730>
    80006270:	0001c517          	auipc	a0,0x1c
    80006274:	be850513          	addi	a0,a0,-1048 # 80021e58 <disk+0x128>
    80006278:	ffffb097          	auipc	ra,0xffffb
    8000627c:	932080e7          	jalr	-1742(ra) # 80000baa <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006280:	100017b7          	lui	a5,0x10001
    80006284:	4398                	lw	a4,0(a5)
    80006286:	2701                	sext.w	a4,a4
    80006288:	747277b7          	lui	a5,0x74727
    8000628c:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006290:	16f71463          	bne	a4,a5,800063f8 <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006294:	100017b7          	lui	a5,0x10001
    80006298:	43dc                	lw	a5,4(a5)
    8000629a:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000629c:	4709                	li	a4,2
    8000629e:	14e79d63          	bne	a5,a4,800063f8 <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800062a2:	100017b7          	lui	a5,0x10001
    800062a6:	479c                	lw	a5,8(a5)
    800062a8:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800062aa:	14e79763          	bne	a5,a4,800063f8 <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800062ae:	100017b7          	lui	a5,0x10001
    800062b2:	47d8                	lw	a4,12(a5)
    800062b4:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800062b6:	554d47b7          	lui	a5,0x554d4
    800062ba:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800062be:	12f71d63          	bne	a4,a5,800063f8 <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_STATUS) = status;
    800062c2:	100017b7          	lui	a5,0x10001
    800062c6:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800062ca:	4705                	li	a4,1
    800062cc:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800062ce:	470d                	li	a4,3
    800062d0:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800062d2:	10001737          	lui	a4,0x10001
    800062d6:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800062d8:	c7ffe6b7          	lui	a3,0xc7ffe
    800062dc:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc8ef>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800062e0:	8f75                	and	a4,a4,a3
    800062e2:	100016b7          	lui	a3,0x10001
    800062e6:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    800062e8:	472d                	li	a4,11
    800062ea:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800062ec:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    800062f0:	439c                	lw	a5,0(a5)
    800062f2:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800062f6:	8ba1                	andi	a5,a5,8
    800062f8:	10078863          	beqz	a5,80006408 <virtio_disk_init+0x1ac>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800062fc:	100017b7          	lui	a5,0x10001
    80006300:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80006304:	43fc                	lw	a5,68(a5)
    80006306:	2781                	sext.w	a5,a5
    80006308:	10079863          	bnez	a5,80006418 <virtio_disk_init+0x1bc>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000630c:	100017b7          	lui	a5,0x10001
    80006310:	5bdc                	lw	a5,52(a5)
    80006312:	2781                	sext.w	a5,a5
  if(max == 0)
    80006314:	10078a63          	beqz	a5,80006428 <virtio_disk_init+0x1cc>
  if(max < NUM)
    80006318:	471d                	li	a4,7
    8000631a:	10f77f63          	bgeu	a4,a5,80006438 <virtio_disk_init+0x1dc>
  disk.desc = kalloc();
    8000631e:	ffffb097          	auipc	ra,0xffffb
    80006322:	82c080e7          	jalr	-2004(ra) # 80000b4a <kalloc>
    80006326:	0001c497          	auipc	s1,0x1c
    8000632a:	a0a48493          	addi	s1,s1,-1526 # 80021d30 <disk>
    8000632e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006330:	ffffb097          	auipc	ra,0xffffb
    80006334:	81a080e7          	jalr	-2022(ra) # 80000b4a <kalloc>
    80006338:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000633a:	ffffb097          	auipc	ra,0xffffb
    8000633e:	810080e7          	jalr	-2032(ra) # 80000b4a <kalloc>
    80006342:	87aa                	mv	a5,a0
    80006344:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006346:	6088                	ld	a0,0(s1)
    80006348:	10050063          	beqz	a0,80006448 <virtio_disk_init+0x1ec>
    8000634c:	0001c717          	auipc	a4,0x1c
    80006350:	9ec73703          	ld	a4,-1556(a4) # 80021d38 <disk+0x8>
    80006354:	cb75                	beqz	a4,80006448 <virtio_disk_init+0x1ec>
    80006356:	cbed                	beqz	a5,80006448 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80006358:	6605                	lui	a2,0x1
    8000635a:	4581                	li	a1,0
    8000635c:	ffffb097          	auipc	ra,0xffffb
    80006360:	9da080e7          	jalr	-1574(ra) # 80000d36 <memset>
  memset(disk.avail, 0, PGSIZE);
    80006364:	0001c497          	auipc	s1,0x1c
    80006368:	9cc48493          	addi	s1,s1,-1588 # 80021d30 <disk>
    8000636c:	6605                	lui	a2,0x1
    8000636e:	4581                	li	a1,0
    80006370:	6488                	ld	a0,8(s1)
    80006372:	ffffb097          	auipc	ra,0xffffb
    80006376:	9c4080e7          	jalr	-1596(ra) # 80000d36 <memset>
  memset(disk.used, 0, PGSIZE);
    8000637a:	6605                	lui	a2,0x1
    8000637c:	4581                	li	a1,0
    8000637e:	6888                	ld	a0,16(s1)
    80006380:	ffffb097          	auipc	ra,0xffffb
    80006384:	9b6080e7          	jalr	-1610(ra) # 80000d36 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006388:	100017b7          	lui	a5,0x10001
    8000638c:	4721                	li	a4,8
    8000638e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006390:	4098                	lw	a4,0(s1)
    80006392:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006396:	40d8                	lw	a4,4(s1)
    80006398:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000639c:	649c                	ld	a5,8(s1)
    8000639e:	0007869b          	sext.w	a3,a5
    800063a2:	10001737          	lui	a4,0x10001
    800063a6:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800063aa:	9781                	srai	a5,a5,0x20
    800063ac:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800063b0:	689c                	ld	a5,16(s1)
    800063b2:	0007869b          	sext.w	a3,a5
    800063b6:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800063ba:	9781                	srai	a5,a5,0x20
    800063bc:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800063c0:	4785                	li	a5,1
    800063c2:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    800063c4:	00f48c23          	sb	a5,24(s1)
    800063c8:	00f48ca3          	sb	a5,25(s1)
    800063cc:	00f48d23          	sb	a5,26(s1)
    800063d0:	00f48da3          	sb	a5,27(s1)
    800063d4:	00f48e23          	sb	a5,28(s1)
    800063d8:	00f48ea3          	sb	a5,29(s1)
    800063dc:	00f48f23          	sb	a5,30(s1)
    800063e0:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800063e4:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800063e8:	07272823          	sw	s2,112(a4)
}
    800063ec:	60e2                	ld	ra,24(sp)
    800063ee:	6442                	ld	s0,16(sp)
    800063f0:	64a2                	ld	s1,8(sp)
    800063f2:	6902                	ld	s2,0(sp)
    800063f4:	6105                	addi	sp,sp,32
    800063f6:	8082                	ret
    panic("could not find virtio disk");
    800063f8:	00002517          	auipc	a0,0x2
    800063fc:	34850513          	addi	a0,a0,840 # 80008740 <etext+0x740>
    80006400:	ffffa097          	auipc	ra,0xffffa
    80006404:	160080e7          	jalr	352(ra) # 80000560 <panic>
    panic("virtio disk FEATURES_OK unset");
    80006408:	00002517          	auipc	a0,0x2
    8000640c:	35850513          	addi	a0,a0,856 # 80008760 <etext+0x760>
    80006410:	ffffa097          	auipc	ra,0xffffa
    80006414:	150080e7          	jalr	336(ra) # 80000560 <panic>
    panic("virtio disk should not be ready");
    80006418:	00002517          	auipc	a0,0x2
    8000641c:	36850513          	addi	a0,a0,872 # 80008780 <etext+0x780>
    80006420:	ffffa097          	auipc	ra,0xffffa
    80006424:	140080e7          	jalr	320(ra) # 80000560 <panic>
    panic("virtio disk has no queue 0");
    80006428:	00002517          	auipc	a0,0x2
    8000642c:	37850513          	addi	a0,a0,888 # 800087a0 <etext+0x7a0>
    80006430:	ffffa097          	auipc	ra,0xffffa
    80006434:	130080e7          	jalr	304(ra) # 80000560 <panic>
    panic("virtio disk max queue too short");
    80006438:	00002517          	auipc	a0,0x2
    8000643c:	38850513          	addi	a0,a0,904 # 800087c0 <etext+0x7c0>
    80006440:	ffffa097          	auipc	ra,0xffffa
    80006444:	120080e7          	jalr	288(ra) # 80000560 <panic>
    panic("virtio disk kalloc");
    80006448:	00002517          	auipc	a0,0x2
    8000644c:	39850513          	addi	a0,a0,920 # 800087e0 <etext+0x7e0>
    80006450:	ffffa097          	auipc	ra,0xffffa
    80006454:	110080e7          	jalr	272(ra) # 80000560 <panic>

0000000080006458 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006458:	711d                	addi	sp,sp,-96
    8000645a:	ec86                	sd	ra,88(sp)
    8000645c:	e8a2                	sd	s0,80(sp)
    8000645e:	e4a6                	sd	s1,72(sp)
    80006460:	e0ca                	sd	s2,64(sp)
    80006462:	fc4e                	sd	s3,56(sp)
    80006464:	f852                	sd	s4,48(sp)
    80006466:	f456                	sd	s5,40(sp)
    80006468:	f05a                	sd	s6,32(sp)
    8000646a:	ec5e                	sd	s7,24(sp)
    8000646c:	e862                	sd	s8,16(sp)
    8000646e:	1080                	addi	s0,sp,96
    80006470:	89aa                	mv	s3,a0
    80006472:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006474:	00c52b83          	lw	s7,12(a0)
    80006478:	001b9b9b          	slliw	s7,s7,0x1
    8000647c:	1b82                	slli	s7,s7,0x20
    8000647e:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80006482:	0001c517          	auipc	a0,0x1c
    80006486:	9d650513          	addi	a0,a0,-1578 # 80021e58 <disk+0x128>
    8000648a:	ffffa097          	auipc	ra,0xffffa
    8000648e:	7b4080e7          	jalr	1972(ra) # 80000c3e <acquire>
  for(int i = 0; i < NUM; i++){
    80006492:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006494:	0001ca97          	auipc	s5,0x1c
    80006498:	89ca8a93          	addi	s5,s5,-1892 # 80021d30 <disk>
  for(int i = 0; i < 3; i++){
    8000649c:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    8000649e:	5c7d                	li	s8,-1
    800064a0:	a885                	j	80006510 <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800064a2:	00fa8733          	add	a4,s5,a5
    800064a6:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800064aa:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800064ac:	0207c563          	bltz	a5,800064d6 <virtio_disk_rw+0x7e>
  for(int i = 0; i < 3; i++){
    800064b0:	2905                	addiw	s2,s2,1
    800064b2:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800064b4:	07490263          	beq	s2,s4,80006518 <virtio_disk_rw+0xc0>
    idx[i] = alloc_desc();
    800064b8:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800064ba:	0001c717          	auipc	a4,0x1c
    800064be:	87670713          	addi	a4,a4,-1930 # 80021d30 <disk>
    800064c2:	4781                	li	a5,0
    if(disk.free[i]){
    800064c4:	01874683          	lbu	a3,24(a4)
    800064c8:	fee9                	bnez	a3,800064a2 <virtio_disk_rw+0x4a>
  for(int i = 0; i < NUM; i++){
    800064ca:	2785                	addiw	a5,a5,1
    800064cc:	0705                	addi	a4,a4,1
    800064ce:	fe979be3          	bne	a5,s1,800064c4 <virtio_disk_rw+0x6c>
    idx[i] = alloc_desc();
    800064d2:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    800064d6:	03205163          	blez	s2,800064f8 <virtio_disk_rw+0xa0>
        free_desc(idx[j]);
    800064da:	fa042503          	lw	a0,-96(s0)
    800064de:	00000097          	auipc	ra,0x0
    800064e2:	cfc080e7          	jalr	-772(ra) # 800061da <free_desc>
      for(int j = 0; j < i; j++)
    800064e6:	4785                	li	a5,1
    800064e8:	0127d863          	bge	a5,s2,800064f8 <virtio_disk_rw+0xa0>
        free_desc(idx[j]);
    800064ec:	fa442503          	lw	a0,-92(s0)
    800064f0:	00000097          	auipc	ra,0x0
    800064f4:	cea080e7          	jalr	-790(ra) # 800061da <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800064f8:	0001c597          	auipc	a1,0x1c
    800064fc:	96058593          	addi	a1,a1,-1696 # 80021e58 <disk+0x128>
    80006500:	0001c517          	auipc	a0,0x1c
    80006504:	84850513          	addi	a0,a0,-1976 # 80021d48 <disk+0x18>
    80006508:	ffffc097          	auipc	ra,0xffffc
    8000650c:	e12080e7          	jalr	-494(ra) # 8000231a <sleep>
  for(int i = 0; i < 3; i++){
    80006510:	fa040613          	addi	a2,s0,-96
    80006514:	4901                	li	s2,0
    80006516:	b74d                	j	800064b8 <virtio_disk_rw+0x60>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006518:	fa042503          	lw	a0,-96(s0)
    8000651c:	00451693          	slli	a3,a0,0x4

  if(write)
    80006520:	0001c797          	auipc	a5,0x1c
    80006524:	81078793          	addi	a5,a5,-2032 # 80021d30 <disk>
    80006528:	00a50713          	addi	a4,a0,10
    8000652c:	0712                	slli	a4,a4,0x4
    8000652e:	973e                	add	a4,a4,a5
    80006530:	01603633          	snez	a2,s6
    80006534:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006536:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    8000653a:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    8000653e:	6398                	ld	a4,0(a5)
    80006540:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006542:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80006546:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006548:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000654a:	6390                	ld	a2,0(a5)
    8000654c:	00d605b3          	add	a1,a2,a3
    80006550:	4741                	li	a4,16
    80006552:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006554:	4805                	li	a6,1
    80006556:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    8000655a:	fa442703          	lw	a4,-92(s0)
    8000655e:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006562:	0712                	slli	a4,a4,0x4
    80006564:	963a                	add	a2,a2,a4
    80006566:	05898593          	addi	a1,s3,88
    8000656a:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    8000656c:	0007b883          	ld	a7,0(a5)
    80006570:	9746                	add	a4,a4,a7
    80006572:	40000613          	li	a2,1024
    80006576:	c710                	sw	a2,8(a4)
  if(write)
    80006578:	001b3613          	seqz	a2,s6
    8000657c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006580:	01066633          	or	a2,a2,a6
    80006584:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80006588:	fa842583          	lw	a1,-88(s0)
    8000658c:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006590:	00250613          	addi	a2,a0,2
    80006594:	0612                	slli	a2,a2,0x4
    80006596:	963e                	add	a2,a2,a5
    80006598:	577d                	li	a4,-1
    8000659a:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000659e:	0592                	slli	a1,a1,0x4
    800065a0:	98ae                	add	a7,a7,a1
    800065a2:	03068713          	addi	a4,a3,48
    800065a6:	973e                	add	a4,a4,a5
    800065a8:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    800065ac:	6398                	ld	a4,0(a5)
    800065ae:	972e                	add	a4,a4,a1
    800065b0:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800065b4:	4689                	li	a3,2
    800065b6:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    800065ba:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800065be:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    800065c2:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800065c6:	6794                	ld	a3,8(a5)
    800065c8:	0026d703          	lhu	a4,2(a3)
    800065cc:	8b1d                	andi	a4,a4,7
    800065ce:	0706                	slli	a4,a4,0x1
    800065d0:	96ba                	add	a3,a3,a4
    800065d2:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800065d6:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800065da:	6798                	ld	a4,8(a5)
    800065dc:	00275783          	lhu	a5,2(a4)
    800065e0:	2785                	addiw	a5,a5,1
    800065e2:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800065e6:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800065ea:	100017b7          	lui	a5,0x10001
    800065ee:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800065f2:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    800065f6:	0001c917          	auipc	s2,0x1c
    800065fa:	86290913          	addi	s2,s2,-1950 # 80021e58 <disk+0x128>
  while(b->disk == 1) {
    800065fe:	84c2                	mv	s1,a6
    80006600:	01079c63          	bne	a5,a6,80006618 <virtio_disk_rw+0x1c0>
    sleep(b, &disk.vdisk_lock);
    80006604:	85ca                	mv	a1,s2
    80006606:	854e                	mv	a0,s3
    80006608:	ffffc097          	auipc	ra,0xffffc
    8000660c:	d12080e7          	jalr	-750(ra) # 8000231a <sleep>
  while(b->disk == 1) {
    80006610:	0049a783          	lw	a5,4(s3)
    80006614:	fe9788e3          	beq	a5,s1,80006604 <virtio_disk_rw+0x1ac>
  }

  disk.info[idx[0]].b = 0;
    80006618:	fa042903          	lw	s2,-96(s0)
    8000661c:	00290713          	addi	a4,s2,2
    80006620:	0712                	slli	a4,a4,0x4
    80006622:	0001b797          	auipc	a5,0x1b
    80006626:	70e78793          	addi	a5,a5,1806 # 80021d30 <disk>
    8000662a:	97ba                	add	a5,a5,a4
    8000662c:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006630:	0001b997          	auipc	s3,0x1b
    80006634:	70098993          	addi	s3,s3,1792 # 80021d30 <disk>
    80006638:	00491713          	slli	a4,s2,0x4
    8000663c:	0009b783          	ld	a5,0(s3)
    80006640:	97ba                	add	a5,a5,a4
    80006642:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006646:	854a                	mv	a0,s2
    80006648:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000664c:	00000097          	auipc	ra,0x0
    80006650:	b8e080e7          	jalr	-1138(ra) # 800061da <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006654:	8885                	andi	s1,s1,1
    80006656:	f0ed                	bnez	s1,80006638 <virtio_disk_rw+0x1e0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006658:	0001c517          	auipc	a0,0x1c
    8000665c:	80050513          	addi	a0,a0,-2048 # 80021e58 <disk+0x128>
    80006660:	ffffa097          	auipc	ra,0xffffa
    80006664:	68e080e7          	jalr	1678(ra) # 80000cee <release>
}
    80006668:	60e6                	ld	ra,88(sp)
    8000666a:	6446                	ld	s0,80(sp)
    8000666c:	64a6                	ld	s1,72(sp)
    8000666e:	6906                	ld	s2,64(sp)
    80006670:	79e2                	ld	s3,56(sp)
    80006672:	7a42                	ld	s4,48(sp)
    80006674:	7aa2                	ld	s5,40(sp)
    80006676:	7b02                	ld	s6,32(sp)
    80006678:	6be2                	ld	s7,24(sp)
    8000667a:	6c42                	ld	s8,16(sp)
    8000667c:	6125                	addi	sp,sp,96
    8000667e:	8082                	ret

0000000080006680 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006680:	1101                	addi	sp,sp,-32
    80006682:	ec06                	sd	ra,24(sp)
    80006684:	e822                	sd	s0,16(sp)
    80006686:	e426                	sd	s1,8(sp)
    80006688:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000668a:	0001b497          	auipc	s1,0x1b
    8000668e:	6a648493          	addi	s1,s1,1702 # 80021d30 <disk>
    80006692:	0001b517          	auipc	a0,0x1b
    80006696:	7c650513          	addi	a0,a0,1990 # 80021e58 <disk+0x128>
    8000669a:	ffffa097          	auipc	ra,0xffffa
    8000669e:	5a4080e7          	jalr	1444(ra) # 80000c3e <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800066a2:	100017b7          	lui	a5,0x10001
    800066a6:	53bc                	lw	a5,96(a5)
    800066a8:	8b8d                	andi	a5,a5,3
    800066aa:	10001737          	lui	a4,0x10001
    800066ae:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800066b0:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800066b4:	689c                	ld	a5,16(s1)
    800066b6:	0204d703          	lhu	a4,32(s1)
    800066ba:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    800066be:	04f70863          	beq	a4,a5,8000670e <virtio_disk_intr+0x8e>
    __sync_synchronize();
    800066c2:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800066c6:	6898                	ld	a4,16(s1)
    800066c8:	0204d783          	lhu	a5,32(s1)
    800066cc:	8b9d                	andi	a5,a5,7
    800066ce:	078e                	slli	a5,a5,0x3
    800066d0:	97ba                	add	a5,a5,a4
    800066d2:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800066d4:	00278713          	addi	a4,a5,2
    800066d8:	0712                	slli	a4,a4,0x4
    800066da:	9726                	add	a4,a4,s1
    800066dc:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800066e0:	e721                	bnez	a4,80006728 <virtio_disk_intr+0xa8>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800066e2:	0789                	addi	a5,a5,2
    800066e4:	0792                	slli	a5,a5,0x4
    800066e6:	97a6                	add	a5,a5,s1
    800066e8:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800066ea:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800066ee:	ffffc097          	auipc	ra,0xffffc
    800066f2:	c90080e7          	jalr	-880(ra) # 8000237e <wakeup>

    disk.used_idx += 1;
    800066f6:	0204d783          	lhu	a5,32(s1)
    800066fa:	2785                	addiw	a5,a5,1
    800066fc:	17c2                	slli	a5,a5,0x30
    800066fe:	93c1                	srli	a5,a5,0x30
    80006700:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006704:	6898                	ld	a4,16(s1)
    80006706:	00275703          	lhu	a4,2(a4)
    8000670a:	faf71ce3          	bne	a4,a5,800066c2 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    8000670e:	0001b517          	auipc	a0,0x1b
    80006712:	74a50513          	addi	a0,a0,1866 # 80021e58 <disk+0x128>
    80006716:	ffffa097          	auipc	ra,0xffffa
    8000671a:	5d8080e7          	jalr	1496(ra) # 80000cee <release>
}
    8000671e:	60e2                	ld	ra,24(sp)
    80006720:	6442                	ld	s0,16(sp)
    80006722:	64a2                	ld	s1,8(sp)
    80006724:	6105                	addi	sp,sp,32
    80006726:	8082                	ret
      panic("virtio_disk_intr status");
    80006728:	00002517          	auipc	a0,0x2
    8000672c:	0d050513          	addi	a0,a0,208 # 800087f8 <etext+0x7f8>
    80006730:	ffffa097          	auipc	ra,0xffffa
    80006734:	e30080e7          	jalr	-464(ra) # 80000560 <panic>
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
