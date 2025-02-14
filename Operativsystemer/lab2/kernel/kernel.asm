
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	b7010113          	addi	sp,sp,-1168 # 80008b70 <stack0>
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
    80000054:	9e078793          	addi	a5,a5,-1568 # 80008a30 <timer_scratch>
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
    80000066:	36e78793          	addi	a5,a5,878 # 800063d0 <timervec>
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
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdbcdf>
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
    80000134:	00003097          	auipc	ra,0x3
    80000138:	898080e7          	jalr	-1896(ra) # 800029cc <either_copyin>
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
    800001a0:	9d450513          	addi	a0,a0,-1580 # 80010b70 <cons>
    800001a4:	00001097          	auipc	ra,0x1
    800001a8:	a9a080e7          	jalr	-1382(ra) # 80000c3e <acquire>
    while (n > 0)
    {
        // wait until interrupt handler has put some
        // input into cons.buffer.
        while (cons.r == cons.w)
    800001ac:	00011497          	auipc	s1,0x11
    800001b0:	9c448493          	addi	s1,s1,-1596 # 80010b70 <cons>
            if (killed(myproc()))
            {
                release(&cons.lock);
                return -1;
            }
            sleep(&cons.r, &cons.lock);
    800001b4:	00011917          	auipc	s2,0x11
    800001b8:	a5490913          	addi	s2,s2,-1452 # 80010c08 <cons+0x98>
    while (n > 0)
    800001bc:	0d305563          	blez	s3,80000286 <consoleread+0x106>
        while (cons.r == cons.w)
    800001c0:	0984a783          	lw	a5,152(s1)
    800001c4:	09c4a703          	lw	a4,156(s1)
    800001c8:	0af71a63          	bne	a4,a5,8000027c <consoleread+0xfc>
            if (killed(myproc()))
    800001cc:	00002097          	auipc	ra,0x2
    800001d0:	bb6080e7          	jalr	-1098(ra) # 80001d82 <myproc>
    800001d4:	00002097          	auipc	ra,0x2
    800001d8:	648080e7          	jalr	1608(ra) # 8000281c <killed>
    800001dc:	e52d                	bnez	a0,80000246 <consoleread+0xc6>
            sleep(&cons.r, &cons.lock);
    800001de:	85a6                	mv	a1,s1
    800001e0:	854a                	mv	a0,s2
    800001e2:	00002097          	auipc	ra,0x2
    800001e6:	392080e7          	jalr	914(ra) # 80002574 <sleep>
        while (cons.r == cons.w)
    800001ea:	0984a783          	lw	a5,152(s1)
    800001ee:	09c4a703          	lw	a4,156(s1)
    800001f2:	fcf70de3          	beq	a4,a5,800001cc <consoleread+0x4c>
    800001f6:	ec5e                	sd	s7,24(sp)
        }

        c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001f8:	00011717          	auipc	a4,0x11
    800001fc:	97870713          	addi	a4,a4,-1672 # 80010b70 <cons>
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
    8000022e:	74c080e7          	jalr	1868(ra) # 80002976 <either_copyout>
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
    8000024a:	92a50513          	addi	a0,a0,-1750 # 80010b70 <cons>
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
    80000274:	98f72c23          	sw	a5,-1640(a4) # 80010c08 <cons+0x98>
    80000278:	6be2                	ld	s7,24(sp)
    8000027a:	a031                	j	80000286 <consoleread+0x106>
    8000027c:	ec5e                	sd	s7,24(sp)
    8000027e:	bfad                	j	800001f8 <consoleread+0x78>
    80000280:	6be2                	ld	s7,24(sp)
    80000282:	a011                	j	80000286 <consoleread+0x106>
    80000284:	6be2                	ld	s7,24(sp)
    release(&cons.lock);
    80000286:	00011517          	auipc	a0,0x11
    8000028a:	8ea50513          	addi	a0,a0,-1814 # 80010b70 <cons>
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
    800002f2:	88250513          	addi	a0,a0,-1918 # 80010b70 <cons>
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
    80000318:	70e080e7          	jalr	1806(ra) # 80002a22 <procdump>
            }
        }
        break;
    }

    release(&cons.lock);
    8000031c:	00011517          	auipc	a0,0x11
    80000320:	85450513          	addi	a0,a0,-1964 # 80010b70 <cons>
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
    80000342:	83270713          	addi	a4,a4,-1998 # 80010b70 <cons>
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
    8000036c:	80878793          	addi	a5,a5,-2040 # 80010b70 <cons>
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
    80000398:	8747a783          	lw	a5,-1932(a5) # 80010c08 <cons+0x98>
    8000039c:	9f1d                	subw	a4,a4,a5
    8000039e:	08000793          	li	a5,128
    800003a2:	f6f71de3          	bne	a4,a5,8000031c <consoleintr+0x3a>
    800003a6:	a0c9                	j	80000468 <consoleintr+0x186>
    800003a8:	e84a                	sd	s2,16(sp)
    800003aa:	e44e                	sd	s3,8(sp)
        while (cons.e != cons.w &&
    800003ac:	00010717          	auipc	a4,0x10
    800003b0:	7c470713          	addi	a4,a4,1988 # 80010b70 <cons>
    800003b4:	0a072783          	lw	a5,160(a4)
    800003b8:	09c72703          	lw	a4,156(a4)
               cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n')
    800003bc:	00010497          	auipc	s1,0x10
    800003c0:	7b448493          	addi	s1,s1,1972 # 80010b70 <cons>
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
    8000040e:	76670713          	addi	a4,a4,1894 # 80010b70 <cons>
    80000412:	0a072783          	lw	a5,160(a4)
    80000416:	09c72703          	lw	a4,156(a4)
    8000041a:	f0f701e3          	beq	a4,a5,8000031c <consoleintr+0x3a>
            cons.e--;
    8000041e:	37fd                	addiw	a5,a5,-1
    80000420:	00010717          	auipc	a4,0x10
    80000424:	7ef72823          	sw	a5,2032(a4) # 80010c10 <cons+0xa0>
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
    8000044a:	72a78793          	addi	a5,a5,1834 # 80010b70 <cons>
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
    8000046c:	7ac7a223          	sw	a2,1956(a5) # 80010c0c <cons+0x9c>
                wakeup(&cons.r);
    80000470:	00010517          	auipc	a0,0x10
    80000474:	79850513          	addi	a0,a0,1944 # 80010c08 <cons+0x98>
    80000478:	00002097          	auipc	ra,0x2
    8000047c:	160080e7          	jalr	352(ra) # 800025d8 <wakeup>
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
    80000496:	6de50513          	addi	a0,a0,1758 # 80010b70 <cons>
    8000049a:	00000097          	auipc	ra,0x0
    8000049e:	710080e7          	jalr	1808(ra) # 80000baa <initlock>

    uartinit();
    800004a2:	00000097          	auipc	ra,0x0
    800004a6:	344080e7          	jalr	836(ra) # 800007e6 <uartinit>

    // connect read and write system calls
    // to consoleread and consolewrite.
    devsw[CONSOLE].read = consoleread;
    800004aa:	00021797          	auipc	a5,0x21
    800004ae:	4de78793          	addi	a5,a5,1246 # 80021988 <devsw>
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
    800004ee:	32e80813          	addi	a6,a6,814 # 80008818 <digits>
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
    80000570:	6c07a223          	sw	zero,1732(a5) # 80010c30 <pr+0x18>
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
    800005a4:	44f72823          	sw	a5,1104(a4) # 800089f0 <panicked>
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
    800005ce:	666dad83          	lw	s11,1638(s11) # 80010c30 <pr+0x18>
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
    80000610:	20ca8a93          	addi	s5,s5,524 # 80008818 <digits>
    switch(c){
    80000614:	07300c13          	li	s8,115
    80000618:	a0b9                	j	80000666 <printf+0xbc>
    acquire(&pr.lock);
    8000061a:	00010517          	auipc	a0,0x10
    8000061e:	5fe50513          	addi	a0,a0,1534 # 80010c18 <pr>
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
    800007a6:	47650513          	addi	a0,a0,1142 # 80010c18 <pr>
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
    800007c2:	45a48493          	addi	s1,s1,1114 # 80010c18 <pr>
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
    8000082c:	41050513          	addi	a0,a0,1040 # 80010c38 <uart_tx_lock>
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
    80000858:	19c7a783          	lw	a5,412(a5) # 800089f0 <panicked>
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
    80000892:	16a7b783          	ld	a5,362(a5) # 800089f8 <uart_tx_r>
    80000896:	00008717          	auipc	a4,0x8
    8000089a:	16a73703          	ld	a4,362(a4) # 80008a00 <uart_tx_w>
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
    800008c0:	37ca8a93          	addi	s5,s5,892 # 80010c38 <uart_tx_lock>
    uart_tx_r += 1;
    800008c4:	00008497          	auipc	s1,0x8
    800008c8:	13448493          	addi	s1,s1,308 # 800089f8 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008cc:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008d0:	00008997          	auipc	s3,0x8
    800008d4:	13098993          	addi	s3,s3,304 # 80008a00 <uart_tx_w>
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
    800008f6:	ce6080e7          	jalr	-794(ra) # 800025d8 <wakeup>
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
    80000934:	30850513          	addi	a0,a0,776 # 80010c38 <uart_tx_lock>
    80000938:	00000097          	auipc	ra,0x0
    8000093c:	306080e7          	jalr	774(ra) # 80000c3e <acquire>
  if(panicked){
    80000940:	00008797          	auipc	a5,0x8
    80000944:	0b07a783          	lw	a5,176(a5) # 800089f0 <panicked>
    80000948:	e7c9                	bnez	a5,800009d2 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000094a:	00008717          	auipc	a4,0x8
    8000094e:	0b673703          	ld	a4,182(a4) # 80008a00 <uart_tx_w>
    80000952:	00008797          	auipc	a5,0x8
    80000956:	0a67b783          	ld	a5,166(a5) # 800089f8 <uart_tx_r>
    8000095a:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000095e:	00010997          	auipc	s3,0x10
    80000962:	2da98993          	addi	s3,s3,730 # 80010c38 <uart_tx_lock>
    80000966:	00008497          	auipc	s1,0x8
    8000096a:	09248493          	addi	s1,s1,146 # 800089f8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000096e:	00008917          	auipc	s2,0x8
    80000972:	09290913          	addi	s2,s2,146 # 80008a00 <uart_tx_w>
    80000976:	00e79f63          	bne	a5,a4,80000994 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000097a:	85ce                	mv	a1,s3
    8000097c:	8526                	mv	a0,s1
    8000097e:	00002097          	auipc	ra,0x2
    80000982:	bf6080e7          	jalr	-1034(ra) # 80002574 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000986:	00093703          	ld	a4,0(s2)
    8000098a:	609c                	ld	a5,0(s1)
    8000098c:	02078793          	addi	a5,a5,32
    80000990:	fee785e3          	beq	a5,a4,8000097a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000994:	00010497          	auipc	s1,0x10
    80000998:	2a448493          	addi	s1,s1,676 # 80010c38 <uart_tx_lock>
    8000099c:	01f77793          	andi	a5,a4,31
    800009a0:	97a6                	add	a5,a5,s1
    800009a2:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009a6:	0705                	addi	a4,a4,1
    800009a8:	00008797          	auipc	a5,0x8
    800009ac:	04e7bc23          	sd	a4,88(a5) # 80008a00 <uart_tx_w>
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
    80000a22:	21a48493          	addi	s1,s1,538 # 80010c38 <uart_tx_lock>
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
    80000a60:	00022797          	auipc	a5,0x22
    80000a64:	0c078793          	addi	a5,a5,192 # 80022b20 <end>
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
    80000a84:	1f090913          	addi	s2,s2,496 # 80010c70 <kmem>
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
    80000b22:	15250513          	addi	a0,a0,338 # 80010c70 <kmem>
    80000b26:	00000097          	auipc	ra,0x0
    80000b2a:	084080e7          	jalr	132(ra) # 80000baa <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b2e:	45c5                	li	a1,17
    80000b30:	05ee                	slli	a1,a1,0x1b
    80000b32:	00022517          	auipc	a0,0x22
    80000b36:	fee50513          	addi	a0,a0,-18 # 80022b20 <end>
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
    80000b58:	11c48493          	addi	s1,s1,284 # 80010c70 <kmem>
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
    80000b70:	10450513          	addi	a0,a0,260 # 80010c70 <kmem>
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
    80000b9c:	0d850513          	addi	a0,a0,216 # 80010c70 <kmem>
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
    80000bdc:	18a080e7          	jalr	394(ra) # 80001d62 <mycpu>
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
    80000c0e:	158080e7          	jalr	344(ra) # 80001d62 <mycpu>
    80000c12:	5d3c                	lw	a5,120(a0)
    80000c14:	cf89                	beqz	a5,80000c2e <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c16:	00001097          	auipc	ra,0x1
    80000c1a:	14c080e7          	jalr	332(ra) # 80001d62 <mycpu>
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
    80000c32:	134080e7          	jalr	308(ra) # 80001d62 <mycpu>
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
    80000c72:	0f4080e7          	jalr	244(ra) # 80001d62 <mycpu>
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
    80000c9e:	0c8080e7          	jalr	200(ra) # 80001d62 <mycpu>
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
    80000db4:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdc4e1>
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
    80000efc:	e56080e7          	jalr	-426(ra) # 80001d4e <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000f00:	00008717          	auipc	a4,0x8
    80000f04:	b0870713          	addi	a4,a4,-1272 # 80008a08 <started>
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
    80000f18:	e3a080e7          	jalr	-454(ra) # 80001d4e <cpuid>
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
    80000f3a:	d72080e7          	jalr	-654(ra) # 80002ca8 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f3e:	00005097          	auipc	ra,0x5
    80000f42:	4d6080e7          	jalr	1238(ra) # 80006414 <plicinithart>
  }

  scheduler();        
    80000f46:	00001097          	auipc	ra,0x1
    80000f4a:	4e6080e7          	jalr	1254(ra) # 8000242c <scheduler>
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
    80000faa:	c84080e7          	jalr	-892(ra) # 80001c2a <procinit>
    trapinit();      // trap vectors
    80000fae:	00002097          	auipc	ra,0x2
    80000fb2:	cd2080e7          	jalr	-814(ra) # 80002c80 <trapinit>
    trapinithart();  // install kernel trap vector
    80000fb6:	00002097          	auipc	ra,0x2
    80000fba:	cf2080e7          	jalr	-782(ra) # 80002ca8 <trapinithart>
    plicinit();      // set up interrupt controller
    80000fbe:	00005097          	auipc	ra,0x5
    80000fc2:	43c080e7          	jalr	1084(ra) # 800063fa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000fc6:	00005097          	auipc	ra,0x5
    80000fca:	44e080e7          	jalr	1102(ra) # 80006414 <plicinithart>
    binit();         // buffer cache
    80000fce:	00002097          	auipc	ra,0x2
    80000fd2:	4ce080e7          	jalr	1230(ra) # 8000349c <binit>
    iinit();         // inode table
    80000fd6:	00003097          	auipc	ra,0x3
    80000fda:	b5e080e7          	jalr	-1186(ra) # 80003b34 <iinit>
    fileinit();      // file table
    80000fde:	00004097          	auipc	ra,0x4
    80000fe2:	b30080e7          	jalr	-1232(ra) # 80004b0e <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000fe6:	00005097          	auipc	ra,0x5
    80000fea:	536080e7          	jalr	1334(ra) # 8000651c <virtio_disk_init>
    userinit();      // first user process
    80000fee:	00001097          	auipc	ra,0x1
    80000ff2:	084080e7          	jalr	132(ra) # 80002072 <userinit>
    __sync_synchronize();
    80000ff6:	0330000f          	fence	rw,rw
    started = 1;
    80000ffa:	4785                	li	a5,1
    80000ffc:	00008717          	auipc	a4,0x8
    80001000:	a0f72623          	sw	a5,-1524(a4) # 80008a08 <started>
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
    80001016:	9fe7b783          	ld	a5,-1538(a5) # 80008a10 <kernel_pagetable>
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
    800012aa:	00001097          	auipc	ra,0x1
    800012ae:	8d6080e7          	jalr	-1834(ra) # 80001b80 <proc_mapstacks>
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
    800012d4:	74a7b023          	sd	a0,1856(a5) # 80008a10 <kernel_pagetable>
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
    800018ac:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdc4e0>
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
    800018ea:	3aaa8a93          	addi	s5,s5,938 # 80010c90 <cpus>
    800018ee:	00779713          	slli	a4,a5,0x7
    800018f2:	00ea86b3          	add	a3,s5,a4
    800018f6:	0006b023          	sd	zero,0(a3) # fffffffffffff000 <end+0xffffffff7ffdc4e0>
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
    8000190a:	00010497          	auipc	s1,0x10
    8000190e:	03648493          	addi	s1,s1,54 # 80011940 <proc>
        if (p->state == RUNNABLE)
    80001912:	498d                	li	s3,3
            p->state = RUNNING;
    80001914:	4b11                	li	s6,4
            c->proc = p;
    80001916:	079e                	slli	a5,a5,0x7
    80001918:	0000fa17          	auipc	s4,0xf
    8000191c:	378a0a13          	addi	s4,s4,888 # 80010c90 <cpus>
    80001920:	9a3e                	add	s4,s4,a5
    for (p = proc; p < &proc[NPROC]; p++)
    80001922:	00016917          	auipc	s2,0x16
    80001926:	e1e90913          	addi	s2,s2,-482 # 80017740 <tickslock>
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
    80001936:	17848493          	addi	s1,s1,376
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
    80001960:	2ba080e7          	jalr	698(ra) # 80002c16 <swtch>
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

000000008000197e <mlfq_enqueue>:
void mlfq_enqueue(struct proc *p) {
    8000197e:	7139                	addi	sp,sp,-64
    80001980:	fc06                	sd	ra,56(sp)
    80001982:	f822                	sd	s0,48(sp)
    80001984:	f426                	sd	s1,40(sp)
    80001986:	f04a                	sd	s2,32(sp)
    80001988:	ec4e                	sd	s3,24(sp)
    8000198a:	e852                	sd	s4,16(sp)
    8000198c:	e456                	sd	s5,8(sp)
    8000198e:	0080                	addi	s0,sp,64
    80001990:	8aaa                	mv	s5,a0
    int level = p->priority;
    80001992:	16852a03          	lw	s4,360(a0)
    acquire(&mlfq[level].lock);
    80001996:	004a1913          	slli	s2,s4,0x4
    8000199a:	014904b3          	add	s1,s2,s4
    8000199e:	0496                	slli	s1,s1,0x5
    800019a0:	20848493          	addi	s1,s1,520
    800019a4:	0000f997          	auipc	s3,0xf
    800019a8:	71c98993          	addi	s3,s3,1820 # 800110c0 <mlfq>
    800019ac:	94ce                	add	s1,s1,s3
    800019ae:	8526                	mv	a0,s1
    800019b0:	fffff097          	auipc	ra,0xfffff
    800019b4:	28e080e7          	jalr	654(ra) # 80000c3e <acquire>
    mlfq[level].queue[mlfq[level].rear] = p;
    800019b8:	014907b3          	add	a5,s2,s4
    800019bc:	0796                	slli	a5,a5,0x5
    800019be:	97ce                	add	a5,a5,s3
    800019c0:	2047a783          	lw	a5,516(a5)
    800019c4:	01490733          	add	a4,s2,s4
    800019c8:	070a                	slli	a4,a4,0x2
    800019ca:	973e                	add	a4,a4,a5
    800019cc:	070e                	slli	a4,a4,0x3
    800019ce:	974e                	add	a4,a4,s3
    800019d0:	01573023          	sd	s5,0(a4)
    mlfq[level].rear = (mlfq[level].rear + 1) % NPROC;
    800019d4:	9952                	add	s2,s2,s4
    800019d6:	0916                	slli	s2,s2,0x5
    800019d8:	99ca                	add	s3,s3,s2
    800019da:	2785                	addiw	a5,a5,1
    800019dc:	41f7d71b          	sraiw	a4,a5,0x1f
    800019e0:	01a7571b          	srliw	a4,a4,0x1a
    800019e4:	9fb9                	addw	a5,a5,a4
    800019e6:	03f7f793          	andi	a5,a5,63
    800019ea:	9f99                	subw	a5,a5,a4
    800019ec:	20f9a223          	sw	a5,516(s3)
    release(&mlfq[level].lock);
    800019f0:	8526                	mv	a0,s1
    800019f2:	fffff097          	auipc	ra,0xfffff
    800019f6:	2fc080e7          	jalr	764(ra) # 80000cee <release>
}
    800019fa:	70e2                	ld	ra,56(sp)
    800019fc:	7442                	ld	s0,48(sp)
    800019fe:	74a2                	ld	s1,40(sp)
    80001a00:	7902                	ld	s2,32(sp)
    80001a02:	69e2                	ld	s3,24(sp)
    80001a04:	6a42                	ld	s4,16(sp)
    80001a06:	6aa2                	ld	s5,8(sp)
    80001a08:	6121                	addi	sp,sp,64
    80001a0a:	8082                	ret

0000000080001a0c <mlfq_dequeue>:
struct proc* mlfq_dequeue(int level) {
    80001a0c:	7179                	addi	sp,sp,-48
    80001a0e:	f406                	sd	ra,40(sp)
    80001a10:	f022                	sd	s0,32(sp)
    80001a12:	ec26                	sd	s1,24(sp)
    80001a14:	e84a                	sd	s2,16(sp)
    80001a16:	e44e                	sd	s3,8(sp)
    80001a18:	e052                	sd	s4,0(sp)
    80001a1a:	1800                	addi	s0,sp,48
    80001a1c:	892a                	mv	s2,a0
    acquire(&mlfq[level].lock);
    80001a1e:	00451993          	slli	s3,a0,0x4
    80001a22:	00a984b3          	add	s1,s3,a0
    80001a26:	0496                	slli	s1,s1,0x5
    80001a28:	20848493          	addi	s1,s1,520
    80001a2c:	0000fa17          	auipc	s4,0xf
    80001a30:	694a0a13          	addi	s4,s4,1684 # 800110c0 <mlfq>
    80001a34:	94d2                	add	s1,s1,s4
    80001a36:	8526                	mv	a0,s1
    80001a38:	fffff097          	auipc	ra,0xfffff
    80001a3c:	206080e7          	jalr	518(ra) # 80000c3e <acquire>
    if(mlfq[level].front == mlfq[level].rear) {
    80001a40:	99ca                	add	s3,s3,s2
    80001a42:	0996                	slli	s3,s3,0x5
    80001a44:	9a4e                	add	s4,s4,s3
    80001a46:	200a2783          	lw	a5,512(s4)
    80001a4a:	204a2703          	lw	a4,516(s4)
    80001a4e:	04f70c63          	beq	a4,a5,80001aa6 <mlfq_dequeue+0x9a>
    struct proc *p = mlfq[level].queue[mlfq[level].front];
    80001a52:	0000f617          	auipc	a2,0xf
    80001a56:	66e60613          	addi	a2,a2,1646 # 800110c0 <mlfq>
    80001a5a:	00491693          	slli	a3,s2,0x4
    80001a5e:	01268733          	add	a4,a3,s2
    80001a62:	070a                	slli	a4,a4,0x2
    80001a64:	973e                	add	a4,a4,a5
    80001a66:	070e                	slli	a4,a4,0x3
    80001a68:	9732                	add	a4,a4,a2
    80001a6a:	00073983          	ld	s3,0(a4)
    mlfq[level].front = (mlfq[level].front + 1) % NPROC;
    80001a6e:	96ca                	add	a3,a3,s2
    80001a70:	0696                	slli	a3,a3,0x5
    80001a72:	9636                	add	a2,a2,a3
    80001a74:	2785                	addiw	a5,a5,1
    80001a76:	41f7d71b          	sraiw	a4,a5,0x1f
    80001a7a:	01a7571b          	srliw	a4,a4,0x1a
    80001a7e:	9fb9                	addw	a5,a5,a4
    80001a80:	03f7f793          	andi	a5,a5,63
    80001a84:	9f99                	subw	a5,a5,a4
    80001a86:	20f62023          	sw	a5,512(a2)
    release(&mlfq[level].lock);
    80001a8a:	8526                	mv	a0,s1
    80001a8c:	fffff097          	auipc	ra,0xfffff
    80001a90:	262080e7          	jalr	610(ra) # 80000cee <release>
}
    80001a94:	854e                	mv	a0,s3
    80001a96:	70a2                	ld	ra,40(sp)
    80001a98:	7402                	ld	s0,32(sp)
    80001a9a:	64e2                	ld	s1,24(sp)
    80001a9c:	6942                	ld	s2,16(sp)
    80001a9e:	69a2                	ld	s3,8(sp)
    80001aa0:	6a02                	ld	s4,0(sp)
    80001aa2:	6145                	addi	sp,sp,48
    80001aa4:	8082                	ret
        release(&mlfq[level].lock);
    80001aa6:	8526                	mv	a0,s1
    80001aa8:	fffff097          	auipc	ra,0xfffff
    80001aac:	246080e7          	jalr	582(ra) # 80000cee <release>
        return 0;
    80001ab0:	4981                	li	s3,0
    80001ab2:	b7cd                	j	80001a94 <mlfq_dequeue+0x88>

0000000080001ab4 <mlfq_scheduler>:


void mlfq_scheduler(void) {
    80001ab4:	715d                	addi	sp,sp,-80
    80001ab6:	e486                	sd	ra,72(sp)
    80001ab8:	e0a2                	sd	s0,64(sp)
    80001aba:	fc26                	sd	s1,56(sp)
    80001abc:	f84a                	sd	s2,48(sp)
    80001abe:	f44e                	sd	s3,40(sp)
    80001ac0:	f052                	sd	s4,32(sp)
    80001ac2:	ec56                	sd	s5,24(sp)
    80001ac4:	e85a                	sd	s6,16(sp)
    80001ac6:	e45e                	sd	s7,8(sp)
    80001ac8:	e062                	sd	s8,0(sp)
    80001aca:	0880                	addi	s0,sp,80
  asm volatile("mv %0, tp" : "=r" (x) );
    80001acc:	8b12                	mv	s6,tp
    int id = r_tp();
    80001ace:	2b01                	sext.w	s6,s6
    struct proc *p;
    struct cpu *c = mycpu();
    c->proc = 0;
    80001ad0:	007b1713          	slli	a4,s6,0x7
    80001ad4:	0000f797          	auipc	a5,0xf
    80001ad8:	1bc78793          	addi	a5,a5,444 # 80010c90 <cpus>
    80001adc:	97ba                	add	a5,a5,a4
    80001ade:	0007b023          	sd	zero,0(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ae2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ae6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001aea:	10079073          	csrw	sstatus,a5
    while(1) {
        for(int level = 0; level < NQUEUES; level++) {
            p = mlfq_dequeue(level);
            if(p != 0) {
                acquire(&p->lock);
                if(p->state == RUNNABLE) {
    80001aee:	4a0d                	li	s4,3
        for(int level = 0; level < NQUEUES; level++) {
    80001af0:	4991                	li	s3,4
                    p->state = RUNNING;
                    c->proc = p;
    80001af2:	0000fc17          	auipc	s8,0xf
    80001af6:	19ec0c13          	addi	s8,s8,414 # 80010c90 <cpus>
    80001afa:	8b3a                	mv	s6,a4
                    p->ticks_left = TICKS_PER_LEVEL;

                    swtch(&c->context, &p->context);
    80001afc:	00870b93          	addi	s7,a4,8
    80001b00:	9be2                	add	s7,s7,s8
        for(int level = 0; level < NQUEUES; level++) {
    80001b02:	4901                	li	s2,0
    80001b04:	a831                	j	80001b20 <mlfq_scheduler+0x6c>

                    if(p->state == RUNNABLE) {
                        if(p->ticks_left <= 0 && p->priority < NQUEUES-1) {
                            p->priority++;
                        }
                        mlfq_enqueue(p);
    80001b06:	8526                	mv	a0,s1
    80001b08:	00000097          	auipc	ra,0x0
    80001b0c:	e76080e7          	jalr	-394(ra) # 8000197e <mlfq_enqueue>
                    }
                }
                release(&p->lock);
    80001b10:	8526                	mv	a0,s1
    80001b12:	fffff097          	auipc	ra,0xfffff
    80001b16:	1dc080e7          	jalr	476(ra) # 80000cee <release>
        for(int level = 0; level < NQUEUES; level++) {
    80001b1a:	2905                	addiw	s2,s2,1
    80001b1c:	ff3903e3          	beq	s2,s3,80001b02 <mlfq_scheduler+0x4e>
            p = mlfq_dequeue(level);
    80001b20:	854a                	mv	a0,s2
    80001b22:	00000097          	auipc	ra,0x0
    80001b26:	eea080e7          	jalr	-278(ra) # 80001a0c <mlfq_dequeue>
    80001b2a:	84aa                	mv	s1,a0
            if(p != 0) {
    80001b2c:	d57d                	beqz	a0,80001b1a <mlfq_scheduler+0x66>
                acquire(&p->lock);
    80001b2e:	fffff097          	auipc	ra,0xfffff
    80001b32:	110080e7          	jalr	272(ra) # 80000c3e <acquire>
                if(p->state == RUNNABLE) {
    80001b36:	4c9c                	lw	a5,24(s1)
    80001b38:	fd479ce3          	bne	a5,s4,80001b10 <mlfq_scheduler+0x5c>
                    p->state = RUNNING;
    80001b3c:	0134ac23          	sw	s3,24(s1)
                    c->proc = p;
    80001b40:	016c0ab3          	add	s5,s8,s6
    80001b44:	009ab023          	sd	s1,0(s5)
                    p->ticks_left = TICKS_PER_LEVEL;
    80001b48:	47a9                	li	a5,10
    80001b4a:	16f4a623          	sw	a5,364(s1)
                    swtch(&c->context, &p->context);
    80001b4e:	06048593          	addi	a1,s1,96
    80001b52:	855e                	mv	a0,s7
    80001b54:	00001097          	auipc	ra,0x1
    80001b58:	0c2080e7          	jalr	194(ra) # 80002c16 <swtch>
                    c->proc = 0;
    80001b5c:	000ab023          	sd	zero,0(s5)
                    if(p->state == RUNNABLE) {
    80001b60:	4c9c                	lw	a5,24(s1)
    80001b62:	fb4797e3          	bne	a5,s4,80001b10 <mlfq_scheduler+0x5c>
                        if(p->ticks_left <= 0 && p->priority < NQUEUES-1) {
    80001b66:	16c4a783          	lw	a5,364(s1)
    80001b6a:	f8f04ee3          	bgtz	a5,80001b06 <mlfq_scheduler+0x52>
    80001b6e:	1684a783          	lw	a5,360(s1)
    80001b72:	4709                	li	a4,2
    80001b74:	f8f749e3          	blt	a4,a5,80001b06 <mlfq_scheduler+0x52>
                            p->priority++;
    80001b78:	2785                	addiw	a5,a5,1
    80001b7a:	16f4a423          	sw	a5,360(s1)
    80001b7e:	b761                	j	80001b06 <mlfq_scheduler+0x52>

0000000080001b80 <proc_mapstacks>:
{
    80001b80:	715d                	addi	sp,sp,-80
    80001b82:	e486                	sd	ra,72(sp)
    80001b84:	e0a2                	sd	s0,64(sp)
    80001b86:	fc26                	sd	s1,56(sp)
    80001b88:	f84a                	sd	s2,48(sp)
    80001b8a:	f44e                	sd	s3,40(sp)
    80001b8c:	f052                	sd	s4,32(sp)
    80001b8e:	ec56                	sd	s5,24(sp)
    80001b90:	e85a                	sd	s6,16(sp)
    80001b92:	e45e                	sd	s7,8(sp)
    80001b94:	e062                	sd	s8,0(sp)
    80001b96:	0880                	addi	s0,sp,80
    80001b98:	8a2a                	mv	s4,a0
    for (p = proc; p < &proc[NPROC]; p++)
    80001b9a:	00010497          	auipc	s1,0x10
    80001b9e:	da648493          	addi	s1,s1,-602 # 80011940 <proc>
        uint64 va = KSTACK((int)(p - proc));
    80001ba2:	8c26                	mv	s8,s1
    80001ba4:	677d47b7          	lui	a5,0x677d4
    80001ba8:	6cf78793          	addi	a5,a5,1743 # 677d46cf <_entry-0x1882b931>
    80001bac:	51b3c937          	lui	s2,0x51b3c
    80001bb0:	ea390913          	addi	s2,s2,-349 # 51b3bea3 <_entry-0x2e4c415d>
    80001bb4:	1902                	slli	s2,s2,0x20
    80001bb6:	993e                	add	s2,s2,a5
    80001bb8:	040009b7          	lui	s3,0x4000
    80001bbc:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001bbe:	09b2                	slli	s3,s3,0xc
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001bc0:	4b99                	li	s7,6
    80001bc2:	6b05                	lui	s6,0x1
    for (p = proc; p < &proc[NPROC]; p++)
    80001bc4:	00016a97          	auipc	s5,0x16
    80001bc8:	b7ca8a93          	addi	s5,s5,-1156 # 80017740 <tickslock>
        char *pa = kalloc();
    80001bcc:	fffff097          	auipc	ra,0xfffff
    80001bd0:	f7e080e7          	jalr	-130(ra) # 80000b4a <kalloc>
    80001bd4:	862a                	mv	a2,a0
        if (pa == 0)
    80001bd6:	c131                	beqz	a0,80001c1a <proc_mapstacks+0x9a>
        uint64 va = KSTACK((int)(p - proc));
    80001bd8:	418485b3          	sub	a1,s1,s8
    80001bdc:	858d                	srai	a1,a1,0x3
    80001bde:	032585b3          	mul	a1,a1,s2
    80001be2:	2585                	addiw	a1,a1,1
    80001be4:	00d5959b          	slliw	a1,a1,0xd
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001be8:	875e                	mv	a4,s7
    80001bea:	86da                	mv	a3,s6
    80001bec:	40b985b3          	sub	a1,s3,a1
    80001bf0:	8552                	mv	a0,s4
    80001bf2:	fffff097          	auipc	ra,0xfffff
    80001bf6:	5ce080e7          	jalr	1486(ra) # 800011c0 <kvmmap>
    for (p = proc; p < &proc[NPROC]; p++)
    80001bfa:	17848493          	addi	s1,s1,376
    80001bfe:	fd5497e3          	bne	s1,s5,80001bcc <proc_mapstacks+0x4c>
}
    80001c02:	60a6                	ld	ra,72(sp)
    80001c04:	6406                	ld	s0,64(sp)
    80001c06:	74e2                	ld	s1,56(sp)
    80001c08:	7942                	ld	s2,48(sp)
    80001c0a:	79a2                	ld	s3,40(sp)
    80001c0c:	7a02                	ld	s4,32(sp)
    80001c0e:	6ae2                	ld	s5,24(sp)
    80001c10:	6b42                	ld	s6,16(sp)
    80001c12:	6ba2                	ld	s7,8(sp)
    80001c14:	6c02                	ld	s8,0(sp)
    80001c16:	6161                	addi	sp,sp,80
    80001c18:	8082                	ret
            panic("kalloc");
    80001c1a:	00006517          	auipc	a0,0x6
    80001c1e:	59e50513          	addi	a0,a0,1438 # 800081b8 <etext+0x1b8>
    80001c22:	fffff097          	auipc	ra,0xfffff
    80001c26:	93e080e7          	jalr	-1730(ra) # 80000560 <panic>

0000000080001c2a <procinit>:
{
    80001c2a:	7139                	addi	sp,sp,-64
    80001c2c:	fc06                	sd	ra,56(sp)
    80001c2e:	f822                	sd	s0,48(sp)
    80001c30:	f426                	sd	s1,40(sp)
    80001c32:	f04a                	sd	s2,32(sp)
    80001c34:	ec4e                	sd	s3,24(sp)
    80001c36:	e852                	sd	s4,16(sp)
    80001c38:	e456                	sd	s5,8(sp)
    80001c3a:	e05a                	sd	s6,0(sp)
    80001c3c:	0080                	addi	s0,sp,64
    initlock(&pid_lock, "nextpid");
    80001c3e:	00006597          	auipc	a1,0x6
    80001c42:	58258593          	addi	a1,a1,1410 # 800081c0 <etext+0x1c0>
    80001c46:	0000f517          	auipc	a0,0xf
    80001c4a:	44a50513          	addi	a0,a0,1098 # 80011090 <pid_lock>
    80001c4e:	fffff097          	auipc	ra,0xfffff
    80001c52:	f5c080e7          	jalr	-164(ra) # 80000baa <initlock>
    initlock(&wait_lock, "wait_lock");
    80001c56:	00006597          	auipc	a1,0x6
    80001c5a:	57258593          	addi	a1,a1,1394 # 800081c8 <etext+0x1c8>
    80001c5e:	0000f517          	auipc	a0,0xf
    80001c62:	44a50513          	addi	a0,a0,1098 # 800110a8 <wait_lock>
    80001c66:	fffff097          	auipc	ra,0xfffff
    80001c6a:	f44080e7          	jalr	-188(ra) # 80000baa <initlock>
    for(int i = 0; i < NQUEUES; i++) {
    80001c6e:	0000f497          	auipc	s1,0xf
    80001c72:	65a48493          	addi	s1,s1,1626 # 800112c8 <mlfq+0x208>
    80001c76:	00010997          	auipc	s3,0x10
    80001c7a:	ed298993          	addi	s3,s3,-302 # 80011b48 <proc+0x208>
        initlock(&mlfq[i].lock, "mlfq");
    80001c7e:	00006917          	auipc	s2,0x6
    80001c82:	55a90913          	addi	s2,s2,1370 # 800081d8 <etext+0x1d8>
    80001c86:	85ca                	mv	a1,s2
    80001c88:	8526                	mv	a0,s1
    80001c8a:	fffff097          	auipc	ra,0xfffff
    80001c8e:	f20080e7          	jalr	-224(ra) # 80000baa <initlock>
        mlfq[i].front = 0;
    80001c92:	fe04ac23          	sw	zero,-8(s1)
        mlfq[i].rear = 0;
    80001c96:	fe04ae23          	sw	zero,-4(s1)
    for(int i = 0; i < NQUEUES; i++) {
    80001c9a:	22048493          	addi	s1,s1,544
    80001c9e:	ff3494e3          	bne	s1,s3,80001c86 <procinit+0x5c>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001ca2:	00010497          	auipc	s1,0x10
    80001ca6:	c9e48493          	addi	s1,s1,-866 # 80011940 <proc>
        initlock(&p->lock, "proc");
    80001caa:	00006b17          	auipc	s6,0x6
    80001cae:	536b0b13          	addi	s6,s6,1334 # 800081e0 <etext+0x1e0>
        p->kstack = KSTACK((int)(p - proc));
    80001cb2:	8aa6                	mv	s5,s1
    80001cb4:	677d47b7          	lui	a5,0x677d4
    80001cb8:	6cf78793          	addi	a5,a5,1743 # 677d46cf <_entry-0x1882b931>
    80001cbc:	51b3c937          	lui	s2,0x51b3c
    80001cc0:	ea390913          	addi	s2,s2,-349 # 51b3bea3 <_entry-0x2e4c415d>
    80001cc4:	1902                	slli	s2,s2,0x20
    80001cc6:	993e                	add	s2,s2,a5
    80001cc8:	040009b7          	lui	s3,0x4000
    80001ccc:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001cce:	09b2                	slli	s3,s3,0xc
    for(p = proc; p < &proc[NPROC]; p++) {
    80001cd0:	00016a17          	auipc	s4,0x16
    80001cd4:	a70a0a13          	addi	s4,s4,-1424 # 80017740 <tickslock>
        initlock(&p->lock, "proc");
    80001cd8:	85da                	mv	a1,s6
    80001cda:	8526                	mv	a0,s1
    80001cdc:	fffff097          	auipc	ra,0xfffff
    80001ce0:	ece080e7          	jalr	-306(ra) # 80000baa <initlock>
        p->state = UNUSED;
    80001ce4:	0004ac23          	sw	zero,24(s1)
        p->kstack = KSTACK((int)(p - proc));
    80001ce8:	415487b3          	sub	a5,s1,s5
    80001cec:	878d                	srai	a5,a5,0x3
    80001cee:	032787b3          	mul	a5,a5,s2
    80001cf2:	2785                	addiw	a5,a5,1
    80001cf4:	00d7979b          	slliw	a5,a5,0xd
    80001cf8:	40f987b3          	sub	a5,s3,a5
    80001cfc:	e0bc                	sd	a5,64(s1)
        p->priority = 0;
    80001cfe:	1604a423          	sw	zero,360(s1)
        p->ticks_left = 0;
    80001d02:	1604a623          	sw	zero,364(s1)
        p->queue_ticks = 0;
    80001d06:	1604a823          	sw	zero,368(s1)
    for(p = proc; p < &proc[NPROC]; p++) {
    80001d0a:	17848493          	addi	s1,s1,376
    80001d0e:	fd4495e3          	bne	s1,s4,80001cd8 <procinit+0xae>
}
    80001d12:	70e2                	ld	ra,56(sp)
    80001d14:	7442                	ld	s0,48(sp)
    80001d16:	74a2                	ld	s1,40(sp)
    80001d18:	7902                	ld	s2,32(sp)
    80001d1a:	69e2                	ld	s3,24(sp)
    80001d1c:	6a42                	ld	s4,16(sp)
    80001d1e:	6aa2                	ld	s5,8(sp)
    80001d20:	6b02                	ld	s6,0(sp)
    80001d22:	6121                	addi	sp,sp,64
    80001d24:	8082                	ret

0000000080001d26 <copy_array>:
{
    80001d26:	1141                	addi	sp,sp,-16
    80001d28:	e406                	sd	ra,8(sp)
    80001d2a:	e022                	sd	s0,0(sp)
    80001d2c:	0800                	addi	s0,sp,16
    for (int i = 0; i < len; i++)
    80001d2e:	00c05c63          	blez	a2,80001d46 <copy_array+0x20>
    80001d32:	87aa                	mv	a5,a0
    80001d34:	9532                	add	a0,a0,a2
        dst[i] = src[i];
    80001d36:	0007c703          	lbu	a4,0(a5)
    80001d3a:	00e58023          	sb	a4,0(a1)
    for (int i = 0; i < len; i++)
    80001d3e:	0785                	addi	a5,a5,1
    80001d40:	0585                	addi	a1,a1,1
    80001d42:	fea79ae3          	bne	a5,a0,80001d36 <copy_array+0x10>
}
    80001d46:	60a2                	ld	ra,8(sp)
    80001d48:	6402                	ld	s0,0(sp)
    80001d4a:	0141                	addi	sp,sp,16
    80001d4c:	8082                	ret

0000000080001d4e <cpuid>:
{
    80001d4e:	1141                	addi	sp,sp,-16
    80001d50:	e406                	sd	ra,8(sp)
    80001d52:	e022                	sd	s0,0(sp)
    80001d54:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d56:	8512                	mv	a0,tp
}
    80001d58:	2501                	sext.w	a0,a0
    80001d5a:	60a2                	ld	ra,8(sp)
    80001d5c:	6402                	ld	s0,0(sp)
    80001d5e:	0141                	addi	sp,sp,16
    80001d60:	8082                	ret

0000000080001d62 <mycpu>:
{
    80001d62:	1141                	addi	sp,sp,-16
    80001d64:	e406                	sd	ra,8(sp)
    80001d66:	e022                	sd	s0,0(sp)
    80001d68:	0800                	addi	s0,sp,16
    80001d6a:	8792                	mv	a5,tp
    struct cpu *c = &cpus[id];
    80001d6c:	2781                	sext.w	a5,a5
    80001d6e:	079e                	slli	a5,a5,0x7
}
    80001d70:	0000f517          	auipc	a0,0xf
    80001d74:	f2050513          	addi	a0,a0,-224 # 80010c90 <cpus>
    80001d78:	953e                	add	a0,a0,a5
    80001d7a:	60a2                	ld	ra,8(sp)
    80001d7c:	6402                	ld	s0,0(sp)
    80001d7e:	0141                	addi	sp,sp,16
    80001d80:	8082                	ret

0000000080001d82 <myproc>:
{
    80001d82:	1101                	addi	sp,sp,-32
    80001d84:	ec06                	sd	ra,24(sp)
    80001d86:	e822                	sd	s0,16(sp)
    80001d88:	e426                	sd	s1,8(sp)
    80001d8a:	1000                	addi	s0,sp,32
    push_off();
    80001d8c:	fffff097          	auipc	ra,0xfffff
    80001d90:	e66080e7          	jalr	-410(ra) # 80000bf2 <push_off>
    80001d94:	8792                	mv	a5,tp
    struct proc *p = c->proc;
    80001d96:	2781                	sext.w	a5,a5
    80001d98:	079e                	slli	a5,a5,0x7
    80001d9a:	0000f717          	auipc	a4,0xf
    80001d9e:	ef670713          	addi	a4,a4,-266 # 80010c90 <cpus>
    80001da2:	97ba                	add	a5,a5,a4
    80001da4:	6384                	ld	s1,0(a5)
    pop_off();
    80001da6:	fffff097          	auipc	ra,0xfffff
    80001daa:	eec080e7          	jalr	-276(ra) # 80000c92 <pop_off>
}
    80001dae:	8526                	mv	a0,s1
    80001db0:	60e2                	ld	ra,24(sp)
    80001db2:	6442                	ld	s0,16(sp)
    80001db4:	64a2                	ld	s1,8(sp)
    80001db6:	6105                	addi	sp,sp,32
    80001db8:	8082                	ret

0000000080001dba <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80001dba:	1141                	addi	sp,sp,-16
    80001dbc:	e406                	sd	ra,8(sp)
    80001dbe:	e022                	sd	s0,0(sp)
    80001dc0:	0800                	addi	s0,sp,16
    static int first = 1;

    // Still holding p->lock from scheduler.
    release(&myproc()->lock);
    80001dc2:	00000097          	auipc	ra,0x0
    80001dc6:	fc0080e7          	jalr	-64(ra) # 80001d82 <myproc>
    80001dca:	fffff097          	auipc	ra,0xfffff
    80001dce:	f24080e7          	jalr	-220(ra) # 80000cee <release>

    if (first)
    80001dd2:	00007797          	auipc	a5,0x7
    80001dd6:	b7e7a783          	lw	a5,-1154(a5) # 80008950 <first.1>
    80001dda:	eb89                	bnez	a5,80001dec <forkret+0x32>
        // be run from main().
        first = 0;
        fsinit(ROOTDEV);
    }

    usertrapret();
    80001ddc:	00001097          	auipc	ra,0x1
    80001de0:	ee8080e7          	jalr	-280(ra) # 80002cc4 <usertrapret>
}
    80001de4:	60a2                	ld	ra,8(sp)
    80001de6:	6402                	ld	s0,0(sp)
    80001de8:	0141                	addi	sp,sp,16
    80001dea:	8082                	ret
        first = 0;
    80001dec:	00007797          	auipc	a5,0x7
    80001df0:	b607a223          	sw	zero,-1180(a5) # 80008950 <first.1>
        fsinit(ROOTDEV);
    80001df4:	4505                	li	a0,1
    80001df6:	00002097          	auipc	ra,0x2
    80001dfa:	cbe080e7          	jalr	-834(ra) # 80003ab4 <fsinit>
    80001dfe:	bff9                	j	80001ddc <forkret+0x22>

0000000080001e00 <allocpid>:
{
    80001e00:	1101                	addi	sp,sp,-32
    80001e02:	ec06                	sd	ra,24(sp)
    80001e04:	e822                	sd	s0,16(sp)
    80001e06:	e426                	sd	s1,8(sp)
    80001e08:	e04a                	sd	s2,0(sp)
    80001e0a:	1000                	addi	s0,sp,32
    acquire(&pid_lock);
    80001e0c:	0000f917          	auipc	s2,0xf
    80001e10:	28490913          	addi	s2,s2,644 # 80011090 <pid_lock>
    80001e14:	854a                	mv	a0,s2
    80001e16:	fffff097          	auipc	ra,0xfffff
    80001e1a:	e28080e7          	jalr	-472(ra) # 80000c3e <acquire>
    pid = nextpid;
    80001e1e:	00007797          	auipc	a5,0x7
    80001e22:	b4278793          	addi	a5,a5,-1214 # 80008960 <nextpid>
    80001e26:	4384                	lw	s1,0(a5)
    nextpid = nextpid + 1;
    80001e28:	0014871b          	addiw	a4,s1,1
    80001e2c:	c398                	sw	a4,0(a5)
    release(&pid_lock);
    80001e2e:	854a                	mv	a0,s2
    80001e30:	fffff097          	auipc	ra,0xfffff
    80001e34:	ebe080e7          	jalr	-322(ra) # 80000cee <release>
}
    80001e38:	8526                	mv	a0,s1
    80001e3a:	60e2                	ld	ra,24(sp)
    80001e3c:	6442                	ld	s0,16(sp)
    80001e3e:	64a2                	ld	s1,8(sp)
    80001e40:	6902                	ld	s2,0(sp)
    80001e42:	6105                	addi	sp,sp,32
    80001e44:	8082                	ret

0000000080001e46 <proc_pagetable>:
{
    80001e46:	1101                	addi	sp,sp,-32
    80001e48:	ec06                	sd	ra,24(sp)
    80001e4a:	e822                	sd	s0,16(sp)
    80001e4c:	e426                	sd	s1,8(sp)
    80001e4e:	e04a                	sd	s2,0(sp)
    80001e50:	1000                	addi	s0,sp,32
    80001e52:	892a                	mv	s2,a0
    pagetable = uvmcreate();
    80001e54:	fffff097          	auipc	ra,0xfffff
    80001e58:	560080e7          	jalr	1376(ra) # 800013b4 <uvmcreate>
    80001e5c:	84aa                	mv	s1,a0
    if (pagetable == 0)
    80001e5e:	c121                	beqz	a0,80001e9e <proc_pagetable+0x58>
    if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001e60:	4729                	li	a4,10
    80001e62:	00005697          	auipc	a3,0x5
    80001e66:	19e68693          	addi	a3,a3,414 # 80007000 <_trampoline>
    80001e6a:	6605                	lui	a2,0x1
    80001e6c:	040005b7          	lui	a1,0x4000
    80001e70:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001e72:	05b2                	slli	a1,a1,0xc
    80001e74:	fffff097          	auipc	ra,0xfffff
    80001e78:	2a6080e7          	jalr	678(ra) # 8000111a <mappages>
    80001e7c:	02054863          	bltz	a0,80001eac <proc_pagetable+0x66>
    if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80001e80:	4719                	li	a4,6
    80001e82:	05893683          	ld	a3,88(s2)
    80001e86:	6605                	lui	a2,0x1
    80001e88:	020005b7          	lui	a1,0x2000
    80001e8c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001e8e:	05b6                	slli	a1,a1,0xd
    80001e90:	8526                	mv	a0,s1
    80001e92:	fffff097          	auipc	ra,0xfffff
    80001e96:	288080e7          	jalr	648(ra) # 8000111a <mappages>
    80001e9a:	02054163          	bltz	a0,80001ebc <proc_pagetable+0x76>
}
    80001e9e:	8526                	mv	a0,s1
    80001ea0:	60e2                	ld	ra,24(sp)
    80001ea2:	6442                	ld	s0,16(sp)
    80001ea4:	64a2                	ld	s1,8(sp)
    80001ea6:	6902                	ld	s2,0(sp)
    80001ea8:	6105                	addi	sp,sp,32
    80001eaa:	8082                	ret
        uvmfree(pagetable, 0);
    80001eac:	4581                	li	a1,0
    80001eae:	8526                	mv	a0,s1
    80001eb0:	fffff097          	auipc	ra,0xfffff
    80001eb4:	71e080e7          	jalr	1822(ra) # 800015ce <uvmfree>
        return 0;
    80001eb8:	4481                	li	s1,0
    80001eba:	b7d5                	j	80001e9e <proc_pagetable+0x58>
        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001ebc:	4681                	li	a3,0
    80001ebe:	4605                	li	a2,1
    80001ec0:	040005b7          	lui	a1,0x4000
    80001ec4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001ec6:	05b2                	slli	a1,a1,0xc
    80001ec8:	8526                	mv	a0,s1
    80001eca:	fffff097          	auipc	ra,0xfffff
    80001ece:	416080e7          	jalr	1046(ra) # 800012e0 <uvmunmap>
        uvmfree(pagetable, 0);
    80001ed2:	4581                	li	a1,0
    80001ed4:	8526                	mv	a0,s1
    80001ed6:	fffff097          	auipc	ra,0xfffff
    80001eda:	6f8080e7          	jalr	1784(ra) # 800015ce <uvmfree>
        return 0;
    80001ede:	4481                	li	s1,0
    80001ee0:	bf7d                	j	80001e9e <proc_pagetable+0x58>

0000000080001ee2 <proc_freepagetable>:
{
    80001ee2:	1101                	addi	sp,sp,-32
    80001ee4:	ec06                	sd	ra,24(sp)
    80001ee6:	e822                	sd	s0,16(sp)
    80001ee8:	e426                	sd	s1,8(sp)
    80001eea:	e04a                	sd	s2,0(sp)
    80001eec:	1000                	addi	s0,sp,32
    80001eee:	84aa                	mv	s1,a0
    80001ef0:	892e                	mv	s2,a1
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001ef2:	4681                	li	a3,0
    80001ef4:	4605                	li	a2,1
    80001ef6:	040005b7          	lui	a1,0x4000
    80001efa:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001efc:	05b2                	slli	a1,a1,0xc
    80001efe:	fffff097          	auipc	ra,0xfffff
    80001f02:	3e2080e7          	jalr	994(ra) # 800012e0 <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001f06:	4681                	li	a3,0
    80001f08:	4605                	li	a2,1
    80001f0a:	020005b7          	lui	a1,0x2000
    80001f0e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001f10:	05b6                	slli	a1,a1,0xd
    80001f12:	8526                	mv	a0,s1
    80001f14:	fffff097          	auipc	ra,0xfffff
    80001f18:	3cc080e7          	jalr	972(ra) # 800012e0 <uvmunmap>
    uvmfree(pagetable, sz);
    80001f1c:	85ca                	mv	a1,s2
    80001f1e:	8526                	mv	a0,s1
    80001f20:	fffff097          	auipc	ra,0xfffff
    80001f24:	6ae080e7          	jalr	1710(ra) # 800015ce <uvmfree>
}
    80001f28:	60e2                	ld	ra,24(sp)
    80001f2a:	6442                	ld	s0,16(sp)
    80001f2c:	64a2                	ld	s1,8(sp)
    80001f2e:	6902                	ld	s2,0(sp)
    80001f30:	6105                	addi	sp,sp,32
    80001f32:	8082                	ret

0000000080001f34 <freeproc>:
{
    80001f34:	1101                	addi	sp,sp,-32
    80001f36:	ec06                	sd	ra,24(sp)
    80001f38:	e822                	sd	s0,16(sp)
    80001f3a:	e426                	sd	s1,8(sp)
    80001f3c:	1000                	addi	s0,sp,32
    80001f3e:	84aa                	mv	s1,a0
    if (p->trapframe)
    80001f40:	6d28                	ld	a0,88(a0)
    80001f42:	c509                	beqz	a0,80001f4c <freeproc+0x18>
        kfree((void *)p->trapframe);
    80001f44:	fffff097          	auipc	ra,0xfffff
    80001f48:	b08080e7          	jalr	-1272(ra) # 80000a4c <kfree>
    p->trapframe = 0;
    80001f4c:	0404bc23          	sd	zero,88(s1)
    if (p->pagetable)
    80001f50:	68a8                	ld	a0,80(s1)
    80001f52:	c511                	beqz	a0,80001f5e <freeproc+0x2a>
        proc_freepagetable(p->pagetable, p->sz);
    80001f54:	64ac                	ld	a1,72(s1)
    80001f56:	00000097          	auipc	ra,0x0
    80001f5a:	f8c080e7          	jalr	-116(ra) # 80001ee2 <proc_freepagetable>
    p->pagetable = 0;
    80001f5e:	0404b823          	sd	zero,80(s1)
    p->sz = 0;
    80001f62:	0404b423          	sd	zero,72(s1)
    p->pid = 0;
    80001f66:	0204a823          	sw	zero,48(s1)
    p->parent = 0;
    80001f6a:	0204bc23          	sd	zero,56(s1)
    p->name[0] = 0;
    80001f6e:	14048c23          	sb	zero,344(s1)
    p->chan = 0;
    80001f72:	0204b023          	sd	zero,32(s1)
    p->killed = 0;
    80001f76:	0204a423          	sw	zero,40(s1)
    p->xstate = 0;
    80001f7a:	0204a623          	sw	zero,44(s1)
    p->state = UNUSED;
    80001f7e:	0004ac23          	sw	zero,24(s1)
}
    80001f82:	60e2                	ld	ra,24(sp)
    80001f84:	6442                	ld	s0,16(sp)
    80001f86:	64a2                	ld	s1,8(sp)
    80001f88:	6105                	addi	sp,sp,32
    80001f8a:	8082                	ret

0000000080001f8c <allocproc>:
{
    80001f8c:	1101                	addi	sp,sp,-32
    80001f8e:	ec06                	sd	ra,24(sp)
    80001f90:	e822                	sd	s0,16(sp)
    80001f92:	e426                	sd	s1,8(sp)
    80001f94:	e04a                	sd	s2,0(sp)
    80001f96:	1000                	addi	s0,sp,32
    for (p = proc; p < &proc[NPROC]; p++)
    80001f98:	00010497          	auipc	s1,0x10
    80001f9c:	9a848493          	addi	s1,s1,-1624 # 80011940 <proc>
    80001fa0:	00015917          	auipc	s2,0x15
    80001fa4:	7a090913          	addi	s2,s2,1952 # 80017740 <tickslock>
        acquire(&p->lock);
    80001fa8:	8526                	mv	a0,s1
    80001faa:	fffff097          	auipc	ra,0xfffff
    80001fae:	c94080e7          	jalr	-876(ra) # 80000c3e <acquire>
        if (p->state == UNUSED)
    80001fb2:	4c9c                	lw	a5,24(s1)
    80001fb4:	cf81                	beqz	a5,80001fcc <allocproc+0x40>
            release(&p->lock);
    80001fb6:	8526                	mv	a0,s1
    80001fb8:	fffff097          	auipc	ra,0xfffff
    80001fbc:	d36080e7          	jalr	-714(ra) # 80000cee <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80001fc0:	17848493          	addi	s1,s1,376
    80001fc4:	ff2492e3          	bne	s1,s2,80001fa8 <allocproc+0x1c>
    return 0;
    80001fc8:	4481                	li	s1,0
    80001fca:	a0ad                	j	80002034 <allocproc+0xa8>
    p->pid = allocpid();
    80001fcc:	00000097          	auipc	ra,0x0
    80001fd0:	e34080e7          	jalr	-460(ra) # 80001e00 <allocpid>
    80001fd4:	d888                	sw	a0,48(s1)
    p->state = USED;
    80001fd6:	4785                	li	a5,1
    80001fd8:	cc9c                	sw	a5,24(s1)
    if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    80001fda:	fffff097          	auipc	ra,0xfffff
    80001fde:	b70080e7          	jalr	-1168(ra) # 80000b4a <kalloc>
    80001fe2:	892a                	mv	s2,a0
    80001fe4:	eca8                	sd	a0,88(s1)
    80001fe6:	cd31                	beqz	a0,80002042 <allocproc+0xb6>
    p->pagetable = proc_pagetable(p);
    80001fe8:	8526                	mv	a0,s1
    80001fea:	00000097          	auipc	ra,0x0
    80001fee:	e5c080e7          	jalr	-420(ra) # 80001e46 <proc_pagetable>
    80001ff2:	892a                	mv	s2,a0
    80001ff4:	e8a8                	sd	a0,80(s1)
    if (p->pagetable == 0)
    80001ff6:	c135                	beqz	a0,8000205a <allocproc+0xce>
    memset(&p->context, 0, sizeof(p->context));
    80001ff8:	07000613          	li	a2,112
    80001ffc:	4581                	li	a1,0
    80001ffe:	06048513          	addi	a0,s1,96
    80002002:	fffff097          	auipc	ra,0xfffff
    80002006:	d34080e7          	jalr	-716(ra) # 80000d36 <memset>
    p->context.ra = (uint64)forkret;
    8000200a:	00000797          	auipc	a5,0x0
    8000200e:	db078793          	addi	a5,a5,-592 # 80001dba <forkret>
    80002012:	f0bc                	sd	a5,96(s1)
    p->context.sp = p->kstack + PGSIZE;
    80002014:	60bc                	ld	a5,64(s1)
    80002016:	6705                	lui	a4,0x1
    80002018:	97ba                	add	a5,a5,a4
    8000201a:	f4bc                	sd	a5,104(s1)
    p->priority = 0;
    8000201c:	1604a423          	sw	zero,360(s1)
    p->ticks_left = TICKS_PER_LEVEL;
    80002020:	47a9                	li	a5,10
    80002022:	16f4a623          	sw	a5,364(s1)
    p->queue_ticks = 0;
    80002026:	1604a823          	sw	zero,368(s1)
    mlfq_enqueue(p);
    8000202a:	8526                	mv	a0,s1
    8000202c:	00000097          	auipc	ra,0x0
    80002030:	952080e7          	jalr	-1710(ra) # 8000197e <mlfq_enqueue>
}
    80002034:	8526                	mv	a0,s1
    80002036:	60e2                	ld	ra,24(sp)
    80002038:	6442                	ld	s0,16(sp)
    8000203a:	64a2                	ld	s1,8(sp)
    8000203c:	6902                	ld	s2,0(sp)
    8000203e:	6105                	addi	sp,sp,32
    80002040:	8082                	ret
        freeproc(p);
    80002042:	8526                	mv	a0,s1
    80002044:	00000097          	auipc	ra,0x0
    80002048:	ef0080e7          	jalr	-272(ra) # 80001f34 <freeproc>
        release(&p->lock);
    8000204c:	8526                	mv	a0,s1
    8000204e:	fffff097          	auipc	ra,0xfffff
    80002052:	ca0080e7          	jalr	-864(ra) # 80000cee <release>
        return 0;
    80002056:	84ca                	mv	s1,s2
    80002058:	bff1                	j	80002034 <allocproc+0xa8>
        freeproc(p);
    8000205a:	8526                	mv	a0,s1
    8000205c:	00000097          	auipc	ra,0x0
    80002060:	ed8080e7          	jalr	-296(ra) # 80001f34 <freeproc>
        release(&p->lock);
    80002064:	8526                	mv	a0,s1
    80002066:	fffff097          	auipc	ra,0xfffff
    8000206a:	c88080e7          	jalr	-888(ra) # 80000cee <release>
        return 0;
    8000206e:	84ca                	mv	s1,s2
    80002070:	b7d1                	j	80002034 <allocproc+0xa8>

0000000080002072 <userinit>:
{
    80002072:	1101                	addi	sp,sp,-32
    80002074:	ec06                	sd	ra,24(sp)
    80002076:	e822                	sd	s0,16(sp)
    80002078:	e426                	sd	s1,8(sp)
    8000207a:	1000                	addi	s0,sp,32
    p = allocproc();
    8000207c:	00000097          	auipc	ra,0x0
    80002080:	f10080e7          	jalr	-240(ra) # 80001f8c <allocproc>
    80002084:	84aa                	mv	s1,a0
    initproc = p;
    80002086:	00007797          	auipc	a5,0x7
    8000208a:	98a7b923          	sd	a0,-1646(a5) # 80008a18 <initproc>
    uvmfirst(p->pagetable, initcode, sizeof(initcode));
    8000208e:	03400613          	li	a2,52
    80002092:	00007597          	auipc	a1,0x7
    80002096:	8de58593          	addi	a1,a1,-1826 # 80008970 <initcode>
    8000209a:	6928                	ld	a0,80(a0)
    8000209c:	fffff097          	auipc	ra,0xfffff
    800020a0:	346080e7          	jalr	838(ra) # 800013e2 <uvmfirst>
    p->sz = PGSIZE;
    800020a4:	6785                	lui	a5,0x1
    800020a6:	e4bc                	sd	a5,72(s1)
    p->trapframe->epc = 0;     // user program counter
    800020a8:	6cb8                	ld	a4,88(s1)
    800020aa:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    p->trapframe->sp = PGSIZE; // user stack pointer
    800020ae:	6cb8                	ld	a4,88(s1)
    800020b0:	fb1c                	sd	a5,48(a4)
    safestrcpy(p->name, "initcode", sizeof(p->name));
    800020b2:	4641                	li	a2,16
    800020b4:	00006597          	auipc	a1,0x6
    800020b8:	13458593          	addi	a1,a1,308 # 800081e8 <etext+0x1e8>
    800020bc:	15848513          	addi	a0,s1,344
    800020c0:	fffff097          	auipc	ra,0xfffff
    800020c4:	dcc080e7          	jalr	-564(ra) # 80000e8c <safestrcpy>
    p->cwd = namei("/");
    800020c8:	00006517          	auipc	a0,0x6
    800020cc:	13050513          	addi	a0,a0,304 # 800081f8 <etext+0x1f8>
    800020d0:	00002097          	auipc	ra,0x2
    800020d4:	44c080e7          	jalr	1100(ra) # 8000451c <namei>
    800020d8:	14a4b823          	sd	a0,336(s1)
    p->state = RUNNABLE;
    800020dc:	478d                	li	a5,3
    800020de:	cc9c                	sw	a5,24(s1)
    release(&p->lock);
    800020e0:	8526                	mv	a0,s1
    800020e2:	fffff097          	auipc	ra,0xfffff
    800020e6:	c0c080e7          	jalr	-1012(ra) # 80000cee <release>
}
    800020ea:	60e2                	ld	ra,24(sp)
    800020ec:	6442                	ld	s0,16(sp)
    800020ee:	64a2                	ld	s1,8(sp)
    800020f0:	6105                	addi	sp,sp,32
    800020f2:	8082                	ret

00000000800020f4 <growproc>:
{
    800020f4:	1101                	addi	sp,sp,-32
    800020f6:	ec06                	sd	ra,24(sp)
    800020f8:	e822                	sd	s0,16(sp)
    800020fa:	e426                	sd	s1,8(sp)
    800020fc:	e04a                	sd	s2,0(sp)
    800020fe:	1000                	addi	s0,sp,32
    80002100:	892a                	mv	s2,a0
    struct proc *p = myproc();
    80002102:	00000097          	auipc	ra,0x0
    80002106:	c80080e7          	jalr	-896(ra) # 80001d82 <myproc>
    8000210a:	84aa                	mv	s1,a0
    sz = p->sz;
    8000210c:	652c                	ld	a1,72(a0)
    if (n > 0)
    8000210e:	01204c63          	bgtz	s2,80002126 <growproc+0x32>
    else if (n < 0)
    80002112:	02094663          	bltz	s2,8000213e <growproc+0x4a>
    p->sz = sz;
    80002116:	e4ac                	sd	a1,72(s1)
    return 0;
    80002118:	4501                	li	a0,0
}
    8000211a:	60e2                	ld	ra,24(sp)
    8000211c:	6442                	ld	s0,16(sp)
    8000211e:	64a2                	ld	s1,8(sp)
    80002120:	6902                	ld	s2,0(sp)
    80002122:	6105                	addi	sp,sp,32
    80002124:	8082                	ret
        if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    80002126:	4691                	li	a3,4
    80002128:	00b90633          	add	a2,s2,a1
    8000212c:	6928                	ld	a0,80(a0)
    8000212e:	fffff097          	auipc	ra,0xfffff
    80002132:	36e080e7          	jalr	878(ra) # 8000149c <uvmalloc>
    80002136:	85aa                	mv	a1,a0
    80002138:	fd79                	bnez	a0,80002116 <growproc+0x22>
            return -1;
    8000213a:	557d                	li	a0,-1
    8000213c:	bff9                	j	8000211a <growproc+0x26>
        sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000213e:	00b90633          	add	a2,s2,a1
    80002142:	6928                	ld	a0,80(a0)
    80002144:	fffff097          	auipc	ra,0xfffff
    80002148:	310080e7          	jalr	784(ra) # 80001454 <uvmdealloc>
    8000214c:	85aa                	mv	a1,a0
    8000214e:	b7e1                	j	80002116 <growproc+0x22>

0000000080002150 <ps>:
{
    80002150:	711d                	addi	sp,sp,-96
    80002152:	ec86                	sd	ra,88(sp)
    80002154:	e8a2                	sd	s0,80(sp)
    80002156:	e4a6                	sd	s1,72(sp)
    80002158:	e0ca                	sd	s2,64(sp)
    8000215a:	fc4e                	sd	s3,56(sp)
    8000215c:	f852                	sd	s4,48(sp)
    8000215e:	f456                	sd	s5,40(sp)
    80002160:	f05a                	sd	s6,32(sp)
    80002162:	ec5e                	sd	s7,24(sp)
    80002164:	e862                	sd	s8,16(sp)
    80002166:	e466                	sd	s9,8(sp)
    80002168:	1080                	addi	s0,sp,96
    8000216a:	84aa                	mv	s1,a0
    8000216c:	8a2e                	mv	s4,a1
    void *result = (void *)myproc()->sz;
    8000216e:	00000097          	auipc	ra,0x0
    80002172:	c14080e7          	jalr	-1004(ra) # 80001d82 <myproc>
        return result;
    80002176:	4901                	li	s2,0
    if (count == 0)
    80002178:	0c0a0563          	beqz	s4,80002242 <ps+0xf2>
    void *result = (void *)myproc()->sz;
    8000217c:	04853b83          	ld	s7,72(a0)
    if (growproc(count * sizeof(struct user_proc)) < 0)
    80002180:	003a151b          	slliw	a0,s4,0x3
    80002184:	0145053b          	addw	a0,a0,s4
    80002188:	050a                	slli	a0,a0,0x2
    8000218a:	00000097          	auipc	ra,0x0
    8000218e:	f6a080e7          	jalr	-150(ra) # 800020f4 <growproc>
    80002192:	14054163          	bltz	a0,800022d4 <ps+0x184>
    struct user_proc loc_result[count];
    80002196:	003a1a93          	slli	s5,s4,0x3
    8000219a:	9ad2                	add	s5,s5,s4
    8000219c:	0a8a                	slli	s5,s5,0x2
    8000219e:	00fa8793          	addi	a5,s5,15
    800021a2:	8391                	srli	a5,a5,0x4
    800021a4:	0792                	slli	a5,a5,0x4
    800021a6:	40f10133          	sub	sp,sp,a5
    800021aa:	8b0a                	mv	s6,sp
    struct proc *p = proc + start;
    800021ac:	17800793          	li	a5,376
    800021b0:	02f484b3          	mul	s1,s1,a5
    800021b4:	0000f797          	auipc	a5,0xf
    800021b8:	78c78793          	addi	a5,a5,1932 # 80011940 <proc>
    800021bc:	94be                	add	s1,s1,a5
    if (p >= &proc[NPROC])
    800021be:	00015797          	auipc	a5,0x15
    800021c2:	58278793          	addi	a5,a5,1410 # 80017740 <tickslock>
        return result;
    800021c6:	4901                	li	s2,0
    if (p >= &proc[NPROC])
    800021c8:	06f4fd63          	bgeu	s1,a5,80002242 <ps+0xf2>
    acquire(&wait_lock);
    800021cc:	0000f517          	auipc	a0,0xf
    800021d0:	edc50513          	addi	a0,a0,-292 # 800110a8 <wait_lock>
    800021d4:	fffff097          	auipc	ra,0xfffff
    800021d8:	a6a080e7          	jalr	-1430(ra) # 80000c3e <acquire>
    for (; p < &proc[NPROC]; p++)
    800021dc:	01410913          	addi	s2,sp,20
    uint8 localCount = 0;
    800021e0:	4981                	li	s3,0
        copy_array(p->name, loc_result[localCount].name, 16);
    800021e2:	4cc1                	li	s9,16
    for (; p < &proc[NPROC]; p++)
    800021e4:	00015c17          	auipc	s8,0x15
    800021e8:	55cc0c13          	addi	s8,s8,1372 # 80017740 <tickslock>
    800021ec:	a07d                	j	8000229a <ps+0x14a>
            loc_result[localCount].state = UNUSED;
    800021ee:	00399793          	slli	a5,s3,0x3
    800021f2:	97ce                	add	a5,a5,s3
    800021f4:	078a                	slli	a5,a5,0x2
    800021f6:	97da                	add	a5,a5,s6
    800021f8:	0007a023          	sw	zero,0(a5)
            release(&p->lock);
    800021fc:	8526                	mv	a0,s1
    800021fe:	fffff097          	auipc	ra,0xfffff
    80002202:	af0080e7          	jalr	-1296(ra) # 80000cee <release>
    release(&wait_lock);
    80002206:	0000f517          	auipc	a0,0xf
    8000220a:	ea250513          	addi	a0,a0,-350 # 800110a8 <wait_lock>
    8000220e:	fffff097          	auipc	ra,0xfffff
    80002212:	ae0080e7          	jalr	-1312(ra) # 80000cee <release>
    if (localCount < count)
    80002216:	0149f963          	bgeu	s3,s4,80002228 <ps+0xd8>
        loc_result[localCount].state = UNUSED; // if we reach the end of processes
    8000221a:	00399793          	slli	a5,s3,0x3
    8000221e:	97ce                	add	a5,a5,s3
    80002220:	078a                	slli	a5,a5,0x2
    80002222:	97da                	add	a5,a5,s6
    80002224:	0007a023          	sw	zero,0(a5)
    void *result = (void *)myproc()->sz;
    80002228:	895e                	mv	s2,s7
    copyout(myproc()->pagetable, (uint64)result, (void *)loc_result, count * sizeof(struct user_proc));
    8000222a:	00000097          	auipc	ra,0x0
    8000222e:	b58080e7          	jalr	-1192(ra) # 80001d82 <myproc>
    80002232:	86d6                	mv	a3,s5
    80002234:	865a                	mv	a2,s6
    80002236:	85de                	mv	a1,s7
    80002238:	6928                	ld	a0,80(a0)
    8000223a:	fffff097          	auipc	ra,0xfffff
    8000223e:	4d6080e7          	jalr	1238(ra) # 80001710 <copyout>
}
    80002242:	854a                	mv	a0,s2
    80002244:	fa040113          	addi	sp,s0,-96
    80002248:	60e6                	ld	ra,88(sp)
    8000224a:	6446                	ld	s0,80(sp)
    8000224c:	64a6                	ld	s1,72(sp)
    8000224e:	6906                	ld	s2,64(sp)
    80002250:	79e2                	ld	s3,56(sp)
    80002252:	7a42                	ld	s4,48(sp)
    80002254:	7aa2                	ld	s5,40(sp)
    80002256:	7b02                	ld	s6,32(sp)
    80002258:	6be2                	ld	s7,24(sp)
    8000225a:	6c42                	ld	s8,16(sp)
    8000225c:	6ca2                	ld	s9,8(sp)
    8000225e:	6125                	addi	sp,sp,96
    80002260:	8082                	ret
            acquire(&p->parent->lock);
    80002262:	fffff097          	auipc	ra,0xfffff
    80002266:	9dc080e7          	jalr	-1572(ra) # 80000c3e <acquire>
            loc_result[localCount].parent_id = p->parent->pid;
    8000226a:	7c88                	ld	a0,56(s1)
    8000226c:	591c                	lw	a5,48(a0)
    8000226e:	fef92e23          	sw	a5,-4(s2)
            release(&p->parent->lock);
    80002272:	fffff097          	auipc	ra,0xfffff
    80002276:	a7c080e7          	jalr	-1412(ra) # 80000cee <release>
        release(&p->lock);
    8000227a:	8526                	mv	a0,s1
    8000227c:	fffff097          	auipc	ra,0xfffff
    80002280:	a72080e7          	jalr	-1422(ra) # 80000cee <release>
        localCount++;
    80002284:	2985                	addiw	s3,s3,1
    80002286:	0ff9f993          	zext.b	s3,s3
    for (; p < &proc[NPROC]; p++)
    8000228a:	17848493          	addi	s1,s1,376
    8000228e:	f784fce3          	bgeu	s1,s8,80002206 <ps+0xb6>
        if (localCount == count)
    80002292:	02490913          	addi	s2,s2,36
    80002296:	053a0163          	beq	s4,s3,800022d8 <ps+0x188>
        acquire(&p->lock);
    8000229a:	8526                	mv	a0,s1
    8000229c:	fffff097          	auipc	ra,0xfffff
    800022a0:	9a2080e7          	jalr	-1630(ra) # 80000c3e <acquire>
        if (p->state == UNUSED)
    800022a4:	4c9c                	lw	a5,24(s1)
    800022a6:	d7a1                	beqz	a5,800021ee <ps+0x9e>
        loc_result[localCount].state = p->state;
    800022a8:	fef92623          	sw	a5,-20(s2)
        loc_result[localCount].killed = p->killed;
    800022ac:	549c                	lw	a5,40(s1)
    800022ae:	fef92823          	sw	a5,-16(s2)
        loc_result[localCount].xstate = p->xstate;
    800022b2:	54dc                	lw	a5,44(s1)
    800022b4:	fef92a23          	sw	a5,-12(s2)
        loc_result[localCount].pid = p->pid;
    800022b8:	589c                	lw	a5,48(s1)
    800022ba:	fef92c23          	sw	a5,-8(s2)
        copy_array(p->name, loc_result[localCount].name, 16);
    800022be:	8666                	mv	a2,s9
    800022c0:	85ca                	mv	a1,s2
    800022c2:	15848513          	addi	a0,s1,344
    800022c6:	00000097          	auipc	ra,0x0
    800022ca:	a60080e7          	jalr	-1440(ra) # 80001d26 <copy_array>
        if (p->parent != 0) // init
    800022ce:	7c88                	ld	a0,56(s1)
    800022d0:	f949                	bnez	a0,80002262 <ps+0x112>
    800022d2:	b765                	j	8000227a <ps+0x12a>
        return result;
    800022d4:	4901                	li	s2,0
    800022d6:	b7b5                	j	80002242 <ps+0xf2>
    release(&wait_lock);
    800022d8:	0000f517          	auipc	a0,0xf
    800022dc:	dd050513          	addi	a0,a0,-560 # 800110a8 <wait_lock>
    800022e0:	fffff097          	auipc	ra,0xfffff
    800022e4:	a0e080e7          	jalr	-1522(ra) # 80000cee <release>
    if (localCount < count)
    800022e8:	b781                	j	80002228 <ps+0xd8>

00000000800022ea <fork>:
{
    800022ea:	7139                	addi	sp,sp,-64
    800022ec:	fc06                	sd	ra,56(sp)
    800022ee:	f822                	sd	s0,48(sp)
    800022f0:	f04a                	sd	s2,32(sp)
    800022f2:	e456                	sd	s5,8(sp)
    800022f4:	0080                	addi	s0,sp,64
    struct proc *p = myproc();
    800022f6:	00000097          	auipc	ra,0x0
    800022fa:	a8c080e7          	jalr	-1396(ra) # 80001d82 <myproc>
    800022fe:	8aaa                	mv	s5,a0
    if ((np = allocproc()) == 0)
    80002300:	00000097          	auipc	ra,0x0
    80002304:	c8c080e7          	jalr	-884(ra) # 80001f8c <allocproc>
    80002308:	12050063          	beqz	a0,80002428 <fork+0x13e>
    8000230c:	e852                	sd	s4,16(sp)
    8000230e:	8a2a                	mv	s4,a0
    if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    80002310:	048ab603          	ld	a2,72(s5)
    80002314:	692c                	ld	a1,80(a0)
    80002316:	050ab503          	ld	a0,80(s5)
    8000231a:	fffff097          	auipc	ra,0xfffff
    8000231e:	2ee080e7          	jalr	750(ra) # 80001608 <uvmcopy>
    80002322:	04054a63          	bltz	a0,80002376 <fork+0x8c>
    80002326:	f426                	sd	s1,40(sp)
    80002328:	ec4e                	sd	s3,24(sp)
    np->sz = p->sz;
    8000232a:	048ab783          	ld	a5,72(s5)
    8000232e:	04fa3423          	sd	a5,72(s4)
    *(np->trapframe) = *(p->trapframe);
    80002332:	058ab683          	ld	a3,88(s5)
    80002336:	87b6                	mv	a5,a3
    80002338:	058a3703          	ld	a4,88(s4)
    8000233c:	12068693          	addi	a3,a3,288
    80002340:	0007b803          	ld	a6,0(a5)
    80002344:	6788                	ld	a0,8(a5)
    80002346:	6b8c                	ld	a1,16(a5)
    80002348:	6f90                	ld	a2,24(a5)
    8000234a:	01073023          	sd	a6,0(a4)
    8000234e:	e708                	sd	a0,8(a4)
    80002350:	eb0c                	sd	a1,16(a4)
    80002352:	ef10                	sd	a2,24(a4)
    80002354:	02078793          	addi	a5,a5,32
    80002358:	02070713          	addi	a4,a4,32
    8000235c:	fed792e3          	bne	a5,a3,80002340 <fork+0x56>
    np->trapframe->a0 = 0;
    80002360:	058a3783          	ld	a5,88(s4)
    80002364:	0607b823          	sd	zero,112(a5)
    for (i = 0; i < NOFILE; i++)
    80002368:	0d0a8493          	addi	s1,s5,208
    8000236c:	0d0a0913          	addi	s2,s4,208
    80002370:	150a8993          	addi	s3,s5,336
    80002374:	a015                	j	80002398 <fork+0xae>
        freeproc(np);
    80002376:	8552                	mv	a0,s4
    80002378:	00000097          	auipc	ra,0x0
    8000237c:	bbc080e7          	jalr	-1092(ra) # 80001f34 <freeproc>
        release(&np->lock);
    80002380:	8552                	mv	a0,s4
    80002382:	fffff097          	auipc	ra,0xfffff
    80002386:	96c080e7          	jalr	-1684(ra) # 80000cee <release>
        return -1;
    8000238a:	597d                	li	s2,-1
    8000238c:	6a42                	ld	s4,16(sp)
    8000238e:	a071                	j	8000241a <fork+0x130>
    for (i = 0; i < NOFILE; i++)
    80002390:	04a1                	addi	s1,s1,8
    80002392:	0921                	addi	s2,s2,8
    80002394:	01348b63          	beq	s1,s3,800023aa <fork+0xc0>
        if (p->ofile[i])
    80002398:	6088                	ld	a0,0(s1)
    8000239a:	d97d                	beqz	a0,80002390 <fork+0xa6>
            np->ofile[i] = filedup(p->ofile[i]);
    8000239c:	00003097          	auipc	ra,0x3
    800023a0:	804080e7          	jalr	-2044(ra) # 80004ba0 <filedup>
    800023a4:	00a93023          	sd	a0,0(s2)
    800023a8:	b7e5                	j	80002390 <fork+0xa6>
    np->cwd = idup(p->cwd);
    800023aa:	150ab503          	ld	a0,336(s5)
    800023ae:	00002097          	auipc	ra,0x2
    800023b2:	94c080e7          	jalr	-1716(ra) # 80003cfa <idup>
    800023b6:	14aa3823          	sd	a0,336(s4)
    safestrcpy(np->name, p->name, sizeof(p->name));
    800023ba:	4641                	li	a2,16
    800023bc:	158a8593          	addi	a1,s5,344
    800023c0:	158a0513          	addi	a0,s4,344
    800023c4:	fffff097          	auipc	ra,0xfffff
    800023c8:	ac8080e7          	jalr	-1336(ra) # 80000e8c <safestrcpy>
    pid = np->pid;
    800023cc:	030a2903          	lw	s2,48(s4)
    release(&np->lock);
    800023d0:	8552                	mv	a0,s4
    800023d2:	fffff097          	auipc	ra,0xfffff
    800023d6:	91c080e7          	jalr	-1764(ra) # 80000cee <release>
    acquire(&wait_lock);
    800023da:	0000f497          	auipc	s1,0xf
    800023de:	cce48493          	addi	s1,s1,-818 # 800110a8 <wait_lock>
    800023e2:	8526                	mv	a0,s1
    800023e4:	fffff097          	auipc	ra,0xfffff
    800023e8:	85a080e7          	jalr	-1958(ra) # 80000c3e <acquire>
    np->parent = p;
    800023ec:	035a3c23          	sd	s5,56(s4)
    release(&wait_lock);
    800023f0:	8526                	mv	a0,s1
    800023f2:	fffff097          	auipc	ra,0xfffff
    800023f6:	8fc080e7          	jalr	-1796(ra) # 80000cee <release>
    acquire(&np->lock);
    800023fa:	8552                	mv	a0,s4
    800023fc:	fffff097          	auipc	ra,0xfffff
    80002400:	842080e7          	jalr	-1982(ra) # 80000c3e <acquire>
    np->state = RUNNABLE;
    80002404:	478d                	li	a5,3
    80002406:	00fa2c23          	sw	a5,24(s4)
    release(&np->lock);
    8000240a:	8552                	mv	a0,s4
    8000240c:	fffff097          	auipc	ra,0xfffff
    80002410:	8e2080e7          	jalr	-1822(ra) # 80000cee <release>
    return pid;
    80002414:	74a2                	ld	s1,40(sp)
    80002416:	69e2                	ld	s3,24(sp)
    80002418:	6a42                	ld	s4,16(sp)
}
    8000241a:	854a                	mv	a0,s2
    8000241c:	70e2                	ld	ra,56(sp)
    8000241e:	7442                	ld	s0,48(sp)
    80002420:	7902                	ld	s2,32(sp)
    80002422:	6aa2                	ld	s5,8(sp)
    80002424:	6121                	addi	sp,sp,64
    80002426:	8082                	ret
        return -1;
    80002428:	597d                	li	s2,-1
    8000242a:	bfc5                	j	8000241a <fork+0x130>

000000008000242c <scheduler>:
{
    8000242c:	1101                	addi	sp,sp,-32
    8000242e:	ec06                	sd	ra,24(sp)
    80002430:	e822                	sd	s0,16(sp)
    80002432:	e426                	sd	s1,8(sp)
    80002434:	e04a                	sd	s2,0(sp)
    80002436:	1000                	addi	s0,sp,32
    void (*old_scheduler)(void) = sched_pointer;
    80002438:	00006797          	auipc	a5,0x6
    8000243c:	5207b783          	ld	a5,1312(a5) # 80008958 <sched_pointer>
        if (old_scheduler != sched_pointer)
    80002440:	00006497          	auipc	s1,0x6
    80002444:	51848493          	addi	s1,s1,1304 # 80008958 <sched_pointer>
            printf("Scheduler switched\n");
    80002448:	00006917          	auipc	s2,0x6
    8000244c:	db890913          	addi	s2,s2,-584 # 80008200 <etext+0x200>
    80002450:	a021                	j	80002458 <scheduler+0x2c>
        (*sched_pointer)();
    80002452:	609c                	ld	a5,0(s1)
    80002454:	9782                	jalr	a5
        old_scheduler = sched_pointer;
    80002456:	609c                	ld	a5,0(s1)
        if (old_scheduler != sched_pointer)
    80002458:	6098                	ld	a4,0(s1)
    8000245a:	fef70ce3          	beq	a4,a5,80002452 <scheduler+0x26>
            printf("Scheduler switched\n");
    8000245e:	854a                	mv	a0,s2
    80002460:	ffffe097          	auipc	ra,0xffffe
    80002464:	14a080e7          	jalr	330(ra) # 800005aa <printf>
    80002468:	b7ed                	j	80002452 <scheduler+0x26>

000000008000246a <sched>:
{
    8000246a:	7179                	addi	sp,sp,-48
    8000246c:	f406                	sd	ra,40(sp)
    8000246e:	f022                	sd	s0,32(sp)
    80002470:	ec26                	sd	s1,24(sp)
    80002472:	e84a                	sd	s2,16(sp)
    80002474:	e44e                	sd	s3,8(sp)
    80002476:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80002478:	00000097          	auipc	ra,0x0
    8000247c:	90a080e7          	jalr	-1782(ra) # 80001d82 <myproc>
    80002480:	84aa                	mv	s1,a0
    if (!holding(&p->lock))
    80002482:	ffffe097          	auipc	ra,0xffffe
    80002486:	742080e7          	jalr	1858(ra) # 80000bc4 <holding>
    8000248a:	c53d                	beqz	a0,800024f8 <sched+0x8e>
    8000248c:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    8000248e:	2781                	sext.w	a5,a5
    80002490:	079e                	slli	a5,a5,0x7
    80002492:	0000e717          	auipc	a4,0xe
    80002496:	7fe70713          	addi	a4,a4,2046 # 80010c90 <cpus>
    8000249a:	97ba                	add	a5,a5,a4
    8000249c:	5fb8                	lw	a4,120(a5)
    8000249e:	4785                	li	a5,1
    800024a0:	06f71463          	bne	a4,a5,80002508 <sched+0x9e>
    if (p->state == RUNNING)
    800024a4:	4c98                	lw	a4,24(s1)
    800024a6:	4791                	li	a5,4
    800024a8:	06f70863          	beq	a4,a5,80002518 <sched+0xae>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800024ac:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800024b0:	8b89                	andi	a5,a5,2
    if (intr_get())
    800024b2:	ebbd                	bnez	a5,80002528 <sched+0xbe>
  asm volatile("mv %0, tp" : "=r" (x) );
    800024b4:	8792                	mv	a5,tp
    intena = mycpu()->intena;
    800024b6:	0000e917          	auipc	s2,0xe
    800024ba:	7da90913          	addi	s2,s2,2010 # 80010c90 <cpus>
    800024be:	2781                	sext.w	a5,a5
    800024c0:	079e                	slli	a5,a5,0x7
    800024c2:	97ca                	add	a5,a5,s2
    800024c4:	07c7a983          	lw	s3,124(a5)
    800024c8:	8592                	mv	a1,tp
    swtch(&p->context, &mycpu()->context);
    800024ca:	2581                	sext.w	a1,a1
    800024cc:	059e                	slli	a1,a1,0x7
    800024ce:	05a1                	addi	a1,a1,8
    800024d0:	95ca                	add	a1,a1,s2
    800024d2:	06048513          	addi	a0,s1,96
    800024d6:	00000097          	auipc	ra,0x0
    800024da:	740080e7          	jalr	1856(ra) # 80002c16 <swtch>
    800024de:	8792                	mv	a5,tp
    mycpu()->intena = intena;
    800024e0:	2781                	sext.w	a5,a5
    800024e2:	079e                	slli	a5,a5,0x7
    800024e4:	993e                	add	s2,s2,a5
    800024e6:	07392e23          	sw	s3,124(s2)
}
    800024ea:	70a2                	ld	ra,40(sp)
    800024ec:	7402                	ld	s0,32(sp)
    800024ee:	64e2                	ld	s1,24(sp)
    800024f0:	6942                	ld	s2,16(sp)
    800024f2:	69a2                	ld	s3,8(sp)
    800024f4:	6145                	addi	sp,sp,48
    800024f6:	8082                	ret
        panic("sched p->lock");
    800024f8:	00006517          	auipc	a0,0x6
    800024fc:	d2050513          	addi	a0,a0,-736 # 80008218 <etext+0x218>
    80002500:	ffffe097          	auipc	ra,0xffffe
    80002504:	060080e7          	jalr	96(ra) # 80000560 <panic>
        panic("sched locks");
    80002508:	00006517          	auipc	a0,0x6
    8000250c:	d2050513          	addi	a0,a0,-736 # 80008228 <etext+0x228>
    80002510:	ffffe097          	auipc	ra,0xffffe
    80002514:	050080e7          	jalr	80(ra) # 80000560 <panic>
        panic("sched running");
    80002518:	00006517          	auipc	a0,0x6
    8000251c:	d2050513          	addi	a0,a0,-736 # 80008238 <etext+0x238>
    80002520:	ffffe097          	auipc	ra,0xffffe
    80002524:	040080e7          	jalr	64(ra) # 80000560 <panic>
        panic("sched interruptible");
    80002528:	00006517          	auipc	a0,0x6
    8000252c:	d2050513          	addi	a0,a0,-736 # 80008248 <etext+0x248>
    80002530:	ffffe097          	auipc	ra,0xffffe
    80002534:	030080e7          	jalr	48(ra) # 80000560 <panic>

0000000080002538 <yield>:
{
    80002538:	1101                	addi	sp,sp,-32
    8000253a:	ec06                	sd	ra,24(sp)
    8000253c:	e822                	sd	s0,16(sp)
    8000253e:	e426                	sd	s1,8(sp)
    80002540:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    80002542:	00000097          	auipc	ra,0x0
    80002546:	840080e7          	jalr	-1984(ra) # 80001d82 <myproc>
    8000254a:	84aa                	mv	s1,a0
    acquire(&p->lock);
    8000254c:	ffffe097          	auipc	ra,0xffffe
    80002550:	6f2080e7          	jalr	1778(ra) # 80000c3e <acquire>
    p->state = RUNNABLE;
    80002554:	478d                	li	a5,3
    80002556:	cc9c                	sw	a5,24(s1)
    sched();
    80002558:	00000097          	auipc	ra,0x0
    8000255c:	f12080e7          	jalr	-238(ra) # 8000246a <sched>
    release(&p->lock);
    80002560:	8526                	mv	a0,s1
    80002562:	ffffe097          	auipc	ra,0xffffe
    80002566:	78c080e7          	jalr	1932(ra) # 80000cee <release>
}
    8000256a:	60e2                	ld	ra,24(sp)
    8000256c:	6442                	ld	s0,16(sp)
    8000256e:	64a2                	ld	s1,8(sp)
    80002570:	6105                	addi	sp,sp,32
    80002572:	8082                	ret

0000000080002574 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    80002574:	7179                	addi	sp,sp,-48
    80002576:	f406                	sd	ra,40(sp)
    80002578:	f022                	sd	s0,32(sp)
    8000257a:	ec26                	sd	s1,24(sp)
    8000257c:	e84a                	sd	s2,16(sp)
    8000257e:	e44e                	sd	s3,8(sp)
    80002580:	1800                	addi	s0,sp,48
    80002582:	89aa                	mv	s3,a0
    80002584:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80002586:	fffff097          	auipc	ra,0xfffff
    8000258a:	7fc080e7          	jalr	2044(ra) # 80001d82 <myproc>
    8000258e:	84aa                	mv	s1,a0
    // Once we hold p->lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup locks p->lock),
    // so it's okay to release lk.

    acquire(&p->lock); // DOC: sleeplock1
    80002590:	ffffe097          	auipc	ra,0xffffe
    80002594:	6ae080e7          	jalr	1710(ra) # 80000c3e <acquire>
    release(lk);
    80002598:	854a                	mv	a0,s2
    8000259a:	ffffe097          	auipc	ra,0xffffe
    8000259e:	754080e7          	jalr	1876(ra) # 80000cee <release>

    // Go to sleep.
    p->chan = chan;
    800025a2:	0334b023          	sd	s3,32(s1)
    p->state = SLEEPING;
    800025a6:	4789                	li	a5,2
    800025a8:	cc9c                	sw	a5,24(s1)

    sched();
    800025aa:	00000097          	auipc	ra,0x0
    800025ae:	ec0080e7          	jalr	-320(ra) # 8000246a <sched>

    // Tidy up.
    p->chan = 0;
    800025b2:	0204b023          	sd	zero,32(s1)

    // Reacquire original lock.
    release(&p->lock);
    800025b6:	8526                	mv	a0,s1
    800025b8:	ffffe097          	auipc	ra,0xffffe
    800025bc:	736080e7          	jalr	1846(ra) # 80000cee <release>
    acquire(lk);
    800025c0:	854a                	mv	a0,s2
    800025c2:	ffffe097          	auipc	ra,0xffffe
    800025c6:	67c080e7          	jalr	1660(ra) # 80000c3e <acquire>
}
    800025ca:	70a2                	ld	ra,40(sp)
    800025cc:	7402                	ld	s0,32(sp)
    800025ce:	64e2                	ld	s1,24(sp)
    800025d0:	6942                	ld	s2,16(sp)
    800025d2:	69a2                	ld	s3,8(sp)
    800025d4:	6145                	addi	sp,sp,48
    800025d6:	8082                	ret

00000000800025d8 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    800025d8:	7139                	addi	sp,sp,-64
    800025da:	fc06                	sd	ra,56(sp)
    800025dc:	f822                	sd	s0,48(sp)
    800025de:	f426                	sd	s1,40(sp)
    800025e0:	f04a                	sd	s2,32(sp)
    800025e2:	ec4e                	sd	s3,24(sp)
    800025e4:	e852                	sd	s4,16(sp)
    800025e6:	e456                	sd	s5,8(sp)
    800025e8:	0080                	addi	s0,sp,64
    800025ea:	8a2a                	mv	s4,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    800025ec:	0000f497          	auipc	s1,0xf
    800025f0:	35448493          	addi	s1,s1,852 # 80011940 <proc>
    {
        if (p != myproc())
        {
            acquire(&p->lock);
            if (p->state == SLEEPING && p->chan == chan)
    800025f4:	4989                	li	s3,2
            {
                p->state = RUNNABLE;
    800025f6:	4a8d                	li	s5,3
    for (p = proc; p < &proc[NPROC]; p++)
    800025f8:	00015917          	auipc	s2,0x15
    800025fc:	14890913          	addi	s2,s2,328 # 80017740 <tickslock>
    80002600:	a811                	j	80002614 <wakeup+0x3c>
            }
            release(&p->lock);
    80002602:	8526                	mv	a0,s1
    80002604:	ffffe097          	auipc	ra,0xffffe
    80002608:	6ea080e7          	jalr	1770(ra) # 80000cee <release>
    for (p = proc; p < &proc[NPROC]; p++)
    8000260c:	17848493          	addi	s1,s1,376
    80002610:	03248663          	beq	s1,s2,8000263c <wakeup+0x64>
        if (p != myproc())
    80002614:	fffff097          	auipc	ra,0xfffff
    80002618:	76e080e7          	jalr	1902(ra) # 80001d82 <myproc>
    8000261c:	fea488e3          	beq	s1,a0,8000260c <wakeup+0x34>
            acquire(&p->lock);
    80002620:	8526                	mv	a0,s1
    80002622:	ffffe097          	auipc	ra,0xffffe
    80002626:	61c080e7          	jalr	1564(ra) # 80000c3e <acquire>
            if (p->state == SLEEPING && p->chan == chan)
    8000262a:	4c9c                	lw	a5,24(s1)
    8000262c:	fd379be3          	bne	a5,s3,80002602 <wakeup+0x2a>
    80002630:	709c                	ld	a5,32(s1)
    80002632:	fd4798e3          	bne	a5,s4,80002602 <wakeup+0x2a>
                p->state = RUNNABLE;
    80002636:	0154ac23          	sw	s5,24(s1)
    8000263a:	b7e1                	j	80002602 <wakeup+0x2a>
        }
    }
}
    8000263c:	70e2                	ld	ra,56(sp)
    8000263e:	7442                	ld	s0,48(sp)
    80002640:	74a2                	ld	s1,40(sp)
    80002642:	7902                	ld	s2,32(sp)
    80002644:	69e2                	ld	s3,24(sp)
    80002646:	6a42                	ld	s4,16(sp)
    80002648:	6aa2                	ld	s5,8(sp)
    8000264a:	6121                	addi	sp,sp,64
    8000264c:	8082                	ret

000000008000264e <reparent>:
{
    8000264e:	7179                	addi	sp,sp,-48
    80002650:	f406                	sd	ra,40(sp)
    80002652:	f022                	sd	s0,32(sp)
    80002654:	ec26                	sd	s1,24(sp)
    80002656:	e84a                	sd	s2,16(sp)
    80002658:	e44e                	sd	s3,8(sp)
    8000265a:	e052                	sd	s4,0(sp)
    8000265c:	1800                	addi	s0,sp,48
    8000265e:	892a                	mv	s2,a0
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80002660:	0000f497          	auipc	s1,0xf
    80002664:	2e048493          	addi	s1,s1,736 # 80011940 <proc>
            pp->parent = initproc;
    80002668:	00006a17          	auipc	s4,0x6
    8000266c:	3b0a0a13          	addi	s4,s4,944 # 80008a18 <initproc>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80002670:	00015997          	auipc	s3,0x15
    80002674:	0d098993          	addi	s3,s3,208 # 80017740 <tickslock>
    80002678:	a029                	j	80002682 <reparent+0x34>
    8000267a:	17848493          	addi	s1,s1,376
    8000267e:	01348d63          	beq	s1,s3,80002698 <reparent+0x4a>
        if (pp->parent == p)
    80002682:	7c9c                	ld	a5,56(s1)
    80002684:	ff279be3          	bne	a5,s2,8000267a <reparent+0x2c>
            pp->parent = initproc;
    80002688:	000a3503          	ld	a0,0(s4)
    8000268c:	fc88                	sd	a0,56(s1)
            wakeup(initproc);
    8000268e:	00000097          	auipc	ra,0x0
    80002692:	f4a080e7          	jalr	-182(ra) # 800025d8 <wakeup>
    80002696:	b7d5                	j	8000267a <reparent+0x2c>
}
    80002698:	70a2                	ld	ra,40(sp)
    8000269a:	7402                	ld	s0,32(sp)
    8000269c:	64e2                	ld	s1,24(sp)
    8000269e:	6942                	ld	s2,16(sp)
    800026a0:	69a2                	ld	s3,8(sp)
    800026a2:	6a02                	ld	s4,0(sp)
    800026a4:	6145                	addi	sp,sp,48
    800026a6:	8082                	ret

00000000800026a8 <exit>:
{
    800026a8:	7179                	addi	sp,sp,-48
    800026aa:	f406                	sd	ra,40(sp)
    800026ac:	f022                	sd	s0,32(sp)
    800026ae:	ec26                	sd	s1,24(sp)
    800026b0:	e84a                	sd	s2,16(sp)
    800026b2:	e44e                	sd	s3,8(sp)
    800026b4:	e052                	sd	s4,0(sp)
    800026b6:	1800                	addi	s0,sp,48
    800026b8:	8a2a                	mv	s4,a0
    struct proc *p = myproc();
    800026ba:	fffff097          	auipc	ra,0xfffff
    800026be:	6c8080e7          	jalr	1736(ra) # 80001d82 <myproc>
    800026c2:	89aa                	mv	s3,a0
    if (p == initproc)
    800026c4:	00006797          	auipc	a5,0x6
    800026c8:	3547b783          	ld	a5,852(a5) # 80008a18 <initproc>
    800026cc:	0d050493          	addi	s1,a0,208
    800026d0:	15050913          	addi	s2,a0,336
    800026d4:	00a79d63          	bne	a5,a0,800026ee <exit+0x46>
        panic("init exiting");
    800026d8:	00006517          	auipc	a0,0x6
    800026dc:	b8850513          	addi	a0,a0,-1144 # 80008260 <etext+0x260>
    800026e0:	ffffe097          	auipc	ra,0xffffe
    800026e4:	e80080e7          	jalr	-384(ra) # 80000560 <panic>
    for (int fd = 0; fd < NOFILE; fd++)
    800026e8:	04a1                	addi	s1,s1,8
    800026ea:	01248b63          	beq	s1,s2,80002700 <exit+0x58>
        if (p->ofile[fd])
    800026ee:	6088                	ld	a0,0(s1)
    800026f0:	dd65                	beqz	a0,800026e8 <exit+0x40>
            fileclose(f);
    800026f2:	00002097          	auipc	ra,0x2
    800026f6:	500080e7          	jalr	1280(ra) # 80004bf2 <fileclose>
            p->ofile[fd] = 0;
    800026fa:	0004b023          	sd	zero,0(s1)
    800026fe:	b7ed                	j	800026e8 <exit+0x40>
    begin_op();
    80002700:	00002097          	auipc	ra,0x2
    80002704:	022080e7          	jalr	34(ra) # 80004722 <begin_op>
    iput(p->cwd);
    80002708:	1509b503          	ld	a0,336(s3)
    8000270c:	00001097          	auipc	ra,0x1
    80002710:	7ea080e7          	jalr	2026(ra) # 80003ef6 <iput>
    end_op();
    80002714:	00002097          	auipc	ra,0x2
    80002718:	088080e7          	jalr	136(ra) # 8000479c <end_op>
    p->cwd = 0;
    8000271c:	1409b823          	sd	zero,336(s3)
    acquire(&wait_lock);
    80002720:	0000f497          	auipc	s1,0xf
    80002724:	98848493          	addi	s1,s1,-1656 # 800110a8 <wait_lock>
    80002728:	8526                	mv	a0,s1
    8000272a:	ffffe097          	auipc	ra,0xffffe
    8000272e:	514080e7          	jalr	1300(ra) # 80000c3e <acquire>
    reparent(p);
    80002732:	854e                	mv	a0,s3
    80002734:	00000097          	auipc	ra,0x0
    80002738:	f1a080e7          	jalr	-230(ra) # 8000264e <reparent>
    wakeup(p->parent);
    8000273c:	0389b503          	ld	a0,56(s3)
    80002740:	00000097          	auipc	ra,0x0
    80002744:	e98080e7          	jalr	-360(ra) # 800025d8 <wakeup>
    acquire(&p->lock);
    80002748:	854e                	mv	a0,s3
    8000274a:	ffffe097          	auipc	ra,0xffffe
    8000274e:	4f4080e7          	jalr	1268(ra) # 80000c3e <acquire>
    p->xstate = status;
    80002752:	0349a623          	sw	s4,44(s3)
    p->state = ZOMBIE;
    80002756:	4795                	li	a5,5
    80002758:	00f9ac23          	sw	a5,24(s3)
    release(&wait_lock);
    8000275c:	8526                	mv	a0,s1
    8000275e:	ffffe097          	auipc	ra,0xffffe
    80002762:	590080e7          	jalr	1424(ra) # 80000cee <release>
    sched();
    80002766:	00000097          	auipc	ra,0x0
    8000276a:	d04080e7          	jalr	-764(ra) # 8000246a <sched>
    panic("zombie exit");
    8000276e:	00006517          	auipc	a0,0x6
    80002772:	b0250513          	addi	a0,a0,-1278 # 80008270 <etext+0x270>
    80002776:	ffffe097          	auipc	ra,0xffffe
    8000277a:	dea080e7          	jalr	-534(ra) # 80000560 <panic>

000000008000277e <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    8000277e:	7179                	addi	sp,sp,-48
    80002780:	f406                	sd	ra,40(sp)
    80002782:	f022                	sd	s0,32(sp)
    80002784:	ec26                	sd	s1,24(sp)
    80002786:	e84a                	sd	s2,16(sp)
    80002788:	e44e                	sd	s3,8(sp)
    8000278a:	1800                	addi	s0,sp,48
    8000278c:	892a                	mv	s2,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    8000278e:	0000f497          	auipc	s1,0xf
    80002792:	1b248493          	addi	s1,s1,434 # 80011940 <proc>
    80002796:	00015997          	auipc	s3,0x15
    8000279a:	faa98993          	addi	s3,s3,-86 # 80017740 <tickslock>
    {
        acquire(&p->lock);
    8000279e:	8526                	mv	a0,s1
    800027a0:	ffffe097          	auipc	ra,0xffffe
    800027a4:	49e080e7          	jalr	1182(ra) # 80000c3e <acquire>
        if (p->pid == pid)
    800027a8:	589c                	lw	a5,48(s1)
    800027aa:	01278d63          	beq	a5,s2,800027c4 <kill+0x46>
                p->state = RUNNABLE;
            }
            release(&p->lock);
            return 0;
        }
        release(&p->lock);
    800027ae:	8526                	mv	a0,s1
    800027b0:	ffffe097          	auipc	ra,0xffffe
    800027b4:	53e080e7          	jalr	1342(ra) # 80000cee <release>
    for (p = proc; p < &proc[NPROC]; p++)
    800027b8:	17848493          	addi	s1,s1,376
    800027bc:	ff3491e3          	bne	s1,s3,8000279e <kill+0x20>
    }
    return -1;
    800027c0:	557d                	li	a0,-1
    800027c2:	a829                	j	800027dc <kill+0x5e>
            p->killed = 1;
    800027c4:	4785                	li	a5,1
    800027c6:	d49c                	sw	a5,40(s1)
            if (p->state == SLEEPING)
    800027c8:	4c98                	lw	a4,24(s1)
    800027ca:	4789                	li	a5,2
    800027cc:	00f70f63          	beq	a4,a5,800027ea <kill+0x6c>
            release(&p->lock);
    800027d0:	8526                	mv	a0,s1
    800027d2:	ffffe097          	auipc	ra,0xffffe
    800027d6:	51c080e7          	jalr	1308(ra) # 80000cee <release>
            return 0;
    800027da:	4501                	li	a0,0
}
    800027dc:	70a2                	ld	ra,40(sp)
    800027de:	7402                	ld	s0,32(sp)
    800027e0:	64e2                	ld	s1,24(sp)
    800027e2:	6942                	ld	s2,16(sp)
    800027e4:	69a2                	ld	s3,8(sp)
    800027e6:	6145                	addi	sp,sp,48
    800027e8:	8082                	ret
                p->state = RUNNABLE;
    800027ea:	478d                	li	a5,3
    800027ec:	cc9c                	sw	a5,24(s1)
    800027ee:	b7cd                	j	800027d0 <kill+0x52>

00000000800027f0 <setkilled>:

void setkilled(struct proc *p)
{
    800027f0:	1101                	addi	sp,sp,-32
    800027f2:	ec06                	sd	ra,24(sp)
    800027f4:	e822                	sd	s0,16(sp)
    800027f6:	e426                	sd	s1,8(sp)
    800027f8:	1000                	addi	s0,sp,32
    800027fa:	84aa                	mv	s1,a0
    acquire(&p->lock);
    800027fc:	ffffe097          	auipc	ra,0xffffe
    80002800:	442080e7          	jalr	1090(ra) # 80000c3e <acquire>
    p->killed = 1;
    80002804:	4785                	li	a5,1
    80002806:	d49c                	sw	a5,40(s1)
    release(&p->lock);
    80002808:	8526                	mv	a0,s1
    8000280a:	ffffe097          	auipc	ra,0xffffe
    8000280e:	4e4080e7          	jalr	1252(ra) # 80000cee <release>
}
    80002812:	60e2                	ld	ra,24(sp)
    80002814:	6442                	ld	s0,16(sp)
    80002816:	64a2                	ld	s1,8(sp)
    80002818:	6105                	addi	sp,sp,32
    8000281a:	8082                	ret

000000008000281c <killed>:

int killed(struct proc *p)
{
    8000281c:	1101                	addi	sp,sp,-32
    8000281e:	ec06                	sd	ra,24(sp)
    80002820:	e822                	sd	s0,16(sp)
    80002822:	e426                	sd	s1,8(sp)
    80002824:	e04a                	sd	s2,0(sp)
    80002826:	1000                	addi	s0,sp,32
    80002828:	84aa                	mv	s1,a0
    int k;

    acquire(&p->lock);
    8000282a:	ffffe097          	auipc	ra,0xffffe
    8000282e:	414080e7          	jalr	1044(ra) # 80000c3e <acquire>
    k = p->killed;
    80002832:	0284a903          	lw	s2,40(s1)
    release(&p->lock);
    80002836:	8526                	mv	a0,s1
    80002838:	ffffe097          	auipc	ra,0xffffe
    8000283c:	4b6080e7          	jalr	1206(ra) # 80000cee <release>
    return k;
}
    80002840:	854a                	mv	a0,s2
    80002842:	60e2                	ld	ra,24(sp)
    80002844:	6442                	ld	s0,16(sp)
    80002846:	64a2                	ld	s1,8(sp)
    80002848:	6902                	ld	s2,0(sp)
    8000284a:	6105                	addi	sp,sp,32
    8000284c:	8082                	ret

000000008000284e <wait>:
{
    8000284e:	715d                	addi	sp,sp,-80
    80002850:	e486                	sd	ra,72(sp)
    80002852:	e0a2                	sd	s0,64(sp)
    80002854:	fc26                	sd	s1,56(sp)
    80002856:	f84a                	sd	s2,48(sp)
    80002858:	f44e                	sd	s3,40(sp)
    8000285a:	f052                	sd	s4,32(sp)
    8000285c:	ec56                	sd	s5,24(sp)
    8000285e:	e85a                	sd	s6,16(sp)
    80002860:	e45e                	sd	s7,8(sp)
    80002862:	0880                	addi	s0,sp,80
    80002864:	8b2a                	mv	s6,a0
    struct proc *p = myproc();
    80002866:	fffff097          	auipc	ra,0xfffff
    8000286a:	51c080e7          	jalr	1308(ra) # 80001d82 <myproc>
    8000286e:	892a                	mv	s2,a0
    acquire(&wait_lock);
    80002870:	0000f517          	auipc	a0,0xf
    80002874:	83850513          	addi	a0,a0,-1992 # 800110a8 <wait_lock>
    80002878:	ffffe097          	auipc	ra,0xffffe
    8000287c:	3c6080e7          	jalr	966(ra) # 80000c3e <acquire>
                if (pp->state == ZOMBIE)
    80002880:	4a15                	li	s4,5
                havekids = 1;
    80002882:	4a85                	li	s5,1
        for (pp = proc; pp < &proc[NPROC]; pp++)
    80002884:	00015997          	auipc	s3,0x15
    80002888:	ebc98993          	addi	s3,s3,-324 # 80017740 <tickslock>
        sleep(p, &wait_lock); // DOC: wait-sleep
    8000288c:	0000fb97          	auipc	s7,0xf
    80002890:	81cb8b93          	addi	s7,s7,-2020 # 800110a8 <wait_lock>
    80002894:	a0c9                	j	80002956 <wait+0x108>
                    pid = pp->pid;
    80002896:	0304a983          	lw	s3,48(s1)
                    if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000289a:	000b0e63          	beqz	s6,800028b6 <wait+0x68>
    8000289e:	4691                	li	a3,4
    800028a0:	02c48613          	addi	a2,s1,44
    800028a4:	85da                	mv	a1,s6
    800028a6:	05093503          	ld	a0,80(s2)
    800028aa:	fffff097          	auipc	ra,0xfffff
    800028ae:	e66080e7          	jalr	-410(ra) # 80001710 <copyout>
    800028b2:	04054063          	bltz	a0,800028f2 <wait+0xa4>
                    freeproc(pp);
    800028b6:	8526                	mv	a0,s1
    800028b8:	fffff097          	auipc	ra,0xfffff
    800028bc:	67c080e7          	jalr	1660(ra) # 80001f34 <freeproc>
                    release(&pp->lock);
    800028c0:	8526                	mv	a0,s1
    800028c2:	ffffe097          	auipc	ra,0xffffe
    800028c6:	42c080e7          	jalr	1068(ra) # 80000cee <release>
                    release(&wait_lock);
    800028ca:	0000e517          	auipc	a0,0xe
    800028ce:	7de50513          	addi	a0,a0,2014 # 800110a8 <wait_lock>
    800028d2:	ffffe097          	auipc	ra,0xffffe
    800028d6:	41c080e7          	jalr	1052(ra) # 80000cee <release>
}
    800028da:	854e                	mv	a0,s3
    800028dc:	60a6                	ld	ra,72(sp)
    800028de:	6406                	ld	s0,64(sp)
    800028e0:	74e2                	ld	s1,56(sp)
    800028e2:	7942                	ld	s2,48(sp)
    800028e4:	79a2                	ld	s3,40(sp)
    800028e6:	7a02                	ld	s4,32(sp)
    800028e8:	6ae2                	ld	s5,24(sp)
    800028ea:	6b42                	ld	s6,16(sp)
    800028ec:	6ba2                	ld	s7,8(sp)
    800028ee:	6161                	addi	sp,sp,80
    800028f0:	8082                	ret
                        release(&pp->lock);
    800028f2:	8526                	mv	a0,s1
    800028f4:	ffffe097          	auipc	ra,0xffffe
    800028f8:	3fa080e7          	jalr	1018(ra) # 80000cee <release>
                        release(&wait_lock);
    800028fc:	0000e517          	auipc	a0,0xe
    80002900:	7ac50513          	addi	a0,a0,1964 # 800110a8 <wait_lock>
    80002904:	ffffe097          	auipc	ra,0xffffe
    80002908:	3ea080e7          	jalr	1002(ra) # 80000cee <release>
                        return -1;
    8000290c:	59fd                	li	s3,-1
    8000290e:	b7f1                	j	800028da <wait+0x8c>
        for (pp = proc; pp < &proc[NPROC]; pp++)
    80002910:	17848493          	addi	s1,s1,376
    80002914:	03348463          	beq	s1,s3,8000293c <wait+0xee>
            if (pp->parent == p)
    80002918:	7c9c                	ld	a5,56(s1)
    8000291a:	ff279be3          	bne	a5,s2,80002910 <wait+0xc2>
                acquire(&pp->lock);
    8000291e:	8526                	mv	a0,s1
    80002920:	ffffe097          	auipc	ra,0xffffe
    80002924:	31e080e7          	jalr	798(ra) # 80000c3e <acquire>
                if (pp->state == ZOMBIE)
    80002928:	4c9c                	lw	a5,24(s1)
    8000292a:	f74786e3          	beq	a5,s4,80002896 <wait+0x48>
                release(&pp->lock);
    8000292e:	8526                	mv	a0,s1
    80002930:	ffffe097          	auipc	ra,0xffffe
    80002934:	3be080e7          	jalr	958(ra) # 80000cee <release>
                havekids = 1;
    80002938:	8756                	mv	a4,s5
    8000293a:	bfd9                	j	80002910 <wait+0xc2>
        if (!havekids || killed(p))
    8000293c:	c31d                	beqz	a4,80002962 <wait+0x114>
    8000293e:	854a                	mv	a0,s2
    80002940:	00000097          	auipc	ra,0x0
    80002944:	edc080e7          	jalr	-292(ra) # 8000281c <killed>
    80002948:	ed09                	bnez	a0,80002962 <wait+0x114>
        sleep(p, &wait_lock); // DOC: wait-sleep
    8000294a:	85de                	mv	a1,s7
    8000294c:	854a                	mv	a0,s2
    8000294e:	00000097          	auipc	ra,0x0
    80002952:	c26080e7          	jalr	-986(ra) # 80002574 <sleep>
        havekids = 0;
    80002956:	4701                	li	a4,0
        for (pp = proc; pp < &proc[NPROC]; pp++)
    80002958:	0000f497          	auipc	s1,0xf
    8000295c:	fe848493          	addi	s1,s1,-24 # 80011940 <proc>
    80002960:	bf65                	j	80002918 <wait+0xca>
            release(&wait_lock);
    80002962:	0000e517          	auipc	a0,0xe
    80002966:	74650513          	addi	a0,a0,1862 # 800110a8 <wait_lock>
    8000296a:	ffffe097          	auipc	ra,0xffffe
    8000296e:	384080e7          	jalr	900(ra) # 80000cee <release>
            return -1;
    80002972:	59fd                	li	s3,-1
    80002974:	b79d                	j	800028da <wait+0x8c>

0000000080002976 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002976:	7179                	addi	sp,sp,-48
    80002978:	f406                	sd	ra,40(sp)
    8000297a:	f022                	sd	s0,32(sp)
    8000297c:	ec26                	sd	s1,24(sp)
    8000297e:	e84a                	sd	s2,16(sp)
    80002980:	e44e                	sd	s3,8(sp)
    80002982:	e052                	sd	s4,0(sp)
    80002984:	1800                	addi	s0,sp,48
    80002986:	84aa                	mv	s1,a0
    80002988:	892e                	mv	s2,a1
    8000298a:	89b2                	mv	s3,a2
    8000298c:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    8000298e:	fffff097          	auipc	ra,0xfffff
    80002992:	3f4080e7          	jalr	1012(ra) # 80001d82 <myproc>
    if (user_dst)
    80002996:	c08d                	beqz	s1,800029b8 <either_copyout+0x42>
    {
        return copyout(p->pagetable, dst, src, len);
    80002998:	86d2                	mv	a3,s4
    8000299a:	864e                	mv	a2,s3
    8000299c:	85ca                	mv	a1,s2
    8000299e:	6928                	ld	a0,80(a0)
    800029a0:	fffff097          	auipc	ra,0xfffff
    800029a4:	d70080e7          	jalr	-656(ra) # 80001710 <copyout>
    else
    {
        memmove((char *)dst, src, len);
        return 0;
    }
}
    800029a8:	70a2                	ld	ra,40(sp)
    800029aa:	7402                	ld	s0,32(sp)
    800029ac:	64e2                	ld	s1,24(sp)
    800029ae:	6942                	ld	s2,16(sp)
    800029b0:	69a2                	ld	s3,8(sp)
    800029b2:	6a02                	ld	s4,0(sp)
    800029b4:	6145                	addi	sp,sp,48
    800029b6:	8082                	ret
        memmove((char *)dst, src, len);
    800029b8:	000a061b          	sext.w	a2,s4
    800029bc:	85ce                	mv	a1,s3
    800029be:	854a                	mv	a0,s2
    800029c0:	ffffe097          	auipc	ra,0xffffe
    800029c4:	3da080e7          	jalr	986(ra) # 80000d9a <memmove>
        return 0;
    800029c8:	8526                	mv	a0,s1
    800029ca:	bff9                	j	800029a8 <either_copyout+0x32>

00000000800029cc <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800029cc:	7179                	addi	sp,sp,-48
    800029ce:	f406                	sd	ra,40(sp)
    800029d0:	f022                	sd	s0,32(sp)
    800029d2:	ec26                	sd	s1,24(sp)
    800029d4:	e84a                	sd	s2,16(sp)
    800029d6:	e44e                	sd	s3,8(sp)
    800029d8:	e052                	sd	s4,0(sp)
    800029da:	1800                	addi	s0,sp,48
    800029dc:	892a                	mv	s2,a0
    800029de:	84ae                	mv	s1,a1
    800029e0:	89b2                	mv	s3,a2
    800029e2:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    800029e4:	fffff097          	auipc	ra,0xfffff
    800029e8:	39e080e7          	jalr	926(ra) # 80001d82 <myproc>
    if (user_src)
    800029ec:	c08d                	beqz	s1,80002a0e <either_copyin+0x42>
    {
        return copyin(p->pagetable, dst, src, len);
    800029ee:	86d2                	mv	a3,s4
    800029f0:	864e                	mv	a2,s3
    800029f2:	85ca                	mv	a1,s2
    800029f4:	6928                	ld	a0,80(a0)
    800029f6:	fffff097          	auipc	ra,0xfffff
    800029fa:	da6080e7          	jalr	-602(ra) # 8000179c <copyin>
    else
    {
        memmove(dst, (char *)src, len);
        return 0;
    }
}
    800029fe:	70a2                	ld	ra,40(sp)
    80002a00:	7402                	ld	s0,32(sp)
    80002a02:	64e2                	ld	s1,24(sp)
    80002a04:	6942                	ld	s2,16(sp)
    80002a06:	69a2                	ld	s3,8(sp)
    80002a08:	6a02                	ld	s4,0(sp)
    80002a0a:	6145                	addi	sp,sp,48
    80002a0c:	8082                	ret
        memmove(dst, (char *)src, len);
    80002a0e:	000a061b          	sext.w	a2,s4
    80002a12:	85ce                	mv	a1,s3
    80002a14:	854a                	mv	a0,s2
    80002a16:	ffffe097          	auipc	ra,0xffffe
    80002a1a:	384080e7          	jalr	900(ra) # 80000d9a <memmove>
        return 0;
    80002a1e:	8526                	mv	a0,s1
    80002a20:	bff9                	j	800029fe <either_copyin+0x32>

0000000080002a22 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    80002a22:	715d                	addi	sp,sp,-80
    80002a24:	e486                	sd	ra,72(sp)
    80002a26:	e0a2                	sd	s0,64(sp)
    80002a28:	fc26                	sd	s1,56(sp)
    80002a2a:	f84a                	sd	s2,48(sp)
    80002a2c:	f44e                	sd	s3,40(sp)
    80002a2e:	f052                	sd	s4,32(sp)
    80002a30:	ec56                	sd	s5,24(sp)
    80002a32:	e85a                	sd	s6,16(sp)
    80002a34:	e45e                	sd	s7,8(sp)
    80002a36:	0880                	addi	s0,sp,80
        [RUNNING] "run   ",
        [ZOMBIE] "zombie"};
    struct proc *p;
    char *state;

    printf("\n");
    80002a38:	00005517          	auipc	a0,0x5
    80002a3c:	5d850513          	addi	a0,a0,1496 # 80008010 <etext+0x10>
    80002a40:	ffffe097          	auipc	ra,0xffffe
    80002a44:	b6a080e7          	jalr	-1174(ra) # 800005aa <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80002a48:	0000f497          	auipc	s1,0xf
    80002a4c:	05048493          	addi	s1,s1,80 # 80011a98 <proc+0x158>
    80002a50:	00015917          	auipc	s2,0x15
    80002a54:	e4890913          	addi	s2,s2,-440 # 80017898 <bcache+0x140>
    {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002a58:	4b15                	li	s6,5
            state = states[p->state];
        else
            state = "???";
    80002a5a:	00006997          	auipc	s3,0x6
    80002a5e:	82698993          	addi	s3,s3,-2010 # 80008280 <etext+0x280>
        printf("%d <%s %s", p->pid, state, p->name);
    80002a62:	00006a97          	auipc	s5,0x6
    80002a66:	826a8a93          	addi	s5,s5,-2010 # 80008288 <etext+0x288>
        printf("\n");
    80002a6a:	00005a17          	auipc	s4,0x5
    80002a6e:	5a6a0a13          	addi	s4,s4,1446 # 80008010 <etext+0x10>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002a72:	00006b97          	auipc	s7,0x6
    80002a76:	dbeb8b93          	addi	s7,s7,-578 # 80008830 <states.0>
    80002a7a:	a00d                	j	80002a9c <procdump+0x7a>
        printf("%d <%s %s", p->pid, state, p->name);
    80002a7c:	ed86a583          	lw	a1,-296(a3)
    80002a80:	8556                	mv	a0,s5
    80002a82:	ffffe097          	auipc	ra,0xffffe
    80002a86:	b28080e7          	jalr	-1240(ra) # 800005aa <printf>
        printf("\n");
    80002a8a:	8552                	mv	a0,s4
    80002a8c:	ffffe097          	auipc	ra,0xffffe
    80002a90:	b1e080e7          	jalr	-1250(ra) # 800005aa <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80002a94:	17848493          	addi	s1,s1,376
    80002a98:	03248263          	beq	s1,s2,80002abc <procdump+0x9a>
        if (p->state == UNUSED)
    80002a9c:	86a6                	mv	a3,s1
    80002a9e:	ec04a783          	lw	a5,-320(s1)
    80002aa2:	dbed                	beqz	a5,80002a94 <procdump+0x72>
            state = "???";
    80002aa4:	864e                	mv	a2,s3
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002aa6:	fcfb6be3          	bltu	s6,a5,80002a7c <procdump+0x5a>
    80002aaa:	02079713          	slli	a4,a5,0x20
    80002aae:	01d75793          	srli	a5,a4,0x1d
    80002ab2:	97de                	add	a5,a5,s7
    80002ab4:	6390                	ld	a2,0(a5)
    80002ab6:	f279                	bnez	a2,80002a7c <procdump+0x5a>
            state = "???";
    80002ab8:	864e                	mv	a2,s3
    80002aba:	b7c9                	j	80002a7c <procdump+0x5a>
    }
}
    80002abc:	60a6                	ld	ra,72(sp)
    80002abe:	6406                	ld	s0,64(sp)
    80002ac0:	74e2                	ld	s1,56(sp)
    80002ac2:	7942                	ld	s2,48(sp)
    80002ac4:	79a2                	ld	s3,40(sp)
    80002ac6:	7a02                	ld	s4,32(sp)
    80002ac8:	6ae2                	ld	s5,24(sp)
    80002aca:	6b42                	ld	s6,16(sp)
    80002acc:	6ba2                	ld	s7,8(sp)
    80002ace:	6161                	addi	sp,sp,80
    80002ad0:	8082                	ret

0000000080002ad2 <schedls>:

void schedls()
{
    80002ad2:	1101                	addi	sp,sp,-32
    80002ad4:	ec06                	sd	ra,24(sp)
    80002ad6:	e822                	sd	s0,16(sp)
    80002ad8:	e426                	sd	s1,8(sp)
    80002ada:	1000                	addi	s0,sp,32
    printf("[ ]\tScheduler Name\tScheduler ID\n");
    80002adc:	00005517          	auipc	a0,0x5
    80002ae0:	7bc50513          	addi	a0,a0,1980 # 80008298 <etext+0x298>
    80002ae4:	ffffe097          	auipc	ra,0xffffe
    80002ae8:	ac6080e7          	jalr	-1338(ra) # 800005aa <printf>
    printf("====================================\n");
    80002aec:	00005517          	auipc	a0,0x5
    80002af0:	7d450513          	addi	a0,a0,2004 # 800082c0 <etext+0x2c0>
    80002af4:	ffffe097          	auipc	ra,0xffffe
    80002af8:	ab6080e7          	jalr	-1354(ra) # 800005aa <printf>
    for (int i = 0; i < SCHEDC; i++)
    {
        if (available_schedulers[i].impl == sched_pointer)
    80002afc:	00006717          	auipc	a4,0x6
    80002b00:	ebc73703          	ld	a4,-324(a4) # 800089b8 <available_schedulers+0x10>
    80002b04:	00006797          	auipc	a5,0x6
    80002b08:	e547b783          	ld	a5,-428(a5) # 80008958 <sched_pointer>
    80002b0c:	08f70763          	beq	a4,a5,80002b9a <schedls+0xc8>
        {
            printf("[*]\t");
        }
        else
        {
            printf("   \t");
    80002b10:	00005517          	auipc	a0,0x5
    80002b14:	7d850513          	addi	a0,a0,2008 # 800082e8 <etext+0x2e8>
    80002b18:	ffffe097          	auipc	ra,0xffffe
    80002b1c:	a92080e7          	jalr	-1390(ra) # 800005aa <printf>
        }
        printf("%s\t%d\n", available_schedulers[i].name, available_schedulers[i].id);
    80002b20:	00006497          	auipc	s1,0x6
    80002b24:	e5048493          	addi	s1,s1,-432 # 80008970 <initcode>
    80002b28:	48b0                	lw	a2,80(s1)
    80002b2a:	00006597          	auipc	a1,0x6
    80002b2e:	e7e58593          	addi	a1,a1,-386 # 800089a8 <available_schedulers>
    80002b32:	00005517          	auipc	a0,0x5
    80002b36:	7c650513          	addi	a0,a0,1990 # 800082f8 <etext+0x2f8>
    80002b3a:	ffffe097          	auipc	ra,0xffffe
    80002b3e:	a70080e7          	jalr	-1424(ra) # 800005aa <printf>
        if (available_schedulers[i].impl == sched_pointer)
    80002b42:	74b8                	ld	a4,104(s1)
    80002b44:	00006797          	auipc	a5,0x6
    80002b48:	e147b783          	ld	a5,-492(a5) # 80008958 <sched_pointer>
    80002b4c:	06f70063          	beq	a4,a5,80002bac <schedls+0xda>
            printf("   \t");
    80002b50:	00005517          	auipc	a0,0x5
    80002b54:	79850513          	addi	a0,a0,1944 # 800082e8 <etext+0x2e8>
    80002b58:	ffffe097          	auipc	ra,0xffffe
    80002b5c:	a52080e7          	jalr	-1454(ra) # 800005aa <printf>
        printf("%s\t%d\n", available_schedulers[i].name, available_schedulers[i].id);
    80002b60:	00006617          	auipc	a2,0x6
    80002b64:	e8062603          	lw	a2,-384(a2) # 800089e0 <available_schedulers+0x38>
    80002b68:	00006597          	auipc	a1,0x6
    80002b6c:	e6058593          	addi	a1,a1,-416 # 800089c8 <available_schedulers+0x20>
    80002b70:	00005517          	auipc	a0,0x5
    80002b74:	78850513          	addi	a0,a0,1928 # 800082f8 <etext+0x2f8>
    80002b78:	ffffe097          	auipc	ra,0xffffe
    80002b7c:	a32080e7          	jalr	-1486(ra) # 800005aa <printf>
    }
    printf("\n*: current scheduler\n\n");
    80002b80:	00005517          	auipc	a0,0x5
    80002b84:	78050513          	addi	a0,a0,1920 # 80008300 <etext+0x300>
    80002b88:	ffffe097          	auipc	ra,0xffffe
    80002b8c:	a22080e7          	jalr	-1502(ra) # 800005aa <printf>
}
    80002b90:	60e2                	ld	ra,24(sp)
    80002b92:	6442                	ld	s0,16(sp)
    80002b94:	64a2                	ld	s1,8(sp)
    80002b96:	6105                	addi	sp,sp,32
    80002b98:	8082                	ret
            printf("[*]\t");
    80002b9a:	00005517          	auipc	a0,0x5
    80002b9e:	75650513          	addi	a0,a0,1878 # 800082f0 <etext+0x2f0>
    80002ba2:	ffffe097          	auipc	ra,0xffffe
    80002ba6:	a08080e7          	jalr	-1528(ra) # 800005aa <printf>
    80002baa:	bf9d                	j	80002b20 <schedls+0x4e>
    80002bac:	00005517          	auipc	a0,0x5
    80002bb0:	74450513          	addi	a0,a0,1860 # 800082f0 <etext+0x2f0>
    80002bb4:	ffffe097          	auipc	ra,0xffffe
    80002bb8:	9f6080e7          	jalr	-1546(ra) # 800005aa <printf>
    80002bbc:	b755                	j	80002b60 <schedls+0x8e>

0000000080002bbe <schedset>:

void schedset(int id)
{
    80002bbe:	1141                	addi	sp,sp,-16
    80002bc0:	e406                	sd	ra,8(sp)
    80002bc2:	e022                	sd	s0,0(sp)
    80002bc4:	0800                	addi	s0,sp,16
    if (id < 0 || SCHEDC <= id)
    80002bc6:	4785                	li	a5,1
    80002bc8:	02a7ee63          	bltu	a5,a0,80002c04 <schedset+0x46>
    {
        printf("Scheduler unchanged: ID out of range\n");
        return;
    }
    sched_pointer = available_schedulers[id].impl;
    80002bcc:	0516                	slli	a0,a0,0x5
    80002bce:	00006797          	auipc	a5,0x6
    80002bd2:	da278793          	addi	a5,a5,-606 # 80008970 <initcode>
    80002bd6:	97aa                	add	a5,a5,a0
    80002bd8:	67bc                	ld	a5,72(a5)
    80002bda:	00006717          	auipc	a4,0x6
    80002bde:	d6f73f23          	sd	a5,-642(a4) # 80008958 <sched_pointer>
    printf("Scheduler successfully changed to %s\n", available_schedulers[id].name);
    80002be2:	00006597          	auipc	a1,0x6
    80002be6:	dc658593          	addi	a1,a1,-570 # 800089a8 <available_schedulers>
    80002bea:	95aa                	add	a1,a1,a0
    80002bec:	00005517          	auipc	a0,0x5
    80002bf0:	75450513          	addi	a0,a0,1876 # 80008340 <etext+0x340>
    80002bf4:	ffffe097          	auipc	ra,0xffffe
    80002bf8:	9b6080e7          	jalr	-1610(ra) # 800005aa <printf>
}
    80002bfc:	60a2                	ld	ra,8(sp)
    80002bfe:	6402                	ld	s0,0(sp)
    80002c00:	0141                	addi	sp,sp,16
    80002c02:	8082                	ret
        printf("Scheduler unchanged: ID out of range\n");
    80002c04:	00005517          	auipc	a0,0x5
    80002c08:	71450513          	addi	a0,a0,1812 # 80008318 <etext+0x318>
    80002c0c:	ffffe097          	auipc	ra,0xffffe
    80002c10:	99e080e7          	jalr	-1634(ra) # 800005aa <printf>
        return;
    80002c14:	b7e5                	j	80002bfc <schedset+0x3e>

0000000080002c16 <swtch>:
    80002c16:	00153023          	sd	ra,0(a0)
    80002c1a:	00253423          	sd	sp,8(a0)
    80002c1e:	e900                	sd	s0,16(a0)
    80002c20:	ed04                	sd	s1,24(a0)
    80002c22:	03253023          	sd	s2,32(a0)
    80002c26:	03353423          	sd	s3,40(a0)
    80002c2a:	03453823          	sd	s4,48(a0)
    80002c2e:	03553c23          	sd	s5,56(a0)
    80002c32:	05653023          	sd	s6,64(a0)
    80002c36:	05753423          	sd	s7,72(a0)
    80002c3a:	05853823          	sd	s8,80(a0)
    80002c3e:	05953c23          	sd	s9,88(a0)
    80002c42:	07a53023          	sd	s10,96(a0)
    80002c46:	07b53423          	sd	s11,104(a0)
    80002c4a:	0005b083          	ld	ra,0(a1)
    80002c4e:	0085b103          	ld	sp,8(a1)
    80002c52:	6980                	ld	s0,16(a1)
    80002c54:	6d84                	ld	s1,24(a1)
    80002c56:	0205b903          	ld	s2,32(a1)
    80002c5a:	0285b983          	ld	s3,40(a1)
    80002c5e:	0305ba03          	ld	s4,48(a1)
    80002c62:	0385ba83          	ld	s5,56(a1)
    80002c66:	0405bb03          	ld	s6,64(a1)
    80002c6a:	0485bb83          	ld	s7,72(a1)
    80002c6e:	0505bc03          	ld	s8,80(a1)
    80002c72:	0585bc83          	ld	s9,88(a1)
    80002c76:	0605bd03          	ld	s10,96(a1)
    80002c7a:	0685bd83          	ld	s11,104(a1)
    80002c7e:	8082                	ret

0000000080002c80 <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80002c80:	1141                	addi	sp,sp,-16
    80002c82:	e406                	sd	ra,8(sp)
    80002c84:	e022                	sd	s0,0(sp)
    80002c86:	0800                	addi	s0,sp,16
    initlock(&tickslock, "time");
    80002c88:	00005597          	auipc	a1,0x5
    80002c8c:	71058593          	addi	a1,a1,1808 # 80008398 <etext+0x398>
    80002c90:	00015517          	auipc	a0,0x15
    80002c94:	ab050513          	addi	a0,a0,-1360 # 80017740 <tickslock>
    80002c98:	ffffe097          	auipc	ra,0xffffe
    80002c9c:	f12080e7          	jalr	-238(ra) # 80000baa <initlock>
}
    80002ca0:	60a2                	ld	ra,8(sp)
    80002ca2:	6402                	ld	s0,0(sp)
    80002ca4:	0141                	addi	sp,sp,16
    80002ca6:	8082                	ret

0000000080002ca8 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80002ca8:	1141                	addi	sp,sp,-16
    80002caa:	e406                	sd	ra,8(sp)
    80002cac:	e022                	sd	s0,0(sp)
    80002cae:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002cb0:	00003797          	auipc	a5,0x3
    80002cb4:	69078793          	addi	a5,a5,1680 # 80006340 <kernelvec>
    80002cb8:	10579073          	csrw	stvec,a5
    w_stvec((uint64)kernelvec);
}
    80002cbc:	60a2                	ld	ra,8(sp)
    80002cbe:	6402                	ld	s0,0(sp)
    80002cc0:	0141                	addi	sp,sp,16
    80002cc2:	8082                	ret

0000000080002cc4 <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80002cc4:	1141                	addi	sp,sp,-16
    80002cc6:	e406                	sd	ra,8(sp)
    80002cc8:	e022                	sd	s0,0(sp)
    80002cca:	0800                	addi	s0,sp,16
    struct proc *p = myproc();
    80002ccc:	fffff097          	auipc	ra,0xfffff
    80002cd0:	0b6080e7          	jalr	182(ra) # 80001d82 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002cd4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002cd8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002cda:	10079073          	csrw	sstatus,a5
    // kerneltrap() to usertrap(), so turn off interrupts until
    // we're back in user space, where usertrap() is correct.
    intr_off();

    // send syscalls, interrupts, and exceptions to uservec in trampoline.S
    uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002cde:	00004697          	auipc	a3,0x4
    80002ce2:	32268693          	addi	a3,a3,802 # 80007000 <_trampoline>
    80002ce6:	00004717          	auipc	a4,0x4
    80002cea:	31a70713          	addi	a4,a4,794 # 80007000 <_trampoline>
    80002cee:	8f15                	sub	a4,a4,a3
    80002cf0:	040007b7          	lui	a5,0x4000
    80002cf4:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002cf6:	07b2                	slli	a5,a5,0xc
    80002cf8:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002cfa:	10571073          	csrw	stvec,a4
    w_stvec(trampoline_uservec);

    // set up trapframe values that uservec will need when
    // the process next traps into the kernel.
    p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002cfe:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002d00:	18002673          	csrr	a2,satp
    80002d04:	e310                	sd	a2,0(a4)
    p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002d06:	6d30                	ld	a2,88(a0)
    80002d08:	6138                	ld	a4,64(a0)
    80002d0a:	6585                	lui	a1,0x1
    80002d0c:	972e                	add	a4,a4,a1
    80002d0e:	e618                	sd	a4,8(a2)
    p->trapframe->kernel_trap = (uint64)usertrap;
    80002d10:	6d38                	ld	a4,88(a0)
    80002d12:	00000617          	auipc	a2,0x0
    80002d16:	13860613          	addi	a2,a2,312 # 80002e4a <usertrap>
    80002d1a:	eb10                	sd	a2,16(a4)
    p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002d1c:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002d1e:	8612                	mv	a2,tp
    80002d20:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d22:	10002773          	csrr	a4,sstatus
    // set up the registers that trampoline.S's sret will use
    // to get to user space.

    // set S Previous Privilege mode to User.
    unsigned long x = r_sstatus();
    x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002d26:	eff77713          	andi	a4,a4,-257
    x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002d2a:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002d2e:	10071073          	csrw	sstatus,a4
    w_sstatus(x);

    // set S Exception Program Counter to the saved user pc.
    w_sepc(p->trapframe->epc);
    80002d32:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002d34:	6f18                	ld	a4,24(a4)
    80002d36:	14171073          	csrw	sepc,a4

    // tell trampoline.S the user page table to switch to.
    uint64 satp = MAKE_SATP(p->pagetable);
    80002d3a:	6928                	ld	a0,80(a0)
    80002d3c:	8131                	srli	a0,a0,0xc

    // jump to userret in trampoline.S at the top of memory, which
    // switches to the user page table, restores user registers,
    // and switches to user mode with sret.
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002d3e:	00004717          	auipc	a4,0x4
    80002d42:	35e70713          	addi	a4,a4,862 # 8000709c <userret>
    80002d46:	8f15                	sub	a4,a4,a3
    80002d48:	97ba                	add	a5,a5,a4
    ((void (*)(uint64))trampoline_userret)(satp);
    80002d4a:	577d                	li	a4,-1
    80002d4c:	177e                	slli	a4,a4,0x3f
    80002d4e:	8d59                	or	a0,a0,a4
    80002d50:	9782                	jalr	a5
}
    80002d52:	60a2                	ld	ra,8(sp)
    80002d54:	6402                	ld	s0,0(sp)
    80002d56:	0141                	addi	sp,sp,16
    80002d58:	8082                	ret

0000000080002d5a <clockintr>:
    w_sepc(sepc);
    w_sstatus(sstatus);
}

void clockintr()
{
    80002d5a:	1101                	addi	sp,sp,-32
    80002d5c:	ec06                	sd	ra,24(sp)
    80002d5e:	e822                	sd	s0,16(sp)
    80002d60:	e426                	sd	s1,8(sp)
    80002d62:	1000                	addi	s0,sp,32
    acquire(&tickslock);
    80002d64:	00015497          	auipc	s1,0x15
    80002d68:	9dc48493          	addi	s1,s1,-1572 # 80017740 <tickslock>
    80002d6c:	8526                	mv	a0,s1
    80002d6e:	ffffe097          	auipc	ra,0xffffe
    80002d72:	ed0080e7          	jalr	-304(ra) # 80000c3e <acquire>
    ticks++;
    80002d76:	00006517          	auipc	a0,0x6
    80002d7a:	caa50513          	addi	a0,a0,-854 # 80008a20 <ticks>
    80002d7e:	411c                	lw	a5,0(a0)
    80002d80:	2785                	addiw	a5,a5,1
    80002d82:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80002d84:	00000097          	auipc	ra,0x0
    80002d88:	854080e7          	jalr	-1964(ra) # 800025d8 <wakeup>
    release(&tickslock);
    80002d8c:	8526                	mv	a0,s1
    80002d8e:	ffffe097          	auipc	ra,0xffffe
    80002d92:	f60080e7          	jalr	-160(ra) # 80000cee <release>
}
    80002d96:	60e2                	ld	ra,24(sp)
    80002d98:	6442                	ld	s0,16(sp)
    80002d9a:	64a2                	ld	s1,8(sp)
    80002d9c:	6105                	addi	sp,sp,32
    80002d9e:	8082                	ret

0000000080002da0 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002da0:	142027f3          	csrr	a5,scause

        return 2;
    }
    else
    {
        return 0;
    80002da4:	4501                	li	a0,0
    if ((scause & 0x8000000000000000L) &&
    80002da6:	0a07d163          	bgez	a5,80002e48 <devintr+0xa8>
{
    80002daa:	1101                	addi	sp,sp,-32
    80002dac:	ec06                	sd	ra,24(sp)
    80002dae:	e822                	sd	s0,16(sp)
    80002db0:	1000                	addi	s0,sp,32
        (scause & 0xff) == 9)
    80002db2:	0ff7f713          	zext.b	a4,a5
    if ((scause & 0x8000000000000000L) &&
    80002db6:	46a5                	li	a3,9
    80002db8:	00d70c63          	beq	a4,a3,80002dd0 <devintr+0x30>
    else if (scause == 0x8000000000000001L)
    80002dbc:	577d                	li	a4,-1
    80002dbe:	177e                	slli	a4,a4,0x3f
    80002dc0:	0705                	addi	a4,a4,1
        return 0;
    80002dc2:	4501                	li	a0,0
    else if (scause == 0x8000000000000001L)
    80002dc4:	06e78163          	beq	a5,a4,80002e26 <devintr+0x86>
    }
}
    80002dc8:	60e2                	ld	ra,24(sp)
    80002dca:	6442                	ld	s0,16(sp)
    80002dcc:	6105                	addi	sp,sp,32
    80002dce:	8082                	ret
    80002dd0:	e426                	sd	s1,8(sp)
        int irq = plic_claim();
    80002dd2:	00003097          	auipc	ra,0x3
    80002dd6:	67a080e7          	jalr	1658(ra) # 8000644c <plic_claim>
    80002dda:	84aa                	mv	s1,a0
        if (irq == UART0_IRQ)
    80002ddc:	47a9                	li	a5,10
    80002dde:	00f50963          	beq	a0,a5,80002df0 <devintr+0x50>
        else if (irq == VIRTIO0_IRQ)
    80002de2:	4785                	li	a5,1
    80002de4:	00f50b63          	beq	a0,a5,80002dfa <devintr+0x5a>
        return 1;
    80002de8:	4505                	li	a0,1
        else if (irq)
    80002dea:	ec89                	bnez	s1,80002e04 <devintr+0x64>
    80002dec:	64a2                	ld	s1,8(sp)
    80002dee:	bfe9                	j	80002dc8 <devintr+0x28>
            uartintr();
    80002df0:	ffffe097          	auipc	ra,0xffffe
    80002df4:	c0c080e7          	jalr	-1012(ra) # 800009fc <uartintr>
        if (irq)
    80002df8:	a839                	j	80002e16 <devintr+0x76>
            virtio_disk_intr();
    80002dfa:	00004097          	auipc	ra,0x4
    80002dfe:	b46080e7          	jalr	-1210(ra) # 80006940 <virtio_disk_intr>
        if (irq)
    80002e02:	a811                	j	80002e16 <devintr+0x76>
            printf("unexpected interrupt irq=%d\n", irq);
    80002e04:	85a6                	mv	a1,s1
    80002e06:	00005517          	auipc	a0,0x5
    80002e0a:	59a50513          	addi	a0,a0,1434 # 800083a0 <etext+0x3a0>
    80002e0e:	ffffd097          	auipc	ra,0xffffd
    80002e12:	79c080e7          	jalr	1948(ra) # 800005aa <printf>
            plic_complete(irq);
    80002e16:	8526                	mv	a0,s1
    80002e18:	00003097          	auipc	ra,0x3
    80002e1c:	658080e7          	jalr	1624(ra) # 80006470 <plic_complete>
        return 1;
    80002e20:	4505                	li	a0,1
    80002e22:	64a2                	ld	s1,8(sp)
    80002e24:	b755                	j	80002dc8 <devintr+0x28>
        if (cpuid() == 0)
    80002e26:	fffff097          	auipc	ra,0xfffff
    80002e2a:	f28080e7          	jalr	-216(ra) # 80001d4e <cpuid>
    80002e2e:	c901                	beqz	a0,80002e3e <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002e30:	144027f3          	csrr	a5,sip
        w_sip(r_sip() & ~2);
    80002e34:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002e36:	14479073          	csrw	sip,a5
        return 2;
    80002e3a:	4509                	li	a0,2
    80002e3c:	b771                	j	80002dc8 <devintr+0x28>
            clockintr();
    80002e3e:	00000097          	auipc	ra,0x0
    80002e42:	f1c080e7          	jalr	-228(ra) # 80002d5a <clockintr>
    80002e46:	b7ed                	j	80002e30 <devintr+0x90>
}
    80002e48:	8082                	ret

0000000080002e4a <usertrap>:
{
    80002e4a:	1101                	addi	sp,sp,-32
    80002e4c:	ec06                	sd	ra,24(sp)
    80002e4e:	e822                	sd	s0,16(sp)
    80002e50:	e426                	sd	s1,8(sp)
    80002e52:	e04a                	sd	s2,0(sp)
    80002e54:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e56:	100027f3          	csrr	a5,sstatus
    if ((r_sstatus() & SSTATUS_SPP) != 0)
    80002e5a:	1007f793          	andi	a5,a5,256
    80002e5e:	e3b1                	bnez	a5,80002ea2 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002e60:	00003797          	auipc	a5,0x3
    80002e64:	4e078793          	addi	a5,a5,1248 # 80006340 <kernelvec>
    80002e68:	10579073          	csrw	stvec,a5
    struct proc *p = myproc();
    80002e6c:	fffff097          	auipc	ra,0xfffff
    80002e70:	f16080e7          	jalr	-234(ra) # 80001d82 <myproc>
    80002e74:	84aa                	mv	s1,a0
    p->trapframe->epc = r_sepc();
    80002e76:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002e78:	14102773          	csrr	a4,sepc
    80002e7c:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002e7e:	14202773          	csrr	a4,scause
    if (r_scause() == 8)
    80002e82:	47a1                	li	a5,8
    80002e84:	02f70763          	beq	a4,a5,80002eb2 <usertrap+0x68>
    else if ((which_dev = devintr()) != 0)
    80002e88:	00000097          	auipc	ra,0x0
    80002e8c:	f18080e7          	jalr	-232(ra) # 80002da0 <devintr>
    80002e90:	892a                	mv	s2,a0
    80002e92:	c151                	beqz	a0,80002f16 <usertrap+0xcc>
    if (killed(p))
    80002e94:	8526                	mv	a0,s1
    80002e96:	00000097          	auipc	ra,0x0
    80002e9a:	986080e7          	jalr	-1658(ra) # 8000281c <killed>
    80002e9e:	c929                	beqz	a0,80002ef0 <usertrap+0xa6>
    80002ea0:	a099                	j	80002ee6 <usertrap+0x9c>
        panic("usertrap: not from user mode");
    80002ea2:	00005517          	auipc	a0,0x5
    80002ea6:	51e50513          	addi	a0,a0,1310 # 800083c0 <etext+0x3c0>
    80002eaa:	ffffd097          	auipc	ra,0xffffd
    80002eae:	6b6080e7          	jalr	1718(ra) # 80000560 <panic>
        if (killed(p))
    80002eb2:	00000097          	auipc	ra,0x0
    80002eb6:	96a080e7          	jalr	-1686(ra) # 8000281c <killed>
    80002eba:	e921                	bnez	a0,80002f0a <usertrap+0xc0>
        p->trapframe->epc += 4;
    80002ebc:	6cb8                	ld	a4,88(s1)
    80002ebe:	6f1c                	ld	a5,24(a4)
    80002ec0:	0791                	addi	a5,a5,4
    80002ec2:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ec4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002ec8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002ecc:	10079073          	csrw	sstatus,a5
        syscall();
    80002ed0:	00000097          	auipc	ra,0x0
    80002ed4:	2d0080e7          	jalr	720(ra) # 800031a0 <syscall>
    if (killed(p))
    80002ed8:	8526                	mv	a0,s1
    80002eda:	00000097          	auipc	ra,0x0
    80002ede:	942080e7          	jalr	-1726(ra) # 8000281c <killed>
    80002ee2:	c911                	beqz	a0,80002ef6 <usertrap+0xac>
    80002ee4:	4901                	li	s2,0
        exit(-1);
    80002ee6:	557d                	li	a0,-1
    80002ee8:	fffff097          	auipc	ra,0xfffff
    80002eec:	7c0080e7          	jalr	1984(ra) # 800026a8 <exit>
    if (which_dev == 2)
    80002ef0:	4789                	li	a5,2
    80002ef2:	04f90f63          	beq	s2,a5,80002f50 <usertrap+0x106>
    usertrapret();
    80002ef6:	00000097          	auipc	ra,0x0
    80002efa:	dce080e7          	jalr	-562(ra) # 80002cc4 <usertrapret>
}
    80002efe:	60e2                	ld	ra,24(sp)
    80002f00:	6442                	ld	s0,16(sp)
    80002f02:	64a2                	ld	s1,8(sp)
    80002f04:	6902                	ld	s2,0(sp)
    80002f06:	6105                	addi	sp,sp,32
    80002f08:	8082                	ret
            exit(-1);
    80002f0a:	557d                	li	a0,-1
    80002f0c:	fffff097          	auipc	ra,0xfffff
    80002f10:	79c080e7          	jalr	1948(ra) # 800026a8 <exit>
    80002f14:	b765                	j	80002ebc <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002f16:	142025f3          	csrr	a1,scause
        printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002f1a:	5890                	lw	a2,48(s1)
    80002f1c:	00005517          	auipc	a0,0x5
    80002f20:	4c450513          	addi	a0,a0,1220 # 800083e0 <etext+0x3e0>
    80002f24:	ffffd097          	auipc	ra,0xffffd
    80002f28:	686080e7          	jalr	1670(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002f2c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002f30:	14302673          	csrr	a2,stval
        printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002f34:	00005517          	auipc	a0,0x5
    80002f38:	4dc50513          	addi	a0,a0,1244 # 80008410 <etext+0x410>
    80002f3c:	ffffd097          	auipc	ra,0xffffd
    80002f40:	66e080e7          	jalr	1646(ra) # 800005aa <printf>
        setkilled(p);
    80002f44:	8526                	mv	a0,s1
    80002f46:	00000097          	auipc	ra,0x0
    80002f4a:	8aa080e7          	jalr	-1878(ra) # 800027f0 <setkilled>
    80002f4e:	b769                	j	80002ed8 <usertrap+0x8e>
        yield(YIELD_TIMER);
    80002f50:	4505                	li	a0,1
    80002f52:	fffff097          	auipc	ra,0xfffff
    80002f56:	5e6080e7          	jalr	1510(ra) # 80002538 <yield>
    80002f5a:	bf71                	j	80002ef6 <usertrap+0xac>

0000000080002f5c <kerneltrap>:
{
    80002f5c:	7179                	addi	sp,sp,-48
    80002f5e:	f406                	sd	ra,40(sp)
    80002f60:	f022                	sd	s0,32(sp)
    80002f62:	ec26                	sd	s1,24(sp)
    80002f64:	e84a                	sd	s2,16(sp)
    80002f66:	e44e                	sd	s3,8(sp)
    80002f68:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002f6a:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002f6e:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002f72:	142029f3          	csrr	s3,scause
    if ((sstatus & SSTATUS_SPP) == 0)
    80002f76:	1004f793          	andi	a5,s1,256
    80002f7a:	cb85                	beqz	a5,80002faa <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002f7c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002f80:	8b89                	andi	a5,a5,2
    if (intr_get() != 0)
    80002f82:	ef85                	bnez	a5,80002fba <kerneltrap+0x5e>
    if ((which_dev = devintr()) == 0)
    80002f84:	00000097          	auipc	ra,0x0
    80002f88:	e1c080e7          	jalr	-484(ra) # 80002da0 <devintr>
    80002f8c:	cd1d                	beqz	a0,80002fca <kerneltrap+0x6e>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002f8e:	4789                	li	a5,2
    80002f90:	06f50a63          	beq	a0,a5,80003004 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002f94:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002f98:	10049073          	csrw	sstatus,s1
}
    80002f9c:	70a2                	ld	ra,40(sp)
    80002f9e:	7402                	ld	s0,32(sp)
    80002fa0:	64e2                	ld	s1,24(sp)
    80002fa2:	6942                	ld	s2,16(sp)
    80002fa4:	69a2                	ld	s3,8(sp)
    80002fa6:	6145                	addi	sp,sp,48
    80002fa8:	8082                	ret
        panic("kerneltrap: not from supervisor mode");
    80002faa:	00005517          	auipc	a0,0x5
    80002fae:	48650513          	addi	a0,a0,1158 # 80008430 <etext+0x430>
    80002fb2:	ffffd097          	auipc	ra,0xffffd
    80002fb6:	5ae080e7          	jalr	1454(ra) # 80000560 <panic>
        panic("kerneltrap: interrupts enabled");
    80002fba:	00005517          	auipc	a0,0x5
    80002fbe:	49e50513          	addi	a0,a0,1182 # 80008458 <etext+0x458>
    80002fc2:	ffffd097          	auipc	ra,0xffffd
    80002fc6:	59e080e7          	jalr	1438(ra) # 80000560 <panic>
        printf("scause %p\n", scause);
    80002fca:	85ce                	mv	a1,s3
    80002fcc:	00005517          	auipc	a0,0x5
    80002fd0:	4ac50513          	addi	a0,a0,1196 # 80008478 <etext+0x478>
    80002fd4:	ffffd097          	auipc	ra,0xffffd
    80002fd8:	5d6080e7          	jalr	1494(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002fdc:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002fe0:	14302673          	csrr	a2,stval
        printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002fe4:	00005517          	auipc	a0,0x5
    80002fe8:	4a450513          	addi	a0,a0,1188 # 80008488 <etext+0x488>
    80002fec:	ffffd097          	auipc	ra,0xffffd
    80002ff0:	5be080e7          	jalr	1470(ra) # 800005aa <printf>
        panic("kerneltrap");
    80002ff4:	00005517          	auipc	a0,0x5
    80002ff8:	4ac50513          	addi	a0,a0,1196 # 800084a0 <etext+0x4a0>
    80002ffc:	ffffd097          	auipc	ra,0xffffd
    80003000:	564080e7          	jalr	1380(ra) # 80000560 <panic>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80003004:	fffff097          	auipc	ra,0xfffff
    80003008:	d7e080e7          	jalr	-642(ra) # 80001d82 <myproc>
    8000300c:	d541                	beqz	a0,80002f94 <kerneltrap+0x38>
    8000300e:	fffff097          	auipc	ra,0xfffff
    80003012:	d74080e7          	jalr	-652(ra) # 80001d82 <myproc>
    80003016:	4d18                	lw	a4,24(a0)
    80003018:	4791                	li	a5,4
    8000301a:	f6f71de3          	bne	a4,a5,80002f94 <kerneltrap+0x38>
        yield(YIELD_OTHER);
    8000301e:	4509                	li	a0,2
    80003020:	fffff097          	auipc	ra,0xfffff
    80003024:	518080e7          	jalr	1304(ra) # 80002538 <yield>
    80003028:	b7b5                	j	80002f94 <kerneltrap+0x38>

000000008000302a <argraw>:
    return strlen(buf);
}

static uint64
argraw(int n)
{
    8000302a:	1101                	addi	sp,sp,-32
    8000302c:	ec06                	sd	ra,24(sp)
    8000302e:	e822                	sd	s0,16(sp)
    80003030:	e426                	sd	s1,8(sp)
    80003032:	1000                	addi	s0,sp,32
    80003034:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    80003036:	fffff097          	auipc	ra,0xfffff
    8000303a:	d4c080e7          	jalr	-692(ra) # 80001d82 <myproc>
    switch (n)
    8000303e:	4795                	li	a5,5
    80003040:	0497e163          	bltu	a5,s1,80003082 <argraw+0x58>
    80003044:	048a                	slli	s1,s1,0x2
    80003046:	00006717          	auipc	a4,0x6
    8000304a:	81a70713          	addi	a4,a4,-2022 # 80008860 <states.0+0x30>
    8000304e:	94ba                	add	s1,s1,a4
    80003050:	409c                	lw	a5,0(s1)
    80003052:	97ba                	add	a5,a5,a4
    80003054:	8782                	jr	a5
    {
    case 0:
        return p->trapframe->a0;
    80003056:	6d3c                	ld	a5,88(a0)
    80003058:	7ba8                	ld	a0,112(a5)
    case 5:
        return p->trapframe->a5;
    }
    panic("argraw");
    return -1;
}
    8000305a:	60e2                	ld	ra,24(sp)
    8000305c:	6442                	ld	s0,16(sp)
    8000305e:	64a2                	ld	s1,8(sp)
    80003060:	6105                	addi	sp,sp,32
    80003062:	8082                	ret
        return p->trapframe->a1;
    80003064:	6d3c                	ld	a5,88(a0)
    80003066:	7fa8                	ld	a0,120(a5)
    80003068:	bfcd                	j	8000305a <argraw+0x30>
        return p->trapframe->a2;
    8000306a:	6d3c                	ld	a5,88(a0)
    8000306c:	63c8                	ld	a0,128(a5)
    8000306e:	b7f5                	j	8000305a <argraw+0x30>
        return p->trapframe->a3;
    80003070:	6d3c                	ld	a5,88(a0)
    80003072:	67c8                	ld	a0,136(a5)
    80003074:	b7dd                	j	8000305a <argraw+0x30>
        return p->trapframe->a4;
    80003076:	6d3c                	ld	a5,88(a0)
    80003078:	6bc8                	ld	a0,144(a5)
    8000307a:	b7c5                	j	8000305a <argraw+0x30>
        return p->trapframe->a5;
    8000307c:	6d3c                	ld	a5,88(a0)
    8000307e:	6fc8                	ld	a0,152(a5)
    80003080:	bfe9                	j	8000305a <argraw+0x30>
    panic("argraw");
    80003082:	00005517          	auipc	a0,0x5
    80003086:	42e50513          	addi	a0,a0,1070 # 800084b0 <etext+0x4b0>
    8000308a:	ffffd097          	auipc	ra,0xffffd
    8000308e:	4d6080e7          	jalr	1238(ra) # 80000560 <panic>

0000000080003092 <fetchaddr>:
{
    80003092:	1101                	addi	sp,sp,-32
    80003094:	ec06                	sd	ra,24(sp)
    80003096:	e822                	sd	s0,16(sp)
    80003098:	e426                	sd	s1,8(sp)
    8000309a:	e04a                	sd	s2,0(sp)
    8000309c:	1000                	addi	s0,sp,32
    8000309e:	84aa                	mv	s1,a0
    800030a0:	892e                	mv	s2,a1
    struct proc *p = myproc();
    800030a2:	fffff097          	auipc	ra,0xfffff
    800030a6:	ce0080e7          	jalr	-800(ra) # 80001d82 <myproc>
    if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800030aa:	653c                	ld	a5,72(a0)
    800030ac:	02f4f863          	bgeu	s1,a5,800030dc <fetchaddr+0x4a>
    800030b0:	00848713          	addi	a4,s1,8
    800030b4:	02e7e663          	bltu	a5,a4,800030e0 <fetchaddr+0x4e>
    if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800030b8:	46a1                	li	a3,8
    800030ba:	8626                	mv	a2,s1
    800030bc:	85ca                	mv	a1,s2
    800030be:	6928                	ld	a0,80(a0)
    800030c0:	ffffe097          	auipc	ra,0xffffe
    800030c4:	6dc080e7          	jalr	1756(ra) # 8000179c <copyin>
    800030c8:	00a03533          	snez	a0,a0
    800030cc:	40a0053b          	negw	a0,a0
}
    800030d0:	60e2                	ld	ra,24(sp)
    800030d2:	6442                	ld	s0,16(sp)
    800030d4:	64a2                	ld	s1,8(sp)
    800030d6:	6902                	ld	s2,0(sp)
    800030d8:	6105                	addi	sp,sp,32
    800030da:	8082                	ret
        return -1;
    800030dc:	557d                	li	a0,-1
    800030de:	bfcd                	j	800030d0 <fetchaddr+0x3e>
    800030e0:	557d                	li	a0,-1
    800030e2:	b7fd                	j	800030d0 <fetchaddr+0x3e>

00000000800030e4 <fetchstr>:
{
    800030e4:	7179                	addi	sp,sp,-48
    800030e6:	f406                	sd	ra,40(sp)
    800030e8:	f022                	sd	s0,32(sp)
    800030ea:	ec26                	sd	s1,24(sp)
    800030ec:	e84a                	sd	s2,16(sp)
    800030ee:	e44e                	sd	s3,8(sp)
    800030f0:	1800                	addi	s0,sp,48
    800030f2:	892a                	mv	s2,a0
    800030f4:	84ae                	mv	s1,a1
    800030f6:	89b2                	mv	s3,a2
    struct proc *p = myproc();
    800030f8:	fffff097          	auipc	ra,0xfffff
    800030fc:	c8a080e7          	jalr	-886(ra) # 80001d82 <myproc>
    if (copyinstr(p->pagetable, buf, addr, max) < 0)
    80003100:	86ce                	mv	a3,s3
    80003102:	864a                	mv	a2,s2
    80003104:	85a6                	mv	a1,s1
    80003106:	6928                	ld	a0,80(a0)
    80003108:	ffffe097          	auipc	ra,0xffffe
    8000310c:	722080e7          	jalr	1826(ra) # 8000182a <copyinstr>
    80003110:	00054e63          	bltz	a0,8000312c <fetchstr+0x48>
    return strlen(buf);
    80003114:	8526                	mv	a0,s1
    80003116:	ffffe097          	auipc	ra,0xffffe
    8000311a:	dac080e7          	jalr	-596(ra) # 80000ec2 <strlen>
}
    8000311e:	70a2                	ld	ra,40(sp)
    80003120:	7402                	ld	s0,32(sp)
    80003122:	64e2                	ld	s1,24(sp)
    80003124:	6942                	ld	s2,16(sp)
    80003126:	69a2                	ld	s3,8(sp)
    80003128:	6145                	addi	sp,sp,48
    8000312a:	8082                	ret
        return -1;
    8000312c:	557d                	li	a0,-1
    8000312e:	bfc5                	j	8000311e <fetchstr+0x3a>

0000000080003130 <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip)
{
    80003130:	1101                	addi	sp,sp,-32
    80003132:	ec06                	sd	ra,24(sp)
    80003134:	e822                	sd	s0,16(sp)
    80003136:	e426                	sd	s1,8(sp)
    80003138:	1000                	addi	s0,sp,32
    8000313a:	84ae                	mv	s1,a1
    *ip = argraw(n);
    8000313c:	00000097          	auipc	ra,0x0
    80003140:	eee080e7          	jalr	-274(ra) # 8000302a <argraw>
    80003144:	c088                	sw	a0,0(s1)
}
    80003146:	60e2                	ld	ra,24(sp)
    80003148:	6442                	ld	s0,16(sp)
    8000314a:	64a2                	ld	s1,8(sp)
    8000314c:	6105                	addi	sp,sp,32
    8000314e:	8082                	ret

0000000080003150 <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip)
{
    80003150:	1101                	addi	sp,sp,-32
    80003152:	ec06                	sd	ra,24(sp)
    80003154:	e822                	sd	s0,16(sp)
    80003156:	e426                	sd	s1,8(sp)
    80003158:	1000                	addi	s0,sp,32
    8000315a:	84ae                	mv	s1,a1
    *ip = argraw(n);
    8000315c:	00000097          	auipc	ra,0x0
    80003160:	ece080e7          	jalr	-306(ra) # 8000302a <argraw>
    80003164:	e088                	sd	a0,0(s1)
}
    80003166:	60e2                	ld	ra,24(sp)
    80003168:	6442                	ld	s0,16(sp)
    8000316a:	64a2                	ld	s1,8(sp)
    8000316c:	6105                	addi	sp,sp,32
    8000316e:	8082                	ret

0000000080003170 <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    80003170:	1101                	addi	sp,sp,-32
    80003172:	ec06                	sd	ra,24(sp)
    80003174:	e822                	sd	s0,16(sp)
    80003176:	e426                	sd	s1,8(sp)
    80003178:	e04a                	sd	s2,0(sp)
    8000317a:	1000                	addi	s0,sp,32
    8000317c:	84ae                	mv	s1,a1
    8000317e:	8932                	mv	s2,a2
    *ip = argraw(n);
    80003180:	00000097          	auipc	ra,0x0
    80003184:	eaa080e7          	jalr	-342(ra) # 8000302a <argraw>
    uint64 addr;
    argaddr(n, &addr);
    return fetchstr(addr, buf, max);
    80003188:	864a                	mv	a2,s2
    8000318a:	85a6                	mv	a1,s1
    8000318c:	00000097          	auipc	ra,0x0
    80003190:	f58080e7          	jalr	-168(ra) # 800030e4 <fetchstr>
}
    80003194:	60e2                	ld	ra,24(sp)
    80003196:	6442                	ld	s0,16(sp)
    80003198:	64a2                	ld	s1,8(sp)
    8000319a:	6902                	ld	s2,0(sp)
    8000319c:	6105                	addi	sp,sp,32
    8000319e:	8082                	ret

00000000800031a0 <syscall>:
    [SYS_schedset] sys_schedset,
    [SYS_yield] sys_yield,
};

void syscall(void)
{
    800031a0:	1101                	addi	sp,sp,-32
    800031a2:	ec06                	sd	ra,24(sp)
    800031a4:	e822                	sd	s0,16(sp)
    800031a6:	e426                	sd	s1,8(sp)
    800031a8:	e04a                	sd	s2,0(sp)
    800031aa:	1000                	addi	s0,sp,32
    int num;
    struct proc *p = myproc();
    800031ac:	fffff097          	auipc	ra,0xfffff
    800031b0:	bd6080e7          	jalr	-1066(ra) # 80001d82 <myproc>
    800031b4:	84aa                	mv	s1,a0

    num = p->trapframe->a7;
    800031b6:	05853903          	ld	s2,88(a0)
    800031ba:	0a893783          	ld	a5,168(s2)
    800031be:	0007869b          	sext.w	a3,a5
    if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    800031c2:	37fd                	addiw	a5,a5,-1
    800031c4:	4761                	li	a4,24
    800031c6:	00f76f63          	bltu	a4,a5,800031e4 <syscall+0x44>
    800031ca:	00369713          	slli	a4,a3,0x3
    800031ce:	00005797          	auipc	a5,0x5
    800031d2:	6aa78793          	addi	a5,a5,1706 # 80008878 <syscalls>
    800031d6:	97ba                	add	a5,a5,a4
    800031d8:	639c                	ld	a5,0(a5)
    800031da:	c789                	beqz	a5,800031e4 <syscall+0x44>
    {
        // Use num to lookup the system call function for num, call it,
        // and store its return value in p->trapframe->a0
        p->trapframe->a0 = syscalls[num]();
    800031dc:	9782                	jalr	a5
    800031de:	06a93823          	sd	a0,112(s2)
    800031e2:	a839                	j	80003200 <syscall+0x60>
    }
    else
    {
        printf("%d %s: unknown sys call %d\n",
    800031e4:	15848613          	addi	a2,s1,344
    800031e8:	588c                	lw	a1,48(s1)
    800031ea:	00005517          	auipc	a0,0x5
    800031ee:	2ce50513          	addi	a0,a0,718 # 800084b8 <etext+0x4b8>
    800031f2:	ffffd097          	auipc	ra,0xffffd
    800031f6:	3b8080e7          	jalr	952(ra) # 800005aa <printf>
               p->pid, p->name, num);
        p->trapframe->a0 = -1;
    800031fa:	6cbc                	ld	a5,88(s1)
    800031fc:	577d                	li	a4,-1
    800031fe:	fbb8                	sd	a4,112(a5)
    }
}
    80003200:	60e2                	ld	ra,24(sp)
    80003202:	6442                	ld	s0,16(sp)
    80003204:	64a2                	ld	s1,8(sp)
    80003206:	6902                	ld	s2,0(sp)
    80003208:	6105                	addi	sp,sp,32
    8000320a:	8082                	ret

000000008000320c <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000320c:	1101                	addi	sp,sp,-32
    8000320e:	ec06                	sd	ra,24(sp)
    80003210:	e822                	sd	s0,16(sp)
    80003212:	1000                	addi	s0,sp,32
    int n;
    argint(0, &n);
    80003214:	fec40593          	addi	a1,s0,-20
    80003218:	4501                	li	a0,0
    8000321a:	00000097          	auipc	ra,0x0
    8000321e:	f16080e7          	jalr	-234(ra) # 80003130 <argint>
    exit(n);
    80003222:	fec42503          	lw	a0,-20(s0)
    80003226:	fffff097          	auipc	ra,0xfffff
    8000322a:	482080e7          	jalr	1154(ra) # 800026a8 <exit>
    return 0; // not reached
}
    8000322e:	4501                	li	a0,0
    80003230:	60e2                	ld	ra,24(sp)
    80003232:	6442                	ld	s0,16(sp)
    80003234:	6105                	addi	sp,sp,32
    80003236:	8082                	ret

0000000080003238 <sys_getpid>:

uint64
sys_getpid(void)
{
    80003238:	1141                	addi	sp,sp,-16
    8000323a:	e406                	sd	ra,8(sp)
    8000323c:	e022                	sd	s0,0(sp)
    8000323e:	0800                	addi	s0,sp,16
    return myproc()->pid;
    80003240:	fffff097          	auipc	ra,0xfffff
    80003244:	b42080e7          	jalr	-1214(ra) # 80001d82 <myproc>
}
    80003248:	5908                	lw	a0,48(a0)
    8000324a:	60a2                	ld	ra,8(sp)
    8000324c:	6402                	ld	s0,0(sp)
    8000324e:	0141                	addi	sp,sp,16
    80003250:	8082                	ret

0000000080003252 <sys_fork>:

uint64
sys_fork(void)
{
    80003252:	1141                	addi	sp,sp,-16
    80003254:	e406                	sd	ra,8(sp)
    80003256:	e022                	sd	s0,0(sp)
    80003258:	0800                	addi	s0,sp,16
    return fork();
    8000325a:	fffff097          	auipc	ra,0xfffff
    8000325e:	090080e7          	jalr	144(ra) # 800022ea <fork>
}
    80003262:	60a2                	ld	ra,8(sp)
    80003264:	6402                	ld	s0,0(sp)
    80003266:	0141                	addi	sp,sp,16
    80003268:	8082                	ret

000000008000326a <sys_wait>:

uint64
sys_wait(void)
{
    8000326a:	1101                	addi	sp,sp,-32
    8000326c:	ec06                	sd	ra,24(sp)
    8000326e:	e822                	sd	s0,16(sp)
    80003270:	1000                	addi	s0,sp,32
    uint64 p;
    argaddr(0, &p);
    80003272:	fe840593          	addi	a1,s0,-24
    80003276:	4501                	li	a0,0
    80003278:	00000097          	auipc	ra,0x0
    8000327c:	ed8080e7          	jalr	-296(ra) # 80003150 <argaddr>
    return wait(p);
    80003280:	fe843503          	ld	a0,-24(s0)
    80003284:	fffff097          	auipc	ra,0xfffff
    80003288:	5ca080e7          	jalr	1482(ra) # 8000284e <wait>
}
    8000328c:	60e2                	ld	ra,24(sp)
    8000328e:	6442                	ld	s0,16(sp)
    80003290:	6105                	addi	sp,sp,32
    80003292:	8082                	ret

0000000080003294 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80003294:	7179                	addi	sp,sp,-48
    80003296:	f406                	sd	ra,40(sp)
    80003298:	f022                	sd	s0,32(sp)
    8000329a:	ec26                	sd	s1,24(sp)
    8000329c:	1800                	addi	s0,sp,48
    uint64 addr;
    int n;

    argint(0, &n);
    8000329e:	fdc40593          	addi	a1,s0,-36
    800032a2:	4501                	li	a0,0
    800032a4:	00000097          	auipc	ra,0x0
    800032a8:	e8c080e7          	jalr	-372(ra) # 80003130 <argint>
    addr = myproc()->sz;
    800032ac:	fffff097          	auipc	ra,0xfffff
    800032b0:	ad6080e7          	jalr	-1322(ra) # 80001d82 <myproc>
    800032b4:	6524                	ld	s1,72(a0)
    if (growproc(n) < 0)
    800032b6:	fdc42503          	lw	a0,-36(s0)
    800032ba:	fffff097          	auipc	ra,0xfffff
    800032be:	e3a080e7          	jalr	-454(ra) # 800020f4 <growproc>
    800032c2:	00054863          	bltz	a0,800032d2 <sys_sbrk+0x3e>
        return -1;
    return addr;
}
    800032c6:	8526                	mv	a0,s1
    800032c8:	70a2                	ld	ra,40(sp)
    800032ca:	7402                	ld	s0,32(sp)
    800032cc:	64e2                	ld	s1,24(sp)
    800032ce:	6145                	addi	sp,sp,48
    800032d0:	8082                	ret
        return -1;
    800032d2:	54fd                	li	s1,-1
    800032d4:	bfcd                	j	800032c6 <sys_sbrk+0x32>

00000000800032d6 <sys_sleep>:

uint64
sys_sleep(void)
{
    800032d6:	7139                	addi	sp,sp,-64
    800032d8:	fc06                	sd	ra,56(sp)
    800032da:	f822                	sd	s0,48(sp)
    800032dc:	f04a                	sd	s2,32(sp)
    800032de:	0080                	addi	s0,sp,64
    int n;
    uint ticks0;

    argint(0, &n);
    800032e0:	fcc40593          	addi	a1,s0,-52
    800032e4:	4501                	li	a0,0
    800032e6:	00000097          	auipc	ra,0x0
    800032ea:	e4a080e7          	jalr	-438(ra) # 80003130 <argint>
    acquire(&tickslock);
    800032ee:	00014517          	auipc	a0,0x14
    800032f2:	45250513          	addi	a0,a0,1106 # 80017740 <tickslock>
    800032f6:	ffffe097          	auipc	ra,0xffffe
    800032fa:	948080e7          	jalr	-1720(ra) # 80000c3e <acquire>
    ticks0 = ticks;
    800032fe:	00005917          	auipc	s2,0x5
    80003302:	72292903          	lw	s2,1826(s2) # 80008a20 <ticks>
    while (ticks - ticks0 < n)
    80003306:	fcc42783          	lw	a5,-52(s0)
    8000330a:	c3b9                	beqz	a5,80003350 <sys_sleep+0x7a>
    8000330c:	f426                	sd	s1,40(sp)
    8000330e:	ec4e                	sd	s3,24(sp)
        if (killed(myproc()))
        {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
    80003310:	00014997          	auipc	s3,0x14
    80003314:	43098993          	addi	s3,s3,1072 # 80017740 <tickslock>
    80003318:	00005497          	auipc	s1,0x5
    8000331c:	70848493          	addi	s1,s1,1800 # 80008a20 <ticks>
        if (killed(myproc()))
    80003320:	fffff097          	auipc	ra,0xfffff
    80003324:	a62080e7          	jalr	-1438(ra) # 80001d82 <myproc>
    80003328:	fffff097          	auipc	ra,0xfffff
    8000332c:	4f4080e7          	jalr	1268(ra) # 8000281c <killed>
    80003330:	ed15                	bnez	a0,8000336c <sys_sleep+0x96>
        sleep(&ticks, &tickslock);
    80003332:	85ce                	mv	a1,s3
    80003334:	8526                	mv	a0,s1
    80003336:	fffff097          	auipc	ra,0xfffff
    8000333a:	23e080e7          	jalr	574(ra) # 80002574 <sleep>
    while (ticks - ticks0 < n)
    8000333e:	409c                	lw	a5,0(s1)
    80003340:	412787bb          	subw	a5,a5,s2
    80003344:	fcc42703          	lw	a4,-52(s0)
    80003348:	fce7ece3          	bltu	a5,a4,80003320 <sys_sleep+0x4a>
    8000334c:	74a2                	ld	s1,40(sp)
    8000334e:	69e2                	ld	s3,24(sp)
    }
    release(&tickslock);
    80003350:	00014517          	auipc	a0,0x14
    80003354:	3f050513          	addi	a0,a0,1008 # 80017740 <tickslock>
    80003358:	ffffe097          	auipc	ra,0xffffe
    8000335c:	996080e7          	jalr	-1642(ra) # 80000cee <release>
    return 0;
    80003360:	4501                	li	a0,0
}
    80003362:	70e2                	ld	ra,56(sp)
    80003364:	7442                	ld	s0,48(sp)
    80003366:	7902                	ld	s2,32(sp)
    80003368:	6121                	addi	sp,sp,64
    8000336a:	8082                	ret
            release(&tickslock);
    8000336c:	00014517          	auipc	a0,0x14
    80003370:	3d450513          	addi	a0,a0,980 # 80017740 <tickslock>
    80003374:	ffffe097          	auipc	ra,0xffffe
    80003378:	97a080e7          	jalr	-1670(ra) # 80000cee <release>
            return -1;
    8000337c:	557d                	li	a0,-1
    8000337e:	74a2                	ld	s1,40(sp)
    80003380:	69e2                	ld	s3,24(sp)
    80003382:	b7c5                	j	80003362 <sys_sleep+0x8c>

0000000080003384 <sys_kill>:

uint64
sys_kill(void)
{
    80003384:	1101                	addi	sp,sp,-32
    80003386:	ec06                	sd	ra,24(sp)
    80003388:	e822                	sd	s0,16(sp)
    8000338a:	1000                	addi	s0,sp,32
    int pid;

    argint(0, &pid);
    8000338c:	fec40593          	addi	a1,s0,-20
    80003390:	4501                	li	a0,0
    80003392:	00000097          	auipc	ra,0x0
    80003396:	d9e080e7          	jalr	-610(ra) # 80003130 <argint>
    return kill(pid);
    8000339a:	fec42503          	lw	a0,-20(s0)
    8000339e:	fffff097          	auipc	ra,0xfffff
    800033a2:	3e0080e7          	jalr	992(ra) # 8000277e <kill>
}
    800033a6:	60e2                	ld	ra,24(sp)
    800033a8:	6442                	ld	s0,16(sp)
    800033aa:	6105                	addi	sp,sp,32
    800033ac:	8082                	ret

00000000800033ae <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800033ae:	1101                	addi	sp,sp,-32
    800033b0:	ec06                	sd	ra,24(sp)
    800033b2:	e822                	sd	s0,16(sp)
    800033b4:	e426                	sd	s1,8(sp)
    800033b6:	1000                	addi	s0,sp,32
    uint xticks;

    acquire(&tickslock);
    800033b8:	00014517          	auipc	a0,0x14
    800033bc:	38850513          	addi	a0,a0,904 # 80017740 <tickslock>
    800033c0:	ffffe097          	auipc	ra,0xffffe
    800033c4:	87e080e7          	jalr	-1922(ra) # 80000c3e <acquire>
    xticks = ticks;
    800033c8:	00005497          	auipc	s1,0x5
    800033cc:	6584a483          	lw	s1,1624(s1) # 80008a20 <ticks>
    release(&tickslock);
    800033d0:	00014517          	auipc	a0,0x14
    800033d4:	37050513          	addi	a0,a0,880 # 80017740 <tickslock>
    800033d8:	ffffe097          	auipc	ra,0xffffe
    800033dc:	916080e7          	jalr	-1770(ra) # 80000cee <release>
    return xticks;
}
    800033e0:	02049513          	slli	a0,s1,0x20
    800033e4:	9101                	srli	a0,a0,0x20
    800033e6:	60e2                	ld	ra,24(sp)
    800033e8:	6442                	ld	s0,16(sp)
    800033ea:	64a2                	ld	s1,8(sp)
    800033ec:	6105                	addi	sp,sp,32
    800033ee:	8082                	ret

00000000800033f0 <sys_ps>:

void *
sys_ps(void)
{
    800033f0:	1101                	addi	sp,sp,-32
    800033f2:	ec06                	sd	ra,24(sp)
    800033f4:	e822                	sd	s0,16(sp)
    800033f6:	1000                	addi	s0,sp,32
    int start = 0, count = 0;
    800033f8:	fe042623          	sw	zero,-20(s0)
    800033fc:	fe042423          	sw	zero,-24(s0)
    argint(0, &start);
    80003400:	fec40593          	addi	a1,s0,-20
    80003404:	4501                	li	a0,0
    80003406:	00000097          	auipc	ra,0x0
    8000340a:	d2a080e7          	jalr	-726(ra) # 80003130 <argint>
    argint(1, &count);
    8000340e:	fe840593          	addi	a1,s0,-24
    80003412:	4505                	li	a0,1
    80003414:	00000097          	auipc	ra,0x0
    80003418:	d1c080e7          	jalr	-740(ra) # 80003130 <argint>
    return ps((uint8)start, (uint8)count);
    8000341c:	fe844583          	lbu	a1,-24(s0)
    80003420:	fec44503          	lbu	a0,-20(s0)
    80003424:	fffff097          	auipc	ra,0xfffff
    80003428:	d2c080e7          	jalr	-724(ra) # 80002150 <ps>
}
    8000342c:	60e2                	ld	ra,24(sp)
    8000342e:	6442                	ld	s0,16(sp)
    80003430:	6105                	addi	sp,sp,32
    80003432:	8082                	ret

0000000080003434 <sys_schedls>:

uint64 sys_schedls(void)
{
    80003434:	1141                	addi	sp,sp,-16
    80003436:	e406                	sd	ra,8(sp)
    80003438:	e022                	sd	s0,0(sp)
    8000343a:	0800                	addi	s0,sp,16
    schedls();
    8000343c:	fffff097          	auipc	ra,0xfffff
    80003440:	696080e7          	jalr	1686(ra) # 80002ad2 <schedls>
    return 0;
}
    80003444:	4501                	li	a0,0
    80003446:	60a2                	ld	ra,8(sp)
    80003448:	6402                	ld	s0,0(sp)
    8000344a:	0141                	addi	sp,sp,16
    8000344c:	8082                	ret

000000008000344e <sys_schedset>:

uint64 sys_schedset(void)
{
    8000344e:	1101                	addi	sp,sp,-32
    80003450:	ec06                	sd	ra,24(sp)
    80003452:	e822                	sd	s0,16(sp)
    80003454:	1000                	addi	s0,sp,32
    int id = 0;
    80003456:	fe042623          	sw	zero,-20(s0)
    argint(0, &id);
    8000345a:	fec40593          	addi	a1,s0,-20
    8000345e:	4501                	li	a0,0
    80003460:	00000097          	auipc	ra,0x0
    80003464:	cd0080e7          	jalr	-816(ra) # 80003130 <argint>
    schedset(id - 1);
    80003468:	fec42503          	lw	a0,-20(s0)
    8000346c:	357d                	addiw	a0,a0,-1
    8000346e:	fffff097          	auipc	ra,0xfffff
    80003472:	750080e7          	jalr	1872(ra) # 80002bbe <schedset>
    return 0;
}
    80003476:	4501                	li	a0,0
    80003478:	60e2                	ld	ra,24(sp)
    8000347a:	6442                	ld	s0,16(sp)
    8000347c:	6105                	addi	sp,sp,32
    8000347e:	8082                	ret

0000000080003480 <sys_yield>:

uint64 sys_yield(void)
{
    80003480:	1141                	addi	sp,sp,-16
    80003482:	e406                	sd	ra,8(sp)
    80003484:	e022                	sd	s0,0(sp)
    80003486:	0800                	addi	s0,sp,16
    yield(YIELD_OTHER);
    80003488:	4509                	li	a0,2
    8000348a:	fffff097          	auipc	ra,0xfffff
    8000348e:	0ae080e7          	jalr	174(ra) # 80002538 <yield>
    return 0;
    80003492:	4501                	li	a0,0
    80003494:	60a2                	ld	ra,8(sp)
    80003496:	6402                	ld	s0,0(sp)
    80003498:	0141                	addi	sp,sp,16
    8000349a:	8082                	ret

000000008000349c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000349c:	7179                	addi	sp,sp,-48
    8000349e:	f406                	sd	ra,40(sp)
    800034a0:	f022                	sd	s0,32(sp)
    800034a2:	ec26                	sd	s1,24(sp)
    800034a4:	e84a                	sd	s2,16(sp)
    800034a6:	e44e                	sd	s3,8(sp)
    800034a8:	e052                	sd	s4,0(sp)
    800034aa:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800034ac:	00005597          	auipc	a1,0x5
    800034b0:	02c58593          	addi	a1,a1,44 # 800084d8 <etext+0x4d8>
    800034b4:	00014517          	auipc	a0,0x14
    800034b8:	2a450513          	addi	a0,a0,676 # 80017758 <bcache>
    800034bc:	ffffd097          	auipc	ra,0xffffd
    800034c0:	6ee080e7          	jalr	1774(ra) # 80000baa <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800034c4:	0001c797          	auipc	a5,0x1c
    800034c8:	29478793          	addi	a5,a5,660 # 8001f758 <bcache+0x8000>
    800034cc:	0001c717          	auipc	a4,0x1c
    800034d0:	4f470713          	addi	a4,a4,1268 # 8001f9c0 <bcache+0x8268>
    800034d4:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800034d8:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800034dc:	00014497          	auipc	s1,0x14
    800034e0:	29448493          	addi	s1,s1,660 # 80017770 <bcache+0x18>
    b->next = bcache.head.next;
    800034e4:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800034e6:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800034e8:	00005a17          	auipc	s4,0x5
    800034ec:	ff8a0a13          	addi	s4,s4,-8 # 800084e0 <etext+0x4e0>
    b->next = bcache.head.next;
    800034f0:	2b893783          	ld	a5,696(s2)
    800034f4:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800034f6:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800034fa:	85d2                	mv	a1,s4
    800034fc:	01048513          	addi	a0,s1,16
    80003500:	00001097          	auipc	ra,0x1
    80003504:	4e4080e7          	jalr	1252(ra) # 800049e4 <initsleeplock>
    bcache.head.next->prev = b;
    80003508:	2b893783          	ld	a5,696(s2)
    8000350c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000350e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003512:	45848493          	addi	s1,s1,1112
    80003516:	fd349de3          	bne	s1,s3,800034f0 <binit+0x54>
  }
}
    8000351a:	70a2                	ld	ra,40(sp)
    8000351c:	7402                	ld	s0,32(sp)
    8000351e:	64e2                	ld	s1,24(sp)
    80003520:	6942                	ld	s2,16(sp)
    80003522:	69a2                	ld	s3,8(sp)
    80003524:	6a02                	ld	s4,0(sp)
    80003526:	6145                	addi	sp,sp,48
    80003528:	8082                	ret

000000008000352a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000352a:	7179                	addi	sp,sp,-48
    8000352c:	f406                	sd	ra,40(sp)
    8000352e:	f022                	sd	s0,32(sp)
    80003530:	ec26                	sd	s1,24(sp)
    80003532:	e84a                	sd	s2,16(sp)
    80003534:	e44e                	sd	s3,8(sp)
    80003536:	1800                	addi	s0,sp,48
    80003538:	892a                	mv	s2,a0
    8000353a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000353c:	00014517          	auipc	a0,0x14
    80003540:	21c50513          	addi	a0,a0,540 # 80017758 <bcache>
    80003544:	ffffd097          	auipc	ra,0xffffd
    80003548:	6fa080e7          	jalr	1786(ra) # 80000c3e <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000354c:	0001c497          	auipc	s1,0x1c
    80003550:	4c44b483          	ld	s1,1220(s1) # 8001fa10 <bcache+0x82b8>
    80003554:	0001c797          	auipc	a5,0x1c
    80003558:	46c78793          	addi	a5,a5,1132 # 8001f9c0 <bcache+0x8268>
    8000355c:	02f48f63          	beq	s1,a5,8000359a <bread+0x70>
    80003560:	873e                	mv	a4,a5
    80003562:	a021                	j	8000356a <bread+0x40>
    80003564:	68a4                	ld	s1,80(s1)
    80003566:	02e48a63          	beq	s1,a4,8000359a <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000356a:	449c                	lw	a5,8(s1)
    8000356c:	ff279ce3          	bne	a5,s2,80003564 <bread+0x3a>
    80003570:	44dc                	lw	a5,12(s1)
    80003572:	ff3799e3          	bne	a5,s3,80003564 <bread+0x3a>
      b->refcnt++;
    80003576:	40bc                	lw	a5,64(s1)
    80003578:	2785                	addiw	a5,a5,1
    8000357a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000357c:	00014517          	auipc	a0,0x14
    80003580:	1dc50513          	addi	a0,a0,476 # 80017758 <bcache>
    80003584:	ffffd097          	auipc	ra,0xffffd
    80003588:	76a080e7          	jalr	1898(ra) # 80000cee <release>
      acquiresleep(&b->lock);
    8000358c:	01048513          	addi	a0,s1,16
    80003590:	00001097          	auipc	ra,0x1
    80003594:	48e080e7          	jalr	1166(ra) # 80004a1e <acquiresleep>
      return b;
    80003598:	a8b9                	j	800035f6 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000359a:	0001c497          	auipc	s1,0x1c
    8000359e:	46e4b483          	ld	s1,1134(s1) # 8001fa08 <bcache+0x82b0>
    800035a2:	0001c797          	auipc	a5,0x1c
    800035a6:	41e78793          	addi	a5,a5,1054 # 8001f9c0 <bcache+0x8268>
    800035aa:	00f48863          	beq	s1,a5,800035ba <bread+0x90>
    800035ae:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800035b0:	40bc                	lw	a5,64(s1)
    800035b2:	cf81                	beqz	a5,800035ca <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800035b4:	64a4                	ld	s1,72(s1)
    800035b6:	fee49de3          	bne	s1,a4,800035b0 <bread+0x86>
  panic("bget: no buffers");
    800035ba:	00005517          	auipc	a0,0x5
    800035be:	f2e50513          	addi	a0,a0,-210 # 800084e8 <etext+0x4e8>
    800035c2:	ffffd097          	auipc	ra,0xffffd
    800035c6:	f9e080e7          	jalr	-98(ra) # 80000560 <panic>
      b->dev = dev;
    800035ca:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800035ce:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800035d2:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800035d6:	4785                	li	a5,1
    800035d8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800035da:	00014517          	auipc	a0,0x14
    800035de:	17e50513          	addi	a0,a0,382 # 80017758 <bcache>
    800035e2:	ffffd097          	auipc	ra,0xffffd
    800035e6:	70c080e7          	jalr	1804(ra) # 80000cee <release>
      acquiresleep(&b->lock);
    800035ea:	01048513          	addi	a0,s1,16
    800035ee:	00001097          	auipc	ra,0x1
    800035f2:	430080e7          	jalr	1072(ra) # 80004a1e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800035f6:	409c                	lw	a5,0(s1)
    800035f8:	cb89                	beqz	a5,8000360a <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800035fa:	8526                	mv	a0,s1
    800035fc:	70a2                	ld	ra,40(sp)
    800035fe:	7402                	ld	s0,32(sp)
    80003600:	64e2                	ld	s1,24(sp)
    80003602:	6942                	ld	s2,16(sp)
    80003604:	69a2                	ld	s3,8(sp)
    80003606:	6145                	addi	sp,sp,48
    80003608:	8082                	ret
    virtio_disk_rw(b, 0);
    8000360a:	4581                	li	a1,0
    8000360c:	8526                	mv	a0,s1
    8000360e:	00003097          	auipc	ra,0x3
    80003612:	10a080e7          	jalr	266(ra) # 80006718 <virtio_disk_rw>
    b->valid = 1;
    80003616:	4785                	li	a5,1
    80003618:	c09c                	sw	a5,0(s1)
  return b;
    8000361a:	b7c5                	j	800035fa <bread+0xd0>

000000008000361c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000361c:	1101                	addi	sp,sp,-32
    8000361e:	ec06                	sd	ra,24(sp)
    80003620:	e822                	sd	s0,16(sp)
    80003622:	e426                	sd	s1,8(sp)
    80003624:	1000                	addi	s0,sp,32
    80003626:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003628:	0541                	addi	a0,a0,16
    8000362a:	00001097          	auipc	ra,0x1
    8000362e:	48e080e7          	jalr	1166(ra) # 80004ab8 <holdingsleep>
    80003632:	cd01                	beqz	a0,8000364a <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003634:	4585                	li	a1,1
    80003636:	8526                	mv	a0,s1
    80003638:	00003097          	auipc	ra,0x3
    8000363c:	0e0080e7          	jalr	224(ra) # 80006718 <virtio_disk_rw>
}
    80003640:	60e2                	ld	ra,24(sp)
    80003642:	6442                	ld	s0,16(sp)
    80003644:	64a2                	ld	s1,8(sp)
    80003646:	6105                	addi	sp,sp,32
    80003648:	8082                	ret
    panic("bwrite");
    8000364a:	00005517          	auipc	a0,0x5
    8000364e:	eb650513          	addi	a0,a0,-330 # 80008500 <etext+0x500>
    80003652:	ffffd097          	auipc	ra,0xffffd
    80003656:	f0e080e7          	jalr	-242(ra) # 80000560 <panic>

000000008000365a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000365a:	1101                	addi	sp,sp,-32
    8000365c:	ec06                	sd	ra,24(sp)
    8000365e:	e822                	sd	s0,16(sp)
    80003660:	e426                	sd	s1,8(sp)
    80003662:	e04a                	sd	s2,0(sp)
    80003664:	1000                	addi	s0,sp,32
    80003666:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003668:	01050913          	addi	s2,a0,16
    8000366c:	854a                	mv	a0,s2
    8000366e:	00001097          	auipc	ra,0x1
    80003672:	44a080e7          	jalr	1098(ra) # 80004ab8 <holdingsleep>
    80003676:	c535                	beqz	a0,800036e2 <brelse+0x88>
    panic("brelse");

  releasesleep(&b->lock);
    80003678:	854a                	mv	a0,s2
    8000367a:	00001097          	auipc	ra,0x1
    8000367e:	3fa080e7          	jalr	1018(ra) # 80004a74 <releasesleep>

  acquire(&bcache.lock);
    80003682:	00014517          	auipc	a0,0x14
    80003686:	0d650513          	addi	a0,a0,214 # 80017758 <bcache>
    8000368a:	ffffd097          	auipc	ra,0xffffd
    8000368e:	5b4080e7          	jalr	1460(ra) # 80000c3e <acquire>
  b->refcnt--;
    80003692:	40bc                	lw	a5,64(s1)
    80003694:	37fd                	addiw	a5,a5,-1
    80003696:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003698:	e79d                	bnez	a5,800036c6 <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000369a:	68b8                	ld	a4,80(s1)
    8000369c:	64bc                	ld	a5,72(s1)
    8000369e:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800036a0:	68b8                	ld	a4,80(s1)
    800036a2:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800036a4:	0001c797          	auipc	a5,0x1c
    800036a8:	0b478793          	addi	a5,a5,180 # 8001f758 <bcache+0x8000>
    800036ac:	2b87b703          	ld	a4,696(a5)
    800036b0:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800036b2:	0001c717          	auipc	a4,0x1c
    800036b6:	30e70713          	addi	a4,a4,782 # 8001f9c0 <bcache+0x8268>
    800036ba:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800036bc:	2b87b703          	ld	a4,696(a5)
    800036c0:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800036c2:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800036c6:	00014517          	auipc	a0,0x14
    800036ca:	09250513          	addi	a0,a0,146 # 80017758 <bcache>
    800036ce:	ffffd097          	auipc	ra,0xffffd
    800036d2:	620080e7          	jalr	1568(ra) # 80000cee <release>
}
    800036d6:	60e2                	ld	ra,24(sp)
    800036d8:	6442                	ld	s0,16(sp)
    800036da:	64a2                	ld	s1,8(sp)
    800036dc:	6902                	ld	s2,0(sp)
    800036de:	6105                	addi	sp,sp,32
    800036e0:	8082                	ret
    panic("brelse");
    800036e2:	00005517          	auipc	a0,0x5
    800036e6:	e2650513          	addi	a0,a0,-474 # 80008508 <etext+0x508>
    800036ea:	ffffd097          	auipc	ra,0xffffd
    800036ee:	e76080e7          	jalr	-394(ra) # 80000560 <panic>

00000000800036f2 <bpin>:

void
bpin(struct buf *b) {
    800036f2:	1101                	addi	sp,sp,-32
    800036f4:	ec06                	sd	ra,24(sp)
    800036f6:	e822                	sd	s0,16(sp)
    800036f8:	e426                	sd	s1,8(sp)
    800036fa:	1000                	addi	s0,sp,32
    800036fc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800036fe:	00014517          	auipc	a0,0x14
    80003702:	05a50513          	addi	a0,a0,90 # 80017758 <bcache>
    80003706:	ffffd097          	auipc	ra,0xffffd
    8000370a:	538080e7          	jalr	1336(ra) # 80000c3e <acquire>
  b->refcnt++;
    8000370e:	40bc                	lw	a5,64(s1)
    80003710:	2785                	addiw	a5,a5,1
    80003712:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003714:	00014517          	auipc	a0,0x14
    80003718:	04450513          	addi	a0,a0,68 # 80017758 <bcache>
    8000371c:	ffffd097          	auipc	ra,0xffffd
    80003720:	5d2080e7          	jalr	1490(ra) # 80000cee <release>
}
    80003724:	60e2                	ld	ra,24(sp)
    80003726:	6442                	ld	s0,16(sp)
    80003728:	64a2                	ld	s1,8(sp)
    8000372a:	6105                	addi	sp,sp,32
    8000372c:	8082                	ret

000000008000372e <bunpin>:

void
bunpin(struct buf *b) {
    8000372e:	1101                	addi	sp,sp,-32
    80003730:	ec06                	sd	ra,24(sp)
    80003732:	e822                	sd	s0,16(sp)
    80003734:	e426                	sd	s1,8(sp)
    80003736:	1000                	addi	s0,sp,32
    80003738:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000373a:	00014517          	auipc	a0,0x14
    8000373e:	01e50513          	addi	a0,a0,30 # 80017758 <bcache>
    80003742:	ffffd097          	auipc	ra,0xffffd
    80003746:	4fc080e7          	jalr	1276(ra) # 80000c3e <acquire>
  b->refcnt--;
    8000374a:	40bc                	lw	a5,64(s1)
    8000374c:	37fd                	addiw	a5,a5,-1
    8000374e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003750:	00014517          	auipc	a0,0x14
    80003754:	00850513          	addi	a0,a0,8 # 80017758 <bcache>
    80003758:	ffffd097          	auipc	ra,0xffffd
    8000375c:	596080e7          	jalr	1430(ra) # 80000cee <release>
}
    80003760:	60e2                	ld	ra,24(sp)
    80003762:	6442                	ld	s0,16(sp)
    80003764:	64a2                	ld	s1,8(sp)
    80003766:	6105                	addi	sp,sp,32
    80003768:	8082                	ret

000000008000376a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000376a:	1101                	addi	sp,sp,-32
    8000376c:	ec06                	sd	ra,24(sp)
    8000376e:	e822                	sd	s0,16(sp)
    80003770:	e426                	sd	s1,8(sp)
    80003772:	e04a                	sd	s2,0(sp)
    80003774:	1000                	addi	s0,sp,32
    80003776:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003778:	00d5d79b          	srliw	a5,a1,0xd
    8000377c:	0001c597          	auipc	a1,0x1c
    80003780:	6b85a583          	lw	a1,1720(a1) # 8001fe34 <sb+0x1c>
    80003784:	9dbd                	addw	a1,a1,a5
    80003786:	00000097          	auipc	ra,0x0
    8000378a:	da4080e7          	jalr	-604(ra) # 8000352a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000378e:	0074f713          	andi	a4,s1,7
    80003792:	4785                	li	a5,1
    80003794:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80003798:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    8000379a:	90d9                	srli	s1,s1,0x36
    8000379c:	00950733          	add	a4,a0,s1
    800037a0:	05874703          	lbu	a4,88(a4)
    800037a4:	00e7f6b3          	and	a3,a5,a4
    800037a8:	c69d                	beqz	a3,800037d6 <bfree+0x6c>
    800037aa:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800037ac:	94aa                	add	s1,s1,a0
    800037ae:	fff7c793          	not	a5,a5
    800037b2:	8f7d                	and	a4,a4,a5
    800037b4:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800037b8:	00001097          	auipc	ra,0x1
    800037bc:	148080e7          	jalr	328(ra) # 80004900 <log_write>
  brelse(bp);
    800037c0:	854a                	mv	a0,s2
    800037c2:	00000097          	auipc	ra,0x0
    800037c6:	e98080e7          	jalr	-360(ra) # 8000365a <brelse>
}
    800037ca:	60e2                	ld	ra,24(sp)
    800037cc:	6442                	ld	s0,16(sp)
    800037ce:	64a2                	ld	s1,8(sp)
    800037d0:	6902                	ld	s2,0(sp)
    800037d2:	6105                	addi	sp,sp,32
    800037d4:	8082                	ret
    panic("freeing free block");
    800037d6:	00005517          	auipc	a0,0x5
    800037da:	d3a50513          	addi	a0,a0,-710 # 80008510 <etext+0x510>
    800037de:	ffffd097          	auipc	ra,0xffffd
    800037e2:	d82080e7          	jalr	-638(ra) # 80000560 <panic>

00000000800037e6 <balloc>:
{
    800037e6:	715d                	addi	sp,sp,-80
    800037e8:	e486                	sd	ra,72(sp)
    800037ea:	e0a2                	sd	s0,64(sp)
    800037ec:	fc26                	sd	s1,56(sp)
    800037ee:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    800037f0:	0001c797          	auipc	a5,0x1c
    800037f4:	62c7a783          	lw	a5,1580(a5) # 8001fe1c <sb+0x4>
    800037f8:	10078863          	beqz	a5,80003908 <balloc+0x122>
    800037fc:	f84a                	sd	s2,48(sp)
    800037fe:	f44e                	sd	s3,40(sp)
    80003800:	f052                	sd	s4,32(sp)
    80003802:	ec56                	sd	s5,24(sp)
    80003804:	e85a                	sd	s6,16(sp)
    80003806:	e45e                	sd	s7,8(sp)
    80003808:	e062                	sd	s8,0(sp)
    8000380a:	8baa                	mv	s7,a0
    8000380c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000380e:	0001cb17          	auipc	s6,0x1c
    80003812:	60ab0b13          	addi	s6,s6,1546 # 8001fe18 <sb>
      m = 1 << (bi % 8);
    80003816:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003818:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000381a:	6c09                	lui	s8,0x2
    8000381c:	a049                	j	8000389e <balloc+0xb8>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000381e:	97ca                	add	a5,a5,s2
    80003820:	8e55                	or	a2,a2,a3
    80003822:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003826:	854a                	mv	a0,s2
    80003828:	00001097          	auipc	ra,0x1
    8000382c:	0d8080e7          	jalr	216(ra) # 80004900 <log_write>
        brelse(bp);
    80003830:	854a                	mv	a0,s2
    80003832:	00000097          	auipc	ra,0x0
    80003836:	e28080e7          	jalr	-472(ra) # 8000365a <brelse>
  bp = bread(dev, bno);
    8000383a:	85a6                	mv	a1,s1
    8000383c:	855e                	mv	a0,s7
    8000383e:	00000097          	auipc	ra,0x0
    80003842:	cec080e7          	jalr	-788(ra) # 8000352a <bread>
    80003846:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003848:	40000613          	li	a2,1024
    8000384c:	4581                	li	a1,0
    8000384e:	05850513          	addi	a0,a0,88
    80003852:	ffffd097          	auipc	ra,0xffffd
    80003856:	4e4080e7          	jalr	1252(ra) # 80000d36 <memset>
  log_write(bp);
    8000385a:	854a                	mv	a0,s2
    8000385c:	00001097          	auipc	ra,0x1
    80003860:	0a4080e7          	jalr	164(ra) # 80004900 <log_write>
  brelse(bp);
    80003864:	854a                	mv	a0,s2
    80003866:	00000097          	auipc	ra,0x0
    8000386a:	df4080e7          	jalr	-524(ra) # 8000365a <brelse>
}
    8000386e:	7942                	ld	s2,48(sp)
    80003870:	79a2                	ld	s3,40(sp)
    80003872:	7a02                	ld	s4,32(sp)
    80003874:	6ae2                	ld	s5,24(sp)
    80003876:	6b42                	ld	s6,16(sp)
    80003878:	6ba2                	ld	s7,8(sp)
    8000387a:	6c02                	ld	s8,0(sp)
}
    8000387c:	8526                	mv	a0,s1
    8000387e:	60a6                	ld	ra,72(sp)
    80003880:	6406                	ld	s0,64(sp)
    80003882:	74e2                	ld	s1,56(sp)
    80003884:	6161                	addi	sp,sp,80
    80003886:	8082                	ret
    brelse(bp);
    80003888:	854a                	mv	a0,s2
    8000388a:	00000097          	auipc	ra,0x0
    8000388e:	dd0080e7          	jalr	-560(ra) # 8000365a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003892:	015c0abb          	addw	s5,s8,s5
    80003896:	004b2783          	lw	a5,4(s6)
    8000389a:	06faf063          	bgeu	s5,a5,800038fa <balloc+0x114>
    bp = bread(dev, BBLOCK(b, sb));
    8000389e:	41fad79b          	sraiw	a5,s5,0x1f
    800038a2:	0137d79b          	srliw	a5,a5,0x13
    800038a6:	015787bb          	addw	a5,a5,s5
    800038aa:	40d7d79b          	sraiw	a5,a5,0xd
    800038ae:	01cb2583          	lw	a1,28(s6)
    800038b2:	9dbd                	addw	a1,a1,a5
    800038b4:	855e                	mv	a0,s7
    800038b6:	00000097          	auipc	ra,0x0
    800038ba:	c74080e7          	jalr	-908(ra) # 8000352a <bread>
    800038be:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800038c0:	004b2503          	lw	a0,4(s6)
    800038c4:	84d6                	mv	s1,s5
    800038c6:	4701                	li	a4,0
    800038c8:	fca4f0e3          	bgeu	s1,a0,80003888 <balloc+0xa2>
      m = 1 << (bi % 8);
    800038cc:	00777693          	andi	a3,a4,7
    800038d0:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800038d4:	41f7579b          	sraiw	a5,a4,0x1f
    800038d8:	01d7d79b          	srliw	a5,a5,0x1d
    800038dc:	9fb9                	addw	a5,a5,a4
    800038de:	4037d79b          	sraiw	a5,a5,0x3
    800038e2:	00f90633          	add	a2,s2,a5
    800038e6:	05864603          	lbu	a2,88(a2)
    800038ea:	00c6f5b3          	and	a1,a3,a2
    800038ee:	d985                	beqz	a1,8000381e <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800038f0:	2705                	addiw	a4,a4,1
    800038f2:	2485                	addiw	s1,s1,1
    800038f4:	fd471ae3          	bne	a4,s4,800038c8 <balloc+0xe2>
    800038f8:	bf41                	j	80003888 <balloc+0xa2>
    800038fa:	7942                	ld	s2,48(sp)
    800038fc:	79a2                	ld	s3,40(sp)
    800038fe:	7a02                	ld	s4,32(sp)
    80003900:	6ae2                	ld	s5,24(sp)
    80003902:	6b42                	ld	s6,16(sp)
    80003904:	6ba2                	ld	s7,8(sp)
    80003906:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    80003908:	00005517          	auipc	a0,0x5
    8000390c:	c2050513          	addi	a0,a0,-992 # 80008528 <etext+0x528>
    80003910:	ffffd097          	auipc	ra,0xffffd
    80003914:	c9a080e7          	jalr	-870(ra) # 800005aa <printf>
  return 0;
    80003918:	4481                	li	s1,0
    8000391a:	b78d                	j	8000387c <balloc+0x96>

000000008000391c <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000391c:	7179                	addi	sp,sp,-48
    8000391e:	f406                	sd	ra,40(sp)
    80003920:	f022                	sd	s0,32(sp)
    80003922:	ec26                	sd	s1,24(sp)
    80003924:	e84a                	sd	s2,16(sp)
    80003926:	e44e                	sd	s3,8(sp)
    80003928:	1800                	addi	s0,sp,48
    8000392a:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000392c:	47ad                	li	a5,11
    8000392e:	02b7e563          	bltu	a5,a1,80003958 <bmap+0x3c>
    if((addr = ip->addrs[bn]) == 0){
    80003932:	02059793          	slli	a5,a1,0x20
    80003936:	01e7d593          	srli	a1,a5,0x1e
    8000393a:	00b504b3          	add	s1,a0,a1
    8000393e:	0504a903          	lw	s2,80(s1)
    80003942:	06091b63          	bnez	s2,800039b8 <bmap+0x9c>
      addr = balloc(ip->dev);
    80003946:	4108                	lw	a0,0(a0)
    80003948:	00000097          	auipc	ra,0x0
    8000394c:	e9e080e7          	jalr	-354(ra) # 800037e6 <balloc>
    80003950:	892a                	mv	s2,a0
      if(addr == 0)
    80003952:	c13d                	beqz	a0,800039b8 <bmap+0x9c>
        return 0;
      ip->addrs[bn] = addr;
    80003954:	c8a8                	sw	a0,80(s1)
    80003956:	a08d                	j	800039b8 <bmap+0x9c>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003958:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    8000395c:	0ff00793          	li	a5,255
    80003960:	0897e363          	bltu	a5,s1,800039e6 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003964:	08052903          	lw	s2,128(a0)
    80003968:	00091d63          	bnez	s2,80003982 <bmap+0x66>
      addr = balloc(ip->dev);
    8000396c:	4108                	lw	a0,0(a0)
    8000396e:	00000097          	auipc	ra,0x0
    80003972:	e78080e7          	jalr	-392(ra) # 800037e6 <balloc>
    80003976:	892a                	mv	s2,a0
      if(addr == 0)
    80003978:	c121                	beqz	a0,800039b8 <bmap+0x9c>
    8000397a:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000397c:	08a9a023          	sw	a0,128(s3)
    80003980:	a011                	j	80003984 <bmap+0x68>
    80003982:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003984:	85ca                	mv	a1,s2
    80003986:	0009a503          	lw	a0,0(s3)
    8000398a:	00000097          	auipc	ra,0x0
    8000398e:	ba0080e7          	jalr	-1120(ra) # 8000352a <bread>
    80003992:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003994:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003998:	02049713          	slli	a4,s1,0x20
    8000399c:	01e75593          	srli	a1,a4,0x1e
    800039a0:	00b784b3          	add	s1,a5,a1
    800039a4:	0004a903          	lw	s2,0(s1)
    800039a8:	02090063          	beqz	s2,800039c8 <bmap+0xac>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800039ac:	8552                	mv	a0,s4
    800039ae:	00000097          	auipc	ra,0x0
    800039b2:	cac080e7          	jalr	-852(ra) # 8000365a <brelse>
    return addr;
    800039b6:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800039b8:	854a                	mv	a0,s2
    800039ba:	70a2                	ld	ra,40(sp)
    800039bc:	7402                	ld	s0,32(sp)
    800039be:	64e2                	ld	s1,24(sp)
    800039c0:	6942                	ld	s2,16(sp)
    800039c2:	69a2                	ld	s3,8(sp)
    800039c4:	6145                	addi	sp,sp,48
    800039c6:	8082                	ret
      addr = balloc(ip->dev);
    800039c8:	0009a503          	lw	a0,0(s3)
    800039cc:	00000097          	auipc	ra,0x0
    800039d0:	e1a080e7          	jalr	-486(ra) # 800037e6 <balloc>
    800039d4:	892a                	mv	s2,a0
      if(addr){
    800039d6:	d979                	beqz	a0,800039ac <bmap+0x90>
        a[bn] = addr;
    800039d8:	c088                	sw	a0,0(s1)
        log_write(bp);
    800039da:	8552                	mv	a0,s4
    800039dc:	00001097          	auipc	ra,0x1
    800039e0:	f24080e7          	jalr	-220(ra) # 80004900 <log_write>
    800039e4:	b7e1                	j	800039ac <bmap+0x90>
    800039e6:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800039e8:	00005517          	auipc	a0,0x5
    800039ec:	b5850513          	addi	a0,a0,-1192 # 80008540 <etext+0x540>
    800039f0:	ffffd097          	auipc	ra,0xffffd
    800039f4:	b70080e7          	jalr	-1168(ra) # 80000560 <panic>

00000000800039f8 <iget>:
{
    800039f8:	7179                	addi	sp,sp,-48
    800039fa:	f406                	sd	ra,40(sp)
    800039fc:	f022                	sd	s0,32(sp)
    800039fe:	ec26                	sd	s1,24(sp)
    80003a00:	e84a                	sd	s2,16(sp)
    80003a02:	e44e                	sd	s3,8(sp)
    80003a04:	e052                	sd	s4,0(sp)
    80003a06:	1800                	addi	s0,sp,48
    80003a08:	89aa                	mv	s3,a0
    80003a0a:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003a0c:	0001c517          	auipc	a0,0x1c
    80003a10:	42c50513          	addi	a0,a0,1068 # 8001fe38 <itable>
    80003a14:	ffffd097          	auipc	ra,0xffffd
    80003a18:	22a080e7          	jalr	554(ra) # 80000c3e <acquire>
  empty = 0;
    80003a1c:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003a1e:	0001c497          	auipc	s1,0x1c
    80003a22:	43248493          	addi	s1,s1,1074 # 8001fe50 <itable+0x18>
    80003a26:	0001e697          	auipc	a3,0x1e
    80003a2a:	eba68693          	addi	a3,a3,-326 # 800218e0 <log>
    80003a2e:	a039                	j	80003a3c <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003a30:	02090b63          	beqz	s2,80003a66 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003a34:	08848493          	addi	s1,s1,136
    80003a38:	02d48a63          	beq	s1,a3,80003a6c <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003a3c:	449c                	lw	a5,8(s1)
    80003a3e:	fef059e3          	blez	a5,80003a30 <iget+0x38>
    80003a42:	4098                	lw	a4,0(s1)
    80003a44:	ff3716e3          	bne	a4,s3,80003a30 <iget+0x38>
    80003a48:	40d8                	lw	a4,4(s1)
    80003a4a:	ff4713e3          	bne	a4,s4,80003a30 <iget+0x38>
      ip->ref++;
    80003a4e:	2785                	addiw	a5,a5,1
    80003a50:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003a52:	0001c517          	auipc	a0,0x1c
    80003a56:	3e650513          	addi	a0,a0,998 # 8001fe38 <itable>
    80003a5a:	ffffd097          	auipc	ra,0xffffd
    80003a5e:	294080e7          	jalr	660(ra) # 80000cee <release>
      return ip;
    80003a62:	8926                	mv	s2,s1
    80003a64:	a03d                	j	80003a92 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003a66:	f7f9                	bnez	a5,80003a34 <iget+0x3c>
      empty = ip;
    80003a68:	8926                	mv	s2,s1
    80003a6a:	b7e9                	j	80003a34 <iget+0x3c>
  if(empty == 0)
    80003a6c:	02090c63          	beqz	s2,80003aa4 <iget+0xac>
  ip->dev = dev;
    80003a70:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003a74:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003a78:	4785                	li	a5,1
    80003a7a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003a7e:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003a82:	0001c517          	auipc	a0,0x1c
    80003a86:	3b650513          	addi	a0,a0,950 # 8001fe38 <itable>
    80003a8a:	ffffd097          	auipc	ra,0xffffd
    80003a8e:	264080e7          	jalr	612(ra) # 80000cee <release>
}
    80003a92:	854a                	mv	a0,s2
    80003a94:	70a2                	ld	ra,40(sp)
    80003a96:	7402                	ld	s0,32(sp)
    80003a98:	64e2                	ld	s1,24(sp)
    80003a9a:	6942                	ld	s2,16(sp)
    80003a9c:	69a2                	ld	s3,8(sp)
    80003a9e:	6a02                	ld	s4,0(sp)
    80003aa0:	6145                	addi	sp,sp,48
    80003aa2:	8082                	ret
    panic("iget: no inodes");
    80003aa4:	00005517          	auipc	a0,0x5
    80003aa8:	ab450513          	addi	a0,a0,-1356 # 80008558 <etext+0x558>
    80003aac:	ffffd097          	auipc	ra,0xffffd
    80003ab0:	ab4080e7          	jalr	-1356(ra) # 80000560 <panic>

0000000080003ab4 <fsinit>:
fsinit(int dev) {
    80003ab4:	7179                	addi	sp,sp,-48
    80003ab6:	f406                	sd	ra,40(sp)
    80003ab8:	f022                	sd	s0,32(sp)
    80003aba:	ec26                	sd	s1,24(sp)
    80003abc:	e84a                	sd	s2,16(sp)
    80003abe:	e44e                	sd	s3,8(sp)
    80003ac0:	1800                	addi	s0,sp,48
    80003ac2:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003ac4:	4585                	li	a1,1
    80003ac6:	00000097          	auipc	ra,0x0
    80003aca:	a64080e7          	jalr	-1436(ra) # 8000352a <bread>
    80003ace:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003ad0:	0001c997          	auipc	s3,0x1c
    80003ad4:	34898993          	addi	s3,s3,840 # 8001fe18 <sb>
    80003ad8:	02000613          	li	a2,32
    80003adc:	05850593          	addi	a1,a0,88
    80003ae0:	854e                	mv	a0,s3
    80003ae2:	ffffd097          	auipc	ra,0xffffd
    80003ae6:	2b8080e7          	jalr	696(ra) # 80000d9a <memmove>
  brelse(bp);
    80003aea:	8526                	mv	a0,s1
    80003aec:	00000097          	auipc	ra,0x0
    80003af0:	b6e080e7          	jalr	-1170(ra) # 8000365a <brelse>
  if(sb.magic != FSMAGIC)
    80003af4:	0009a703          	lw	a4,0(s3)
    80003af8:	102037b7          	lui	a5,0x10203
    80003afc:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003b00:	02f71263          	bne	a4,a5,80003b24 <fsinit+0x70>
  initlog(dev, &sb);
    80003b04:	0001c597          	auipc	a1,0x1c
    80003b08:	31458593          	addi	a1,a1,788 # 8001fe18 <sb>
    80003b0c:	854a                	mv	a0,s2
    80003b0e:	00001097          	auipc	ra,0x1
    80003b12:	b7c080e7          	jalr	-1156(ra) # 8000468a <initlog>
}
    80003b16:	70a2                	ld	ra,40(sp)
    80003b18:	7402                	ld	s0,32(sp)
    80003b1a:	64e2                	ld	s1,24(sp)
    80003b1c:	6942                	ld	s2,16(sp)
    80003b1e:	69a2                	ld	s3,8(sp)
    80003b20:	6145                	addi	sp,sp,48
    80003b22:	8082                	ret
    panic("invalid file system");
    80003b24:	00005517          	auipc	a0,0x5
    80003b28:	a4450513          	addi	a0,a0,-1468 # 80008568 <etext+0x568>
    80003b2c:	ffffd097          	auipc	ra,0xffffd
    80003b30:	a34080e7          	jalr	-1484(ra) # 80000560 <panic>

0000000080003b34 <iinit>:
{
    80003b34:	7179                	addi	sp,sp,-48
    80003b36:	f406                	sd	ra,40(sp)
    80003b38:	f022                	sd	s0,32(sp)
    80003b3a:	ec26                	sd	s1,24(sp)
    80003b3c:	e84a                	sd	s2,16(sp)
    80003b3e:	e44e                	sd	s3,8(sp)
    80003b40:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003b42:	00005597          	auipc	a1,0x5
    80003b46:	a3e58593          	addi	a1,a1,-1474 # 80008580 <etext+0x580>
    80003b4a:	0001c517          	auipc	a0,0x1c
    80003b4e:	2ee50513          	addi	a0,a0,750 # 8001fe38 <itable>
    80003b52:	ffffd097          	auipc	ra,0xffffd
    80003b56:	058080e7          	jalr	88(ra) # 80000baa <initlock>
  for(i = 0; i < NINODE; i++) {
    80003b5a:	0001c497          	auipc	s1,0x1c
    80003b5e:	30648493          	addi	s1,s1,774 # 8001fe60 <itable+0x28>
    80003b62:	0001e997          	auipc	s3,0x1e
    80003b66:	d8e98993          	addi	s3,s3,-626 # 800218f0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003b6a:	00005917          	auipc	s2,0x5
    80003b6e:	a1e90913          	addi	s2,s2,-1506 # 80008588 <etext+0x588>
    80003b72:	85ca                	mv	a1,s2
    80003b74:	8526                	mv	a0,s1
    80003b76:	00001097          	auipc	ra,0x1
    80003b7a:	e6e080e7          	jalr	-402(ra) # 800049e4 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003b7e:	08848493          	addi	s1,s1,136
    80003b82:	ff3498e3          	bne	s1,s3,80003b72 <iinit+0x3e>
}
    80003b86:	70a2                	ld	ra,40(sp)
    80003b88:	7402                	ld	s0,32(sp)
    80003b8a:	64e2                	ld	s1,24(sp)
    80003b8c:	6942                	ld	s2,16(sp)
    80003b8e:	69a2                	ld	s3,8(sp)
    80003b90:	6145                	addi	sp,sp,48
    80003b92:	8082                	ret

0000000080003b94 <ialloc>:
{
    80003b94:	7139                	addi	sp,sp,-64
    80003b96:	fc06                	sd	ra,56(sp)
    80003b98:	f822                	sd	s0,48(sp)
    80003b9a:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003b9c:	0001c717          	auipc	a4,0x1c
    80003ba0:	28872703          	lw	a4,648(a4) # 8001fe24 <sb+0xc>
    80003ba4:	4785                	li	a5,1
    80003ba6:	06e7f463          	bgeu	a5,a4,80003c0e <ialloc+0x7a>
    80003baa:	f426                	sd	s1,40(sp)
    80003bac:	f04a                	sd	s2,32(sp)
    80003bae:	ec4e                	sd	s3,24(sp)
    80003bb0:	e852                	sd	s4,16(sp)
    80003bb2:	e456                	sd	s5,8(sp)
    80003bb4:	e05a                	sd	s6,0(sp)
    80003bb6:	8aaa                	mv	s5,a0
    80003bb8:	8b2e                	mv	s6,a1
    80003bba:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80003bbc:	0001ca17          	auipc	s4,0x1c
    80003bc0:	25ca0a13          	addi	s4,s4,604 # 8001fe18 <sb>
    80003bc4:	00495593          	srli	a1,s2,0x4
    80003bc8:	018a2783          	lw	a5,24(s4)
    80003bcc:	9dbd                	addw	a1,a1,a5
    80003bce:	8556                	mv	a0,s5
    80003bd0:	00000097          	auipc	ra,0x0
    80003bd4:	95a080e7          	jalr	-1702(ra) # 8000352a <bread>
    80003bd8:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003bda:	05850993          	addi	s3,a0,88
    80003bde:	00f97793          	andi	a5,s2,15
    80003be2:	079a                	slli	a5,a5,0x6
    80003be4:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003be6:	00099783          	lh	a5,0(s3)
    80003bea:	cf9d                	beqz	a5,80003c28 <ialloc+0x94>
    brelse(bp);
    80003bec:	00000097          	auipc	ra,0x0
    80003bf0:	a6e080e7          	jalr	-1426(ra) # 8000365a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003bf4:	0905                	addi	s2,s2,1
    80003bf6:	00ca2703          	lw	a4,12(s4)
    80003bfa:	0009079b          	sext.w	a5,s2
    80003bfe:	fce7e3e3          	bltu	a5,a4,80003bc4 <ialloc+0x30>
    80003c02:	74a2                	ld	s1,40(sp)
    80003c04:	7902                	ld	s2,32(sp)
    80003c06:	69e2                	ld	s3,24(sp)
    80003c08:	6a42                	ld	s4,16(sp)
    80003c0a:	6aa2                	ld	s5,8(sp)
    80003c0c:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003c0e:	00005517          	auipc	a0,0x5
    80003c12:	98250513          	addi	a0,a0,-1662 # 80008590 <etext+0x590>
    80003c16:	ffffd097          	auipc	ra,0xffffd
    80003c1a:	994080e7          	jalr	-1644(ra) # 800005aa <printf>
  return 0;
    80003c1e:	4501                	li	a0,0
}
    80003c20:	70e2                	ld	ra,56(sp)
    80003c22:	7442                	ld	s0,48(sp)
    80003c24:	6121                	addi	sp,sp,64
    80003c26:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003c28:	04000613          	li	a2,64
    80003c2c:	4581                	li	a1,0
    80003c2e:	854e                	mv	a0,s3
    80003c30:	ffffd097          	auipc	ra,0xffffd
    80003c34:	106080e7          	jalr	262(ra) # 80000d36 <memset>
      dip->type = type;
    80003c38:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003c3c:	8526                	mv	a0,s1
    80003c3e:	00001097          	auipc	ra,0x1
    80003c42:	cc2080e7          	jalr	-830(ra) # 80004900 <log_write>
      brelse(bp);
    80003c46:	8526                	mv	a0,s1
    80003c48:	00000097          	auipc	ra,0x0
    80003c4c:	a12080e7          	jalr	-1518(ra) # 8000365a <brelse>
      return iget(dev, inum);
    80003c50:	0009059b          	sext.w	a1,s2
    80003c54:	8556                	mv	a0,s5
    80003c56:	00000097          	auipc	ra,0x0
    80003c5a:	da2080e7          	jalr	-606(ra) # 800039f8 <iget>
    80003c5e:	74a2                	ld	s1,40(sp)
    80003c60:	7902                	ld	s2,32(sp)
    80003c62:	69e2                	ld	s3,24(sp)
    80003c64:	6a42                	ld	s4,16(sp)
    80003c66:	6aa2                	ld	s5,8(sp)
    80003c68:	6b02                	ld	s6,0(sp)
    80003c6a:	bf5d                	j	80003c20 <ialloc+0x8c>

0000000080003c6c <iupdate>:
{
    80003c6c:	1101                	addi	sp,sp,-32
    80003c6e:	ec06                	sd	ra,24(sp)
    80003c70:	e822                	sd	s0,16(sp)
    80003c72:	e426                	sd	s1,8(sp)
    80003c74:	e04a                	sd	s2,0(sp)
    80003c76:	1000                	addi	s0,sp,32
    80003c78:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003c7a:	415c                	lw	a5,4(a0)
    80003c7c:	0047d79b          	srliw	a5,a5,0x4
    80003c80:	0001c597          	auipc	a1,0x1c
    80003c84:	1b05a583          	lw	a1,432(a1) # 8001fe30 <sb+0x18>
    80003c88:	9dbd                	addw	a1,a1,a5
    80003c8a:	4108                	lw	a0,0(a0)
    80003c8c:	00000097          	auipc	ra,0x0
    80003c90:	89e080e7          	jalr	-1890(ra) # 8000352a <bread>
    80003c94:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003c96:	05850793          	addi	a5,a0,88
    80003c9a:	40d8                	lw	a4,4(s1)
    80003c9c:	8b3d                	andi	a4,a4,15
    80003c9e:	071a                	slli	a4,a4,0x6
    80003ca0:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003ca2:	04449703          	lh	a4,68(s1)
    80003ca6:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003caa:	04649703          	lh	a4,70(s1)
    80003cae:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003cb2:	04849703          	lh	a4,72(s1)
    80003cb6:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003cba:	04a49703          	lh	a4,74(s1)
    80003cbe:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003cc2:	44f8                	lw	a4,76(s1)
    80003cc4:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003cc6:	03400613          	li	a2,52
    80003cca:	05048593          	addi	a1,s1,80
    80003cce:	00c78513          	addi	a0,a5,12
    80003cd2:	ffffd097          	auipc	ra,0xffffd
    80003cd6:	0c8080e7          	jalr	200(ra) # 80000d9a <memmove>
  log_write(bp);
    80003cda:	854a                	mv	a0,s2
    80003cdc:	00001097          	auipc	ra,0x1
    80003ce0:	c24080e7          	jalr	-988(ra) # 80004900 <log_write>
  brelse(bp);
    80003ce4:	854a                	mv	a0,s2
    80003ce6:	00000097          	auipc	ra,0x0
    80003cea:	974080e7          	jalr	-1676(ra) # 8000365a <brelse>
}
    80003cee:	60e2                	ld	ra,24(sp)
    80003cf0:	6442                	ld	s0,16(sp)
    80003cf2:	64a2                	ld	s1,8(sp)
    80003cf4:	6902                	ld	s2,0(sp)
    80003cf6:	6105                	addi	sp,sp,32
    80003cf8:	8082                	ret

0000000080003cfa <idup>:
{
    80003cfa:	1101                	addi	sp,sp,-32
    80003cfc:	ec06                	sd	ra,24(sp)
    80003cfe:	e822                	sd	s0,16(sp)
    80003d00:	e426                	sd	s1,8(sp)
    80003d02:	1000                	addi	s0,sp,32
    80003d04:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003d06:	0001c517          	auipc	a0,0x1c
    80003d0a:	13250513          	addi	a0,a0,306 # 8001fe38 <itable>
    80003d0e:	ffffd097          	auipc	ra,0xffffd
    80003d12:	f30080e7          	jalr	-208(ra) # 80000c3e <acquire>
  ip->ref++;
    80003d16:	449c                	lw	a5,8(s1)
    80003d18:	2785                	addiw	a5,a5,1
    80003d1a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003d1c:	0001c517          	auipc	a0,0x1c
    80003d20:	11c50513          	addi	a0,a0,284 # 8001fe38 <itable>
    80003d24:	ffffd097          	auipc	ra,0xffffd
    80003d28:	fca080e7          	jalr	-54(ra) # 80000cee <release>
}
    80003d2c:	8526                	mv	a0,s1
    80003d2e:	60e2                	ld	ra,24(sp)
    80003d30:	6442                	ld	s0,16(sp)
    80003d32:	64a2                	ld	s1,8(sp)
    80003d34:	6105                	addi	sp,sp,32
    80003d36:	8082                	ret

0000000080003d38 <ilock>:
{
    80003d38:	1101                	addi	sp,sp,-32
    80003d3a:	ec06                	sd	ra,24(sp)
    80003d3c:	e822                	sd	s0,16(sp)
    80003d3e:	e426                	sd	s1,8(sp)
    80003d40:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003d42:	c10d                	beqz	a0,80003d64 <ilock+0x2c>
    80003d44:	84aa                	mv	s1,a0
    80003d46:	451c                	lw	a5,8(a0)
    80003d48:	00f05e63          	blez	a5,80003d64 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80003d4c:	0541                	addi	a0,a0,16
    80003d4e:	00001097          	auipc	ra,0x1
    80003d52:	cd0080e7          	jalr	-816(ra) # 80004a1e <acquiresleep>
  if(ip->valid == 0){
    80003d56:	40bc                	lw	a5,64(s1)
    80003d58:	cf99                	beqz	a5,80003d76 <ilock+0x3e>
}
    80003d5a:	60e2                	ld	ra,24(sp)
    80003d5c:	6442                	ld	s0,16(sp)
    80003d5e:	64a2                	ld	s1,8(sp)
    80003d60:	6105                	addi	sp,sp,32
    80003d62:	8082                	ret
    80003d64:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003d66:	00005517          	auipc	a0,0x5
    80003d6a:	84250513          	addi	a0,a0,-1982 # 800085a8 <etext+0x5a8>
    80003d6e:	ffffc097          	auipc	ra,0xffffc
    80003d72:	7f2080e7          	jalr	2034(ra) # 80000560 <panic>
    80003d76:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003d78:	40dc                	lw	a5,4(s1)
    80003d7a:	0047d79b          	srliw	a5,a5,0x4
    80003d7e:	0001c597          	auipc	a1,0x1c
    80003d82:	0b25a583          	lw	a1,178(a1) # 8001fe30 <sb+0x18>
    80003d86:	9dbd                	addw	a1,a1,a5
    80003d88:	4088                	lw	a0,0(s1)
    80003d8a:	fffff097          	auipc	ra,0xfffff
    80003d8e:	7a0080e7          	jalr	1952(ra) # 8000352a <bread>
    80003d92:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003d94:	05850593          	addi	a1,a0,88
    80003d98:	40dc                	lw	a5,4(s1)
    80003d9a:	8bbd                	andi	a5,a5,15
    80003d9c:	079a                	slli	a5,a5,0x6
    80003d9e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003da0:	00059783          	lh	a5,0(a1)
    80003da4:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003da8:	00259783          	lh	a5,2(a1)
    80003dac:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003db0:	00459783          	lh	a5,4(a1)
    80003db4:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003db8:	00659783          	lh	a5,6(a1)
    80003dbc:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003dc0:	459c                	lw	a5,8(a1)
    80003dc2:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003dc4:	03400613          	li	a2,52
    80003dc8:	05b1                	addi	a1,a1,12
    80003dca:	05048513          	addi	a0,s1,80
    80003dce:	ffffd097          	auipc	ra,0xffffd
    80003dd2:	fcc080e7          	jalr	-52(ra) # 80000d9a <memmove>
    brelse(bp);
    80003dd6:	854a                	mv	a0,s2
    80003dd8:	00000097          	auipc	ra,0x0
    80003ddc:	882080e7          	jalr	-1918(ra) # 8000365a <brelse>
    ip->valid = 1;
    80003de0:	4785                	li	a5,1
    80003de2:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003de4:	04449783          	lh	a5,68(s1)
    80003de8:	c399                	beqz	a5,80003dee <ilock+0xb6>
    80003dea:	6902                	ld	s2,0(sp)
    80003dec:	b7bd                	j	80003d5a <ilock+0x22>
      panic("ilock: no type");
    80003dee:	00004517          	auipc	a0,0x4
    80003df2:	7c250513          	addi	a0,a0,1986 # 800085b0 <etext+0x5b0>
    80003df6:	ffffc097          	auipc	ra,0xffffc
    80003dfa:	76a080e7          	jalr	1898(ra) # 80000560 <panic>

0000000080003dfe <iunlock>:
{
    80003dfe:	1101                	addi	sp,sp,-32
    80003e00:	ec06                	sd	ra,24(sp)
    80003e02:	e822                	sd	s0,16(sp)
    80003e04:	e426                	sd	s1,8(sp)
    80003e06:	e04a                	sd	s2,0(sp)
    80003e08:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003e0a:	c905                	beqz	a0,80003e3a <iunlock+0x3c>
    80003e0c:	84aa                	mv	s1,a0
    80003e0e:	01050913          	addi	s2,a0,16
    80003e12:	854a                	mv	a0,s2
    80003e14:	00001097          	auipc	ra,0x1
    80003e18:	ca4080e7          	jalr	-860(ra) # 80004ab8 <holdingsleep>
    80003e1c:	cd19                	beqz	a0,80003e3a <iunlock+0x3c>
    80003e1e:	449c                	lw	a5,8(s1)
    80003e20:	00f05d63          	blez	a5,80003e3a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003e24:	854a                	mv	a0,s2
    80003e26:	00001097          	auipc	ra,0x1
    80003e2a:	c4e080e7          	jalr	-946(ra) # 80004a74 <releasesleep>
}
    80003e2e:	60e2                	ld	ra,24(sp)
    80003e30:	6442                	ld	s0,16(sp)
    80003e32:	64a2                	ld	s1,8(sp)
    80003e34:	6902                	ld	s2,0(sp)
    80003e36:	6105                	addi	sp,sp,32
    80003e38:	8082                	ret
    panic("iunlock");
    80003e3a:	00004517          	auipc	a0,0x4
    80003e3e:	78650513          	addi	a0,a0,1926 # 800085c0 <etext+0x5c0>
    80003e42:	ffffc097          	auipc	ra,0xffffc
    80003e46:	71e080e7          	jalr	1822(ra) # 80000560 <panic>

0000000080003e4a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003e4a:	7179                	addi	sp,sp,-48
    80003e4c:	f406                	sd	ra,40(sp)
    80003e4e:	f022                	sd	s0,32(sp)
    80003e50:	ec26                	sd	s1,24(sp)
    80003e52:	e84a                	sd	s2,16(sp)
    80003e54:	e44e                	sd	s3,8(sp)
    80003e56:	1800                	addi	s0,sp,48
    80003e58:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003e5a:	05050493          	addi	s1,a0,80
    80003e5e:	08050913          	addi	s2,a0,128
    80003e62:	a021                	j	80003e6a <itrunc+0x20>
    80003e64:	0491                	addi	s1,s1,4
    80003e66:	01248d63          	beq	s1,s2,80003e80 <itrunc+0x36>
    if(ip->addrs[i]){
    80003e6a:	408c                	lw	a1,0(s1)
    80003e6c:	dde5                	beqz	a1,80003e64 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003e6e:	0009a503          	lw	a0,0(s3)
    80003e72:	00000097          	auipc	ra,0x0
    80003e76:	8f8080e7          	jalr	-1800(ra) # 8000376a <bfree>
      ip->addrs[i] = 0;
    80003e7a:	0004a023          	sw	zero,0(s1)
    80003e7e:	b7dd                	j	80003e64 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003e80:	0809a583          	lw	a1,128(s3)
    80003e84:	ed99                	bnez	a1,80003ea2 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003e86:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003e8a:	854e                	mv	a0,s3
    80003e8c:	00000097          	auipc	ra,0x0
    80003e90:	de0080e7          	jalr	-544(ra) # 80003c6c <iupdate>
}
    80003e94:	70a2                	ld	ra,40(sp)
    80003e96:	7402                	ld	s0,32(sp)
    80003e98:	64e2                	ld	s1,24(sp)
    80003e9a:	6942                	ld	s2,16(sp)
    80003e9c:	69a2                	ld	s3,8(sp)
    80003e9e:	6145                	addi	sp,sp,48
    80003ea0:	8082                	ret
    80003ea2:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003ea4:	0009a503          	lw	a0,0(s3)
    80003ea8:	fffff097          	auipc	ra,0xfffff
    80003eac:	682080e7          	jalr	1666(ra) # 8000352a <bread>
    80003eb0:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003eb2:	05850493          	addi	s1,a0,88
    80003eb6:	45850913          	addi	s2,a0,1112
    80003eba:	a021                	j	80003ec2 <itrunc+0x78>
    80003ebc:	0491                	addi	s1,s1,4
    80003ebe:	01248b63          	beq	s1,s2,80003ed4 <itrunc+0x8a>
      if(a[j])
    80003ec2:	408c                	lw	a1,0(s1)
    80003ec4:	dde5                	beqz	a1,80003ebc <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80003ec6:	0009a503          	lw	a0,0(s3)
    80003eca:	00000097          	auipc	ra,0x0
    80003ece:	8a0080e7          	jalr	-1888(ra) # 8000376a <bfree>
    80003ed2:	b7ed                	j	80003ebc <itrunc+0x72>
    brelse(bp);
    80003ed4:	8552                	mv	a0,s4
    80003ed6:	fffff097          	auipc	ra,0xfffff
    80003eda:	784080e7          	jalr	1924(ra) # 8000365a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003ede:	0809a583          	lw	a1,128(s3)
    80003ee2:	0009a503          	lw	a0,0(s3)
    80003ee6:	00000097          	auipc	ra,0x0
    80003eea:	884080e7          	jalr	-1916(ra) # 8000376a <bfree>
    ip->addrs[NDIRECT] = 0;
    80003eee:	0809a023          	sw	zero,128(s3)
    80003ef2:	6a02                	ld	s4,0(sp)
    80003ef4:	bf49                	j	80003e86 <itrunc+0x3c>

0000000080003ef6 <iput>:
{
    80003ef6:	1101                	addi	sp,sp,-32
    80003ef8:	ec06                	sd	ra,24(sp)
    80003efa:	e822                	sd	s0,16(sp)
    80003efc:	e426                	sd	s1,8(sp)
    80003efe:	1000                	addi	s0,sp,32
    80003f00:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003f02:	0001c517          	auipc	a0,0x1c
    80003f06:	f3650513          	addi	a0,a0,-202 # 8001fe38 <itable>
    80003f0a:	ffffd097          	auipc	ra,0xffffd
    80003f0e:	d34080e7          	jalr	-716(ra) # 80000c3e <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003f12:	4498                	lw	a4,8(s1)
    80003f14:	4785                	li	a5,1
    80003f16:	02f70263          	beq	a4,a5,80003f3a <iput+0x44>
  ip->ref--;
    80003f1a:	449c                	lw	a5,8(s1)
    80003f1c:	37fd                	addiw	a5,a5,-1
    80003f1e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003f20:	0001c517          	auipc	a0,0x1c
    80003f24:	f1850513          	addi	a0,a0,-232 # 8001fe38 <itable>
    80003f28:	ffffd097          	auipc	ra,0xffffd
    80003f2c:	dc6080e7          	jalr	-570(ra) # 80000cee <release>
}
    80003f30:	60e2                	ld	ra,24(sp)
    80003f32:	6442                	ld	s0,16(sp)
    80003f34:	64a2                	ld	s1,8(sp)
    80003f36:	6105                	addi	sp,sp,32
    80003f38:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003f3a:	40bc                	lw	a5,64(s1)
    80003f3c:	dff9                	beqz	a5,80003f1a <iput+0x24>
    80003f3e:	04a49783          	lh	a5,74(s1)
    80003f42:	ffe1                	bnez	a5,80003f1a <iput+0x24>
    80003f44:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003f46:	01048913          	addi	s2,s1,16
    80003f4a:	854a                	mv	a0,s2
    80003f4c:	00001097          	auipc	ra,0x1
    80003f50:	ad2080e7          	jalr	-1326(ra) # 80004a1e <acquiresleep>
    release(&itable.lock);
    80003f54:	0001c517          	auipc	a0,0x1c
    80003f58:	ee450513          	addi	a0,a0,-284 # 8001fe38 <itable>
    80003f5c:	ffffd097          	auipc	ra,0xffffd
    80003f60:	d92080e7          	jalr	-622(ra) # 80000cee <release>
    itrunc(ip);
    80003f64:	8526                	mv	a0,s1
    80003f66:	00000097          	auipc	ra,0x0
    80003f6a:	ee4080e7          	jalr	-284(ra) # 80003e4a <itrunc>
    ip->type = 0;
    80003f6e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003f72:	8526                	mv	a0,s1
    80003f74:	00000097          	auipc	ra,0x0
    80003f78:	cf8080e7          	jalr	-776(ra) # 80003c6c <iupdate>
    ip->valid = 0;
    80003f7c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003f80:	854a                	mv	a0,s2
    80003f82:	00001097          	auipc	ra,0x1
    80003f86:	af2080e7          	jalr	-1294(ra) # 80004a74 <releasesleep>
    acquire(&itable.lock);
    80003f8a:	0001c517          	auipc	a0,0x1c
    80003f8e:	eae50513          	addi	a0,a0,-338 # 8001fe38 <itable>
    80003f92:	ffffd097          	auipc	ra,0xffffd
    80003f96:	cac080e7          	jalr	-852(ra) # 80000c3e <acquire>
    80003f9a:	6902                	ld	s2,0(sp)
    80003f9c:	bfbd                	j	80003f1a <iput+0x24>

0000000080003f9e <iunlockput>:
{
    80003f9e:	1101                	addi	sp,sp,-32
    80003fa0:	ec06                	sd	ra,24(sp)
    80003fa2:	e822                	sd	s0,16(sp)
    80003fa4:	e426                	sd	s1,8(sp)
    80003fa6:	1000                	addi	s0,sp,32
    80003fa8:	84aa                	mv	s1,a0
  iunlock(ip);
    80003faa:	00000097          	auipc	ra,0x0
    80003fae:	e54080e7          	jalr	-428(ra) # 80003dfe <iunlock>
  iput(ip);
    80003fb2:	8526                	mv	a0,s1
    80003fb4:	00000097          	auipc	ra,0x0
    80003fb8:	f42080e7          	jalr	-190(ra) # 80003ef6 <iput>
}
    80003fbc:	60e2                	ld	ra,24(sp)
    80003fbe:	6442                	ld	s0,16(sp)
    80003fc0:	64a2                	ld	s1,8(sp)
    80003fc2:	6105                	addi	sp,sp,32
    80003fc4:	8082                	ret

0000000080003fc6 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003fc6:	1141                	addi	sp,sp,-16
    80003fc8:	e406                	sd	ra,8(sp)
    80003fca:	e022                	sd	s0,0(sp)
    80003fcc:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003fce:	411c                	lw	a5,0(a0)
    80003fd0:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003fd2:	415c                	lw	a5,4(a0)
    80003fd4:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003fd6:	04451783          	lh	a5,68(a0)
    80003fda:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003fde:	04a51783          	lh	a5,74(a0)
    80003fe2:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003fe6:	04c56783          	lwu	a5,76(a0)
    80003fea:	e99c                	sd	a5,16(a1)
}
    80003fec:	60a2                	ld	ra,8(sp)
    80003fee:	6402                	ld	s0,0(sp)
    80003ff0:	0141                	addi	sp,sp,16
    80003ff2:	8082                	ret

0000000080003ff4 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003ff4:	457c                	lw	a5,76(a0)
    80003ff6:	10d7e063          	bltu	a5,a3,800040f6 <readi+0x102>
{
    80003ffa:	7159                	addi	sp,sp,-112
    80003ffc:	f486                	sd	ra,104(sp)
    80003ffe:	f0a2                	sd	s0,96(sp)
    80004000:	eca6                	sd	s1,88(sp)
    80004002:	e0d2                	sd	s4,64(sp)
    80004004:	fc56                	sd	s5,56(sp)
    80004006:	f85a                	sd	s6,48(sp)
    80004008:	f45e                	sd	s7,40(sp)
    8000400a:	1880                	addi	s0,sp,112
    8000400c:	8b2a                	mv	s6,a0
    8000400e:	8bae                	mv	s7,a1
    80004010:	8a32                	mv	s4,a2
    80004012:	84b6                	mv	s1,a3
    80004014:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80004016:	9f35                	addw	a4,a4,a3
    return 0;
    80004018:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000401a:	0cd76563          	bltu	a4,a3,800040e4 <readi+0xf0>
    8000401e:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80004020:	00e7f463          	bgeu	a5,a4,80004028 <readi+0x34>
    n = ip->size - off;
    80004024:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004028:	0a0a8563          	beqz	s5,800040d2 <readi+0xde>
    8000402c:	e8ca                	sd	s2,80(sp)
    8000402e:	f062                	sd	s8,32(sp)
    80004030:	ec66                	sd	s9,24(sp)
    80004032:	e86a                	sd	s10,16(sp)
    80004034:	e46e                	sd	s11,8(sp)
    80004036:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80004038:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000403c:	5c7d                	li	s8,-1
    8000403e:	a82d                	j	80004078 <readi+0x84>
    80004040:	020d1d93          	slli	s11,s10,0x20
    80004044:	020ddd93          	srli	s11,s11,0x20
    80004048:	05890613          	addi	a2,s2,88
    8000404c:	86ee                	mv	a3,s11
    8000404e:	963e                	add	a2,a2,a5
    80004050:	85d2                	mv	a1,s4
    80004052:	855e                	mv	a0,s7
    80004054:	fffff097          	auipc	ra,0xfffff
    80004058:	922080e7          	jalr	-1758(ra) # 80002976 <either_copyout>
    8000405c:	05850963          	beq	a0,s8,800040ae <readi+0xba>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80004060:	854a                	mv	a0,s2
    80004062:	fffff097          	auipc	ra,0xfffff
    80004066:	5f8080e7          	jalr	1528(ra) # 8000365a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000406a:	013d09bb          	addw	s3,s10,s3
    8000406e:	009d04bb          	addw	s1,s10,s1
    80004072:	9a6e                	add	s4,s4,s11
    80004074:	0559f963          	bgeu	s3,s5,800040c6 <readi+0xd2>
    uint addr = bmap(ip, off/BSIZE);
    80004078:	00a4d59b          	srliw	a1,s1,0xa
    8000407c:	855a                	mv	a0,s6
    8000407e:	00000097          	auipc	ra,0x0
    80004082:	89e080e7          	jalr	-1890(ra) # 8000391c <bmap>
    80004086:	85aa                	mv	a1,a0
    if(addr == 0)
    80004088:	c539                	beqz	a0,800040d6 <readi+0xe2>
    bp = bread(ip->dev, addr);
    8000408a:	000b2503          	lw	a0,0(s6)
    8000408e:	fffff097          	auipc	ra,0xfffff
    80004092:	49c080e7          	jalr	1180(ra) # 8000352a <bread>
    80004096:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004098:	3ff4f793          	andi	a5,s1,1023
    8000409c:	40fc873b          	subw	a4,s9,a5
    800040a0:	413a86bb          	subw	a3,s5,s3
    800040a4:	8d3a                	mv	s10,a4
    800040a6:	f8e6fde3          	bgeu	a3,a4,80004040 <readi+0x4c>
    800040aa:	8d36                	mv	s10,a3
    800040ac:	bf51                	j	80004040 <readi+0x4c>
      brelse(bp);
    800040ae:	854a                	mv	a0,s2
    800040b0:	fffff097          	auipc	ra,0xfffff
    800040b4:	5aa080e7          	jalr	1450(ra) # 8000365a <brelse>
      tot = -1;
    800040b8:	59fd                	li	s3,-1
      break;
    800040ba:	6946                	ld	s2,80(sp)
    800040bc:	7c02                	ld	s8,32(sp)
    800040be:	6ce2                	ld	s9,24(sp)
    800040c0:	6d42                	ld	s10,16(sp)
    800040c2:	6da2                	ld	s11,8(sp)
    800040c4:	a831                	j	800040e0 <readi+0xec>
    800040c6:	6946                	ld	s2,80(sp)
    800040c8:	7c02                	ld	s8,32(sp)
    800040ca:	6ce2                	ld	s9,24(sp)
    800040cc:	6d42                	ld	s10,16(sp)
    800040ce:	6da2                	ld	s11,8(sp)
    800040d0:	a801                	j	800040e0 <readi+0xec>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800040d2:	89d6                	mv	s3,s5
    800040d4:	a031                	j	800040e0 <readi+0xec>
    800040d6:	6946                	ld	s2,80(sp)
    800040d8:	7c02                	ld	s8,32(sp)
    800040da:	6ce2                	ld	s9,24(sp)
    800040dc:	6d42                	ld	s10,16(sp)
    800040de:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800040e0:	854e                	mv	a0,s3
    800040e2:	69a6                	ld	s3,72(sp)
}
    800040e4:	70a6                	ld	ra,104(sp)
    800040e6:	7406                	ld	s0,96(sp)
    800040e8:	64e6                	ld	s1,88(sp)
    800040ea:	6a06                	ld	s4,64(sp)
    800040ec:	7ae2                	ld	s5,56(sp)
    800040ee:	7b42                	ld	s6,48(sp)
    800040f0:	7ba2                	ld	s7,40(sp)
    800040f2:	6165                	addi	sp,sp,112
    800040f4:	8082                	ret
    return 0;
    800040f6:	4501                	li	a0,0
}
    800040f8:	8082                	ret

00000000800040fa <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800040fa:	457c                	lw	a5,76(a0)
    800040fc:	10d7e963          	bltu	a5,a3,8000420e <writei+0x114>
{
    80004100:	7159                	addi	sp,sp,-112
    80004102:	f486                	sd	ra,104(sp)
    80004104:	f0a2                	sd	s0,96(sp)
    80004106:	e8ca                	sd	s2,80(sp)
    80004108:	e0d2                	sd	s4,64(sp)
    8000410a:	fc56                	sd	s5,56(sp)
    8000410c:	f85a                	sd	s6,48(sp)
    8000410e:	f45e                	sd	s7,40(sp)
    80004110:	1880                	addi	s0,sp,112
    80004112:	8aaa                	mv	s5,a0
    80004114:	8bae                	mv	s7,a1
    80004116:	8a32                	mv	s4,a2
    80004118:	8936                	mv	s2,a3
    8000411a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000411c:	00e687bb          	addw	a5,a3,a4
    80004120:	0ed7e963          	bltu	a5,a3,80004212 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80004124:	00043737          	lui	a4,0x43
    80004128:	0ef76763          	bltu	a4,a5,80004216 <writei+0x11c>
    8000412c:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000412e:	0c0b0863          	beqz	s6,800041fe <writei+0x104>
    80004132:	eca6                	sd	s1,88(sp)
    80004134:	f062                	sd	s8,32(sp)
    80004136:	ec66                	sd	s9,24(sp)
    80004138:	e86a                	sd	s10,16(sp)
    8000413a:	e46e                	sd	s11,8(sp)
    8000413c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000413e:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80004142:	5c7d                	li	s8,-1
    80004144:	a091                	j	80004188 <writei+0x8e>
    80004146:	020d1d93          	slli	s11,s10,0x20
    8000414a:	020ddd93          	srli	s11,s11,0x20
    8000414e:	05848513          	addi	a0,s1,88
    80004152:	86ee                	mv	a3,s11
    80004154:	8652                	mv	a2,s4
    80004156:	85de                	mv	a1,s7
    80004158:	953e                	add	a0,a0,a5
    8000415a:	fffff097          	auipc	ra,0xfffff
    8000415e:	872080e7          	jalr	-1934(ra) # 800029cc <either_copyin>
    80004162:	05850e63          	beq	a0,s8,800041be <writei+0xc4>
      brelse(bp);
      break;
    }
    log_write(bp);
    80004166:	8526                	mv	a0,s1
    80004168:	00000097          	auipc	ra,0x0
    8000416c:	798080e7          	jalr	1944(ra) # 80004900 <log_write>
    brelse(bp);
    80004170:	8526                	mv	a0,s1
    80004172:	fffff097          	auipc	ra,0xfffff
    80004176:	4e8080e7          	jalr	1256(ra) # 8000365a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000417a:	013d09bb          	addw	s3,s10,s3
    8000417e:	012d093b          	addw	s2,s10,s2
    80004182:	9a6e                	add	s4,s4,s11
    80004184:	0569f263          	bgeu	s3,s6,800041c8 <writei+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80004188:	00a9559b          	srliw	a1,s2,0xa
    8000418c:	8556                	mv	a0,s5
    8000418e:	fffff097          	auipc	ra,0xfffff
    80004192:	78e080e7          	jalr	1934(ra) # 8000391c <bmap>
    80004196:	85aa                	mv	a1,a0
    if(addr == 0)
    80004198:	c905                	beqz	a0,800041c8 <writei+0xce>
    bp = bread(ip->dev, addr);
    8000419a:	000aa503          	lw	a0,0(s5)
    8000419e:	fffff097          	auipc	ra,0xfffff
    800041a2:	38c080e7          	jalr	908(ra) # 8000352a <bread>
    800041a6:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800041a8:	3ff97793          	andi	a5,s2,1023
    800041ac:	40fc873b          	subw	a4,s9,a5
    800041b0:	413b06bb          	subw	a3,s6,s3
    800041b4:	8d3a                	mv	s10,a4
    800041b6:	f8e6f8e3          	bgeu	a3,a4,80004146 <writei+0x4c>
    800041ba:	8d36                	mv	s10,a3
    800041bc:	b769                	j	80004146 <writei+0x4c>
      brelse(bp);
    800041be:	8526                	mv	a0,s1
    800041c0:	fffff097          	auipc	ra,0xfffff
    800041c4:	49a080e7          	jalr	1178(ra) # 8000365a <brelse>
  }

  if(off > ip->size)
    800041c8:	04caa783          	lw	a5,76(s5)
    800041cc:	0327fb63          	bgeu	a5,s2,80004202 <writei+0x108>
    ip->size = off;
    800041d0:	052aa623          	sw	s2,76(s5)
    800041d4:	64e6                	ld	s1,88(sp)
    800041d6:	7c02                	ld	s8,32(sp)
    800041d8:	6ce2                	ld	s9,24(sp)
    800041da:	6d42                	ld	s10,16(sp)
    800041dc:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800041de:	8556                	mv	a0,s5
    800041e0:	00000097          	auipc	ra,0x0
    800041e4:	a8c080e7          	jalr	-1396(ra) # 80003c6c <iupdate>

  return tot;
    800041e8:	854e                	mv	a0,s3
    800041ea:	69a6                	ld	s3,72(sp)
}
    800041ec:	70a6                	ld	ra,104(sp)
    800041ee:	7406                	ld	s0,96(sp)
    800041f0:	6946                	ld	s2,80(sp)
    800041f2:	6a06                	ld	s4,64(sp)
    800041f4:	7ae2                	ld	s5,56(sp)
    800041f6:	7b42                	ld	s6,48(sp)
    800041f8:	7ba2                	ld	s7,40(sp)
    800041fa:	6165                	addi	sp,sp,112
    800041fc:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800041fe:	89da                	mv	s3,s6
    80004200:	bff9                	j	800041de <writei+0xe4>
    80004202:	64e6                	ld	s1,88(sp)
    80004204:	7c02                	ld	s8,32(sp)
    80004206:	6ce2                	ld	s9,24(sp)
    80004208:	6d42                	ld	s10,16(sp)
    8000420a:	6da2                	ld	s11,8(sp)
    8000420c:	bfc9                	j	800041de <writei+0xe4>
    return -1;
    8000420e:	557d                	li	a0,-1
}
    80004210:	8082                	ret
    return -1;
    80004212:	557d                	li	a0,-1
    80004214:	bfe1                	j	800041ec <writei+0xf2>
    return -1;
    80004216:	557d                	li	a0,-1
    80004218:	bfd1                	j	800041ec <writei+0xf2>

000000008000421a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000421a:	1141                	addi	sp,sp,-16
    8000421c:	e406                	sd	ra,8(sp)
    8000421e:	e022                	sd	s0,0(sp)
    80004220:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80004222:	4639                	li	a2,14
    80004224:	ffffd097          	auipc	ra,0xffffd
    80004228:	bee080e7          	jalr	-1042(ra) # 80000e12 <strncmp>
}
    8000422c:	60a2                	ld	ra,8(sp)
    8000422e:	6402                	ld	s0,0(sp)
    80004230:	0141                	addi	sp,sp,16
    80004232:	8082                	ret

0000000080004234 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80004234:	711d                	addi	sp,sp,-96
    80004236:	ec86                	sd	ra,88(sp)
    80004238:	e8a2                	sd	s0,80(sp)
    8000423a:	e4a6                	sd	s1,72(sp)
    8000423c:	e0ca                	sd	s2,64(sp)
    8000423e:	fc4e                	sd	s3,56(sp)
    80004240:	f852                	sd	s4,48(sp)
    80004242:	f456                	sd	s5,40(sp)
    80004244:	f05a                	sd	s6,32(sp)
    80004246:	ec5e                	sd	s7,24(sp)
    80004248:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000424a:	04451703          	lh	a4,68(a0)
    8000424e:	4785                	li	a5,1
    80004250:	00f71f63          	bne	a4,a5,8000426e <dirlookup+0x3a>
    80004254:	892a                	mv	s2,a0
    80004256:	8aae                	mv	s5,a1
    80004258:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000425a:	457c                	lw	a5,76(a0)
    8000425c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000425e:	fa040a13          	addi	s4,s0,-96
    80004262:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80004264:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80004268:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000426a:	e79d                	bnez	a5,80004298 <dirlookup+0x64>
    8000426c:	a88d                	j	800042de <dirlookup+0xaa>
    panic("dirlookup not DIR");
    8000426e:	00004517          	auipc	a0,0x4
    80004272:	35a50513          	addi	a0,a0,858 # 800085c8 <etext+0x5c8>
    80004276:	ffffc097          	auipc	ra,0xffffc
    8000427a:	2ea080e7          	jalr	746(ra) # 80000560 <panic>
      panic("dirlookup read");
    8000427e:	00004517          	auipc	a0,0x4
    80004282:	36250513          	addi	a0,a0,866 # 800085e0 <etext+0x5e0>
    80004286:	ffffc097          	auipc	ra,0xffffc
    8000428a:	2da080e7          	jalr	730(ra) # 80000560 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000428e:	24c1                	addiw	s1,s1,16
    80004290:	04c92783          	lw	a5,76(s2)
    80004294:	04f4f463          	bgeu	s1,a5,800042dc <dirlookup+0xa8>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004298:	874e                	mv	a4,s3
    8000429a:	86a6                	mv	a3,s1
    8000429c:	8652                	mv	a2,s4
    8000429e:	4581                	li	a1,0
    800042a0:	854a                	mv	a0,s2
    800042a2:	00000097          	auipc	ra,0x0
    800042a6:	d52080e7          	jalr	-686(ra) # 80003ff4 <readi>
    800042aa:	fd351ae3          	bne	a0,s3,8000427e <dirlookup+0x4a>
    if(de.inum == 0)
    800042ae:	fa045783          	lhu	a5,-96(s0)
    800042b2:	dff1                	beqz	a5,8000428e <dirlookup+0x5a>
    if(namecmp(name, de.name) == 0){
    800042b4:	85da                	mv	a1,s6
    800042b6:	8556                	mv	a0,s5
    800042b8:	00000097          	auipc	ra,0x0
    800042bc:	f62080e7          	jalr	-158(ra) # 8000421a <namecmp>
    800042c0:	f579                	bnez	a0,8000428e <dirlookup+0x5a>
      if(poff)
    800042c2:	000b8463          	beqz	s7,800042ca <dirlookup+0x96>
        *poff = off;
    800042c6:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    800042ca:	fa045583          	lhu	a1,-96(s0)
    800042ce:	00092503          	lw	a0,0(s2)
    800042d2:	fffff097          	auipc	ra,0xfffff
    800042d6:	726080e7          	jalr	1830(ra) # 800039f8 <iget>
    800042da:	a011                	j	800042de <dirlookup+0xaa>
  return 0;
    800042dc:	4501                	li	a0,0
}
    800042de:	60e6                	ld	ra,88(sp)
    800042e0:	6446                	ld	s0,80(sp)
    800042e2:	64a6                	ld	s1,72(sp)
    800042e4:	6906                	ld	s2,64(sp)
    800042e6:	79e2                	ld	s3,56(sp)
    800042e8:	7a42                	ld	s4,48(sp)
    800042ea:	7aa2                	ld	s5,40(sp)
    800042ec:	7b02                	ld	s6,32(sp)
    800042ee:	6be2                	ld	s7,24(sp)
    800042f0:	6125                	addi	sp,sp,96
    800042f2:	8082                	ret

00000000800042f4 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800042f4:	711d                	addi	sp,sp,-96
    800042f6:	ec86                	sd	ra,88(sp)
    800042f8:	e8a2                	sd	s0,80(sp)
    800042fa:	e4a6                	sd	s1,72(sp)
    800042fc:	e0ca                	sd	s2,64(sp)
    800042fe:	fc4e                	sd	s3,56(sp)
    80004300:	f852                	sd	s4,48(sp)
    80004302:	f456                	sd	s5,40(sp)
    80004304:	f05a                	sd	s6,32(sp)
    80004306:	ec5e                	sd	s7,24(sp)
    80004308:	e862                	sd	s8,16(sp)
    8000430a:	e466                	sd	s9,8(sp)
    8000430c:	e06a                	sd	s10,0(sp)
    8000430e:	1080                	addi	s0,sp,96
    80004310:	84aa                	mv	s1,a0
    80004312:	8b2e                	mv	s6,a1
    80004314:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80004316:	00054703          	lbu	a4,0(a0)
    8000431a:	02f00793          	li	a5,47
    8000431e:	02f70363          	beq	a4,a5,80004344 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80004322:	ffffe097          	auipc	ra,0xffffe
    80004326:	a60080e7          	jalr	-1440(ra) # 80001d82 <myproc>
    8000432a:	15053503          	ld	a0,336(a0)
    8000432e:	00000097          	auipc	ra,0x0
    80004332:	9cc080e7          	jalr	-1588(ra) # 80003cfa <idup>
    80004336:	8a2a                	mv	s4,a0
  while(*path == '/')
    80004338:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000433c:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    8000433e:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004340:	4b85                	li	s7,1
    80004342:	a87d                	j	80004400 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80004344:	4585                	li	a1,1
    80004346:	852e                	mv	a0,a1
    80004348:	fffff097          	auipc	ra,0xfffff
    8000434c:	6b0080e7          	jalr	1712(ra) # 800039f8 <iget>
    80004350:	8a2a                	mv	s4,a0
    80004352:	b7dd                	j	80004338 <namex+0x44>
      iunlockput(ip);
    80004354:	8552                	mv	a0,s4
    80004356:	00000097          	auipc	ra,0x0
    8000435a:	c48080e7          	jalr	-952(ra) # 80003f9e <iunlockput>
      return 0;
    8000435e:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80004360:	8552                	mv	a0,s4
    80004362:	60e6                	ld	ra,88(sp)
    80004364:	6446                	ld	s0,80(sp)
    80004366:	64a6                	ld	s1,72(sp)
    80004368:	6906                	ld	s2,64(sp)
    8000436a:	79e2                	ld	s3,56(sp)
    8000436c:	7a42                	ld	s4,48(sp)
    8000436e:	7aa2                	ld	s5,40(sp)
    80004370:	7b02                	ld	s6,32(sp)
    80004372:	6be2                	ld	s7,24(sp)
    80004374:	6c42                	ld	s8,16(sp)
    80004376:	6ca2                	ld	s9,8(sp)
    80004378:	6d02                	ld	s10,0(sp)
    8000437a:	6125                	addi	sp,sp,96
    8000437c:	8082                	ret
      iunlock(ip);
    8000437e:	8552                	mv	a0,s4
    80004380:	00000097          	auipc	ra,0x0
    80004384:	a7e080e7          	jalr	-1410(ra) # 80003dfe <iunlock>
      return ip;
    80004388:	bfe1                	j	80004360 <namex+0x6c>
      iunlockput(ip);
    8000438a:	8552                	mv	a0,s4
    8000438c:	00000097          	auipc	ra,0x0
    80004390:	c12080e7          	jalr	-1006(ra) # 80003f9e <iunlockput>
      return 0;
    80004394:	8a4e                	mv	s4,s3
    80004396:	b7e9                	j	80004360 <namex+0x6c>
  len = path - s;
    80004398:	40998633          	sub	a2,s3,s1
    8000439c:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    800043a0:	09ac5863          	bge	s8,s10,80004430 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    800043a4:	8666                	mv	a2,s9
    800043a6:	85a6                	mv	a1,s1
    800043a8:	8556                	mv	a0,s5
    800043aa:	ffffd097          	auipc	ra,0xffffd
    800043ae:	9f0080e7          	jalr	-1552(ra) # 80000d9a <memmove>
    800043b2:	84ce                	mv	s1,s3
  while(*path == '/')
    800043b4:	0004c783          	lbu	a5,0(s1)
    800043b8:	01279763          	bne	a5,s2,800043c6 <namex+0xd2>
    path++;
    800043bc:	0485                	addi	s1,s1,1
  while(*path == '/')
    800043be:	0004c783          	lbu	a5,0(s1)
    800043c2:	ff278de3          	beq	a5,s2,800043bc <namex+0xc8>
    ilock(ip);
    800043c6:	8552                	mv	a0,s4
    800043c8:	00000097          	auipc	ra,0x0
    800043cc:	970080e7          	jalr	-1680(ra) # 80003d38 <ilock>
    if(ip->type != T_DIR){
    800043d0:	044a1783          	lh	a5,68(s4)
    800043d4:	f97790e3          	bne	a5,s7,80004354 <namex+0x60>
    if(nameiparent && *path == '\0'){
    800043d8:	000b0563          	beqz	s6,800043e2 <namex+0xee>
    800043dc:	0004c783          	lbu	a5,0(s1)
    800043e0:	dfd9                	beqz	a5,8000437e <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    800043e2:	4601                	li	a2,0
    800043e4:	85d6                	mv	a1,s5
    800043e6:	8552                	mv	a0,s4
    800043e8:	00000097          	auipc	ra,0x0
    800043ec:	e4c080e7          	jalr	-436(ra) # 80004234 <dirlookup>
    800043f0:	89aa                	mv	s3,a0
    800043f2:	dd41                	beqz	a0,8000438a <namex+0x96>
    iunlockput(ip);
    800043f4:	8552                	mv	a0,s4
    800043f6:	00000097          	auipc	ra,0x0
    800043fa:	ba8080e7          	jalr	-1112(ra) # 80003f9e <iunlockput>
    ip = next;
    800043fe:	8a4e                	mv	s4,s3
  while(*path == '/')
    80004400:	0004c783          	lbu	a5,0(s1)
    80004404:	01279763          	bne	a5,s2,80004412 <namex+0x11e>
    path++;
    80004408:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000440a:	0004c783          	lbu	a5,0(s1)
    8000440e:	ff278de3          	beq	a5,s2,80004408 <namex+0x114>
  if(*path == 0)
    80004412:	cb9d                	beqz	a5,80004448 <namex+0x154>
  while(*path != '/' && *path != 0)
    80004414:	0004c783          	lbu	a5,0(s1)
    80004418:	89a6                	mv	s3,s1
  len = path - s;
    8000441a:	4d01                	li	s10,0
    8000441c:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    8000441e:	01278963          	beq	a5,s2,80004430 <namex+0x13c>
    80004422:	dbbd                	beqz	a5,80004398 <namex+0xa4>
    path++;
    80004424:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80004426:	0009c783          	lbu	a5,0(s3)
    8000442a:	ff279ce3          	bne	a5,s2,80004422 <namex+0x12e>
    8000442e:	b7ad                	j	80004398 <namex+0xa4>
    memmove(name, s, len);
    80004430:	2601                	sext.w	a2,a2
    80004432:	85a6                	mv	a1,s1
    80004434:	8556                	mv	a0,s5
    80004436:	ffffd097          	auipc	ra,0xffffd
    8000443a:	964080e7          	jalr	-1692(ra) # 80000d9a <memmove>
    name[len] = 0;
    8000443e:	9d56                	add	s10,s10,s5
    80004440:	000d0023          	sb	zero,0(s10)
    80004444:	84ce                	mv	s1,s3
    80004446:	b7bd                	j	800043b4 <namex+0xc0>
  if(nameiparent){
    80004448:	f00b0ce3          	beqz	s6,80004360 <namex+0x6c>
    iput(ip);
    8000444c:	8552                	mv	a0,s4
    8000444e:	00000097          	auipc	ra,0x0
    80004452:	aa8080e7          	jalr	-1368(ra) # 80003ef6 <iput>
    return 0;
    80004456:	4a01                	li	s4,0
    80004458:	b721                	j	80004360 <namex+0x6c>

000000008000445a <dirlink>:
{
    8000445a:	715d                	addi	sp,sp,-80
    8000445c:	e486                	sd	ra,72(sp)
    8000445e:	e0a2                	sd	s0,64(sp)
    80004460:	f84a                	sd	s2,48(sp)
    80004462:	ec56                	sd	s5,24(sp)
    80004464:	e85a                	sd	s6,16(sp)
    80004466:	0880                	addi	s0,sp,80
    80004468:	892a                	mv	s2,a0
    8000446a:	8aae                	mv	s5,a1
    8000446c:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000446e:	4601                	li	a2,0
    80004470:	00000097          	auipc	ra,0x0
    80004474:	dc4080e7          	jalr	-572(ra) # 80004234 <dirlookup>
    80004478:	e129                	bnez	a0,800044ba <dirlink+0x60>
    8000447a:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000447c:	04c92483          	lw	s1,76(s2)
    80004480:	cca9                	beqz	s1,800044da <dirlink+0x80>
    80004482:	f44e                	sd	s3,40(sp)
    80004484:	f052                	sd	s4,32(sp)
    80004486:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004488:	fb040a13          	addi	s4,s0,-80
    8000448c:	49c1                	li	s3,16
    8000448e:	874e                	mv	a4,s3
    80004490:	86a6                	mv	a3,s1
    80004492:	8652                	mv	a2,s4
    80004494:	4581                	li	a1,0
    80004496:	854a                	mv	a0,s2
    80004498:	00000097          	auipc	ra,0x0
    8000449c:	b5c080e7          	jalr	-1188(ra) # 80003ff4 <readi>
    800044a0:	03351363          	bne	a0,s3,800044c6 <dirlink+0x6c>
    if(de.inum == 0)
    800044a4:	fb045783          	lhu	a5,-80(s0)
    800044a8:	c79d                	beqz	a5,800044d6 <dirlink+0x7c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800044aa:	24c1                	addiw	s1,s1,16
    800044ac:	04c92783          	lw	a5,76(s2)
    800044b0:	fcf4efe3          	bltu	s1,a5,8000448e <dirlink+0x34>
    800044b4:	79a2                	ld	s3,40(sp)
    800044b6:	7a02                	ld	s4,32(sp)
    800044b8:	a00d                	j	800044da <dirlink+0x80>
    iput(ip);
    800044ba:	00000097          	auipc	ra,0x0
    800044be:	a3c080e7          	jalr	-1476(ra) # 80003ef6 <iput>
    return -1;
    800044c2:	557d                	li	a0,-1
    800044c4:	a0a9                	j	8000450e <dirlink+0xb4>
      panic("dirlink read");
    800044c6:	00004517          	auipc	a0,0x4
    800044ca:	12a50513          	addi	a0,a0,298 # 800085f0 <etext+0x5f0>
    800044ce:	ffffc097          	auipc	ra,0xffffc
    800044d2:	092080e7          	jalr	146(ra) # 80000560 <panic>
    800044d6:	79a2                	ld	s3,40(sp)
    800044d8:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    800044da:	4639                	li	a2,14
    800044dc:	85d6                	mv	a1,s5
    800044de:	fb240513          	addi	a0,s0,-78
    800044e2:	ffffd097          	auipc	ra,0xffffd
    800044e6:	96a080e7          	jalr	-1686(ra) # 80000e4c <strncpy>
  de.inum = inum;
    800044ea:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800044ee:	4741                	li	a4,16
    800044f0:	86a6                	mv	a3,s1
    800044f2:	fb040613          	addi	a2,s0,-80
    800044f6:	4581                	li	a1,0
    800044f8:	854a                	mv	a0,s2
    800044fa:	00000097          	auipc	ra,0x0
    800044fe:	c00080e7          	jalr	-1024(ra) # 800040fa <writei>
    80004502:	1541                	addi	a0,a0,-16
    80004504:	00a03533          	snez	a0,a0
    80004508:	40a0053b          	negw	a0,a0
    8000450c:	74e2                	ld	s1,56(sp)
}
    8000450e:	60a6                	ld	ra,72(sp)
    80004510:	6406                	ld	s0,64(sp)
    80004512:	7942                	ld	s2,48(sp)
    80004514:	6ae2                	ld	s5,24(sp)
    80004516:	6b42                	ld	s6,16(sp)
    80004518:	6161                	addi	sp,sp,80
    8000451a:	8082                	ret

000000008000451c <namei>:

struct inode*
namei(char *path)
{
    8000451c:	1101                	addi	sp,sp,-32
    8000451e:	ec06                	sd	ra,24(sp)
    80004520:	e822                	sd	s0,16(sp)
    80004522:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004524:	fe040613          	addi	a2,s0,-32
    80004528:	4581                	li	a1,0
    8000452a:	00000097          	auipc	ra,0x0
    8000452e:	dca080e7          	jalr	-566(ra) # 800042f4 <namex>
}
    80004532:	60e2                	ld	ra,24(sp)
    80004534:	6442                	ld	s0,16(sp)
    80004536:	6105                	addi	sp,sp,32
    80004538:	8082                	ret

000000008000453a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000453a:	1141                	addi	sp,sp,-16
    8000453c:	e406                	sd	ra,8(sp)
    8000453e:	e022                	sd	s0,0(sp)
    80004540:	0800                	addi	s0,sp,16
    80004542:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004544:	4585                	li	a1,1
    80004546:	00000097          	auipc	ra,0x0
    8000454a:	dae080e7          	jalr	-594(ra) # 800042f4 <namex>
}
    8000454e:	60a2                	ld	ra,8(sp)
    80004550:	6402                	ld	s0,0(sp)
    80004552:	0141                	addi	sp,sp,16
    80004554:	8082                	ret

0000000080004556 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80004556:	1101                	addi	sp,sp,-32
    80004558:	ec06                	sd	ra,24(sp)
    8000455a:	e822                	sd	s0,16(sp)
    8000455c:	e426                	sd	s1,8(sp)
    8000455e:	e04a                	sd	s2,0(sp)
    80004560:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004562:	0001d917          	auipc	s2,0x1d
    80004566:	37e90913          	addi	s2,s2,894 # 800218e0 <log>
    8000456a:	01892583          	lw	a1,24(s2)
    8000456e:	02892503          	lw	a0,40(s2)
    80004572:	fffff097          	auipc	ra,0xfffff
    80004576:	fb8080e7          	jalr	-72(ra) # 8000352a <bread>
    8000457a:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000457c:	02c92603          	lw	a2,44(s2)
    80004580:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004582:	00c05f63          	blez	a2,800045a0 <write_head+0x4a>
    80004586:	0001d717          	auipc	a4,0x1d
    8000458a:	38a70713          	addi	a4,a4,906 # 80021910 <log+0x30>
    8000458e:	87aa                	mv	a5,a0
    80004590:	060a                	slli	a2,a2,0x2
    80004592:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80004594:	4314                	lw	a3,0(a4)
    80004596:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80004598:	0711                	addi	a4,a4,4
    8000459a:	0791                	addi	a5,a5,4
    8000459c:	fec79ce3          	bne	a5,a2,80004594 <write_head+0x3e>
  }
  bwrite(buf);
    800045a0:	8526                	mv	a0,s1
    800045a2:	fffff097          	auipc	ra,0xfffff
    800045a6:	07a080e7          	jalr	122(ra) # 8000361c <bwrite>
  brelse(buf);
    800045aa:	8526                	mv	a0,s1
    800045ac:	fffff097          	auipc	ra,0xfffff
    800045b0:	0ae080e7          	jalr	174(ra) # 8000365a <brelse>
}
    800045b4:	60e2                	ld	ra,24(sp)
    800045b6:	6442                	ld	s0,16(sp)
    800045b8:	64a2                	ld	s1,8(sp)
    800045ba:	6902                	ld	s2,0(sp)
    800045bc:	6105                	addi	sp,sp,32
    800045be:	8082                	ret

00000000800045c0 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800045c0:	0001d797          	auipc	a5,0x1d
    800045c4:	34c7a783          	lw	a5,844(a5) # 8002190c <log+0x2c>
    800045c8:	0cf05063          	blez	a5,80004688 <install_trans+0xc8>
{
    800045cc:	715d                	addi	sp,sp,-80
    800045ce:	e486                	sd	ra,72(sp)
    800045d0:	e0a2                	sd	s0,64(sp)
    800045d2:	fc26                	sd	s1,56(sp)
    800045d4:	f84a                	sd	s2,48(sp)
    800045d6:	f44e                	sd	s3,40(sp)
    800045d8:	f052                	sd	s4,32(sp)
    800045da:	ec56                	sd	s5,24(sp)
    800045dc:	e85a                	sd	s6,16(sp)
    800045de:	e45e                	sd	s7,8(sp)
    800045e0:	0880                	addi	s0,sp,80
    800045e2:	8b2a                	mv	s6,a0
    800045e4:	0001da97          	auipc	s5,0x1d
    800045e8:	32ca8a93          	addi	s5,s5,812 # 80021910 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800045ec:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800045ee:	0001d997          	auipc	s3,0x1d
    800045f2:	2f298993          	addi	s3,s3,754 # 800218e0 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800045f6:	40000b93          	li	s7,1024
    800045fa:	a00d                	j	8000461c <install_trans+0x5c>
    brelse(lbuf);
    800045fc:	854a                	mv	a0,s2
    800045fe:	fffff097          	auipc	ra,0xfffff
    80004602:	05c080e7          	jalr	92(ra) # 8000365a <brelse>
    brelse(dbuf);
    80004606:	8526                	mv	a0,s1
    80004608:	fffff097          	auipc	ra,0xfffff
    8000460c:	052080e7          	jalr	82(ra) # 8000365a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004610:	2a05                	addiw	s4,s4,1
    80004612:	0a91                	addi	s5,s5,4
    80004614:	02c9a783          	lw	a5,44(s3)
    80004618:	04fa5d63          	bge	s4,a5,80004672 <install_trans+0xb2>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000461c:	0189a583          	lw	a1,24(s3)
    80004620:	014585bb          	addw	a1,a1,s4
    80004624:	2585                	addiw	a1,a1,1
    80004626:	0289a503          	lw	a0,40(s3)
    8000462a:	fffff097          	auipc	ra,0xfffff
    8000462e:	f00080e7          	jalr	-256(ra) # 8000352a <bread>
    80004632:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004634:	000aa583          	lw	a1,0(s5)
    80004638:	0289a503          	lw	a0,40(s3)
    8000463c:	fffff097          	auipc	ra,0xfffff
    80004640:	eee080e7          	jalr	-274(ra) # 8000352a <bread>
    80004644:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004646:	865e                	mv	a2,s7
    80004648:	05890593          	addi	a1,s2,88
    8000464c:	05850513          	addi	a0,a0,88
    80004650:	ffffc097          	auipc	ra,0xffffc
    80004654:	74a080e7          	jalr	1866(ra) # 80000d9a <memmove>
    bwrite(dbuf);  // write dst to disk
    80004658:	8526                	mv	a0,s1
    8000465a:	fffff097          	auipc	ra,0xfffff
    8000465e:	fc2080e7          	jalr	-62(ra) # 8000361c <bwrite>
    if(recovering == 0)
    80004662:	f80b1de3          	bnez	s6,800045fc <install_trans+0x3c>
      bunpin(dbuf);
    80004666:	8526                	mv	a0,s1
    80004668:	fffff097          	auipc	ra,0xfffff
    8000466c:	0c6080e7          	jalr	198(ra) # 8000372e <bunpin>
    80004670:	b771                	j	800045fc <install_trans+0x3c>
}
    80004672:	60a6                	ld	ra,72(sp)
    80004674:	6406                	ld	s0,64(sp)
    80004676:	74e2                	ld	s1,56(sp)
    80004678:	7942                	ld	s2,48(sp)
    8000467a:	79a2                	ld	s3,40(sp)
    8000467c:	7a02                	ld	s4,32(sp)
    8000467e:	6ae2                	ld	s5,24(sp)
    80004680:	6b42                	ld	s6,16(sp)
    80004682:	6ba2                	ld	s7,8(sp)
    80004684:	6161                	addi	sp,sp,80
    80004686:	8082                	ret
    80004688:	8082                	ret

000000008000468a <initlog>:
{
    8000468a:	7179                	addi	sp,sp,-48
    8000468c:	f406                	sd	ra,40(sp)
    8000468e:	f022                	sd	s0,32(sp)
    80004690:	ec26                	sd	s1,24(sp)
    80004692:	e84a                	sd	s2,16(sp)
    80004694:	e44e                	sd	s3,8(sp)
    80004696:	1800                	addi	s0,sp,48
    80004698:	892a                	mv	s2,a0
    8000469a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000469c:	0001d497          	auipc	s1,0x1d
    800046a0:	24448493          	addi	s1,s1,580 # 800218e0 <log>
    800046a4:	00004597          	auipc	a1,0x4
    800046a8:	f5c58593          	addi	a1,a1,-164 # 80008600 <etext+0x600>
    800046ac:	8526                	mv	a0,s1
    800046ae:	ffffc097          	auipc	ra,0xffffc
    800046b2:	4fc080e7          	jalr	1276(ra) # 80000baa <initlock>
  log.start = sb->logstart;
    800046b6:	0149a583          	lw	a1,20(s3)
    800046ba:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800046bc:	0109a783          	lw	a5,16(s3)
    800046c0:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800046c2:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800046c6:	854a                	mv	a0,s2
    800046c8:	fffff097          	auipc	ra,0xfffff
    800046cc:	e62080e7          	jalr	-414(ra) # 8000352a <bread>
  log.lh.n = lh->n;
    800046d0:	4d30                	lw	a2,88(a0)
    800046d2:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800046d4:	00c05f63          	blez	a2,800046f2 <initlog+0x68>
    800046d8:	87aa                	mv	a5,a0
    800046da:	0001d717          	auipc	a4,0x1d
    800046de:	23670713          	addi	a4,a4,566 # 80021910 <log+0x30>
    800046e2:	060a                	slli	a2,a2,0x2
    800046e4:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800046e6:	4ff4                	lw	a3,92(a5)
    800046e8:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800046ea:	0791                	addi	a5,a5,4
    800046ec:	0711                	addi	a4,a4,4
    800046ee:	fec79ce3          	bne	a5,a2,800046e6 <initlog+0x5c>
  brelse(buf);
    800046f2:	fffff097          	auipc	ra,0xfffff
    800046f6:	f68080e7          	jalr	-152(ra) # 8000365a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800046fa:	4505                	li	a0,1
    800046fc:	00000097          	auipc	ra,0x0
    80004700:	ec4080e7          	jalr	-316(ra) # 800045c0 <install_trans>
  log.lh.n = 0;
    80004704:	0001d797          	auipc	a5,0x1d
    80004708:	2007a423          	sw	zero,520(a5) # 8002190c <log+0x2c>
  write_head(); // clear the log
    8000470c:	00000097          	auipc	ra,0x0
    80004710:	e4a080e7          	jalr	-438(ra) # 80004556 <write_head>
}
    80004714:	70a2                	ld	ra,40(sp)
    80004716:	7402                	ld	s0,32(sp)
    80004718:	64e2                	ld	s1,24(sp)
    8000471a:	6942                	ld	s2,16(sp)
    8000471c:	69a2                	ld	s3,8(sp)
    8000471e:	6145                	addi	sp,sp,48
    80004720:	8082                	ret

0000000080004722 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004722:	1101                	addi	sp,sp,-32
    80004724:	ec06                	sd	ra,24(sp)
    80004726:	e822                	sd	s0,16(sp)
    80004728:	e426                	sd	s1,8(sp)
    8000472a:	e04a                	sd	s2,0(sp)
    8000472c:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000472e:	0001d517          	auipc	a0,0x1d
    80004732:	1b250513          	addi	a0,a0,434 # 800218e0 <log>
    80004736:	ffffc097          	auipc	ra,0xffffc
    8000473a:	508080e7          	jalr	1288(ra) # 80000c3e <acquire>
  while(1){
    if(log.committing){
    8000473e:	0001d497          	auipc	s1,0x1d
    80004742:	1a248493          	addi	s1,s1,418 # 800218e0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004746:	4979                	li	s2,30
    80004748:	a039                	j	80004756 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000474a:	85a6                	mv	a1,s1
    8000474c:	8526                	mv	a0,s1
    8000474e:	ffffe097          	auipc	ra,0xffffe
    80004752:	e26080e7          	jalr	-474(ra) # 80002574 <sleep>
    if(log.committing){
    80004756:	50dc                	lw	a5,36(s1)
    80004758:	fbed                	bnez	a5,8000474a <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000475a:	5098                	lw	a4,32(s1)
    8000475c:	2705                	addiw	a4,a4,1
    8000475e:	0027179b          	slliw	a5,a4,0x2
    80004762:	9fb9                	addw	a5,a5,a4
    80004764:	0017979b          	slliw	a5,a5,0x1
    80004768:	54d4                	lw	a3,44(s1)
    8000476a:	9fb5                	addw	a5,a5,a3
    8000476c:	00f95963          	bge	s2,a5,8000477e <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004770:	85a6                	mv	a1,s1
    80004772:	8526                	mv	a0,s1
    80004774:	ffffe097          	auipc	ra,0xffffe
    80004778:	e00080e7          	jalr	-512(ra) # 80002574 <sleep>
    8000477c:	bfe9                	j	80004756 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000477e:	0001d517          	auipc	a0,0x1d
    80004782:	16250513          	addi	a0,a0,354 # 800218e0 <log>
    80004786:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80004788:	ffffc097          	auipc	ra,0xffffc
    8000478c:	566080e7          	jalr	1382(ra) # 80000cee <release>
      break;
    }
  }
}
    80004790:	60e2                	ld	ra,24(sp)
    80004792:	6442                	ld	s0,16(sp)
    80004794:	64a2                	ld	s1,8(sp)
    80004796:	6902                	ld	s2,0(sp)
    80004798:	6105                	addi	sp,sp,32
    8000479a:	8082                	ret

000000008000479c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000479c:	7139                	addi	sp,sp,-64
    8000479e:	fc06                	sd	ra,56(sp)
    800047a0:	f822                	sd	s0,48(sp)
    800047a2:	f426                	sd	s1,40(sp)
    800047a4:	f04a                	sd	s2,32(sp)
    800047a6:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800047a8:	0001d497          	auipc	s1,0x1d
    800047ac:	13848493          	addi	s1,s1,312 # 800218e0 <log>
    800047b0:	8526                	mv	a0,s1
    800047b2:	ffffc097          	auipc	ra,0xffffc
    800047b6:	48c080e7          	jalr	1164(ra) # 80000c3e <acquire>
  log.outstanding -= 1;
    800047ba:	509c                	lw	a5,32(s1)
    800047bc:	37fd                	addiw	a5,a5,-1
    800047be:	893e                	mv	s2,a5
    800047c0:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800047c2:	50dc                	lw	a5,36(s1)
    800047c4:	e7b9                	bnez	a5,80004812 <end_op+0x76>
    panic("log.committing");
  if(log.outstanding == 0){
    800047c6:	06091263          	bnez	s2,8000482a <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800047ca:	0001d497          	auipc	s1,0x1d
    800047ce:	11648493          	addi	s1,s1,278 # 800218e0 <log>
    800047d2:	4785                	li	a5,1
    800047d4:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800047d6:	8526                	mv	a0,s1
    800047d8:	ffffc097          	auipc	ra,0xffffc
    800047dc:	516080e7          	jalr	1302(ra) # 80000cee <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800047e0:	54dc                	lw	a5,44(s1)
    800047e2:	06f04863          	bgtz	a5,80004852 <end_op+0xb6>
    acquire(&log.lock);
    800047e6:	0001d497          	auipc	s1,0x1d
    800047ea:	0fa48493          	addi	s1,s1,250 # 800218e0 <log>
    800047ee:	8526                	mv	a0,s1
    800047f0:	ffffc097          	auipc	ra,0xffffc
    800047f4:	44e080e7          	jalr	1102(ra) # 80000c3e <acquire>
    log.committing = 0;
    800047f8:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800047fc:	8526                	mv	a0,s1
    800047fe:	ffffe097          	auipc	ra,0xffffe
    80004802:	dda080e7          	jalr	-550(ra) # 800025d8 <wakeup>
    release(&log.lock);
    80004806:	8526                	mv	a0,s1
    80004808:	ffffc097          	auipc	ra,0xffffc
    8000480c:	4e6080e7          	jalr	1254(ra) # 80000cee <release>
}
    80004810:	a81d                	j	80004846 <end_op+0xaa>
    80004812:	ec4e                	sd	s3,24(sp)
    80004814:	e852                	sd	s4,16(sp)
    80004816:	e456                	sd	s5,8(sp)
    80004818:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    8000481a:	00004517          	auipc	a0,0x4
    8000481e:	dee50513          	addi	a0,a0,-530 # 80008608 <etext+0x608>
    80004822:	ffffc097          	auipc	ra,0xffffc
    80004826:	d3e080e7          	jalr	-706(ra) # 80000560 <panic>
    wakeup(&log);
    8000482a:	0001d497          	auipc	s1,0x1d
    8000482e:	0b648493          	addi	s1,s1,182 # 800218e0 <log>
    80004832:	8526                	mv	a0,s1
    80004834:	ffffe097          	auipc	ra,0xffffe
    80004838:	da4080e7          	jalr	-604(ra) # 800025d8 <wakeup>
  release(&log.lock);
    8000483c:	8526                	mv	a0,s1
    8000483e:	ffffc097          	auipc	ra,0xffffc
    80004842:	4b0080e7          	jalr	1200(ra) # 80000cee <release>
}
    80004846:	70e2                	ld	ra,56(sp)
    80004848:	7442                	ld	s0,48(sp)
    8000484a:	74a2                	ld	s1,40(sp)
    8000484c:	7902                	ld	s2,32(sp)
    8000484e:	6121                	addi	sp,sp,64
    80004850:	8082                	ret
    80004852:	ec4e                	sd	s3,24(sp)
    80004854:	e852                	sd	s4,16(sp)
    80004856:	e456                	sd	s5,8(sp)
    80004858:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000485a:	0001da97          	auipc	s5,0x1d
    8000485e:	0b6a8a93          	addi	s5,s5,182 # 80021910 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004862:	0001da17          	auipc	s4,0x1d
    80004866:	07ea0a13          	addi	s4,s4,126 # 800218e0 <log>
    memmove(to->data, from->data, BSIZE);
    8000486a:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000486e:	018a2583          	lw	a1,24(s4)
    80004872:	012585bb          	addw	a1,a1,s2
    80004876:	2585                	addiw	a1,a1,1
    80004878:	028a2503          	lw	a0,40(s4)
    8000487c:	fffff097          	auipc	ra,0xfffff
    80004880:	cae080e7          	jalr	-850(ra) # 8000352a <bread>
    80004884:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004886:	000aa583          	lw	a1,0(s5)
    8000488a:	028a2503          	lw	a0,40(s4)
    8000488e:	fffff097          	auipc	ra,0xfffff
    80004892:	c9c080e7          	jalr	-868(ra) # 8000352a <bread>
    80004896:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004898:	865a                	mv	a2,s6
    8000489a:	05850593          	addi	a1,a0,88
    8000489e:	05848513          	addi	a0,s1,88
    800048a2:	ffffc097          	auipc	ra,0xffffc
    800048a6:	4f8080e7          	jalr	1272(ra) # 80000d9a <memmove>
    bwrite(to);  // write the log
    800048aa:	8526                	mv	a0,s1
    800048ac:	fffff097          	auipc	ra,0xfffff
    800048b0:	d70080e7          	jalr	-656(ra) # 8000361c <bwrite>
    brelse(from);
    800048b4:	854e                	mv	a0,s3
    800048b6:	fffff097          	auipc	ra,0xfffff
    800048ba:	da4080e7          	jalr	-604(ra) # 8000365a <brelse>
    brelse(to);
    800048be:	8526                	mv	a0,s1
    800048c0:	fffff097          	auipc	ra,0xfffff
    800048c4:	d9a080e7          	jalr	-614(ra) # 8000365a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800048c8:	2905                	addiw	s2,s2,1
    800048ca:	0a91                	addi	s5,s5,4
    800048cc:	02ca2783          	lw	a5,44(s4)
    800048d0:	f8f94fe3          	blt	s2,a5,8000486e <end_op+0xd2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800048d4:	00000097          	auipc	ra,0x0
    800048d8:	c82080e7          	jalr	-894(ra) # 80004556 <write_head>
    install_trans(0); // Now install writes to home locations
    800048dc:	4501                	li	a0,0
    800048de:	00000097          	auipc	ra,0x0
    800048e2:	ce2080e7          	jalr	-798(ra) # 800045c0 <install_trans>
    log.lh.n = 0;
    800048e6:	0001d797          	auipc	a5,0x1d
    800048ea:	0207a323          	sw	zero,38(a5) # 8002190c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800048ee:	00000097          	auipc	ra,0x0
    800048f2:	c68080e7          	jalr	-920(ra) # 80004556 <write_head>
    800048f6:	69e2                	ld	s3,24(sp)
    800048f8:	6a42                	ld	s4,16(sp)
    800048fa:	6aa2                	ld	s5,8(sp)
    800048fc:	6b02                	ld	s6,0(sp)
    800048fe:	b5e5                	j	800047e6 <end_op+0x4a>

0000000080004900 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004900:	1101                	addi	sp,sp,-32
    80004902:	ec06                	sd	ra,24(sp)
    80004904:	e822                	sd	s0,16(sp)
    80004906:	e426                	sd	s1,8(sp)
    80004908:	e04a                	sd	s2,0(sp)
    8000490a:	1000                	addi	s0,sp,32
    8000490c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000490e:	0001d917          	auipc	s2,0x1d
    80004912:	fd290913          	addi	s2,s2,-46 # 800218e0 <log>
    80004916:	854a                	mv	a0,s2
    80004918:	ffffc097          	auipc	ra,0xffffc
    8000491c:	326080e7          	jalr	806(ra) # 80000c3e <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004920:	02c92603          	lw	a2,44(s2)
    80004924:	47f5                	li	a5,29
    80004926:	06c7c563          	blt	a5,a2,80004990 <log_write+0x90>
    8000492a:	0001d797          	auipc	a5,0x1d
    8000492e:	fd27a783          	lw	a5,-46(a5) # 800218fc <log+0x1c>
    80004932:	37fd                	addiw	a5,a5,-1
    80004934:	04f65e63          	bge	a2,a5,80004990 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004938:	0001d797          	auipc	a5,0x1d
    8000493c:	fc87a783          	lw	a5,-56(a5) # 80021900 <log+0x20>
    80004940:	06f05063          	blez	a5,800049a0 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004944:	4781                	li	a5,0
    80004946:	06c05563          	blez	a2,800049b0 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000494a:	44cc                	lw	a1,12(s1)
    8000494c:	0001d717          	auipc	a4,0x1d
    80004950:	fc470713          	addi	a4,a4,-60 # 80021910 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004954:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004956:	4314                	lw	a3,0(a4)
    80004958:	04b68c63          	beq	a3,a1,800049b0 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000495c:	2785                	addiw	a5,a5,1
    8000495e:	0711                	addi	a4,a4,4
    80004960:	fef61be3          	bne	a2,a5,80004956 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004964:	0621                	addi	a2,a2,8
    80004966:	060a                	slli	a2,a2,0x2
    80004968:	0001d797          	auipc	a5,0x1d
    8000496c:	f7878793          	addi	a5,a5,-136 # 800218e0 <log>
    80004970:	97b2                	add	a5,a5,a2
    80004972:	44d8                	lw	a4,12(s1)
    80004974:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004976:	8526                	mv	a0,s1
    80004978:	fffff097          	auipc	ra,0xfffff
    8000497c:	d7a080e7          	jalr	-646(ra) # 800036f2 <bpin>
    log.lh.n++;
    80004980:	0001d717          	auipc	a4,0x1d
    80004984:	f6070713          	addi	a4,a4,-160 # 800218e0 <log>
    80004988:	575c                	lw	a5,44(a4)
    8000498a:	2785                	addiw	a5,a5,1
    8000498c:	d75c                	sw	a5,44(a4)
    8000498e:	a82d                	j	800049c8 <log_write+0xc8>
    panic("too big a transaction");
    80004990:	00004517          	auipc	a0,0x4
    80004994:	c8850513          	addi	a0,a0,-888 # 80008618 <etext+0x618>
    80004998:	ffffc097          	auipc	ra,0xffffc
    8000499c:	bc8080e7          	jalr	-1080(ra) # 80000560 <panic>
    panic("log_write outside of trans");
    800049a0:	00004517          	auipc	a0,0x4
    800049a4:	c9050513          	addi	a0,a0,-880 # 80008630 <etext+0x630>
    800049a8:	ffffc097          	auipc	ra,0xffffc
    800049ac:	bb8080e7          	jalr	-1096(ra) # 80000560 <panic>
  log.lh.block[i] = b->blockno;
    800049b0:	00878693          	addi	a3,a5,8
    800049b4:	068a                	slli	a3,a3,0x2
    800049b6:	0001d717          	auipc	a4,0x1d
    800049ba:	f2a70713          	addi	a4,a4,-214 # 800218e0 <log>
    800049be:	9736                	add	a4,a4,a3
    800049c0:	44d4                	lw	a3,12(s1)
    800049c2:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800049c4:	faf609e3          	beq	a2,a5,80004976 <log_write+0x76>
  }
  release(&log.lock);
    800049c8:	0001d517          	auipc	a0,0x1d
    800049cc:	f1850513          	addi	a0,a0,-232 # 800218e0 <log>
    800049d0:	ffffc097          	auipc	ra,0xffffc
    800049d4:	31e080e7          	jalr	798(ra) # 80000cee <release>
}
    800049d8:	60e2                	ld	ra,24(sp)
    800049da:	6442                	ld	s0,16(sp)
    800049dc:	64a2                	ld	s1,8(sp)
    800049de:	6902                	ld	s2,0(sp)
    800049e0:	6105                	addi	sp,sp,32
    800049e2:	8082                	ret

00000000800049e4 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800049e4:	1101                	addi	sp,sp,-32
    800049e6:	ec06                	sd	ra,24(sp)
    800049e8:	e822                	sd	s0,16(sp)
    800049ea:	e426                	sd	s1,8(sp)
    800049ec:	e04a                	sd	s2,0(sp)
    800049ee:	1000                	addi	s0,sp,32
    800049f0:	84aa                	mv	s1,a0
    800049f2:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800049f4:	00004597          	auipc	a1,0x4
    800049f8:	c5c58593          	addi	a1,a1,-932 # 80008650 <etext+0x650>
    800049fc:	0521                	addi	a0,a0,8
    800049fe:	ffffc097          	auipc	ra,0xffffc
    80004a02:	1ac080e7          	jalr	428(ra) # 80000baa <initlock>
  lk->name = name;
    80004a06:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004a0a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004a0e:	0204a423          	sw	zero,40(s1)
}
    80004a12:	60e2                	ld	ra,24(sp)
    80004a14:	6442                	ld	s0,16(sp)
    80004a16:	64a2                	ld	s1,8(sp)
    80004a18:	6902                	ld	s2,0(sp)
    80004a1a:	6105                	addi	sp,sp,32
    80004a1c:	8082                	ret

0000000080004a1e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004a1e:	1101                	addi	sp,sp,-32
    80004a20:	ec06                	sd	ra,24(sp)
    80004a22:	e822                	sd	s0,16(sp)
    80004a24:	e426                	sd	s1,8(sp)
    80004a26:	e04a                	sd	s2,0(sp)
    80004a28:	1000                	addi	s0,sp,32
    80004a2a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004a2c:	00850913          	addi	s2,a0,8
    80004a30:	854a                	mv	a0,s2
    80004a32:	ffffc097          	auipc	ra,0xffffc
    80004a36:	20c080e7          	jalr	524(ra) # 80000c3e <acquire>
  while (lk->locked) {
    80004a3a:	409c                	lw	a5,0(s1)
    80004a3c:	cb89                	beqz	a5,80004a4e <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004a3e:	85ca                	mv	a1,s2
    80004a40:	8526                	mv	a0,s1
    80004a42:	ffffe097          	auipc	ra,0xffffe
    80004a46:	b32080e7          	jalr	-1230(ra) # 80002574 <sleep>
  while (lk->locked) {
    80004a4a:	409c                	lw	a5,0(s1)
    80004a4c:	fbed                	bnez	a5,80004a3e <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004a4e:	4785                	li	a5,1
    80004a50:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004a52:	ffffd097          	auipc	ra,0xffffd
    80004a56:	330080e7          	jalr	816(ra) # 80001d82 <myproc>
    80004a5a:	591c                	lw	a5,48(a0)
    80004a5c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004a5e:	854a                	mv	a0,s2
    80004a60:	ffffc097          	auipc	ra,0xffffc
    80004a64:	28e080e7          	jalr	654(ra) # 80000cee <release>
}
    80004a68:	60e2                	ld	ra,24(sp)
    80004a6a:	6442                	ld	s0,16(sp)
    80004a6c:	64a2                	ld	s1,8(sp)
    80004a6e:	6902                	ld	s2,0(sp)
    80004a70:	6105                	addi	sp,sp,32
    80004a72:	8082                	ret

0000000080004a74 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004a74:	1101                	addi	sp,sp,-32
    80004a76:	ec06                	sd	ra,24(sp)
    80004a78:	e822                	sd	s0,16(sp)
    80004a7a:	e426                	sd	s1,8(sp)
    80004a7c:	e04a                	sd	s2,0(sp)
    80004a7e:	1000                	addi	s0,sp,32
    80004a80:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004a82:	00850913          	addi	s2,a0,8
    80004a86:	854a                	mv	a0,s2
    80004a88:	ffffc097          	auipc	ra,0xffffc
    80004a8c:	1b6080e7          	jalr	438(ra) # 80000c3e <acquire>
  lk->locked = 0;
    80004a90:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004a94:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004a98:	8526                	mv	a0,s1
    80004a9a:	ffffe097          	auipc	ra,0xffffe
    80004a9e:	b3e080e7          	jalr	-1218(ra) # 800025d8 <wakeup>
  release(&lk->lk);
    80004aa2:	854a                	mv	a0,s2
    80004aa4:	ffffc097          	auipc	ra,0xffffc
    80004aa8:	24a080e7          	jalr	586(ra) # 80000cee <release>
}
    80004aac:	60e2                	ld	ra,24(sp)
    80004aae:	6442                	ld	s0,16(sp)
    80004ab0:	64a2                	ld	s1,8(sp)
    80004ab2:	6902                	ld	s2,0(sp)
    80004ab4:	6105                	addi	sp,sp,32
    80004ab6:	8082                	ret

0000000080004ab8 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004ab8:	7179                	addi	sp,sp,-48
    80004aba:	f406                	sd	ra,40(sp)
    80004abc:	f022                	sd	s0,32(sp)
    80004abe:	ec26                	sd	s1,24(sp)
    80004ac0:	e84a                	sd	s2,16(sp)
    80004ac2:	1800                	addi	s0,sp,48
    80004ac4:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004ac6:	00850913          	addi	s2,a0,8
    80004aca:	854a                	mv	a0,s2
    80004acc:	ffffc097          	auipc	ra,0xffffc
    80004ad0:	172080e7          	jalr	370(ra) # 80000c3e <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004ad4:	409c                	lw	a5,0(s1)
    80004ad6:	ef91                	bnez	a5,80004af2 <holdingsleep+0x3a>
    80004ad8:	4481                	li	s1,0
  release(&lk->lk);
    80004ada:	854a                	mv	a0,s2
    80004adc:	ffffc097          	auipc	ra,0xffffc
    80004ae0:	212080e7          	jalr	530(ra) # 80000cee <release>
  return r;
}
    80004ae4:	8526                	mv	a0,s1
    80004ae6:	70a2                	ld	ra,40(sp)
    80004ae8:	7402                	ld	s0,32(sp)
    80004aea:	64e2                	ld	s1,24(sp)
    80004aec:	6942                	ld	s2,16(sp)
    80004aee:	6145                	addi	sp,sp,48
    80004af0:	8082                	ret
    80004af2:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004af4:	0284a983          	lw	s3,40(s1)
    80004af8:	ffffd097          	auipc	ra,0xffffd
    80004afc:	28a080e7          	jalr	650(ra) # 80001d82 <myproc>
    80004b00:	5904                	lw	s1,48(a0)
    80004b02:	413484b3          	sub	s1,s1,s3
    80004b06:	0014b493          	seqz	s1,s1
    80004b0a:	69a2                	ld	s3,8(sp)
    80004b0c:	b7f9                	j	80004ada <holdingsleep+0x22>

0000000080004b0e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004b0e:	1141                	addi	sp,sp,-16
    80004b10:	e406                	sd	ra,8(sp)
    80004b12:	e022                	sd	s0,0(sp)
    80004b14:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004b16:	00004597          	auipc	a1,0x4
    80004b1a:	b4a58593          	addi	a1,a1,-1206 # 80008660 <etext+0x660>
    80004b1e:	0001d517          	auipc	a0,0x1d
    80004b22:	f0a50513          	addi	a0,a0,-246 # 80021a28 <ftable>
    80004b26:	ffffc097          	auipc	ra,0xffffc
    80004b2a:	084080e7          	jalr	132(ra) # 80000baa <initlock>
}
    80004b2e:	60a2                	ld	ra,8(sp)
    80004b30:	6402                	ld	s0,0(sp)
    80004b32:	0141                	addi	sp,sp,16
    80004b34:	8082                	ret

0000000080004b36 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004b36:	1101                	addi	sp,sp,-32
    80004b38:	ec06                	sd	ra,24(sp)
    80004b3a:	e822                	sd	s0,16(sp)
    80004b3c:	e426                	sd	s1,8(sp)
    80004b3e:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004b40:	0001d517          	auipc	a0,0x1d
    80004b44:	ee850513          	addi	a0,a0,-280 # 80021a28 <ftable>
    80004b48:	ffffc097          	auipc	ra,0xffffc
    80004b4c:	0f6080e7          	jalr	246(ra) # 80000c3e <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004b50:	0001d497          	auipc	s1,0x1d
    80004b54:	ef048493          	addi	s1,s1,-272 # 80021a40 <ftable+0x18>
    80004b58:	0001e717          	auipc	a4,0x1e
    80004b5c:	e8870713          	addi	a4,a4,-376 # 800229e0 <disk>
    if(f->ref == 0){
    80004b60:	40dc                	lw	a5,4(s1)
    80004b62:	cf99                	beqz	a5,80004b80 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004b64:	02848493          	addi	s1,s1,40
    80004b68:	fee49ce3          	bne	s1,a4,80004b60 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004b6c:	0001d517          	auipc	a0,0x1d
    80004b70:	ebc50513          	addi	a0,a0,-324 # 80021a28 <ftable>
    80004b74:	ffffc097          	auipc	ra,0xffffc
    80004b78:	17a080e7          	jalr	378(ra) # 80000cee <release>
  return 0;
    80004b7c:	4481                	li	s1,0
    80004b7e:	a819                	j	80004b94 <filealloc+0x5e>
      f->ref = 1;
    80004b80:	4785                	li	a5,1
    80004b82:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004b84:	0001d517          	auipc	a0,0x1d
    80004b88:	ea450513          	addi	a0,a0,-348 # 80021a28 <ftable>
    80004b8c:	ffffc097          	auipc	ra,0xffffc
    80004b90:	162080e7          	jalr	354(ra) # 80000cee <release>
}
    80004b94:	8526                	mv	a0,s1
    80004b96:	60e2                	ld	ra,24(sp)
    80004b98:	6442                	ld	s0,16(sp)
    80004b9a:	64a2                	ld	s1,8(sp)
    80004b9c:	6105                	addi	sp,sp,32
    80004b9e:	8082                	ret

0000000080004ba0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004ba0:	1101                	addi	sp,sp,-32
    80004ba2:	ec06                	sd	ra,24(sp)
    80004ba4:	e822                	sd	s0,16(sp)
    80004ba6:	e426                	sd	s1,8(sp)
    80004ba8:	1000                	addi	s0,sp,32
    80004baa:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004bac:	0001d517          	auipc	a0,0x1d
    80004bb0:	e7c50513          	addi	a0,a0,-388 # 80021a28 <ftable>
    80004bb4:	ffffc097          	auipc	ra,0xffffc
    80004bb8:	08a080e7          	jalr	138(ra) # 80000c3e <acquire>
  if(f->ref < 1)
    80004bbc:	40dc                	lw	a5,4(s1)
    80004bbe:	02f05263          	blez	a5,80004be2 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004bc2:	2785                	addiw	a5,a5,1
    80004bc4:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004bc6:	0001d517          	auipc	a0,0x1d
    80004bca:	e6250513          	addi	a0,a0,-414 # 80021a28 <ftable>
    80004bce:	ffffc097          	auipc	ra,0xffffc
    80004bd2:	120080e7          	jalr	288(ra) # 80000cee <release>
  return f;
}
    80004bd6:	8526                	mv	a0,s1
    80004bd8:	60e2                	ld	ra,24(sp)
    80004bda:	6442                	ld	s0,16(sp)
    80004bdc:	64a2                	ld	s1,8(sp)
    80004bde:	6105                	addi	sp,sp,32
    80004be0:	8082                	ret
    panic("filedup");
    80004be2:	00004517          	auipc	a0,0x4
    80004be6:	a8650513          	addi	a0,a0,-1402 # 80008668 <etext+0x668>
    80004bea:	ffffc097          	auipc	ra,0xffffc
    80004bee:	976080e7          	jalr	-1674(ra) # 80000560 <panic>

0000000080004bf2 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004bf2:	7139                	addi	sp,sp,-64
    80004bf4:	fc06                	sd	ra,56(sp)
    80004bf6:	f822                	sd	s0,48(sp)
    80004bf8:	f426                	sd	s1,40(sp)
    80004bfa:	0080                	addi	s0,sp,64
    80004bfc:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004bfe:	0001d517          	auipc	a0,0x1d
    80004c02:	e2a50513          	addi	a0,a0,-470 # 80021a28 <ftable>
    80004c06:	ffffc097          	auipc	ra,0xffffc
    80004c0a:	038080e7          	jalr	56(ra) # 80000c3e <acquire>
  if(f->ref < 1)
    80004c0e:	40dc                	lw	a5,4(s1)
    80004c10:	04f05a63          	blez	a5,80004c64 <fileclose+0x72>
    panic("fileclose");
  if(--f->ref > 0){
    80004c14:	37fd                	addiw	a5,a5,-1
    80004c16:	c0dc                	sw	a5,4(s1)
    80004c18:	06f04263          	bgtz	a5,80004c7c <fileclose+0x8a>
    80004c1c:	f04a                	sd	s2,32(sp)
    80004c1e:	ec4e                	sd	s3,24(sp)
    80004c20:	e852                	sd	s4,16(sp)
    80004c22:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004c24:	0004a903          	lw	s2,0(s1)
    80004c28:	0094ca83          	lbu	s5,9(s1)
    80004c2c:	0104ba03          	ld	s4,16(s1)
    80004c30:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004c34:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004c38:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004c3c:	0001d517          	auipc	a0,0x1d
    80004c40:	dec50513          	addi	a0,a0,-532 # 80021a28 <ftable>
    80004c44:	ffffc097          	auipc	ra,0xffffc
    80004c48:	0aa080e7          	jalr	170(ra) # 80000cee <release>

  if(ff.type == FD_PIPE){
    80004c4c:	4785                	li	a5,1
    80004c4e:	04f90463          	beq	s2,a5,80004c96 <fileclose+0xa4>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004c52:	3979                	addiw	s2,s2,-2
    80004c54:	4785                	li	a5,1
    80004c56:	0527fb63          	bgeu	a5,s2,80004cac <fileclose+0xba>
    80004c5a:	7902                	ld	s2,32(sp)
    80004c5c:	69e2                	ld	s3,24(sp)
    80004c5e:	6a42                	ld	s4,16(sp)
    80004c60:	6aa2                	ld	s5,8(sp)
    80004c62:	a02d                	j	80004c8c <fileclose+0x9a>
    80004c64:	f04a                	sd	s2,32(sp)
    80004c66:	ec4e                	sd	s3,24(sp)
    80004c68:	e852                	sd	s4,16(sp)
    80004c6a:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004c6c:	00004517          	auipc	a0,0x4
    80004c70:	a0450513          	addi	a0,a0,-1532 # 80008670 <etext+0x670>
    80004c74:	ffffc097          	auipc	ra,0xffffc
    80004c78:	8ec080e7          	jalr	-1812(ra) # 80000560 <panic>
    release(&ftable.lock);
    80004c7c:	0001d517          	auipc	a0,0x1d
    80004c80:	dac50513          	addi	a0,a0,-596 # 80021a28 <ftable>
    80004c84:	ffffc097          	auipc	ra,0xffffc
    80004c88:	06a080e7          	jalr	106(ra) # 80000cee <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004c8c:	70e2                	ld	ra,56(sp)
    80004c8e:	7442                	ld	s0,48(sp)
    80004c90:	74a2                	ld	s1,40(sp)
    80004c92:	6121                	addi	sp,sp,64
    80004c94:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004c96:	85d6                	mv	a1,s5
    80004c98:	8552                	mv	a0,s4
    80004c9a:	00000097          	auipc	ra,0x0
    80004c9e:	3ac080e7          	jalr	940(ra) # 80005046 <pipeclose>
    80004ca2:	7902                	ld	s2,32(sp)
    80004ca4:	69e2                	ld	s3,24(sp)
    80004ca6:	6a42                	ld	s4,16(sp)
    80004ca8:	6aa2                	ld	s5,8(sp)
    80004caa:	b7cd                	j	80004c8c <fileclose+0x9a>
    begin_op();
    80004cac:	00000097          	auipc	ra,0x0
    80004cb0:	a76080e7          	jalr	-1418(ra) # 80004722 <begin_op>
    iput(ff.ip);
    80004cb4:	854e                	mv	a0,s3
    80004cb6:	fffff097          	auipc	ra,0xfffff
    80004cba:	240080e7          	jalr	576(ra) # 80003ef6 <iput>
    end_op();
    80004cbe:	00000097          	auipc	ra,0x0
    80004cc2:	ade080e7          	jalr	-1314(ra) # 8000479c <end_op>
    80004cc6:	7902                	ld	s2,32(sp)
    80004cc8:	69e2                	ld	s3,24(sp)
    80004cca:	6a42                	ld	s4,16(sp)
    80004ccc:	6aa2                	ld	s5,8(sp)
    80004cce:	bf7d                	j	80004c8c <fileclose+0x9a>

0000000080004cd0 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004cd0:	715d                	addi	sp,sp,-80
    80004cd2:	e486                	sd	ra,72(sp)
    80004cd4:	e0a2                	sd	s0,64(sp)
    80004cd6:	fc26                	sd	s1,56(sp)
    80004cd8:	f44e                	sd	s3,40(sp)
    80004cda:	0880                	addi	s0,sp,80
    80004cdc:	84aa                	mv	s1,a0
    80004cde:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004ce0:	ffffd097          	auipc	ra,0xffffd
    80004ce4:	0a2080e7          	jalr	162(ra) # 80001d82 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004ce8:	409c                	lw	a5,0(s1)
    80004cea:	37f9                	addiw	a5,a5,-2
    80004cec:	4705                	li	a4,1
    80004cee:	04f76a63          	bltu	a4,a5,80004d42 <filestat+0x72>
    80004cf2:	f84a                	sd	s2,48(sp)
    80004cf4:	f052                	sd	s4,32(sp)
    80004cf6:	892a                	mv	s2,a0
    ilock(f->ip);
    80004cf8:	6c88                	ld	a0,24(s1)
    80004cfa:	fffff097          	auipc	ra,0xfffff
    80004cfe:	03e080e7          	jalr	62(ra) # 80003d38 <ilock>
    stati(f->ip, &st);
    80004d02:	fb840a13          	addi	s4,s0,-72
    80004d06:	85d2                	mv	a1,s4
    80004d08:	6c88                	ld	a0,24(s1)
    80004d0a:	fffff097          	auipc	ra,0xfffff
    80004d0e:	2bc080e7          	jalr	700(ra) # 80003fc6 <stati>
    iunlock(f->ip);
    80004d12:	6c88                	ld	a0,24(s1)
    80004d14:	fffff097          	auipc	ra,0xfffff
    80004d18:	0ea080e7          	jalr	234(ra) # 80003dfe <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004d1c:	46e1                	li	a3,24
    80004d1e:	8652                	mv	a2,s4
    80004d20:	85ce                	mv	a1,s3
    80004d22:	05093503          	ld	a0,80(s2)
    80004d26:	ffffd097          	auipc	ra,0xffffd
    80004d2a:	9ea080e7          	jalr	-1558(ra) # 80001710 <copyout>
    80004d2e:	41f5551b          	sraiw	a0,a0,0x1f
    80004d32:	7942                	ld	s2,48(sp)
    80004d34:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004d36:	60a6                	ld	ra,72(sp)
    80004d38:	6406                	ld	s0,64(sp)
    80004d3a:	74e2                	ld	s1,56(sp)
    80004d3c:	79a2                	ld	s3,40(sp)
    80004d3e:	6161                	addi	sp,sp,80
    80004d40:	8082                	ret
  return -1;
    80004d42:	557d                	li	a0,-1
    80004d44:	bfcd                	j	80004d36 <filestat+0x66>

0000000080004d46 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004d46:	7179                	addi	sp,sp,-48
    80004d48:	f406                	sd	ra,40(sp)
    80004d4a:	f022                	sd	s0,32(sp)
    80004d4c:	e84a                	sd	s2,16(sp)
    80004d4e:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004d50:	00854783          	lbu	a5,8(a0)
    80004d54:	cbc5                	beqz	a5,80004e04 <fileread+0xbe>
    80004d56:	ec26                	sd	s1,24(sp)
    80004d58:	e44e                	sd	s3,8(sp)
    80004d5a:	84aa                	mv	s1,a0
    80004d5c:	89ae                	mv	s3,a1
    80004d5e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004d60:	411c                	lw	a5,0(a0)
    80004d62:	4705                	li	a4,1
    80004d64:	04e78963          	beq	a5,a4,80004db6 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004d68:	470d                	li	a4,3
    80004d6a:	04e78f63          	beq	a5,a4,80004dc8 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004d6e:	4709                	li	a4,2
    80004d70:	08e79263          	bne	a5,a4,80004df4 <fileread+0xae>
    ilock(f->ip);
    80004d74:	6d08                	ld	a0,24(a0)
    80004d76:	fffff097          	auipc	ra,0xfffff
    80004d7a:	fc2080e7          	jalr	-62(ra) # 80003d38 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004d7e:	874a                	mv	a4,s2
    80004d80:	5094                	lw	a3,32(s1)
    80004d82:	864e                	mv	a2,s3
    80004d84:	4585                	li	a1,1
    80004d86:	6c88                	ld	a0,24(s1)
    80004d88:	fffff097          	auipc	ra,0xfffff
    80004d8c:	26c080e7          	jalr	620(ra) # 80003ff4 <readi>
    80004d90:	892a                	mv	s2,a0
    80004d92:	00a05563          	blez	a0,80004d9c <fileread+0x56>
      f->off += r;
    80004d96:	509c                	lw	a5,32(s1)
    80004d98:	9fa9                	addw	a5,a5,a0
    80004d9a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004d9c:	6c88                	ld	a0,24(s1)
    80004d9e:	fffff097          	auipc	ra,0xfffff
    80004da2:	060080e7          	jalr	96(ra) # 80003dfe <iunlock>
    80004da6:	64e2                	ld	s1,24(sp)
    80004da8:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004daa:	854a                	mv	a0,s2
    80004dac:	70a2                	ld	ra,40(sp)
    80004dae:	7402                	ld	s0,32(sp)
    80004db0:	6942                	ld	s2,16(sp)
    80004db2:	6145                	addi	sp,sp,48
    80004db4:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004db6:	6908                	ld	a0,16(a0)
    80004db8:	00000097          	auipc	ra,0x0
    80004dbc:	41a080e7          	jalr	1050(ra) # 800051d2 <piperead>
    80004dc0:	892a                	mv	s2,a0
    80004dc2:	64e2                	ld	s1,24(sp)
    80004dc4:	69a2                	ld	s3,8(sp)
    80004dc6:	b7d5                	j	80004daa <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004dc8:	02451783          	lh	a5,36(a0)
    80004dcc:	03079693          	slli	a3,a5,0x30
    80004dd0:	92c1                	srli	a3,a3,0x30
    80004dd2:	4725                	li	a4,9
    80004dd4:	02d76a63          	bltu	a4,a3,80004e08 <fileread+0xc2>
    80004dd8:	0792                	slli	a5,a5,0x4
    80004dda:	0001d717          	auipc	a4,0x1d
    80004dde:	bae70713          	addi	a4,a4,-1106 # 80021988 <devsw>
    80004de2:	97ba                	add	a5,a5,a4
    80004de4:	639c                	ld	a5,0(a5)
    80004de6:	c78d                	beqz	a5,80004e10 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80004de8:	4505                	li	a0,1
    80004dea:	9782                	jalr	a5
    80004dec:	892a                	mv	s2,a0
    80004dee:	64e2                	ld	s1,24(sp)
    80004df0:	69a2                	ld	s3,8(sp)
    80004df2:	bf65                	j	80004daa <fileread+0x64>
    panic("fileread");
    80004df4:	00004517          	auipc	a0,0x4
    80004df8:	88c50513          	addi	a0,a0,-1908 # 80008680 <etext+0x680>
    80004dfc:	ffffb097          	auipc	ra,0xffffb
    80004e00:	764080e7          	jalr	1892(ra) # 80000560 <panic>
    return -1;
    80004e04:	597d                	li	s2,-1
    80004e06:	b755                	j	80004daa <fileread+0x64>
      return -1;
    80004e08:	597d                	li	s2,-1
    80004e0a:	64e2                	ld	s1,24(sp)
    80004e0c:	69a2                	ld	s3,8(sp)
    80004e0e:	bf71                	j	80004daa <fileread+0x64>
    80004e10:	597d                	li	s2,-1
    80004e12:	64e2                	ld	s1,24(sp)
    80004e14:	69a2                	ld	s3,8(sp)
    80004e16:	bf51                	j	80004daa <fileread+0x64>

0000000080004e18 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004e18:	00954783          	lbu	a5,9(a0)
    80004e1c:	12078c63          	beqz	a5,80004f54 <filewrite+0x13c>
{
    80004e20:	711d                	addi	sp,sp,-96
    80004e22:	ec86                	sd	ra,88(sp)
    80004e24:	e8a2                	sd	s0,80(sp)
    80004e26:	e0ca                	sd	s2,64(sp)
    80004e28:	f456                	sd	s5,40(sp)
    80004e2a:	f05a                	sd	s6,32(sp)
    80004e2c:	1080                	addi	s0,sp,96
    80004e2e:	892a                	mv	s2,a0
    80004e30:	8b2e                	mv	s6,a1
    80004e32:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80004e34:	411c                	lw	a5,0(a0)
    80004e36:	4705                	li	a4,1
    80004e38:	02e78963          	beq	a5,a4,80004e6a <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004e3c:	470d                	li	a4,3
    80004e3e:	02e78c63          	beq	a5,a4,80004e76 <filewrite+0x5e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004e42:	4709                	li	a4,2
    80004e44:	0ee79a63          	bne	a5,a4,80004f38 <filewrite+0x120>
    80004e48:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004e4a:	0cc05563          	blez	a2,80004f14 <filewrite+0xfc>
    80004e4e:	e4a6                	sd	s1,72(sp)
    80004e50:	fc4e                	sd	s3,56(sp)
    80004e52:	ec5e                	sd	s7,24(sp)
    80004e54:	e862                	sd	s8,16(sp)
    80004e56:	e466                	sd	s9,8(sp)
    int i = 0;
    80004e58:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80004e5a:	6b85                	lui	s7,0x1
    80004e5c:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004e60:	6c85                	lui	s9,0x1
    80004e62:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004e66:	4c05                	li	s8,1
    80004e68:	a849                	j	80004efa <filewrite+0xe2>
    ret = pipewrite(f->pipe, addr, n);
    80004e6a:	6908                	ld	a0,16(a0)
    80004e6c:	00000097          	auipc	ra,0x0
    80004e70:	24a080e7          	jalr	586(ra) # 800050b6 <pipewrite>
    80004e74:	a85d                	j	80004f2a <filewrite+0x112>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004e76:	02451783          	lh	a5,36(a0)
    80004e7a:	03079693          	slli	a3,a5,0x30
    80004e7e:	92c1                	srli	a3,a3,0x30
    80004e80:	4725                	li	a4,9
    80004e82:	0cd76b63          	bltu	a4,a3,80004f58 <filewrite+0x140>
    80004e86:	0792                	slli	a5,a5,0x4
    80004e88:	0001d717          	auipc	a4,0x1d
    80004e8c:	b0070713          	addi	a4,a4,-1280 # 80021988 <devsw>
    80004e90:	97ba                	add	a5,a5,a4
    80004e92:	679c                	ld	a5,8(a5)
    80004e94:	c7e1                	beqz	a5,80004f5c <filewrite+0x144>
    ret = devsw[f->major].write(1, addr, n);
    80004e96:	4505                	li	a0,1
    80004e98:	9782                	jalr	a5
    80004e9a:	a841                	j	80004f2a <filewrite+0x112>
      if(n1 > max)
    80004e9c:	2981                	sext.w	s3,s3
      begin_op();
    80004e9e:	00000097          	auipc	ra,0x0
    80004ea2:	884080e7          	jalr	-1916(ra) # 80004722 <begin_op>
      ilock(f->ip);
    80004ea6:	01893503          	ld	a0,24(s2)
    80004eaa:	fffff097          	auipc	ra,0xfffff
    80004eae:	e8e080e7          	jalr	-370(ra) # 80003d38 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004eb2:	874e                	mv	a4,s3
    80004eb4:	02092683          	lw	a3,32(s2)
    80004eb8:	016a0633          	add	a2,s4,s6
    80004ebc:	85e2                	mv	a1,s8
    80004ebe:	01893503          	ld	a0,24(s2)
    80004ec2:	fffff097          	auipc	ra,0xfffff
    80004ec6:	238080e7          	jalr	568(ra) # 800040fa <writei>
    80004eca:	84aa                	mv	s1,a0
    80004ecc:	00a05763          	blez	a0,80004eda <filewrite+0xc2>
        f->off += r;
    80004ed0:	02092783          	lw	a5,32(s2)
    80004ed4:	9fa9                	addw	a5,a5,a0
    80004ed6:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004eda:	01893503          	ld	a0,24(s2)
    80004ede:	fffff097          	auipc	ra,0xfffff
    80004ee2:	f20080e7          	jalr	-224(ra) # 80003dfe <iunlock>
      end_op();
    80004ee6:	00000097          	auipc	ra,0x0
    80004eea:	8b6080e7          	jalr	-1866(ra) # 8000479c <end_op>

      if(r != n1){
    80004eee:	02999563          	bne	s3,s1,80004f18 <filewrite+0x100>
        // error from writei
        break;
      }
      i += r;
    80004ef2:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80004ef6:	015a5963          	bge	s4,s5,80004f08 <filewrite+0xf0>
      int n1 = n - i;
    80004efa:	414a87bb          	subw	a5,s5,s4
    80004efe:	89be                	mv	s3,a5
      if(n1 > max)
    80004f00:	f8fbdee3          	bge	s7,a5,80004e9c <filewrite+0x84>
    80004f04:	89e6                	mv	s3,s9
    80004f06:	bf59                	j	80004e9c <filewrite+0x84>
    80004f08:	64a6                	ld	s1,72(sp)
    80004f0a:	79e2                	ld	s3,56(sp)
    80004f0c:	6be2                	ld	s7,24(sp)
    80004f0e:	6c42                	ld	s8,16(sp)
    80004f10:	6ca2                	ld	s9,8(sp)
    80004f12:	a801                	j	80004f22 <filewrite+0x10a>
    int i = 0;
    80004f14:	4a01                	li	s4,0
    80004f16:	a031                	j	80004f22 <filewrite+0x10a>
    80004f18:	64a6                	ld	s1,72(sp)
    80004f1a:	79e2                	ld	s3,56(sp)
    80004f1c:	6be2                	ld	s7,24(sp)
    80004f1e:	6c42                	ld	s8,16(sp)
    80004f20:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80004f22:	034a9f63          	bne	s5,s4,80004f60 <filewrite+0x148>
    80004f26:	8556                	mv	a0,s5
    80004f28:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004f2a:	60e6                	ld	ra,88(sp)
    80004f2c:	6446                	ld	s0,80(sp)
    80004f2e:	6906                	ld	s2,64(sp)
    80004f30:	7aa2                	ld	s5,40(sp)
    80004f32:	7b02                	ld	s6,32(sp)
    80004f34:	6125                	addi	sp,sp,96
    80004f36:	8082                	ret
    80004f38:	e4a6                	sd	s1,72(sp)
    80004f3a:	fc4e                	sd	s3,56(sp)
    80004f3c:	f852                	sd	s4,48(sp)
    80004f3e:	ec5e                	sd	s7,24(sp)
    80004f40:	e862                	sd	s8,16(sp)
    80004f42:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80004f44:	00003517          	auipc	a0,0x3
    80004f48:	74c50513          	addi	a0,a0,1868 # 80008690 <etext+0x690>
    80004f4c:	ffffb097          	auipc	ra,0xffffb
    80004f50:	614080e7          	jalr	1556(ra) # 80000560 <panic>
    return -1;
    80004f54:	557d                	li	a0,-1
}
    80004f56:	8082                	ret
      return -1;
    80004f58:	557d                	li	a0,-1
    80004f5a:	bfc1                	j	80004f2a <filewrite+0x112>
    80004f5c:	557d                	li	a0,-1
    80004f5e:	b7f1                	j	80004f2a <filewrite+0x112>
    ret = (i == n ? n : -1);
    80004f60:	557d                	li	a0,-1
    80004f62:	7a42                	ld	s4,48(sp)
    80004f64:	b7d9                	j	80004f2a <filewrite+0x112>

0000000080004f66 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004f66:	7179                	addi	sp,sp,-48
    80004f68:	f406                	sd	ra,40(sp)
    80004f6a:	f022                	sd	s0,32(sp)
    80004f6c:	ec26                	sd	s1,24(sp)
    80004f6e:	e052                	sd	s4,0(sp)
    80004f70:	1800                	addi	s0,sp,48
    80004f72:	84aa                	mv	s1,a0
    80004f74:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004f76:	0005b023          	sd	zero,0(a1)
    80004f7a:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004f7e:	00000097          	auipc	ra,0x0
    80004f82:	bb8080e7          	jalr	-1096(ra) # 80004b36 <filealloc>
    80004f86:	e088                	sd	a0,0(s1)
    80004f88:	cd49                	beqz	a0,80005022 <pipealloc+0xbc>
    80004f8a:	00000097          	auipc	ra,0x0
    80004f8e:	bac080e7          	jalr	-1108(ra) # 80004b36 <filealloc>
    80004f92:	00aa3023          	sd	a0,0(s4)
    80004f96:	c141                	beqz	a0,80005016 <pipealloc+0xb0>
    80004f98:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004f9a:	ffffc097          	auipc	ra,0xffffc
    80004f9e:	bb0080e7          	jalr	-1104(ra) # 80000b4a <kalloc>
    80004fa2:	892a                	mv	s2,a0
    80004fa4:	c13d                	beqz	a0,8000500a <pipealloc+0xa4>
    80004fa6:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004fa8:	4985                	li	s3,1
    80004faa:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004fae:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004fb2:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004fb6:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004fba:	00003597          	auipc	a1,0x3
    80004fbe:	6e658593          	addi	a1,a1,1766 # 800086a0 <etext+0x6a0>
    80004fc2:	ffffc097          	auipc	ra,0xffffc
    80004fc6:	be8080e7          	jalr	-1048(ra) # 80000baa <initlock>
  (*f0)->type = FD_PIPE;
    80004fca:	609c                	ld	a5,0(s1)
    80004fcc:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004fd0:	609c                	ld	a5,0(s1)
    80004fd2:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004fd6:	609c                	ld	a5,0(s1)
    80004fd8:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004fdc:	609c                	ld	a5,0(s1)
    80004fde:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004fe2:	000a3783          	ld	a5,0(s4)
    80004fe6:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004fea:	000a3783          	ld	a5,0(s4)
    80004fee:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004ff2:	000a3783          	ld	a5,0(s4)
    80004ff6:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004ffa:	000a3783          	ld	a5,0(s4)
    80004ffe:	0127b823          	sd	s2,16(a5)
  return 0;
    80005002:	4501                	li	a0,0
    80005004:	6942                	ld	s2,16(sp)
    80005006:	69a2                	ld	s3,8(sp)
    80005008:	a03d                	j	80005036 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000500a:	6088                	ld	a0,0(s1)
    8000500c:	c119                	beqz	a0,80005012 <pipealloc+0xac>
    8000500e:	6942                	ld	s2,16(sp)
    80005010:	a029                	j	8000501a <pipealloc+0xb4>
    80005012:	6942                	ld	s2,16(sp)
    80005014:	a039                	j	80005022 <pipealloc+0xbc>
    80005016:	6088                	ld	a0,0(s1)
    80005018:	c50d                	beqz	a0,80005042 <pipealloc+0xdc>
    fileclose(*f0);
    8000501a:	00000097          	auipc	ra,0x0
    8000501e:	bd8080e7          	jalr	-1064(ra) # 80004bf2 <fileclose>
  if(*f1)
    80005022:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80005026:	557d                	li	a0,-1
  if(*f1)
    80005028:	c799                	beqz	a5,80005036 <pipealloc+0xd0>
    fileclose(*f1);
    8000502a:	853e                	mv	a0,a5
    8000502c:	00000097          	auipc	ra,0x0
    80005030:	bc6080e7          	jalr	-1082(ra) # 80004bf2 <fileclose>
  return -1;
    80005034:	557d                	li	a0,-1
}
    80005036:	70a2                	ld	ra,40(sp)
    80005038:	7402                	ld	s0,32(sp)
    8000503a:	64e2                	ld	s1,24(sp)
    8000503c:	6a02                	ld	s4,0(sp)
    8000503e:	6145                	addi	sp,sp,48
    80005040:	8082                	ret
  return -1;
    80005042:	557d                	li	a0,-1
    80005044:	bfcd                	j	80005036 <pipealloc+0xd0>

0000000080005046 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80005046:	1101                	addi	sp,sp,-32
    80005048:	ec06                	sd	ra,24(sp)
    8000504a:	e822                	sd	s0,16(sp)
    8000504c:	e426                	sd	s1,8(sp)
    8000504e:	e04a                	sd	s2,0(sp)
    80005050:	1000                	addi	s0,sp,32
    80005052:	84aa                	mv	s1,a0
    80005054:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80005056:	ffffc097          	auipc	ra,0xffffc
    8000505a:	be8080e7          	jalr	-1048(ra) # 80000c3e <acquire>
  if(writable){
    8000505e:	02090d63          	beqz	s2,80005098 <pipeclose+0x52>
    pi->writeopen = 0;
    80005062:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80005066:	21848513          	addi	a0,s1,536
    8000506a:	ffffd097          	auipc	ra,0xffffd
    8000506e:	56e080e7          	jalr	1390(ra) # 800025d8 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80005072:	2204b783          	ld	a5,544(s1)
    80005076:	eb95                	bnez	a5,800050aa <pipeclose+0x64>
    release(&pi->lock);
    80005078:	8526                	mv	a0,s1
    8000507a:	ffffc097          	auipc	ra,0xffffc
    8000507e:	c74080e7          	jalr	-908(ra) # 80000cee <release>
    kfree((char*)pi);
    80005082:	8526                	mv	a0,s1
    80005084:	ffffc097          	auipc	ra,0xffffc
    80005088:	9c8080e7          	jalr	-1592(ra) # 80000a4c <kfree>
  } else
    release(&pi->lock);
}
    8000508c:	60e2                	ld	ra,24(sp)
    8000508e:	6442                	ld	s0,16(sp)
    80005090:	64a2                	ld	s1,8(sp)
    80005092:	6902                	ld	s2,0(sp)
    80005094:	6105                	addi	sp,sp,32
    80005096:	8082                	ret
    pi->readopen = 0;
    80005098:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000509c:	21c48513          	addi	a0,s1,540
    800050a0:	ffffd097          	auipc	ra,0xffffd
    800050a4:	538080e7          	jalr	1336(ra) # 800025d8 <wakeup>
    800050a8:	b7e9                	j	80005072 <pipeclose+0x2c>
    release(&pi->lock);
    800050aa:	8526                	mv	a0,s1
    800050ac:	ffffc097          	auipc	ra,0xffffc
    800050b0:	c42080e7          	jalr	-958(ra) # 80000cee <release>
}
    800050b4:	bfe1                	j	8000508c <pipeclose+0x46>

00000000800050b6 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800050b6:	7159                	addi	sp,sp,-112
    800050b8:	f486                	sd	ra,104(sp)
    800050ba:	f0a2                	sd	s0,96(sp)
    800050bc:	eca6                	sd	s1,88(sp)
    800050be:	e8ca                	sd	s2,80(sp)
    800050c0:	e4ce                	sd	s3,72(sp)
    800050c2:	e0d2                	sd	s4,64(sp)
    800050c4:	fc56                	sd	s5,56(sp)
    800050c6:	1880                	addi	s0,sp,112
    800050c8:	84aa                	mv	s1,a0
    800050ca:	8aae                	mv	s5,a1
    800050cc:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800050ce:	ffffd097          	auipc	ra,0xffffd
    800050d2:	cb4080e7          	jalr	-844(ra) # 80001d82 <myproc>
    800050d6:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800050d8:	8526                	mv	a0,s1
    800050da:	ffffc097          	auipc	ra,0xffffc
    800050de:	b64080e7          	jalr	-1180(ra) # 80000c3e <acquire>
  while(i < n){
    800050e2:	0f405063          	blez	s4,800051c2 <pipewrite+0x10c>
    800050e6:	f85a                	sd	s6,48(sp)
    800050e8:	f45e                	sd	s7,40(sp)
    800050ea:	f062                	sd	s8,32(sp)
    800050ec:	ec66                	sd	s9,24(sp)
    800050ee:	e86a                	sd	s10,16(sp)
  int i = 0;
    800050f0:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800050f2:	f9f40c13          	addi	s8,s0,-97
    800050f6:	4b85                	li	s7,1
    800050f8:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800050fa:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800050fe:	21c48c93          	addi	s9,s1,540
    80005102:	a099                	j	80005148 <pipewrite+0x92>
      release(&pi->lock);
    80005104:	8526                	mv	a0,s1
    80005106:	ffffc097          	auipc	ra,0xffffc
    8000510a:	be8080e7          	jalr	-1048(ra) # 80000cee <release>
      return -1;
    8000510e:	597d                	li	s2,-1
    80005110:	7b42                	ld	s6,48(sp)
    80005112:	7ba2                	ld	s7,40(sp)
    80005114:	7c02                	ld	s8,32(sp)
    80005116:	6ce2                	ld	s9,24(sp)
    80005118:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000511a:	854a                	mv	a0,s2
    8000511c:	70a6                	ld	ra,104(sp)
    8000511e:	7406                	ld	s0,96(sp)
    80005120:	64e6                	ld	s1,88(sp)
    80005122:	6946                	ld	s2,80(sp)
    80005124:	69a6                	ld	s3,72(sp)
    80005126:	6a06                	ld	s4,64(sp)
    80005128:	7ae2                	ld	s5,56(sp)
    8000512a:	6165                	addi	sp,sp,112
    8000512c:	8082                	ret
      wakeup(&pi->nread);
    8000512e:	856a                	mv	a0,s10
    80005130:	ffffd097          	auipc	ra,0xffffd
    80005134:	4a8080e7          	jalr	1192(ra) # 800025d8 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80005138:	85a6                	mv	a1,s1
    8000513a:	8566                	mv	a0,s9
    8000513c:	ffffd097          	auipc	ra,0xffffd
    80005140:	438080e7          	jalr	1080(ra) # 80002574 <sleep>
  while(i < n){
    80005144:	05495e63          	bge	s2,s4,800051a0 <pipewrite+0xea>
    if(pi->readopen == 0 || killed(pr)){
    80005148:	2204a783          	lw	a5,544(s1)
    8000514c:	dfc5                	beqz	a5,80005104 <pipewrite+0x4e>
    8000514e:	854e                	mv	a0,s3
    80005150:	ffffd097          	auipc	ra,0xffffd
    80005154:	6cc080e7          	jalr	1740(ra) # 8000281c <killed>
    80005158:	f555                	bnez	a0,80005104 <pipewrite+0x4e>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000515a:	2184a783          	lw	a5,536(s1)
    8000515e:	21c4a703          	lw	a4,540(s1)
    80005162:	2007879b          	addiw	a5,a5,512
    80005166:	fcf704e3          	beq	a4,a5,8000512e <pipewrite+0x78>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000516a:	86de                	mv	a3,s7
    8000516c:	01590633          	add	a2,s2,s5
    80005170:	85e2                	mv	a1,s8
    80005172:	0509b503          	ld	a0,80(s3)
    80005176:	ffffc097          	auipc	ra,0xffffc
    8000517a:	626080e7          	jalr	1574(ra) # 8000179c <copyin>
    8000517e:	05650463          	beq	a0,s6,800051c6 <pipewrite+0x110>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80005182:	21c4a783          	lw	a5,540(s1)
    80005186:	0017871b          	addiw	a4,a5,1
    8000518a:	20e4ae23          	sw	a4,540(s1)
    8000518e:	1ff7f793          	andi	a5,a5,511
    80005192:	97a6                	add	a5,a5,s1
    80005194:	f9f44703          	lbu	a4,-97(s0)
    80005198:	00e78c23          	sb	a4,24(a5)
      i++;
    8000519c:	2905                	addiw	s2,s2,1
    8000519e:	b75d                	j	80005144 <pipewrite+0x8e>
    800051a0:	7b42                	ld	s6,48(sp)
    800051a2:	7ba2                	ld	s7,40(sp)
    800051a4:	7c02                	ld	s8,32(sp)
    800051a6:	6ce2                	ld	s9,24(sp)
    800051a8:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    800051aa:	21848513          	addi	a0,s1,536
    800051ae:	ffffd097          	auipc	ra,0xffffd
    800051b2:	42a080e7          	jalr	1066(ra) # 800025d8 <wakeup>
  release(&pi->lock);
    800051b6:	8526                	mv	a0,s1
    800051b8:	ffffc097          	auipc	ra,0xffffc
    800051bc:	b36080e7          	jalr	-1226(ra) # 80000cee <release>
  return i;
    800051c0:	bfa9                	j	8000511a <pipewrite+0x64>
  int i = 0;
    800051c2:	4901                	li	s2,0
    800051c4:	b7dd                	j	800051aa <pipewrite+0xf4>
    800051c6:	7b42                	ld	s6,48(sp)
    800051c8:	7ba2                	ld	s7,40(sp)
    800051ca:	7c02                	ld	s8,32(sp)
    800051cc:	6ce2                	ld	s9,24(sp)
    800051ce:	6d42                	ld	s10,16(sp)
    800051d0:	bfe9                	j	800051aa <pipewrite+0xf4>

00000000800051d2 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800051d2:	711d                	addi	sp,sp,-96
    800051d4:	ec86                	sd	ra,88(sp)
    800051d6:	e8a2                	sd	s0,80(sp)
    800051d8:	e4a6                	sd	s1,72(sp)
    800051da:	e0ca                	sd	s2,64(sp)
    800051dc:	fc4e                	sd	s3,56(sp)
    800051de:	f852                	sd	s4,48(sp)
    800051e0:	f456                	sd	s5,40(sp)
    800051e2:	1080                	addi	s0,sp,96
    800051e4:	84aa                	mv	s1,a0
    800051e6:	892e                	mv	s2,a1
    800051e8:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800051ea:	ffffd097          	auipc	ra,0xffffd
    800051ee:	b98080e7          	jalr	-1128(ra) # 80001d82 <myproc>
    800051f2:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800051f4:	8526                	mv	a0,s1
    800051f6:	ffffc097          	auipc	ra,0xffffc
    800051fa:	a48080e7          	jalr	-1464(ra) # 80000c3e <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800051fe:	2184a703          	lw	a4,536(s1)
    80005202:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005206:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000520a:	02f71b63          	bne	a4,a5,80005240 <piperead+0x6e>
    8000520e:	2244a783          	lw	a5,548(s1)
    80005212:	c3b1                	beqz	a5,80005256 <piperead+0x84>
    if(killed(pr)){
    80005214:	8552                	mv	a0,s4
    80005216:	ffffd097          	auipc	ra,0xffffd
    8000521a:	606080e7          	jalr	1542(ra) # 8000281c <killed>
    8000521e:	e50d                	bnez	a0,80005248 <piperead+0x76>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005220:	85a6                	mv	a1,s1
    80005222:	854e                	mv	a0,s3
    80005224:	ffffd097          	auipc	ra,0xffffd
    80005228:	350080e7          	jalr	848(ra) # 80002574 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000522c:	2184a703          	lw	a4,536(s1)
    80005230:	21c4a783          	lw	a5,540(s1)
    80005234:	fcf70de3          	beq	a4,a5,8000520e <piperead+0x3c>
    80005238:	f05a                	sd	s6,32(sp)
    8000523a:	ec5e                	sd	s7,24(sp)
    8000523c:	e862                	sd	s8,16(sp)
    8000523e:	a839                	j	8000525c <piperead+0x8a>
    80005240:	f05a                	sd	s6,32(sp)
    80005242:	ec5e                	sd	s7,24(sp)
    80005244:	e862                	sd	s8,16(sp)
    80005246:	a819                	j	8000525c <piperead+0x8a>
      release(&pi->lock);
    80005248:	8526                	mv	a0,s1
    8000524a:	ffffc097          	auipc	ra,0xffffc
    8000524e:	aa4080e7          	jalr	-1372(ra) # 80000cee <release>
      return -1;
    80005252:	59fd                	li	s3,-1
    80005254:	a895                	j	800052c8 <piperead+0xf6>
    80005256:	f05a                	sd	s6,32(sp)
    80005258:	ec5e                	sd	s7,24(sp)
    8000525a:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000525c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000525e:	faf40c13          	addi	s8,s0,-81
    80005262:	4b85                	li	s7,1
    80005264:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005266:	05505363          	blez	s5,800052ac <piperead+0xda>
    if(pi->nread == pi->nwrite)
    8000526a:	2184a783          	lw	a5,536(s1)
    8000526e:	21c4a703          	lw	a4,540(s1)
    80005272:	02f70d63          	beq	a4,a5,800052ac <piperead+0xda>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80005276:	0017871b          	addiw	a4,a5,1
    8000527a:	20e4ac23          	sw	a4,536(s1)
    8000527e:	1ff7f793          	andi	a5,a5,511
    80005282:	97a6                	add	a5,a5,s1
    80005284:	0187c783          	lbu	a5,24(a5)
    80005288:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000528c:	86de                	mv	a3,s7
    8000528e:	8662                	mv	a2,s8
    80005290:	85ca                	mv	a1,s2
    80005292:	050a3503          	ld	a0,80(s4)
    80005296:	ffffc097          	auipc	ra,0xffffc
    8000529a:	47a080e7          	jalr	1146(ra) # 80001710 <copyout>
    8000529e:	01650763          	beq	a0,s6,800052ac <piperead+0xda>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800052a2:	2985                	addiw	s3,s3,1
    800052a4:	0905                	addi	s2,s2,1
    800052a6:	fd3a92e3          	bne	s5,s3,8000526a <piperead+0x98>
    800052aa:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800052ac:	21c48513          	addi	a0,s1,540
    800052b0:	ffffd097          	auipc	ra,0xffffd
    800052b4:	328080e7          	jalr	808(ra) # 800025d8 <wakeup>
  release(&pi->lock);
    800052b8:	8526                	mv	a0,s1
    800052ba:	ffffc097          	auipc	ra,0xffffc
    800052be:	a34080e7          	jalr	-1484(ra) # 80000cee <release>
    800052c2:	7b02                	ld	s6,32(sp)
    800052c4:	6be2                	ld	s7,24(sp)
    800052c6:	6c42                	ld	s8,16(sp)
  return i;
}
    800052c8:	854e                	mv	a0,s3
    800052ca:	60e6                	ld	ra,88(sp)
    800052cc:	6446                	ld	s0,80(sp)
    800052ce:	64a6                	ld	s1,72(sp)
    800052d0:	6906                	ld	s2,64(sp)
    800052d2:	79e2                	ld	s3,56(sp)
    800052d4:	7a42                	ld	s4,48(sp)
    800052d6:	7aa2                	ld	s5,40(sp)
    800052d8:	6125                	addi	sp,sp,96
    800052da:	8082                	ret

00000000800052dc <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800052dc:	1141                	addi	sp,sp,-16
    800052de:	e406                	sd	ra,8(sp)
    800052e0:	e022                	sd	s0,0(sp)
    800052e2:	0800                	addi	s0,sp,16
    800052e4:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800052e6:	0035151b          	slliw	a0,a0,0x3
    800052ea:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    800052ec:	8b89                	andi	a5,a5,2
    800052ee:	c399                	beqz	a5,800052f4 <flags2perm+0x18>
      perm |= PTE_W;
    800052f0:	00456513          	ori	a0,a0,4
    return perm;
}
    800052f4:	60a2                	ld	ra,8(sp)
    800052f6:	6402                	ld	s0,0(sp)
    800052f8:	0141                	addi	sp,sp,16
    800052fa:	8082                	ret

00000000800052fc <exec>:

int
exec(char *path, char **argv)
{
    800052fc:	de010113          	addi	sp,sp,-544
    80005300:	20113c23          	sd	ra,536(sp)
    80005304:	20813823          	sd	s0,528(sp)
    80005308:	20913423          	sd	s1,520(sp)
    8000530c:	21213023          	sd	s2,512(sp)
    80005310:	1400                	addi	s0,sp,544
    80005312:	892a                	mv	s2,a0
    80005314:	dea43823          	sd	a0,-528(s0)
    80005318:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000531c:	ffffd097          	auipc	ra,0xffffd
    80005320:	a66080e7          	jalr	-1434(ra) # 80001d82 <myproc>
    80005324:	84aa                	mv	s1,a0

  begin_op();
    80005326:	fffff097          	auipc	ra,0xfffff
    8000532a:	3fc080e7          	jalr	1020(ra) # 80004722 <begin_op>

  if((ip = namei(path)) == 0){
    8000532e:	854a                	mv	a0,s2
    80005330:	fffff097          	auipc	ra,0xfffff
    80005334:	1ec080e7          	jalr	492(ra) # 8000451c <namei>
    80005338:	c525                	beqz	a0,800053a0 <exec+0xa4>
    8000533a:	fbd2                	sd	s4,496(sp)
    8000533c:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000533e:	fffff097          	auipc	ra,0xfffff
    80005342:	9fa080e7          	jalr	-1542(ra) # 80003d38 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80005346:	04000713          	li	a4,64
    8000534a:	4681                	li	a3,0
    8000534c:	e5040613          	addi	a2,s0,-432
    80005350:	4581                	li	a1,0
    80005352:	8552                	mv	a0,s4
    80005354:	fffff097          	auipc	ra,0xfffff
    80005358:	ca0080e7          	jalr	-864(ra) # 80003ff4 <readi>
    8000535c:	04000793          	li	a5,64
    80005360:	00f51a63          	bne	a0,a5,80005374 <exec+0x78>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80005364:	e5042703          	lw	a4,-432(s0)
    80005368:	464c47b7          	lui	a5,0x464c4
    8000536c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005370:	02f70e63          	beq	a4,a5,800053ac <exec+0xb0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80005374:	8552                	mv	a0,s4
    80005376:	fffff097          	auipc	ra,0xfffff
    8000537a:	c28080e7          	jalr	-984(ra) # 80003f9e <iunlockput>
    end_op();
    8000537e:	fffff097          	auipc	ra,0xfffff
    80005382:	41e080e7          	jalr	1054(ra) # 8000479c <end_op>
  }
  return -1;
    80005386:	557d                	li	a0,-1
    80005388:	7a5e                	ld	s4,496(sp)
}
    8000538a:	21813083          	ld	ra,536(sp)
    8000538e:	21013403          	ld	s0,528(sp)
    80005392:	20813483          	ld	s1,520(sp)
    80005396:	20013903          	ld	s2,512(sp)
    8000539a:	22010113          	addi	sp,sp,544
    8000539e:	8082                	ret
    end_op();
    800053a0:	fffff097          	auipc	ra,0xfffff
    800053a4:	3fc080e7          	jalr	1020(ra) # 8000479c <end_op>
    return -1;
    800053a8:	557d                	li	a0,-1
    800053aa:	b7c5                	j	8000538a <exec+0x8e>
    800053ac:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    800053ae:	8526                	mv	a0,s1
    800053b0:	ffffd097          	auipc	ra,0xffffd
    800053b4:	a96080e7          	jalr	-1386(ra) # 80001e46 <proc_pagetable>
    800053b8:	8b2a                	mv	s6,a0
    800053ba:	2c050163          	beqz	a0,8000567c <exec+0x380>
    800053be:	ffce                	sd	s3,504(sp)
    800053c0:	f7d6                	sd	s5,488(sp)
    800053c2:	efde                	sd	s7,472(sp)
    800053c4:	ebe2                	sd	s8,464(sp)
    800053c6:	e7e6                	sd	s9,456(sp)
    800053c8:	e3ea                	sd	s10,448(sp)
    800053ca:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800053cc:	e7042683          	lw	a3,-400(s0)
    800053d0:	e8845783          	lhu	a5,-376(s0)
    800053d4:	10078363          	beqz	a5,800054da <exec+0x1de>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800053d8:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800053da:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800053dc:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    800053e0:	6c85                	lui	s9,0x1
    800053e2:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800053e6:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800053ea:	6a85                	lui	s5,0x1
    800053ec:	a0b5                	j	80005458 <exec+0x15c>
      panic("loadseg: address should exist");
    800053ee:	00003517          	auipc	a0,0x3
    800053f2:	2ba50513          	addi	a0,a0,698 # 800086a8 <etext+0x6a8>
    800053f6:	ffffb097          	auipc	ra,0xffffb
    800053fa:	16a080e7          	jalr	362(ra) # 80000560 <panic>
    if(sz - i < PGSIZE)
    800053fe:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80005400:	874a                	mv	a4,s2
    80005402:	009c06bb          	addw	a3,s8,s1
    80005406:	4581                	li	a1,0
    80005408:	8552                	mv	a0,s4
    8000540a:	fffff097          	auipc	ra,0xfffff
    8000540e:	bea080e7          	jalr	-1046(ra) # 80003ff4 <readi>
    80005412:	26a91963          	bne	s2,a0,80005684 <exec+0x388>
  for(i = 0; i < sz; i += PGSIZE){
    80005416:	009a84bb          	addw	s1,s5,s1
    8000541a:	0334f463          	bgeu	s1,s3,80005442 <exec+0x146>
    pa = walkaddr(pagetable, va + i);
    8000541e:	02049593          	slli	a1,s1,0x20
    80005422:	9181                	srli	a1,a1,0x20
    80005424:	95de                	add	a1,a1,s7
    80005426:	855a                	mv	a0,s6
    80005428:	ffffc097          	auipc	ra,0xffffc
    8000542c:	cb0080e7          	jalr	-848(ra) # 800010d8 <walkaddr>
    80005430:	862a                	mv	a2,a0
    if(pa == 0)
    80005432:	dd55                	beqz	a0,800053ee <exec+0xf2>
    if(sz - i < PGSIZE)
    80005434:	409987bb          	subw	a5,s3,s1
    80005438:	893e                	mv	s2,a5
    8000543a:	fcfcf2e3          	bgeu	s9,a5,800053fe <exec+0x102>
    8000543e:	8956                	mv	s2,s5
    80005440:	bf7d                	j	800053fe <exec+0x102>
    sz = sz1;
    80005442:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005446:	2d05                	addiw	s10,s10,1
    80005448:	e0843783          	ld	a5,-504(s0)
    8000544c:	0387869b          	addiw	a3,a5,56
    80005450:	e8845783          	lhu	a5,-376(s0)
    80005454:	08fd5463          	bge	s10,a5,800054dc <exec+0x1e0>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005458:	e0d43423          	sd	a3,-504(s0)
    8000545c:	876e                	mv	a4,s11
    8000545e:	e1840613          	addi	a2,s0,-488
    80005462:	4581                	li	a1,0
    80005464:	8552                	mv	a0,s4
    80005466:	fffff097          	auipc	ra,0xfffff
    8000546a:	b8e080e7          	jalr	-1138(ra) # 80003ff4 <readi>
    8000546e:	21b51963          	bne	a0,s11,80005680 <exec+0x384>
    if(ph.type != ELF_PROG_LOAD)
    80005472:	e1842783          	lw	a5,-488(s0)
    80005476:	4705                	li	a4,1
    80005478:	fce797e3          	bne	a5,a4,80005446 <exec+0x14a>
    if(ph.memsz < ph.filesz)
    8000547c:	e4043483          	ld	s1,-448(s0)
    80005480:	e3843783          	ld	a5,-456(s0)
    80005484:	22f4e063          	bltu	s1,a5,800056a4 <exec+0x3a8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005488:	e2843783          	ld	a5,-472(s0)
    8000548c:	94be                	add	s1,s1,a5
    8000548e:	20f4ee63          	bltu	s1,a5,800056aa <exec+0x3ae>
    if(ph.vaddr % PGSIZE != 0)
    80005492:	de843703          	ld	a4,-536(s0)
    80005496:	8ff9                	and	a5,a5,a4
    80005498:	20079c63          	bnez	a5,800056b0 <exec+0x3b4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000549c:	e1c42503          	lw	a0,-484(s0)
    800054a0:	00000097          	auipc	ra,0x0
    800054a4:	e3c080e7          	jalr	-452(ra) # 800052dc <flags2perm>
    800054a8:	86aa                	mv	a3,a0
    800054aa:	8626                	mv	a2,s1
    800054ac:	85ca                	mv	a1,s2
    800054ae:	855a                	mv	a0,s6
    800054b0:	ffffc097          	auipc	ra,0xffffc
    800054b4:	fec080e7          	jalr	-20(ra) # 8000149c <uvmalloc>
    800054b8:	dea43c23          	sd	a0,-520(s0)
    800054bc:	1e050d63          	beqz	a0,800056b6 <exec+0x3ba>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800054c0:	e2843b83          	ld	s7,-472(s0)
    800054c4:	e2042c03          	lw	s8,-480(s0)
    800054c8:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800054cc:	00098463          	beqz	s3,800054d4 <exec+0x1d8>
    800054d0:	4481                	li	s1,0
    800054d2:	b7b1                	j	8000541e <exec+0x122>
    sz = sz1;
    800054d4:	df843903          	ld	s2,-520(s0)
    800054d8:	b7bd                	j	80005446 <exec+0x14a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800054da:	4901                	li	s2,0
  iunlockput(ip);
    800054dc:	8552                	mv	a0,s4
    800054de:	fffff097          	auipc	ra,0xfffff
    800054e2:	ac0080e7          	jalr	-1344(ra) # 80003f9e <iunlockput>
  end_op();
    800054e6:	fffff097          	auipc	ra,0xfffff
    800054ea:	2b6080e7          	jalr	694(ra) # 8000479c <end_op>
  p = myproc();
    800054ee:	ffffd097          	auipc	ra,0xffffd
    800054f2:	894080e7          	jalr	-1900(ra) # 80001d82 <myproc>
    800054f6:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800054f8:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800054fc:	6985                	lui	s3,0x1
    800054fe:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80005500:	99ca                	add	s3,s3,s2
    80005502:	77fd                	lui	a5,0xfffff
    80005504:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80005508:	4691                	li	a3,4
    8000550a:	6609                	lui	a2,0x2
    8000550c:	964e                	add	a2,a2,s3
    8000550e:	85ce                	mv	a1,s3
    80005510:	855a                	mv	a0,s6
    80005512:	ffffc097          	auipc	ra,0xffffc
    80005516:	f8a080e7          	jalr	-118(ra) # 8000149c <uvmalloc>
    8000551a:	8a2a                	mv	s4,a0
    8000551c:	e115                	bnez	a0,80005540 <exec+0x244>
    proc_freepagetable(pagetable, sz);
    8000551e:	85ce                	mv	a1,s3
    80005520:	855a                	mv	a0,s6
    80005522:	ffffd097          	auipc	ra,0xffffd
    80005526:	9c0080e7          	jalr	-1600(ra) # 80001ee2 <proc_freepagetable>
  return -1;
    8000552a:	557d                	li	a0,-1
    8000552c:	79fe                	ld	s3,504(sp)
    8000552e:	7a5e                	ld	s4,496(sp)
    80005530:	7abe                	ld	s5,488(sp)
    80005532:	7b1e                	ld	s6,480(sp)
    80005534:	6bfe                	ld	s7,472(sp)
    80005536:	6c5e                	ld	s8,464(sp)
    80005538:	6cbe                	ld	s9,456(sp)
    8000553a:	6d1e                	ld	s10,448(sp)
    8000553c:	7dfa                	ld	s11,440(sp)
    8000553e:	b5b1                	j	8000538a <exec+0x8e>
  uvmclear(pagetable, sz-2*PGSIZE);
    80005540:	75f9                	lui	a1,0xffffe
    80005542:	95aa                	add	a1,a1,a0
    80005544:	855a                	mv	a0,s6
    80005546:	ffffc097          	auipc	ra,0xffffc
    8000554a:	198080e7          	jalr	408(ra) # 800016de <uvmclear>
  stackbase = sp - PGSIZE;
    8000554e:	7bfd                	lui	s7,0xfffff
    80005550:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    80005552:	e0043783          	ld	a5,-512(s0)
    80005556:	6388                	ld	a0,0(a5)
  sp = sz;
    80005558:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    8000555a:	4481                	li	s1,0
    ustack[argc] = sp;
    8000555c:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80005560:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80005564:	c135                	beqz	a0,800055c8 <exec+0x2cc>
    sp -= strlen(argv[argc]) + 1;
    80005566:	ffffc097          	auipc	ra,0xffffc
    8000556a:	95c080e7          	jalr	-1700(ra) # 80000ec2 <strlen>
    8000556e:	0015079b          	addiw	a5,a0,1
    80005572:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005576:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000557a:	15796163          	bltu	s2,s7,800056bc <exec+0x3c0>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000557e:	e0043d83          	ld	s11,-512(s0)
    80005582:	000db983          	ld	s3,0(s11)
    80005586:	854e                	mv	a0,s3
    80005588:	ffffc097          	auipc	ra,0xffffc
    8000558c:	93a080e7          	jalr	-1734(ra) # 80000ec2 <strlen>
    80005590:	0015069b          	addiw	a3,a0,1
    80005594:	864e                	mv	a2,s3
    80005596:	85ca                	mv	a1,s2
    80005598:	855a                	mv	a0,s6
    8000559a:	ffffc097          	auipc	ra,0xffffc
    8000559e:	176080e7          	jalr	374(ra) # 80001710 <copyout>
    800055a2:	10054f63          	bltz	a0,800056c0 <exec+0x3c4>
    ustack[argc] = sp;
    800055a6:	00349793          	slli	a5,s1,0x3
    800055aa:	97e6                	add	a5,a5,s9
    800055ac:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffdc4e0>
  for(argc = 0; argv[argc]; argc++) {
    800055b0:	0485                	addi	s1,s1,1
    800055b2:	008d8793          	addi	a5,s11,8
    800055b6:	e0f43023          	sd	a5,-512(s0)
    800055ba:	008db503          	ld	a0,8(s11)
    800055be:	c509                	beqz	a0,800055c8 <exec+0x2cc>
    if(argc >= MAXARG)
    800055c0:	fb8493e3          	bne	s1,s8,80005566 <exec+0x26a>
  sz = sz1;
    800055c4:	89d2                	mv	s3,s4
    800055c6:	bfa1                	j	8000551e <exec+0x222>
  ustack[argc] = 0;
    800055c8:	00349793          	slli	a5,s1,0x3
    800055cc:	f9078793          	addi	a5,a5,-112
    800055d0:	97a2                	add	a5,a5,s0
    800055d2:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800055d6:	00148693          	addi	a3,s1,1
    800055da:	068e                	slli	a3,a3,0x3
    800055dc:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800055e0:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    800055e4:	89d2                	mv	s3,s4
  if(sp < stackbase)
    800055e6:	f3796ce3          	bltu	s2,s7,8000551e <exec+0x222>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800055ea:	e9040613          	addi	a2,s0,-368
    800055ee:	85ca                	mv	a1,s2
    800055f0:	855a                	mv	a0,s6
    800055f2:	ffffc097          	auipc	ra,0xffffc
    800055f6:	11e080e7          	jalr	286(ra) # 80001710 <copyout>
    800055fa:	f20542e3          	bltz	a0,8000551e <exec+0x222>
  p->trapframe->a1 = sp;
    800055fe:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80005602:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005606:	df043783          	ld	a5,-528(s0)
    8000560a:	0007c703          	lbu	a4,0(a5)
    8000560e:	cf11                	beqz	a4,8000562a <exec+0x32e>
    80005610:	0785                	addi	a5,a5,1
    if(*s == '/')
    80005612:	02f00693          	li	a3,47
    80005616:	a029                	j	80005620 <exec+0x324>
  for(last=s=path; *s; s++)
    80005618:	0785                	addi	a5,a5,1
    8000561a:	fff7c703          	lbu	a4,-1(a5)
    8000561e:	c711                	beqz	a4,8000562a <exec+0x32e>
    if(*s == '/')
    80005620:	fed71ce3          	bne	a4,a3,80005618 <exec+0x31c>
      last = s+1;
    80005624:	def43823          	sd	a5,-528(s0)
    80005628:	bfc5                	j	80005618 <exec+0x31c>
  safestrcpy(p->name, last, sizeof(p->name));
    8000562a:	4641                	li	a2,16
    8000562c:	df043583          	ld	a1,-528(s0)
    80005630:	158a8513          	addi	a0,s5,344
    80005634:	ffffc097          	auipc	ra,0xffffc
    80005638:	858080e7          	jalr	-1960(ra) # 80000e8c <safestrcpy>
  oldpagetable = p->pagetable;
    8000563c:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80005640:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80005644:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005648:	058ab783          	ld	a5,88(s5)
    8000564c:	e6843703          	ld	a4,-408(s0)
    80005650:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80005652:	058ab783          	ld	a5,88(s5)
    80005656:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000565a:	85ea                	mv	a1,s10
    8000565c:	ffffd097          	auipc	ra,0xffffd
    80005660:	886080e7          	jalr	-1914(ra) # 80001ee2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005664:	0004851b          	sext.w	a0,s1
    80005668:	79fe                	ld	s3,504(sp)
    8000566a:	7a5e                	ld	s4,496(sp)
    8000566c:	7abe                	ld	s5,488(sp)
    8000566e:	7b1e                	ld	s6,480(sp)
    80005670:	6bfe                	ld	s7,472(sp)
    80005672:	6c5e                	ld	s8,464(sp)
    80005674:	6cbe                	ld	s9,456(sp)
    80005676:	6d1e                	ld	s10,448(sp)
    80005678:	7dfa                	ld	s11,440(sp)
    8000567a:	bb01                	j	8000538a <exec+0x8e>
    8000567c:	7b1e                	ld	s6,480(sp)
    8000567e:	b9dd                	j	80005374 <exec+0x78>
    80005680:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80005684:	df843583          	ld	a1,-520(s0)
    80005688:	855a                	mv	a0,s6
    8000568a:	ffffd097          	auipc	ra,0xffffd
    8000568e:	858080e7          	jalr	-1960(ra) # 80001ee2 <proc_freepagetable>
  if(ip){
    80005692:	79fe                	ld	s3,504(sp)
    80005694:	7abe                	ld	s5,488(sp)
    80005696:	7b1e                	ld	s6,480(sp)
    80005698:	6bfe                	ld	s7,472(sp)
    8000569a:	6c5e                	ld	s8,464(sp)
    8000569c:	6cbe                	ld	s9,456(sp)
    8000569e:	6d1e                	ld	s10,448(sp)
    800056a0:	7dfa                	ld	s11,440(sp)
    800056a2:	b9c9                	j	80005374 <exec+0x78>
    800056a4:	df243c23          	sd	s2,-520(s0)
    800056a8:	bff1                	j	80005684 <exec+0x388>
    800056aa:	df243c23          	sd	s2,-520(s0)
    800056ae:	bfd9                	j	80005684 <exec+0x388>
    800056b0:	df243c23          	sd	s2,-520(s0)
    800056b4:	bfc1                	j	80005684 <exec+0x388>
    800056b6:	df243c23          	sd	s2,-520(s0)
    800056ba:	b7e9                	j	80005684 <exec+0x388>
  sz = sz1;
    800056bc:	89d2                	mv	s3,s4
    800056be:	b585                	j	8000551e <exec+0x222>
    800056c0:	89d2                	mv	s3,s4
    800056c2:	bdb1                	j	8000551e <exec+0x222>

00000000800056c4 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800056c4:	7179                	addi	sp,sp,-48
    800056c6:	f406                	sd	ra,40(sp)
    800056c8:	f022                	sd	s0,32(sp)
    800056ca:	ec26                	sd	s1,24(sp)
    800056cc:	e84a                	sd	s2,16(sp)
    800056ce:	1800                	addi	s0,sp,48
    800056d0:	892e                	mv	s2,a1
    800056d2:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800056d4:	fdc40593          	addi	a1,s0,-36
    800056d8:	ffffe097          	auipc	ra,0xffffe
    800056dc:	a58080e7          	jalr	-1448(ra) # 80003130 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800056e0:	fdc42703          	lw	a4,-36(s0)
    800056e4:	47bd                	li	a5,15
    800056e6:	02e7eb63          	bltu	a5,a4,8000571c <argfd+0x58>
    800056ea:	ffffc097          	auipc	ra,0xffffc
    800056ee:	698080e7          	jalr	1688(ra) # 80001d82 <myproc>
    800056f2:	fdc42703          	lw	a4,-36(s0)
    800056f6:	01a70793          	addi	a5,a4,26
    800056fa:	078e                	slli	a5,a5,0x3
    800056fc:	953e                	add	a0,a0,a5
    800056fe:	611c                	ld	a5,0(a0)
    80005700:	c385                	beqz	a5,80005720 <argfd+0x5c>
    return -1;
  if(pfd)
    80005702:	00090463          	beqz	s2,8000570a <argfd+0x46>
    *pfd = fd;
    80005706:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000570a:	4501                	li	a0,0
  if(pf)
    8000570c:	c091                	beqz	s1,80005710 <argfd+0x4c>
    *pf = f;
    8000570e:	e09c                	sd	a5,0(s1)
}
    80005710:	70a2                	ld	ra,40(sp)
    80005712:	7402                	ld	s0,32(sp)
    80005714:	64e2                	ld	s1,24(sp)
    80005716:	6942                	ld	s2,16(sp)
    80005718:	6145                	addi	sp,sp,48
    8000571a:	8082                	ret
    return -1;
    8000571c:	557d                	li	a0,-1
    8000571e:	bfcd                	j	80005710 <argfd+0x4c>
    80005720:	557d                	li	a0,-1
    80005722:	b7fd                	j	80005710 <argfd+0x4c>

0000000080005724 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005724:	1101                	addi	sp,sp,-32
    80005726:	ec06                	sd	ra,24(sp)
    80005728:	e822                	sd	s0,16(sp)
    8000572a:	e426                	sd	s1,8(sp)
    8000572c:	1000                	addi	s0,sp,32
    8000572e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005730:	ffffc097          	auipc	ra,0xffffc
    80005734:	652080e7          	jalr	1618(ra) # 80001d82 <myproc>
    80005738:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000573a:	0d050793          	addi	a5,a0,208
    8000573e:	4501                	li	a0,0
    80005740:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005742:	6398                	ld	a4,0(a5)
    80005744:	cb19                	beqz	a4,8000575a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005746:	2505                	addiw	a0,a0,1
    80005748:	07a1                	addi	a5,a5,8
    8000574a:	fed51ce3          	bne	a0,a3,80005742 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000574e:	557d                	li	a0,-1
}
    80005750:	60e2                	ld	ra,24(sp)
    80005752:	6442                	ld	s0,16(sp)
    80005754:	64a2                	ld	s1,8(sp)
    80005756:	6105                	addi	sp,sp,32
    80005758:	8082                	ret
      p->ofile[fd] = f;
    8000575a:	01a50793          	addi	a5,a0,26
    8000575e:	078e                	slli	a5,a5,0x3
    80005760:	963e                	add	a2,a2,a5
    80005762:	e204                	sd	s1,0(a2)
      return fd;
    80005764:	b7f5                	j	80005750 <fdalloc+0x2c>

0000000080005766 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005766:	715d                	addi	sp,sp,-80
    80005768:	e486                	sd	ra,72(sp)
    8000576a:	e0a2                	sd	s0,64(sp)
    8000576c:	fc26                	sd	s1,56(sp)
    8000576e:	f84a                	sd	s2,48(sp)
    80005770:	f44e                	sd	s3,40(sp)
    80005772:	ec56                	sd	s5,24(sp)
    80005774:	e85a                	sd	s6,16(sp)
    80005776:	0880                	addi	s0,sp,80
    80005778:	8b2e                	mv	s6,a1
    8000577a:	89b2                	mv	s3,a2
    8000577c:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000577e:	fb040593          	addi	a1,s0,-80
    80005782:	fffff097          	auipc	ra,0xfffff
    80005786:	db8080e7          	jalr	-584(ra) # 8000453a <nameiparent>
    8000578a:	84aa                	mv	s1,a0
    8000578c:	14050e63          	beqz	a0,800058e8 <create+0x182>
    return 0;

  ilock(dp);
    80005790:	ffffe097          	auipc	ra,0xffffe
    80005794:	5a8080e7          	jalr	1448(ra) # 80003d38 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005798:	4601                	li	a2,0
    8000579a:	fb040593          	addi	a1,s0,-80
    8000579e:	8526                	mv	a0,s1
    800057a0:	fffff097          	auipc	ra,0xfffff
    800057a4:	a94080e7          	jalr	-1388(ra) # 80004234 <dirlookup>
    800057a8:	8aaa                	mv	s5,a0
    800057aa:	c539                	beqz	a0,800057f8 <create+0x92>
    iunlockput(dp);
    800057ac:	8526                	mv	a0,s1
    800057ae:	ffffe097          	auipc	ra,0xffffe
    800057b2:	7f0080e7          	jalr	2032(ra) # 80003f9e <iunlockput>
    ilock(ip);
    800057b6:	8556                	mv	a0,s5
    800057b8:	ffffe097          	auipc	ra,0xffffe
    800057bc:	580080e7          	jalr	1408(ra) # 80003d38 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800057c0:	4789                	li	a5,2
    800057c2:	02fb1463          	bne	s6,a5,800057ea <create+0x84>
    800057c6:	044ad783          	lhu	a5,68(s5)
    800057ca:	37f9                	addiw	a5,a5,-2
    800057cc:	17c2                	slli	a5,a5,0x30
    800057ce:	93c1                	srli	a5,a5,0x30
    800057d0:	4705                	li	a4,1
    800057d2:	00f76c63          	bltu	a4,a5,800057ea <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800057d6:	8556                	mv	a0,s5
    800057d8:	60a6                	ld	ra,72(sp)
    800057da:	6406                	ld	s0,64(sp)
    800057dc:	74e2                	ld	s1,56(sp)
    800057de:	7942                	ld	s2,48(sp)
    800057e0:	79a2                	ld	s3,40(sp)
    800057e2:	6ae2                	ld	s5,24(sp)
    800057e4:	6b42                	ld	s6,16(sp)
    800057e6:	6161                	addi	sp,sp,80
    800057e8:	8082                	ret
    iunlockput(ip);
    800057ea:	8556                	mv	a0,s5
    800057ec:	ffffe097          	auipc	ra,0xffffe
    800057f0:	7b2080e7          	jalr	1970(ra) # 80003f9e <iunlockput>
    return 0;
    800057f4:	4a81                	li	s5,0
    800057f6:	b7c5                	j	800057d6 <create+0x70>
    800057f8:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    800057fa:	85da                	mv	a1,s6
    800057fc:	4088                	lw	a0,0(s1)
    800057fe:	ffffe097          	auipc	ra,0xffffe
    80005802:	396080e7          	jalr	918(ra) # 80003b94 <ialloc>
    80005806:	8a2a                	mv	s4,a0
    80005808:	c531                	beqz	a0,80005854 <create+0xee>
  ilock(ip);
    8000580a:	ffffe097          	auipc	ra,0xffffe
    8000580e:	52e080e7          	jalr	1326(ra) # 80003d38 <ilock>
  ip->major = major;
    80005812:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80005816:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000581a:	4905                	li	s2,1
    8000581c:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80005820:	8552                	mv	a0,s4
    80005822:	ffffe097          	auipc	ra,0xffffe
    80005826:	44a080e7          	jalr	1098(ra) # 80003c6c <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000582a:	032b0d63          	beq	s6,s2,80005864 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    8000582e:	004a2603          	lw	a2,4(s4)
    80005832:	fb040593          	addi	a1,s0,-80
    80005836:	8526                	mv	a0,s1
    80005838:	fffff097          	auipc	ra,0xfffff
    8000583c:	c22080e7          	jalr	-990(ra) # 8000445a <dirlink>
    80005840:	08054163          	bltz	a0,800058c2 <create+0x15c>
  iunlockput(dp);
    80005844:	8526                	mv	a0,s1
    80005846:	ffffe097          	auipc	ra,0xffffe
    8000584a:	758080e7          	jalr	1880(ra) # 80003f9e <iunlockput>
  return ip;
    8000584e:	8ad2                	mv	s5,s4
    80005850:	7a02                	ld	s4,32(sp)
    80005852:	b751                	j	800057d6 <create+0x70>
    iunlockput(dp);
    80005854:	8526                	mv	a0,s1
    80005856:	ffffe097          	auipc	ra,0xffffe
    8000585a:	748080e7          	jalr	1864(ra) # 80003f9e <iunlockput>
    return 0;
    8000585e:	8ad2                	mv	s5,s4
    80005860:	7a02                	ld	s4,32(sp)
    80005862:	bf95                	j	800057d6 <create+0x70>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005864:	004a2603          	lw	a2,4(s4)
    80005868:	00003597          	auipc	a1,0x3
    8000586c:	e6058593          	addi	a1,a1,-416 # 800086c8 <etext+0x6c8>
    80005870:	8552                	mv	a0,s4
    80005872:	fffff097          	auipc	ra,0xfffff
    80005876:	be8080e7          	jalr	-1048(ra) # 8000445a <dirlink>
    8000587a:	04054463          	bltz	a0,800058c2 <create+0x15c>
    8000587e:	40d0                	lw	a2,4(s1)
    80005880:	00003597          	auipc	a1,0x3
    80005884:	e5058593          	addi	a1,a1,-432 # 800086d0 <etext+0x6d0>
    80005888:	8552                	mv	a0,s4
    8000588a:	fffff097          	auipc	ra,0xfffff
    8000588e:	bd0080e7          	jalr	-1072(ra) # 8000445a <dirlink>
    80005892:	02054863          	bltz	a0,800058c2 <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    80005896:	004a2603          	lw	a2,4(s4)
    8000589a:	fb040593          	addi	a1,s0,-80
    8000589e:	8526                	mv	a0,s1
    800058a0:	fffff097          	auipc	ra,0xfffff
    800058a4:	bba080e7          	jalr	-1094(ra) # 8000445a <dirlink>
    800058a8:	00054d63          	bltz	a0,800058c2 <create+0x15c>
    dp->nlink++;  // for ".."
    800058ac:	04a4d783          	lhu	a5,74(s1)
    800058b0:	2785                	addiw	a5,a5,1
    800058b2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800058b6:	8526                	mv	a0,s1
    800058b8:	ffffe097          	auipc	ra,0xffffe
    800058bc:	3b4080e7          	jalr	948(ra) # 80003c6c <iupdate>
    800058c0:	b751                	j	80005844 <create+0xde>
  ip->nlink = 0;
    800058c2:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800058c6:	8552                	mv	a0,s4
    800058c8:	ffffe097          	auipc	ra,0xffffe
    800058cc:	3a4080e7          	jalr	932(ra) # 80003c6c <iupdate>
  iunlockput(ip);
    800058d0:	8552                	mv	a0,s4
    800058d2:	ffffe097          	auipc	ra,0xffffe
    800058d6:	6cc080e7          	jalr	1740(ra) # 80003f9e <iunlockput>
  iunlockput(dp);
    800058da:	8526                	mv	a0,s1
    800058dc:	ffffe097          	auipc	ra,0xffffe
    800058e0:	6c2080e7          	jalr	1730(ra) # 80003f9e <iunlockput>
  return 0;
    800058e4:	7a02                	ld	s4,32(sp)
    800058e6:	bdc5                	j	800057d6 <create+0x70>
    return 0;
    800058e8:	8aaa                	mv	s5,a0
    800058ea:	b5f5                	j	800057d6 <create+0x70>

00000000800058ec <sys_dup>:
{
    800058ec:	7179                	addi	sp,sp,-48
    800058ee:	f406                	sd	ra,40(sp)
    800058f0:	f022                	sd	s0,32(sp)
    800058f2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800058f4:	fd840613          	addi	a2,s0,-40
    800058f8:	4581                	li	a1,0
    800058fa:	4501                	li	a0,0
    800058fc:	00000097          	auipc	ra,0x0
    80005900:	dc8080e7          	jalr	-568(ra) # 800056c4 <argfd>
    return -1;
    80005904:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005906:	02054763          	bltz	a0,80005934 <sys_dup+0x48>
    8000590a:	ec26                	sd	s1,24(sp)
    8000590c:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    8000590e:	fd843903          	ld	s2,-40(s0)
    80005912:	854a                	mv	a0,s2
    80005914:	00000097          	auipc	ra,0x0
    80005918:	e10080e7          	jalr	-496(ra) # 80005724 <fdalloc>
    8000591c:	84aa                	mv	s1,a0
    return -1;
    8000591e:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005920:	00054f63          	bltz	a0,8000593e <sys_dup+0x52>
  filedup(f);
    80005924:	854a                	mv	a0,s2
    80005926:	fffff097          	auipc	ra,0xfffff
    8000592a:	27a080e7          	jalr	634(ra) # 80004ba0 <filedup>
  return fd;
    8000592e:	87a6                	mv	a5,s1
    80005930:	64e2                	ld	s1,24(sp)
    80005932:	6942                	ld	s2,16(sp)
}
    80005934:	853e                	mv	a0,a5
    80005936:	70a2                	ld	ra,40(sp)
    80005938:	7402                	ld	s0,32(sp)
    8000593a:	6145                	addi	sp,sp,48
    8000593c:	8082                	ret
    8000593e:	64e2                	ld	s1,24(sp)
    80005940:	6942                	ld	s2,16(sp)
    80005942:	bfcd                	j	80005934 <sys_dup+0x48>

0000000080005944 <sys_read>:
{
    80005944:	7179                	addi	sp,sp,-48
    80005946:	f406                	sd	ra,40(sp)
    80005948:	f022                	sd	s0,32(sp)
    8000594a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000594c:	fd840593          	addi	a1,s0,-40
    80005950:	4505                	li	a0,1
    80005952:	ffffd097          	auipc	ra,0xffffd
    80005956:	7fe080e7          	jalr	2046(ra) # 80003150 <argaddr>
  argint(2, &n);
    8000595a:	fe440593          	addi	a1,s0,-28
    8000595e:	4509                	li	a0,2
    80005960:	ffffd097          	auipc	ra,0xffffd
    80005964:	7d0080e7          	jalr	2000(ra) # 80003130 <argint>
  if(argfd(0, 0, &f) < 0)
    80005968:	fe840613          	addi	a2,s0,-24
    8000596c:	4581                	li	a1,0
    8000596e:	4501                	li	a0,0
    80005970:	00000097          	auipc	ra,0x0
    80005974:	d54080e7          	jalr	-684(ra) # 800056c4 <argfd>
    80005978:	87aa                	mv	a5,a0
    return -1;
    8000597a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000597c:	0007cc63          	bltz	a5,80005994 <sys_read+0x50>
  return fileread(f, p, n);
    80005980:	fe442603          	lw	a2,-28(s0)
    80005984:	fd843583          	ld	a1,-40(s0)
    80005988:	fe843503          	ld	a0,-24(s0)
    8000598c:	fffff097          	auipc	ra,0xfffff
    80005990:	3ba080e7          	jalr	954(ra) # 80004d46 <fileread>
}
    80005994:	70a2                	ld	ra,40(sp)
    80005996:	7402                	ld	s0,32(sp)
    80005998:	6145                	addi	sp,sp,48
    8000599a:	8082                	ret

000000008000599c <sys_write>:
{
    8000599c:	7179                	addi	sp,sp,-48
    8000599e:	f406                	sd	ra,40(sp)
    800059a0:	f022                	sd	s0,32(sp)
    800059a2:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800059a4:	fd840593          	addi	a1,s0,-40
    800059a8:	4505                	li	a0,1
    800059aa:	ffffd097          	auipc	ra,0xffffd
    800059ae:	7a6080e7          	jalr	1958(ra) # 80003150 <argaddr>
  argint(2, &n);
    800059b2:	fe440593          	addi	a1,s0,-28
    800059b6:	4509                	li	a0,2
    800059b8:	ffffd097          	auipc	ra,0xffffd
    800059bc:	778080e7          	jalr	1912(ra) # 80003130 <argint>
  if(argfd(0, 0, &f) < 0)
    800059c0:	fe840613          	addi	a2,s0,-24
    800059c4:	4581                	li	a1,0
    800059c6:	4501                	li	a0,0
    800059c8:	00000097          	auipc	ra,0x0
    800059cc:	cfc080e7          	jalr	-772(ra) # 800056c4 <argfd>
    800059d0:	87aa                	mv	a5,a0
    return -1;
    800059d2:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800059d4:	0007cc63          	bltz	a5,800059ec <sys_write+0x50>
  return filewrite(f, p, n);
    800059d8:	fe442603          	lw	a2,-28(s0)
    800059dc:	fd843583          	ld	a1,-40(s0)
    800059e0:	fe843503          	ld	a0,-24(s0)
    800059e4:	fffff097          	auipc	ra,0xfffff
    800059e8:	434080e7          	jalr	1076(ra) # 80004e18 <filewrite>
}
    800059ec:	70a2                	ld	ra,40(sp)
    800059ee:	7402                	ld	s0,32(sp)
    800059f0:	6145                	addi	sp,sp,48
    800059f2:	8082                	ret

00000000800059f4 <sys_close>:
{
    800059f4:	1101                	addi	sp,sp,-32
    800059f6:	ec06                	sd	ra,24(sp)
    800059f8:	e822                	sd	s0,16(sp)
    800059fa:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800059fc:	fe040613          	addi	a2,s0,-32
    80005a00:	fec40593          	addi	a1,s0,-20
    80005a04:	4501                	li	a0,0
    80005a06:	00000097          	auipc	ra,0x0
    80005a0a:	cbe080e7          	jalr	-834(ra) # 800056c4 <argfd>
    return -1;
    80005a0e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005a10:	02054463          	bltz	a0,80005a38 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005a14:	ffffc097          	auipc	ra,0xffffc
    80005a18:	36e080e7          	jalr	878(ra) # 80001d82 <myproc>
    80005a1c:	fec42783          	lw	a5,-20(s0)
    80005a20:	07e9                	addi	a5,a5,26
    80005a22:	078e                	slli	a5,a5,0x3
    80005a24:	953e                	add	a0,a0,a5
    80005a26:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80005a2a:	fe043503          	ld	a0,-32(s0)
    80005a2e:	fffff097          	auipc	ra,0xfffff
    80005a32:	1c4080e7          	jalr	452(ra) # 80004bf2 <fileclose>
  return 0;
    80005a36:	4781                	li	a5,0
}
    80005a38:	853e                	mv	a0,a5
    80005a3a:	60e2                	ld	ra,24(sp)
    80005a3c:	6442                	ld	s0,16(sp)
    80005a3e:	6105                	addi	sp,sp,32
    80005a40:	8082                	ret

0000000080005a42 <sys_fstat>:
{
    80005a42:	1101                	addi	sp,sp,-32
    80005a44:	ec06                	sd	ra,24(sp)
    80005a46:	e822                	sd	s0,16(sp)
    80005a48:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005a4a:	fe040593          	addi	a1,s0,-32
    80005a4e:	4505                	li	a0,1
    80005a50:	ffffd097          	auipc	ra,0xffffd
    80005a54:	700080e7          	jalr	1792(ra) # 80003150 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005a58:	fe840613          	addi	a2,s0,-24
    80005a5c:	4581                	li	a1,0
    80005a5e:	4501                	li	a0,0
    80005a60:	00000097          	auipc	ra,0x0
    80005a64:	c64080e7          	jalr	-924(ra) # 800056c4 <argfd>
    80005a68:	87aa                	mv	a5,a0
    return -1;
    80005a6a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005a6c:	0007ca63          	bltz	a5,80005a80 <sys_fstat+0x3e>
  return filestat(f, st);
    80005a70:	fe043583          	ld	a1,-32(s0)
    80005a74:	fe843503          	ld	a0,-24(s0)
    80005a78:	fffff097          	auipc	ra,0xfffff
    80005a7c:	258080e7          	jalr	600(ra) # 80004cd0 <filestat>
}
    80005a80:	60e2                	ld	ra,24(sp)
    80005a82:	6442                	ld	s0,16(sp)
    80005a84:	6105                	addi	sp,sp,32
    80005a86:	8082                	ret

0000000080005a88 <sys_link>:
{
    80005a88:	7169                	addi	sp,sp,-304
    80005a8a:	f606                	sd	ra,296(sp)
    80005a8c:	f222                	sd	s0,288(sp)
    80005a8e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005a90:	08000613          	li	a2,128
    80005a94:	ed040593          	addi	a1,s0,-304
    80005a98:	4501                	li	a0,0
    80005a9a:	ffffd097          	auipc	ra,0xffffd
    80005a9e:	6d6080e7          	jalr	1750(ra) # 80003170 <argstr>
    return -1;
    80005aa2:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005aa4:	12054663          	bltz	a0,80005bd0 <sys_link+0x148>
    80005aa8:	08000613          	li	a2,128
    80005aac:	f5040593          	addi	a1,s0,-176
    80005ab0:	4505                	li	a0,1
    80005ab2:	ffffd097          	auipc	ra,0xffffd
    80005ab6:	6be080e7          	jalr	1726(ra) # 80003170 <argstr>
    return -1;
    80005aba:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005abc:	10054a63          	bltz	a0,80005bd0 <sys_link+0x148>
    80005ac0:	ee26                	sd	s1,280(sp)
  begin_op();
    80005ac2:	fffff097          	auipc	ra,0xfffff
    80005ac6:	c60080e7          	jalr	-928(ra) # 80004722 <begin_op>
  if((ip = namei(old)) == 0){
    80005aca:	ed040513          	addi	a0,s0,-304
    80005ace:	fffff097          	auipc	ra,0xfffff
    80005ad2:	a4e080e7          	jalr	-1458(ra) # 8000451c <namei>
    80005ad6:	84aa                	mv	s1,a0
    80005ad8:	c949                	beqz	a0,80005b6a <sys_link+0xe2>
  ilock(ip);
    80005ada:	ffffe097          	auipc	ra,0xffffe
    80005ade:	25e080e7          	jalr	606(ra) # 80003d38 <ilock>
  if(ip->type == T_DIR){
    80005ae2:	04449703          	lh	a4,68(s1)
    80005ae6:	4785                	li	a5,1
    80005ae8:	08f70863          	beq	a4,a5,80005b78 <sys_link+0xf0>
    80005aec:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80005aee:	04a4d783          	lhu	a5,74(s1)
    80005af2:	2785                	addiw	a5,a5,1
    80005af4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005af8:	8526                	mv	a0,s1
    80005afa:	ffffe097          	auipc	ra,0xffffe
    80005afe:	172080e7          	jalr	370(ra) # 80003c6c <iupdate>
  iunlock(ip);
    80005b02:	8526                	mv	a0,s1
    80005b04:	ffffe097          	auipc	ra,0xffffe
    80005b08:	2fa080e7          	jalr	762(ra) # 80003dfe <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005b0c:	fd040593          	addi	a1,s0,-48
    80005b10:	f5040513          	addi	a0,s0,-176
    80005b14:	fffff097          	auipc	ra,0xfffff
    80005b18:	a26080e7          	jalr	-1498(ra) # 8000453a <nameiparent>
    80005b1c:	892a                	mv	s2,a0
    80005b1e:	cd35                	beqz	a0,80005b9a <sys_link+0x112>
  ilock(dp);
    80005b20:	ffffe097          	auipc	ra,0xffffe
    80005b24:	218080e7          	jalr	536(ra) # 80003d38 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005b28:	00092703          	lw	a4,0(s2)
    80005b2c:	409c                	lw	a5,0(s1)
    80005b2e:	06f71163          	bne	a4,a5,80005b90 <sys_link+0x108>
    80005b32:	40d0                	lw	a2,4(s1)
    80005b34:	fd040593          	addi	a1,s0,-48
    80005b38:	854a                	mv	a0,s2
    80005b3a:	fffff097          	auipc	ra,0xfffff
    80005b3e:	920080e7          	jalr	-1760(ra) # 8000445a <dirlink>
    80005b42:	04054763          	bltz	a0,80005b90 <sys_link+0x108>
  iunlockput(dp);
    80005b46:	854a                	mv	a0,s2
    80005b48:	ffffe097          	auipc	ra,0xffffe
    80005b4c:	456080e7          	jalr	1110(ra) # 80003f9e <iunlockput>
  iput(ip);
    80005b50:	8526                	mv	a0,s1
    80005b52:	ffffe097          	auipc	ra,0xffffe
    80005b56:	3a4080e7          	jalr	932(ra) # 80003ef6 <iput>
  end_op();
    80005b5a:	fffff097          	auipc	ra,0xfffff
    80005b5e:	c42080e7          	jalr	-958(ra) # 8000479c <end_op>
  return 0;
    80005b62:	4781                	li	a5,0
    80005b64:	64f2                	ld	s1,280(sp)
    80005b66:	6952                	ld	s2,272(sp)
    80005b68:	a0a5                	j	80005bd0 <sys_link+0x148>
    end_op();
    80005b6a:	fffff097          	auipc	ra,0xfffff
    80005b6e:	c32080e7          	jalr	-974(ra) # 8000479c <end_op>
    return -1;
    80005b72:	57fd                	li	a5,-1
    80005b74:	64f2                	ld	s1,280(sp)
    80005b76:	a8a9                	j	80005bd0 <sys_link+0x148>
    iunlockput(ip);
    80005b78:	8526                	mv	a0,s1
    80005b7a:	ffffe097          	auipc	ra,0xffffe
    80005b7e:	424080e7          	jalr	1060(ra) # 80003f9e <iunlockput>
    end_op();
    80005b82:	fffff097          	auipc	ra,0xfffff
    80005b86:	c1a080e7          	jalr	-998(ra) # 8000479c <end_op>
    return -1;
    80005b8a:	57fd                	li	a5,-1
    80005b8c:	64f2                	ld	s1,280(sp)
    80005b8e:	a089                	j	80005bd0 <sys_link+0x148>
    iunlockput(dp);
    80005b90:	854a                	mv	a0,s2
    80005b92:	ffffe097          	auipc	ra,0xffffe
    80005b96:	40c080e7          	jalr	1036(ra) # 80003f9e <iunlockput>
  ilock(ip);
    80005b9a:	8526                	mv	a0,s1
    80005b9c:	ffffe097          	auipc	ra,0xffffe
    80005ba0:	19c080e7          	jalr	412(ra) # 80003d38 <ilock>
  ip->nlink--;
    80005ba4:	04a4d783          	lhu	a5,74(s1)
    80005ba8:	37fd                	addiw	a5,a5,-1
    80005baa:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005bae:	8526                	mv	a0,s1
    80005bb0:	ffffe097          	auipc	ra,0xffffe
    80005bb4:	0bc080e7          	jalr	188(ra) # 80003c6c <iupdate>
  iunlockput(ip);
    80005bb8:	8526                	mv	a0,s1
    80005bba:	ffffe097          	auipc	ra,0xffffe
    80005bbe:	3e4080e7          	jalr	996(ra) # 80003f9e <iunlockput>
  end_op();
    80005bc2:	fffff097          	auipc	ra,0xfffff
    80005bc6:	bda080e7          	jalr	-1062(ra) # 8000479c <end_op>
  return -1;
    80005bca:	57fd                	li	a5,-1
    80005bcc:	64f2                	ld	s1,280(sp)
    80005bce:	6952                	ld	s2,272(sp)
}
    80005bd0:	853e                	mv	a0,a5
    80005bd2:	70b2                	ld	ra,296(sp)
    80005bd4:	7412                	ld	s0,288(sp)
    80005bd6:	6155                	addi	sp,sp,304
    80005bd8:	8082                	ret

0000000080005bda <sys_unlink>:
{
    80005bda:	7111                	addi	sp,sp,-256
    80005bdc:	fd86                	sd	ra,248(sp)
    80005bde:	f9a2                	sd	s0,240(sp)
    80005be0:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    80005be2:	08000613          	li	a2,128
    80005be6:	f2040593          	addi	a1,s0,-224
    80005bea:	4501                	li	a0,0
    80005bec:	ffffd097          	auipc	ra,0xffffd
    80005bf0:	584080e7          	jalr	1412(ra) # 80003170 <argstr>
    80005bf4:	1c054063          	bltz	a0,80005db4 <sys_unlink+0x1da>
    80005bf8:	f5a6                	sd	s1,232(sp)
  begin_op();
    80005bfa:	fffff097          	auipc	ra,0xfffff
    80005bfe:	b28080e7          	jalr	-1240(ra) # 80004722 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005c02:	fa040593          	addi	a1,s0,-96
    80005c06:	f2040513          	addi	a0,s0,-224
    80005c0a:	fffff097          	auipc	ra,0xfffff
    80005c0e:	930080e7          	jalr	-1744(ra) # 8000453a <nameiparent>
    80005c12:	84aa                	mv	s1,a0
    80005c14:	c165                	beqz	a0,80005cf4 <sys_unlink+0x11a>
  ilock(dp);
    80005c16:	ffffe097          	auipc	ra,0xffffe
    80005c1a:	122080e7          	jalr	290(ra) # 80003d38 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005c1e:	00003597          	auipc	a1,0x3
    80005c22:	aaa58593          	addi	a1,a1,-1366 # 800086c8 <etext+0x6c8>
    80005c26:	fa040513          	addi	a0,s0,-96
    80005c2a:	ffffe097          	auipc	ra,0xffffe
    80005c2e:	5f0080e7          	jalr	1520(ra) # 8000421a <namecmp>
    80005c32:	16050263          	beqz	a0,80005d96 <sys_unlink+0x1bc>
    80005c36:	00003597          	auipc	a1,0x3
    80005c3a:	a9a58593          	addi	a1,a1,-1382 # 800086d0 <etext+0x6d0>
    80005c3e:	fa040513          	addi	a0,s0,-96
    80005c42:	ffffe097          	auipc	ra,0xffffe
    80005c46:	5d8080e7          	jalr	1496(ra) # 8000421a <namecmp>
    80005c4a:	14050663          	beqz	a0,80005d96 <sys_unlink+0x1bc>
    80005c4e:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005c50:	f1c40613          	addi	a2,s0,-228
    80005c54:	fa040593          	addi	a1,s0,-96
    80005c58:	8526                	mv	a0,s1
    80005c5a:	ffffe097          	auipc	ra,0xffffe
    80005c5e:	5da080e7          	jalr	1498(ra) # 80004234 <dirlookup>
    80005c62:	892a                	mv	s2,a0
    80005c64:	12050863          	beqz	a0,80005d94 <sys_unlink+0x1ba>
    80005c68:	edce                	sd	s3,216(sp)
  ilock(ip);
    80005c6a:	ffffe097          	auipc	ra,0xffffe
    80005c6e:	0ce080e7          	jalr	206(ra) # 80003d38 <ilock>
  if(ip->nlink < 1)
    80005c72:	04a91783          	lh	a5,74(s2)
    80005c76:	08f05663          	blez	a5,80005d02 <sys_unlink+0x128>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005c7a:	04491703          	lh	a4,68(s2)
    80005c7e:	4785                	li	a5,1
    80005c80:	08f70b63          	beq	a4,a5,80005d16 <sys_unlink+0x13c>
  memset(&de, 0, sizeof(de));
    80005c84:	fb040993          	addi	s3,s0,-80
    80005c88:	4641                	li	a2,16
    80005c8a:	4581                	li	a1,0
    80005c8c:	854e                	mv	a0,s3
    80005c8e:	ffffb097          	auipc	ra,0xffffb
    80005c92:	0a8080e7          	jalr	168(ra) # 80000d36 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005c96:	4741                	li	a4,16
    80005c98:	f1c42683          	lw	a3,-228(s0)
    80005c9c:	864e                	mv	a2,s3
    80005c9e:	4581                	li	a1,0
    80005ca0:	8526                	mv	a0,s1
    80005ca2:	ffffe097          	auipc	ra,0xffffe
    80005ca6:	458080e7          	jalr	1112(ra) # 800040fa <writei>
    80005caa:	47c1                	li	a5,16
    80005cac:	0af51f63          	bne	a0,a5,80005d6a <sys_unlink+0x190>
  if(ip->type == T_DIR){
    80005cb0:	04491703          	lh	a4,68(s2)
    80005cb4:	4785                	li	a5,1
    80005cb6:	0cf70463          	beq	a4,a5,80005d7e <sys_unlink+0x1a4>
  iunlockput(dp);
    80005cba:	8526                	mv	a0,s1
    80005cbc:	ffffe097          	auipc	ra,0xffffe
    80005cc0:	2e2080e7          	jalr	738(ra) # 80003f9e <iunlockput>
  ip->nlink--;
    80005cc4:	04a95783          	lhu	a5,74(s2)
    80005cc8:	37fd                	addiw	a5,a5,-1
    80005cca:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005cce:	854a                	mv	a0,s2
    80005cd0:	ffffe097          	auipc	ra,0xffffe
    80005cd4:	f9c080e7          	jalr	-100(ra) # 80003c6c <iupdate>
  iunlockput(ip);
    80005cd8:	854a                	mv	a0,s2
    80005cda:	ffffe097          	auipc	ra,0xffffe
    80005cde:	2c4080e7          	jalr	708(ra) # 80003f9e <iunlockput>
  end_op();
    80005ce2:	fffff097          	auipc	ra,0xfffff
    80005ce6:	aba080e7          	jalr	-1350(ra) # 8000479c <end_op>
  return 0;
    80005cea:	4501                	li	a0,0
    80005cec:	74ae                	ld	s1,232(sp)
    80005cee:	790e                	ld	s2,224(sp)
    80005cf0:	69ee                	ld	s3,216(sp)
    80005cf2:	a86d                	j	80005dac <sys_unlink+0x1d2>
    end_op();
    80005cf4:	fffff097          	auipc	ra,0xfffff
    80005cf8:	aa8080e7          	jalr	-1368(ra) # 8000479c <end_op>
    return -1;
    80005cfc:	557d                	li	a0,-1
    80005cfe:	74ae                	ld	s1,232(sp)
    80005d00:	a075                	j	80005dac <sys_unlink+0x1d2>
    80005d02:	e9d2                	sd	s4,208(sp)
    80005d04:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    80005d06:	00003517          	auipc	a0,0x3
    80005d0a:	9d250513          	addi	a0,a0,-1582 # 800086d8 <etext+0x6d8>
    80005d0e:	ffffb097          	auipc	ra,0xffffb
    80005d12:	852080e7          	jalr	-1966(ra) # 80000560 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005d16:	04c92703          	lw	a4,76(s2)
    80005d1a:	02000793          	li	a5,32
    80005d1e:	f6e7f3e3          	bgeu	a5,a4,80005c84 <sys_unlink+0xaa>
    80005d22:	e9d2                	sd	s4,208(sp)
    80005d24:	e5d6                	sd	s5,200(sp)
    80005d26:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005d28:	f0840a93          	addi	s5,s0,-248
    80005d2c:	4a41                	li	s4,16
    80005d2e:	8752                	mv	a4,s4
    80005d30:	86ce                	mv	a3,s3
    80005d32:	8656                	mv	a2,s5
    80005d34:	4581                	li	a1,0
    80005d36:	854a                	mv	a0,s2
    80005d38:	ffffe097          	auipc	ra,0xffffe
    80005d3c:	2bc080e7          	jalr	700(ra) # 80003ff4 <readi>
    80005d40:	01451d63          	bne	a0,s4,80005d5a <sys_unlink+0x180>
    if(de.inum != 0)
    80005d44:	f0845783          	lhu	a5,-248(s0)
    80005d48:	eba5                	bnez	a5,80005db8 <sys_unlink+0x1de>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005d4a:	29c1                	addiw	s3,s3,16
    80005d4c:	04c92783          	lw	a5,76(s2)
    80005d50:	fcf9efe3          	bltu	s3,a5,80005d2e <sys_unlink+0x154>
    80005d54:	6a4e                	ld	s4,208(sp)
    80005d56:	6aae                	ld	s5,200(sp)
    80005d58:	b735                	j	80005c84 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005d5a:	00003517          	auipc	a0,0x3
    80005d5e:	99650513          	addi	a0,a0,-1642 # 800086f0 <etext+0x6f0>
    80005d62:	ffffa097          	auipc	ra,0xffffa
    80005d66:	7fe080e7          	jalr	2046(ra) # 80000560 <panic>
    80005d6a:	e9d2                	sd	s4,208(sp)
    80005d6c:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    80005d6e:	00003517          	auipc	a0,0x3
    80005d72:	99a50513          	addi	a0,a0,-1638 # 80008708 <etext+0x708>
    80005d76:	ffffa097          	auipc	ra,0xffffa
    80005d7a:	7ea080e7          	jalr	2026(ra) # 80000560 <panic>
    dp->nlink--;
    80005d7e:	04a4d783          	lhu	a5,74(s1)
    80005d82:	37fd                	addiw	a5,a5,-1
    80005d84:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005d88:	8526                	mv	a0,s1
    80005d8a:	ffffe097          	auipc	ra,0xffffe
    80005d8e:	ee2080e7          	jalr	-286(ra) # 80003c6c <iupdate>
    80005d92:	b725                	j	80005cba <sys_unlink+0xe0>
    80005d94:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    80005d96:	8526                	mv	a0,s1
    80005d98:	ffffe097          	auipc	ra,0xffffe
    80005d9c:	206080e7          	jalr	518(ra) # 80003f9e <iunlockput>
  end_op();
    80005da0:	fffff097          	auipc	ra,0xfffff
    80005da4:	9fc080e7          	jalr	-1540(ra) # 8000479c <end_op>
  return -1;
    80005da8:	557d                	li	a0,-1
    80005daa:	74ae                	ld	s1,232(sp)
}
    80005dac:	70ee                	ld	ra,248(sp)
    80005dae:	744e                	ld	s0,240(sp)
    80005db0:	6111                	addi	sp,sp,256
    80005db2:	8082                	ret
    return -1;
    80005db4:	557d                	li	a0,-1
    80005db6:	bfdd                	j	80005dac <sys_unlink+0x1d2>
    iunlockput(ip);
    80005db8:	854a                	mv	a0,s2
    80005dba:	ffffe097          	auipc	ra,0xffffe
    80005dbe:	1e4080e7          	jalr	484(ra) # 80003f9e <iunlockput>
    goto bad;
    80005dc2:	790e                	ld	s2,224(sp)
    80005dc4:	69ee                	ld	s3,216(sp)
    80005dc6:	6a4e                	ld	s4,208(sp)
    80005dc8:	6aae                	ld	s5,200(sp)
    80005dca:	b7f1                	j	80005d96 <sys_unlink+0x1bc>

0000000080005dcc <sys_open>:

uint64
sys_open(void)
{
    80005dcc:	7131                	addi	sp,sp,-192
    80005dce:	fd06                	sd	ra,184(sp)
    80005dd0:	f922                	sd	s0,176(sp)
    80005dd2:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005dd4:	f4c40593          	addi	a1,s0,-180
    80005dd8:	4505                	li	a0,1
    80005dda:	ffffd097          	auipc	ra,0xffffd
    80005dde:	356080e7          	jalr	854(ra) # 80003130 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005de2:	08000613          	li	a2,128
    80005de6:	f5040593          	addi	a1,s0,-176
    80005dea:	4501                	li	a0,0
    80005dec:	ffffd097          	auipc	ra,0xffffd
    80005df0:	384080e7          	jalr	900(ra) # 80003170 <argstr>
    80005df4:	87aa                	mv	a5,a0
    return -1;
    80005df6:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005df8:	0a07cf63          	bltz	a5,80005eb6 <sys_open+0xea>
    80005dfc:	f526                	sd	s1,168(sp)

  begin_op();
    80005dfe:	fffff097          	auipc	ra,0xfffff
    80005e02:	924080e7          	jalr	-1756(ra) # 80004722 <begin_op>

  if(omode & O_CREATE){
    80005e06:	f4c42783          	lw	a5,-180(s0)
    80005e0a:	2007f793          	andi	a5,a5,512
    80005e0e:	cfdd                	beqz	a5,80005ecc <sys_open+0x100>
    ip = create(path, T_FILE, 0, 0);
    80005e10:	4681                	li	a3,0
    80005e12:	4601                	li	a2,0
    80005e14:	4589                	li	a1,2
    80005e16:	f5040513          	addi	a0,s0,-176
    80005e1a:	00000097          	auipc	ra,0x0
    80005e1e:	94c080e7          	jalr	-1716(ra) # 80005766 <create>
    80005e22:	84aa                	mv	s1,a0
    if(ip == 0){
    80005e24:	cd49                	beqz	a0,80005ebe <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005e26:	04449703          	lh	a4,68(s1)
    80005e2a:	478d                	li	a5,3
    80005e2c:	00f71763          	bne	a4,a5,80005e3a <sys_open+0x6e>
    80005e30:	0464d703          	lhu	a4,70(s1)
    80005e34:	47a5                	li	a5,9
    80005e36:	0ee7e263          	bltu	a5,a4,80005f1a <sys_open+0x14e>
    80005e3a:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005e3c:	fffff097          	auipc	ra,0xfffff
    80005e40:	cfa080e7          	jalr	-774(ra) # 80004b36 <filealloc>
    80005e44:	892a                	mv	s2,a0
    80005e46:	cd65                	beqz	a0,80005f3e <sys_open+0x172>
    80005e48:	ed4e                	sd	s3,152(sp)
    80005e4a:	00000097          	auipc	ra,0x0
    80005e4e:	8da080e7          	jalr	-1830(ra) # 80005724 <fdalloc>
    80005e52:	89aa                	mv	s3,a0
    80005e54:	0c054f63          	bltz	a0,80005f32 <sys_open+0x166>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005e58:	04449703          	lh	a4,68(s1)
    80005e5c:	478d                	li	a5,3
    80005e5e:	0ef70d63          	beq	a4,a5,80005f58 <sys_open+0x18c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005e62:	4789                	li	a5,2
    80005e64:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005e68:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005e6c:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005e70:	f4c42783          	lw	a5,-180(s0)
    80005e74:	0017f713          	andi	a4,a5,1
    80005e78:	00174713          	xori	a4,a4,1
    80005e7c:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005e80:	0037f713          	andi	a4,a5,3
    80005e84:	00e03733          	snez	a4,a4
    80005e88:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005e8c:	4007f793          	andi	a5,a5,1024
    80005e90:	c791                	beqz	a5,80005e9c <sys_open+0xd0>
    80005e92:	04449703          	lh	a4,68(s1)
    80005e96:	4789                	li	a5,2
    80005e98:	0cf70763          	beq	a4,a5,80005f66 <sys_open+0x19a>
    itrunc(ip);
  }

  iunlock(ip);
    80005e9c:	8526                	mv	a0,s1
    80005e9e:	ffffe097          	auipc	ra,0xffffe
    80005ea2:	f60080e7          	jalr	-160(ra) # 80003dfe <iunlock>
  end_op();
    80005ea6:	fffff097          	auipc	ra,0xfffff
    80005eaa:	8f6080e7          	jalr	-1802(ra) # 8000479c <end_op>

  return fd;
    80005eae:	854e                	mv	a0,s3
    80005eb0:	74aa                	ld	s1,168(sp)
    80005eb2:	790a                	ld	s2,160(sp)
    80005eb4:	69ea                	ld	s3,152(sp)
}
    80005eb6:	70ea                	ld	ra,184(sp)
    80005eb8:	744a                	ld	s0,176(sp)
    80005eba:	6129                	addi	sp,sp,192
    80005ebc:	8082                	ret
      end_op();
    80005ebe:	fffff097          	auipc	ra,0xfffff
    80005ec2:	8de080e7          	jalr	-1826(ra) # 8000479c <end_op>
      return -1;
    80005ec6:	557d                	li	a0,-1
    80005ec8:	74aa                	ld	s1,168(sp)
    80005eca:	b7f5                	j	80005eb6 <sys_open+0xea>
    if((ip = namei(path)) == 0){
    80005ecc:	f5040513          	addi	a0,s0,-176
    80005ed0:	ffffe097          	auipc	ra,0xffffe
    80005ed4:	64c080e7          	jalr	1612(ra) # 8000451c <namei>
    80005ed8:	84aa                	mv	s1,a0
    80005eda:	c90d                	beqz	a0,80005f0c <sys_open+0x140>
    ilock(ip);
    80005edc:	ffffe097          	auipc	ra,0xffffe
    80005ee0:	e5c080e7          	jalr	-420(ra) # 80003d38 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005ee4:	04449703          	lh	a4,68(s1)
    80005ee8:	4785                	li	a5,1
    80005eea:	f2f71ee3          	bne	a4,a5,80005e26 <sys_open+0x5a>
    80005eee:	f4c42783          	lw	a5,-180(s0)
    80005ef2:	d7a1                	beqz	a5,80005e3a <sys_open+0x6e>
      iunlockput(ip);
    80005ef4:	8526                	mv	a0,s1
    80005ef6:	ffffe097          	auipc	ra,0xffffe
    80005efa:	0a8080e7          	jalr	168(ra) # 80003f9e <iunlockput>
      end_op();
    80005efe:	fffff097          	auipc	ra,0xfffff
    80005f02:	89e080e7          	jalr	-1890(ra) # 8000479c <end_op>
      return -1;
    80005f06:	557d                	li	a0,-1
    80005f08:	74aa                	ld	s1,168(sp)
    80005f0a:	b775                	j	80005eb6 <sys_open+0xea>
      end_op();
    80005f0c:	fffff097          	auipc	ra,0xfffff
    80005f10:	890080e7          	jalr	-1904(ra) # 8000479c <end_op>
      return -1;
    80005f14:	557d                	li	a0,-1
    80005f16:	74aa                	ld	s1,168(sp)
    80005f18:	bf79                	j	80005eb6 <sys_open+0xea>
    iunlockput(ip);
    80005f1a:	8526                	mv	a0,s1
    80005f1c:	ffffe097          	auipc	ra,0xffffe
    80005f20:	082080e7          	jalr	130(ra) # 80003f9e <iunlockput>
    end_op();
    80005f24:	fffff097          	auipc	ra,0xfffff
    80005f28:	878080e7          	jalr	-1928(ra) # 8000479c <end_op>
    return -1;
    80005f2c:	557d                	li	a0,-1
    80005f2e:	74aa                	ld	s1,168(sp)
    80005f30:	b759                	j	80005eb6 <sys_open+0xea>
      fileclose(f);
    80005f32:	854a                	mv	a0,s2
    80005f34:	fffff097          	auipc	ra,0xfffff
    80005f38:	cbe080e7          	jalr	-834(ra) # 80004bf2 <fileclose>
    80005f3c:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005f3e:	8526                	mv	a0,s1
    80005f40:	ffffe097          	auipc	ra,0xffffe
    80005f44:	05e080e7          	jalr	94(ra) # 80003f9e <iunlockput>
    end_op();
    80005f48:	fffff097          	auipc	ra,0xfffff
    80005f4c:	854080e7          	jalr	-1964(ra) # 8000479c <end_op>
    return -1;
    80005f50:	557d                	li	a0,-1
    80005f52:	74aa                	ld	s1,168(sp)
    80005f54:	790a                	ld	s2,160(sp)
    80005f56:	b785                	j	80005eb6 <sys_open+0xea>
    f->type = FD_DEVICE;
    80005f58:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005f5c:	04649783          	lh	a5,70(s1)
    80005f60:	02f91223          	sh	a5,36(s2)
    80005f64:	b721                	j	80005e6c <sys_open+0xa0>
    itrunc(ip);
    80005f66:	8526                	mv	a0,s1
    80005f68:	ffffe097          	auipc	ra,0xffffe
    80005f6c:	ee2080e7          	jalr	-286(ra) # 80003e4a <itrunc>
    80005f70:	b735                	j	80005e9c <sys_open+0xd0>

0000000080005f72 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005f72:	7175                	addi	sp,sp,-144
    80005f74:	e506                	sd	ra,136(sp)
    80005f76:	e122                	sd	s0,128(sp)
    80005f78:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005f7a:	ffffe097          	auipc	ra,0xffffe
    80005f7e:	7a8080e7          	jalr	1960(ra) # 80004722 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005f82:	08000613          	li	a2,128
    80005f86:	f7040593          	addi	a1,s0,-144
    80005f8a:	4501                	li	a0,0
    80005f8c:	ffffd097          	auipc	ra,0xffffd
    80005f90:	1e4080e7          	jalr	484(ra) # 80003170 <argstr>
    80005f94:	02054963          	bltz	a0,80005fc6 <sys_mkdir+0x54>
    80005f98:	4681                	li	a3,0
    80005f9a:	4601                	li	a2,0
    80005f9c:	4585                	li	a1,1
    80005f9e:	f7040513          	addi	a0,s0,-144
    80005fa2:	fffff097          	auipc	ra,0xfffff
    80005fa6:	7c4080e7          	jalr	1988(ra) # 80005766 <create>
    80005faa:	cd11                	beqz	a0,80005fc6 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005fac:	ffffe097          	auipc	ra,0xffffe
    80005fb0:	ff2080e7          	jalr	-14(ra) # 80003f9e <iunlockput>
  end_op();
    80005fb4:	ffffe097          	auipc	ra,0xffffe
    80005fb8:	7e8080e7          	jalr	2024(ra) # 8000479c <end_op>
  return 0;
    80005fbc:	4501                	li	a0,0
}
    80005fbe:	60aa                	ld	ra,136(sp)
    80005fc0:	640a                	ld	s0,128(sp)
    80005fc2:	6149                	addi	sp,sp,144
    80005fc4:	8082                	ret
    end_op();
    80005fc6:	ffffe097          	auipc	ra,0xffffe
    80005fca:	7d6080e7          	jalr	2006(ra) # 8000479c <end_op>
    return -1;
    80005fce:	557d                	li	a0,-1
    80005fd0:	b7fd                	j	80005fbe <sys_mkdir+0x4c>

0000000080005fd2 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005fd2:	7135                	addi	sp,sp,-160
    80005fd4:	ed06                	sd	ra,152(sp)
    80005fd6:	e922                	sd	s0,144(sp)
    80005fd8:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005fda:	ffffe097          	auipc	ra,0xffffe
    80005fde:	748080e7          	jalr	1864(ra) # 80004722 <begin_op>
  argint(1, &major);
    80005fe2:	f6c40593          	addi	a1,s0,-148
    80005fe6:	4505                	li	a0,1
    80005fe8:	ffffd097          	auipc	ra,0xffffd
    80005fec:	148080e7          	jalr	328(ra) # 80003130 <argint>
  argint(2, &minor);
    80005ff0:	f6840593          	addi	a1,s0,-152
    80005ff4:	4509                	li	a0,2
    80005ff6:	ffffd097          	auipc	ra,0xffffd
    80005ffa:	13a080e7          	jalr	314(ra) # 80003130 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005ffe:	08000613          	li	a2,128
    80006002:	f7040593          	addi	a1,s0,-144
    80006006:	4501                	li	a0,0
    80006008:	ffffd097          	auipc	ra,0xffffd
    8000600c:	168080e7          	jalr	360(ra) # 80003170 <argstr>
    80006010:	02054b63          	bltz	a0,80006046 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80006014:	f6841683          	lh	a3,-152(s0)
    80006018:	f6c41603          	lh	a2,-148(s0)
    8000601c:	458d                	li	a1,3
    8000601e:	f7040513          	addi	a0,s0,-144
    80006022:	fffff097          	auipc	ra,0xfffff
    80006026:	744080e7          	jalr	1860(ra) # 80005766 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000602a:	cd11                	beqz	a0,80006046 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000602c:	ffffe097          	auipc	ra,0xffffe
    80006030:	f72080e7          	jalr	-142(ra) # 80003f9e <iunlockput>
  end_op();
    80006034:	ffffe097          	auipc	ra,0xffffe
    80006038:	768080e7          	jalr	1896(ra) # 8000479c <end_op>
  return 0;
    8000603c:	4501                	li	a0,0
}
    8000603e:	60ea                	ld	ra,152(sp)
    80006040:	644a                	ld	s0,144(sp)
    80006042:	610d                	addi	sp,sp,160
    80006044:	8082                	ret
    end_op();
    80006046:	ffffe097          	auipc	ra,0xffffe
    8000604a:	756080e7          	jalr	1878(ra) # 8000479c <end_op>
    return -1;
    8000604e:	557d                	li	a0,-1
    80006050:	b7fd                	j	8000603e <sys_mknod+0x6c>

0000000080006052 <sys_chdir>:

uint64
sys_chdir(void)
{
    80006052:	7135                	addi	sp,sp,-160
    80006054:	ed06                	sd	ra,152(sp)
    80006056:	e922                	sd	s0,144(sp)
    80006058:	e14a                	sd	s2,128(sp)
    8000605a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000605c:	ffffc097          	auipc	ra,0xffffc
    80006060:	d26080e7          	jalr	-730(ra) # 80001d82 <myproc>
    80006064:	892a                	mv	s2,a0
  
  begin_op();
    80006066:	ffffe097          	auipc	ra,0xffffe
    8000606a:	6bc080e7          	jalr	1724(ra) # 80004722 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000606e:	08000613          	li	a2,128
    80006072:	f6040593          	addi	a1,s0,-160
    80006076:	4501                	li	a0,0
    80006078:	ffffd097          	auipc	ra,0xffffd
    8000607c:	0f8080e7          	jalr	248(ra) # 80003170 <argstr>
    80006080:	04054d63          	bltz	a0,800060da <sys_chdir+0x88>
    80006084:	e526                	sd	s1,136(sp)
    80006086:	f6040513          	addi	a0,s0,-160
    8000608a:	ffffe097          	auipc	ra,0xffffe
    8000608e:	492080e7          	jalr	1170(ra) # 8000451c <namei>
    80006092:	84aa                	mv	s1,a0
    80006094:	c131                	beqz	a0,800060d8 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80006096:	ffffe097          	auipc	ra,0xffffe
    8000609a:	ca2080e7          	jalr	-862(ra) # 80003d38 <ilock>
  if(ip->type != T_DIR){
    8000609e:	04449703          	lh	a4,68(s1)
    800060a2:	4785                	li	a5,1
    800060a4:	04f71163          	bne	a4,a5,800060e6 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800060a8:	8526                	mv	a0,s1
    800060aa:	ffffe097          	auipc	ra,0xffffe
    800060ae:	d54080e7          	jalr	-684(ra) # 80003dfe <iunlock>
  iput(p->cwd);
    800060b2:	15093503          	ld	a0,336(s2)
    800060b6:	ffffe097          	auipc	ra,0xffffe
    800060ba:	e40080e7          	jalr	-448(ra) # 80003ef6 <iput>
  end_op();
    800060be:	ffffe097          	auipc	ra,0xffffe
    800060c2:	6de080e7          	jalr	1758(ra) # 8000479c <end_op>
  p->cwd = ip;
    800060c6:	14993823          	sd	s1,336(s2)
  return 0;
    800060ca:	4501                	li	a0,0
    800060cc:	64aa                	ld	s1,136(sp)
}
    800060ce:	60ea                	ld	ra,152(sp)
    800060d0:	644a                	ld	s0,144(sp)
    800060d2:	690a                	ld	s2,128(sp)
    800060d4:	610d                	addi	sp,sp,160
    800060d6:	8082                	ret
    800060d8:	64aa                	ld	s1,136(sp)
    end_op();
    800060da:	ffffe097          	auipc	ra,0xffffe
    800060de:	6c2080e7          	jalr	1730(ra) # 8000479c <end_op>
    return -1;
    800060e2:	557d                	li	a0,-1
    800060e4:	b7ed                	j	800060ce <sys_chdir+0x7c>
    iunlockput(ip);
    800060e6:	8526                	mv	a0,s1
    800060e8:	ffffe097          	auipc	ra,0xffffe
    800060ec:	eb6080e7          	jalr	-330(ra) # 80003f9e <iunlockput>
    end_op();
    800060f0:	ffffe097          	auipc	ra,0xffffe
    800060f4:	6ac080e7          	jalr	1708(ra) # 8000479c <end_op>
    return -1;
    800060f8:	557d                	li	a0,-1
    800060fa:	64aa                	ld	s1,136(sp)
    800060fc:	bfc9                	j	800060ce <sys_chdir+0x7c>

00000000800060fe <sys_exec>:

uint64
sys_exec(void)
{
    800060fe:	7105                	addi	sp,sp,-480
    80006100:	ef86                	sd	ra,472(sp)
    80006102:	eba2                	sd	s0,464(sp)
    80006104:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80006106:	e2840593          	addi	a1,s0,-472
    8000610a:	4505                	li	a0,1
    8000610c:	ffffd097          	auipc	ra,0xffffd
    80006110:	044080e7          	jalr	68(ra) # 80003150 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80006114:	08000613          	li	a2,128
    80006118:	f3040593          	addi	a1,s0,-208
    8000611c:	4501                	li	a0,0
    8000611e:	ffffd097          	auipc	ra,0xffffd
    80006122:	052080e7          	jalr	82(ra) # 80003170 <argstr>
    80006126:	87aa                	mv	a5,a0
    return -1;
    80006128:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000612a:	0e07ce63          	bltz	a5,80006226 <sys_exec+0x128>
    8000612e:	e7a6                	sd	s1,456(sp)
    80006130:	e3ca                	sd	s2,448(sp)
    80006132:	ff4e                	sd	s3,440(sp)
    80006134:	fb52                	sd	s4,432(sp)
    80006136:	f756                	sd	s5,424(sp)
    80006138:	f35a                	sd	s6,416(sp)
    8000613a:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    8000613c:	e3040a13          	addi	s4,s0,-464
    80006140:	10000613          	li	a2,256
    80006144:	4581                	li	a1,0
    80006146:	8552                	mv	a0,s4
    80006148:	ffffb097          	auipc	ra,0xffffb
    8000614c:	bee080e7          	jalr	-1042(ra) # 80000d36 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80006150:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80006152:	89d2                	mv	s3,s4
    80006154:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80006156:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000615a:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    8000615c:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80006160:	00391513          	slli	a0,s2,0x3
    80006164:	85d6                	mv	a1,s5
    80006166:	e2843783          	ld	a5,-472(s0)
    8000616a:	953e                	add	a0,a0,a5
    8000616c:	ffffd097          	auipc	ra,0xffffd
    80006170:	f26080e7          	jalr	-218(ra) # 80003092 <fetchaddr>
    80006174:	02054a63          	bltz	a0,800061a8 <sys_exec+0xaa>
    if(uarg == 0){
    80006178:	e2043783          	ld	a5,-480(s0)
    8000617c:	cbb1                	beqz	a5,800061d0 <sys_exec+0xd2>
    argv[i] = kalloc();
    8000617e:	ffffb097          	auipc	ra,0xffffb
    80006182:	9cc080e7          	jalr	-1588(ra) # 80000b4a <kalloc>
    80006186:	85aa                	mv	a1,a0
    80006188:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000618c:	cd11                	beqz	a0,800061a8 <sys_exec+0xaa>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000618e:	865a                	mv	a2,s6
    80006190:	e2043503          	ld	a0,-480(s0)
    80006194:	ffffd097          	auipc	ra,0xffffd
    80006198:	f50080e7          	jalr	-176(ra) # 800030e4 <fetchstr>
    8000619c:	00054663          	bltz	a0,800061a8 <sys_exec+0xaa>
    if(i >= NELEM(argv)){
    800061a0:	0905                	addi	s2,s2,1
    800061a2:	09a1                	addi	s3,s3,8
    800061a4:	fb791ee3          	bne	s2,s7,80006160 <sys_exec+0x62>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800061a8:	100a0a13          	addi	s4,s4,256
    800061ac:	6088                	ld	a0,0(s1)
    800061ae:	c525                	beqz	a0,80006216 <sys_exec+0x118>
    kfree(argv[i]);
    800061b0:	ffffb097          	auipc	ra,0xffffb
    800061b4:	89c080e7          	jalr	-1892(ra) # 80000a4c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800061b8:	04a1                	addi	s1,s1,8
    800061ba:	ff4499e3          	bne	s1,s4,800061ac <sys_exec+0xae>
  return -1;
    800061be:	557d                	li	a0,-1
    800061c0:	64be                	ld	s1,456(sp)
    800061c2:	691e                	ld	s2,448(sp)
    800061c4:	79fa                	ld	s3,440(sp)
    800061c6:	7a5a                	ld	s4,432(sp)
    800061c8:	7aba                	ld	s5,424(sp)
    800061ca:	7b1a                	ld	s6,416(sp)
    800061cc:	6bfa                	ld	s7,408(sp)
    800061ce:	a8a1                	j	80006226 <sys_exec+0x128>
      argv[i] = 0;
    800061d0:	0009079b          	sext.w	a5,s2
    800061d4:	e3040593          	addi	a1,s0,-464
    800061d8:	078e                	slli	a5,a5,0x3
    800061da:	97ae                	add	a5,a5,a1
    800061dc:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    800061e0:	f3040513          	addi	a0,s0,-208
    800061e4:	fffff097          	auipc	ra,0xfffff
    800061e8:	118080e7          	jalr	280(ra) # 800052fc <exec>
    800061ec:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800061ee:	100a0a13          	addi	s4,s4,256
    800061f2:	6088                	ld	a0,0(s1)
    800061f4:	c901                	beqz	a0,80006204 <sys_exec+0x106>
    kfree(argv[i]);
    800061f6:	ffffb097          	auipc	ra,0xffffb
    800061fa:	856080e7          	jalr	-1962(ra) # 80000a4c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800061fe:	04a1                	addi	s1,s1,8
    80006200:	ff4499e3          	bne	s1,s4,800061f2 <sys_exec+0xf4>
  return ret;
    80006204:	854a                	mv	a0,s2
    80006206:	64be                	ld	s1,456(sp)
    80006208:	691e                	ld	s2,448(sp)
    8000620a:	79fa                	ld	s3,440(sp)
    8000620c:	7a5a                	ld	s4,432(sp)
    8000620e:	7aba                	ld	s5,424(sp)
    80006210:	7b1a                	ld	s6,416(sp)
    80006212:	6bfa                	ld	s7,408(sp)
    80006214:	a809                	j	80006226 <sys_exec+0x128>
  return -1;
    80006216:	557d                	li	a0,-1
    80006218:	64be                	ld	s1,456(sp)
    8000621a:	691e                	ld	s2,448(sp)
    8000621c:	79fa                	ld	s3,440(sp)
    8000621e:	7a5a                	ld	s4,432(sp)
    80006220:	7aba                	ld	s5,424(sp)
    80006222:	7b1a                	ld	s6,416(sp)
    80006224:	6bfa                	ld	s7,408(sp)
}
    80006226:	60fe                	ld	ra,472(sp)
    80006228:	645e                	ld	s0,464(sp)
    8000622a:	613d                	addi	sp,sp,480
    8000622c:	8082                	ret

000000008000622e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000622e:	7139                	addi	sp,sp,-64
    80006230:	fc06                	sd	ra,56(sp)
    80006232:	f822                	sd	s0,48(sp)
    80006234:	f426                	sd	s1,40(sp)
    80006236:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80006238:	ffffc097          	auipc	ra,0xffffc
    8000623c:	b4a080e7          	jalr	-1206(ra) # 80001d82 <myproc>
    80006240:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80006242:	fd840593          	addi	a1,s0,-40
    80006246:	4501                	li	a0,0
    80006248:	ffffd097          	auipc	ra,0xffffd
    8000624c:	f08080e7          	jalr	-248(ra) # 80003150 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80006250:	fc840593          	addi	a1,s0,-56
    80006254:	fd040513          	addi	a0,s0,-48
    80006258:	fffff097          	auipc	ra,0xfffff
    8000625c:	d0e080e7          	jalr	-754(ra) # 80004f66 <pipealloc>
    return -1;
    80006260:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80006262:	0c054463          	bltz	a0,8000632a <sys_pipe+0xfc>
  fd0 = -1;
    80006266:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000626a:	fd043503          	ld	a0,-48(s0)
    8000626e:	fffff097          	auipc	ra,0xfffff
    80006272:	4b6080e7          	jalr	1206(ra) # 80005724 <fdalloc>
    80006276:	fca42223          	sw	a0,-60(s0)
    8000627a:	08054b63          	bltz	a0,80006310 <sys_pipe+0xe2>
    8000627e:	fc843503          	ld	a0,-56(s0)
    80006282:	fffff097          	auipc	ra,0xfffff
    80006286:	4a2080e7          	jalr	1186(ra) # 80005724 <fdalloc>
    8000628a:	fca42023          	sw	a0,-64(s0)
    8000628e:	06054863          	bltz	a0,800062fe <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006292:	4691                	li	a3,4
    80006294:	fc440613          	addi	a2,s0,-60
    80006298:	fd843583          	ld	a1,-40(s0)
    8000629c:	68a8                	ld	a0,80(s1)
    8000629e:	ffffb097          	auipc	ra,0xffffb
    800062a2:	472080e7          	jalr	1138(ra) # 80001710 <copyout>
    800062a6:	02054063          	bltz	a0,800062c6 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800062aa:	4691                	li	a3,4
    800062ac:	fc040613          	addi	a2,s0,-64
    800062b0:	fd843583          	ld	a1,-40(s0)
    800062b4:	95b6                	add	a1,a1,a3
    800062b6:	68a8                	ld	a0,80(s1)
    800062b8:	ffffb097          	auipc	ra,0xffffb
    800062bc:	458080e7          	jalr	1112(ra) # 80001710 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800062c0:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800062c2:	06055463          	bgez	a0,8000632a <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800062c6:	fc442783          	lw	a5,-60(s0)
    800062ca:	07e9                	addi	a5,a5,26
    800062cc:	078e                	slli	a5,a5,0x3
    800062ce:	97a6                	add	a5,a5,s1
    800062d0:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800062d4:	fc042783          	lw	a5,-64(s0)
    800062d8:	07e9                	addi	a5,a5,26
    800062da:	078e                	slli	a5,a5,0x3
    800062dc:	94be                	add	s1,s1,a5
    800062de:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800062e2:	fd043503          	ld	a0,-48(s0)
    800062e6:	fffff097          	auipc	ra,0xfffff
    800062ea:	90c080e7          	jalr	-1780(ra) # 80004bf2 <fileclose>
    fileclose(wf);
    800062ee:	fc843503          	ld	a0,-56(s0)
    800062f2:	fffff097          	auipc	ra,0xfffff
    800062f6:	900080e7          	jalr	-1792(ra) # 80004bf2 <fileclose>
    return -1;
    800062fa:	57fd                	li	a5,-1
    800062fc:	a03d                	j	8000632a <sys_pipe+0xfc>
    if(fd0 >= 0)
    800062fe:	fc442783          	lw	a5,-60(s0)
    80006302:	0007c763          	bltz	a5,80006310 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80006306:	07e9                	addi	a5,a5,26
    80006308:	078e                	slli	a5,a5,0x3
    8000630a:	97a6                	add	a5,a5,s1
    8000630c:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80006310:	fd043503          	ld	a0,-48(s0)
    80006314:	fffff097          	auipc	ra,0xfffff
    80006318:	8de080e7          	jalr	-1826(ra) # 80004bf2 <fileclose>
    fileclose(wf);
    8000631c:	fc843503          	ld	a0,-56(s0)
    80006320:	fffff097          	auipc	ra,0xfffff
    80006324:	8d2080e7          	jalr	-1838(ra) # 80004bf2 <fileclose>
    return -1;
    80006328:	57fd                	li	a5,-1
}
    8000632a:	853e                	mv	a0,a5
    8000632c:	70e2                	ld	ra,56(sp)
    8000632e:	7442                	ld	s0,48(sp)
    80006330:	74a2                	ld	s1,40(sp)
    80006332:	6121                	addi	sp,sp,64
    80006334:	8082                	ret
	...

0000000080006340 <kernelvec>:
    80006340:	7111                	addi	sp,sp,-256
    80006342:	e006                	sd	ra,0(sp)
    80006344:	e40a                	sd	sp,8(sp)
    80006346:	e80e                	sd	gp,16(sp)
    80006348:	ec12                	sd	tp,24(sp)
    8000634a:	f016                	sd	t0,32(sp)
    8000634c:	f41a                	sd	t1,40(sp)
    8000634e:	f81e                	sd	t2,48(sp)
    80006350:	fc22                	sd	s0,56(sp)
    80006352:	e0a6                	sd	s1,64(sp)
    80006354:	e4aa                	sd	a0,72(sp)
    80006356:	e8ae                	sd	a1,80(sp)
    80006358:	ecb2                	sd	a2,88(sp)
    8000635a:	f0b6                	sd	a3,96(sp)
    8000635c:	f4ba                	sd	a4,104(sp)
    8000635e:	f8be                	sd	a5,112(sp)
    80006360:	fcc2                	sd	a6,120(sp)
    80006362:	e146                	sd	a7,128(sp)
    80006364:	e54a                	sd	s2,136(sp)
    80006366:	e94e                	sd	s3,144(sp)
    80006368:	ed52                	sd	s4,152(sp)
    8000636a:	f156                	sd	s5,160(sp)
    8000636c:	f55a                	sd	s6,168(sp)
    8000636e:	f95e                	sd	s7,176(sp)
    80006370:	fd62                	sd	s8,184(sp)
    80006372:	e1e6                	sd	s9,192(sp)
    80006374:	e5ea                	sd	s10,200(sp)
    80006376:	e9ee                	sd	s11,208(sp)
    80006378:	edf2                	sd	t3,216(sp)
    8000637a:	f1f6                	sd	t4,224(sp)
    8000637c:	f5fa                	sd	t5,232(sp)
    8000637e:	f9fe                	sd	t6,240(sp)
    80006380:	bddfc0ef          	jal	80002f5c <kerneltrap>
    80006384:	6082                	ld	ra,0(sp)
    80006386:	6122                	ld	sp,8(sp)
    80006388:	61c2                	ld	gp,16(sp)
    8000638a:	7282                	ld	t0,32(sp)
    8000638c:	7322                	ld	t1,40(sp)
    8000638e:	73c2                	ld	t2,48(sp)
    80006390:	7462                	ld	s0,56(sp)
    80006392:	6486                	ld	s1,64(sp)
    80006394:	6526                	ld	a0,72(sp)
    80006396:	65c6                	ld	a1,80(sp)
    80006398:	6666                	ld	a2,88(sp)
    8000639a:	7686                	ld	a3,96(sp)
    8000639c:	7726                	ld	a4,104(sp)
    8000639e:	77c6                	ld	a5,112(sp)
    800063a0:	7866                	ld	a6,120(sp)
    800063a2:	688a                	ld	a7,128(sp)
    800063a4:	692a                	ld	s2,136(sp)
    800063a6:	69ca                	ld	s3,144(sp)
    800063a8:	6a6a                	ld	s4,152(sp)
    800063aa:	7a8a                	ld	s5,160(sp)
    800063ac:	7b2a                	ld	s6,168(sp)
    800063ae:	7bca                	ld	s7,176(sp)
    800063b0:	7c6a                	ld	s8,184(sp)
    800063b2:	6c8e                	ld	s9,192(sp)
    800063b4:	6d2e                	ld	s10,200(sp)
    800063b6:	6dce                	ld	s11,208(sp)
    800063b8:	6e6e                	ld	t3,216(sp)
    800063ba:	7e8e                	ld	t4,224(sp)
    800063bc:	7f2e                	ld	t5,232(sp)
    800063be:	7fce                	ld	t6,240(sp)
    800063c0:	6111                	addi	sp,sp,256
    800063c2:	10200073          	sret
    800063c6:	00000013          	nop
    800063ca:	00000013          	nop
    800063ce:	0001                	nop

00000000800063d0 <timervec>:
    800063d0:	34051573          	csrrw	a0,mscratch,a0
    800063d4:	e10c                	sd	a1,0(a0)
    800063d6:	e510                	sd	a2,8(a0)
    800063d8:	e914                	sd	a3,16(a0)
    800063da:	6d0c                	ld	a1,24(a0)
    800063dc:	7110                	ld	a2,32(a0)
    800063de:	6194                	ld	a3,0(a1)
    800063e0:	96b2                	add	a3,a3,a2
    800063e2:	e194                	sd	a3,0(a1)
    800063e4:	4589                	li	a1,2
    800063e6:	14459073          	csrw	sip,a1
    800063ea:	6914                	ld	a3,16(a0)
    800063ec:	6510                	ld	a2,8(a0)
    800063ee:	610c                	ld	a1,0(a0)
    800063f0:	34051573          	csrrw	a0,mscratch,a0
    800063f4:	30200073          	mret
	...

00000000800063fa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800063fa:	1141                	addi	sp,sp,-16
    800063fc:	e406                	sd	ra,8(sp)
    800063fe:	e022                	sd	s0,0(sp)
    80006400:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006402:	0c000737          	lui	a4,0xc000
    80006406:	4785                	li	a5,1
    80006408:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000640a:	c35c                	sw	a5,4(a4)
}
    8000640c:	60a2                	ld	ra,8(sp)
    8000640e:	6402                	ld	s0,0(sp)
    80006410:	0141                	addi	sp,sp,16
    80006412:	8082                	ret

0000000080006414 <plicinithart>:

void
plicinithart(void)
{
    80006414:	1141                	addi	sp,sp,-16
    80006416:	e406                	sd	ra,8(sp)
    80006418:	e022                	sd	s0,0(sp)
    8000641a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000641c:	ffffc097          	auipc	ra,0xffffc
    80006420:	932080e7          	jalr	-1742(ra) # 80001d4e <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006424:	0085171b          	slliw	a4,a0,0x8
    80006428:	0c0027b7          	lui	a5,0xc002
    8000642c:	97ba                	add	a5,a5,a4
    8000642e:	40200713          	li	a4,1026
    80006432:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006436:	00d5151b          	slliw	a0,a0,0xd
    8000643a:	0c2017b7          	lui	a5,0xc201
    8000643e:	97aa                	add	a5,a5,a0
    80006440:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80006444:	60a2                	ld	ra,8(sp)
    80006446:	6402                	ld	s0,0(sp)
    80006448:	0141                	addi	sp,sp,16
    8000644a:	8082                	ret

000000008000644c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000644c:	1141                	addi	sp,sp,-16
    8000644e:	e406                	sd	ra,8(sp)
    80006450:	e022                	sd	s0,0(sp)
    80006452:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006454:	ffffc097          	auipc	ra,0xffffc
    80006458:	8fa080e7          	jalr	-1798(ra) # 80001d4e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000645c:	00d5151b          	slliw	a0,a0,0xd
    80006460:	0c2017b7          	lui	a5,0xc201
    80006464:	97aa                	add	a5,a5,a0
  return irq;
}
    80006466:	43c8                	lw	a0,4(a5)
    80006468:	60a2                	ld	ra,8(sp)
    8000646a:	6402                	ld	s0,0(sp)
    8000646c:	0141                	addi	sp,sp,16
    8000646e:	8082                	ret

0000000080006470 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80006470:	1101                	addi	sp,sp,-32
    80006472:	ec06                	sd	ra,24(sp)
    80006474:	e822                	sd	s0,16(sp)
    80006476:	e426                	sd	s1,8(sp)
    80006478:	1000                	addi	s0,sp,32
    8000647a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000647c:	ffffc097          	auipc	ra,0xffffc
    80006480:	8d2080e7          	jalr	-1838(ra) # 80001d4e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006484:	00d5179b          	slliw	a5,a0,0xd
    80006488:	0c201737          	lui	a4,0xc201
    8000648c:	97ba                	add	a5,a5,a4
    8000648e:	c3c4                	sw	s1,4(a5)
}
    80006490:	60e2                	ld	ra,24(sp)
    80006492:	6442                	ld	s0,16(sp)
    80006494:	64a2                	ld	s1,8(sp)
    80006496:	6105                	addi	sp,sp,32
    80006498:	8082                	ret

000000008000649a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000649a:	1141                	addi	sp,sp,-16
    8000649c:	e406                	sd	ra,8(sp)
    8000649e:	e022                	sd	s0,0(sp)
    800064a0:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800064a2:	479d                	li	a5,7
    800064a4:	04a7cc63          	blt	a5,a0,800064fc <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800064a8:	0001c797          	auipc	a5,0x1c
    800064ac:	53878793          	addi	a5,a5,1336 # 800229e0 <disk>
    800064b0:	97aa                	add	a5,a5,a0
    800064b2:	0187c783          	lbu	a5,24(a5)
    800064b6:	ebb9                	bnez	a5,8000650c <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800064b8:	00451693          	slli	a3,a0,0x4
    800064bc:	0001c797          	auipc	a5,0x1c
    800064c0:	52478793          	addi	a5,a5,1316 # 800229e0 <disk>
    800064c4:	6398                	ld	a4,0(a5)
    800064c6:	9736                	add	a4,a4,a3
    800064c8:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    800064cc:	6398                	ld	a4,0(a5)
    800064ce:	9736                	add	a4,a4,a3
    800064d0:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800064d4:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800064d8:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800064dc:	97aa                	add	a5,a5,a0
    800064de:	4705                	li	a4,1
    800064e0:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800064e4:	0001c517          	auipc	a0,0x1c
    800064e8:	51450513          	addi	a0,a0,1300 # 800229f8 <disk+0x18>
    800064ec:	ffffc097          	auipc	ra,0xffffc
    800064f0:	0ec080e7          	jalr	236(ra) # 800025d8 <wakeup>
}
    800064f4:	60a2                	ld	ra,8(sp)
    800064f6:	6402                	ld	s0,0(sp)
    800064f8:	0141                	addi	sp,sp,16
    800064fa:	8082                	ret
    panic("free_desc 1");
    800064fc:	00002517          	auipc	a0,0x2
    80006500:	21c50513          	addi	a0,a0,540 # 80008718 <etext+0x718>
    80006504:	ffffa097          	auipc	ra,0xffffa
    80006508:	05c080e7          	jalr	92(ra) # 80000560 <panic>
    panic("free_desc 2");
    8000650c:	00002517          	auipc	a0,0x2
    80006510:	21c50513          	addi	a0,a0,540 # 80008728 <etext+0x728>
    80006514:	ffffa097          	auipc	ra,0xffffa
    80006518:	04c080e7          	jalr	76(ra) # 80000560 <panic>

000000008000651c <virtio_disk_init>:
{
    8000651c:	1101                	addi	sp,sp,-32
    8000651e:	ec06                	sd	ra,24(sp)
    80006520:	e822                	sd	s0,16(sp)
    80006522:	e426                	sd	s1,8(sp)
    80006524:	e04a                	sd	s2,0(sp)
    80006526:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006528:	00002597          	auipc	a1,0x2
    8000652c:	21058593          	addi	a1,a1,528 # 80008738 <etext+0x738>
    80006530:	0001c517          	auipc	a0,0x1c
    80006534:	5d850513          	addi	a0,a0,1496 # 80022b08 <disk+0x128>
    80006538:	ffffa097          	auipc	ra,0xffffa
    8000653c:	672080e7          	jalr	1650(ra) # 80000baa <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006540:	100017b7          	lui	a5,0x10001
    80006544:	4398                	lw	a4,0(a5)
    80006546:	2701                	sext.w	a4,a4
    80006548:	747277b7          	lui	a5,0x74727
    8000654c:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006550:	16f71463          	bne	a4,a5,800066b8 <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006554:	100017b7          	lui	a5,0x10001
    80006558:	43dc                	lw	a5,4(a5)
    8000655a:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000655c:	4709                	li	a4,2
    8000655e:	14e79d63          	bne	a5,a4,800066b8 <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006562:	100017b7          	lui	a5,0x10001
    80006566:	479c                	lw	a5,8(a5)
    80006568:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000656a:	14e79763          	bne	a5,a4,800066b8 <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000656e:	100017b7          	lui	a5,0x10001
    80006572:	47d8                	lw	a4,12(a5)
    80006574:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006576:	554d47b7          	lui	a5,0x554d4
    8000657a:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000657e:	12f71d63          	bne	a4,a5,800066b8 <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006582:	100017b7          	lui	a5,0x10001
    80006586:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000658a:	4705                	li	a4,1
    8000658c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000658e:	470d                	li	a4,3
    80006590:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80006592:	10001737          	lui	a4,0x10001
    80006596:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80006598:	c7ffe6b7          	lui	a3,0xc7ffe
    8000659c:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdbc3f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800065a0:	8f75                	and	a4,a4,a3
    800065a2:	100016b7          	lui	a3,0x10001
    800065a6:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    800065a8:	472d                	li	a4,11
    800065aa:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800065ac:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    800065b0:	439c                	lw	a5,0(a5)
    800065b2:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800065b6:	8ba1                	andi	a5,a5,8
    800065b8:	10078863          	beqz	a5,800066c8 <virtio_disk_init+0x1ac>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800065bc:	100017b7          	lui	a5,0x10001
    800065c0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800065c4:	43fc                	lw	a5,68(a5)
    800065c6:	2781                	sext.w	a5,a5
    800065c8:	10079863          	bnez	a5,800066d8 <virtio_disk_init+0x1bc>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800065cc:	100017b7          	lui	a5,0x10001
    800065d0:	5bdc                	lw	a5,52(a5)
    800065d2:	2781                	sext.w	a5,a5
  if(max == 0)
    800065d4:	10078a63          	beqz	a5,800066e8 <virtio_disk_init+0x1cc>
  if(max < NUM)
    800065d8:	471d                	li	a4,7
    800065da:	10f77f63          	bgeu	a4,a5,800066f8 <virtio_disk_init+0x1dc>
  disk.desc = kalloc();
    800065de:	ffffa097          	auipc	ra,0xffffa
    800065e2:	56c080e7          	jalr	1388(ra) # 80000b4a <kalloc>
    800065e6:	0001c497          	auipc	s1,0x1c
    800065ea:	3fa48493          	addi	s1,s1,1018 # 800229e0 <disk>
    800065ee:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800065f0:	ffffa097          	auipc	ra,0xffffa
    800065f4:	55a080e7          	jalr	1370(ra) # 80000b4a <kalloc>
    800065f8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800065fa:	ffffa097          	auipc	ra,0xffffa
    800065fe:	550080e7          	jalr	1360(ra) # 80000b4a <kalloc>
    80006602:	87aa                	mv	a5,a0
    80006604:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006606:	6088                	ld	a0,0(s1)
    80006608:	10050063          	beqz	a0,80006708 <virtio_disk_init+0x1ec>
    8000660c:	0001c717          	auipc	a4,0x1c
    80006610:	3dc73703          	ld	a4,988(a4) # 800229e8 <disk+0x8>
    80006614:	cb75                	beqz	a4,80006708 <virtio_disk_init+0x1ec>
    80006616:	cbed                	beqz	a5,80006708 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80006618:	6605                	lui	a2,0x1
    8000661a:	4581                	li	a1,0
    8000661c:	ffffa097          	auipc	ra,0xffffa
    80006620:	71a080e7          	jalr	1818(ra) # 80000d36 <memset>
  memset(disk.avail, 0, PGSIZE);
    80006624:	0001c497          	auipc	s1,0x1c
    80006628:	3bc48493          	addi	s1,s1,956 # 800229e0 <disk>
    8000662c:	6605                	lui	a2,0x1
    8000662e:	4581                	li	a1,0
    80006630:	6488                	ld	a0,8(s1)
    80006632:	ffffa097          	auipc	ra,0xffffa
    80006636:	704080e7          	jalr	1796(ra) # 80000d36 <memset>
  memset(disk.used, 0, PGSIZE);
    8000663a:	6605                	lui	a2,0x1
    8000663c:	4581                	li	a1,0
    8000663e:	6888                	ld	a0,16(s1)
    80006640:	ffffa097          	auipc	ra,0xffffa
    80006644:	6f6080e7          	jalr	1782(ra) # 80000d36 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006648:	100017b7          	lui	a5,0x10001
    8000664c:	4721                	li	a4,8
    8000664e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006650:	4098                	lw	a4,0(s1)
    80006652:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006656:	40d8                	lw	a4,4(s1)
    80006658:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000665c:	649c                	ld	a5,8(s1)
    8000665e:	0007869b          	sext.w	a3,a5
    80006662:	10001737          	lui	a4,0x10001
    80006666:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    8000666a:	9781                	srai	a5,a5,0x20
    8000666c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80006670:	689c                	ld	a5,16(s1)
    80006672:	0007869b          	sext.w	a3,a5
    80006676:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000667a:	9781                	srai	a5,a5,0x20
    8000667c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80006680:	4785                	li	a5,1
    80006682:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80006684:	00f48c23          	sb	a5,24(s1)
    80006688:	00f48ca3          	sb	a5,25(s1)
    8000668c:	00f48d23          	sb	a5,26(s1)
    80006690:	00f48da3          	sb	a5,27(s1)
    80006694:	00f48e23          	sb	a5,28(s1)
    80006698:	00f48ea3          	sb	a5,29(s1)
    8000669c:	00f48f23          	sb	a5,30(s1)
    800066a0:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800066a4:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800066a8:	07272823          	sw	s2,112(a4)
}
    800066ac:	60e2                	ld	ra,24(sp)
    800066ae:	6442                	ld	s0,16(sp)
    800066b0:	64a2                	ld	s1,8(sp)
    800066b2:	6902                	ld	s2,0(sp)
    800066b4:	6105                	addi	sp,sp,32
    800066b6:	8082                	ret
    panic("could not find virtio disk");
    800066b8:	00002517          	auipc	a0,0x2
    800066bc:	09050513          	addi	a0,a0,144 # 80008748 <etext+0x748>
    800066c0:	ffffa097          	auipc	ra,0xffffa
    800066c4:	ea0080e7          	jalr	-352(ra) # 80000560 <panic>
    panic("virtio disk FEATURES_OK unset");
    800066c8:	00002517          	auipc	a0,0x2
    800066cc:	0a050513          	addi	a0,a0,160 # 80008768 <etext+0x768>
    800066d0:	ffffa097          	auipc	ra,0xffffa
    800066d4:	e90080e7          	jalr	-368(ra) # 80000560 <panic>
    panic("virtio disk should not be ready");
    800066d8:	00002517          	auipc	a0,0x2
    800066dc:	0b050513          	addi	a0,a0,176 # 80008788 <etext+0x788>
    800066e0:	ffffa097          	auipc	ra,0xffffa
    800066e4:	e80080e7          	jalr	-384(ra) # 80000560 <panic>
    panic("virtio disk has no queue 0");
    800066e8:	00002517          	auipc	a0,0x2
    800066ec:	0c050513          	addi	a0,a0,192 # 800087a8 <etext+0x7a8>
    800066f0:	ffffa097          	auipc	ra,0xffffa
    800066f4:	e70080e7          	jalr	-400(ra) # 80000560 <panic>
    panic("virtio disk max queue too short");
    800066f8:	00002517          	auipc	a0,0x2
    800066fc:	0d050513          	addi	a0,a0,208 # 800087c8 <etext+0x7c8>
    80006700:	ffffa097          	auipc	ra,0xffffa
    80006704:	e60080e7          	jalr	-416(ra) # 80000560 <panic>
    panic("virtio disk kalloc");
    80006708:	00002517          	auipc	a0,0x2
    8000670c:	0e050513          	addi	a0,a0,224 # 800087e8 <etext+0x7e8>
    80006710:	ffffa097          	auipc	ra,0xffffa
    80006714:	e50080e7          	jalr	-432(ra) # 80000560 <panic>

0000000080006718 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006718:	711d                	addi	sp,sp,-96
    8000671a:	ec86                	sd	ra,88(sp)
    8000671c:	e8a2                	sd	s0,80(sp)
    8000671e:	e4a6                	sd	s1,72(sp)
    80006720:	e0ca                	sd	s2,64(sp)
    80006722:	fc4e                	sd	s3,56(sp)
    80006724:	f852                	sd	s4,48(sp)
    80006726:	f456                	sd	s5,40(sp)
    80006728:	f05a                	sd	s6,32(sp)
    8000672a:	ec5e                	sd	s7,24(sp)
    8000672c:	e862                	sd	s8,16(sp)
    8000672e:	1080                	addi	s0,sp,96
    80006730:	89aa                	mv	s3,a0
    80006732:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006734:	00c52b83          	lw	s7,12(a0)
    80006738:	001b9b9b          	slliw	s7,s7,0x1
    8000673c:	1b82                	slli	s7,s7,0x20
    8000673e:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80006742:	0001c517          	auipc	a0,0x1c
    80006746:	3c650513          	addi	a0,a0,966 # 80022b08 <disk+0x128>
    8000674a:	ffffa097          	auipc	ra,0xffffa
    8000674e:	4f4080e7          	jalr	1268(ra) # 80000c3e <acquire>
  for(int i = 0; i < NUM; i++){
    80006752:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006754:	0001ca97          	auipc	s5,0x1c
    80006758:	28ca8a93          	addi	s5,s5,652 # 800229e0 <disk>
  for(int i = 0; i < 3; i++){
    8000675c:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    8000675e:	5c7d                	li	s8,-1
    80006760:	a885                	j	800067d0 <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    80006762:	00fa8733          	add	a4,s5,a5
    80006766:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000676a:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000676c:	0207c563          	bltz	a5,80006796 <virtio_disk_rw+0x7e>
  for(int i = 0; i < 3; i++){
    80006770:	2905                	addiw	s2,s2,1
    80006772:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80006774:	07490263          	beq	s2,s4,800067d8 <virtio_disk_rw+0xc0>
    idx[i] = alloc_desc();
    80006778:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000677a:	0001c717          	auipc	a4,0x1c
    8000677e:	26670713          	addi	a4,a4,614 # 800229e0 <disk>
    80006782:	4781                	li	a5,0
    if(disk.free[i]){
    80006784:	01874683          	lbu	a3,24(a4)
    80006788:	fee9                	bnez	a3,80006762 <virtio_disk_rw+0x4a>
  for(int i = 0; i < NUM; i++){
    8000678a:	2785                	addiw	a5,a5,1
    8000678c:	0705                	addi	a4,a4,1
    8000678e:	fe979be3          	bne	a5,s1,80006784 <virtio_disk_rw+0x6c>
    idx[i] = alloc_desc();
    80006792:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80006796:	03205163          	blez	s2,800067b8 <virtio_disk_rw+0xa0>
        free_desc(idx[j]);
    8000679a:	fa042503          	lw	a0,-96(s0)
    8000679e:	00000097          	auipc	ra,0x0
    800067a2:	cfc080e7          	jalr	-772(ra) # 8000649a <free_desc>
      for(int j = 0; j < i; j++)
    800067a6:	4785                	li	a5,1
    800067a8:	0127d863          	bge	a5,s2,800067b8 <virtio_disk_rw+0xa0>
        free_desc(idx[j]);
    800067ac:	fa442503          	lw	a0,-92(s0)
    800067b0:	00000097          	auipc	ra,0x0
    800067b4:	cea080e7          	jalr	-790(ra) # 8000649a <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800067b8:	0001c597          	auipc	a1,0x1c
    800067bc:	35058593          	addi	a1,a1,848 # 80022b08 <disk+0x128>
    800067c0:	0001c517          	auipc	a0,0x1c
    800067c4:	23850513          	addi	a0,a0,568 # 800229f8 <disk+0x18>
    800067c8:	ffffc097          	auipc	ra,0xffffc
    800067cc:	dac080e7          	jalr	-596(ra) # 80002574 <sleep>
  for(int i = 0; i < 3; i++){
    800067d0:	fa040613          	addi	a2,s0,-96
    800067d4:	4901                	li	s2,0
    800067d6:	b74d                	j	80006778 <virtio_disk_rw+0x60>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800067d8:	fa042503          	lw	a0,-96(s0)
    800067dc:	00451693          	slli	a3,a0,0x4

  if(write)
    800067e0:	0001c797          	auipc	a5,0x1c
    800067e4:	20078793          	addi	a5,a5,512 # 800229e0 <disk>
    800067e8:	00a50713          	addi	a4,a0,10
    800067ec:	0712                	slli	a4,a4,0x4
    800067ee:	973e                	add	a4,a4,a5
    800067f0:	01603633          	snez	a2,s6
    800067f4:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800067f6:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800067fa:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800067fe:	6398                	ld	a4,0(a5)
    80006800:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006802:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80006806:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006808:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000680a:	6390                	ld	a2,0(a5)
    8000680c:	00d605b3          	add	a1,a2,a3
    80006810:	4741                	li	a4,16
    80006812:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006814:	4805                	li	a6,1
    80006816:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    8000681a:	fa442703          	lw	a4,-92(s0)
    8000681e:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006822:	0712                	slli	a4,a4,0x4
    80006824:	963a                	add	a2,a2,a4
    80006826:	05898593          	addi	a1,s3,88
    8000682a:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    8000682c:	0007b883          	ld	a7,0(a5)
    80006830:	9746                	add	a4,a4,a7
    80006832:	40000613          	li	a2,1024
    80006836:	c710                	sw	a2,8(a4)
  if(write)
    80006838:	001b3613          	seqz	a2,s6
    8000683c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006840:	01066633          	or	a2,a2,a6
    80006844:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80006848:	fa842583          	lw	a1,-88(s0)
    8000684c:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006850:	00250613          	addi	a2,a0,2
    80006854:	0612                	slli	a2,a2,0x4
    80006856:	963e                	add	a2,a2,a5
    80006858:	577d                	li	a4,-1
    8000685a:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000685e:	0592                	slli	a1,a1,0x4
    80006860:	98ae                	add	a7,a7,a1
    80006862:	03068713          	addi	a4,a3,48
    80006866:	973e                	add	a4,a4,a5
    80006868:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    8000686c:	6398                	ld	a4,0(a5)
    8000686e:	972e                	add	a4,a4,a1
    80006870:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006874:	4689                	li	a3,2
    80006876:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    8000687a:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000687e:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    80006882:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006886:	6794                	ld	a3,8(a5)
    80006888:	0026d703          	lhu	a4,2(a3)
    8000688c:	8b1d                	andi	a4,a4,7
    8000688e:	0706                	slli	a4,a4,0x1
    80006890:	96ba                	add	a3,a3,a4
    80006892:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80006896:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000689a:	6798                	ld	a4,8(a5)
    8000689c:	00275783          	lhu	a5,2(a4)
    800068a0:	2785                	addiw	a5,a5,1
    800068a2:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800068a6:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800068aa:	100017b7          	lui	a5,0x10001
    800068ae:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800068b2:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    800068b6:	0001c917          	auipc	s2,0x1c
    800068ba:	25290913          	addi	s2,s2,594 # 80022b08 <disk+0x128>
  while(b->disk == 1) {
    800068be:	84c2                	mv	s1,a6
    800068c0:	01079c63          	bne	a5,a6,800068d8 <virtio_disk_rw+0x1c0>
    sleep(b, &disk.vdisk_lock);
    800068c4:	85ca                	mv	a1,s2
    800068c6:	854e                	mv	a0,s3
    800068c8:	ffffc097          	auipc	ra,0xffffc
    800068cc:	cac080e7          	jalr	-852(ra) # 80002574 <sleep>
  while(b->disk == 1) {
    800068d0:	0049a783          	lw	a5,4(s3)
    800068d4:	fe9788e3          	beq	a5,s1,800068c4 <virtio_disk_rw+0x1ac>
  }

  disk.info[idx[0]].b = 0;
    800068d8:	fa042903          	lw	s2,-96(s0)
    800068dc:	00290713          	addi	a4,s2,2
    800068e0:	0712                	slli	a4,a4,0x4
    800068e2:	0001c797          	auipc	a5,0x1c
    800068e6:	0fe78793          	addi	a5,a5,254 # 800229e0 <disk>
    800068ea:	97ba                	add	a5,a5,a4
    800068ec:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800068f0:	0001c997          	auipc	s3,0x1c
    800068f4:	0f098993          	addi	s3,s3,240 # 800229e0 <disk>
    800068f8:	00491713          	slli	a4,s2,0x4
    800068fc:	0009b783          	ld	a5,0(s3)
    80006900:	97ba                	add	a5,a5,a4
    80006902:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006906:	854a                	mv	a0,s2
    80006908:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000690c:	00000097          	auipc	ra,0x0
    80006910:	b8e080e7          	jalr	-1138(ra) # 8000649a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006914:	8885                	andi	s1,s1,1
    80006916:	f0ed                	bnez	s1,800068f8 <virtio_disk_rw+0x1e0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006918:	0001c517          	auipc	a0,0x1c
    8000691c:	1f050513          	addi	a0,a0,496 # 80022b08 <disk+0x128>
    80006920:	ffffa097          	auipc	ra,0xffffa
    80006924:	3ce080e7          	jalr	974(ra) # 80000cee <release>
}
    80006928:	60e6                	ld	ra,88(sp)
    8000692a:	6446                	ld	s0,80(sp)
    8000692c:	64a6                	ld	s1,72(sp)
    8000692e:	6906                	ld	s2,64(sp)
    80006930:	79e2                	ld	s3,56(sp)
    80006932:	7a42                	ld	s4,48(sp)
    80006934:	7aa2                	ld	s5,40(sp)
    80006936:	7b02                	ld	s6,32(sp)
    80006938:	6be2                	ld	s7,24(sp)
    8000693a:	6c42                	ld	s8,16(sp)
    8000693c:	6125                	addi	sp,sp,96
    8000693e:	8082                	ret

0000000080006940 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006940:	1101                	addi	sp,sp,-32
    80006942:	ec06                	sd	ra,24(sp)
    80006944:	e822                	sd	s0,16(sp)
    80006946:	e426                	sd	s1,8(sp)
    80006948:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000694a:	0001c497          	auipc	s1,0x1c
    8000694e:	09648493          	addi	s1,s1,150 # 800229e0 <disk>
    80006952:	0001c517          	auipc	a0,0x1c
    80006956:	1b650513          	addi	a0,a0,438 # 80022b08 <disk+0x128>
    8000695a:	ffffa097          	auipc	ra,0xffffa
    8000695e:	2e4080e7          	jalr	740(ra) # 80000c3e <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006962:	100017b7          	lui	a5,0x10001
    80006966:	53bc                	lw	a5,96(a5)
    80006968:	8b8d                	andi	a5,a5,3
    8000696a:	10001737          	lui	a4,0x10001
    8000696e:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80006970:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006974:	689c                	ld	a5,16(s1)
    80006976:	0204d703          	lhu	a4,32(s1)
    8000697a:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    8000697e:	04f70863          	beq	a4,a5,800069ce <virtio_disk_intr+0x8e>
    __sync_synchronize();
    80006982:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006986:	6898                	ld	a4,16(s1)
    80006988:	0204d783          	lhu	a5,32(s1)
    8000698c:	8b9d                	andi	a5,a5,7
    8000698e:	078e                	slli	a5,a5,0x3
    80006990:	97ba                	add	a5,a5,a4
    80006992:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006994:	00278713          	addi	a4,a5,2
    80006998:	0712                	slli	a4,a4,0x4
    8000699a:	9726                	add	a4,a4,s1
    8000699c:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800069a0:	e721                	bnez	a4,800069e8 <virtio_disk_intr+0xa8>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800069a2:	0789                	addi	a5,a5,2
    800069a4:	0792                	slli	a5,a5,0x4
    800069a6:	97a6                	add	a5,a5,s1
    800069a8:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800069aa:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800069ae:	ffffc097          	auipc	ra,0xffffc
    800069b2:	c2a080e7          	jalr	-982(ra) # 800025d8 <wakeup>

    disk.used_idx += 1;
    800069b6:	0204d783          	lhu	a5,32(s1)
    800069ba:	2785                	addiw	a5,a5,1
    800069bc:	17c2                	slli	a5,a5,0x30
    800069be:	93c1                	srli	a5,a5,0x30
    800069c0:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800069c4:	6898                	ld	a4,16(s1)
    800069c6:	00275703          	lhu	a4,2(a4)
    800069ca:	faf71ce3          	bne	a4,a5,80006982 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    800069ce:	0001c517          	auipc	a0,0x1c
    800069d2:	13a50513          	addi	a0,a0,314 # 80022b08 <disk+0x128>
    800069d6:	ffffa097          	auipc	ra,0xffffa
    800069da:	318080e7          	jalr	792(ra) # 80000cee <release>
}
    800069de:	60e2                	ld	ra,24(sp)
    800069e0:	6442                	ld	s0,16(sp)
    800069e2:	64a2                	ld	s1,8(sp)
    800069e4:	6105                	addi	sp,sp,32
    800069e6:	8082                	ret
      panic("virtio_disk_intr status");
    800069e8:	00002517          	auipc	a0,0x2
    800069ec:	e1850513          	addi	a0,a0,-488 # 80008800 <etext+0x800>
    800069f0:	ffffa097          	auipc	ra,0xffffa
    800069f4:	b70080e7          	jalr	-1168(ra) # 80000560 <panic>
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
