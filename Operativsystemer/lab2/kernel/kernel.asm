
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	b6010113          	addi	sp,sp,-1184 # 80008b60 <stack0>
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
    80000054:	9d078793          	addi	a5,a5,-1584 # 80008a20 <timer_scratch>
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
    80000066:	2fe78793          	addi	a5,a5,766 # 80006360 <timervec>
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
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc76f>
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
    80000138:	80c080e7          	jalr	-2036(ra) # 80002940 <either_copyin>
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
    800001a0:	9c450513          	addi	a0,a0,-1596 # 80010b60 <cons>
    800001a4:	00001097          	auipc	ra,0x1
    800001a8:	a9a080e7          	jalr	-1382(ra) # 80000c3e <acquire>
    while (n > 0)
    {
        // wait until interrupt handler has put some
        // input into cons.buffer.
        while (cons.r == cons.w)
    800001ac:	00011497          	auipc	s1,0x11
    800001b0:	9b448493          	addi	s1,s1,-1612 # 80010b60 <cons>
            if (killed(myproc()))
            {
                release(&cons.lock);
                return -1;
            }
            sleep(&cons.r, &cons.lock);
    800001b4:	00011917          	auipc	s2,0x11
    800001b8:	a4490913          	addi	s2,s2,-1468 # 80010bf8 <cons+0x98>
    while (n > 0)
    800001bc:	0d305563          	blez	s3,80000286 <consoleread+0x106>
        while (cons.r == cons.w)
    800001c0:	0984a783          	lw	a5,152(s1)
    800001c4:	09c4a703          	lw	a4,156(s1)
    800001c8:	0af71a63          	bne	a4,a5,8000027c <consoleread+0xfc>
            if (killed(myproc()))
    800001cc:	00002097          	auipc	ra,0x2
    800001d0:	b3a080e7          	jalr	-1222(ra) # 80001d06 <myproc>
    800001d4:	00002097          	auipc	ra,0x2
    800001d8:	5bc080e7          	jalr	1468(ra) # 80002790 <killed>
    800001dc:	e52d                	bnez	a0,80000246 <consoleread+0xc6>
            sleep(&cons.r, &cons.lock);
    800001de:	85a6                	mv	a1,s1
    800001e0:	854a                	mv	a0,s2
    800001e2:	00002097          	auipc	ra,0x2
    800001e6:	306080e7          	jalr	774(ra) # 800024e8 <sleep>
        while (cons.r == cons.w)
    800001ea:	0984a783          	lw	a5,152(s1)
    800001ee:	09c4a703          	lw	a4,156(s1)
    800001f2:	fcf70de3          	beq	a4,a5,800001cc <consoleread+0x4c>
    800001f6:	ec5e                	sd	s7,24(sp)
        }

        c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001f8:	00011717          	auipc	a4,0x11
    800001fc:	96870713          	addi	a4,a4,-1688 # 80010b60 <cons>
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
    8000022e:	6c0080e7          	jalr	1728(ra) # 800028ea <either_copyout>
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
    8000024a:	91a50513          	addi	a0,a0,-1766 # 80010b60 <cons>
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
    80000274:	98f72423          	sw	a5,-1656(a4) # 80010bf8 <cons+0x98>
    80000278:	6be2                	ld	s7,24(sp)
    8000027a:	a031                	j	80000286 <consoleread+0x106>
    8000027c:	ec5e                	sd	s7,24(sp)
    8000027e:	bfad                	j	800001f8 <consoleread+0x78>
    80000280:	6be2                	ld	s7,24(sp)
    80000282:	a011                	j	80000286 <consoleread+0x106>
    80000284:	6be2                	ld	s7,24(sp)
    release(&cons.lock);
    80000286:	00011517          	auipc	a0,0x11
    8000028a:	8da50513          	addi	a0,a0,-1830 # 80010b60 <cons>
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
    800002f2:	87250513          	addi	a0,a0,-1934 # 80010b60 <cons>
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
    80000318:	682080e7          	jalr	1666(ra) # 80002996 <procdump>
            }
        }
        break;
    }

    release(&cons.lock);
    8000031c:	00011517          	auipc	a0,0x11
    80000320:	84450513          	addi	a0,a0,-1980 # 80010b60 <cons>
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
    80000342:	82270713          	addi	a4,a4,-2014 # 80010b60 <cons>
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
    8000036c:	7f878793          	addi	a5,a5,2040 # 80010b60 <cons>
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
    80000398:	8647a783          	lw	a5,-1948(a5) # 80010bf8 <cons+0x98>
    8000039c:	9f1d                	subw	a4,a4,a5
    8000039e:	08000793          	li	a5,128
    800003a2:	f6f71de3          	bne	a4,a5,8000031c <consoleintr+0x3a>
    800003a6:	a0c9                	j	80000468 <consoleintr+0x186>
    800003a8:	e84a                	sd	s2,16(sp)
    800003aa:	e44e                	sd	s3,8(sp)
        while (cons.e != cons.w &&
    800003ac:	00010717          	auipc	a4,0x10
    800003b0:	7b470713          	addi	a4,a4,1972 # 80010b60 <cons>
    800003b4:	0a072783          	lw	a5,160(a4)
    800003b8:	09c72703          	lw	a4,156(a4)
               cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n')
    800003bc:	00010497          	auipc	s1,0x10
    800003c0:	7a448493          	addi	s1,s1,1956 # 80010b60 <cons>
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
    8000040e:	75670713          	addi	a4,a4,1878 # 80010b60 <cons>
    80000412:	0a072783          	lw	a5,160(a4)
    80000416:	09c72703          	lw	a4,156(a4)
    8000041a:	f0f701e3          	beq	a4,a5,8000031c <consoleintr+0x3a>
            cons.e--;
    8000041e:	37fd                	addiw	a5,a5,-1
    80000420:	00010717          	auipc	a4,0x10
    80000424:	7ef72023          	sw	a5,2016(a4) # 80010c00 <cons+0xa0>
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
    8000044a:	71a78793          	addi	a5,a5,1818 # 80010b60 <cons>
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
    8000046c:	78c7aa23          	sw	a2,1940(a5) # 80010bfc <cons+0x9c>
                wakeup(&cons.r);
    80000470:	00010517          	auipc	a0,0x10
    80000474:	78850513          	addi	a0,a0,1928 # 80010bf8 <cons+0x98>
    80000478:	00002097          	auipc	ra,0x2
    8000047c:	0d4080e7          	jalr	212(ra) # 8000254c <wakeup>
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
    80000496:	6ce50513          	addi	a0,a0,1742 # 80010b60 <cons>
    8000049a:	00000097          	auipc	ra,0x0
    8000049e:	710080e7          	jalr	1808(ra) # 80000baa <initlock>

    uartinit();
    800004a2:	00000097          	auipc	ra,0x0
    800004a6:	344080e7          	jalr	836(ra) # 800007e6 <uartinit>

    // connect read and write system calls
    // to consoleread and consolewrite.
    devsw[CONSOLE].read = consoleread;
    800004aa:	00021797          	auipc	a5,0x21
    800004ae:	a4e78793          	addi	a5,a5,-1458 # 80020ef8 <devsw>
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
    80000570:	6a07aa23          	sw	zero,1716(a5) # 80010c20 <pr+0x18>
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
    800005a4:	44f72023          	sw	a5,1088(a4) # 800089e0 <panicked>
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
    800005ce:	656dad83          	lw	s11,1622(s11) # 80010c20 <pr+0x18>
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
    8000061e:	5ee50513          	addi	a0,a0,1518 # 80010c08 <pr>
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
    800007a6:	46650513          	addi	a0,a0,1126 # 80010c08 <pr>
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
    800007c2:	44a48493          	addi	s1,s1,1098 # 80010c08 <pr>
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
    8000082c:	40050513          	addi	a0,a0,1024 # 80010c28 <uart_tx_lock>
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
    80000858:	18c7a783          	lw	a5,396(a5) # 800089e0 <panicked>
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
    80000892:	15a7b783          	ld	a5,346(a5) # 800089e8 <uart_tx_r>
    80000896:	00008717          	auipc	a4,0x8
    8000089a:	15a73703          	ld	a4,346(a4) # 800089f0 <uart_tx_w>
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
    800008c0:	36ca8a93          	addi	s5,s5,876 # 80010c28 <uart_tx_lock>
    uart_tx_r += 1;
    800008c4:	00008497          	auipc	s1,0x8
    800008c8:	12448493          	addi	s1,s1,292 # 800089e8 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008cc:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008d0:	00008997          	auipc	s3,0x8
    800008d4:	12098993          	addi	s3,s3,288 # 800089f0 <uart_tx_w>
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
    800008f6:	c5a080e7          	jalr	-934(ra) # 8000254c <wakeup>
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
    80000934:	2f850513          	addi	a0,a0,760 # 80010c28 <uart_tx_lock>
    80000938:	00000097          	auipc	ra,0x0
    8000093c:	306080e7          	jalr	774(ra) # 80000c3e <acquire>
  if(panicked){
    80000940:	00008797          	auipc	a5,0x8
    80000944:	0a07a783          	lw	a5,160(a5) # 800089e0 <panicked>
    80000948:	e7c9                	bnez	a5,800009d2 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000094a:	00008717          	auipc	a4,0x8
    8000094e:	0a673703          	ld	a4,166(a4) # 800089f0 <uart_tx_w>
    80000952:	00008797          	auipc	a5,0x8
    80000956:	0967b783          	ld	a5,150(a5) # 800089e8 <uart_tx_r>
    8000095a:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000095e:	00010997          	auipc	s3,0x10
    80000962:	2ca98993          	addi	s3,s3,714 # 80010c28 <uart_tx_lock>
    80000966:	00008497          	auipc	s1,0x8
    8000096a:	08248493          	addi	s1,s1,130 # 800089e8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000096e:	00008917          	auipc	s2,0x8
    80000972:	08290913          	addi	s2,s2,130 # 800089f0 <uart_tx_w>
    80000976:	00e79f63          	bne	a5,a4,80000994 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000097a:	85ce                	mv	a1,s3
    8000097c:	8526                	mv	a0,s1
    8000097e:	00002097          	auipc	ra,0x2
    80000982:	b6a080e7          	jalr	-1174(ra) # 800024e8 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000986:	00093703          	ld	a4,0(s2)
    8000098a:	609c                	ld	a5,0(s1)
    8000098c:	02078793          	addi	a5,a5,32
    80000990:	fee785e3          	beq	a5,a4,8000097a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000994:	00010497          	auipc	s1,0x10
    80000998:	29448493          	addi	s1,s1,660 # 80010c28 <uart_tx_lock>
    8000099c:	01f77793          	andi	a5,a4,31
    800009a0:	97a6                	add	a5,a5,s1
    800009a2:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009a6:	0705                	addi	a4,a4,1
    800009a8:	00008797          	auipc	a5,0x8
    800009ac:	04e7b423          	sd	a4,72(a5) # 800089f0 <uart_tx_w>
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
    80000a22:	20a48493          	addi	s1,s1,522 # 80010c28 <uart_tx_lock>
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
    80000a64:	63078793          	addi	a5,a5,1584 # 80022090 <end>
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
    80000a84:	1e090913          	addi	s2,s2,480 # 80010c60 <kmem>
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
    80000b22:	14250513          	addi	a0,a0,322 # 80010c60 <kmem>
    80000b26:	00000097          	auipc	ra,0x0
    80000b2a:	084080e7          	jalr	132(ra) # 80000baa <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b2e:	45c5                	li	a1,17
    80000b30:	05ee                	slli	a1,a1,0x1b
    80000b32:	00021517          	auipc	a0,0x21
    80000b36:	55e50513          	addi	a0,a0,1374 # 80022090 <end>
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
    80000b58:	10c48493          	addi	s1,s1,268 # 80010c60 <kmem>
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
    80000b70:	0f450513          	addi	a0,a0,244 # 80010c60 <kmem>
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
    80000b9c:	0c850513          	addi	a0,a0,200 # 80010c60 <kmem>
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
    80000bdc:	10e080e7          	jalr	270(ra) # 80001ce6 <mycpu>
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
    80000c0e:	0dc080e7          	jalr	220(ra) # 80001ce6 <mycpu>
    80000c12:	5d3c                	lw	a5,120(a0)
    80000c14:	cf89                	beqz	a5,80000c2e <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c16:	00001097          	auipc	ra,0x1
    80000c1a:	0d0080e7          	jalr	208(ra) # 80001ce6 <mycpu>
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
    80000c32:	0b8080e7          	jalr	184(ra) # 80001ce6 <mycpu>
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
    80000c72:	078080e7          	jalr	120(ra) # 80001ce6 <mycpu>
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
    80000c9e:	04c080e7          	jalr	76(ra) # 80001ce6 <mycpu>
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
    80000db4:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdcf71>
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
    80000efc:	dda080e7          	jalr	-550(ra) # 80001cd2 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000f00:	00008717          	auipc	a4,0x8
    80000f04:	af870713          	addi	a4,a4,-1288 # 800089f8 <started>
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
    80000f18:	dbe080e7          	jalr	-578(ra) # 80001cd2 <cpuid>
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
    80000f3a:	ce6080e7          	jalr	-794(ra) # 80002c1c <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f3e:	00005097          	auipc	ra,0x5
    80000f42:	466080e7          	jalr	1126(ra) # 800063a4 <plicinithart>
  }

  scheduler();        
    80000f46:	00001097          	auipc	ra,0x1
    80000f4a:	45a080e7          	jalr	1114(ra) # 800023a0 <scheduler>
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
    80000faa:	c48080e7          	jalr	-952(ra) # 80001bee <procinit>
    trapinit();      // trap vectors
    80000fae:	00002097          	auipc	ra,0x2
    80000fb2:	c46080e7          	jalr	-954(ra) # 80002bf4 <trapinit>
    trapinithart();  // install kernel trap vector
    80000fb6:	00002097          	auipc	ra,0x2
    80000fba:	c66080e7          	jalr	-922(ra) # 80002c1c <trapinithart>
    plicinit();      // set up interrupt controller
    80000fbe:	00005097          	auipc	ra,0x5
    80000fc2:	3cc080e7          	jalr	972(ra) # 8000638a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000fc6:	00005097          	auipc	ra,0x5
    80000fca:	3de080e7          	jalr	990(ra) # 800063a4 <plicinithart>
    binit();         // buffer cache
    80000fce:	00002097          	auipc	ra,0x2
    80000fd2:	466080e7          	jalr	1126(ra) # 80003434 <binit>
    iinit();         // inode table
    80000fd6:	00003097          	auipc	ra,0x3
    80000fda:	af6080e7          	jalr	-1290(ra) # 80003acc <iinit>
    fileinit();      // file table
    80000fde:	00004097          	auipc	ra,0x4
    80000fe2:	ac8080e7          	jalr	-1336(ra) # 80004aa6 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000fe6:	00005097          	auipc	ra,0x5
    80000fea:	4c6080e7          	jalr	1222(ra) # 800064ac <virtio_disk_init>
    userinit();      // first user process
    80000fee:	00001097          	auipc	ra,0x1
    80000ff2:	ff8080e7          	jalr	-8(ra) # 80001fe6 <userinit>
    __sync_synchronize();
    80000ff6:	0330000f          	fence	rw,rw
    started = 1;
    80000ffa:	4785                	li	a5,1
    80000ffc:	00008717          	auipc	a4,0x8
    80001000:	9ef72e23          	sw	a5,-1540(a4) # 800089f8 <started>
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
    80001016:	9ee7b783          	ld	a5,-1554(a5) # 80008a00 <kernel_pagetable>
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
    800012ae:	89a080e7          	jalr	-1894(ra) # 80001b44 <proc_mapstacks>
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
    800012d4:	72a7b823          	sd	a0,1840(a5) # 80008a00 <kernel_pagetable>
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
    800018ac:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdcf70>
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
    800018ea:	39aa8a93          	addi	s5,s5,922 # 80010c80 <cpus>
    800018ee:	00779713          	slli	a4,a5,0x7
    800018f2:	00ea86b3          	add	a3,s5,a4
    800018f6:	0006b023          	sd	zero,0(a3) # fffffffffffff000 <end+0xffffffff7ffdcf70>
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
    8000190e:	7a648493          	addi	s1,s1,1958 # 800110b0 <proc>
        if (p->state == RUNNABLE)
    80001912:	498d                	li	s3,3
            p->state = RUNNING;
    80001914:	4b11                	li	s6,4
            c->proc = p;
    80001916:	079e                	slli	a5,a5,0x7
    80001918:	0000fa17          	auipc	s4,0xf
    8000191c:	368a0a13          	addi	s4,s4,872 # 80010c80 <cpus>
    80001920:	9a3e                	add	s4,s4,a5
    for (p = proc; p < &proc[NPROC]; p++)
    80001922:	00015917          	auipc	s2,0x15
    80001926:	38e90913          	addi	s2,s2,910 # 80016cb0 <tickslock>
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
    80001936:	17048493          	addi	s1,s1,368
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
    80001960:	22e080e7          	jalr	558(ra) # 80002b8a <swtch>
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

000000008000197e <mlfq_scheduler>:

void mlfq_scheduler(void)
{
    8000197e:	7159                	addi	sp,sp,-112
    80001980:	f486                	sd	ra,104(sp)
    80001982:	f0a2                	sd	s0,96(sp)
    80001984:	eca6                	sd	s1,88(sp)
    80001986:	e8ca                	sd	s2,80(sp)
    80001988:	e4ce                	sd	s3,72(sp)
    8000198a:	e0d2                	sd	s4,64(sp)
    8000198c:	fc56                	sd	s5,56(sp)
    8000198e:	f85a                	sd	s6,48(sp)
    80001990:	f45e                	sd	s7,40(sp)
    80001992:	f062                	sd	s8,32(sp)
    80001994:	ec66                	sd	s9,24(sp)
    80001996:	e86a                	sd	s10,16(sp)
    80001998:	1880                	addi	s0,sp,112
  asm volatile("mv %0, tp" : "=r" (x) );
    8000199a:	8b12                	mv	s6,tp
    int id = r_tp();
    8000199c:	2b01                	sext.w	s6,s6
    struct proc *p;
    struct cpu *c = mycpu();

    #define NQUEUE 4
    const int time_slice[NQUEUE] = {1, 2, 4, 8};
    8000199e:	4785                	li	a5,1
    800019a0:	f8f42823          	sw	a5,-112(s0)
    800019a4:	4789                	li	a5,2
    800019a6:	f8f42a23          	sw	a5,-108(s0)
    800019aa:	4791                	li	a5,4
    800019ac:	f8f42c23          	sw	a5,-104(s0)
    800019b0:	47a1                	li	a5,8
    800019b2:	f8f42e23          	sw	a5,-100(s0)

    c->proc = 0;
    800019b6:	007b1713          	slli	a4,s6,0x7
    800019ba:	0000f797          	auipc	a5,0xf
    800019be:	2c678793          	addi	a5,a5,710 # 80010c80 <cpus>
    800019c2:	97ba                	add	a5,a5,a4
    800019c4:	0007b023          	sd	zero,0(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800019c8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800019cc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800019d0:	10079073          	csrw	sstatus,a5
    intr_on();
    static int boost_counter = 0;
    boost_counter++;
    800019d4:	00007797          	auipc	a5,0x7
    800019d8:	0347a783          	lw	a5,52(a5) # 80008a08 <boost_counter.2>
    800019dc:	2785                	addiw	a5,a5,1
    if (boost_counter >= 100) {
    800019de:	06300713          	li	a4,99
    800019e2:	04f75463          	bge	a4,a5,80001a2a <mlfq_scheduler+0xac>
        boost_counter = 0;
    800019e6:	00007797          	auipc	a5,0x7
    800019ea:	0207a123          	sw	zero,34(a5) # 80008a08 <boost_counter.2>
        for (p = proc; p < &proc[NPROC]; p++) {
    800019ee:	0000f497          	auipc	s1,0xf
    800019f2:	6c248493          	addi	s1,s1,1730 # 800110b0 <proc>
    800019f6:	00015917          	auipc	s2,0x15
    800019fa:	2ba90913          	addi	s2,s2,698 # 80016cb0 <tickslock>
    800019fe:	a811                	j	80001a12 <mlfq_scheduler+0x94>
            acquire(&p->lock);
            if (p->state != UNUSED) {
                p->queue_level = 0;
                p->queue_ticks = 0;
            }
            release(&p->lock);
    80001a00:	8526                	mv	a0,s1
    80001a02:	fffff097          	auipc	ra,0xfffff
    80001a06:	2ec080e7          	jalr	748(ra) # 80000cee <release>
        for (p = proc; p < &proc[NPROC]; p++) {
    80001a0a:	17048493          	addi	s1,s1,368
    80001a0e:	03248263          	beq	s1,s2,80001a32 <mlfq_scheduler+0xb4>
            acquire(&p->lock);
    80001a12:	8526                	mv	a0,s1
    80001a14:	fffff097          	auipc	ra,0xfffff
    80001a18:	22a080e7          	jalr	554(ra) # 80000c3e <acquire>
            if (p->state != UNUSED) {
    80001a1c:	4c9c                	lw	a5,24(s1)
    80001a1e:	d3ed                	beqz	a5,80001a00 <mlfq_scheduler+0x82>
                p->queue_level = 0;
    80001a20:	1604a423          	sw	zero,360(s1)
                p->queue_ticks = 0;
    80001a24:	1604a623          	sw	zero,364(s1)
    80001a28:	bfe1                	j	80001a00 <mlfq_scheduler+0x82>
    boost_counter++;
    80001a2a:	00007717          	auipc	a4,0x7
    80001a2e:	fcf72f23          	sw	a5,-34(a4) # 80008a08 <boost_counter.2>
        for (p = proc; p < &proc[NPROC]; p++) {
    80001a32:	0000f497          	auipc	s1,0xf
    80001a36:	67e48493          	addi	s1,s1,1662 # 800110b0 <proc>
        }
    }
    for (p = proc; p < &proc[NPROC]; p++) {
        acquire(&p->lock);
        if (p->state == RUNNABLE && p->queue_level == 0) {
    80001a3a:	498d                	li	s3,3
    for (p = proc; p < &proc[NPROC]; p++) {
    80001a3c:	00015917          	auipc	s2,0x15
    80001a40:	27490913          	addi	s2,s2,628 # 80016cb0 <tickslock>
    80001a44:	a811                	j	80001a58 <mlfq_scheduler+0xda>
            p->queue_level = 0;
            p->queue_ticks = 0;
        }
        release(&p->lock);
    80001a46:	8526                	mv	a0,s1
    80001a48:	fffff097          	auipc	ra,0xfffff
    80001a4c:	2a6080e7          	jalr	678(ra) # 80000cee <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    80001a50:	17048493          	addi	s1,s1,368
    80001a54:	03248063          	beq	s1,s2,80001a74 <mlfq_scheduler+0xf6>
        acquire(&p->lock);
    80001a58:	8526                	mv	a0,s1
    80001a5a:	fffff097          	auipc	ra,0xfffff
    80001a5e:	1e4080e7          	jalr	484(ra) # 80000c3e <acquire>
        if (p->state == RUNNABLE && p->queue_level == 0) {
    80001a62:	4c9c                	lw	a5,24(s1)
    80001a64:	ff3791e3          	bne	a5,s3,80001a46 <mlfq_scheduler+0xc8>
    80001a68:	1684a783          	lw	a5,360(s1)
    80001a6c:	ffe9                	bnez	a5,80001a46 <mlfq_scheduler+0xc8>
            p->queue_ticks = 0;
    80001a6e:	1604a623          	sw	zero,364(s1)
    80001a72:	bfd1                	j	80001a46 <mlfq_scheduler+0xc8>
    80001a74:	f9040b93          	addi	s7,s0,-112
    }

    for (int level = 0; level < NQUEUE; level++) {
    80001a78:	4a81                	li	s5,0
        for (p = proc; p < &proc[NPROC]; p++) {
            acquire(&p->lock);
            if (p->state == RUNNABLE && p->queue_level == level) {
    80001a7a:	498d                	li	s3,3
                    p->queue_ticks = 0;
                }
            }
            release(&p->lock);

            if (c->proc != 0)
    80001a7c:	0000fc17          	auipc	s8,0xf
    80001a80:	204c0c13          	addi	s8,s8,516 # 80010c80 <cpus>
    80001a84:	0b1e                	slli	s6,s6,0x7
        for (p = proc; p < &proc[NPROC]; p++) {
    80001a86:	00015a17          	auipc	s4,0x15
    80001a8a:	22aa0a13          	addi	s4,s4,554 # 80016cb0 <tickslock>
                swtch(&c->context, &p->context);
    80001a8e:	008b0c93          	addi	s9,s6,8 # fffffffffffff008 <end+0xffffffff7ffdcf78>
    80001a92:	9ce2                	add	s9,s9,s8
    80001a94:	a059                	j	80001b1a <mlfq_scheduler+0x19c>
            release(&p->lock);
    80001a96:	8526                	mv	a0,s1
    80001a98:	fffff097          	auipc	ra,0xfffff
    80001a9c:	256080e7          	jalr	598(ra) # 80000cee <release>
            if (c->proc != 0)
    80001aa0:	00093783          	ld	a5,0(s2)
    80001aa4:	e3d1                	bnez	a5,80001b28 <mlfq_scheduler+0x1aa>
        for (p = proc; p < &proc[NPROC]; p++) {
    80001aa6:	17048493          	addi	s1,s1,368
    80001aaa:	07448363          	beq	s1,s4,80001b10 <mlfq_scheduler+0x192>
            acquire(&p->lock);
    80001aae:	8526                	mv	a0,s1
    80001ab0:	fffff097          	auipc	ra,0xfffff
    80001ab4:	18e080e7          	jalr	398(ra) # 80000c3e <acquire>
            if (p->state == RUNNABLE && p->queue_level == level) {
    80001ab8:	4c9c                	lw	a5,24(s1)
    80001aba:	fd379ee3          	bne	a5,s3,80001a96 <mlfq_scheduler+0x118>
    80001abe:	1684a783          	lw	a5,360(s1)
    80001ac2:	fd579ae3          	bne	a5,s5,80001a96 <mlfq_scheduler+0x118>
                p->state = RUNNING;
    80001ac6:	4791                	li	a5,4
    80001ac8:	cc9c                	sw	a5,24(s1)
                p->queue_ticks = 0;
    80001aca:	1604a623          	sw	zero,364(s1)
                c->proc = p;
    80001ace:	016c0d33          	add	s10,s8,s6
    80001ad2:	009d3023          	sd	s1,0(s10)
                swtch(&c->context, &p->context);
    80001ad6:	06048593          	addi	a1,s1,96
    80001ada:	8566                	mv	a0,s9
    80001adc:	00001097          	auipc	ra,0x1
    80001ae0:	0ae080e7          	jalr	174(ra) # 80002b8a <swtch>
                c->proc = 0;
    80001ae4:	000d3023          	sd	zero,0(s10)
                if (p->queue_ticks >= time_slice[level] && p->state == RUNNABLE && 
    80001ae8:	16c4a703          	lw	a4,364(s1)
    80001aec:	000ba783          	lw	a5,0(s7) # fffffffffffff000 <end+0xffffffff7ffdcf70>
    80001af0:	faf743e3          	blt	a4,a5,80001a96 <mlfq_scheduler+0x118>
    80001af4:	4c9c                	lw	a5,24(s1)
    80001af6:	fb3790e3          	bne	a5,s3,80001a96 <mlfq_scheduler+0x118>
    80001afa:	4789                	li	a5,2
    80001afc:	f957cde3          	blt	a5,s5,80001a96 <mlfq_scheduler+0x118>
                    p->queue_level++;
    80001b00:	1684a783          	lw	a5,360(s1)
    80001b04:	2785                	addiw	a5,a5,1
    80001b06:	16f4a423          	sw	a5,360(s1)
                    p->queue_ticks = 0;
    80001b0a:	1604a623          	sw	zero,364(s1)
    80001b0e:	b761                	j	80001a96 <mlfq_scheduler+0x118>
    for (int level = 0; level < NQUEUE; level++) {
    80001b10:	2a85                	addiw	s5,s5,1
    80001b12:	0b91                	addi	s7,s7,4
    80001b14:	4791                	li	a5,4
    80001b16:	00fa8963          	beq	s5,a5,80001b28 <mlfq_scheduler+0x1aa>
        for (p = proc; p < &proc[NPROC]; p++) {
    80001b1a:	0000f497          	auipc	s1,0xf
    80001b1e:	59648493          	addi	s1,s1,1430 # 800110b0 <proc>
            if (c->proc != 0)
    80001b22:	016c0933          	add	s2,s8,s6
    80001b26:	b761                	j	80001aae <mlfq_scheduler+0x130>
                break;
        }
        if (c->proc != 0)
            break;
    }
}
    80001b28:	70a6                	ld	ra,104(sp)
    80001b2a:	7406                	ld	s0,96(sp)
    80001b2c:	64e6                	ld	s1,88(sp)
    80001b2e:	6946                	ld	s2,80(sp)
    80001b30:	69a6                	ld	s3,72(sp)
    80001b32:	6a06                	ld	s4,64(sp)
    80001b34:	7ae2                	ld	s5,56(sp)
    80001b36:	7b42                	ld	s6,48(sp)
    80001b38:	7ba2                	ld	s7,40(sp)
    80001b3a:	7c02                	ld	s8,32(sp)
    80001b3c:	6ce2                	ld	s9,24(sp)
    80001b3e:	6d42                	ld	s10,16(sp)
    80001b40:	6165                	addi	sp,sp,112
    80001b42:	8082                	ret

0000000080001b44 <proc_mapstacks>:
{
    80001b44:	715d                	addi	sp,sp,-80
    80001b46:	e486                	sd	ra,72(sp)
    80001b48:	e0a2                	sd	s0,64(sp)
    80001b4a:	fc26                	sd	s1,56(sp)
    80001b4c:	f84a                	sd	s2,48(sp)
    80001b4e:	f44e                	sd	s3,40(sp)
    80001b50:	f052                	sd	s4,32(sp)
    80001b52:	ec56                	sd	s5,24(sp)
    80001b54:	e85a                	sd	s6,16(sp)
    80001b56:	e45e                	sd	s7,8(sp)
    80001b58:	e062                	sd	s8,0(sp)
    80001b5a:	0880                	addi	s0,sp,80
    80001b5c:	8a2a                	mv	s4,a0
    for (p = proc; p < &proc[NPROC]; p++)
    80001b5e:	0000f497          	auipc	s1,0xf
    80001b62:	55248493          	addi	s1,s1,1362 # 800110b0 <proc>
        uint64 va = KSTACK((int)(p - proc));
    80001b66:	8c26                	mv	s8,s1
    80001b68:	e9bd37b7          	lui	a5,0xe9bd3
    80001b6c:	7a778793          	addi	a5,a5,1959 # ffffffffe9bd37a7 <end+0xffffffff69bb1717>
    80001b70:	d37a7937          	lui	s2,0xd37a7
    80001b74:	f4e90913          	addi	s2,s2,-178 # ffffffffd37a6f4e <end+0xffffffff53784ebe>
    80001b78:	1902                	slli	s2,s2,0x20
    80001b7a:	993e                	add	s2,s2,a5
    80001b7c:	040009b7          	lui	s3,0x4000
    80001b80:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001b82:	09b2                	slli	s3,s3,0xc
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001b84:	4b99                	li	s7,6
    80001b86:	6b05                	lui	s6,0x1
    for (p = proc; p < &proc[NPROC]; p++)
    80001b88:	00015a97          	auipc	s5,0x15
    80001b8c:	128a8a93          	addi	s5,s5,296 # 80016cb0 <tickslock>
        char *pa = kalloc();
    80001b90:	fffff097          	auipc	ra,0xfffff
    80001b94:	fba080e7          	jalr	-70(ra) # 80000b4a <kalloc>
    80001b98:	862a                	mv	a2,a0
        if (pa == 0)
    80001b9a:	c131                	beqz	a0,80001bde <proc_mapstacks+0x9a>
        uint64 va = KSTACK((int)(p - proc));
    80001b9c:	418485b3          	sub	a1,s1,s8
    80001ba0:	8591                	srai	a1,a1,0x4
    80001ba2:	032585b3          	mul	a1,a1,s2
    80001ba6:	2585                	addiw	a1,a1,1
    80001ba8:	00d5959b          	slliw	a1,a1,0xd
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001bac:	875e                	mv	a4,s7
    80001bae:	86da                	mv	a3,s6
    80001bb0:	40b985b3          	sub	a1,s3,a1
    80001bb4:	8552                	mv	a0,s4
    80001bb6:	fffff097          	auipc	ra,0xfffff
    80001bba:	60a080e7          	jalr	1546(ra) # 800011c0 <kvmmap>
    for (p = proc; p < &proc[NPROC]; p++)
    80001bbe:	17048493          	addi	s1,s1,368
    80001bc2:	fd5497e3          	bne	s1,s5,80001b90 <proc_mapstacks+0x4c>
}
    80001bc6:	60a6                	ld	ra,72(sp)
    80001bc8:	6406                	ld	s0,64(sp)
    80001bca:	74e2                	ld	s1,56(sp)
    80001bcc:	7942                	ld	s2,48(sp)
    80001bce:	79a2                	ld	s3,40(sp)
    80001bd0:	7a02                	ld	s4,32(sp)
    80001bd2:	6ae2                	ld	s5,24(sp)
    80001bd4:	6b42                	ld	s6,16(sp)
    80001bd6:	6ba2                	ld	s7,8(sp)
    80001bd8:	6c02                	ld	s8,0(sp)
    80001bda:	6161                	addi	sp,sp,80
    80001bdc:	8082                	ret
            panic("kalloc");
    80001bde:	00006517          	auipc	a0,0x6
    80001be2:	5da50513          	addi	a0,a0,1498 # 800081b8 <etext+0x1b8>
    80001be6:	fffff097          	auipc	ra,0xfffff
    80001bea:	97a080e7          	jalr	-1670(ra) # 80000560 <panic>

0000000080001bee <procinit>:
{
    80001bee:	7139                	addi	sp,sp,-64
    80001bf0:	fc06                	sd	ra,56(sp)
    80001bf2:	f822                	sd	s0,48(sp)
    80001bf4:	f426                	sd	s1,40(sp)
    80001bf6:	f04a                	sd	s2,32(sp)
    80001bf8:	ec4e                	sd	s3,24(sp)
    80001bfa:	e852                	sd	s4,16(sp)
    80001bfc:	e456                	sd	s5,8(sp)
    80001bfe:	e05a                	sd	s6,0(sp)
    80001c00:	0080                	addi	s0,sp,64
    initlock(&pid_lock, "nextpid");
    80001c02:	00006597          	auipc	a1,0x6
    80001c06:	5be58593          	addi	a1,a1,1470 # 800081c0 <etext+0x1c0>
    80001c0a:	0000f517          	auipc	a0,0xf
    80001c0e:	47650513          	addi	a0,a0,1142 # 80011080 <pid_lock>
    80001c12:	fffff097          	auipc	ra,0xfffff
    80001c16:	f98080e7          	jalr	-104(ra) # 80000baa <initlock>
    initlock(&wait_lock, "wait_lock");
    80001c1a:	00006597          	auipc	a1,0x6
    80001c1e:	5ae58593          	addi	a1,a1,1454 # 800081c8 <etext+0x1c8>
    80001c22:	0000f517          	auipc	a0,0xf
    80001c26:	47650513          	addi	a0,a0,1142 # 80011098 <wait_lock>
    80001c2a:	fffff097          	auipc	ra,0xfffff
    80001c2e:	f80080e7          	jalr	-128(ra) # 80000baa <initlock>
    for (p = proc; p < &proc[NPROC]; p++)
    80001c32:	0000f497          	auipc	s1,0xf
    80001c36:	47e48493          	addi	s1,s1,1150 # 800110b0 <proc>
        initlock(&p->lock, "proc");
    80001c3a:	00006b17          	auipc	s6,0x6
    80001c3e:	59eb0b13          	addi	s6,s6,1438 # 800081d8 <etext+0x1d8>
        p->kstack = KSTACK((int)(p - proc));
    80001c42:	8aa6                	mv	s5,s1
    80001c44:	e9bd37b7          	lui	a5,0xe9bd3
    80001c48:	7a778793          	addi	a5,a5,1959 # ffffffffe9bd37a7 <end+0xffffffff69bb1717>
    80001c4c:	d37a7937          	lui	s2,0xd37a7
    80001c50:	f4e90913          	addi	s2,s2,-178 # ffffffffd37a6f4e <end+0xffffffff53784ebe>
    80001c54:	1902                	slli	s2,s2,0x20
    80001c56:	993e                	add	s2,s2,a5
    80001c58:	040009b7          	lui	s3,0x4000
    80001c5c:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001c5e:	09b2                	slli	s3,s3,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    80001c60:	00015a17          	auipc	s4,0x15
    80001c64:	050a0a13          	addi	s4,s4,80 # 80016cb0 <tickslock>
        initlock(&p->lock, "proc");
    80001c68:	85da                	mv	a1,s6
    80001c6a:	8526                	mv	a0,s1
    80001c6c:	fffff097          	auipc	ra,0xfffff
    80001c70:	f3e080e7          	jalr	-194(ra) # 80000baa <initlock>
        p->state = UNUSED;
    80001c74:	0004ac23          	sw	zero,24(s1)
        p->kstack = KSTACK((int)(p - proc));
    80001c78:	415487b3          	sub	a5,s1,s5
    80001c7c:	8791                	srai	a5,a5,0x4
    80001c7e:	032787b3          	mul	a5,a5,s2
    80001c82:	2785                	addiw	a5,a5,1
    80001c84:	00d7979b          	slliw	a5,a5,0xd
    80001c88:	40f987b3          	sub	a5,s3,a5
    80001c8c:	e0bc                	sd	a5,64(s1)
    for (p = proc; p < &proc[NPROC]; p++)
    80001c8e:	17048493          	addi	s1,s1,368
    80001c92:	fd449be3          	bne	s1,s4,80001c68 <procinit+0x7a>
}
    80001c96:	70e2                	ld	ra,56(sp)
    80001c98:	7442                	ld	s0,48(sp)
    80001c9a:	74a2                	ld	s1,40(sp)
    80001c9c:	7902                	ld	s2,32(sp)
    80001c9e:	69e2                	ld	s3,24(sp)
    80001ca0:	6a42                	ld	s4,16(sp)
    80001ca2:	6aa2                	ld	s5,8(sp)
    80001ca4:	6b02                	ld	s6,0(sp)
    80001ca6:	6121                	addi	sp,sp,64
    80001ca8:	8082                	ret

0000000080001caa <copy_array>:
{
    80001caa:	1141                	addi	sp,sp,-16
    80001cac:	e406                	sd	ra,8(sp)
    80001cae:	e022                	sd	s0,0(sp)
    80001cb0:	0800                	addi	s0,sp,16
    for (int i = 0; i < len; i++)
    80001cb2:	00c05c63          	blez	a2,80001cca <copy_array+0x20>
    80001cb6:	87aa                	mv	a5,a0
    80001cb8:	9532                	add	a0,a0,a2
        dst[i] = src[i];
    80001cba:	0007c703          	lbu	a4,0(a5)
    80001cbe:	00e58023          	sb	a4,0(a1)
    for (int i = 0; i < len; i++)
    80001cc2:	0785                	addi	a5,a5,1
    80001cc4:	0585                	addi	a1,a1,1
    80001cc6:	fea79ae3          	bne	a5,a0,80001cba <copy_array+0x10>
}
    80001cca:	60a2                	ld	ra,8(sp)
    80001ccc:	6402                	ld	s0,0(sp)
    80001cce:	0141                	addi	sp,sp,16
    80001cd0:	8082                	ret

0000000080001cd2 <cpuid>:
{
    80001cd2:	1141                	addi	sp,sp,-16
    80001cd4:	e406                	sd	ra,8(sp)
    80001cd6:	e022                	sd	s0,0(sp)
    80001cd8:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001cda:	8512                	mv	a0,tp
}
    80001cdc:	2501                	sext.w	a0,a0
    80001cde:	60a2                	ld	ra,8(sp)
    80001ce0:	6402                	ld	s0,0(sp)
    80001ce2:	0141                	addi	sp,sp,16
    80001ce4:	8082                	ret

0000000080001ce6 <mycpu>:
{
    80001ce6:	1141                	addi	sp,sp,-16
    80001ce8:	e406                	sd	ra,8(sp)
    80001cea:	e022                	sd	s0,0(sp)
    80001cec:	0800                	addi	s0,sp,16
    80001cee:	8792                	mv	a5,tp
    struct cpu *c = &cpus[id];
    80001cf0:	2781                	sext.w	a5,a5
    80001cf2:	079e                	slli	a5,a5,0x7
}
    80001cf4:	0000f517          	auipc	a0,0xf
    80001cf8:	f8c50513          	addi	a0,a0,-116 # 80010c80 <cpus>
    80001cfc:	953e                	add	a0,a0,a5
    80001cfe:	60a2                	ld	ra,8(sp)
    80001d00:	6402                	ld	s0,0(sp)
    80001d02:	0141                	addi	sp,sp,16
    80001d04:	8082                	ret

0000000080001d06 <myproc>:
{
    80001d06:	1101                	addi	sp,sp,-32
    80001d08:	ec06                	sd	ra,24(sp)
    80001d0a:	e822                	sd	s0,16(sp)
    80001d0c:	e426                	sd	s1,8(sp)
    80001d0e:	1000                	addi	s0,sp,32
    push_off();
    80001d10:	fffff097          	auipc	ra,0xfffff
    80001d14:	ee2080e7          	jalr	-286(ra) # 80000bf2 <push_off>
    80001d18:	8792                	mv	a5,tp
    struct proc *p = c->proc;
    80001d1a:	2781                	sext.w	a5,a5
    80001d1c:	079e                	slli	a5,a5,0x7
    80001d1e:	0000f717          	auipc	a4,0xf
    80001d22:	f6270713          	addi	a4,a4,-158 # 80010c80 <cpus>
    80001d26:	97ba                	add	a5,a5,a4
    80001d28:	6384                	ld	s1,0(a5)
    pop_off();
    80001d2a:	fffff097          	auipc	ra,0xfffff
    80001d2e:	f68080e7          	jalr	-152(ra) # 80000c92 <pop_off>
}
    80001d32:	8526                	mv	a0,s1
    80001d34:	60e2                	ld	ra,24(sp)
    80001d36:	6442                	ld	s0,16(sp)
    80001d38:	64a2                	ld	s1,8(sp)
    80001d3a:	6105                	addi	sp,sp,32
    80001d3c:	8082                	ret

0000000080001d3e <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80001d3e:	1141                	addi	sp,sp,-16
    80001d40:	e406                	sd	ra,8(sp)
    80001d42:	e022                	sd	s0,0(sp)
    80001d44:	0800                	addi	s0,sp,16
    static int first = 1;

    // Still holding p->lock from scheduler.
    release(&myproc()->lock);
    80001d46:	00000097          	auipc	ra,0x0
    80001d4a:	fc0080e7          	jalr	-64(ra) # 80001d06 <myproc>
    80001d4e:	fffff097          	auipc	ra,0xfffff
    80001d52:	fa0080e7          	jalr	-96(ra) # 80000cee <release>

    if (first)
    80001d56:	00007797          	auipc	a5,0x7
    80001d5a:	bea7a783          	lw	a5,-1046(a5) # 80008940 <first.1>
    80001d5e:	eb89                	bnez	a5,80001d70 <forkret+0x32>
        // be run from main().
        first = 0;
        fsinit(ROOTDEV);
    }

    usertrapret();
    80001d60:	00001097          	auipc	ra,0x1
    80001d64:	ed8080e7          	jalr	-296(ra) # 80002c38 <usertrapret>
}
    80001d68:	60a2                	ld	ra,8(sp)
    80001d6a:	6402                	ld	s0,0(sp)
    80001d6c:	0141                	addi	sp,sp,16
    80001d6e:	8082                	ret
        first = 0;
    80001d70:	00007797          	auipc	a5,0x7
    80001d74:	bc07a823          	sw	zero,-1072(a5) # 80008940 <first.1>
        fsinit(ROOTDEV);
    80001d78:	4505                	li	a0,1
    80001d7a:	00002097          	auipc	ra,0x2
    80001d7e:	cd2080e7          	jalr	-814(ra) # 80003a4c <fsinit>
    80001d82:	bff9                	j	80001d60 <forkret+0x22>

0000000080001d84 <allocpid>:
{
    80001d84:	1101                	addi	sp,sp,-32
    80001d86:	ec06                	sd	ra,24(sp)
    80001d88:	e822                	sd	s0,16(sp)
    80001d8a:	e426                	sd	s1,8(sp)
    80001d8c:	e04a                	sd	s2,0(sp)
    80001d8e:	1000                	addi	s0,sp,32
    acquire(&pid_lock);
    80001d90:	0000f917          	auipc	s2,0xf
    80001d94:	2f090913          	addi	s2,s2,752 # 80011080 <pid_lock>
    80001d98:	854a                	mv	a0,s2
    80001d9a:	fffff097          	auipc	ra,0xfffff
    80001d9e:	ea4080e7          	jalr	-348(ra) # 80000c3e <acquire>
    pid = nextpid;
    80001da2:	00007797          	auipc	a5,0x7
    80001da6:	bae78793          	addi	a5,a5,-1106 # 80008950 <nextpid>
    80001daa:	4384                	lw	s1,0(a5)
    nextpid = nextpid + 1;
    80001dac:	0014871b          	addiw	a4,s1,1
    80001db0:	c398                	sw	a4,0(a5)
    release(&pid_lock);
    80001db2:	854a                	mv	a0,s2
    80001db4:	fffff097          	auipc	ra,0xfffff
    80001db8:	f3a080e7          	jalr	-198(ra) # 80000cee <release>
}
    80001dbc:	8526                	mv	a0,s1
    80001dbe:	60e2                	ld	ra,24(sp)
    80001dc0:	6442                	ld	s0,16(sp)
    80001dc2:	64a2                	ld	s1,8(sp)
    80001dc4:	6902                	ld	s2,0(sp)
    80001dc6:	6105                	addi	sp,sp,32
    80001dc8:	8082                	ret

0000000080001dca <proc_pagetable>:
{
    80001dca:	1101                	addi	sp,sp,-32
    80001dcc:	ec06                	sd	ra,24(sp)
    80001dce:	e822                	sd	s0,16(sp)
    80001dd0:	e426                	sd	s1,8(sp)
    80001dd2:	e04a                	sd	s2,0(sp)
    80001dd4:	1000                	addi	s0,sp,32
    80001dd6:	892a                	mv	s2,a0
    pagetable = uvmcreate();
    80001dd8:	fffff097          	auipc	ra,0xfffff
    80001ddc:	5dc080e7          	jalr	1500(ra) # 800013b4 <uvmcreate>
    80001de0:	84aa                	mv	s1,a0
    if (pagetable == 0)
    80001de2:	c121                	beqz	a0,80001e22 <proc_pagetable+0x58>
    if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001de4:	4729                	li	a4,10
    80001de6:	00005697          	auipc	a3,0x5
    80001dea:	21a68693          	addi	a3,a3,538 # 80007000 <_trampoline>
    80001dee:	6605                	lui	a2,0x1
    80001df0:	040005b7          	lui	a1,0x4000
    80001df4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001df6:	05b2                	slli	a1,a1,0xc
    80001df8:	fffff097          	auipc	ra,0xfffff
    80001dfc:	322080e7          	jalr	802(ra) # 8000111a <mappages>
    80001e00:	02054863          	bltz	a0,80001e30 <proc_pagetable+0x66>
    if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80001e04:	4719                	li	a4,6
    80001e06:	05893683          	ld	a3,88(s2)
    80001e0a:	6605                	lui	a2,0x1
    80001e0c:	020005b7          	lui	a1,0x2000
    80001e10:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001e12:	05b6                	slli	a1,a1,0xd
    80001e14:	8526                	mv	a0,s1
    80001e16:	fffff097          	auipc	ra,0xfffff
    80001e1a:	304080e7          	jalr	772(ra) # 8000111a <mappages>
    80001e1e:	02054163          	bltz	a0,80001e40 <proc_pagetable+0x76>
}
    80001e22:	8526                	mv	a0,s1
    80001e24:	60e2                	ld	ra,24(sp)
    80001e26:	6442                	ld	s0,16(sp)
    80001e28:	64a2                	ld	s1,8(sp)
    80001e2a:	6902                	ld	s2,0(sp)
    80001e2c:	6105                	addi	sp,sp,32
    80001e2e:	8082                	ret
        uvmfree(pagetable, 0);
    80001e30:	4581                	li	a1,0
    80001e32:	8526                	mv	a0,s1
    80001e34:	fffff097          	auipc	ra,0xfffff
    80001e38:	79a080e7          	jalr	1946(ra) # 800015ce <uvmfree>
        return 0;
    80001e3c:	4481                	li	s1,0
    80001e3e:	b7d5                	j	80001e22 <proc_pagetable+0x58>
        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001e40:	4681                	li	a3,0
    80001e42:	4605                	li	a2,1
    80001e44:	040005b7          	lui	a1,0x4000
    80001e48:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001e4a:	05b2                	slli	a1,a1,0xc
    80001e4c:	8526                	mv	a0,s1
    80001e4e:	fffff097          	auipc	ra,0xfffff
    80001e52:	492080e7          	jalr	1170(ra) # 800012e0 <uvmunmap>
        uvmfree(pagetable, 0);
    80001e56:	4581                	li	a1,0
    80001e58:	8526                	mv	a0,s1
    80001e5a:	fffff097          	auipc	ra,0xfffff
    80001e5e:	774080e7          	jalr	1908(ra) # 800015ce <uvmfree>
        return 0;
    80001e62:	4481                	li	s1,0
    80001e64:	bf7d                	j	80001e22 <proc_pagetable+0x58>

0000000080001e66 <proc_freepagetable>:
{
    80001e66:	1101                	addi	sp,sp,-32
    80001e68:	ec06                	sd	ra,24(sp)
    80001e6a:	e822                	sd	s0,16(sp)
    80001e6c:	e426                	sd	s1,8(sp)
    80001e6e:	e04a                	sd	s2,0(sp)
    80001e70:	1000                	addi	s0,sp,32
    80001e72:	84aa                	mv	s1,a0
    80001e74:	892e                	mv	s2,a1
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001e76:	4681                	li	a3,0
    80001e78:	4605                	li	a2,1
    80001e7a:	040005b7          	lui	a1,0x4000
    80001e7e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001e80:	05b2                	slli	a1,a1,0xc
    80001e82:	fffff097          	auipc	ra,0xfffff
    80001e86:	45e080e7          	jalr	1118(ra) # 800012e0 <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001e8a:	4681                	li	a3,0
    80001e8c:	4605                	li	a2,1
    80001e8e:	020005b7          	lui	a1,0x2000
    80001e92:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001e94:	05b6                	slli	a1,a1,0xd
    80001e96:	8526                	mv	a0,s1
    80001e98:	fffff097          	auipc	ra,0xfffff
    80001e9c:	448080e7          	jalr	1096(ra) # 800012e0 <uvmunmap>
    uvmfree(pagetable, sz);
    80001ea0:	85ca                	mv	a1,s2
    80001ea2:	8526                	mv	a0,s1
    80001ea4:	fffff097          	auipc	ra,0xfffff
    80001ea8:	72a080e7          	jalr	1834(ra) # 800015ce <uvmfree>
}
    80001eac:	60e2                	ld	ra,24(sp)
    80001eae:	6442                	ld	s0,16(sp)
    80001eb0:	64a2                	ld	s1,8(sp)
    80001eb2:	6902                	ld	s2,0(sp)
    80001eb4:	6105                	addi	sp,sp,32
    80001eb6:	8082                	ret

0000000080001eb8 <freeproc>:
{
    80001eb8:	1101                	addi	sp,sp,-32
    80001eba:	ec06                	sd	ra,24(sp)
    80001ebc:	e822                	sd	s0,16(sp)
    80001ebe:	e426                	sd	s1,8(sp)
    80001ec0:	1000                	addi	s0,sp,32
    80001ec2:	84aa                	mv	s1,a0
    if (p->trapframe)
    80001ec4:	6d28                	ld	a0,88(a0)
    80001ec6:	c509                	beqz	a0,80001ed0 <freeproc+0x18>
        kfree((void *)p->trapframe);
    80001ec8:	fffff097          	auipc	ra,0xfffff
    80001ecc:	b84080e7          	jalr	-1148(ra) # 80000a4c <kfree>
    p->trapframe = 0;
    80001ed0:	0404bc23          	sd	zero,88(s1)
    if (p->pagetable)
    80001ed4:	68a8                	ld	a0,80(s1)
    80001ed6:	c511                	beqz	a0,80001ee2 <freeproc+0x2a>
        proc_freepagetable(p->pagetable, p->sz);
    80001ed8:	64ac                	ld	a1,72(s1)
    80001eda:	00000097          	auipc	ra,0x0
    80001ede:	f8c080e7          	jalr	-116(ra) # 80001e66 <proc_freepagetable>
    p->pagetable = 0;
    80001ee2:	0404b823          	sd	zero,80(s1)
    p->sz = 0;
    80001ee6:	0404b423          	sd	zero,72(s1)
    p->pid = 0;
    80001eea:	0204a823          	sw	zero,48(s1)
    p->parent = 0;
    80001eee:	0204bc23          	sd	zero,56(s1)
    p->name[0] = 0;
    80001ef2:	14048c23          	sb	zero,344(s1)
    p->chan = 0;
    80001ef6:	0204b023          	sd	zero,32(s1)
    p->killed = 0;
    80001efa:	0204a423          	sw	zero,40(s1)
    p->xstate = 0;
    80001efe:	0204a623          	sw	zero,44(s1)
    p->state = UNUSED;
    80001f02:	0004ac23          	sw	zero,24(s1)
}
    80001f06:	60e2                	ld	ra,24(sp)
    80001f08:	6442                	ld	s0,16(sp)
    80001f0a:	64a2                	ld	s1,8(sp)
    80001f0c:	6105                	addi	sp,sp,32
    80001f0e:	8082                	ret

0000000080001f10 <allocproc>:
{
    80001f10:	1101                	addi	sp,sp,-32
    80001f12:	ec06                	sd	ra,24(sp)
    80001f14:	e822                	sd	s0,16(sp)
    80001f16:	e426                	sd	s1,8(sp)
    80001f18:	e04a                	sd	s2,0(sp)
    80001f1a:	1000                	addi	s0,sp,32
    for (p = proc; p < &proc[NPROC]; p++)
    80001f1c:	0000f497          	auipc	s1,0xf
    80001f20:	19448493          	addi	s1,s1,404 # 800110b0 <proc>
    80001f24:	00015917          	auipc	s2,0x15
    80001f28:	d8c90913          	addi	s2,s2,-628 # 80016cb0 <tickslock>
        acquire(&p->lock);
    80001f2c:	8526                	mv	a0,s1
    80001f2e:	fffff097          	auipc	ra,0xfffff
    80001f32:	d10080e7          	jalr	-752(ra) # 80000c3e <acquire>
        if (p->state == UNUSED)
    80001f36:	4c9c                	lw	a5,24(s1)
    80001f38:	cf81                	beqz	a5,80001f50 <allocproc+0x40>
            release(&p->lock);
    80001f3a:	8526                	mv	a0,s1
    80001f3c:	fffff097          	auipc	ra,0xfffff
    80001f40:	db2080e7          	jalr	-590(ra) # 80000cee <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80001f44:	17048493          	addi	s1,s1,368
    80001f48:	ff2492e3          	bne	s1,s2,80001f2c <allocproc+0x1c>
    return 0;
    80001f4c:	4481                	li	s1,0
    80001f4e:	a8a9                	j	80001fa8 <allocproc+0x98>
    p->pid = allocpid();
    80001f50:	00000097          	auipc	ra,0x0
    80001f54:	e34080e7          	jalr	-460(ra) # 80001d84 <allocpid>
    80001f58:	d888                	sw	a0,48(s1)
    p->state = USED;
    80001f5a:	4785                	li	a5,1
    80001f5c:	cc9c                	sw	a5,24(s1)
    p->queue_level = 0;
    80001f5e:	1604a423          	sw	zero,360(s1)
    p->queue_ticks = 0;
    80001f62:	1604a623          	sw	zero,364(s1)
    if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    80001f66:	fffff097          	auipc	ra,0xfffff
    80001f6a:	be4080e7          	jalr	-1052(ra) # 80000b4a <kalloc>
    80001f6e:	892a                	mv	s2,a0
    80001f70:	eca8                	sd	a0,88(s1)
    80001f72:	c131                	beqz	a0,80001fb6 <allocproc+0xa6>
    p->pagetable = proc_pagetable(p);
    80001f74:	8526                	mv	a0,s1
    80001f76:	00000097          	auipc	ra,0x0
    80001f7a:	e54080e7          	jalr	-428(ra) # 80001dca <proc_pagetable>
    80001f7e:	892a                	mv	s2,a0
    80001f80:	e8a8                	sd	a0,80(s1)
    if (p->pagetable == 0)
    80001f82:	c531                	beqz	a0,80001fce <allocproc+0xbe>
    memset(&p->context, 0, sizeof(p->context));
    80001f84:	07000613          	li	a2,112
    80001f88:	4581                	li	a1,0
    80001f8a:	06048513          	addi	a0,s1,96
    80001f8e:	fffff097          	auipc	ra,0xfffff
    80001f92:	da8080e7          	jalr	-600(ra) # 80000d36 <memset>
    p->context.ra = (uint64)forkret;
    80001f96:	00000797          	auipc	a5,0x0
    80001f9a:	da878793          	addi	a5,a5,-600 # 80001d3e <forkret>
    80001f9e:	f0bc                	sd	a5,96(s1)
    p->context.sp = p->kstack + PGSIZE;
    80001fa0:	60bc                	ld	a5,64(s1)
    80001fa2:	6705                	lui	a4,0x1
    80001fa4:	97ba                	add	a5,a5,a4
    80001fa6:	f4bc                	sd	a5,104(s1)
}
    80001fa8:	8526                	mv	a0,s1
    80001faa:	60e2                	ld	ra,24(sp)
    80001fac:	6442                	ld	s0,16(sp)
    80001fae:	64a2                	ld	s1,8(sp)
    80001fb0:	6902                	ld	s2,0(sp)
    80001fb2:	6105                	addi	sp,sp,32
    80001fb4:	8082                	ret
        freeproc(p);
    80001fb6:	8526                	mv	a0,s1
    80001fb8:	00000097          	auipc	ra,0x0
    80001fbc:	f00080e7          	jalr	-256(ra) # 80001eb8 <freeproc>
        release(&p->lock);
    80001fc0:	8526                	mv	a0,s1
    80001fc2:	fffff097          	auipc	ra,0xfffff
    80001fc6:	d2c080e7          	jalr	-724(ra) # 80000cee <release>
        return 0;
    80001fca:	84ca                	mv	s1,s2
    80001fcc:	bff1                	j	80001fa8 <allocproc+0x98>
        freeproc(p);
    80001fce:	8526                	mv	a0,s1
    80001fd0:	00000097          	auipc	ra,0x0
    80001fd4:	ee8080e7          	jalr	-280(ra) # 80001eb8 <freeproc>
        release(&p->lock);
    80001fd8:	8526                	mv	a0,s1
    80001fda:	fffff097          	auipc	ra,0xfffff
    80001fde:	d14080e7          	jalr	-748(ra) # 80000cee <release>
        return 0;
    80001fe2:	84ca                	mv	s1,s2
    80001fe4:	b7d1                	j	80001fa8 <allocproc+0x98>

0000000080001fe6 <userinit>:
{
    80001fe6:	1101                	addi	sp,sp,-32
    80001fe8:	ec06                	sd	ra,24(sp)
    80001fea:	e822                	sd	s0,16(sp)
    80001fec:	e426                	sd	s1,8(sp)
    80001fee:	1000                	addi	s0,sp,32
    p = allocproc();
    80001ff0:	00000097          	auipc	ra,0x0
    80001ff4:	f20080e7          	jalr	-224(ra) # 80001f10 <allocproc>
    80001ff8:	84aa                	mv	s1,a0
    initproc = p;
    80001ffa:	00007797          	auipc	a5,0x7
    80001ffe:	a0a7bb23          	sd	a0,-1514(a5) # 80008a10 <initproc>
    uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80002002:	03400613          	li	a2,52
    80002006:	00007597          	auipc	a1,0x7
    8000200a:	95a58593          	addi	a1,a1,-1702 # 80008960 <initcode>
    8000200e:	6928                	ld	a0,80(a0)
    80002010:	fffff097          	auipc	ra,0xfffff
    80002014:	3d2080e7          	jalr	978(ra) # 800013e2 <uvmfirst>
    p->sz = PGSIZE;
    80002018:	6785                	lui	a5,0x1
    8000201a:	e4bc                	sd	a5,72(s1)
    p->trapframe->epc = 0;     // user program counter
    8000201c:	6cb8                	ld	a4,88(s1)
    8000201e:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    p->trapframe->sp = PGSIZE; // user stack pointer
    80002022:	6cb8                	ld	a4,88(s1)
    80002024:	fb1c                	sd	a5,48(a4)
    safestrcpy(p->name, "initcode", sizeof(p->name));
    80002026:	4641                	li	a2,16
    80002028:	00006597          	auipc	a1,0x6
    8000202c:	1b858593          	addi	a1,a1,440 # 800081e0 <etext+0x1e0>
    80002030:	15848513          	addi	a0,s1,344
    80002034:	fffff097          	auipc	ra,0xfffff
    80002038:	e58080e7          	jalr	-424(ra) # 80000e8c <safestrcpy>
    p->cwd = namei("/");
    8000203c:	00006517          	auipc	a0,0x6
    80002040:	1b450513          	addi	a0,a0,436 # 800081f0 <etext+0x1f0>
    80002044:	00002097          	auipc	ra,0x2
    80002048:	470080e7          	jalr	1136(ra) # 800044b4 <namei>
    8000204c:	14a4b823          	sd	a0,336(s1)
    p->state = RUNNABLE;
    80002050:	478d                	li	a5,3
    80002052:	cc9c                	sw	a5,24(s1)
    release(&p->lock);
    80002054:	8526                	mv	a0,s1
    80002056:	fffff097          	auipc	ra,0xfffff
    8000205a:	c98080e7          	jalr	-872(ra) # 80000cee <release>
}
    8000205e:	60e2                	ld	ra,24(sp)
    80002060:	6442                	ld	s0,16(sp)
    80002062:	64a2                	ld	s1,8(sp)
    80002064:	6105                	addi	sp,sp,32
    80002066:	8082                	ret

0000000080002068 <growproc>:
{
    80002068:	1101                	addi	sp,sp,-32
    8000206a:	ec06                	sd	ra,24(sp)
    8000206c:	e822                	sd	s0,16(sp)
    8000206e:	e426                	sd	s1,8(sp)
    80002070:	e04a                	sd	s2,0(sp)
    80002072:	1000                	addi	s0,sp,32
    80002074:	892a                	mv	s2,a0
    struct proc *p = myproc();
    80002076:	00000097          	auipc	ra,0x0
    8000207a:	c90080e7          	jalr	-880(ra) # 80001d06 <myproc>
    8000207e:	84aa                	mv	s1,a0
    sz = p->sz;
    80002080:	652c                	ld	a1,72(a0)
    if (n > 0)
    80002082:	01204c63          	bgtz	s2,8000209a <growproc+0x32>
    else if (n < 0)
    80002086:	02094663          	bltz	s2,800020b2 <growproc+0x4a>
    p->sz = sz;
    8000208a:	e4ac                	sd	a1,72(s1)
    return 0;
    8000208c:	4501                	li	a0,0
}
    8000208e:	60e2                	ld	ra,24(sp)
    80002090:	6442                	ld	s0,16(sp)
    80002092:	64a2                	ld	s1,8(sp)
    80002094:	6902                	ld	s2,0(sp)
    80002096:	6105                	addi	sp,sp,32
    80002098:	8082                	ret
        if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    8000209a:	4691                	li	a3,4
    8000209c:	00b90633          	add	a2,s2,a1
    800020a0:	6928                	ld	a0,80(a0)
    800020a2:	fffff097          	auipc	ra,0xfffff
    800020a6:	3fa080e7          	jalr	1018(ra) # 8000149c <uvmalloc>
    800020aa:	85aa                	mv	a1,a0
    800020ac:	fd79                	bnez	a0,8000208a <growproc+0x22>
            return -1;
    800020ae:	557d                	li	a0,-1
    800020b0:	bff9                	j	8000208e <growproc+0x26>
        sz = uvmdealloc(p->pagetable, sz, sz + n);
    800020b2:	00b90633          	add	a2,s2,a1
    800020b6:	6928                	ld	a0,80(a0)
    800020b8:	fffff097          	auipc	ra,0xfffff
    800020bc:	39c080e7          	jalr	924(ra) # 80001454 <uvmdealloc>
    800020c0:	85aa                	mv	a1,a0
    800020c2:	b7e1                	j	8000208a <growproc+0x22>

00000000800020c4 <ps>:
{
    800020c4:	711d                	addi	sp,sp,-96
    800020c6:	ec86                	sd	ra,88(sp)
    800020c8:	e8a2                	sd	s0,80(sp)
    800020ca:	e4a6                	sd	s1,72(sp)
    800020cc:	e0ca                	sd	s2,64(sp)
    800020ce:	fc4e                	sd	s3,56(sp)
    800020d0:	f852                	sd	s4,48(sp)
    800020d2:	f456                	sd	s5,40(sp)
    800020d4:	f05a                	sd	s6,32(sp)
    800020d6:	ec5e                	sd	s7,24(sp)
    800020d8:	e862                	sd	s8,16(sp)
    800020da:	e466                	sd	s9,8(sp)
    800020dc:	1080                	addi	s0,sp,96
    800020de:	84aa                	mv	s1,a0
    800020e0:	8a2e                	mv	s4,a1
    void *result = (void *)myproc()->sz;
    800020e2:	00000097          	auipc	ra,0x0
    800020e6:	c24080e7          	jalr	-988(ra) # 80001d06 <myproc>
        return result;
    800020ea:	4901                	li	s2,0
    if (count == 0)
    800020ec:	0c0a0563          	beqz	s4,800021b6 <ps+0xf2>
    void *result = (void *)myproc()->sz;
    800020f0:	04853b83          	ld	s7,72(a0)
    if (growproc(count * sizeof(struct user_proc)) < 0)
    800020f4:	003a151b          	slliw	a0,s4,0x3
    800020f8:	0145053b          	addw	a0,a0,s4
    800020fc:	050a                	slli	a0,a0,0x2
    800020fe:	00000097          	auipc	ra,0x0
    80002102:	f6a080e7          	jalr	-150(ra) # 80002068 <growproc>
    80002106:	14054163          	bltz	a0,80002248 <ps+0x184>
    struct user_proc loc_result[count];
    8000210a:	003a1a93          	slli	s5,s4,0x3
    8000210e:	9ad2                	add	s5,s5,s4
    80002110:	0a8a                	slli	s5,s5,0x2
    80002112:	00fa8793          	addi	a5,s5,15
    80002116:	8391                	srli	a5,a5,0x4
    80002118:	0792                	slli	a5,a5,0x4
    8000211a:	40f10133          	sub	sp,sp,a5
    8000211e:	8b0a                	mv	s6,sp
    struct proc *p = proc + start;
    80002120:	17000793          	li	a5,368
    80002124:	02f484b3          	mul	s1,s1,a5
    80002128:	0000f797          	auipc	a5,0xf
    8000212c:	f8878793          	addi	a5,a5,-120 # 800110b0 <proc>
    80002130:	94be                	add	s1,s1,a5
    if (p >= &proc[NPROC])
    80002132:	00015797          	auipc	a5,0x15
    80002136:	b7e78793          	addi	a5,a5,-1154 # 80016cb0 <tickslock>
        return result;
    8000213a:	4901                	li	s2,0
    if (p >= &proc[NPROC])
    8000213c:	06f4fd63          	bgeu	s1,a5,800021b6 <ps+0xf2>
    acquire(&wait_lock);
    80002140:	0000f517          	auipc	a0,0xf
    80002144:	f5850513          	addi	a0,a0,-168 # 80011098 <wait_lock>
    80002148:	fffff097          	auipc	ra,0xfffff
    8000214c:	af6080e7          	jalr	-1290(ra) # 80000c3e <acquire>
    for (; p < &proc[NPROC]; p++)
    80002150:	01410913          	addi	s2,sp,20
    uint8 localCount = 0;
    80002154:	4981                	li	s3,0
        copy_array(p->name, loc_result[localCount].name, 16);
    80002156:	4cc1                	li	s9,16
    for (; p < &proc[NPROC]; p++)
    80002158:	00015c17          	auipc	s8,0x15
    8000215c:	b58c0c13          	addi	s8,s8,-1192 # 80016cb0 <tickslock>
    80002160:	a07d                	j	8000220e <ps+0x14a>
            loc_result[localCount].state = UNUSED;
    80002162:	00399793          	slli	a5,s3,0x3
    80002166:	97ce                	add	a5,a5,s3
    80002168:	078a                	slli	a5,a5,0x2
    8000216a:	97da                	add	a5,a5,s6
    8000216c:	0007a023          	sw	zero,0(a5)
            release(&p->lock);
    80002170:	8526                	mv	a0,s1
    80002172:	fffff097          	auipc	ra,0xfffff
    80002176:	b7c080e7          	jalr	-1156(ra) # 80000cee <release>
    release(&wait_lock);
    8000217a:	0000f517          	auipc	a0,0xf
    8000217e:	f1e50513          	addi	a0,a0,-226 # 80011098 <wait_lock>
    80002182:	fffff097          	auipc	ra,0xfffff
    80002186:	b6c080e7          	jalr	-1172(ra) # 80000cee <release>
    if (localCount < count)
    8000218a:	0149f963          	bgeu	s3,s4,8000219c <ps+0xd8>
        loc_result[localCount].state = UNUSED; // if we reach the end of processes
    8000218e:	00399793          	slli	a5,s3,0x3
    80002192:	97ce                	add	a5,a5,s3
    80002194:	078a                	slli	a5,a5,0x2
    80002196:	97da                	add	a5,a5,s6
    80002198:	0007a023          	sw	zero,0(a5)
    void *result = (void *)myproc()->sz;
    8000219c:	895e                	mv	s2,s7
    copyout(myproc()->pagetable, (uint64)result, (void *)loc_result, count * sizeof(struct user_proc));
    8000219e:	00000097          	auipc	ra,0x0
    800021a2:	b68080e7          	jalr	-1176(ra) # 80001d06 <myproc>
    800021a6:	86d6                	mv	a3,s5
    800021a8:	865a                	mv	a2,s6
    800021aa:	85de                	mv	a1,s7
    800021ac:	6928                	ld	a0,80(a0)
    800021ae:	fffff097          	auipc	ra,0xfffff
    800021b2:	562080e7          	jalr	1378(ra) # 80001710 <copyout>
}
    800021b6:	854a                	mv	a0,s2
    800021b8:	fa040113          	addi	sp,s0,-96
    800021bc:	60e6                	ld	ra,88(sp)
    800021be:	6446                	ld	s0,80(sp)
    800021c0:	64a6                	ld	s1,72(sp)
    800021c2:	6906                	ld	s2,64(sp)
    800021c4:	79e2                	ld	s3,56(sp)
    800021c6:	7a42                	ld	s4,48(sp)
    800021c8:	7aa2                	ld	s5,40(sp)
    800021ca:	7b02                	ld	s6,32(sp)
    800021cc:	6be2                	ld	s7,24(sp)
    800021ce:	6c42                	ld	s8,16(sp)
    800021d0:	6ca2                	ld	s9,8(sp)
    800021d2:	6125                	addi	sp,sp,96
    800021d4:	8082                	ret
            acquire(&p->parent->lock);
    800021d6:	fffff097          	auipc	ra,0xfffff
    800021da:	a68080e7          	jalr	-1432(ra) # 80000c3e <acquire>
            loc_result[localCount].parent_id = p->parent->pid;
    800021de:	7c88                	ld	a0,56(s1)
    800021e0:	591c                	lw	a5,48(a0)
    800021e2:	fef92e23          	sw	a5,-4(s2)
            release(&p->parent->lock);
    800021e6:	fffff097          	auipc	ra,0xfffff
    800021ea:	b08080e7          	jalr	-1272(ra) # 80000cee <release>
        release(&p->lock);
    800021ee:	8526                	mv	a0,s1
    800021f0:	fffff097          	auipc	ra,0xfffff
    800021f4:	afe080e7          	jalr	-1282(ra) # 80000cee <release>
        localCount++;
    800021f8:	2985                	addiw	s3,s3,1
    800021fa:	0ff9f993          	zext.b	s3,s3
    for (; p < &proc[NPROC]; p++)
    800021fe:	17048493          	addi	s1,s1,368
    80002202:	f784fce3          	bgeu	s1,s8,8000217a <ps+0xb6>
        if (localCount == count)
    80002206:	02490913          	addi	s2,s2,36
    8000220a:	053a0163          	beq	s4,s3,8000224c <ps+0x188>
        acquire(&p->lock);
    8000220e:	8526                	mv	a0,s1
    80002210:	fffff097          	auipc	ra,0xfffff
    80002214:	a2e080e7          	jalr	-1490(ra) # 80000c3e <acquire>
        if (p->state == UNUSED)
    80002218:	4c9c                	lw	a5,24(s1)
    8000221a:	d7a1                	beqz	a5,80002162 <ps+0x9e>
        loc_result[localCount].state = p->state;
    8000221c:	fef92623          	sw	a5,-20(s2)
        loc_result[localCount].killed = p->killed;
    80002220:	549c                	lw	a5,40(s1)
    80002222:	fef92823          	sw	a5,-16(s2)
        loc_result[localCount].xstate = p->xstate;
    80002226:	54dc                	lw	a5,44(s1)
    80002228:	fef92a23          	sw	a5,-12(s2)
        loc_result[localCount].pid = p->pid;
    8000222c:	589c                	lw	a5,48(s1)
    8000222e:	fef92c23          	sw	a5,-8(s2)
        copy_array(p->name, loc_result[localCount].name, 16);
    80002232:	8666                	mv	a2,s9
    80002234:	85ca                	mv	a1,s2
    80002236:	15848513          	addi	a0,s1,344
    8000223a:	00000097          	auipc	ra,0x0
    8000223e:	a70080e7          	jalr	-1424(ra) # 80001caa <copy_array>
        if (p->parent != 0) // init
    80002242:	7c88                	ld	a0,56(s1)
    80002244:	f949                	bnez	a0,800021d6 <ps+0x112>
    80002246:	b765                	j	800021ee <ps+0x12a>
        return result;
    80002248:	4901                	li	s2,0
    8000224a:	b7b5                	j	800021b6 <ps+0xf2>
    release(&wait_lock);
    8000224c:	0000f517          	auipc	a0,0xf
    80002250:	e4c50513          	addi	a0,a0,-436 # 80011098 <wait_lock>
    80002254:	fffff097          	auipc	ra,0xfffff
    80002258:	a9a080e7          	jalr	-1382(ra) # 80000cee <release>
    if (localCount < count)
    8000225c:	b781                	j	8000219c <ps+0xd8>

000000008000225e <fork>:
{
    8000225e:	7139                	addi	sp,sp,-64
    80002260:	fc06                	sd	ra,56(sp)
    80002262:	f822                	sd	s0,48(sp)
    80002264:	f04a                	sd	s2,32(sp)
    80002266:	e456                	sd	s5,8(sp)
    80002268:	0080                	addi	s0,sp,64
    struct proc *p = myproc();
    8000226a:	00000097          	auipc	ra,0x0
    8000226e:	a9c080e7          	jalr	-1380(ra) # 80001d06 <myproc>
    80002272:	8aaa                	mv	s5,a0
    if ((np = allocproc()) == 0)
    80002274:	00000097          	auipc	ra,0x0
    80002278:	c9c080e7          	jalr	-868(ra) # 80001f10 <allocproc>
    8000227c:	12050063          	beqz	a0,8000239c <fork+0x13e>
    80002280:	e852                	sd	s4,16(sp)
    80002282:	8a2a                	mv	s4,a0
    if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    80002284:	048ab603          	ld	a2,72(s5)
    80002288:	692c                	ld	a1,80(a0)
    8000228a:	050ab503          	ld	a0,80(s5)
    8000228e:	fffff097          	auipc	ra,0xfffff
    80002292:	37a080e7          	jalr	890(ra) # 80001608 <uvmcopy>
    80002296:	04054a63          	bltz	a0,800022ea <fork+0x8c>
    8000229a:	f426                	sd	s1,40(sp)
    8000229c:	ec4e                	sd	s3,24(sp)
    np->sz = p->sz;
    8000229e:	048ab783          	ld	a5,72(s5)
    800022a2:	04fa3423          	sd	a5,72(s4)
    *(np->trapframe) = *(p->trapframe);
    800022a6:	058ab683          	ld	a3,88(s5)
    800022aa:	87b6                	mv	a5,a3
    800022ac:	058a3703          	ld	a4,88(s4)
    800022b0:	12068693          	addi	a3,a3,288
    800022b4:	0007b803          	ld	a6,0(a5)
    800022b8:	6788                	ld	a0,8(a5)
    800022ba:	6b8c                	ld	a1,16(a5)
    800022bc:	6f90                	ld	a2,24(a5)
    800022be:	01073023          	sd	a6,0(a4)
    800022c2:	e708                	sd	a0,8(a4)
    800022c4:	eb0c                	sd	a1,16(a4)
    800022c6:	ef10                	sd	a2,24(a4)
    800022c8:	02078793          	addi	a5,a5,32
    800022cc:	02070713          	addi	a4,a4,32
    800022d0:	fed792e3          	bne	a5,a3,800022b4 <fork+0x56>
    np->trapframe->a0 = 0;
    800022d4:	058a3783          	ld	a5,88(s4)
    800022d8:	0607b823          	sd	zero,112(a5)
    for (i = 0; i < NOFILE; i++)
    800022dc:	0d0a8493          	addi	s1,s5,208
    800022e0:	0d0a0913          	addi	s2,s4,208
    800022e4:	150a8993          	addi	s3,s5,336
    800022e8:	a015                	j	8000230c <fork+0xae>
        freeproc(np);
    800022ea:	8552                	mv	a0,s4
    800022ec:	00000097          	auipc	ra,0x0
    800022f0:	bcc080e7          	jalr	-1076(ra) # 80001eb8 <freeproc>
        release(&np->lock);
    800022f4:	8552                	mv	a0,s4
    800022f6:	fffff097          	auipc	ra,0xfffff
    800022fa:	9f8080e7          	jalr	-1544(ra) # 80000cee <release>
        return -1;
    800022fe:	597d                	li	s2,-1
    80002300:	6a42                	ld	s4,16(sp)
    80002302:	a071                	j	8000238e <fork+0x130>
    for (i = 0; i < NOFILE; i++)
    80002304:	04a1                	addi	s1,s1,8
    80002306:	0921                	addi	s2,s2,8
    80002308:	01348b63          	beq	s1,s3,8000231e <fork+0xc0>
        if (p->ofile[i])
    8000230c:	6088                	ld	a0,0(s1)
    8000230e:	d97d                	beqz	a0,80002304 <fork+0xa6>
            np->ofile[i] = filedup(p->ofile[i]);
    80002310:	00003097          	auipc	ra,0x3
    80002314:	828080e7          	jalr	-2008(ra) # 80004b38 <filedup>
    80002318:	00a93023          	sd	a0,0(s2)
    8000231c:	b7e5                	j	80002304 <fork+0xa6>
    np->cwd = idup(p->cwd);
    8000231e:	150ab503          	ld	a0,336(s5)
    80002322:	00002097          	auipc	ra,0x2
    80002326:	970080e7          	jalr	-1680(ra) # 80003c92 <idup>
    8000232a:	14aa3823          	sd	a0,336(s4)
    safestrcpy(np->name, p->name, sizeof(p->name));
    8000232e:	4641                	li	a2,16
    80002330:	158a8593          	addi	a1,s5,344
    80002334:	158a0513          	addi	a0,s4,344
    80002338:	fffff097          	auipc	ra,0xfffff
    8000233c:	b54080e7          	jalr	-1196(ra) # 80000e8c <safestrcpy>
    pid = np->pid;
    80002340:	030a2903          	lw	s2,48(s4)
    release(&np->lock);
    80002344:	8552                	mv	a0,s4
    80002346:	fffff097          	auipc	ra,0xfffff
    8000234a:	9a8080e7          	jalr	-1624(ra) # 80000cee <release>
    acquire(&wait_lock);
    8000234e:	0000f497          	auipc	s1,0xf
    80002352:	d4a48493          	addi	s1,s1,-694 # 80011098 <wait_lock>
    80002356:	8526                	mv	a0,s1
    80002358:	fffff097          	auipc	ra,0xfffff
    8000235c:	8e6080e7          	jalr	-1818(ra) # 80000c3e <acquire>
    np->parent = p;
    80002360:	035a3c23          	sd	s5,56(s4)
    release(&wait_lock);
    80002364:	8526                	mv	a0,s1
    80002366:	fffff097          	auipc	ra,0xfffff
    8000236a:	988080e7          	jalr	-1656(ra) # 80000cee <release>
    acquire(&np->lock);
    8000236e:	8552                	mv	a0,s4
    80002370:	fffff097          	auipc	ra,0xfffff
    80002374:	8ce080e7          	jalr	-1842(ra) # 80000c3e <acquire>
    np->state = RUNNABLE;
    80002378:	478d                	li	a5,3
    8000237a:	00fa2c23          	sw	a5,24(s4)
    release(&np->lock);
    8000237e:	8552                	mv	a0,s4
    80002380:	fffff097          	auipc	ra,0xfffff
    80002384:	96e080e7          	jalr	-1682(ra) # 80000cee <release>
    return pid;
    80002388:	74a2                	ld	s1,40(sp)
    8000238a:	69e2                	ld	s3,24(sp)
    8000238c:	6a42                	ld	s4,16(sp)
}
    8000238e:	854a                	mv	a0,s2
    80002390:	70e2                	ld	ra,56(sp)
    80002392:	7442                	ld	s0,48(sp)
    80002394:	7902                	ld	s2,32(sp)
    80002396:	6aa2                	ld	s5,8(sp)
    80002398:	6121                	addi	sp,sp,64
    8000239a:	8082                	ret
        return -1;
    8000239c:	597d                	li	s2,-1
    8000239e:	bfc5                	j	8000238e <fork+0x130>

00000000800023a0 <scheduler>:
{
    800023a0:	1101                	addi	sp,sp,-32
    800023a2:	ec06                	sd	ra,24(sp)
    800023a4:	e822                	sd	s0,16(sp)
    800023a6:	e426                	sd	s1,8(sp)
    800023a8:	e04a                	sd	s2,0(sp)
    800023aa:	1000                	addi	s0,sp,32
    void (*old_scheduler)(void) = sched_pointer;
    800023ac:	00006797          	auipc	a5,0x6
    800023b0:	59c7b783          	ld	a5,1436(a5) # 80008948 <sched_pointer>
        if (old_scheduler != sched_pointer)
    800023b4:	00006497          	auipc	s1,0x6
    800023b8:	59448493          	addi	s1,s1,1428 # 80008948 <sched_pointer>
            printf("Scheduler switched\n");
    800023bc:	00006917          	auipc	s2,0x6
    800023c0:	e3c90913          	addi	s2,s2,-452 # 800081f8 <etext+0x1f8>
    800023c4:	a021                	j	800023cc <scheduler+0x2c>
        (*sched_pointer)();
    800023c6:	609c                	ld	a5,0(s1)
    800023c8:	9782                	jalr	a5
        old_scheduler = sched_pointer;
    800023ca:	609c                	ld	a5,0(s1)
        if (old_scheduler != sched_pointer)
    800023cc:	6098                	ld	a4,0(s1)
    800023ce:	fef70ce3          	beq	a4,a5,800023c6 <scheduler+0x26>
            printf("Scheduler switched\n");
    800023d2:	854a                	mv	a0,s2
    800023d4:	ffffe097          	auipc	ra,0xffffe
    800023d8:	1d6080e7          	jalr	470(ra) # 800005aa <printf>
    800023dc:	b7ed                	j	800023c6 <scheduler+0x26>

00000000800023de <sched>:
{
    800023de:	7179                	addi	sp,sp,-48
    800023e0:	f406                	sd	ra,40(sp)
    800023e2:	f022                	sd	s0,32(sp)
    800023e4:	ec26                	sd	s1,24(sp)
    800023e6:	e84a                	sd	s2,16(sp)
    800023e8:	e44e                	sd	s3,8(sp)
    800023ea:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    800023ec:	00000097          	auipc	ra,0x0
    800023f0:	91a080e7          	jalr	-1766(ra) # 80001d06 <myproc>
    800023f4:	84aa                	mv	s1,a0
    if (!holding(&p->lock))
    800023f6:	ffffe097          	auipc	ra,0xffffe
    800023fa:	7ce080e7          	jalr	1998(ra) # 80000bc4 <holding>
    800023fe:	c53d                	beqz	a0,8000246c <sched+0x8e>
    80002400:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    80002402:	2781                	sext.w	a5,a5
    80002404:	079e                	slli	a5,a5,0x7
    80002406:	0000f717          	auipc	a4,0xf
    8000240a:	87a70713          	addi	a4,a4,-1926 # 80010c80 <cpus>
    8000240e:	97ba                	add	a5,a5,a4
    80002410:	5fb8                	lw	a4,120(a5)
    80002412:	4785                	li	a5,1
    80002414:	06f71463          	bne	a4,a5,8000247c <sched+0x9e>
    if (p->state == RUNNING)
    80002418:	4c98                	lw	a4,24(s1)
    8000241a:	4791                	li	a5,4
    8000241c:	06f70863          	beq	a4,a5,8000248c <sched+0xae>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002420:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002424:	8b89                	andi	a5,a5,2
    if (intr_get())
    80002426:	ebbd                	bnez	a5,8000249c <sched+0xbe>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002428:	8792                	mv	a5,tp
    intena = mycpu()->intena;
    8000242a:	0000f917          	auipc	s2,0xf
    8000242e:	85690913          	addi	s2,s2,-1962 # 80010c80 <cpus>
    80002432:	2781                	sext.w	a5,a5
    80002434:	079e                	slli	a5,a5,0x7
    80002436:	97ca                	add	a5,a5,s2
    80002438:	07c7a983          	lw	s3,124(a5)
    8000243c:	8592                	mv	a1,tp
    swtch(&p->context, &mycpu()->context);
    8000243e:	2581                	sext.w	a1,a1
    80002440:	059e                	slli	a1,a1,0x7
    80002442:	05a1                	addi	a1,a1,8
    80002444:	95ca                	add	a1,a1,s2
    80002446:	06048513          	addi	a0,s1,96
    8000244a:	00000097          	auipc	ra,0x0
    8000244e:	740080e7          	jalr	1856(ra) # 80002b8a <swtch>
    80002452:	8792                	mv	a5,tp
    mycpu()->intena = intena;
    80002454:	2781                	sext.w	a5,a5
    80002456:	079e                	slli	a5,a5,0x7
    80002458:	993e                	add	s2,s2,a5
    8000245a:	07392e23          	sw	s3,124(s2)
}
    8000245e:	70a2                	ld	ra,40(sp)
    80002460:	7402                	ld	s0,32(sp)
    80002462:	64e2                	ld	s1,24(sp)
    80002464:	6942                	ld	s2,16(sp)
    80002466:	69a2                	ld	s3,8(sp)
    80002468:	6145                	addi	sp,sp,48
    8000246a:	8082                	ret
        panic("sched p->lock");
    8000246c:	00006517          	auipc	a0,0x6
    80002470:	da450513          	addi	a0,a0,-604 # 80008210 <etext+0x210>
    80002474:	ffffe097          	auipc	ra,0xffffe
    80002478:	0ec080e7          	jalr	236(ra) # 80000560 <panic>
        panic("sched locks");
    8000247c:	00006517          	auipc	a0,0x6
    80002480:	da450513          	addi	a0,a0,-604 # 80008220 <etext+0x220>
    80002484:	ffffe097          	auipc	ra,0xffffe
    80002488:	0dc080e7          	jalr	220(ra) # 80000560 <panic>
        panic("sched running");
    8000248c:	00006517          	auipc	a0,0x6
    80002490:	da450513          	addi	a0,a0,-604 # 80008230 <etext+0x230>
    80002494:	ffffe097          	auipc	ra,0xffffe
    80002498:	0cc080e7          	jalr	204(ra) # 80000560 <panic>
        panic("sched interruptible");
    8000249c:	00006517          	auipc	a0,0x6
    800024a0:	da450513          	addi	a0,a0,-604 # 80008240 <etext+0x240>
    800024a4:	ffffe097          	auipc	ra,0xffffe
    800024a8:	0bc080e7          	jalr	188(ra) # 80000560 <panic>

00000000800024ac <yield>:
{
    800024ac:	1101                	addi	sp,sp,-32
    800024ae:	ec06                	sd	ra,24(sp)
    800024b0:	e822                	sd	s0,16(sp)
    800024b2:	e426                	sd	s1,8(sp)
    800024b4:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    800024b6:	00000097          	auipc	ra,0x0
    800024ba:	850080e7          	jalr	-1968(ra) # 80001d06 <myproc>
    800024be:	84aa                	mv	s1,a0
    acquire(&p->lock);
    800024c0:	ffffe097          	auipc	ra,0xffffe
    800024c4:	77e080e7          	jalr	1918(ra) # 80000c3e <acquire>
    p->state = RUNNABLE;
    800024c8:	478d                	li	a5,3
    800024ca:	cc9c                	sw	a5,24(s1)
    sched();
    800024cc:	00000097          	auipc	ra,0x0
    800024d0:	f12080e7          	jalr	-238(ra) # 800023de <sched>
    release(&p->lock);
    800024d4:	8526                	mv	a0,s1
    800024d6:	fffff097          	auipc	ra,0xfffff
    800024da:	818080e7          	jalr	-2024(ra) # 80000cee <release>
}
    800024de:	60e2                	ld	ra,24(sp)
    800024e0:	6442                	ld	s0,16(sp)
    800024e2:	64a2                	ld	s1,8(sp)
    800024e4:	6105                	addi	sp,sp,32
    800024e6:	8082                	ret

00000000800024e8 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    800024e8:	7179                	addi	sp,sp,-48
    800024ea:	f406                	sd	ra,40(sp)
    800024ec:	f022                	sd	s0,32(sp)
    800024ee:	ec26                	sd	s1,24(sp)
    800024f0:	e84a                	sd	s2,16(sp)
    800024f2:	e44e                	sd	s3,8(sp)
    800024f4:	1800                	addi	s0,sp,48
    800024f6:	89aa                	mv	s3,a0
    800024f8:	892e                	mv	s2,a1
    struct proc *p = myproc();
    800024fa:	00000097          	auipc	ra,0x0
    800024fe:	80c080e7          	jalr	-2036(ra) # 80001d06 <myproc>
    80002502:	84aa                	mv	s1,a0
    // Once we hold p->lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup locks p->lock),
    // so it's okay to release lk.

    acquire(&p->lock); // DOC: sleeplock1
    80002504:	ffffe097          	auipc	ra,0xffffe
    80002508:	73a080e7          	jalr	1850(ra) # 80000c3e <acquire>
    release(lk);
    8000250c:	854a                	mv	a0,s2
    8000250e:	ffffe097          	auipc	ra,0xffffe
    80002512:	7e0080e7          	jalr	2016(ra) # 80000cee <release>

    // Go to sleep.
    p->chan = chan;
    80002516:	0334b023          	sd	s3,32(s1)
    p->state = SLEEPING;
    8000251a:	4789                	li	a5,2
    8000251c:	cc9c                	sw	a5,24(s1)

    sched();
    8000251e:	00000097          	auipc	ra,0x0
    80002522:	ec0080e7          	jalr	-320(ra) # 800023de <sched>

    // Tidy up.
    p->chan = 0;
    80002526:	0204b023          	sd	zero,32(s1)

    // Reacquire original lock.
    release(&p->lock);
    8000252a:	8526                	mv	a0,s1
    8000252c:	ffffe097          	auipc	ra,0xffffe
    80002530:	7c2080e7          	jalr	1986(ra) # 80000cee <release>
    acquire(lk);
    80002534:	854a                	mv	a0,s2
    80002536:	ffffe097          	auipc	ra,0xffffe
    8000253a:	708080e7          	jalr	1800(ra) # 80000c3e <acquire>
}
    8000253e:	70a2                	ld	ra,40(sp)
    80002540:	7402                	ld	s0,32(sp)
    80002542:	64e2                	ld	s1,24(sp)
    80002544:	6942                	ld	s2,16(sp)
    80002546:	69a2                	ld	s3,8(sp)
    80002548:	6145                	addi	sp,sp,48
    8000254a:	8082                	ret

000000008000254c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    8000254c:	7139                	addi	sp,sp,-64
    8000254e:	fc06                	sd	ra,56(sp)
    80002550:	f822                	sd	s0,48(sp)
    80002552:	f426                	sd	s1,40(sp)
    80002554:	f04a                	sd	s2,32(sp)
    80002556:	ec4e                	sd	s3,24(sp)
    80002558:	e852                	sd	s4,16(sp)
    8000255a:	e456                	sd	s5,8(sp)
    8000255c:	0080                	addi	s0,sp,64
    8000255e:	8a2a                	mv	s4,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    80002560:	0000f497          	auipc	s1,0xf
    80002564:	b5048493          	addi	s1,s1,-1200 # 800110b0 <proc>
    {
        if (p != myproc())
        {
            acquire(&p->lock);
            if (p->state == SLEEPING && p->chan == chan)
    80002568:	4989                	li	s3,2
            {
                p->state = RUNNABLE;
    8000256a:	4a8d                	li	s5,3
    for (p = proc; p < &proc[NPROC]; p++)
    8000256c:	00014917          	auipc	s2,0x14
    80002570:	74490913          	addi	s2,s2,1860 # 80016cb0 <tickslock>
    80002574:	a811                	j	80002588 <wakeup+0x3c>
            }
            release(&p->lock);
    80002576:	8526                	mv	a0,s1
    80002578:	ffffe097          	auipc	ra,0xffffe
    8000257c:	776080e7          	jalr	1910(ra) # 80000cee <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80002580:	17048493          	addi	s1,s1,368
    80002584:	03248663          	beq	s1,s2,800025b0 <wakeup+0x64>
        if (p != myproc())
    80002588:	fffff097          	auipc	ra,0xfffff
    8000258c:	77e080e7          	jalr	1918(ra) # 80001d06 <myproc>
    80002590:	fea488e3          	beq	s1,a0,80002580 <wakeup+0x34>
            acquire(&p->lock);
    80002594:	8526                	mv	a0,s1
    80002596:	ffffe097          	auipc	ra,0xffffe
    8000259a:	6a8080e7          	jalr	1704(ra) # 80000c3e <acquire>
            if (p->state == SLEEPING && p->chan == chan)
    8000259e:	4c9c                	lw	a5,24(s1)
    800025a0:	fd379be3          	bne	a5,s3,80002576 <wakeup+0x2a>
    800025a4:	709c                	ld	a5,32(s1)
    800025a6:	fd4798e3          	bne	a5,s4,80002576 <wakeup+0x2a>
                p->state = RUNNABLE;
    800025aa:	0154ac23          	sw	s5,24(s1)
    800025ae:	b7e1                	j	80002576 <wakeup+0x2a>
        }
    }
}
    800025b0:	70e2                	ld	ra,56(sp)
    800025b2:	7442                	ld	s0,48(sp)
    800025b4:	74a2                	ld	s1,40(sp)
    800025b6:	7902                	ld	s2,32(sp)
    800025b8:	69e2                	ld	s3,24(sp)
    800025ba:	6a42                	ld	s4,16(sp)
    800025bc:	6aa2                	ld	s5,8(sp)
    800025be:	6121                	addi	sp,sp,64
    800025c0:	8082                	ret

00000000800025c2 <reparent>:
{
    800025c2:	7179                	addi	sp,sp,-48
    800025c4:	f406                	sd	ra,40(sp)
    800025c6:	f022                	sd	s0,32(sp)
    800025c8:	ec26                	sd	s1,24(sp)
    800025ca:	e84a                	sd	s2,16(sp)
    800025cc:	e44e                	sd	s3,8(sp)
    800025ce:	e052                	sd	s4,0(sp)
    800025d0:	1800                	addi	s0,sp,48
    800025d2:	892a                	mv	s2,a0
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800025d4:	0000f497          	auipc	s1,0xf
    800025d8:	adc48493          	addi	s1,s1,-1316 # 800110b0 <proc>
            pp->parent = initproc;
    800025dc:	00006a17          	auipc	s4,0x6
    800025e0:	434a0a13          	addi	s4,s4,1076 # 80008a10 <initproc>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800025e4:	00014997          	auipc	s3,0x14
    800025e8:	6cc98993          	addi	s3,s3,1740 # 80016cb0 <tickslock>
    800025ec:	a029                	j	800025f6 <reparent+0x34>
    800025ee:	17048493          	addi	s1,s1,368
    800025f2:	01348d63          	beq	s1,s3,8000260c <reparent+0x4a>
        if (pp->parent == p)
    800025f6:	7c9c                	ld	a5,56(s1)
    800025f8:	ff279be3          	bne	a5,s2,800025ee <reparent+0x2c>
            pp->parent = initproc;
    800025fc:	000a3503          	ld	a0,0(s4)
    80002600:	fc88                	sd	a0,56(s1)
            wakeup(initproc);
    80002602:	00000097          	auipc	ra,0x0
    80002606:	f4a080e7          	jalr	-182(ra) # 8000254c <wakeup>
    8000260a:	b7d5                	j	800025ee <reparent+0x2c>
}
    8000260c:	70a2                	ld	ra,40(sp)
    8000260e:	7402                	ld	s0,32(sp)
    80002610:	64e2                	ld	s1,24(sp)
    80002612:	6942                	ld	s2,16(sp)
    80002614:	69a2                	ld	s3,8(sp)
    80002616:	6a02                	ld	s4,0(sp)
    80002618:	6145                	addi	sp,sp,48
    8000261a:	8082                	ret

000000008000261c <exit>:
{
    8000261c:	7179                	addi	sp,sp,-48
    8000261e:	f406                	sd	ra,40(sp)
    80002620:	f022                	sd	s0,32(sp)
    80002622:	ec26                	sd	s1,24(sp)
    80002624:	e84a                	sd	s2,16(sp)
    80002626:	e44e                	sd	s3,8(sp)
    80002628:	e052                	sd	s4,0(sp)
    8000262a:	1800                	addi	s0,sp,48
    8000262c:	8a2a                	mv	s4,a0
    struct proc *p = myproc();
    8000262e:	fffff097          	auipc	ra,0xfffff
    80002632:	6d8080e7          	jalr	1752(ra) # 80001d06 <myproc>
    80002636:	89aa                	mv	s3,a0
    if (p == initproc)
    80002638:	00006797          	auipc	a5,0x6
    8000263c:	3d87b783          	ld	a5,984(a5) # 80008a10 <initproc>
    80002640:	0d050493          	addi	s1,a0,208
    80002644:	15050913          	addi	s2,a0,336
    80002648:	00a79d63          	bne	a5,a0,80002662 <exit+0x46>
        panic("init exiting");
    8000264c:	00006517          	auipc	a0,0x6
    80002650:	c0c50513          	addi	a0,a0,-1012 # 80008258 <etext+0x258>
    80002654:	ffffe097          	auipc	ra,0xffffe
    80002658:	f0c080e7          	jalr	-244(ra) # 80000560 <panic>
    for (int fd = 0; fd < NOFILE; fd++)
    8000265c:	04a1                	addi	s1,s1,8
    8000265e:	01248b63          	beq	s1,s2,80002674 <exit+0x58>
        if (p->ofile[fd])
    80002662:	6088                	ld	a0,0(s1)
    80002664:	dd65                	beqz	a0,8000265c <exit+0x40>
            fileclose(f);
    80002666:	00002097          	auipc	ra,0x2
    8000266a:	524080e7          	jalr	1316(ra) # 80004b8a <fileclose>
            p->ofile[fd] = 0;
    8000266e:	0004b023          	sd	zero,0(s1)
    80002672:	b7ed                	j	8000265c <exit+0x40>
    begin_op();
    80002674:	00002097          	auipc	ra,0x2
    80002678:	046080e7          	jalr	70(ra) # 800046ba <begin_op>
    iput(p->cwd);
    8000267c:	1509b503          	ld	a0,336(s3)
    80002680:	00002097          	auipc	ra,0x2
    80002684:	80e080e7          	jalr	-2034(ra) # 80003e8e <iput>
    end_op();
    80002688:	00002097          	auipc	ra,0x2
    8000268c:	0ac080e7          	jalr	172(ra) # 80004734 <end_op>
    p->cwd = 0;
    80002690:	1409b823          	sd	zero,336(s3)
    acquire(&wait_lock);
    80002694:	0000f497          	auipc	s1,0xf
    80002698:	a0448493          	addi	s1,s1,-1532 # 80011098 <wait_lock>
    8000269c:	8526                	mv	a0,s1
    8000269e:	ffffe097          	auipc	ra,0xffffe
    800026a2:	5a0080e7          	jalr	1440(ra) # 80000c3e <acquire>
    reparent(p);
    800026a6:	854e                	mv	a0,s3
    800026a8:	00000097          	auipc	ra,0x0
    800026ac:	f1a080e7          	jalr	-230(ra) # 800025c2 <reparent>
    wakeup(p->parent);
    800026b0:	0389b503          	ld	a0,56(s3)
    800026b4:	00000097          	auipc	ra,0x0
    800026b8:	e98080e7          	jalr	-360(ra) # 8000254c <wakeup>
    acquire(&p->lock);
    800026bc:	854e                	mv	a0,s3
    800026be:	ffffe097          	auipc	ra,0xffffe
    800026c2:	580080e7          	jalr	1408(ra) # 80000c3e <acquire>
    p->xstate = status;
    800026c6:	0349a623          	sw	s4,44(s3)
    p->state = ZOMBIE;
    800026ca:	4795                	li	a5,5
    800026cc:	00f9ac23          	sw	a5,24(s3)
    release(&wait_lock);
    800026d0:	8526                	mv	a0,s1
    800026d2:	ffffe097          	auipc	ra,0xffffe
    800026d6:	61c080e7          	jalr	1564(ra) # 80000cee <release>
    sched();
    800026da:	00000097          	auipc	ra,0x0
    800026de:	d04080e7          	jalr	-764(ra) # 800023de <sched>
    panic("zombie exit");
    800026e2:	00006517          	auipc	a0,0x6
    800026e6:	b8650513          	addi	a0,a0,-1146 # 80008268 <etext+0x268>
    800026ea:	ffffe097          	auipc	ra,0xffffe
    800026ee:	e76080e7          	jalr	-394(ra) # 80000560 <panic>

00000000800026f2 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    800026f2:	7179                	addi	sp,sp,-48
    800026f4:	f406                	sd	ra,40(sp)
    800026f6:	f022                	sd	s0,32(sp)
    800026f8:	ec26                	sd	s1,24(sp)
    800026fa:	e84a                	sd	s2,16(sp)
    800026fc:	e44e                	sd	s3,8(sp)
    800026fe:	1800                	addi	s0,sp,48
    80002700:	892a                	mv	s2,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    80002702:	0000f497          	auipc	s1,0xf
    80002706:	9ae48493          	addi	s1,s1,-1618 # 800110b0 <proc>
    8000270a:	00014997          	auipc	s3,0x14
    8000270e:	5a698993          	addi	s3,s3,1446 # 80016cb0 <tickslock>
    {
        acquire(&p->lock);
    80002712:	8526                	mv	a0,s1
    80002714:	ffffe097          	auipc	ra,0xffffe
    80002718:	52a080e7          	jalr	1322(ra) # 80000c3e <acquire>
        if (p->pid == pid)
    8000271c:	589c                	lw	a5,48(s1)
    8000271e:	01278d63          	beq	a5,s2,80002738 <kill+0x46>
                p->state = RUNNABLE;
            }
            release(&p->lock);
            return 0;
        }
        release(&p->lock);
    80002722:	8526                	mv	a0,s1
    80002724:	ffffe097          	auipc	ra,0xffffe
    80002728:	5ca080e7          	jalr	1482(ra) # 80000cee <release>
    for (p = proc; p < &proc[NPROC]; p++)
    8000272c:	17048493          	addi	s1,s1,368
    80002730:	ff3491e3          	bne	s1,s3,80002712 <kill+0x20>
    }
    return -1;
    80002734:	557d                	li	a0,-1
    80002736:	a829                	j	80002750 <kill+0x5e>
            p->killed = 1;
    80002738:	4785                	li	a5,1
    8000273a:	d49c                	sw	a5,40(s1)
            if (p->state == SLEEPING)
    8000273c:	4c98                	lw	a4,24(s1)
    8000273e:	4789                	li	a5,2
    80002740:	00f70f63          	beq	a4,a5,8000275e <kill+0x6c>
            release(&p->lock);
    80002744:	8526                	mv	a0,s1
    80002746:	ffffe097          	auipc	ra,0xffffe
    8000274a:	5a8080e7          	jalr	1448(ra) # 80000cee <release>
            return 0;
    8000274e:	4501                	li	a0,0
}
    80002750:	70a2                	ld	ra,40(sp)
    80002752:	7402                	ld	s0,32(sp)
    80002754:	64e2                	ld	s1,24(sp)
    80002756:	6942                	ld	s2,16(sp)
    80002758:	69a2                	ld	s3,8(sp)
    8000275a:	6145                	addi	sp,sp,48
    8000275c:	8082                	ret
                p->state = RUNNABLE;
    8000275e:	478d                	li	a5,3
    80002760:	cc9c                	sw	a5,24(s1)
    80002762:	b7cd                	j	80002744 <kill+0x52>

0000000080002764 <setkilled>:

void setkilled(struct proc *p)
{
    80002764:	1101                	addi	sp,sp,-32
    80002766:	ec06                	sd	ra,24(sp)
    80002768:	e822                	sd	s0,16(sp)
    8000276a:	e426                	sd	s1,8(sp)
    8000276c:	1000                	addi	s0,sp,32
    8000276e:	84aa                	mv	s1,a0
    acquire(&p->lock);
    80002770:	ffffe097          	auipc	ra,0xffffe
    80002774:	4ce080e7          	jalr	1230(ra) # 80000c3e <acquire>
    p->killed = 1;
    80002778:	4785                	li	a5,1
    8000277a:	d49c                	sw	a5,40(s1)
    release(&p->lock);
    8000277c:	8526                	mv	a0,s1
    8000277e:	ffffe097          	auipc	ra,0xffffe
    80002782:	570080e7          	jalr	1392(ra) # 80000cee <release>
}
    80002786:	60e2                	ld	ra,24(sp)
    80002788:	6442                	ld	s0,16(sp)
    8000278a:	64a2                	ld	s1,8(sp)
    8000278c:	6105                	addi	sp,sp,32
    8000278e:	8082                	ret

0000000080002790 <killed>:

int killed(struct proc *p)
{
    80002790:	1101                	addi	sp,sp,-32
    80002792:	ec06                	sd	ra,24(sp)
    80002794:	e822                	sd	s0,16(sp)
    80002796:	e426                	sd	s1,8(sp)
    80002798:	e04a                	sd	s2,0(sp)
    8000279a:	1000                	addi	s0,sp,32
    8000279c:	84aa                	mv	s1,a0
    int k;

    acquire(&p->lock);
    8000279e:	ffffe097          	auipc	ra,0xffffe
    800027a2:	4a0080e7          	jalr	1184(ra) # 80000c3e <acquire>
    k = p->killed;
    800027a6:	0284a903          	lw	s2,40(s1)
    release(&p->lock);
    800027aa:	8526                	mv	a0,s1
    800027ac:	ffffe097          	auipc	ra,0xffffe
    800027b0:	542080e7          	jalr	1346(ra) # 80000cee <release>
    return k;
}
    800027b4:	854a                	mv	a0,s2
    800027b6:	60e2                	ld	ra,24(sp)
    800027b8:	6442                	ld	s0,16(sp)
    800027ba:	64a2                	ld	s1,8(sp)
    800027bc:	6902                	ld	s2,0(sp)
    800027be:	6105                	addi	sp,sp,32
    800027c0:	8082                	ret

00000000800027c2 <wait>:
{
    800027c2:	715d                	addi	sp,sp,-80
    800027c4:	e486                	sd	ra,72(sp)
    800027c6:	e0a2                	sd	s0,64(sp)
    800027c8:	fc26                	sd	s1,56(sp)
    800027ca:	f84a                	sd	s2,48(sp)
    800027cc:	f44e                	sd	s3,40(sp)
    800027ce:	f052                	sd	s4,32(sp)
    800027d0:	ec56                	sd	s5,24(sp)
    800027d2:	e85a                	sd	s6,16(sp)
    800027d4:	e45e                	sd	s7,8(sp)
    800027d6:	0880                	addi	s0,sp,80
    800027d8:	8b2a                	mv	s6,a0
    struct proc *p = myproc();
    800027da:	fffff097          	auipc	ra,0xfffff
    800027de:	52c080e7          	jalr	1324(ra) # 80001d06 <myproc>
    800027e2:	892a                	mv	s2,a0
    acquire(&wait_lock);
    800027e4:	0000f517          	auipc	a0,0xf
    800027e8:	8b450513          	addi	a0,a0,-1868 # 80011098 <wait_lock>
    800027ec:	ffffe097          	auipc	ra,0xffffe
    800027f0:	452080e7          	jalr	1106(ra) # 80000c3e <acquire>
                if (pp->state == ZOMBIE)
    800027f4:	4a15                	li	s4,5
                havekids = 1;
    800027f6:	4a85                	li	s5,1
        for (pp = proc; pp < &proc[NPROC]; pp++)
    800027f8:	00014997          	auipc	s3,0x14
    800027fc:	4b898993          	addi	s3,s3,1208 # 80016cb0 <tickslock>
        sleep(p, &wait_lock); // DOC: wait-sleep
    80002800:	0000fb97          	auipc	s7,0xf
    80002804:	898b8b93          	addi	s7,s7,-1896 # 80011098 <wait_lock>
    80002808:	a0c9                	j	800028ca <wait+0x108>
                    pid = pp->pid;
    8000280a:	0304a983          	lw	s3,48(s1)
                    if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000280e:	000b0e63          	beqz	s6,8000282a <wait+0x68>
    80002812:	4691                	li	a3,4
    80002814:	02c48613          	addi	a2,s1,44
    80002818:	85da                	mv	a1,s6
    8000281a:	05093503          	ld	a0,80(s2)
    8000281e:	fffff097          	auipc	ra,0xfffff
    80002822:	ef2080e7          	jalr	-270(ra) # 80001710 <copyout>
    80002826:	04054063          	bltz	a0,80002866 <wait+0xa4>
                    freeproc(pp);
    8000282a:	8526                	mv	a0,s1
    8000282c:	fffff097          	auipc	ra,0xfffff
    80002830:	68c080e7          	jalr	1676(ra) # 80001eb8 <freeproc>
                    release(&pp->lock);
    80002834:	8526                	mv	a0,s1
    80002836:	ffffe097          	auipc	ra,0xffffe
    8000283a:	4b8080e7          	jalr	1208(ra) # 80000cee <release>
                    release(&wait_lock);
    8000283e:	0000f517          	auipc	a0,0xf
    80002842:	85a50513          	addi	a0,a0,-1958 # 80011098 <wait_lock>
    80002846:	ffffe097          	auipc	ra,0xffffe
    8000284a:	4a8080e7          	jalr	1192(ra) # 80000cee <release>
}
    8000284e:	854e                	mv	a0,s3
    80002850:	60a6                	ld	ra,72(sp)
    80002852:	6406                	ld	s0,64(sp)
    80002854:	74e2                	ld	s1,56(sp)
    80002856:	7942                	ld	s2,48(sp)
    80002858:	79a2                	ld	s3,40(sp)
    8000285a:	7a02                	ld	s4,32(sp)
    8000285c:	6ae2                	ld	s5,24(sp)
    8000285e:	6b42                	ld	s6,16(sp)
    80002860:	6ba2                	ld	s7,8(sp)
    80002862:	6161                	addi	sp,sp,80
    80002864:	8082                	ret
                        release(&pp->lock);
    80002866:	8526                	mv	a0,s1
    80002868:	ffffe097          	auipc	ra,0xffffe
    8000286c:	486080e7          	jalr	1158(ra) # 80000cee <release>
                        release(&wait_lock);
    80002870:	0000f517          	auipc	a0,0xf
    80002874:	82850513          	addi	a0,a0,-2008 # 80011098 <wait_lock>
    80002878:	ffffe097          	auipc	ra,0xffffe
    8000287c:	476080e7          	jalr	1142(ra) # 80000cee <release>
                        return -1;
    80002880:	59fd                	li	s3,-1
    80002882:	b7f1                	j	8000284e <wait+0x8c>
        for (pp = proc; pp < &proc[NPROC]; pp++)
    80002884:	17048493          	addi	s1,s1,368
    80002888:	03348463          	beq	s1,s3,800028b0 <wait+0xee>
            if (pp->parent == p)
    8000288c:	7c9c                	ld	a5,56(s1)
    8000288e:	ff279be3          	bne	a5,s2,80002884 <wait+0xc2>
                acquire(&pp->lock);
    80002892:	8526                	mv	a0,s1
    80002894:	ffffe097          	auipc	ra,0xffffe
    80002898:	3aa080e7          	jalr	938(ra) # 80000c3e <acquire>
                if (pp->state == ZOMBIE)
    8000289c:	4c9c                	lw	a5,24(s1)
    8000289e:	f74786e3          	beq	a5,s4,8000280a <wait+0x48>
                release(&pp->lock);
    800028a2:	8526                	mv	a0,s1
    800028a4:	ffffe097          	auipc	ra,0xffffe
    800028a8:	44a080e7          	jalr	1098(ra) # 80000cee <release>
                havekids = 1;
    800028ac:	8756                	mv	a4,s5
    800028ae:	bfd9                	j	80002884 <wait+0xc2>
        if (!havekids || killed(p))
    800028b0:	c31d                	beqz	a4,800028d6 <wait+0x114>
    800028b2:	854a                	mv	a0,s2
    800028b4:	00000097          	auipc	ra,0x0
    800028b8:	edc080e7          	jalr	-292(ra) # 80002790 <killed>
    800028bc:	ed09                	bnez	a0,800028d6 <wait+0x114>
        sleep(p, &wait_lock); // DOC: wait-sleep
    800028be:	85de                	mv	a1,s7
    800028c0:	854a                	mv	a0,s2
    800028c2:	00000097          	auipc	ra,0x0
    800028c6:	c26080e7          	jalr	-986(ra) # 800024e8 <sleep>
        havekids = 0;
    800028ca:	4701                	li	a4,0
        for (pp = proc; pp < &proc[NPROC]; pp++)
    800028cc:	0000e497          	auipc	s1,0xe
    800028d0:	7e448493          	addi	s1,s1,2020 # 800110b0 <proc>
    800028d4:	bf65                	j	8000288c <wait+0xca>
            release(&wait_lock);
    800028d6:	0000e517          	auipc	a0,0xe
    800028da:	7c250513          	addi	a0,a0,1986 # 80011098 <wait_lock>
    800028de:	ffffe097          	auipc	ra,0xffffe
    800028e2:	410080e7          	jalr	1040(ra) # 80000cee <release>
            return -1;
    800028e6:	59fd                	li	s3,-1
    800028e8:	b79d                	j	8000284e <wait+0x8c>

00000000800028ea <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800028ea:	7179                	addi	sp,sp,-48
    800028ec:	f406                	sd	ra,40(sp)
    800028ee:	f022                	sd	s0,32(sp)
    800028f0:	ec26                	sd	s1,24(sp)
    800028f2:	e84a                	sd	s2,16(sp)
    800028f4:	e44e                	sd	s3,8(sp)
    800028f6:	e052                	sd	s4,0(sp)
    800028f8:	1800                	addi	s0,sp,48
    800028fa:	84aa                	mv	s1,a0
    800028fc:	892e                	mv	s2,a1
    800028fe:	89b2                	mv	s3,a2
    80002900:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    80002902:	fffff097          	auipc	ra,0xfffff
    80002906:	404080e7          	jalr	1028(ra) # 80001d06 <myproc>
    if (user_dst)
    8000290a:	c08d                	beqz	s1,8000292c <either_copyout+0x42>
    {
        return copyout(p->pagetable, dst, src, len);
    8000290c:	86d2                	mv	a3,s4
    8000290e:	864e                	mv	a2,s3
    80002910:	85ca                	mv	a1,s2
    80002912:	6928                	ld	a0,80(a0)
    80002914:	fffff097          	auipc	ra,0xfffff
    80002918:	dfc080e7          	jalr	-516(ra) # 80001710 <copyout>
    else
    {
        memmove((char *)dst, src, len);
        return 0;
    }
}
    8000291c:	70a2                	ld	ra,40(sp)
    8000291e:	7402                	ld	s0,32(sp)
    80002920:	64e2                	ld	s1,24(sp)
    80002922:	6942                	ld	s2,16(sp)
    80002924:	69a2                	ld	s3,8(sp)
    80002926:	6a02                	ld	s4,0(sp)
    80002928:	6145                	addi	sp,sp,48
    8000292a:	8082                	ret
        memmove((char *)dst, src, len);
    8000292c:	000a061b          	sext.w	a2,s4
    80002930:	85ce                	mv	a1,s3
    80002932:	854a                	mv	a0,s2
    80002934:	ffffe097          	auipc	ra,0xffffe
    80002938:	466080e7          	jalr	1126(ra) # 80000d9a <memmove>
        return 0;
    8000293c:	8526                	mv	a0,s1
    8000293e:	bff9                	j	8000291c <either_copyout+0x32>

0000000080002940 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002940:	7179                	addi	sp,sp,-48
    80002942:	f406                	sd	ra,40(sp)
    80002944:	f022                	sd	s0,32(sp)
    80002946:	ec26                	sd	s1,24(sp)
    80002948:	e84a                	sd	s2,16(sp)
    8000294a:	e44e                	sd	s3,8(sp)
    8000294c:	e052                	sd	s4,0(sp)
    8000294e:	1800                	addi	s0,sp,48
    80002950:	892a                	mv	s2,a0
    80002952:	84ae                	mv	s1,a1
    80002954:	89b2                	mv	s3,a2
    80002956:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    80002958:	fffff097          	auipc	ra,0xfffff
    8000295c:	3ae080e7          	jalr	942(ra) # 80001d06 <myproc>
    if (user_src)
    80002960:	c08d                	beqz	s1,80002982 <either_copyin+0x42>
    {
        return copyin(p->pagetable, dst, src, len);
    80002962:	86d2                	mv	a3,s4
    80002964:	864e                	mv	a2,s3
    80002966:	85ca                	mv	a1,s2
    80002968:	6928                	ld	a0,80(a0)
    8000296a:	fffff097          	auipc	ra,0xfffff
    8000296e:	e32080e7          	jalr	-462(ra) # 8000179c <copyin>
    else
    {
        memmove(dst, (char *)src, len);
        return 0;
    }
}
    80002972:	70a2                	ld	ra,40(sp)
    80002974:	7402                	ld	s0,32(sp)
    80002976:	64e2                	ld	s1,24(sp)
    80002978:	6942                	ld	s2,16(sp)
    8000297a:	69a2                	ld	s3,8(sp)
    8000297c:	6a02                	ld	s4,0(sp)
    8000297e:	6145                	addi	sp,sp,48
    80002980:	8082                	ret
        memmove(dst, (char *)src, len);
    80002982:	000a061b          	sext.w	a2,s4
    80002986:	85ce                	mv	a1,s3
    80002988:	854a                	mv	a0,s2
    8000298a:	ffffe097          	auipc	ra,0xffffe
    8000298e:	410080e7          	jalr	1040(ra) # 80000d9a <memmove>
        return 0;
    80002992:	8526                	mv	a0,s1
    80002994:	bff9                	j	80002972 <either_copyin+0x32>

0000000080002996 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    80002996:	715d                	addi	sp,sp,-80
    80002998:	e486                	sd	ra,72(sp)
    8000299a:	e0a2                	sd	s0,64(sp)
    8000299c:	fc26                	sd	s1,56(sp)
    8000299e:	f84a                	sd	s2,48(sp)
    800029a0:	f44e                	sd	s3,40(sp)
    800029a2:	f052                	sd	s4,32(sp)
    800029a4:	ec56                	sd	s5,24(sp)
    800029a6:	e85a                	sd	s6,16(sp)
    800029a8:	e45e                	sd	s7,8(sp)
    800029aa:	0880                	addi	s0,sp,80
        [RUNNING] "run   ",
        [ZOMBIE] "zombie"};
    struct proc *p;
    char *state;

    printf("\n");
    800029ac:	00005517          	auipc	a0,0x5
    800029b0:	66450513          	addi	a0,a0,1636 # 80008010 <etext+0x10>
    800029b4:	ffffe097          	auipc	ra,0xffffe
    800029b8:	bf6080e7          	jalr	-1034(ra) # 800005aa <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    800029bc:	0000f497          	auipc	s1,0xf
    800029c0:	84c48493          	addi	s1,s1,-1972 # 80011208 <proc+0x158>
    800029c4:	00014917          	auipc	s2,0x14
    800029c8:	44490913          	addi	s2,s2,1092 # 80016e08 <bcache+0x140>
    {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800029cc:	4b15                	li	s6,5
            state = states[p->state];
        else
            state = "???";
    800029ce:	00006997          	auipc	s3,0x6
    800029d2:	8aa98993          	addi	s3,s3,-1878 # 80008278 <etext+0x278>
        printf("%d <%s %s", p->pid, state, p->name);
    800029d6:	00006a97          	auipc	s5,0x6
    800029da:	8aaa8a93          	addi	s5,s5,-1878 # 80008280 <etext+0x280>
        printf("\n");
    800029de:	00005a17          	auipc	s4,0x5
    800029e2:	632a0a13          	addi	s4,s4,1586 # 80008010 <etext+0x10>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800029e6:	00006b97          	auipc	s7,0x6
    800029ea:	e42b8b93          	addi	s7,s7,-446 # 80008828 <states.0>
    800029ee:	a00d                	j	80002a10 <procdump+0x7a>
        printf("%d <%s %s", p->pid, state, p->name);
    800029f0:	ed86a583          	lw	a1,-296(a3)
    800029f4:	8556                	mv	a0,s5
    800029f6:	ffffe097          	auipc	ra,0xffffe
    800029fa:	bb4080e7          	jalr	-1100(ra) # 800005aa <printf>
        printf("\n");
    800029fe:	8552                	mv	a0,s4
    80002a00:	ffffe097          	auipc	ra,0xffffe
    80002a04:	baa080e7          	jalr	-1110(ra) # 800005aa <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80002a08:	17048493          	addi	s1,s1,368
    80002a0c:	03248263          	beq	s1,s2,80002a30 <procdump+0x9a>
        if (p->state == UNUSED)
    80002a10:	86a6                	mv	a3,s1
    80002a12:	ec04a783          	lw	a5,-320(s1)
    80002a16:	dbed                	beqz	a5,80002a08 <procdump+0x72>
            state = "???";
    80002a18:	864e                	mv	a2,s3
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002a1a:	fcfb6be3          	bltu	s6,a5,800029f0 <procdump+0x5a>
    80002a1e:	02079713          	slli	a4,a5,0x20
    80002a22:	01d75793          	srli	a5,a4,0x1d
    80002a26:	97de                	add	a5,a5,s7
    80002a28:	6390                	ld	a2,0(a5)
    80002a2a:	f279                	bnez	a2,800029f0 <procdump+0x5a>
            state = "???";
    80002a2c:	864e                	mv	a2,s3
    80002a2e:	b7c9                	j	800029f0 <procdump+0x5a>
    }
}
    80002a30:	60a6                	ld	ra,72(sp)
    80002a32:	6406                	ld	s0,64(sp)
    80002a34:	74e2                	ld	s1,56(sp)
    80002a36:	7942                	ld	s2,48(sp)
    80002a38:	79a2                	ld	s3,40(sp)
    80002a3a:	7a02                	ld	s4,32(sp)
    80002a3c:	6ae2                	ld	s5,24(sp)
    80002a3e:	6b42                	ld	s6,16(sp)
    80002a40:	6ba2                	ld	s7,8(sp)
    80002a42:	6161                	addi	sp,sp,80
    80002a44:	8082                	ret

0000000080002a46 <schedls>:

void schedls()
{
    80002a46:	1101                	addi	sp,sp,-32
    80002a48:	ec06                	sd	ra,24(sp)
    80002a4a:	e822                	sd	s0,16(sp)
    80002a4c:	e426                	sd	s1,8(sp)
    80002a4e:	1000                	addi	s0,sp,32
    printf("[ ]\tScheduler Name\tScheduler ID\n");
    80002a50:	00006517          	auipc	a0,0x6
    80002a54:	84050513          	addi	a0,a0,-1984 # 80008290 <etext+0x290>
    80002a58:	ffffe097          	auipc	ra,0xffffe
    80002a5c:	b52080e7          	jalr	-1198(ra) # 800005aa <printf>
    printf("====================================\n");
    80002a60:	00006517          	auipc	a0,0x6
    80002a64:	85850513          	addi	a0,a0,-1960 # 800082b8 <etext+0x2b8>
    80002a68:	ffffe097          	auipc	ra,0xffffe
    80002a6c:	b42080e7          	jalr	-1214(ra) # 800005aa <printf>
    for (int i = 0; i < SCHEDC; i++)
    {
        if (available_schedulers[i].impl == sched_pointer)
    80002a70:	00006717          	auipc	a4,0x6
    80002a74:	f3873703          	ld	a4,-200(a4) # 800089a8 <available_schedulers+0x10>
    80002a78:	00006797          	auipc	a5,0x6
    80002a7c:	ed07b783          	ld	a5,-304(a5) # 80008948 <sched_pointer>
    80002a80:	08f70763          	beq	a4,a5,80002b0e <schedls+0xc8>
        {
            printf("[*]\t");
        }
        else
        {
            printf("   \t");
    80002a84:	00006517          	auipc	a0,0x6
    80002a88:	85c50513          	addi	a0,a0,-1956 # 800082e0 <etext+0x2e0>
    80002a8c:	ffffe097          	auipc	ra,0xffffe
    80002a90:	b1e080e7          	jalr	-1250(ra) # 800005aa <printf>
        }
        printf("%s\t%d\n", available_schedulers[i].name, available_schedulers[i].id);
    80002a94:	00006497          	auipc	s1,0x6
    80002a98:	ecc48493          	addi	s1,s1,-308 # 80008960 <initcode>
    80002a9c:	48b0                	lw	a2,80(s1)
    80002a9e:	00006597          	auipc	a1,0x6
    80002aa2:	efa58593          	addi	a1,a1,-262 # 80008998 <available_schedulers>
    80002aa6:	00006517          	auipc	a0,0x6
    80002aaa:	84a50513          	addi	a0,a0,-1974 # 800082f0 <etext+0x2f0>
    80002aae:	ffffe097          	auipc	ra,0xffffe
    80002ab2:	afc080e7          	jalr	-1284(ra) # 800005aa <printf>
        if (available_schedulers[i].impl == sched_pointer)
    80002ab6:	74b8                	ld	a4,104(s1)
    80002ab8:	00006797          	auipc	a5,0x6
    80002abc:	e907b783          	ld	a5,-368(a5) # 80008948 <sched_pointer>
    80002ac0:	06f70063          	beq	a4,a5,80002b20 <schedls+0xda>
            printf("   \t");
    80002ac4:	00006517          	auipc	a0,0x6
    80002ac8:	81c50513          	addi	a0,a0,-2020 # 800082e0 <etext+0x2e0>
    80002acc:	ffffe097          	auipc	ra,0xffffe
    80002ad0:	ade080e7          	jalr	-1314(ra) # 800005aa <printf>
        printf("%s\t%d\n", available_schedulers[i].name, available_schedulers[i].id);
    80002ad4:	00006617          	auipc	a2,0x6
    80002ad8:	efc62603          	lw	a2,-260(a2) # 800089d0 <available_schedulers+0x38>
    80002adc:	00006597          	auipc	a1,0x6
    80002ae0:	edc58593          	addi	a1,a1,-292 # 800089b8 <available_schedulers+0x20>
    80002ae4:	00006517          	auipc	a0,0x6
    80002ae8:	80c50513          	addi	a0,a0,-2036 # 800082f0 <etext+0x2f0>
    80002aec:	ffffe097          	auipc	ra,0xffffe
    80002af0:	abe080e7          	jalr	-1346(ra) # 800005aa <printf>
    }
    printf("\n*: current scheduler\n\n");
    80002af4:	00006517          	auipc	a0,0x6
    80002af8:	80450513          	addi	a0,a0,-2044 # 800082f8 <etext+0x2f8>
    80002afc:	ffffe097          	auipc	ra,0xffffe
    80002b00:	aae080e7          	jalr	-1362(ra) # 800005aa <printf>
}
    80002b04:	60e2                	ld	ra,24(sp)
    80002b06:	6442                	ld	s0,16(sp)
    80002b08:	64a2                	ld	s1,8(sp)
    80002b0a:	6105                	addi	sp,sp,32
    80002b0c:	8082                	ret
            printf("[*]\t");
    80002b0e:	00005517          	auipc	a0,0x5
    80002b12:	7da50513          	addi	a0,a0,2010 # 800082e8 <etext+0x2e8>
    80002b16:	ffffe097          	auipc	ra,0xffffe
    80002b1a:	a94080e7          	jalr	-1388(ra) # 800005aa <printf>
    80002b1e:	bf9d                	j	80002a94 <schedls+0x4e>
    80002b20:	00005517          	auipc	a0,0x5
    80002b24:	7c850513          	addi	a0,a0,1992 # 800082e8 <etext+0x2e8>
    80002b28:	ffffe097          	auipc	ra,0xffffe
    80002b2c:	a82080e7          	jalr	-1406(ra) # 800005aa <printf>
    80002b30:	b755                	j	80002ad4 <schedls+0x8e>

0000000080002b32 <schedset>:

void schedset(int id)
{
    80002b32:	1141                	addi	sp,sp,-16
    80002b34:	e406                	sd	ra,8(sp)
    80002b36:	e022                	sd	s0,0(sp)
    80002b38:	0800                	addi	s0,sp,16
    if (id < 0 || SCHEDC <= id)
    80002b3a:	4785                	li	a5,1
    80002b3c:	02a7ee63          	bltu	a5,a0,80002b78 <schedset+0x46>
    {
        printf("Scheduler unchanged: ID out of range\n");
        return;
    }
    sched_pointer = available_schedulers[id].impl;
    80002b40:	0516                	slli	a0,a0,0x5
    80002b42:	00006797          	auipc	a5,0x6
    80002b46:	e1e78793          	addi	a5,a5,-482 # 80008960 <initcode>
    80002b4a:	97aa                	add	a5,a5,a0
    80002b4c:	67bc                	ld	a5,72(a5)
    80002b4e:	00006717          	auipc	a4,0x6
    80002b52:	def73d23          	sd	a5,-518(a4) # 80008948 <sched_pointer>
    printf("Scheduler successfully changed to %s\n", available_schedulers[id].name);
    80002b56:	00006597          	auipc	a1,0x6
    80002b5a:	e4258593          	addi	a1,a1,-446 # 80008998 <available_schedulers>
    80002b5e:	95aa                	add	a1,a1,a0
    80002b60:	00005517          	auipc	a0,0x5
    80002b64:	7d850513          	addi	a0,a0,2008 # 80008338 <etext+0x338>
    80002b68:	ffffe097          	auipc	ra,0xffffe
    80002b6c:	a42080e7          	jalr	-1470(ra) # 800005aa <printf>
}
    80002b70:	60a2                	ld	ra,8(sp)
    80002b72:	6402                	ld	s0,0(sp)
    80002b74:	0141                	addi	sp,sp,16
    80002b76:	8082                	ret
        printf("Scheduler unchanged: ID out of range\n");
    80002b78:	00005517          	auipc	a0,0x5
    80002b7c:	79850513          	addi	a0,a0,1944 # 80008310 <etext+0x310>
    80002b80:	ffffe097          	auipc	ra,0xffffe
    80002b84:	a2a080e7          	jalr	-1494(ra) # 800005aa <printf>
        return;
    80002b88:	b7e5                	j	80002b70 <schedset+0x3e>

0000000080002b8a <swtch>:
    80002b8a:	00153023          	sd	ra,0(a0)
    80002b8e:	00253423          	sd	sp,8(a0)
    80002b92:	e900                	sd	s0,16(a0)
    80002b94:	ed04                	sd	s1,24(a0)
    80002b96:	03253023          	sd	s2,32(a0)
    80002b9a:	03353423          	sd	s3,40(a0)
    80002b9e:	03453823          	sd	s4,48(a0)
    80002ba2:	03553c23          	sd	s5,56(a0)
    80002ba6:	05653023          	sd	s6,64(a0)
    80002baa:	05753423          	sd	s7,72(a0)
    80002bae:	05853823          	sd	s8,80(a0)
    80002bb2:	05953c23          	sd	s9,88(a0)
    80002bb6:	07a53023          	sd	s10,96(a0)
    80002bba:	07b53423          	sd	s11,104(a0)
    80002bbe:	0005b083          	ld	ra,0(a1)
    80002bc2:	0085b103          	ld	sp,8(a1)
    80002bc6:	6980                	ld	s0,16(a1)
    80002bc8:	6d84                	ld	s1,24(a1)
    80002bca:	0205b903          	ld	s2,32(a1)
    80002bce:	0285b983          	ld	s3,40(a1)
    80002bd2:	0305ba03          	ld	s4,48(a1)
    80002bd6:	0385ba83          	ld	s5,56(a1)
    80002bda:	0405bb03          	ld	s6,64(a1)
    80002bde:	0485bb83          	ld	s7,72(a1)
    80002be2:	0505bc03          	ld	s8,80(a1)
    80002be6:	0585bc83          	ld	s9,88(a1)
    80002bea:	0605bd03          	ld	s10,96(a1)
    80002bee:	0685bd83          	ld	s11,104(a1)
    80002bf2:	8082                	ret

0000000080002bf4 <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80002bf4:	1141                	addi	sp,sp,-16
    80002bf6:	e406                	sd	ra,8(sp)
    80002bf8:	e022                	sd	s0,0(sp)
    80002bfa:	0800                	addi	s0,sp,16
    initlock(&tickslock, "time");
    80002bfc:	00005597          	auipc	a1,0x5
    80002c00:	79458593          	addi	a1,a1,1940 # 80008390 <etext+0x390>
    80002c04:	00014517          	auipc	a0,0x14
    80002c08:	0ac50513          	addi	a0,a0,172 # 80016cb0 <tickslock>
    80002c0c:	ffffe097          	auipc	ra,0xffffe
    80002c10:	f9e080e7          	jalr	-98(ra) # 80000baa <initlock>
}
    80002c14:	60a2                	ld	ra,8(sp)
    80002c16:	6402                	ld	s0,0(sp)
    80002c18:	0141                	addi	sp,sp,16
    80002c1a:	8082                	ret

0000000080002c1c <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80002c1c:	1141                	addi	sp,sp,-16
    80002c1e:	e406                	sd	ra,8(sp)
    80002c20:	e022                	sd	s0,0(sp)
    80002c22:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002c24:	00003797          	auipc	a5,0x3
    80002c28:	6ac78793          	addi	a5,a5,1708 # 800062d0 <kernelvec>
    80002c2c:	10579073          	csrw	stvec,a5
    w_stvec((uint64)kernelvec);
}
    80002c30:	60a2                	ld	ra,8(sp)
    80002c32:	6402                	ld	s0,0(sp)
    80002c34:	0141                	addi	sp,sp,16
    80002c36:	8082                	ret

0000000080002c38 <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80002c38:	1141                	addi	sp,sp,-16
    80002c3a:	e406                	sd	ra,8(sp)
    80002c3c:	e022                	sd	s0,0(sp)
    80002c3e:	0800                	addi	s0,sp,16
    struct proc *p = myproc();
    80002c40:	fffff097          	auipc	ra,0xfffff
    80002c44:	0c6080e7          	jalr	198(ra) # 80001d06 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002c48:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002c4c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002c4e:	10079073          	csrw	sstatus,a5
    // kerneltrap() to usertrap(), so turn off interrupts until
    // we're back in user space, where usertrap() is correct.
    intr_off();

    // send syscalls, interrupts, and exceptions to uservec in trampoline.S
    uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002c52:	00004697          	auipc	a3,0x4
    80002c56:	3ae68693          	addi	a3,a3,942 # 80007000 <_trampoline>
    80002c5a:	00004717          	auipc	a4,0x4
    80002c5e:	3a670713          	addi	a4,a4,934 # 80007000 <_trampoline>
    80002c62:	8f15                	sub	a4,a4,a3
    80002c64:	040007b7          	lui	a5,0x4000
    80002c68:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002c6a:	07b2                	slli	a5,a5,0xc
    80002c6c:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002c6e:	10571073          	csrw	stvec,a4
    w_stvec(trampoline_uservec);

    // set up trapframe values that uservec will need when
    // the process next traps into the kernel.
    p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002c72:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002c74:	18002673          	csrr	a2,satp
    80002c78:	e310                	sd	a2,0(a4)
    p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002c7a:	6d30                	ld	a2,88(a0)
    80002c7c:	6138                	ld	a4,64(a0)
    80002c7e:	6585                	lui	a1,0x1
    80002c80:	972e                	add	a4,a4,a1
    80002c82:	e618                	sd	a4,8(a2)
    p->trapframe->kernel_trap = (uint64)usertrap;
    80002c84:	6d38                	ld	a4,88(a0)
    80002c86:	00000617          	auipc	a2,0x0
    80002c8a:	13860613          	addi	a2,a2,312 # 80002dbe <usertrap>
    80002c8e:	eb10                	sd	a2,16(a4)
    p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002c90:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002c92:	8612                	mv	a2,tp
    80002c94:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002c96:	10002773          	csrr	a4,sstatus
    // set up the registers that trampoline.S's sret will use
    // to get to user space.

    // set S Previous Privilege mode to User.
    unsigned long x = r_sstatus();
    x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002c9a:	eff77713          	andi	a4,a4,-257
    x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002c9e:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002ca2:	10071073          	csrw	sstatus,a4
    w_sstatus(x);

    // set S Exception Program Counter to the saved user pc.
    w_sepc(p->trapframe->epc);
    80002ca6:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002ca8:	6f18                	ld	a4,24(a4)
    80002caa:	14171073          	csrw	sepc,a4

    // tell trampoline.S the user page table to switch to.
    uint64 satp = MAKE_SATP(p->pagetable);
    80002cae:	6928                	ld	a0,80(a0)
    80002cb0:	8131                	srli	a0,a0,0xc

    // jump to userret in trampoline.S at the top of memory, which
    // switches to the user page table, restores user registers,
    // and switches to user mode with sret.
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002cb2:	00004717          	auipc	a4,0x4
    80002cb6:	3ea70713          	addi	a4,a4,1002 # 8000709c <userret>
    80002cba:	8f15                	sub	a4,a4,a3
    80002cbc:	97ba                	add	a5,a5,a4
    ((void (*)(uint64))trampoline_userret)(satp);
    80002cbe:	577d                	li	a4,-1
    80002cc0:	177e                	slli	a4,a4,0x3f
    80002cc2:	8d59                	or	a0,a0,a4
    80002cc4:	9782                	jalr	a5
}
    80002cc6:	60a2                	ld	ra,8(sp)
    80002cc8:	6402                	ld	s0,0(sp)
    80002cca:	0141                	addi	sp,sp,16
    80002ccc:	8082                	ret

0000000080002cce <clockintr>:
    w_sepc(sepc);
    w_sstatus(sstatus);
}

void clockintr()
{
    80002cce:	1101                	addi	sp,sp,-32
    80002cd0:	ec06                	sd	ra,24(sp)
    80002cd2:	e822                	sd	s0,16(sp)
    80002cd4:	e426                	sd	s1,8(sp)
    80002cd6:	1000                	addi	s0,sp,32
    acquire(&tickslock);
    80002cd8:	00014497          	auipc	s1,0x14
    80002cdc:	fd848493          	addi	s1,s1,-40 # 80016cb0 <tickslock>
    80002ce0:	8526                	mv	a0,s1
    80002ce2:	ffffe097          	auipc	ra,0xffffe
    80002ce6:	f5c080e7          	jalr	-164(ra) # 80000c3e <acquire>
    ticks++;
    80002cea:	00006517          	auipc	a0,0x6
    80002cee:	d2e50513          	addi	a0,a0,-722 # 80008a18 <ticks>
    80002cf2:	411c                	lw	a5,0(a0)
    80002cf4:	2785                	addiw	a5,a5,1
    80002cf6:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80002cf8:	00000097          	auipc	ra,0x0
    80002cfc:	854080e7          	jalr	-1964(ra) # 8000254c <wakeup>
    release(&tickslock);
    80002d00:	8526                	mv	a0,s1
    80002d02:	ffffe097          	auipc	ra,0xffffe
    80002d06:	fec080e7          	jalr	-20(ra) # 80000cee <release>
}
    80002d0a:	60e2                	ld	ra,24(sp)
    80002d0c:	6442                	ld	s0,16(sp)
    80002d0e:	64a2                	ld	s1,8(sp)
    80002d10:	6105                	addi	sp,sp,32
    80002d12:	8082                	ret

0000000080002d14 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002d14:	142027f3          	csrr	a5,scause

        return 2;
    }
    else
    {
        return 0;
    80002d18:	4501                	li	a0,0
    if ((scause & 0x8000000000000000L) &&
    80002d1a:	0a07d163          	bgez	a5,80002dbc <devintr+0xa8>
{
    80002d1e:	1101                	addi	sp,sp,-32
    80002d20:	ec06                	sd	ra,24(sp)
    80002d22:	e822                	sd	s0,16(sp)
    80002d24:	1000                	addi	s0,sp,32
        (scause & 0xff) == 9)
    80002d26:	0ff7f713          	zext.b	a4,a5
    if ((scause & 0x8000000000000000L) &&
    80002d2a:	46a5                	li	a3,9
    80002d2c:	00d70c63          	beq	a4,a3,80002d44 <devintr+0x30>
    else if (scause == 0x8000000000000001L)
    80002d30:	577d                	li	a4,-1
    80002d32:	177e                	slli	a4,a4,0x3f
    80002d34:	0705                	addi	a4,a4,1
        return 0;
    80002d36:	4501                	li	a0,0
    else if (scause == 0x8000000000000001L)
    80002d38:	06e78163          	beq	a5,a4,80002d9a <devintr+0x86>
    }
}
    80002d3c:	60e2                	ld	ra,24(sp)
    80002d3e:	6442                	ld	s0,16(sp)
    80002d40:	6105                	addi	sp,sp,32
    80002d42:	8082                	ret
    80002d44:	e426                	sd	s1,8(sp)
        int irq = plic_claim();
    80002d46:	00003097          	auipc	ra,0x3
    80002d4a:	696080e7          	jalr	1686(ra) # 800063dc <plic_claim>
    80002d4e:	84aa                	mv	s1,a0
        if (irq == UART0_IRQ)
    80002d50:	47a9                	li	a5,10
    80002d52:	00f50963          	beq	a0,a5,80002d64 <devintr+0x50>
        else if (irq == VIRTIO0_IRQ)
    80002d56:	4785                	li	a5,1
    80002d58:	00f50b63          	beq	a0,a5,80002d6e <devintr+0x5a>
        return 1;
    80002d5c:	4505                	li	a0,1
        else if (irq)
    80002d5e:	ec89                	bnez	s1,80002d78 <devintr+0x64>
    80002d60:	64a2                	ld	s1,8(sp)
    80002d62:	bfe9                	j	80002d3c <devintr+0x28>
            uartintr();
    80002d64:	ffffe097          	auipc	ra,0xffffe
    80002d68:	c98080e7          	jalr	-872(ra) # 800009fc <uartintr>
        if (irq)
    80002d6c:	a839                	j	80002d8a <devintr+0x76>
            virtio_disk_intr();
    80002d6e:	00004097          	auipc	ra,0x4
    80002d72:	b62080e7          	jalr	-1182(ra) # 800068d0 <virtio_disk_intr>
        if (irq)
    80002d76:	a811                	j	80002d8a <devintr+0x76>
            printf("unexpected interrupt irq=%d\n", irq);
    80002d78:	85a6                	mv	a1,s1
    80002d7a:	00005517          	auipc	a0,0x5
    80002d7e:	61e50513          	addi	a0,a0,1566 # 80008398 <etext+0x398>
    80002d82:	ffffe097          	auipc	ra,0xffffe
    80002d86:	828080e7          	jalr	-2008(ra) # 800005aa <printf>
            plic_complete(irq);
    80002d8a:	8526                	mv	a0,s1
    80002d8c:	00003097          	auipc	ra,0x3
    80002d90:	674080e7          	jalr	1652(ra) # 80006400 <plic_complete>
        return 1;
    80002d94:	4505                	li	a0,1
    80002d96:	64a2                	ld	s1,8(sp)
    80002d98:	b755                	j	80002d3c <devintr+0x28>
        if (cpuid() == 0)
    80002d9a:	fffff097          	auipc	ra,0xfffff
    80002d9e:	f38080e7          	jalr	-200(ra) # 80001cd2 <cpuid>
    80002da2:	c901                	beqz	a0,80002db2 <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002da4:	144027f3          	csrr	a5,sip
        w_sip(r_sip() & ~2);
    80002da8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002daa:	14479073          	csrw	sip,a5
        return 2;
    80002dae:	4509                	li	a0,2
    80002db0:	b771                	j	80002d3c <devintr+0x28>
            clockintr();
    80002db2:	00000097          	auipc	ra,0x0
    80002db6:	f1c080e7          	jalr	-228(ra) # 80002cce <clockintr>
    80002dba:	b7ed                	j	80002da4 <devintr+0x90>
}
    80002dbc:	8082                	ret

0000000080002dbe <usertrap>:
{
    80002dbe:	1101                	addi	sp,sp,-32
    80002dc0:	ec06                	sd	ra,24(sp)
    80002dc2:	e822                	sd	s0,16(sp)
    80002dc4:	e426                	sd	s1,8(sp)
    80002dc6:	e04a                	sd	s2,0(sp)
    80002dc8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002dca:	100027f3          	csrr	a5,sstatus
    if ((r_sstatus() & SSTATUS_SPP) != 0)
    80002dce:	1007f793          	andi	a5,a5,256
    80002dd2:	e3b1                	bnez	a5,80002e16 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002dd4:	00003797          	auipc	a5,0x3
    80002dd8:	4fc78793          	addi	a5,a5,1276 # 800062d0 <kernelvec>
    80002ddc:	10579073          	csrw	stvec,a5
    struct proc *p = myproc();
    80002de0:	fffff097          	auipc	ra,0xfffff
    80002de4:	f26080e7          	jalr	-218(ra) # 80001d06 <myproc>
    80002de8:	84aa                	mv	s1,a0
    p->trapframe->epc = r_sepc();
    80002dea:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002dec:	14102773          	csrr	a4,sepc
    80002df0:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002df2:	14202773          	csrr	a4,scause
    if (r_scause() == 8)
    80002df6:	47a1                	li	a5,8
    80002df8:	02f70763          	beq	a4,a5,80002e26 <usertrap+0x68>
    else if ((which_dev = devintr()) != 0)
    80002dfc:	00000097          	auipc	ra,0x0
    80002e00:	f18080e7          	jalr	-232(ra) # 80002d14 <devintr>
    80002e04:	892a                	mv	s2,a0
    80002e06:	c151                	beqz	a0,80002e8a <usertrap+0xcc>
    if (killed(p))
    80002e08:	8526                	mv	a0,s1
    80002e0a:	00000097          	auipc	ra,0x0
    80002e0e:	986080e7          	jalr	-1658(ra) # 80002790 <killed>
    80002e12:	c929                	beqz	a0,80002e64 <usertrap+0xa6>
    80002e14:	a099                	j	80002e5a <usertrap+0x9c>
        panic("usertrap: not from user mode");
    80002e16:	00005517          	auipc	a0,0x5
    80002e1a:	5a250513          	addi	a0,a0,1442 # 800083b8 <etext+0x3b8>
    80002e1e:	ffffd097          	auipc	ra,0xffffd
    80002e22:	742080e7          	jalr	1858(ra) # 80000560 <panic>
        if (killed(p))
    80002e26:	00000097          	auipc	ra,0x0
    80002e2a:	96a080e7          	jalr	-1686(ra) # 80002790 <killed>
    80002e2e:	e921                	bnez	a0,80002e7e <usertrap+0xc0>
        p->trapframe->epc += 4;
    80002e30:	6cb8                	ld	a4,88(s1)
    80002e32:	6f1c                	ld	a5,24(a4)
    80002e34:	0791                	addi	a5,a5,4
    80002e36:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e38:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002e3c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002e40:	10079073          	csrw	sstatus,a5
        syscall();
    80002e44:	00000097          	auipc	ra,0x0
    80002e48:	2f4080e7          	jalr	756(ra) # 80003138 <syscall>
    if (killed(p))
    80002e4c:	8526                	mv	a0,s1
    80002e4e:	00000097          	auipc	ra,0x0
    80002e52:	942080e7          	jalr	-1726(ra) # 80002790 <killed>
    80002e56:	c911                	beqz	a0,80002e6a <usertrap+0xac>
    80002e58:	4901                	li	s2,0
        exit(-1);
    80002e5a:	557d                	li	a0,-1
    80002e5c:	fffff097          	auipc	ra,0xfffff
    80002e60:	7c0080e7          	jalr	1984(ra) # 8000261c <exit>
    if (which_dev == 2) {
    80002e64:	4789                	li	a5,2
    80002e66:	04f90f63          	beq	s2,a5,80002ec4 <usertrap+0x106>
    usertrapret();
    80002e6a:	00000097          	auipc	ra,0x0
    80002e6e:	dce080e7          	jalr	-562(ra) # 80002c38 <usertrapret>
}
    80002e72:	60e2                	ld	ra,24(sp)
    80002e74:	6442                	ld	s0,16(sp)
    80002e76:	64a2                	ld	s1,8(sp)
    80002e78:	6902                	ld	s2,0(sp)
    80002e7a:	6105                	addi	sp,sp,32
    80002e7c:	8082                	ret
            exit(-1);
    80002e7e:	557d                	li	a0,-1
    80002e80:	fffff097          	auipc	ra,0xfffff
    80002e84:	79c080e7          	jalr	1948(ra) # 8000261c <exit>
    80002e88:	b765                	j	80002e30 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002e8a:	142025f3          	csrr	a1,scause
        printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002e8e:	5890                	lw	a2,48(s1)
    80002e90:	00005517          	auipc	a0,0x5
    80002e94:	54850513          	addi	a0,a0,1352 # 800083d8 <etext+0x3d8>
    80002e98:	ffffd097          	auipc	ra,0xffffd
    80002e9c:	712080e7          	jalr	1810(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002ea0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002ea4:	14302673          	csrr	a2,stval
        printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002ea8:	00005517          	auipc	a0,0x5
    80002eac:	56050513          	addi	a0,a0,1376 # 80008408 <etext+0x408>
    80002eb0:	ffffd097          	auipc	ra,0xffffd
    80002eb4:	6fa080e7          	jalr	1786(ra) # 800005aa <printf>
        setkilled(p);
    80002eb8:	8526                	mv	a0,s1
    80002eba:	00000097          	auipc	ra,0x0
    80002ebe:	8aa080e7          	jalr	-1878(ra) # 80002764 <setkilled>
    80002ec2:	b769                	j	80002e4c <usertrap+0x8e>
        myproc()->queue_ticks++;
    80002ec4:	fffff097          	auipc	ra,0xfffff
    80002ec8:	e42080e7          	jalr	-446(ra) # 80001d06 <myproc>
    80002ecc:	16c52783          	lw	a5,364(a0)
    80002ed0:	2785                	addiw	a5,a5,1
    80002ed2:	16f52623          	sw	a5,364(a0)
        yield(YIELD_TIMER);
    80002ed6:	4505                	li	a0,1
    80002ed8:	fffff097          	auipc	ra,0xfffff
    80002edc:	5d4080e7          	jalr	1492(ra) # 800024ac <yield>
    80002ee0:	b769                	j	80002e6a <usertrap+0xac>

0000000080002ee2 <kerneltrap>:
{
    80002ee2:	7179                	addi	sp,sp,-48
    80002ee4:	f406                	sd	ra,40(sp)
    80002ee6:	f022                	sd	s0,32(sp)
    80002ee8:	ec26                	sd	s1,24(sp)
    80002eea:	e84a                	sd	s2,16(sp)
    80002eec:	e44e                	sd	s3,8(sp)
    80002eee:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002ef0:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ef4:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002ef8:	142029f3          	csrr	s3,scause
    if ((sstatus & SSTATUS_SPP) == 0)
    80002efc:	1004f793          	andi	a5,s1,256
    80002f00:	cb85                	beqz	a5,80002f30 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002f02:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002f06:	8b89                	andi	a5,a5,2
    if (intr_get() != 0)
    80002f08:	ef85                	bnez	a5,80002f40 <kerneltrap+0x5e>
    if ((which_dev = devintr()) == 0)
    80002f0a:	00000097          	auipc	ra,0x0
    80002f0e:	e0a080e7          	jalr	-502(ra) # 80002d14 <devintr>
    80002f12:	cd1d                	beqz	a0,80002f50 <kerneltrap+0x6e>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING) {
    80002f14:	4789                	li	a5,2
    80002f16:	06f50a63          	beq	a0,a5,80002f8a <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002f1a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002f1e:	10049073          	csrw	sstatus,s1
}
    80002f22:	70a2                	ld	ra,40(sp)
    80002f24:	7402                	ld	s0,32(sp)
    80002f26:	64e2                	ld	s1,24(sp)
    80002f28:	6942                	ld	s2,16(sp)
    80002f2a:	69a2                	ld	s3,8(sp)
    80002f2c:	6145                	addi	sp,sp,48
    80002f2e:	8082                	ret
        panic("kerneltrap: not from supervisor mode");
    80002f30:	00005517          	auipc	a0,0x5
    80002f34:	4f850513          	addi	a0,a0,1272 # 80008428 <etext+0x428>
    80002f38:	ffffd097          	auipc	ra,0xffffd
    80002f3c:	628080e7          	jalr	1576(ra) # 80000560 <panic>
        panic("kerneltrap: interrupts enabled");
    80002f40:	00005517          	auipc	a0,0x5
    80002f44:	51050513          	addi	a0,a0,1296 # 80008450 <etext+0x450>
    80002f48:	ffffd097          	auipc	ra,0xffffd
    80002f4c:	618080e7          	jalr	1560(ra) # 80000560 <panic>
        printf("scause %p\n", scause);
    80002f50:	85ce                	mv	a1,s3
    80002f52:	00005517          	auipc	a0,0x5
    80002f56:	51e50513          	addi	a0,a0,1310 # 80008470 <etext+0x470>
    80002f5a:	ffffd097          	auipc	ra,0xffffd
    80002f5e:	650080e7          	jalr	1616(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002f62:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002f66:	14302673          	csrr	a2,stval
        printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002f6a:	00005517          	auipc	a0,0x5
    80002f6e:	51650513          	addi	a0,a0,1302 # 80008480 <etext+0x480>
    80002f72:	ffffd097          	auipc	ra,0xffffd
    80002f76:	638080e7          	jalr	1592(ra) # 800005aa <printf>
        panic("kerneltrap");
    80002f7a:	00005517          	auipc	a0,0x5
    80002f7e:	51e50513          	addi	a0,a0,1310 # 80008498 <etext+0x498>
    80002f82:	ffffd097          	auipc	ra,0xffffd
    80002f86:	5de080e7          	jalr	1502(ra) # 80000560 <panic>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING) {
    80002f8a:	fffff097          	auipc	ra,0xfffff
    80002f8e:	d7c080e7          	jalr	-644(ra) # 80001d06 <myproc>
    80002f92:	d541                	beqz	a0,80002f1a <kerneltrap+0x38>
    80002f94:	fffff097          	auipc	ra,0xfffff
    80002f98:	d72080e7          	jalr	-654(ra) # 80001d06 <myproc>
    80002f9c:	4d18                	lw	a4,24(a0)
    80002f9e:	4791                	li	a5,4
    80002fa0:	f6f71de3          	bne	a4,a5,80002f1a <kerneltrap+0x38>
        myproc()->queue_ticks++;
    80002fa4:	fffff097          	auipc	ra,0xfffff
    80002fa8:	d62080e7          	jalr	-670(ra) # 80001d06 <myproc>
    80002fac:	16c52783          	lw	a5,364(a0)
    80002fb0:	2785                	addiw	a5,a5,1
    80002fb2:	16f52623          	sw	a5,364(a0)
        yield(YIELD_OTHER);
    80002fb6:	4509                	li	a0,2
    80002fb8:	fffff097          	auipc	ra,0xfffff
    80002fbc:	4f4080e7          	jalr	1268(ra) # 800024ac <yield>
    80002fc0:	bfa9                	j	80002f1a <kerneltrap+0x38>

0000000080002fc2 <argraw>:
    return strlen(buf);
}

static uint64
argraw(int n)
{
    80002fc2:	1101                	addi	sp,sp,-32
    80002fc4:	ec06                	sd	ra,24(sp)
    80002fc6:	e822                	sd	s0,16(sp)
    80002fc8:	e426                	sd	s1,8(sp)
    80002fca:	1000                	addi	s0,sp,32
    80002fcc:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    80002fce:	fffff097          	auipc	ra,0xfffff
    80002fd2:	d38080e7          	jalr	-712(ra) # 80001d06 <myproc>
    switch (n)
    80002fd6:	4795                	li	a5,5
    80002fd8:	0497e163          	bltu	a5,s1,8000301a <argraw+0x58>
    80002fdc:	048a                	slli	s1,s1,0x2
    80002fde:	00006717          	auipc	a4,0x6
    80002fe2:	87a70713          	addi	a4,a4,-1926 # 80008858 <states.0+0x30>
    80002fe6:	94ba                	add	s1,s1,a4
    80002fe8:	409c                	lw	a5,0(s1)
    80002fea:	97ba                	add	a5,a5,a4
    80002fec:	8782                	jr	a5
    {
    case 0:
        return p->trapframe->a0;
    80002fee:	6d3c                	ld	a5,88(a0)
    80002ff0:	7ba8                	ld	a0,112(a5)
    case 5:
        return p->trapframe->a5;
    }
    panic("argraw");
    return -1;
}
    80002ff2:	60e2                	ld	ra,24(sp)
    80002ff4:	6442                	ld	s0,16(sp)
    80002ff6:	64a2                	ld	s1,8(sp)
    80002ff8:	6105                	addi	sp,sp,32
    80002ffa:	8082                	ret
        return p->trapframe->a1;
    80002ffc:	6d3c                	ld	a5,88(a0)
    80002ffe:	7fa8                	ld	a0,120(a5)
    80003000:	bfcd                	j	80002ff2 <argraw+0x30>
        return p->trapframe->a2;
    80003002:	6d3c                	ld	a5,88(a0)
    80003004:	63c8                	ld	a0,128(a5)
    80003006:	b7f5                	j	80002ff2 <argraw+0x30>
        return p->trapframe->a3;
    80003008:	6d3c                	ld	a5,88(a0)
    8000300a:	67c8                	ld	a0,136(a5)
    8000300c:	b7dd                	j	80002ff2 <argraw+0x30>
        return p->trapframe->a4;
    8000300e:	6d3c                	ld	a5,88(a0)
    80003010:	6bc8                	ld	a0,144(a5)
    80003012:	b7c5                	j	80002ff2 <argraw+0x30>
        return p->trapframe->a5;
    80003014:	6d3c                	ld	a5,88(a0)
    80003016:	6fc8                	ld	a0,152(a5)
    80003018:	bfe9                	j	80002ff2 <argraw+0x30>
    panic("argraw");
    8000301a:	00005517          	auipc	a0,0x5
    8000301e:	48e50513          	addi	a0,a0,1166 # 800084a8 <etext+0x4a8>
    80003022:	ffffd097          	auipc	ra,0xffffd
    80003026:	53e080e7          	jalr	1342(ra) # 80000560 <panic>

000000008000302a <fetchaddr>:
{
    8000302a:	1101                	addi	sp,sp,-32
    8000302c:	ec06                	sd	ra,24(sp)
    8000302e:	e822                	sd	s0,16(sp)
    80003030:	e426                	sd	s1,8(sp)
    80003032:	e04a                	sd	s2,0(sp)
    80003034:	1000                	addi	s0,sp,32
    80003036:	84aa                	mv	s1,a0
    80003038:	892e                	mv	s2,a1
    struct proc *p = myproc();
    8000303a:	fffff097          	auipc	ra,0xfffff
    8000303e:	ccc080e7          	jalr	-820(ra) # 80001d06 <myproc>
    if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80003042:	653c                	ld	a5,72(a0)
    80003044:	02f4f863          	bgeu	s1,a5,80003074 <fetchaddr+0x4a>
    80003048:	00848713          	addi	a4,s1,8
    8000304c:	02e7e663          	bltu	a5,a4,80003078 <fetchaddr+0x4e>
    if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80003050:	46a1                	li	a3,8
    80003052:	8626                	mv	a2,s1
    80003054:	85ca                	mv	a1,s2
    80003056:	6928                	ld	a0,80(a0)
    80003058:	ffffe097          	auipc	ra,0xffffe
    8000305c:	744080e7          	jalr	1860(ra) # 8000179c <copyin>
    80003060:	00a03533          	snez	a0,a0
    80003064:	40a0053b          	negw	a0,a0
}
    80003068:	60e2                	ld	ra,24(sp)
    8000306a:	6442                	ld	s0,16(sp)
    8000306c:	64a2                	ld	s1,8(sp)
    8000306e:	6902                	ld	s2,0(sp)
    80003070:	6105                	addi	sp,sp,32
    80003072:	8082                	ret
        return -1;
    80003074:	557d                	li	a0,-1
    80003076:	bfcd                	j	80003068 <fetchaddr+0x3e>
    80003078:	557d                	li	a0,-1
    8000307a:	b7fd                	j	80003068 <fetchaddr+0x3e>

000000008000307c <fetchstr>:
{
    8000307c:	7179                	addi	sp,sp,-48
    8000307e:	f406                	sd	ra,40(sp)
    80003080:	f022                	sd	s0,32(sp)
    80003082:	ec26                	sd	s1,24(sp)
    80003084:	e84a                	sd	s2,16(sp)
    80003086:	e44e                	sd	s3,8(sp)
    80003088:	1800                	addi	s0,sp,48
    8000308a:	892a                	mv	s2,a0
    8000308c:	84ae                	mv	s1,a1
    8000308e:	89b2                	mv	s3,a2
    struct proc *p = myproc();
    80003090:	fffff097          	auipc	ra,0xfffff
    80003094:	c76080e7          	jalr	-906(ra) # 80001d06 <myproc>
    if (copyinstr(p->pagetable, buf, addr, max) < 0)
    80003098:	86ce                	mv	a3,s3
    8000309a:	864a                	mv	a2,s2
    8000309c:	85a6                	mv	a1,s1
    8000309e:	6928                	ld	a0,80(a0)
    800030a0:	ffffe097          	auipc	ra,0xffffe
    800030a4:	78a080e7          	jalr	1930(ra) # 8000182a <copyinstr>
    800030a8:	00054e63          	bltz	a0,800030c4 <fetchstr+0x48>
    return strlen(buf);
    800030ac:	8526                	mv	a0,s1
    800030ae:	ffffe097          	auipc	ra,0xffffe
    800030b2:	e14080e7          	jalr	-492(ra) # 80000ec2 <strlen>
}
    800030b6:	70a2                	ld	ra,40(sp)
    800030b8:	7402                	ld	s0,32(sp)
    800030ba:	64e2                	ld	s1,24(sp)
    800030bc:	6942                	ld	s2,16(sp)
    800030be:	69a2                	ld	s3,8(sp)
    800030c0:	6145                	addi	sp,sp,48
    800030c2:	8082                	ret
        return -1;
    800030c4:	557d                	li	a0,-1
    800030c6:	bfc5                	j	800030b6 <fetchstr+0x3a>

00000000800030c8 <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip)
{
    800030c8:	1101                	addi	sp,sp,-32
    800030ca:	ec06                	sd	ra,24(sp)
    800030cc:	e822                	sd	s0,16(sp)
    800030ce:	e426                	sd	s1,8(sp)
    800030d0:	1000                	addi	s0,sp,32
    800030d2:	84ae                	mv	s1,a1
    *ip = argraw(n);
    800030d4:	00000097          	auipc	ra,0x0
    800030d8:	eee080e7          	jalr	-274(ra) # 80002fc2 <argraw>
    800030dc:	c088                	sw	a0,0(s1)
}
    800030de:	60e2                	ld	ra,24(sp)
    800030e0:	6442                	ld	s0,16(sp)
    800030e2:	64a2                	ld	s1,8(sp)
    800030e4:	6105                	addi	sp,sp,32
    800030e6:	8082                	ret

00000000800030e8 <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip)
{
    800030e8:	1101                	addi	sp,sp,-32
    800030ea:	ec06                	sd	ra,24(sp)
    800030ec:	e822                	sd	s0,16(sp)
    800030ee:	e426                	sd	s1,8(sp)
    800030f0:	1000                	addi	s0,sp,32
    800030f2:	84ae                	mv	s1,a1
    *ip = argraw(n);
    800030f4:	00000097          	auipc	ra,0x0
    800030f8:	ece080e7          	jalr	-306(ra) # 80002fc2 <argraw>
    800030fc:	e088                	sd	a0,0(s1)
}
    800030fe:	60e2                	ld	ra,24(sp)
    80003100:	6442                	ld	s0,16(sp)
    80003102:	64a2                	ld	s1,8(sp)
    80003104:	6105                	addi	sp,sp,32
    80003106:	8082                	ret

0000000080003108 <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    80003108:	1101                	addi	sp,sp,-32
    8000310a:	ec06                	sd	ra,24(sp)
    8000310c:	e822                	sd	s0,16(sp)
    8000310e:	e426                	sd	s1,8(sp)
    80003110:	e04a                	sd	s2,0(sp)
    80003112:	1000                	addi	s0,sp,32
    80003114:	84ae                	mv	s1,a1
    80003116:	8932                	mv	s2,a2
    *ip = argraw(n);
    80003118:	00000097          	auipc	ra,0x0
    8000311c:	eaa080e7          	jalr	-342(ra) # 80002fc2 <argraw>
    uint64 addr;
    argaddr(n, &addr);
    return fetchstr(addr, buf, max);
    80003120:	864a                	mv	a2,s2
    80003122:	85a6                	mv	a1,s1
    80003124:	00000097          	auipc	ra,0x0
    80003128:	f58080e7          	jalr	-168(ra) # 8000307c <fetchstr>
}
    8000312c:	60e2                	ld	ra,24(sp)
    8000312e:	6442                	ld	s0,16(sp)
    80003130:	64a2                	ld	s1,8(sp)
    80003132:	6902                	ld	s2,0(sp)
    80003134:	6105                	addi	sp,sp,32
    80003136:	8082                	ret

0000000080003138 <syscall>:
    [SYS_schedset] sys_schedset,
    [SYS_yield] sys_yield,
};

void syscall(void)
{
    80003138:	1101                	addi	sp,sp,-32
    8000313a:	ec06                	sd	ra,24(sp)
    8000313c:	e822                	sd	s0,16(sp)
    8000313e:	e426                	sd	s1,8(sp)
    80003140:	e04a                	sd	s2,0(sp)
    80003142:	1000                	addi	s0,sp,32
    int num;
    struct proc *p = myproc();
    80003144:	fffff097          	auipc	ra,0xfffff
    80003148:	bc2080e7          	jalr	-1086(ra) # 80001d06 <myproc>
    8000314c:	84aa                	mv	s1,a0

    num = p->trapframe->a7;
    8000314e:	05853903          	ld	s2,88(a0)
    80003152:	0a893783          	ld	a5,168(s2)
    80003156:	0007869b          	sext.w	a3,a5
    if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    8000315a:	37fd                	addiw	a5,a5,-1
    8000315c:	4761                	li	a4,24
    8000315e:	00f76f63          	bltu	a4,a5,8000317c <syscall+0x44>
    80003162:	00369713          	slli	a4,a3,0x3
    80003166:	00005797          	auipc	a5,0x5
    8000316a:	70a78793          	addi	a5,a5,1802 # 80008870 <syscalls>
    8000316e:	97ba                	add	a5,a5,a4
    80003170:	639c                	ld	a5,0(a5)
    80003172:	c789                	beqz	a5,8000317c <syscall+0x44>
    {
        // Use num to lookup the system call function for num, call it,
        // and store its return value in p->trapframe->a0
        p->trapframe->a0 = syscalls[num]();
    80003174:	9782                	jalr	a5
    80003176:	06a93823          	sd	a0,112(s2)
    8000317a:	a839                	j	80003198 <syscall+0x60>
    }
    else
    {
        printf("%d %s: unknown sys call %d\n",
    8000317c:	15848613          	addi	a2,s1,344
    80003180:	588c                	lw	a1,48(s1)
    80003182:	00005517          	auipc	a0,0x5
    80003186:	32e50513          	addi	a0,a0,814 # 800084b0 <etext+0x4b0>
    8000318a:	ffffd097          	auipc	ra,0xffffd
    8000318e:	420080e7          	jalr	1056(ra) # 800005aa <printf>
               p->pid, p->name, num);
        p->trapframe->a0 = -1;
    80003192:	6cbc                	ld	a5,88(s1)
    80003194:	577d                	li	a4,-1
    80003196:	fbb8                	sd	a4,112(a5)
    }
}
    80003198:	60e2                	ld	ra,24(sp)
    8000319a:	6442                	ld	s0,16(sp)
    8000319c:	64a2                	ld	s1,8(sp)
    8000319e:	6902                	ld	s2,0(sp)
    800031a0:	6105                	addi	sp,sp,32
    800031a2:	8082                	ret

00000000800031a4 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800031a4:	1101                	addi	sp,sp,-32
    800031a6:	ec06                	sd	ra,24(sp)
    800031a8:	e822                	sd	s0,16(sp)
    800031aa:	1000                	addi	s0,sp,32
    int n;
    argint(0, &n);
    800031ac:	fec40593          	addi	a1,s0,-20
    800031b0:	4501                	li	a0,0
    800031b2:	00000097          	auipc	ra,0x0
    800031b6:	f16080e7          	jalr	-234(ra) # 800030c8 <argint>
    exit(n);
    800031ba:	fec42503          	lw	a0,-20(s0)
    800031be:	fffff097          	auipc	ra,0xfffff
    800031c2:	45e080e7          	jalr	1118(ra) # 8000261c <exit>
    return 0; // not reached
}
    800031c6:	4501                	li	a0,0
    800031c8:	60e2                	ld	ra,24(sp)
    800031ca:	6442                	ld	s0,16(sp)
    800031cc:	6105                	addi	sp,sp,32
    800031ce:	8082                	ret

00000000800031d0 <sys_getpid>:

uint64
sys_getpid(void)
{
    800031d0:	1141                	addi	sp,sp,-16
    800031d2:	e406                	sd	ra,8(sp)
    800031d4:	e022                	sd	s0,0(sp)
    800031d6:	0800                	addi	s0,sp,16
    return myproc()->pid;
    800031d8:	fffff097          	auipc	ra,0xfffff
    800031dc:	b2e080e7          	jalr	-1234(ra) # 80001d06 <myproc>
}
    800031e0:	5908                	lw	a0,48(a0)
    800031e2:	60a2                	ld	ra,8(sp)
    800031e4:	6402                	ld	s0,0(sp)
    800031e6:	0141                	addi	sp,sp,16
    800031e8:	8082                	ret

00000000800031ea <sys_fork>:

uint64
sys_fork(void)
{
    800031ea:	1141                	addi	sp,sp,-16
    800031ec:	e406                	sd	ra,8(sp)
    800031ee:	e022                	sd	s0,0(sp)
    800031f0:	0800                	addi	s0,sp,16
    return fork();
    800031f2:	fffff097          	auipc	ra,0xfffff
    800031f6:	06c080e7          	jalr	108(ra) # 8000225e <fork>
}
    800031fa:	60a2                	ld	ra,8(sp)
    800031fc:	6402                	ld	s0,0(sp)
    800031fe:	0141                	addi	sp,sp,16
    80003200:	8082                	ret

0000000080003202 <sys_wait>:

uint64
sys_wait(void)
{
    80003202:	1101                	addi	sp,sp,-32
    80003204:	ec06                	sd	ra,24(sp)
    80003206:	e822                	sd	s0,16(sp)
    80003208:	1000                	addi	s0,sp,32
    uint64 p;
    argaddr(0, &p);
    8000320a:	fe840593          	addi	a1,s0,-24
    8000320e:	4501                	li	a0,0
    80003210:	00000097          	auipc	ra,0x0
    80003214:	ed8080e7          	jalr	-296(ra) # 800030e8 <argaddr>
    return wait(p);
    80003218:	fe843503          	ld	a0,-24(s0)
    8000321c:	fffff097          	auipc	ra,0xfffff
    80003220:	5a6080e7          	jalr	1446(ra) # 800027c2 <wait>
}
    80003224:	60e2                	ld	ra,24(sp)
    80003226:	6442                	ld	s0,16(sp)
    80003228:	6105                	addi	sp,sp,32
    8000322a:	8082                	ret

000000008000322c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000322c:	7179                	addi	sp,sp,-48
    8000322e:	f406                	sd	ra,40(sp)
    80003230:	f022                	sd	s0,32(sp)
    80003232:	ec26                	sd	s1,24(sp)
    80003234:	1800                	addi	s0,sp,48
    uint64 addr;
    int n;

    argint(0, &n);
    80003236:	fdc40593          	addi	a1,s0,-36
    8000323a:	4501                	li	a0,0
    8000323c:	00000097          	auipc	ra,0x0
    80003240:	e8c080e7          	jalr	-372(ra) # 800030c8 <argint>
    addr = myproc()->sz;
    80003244:	fffff097          	auipc	ra,0xfffff
    80003248:	ac2080e7          	jalr	-1342(ra) # 80001d06 <myproc>
    8000324c:	6524                	ld	s1,72(a0)
    if (growproc(n) < 0)
    8000324e:	fdc42503          	lw	a0,-36(s0)
    80003252:	fffff097          	auipc	ra,0xfffff
    80003256:	e16080e7          	jalr	-490(ra) # 80002068 <growproc>
    8000325a:	00054863          	bltz	a0,8000326a <sys_sbrk+0x3e>
        return -1;
    return addr;
}
    8000325e:	8526                	mv	a0,s1
    80003260:	70a2                	ld	ra,40(sp)
    80003262:	7402                	ld	s0,32(sp)
    80003264:	64e2                	ld	s1,24(sp)
    80003266:	6145                	addi	sp,sp,48
    80003268:	8082                	ret
        return -1;
    8000326a:	54fd                	li	s1,-1
    8000326c:	bfcd                	j	8000325e <sys_sbrk+0x32>

000000008000326e <sys_sleep>:

uint64
sys_sleep(void)
{
    8000326e:	7139                	addi	sp,sp,-64
    80003270:	fc06                	sd	ra,56(sp)
    80003272:	f822                	sd	s0,48(sp)
    80003274:	f04a                	sd	s2,32(sp)
    80003276:	0080                	addi	s0,sp,64
    int n;
    uint ticks0;

    argint(0, &n);
    80003278:	fcc40593          	addi	a1,s0,-52
    8000327c:	4501                	li	a0,0
    8000327e:	00000097          	auipc	ra,0x0
    80003282:	e4a080e7          	jalr	-438(ra) # 800030c8 <argint>
    acquire(&tickslock);
    80003286:	00014517          	auipc	a0,0x14
    8000328a:	a2a50513          	addi	a0,a0,-1494 # 80016cb0 <tickslock>
    8000328e:	ffffe097          	auipc	ra,0xffffe
    80003292:	9b0080e7          	jalr	-1616(ra) # 80000c3e <acquire>
    ticks0 = ticks;
    80003296:	00005917          	auipc	s2,0x5
    8000329a:	78292903          	lw	s2,1922(s2) # 80008a18 <ticks>
    while (ticks - ticks0 < n)
    8000329e:	fcc42783          	lw	a5,-52(s0)
    800032a2:	c3b9                	beqz	a5,800032e8 <sys_sleep+0x7a>
    800032a4:	f426                	sd	s1,40(sp)
    800032a6:	ec4e                	sd	s3,24(sp)
        if (killed(myproc()))
        {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
    800032a8:	00014997          	auipc	s3,0x14
    800032ac:	a0898993          	addi	s3,s3,-1528 # 80016cb0 <tickslock>
    800032b0:	00005497          	auipc	s1,0x5
    800032b4:	76848493          	addi	s1,s1,1896 # 80008a18 <ticks>
        if (killed(myproc()))
    800032b8:	fffff097          	auipc	ra,0xfffff
    800032bc:	a4e080e7          	jalr	-1458(ra) # 80001d06 <myproc>
    800032c0:	fffff097          	auipc	ra,0xfffff
    800032c4:	4d0080e7          	jalr	1232(ra) # 80002790 <killed>
    800032c8:	ed15                	bnez	a0,80003304 <sys_sleep+0x96>
        sleep(&ticks, &tickslock);
    800032ca:	85ce                	mv	a1,s3
    800032cc:	8526                	mv	a0,s1
    800032ce:	fffff097          	auipc	ra,0xfffff
    800032d2:	21a080e7          	jalr	538(ra) # 800024e8 <sleep>
    while (ticks - ticks0 < n)
    800032d6:	409c                	lw	a5,0(s1)
    800032d8:	412787bb          	subw	a5,a5,s2
    800032dc:	fcc42703          	lw	a4,-52(s0)
    800032e0:	fce7ece3          	bltu	a5,a4,800032b8 <sys_sleep+0x4a>
    800032e4:	74a2                	ld	s1,40(sp)
    800032e6:	69e2                	ld	s3,24(sp)
    }
    release(&tickslock);
    800032e8:	00014517          	auipc	a0,0x14
    800032ec:	9c850513          	addi	a0,a0,-1592 # 80016cb0 <tickslock>
    800032f0:	ffffe097          	auipc	ra,0xffffe
    800032f4:	9fe080e7          	jalr	-1538(ra) # 80000cee <release>
    return 0;
    800032f8:	4501                	li	a0,0
}
    800032fa:	70e2                	ld	ra,56(sp)
    800032fc:	7442                	ld	s0,48(sp)
    800032fe:	7902                	ld	s2,32(sp)
    80003300:	6121                	addi	sp,sp,64
    80003302:	8082                	ret
            release(&tickslock);
    80003304:	00014517          	auipc	a0,0x14
    80003308:	9ac50513          	addi	a0,a0,-1620 # 80016cb0 <tickslock>
    8000330c:	ffffe097          	auipc	ra,0xffffe
    80003310:	9e2080e7          	jalr	-1566(ra) # 80000cee <release>
            return -1;
    80003314:	557d                	li	a0,-1
    80003316:	74a2                	ld	s1,40(sp)
    80003318:	69e2                	ld	s3,24(sp)
    8000331a:	b7c5                	j	800032fa <sys_sleep+0x8c>

000000008000331c <sys_kill>:

uint64
sys_kill(void)
{
    8000331c:	1101                	addi	sp,sp,-32
    8000331e:	ec06                	sd	ra,24(sp)
    80003320:	e822                	sd	s0,16(sp)
    80003322:	1000                	addi	s0,sp,32
    int pid;

    argint(0, &pid);
    80003324:	fec40593          	addi	a1,s0,-20
    80003328:	4501                	li	a0,0
    8000332a:	00000097          	auipc	ra,0x0
    8000332e:	d9e080e7          	jalr	-610(ra) # 800030c8 <argint>
    return kill(pid);
    80003332:	fec42503          	lw	a0,-20(s0)
    80003336:	fffff097          	auipc	ra,0xfffff
    8000333a:	3bc080e7          	jalr	956(ra) # 800026f2 <kill>
}
    8000333e:	60e2                	ld	ra,24(sp)
    80003340:	6442                	ld	s0,16(sp)
    80003342:	6105                	addi	sp,sp,32
    80003344:	8082                	ret

0000000080003346 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80003346:	1101                	addi	sp,sp,-32
    80003348:	ec06                	sd	ra,24(sp)
    8000334a:	e822                	sd	s0,16(sp)
    8000334c:	e426                	sd	s1,8(sp)
    8000334e:	1000                	addi	s0,sp,32
    uint xticks;

    acquire(&tickslock);
    80003350:	00014517          	auipc	a0,0x14
    80003354:	96050513          	addi	a0,a0,-1696 # 80016cb0 <tickslock>
    80003358:	ffffe097          	auipc	ra,0xffffe
    8000335c:	8e6080e7          	jalr	-1818(ra) # 80000c3e <acquire>
    xticks = ticks;
    80003360:	00005497          	auipc	s1,0x5
    80003364:	6b84a483          	lw	s1,1720(s1) # 80008a18 <ticks>
    release(&tickslock);
    80003368:	00014517          	auipc	a0,0x14
    8000336c:	94850513          	addi	a0,a0,-1720 # 80016cb0 <tickslock>
    80003370:	ffffe097          	auipc	ra,0xffffe
    80003374:	97e080e7          	jalr	-1666(ra) # 80000cee <release>
    return xticks;
}
    80003378:	02049513          	slli	a0,s1,0x20
    8000337c:	9101                	srli	a0,a0,0x20
    8000337e:	60e2                	ld	ra,24(sp)
    80003380:	6442                	ld	s0,16(sp)
    80003382:	64a2                	ld	s1,8(sp)
    80003384:	6105                	addi	sp,sp,32
    80003386:	8082                	ret

0000000080003388 <sys_ps>:

void *
sys_ps(void)
{
    80003388:	1101                	addi	sp,sp,-32
    8000338a:	ec06                	sd	ra,24(sp)
    8000338c:	e822                	sd	s0,16(sp)
    8000338e:	1000                	addi	s0,sp,32
    int start = 0, count = 0;
    80003390:	fe042623          	sw	zero,-20(s0)
    80003394:	fe042423          	sw	zero,-24(s0)
    argint(0, &start);
    80003398:	fec40593          	addi	a1,s0,-20
    8000339c:	4501                	li	a0,0
    8000339e:	00000097          	auipc	ra,0x0
    800033a2:	d2a080e7          	jalr	-726(ra) # 800030c8 <argint>
    argint(1, &count);
    800033a6:	fe840593          	addi	a1,s0,-24
    800033aa:	4505                	li	a0,1
    800033ac:	00000097          	auipc	ra,0x0
    800033b0:	d1c080e7          	jalr	-740(ra) # 800030c8 <argint>
    return ps((uint8)start, (uint8)count);
    800033b4:	fe844583          	lbu	a1,-24(s0)
    800033b8:	fec44503          	lbu	a0,-20(s0)
    800033bc:	fffff097          	auipc	ra,0xfffff
    800033c0:	d08080e7          	jalr	-760(ra) # 800020c4 <ps>
}
    800033c4:	60e2                	ld	ra,24(sp)
    800033c6:	6442                	ld	s0,16(sp)
    800033c8:	6105                	addi	sp,sp,32
    800033ca:	8082                	ret

00000000800033cc <sys_schedls>:

uint64 sys_schedls(void)
{
    800033cc:	1141                	addi	sp,sp,-16
    800033ce:	e406                	sd	ra,8(sp)
    800033d0:	e022                	sd	s0,0(sp)
    800033d2:	0800                	addi	s0,sp,16
    schedls();
    800033d4:	fffff097          	auipc	ra,0xfffff
    800033d8:	672080e7          	jalr	1650(ra) # 80002a46 <schedls>
    return 0;
}
    800033dc:	4501                	li	a0,0
    800033de:	60a2                	ld	ra,8(sp)
    800033e0:	6402                	ld	s0,0(sp)
    800033e2:	0141                	addi	sp,sp,16
    800033e4:	8082                	ret

00000000800033e6 <sys_schedset>:

uint64 sys_schedset(void)
{
    800033e6:	1101                	addi	sp,sp,-32
    800033e8:	ec06                	sd	ra,24(sp)
    800033ea:	e822                	sd	s0,16(sp)
    800033ec:	1000                	addi	s0,sp,32
    int id = 0;
    800033ee:	fe042623          	sw	zero,-20(s0)
    argint(0, &id);
    800033f2:	fec40593          	addi	a1,s0,-20
    800033f6:	4501                	li	a0,0
    800033f8:	00000097          	auipc	ra,0x0
    800033fc:	cd0080e7          	jalr	-816(ra) # 800030c8 <argint>
    schedset(id - 1);
    80003400:	fec42503          	lw	a0,-20(s0)
    80003404:	357d                	addiw	a0,a0,-1
    80003406:	fffff097          	auipc	ra,0xfffff
    8000340a:	72c080e7          	jalr	1836(ra) # 80002b32 <schedset>
    return 0;
}
    8000340e:	4501                	li	a0,0
    80003410:	60e2                	ld	ra,24(sp)
    80003412:	6442                	ld	s0,16(sp)
    80003414:	6105                	addi	sp,sp,32
    80003416:	8082                	ret

0000000080003418 <sys_yield>:

uint64 sys_yield(void)
{
    80003418:	1141                	addi	sp,sp,-16
    8000341a:	e406                	sd	ra,8(sp)
    8000341c:	e022                	sd	s0,0(sp)
    8000341e:	0800                	addi	s0,sp,16
    yield(YIELD_OTHER);
    80003420:	4509                	li	a0,2
    80003422:	fffff097          	auipc	ra,0xfffff
    80003426:	08a080e7          	jalr	138(ra) # 800024ac <yield>
    return 0;
    8000342a:	4501                	li	a0,0
    8000342c:	60a2                	ld	ra,8(sp)
    8000342e:	6402                	ld	s0,0(sp)
    80003430:	0141                	addi	sp,sp,16
    80003432:	8082                	ret

0000000080003434 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003434:	7179                	addi	sp,sp,-48
    80003436:	f406                	sd	ra,40(sp)
    80003438:	f022                	sd	s0,32(sp)
    8000343a:	ec26                	sd	s1,24(sp)
    8000343c:	e84a                	sd	s2,16(sp)
    8000343e:	e44e                	sd	s3,8(sp)
    80003440:	e052                	sd	s4,0(sp)
    80003442:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003444:	00005597          	auipc	a1,0x5
    80003448:	08c58593          	addi	a1,a1,140 # 800084d0 <etext+0x4d0>
    8000344c:	00014517          	auipc	a0,0x14
    80003450:	87c50513          	addi	a0,a0,-1924 # 80016cc8 <bcache>
    80003454:	ffffd097          	auipc	ra,0xffffd
    80003458:	756080e7          	jalr	1878(ra) # 80000baa <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000345c:	0001c797          	auipc	a5,0x1c
    80003460:	86c78793          	addi	a5,a5,-1940 # 8001ecc8 <bcache+0x8000>
    80003464:	0001c717          	auipc	a4,0x1c
    80003468:	acc70713          	addi	a4,a4,-1332 # 8001ef30 <bcache+0x8268>
    8000346c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003470:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003474:	00014497          	auipc	s1,0x14
    80003478:	86c48493          	addi	s1,s1,-1940 # 80016ce0 <bcache+0x18>
    b->next = bcache.head.next;
    8000347c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000347e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003480:	00005a17          	auipc	s4,0x5
    80003484:	058a0a13          	addi	s4,s4,88 # 800084d8 <etext+0x4d8>
    b->next = bcache.head.next;
    80003488:	2b893783          	ld	a5,696(s2)
    8000348c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000348e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003492:	85d2                	mv	a1,s4
    80003494:	01048513          	addi	a0,s1,16
    80003498:	00001097          	auipc	ra,0x1
    8000349c:	4e4080e7          	jalr	1252(ra) # 8000497c <initsleeplock>
    bcache.head.next->prev = b;
    800034a0:	2b893783          	ld	a5,696(s2)
    800034a4:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800034a6:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800034aa:	45848493          	addi	s1,s1,1112
    800034ae:	fd349de3          	bne	s1,s3,80003488 <binit+0x54>
  }
}
    800034b2:	70a2                	ld	ra,40(sp)
    800034b4:	7402                	ld	s0,32(sp)
    800034b6:	64e2                	ld	s1,24(sp)
    800034b8:	6942                	ld	s2,16(sp)
    800034ba:	69a2                	ld	s3,8(sp)
    800034bc:	6a02                	ld	s4,0(sp)
    800034be:	6145                	addi	sp,sp,48
    800034c0:	8082                	ret

00000000800034c2 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800034c2:	7179                	addi	sp,sp,-48
    800034c4:	f406                	sd	ra,40(sp)
    800034c6:	f022                	sd	s0,32(sp)
    800034c8:	ec26                	sd	s1,24(sp)
    800034ca:	e84a                	sd	s2,16(sp)
    800034cc:	e44e                	sd	s3,8(sp)
    800034ce:	1800                	addi	s0,sp,48
    800034d0:	892a                	mv	s2,a0
    800034d2:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800034d4:	00013517          	auipc	a0,0x13
    800034d8:	7f450513          	addi	a0,a0,2036 # 80016cc8 <bcache>
    800034dc:	ffffd097          	auipc	ra,0xffffd
    800034e0:	762080e7          	jalr	1890(ra) # 80000c3e <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800034e4:	0001c497          	auipc	s1,0x1c
    800034e8:	a9c4b483          	ld	s1,-1380(s1) # 8001ef80 <bcache+0x82b8>
    800034ec:	0001c797          	auipc	a5,0x1c
    800034f0:	a4478793          	addi	a5,a5,-1468 # 8001ef30 <bcache+0x8268>
    800034f4:	02f48f63          	beq	s1,a5,80003532 <bread+0x70>
    800034f8:	873e                	mv	a4,a5
    800034fa:	a021                	j	80003502 <bread+0x40>
    800034fc:	68a4                	ld	s1,80(s1)
    800034fe:	02e48a63          	beq	s1,a4,80003532 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80003502:	449c                	lw	a5,8(s1)
    80003504:	ff279ce3          	bne	a5,s2,800034fc <bread+0x3a>
    80003508:	44dc                	lw	a5,12(s1)
    8000350a:	ff3799e3          	bne	a5,s3,800034fc <bread+0x3a>
      b->refcnt++;
    8000350e:	40bc                	lw	a5,64(s1)
    80003510:	2785                	addiw	a5,a5,1
    80003512:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003514:	00013517          	auipc	a0,0x13
    80003518:	7b450513          	addi	a0,a0,1972 # 80016cc8 <bcache>
    8000351c:	ffffd097          	auipc	ra,0xffffd
    80003520:	7d2080e7          	jalr	2002(ra) # 80000cee <release>
      acquiresleep(&b->lock);
    80003524:	01048513          	addi	a0,s1,16
    80003528:	00001097          	auipc	ra,0x1
    8000352c:	48e080e7          	jalr	1166(ra) # 800049b6 <acquiresleep>
      return b;
    80003530:	a8b9                	j	8000358e <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003532:	0001c497          	auipc	s1,0x1c
    80003536:	a464b483          	ld	s1,-1466(s1) # 8001ef78 <bcache+0x82b0>
    8000353a:	0001c797          	auipc	a5,0x1c
    8000353e:	9f678793          	addi	a5,a5,-1546 # 8001ef30 <bcache+0x8268>
    80003542:	00f48863          	beq	s1,a5,80003552 <bread+0x90>
    80003546:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003548:	40bc                	lw	a5,64(s1)
    8000354a:	cf81                	beqz	a5,80003562 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000354c:	64a4                	ld	s1,72(s1)
    8000354e:	fee49de3          	bne	s1,a4,80003548 <bread+0x86>
  panic("bget: no buffers");
    80003552:	00005517          	auipc	a0,0x5
    80003556:	f8e50513          	addi	a0,a0,-114 # 800084e0 <etext+0x4e0>
    8000355a:	ffffd097          	auipc	ra,0xffffd
    8000355e:	006080e7          	jalr	6(ra) # 80000560 <panic>
      b->dev = dev;
    80003562:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003566:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000356a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000356e:	4785                	li	a5,1
    80003570:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003572:	00013517          	auipc	a0,0x13
    80003576:	75650513          	addi	a0,a0,1878 # 80016cc8 <bcache>
    8000357a:	ffffd097          	auipc	ra,0xffffd
    8000357e:	774080e7          	jalr	1908(ra) # 80000cee <release>
      acquiresleep(&b->lock);
    80003582:	01048513          	addi	a0,s1,16
    80003586:	00001097          	auipc	ra,0x1
    8000358a:	430080e7          	jalr	1072(ra) # 800049b6 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000358e:	409c                	lw	a5,0(s1)
    80003590:	cb89                	beqz	a5,800035a2 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003592:	8526                	mv	a0,s1
    80003594:	70a2                	ld	ra,40(sp)
    80003596:	7402                	ld	s0,32(sp)
    80003598:	64e2                	ld	s1,24(sp)
    8000359a:	6942                	ld	s2,16(sp)
    8000359c:	69a2                	ld	s3,8(sp)
    8000359e:	6145                	addi	sp,sp,48
    800035a0:	8082                	ret
    virtio_disk_rw(b, 0);
    800035a2:	4581                	li	a1,0
    800035a4:	8526                	mv	a0,s1
    800035a6:	00003097          	auipc	ra,0x3
    800035aa:	102080e7          	jalr	258(ra) # 800066a8 <virtio_disk_rw>
    b->valid = 1;
    800035ae:	4785                	li	a5,1
    800035b0:	c09c                	sw	a5,0(s1)
  return b;
    800035b2:	b7c5                	j	80003592 <bread+0xd0>

00000000800035b4 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800035b4:	1101                	addi	sp,sp,-32
    800035b6:	ec06                	sd	ra,24(sp)
    800035b8:	e822                	sd	s0,16(sp)
    800035ba:	e426                	sd	s1,8(sp)
    800035bc:	1000                	addi	s0,sp,32
    800035be:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800035c0:	0541                	addi	a0,a0,16
    800035c2:	00001097          	auipc	ra,0x1
    800035c6:	48e080e7          	jalr	1166(ra) # 80004a50 <holdingsleep>
    800035ca:	cd01                	beqz	a0,800035e2 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800035cc:	4585                	li	a1,1
    800035ce:	8526                	mv	a0,s1
    800035d0:	00003097          	auipc	ra,0x3
    800035d4:	0d8080e7          	jalr	216(ra) # 800066a8 <virtio_disk_rw>
}
    800035d8:	60e2                	ld	ra,24(sp)
    800035da:	6442                	ld	s0,16(sp)
    800035dc:	64a2                	ld	s1,8(sp)
    800035de:	6105                	addi	sp,sp,32
    800035e0:	8082                	ret
    panic("bwrite");
    800035e2:	00005517          	auipc	a0,0x5
    800035e6:	f1650513          	addi	a0,a0,-234 # 800084f8 <etext+0x4f8>
    800035ea:	ffffd097          	auipc	ra,0xffffd
    800035ee:	f76080e7          	jalr	-138(ra) # 80000560 <panic>

00000000800035f2 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800035f2:	1101                	addi	sp,sp,-32
    800035f4:	ec06                	sd	ra,24(sp)
    800035f6:	e822                	sd	s0,16(sp)
    800035f8:	e426                	sd	s1,8(sp)
    800035fa:	e04a                	sd	s2,0(sp)
    800035fc:	1000                	addi	s0,sp,32
    800035fe:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003600:	01050913          	addi	s2,a0,16
    80003604:	854a                	mv	a0,s2
    80003606:	00001097          	auipc	ra,0x1
    8000360a:	44a080e7          	jalr	1098(ra) # 80004a50 <holdingsleep>
    8000360e:	c535                	beqz	a0,8000367a <brelse+0x88>
    panic("brelse");

  releasesleep(&b->lock);
    80003610:	854a                	mv	a0,s2
    80003612:	00001097          	auipc	ra,0x1
    80003616:	3fa080e7          	jalr	1018(ra) # 80004a0c <releasesleep>

  acquire(&bcache.lock);
    8000361a:	00013517          	auipc	a0,0x13
    8000361e:	6ae50513          	addi	a0,a0,1710 # 80016cc8 <bcache>
    80003622:	ffffd097          	auipc	ra,0xffffd
    80003626:	61c080e7          	jalr	1564(ra) # 80000c3e <acquire>
  b->refcnt--;
    8000362a:	40bc                	lw	a5,64(s1)
    8000362c:	37fd                	addiw	a5,a5,-1
    8000362e:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003630:	e79d                	bnez	a5,8000365e <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003632:	68b8                	ld	a4,80(s1)
    80003634:	64bc                	ld	a5,72(s1)
    80003636:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003638:	68b8                	ld	a4,80(s1)
    8000363a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000363c:	0001b797          	auipc	a5,0x1b
    80003640:	68c78793          	addi	a5,a5,1676 # 8001ecc8 <bcache+0x8000>
    80003644:	2b87b703          	ld	a4,696(a5)
    80003648:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000364a:	0001c717          	auipc	a4,0x1c
    8000364e:	8e670713          	addi	a4,a4,-1818 # 8001ef30 <bcache+0x8268>
    80003652:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003654:	2b87b703          	ld	a4,696(a5)
    80003658:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000365a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000365e:	00013517          	auipc	a0,0x13
    80003662:	66a50513          	addi	a0,a0,1642 # 80016cc8 <bcache>
    80003666:	ffffd097          	auipc	ra,0xffffd
    8000366a:	688080e7          	jalr	1672(ra) # 80000cee <release>
}
    8000366e:	60e2                	ld	ra,24(sp)
    80003670:	6442                	ld	s0,16(sp)
    80003672:	64a2                	ld	s1,8(sp)
    80003674:	6902                	ld	s2,0(sp)
    80003676:	6105                	addi	sp,sp,32
    80003678:	8082                	ret
    panic("brelse");
    8000367a:	00005517          	auipc	a0,0x5
    8000367e:	e8650513          	addi	a0,a0,-378 # 80008500 <etext+0x500>
    80003682:	ffffd097          	auipc	ra,0xffffd
    80003686:	ede080e7          	jalr	-290(ra) # 80000560 <panic>

000000008000368a <bpin>:

void
bpin(struct buf *b) {
    8000368a:	1101                	addi	sp,sp,-32
    8000368c:	ec06                	sd	ra,24(sp)
    8000368e:	e822                	sd	s0,16(sp)
    80003690:	e426                	sd	s1,8(sp)
    80003692:	1000                	addi	s0,sp,32
    80003694:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003696:	00013517          	auipc	a0,0x13
    8000369a:	63250513          	addi	a0,a0,1586 # 80016cc8 <bcache>
    8000369e:	ffffd097          	auipc	ra,0xffffd
    800036a2:	5a0080e7          	jalr	1440(ra) # 80000c3e <acquire>
  b->refcnt++;
    800036a6:	40bc                	lw	a5,64(s1)
    800036a8:	2785                	addiw	a5,a5,1
    800036aa:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800036ac:	00013517          	auipc	a0,0x13
    800036b0:	61c50513          	addi	a0,a0,1564 # 80016cc8 <bcache>
    800036b4:	ffffd097          	auipc	ra,0xffffd
    800036b8:	63a080e7          	jalr	1594(ra) # 80000cee <release>
}
    800036bc:	60e2                	ld	ra,24(sp)
    800036be:	6442                	ld	s0,16(sp)
    800036c0:	64a2                	ld	s1,8(sp)
    800036c2:	6105                	addi	sp,sp,32
    800036c4:	8082                	ret

00000000800036c6 <bunpin>:

void
bunpin(struct buf *b) {
    800036c6:	1101                	addi	sp,sp,-32
    800036c8:	ec06                	sd	ra,24(sp)
    800036ca:	e822                	sd	s0,16(sp)
    800036cc:	e426                	sd	s1,8(sp)
    800036ce:	1000                	addi	s0,sp,32
    800036d0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800036d2:	00013517          	auipc	a0,0x13
    800036d6:	5f650513          	addi	a0,a0,1526 # 80016cc8 <bcache>
    800036da:	ffffd097          	auipc	ra,0xffffd
    800036de:	564080e7          	jalr	1380(ra) # 80000c3e <acquire>
  b->refcnt--;
    800036e2:	40bc                	lw	a5,64(s1)
    800036e4:	37fd                	addiw	a5,a5,-1
    800036e6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800036e8:	00013517          	auipc	a0,0x13
    800036ec:	5e050513          	addi	a0,a0,1504 # 80016cc8 <bcache>
    800036f0:	ffffd097          	auipc	ra,0xffffd
    800036f4:	5fe080e7          	jalr	1534(ra) # 80000cee <release>
}
    800036f8:	60e2                	ld	ra,24(sp)
    800036fa:	6442                	ld	s0,16(sp)
    800036fc:	64a2                	ld	s1,8(sp)
    800036fe:	6105                	addi	sp,sp,32
    80003700:	8082                	ret

0000000080003702 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003702:	1101                	addi	sp,sp,-32
    80003704:	ec06                	sd	ra,24(sp)
    80003706:	e822                	sd	s0,16(sp)
    80003708:	e426                	sd	s1,8(sp)
    8000370a:	e04a                	sd	s2,0(sp)
    8000370c:	1000                	addi	s0,sp,32
    8000370e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003710:	00d5d79b          	srliw	a5,a1,0xd
    80003714:	0001c597          	auipc	a1,0x1c
    80003718:	c905a583          	lw	a1,-880(a1) # 8001f3a4 <sb+0x1c>
    8000371c:	9dbd                	addw	a1,a1,a5
    8000371e:	00000097          	auipc	ra,0x0
    80003722:	da4080e7          	jalr	-604(ra) # 800034c2 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003726:	0074f713          	andi	a4,s1,7
    8000372a:	4785                	li	a5,1
    8000372c:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80003730:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80003732:	90d9                	srli	s1,s1,0x36
    80003734:	00950733          	add	a4,a0,s1
    80003738:	05874703          	lbu	a4,88(a4)
    8000373c:	00e7f6b3          	and	a3,a5,a4
    80003740:	c69d                	beqz	a3,8000376e <bfree+0x6c>
    80003742:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003744:	94aa                	add	s1,s1,a0
    80003746:	fff7c793          	not	a5,a5
    8000374a:	8f7d                	and	a4,a4,a5
    8000374c:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003750:	00001097          	auipc	ra,0x1
    80003754:	148080e7          	jalr	328(ra) # 80004898 <log_write>
  brelse(bp);
    80003758:	854a                	mv	a0,s2
    8000375a:	00000097          	auipc	ra,0x0
    8000375e:	e98080e7          	jalr	-360(ra) # 800035f2 <brelse>
}
    80003762:	60e2                	ld	ra,24(sp)
    80003764:	6442                	ld	s0,16(sp)
    80003766:	64a2                	ld	s1,8(sp)
    80003768:	6902                	ld	s2,0(sp)
    8000376a:	6105                	addi	sp,sp,32
    8000376c:	8082                	ret
    panic("freeing free block");
    8000376e:	00005517          	auipc	a0,0x5
    80003772:	d9a50513          	addi	a0,a0,-614 # 80008508 <etext+0x508>
    80003776:	ffffd097          	auipc	ra,0xffffd
    8000377a:	dea080e7          	jalr	-534(ra) # 80000560 <panic>

000000008000377e <balloc>:
{
    8000377e:	715d                	addi	sp,sp,-80
    80003780:	e486                	sd	ra,72(sp)
    80003782:	e0a2                	sd	s0,64(sp)
    80003784:	fc26                	sd	s1,56(sp)
    80003786:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    80003788:	0001c797          	auipc	a5,0x1c
    8000378c:	c047a783          	lw	a5,-1020(a5) # 8001f38c <sb+0x4>
    80003790:	10078863          	beqz	a5,800038a0 <balloc+0x122>
    80003794:	f84a                	sd	s2,48(sp)
    80003796:	f44e                	sd	s3,40(sp)
    80003798:	f052                	sd	s4,32(sp)
    8000379a:	ec56                	sd	s5,24(sp)
    8000379c:	e85a                	sd	s6,16(sp)
    8000379e:	e45e                	sd	s7,8(sp)
    800037a0:	e062                	sd	s8,0(sp)
    800037a2:	8baa                	mv	s7,a0
    800037a4:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800037a6:	0001cb17          	auipc	s6,0x1c
    800037aa:	be2b0b13          	addi	s6,s6,-1054 # 8001f388 <sb>
      m = 1 << (bi % 8);
    800037ae:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800037b0:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800037b2:	6c09                	lui	s8,0x2
    800037b4:	a049                	j	80003836 <balloc+0xb8>
        bp->data[bi/8] |= m;  // Mark block in use.
    800037b6:	97ca                	add	a5,a5,s2
    800037b8:	8e55                	or	a2,a2,a3
    800037ba:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800037be:	854a                	mv	a0,s2
    800037c0:	00001097          	auipc	ra,0x1
    800037c4:	0d8080e7          	jalr	216(ra) # 80004898 <log_write>
        brelse(bp);
    800037c8:	854a                	mv	a0,s2
    800037ca:	00000097          	auipc	ra,0x0
    800037ce:	e28080e7          	jalr	-472(ra) # 800035f2 <brelse>
  bp = bread(dev, bno);
    800037d2:	85a6                	mv	a1,s1
    800037d4:	855e                	mv	a0,s7
    800037d6:	00000097          	auipc	ra,0x0
    800037da:	cec080e7          	jalr	-788(ra) # 800034c2 <bread>
    800037de:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800037e0:	40000613          	li	a2,1024
    800037e4:	4581                	li	a1,0
    800037e6:	05850513          	addi	a0,a0,88
    800037ea:	ffffd097          	auipc	ra,0xffffd
    800037ee:	54c080e7          	jalr	1356(ra) # 80000d36 <memset>
  log_write(bp);
    800037f2:	854a                	mv	a0,s2
    800037f4:	00001097          	auipc	ra,0x1
    800037f8:	0a4080e7          	jalr	164(ra) # 80004898 <log_write>
  brelse(bp);
    800037fc:	854a                	mv	a0,s2
    800037fe:	00000097          	auipc	ra,0x0
    80003802:	df4080e7          	jalr	-524(ra) # 800035f2 <brelse>
}
    80003806:	7942                	ld	s2,48(sp)
    80003808:	79a2                	ld	s3,40(sp)
    8000380a:	7a02                	ld	s4,32(sp)
    8000380c:	6ae2                	ld	s5,24(sp)
    8000380e:	6b42                	ld	s6,16(sp)
    80003810:	6ba2                	ld	s7,8(sp)
    80003812:	6c02                	ld	s8,0(sp)
}
    80003814:	8526                	mv	a0,s1
    80003816:	60a6                	ld	ra,72(sp)
    80003818:	6406                	ld	s0,64(sp)
    8000381a:	74e2                	ld	s1,56(sp)
    8000381c:	6161                	addi	sp,sp,80
    8000381e:	8082                	ret
    brelse(bp);
    80003820:	854a                	mv	a0,s2
    80003822:	00000097          	auipc	ra,0x0
    80003826:	dd0080e7          	jalr	-560(ra) # 800035f2 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000382a:	015c0abb          	addw	s5,s8,s5
    8000382e:	004b2783          	lw	a5,4(s6)
    80003832:	06faf063          	bgeu	s5,a5,80003892 <balloc+0x114>
    bp = bread(dev, BBLOCK(b, sb));
    80003836:	41fad79b          	sraiw	a5,s5,0x1f
    8000383a:	0137d79b          	srliw	a5,a5,0x13
    8000383e:	015787bb          	addw	a5,a5,s5
    80003842:	40d7d79b          	sraiw	a5,a5,0xd
    80003846:	01cb2583          	lw	a1,28(s6)
    8000384a:	9dbd                	addw	a1,a1,a5
    8000384c:	855e                	mv	a0,s7
    8000384e:	00000097          	auipc	ra,0x0
    80003852:	c74080e7          	jalr	-908(ra) # 800034c2 <bread>
    80003856:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003858:	004b2503          	lw	a0,4(s6)
    8000385c:	84d6                	mv	s1,s5
    8000385e:	4701                	li	a4,0
    80003860:	fca4f0e3          	bgeu	s1,a0,80003820 <balloc+0xa2>
      m = 1 << (bi % 8);
    80003864:	00777693          	andi	a3,a4,7
    80003868:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000386c:	41f7579b          	sraiw	a5,a4,0x1f
    80003870:	01d7d79b          	srliw	a5,a5,0x1d
    80003874:	9fb9                	addw	a5,a5,a4
    80003876:	4037d79b          	sraiw	a5,a5,0x3
    8000387a:	00f90633          	add	a2,s2,a5
    8000387e:	05864603          	lbu	a2,88(a2)
    80003882:	00c6f5b3          	and	a1,a3,a2
    80003886:	d985                	beqz	a1,800037b6 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003888:	2705                	addiw	a4,a4,1
    8000388a:	2485                	addiw	s1,s1,1
    8000388c:	fd471ae3          	bne	a4,s4,80003860 <balloc+0xe2>
    80003890:	bf41                	j	80003820 <balloc+0xa2>
    80003892:	7942                	ld	s2,48(sp)
    80003894:	79a2                	ld	s3,40(sp)
    80003896:	7a02                	ld	s4,32(sp)
    80003898:	6ae2                	ld	s5,24(sp)
    8000389a:	6b42                	ld	s6,16(sp)
    8000389c:	6ba2                	ld	s7,8(sp)
    8000389e:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    800038a0:	00005517          	auipc	a0,0x5
    800038a4:	c8050513          	addi	a0,a0,-896 # 80008520 <etext+0x520>
    800038a8:	ffffd097          	auipc	ra,0xffffd
    800038ac:	d02080e7          	jalr	-766(ra) # 800005aa <printf>
  return 0;
    800038b0:	4481                	li	s1,0
    800038b2:	b78d                	j	80003814 <balloc+0x96>

00000000800038b4 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800038b4:	7179                	addi	sp,sp,-48
    800038b6:	f406                	sd	ra,40(sp)
    800038b8:	f022                	sd	s0,32(sp)
    800038ba:	ec26                	sd	s1,24(sp)
    800038bc:	e84a                	sd	s2,16(sp)
    800038be:	e44e                	sd	s3,8(sp)
    800038c0:	1800                	addi	s0,sp,48
    800038c2:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800038c4:	47ad                	li	a5,11
    800038c6:	02b7e563          	bltu	a5,a1,800038f0 <bmap+0x3c>
    if((addr = ip->addrs[bn]) == 0){
    800038ca:	02059793          	slli	a5,a1,0x20
    800038ce:	01e7d593          	srli	a1,a5,0x1e
    800038d2:	00b504b3          	add	s1,a0,a1
    800038d6:	0504a903          	lw	s2,80(s1)
    800038da:	06091b63          	bnez	s2,80003950 <bmap+0x9c>
      addr = balloc(ip->dev);
    800038de:	4108                	lw	a0,0(a0)
    800038e0:	00000097          	auipc	ra,0x0
    800038e4:	e9e080e7          	jalr	-354(ra) # 8000377e <balloc>
    800038e8:	892a                	mv	s2,a0
      if(addr == 0)
    800038ea:	c13d                	beqz	a0,80003950 <bmap+0x9c>
        return 0;
      ip->addrs[bn] = addr;
    800038ec:	c8a8                	sw	a0,80(s1)
    800038ee:	a08d                	j	80003950 <bmap+0x9c>
    }
    return addr;
  }
  bn -= NDIRECT;
    800038f0:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    800038f4:	0ff00793          	li	a5,255
    800038f8:	0897e363          	bltu	a5,s1,8000397e <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800038fc:	08052903          	lw	s2,128(a0)
    80003900:	00091d63          	bnez	s2,8000391a <bmap+0x66>
      addr = balloc(ip->dev);
    80003904:	4108                	lw	a0,0(a0)
    80003906:	00000097          	auipc	ra,0x0
    8000390a:	e78080e7          	jalr	-392(ra) # 8000377e <balloc>
    8000390e:	892a                	mv	s2,a0
      if(addr == 0)
    80003910:	c121                	beqz	a0,80003950 <bmap+0x9c>
    80003912:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003914:	08a9a023          	sw	a0,128(s3)
    80003918:	a011                	j	8000391c <bmap+0x68>
    8000391a:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    8000391c:	85ca                	mv	a1,s2
    8000391e:	0009a503          	lw	a0,0(s3)
    80003922:	00000097          	auipc	ra,0x0
    80003926:	ba0080e7          	jalr	-1120(ra) # 800034c2 <bread>
    8000392a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000392c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003930:	02049713          	slli	a4,s1,0x20
    80003934:	01e75593          	srli	a1,a4,0x1e
    80003938:	00b784b3          	add	s1,a5,a1
    8000393c:	0004a903          	lw	s2,0(s1)
    80003940:	02090063          	beqz	s2,80003960 <bmap+0xac>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003944:	8552                	mv	a0,s4
    80003946:	00000097          	auipc	ra,0x0
    8000394a:	cac080e7          	jalr	-852(ra) # 800035f2 <brelse>
    return addr;
    8000394e:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003950:	854a                	mv	a0,s2
    80003952:	70a2                	ld	ra,40(sp)
    80003954:	7402                	ld	s0,32(sp)
    80003956:	64e2                	ld	s1,24(sp)
    80003958:	6942                	ld	s2,16(sp)
    8000395a:	69a2                	ld	s3,8(sp)
    8000395c:	6145                	addi	sp,sp,48
    8000395e:	8082                	ret
      addr = balloc(ip->dev);
    80003960:	0009a503          	lw	a0,0(s3)
    80003964:	00000097          	auipc	ra,0x0
    80003968:	e1a080e7          	jalr	-486(ra) # 8000377e <balloc>
    8000396c:	892a                	mv	s2,a0
      if(addr){
    8000396e:	d979                	beqz	a0,80003944 <bmap+0x90>
        a[bn] = addr;
    80003970:	c088                	sw	a0,0(s1)
        log_write(bp);
    80003972:	8552                	mv	a0,s4
    80003974:	00001097          	auipc	ra,0x1
    80003978:	f24080e7          	jalr	-220(ra) # 80004898 <log_write>
    8000397c:	b7e1                	j	80003944 <bmap+0x90>
    8000397e:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003980:	00005517          	auipc	a0,0x5
    80003984:	bb850513          	addi	a0,a0,-1096 # 80008538 <etext+0x538>
    80003988:	ffffd097          	auipc	ra,0xffffd
    8000398c:	bd8080e7          	jalr	-1064(ra) # 80000560 <panic>

0000000080003990 <iget>:
{
    80003990:	7179                	addi	sp,sp,-48
    80003992:	f406                	sd	ra,40(sp)
    80003994:	f022                	sd	s0,32(sp)
    80003996:	ec26                	sd	s1,24(sp)
    80003998:	e84a                	sd	s2,16(sp)
    8000399a:	e44e                	sd	s3,8(sp)
    8000399c:	e052                	sd	s4,0(sp)
    8000399e:	1800                	addi	s0,sp,48
    800039a0:	89aa                	mv	s3,a0
    800039a2:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800039a4:	0001c517          	auipc	a0,0x1c
    800039a8:	a0450513          	addi	a0,a0,-1532 # 8001f3a8 <itable>
    800039ac:	ffffd097          	auipc	ra,0xffffd
    800039b0:	292080e7          	jalr	658(ra) # 80000c3e <acquire>
  empty = 0;
    800039b4:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800039b6:	0001c497          	auipc	s1,0x1c
    800039ba:	a0a48493          	addi	s1,s1,-1526 # 8001f3c0 <itable+0x18>
    800039be:	0001d697          	auipc	a3,0x1d
    800039c2:	49268693          	addi	a3,a3,1170 # 80020e50 <log>
    800039c6:	a039                	j	800039d4 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800039c8:	02090b63          	beqz	s2,800039fe <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800039cc:	08848493          	addi	s1,s1,136
    800039d0:	02d48a63          	beq	s1,a3,80003a04 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800039d4:	449c                	lw	a5,8(s1)
    800039d6:	fef059e3          	blez	a5,800039c8 <iget+0x38>
    800039da:	4098                	lw	a4,0(s1)
    800039dc:	ff3716e3          	bne	a4,s3,800039c8 <iget+0x38>
    800039e0:	40d8                	lw	a4,4(s1)
    800039e2:	ff4713e3          	bne	a4,s4,800039c8 <iget+0x38>
      ip->ref++;
    800039e6:	2785                	addiw	a5,a5,1
    800039e8:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800039ea:	0001c517          	auipc	a0,0x1c
    800039ee:	9be50513          	addi	a0,a0,-1602 # 8001f3a8 <itable>
    800039f2:	ffffd097          	auipc	ra,0xffffd
    800039f6:	2fc080e7          	jalr	764(ra) # 80000cee <release>
      return ip;
    800039fa:	8926                	mv	s2,s1
    800039fc:	a03d                	j	80003a2a <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800039fe:	f7f9                	bnez	a5,800039cc <iget+0x3c>
      empty = ip;
    80003a00:	8926                	mv	s2,s1
    80003a02:	b7e9                	j	800039cc <iget+0x3c>
  if(empty == 0)
    80003a04:	02090c63          	beqz	s2,80003a3c <iget+0xac>
  ip->dev = dev;
    80003a08:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003a0c:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003a10:	4785                	li	a5,1
    80003a12:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003a16:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003a1a:	0001c517          	auipc	a0,0x1c
    80003a1e:	98e50513          	addi	a0,a0,-1650 # 8001f3a8 <itable>
    80003a22:	ffffd097          	auipc	ra,0xffffd
    80003a26:	2cc080e7          	jalr	716(ra) # 80000cee <release>
}
    80003a2a:	854a                	mv	a0,s2
    80003a2c:	70a2                	ld	ra,40(sp)
    80003a2e:	7402                	ld	s0,32(sp)
    80003a30:	64e2                	ld	s1,24(sp)
    80003a32:	6942                	ld	s2,16(sp)
    80003a34:	69a2                	ld	s3,8(sp)
    80003a36:	6a02                	ld	s4,0(sp)
    80003a38:	6145                	addi	sp,sp,48
    80003a3a:	8082                	ret
    panic("iget: no inodes");
    80003a3c:	00005517          	auipc	a0,0x5
    80003a40:	b1450513          	addi	a0,a0,-1260 # 80008550 <etext+0x550>
    80003a44:	ffffd097          	auipc	ra,0xffffd
    80003a48:	b1c080e7          	jalr	-1252(ra) # 80000560 <panic>

0000000080003a4c <fsinit>:
fsinit(int dev) {
    80003a4c:	7179                	addi	sp,sp,-48
    80003a4e:	f406                	sd	ra,40(sp)
    80003a50:	f022                	sd	s0,32(sp)
    80003a52:	ec26                	sd	s1,24(sp)
    80003a54:	e84a                	sd	s2,16(sp)
    80003a56:	e44e                	sd	s3,8(sp)
    80003a58:	1800                	addi	s0,sp,48
    80003a5a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003a5c:	4585                	li	a1,1
    80003a5e:	00000097          	auipc	ra,0x0
    80003a62:	a64080e7          	jalr	-1436(ra) # 800034c2 <bread>
    80003a66:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003a68:	0001c997          	auipc	s3,0x1c
    80003a6c:	92098993          	addi	s3,s3,-1760 # 8001f388 <sb>
    80003a70:	02000613          	li	a2,32
    80003a74:	05850593          	addi	a1,a0,88
    80003a78:	854e                	mv	a0,s3
    80003a7a:	ffffd097          	auipc	ra,0xffffd
    80003a7e:	320080e7          	jalr	800(ra) # 80000d9a <memmove>
  brelse(bp);
    80003a82:	8526                	mv	a0,s1
    80003a84:	00000097          	auipc	ra,0x0
    80003a88:	b6e080e7          	jalr	-1170(ra) # 800035f2 <brelse>
  if(sb.magic != FSMAGIC)
    80003a8c:	0009a703          	lw	a4,0(s3)
    80003a90:	102037b7          	lui	a5,0x10203
    80003a94:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003a98:	02f71263          	bne	a4,a5,80003abc <fsinit+0x70>
  initlog(dev, &sb);
    80003a9c:	0001c597          	auipc	a1,0x1c
    80003aa0:	8ec58593          	addi	a1,a1,-1812 # 8001f388 <sb>
    80003aa4:	854a                	mv	a0,s2
    80003aa6:	00001097          	auipc	ra,0x1
    80003aaa:	b7c080e7          	jalr	-1156(ra) # 80004622 <initlog>
}
    80003aae:	70a2                	ld	ra,40(sp)
    80003ab0:	7402                	ld	s0,32(sp)
    80003ab2:	64e2                	ld	s1,24(sp)
    80003ab4:	6942                	ld	s2,16(sp)
    80003ab6:	69a2                	ld	s3,8(sp)
    80003ab8:	6145                	addi	sp,sp,48
    80003aba:	8082                	ret
    panic("invalid file system");
    80003abc:	00005517          	auipc	a0,0x5
    80003ac0:	aa450513          	addi	a0,a0,-1372 # 80008560 <etext+0x560>
    80003ac4:	ffffd097          	auipc	ra,0xffffd
    80003ac8:	a9c080e7          	jalr	-1380(ra) # 80000560 <panic>

0000000080003acc <iinit>:
{
    80003acc:	7179                	addi	sp,sp,-48
    80003ace:	f406                	sd	ra,40(sp)
    80003ad0:	f022                	sd	s0,32(sp)
    80003ad2:	ec26                	sd	s1,24(sp)
    80003ad4:	e84a                	sd	s2,16(sp)
    80003ad6:	e44e                	sd	s3,8(sp)
    80003ad8:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003ada:	00005597          	auipc	a1,0x5
    80003ade:	a9e58593          	addi	a1,a1,-1378 # 80008578 <etext+0x578>
    80003ae2:	0001c517          	auipc	a0,0x1c
    80003ae6:	8c650513          	addi	a0,a0,-1850 # 8001f3a8 <itable>
    80003aea:	ffffd097          	auipc	ra,0xffffd
    80003aee:	0c0080e7          	jalr	192(ra) # 80000baa <initlock>
  for(i = 0; i < NINODE; i++) {
    80003af2:	0001c497          	auipc	s1,0x1c
    80003af6:	8de48493          	addi	s1,s1,-1826 # 8001f3d0 <itable+0x28>
    80003afa:	0001d997          	auipc	s3,0x1d
    80003afe:	36698993          	addi	s3,s3,870 # 80020e60 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003b02:	00005917          	auipc	s2,0x5
    80003b06:	a7e90913          	addi	s2,s2,-1410 # 80008580 <etext+0x580>
    80003b0a:	85ca                	mv	a1,s2
    80003b0c:	8526                	mv	a0,s1
    80003b0e:	00001097          	auipc	ra,0x1
    80003b12:	e6e080e7          	jalr	-402(ra) # 8000497c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003b16:	08848493          	addi	s1,s1,136
    80003b1a:	ff3498e3          	bne	s1,s3,80003b0a <iinit+0x3e>
}
    80003b1e:	70a2                	ld	ra,40(sp)
    80003b20:	7402                	ld	s0,32(sp)
    80003b22:	64e2                	ld	s1,24(sp)
    80003b24:	6942                	ld	s2,16(sp)
    80003b26:	69a2                	ld	s3,8(sp)
    80003b28:	6145                	addi	sp,sp,48
    80003b2a:	8082                	ret

0000000080003b2c <ialloc>:
{
    80003b2c:	7139                	addi	sp,sp,-64
    80003b2e:	fc06                	sd	ra,56(sp)
    80003b30:	f822                	sd	s0,48(sp)
    80003b32:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003b34:	0001c717          	auipc	a4,0x1c
    80003b38:	86072703          	lw	a4,-1952(a4) # 8001f394 <sb+0xc>
    80003b3c:	4785                	li	a5,1
    80003b3e:	06e7f463          	bgeu	a5,a4,80003ba6 <ialloc+0x7a>
    80003b42:	f426                	sd	s1,40(sp)
    80003b44:	f04a                	sd	s2,32(sp)
    80003b46:	ec4e                	sd	s3,24(sp)
    80003b48:	e852                	sd	s4,16(sp)
    80003b4a:	e456                	sd	s5,8(sp)
    80003b4c:	e05a                	sd	s6,0(sp)
    80003b4e:	8aaa                	mv	s5,a0
    80003b50:	8b2e                	mv	s6,a1
    80003b52:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80003b54:	0001ca17          	auipc	s4,0x1c
    80003b58:	834a0a13          	addi	s4,s4,-1996 # 8001f388 <sb>
    80003b5c:	00495593          	srli	a1,s2,0x4
    80003b60:	018a2783          	lw	a5,24(s4)
    80003b64:	9dbd                	addw	a1,a1,a5
    80003b66:	8556                	mv	a0,s5
    80003b68:	00000097          	auipc	ra,0x0
    80003b6c:	95a080e7          	jalr	-1702(ra) # 800034c2 <bread>
    80003b70:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003b72:	05850993          	addi	s3,a0,88
    80003b76:	00f97793          	andi	a5,s2,15
    80003b7a:	079a                	slli	a5,a5,0x6
    80003b7c:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003b7e:	00099783          	lh	a5,0(s3)
    80003b82:	cf9d                	beqz	a5,80003bc0 <ialloc+0x94>
    brelse(bp);
    80003b84:	00000097          	auipc	ra,0x0
    80003b88:	a6e080e7          	jalr	-1426(ra) # 800035f2 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003b8c:	0905                	addi	s2,s2,1
    80003b8e:	00ca2703          	lw	a4,12(s4)
    80003b92:	0009079b          	sext.w	a5,s2
    80003b96:	fce7e3e3          	bltu	a5,a4,80003b5c <ialloc+0x30>
    80003b9a:	74a2                	ld	s1,40(sp)
    80003b9c:	7902                	ld	s2,32(sp)
    80003b9e:	69e2                	ld	s3,24(sp)
    80003ba0:	6a42                	ld	s4,16(sp)
    80003ba2:	6aa2                	ld	s5,8(sp)
    80003ba4:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003ba6:	00005517          	auipc	a0,0x5
    80003baa:	9e250513          	addi	a0,a0,-1566 # 80008588 <etext+0x588>
    80003bae:	ffffd097          	auipc	ra,0xffffd
    80003bb2:	9fc080e7          	jalr	-1540(ra) # 800005aa <printf>
  return 0;
    80003bb6:	4501                	li	a0,0
}
    80003bb8:	70e2                	ld	ra,56(sp)
    80003bba:	7442                	ld	s0,48(sp)
    80003bbc:	6121                	addi	sp,sp,64
    80003bbe:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003bc0:	04000613          	li	a2,64
    80003bc4:	4581                	li	a1,0
    80003bc6:	854e                	mv	a0,s3
    80003bc8:	ffffd097          	auipc	ra,0xffffd
    80003bcc:	16e080e7          	jalr	366(ra) # 80000d36 <memset>
      dip->type = type;
    80003bd0:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003bd4:	8526                	mv	a0,s1
    80003bd6:	00001097          	auipc	ra,0x1
    80003bda:	cc2080e7          	jalr	-830(ra) # 80004898 <log_write>
      brelse(bp);
    80003bde:	8526                	mv	a0,s1
    80003be0:	00000097          	auipc	ra,0x0
    80003be4:	a12080e7          	jalr	-1518(ra) # 800035f2 <brelse>
      return iget(dev, inum);
    80003be8:	0009059b          	sext.w	a1,s2
    80003bec:	8556                	mv	a0,s5
    80003bee:	00000097          	auipc	ra,0x0
    80003bf2:	da2080e7          	jalr	-606(ra) # 80003990 <iget>
    80003bf6:	74a2                	ld	s1,40(sp)
    80003bf8:	7902                	ld	s2,32(sp)
    80003bfa:	69e2                	ld	s3,24(sp)
    80003bfc:	6a42                	ld	s4,16(sp)
    80003bfe:	6aa2                	ld	s5,8(sp)
    80003c00:	6b02                	ld	s6,0(sp)
    80003c02:	bf5d                	j	80003bb8 <ialloc+0x8c>

0000000080003c04 <iupdate>:
{
    80003c04:	1101                	addi	sp,sp,-32
    80003c06:	ec06                	sd	ra,24(sp)
    80003c08:	e822                	sd	s0,16(sp)
    80003c0a:	e426                	sd	s1,8(sp)
    80003c0c:	e04a                	sd	s2,0(sp)
    80003c0e:	1000                	addi	s0,sp,32
    80003c10:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003c12:	415c                	lw	a5,4(a0)
    80003c14:	0047d79b          	srliw	a5,a5,0x4
    80003c18:	0001b597          	auipc	a1,0x1b
    80003c1c:	7885a583          	lw	a1,1928(a1) # 8001f3a0 <sb+0x18>
    80003c20:	9dbd                	addw	a1,a1,a5
    80003c22:	4108                	lw	a0,0(a0)
    80003c24:	00000097          	auipc	ra,0x0
    80003c28:	89e080e7          	jalr	-1890(ra) # 800034c2 <bread>
    80003c2c:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003c2e:	05850793          	addi	a5,a0,88
    80003c32:	40d8                	lw	a4,4(s1)
    80003c34:	8b3d                	andi	a4,a4,15
    80003c36:	071a                	slli	a4,a4,0x6
    80003c38:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003c3a:	04449703          	lh	a4,68(s1)
    80003c3e:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003c42:	04649703          	lh	a4,70(s1)
    80003c46:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003c4a:	04849703          	lh	a4,72(s1)
    80003c4e:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003c52:	04a49703          	lh	a4,74(s1)
    80003c56:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003c5a:	44f8                	lw	a4,76(s1)
    80003c5c:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003c5e:	03400613          	li	a2,52
    80003c62:	05048593          	addi	a1,s1,80
    80003c66:	00c78513          	addi	a0,a5,12
    80003c6a:	ffffd097          	auipc	ra,0xffffd
    80003c6e:	130080e7          	jalr	304(ra) # 80000d9a <memmove>
  log_write(bp);
    80003c72:	854a                	mv	a0,s2
    80003c74:	00001097          	auipc	ra,0x1
    80003c78:	c24080e7          	jalr	-988(ra) # 80004898 <log_write>
  brelse(bp);
    80003c7c:	854a                	mv	a0,s2
    80003c7e:	00000097          	auipc	ra,0x0
    80003c82:	974080e7          	jalr	-1676(ra) # 800035f2 <brelse>
}
    80003c86:	60e2                	ld	ra,24(sp)
    80003c88:	6442                	ld	s0,16(sp)
    80003c8a:	64a2                	ld	s1,8(sp)
    80003c8c:	6902                	ld	s2,0(sp)
    80003c8e:	6105                	addi	sp,sp,32
    80003c90:	8082                	ret

0000000080003c92 <idup>:
{
    80003c92:	1101                	addi	sp,sp,-32
    80003c94:	ec06                	sd	ra,24(sp)
    80003c96:	e822                	sd	s0,16(sp)
    80003c98:	e426                	sd	s1,8(sp)
    80003c9a:	1000                	addi	s0,sp,32
    80003c9c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003c9e:	0001b517          	auipc	a0,0x1b
    80003ca2:	70a50513          	addi	a0,a0,1802 # 8001f3a8 <itable>
    80003ca6:	ffffd097          	auipc	ra,0xffffd
    80003caa:	f98080e7          	jalr	-104(ra) # 80000c3e <acquire>
  ip->ref++;
    80003cae:	449c                	lw	a5,8(s1)
    80003cb0:	2785                	addiw	a5,a5,1
    80003cb2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003cb4:	0001b517          	auipc	a0,0x1b
    80003cb8:	6f450513          	addi	a0,a0,1780 # 8001f3a8 <itable>
    80003cbc:	ffffd097          	auipc	ra,0xffffd
    80003cc0:	032080e7          	jalr	50(ra) # 80000cee <release>
}
    80003cc4:	8526                	mv	a0,s1
    80003cc6:	60e2                	ld	ra,24(sp)
    80003cc8:	6442                	ld	s0,16(sp)
    80003cca:	64a2                	ld	s1,8(sp)
    80003ccc:	6105                	addi	sp,sp,32
    80003cce:	8082                	ret

0000000080003cd0 <ilock>:
{
    80003cd0:	1101                	addi	sp,sp,-32
    80003cd2:	ec06                	sd	ra,24(sp)
    80003cd4:	e822                	sd	s0,16(sp)
    80003cd6:	e426                	sd	s1,8(sp)
    80003cd8:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003cda:	c10d                	beqz	a0,80003cfc <ilock+0x2c>
    80003cdc:	84aa                	mv	s1,a0
    80003cde:	451c                	lw	a5,8(a0)
    80003ce0:	00f05e63          	blez	a5,80003cfc <ilock+0x2c>
  acquiresleep(&ip->lock);
    80003ce4:	0541                	addi	a0,a0,16
    80003ce6:	00001097          	auipc	ra,0x1
    80003cea:	cd0080e7          	jalr	-816(ra) # 800049b6 <acquiresleep>
  if(ip->valid == 0){
    80003cee:	40bc                	lw	a5,64(s1)
    80003cf0:	cf99                	beqz	a5,80003d0e <ilock+0x3e>
}
    80003cf2:	60e2                	ld	ra,24(sp)
    80003cf4:	6442                	ld	s0,16(sp)
    80003cf6:	64a2                	ld	s1,8(sp)
    80003cf8:	6105                	addi	sp,sp,32
    80003cfa:	8082                	ret
    80003cfc:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003cfe:	00005517          	auipc	a0,0x5
    80003d02:	8a250513          	addi	a0,a0,-1886 # 800085a0 <etext+0x5a0>
    80003d06:	ffffd097          	auipc	ra,0xffffd
    80003d0a:	85a080e7          	jalr	-1958(ra) # 80000560 <panic>
    80003d0e:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003d10:	40dc                	lw	a5,4(s1)
    80003d12:	0047d79b          	srliw	a5,a5,0x4
    80003d16:	0001b597          	auipc	a1,0x1b
    80003d1a:	68a5a583          	lw	a1,1674(a1) # 8001f3a0 <sb+0x18>
    80003d1e:	9dbd                	addw	a1,a1,a5
    80003d20:	4088                	lw	a0,0(s1)
    80003d22:	fffff097          	auipc	ra,0xfffff
    80003d26:	7a0080e7          	jalr	1952(ra) # 800034c2 <bread>
    80003d2a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003d2c:	05850593          	addi	a1,a0,88
    80003d30:	40dc                	lw	a5,4(s1)
    80003d32:	8bbd                	andi	a5,a5,15
    80003d34:	079a                	slli	a5,a5,0x6
    80003d36:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003d38:	00059783          	lh	a5,0(a1)
    80003d3c:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003d40:	00259783          	lh	a5,2(a1)
    80003d44:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003d48:	00459783          	lh	a5,4(a1)
    80003d4c:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003d50:	00659783          	lh	a5,6(a1)
    80003d54:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003d58:	459c                	lw	a5,8(a1)
    80003d5a:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003d5c:	03400613          	li	a2,52
    80003d60:	05b1                	addi	a1,a1,12
    80003d62:	05048513          	addi	a0,s1,80
    80003d66:	ffffd097          	auipc	ra,0xffffd
    80003d6a:	034080e7          	jalr	52(ra) # 80000d9a <memmove>
    brelse(bp);
    80003d6e:	854a                	mv	a0,s2
    80003d70:	00000097          	auipc	ra,0x0
    80003d74:	882080e7          	jalr	-1918(ra) # 800035f2 <brelse>
    ip->valid = 1;
    80003d78:	4785                	li	a5,1
    80003d7a:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003d7c:	04449783          	lh	a5,68(s1)
    80003d80:	c399                	beqz	a5,80003d86 <ilock+0xb6>
    80003d82:	6902                	ld	s2,0(sp)
    80003d84:	b7bd                	j	80003cf2 <ilock+0x22>
      panic("ilock: no type");
    80003d86:	00005517          	auipc	a0,0x5
    80003d8a:	82250513          	addi	a0,a0,-2014 # 800085a8 <etext+0x5a8>
    80003d8e:	ffffc097          	auipc	ra,0xffffc
    80003d92:	7d2080e7          	jalr	2002(ra) # 80000560 <panic>

0000000080003d96 <iunlock>:
{
    80003d96:	1101                	addi	sp,sp,-32
    80003d98:	ec06                	sd	ra,24(sp)
    80003d9a:	e822                	sd	s0,16(sp)
    80003d9c:	e426                	sd	s1,8(sp)
    80003d9e:	e04a                	sd	s2,0(sp)
    80003da0:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003da2:	c905                	beqz	a0,80003dd2 <iunlock+0x3c>
    80003da4:	84aa                	mv	s1,a0
    80003da6:	01050913          	addi	s2,a0,16
    80003daa:	854a                	mv	a0,s2
    80003dac:	00001097          	auipc	ra,0x1
    80003db0:	ca4080e7          	jalr	-860(ra) # 80004a50 <holdingsleep>
    80003db4:	cd19                	beqz	a0,80003dd2 <iunlock+0x3c>
    80003db6:	449c                	lw	a5,8(s1)
    80003db8:	00f05d63          	blez	a5,80003dd2 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003dbc:	854a                	mv	a0,s2
    80003dbe:	00001097          	auipc	ra,0x1
    80003dc2:	c4e080e7          	jalr	-946(ra) # 80004a0c <releasesleep>
}
    80003dc6:	60e2                	ld	ra,24(sp)
    80003dc8:	6442                	ld	s0,16(sp)
    80003dca:	64a2                	ld	s1,8(sp)
    80003dcc:	6902                	ld	s2,0(sp)
    80003dce:	6105                	addi	sp,sp,32
    80003dd0:	8082                	ret
    panic("iunlock");
    80003dd2:	00004517          	auipc	a0,0x4
    80003dd6:	7e650513          	addi	a0,a0,2022 # 800085b8 <etext+0x5b8>
    80003dda:	ffffc097          	auipc	ra,0xffffc
    80003dde:	786080e7          	jalr	1926(ra) # 80000560 <panic>

0000000080003de2 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003de2:	7179                	addi	sp,sp,-48
    80003de4:	f406                	sd	ra,40(sp)
    80003de6:	f022                	sd	s0,32(sp)
    80003de8:	ec26                	sd	s1,24(sp)
    80003dea:	e84a                	sd	s2,16(sp)
    80003dec:	e44e                	sd	s3,8(sp)
    80003dee:	1800                	addi	s0,sp,48
    80003df0:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003df2:	05050493          	addi	s1,a0,80
    80003df6:	08050913          	addi	s2,a0,128
    80003dfa:	a021                	j	80003e02 <itrunc+0x20>
    80003dfc:	0491                	addi	s1,s1,4
    80003dfe:	01248d63          	beq	s1,s2,80003e18 <itrunc+0x36>
    if(ip->addrs[i]){
    80003e02:	408c                	lw	a1,0(s1)
    80003e04:	dde5                	beqz	a1,80003dfc <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003e06:	0009a503          	lw	a0,0(s3)
    80003e0a:	00000097          	auipc	ra,0x0
    80003e0e:	8f8080e7          	jalr	-1800(ra) # 80003702 <bfree>
      ip->addrs[i] = 0;
    80003e12:	0004a023          	sw	zero,0(s1)
    80003e16:	b7dd                	j	80003dfc <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003e18:	0809a583          	lw	a1,128(s3)
    80003e1c:	ed99                	bnez	a1,80003e3a <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003e1e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003e22:	854e                	mv	a0,s3
    80003e24:	00000097          	auipc	ra,0x0
    80003e28:	de0080e7          	jalr	-544(ra) # 80003c04 <iupdate>
}
    80003e2c:	70a2                	ld	ra,40(sp)
    80003e2e:	7402                	ld	s0,32(sp)
    80003e30:	64e2                	ld	s1,24(sp)
    80003e32:	6942                	ld	s2,16(sp)
    80003e34:	69a2                	ld	s3,8(sp)
    80003e36:	6145                	addi	sp,sp,48
    80003e38:	8082                	ret
    80003e3a:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003e3c:	0009a503          	lw	a0,0(s3)
    80003e40:	fffff097          	auipc	ra,0xfffff
    80003e44:	682080e7          	jalr	1666(ra) # 800034c2 <bread>
    80003e48:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003e4a:	05850493          	addi	s1,a0,88
    80003e4e:	45850913          	addi	s2,a0,1112
    80003e52:	a021                	j	80003e5a <itrunc+0x78>
    80003e54:	0491                	addi	s1,s1,4
    80003e56:	01248b63          	beq	s1,s2,80003e6c <itrunc+0x8a>
      if(a[j])
    80003e5a:	408c                	lw	a1,0(s1)
    80003e5c:	dde5                	beqz	a1,80003e54 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80003e5e:	0009a503          	lw	a0,0(s3)
    80003e62:	00000097          	auipc	ra,0x0
    80003e66:	8a0080e7          	jalr	-1888(ra) # 80003702 <bfree>
    80003e6a:	b7ed                	j	80003e54 <itrunc+0x72>
    brelse(bp);
    80003e6c:	8552                	mv	a0,s4
    80003e6e:	fffff097          	auipc	ra,0xfffff
    80003e72:	784080e7          	jalr	1924(ra) # 800035f2 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003e76:	0809a583          	lw	a1,128(s3)
    80003e7a:	0009a503          	lw	a0,0(s3)
    80003e7e:	00000097          	auipc	ra,0x0
    80003e82:	884080e7          	jalr	-1916(ra) # 80003702 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003e86:	0809a023          	sw	zero,128(s3)
    80003e8a:	6a02                	ld	s4,0(sp)
    80003e8c:	bf49                	j	80003e1e <itrunc+0x3c>

0000000080003e8e <iput>:
{
    80003e8e:	1101                	addi	sp,sp,-32
    80003e90:	ec06                	sd	ra,24(sp)
    80003e92:	e822                	sd	s0,16(sp)
    80003e94:	e426                	sd	s1,8(sp)
    80003e96:	1000                	addi	s0,sp,32
    80003e98:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003e9a:	0001b517          	auipc	a0,0x1b
    80003e9e:	50e50513          	addi	a0,a0,1294 # 8001f3a8 <itable>
    80003ea2:	ffffd097          	auipc	ra,0xffffd
    80003ea6:	d9c080e7          	jalr	-612(ra) # 80000c3e <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003eaa:	4498                	lw	a4,8(s1)
    80003eac:	4785                	li	a5,1
    80003eae:	02f70263          	beq	a4,a5,80003ed2 <iput+0x44>
  ip->ref--;
    80003eb2:	449c                	lw	a5,8(s1)
    80003eb4:	37fd                	addiw	a5,a5,-1
    80003eb6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003eb8:	0001b517          	auipc	a0,0x1b
    80003ebc:	4f050513          	addi	a0,a0,1264 # 8001f3a8 <itable>
    80003ec0:	ffffd097          	auipc	ra,0xffffd
    80003ec4:	e2e080e7          	jalr	-466(ra) # 80000cee <release>
}
    80003ec8:	60e2                	ld	ra,24(sp)
    80003eca:	6442                	ld	s0,16(sp)
    80003ecc:	64a2                	ld	s1,8(sp)
    80003ece:	6105                	addi	sp,sp,32
    80003ed0:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003ed2:	40bc                	lw	a5,64(s1)
    80003ed4:	dff9                	beqz	a5,80003eb2 <iput+0x24>
    80003ed6:	04a49783          	lh	a5,74(s1)
    80003eda:	ffe1                	bnez	a5,80003eb2 <iput+0x24>
    80003edc:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003ede:	01048913          	addi	s2,s1,16
    80003ee2:	854a                	mv	a0,s2
    80003ee4:	00001097          	auipc	ra,0x1
    80003ee8:	ad2080e7          	jalr	-1326(ra) # 800049b6 <acquiresleep>
    release(&itable.lock);
    80003eec:	0001b517          	auipc	a0,0x1b
    80003ef0:	4bc50513          	addi	a0,a0,1212 # 8001f3a8 <itable>
    80003ef4:	ffffd097          	auipc	ra,0xffffd
    80003ef8:	dfa080e7          	jalr	-518(ra) # 80000cee <release>
    itrunc(ip);
    80003efc:	8526                	mv	a0,s1
    80003efe:	00000097          	auipc	ra,0x0
    80003f02:	ee4080e7          	jalr	-284(ra) # 80003de2 <itrunc>
    ip->type = 0;
    80003f06:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003f0a:	8526                	mv	a0,s1
    80003f0c:	00000097          	auipc	ra,0x0
    80003f10:	cf8080e7          	jalr	-776(ra) # 80003c04 <iupdate>
    ip->valid = 0;
    80003f14:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003f18:	854a                	mv	a0,s2
    80003f1a:	00001097          	auipc	ra,0x1
    80003f1e:	af2080e7          	jalr	-1294(ra) # 80004a0c <releasesleep>
    acquire(&itable.lock);
    80003f22:	0001b517          	auipc	a0,0x1b
    80003f26:	48650513          	addi	a0,a0,1158 # 8001f3a8 <itable>
    80003f2a:	ffffd097          	auipc	ra,0xffffd
    80003f2e:	d14080e7          	jalr	-748(ra) # 80000c3e <acquire>
    80003f32:	6902                	ld	s2,0(sp)
    80003f34:	bfbd                	j	80003eb2 <iput+0x24>

0000000080003f36 <iunlockput>:
{
    80003f36:	1101                	addi	sp,sp,-32
    80003f38:	ec06                	sd	ra,24(sp)
    80003f3a:	e822                	sd	s0,16(sp)
    80003f3c:	e426                	sd	s1,8(sp)
    80003f3e:	1000                	addi	s0,sp,32
    80003f40:	84aa                	mv	s1,a0
  iunlock(ip);
    80003f42:	00000097          	auipc	ra,0x0
    80003f46:	e54080e7          	jalr	-428(ra) # 80003d96 <iunlock>
  iput(ip);
    80003f4a:	8526                	mv	a0,s1
    80003f4c:	00000097          	auipc	ra,0x0
    80003f50:	f42080e7          	jalr	-190(ra) # 80003e8e <iput>
}
    80003f54:	60e2                	ld	ra,24(sp)
    80003f56:	6442                	ld	s0,16(sp)
    80003f58:	64a2                	ld	s1,8(sp)
    80003f5a:	6105                	addi	sp,sp,32
    80003f5c:	8082                	ret

0000000080003f5e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003f5e:	1141                	addi	sp,sp,-16
    80003f60:	e406                	sd	ra,8(sp)
    80003f62:	e022                	sd	s0,0(sp)
    80003f64:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003f66:	411c                	lw	a5,0(a0)
    80003f68:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003f6a:	415c                	lw	a5,4(a0)
    80003f6c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003f6e:	04451783          	lh	a5,68(a0)
    80003f72:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003f76:	04a51783          	lh	a5,74(a0)
    80003f7a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003f7e:	04c56783          	lwu	a5,76(a0)
    80003f82:	e99c                	sd	a5,16(a1)
}
    80003f84:	60a2                	ld	ra,8(sp)
    80003f86:	6402                	ld	s0,0(sp)
    80003f88:	0141                	addi	sp,sp,16
    80003f8a:	8082                	ret

0000000080003f8c <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003f8c:	457c                	lw	a5,76(a0)
    80003f8e:	10d7e063          	bltu	a5,a3,8000408e <readi+0x102>
{
    80003f92:	7159                	addi	sp,sp,-112
    80003f94:	f486                	sd	ra,104(sp)
    80003f96:	f0a2                	sd	s0,96(sp)
    80003f98:	eca6                	sd	s1,88(sp)
    80003f9a:	e0d2                	sd	s4,64(sp)
    80003f9c:	fc56                	sd	s5,56(sp)
    80003f9e:	f85a                	sd	s6,48(sp)
    80003fa0:	f45e                	sd	s7,40(sp)
    80003fa2:	1880                	addi	s0,sp,112
    80003fa4:	8b2a                	mv	s6,a0
    80003fa6:	8bae                	mv	s7,a1
    80003fa8:	8a32                	mv	s4,a2
    80003faa:	84b6                	mv	s1,a3
    80003fac:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003fae:	9f35                	addw	a4,a4,a3
    return 0;
    80003fb0:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003fb2:	0cd76563          	bltu	a4,a3,8000407c <readi+0xf0>
    80003fb6:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003fb8:	00e7f463          	bgeu	a5,a4,80003fc0 <readi+0x34>
    n = ip->size - off;
    80003fbc:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003fc0:	0a0a8563          	beqz	s5,8000406a <readi+0xde>
    80003fc4:	e8ca                	sd	s2,80(sp)
    80003fc6:	f062                	sd	s8,32(sp)
    80003fc8:	ec66                	sd	s9,24(sp)
    80003fca:	e86a                	sd	s10,16(sp)
    80003fcc:	e46e                	sd	s11,8(sp)
    80003fce:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003fd0:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003fd4:	5c7d                	li	s8,-1
    80003fd6:	a82d                	j	80004010 <readi+0x84>
    80003fd8:	020d1d93          	slli	s11,s10,0x20
    80003fdc:	020ddd93          	srli	s11,s11,0x20
    80003fe0:	05890613          	addi	a2,s2,88
    80003fe4:	86ee                	mv	a3,s11
    80003fe6:	963e                	add	a2,a2,a5
    80003fe8:	85d2                	mv	a1,s4
    80003fea:	855e                	mv	a0,s7
    80003fec:	fffff097          	auipc	ra,0xfffff
    80003ff0:	8fe080e7          	jalr	-1794(ra) # 800028ea <either_copyout>
    80003ff4:	05850963          	beq	a0,s8,80004046 <readi+0xba>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003ff8:	854a                	mv	a0,s2
    80003ffa:	fffff097          	auipc	ra,0xfffff
    80003ffe:	5f8080e7          	jalr	1528(ra) # 800035f2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004002:	013d09bb          	addw	s3,s10,s3
    80004006:	009d04bb          	addw	s1,s10,s1
    8000400a:	9a6e                	add	s4,s4,s11
    8000400c:	0559f963          	bgeu	s3,s5,8000405e <readi+0xd2>
    uint addr = bmap(ip, off/BSIZE);
    80004010:	00a4d59b          	srliw	a1,s1,0xa
    80004014:	855a                	mv	a0,s6
    80004016:	00000097          	auipc	ra,0x0
    8000401a:	89e080e7          	jalr	-1890(ra) # 800038b4 <bmap>
    8000401e:	85aa                	mv	a1,a0
    if(addr == 0)
    80004020:	c539                	beqz	a0,8000406e <readi+0xe2>
    bp = bread(ip->dev, addr);
    80004022:	000b2503          	lw	a0,0(s6)
    80004026:	fffff097          	auipc	ra,0xfffff
    8000402a:	49c080e7          	jalr	1180(ra) # 800034c2 <bread>
    8000402e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004030:	3ff4f793          	andi	a5,s1,1023
    80004034:	40fc873b          	subw	a4,s9,a5
    80004038:	413a86bb          	subw	a3,s5,s3
    8000403c:	8d3a                	mv	s10,a4
    8000403e:	f8e6fde3          	bgeu	a3,a4,80003fd8 <readi+0x4c>
    80004042:	8d36                	mv	s10,a3
    80004044:	bf51                	j	80003fd8 <readi+0x4c>
      brelse(bp);
    80004046:	854a                	mv	a0,s2
    80004048:	fffff097          	auipc	ra,0xfffff
    8000404c:	5aa080e7          	jalr	1450(ra) # 800035f2 <brelse>
      tot = -1;
    80004050:	59fd                	li	s3,-1
      break;
    80004052:	6946                	ld	s2,80(sp)
    80004054:	7c02                	ld	s8,32(sp)
    80004056:	6ce2                	ld	s9,24(sp)
    80004058:	6d42                	ld	s10,16(sp)
    8000405a:	6da2                	ld	s11,8(sp)
    8000405c:	a831                	j	80004078 <readi+0xec>
    8000405e:	6946                	ld	s2,80(sp)
    80004060:	7c02                	ld	s8,32(sp)
    80004062:	6ce2                	ld	s9,24(sp)
    80004064:	6d42                	ld	s10,16(sp)
    80004066:	6da2                	ld	s11,8(sp)
    80004068:	a801                	j	80004078 <readi+0xec>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000406a:	89d6                	mv	s3,s5
    8000406c:	a031                	j	80004078 <readi+0xec>
    8000406e:	6946                	ld	s2,80(sp)
    80004070:	7c02                	ld	s8,32(sp)
    80004072:	6ce2                	ld	s9,24(sp)
    80004074:	6d42                	ld	s10,16(sp)
    80004076:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80004078:	854e                	mv	a0,s3
    8000407a:	69a6                	ld	s3,72(sp)
}
    8000407c:	70a6                	ld	ra,104(sp)
    8000407e:	7406                	ld	s0,96(sp)
    80004080:	64e6                	ld	s1,88(sp)
    80004082:	6a06                	ld	s4,64(sp)
    80004084:	7ae2                	ld	s5,56(sp)
    80004086:	7b42                	ld	s6,48(sp)
    80004088:	7ba2                	ld	s7,40(sp)
    8000408a:	6165                	addi	sp,sp,112
    8000408c:	8082                	ret
    return 0;
    8000408e:	4501                	li	a0,0
}
    80004090:	8082                	ret

0000000080004092 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004092:	457c                	lw	a5,76(a0)
    80004094:	10d7e963          	bltu	a5,a3,800041a6 <writei+0x114>
{
    80004098:	7159                	addi	sp,sp,-112
    8000409a:	f486                	sd	ra,104(sp)
    8000409c:	f0a2                	sd	s0,96(sp)
    8000409e:	e8ca                	sd	s2,80(sp)
    800040a0:	e0d2                	sd	s4,64(sp)
    800040a2:	fc56                	sd	s5,56(sp)
    800040a4:	f85a                	sd	s6,48(sp)
    800040a6:	f45e                	sd	s7,40(sp)
    800040a8:	1880                	addi	s0,sp,112
    800040aa:	8aaa                	mv	s5,a0
    800040ac:	8bae                	mv	s7,a1
    800040ae:	8a32                	mv	s4,a2
    800040b0:	8936                	mv	s2,a3
    800040b2:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800040b4:	00e687bb          	addw	a5,a3,a4
    800040b8:	0ed7e963          	bltu	a5,a3,800041aa <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800040bc:	00043737          	lui	a4,0x43
    800040c0:	0ef76763          	bltu	a4,a5,800041ae <writei+0x11c>
    800040c4:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800040c6:	0c0b0863          	beqz	s6,80004196 <writei+0x104>
    800040ca:	eca6                	sd	s1,88(sp)
    800040cc:	f062                	sd	s8,32(sp)
    800040ce:	ec66                	sd	s9,24(sp)
    800040d0:	e86a                	sd	s10,16(sp)
    800040d2:	e46e                	sd	s11,8(sp)
    800040d4:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800040d6:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800040da:	5c7d                	li	s8,-1
    800040dc:	a091                	j	80004120 <writei+0x8e>
    800040de:	020d1d93          	slli	s11,s10,0x20
    800040e2:	020ddd93          	srli	s11,s11,0x20
    800040e6:	05848513          	addi	a0,s1,88
    800040ea:	86ee                	mv	a3,s11
    800040ec:	8652                	mv	a2,s4
    800040ee:	85de                	mv	a1,s7
    800040f0:	953e                	add	a0,a0,a5
    800040f2:	fffff097          	auipc	ra,0xfffff
    800040f6:	84e080e7          	jalr	-1970(ra) # 80002940 <either_copyin>
    800040fa:	05850e63          	beq	a0,s8,80004156 <writei+0xc4>
      brelse(bp);
      break;
    }
    log_write(bp);
    800040fe:	8526                	mv	a0,s1
    80004100:	00000097          	auipc	ra,0x0
    80004104:	798080e7          	jalr	1944(ra) # 80004898 <log_write>
    brelse(bp);
    80004108:	8526                	mv	a0,s1
    8000410a:	fffff097          	auipc	ra,0xfffff
    8000410e:	4e8080e7          	jalr	1256(ra) # 800035f2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004112:	013d09bb          	addw	s3,s10,s3
    80004116:	012d093b          	addw	s2,s10,s2
    8000411a:	9a6e                	add	s4,s4,s11
    8000411c:	0569f263          	bgeu	s3,s6,80004160 <writei+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80004120:	00a9559b          	srliw	a1,s2,0xa
    80004124:	8556                	mv	a0,s5
    80004126:	fffff097          	auipc	ra,0xfffff
    8000412a:	78e080e7          	jalr	1934(ra) # 800038b4 <bmap>
    8000412e:	85aa                	mv	a1,a0
    if(addr == 0)
    80004130:	c905                	beqz	a0,80004160 <writei+0xce>
    bp = bread(ip->dev, addr);
    80004132:	000aa503          	lw	a0,0(s5)
    80004136:	fffff097          	auipc	ra,0xfffff
    8000413a:	38c080e7          	jalr	908(ra) # 800034c2 <bread>
    8000413e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004140:	3ff97793          	andi	a5,s2,1023
    80004144:	40fc873b          	subw	a4,s9,a5
    80004148:	413b06bb          	subw	a3,s6,s3
    8000414c:	8d3a                	mv	s10,a4
    8000414e:	f8e6f8e3          	bgeu	a3,a4,800040de <writei+0x4c>
    80004152:	8d36                	mv	s10,a3
    80004154:	b769                	j	800040de <writei+0x4c>
      brelse(bp);
    80004156:	8526                	mv	a0,s1
    80004158:	fffff097          	auipc	ra,0xfffff
    8000415c:	49a080e7          	jalr	1178(ra) # 800035f2 <brelse>
  }

  if(off > ip->size)
    80004160:	04caa783          	lw	a5,76(s5)
    80004164:	0327fb63          	bgeu	a5,s2,8000419a <writei+0x108>
    ip->size = off;
    80004168:	052aa623          	sw	s2,76(s5)
    8000416c:	64e6                	ld	s1,88(sp)
    8000416e:	7c02                	ld	s8,32(sp)
    80004170:	6ce2                	ld	s9,24(sp)
    80004172:	6d42                	ld	s10,16(sp)
    80004174:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80004176:	8556                	mv	a0,s5
    80004178:	00000097          	auipc	ra,0x0
    8000417c:	a8c080e7          	jalr	-1396(ra) # 80003c04 <iupdate>

  return tot;
    80004180:	854e                	mv	a0,s3
    80004182:	69a6                	ld	s3,72(sp)
}
    80004184:	70a6                	ld	ra,104(sp)
    80004186:	7406                	ld	s0,96(sp)
    80004188:	6946                	ld	s2,80(sp)
    8000418a:	6a06                	ld	s4,64(sp)
    8000418c:	7ae2                	ld	s5,56(sp)
    8000418e:	7b42                	ld	s6,48(sp)
    80004190:	7ba2                	ld	s7,40(sp)
    80004192:	6165                	addi	sp,sp,112
    80004194:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004196:	89da                	mv	s3,s6
    80004198:	bff9                	j	80004176 <writei+0xe4>
    8000419a:	64e6                	ld	s1,88(sp)
    8000419c:	7c02                	ld	s8,32(sp)
    8000419e:	6ce2                	ld	s9,24(sp)
    800041a0:	6d42                	ld	s10,16(sp)
    800041a2:	6da2                	ld	s11,8(sp)
    800041a4:	bfc9                	j	80004176 <writei+0xe4>
    return -1;
    800041a6:	557d                	li	a0,-1
}
    800041a8:	8082                	ret
    return -1;
    800041aa:	557d                	li	a0,-1
    800041ac:	bfe1                	j	80004184 <writei+0xf2>
    return -1;
    800041ae:	557d                	li	a0,-1
    800041b0:	bfd1                	j	80004184 <writei+0xf2>

00000000800041b2 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800041b2:	1141                	addi	sp,sp,-16
    800041b4:	e406                	sd	ra,8(sp)
    800041b6:	e022                	sd	s0,0(sp)
    800041b8:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800041ba:	4639                	li	a2,14
    800041bc:	ffffd097          	auipc	ra,0xffffd
    800041c0:	c56080e7          	jalr	-938(ra) # 80000e12 <strncmp>
}
    800041c4:	60a2                	ld	ra,8(sp)
    800041c6:	6402                	ld	s0,0(sp)
    800041c8:	0141                	addi	sp,sp,16
    800041ca:	8082                	ret

00000000800041cc <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800041cc:	711d                	addi	sp,sp,-96
    800041ce:	ec86                	sd	ra,88(sp)
    800041d0:	e8a2                	sd	s0,80(sp)
    800041d2:	e4a6                	sd	s1,72(sp)
    800041d4:	e0ca                	sd	s2,64(sp)
    800041d6:	fc4e                	sd	s3,56(sp)
    800041d8:	f852                	sd	s4,48(sp)
    800041da:	f456                	sd	s5,40(sp)
    800041dc:	f05a                	sd	s6,32(sp)
    800041de:	ec5e                	sd	s7,24(sp)
    800041e0:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800041e2:	04451703          	lh	a4,68(a0)
    800041e6:	4785                	li	a5,1
    800041e8:	00f71f63          	bne	a4,a5,80004206 <dirlookup+0x3a>
    800041ec:	892a                	mv	s2,a0
    800041ee:	8aae                	mv	s5,a1
    800041f0:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800041f2:	457c                	lw	a5,76(a0)
    800041f4:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800041f6:	fa040a13          	addi	s4,s0,-96
    800041fa:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    800041fc:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80004200:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004202:	e79d                	bnez	a5,80004230 <dirlookup+0x64>
    80004204:	a88d                	j	80004276 <dirlookup+0xaa>
    panic("dirlookup not DIR");
    80004206:	00004517          	auipc	a0,0x4
    8000420a:	3ba50513          	addi	a0,a0,954 # 800085c0 <etext+0x5c0>
    8000420e:	ffffc097          	auipc	ra,0xffffc
    80004212:	352080e7          	jalr	850(ra) # 80000560 <panic>
      panic("dirlookup read");
    80004216:	00004517          	auipc	a0,0x4
    8000421a:	3c250513          	addi	a0,a0,962 # 800085d8 <etext+0x5d8>
    8000421e:	ffffc097          	auipc	ra,0xffffc
    80004222:	342080e7          	jalr	834(ra) # 80000560 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004226:	24c1                	addiw	s1,s1,16
    80004228:	04c92783          	lw	a5,76(s2)
    8000422c:	04f4f463          	bgeu	s1,a5,80004274 <dirlookup+0xa8>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004230:	874e                	mv	a4,s3
    80004232:	86a6                	mv	a3,s1
    80004234:	8652                	mv	a2,s4
    80004236:	4581                	li	a1,0
    80004238:	854a                	mv	a0,s2
    8000423a:	00000097          	auipc	ra,0x0
    8000423e:	d52080e7          	jalr	-686(ra) # 80003f8c <readi>
    80004242:	fd351ae3          	bne	a0,s3,80004216 <dirlookup+0x4a>
    if(de.inum == 0)
    80004246:	fa045783          	lhu	a5,-96(s0)
    8000424a:	dff1                	beqz	a5,80004226 <dirlookup+0x5a>
    if(namecmp(name, de.name) == 0){
    8000424c:	85da                	mv	a1,s6
    8000424e:	8556                	mv	a0,s5
    80004250:	00000097          	auipc	ra,0x0
    80004254:	f62080e7          	jalr	-158(ra) # 800041b2 <namecmp>
    80004258:	f579                	bnez	a0,80004226 <dirlookup+0x5a>
      if(poff)
    8000425a:	000b8463          	beqz	s7,80004262 <dirlookup+0x96>
        *poff = off;
    8000425e:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80004262:	fa045583          	lhu	a1,-96(s0)
    80004266:	00092503          	lw	a0,0(s2)
    8000426a:	fffff097          	auipc	ra,0xfffff
    8000426e:	726080e7          	jalr	1830(ra) # 80003990 <iget>
    80004272:	a011                	j	80004276 <dirlookup+0xaa>
  return 0;
    80004274:	4501                	li	a0,0
}
    80004276:	60e6                	ld	ra,88(sp)
    80004278:	6446                	ld	s0,80(sp)
    8000427a:	64a6                	ld	s1,72(sp)
    8000427c:	6906                	ld	s2,64(sp)
    8000427e:	79e2                	ld	s3,56(sp)
    80004280:	7a42                	ld	s4,48(sp)
    80004282:	7aa2                	ld	s5,40(sp)
    80004284:	7b02                	ld	s6,32(sp)
    80004286:	6be2                	ld	s7,24(sp)
    80004288:	6125                	addi	sp,sp,96
    8000428a:	8082                	ret

000000008000428c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000428c:	711d                	addi	sp,sp,-96
    8000428e:	ec86                	sd	ra,88(sp)
    80004290:	e8a2                	sd	s0,80(sp)
    80004292:	e4a6                	sd	s1,72(sp)
    80004294:	e0ca                	sd	s2,64(sp)
    80004296:	fc4e                	sd	s3,56(sp)
    80004298:	f852                	sd	s4,48(sp)
    8000429a:	f456                	sd	s5,40(sp)
    8000429c:	f05a                	sd	s6,32(sp)
    8000429e:	ec5e                	sd	s7,24(sp)
    800042a0:	e862                	sd	s8,16(sp)
    800042a2:	e466                	sd	s9,8(sp)
    800042a4:	e06a                	sd	s10,0(sp)
    800042a6:	1080                	addi	s0,sp,96
    800042a8:	84aa                	mv	s1,a0
    800042aa:	8b2e                	mv	s6,a1
    800042ac:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800042ae:	00054703          	lbu	a4,0(a0)
    800042b2:	02f00793          	li	a5,47
    800042b6:	02f70363          	beq	a4,a5,800042dc <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800042ba:	ffffe097          	auipc	ra,0xffffe
    800042be:	a4c080e7          	jalr	-1460(ra) # 80001d06 <myproc>
    800042c2:	15053503          	ld	a0,336(a0)
    800042c6:	00000097          	auipc	ra,0x0
    800042ca:	9cc080e7          	jalr	-1588(ra) # 80003c92 <idup>
    800042ce:	8a2a                	mv	s4,a0
  while(*path == '/')
    800042d0:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800042d4:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    800042d6:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800042d8:	4b85                	li	s7,1
    800042da:	a87d                	j	80004398 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    800042dc:	4585                	li	a1,1
    800042de:	852e                	mv	a0,a1
    800042e0:	fffff097          	auipc	ra,0xfffff
    800042e4:	6b0080e7          	jalr	1712(ra) # 80003990 <iget>
    800042e8:	8a2a                	mv	s4,a0
    800042ea:	b7dd                	j	800042d0 <namex+0x44>
      iunlockput(ip);
    800042ec:	8552                	mv	a0,s4
    800042ee:	00000097          	auipc	ra,0x0
    800042f2:	c48080e7          	jalr	-952(ra) # 80003f36 <iunlockput>
      return 0;
    800042f6:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800042f8:	8552                	mv	a0,s4
    800042fa:	60e6                	ld	ra,88(sp)
    800042fc:	6446                	ld	s0,80(sp)
    800042fe:	64a6                	ld	s1,72(sp)
    80004300:	6906                	ld	s2,64(sp)
    80004302:	79e2                	ld	s3,56(sp)
    80004304:	7a42                	ld	s4,48(sp)
    80004306:	7aa2                	ld	s5,40(sp)
    80004308:	7b02                	ld	s6,32(sp)
    8000430a:	6be2                	ld	s7,24(sp)
    8000430c:	6c42                	ld	s8,16(sp)
    8000430e:	6ca2                	ld	s9,8(sp)
    80004310:	6d02                	ld	s10,0(sp)
    80004312:	6125                	addi	sp,sp,96
    80004314:	8082                	ret
      iunlock(ip);
    80004316:	8552                	mv	a0,s4
    80004318:	00000097          	auipc	ra,0x0
    8000431c:	a7e080e7          	jalr	-1410(ra) # 80003d96 <iunlock>
      return ip;
    80004320:	bfe1                	j	800042f8 <namex+0x6c>
      iunlockput(ip);
    80004322:	8552                	mv	a0,s4
    80004324:	00000097          	auipc	ra,0x0
    80004328:	c12080e7          	jalr	-1006(ra) # 80003f36 <iunlockput>
      return 0;
    8000432c:	8a4e                	mv	s4,s3
    8000432e:	b7e9                	j	800042f8 <namex+0x6c>
  len = path - s;
    80004330:	40998633          	sub	a2,s3,s1
    80004334:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80004338:	09ac5863          	bge	s8,s10,800043c8 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    8000433c:	8666                	mv	a2,s9
    8000433e:	85a6                	mv	a1,s1
    80004340:	8556                	mv	a0,s5
    80004342:	ffffd097          	auipc	ra,0xffffd
    80004346:	a58080e7          	jalr	-1448(ra) # 80000d9a <memmove>
    8000434a:	84ce                	mv	s1,s3
  while(*path == '/')
    8000434c:	0004c783          	lbu	a5,0(s1)
    80004350:	01279763          	bne	a5,s2,8000435e <namex+0xd2>
    path++;
    80004354:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004356:	0004c783          	lbu	a5,0(s1)
    8000435a:	ff278de3          	beq	a5,s2,80004354 <namex+0xc8>
    ilock(ip);
    8000435e:	8552                	mv	a0,s4
    80004360:	00000097          	auipc	ra,0x0
    80004364:	970080e7          	jalr	-1680(ra) # 80003cd0 <ilock>
    if(ip->type != T_DIR){
    80004368:	044a1783          	lh	a5,68(s4)
    8000436c:	f97790e3          	bne	a5,s7,800042ec <namex+0x60>
    if(nameiparent && *path == '\0'){
    80004370:	000b0563          	beqz	s6,8000437a <namex+0xee>
    80004374:	0004c783          	lbu	a5,0(s1)
    80004378:	dfd9                	beqz	a5,80004316 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000437a:	4601                	li	a2,0
    8000437c:	85d6                	mv	a1,s5
    8000437e:	8552                	mv	a0,s4
    80004380:	00000097          	auipc	ra,0x0
    80004384:	e4c080e7          	jalr	-436(ra) # 800041cc <dirlookup>
    80004388:	89aa                	mv	s3,a0
    8000438a:	dd41                	beqz	a0,80004322 <namex+0x96>
    iunlockput(ip);
    8000438c:	8552                	mv	a0,s4
    8000438e:	00000097          	auipc	ra,0x0
    80004392:	ba8080e7          	jalr	-1112(ra) # 80003f36 <iunlockput>
    ip = next;
    80004396:	8a4e                	mv	s4,s3
  while(*path == '/')
    80004398:	0004c783          	lbu	a5,0(s1)
    8000439c:	01279763          	bne	a5,s2,800043aa <namex+0x11e>
    path++;
    800043a0:	0485                	addi	s1,s1,1
  while(*path == '/')
    800043a2:	0004c783          	lbu	a5,0(s1)
    800043a6:	ff278de3          	beq	a5,s2,800043a0 <namex+0x114>
  if(*path == 0)
    800043aa:	cb9d                	beqz	a5,800043e0 <namex+0x154>
  while(*path != '/' && *path != 0)
    800043ac:	0004c783          	lbu	a5,0(s1)
    800043b0:	89a6                	mv	s3,s1
  len = path - s;
    800043b2:	4d01                	li	s10,0
    800043b4:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800043b6:	01278963          	beq	a5,s2,800043c8 <namex+0x13c>
    800043ba:	dbbd                	beqz	a5,80004330 <namex+0xa4>
    path++;
    800043bc:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800043be:	0009c783          	lbu	a5,0(s3)
    800043c2:	ff279ce3          	bne	a5,s2,800043ba <namex+0x12e>
    800043c6:	b7ad                	j	80004330 <namex+0xa4>
    memmove(name, s, len);
    800043c8:	2601                	sext.w	a2,a2
    800043ca:	85a6                	mv	a1,s1
    800043cc:	8556                	mv	a0,s5
    800043ce:	ffffd097          	auipc	ra,0xffffd
    800043d2:	9cc080e7          	jalr	-1588(ra) # 80000d9a <memmove>
    name[len] = 0;
    800043d6:	9d56                	add	s10,s10,s5
    800043d8:	000d0023          	sb	zero,0(s10)
    800043dc:	84ce                	mv	s1,s3
    800043de:	b7bd                	j	8000434c <namex+0xc0>
  if(nameiparent){
    800043e0:	f00b0ce3          	beqz	s6,800042f8 <namex+0x6c>
    iput(ip);
    800043e4:	8552                	mv	a0,s4
    800043e6:	00000097          	auipc	ra,0x0
    800043ea:	aa8080e7          	jalr	-1368(ra) # 80003e8e <iput>
    return 0;
    800043ee:	4a01                	li	s4,0
    800043f0:	b721                	j	800042f8 <namex+0x6c>

00000000800043f2 <dirlink>:
{
    800043f2:	715d                	addi	sp,sp,-80
    800043f4:	e486                	sd	ra,72(sp)
    800043f6:	e0a2                	sd	s0,64(sp)
    800043f8:	f84a                	sd	s2,48(sp)
    800043fa:	ec56                	sd	s5,24(sp)
    800043fc:	e85a                	sd	s6,16(sp)
    800043fe:	0880                	addi	s0,sp,80
    80004400:	892a                	mv	s2,a0
    80004402:	8aae                	mv	s5,a1
    80004404:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004406:	4601                	li	a2,0
    80004408:	00000097          	auipc	ra,0x0
    8000440c:	dc4080e7          	jalr	-572(ra) # 800041cc <dirlookup>
    80004410:	e129                	bnez	a0,80004452 <dirlink+0x60>
    80004412:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004414:	04c92483          	lw	s1,76(s2)
    80004418:	cca9                	beqz	s1,80004472 <dirlink+0x80>
    8000441a:	f44e                	sd	s3,40(sp)
    8000441c:	f052                	sd	s4,32(sp)
    8000441e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004420:	fb040a13          	addi	s4,s0,-80
    80004424:	49c1                	li	s3,16
    80004426:	874e                	mv	a4,s3
    80004428:	86a6                	mv	a3,s1
    8000442a:	8652                	mv	a2,s4
    8000442c:	4581                	li	a1,0
    8000442e:	854a                	mv	a0,s2
    80004430:	00000097          	auipc	ra,0x0
    80004434:	b5c080e7          	jalr	-1188(ra) # 80003f8c <readi>
    80004438:	03351363          	bne	a0,s3,8000445e <dirlink+0x6c>
    if(de.inum == 0)
    8000443c:	fb045783          	lhu	a5,-80(s0)
    80004440:	c79d                	beqz	a5,8000446e <dirlink+0x7c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004442:	24c1                	addiw	s1,s1,16
    80004444:	04c92783          	lw	a5,76(s2)
    80004448:	fcf4efe3          	bltu	s1,a5,80004426 <dirlink+0x34>
    8000444c:	79a2                	ld	s3,40(sp)
    8000444e:	7a02                	ld	s4,32(sp)
    80004450:	a00d                	j	80004472 <dirlink+0x80>
    iput(ip);
    80004452:	00000097          	auipc	ra,0x0
    80004456:	a3c080e7          	jalr	-1476(ra) # 80003e8e <iput>
    return -1;
    8000445a:	557d                	li	a0,-1
    8000445c:	a0a9                	j	800044a6 <dirlink+0xb4>
      panic("dirlink read");
    8000445e:	00004517          	auipc	a0,0x4
    80004462:	18a50513          	addi	a0,a0,394 # 800085e8 <etext+0x5e8>
    80004466:	ffffc097          	auipc	ra,0xffffc
    8000446a:	0fa080e7          	jalr	250(ra) # 80000560 <panic>
    8000446e:	79a2                	ld	s3,40(sp)
    80004470:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80004472:	4639                	li	a2,14
    80004474:	85d6                	mv	a1,s5
    80004476:	fb240513          	addi	a0,s0,-78
    8000447a:	ffffd097          	auipc	ra,0xffffd
    8000447e:	9d2080e7          	jalr	-1582(ra) # 80000e4c <strncpy>
  de.inum = inum;
    80004482:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004486:	4741                	li	a4,16
    80004488:	86a6                	mv	a3,s1
    8000448a:	fb040613          	addi	a2,s0,-80
    8000448e:	4581                	li	a1,0
    80004490:	854a                	mv	a0,s2
    80004492:	00000097          	auipc	ra,0x0
    80004496:	c00080e7          	jalr	-1024(ra) # 80004092 <writei>
    8000449a:	1541                	addi	a0,a0,-16
    8000449c:	00a03533          	snez	a0,a0
    800044a0:	40a0053b          	negw	a0,a0
    800044a4:	74e2                	ld	s1,56(sp)
}
    800044a6:	60a6                	ld	ra,72(sp)
    800044a8:	6406                	ld	s0,64(sp)
    800044aa:	7942                	ld	s2,48(sp)
    800044ac:	6ae2                	ld	s5,24(sp)
    800044ae:	6b42                	ld	s6,16(sp)
    800044b0:	6161                	addi	sp,sp,80
    800044b2:	8082                	ret

00000000800044b4 <namei>:

struct inode*
namei(char *path)
{
    800044b4:	1101                	addi	sp,sp,-32
    800044b6:	ec06                	sd	ra,24(sp)
    800044b8:	e822                	sd	s0,16(sp)
    800044ba:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800044bc:	fe040613          	addi	a2,s0,-32
    800044c0:	4581                	li	a1,0
    800044c2:	00000097          	auipc	ra,0x0
    800044c6:	dca080e7          	jalr	-566(ra) # 8000428c <namex>
}
    800044ca:	60e2                	ld	ra,24(sp)
    800044cc:	6442                	ld	s0,16(sp)
    800044ce:	6105                	addi	sp,sp,32
    800044d0:	8082                	ret

00000000800044d2 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800044d2:	1141                	addi	sp,sp,-16
    800044d4:	e406                	sd	ra,8(sp)
    800044d6:	e022                	sd	s0,0(sp)
    800044d8:	0800                	addi	s0,sp,16
    800044da:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800044dc:	4585                	li	a1,1
    800044de:	00000097          	auipc	ra,0x0
    800044e2:	dae080e7          	jalr	-594(ra) # 8000428c <namex>
}
    800044e6:	60a2                	ld	ra,8(sp)
    800044e8:	6402                	ld	s0,0(sp)
    800044ea:	0141                	addi	sp,sp,16
    800044ec:	8082                	ret

00000000800044ee <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800044ee:	1101                	addi	sp,sp,-32
    800044f0:	ec06                	sd	ra,24(sp)
    800044f2:	e822                	sd	s0,16(sp)
    800044f4:	e426                	sd	s1,8(sp)
    800044f6:	e04a                	sd	s2,0(sp)
    800044f8:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800044fa:	0001d917          	auipc	s2,0x1d
    800044fe:	95690913          	addi	s2,s2,-1706 # 80020e50 <log>
    80004502:	01892583          	lw	a1,24(s2)
    80004506:	02892503          	lw	a0,40(s2)
    8000450a:	fffff097          	auipc	ra,0xfffff
    8000450e:	fb8080e7          	jalr	-72(ra) # 800034c2 <bread>
    80004512:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004514:	02c92603          	lw	a2,44(s2)
    80004518:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000451a:	00c05f63          	blez	a2,80004538 <write_head+0x4a>
    8000451e:	0001d717          	auipc	a4,0x1d
    80004522:	96270713          	addi	a4,a4,-1694 # 80020e80 <log+0x30>
    80004526:	87aa                	mv	a5,a0
    80004528:	060a                	slli	a2,a2,0x2
    8000452a:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000452c:	4314                	lw	a3,0(a4)
    8000452e:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80004530:	0711                	addi	a4,a4,4
    80004532:	0791                	addi	a5,a5,4
    80004534:	fec79ce3          	bne	a5,a2,8000452c <write_head+0x3e>
  }
  bwrite(buf);
    80004538:	8526                	mv	a0,s1
    8000453a:	fffff097          	auipc	ra,0xfffff
    8000453e:	07a080e7          	jalr	122(ra) # 800035b4 <bwrite>
  brelse(buf);
    80004542:	8526                	mv	a0,s1
    80004544:	fffff097          	auipc	ra,0xfffff
    80004548:	0ae080e7          	jalr	174(ra) # 800035f2 <brelse>
}
    8000454c:	60e2                	ld	ra,24(sp)
    8000454e:	6442                	ld	s0,16(sp)
    80004550:	64a2                	ld	s1,8(sp)
    80004552:	6902                	ld	s2,0(sp)
    80004554:	6105                	addi	sp,sp,32
    80004556:	8082                	ret

0000000080004558 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004558:	0001d797          	auipc	a5,0x1d
    8000455c:	9247a783          	lw	a5,-1756(a5) # 80020e7c <log+0x2c>
    80004560:	0cf05063          	blez	a5,80004620 <install_trans+0xc8>
{
    80004564:	715d                	addi	sp,sp,-80
    80004566:	e486                	sd	ra,72(sp)
    80004568:	e0a2                	sd	s0,64(sp)
    8000456a:	fc26                	sd	s1,56(sp)
    8000456c:	f84a                	sd	s2,48(sp)
    8000456e:	f44e                	sd	s3,40(sp)
    80004570:	f052                	sd	s4,32(sp)
    80004572:	ec56                	sd	s5,24(sp)
    80004574:	e85a                	sd	s6,16(sp)
    80004576:	e45e                	sd	s7,8(sp)
    80004578:	0880                	addi	s0,sp,80
    8000457a:	8b2a                	mv	s6,a0
    8000457c:	0001da97          	auipc	s5,0x1d
    80004580:	904a8a93          	addi	s5,s5,-1788 # 80020e80 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004584:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004586:	0001d997          	auipc	s3,0x1d
    8000458a:	8ca98993          	addi	s3,s3,-1846 # 80020e50 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000458e:	40000b93          	li	s7,1024
    80004592:	a00d                	j	800045b4 <install_trans+0x5c>
    brelse(lbuf);
    80004594:	854a                	mv	a0,s2
    80004596:	fffff097          	auipc	ra,0xfffff
    8000459a:	05c080e7          	jalr	92(ra) # 800035f2 <brelse>
    brelse(dbuf);
    8000459e:	8526                	mv	a0,s1
    800045a0:	fffff097          	auipc	ra,0xfffff
    800045a4:	052080e7          	jalr	82(ra) # 800035f2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800045a8:	2a05                	addiw	s4,s4,1
    800045aa:	0a91                	addi	s5,s5,4
    800045ac:	02c9a783          	lw	a5,44(s3)
    800045b0:	04fa5d63          	bge	s4,a5,8000460a <install_trans+0xb2>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800045b4:	0189a583          	lw	a1,24(s3)
    800045b8:	014585bb          	addw	a1,a1,s4
    800045bc:	2585                	addiw	a1,a1,1
    800045be:	0289a503          	lw	a0,40(s3)
    800045c2:	fffff097          	auipc	ra,0xfffff
    800045c6:	f00080e7          	jalr	-256(ra) # 800034c2 <bread>
    800045ca:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800045cc:	000aa583          	lw	a1,0(s5)
    800045d0:	0289a503          	lw	a0,40(s3)
    800045d4:	fffff097          	auipc	ra,0xfffff
    800045d8:	eee080e7          	jalr	-274(ra) # 800034c2 <bread>
    800045dc:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800045de:	865e                	mv	a2,s7
    800045e0:	05890593          	addi	a1,s2,88
    800045e4:	05850513          	addi	a0,a0,88
    800045e8:	ffffc097          	auipc	ra,0xffffc
    800045ec:	7b2080e7          	jalr	1970(ra) # 80000d9a <memmove>
    bwrite(dbuf);  // write dst to disk
    800045f0:	8526                	mv	a0,s1
    800045f2:	fffff097          	auipc	ra,0xfffff
    800045f6:	fc2080e7          	jalr	-62(ra) # 800035b4 <bwrite>
    if(recovering == 0)
    800045fa:	f80b1de3          	bnez	s6,80004594 <install_trans+0x3c>
      bunpin(dbuf);
    800045fe:	8526                	mv	a0,s1
    80004600:	fffff097          	auipc	ra,0xfffff
    80004604:	0c6080e7          	jalr	198(ra) # 800036c6 <bunpin>
    80004608:	b771                	j	80004594 <install_trans+0x3c>
}
    8000460a:	60a6                	ld	ra,72(sp)
    8000460c:	6406                	ld	s0,64(sp)
    8000460e:	74e2                	ld	s1,56(sp)
    80004610:	7942                	ld	s2,48(sp)
    80004612:	79a2                	ld	s3,40(sp)
    80004614:	7a02                	ld	s4,32(sp)
    80004616:	6ae2                	ld	s5,24(sp)
    80004618:	6b42                	ld	s6,16(sp)
    8000461a:	6ba2                	ld	s7,8(sp)
    8000461c:	6161                	addi	sp,sp,80
    8000461e:	8082                	ret
    80004620:	8082                	ret

0000000080004622 <initlog>:
{
    80004622:	7179                	addi	sp,sp,-48
    80004624:	f406                	sd	ra,40(sp)
    80004626:	f022                	sd	s0,32(sp)
    80004628:	ec26                	sd	s1,24(sp)
    8000462a:	e84a                	sd	s2,16(sp)
    8000462c:	e44e                	sd	s3,8(sp)
    8000462e:	1800                	addi	s0,sp,48
    80004630:	892a                	mv	s2,a0
    80004632:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004634:	0001d497          	auipc	s1,0x1d
    80004638:	81c48493          	addi	s1,s1,-2020 # 80020e50 <log>
    8000463c:	00004597          	auipc	a1,0x4
    80004640:	fbc58593          	addi	a1,a1,-68 # 800085f8 <etext+0x5f8>
    80004644:	8526                	mv	a0,s1
    80004646:	ffffc097          	auipc	ra,0xffffc
    8000464a:	564080e7          	jalr	1380(ra) # 80000baa <initlock>
  log.start = sb->logstart;
    8000464e:	0149a583          	lw	a1,20(s3)
    80004652:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004654:	0109a783          	lw	a5,16(s3)
    80004658:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000465a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000465e:	854a                	mv	a0,s2
    80004660:	fffff097          	auipc	ra,0xfffff
    80004664:	e62080e7          	jalr	-414(ra) # 800034c2 <bread>
  log.lh.n = lh->n;
    80004668:	4d30                	lw	a2,88(a0)
    8000466a:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000466c:	00c05f63          	blez	a2,8000468a <initlog+0x68>
    80004670:	87aa                	mv	a5,a0
    80004672:	0001d717          	auipc	a4,0x1d
    80004676:	80e70713          	addi	a4,a4,-2034 # 80020e80 <log+0x30>
    8000467a:	060a                	slli	a2,a2,0x2
    8000467c:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000467e:	4ff4                	lw	a3,92(a5)
    80004680:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004682:	0791                	addi	a5,a5,4
    80004684:	0711                	addi	a4,a4,4
    80004686:	fec79ce3          	bne	a5,a2,8000467e <initlog+0x5c>
  brelse(buf);
    8000468a:	fffff097          	auipc	ra,0xfffff
    8000468e:	f68080e7          	jalr	-152(ra) # 800035f2 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004692:	4505                	li	a0,1
    80004694:	00000097          	auipc	ra,0x0
    80004698:	ec4080e7          	jalr	-316(ra) # 80004558 <install_trans>
  log.lh.n = 0;
    8000469c:	0001c797          	auipc	a5,0x1c
    800046a0:	7e07a023          	sw	zero,2016(a5) # 80020e7c <log+0x2c>
  write_head(); // clear the log
    800046a4:	00000097          	auipc	ra,0x0
    800046a8:	e4a080e7          	jalr	-438(ra) # 800044ee <write_head>
}
    800046ac:	70a2                	ld	ra,40(sp)
    800046ae:	7402                	ld	s0,32(sp)
    800046b0:	64e2                	ld	s1,24(sp)
    800046b2:	6942                	ld	s2,16(sp)
    800046b4:	69a2                	ld	s3,8(sp)
    800046b6:	6145                	addi	sp,sp,48
    800046b8:	8082                	ret

00000000800046ba <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800046ba:	1101                	addi	sp,sp,-32
    800046bc:	ec06                	sd	ra,24(sp)
    800046be:	e822                	sd	s0,16(sp)
    800046c0:	e426                	sd	s1,8(sp)
    800046c2:	e04a                	sd	s2,0(sp)
    800046c4:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800046c6:	0001c517          	auipc	a0,0x1c
    800046ca:	78a50513          	addi	a0,a0,1930 # 80020e50 <log>
    800046ce:	ffffc097          	auipc	ra,0xffffc
    800046d2:	570080e7          	jalr	1392(ra) # 80000c3e <acquire>
  while(1){
    if(log.committing){
    800046d6:	0001c497          	auipc	s1,0x1c
    800046da:	77a48493          	addi	s1,s1,1914 # 80020e50 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800046de:	4979                	li	s2,30
    800046e0:	a039                	j	800046ee <begin_op+0x34>
      sleep(&log, &log.lock);
    800046e2:	85a6                	mv	a1,s1
    800046e4:	8526                	mv	a0,s1
    800046e6:	ffffe097          	auipc	ra,0xffffe
    800046ea:	e02080e7          	jalr	-510(ra) # 800024e8 <sleep>
    if(log.committing){
    800046ee:	50dc                	lw	a5,36(s1)
    800046f0:	fbed                	bnez	a5,800046e2 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800046f2:	5098                	lw	a4,32(s1)
    800046f4:	2705                	addiw	a4,a4,1
    800046f6:	0027179b          	slliw	a5,a4,0x2
    800046fa:	9fb9                	addw	a5,a5,a4
    800046fc:	0017979b          	slliw	a5,a5,0x1
    80004700:	54d4                	lw	a3,44(s1)
    80004702:	9fb5                	addw	a5,a5,a3
    80004704:	00f95963          	bge	s2,a5,80004716 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004708:	85a6                	mv	a1,s1
    8000470a:	8526                	mv	a0,s1
    8000470c:	ffffe097          	auipc	ra,0xffffe
    80004710:	ddc080e7          	jalr	-548(ra) # 800024e8 <sleep>
    80004714:	bfe9                	j	800046ee <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004716:	0001c517          	auipc	a0,0x1c
    8000471a:	73a50513          	addi	a0,a0,1850 # 80020e50 <log>
    8000471e:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80004720:	ffffc097          	auipc	ra,0xffffc
    80004724:	5ce080e7          	jalr	1486(ra) # 80000cee <release>
      break;
    }
  }
}
    80004728:	60e2                	ld	ra,24(sp)
    8000472a:	6442                	ld	s0,16(sp)
    8000472c:	64a2                	ld	s1,8(sp)
    8000472e:	6902                	ld	s2,0(sp)
    80004730:	6105                	addi	sp,sp,32
    80004732:	8082                	ret

0000000080004734 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004734:	7139                	addi	sp,sp,-64
    80004736:	fc06                	sd	ra,56(sp)
    80004738:	f822                	sd	s0,48(sp)
    8000473a:	f426                	sd	s1,40(sp)
    8000473c:	f04a                	sd	s2,32(sp)
    8000473e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004740:	0001c497          	auipc	s1,0x1c
    80004744:	71048493          	addi	s1,s1,1808 # 80020e50 <log>
    80004748:	8526                	mv	a0,s1
    8000474a:	ffffc097          	auipc	ra,0xffffc
    8000474e:	4f4080e7          	jalr	1268(ra) # 80000c3e <acquire>
  log.outstanding -= 1;
    80004752:	509c                	lw	a5,32(s1)
    80004754:	37fd                	addiw	a5,a5,-1
    80004756:	893e                	mv	s2,a5
    80004758:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000475a:	50dc                	lw	a5,36(s1)
    8000475c:	e7b9                	bnez	a5,800047aa <end_op+0x76>
    panic("log.committing");
  if(log.outstanding == 0){
    8000475e:	06091263          	bnez	s2,800047c2 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004762:	0001c497          	auipc	s1,0x1c
    80004766:	6ee48493          	addi	s1,s1,1774 # 80020e50 <log>
    8000476a:	4785                	li	a5,1
    8000476c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000476e:	8526                	mv	a0,s1
    80004770:	ffffc097          	auipc	ra,0xffffc
    80004774:	57e080e7          	jalr	1406(ra) # 80000cee <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004778:	54dc                	lw	a5,44(s1)
    8000477a:	06f04863          	bgtz	a5,800047ea <end_op+0xb6>
    acquire(&log.lock);
    8000477e:	0001c497          	auipc	s1,0x1c
    80004782:	6d248493          	addi	s1,s1,1746 # 80020e50 <log>
    80004786:	8526                	mv	a0,s1
    80004788:	ffffc097          	auipc	ra,0xffffc
    8000478c:	4b6080e7          	jalr	1206(ra) # 80000c3e <acquire>
    log.committing = 0;
    80004790:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004794:	8526                	mv	a0,s1
    80004796:	ffffe097          	auipc	ra,0xffffe
    8000479a:	db6080e7          	jalr	-586(ra) # 8000254c <wakeup>
    release(&log.lock);
    8000479e:	8526                	mv	a0,s1
    800047a0:	ffffc097          	auipc	ra,0xffffc
    800047a4:	54e080e7          	jalr	1358(ra) # 80000cee <release>
}
    800047a8:	a81d                	j	800047de <end_op+0xaa>
    800047aa:	ec4e                	sd	s3,24(sp)
    800047ac:	e852                	sd	s4,16(sp)
    800047ae:	e456                	sd	s5,8(sp)
    800047b0:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    800047b2:	00004517          	auipc	a0,0x4
    800047b6:	e4e50513          	addi	a0,a0,-434 # 80008600 <etext+0x600>
    800047ba:	ffffc097          	auipc	ra,0xffffc
    800047be:	da6080e7          	jalr	-602(ra) # 80000560 <panic>
    wakeup(&log);
    800047c2:	0001c497          	auipc	s1,0x1c
    800047c6:	68e48493          	addi	s1,s1,1678 # 80020e50 <log>
    800047ca:	8526                	mv	a0,s1
    800047cc:	ffffe097          	auipc	ra,0xffffe
    800047d0:	d80080e7          	jalr	-640(ra) # 8000254c <wakeup>
  release(&log.lock);
    800047d4:	8526                	mv	a0,s1
    800047d6:	ffffc097          	auipc	ra,0xffffc
    800047da:	518080e7          	jalr	1304(ra) # 80000cee <release>
}
    800047de:	70e2                	ld	ra,56(sp)
    800047e0:	7442                	ld	s0,48(sp)
    800047e2:	74a2                	ld	s1,40(sp)
    800047e4:	7902                	ld	s2,32(sp)
    800047e6:	6121                	addi	sp,sp,64
    800047e8:	8082                	ret
    800047ea:	ec4e                	sd	s3,24(sp)
    800047ec:	e852                	sd	s4,16(sp)
    800047ee:	e456                	sd	s5,8(sp)
    800047f0:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800047f2:	0001ca97          	auipc	s5,0x1c
    800047f6:	68ea8a93          	addi	s5,s5,1678 # 80020e80 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800047fa:	0001ca17          	auipc	s4,0x1c
    800047fe:	656a0a13          	addi	s4,s4,1622 # 80020e50 <log>
    memmove(to->data, from->data, BSIZE);
    80004802:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004806:	018a2583          	lw	a1,24(s4)
    8000480a:	012585bb          	addw	a1,a1,s2
    8000480e:	2585                	addiw	a1,a1,1
    80004810:	028a2503          	lw	a0,40(s4)
    80004814:	fffff097          	auipc	ra,0xfffff
    80004818:	cae080e7          	jalr	-850(ra) # 800034c2 <bread>
    8000481c:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000481e:	000aa583          	lw	a1,0(s5)
    80004822:	028a2503          	lw	a0,40(s4)
    80004826:	fffff097          	auipc	ra,0xfffff
    8000482a:	c9c080e7          	jalr	-868(ra) # 800034c2 <bread>
    8000482e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004830:	865a                	mv	a2,s6
    80004832:	05850593          	addi	a1,a0,88
    80004836:	05848513          	addi	a0,s1,88
    8000483a:	ffffc097          	auipc	ra,0xffffc
    8000483e:	560080e7          	jalr	1376(ra) # 80000d9a <memmove>
    bwrite(to);  // write the log
    80004842:	8526                	mv	a0,s1
    80004844:	fffff097          	auipc	ra,0xfffff
    80004848:	d70080e7          	jalr	-656(ra) # 800035b4 <bwrite>
    brelse(from);
    8000484c:	854e                	mv	a0,s3
    8000484e:	fffff097          	auipc	ra,0xfffff
    80004852:	da4080e7          	jalr	-604(ra) # 800035f2 <brelse>
    brelse(to);
    80004856:	8526                	mv	a0,s1
    80004858:	fffff097          	auipc	ra,0xfffff
    8000485c:	d9a080e7          	jalr	-614(ra) # 800035f2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004860:	2905                	addiw	s2,s2,1
    80004862:	0a91                	addi	s5,s5,4
    80004864:	02ca2783          	lw	a5,44(s4)
    80004868:	f8f94fe3          	blt	s2,a5,80004806 <end_op+0xd2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000486c:	00000097          	auipc	ra,0x0
    80004870:	c82080e7          	jalr	-894(ra) # 800044ee <write_head>
    install_trans(0); // Now install writes to home locations
    80004874:	4501                	li	a0,0
    80004876:	00000097          	auipc	ra,0x0
    8000487a:	ce2080e7          	jalr	-798(ra) # 80004558 <install_trans>
    log.lh.n = 0;
    8000487e:	0001c797          	auipc	a5,0x1c
    80004882:	5e07af23          	sw	zero,1534(a5) # 80020e7c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004886:	00000097          	auipc	ra,0x0
    8000488a:	c68080e7          	jalr	-920(ra) # 800044ee <write_head>
    8000488e:	69e2                	ld	s3,24(sp)
    80004890:	6a42                	ld	s4,16(sp)
    80004892:	6aa2                	ld	s5,8(sp)
    80004894:	6b02                	ld	s6,0(sp)
    80004896:	b5e5                	j	8000477e <end_op+0x4a>

0000000080004898 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004898:	1101                	addi	sp,sp,-32
    8000489a:	ec06                	sd	ra,24(sp)
    8000489c:	e822                	sd	s0,16(sp)
    8000489e:	e426                	sd	s1,8(sp)
    800048a0:	e04a                	sd	s2,0(sp)
    800048a2:	1000                	addi	s0,sp,32
    800048a4:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800048a6:	0001c917          	auipc	s2,0x1c
    800048aa:	5aa90913          	addi	s2,s2,1450 # 80020e50 <log>
    800048ae:	854a                	mv	a0,s2
    800048b0:	ffffc097          	auipc	ra,0xffffc
    800048b4:	38e080e7          	jalr	910(ra) # 80000c3e <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800048b8:	02c92603          	lw	a2,44(s2)
    800048bc:	47f5                	li	a5,29
    800048be:	06c7c563          	blt	a5,a2,80004928 <log_write+0x90>
    800048c2:	0001c797          	auipc	a5,0x1c
    800048c6:	5aa7a783          	lw	a5,1450(a5) # 80020e6c <log+0x1c>
    800048ca:	37fd                	addiw	a5,a5,-1
    800048cc:	04f65e63          	bge	a2,a5,80004928 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800048d0:	0001c797          	auipc	a5,0x1c
    800048d4:	5a07a783          	lw	a5,1440(a5) # 80020e70 <log+0x20>
    800048d8:	06f05063          	blez	a5,80004938 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800048dc:	4781                	li	a5,0
    800048de:	06c05563          	blez	a2,80004948 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800048e2:	44cc                	lw	a1,12(s1)
    800048e4:	0001c717          	auipc	a4,0x1c
    800048e8:	59c70713          	addi	a4,a4,1436 # 80020e80 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800048ec:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800048ee:	4314                	lw	a3,0(a4)
    800048f0:	04b68c63          	beq	a3,a1,80004948 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800048f4:	2785                	addiw	a5,a5,1
    800048f6:	0711                	addi	a4,a4,4
    800048f8:	fef61be3          	bne	a2,a5,800048ee <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800048fc:	0621                	addi	a2,a2,8
    800048fe:	060a                	slli	a2,a2,0x2
    80004900:	0001c797          	auipc	a5,0x1c
    80004904:	55078793          	addi	a5,a5,1360 # 80020e50 <log>
    80004908:	97b2                	add	a5,a5,a2
    8000490a:	44d8                	lw	a4,12(s1)
    8000490c:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000490e:	8526                	mv	a0,s1
    80004910:	fffff097          	auipc	ra,0xfffff
    80004914:	d7a080e7          	jalr	-646(ra) # 8000368a <bpin>
    log.lh.n++;
    80004918:	0001c717          	auipc	a4,0x1c
    8000491c:	53870713          	addi	a4,a4,1336 # 80020e50 <log>
    80004920:	575c                	lw	a5,44(a4)
    80004922:	2785                	addiw	a5,a5,1
    80004924:	d75c                	sw	a5,44(a4)
    80004926:	a82d                	j	80004960 <log_write+0xc8>
    panic("too big a transaction");
    80004928:	00004517          	auipc	a0,0x4
    8000492c:	ce850513          	addi	a0,a0,-792 # 80008610 <etext+0x610>
    80004930:	ffffc097          	auipc	ra,0xffffc
    80004934:	c30080e7          	jalr	-976(ra) # 80000560 <panic>
    panic("log_write outside of trans");
    80004938:	00004517          	auipc	a0,0x4
    8000493c:	cf050513          	addi	a0,a0,-784 # 80008628 <etext+0x628>
    80004940:	ffffc097          	auipc	ra,0xffffc
    80004944:	c20080e7          	jalr	-992(ra) # 80000560 <panic>
  log.lh.block[i] = b->blockno;
    80004948:	00878693          	addi	a3,a5,8
    8000494c:	068a                	slli	a3,a3,0x2
    8000494e:	0001c717          	auipc	a4,0x1c
    80004952:	50270713          	addi	a4,a4,1282 # 80020e50 <log>
    80004956:	9736                	add	a4,a4,a3
    80004958:	44d4                	lw	a3,12(s1)
    8000495a:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000495c:	faf609e3          	beq	a2,a5,8000490e <log_write+0x76>
  }
  release(&log.lock);
    80004960:	0001c517          	auipc	a0,0x1c
    80004964:	4f050513          	addi	a0,a0,1264 # 80020e50 <log>
    80004968:	ffffc097          	auipc	ra,0xffffc
    8000496c:	386080e7          	jalr	902(ra) # 80000cee <release>
}
    80004970:	60e2                	ld	ra,24(sp)
    80004972:	6442                	ld	s0,16(sp)
    80004974:	64a2                	ld	s1,8(sp)
    80004976:	6902                	ld	s2,0(sp)
    80004978:	6105                	addi	sp,sp,32
    8000497a:	8082                	ret

000000008000497c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000497c:	1101                	addi	sp,sp,-32
    8000497e:	ec06                	sd	ra,24(sp)
    80004980:	e822                	sd	s0,16(sp)
    80004982:	e426                	sd	s1,8(sp)
    80004984:	e04a                	sd	s2,0(sp)
    80004986:	1000                	addi	s0,sp,32
    80004988:	84aa                	mv	s1,a0
    8000498a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000498c:	00004597          	auipc	a1,0x4
    80004990:	cbc58593          	addi	a1,a1,-836 # 80008648 <etext+0x648>
    80004994:	0521                	addi	a0,a0,8
    80004996:	ffffc097          	auipc	ra,0xffffc
    8000499a:	214080e7          	jalr	532(ra) # 80000baa <initlock>
  lk->name = name;
    8000499e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800049a2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800049a6:	0204a423          	sw	zero,40(s1)
}
    800049aa:	60e2                	ld	ra,24(sp)
    800049ac:	6442                	ld	s0,16(sp)
    800049ae:	64a2                	ld	s1,8(sp)
    800049b0:	6902                	ld	s2,0(sp)
    800049b2:	6105                	addi	sp,sp,32
    800049b4:	8082                	ret

00000000800049b6 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800049b6:	1101                	addi	sp,sp,-32
    800049b8:	ec06                	sd	ra,24(sp)
    800049ba:	e822                	sd	s0,16(sp)
    800049bc:	e426                	sd	s1,8(sp)
    800049be:	e04a                	sd	s2,0(sp)
    800049c0:	1000                	addi	s0,sp,32
    800049c2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800049c4:	00850913          	addi	s2,a0,8
    800049c8:	854a                	mv	a0,s2
    800049ca:	ffffc097          	auipc	ra,0xffffc
    800049ce:	274080e7          	jalr	628(ra) # 80000c3e <acquire>
  while (lk->locked) {
    800049d2:	409c                	lw	a5,0(s1)
    800049d4:	cb89                	beqz	a5,800049e6 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800049d6:	85ca                	mv	a1,s2
    800049d8:	8526                	mv	a0,s1
    800049da:	ffffe097          	auipc	ra,0xffffe
    800049de:	b0e080e7          	jalr	-1266(ra) # 800024e8 <sleep>
  while (lk->locked) {
    800049e2:	409c                	lw	a5,0(s1)
    800049e4:	fbed                	bnez	a5,800049d6 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800049e6:	4785                	li	a5,1
    800049e8:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800049ea:	ffffd097          	auipc	ra,0xffffd
    800049ee:	31c080e7          	jalr	796(ra) # 80001d06 <myproc>
    800049f2:	591c                	lw	a5,48(a0)
    800049f4:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800049f6:	854a                	mv	a0,s2
    800049f8:	ffffc097          	auipc	ra,0xffffc
    800049fc:	2f6080e7          	jalr	758(ra) # 80000cee <release>
}
    80004a00:	60e2                	ld	ra,24(sp)
    80004a02:	6442                	ld	s0,16(sp)
    80004a04:	64a2                	ld	s1,8(sp)
    80004a06:	6902                	ld	s2,0(sp)
    80004a08:	6105                	addi	sp,sp,32
    80004a0a:	8082                	ret

0000000080004a0c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004a0c:	1101                	addi	sp,sp,-32
    80004a0e:	ec06                	sd	ra,24(sp)
    80004a10:	e822                	sd	s0,16(sp)
    80004a12:	e426                	sd	s1,8(sp)
    80004a14:	e04a                	sd	s2,0(sp)
    80004a16:	1000                	addi	s0,sp,32
    80004a18:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004a1a:	00850913          	addi	s2,a0,8
    80004a1e:	854a                	mv	a0,s2
    80004a20:	ffffc097          	auipc	ra,0xffffc
    80004a24:	21e080e7          	jalr	542(ra) # 80000c3e <acquire>
  lk->locked = 0;
    80004a28:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004a2c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004a30:	8526                	mv	a0,s1
    80004a32:	ffffe097          	auipc	ra,0xffffe
    80004a36:	b1a080e7          	jalr	-1254(ra) # 8000254c <wakeup>
  release(&lk->lk);
    80004a3a:	854a                	mv	a0,s2
    80004a3c:	ffffc097          	auipc	ra,0xffffc
    80004a40:	2b2080e7          	jalr	690(ra) # 80000cee <release>
}
    80004a44:	60e2                	ld	ra,24(sp)
    80004a46:	6442                	ld	s0,16(sp)
    80004a48:	64a2                	ld	s1,8(sp)
    80004a4a:	6902                	ld	s2,0(sp)
    80004a4c:	6105                	addi	sp,sp,32
    80004a4e:	8082                	ret

0000000080004a50 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004a50:	7179                	addi	sp,sp,-48
    80004a52:	f406                	sd	ra,40(sp)
    80004a54:	f022                	sd	s0,32(sp)
    80004a56:	ec26                	sd	s1,24(sp)
    80004a58:	e84a                	sd	s2,16(sp)
    80004a5a:	1800                	addi	s0,sp,48
    80004a5c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004a5e:	00850913          	addi	s2,a0,8
    80004a62:	854a                	mv	a0,s2
    80004a64:	ffffc097          	auipc	ra,0xffffc
    80004a68:	1da080e7          	jalr	474(ra) # 80000c3e <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004a6c:	409c                	lw	a5,0(s1)
    80004a6e:	ef91                	bnez	a5,80004a8a <holdingsleep+0x3a>
    80004a70:	4481                	li	s1,0
  release(&lk->lk);
    80004a72:	854a                	mv	a0,s2
    80004a74:	ffffc097          	auipc	ra,0xffffc
    80004a78:	27a080e7          	jalr	634(ra) # 80000cee <release>
  return r;
}
    80004a7c:	8526                	mv	a0,s1
    80004a7e:	70a2                	ld	ra,40(sp)
    80004a80:	7402                	ld	s0,32(sp)
    80004a82:	64e2                	ld	s1,24(sp)
    80004a84:	6942                	ld	s2,16(sp)
    80004a86:	6145                	addi	sp,sp,48
    80004a88:	8082                	ret
    80004a8a:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004a8c:	0284a983          	lw	s3,40(s1)
    80004a90:	ffffd097          	auipc	ra,0xffffd
    80004a94:	276080e7          	jalr	630(ra) # 80001d06 <myproc>
    80004a98:	5904                	lw	s1,48(a0)
    80004a9a:	413484b3          	sub	s1,s1,s3
    80004a9e:	0014b493          	seqz	s1,s1
    80004aa2:	69a2                	ld	s3,8(sp)
    80004aa4:	b7f9                	j	80004a72 <holdingsleep+0x22>

0000000080004aa6 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004aa6:	1141                	addi	sp,sp,-16
    80004aa8:	e406                	sd	ra,8(sp)
    80004aaa:	e022                	sd	s0,0(sp)
    80004aac:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004aae:	00004597          	auipc	a1,0x4
    80004ab2:	baa58593          	addi	a1,a1,-1110 # 80008658 <etext+0x658>
    80004ab6:	0001c517          	auipc	a0,0x1c
    80004aba:	4e250513          	addi	a0,a0,1250 # 80020f98 <ftable>
    80004abe:	ffffc097          	auipc	ra,0xffffc
    80004ac2:	0ec080e7          	jalr	236(ra) # 80000baa <initlock>
}
    80004ac6:	60a2                	ld	ra,8(sp)
    80004ac8:	6402                	ld	s0,0(sp)
    80004aca:	0141                	addi	sp,sp,16
    80004acc:	8082                	ret

0000000080004ace <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004ace:	1101                	addi	sp,sp,-32
    80004ad0:	ec06                	sd	ra,24(sp)
    80004ad2:	e822                	sd	s0,16(sp)
    80004ad4:	e426                	sd	s1,8(sp)
    80004ad6:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004ad8:	0001c517          	auipc	a0,0x1c
    80004adc:	4c050513          	addi	a0,a0,1216 # 80020f98 <ftable>
    80004ae0:	ffffc097          	auipc	ra,0xffffc
    80004ae4:	15e080e7          	jalr	350(ra) # 80000c3e <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004ae8:	0001c497          	auipc	s1,0x1c
    80004aec:	4c848493          	addi	s1,s1,1224 # 80020fb0 <ftable+0x18>
    80004af0:	0001d717          	auipc	a4,0x1d
    80004af4:	46070713          	addi	a4,a4,1120 # 80021f50 <disk>
    if(f->ref == 0){
    80004af8:	40dc                	lw	a5,4(s1)
    80004afa:	cf99                	beqz	a5,80004b18 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004afc:	02848493          	addi	s1,s1,40
    80004b00:	fee49ce3          	bne	s1,a4,80004af8 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004b04:	0001c517          	auipc	a0,0x1c
    80004b08:	49450513          	addi	a0,a0,1172 # 80020f98 <ftable>
    80004b0c:	ffffc097          	auipc	ra,0xffffc
    80004b10:	1e2080e7          	jalr	482(ra) # 80000cee <release>
  return 0;
    80004b14:	4481                	li	s1,0
    80004b16:	a819                	j	80004b2c <filealloc+0x5e>
      f->ref = 1;
    80004b18:	4785                	li	a5,1
    80004b1a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004b1c:	0001c517          	auipc	a0,0x1c
    80004b20:	47c50513          	addi	a0,a0,1148 # 80020f98 <ftable>
    80004b24:	ffffc097          	auipc	ra,0xffffc
    80004b28:	1ca080e7          	jalr	458(ra) # 80000cee <release>
}
    80004b2c:	8526                	mv	a0,s1
    80004b2e:	60e2                	ld	ra,24(sp)
    80004b30:	6442                	ld	s0,16(sp)
    80004b32:	64a2                	ld	s1,8(sp)
    80004b34:	6105                	addi	sp,sp,32
    80004b36:	8082                	ret

0000000080004b38 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004b38:	1101                	addi	sp,sp,-32
    80004b3a:	ec06                	sd	ra,24(sp)
    80004b3c:	e822                	sd	s0,16(sp)
    80004b3e:	e426                	sd	s1,8(sp)
    80004b40:	1000                	addi	s0,sp,32
    80004b42:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004b44:	0001c517          	auipc	a0,0x1c
    80004b48:	45450513          	addi	a0,a0,1108 # 80020f98 <ftable>
    80004b4c:	ffffc097          	auipc	ra,0xffffc
    80004b50:	0f2080e7          	jalr	242(ra) # 80000c3e <acquire>
  if(f->ref < 1)
    80004b54:	40dc                	lw	a5,4(s1)
    80004b56:	02f05263          	blez	a5,80004b7a <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004b5a:	2785                	addiw	a5,a5,1
    80004b5c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004b5e:	0001c517          	auipc	a0,0x1c
    80004b62:	43a50513          	addi	a0,a0,1082 # 80020f98 <ftable>
    80004b66:	ffffc097          	auipc	ra,0xffffc
    80004b6a:	188080e7          	jalr	392(ra) # 80000cee <release>
  return f;
}
    80004b6e:	8526                	mv	a0,s1
    80004b70:	60e2                	ld	ra,24(sp)
    80004b72:	6442                	ld	s0,16(sp)
    80004b74:	64a2                	ld	s1,8(sp)
    80004b76:	6105                	addi	sp,sp,32
    80004b78:	8082                	ret
    panic("filedup");
    80004b7a:	00004517          	auipc	a0,0x4
    80004b7e:	ae650513          	addi	a0,a0,-1306 # 80008660 <etext+0x660>
    80004b82:	ffffc097          	auipc	ra,0xffffc
    80004b86:	9de080e7          	jalr	-1570(ra) # 80000560 <panic>

0000000080004b8a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004b8a:	7139                	addi	sp,sp,-64
    80004b8c:	fc06                	sd	ra,56(sp)
    80004b8e:	f822                	sd	s0,48(sp)
    80004b90:	f426                	sd	s1,40(sp)
    80004b92:	0080                	addi	s0,sp,64
    80004b94:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004b96:	0001c517          	auipc	a0,0x1c
    80004b9a:	40250513          	addi	a0,a0,1026 # 80020f98 <ftable>
    80004b9e:	ffffc097          	auipc	ra,0xffffc
    80004ba2:	0a0080e7          	jalr	160(ra) # 80000c3e <acquire>
  if(f->ref < 1)
    80004ba6:	40dc                	lw	a5,4(s1)
    80004ba8:	04f05a63          	blez	a5,80004bfc <fileclose+0x72>
    panic("fileclose");
  if(--f->ref > 0){
    80004bac:	37fd                	addiw	a5,a5,-1
    80004bae:	c0dc                	sw	a5,4(s1)
    80004bb0:	06f04263          	bgtz	a5,80004c14 <fileclose+0x8a>
    80004bb4:	f04a                	sd	s2,32(sp)
    80004bb6:	ec4e                	sd	s3,24(sp)
    80004bb8:	e852                	sd	s4,16(sp)
    80004bba:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004bbc:	0004a903          	lw	s2,0(s1)
    80004bc0:	0094ca83          	lbu	s5,9(s1)
    80004bc4:	0104ba03          	ld	s4,16(s1)
    80004bc8:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004bcc:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004bd0:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004bd4:	0001c517          	auipc	a0,0x1c
    80004bd8:	3c450513          	addi	a0,a0,964 # 80020f98 <ftable>
    80004bdc:	ffffc097          	auipc	ra,0xffffc
    80004be0:	112080e7          	jalr	274(ra) # 80000cee <release>

  if(ff.type == FD_PIPE){
    80004be4:	4785                	li	a5,1
    80004be6:	04f90463          	beq	s2,a5,80004c2e <fileclose+0xa4>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004bea:	3979                	addiw	s2,s2,-2
    80004bec:	4785                	li	a5,1
    80004bee:	0527fb63          	bgeu	a5,s2,80004c44 <fileclose+0xba>
    80004bf2:	7902                	ld	s2,32(sp)
    80004bf4:	69e2                	ld	s3,24(sp)
    80004bf6:	6a42                	ld	s4,16(sp)
    80004bf8:	6aa2                	ld	s5,8(sp)
    80004bfa:	a02d                	j	80004c24 <fileclose+0x9a>
    80004bfc:	f04a                	sd	s2,32(sp)
    80004bfe:	ec4e                	sd	s3,24(sp)
    80004c00:	e852                	sd	s4,16(sp)
    80004c02:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004c04:	00004517          	auipc	a0,0x4
    80004c08:	a6450513          	addi	a0,a0,-1436 # 80008668 <etext+0x668>
    80004c0c:	ffffc097          	auipc	ra,0xffffc
    80004c10:	954080e7          	jalr	-1708(ra) # 80000560 <panic>
    release(&ftable.lock);
    80004c14:	0001c517          	auipc	a0,0x1c
    80004c18:	38450513          	addi	a0,a0,900 # 80020f98 <ftable>
    80004c1c:	ffffc097          	auipc	ra,0xffffc
    80004c20:	0d2080e7          	jalr	210(ra) # 80000cee <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004c24:	70e2                	ld	ra,56(sp)
    80004c26:	7442                	ld	s0,48(sp)
    80004c28:	74a2                	ld	s1,40(sp)
    80004c2a:	6121                	addi	sp,sp,64
    80004c2c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004c2e:	85d6                	mv	a1,s5
    80004c30:	8552                	mv	a0,s4
    80004c32:	00000097          	auipc	ra,0x0
    80004c36:	3ac080e7          	jalr	940(ra) # 80004fde <pipeclose>
    80004c3a:	7902                	ld	s2,32(sp)
    80004c3c:	69e2                	ld	s3,24(sp)
    80004c3e:	6a42                	ld	s4,16(sp)
    80004c40:	6aa2                	ld	s5,8(sp)
    80004c42:	b7cd                	j	80004c24 <fileclose+0x9a>
    begin_op();
    80004c44:	00000097          	auipc	ra,0x0
    80004c48:	a76080e7          	jalr	-1418(ra) # 800046ba <begin_op>
    iput(ff.ip);
    80004c4c:	854e                	mv	a0,s3
    80004c4e:	fffff097          	auipc	ra,0xfffff
    80004c52:	240080e7          	jalr	576(ra) # 80003e8e <iput>
    end_op();
    80004c56:	00000097          	auipc	ra,0x0
    80004c5a:	ade080e7          	jalr	-1314(ra) # 80004734 <end_op>
    80004c5e:	7902                	ld	s2,32(sp)
    80004c60:	69e2                	ld	s3,24(sp)
    80004c62:	6a42                	ld	s4,16(sp)
    80004c64:	6aa2                	ld	s5,8(sp)
    80004c66:	bf7d                	j	80004c24 <fileclose+0x9a>

0000000080004c68 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004c68:	715d                	addi	sp,sp,-80
    80004c6a:	e486                	sd	ra,72(sp)
    80004c6c:	e0a2                	sd	s0,64(sp)
    80004c6e:	fc26                	sd	s1,56(sp)
    80004c70:	f44e                	sd	s3,40(sp)
    80004c72:	0880                	addi	s0,sp,80
    80004c74:	84aa                	mv	s1,a0
    80004c76:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004c78:	ffffd097          	auipc	ra,0xffffd
    80004c7c:	08e080e7          	jalr	142(ra) # 80001d06 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004c80:	409c                	lw	a5,0(s1)
    80004c82:	37f9                	addiw	a5,a5,-2
    80004c84:	4705                	li	a4,1
    80004c86:	04f76a63          	bltu	a4,a5,80004cda <filestat+0x72>
    80004c8a:	f84a                	sd	s2,48(sp)
    80004c8c:	f052                	sd	s4,32(sp)
    80004c8e:	892a                	mv	s2,a0
    ilock(f->ip);
    80004c90:	6c88                	ld	a0,24(s1)
    80004c92:	fffff097          	auipc	ra,0xfffff
    80004c96:	03e080e7          	jalr	62(ra) # 80003cd0 <ilock>
    stati(f->ip, &st);
    80004c9a:	fb840a13          	addi	s4,s0,-72
    80004c9e:	85d2                	mv	a1,s4
    80004ca0:	6c88                	ld	a0,24(s1)
    80004ca2:	fffff097          	auipc	ra,0xfffff
    80004ca6:	2bc080e7          	jalr	700(ra) # 80003f5e <stati>
    iunlock(f->ip);
    80004caa:	6c88                	ld	a0,24(s1)
    80004cac:	fffff097          	auipc	ra,0xfffff
    80004cb0:	0ea080e7          	jalr	234(ra) # 80003d96 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004cb4:	46e1                	li	a3,24
    80004cb6:	8652                	mv	a2,s4
    80004cb8:	85ce                	mv	a1,s3
    80004cba:	05093503          	ld	a0,80(s2)
    80004cbe:	ffffd097          	auipc	ra,0xffffd
    80004cc2:	a52080e7          	jalr	-1454(ra) # 80001710 <copyout>
    80004cc6:	41f5551b          	sraiw	a0,a0,0x1f
    80004cca:	7942                	ld	s2,48(sp)
    80004ccc:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004cce:	60a6                	ld	ra,72(sp)
    80004cd0:	6406                	ld	s0,64(sp)
    80004cd2:	74e2                	ld	s1,56(sp)
    80004cd4:	79a2                	ld	s3,40(sp)
    80004cd6:	6161                	addi	sp,sp,80
    80004cd8:	8082                	ret
  return -1;
    80004cda:	557d                	li	a0,-1
    80004cdc:	bfcd                	j	80004cce <filestat+0x66>

0000000080004cde <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004cde:	7179                	addi	sp,sp,-48
    80004ce0:	f406                	sd	ra,40(sp)
    80004ce2:	f022                	sd	s0,32(sp)
    80004ce4:	e84a                	sd	s2,16(sp)
    80004ce6:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004ce8:	00854783          	lbu	a5,8(a0)
    80004cec:	cbc5                	beqz	a5,80004d9c <fileread+0xbe>
    80004cee:	ec26                	sd	s1,24(sp)
    80004cf0:	e44e                	sd	s3,8(sp)
    80004cf2:	84aa                	mv	s1,a0
    80004cf4:	89ae                	mv	s3,a1
    80004cf6:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004cf8:	411c                	lw	a5,0(a0)
    80004cfa:	4705                	li	a4,1
    80004cfc:	04e78963          	beq	a5,a4,80004d4e <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004d00:	470d                	li	a4,3
    80004d02:	04e78f63          	beq	a5,a4,80004d60 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004d06:	4709                	li	a4,2
    80004d08:	08e79263          	bne	a5,a4,80004d8c <fileread+0xae>
    ilock(f->ip);
    80004d0c:	6d08                	ld	a0,24(a0)
    80004d0e:	fffff097          	auipc	ra,0xfffff
    80004d12:	fc2080e7          	jalr	-62(ra) # 80003cd0 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004d16:	874a                	mv	a4,s2
    80004d18:	5094                	lw	a3,32(s1)
    80004d1a:	864e                	mv	a2,s3
    80004d1c:	4585                	li	a1,1
    80004d1e:	6c88                	ld	a0,24(s1)
    80004d20:	fffff097          	auipc	ra,0xfffff
    80004d24:	26c080e7          	jalr	620(ra) # 80003f8c <readi>
    80004d28:	892a                	mv	s2,a0
    80004d2a:	00a05563          	blez	a0,80004d34 <fileread+0x56>
      f->off += r;
    80004d2e:	509c                	lw	a5,32(s1)
    80004d30:	9fa9                	addw	a5,a5,a0
    80004d32:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004d34:	6c88                	ld	a0,24(s1)
    80004d36:	fffff097          	auipc	ra,0xfffff
    80004d3a:	060080e7          	jalr	96(ra) # 80003d96 <iunlock>
    80004d3e:	64e2                	ld	s1,24(sp)
    80004d40:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004d42:	854a                	mv	a0,s2
    80004d44:	70a2                	ld	ra,40(sp)
    80004d46:	7402                	ld	s0,32(sp)
    80004d48:	6942                	ld	s2,16(sp)
    80004d4a:	6145                	addi	sp,sp,48
    80004d4c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004d4e:	6908                	ld	a0,16(a0)
    80004d50:	00000097          	auipc	ra,0x0
    80004d54:	41a080e7          	jalr	1050(ra) # 8000516a <piperead>
    80004d58:	892a                	mv	s2,a0
    80004d5a:	64e2                	ld	s1,24(sp)
    80004d5c:	69a2                	ld	s3,8(sp)
    80004d5e:	b7d5                	j	80004d42 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004d60:	02451783          	lh	a5,36(a0)
    80004d64:	03079693          	slli	a3,a5,0x30
    80004d68:	92c1                	srli	a3,a3,0x30
    80004d6a:	4725                	li	a4,9
    80004d6c:	02d76a63          	bltu	a4,a3,80004da0 <fileread+0xc2>
    80004d70:	0792                	slli	a5,a5,0x4
    80004d72:	0001c717          	auipc	a4,0x1c
    80004d76:	18670713          	addi	a4,a4,390 # 80020ef8 <devsw>
    80004d7a:	97ba                	add	a5,a5,a4
    80004d7c:	639c                	ld	a5,0(a5)
    80004d7e:	c78d                	beqz	a5,80004da8 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80004d80:	4505                	li	a0,1
    80004d82:	9782                	jalr	a5
    80004d84:	892a                	mv	s2,a0
    80004d86:	64e2                	ld	s1,24(sp)
    80004d88:	69a2                	ld	s3,8(sp)
    80004d8a:	bf65                	j	80004d42 <fileread+0x64>
    panic("fileread");
    80004d8c:	00004517          	auipc	a0,0x4
    80004d90:	8ec50513          	addi	a0,a0,-1812 # 80008678 <etext+0x678>
    80004d94:	ffffb097          	auipc	ra,0xffffb
    80004d98:	7cc080e7          	jalr	1996(ra) # 80000560 <panic>
    return -1;
    80004d9c:	597d                	li	s2,-1
    80004d9e:	b755                	j	80004d42 <fileread+0x64>
      return -1;
    80004da0:	597d                	li	s2,-1
    80004da2:	64e2                	ld	s1,24(sp)
    80004da4:	69a2                	ld	s3,8(sp)
    80004da6:	bf71                	j	80004d42 <fileread+0x64>
    80004da8:	597d                	li	s2,-1
    80004daa:	64e2                	ld	s1,24(sp)
    80004dac:	69a2                	ld	s3,8(sp)
    80004dae:	bf51                	j	80004d42 <fileread+0x64>

0000000080004db0 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004db0:	00954783          	lbu	a5,9(a0)
    80004db4:	12078c63          	beqz	a5,80004eec <filewrite+0x13c>
{
    80004db8:	711d                	addi	sp,sp,-96
    80004dba:	ec86                	sd	ra,88(sp)
    80004dbc:	e8a2                	sd	s0,80(sp)
    80004dbe:	e0ca                	sd	s2,64(sp)
    80004dc0:	f456                	sd	s5,40(sp)
    80004dc2:	f05a                	sd	s6,32(sp)
    80004dc4:	1080                	addi	s0,sp,96
    80004dc6:	892a                	mv	s2,a0
    80004dc8:	8b2e                	mv	s6,a1
    80004dca:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80004dcc:	411c                	lw	a5,0(a0)
    80004dce:	4705                	li	a4,1
    80004dd0:	02e78963          	beq	a5,a4,80004e02 <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004dd4:	470d                	li	a4,3
    80004dd6:	02e78c63          	beq	a5,a4,80004e0e <filewrite+0x5e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004dda:	4709                	li	a4,2
    80004ddc:	0ee79a63          	bne	a5,a4,80004ed0 <filewrite+0x120>
    80004de0:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004de2:	0cc05563          	blez	a2,80004eac <filewrite+0xfc>
    80004de6:	e4a6                	sd	s1,72(sp)
    80004de8:	fc4e                	sd	s3,56(sp)
    80004dea:	ec5e                	sd	s7,24(sp)
    80004dec:	e862                	sd	s8,16(sp)
    80004dee:	e466                	sd	s9,8(sp)
    int i = 0;
    80004df0:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80004df2:	6b85                	lui	s7,0x1
    80004df4:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004df8:	6c85                	lui	s9,0x1
    80004dfa:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004dfe:	4c05                	li	s8,1
    80004e00:	a849                	j	80004e92 <filewrite+0xe2>
    ret = pipewrite(f->pipe, addr, n);
    80004e02:	6908                	ld	a0,16(a0)
    80004e04:	00000097          	auipc	ra,0x0
    80004e08:	24a080e7          	jalr	586(ra) # 8000504e <pipewrite>
    80004e0c:	a85d                	j	80004ec2 <filewrite+0x112>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004e0e:	02451783          	lh	a5,36(a0)
    80004e12:	03079693          	slli	a3,a5,0x30
    80004e16:	92c1                	srli	a3,a3,0x30
    80004e18:	4725                	li	a4,9
    80004e1a:	0cd76b63          	bltu	a4,a3,80004ef0 <filewrite+0x140>
    80004e1e:	0792                	slli	a5,a5,0x4
    80004e20:	0001c717          	auipc	a4,0x1c
    80004e24:	0d870713          	addi	a4,a4,216 # 80020ef8 <devsw>
    80004e28:	97ba                	add	a5,a5,a4
    80004e2a:	679c                	ld	a5,8(a5)
    80004e2c:	c7e1                	beqz	a5,80004ef4 <filewrite+0x144>
    ret = devsw[f->major].write(1, addr, n);
    80004e2e:	4505                	li	a0,1
    80004e30:	9782                	jalr	a5
    80004e32:	a841                	j	80004ec2 <filewrite+0x112>
      if(n1 > max)
    80004e34:	2981                	sext.w	s3,s3
      begin_op();
    80004e36:	00000097          	auipc	ra,0x0
    80004e3a:	884080e7          	jalr	-1916(ra) # 800046ba <begin_op>
      ilock(f->ip);
    80004e3e:	01893503          	ld	a0,24(s2)
    80004e42:	fffff097          	auipc	ra,0xfffff
    80004e46:	e8e080e7          	jalr	-370(ra) # 80003cd0 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004e4a:	874e                	mv	a4,s3
    80004e4c:	02092683          	lw	a3,32(s2)
    80004e50:	016a0633          	add	a2,s4,s6
    80004e54:	85e2                	mv	a1,s8
    80004e56:	01893503          	ld	a0,24(s2)
    80004e5a:	fffff097          	auipc	ra,0xfffff
    80004e5e:	238080e7          	jalr	568(ra) # 80004092 <writei>
    80004e62:	84aa                	mv	s1,a0
    80004e64:	00a05763          	blez	a0,80004e72 <filewrite+0xc2>
        f->off += r;
    80004e68:	02092783          	lw	a5,32(s2)
    80004e6c:	9fa9                	addw	a5,a5,a0
    80004e6e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004e72:	01893503          	ld	a0,24(s2)
    80004e76:	fffff097          	auipc	ra,0xfffff
    80004e7a:	f20080e7          	jalr	-224(ra) # 80003d96 <iunlock>
      end_op();
    80004e7e:	00000097          	auipc	ra,0x0
    80004e82:	8b6080e7          	jalr	-1866(ra) # 80004734 <end_op>

      if(r != n1){
    80004e86:	02999563          	bne	s3,s1,80004eb0 <filewrite+0x100>
        // error from writei
        break;
      }
      i += r;
    80004e8a:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80004e8e:	015a5963          	bge	s4,s5,80004ea0 <filewrite+0xf0>
      int n1 = n - i;
    80004e92:	414a87bb          	subw	a5,s5,s4
    80004e96:	89be                	mv	s3,a5
      if(n1 > max)
    80004e98:	f8fbdee3          	bge	s7,a5,80004e34 <filewrite+0x84>
    80004e9c:	89e6                	mv	s3,s9
    80004e9e:	bf59                	j	80004e34 <filewrite+0x84>
    80004ea0:	64a6                	ld	s1,72(sp)
    80004ea2:	79e2                	ld	s3,56(sp)
    80004ea4:	6be2                	ld	s7,24(sp)
    80004ea6:	6c42                	ld	s8,16(sp)
    80004ea8:	6ca2                	ld	s9,8(sp)
    80004eaa:	a801                	j	80004eba <filewrite+0x10a>
    int i = 0;
    80004eac:	4a01                	li	s4,0
    80004eae:	a031                	j	80004eba <filewrite+0x10a>
    80004eb0:	64a6                	ld	s1,72(sp)
    80004eb2:	79e2                	ld	s3,56(sp)
    80004eb4:	6be2                	ld	s7,24(sp)
    80004eb6:	6c42                	ld	s8,16(sp)
    80004eb8:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80004eba:	034a9f63          	bne	s5,s4,80004ef8 <filewrite+0x148>
    80004ebe:	8556                	mv	a0,s5
    80004ec0:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004ec2:	60e6                	ld	ra,88(sp)
    80004ec4:	6446                	ld	s0,80(sp)
    80004ec6:	6906                	ld	s2,64(sp)
    80004ec8:	7aa2                	ld	s5,40(sp)
    80004eca:	7b02                	ld	s6,32(sp)
    80004ecc:	6125                	addi	sp,sp,96
    80004ece:	8082                	ret
    80004ed0:	e4a6                	sd	s1,72(sp)
    80004ed2:	fc4e                	sd	s3,56(sp)
    80004ed4:	f852                	sd	s4,48(sp)
    80004ed6:	ec5e                	sd	s7,24(sp)
    80004ed8:	e862                	sd	s8,16(sp)
    80004eda:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80004edc:	00003517          	auipc	a0,0x3
    80004ee0:	7ac50513          	addi	a0,a0,1964 # 80008688 <etext+0x688>
    80004ee4:	ffffb097          	auipc	ra,0xffffb
    80004ee8:	67c080e7          	jalr	1660(ra) # 80000560 <panic>
    return -1;
    80004eec:	557d                	li	a0,-1
}
    80004eee:	8082                	ret
      return -1;
    80004ef0:	557d                	li	a0,-1
    80004ef2:	bfc1                	j	80004ec2 <filewrite+0x112>
    80004ef4:	557d                	li	a0,-1
    80004ef6:	b7f1                	j	80004ec2 <filewrite+0x112>
    ret = (i == n ? n : -1);
    80004ef8:	557d                	li	a0,-1
    80004efa:	7a42                	ld	s4,48(sp)
    80004efc:	b7d9                	j	80004ec2 <filewrite+0x112>

0000000080004efe <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004efe:	7179                	addi	sp,sp,-48
    80004f00:	f406                	sd	ra,40(sp)
    80004f02:	f022                	sd	s0,32(sp)
    80004f04:	ec26                	sd	s1,24(sp)
    80004f06:	e052                	sd	s4,0(sp)
    80004f08:	1800                	addi	s0,sp,48
    80004f0a:	84aa                	mv	s1,a0
    80004f0c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004f0e:	0005b023          	sd	zero,0(a1)
    80004f12:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004f16:	00000097          	auipc	ra,0x0
    80004f1a:	bb8080e7          	jalr	-1096(ra) # 80004ace <filealloc>
    80004f1e:	e088                	sd	a0,0(s1)
    80004f20:	cd49                	beqz	a0,80004fba <pipealloc+0xbc>
    80004f22:	00000097          	auipc	ra,0x0
    80004f26:	bac080e7          	jalr	-1108(ra) # 80004ace <filealloc>
    80004f2a:	00aa3023          	sd	a0,0(s4)
    80004f2e:	c141                	beqz	a0,80004fae <pipealloc+0xb0>
    80004f30:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004f32:	ffffc097          	auipc	ra,0xffffc
    80004f36:	c18080e7          	jalr	-1000(ra) # 80000b4a <kalloc>
    80004f3a:	892a                	mv	s2,a0
    80004f3c:	c13d                	beqz	a0,80004fa2 <pipealloc+0xa4>
    80004f3e:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004f40:	4985                	li	s3,1
    80004f42:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004f46:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004f4a:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004f4e:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004f52:	00003597          	auipc	a1,0x3
    80004f56:	74658593          	addi	a1,a1,1862 # 80008698 <etext+0x698>
    80004f5a:	ffffc097          	auipc	ra,0xffffc
    80004f5e:	c50080e7          	jalr	-944(ra) # 80000baa <initlock>
  (*f0)->type = FD_PIPE;
    80004f62:	609c                	ld	a5,0(s1)
    80004f64:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004f68:	609c                	ld	a5,0(s1)
    80004f6a:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004f6e:	609c                	ld	a5,0(s1)
    80004f70:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004f74:	609c                	ld	a5,0(s1)
    80004f76:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004f7a:	000a3783          	ld	a5,0(s4)
    80004f7e:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004f82:	000a3783          	ld	a5,0(s4)
    80004f86:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004f8a:	000a3783          	ld	a5,0(s4)
    80004f8e:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004f92:	000a3783          	ld	a5,0(s4)
    80004f96:	0127b823          	sd	s2,16(a5)
  return 0;
    80004f9a:	4501                	li	a0,0
    80004f9c:	6942                	ld	s2,16(sp)
    80004f9e:	69a2                	ld	s3,8(sp)
    80004fa0:	a03d                	j	80004fce <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004fa2:	6088                	ld	a0,0(s1)
    80004fa4:	c119                	beqz	a0,80004faa <pipealloc+0xac>
    80004fa6:	6942                	ld	s2,16(sp)
    80004fa8:	a029                	j	80004fb2 <pipealloc+0xb4>
    80004faa:	6942                	ld	s2,16(sp)
    80004fac:	a039                	j	80004fba <pipealloc+0xbc>
    80004fae:	6088                	ld	a0,0(s1)
    80004fb0:	c50d                	beqz	a0,80004fda <pipealloc+0xdc>
    fileclose(*f0);
    80004fb2:	00000097          	auipc	ra,0x0
    80004fb6:	bd8080e7          	jalr	-1064(ra) # 80004b8a <fileclose>
  if(*f1)
    80004fba:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004fbe:	557d                	li	a0,-1
  if(*f1)
    80004fc0:	c799                	beqz	a5,80004fce <pipealloc+0xd0>
    fileclose(*f1);
    80004fc2:	853e                	mv	a0,a5
    80004fc4:	00000097          	auipc	ra,0x0
    80004fc8:	bc6080e7          	jalr	-1082(ra) # 80004b8a <fileclose>
  return -1;
    80004fcc:	557d                	li	a0,-1
}
    80004fce:	70a2                	ld	ra,40(sp)
    80004fd0:	7402                	ld	s0,32(sp)
    80004fd2:	64e2                	ld	s1,24(sp)
    80004fd4:	6a02                	ld	s4,0(sp)
    80004fd6:	6145                	addi	sp,sp,48
    80004fd8:	8082                	ret
  return -1;
    80004fda:	557d                	li	a0,-1
    80004fdc:	bfcd                	j	80004fce <pipealloc+0xd0>

0000000080004fde <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004fde:	1101                	addi	sp,sp,-32
    80004fe0:	ec06                	sd	ra,24(sp)
    80004fe2:	e822                	sd	s0,16(sp)
    80004fe4:	e426                	sd	s1,8(sp)
    80004fe6:	e04a                	sd	s2,0(sp)
    80004fe8:	1000                	addi	s0,sp,32
    80004fea:	84aa                	mv	s1,a0
    80004fec:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004fee:	ffffc097          	auipc	ra,0xffffc
    80004ff2:	c50080e7          	jalr	-944(ra) # 80000c3e <acquire>
  if(writable){
    80004ff6:	02090d63          	beqz	s2,80005030 <pipeclose+0x52>
    pi->writeopen = 0;
    80004ffa:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004ffe:	21848513          	addi	a0,s1,536
    80005002:	ffffd097          	auipc	ra,0xffffd
    80005006:	54a080e7          	jalr	1354(ra) # 8000254c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000500a:	2204b783          	ld	a5,544(s1)
    8000500e:	eb95                	bnez	a5,80005042 <pipeclose+0x64>
    release(&pi->lock);
    80005010:	8526                	mv	a0,s1
    80005012:	ffffc097          	auipc	ra,0xffffc
    80005016:	cdc080e7          	jalr	-804(ra) # 80000cee <release>
    kfree((char*)pi);
    8000501a:	8526                	mv	a0,s1
    8000501c:	ffffc097          	auipc	ra,0xffffc
    80005020:	a30080e7          	jalr	-1488(ra) # 80000a4c <kfree>
  } else
    release(&pi->lock);
}
    80005024:	60e2                	ld	ra,24(sp)
    80005026:	6442                	ld	s0,16(sp)
    80005028:	64a2                	ld	s1,8(sp)
    8000502a:	6902                	ld	s2,0(sp)
    8000502c:	6105                	addi	sp,sp,32
    8000502e:	8082                	ret
    pi->readopen = 0;
    80005030:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80005034:	21c48513          	addi	a0,s1,540
    80005038:	ffffd097          	auipc	ra,0xffffd
    8000503c:	514080e7          	jalr	1300(ra) # 8000254c <wakeup>
    80005040:	b7e9                	j	8000500a <pipeclose+0x2c>
    release(&pi->lock);
    80005042:	8526                	mv	a0,s1
    80005044:	ffffc097          	auipc	ra,0xffffc
    80005048:	caa080e7          	jalr	-854(ra) # 80000cee <release>
}
    8000504c:	bfe1                	j	80005024 <pipeclose+0x46>

000000008000504e <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000504e:	7159                	addi	sp,sp,-112
    80005050:	f486                	sd	ra,104(sp)
    80005052:	f0a2                	sd	s0,96(sp)
    80005054:	eca6                	sd	s1,88(sp)
    80005056:	e8ca                	sd	s2,80(sp)
    80005058:	e4ce                	sd	s3,72(sp)
    8000505a:	e0d2                	sd	s4,64(sp)
    8000505c:	fc56                	sd	s5,56(sp)
    8000505e:	1880                	addi	s0,sp,112
    80005060:	84aa                	mv	s1,a0
    80005062:	8aae                	mv	s5,a1
    80005064:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80005066:	ffffd097          	auipc	ra,0xffffd
    8000506a:	ca0080e7          	jalr	-864(ra) # 80001d06 <myproc>
    8000506e:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80005070:	8526                	mv	a0,s1
    80005072:	ffffc097          	auipc	ra,0xffffc
    80005076:	bcc080e7          	jalr	-1076(ra) # 80000c3e <acquire>
  while(i < n){
    8000507a:	0f405063          	blez	s4,8000515a <pipewrite+0x10c>
    8000507e:	f85a                	sd	s6,48(sp)
    80005080:	f45e                	sd	s7,40(sp)
    80005082:	f062                	sd	s8,32(sp)
    80005084:	ec66                	sd	s9,24(sp)
    80005086:	e86a                	sd	s10,16(sp)
  int i = 0;
    80005088:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000508a:	f9f40c13          	addi	s8,s0,-97
    8000508e:	4b85                	li	s7,1
    80005090:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80005092:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80005096:	21c48c93          	addi	s9,s1,540
    8000509a:	a099                	j	800050e0 <pipewrite+0x92>
      release(&pi->lock);
    8000509c:	8526                	mv	a0,s1
    8000509e:	ffffc097          	auipc	ra,0xffffc
    800050a2:	c50080e7          	jalr	-944(ra) # 80000cee <release>
      return -1;
    800050a6:	597d                	li	s2,-1
    800050a8:	7b42                	ld	s6,48(sp)
    800050aa:	7ba2                	ld	s7,40(sp)
    800050ac:	7c02                	ld	s8,32(sp)
    800050ae:	6ce2                	ld	s9,24(sp)
    800050b0:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800050b2:	854a                	mv	a0,s2
    800050b4:	70a6                	ld	ra,104(sp)
    800050b6:	7406                	ld	s0,96(sp)
    800050b8:	64e6                	ld	s1,88(sp)
    800050ba:	6946                	ld	s2,80(sp)
    800050bc:	69a6                	ld	s3,72(sp)
    800050be:	6a06                	ld	s4,64(sp)
    800050c0:	7ae2                	ld	s5,56(sp)
    800050c2:	6165                	addi	sp,sp,112
    800050c4:	8082                	ret
      wakeup(&pi->nread);
    800050c6:	856a                	mv	a0,s10
    800050c8:	ffffd097          	auipc	ra,0xffffd
    800050cc:	484080e7          	jalr	1156(ra) # 8000254c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800050d0:	85a6                	mv	a1,s1
    800050d2:	8566                	mv	a0,s9
    800050d4:	ffffd097          	auipc	ra,0xffffd
    800050d8:	414080e7          	jalr	1044(ra) # 800024e8 <sleep>
  while(i < n){
    800050dc:	05495e63          	bge	s2,s4,80005138 <pipewrite+0xea>
    if(pi->readopen == 0 || killed(pr)){
    800050e0:	2204a783          	lw	a5,544(s1)
    800050e4:	dfc5                	beqz	a5,8000509c <pipewrite+0x4e>
    800050e6:	854e                	mv	a0,s3
    800050e8:	ffffd097          	auipc	ra,0xffffd
    800050ec:	6a8080e7          	jalr	1704(ra) # 80002790 <killed>
    800050f0:	f555                	bnez	a0,8000509c <pipewrite+0x4e>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800050f2:	2184a783          	lw	a5,536(s1)
    800050f6:	21c4a703          	lw	a4,540(s1)
    800050fa:	2007879b          	addiw	a5,a5,512
    800050fe:	fcf704e3          	beq	a4,a5,800050c6 <pipewrite+0x78>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80005102:	86de                	mv	a3,s7
    80005104:	01590633          	add	a2,s2,s5
    80005108:	85e2                	mv	a1,s8
    8000510a:	0509b503          	ld	a0,80(s3)
    8000510e:	ffffc097          	auipc	ra,0xffffc
    80005112:	68e080e7          	jalr	1678(ra) # 8000179c <copyin>
    80005116:	05650463          	beq	a0,s6,8000515e <pipewrite+0x110>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000511a:	21c4a783          	lw	a5,540(s1)
    8000511e:	0017871b          	addiw	a4,a5,1
    80005122:	20e4ae23          	sw	a4,540(s1)
    80005126:	1ff7f793          	andi	a5,a5,511
    8000512a:	97a6                	add	a5,a5,s1
    8000512c:	f9f44703          	lbu	a4,-97(s0)
    80005130:	00e78c23          	sb	a4,24(a5)
      i++;
    80005134:	2905                	addiw	s2,s2,1
    80005136:	b75d                	j	800050dc <pipewrite+0x8e>
    80005138:	7b42                	ld	s6,48(sp)
    8000513a:	7ba2                	ld	s7,40(sp)
    8000513c:	7c02                	ld	s8,32(sp)
    8000513e:	6ce2                	ld	s9,24(sp)
    80005140:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80005142:	21848513          	addi	a0,s1,536
    80005146:	ffffd097          	auipc	ra,0xffffd
    8000514a:	406080e7          	jalr	1030(ra) # 8000254c <wakeup>
  release(&pi->lock);
    8000514e:	8526                	mv	a0,s1
    80005150:	ffffc097          	auipc	ra,0xffffc
    80005154:	b9e080e7          	jalr	-1122(ra) # 80000cee <release>
  return i;
    80005158:	bfa9                	j	800050b2 <pipewrite+0x64>
  int i = 0;
    8000515a:	4901                	li	s2,0
    8000515c:	b7dd                	j	80005142 <pipewrite+0xf4>
    8000515e:	7b42                	ld	s6,48(sp)
    80005160:	7ba2                	ld	s7,40(sp)
    80005162:	7c02                	ld	s8,32(sp)
    80005164:	6ce2                	ld	s9,24(sp)
    80005166:	6d42                	ld	s10,16(sp)
    80005168:	bfe9                	j	80005142 <pipewrite+0xf4>

000000008000516a <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000516a:	711d                	addi	sp,sp,-96
    8000516c:	ec86                	sd	ra,88(sp)
    8000516e:	e8a2                	sd	s0,80(sp)
    80005170:	e4a6                	sd	s1,72(sp)
    80005172:	e0ca                	sd	s2,64(sp)
    80005174:	fc4e                	sd	s3,56(sp)
    80005176:	f852                	sd	s4,48(sp)
    80005178:	f456                	sd	s5,40(sp)
    8000517a:	1080                	addi	s0,sp,96
    8000517c:	84aa                	mv	s1,a0
    8000517e:	892e                	mv	s2,a1
    80005180:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80005182:	ffffd097          	auipc	ra,0xffffd
    80005186:	b84080e7          	jalr	-1148(ra) # 80001d06 <myproc>
    8000518a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000518c:	8526                	mv	a0,s1
    8000518e:	ffffc097          	auipc	ra,0xffffc
    80005192:	ab0080e7          	jalr	-1360(ra) # 80000c3e <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005196:	2184a703          	lw	a4,536(s1)
    8000519a:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000519e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800051a2:	02f71b63          	bne	a4,a5,800051d8 <piperead+0x6e>
    800051a6:	2244a783          	lw	a5,548(s1)
    800051aa:	c3b1                	beqz	a5,800051ee <piperead+0x84>
    if(killed(pr)){
    800051ac:	8552                	mv	a0,s4
    800051ae:	ffffd097          	auipc	ra,0xffffd
    800051b2:	5e2080e7          	jalr	1506(ra) # 80002790 <killed>
    800051b6:	e50d                	bnez	a0,800051e0 <piperead+0x76>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800051b8:	85a6                	mv	a1,s1
    800051ba:	854e                	mv	a0,s3
    800051bc:	ffffd097          	auipc	ra,0xffffd
    800051c0:	32c080e7          	jalr	812(ra) # 800024e8 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800051c4:	2184a703          	lw	a4,536(s1)
    800051c8:	21c4a783          	lw	a5,540(s1)
    800051cc:	fcf70de3          	beq	a4,a5,800051a6 <piperead+0x3c>
    800051d0:	f05a                	sd	s6,32(sp)
    800051d2:	ec5e                	sd	s7,24(sp)
    800051d4:	e862                	sd	s8,16(sp)
    800051d6:	a839                	j	800051f4 <piperead+0x8a>
    800051d8:	f05a                	sd	s6,32(sp)
    800051da:	ec5e                	sd	s7,24(sp)
    800051dc:	e862                	sd	s8,16(sp)
    800051de:	a819                	j	800051f4 <piperead+0x8a>
      release(&pi->lock);
    800051e0:	8526                	mv	a0,s1
    800051e2:	ffffc097          	auipc	ra,0xffffc
    800051e6:	b0c080e7          	jalr	-1268(ra) # 80000cee <release>
      return -1;
    800051ea:	59fd                	li	s3,-1
    800051ec:	a895                	j	80005260 <piperead+0xf6>
    800051ee:	f05a                	sd	s6,32(sp)
    800051f0:	ec5e                	sd	s7,24(sp)
    800051f2:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800051f4:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800051f6:	faf40c13          	addi	s8,s0,-81
    800051fa:	4b85                	li	s7,1
    800051fc:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800051fe:	05505363          	blez	s5,80005244 <piperead+0xda>
    if(pi->nread == pi->nwrite)
    80005202:	2184a783          	lw	a5,536(s1)
    80005206:	21c4a703          	lw	a4,540(s1)
    8000520a:	02f70d63          	beq	a4,a5,80005244 <piperead+0xda>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000520e:	0017871b          	addiw	a4,a5,1
    80005212:	20e4ac23          	sw	a4,536(s1)
    80005216:	1ff7f793          	andi	a5,a5,511
    8000521a:	97a6                	add	a5,a5,s1
    8000521c:	0187c783          	lbu	a5,24(a5)
    80005220:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005224:	86de                	mv	a3,s7
    80005226:	8662                	mv	a2,s8
    80005228:	85ca                	mv	a1,s2
    8000522a:	050a3503          	ld	a0,80(s4)
    8000522e:	ffffc097          	auipc	ra,0xffffc
    80005232:	4e2080e7          	jalr	1250(ra) # 80001710 <copyout>
    80005236:	01650763          	beq	a0,s6,80005244 <piperead+0xda>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000523a:	2985                	addiw	s3,s3,1
    8000523c:	0905                	addi	s2,s2,1
    8000523e:	fd3a92e3          	bne	s5,s3,80005202 <piperead+0x98>
    80005242:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80005244:	21c48513          	addi	a0,s1,540
    80005248:	ffffd097          	auipc	ra,0xffffd
    8000524c:	304080e7          	jalr	772(ra) # 8000254c <wakeup>
  release(&pi->lock);
    80005250:	8526                	mv	a0,s1
    80005252:	ffffc097          	auipc	ra,0xffffc
    80005256:	a9c080e7          	jalr	-1380(ra) # 80000cee <release>
    8000525a:	7b02                	ld	s6,32(sp)
    8000525c:	6be2                	ld	s7,24(sp)
    8000525e:	6c42                	ld	s8,16(sp)
  return i;
}
    80005260:	854e                	mv	a0,s3
    80005262:	60e6                	ld	ra,88(sp)
    80005264:	6446                	ld	s0,80(sp)
    80005266:	64a6                	ld	s1,72(sp)
    80005268:	6906                	ld	s2,64(sp)
    8000526a:	79e2                	ld	s3,56(sp)
    8000526c:	7a42                	ld	s4,48(sp)
    8000526e:	7aa2                	ld	s5,40(sp)
    80005270:	6125                	addi	sp,sp,96
    80005272:	8082                	ret

0000000080005274 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80005274:	1141                	addi	sp,sp,-16
    80005276:	e406                	sd	ra,8(sp)
    80005278:	e022                	sd	s0,0(sp)
    8000527a:	0800                	addi	s0,sp,16
    8000527c:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000527e:	0035151b          	slliw	a0,a0,0x3
    80005282:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80005284:	8b89                	andi	a5,a5,2
    80005286:	c399                	beqz	a5,8000528c <flags2perm+0x18>
      perm |= PTE_W;
    80005288:	00456513          	ori	a0,a0,4
    return perm;
}
    8000528c:	60a2                	ld	ra,8(sp)
    8000528e:	6402                	ld	s0,0(sp)
    80005290:	0141                	addi	sp,sp,16
    80005292:	8082                	ret

0000000080005294 <exec>:

int
exec(char *path, char **argv)
{
    80005294:	de010113          	addi	sp,sp,-544
    80005298:	20113c23          	sd	ra,536(sp)
    8000529c:	20813823          	sd	s0,528(sp)
    800052a0:	20913423          	sd	s1,520(sp)
    800052a4:	21213023          	sd	s2,512(sp)
    800052a8:	1400                	addi	s0,sp,544
    800052aa:	892a                	mv	s2,a0
    800052ac:	dea43823          	sd	a0,-528(s0)
    800052b0:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800052b4:	ffffd097          	auipc	ra,0xffffd
    800052b8:	a52080e7          	jalr	-1454(ra) # 80001d06 <myproc>
    800052bc:	84aa                	mv	s1,a0

  begin_op();
    800052be:	fffff097          	auipc	ra,0xfffff
    800052c2:	3fc080e7          	jalr	1020(ra) # 800046ba <begin_op>

  if((ip = namei(path)) == 0){
    800052c6:	854a                	mv	a0,s2
    800052c8:	fffff097          	auipc	ra,0xfffff
    800052cc:	1ec080e7          	jalr	492(ra) # 800044b4 <namei>
    800052d0:	c525                	beqz	a0,80005338 <exec+0xa4>
    800052d2:	fbd2                	sd	s4,496(sp)
    800052d4:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800052d6:	fffff097          	auipc	ra,0xfffff
    800052da:	9fa080e7          	jalr	-1542(ra) # 80003cd0 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800052de:	04000713          	li	a4,64
    800052e2:	4681                	li	a3,0
    800052e4:	e5040613          	addi	a2,s0,-432
    800052e8:	4581                	li	a1,0
    800052ea:	8552                	mv	a0,s4
    800052ec:	fffff097          	auipc	ra,0xfffff
    800052f0:	ca0080e7          	jalr	-864(ra) # 80003f8c <readi>
    800052f4:	04000793          	li	a5,64
    800052f8:	00f51a63          	bne	a0,a5,8000530c <exec+0x78>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800052fc:	e5042703          	lw	a4,-432(s0)
    80005300:	464c47b7          	lui	a5,0x464c4
    80005304:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005308:	02f70e63          	beq	a4,a5,80005344 <exec+0xb0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000530c:	8552                	mv	a0,s4
    8000530e:	fffff097          	auipc	ra,0xfffff
    80005312:	c28080e7          	jalr	-984(ra) # 80003f36 <iunlockput>
    end_op();
    80005316:	fffff097          	auipc	ra,0xfffff
    8000531a:	41e080e7          	jalr	1054(ra) # 80004734 <end_op>
  }
  return -1;
    8000531e:	557d                	li	a0,-1
    80005320:	7a5e                	ld	s4,496(sp)
}
    80005322:	21813083          	ld	ra,536(sp)
    80005326:	21013403          	ld	s0,528(sp)
    8000532a:	20813483          	ld	s1,520(sp)
    8000532e:	20013903          	ld	s2,512(sp)
    80005332:	22010113          	addi	sp,sp,544
    80005336:	8082                	ret
    end_op();
    80005338:	fffff097          	auipc	ra,0xfffff
    8000533c:	3fc080e7          	jalr	1020(ra) # 80004734 <end_op>
    return -1;
    80005340:	557d                	li	a0,-1
    80005342:	b7c5                	j	80005322 <exec+0x8e>
    80005344:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80005346:	8526                	mv	a0,s1
    80005348:	ffffd097          	auipc	ra,0xffffd
    8000534c:	a82080e7          	jalr	-1406(ra) # 80001dca <proc_pagetable>
    80005350:	8b2a                	mv	s6,a0
    80005352:	2c050163          	beqz	a0,80005614 <exec+0x380>
    80005356:	ffce                	sd	s3,504(sp)
    80005358:	f7d6                	sd	s5,488(sp)
    8000535a:	efde                	sd	s7,472(sp)
    8000535c:	ebe2                	sd	s8,464(sp)
    8000535e:	e7e6                	sd	s9,456(sp)
    80005360:	e3ea                	sd	s10,448(sp)
    80005362:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005364:	e7042683          	lw	a3,-400(s0)
    80005368:	e8845783          	lhu	a5,-376(s0)
    8000536c:	10078363          	beqz	a5,80005472 <exec+0x1de>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005370:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005372:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005374:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80005378:	6c85                	lui	s9,0x1
    8000537a:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000537e:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80005382:	6a85                	lui	s5,0x1
    80005384:	a0b5                	j	800053f0 <exec+0x15c>
      panic("loadseg: address should exist");
    80005386:	00003517          	auipc	a0,0x3
    8000538a:	31a50513          	addi	a0,a0,794 # 800086a0 <etext+0x6a0>
    8000538e:	ffffb097          	auipc	ra,0xffffb
    80005392:	1d2080e7          	jalr	466(ra) # 80000560 <panic>
    if(sz - i < PGSIZE)
    80005396:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80005398:	874a                	mv	a4,s2
    8000539a:	009c06bb          	addw	a3,s8,s1
    8000539e:	4581                	li	a1,0
    800053a0:	8552                	mv	a0,s4
    800053a2:	fffff097          	auipc	ra,0xfffff
    800053a6:	bea080e7          	jalr	-1046(ra) # 80003f8c <readi>
    800053aa:	26a91963          	bne	s2,a0,8000561c <exec+0x388>
  for(i = 0; i < sz; i += PGSIZE){
    800053ae:	009a84bb          	addw	s1,s5,s1
    800053b2:	0334f463          	bgeu	s1,s3,800053da <exec+0x146>
    pa = walkaddr(pagetable, va + i);
    800053b6:	02049593          	slli	a1,s1,0x20
    800053ba:	9181                	srli	a1,a1,0x20
    800053bc:	95de                	add	a1,a1,s7
    800053be:	855a                	mv	a0,s6
    800053c0:	ffffc097          	auipc	ra,0xffffc
    800053c4:	d18080e7          	jalr	-744(ra) # 800010d8 <walkaddr>
    800053c8:	862a                	mv	a2,a0
    if(pa == 0)
    800053ca:	dd55                	beqz	a0,80005386 <exec+0xf2>
    if(sz - i < PGSIZE)
    800053cc:	409987bb          	subw	a5,s3,s1
    800053d0:	893e                	mv	s2,a5
    800053d2:	fcfcf2e3          	bgeu	s9,a5,80005396 <exec+0x102>
    800053d6:	8956                	mv	s2,s5
    800053d8:	bf7d                	j	80005396 <exec+0x102>
    sz = sz1;
    800053da:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800053de:	2d05                	addiw	s10,s10,1
    800053e0:	e0843783          	ld	a5,-504(s0)
    800053e4:	0387869b          	addiw	a3,a5,56
    800053e8:	e8845783          	lhu	a5,-376(s0)
    800053ec:	08fd5463          	bge	s10,a5,80005474 <exec+0x1e0>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800053f0:	e0d43423          	sd	a3,-504(s0)
    800053f4:	876e                	mv	a4,s11
    800053f6:	e1840613          	addi	a2,s0,-488
    800053fa:	4581                	li	a1,0
    800053fc:	8552                	mv	a0,s4
    800053fe:	fffff097          	auipc	ra,0xfffff
    80005402:	b8e080e7          	jalr	-1138(ra) # 80003f8c <readi>
    80005406:	21b51963          	bne	a0,s11,80005618 <exec+0x384>
    if(ph.type != ELF_PROG_LOAD)
    8000540a:	e1842783          	lw	a5,-488(s0)
    8000540e:	4705                	li	a4,1
    80005410:	fce797e3          	bne	a5,a4,800053de <exec+0x14a>
    if(ph.memsz < ph.filesz)
    80005414:	e4043483          	ld	s1,-448(s0)
    80005418:	e3843783          	ld	a5,-456(s0)
    8000541c:	22f4e063          	bltu	s1,a5,8000563c <exec+0x3a8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005420:	e2843783          	ld	a5,-472(s0)
    80005424:	94be                	add	s1,s1,a5
    80005426:	20f4ee63          	bltu	s1,a5,80005642 <exec+0x3ae>
    if(ph.vaddr % PGSIZE != 0)
    8000542a:	de843703          	ld	a4,-536(s0)
    8000542e:	8ff9                	and	a5,a5,a4
    80005430:	20079c63          	bnez	a5,80005648 <exec+0x3b4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80005434:	e1c42503          	lw	a0,-484(s0)
    80005438:	00000097          	auipc	ra,0x0
    8000543c:	e3c080e7          	jalr	-452(ra) # 80005274 <flags2perm>
    80005440:	86aa                	mv	a3,a0
    80005442:	8626                	mv	a2,s1
    80005444:	85ca                	mv	a1,s2
    80005446:	855a                	mv	a0,s6
    80005448:	ffffc097          	auipc	ra,0xffffc
    8000544c:	054080e7          	jalr	84(ra) # 8000149c <uvmalloc>
    80005450:	dea43c23          	sd	a0,-520(s0)
    80005454:	1e050d63          	beqz	a0,8000564e <exec+0x3ba>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005458:	e2843b83          	ld	s7,-472(s0)
    8000545c:	e2042c03          	lw	s8,-480(s0)
    80005460:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005464:	00098463          	beqz	s3,8000546c <exec+0x1d8>
    80005468:	4481                	li	s1,0
    8000546a:	b7b1                	j	800053b6 <exec+0x122>
    sz = sz1;
    8000546c:	df843903          	ld	s2,-520(s0)
    80005470:	b7bd                	j	800053de <exec+0x14a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005472:	4901                	li	s2,0
  iunlockput(ip);
    80005474:	8552                	mv	a0,s4
    80005476:	fffff097          	auipc	ra,0xfffff
    8000547a:	ac0080e7          	jalr	-1344(ra) # 80003f36 <iunlockput>
  end_op();
    8000547e:	fffff097          	auipc	ra,0xfffff
    80005482:	2b6080e7          	jalr	694(ra) # 80004734 <end_op>
  p = myproc();
    80005486:	ffffd097          	auipc	ra,0xffffd
    8000548a:	880080e7          	jalr	-1920(ra) # 80001d06 <myproc>
    8000548e:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80005490:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80005494:	6985                	lui	s3,0x1
    80005496:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80005498:	99ca                	add	s3,s3,s2
    8000549a:	77fd                	lui	a5,0xfffff
    8000549c:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800054a0:	4691                	li	a3,4
    800054a2:	6609                	lui	a2,0x2
    800054a4:	964e                	add	a2,a2,s3
    800054a6:	85ce                	mv	a1,s3
    800054a8:	855a                	mv	a0,s6
    800054aa:	ffffc097          	auipc	ra,0xffffc
    800054ae:	ff2080e7          	jalr	-14(ra) # 8000149c <uvmalloc>
    800054b2:	8a2a                	mv	s4,a0
    800054b4:	e115                	bnez	a0,800054d8 <exec+0x244>
    proc_freepagetable(pagetable, sz);
    800054b6:	85ce                	mv	a1,s3
    800054b8:	855a                	mv	a0,s6
    800054ba:	ffffd097          	auipc	ra,0xffffd
    800054be:	9ac080e7          	jalr	-1620(ra) # 80001e66 <proc_freepagetable>
  return -1;
    800054c2:	557d                	li	a0,-1
    800054c4:	79fe                	ld	s3,504(sp)
    800054c6:	7a5e                	ld	s4,496(sp)
    800054c8:	7abe                	ld	s5,488(sp)
    800054ca:	7b1e                	ld	s6,480(sp)
    800054cc:	6bfe                	ld	s7,472(sp)
    800054ce:	6c5e                	ld	s8,464(sp)
    800054d0:	6cbe                	ld	s9,456(sp)
    800054d2:	6d1e                	ld	s10,448(sp)
    800054d4:	7dfa                	ld	s11,440(sp)
    800054d6:	b5b1                	j	80005322 <exec+0x8e>
  uvmclear(pagetable, sz-2*PGSIZE);
    800054d8:	75f9                	lui	a1,0xffffe
    800054da:	95aa                	add	a1,a1,a0
    800054dc:	855a                	mv	a0,s6
    800054de:	ffffc097          	auipc	ra,0xffffc
    800054e2:	200080e7          	jalr	512(ra) # 800016de <uvmclear>
  stackbase = sp - PGSIZE;
    800054e6:	7bfd                	lui	s7,0xfffff
    800054e8:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    800054ea:	e0043783          	ld	a5,-512(s0)
    800054ee:	6388                	ld	a0,0(a5)
  sp = sz;
    800054f0:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    800054f2:	4481                	li	s1,0
    ustack[argc] = sp;
    800054f4:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    800054f8:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    800054fc:	c135                	beqz	a0,80005560 <exec+0x2cc>
    sp -= strlen(argv[argc]) + 1;
    800054fe:	ffffc097          	auipc	ra,0xffffc
    80005502:	9c4080e7          	jalr	-1596(ra) # 80000ec2 <strlen>
    80005506:	0015079b          	addiw	a5,a0,1
    8000550a:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000550e:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80005512:	15796163          	bltu	s2,s7,80005654 <exec+0x3c0>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005516:	e0043d83          	ld	s11,-512(s0)
    8000551a:	000db983          	ld	s3,0(s11)
    8000551e:	854e                	mv	a0,s3
    80005520:	ffffc097          	auipc	ra,0xffffc
    80005524:	9a2080e7          	jalr	-1630(ra) # 80000ec2 <strlen>
    80005528:	0015069b          	addiw	a3,a0,1
    8000552c:	864e                	mv	a2,s3
    8000552e:	85ca                	mv	a1,s2
    80005530:	855a                	mv	a0,s6
    80005532:	ffffc097          	auipc	ra,0xffffc
    80005536:	1de080e7          	jalr	478(ra) # 80001710 <copyout>
    8000553a:	10054f63          	bltz	a0,80005658 <exec+0x3c4>
    ustack[argc] = sp;
    8000553e:	00349793          	slli	a5,s1,0x3
    80005542:	97e6                	add	a5,a5,s9
    80005544:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffdcf70>
  for(argc = 0; argv[argc]; argc++) {
    80005548:	0485                	addi	s1,s1,1
    8000554a:	008d8793          	addi	a5,s11,8
    8000554e:	e0f43023          	sd	a5,-512(s0)
    80005552:	008db503          	ld	a0,8(s11)
    80005556:	c509                	beqz	a0,80005560 <exec+0x2cc>
    if(argc >= MAXARG)
    80005558:	fb8493e3          	bne	s1,s8,800054fe <exec+0x26a>
  sz = sz1;
    8000555c:	89d2                	mv	s3,s4
    8000555e:	bfa1                	j	800054b6 <exec+0x222>
  ustack[argc] = 0;
    80005560:	00349793          	slli	a5,s1,0x3
    80005564:	f9078793          	addi	a5,a5,-112
    80005568:	97a2                	add	a5,a5,s0
    8000556a:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000556e:	00148693          	addi	a3,s1,1
    80005572:	068e                	slli	a3,a3,0x3
    80005574:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005578:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    8000557c:	89d2                	mv	s3,s4
  if(sp < stackbase)
    8000557e:	f3796ce3          	bltu	s2,s7,800054b6 <exec+0x222>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005582:	e9040613          	addi	a2,s0,-368
    80005586:	85ca                	mv	a1,s2
    80005588:	855a                	mv	a0,s6
    8000558a:	ffffc097          	auipc	ra,0xffffc
    8000558e:	186080e7          	jalr	390(ra) # 80001710 <copyout>
    80005592:	f20542e3          	bltz	a0,800054b6 <exec+0x222>
  p->trapframe->a1 = sp;
    80005596:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    8000559a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000559e:	df043783          	ld	a5,-528(s0)
    800055a2:	0007c703          	lbu	a4,0(a5)
    800055a6:	cf11                	beqz	a4,800055c2 <exec+0x32e>
    800055a8:	0785                	addi	a5,a5,1
    if(*s == '/')
    800055aa:	02f00693          	li	a3,47
    800055ae:	a029                	j	800055b8 <exec+0x324>
  for(last=s=path; *s; s++)
    800055b0:	0785                	addi	a5,a5,1
    800055b2:	fff7c703          	lbu	a4,-1(a5)
    800055b6:	c711                	beqz	a4,800055c2 <exec+0x32e>
    if(*s == '/')
    800055b8:	fed71ce3          	bne	a4,a3,800055b0 <exec+0x31c>
      last = s+1;
    800055bc:	def43823          	sd	a5,-528(s0)
    800055c0:	bfc5                	j	800055b0 <exec+0x31c>
  safestrcpy(p->name, last, sizeof(p->name));
    800055c2:	4641                	li	a2,16
    800055c4:	df043583          	ld	a1,-528(s0)
    800055c8:	158a8513          	addi	a0,s5,344
    800055cc:	ffffc097          	auipc	ra,0xffffc
    800055d0:	8c0080e7          	jalr	-1856(ra) # 80000e8c <safestrcpy>
  oldpagetable = p->pagetable;
    800055d4:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800055d8:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800055dc:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800055e0:	058ab783          	ld	a5,88(s5)
    800055e4:	e6843703          	ld	a4,-408(s0)
    800055e8:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800055ea:	058ab783          	ld	a5,88(s5)
    800055ee:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800055f2:	85ea                	mv	a1,s10
    800055f4:	ffffd097          	auipc	ra,0xffffd
    800055f8:	872080e7          	jalr	-1934(ra) # 80001e66 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800055fc:	0004851b          	sext.w	a0,s1
    80005600:	79fe                	ld	s3,504(sp)
    80005602:	7a5e                	ld	s4,496(sp)
    80005604:	7abe                	ld	s5,488(sp)
    80005606:	7b1e                	ld	s6,480(sp)
    80005608:	6bfe                	ld	s7,472(sp)
    8000560a:	6c5e                	ld	s8,464(sp)
    8000560c:	6cbe                	ld	s9,456(sp)
    8000560e:	6d1e                	ld	s10,448(sp)
    80005610:	7dfa                	ld	s11,440(sp)
    80005612:	bb01                	j	80005322 <exec+0x8e>
    80005614:	7b1e                	ld	s6,480(sp)
    80005616:	b9dd                	j	8000530c <exec+0x78>
    80005618:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    8000561c:	df843583          	ld	a1,-520(s0)
    80005620:	855a                	mv	a0,s6
    80005622:	ffffd097          	auipc	ra,0xffffd
    80005626:	844080e7          	jalr	-1980(ra) # 80001e66 <proc_freepagetable>
  if(ip){
    8000562a:	79fe                	ld	s3,504(sp)
    8000562c:	7abe                	ld	s5,488(sp)
    8000562e:	7b1e                	ld	s6,480(sp)
    80005630:	6bfe                	ld	s7,472(sp)
    80005632:	6c5e                	ld	s8,464(sp)
    80005634:	6cbe                	ld	s9,456(sp)
    80005636:	6d1e                	ld	s10,448(sp)
    80005638:	7dfa                	ld	s11,440(sp)
    8000563a:	b9c9                	j	8000530c <exec+0x78>
    8000563c:	df243c23          	sd	s2,-520(s0)
    80005640:	bff1                	j	8000561c <exec+0x388>
    80005642:	df243c23          	sd	s2,-520(s0)
    80005646:	bfd9                	j	8000561c <exec+0x388>
    80005648:	df243c23          	sd	s2,-520(s0)
    8000564c:	bfc1                	j	8000561c <exec+0x388>
    8000564e:	df243c23          	sd	s2,-520(s0)
    80005652:	b7e9                	j	8000561c <exec+0x388>
  sz = sz1;
    80005654:	89d2                	mv	s3,s4
    80005656:	b585                	j	800054b6 <exec+0x222>
    80005658:	89d2                	mv	s3,s4
    8000565a:	bdb1                	j	800054b6 <exec+0x222>

000000008000565c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000565c:	7179                	addi	sp,sp,-48
    8000565e:	f406                	sd	ra,40(sp)
    80005660:	f022                	sd	s0,32(sp)
    80005662:	ec26                	sd	s1,24(sp)
    80005664:	e84a                	sd	s2,16(sp)
    80005666:	1800                	addi	s0,sp,48
    80005668:	892e                	mv	s2,a1
    8000566a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000566c:	fdc40593          	addi	a1,s0,-36
    80005670:	ffffe097          	auipc	ra,0xffffe
    80005674:	a58080e7          	jalr	-1448(ra) # 800030c8 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005678:	fdc42703          	lw	a4,-36(s0)
    8000567c:	47bd                	li	a5,15
    8000567e:	02e7eb63          	bltu	a5,a4,800056b4 <argfd+0x58>
    80005682:	ffffc097          	auipc	ra,0xffffc
    80005686:	684080e7          	jalr	1668(ra) # 80001d06 <myproc>
    8000568a:	fdc42703          	lw	a4,-36(s0)
    8000568e:	01a70793          	addi	a5,a4,26
    80005692:	078e                	slli	a5,a5,0x3
    80005694:	953e                	add	a0,a0,a5
    80005696:	611c                	ld	a5,0(a0)
    80005698:	c385                	beqz	a5,800056b8 <argfd+0x5c>
    return -1;
  if(pfd)
    8000569a:	00090463          	beqz	s2,800056a2 <argfd+0x46>
    *pfd = fd;
    8000569e:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800056a2:	4501                	li	a0,0
  if(pf)
    800056a4:	c091                	beqz	s1,800056a8 <argfd+0x4c>
    *pf = f;
    800056a6:	e09c                	sd	a5,0(s1)
}
    800056a8:	70a2                	ld	ra,40(sp)
    800056aa:	7402                	ld	s0,32(sp)
    800056ac:	64e2                	ld	s1,24(sp)
    800056ae:	6942                	ld	s2,16(sp)
    800056b0:	6145                	addi	sp,sp,48
    800056b2:	8082                	ret
    return -1;
    800056b4:	557d                	li	a0,-1
    800056b6:	bfcd                	j	800056a8 <argfd+0x4c>
    800056b8:	557d                	li	a0,-1
    800056ba:	b7fd                	j	800056a8 <argfd+0x4c>

00000000800056bc <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800056bc:	1101                	addi	sp,sp,-32
    800056be:	ec06                	sd	ra,24(sp)
    800056c0:	e822                	sd	s0,16(sp)
    800056c2:	e426                	sd	s1,8(sp)
    800056c4:	1000                	addi	s0,sp,32
    800056c6:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800056c8:	ffffc097          	auipc	ra,0xffffc
    800056cc:	63e080e7          	jalr	1598(ra) # 80001d06 <myproc>
    800056d0:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800056d2:	0d050793          	addi	a5,a0,208
    800056d6:	4501                	li	a0,0
    800056d8:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800056da:	6398                	ld	a4,0(a5)
    800056dc:	cb19                	beqz	a4,800056f2 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800056de:	2505                	addiw	a0,a0,1
    800056e0:	07a1                	addi	a5,a5,8
    800056e2:	fed51ce3          	bne	a0,a3,800056da <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800056e6:	557d                	li	a0,-1
}
    800056e8:	60e2                	ld	ra,24(sp)
    800056ea:	6442                	ld	s0,16(sp)
    800056ec:	64a2                	ld	s1,8(sp)
    800056ee:	6105                	addi	sp,sp,32
    800056f0:	8082                	ret
      p->ofile[fd] = f;
    800056f2:	01a50793          	addi	a5,a0,26
    800056f6:	078e                	slli	a5,a5,0x3
    800056f8:	963e                	add	a2,a2,a5
    800056fa:	e204                	sd	s1,0(a2)
      return fd;
    800056fc:	b7f5                	j	800056e8 <fdalloc+0x2c>

00000000800056fe <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800056fe:	715d                	addi	sp,sp,-80
    80005700:	e486                	sd	ra,72(sp)
    80005702:	e0a2                	sd	s0,64(sp)
    80005704:	fc26                	sd	s1,56(sp)
    80005706:	f84a                	sd	s2,48(sp)
    80005708:	f44e                	sd	s3,40(sp)
    8000570a:	ec56                	sd	s5,24(sp)
    8000570c:	e85a                	sd	s6,16(sp)
    8000570e:	0880                	addi	s0,sp,80
    80005710:	8b2e                	mv	s6,a1
    80005712:	89b2                	mv	s3,a2
    80005714:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005716:	fb040593          	addi	a1,s0,-80
    8000571a:	fffff097          	auipc	ra,0xfffff
    8000571e:	db8080e7          	jalr	-584(ra) # 800044d2 <nameiparent>
    80005722:	84aa                	mv	s1,a0
    80005724:	14050e63          	beqz	a0,80005880 <create+0x182>
    return 0;

  ilock(dp);
    80005728:	ffffe097          	auipc	ra,0xffffe
    8000572c:	5a8080e7          	jalr	1448(ra) # 80003cd0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005730:	4601                	li	a2,0
    80005732:	fb040593          	addi	a1,s0,-80
    80005736:	8526                	mv	a0,s1
    80005738:	fffff097          	auipc	ra,0xfffff
    8000573c:	a94080e7          	jalr	-1388(ra) # 800041cc <dirlookup>
    80005740:	8aaa                	mv	s5,a0
    80005742:	c539                	beqz	a0,80005790 <create+0x92>
    iunlockput(dp);
    80005744:	8526                	mv	a0,s1
    80005746:	ffffe097          	auipc	ra,0xffffe
    8000574a:	7f0080e7          	jalr	2032(ra) # 80003f36 <iunlockput>
    ilock(ip);
    8000574e:	8556                	mv	a0,s5
    80005750:	ffffe097          	auipc	ra,0xffffe
    80005754:	580080e7          	jalr	1408(ra) # 80003cd0 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005758:	4789                	li	a5,2
    8000575a:	02fb1463          	bne	s6,a5,80005782 <create+0x84>
    8000575e:	044ad783          	lhu	a5,68(s5)
    80005762:	37f9                	addiw	a5,a5,-2
    80005764:	17c2                	slli	a5,a5,0x30
    80005766:	93c1                	srli	a5,a5,0x30
    80005768:	4705                	li	a4,1
    8000576a:	00f76c63          	bltu	a4,a5,80005782 <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000576e:	8556                	mv	a0,s5
    80005770:	60a6                	ld	ra,72(sp)
    80005772:	6406                	ld	s0,64(sp)
    80005774:	74e2                	ld	s1,56(sp)
    80005776:	7942                	ld	s2,48(sp)
    80005778:	79a2                	ld	s3,40(sp)
    8000577a:	6ae2                	ld	s5,24(sp)
    8000577c:	6b42                	ld	s6,16(sp)
    8000577e:	6161                	addi	sp,sp,80
    80005780:	8082                	ret
    iunlockput(ip);
    80005782:	8556                	mv	a0,s5
    80005784:	ffffe097          	auipc	ra,0xffffe
    80005788:	7b2080e7          	jalr	1970(ra) # 80003f36 <iunlockput>
    return 0;
    8000578c:	4a81                	li	s5,0
    8000578e:	b7c5                	j	8000576e <create+0x70>
    80005790:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80005792:	85da                	mv	a1,s6
    80005794:	4088                	lw	a0,0(s1)
    80005796:	ffffe097          	auipc	ra,0xffffe
    8000579a:	396080e7          	jalr	918(ra) # 80003b2c <ialloc>
    8000579e:	8a2a                	mv	s4,a0
    800057a0:	c531                	beqz	a0,800057ec <create+0xee>
  ilock(ip);
    800057a2:	ffffe097          	auipc	ra,0xffffe
    800057a6:	52e080e7          	jalr	1326(ra) # 80003cd0 <ilock>
  ip->major = major;
    800057aa:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800057ae:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800057b2:	4905                	li	s2,1
    800057b4:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800057b8:	8552                	mv	a0,s4
    800057ba:	ffffe097          	auipc	ra,0xffffe
    800057be:	44a080e7          	jalr	1098(ra) # 80003c04 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800057c2:	032b0d63          	beq	s6,s2,800057fc <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800057c6:	004a2603          	lw	a2,4(s4)
    800057ca:	fb040593          	addi	a1,s0,-80
    800057ce:	8526                	mv	a0,s1
    800057d0:	fffff097          	auipc	ra,0xfffff
    800057d4:	c22080e7          	jalr	-990(ra) # 800043f2 <dirlink>
    800057d8:	08054163          	bltz	a0,8000585a <create+0x15c>
  iunlockput(dp);
    800057dc:	8526                	mv	a0,s1
    800057de:	ffffe097          	auipc	ra,0xffffe
    800057e2:	758080e7          	jalr	1880(ra) # 80003f36 <iunlockput>
  return ip;
    800057e6:	8ad2                	mv	s5,s4
    800057e8:	7a02                	ld	s4,32(sp)
    800057ea:	b751                	j	8000576e <create+0x70>
    iunlockput(dp);
    800057ec:	8526                	mv	a0,s1
    800057ee:	ffffe097          	auipc	ra,0xffffe
    800057f2:	748080e7          	jalr	1864(ra) # 80003f36 <iunlockput>
    return 0;
    800057f6:	8ad2                	mv	s5,s4
    800057f8:	7a02                	ld	s4,32(sp)
    800057fa:	bf95                	j	8000576e <create+0x70>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800057fc:	004a2603          	lw	a2,4(s4)
    80005800:	00003597          	auipc	a1,0x3
    80005804:	ec058593          	addi	a1,a1,-320 # 800086c0 <etext+0x6c0>
    80005808:	8552                	mv	a0,s4
    8000580a:	fffff097          	auipc	ra,0xfffff
    8000580e:	be8080e7          	jalr	-1048(ra) # 800043f2 <dirlink>
    80005812:	04054463          	bltz	a0,8000585a <create+0x15c>
    80005816:	40d0                	lw	a2,4(s1)
    80005818:	00003597          	auipc	a1,0x3
    8000581c:	eb058593          	addi	a1,a1,-336 # 800086c8 <etext+0x6c8>
    80005820:	8552                	mv	a0,s4
    80005822:	fffff097          	auipc	ra,0xfffff
    80005826:	bd0080e7          	jalr	-1072(ra) # 800043f2 <dirlink>
    8000582a:	02054863          	bltz	a0,8000585a <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    8000582e:	004a2603          	lw	a2,4(s4)
    80005832:	fb040593          	addi	a1,s0,-80
    80005836:	8526                	mv	a0,s1
    80005838:	fffff097          	auipc	ra,0xfffff
    8000583c:	bba080e7          	jalr	-1094(ra) # 800043f2 <dirlink>
    80005840:	00054d63          	bltz	a0,8000585a <create+0x15c>
    dp->nlink++;  // for ".."
    80005844:	04a4d783          	lhu	a5,74(s1)
    80005848:	2785                	addiw	a5,a5,1
    8000584a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000584e:	8526                	mv	a0,s1
    80005850:	ffffe097          	auipc	ra,0xffffe
    80005854:	3b4080e7          	jalr	948(ra) # 80003c04 <iupdate>
    80005858:	b751                	j	800057dc <create+0xde>
  ip->nlink = 0;
    8000585a:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000585e:	8552                	mv	a0,s4
    80005860:	ffffe097          	auipc	ra,0xffffe
    80005864:	3a4080e7          	jalr	932(ra) # 80003c04 <iupdate>
  iunlockput(ip);
    80005868:	8552                	mv	a0,s4
    8000586a:	ffffe097          	auipc	ra,0xffffe
    8000586e:	6cc080e7          	jalr	1740(ra) # 80003f36 <iunlockput>
  iunlockput(dp);
    80005872:	8526                	mv	a0,s1
    80005874:	ffffe097          	auipc	ra,0xffffe
    80005878:	6c2080e7          	jalr	1730(ra) # 80003f36 <iunlockput>
  return 0;
    8000587c:	7a02                	ld	s4,32(sp)
    8000587e:	bdc5                	j	8000576e <create+0x70>
    return 0;
    80005880:	8aaa                	mv	s5,a0
    80005882:	b5f5                	j	8000576e <create+0x70>

0000000080005884 <sys_dup>:
{
    80005884:	7179                	addi	sp,sp,-48
    80005886:	f406                	sd	ra,40(sp)
    80005888:	f022                	sd	s0,32(sp)
    8000588a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000588c:	fd840613          	addi	a2,s0,-40
    80005890:	4581                	li	a1,0
    80005892:	4501                	li	a0,0
    80005894:	00000097          	auipc	ra,0x0
    80005898:	dc8080e7          	jalr	-568(ra) # 8000565c <argfd>
    return -1;
    8000589c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000589e:	02054763          	bltz	a0,800058cc <sys_dup+0x48>
    800058a2:	ec26                	sd	s1,24(sp)
    800058a4:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800058a6:	fd843903          	ld	s2,-40(s0)
    800058aa:	854a                	mv	a0,s2
    800058ac:	00000097          	auipc	ra,0x0
    800058b0:	e10080e7          	jalr	-496(ra) # 800056bc <fdalloc>
    800058b4:	84aa                	mv	s1,a0
    return -1;
    800058b6:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800058b8:	00054f63          	bltz	a0,800058d6 <sys_dup+0x52>
  filedup(f);
    800058bc:	854a                	mv	a0,s2
    800058be:	fffff097          	auipc	ra,0xfffff
    800058c2:	27a080e7          	jalr	634(ra) # 80004b38 <filedup>
  return fd;
    800058c6:	87a6                	mv	a5,s1
    800058c8:	64e2                	ld	s1,24(sp)
    800058ca:	6942                	ld	s2,16(sp)
}
    800058cc:	853e                	mv	a0,a5
    800058ce:	70a2                	ld	ra,40(sp)
    800058d0:	7402                	ld	s0,32(sp)
    800058d2:	6145                	addi	sp,sp,48
    800058d4:	8082                	ret
    800058d6:	64e2                	ld	s1,24(sp)
    800058d8:	6942                	ld	s2,16(sp)
    800058da:	bfcd                	j	800058cc <sys_dup+0x48>

00000000800058dc <sys_read>:
{
    800058dc:	7179                	addi	sp,sp,-48
    800058de:	f406                	sd	ra,40(sp)
    800058e0:	f022                	sd	s0,32(sp)
    800058e2:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800058e4:	fd840593          	addi	a1,s0,-40
    800058e8:	4505                	li	a0,1
    800058ea:	ffffd097          	auipc	ra,0xffffd
    800058ee:	7fe080e7          	jalr	2046(ra) # 800030e8 <argaddr>
  argint(2, &n);
    800058f2:	fe440593          	addi	a1,s0,-28
    800058f6:	4509                	li	a0,2
    800058f8:	ffffd097          	auipc	ra,0xffffd
    800058fc:	7d0080e7          	jalr	2000(ra) # 800030c8 <argint>
  if(argfd(0, 0, &f) < 0)
    80005900:	fe840613          	addi	a2,s0,-24
    80005904:	4581                	li	a1,0
    80005906:	4501                	li	a0,0
    80005908:	00000097          	auipc	ra,0x0
    8000590c:	d54080e7          	jalr	-684(ra) # 8000565c <argfd>
    80005910:	87aa                	mv	a5,a0
    return -1;
    80005912:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005914:	0007cc63          	bltz	a5,8000592c <sys_read+0x50>
  return fileread(f, p, n);
    80005918:	fe442603          	lw	a2,-28(s0)
    8000591c:	fd843583          	ld	a1,-40(s0)
    80005920:	fe843503          	ld	a0,-24(s0)
    80005924:	fffff097          	auipc	ra,0xfffff
    80005928:	3ba080e7          	jalr	954(ra) # 80004cde <fileread>
}
    8000592c:	70a2                	ld	ra,40(sp)
    8000592e:	7402                	ld	s0,32(sp)
    80005930:	6145                	addi	sp,sp,48
    80005932:	8082                	ret

0000000080005934 <sys_write>:
{
    80005934:	7179                	addi	sp,sp,-48
    80005936:	f406                	sd	ra,40(sp)
    80005938:	f022                	sd	s0,32(sp)
    8000593a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000593c:	fd840593          	addi	a1,s0,-40
    80005940:	4505                	li	a0,1
    80005942:	ffffd097          	auipc	ra,0xffffd
    80005946:	7a6080e7          	jalr	1958(ra) # 800030e8 <argaddr>
  argint(2, &n);
    8000594a:	fe440593          	addi	a1,s0,-28
    8000594e:	4509                	li	a0,2
    80005950:	ffffd097          	auipc	ra,0xffffd
    80005954:	778080e7          	jalr	1912(ra) # 800030c8 <argint>
  if(argfd(0, 0, &f) < 0)
    80005958:	fe840613          	addi	a2,s0,-24
    8000595c:	4581                	li	a1,0
    8000595e:	4501                	li	a0,0
    80005960:	00000097          	auipc	ra,0x0
    80005964:	cfc080e7          	jalr	-772(ra) # 8000565c <argfd>
    80005968:	87aa                	mv	a5,a0
    return -1;
    8000596a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000596c:	0007cc63          	bltz	a5,80005984 <sys_write+0x50>
  return filewrite(f, p, n);
    80005970:	fe442603          	lw	a2,-28(s0)
    80005974:	fd843583          	ld	a1,-40(s0)
    80005978:	fe843503          	ld	a0,-24(s0)
    8000597c:	fffff097          	auipc	ra,0xfffff
    80005980:	434080e7          	jalr	1076(ra) # 80004db0 <filewrite>
}
    80005984:	70a2                	ld	ra,40(sp)
    80005986:	7402                	ld	s0,32(sp)
    80005988:	6145                	addi	sp,sp,48
    8000598a:	8082                	ret

000000008000598c <sys_close>:
{
    8000598c:	1101                	addi	sp,sp,-32
    8000598e:	ec06                	sd	ra,24(sp)
    80005990:	e822                	sd	s0,16(sp)
    80005992:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005994:	fe040613          	addi	a2,s0,-32
    80005998:	fec40593          	addi	a1,s0,-20
    8000599c:	4501                	li	a0,0
    8000599e:	00000097          	auipc	ra,0x0
    800059a2:	cbe080e7          	jalr	-834(ra) # 8000565c <argfd>
    return -1;
    800059a6:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800059a8:	02054463          	bltz	a0,800059d0 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800059ac:	ffffc097          	auipc	ra,0xffffc
    800059b0:	35a080e7          	jalr	858(ra) # 80001d06 <myproc>
    800059b4:	fec42783          	lw	a5,-20(s0)
    800059b8:	07e9                	addi	a5,a5,26
    800059ba:	078e                	slli	a5,a5,0x3
    800059bc:	953e                	add	a0,a0,a5
    800059be:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800059c2:	fe043503          	ld	a0,-32(s0)
    800059c6:	fffff097          	auipc	ra,0xfffff
    800059ca:	1c4080e7          	jalr	452(ra) # 80004b8a <fileclose>
  return 0;
    800059ce:	4781                	li	a5,0
}
    800059d0:	853e                	mv	a0,a5
    800059d2:	60e2                	ld	ra,24(sp)
    800059d4:	6442                	ld	s0,16(sp)
    800059d6:	6105                	addi	sp,sp,32
    800059d8:	8082                	ret

00000000800059da <sys_fstat>:
{
    800059da:	1101                	addi	sp,sp,-32
    800059dc:	ec06                	sd	ra,24(sp)
    800059de:	e822                	sd	s0,16(sp)
    800059e0:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800059e2:	fe040593          	addi	a1,s0,-32
    800059e6:	4505                	li	a0,1
    800059e8:	ffffd097          	auipc	ra,0xffffd
    800059ec:	700080e7          	jalr	1792(ra) # 800030e8 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800059f0:	fe840613          	addi	a2,s0,-24
    800059f4:	4581                	li	a1,0
    800059f6:	4501                	li	a0,0
    800059f8:	00000097          	auipc	ra,0x0
    800059fc:	c64080e7          	jalr	-924(ra) # 8000565c <argfd>
    80005a00:	87aa                	mv	a5,a0
    return -1;
    80005a02:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005a04:	0007ca63          	bltz	a5,80005a18 <sys_fstat+0x3e>
  return filestat(f, st);
    80005a08:	fe043583          	ld	a1,-32(s0)
    80005a0c:	fe843503          	ld	a0,-24(s0)
    80005a10:	fffff097          	auipc	ra,0xfffff
    80005a14:	258080e7          	jalr	600(ra) # 80004c68 <filestat>
}
    80005a18:	60e2                	ld	ra,24(sp)
    80005a1a:	6442                	ld	s0,16(sp)
    80005a1c:	6105                	addi	sp,sp,32
    80005a1e:	8082                	ret

0000000080005a20 <sys_link>:
{
    80005a20:	7169                	addi	sp,sp,-304
    80005a22:	f606                	sd	ra,296(sp)
    80005a24:	f222                	sd	s0,288(sp)
    80005a26:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005a28:	08000613          	li	a2,128
    80005a2c:	ed040593          	addi	a1,s0,-304
    80005a30:	4501                	li	a0,0
    80005a32:	ffffd097          	auipc	ra,0xffffd
    80005a36:	6d6080e7          	jalr	1750(ra) # 80003108 <argstr>
    return -1;
    80005a3a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005a3c:	12054663          	bltz	a0,80005b68 <sys_link+0x148>
    80005a40:	08000613          	li	a2,128
    80005a44:	f5040593          	addi	a1,s0,-176
    80005a48:	4505                	li	a0,1
    80005a4a:	ffffd097          	auipc	ra,0xffffd
    80005a4e:	6be080e7          	jalr	1726(ra) # 80003108 <argstr>
    return -1;
    80005a52:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005a54:	10054a63          	bltz	a0,80005b68 <sys_link+0x148>
    80005a58:	ee26                	sd	s1,280(sp)
  begin_op();
    80005a5a:	fffff097          	auipc	ra,0xfffff
    80005a5e:	c60080e7          	jalr	-928(ra) # 800046ba <begin_op>
  if((ip = namei(old)) == 0){
    80005a62:	ed040513          	addi	a0,s0,-304
    80005a66:	fffff097          	auipc	ra,0xfffff
    80005a6a:	a4e080e7          	jalr	-1458(ra) # 800044b4 <namei>
    80005a6e:	84aa                	mv	s1,a0
    80005a70:	c949                	beqz	a0,80005b02 <sys_link+0xe2>
  ilock(ip);
    80005a72:	ffffe097          	auipc	ra,0xffffe
    80005a76:	25e080e7          	jalr	606(ra) # 80003cd0 <ilock>
  if(ip->type == T_DIR){
    80005a7a:	04449703          	lh	a4,68(s1)
    80005a7e:	4785                	li	a5,1
    80005a80:	08f70863          	beq	a4,a5,80005b10 <sys_link+0xf0>
    80005a84:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80005a86:	04a4d783          	lhu	a5,74(s1)
    80005a8a:	2785                	addiw	a5,a5,1
    80005a8c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005a90:	8526                	mv	a0,s1
    80005a92:	ffffe097          	auipc	ra,0xffffe
    80005a96:	172080e7          	jalr	370(ra) # 80003c04 <iupdate>
  iunlock(ip);
    80005a9a:	8526                	mv	a0,s1
    80005a9c:	ffffe097          	auipc	ra,0xffffe
    80005aa0:	2fa080e7          	jalr	762(ra) # 80003d96 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005aa4:	fd040593          	addi	a1,s0,-48
    80005aa8:	f5040513          	addi	a0,s0,-176
    80005aac:	fffff097          	auipc	ra,0xfffff
    80005ab0:	a26080e7          	jalr	-1498(ra) # 800044d2 <nameiparent>
    80005ab4:	892a                	mv	s2,a0
    80005ab6:	cd35                	beqz	a0,80005b32 <sys_link+0x112>
  ilock(dp);
    80005ab8:	ffffe097          	auipc	ra,0xffffe
    80005abc:	218080e7          	jalr	536(ra) # 80003cd0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005ac0:	00092703          	lw	a4,0(s2)
    80005ac4:	409c                	lw	a5,0(s1)
    80005ac6:	06f71163          	bne	a4,a5,80005b28 <sys_link+0x108>
    80005aca:	40d0                	lw	a2,4(s1)
    80005acc:	fd040593          	addi	a1,s0,-48
    80005ad0:	854a                	mv	a0,s2
    80005ad2:	fffff097          	auipc	ra,0xfffff
    80005ad6:	920080e7          	jalr	-1760(ra) # 800043f2 <dirlink>
    80005ada:	04054763          	bltz	a0,80005b28 <sys_link+0x108>
  iunlockput(dp);
    80005ade:	854a                	mv	a0,s2
    80005ae0:	ffffe097          	auipc	ra,0xffffe
    80005ae4:	456080e7          	jalr	1110(ra) # 80003f36 <iunlockput>
  iput(ip);
    80005ae8:	8526                	mv	a0,s1
    80005aea:	ffffe097          	auipc	ra,0xffffe
    80005aee:	3a4080e7          	jalr	932(ra) # 80003e8e <iput>
  end_op();
    80005af2:	fffff097          	auipc	ra,0xfffff
    80005af6:	c42080e7          	jalr	-958(ra) # 80004734 <end_op>
  return 0;
    80005afa:	4781                	li	a5,0
    80005afc:	64f2                	ld	s1,280(sp)
    80005afe:	6952                	ld	s2,272(sp)
    80005b00:	a0a5                	j	80005b68 <sys_link+0x148>
    end_op();
    80005b02:	fffff097          	auipc	ra,0xfffff
    80005b06:	c32080e7          	jalr	-974(ra) # 80004734 <end_op>
    return -1;
    80005b0a:	57fd                	li	a5,-1
    80005b0c:	64f2                	ld	s1,280(sp)
    80005b0e:	a8a9                	j	80005b68 <sys_link+0x148>
    iunlockput(ip);
    80005b10:	8526                	mv	a0,s1
    80005b12:	ffffe097          	auipc	ra,0xffffe
    80005b16:	424080e7          	jalr	1060(ra) # 80003f36 <iunlockput>
    end_op();
    80005b1a:	fffff097          	auipc	ra,0xfffff
    80005b1e:	c1a080e7          	jalr	-998(ra) # 80004734 <end_op>
    return -1;
    80005b22:	57fd                	li	a5,-1
    80005b24:	64f2                	ld	s1,280(sp)
    80005b26:	a089                	j	80005b68 <sys_link+0x148>
    iunlockput(dp);
    80005b28:	854a                	mv	a0,s2
    80005b2a:	ffffe097          	auipc	ra,0xffffe
    80005b2e:	40c080e7          	jalr	1036(ra) # 80003f36 <iunlockput>
  ilock(ip);
    80005b32:	8526                	mv	a0,s1
    80005b34:	ffffe097          	auipc	ra,0xffffe
    80005b38:	19c080e7          	jalr	412(ra) # 80003cd0 <ilock>
  ip->nlink--;
    80005b3c:	04a4d783          	lhu	a5,74(s1)
    80005b40:	37fd                	addiw	a5,a5,-1
    80005b42:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005b46:	8526                	mv	a0,s1
    80005b48:	ffffe097          	auipc	ra,0xffffe
    80005b4c:	0bc080e7          	jalr	188(ra) # 80003c04 <iupdate>
  iunlockput(ip);
    80005b50:	8526                	mv	a0,s1
    80005b52:	ffffe097          	auipc	ra,0xffffe
    80005b56:	3e4080e7          	jalr	996(ra) # 80003f36 <iunlockput>
  end_op();
    80005b5a:	fffff097          	auipc	ra,0xfffff
    80005b5e:	bda080e7          	jalr	-1062(ra) # 80004734 <end_op>
  return -1;
    80005b62:	57fd                	li	a5,-1
    80005b64:	64f2                	ld	s1,280(sp)
    80005b66:	6952                	ld	s2,272(sp)
}
    80005b68:	853e                	mv	a0,a5
    80005b6a:	70b2                	ld	ra,296(sp)
    80005b6c:	7412                	ld	s0,288(sp)
    80005b6e:	6155                	addi	sp,sp,304
    80005b70:	8082                	ret

0000000080005b72 <sys_unlink>:
{
    80005b72:	7111                	addi	sp,sp,-256
    80005b74:	fd86                	sd	ra,248(sp)
    80005b76:	f9a2                	sd	s0,240(sp)
    80005b78:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    80005b7a:	08000613          	li	a2,128
    80005b7e:	f2040593          	addi	a1,s0,-224
    80005b82:	4501                	li	a0,0
    80005b84:	ffffd097          	auipc	ra,0xffffd
    80005b88:	584080e7          	jalr	1412(ra) # 80003108 <argstr>
    80005b8c:	1c054063          	bltz	a0,80005d4c <sys_unlink+0x1da>
    80005b90:	f5a6                	sd	s1,232(sp)
  begin_op();
    80005b92:	fffff097          	auipc	ra,0xfffff
    80005b96:	b28080e7          	jalr	-1240(ra) # 800046ba <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005b9a:	fa040593          	addi	a1,s0,-96
    80005b9e:	f2040513          	addi	a0,s0,-224
    80005ba2:	fffff097          	auipc	ra,0xfffff
    80005ba6:	930080e7          	jalr	-1744(ra) # 800044d2 <nameiparent>
    80005baa:	84aa                	mv	s1,a0
    80005bac:	c165                	beqz	a0,80005c8c <sys_unlink+0x11a>
  ilock(dp);
    80005bae:	ffffe097          	auipc	ra,0xffffe
    80005bb2:	122080e7          	jalr	290(ra) # 80003cd0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005bb6:	00003597          	auipc	a1,0x3
    80005bba:	b0a58593          	addi	a1,a1,-1270 # 800086c0 <etext+0x6c0>
    80005bbe:	fa040513          	addi	a0,s0,-96
    80005bc2:	ffffe097          	auipc	ra,0xffffe
    80005bc6:	5f0080e7          	jalr	1520(ra) # 800041b2 <namecmp>
    80005bca:	16050263          	beqz	a0,80005d2e <sys_unlink+0x1bc>
    80005bce:	00003597          	auipc	a1,0x3
    80005bd2:	afa58593          	addi	a1,a1,-1286 # 800086c8 <etext+0x6c8>
    80005bd6:	fa040513          	addi	a0,s0,-96
    80005bda:	ffffe097          	auipc	ra,0xffffe
    80005bde:	5d8080e7          	jalr	1496(ra) # 800041b2 <namecmp>
    80005be2:	14050663          	beqz	a0,80005d2e <sys_unlink+0x1bc>
    80005be6:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005be8:	f1c40613          	addi	a2,s0,-228
    80005bec:	fa040593          	addi	a1,s0,-96
    80005bf0:	8526                	mv	a0,s1
    80005bf2:	ffffe097          	auipc	ra,0xffffe
    80005bf6:	5da080e7          	jalr	1498(ra) # 800041cc <dirlookup>
    80005bfa:	892a                	mv	s2,a0
    80005bfc:	12050863          	beqz	a0,80005d2c <sys_unlink+0x1ba>
    80005c00:	edce                	sd	s3,216(sp)
  ilock(ip);
    80005c02:	ffffe097          	auipc	ra,0xffffe
    80005c06:	0ce080e7          	jalr	206(ra) # 80003cd0 <ilock>
  if(ip->nlink < 1)
    80005c0a:	04a91783          	lh	a5,74(s2)
    80005c0e:	08f05663          	blez	a5,80005c9a <sys_unlink+0x128>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005c12:	04491703          	lh	a4,68(s2)
    80005c16:	4785                	li	a5,1
    80005c18:	08f70b63          	beq	a4,a5,80005cae <sys_unlink+0x13c>
  memset(&de, 0, sizeof(de));
    80005c1c:	fb040993          	addi	s3,s0,-80
    80005c20:	4641                	li	a2,16
    80005c22:	4581                	li	a1,0
    80005c24:	854e                	mv	a0,s3
    80005c26:	ffffb097          	auipc	ra,0xffffb
    80005c2a:	110080e7          	jalr	272(ra) # 80000d36 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005c2e:	4741                	li	a4,16
    80005c30:	f1c42683          	lw	a3,-228(s0)
    80005c34:	864e                	mv	a2,s3
    80005c36:	4581                	li	a1,0
    80005c38:	8526                	mv	a0,s1
    80005c3a:	ffffe097          	auipc	ra,0xffffe
    80005c3e:	458080e7          	jalr	1112(ra) # 80004092 <writei>
    80005c42:	47c1                	li	a5,16
    80005c44:	0af51f63          	bne	a0,a5,80005d02 <sys_unlink+0x190>
  if(ip->type == T_DIR){
    80005c48:	04491703          	lh	a4,68(s2)
    80005c4c:	4785                	li	a5,1
    80005c4e:	0cf70463          	beq	a4,a5,80005d16 <sys_unlink+0x1a4>
  iunlockput(dp);
    80005c52:	8526                	mv	a0,s1
    80005c54:	ffffe097          	auipc	ra,0xffffe
    80005c58:	2e2080e7          	jalr	738(ra) # 80003f36 <iunlockput>
  ip->nlink--;
    80005c5c:	04a95783          	lhu	a5,74(s2)
    80005c60:	37fd                	addiw	a5,a5,-1
    80005c62:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005c66:	854a                	mv	a0,s2
    80005c68:	ffffe097          	auipc	ra,0xffffe
    80005c6c:	f9c080e7          	jalr	-100(ra) # 80003c04 <iupdate>
  iunlockput(ip);
    80005c70:	854a                	mv	a0,s2
    80005c72:	ffffe097          	auipc	ra,0xffffe
    80005c76:	2c4080e7          	jalr	708(ra) # 80003f36 <iunlockput>
  end_op();
    80005c7a:	fffff097          	auipc	ra,0xfffff
    80005c7e:	aba080e7          	jalr	-1350(ra) # 80004734 <end_op>
  return 0;
    80005c82:	4501                	li	a0,0
    80005c84:	74ae                	ld	s1,232(sp)
    80005c86:	790e                	ld	s2,224(sp)
    80005c88:	69ee                	ld	s3,216(sp)
    80005c8a:	a86d                	j	80005d44 <sys_unlink+0x1d2>
    end_op();
    80005c8c:	fffff097          	auipc	ra,0xfffff
    80005c90:	aa8080e7          	jalr	-1368(ra) # 80004734 <end_op>
    return -1;
    80005c94:	557d                	li	a0,-1
    80005c96:	74ae                	ld	s1,232(sp)
    80005c98:	a075                	j	80005d44 <sys_unlink+0x1d2>
    80005c9a:	e9d2                	sd	s4,208(sp)
    80005c9c:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    80005c9e:	00003517          	auipc	a0,0x3
    80005ca2:	a3250513          	addi	a0,a0,-1486 # 800086d0 <etext+0x6d0>
    80005ca6:	ffffb097          	auipc	ra,0xffffb
    80005caa:	8ba080e7          	jalr	-1862(ra) # 80000560 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005cae:	04c92703          	lw	a4,76(s2)
    80005cb2:	02000793          	li	a5,32
    80005cb6:	f6e7f3e3          	bgeu	a5,a4,80005c1c <sys_unlink+0xaa>
    80005cba:	e9d2                	sd	s4,208(sp)
    80005cbc:	e5d6                	sd	s5,200(sp)
    80005cbe:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005cc0:	f0840a93          	addi	s5,s0,-248
    80005cc4:	4a41                	li	s4,16
    80005cc6:	8752                	mv	a4,s4
    80005cc8:	86ce                	mv	a3,s3
    80005cca:	8656                	mv	a2,s5
    80005ccc:	4581                	li	a1,0
    80005cce:	854a                	mv	a0,s2
    80005cd0:	ffffe097          	auipc	ra,0xffffe
    80005cd4:	2bc080e7          	jalr	700(ra) # 80003f8c <readi>
    80005cd8:	01451d63          	bne	a0,s4,80005cf2 <sys_unlink+0x180>
    if(de.inum != 0)
    80005cdc:	f0845783          	lhu	a5,-248(s0)
    80005ce0:	eba5                	bnez	a5,80005d50 <sys_unlink+0x1de>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005ce2:	29c1                	addiw	s3,s3,16
    80005ce4:	04c92783          	lw	a5,76(s2)
    80005ce8:	fcf9efe3          	bltu	s3,a5,80005cc6 <sys_unlink+0x154>
    80005cec:	6a4e                	ld	s4,208(sp)
    80005cee:	6aae                	ld	s5,200(sp)
    80005cf0:	b735                	j	80005c1c <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005cf2:	00003517          	auipc	a0,0x3
    80005cf6:	9f650513          	addi	a0,a0,-1546 # 800086e8 <etext+0x6e8>
    80005cfa:	ffffb097          	auipc	ra,0xffffb
    80005cfe:	866080e7          	jalr	-1946(ra) # 80000560 <panic>
    80005d02:	e9d2                	sd	s4,208(sp)
    80005d04:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    80005d06:	00003517          	auipc	a0,0x3
    80005d0a:	9fa50513          	addi	a0,a0,-1542 # 80008700 <etext+0x700>
    80005d0e:	ffffb097          	auipc	ra,0xffffb
    80005d12:	852080e7          	jalr	-1966(ra) # 80000560 <panic>
    dp->nlink--;
    80005d16:	04a4d783          	lhu	a5,74(s1)
    80005d1a:	37fd                	addiw	a5,a5,-1
    80005d1c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005d20:	8526                	mv	a0,s1
    80005d22:	ffffe097          	auipc	ra,0xffffe
    80005d26:	ee2080e7          	jalr	-286(ra) # 80003c04 <iupdate>
    80005d2a:	b725                	j	80005c52 <sys_unlink+0xe0>
    80005d2c:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    80005d2e:	8526                	mv	a0,s1
    80005d30:	ffffe097          	auipc	ra,0xffffe
    80005d34:	206080e7          	jalr	518(ra) # 80003f36 <iunlockput>
  end_op();
    80005d38:	fffff097          	auipc	ra,0xfffff
    80005d3c:	9fc080e7          	jalr	-1540(ra) # 80004734 <end_op>
  return -1;
    80005d40:	557d                	li	a0,-1
    80005d42:	74ae                	ld	s1,232(sp)
}
    80005d44:	70ee                	ld	ra,248(sp)
    80005d46:	744e                	ld	s0,240(sp)
    80005d48:	6111                	addi	sp,sp,256
    80005d4a:	8082                	ret
    return -1;
    80005d4c:	557d                	li	a0,-1
    80005d4e:	bfdd                	j	80005d44 <sys_unlink+0x1d2>
    iunlockput(ip);
    80005d50:	854a                	mv	a0,s2
    80005d52:	ffffe097          	auipc	ra,0xffffe
    80005d56:	1e4080e7          	jalr	484(ra) # 80003f36 <iunlockput>
    goto bad;
    80005d5a:	790e                	ld	s2,224(sp)
    80005d5c:	69ee                	ld	s3,216(sp)
    80005d5e:	6a4e                	ld	s4,208(sp)
    80005d60:	6aae                	ld	s5,200(sp)
    80005d62:	b7f1                	j	80005d2e <sys_unlink+0x1bc>

0000000080005d64 <sys_open>:

uint64
sys_open(void)
{
    80005d64:	7131                	addi	sp,sp,-192
    80005d66:	fd06                	sd	ra,184(sp)
    80005d68:	f922                	sd	s0,176(sp)
    80005d6a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005d6c:	f4c40593          	addi	a1,s0,-180
    80005d70:	4505                	li	a0,1
    80005d72:	ffffd097          	auipc	ra,0xffffd
    80005d76:	356080e7          	jalr	854(ra) # 800030c8 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005d7a:	08000613          	li	a2,128
    80005d7e:	f5040593          	addi	a1,s0,-176
    80005d82:	4501                	li	a0,0
    80005d84:	ffffd097          	auipc	ra,0xffffd
    80005d88:	384080e7          	jalr	900(ra) # 80003108 <argstr>
    80005d8c:	87aa                	mv	a5,a0
    return -1;
    80005d8e:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005d90:	0a07cf63          	bltz	a5,80005e4e <sys_open+0xea>
    80005d94:	f526                	sd	s1,168(sp)

  begin_op();
    80005d96:	fffff097          	auipc	ra,0xfffff
    80005d9a:	924080e7          	jalr	-1756(ra) # 800046ba <begin_op>

  if(omode & O_CREATE){
    80005d9e:	f4c42783          	lw	a5,-180(s0)
    80005da2:	2007f793          	andi	a5,a5,512
    80005da6:	cfdd                	beqz	a5,80005e64 <sys_open+0x100>
    ip = create(path, T_FILE, 0, 0);
    80005da8:	4681                	li	a3,0
    80005daa:	4601                	li	a2,0
    80005dac:	4589                	li	a1,2
    80005dae:	f5040513          	addi	a0,s0,-176
    80005db2:	00000097          	auipc	ra,0x0
    80005db6:	94c080e7          	jalr	-1716(ra) # 800056fe <create>
    80005dba:	84aa                	mv	s1,a0
    if(ip == 0){
    80005dbc:	cd49                	beqz	a0,80005e56 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005dbe:	04449703          	lh	a4,68(s1)
    80005dc2:	478d                	li	a5,3
    80005dc4:	00f71763          	bne	a4,a5,80005dd2 <sys_open+0x6e>
    80005dc8:	0464d703          	lhu	a4,70(s1)
    80005dcc:	47a5                	li	a5,9
    80005dce:	0ee7e263          	bltu	a5,a4,80005eb2 <sys_open+0x14e>
    80005dd2:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005dd4:	fffff097          	auipc	ra,0xfffff
    80005dd8:	cfa080e7          	jalr	-774(ra) # 80004ace <filealloc>
    80005ddc:	892a                	mv	s2,a0
    80005dde:	cd65                	beqz	a0,80005ed6 <sys_open+0x172>
    80005de0:	ed4e                	sd	s3,152(sp)
    80005de2:	00000097          	auipc	ra,0x0
    80005de6:	8da080e7          	jalr	-1830(ra) # 800056bc <fdalloc>
    80005dea:	89aa                	mv	s3,a0
    80005dec:	0c054f63          	bltz	a0,80005eca <sys_open+0x166>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005df0:	04449703          	lh	a4,68(s1)
    80005df4:	478d                	li	a5,3
    80005df6:	0ef70d63          	beq	a4,a5,80005ef0 <sys_open+0x18c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005dfa:	4789                	li	a5,2
    80005dfc:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005e00:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005e04:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005e08:	f4c42783          	lw	a5,-180(s0)
    80005e0c:	0017f713          	andi	a4,a5,1
    80005e10:	00174713          	xori	a4,a4,1
    80005e14:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005e18:	0037f713          	andi	a4,a5,3
    80005e1c:	00e03733          	snez	a4,a4
    80005e20:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005e24:	4007f793          	andi	a5,a5,1024
    80005e28:	c791                	beqz	a5,80005e34 <sys_open+0xd0>
    80005e2a:	04449703          	lh	a4,68(s1)
    80005e2e:	4789                	li	a5,2
    80005e30:	0cf70763          	beq	a4,a5,80005efe <sys_open+0x19a>
    itrunc(ip);
  }

  iunlock(ip);
    80005e34:	8526                	mv	a0,s1
    80005e36:	ffffe097          	auipc	ra,0xffffe
    80005e3a:	f60080e7          	jalr	-160(ra) # 80003d96 <iunlock>
  end_op();
    80005e3e:	fffff097          	auipc	ra,0xfffff
    80005e42:	8f6080e7          	jalr	-1802(ra) # 80004734 <end_op>

  return fd;
    80005e46:	854e                	mv	a0,s3
    80005e48:	74aa                	ld	s1,168(sp)
    80005e4a:	790a                	ld	s2,160(sp)
    80005e4c:	69ea                	ld	s3,152(sp)
}
    80005e4e:	70ea                	ld	ra,184(sp)
    80005e50:	744a                	ld	s0,176(sp)
    80005e52:	6129                	addi	sp,sp,192
    80005e54:	8082                	ret
      end_op();
    80005e56:	fffff097          	auipc	ra,0xfffff
    80005e5a:	8de080e7          	jalr	-1826(ra) # 80004734 <end_op>
      return -1;
    80005e5e:	557d                	li	a0,-1
    80005e60:	74aa                	ld	s1,168(sp)
    80005e62:	b7f5                	j	80005e4e <sys_open+0xea>
    if((ip = namei(path)) == 0){
    80005e64:	f5040513          	addi	a0,s0,-176
    80005e68:	ffffe097          	auipc	ra,0xffffe
    80005e6c:	64c080e7          	jalr	1612(ra) # 800044b4 <namei>
    80005e70:	84aa                	mv	s1,a0
    80005e72:	c90d                	beqz	a0,80005ea4 <sys_open+0x140>
    ilock(ip);
    80005e74:	ffffe097          	auipc	ra,0xffffe
    80005e78:	e5c080e7          	jalr	-420(ra) # 80003cd0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005e7c:	04449703          	lh	a4,68(s1)
    80005e80:	4785                	li	a5,1
    80005e82:	f2f71ee3          	bne	a4,a5,80005dbe <sys_open+0x5a>
    80005e86:	f4c42783          	lw	a5,-180(s0)
    80005e8a:	d7a1                	beqz	a5,80005dd2 <sys_open+0x6e>
      iunlockput(ip);
    80005e8c:	8526                	mv	a0,s1
    80005e8e:	ffffe097          	auipc	ra,0xffffe
    80005e92:	0a8080e7          	jalr	168(ra) # 80003f36 <iunlockput>
      end_op();
    80005e96:	fffff097          	auipc	ra,0xfffff
    80005e9a:	89e080e7          	jalr	-1890(ra) # 80004734 <end_op>
      return -1;
    80005e9e:	557d                	li	a0,-1
    80005ea0:	74aa                	ld	s1,168(sp)
    80005ea2:	b775                	j	80005e4e <sys_open+0xea>
      end_op();
    80005ea4:	fffff097          	auipc	ra,0xfffff
    80005ea8:	890080e7          	jalr	-1904(ra) # 80004734 <end_op>
      return -1;
    80005eac:	557d                	li	a0,-1
    80005eae:	74aa                	ld	s1,168(sp)
    80005eb0:	bf79                	j	80005e4e <sys_open+0xea>
    iunlockput(ip);
    80005eb2:	8526                	mv	a0,s1
    80005eb4:	ffffe097          	auipc	ra,0xffffe
    80005eb8:	082080e7          	jalr	130(ra) # 80003f36 <iunlockput>
    end_op();
    80005ebc:	fffff097          	auipc	ra,0xfffff
    80005ec0:	878080e7          	jalr	-1928(ra) # 80004734 <end_op>
    return -1;
    80005ec4:	557d                	li	a0,-1
    80005ec6:	74aa                	ld	s1,168(sp)
    80005ec8:	b759                	j	80005e4e <sys_open+0xea>
      fileclose(f);
    80005eca:	854a                	mv	a0,s2
    80005ecc:	fffff097          	auipc	ra,0xfffff
    80005ed0:	cbe080e7          	jalr	-834(ra) # 80004b8a <fileclose>
    80005ed4:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005ed6:	8526                	mv	a0,s1
    80005ed8:	ffffe097          	auipc	ra,0xffffe
    80005edc:	05e080e7          	jalr	94(ra) # 80003f36 <iunlockput>
    end_op();
    80005ee0:	fffff097          	auipc	ra,0xfffff
    80005ee4:	854080e7          	jalr	-1964(ra) # 80004734 <end_op>
    return -1;
    80005ee8:	557d                	li	a0,-1
    80005eea:	74aa                	ld	s1,168(sp)
    80005eec:	790a                	ld	s2,160(sp)
    80005eee:	b785                	j	80005e4e <sys_open+0xea>
    f->type = FD_DEVICE;
    80005ef0:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005ef4:	04649783          	lh	a5,70(s1)
    80005ef8:	02f91223          	sh	a5,36(s2)
    80005efc:	b721                	j	80005e04 <sys_open+0xa0>
    itrunc(ip);
    80005efe:	8526                	mv	a0,s1
    80005f00:	ffffe097          	auipc	ra,0xffffe
    80005f04:	ee2080e7          	jalr	-286(ra) # 80003de2 <itrunc>
    80005f08:	b735                	j	80005e34 <sys_open+0xd0>

0000000080005f0a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005f0a:	7175                	addi	sp,sp,-144
    80005f0c:	e506                	sd	ra,136(sp)
    80005f0e:	e122                	sd	s0,128(sp)
    80005f10:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005f12:	ffffe097          	auipc	ra,0xffffe
    80005f16:	7a8080e7          	jalr	1960(ra) # 800046ba <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005f1a:	08000613          	li	a2,128
    80005f1e:	f7040593          	addi	a1,s0,-144
    80005f22:	4501                	li	a0,0
    80005f24:	ffffd097          	auipc	ra,0xffffd
    80005f28:	1e4080e7          	jalr	484(ra) # 80003108 <argstr>
    80005f2c:	02054963          	bltz	a0,80005f5e <sys_mkdir+0x54>
    80005f30:	4681                	li	a3,0
    80005f32:	4601                	li	a2,0
    80005f34:	4585                	li	a1,1
    80005f36:	f7040513          	addi	a0,s0,-144
    80005f3a:	fffff097          	auipc	ra,0xfffff
    80005f3e:	7c4080e7          	jalr	1988(ra) # 800056fe <create>
    80005f42:	cd11                	beqz	a0,80005f5e <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005f44:	ffffe097          	auipc	ra,0xffffe
    80005f48:	ff2080e7          	jalr	-14(ra) # 80003f36 <iunlockput>
  end_op();
    80005f4c:	ffffe097          	auipc	ra,0xffffe
    80005f50:	7e8080e7          	jalr	2024(ra) # 80004734 <end_op>
  return 0;
    80005f54:	4501                	li	a0,0
}
    80005f56:	60aa                	ld	ra,136(sp)
    80005f58:	640a                	ld	s0,128(sp)
    80005f5a:	6149                	addi	sp,sp,144
    80005f5c:	8082                	ret
    end_op();
    80005f5e:	ffffe097          	auipc	ra,0xffffe
    80005f62:	7d6080e7          	jalr	2006(ra) # 80004734 <end_op>
    return -1;
    80005f66:	557d                	li	a0,-1
    80005f68:	b7fd                	j	80005f56 <sys_mkdir+0x4c>

0000000080005f6a <sys_mknod>:

uint64
sys_mknod(void)
{
    80005f6a:	7135                	addi	sp,sp,-160
    80005f6c:	ed06                	sd	ra,152(sp)
    80005f6e:	e922                	sd	s0,144(sp)
    80005f70:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005f72:	ffffe097          	auipc	ra,0xffffe
    80005f76:	748080e7          	jalr	1864(ra) # 800046ba <begin_op>
  argint(1, &major);
    80005f7a:	f6c40593          	addi	a1,s0,-148
    80005f7e:	4505                	li	a0,1
    80005f80:	ffffd097          	auipc	ra,0xffffd
    80005f84:	148080e7          	jalr	328(ra) # 800030c8 <argint>
  argint(2, &minor);
    80005f88:	f6840593          	addi	a1,s0,-152
    80005f8c:	4509                	li	a0,2
    80005f8e:	ffffd097          	auipc	ra,0xffffd
    80005f92:	13a080e7          	jalr	314(ra) # 800030c8 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005f96:	08000613          	li	a2,128
    80005f9a:	f7040593          	addi	a1,s0,-144
    80005f9e:	4501                	li	a0,0
    80005fa0:	ffffd097          	auipc	ra,0xffffd
    80005fa4:	168080e7          	jalr	360(ra) # 80003108 <argstr>
    80005fa8:	02054b63          	bltz	a0,80005fde <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005fac:	f6841683          	lh	a3,-152(s0)
    80005fb0:	f6c41603          	lh	a2,-148(s0)
    80005fb4:	458d                	li	a1,3
    80005fb6:	f7040513          	addi	a0,s0,-144
    80005fba:	fffff097          	auipc	ra,0xfffff
    80005fbe:	744080e7          	jalr	1860(ra) # 800056fe <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005fc2:	cd11                	beqz	a0,80005fde <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005fc4:	ffffe097          	auipc	ra,0xffffe
    80005fc8:	f72080e7          	jalr	-142(ra) # 80003f36 <iunlockput>
  end_op();
    80005fcc:	ffffe097          	auipc	ra,0xffffe
    80005fd0:	768080e7          	jalr	1896(ra) # 80004734 <end_op>
  return 0;
    80005fd4:	4501                	li	a0,0
}
    80005fd6:	60ea                	ld	ra,152(sp)
    80005fd8:	644a                	ld	s0,144(sp)
    80005fda:	610d                	addi	sp,sp,160
    80005fdc:	8082                	ret
    end_op();
    80005fde:	ffffe097          	auipc	ra,0xffffe
    80005fe2:	756080e7          	jalr	1878(ra) # 80004734 <end_op>
    return -1;
    80005fe6:	557d                	li	a0,-1
    80005fe8:	b7fd                	j	80005fd6 <sys_mknod+0x6c>

0000000080005fea <sys_chdir>:

uint64
sys_chdir(void)
{
    80005fea:	7135                	addi	sp,sp,-160
    80005fec:	ed06                	sd	ra,152(sp)
    80005fee:	e922                	sd	s0,144(sp)
    80005ff0:	e14a                	sd	s2,128(sp)
    80005ff2:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005ff4:	ffffc097          	auipc	ra,0xffffc
    80005ff8:	d12080e7          	jalr	-750(ra) # 80001d06 <myproc>
    80005ffc:	892a                	mv	s2,a0
  
  begin_op();
    80005ffe:	ffffe097          	auipc	ra,0xffffe
    80006002:	6bc080e7          	jalr	1724(ra) # 800046ba <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80006006:	08000613          	li	a2,128
    8000600a:	f6040593          	addi	a1,s0,-160
    8000600e:	4501                	li	a0,0
    80006010:	ffffd097          	auipc	ra,0xffffd
    80006014:	0f8080e7          	jalr	248(ra) # 80003108 <argstr>
    80006018:	04054d63          	bltz	a0,80006072 <sys_chdir+0x88>
    8000601c:	e526                	sd	s1,136(sp)
    8000601e:	f6040513          	addi	a0,s0,-160
    80006022:	ffffe097          	auipc	ra,0xffffe
    80006026:	492080e7          	jalr	1170(ra) # 800044b4 <namei>
    8000602a:	84aa                	mv	s1,a0
    8000602c:	c131                	beqz	a0,80006070 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    8000602e:	ffffe097          	auipc	ra,0xffffe
    80006032:	ca2080e7          	jalr	-862(ra) # 80003cd0 <ilock>
  if(ip->type != T_DIR){
    80006036:	04449703          	lh	a4,68(s1)
    8000603a:	4785                	li	a5,1
    8000603c:	04f71163          	bne	a4,a5,8000607e <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80006040:	8526                	mv	a0,s1
    80006042:	ffffe097          	auipc	ra,0xffffe
    80006046:	d54080e7          	jalr	-684(ra) # 80003d96 <iunlock>
  iput(p->cwd);
    8000604a:	15093503          	ld	a0,336(s2)
    8000604e:	ffffe097          	auipc	ra,0xffffe
    80006052:	e40080e7          	jalr	-448(ra) # 80003e8e <iput>
  end_op();
    80006056:	ffffe097          	auipc	ra,0xffffe
    8000605a:	6de080e7          	jalr	1758(ra) # 80004734 <end_op>
  p->cwd = ip;
    8000605e:	14993823          	sd	s1,336(s2)
  return 0;
    80006062:	4501                	li	a0,0
    80006064:	64aa                	ld	s1,136(sp)
}
    80006066:	60ea                	ld	ra,152(sp)
    80006068:	644a                	ld	s0,144(sp)
    8000606a:	690a                	ld	s2,128(sp)
    8000606c:	610d                	addi	sp,sp,160
    8000606e:	8082                	ret
    80006070:	64aa                	ld	s1,136(sp)
    end_op();
    80006072:	ffffe097          	auipc	ra,0xffffe
    80006076:	6c2080e7          	jalr	1730(ra) # 80004734 <end_op>
    return -1;
    8000607a:	557d                	li	a0,-1
    8000607c:	b7ed                	j	80006066 <sys_chdir+0x7c>
    iunlockput(ip);
    8000607e:	8526                	mv	a0,s1
    80006080:	ffffe097          	auipc	ra,0xffffe
    80006084:	eb6080e7          	jalr	-330(ra) # 80003f36 <iunlockput>
    end_op();
    80006088:	ffffe097          	auipc	ra,0xffffe
    8000608c:	6ac080e7          	jalr	1708(ra) # 80004734 <end_op>
    return -1;
    80006090:	557d                	li	a0,-1
    80006092:	64aa                	ld	s1,136(sp)
    80006094:	bfc9                	j	80006066 <sys_chdir+0x7c>

0000000080006096 <sys_exec>:

uint64
sys_exec(void)
{
    80006096:	7105                	addi	sp,sp,-480
    80006098:	ef86                	sd	ra,472(sp)
    8000609a:	eba2                	sd	s0,464(sp)
    8000609c:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000609e:	e2840593          	addi	a1,s0,-472
    800060a2:	4505                	li	a0,1
    800060a4:	ffffd097          	auipc	ra,0xffffd
    800060a8:	044080e7          	jalr	68(ra) # 800030e8 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800060ac:	08000613          	li	a2,128
    800060b0:	f3040593          	addi	a1,s0,-208
    800060b4:	4501                	li	a0,0
    800060b6:	ffffd097          	auipc	ra,0xffffd
    800060ba:	052080e7          	jalr	82(ra) # 80003108 <argstr>
    800060be:	87aa                	mv	a5,a0
    return -1;
    800060c0:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800060c2:	0e07ce63          	bltz	a5,800061be <sys_exec+0x128>
    800060c6:	e7a6                	sd	s1,456(sp)
    800060c8:	e3ca                	sd	s2,448(sp)
    800060ca:	ff4e                	sd	s3,440(sp)
    800060cc:	fb52                	sd	s4,432(sp)
    800060ce:	f756                	sd	s5,424(sp)
    800060d0:	f35a                	sd	s6,416(sp)
    800060d2:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    800060d4:	e3040a13          	addi	s4,s0,-464
    800060d8:	10000613          	li	a2,256
    800060dc:	4581                	li	a1,0
    800060de:	8552                	mv	a0,s4
    800060e0:	ffffb097          	auipc	ra,0xffffb
    800060e4:	c56080e7          	jalr	-938(ra) # 80000d36 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800060e8:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    800060ea:	89d2                	mv	s3,s4
    800060ec:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800060ee:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800060f2:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    800060f4:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800060f8:	00391513          	slli	a0,s2,0x3
    800060fc:	85d6                	mv	a1,s5
    800060fe:	e2843783          	ld	a5,-472(s0)
    80006102:	953e                	add	a0,a0,a5
    80006104:	ffffd097          	auipc	ra,0xffffd
    80006108:	f26080e7          	jalr	-218(ra) # 8000302a <fetchaddr>
    8000610c:	02054a63          	bltz	a0,80006140 <sys_exec+0xaa>
    if(uarg == 0){
    80006110:	e2043783          	ld	a5,-480(s0)
    80006114:	cbb1                	beqz	a5,80006168 <sys_exec+0xd2>
    argv[i] = kalloc();
    80006116:	ffffb097          	auipc	ra,0xffffb
    8000611a:	a34080e7          	jalr	-1484(ra) # 80000b4a <kalloc>
    8000611e:	85aa                	mv	a1,a0
    80006120:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80006124:	cd11                	beqz	a0,80006140 <sys_exec+0xaa>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80006126:	865a                	mv	a2,s6
    80006128:	e2043503          	ld	a0,-480(s0)
    8000612c:	ffffd097          	auipc	ra,0xffffd
    80006130:	f50080e7          	jalr	-176(ra) # 8000307c <fetchstr>
    80006134:	00054663          	bltz	a0,80006140 <sys_exec+0xaa>
    if(i >= NELEM(argv)){
    80006138:	0905                	addi	s2,s2,1
    8000613a:	09a1                	addi	s3,s3,8
    8000613c:	fb791ee3          	bne	s2,s7,800060f8 <sys_exec+0x62>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006140:	100a0a13          	addi	s4,s4,256
    80006144:	6088                	ld	a0,0(s1)
    80006146:	c525                	beqz	a0,800061ae <sys_exec+0x118>
    kfree(argv[i]);
    80006148:	ffffb097          	auipc	ra,0xffffb
    8000614c:	904080e7          	jalr	-1788(ra) # 80000a4c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006150:	04a1                	addi	s1,s1,8
    80006152:	ff4499e3          	bne	s1,s4,80006144 <sys_exec+0xae>
  return -1;
    80006156:	557d                	li	a0,-1
    80006158:	64be                	ld	s1,456(sp)
    8000615a:	691e                	ld	s2,448(sp)
    8000615c:	79fa                	ld	s3,440(sp)
    8000615e:	7a5a                	ld	s4,432(sp)
    80006160:	7aba                	ld	s5,424(sp)
    80006162:	7b1a                	ld	s6,416(sp)
    80006164:	6bfa                	ld	s7,408(sp)
    80006166:	a8a1                	j	800061be <sys_exec+0x128>
      argv[i] = 0;
    80006168:	0009079b          	sext.w	a5,s2
    8000616c:	e3040593          	addi	a1,s0,-464
    80006170:	078e                	slli	a5,a5,0x3
    80006172:	97ae                	add	a5,a5,a1
    80006174:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    80006178:	f3040513          	addi	a0,s0,-208
    8000617c:	fffff097          	auipc	ra,0xfffff
    80006180:	118080e7          	jalr	280(ra) # 80005294 <exec>
    80006184:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006186:	100a0a13          	addi	s4,s4,256
    8000618a:	6088                	ld	a0,0(s1)
    8000618c:	c901                	beqz	a0,8000619c <sys_exec+0x106>
    kfree(argv[i]);
    8000618e:	ffffb097          	auipc	ra,0xffffb
    80006192:	8be080e7          	jalr	-1858(ra) # 80000a4c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006196:	04a1                	addi	s1,s1,8
    80006198:	ff4499e3          	bne	s1,s4,8000618a <sys_exec+0xf4>
  return ret;
    8000619c:	854a                	mv	a0,s2
    8000619e:	64be                	ld	s1,456(sp)
    800061a0:	691e                	ld	s2,448(sp)
    800061a2:	79fa                	ld	s3,440(sp)
    800061a4:	7a5a                	ld	s4,432(sp)
    800061a6:	7aba                	ld	s5,424(sp)
    800061a8:	7b1a                	ld	s6,416(sp)
    800061aa:	6bfa                	ld	s7,408(sp)
    800061ac:	a809                	j	800061be <sys_exec+0x128>
  return -1;
    800061ae:	557d                	li	a0,-1
    800061b0:	64be                	ld	s1,456(sp)
    800061b2:	691e                	ld	s2,448(sp)
    800061b4:	79fa                	ld	s3,440(sp)
    800061b6:	7a5a                	ld	s4,432(sp)
    800061b8:	7aba                	ld	s5,424(sp)
    800061ba:	7b1a                	ld	s6,416(sp)
    800061bc:	6bfa                	ld	s7,408(sp)
}
    800061be:	60fe                	ld	ra,472(sp)
    800061c0:	645e                	ld	s0,464(sp)
    800061c2:	613d                	addi	sp,sp,480
    800061c4:	8082                	ret

00000000800061c6 <sys_pipe>:

uint64
sys_pipe(void)
{
    800061c6:	7139                	addi	sp,sp,-64
    800061c8:	fc06                	sd	ra,56(sp)
    800061ca:	f822                	sd	s0,48(sp)
    800061cc:	f426                	sd	s1,40(sp)
    800061ce:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800061d0:	ffffc097          	auipc	ra,0xffffc
    800061d4:	b36080e7          	jalr	-1226(ra) # 80001d06 <myproc>
    800061d8:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800061da:	fd840593          	addi	a1,s0,-40
    800061de:	4501                	li	a0,0
    800061e0:	ffffd097          	auipc	ra,0xffffd
    800061e4:	f08080e7          	jalr	-248(ra) # 800030e8 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800061e8:	fc840593          	addi	a1,s0,-56
    800061ec:	fd040513          	addi	a0,s0,-48
    800061f0:	fffff097          	auipc	ra,0xfffff
    800061f4:	d0e080e7          	jalr	-754(ra) # 80004efe <pipealloc>
    return -1;
    800061f8:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800061fa:	0c054463          	bltz	a0,800062c2 <sys_pipe+0xfc>
  fd0 = -1;
    800061fe:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80006202:	fd043503          	ld	a0,-48(s0)
    80006206:	fffff097          	auipc	ra,0xfffff
    8000620a:	4b6080e7          	jalr	1206(ra) # 800056bc <fdalloc>
    8000620e:	fca42223          	sw	a0,-60(s0)
    80006212:	08054b63          	bltz	a0,800062a8 <sys_pipe+0xe2>
    80006216:	fc843503          	ld	a0,-56(s0)
    8000621a:	fffff097          	auipc	ra,0xfffff
    8000621e:	4a2080e7          	jalr	1186(ra) # 800056bc <fdalloc>
    80006222:	fca42023          	sw	a0,-64(s0)
    80006226:	06054863          	bltz	a0,80006296 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000622a:	4691                	li	a3,4
    8000622c:	fc440613          	addi	a2,s0,-60
    80006230:	fd843583          	ld	a1,-40(s0)
    80006234:	68a8                	ld	a0,80(s1)
    80006236:	ffffb097          	auipc	ra,0xffffb
    8000623a:	4da080e7          	jalr	1242(ra) # 80001710 <copyout>
    8000623e:	02054063          	bltz	a0,8000625e <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80006242:	4691                	li	a3,4
    80006244:	fc040613          	addi	a2,s0,-64
    80006248:	fd843583          	ld	a1,-40(s0)
    8000624c:	95b6                	add	a1,a1,a3
    8000624e:	68a8                	ld	a0,80(s1)
    80006250:	ffffb097          	auipc	ra,0xffffb
    80006254:	4c0080e7          	jalr	1216(ra) # 80001710 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80006258:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000625a:	06055463          	bgez	a0,800062c2 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    8000625e:	fc442783          	lw	a5,-60(s0)
    80006262:	07e9                	addi	a5,a5,26
    80006264:	078e                	slli	a5,a5,0x3
    80006266:	97a6                	add	a5,a5,s1
    80006268:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000626c:	fc042783          	lw	a5,-64(s0)
    80006270:	07e9                	addi	a5,a5,26
    80006272:	078e                	slli	a5,a5,0x3
    80006274:	94be                	add	s1,s1,a5
    80006276:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000627a:	fd043503          	ld	a0,-48(s0)
    8000627e:	fffff097          	auipc	ra,0xfffff
    80006282:	90c080e7          	jalr	-1780(ra) # 80004b8a <fileclose>
    fileclose(wf);
    80006286:	fc843503          	ld	a0,-56(s0)
    8000628a:	fffff097          	auipc	ra,0xfffff
    8000628e:	900080e7          	jalr	-1792(ra) # 80004b8a <fileclose>
    return -1;
    80006292:	57fd                	li	a5,-1
    80006294:	a03d                	j	800062c2 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80006296:	fc442783          	lw	a5,-60(s0)
    8000629a:	0007c763          	bltz	a5,800062a8 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    8000629e:	07e9                	addi	a5,a5,26
    800062a0:	078e                	slli	a5,a5,0x3
    800062a2:	97a6                	add	a5,a5,s1
    800062a4:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800062a8:	fd043503          	ld	a0,-48(s0)
    800062ac:	fffff097          	auipc	ra,0xfffff
    800062b0:	8de080e7          	jalr	-1826(ra) # 80004b8a <fileclose>
    fileclose(wf);
    800062b4:	fc843503          	ld	a0,-56(s0)
    800062b8:	fffff097          	auipc	ra,0xfffff
    800062bc:	8d2080e7          	jalr	-1838(ra) # 80004b8a <fileclose>
    return -1;
    800062c0:	57fd                	li	a5,-1
}
    800062c2:	853e                	mv	a0,a5
    800062c4:	70e2                	ld	ra,56(sp)
    800062c6:	7442                	ld	s0,48(sp)
    800062c8:	74a2                	ld	s1,40(sp)
    800062ca:	6121                	addi	sp,sp,64
    800062cc:	8082                	ret
	...

00000000800062d0 <kernelvec>:
    800062d0:	7111                	addi	sp,sp,-256
    800062d2:	e006                	sd	ra,0(sp)
    800062d4:	e40a                	sd	sp,8(sp)
    800062d6:	e80e                	sd	gp,16(sp)
    800062d8:	ec12                	sd	tp,24(sp)
    800062da:	f016                	sd	t0,32(sp)
    800062dc:	f41a                	sd	t1,40(sp)
    800062de:	f81e                	sd	t2,48(sp)
    800062e0:	fc22                	sd	s0,56(sp)
    800062e2:	e0a6                	sd	s1,64(sp)
    800062e4:	e4aa                	sd	a0,72(sp)
    800062e6:	e8ae                	sd	a1,80(sp)
    800062e8:	ecb2                	sd	a2,88(sp)
    800062ea:	f0b6                	sd	a3,96(sp)
    800062ec:	f4ba                	sd	a4,104(sp)
    800062ee:	f8be                	sd	a5,112(sp)
    800062f0:	fcc2                	sd	a6,120(sp)
    800062f2:	e146                	sd	a7,128(sp)
    800062f4:	e54a                	sd	s2,136(sp)
    800062f6:	e94e                	sd	s3,144(sp)
    800062f8:	ed52                	sd	s4,152(sp)
    800062fa:	f156                	sd	s5,160(sp)
    800062fc:	f55a                	sd	s6,168(sp)
    800062fe:	f95e                	sd	s7,176(sp)
    80006300:	fd62                	sd	s8,184(sp)
    80006302:	e1e6                	sd	s9,192(sp)
    80006304:	e5ea                	sd	s10,200(sp)
    80006306:	e9ee                	sd	s11,208(sp)
    80006308:	edf2                	sd	t3,216(sp)
    8000630a:	f1f6                	sd	t4,224(sp)
    8000630c:	f5fa                	sd	t5,232(sp)
    8000630e:	f9fe                	sd	t6,240(sp)
    80006310:	bd3fc0ef          	jal	80002ee2 <kerneltrap>
    80006314:	6082                	ld	ra,0(sp)
    80006316:	6122                	ld	sp,8(sp)
    80006318:	61c2                	ld	gp,16(sp)
    8000631a:	7282                	ld	t0,32(sp)
    8000631c:	7322                	ld	t1,40(sp)
    8000631e:	73c2                	ld	t2,48(sp)
    80006320:	7462                	ld	s0,56(sp)
    80006322:	6486                	ld	s1,64(sp)
    80006324:	6526                	ld	a0,72(sp)
    80006326:	65c6                	ld	a1,80(sp)
    80006328:	6666                	ld	a2,88(sp)
    8000632a:	7686                	ld	a3,96(sp)
    8000632c:	7726                	ld	a4,104(sp)
    8000632e:	77c6                	ld	a5,112(sp)
    80006330:	7866                	ld	a6,120(sp)
    80006332:	688a                	ld	a7,128(sp)
    80006334:	692a                	ld	s2,136(sp)
    80006336:	69ca                	ld	s3,144(sp)
    80006338:	6a6a                	ld	s4,152(sp)
    8000633a:	7a8a                	ld	s5,160(sp)
    8000633c:	7b2a                	ld	s6,168(sp)
    8000633e:	7bca                	ld	s7,176(sp)
    80006340:	7c6a                	ld	s8,184(sp)
    80006342:	6c8e                	ld	s9,192(sp)
    80006344:	6d2e                	ld	s10,200(sp)
    80006346:	6dce                	ld	s11,208(sp)
    80006348:	6e6e                	ld	t3,216(sp)
    8000634a:	7e8e                	ld	t4,224(sp)
    8000634c:	7f2e                	ld	t5,232(sp)
    8000634e:	7fce                	ld	t6,240(sp)
    80006350:	6111                	addi	sp,sp,256
    80006352:	10200073          	sret
    80006356:	00000013          	nop
    8000635a:	00000013          	nop
    8000635e:	0001                	nop

0000000080006360 <timervec>:
    80006360:	34051573          	csrrw	a0,mscratch,a0
    80006364:	e10c                	sd	a1,0(a0)
    80006366:	e510                	sd	a2,8(a0)
    80006368:	e914                	sd	a3,16(a0)
    8000636a:	6d0c                	ld	a1,24(a0)
    8000636c:	7110                	ld	a2,32(a0)
    8000636e:	6194                	ld	a3,0(a1)
    80006370:	96b2                	add	a3,a3,a2
    80006372:	e194                	sd	a3,0(a1)
    80006374:	4589                	li	a1,2
    80006376:	14459073          	csrw	sip,a1
    8000637a:	6914                	ld	a3,16(a0)
    8000637c:	6510                	ld	a2,8(a0)
    8000637e:	610c                	ld	a1,0(a0)
    80006380:	34051573          	csrrw	a0,mscratch,a0
    80006384:	30200073          	mret
	...

000000008000638a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000638a:	1141                	addi	sp,sp,-16
    8000638c:	e406                	sd	ra,8(sp)
    8000638e:	e022                	sd	s0,0(sp)
    80006390:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006392:	0c000737          	lui	a4,0xc000
    80006396:	4785                	li	a5,1
    80006398:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000639a:	c35c                	sw	a5,4(a4)
}
    8000639c:	60a2                	ld	ra,8(sp)
    8000639e:	6402                	ld	s0,0(sp)
    800063a0:	0141                	addi	sp,sp,16
    800063a2:	8082                	ret

00000000800063a4 <plicinithart>:

void
plicinithart(void)
{
    800063a4:	1141                	addi	sp,sp,-16
    800063a6:	e406                	sd	ra,8(sp)
    800063a8:	e022                	sd	s0,0(sp)
    800063aa:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800063ac:	ffffc097          	auipc	ra,0xffffc
    800063b0:	926080e7          	jalr	-1754(ra) # 80001cd2 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800063b4:	0085171b          	slliw	a4,a0,0x8
    800063b8:	0c0027b7          	lui	a5,0xc002
    800063bc:	97ba                	add	a5,a5,a4
    800063be:	40200713          	li	a4,1026
    800063c2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800063c6:	00d5151b          	slliw	a0,a0,0xd
    800063ca:	0c2017b7          	lui	a5,0xc201
    800063ce:	97aa                	add	a5,a5,a0
    800063d0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800063d4:	60a2                	ld	ra,8(sp)
    800063d6:	6402                	ld	s0,0(sp)
    800063d8:	0141                	addi	sp,sp,16
    800063da:	8082                	ret

00000000800063dc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800063dc:	1141                	addi	sp,sp,-16
    800063de:	e406                	sd	ra,8(sp)
    800063e0:	e022                	sd	s0,0(sp)
    800063e2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800063e4:	ffffc097          	auipc	ra,0xffffc
    800063e8:	8ee080e7          	jalr	-1810(ra) # 80001cd2 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800063ec:	00d5151b          	slliw	a0,a0,0xd
    800063f0:	0c2017b7          	lui	a5,0xc201
    800063f4:	97aa                	add	a5,a5,a0
  return irq;
}
    800063f6:	43c8                	lw	a0,4(a5)
    800063f8:	60a2                	ld	ra,8(sp)
    800063fa:	6402                	ld	s0,0(sp)
    800063fc:	0141                	addi	sp,sp,16
    800063fe:	8082                	ret

0000000080006400 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80006400:	1101                	addi	sp,sp,-32
    80006402:	ec06                	sd	ra,24(sp)
    80006404:	e822                	sd	s0,16(sp)
    80006406:	e426                	sd	s1,8(sp)
    80006408:	1000                	addi	s0,sp,32
    8000640a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000640c:	ffffc097          	auipc	ra,0xffffc
    80006410:	8c6080e7          	jalr	-1850(ra) # 80001cd2 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006414:	00d5179b          	slliw	a5,a0,0xd
    80006418:	0c201737          	lui	a4,0xc201
    8000641c:	97ba                	add	a5,a5,a4
    8000641e:	c3c4                	sw	s1,4(a5)
}
    80006420:	60e2                	ld	ra,24(sp)
    80006422:	6442                	ld	s0,16(sp)
    80006424:	64a2                	ld	s1,8(sp)
    80006426:	6105                	addi	sp,sp,32
    80006428:	8082                	ret

000000008000642a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000642a:	1141                	addi	sp,sp,-16
    8000642c:	e406                	sd	ra,8(sp)
    8000642e:	e022                	sd	s0,0(sp)
    80006430:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80006432:	479d                	li	a5,7
    80006434:	04a7cc63          	blt	a5,a0,8000648c <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80006438:	0001c797          	auipc	a5,0x1c
    8000643c:	b1878793          	addi	a5,a5,-1256 # 80021f50 <disk>
    80006440:	97aa                	add	a5,a5,a0
    80006442:	0187c783          	lbu	a5,24(a5)
    80006446:	ebb9                	bnez	a5,8000649c <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006448:	00451693          	slli	a3,a0,0x4
    8000644c:	0001c797          	auipc	a5,0x1c
    80006450:	b0478793          	addi	a5,a5,-1276 # 80021f50 <disk>
    80006454:	6398                	ld	a4,0(a5)
    80006456:	9736                	add	a4,a4,a3
    80006458:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    8000645c:	6398                	ld	a4,0(a5)
    8000645e:	9736                	add	a4,a4,a3
    80006460:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80006464:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006468:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    8000646c:	97aa                	add	a5,a5,a0
    8000646e:	4705                	li	a4,1
    80006470:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80006474:	0001c517          	auipc	a0,0x1c
    80006478:	af450513          	addi	a0,a0,-1292 # 80021f68 <disk+0x18>
    8000647c:	ffffc097          	auipc	ra,0xffffc
    80006480:	0d0080e7          	jalr	208(ra) # 8000254c <wakeup>
}
    80006484:	60a2                	ld	ra,8(sp)
    80006486:	6402                	ld	s0,0(sp)
    80006488:	0141                	addi	sp,sp,16
    8000648a:	8082                	ret
    panic("free_desc 1");
    8000648c:	00002517          	auipc	a0,0x2
    80006490:	28450513          	addi	a0,a0,644 # 80008710 <etext+0x710>
    80006494:	ffffa097          	auipc	ra,0xffffa
    80006498:	0cc080e7          	jalr	204(ra) # 80000560 <panic>
    panic("free_desc 2");
    8000649c:	00002517          	auipc	a0,0x2
    800064a0:	28450513          	addi	a0,a0,644 # 80008720 <etext+0x720>
    800064a4:	ffffa097          	auipc	ra,0xffffa
    800064a8:	0bc080e7          	jalr	188(ra) # 80000560 <panic>

00000000800064ac <virtio_disk_init>:
{
    800064ac:	1101                	addi	sp,sp,-32
    800064ae:	ec06                	sd	ra,24(sp)
    800064b0:	e822                	sd	s0,16(sp)
    800064b2:	e426                	sd	s1,8(sp)
    800064b4:	e04a                	sd	s2,0(sp)
    800064b6:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800064b8:	00002597          	auipc	a1,0x2
    800064bc:	27858593          	addi	a1,a1,632 # 80008730 <etext+0x730>
    800064c0:	0001c517          	auipc	a0,0x1c
    800064c4:	bb850513          	addi	a0,a0,-1096 # 80022078 <disk+0x128>
    800064c8:	ffffa097          	auipc	ra,0xffffa
    800064cc:	6e2080e7          	jalr	1762(ra) # 80000baa <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800064d0:	100017b7          	lui	a5,0x10001
    800064d4:	4398                	lw	a4,0(a5)
    800064d6:	2701                	sext.w	a4,a4
    800064d8:	747277b7          	lui	a5,0x74727
    800064dc:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800064e0:	16f71463          	bne	a4,a5,80006648 <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800064e4:	100017b7          	lui	a5,0x10001
    800064e8:	43dc                	lw	a5,4(a5)
    800064ea:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800064ec:	4709                	li	a4,2
    800064ee:	14e79d63          	bne	a5,a4,80006648 <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800064f2:	100017b7          	lui	a5,0x10001
    800064f6:	479c                	lw	a5,8(a5)
    800064f8:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800064fa:	14e79763          	bne	a5,a4,80006648 <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800064fe:	100017b7          	lui	a5,0x10001
    80006502:	47d8                	lw	a4,12(a5)
    80006504:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006506:	554d47b7          	lui	a5,0x554d4
    8000650a:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000650e:	12f71d63          	bne	a4,a5,80006648 <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006512:	100017b7          	lui	a5,0x10001
    80006516:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000651a:	4705                	li	a4,1
    8000651c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000651e:	470d                	li	a4,3
    80006520:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80006522:	10001737          	lui	a4,0x10001
    80006526:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80006528:	c7ffe6b7          	lui	a3,0xc7ffe
    8000652c:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc6cf>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006530:	8f75                	and	a4,a4,a3
    80006532:	100016b7          	lui	a3,0x10001
    80006536:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006538:	472d                	li	a4,11
    8000653a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000653c:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80006540:	439c                	lw	a5,0(a5)
    80006542:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80006546:	8ba1                	andi	a5,a5,8
    80006548:	10078863          	beqz	a5,80006658 <virtio_disk_init+0x1ac>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000654c:	100017b7          	lui	a5,0x10001
    80006550:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80006554:	43fc                	lw	a5,68(a5)
    80006556:	2781                	sext.w	a5,a5
    80006558:	10079863          	bnez	a5,80006668 <virtio_disk_init+0x1bc>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000655c:	100017b7          	lui	a5,0x10001
    80006560:	5bdc                	lw	a5,52(a5)
    80006562:	2781                	sext.w	a5,a5
  if(max == 0)
    80006564:	10078a63          	beqz	a5,80006678 <virtio_disk_init+0x1cc>
  if(max < NUM)
    80006568:	471d                	li	a4,7
    8000656a:	10f77f63          	bgeu	a4,a5,80006688 <virtio_disk_init+0x1dc>
  disk.desc = kalloc();
    8000656e:	ffffa097          	auipc	ra,0xffffa
    80006572:	5dc080e7          	jalr	1500(ra) # 80000b4a <kalloc>
    80006576:	0001c497          	auipc	s1,0x1c
    8000657a:	9da48493          	addi	s1,s1,-1574 # 80021f50 <disk>
    8000657e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006580:	ffffa097          	auipc	ra,0xffffa
    80006584:	5ca080e7          	jalr	1482(ra) # 80000b4a <kalloc>
    80006588:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000658a:	ffffa097          	auipc	ra,0xffffa
    8000658e:	5c0080e7          	jalr	1472(ra) # 80000b4a <kalloc>
    80006592:	87aa                	mv	a5,a0
    80006594:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006596:	6088                	ld	a0,0(s1)
    80006598:	10050063          	beqz	a0,80006698 <virtio_disk_init+0x1ec>
    8000659c:	0001c717          	auipc	a4,0x1c
    800065a0:	9bc73703          	ld	a4,-1604(a4) # 80021f58 <disk+0x8>
    800065a4:	cb75                	beqz	a4,80006698 <virtio_disk_init+0x1ec>
    800065a6:	cbed                	beqz	a5,80006698 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    800065a8:	6605                	lui	a2,0x1
    800065aa:	4581                	li	a1,0
    800065ac:	ffffa097          	auipc	ra,0xffffa
    800065b0:	78a080e7          	jalr	1930(ra) # 80000d36 <memset>
  memset(disk.avail, 0, PGSIZE);
    800065b4:	0001c497          	auipc	s1,0x1c
    800065b8:	99c48493          	addi	s1,s1,-1636 # 80021f50 <disk>
    800065bc:	6605                	lui	a2,0x1
    800065be:	4581                	li	a1,0
    800065c0:	6488                	ld	a0,8(s1)
    800065c2:	ffffa097          	auipc	ra,0xffffa
    800065c6:	774080e7          	jalr	1908(ra) # 80000d36 <memset>
  memset(disk.used, 0, PGSIZE);
    800065ca:	6605                	lui	a2,0x1
    800065cc:	4581                	li	a1,0
    800065ce:	6888                	ld	a0,16(s1)
    800065d0:	ffffa097          	auipc	ra,0xffffa
    800065d4:	766080e7          	jalr	1894(ra) # 80000d36 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800065d8:	100017b7          	lui	a5,0x10001
    800065dc:	4721                	li	a4,8
    800065de:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800065e0:	4098                	lw	a4,0(s1)
    800065e2:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800065e6:	40d8                	lw	a4,4(s1)
    800065e8:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800065ec:	649c                	ld	a5,8(s1)
    800065ee:	0007869b          	sext.w	a3,a5
    800065f2:	10001737          	lui	a4,0x10001
    800065f6:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800065fa:	9781                	srai	a5,a5,0x20
    800065fc:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80006600:	689c                	ld	a5,16(s1)
    80006602:	0007869b          	sext.w	a3,a5
    80006606:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000660a:	9781                	srai	a5,a5,0x20
    8000660c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80006610:	4785                	li	a5,1
    80006612:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80006614:	00f48c23          	sb	a5,24(s1)
    80006618:	00f48ca3          	sb	a5,25(s1)
    8000661c:	00f48d23          	sb	a5,26(s1)
    80006620:	00f48da3          	sb	a5,27(s1)
    80006624:	00f48e23          	sb	a5,28(s1)
    80006628:	00f48ea3          	sb	a5,29(s1)
    8000662c:	00f48f23          	sb	a5,30(s1)
    80006630:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80006634:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006638:	07272823          	sw	s2,112(a4)
}
    8000663c:	60e2                	ld	ra,24(sp)
    8000663e:	6442                	ld	s0,16(sp)
    80006640:	64a2                	ld	s1,8(sp)
    80006642:	6902                	ld	s2,0(sp)
    80006644:	6105                	addi	sp,sp,32
    80006646:	8082                	ret
    panic("could not find virtio disk");
    80006648:	00002517          	auipc	a0,0x2
    8000664c:	0f850513          	addi	a0,a0,248 # 80008740 <etext+0x740>
    80006650:	ffffa097          	auipc	ra,0xffffa
    80006654:	f10080e7          	jalr	-240(ra) # 80000560 <panic>
    panic("virtio disk FEATURES_OK unset");
    80006658:	00002517          	auipc	a0,0x2
    8000665c:	10850513          	addi	a0,a0,264 # 80008760 <etext+0x760>
    80006660:	ffffa097          	auipc	ra,0xffffa
    80006664:	f00080e7          	jalr	-256(ra) # 80000560 <panic>
    panic("virtio disk should not be ready");
    80006668:	00002517          	auipc	a0,0x2
    8000666c:	11850513          	addi	a0,a0,280 # 80008780 <etext+0x780>
    80006670:	ffffa097          	auipc	ra,0xffffa
    80006674:	ef0080e7          	jalr	-272(ra) # 80000560 <panic>
    panic("virtio disk has no queue 0");
    80006678:	00002517          	auipc	a0,0x2
    8000667c:	12850513          	addi	a0,a0,296 # 800087a0 <etext+0x7a0>
    80006680:	ffffa097          	auipc	ra,0xffffa
    80006684:	ee0080e7          	jalr	-288(ra) # 80000560 <panic>
    panic("virtio disk max queue too short");
    80006688:	00002517          	auipc	a0,0x2
    8000668c:	13850513          	addi	a0,a0,312 # 800087c0 <etext+0x7c0>
    80006690:	ffffa097          	auipc	ra,0xffffa
    80006694:	ed0080e7          	jalr	-304(ra) # 80000560 <panic>
    panic("virtio disk kalloc");
    80006698:	00002517          	auipc	a0,0x2
    8000669c:	14850513          	addi	a0,a0,328 # 800087e0 <etext+0x7e0>
    800066a0:	ffffa097          	auipc	ra,0xffffa
    800066a4:	ec0080e7          	jalr	-320(ra) # 80000560 <panic>

00000000800066a8 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800066a8:	711d                	addi	sp,sp,-96
    800066aa:	ec86                	sd	ra,88(sp)
    800066ac:	e8a2                	sd	s0,80(sp)
    800066ae:	e4a6                	sd	s1,72(sp)
    800066b0:	e0ca                	sd	s2,64(sp)
    800066b2:	fc4e                	sd	s3,56(sp)
    800066b4:	f852                	sd	s4,48(sp)
    800066b6:	f456                	sd	s5,40(sp)
    800066b8:	f05a                	sd	s6,32(sp)
    800066ba:	ec5e                	sd	s7,24(sp)
    800066bc:	e862                	sd	s8,16(sp)
    800066be:	1080                	addi	s0,sp,96
    800066c0:	89aa                	mv	s3,a0
    800066c2:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800066c4:	00c52b83          	lw	s7,12(a0)
    800066c8:	001b9b9b          	slliw	s7,s7,0x1
    800066cc:	1b82                	slli	s7,s7,0x20
    800066ce:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    800066d2:	0001c517          	auipc	a0,0x1c
    800066d6:	9a650513          	addi	a0,a0,-1626 # 80022078 <disk+0x128>
    800066da:	ffffa097          	auipc	ra,0xffffa
    800066de:	564080e7          	jalr	1380(ra) # 80000c3e <acquire>
  for(int i = 0; i < NUM; i++){
    800066e2:	44a1                	li	s1,8
      disk.free[i] = 0;
    800066e4:	0001ca97          	auipc	s5,0x1c
    800066e8:	86ca8a93          	addi	s5,s5,-1940 # 80021f50 <disk>
  for(int i = 0; i < 3; i++){
    800066ec:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    800066ee:	5c7d                	li	s8,-1
    800066f0:	a885                	j	80006760 <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800066f2:	00fa8733          	add	a4,s5,a5
    800066f6:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800066fa:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800066fc:	0207c563          	bltz	a5,80006726 <virtio_disk_rw+0x7e>
  for(int i = 0; i < 3; i++){
    80006700:	2905                	addiw	s2,s2,1
    80006702:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80006704:	07490263          	beq	s2,s4,80006768 <virtio_disk_rw+0xc0>
    idx[i] = alloc_desc();
    80006708:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000670a:	0001c717          	auipc	a4,0x1c
    8000670e:	84670713          	addi	a4,a4,-1978 # 80021f50 <disk>
    80006712:	4781                	li	a5,0
    if(disk.free[i]){
    80006714:	01874683          	lbu	a3,24(a4)
    80006718:	fee9                	bnez	a3,800066f2 <virtio_disk_rw+0x4a>
  for(int i = 0; i < NUM; i++){
    8000671a:	2785                	addiw	a5,a5,1
    8000671c:	0705                	addi	a4,a4,1
    8000671e:	fe979be3          	bne	a5,s1,80006714 <virtio_disk_rw+0x6c>
    idx[i] = alloc_desc();
    80006722:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80006726:	03205163          	blez	s2,80006748 <virtio_disk_rw+0xa0>
        free_desc(idx[j]);
    8000672a:	fa042503          	lw	a0,-96(s0)
    8000672e:	00000097          	auipc	ra,0x0
    80006732:	cfc080e7          	jalr	-772(ra) # 8000642a <free_desc>
      for(int j = 0; j < i; j++)
    80006736:	4785                	li	a5,1
    80006738:	0127d863          	bge	a5,s2,80006748 <virtio_disk_rw+0xa0>
        free_desc(idx[j]);
    8000673c:	fa442503          	lw	a0,-92(s0)
    80006740:	00000097          	auipc	ra,0x0
    80006744:	cea080e7          	jalr	-790(ra) # 8000642a <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006748:	0001c597          	auipc	a1,0x1c
    8000674c:	93058593          	addi	a1,a1,-1744 # 80022078 <disk+0x128>
    80006750:	0001c517          	auipc	a0,0x1c
    80006754:	81850513          	addi	a0,a0,-2024 # 80021f68 <disk+0x18>
    80006758:	ffffc097          	auipc	ra,0xffffc
    8000675c:	d90080e7          	jalr	-624(ra) # 800024e8 <sleep>
  for(int i = 0; i < 3; i++){
    80006760:	fa040613          	addi	a2,s0,-96
    80006764:	4901                	li	s2,0
    80006766:	b74d                	j	80006708 <virtio_disk_rw+0x60>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006768:	fa042503          	lw	a0,-96(s0)
    8000676c:	00451693          	slli	a3,a0,0x4

  if(write)
    80006770:	0001b797          	auipc	a5,0x1b
    80006774:	7e078793          	addi	a5,a5,2016 # 80021f50 <disk>
    80006778:	00a50713          	addi	a4,a0,10
    8000677c:	0712                	slli	a4,a4,0x4
    8000677e:	973e                	add	a4,a4,a5
    80006780:	01603633          	snez	a2,s6
    80006784:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006786:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    8000678a:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    8000678e:	6398                	ld	a4,0(a5)
    80006790:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006792:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80006796:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006798:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000679a:	6390                	ld	a2,0(a5)
    8000679c:	00d605b3          	add	a1,a2,a3
    800067a0:	4741                	li	a4,16
    800067a2:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800067a4:	4805                	li	a6,1
    800067a6:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    800067aa:	fa442703          	lw	a4,-92(s0)
    800067ae:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800067b2:	0712                	slli	a4,a4,0x4
    800067b4:	963a                	add	a2,a2,a4
    800067b6:	05898593          	addi	a1,s3,88
    800067ba:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800067bc:	0007b883          	ld	a7,0(a5)
    800067c0:	9746                	add	a4,a4,a7
    800067c2:	40000613          	li	a2,1024
    800067c6:	c710                	sw	a2,8(a4)
  if(write)
    800067c8:	001b3613          	seqz	a2,s6
    800067cc:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800067d0:	01066633          	or	a2,a2,a6
    800067d4:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800067d8:	fa842583          	lw	a1,-88(s0)
    800067dc:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800067e0:	00250613          	addi	a2,a0,2
    800067e4:	0612                	slli	a2,a2,0x4
    800067e6:	963e                	add	a2,a2,a5
    800067e8:	577d                	li	a4,-1
    800067ea:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800067ee:	0592                	slli	a1,a1,0x4
    800067f0:	98ae                	add	a7,a7,a1
    800067f2:	03068713          	addi	a4,a3,48
    800067f6:	973e                	add	a4,a4,a5
    800067f8:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    800067fc:	6398                	ld	a4,0(a5)
    800067fe:	972e                	add	a4,a4,a1
    80006800:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006804:	4689                	li	a3,2
    80006806:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    8000680a:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000680e:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    80006812:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006816:	6794                	ld	a3,8(a5)
    80006818:	0026d703          	lhu	a4,2(a3)
    8000681c:	8b1d                	andi	a4,a4,7
    8000681e:	0706                	slli	a4,a4,0x1
    80006820:	96ba                	add	a3,a3,a4
    80006822:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80006826:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000682a:	6798                	ld	a4,8(a5)
    8000682c:	00275783          	lhu	a5,2(a4)
    80006830:	2785                	addiw	a5,a5,1
    80006832:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006836:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000683a:	100017b7          	lui	a5,0x10001
    8000683e:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006842:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80006846:	0001c917          	auipc	s2,0x1c
    8000684a:	83290913          	addi	s2,s2,-1998 # 80022078 <disk+0x128>
  while(b->disk == 1) {
    8000684e:	84c2                	mv	s1,a6
    80006850:	01079c63          	bne	a5,a6,80006868 <virtio_disk_rw+0x1c0>
    sleep(b, &disk.vdisk_lock);
    80006854:	85ca                	mv	a1,s2
    80006856:	854e                	mv	a0,s3
    80006858:	ffffc097          	auipc	ra,0xffffc
    8000685c:	c90080e7          	jalr	-880(ra) # 800024e8 <sleep>
  while(b->disk == 1) {
    80006860:	0049a783          	lw	a5,4(s3)
    80006864:	fe9788e3          	beq	a5,s1,80006854 <virtio_disk_rw+0x1ac>
  }

  disk.info[idx[0]].b = 0;
    80006868:	fa042903          	lw	s2,-96(s0)
    8000686c:	00290713          	addi	a4,s2,2
    80006870:	0712                	slli	a4,a4,0x4
    80006872:	0001b797          	auipc	a5,0x1b
    80006876:	6de78793          	addi	a5,a5,1758 # 80021f50 <disk>
    8000687a:	97ba                	add	a5,a5,a4
    8000687c:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006880:	0001b997          	auipc	s3,0x1b
    80006884:	6d098993          	addi	s3,s3,1744 # 80021f50 <disk>
    80006888:	00491713          	slli	a4,s2,0x4
    8000688c:	0009b783          	ld	a5,0(s3)
    80006890:	97ba                	add	a5,a5,a4
    80006892:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006896:	854a                	mv	a0,s2
    80006898:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000689c:	00000097          	auipc	ra,0x0
    800068a0:	b8e080e7          	jalr	-1138(ra) # 8000642a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800068a4:	8885                	andi	s1,s1,1
    800068a6:	f0ed                	bnez	s1,80006888 <virtio_disk_rw+0x1e0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800068a8:	0001b517          	auipc	a0,0x1b
    800068ac:	7d050513          	addi	a0,a0,2000 # 80022078 <disk+0x128>
    800068b0:	ffffa097          	auipc	ra,0xffffa
    800068b4:	43e080e7          	jalr	1086(ra) # 80000cee <release>
}
    800068b8:	60e6                	ld	ra,88(sp)
    800068ba:	6446                	ld	s0,80(sp)
    800068bc:	64a6                	ld	s1,72(sp)
    800068be:	6906                	ld	s2,64(sp)
    800068c0:	79e2                	ld	s3,56(sp)
    800068c2:	7a42                	ld	s4,48(sp)
    800068c4:	7aa2                	ld	s5,40(sp)
    800068c6:	7b02                	ld	s6,32(sp)
    800068c8:	6be2                	ld	s7,24(sp)
    800068ca:	6c42                	ld	s8,16(sp)
    800068cc:	6125                	addi	sp,sp,96
    800068ce:	8082                	ret

00000000800068d0 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800068d0:	1101                	addi	sp,sp,-32
    800068d2:	ec06                	sd	ra,24(sp)
    800068d4:	e822                	sd	s0,16(sp)
    800068d6:	e426                	sd	s1,8(sp)
    800068d8:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800068da:	0001b497          	auipc	s1,0x1b
    800068de:	67648493          	addi	s1,s1,1654 # 80021f50 <disk>
    800068e2:	0001b517          	auipc	a0,0x1b
    800068e6:	79650513          	addi	a0,a0,1942 # 80022078 <disk+0x128>
    800068ea:	ffffa097          	auipc	ra,0xffffa
    800068ee:	354080e7          	jalr	852(ra) # 80000c3e <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800068f2:	100017b7          	lui	a5,0x10001
    800068f6:	53bc                	lw	a5,96(a5)
    800068f8:	8b8d                	andi	a5,a5,3
    800068fa:	10001737          	lui	a4,0x10001
    800068fe:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80006900:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006904:	689c                	ld	a5,16(s1)
    80006906:	0204d703          	lhu	a4,32(s1)
    8000690a:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    8000690e:	04f70863          	beq	a4,a5,8000695e <virtio_disk_intr+0x8e>
    __sync_synchronize();
    80006912:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006916:	6898                	ld	a4,16(s1)
    80006918:	0204d783          	lhu	a5,32(s1)
    8000691c:	8b9d                	andi	a5,a5,7
    8000691e:	078e                	slli	a5,a5,0x3
    80006920:	97ba                	add	a5,a5,a4
    80006922:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006924:	00278713          	addi	a4,a5,2
    80006928:	0712                	slli	a4,a4,0x4
    8000692a:	9726                	add	a4,a4,s1
    8000692c:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80006930:	e721                	bnez	a4,80006978 <virtio_disk_intr+0xa8>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006932:	0789                	addi	a5,a5,2
    80006934:	0792                	slli	a5,a5,0x4
    80006936:	97a6                	add	a5,a5,s1
    80006938:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000693a:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000693e:	ffffc097          	auipc	ra,0xffffc
    80006942:	c0e080e7          	jalr	-1010(ra) # 8000254c <wakeup>

    disk.used_idx += 1;
    80006946:	0204d783          	lhu	a5,32(s1)
    8000694a:	2785                	addiw	a5,a5,1
    8000694c:	17c2                	slli	a5,a5,0x30
    8000694e:	93c1                	srli	a5,a5,0x30
    80006950:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006954:	6898                	ld	a4,16(s1)
    80006956:	00275703          	lhu	a4,2(a4)
    8000695a:	faf71ce3          	bne	a4,a5,80006912 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    8000695e:	0001b517          	auipc	a0,0x1b
    80006962:	71a50513          	addi	a0,a0,1818 # 80022078 <disk+0x128>
    80006966:	ffffa097          	auipc	ra,0xffffa
    8000696a:	388080e7          	jalr	904(ra) # 80000cee <release>
}
    8000696e:	60e2                	ld	ra,24(sp)
    80006970:	6442                	ld	s0,16(sp)
    80006972:	64a2                	ld	s1,8(sp)
    80006974:	6105                	addi	sp,sp,32
    80006976:	8082                	ret
      panic("virtio_disk_intr status");
    80006978:	00002517          	auipc	a0,0x2
    8000697c:	e8050513          	addi	a0,a0,-384 # 800087f8 <etext+0x7f8>
    80006980:	ffffa097          	auipc	ra,0xffffa
    80006984:	be0080e7          	jalr	-1056(ra) # 80000560 <panic>
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
