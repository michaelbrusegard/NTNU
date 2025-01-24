
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000c117          	auipc	sp,0xc
    80000004:	8f010113          	addi	sp,sp,-1808 # 8000b8f0 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	1e4000ef          	jal	800001fa <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <r_mhartid>:
#ifndef __ASSEMBLER__

// which hart (core) is this?
static inline uint64
r_mhartid()
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	1000                	addi	s0,sp,32
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000024:	f14027f3          	csrr	a5,mhartid
    80000028:	fef43423          	sd	a5,-24(s0)
  return x;
    8000002c:	fe843783          	ld	a5,-24(s0)
}
    80000030:	853e                	mv	a0,a5
    80000032:	60e2                	ld	ra,24(sp)
    80000034:	6442                	ld	s0,16(sp)
    80000036:	6105                	addi	sp,sp,32
    80000038:	8082                	ret

000000008000003a <r_mstatus>:
#define MSTATUS_MPP_U (0L << 11)
#define MSTATUS_MIE (1L << 3)    // machine-mode interrupt enable.

static inline uint64
r_mstatus()
{
    8000003a:	1101                	addi	sp,sp,-32
    8000003c:	ec06                	sd	ra,24(sp)
    8000003e:	e822                	sd	s0,16(sp)
    80000040:	1000                	addi	s0,sp,32
  uint64 x;
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000042:	300027f3          	csrr	a5,mstatus
    80000046:	fef43423          	sd	a5,-24(s0)
  return x;
    8000004a:	fe843783          	ld	a5,-24(s0)
}
    8000004e:	853e                	mv	a0,a5
    80000050:	60e2                	ld	ra,24(sp)
    80000052:	6442                	ld	s0,16(sp)
    80000054:	6105                	addi	sp,sp,32
    80000056:	8082                	ret

0000000080000058 <w_mstatus>:

static inline void 
w_mstatus(uint64 x)
{
    80000058:	1101                	addi	sp,sp,-32
    8000005a:	ec06                	sd	ra,24(sp)
    8000005c:	e822                	sd	s0,16(sp)
    8000005e:	1000                	addi	s0,sp,32
    80000060:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000064:	fe843783          	ld	a5,-24(s0)
    80000068:	30079073          	csrw	mstatus,a5
}
    8000006c:	0001                	nop
    8000006e:	60e2                	ld	ra,24(sp)
    80000070:	6442                	ld	s0,16(sp)
    80000072:	6105                	addi	sp,sp,32
    80000074:	8082                	ret

0000000080000076 <w_mepc>:
// machine exception program counter, holds the
// instruction address to which a return from
// exception will go.
static inline void 
w_mepc(uint64 x)
{
    80000076:	1101                	addi	sp,sp,-32
    80000078:	ec06                	sd	ra,24(sp)
    8000007a:	e822                	sd	s0,16(sp)
    8000007c:	1000                	addi	s0,sp,32
    8000007e:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000082:	fe843783          	ld	a5,-24(s0)
    80000086:	34179073          	csrw	mepc,a5
}
    8000008a:	0001                	nop
    8000008c:	60e2                	ld	ra,24(sp)
    8000008e:	6442                	ld	s0,16(sp)
    80000090:	6105                	addi	sp,sp,32
    80000092:	8082                	ret

0000000080000094 <r_sie>:
#define SIE_SEIE (1L << 9) // external
#define SIE_STIE (1L << 5) // timer
#define SIE_SSIE (1L << 1) // software
static inline uint64
r_sie()
{
    80000094:	1101                	addi	sp,sp,-32
    80000096:	ec06                	sd	ra,24(sp)
    80000098:	e822                	sd	s0,16(sp)
    8000009a:	1000                	addi	s0,sp,32
  uint64 x;
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000009c:	104027f3          	csrr	a5,sie
    800000a0:	fef43423          	sd	a5,-24(s0)
  return x;
    800000a4:	fe843783          	ld	a5,-24(s0)
}
    800000a8:	853e                	mv	a0,a5
    800000aa:	60e2                	ld	ra,24(sp)
    800000ac:	6442                	ld	s0,16(sp)
    800000ae:	6105                	addi	sp,sp,32
    800000b0:	8082                	ret

00000000800000b2 <w_sie>:

static inline void 
w_sie(uint64 x)
{
    800000b2:	1101                	addi	sp,sp,-32
    800000b4:	ec06                	sd	ra,24(sp)
    800000b6:	e822                	sd	s0,16(sp)
    800000b8:	1000                	addi	s0,sp,32
    800000ba:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw sie, %0" : : "r" (x));
    800000be:	fe843783          	ld	a5,-24(s0)
    800000c2:	10479073          	csrw	sie,a5
}
    800000c6:	0001                	nop
    800000c8:	60e2                	ld	ra,24(sp)
    800000ca:	6442                	ld	s0,16(sp)
    800000cc:	6105                	addi	sp,sp,32
    800000ce:	8082                	ret

00000000800000d0 <r_mie>:
#define MIE_MEIE (1L << 11) // external
#define MIE_MTIE (1L << 7)  // timer
#define MIE_MSIE (1L << 3)  // software
static inline uint64
r_mie()
{
    800000d0:	1101                	addi	sp,sp,-32
    800000d2:	ec06                	sd	ra,24(sp)
    800000d4:	e822                	sd	s0,16(sp)
    800000d6:	1000                	addi	s0,sp,32
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    800000d8:	304027f3          	csrr	a5,mie
    800000dc:	fef43423          	sd	a5,-24(s0)
  return x;
    800000e0:	fe843783          	ld	a5,-24(s0)
}
    800000e4:	853e                	mv	a0,a5
    800000e6:	60e2                	ld	ra,24(sp)
    800000e8:	6442                	ld	s0,16(sp)
    800000ea:	6105                	addi	sp,sp,32
    800000ec:	8082                	ret

00000000800000ee <w_mie>:

static inline void 
w_mie(uint64 x)
{
    800000ee:	1101                	addi	sp,sp,-32
    800000f0:	ec06                	sd	ra,24(sp)
    800000f2:	e822                	sd	s0,16(sp)
    800000f4:	1000                	addi	s0,sp,32
    800000f6:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw mie, %0" : : "r" (x));
    800000fa:	fe843783          	ld	a5,-24(s0)
    800000fe:	30479073          	csrw	mie,a5
}
    80000102:	0001                	nop
    80000104:	60e2                	ld	ra,24(sp)
    80000106:	6442                	ld	s0,16(sp)
    80000108:	6105                	addi	sp,sp,32
    8000010a:	8082                	ret

000000008000010c <w_medeleg>:
  return x;
}

static inline void 
w_medeleg(uint64 x)
{
    8000010c:	1101                	addi	sp,sp,-32
    8000010e:	ec06                	sd	ra,24(sp)
    80000110:	e822                	sd	s0,16(sp)
    80000112:	1000                	addi	s0,sp,32
    80000114:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000118:	fe843783          	ld	a5,-24(s0)
    8000011c:	30279073          	csrw	medeleg,a5
}
    80000120:	0001                	nop
    80000122:	60e2                	ld	ra,24(sp)
    80000124:	6442                	ld	s0,16(sp)
    80000126:	6105                	addi	sp,sp,32
    80000128:	8082                	ret

000000008000012a <w_mideleg>:
  return x;
}

static inline void 
w_mideleg(uint64 x)
{
    8000012a:	1101                	addi	sp,sp,-32
    8000012c:	ec06                	sd	ra,24(sp)
    8000012e:	e822                	sd	s0,16(sp)
    80000130:	1000                	addi	s0,sp,32
    80000132:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80000136:	fe843783          	ld	a5,-24(s0)
    8000013a:	30379073          	csrw	mideleg,a5
}
    8000013e:	0001                	nop
    80000140:	60e2                	ld	ra,24(sp)
    80000142:	6442                	ld	s0,16(sp)
    80000144:	6105                	addi	sp,sp,32
    80000146:	8082                	ret

0000000080000148 <w_mtvec>:
}

// Machine-mode interrupt vector
static inline void 
w_mtvec(uint64 x)
{
    80000148:	1101                	addi	sp,sp,-32
    8000014a:	ec06                	sd	ra,24(sp)
    8000014c:	e822                	sd	s0,16(sp)
    8000014e:	1000                	addi	s0,sp,32
    80000150:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000154:	fe843783          	ld	a5,-24(s0)
    80000158:	30579073          	csrw	mtvec,a5
}
    8000015c:	0001                	nop
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret

0000000080000166 <w_pmpcfg0>:

// Physical Memory Protection
static inline void
w_pmpcfg0(uint64 x)
{
    80000166:	1101                	addi	sp,sp,-32
    80000168:	ec06                	sd	ra,24(sp)
    8000016a:	e822                	sd	s0,16(sp)
    8000016c:	1000                	addi	s0,sp,32
    8000016e:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80000172:	fe843783          	ld	a5,-24(s0)
    80000176:	3a079073          	csrw	pmpcfg0,a5
}
    8000017a:	0001                	nop
    8000017c:	60e2                	ld	ra,24(sp)
    8000017e:	6442                	ld	s0,16(sp)
    80000180:	6105                	addi	sp,sp,32
    80000182:	8082                	ret

0000000080000184 <w_pmpaddr0>:

static inline void
w_pmpaddr0(uint64 x)
{
    80000184:	1101                	addi	sp,sp,-32
    80000186:	ec06                	sd	ra,24(sp)
    80000188:	e822                	sd	s0,16(sp)
    8000018a:	1000                	addi	s0,sp,32
    8000018c:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80000190:	fe843783          	ld	a5,-24(s0)
    80000194:	3b079073          	csrw	pmpaddr0,a5
}
    80000198:	0001                	nop
    8000019a:	60e2                	ld	ra,24(sp)
    8000019c:	6442                	ld	s0,16(sp)
    8000019e:	6105                	addi	sp,sp,32
    800001a0:	8082                	ret

00000000800001a2 <w_satp>:

// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
    800001a2:	1101                	addi	sp,sp,-32
    800001a4:	ec06                	sd	ra,24(sp)
    800001a6:	e822                	sd	s0,16(sp)
    800001a8:	1000                	addi	s0,sp,32
    800001aa:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw satp, %0" : : "r" (x));
    800001ae:	fe843783          	ld	a5,-24(s0)
    800001b2:	18079073          	csrw	satp,a5
}
    800001b6:	0001                	nop
    800001b8:	60e2                	ld	ra,24(sp)
    800001ba:	6442                	ld	s0,16(sp)
    800001bc:	6105                	addi	sp,sp,32
    800001be:	8082                	ret

00000000800001c0 <w_mscratch>:
  return x;
}

static inline void 
w_mscratch(uint64 x)
{
    800001c0:	1101                	addi	sp,sp,-32
    800001c2:	ec06                	sd	ra,24(sp)
    800001c4:	e822                	sd	s0,16(sp)
    800001c6:	1000                	addi	s0,sp,32
    800001c8:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800001cc:	fe843783          	ld	a5,-24(s0)
    800001d0:	34079073          	csrw	mscratch,a5
}
    800001d4:	0001                	nop
    800001d6:	60e2                	ld	ra,24(sp)
    800001d8:	6442                	ld	s0,16(sp)
    800001da:	6105                	addi	sp,sp,32
    800001dc:	8082                	ret

00000000800001de <w_tp>:
  return x;
}

static inline void 
w_tp(uint64 x)
{
    800001de:	1101                	addi	sp,sp,-32
    800001e0:	ec06                	sd	ra,24(sp)
    800001e2:	e822                	sd	s0,16(sp)
    800001e4:	1000                	addi	s0,sp,32
    800001e6:	fea43423          	sd	a0,-24(s0)
  asm volatile("mv tp, %0" : : "r" (x));
    800001ea:	fe843783          	ld	a5,-24(s0)
    800001ee:	823e                	mv	tp,a5
}
    800001f0:	0001                	nop
    800001f2:	60e2                	ld	ra,24(sp)
    800001f4:	6442                	ld	s0,16(sp)
    800001f6:	6105                	addi	sp,sp,32
    800001f8:	8082                	ret

00000000800001fa <start>:
extern void timervec();

// entry.S jumps here in machine mode on stack0.
void
start()
{
    800001fa:	1101                	addi	sp,sp,-32
    800001fc:	ec06                	sd	ra,24(sp)
    800001fe:	e822                	sd	s0,16(sp)
    80000200:	1000                	addi	s0,sp,32
  // set M Previous Privilege mode to Supervisor, for mret.
  unsigned long x = r_mstatus();
    80000202:	00000097          	auipc	ra,0x0
    80000206:	e38080e7          	jalr	-456(ra) # 8000003a <r_mstatus>
    8000020a:	fea43423          	sd	a0,-24(s0)
  x &= ~MSTATUS_MPP_MASK;
    8000020e:	fe843703          	ld	a4,-24(s0)
    80000212:	77f9                	lui	a5,0xffffe
    80000214:	7ff78793          	addi	a5,a5,2047 # ffffffffffffe7ff <end+0xffffffff7ffd9a97>
    80000218:	8ff9                	and	a5,a5,a4
    8000021a:	fef43423          	sd	a5,-24(s0)
  x |= MSTATUS_MPP_S;
    8000021e:	fe843703          	ld	a4,-24(s0)
    80000222:	6785                	lui	a5,0x1
    80000224:	80078793          	addi	a5,a5,-2048 # 800 <_entry-0x7ffff800>
    80000228:	8fd9                	or	a5,a5,a4
    8000022a:	fef43423          	sd	a5,-24(s0)
  w_mstatus(x);
    8000022e:	fe843503          	ld	a0,-24(s0)
    80000232:	00000097          	auipc	ra,0x0
    80000236:	e26080e7          	jalr	-474(ra) # 80000058 <w_mstatus>

  // set M Exception Program Counter to main, for mret.
  // requires gcc -mcmodel=medany
  w_mepc((uint64)main);
    8000023a:	00001797          	auipc	a5,0x1
    8000023e:	63078793          	addi	a5,a5,1584 # 8000186a <main>
    80000242:	853e                	mv	a0,a5
    80000244:	00000097          	auipc	ra,0x0
    80000248:	e32080e7          	jalr	-462(ra) # 80000076 <w_mepc>

  // disable paging for now.
  w_satp(0);
    8000024c:	4501                	li	a0,0
    8000024e:	00000097          	auipc	ra,0x0
    80000252:	f54080e7          	jalr	-172(ra) # 800001a2 <w_satp>

  // delegate all interrupts and exceptions to supervisor mode.
  w_medeleg(0xffff);
    80000256:	67c1                	lui	a5,0x10
    80000258:	fff78513          	addi	a0,a5,-1 # ffff <_entry-0x7fff0001>
    8000025c:	00000097          	auipc	ra,0x0
    80000260:	eb0080e7          	jalr	-336(ra) # 8000010c <w_medeleg>
  w_mideleg(0xffff);
    80000264:	67c1                	lui	a5,0x10
    80000266:	fff78513          	addi	a0,a5,-1 # ffff <_entry-0x7fff0001>
    8000026a:	00000097          	auipc	ra,0x0
    8000026e:	ec0080e7          	jalr	-320(ra) # 8000012a <w_mideleg>
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80000272:	00000097          	auipc	ra,0x0
    80000276:	e22080e7          	jalr	-478(ra) # 80000094 <r_sie>
    8000027a:	87aa                	mv	a5,a0
    8000027c:	2227e793          	ori	a5,a5,546
    80000280:	853e                	mv	a0,a5
    80000282:	00000097          	auipc	ra,0x0
    80000286:	e30080e7          	jalr	-464(ra) # 800000b2 <w_sie>

  // configure Physical Memory Protection to give supervisor mode
  // access to all of physical memory.
  w_pmpaddr0(0x3fffffffffffffull);
    8000028a:	57fd                	li	a5,-1
    8000028c:	00a7d513          	srli	a0,a5,0xa
    80000290:	00000097          	auipc	ra,0x0
    80000294:	ef4080e7          	jalr	-268(ra) # 80000184 <w_pmpaddr0>
  w_pmpcfg0(0xf);
    80000298:	453d                	li	a0,15
    8000029a:	00000097          	auipc	ra,0x0
    8000029e:	ecc080e7          	jalr	-308(ra) # 80000166 <w_pmpcfg0>

  // ask for clock interrupts.
  timerinit();
    800002a2:	00000097          	auipc	ra,0x0
    800002a6:	032080e7          	jalr	50(ra) # 800002d4 <timerinit>

  // keep each CPU's hartid in its tp register, for cpuid().
  int id = r_mhartid();
    800002aa:	00000097          	auipc	ra,0x0
    800002ae:	d72080e7          	jalr	-654(ra) # 8000001c <r_mhartid>
    800002b2:	87aa                	mv	a5,a0
    800002b4:	fef42223          	sw	a5,-28(s0)
  w_tp(id);
    800002b8:	fe442783          	lw	a5,-28(s0)
    800002bc:	853e                	mv	a0,a5
    800002be:	00000097          	auipc	ra,0x0
    800002c2:	f20080e7          	jalr	-224(ra) # 800001de <w_tp>

  // switch to supervisor mode and jump to main().
  asm volatile("mret");
    800002c6:	30200073          	mret
}
    800002ca:	0001                	nop
    800002cc:	60e2                	ld	ra,24(sp)
    800002ce:	6442                	ld	s0,16(sp)
    800002d0:	6105                	addi	sp,sp,32
    800002d2:	8082                	ret

00000000800002d4 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800002d4:	1101                	addi	sp,sp,-32
    800002d6:	ec06                	sd	ra,24(sp)
    800002d8:	e822                	sd	s0,16(sp)
    800002da:	1000                	addi	s0,sp,32
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800002dc:	00000097          	auipc	ra,0x0
    800002e0:	d40080e7          	jalr	-704(ra) # 8000001c <r_mhartid>
    800002e4:	87aa                	mv	a5,a0
    800002e6:	fef42623          	sw	a5,-20(s0)

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
    800002ea:	000f47b7          	lui	a5,0xf4
    800002ee:	24078793          	addi	a5,a5,576 # f4240 <_entry-0x7ff0bdc0>
    800002f2:	fef42423          	sw	a5,-24(s0)
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800002f6:	0200c7b7          	lui	a5,0x200c
    800002fa:	17e1                	addi	a5,a5,-8 # 200bff8 <_entry-0x7dff4008>
    800002fc:	6398                	ld	a4,0(a5)
    800002fe:	fe842783          	lw	a5,-24(s0)
    80000302:	fec42683          	lw	a3,-20(s0)
    80000306:	0036969b          	slliw	a3,a3,0x3
    8000030a:	2681                	sext.w	a3,a3
    8000030c:	8636                	mv	a2,a3
    8000030e:	020046b7          	lui	a3,0x2004
    80000312:	96b2                	add	a3,a3,a2
    80000314:	97ba                	add	a5,a5,a4
    80000316:	e29c                	sd	a5,0(a3)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000318:	fec42703          	lw	a4,-20(s0)
    8000031c:	87ba                	mv	a5,a4
    8000031e:	078a                	slli	a5,a5,0x2
    80000320:	97ba                	add	a5,a5,a4
    80000322:	078e                	slli	a5,a5,0x3
    80000324:	00013717          	auipc	a4,0x13
    80000328:	5cc70713          	addi	a4,a4,1484 # 800138f0 <timer_scratch>
    8000032c:	97ba                	add	a5,a5,a4
    8000032e:	fef43023          	sd	a5,-32(s0)
  scratch[3] = CLINT_MTIMECMP(id);
    80000332:	fec42783          	lw	a5,-20(s0)
    80000336:	0037979b          	slliw	a5,a5,0x3
    8000033a:	2781                	sext.w	a5,a5
    8000033c:	873e                	mv	a4,a5
    8000033e:	020047b7          	lui	a5,0x2004
    80000342:	973e                	add	a4,a4,a5
    80000344:	fe043783          	ld	a5,-32(s0)
    80000348:	07e1                	addi	a5,a5,24 # 2004018 <_entry-0x7dffbfe8>
    8000034a:	e398                	sd	a4,0(a5)
  scratch[4] = interval;
    8000034c:	fe043783          	ld	a5,-32(s0)
    80000350:	02078793          	addi	a5,a5,32
    80000354:	fe842703          	lw	a4,-24(s0)
    80000358:	e398                	sd	a4,0(a5)
  w_mscratch((uint64)scratch);
    8000035a:	fe043783          	ld	a5,-32(s0)
    8000035e:	853e                	mv	a0,a5
    80000360:	00000097          	auipc	ra,0x0
    80000364:	e60080e7          	jalr	-416(ra) # 800001c0 <w_mscratch>

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);
    80000368:	00008797          	auipc	a5,0x8
    8000036c:	52878793          	addi	a5,a5,1320 # 80008890 <timervec>
    80000370:	853e                	mv	a0,a5
    80000372:	00000097          	auipc	ra,0x0
    80000376:	dd6080e7          	jalr	-554(ra) # 80000148 <w_mtvec>

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000037a:	00000097          	auipc	ra,0x0
    8000037e:	cc0080e7          	jalr	-832(ra) # 8000003a <r_mstatus>
    80000382:	87aa                	mv	a5,a0
    80000384:	0087e793          	ori	a5,a5,8
    80000388:	853e                	mv	a0,a5
    8000038a:	00000097          	auipc	ra,0x0
    8000038e:	cce080e7          	jalr	-818(ra) # 80000058 <w_mstatus>

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000392:	00000097          	auipc	ra,0x0
    80000396:	d3e080e7          	jalr	-706(ra) # 800000d0 <r_mie>
    8000039a:	87aa                	mv	a5,a0
    8000039c:	0807e793          	ori	a5,a5,128
    800003a0:	853e                	mv	a0,a5
    800003a2:	00000097          	auipc	ra,0x0
    800003a6:	d4c080e7          	jalr	-692(ra) # 800000ee <w_mie>
}
    800003aa:	0001                	nop
    800003ac:	60e2                	ld	ra,24(sp)
    800003ae:	6442                	ld	s0,16(sp)
    800003b0:	6105                	addi	sp,sp,32
    800003b2:	8082                	ret

00000000800003b4 <consputc>:
// called by printf(), and to echo input characters,
// but not from write().
//
void
consputc(int c)
{
    800003b4:	1101                	addi	sp,sp,-32
    800003b6:	ec06                	sd	ra,24(sp)
    800003b8:	e822                	sd	s0,16(sp)
    800003ba:	1000                	addi	s0,sp,32
    800003bc:	87aa                	mv	a5,a0
    800003be:	fef42623          	sw	a5,-20(s0)
  if(c == BACKSPACE){
    800003c2:	fec42783          	lw	a5,-20(s0)
    800003c6:	0007871b          	sext.w	a4,a5
    800003ca:	10000793          	li	a5,256
    800003ce:	02f71363          	bne	a4,a5,800003f4 <consputc+0x40>
    // if the user typed backspace, overwrite with a space.
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800003d2:	4521                	li	a0,8
    800003d4:	00001097          	auipc	ra,0x1
    800003d8:	ab0080e7          	jalr	-1360(ra) # 80000e84 <uartputc_sync>
    800003dc:	02000513          	li	a0,32
    800003e0:	00001097          	auipc	ra,0x1
    800003e4:	aa4080e7          	jalr	-1372(ra) # 80000e84 <uartputc_sync>
    800003e8:	4521                	li	a0,8
    800003ea:	00001097          	auipc	ra,0x1
    800003ee:	a9a080e7          	jalr	-1382(ra) # 80000e84 <uartputc_sync>
  } else {
    uartputc_sync(c);
  }
}
    800003f2:	a801                	j	80000402 <consputc+0x4e>
    uartputc_sync(c);
    800003f4:	fec42783          	lw	a5,-20(s0)
    800003f8:	853e                	mv	a0,a5
    800003fa:	00001097          	auipc	ra,0x1
    800003fe:	a8a080e7          	jalr	-1398(ra) # 80000e84 <uartputc_sync>
}
    80000402:	0001                	nop
    80000404:	60e2                	ld	ra,24(sp)
    80000406:	6442                	ld	s0,16(sp)
    80000408:	6105                	addi	sp,sp,32
    8000040a:	8082                	ret

000000008000040c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000040c:	7179                	addi	sp,sp,-48
    8000040e:	f406                	sd	ra,40(sp)
    80000410:	f022                	sd	s0,32(sp)
    80000412:	1800                	addi	s0,sp,48
    80000414:	87aa                	mv	a5,a0
    80000416:	fcb43823          	sd	a1,-48(s0)
    8000041a:	8732                	mv	a4,a2
    8000041c:	fcf42e23          	sw	a5,-36(s0)
    80000420:	87ba                	mv	a5,a4
    80000422:	fcf42c23          	sw	a5,-40(s0)
  int i;

  for(i = 0; i < n; i++){
    80000426:	fe042623          	sw	zero,-20(s0)
    8000042a:	a0a1                	j	80000472 <consolewrite+0x66>
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000042c:	fec42703          	lw	a4,-20(s0)
    80000430:	fd043783          	ld	a5,-48(s0)
    80000434:	00f70633          	add	a2,a4,a5
    80000438:	fdc42703          	lw	a4,-36(s0)
    8000043c:	feb40793          	addi	a5,s0,-21
    80000440:	4685                	li	a3,1
    80000442:	85ba                	mv	a1,a4
    80000444:	853e                	mv	a0,a5
    80000446:	00003097          	auipc	ra,0x3
    8000044a:	2ca080e7          	jalr	714(ra) # 80003710 <either_copyin>
    8000044e:	87aa                	mv	a5,a0
    80000450:	873e                	mv	a4,a5
    80000452:	57fd                	li	a5,-1
    80000454:	02f70963          	beq	a4,a5,80000486 <consolewrite+0x7a>
      break;
    uartputc(c);
    80000458:	feb44783          	lbu	a5,-21(s0)
    8000045c:	2781                	sext.w	a5,a5
    8000045e:	853e                	mv	a0,a5
    80000460:	00001097          	auipc	ra,0x1
    80000464:	964080e7          	jalr	-1692(ra) # 80000dc4 <uartputc>
  for(i = 0; i < n; i++){
    80000468:	fec42783          	lw	a5,-20(s0)
    8000046c:	2785                	addiw	a5,a5,1
    8000046e:	fef42623          	sw	a5,-20(s0)
    80000472:	fec42783          	lw	a5,-20(s0)
    80000476:	873e                	mv	a4,a5
    80000478:	fd842783          	lw	a5,-40(s0)
    8000047c:	2701                	sext.w	a4,a4
    8000047e:	2781                	sext.w	a5,a5
    80000480:	faf746e3          	blt	a4,a5,8000042c <consolewrite+0x20>
    80000484:	a011                	j	80000488 <consolewrite+0x7c>
      break;
    80000486:	0001                	nop
  }

  return i;
    80000488:	fec42783          	lw	a5,-20(s0)
}
    8000048c:	853e                	mv	a0,a5
    8000048e:	70a2                	ld	ra,40(sp)
    80000490:	7402                	ld	s0,32(sp)
    80000492:	6145                	addi	sp,sp,48
    80000494:	8082                	ret

0000000080000496 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000496:	7179                	addi	sp,sp,-48
    80000498:	f406                	sd	ra,40(sp)
    8000049a:	f022                	sd	s0,32(sp)
    8000049c:	1800                	addi	s0,sp,48
    8000049e:	87aa                	mv	a5,a0
    800004a0:	fcb43823          	sd	a1,-48(s0)
    800004a4:	8732                	mv	a4,a2
    800004a6:	fcf42e23          	sw	a5,-36(s0)
    800004aa:	87ba                	mv	a5,a4
    800004ac:	fcf42c23          	sw	a5,-40(s0)
  uint target;
  int c;
  char cbuf;

  target = n;
    800004b0:	fd842783          	lw	a5,-40(s0)
    800004b4:	fef42623          	sw	a5,-20(s0)
  acquire(&cons.lock);
    800004b8:	00013517          	auipc	a0,0x13
    800004bc:	57850513          	addi	a0,a0,1400 # 80013a30 <cons>
    800004c0:	00001097          	auipc	ra,0x1
    800004c4:	e04080e7          	jalr	-508(ra) # 800012c4 <acquire>
  while(n > 0){
    800004c8:	a235                	j	800005f4 <consoleread+0x15e>
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
      if(killed(myproc())){
    800004ca:	00002097          	auipc	ra,0x2
    800004ce:	3f2080e7          	jalr	1010(ra) # 800028bc <myproc>
    800004d2:	87aa                	mv	a5,a0
    800004d4:	853e                	mv	a0,a5
    800004d6:	00003097          	auipc	ra,0x3
    800004da:	186080e7          	jalr	390(ra) # 8000365c <killed>
    800004de:	87aa                	mv	a5,a0
    800004e0:	cb99                	beqz	a5,800004f6 <consoleread+0x60>
        release(&cons.lock);
    800004e2:	00013517          	auipc	a0,0x13
    800004e6:	54e50513          	addi	a0,a0,1358 # 80013a30 <cons>
    800004ea:	00001097          	auipc	ra,0x1
    800004ee:	e3e080e7          	jalr	-450(ra) # 80001328 <release>
        return -1;
    800004f2:	57fd                	li	a5,-1
    800004f4:	aa15                	j	80000628 <consoleread+0x192>
      }
      sleep(&cons.r, &cons.lock);
    800004f6:	00013597          	auipc	a1,0x13
    800004fa:	53a58593          	addi	a1,a1,1338 # 80013a30 <cons>
    800004fe:	00013517          	auipc	a0,0x13
    80000502:	5ca50513          	addi	a0,a0,1482 # 80013ac8 <cons+0x98>
    80000506:	00003097          	auipc	ra,0x3
    8000050a:	f70080e7          	jalr	-144(ra) # 80003476 <sleep>
    while(cons.r == cons.w){
    8000050e:	00013797          	auipc	a5,0x13
    80000512:	52278793          	addi	a5,a5,1314 # 80013a30 <cons>
    80000516:	0987a703          	lw	a4,152(a5)
    8000051a:	00013797          	auipc	a5,0x13
    8000051e:	51678793          	addi	a5,a5,1302 # 80013a30 <cons>
    80000522:	09c7a783          	lw	a5,156(a5)
    80000526:	faf702e3          	beq	a4,a5,800004ca <consoleread+0x34>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    8000052a:	00013797          	auipc	a5,0x13
    8000052e:	50678793          	addi	a5,a5,1286 # 80013a30 <cons>
    80000532:	0987a783          	lw	a5,152(a5)
    80000536:	0017871b          	addiw	a4,a5,1
    8000053a:	0007069b          	sext.w	a3,a4
    8000053e:	00013717          	auipc	a4,0x13
    80000542:	4f270713          	addi	a4,a4,1266 # 80013a30 <cons>
    80000546:	08d72c23          	sw	a3,152(a4)
    8000054a:	07f7f793          	andi	a5,a5,127
    8000054e:	2781                	sext.w	a5,a5
    80000550:	00013717          	auipc	a4,0x13
    80000554:	4e070713          	addi	a4,a4,1248 # 80013a30 <cons>
    80000558:	1782                	slli	a5,a5,0x20
    8000055a:	9381                	srli	a5,a5,0x20
    8000055c:	97ba                	add	a5,a5,a4
    8000055e:	0187c783          	lbu	a5,24(a5)
    80000562:	fef42423          	sw	a5,-24(s0)

    if(c == C('D')){  // end-of-file
    80000566:	fe842783          	lw	a5,-24(s0)
    8000056a:	0007871b          	sext.w	a4,a5
    8000056e:	4791                	li	a5,4
    80000570:	02f71963          	bne	a4,a5,800005a2 <consoleread+0x10c>
      if(n < target){
    80000574:	fd842783          	lw	a5,-40(s0)
    80000578:	fec42703          	lw	a4,-20(s0)
    8000057c:	2701                	sext.w	a4,a4
    8000057e:	08e7f163          	bgeu	a5,a4,80000600 <consoleread+0x16a>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        cons.r--;
    80000582:	00013797          	auipc	a5,0x13
    80000586:	4ae78793          	addi	a5,a5,1198 # 80013a30 <cons>
    8000058a:	0987a783          	lw	a5,152(a5)
    8000058e:	37fd                	addiw	a5,a5,-1
    80000590:	0007871b          	sext.w	a4,a5
    80000594:	00013797          	auipc	a5,0x13
    80000598:	49c78793          	addi	a5,a5,1180 # 80013a30 <cons>
    8000059c:	08e7ac23          	sw	a4,152(a5)
      }
      break;
    800005a0:	a085                	j	80000600 <consoleread+0x16a>
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800005a2:	fe842783          	lw	a5,-24(s0)
    800005a6:	0ff7f793          	zext.b	a5,a5
    800005aa:	fef403a3          	sb	a5,-25(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800005ae:	fe740713          	addi	a4,s0,-25
    800005b2:	fdc42783          	lw	a5,-36(s0)
    800005b6:	4685                	li	a3,1
    800005b8:	863a                	mv	a2,a4
    800005ba:	fd043583          	ld	a1,-48(s0)
    800005be:	853e                	mv	a0,a5
    800005c0:	00003097          	auipc	ra,0x3
    800005c4:	0dc080e7          	jalr	220(ra) # 8000369c <either_copyout>
    800005c8:	87aa                	mv	a5,a0
    800005ca:	873e                	mv	a4,a5
    800005cc:	57fd                	li	a5,-1
    800005ce:	02f70b63          	beq	a4,a5,80000604 <consoleread+0x16e>
      break;

    dst++;
    800005d2:	fd043783          	ld	a5,-48(s0)
    800005d6:	0785                	addi	a5,a5,1
    800005d8:	fcf43823          	sd	a5,-48(s0)
    --n;
    800005dc:	fd842783          	lw	a5,-40(s0)
    800005e0:	37fd                	addiw	a5,a5,-1
    800005e2:	fcf42c23          	sw	a5,-40(s0)

    if(c == '\n'){
    800005e6:	fe842783          	lw	a5,-24(s0)
    800005ea:	0007871b          	sext.w	a4,a5
    800005ee:	47a9                	li	a5,10
    800005f0:	00f70c63          	beq	a4,a5,80000608 <consoleread+0x172>
  while(n > 0){
    800005f4:	fd842783          	lw	a5,-40(s0)
    800005f8:	2781                	sext.w	a5,a5
    800005fa:	f0f04ae3          	bgtz	a5,8000050e <consoleread+0x78>
    800005fe:	a031                	j	8000060a <consoleread+0x174>
      break;
    80000600:	0001                	nop
    80000602:	a021                	j	8000060a <consoleread+0x174>
      break;
    80000604:	0001                	nop
    80000606:	a011                	j	8000060a <consoleread+0x174>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    80000608:	0001                	nop
    }
  }
  release(&cons.lock);
    8000060a:	00013517          	auipc	a0,0x13
    8000060e:	42650513          	addi	a0,a0,1062 # 80013a30 <cons>
    80000612:	00001097          	auipc	ra,0x1
    80000616:	d16080e7          	jalr	-746(ra) # 80001328 <release>

  return target - n;
    8000061a:	fd842783          	lw	a5,-40(s0)
    8000061e:	fec42703          	lw	a4,-20(s0)
    80000622:	40f707bb          	subw	a5,a4,a5
    80000626:	2781                	sext.w	a5,a5
}
    80000628:	853e                	mv	a0,a5
    8000062a:	70a2                	ld	ra,40(sp)
    8000062c:	7402                	ld	s0,32(sp)
    8000062e:	6145                	addi	sp,sp,48
    80000630:	8082                	ret

0000000080000632 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80000632:	1101                	addi	sp,sp,-32
    80000634:	ec06                	sd	ra,24(sp)
    80000636:	e822                	sd	s0,16(sp)
    80000638:	1000                	addi	s0,sp,32
    8000063a:	87aa                	mv	a5,a0
    8000063c:	fef42623          	sw	a5,-20(s0)
  acquire(&cons.lock);
    80000640:	00013517          	auipc	a0,0x13
    80000644:	3f050513          	addi	a0,a0,1008 # 80013a30 <cons>
    80000648:	00001097          	auipc	ra,0x1
    8000064c:	c7c080e7          	jalr	-900(ra) # 800012c4 <acquire>

  switch(c){
    80000650:	fec42783          	lw	a5,-20(s0)
    80000654:	0007871b          	sext.w	a4,a5
    80000658:	07f00793          	li	a5,127
    8000065c:	0cf70763          	beq	a4,a5,8000072a <consoleintr+0xf8>
    80000660:	fec42783          	lw	a5,-20(s0)
    80000664:	0007871b          	sext.w	a4,a5
    80000668:	07f00793          	li	a5,127
    8000066c:	10e7c363          	blt	a5,a4,80000772 <consoleintr+0x140>
    80000670:	fec42783          	lw	a5,-20(s0)
    80000674:	0007871b          	sext.w	a4,a5
    80000678:	47d5                	li	a5,21
    8000067a:	06f70163          	beq	a4,a5,800006dc <consoleintr+0xaa>
    8000067e:	fec42783          	lw	a5,-20(s0)
    80000682:	0007871b          	sext.w	a4,a5
    80000686:	47d5                	li	a5,21
    80000688:	0ee7c563          	blt	a5,a4,80000772 <consoleintr+0x140>
    8000068c:	fec42783          	lw	a5,-20(s0)
    80000690:	0007871b          	sext.w	a4,a5
    80000694:	47a1                	li	a5,8
    80000696:	08f70a63          	beq	a4,a5,8000072a <consoleintr+0xf8>
    8000069a:	fec42783          	lw	a5,-20(s0)
    8000069e:	0007871b          	sext.w	a4,a5
    800006a2:	47c1                	li	a5,16
    800006a4:	0cf71763          	bne	a4,a5,80000772 <consoleintr+0x140>
  case C('P'):  // Print process list.
    procdump();
    800006a8:	00003097          	auipc	ra,0x3
    800006ac:	0dc080e7          	jalr	220(ra) # 80003784 <procdump>
    break;
    800006b0:	aad1                	j	80000884 <consoleintr+0x252>
  case C('U'):  // Kill line.
    while(cons.e != cons.w &&
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
      cons.e--;
    800006b2:	00013797          	auipc	a5,0x13
    800006b6:	37e78793          	addi	a5,a5,894 # 80013a30 <cons>
    800006ba:	0a07a783          	lw	a5,160(a5)
    800006be:	37fd                	addiw	a5,a5,-1
    800006c0:	0007871b          	sext.w	a4,a5
    800006c4:	00013797          	auipc	a5,0x13
    800006c8:	36c78793          	addi	a5,a5,876 # 80013a30 <cons>
    800006cc:	0ae7a023          	sw	a4,160(a5)
      consputc(BACKSPACE);
    800006d0:	10000513          	li	a0,256
    800006d4:	00000097          	auipc	ra,0x0
    800006d8:	ce0080e7          	jalr	-800(ra) # 800003b4 <consputc>
    while(cons.e != cons.w &&
    800006dc:	00013797          	auipc	a5,0x13
    800006e0:	35478793          	addi	a5,a5,852 # 80013a30 <cons>
    800006e4:	0a07a703          	lw	a4,160(a5)
    800006e8:	00013797          	auipc	a5,0x13
    800006ec:	34878793          	addi	a5,a5,840 # 80013a30 <cons>
    800006f0:	09c7a783          	lw	a5,156(a5)
    800006f4:	18f70363          	beq	a4,a5,8000087a <consoleintr+0x248>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800006f8:	00013797          	auipc	a5,0x13
    800006fc:	33878793          	addi	a5,a5,824 # 80013a30 <cons>
    80000700:	0a07a783          	lw	a5,160(a5)
    80000704:	37fd                	addiw	a5,a5,-1
    80000706:	2781                	sext.w	a5,a5
    80000708:	07f7f793          	andi	a5,a5,127
    8000070c:	2781                	sext.w	a5,a5
    8000070e:	00013717          	auipc	a4,0x13
    80000712:	32270713          	addi	a4,a4,802 # 80013a30 <cons>
    80000716:	1782                	slli	a5,a5,0x20
    80000718:	9381                	srli	a5,a5,0x20
    8000071a:	97ba                	add	a5,a5,a4
    8000071c:	0187c783          	lbu	a5,24(a5)
    while(cons.e != cons.w &&
    80000720:	873e                	mv	a4,a5
    80000722:	47a9                	li	a5,10
    80000724:	f8f717e3          	bne	a4,a5,800006b2 <consoleintr+0x80>
    }
    break;
    80000728:	aa89                	j	8000087a <consoleintr+0x248>
  case C('H'): // Backspace
  case '\x7f': // Delete key
    if(cons.e != cons.w){
    8000072a:	00013797          	auipc	a5,0x13
    8000072e:	30678793          	addi	a5,a5,774 # 80013a30 <cons>
    80000732:	0a07a703          	lw	a4,160(a5)
    80000736:	00013797          	auipc	a5,0x13
    8000073a:	2fa78793          	addi	a5,a5,762 # 80013a30 <cons>
    8000073e:	09c7a783          	lw	a5,156(a5)
    80000742:	12f70e63          	beq	a4,a5,8000087e <consoleintr+0x24c>
      cons.e--;
    80000746:	00013797          	auipc	a5,0x13
    8000074a:	2ea78793          	addi	a5,a5,746 # 80013a30 <cons>
    8000074e:	0a07a783          	lw	a5,160(a5)
    80000752:	37fd                	addiw	a5,a5,-1
    80000754:	0007871b          	sext.w	a4,a5
    80000758:	00013797          	auipc	a5,0x13
    8000075c:	2d878793          	addi	a5,a5,728 # 80013a30 <cons>
    80000760:	0ae7a023          	sw	a4,160(a5)
      consputc(BACKSPACE);
    80000764:	10000513          	li	a0,256
    80000768:	00000097          	auipc	ra,0x0
    8000076c:	c4c080e7          	jalr	-948(ra) # 800003b4 <consputc>
    }
    break;
    80000770:	a239                	j	8000087e <consoleintr+0x24c>
  default:
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000772:	fec42783          	lw	a5,-20(s0)
    80000776:	2781                	sext.w	a5,a5
    80000778:	10078563          	beqz	a5,80000882 <consoleintr+0x250>
    8000077c:	00013797          	auipc	a5,0x13
    80000780:	2b478793          	addi	a5,a5,692 # 80013a30 <cons>
    80000784:	0a07a703          	lw	a4,160(a5)
    80000788:	00013797          	auipc	a5,0x13
    8000078c:	2a878793          	addi	a5,a5,680 # 80013a30 <cons>
    80000790:	0987a783          	lw	a5,152(a5)
    80000794:	40f707bb          	subw	a5,a4,a5
    80000798:	0007871b          	sext.w	a4,a5
    8000079c:	07f00793          	li	a5,127
    800007a0:	0ee7e163          	bltu	a5,a4,80000882 <consoleintr+0x250>
      c = (c == '\r') ? '\n' : c;
    800007a4:	fec42783          	lw	a5,-20(s0)
    800007a8:	0007871b          	sext.w	a4,a5
    800007ac:	47b5                	li	a5,13
    800007ae:	00f70563          	beq	a4,a5,800007b8 <consoleintr+0x186>
    800007b2:	fec42783          	lw	a5,-20(s0)
    800007b6:	a011                	j	800007ba <consoleintr+0x188>
    800007b8:	47a9                	li	a5,10
    800007ba:	fef42623          	sw	a5,-20(s0)

      // echo back to the user.
      consputc(c);
    800007be:	fec42783          	lw	a5,-20(s0)
    800007c2:	853e                	mv	a0,a5
    800007c4:	00000097          	auipc	ra,0x0
    800007c8:	bf0080e7          	jalr	-1040(ra) # 800003b4 <consputc>

      // store for consumption by consoleread().
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800007cc:	00013797          	auipc	a5,0x13
    800007d0:	26478793          	addi	a5,a5,612 # 80013a30 <cons>
    800007d4:	0a07a783          	lw	a5,160(a5)
    800007d8:	0017871b          	addiw	a4,a5,1
    800007dc:	0007069b          	sext.w	a3,a4
    800007e0:	00013717          	auipc	a4,0x13
    800007e4:	25070713          	addi	a4,a4,592 # 80013a30 <cons>
    800007e8:	0ad72023          	sw	a3,160(a4)
    800007ec:	07f7f793          	andi	a5,a5,127
    800007f0:	2781                	sext.w	a5,a5
    800007f2:	fec42703          	lw	a4,-20(s0)
    800007f6:	0ff77713          	zext.b	a4,a4
    800007fa:	00013697          	auipc	a3,0x13
    800007fe:	23668693          	addi	a3,a3,566 # 80013a30 <cons>
    80000802:	1782                	slli	a5,a5,0x20
    80000804:	9381                	srli	a5,a5,0x20
    80000806:	97b6                	add	a5,a5,a3
    80000808:	00e78c23          	sb	a4,24(a5)

      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000080c:	fec42783          	lw	a5,-20(s0)
    80000810:	0007871b          	sext.w	a4,a5
    80000814:	47a9                	li	a5,10
    80000816:	02f70d63          	beq	a4,a5,80000850 <consoleintr+0x21e>
    8000081a:	fec42783          	lw	a5,-20(s0)
    8000081e:	0007871b          	sext.w	a4,a5
    80000822:	4791                	li	a5,4
    80000824:	02f70663          	beq	a4,a5,80000850 <consoleintr+0x21e>
    80000828:	00013797          	auipc	a5,0x13
    8000082c:	20878793          	addi	a5,a5,520 # 80013a30 <cons>
    80000830:	0a07a703          	lw	a4,160(a5)
    80000834:	00013797          	auipc	a5,0x13
    80000838:	1fc78793          	addi	a5,a5,508 # 80013a30 <cons>
    8000083c:	0987a783          	lw	a5,152(a5)
    80000840:	40f707bb          	subw	a5,a4,a5
    80000844:	0007871b          	sext.w	a4,a5
    80000848:	08000793          	li	a5,128
    8000084c:	02f71b63          	bne	a4,a5,80000882 <consoleintr+0x250>
        // wake up consoleread() if a whole line (or end-of-file)
        // has arrived.
        cons.w = cons.e;
    80000850:	00013797          	auipc	a5,0x13
    80000854:	1e078793          	addi	a5,a5,480 # 80013a30 <cons>
    80000858:	0a07a703          	lw	a4,160(a5)
    8000085c:	00013797          	auipc	a5,0x13
    80000860:	1d478793          	addi	a5,a5,468 # 80013a30 <cons>
    80000864:	08e7ae23          	sw	a4,156(a5)
        wakeup(&cons.r);
    80000868:	00013517          	auipc	a0,0x13
    8000086c:	26050513          	addi	a0,a0,608 # 80013ac8 <cons+0x98>
    80000870:	00003097          	auipc	ra,0x3
    80000874:	c82080e7          	jalr	-894(ra) # 800034f2 <wakeup>
      }
    }
    break;
    80000878:	a029                	j	80000882 <consoleintr+0x250>
    break;
    8000087a:	0001                	nop
    8000087c:	a021                	j	80000884 <consoleintr+0x252>
    break;
    8000087e:	0001                	nop
    80000880:	a011                	j	80000884 <consoleintr+0x252>
    break;
    80000882:	0001                	nop
  }
  
  release(&cons.lock);
    80000884:	00013517          	auipc	a0,0x13
    80000888:	1ac50513          	addi	a0,a0,428 # 80013a30 <cons>
    8000088c:	00001097          	auipc	ra,0x1
    80000890:	a9c080e7          	jalr	-1380(ra) # 80001328 <release>
}
    80000894:	0001                	nop
    80000896:	60e2                	ld	ra,24(sp)
    80000898:	6442                	ld	s0,16(sp)
    8000089a:	6105                	addi	sp,sp,32
    8000089c:	8082                	ret

000000008000089e <consoleinit>:

void
consoleinit(void)
{
    8000089e:	1141                	addi	sp,sp,-16
    800008a0:	e406                	sd	ra,8(sp)
    800008a2:	e022                	sd	s0,0(sp)
    800008a4:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800008a6:	0000a597          	auipc	a1,0xa
    800008aa:	75a58593          	addi	a1,a1,1882 # 8000b000 <etext>
    800008ae:	00013517          	auipc	a0,0x13
    800008b2:	18250513          	addi	a0,a0,386 # 80013a30 <cons>
    800008b6:	00001097          	auipc	ra,0x1
    800008ba:	9da080e7          	jalr	-1574(ra) # 80001290 <initlock>

  uartinit();
    800008be:	00000097          	auipc	ra,0x0
    800008c2:	48c080e7          	jalr	1164(ra) # 80000d4a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800008c6:	00023797          	auipc	a5,0x23
    800008ca:	30a78793          	addi	a5,a5,778 # 80023bd0 <devsw>
    800008ce:	00000717          	auipc	a4,0x0
    800008d2:	bc870713          	addi	a4,a4,-1080 # 80000496 <consoleread>
    800008d6:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800008d8:	00023797          	auipc	a5,0x23
    800008dc:	2f878793          	addi	a5,a5,760 # 80023bd0 <devsw>
    800008e0:	00000717          	auipc	a4,0x0
    800008e4:	b2c70713          	addi	a4,a4,-1236 # 8000040c <consolewrite>
    800008e8:	ef98                	sd	a4,24(a5)
}
    800008ea:	0001                	nop
    800008ec:	60a2                	ld	ra,8(sp)
    800008ee:	6402                	ld	s0,0(sp)
    800008f0:	0141                	addi	sp,sp,16
    800008f2:	8082                	ret

00000000800008f4 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800008f4:	7139                	addi	sp,sp,-64
    800008f6:	fc06                	sd	ra,56(sp)
    800008f8:	f822                	sd	s0,48(sp)
    800008fa:	0080                	addi	s0,sp,64
    800008fc:	87aa                	mv	a5,a0
    800008fe:	86ae                	mv	a3,a1
    80000900:	8732                	mv	a4,a2
    80000902:	fcf42623          	sw	a5,-52(s0)
    80000906:	87b6                	mv	a5,a3
    80000908:	fcf42423          	sw	a5,-56(s0)
    8000090c:	87ba                	mv	a5,a4
    8000090e:	fcf42223          	sw	a5,-60(s0)
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80000912:	fc442783          	lw	a5,-60(s0)
    80000916:	2781                	sext.w	a5,a5
    80000918:	c78d                	beqz	a5,80000942 <printint+0x4e>
    8000091a:	fcc42783          	lw	a5,-52(s0)
    8000091e:	01f7d79b          	srliw	a5,a5,0x1f
    80000922:	0ff7f793          	zext.b	a5,a5
    80000926:	fcf42223          	sw	a5,-60(s0)
    8000092a:	fc442783          	lw	a5,-60(s0)
    8000092e:	2781                	sext.w	a5,a5
    80000930:	cb89                	beqz	a5,80000942 <printint+0x4e>
    x = -xx;
    80000932:	fcc42783          	lw	a5,-52(s0)
    80000936:	40f007bb          	negw	a5,a5
    8000093a:	2781                	sext.w	a5,a5
    8000093c:	fef42423          	sw	a5,-24(s0)
    80000940:	a029                	j	8000094a <printint+0x56>
  else
    x = xx;
    80000942:	fcc42783          	lw	a5,-52(s0)
    80000946:	fef42423          	sw	a5,-24(s0)

  i = 0;
    8000094a:	fe042623          	sw	zero,-20(s0)
  do {
    buf[i++] = digits[x % base];
    8000094e:	fc842783          	lw	a5,-56(s0)
    80000952:	fe842703          	lw	a4,-24(s0)
    80000956:	02f777bb          	remuw	a5,a4,a5
    8000095a:	0007871b          	sext.w	a4,a5
    8000095e:	fec42783          	lw	a5,-20(s0)
    80000962:	0017869b          	addiw	a3,a5,1
    80000966:	fed42623          	sw	a3,-20(s0)
    8000096a:	0000b697          	auipc	a3,0xb
    8000096e:	e1668693          	addi	a3,a3,-490 # 8000b780 <digits>
    80000972:	1702                	slli	a4,a4,0x20
    80000974:	9301                	srli	a4,a4,0x20
    80000976:	9736                	add	a4,a4,a3
    80000978:	00074703          	lbu	a4,0(a4)
    8000097c:	17c1                	addi	a5,a5,-16
    8000097e:	97a2                	add	a5,a5,s0
    80000980:	fee78423          	sb	a4,-24(a5)
  } while((x /= base) != 0);
    80000984:	fc842783          	lw	a5,-56(s0)
    80000988:	fe842703          	lw	a4,-24(s0)
    8000098c:	02f757bb          	divuw	a5,a4,a5
    80000990:	fef42423          	sw	a5,-24(s0)
    80000994:	fe842783          	lw	a5,-24(s0)
    80000998:	2781                	sext.w	a5,a5
    8000099a:	fbd5                	bnez	a5,8000094e <printint+0x5a>

  if(sign)
    8000099c:	fc442783          	lw	a5,-60(s0)
    800009a0:	2781                	sext.w	a5,a5
    800009a2:	cb95                	beqz	a5,800009d6 <printint+0xe2>
    buf[i++] = '-';
    800009a4:	fec42783          	lw	a5,-20(s0)
    800009a8:	0017871b          	addiw	a4,a5,1
    800009ac:	fee42623          	sw	a4,-20(s0)
    800009b0:	17c1                	addi	a5,a5,-16
    800009b2:	97a2                	add	a5,a5,s0
    800009b4:	02d00713          	li	a4,45
    800009b8:	fee78423          	sb	a4,-24(a5)

  while(--i >= 0)
    800009bc:	a829                	j	800009d6 <printint+0xe2>
    consputc(buf[i]);
    800009be:	fec42783          	lw	a5,-20(s0)
    800009c2:	17c1                	addi	a5,a5,-16
    800009c4:	97a2                	add	a5,a5,s0
    800009c6:	fe87c783          	lbu	a5,-24(a5)
    800009ca:	2781                	sext.w	a5,a5
    800009cc:	853e                	mv	a0,a5
    800009ce:	00000097          	auipc	ra,0x0
    800009d2:	9e6080e7          	jalr	-1562(ra) # 800003b4 <consputc>
  while(--i >= 0)
    800009d6:	fec42783          	lw	a5,-20(s0)
    800009da:	37fd                	addiw	a5,a5,-1
    800009dc:	fef42623          	sw	a5,-20(s0)
    800009e0:	fec42783          	lw	a5,-20(s0)
    800009e4:	2781                	sext.w	a5,a5
    800009e6:	fc07dce3          	bgez	a5,800009be <printint+0xca>
}
    800009ea:	0001                	nop
    800009ec:	0001                	nop
    800009ee:	70e2                	ld	ra,56(sp)
    800009f0:	7442                	ld	s0,48(sp)
    800009f2:	6121                	addi	sp,sp,64
    800009f4:	8082                	ret

00000000800009f6 <printptr>:

static void
printptr(uint64 x)
{
    800009f6:	7179                	addi	sp,sp,-48
    800009f8:	f406                	sd	ra,40(sp)
    800009fa:	f022                	sd	s0,32(sp)
    800009fc:	1800                	addi	s0,sp,48
    800009fe:	fca43c23          	sd	a0,-40(s0)
  int i;
  consputc('0');
    80000a02:	03000513          	li	a0,48
    80000a06:	00000097          	auipc	ra,0x0
    80000a0a:	9ae080e7          	jalr	-1618(ra) # 800003b4 <consputc>
  consputc('x');
    80000a0e:	07800513          	li	a0,120
    80000a12:	00000097          	auipc	ra,0x0
    80000a16:	9a2080e7          	jalr	-1630(ra) # 800003b4 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80000a1a:	fe042623          	sw	zero,-20(s0)
    80000a1e:	a81d                	j	80000a54 <printptr+0x5e>
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000a20:	fd843783          	ld	a5,-40(s0)
    80000a24:	93f1                	srli	a5,a5,0x3c
    80000a26:	0000b717          	auipc	a4,0xb
    80000a2a:	d5a70713          	addi	a4,a4,-678 # 8000b780 <digits>
    80000a2e:	97ba                	add	a5,a5,a4
    80000a30:	0007c783          	lbu	a5,0(a5)
    80000a34:	2781                	sext.w	a5,a5
    80000a36:	853e                	mv	a0,a5
    80000a38:	00000097          	auipc	ra,0x0
    80000a3c:	97c080e7          	jalr	-1668(ra) # 800003b4 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80000a40:	fec42783          	lw	a5,-20(s0)
    80000a44:	2785                	addiw	a5,a5,1
    80000a46:	fef42623          	sw	a5,-20(s0)
    80000a4a:	fd843783          	ld	a5,-40(s0)
    80000a4e:	0792                	slli	a5,a5,0x4
    80000a50:	fcf43c23          	sd	a5,-40(s0)
    80000a54:	fec42703          	lw	a4,-20(s0)
    80000a58:	47bd                	li	a5,15
    80000a5a:	fce7f3e3          	bgeu	a5,a4,80000a20 <printptr+0x2a>
}
    80000a5e:	0001                	nop
    80000a60:	0001                	nop
    80000a62:	70a2                	ld	ra,40(sp)
    80000a64:	7402                	ld	s0,32(sp)
    80000a66:	6145                	addi	sp,sp,48
    80000a68:	8082                	ret

0000000080000a6a <printf>:

// Print to the console. only understands %d, %x, %p, %s.
void
printf(char *fmt, ...)
{
    80000a6a:	7119                	addi	sp,sp,-128
    80000a6c:	fc06                	sd	ra,56(sp)
    80000a6e:	f822                	sd	s0,48(sp)
    80000a70:	0080                	addi	s0,sp,64
    80000a72:	fca43423          	sd	a0,-56(s0)
    80000a76:	e40c                	sd	a1,8(s0)
    80000a78:	e810                	sd	a2,16(s0)
    80000a7a:	ec14                	sd	a3,24(s0)
    80000a7c:	f018                	sd	a4,32(s0)
    80000a7e:	f41c                	sd	a5,40(s0)
    80000a80:	03043823          	sd	a6,48(s0)
    80000a84:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, c, locking;
  char *s;

  locking = pr.locking;
    80000a88:	00013797          	auipc	a5,0x13
    80000a8c:	05078793          	addi	a5,a5,80 # 80013ad8 <pr>
    80000a90:	4f9c                	lw	a5,24(a5)
    80000a92:	fcf42e23          	sw	a5,-36(s0)
  if(locking)
    80000a96:	fdc42783          	lw	a5,-36(s0)
    80000a9a:	2781                	sext.w	a5,a5
    80000a9c:	cb89                	beqz	a5,80000aae <printf+0x44>
    acquire(&pr.lock);
    80000a9e:	00013517          	auipc	a0,0x13
    80000aa2:	03a50513          	addi	a0,a0,58 # 80013ad8 <pr>
    80000aa6:	00001097          	auipc	ra,0x1
    80000aaa:	81e080e7          	jalr	-2018(ra) # 800012c4 <acquire>

  if (fmt == 0)
    80000aae:	fc843783          	ld	a5,-56(s0)
    80000ab2:	eb89                	bnez	a5,80000ac4 <printf+0x5a>
    panic("null fmt");
    80000ab4:	0000a517          	auipc	a0,0xa
    80000ab8:	55450513          	addi	a0,a0,1364 # 8000b008 <etext+0x8>
    80000abc:	00000097          	auipc	ra,0x0
    80000ac0:	204080e7          	jalr	516(ra) # 80000cc0 <panic>

  va_start(ap, fmt);
    80000ac4:	04040793          	addi	a5,s0,64
    80000ac8:	fcf43023          	sd	a5,-64(s0)
    80000acc:	fc043783          	ld	a5,-64(s0)
    80000ad0:	fc878793          	addi	a5,a5,-56
    80000ad4:	fcf43823          	sd	a5,-48(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000ad8:	fe042623          	sw	zero,-20(s0)
    80000adc:	a24d                	j	80000c7e <printf+0x214>
    if(c != '%'){
    80000ade:	fd842783          	lw	a5,-40(s0)
    80000ae2:	0007871b          	sext.w	a4,a5
    80000ae6:	02500793          	li	a5,37
    80000aea:	00f70a63          	beq	a4,a5,80000afe <printf+0x94>
      consputc(c);
    80000aee:	fd842783          	lw	a5,-40(s0)
    80000af2:	853e                	mv	a0,a5
    80000af4:	00000097          	auipc	ra,0x0
    80000af8:	8c0080e7          	jalr	-1856(ra) # 800003b4 <consputc>
      continue;
    80000afc:	aaa5                	j	80000c74 <printf+0x20a>
    }
    c = fmt[++i] & 0xff;
    80000afe:	fec42783          	lw	a5,-20(s0)
    80000b02:	2785                	addiw	a5,a5,1
    80000b04:	fef42623          	sw	a5,-20(s0)
    80000b08:	fec42783          	lw	a5,-20(s0)
    80000b0c:	fc843703          	ld	a4,-56(s0)
    80000b10:	97ba                	add	a5,a5,a4
    80000b12:	0007c783          	lbu	a5,0(a5)
    80000b16:	fcf42c23          	sw	a5,-40(s0)
    if(c == 0)
    80000b1a:	fd842783          	lw	a5,-40(s0)
    80000b1e:	2781                	sext.w	a5,a5
    80000b20:	16078e63          	beqz	a5,80000c9c <printf+0x232>
      break;
    switch(c){
    80000b24:	fd842783          	lw	a5,-40(s0)
    80000b28:	0007871b          	sext.w	a4,a5
    80000b2c:	07800793          	li	a5,120
    80000b30:	08f70963          	beq	a4,a5,80000bc2 <printf+0x158>
    80000b34:	fd842783          	lw	a5,-40(s0)
    80000b38:	0007871b          	sext.w	a4,a5
    80000b3c:	07800793          	li	a5,120
    80000b40:	10e7cc63          	blt	a5,a4,80000c58 <printf+0x1ee>
    80000b44:	fd842783          	lw	a5,-40(s0)
    80000b48:	0007871b          	sext.w	a4,a5
    80000b4c:	07300793          	li	a5,115
    80000b50:	0af70563          	beq	a4,a5,80000bfa <printf+0x190>
    80000b54:	fd842783          	lw	a5,-40(s0)
    80000b58:	0007871b          	sext.w	a4,a5
    80000b5c:	07300793          	li	a5,115
    80000b60:	0ee7cc63          	blt	a5,a4,80000c58 <printf+0x1ee>
    80000b64:	fd842783          	lw	a5,-40(s0)
    80000b68:	0007871b          	sext.w	a4,a5
    80000b6c:	07000793          	li	a5,112
    80000b70:	06f70863          	beq	a4,a5,80000be0 <printf+0x176>
    80000b74:	fd842783          	lw	a5,-40(s0)
    80000b78:	0007871b          	sext.w	a4,a5
    80000b7c:	07000793          	li	a5,112
    80000b80:	0ce7cc63          	blt	a5,a4,80000c58 <printf+0x1ee>
    80000b84:	fd842783          	lw	a5,-40(s0)
    80000b88:	0007871b          	sext.w	a4,a5
    80000b8c:	02500793          	li	a5,37
    80000b90:	0af70d63          	beq	a4,a5,80000c4a <printf+0x1e0>
    80000b94:	fd842783          	lw	a5,-40(s0)
    80000b98:	0007871b          	sext.w	a4,a5
    80000b9c:	06400793          	li	a5,100
    80000ba0:	0af71c63          	bne	a4,a5,80000c58 <printf+0x1ee>
    case 'd':
      printint(va_arg(ap, int), 10, 1);
    80000ba4:	fd043783          	ld	a5,-48(s0)
    80000ba8:	00878713          	addi	a4,a5,8
    80000bac:	fce43823          	sd	a4,-48(s0)
    80000bb0:	439c                	lw	a5,0(a5)
    80000bb2:	4605                	li	a2,1
    80000bb4:	45a9                	li	a1,10
    80000bb6:	853e                	mv	a0,a5
    80000bb8:	00000097          	auipc	ra,0x0
    80000bbc:	d3c080e7          	jalr	-708(ra) # 800008f4 <printint>
      break;
    80000bc0:	a855                	j	80000c74 <printf+0x20a>
    case 'x':
      printint(va_arg(ap, int), 16, 1);
    80000bc2:	fd043783          	ld	a5,-48(s0)
    80000bc6:	00878713          	addi	a4,a5,8
    80000bca:	fce43823          	sd	a4,-48(s0)
    80000bce:	439c                	lw	a5,0(a5)
    80000bd0:	4605                	li	a2,1
    80000bd2:	45c1                	li	a1,16
    80000bd4:	853e                	mv	a0,a5
    80000bd6:	00000097          	auipc	ra,0x0
    80000bda:	d1e080e7          	jalr	-738(ra) # 800008f4 <printint>
      break;
    80000bde:	a859                	j	80000c74 <printf+0x20a>
    case 'p':
      printptr(va_arg(ap, uint64));
    80000be0:	fd043783          	ld	a5,-48(s0)
    80000be4:	00878713          	addi	a4,a5,8
    80000be8:	fce43823          	sd	a4,-48(s0)
    80000bec:	639c                	ld	a5,0(a5)
    80000bee:	853e                	mv	a0,a5
    80000bf0:	00000097          	auipc	ra,0x0
    80000bf4:	e06080e7          	jalr	-506(ra) # 800009f6 <printptr>
      break;
    80000bf8:	a8b5                	j	80000c74 <printf+0x20a>
    case 's':
      if((s = va_arg(ap, char*)) == 0)
    80000bfa:	fd043783          	ld	a5,-48(s0)
    80000bfe:	00878713          	addi	a4,a5,8
    80000c02:	fce43823          	sd	a4,-48(s0)
    80000c06:	639c                	ld	a5,0(a5)
    80000c08:	fef43023          	sd	a5,-32(s0)
    80000c0c:	fe043783          	ld	a5,-32(s0)
    80000c10:	e79d                	bnez	a5,80000c3e <printf+0x1d4>
        s = "(null)";
    80000c12:	0000a797          	auipc	a5,0xa
    80000c16:	40678793          	addi	a5,a5,1030 # 8000b018 <etext+0x18>
    80000c1a:	fef43023          	sd	a5,-32(s0)
      for(; *s; s++)
    80000c1e:	a005                	j	80000c3e <printf+0x1d4>
        consputc(*s);
    80000c20:	fe043783          	ld	a5,-32(s0)
    80000c24:	0007c783          	lbu	a5,0(a5)
    80000c28:	2781                	sext.w	a5,a5
    80000c2a:	853e                	mv	a0,a5
    80000c2c:	fffff097          	auipc	ra,0xfffff
    80000c30:	788080e7          	jalr	1928(ra) # 800003b4 <consputc>
      for(; *s; s++)
    80000c34:	fe043783          	ld	a5,-32(s0)
    80000c38:	0785                	addi	a5,a5,1
    80000c3a:	fef43023          	sd	a5,-32(s0)
    80000c3e:	fe043783          	ld	a5,-32(s0)
    80000c42:	0007c783          	lbu	a5,0(a5)
    80000c46:	ffe9                	bnez	a5,80000c20 <printf+0x1b6>
      break;
    80000c48:	a035                	j	80000c74 <printf+0x20a>
    case '%':
      consputc('%');
    80000c4a:	02500513          	li	a0,37
    80000c4e:	fffff097          	auipc	ra,0xfffff
    80000c52:	766080e7          	jalr	1894(ra) # 800003b4 <consputc>
      break;
    80000c56:	a839                	j	80000c74 <printf+0x20a>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
    80000c58:	02500513          	li	a0,37
    80000c5c:	fffff097          	auipc	ra,0xfffff
    80000c60:	758080e7          	jalr	1880(ra) # 800003b4 <consputc>
      consputc(c);
    80000c64:	fd842783          	lw	a5,-40(s0)
    80000c68:	853e                	mv	a0,a5
    80000c6a:	fffff097          	auipc	ra,0xfffff
    80000c6e:	74a080e7          	jalr	1866(ra) # 800003b4 <consputc>
      break;
    80000c72:	0001                	nop
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000c74:	fec42783          	lw	a5,-20(s0)
    80000c78:	2785                	addiw	a5,a5,1
    80000c7a:	fef42623          	sw	a5,-20(s0)
    80000c7e:	fec42783          	lw	a5,-20(s0)
    80000c82:	fc843703          	ld	a4,-56(s0)
    80000c86:	97ba                	add	a5,a5,a4
    80000c88:	0007c783          	lbu	a5,0(a5)
    80000c8c:	fcf42c23          	sw	a5,-40(s0)
    80000c90:	fd842783          	lw	a5,-40(s0)
    80000c94:	2781                	sext.w	a5,a5
    80000c96:	e40794e3          	bnez	a5,80000ade <printf+0x74>
    80000c9a:	a011                	j	80000c9e <printf+0x234>
      break;
    80000c9c:	0001                	nop
    }
  }
  va_end(ap);

  if(locking)
    80000c9e:	fdc42783          	lw	a5,-36(s0)
    80000ca2:	2781                	sext.w	a5,a5
    80000ca4:	cb89                	beqz	a5,80000cb6 <printf+0x24c>
    release(&pr.lock);
    80000ca6:	00013517          	auipc	a0,0x13
    80000caa:	e3250513          	addi	a0,a0,-462 # 80013ad8 <pr>
    80000cae:	00000097          	auipc	ra,0x0
    80000cb2:	67a080e7          	jalr	1658(ra) # 80001328 <release>
}
    80000cb6:	0001                	nop
    80000cb8:	70e2                	ld	ra,56(sp)
    80000cba:	7442                	ld	s0,48(sp)
    80000cbc:	6109                	addi	sp,sp,128
    80000cbe:	8082                	ret

0000000080000cc0 <panic>:

void
panic(char *s)
{
    80000cc0:	1101                	addi	sp,sp,-32
    80000cc2:	ec06                	sd	ra,24(sp)
    80000cc4:	e822                	sd	s0,16(sp)
    80000cc6:	1000                	addi	s0,sp,32
    80000cc8:	fea43423          	sd	a0,-24(s0)
  pr.locking = 0;
    80000ccc:	00013797          	auipc	a5,0x13
    80000cd0:	e0c78793          	addi	a5,a5,-500 # 80013ad8 <pr>
    80000cd4:	0007ac23          	sw	zero,24(a5)
  printf("panic: ");
    80000cd8:	0000a517          	auipc	a0,0xa
    80000cdc:	34850513          	addi	a0,a0,840 # 8000b020 <etext+0x20>
    80000ce0:	00000097          	auipc	ra,0x0
    80000ce4:	d8a080e7          	jalr	-630(ra) # 80000a6a <printf>
  printf(s);
    80000ce8:	fe843503          	ld	a0,-24(s0)
    80000cec:	00000097          	auipc	ra,0x0
    80000cf0:	d7e080e7          	jalr	-642(ra) # 80000a6a <printf>
  printf("\n");
    80000cf4:	0000a517          	auipc	a0,0xa
    80000cf8:	33450513          	addi	a0,a0,820 # 8000b028 <etext+0x28>
    80000cfc:	00000097          	auipc	ra,0x0
    80000d00:	d6e080e7          	jalr	-658(ra) # 80000a6a <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000d04:	0000b797          	auipc	a5,0xb
    80000d08:	bbc78793          	addi	a5,a5,-1092 # 8000b8c0 <panicked>
    80000d0c:	4705                	li	a4,1
    80000d0e:	c398                	sw	a4,0(a5)
  for(;;)
    80000d10:	0001                	nop
    80000d12:	bffd                	j	80000d10 <panic+0x50>

0000000080000d14 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000d14:	1141                	addi	sp,sp,-16
    80000d16:	e406                	sd	ra,8(sp)
    80000d18:	e022                	sd	s0,0(sp)
    80000d1a:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    80000d1c:	0000a597          	auipc	a1,0xa
    80000d20:	31458593          	addi	a1,a1,788 # 8000b030 <etext+0x30>
    80000d24:	00013517          	auipc	a0,0x13
    80000d28:	db450513          	addi	a0,a0,-588 # 80013ad8 <pr>
    80000d2c:	00000097          	auipc	ra,0x0
    80000d30:	564080e7          	jalr	1380(ra) # 80001290 <initlock>
  pr.locking = 1;
    80000d34:	00013797          	auipc	a5,0x13
    80000d38:	da478793          	addi	a5,a5,-604 # 80013ad8 <pr>
    80000d3c:	4705                	li	a4,1
    80000d3e:	cf98                	sw	a4,24(a5)
}
    80000d40:	0001                	nop
    80000d42:	60a2                	ld	ra,8(sp)
    80000d44:	6402                	ld	s0,0(sp)
    80000d46:	0141                	addi	sp,sp,16
    80000d48:	8082                	ret

0000000080000d4a <uartinit>:

void uartstart();

void
uartinit(void)
{
    80000d4a:	1141                	addi	sp,sp,-16
    80000d4c:	e406                	sd	ra,8(sp)
    80000d4e:	e022                	sd	s0,0(sp)
    80000d50:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80000d52:	100007b7          	lui	a5,0x10000
    80000d56:	0785                	addi	a5,a5,1 # 10000001 <_entry-0x6fffffff>
    80000d58:	00078023          	sb	zero,0(a5)

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80000d5c:	100007b7          	lui	a5,0x10000
    80000d60:	078d                	addi	a5,a5,3 # 10000003 <_entry-0x6ffffffd>
    80000d62:	f8000713          	li	a4,-128
    80000d66:	00e78023          	sb	a4,0(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000d6a:	100007b7          	lui	a5,0x10000
    80000d6e:	470d                	li	a4,3
    80000d70:	00e78023          	sb	a4,0(a5) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80000d74:	100007b7          	lui	a5,0x10000
    80000d78:	0785                	addi	a5,a5,1 # 10000001 <_entry-0x6fffffff>
    80000d7a:	00078023          	sb	zero,0(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000d7e:	100007b7          	lui	a5,0x10000
    80000d82:	078d                	addi	a5,a5,3 # 10000003 <_entry-0x6ffffffd>
    80000d84:	470d                	li	a4,3
    80000d86:	00e78023          	sb	a4,0(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000d8a:	100007b7          	lui	a5,0x10000
    80000d8e:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80000d90:	471d                	li	a4,7
    80000d92:	00e78023          	sb	a4,0(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80000d96:	100007b7          	lui	a5,0x10000
    80000d9a:	0785                	addi	a5,a5,1 # 10000001 <_entry-0x6fffffff>
    80000d9c:	470d                	li	a4,3
    80000d9e:	00e78023          	sb	a4,0(a5)

  initlock(&uart_tx_lock, "uart");
    80000da2:	0000a597          	auipc	a1,0xa
    80000da6:	29658593          	addi	a1,a1,662 # 8000b038 <etext+0x38>
    80000daa:	00013517          	auipc	a0,0x13
    80000dae:	d4e50513          	addi	a0,a0,-690 # 80013af8 <uart_tx_lock>
    80000db2:	00000097          	auipc	ra,0x0
    80000db6:	4de080e7          	jalr	1246(ra) # 80001290 <initlock>
}
    80000dba:	0001                	nop
    80000dbc:	60a2                	ld	ra,8(sp)
    80000dbe:	6402                	ld	s0,0(sp)
    80000dc0:	0141                	addi	sp,sp,16
    80000dc2:	8082                	ret

0000000080000dc4 <uartputc>:
// because it may block, it can't be called
// from interrupts; it's only suitable for use
// by write().
void
uartputc(int c)
{
    80000dc4:	1101                	addi	sp,sp,-32
    80000dc6:	ec06                	sd	ra,24(sp)
    80000dc8:	e822                	sd	s0,16(sp)
    80000dca:	1000                	addi	s0,sp,32
    80000dcc:	87aa                	mv	a5,a0
    80000dce:	fef42623          	sw	a5,-20(s0)
  acquire(&uart_tx_lock);
    80000dd2:	00013517          	auipc	a0,0x13
    80000dd6:	d2650513          	addi	a0,a0,-730 # 80013af8 <uart_tx_lock>
    80000dda:	00000097          	auipc	ra,0x0
    80000dde:	4ea080e7          	jalr	1258(ra) # 800012c4 <acquire>

  if(panicked){
    80000de2:	0000b797          	auipc	a5,0xb
    80000de6:	ade78793          	addi	a5,a5,-1314 # 8000b8c0 <panicked>
    80000dea:	439c                	lw	a5,0(a5)
    80000dec:	2781                	sext.w	a5,a5
    80000dee:	cf99                	beqz	a5,80000e0c <uartputc+0x48>
    for(;;)
    80000df0:	0001                	nop
    80000df2:	bffd                	j	80000df0 <uartputc+0x2c>
      ;
  }
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    // buffer is full.
    // wait for uartstart() to open up space in the buffer.
    sleep(&uart_tx_r, &uart_tx_lock);
    80000df4:	00013597          	auipc	a1,0x13
    80000df8:	d0458593          	addi	a1,a1,-764 # 80013af8 <uart_tx_lock>
    80000dfc:	0000b517          	auipc	a0,0xb
    80000e00:	ad450513          	addi	a0,a0,-1324 # 8000b8d0 <uart_tx_r>
    80000e04:	00002097          	auipc	ra,0x2
    80000e08:	672080e7          	jalr	1650(ra) # 80003476 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000e0c:	0000b797          	auipc	a5,0xb
    80000e10:	ac478793          	addi	a5,a5,-1340 # 8000b8d0 <uart_tx_r>
    80000e14:	639c                	ld	a5,0(a5)
    80000e16:	02078713          	addi	a4,a5,32
    80000e1a:	0000b797          	auipc	a5,0xb
    80000e1e:	aae78793          	addi	a5,a5,-1362 # 8000b8c8 <uart_tx_w>
    80000e22:	639c                	ld	a5,0(a5)
    80000e24:	fcf708e3          	beq	a4,a5,80000df4 <uartputc+0x30>
  }
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000e28:	0000b797          	auipc	a5,0xb
    80000e2c:	aa078793          	addi	a5,a5,-1376 # 8000b8c8 <uart_tx_w>
    80000e30:	639c                	ld	a5,0(a5)
    80000e32:	8bfd                	andi	a5,a5,31
    80000e34:	fec42703          	lw	a4,-20(s0)
    80000e38:	0ff77713          	zext.b	a4,a4
    80000e3c:	00013697          	auipc	a3,0x13
    80000e40:	cd468693          	addi	a3,a3,-812 # 80013b10 <uart_tx_buf>
    80000e44:	97b6                	add	a5,a5,a3
    80000e46:	00e78023          	sb	a4,0(a5)
  uart_tx_w += 1;
    80000e4a:	0000b797          	auipc	a5,0xb
    80000e4e:	a7e78793          	addi	a5,a5,-1410 # 8000b8c8 <uart_tx_w>
    80000e52:	639c                	ld	a5,0(a5)
    80000e54:	00178713          	addi	a4,a5,1
    80000e58:	0000b797          	auipc	a5,0xb
    80000e5c:	a7078793          	addi	a5,a5,-1424 # 8000b8c8 <uart_tx_w>
    80000e60:	e398                	sd	a4,0(a5)
  uartstart();
    80000e62:	00000097          	auipc	ra,0x0
    80000e66:	086080e7          	jalr	134(ra) # 80000ee8 <uartstart>
  release(&uart_tx_lock);
    80000e6a:	00013517          	auipc	a0,0x13
    80000e6e:	c8e50513          	addi	a0,a0,-882 # 80013af8 <uart_tx_lock>
    80000e72:	00000097          	auipc	ra,0x0
    80000e76:	4b6080e7          	jalr	1206(ra) # 80001328 <release>
}
    80000e7a:	0001                	nop
    80000e7c:	60e2                	ld	ra,24(sp)
    80000e7e:	6442                	ld	s0,16(sp)
    80000e80:	6105                	addi	sp,sp,32
    80000e82:	8082                	ret

0000000080000e84 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000e84:	1101                	addi	sp,sp,-32
    80000e86:	ec06                	sd	ra,24(sp)
    80000e88:	e822                	sd	s0,16(sp)
    80000e8a:	1000                	addi	s0,sp,32
    80000e8c:	87aa                	mv	a5,a0
    80000e8e:	fef42623          	sw	a5,-20(s0)
  push_off();
    80000e92:	00000097          	auipc	ra,0x0
    80000e96:	530080e7          	jalr	1328(ra) # 800013c2 <push_off>

  if(panicked){
    80000e9a:	0000b797          	auipc	a5,0xb
    80000e9e:	a2678793          	addi	a5,a5,-1498 # 8000b8c0 <panicked>
    80000ea2:	439c                	lw	a5,0(a5)
    80000ea4:	2781                	sext.w	a5,a5
    80000ea6:	c399                	beqz	a5,80000eac <uartputc_sync+0x28>
    for(;;)
    80000ea8:	0001                	nop
    80000eaa:	bffd                	j	80000ea8 <uartputc_sync+0x24>
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000eac:	0001                	nop
    80000eae:	100007b7          	lui	a5,0x10000
    80000eb2:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80000eb4:	0007c783          	lbu	a5,0(a5)
    80000eb8:	0ff7f793          	zext.b	a5,a5
    80000ebc:	2781                	sext.w	a5,a5
    80000ebe:	0207f793          	andi	a5,a5,32
    80000ec2:	2781                	sext.w	a5,a5
    80000ec4:	d7ed                	beqz	a5,80000eae <uartputc_sync+0x2a>
    ;
  WriteReg(THR, c);
    80000ec6:	100007b7          	lui	a5,0x10000
    80000eca:	fec42703          	lw	a4,-20(s0)
    80000ece:	0ff77713          	zext.b	a4,a4
    80000ed2:	00e78023          	sb	a4,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000ed6:	00000097          	auipc	ra,0x0
    80000eda:	544080e7          	jalr	1348(ra) # 8000141a <pop_off>
}
    80000ede:	0001                	nop
    80000ee0:	60e2                	ld	ra,24(sp)
    80000ee2:	6442                	ld	s0,16(sp)
    80000ee4:	6105                	addi	sp,sp,32
    80000ee6:	8082                	ret

0000000080000ee8 <uartstart>:
// in the transmit buffer, send it.
// caller must hold uart_tx_lock.
// called from both the top- and bottom-half.
void
uartstart()
{
    80000ee8:	1101                	addi	sp,sp,-32
    80000eea:	ec06                	sd	ra,24(sp)
    80000eec:	e822                	sd	s0,16(sp)
    80000eee:	1000                	addi	s0,sp,32
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000ef0:	0000b797          	auipc	a5,0xb
    80000ef4:	9d878793          	addi	a5,a5,-1576 # 8000b8c8 <uart_tx_w>
    80000ef8:	6398                	ld	a4,0(a5)
    80000efa:	0000b797          	auipc	a5,0xb
    80000efe:	9d678793          	addi	a5,a5,-1578 # 8000b8d0 <uart_tx_r>
    80000f02:	639c                	ld	a5,0(a5)
    80000f04:	06f70a63          	beq	a4,a5,80000f78 <uartstart+0x90>
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000f08:	100007b7          	lui	a5,0x10000
    80000f0c:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80000f0e:	0007c783          	lbu	a5,0(a5)
    80000f12:	0ff7f793          	zext.b	a5,a5
    80000f16:	2781                	sext.w	a5,a5
    80000f18:	0207f793          	andi	a5,a5,32
    80000f1c:	2781                	sext.w	a5,a5
    80000f1e:	cfb9                	beqz	a5,80000f7c <uartstart+0x94>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000f20:	0000b797          	auipc	a5,0xb
    80000f24:	9b078793          	addi	a5,a5,-1616 # 8000b8d0 <uart_tx_r>
    80000f28:	639c                	ld	a5,0(a5)
    80000f2a:	8bfd                	andi	a5,a5,31
    80000f2c:	00013717          	auipc	a4,0x13
    80000f30:	be470713          	addi	a4,a4,-1052 # 80013b10 <uart_tx_buf>
    80000f34:	97ba                	add	a5,a5,a4
    80000f36:	0007c783          	lbu	a5,0(a5)
    80000f3a:	fef42623          	sw	a5,-20(s0)
    uart_tx_r += 1;
    80000f3e:	0000b797          	auipc	a5,0xb
    80000f42:	99278793          	addi	a5,a5,-1646 # 8000b8d0 <uart_tx_r>
    80000f46:	639c                	ld	a5,0(a5)
    80000f48:	00178713          	addi	a4,a5,1
    80000f4c:	0000b797          	auipc	a5,0xb
    80000f50:	98478793          	addi	a5,a5,-1660 # 8000b8d0 <uart_tx_r>
    80000f54:	e398                	sd	a4,0(a5)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80000f56:	0000b517          	auipc	a0,0xb
    80000f5a:	97a50513          	addi	a0,a0,-1670 # 8000b8d0 <uart_tx_r>
    80000f5e:	00002097          	auipc	ra,0x2
    80000f62:	594080e7          	jalr	1428(ra) # 800034f2 <wakeup>
    
    WriteReg(THR, c);
    80000f66:	100007b7          	lui	a5,0x10000
    80000f6a:	fec42703          	lw	a4,-20(s0)
    80000f6e:	0ff77713          	zext.b	a4,a4
    80000f72:	00e78023          	sb	a4,0(a5) # 10000000 <_entry-0x70000000>
  while(1){
    80000f76:	bfad                	j	80000ef0 <uartstart+0x8>
      return;
    80000f78:	0001                	nop
    80000f7a:	a011                	j	80000f7e <uartstart+0x96>
      return;
    80000f7c:	0001                	nop
  }
}
    80000f7e:	60e2                	ld	ra,24(sp)
    80000f80:	6442                	ld	s0,16(sp)
    80000f82:	6105                	addi	sp,sp,32
    80000f84:	8082                	ret

0000000080000f86 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000f86:	1141                	addi	sp,sp,-16
    80000f88:	e406                	sd	ra,8(sp)
    80000f8a:	e022                	sd	s0,0(sp)
    80000f8c:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000f8e:	100007b7          	lui	a5,0x10000
    80000f92:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80000f94:	0007c783          	lbu	a5,0(a5)
    80000f98:	0ff7f793          	zext.b	a5,a5
    80000f9c:	2781                	sext.w	a5,a5
    80000f9e:	8b85                	andi	a5,a5,1
    80000fa0:	2781                	sext.w	a5,a5
    80000fa2:	cb89                	beqz	a5,80000fb4 <uartgetc+0x2e>
    // input data is ready.
    return ReadReg(RHR);
    80000fa4:	100007b7          	lui	a5,0x10000
    80000fa8:	0007c783          	lbu	a5,0(a5) # 10000000 <_entry-0x70000000>
    80000fac:	0ff7f793          	zext.b	a5,a5
    80000fb0:	2781                	sext.w	a5,a5
    80000fb2:	a011                	j	80000fb6 <uartgetc+0x30>
  } else {
    return -1;
    80000fb4:	57fd                	li	a5,-1
  }
}
    80000fb6:	853e                	mv	a0,a5
    80000fb8:	60a2                	ld	ra,8(sp)
    80000fba:	6402                	ld	s0,0(sp)
    80000fbc:	0141                	addi	sp,sp,16
    80000fbe:	8082                	ret

0000000080000fc0 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000fc0:	1101                	addi	sp,sp,-32
    80000fc2:	ec06                	sd	ra,24(sp)
    80000fc4:	e822                	sd	s0,16(sp)
    80000fc6:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    80000fc8:	00000097          	auipc	ra,0x0
    80000fcc:	fbe080e7          	jalr	-66(ra) # 80000f86 <uartgetc>
    80000fd0:	87aa                	mv	a5,a0
    80000fd2:	fef42623          	sw	a5,-20(s0)
    if(c == -1)
    80000fd6:	fec42783          	lw	a5,-20(s0)
    80000fda:	0007871b          	sext.w	a4,a5
    80000fde:	57fd                	li	a5,-1
    80000fe0:	00f70a63          	beq	a4,a5,80000ff4 <uartintr+0x34>
      break;
    consoleintr(c);
    80000fe4:	fec42783          	lw	a5,-20(s0)
    80000fe8:	853e                	mv	a0,a5
    80000fea:	fffff097          	auipc	ra,0xfffff
    80000fee:	648080e7          	jalr	1608(ra) # 80000632 <consoleintr>
  while(1){
    80000ff2:	bfd9                	j	80000fc8 <uartintr+0x8>
      break;
    80000ff4:	0001                	nop
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000ff6:	00013517          	auipc	a0,0x13
    80000ffa:	b0250513          	addi	a0,a0,-1278 # 80013af8 <uart_tx_lock>
    80000ffe:	00000097          	auipc	ra,0x0
    80001002:	2c6080e7          	jalr	710(ra) # 800012c4 <acquire>
  uartstart();
    80001006:	00000097          	auipc	ra,0x0
    8000100a:	ee2080e7          	jalr	-286(ra) # 80000ee8 <uartstart>
  release(&uart_tx_lock);
    8000100e:	00013517          	auipc	a0,0x13
    80001012:	aea50513          	addi	a0,a0,-1302 # 80013af8 <uart_tx_lock>
    80001016:	00000097          	auipc	ra,0x0
    8000101a:	312080e7          	jalr	786(ra) # 80001328 <release>
}
    8000101e:	0001                	nop
    80001020:	60e2                	ld	ra,24(sp)
    80001022:	6442                	ld	s0,16(sp)
    80001024:	6105                	addi	sp,sp,32
    80001026:	8082                	ret

0000000080001028 <kinit>:
  struct run *freelist;
} kmem;

void
kinit()
{
    80001028:	1141                	addi	sp,sp,-16
    8000102a:	e406                	sd	ra,8(sp)
    8000102c:	e022                	sd	s0,0(sp)
    8000102e:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80001030:	0000a597          	auipc	a1,0xa
    80001034:	01058593          	addi	a1,a1,16 # 8000b040 <etext+0x40>
    80001038:	00013517          	auipc	a0,0x13
    8000103c:	af850513          	addi	a0,a0,-1288 # 80013b30 <kmem>
    80001040:	00000097          	auipc	ra,0x0
    80001044:	250080e7          	jalr	592(ra) # 80001290 <initlock>
  freerange(end, (void*)PHYSTOP);
    80001048:	47c5                	li	a5,17
    8000104a:	01b79593          	slli	a1,a5,0x1b
    8000104e:	00024517          	auipc	a0,0x24
    80001052:	d1a50513          	addi	a0,a0,-742 # 80024d68 <end>
    80001056:	00000097          	auipc	ra,0x0
    8000105a:	012080e7          	jalr	18(ra) # 80001068 <freerange>
}
    8000105e:	0001                	nop
    80001060:	60a2                	ld	ra,8(sp)
    80001062:	6402                	ld	s0,0(sp)
    80001064:	0141                	addi	sp,sp,16
    80001066:	8082                	ret

0000000080001068 <freerange>:

void
freerange(void *pa_start, void *pa_end)
{
    80001068:	7179                	addi	sp,sp,-48
    8000106a:	f406                	sd	ra,40(sp)
    8000106c:	f022                	sd	s0,32(sp)
    8000106e:	1800                	addi	s0,sp,48
    80001070:	fca43c23          	sd	a0,-40(s0)
    80001074:	fcb43823          	sd	a1,-48(s0)
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
    80001078:	fd843703          	ld	a4,-40(s0)
    8000107c:	6785                	lui	a5,0x1
    8000107e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001080:	973e                	add	a4,a4,a5
    80001082:	77fd                	lui	a5,0xfffff
    80001084:	8ff9                	and	a5,a5,a4
    80001086:	fef43423          	sd	a5,-24(s0)
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000108a:	a829                	j	800010a4 <freerange+0x3c>
    kfree(p);
    8000108c:	fe843503          	ld	a0,-24(s0)
    80001090:	00000097          	auipc	ra,0x0
    80001094:	030080e7          	jalr	48(ra) # 800010c0 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80001098:	fe843703          	ld	a4,-24(s0)
    8000109c:	6785                	lui	a5,0x1
    8000109e:	97ba                	add	a5,a5,a4
    800010a0:	fef43423          	sd	a5,-24(s0)
    800010a4:	fe843703          	ld	a4,-24(s0)
    800010a8:	6785                	lui	a5,0x1
    800010aa:	97ba                	add	a5,a5,a4
    800010ac:	fd043703          	ld	a4,-48(s0)
    800010b0:	fcf77ee3          	bgeu	a4,a5,8000108c <freerange+0x24>
}
    800010b4:	0001                	nop
    800010b6:	0001                	nop
    800010b8:	70a2                	ld	ra,40(sp)
    800010ba:	7402                	ld	s0,32(sp)
    800010bc:	6145                	addi	sp,sp,48
    800010be:	8082                	ret

00000000800010c0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800010c0:	7179                	addi	sp,sp,-48
    800010c2:	f406                	sd	ra,40(sp)
    800010c4:	f022                	sd	s0,32(sp)
    800010c6:	1800                	addi	s0,sp,48
    800010c8:	fca43c23          	sd	a0,-40(s0)
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800010cc:	fd843703          	ld	a4,-40(s0)
    800010d0:	6785                	lui	a5,0x1
    800010d2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800010d4:	8ff9                	and	a5,a5,a4
    800010d6:	ef99                	bnez	a5,800010f4 <kfree+0x34>
    800010d8:	fd843703          	ld	a4,-40(s0)
    800010dc:	00024797          	auipc	a5,0x24
    800010e0:	c8c78793          	addi	a5,a5,-884 # 80024d68 <end>
    800010e4:	00f76863          	bltu	a4,a5,800010f4 <kfree+0x34>
    800010e8:	fd843703          	ld	a4,-40(s0)
    800010ec:	47c5                	li	a5,17
    800010ee:	07ee                	slli	a5,a5,0x1b
    800010f0:	00f76a63          	bltu	a4,a5,80001104 <kfree+0x44>
    panic("kfree");
    800010f4:	0000a517          	auipc	a0,0xa
    800010f8:	f5450513          	addi	a0,a0,-172 # 8000b048 <etext+0x48>
    800010fc:	00000097          	auipc	ra,0x0
    80001100:	bc4080e7          	jalr	-1084(ra) # 80000cc0 <panic>

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80001104:	6605                	lui	a2,0x1
    80001106:	4585                	li	a1,1
    80001108:	fd843503          	ld	a0,-40(s0)
    8000110c:	00000097          	auipc	ra,0x0
    80001110:	38c080e7          	jalr	908(ra) # 80001498 <memset>

  r = (struct run*)pa;
    80001114:	fd843783          	ld	a5,-40(s0)
    80001118:	fef43423          	sd	a5,-24(s0)

  acquire(&kmem.lock);
    8000111c:	00013517          	auipc	a0,0x13
    80001120:	a1450513          	addi	a0,a0,-1516 # 80013b30 <kmem>
    80001124:	00000097          	auipc	ra,0x0
    80001128:	1a0080e7          	jalr	416(ra) # 800012c4 <acquire>
  r->next = kmem.freelist;
    8000112c:	00013797          	auipc	a5,0x13
    80001130:	a0478793          	addi	a5,a5,-1532 # 80013b30 <kmem>
    80001134:	6f98                	ld	a4,24(a5)
    80001136:	fe843783          	ld	a5,-24(s0)
    8000113a:	e398                	sd	a4,0(a5)
  kmem.freelist = r;
    8000113c:	00013797          	auipc	a5,0x13
    80001140:	9f478793          	addi	a5,a5,-1548 # 80013b30 <kmem>
    80001144:	fe843703          	ld	a4,-24(s0)
    80001148:	ef98                	sd	a4,24(a5)
  release(&kmem.lock);
    8000114a:	00013517          	auipc	a0,0x13
    8000114e:	9e650513          	addi	a0,a0,-1562 # 80013b30 <kmem>
    80001152:	00000097          	auipc	ra,0x0
    80001156:	1d6080e7          	jalr	470(ra) # 80001328 <release>
}
    8000115a:	0001                	nop
    8000115c:	70a2                	ld	ra,40(sp)
    8000115e:	7402                	ld	s0,32(sp)
    80001160:	6145                	addi	sp,sp,48
    80001162:	8082                	ret

0000000080001164 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80001164:	1101                	addi	sp,sp,-32
    80001166:	ec06                	sd	ra,24(sp)
    80001168:	e822                	sd	s0,16(sp)
    8000116a:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    8000116c:	00013517          	auipc	a0,0x13
    80001170:	9c450513          	addi	a0,a0,-1596 # 80013b30 <kmem>
    80001174:	00000097          	auipc	ra,0x0
    80001178:	150080e7          	jalr	336(ra) # 800012c4 <acquire>
  r = kmem.freelist;
    8000117c:	00013797          	auipc	a5,0x13
    80001180:	9b478793          	addi	a5,a5,-1612 # 80013b30 <kmem>
    80001184:	6f9c                	ld	a5,24(a5)
    80001186:	fef43423          	sd	a5,-24(s0)
  if(r)
    8000118a:	fe843783          	ld	a5,-24(s0)
    8000118e:	cb89                	beqz	a5,800011a0 <kalloc+0x3c>
    kmem.freelist = r->next;
    80001190:	fe843783          	ld	a5,-24(s0)
    80001194:	6398                	ld	a4,0(a5)
    80001196:	00013797          	auipc	a5,0x13
    8000119a:	99a78793          	addi	a5,a5,-1638 # 80013b30 <kmem>
    8000119e:	ef98                	sd	a4,24(a5)
  release(&kmem.lock);
    800011a0:	00013517          	auipc	a0,0x13
    800011a4:	99050513          	addi	a0,a0,-1648 # 80013b30 <kmem>
    800011a8:	00000097          	auipc	ra,0x0
    800011ac:	180080e7          	jalr	384(ra) # 80001328 <release>

  if(r)
    800011b0:	fe843783          	ld	a5,-24(s0)
    800011b4:	cb89                	beqz	a5,800011c6 <kalloc+0x62>
    memset((char*)r, 5, PGSIZE); // fill with junk
    800011b6:	6605                	lui	a2,0x1
    800011b8:	4595                	li	a1,5
    800011ba:	fe843503          	ld	a0,-24(s0)
    800011be:	00000097          	auipc	ra,0x0
    800011c2:	2da080e7          	jalr	730(ra) # 80001498 <memset>
  return (void*)r;
    800011c6:	fe843783          	ld	a5,-24(s0)
}
    800011ca:	853e                	mv	a0,a5
    800011cc:	60e2                	ld	ra,24(sp)
    800011ce:	6442                	ld	s0,16(sp)
    800011d0:	6105                	addi	sp,sp,32
    800011d2:	8082                	ret

00000000800011d4 <r_sstatus>:
{
    800011d4:	1101                	addi	sp,sp,-32
    800011d6:	ec06                	sd	ra,24(sp)
    800011d8:	e822                	sd	s0,16(sp)
    800011da:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800011dc:	100027f3          	csrr	a5,sstatus
    800011e0:	fef43423          	sd	a5,-24(s0)
  return x;
    800011e4:	fe843783          	ld	a5,-24(s0)
}
    800011e8:	853e                	mv	a0,a5
    800011ea:	60e2                	ld	ra,24(sp)
    800011ec:	6442                	ld	s0,16(sp)
    800011ee:	6105                	addi	sp,sp,32
    800011f0:	8082                	ret

00000000800011f2 <w_sstatus>:
{
    800011f2:	1101                	addi	sp,sp,-32
    800011f4:	ec06                	sd	ra,24(sp)
    800011f6:	e822                	sd	s0,16(sp)
    800011f8:	1000                	addi	s0,sp,32
    800011fa:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800011fe:	fe843783          	ld	a5,-24(s0)
    80001202:	10079073          	csrw	sstatus,a5
}
    80001206:	0001                	nop
    80001208:	60e2                	ld	ra,24(sp)
    8000120a:	6442                	ld	s0,16(sp)
    8000120c:	6105                	addi	sp,sp,32
    8000120e:	8082                	ret

0000000080001210 <intr_on>:
{
    80001210:	1141                	addi	sp,sp,-16
    80001212:	e406                	sd	ra,8(sp)
    80001214:	e022                	sd	s0,0(sp)
    80001216:	0800                	addi	s0,sp,16
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001218:	00000097          	auipc	ra,0x0
    8000121c:	fbc080e7          	jalr	-68(ra) # 800011d4 <r_sstatus>
    80001220:	87aa                	mv	a5,a0
    80001222:	0027e793          	ori	a5,a5,2
    80001226:	853e                	mv	a0,a5
    80001228:	00000097          	auipc	ra,0x0
    8000122c:	fca080e7          	jalr	-54(ra) # 800011f2 <w_sstatus>
}
    80001230:	0001                	nop
    80001232:	60a2                	ld	ra,8(sp)
    80001234:	6402                	ld	s0,0(sp)
    80001236:	0141                	addi	sp,sp,16
    80001238:	8082                	ret

000000008000123a <intr_off>:
{
    8000123a:	1141                	addi	sp,sp,-16
    8000123c:	e406                	sd	ra,8(sp)
    8000123e:	e022                	sd	s0,0(sp)
    80001240:	0800                	addi	s0,sp,16
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001242:	00000097          	auipc	ra,0x0
    80001246:	f92080e7          	jalr	-110(ra) # 800011d4 <r_sstatus>
    8000124a:	87aa                	mv	a5,a0
    8000124c:	9bf5                	andi	a5,a5,-3
    8000124e:	853e                	mv	a0,a5
    80001250:	00000097          	auipc	ra,0x0
    80001254:	fa2080e7          	jalr	-94(ra) # 800011f2 <w_sstatus>
}
    80001258:	0001                	nop
    8000125a:	60a2                	ld	ra,8(sp)
    8000125c:	6402                	ld	s0,0(sp)
    8000125e:	0141                	addi	sp,sp,16
    80001260:	8082                	ret

0000000080001262 <intr_get>:
{
    80001262:	1101                	addi	sp,sp,-32
    80001264:	ec06                	sd	ra,24(sp)
    80001266:	e822                	sd	s0,16(sp)
    80001268:	1000                	addi	s0,sp,32
  uint64 x = r_sstatus();
    8000126a:	00000097          	auipc	ra,0x0
    8000126e:	f6a080e7          	jalr	-150(ra) # 800011d4 <r_sstatus>
    80001272:	fea43423          	sd	a0,-24(s0)
  return (x & SSTATUS_SIE) != 0;
    80001276:	fe843783          	ld	a5,-24(s0)
    8000127a:	8b89                	andi	a5,a5,2
    8000127c:	00f037b3          	snez	a5,a5
    80001280:	0ff7f793          	zext.b	a5,a5
    80001284:	2781                	sext.w	a5,a5
}
    80001286:	853e                	mv	a0,a5
    80001288:	60e2                	ld	ra,24(sp)
    8000128a:	6442                	ld	s0,16(sp)
    8000128c:	6105                	addi	sp,sp,32
    8000128e:	8082                	ret

0000000080001290 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80001290:	1101                	addi	sp,sp,-32
    80001292:	ec06                	sd	ra,24(sp)
    80001294:	e822                	sd	s0,16(sp)
    80001296:	1000                	addi	s0,sp,32
    80001298:	fea43423          	sd	a0,-24(s0)
    8000129c:	feb43023          	sd	a1,-32(s0)
  lk->name = name;
    800012a0:	fe843783          	ld	a5,-24(s0)
    800012a4:	fe043703          	ld	a4,-32(s0)
    800012a8:	e798                	sd	a4,8(a5)
  lk->locked = 0;
    800012aa:	fe843783          	ld	a5,-24(s0)
    800012ae:	0007a023          	sw	zero,0(a5)
  lk->cpu = 0;
    800012b2:	fe843783          	ld	a5,-24(s0)
    800012b6:	0007b823          	sd	zero,16(a5)
}
    800012ba:	0001                	nop
    800012bc:	60e2                	ld	ra,24(sp)
    800012be:	6442                	ld	s0,16(sp)
    800012c0:	6105                	addi	sp,sp,32
    800012c2:	8082                	ret

00000000800012c4 <acquire>:

// Acquire the lock.
// Loops (spins) until the lock is acquired.
void
acquire(struct spinlock *lk)
{
    800012c4:	1101                	addi	sp,sp,-32
    800012c6:	ec06                	sd	ra,24(sp)
    800012c8:	e822                	sd	s0,16(sp)
    800012ca:	1000                	addi	s0,sp,32
    800012cc:	fea43423          	sd	a0,-24(s0)
  push_off(); // disable interrupts to avoid deadlock.
    800012d0:	00000097          	auipc	ra,0x0
    800012d4:	0f2080e7          	jalr	242(ra) # 800013c2 <push_off>
  if(holding(lk))
    800012d8:	fe843503          	ld	a0,-24(s0)
    800012dc:	00000097          	auipc	ra,0x0
    800012e0:	0a2080e7          	jalr	162(ra) # 8000137e <holding>
    800012e4:	87aa                	mv	a5,a0
    800012e6:	cb89                	beqz	a5,800012f8 <acquire+0x34>
    panic("acquire");
    800012e8:	0000a517          	auipc	a0,0xa
    800012ec:	d6850513          	addi	a0,a0,-664 # 8000b050 <etext+0x50>
    800012f0:	00000097          	auipc	ra,0x0
    800012f4:	9d0080e7          	jalr	-1584(ra) # 80000cc0 <panic>

  // On RISC-V, sync_lock_test_and_set turns into an atomic swap:
  //   a5 = 1
  //   s1 = &lk->locked
  //   amoswap.w.aq a5, a5, (s1)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800012f8:	0001                	nop
    800012fa:	fe843783          	ld	a5,-24(s0)
    800012fe:	4705                	li	a4,1
    80001300:	0ce7a72f          	amoswap.w.aq	a4,a4,(a5)
    80001304:	0007079b          	sext.w	a5,a4
    80001308:	fbed                	bnez	a5,800012fa <acquire+0x36>

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen strictly after the lock is acquired.
  // On RISC-V, this emits a fence instruction.
  __sync_synchronize();
    8000130a:	0330000f          	fence	rw,rw

  // Record info about lock acquisition for holding() and debugging.
  lk->cpu = mycpu();
    8000130e:	00001097          	auipc	ra,0x1
    80001312:	574080e7          	jalr	1396(ra) # 80002882 <mycpu>
    80001316:	872a                	mv	a4,a0
    80001318:	fe843783          	ld	a5,-24(s0)
    8000131c:	eb98                	sd	a4,16(a5)
}
    8000131e:	0001                	nop
    80001320:	60e2                	ld	ra,24(sp)
    80001322:	6442                	ld	s0,16(sp)
    80001324:	6105                	addi	sp,sp,32
    80001326:	8082                	ret

0000000080001328 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
    80001328:	1101                	addi	sp,sp,-32
    8000132a:	ec06                	sd	ra,24(sp)
    8000132c:	e822                	sd	s0,16(sp)
    8000132e:	1000                	addi	s0,sp,32
    80001330:	fea43423          	sd	a0,-24(s0)
  if(!holding(lk))
    80001334:	fe843503          	ld	a0,-24(s0)
    80001338:	00000097          	auipc	ra,0x0
    8000133c:	046080e7          	jalr	70(ra) # 8000137e <holding>
    80001340:	87aa                	mv	a5,a0
    80001342:	eb89                	bnez	a5,80001354 <release+0x2c>
    panic("release");
    80001344:	0000a517          	auipc	a0,0xa
    80001348:	d1450513          	addi	a0,a0,-748 # 8000b058 <etext+0x58>
    8000134c:	00000097          	auipc	ra,0x0
    80001350:	974080e7          	jalr	-1676(ra) # 80000cc0 <panic>

  lk->cpu = 0;
    80001354:	fe843783          	ld	a5,-24(s0)
    80001358:	0007b823          	sd	zero,16(a5)
  // past this point, to ensure that all the stores in the critical
  // section are visible to other CPUs before the lock is released,
  // and that loads in the critical section occur strictly before
  // the lock is released.
  // On RISC-V, this emits a fence instruction.
  __sync_synchronize();
    8000135c:	0330000f          	fence	rw,rw
  // implies that an assignment might be implemented with
  // multiple store instructions.
  // On RISC-V, sync_lock_release turns into an atomic swap:
  //   s1 = &lk->locked
  //   amoswap.w zero, zero, (s1)
  __sync_lock_release(&lk->locked);
    80001360:	fe843783          	ld	a5,-24(s0)
    80001364:	0310000f          	fence	rw,w
    80001368:	0007a023          	sw	zero,0(a5)

  pop_off();
    8000136c:	00000097          	auipc	ra,0x0
    80001370:	0ae080e7          	jalr	174(ra) # 8000141a <pop_off>
}
    80001374:	0001                	nop
    80001376:	60e2                	ld	ra,24(sp)
    80001378:	6442                	ld	s0,16(sp)
    8000137a:	6105                	addi	sp,sp,32
    8000137c:	8082                	ret

000000008000137e <holding>:

// Check whether this cpu is holding the lock.
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
    8000137e:	7139                	addi	sp,sp,-64
    80001380:	fc06                	sd	ra,56(sp)
    80001382:	f822                	sd	s0,48(sp)
    80001384:	f426                	sd	s1,40(sp)
    80001386:	0080                	addi	s0,sp,64
    80001388:	fca43423          	sd	a0,-56(s0)
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000138c:	fc843783          	ld	a5,-56(s0)
    80001390:	439c                	lw	a5,0(a5)
    80001392:	cf89                	beqz	a5,800013ac <holding+0x2e>
    80001394:	fc843783          	ld	a5,-56(s0)
    80001398:	6b84                	ld	s1,16(a5)
    8000139a:	00001097          	auipc	ra,0x1
    8000139e:	4e8080e7          	jalr	1256(ra) # 80002882 <mycpu>
    800013a2:	87aa                	mv	a5,a0
    800013a4:	00f49463          	bne	s1,a5,800013ac <holding+0x2e>
    800013a8:	4785                	li	a5,1
    800013aa:	a011                	j	800013ae <holding+0x30>
    800013ac:	4781                	li	a5,0
    800013ae:	fcf42e23          	sw	a5,-36(s0)
  return r;
    800013b2:	fdc42783          	lw	a5,-36(s0)
}
    800013b6:	853e                	mv	a0,a5
    800013b8:	70e2                	ld	ra,56(sp)
    800013ba:	7442                	ld	s0,48(sp)
    800013bc:	74a2                	ld	s1,40(sp)
    800013be:	6121                	addi	sp,sp,64
    800013c0:	8082                	ret

00000000800013c2 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800013c2:	1101                	addi	sp,sp,-32
    800013c4:	ec06                	sd	ra,24(sp)
    800013c6:	e822                	sd	s0,16(sp)
    800013c8:	1000                	addi	s0,sp,32
  int old = intr_get();
    800013ca:	00000097          	auipc	ra,0x0
    800013ce:	e98080e7          	jalr	-360(ra) # 80001262 <intr_get>
    800013d2:	87aa                	mv	a5,a0
    800013d4:	fef42623          	sw	a5,-20(s0)

  intr_off();
    800013d8:	00000097          	auipc	ra,0x0
    800013dc:	e62080e7          	jalr	-414(ra) # 8000123a <intr_off>
  if(mycpu()->noff == 0)
    800013e0:	00001097          	auipc	ra,0x1
    800013e4:	4a2080e7          	jalr	1186(ra) # 80002882 <mycpu>
    800013e8:	87aa                	mv	a5,a0
    800013ea:	5fbc                	lw	a5,120(a5)
    800013ec:	eb89                	bnez	a5,800013fe <push_off+0x3c>
    mycpu()->intena = old;
    800013ee:	00001097          	auipc	ra,0x1
    800013f2:	494080e7          	jalr	1172(ra) # 80002882 <mycpu>
    800013f6:	872a                	mv	a4,a0
    800013f8:	fec42783          	lw	a5,-20(s0)
    800013fc:	df7c                	sw	a5,124(a4)
  mycpu()->noff += 1;
    800013fe:	00001097          	auipc	ra,0x1
    80001402:	484080e7          	jalr	1156(ra) # 80002882 <mycpu>
    80001406:	87aa                	mv	a5,a0
    80001408:	5fb8                	lw	a4,120(a5)
    8000140a:	2705                	addiw	a4,a4,1
    8000140c:	2701                	sext.w	a4,a4
    8000140e:	dfb8                	sw	a4,120(a5)
}
    80001410:	0001                	nop
    80001412:	60e2                	ld	ra,24(sp)
    80001414:	6442                	ld	s0,16(sp)
    80001416:	6105                	addi	sp,sp,32
    80001418:	8082                	ret

000000008000141a <pop_off>:

void
pop_off(void)
{
    8000141a:	1101                	addi	sp,sp,-32
    8000141c:	ec06                	sd	ra,24(sp)
    8000141e:	e822                	sd	s0,16(sp)
    80001420:	1000                	addi	s0,sp,32
  struct cpu *c = mycpu();
    80001422:	00001097          	auipc	ra,0x1
    80001426:	460080e7          	jalr	1120(ra) # 80002882 <mycpu>
    8000142a:	fea43423          	sd	a0,-24(s0)
  if(intr_get())
    8000142e:	00000097          	auipc	ra,0x0
    80001432:	e34080e7          	jalr	-460(ra) # 80001262 <intr_get>
    80001436:	87aa                	mv	a5,a0
    80001438:	cb89                	beqz	a5,8000144a <pop_off+0x30>
    panic("pop_off - interruptible");
    8000143a:	0000a517          	auipc	a0,0xa
    8000143e:	c2650513          	addi	a0,a0,-986 # 8000b060 <etext+0x60>
    80001442:	00000097          	auipc	ra,0x0
    80001446:	87e080e7          	jalr	-1922(ra) # 80000cc0 <panic>
  if(c->noff < 1)
    8000144a:	fe843783          	ld	a5,-24(s0)
    8000144e:	5fbc                	lw	a5,120(a5)
    80001450:	00f04a63          	bgtz	a5,80001464 <pop_off+0x4a>
    panic("pop_off");
    80001454:	0000a517          	auipc	a0,0xa
    80001458:	c2450513          	addi	a0,a0,-988 # 8000b078 <etext+0x78>
    8000145c:	00000097          	auipc	ra,0x0
    80001460:	864080e7          	jalr	-1948(ra) # 80000cc0 <panic>
  c->noff -= 1;
    80001464:	fe843783          	ld	a5,-24(s0)
    80001468:	5fbc                	lw	a5,120(a5)
    8000146a:	37fd                	addiw	a5,a5,-1
    8000146c:	0007871b          	sext.w	a4,a5
    80001470:	fe843783          	ld	a5,-24(s0)
    80001474:	dfb8                	sw	a4,120(a5)
  if(c->noff == 0 && c->intena)
    80001476:	fe843783          	ld	a5,-24(s0)
    8000147a:	5fbc                	lw	a5,120(a5)
    8000147c:	eb89                	bnez	a5,8000148e <pop_off+0x74>
    8000147e:	fe843783          	ld	a5,-24(s0)
    80001482:	5ffc                	lw	a5,124(a5)
    80001484:	c789                	beqz	a5,8000148e <pop_off+0x74>
    intr_on();
    80001486:	00000097          	auipc	ra,0x0
    8000148a:	d8a080e7          	jalr	-630(ra) # 80001210 <intr_on>
}
    8000148e:	0001                	nop
    80001490:	60e2                	ld	ra,24(sp)
    80001492:	6442                	ld	s0,16(sp)
    80001494:	6105                	addi	sp,sp,32
    80001496:	8082                	ret

0000000080001498 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80001498:	7179                	addi	sp,sp,-48
    8000149a:	f406                	sd	ra,40(sp)
    8000149c:	f022                	sd	s0,32(sp)
    8000149e:	1800                	addi	s0,sp,48
    800014a0:	fca43c23          	sd	a0,-40(s0)
    800014a4:	87ae                	mv	a5,a1
    800014a6:	8732                	mv	a4,a2
    800014a8:	fcf42a23          	sw	a5,-44(s0)
    800014ac:	87ba                	mv	a5,a4
    800014ae:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
    800014b2:	fd843783          	ld	a5,-40(s0)
    800014b6:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
    800014ba:	fe042623          	sw	zero,-20(s0)
    800014be:	a00d                	j	800014e0 <memset+0x48>
    cdst[i] = c;
    800014c0:	fec42783          	lw	a5,-20(s0)
    800014c4:	fe043703          	ld	a4,-32(s0)
    800014c8:	97ba                	add	a5,a5,a4
    800014ca:	fd442703          	lw	a4,-44(s0)
    800014ce:	0ff77713          	zext.b	a4,a4
    800014d2:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
    800014d6:	fec42783          	lw	a5,-20(s0)
    800014da:	2785                	addiw	a5,a5,1
    800014dc:	fef42623          	sw	a5,-20(s0)
    800014e0:	fec42783          	lw	a5,-20(s0)
    800014e4:	fd042703          	lw	a4,-48(s0)
    800014e8:	2701                	sext.w	a4,a4
    800014ea:	fce7ebe3          	bltu	a5,a4,800014c0 <memset+0x28>
  }
  return dst;
    800014ee:	fd843783          	ld	a5,-40(s0)
}
    800014f2:	853e                	mv	a0,a5
    800014f4:	70a2                	ld	ra,40(sp)
    800014f6:	7402                	ld	s0,32(sp)
    800014f8:	6145                	addi	sp,sp,48
    800014fa:	8082                	ret

00000000800014fc <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800014fc:	7139                	addi	sp,sp,-64
    800014fe:	fc06                	sd	ra,56(sp)
    80001500:	f822                	sd	s0,48(sp)
    80001502:	0080                	addi	s0,sp,64
    80001504:	fca43c23          	sd	a0,-40(s0)
    80001508:	fcb43823          	sd	a1,-48(s0)
    8000150c:	87b2                	mv	a5,a2
    8000150e:	fcf42623          	sw	a5,-52(s0)
  const uchar *s1, *s2;

  s1 = v1;
    80001512:	fd843783          	ld	a5,-40(s0)
    80001516:	fef43423          	sd	a5,-24(s0)
  s2 = v2;
    8000151a:	fd043783          	ld	a5,-48(s0)
    8000151e:	fef43023          	sd	a5,-32(s0)
  while(n-- > 0){
    80001522:	a0a1                	j	8000156a <memcmp+0x6e>
    if(*s1 != *s2)
    80001524:	fe843783          	ld	a5,-24(s0)
    80001528:	0007c703          	lbu	a4,0(a5)
    8000152c:	fe043783          	ld	a5,-32(s0)
    80001530:	0007c783          	lbu	a5,0(a5)
    80001534:	02f70163          	beq	a4,a5,80001556 <memcmp+0x5a>
      return *s1 - *s2;
    80001538:	fe843783          	ld	a5,-24(s0)
    8000153c:	0007c783          	lbu	a5,0(a5)
    80001540:	0007871b          	sext.w	a4,a5
    80001544:	fe043783          	ld	a5,-32(s0)
    80001548:	0007c783          	lbu	a5,0(a5)
    8000154c:	2781                	sext.w	a5,a5
    8000154e:	40f707bb          	subw	a5,a4,a5
    80001552:	2781                	sext.w	a5,a5
    80001554:	a01d                	j	8000157a <memcmp+0x7e>
    s1++, s2++;
    80001556:	fe843783          	ld	a5,-24(s0)
    8000155a:	0785                	addi	a5,a5,1
    8000155c:	fef43423          	sd	a5,-24(s0)
    80001560:	fe043783          	ld	a5,-32(s0)
    80001564:	0785                	addi	a5,a5,1
    80001566:	fef43023          	sd	a5,-32(s0)
  while(n-- > 0){
    8000156a:	fcc42783          	lw	a5,-52(s0)
    8000156e:	fff7871b          	addiw	a4,a5,-1
    80001572:	fce42623          	sw	a4,-52(s0)
    80001576:	f7dd                	bnez	a5,80001524 <memcmp+0x28>
  }

  return 0;
    80001578:	4781                	li	a5,0
}
    8000157a:	853e                	mv	a0,a5
    8000157c:	70e2                	ld	ra,56(sp)
    8000157e:	7442                	ld	s0,48(sp)
    80001580:	6121                	addi	sp,sp,64
    80001582:	8082                	ret

0000000080001584 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80001584:	7139                	addi	sp,sp,-64
    80001586:	fc06                	sd	ra,56(sp)
    80001588:	f822                	sd	s0,48(sp)
    8000158a:	0080                	addi	s0,sp,64
    8000158c:	fca43c23          	sd	a0,-40(s0)
    80001590:	fcb43823          	sd	a1,-48(s0)
    80001594:	87b2                	mv	a5,a2
    80001596:	fcf42623          	sw	a5,-52(s0)
  const char *s;
  char *d;

  if(n == 0)
    8000159a:	fcc42783          	lw	a5,-52(s0)
    8000159e:	2781                	sext.w	a5,a5
    800015a0:	e781                	bnez	a5,800015a8 <memmove+0x24>
    return dst;
    800015a2:	fd843783          	ld	a5,-40(s0)
    800015a6:	a855                	j	8000165a <memmove+0xd6>
  
  s = src;
    800015a8:	fd043783          	ld	a5,-48(s0)
    800015ac:	fef43423          	sd	a5,-24(s0)
  d = dst;
    800015b0:	fd843783          	ld	a5,-40(s0)
    800015b4:	fef43023          	sd	a5,-32(s0)
  if(s < d && s + n > d){
    800015b8:	fe843703          	ld	a4,-24(s0)
    800015bc:	fe043783          	ld	a5,-32(s0)
    800015c0:	08f77463          	bgeu	a4,a5,80001648 <memmove+0xc4>
    800015c4:	fcc46783          	lwu	a5,-52(s0)
    800015c8:	fe843703          	ld	a4,-24(s0)
    800015cc:	97ba                	add	a5,a5,a4
    800015ce:	fe043703          	ld	a4,-32(s0)
    800015d2:	06f77b63          	bgeu	a4,a5,80001648 <memmove+0xc4>
    s += n;
    800015d6:	fcc46783          	lwu	a5,-52(s0)
    800015da:	fe843703          	ld	a4,-24(s0)
    800015de:	97ba                	add	a5,a5,a4
    800015e0:	fef43423          	sd	a5,-24(s0)
    d += n;
    800015e4:	fcc46783          	lwu	a5,-52(s0)
    800015e8:	fe043703          	ld	a4,-32(s0)
    800015ec:	97ba                	add	a5,a5,a4
    800015ee:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
    800015f2:	a01d                	j	80001618 <memmove+0x94>
      *--d = *--s;
    800015f4:	fe843783          	ld	a5,-24(s0)
    800015f8:	17fd                	addi	a5,a5,-1
    800015fa:	fef43423          	sd	a5,-24(s0)
    800015fe:	fe043783          	ld	a5,-32(s0)
    80001602:	17fd                	addi	a5,a5,-1
    80001604:	fef43023          	sd	a5,-32(s0)
    80001608:	fe843783          	ld	a5,-24(s0)
    8000160c:	0007c703          	lbu	a4,0(a5)
    80001610:	fe043783          	ld	a5,-32(s0)
    80001614:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
    80001618:	fcc42783          	lw	a5,-52(s0)
    8000161c:	fff7871b          	addiw	a4,a5,-1
    80001620:	fce42623          	sw	a4,-52(s0)
    80001624:	fbe1                	bnez	a5,800015f4 <memmove+0x70>
  if(s < d && s + n > d){
    80001626:	a805                	j	80001656 <memmove+0xd2>
  } else
    while(n-- > 0)
      *d++ = *s++;
    80001628:	fe843703          	ld	a4,-24(s0)
    8000162c:	00170793          	addi	a5,a4,1
    80001630:	fef43423          	sd	a5,-24(s0)
    80001634:	fe043783          	ld	a5,-32(s0)
    80001638:	00178693          	addi	a3,a5,1
    8000163c:	fed43023          	sd	a3,-32(s0)
    80001640:	00074703          	lbu	a4,0(a4)
    80001644:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
    80001648:	fcc42783          	lw	a5,-52(s0)
    8000164c:	fff7871b          	addiw	a4,a5,-1
    80001650:	fce42623          	sw	a4,-52(s0)
    80001654:	fbf1                	bnez	a5,80001628 <memmove+0xa4>

  return dst;
    80001656:	fd843783          	ld	a5,-40(s0)
}
    8000165a:	853e                	mv	a0,a5
    8000165c:	70e2                	ld	ra,56(sp)
    8000165e:	7442                	ld	s0,48(sp)
    80001660:	6121                	addi	sp,sp,64
    80001662:	8082                	ret

0000000080001664 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80001664:	7179                	addi	sp,sp,-48
    80001666:	f406                	sd	ra,40(sp)
    80001668:	f022                	sd	s0,32(sp)
    8000166a:	1800                	addi	s0,sp,48
    8000166c:	fea43423          	sd	a0,-24(s0)
    80001670:	feb43023          	sd	a1,-32(s0)
    80001674:	87b2                	mv	a5,a2
    80001676:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
    8000167a:	fdc42783          	lw	a5,-36(s0)
    8000167e:	863e                	mv	a2,a5
    80001680:	fe043583          	ld	a1,-32(s0)
    80001684:	fe843503          	ld	a0,-24(s0)
    80001688:	00000097          	auipc	ra,0x0
    8000168c:	efc080e7          	jalr	-260(ra) # 80001584 <memmove>
    80001690:	87aa                	mv	a5,a0
}
    80001692:	853e                	mv	a0,a5
    80001694:	70a2                	ld	ra,40(sp)
    80001696:	7402                	ld	s0,32(sp)
    80001698:	6145                	addi	sp,sp,48
    8000169a:	8082                	ret

000000008000169c <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000169c:	7179                	addi	sp,sp,-48
    8000169e:	f406                	sd	ra,40(sp)
    800016a0:	f022                	sd	s0,32(sp)
    800016a2:	1800                	addi	s0,sp,48
    800016a4:	fea43423          	sd	a0,-24(s0)
    800016a8:	feb43023          	sd	a1,-32(s0)
    800016ac:	87b2                	mv	a5,a2
    800016ae:	fcf42e23          	sw	a5,-36(s0)
  while(n > 0 && *p && *p == *q)
    800016b2:	a005                	j	800016d2 <strncmp+0x36>
    n--, p++, q++;
    800016b4:	fdc42783          	lw	a5,-36(s0)
    800016b8:	37fd                	addiw	a5,a5,-1
    800016ba:	fcf42e23          	sw	a5,-36(s0)
    800016be:	fe843783          	ld	a5,-24(s0)
    800016c2:	0785                	addi	a5,a5,1
    800016c4:	fef43423          	sd	a5,-24(s0)
    800016c8:	fe043783          	ld	a5,-32(s0)
    800016cc:	0785                	addi	a5,a5,1
    800016ce:	fef43023          	sd	a5,-32(s0)
  while(n > 0 && *p && *p == *q)
    800016d2:	fdc42783          	lw	a5,-36(s0)
    800016d6:	2781                	sext.w	a5,a5
    800016d8:	c385                	beqz	a5,800016f8 <strncmp+0x5c>
    800016da:	fe843783          	ld	a5,-24(s0)
    800016de:	0007c783          	lbu	a5,0(a5)
    800016e2:	cb99                	beqz	a5,800016f8 <strncmp+0x5c>
    800016e4:	fe843783          	ld	a5,-24(s0)
    800016e8:	0007c703          	lbu	a4,0(a5)
    800016ec:	fe043783          	ld	a5,-32(s0)
    800016f0:	0007c783          	lbu	a5,0(a5)
    800016f4:	fcf700e3          	beq	a4,a5,800016b4 <strncmp+0x18>
  if(n == 0)
    800016f8:	fdc42783          	lw	a5,-36(s0)
    800016fc:	2781                	sext.w	a5,a5
    800016fe:	e399                	bnez	a5,80001704 <strncmp+0x68>
    return 0;
    80001700:	4781                	li	a5,0
    80001702:	a839                	j	80001720 <strncmp+0x84>
  return (uchar)*p - (uchar)*q;
    80001704:	fe843783          	ld	a5,-24(s0)
    80001708:	0007c783          	lbu	a5,0(a5)
    8000170c:	0007871b          	sext.w	a4,a5
    80001710:	fe043783          	ld	a5,-32(s0)
    80001714:	0007c783          	lbu	a5,0(a5)
    80001718:	2781                	sext.w	a5,a5
    8000171a:	40f707bb          	subw	a5,a4,a5
    8000171e:	2781                	sext.w	a5,a5
}
    80001720:	853e                	mv	a0,a5
    80001722:	70a2                	ld	ra,40(sp)
    80001724:	7402                	ld	s0,32(sp)
    80001726:	6145                	addi	sp,sp,48
    80001728:	8082                	ret

000000008000172a <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000172a:	7139                	addi	sp,sp,-64
    8000172c:	fc06                	sd	ra,56(sp)
    8000172e:	f822                	sd	s0,48(sp)
    80001730:	0080                	addi	s0,sp,64
    80001732:	fca43c23          	sd	a0,-40(s0)
    80001736:	fcb43823          	sd	a1,-48(s0)
    8000173a:	87b2                	mv	a5,a2
    8000173c:	fcf42623          	sw	a5,-52(s0)
  char *os;

  os = s;
    80001740:	fd843783          	ld	a5,-40(s0)
    80001744:	fef43423          	sd	a5,-24(s0)
  while(n-- > 0 && (*s++ = *t++) != 0)
    80001748:	0001                	nop
    8000174a:	fcc42783          	lw	a5,-52(s0)
    8000174e:	fff7871b          	addiw	a4,a5,-1
    80001752:	fce42623          	sw	a4,-52(s0)
    80001756:	02f05e63          	blez	a5,80001792 <strncpy+0x68>
    8000175a:	fd043703          	ld	a4,-48(s0)
    8000175e:	00170793          	addi	a5,a4,1
    80001762:	fcf43823          	sd	a5,-48(s0)
    80001766:	fd843783          	ld	a5,-40(s0)
    8000176a:	00178693          	addi	a3,a5,1
    8000176e:	fcd43c23          	sd	a3,-40(s0)
    80001772:	00074703          	lbu	a4,0(a4)
    80001776:	00e78023          	sb	a4,0(a5)
    8000177a:	0007c783          	lbu	a5,0(a5)
    8000177e:	f7f1                	bnez	a5,8000174a <strncpy+0x20>
    ;
  while(n-- > 0)
    80001780:	a809                	j	80001792 <strncpy+0x68>
    *s++ = 0;
    80001782:	fd843783          	ld	a5,-40(s0)
    80001786:	00178713          	addi	a4,a5,1
    8000178a:	fce43c23          	sd	a4,-40(s0)
    8000178e:	00078023          	sb	zero,0(a5)
  while(n-- > 0)
    80001792:	fcc42783          	lw	a5,-52(s0)
    80001796:	fff7871b          	addiw	a4,a5,-1
    8000179a:	fce42623          	sw	a4,-52(s0)
    8000179e:	fef042e3          	bgtz	a5,80001782 <strncpy+0x58>
  return os;
    800017a2:	fe843783          	ld	a5,-24(s0)
}
    800017a6:	853e                	mv	a0,a5
    800017a8:	70e2                	ld	ra,56(sp)
    800017aa:	7442                	ld	s0,48(sp)
    800017ac:	6121                	addi	sp,sp,64
    800017ae:	8082                	ret

00000000800017b0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800017b0:	7139                	addi	sp,sp,-64
    800017b2:	fc06                	sd	ra,56(sp)
    800017b4:	f822                	sd	s0,48(sp)
    800017b6:	0080                	addi	s0,sp,64
    800017b8:	fca43c23          	sd	a0,-40(s0)
    800017bc:	fcb43823          	sd	a1,-48(s0)
    800017c0:	87b2                	mv	a5,a2
    800017c2:	fcf42623          	sw	a5,-52(s0)
  char *os;

  os = s;
    800017c6:	fd843783          	ld	a5,-40(s0)
    800017ca:	fef43423          	sd	a5,-24(s0)
  if(n <= 0)
    800017ce:	fcc42783          	lw	a5,-52(s0)
    800017d2:	2781                	sext.w	a5,a5
    800017d4:	00f04563          	bgtz	a5,800017de <safestrcpy+0x2e>
    return os;
    800017d8:	fe843783          	ld	a5,-24(s0)
    800017dc:	a0a9                	j	80001826 <safestrcpy+0x76>
  while(--n > 0 && (*s++ = *t++) != 0)
    800017de:	0001                	nop
    800017e0:	fcc42783          	lw	a5,-52(s0)
    800017e4:	37fd                	addiw	a5,a5,-1
    800017e6:	fcf42623          	sw	a5,-52(s0)
    800017ea:	fcc42783          	lw	a5,-52(s0)
    800017ee:	2781                	sext.w	a5,a5
    800017f0:	02f05563          	blez	a5,8000181a <safestrcpy+0x6a>
    800017f4:	fd043703          	ld	a4,-48(s0)
    800017f8:	00170793          	addi	a5,a4,1
    800017fc:	fcf43823          	sd	a5,-48(s0)
    80001800:	fd843783          	ld	a5,-40(s0)
    80001804:	00178693          	addi	a3,a5,1
    80001808:	fcd43c23          	sd	a3,-40(s0)
    8000180c:	00074703          	lbu	a4,0(a4)
    80001810:	00e78023          	sb	a4,0(a5)
    80001814:	0007c783          	lbu	a5,0(a5)
    80001818:	f7e1                	bnez	a5,800017e0 <safestrcpy+0x30>
    ;
  *s = 0;
    8000181a:	fd843783          	ld	a5,-40(s0)
    8000181e:	00078023          	sb	zero,0(a5)
  return os;
    80001822:	fe843783          	ld	a5,-24(s0)
}
    80001826:	853e                	mv	a0,a5
    80001828:	70e2                	ld	ra,56(sp)
    8000182a:	7442                	ld	s0,48(sp)
    8000182c:	6121                	addi	sp,sp,64
    8000182e:	8082                	ret

0000000080001830 <strlen>:

int
strlen(const char *s)
{
    80001830:	7179                	addi	sp,sp,-48
    80001832:	f406                	sd	ra,40(sp)
    80001834:	f022                	sd	s0,32(sp)
    80001836:	1800                	addi	s0,sp,48
    80001838:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
    8000183c:	fe042623          	sw	zero,-20(s0)
    80001840:	a031                	j	8000184c <strlen+0x1c>
    80001842:	fec42783          	lw	a5,-20(s0)
    80001846:	2785                	addiw	a5,a5,1
    80001848:	fef42623          	sw	a5,-20(s0)
    8000184c:	fec42783          	lw	a5,-20(s0)
    80001850:	fd843703          	ld	a4,-40(s0)
    80001854:	97ba                	add	a5,a5,a4
    80001856:	0007c783          	lbu	a5,0(a5)
    8000185a:	f7e5                	bnez	a5,80001842 <strlen+0x12>
    ;
  return n;
    8000185c:	fec42783          	lw	a5,-20(s0)
}
    80001860:	853e                	mv	a0,a5
    80001862:	70a2                	ld	ra,40(sp)
    80001864:	7402                	ld	s0,32(sp)
    80001866:	6145                	addi	sp,sp,48
    80001868:	8082                	ret

000000008000186a <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000186a:	1141                	addi	sp,sp,-16
    8000186c:	e406                	sd	ra,8(sp)
    8000186e:	e022                	sd	s0,0(sp)
    80001870:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80001872:	00001097          	auipc	ra,0x1
    80001876:	fec080e7          	jalr	-20(ra) # 8000285e <cpuid>
    8000187a:	87aa                	mv	a5,a0
    8000187c:	efd5                	bnez	a5,80001938 <main+0xce>
    consoleinit();
    8000187e:	fffff097          	auipc	ra,0xfffff
    80001882:	020080e7          	jalr	32(ra) # 8000089e <consoleinit>
    printfinit();
    80001886:	fffff097          	auipc	ra,0xfffff
    8000188a:	48e080e7          	jalr	1166(ra) # 80000d14 <printfinit>
    printf("\n");
    8000188e:	00009517          	auipc	a0,0x9
    80001892:	7f250513          	addi	a0,a0,2034 # 8000b080 <etext+0x80>
    80001896:	fffff097          	auipc	ra,0xfffff
    8000189a:	1d4080e7          	jalr	468(ra) # 80000a6a <printf>
    printf("xv6 kernel is booting\n");
    8000189e:	00009517          	auipc	a0,0x9
    800018a2:	7ea50513          	addi	a0,a0,2026 # 8000b088 <etext+0x88>
    800018a6:	fffff097          	auipc	ra,0xfffff
    800018aa:	1c4080e7          	jalr	452(ra) # 80000a6a <printf>
    printf("\n");
    800018ae:	00009517          	auipc	a0,0x9
    800018b2:	7d250513          	addi	a0,a0,2002 # 8000b080 <etext+0x80>
    800018b6:	fffff097          	auipc	ra,0xfffff
    800018ba:	1b4080e7          	jalr	436(ra) # 80000a6a <printf>
    kinit();         // physical page allocator
    800018be:	fffff097          	auipc	ra,0xfffff
    800018c2:	76a080e7          	jalr	1898(ra) # 80001028 <kinit>
    kvminit();       // create kernel page table
    800018c6:	00000097          	auipc	ra,0x0
    800018ca:	1fc080e7          	jalr	508(ra) # 80001ac2 <kvminit>
    kvminithart();   // turn on paging
    800018ce:	00000097          	auipc	ra,0x0
    800018d2:	21a080e7          	jalr	538(ra) # 80001ae8 <kvminithart>
    procinit();      // process table
    800018d6:	00001097          	auipc	ra,0x1
    800018da:	eba080e7          	jalr	-326(ra) # 80002790 <procinit>
    trapinit();      // trap vectors
    800018de:	00002097          	auipc	ra,0x2
    800018e2:	22a080e7          	jalr	554(ra) # 80003b08 <trapinit>
    trapinithart();  // install kernel trap vector
    800018e6:	00002097          	auipc	ra,0x2
    800018ea:	24c080e7          	jalr	588(ra) # 80003b32 <trapinithart>
    plicinit();      // set up interrupt controller
    800018ee:	00007097          	auipc	ra,0x7
    800018f2:	fcc080e7          	jalr	-52(ra) # 800088ba <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800018f6:	00007097          	auipc	ra,0x7
    800018fa:	fec080e7          	jalr	-20(ra) # 800088e2 <plicinithart>
    binit();         // buffer cache
    800018fe:	00003097          	auipc	ra,0x3
    80001902:	c20080e7          	jalr	-992(ra) # 8000451e <binit>
    iinit();         // inode table
    80001906:	00003097          	auipc	ra,0x3
    8000190a:	44e080e7          	jalr	1102(ra) # 80004d54 <iinit>
    fileinit();      // file table
    8000190e:	00005097          	auipc	ra,0x5
    80001912:	df8080e7          	jalr	-520(ra) # 80006706 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80001916:	00007097          	auipc	ra,0x7
    8000191a:	0a0080e7          	jalr	160(ra) # 800089b6 <virtio_disk_init>
    userinit();      // first user process
    8000191e:	00001097          	auipc	ra,0x1
    80001922:	31e080e7          	jalr	798(ra) # 80002c3c <userinit>
    __sync_synchronize();
    80001926:	0330000f          	fence	rw,rw
    started = 1;
    8000192a:	00012797          	auipc	a5,0x12
    8000192e:	22678793          	addi	a5,a5,550 # 80013b50 <started>
    80001932:	4705                	li	a4,1
    80001934:	c398                	sw	a4,0(a5)
    80001936:	a0a9                	j	80001980 <main+0x116>
  } else {
    while(started == 0)
    80001938:	0001                	nop
    8000193a:	00012797          	auipc	a5,0x12
    8000193e:	21678793          	addi	a5,a5,534 # 80013b50 <started>
    80001942:	439c                	lw	a5,0(a5)
    80001944:	2781                	sext.w	a5,a5
    80001946:	dbf5                	beqz	a5,8000193a <main+0xd0>
      ;
    __sync_synchronize();
    80001948:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    8000194c:	00001097          	auipc	ra,0x1
    80001950:	f12080e7          	jalr	-238(ra) # 8000285e <cpuid>
    80001954:	87aa                	mv	a5,a0
    80001956:	85be                	mv	a1,a5
    80001958:	00009517          	auipc	a0,0x9
    8000195c:	74850513          	addi	a0,a0,1864 # 8000b0a0 <etext+0xa0>
    80001960:	fffff097          	auipc	ra,0xfffff
    80001964:	10a080e7          	jalr	266(ra) # 80000a6a <printf>
    kvminithart();    // turn on paging
    80001968:	00000097          	auipc	ra,0x0
    8000196c:	180080e7          	jalr	384(ra) # 80001ae8 <kvminithart>
    trapinithart();   // install kernel trap vector
    80001970:	00002097          	auipc	ra,0x2
    80001974:	1c2080e7          	jalr	450(ra) # 80003b32 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80001978:	00007097          	auipc	ra,0x7
    8000197c:	f6a080e7          	jalr	-150(ra) # 800088e2 <plicinithart>
  }

  scheduler();        
    80001980:	00002097          	auipc	ra,0x2
    80001984:	8d0080e7          	jalr	-1840(ra) # 80003250 <scheduler>

0000000080001988 <w_satp>:
{
    80001988:	1101                	addi	sp,sp,-32
    8000198a:	ec06                	sd	ra,24(sp)
    8000198c:	e822                	sd	s0,16(sp)
    8000198e:	1000                	addi	s0,sp,32
    80001990:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw satp, %0" : : "r" (x));
    80001994:	fe843783          	ld	a5,-24(s0)
    80001998:	18079073          	csrw	satp,a5
}
    8000199c:	0001                	nop
    8000199e:	60e2                	ld	ra,24(sp)
    800019a0:	6442                	ld	s0,16(sp)
    800019a2:	6105                	addi	sp,sp,32
    800019a4:	8082                	ret

00000000800019a6 <sfence_vma>:
}

// flush the TLB.
static inline void
sfence_vma()
{
    800019a6:	1141                	addi	sp,sp,-16
    800019a8:	e406                	sd	ra,8(sp)
    800019aa:	e022                	sd	s0,0(sp)
    800019ac:	0800                	addi	s0,sp,16
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800019ae:	12000073          	sfence.vma
}
    800019b2:	0001                	nop
    800019b4:	60a2                	ld	ra,8(sp)
    800019b6:	6402                	ld	s0,0(sp)
    800019b8:	0141                	addi	sp,sp,16
    800019ba:	8082                	ret

00000000800019bc <kvmmake>:
extern char trampoline[]; // trampoline.S

// Make a direct-map page table for the kernel.
pagetable_t
kvmmake(void)
{
    800019bc:	1101                	addi	sp,sp,-32
    800019be:	ec06                	sd	ra,24(sp)
    800019c0:	e822                	sd	s0,16(sp)
    800019c2:	1000                	addi	s0,sp,32
  pagetable_t kpgtbl;

  kpgtbl = (pagetable_t) kalloc();
    800019c4:	fffff097          	auipc	ra,0xfffff
    800019c8:	7a0080e7          	jalr	1952(ra) # 80001164 <kalloc>
    800019cc:	fea43423          	sd	a0,-24(s0)
  memset(kpgtbl, 0, PGSIZE);
    800019d0:	6605                	lui	a2,0x1
    800019d2:	4581                	li	a1,0
    800019d4:	fe843503          	ld	a0,-24(s0)
    800019d8:	00000097          	auipc	ra,0x0
    800019dc:	ac0080e7          	jalr	-1344(ra) # 80001498 <memset>

  // uart registers
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800019e0:	4719                	li	a4,6
    800019e2:	6685                	lui	a3,0x1
    800019e4:	10000637          	lui	a2,0x10000
    800019e8:	100005b7          	lui	a1,0x10000
    800019ec:	fe843503          	ld	a0,-24(s0)
    800019f0:	00000097          	auipc	ra,0x0
    800019f4:	2a2080e7          	jalr	674(ra) # 80001c92 <kvmmap>

  // virtio mmio disk interface
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800019f8:	4719                	li	a4,6
    800019fa:	6685                	lui	a3,0x1
    800019fc:	10001637          	lui	a2,0x10001
    80001a00:	100015b7          	lui	a1,0x10001
    80001a04:	fe843503          	ld	a0,-24(s0)
    80001a08:	00000097          	auipc	ra,0x0
    80001a0c:	28a080e7          	jalr	650(ra) # 80001c92 <kvmmap>

  // PLIC
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001a10:	4719                	li	a4,6
    80001a12:	004006b7          	lui	a3,0x400
    80001a16:	0c000637          	lui	a2,0xc000
    80001a1a:	0c0005b7          	lui	a1,0xc000
    80001a1e:	fe843503          	ld	a0,-24(s0)
    80001a22:	00000097          	auipc	ra,0x0
    80001a26:	270080e7          	jalr	624(ra) # 80001c92 <kvmmap>

  // map kernel text executable and read-only.
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001a2a:	00009717          	auipc	a4,0x9
    80001a2e:	5d670713          	addi	a4,a4,1494 # 8000b000 <etext>
    80001a32:	800007b7          	lui	a5,0x80000
    80001a36:	97ba                	add	a5,a5,a4
    80001a38:	4729                	li	a4,10
    80001a3a:	86be                	mv	a3,a5
    80001a3c:	4785                	li	a5,1
    80001a3e:	01f79613          	slli	a2,a5,0x1f
    80001a42:	4785                	li	a5,1
    80001a44:	01f79593          	slli	a1,a5,0x1f
    80001a48:	fe843503          	ld	a0,-24(s0)
    80001a4c:	00000097          	auipc	ra,0x0
    80001a50:	246080e7          	jalr	582(ra) # 80001c92 <kvmmap>

  // map kernel data and the physical RAM we'll make use of.
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001a54:	00009597          	auipc	a1,0x9
    80001a58:	5ac58593          	addi	a1,a1,1452 # 8000b000 <etext>
    80001a5c:	00009617          	auipc	a2,0x9
    80001a60:	5a460613          	addi	a2,a2,1444 # 8000b000 <etext>
    80001a64:	00009797          	auipc	a5,0x9
    80001a68:	59c78793          	addi	a5,a5,1436 # 8000b000 <etext>
    80001a6c:	4745                	li	a4,17
    80001a6e:	076e                	slli	a4,a4,0x1b
    80001a70:	40f707b3          	sub	a5,a4,a5
    80001a74:	4719                	li	a4,6
    80001a76:	86be                	mv	a3,a5
    80001a78:	fe843503          	ld	a0,-24(s0)
    80001a7c:	00000097          	auipc	ra,0x0
    80001a80:	216080e7          	jalr	534(ra) # 80001c92 <kvmmap>

  // map the trampoline for trap entry/exit to
  // the highest virtual address in the kernel.
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001a84:	00008797          	auipc	a5,0x8
    80001a88:	57c78793          	addi	a5,a5,1404 # 8000a000 <_trampoline>
    80001a8c:	4729                	li	a4,10
    80001a8e:	6685                	lui	a3,0x1
    80001a90:	863e                	mv	a2,a5
    80001a92:	040007b7          	lui	a5,0x4000
    80001a96:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001a98:	00c79593          	slli	a1,a5,0xc
    80001a9c:	fe843503          	ld	a0,-24(s0)
    80001aa0:	00000097          	auipc	ra,0x0
    80001aa4:	1f2080e7          	jalr	498(ra) # 80001c92 <kvmmap>

  // allocate and map a kernel stack for each process.
  proc_mapstacks(kpgtbl);
    80001aa8:	fe843503          	ld	a0,-24(s0)
    80001aac:	00001097          	auipc	ra,0x1
    80001ab0:	c28080e7          	jalr	-984(ra) # 800026d4 <proc_mapstacks>
  
  return kpgtbl;
    80001ab4:	fe843783          	ld	a5,-24(s0)
}
    80001ab8:	853e                	mv	a0,a5
    80001aba:	60e2                	ld	ra,24(sp)
    80001abc:	6442                	ld	s0,16(sp)
    80001abe:	6105                	addi	sp,sp,32
    80001ac0:	8082                	ret

0000000080001ac2 <kvminit>:

// Initialize the one kernel_pagetable
void
kvminit(void)
{
    80001ac2:	1141                	addi	sp,sp,-16
    80001ac4:	e406                	sd	ra,8(sp)
    80001ac6:	e022                	sd	s0,0(sp)
    80001ac8:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80001aca:	00000097          	auipc	ra,0x0
    80001ace:	ef2080e7          	jalr	-270(ra) # 800019bc <kvmmake>
    80001ad2:	872a                	mv	a4,a0
    80001ad4:	0000a797          	auipc	a5,0xa
    80001ad8:	e0478793          	addi	a5,a5,-508 # 8000b8d8 <kernel_pagetable>
    80001adc:	e398                	sd	a4,0(a5)
}
    80001ade:	0001                	nop
    80001ae0:	60a2                	ld	ra,8(sp)
    80001ae2:	6402                	ld	s0,0(sp)
    80001ae4:	0141                	addi	sp,sp,16
    80001ae6:	8082                	ret

0000000080001ae8 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80001ae8:	1141                	addi	sp,sp,-16
    80001aea:	e406                	sd	ra,8(sp)
    80001aec:	e022                	sd	s0,0(sp)
    80001aee:	0800                	addi	s0,sp,16
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();
    80001af0:	00000097          	auipc	ra,0x0
    80001af4:	eb6080e7          	jalr	-330(ra) # 800019a6 <sfence_vma>

  w_satp(MAKE_SATP(kernel_pagetable));
    80001af8:	0000a797          	auipc	a5,0xa
    80001afc:	de078793          	addi	a5,a5,-544 # 8000b8d8 <kernel_pagetable>
    80001b00:	639c                	ld	a5,0(a5)
    80001b02:	00c7d713          	srli	a4,a5,0xc
    80001b06:	57fd                	li	a5,-1
    80001b08:	17fe                	slli	a5,a5,0x3f
    80001b0a:	8fd9                	or	a5,a5,a4
    80001b0c:	853e                	mv	a0,a5
    80001b0e:	00000097          	auipc	ra,0x0
    80001b12:	e7a080e7          	jalr	-390(ra) # 80001988 <w_satp>

  // flush stale entries from the TLB.
  sfence_vma();
    80001b16:	00000097          	auipc	ra,0x0
    80001b1a:	e90080e7          	jalr	-368(ra) # 800019a6 <sfence_vma>
}
    80001b1e:	0001                	nop
    80001b20:	60a2                	ld	ra,8(sp)
    80001b22:	6402                	ld	s0,0(sp)
    80001b24:	0141                	addi	sp,sp,16
    80001b26:	8082                	ret

0000000080001b28 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80001b28:	7139                	addi	sp,sp,-64
    80001b2a:	fc06                	sd	ra,56(sp)
    80001b2c:	f822                	sd	s0,48(sp)
    80001b2e:	0080                	addi	s0,sp,64
    80001b30:	fca43c23          	sd	a0,-40(s0)
    80001b34:	fcb43823          	sd	a1,-48(s0)
    80001b38:	87b2                	mv	a5,a2
    80001b3a:	fcf42623          	sw	a5,-52(s0)
  if(va >= MAXVA)
    80001b3e:	fd043703          	ld	a4,-48(s0)
    80001b42:	57fd                	li	a5,-1
    80001b44:	83e9                	srli	a5,a5,0x1a
    80001b46:	00e7fa63          	bgeu	a5,a4,80001b5a <walk+0x32>
    panic("walk");
    80001b4a:	00009517          	auipc	a0,0x9
    80001b4e:	56e50513          	addi	a0,a0,1390 # 8000b0b8 <etext+0xb8>
    80001b52:	fffff097          	auipc	ra,0xfffff
    80001b56:	16e080e7          	jalr	366(ra) # 80000cc0 <panic>

  for(int level = 2; level > 0; level--) {
    80001b5a:	4789                	li	a5,2
    80001b5c:	fef42623          	sw	a5,-20(s0)
    80001b60:	a851                	j	80001bf4 <walk+0xcc>
    pte_t *pte = &pagetable[PX(level, va)];
    80001b62:	fec42783          	lw	a5,-20(s0)
    80001b66:	873e                	mv	a4,a5
    80001b68:	87ba                	mv	a5,a4
    80001b6a:	0037979b          	slliw	a5,a5,0x3
    80001b6e:	9fb9                	addw	a5,a5,a4
    80001b70:	2781                	sext.w	a5,a5
    80001b72:	27b1                	addiw	a5,a5,12
    80001b74:	2781                	sext.w	a5,a5
    80001b76:	873e                	mv	a4,a5
    80001b78:	fd043783          	ld	a5,-48(s0)
    80001b7c:	00e7d7b3          	srl	a5,a5,a4
    80001b80:	1ff7f793          	andi	a5,a5,511
    80001b84:	078e                	slli	a5,a5,0x3
    80001b86:	fd843703          	ld	a4,-40(s0)
    80001b8a:	97ba                	add	a5,a5,a4
    80001b8c:	fef43023          	sd	a5,-32(s0)
    if(*pte & PTE_V) {
    80001b90:	fe043783          	ld	a5,-32(s0)
    80001b94:	639c                	ld	a5,0(a5)
    80001b96:	8b85                	andi	a5,a5,1
    80001b98:	cb89                	beqz	a5,80001baa <walk+0x82>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001b9a:	fe043783          	ld	a5,-32(s0)
    80001b9e:	639c                	ld	a5,0(a5)
    80001ba0:	83a9                	srli	a5,a5,0xa
    80001ba2:	07b2                	slli	a5,a5,0xc
    80001ba4:	fcf43c23          	sd	a5,-40(s0)
    80001ba8:	a089                	j	80001bea <walk+0xc2>
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80001baa:	fcc42783          	lw	a5,-52(s0)
    80001bae:	2781                	sext.w	a5,a5
    80001bb0:	cb91                	beqz	a5,80001bc4 <walk+0x9c>
    80001bb2:	fffff097          	auipc	ra,0xfffff
    80001bb6:	5b2080e7          	jalr	1458(ra) # 80001164 <kalloc>
    80001bba:	fca43c23          	sd	a0,-40(s0)
    80001bbe:	fd843783          	ld	a5,-40(s0)
    80001bc2:	e399                	bnez	a5,80001bc8 <walk+0xa0>
        return 0;
    80001bc4:	4781                	li	a5,0
    80001bc6:	a0a9                	j	80001c10 <walk+0xe8>
      memset(pagetable, 0, PGSIZE);
    80001bc8:	6605                	lui	a2,0x1
    80001bca:	4581                	li	a1,0
    80001bcc:	fd843503          	ld	a0,-40(s0)
    80001bd0:	00000097          	auipc	ra,0x0
    80001bd4:	8c8080e7          	jalr	-1848(ra) # 80001498 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001bd8:	fd843783          	ld	a5,-40(s0)
    80001bdc:	83b1                	srli	a5,a5,0xc
    80001bde:	07aa                	slli	a5,a5,0xa
    80001be0:	0017e713          	ori	a4,a5,1
    80001be4:	fe043783          	ld	a5,-32(s0)
    80001be8:	e398                	sd	a4,0(a5)
  for(int level = 2; level > 0; level--) {
    80001bea:	fec42783          	lw	a5,-20(s0)
    80001bee:	37fd                	addiw	a5,a5,-1
    80001bf0:	fef42623          	sw	a5,-20(s0)
    80001bf4:	fec42783          	lw	a5,-20(s0)
    80001bf8:	2781                	sext.w	a5,a5
    80001bfa:	f6f044e3          	bgtz	a5,80001b62 <walk+0x3a>
    }
  }
  return &pagetable[PX(0, va)];
    80001bfe:	fd043783          	ld	a5,-48(s0)
    80001c02:	83b1                	srli	a5,a5,0xc
    80001c04:	1ff7f793          	andi	a5,a5,511
    80001c08:	078e                	slli	a5,a5,0x3
    80001c0a:	fd843703          	ld	a4,-40(s0)
    80001c0e:	97ba                	add	a5,a5,a4
}
    80001c10:	853e                	mv	a0,a5
    80001c12:	70e2                	ld	ra,56(sp)
    80001c14:	7442                	ld	s0,48(sp)
    80001c16:	6121                	addi	sp,sp,64
    80001c18:	8082                	ret

0000000080001c1a <walkaddr>:
// Look up a virtual address, return the physical address,
// or 0 if not mapped.
// Can only be used to look up user pages.
uint64
walkaddr(pagetable_t pagetable, uint64 va)
{
    80001c1a:	7179                	addi	sp,sp,-48
    80001c1c:	f406                	sd	ra,40(sp)
    80001c1e:	f022                	sd	s0,32(sp)
    80001c20:	1800                	addi	s0,sp,48
    80001c22:	fca43c23          	sd	a0,-40(s0)
    80001c26:	fcb43823          	sd	a1,-48(s0)
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80001c2a:	fd043703          	ld	a4,-48(s0)
    80001c2e:	57fd                	li	a5,-1
    80001c30:	83e9                	srli	a5,a5,0x1a
    80001c32:	00e7f463          	bgeu	a5,a4,80001c3a <walkaddr+0x20>
    return 0;
    80001c36:	4781                	li	a5,0
    80001c38:	a881                	j	80001c88 <walkaddr+0x6e>

  pte = walk(pagetable, va, 0);
    80001c3a:	4601                	li	a2,0
    80001c3c:	fd043583          	ld	a1,-48(s0)
    80001c40:	fd843503          	ld	a0,-40(s0)
    80001c44:	00000097          	auipc	ra,0x0
    80001c48:	ee4080e7          	jalr	-284(ra) # 80001b28 <walk>
    80001c4c:	fea43423          	sd	a0,-24(s0)
  if(pte == 0)
    80001c50:	fe843783          	ld	a5,-24(s0)
    80001c54:	e399                	bnez	a5,80001c5a <walkaddr+0x40>
    return 0;
    80001c56:	4781                	li	a5,0
    80001c58:	a805                	j	80001c88 <walkaddr+0x6e>
  if((*pte & PTE_V) == 0)
    80001c5a:	fe843783          	ld	a5,-24(s0)
    80001c5e:	639c                	ld	a5,0(a5)
    80001c60:	8b85                	andi	a5,a5,1
    80001c62:	e399                	bnez	a5,80001c68 <walkaddr+0x4e>
    return 0;
    80001c64:	4781                	li	a5,0
    80001c66:	a00d                	j	80001c88 <walkaddr+0x6e>
  if((*pte & PTE_U) == 0)
    80001c68:	fe843783          	ld	a5,-24(s0)
    80001c6c:	639c                	ld	a5,0(a5)
    80001c6e:	8bc1                	andi	a5,a5,16
    80001c70:	e399                	bnez	a5,80001c76 <walkaddr+0x5c>
    return 0;
    80001c72:	4781                	li	a5,0
    80001c74:	a811                	j	80001c88 <walkaddr+0x6e>
  pa = PTE2PA(*pte);
    80001c76:	fe843783          	ld	a5,-24(s0)
    80001c7a:	639c                	ld	a5,0(a5)
    80001c7c:	83a9                	srli	a5,a5,0xa
    80001c7e:	07b2                	slli	a5,a5,0xc
    80001c80:	fef43023          	sd	a5,-32(s0)
  return pa;
    80001c84:	fe043783          	ld	a5,-32(s0)
}
    80001c88:	853e                	mv	a0,a5
    80001c8a:	70a2                	ld	ra,40(sp)
    80001c8c:	7402                	ld	s0,32(sp)
    80001c8e:	6145                	addi	sp,sp,48
    80001c90:	8082                	ret

0000000080001c92 <kvmmap>:
// add a mapping to the kernel page table.
// only used when booting.
// does not flush TLB or enable paging.
void
kvmmap(pagetable_t kpgtbl, uint64 va, uint64 pa, uint64 sz, int perm)
{
    80001c92:	7139                	addi	sp,sp,-64
    80001c94:	fc06                	sd	ra,56(sp)
    80001c96:	f822                	sd	s0,48(sp)
    80001c98:	0080                	addi	s0,sp,64
    80001c9a:	fea43423          	sd	a0,-24(s0)
    80001c9e:	feb43023          	sd	a1,-32(s0)
    80001ca2:	fcc43c23          	sd	a2,-40(s0)
    80001ca6:	fcd43823          	sd	a3,-48(s0)
    80001caa:	87ba                	mv	a5,a4
    80001cac:	fcf42623          	sw	a5,-52(s0)
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001cb0:	fcc42783          	lw	a5,-52(s0)
    80001cb4:	873e                	mv	a4,a5
    80001cb6:	fd843683          	ld	a3,-40(s0)
    80001cba:	fd043603          	ld	a2,-48(s0)
    80001cbe:	fe043583          	ld	a1,-32(s0)
    80001cc2:	fe843503          	ld	a0,-24(s0)
    80001cc6:	00000097          	auipc	ra,0x0
    80001cca:	026080e7          	jalr	38(ra) # 80001cec <mappages>
    80001cce:	87aa                	mv	a5,a0
    80001cd0:	cb89                	beqz	a5,80001ce2 <kvmmap+0x50>
    panic("kvmmap");
    80001cd2:	00009517          	auipc	a0,0x9
    80001cd6:	3ee50513          	addi	a0,a0,1006 # 8000b0c0 <etext+0xc0>
    80001cda:	fffff097          	auipc	ra,0xfffff
    80001cde:	fe6080e7          	jalr	-26(ra) # 80000cc0 <panic>
}
    80001ce2:	0001                	nop
    80001ce4:	70e2                	ld	ra,56(sp)
    80001ce6:	7442                	ld	s0,48(sp)
    80001ce8:	6121                	addi	sp,sp,64
    80001cea:	8082                	ret

0000000080001cec <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001cec:	711d                	addi	sp,sp,-96
    80001cee:	ec86                	sd	ra,88(sp)
    80001cf0:	e8a2                	sd	s0,80(sp)
    80001cf2:	1080                	addi	s0,sp,96
    80001cf4:	fca43423          	sd	a0,-56(s0)
    80001cf8:	fcb43023          	sd	a1,-64(s0)
    80001cfc:	fac43c23          	sd	a2,-72(s0)
    80001d00:	fad43823          	sd	a3,-80(s0)
    80001d04:	87ba                	mv	a5,a4
    80001d06:	faf42623          	sw	a5,-84(s0)
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80001d0a:	fb843783          	ld	a5,-72(s0)
    80001d0e:	eb89                	bnez	a5,80001d20 <mappages+0x34>
    panic("mappages: size");
    80001d10:	00009517          	auipc	a0,0x9
    80001d14:	3b850513          	addi	a0,a0,952 # 8000b0c8 <etext+0xc8>
    80001d18:	fffff097          	auipc	ra,0xfffff
    80001d1c:	fa8080e7          	jalr	-88(ra) # 80000cc0 <panic>
  
  a = PGROUNDDOWN(va);
    80001d20:	fc043703          	ld	a4,-64(s0)
    80001d24:	77fd                	lui	a5,0xfffff
    80001d26:	8ff9                	and	a5,a5,a4
    80001d28:	fef43423          	sd	a5,-24(s0)
  last = PGROUNDDOWN(va + size - 1);
    80001d2c:	fc043703          	ld	a4,-64(s0)
    80001d30:	fb843783          	ld	a5,-72(s0)
    80001d34:	97ba                	add	a5,a5,a4
    80001d36:	fff78713          	addi	a4,a5,-1 # ffffffffffffefff <end+0xffffffff7ffda297>
    80001d3a:	77fd                	lui	a5,0xfffff
    80001d3c:	8ff9                	and	a5,a5,a4
    80001d3e:	fef43023          	sd	a5,-32(s0)
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    80001d42:	4605                	li	a2,1
    80001d44:	fe843583          	ld	a1,-24(s0)
    80001d48:	fc843503          	ld	a0,-56(s0)
    80001d4c:	00000097          	auipc	ra,0x0
    80001d50:	ddc080e7          	jalr	-548(ra) # 80001b28 <walk>
    80001d54:	fca43c23          	sd	a0,-40(s0)
    80001d58:	fd843783          	ld	a5,-40(s0)
    80001d5c:	e399                	bnez	a5,80001d62 <mappages+0x76>
      return -1;
    80001d5e:	57fd                	li	a5,-1
    80001d60:	a085                	j	80001dc0 <mappages+0xd4>
    if(*pte & PTE_V)
    80001d62:	fd843783          	ld	a5,-40(s0)
    80001d66:	639c                	ld	a5,0(a5)
    80001d68:	8b85                	andi	a5,a5,1
    80001d6a:	cb89                	beqz	a5,80001d7c <mappages+0x90>
      panic("mappages: remap");
    80001d6c:	00009517          	auipc	a0,0x9
    80001d70:	36c50513          	addi	a0,a0,876 # 8000b0d8 <etext+0xd8>
    80001d74:	fffff097          	auipc	ra,0xfffff
    80001d78:	f4c080e7          	jalr	-180(ra) # 80000cc0 <panic>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001d7c:	fb043783          	ld	a5,-80(s0)
    80001d80:	83b1                	srli	a5,a5,0xc
    80001d82:	00a79713          	slli	a4,a5,0xa
    80001d86:	fac42783          	lw	a5,-84(s0)
    80001d8a:	8fd9                	or	a5,a5,a4
    80001d8c:	0017e713          	ori	a4,a5,1
    80001d90:	fd843783          	ld	a5,-40(s0)
    80001d94:	e398                	sd	a4,0(a5)
    if(a == last)
    80001d96:	fe843703          	ld	a4,-24(s0)
    80001d9a:	fe043783          	ld	a5,-32(s0)
    80001d9e:	00f70f63          	beq	a4,a5,80001dbc <mappages+0xd0>
      break;
    a += PGSIZE;
    80001da2:	fe843703          	ld	a4,-24(s0)
    80001da6:	6785                	lui	a5,0x1
    80001da8:	97ba                	add	a5,a5,a4
    80001daa:	fef43423          	sd	a5,-24(s0)
    pa += PGSIZE;
    80001dae:	fb043703          	ld	a4,-80(s0)
    80001db2:	6785                	lui	a5,0x1
    80001db4:	97ba                	add	a5,a5,a4
    80001db6:	faf43823          	sd	a5,-80(s0)
    if((pte = walk(pagetable, a, 1)) == 0)
    80001dba:	b761                	j	80001d42 <mappages+0x56>
      break;
    80001dbc:	0001                	nop
  }
  return 0;
    80001dbe:	4781                	li	a5,0
}
    80001dc0:	853e                	mv	a0,a5
    80001dc2:	60e6                	ld	ra,88(sp)
    80001dc4:	6446                	ld	s0,80(sp)
    80001dc6:	6125                	addi	sp,sp,96
    80001dc8:	8082                	ret

0000000080001dca <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001dca:	715d                	addi	sp,sp,-80
    80001dcc:	e486                	sd	ra,72(sp)
    80001dce:	e0a2                	sd	s0,64(sp)
    80001dd0:	0880                	addi	s0,sp,80
    80001dd2:	fca43423          	sd	a0,-56(s0)
    80001dd6:	fcb43023          	sd	a1,-64(s0)
    80001dda:	fac43c23          	sd	a2,-72(s0)
    80001dde:	87b6                	mv	a5,a3
    80001de0:	faf42a23          	sw	a5,-76(s0)
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001de4:	fc043703          	ld	a4,-64(s0)
    80001de8:	6785                	lui	a5,0x1
    80001dea:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001dec:	8ff9                	and	a5,a5,a4
    80001dee:	cb89                	beqz	a5,80001e00 <uvmunmap+0x36>
    panic("uvmunmap: not aligned");
    80001df0:	00009517          	auipc	a0,0x9
    80001df4:	2f850513          	addi	a0,a0,760 # 8000b0e8 <etext+0xe8>
    80001df8:	fffff097          	auipc	ra,0xfffff
    80001dfc:	ec8080e7          	jalr	-312(ra) # 80000cc0 <panic>

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001e00:	fc043783          	ld	a5,-64(s0)
    80001e04:	fef43423          	sd	a5,-24(s0)
    80001e08:	a045                	j	80001ea8 <uvmunmap+0xde>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001e0a:	4601                	li	a2,0
    80001e0c:	fe843583          	ld	a1,-24(s0)
    80001e10:	fc843503          	ld	a0,-56(s0)
    80001e14:	00000097          	auipc	ra,0x0
    80001e18:	d14080e7          	jalr	-748(ra) # 80001b28 <walk>
    80001e1c:	fea43023          	sd	a0,-32(s0)
    80001e20:	fe043783          	ld	a5,-32(s0)
    80001e24:	eb89                	bnez	a5,80001e36 <uvmunmap+0x6c>
      panic("uvmunmap: walk");
    80001e26:	00009517          	auipc	a0,0x9
    80001e2a:	2da50513          	addi	a0,a0,730 # 8000b100 <etext+0x100>
    80001e2e:	fffff097          	auipc	ra,0xfffff
    80001e32:	e92080e7          	jalr	-366(ra) # 80000cc0 <panic>
    if((*pte & PTE_V) == 0)
    80001e36:	fe043783          	ld	a5,-32(s0)
    80001e3a:	639c                	ld	a5,0(a5)
    80001e3c:	8b85                	andi	a5,a5,1
    80001e3e:	eb89                	bnez	a5,80001e50 <uvmunmap+0x86>
      panic("uvmunmap: not mapped");
    80001e40:	00009517          	auipc	a0,0x9
    80001e44:	2d050513          	addi	a0,a0,720 # 8000b110 <etext+0x110>
    80001e48:	fffff097          	auipc	ra,0xfffff
    80001e4c:	e78080e7          	jalr	-392(ra) # 80000cc0 <panic>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001e50:	fe043783          	ld	a5,-32(s0)
    80001e54:	639c                	ld	a5,0(a5)
    80001e56:	3ff7f713          	andi	a4,a5,1023
    80001e5a:	4785                	li	a5,1
    80001e5c:	00f71a63          	bne	a4,a5,80001e70 <uvmunmap+0xa6>
      panic("uvmunmap: not a leaf");
    80001e60:	00009517          	auipc	a0,0x9
    80001e64:	2c850513          	addi	a0,a0,712 # 8000b128 <etext+0x128>
    80001e68:	fffff097          	auipc	ra,0xfffff
    80001e6c:	e58080e7          	jalr	-424(ra) # 80000cc0 <panic>
    if(do_free){
    80001e70:	fb442783          	lw	a5,-76(s0)
    80001e74:	2781                	sext.w	a5,a5
    80001e76:	cf99                	beqz	a5,80001e94 <uvmunmap+0xca>
      uint64 pa = PTE2PA(*pte);
    80001e78:	fe043783          	ld	a5,-32(s0)
    80001e7c:	639c                	ld	a5,0(a5)
    80001e7e:	83a9                	srli	a5,a5,0xa
    80001e80:	07b2                	slli	a5,a5,0xc
    80001e82:	fcf43c23          	sd	a5,-40(s0)
      kfree((void*)pa);
    80001e86:	fd843783          	ld	a5,-40(s0)
    80001e8a:	853e                	mv	a0,a5
    80001e8c:	fffff097          	auipc	ra,0xfffff
    80001e90:	234080e7          	jalr	564(ra) # 800010c0 <kfree>
    }
    *pte = 0;
    80001e94:	fe043783          	ld	a5,-32(s0)
    80001e98:	0007b023          	sd	zero,0(a5)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001e9c:	fe843703          	ld	a4,-24(s0)
    80001ea0:	6785                	lui	a5,0x1
    80001ea2:	97ba                	add	a5,a5,a4
    80001ea4:	fef43423          	sd	a5,-24(s0)
    80001ea8:	fb843783          	ld	a5,-72(s0)
    80001eac:	00c79713          	slli	a4,a5,0xc
    80001eb0:	fc043783          	ld	a5,-64(s0)
    80001eb4:	97ba                	add	a5,a5,a4
    80001eb6:	fe843703          	ld	a4,-24(s0)
    80001eba:	f4f768e3          	bltu	a4,a5,80001e0a <uvmunmap+0x40>
  }
}
    80001ebe:	0001                	nop
    80001ec0:	0001                	nop
    80001ec2:	60a6                	ld	ra,72(sp)
    80001ec4:	6406                	ld	s0,64(sp)
    80001ec6:	6161                	addi	sp,sp,80
    80001ec8:	8082                	ret

0000000080001eca <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001eca:	1101                	addi	sp,sp,-32
    80001ecc:	ec06                	sd	ra,24(sp)
    80001ece:	e822                	sd	s0,16(sp)
    80001ed0:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001ed2:	fffff097          	auipc	ra,0xfffff
    80001ed6:	292080e7          	jalr	658(ra) # 80001164 <kalloc>
    80001eda:	fea43423          	sd	a0,-24(s0)
  if(pagetable == 0)
    80001ede:	fe843783          	ld	a5,-24(s0)
    80001ee2:	e399                	bnez	a5,80001ee8 <uvmcreate+0x1e>
    return 0;
    80001ee4:	4781                	li	a5,0
    80001ee6:	a819                	j	80001efc <uvmcreate+0x32>
  memset(pagetable, 0, PGSIZE);
    80001ee8:	6605                	lui	a2,0x1
    80001eea:	4581                	li	a1,0
    80001eec:	fe843503          	ld	a0,-24(s0)
    80001ef0:	fffff097          	auipc	ra,0xfffff
    80001ef4:	5a8080e7          	jalr	1448(ra) # 80001498 <memset>
  return pagetable;
    80001ef8:	fe843783          	ld	a5,-24(s0)
}
    80001efc:	853e                	mv	a0,a5
    80001efe:	60e2                	ld	ra,24(sp)
    80001f00:	6442                	ld	s0,16(sp)
    80001f02:	6105                	addi	sp,sp,32
    80001f04:	8082                	ret

0000000080001f06 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80001f06:	7139                	addi	sp,sp,-64
    80001f08:	fc06                	sd	ra,56(sp)
    80001f0a:	f822                	sd	s0,48(sp)
    80001f0c:	0080                	addi	s0,sp,64
    80001f0e:	fca43c23          	sd	a0,-40(s0)
    80001f12:	fcb43823          	sd	a1,-48(s0)
    80001f16:	87b2                	mv	a5,a2
    80001f18:	fcf42623          	sw	a5,-52(s0)
  char *mem;

  if(sz >= PGSIZE)
    80001f1c:	fcc42783          	lw	a5,-52(s0)
    80001f20:	0007871b          	sext.w	a4,a5
    80001f24:	6785                	lui	a5,0x1
    80001f26:	00f76a63          	bltu	a4,a5,80001f3a <uvmfirst+0x34>
    panic("uvmfirst: more than a page");
    80001f2a:	00009517          	auipc	a0,0x9
    80001f2e:	21650513          	addi	a0,a0,534 # 8000b140 <etext+0x140>
    80001f32:	fffff097          	auipc	ra,0xfffff
    80001f36:	d8e080e7          	jalr	-626(ra) # 80000cc0 <panic>
  mem = kalloc();
    80001f3a:	fffff097          	auipc	ra,0xfffff
    80001f3e:	22a080e7          	jalr	554(ra) # 80001164 <kalloc>
    80001f42:	fea43423          	sd	a0,-24(s0)
  memset(mem, 0, PGSIZE);
    80001f46:	6605                	lui	a2,0x1
    80001f48:	4581                	li	a1,0
    80001f4a:	fe843503          	ld	a0,-24(s0)
    80001f4e:	fffff097          	auipc	ra,0xfffff
    80001f52:	54a080e7          	jalr	1354(ra) # 80001498 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001f56:	fe843783          	ld	a5,-24(s0)
    80001f5a:	4779                	li	a4,30
    80001f5c:	86be                	mv	a3,a5
    80001f5e:	6605                	lui	a2,0x1
    80001f60:	4581                	li	a1,0
    80001f62:	fd843503          	ld	a0,-40(s0)
    80001f66:	00000097          	auipc	ra,0x0
    80001f6a:	d86080e7          	jalr	-634(ra) # 80001cec <mappages>
  memmove(mem, src, sz);
    80001f6e:	fcc42783          	lw	a5,-52(s0)
    80001f72:	863e                	mv	a2,a5
    80001f74:	fd043583          	ld	a1,-48(s0)
    80001f78:	fe843503          	ld	a0,-24(s0)
    80001f7c:	fffff097          	auipc	ra,0xfffff
    80001f80:	608080e7          	jalr	1544(ra) # 80001584 <memmove>
}
    80001f84:	0001                	nop
    80001f86:	70e2                	ld	ra,56(sp)
    80001f88:	7442                	ld	s0,48(sp)
    80001f8a:	6121                	addi	sp,sp,64
    80001f8c:	8082                	ret

0000000080001f8e <uvmalloc>:

// Allocate PTEs and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
uint64
uvmalloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz, int xperm)
{
    80001f8e:	7139                	addi	sp,sp,-64
    80001f90:	fc06                	sd	ra,56(sp)
    80001f92:	f822                	sd	s0,48(sp)
    80001f94:	0080                	addi	s0,sp,64
    80001f96:	fca43c23          	sd	a0,-40(s0)
    80001f9a:	fcb43823          	sd	a1,-48(s0)
    80001f9e:	fcc43423          	sd	a2,-56(s0)
    80001fa2:	87b6                	mv	a5,a3
    80001fa4:	fcf42223          	sw	a5,-60(s0)
  char *mem;
  uint64 a;

  if(newsz < oldsz)
    80001fa8:	fc843703          	ld	a4,-56(s0)
    80001fac:	fd043783          	ld	a5,-48(s0)
    80001fb0:	00f77563          	bgeu	a4,a5,80001fba <uvmalloc+0x2c>
    return oldsz;
    80001fb4:	fd043783          	ld	a5,-48(s0)
    80001fb8:	a87d                	j	80002076 <uvmalloc+0xe8>

  oldsz = PGROUNDUP(oldsz);
    80001fba:	fd043703          	ld	a4,-48(s0)
    80001fbe:	6785                	lui	a5,0x1
    80001fc0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001fc2:	973e                	add	a4,a4,a5
    80001fc4:	77fd                	lui	a5,0xfffff
    80001fc6:	8ff9                	and	a5,a5,a4
    80001fc8:	fcf43823          	sd	a5,-48(s0)
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001fcc:	fd043783          	ld	a5,-48(s0)
    80001fd0:	fef43423          	sd	a5,-24(s0)
    80001fd4:	a849                	j	80002066 <uvmalloc+0xd8>
    mem = kalloc();
    80001fd6:	fffff097          	auipc	ra,0xfffff
    80001fda:	18e080e7          	jalr	398(ra) # 80001164 <kalloc>
    80001fde:	fea43023          	sd	a0,-32(s0)
    if(mem == 0){
    80001fe2:	fe043783          	ld	a5,-32(s0)
    80001fe6:	ef89                	bnez	a5,80002000 <uvmalloc+0x72>
      uvmdealloc(pagetable, a, oldsz);
    80001fe8:	fd043603          	ld	a2,-48(s0)
    80001fec:	fe843583          	ld	a1,-24(s0)
    80001ff0:	fd843503          	ld	a0,-40(s0)
    80001ff4:	00000097          	auipc	ra,0x0
    80001ff8:	08c080e7          	jalr	140(ra) # 80002080 <uvmdealloc>
      return 0;
    80001ffc:	4781                	li	a5,0
    80001ffe:	a8a5                	j	80002076 <uvmalloc+0xe8>
    }
    memset(mem, 0, PGSIZE);
    80002000:	6605                	lui	a2,0x1
    80002002:	4581                	li	a1,0
    80002004:	fe043503          	ld	a0,-32(s0)
    80002008:	fffff097          	auipc	ra,0xfffff
    8000200c:	490080e7          	jalr	1168(ra) # 80001498 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80002010:	fe043783          	ld	a5,-32(s0)
    80002014:	fc442703          	lw	a4,-60(s0)
    80002018:	01276713          	ori	a4,a4,18
    8000201c:	2701                	sext.w	a4,a4
    8000201e:	86be                	mv	a3,a5
    80002020:	6605                	lui	a2,0x1
    80002022:	fe843583          	ld	a1,-24(s0)
    80002026:	fd843503          	ld	a0,-40(s0)
    8000202a:	00000097          	auipc	ra,0x0
    8000202e:	cc2080e7          	jalr	-830(ra) # 80001cec <mappages>
    80002032:	87aa                	mv	a5,a0
    80002034:	c39d                	beqz	a5,8000205a <uvmalloc+0xcc>
      kfree(mem);
    80002036:	fe043503          	ld	a0,-32(s0)
    8000203a:	fffff097          	auipc	ra,0xfffff
    8000203e:	086080e7          	jalr	134(ra) # 800010c0 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80002042:	fd043603          	ld	a2,-48(s0)
    80002046:	fe843583          	ld	a1,-24(s0)
    8000204a:	fd843503          	ld	a0,-40(s0)
    8000204e:	00000097          	auipc	ra,0x0
    80002052:	032080e7          	jalr	50(ra) # 80002080 <uvmdealloc>
      return 0;
    80002056:	4781                	li	a5,0
    80002058:	a839                	j	80002076 <uvmalloc+0xe8>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000205a:	fe843703          	ld	a4,-24(s0)
    8000205e:	6785                	lui	a5,0x1
    80002060:	97ba                	add	a5,a5,a4
    80002062:	fef43423          	sd	a5,-24(s0)
    80002066:	fe843703          	ld	a4,-24(s0)
    8000206a:	fc843783          	ld	a5,-56(s0)
    8000206e:	f6f764e3          	bltu	a4,a5,80001fd6 <uvmalloc+0x48>
    }
  }
  return newsz;
    80002072:	fc843783          	ld	a5,-56(s0)
}
    80002076:	853e                	mv	a0,a5
    80002078:	70e2                	ld	ra,56(sp)
    8000207a:	7442                	ld	s0,48(sp)
    8000207c:	6121                	addi	sp,sp,64
    8000207e:	8082                	ret

0000000080002080 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80002080:	7139                	addi	sp,sp,-64
    80002082:	fc06                	sd	ra,56(sp)
    80002084:	f822                	sd	s0,48(sp)
    80002086:	0080                	addi	s0,sp,64
    80002088:	fca43c23          	sd	a0,-40(s0)
    8000208c:	fcb43823          	sd	a1,-48(s0)
    80002090:	fcc43423          	sd	a2,-56(s0)
  if(newsz >= oldsz)
    80002094:	fc843703          	ld	a4,-56(s0)
    80002098:	fd043783          	ld	a5,-48(s0)
    8000209c:	00f76563          	bltu	a4,a5,800020a6 <uvmdealloc+0x26>
    return oldsz;
    800020a0:	fd043783          	ld	a5,-48(s0)
    800020a4:	a885                	j	80002114 <uvmdealloc+0x94>

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800020a6:	fc843703          	ld	a4,-56(s0)
    800020aa:	6785                	lui	a5,0x1
    800020ac:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800020ae:	973e                	add	a4,a4,a5
    800020b0:	77fd                	lui	a5,0xfffff
    800020b2:	8f7d                	and	a4,a4,a5
    800020b4:	fd043683          	ld	a3,-48(s0)
    800020b8:	6785                	lui	a5,0x1
    800020ba:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800020bc:	96be                	add	a3,a3,a5
    800020be:	77fd                	lui	a5,0xfffff
    800020c0:	8ff5                	and	a5,a5,a3
    800020c2:	04f77763          	bgeu	a4,a5,80002110 <uvmdealloc+0x90>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800020c6:	fd043703          	ld	a4,-48(s0)
    800020ca:	6785                	lui	a5,0x1
    800020cc:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800020ce:	973e                	add	a4,a4,a5
    800020d0:	77fd                	lui	a5,0xfffff
    800020d2:	8f7d                	and	a4,a4,a5
    800020d4:	fc843683          	ld	a3,-56(s0)
    800020d8:	6785                	lui	a5,0x1
    800020da:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800020dc:	96be                	add	a3,a3,a5
    800020de:	77fd                	lui	a5,0xfffff
    800020e0:	8ff5                	and	a5,a5,a3
    800020e2:	40f707b3          	sub	a5,a4,a5
    800020e6:	83b1                	srli	a5,a5,0xc
    800020e8:	fef42623          	sw	a5,-20(s0)
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800020ec:	fc843703          	ld	a4,-56(s0)
    800020f0:	6785                	lui	a5,0x1
    800020f2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800020f4:	973e                	add	a4,a4,a5
    800020f6:	77fd                	lui	a5,0xfffff
    800020f8:	8ff9                	and	a5,a5,a4
    800020fa:	fec42703          	lw	a4,-20(s0)
    800020fe:	4685                	li	a3,1
    80002100:	863a                	mv	a2,a4
    80002102:	85be                	mv	a1,a5
    80002104:	fd843503          	ld	a0,-40(s0)
    80002108:	00000097          	auipc	ra,0x0
    8000210c:	cc2080e7          	jalr	-830(ra) # 80001dca <uvmunmap>
  }

  return newsz;
    80002110:	fc843783          	ld	a5,-56(s0)
}
    80002114:	853e                	mv	a0,a5
    80002116:	70e2                	ld	ra,56(sp)
    80002118:	7442                	ld	s0,48(sp)
    8000211a:	6121                	addi	sp,sp,64
    8000211c:	8082                	ret

000000008000211e <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000211e:	7139                	addi	sp,sp,-64
    80002120:	fc06                	sd	ra,56(sp)
    80002122:	f822                	sd	s0,48(sp)
    80002124:	0080                	addi	s0,sp,64
    80002126:	fca43423          	sd	a0,-56(s0)
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000212a:	fe042623          	sw	zero,-20(s0)
    8000212e:	a88d                	j	800021a0 <freewalk+0x82>
    pte_t pte = pagetable[i];
    80002130:	fec42783          	lw	a5,-20(s0)
    80002134:	078e                	slli	a5,a5,0x3
    80002136:	fc843703          	ld	a4,-56(s0)
    8000213a:	97ba                	add	a5,a5,a4
    8000213c:	639c                	ld	a5,0(a5)
    8000213e:	fef43023          	sd	a5,-32(s0)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80002142:	fe043783          	ld	a5,-32(s0)
    80002146:	8b85                	andi	a5,a5,1
    80002148:	cb9d                	beqz	a5,8000217e <freewalk+0x60>
    8000214a:	fe043783          	ld	a5,-32(s0)
    8000214e:	8bb9                	andi	a5,a5,14
    80002150:	e79d                	bnez	a5,8000217e <freewalk+0x60>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80002152:	fe043783          	ld	a5,-32(s0)
    80002156:	83a9                	srli	a5,a5,0xa
    80002158:	07b2                	slli	a5,a5,0xc
    8000215a:	fcf43c23          	sd	a5,-40(s0)
      freewalk((pagetable_t)child);
    8000215e:	fd843783          	ld	a5,-40(s0)
    80002162:	853e                	mv	a0,a5
    80002164:	00000097          	auipc	ra,0x0
    80002168:	fba080e7          	jalr	-70(ra) # 8000211e <freewalk>
      pagetable[i] = 0;
    8000216c:	fec42783          	lw	a5,-20(s0)
    80002170:	078e                	slli	a5,a5,0x3
    80002172:	fc843703          	ld	a4,-56(s0)
    80002176:	97ba                	add	a5,a5,a4
    80002178:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0xffffffff7ffda298>
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000217c:	a829                	j	80002196 <freewalk+0x78>
    } else if(pte & PTE_V){
    8000217e:	fe043783          	ld	a5,-32(s0)
    80002182:	8b85                	andi	a5,a5,1
    80002184:	cb89                	beqz	a5,80002196 <freewalk+0x78>
      panic("freewalk: leaf");
    80002186:	00009517          	auipc	a0,0x9
    8000218a:	fda50513          	addi	a0,a0,-38 # 8000b160 <etext+0x160>
    8000218e:	fffff097          	auipc	ra,0xfffff
    80002192:	b32080e7          	jalr	-1230(ra) # 80000cc0 <panic>
  for(int i = 0; i < 512; i++){
    80002196:	fec42783          	lw	a5,-20(s0)
    8000219a:	2785                	addiw	a5,a5,1
    8000219c:	fef42623          	sw	a5,-20(s0)
    800021a0:	fec42783          	lw	a5,-20(s0)
    800021a4:	0007871b          	sext.w	a4,a5
    800021a8:	1ff00793          	li	a5,511
    800021ac:	f8e7d2e3          	bge	a5,a4,80002130 <freewalk+0x12>
    }
  }
  kfree((void*)pagetable);
    800021b0:	fc843503          	ld	a0,-56(s0)
    800021b4:	fffff097          	auipc	ra,0xfffff
    800021b8:	f0c080e7          	jalr	-244(ra) # 800010c0 <kfree>
}
    800021bc:	0001                	nop
    800021be:	70e2                	ld	ra,56(sp)
    800021c0:	7442                	ld	s0,48(sp)
    800021c2:	6121                	addi	sp,sp,64
    800021c4:	8082                	ret

00000000800021c6 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800021c6:	1101                	addi	sp,sp,-32
    800021c8:	ec06                	sd	ra,24(sp)
    800021ca:	e822                	sd	s0,16(sp)
    800021cc:	1000                	addi	s0,sp,32
    800021ce:	fea43423          	sd	a0,-24(s0)
    800021d2:	feb43023          	sd	a1,-32(s0)
  if(sz > 0)
    800021d6:	fe043783          	ld	a5,-32(s0)
    800021da:	c385                	beqz	a5,800021fa <uvmfree+0x34>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800021dc:	fe043703          	ld	a4,-32(s0)
    800021e0:	6785                	lui	a5,0x1
    800021e2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800021e4:	97ba                	add	a5,a5,a4
    800021e6:	83b1                	srli	a5,a5,0xc
    800021e8:	4685                	li	a3,1
    800021ea:	863e                	mv	a2,a5
    800021ec:	4581                	li	a1,0
    800021ee:	fe843503          	ld	a0,-24(s0)
    800021f2:	00000097          	auipc	ra,0x0
    800021f6:	bd8080e7          	jalr	-1064(ra) # 80001dca <uvmunmap>
  freewalk(pagetable);
    800021fa:	fe843503          	ld	a0,-24(s0)
    800021fe:	00000097          	auipc	ra,0x0
    80002202:	f20080e7          	jalr	-224(ra) # 8000211e <freewalk>
}
    80002206:	0001                	nop
    80002208:	60e2                	ld	ra,24(sp)
    8000220a:	6442                	ld	s0,16(sp)
    8000220c:	6105                	addi	sp,sp,32
    8000220e:	8082                	ret

0000000080002210 <uvmcopy>:
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int
uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
    80002210:	711d                	addi	sp,sp,-96
    80002212:	ec86                	sd	ra,88(sp)
    80002214:	e8a2                	sd	s0,80(sp)
    80002216:	1080                	addi	s0,sp,96
    80002218:	faa43c23          	sd	a0,-72(s0)
    8000221c:	fab43823          	sd	a1,-80(s0)
    80002220:	fac43423          	sd	a2,-88(s0)
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80002224:	fe043423          	sd	zero,-24(s0)
    80002228:	a0d9                	j	800022ee <uvmcopy+0xde>
    if((pte = walk(old, i, 0)) == 0)
    8000222a:	4601                	li	a2,0
    8000222c:	fe843583          	ld	a1,-24(s0)
    80002230:	fb843503          	ld	a0,-72(s0)
    80002234:	00000097          	auipc	ra,0x0
    80002238:	8f4080e7          	jalr	-1804(ra) # 80001b28 <walk>
    8000223c:	fea43023          	sd	a0,-32(s0)
    80002240:	fe043783          	ld	a5,-32(s0)
    80002244:	eb89                	bnez	a5,80002256 <uvmcopy+0x46>
      panic("uvmcopy: pte should exist");
    80002246:	00009517          	auipc	a0,0x9
    8000224a:	f2a50513          	addi	a0,a0,-214 # 8000b170 <etext+0x170>
    8000224e:	fffff097          	auipc	ra,0xfffff
    80002252:	a72080e7          	jalr	-1422(ra) # 80000cc0 <panic>
    if((*pte & PTE_V) == 0)
    80002256:	fe043783          	ld	a5,-32(s0)
    8000225a:	639c                	ld	a5,0(a5)
    8000225c:	8b85                	andi	a5,a5,1
    8000225e:	eb89                	bnez	a5,80002270 <uvmcopy+0x60>
      panic("uvmcopy: page not present");
    80002260:	00009517          	auipc	a0,0x9
    80002264:	f3050513          	addi	a0,a0,-208 # 8000b190 <etext+0x190>
    80002268:	fffff097          	auipc	ra,0xfffff
    8000226c:	a58080e7          	jalr	-1448(ra) # 80000cc0 <panic>
    pa = PTE2PA(*pte);
    80002270:	fe043783          	ld	a5,-32(s0)
    80002274:	639c                	ld	a5,0(a5)
    80002276:	83a9                	srli	a5,a5,0xa
    80002278:	07b2                	slli	a5,a5,0xc
    8000227a:	fcf43c23          	sd	a5,-40(s0)
    flags = PTE_FLAGS(*pte);
    8000227e:	fe043783          	ld	a5,-32(s0)
    80002282:	639c                	ld	a5,0(a5)
    80002284:	2781                	sext.w	a5,a5
    80002286:	3ff7f793          	andi	a5,a5,1023
    8000228a:	fcf42a23          	sw	a5,-44(s0)
    if((mem = kalloc()) == 0)
    8000228e:	fffff097          	auipc	ra,0xfffff
    80002292:	ed6080e7          	jalr	-298(ra) # 80001164 <kalloc>
    80002296:	fca43423          	sd	a0,-56(s0)
    8000229a:	fc843783          	ld	a5,-56(s0)
    8000229e:	c3a5                	beqz	a5,800022fe <uvmcopy+0xee>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800022a0:	fd843783          	ld	a5,-40(s0)
    800022a4:	6605                	lui	a2,0x1
    800022a6:	85be                	mv	a1,a5
    800022a8:	fc843503          	ld	a0,-56(s0)
    800022ac:	fffff097          	auipc	ra,0xfffff
    800022b0:	2d8080e7          	jalr	728(ra) # 80001584 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800022b4:	fc843783          	ld	a5,-56(s0)
    800022b8:	fd442703          	lw	a4,-44(s0)
    800022bc:	86be                	mv	a3,a5
    800022be:	6605                	lui	a2,0x1
    800022c0:	fe843583          	ld	a1,-24(s0)
    800022c4:	fb043503          	ld	a0,-80(s0)
    800022c8:	00000097          	auipc	ra,0x0
    800022cc:	a24080e7          	jalr	-1500(ra) # 80001cec <mappages>
    800022d0:	87aa                	mv	a5,a0
    800022d2:	cb81                	beqz	a5,800022e2 <uvmcopy+0xd2>
      kfree(mem);
    800022d4:	fc843503          	ld	a0,-56(s0)
    800022d8:	fffff097          	auipc	ra,0xfffff
    800022dc:	de8080e7          	jalr	-536(ra) # 800010c0 <kfree>
      goto err;
    800022e0:	a005                	j	80002300 <uvmcopy+0xf0>
  for(i = 0; i < sz; i += PGSIZE){
    800022e2:	fe843703          	ld	a4,-24(s0)
    800022e6:	6785                	lui	a5,0x1
    800022e8:	97ba                	add	a5,a5,a4
    800022ea:	fef43423          	sd	a5,-24(s0)
    800022ee:	fe843703          	ld	a4,-24(s0)
    800022f2:	fa843783          	ld	a5,-88(s0)
    800022f6:	f2f76ae3          	bltu	a4,a5,8000222a <uvmcopy+0x1a>
    }
  }
  return 0;
    800022fa:	4781                	li	a5,0
    800022fc:	a839                	j	8000231a <uvmcopy+0x10a>
      goto err;
    800022fe:	0001                	nop

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80002300:	fe843783          	ld	a5,-24(s0)
    80002304:	83b1                	srli	a5,a5,0xc
    80002306:	4685                	li	a3,1
    80002308:	863e                	mv	a2,a5
    8000230a:	4581                	li	a1,0
    8000230c:	fb043503          	ld	a0,-80(s0)
    80002310:	00000097          	auipc	ra,0x0
    80002314:	aba080e7          	jalr	-1350(ra) # 80001dca <uvmunmap>
  return -1;
    80002318:	57fd                	li	a5,-1
}
    8000231a:	853e                	mv	a0,a5
    8000231c:	60e6                	ld	ra,88(sp)
    8000231e:	6446                	ld	s0,80(sp)
    80002320:	6125                	addi	sp,sp,96
    80002322:	8082                	ret

0000000080002324 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80002324:	7179                	addi	sp,sp,-48
    80002326:	f406                	sd	ra,40(sp)
    80002328:	f022                	sd	s0,32(sp)
    8000232a:	1800                	addi	s0,sp,48
    8000232c:	fca43c23          	sd	a0,-40(s0)
    80002330:	fcb43823          	sd	a1,-48(s0)
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80002334:	4601                	li	a2,0
    80002336:	fd043583          	ld	a1,-48(s0)
    8000233a:	fd843503          	ld	a0,-40(s0)
    8000233e:	fffff097          	auipc	ra,0xfffff
    80002342:	7ea080e7          	jalr	2026(ra) # 80001b28 <walk>
    80002346:	fea43423          	sd	a0,-24(s0)
  if(pte == 0)
    8000234a:	fe843783          	ld	a5,-24(s0)
    8000234e:	eb89                	bnez	a5,80002360 <uvmclear+0x3c>
    panic("uvmclear");
    80002350:	00009517          	auipc	a0,0x9
    80002354:	e6050513          	addi	a0,a0,-416 # 8000b1b0 <etext+0x1b0>
    80002358:	fffff097          	auipc	ra,0xfffff
    8000235c:	968080e7          	jalr	-1688(ra) # 80000cc0 <panic>
  *pte &= ~PTE_U;
    80002360:	fe843783          	ld	a5,-24(s0)
    80002364:	639c                	ld	a5,0(a5)
    80002366:	fef7f713          	andi	a4,a5,-17
    8000236a:	fe843783          	ld	a5,-24(s0)
    8000236e:	e398                	sd	a4,0(a5)
}
    80002370:	0001                	nop
    80002372:	70a2                	ld	ra,40(sp)
    80002374:	7402                	ld	s0,32(sp)
    80002376:	6145                	addi	sp,sp,48
    80002378:	8082                	ret

000000008000237a <copyout>:
// Copy from kernel to user.
// Copy len bytes from src to virtual address dstva in a given page table.
// Return 0 on success, -1 on error.
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
    8000237a:	715d                	addi	sp,sp,-80
    8000237c:	e486                	sd	ra,72(sp)
    8000237e:	e0a2                	sd	s0,64(sp)
    80002380:	0880                	addi	s0,sp,80
    80002382:	fca43423          	sd	a0,-56(s0)
    80002386:	fcb43023          	sd	a1,-64(s0)
    8000238a:	fac43c23          	sd	a2,-72(s0)
    8000238e:	fad43823          	sd	a3,-80(s0)
  uint64 n, va0, pa0;

  while(len > 0){
    80002392:	a055                	j	80002436 <copyout+0xbc>
    va0 = PGROUNDDOWN(dstva);
    80002394:	fc043703          	ld	a4,-64(s0)
    80002398:	77fd                	lui	a5,0xfffff
    8000239a:	8ff9                	and	a5,a5,a4
    8000239c:	fef43023          	sd	a5,-32(s0)
    pa0 = walkaddr(pagetable, va0);
    800023a0:	fe043583          	ld	a1,-32(s0)
    800023a4:	fc843503          	ld	a0,-56(s0)
    800023a8:	00000097          	auipc	ra,0x0
    800023ac:	872080e7          	jalr	-1934(ra) # 80001c1a <walkaddr>
    800023b0:	fca43c23          	sd	a0,-40(s0)
    if(pa0 == 0)
    800023b4:	fd843783          	ld	a5,-40(s0)
    800023b8:	e399                	bnez	a5,800023be <copyout+0x44>
      return -1;
    800023ba:	57fd                	li	a5,-1
    800023bc:	a049                	j	8000243e <copyout+0xc4>
    n = PGSIZE - (dstva - va0);
    800023be:	fe043703          	ld	a4,-32(s0)
    800023c2:	fc043783          	ld	a5,-64(s0)
    800023c6:	8f1d                	sub	a4,a4,a5
    800023c8:	6785                	lui	a5,0x1
    800023ca:	97ba                	add	a5,a5,a4
    800023cc:	fef43423          	sd	a5,-24(s0)
    if(n > len)
    800023d0:	fe843703          	ld	a4,-24(s0)
    800023d4:	fb043783          	ld	a5,-80(s0)
    800023d8:	00e7f663          	bgeu	a5,a4,800023e4 <copyout+0x6a>
      n = len;
    800023dc:	fb043783          	ld	a5,-80(s0)
    800023e0:	fef43423          	sd	a5,-24(s0)
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800023e4:	fc043703          	ld	a4,-64(s0)
    800023e8:	fe043783          	ld	a5,-32(s0)
    800023ec:	8f1d                	sub	a4,a4,a5
    800023ee:	fd843783          	ld	a5,-40(s0)
    800023f2:	97ba                	add	a5,a5,a4
    800023f4:	873e                	mv	a4,a5
    800023f6:	fe843783          	ld	a5,-24(s0)
    800023fa:	2781                	sext.w	a5,a5
    800023fc:	863e                	mv	a2,a5
    800023fe:	fb843583          	ld	a1,-72(s0)
    80002402:	853a                	mv	a0,a4
    80002404:	fffff097          	auipc	ra,0xfffff
    80002408:	180080e7          	jalr	384(ra) # 80001584 <memmove>

    len -= n;
    8000240c:	fb043703          	ld	a4,-80(s0)
    80002410:	fe843783          	ld	a5,-24(s0)
    80002414:	40f707b3          	sub	a5,a4,a5
    80002418:	faf43823          	sd	a5,-80(s0)
    src += n;
    8000241c:	fb843703          	ld	a4,-72(s0)
    80002420:	fe843783          	ld	a5,-24(s0)
    80002424:	97ba                	add	a5,a5,a4
    80002426:	faf43c23          	sd	a5,-72(s0)
    dstva = va0 + PGSIZE;
    8000242a:	fe043703          	ld	a4,-32(s0)
    8000242e:	6785                	lui	a5,0x1
    80002430:	97ba                	add	a5,a5,a4
    80002432:	fcf43023          	sd	a5,-64(s0)
  while(len > 0){
    80002436:	fb043783          	ld	a5,-80(s0)
    8000243a:	ffa9                	bnez	a5,80002394 <copyout+0x1a>
  }
  return 0;
    8000243c:	4781                	li	a5,0
}
    8000243e:	853e                	mv	a0,a5
    80002440:	60a6                	ld	ra,72(sp)
    80002442:	6406                	ld	s0,64(sp)
    80002444:	6161                	addi	sp,sp,80
    80002446:	8082                	ret

0000000080002448 <copyin>:
// Copy from user to kernel.
// Copy len bytes to dst from virtual address srcva in a given page table.
// Return 0 on success, -1 on error.
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
    80002448:	715d                	addi	sp,sp,-80
    8000244a:	e486                	sd	ra,72(sp)
    8000244c:	e0a2                	sd	s0,64(sp)
    8000244e:	0880                	addi	s0,sp,80
    80002450:	fca43423          	sd	a0,-56(s0)
    80002454:	fcb43023          	sd	a1,-64(s0)
    80002458:	fac43c23          	sd	a2,-72(s0)
    8000245c:	fad43823          	sd	a3,-80(s0)
  uint64 n, va0, pa0;

  while(len > 0){
    80002460:	a055                	j	80002504 <copyin+0xbc>
    va0 = PGROUNDDOWN(srcva);
    80002462:	fb843703          	ld	a4,-72(s0)
    80002466:	77fd                	lui	a5,0xfffff
    80002468:	8ff9                	and	a5,a5,a4
    8000246a:	fef43023          	sd	a5,-32(s0)
    pa0 = walkaddr(pagetable, va0);
    8000246e:	fe043583          	ld	a1,-32(s0)
    80002472:	fc843503          	ld	a0,-56(s0)
    80002476:	fffff097          	auipc	ra,0xfffff
    8000247a:	7a4080e7          	jalr	1956(ra) # 80001c1a <walkaddr>
    8000247e:	fca43c23          	sd	a0,-40(s0)
    if(pa0 == 0)
    80002482:	fd843783          	ld	a5,-40(s0)
    80002486:	e399                	bnez	a5,8000248c <copyin+0x44>
      return -1;
    80002488:	57fd                	li	a5,-1
    8000248a:	a049                	j	8000250c <copyin+0xc4>
    n = PGSIZE - (srcva - va0);
    8000248c:	fe043703          	ld	a4,-32(s0)
    80002490:	fb843783          	ld	a5,-72(s0)
    80002494:	8f1d                	sub	a4,a4,a5
    80002496:	6785                	lui	a5,0x1
    80002498:	97ba                	add	a5,a5,a4
    8000249a:	fef43423          	sd	a5,-24(s0)
    if(n > len)
    8000249e:	fe843703          	ld	a4,-24(s0)
    800024a2:	fb043783          	ld	a5,-80(s0)
    800024a6:	00e7f663          	bgeu	a5,a4,800024b2 <copyin+0x6a>
      n = len;
    800024aa:	fb043783          	ld	a5,-80(s0)
    800024ae:	fef43423          	sd	a5,-24(s0)
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800024b2:	fb843703          	ld	a4,-72(s0)
    800024b6:	fe043783          	ld	a5,-32(s0)
    800024ba:	8f1d                	sub	a4,a4,a5
    800024bc:	fd843783          	ld	a5,-40(s0)
    800024c0:	97ba                	add	a5,a5,a4
    800024c2:	873e                	mv	a4,a5
    800024c4:	fe843783          	ld	a5,-24(s0)
    800024c8:	2781                	sext.w	a5,a5
    800024ca:	863e                	mv	a2,a5
    800024cc:	85ba                	mv	a1,a4
    800024ce:	fc043503          	ld	a0,-64(s0)
    800024d2:	fffff097          	auipc	ra,0xfffff
    800024d6:	0b2080e7          	jalr	178(ra) # 80001584 <memmove>

    len -= n;
    800024da:	fb043703          	ld	a4,-80(s0)
    800024de:	fe843783          	ld	a5,-24(s0)
    800024e2:	40f707b3          	sub	a5,a4,a5
    800024e6:	faf43823          	sd	a5,-80(s0)
    dst += n;
    800024ea:	fc043703          	ld	a4,-64(s0)
    800024ee:	fe843783          	ld	a5,-24(s0)
    800024f2:	97ba                	add	a5,a5,a4
    800024f4:	fcf43023          	sd	a5,-64(s0)
    srcva = va0 + PGSIZE;
    800024f8:	fe043703          	ld	a4,-32(s0)
    800024fc:	6785                	lui	a5,0x1
    800024fe:	97ba                	add	a5,a5,a4
    80002500:	faf43c23          	sd	a5,-72(s0)
  while(len > 0){
    80002504:	fb043783          	ld	a5,-80(s0)
    80002508:	ffa9                	bnez	a5,80002462 <copyin+0x1a>
  }
  return 0;
    8000250a:	4781                	li	a5,0
}
    8000250c:	853e                	mv	a0,a5
    8000250e:	60a6                	ld	ra,72(sp)
    80002510:	6406                	ld	s0,64(sp)
    80002512:	6161                	addi	sp,sp,80
    80002514:	8082                	ret

0000000080002516 <copyinstr>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    80002516:	711d                	addi	sp,sp,-96
    80002518:	ec86                	sd	ra,88(sp)
    8000251a:	e8a2                	sd	s0,80(sp)
    8000251c:	1080                	addi	s0,sp,96
    8000251e:	faa43c23          	sd	a0,-72(s0)
    80002522:	fab43823          	sd	a1,-80(s0)
    80002526:	fac43423          	sd	a2,-88(s0)
    8000252a:	fad43023          	sd	a3,-96(s0)
  uint64 n, va0, pa0;
  int got_null = 0;
    8000252e:	fe042223          	sw	zero,-28(s0)

  while(got_null == 0 && max > 0){
    80002532:	a0f1                	j	800025fe <copyinstr+0xe8>
    va0 = PGROUNDDOWN(srcva);
    80002534:	fa843703          	ld	a4,-88(s0)
    80002538:	77fd                	lui	a5,0xfffff
    8000253a:	8ff9                	and	a5,a5,a4
    8000253c:	fcf43823          	sd	a5,-48(s0)
    pa0 = walkaddr(pagetable, va0);
    80002540:	fd043583          	ld	a1,-48(s0)
    80002544:	fb843503          	ld	a0,-72(s0)
    80002548:	fffff097          	auipc	ra,0xfffff
    8000254c:	6d2080e7          	jalr	1746(ra) # 80001c1a <walkaddr>
    80002550:	fca43423          	sd	a0,-56(s0)
    if(pa0 == 0)
    80002554:	fc843783          	ld	a5,-56(s0)
    80002558:	e399                	bnez	a5,8000255e <copyinstr+0x48>
      return -1;
    8000255a:	57fd                	li	a5,-1
    8000255c:	a87d                	j	8000261a <copyinstr+0x104>
    n = PGSIZE - (srcva - va0);
    8000255e:	fd043703          	ld	a4,-48(s0)
    80002562:	fa843783          	ld	a5,-88(s0)
    80002566:	8f1d                	sub	a4,a4,a5
    80002568:	6785                	lui	a5,0x1
    8000256a:	97ba                	add	a5,a5,a4
    8000256c:	fef43423          	sd	a5,-24(s0)
    if(n > max)
    80002570:	fe843703          	ld	a4,-24(s0)
    80002574:	fa043783          	ld	a5,-96(s0)
    80002578:	00e7f663          	bgeu	a5,a4,80002584 <copyinstr+0x6e>
      n = max;
    8000257c:	fa043783          	ld	a5,-96(s0)
    80002580:	fef43423          	sd	a5,-24(s0)

    char *p = (char *) (pa0 + (srcva - va0));
    80002584:	fa843703          	ld	a4,-88(s0)
    80002588:	fd043783          	ld	a5,-48(s0)
    8000258c:	8f1d                	sub	a4,a4,a5
    8000258e:	fc843783          	ld	a5,-56(s0)
    80002592:	97ba                	add	a5,a5,a4
    80002594:	fcf43c23          	sd	a5,-40(s0)
    while(n > 0){
    80002598:	a891                	j	800025ec <copyinstr+0xd6>
      if(*p == '\0'){
    8000259a:	fd843783          	ld	a5,-40(s0)
    8000259e:	0007c783          	lbu	a5,0(a5) # 1000 <_entry-0x7ffff000>
    800025a2:	eb89                	bnez	a5,800025b4 <copyinstr+0x9e>
        *dst = '\0';
    800025a4:	fb043783          	ld	a5,-80(s0)
    800025a8:	00078023          	sb	zero,0(a5)
        got_null = 1;
    800025ac:	4785                	li	a5,1
    800025ae:	fef42223          	sw	a5,-28(s0)
        break;
    800025b2:	a081                	j	800025f2 <copyinstr+0xdc>
      } else {
        *dst = *p;
    800025b4:	fd843783          	ld	a5,-40(s0)
    800025b8:	0007c703          	lbu	a4,0(a5)
    800025bc:	fb043783          	ld	a5,-80(s0)
    800025c0:	00e78023          	sb	a4,0(a5)
      }
      --n;
    800025c4:	fe843783          	ld	a5,-24(s0)
    800025c8:	17fd                	addi	a5,a5,-1
    800025ca:	fef43423          	sd	a5,-24(s0)
      --max;
    800025ce:	fa043783          	ld	a5,-96(s0)
    800025d2:	17fd                	addi	a5,a5,-1
    800025d4:	faf43023          	sd	a5,-96(s0)
      p++;
    800025d8:	fd843783          	ld	a5,-40(s0)
    800025dc:	0785                	addi	a5,a5,1
    800025de:	fcf43c23          	sd	a5,-40(s0)
      dst++;
    800025e2:	fb043783          	ld	a5,-80(s0)
    800025e6:	0785                	addi	a5,a5,1
    800025e8:	faf43823          	sd	a5,-80(s0)
    while(n > 0){
    800025ec:	fe843783          	ld	a5,-24(s0)
    800025f0:	f7cd                	bnez	a5,8000259a <copyinstr+0x84>
    }

    srcva = va0 + PGSIZE;
    800025f2:	fd043703          	ld	a4,-48(s0)
    800025f6:	6785                	lui	a5,0x1
    800025f8:	97ba                	add	a5,a5,a4
    800025fa:	faf43423          	sd	a5,-88(s0)
  while(got_null == 0 && max > 0){
    800025fe:	fe442783          	lw	a5,-28(s0)
    80002602:	2781                	sext.w	a5,a5
    80002604:	e781                	bnez	a5,8000260c <copyinstr+0xf6>
    80002606:	fa043783          	ld	a5,-96(s0)
    8000260a:	f78d                	bnez	a5,80002534 <copyinstr+0x1e>
  }
  if(got_null){
    8000260c:	fe442783          	lw	a5,-28(s0)
    80002610:	2781                	sext.w	a5,a5
    80002612:	c399                	beqz	a5,80002618 <copyinstr+0x102>
    return 0;
    80002614:	4781                	li	a5,0
    80002616:	a011                	j	8000261a <copyinstr+0x104>
  } else {
    return -1;
    80002618:	57fd                	li	a5,-1
  }
}
    8000261a:	853e                	mv	a0,a5
    8000261c:	60e6                	ld	ra,88(sp)
    8000261e:	6446                	ld	s0,80(sp)
    80002620:	6125                	addi	sp,sp,96
    80002622:	8082                	ret

0000000080002624 <r_sstatus>:
{
    80002624:	1101                	addi	sp,sp,-32
    80002626:	ec06                	sd	ra,24(sp)
    80002628:	e822                	sd	s0,16(sp)
    8000262a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000262c:	100027f3          	csrr	a5,sstatus
    80002630:	fef43423          	sd	a5,-24(s0)
  return x;
    80002634:	fe843783          	ld	a5,-24(s0)
}
    80002638:	853e                	mv	a0,a5
    8000263a:	60e2                	ld	ra,24(sp)
    8000263c:	6442                	ld	s0,16(sp)
    8000263e:	6105                	addi	sp,sp,32
    80002640:	8082                	ret

0000000080002642 <w_sstatus>:
{
    80002642:	1101                	addi	sp,sp,-32
    80002644:	ec06                	sd	ra,24(sp)
    80002646:	e822                	sd	s0,16(sp)
    80002648:	1000                	addi	s0,sp,32
    8000264a:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000264e:	fe843783          	ld	a5,-24(s0)
    80002652:	10079073          	csrw	sstatus,a5
}
    80002656:	0001                	nop
    80002658:	60e2                	ld	ra,24(sp)
    8000265a:	6442                	ld	s0,16(sp)
    8000265c:	6105                	addi	sp,sp,32
    8000265e:	8082                	ret

0000000080002660 <intr_on>:
{
    80002660:	1141                	addi	sp,sp,-16
    80002662:	e406                	sd	ra,8(sp)
    80002664:	e022                	sd	s0,0(sp)
    80002666:	0800                	addi	s0,sp,16
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002668:	00000097          	auipc	ra,0x0
    8000266c:	fbc080e7          	jalr	-68(ra) # 80002624 <r_sstatus>
    80002670:	87aa                	mv	a5,a0
    80002672:	0027e793          	ori	a5,a5,2
    80002676:	853e                	mv	a0,a5
    80002678:	00000097          	auipc	ra,0x0
    8000267c:	fca080e7          	jalr	-54(ra) # 80002642 <w_sstatus>
}
    80002680:	0001                	nop
    80002682:	60a2                	ld	ra,8(sp)
    80002684:	6402                	ld	s0,0(sp)
    80002686:	0141                	addi	sp,sp,16
    80002688:	8082                	ret

000000008000268a <intr_get>:
{
    8000268a:	1101                	addi	sp,sp,-32
    8000268c:	ec06                	sd	ra,24(sp)
    8000268e:	e822                	sd	s0,16(sp)
    80002690:	1000                	addi	s0,sp,32
  uint64 x = r_sstatus();
    80002692:	00000097          	auipc	ra,0x0
    80002696:	f92080e7          	jalr	-110(ra) # 80002624 <r_sstatus>
    8000269a:	fea43423          	sd	a0,-24(s0)
  return (x & SSTATUS_SIE) != 0;
    8000269e:	fe843783          	ld	a5,-24(s0)
    800026a2:	8b89                	andi	a5,a5,2
    800026a4:	00f037b3          	snez	a5,a5
    800026a8:	0ff7f793          	zext.b	a5,a5
    800026ac:	2781                	sext.w	a5,a5
}
    800026ae:	853e                	mv	a0,a5
    800026b0:	60e2                	ld	ra,24(sp)
    800026b2:	6442                	ld	s0,16(sp)
    800026b4:	6105                	addi	sp,sp,32
    800026b6:	8082                	ret

00000000800026b8 <r_tp>:
{
    800026b8:	1101                	addi	sp,sp,-32
    800026ba:	ec06                	sd	ra,24(sp)
    800026bc:	e822                	sd	s0,16(sp)
    800026be:	1000                	addi	s0,sp,32
  asm volatile("mv %0, tp" : "=r" (x) );
    800026c0:	8792                	mv	a5,tp
    800026c2:	fef43423          	sd	a5,-24(s0)
  return x;
    800026c6:	fe843783          	ld	a5,-24(s0)
}
    800026ca:	853e                	mv	a0,a5
    800026cc:	60e2                	ld	ra,24(sp)
    800026ce:	6442                	ld	s0,16(sp)
    800026d0:	6105                	addi	sp,sp,32
    800026d2:	8082                	ret

00000000800026d4 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    800026d4:	7139                	addi	sp,sp,-64
    800026d6:	fc06                	sd	ra,56(sp)
    800026d8:	f822                	sd	s0,48(sp)
    800026da:	0080                	addi	s0,sp,64
    800026dc:	fca43423          	sd	a0,-56(s0)
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    800026e0:	00012797          	auipc	a5,0x12
    800026e4:	87878793          	addi	a5,a5,-1928 # 80013f58 <proc>
    800026e8:	fef43423          	sd	a5,-24(s0)
    800026ec:	a061                	j	80002774 <proc_mapstacks+0xa0>
    char *pa = kalloc();
    800026ee:	fffff097          	auipc	ra,0xfffff
    800026f2:	a76080e7          	jalr	-1418(ra) # 80001164 <kalloc>
    800026f6:	fea43023          	sd	a0,-32(s0)
    if(pa == 0)
    800026fa:	fe043783          	ld	a5,-32(s0)
    800026fe:	eb89                	bnez	a5,80002710 <proc_mapstacks+0x3c>
      panic("kalloc");
    80002700:	00009517          	auipc	a0,0x9
    80002704:	ac050513          	addi	a0,a0,-1344 # 8000b1c0 <etext+0x1c0>
    80002708:	ffffe097          	auipc	ra,0xffffe
    8000270c:	5b8080e7          	jalr	1464(ra) # 80000cc0 <panic>
    uint64 va = KSTACK((int) (p - proc));
    80002710:	fe843703          	ld	a4,-24(s0)
    80002714:	00012797          	auipc	a5,0x12
    80002718:	84478793          	addi	a5,a5,-1980 # 80013f58 <proc>
    8000271c:	40f707b3          	sub	a5,a4,a5
    80002720:	4037d713          	srai	a4,a5,0x3
    80002724:	00009797          	auipc	a5,0x9
    80002728:	ba478793          	addi	a5,a5,-1116 # 8000b2c8 <etext+0x2c8>
    8000272c:	639c                	ld	a5,0(a5)
    8000272e:	02f707b3          	mul	a5,a4,a5
    80002732:	2781                	sext.w	a5,a5
    80002734:	2785                	addiw	a5,a5,1
    80002736:	2781                	sext.w	a5,a5
    80002738:	00d7979b          	slliw	a5,a5,0xd
    8000273c:	2781                	sext.w	a5,a5
    8000273e:	873e                	mv	a4,a5
    80002740:	040007b7          	lui	a5,0x4000
    80002744:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002746:	07b2                	slli	a5,a5,0xc
    80002748:	8f99                	sub	a5,a5,a4
    8000274a:	fcf43c23          	sd	a5,-40(s0)
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000274e:	fe043783          	ld	a5,-32(s0)
    80002752:	4719                	li	a4,6
    80002754:	6685                	lui	a3,0x1
    80002756:	863e                	mv	a2,a5
    80002758:	fd843583          	ld	a1,-40(s0)
    8000275c:	fc843503          	ld	a0,-56(s0)
    80002760:	fffff097          	auipc	ra,0xfffff
    80002764:	532080e7          	jalr	1330(ra) # 80001c92 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002768:	fe843783          	ld	a5,-24(s0)
    8000276c:	16878793          	addi	a5,a5,360
    80002770:	fef43423          	sd	a5,-24(s0)
    80002774:	fe843703          	ld	a4,-24(s0)
    80002778:	00017797          	auipc	a5,0x17
    8000277c:	1e078793          	addi	a5,a5,480 # 80019958 <pid_lock>
    80002780:	f6f767e3          	bltu	a4,a5,800026ee <proc_mapstacks+0x1a>
  }
}
    80002784:	0001                	nop
    80002786:	0001                	nop
    80002788:	70e2                	ld	ra,56(sp)
    8000278a:	7442                	ld	s0,48(sp)
    8000278c:	6121                	addi	sp,sp,64
    8000278e:	8082                	ret

0000000080002790 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80002790:	1101                	addi	sp,sp,-32
    80002792:	ec06                	sd	ra,24(sp)
    80002794:	e822                	sd	s0,16(sp)
    80002796:	1000                	addi	s0,sp,32
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80002798:	00009597          	auipc	a1,0x9
    8000279c:	a3058593          	addi	a1,a1,-1488 # 8000b1c8 <etext+0x1c8>
    800027a0:	00017517          	auipc	a0,0x17
    800027a4:	1b850513          	addi	a0,a0,440 # 80019958 <pid_lock>
    800027a8:	fffff097          	auipc	ra,0xfffff
    800027ac:	ae8080e7          	jalr	-1304(ra) # 80001290 <initlock>
  initlock(&wait_lock, "wait_lock");
    800027b0:	00009597          	auipc	a1,0x9
    800027b4:	a2058593          	addi	a1,a1,-1504 # 8000b1d0 <etext+0x1d0>
    800027b8:	00017517          	auipc	a0,0x17
    800027bc:	1b850513          	addi	a0,a0,440 # 80019970 <wait_lock>
    800027c0:	fffff097          	auipc	ra,0xfffff
    800027c4:	ad0080e7          	jalr	-1328(ra) # 80001290 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    800027c8:	00011797          	auipc	a5,0x11
    800027cc:	79078793          	addi	a5,a5,1936 # 80013f58 <proc>
    800027d0:	fef43423          	sd	a5,-24(s0)
    800027d4:	a0bd                	j	80002842 <procinit+0xb2>
      initlock(&p->lock, "proc");
    800027d6:	fe843783          	ld	a5,-24(s0)
    800027da:	00009597          	auipc	a1,0x9
    800027de:	a0658593          	addi	a1,a1,-1530 # 8000b1e0 <etext+0x1e0>
    800027e2:	853e                	mv	a0,a5
    800027e4:	fffff097          	auipc	ra,0xfffff
    800027e8:	aac080e7          	jalr	-1364(ra) # 80001290 <initlock>
      p->state = UNUSED;
    800027ec:	fe843783          	ld	a5,-24(s0)
    800027f0:	0007ac23          	sw	zero,24(a5)
      p->kstack = KSTACK((int) (p - proc));
    800027f4:	fe843703          	ld	a4,-24(s0)
    800027f8:	00011797          	auipc	a5,0x11
    800027fc:	76078793          	addi	a5,a5,1888 # 80013f58 <proc>
    80002800:	40f707b3          	sub	a5,a4,a5
    80002804:	4037d713          	srai	a4,a5,0x3
    80002808:	00009797          	auipc	a5,0x9
    8000280c:	ac078793          	addi	a5,a5,-1344 # 8000b2c8 <etext+0x2c8>
    80002810:	639c                	ld	a5,0(a5)
    80002812:	02f707b3          	mul	a5,a4,a5
    80002816:	2781                	sext.w	a5,a5
    80002818:	2785                	addiw	a5,a5,1
    8000281a:	2781                	sext.w	a5,a5
    8000281c:	00d7979b          	slliw	a5,a5,0xd
    80002820:	2781                	sext.w	a5,a5
    80002822:	873e                	mv	a4,a5
    80002824:	040007b7          	lui	a5,0x4000
    80002828:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    8000282a:	07b2                	slli	a5,a5,0xc
    8000282c:	8f99                	sub	a5,a5,a4
    8000282e:	873e                	mv	a4,a5
    80002830:	fe843783          	ld	a5,-24(s0)
    80002834:	e3b8                	sd	a4,64(a5)
  for(p = proc; p < &proc[NPROC]; p++) {
    80002836:	fe843783          	ld	a5,-24(s0)
    8000283a:	16878793          	addi	a5,a5,360
    8000283e:	fef43423          	sd	a5,-24(s0)
    80002842:	fe843703          	ld	a4,-24(s0)
    80002846:	00017797          	auipc	a5,0x17
    8000284a:	11278793          	addi	a5,a5,274 # 80019958 <pid_lock>
    8000284e:	f8f764e3          	bltu	a4,a5,800027d6 <procinit+0x46>
  }
}
    80002852:	0001                	nop
    80002854:	0001                	nop
    80002856:	60e2                	ld	ra,24(sp)
    80002858:	6442                	ld	s0,16(sp)
    8000285a:	6105                	addi	sp,sp,32
    8000285c:	8082                	ret

000000008000285e <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    8000285e:	1101                	addi	sp,sp,-32
    80002860:	ec06                	sd	ra,24(sp)
    80002862:	e822                	sd	s0,16(sp)
    80002864:	1000                	addi	s0,sp,32
  int id = r_tp();
    80002866:	00000097          	auipc	ra,0x0
    8000286a:	e52080e7          	jalr	-430(ra) # 800026b8 <r_tp>
    8000286e:	87aa                	mv	a5,a0
    80002870:	fef42623          	sw	a5,-20(s0)
  return id;
    80002874:	fec42783          	lw	a5,-20(s0)
}
    80002878:	853e                	mv	a0,a5
    8000287a:	60e2                	ld	ra,24(sp)
    8000287c:	6442                	ld	s0,16(sp)
    8000287e:	6105                	addi	sp,sp,32
    80002880:	8082                	ret

0000000080002882 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80002882:	1101                	addi	sp,sp,-32
    80002884:	ec06                	sd	ra,24(sp)
    80002886:	e822                	sd	s0,16(sp)
    80002888:	1000                	addi	s0,sp,32
  int id = cpuid();
    8000288a:	00000097          	auipc	ra,0x0
    8000288e:	fd4080e7          	jalr	-44(ra) # 8000285e <cpuid>
    80002892:	87aa                	mv	a5,a0
    80002894:	fef42623          	sw	a5,-20(s0)
  struct cpu *c = &cpus[id];
    80002898:	fec42783          	lw	a5,-20(s0)
    8000289c:	00779713          	slli	a4,a5,0x7
    800028a0:	00011797          	auipc	a5,0x11
    800028a4:	2b878793          	addi	a5,a5,696 # 80013b58 <cpus>
    800028a8:	97ba                	add	a5,a5,a4
    800028aa:	fef43023          	sd	a5,-32(s0)
  return c;
    800028ae:	fe043783          	ld	a5,-32(s0)
}
    800028b2:	853e                	mv	a0,a5
    800028b4:	60e2                	ld	ra,24(sp)
    800028b6:	6442                	ld	s0,16(sp)
    800028b8:	6105                	addi	sp,sp,32
    800028ba:	8082                	ret

00000000800028bc <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    800028bc:	1101                	addi	sp,sp,-32
    800028be:	ec06                	sd	ra,24(sp)
    800028c0:	e822                	sd	s0,16(sp)
    800028c2:	1000                	addi	s0,sp,32
  push_off();
    800028c4:	fffff097          	auipc	ra,0xfffff
    800028c8:	afe080e7          	jalr	-1282(ra) # 800013c2 <push_off>
  struct cpu *c = mycpu();
    800028cc:	00000097          	auipc	ra,0x0
    800028d0:	fb6080e7          	jalr	-74(ra) # 80002882 <mycpu>
    800028d4:	fea43423          	sd	a0,-24(s0)
  struct proc *p = c->proc;
    800028d8:	fe843783          	ld	a5,-24(s0)
    800028dc:	639c                	ld	a5,0(a5)
    800028de:	fef43023          	sd	a5,-32(s0)
  pop_off();
    800028e2:	fffff097          	auipc	ra,0xfffff
    800028e6:	b38080e7          	jalr	-1224(ra) # 8000141a <pop_off>
  return p;
    800028ea:	fe043783          	ld	a5,-32(s0)
}
    800028ee:	853e                	mv	a0,a5
    800028f0:	60e2                	ld	ra,24(sp)
    800028f2:	6442                	ld	s0,16(sp)
    800028f4:	6105                	addi	sp,sp,32
    800028f6:	8082                	ret

00000000800028f8 <allocpid>:

int
allocpid()
{
    800028f8:	1101                	addi	sp,sp,-32
    800028fa:	ec06                	sd	ra,24(sp)
    800028fc:	e822                	sd	s0,16(sp)
    800028fe:	1000                	addi	s0,sp,32
  int pid;
  
  acquire(&pid_lock);
    80002900:	00017517          	auipc	a0,0x17
    80002904:	05850513          	addi	a0,a0,88 # 80019958 <pid_lock>
    80002908:	fffff097          	auipc	ra,0xfffff
    8000290c:	9bc080e7          	jalr	-1604(ra) # 800012c4 <acquire>
  pid = nextpid;
    80002910:	00009797          	auipc	a5,0x9
    80002914:	e6078793          	addi	a5,a5,-416 # 8000b770 <nextpid>
    80002918:	439c                	lw	a5,0(a5)
    8000291a:	fef42623          	sw	a5,-20(s0)
  nextpid = nextpid + 1;
    8000291e:	00009797          	auipc	a5,0x9
    80002922:	e5278793          	addi	a5,a5,-430 # 8000b770 <nextpid>
    80002926:	439c                	lw	a5,0(a5)
    80002928:	2785                	addiw	a5,a5,1
    8000292a:	0007871b          	sext.w	a4,a5
    8000292e:	00009797          	auipc	a5,0x9
    80002932:	e4278793          	addi	a5,a5,-446 # 8000b770 <nextpid>
    80002936:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80002938:	00017517          	auipc	a0,0x17
    8000293c:	02050513          	addi	a0,a0,32 # 80019958 <pid_lock>
    80002940:	fffff097          	auipc	ra,0xfffff
    80002944:	9e8080e7          	jalr	-1560(ra) # 80001328 <release>

  return pid;
    80002948:	fec42783          	lw	a5,-20(s0)
}
    8000294c:	853e                	mv	a0,a5
    8000294e:	60e2                	ld	ra,24(sp)
    80002950:	6442                	ld	s0,16(sp)
    80002952:	6105                	addi	sp,sp,32
    80002954:	8082                	ret

0000000080002956 <allocproc>:
// If found, initialize state required to run in the kernel,
// and return with p->lock held.
// If there are no free procs, or a memory allocation fails, return 0.
static struct proc*
allocproc(void)
{
    80002956:	1101                	addi	sp,sp,-32
    80002958:	ec06                	sd	ra,24(sp)
    8000295a:	e822                	sd	s0,16(sp)
    8000295c:	1000                	addi	s0,sp,32
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000295e:	00011797          	auipc	a5,0x11
    80002962:	5fa78793          	addi	a5,a5,1530 # 80013f58 <proc>
    80002966:	fef43423          	sd	a5,-24(s0)
    8000296a:	a80d                	j	8000299c <allocproc+0x46>
    acquire(&p->lock);
    8000296c:	fe843783          	ld	a5,-24(s0)
    80002970:	853e                	mv	a0,a5
    80002972:	fffff097          	auipc	ra,0xfffff
    80002976:	952080e7          	jalr	-1710(ra) # 800012c4 <acquire>
    if(p->state == UNUSED) {
    8000297a:	fe843783          	ld	a5,-24(s0)
    8000297e:	4f9c                	lw	a5,24(a5)
    80002980:	cb85                	beqz	a5,800029b0 <allocproc+0x5a>
      goto found;
    } else {
      release(&p->lock);
    80002982:	fe843783          	ld	a5,-24(s0)
    80002986:	853e                	mv	a0,a5
    80002988:	fffff097          	auipc	ra,0xfffff
    8000298c:	9a0080e7          	jalr	-1632(ra) # 80001328 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002990:	fe843783          	ld	a5,-24(s0)
    80002994:	16878793          	addi	a5,a5,360
    80002998:	fef43423          	sd	a5,-24(s0)
    8000299c:	fe843703          	ld	a4,-24(s0)
    800029a0:	00017797          	auipc	a5,0x17
    800029a4:	fb878793          	addi	a5,a5,-72 # 80019958 <pid_lock>
    800029a8:	fcf762e3          	bltu	a4,a5,8000296c <allocproc+0x16>
    }
  }
  return 0;
    800029ac:	4781                	li	a5,0
    800029ae:	a0e1                	j	80002a76 <allocproc+0x120>
      goto found;
    800029b0:	0001                	nop

found:
  p->pid = allocpid();
    800029b2:	00000097          	auipc	ra,0x0
    800029b6:	f46080e7          	jalr	-186(ra) # 800028f8 <allocpid>
    800029ba:	87aa                	mv	a5,a0
    800029bc:	873e                	mv	a4,a5
    800029be:	fe843783          	ld	a5,-24(s0)
    800029c2:	db98                	sw	a4,48(a5)
  p->state = USED;
    800029c4:	fe843783          	ld	a5,-24(s0)
    800029c8:	4705                	li	a4,1
    800029ca:	cf98                	sw	a4,24(a5)

  // Allocate a trapframe page.
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800029cc:	ffffe097          	auipc	ra,0xffffe
    800029d0:	798080e7          	jalr	1944(ra) # 80001164 <kalloc>
    800029d4:	872a                	mv	a4,a0
    800029d6:	fe843783          	ld	a5,-24(s0)
    800029da:	efb8                	sd	a4,88(a5)
    800029dc:	fe843783          	ld	a5,-24(s0)
    800029e0:	6fbc                	ld	a5,88(a5)
    800029e2:	e385                	bnez	a5,80002a02 <allocproc+0xac>
    freeproc(p);
    800029e4:	fe843503          	ld	a0,-24(s0)
    800029e8:	00000097          	auipc	ra,0x0
    800029ec:	098080e7          	jalr	152(ra) # 80002a80 <freeproc>
    release(&p->lock);
    800029f0:	fe843783          	ld	a5,-24(s0)
    800029f4:	853e                	mv	a0,a5
    800029f6:	fffff097          	auipc	ra,0xfffff
    800029fa:	932080e7          	jalr	-1742(ra) # 80001328 <release>
    return 0;
    800029fe:	4781                	li	a5,0
    80002a00:	a89d                	j	80002a76 <allocproc+0x120>
  }

  // An empty user page table.
  p->pagetable = proc_pagetable(p);
    80002a02:	fe843503          	ld	a0,-24(s0)
    80002a06:	00000097          	auipc	ra,0x0
    80002a0a:	118080e7          	jalr	280(ra) # 80002b1e <proc_pagetable>
    80002a0e:	872a                	mv	a4,a0
    80002a10:	fe843783          	ld	a5,-24(s0)
    80002a14:	ebb8                	sd	a4,80(a5)
  if(p->pagetable == 0){
    80002a16:	fe843783          	ld	a5,-24(s0)
    80002a1a:	6bbc                	ld	a5,80(a5)
    80002a1c:	e385                	bnez	a5,80002a3c <allocproc+0xe6>
    freeproc(p);
    80002a1e:	fe843503          	ld	a0,-24(s0)
    80002a22:	00000097          	auipc	ra,0x0
    80002a26:	05e080e7          	jalr	94(ra) # 80002a80 <freeproc>
    release(&p->lock);
    80002a2a:	fe843783          	ld	a5,-24(s0)
    80002a2e:	853e                	mv	a0,a5
    80002a30:	fffff097          	auipc	ra,0xfffff
    80002a34:	8f8080e7          	jalr	-1800(ra) # 80001328 <release>
    return 0;
    80002a38:	4781                	li	a5,0
    80002a3a:	a835                	j	80002a76 <allocproc+0x120>
  }

  // Set up new context to start executing at forkret,
  // which returns to user space.
  memset(&p->context, 0, sizeof(p->context));
    80002a3c:	fe843783          	ld	a5,-24(s0)
    80002a40:	06078793          	addi	a5,a5,96
    80002a44:	07000613          	li	a2,112
    80002a48:	4581                	li	a1,0
    80002a4a:	853e                	mv	a0,a5
    80002a4c:	fffff097          	auipc	ra,0xfffff
    80002a50:	a4c080e7          	jalr	-1460(ra) # 80001498 <memset>
  p->context.ra = (uint64)forkret;
    80002a54:	00001717          	auipc	a4,0x1
    80002a58:	9d270713          	addi	a4,a4,-1582 # 80003426 <forkret>
    80002a5c:	fe843783          	ld	a5,-24(s0)
    80002a60:	f3b8                	sd	a4,96(a5)
  p->context.sp = p->kstack + PGSIZE;
    80002a62:	fe843783          	ld	a5,-24(s0)
    80002a66:	63b8                	ld	a4,64(a5)
    80002a68:	6785                	lui	a5,0x1
    80002a6a:	973e                	add	a4,a4,a5
    80002a6c:	fe843783          	ld	a5,-24(s0)
    80002a70:	f7b8                	sd	a4,104(a5)

  return p;
    80002a72:	fe843783          	ld	a5,-24(s0)
}
    80002a76:	853e                	mv	a0,a5
    80002a78:	60e2                	ld	ra,24(sp)
    80002a7a:	6442                	ld	s0,16(sp)
    80002a7c:	6105                	addi	sp,sp,32
    80002a7e:	8082                	ret

0000000080002a80 <freeproc>:
// free a proc structure and the data hanging from it,
// including user pages.
// p->lock must be held.
static void
freeproc(struct proc *p)
{
    80002a80:	1101                	addi	sp,sp,-32
    80002a82:	ec06                	sd	ra,24(sp)
    80002a84:	e822                	sd	s0,16(sp)
    80002a86:	1000                	addi	s0,sp,32
    80002a88:	fea43423          	sd	a0,-24(s0)
  if(p->trapframe)
    80002a8c:	fe843783          	ld	a5,-24(s0)
    80002a90:	6fbc                	ld	a5,88(a5)
    80002a92:	cb89                	beqz	a5,80002aa4 <freeproc+0x24>
    kfree((void*)p->trapframe);
    80002a94:	fe843783          	ld	a5,-24(s0)
    80002a98:	6fbc                	ld	a5,88(a5)
    80002a9a:	853e                	mv	a0,a5
    80002a9c:	ffffe097          	auipc	ra,0xffffe
    80002aa0:	624080e7          	jalr	1572(ra) # 800010c0 <kfree>
  p->trapframe = 0;
    80002aa4:	fe843783          	ld	a5,-24(s0)
    80002aa8:	0407bc23          	sd	zero,88(a5) # 1058 <_entry-0x7fffefa8>
  if(p->pagetable)
    80002aac:	fe843783          	ld	a5,-24(s0)
    80002ab0:	6bbc                	ld	a5,80(a5)
    80002ab2:	cf89                	beqz	a5,80002acc <freeproc+0x4c>
    proc_freepagetable(p->pagetable, p->sz);
    80002ab4:	fe843783          	ld	a5,-24(s0)
    80002ab8:	6bb8                	ld	a4,80(a5)
    80002aba:	fe843783          	ld	a5,-24(s0)
    80002abe:	67bc                	ld	a5,72(a5)
    80002ac0:	85be                	mv	a1,a5
    80002ac2:	853a                	mv	a0,a4
    80002ac4:	00000097          	auipc	ra,0x0
    80002ac8:	11a080e7          	jalr	282(ra) # 80002bde <proc_freepagetable>
  p->pagetable = 0;
    80002acc:	fe843783          	ld	a5,-24(s0)
    80002ad0:	0407b823          	sd	zero,80(a5)
  p->sz = 0;
    80002ad4:	fe843783          	ld	a5,-24(s0)
    80002ad8:	0407b423          	sd	zero,72(a5)
  p->pid = 0;
    80002adc:	fe843783          	ld	a5,-24(s0)
    80002ae0:	0207a823          	sw	zero,48(a5)
  p->parent = 0;
    80002ae4:	fe843783          	ld	a5,-24(s0)
    80002ae8:	0207bc23          	sd	zero,56(a5)
  p->name[0] = 0;
    80002aec:	fe843783          	ld	a5,-24(s0)
    80002af0:	14078c23          	sb	zero,344(a5)
  p->chan = 0;
    80002af4:	fe843783          	ld	a5,-24(s0)
    80002af8:	0207b023          	sd	zero,32(a5)
  p->killed = 0;
    80002afc:	fe843783          	ld	a5,-24(s0)
    80002b00:	0207a423          	sw	zero,40(a5)
  p->xstate = 0;
    80002b04:	fe843783          	ld	a5,-24(s0)
    80002b08:	0207a623          	sw	zero,44(a5)
  p->state = UNUSED;
    80002b0c:	fe843783          	ld	a5,-24(s0)
    80002b10:	0007ac23          	sw	zero,24(a5)
}
    80002b14:	0001                	nop
    80002b16:	60e2                	ld	ra,24(sp)
    80002b18:	6442                	ld	s0,16(sp)
    80002b1a:	6105                	addi	sp,sp,32
    80002b1c:	8082                	ret

0000000080002b1e <proc_pagetable>:

// Create a user page table for a given process, with no user memory,
// but with trampoline and trapframe pages.
pagetable_t
proc_pagetable(struct proc *p)
{
    80002b1e:	7179                	addi	sp,sp,-48
    80002b20:	f406                	sd	ra,40(sp)
    80002b22:	f022                	sd	s0,32(sp)
    80002b24:	1800                	addi	s0,sp,48
    80002b26:	fca43c23          	sd	a0,-40(s0)
  pagetable_t pagetable;

  // An empty page table.
  pagetable = uvmcreate();
    80002b2a:	fffff097          	auipc	ra,0xfffff
    80002b2e:	3a0080e7          	jalr	928(ra) # 80001eca <uvmcreate>
    80002b32:	fea43423          	sd	a0,-24(s0)
  if(pagetable == 0)
    80002b36:	fe843783          	ld	a5,-24(s0)
    80002b3a:	e399                	bnez	a5,80002b40 <proc_pagetable+0x22>
    return 0;
    80002b3c:	4781                	li	a5,0
    80002b3e:	a859                	j	80002bd4 <proc_pagetable+0xb6>

  // map the trampoline code (for system call return)
  // at the highest user virtual address.
  // only the supervisor uses it, on the way
  // to/from user space, so not PTE_U.
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80002b40:	00007797          	auipc	a5,0x7
    80002b44:	4c078793          	addi	a5,a5,1216 # 8000a000 <_trampoline>
    80002b48:	4729                	li	a4,10
    80002b4a:	86be                	mv	a3,a5
    80002b4c:	6605                	lui	a2,0x1
    80002b4e:	040007b7          	lui	a5,0x4000
    80002b52:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002b54:	00c79593          	slli	a1,a5,0xc
    80002b58:	fe843503          	ld	a0,-24(s0)
    80002b5c:	fffff097          	auipc	ra,0xfffff
    80002b60:	190080e7          	jalr	400(ra) # 80001cec <mappages>
    80002b64:	87aa                	mv	a5,a0
    80002b66:	0007db63          	bgez	a5,80002b7c <proc_pagetable+0x5e>
              (uint64)trampoline, PTE_R | PTE_X) < 0){
    uvmfree(pagetable, 0);
    80002b6a:	4581                	li	a1,0
    80002b6c:	fe843503          	ld	a0,-24(s0)
    80002b70:	fffff097          	auipc	ra,0xfffff
    80002b74:	656080e7          	jalr	1622(ra) # 800021c6 <uvmfree>
    return 0;
    80002b78:	4781                	li	a5,0
    80002b7a:	a8a9                	j	80002bd4 <proc_pagetable+0xb6>
  }

  // map the trapframe page just below the trampoline page, for
  // trampoline.S.
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
              (uint64)(p->trapframe), PTE_R | PTE_W) < 0){
    80002b7c:	fd843783          	ld	a5,-40(s0)
    80002b80:	6fbc                	ld	a5,88(a5)
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80002b82:	4719                	li	a4,6
    80002b84:	86be                	mv	a3,a5
    80002b86:	6605                	lui	a2,0x1
    80002b88:	020007b7          	lui	a5,0x2000
    80002b8c:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80002b8e:	00d79593          	slli	a1,a5,0xd
    80002b92:	fe843503          	ld	a0,-24(s0)
    80002b96:	fffff097          	auipc	ra,0xfffff
    80002b9a:	156080e7          	jalr	342(ra) # 80001cec <mappages>
    80002b9e:	87aa                	mv	a5,a0
    80002ba0:	0207d863          	bgez	a5,80002bd0 <proc_pagetable+0xb2>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80002ba4:	4681                	li	a3,0
    80002ba6:	4605                	li	a2,1
    80002ba8:	040007b7          	lui	a5,0x4000
    80002bac:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002bae:	00c79593          	slli	a1,a5,0xc
    80002bb2:	fe843503          	ld	a0,-24(s0)
    80002bb6:	fffff097          	auipc	ra,0xfffff
    80002bba:	214080e7          	jalr	532(ra) # 80001dca <uvmunmap>
    uvmfree(pagetable, 0);
    80002bbe:	4581                	li	a1,0
    80002bc0:	fe843503          	ld	a0,-24(s0)
    80002bc4:	fffff097          	auipc	ra,0xfffff
    80002bc8:	602080e7          	jalr	1538(ra) # 800021c6 <uvmfree>
    return 0;
    80002bcc:	4781                	li	a5,0
    80002bce:	a019                	j	80002bd4 <proc_pagetable+0xb6>
  }

  return pagetable;
    80002bd0:	fe843783          	ld	a5,-24(s0)
}
    80002bd4:	853e                	mv	a0,a5
    80002bd6:	70a2                	ld	ra,40(sp)
    80002bd8:	7402                	ld	s0,32(sp)
    80002bda:	6145                	addi	sp,sp,48
    80002bdc:	8082                	ret

0000000080002bde <proc_freepagetable>:

// Free a process's page table, and free the
// physical memory it refers to.
void
proc_freepagetable(pagetable_t pagetable, uint64 sz)
{
    80002bde:	1101                	addi	sp,sp,-32
    80002be0:	ec06                	sd	ra,24(sp)
    80002be2:	e822                	sd	s0,16(sp)
    80002be4:	1000                	addi	s0,sp,32
    80002be6:	fea43423          	sd	a0,-24(s0)
    80002bea:	feb43023          	sd	a1,-32(s0)
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80002bee:	4681                	li	a3,0
    80002bf0:	4605                	li	a2,1
    80002bf2:	040007b7          	lui	a5,0x4000
    80002bf6:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002bf8:	00c79593          	slli	a1,a5,0xc
    80002bfc:	fe843503          	ld	a0,-24(s0)
    80002c00:	fffff097          	auipc	ra,0xfffff
    80002c04:	1ca080e7          	jalr	458(ra) # 80001dca <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80002c08:	4681                	li	a3,0
    80002c0a:	4605                	li	a2,1
    80002c0c:	020007b7          	lui	a5,0x2000
    80002c10:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80002c12:	00d79593          	slli	a1,a5,0xd
    80002c16:	fe843503          	ld	a0,-24(s0)
    80002c1a:	fffff097          	auipc	ra,0xfffff
    80002c1e:	1b0080e7          	jalr	432(ra) # 80001dca <uvmunmap>
  uvmfree(pagetable, sz);
    80002c22:	fe043583          	ld	a1,-32(s0)
    80002c26:	fe843503          	ld	a0,-24(s0)
    80002c2a:	fffff097          	auipc	ra,0xfffff
    80002c2e:	59c080e7          	jalr	1436(ra) # 800021c6 <uvmfree>
}
    80002c32:	0001                	nop
    80002c34:	60e2                	ld	ra,24(sp)
    80002c36:	6442                	ld	s0,16(sp)
    80002c38:	6105                	addi	sp,sp,32
    80002c3a:	8082                	ret

0000000080002c3c <userinit>:
};

// Set up first user process.
void
userinit(void)
{
    80002c3c:	1101                	addi	sp,sp,-32
    80002c3e:	ec06                	sd	ra,24(sp)
    80002c40:	e822                	sd	s0,16(sp)
    80002c42:	1000                	addi	s0,sp,32
  struct proc *p;

  p = allocproc();
    80002c44:	00000097          	auipc	ra,0x0
    80002c48:	d12080e7          	jalr	-750(ra) # 80002956 <allocproc>
    80002c4c:	fea43423          	sd	a0,-24(s0)
  initproc = p;
    80002c50:	00009797          	auipc	a5,0x9
    80002c54:	c9078793          	addi	a5,a5,-880 # 8000b8e0 <initproc>
    80002c58:	fe843703          	ld	a4,-24(s0)
    80002c5c:	e398                	sd	a4,0(a5)
  
  // allocate one user page and copy initcode's instructions
  // and data into it.
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80002c5e:	fe843783          	ld	a5,-24(s0)
    80002c62:	6bbc                	ld	a5,80(a5)
    80002c64:	03400613          	li	a2,52
    80002c68:	00009597          	auipc	a1,0x9
    80002c6c:	b3058593          	addi	a1,a1,-1232 # 8000b798 <initcode>
    80002c70:	853e                	mv	a0,a5
    80002c72:	fffff097          	auipc	ra,0xfffff
    80002c76:	294080e7          	jalr	660(ra) # 80001f06 <uvmfirst>
  p->sz = PGSIZE;
    80002c7a:	fe843783          	ld	a5,-24(s0)
    80002c7e:	6705                	lui	a4,0x1
    80002c80:	e7b8                	sd	a4,72(a5)

  // prepare for the very first "return" from kernel to user.
  p->trapframe->epc = 0;      // user program counter
    80002c82:	fe843783          	ld	a5,-24(s0)
    80002c86:	6fbc                	ld	a5,88(a5)
    80002c88:	0007bc23          	sd	zero,24(a5)
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80002c8c:	fe843783          	ld	a5,-24(s0)
    80002c90:	6fbc                	ld	a5,88(a5)
    80002c92:	6705                	lui	a4,0x1
    80002c94:	fb98                	sd	a4,48(a5)

  safestrcpy(p->name, "initcode", sizeof(p->name));
    80002c96:	fe843783          	ld	a5,-24(s0)
    80002c9a:	15878793          	addi	a5,a5,344
    80002c9e:	4641                	li	a2,16
    80002ca0:	00008597          	auipc	a1,0x8
    80002ca4:	54858593          	addi	a1,a1,1352 # 8000b1e8 <etext+0x1e8>
    80002ca8:	853e                	mv	a0,a5
    80002caa:	fffff097          	auipc	ra,0xfffff
    80002cae:	b06080e7          	jalr	-1274(ra) # 800017b0 <safestrcpy>
  p->cwd = namei("/");
    80002cb2:	00008517          	auipc	a0,0x8
    80002cb6:	54650513          	addi	a0,a0,1350 # 8000b1f8 <etext+0x1f8>
    80002cba:	00003097          	auipc	ra,0x3
    80002cbe:	186080e7          	jalr	390(ra) # 80005e40 <namei>
    80002cc2:	872a                	mv	a4,a0
    80002cc4:	fe843783          	ld	a5,-24(s0)
    80002cc8:	14e7b823          	sd	a4,336(a5)

  p->state = RUNNABLE;
    80002ccc:	fe843783          	ld	a5,-24(s0)
    80002cd0:	470d                	li	a4,3
    80002cd2:	cf98                	sw	a4,24(a5)

  release(&p->lock);
    80002cd4:	fe843783          	ld	a5,-24(s0)
    80002cd8:	853e                	mv	a0,a5
    80002cda:	ffffe097          	auipc	ra,0xffffe
    80002cde:	64e080e7          	jalr	1614(ra) # 80001328 <release>
}
    80002ce2:	0001                	nop
    80002ce4:	60e2                	ld	ra,24(sp)
    80002ce6:	6442                	ld	s0,16(sp)
    80002ce8:	6105                	addi	sp,sp,32
    80002cea:	8082                	ret

0000000080002cec <growproc>:

// Grow or shrink user memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
    80002cec:	7179                	addi	sp,sp,-48
    80002cee:	f406                	sd	ra,40(sp)
    80002cf0:	f022                	sd	s0,32(sp)
    80002cf2:	1800                	addi	s0,sp,48
    80002cf4:	87aa                	mv	a5,a0
    80002cf6:	fcf42e23          	sw	a5,-36(s0)
  uint64 sz;
  struct proc *p = myproc();
    80002cfa:	00000097          	auipc	ra,0x0
    80002cfe:	bc2080e7          	jalr	-1086(ra) # 800028bc <myproc>
    80002d02:	fea43023          	sd	a0,-32(s0)

  sz = p->sz;
    80002d06:	fe043783          	ld	a5,-32(s0)
    80002d0a:	67bc                	ld	a5,72(a5)
    80002d0c:	fef43423          	sd	a5,-24(s0)
  if(n > 0){
    80002d10:	fdc42783          	lw	a5,-36(s0)
    80002d14:	2781                	sext.w	a5,a5
    80002d16:	02f05963          	blez	a5,80002d48 <growproc+0x5c>
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80002d1a:	fe043783          	ld	a5,-32(s0)
    80002d1e:	6ba8                	ld	a0,80(a5)
    80002d20:	fdc42703          	lw	a4,-36(s0)
    80002d24:	fe843783          	ld	a5,-24(s0)
    80002d28:	97ba                	add	a5,a5,a4
    80002d2a:	4691                	li	a3,4
    80002d2c:	863e                	mv	a2,a5
    80002d2e:	fe843583          	ld	a1,-24(s0)
    80002d32:	fffff097          	auipc	ra,0xfffff
    80002d36:	25c080e7          	jalr	604(ra) # 80001f8e <uvmalloc>
    80002d3a:	fea43423          	sd	a0,-24(s0)
    80002d3e:	fe843783          	ld	a5,-24(s0)
    80002d42:	eb95                	bnez	a5,80002d76 <growproc+0x8a>
      return -1;
    80002d44:	57fd                	li	a5,-1
    80002d46:	a835                	j	80002d82 <growproc+0x96>
    }
  } else if(n < 0){
    80002d48:	fdc42783          	lw	a5,-36(s0)
    80002d4c:	2781                	sext.w	a5,a5
    80002d4e:	0207d463          	bgez	a5,80002d76 <growproc+0x8a>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80002d52:	fe043783          	ld	a5,-32(s0)
    80002d56:	6bb4                	ld	a3,80(a5)
    80002d58:	fdc42703          	lw	a4,-36(s0)
    80002d5c:	fe843783          	ld	a5,-24(s0)
    80002d60:	97ba                	add	a5,a5,a4
    80002d62:	863e                	mv	a2,a5
    80002d64:	fe843583          	ld	a1,-24(s0)
    80002d68:	8536                	mv	a0,a3
    80002d6a:	fffff097          	auipc	ra,0xfffff
    80002d6e:	316080e7          	jalr	790(ra) # 80002080 <uvmdealloc>
    80002d72:	fea43423          	sd	a0,-24(s0)
  }
  p->sz = sz;
    80002d76:	fe043783          	ld	a5,-32(s0)
    80002d7a:	fe843703          	ld	a4,-24(s0)
    80002d7e:	e7b8                	sd	a4,72(a5)
  return 0;
    80002d80:	4781                	li	a5,0
}
    80002d82:	853e                	mv	a0,a5
    80002d84:	70a2                	ld	ra,40(sp)
    80002d86:	7402                	ld	s0,32(sp)
    80002d88:	6145                	addi	sp,sp,48
    80002d8a:	8082                	ret

0000000080002d8c <fork>:

// Create a new process, copying the parent.
// Sets up child kernel stack to return as if from fork() system call.
int
fork(void)
{
    80002d8c:	7179                	addi	sp,sp,-48
    80002d8e:	f406                	sd	ra,40(sp)
    80002d90:	f022                	sd	s0,32(sp)
    80002d92:	1800                	addi	s0,sp,48
  int i, pid;
  struct proc *np;
  struct proc *p = myproc();
    80002d94:	00000097          	auipc	ra,0x0
    80002d98:	b28080e7          	jalr	-1240(ra) # 800028bc <myproc>
    80002d9c:	fea43023          	sd	a0,-32(s0)

  // Allocate process.
  if((np = allocproc()) == 0){
    80002da0:	00000097          	auipc	ra,0x0
    80002da4:	bb6080e7          	jalr	-1098(ra) # 80002956 <allocproc>
    80002da8:	fca43c23          	sd	a0,-40(s0)
    80002dac:	fd843783          	ld	a5,-40(s0)
    80002db0:	e399                	bnez	a5,80002db6 <fork+0x2a>
    return -1;
    80002db2:	57fd                	li	a5,-1
    80002db4:	aab5                	j	80002f30 <fork+0x1a4>
  }

  // Copy user memory from parent to child.
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80002db6:	fe043783          	ld	a5,-32(s0)
    80002dba:	6bb8                	ld	a4,80(a5)
    80002dbc:	fd843783          	ld	a5,-40(s0)
    80002dc0:	6bb4                	ld	a3,80(a5)
    80002dc2:	fe043783          	ld	a5,-32(s0)
    80002dc6:	67bc                	ld	a5,72(a5)
    80002dc8:	863e                	mv	a2,a5
    80002dca:	85b6                	mv	a1,a3
    80002dcc:	853a                	mv	a0,a4
    80002dce:	fffff097          	auipc	ra,0xfffff
    80002dd2:	442080e7          	jalr	1090(ra) # 80002210 <uvmcopy>
    80002dd6:	87aa                	mv	a5,a0
    80002dd8:	0207d163          	bgez	a5,80002dfa <fork+0x6e>
    freeproc(np);
    80002ddc:	fd843503          	ld	a0,-40(s0)
    80002de0:	00000097          	auipc	ra,0x0
    80002de4:	ca0080e7          	jalr	-864(ra) # 80002a80 <freeproc>
    release(&np->lock);
    80002de8:	fd843783          	ld	a5,-40(s0)
    80002dec:	853e                	mv	a0,a5
    80002dee:	ffffe097          	auipc	ra,0xffffe
    80002df2:	53a080e7          	jalr	1338(ra) # 80001328 <release>
    return -1;
    80002df6:	57fd                	li	a5,-1
    80002df8:	aa25                	j	80002f30 <fork+0x1a4>
  }
  np->sz = p->sz;
    80002dfa:	fe043783          	ld	a5,-32(s0)
    80002dfe:	67b8                	ld	a4,72(a5)
    80002e00:	fd843783          	ld	a5,-40(s0)
    80002e04:	e7b8                	sd	a4,72(a5)

  // copy saved user registers.
  *(np->trapframe) = *(p->trapframe);
    80002e06:	fe043783          	ld	a5,-32(s0)
    80002e0a:	6fb8                	ld	a4,88(a5)
    80002e0c:	fd843783          	ld	a5,-40(s0)
    80002e10:	6fbc                	ld	a5,88(a5)
    80002e12:	86be                	mv	a3,a5
    80002e14:	12000793          	li	a5,288
    80002e18:	863e                	mv	a2,a5
    80002e1a:	85ba                	mv	a1,a4
    80002e1c:	8536                	mv	a0,a3
    80002e1e:	fffff097          	auipc	ra,0xfffff
    80002e22:	846080e7          	jalr	-1978(ra) # 80001664 <memcpy>

  // Cause fork to return 0 in the child.
  np->trapframe->a0 = 0;
    80002e26:	fd843783          	ld	a5,-40(s0)
    80002e2a:	6fbc                	ld	a5,88(a5)
    80002e2c:	0607b823          	sd	zero,112(a5)

  // increment reference counts on open file descriptors.
  for(i = 0; i < NOFILE; i++)
    80002e30:	fe042623          	sw	zero,-20(s0)
    80002e34:	a0a9                	j	80002e7e <fork+0xf2>
    if(p->ofile[i])
    80002e36:	fe043703          	ld	a4,-32(s0)
    80002e3a:	fec42783          	lw	a5,-20(s0)
    80002e3e:	07e9                	addi	a5,a5,26
    80002e40:	078e                	slli	a5,a5,0x3
    80002e42:	97ba                	add	a5,a5,a4
    80002e44:	639c                	ld	a5,0(a5)
    80002e46:	c79d                	beqz	a5,80002e74 <fork+0xe8>
      np->ofile[i] = filedup(p->ofile[i]);
    80002e48:	fe043703          	ld	a4,-32(s0)
    80002e4c:	fec42783          	lw	a5,-20(s0)
    80002e50:	07e9                	addi	a5,a5,26
    80002e52:	078e                	slli	a5,a5,0x3
    80002e54:	97ba                	add	a5,a5,a4
    80002e56:	639c                	ld	a5,0(a5)
    80002e58:	853e                	mv	a0,a5
    80002e5a:	00004097          	auipc	ra,0x4
    80002e5e:	95a080e7          	jalr	-1702(ra) # 800067b4 <filedup>
    80002e62:	86aa                	mv	a3,a0
    80002e64:	fd843703          	ld	a4,-40(s0)
    80002e68:	fec42783          	lw	a5,-20(s0)
    80002e6c:	07e9                	addi	a5,a5,26
    80002e6e:	078e                	slli	a5,a5,0x3
    80002e70:	97ba                	add	a5,a5,a4
    80002e72:	e394                	sd	a3,0(a5)
  for(i = 0; i < NOFILE; i++)
    80002e74:	fec42783          	lw	a5,-20(s0)
    80002e78:	2785                	addiw	a5,a5,1
    80002e7a:	fef42623          	sw	a5,-20(s0)
    80002e7e:	fec42783          	lw	a5,-20(s0)
    80002e82:	0007871b          	sext.w	a4,a5
    80002e86:	47bd                	li	a5,15
    80002e88:	fae7d7e3          	bge	a5,a4,80002e36 <fork+0xaa>
  np->cwd = idup(p->cwd);
    80002e8c:	fe043783          	ld	a5,-32(s0)
    80002e90:	1507b783          	ld	a5,336(a5)
    80002e94:	853e                	mv	a0,a5
    80002e96:	00002097          	auipc	ra,0x2
    80002e9a:	23e080e7          	jalr	574(ra) # 800050d4 <idup>
    80002e9e:	872a                	mv	a4,a0
    80002ea0:	fd843783          	ld	a5,-40(s0)
    80002ea4:	14e7b823          	sd	a4,336(a5)

  safestrcpy(np->name, p->name, sizeof(p->name));
    80002ea8:	fd843783          	ld	a5,-40(s0)
    80002eac:	15878713          	addi	a4,a5,344
    80002eb0:	fe043783          	ld	a5,-32(s0)
    80002eb4:	15878793          	addi	a5,a5,344
    80002eb8:	4641                	li	a2,16
    80002eba:	85be                	mv	a1,a5
    80002ebc:	853a                	mv	a0,a4
    80002ebe:	fffff097          	auipc	ra,0xfffff
    80002ec2:	8f2080e7          	jalr	-1806(ra) # 800017b0 <safestrcpy>

  pid = np->pid;
    80002ec6:	fd843783          	ld	a5,-40(s0)
    80002eca:	5b9c                	lw	a5,48(a5)
    80002ecc:	fcf42a23          	sw	a5,-44(s0)

  release(&np->lock);
    80002ed0:	fd843783          	ld	a5,-40(s0)
    80002ed4:	853e                	mv	a0,a5
    80002ed6:	ffffe097          	auipc	ra,0xffffe
    80002eda:	452080e7          	jalr	1106(ra) # 80001328 <release>

  acquire(&wait_lock);
    80002ede:	00017517          	auipc	a0,0x17
    80002ee2:	a9250513          	addi	a0,a0,-1390 # 80019970 <wait_lock>
    80002ee6:	ffffe097          	auipc	ra,0xffffe
    80002eea:	3de080e7          	jalr	990(ra) # 800012c4 <acquire>
  np->parent = p;
    80002eee:	fd843783          	ld	a5,-40(s0)
    80002ef2:	fe043703          	ld	a4,-32(s0)
    80002ef6:	ff98                	sd	a4,56(a5)
  release(&wait_lock);
    80002ef8:	00017517          	auipc	a0,0x17
    80002efc:	a7850513          	addi	a0,a0,-1416 # 80019970 <wait_lock>
    80002f00:	ffffe097          	auipc	ra,0xffffe
    80002f04:	428080e7          	jalr	1064(ra) # 80001328 <release>

  acquire(&np->lock);
    80002f08:	fd843783          	ld	a5,-40(s0)
    80002f0c:	853e                	mv	a0,a5
    80002f0e:	ffffe097          	auipc	ra,0xffffe
    80002f12:	3b6080e7          	jalr	950(ra) # 800012c4 <acquire>
  np->state = RUNNABLE;
    80002f16:	fd843783          	ld	a5,-40(s0)
    80002f1a:	470d                	li	a4,3
    80002f1c:	cf98                	sw	a4,24(a5)
  release(&np->lock);
    80002f1e:	fd843783          	ld	a5,-40(s0)
    80002f22:	853e                	mv	a0,a5
    80002f24:	ffffe097          	auipc	ra,0xffffe
    80002f28:	404080e7          	jalr	1028(ra) # 80001328 <release>

  return pid;
    80002f2c:	fd442783          	lw	a5,-44(s0)
}
    80002f30:	853e                	mv	a0,a5
    80002f32:	70a2                	ld	ra,40(sp)
    80002f34:	7402                	ld	s0,32(sp)
    80002f36:	6145                	addi	sp,sp,48
    80002f38:	8082                	ret

0000000080002f3a <reparent>:

// Pass p's abandoned children to init.
// Caller must hold wait_lock.
void
reparent(struct proc *p)
{
    80002f3a:	7179                	addi	sp,sp,-48
    80002f3c:	f406                	sd	ra,40(sp)
    80002f3e:	f022                	sd	s0,32(sp)
    80002f40:	1800                	addi	s0,sp,48
    80002f42:	fca43c23          	sd	a0,-40(s0)
  struct proc *pp;

  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002f46:	00011797          	auipc	a5,0x11
    80002f4a:	01278793          	addi	a5,a5,18 # 80013f58 <proc>
    80002f4e:	fef43423          	sd	a5,-24(s0)
    80002f52:	a081                	j	80002f92 <reparent+0x58>
    if(pp->parent == p){
    80002f54:	fe843783          	ld	a5,-24(s0)
    80002f58:	7f9c                	ld	a5,56(a5)
    80002f5a:	fd843703          	ld	a4,-40(s0)
    80002f5e:	02f71463          	bne	a4,a5,80002f86 <reparent+0x4c>
      pp->parent = initproc;
    80002f62:	00009797          	auipc	a5,0x9
    80002f66:	97e78793          	addi	a5,a5,-1666 # 8000b8e0 <initproc>
    80002f6a:	6398                	ld	a4,0(a5)
    80002f6c:	fe843783          	ld	a5,-24(s0)
    80002f70:	ff98                	sd	a4,56(a5)
      wakeup(initproc);
    80002f72:	00009797          	auipc	a5,0x9
    80002f76:	96e78793          	addi	a5,a5,-1682 # 8000b8e0 <initproc>
    80002f7a:	639c                	ld	a5,0(a5)
    80002f7c:	853e                	mv	a0,a5
    80002f7e:	00000097          	auipc	ra,0x0
    80002f82:	574080e7          	jalr	1396(ra) # 800034f2 <wakeup>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002f86:	fe843783          	ld	a5,-24(s0)
    80002f8a:	16878793          	addi	a5,a5,360
    80002f8e:	fef43423          	sd	a5,-24(s0)
    80002f92:	fe843703          	ld	a4,-24(s0)
    80002f96:	00017797          	auipc	a5,0x17
    80002f9a:	9c278793          	addi	a5,a5,-1598 # 80019958 <pid_lock>
    80002f9e:	faf76be3          	bltu	a4,a5,80002f54 <reparent+0x1a>
    }
  }
}
    80002fa2:	0001                	nop
    80002fa4:	0001                	nop
    80002fa6:	70a2                	ld	ra,40(sp)
    80002fa8:	7402                	ld	s0,32(sp)
    80002faa:	6145                	addi	sp,sp,48
    80002fac:	8082                	ret

0000000080002fae <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait().
void
exit(int status)
{
    80002fae:	7139                	addi	sp,sp,-64
    80002fb0:	fc06                	sd	ra,56(sp)
    80002fb2:	f822                	sd	s0,48(sp)
    80002fb4:	0080                	addi	s0,sp,64
    80002fb6:	87aa                	mv	a5,a0
    80002fb8:	fcf42623          	sw	a5,-52(s0)
  struct proc *p = myproc();
    80002fbc:	00000097          	auipc	ra,0x0
    80002fc0:	900080e7          	jalr	-1792(ra) # 800028bc <myproc>
    80002fc4:	fea43023          	sd	a0,-32(s0)

  if(p == initproc)
    80002fc8:	00009797          	auipc	a5,0x9
    80002fcc:	91878793          	addi	a5,a5,-1768 # 8000b8e0 <initproc>
    80002fd0:	639c                	ld	a5,0(a5)
    80002fd2:	fe043703          	ld	a4,-32(s0)
    80002fd6:	00f71a63          	bne	a4,a5,80002fea <exit+0x3c>
    panic("init exiting");
    80002fda:	00008517          	auipc	a0,0x8
    80002fde:	22650513          	addi	a0,a0,550 # 8000b200 <etext+0x200>
    80002fe2:	ffffe097          	auipc	ra,0xffffe
    80002fe6:	cde080e7          	jalr	-802(ra) # 80000cc0 <panic>

  // Close all open files.
  for(int fd = 0; fd < NOFILE; fd++){
    80002fea:	fe042623          	sw	zero,-20(s0)
    80002fee:	a881                	j	8000303e <exit+0x90>
    if(p->ofile[fd]){
    80002ff0:	fe043703          	ld	a4,-32(s0)
    80002ff4:	fec42783          	lw	a5,-20(s0)
    80002ff8:	07e9                	addi	a5,a5,26
    80002ffa:	078e                	slli	a5,a5,0x3
    80002ffc:	97ba                	add	a5,a5,a4
    80002ffe:	639c                	ld	a5,0(a5)
    80003000:	cb95                	beqz	a5,80003034 <exit+0x86>
      struct file *f = p->ofile[fd];
    80003002:	fe043703          	ld	a4,-32(s0)
    80003006:	fec42783          	lw	a5,-20(s0)
    8000300a:	07e9                	addi	a5,a5,26
    8000300c:	078e                	slli	a5,a5,0x3
    8000300e:	97ba                	add	a5,a5,a4
    80003010:	639c                	ld	a5,0(a5)
    80003012:	fcf43c23          	sd	a5,-40(s0)
      fileclose(f);
    80003016:	fd843503          	ld	a0,-40(s0)
    8000301a:	00004097          	auipc	ra,0x4
    8000301e:	800080e7          	jalr	-2048(ra) # 8000681a <fileclose>
      p->ofile[fd] = 0;
    80003022:	fe043703          	ld	a4,-32(s0)
    80003026:	fec42783          	lw	a5,-20(s0)
    8000302a:	07e9                	addi	a5,a5,26
    8000302c:	078e                	slli	a5,a5,0x3
    8000302e:	97ba                	add	a5,a5,a4
    80003030:	0007b023          	sd	zero,0(a5)
  for(int fd = 0; fd < NOFILE; fd++){
    80003034:	fec42783          	lw	a5,-20(s0)
    80003038:	2785                	addiw	a5,a5,1
    8000303a:	fef42623          	sw	a5,-20(s0)
    8000303e:	fec42783          	lw	a5,-20(s0)
    80003042:	0007871b          	sext.w	a4,a5
    80003046:	47bd                	li	a5,15
    80003048:	fae7d4e3          	bge	a5,a4,80002ff0 <exit+0x42>
    }
  }

  begin_op();
    8000304c:	00003097          	auipc	ra,0x3
    80003050:	144080e7          	jalr	324(ra) # 80006190 <begin_op>
  iput(p->cwd);
    80003054:	fe043783          	ld	a5,-32(s0)
    80003058:	1507b783          	ld	a5,336(a5)
    8000305c:	853e                	mv	a0,a5
    8000305e:	00002097          	auipc	ra,0x2
    80003062:	250080e7          	jalr	592(ra) # 800052ae <iput>
  end_op();
    80003066:	00003097          	auipc	ra,0x3
    8000306a:	1ec080e7          	jalr	492(ra) # 80006252 <end_op>
  p->cwd = 0;
    8000306e:	fe043783          	ld	a5,-32(s0)
    80003072:	1407b823          	sd	zero,336(a5)

  acquire(&wait_lock);
    80003076:	00017517          	auipc	a0,0x17
    8000307a:	8fa50513          	addi	a0,a0,-1798 # 80019970 <wait_lock>
    8000307e:	ffffe097          	auipc	ra,0xffffe
    80003082:	246080e7          	jalr	582(ra) # 800012c4 <acquire>

  // Give any children to init.
  reparent(p);
    80003086:	fe043503          	ld	a0,-32(s0)
    8000308a:	00000097          	auipc	ra,0x0
    8000308e:	eb0080e7          	jalr	-336(ra) # 80002f3a <reparent>

  // Parent might be sleeping in wait().
  wakeup(p->parent);
    80003092:	fe043783          	ld	a5,-32(s0)
    80003096:	7f9c                	ld	a5,56(a5)
    80003098:	853e                	mv	a0,a5
    8000309a:	00000097          	auipc	ra,0x0
    8000309e:	458080e7          	jalr	1112(ra) # 800034f2 <wakeup>
  
  acquire(&p->lock);
    800030a2:	fe043783          	ld	a5,-32(s0)
    800030a6:	853e                	mv	a0,a5
    800030a8:	ffffe097          	auipc	ra,0xffffe
    800030ac:	21c080e7          	jalr	540(ra) # 800012c4 <acquire>

  p->xstate = status;
    800030b0:	fe043783          	ld	a5,-32(s0)
    800030b4:	fcc42703          	lw	a4,-52(s0)
    800030b8:	d7d8                	sw	a4,44(a5)
  p->state = ZOMBIE;
    800030ba:	fe043783          	ld	a5,-32(s0)
    800030be:	4715                	li	a4,5
    800030c0:	cf98                	sw	a4,24(a5)

  release(&wait_lock);
    800030c2:	00017517          	auipc	a0,0x17
    800030c6:	8ae50513          	addi	a0,a0,-1874 # 80019970 <wait_lock>
    800030ca:	ffffe097          	auipc	ra,0xffffe
    800030ce:	25e080e7          	jalr	606(ra) # 80001328 <release>

  // Jump into the scheduler, never to return.
  sched();
    800030d2:	00000097          	auipc	ra,0x0
    800030d6:	22c080e7          	jalr	556(ra) # 800032fe <sched>
  panic("zombie exit");
    800030da:	00008517          	auipc	a0,0x8
    800030de:	13650513          	addi	a0,a0,310 # 8000b210 <etext+0x210>
    800030e2:	ffffe097          	auipc	ra,0xffffe
    800030e6:	bde080e7          	jalr	-1058(ra) # 80000cc0 <panic>

00000000800030ea <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(uint64 addr)
{
    800030ea:	7139                	addi	sp,sp,-64
    800030ec:	fc06                	sd	ra,56(sp)
    800030ee:	f822                	sd	s0,48(sp)
    800030f0:	0080                	addi	s0,sp,64
    800030f2:	fca43423          	sd	a0,-56(s0)
  struct proc *pp;
  int havekids, pid;
  struct proc *p = myproc();
    800030f6:	fffff097          	auipc	ra,0xfffff
    800030fa:	7c6080e7          	jalr	1990(ra) # 800028bc <myproc>
    800030fe:	fca43c23          	sd	a0,-40(s0)

  acquire(&wait_lock);
    80003102:	00017517          	auipc	a0,0x17
    80003106:	86e50513          	addi	a0,a0,-1938 # 80019970 <wait_lock>
    8000310a:	ffffe097          	auipc	ra,0xffffe
    8000310e:	1ba080e7          	jalr	442(ra) # 800012c4 <acquire>

  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    80003112:	fe042223          	sw	zero,-28(s0)
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80003116:	00011797          	auipc	a5,0x11
    8000311a:	e4278793          	addi	a5,a5,-446 # 80013f58 <proc>
    8000311e:	fef43423          	sd	a5,-24(s0)
    80003122:	a8c9                	j	800031f4 <wait+0x10a>
      if(pp->parent == p){
    80003124:	fe843783          	ld	a5,-24(s0)
    80003128:	7f9c                	ld	a5,56(a5)
    8000312a:	fd843703          	ld	a4,-40(s0)
    8000312e:	0af71d63          	bne	a4,a5,800031e8 <wait+0xfe>
        // make sure the child isn't still in exit() or swtch().
        acquire(&pp->lock);
    80003132:	fe843783          	ld	a5,-24(s0)
    80003136:	853e                	mv	a0,a5
    80003138:	ffffe097          	auipc	ra,0xffffe
    8000313c:	18c080e7          	jalr	396(ra) # 800012c4 <acquire>

        havekids = 1;
    80003140:	4785                	li	a5,1
    80003142:	fef42223          	sw	a5,-28(s0)
        if(pp->state == ZOMBIE){
    80003146:	fe843783          	ld	a5,-24(s0)
    8000314a:	4f98                	lw	a4,24(a5)
    8000314c:	4795                	li	a5,5
    8000314e:	08f71663          	bne	a4,a5,800031da <wait+0xf0>
          // Found one.
          pid = pp->pid;
    80003152:	fe843783          	ld	a5,-24(s0)
    80003156:	5b9c                	lw	a5,48(a5)
    80003158:	fcf42a23          	sw	a5,-44(s0)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000315c:	fc843783          	ld	a5,-56(s0)
    80003160:	c7a9                	beqz	a5,800031aa <wait+0xc0>
    80003162:	fd843783          	ld	a5,-40(s0)
    80003166:	6bb8                	ld	a4,80(a5)
    80003168:	fe843783          	ld	a5,-24(s0)
    8000316c:	02c78793          	addi	a5,a5,44
    80003170:	4691                	li	a3,4
    80003172:	863e                	mv	a2,a5
    80003174:	fc843583          	ld	a1,-56(s0)
    80003178:	853a                	mv	a0,a4
    8000317a:	fffff097          	auipc	ra,0xfffff
    8000317e:	200080e7          	jalr	512(ra) # 8000237a <copyout>
    80003182:	87aa                	mv	a5,a0
    80003184:	0207d363          	bgez	a5,800031aa <wait+0xc0>
                                  sizeof(pp->xstate)) < 0) {
            release(&pp->lock);
    80003188:	fe843783          	ld	a5,-24(s0)
    8000318c:	853e                	mv	a0,a5
    8000318e:	ffffe097          	auipc	ra,0xffffe
    80003192:	19a080e7          	jalr	410(ra) # 80001328 <release>
            release(&wait_lock);
    80003196:	00016517          	auipc	a0,0x16
    8000319a:	7da50513          	addi	a0,a0,2010 # 80019970 <wait_lock>
    8000319e:	ffffe097          	auipc	ra,0xffffe
    800031a2:	18a080e7          	jalr	394(ra) # 80001328 <release>
            return -1;
    800031a6:	57fd                	li	a5,-1
    800031a8:	a879                	j	80003246 <wait+0x15c>
          }
          freeproc(pp);
    800031aa:	fe843503          	ld	a0,-24(s0)
    800031ae:	00000097          	auipc	ra,0x0
    800031b2:	8d2080e7          	jalr	-1838(ra) # 80002a80 <freeproc>
          release(&pp->lock);
    800031b6:	fe843783          	ld	a5,-24(s0)
    800031ba:	853e                	mv	a0,a5
    800031bc:	ffffe097          	auipc	ra,0xffffe
    800031c0:	16c080e7          	jalr	364(ra) # 80001328 <release>
          release(&wait_lock);
    800031c4:	00016517          	auipc	a0,0x16
    800031c8:	7ac50513          	addi	a0,a0,1964 # 80019970 <wait_lock>
    800031cc:	ffffe097          	auipc	ra,0xffffe
    800031d0:	15c080e7          	jalr	348(ra) # 80001328 <release>
          return pid;
    800031d4:	fd442783          	lw	a5,-44(s0)
    800031d8:	a0bd                	j	80003246 <wait+0x15c>
        }
        release(&pp->lock);
    800031da:	fe843783          	ld	a5,-24(s0)
    800031de:	853e                	mv	a0,a5
    800031e0:	ffffe097          	auipc	ra,0xffffe
    800031e4:	148080e7          	jalr	328(ra) # 80001328 <release>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800031e8:	fe843783          	ld	a5,-24(s0)
    800031ec:	16878793          	addi	a5,a5,360
    800031f0:	fef43423          	sd	a5,-24(s0)
    800031f4:	fe843703          	ld	a4,-24(s0)
    800031f8:	00016797          	auipc	a5,0x16
    800031fc:	76078793          	addi	a5,a5,1888 # 80019958 <pid_lock>
    80003200:	f2f762e3          	bltu	a4,a5,80003124 <wait+0x3a>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || killed(p)){
    80003204:	fe442783          	lw	a5,-28(s0)
    80003208:	2781                	sext.w	a5,a5
    8000320a:	cb89                	beqz	a5,8000321c <wait+0x132>
    8000320c:	fd843503          	ld	a0,-40(s0)
    80003210:	00000097          	auipc	ra,0x0
    80003214:	44c080e7          	jalr	1100(ra) # 8000365c <killed>
    80003218:	87aa                	mv	a5,a0
    8000321a:	cb99                	beqz	a5,80003230 <wait+0x146>
      release(&wait_lock);
    8000321c:	00016517          	auipc	a0,0x16
    80003220:	75450513          	addi	a0,a0,1876 # 80019970 <wait_lock>
    80003224:	ffffe097          	auipc	ra,0xffffe
    80003228:	104080e7          	jalr	260(ra) # 80001328 <release>
      return -1;
    8000322c:	57fd                	li	a5,-1
    8000322e:	a821                	j	80003246 <wait+0x15c>
    }
    
    // Wait for a child to exit.
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80003230:	00016597          	auipc	a1,0x16
    80003234:	74058593          	addi	a1,a1,1856 # 80019970 <wait_lock>
    80003238:	fd843503          	ld	a0,-40(s0)
    8000323c:	00000097          	auipc	ra,0x0
    80003240:	23a080e7          	jalr	570(ra) # 80003476 <sleep>
    havekids = 0;
    80003244:	b5f9                	j	80003112 <wait+0x28>
  }
}
    80003246:	853e                	mv	a0,a5
    80003248:	70e2                	ld	ra,56(sp)
    8000324a:	7442                	ld	s0,48(sp)
    8000324c:	6121                	addi	sp,sp,64
    8000324e:	8082                	ret

0000000080003250 <scheduler>:
//  - swtch to start running that process.
//  - eventually that process transfers control
//    via swtch back to the scheduler.
void
scheduler(void)
{
    80003250:	1101                	addi	sp,sp,-32
    80003252:	ec06                	sd	ra,24(sp)
    80003254:	e822                	sd	s0,16(sp)
    80003256:	1000                	addi	s0,sp,32
  struct proc *p;
  struct cpu *c = mycpu();
    80003258:	fffff097          	auipc	ra,0xfffff
    8000325c:	62a080e7          	jalr	1578(ra) # 80002882 <mycpu>
    80003260:	fea43023          	sd	a0,-32(s0)
  
  c->proc = 0;
    80003264:	fe043783          	ld	a5,-32(s0)
    80003268:	0007b023          	sd	zero,0(a5)
  for(;;){
    // Avoid deadlock by ensuring that devices can interrupt.
    intr_on();
    8000326c:	fffff097          	auipc	ra,0xfffff
    80003270:	3f4080e7          	jalr	1012(ra) # 80002660 <intr_on>

    for(p = proc; p < &proc[NPROC]; p++) {
    80003274:	00011797          	auipc	a5,0x11
    80003278:	ce478793          	addi	a5,a5,-796 # 80013f58 <proc>
    8000327c:	fef43423          	sd	a5,-24(s0)
    80003280:	a0b5                	j	800032ec <scheduler+0x9c>
      acquire(&p->lock);
    80003282:	fe843783          	ld	a5,-24(s0)
    80003286:	853e                	mv	a0,a5
    80003288:	ffffe097          	auipc	ra,0xffffe
    8000328c:	03c080e7          	jalr	60(ra) # 800012c4 <acquire>
      if(p->state == RUNNABLE) {
    80003290:	fe843783          	ld	a5,-24(s0)
    80003294:	4f98                	lw	a4,24(a5)
    80003296:	478d                	li	a5,3
    80003298:	02f71d63          	bne	a4,a5,800032d2 <scheduler+0x82>
        // Switch to chosen process.  It is the process's job
        // to release its lock and then reacquire it
        // before jumping back to us.
        p->state = RUNNING;
    8000329c:	fe843783          	ld	a5,-24(s0)
    800032a0:	4711                	li	a4,4
    800032a2:	cf98                	sw	a4,24(a5)
        c->proc = p;
    800032a4:	fe043783          	ld	a5,-32(s0)
    800032a8:	fe843703          	ld	a4,-24(s0)
    800032ac:	e398                	sd	a4,0(a5)
        swtch(&c->context, &p->context);
    800032ae:	fe043783          	ld	a5,-32(s0)
    800032b2:	00878713          	addi	a4,a5,8
    800032b6:	fe843783          	ld	a5,-24(s0)
    800032ba:	06078793          	addi	a5,a5,96
    800032be:	85be                	mv	a1,a5
    800032c0:	853a                	mv	a0,a4
    800032c2:	00000097          	auipc	ra,0x0
    800032c6:	614080e7          	jalr	1556(ra) # 800038d6 <swtch>

        // Process is done running for now.
        // It should have changed its p->state before coming back.
        c->proc = 0;
    800032ca:	fe043783          	ld	a5,-32(s0)
    800032ce:	0007b023          	sd	zero,0(a5)
      }
      release(&p->lock);
    800032d2:	fe843783          	ld	a5,-24(s0)
    800032d6:	853e                	mv	a0,a5
    800032d8:	ffffe097          	auipc	ra,0xffffe
    800032dc:	050080e7          	jalr	80(ra) # 80001328 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800032e0:	fe843783          	ld	a5,-24(s0)
    800032e4:	16878793          	addi	a5,a5,360
    800032e8:	fef43423          	sd	a5,-24(s0)
    800032ec:	fe843703          	ld	a4,-24(s0)
    800032f0:	00016797          	auipc	a5,0x16
    800032f4:	66878793          	addi	a5,a5,1640 # 80019958 <pid_lock>
    800032f8:	f8f765e3          	bltu	a4,a5,80003282 <scheduler+0x32>
    intr_on();
    800032fc:	bf85                	j	8000326c <scheduler+0x1c>

00000000800032fe <sched>:
// be proc->intena and proc->noff, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
    800032fe:	7179                	addi	sp,sp,-48
    80003300:	f406                	sd	ra,40(sp)
    80003302:	f022                	sd	s0,32(sp)
    80003304:	ec26                	sd	s1,24(sp)
    80003306:	1800                	addi	s0,sp,48
  int intena;
  struct proc *p = myproc();
    80003308:	fffff097          	auipc	ra,0xfffff
    8000330c:	5b4080e7          	jalr	1460(ra) # 800028bc <myproc>
    80003310:	fca43c23          	sd	a0,-40(s0)

  if(!holding(&p->lock))
    80003314:	fd843783          	ld	a5,-40(s0)
    80003318:	853e                	mv	a0,a5
    8000331a:	ffffe097          	auipc	ra,0xffffe
    8000331e:	064080e7          	jalr	100(ra) # 8000137e <holding>
    80003322:	87aa                	mv	a5,a0
    80003324:	eb89                	bnez	a5,80003336 <sched+0x38>
    panic("sched p->lock");
    80003326:	00008517          	auipc	a0,0x8
    8000332a:	efa50513          	addi	a0,a0,-262 # 8000b220 <etext+0x220>
    8000332e:	ffffe097          	auipc	ra,0xffffe
    80003332:	992080e7          	jalr	-1646(ra) # 80000cc0 <panic>
  if(mycpu()->noff != 1)
    80003336:	fffff097          	auipc	ra,0xfffff
    8000333a:	54c080e7          	jalr	1356(ra) # 80002882 <mycpu>
    8000333e:	87aa                	mv	a5,a0
    80003340:	5fb8                	lw	a4,120(a5)
    80003342:	4785                	li	a5,1
    80003344:	00f70a63          	beq	a4,a5,80003358 <sched+0x5a>
    panic("sched locks");
    80003348:	00008517          	auipc	a0,0x8
    8000334c:	ee850513          	addi	a0,a0,-280 # 8000b230 <etext+0x230>
    80003350:	ffffe097          	auipc	ra,0xffffe
    80003354:	970080e7          	jalr	-1680(ra) # 80000cc0 <panic>
  if(p->state == RUNNING)
    80003358:	fd843783          	ld	a5,-40(s0)
    8000335c:	4f98                	lw	a4,24(a5)
    8000335e:	4791                	li	a5,4
    80003360:	00f71a63          	bne	a4,a5,80003374 <sched+0x76>
    panic("sched running");
    80003364:	00008517          	auipc	a0,0x8
    80003368:	edc50513          	addi	a0,a0,-292 # 8000b240 <etext+0x240>
    8000336c:	ffffe097          	auipc	ra,0xffffe
    80003370:	954080e7          	jalr	-1708(ra) # 80000cc0 <panic>
  if(intr_get())
    80003374:	fffff097          	auipc	ra,0xfffff
    80003378:	316080e7          	jalr	790(ra) # 8000268a <intr_get>
    8000337c:	87aa                	mv	a5,a0
    8000337e:	cb89                	beqz	a5,80003390 <sched+0x92>
    panic("sched interruptible");
    80003380:	00008517          	auipc	a0,0x8
    80003384:	ed050513          	addi	a0,a0,-304 # 8000b250 <etext+0x250>
    80003388:	ffffe097          	auipc	ra,0xffffe
    8000338c:	938080e7          	jalr	-1736(ra) # 80000cc0 <panic>

  intena = mycpu()->intena;
    80003390:	fffff097          	auipc	ra,0xfffff
    80003394:	4f2080e7          	jalr	1266(ra) # 80002882 <mycpu>
    80003398:	87aa                	mv	a5,a0
    8000339a:	5ffc                	lw	a5,124(a5)
    8000339c:	fcf42a23          	sw	a5,-44(s0)
  swtch(&p->context, &mycpu()->context);
    800033a0:	fd843783          	ld	a5,-40(s0)
    800033a4:	06078493          	addi	s1,a5,96
    800033a8:	fffff097          	auipc	ra,0xfffff
    800033ac:	4da080e7          	jalr	1242(ra) # 80002882 <mycpu>
    800033b0:	87aa                	mv	a5,a0
    800033b2:	07a1                	addi	a5,a5,8
    800033b4:	85be                	mv	a1,a5
    800033b6:	8526                	mv	a0,s1
    800033b8:	00000097          	auipc	ra,0x0
    800033bc:	51e080e7          	jalr	1310(ra) # 800038d6 <swtch>
  mycpu()->intena = intena;
    800033c0:	fffff097          	auipc	ra,0xfffff
    800033c4:	4c2080e7          	jalr	1218(ra) # 80002882 <mycpu>
    800033c8:	872a                	mv	a4,a0
    800033ca:	fd442783          	lw	a5,-44(s0)
    800033ce:	df7c                	sw	a5,124(a4)
}
    800033d0:	0001                	nop
    800033d2:	70a2                	ld	ra,40(sp)
    800033d4:	7402                	ld	s0,32(sp)
    800033d6:	64e2                	ld	s1,24(sp)
    800033d8:	6145                	addi	sp,sp,48
    800033da:	8082                	ret

00000000800033dc <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
    800033dc:	1101                	addi	sp,sp,-32
    800033de:	ec06                	sd	ra,24(sp)
    800033e0:	e822                	sd	s0,16(sp)
    800033e2:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800033e4:	fffff097          	auipc	ra,0xfffff
    800033e8:	4d8080e7          	jalr	1240(ra) # 800028bc <myproc>
    800033ec:	fea43423          	sd	a0,-24(s0)
  acquire(&p->lock);
    800033f0:	fe843783          	ld	a5,-24(s0)
    800033f4:	853e                	mv	a0,a5
    800033f6:	ffffe097          	auipc	ra,0xffffe
    800033fa:	ece080e7          	jalr	-306(ra) # 800012c4 <acquire>
  p->state = RUNNABLE;
    800033fe:	fe843783          	ld	a5,-24(s0)
    80003402:	470d                	li	a4,3
    80003404:	cf98                	sw	a4,24(a5)
  sched();
    80003406:	00000097          	auipc	ra,0x0
    8000340a:	ef8080e7          	jalr	-264(ra) # 800032fe <sched>
  release(&p->lock);
    8000340e:	fe843783          	ld	a5,-24(s0)
    80003412:	853e                	mv	a0,a5
    80003414:	ffffe097          	auipc	ra,0xffffe
    80003418:	f14080e7          	jalr	-236(ra) # 80001328 <release>
}
    8000341c:	0001                	nop
    8000341e:	60e2                	ld	ra,24(sp)
    80003420:	6442                	ld	s0,16(sp)
    80003422:	6105                	addi	sp,sp,32
    80003424:	8082                	ret

0000000080003426 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80003426:	1141                	addi	sp,sp,-16
    80003428:	e406                	sd	ra,8(sp)
    8000342a:	e022                	sd	s0,0(sp)
    8000342c:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    8000342e:	fffff097          	auipc	ra,0xfffff
    80003432:	48e080e7          	jalr	1166(ra) # 800028bc <myproc>
    80003436:	87aa                	mv	a5,a0
    80003438:	853e                	mv	a0,a5
    8000343a:	ffffe097          	auipc	ra,0xffffe
    8000343e:	eee080e7          	jalr	-274(ra) # 80001328 <release>

  if (first) {
    80003442:	00008797          	auipc	a5,0x8
    80003446:	33278793          	addi	a5,a5,818 # 8000b774 <first.1>
    8000344a:	439c                	lw	a5,0(a5)
    8000344c:	cf81                	beqz	a5,80003464 <forkret+0x3e>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    first = 0;
    8000344e:	00008797          	auipc	a5,0x8
    80003452:	32678793          	addi	a5,a5,806 # 8000b774 <first.1>
    80003456:	0007a023          	sw	zero,0(a5)
    fsinit(ROOTDEV);
    8000345a:	4505                	li	a0,1
    8000345c:	00001097          	auipc	ra,0x1
    80003460:	56e080e7          	jalr	1390(ra) # 800049ca <fsinit>
  }

  usertrapret();
    80003464:	00001097          	auipc	ra,0x1
    80003468:	850080e7          	jalr	-1968(ra) # 80003cb4 <usertrapret>
}
    8000346c:	0001                	nop
    8000346e:	60a2                	ld	ra,8(sp)
    80003470:	6402                	ld	s0,0(sp)
    80003472:	0141                	addi	sp,sp,16
    80003474:	8082                	ret

0000000080003476 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80003476:	7179                	addi	sp,sp,-48
    80003478:	f406                	sd	ra,40(sp)
    8000347a:	f022                	sd	s0,32(sp)
    8000347c:	1800                	addi	s0,sp,48
    8000347e:	fca43c23          	sd	a0,-40(s0)
    80003482:	fcb43823          	sd	a1,-48(s0)
  struct proc *p = myproc();
    80003486:	fffff097          	auipc	ra,0xfffff
    8000348a:	436080e7          	jalr	1078(ra) # 800028bc <myproc>
    8000348e:	fea43423          	sd	a0,-24(s0)
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80003492:	fe843783          	ld	a5,-24(s0)
    80003496:	853e                	mv	a0,a5
    80003498:	ffffe097          	auipc	ra,0xffffe
    8000349c:	e2c080e7          	jalr	-468(ra) # 800012c4 <acquire>
  release(lk);
    800034a0:	fd043503          	ld	a0,-48(s0)
    800034a4:	ffffe097          	auipc	ra,0xffffe
    800034a8:	e84080e7          	jalr	-380(ra) # 80001328 <release>

  // Go to sleep.
  p->chan = chan;
    800034ac:	fe843783          	ld	a5,-24(s0)
    800034b0:	fd843703          	ld	a4,-40(s0)
    800034b4:	f398                	sd	a4,32(a5)
  p->state = SLEEPING;
    800034b6:	fe843783          	ld	a5,-24(s0)
    800034ba:	4709                	li	a4,2
    800034bc:	cf98                	sw	a4,24(a5)

  sched();
    800034be:	00000097          	auipc	ra,0x0
    800034c2:	e40080e7          	jalr	-448(ra) # 800032fe <sched>

  // Tidy up.
  p->chan = 0;
    800034c6:	fe843783          	ld	a5,-24(s0)
    800034ca:	0207b023          	sd	zero,32(a5)

  // Reacquire original lock.
  release(&p->lock);
    800034ce:	fe843783          	ld	a5,-24(s0)
    800034d2:	853e                	mv	a0,a5
    800034d4:	ffffe097          	auipc	ra,0xffffe
    800034d8:	e54080e7          	jalr	-428(ra) # 80001328 <release>
  acquire(lk);
    800034dc:	fd043503          	ld	a0,-48(s0)
    800034e0:	ffffe097          	auipc	ra,0xffffe
    800034e4:	de4080e7          	jalr	-540(ra) # 800012c4 <acquire>
}
    800034e8:	0001                	nop
    800034ea:	70a2                	ld	ra,40(sp)
    800034ec:	7402                	ld	s0,32(sp)
    800034ee:	6145                	addi	sp,sp,48
    800034f0:	8082                	ret

00000000800034f2 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800034f2:	7179                	addi	sp,sp,-48
    800034f4:	f406                	sd	ra,40(sp)
    800034f6:	f022                	sd	s0,32(sp)
    800034f8:	1800                	addi	s0,sp,48
    800034fa:	fca43c23          	sd	a0,-40(s0)
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800034fe:	00011797          	auipc	a5,0x11
    80003502:	a5a78793          	addi	a5,a5,-1446 # 80013f58 <proc>
    80003506:	fef43423          	sd	a5,-24(s0)
    8000350a:	a8b9                	j	80003568 <wakeup+0x76>
    if(p != myproc()){
    8000350c:	fffff097          	auipc	ra,0xfffff
    80003510:	3b0080e7          	jalr	944(ra) # 800028bc <myproc>
    80003514:	872a                	mv	a4,a0
    80003516:	fe843783          	ld	a5,-24(s0)
    8000351a:	04e78163          	beq	a5,a4,8000355c <wakeup+0x6a>
      acquire(&p->lock);
    8000351e:	fe843783          	ld	a5,-24(s0)
    80003522:	853e                	mv	a0,a5
    80003524:	ffffe097          	auipc	ra,0xffffe
    80003528:	da0080e7          	jalr	-608(ra) # 800012c4 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000352c:	fe843783          	ld	a5,-24(s0)
    80003530:	4f98                	lw	a4,24(a5)
    80003532:	4789                	li	a5,2
    80003534:	00f71d63          	bne	a4,a5,8000354e <wakeup+0x5c>
    80003538:	fe843783          	ld	a5,-24(s0)
    8000353c:	739c                	ld	a5,32(a5)
    8000353e:	fd843703          	ld	a4,-40(s0)
    80003542:	00f71663          	bne	a4,a5,8000354e <wakeup+0x5c>
        p->state = RUNNABLE;
    80003546:	fe843783          	ld	a5,-24(s0)
    8000354a:	470d                	li	a4,3
    8000354c:	cf98                	sw	a4,24(a5)
      }
      release(&p->lock);
    8000354e:	fe843783          	ld	a5,-24(s0)
    80003552:	853e                	mv	a0,a5
    80003554:	ffffe097          	auipc	ra,0xffffe
    80003558:	dd4080e7          	jalr	-556(ra) # 80001328 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000355c:	fe843783          	ld	a5,-24(s0)
    80003560:	16878793          	addi	a5,a5,360
    80003564:	fef43423          	sd	a5,-24(s0)
    80003568:	fe843703          	ld	a4,-24(s0)
    8000356c:	00016797          	auipc	a5,0x16
    80003570:	3ec78793          	addi	a5,a5,1004 # 80019958 <pid_lock>
    80003574:	f8f76ce3          	bltu	a4,a5,8000350c <wakeup+0x1a>
    }
  }
}
    80003578:	0001                	nop
    8000357a:	0001                	nop
    8000357c:	70a2                	ld	ra,40(sp)
    8000357e:	7402                	ld	s0,32(sp)
    80003580:	6145                	addi	sp,sp,48
    80003582:	8082                	ret

0000000080003584 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80003584:	7179                	addi	sp,sp,-48
    80003586:	f406                	sd	ra,40(sp)
    80003588:	f022                	sd	s0,32(sp)
    8000358a:	1800                	addi	s0,sp,48
    8000358c:	87aa                	mv	a5,a0
    8000358e:	fcf42e23          	sw	a5,-36(s0)
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80003592:	00011797          	auipc	a5,0x11
    80003596:	9c678793          	addi	a5,a5,-1594 # 80013f58 <proc>
    8000359a:	fef43423          	sd	a5,-24(s0)
    8000359e:	a0a5                	j	80003606 <kill+0x82>
    acquire(&p->lock);
    800035a0:	fe843783          	ld	a5,-24(s0)
    800035a4:	853e                	mv	a0,a5
    800035a6:	ffffe097          	auipc	ra,0xffffe
    800035aa:	d1e080e7          	jalr	-738(ra) # 800012c4 <acquire>
    if(p->pid == pid){
    800035ae:	fe843783          	ld	a5,-24(s0)
    800035b2:	5b9c                	lw	a5,48(a5)
    800035b4:	fdc42703          	lw	a4,-36(s0)
    800035b8:	2701                	sext.w	a4,a4
    800035ba:	02f71963          	bne	a4,a5,800035ec <kill+0x68>
      p->killed = 1;
    800035be:	fe843783          	ld	a5,-24(s0)
    800035c2:	4705                	li	a4,1
    800035c4:	d798                	sw	a4,40(a5)
      if(p->state == SLEEPING){
    800035c6:	fe843783          	ld	a5,-24(s0)
    800035ca:	4f98                	lw	a4,24(a5)
    800035cc:	4789                	li	a5,2
    800035ce:	00f71663          	bne	a4,a5,800035da <kill+0x56>
        // Wake process from sleep().
        p->state = RUNNABLE;
    800035d2:	fe843783          	ld	a5,-24(s0)
    800035d6:	470d                	li	a4,3
    800035d8:	cf98                	sw	a4,24(a5)
      }
      release(&p->lock);
    800035da:	fe843783          	ld	a5,-24(s0)
    800035de:	853e                	mv	a0,a5
    800035e0:	ffffe097          	auipc	ra,0xffffe
    800035e4:	d48080e7          	jalr	-696(ra) # 80001328 <release>
      return 0;
    800035e8:	4781                	li	a5,0
    800035ea:	a03d                	j	80003618 <kill+0x94>
    }
    release(&p->lock);
    800035ec:	fe843783          	ld	a5,-24(s0)
    800035f0:	853e                	mv	a0,a5
    800035f2:	ffffe097          	auipc	ra,0xffffe
    800035f6:	d36080e7          	jalr	-714(ra) # 80001328 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800035fa:	fe843783          	ld	a5,-24(s0)
    800035fe:	16878793          	addi	a5,a5,360
    80003602:	fef43423          	sd	a5,-24(s0)
    80003606:	fe843703          	ld	a4,-24(s0)
    8000360a:	00016797          	auipc	a5,0x16
    8000360e:	34e78793          	addi	a5,a5,846 # 80019958 <pid_lock>
    80003612:	f8f767e3          	bltu	a4,a5,800035a0 <kill+0x1c>
  }
  return -1;
    80003616:	57fd                	li	a5,-1
}
    80003618:	853e                	mv	a0,a5
    8000361a:	70a2                	ld	ra,40(sp)
    8000361c:	7402                	ld	s0,32(sp)
    8000361e:	6145                	addi	sp,sp,48
    80003620:	8082                	ret

0000000080003622 <setkilled>:

void
setkilled(struct proc *p)
{
    80003622:	1101                	addi	sp,sp,-32
    80003624:	ec06                	sd	ra,24(sp)
    80003626:	e822                	sd	s0,16(sp)
    80003628:	1000                	addi	s0,sp,32
    8000362a:	fea43423          	sd	a0,-24(s0)
  acquire(&p->lock);
    8000362e:	fe843783          	ld	a5,-24(s0)
    80003632:	853e                	mv	a0,a5
    80003634:	ffffe097          	auipc	ra,0xffffe
    80003638:	c90080e7          	jalr	-880(ra) # 800012c4 <acquire>
  p->killed = 1;
    8000363c:	fe843783          	ld	a5,-24(s0)
    80003640:	4705                	li	a4,1
    80003642:	d798                	sw	a4,40(a5)
  release(&p->lock);
    80003644:	fe843783          	ld	a5,-24(s0)
    80003648:	853e                	mv	a0,a5
    8000364a:	ffffe097          	auipc	ra,0xffffe
    8000364e:	cde080e7          	jalr	-802(ra) # 80001328 <release>
}
    80003652:	0001                	nop
    80003654:	60e2                	ld	ra,24(sp)
    80003656:	6442                	ld	s0,16(sp)
    80003658:	6105                	addi	sp,sp,32
    8000365a:	8082                	ret

000000008000365c <killed>:

int
killed(struct proc *p)
{
    8000365c:	7179                	addi	sp,sp,-48
    8000365e:	f406                	sd	ra,40(sp)
    80003660:	f022                	sd	s0,32(sp)
    80003662:	1800                	addi	s0,sp,48
    80003664:	fca43c23          	sd	a0,-40(s0)
  int k;
  
  acquire(&p->lock);
    80003668:	fd843783          	ld	a5,-40(s0)
    8000366c:	853e                	mv	a0,a5
    8000366e:	ffffe097          	auipc	ra,0xffffe
    80003672:	c56080e7          	jalr	-938(ra) # 800012c4 <acquire>
  k = p->killed;
    80003676:	fd843783          	ld	a5,-40(s0)
    8000367a:	579c                	lw	a5,40(a5)
    8000367c:	fef42623          	sw	a5,-20(s0)
  release(&p->lock);
    80003680:	fd843783          	ld	a5,-40(s0)
    80003684:	853e                	mv	a0,a5
    80003686:	ffffe097          	auipc	ra,0xffffe
    8000368a:	ca2080e7          	jalr	-862(ra) # 80001328 <release>
  return k;
    8000368e:	fec42783          	lw	a5,-20(s0)
}
    80003692:	853e                	mv	a0,a5
    80003694:	70a2                	ld	ra,40(sp)
    80003696:	7402                	ld	s0,32(sp)
    80003698:	6145                	addi	sp,sp,48
    8000369a:	8082                	ret

000000008000369c <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000369c:	7139                	addi	sp,sp,-64
    8000369e:	fc06                	sd	ra,56(sp)
    800036a0:	f822                	sd	s0,48(sp)
    800036a2:	0080                	addi	s0,sp,64
    800036a4:	87aa                	mv	a5,a0
    800036a6:	fcb43823          	sd	a1,-48(s0)
    800036aa:	fcc43423          	sd	a2,-56(s0)
    800036ae:	fcd43023          	sd	a3,-64(s0)
    800036b2:	fcf42e23          	sw	a5,-36(s0)
  struct proc *p = myproc();
    800036b6:	fffff097          	auipc	ra,0xfffff
    800036ba:	206080e7          	jalr	518(ra) # 800028bc <myproc>
    800036be:	fea43423          	sd	a0,-24(s0)
  if(user_dst){
    800036c2:	fdc42783          	lw	a5,-36(s0)
    800036c6:	2781                	sext.w	a5,a5
    800036c8:	c38d                	beqz	a5,800036ea <either_copyout+0x4e>
    return copyout(p->pagetable, dst, src, len);
    800036ca:	fe843783          	ld	a5,-24(s0)
    800036ce:	6bbc                	ld	a5,80(a5)
    800036d0:	fc043683          	ld	a3,-64(s0)
    800036d4:	fc843603          	ld	a2,-56(s0)
    800036d8:	fd043583          	ld	a1,-48(s0)
    800036dc:	853e                	mv	a0,a5
    800036de:	fffff097          	auipc	ra,0xfffff
    800036e2:	c9c080e7          	jalr	-868(ra) # 8000237a <copyout>
    800036e6:	87aa                	mv	a5,a0
    800036e8:	a839                	j	80003706 <either_copyout+0x6a>
  } else {
    memmove((char *)dst, src, len);
    800036ea:	fd043783          	ld	a5,-48(s0)
    800036ee:	fc043703          	ld	a4,-64(s0)
    800036f2:	2701                	sext.w	a4,a4
    800036f4:	863a                	mv	a2,a4
    800036f6:	fc843583          	ld	a1,-56(s0)
    800036fa:	853e                	mv	a0,a5
    800036fc:	ffffe097          	auipc	ra,0xffffe
    80003700:	e88080e7          	jalr	-376(ra) # 80001584 <memmove>
    return 0;
    80003704:	4781                	li	a5,0
  }
}
    80003706:	853e                	mv	a0,a5
    80003708:	70e2                	ld	ra,56(sp)
    8000370a:	7442                	ld	s0,48(sp)
    8000370c:	6121                	addi	sp,sp,64
    8000370e:	8082                	ret

0000000080003710 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80003710:	7139                	addi	sp,sp,-64
    80003712:	fc06                	sd	ra,56(sp)
    80003714:	f822                	sd	s0,48(sp)
    80003716:	0080                	addi	s0,sp,64
    80003718:	fca43c23          	sd	a0,-40(s0)
    8000371c:	87ae                	mv	a5,a1
    8000371e:	fcc43423          	sd	a2,-56(s0)
    80003722:	fcd43023          	sd	a3,-64(s0)
    80003726:	fcf42a23          	sw	a5,-44(s0)
  struct proc *p = myproc();
    8000372a:	fffff097          	auipc	ra,0xfffff
    8000372e:	192080e7          	jalr	402(ra) # 800028bc <myproc>
    80003732:	fea43423          	sd	a0,-24(s0)
  if(user_src){
    80003736:	fd442783          	lw	a5,-44(s0)
    8000373a:	2781                	sext.w	a5,a5
    8000373c:	c38d                	beqz	a5,8000375e <either_copyin+0x4e>
    return copyin(p->pagetable, dst, src, len);
    8000373e:	fe843783          	ld	a5,-24(s0)
    80003742:	6bbc                	ld	a5,80(a5)
    80003744:	fc043683          	ld	a3,-64(s0)
    80003748:	fc843603          	ld	a2,-56(s0)
    8000374c:	fd843583          	ld	a1,-40(s0)
    80003750:	853e                	mv	a0,a5
    80003752:	fffff097          	auipc	ra,0xfffff
    80003756:	cf6080e7          	jalr	-778(ra) # 80002448 <copyin>
    8000375a:	87aa                	mv	a5,a0
    8000375c:	a839                	j	8000377a <either_copyin+0x6a>
  } else {
    memmove(dst, (char*)src, len);
    8000375e:	fc843783          	ld	a5,-56(s0)
    80003762:	fc043703          	ld	a4,-64(s0)
    80003766:	2701                	sext.w	a4,a4
    80003768:	863a                	mv	a2,a4
    8000376a:	85be                	mv	a1,a5
    8000376c:	fd843503          	ld	a0,-40(s0)
    80003770:	ffffe097          	auipc	ra,0xffffe
    80003774:	e14080e7          	jalr	-492(ra) # 80001584 <memmove>
    return 0;
    80003778:	4781                	li	a5,0
  }
}
    8000377a:	853e                	mv	a0,a5
    8000377c:	70e2                	ld	ra,56(sp)
    8000377e:	7442                	ld	s0,48(sp)
    80003780:	6121                	addi	sp,sp,64
    80003782:	8082                	ret

0000000080003784 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80003784:	1101                	addi	sp,sp,-32
    80003786:	ec06                	sd	ra,24(sp)
    80003788:	e822                	sd	s0,16(sp)
    8000378a:	1000                	addi	s0,sp,32
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000378c:	00008517          	auipc	a0,0x8
    80003790:	adc50513          	addi	a0,a0,-1316 # 8000b268 <etext+0x268>
    80003794:	ffffd097          	auipc	ra,0xffffd
    80003798:	2d6080e7          	jalr	726(ra) # 80000a6a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000379c:	00010797          	auipc	a5,0x10
    800037a0:	7bc78793          	addi	a5,a5,1980 # 80013f58 <proc>
    800037a4:	fef43423          	sd	a5,-24(s0)
    800037a8:	a045                	j	80003848 <procdump+0xc4>
    if(p->state == UNUSED)
    800037aa:	fe843783          	ld	a5,-24(s0)
    800037ae:	4f9c                	lw	a5,24(a5)
    800037b0:	c7c9                	beqz	a5,8000383a <procdump+0xb6>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800037b2:	fe843783          	ld	a5,-24(s0)
    800037b6:	4f98                	lw	a4,24(a5)
    800037b8:	4795                	li	a5,5
    800037ba:	02e7ee63          	bltu	a5,a4,800037f6 <procdump+0x72>
    800037be:	fe843783          	ld	a5,-24(s0)
    800037c2:	4f9c                	lw	a5,24(a5)
    800037c4:	00008717          	auipc	a4,0x8
    800037c8:	00c70713          	addi	a4,a4,12 # 8000b7d0 <states.0>
    800037cc:	1782                	slli	a5,a5,0x20
    800037ce:	9381                	srli	a5,a5,0x20
    800037d0:	078e                	slli	a5,a5,0x3
    800037d2:	97ba                	add	a5,a5,a4
    800037d4:	639c                	ld	a5,0(a5)
    800037d6:	c385                	beqz	a5,800037f6 <procdump+0x72>
      state = states[p->state];
    800037d8:	fe843783          	ld	a5,-24(s0)
    800037dc:	4f9c                	lw	a5,24(a5)
    800037de:	00008717          	auipc	a4,0x8
    800037e2:	ff270713          	addi	a4,a4,-14 # 8000b7d0 <states.0>
    800037e6:	1782                	slli	a5,a5,0x20
    800037e8:	9381                	srli	a5,a5,0x20
    800037ea:	078e                	slli	a5,a5,0x3
    800037ec:	97ba                	add	a5,a5,a4
    800037ee:	639c                	ld	a5,0(a5)
    800037f0:	fef43023          	sd	a5,-32(s0)
    800037f4:	a039                	j	80003802 <procdump+0x7e>
    else
      state = "???";
    800037f6:	00008797          	auipc	a5,0x8
    800037fa:	a7a78793          	addi	a5,a5,-1414 # 8000b270 <etext+0x270>
    800037fe:	fef43023          	sd	a5,-32(s0)
    printf("%d %s %s", p->pid, state, p->name);
    80003802:	fe843783          	ld	a5,-24(s0)
    80003806:	5b98                	lw	a4,48(a5)
    80003808:	fe843783          	ld	a5,-24(s0)
    8000380c:	15878793          	addi	a5,a5,344
    80003810:	86be                	mv	a3,a5
    80003812:	fe043603          	ld	a2,-32(s0)
    80003816:	85ba                	mv	a1,a4
    80003818:	00008517          	auipc	a0,0x8
    8000381c:	a6050513          	addi	a0,a0,-1440 # 8000b278 <etext+0x278>
    80003820:	ffffd097          	auipc	ra,0xffffd
    80003824:	24a080e7          	jalr	586(ra) # 80000a6a <printf>
    printf("\n");
    80003828:	00008517          	auipc	a0,0x8
    8000382c:	a4050513          	addi	a0,a0,-1472 # 8000b268 <etext+0x268>
    80003830:	ffffd097          	auipc	ra,0xffffd
    80003834:	23a080e7          	jalr	570(ra) # 80000a6a <printf>
    80003838:	a011                	j	8000383c <procdump+0xb8>
      continue;
    8000383a:	0001                	nop
  for(p = proc; p < &proc[NPROC]; p++){
    8000383c:	fe843783          	ld	a5,-24(s0)
    80003840:	16878793          	addi	a5,a5,360
    80003844:	fef43423          	sd	a5,-24(s0)
    80003848:	fe843703          	ld	a4,-24(s0)
    8000384c:	00016797          	auipc	a5,0x16
    80003850:	10c78793          	addi	a5,a5,268 # 80019958 <pid_lock>
    80003854:	f4f76be3          	bltu	a4,a5,800037aa <procdump+0x26>
  }
}
    80003858:	0001                	nop
    8000385a:	0001                	nop
    8000385c:	60e2                	ld	ra,24(sp)
    8000385e:	6442                	ld	s0,16(sp)
    80003860:	6105                	addi	sp,sp,32
    80003862:	8082                	ret

0000000080003864 <sys_ps>:

int
sys_ps(void)
{
    80003864:	1101                	addi	sp,sp,-32
    80003866:	ec06                	sd	ra,24(sp)
    80003868:	e822                	sd	s0,16(sp)
    8000386a:	1000                	addi	s0,sp,32
  struct proc *p;
  for(p = proc; p < &proc[NPROC]; p++) {
    8000386c:	00010797          	auipc	a5,0x10
    80003870:	6ec78793          	addi	a5,a5,1772 # 80013f58 <proc>
    80003874:	fef43423          	sd	a5,-24(s0)
    80003878:	a089                	j	800038ba <sys_ps+0x56>
    if(p->state == UNUSED)
    8000387a:	fe843783          	ld	a5,-24(s0)
    8000387e:	4f9c                	lw	a5,24(a5)
    80003880:	c795                	beqz	a5,800038ac <sys_ps+0x48>
      continue;
    printf("%s (%d): %d\n", p->name, p->pid, p->state);
    80003882:	fe843783          	ld	a5,-24(s0)
    80003886:	15878713          	addi	a4,a5,344
    8000388a:	fe843783          	ld	a5,-24(s0)
    8000388e:	5b90                	lw	a2,48(a5)
    80003890:	fe843783          	ld	a5,-24(s0)
    80003894:	4f9c                	lw	a5,24(a5)
    80003896:	86be                	mv	a3,a5
    80003898:	85ba                	mv	a1,a4
    8000389a:	00008517          	auipc	a0,0x8
    8000389e:	9ee50513          	addi	a0,a0,-1554 # 8000b288 <etext+0x288>
    800038a2:	ffffd097          	auipc	ra,0xffffd
    800038a6:	1c8080e7          	jalr	456(ra) # 80000a6a <printf>
    800038aa:	a011                	j	800038ae <sys_ps+0x4a>
      continue;
    800038ac:	0001                	nop
  for(p = proc; p < &proc[NPROC]; p++) {
    800038ae:	fe843783          	ld	a5,-24(s0)
    800038b2:	16878793          	addi	a5,a5,360
    800038b6:	fef43423          	sd	a5,-24(s0)
    800038ba:	fe843703          	ld	a4,-24(s0)
    800038be:	00016797          	auipc	a5,0x16
    800038c2:	09a78793          	addi	a5,a5,154 # 80019958 <pid_lock>
    800038c6:	faf76ae3          	bltu	a4,a5,8000387a <sys_ps+0x16>
  }
  return 0;
    800038ca:	4781                	li	a5,0
}
    800038cc:	853e                	mv	a0,a5
    800038ce:	60e2                	ld	ra,24(sp)
    800038d0:	6442                	ld	s0,16(sp)
    800038d2:	6105                	addi	sp,sp,32
    800038d4:	8082                	ret

00000000800038d6 <swtch>:
    800038d6:	00153023          	sd	ra,0(a0)
    800038da:	00253423          	sd	sp,8(a0)
    800038de:	e900                	sd	s0,16(a0)
    800038e0:	ed04                	sd	s1,24(a0)
    800038e2:	03253023          	sd	s2,32(a0)
    800038e6:	03353423          	sd	s3,40(a0)
    800038ea:	03453823          	sd	s4,48(a0)
    800038ee:	03553c23          	sd	s5,56(a0)
    800038f2:	05653023          	sd	s6,64(a0)
    800038f6:	05753423          	sd	s7,72(a0)
    800038fa:	05853823          	sd	s8,80(a0)
    800038fe:	05953c23          	sd	s9,88(a0)
    80003902:	07a53023          	sd	s10,96(a0)
    80003906:	07b53423          	sd	s11,104(a0)
    8000390a:	0005b083          	ld	ra,0(a1)
    8000390e:	0085b103          	ld	sp,8(a1)
    80003912:	6980                	ld	s0,16(a1)
    80003914:	6d84                	ld	s1,24(a1)
    80003916:	0205b903          	ld	s2,32(a1)
    8000391a:	0285b983          	ld	s3,40(a1)
    8000391e:	0305ba03          	ld	s4,48(a1)
    80003922:	0385ba83          	ld	s5,56(a1)
    80003926:	0405bb03          	ld	s6,64(a1)
    8000392a:	0485bb83          	ld	s7,72(a1)
    8000392e:	0505bc03          	ld	s8,80(a1)
    80003932:	0585bc83          	ld	s9,88(a1)
    80003936:	0605bd03          	ld	s10,96(a1)
    8000393a:	0685bd83          	ld	s11,104(a1)
    8000393e:	8082                	ret

0000000080003940 <r_sstatus>:
{
    80003940:	1101                	addi	sp,sp,-32
    80003942:	ec06                	sd	ra,24(sp)
    80003944:	e822                	sd	s0,16(sp)
    80003946:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003948:	100027f3          	csrr	a5,sstatus
    8000394c:	fef43423          	sd	a5,-24(s0)
  return x;
    80003950:	fe843783          	ld	a5,-24(s0)
}
    80003954:	853e                	mv	a0,a5
    80003956:	60e2                	ld	ra,24(sp)
    80003958:	6442                	ld	s0,16(sp)
    8000395a:	6105                	addi	sp,sp,32
    8000395c:	8082                	ret

000000008000395e <w_sstatus>:
{
    8000395e:	1101                	addi	sp,sp,-32
    80003960:	ec06                	sd	ra,24(sp)
    80003962:	e822                	sd	s0,16(sp)
    80003964:	1000                	addi	s0,sp,32
    80003966:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000396a:	fe843783          	ld	a5,-24(s0)
    8000396e:	10079073          	csrw	sstatus,a5
}
    80003972:	0001                	nop
    80003974:	60e2                	ld	ra,24(sp)
    80003976:	6442                	ld	s0,16(sp)
    80003978:	6105                	addi	sp,sp,32
    8000397a:	8082                	ret

000000008000397c <r_sip>:
{
    8000397c:	1101                	addi	sp,sp,-32
    8000397e:	ec06                	sd	ra,24(sp)
    80003980:	e822                	sd	s0,16(sp)
    80003982:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sip" : "=r" (x) );
    80003984:	144027f3          	csrr	a5,sip
    80003988:	fef43423          	sd	a5,-24(s0)
  return x;
    8000398c:	fe843783          	ld	a5,-24(s0)
}
    80003990:	853e                	mv	a0,a5
    80003992:	60e2                	ld	ra,24(sp)
    80003994:	6442                	ld	s0,16(sp)
    80003996:	6105                	addi	sp,sp,32
    80003998:	8082                	ret

000000008000399a <w_sip>:
{
    8000399a:	1101                	addi	sp,sp,-32
    8000399c:	ec06                	sd	ra,24(sp)
    8000399e:	e822                	sd	s0,16(sp)
    800039a0:	1000                	addi	s0,sp,32
    800039a2:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw sip, %0" : : "r" (x));
    800039a6:	fe843783          	ld	a5,-24(s0)
    800039aa:	14479073          	csrw	sip,a5
}
    800039ae:	0001                	nop
    800039b0:	60e2                	ld	ra,24(sp)
    800039b2:	6442                	ld	s0,16(sp)
    800039b4:	6105                	addi	sp,sp,32
    800039b6:	8082                	ret

00000000800039b8 <w_sepc>:
{
    800039b8:	1101                	addi	sp,sp,-32
    800039ba:	ec06                	sd	ra,24(sp)
    800039bc:	e822                	sd	s0,16(sp)
    800039be:	1000                	addi	s0,sp,32
    800039c0:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800039c4:	fe843783          	ld	a5,-24(s0)
    800039c8:	14179073          	csrw	sepc,a5
}
    800039cc:	0001                	nop
    800039ce:	60e2                	ld	ra,24(sp)
    800039d0:	6442                	ld	s0,16(sp)
    800039d2:	6105                	addi	sp,sp,32
    800039d4:	8082                	ret

00000000800039d6 <r_sepc>:
{
    800039d6:	1101                	addi	sp,sp,-32
    800039d8:	ec06                	sd	ra,24(sp)
    800039da:	e822                	sd	s0,16(sp)
    800039dc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800039de:	141027f3          	csrr	a5,sepc
    800039e2:	fef43423          	sd	a5,-24(s0)
  return x;
    800039e6:	fe843783          	ld	a5,-24(s0)
}
    800039ea:	853e                	mv	a0,a5
    800039ec:	60e2                	ld	ra,24(sp)
    800039ee:	6442                	ld	s0,16(sp)
    800039f0:	6105                	addi	sp,sp,32
    800039f2:	8082                	ret

00000000800039f4 <w_stvec>:
{
    800039f4:	1101                	addi	sp,sp,-32
    800039f6:	ec06                	sd	ra,24(sp)
    800039f8:	e822                	sd	s0,16(sp)
    800039fa:	1000                	addi	s0,sp,32
    800039fc:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw stvec, %0" : : "r" (x));
    80003a00:	fe843783          	ld	a5,-24(s0)
    80003a04:	10579073          	csrw	stvec,a5
}
    80003a08:	0001                	nop
    80003a0a:	60e2                	ld	ra,24(sp)
    80003a0c:	6442                	ld	s0,16(sp)
    80003a0e:	6105                	addi	sp,sp,32
    80003a10:	8082                	ret

0000000080003a12 <r_satp>:
{
    80003a12:	1101                	addi	sp,sp,-32
    80003a14:	ec06                	sd	ra,24(sp)
    80003a16:	e822                	sd	s0,16(sp)
    80003a18:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, satp" : "=r" (x) );
    80003a1a:	180027f3          	csrr	a5,satp
    80003a1e:	fef43423          	sd	a5,-24(s0)
  return x;
    80003a22:	fe843783          	ld	a5,-24(s0)
}
    80003a26:	853e                	mv	a0,a5
    80003a28:	60e2                	ld	ra,24(sp)
    80003a2a:	6442                	ld	s0,16(sp)
    80003a2c:	6105                	addi	sp,sp,32
    80003a2e:	8082                	ret

0000000080003a30 <r_scause>:
{
    80003a30:	1101                	addi	sp,sp,-32
    80003a32:	ec06                	sd	ra,24(sp)
    80003a34:	e822                	sd	s0,16(sp)
    80003a36:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003a38:	142027f3          	csrr	a5,scause
    80003a3c:	fef43423          	sd	a5,-24(s0)
  return x;
    80003a40:	fe843783          	ld	a5,-24(s0)
}
    80003a44:	853e                	mv	a0,a5
    80003a46:	60e2                	ld	ra,24(sp)
    80003a48:	6442                	ld	s0,16(sp)
    80003a4a:	6105                	addi	sp,sp,32
    80003a4c:	8082                	ret

0000000080003a4e <r_stval>:
{
    80003a4e:	1101                	addi	sp,sp,-32
    80003a50:	ec06                	sd	ra,24(sp)
    80003a52:	e822                	sd	s0,16(sp)
    80003a54:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, stval" : "=r" (x) );
    80003a56:	143027f3          	csrr	a5,stval
    80003a5a:	fef43423          	sd	a5,-24(s0)
  return x;
    80003a5e:	fe843783          	ld	a5,-24(s0)
}
    80003a62:	853e                	mv	a0,a5
    80003a64:	60e2                	ld	ra,24(sp)
    80003a66:	6442                	ld	s0,16(sp)
    80003a68:	6105                	addi	sp,sp,32
    80003a6a:	8082                	ret

0000000080003a6c <intr_on>:
{
    80003a6c:	1141                	addi	sp,sp,-16
    80003a6e:	e406                	sd	ra,8(sp)
    80003a70:	e022                	sd	s0,0(sp)
    80003a72:	0800                	addi	s0,sp,16
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80003a74:	00000097          	auipc	ra,0x0
    80003a78:	ecc080e7          	jalr	-308(ra) # 80003940 <r_sstatus>
    80003a7c:	87aa                	mv	a5,a0
    80003a7e:	0027e793          	ori	a5,a5,2
    80003a82:	853e                	mv	a0,a5
    80003a84:	00000097          	auipc	ra,0x0
    80003a88:	eda080e7          	jalr	-294(ra) # 8000395e <w_sstatus>
}
    80003a8c:	0001                	nop
    80003a8e:	60a2                	ld	ra,8(sp)
    80003a90:	6402                	ld	s0,0(sp)
    80003a92:	0141                	addi	sp,sp,16
    80003a94:	8082                	ret

0000000080003a96 <intr_off>:
{
    80003a96:	1141                	addi	sp,sp,-16
    80003a98:	e406                	sd	ra,8(sp)
    80003a9a:	e022                	sd	s0,0(sp)
    80003a9c:	0800                	addi	s0,sp,16
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80003a9e:	00000097          	auipc	ra,0x0
    80003aa2:	ea2080e7          	jalr	-350(ra) # 80003940 <r_sstatus>
    80003aa6:	87aa                	mv	a5,a0
    80003aa8:	9bf5                	andi	a5,a5,-3
    80003aaa:	853e                	mv	a0,a5
    80003aac:	00000097          	auipc	ra,0x0
    80003ab0:	eb2080e7          	jalr	-334(ra) # 8000395e <w_sstatus>
}
    80003ab4:	0001                	nop
    80003ab6:	60a2                	ld	ra,8(sp)
    80003ab8:	6402                	ld	s0,0(sp)
    80003aba:	0141                	addi	sp,sp,16
    80003abc:	8082                	ret

0000000080003abe <intr_get>:
{
    80003abe:	1101                	addi	sp,sp,-32
    80003ac0:	ec06                	sd	ra,24(sp)
    80003ac2:	e822                	sd	s0,16(sp)
    80003ac4:	1000                	addi	s0,sp,32
  uint64 x = r_sstatus();
    80003ac6:	00000097          	auipc	ra,0x0
    80003aca:	e7a080e7          	jalr	-390(ra) # 80003940 <r_sstatus>
    80003ace:	fea43423          	sd	a0,-24(s0)
  return (x & SSTATUS_SIE) != 0;
    80003ad2:	fe843783          	ld	a5,-24(s0)
    80003ad6:	8b89                	andi	a5,a5,2
    80003ad8:	00f037b3          	snez	a5,a5
    80003adc:	0ff7f793          	zext.b	a5,a5
    80003ae0:	2781                	sext.w	a5,a5
}
    80003ae2:	853e                	mv	a0,a5
    80003ae4:	60e2                	ld	ra,24(sp)
    80003ae6:	6442                	ld	s0,16(sp)
    80003ae8:	6105                	addi	sp,sp,32
    80003aea:	8082                	ret

0000000080003aec <r_tp>:
{
    80003aec:	1101                	addi	sp,sp,-32
    80003aee:	ec06                	sd	ra,24(sp)
    80003af0:	e822                	sd	s0,16(sp)
    80003af2:	1000                	addi	s0,sp,32
  asm volatile("mv %0, tp" : "=r" (x) );
    80003af4:	8792                	mv	a5,tp
    80003af6:	fef43423          	sd	a5,-24(s0)
  return x;
    80003afa:	fe843783          	ld	a5,-24(s0)
}
    80003afe:	853e                	mv	a0,a5
    80003b00:	60e2                	ld	ra,24(sp)
    80003b02:	6442                	ld	s0,16(sp)
    80003b04:	6105                	addi	sp,sp,32
    80003b06:	8082                	ret

0000000080003b08 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80003b08:	1141                	addi	sp,sp,-16
    80003b0a:	e406                	sd	ra,8(sp)
    80003b0c:	e022                	sd	s0,0(sp)
    80003b0e:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80003b10:	00007597          	auipc	a1,0x7
    80003b14:	7c058593          	addi	a1,a1,1984 # 8000b2d0 <etext+0x2d0>
    80003b18:	00016517          	auipc	a0,0x16
    80003b1c:	e7050513          	addi	a0,a0,-400 # 80019988 <tickslock>
    80003b20:	ffffd097          	auipc	ra,0xffffd
    80003b24:	770080e7          	jalr	1904(ra) # 80001290 <initlock>
}
    80003b28:	0001                	nop
    80003b2a:	60a2                	ld	ra,8(sp)
    80003b2c:	6402                	ld	s0,0(sp)
    80003b2e:	0141                	addi	sp,sp,16
    80003b30:	8082                	ret

0000000080003b32 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80003b32:	1141                	addi	sp,sp,-16
    80003b34:	e406                	sd	ra,8(sp)
    80003b36:	e022                	sd	s0,0(sp)
    80003b38:	0800                	addi	s0,sp,16
  w_stvec((uint64)kernelvec);
    80003b3a:	00005797          	auipc	a5,0x5
    80003b3e:	cc678793          	addi	a5,a5,-826 # 80008800 <kernelvec>
    80003b42:	853e                	mv	a0,a5
    80003b44:	00000097          	auipc	ra,0x0
    80003b48:	eb0080e7          	jalr	-336(ra) # 800039f4 <w_stvec>
}
    80003b4c:	0001                	nop
    80003b4e:	60a2                	ld	ra,8(sp)
    80003b50:	6402                	ld	s0,0(sp)
    80003b52:	0141                	addi	sp,sp,16
    80003b54:	8082                	ret

0000000080003b56 <usertrap>:
// handle an interrupt, exception, or system call from user space.
// called from trampoline.S
//
void
usertrap(void)
{
    80003b56:	7179                	addi	sp,sp,-48
    80003b58:	f406                	sd	ra,40(sp)
    80003b5a:	f022                	sd	s0,32(sp)
    80003b5c:	ec26                	sd	s1,24(sp)
    80003b5e:	1800                	addi	s0,sp,48
  int which_dev = 0;
    80003b60:	fc042e23          	sw	zero,-36(s0)

  if((r_sstatus() & SSTATUS_SPP) != 0)
    80003b64:	00000097          	auipc	ra,0x0
    80003b68:	ddc080e7          	jalr	-548(ra) # 80003940 <r_sstatus>
    80003b6c:	87aa                	mv	a5,a0
    80003b6e:	1007f793          	andi	a5,a5,256
    80003b72:	cb89                	beqz	a5,80003b84 <usertrap+0x2e>
    panic("usertrap: not from user mode");
    80003b74:	00007517          	auipc	a0,0x7
    80003b78:	76450513          	addi	a0,a0,1892 # 8000b2d8 <etext+0x2d8>
    80003b7c:	ffffd097          	auipc	ra,0xffffd
    80003b80:	144080e7          	jalr	324(ra) # 80000cc0 <panic>

  // send interrupts and exceptions to kerneltrap(),
  // since we're now in the kernel.
  w_stvec((uint64)kernelvec);
    80003b84:	00005797          	auipc	a5,0x5
    80003b88:	c7c78793          	addi	a5,a5,-900 # 80008800 <kernelvec>
    80003b8c:	853e                	mv	a0,a5
    80003b8e:	00000097          	auipc	ra,0x0
    80003b92:	e66080e7          	jalr	-410(ra) # 800039f4 <w_stvec>

  struct proc *p = myproc();
    80003b96:	fffff097          	auipc	ra,0xfffff
    80003b9a:	d26080e7          	jalr	-730(ra) # 800028bc <myproc>
    80003b9e:	fca43823          	sd	a0,-48(s0)
  
  // save user program counter.
  p->trapframe->epc = r_sepc();
    80003ba2:	fd043783          	ld	a5,-48(s0)
    80003ba6:	6fa4                	ld	s1,88(a5)
    80003ba8:	00000097          	auipc	ra,0x0
    80003bac:	e2e080e7          	jalr	-466(ra) # 800039d6 <r_sepc>
    80003bb0:	87aa                	mv	a5,a0
    80003bb2:	ec9c                	sd	a5,24(s1)
  
  if(r_scause() == 8){
    80003bb4:	00000097          	auipc	ra,0x0
    80003bb8:	e7c080e7          	jalr	-388(ra) # 80003a30 <r_scause>
    80003bbc:	872a                	mv	a4,a0
    80003bbe:	47a1                	li	a5,8
    80003bc0:	04f71163          	bne	a4,a5,80003c02 <usertrap+0xac>
    // system call

    if(killed(p))
    80003bc4:	fd043503          	ld	a0,-48(s0)
    80003bc8:	00000097          	auipc	ra,0x0
    80003bcc:	a94080e7          	jalr	-1388(ra) # 8000365c <killed>
    80003bd0:	87aa                	mv	a5,a0
    80003bd2:	c791                	beqz	a5,80003bde <usertrap+0x88>
      exit(-1);
    80003bd4:	557d                	li	a0,-1
    80003bd6:	fffff097          	auipc	ra,0xfffff
    80003bda:	3d8080e7          	jalr	984(ra) # 80002fae <exit>

    // sepc points to the ecall instruction,
    // but we want to return to the next instruction.
    p->trapframe->epc += 4;
    80003bde:	fd043783          	ld	a5,-48(s0)
    80003be2:	6fbc                	ld	a5,88(a5)
    80003be4:	6f98                	ld	a4,24(a5)
    80003be6:	fd043783          	ld	a5,-48(s0)
    80003bea:	6fbc                	ld	a5,88(a5)
    80003bec:	0711                	addi	a4,a4,4
    80003bee:	ef98                	sd	a4,24(a5)

    // an interrupt will change sepc, scause, and sstatus,
    // so enable only now that we're done with those registers.
    intr_on();
    80003bf0:	00000097          	auipc	ra,0x0
    80003bf4:	e7c080e7          	jalr	-388(ra) # 80003a6c <intr_on>

    syscall();
    80003bf8:	00000097          	auipc	ra,0x0
    80003bfc:	66a080e7          	jalr	1642(ra) # 80004262 <syscall>
    80003c00:	a885                	j	80003c70 <usertrap+0x11a>
  } else if((which_dev = devintr()) != 0){
    80003c02:	00000097          	auipc	ra,0x0
    80003c06:	34c080e7          	jalr	844(ra) # 80003f4e <devintr>
    80003c0a:	87aa                	mv	a5,a0
    80003c0c:	fcf42e23          	sw	a5,-36(s0)
    80003c10:	fdc42783          	lw	a5,-36(s0)
    80003c14:	2781                	sext.w	a5,a5
    80003c16:	efa9                	bnez	a5,80003c70 <usertrap+0x11a>
    // ok
  } else {
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80003c18:	00000097          	auipc	ra,0x0
    80003c1c:	e18080e7          	jalr	-488(ra) # 80003a30 <r_scause>
    80003c20:	872a                	mv	a4,a0
    80003c22:	fd043783          	ld	a5,-48(s0)
    80003c26:	5b9c                	lw	a5,48(a5)
    80003c28:	863e                	mv	a2,a5
    80003c2a:	85ba                	mv	a1,a4
    80003c2c:	00007517          	auipc	a0,0x7
    80003c30:	6cc50513          	addi	a0,a0,1740 # 8000b2f8 <etext+0x2f8>
    80003c34:	ffffd097          	auipc	ra,0xffffd
    80003c38:	e36080e7          	jalr	-458(ra) # 80000a6a <printf>
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003c3c:	00000097          	auipc	ra,0x0
    80003c40:	d9a080e7          	jalr	-614(ra) # 800039d6 <r_sepc>
    80003c44:	84aa                	mv	s1,a0
    80003c46:	00000097          	auipc	ra,0x0
    80003c4a:	e08080e7          	jalr	-504(ra) # 80003a4e <r_stval>
    80003c4e:	87aa                	mv	a5,a0
    80003c50:	863e                	mv	a2,a5
    80003c52:	85a6                	mv	a1,s1
    80003c54:	00007517          	auipc	a0,0x7
    80003c58:	6d450513          	addi	a0,a0,1748 # 8000b328 <etext+0x328>
    80003c5c:	ffffd097          	auipc	ra,0xffffd
    80003c60:	e0e080e7          	jalr	-498(ra) # 80000a6a <printf>
    setkilled(p);
    80003c64:	fd043503          	ld	a0,-48(s0)
    80003c68:	00000097          	auipc	ra,0x0
    80003c6c:	9ba080e7          	jalr	-1606(ra) # 80003622 <setkilled>
  }

  if(killed(p))
    80003c70:	fd043503          	ld	a0,-48(s0)
    80003c74:	00000097          	auipc	ra,0x0
    80003c78:	9e8080e7          	jalr	-1560(ra) # 8000365c <killed>
    80003c7c:	87aa                	mv	a5,a0
    80003c7e:	c791                	beqz	a5,80003c8a <usertrap+0x134>
    exit(-1);
    80003c80:	557d                	li	a0,-1
    80003c82:	fffff097          	auipc	ra,0xfffff
    80003c86:	32c080e7          	jalr	812(ra) # 80002fae <exit>

  // give up the CPU if this is a timer interrupt.
  if(which_dev == 2)
    80003c8a:	fdc42783          	lw	a5,-36(s0)
    80003c8e:	0007871b          	sext.w	a4,a5
    80003c92:	4789                	li	a5,2
    80003c94:	00f71663          	bne	a4,a5,80003ca0 <usertrap+0x14a>
    yield();
    80003c98:	fffff097          	auipc	ra,0xfffff
    80003c9c:	744080e7          	jalr	1860(ra) # 800033dc <yield>

  usertrapret();
    80003ca0:	00000097          	auipc	ra,0x0
    80003ca4:	014080e7          	jalr	20(ra) # 80003cb4 <usertrapret>
}
    80003ca8:	0001                	nop
    80003caa:	70a2                	ld	ra,40(sp)
    80003cac:	7402                	ld	s0,32(sp)
    80003cae:	64e2                	ld	s1,24(sp)
    80003cb0:	6145                	addi	sp,sp,48
    80003cb2:	8082                	ret

0000000080003cb4 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80003cb4:	715d                	addi	sp,sp,-80
    80003cb6:	e486                	sd	ra,72(sp)
    80003cb8:	e0a2                	sd	s0,64(sp)
    80003cba:	fc26                	sd	s1,56(sp)
    80003cbc:	0880                	addi	s0,sp,80
  struct proc *p = myproc();
    80003cbe:	fffff097          	auipc	ra,0xfffff
    80003cc2:	bfe080e7          	jalr	-1026(ra) # 800028bc <myproc>
    80003cc6:	fca43c23          	sd	a0,-40(s0)

  // we're about to switch the destination of traps from
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();
    80003cca:	00000097          	auipc	ra,0x0
    80003cce:	dcc080e7          	jalr	-564(ra) # 80003a96 <intr_off>

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80003cd2:	00006717          	auipc	a4,0x6
    80003cd6:	32e70713          	addi	a4,a4,814 # 8000a000 <_trampoline>
    80003cda:	00006797          	auipc	a5,0x6
    80003cde:	32678793          	addi	a5,a5,806 # 8000a000 <_trampoline>
    80003ce2:	8f1d                	sub	a4,a4,a5
    80003ce4:	040007b7          	lui	a5,0x4000
    80003ce8:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80003cea:	07b2                	slli	a5,a5,0xc
    80003cec:	97ba                	add	a5,a5,a4
    80003cee:	fcf43823          	sd	a5,-48(s0)
  w_stvec(trampoline_uservec);
    80003cf2:	fd043503          	ld	a0,-48(s0)
    80003cf6:	00000097          	auipc	ra,0x0
    80003cfa:	cfe080e7          	jalr	-770(ra) # 800039f4 <w_stvec>

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80003cfe:	fd843783          	ld	a5,-40(s0)
    80003d02:	6fa4                	ld	s1,88(a5)
    80003d04:	00000097          	auipc	ra,0x0
    80003d08:	d0e080e7          	jalr	-754(ra) # 80003a12 <r_satp>
    80003d0c:	87aa                	mv	a5,a0
    80003d0e:	e09c                	sd	a5,0(s1)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80003d10:	fd843783          	ld	a5,-40(s0)
    80003d14:	63b4                	ld	a3,64(a5)
    80003d16:	fd843783          	ld	a5,-40(s0)
    80003d1a:	6fbc                	ld	a5,88(a5)
    80003d1c:	6705                	lui	a4,0x1
    80003d1e:	9736                	add	a4,a4,a3
    80003d20:	e798                	sd	a4,8(a5)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80003d22:	fd843783          	ld	a5,-40(s0)
    80003d26:	6fbc                	ld	a5,88(a5)
    80003d28:	00000717          	auipc	a4,0x0
    80003d2c:	e2e70713          	addi	a4,a4,-466 # 80003b56 <usertrap>
    80003d30:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80003d32:	fd843783          	ld	a5,-40(s0)
    80003d36:	6fa4                	ld	s1,88(a5)
    80003d38:	00000097          	auipc	ra,0x0
    80003d3c:	db4080e7          	jalr	-588(ra) # 80003aec <r_tp>
    80003d40:	87aa                	mv	a5,a0
    80003d42:	f09c                	sd	a5,32(s1)

  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
    80003d44:	00000097          	auipc	ra,0x0
    80003d48:	bfc080e7          	jalr	-1028(ra) # 80003940 <r_sstatus>
    80003d4c:	fca43423          	sd	a0,-56(s0)
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80003d50:	fc843783          	ld	a5,-56(s0)
    80003d54:	eff7f793          	andi	a5,a5,-257
    80003d58:	fcf43423          	sd	a5,-56(s0)
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80003d5c:	fc843783          	ld	a5,-56(s0)
    80003d60:	0207e793          	ori	a5,a5,32
    80003d64:	fcf43423          	sd	a5,-56(s0)
  w_sstatus(x);
    80003d68:	fc843503          	ld	a0,-56(s0)
    80003d6c:	00000097          	auipc	ra,0x0
    80003d70:	bf2080e7          	jalr	-1038(ra) # 8000395e <w_sstatus>

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80003d74:	fd843783          	ld	a5,-40(s0)
    80003d78:	6fbc                	ld	a5,88(a5)
    80003d7a:	6f9c                	ld	a5,24(a5)
    80003d7c:	853e                	mv	a0,a5
    80003d7e:	00000097          	auipc	ra,0x0
    80003d82:	c3a080e7          	jalr	-966(ra) # 800039b8 <w_sepc>

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80003d86:	fd843783          	ld	a5,-40(s0)
    80003d8a:	6bbc                	ld	a5,80(a5)
    80003d8c:	00c7d713          	srli	a4,a5,0xc
    80003d90:	57fd                	li	a5,-1
    80003d92:	17fe                	slli	a5,a5,0x3f
    80003d94:	8fd9                	or	a5,a5,a4
    80003d96:	fcf43023          	sd	a5,-64(s0)

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80003d9a:	00006717          	auipc	a4,0x6
    80003d9e:	30270713          	addi	a4,a4,770 # 8000a09c <userret>
    80003da2:	00006797          	auipc	a5,0x6
    80003da6:	25e78793          	addi	a5,a5,606 # 8000a000 <_trampoline>
    80003daa:	8f1d                	sub	a4,a4,a5
    80003dac:	040007b7          	lui	a5,0x4000
    80003db0:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80003db2:	07b2                	slli	a5,a5,0xc
    80003db4:	97ba                	add	a5,a5,a4
    80003db6:	faf43c23          	sd	a5,-72(s0)
  ((void (*)(uint64))trampoline_userret)(satp);
    80003dba:	fb843783          	ld	a5,-72(s0)
    80003dbe:	fc043503          	ld	a0,-64(s0)
    80003dc2:	9782                	jalr	a5
}
    80003dc4:	0001                	nop
    80003dc6:	60a6                	ld	ra,72(sp)
    80003dc8:	6406                	ld	s0,64(sp)
    80003dca:	74e2                	ld	s1,56(sp)
    80003dcc:	6161                	addi	sp,sp,80
    80003dce:	8082                	ret

0000000080003dd0 <kerneltrap>:

// interrupts and exceptions from kernel code go here via kernelvec,
// on whatever the current kernel stack is.
void 
kerneltrap()
{
    80003dd0:	7139                	addi	sp,sp,-64
    80003dd2:	fc06                	sd	ra,56(sp)
    80003dd4:	f822                	sd	s0,48(sp)
    80003dd6:	f426                	sd	s1,40(sp)
    80003dd8:	0080                	addi	s0,sp,64
  int which_dev = 0;
    80003dda:	fc042e23          	sw	zero,-36(s0)
  uint64 sepc = r_sepc();
    80003dde:	00000097          	auipc	ra,0x0
    80003de2:	bf8080e7          	jalr	-1032(ra) # 800039d6 <r_sepc>
    80003de6:	fca43823          	sd	a0,-48(s0)
  uint64 sstatus = r_sstatus();
    80003dea:	00000097          	auipc	ra,0x0
    80003dee:	b56080e7          	jalr	-1194(ra) # 80003940 <r_sstatus>
    80003df2:	fca43423          	sd	a0,-56(s0)
  uint64 scause = r_scause();
    80003df6:	00000097          	auipc	ra,0x0
    80003dfa:	c3a080e7          	jalr	-966(ra) # 80003a30 <r_scause>
    80003dfe:	fca43023          	sd	a0,-64(s0)
  
  if((sstatus & SSTATUS_SPP) == 0)
    80003e02:	fc843783          	ld	a5,-56(s0)
    80003e06:	1007f793          	andi	a5,a5,256
    80003e0a:	eb89                	bnez	a5,80003e1c <kerneltrap+0x4c>
    panic("kerneltrap: not from supervisor mode");
    80003e0c:	00007517          	auipc	a0,0x7
    80003e10:	53c50513          	addi	a0,a0,1340 # 8000b348 <etext+0x348>
    80003e14:	ffffd097          	auipc	ra,0xffffd
    80003e18:	eac080e7          	jalr	-340(ra) # 80000cc0 <panic>
  if(intr_get() != 0)
    80003e1c:	00000097          	auipc	ra,0x0
    80003e20:	ca2080e7          	jalr	-862(ra) # 80003abe <intr_get>
    80003e24:	87aa                	mv	a5,a0
    80003e26:	cb89                	beqz	a5,80003e38 <kerneltrap+0x68>
    panic("kerneltrap: interrupts enabled");
    80003e28:	00007517          	auipc	a0,0x7
    80003e2c:	54850513          	addi	a0,a0,1352 # 8000b370 <etext+0x370>
    80003e30:	ffffd097          	auipc	ra,0xffffd
    80003e34:	e90080e7          	jalr	-368(ra) # 80000cc0 <panic>

  if((which_dev = devintr()) == 0){
    80003e38:	00000097          	auipc	ra,0x0
    80003e3c:	116080e7          	jalr	278(ra) # 80003f4e <devintr>
    80003e40:	87aa                	mv	a5,a0
    80003e42:	fcf42e23          	sw	a5,-36(s0)
    80003e46:	fdc42783          	lw	a5,-36(s0)
    80003e4a:	2781                	sext.w	a5,a5
    80003e4c:	e7b9                	bnez	a5,80003e9a <kerneltrap+0xca>
    printf("scause %p\n", scause);
    80003e4e:	fc043583          	ld	a1,-64(s0)
    80003e52:	00007517          	auipc	a0,0x7
    80003e56:	53e50513          	addi	a0,a0,1342 # 8000b390 <etext+0x390>
    80003e5a:	ffffd097          	auipc	ra,0xffffd
    80003e5e:	c10080e7          	jalr	-1008(ra) # 80000a6a <printf>
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003e62:	00000097          	auipc	ra,0x0
    80003e66:	b74080e7          	jalr	-1164(ra) # 800039d6 <r_sepc>
    80003e6a:	84aa                	mv	s1,a0
    80003e6c:	00000097          	auipc	ra,0x0
    80003e70:	be2080e7          	jalr	-1054(ra) # 80003a4e <r_stval>
    80003e74:	87aa                	mv	a5,a0
    80003e76:	863e                	mv	a2,a5
    80003e78:	85a6                	mv	a1,s1
    80003e7a:	00007517          	auipc	a0,0x7
    80003e7e:	52650513          	addi	a0,a0,1318 # 8000b3a0 <etext+0x3a0>
    80003e82:	ffffd097          	auipc	ra,0xffffd
    80003e86:	be8080e7          	jalr	-1048(ra) # 80000a6a <printf>
    panic("kerneltrap");
    80003e8a:	00007517          	auipc	a0,0x7
    80003e8e:	52e50513          	addi	a0,a0,1326 # 8000b3b8 <etext+0x3b8>
    80003e92:	ffffd097          	auipc	ra,0xffffd
    80003e96:	e2e080e7          	jalr	-466(ra) # 80000cc0 <panic>
  }

  // give up the CPU if this is a timer interrupt.
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80003e9a:	fdc42783          	lw	a5,-36(s0)
    80003e9e:	0007871b          	sext.w	a4,a5
    80003ea2:	4789                	li	a5,2
    80003ea4:	02f71563          	bne	a4,a5,80003ece <kerneltrap+0xfe>
    80003ea8:	fffff097          	auipc	ra,0xfffff
    80003eac:	a14080e7          	jalr	-1516(ra) # 800028bc <myproc>
    80003eb0:	87aa                	mv	a5,a0
    80003eb2:	cf91                	beqz	a5,80003ece <kerneltrap+0xfe>
    80003eb4:	fffff097          	auipc	ra,0xfffff
    80003eb8:	a08080e7          	jalr	-1528(ra) # 800028bc <myproc>
    80003ebc:	87aa                	mv	a5,a0
    80003ebe:	4f98                	lw	a4,24(a5)
    80003ec0:	4791                	li	a5,4
    80003ec2:	00f71663          	bne	a4,a5,80003ece <kerneltrap+0xfe>
    yield();
    80003ec6:	fffff097          	auipc	ra,0xfffff
    80003eca:	516080e7          	jalr	1302(ra) # 800033dc <yield>

  // the yield() may have caused some traps to occur,
  // so restore trap registers for use by kernelvec.S's sepc instruction.
  w_sepc(sepc);
    80003ece:	fd043503          	ld	a0,-48(s0)
    80003ed2:	00000097          	auipc	ra,0x0
    80003ed6:	ae6080e7          	jalr	-1306(ra) # 800039b8 <w_sepc>
  w_sstatus(sstatus);
    80003eda:	fc843503          	ld	a0,-56(s0)
    80003ede:	00000097          	auipc	ra,0x0
    80003ee2:	a80080e7          	jalr	-1408(ra) # 8000395e <w_sstatus>
}
    80003ee6:	0001                	nop
    80003ee8:	70e2                	ld	ra,56(sp)
    80003eea:	7442                	ld	s0,48(sp)
    80003eec:	74a2                	ld	s1,40(sp)
    80003eee:	6121                	addi	sp,sp,64
    80003ef0:	8082                	ret

0000000080003ef2 <clockintr>:

void
clockintr()
{
    80003ef2:	1141                	addi	sp,sp,-16
    80003ef4:	e406                	sd	ra,8(sp)
    80003ef6:	e022                	sd	s0,0(sp)
    80003ef8:	0800                	addi	s0,sp,16
  acquire(&tickslock);
    80003efa:	00016517          	auipc	a0,0x16
    80003efe:	a8e50513          	addi	a0,a0,-1394 # 80019988 <tickslock>
    80003f02:	ffffd097          	auipc	ra,0xffffd
    80003f06:	3c2080e7          	jalr	962(ra) # 800012c4 <acquire>
  ticks++;
    80003f0a:	00008797          	auipc	a5,0x8
    80003f0e:	9de78793          	addi	a5,a5,-1570 # 8000b8e8 <ticks>
    80003f12:	439c                	lw	a5,0(a5)
    80003f14:	2785                	addiw	a5,a5,1
    80003f16:	0007871b          	sext.w	a4,a5
    80003f1a:	00008797          	auipc	a5,0x8
    80003f1e:	9ce78793          	addi	a5,a5,-1586 # 8000b8e8 <ticks>
    80003f22:	c398                	sw	a4,0(a5)
  wakeup(&ticks);
    80003f24:	00008517          	auipc	a0,0x8
    80003f28:	9c450513          	addi	a0,a0,-1596 # 8000b8e8 <ticks>
    80003f2c:	fffff097          	auipc	ra,0xfffff
    80003f30:	5c6080e7          	jalr	1478(ra) # 800034f2 <wakeup>
  release(&tickslock);
    80003f34:	00016517          	auipc	a0,0x16
    80003f38:	a5450513          	addi	a0,a0,-1452 # 80019988 <tickslock>
    80003f3c:	ffffd097          	auipc	ra,0xffffd
    80003f40:	3ec080e7          	jalr	1004(ra) # 80001328 <release>
}
    80003f44:	0001                	nop
    80003f46:	60a2                	ld	ra,8(sp)
    80003f48:	6402                	ld	s0,0(sp)
    80003f4a:	0141                	addi	sp,sp,16
    80003f4c:	8082                	ret

0000000080003f4e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80003f4e:	1101                	addi	sp,sp,-32
    80003f50:	ec06                	sd	ra,24(sp)
    80003f52:	e822                	sd	s0,16(sp)
    80003f54:	1000                	addi	s0,sp,32
  uint64 scause = r_scause();
    80003f56:	00000097          	auipc	ra,0x0
    80003f5a:	ada080e7          	jalr	-1318(ra) # 80003a30 <r_scause>
    80003f5e:	fea43423          	sd	a0,-24(s0)

  if((scause & 0x8000000000000000L) &&
    80003f62:	fe843783          	ld	a5,-24(s0)
    80003f66:	0807d463          	bgez	a5,80003fee <devintr+0xa0>
     (scause & 0xff) == 9){
    80003f6a:	fe843783          	ld	a5,-24(s0)
    80003f6e:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80003f72:	47a5                	li	a5,9
    80003f74:	06f71d63          	bne	a4,a5,80003fee <devintr+0xa0>
    // this is a supervisor external interrupt, via PLIC.

    // irq indicates which device interrupted.
    int irq = plic_claim();
    80003f78:	00005097          	auipc	ra,0x5
    80003f7c:	9be080e7          	jalr	-1602(ra) # 80008936 <plic_claim>
    80003f80:	87aa                	mv	a5,a0
    80003f82:	fef42223          	sw	a5,-28(s0)

    if(irq == UART0_IRQ){
    80003f86:	fe442783          	lw	a5,-28(s0)
    80003f8a:	0007871b          	sext.w	a4,a5
    80003f8e:	47a9                	li	a5,10
    80003f90:	00f71763          	bne	a4,a5,80003f9e <devintr+0x50>
      uartintr();
    80003f94:	ffffd097          	auipc	ra,0xffffd
    80003f98:	02c080e7          	jalr	44(ra) # 80000fc0 <uartintr>
    80003f9c:	a825                	j	80003fd4 <devintr+0x86>
    } else if(irq == VIRTIO0_IRQ){
    80003f9e:	fe442783          	lw	a5,-28(s0)
    80003fa2:	0007871b          	sext.w	a4,a5
    80003fa6:	4785                	li	a5,1
    80003fa8:	00f71763          	bne	a4,a5,80003fb6 <devintr+0x68>
      virtio_disk_intr();
    80003fac:	00005097          	auipc	ra,0x5
    80003fb0:	34e080e7          	jalr	846(ra) # 800092fa <virtio_disk_intr>
    80003fb4:	a005                	j	80003fd4 <devintr+0x86>
    } else if(irq){
    80003fb6:	fe442783          	lw	a5,-28(s0)
    80003fba:	2781                	sext.w	a5,a5
    80003fbc:	cf81                	beqz	a5,80003fd4 <devintr+0x86>
      printf("unexpected interrupt irq=%d\n", irq);
    80003fbe:	fe442783          	lw	a5,-28(s0)
    80003fc2:	85be                	mv	a1,a5
    80003fc4:	00007517          	auipc	a0,0x7
    80003fc8:	40450513          	addi	a0,a0,1028 # 8000b3c8 <etext+0x3c8>
    80003fcc:	ffffd097          	auipc	ra,0xffffd
    80003fd0:	a9e080e7          	jalr	-1378(ra) # 80000a6a <printf>
    }

    // the PLIC allows each device to raise at most one
    // interrupt at a time; tell the PLIC the device is
    // now allowed to interrupt again.
    if(irq)
    80003fd4:	fe442783          	lw	a5,-28(s0)
    80003fd8:	2781                	sext.w	a5,a5
    80003fda:	cb81                	beqz	a5,80003fea <devintr+0x9c>
      plic_complete(irq);
    80003fdc:	fe442783          	lw	a5,-28(s0)
    80003fe0:	853e                	mv	a0,a5
    80003fe2:	00005097          	auipc	ra,0x5
    80003fe6:	992080e7          	jalr	-1646(ra) # 80008974 <plic_complete>

    return 1;
    80003fea:	4785                	li	a5,1
    80003fec:	a081                	j	8000402c <devintr+0xde>
  } else if(scause == 0x8000000000000001L){
    80003fee:	fe843703          	ld	a4,-24(s0)
    80003ff2:	57fd                	li	a5,-1
    80003ff4:	17fe                	slli	a5,a5,0x3f
    80003ff6:	0785                	addi	a5,a5,1
    80003ff8:	02f71963          	bne	a4,a5,8000402a <devintr+0xdc>
    // software interrupt from a machine-mode timer interrupt,
    // forwarded by timervec in kernelvec.S.

    if(cpuid() == 0){
    80003ffc:	fffff097          	auipc	ra,0xfffff
    80004000:	862080e7          	jalr	-1950(ra) # 8000285e <cpuid>
    80004004:	87aa                	mv	a5,a0
    80004006:	e789                	bnez	a5,80004010 <devintr+0xc2>
      clockintr();
    80004008:	00000097          	auipc	ra,0x0
    8000400c:	eea080e7          	jalr	-278(ra) # 80003ef2 <clockintr>
    }
    
    // acknowledge the software interrupt by clearing
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);
    80004010:	00000097          	auipc	ra,0x0
    80004014:	96c080e7          	jalr	-1684(ra) # 8000397c <r_sip>
    80004018:	87aa                	mv	a5,a0
    8000401a:	9bf5                	andi	a5,a5,-3
    8000401c:	853e                	mv	a0,a5
    8000401e:	00000097          	auipc	ra,0x0
    80004022:	97c080e7          	jalr	-1668(ra) # 8000399a <w_sip>

    return 2;
    80004026:	4789                	li	a5,2
    80004028:	a011                	j	8000402c <devintr+0xde>
  } else {
    return 0;
    8000402a:	4781                	li	a5,0
  }
}
    8000402c:	853e                	mv	a0,a5
    8000402e:	60e2                	ld	ra,24(sp)
    80004030:	6442                	ld	s0,16(sp)
    80004032:	6105                	addi	sp,sp,32
    80004034:	8082                	ret

0000000080004036 <fetchaddr>:
#include "defs.h"

// Fetch the uint64 at addr from the current process.
int
fetchaddr(uint64 addr, uint64 *ip)
{
    80004036:	7179                	addi	sp,sp,-48
    80004038:	f406                	sd	ra,40(sp)
    8000403a:	f022                	sd	s0,32(sp)
    8000403c:	1800                	addi	s0,sp,48
    8000403e:	fca43c23          	sd	a0,-40(s0)
    80004042:	fcb43823          	sd	a1,-48(s0)
  struct proc *p = myproc();
    80004046:	fffff097          	auipc	ra,0xfffff
    8000404a:	876080e7          	jalr	-1930(ra) # 800028bc <myproc>
    8000404e:	fea43423          	sd	a0,-24(s0)
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80004052:	fe843783          	ld	a5,-24(s0)
    80004056:	67bc                	ld	a5,72(a5)
    80004058:	fd843703          	ld	a4,-40(s0)
    8000405c:	00f77b63          	bgeu	a4,a5,80004072 <fetchaddr+0x3c>
    80004060:	fd843783          	ld	a5,-40(s0)
    80004064:	00878713          	addi	a4,a5,8
    80004068:	fe843783          	ld	a5,-24(s0)
    8000406c:	67bc                	ld	a5,72(a5)
    8000406e:	00e7f463          	bgeu	a5,a4,80004076 <fetchaddr+0x40>
    return -1;
    80004072:	57fd                	li	a5,-1
    80004074:	a01d                	j	8000409a <fetchaddr+0x64>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80004076:	fe843783          	ld	a5,-24(s0)
    8000407a:	6bbc                	ld	a5,80(a5)
    8000407c:	46a1                	li	a3,8
    8000407e:	fd843603          	ld	a2,-40(s0)
    80004082:	fd043583          	ld	a1,-48(s0)
    80004086:	853e                	mv	a0,a5
    80004088:	ffffe097          	auipc	ra,0xffffe
    8000408c:	3c0080e7          	jalr	960(ra) # 80002448 <copyin>
    80004090:	87aa                	mv	a5,a0
    80004092:	c399                	beqz	a5,80004098 <fetchaddr+0x62>
    return -1;
    80004094:	57fd                	li	a5,-1
    80004096:	a011                	j	8000409a <fetchaddr+0x64>
  return 0;
    80004098:	4781                	li	a5,0
}
    8000409a:	853e                	mv	a0,a5
    8000409c:	70a2                	ld	ra,40(sp)
    8000409e:	7402                	ld	s0,32(sp)
    800040a0:	6145                	addi	sp,sp,48
    800040a2:	8082                	ret

00000000800040a4 <fetchstr>:

// Fetch the nul-terminated string at addr from the current process.
// Returns length of string, not including nul, or -1 for error.
int
fetchstr(uint64 addr, char *buf, int max)
{
    800040a4:	7139                	addi	sp,sp,-64
    800040a6:	fc06                	sd	ra,56(sp)
    800040a8:	f822                	sd	s0,48(sp)
    800040aa:	0080                	addi	s0,sp,64
    800040ac:	fca43c23          	sd	a0,-40(s0)
    800040b0:	fcb43823          	sd	a1,-48(s0)
    800040b4:	87b2                	mv	a5,a2
    800040b6:	fcf42623          	sw	a5,-52(s0)
  struct proc *p = myproc();
    800040ba:	fffff097          	auipc	ra,0xfffff
    800040be:	802080e7          	jalr	-2046(ra) # 800028bc <myproc>
    800040c2:	fea43423          	sd	a0,-24(s0)
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800040c6:	fe843783          	ld	a5,-24(s0)
    800040ca:	6bbc                	ld	a5,80(a5)
    800040cc:	fcc42703          	lw	a4,-52(s0)
    800040d0:	86ba                	mv	a3,a4
    800040d2:	fd843603          	ld	a2,-40(s0)
    800040d6:	fd043583          	ld	a1,-48(s0)
    800040da:	853e                	mv	a0,a5
    800040dc:	ffffe097          	auipc	ra,0xffffe
    800040e0:	43a080e7          	jalr	1082(ra) # 80002516 <copyinstr>
    800040e4:	87aa                	mv	a5,a0
    800040e6:	0007d463          	bgez	a5,800040ee <fetchstr+0x4a>
    return -1;
    800040ea:	57fd                	li	a5,-1
    800040ec:	a801                	j	800040fc <fetchstr+0x58>
  return strlen(buf);
    800040ee:	fd043503          	ld	a0,-48(s0)
    800040f2:	ffffd097          	auipc	ra,0xffffd
    800040f6:	73e080e7          	jalr	1854(ra) # 80001830 <strlen>
    800040fa:	87aa                	mv	a5,a0
}
    800040fc:	853e                	mv	a0,a5
    800040fe:	70e2                	ld	ra,56(sp)
    80004100:	7442                	ld	s0,48(sp)
    80004102:	6121                	addi	sp,sp,64
    80004104:	8082                	ret

0000000080004106 <argraw>:

static uint64
argraw(int n)
{
    80004106:	7179                	addi	sp,sp,-48
    80004108:	f406                	sd	ra,40(sp)
    8000410a:	f022                	sd	s0,32(sp)
    8000410c:	1800                	addi	s0,sp,48
    8000410e:	87aa                	mv	a5,a0
    80004110:	fcf42e23          	sw	a5,-36(s0)
  struct proc *p = myproc();
    80004114:	ffffe097          	auipc	ra,0xffffe
    80004118:	7a8080e7          	jalr	1960(ra) # 800028bc <myproc>
    8000411c:	fea43423          	sd	a0,-24(s0)
  switch (n) {
    80004120:	fdc42783          	lw	a5,-36(s0)
    80004124:	0007871b          	sext.w	a4,a5
    80004128:	4795                	li	a5,5
    8000412a:	06e7e263          	bltu	a5,a4,8000418e <argraw+0x88>
    8000412e:	fdc46783          	lwu	a5,-36(s0)
    80004132:	00279713          	slli	a4,a5,0x2
    80004136:	00007797          	auipc	a5,0x7
    8000413a:	2ba78793          	addi	a5,a5,698 # 8000b3f0 <etext+0x3f0>
    8000413e:	97ba                	add	a5,a5,a4
    80004140:	439c                	lw	a5,0(a5)
    80004142:	0007871b          	sext.w	a4,a5
    80004146:	00007797          	auipc	a5,0x7
    8000414a:	2aa78793          	addi	a5,a5,682 # 8000b3f0 <etext+0x3f0>
    8000414e:	97ba                	add	a5,a5,a4
    80004150:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80004152:	fe843783          	ld	a5,-24(s0)
    80004156:	6fbc                	ld	a5,88(a5)
    80004158:	7bbc                	ld	a5,112(a5)
    8000415a:	a091                	j	8000419e <argraw+0x98>
  case 1:
    return p->trapframe->a1;
    8000415c:	fe843783          	ld	a5,-24(s0)
    80004160:	6fbc                	ld	a5,88(a5)
    80004162:	7fbc                	ld	a5,120(a5)
    80004164:	a82d                	j	8000419e <argraw+0x98>
  case 2:
    return p->trapframe->a2;
    80004166:	fe843783          	ld	a5,-24(s0)
    8000416a:	6fbc                	ld	a5,88(a5)
    8000416c:	63dc                	ld	a5,128(a5)
    8000416e:	a805                	j	8000419e <argraw+0x98>
  case 3:
    return p->trapframe->a3;
    80004170:	fe843783          	ld	a5,-24(s0)
    80004174:	6fbc                	ld	a5,88(a5)
    80004176:	67dc                	ld	a5,136(a5)
    80004178:	a01d                	j	8000419e <argraw+0x98>
  case 4:
    return p->trapframe->a4;
    8000417a:	fe843783          	ld	a5,-24(s0)
    8000417e:	6fbc                	ld	a5,88(a5)
    80004180:	6bdc                	ld	a5,144(a5)
    80004182:	a831                	j	8000419e <argraw+0x98>
  case 5:
    return p->trapframe->a5;
    80004184:	fe843783          	ld	a5,-24(s0)
    80004188:	6fbc                	ld	a5,88(a5)
    8000418a:	6fdc                	ld	a5,152(a5)
    8000418c:	a809                	j	8000419e <argraw+0x98>
  }
  panic("argraw");
    8000418e:	00007517          	auipc	a0,0x7
    80004192:	25a50513          	addi	a0,a0,602 # 8000b3e8 <etext+0x3e8>
    80004196:	ffffd097          	auipc	ra,0xffffd
    8000419a:	b2a080e7          	jalr	-1238(ra) # 80000cc0 <panic>
  return -1;
}
    8000419e:	853e                	mv	a0,a5
    800041a0:	70a2                	ld	ra,40(sp)
    800041a2:	7402                	ld	s0,32(sp)
    800041a4:	6145                	addi	sp,sp,48
    800041a6:	8082                	ret

00000000800041a8 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800041a8:	1101                	addi	sp,sp,-32
    800041aa:	ec06                	sd	ra,24(sp)
    800041ac:	e822                	sd	s0,16(sp)
    800041ae:	1000                	addi	s0,sp,32
    800041b0:	87aa                	mv	a5,a0
    800041b2:	feb43023          	sd	a1,-32(s0)
    800041b6:	fef42623          	sw	a5,-20(s0)
  *ip = argraw(n);
    800041ba:	fec42783          	lw	a5,-20(s0)
    800041be:	853e                	mv	a0,a5
    800041c0:	00000097          	auipc	ra,0x0
    800041c4:	f46080e7          	jalr	-186(ra) # 80004106 <argraw>
    800041c8:	87aa                	mv	a5,a0
    800041ca:	0007871b          	sext.w	a4,a5
    800041ce:	fe043783          	ld	a5,-32(s0)
    800041d2:	c398                	sw	a4,0(a5)
}
    800041d4:	0001                	nop
    800041d6:	60e2                	ld	ra,24(sp)
    800041d8:	6442                	ld	s0,16(sp)
    800041da:	6105                	addi	sp,sp,32
    800041dc:	8082                	ret

00000000800041de <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800041de:	1101                	addi	sp,sp,-32
    800041e0:	ec06                	sd	ra,24(sp)
    800041e2:	e822                	sd	s0,16(sp)
    800041e4:	1000                	addi	s0,sp,32
    800041e6:	87aa                	mv	a5,a0
    800041e8:	feb43023          	sd	a1,-32(s0)
    800041ec:	fef42623          	sw	a5,-20(s0)
  *ip = argraw(n);
    800041f0:	fec42783          	lw	a5,-20(s0)
    800041f4:	853e                	mv	a0,a5
    800041f6:	00000097          	auipc	ra,0x0
    800041fa:	f10080e7          	jalr	-240(ra) # 80004106 <argraw>
    800041fe:	872a                	mv	a4,a0
    80004200:	fe043783          	ld	a5,-32(s0)
    80004204:	e398                	sd	a4,0(a5)
}
    80004206:	0001                	nop
    80004208:	60e2                	ld	ra,24(sp)
    8000420a:	6442                	ld	s0,16(sp)
    8000420c:	6105                	addi	sp,sp,32
    8000420e:	8082                	ret

0000000080004210 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80004210:	7179                	addi	sp,sp,-48
    80004212:	f406                	sd	ra,40(sp)
    80004214:	f022                	sd	s0,32(sp)
    80004216:	1800                	addi	s0,sp,48
    80004218:	87aa                	mv	a5,a0
    8000421a:	fcb43823          	sd	a1,-48(s0)
    8000421e:	8732                	mv	a4,a2
    80004220:	fcf42e23          	sw	a5,-36(s0)
    80004224:	87ba                	mv	a5,a4
    80004226:	fcf42c23          	sw	a5,-40(s0)
  uint64 addr;
  argaddr(n, &addr);
    8000422a:	fe840713          	addi	a4,s0,-24
    8000422e:	fdc42783          	lw	a5,-36(s0)
    80004232:	85ba                	mv	a1,a4
    80004234:	853e                	mv	a0,a5
    80004236:	00000097          	auipc	ra,0x0
    8000423a:	fa8080e7          	jalr	-88(ra) # 800041de <argaddr>
  return fetchstr(addr, buf, max);
    8000423e:	fe843783          	ld	a5,-24(s0)
    80004242:	fd842703          	lw	a4,-40(s0)
    80004246:	863a                	mv	a2,a4
    80004248:	fd043583          	ld	a1,-48(s0)
    8000424c:	853e                	mv	a0,a5
    8000424e:	00000097          	auipc	ra,0x0
    80004252:	e56080e7          	jalr	-426(ra) # 800040a4 <fetchstr>
    80004256:	87aa                	mv	a5,a0
}
    80004258:	853e                	mv	a0,a5
    8000425a:	70a2                	ld	ra,40(sp)
    8000425c:	7402                	ld	s0,32(sp)
    8000425e:	6145                	addi	sp,sp,48
    80004260:	8082                	ret

0000000080004262 <syscall>:
[SYS_ps]    sys_ps,
};

void
syscall(void)
{
    80004262:	7179                	addi	sp,sp,-48
    80004264:	f406                	sd	ra,40(sp)
    80004266:	f022                	sd	s0,32(sp)
    80004268:	ec26                	sd	s1,24(sp)
    8000426a:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    8000426c:	ffffe097          	auipc	ra,0xffffe
    80004270:	650080e7          	jalr	1616(ra) # 800028bc <myproc>
    80004274:	fca43c23          	sd	a0,-40(s0)

  num = p->trapframe->a7;
    80004278:	fd843783          	ld	a5,-40(s0)
    8000427c:	6fbc                	ld	a5,88(a5)
    8000427e:	77dc                	ld	a5,168(a5)
    80004280:	fcf42a23          	sw	a5,-44(s0)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80004284:	fd442783          	lw	a5,-44(s0)
    80004288:	2781                	sext.w	a5,a5
    8000428a:	04f05163          	blez	a5,800042cc <syscall+0x6a>
    8000428e:	fd442703          	lw	a4,-44(s0)
    80004292:	47d9                	li	a5,22
    80004294:	02e7ec63          	bltu	a5,a4,800042cc <syscall+0x6a>
    80004298:	00007717          	auipc	a4,0x7
    8000429c:	56870713          	addi	a4,a4,1384 # 8000b800 <syscalls>
    800042a0:	fd442783          	lw	a5,-44(s0)
    800042a4:	078e                	slli	a5,a5,0x3
    800042a6:	97ba                	add	a5,a5,a4
    800042a8:	639c                	ld	a5,0(a5)
    800042aa:	c38d                	beqz	a5,800042cc <syscall+0x6a>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800042ac:	00007717          	auipc	a4,0x7
    800042b0:	55470713          	addi	a4,a4,1364 # 8000b800 <syscalls>
    800042b4:	fd442783          	lw	a5,-44(s0)
    800042b8:	078e                	slli	a5,a5,0x3
    800042ba:	97ba                	add	a5,a5,a4
    800042bc:	639c                	ld	a5,0(a5)
    800042be:	fd843703          	ld	a4,-40(s0)
    800042c2:	6f24                	ld	s1,88(a4)
    800042c4:	9782                	jalr	a5
    800042c6:	87aa                	mv	a5,a0
    800042c8:	f8bc                	sd	a5,112(s1)
    800042ca:	a815                	j	800042fe <syscall+0x9c>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800042cc:	fd843783          	ld	a5,-40(s0)
    800042d0:	5b98                	lw	a4,48(a5)
            p->pid, p->name, num);
    800042d2:	fd843783          	ld	a5,-40(s0)
    800042d6:	15878793          	addi	a5,a5,344
    printf("%d %s: unknown sys call %d\n",
    800042da:	fd442683          	lw	a3,-44(s0)
    800042de:	863e                	mv	a2,a5
    800042e0:	85ba                	mv	a1,a4
    800042e2:	00007517          	auipc	a0,0x7
    800042e6:	12650513          	addi	a0,a0,294 # 8000b408 <etext+0x408>
    800042ea:	ffffc097          	auipc	ra,0xffffc
    800042ee:	780080e7          	jalr	1920(ra) # 80000a6a <printf>
    p->trapframe->a0 = -1;
    800042f2:	fd843783          	ld	a5,-40(s0)
    800042f6:	6fbc                	ld	a5,88(a5)
    800042f8:	577d                	li	a4,-1
    800042fa:	fbb8                	sd	a4,112(a5)
  }
}
    800042fc:	0001                	nop
    800042fe:	0001                	nop
    80004300:	70a2                	ld	ra,40(sp)
    80004302:	7402                	ld	s0,32(sp)
    80004304:	64e2                	ld	s1,24(sp)
    80004306:	6145                	addi	sp,sp,48
    80004308:	8082                	ret

000000008000430a <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000430a:	1101                	addi	sp,sp,-32
    8000430c:	ec06                	sd	ra,24(sp)
    8000430e:	e822                	sd	s0,16(sp)
    80004310:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80004312:	fec40793          	addi	a5,s0,-20
    80004316:	85be                	mv	a1,a5
    80004318:	4501                	li	a0,0
    8000431a:	00000097          	auipc	ra,0x0
    8000431e:	e8e080e7          	jalr	-370(ra) # 800041a8 <argint>
  exit(n);
    80004322:	fec42783          	lw	a5,-20(s0)
    80004326:	853e                	mv	a0,a5
    80004328:	fffff097          	auipc	ra,0xfffff
    8000432c:	c86080e7          	jalr	-890(ra) # 80002fae <exit>
  return 0;  // not reached
    80004330:	4781                	li	a5,0
}
    80004332:	853e                	mv	a0,a5
    80004334:	60e2                	ld	ra,24(sp)
    80004336:	6442                	ld	s0,16(sp)
    80004338:	6105                	addi	sp,sp,32
    8000433a:	8082                	ret

000000008000433c <sys_getpid>:

uint64
sys_getpid(void)
{
    8000433c:	1141                	addi	sp,sp,-16
    8000433e:	e406                	sd	ra,8(sp)
    80004340:	e022                	sd	s0,0(sp)
    80004342:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80004344:	ffffe097          	auipc	ra,0xffffe
    80004348:	578080e7          	jalr	1400(ra) # 800028bc <myproc>
    8000434c:	87aa                	mv	a5,a0
    8000434e:	5b9c                	lw	a5,48(a5)
}
    80004350:	853e                	mv	a0,a5
    80004352:	60a2                	ld	ra,8(sp)
    80004354:	6402                	ld	s0,0(sp)
    80004356:	0141                	addi	sp,sp,16
    80004358:	8082                	ret

000000008000435a <sys_fork>:

uint64
sys_fork(void)
{
    8000435a:	1141                	addi	sp,sp,-16
    8000435c:	e406                	sd	ra,8(sp)
    8000435e:	e022                	sd	s0,0(sp)
    80004360:	0800                	addi	s0,sp,16
  return fork();
    80004362:	fffff097          	auipc	ra,0xfffff
    80004366:	a2a080e7          	jalr	-1494(ra) # 80002d8c <fork>
    8000436a:	87aa                	mv	a5,a0
}
    8000436c:	853e                	mv	a0,a5
    8000436e:	60a2                	ld	ra,8(sp)
    80004370:	6402                	ld	s0,0(sp)
    80004372:	0141                	addi	sp,sp,16
    80004374:	8082                	ret

0000000080004376 <sys_wait>:

uint64
sys_wait(void)
{
    80004376:	1101                	addi	sp,sp,-32
    80004378:	ec06                	sd	ra,24(sp)
    8000437a:	e822                	sd	s0,16(sp)
    8000437c:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000437e:	fe840793          	addi	a5,s0,-24
    80004382:	85be                	mv	a1,a5
    80004384:	4501                	li	a0,0
    80004386:	00000097          	auipc	ra,0x0
    8000438a:	e58080e7          	jalr	-424(ra) # 800041de <argaddr>
  return wait(p);
    8000438e:	fe843783          	ld	a5,-24(s0)
    80004392:	853e                	mv	a0,a5
    80004394:	fffff097          	auipc	ra,0xfffff
    80004398:	d56080e7          	jalr	-682(ra) # 800030ea <wait>
    8000439c:	87aa                	mv	a5,a0
}
    8000439e:	853e                	mv	a0,a5
    800043a0:	60e2                	ld	ra,24(sp)
    800043a2:	6442                	ld	s0,16(sp)
    800043a4:	6105                	addi	sp,sp,32
    800043a6:	8082                	ret

00000000800043a8 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800043a8:	1101                	addi	sp,sp,-32
    800043aa:	ec06                	sd	ra,24(sp)
    800043ac:	e822                	sd	s0,16(sp)
    800043ae:	1000                	addi	s0,sp,32
  uint64 addr;
  int n;

  argint(0, &n);
    800043b0:	fe440793          	addi	a5,s0,-28
    800043b4:	85be                	mv	a1,a5
    800043b6:	4501                	li	a0,0
    800043b8:	00000097          	auipc	ra,0x0
    800043bc:	df0080e7          	jalr	-528(ra) # 800041a8 <argint>
  addr = myproc()->sz;
    800043c0:	ffffe097          	auipc	ra,0xffffe
    800043c4:	4fc080e7          	jalr	1276(ra) # 800028bc <myproc>
    800043c8:	87aa                	mv	a5,a0
    800043ca:	67bc                	ld	a5,72(a5)
    800043cc:	fef43423          	sd	a5,-24(s0)
  if(growproc(n) < 0)
    800043d0:	fe442783          	lw	a5,-28(s0)
    800043d4:	853e                	mv	a0,a5
    800043d6:	fffff097          	auipc	ra,0xfffff
    800043da:	916080e7          	jalr	-1770(ra) # 80002cec <growproc>
    800043de:	87aa                	mv	a5,a0
    800043e0:	0007d463          	bgez	a5,800043e8 <sys_sbrk+0x40>
    return -1;
    800043e4:	57fd                	li	a5,-1
    800043e6:	a019                	j	800043ec <sys_sbrk+0x44>
  return addr;
    800043e8:	fe843783          	ld	a5,-24(s0)
}
    800043ec:	853e                	mv	a0,a5
    800043ee:	60e2                	ld	ra,24(sp)
    800043f0:	6442                	ld	s0,16(sp)
    800043f2:	6105                	addi	sp,sp,32
    800043f4:	8082                	ret

00000000800043f6 <sys_sleep>:

uint64
sys_sleep(void)
{
    800043f6:	1101                	addi	sp,sp,-32
    800043f8:	ec06                	sd	ra,24(sp)
    800043fa:	e822                	sd	s0,16(sp)
    800043fc:	1000                	addi	s0,sp,32
  int n;
  uint ticks0;

  argint(0, &n);
    800043fe:	fe840793          	addi	a5,s0,-24
    80004402:	85be                	mv	a1,a5
    80004404:	4501                	li	a0,0
    80004406:	00000097          	auipc	ra,0x0
    8000440a:	da2080e7          	jalr	-606(ra) # 800041a8 <argint>
  acquire(&tickslock);
    8000440e:	00015517          	auipc	a0,0x15
    80004412:	57a50513          	addi	a0,a0,1402 # 80019988 <tickslock>
    80004416:	ffffd097          	auipc	ra,0xffffd
    8000441a:	eae080e7          	jalr	-338(ra) # 800012c4 <acquire>
  ticks0 = ticks;
    8000441e:	00007797          	auipc	a5,0x7
    80004422:	4ca78793          	addi	a5,a5,1226 # 8000b8e8 <ticks>
    80004426:	439c                	lw	a5,0(a5)
    80004428:	fef42623          	sw	a5,-20(s0)
  while(ticks - ticks0 < n){
    8000442c:	a099                	j	80004472 <sys_sleep+0x7c>
    if(killed(myproc())){
    8000442e:	ffffe097          	auipc	ra,0xffffe
    80004432:	48e080e7          	jalr	1166(ra) # 800028bc <myproc>
    80004436:	87aa                	mv	a5,a0
    80004438:	853e                	mv	a0,a5
    8000443a:	fffff097          	auipc	ra,0xfffff
    8000443e:	222080e7          	jalr	546(ra) # 8000365c <killed>
    80004442:	87aa                	mv	a5,a0
    80004444:	cb99                	beqz	a5,8000445a <sys_sleep+0x64>
      release(&tickslock);
    80004446:	00015517          	auipc	a0,0x15
    8000444a:	54250513          	addi	a0,a0,1346 # 80019988 <tickslock>
    8000444e:	ffffd097          	auipc	ra,0xffffd
    80004452:	eda080e7          	jalr	-294(ra) # 80001328 <release>
      return -1;
    80004456:	57fd                	li	a5,-1
    80004458:	a099                	j	8000449e <sys_sleep+0xa8>
    }
    sleep(&ticks, &tickslock);
    8000445a:	00015597          	auipc	a1,0x15
    8000445e:	52e58593          	addi	a1,a1,1326 # 80019988 <tickslock>
    80004462:	00007517          	auipc	a0,0x7
    80004466:	48650513          	addi	a0,a0,1158 # 8000b8e8 <ticks>
    8000446a:	fffff097          	auipc	ra,0xfffff
    8000446e:	00c080e7          	jalr	12(ra) # 80003476 <sleep>
  while(ticks - ticks0 < n){
    80004472:	00007797          	auipc	a5,0x7
    80004476:	47678793          	addi	a5,a5,1142 # 8000b8e8 <ticks>
    8000447a:	439c                	lw	a5,0(a5)
    8000447c:	fec42703          	lw	a4,-20(s0)
    80004480:	9f99                	subw	a5,a5,a4
    80004482:	2781                	sext.w	a5,a5
    80004484:	fe842703          	lw	a4,-24(s0)
    80004488:	fae7e3e3          	bltu	a5,a4,8000442e <sys_sleep+0x38>
  }
  release(&tickslock);
    8000448c:	00015517          	auipc	a0,0x15
    80004490:	4fc50513          	addi	a0,a0,1276 # 80019988 <tickslock>
    80004494:	ffffd097          	auipc	ra,0xffffd
    80004498:	e94080e7          	jalr	-364(ra) # 80001328 <release>
  return 0;
    8000449c:	4781                	li	a5,0
}
    8000449e:	853e                	mv	a0,a5
    800044a0:	60e2                	ld	ra,24(sp)
    800044a2:	6442                	ld	s0,16(sp)
    800044a4:	6105                	addi	sp,sp,32
    800044a6:	8082                	ret

00000000800044a8 <sys_kill>:

uint64
sys_kill(void)
{
    800044a8:	1101                	addi	sp,sp,-32
    800044aa:	ec06                	sd	ra,24(sp)
    800044ac:	e822                	sd	s0,16(sp)
    800044ae:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800044b0:	fec40793          	addi	a5,s0,-20
    800044b4:	85be                	mv	a1,a5
    800044b6:	4501                	li	a0,0
    800044b8:	00000097          	auipc	ra,0x0
    800044bc:	cf0080e7          	jalr	-784(ra) # 800041a8 <argint>
  return kill(pid);
    800044c0:	fec42783          	lw	a5,-20(s0)
    800044c4:	853e                	mv	a0,a5
    800044c6:	fffff097          	auipc	ra,0xfffff
    800044ca:	0be080e7          	jalr	190(ra) # 80003584 <kill>
    800044ce:	87aa                	mv	a5,a0
}
    800044d0:	853e                	mv	a0,a5
    800044d2:	60e2                	ld	ra,24(sp)
    800044d4:	6442                	ld	s0,16(sp)
    800044d6:	6105                	addi	sp,sp,32
    800044d8:	8082                	ret

00000000800044da <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800044da:	1101                	addi	sp,sp,-32
    800044dc:	ec06                	sd	ra,24(sp)
    800044de:	e822                	sd	s0,16(sp)
    800044e0:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800044e2:	00015517          	auipc	a0,0x15
    800044e6:	4a650513          	addi	a0,a0,1190 # 80019988 <tickslock>
    800044ea:	ffffd097          	auipc	ra,0xffffd
    800044ee:	dda080e7          	jalr	-550(ra) # 800012c4 <acquire>
  xticks = ticks;
    800044f2:	00007797          	auipc	a5,0x7
    800044f6:	3f678793          	addi	a5,a5,1014 # 8000b8e8 <ticks>
    800044fa:	439c                	lw	a5,0(a5)
    800044fc:	fef42623          	sw	a5,-20(s0)
  release(&tickslock);
    80004500:	00015517          	auipc	a0,0x15
    80004504:	48850513          	addi	a0,a0,1160 # 80019988 <tickslock>
    80004508:	ffffd097          	auipc	ra,0xffffd
    8000450c:	e20080e7          	jalr	-480(ra) # 80001328 <release>
  return xticks;
    80004510:	fec46783          	lwu	a5,-20(s0)
}
    80004514:	853e                	mv	a0,a5
    80004516:	60e2                	ld	ra,24(sp)
    80004518:	6442                	ld	s0,16(sp)
    8000451a:	6105                	addi	sp,sp,32
    8000451c:	8082                	ret

000000008000451e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000451e:	1101                	addi	sp,sp,-32
    80004520:	ec06                	sd	ra,24(sp)
    80004522:	e822                	sd	s0,16(sp)
    80004524:	1000                	addi	s0,sp,32
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80004526:	00007597          	auipc	a1,0x7
    8000452a:	f0258593          	addi	a1,a1,-254 # 8000b428 <etext+0x428>
    8000452e:	00015517          	auipc	a0,0x15
    80004532:	47250513          	addi	a0,a0,1138 # 800199a0 <bcache>
    80004536:	ffffd097          	auipc	ra,0xffffd
    8000453a:	d5a080e7          	jalr	-678(ra) # 80001290 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000453e:	00015717          	auipc	a4,0x15
    80004542:	46270713          	addi	a4,a4,1122 # 800199a0 <bcache>
    80004546:	67a1                	lui	a5,0x8
    80004548:	97ba                	add	a5,a5,a4
    8000454a:	0001d717          	auipc	a4,0x1d
    8000454e:	6be70713          	addi	a4,a4,1726 # 80021c08 <bcache+0x8268>
    80004552:	2ae7b823          	sd	a4,688(a5) # 82b0 <_entry-0x7fff7d50>
  bcache.head.next = &bcache.head;
    80004556:	00015717          	auipc	a4,0x15
    8000455a:	44a70713          	addi	a4,a4,1098 # 800199a0 <bcache>
    8000455e:	67a1                	lui	a5,0x8
    80004560:	97ba                	add	a5,a5,a4
    80004562:	0001d717          	auipc	a4,0x1d
    80004566:	6a670713          	addi	a4,a4,1702 # 80021c08 <bcache+0x8268>
    8000456a:	2ae7bc23          	sd	a4,696(a5) # 82b8 <_entry-0x7fff7d48>
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000456e:	00015797          	auipc	a5,0x15
    80004572:	44a78793          	addi	a5,a5,1098 # 800199b8 <bcache+0x18>
    80004576:	fef43423          	sd	a5,-24(s0)
    8000457a:	a895                	j	800045ee <binit+0xd0>
    b->next = bcache.head.next;
    8000457c:	00015717          	auipc	a4,0x15
    80004580:	42470713          	addi	a4,a4,1060 # 800199a0 <bcache>
    80004584:	67a1                	lui	a5,0x8
    80004586:	97ba                	add	a5,a5,a4
    80004588:	2b87b703          	ld	a4,696(a5) # 82b8 <_entry-0x7fff7d48>
    8000458c:	fe843783          	ld	a5,-24(s0)
    80004590:	ebb8                	sd	a4,80(a5)
    b->prev = &bcache.head;
    80004592:	fe843783          	ld	a5,-24(s0)
    80004596:	0001d717          	auipc	a4,0x1d
    8000459a:	67270713          	addi	a4,a4,1650 # 80021c08 <bcache+0x8268>
    8000459e:	e7b8                	sd	a4,72(a5)
    initsleeplock(&b->lock, "buffer");
    800045a0:	fe843783          	ld	a5,-24(s0)
    800045a4:	07c1                	addi	a5,a5,16
    800045a6:	00007597          	auipc	a1,0x7
    800045aa:	e8a58593          	addi	a1,a1,-374 # 8000b430 <etext+0x430>
    800045ae:	853e                	mv	a0,a5
    800045b0:	00002097          	auipc	ra,0x2
    800045b4:	fe4080e7          	jalr	-28(ra) # 80006594 <initsleeplock>
    bcache.head.next->prev = b;
    800045b8:	00015717          	auipc	a4,0x15
    800045bc:	3e870713          	addi	a4,a4,1000 # 800199a0 <bcache>
    800045c0:	67a1                	lui	a5,0x8
    800045c2:	97ba                	add	a5,a5,a4
    800045c4:	2b87b783          	ld	a5,696(a5) # 82b8 <_entry-0x7fff7d48>
    800045c8:	fe843703          	ld	a4,-24(s0)
    800045cc:	e7b8                	sd	a4,72(a5)
    bcache.head.next = b;
    800045ce:	00015717          	auipc	a4,0x15
    800045d2:	3d270713          	addi	a4,a4,978 # 800199a0 <bcache>
    800045d6:	67a1                	lui	a5,0x8
    800045d8:	97ba                	add	a5,a5,a4
    800045da:	fe843703          	ld	a4,-24(s0)
    800045de:	2ae7bc23          	sd	a4,696(a5) # 82b8 <_entry-0x7fff7d48>
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800045e2:	fe843783          	ld	a5,-24(s0)
    800045e6:	45878793          	addi	a5,a5,1112
    800045ea:	fef43423          	sd	a5,-24(s0)
    800045ee:	0001d797          	auipc	a5,0x1d
    800045f2:	61a78793          	addi	a5,a5,1562 # 80021c08 <bcache+0x8268>
    800045f6:	fe843703          	ld	a4,-24(s0)
    800045fa:	f8f761e3          	bltu	a4,a5,8000457c <binit+0x5e>
  }
}
    800045fe:	0001                	nop
    80004600:	0001                	nop
    80004602:	60e2                	ld	ra,24(sp)
    80004604:	6442                	ld	s0,16(sp)
    80004606:	6105                	addi	sp,sp,32
    80004608:	8082                	ret

000000008000460a <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
    8000460a:	7179                	addi	sp,sp,-48
    8000460c:	f406                	sd	ra,40(sp)
    8000460e:	f022                	sd	s0,32(sp)
    80004610:	1800                	addi	s0,sp,48
    80004612:	87aa                	mv	a5,a0
    80004614:	872e                	mv	a4,a1
    80004616:	fcf42e23          	sw	a5,-36(s0)
    8000461a:	87ba                	mv	a5,a4
    8000461c:	fcf42c23          	sw	a5,-40(s0)
  struct buf *b;

  acquire(&bcache.lock);
    80004620:	00015517          	auipc	a0,0x15
    80004624:	38050513          	addi	a0,a0,896 # 800199a0 <bcache>
    80004628:	ffffd097          	auipc	ra,0xffffd
    8000462c:	c9c080e7          	jalr	-868(ra) # 800012c4 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80004630:	00015717          	auipc	a4,0x15
    80004634:	37070713          	addi	a4,a4,880 # 800199a0 <bcache>
    80004638:	67a1                	lui	a5,0x8
    8000463a:	97ba                	add	a5,a5,a4
    8000463c:	2b87b783          	ld	a5,696(a5) # 82b8 <_entry-0x7fff7d48>
    80004640:	fef43423          	sd	a5,-24(s0)
    80004644:	a095                	j	800046a8 <bget+0x9e>
    if(b->dev == dev && b->blockno == blockno){
    80004646:	fe843783          	ld	a5,-24(s0)
    8000464a:	479c                	lw	a5,8(a5)
    8000464c:	fdc42703          	lw	a4,-36(s0)
    80004650:	2701                	sext.w	a4,a4
    80004652:	04f71663          	bne	a4,a5,8000469e <bget+0x94>
    80004656:	fe843783          	ld	a5,-24(s0)
    8000465a:	47dc                	lw	a5,12(a5)
    8000465c:	fd842703          	lw	a4,-40(s0)
    80004660:	2701                	sext.w	a4,a4
    80004662:	02f71e63          	bne	a4,a5,8000469e <bget+0x94>
      b->refcnt++;
    80004666:	fe843783          	ld	a5,-24(s0)
    8000466a:	43bc                	lw	a5,64(a5)
    8000466c:	2785                	addiw	a5,a5,1
    8000466e:	0007871b          	sext.w	a4,a5
    80004672:	fe843783          	ld	a5,-24(s0)
    80004676:	c3b8                	sw	a4,64(a5)
      release(&bcache.lock);
    80004678:	00015517          	auipc	a0,0x15
    8000467c:	32850513          	addi	a0,a0,808 # 800199a0 <bcache>
    80004680:	ffffd097          	auipc	ra,0xffffd
    80004684:	ca8080e7          	jalr	-856(ra) # 80001328 <release>
      acquiresleep(&b->lock);
    80004688:	fe843783          	ld	a5,-24(s0)
    8000468c:	07c1                	addi	a5,a5,16
    8000468e:	853e                	mv	a0,a5
    80004690:	00002097          	auipc	ra,0x2
    80004694:	f50080e7          	jalr	-176(ra) # 800065e0 <acquiresleep>
      return b;
    80004698:	fe843783          	ld	a5,-24(s0)
    8000469c:	a07d                	j	8000474a <bget+0x140>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000469e:	fe843783          	ld	a5,-24(s0)
    800046a2:	6bbc                	ld	a5,80(a5)
    800046a4:	fef43423          	sd	a5,-24(s0)
    800046a8:	fe843703          	ld	a4,-24(s0)
    800046ac:	0001d797          	auipc	a5,0x1d
    800046b0:	55c78793          	addi	a5,a5,1372 # 80021c08 <bcache+0x8268>
    800046b4:	f8f719e3          	bne	a4,a5,80004646 <bget+0x3c>
    }
  }

  // Not cached.
  // Recycle the least recently used (LRU) unused buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800046b8:	00015717          	auipc	a4,0x15
    800046bc:	2e870713          	addi	a4,a4,744 # 800199a0 <bcache>
    800046c0:	67a1                	lui	a5,0x8
    800046c2:	97ba                	add	a5,a5,a4
    800046c4:	2b07b783          	ld	a5,688(a5) # 82b0 <_entry-0x7fff7d50>
    800046c8:	fef43423          	sd	a5,-24(s0)
    800046cc:	a8b9                	j	8000472a <bget+0x120>
    if(b->refcnt == 0) {
    800046ce:	fe843783          	ld	a5,-24(s0)
    800046d2:	43bc                	lw	a5,64(a5)
    800046d4:	e7b1                	bnez	a5,80004720 <bget+0x116>
      b->dev = dev;
    800046d6:	fe843783          	ld	a5,-24(s0)
    800046da:	fdc42703          	lw	a4,-36(s0)
    800046de:	c798                	sw	a4,8(a5)
      b->blockno = blockno;
    800046e0:	fe843783          	ld	a5,-24(s0)
    800046e4:	fd842703          	lw	a4,-40(s0)
    800046e8:	c7d8                	sw	a4,12(a5)
      b->valid = 0;
    800046ea:	fe843783          	ld	a5,-24(s0)
    800046ee:	0007a023          	sw	zero,0(a5)
      b->refcnt = 1;
    800046f2:	fe843783          	ld	a5,-24(s0)
    800046f6:	4705                	li	a4,1
    800046f8:	c3b8                	sw	a4,64(a5)
      release(&bcache.lock);
    800046fa:	00015517          	auipc	a0,0x15
    800046fe:	2a650513          	addi	a0,a0,678 # 800199a0 <bcache>
    80004702:	ffffd097          	auipc	ra,0xffffd
    80004706:	c26080e7          	jalr	-986(ra) # 80001328 <release>
      acquiresleep(&b->lock);
    8000470a:	fe843783          	ld	a5,-24(s0)
    8000470e:	07c1                	addi	a5,a5,16
    80004710:	853e                	mv	a0,a5
    80004712:	00002097          	auipc	ra,0x2
    80004716:	ece080e7          	jalr	-306(ra) # 800065e0 <acquiresleep>
      return b;
    8000471a:	fe843783          	ld	a5,-24(s0)
    8000471e:	a035                	j	8000474a <bget+0x140>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80004720:	fe843783          	ld	a5,-24(s0)
    80004724:	67bc                	ld	a5,72(a5)
    80004726:	fef43423          	sd	a5,-24(s0)
    8000472a:	fe843703          	ld	a4,-24(s0)
    8000472e:	0001d797          	auipc	a5,0x1d
    80004732:	4da78793          	addi	a5,a5,1242 # 80021c08 <bcache+0x8268>
    80004736:	f8f71ce3          	bne	a4,a5,800046ce <bget+0xc4>
    }
  }
  panic("bget: no buffers");
    8000473a:	00007517          	auipc	a0,0x7
    8000473e:	cfe50513          	addi	a0,a0,-770 # 8000b438 <etext+0x438>
    80004742:	ffffc097          	auipc	ra,0xffffc
    80004746:	57e080e7          	jalr	1406(ra) # 80000cc0 <panic>
}
    8000474a:	853e                	mv	a0,a5
    8000474c:	70a2                	ld	ra,40(sp)
    8000474e:	7402                	ld	s0,32(sp)
    80004750:	6145                	addi	sp,sp,48
    80004752:	8082                	ret

0000000080004754 <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80004754:	7179                	addi	sp,sp,-48
    80004756:	f406                	sd	ra,40(sp)
    80004758:	f022                	sd	s0,32(sp)
    8000475a:	1800                	addi	s0,sp,48
    8000475c:	87aa                	mv	a5,a0
    8000475e:	872e                	mv	a4,a1
    80004760:	fcf42e23          	sw	a5,-36(s0)
    80004764:	87ba                	mv	a5,a4
    80004766:	fcf42c23          	sw	a5,-40(s0)
  struct buf *b;

  b = bget(dev, blockno);
    8000476a:	fd842703          	lw	a4,-40(s0)
    8000476e:	fdc42783          	lw	a5,-36(s0)
    80004772:	85ba                	mv	a1,a4
    80004774:	853e                	mv	a0,a5
    80004776:	00000097          	auipc	ra,0x0
    8000477a:	e94080e7          	jalr	-364(ra) # 8000460a <bget>
    8000477e:	fea43423          	sd	a0,-24(s0)
  if(!b->valid) {
    80004782:	fe843783          	ld	a5,-24(s0)
    80004786:	439c                	lw	a5,0(a5)
    80004788:	ef81                	bnez	a5,800047a0 <bread+0x4c>
    virtio_disk_rw(b, 0);
    8000478a:	4581                	li	a1,0
    8000478c:	fe843503          	ld	a0,-24(s0)
    80004790:	00005097          	auipc	ra,0x5
    80004794:	82a080e7          	jalr	-2006(ra) # 80008fba <virtio_disk_rw>
    b->valid = 1;
    80004798:	fe843783          	ld	a5,-24(s0)
    8000479c:	4705                	li	a4,1
    8000479e:	c398                	sw	a4,0(a5)
  }
  return b;
    800047a0:	fe843783          	ld	a5,-24(s0)
}
    800047a4:	853e                	mv	a0,a5
    800047a6:	70a2                	ld	ra,40(sp)
    800047a8:	7402                	ld	s0,32(sp)
    800047aa:	6145                	addi	sp,sp,48
    800047ac:	8082                	ret

00000000800047ae <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800047ae:	1101                	addi	sp,sp,-32
    800047b0:	ec06                	sd	ra,24(sp)
    800047b2:	e822                	sd	s0,16(sp)
    800047b4:	1000                	addi	s0,sp,32
    800047b6:	fea43423          	sd	a0,-24(s0)
  if(!holdingsleep(&b->lock))
    800047ba:	fe843783          	ld	a5,-24(s0)
    800047be:	07c1                	addi	a5,a5,16
    800047c0:	853e                	mv	a0,a5
    800047c2:	00002097          	auipc	ra,0x2
    800047c6:	ede080e7          	jalr	-290(ra) # 800066a0 <holdingsleep>
    800047ca:	87aa                	mv	a5,a0
    800047cc:	eb89                	bnez	a5,800047de <bwrite+0x30>
    panic("bwrite");
    800047ce:	00007517          	auipc	a0,0x7
    800047d2:	c8250513          	addi	a0,a0,-894 # 8000b450 <etext+0x450>
    800047d6:	ffffc097          	auipc	ra,0xffffc
    800047da:	4ea080e7          	jalr	1258(ra) # 80000cc0 <panic>
  virtio_disk_rw(b, 1);
    800047de:	4585                	li	a1,1
    800047e0:	fe843503          	ld	a0,-24(s0)
    800047e4:	00004097          	auipc	ra,0x4
    800047e8:	7d6080e7          	jalr	2006(ra) # 80008fba <virtio_disk_rw>
}
    800047ec:	0001                	nop
    800047ee:	60e2                	ld	ra,24(sp)
    800047f0:	6442                	ld	s0,16(sp)
    800047f2:	6105                	addi	sp,sp,32
    800047f4:	8082                	ret

00000000800047f6 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800047f6:	1101                	addi	sp,sp,-32
    800047f8:	ec06                	sd	ra,24(sp)
    800047fa:	e822                	sd	s0,16(sp)
    800047fc:	1000                	addi	s0,sp,32
    800047fe:	fea43423          	sd	a0,-24(s0)
  if(!holdingsleep(&b->lock))
    80004802:	fe843783          	ld	a5,-24(s0)
    80004806:	07c1                	addi	a5,a5,16
    80004808:	853e                	mv	a0,a5
    8000480a:	00002097          	auipc	ra,0x2
    8000480e:	e96080e7          	jalr	-362(ra) # 800066a0 <holdingsleep>
    80004812:	87aa                	mv	a5,a0
    80004814:	eb89                	bnez	a5,80004826 <brelse+0x30>
    panic("brelse");
    80004816:	00007517          	auipc	a0,0x7
    8000481a:	c4250513          	addi	a0,a0,-958 # 8000b458 <etext+0x458>
    8000481e:	ffffc097          	auipc	ra,0xffffc
    80004822:	4a2080e7          	jalr	1186(ra) # 80000cc0 <panic>

  releasesleep(&b->lock);
    80004826:	fe843783          	ld	a5,-24(s0)
    8000482a:	07c1                	addi	a5,a5,16
    8000482c:	853e                	mv	a0,a5
    8000482e:	00002097          	auipc	ra,0x2
    80004832:	e20080e7          	jalr	-480(ra) # 8000664e <releasesleep>

  acquire(&bcache.lock);
    80004836:	00015517          	auipc	a0,0x15
    8000483a:	16a50513          	addi	a0,a0,362 # 800199a0 <bcache>
    8000483e:	ffffd097          	auipc	ra,0xffffd
    80004842:	a86080e7          	jalr	-1402(ra) # 800012c4 <acquire>
  b->refcnt--;
    80004846:	fe843783          	ld	a5,-24(s0)
    8000484a:	43bc                	lw	a5,64(a5)
    8000484c:	37fd                	addiw	a5,a5,-1
    8000484e:	0007871b          	sext.w	a4,a5
    80004852:	fe843783          	ld	a5,-24(s0)
    80004856:	c3b8                	sw	a4,64(a5)
  if (b->refcnt == 0) {
    80004858:	fe843783          	ld	a5,-24(s0)
    8000485c:	43bc                	lw	a5,64(a5)
    8000485e:	e7b5                	bnez	a5,800048ca <brelse+0xd4>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80004860:	fe843783          	ld	a5,-24(s0)
    80004864:	6bbc                	ld	a5,80(a5)
    80004866:	fe843703          	ld	a4,-24(s0)
    8000486a:	6738                	ld	a4,72(a4)
    8000486c:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000486e:	fe843783          	ld	a5,-24(s0)
    80004872:	67bc                	ld	a5,72(a5)
    80004874:	fe843703          	ld	a4,-24(s0)
    80004878:	6b38                	ld	a4,80(a4)
    8000487a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000487c:	00015717          	auipc	a4,0x15
    80004880:	12470713          	addi	a4,a4,292 # 800199a0 <bcache>
    80004884:	67a1                	lui	a5,0x8
    80004886:	97ba                	add	a5,a5,a4
    80004888:	2b87b703          	ld	a4,696(a5) # 82b8 <_entry-0x7fff7d48>
    8000488c:	fe843783          	ld	a5,-24(s0)
    80004890:	ebb8                	sd	a4,80(a5)
    b->prev = &bcache.head;
    80004892:	fe843783          	ld	a5,-24(s0)
    80004896:	0001d717          	auipc	a4,0x1d
    8000489a:	37270713          	addi	a4,a4,882 # 80021c08 <bcache+0x8268>
    8000489e:	e7b8                	sd	a4,72(a5)
    bcache.head.next->prev = b;
    800048a0:	00015717          	auipc	a4,0x15
    800048a4:	10070713          	addi	a4,a4,256 # 800199a0 <bcache>
    800048a8:	67a1                	lui	a5,0x8
    800048aa:	97ba                	add	a5,a5,a4
    800048ac:	2b87b783          	ld	a5,696(a5) # 82b8 <_entry-0x7fff7d48>
    800048b0:	fe843703          	ld	a4,-24(s0)
    800048b4:	e7b8                	sd	a4,72(a5)
    bcache.head.next = b;
    800048b6:	00015717          	auipc	a4,0x15
    800048ba:	0ea70713          	addi	a4,a4,234 # 800199a0 <bcache>
    800048be:	67a1                	lui	a5,0x8
    800048c0:	97ba                	add	a5,a5,a4
    800048c2:	fe843703          	ld	a4,-24(s0)
    800048c6:	2ae7bc23          	sd	a4,696(a5) # 82b8 <_entry-0x7fff7d48>
  }
  
  release(&bcache.lock);
    800048ca:	00015517          	auipc	a0,0x15
    800048ce:	0d650513          	addi	a0,a0,214 # 800199a0 <bcache>
    800048d2:	ffffd097          	auipc	ra,0xffffd
    800048d6:	a56080e7          	jalr	-1450(ra) # 80001328 <release>
}
    800048da:	0001                	nop
    800048dc:	60e2                	ld	ra,24(sp)
    800048de:	6442                	ld	s0,16(sp)
    800048e0:	6105                	addi	sp,sp,32
    800048e2:	8082                	ret

00000000800048e4 <bpin>:

void
bpin(struct buf *b) {
    800048e4:	1101                	addi	sp,sp,-32
    800048e6:	ec06                	sd	ra,24(sp)
    800048e8:	e822                	sd	s0,16(sp)
    800048ea:	1000                	addi	s0,sp,32
    800048ec:	fea43423          	sd	a0,-24(s0)
  acquire(&bcache.lock);
    800048f0:	00015517          	auipc	a0,0x15
    800048f4:	0b050513          	addi	a0,a0,176 # 800199a0 <bcache>
    800048f8:	ffffd097          	auipc	ra,0xffffd
    800048fc:	9cc080e7          	jalr	-1588(ra) # 800012c4 <acquire>
  b->refcnt++;
    80004900:	fe843783          	ld	a5,-24(s0)
    80004904:	43bc                	lw	a5,64(a5)
    80004906:	2785                	addiw	a5,a5,1
    80004908:	0007871b          	sext.w	a4,a5
    8000490c:	fe843783          	ld	a5,-24(s0)
    80004910:	c3b8                	sw	a4,64(a5)
  release(&bcache.lock);
    80004912:	00015517          	auipc	a0,0x15
    80004916:	08e50513          	addi	a0,a0,142 # 800199a0 <bcache>
    8000491a:	ffffd097          	auipc	ra,0xffffd
    8000491e:	a0e080e7          	jalr	-1522(ra) # 80001328 <release>
}
    80004922:	0001                	nop
    80004924:	60e2                	ld	ra,24(sp)
    80004926:	6442                	ld	s0,16(sp)
    80004928:	6105                	addi	sp,sp,32
    8000492a:	8082                	ret

000000008000492c <bunpin>:

void
bunpin(struct buf *b) {
    8000492c:	1101                	addi	sp,sp,-32
    8000492e:	ec06                	sd	ra,24(sp)
    80004930:	e822                	sd	s0,16(sp)
    80004932:	1000                	addi	s0,sp,32
    80004934:	fea43423          	sd	a0,-24(s0)
  acquire(&bcache.lock);
    80004938:	00015517          	auipc	a0,0x15
    8000493c:	06850513          	addi	a0,a0,104 # 800199a0 <bcache>
    80004940:	ffffd097          	auipc	ra,0xffffd
    80004944:	984080e7          	jalr	-1660(ra) # 800012c4 <acquire>
  b->refcnt--;
    80004948:	fe843783          	ld	a5,-24(s0)
    8000494c:	43bc                	lw	a5,64(a5)
    8000494e:	37fd                	addiw	a5,a5,-1
    80004950:	0007871b          	sext.w	a4,a5
    80004954:	fe843783          	ld	a5,-24(s0)
    80004958:	c3b8                	sw	a4,64(a5)
  release(&bcache.lock);
    8000495a:	00015517          	auipc	a0,0x15
    8000495e:	04650513          	addi	a0,a0,70 # 800199a0 <bcache>
    80004962:	ffffd097          	auipc	ra,0xffffd
    80004966:	9c6080e7          	jalr	-1594(ra) # 80001328 <release>
}
    8000496a:	0001                	nop
    8000496c:	60e2                	ld	ra,24(sp)
    8000496e:	6442                	ld	s0,16(sp)
    80004970:	6105                	addi	sp,sp,32
    80004972:	8082                	ret

0000000080004974 <readsb>:
struct superblock sb; 

// Read the super block.
static void
readsb(int dev, struct superblock *sb)
{
    80004974:	7179                	addi	sp,sp,-48
    80004976:	f406                	sd	ra,40(sp)
    80004978:	f022                	sd	s0,32(sp)
    8000497a:	1800                	addi	s0,sp,48
    8000497c:	87aa                	mv	a5,a0
    8000497e:	fcb43823          	sd	a1,-48(s0)
    80004982:	fcf42e23          	sw	a5,-36(s0)
  struct buf *bp;

  bp = bread(dev, 1);
    80004986:	fdc42783          	lw	a5,-36(s0)
    8000498a:	4585                	li	a1,1
    8000498c:	853e                	mv	a0,a5
    8000498e:	00000097          	auipc	ra,0x0
    80004992:	dc6080e7          	jalr	-570(ra) # 80004754 <bread>
    80004996:	fea43423          	sd	a0,-24(s0)
  memmove(sb, bp->data, sizeof(*sb));
    8000499a:	fe843783          	ld	a5,-24(s0)
    8000499e:	05878793          	addi	a5,a5,88
    800049a2:	02000613          	li	a2,32
    800049a6:	85be                	mv	a1,a5
    800049a8:	fd043503          	ld	a0,-48(s0)
    800049ac:	ffffd097          	auipc	ra,0xffffd
    800049b0:	bd8080e7          	jalr	-1064(ra) # 80001584 <memmove>
  brelse(bp);
    800049b4:	fe843503          	ld	a0,-24(s0)
    800049b8:	00000097          	auipc	ra,0x0
    800049bc:	e3e080e7          	jalr	-450(ra) # 800047f6 <brelse>
}
    800049c0:	0001                	nop
    800049c2:	70a2                	ld	ra,40(sp)
    800049c4:	7402                	ld	s0,32(sp)
    800049c6:	6145                	addi	sp,sp,48
    800049c8:	8082                	ret

00000000800049ca <fsinit>:

// Init fs
void
fsinit(int dev) {
    800049ca:	1101                	addi	sp,sp,-32
    800049cc:	ec06                	sd	ra,24(sp)
    800049ce:	e822                	sd	s0,16(sp)
    800049d0:	1000                	addi	s0,sp,32
    800049d2:	87aa                	mv	a5,a0
    800049d4:	fef42623          	sw	a5,-20(s0)
  readsb(dev, &sb);
    800049d8:	fec42783          	lw	a5,-20(s0)
    800049dc:	0001d597          	auipc	a1,0x1d
    800049e0:	68458593          	addi	a1,a1,1668 # 80022060 <sb>
    800049e4:	853e                	mv	a0,a5
    800049e6:	00000097          	auipc	ra,0x0
    800049ea:	f8e080e7          	jalr	-114(ra) # 80004974 <readsb>
  if(sb.magic != FSMAGIC)
    800049ee:	0001d797          	auipc	a5,0x1d
    800049f2:	67278793          	addi	a5,a5,1650 # 80022060 <sb>
    800049f6:	4398                	lw	a4,0(a5)
    800049f8:	102037b7          	lui	a5,0x10203
    800049fc:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80004a00:	00f70a63          	beq	a4,a5,80004a14 <fsinit+0x4a>
    panic("invalid file system");
    80004a04:	00007517          	auipc	a0,0x7
    80004a08:	a5c50513          	addi	a0,a0,-1444 # 8000b460 <etext+0x460>
    80004a0c:	ffffc097          	auipc	ra,0xffffc
    80004a10:	2b4080e7          	jalr	692(ra) # 80000cc0 <panic>
  initlog(dev, &sb);
    80004a14:	fec42783          	lw	a5,-20(s0)
    80004a18:	0001d597          	auipc	a1,0x1d
    80004a1c:	64858593          	addi	a1,a1,1608 # 80022060 <sb>
    80004a20:	853e                	mv	a0,a5
    80004a22:	00001097          	auipc	ra,0x1
    80004a26:	478080e7          	jalr	1144(ra) # 80005e9a <initlog>
}
    80004a2a:	0001                	nop
    80004a2c:	60e2                	ld	ra,24(sp)
    80004a2e:	6442                	ld	s0,16(sp)
    80004a30:	6105                	addi	sp,sp,32
    80004a32:	8082                	ret

0000000080004a34 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
    80004a34:	7179                	addi	sp,sp,-48
    80004a36:	f406                	sd	ra,40(sp)
    80004a38:	f022                	sd	s0,32(sp)
    80004a3a:	1800                	addi	s0,sp,48
    80004a3c:	87aa                	mv	a5,a0
    80004a3e:	872e                	mv	a4,a1
    80004a40:	fcf42e23          	sw	a5,-36(s0)
    80004a44:	87ba                	mv	a5,a4
    80004a46:	fcf42c23          	sw	a5,-40(s0)
  struct buf *bp;

  bp = bread(dev, bno);
    80004a4a:	fdc42783          	lw	a5,-36(s0)
    80004a4e:	fd842703          	lw	a4,-40(s0)
    80004a52:	85ba                	mv	a1,a4
    80004a54:	853e                	mv	a0,a5
    80004a56:	00000097          	auipc	ra,0x0
    80004a5a:	cfe080e7          	jalr	-770(ra) # 80004754 <bread>
    80004a5e:	fea43423          	sd	a0,-24(s0)
  memset(bp->data, 0, BSIZE);
    80004a62:	fe843783          	ld	a5,-24(s0)
    80004a66:	05878793          	addi	a5,a5,88
    80004a6a:	40000613          	li	a2,1024
    80004a6e:	4581                	li	a1,0
    80004a70:	853e                	mv	a0,a5
    80004a72:	ffffd097          	auipc	ra,0xffffd
    80004a76:	a26080e7          	jalr	-1498(ra) # 80001498 <memset>
  log_write(bp);
    80004a7a:	fe843503          	ld	a0,-24(s0)
    80004a7e:	00002097          	auipc	ra,0x2
    80004a82:	9e8080e7          	jalr	-1560(ra) # 80006466 <log_write>
  brelse(bp);
    80004a86:	fe843503          	ld	a0,-24(s0)
    80004a8a:	00000097          	auipc	ra,0x0
    80004a8e:	d6c080e7          	jalr	-660(ra) # 800047f6 <brelse>
}
    80004a92:	0001                	nop
    80004a94:	70a2                	ld	ra,40(sp)
    80004a96:	7402                	ld	s0,32(sp)
    80004a98:	6145                	addi	sp,sp,48
    80004a9a:	8082                	ret

0000000080004a9c <balloc>:

// Allocate a zeroed disk block.
// returns 0 if out of disk space.
static uint
balloc(uint dev)
{
    80004a9c:	7139                	addi	sp,sp,-64
    80004a9e:	fc06                	sd	ra,56(sp)
    80004aa0:	f822                	sd	s0,48(sp)
    80004aa2:	0080                	addi	s0,sp,64
    80004aa4:	87aa                	mv	a5,a0
    80004aa6:	fcf42623          	sw	a5,-52(s0)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
    80004aaa:	fe043023          	sd	zero,-32(s0)
  for(b = 0; b < sb.size; b += BPB){
    80004aae:	fe042623          	sw	zero,-20(s0)
    80004ab2:	aab9                	j	80004c10 <balloc+0x174>
    bp = bread(dev, BBLOCK(b, sb));
    80004ab4:	fec42783          	lw	a5,-20(s0)
    80004ab8:	41f7d71b          	sraiw	a4,a5,0x1f
    80004abc:	0137571b          	srliw	a4,a4,0x13
    80004ac0:	9fb9                	addw	a5,a5,a4
    80004ac2:	40d7d79b          	sraiw	a5,a5,0xd
    80004ac6:	2781                	sext.w	a5,a5
    80004ac8:	873e                	mv	a4,a5
    80004aca:	0001d797          	auipc	a5,0x1d
    80004ace:	59678793          	addi	a5,a5,1430 # 80022060 <sb>
    80004ad2:	4fdc                	lw	a5,28(a5)
    80004ad4:	9fb9                	addw	a5,a5,a4
    80004ad6:	0007871b          	sext.w	a4,a5
    80004ada:	fcc42783          	lw	a5,-52(s0)
    80004ade:	85ba                	mv	a1,a4
    80004ae0:	853e                	mv	a0,a5
    80004ae2:	00000097          	auipc	ra,0x0
    80004ae6:	c72080e7          	jalr	-910(ra) # 80004754 <bread>
    80004aea:	fea43023          	sd	a0,-32(s0)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80004aee:	fe042423          	sw	zero,-24(s0)
    80004af2:	a8e1                	j	80004bca <balloc+0x12e>
      m = 1 << (bi % 8);
    80004af4:	fe842783          	lw	a5,-24(s0)
    80004af8:	8b9d                	andi	a5,a5,7
    80004afa:	2781                	sext.w	a5,a5
    80004afc:	4705                	li	a4,1
    80004afe:	00f717bb          	sllw	a5,a4,a5
    80004b02:	fcf42e23          	sw	a5,-36(s0)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80004b06:	fe842783          	lw	a5,-24(s0)
    80004b0a:	41f7d71b          	sraiw	a4,a5,0x1f
    80004b0e:	01d7571b          	srliw	a4,a4,0x1d
    80004b12:	9fb9                	addw	a5,a5,a4
    80004b14:	4037d79b          	sraiw	a5,a5,0x3
    80004b18:	2781                	sext.w	a5,a5
    80004b1a:	fe043703          	ld	a4,-32(s0)
    80004b1e:	97ba                	add	a5,a5,a4
    80004b20:	0587c783          	lbu	a5,88(a5)
    80004b24:	2781                	sext.w	a5,a5
    80004b26:	fdc42703          	lw	a4,-36(s0)
    80004b2a:	8ff9                	and	a5,a5,a4
    80004b2c:	2781                	sext.w	a5,a5
    80004b2e:	ebc9                	bnez	a5,80004bc0 <balloc+0x124>
        bp->data[bi/8] |= m;  // Mark block in use.
    80004b30:	fe842783          	lw	a5,-24(s0)
    80004b34:	41f7d71b          	sraiw	a4,a5,0x1f
    80004b38:	01d7571b          	srliw	a4,a4,0x1d
    80004b3c:	9fb9                	addw	a5,a5,a4
    80004b3e:	4037d79b          	sraiw	a5,a5,0x3
    80004b42:	2781                	sext.w	a5,a5
    80004b44:	fe043703          	ld	a4,-32(s0)
    80004b48:	973e                	add	a4,a4,a5
    80004b4a:	05874703          	lbu	a4,88(a4)
    80004b4e:	0187169b          	slliw	a3,a4,0x18
    80004b52:	4186d69b          	sraiw	a3,a3,0x18
    80004b56:	fdc42703          	lw	a4,-36(s0)
    80004b5a:	0187171b          	slliw	a4,a4,0x18
    80004b5e:	4187571b          	sraiw	a4,a4,0x18
    80004b62:	8f55                	or	a4,a4,a3
    80004b64:	0187171b          	slliw	a4,a4,0x18
    80004b68:	4187571b          	sraiw	a4,a4,0x18
    80004b6c:	0ff77713          	zext.b	a4,a4
    80004b70:	fe043683          	ld	a3,-32(s0)
    80004b74:	97b6                	add	a5,a5,a3
    80004b76:	04e78c23          	sb	a4,88(a5)
        log_write(bp);
    80004b7a:	fe043503          	ld	a0,-32(s0)
    80004b7e:	00002097          	auipc	ra,0x2
    80004b82:	8e8080e7          	jalr	-1816(ra) # 80006466 <log_write>
        brelse(bp);
    80004b86:	fe043503          	ld	a0,-32(s0)
    80004b8a:	00000097          	auipc	ra,0x0
    80004b8e:	c6c080e7          	jalr	-916(ra) # 800047f6 <brelse>
        bzero(dev, b + bi);
    80004b92:	fcc42783          	lw	a5,-52(s0)
    80004b96:	fec42703          	lw	a4,-20(s0)
    80004b9a:	86ba                	mv	a3,a4
    80004b9c:	fe842703          	lw	a4,-24(s0)
    80004ba0:	9f35                	addw	a4,a4,a3
    80004ba2:	2701                	sext.w	a4,a4
    80004ba4:	85ba                	mv	a1,a4
    80004ba6:	853e                	mv	a0,a5
    80004ba8:	00000097          	auipc	ra,0x0
    80004bac:	e8c080e7          	jalr	-372(ra) # 80004a34 <bzero>
        return b + bi;
    80004bb0:	fec42783          	lw	a5,-20(s0)
    80004bb4:	873e                	mv	a4,a5
    80004bb6:	fe842783          	lw	a5,-24(s0)
    80004bba:	9fb9                	addw	a5,a5,a4
    80004bbc:	2781                	sext.w	a5,a5
    80004bbe:	a89d                	j	80004c34 <balloc+0x198>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80004bc0:	fe842783          	lw	a5,-24(s0)
    80004bc4:	2785                	addiw	a5,a5,1
    80004bc6:	fef42423          	sw	a5,-24(s0)
    80004bca:	fe842783          	lw	a5,-24(s0)
    80004bce:	0007871b          	sext.w	a4,a5
    80004bd2:	6789                	lui	a5,0x2
    80004bd4:	02f75163          	bge	a4,a5,80004bf6 <balloc+0x15a>
    80004bd8:	fec42783          	lw	a5,-20(s0)
    80004bdc:	873e                	mv	a4,a5
    80004bde:	fe842783          	lw	a5,-24(s0)
    80004be2:	9fb9                	addw	a5,a5,a4
    80004be4:	2781                	sext.w	a5,a5
    80004be6:	873e                	mv	a4,a5
    80004be8:	0001d797          	auipc	a5,0x1d
    80004bec:	47878793          	addi	a5,a5,1144 # 80022060 <sb>
    80004bf0:	43dc                	lw	a5,4(a5)
    80004bf2:	f0f761e3          	bltu	a4,a5,80004af4 <balloc+0x58>
      }
    }
    brelse(bp);
    80004bf6:	fe043503          	ld	a0,-32(s0)
    80004bfa:	00000097          	auipc	ra,0x0
    80004bfe:	bfc080e7          	jalr	-1028(ra) # 800047f6 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80004c02:	fec42783          	lw	a5,-20(s0)
    80004c06:	873e                	mv	a4,a5
    80004c08:	6789                	lui	a5,0x2
    80004c0a:	9fb9                	addw	a5,a5,a4
    80004c0c:	fef42623          	sw	a5,-20(s0)
    80004c10:	0001d797          	auipc	a5,0x1d
    80004c14:	45078793          	addi	a5,a5,1104 # 80022060 <sb>
    80004c18:	43d8                	lw	a4,4(a5)
    80004c1a:	fec42783          	lw	a5,-20(s0)
    80004c1e:	e8e7ebe3          	bltu	a5,a4,80004ab4 <balloc+0x18>
  }
  printf("balloc: out of blocks\n");
    80004c22:	00007517          	auipc	a0,0x7
    80004c26:	85650513          	addi	a0,a0,-1962 # 8000b478 <etext+0x478>
    80004c2a:	ffffc097          	auipc	ra,0xffffc
    80004c2e:	e40080e7          	jalr	-448(ra) # 80000a6a <printf>
  return 0;
    80004c32:	4781                	li	a5,0
}
    80004c34:	853e                	mv	a0,a5
    80004c36:	70e2                	ld	ra,56(sp)
    80004c38:	7442                	ld	s0,48(sp)
    80004c3a:	6121                	addi	sp,sp,64
    80004c3c:	8082                	ret

0000000080004c3e <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80004c3e:	7179                	addi	sp,sp,-48
    80004c40:	f406                	sd	ra,40(sp)
    80004c42:	f022                	sd	s0,32(sp)
    80004c44:	1800                	addi	s0,sp,48
    80004c46:	87aa                	mv	a5,a0
    80004c48:	872e                	mv	a4,a1
    80004c4a:	fcf42e23          	sw	a5,-36(s0)
    80004c4e:	87ba                	mv	a5,a4
    80004c50:	fcf42c23          	sw	a5,-40(s0)
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80004c54:	fdc42683          	lw	a3,-36(s0)
    80004c58:	fd842783          	lw	a5,-40(s0)
    80004c5c:	00d7d79b          	srliw	a5,a5,0xd
    80004c60:	0007871b          	sext.w	a4,a5
    80004c64:	0001d797          	auipc	a5,0x1d
    80004c68:	3fc78793          	addi	a5,a5,1020 # 80022060 <sb>
    80004c6c:	4fdc                	lw	a5,28(a5)
    80004c6e:	9fb9                	addw	a5,a5,a4
    80004c70:	2781                	sext.w	a5,a5
    80004c72:	85be                	mv	a1,a5
    80004c74:	8536                	mv	a0,a3
    80004c76:	00000097          	auipc	ra,0x0
    80004c7a:	ade080e7          	jalr	-1314(ra) # 80004754 <bread>
    80004c7e:	fea43423          	sd	a0,-24(s0)
  bi = b % BPB;
    80004c82:	fd842703          	lw	a4,-40(s0)
    80004c86:	6789                	lui	a5,0x2
    80004c88:	17fd                	addi	a5,a5,-1 # 1fff <_entry-0x7fffe001>
    80004c8a:	8ff9                	and	a5,a5,a4
    80004c8c:	fef42223          	sw	a5,-28(s0)
  m = 1 << (bi % 8);
    80004c90:	fe442783          	lw	a5,-28(s0)
    80004c94:	8b9d                	andi	a5,a5,7
    80004c96:	2781                	sext.w	a5,a5
    80004c98:	4705                	li	a4,1
    80004c9a:	00f717bb          	sllw	a5,a4,a5
    80004c9e:	fef42023          	sw	a5,-32(s0)
  if((bp->data[bi/8] & m) == 0)
    80004ca2:	fe442783          	lw	a5,-28(s0)
    80004ca6:	41f7d71b          	sraiw	a4,a5,0x1f
    80004caa:	01d7571b          	srliw	a4,a4,0x1d
    80004cae:	9fb9                	addw	a5,a5,a4
    80004cb0:	4037d79b          	sraiw	a5,a5,0x3
    80004cb4:	2781                	sext.w	a5,a5
    80004cb6:	fe843703          	ld	a4,-24(s0)
    80004cba:	97ba                	add	a5,a5,a4
    80004cbc:	0587c783          	lbu	a5,88(a5)
    80004cc0:	2781                	sext.w	a5,a5
    80004cc2:	fe042703          	lw	a4,-32(s0)
    80004cc6:	8ff9                	and	a5,a5,a4
    80004cc8:	2781                	sext.w	a5,a5
    80004cca:	eb89                	bnez	a5,80004cdc <bfree+0x9e>
    panic("freeing free block");
    80004ccc:	00006517          	auipc	a0,0x6
    80004cd0:	7c450513          	addi	a0,a0,1988 # 8000b490 <etext+0x490>
    80004cd4:	ffffc097          	auipc	ra,0xffffc
    80004cd8:	fec080e7          	jalr	-20(ra) # 80000cc0 <panic>
  bp->data[bi/8] &= ~m;
    80004cdc:	fe442783          	lw	a5,-28(s0)
    80004ce0:	41f7d71b          	sraiw	a4,a5,0x1f
    80004ce4:	01d7571b          	srliw	a4,a4,0x1d
    80004ce8:	9fb9                	addw	a5,a5,a4
    80004cea:	4037d79b          	sraiw	a5,a5,0x3
    80004cee:	2781                	sext.w	a5,a5
    80004cf0:	fe843703          	ld	a4,-24(s0)
    80004cf4:	973e                	add	a4,a4,a5
    80004cf6:	05874703          	lbu	a4,88(a4)
    80004cfa:	0187169b          	slliw	a3,a4,0x18
    80004cfe:	4186d69b          	sraiw	a3,a3,0x18
    80004d02:	fe042703          	lw	a4,-32(s0)
    80004d06:	0187171b          	slliw	a4,a4,0x18
    80004d0a:	4187571b          	sraiw	a4,a4,0x18
    80004d0e:	fff74713          	not	a4,a4
    80004d12:	0187171b          	slliw	a4,a4,0x18
    80004d16:	4187571b          	sraiw	a4,a4,0x18
    80004d1a:	8f75                	and	a4,a4,a3
    80004d1c:	0187171b          	slliw	a4,a4,0x18
    80004d20:	4187571b          	sraiw	a4,a4,0x18
    80004d24:	0ff77713          	zext.b	a4,a4
    80004d28:	fe843683          	ld	a3,-24(s0)
    80004d2c:	97b6                	add	a5,a5,a3
    80004d2e:	04e78c23          	sb	a4,88(a5)
  log_write(bp);
    80004d32:	fe843503          	ld	a0,-24(s0)
    80004d36:	00001097          	auipc	ra,0x1
    80004d3a:	730080e7          	jalr	1840(ra) # 80006466 <log_write>
  brelse(bp);
    80004d3e:	fe843503          	ld	a0,-24(s0)
    80004d42:	00000097          	auipc	ra,0x0
    80004d46:	ab4080e7          	jalr	-1356(ra) # 800047f6 <brelse>
}
    80004d4a:	0001                	nop
    80004d4c:	70a2                	ld	ra,40(sp)
    80004d4e:	7402                	ld	s0,32(sp)
    80004d50:	6145                	addi	sp,sp,48
    80004d52:	8082                	ret

0000000080004d54 <iinit>:
  struct inode inode[NINODE];
} itable;

void
iinit()
{
    80004d54:	1101                	addi	sp,sp,-32
    80004d56:	ec06                	sd	ra,24(sp)
    80004d58:	e822                	sd	s0,16(sp)
    80004d5a:	1000                	addi	s0,sp,32
  int i = 0;
    80004d5c:	fe042623          	sw	zero,-20(s0)
  
  initlock(&itable.lock, "itable");
    80004d60:	00006597          	auipc	a1,0x6
    80004d64:	74858593          	addi	a1,a1,1864 # 8000b4a8 <etext+0x4a8>
    80004d68:	0001d517          	auipc	a0,0x1d
    80004d6c:	31850513          	addi	a0,a0,792 # 80022080 <itable>
    80004d70:	ffffc097          	auipc	ra,0xffffc
    80004d74:	520080e7          	jalr	1312(ra) # 80001290 <initlock>
  for(i = 0; i < NINODE; i++) {
    80004d78:	fe042623          	sw	zero,-20(s0)
    80004d7c:	a82d                	j	80004db6 <iinit+0x62>
    initsleeplock(&itable.inode[i].lock, "inode");
    80004d7e:	fec42703          	lw	a4,-20(s0)
    80004d82:	87ba                	mv	a5,a4
    80004d84:	0792                	slli	a5,a5,0x4
    80004d86:	97ba                	add	a5,a5,a4
    80004d88:	078e                	slli	a5,a5,0x3
    80004d8a:	02078713          	addi	a4,a5,32
    80004d8e:	0001d797          	auipc	a5,0x1d
    80004d92:	2f278793          	addi	a5,a5,754 # 80022080 <itable>
    80004d96:	97ba                	add	a5,a5,a4
    80004d98:	07a1                	addi	a5,a5,8
    80004d9a:	00006597          	auipc	a1,0x6
    80004d9e:	71658593          	addi	a1,a1,1814 # 8000b4b0 <etext+0x4b0>
    80004da2:	853e                	mv	a0,a5
    80004da4:	00001097          	auipc	ra,0x1
    80004da8:	7f0080e7          	jalr	2032(ra) # 80006594 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80004dac:	fec42783          	lw	a5,-20(s0)
    80004db0:	2785                	addiw	a5,a5,1
    80004db2:	fef42623          	sw	a5,-20(s0)
    80004db6:	fec42783          	lw	a5,-20(s0)
    80004dba:	0007871b          	sext.w	a4,a5
    80004dbe:	03100793          	li	a5,49
    80004dc2:	fae7dee3          	bge	a5,a4,80004d7e <iinit+0x2a>
  }
}
    80004dc6:	0001                	nop
    80004dc8:	0001                	nop
    80004dca:	60e2                	ld	ra,24(sp)
    80004dcc:	6442                	ld	s0,16(sp)
    80004dce:	6105                	addi	sp,sp,32
    80004dd0:	8082                	ret

0000000080004dd2 <ialloc>:
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode,
// or NULL if there is no free inode.
struct inode*
ialloc(uint dev, short type)
{
    80004dd2:	7139                	addi	sp,sp,-64
    80004dd4:	fc06                	sd	ra,56(sp)
    80004dd6:	f822                	sd	s0,48(sp)
    80004dd8:	0080                	addi	s0,sp,64
    80004dda:	87aa                	mv	a5,a0
    80004ddc:	872e                	mv	a4,a1
    80004dde:	fcf42623          	sw	a5,-52(s0)
    80004de2:	87ba                	mv	a5,a4
    80004de4:	fcf41523          	sh	a5,-54(s0)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    80004de8:	4785                	li	a5,1
    80004dea:	fef42623          	sw	a5,-20(s0)
    80004dee:	a855                	j	80004ea2 <ialloc+0xd0>
    bp = bread(dev, IBLOCK(inum, sb));
    80004df0:	fec42783          	lw	a5,-20(s0)
    80004df4:	8391                	srli	a5,a5,0x4
    80004df6:	0007871b          	sext.w	a4,a5
    80004dfa:	0001d797          	auipc	a5,0x1d
    80004dfe:	26678793          	addi	a5,a5,614 # 80022060 <sb>
    80004e02:	4f9c                	lw	a5,24(a5)
    80004e04:	9fb9                	addw	a5,a5,a4
    80004e06:	0007871b          	sext.w	a4,a5
    80004e0a:	fcc42783          	lw	a5,-52(s0)
    80004e0e:	85ba                	mv	a1,a4
    80004e10:	853e                	mv	a0,a5
    80004e12:	00000097          	auipc	ra,0x0
    80004e16:	942080e7          	jalr	-1726(ra) # 80004754 <bread>
    80004e1a:	fea43023          	sd	a0,-32(s0)
    dip = (struct dinode*)bp->data + inum%IPB;
    80004e1e:	fe043783          	ld	a5,-32(s0)
    80004e22:	05878713          	addi	a4,a5,88
    80004e26:	fec42783          	lw	a5,-20(s0)
    80004e2a:	8bbd                	andi	a5,a5,15
    80004e2c:	079a                	slli	a5,a5,0x6
    80004e2e:	97ba                	add	a5,a5,a4
    80004e30:	fcf43c23          	sd	a5,-40(s0)
    if(dip->type == 0){  // a free inode
    80004e34:	fd843783          	ld	a5,-40(s0)
    80004e38:	00079783          	lh	a5,0(a5)
    80004e3c:	eba1                	bnez	a5,80004e8c <ialloc+0xba>
      memset(dip, 0, sizeof(*dip));
    80004e3e:	04000613          	li	a2,64
    80004e42:	4581                	li	a1,0
    80004e44:	fd843503          	ld	a0,-40(s0)
    80004e48:	ffffc097          	auipc	ra,0xffffc
    80004e4c:	650080e7          	jalr	1616(ra) # 80001498 <memset>
      dip->type = type;
    80004e50:	fd843783          	ld	a5,-40(s0)
    80004e54:	fca45703          	lhu	a4,-54(s0)
    80004e58:	00e79023          	sh	a4,0(a5)
      log_write(bp);   // mark it allocated on the disk
    80004e5c:	fe043503          	ld	a0,-32(s0)
    80004e60:	00001097          	auipc	ra,0x1
    80004e64:	606080e7          	jalr	1542(ra) # 80006466 <log_write>
      brelse(bp);
    80004e68:	fe043503          	ld	a0,-32(s0)
    80004e6c:	00000097          	auipc	ra,0x0
    80004e70:	98a080e7          	jalr	-1654(ra) # 800047f6 <brelse>
      return iget(dev, inum);
    80004e74:	fec42703          	lw	a4,-20(s0)
    80004e78:	fcc42783          	lw	a5,-52(s0)
    80004e7c:	85ba                	mv	a1,a4
    80004e7e:	853e                	mv	a0,a5
    80004e80:	00000097          	auipc	ra,0x0
    80004e84:	138080e7          	jalr	312(ra) # 80004fb8 <iget>
    80004e88:	87aa                	mv	a5,a0
    80004e8a:	a835                	j	80004ec6 <ialloc+0xf4>
    }
    brelse(bp);
    80004e8c:	fe043503          	ld	a0,-32(s0)
    80004e90:	00000097          	auipc	ra,0x0
    80004e94:	966080e7          	jalr	-1690(ra) # 800047f6 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80004e98:	fec42783          	lw	a5,-20(s0)
    80004e9c:	2785                	addiw	a5,a5,1
    80004e9e:	fef42623          	sw	a5,-20(s0)
    80004ea2:	0001d797          	auipc	a5,0x1d
    80004ea6:	1be78793          	addi	a5,a5,446 # 80022060 <sb>
    80004eaa:	47d8                	lw	a4,12(a5)
    80004eac:	fec42783          	lw	a5,-20(s0)
    80004eb0:	f4e7e0e3          	bltu	a5,a4,80004df0 <ialloc+0x1e>
  }
  printf("ialloc: no inodes\n");
    80004eb4:	00006517          	auipc	a0,0x6
    80004eb8:	60450513          	addi	a0,a0,1540 # 8000b4b8 <etext+0x4b8>
    80004ebc:	ffffc097          	auipc	ra,0xffffc
    80004ec0:	bae080e7          	jalr	-1106(ra) # 80000a6a <printf>
  return 0;
    80004ec4:	4781                	li	a5,0
}
    80004ec6:	853e                	mv	a0,a5
    80004ec8:	70e2                	ld	ra,56(sp)
    80004eca:	7442                	ld	s0,48(sp)
    80004ecc:	6121                	addi	sp,sp,64
    80004ece:	8082                	ret

0000000080004ed0 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
    80004ed0:	7179                	addi	sp,sp,-48
    80004ed2:	f406                	sd	ra,40(sp)
    80004ed4:	f022                	sd	s0,32(sp)
    80004ed6:	1800                	addi	s0,sp,48
    80004ed8:	fca43c23          	sd	a0,-40(s0)
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80004edc:	fd843783          	ld	a5,-40(s0)
    80004ee0:	4394                	lw	a3,0(a5)
    80004ee2:	fd843783          	ld	a5,-40(s0)
    80004ee6:	43dc                	lw	a5,4(a5)
    80004ee8:	0047d79b          	srliw	a5,a5,0x4
    80004eec:	0007871b          	sext.w	a4,a5
    80004ef0:	0001d797          	auipc	a5,0x1d
    80004ef4:	17078793          	addi	a5,a5,368 # 80022060 <sb>
    80004ef8:	4f9c                	lw	a5,24(a5)
    80004efa:	9fb9                	addw	a5,a5,a4
    80004efc:	2781                	sext.w	a5,a5
    80004efe:	85be                	mv	a1,a5
    80004f00:	8536                	mv	a0,a3
    80004f02:	00000097          	auipc	ra,0x0
    80004f06:	852080e7          	jalr	-1966(ra) # 80004754 <bread>
    80004f0a:	fea43423          	sd	a0,-24(s0)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80004f0e:	fe843783          	ld	a5,-24(s0)
    80004f12:	05878713          	addi	a4,a5,88
    80004f16:	fd843783          	ld	a5,-40(s0)
    80004f1a:	43dc                	lw	a5,4(a5)
    80004f1c:	1782                	slli	a5,a5,0x20
    80004f1e:	9381                	srli	a5,a5,0x20
    80004f20:	8bbd                	andi	a5,a5,15
    80004f22:	079a                	slli	a5,a5,0x6
    80004f24:	97ba                	add	a5,a5,a4
    80004f26:	fef43023          	sd	a5,-32(s0)
  dip->type = ip->type;
    80004f2a:	fd843783          	ld	a5,-40(s0)
    80004f2e:	04479703          	lh	a4,68(a5)
    80004f32:	fe043783          	ld	a5,-32(s0)
    80004f36:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80004f3a:	fd843783          	ld	a5,-40(s0)
    80004f3e:	04679703          	lh	a4,70(a5)
    80004f42:	fe043783          	ld	a5,-32(s0)
    80004f46:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80004f4a:	fd843783          	ld	a5,-40(s0)
    80004f4e:	04879703          	lh	a4,72(a5)
    80004f52:	fe043783          	ld	a5,-32(s0)
    80004f56:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80004f5a:	fd843783          	ld	a5,-40(s0)
    80004f5e:	04a79703          	lh	a4,74(a5)
    80004f62:	fe043783          	ld	a5,-32(s0)
    80004f66:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80004f6a:	fd843783          	ld	a5,-40(s0)
    80004f6e:	47f8                	lw	a4,76(a5)
    80004f70:	fe043783          	ld	a5,-32(s0)
    80004f74:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80004f76:	fe043783          	ld	a5,-32(s0)
    80004f7a:	00c78713          	addi	a4,a5,12
    80004f7e:	fd843783          	ld	a5,-40(s0)
    80004f82:	05078793          	addi	a5,a5,80
    80004f86:	03400613          	li	a2,52
    80004f8a:	85be                	mv	a1,a5
    80004f8c:	853a                	mv	a0,a4
    80004f8e:	ffffc097          	auipc	ra,0xffffc
    80004f92:	5f6080e7          	jalr	1526(ra) # 80001584 <memmove>
  log_write(bp);
    80004f96:	fe843503          	ld	a0,-24(s0)
    80004f9a:	00001097          	auipc	ra,0x1
    80004f9e:	4cc080e7          	jalr	1228(ra) # 80006466 <log_write>
  brelse(bp);
    80004fa2:	fe843503          	ld	a0,-24(s0)
    80004fa6:	00000097          	auipc	ra,0x0
    80004faa:	850080e7          	jalr	-1968(ra) # 800047f6 <brelse>
}
    80004fae:	0001                	nop
    80004fb0:	70a2                	ld	ra,40(sp)
    80004fb2:	7402                	ld	s0,32(sp)
    80004fb4:	6145                	addi	sp,sp,48
    80004fb6:	8082                	ret

0000000080004fb8 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
    80004fb8:	7179                	addi	sp,sp,-48
    80004fba:	f406                	sd	ra,40(sp)
    80004fbc:	f022                	sd	s0,32(sp)
    80004fbe:	1800                	addi	s0,sp,48
    80004fc0:	87aa                	mv	a5,a0
    80004fc2:	872e                	mv	a4,a1
    80004fc4:	fcf42e23          	sw	a5,-36(s0)
    80004fc8:	87ba                	mv	a5,a4
    80004fca:	fcf42c23          	sw	a5,-40(s0)
  struct inode *ip, *empty;

  acquire(&itable.lock);
    80004fce:	0001d517          	auipc	a0,0x1d
    80004fd2:	0b250513          	addi	a0,a0,178 # 80022080 <itable>
    80004fd6:	ffffc097          	auipc	ra,0xffffc
    80004fda:	2ee080e7          	jalr	750(ra) # 800012c4 <acquire>

  // Is the inode already in the table?
  empty = 0;
    80004fde:	fe043023          	sd	zero,-32(s0)
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80004fe2:	0001d797          	auipc	a5,0x1d
    80004fe6:	0b678793          	addi	a5,a5,182 # 80022098 <itable+0x18>
    80004fea:	fef43423          	sd	a5,-24(s0)
    80004fee:	a89d                	j	80005064 <iget+0xac>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80004ff0:	fe843783          	ld	a5,-24(s0)
    80004ff4:	479c                	lw	a5,8(a5)
    80004ff6:	04f05663          	blez	a5,80005042 <iget+0x8a>
    80004ffa:	fe843783          	ld	a5,-24(s0)
    80004ffe:	439c                	lw	a5,0(a5)
    80005000:	fdc42703          	lw	a4,-36(s0)
    80005004:	2701                	sext.w	a4,a4
    80005006:	02f71e63          	bne	a4,a5,80005042 <iget+0x8a>
    8000500a:	fe843783          	ld	a5,-24(s0)
    8000500e:	43dc                	lw	a5,4(a5)
    80005010:	fd842703          	lw	a4,-40(s0)
    80005014:	2701                	sext.w	a4,a4
    80005016:	02f71663          	bne	a4,a5,80005042 <iget+0x8a>
      ip->ref++;
    8000501a:	fe843783          	ld	a5,-24(s0)
    8000501e:	479c                	lw	a5,8(a5)
    80005020:	2785                	addiw	a5,a5,1
    80005022:	0007871b          	sext.w	a4,a5
    80005026:	fe843783          	ld	a5,-24(s0)
    8000502a:	c798                	sw	a4,8(a5)
      release(&itable.lock);
    8000502c:	0001d517          	auipc	a0,0x1d
    80005030:	05450513          	addi	a0,a0,84 # 80022080 <itable>
    80005034:	ffffc097          	auipc	ra,0xffffc
    80005038:	2f4080e7          	jalr	756(ra) # 80001328 <release>
      return ip;
    8000503c:	fe843783          	ld	a5,-24(s0)
    80005040:	a069                	j	800050ca <iget+0x112>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80005042:	fe043783          	ld	a5,-32(s0)
    80005046:	eb89                	bnez	a5,80005058 <iget+0xa0>
    80005048:	fe843783          	ld	a5,-24(s0)
    8000504c:	479c                	lw	a5,8(a5)
    8000504e:	e789                	bnez	a5,80005058 <iget+0xa0>
      empty = ip;
    80005050:	fe843783          	ld	a5,-24(s0)
    80005054:	fef43023          	sd	a5,-32(s0)
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80005058:	fe843783          	ld	a5,-24(s0)
    8000505c:	08878793          	addi	a5,a5,136
    80005060:	fef43423          	sd	a5,-24(s0)
    80005064:	fe843703          	ld	a4,-24(s0)
    80005068:	0001f797          	auipc	a5,0x1f
    8000506c:	ac078793          	addi	a5,a5,-1344 # 80023b28 <log>
    80005070:	f8f760e3          	bltu	a4,a5,80004ff0 <iget+0x38>
  }

  // Recycle an inode entry.
  if(empty == 0)
    80005074:	fe043783          	ld	a5,-32(s0)
    80005078:	eb89                	bnez	a5,8000508a <iget+0xd2>
    panic("iget: no inodes");
    8000507a:	00006517          	auipc	a0,0x6
    8000507e:	45650513          	addi	a0,a0,1110 # 8000b4d0 <etext+0x4d0>
    80005082:	ffffc097          	auipc	ra,0xffffc
    80005086:	c3e080e7          	jalr	-962(ra) # 80000cc0 <panic>

  ip = empty;
    8000508a:	fe043783          	ld	a5,-32(s0)
    8000508e:	fef43423          	sd	a5,-24(s0)
  ip->dev = dev;
    80005092:	fe843783          	ld	a5,-24(s0)
    80005096:	fdc42703          	lw	a4,-36(s0)
    8000509a:	c398                	sw	a4,0(a5)
  ip->inum = inum;
    8000509c:	fe843783          	ld	a5,-24(s0)
    800050a0:	fd842703          	lw	a4,-40(s0)
    800050a4:	c3d8                	sw	a4,4(a5)
  ip->ref = 1;
    800050a6:	fe843783          	ld	a5,-24(s0)
    800050aa:	4705                	li	a4,1
    800050ac:	c798                	sw	a4,8(a5)
  ip->valid = 0;
    800050ae:	fe843783          	ld	a5,-24(s0)
    800050b2:	0407a023          	sw	zero,64(a5)
  release(&itable.lock);
    800050b6:	0001d517          	auipc	a0,0x1d
    800050ba:	fca50513          	addi	a0,a0,-54 # 80022080 <itable>
    800050be:	ffffc097          	auipc	ra,0xffffc
    800050c2:	26a080e7          	jalr	618(ra) # 80001328 <release>

  return ip;
    800050c6:	fe843783          	ld	a5,-24(s0)
}
    800050ca:	853e                	mv	a0,a5
    800050cc:	70a2                	ld	ra,40(sp)
    800050ce:	7402                	ld	s0,32(sp)
    800050d0:	6145                	addi	sp,sp,48
    800050d2:	8082                	ret

00000000800050d4 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
    800050d4:	1101                	addi	sp,sp,-32
    800050d6:	ec06                	sd	ra,24(sp)
    800050d8:	e822                	sd	s0,16(sp)
    800050da:	1000                	addi	s0,sp,32
    800050dc:	fea43423          	sd	a0,-24(s0)
  acquire(&itable.lock);
    800050e0:	0001d517          	auipc	a0,0x1d
    800050e4:	fa050513          	addi	a0,a0,-96 # 80022080 <itable>
    800050e8:	ffffc097          	auipc	ra,0xffffc
    800050ec:	1dc080e7          	jalr	476(ra) # 800012c4 <acquire>
  ip->ref++;
    800050f0:	fe843783          	ld	a5,-24(s0)
    800050f4:	479c                	lw	a5,8(a5)
    800050f6:	2785                	addiw	a5,a5,1
    800050f8:	0007871b          	sext.w	a4,a5
    800050fc:	fe843783          	ld	a5,-24(s0)
    80005100:	c798                	sw	a4,8(a5)
  release(&itable.lock);
    80005102:	0001d517          	auipc	a0,0x1d
    80005106:	f7e50513          	addi	a0,a0,-130 # 80022080 <itable>
    8000510a:	ffffc097          	auipc	ra,0xffffc
    8000510e:	21e080e7          	jalr	542(ra) # 80001328 <release>
  return ip;
    80005112:	fe843783          	ld	a5,-24(s0)
}
    80005116:	853e                	mv	a0,a5
    80005118:	60e2                	ld	ra,24(sp)
    8000511a:	6442                	ld	s0,16(sp)
    8000511c:	6105                	addi	sp,sp,32
    8000511e:	8082                	ret

0000000080005120 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
    80005120:	7179                	addi	sp,sp,-48
    80005122:	f406                	sd	ra,40(sp)
    80005124:	f022                	sd	s0,32(sp)
    80005126:	1800                	addi	s0,sp,48
    80005128:	fca43c23          	sd	a0,-40(s0)
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    8000512c:	fd843783          	ld	a5,-40(s0)
    80005130:	c791                	beqz	a5,8000513c <ilock+0x1c>
    80005132:	fd843783          	ld	a5,-40(s0)
    80005136:	479c                	lw	a5,8(a5)
    80005138:	00f04a63          	bgtz	a5,8000514c <ilock+0x2c>
    panic("ilock");
    8000513c:	00006517          	auipc	a0,0x6
    80005140:	3a450513          	addi	a0,a0,932 # 8000b4e0 <etext+0x4e0>
    80005144:	ffffc097          	auipc	ra,0xffffc
    80005148:	b7c080e7          	jalr	-1156(ra) # 80000cc0 <panic>

  acquiresleep(&ip->lock);
    8000514c:	fd843783          	ld	a5,-40(s0)
    80005150:	07c1                	addi	a5,a5,16
    80005152:	853e                	mv	a0,a5
    80005154:	00001097          	auipc	ra,0x1
    80005158:	48c080e7          	jalr	1164(ra) # 800065e0 <acquiresleep>

  if(ip->valid == 0){
    8000515c:	fd843783          	ld	a5,-40(s0)
    80005160:	43bc                	lw	a5,64(a5)
    80005162:	e7e5                	bnez	a5,8000524a <ilock+0x12a>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80005164:	fd843783          	ld	a5,-40(s0)
    80005168:	4394                	lw	a3,0(a5)
    8000516a:	fd843783          	ld	a5,-40(s0)
    8000516e:	43dc                	lw	a5,4(a5)
    80005170:	0047d79b          	srliw	a5,a5,0x4
    80005174:	0007871b          	sext.w	a4,a5
    80005178:	0001d797          	auipc	a5,0x1d
    8000517c:	ee878793          	addi	a5,a5,-280 # 80022060 <sb>
    80005180:	4f9c                	lw	a5,24(a5)
    80005182:	9fb9                	addw	a5,a5,a4
    80005184:	2781                	sext.w	a5,a5
    80005186:	85be                	mv	a1,a5
    80005188:	8536                	mv	a0,a3
    8000518a:	fffff097          	auipc	ra,0xfffff
    8000518e:	5ca080e7          	jalr	1482(ra) # 80004754 <bread>
    80005192:	fea43423          	sd	a0,-24(s0)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80005196:	fe843783          	ld	a5,-24(s0)
    8000519a:	05878713          	addi	a4,a5,88
    8000519e:	fd843783          	ld	a5,-40(s0)
    800051a2:	43dc                	lw	a5,4(a5)
    800051a4:	1782                	slli	a5,a5,0x20
    800051a6:	9381                	srli	a5,a5,0x20
    800051a8:	8bbd                	andi	a5,a5,15
    800051aa:	079a                	slli	a5,a5,0x6
    800051ac:	97ba                	add	a5,a5,a4
    800051ae:	fef43023          	sd	a5,-32(s0)
    ip->type = dip->type;
    800051b2:	fe043783          	ld	a5,-32(s0)
    800051b6:	00079703          	lh	a4,0(a5)
    800051ba:	fd843783          	ld	a5,-40(s0)
    800051be:	04e79223          	sh	a4,68(a5)
    ip->major = dip->major;
    800051c2:	fe043783          	ld	a5,-32(s0)
    800051c6:	00279703          	lh	a4,2(a5)
    800051ca:	fd843783          	ld	a5,-40(s0)
    800051ce:	04e79323          	sh	a4,70(a5)
    ip->minor = dip->minor;
    800051d2:	fe043783          	ld	a5,-32(s0)
    800051d6:	00479703          	lh	a4,4(a5)
    800051da:	fd843783          	ld	a5,-40(s0)
    800051de:	04e79423          	sh	a4,72(a5)
    ip->nlink = dip->nlink;
    800051e2:	fe043783          	ld	a5,-32(s0)
    800051e6:	00679703          	lh	a4,6(a5)
    800051ea:	fd843783          	ld	a5,-40(s0)
    800051ee:	04e79523          	sh	a4,74(a5)
    ip->size = dip->size;
    800051f2:	fe043783          	ld	a5,-32(s0)
    800051f6:	4798                	lw	a4,8(a5)
    800051f8:	fd843783          	ld	a5,-40(s0)
    800051fc:	c7f8                	sw	a4,76(a5)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800051fe:	fd843783          	ld	a5,-40(s0)
    80005202:	05078713          	addi	a4,a5,80
    80005206:	fe043783          	ld	a5,-32(s0)
    8000520a:	07b1                	addi	a5,a5,12
    8000520c:	03400613          	li	a2,52
    80005210:	85be                	mv	a1,a5
    80005212:	853a                	mv	a0,a4
    80005214:	ffffc097          	auipc	ra,0xffffc
    80005218:	370080e7          	jalr	880(ra) # 80001584 <memmove>
    brelse(bp);
    8000521c:	fe843503          	ld	a0,-24(s0)
    80005220:	fffff097          	auipc	ra,0xfffff
    80005224:	5d6080e7          	jalr	1494(ra) # 800047f6 <brelse>
    ip->valid = 1;
    80005228:	fd843783          	ld	a5,-40(s0)
    8000522c:	4705                	li	a4,1
    8000522e:	c3b8                	sw	a4,64(a5)
    if(ip->type == 0)
    80005230:	fd843783          	ld	a5,-40(s0)
    80005234:	04479783          	lh	a5,68(a5)
    80005238:	eb89                	bnez	a5,8000524a <ilock+0x12a>
      panic("ilock: no type");
    8000523a:	00006517          	auipc	a0,0x6
    8000523e:	2ae50513          	addi	a0,a0,686 # 8000b4e8 <etext+0x4e8>
    80005242:	ffffc097          	auipc	ra,0xffffc
    80005246:	a7e080e7          	jalr	-1410(ra) # 80000cc0 <panic>
  }
}
    8000524a:	0001                	nop
    8000524c:	70a2                	ld	ra,40(sp)
    8000524e:	7402                	ld	s0,32(sp)
    80005250:	6145                	addi	sp,sp,48
    80005252:	8082                	ret

0000000080005254 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
    80005254:	1101                	addi	sp,sp,-32
    80005256:	ec06                	sd	ra,24(sp)
    80005258:	e822                	sd	s0,16(sp)
    8000525a:	1000                	addi	s0,sp,32
    8000525c:	fea43423          	sd	a0,-24(s0)
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80005260:	fe843783          	ld	a5,-24(s0)
    80005264:	c385                	beqz	a5,80005284 <iunlock+0x30>
    80005266:	fe843783          	ld	a5,-24(s0)
    8000526a:	07c1                	addi	a5,a5,16
    8000526c:	853e                	mv	a0,a5
    8000526e:	00001097          	auipc	ra,0x1
    80005272:	432080e7          	jalr	1074(ra) # 800066a0 <holdingsleep>
    80005276:	87aa                	mv	a5,a0
    80005278:	c791                	beqz	a5,80005284 <iunlock+0x30>
    8000527a:	fe843783          	ld	a5,-24(s0)
    8000527e:	479c                	lw	a5,8(a5)
    80005280:	00f04a63          	bgtz	a5,80005294 <iunlock+0x40>
    panic("iunlock");
    80005284:	00006517          	auipc	a0,0x6
    80005288:	27450513          	addi	a0,a0,628 # 8000b4f8 <etext+0x4f8>
    8000528c:	ffffc097          	auipc	ra,0xffffc
    80005290:	a34080e7          	jalr	-1484(ra) # 80000cc0 <panic>

  releasesleep(&ip->lock);
    80005294:	fe843783          	ld	a5,-24(s0)
    80005298:	07c1                	addi	a5,a5,16
    8000529a:	853e                	mv	a0,a5
    8000529c:	00001097          	auipc	ra,0x1
    800052a0:	3b2080e7          	jalr	946(ra) # 8000664e <releasesleep>
}
    800052a4:	0001                	nop
    800052a6:	60e2                	ld	ra,24(sp)
    800052a8:	6442                	ld	s0,16(sp)
    800052aa:	6105                	addi	sp,sp,32
    800052ac:	8082                	ret

00000000800052ae <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
    800052ae:	1101                	addi	sp,sp,-32
    800052b0:	ec06                	sd	ra,24(sp)
    800052b2:	e822                	sd	s0,16(sp)
    800052b4:	1000                	addi	s0,sp,32
    800052b6:	fea43423          	sd	a0,-24(s0)
  acquire(&itable.lock);
    800052ba:	0001d517          	auipc	a0,0x1d
    800052be:	dc650513          	addi	a0,a0,-570 # 80022080 <itable>
    800052c2:	ffffc097          	auipc	ra,0xffffc
    800052c6:	002080e7          	jalr	2(ra) # 800012c4 <acquire>

  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800052ca:	fe843783          	ld	a5,-24(s0)
    800052ce:	4798                	lw	a4,8(a5)
    800052d0:	4785                	li	a5,1
    800052d2:	06f71f63          	bne	a4,a5,80005350 <iput+0xa2>
    800052d6:	fe843783          	ld	a5,-24(s0)
    800052da:	43bc                	lw	a5,64(a5)
    800052dc:	cbb5                	beqz	a5,80005350 <iput+0xa2>
    800052de:	fe843783          	ld	a5,-24(s0)
    800052e2:	04a79783          	lh	a5,74(a5)
    800052e6:	e7ad                	bnez	a5,80005350 <iput+0xa2>
    // inode has no links and no other references: truncate and free.

    // ip->ref == 1 means no other process can have ip locked,
    // so this acquiresleep() won't block (or deadlock).
    acquiresleep(&ip->lock);
    800052e8:	fe843783          	ld	a5,-24(s0)
    800052ec:	07c1                	addi	a5,a5,16
    800052ee:	853e                	mv	a0,a5
    800052f0:	00001097          	auipc	ra,0x1
    800052f4:	2f0080e7          	jalr	752(ra) # 800065e0 <acquiresleep>

    release(&itable.lock);
    800052f8:	0001d517          	auipc	a0,0x1d
    800052fc:	d8850513          	addi	a0,a0,-632 # 80022080 <itable>
    80005300:	ffffc097          	auipc	ra,0xffffc
    80005304:	028080e7          	jalr	40(ra) # 80001328 <release>

    itrunc(ip);
    80005308:	fe843503          	ld	a0,-24(s0)
    8000530c:	00000097          	auipc	ra,0x0
    80005310:	21a080e7          	jalr	538(ra) # 80005526 <itrunc>
    ip->type = 0;
    80005314:	fe843783          	ld	a5,-24(s0)
    80005318:	04079223          	sh	zero,68(a5)
    iupdate(ip);
    8000531c:	fe843503          	ld	a0,-24(s0)
    80005320:	00000097          	auipc	ra,0x0
    80005324:	bb0080e7          	jalr	-1104(ra) # 80004ed0 <iupdate>
    ip->valid = 0;
    80005328:	fe843783          	ld	a5,-24(s0)
    8000532c:	0407a023          	sw	zero,64(a5)

    releasesleep(&ip->lock);
    80005330:	fe843783          	ld	a5,-24(s0)
    80005334:	07c1                	addi	a5,a5,16
    80005336:	853e                	mv	a0,a5
    80005338:	00001097          	auipc	ra,0x1
    8000533c:	316080e7          	jalr	790(ra) # 8000664e <releasesleep>

    acquire(&itable.lock);
    80005340:	0001d517          	auipc	a0,0x1d
    80005344:	d4050513          	addi	a0,a0,-704 # 80022080 <itable>
    80005348:	ffffc097          	auipc	ra,0xffffc
    8000534c:	f7c080e7          	jalr	-132(ra) # 800012c4 <acquire>
  }

  ip->ref--;
    80005350:	fe843783          	ld	a5,-24(s0)
    80005354:	479c                	lw	a5,8(a5)
    80005356:	37fd                	addiw	a5,a5,-1
    80005358:	0007871b          	sext.w	a4,a5
    8000535c:	fe843783          	ld	a5,-24(s0)
    80005360:	c798                	sw	a4,8(a5)
  release(&itable.lock);
    80005362:	0001d517          	auipc	a0,0x1d
    80005366:	d1e50513          	addi	a0,a0,-738 # 80022080 <itable>
    8000536a:	ffffc097          	auipc	ra,0xffffc
    8000536e:	fbe080e7          	jalr	-66(ra) # 80001328 <release>
}
    80005372:	0001                	nop
    80005374:	60e2                	ld	ra,24(sp)
    80005376:	6442                	ld	s0,16(sp)
    80005378:	6105                	addi	sp,sp,32
    8000537a:	8082                	ret

000000008000537c <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
    8000537c:	1101                	addi	sp,sp,-32
    8000537e:	ec06                	sd	ra,24(sp)
    80005380:	e822                	sd	s0,16(sp)
    80005382:	1000                	addi	s0,sp,32
    80005384:	fea43423          	sd	a0,-24(s0)
  iunlock(ip);
    80005388:	fe843503          	ld	a0,-24(s0)
    8000538c:	00000097          	auipc	ra,0x0
    80005390:	ec8080e7          	jalr	-312(ra) # 80005254 <iunlock>
  iput(ip);
    80005394:	fe843503          	ld	a0,-24(s0)
    80005398:	00000097          	auipc	ra,0x0
    8000539c:	f16080e7          	jalr	-234(ra) # 800052ae <iput>
}
    800053a0:	0001                	nop
    800053a2:	60e2                	ld	ra,24(sp)
    800053a4:	6442                	ld	s0,16(sp)
    800053a6:	6105                	addi	sp,sp,32
    800053a8:	8082                	ret

00000000800053aa <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800053aa:	7139                	addi	sp,sp,-64
    800053ac:	fc06                	sd	ra,56(sp)
    800053ae:	f822                	sd	s0,48(sp)
    800053b0:	0080                	addi	s0,sp,64
    800053b2:	fca43423          	sd	a0,-56(s0)
    800053b6:	87ae                	mv	a5,a1
    800053b8:	fcf42223          	sw	a5,-60(s0)
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800053bc:	fc442783          	lw	a5,-60(s0)
    800053c0:	0007871b          	sext.w	a4,a5
    800053c4:	47ad                	li	a5,11
    800053c6:	04e7ee63          	bltu	a5,a4,80005422 <bmap+0x78>
    if((addr = ip->addrs[bn]) == 0){
    800053ca:	fc843703          	ld	a4,-56(s0)
    800053ce:	fc446783          	lwu	a5,-60(s0)
    800053d2:	07d1                	addi	a5,a5,20
    800053d4:	078a                	slli	a5,a5,0x2
    800053d6:	97ba                	add	a5,a5,a4
    800053d8:	439c                	lw	a5,0(a5)
    800053da:	fef42623          	sw	a5,-20(s0)
    800053de:	fec42783          	lw	a5,-20(s0)
    800053e2:	2781                	sext.w	a5,a5
    800053e4:	ef85                	bnez	a5,8000541c <bmap+0x72>
      addr = balloc(ip->dev);
    800053e6:	fc843783          	ld	a5,-56(s0)
    800053ea:	439c                	lw	a5,0(a5)
    800053ec:	853e                	mv	a0,a5
    800053ee:	fffff097          	auipc	ra,0xfffff
    800053f2:	6ae080e7          	jalr	1710(ra) # 80004a9c <balloc>
    800053f6:	87aa                	mv	a5,a0
    800053f8:	fef42623          	sw	a5,-20(s0)
      if(addr == 0)
    800053fc:	fec42783          	lw	a5,-20(s0)
    80005400:	2781                	sext.w	a5,a5
    80005402:	e399                	bnez	a5,80005408 <bmap+0x5e>
        return 0;
    80005404:	4781                	li	a5,0
    80005406:	aa19                	j	8000551c <bmap+0x172>
      ip->addrs[bn] = addr;
    80005408:	fc843703          	ld	a4,-56(s0)
    8000540c:	fc446783          	lwu	a5,-60(s0)
    80005410:	07d1                	addi	a5,a5,20
    80005412:	078a                	slli	a5,a5,0x2
    80005414:	97ba                	add	a5,a5,a4
    80005416:	fec42703          	lw	a4,-20(s0)
    8000541a:	c398                	sw	a4,0(a5)
    }
    return addr;
    8000541c:	fec42783          	lw	a5,-20(s0)
    80005420:	a8f5                	j	8000551c <bmap+0x172>
  }
  bn -= NDIRECT;
    80005422:	fc442783          	lw	a5,-60(s0)
    80005426:	37d1                	addiw	a5,a5,-12
    80005428:	fcf42223          	sw	a5,-60(s0)

  if(bn < NINDIRECT){
    8000542c:	fc442783          	lw	a5,-60(s0)
    80005430:	0007871b          	sext.w	a4,a5
    80005434:	0ff00793          	li	a5,255
    80005438:	0ce7ea63          	bltu	a5,a4,8000550c <bmap+0x162>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000543c:	fc843783          	ld	a5,-56(s0)
    80005440:	0807a783          	lw	a5,128(a5)
    80005444:	fef42623          	sw	a5,-20(s0)
    80005448:	fec42783          	lw	a5,-20(s0)
    8000544c:	2781                	sext.w	a5,a5
    8000544e:	eb85                	bnez	a5,8000547e <bmap+0xd4>
      addr = balloc(ip->dev);
    80005450:	fc843783          	ld	a5,-56(s0)
    80005454:	439c                	lw	a5,0(a5)
    80005456:	853e                	mv	a0,a5
    80005458:	fffff097          	auipc	ra,0xfffff
    8000545c:	644080e7          	jalr	1604(ra) # 80004a9c <balloc>
    80005460:	87aa                	mv	a5,a0
    80005462:	fef42623          	sw	a5,-20(s0)
      if(addr == 0)
    80005466:	fec42783          	lw	a5,-20(s0)
    8000546a:	2781                	sext.w	a5,a5
    8000546c:	e399                	bnez	a5,80005472 <bmap+0xc8>
        return 0;
    8000546e:	4781                	li	a5,0
    80005470:	a075                	j	8000551c <bmap+0x172>
      ip->addrs[NDIRECT] = addr;
    80005472:	fc843783          	ld	a5,-56(s0)
    80005476:	fec42703          	lw	a4,-20(s0)
    8000547a:	08e7a023          	sw	a4,128(a5)
    }
    bp = bread(ip->dev, addr);
    8000547e:	fc843783          	ld	a5,-56(s0)
    80005482:	439c                	lw	a5,0(a5)
    80005484:	fec42703          	lw	a4,-20(s0)
    80005488:	85ba                	mv	a1,a4
    8000548a:	853e                	mv	a0,a5
    8000548c:	fffff097          	auipc	ra,0xfffff
    80005490:	2c8080e7          	jalr	712(ra) # 80004754 <bread>
    80005494:	fea43023          	sd	a0,-32(s0)
    a = (uint*)bp->data;
    80005498:	fe043783          	ld	a5,-32(s0)
    8000549c:	05878793          	addi	a5,a5,88
    800054a0:	fcf43c23          	sd	a5,-40(s0)
    if((addr = a[bn]) == 0){
    800054a4:	fc446783          	lwu	a5,-60(s0)
    800054a8:	078a                	slli	a5,a5,0x2
    800054aa:	fd843703          	ld	a4,-40(s0)
    800054ae:	97ba                	add	a5,a5,a4
    800054b0:	439c                	lw	a5,0(a5)
    800054b2:	fef42623          	sw	a5,-20(s0)
    800054b6:	fec42783          	lw	a5,-20(s0)
    800054ba:	2781                	sext.w	a5,a5
    800054bc:	ef9d                	bnez	a5,800054fa <bmap+0x150>
      addr = balloc(ip->dev);
    800054be:	fc843783          	ld	a5,-56(s0)
    800054c2:	439c                	lw	a5,0(a5)
    800054c4:	853e                	mv	a0,a5
    800054c6:	fffff097          	auipc	ra,0xfffff
    800054ca:	5d6080e7          	jalr	1494(ra) # 80004a9c <balloc>
    800054ce:	87aa                	mv	a5,a0
    800054d0:	fef42623          	sw	a5,-20(s0)
      if(addr){
    800054d4:	fec42783          	lw	a5,-20(s0)
    800054d8:	2781                	sext.w	a5,a5
    800054da:	c385                	beqz	a5,800054fa <bmap+0x150>
        a[bn] = addr;
    800054dc:	fc446783          	lwu	a5,-60(s0)
    800054e0:	078a                	slli	a5,a5,0x2
    800054e2:	fd843703          	ld	a4,-40(s0)
    800054e6:	97ba                	add	a5,a5,a4
    800054e8:	fec42703          	lw	a4,-20(s0)
    800054ec:	c398                	sw	a4,0(a5)
        log_write(bp);
    800054ee:	fe043503          	ld	a0,-32(s0)
    800054f2:	00001097          	auipc	ra,0x1
    800054f6:	f74080e7          	jalr	-140(ra) # 80006466 <log_write>
      }
    }
    brelse(bp);
    800054fa:	fe043503          	ld	a0,-32(s0)
    800054fe:	fffff097          	auipc	ra,0xfffff
    80005502:	2f8080e7          	jalr	760(ra) # 800047f6 <brelse>
    return addr;
    80005506:	fec42783          	lw	a5,-20(s0)
    8000550a:	a809                	j	8000551c <bmap+0x172>
  }

  panic("bmap: out of range");
    8000550c:	00006517          	auipc	a0,0x6
    80005510:	ff450513          	addi	a0,a0,-12 # 8000b500 <etext+0x500>
    80005514:	ffffb097          	auipc	ra,0xffffb
    80005518:	7ac080e7          	jalr	1964(ra) # 80000cc0 <panic>
}
    8000551c:	853e                	mv	a0,a5
    8000551e:	70e2                	ld	ra,56(sp)
    80005520:	7442                	ld	s0,48(sp)
    80005522:	6121                	addi	sp,sp,64
    80005524:	8082                	ret

0000000080005526 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80005526:	7139                	addi	sp,sp,-64
    80005528:	fc06                	sd	ra,56(sp)
    8000552a:	f822                	sd	s0,48(sp)
    8000552c:	0080                	addi	s0,sp,64
    8000552e:	fca43423          	sd	a0,-56(s0)
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80005532:	fe042623          	sw	zero,-20(s0)
    80005536:	a891                	j	8000558a <itrunc+0x64>
    if(ip->addrs[i]){
    80005538:	fc843703          	ld	a4,-56(s0)
    8000553c:	fec42783          	lw	a5,-20(s0)
    80005540:	07d1                	addi	a5,a5,20
    80005542:	078a                	slli	a5,a5,0x2
    80005544:	97ba                	add	a5,a5,a4
    80005546:	439c                	lw	a5,0(a5)
    80005548:	cf85                	beqz	a5,80005580 <itrunc+0x5a>
      bfree(ip->dev, ip->addrs[i]);
    8000554a:	fc843783          	ld	a5,-56(s0)
    8000554e:	439c                	lw	a5,0(a5)
    80005550:	86be                	mv	a3,a5
    80005552:	fc843703          	ld	a4,-56(s0)
    80005556:	fec42783          	lw	a5,-20(s0)
    8000555a:	07d1                	addi	a5,a5,20
    8000555c:	078a                	slli	a5,a5,0x2
    8000555e:	97ba                	add	a5,a5,a4
    80005560:	439c                	lw	a5,0(a5)
    80005562:	85be                	mv	a1,a5
    80005564:	8536                	mv	a0,a3
    80005566:	fffff097          	auipc	ra,0xfffff
    8000556a:	6d8080e7          	jalr	1752(ra) # 80004c3e <bfree>
      ip->addrs[i] = 0;
    8000556e:	fc843703          	ld	a4,-56(s0)
    80005572:	fec42783          	lw	a5,-20(s0)
    80005576:	07d1                	addi	a5,a5,20
    80005578:	078a                	slli	a5,a5,0x2
    8000557a:	97ba                	add	a5,a5,a4
    8000557c:	0007a023          	sw	zero,0(a5)
  for(i = 0; i < NDIRECT; i++){
    80005580:	fec42783          	lw	a5,-20(s0)
    80005584:	2785                	addiw	a5,a5,1
    80005586:	fef42623          	sw	a5,-20(s0)
    8000558a:	fec42783          	lw	a5,-20(s0)
    8000558e:	0007871b          	sext.w	a4,a5
    80005592:	47ad                	li	a5,11
    80005594:	fae7d2e3          	bge	a5,a4,80005538 <itrunc+0x12>
    }
  }

  if(ip->addrs[NDIRECT]){
    80005598:	fc843783          	ld	a5,-56(s0)
    8000559c:	0807a783          	lw	a5,128(a5)
    800055a0:	c7cd                	beqz	a5,8000564a <itrunc+0x124>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800055a2:	fc843783          	ld	a5,-56(s0)
    800055a6:	4398                	lw	a4,0(a5)
    800055a8:	fc843783          	ld	a5,-56(s0)
    800055ac:	0807a783          	lw	a5,128(a5)
    800055b0:	85be                	mv	a1,a5
    800055b2:	853a                	mv	a0,a4
    800055b4:	fffff097          	auipc	ra,0xfffff
    800055b8:	1a0080e7          	jalr	416(ra) # 80004754 <bread>
    800055bc:	fea43023          	sd	a0,-32(s0)
    a = (uint*)bp->data;
    800055c0:	fe043783          	ld	a5,-32(s0)
    800055c4:	05878793          	addi	a5,a5,88
    800055c8:	fcf43c23          	sd	a5,-40(s0)
    for(j = 0; j < NINDIRECT; j++){
    800055cc:	fe042423          	sw	zero,-24(s0)
    800055d0:	a83d                	j	8000560e <itrunc+0xe8>
      if(a[j])
    800055d2:	fe842783          	lw	a5,-24(s0)
    800055d6:	078a                	slli	a5,a5,0x2
    800055d8:	fd843703          	ld	a4,-40(s0)
    800055dc:	97ba                	add	a5,a5,a4
    800055de:	439c                	lw	a5,0(a5)
    800055e0:	c395                	beqz	a5,80005604 <itrunc+0xde>
        bfree(ip->dev, a[j]);
    800055e2:	fc843783          	ld	a5,-56(s0)
    800055e6:	439c                	lw	a5,0(a5)
    800055e8:	86be                	mv	a3,a5
    800055ea:	fe842783          	lw	a5,-24(s0)
    800055ee:	078a                	slli	a5,a5,0x2
    800055f0:	fd843703          	ld	a4,-40(s0)
    800055f4:	97ba                	add	a5,a5,a4
    800055f6:	439c                	lw	a5,0(a5)
    800055f8:	85be                	mv	a1,a5
    800055fa:	8536                	mv	a0,a3
    800055fc:	fffff097          	auipc	ra,0xfffff
    80005600:	642080e7          	jalr	1602(ra) # 80004c3e <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80005604:	fe842783          	lw	a5,-24(s0)
    80005608:	2785                	addiw	a5,a5,1
    8000560a:	fef42423          	sw	a5,-24(s0)
    8000560e:	fe842703          	lw	a4,-24(s0)
    80005612:	0ff00793          	li	a5,255
    80005616:	fae7fee3          	bgeu	a5,a4,800055d2 <itrunc+0xac>
    }
    brelse(bp);
    8000561a:	fe043503          	ld	a0,-32(s0)
    8000561e:	fffff097          	auipc	ra,0xfffff
    80005622:	1d8080e7          	jalr	472(ra) # 800047f6 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80005626:	fc843783          	ld	a5,-56(s0)
    8000562a:	439c                	lw	a5,0(a5)
    8000562c:	873e                	mv	a4,a5
    8000562e:	fc843783          	ld	a5,-56(s0)
    80005632:	0807a783          	lw	a5,128(a5)
    80005636:	85be                	mv	a1,a5
    80005638:	853a                	mv	a0,a4
    8000563a:	fffff097          	auipc	ra,0xfffff
    8000563e:	604080e7          	jalr	1540(ra) # 80004c3e <bfree>
    ip->addrs[NDIRECT] = 0;
    80005642:	fc843783          	ld	a5,-56(s0)
    80005646:	0807a023          	sw	zero,128(a5)
  }

  ip->size = 0;
    8000564a:	fc843783          	ld	a5,-56(s0)
    8000564e:	0407a623          	sw	zero,76(a5)
  iupdate(ip);
    80005652:	fc843503          	ld	a0,-56(s0)
    80005656:	00000097          	auipc	ra,0x0
    8000565a:	87a080e7          	jalr	-1926(ra) # 80004ed0 <iupdate>
}
    8000565e:	0001                	nop
    80005660:	70e2                	ld	ra,56(sp)
    80005662:	7442                	ld	s0,48(sp)
    80005664:	6121                	addi	sp,sp,64
    80005666:	8082                	ret

0000000080005668 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80005668:	1101                	addi	sp,sp,-32
    8000566a:	ec06                	sd	ra,24(sp)
    8000566c:	e822                	sd	s0,16(sp)
    8000566e:	1000                	addi	s0,sp,32
    80005670:	fea43423          	sd	a0,-24(s0)
    80005674:	feb43023          	sd	a1,-32(s0)
  st->dev = ip->dev;
    80005678:	fe843783          	ld	a5,-24(s0)
    8000567c:	439c                	lw	a5,0(a5)
    8000567e:	873e                	mv	a4,a5
    80005680:	fe043783          	ld	a5,-32(s0)
    80005684:	c398                	sw	a4,0(a5)
  st->ino = ip->inum;
    80005686:	fe843783          	ld	a5,-24(s0)
    8000568a:	43d8                	lw	a4,4(a5)
    8000568c:	fe043783          	ld	a5,-32(s0)
    80005690:	c3d8                	sw	a4,4(a5)
  st->type = ip->type;
    80005692:	fe843783          	ld	a5,-24(s0)
    80005696:	04479703          	lh	a4,68(a5)
    8000569a:	fe043783          	ld	a5,-32(s0)
    8000569e:	00e79423          	sh	a4,8(a5)
  st->nlink = ip->nlink;
    800056a2:	fe843783          	ld	a5,-24(s0)
    800056a6:	04a79703          	lh	a4,74(a5)
    800056aa:	fe043783          	ld	a5,-32(s0)
    800056ae:	00e79523          	sh	a4,10(a5)
  st->size = ip->size;
    800056b2:	fe843783          	ld	a5,-24(s0)
    800056b6:	47fc                	lw	a5,76(a5)
    800056b8:	02079713          	slli	a4,a5,0x20
    800056bc:	9301                	srli	a4,a4,0x20
    800056be:	fe043783          	ld	a5,-32(s0)
    800056c2:	eb98                	sd	a4,16(a5)
}
    800056c4:	0001                	nop
    800056c6:	60e2                	ld	ra,24(sp)
    800056c8:	6442                	ld	s0,16(sp)
    800056ca:	6105                	addi	sp,sp,32
    800056cc:	8082                	ret

00000000800056ce <readi>:
// Caller must hold ip->lock.
// If user_dst==1, then dst is a user virtual address;
// otherwise, dst is a kernel address.
int
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
    800056ce:	715d                	addi	sp,sp,-80
    800056d0:	e486                	sd	ra,72(sp)
    800056d2:	e0a2                	sd	s0,64(sp)
    800056d4:	0880                	addi	s0,sp,80
    800056d6:	fca43423          	sd	a0,-56(s0)
    800056da:	87ae                	mv	a5,a1
    800056dc:	fac43c23          	sd	a2,-72(s0)
    800056e0:	fcf42223          	sw	a5,-60(s0)
    800056e4:	87b6                	mv	a5,a3
    800056e6:	fcf42023          	sw	a5,-64(s0)
    800056ea:	87ba                	mv	a5,a4
    800056ec:	faf42a23          	sw	a5,-76(s0)
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800056f0:	fc843783          	ld	a5,-56(s0)
    800056f4:	47fc                	lw	a5,76(a5)
    800056f6:	fc042703          	lw	a4,-64(s0)
    800056fa:	2701                	sext.w	a4,a4
    800056fc:	00e7ee63          	bltu	a5,a4,80005718 <readi+0x4a>
    80005700:	fc042783          	lw	a5,-64(s0)
    80005704:	873e                	mv	a4,a5
    80005706:	fb442783          	lw	a5,-76(s0)
    8000570a:	9fb9                	addw	a5,a5,a4
    8000570c:	2781                	sext.w	a5,a5
    8000570e:	fc042703          	lw	a4,-64(s0)
    80005712:	2701                	sext.w	a4,a4
    80005714:	00e7f463          	bgeu	a5,a4,8000571c <readi+0x4e>
    return 0;
    80005718:	4781                	li	a5,0
    8000571a:	a299                	j	80005860 <readi+0x192>
  if(off + n > ip->size)
    8000571c:	fc042783          	lw	a5,-64(s0)
    80005720:	873e                	mv	a4,a5
    80005722:	fb442783          	lw	a5,-76(s0)
    80005726:	9fb9                	addw	a5,a5,a4
    80005728:	0007871b          	sext.w	a4,a5
    8000572c:	fc843783          	ld	a5,-56(s0)
    80005730:	47fc                	lw	a5,76(a5)
    80005732:	00e7fa63          	bgeu	a5,a4,80005746 <readi+0x78>
    n = ip->size - off;
    80005736:	fc843783          	ld	a5,-56(s0)
    8000573a:	47fc                	lw	a5,76(a5)
    8000573c:	fc042703          	lw	a4,-64(s0)
    80005740:	9f99                	subw	a5,a5,a4
    80005742:	faf42a23          	sw	a5,-76(s0)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80005746:	fe042623          	sw	zero,-20(s0)
    8000574a:	a8f5                	j	80005846 <readi+0x178>
    uint addr = bmap(ip, off/BSIZE);
    8000574c:	fc042783          	lw	a5,-64(s0)
    80005750:	00a7d79b          	srliw	a5,a5,0xa
    80005754:	2781                	sext.w	a5,a5
    80005756:	85be                	mv	a1,a5
    80005758:	fc843503          	ld	a0,-56(s0)
    8000575c:	00000097          	auipc	ra,0x0
    80005760:	c4e080e7          	jalr	-946(ra) # 800053aa <bmap>
    80005764:	87aa                	mv	a5,a0
    80005766:	fef42423          	sw	a5,-24(s0)
    if(addr == 0)
    8000576a:	fe842783          	lw	a5,-24(s0)
    8000576e:	2781                	sext.w	a5,a5
    80005770:	c7ed                	beqz	a5,8000585a <readi+0x18c>
      break;
    bp = bread(ip->dev, addr);
    80005772:	fc843783          	ld	a5,-56(s0)
    80005776:	439c                	lw	a5,0(a5)
    80005778:	fe842703          	lw	a4,-24(s0)
    8000577c:	85ba                	mv	a1,a4
    8000577e:	853e                	mv	a0,a5
    80005780:	fffff097          	auipc	ra,0xfffff
    80005784:	fd4080e7          	jalr	-44(ra) # 80004754 <bread>
    80005788:	fea43023          	sd	a0,-32(s0)
    m = min(n - tot, BSIZE - off%BSIZE);
    8000578c:	fc042783          	lw	a5,-64(s0)
    80005790:	3ff7f793          	andi	a5,a5,1023
    80005794:	2781                	sext.w	a5,a5
    80005796:	40000713          	li	a4,1024
    8000579a:	40f707bb          	subw	a5,a4,a5
    8000579e:	2781                	sext.w	a5,a5
    800057a0:	fb442703          	lw	a4,-76(s0)
    800057a4:	86ba                	mv	a3,a4
    800057a6:	fec42703          	lw	a4,-20(s0)
    800057aa:	40e6873b          	subw	a4,a3,a4
    800057ae:	2701                	sext.w	a4,a4
    800057b0:	863a                	mv	a2,a4
    800057b2:	0007869b          	sext.w	a3,a5
    800057b6:	0006071b          	sext.w	a4,a2
    800057ba:	00d77363          	bgeu	a4,a3,800057c0 <readi+0xf2>
    800057be:	87b2                	mv	a5,a2
    800057c0:	fcf42e23          	sw	a5,-36(s0)
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800057c4:	fe043783          	ld	a5,-32(s0)
    800057c8:	05878713          	addi	a4,a5,88
    800057cc:	fc046783          	lwu	a5,-64(s0)
    800057d0:	3ff7f793          	andi	a5,a5,1023
    800057d4:	973e                	add	a4,a4,a5
    800057d6:	fdc46683          	lwu	a3,-36(s0)
    800057da:	fc442783          	lw	a5,-60(s0)
    800057de:	863a                	mv	a2,a4
    800057e0:	fb843583          	ld	a1,-72(s0)
    800057e4:	853e                	mv	a0,a5
    800057e6:	ffffe097          	auipc	ra,0xffffe
    800057ea:	eb6080e7          	jalr	-330(ra) # 8000369c <either_copyout>
    800057ee:	87aa                	mv	a5,a0
    800057f0:	873e                	mv	a4,a5
    800057f2:	57fd                	li	a5,-1
    800057f4:	00f71c63          	bne	a4,a5,8000580c <readi+0x13e>
      brelse(bp);
    800057f8:	fe043503          	ld	a0,-32(s0)
    800057fc:	fffff097          	auipc	ra,0xfffff
    80005800:	ffa080e7          	jalr	-6(ra) # 800047f6 <brelse>
      tot = -1;
    80005804:	57fd                	li	a5,-1
    80005806:	fef42623          	sw	a5,-20(s0)
      break;
    8000580a:	a889                	j	8000585c <readi+0x18e>
    }
    brelse(bp);
    8000580c:	fe043503          	ld	a0,-32(s0)
    80005810:	fffff097          	auipc	ra,0xfffff
    80005814:	fe6080e7          	jalr	-26(ra) # 800047f6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80005818:	fec42783          	lw	a5,-20(s0)
    8000581c:	873e                	mv	a4,a5
    8000581e:	fdc42783          	lw	a5,-36(s0)
    80005822:	9fb9                	addw	a5,a5,a4
    80005824:	fef42623          	sw	a5,-20(s0)
    80005828:	fc042783          	lw	a5,-64(s0)
    8000582c:	873e                	mv	a4,a5
    8000582e:	fdc42783          	lw	a5,-36(s0)
    80005832:	9fb9                	addw	a5,a5,a4
    80005834:	fcf42023          	sw	a5,-64(s0)
    80005838:	fdc46783          	lwu	a5,-36(s0)
    8000583c:	fb843703          	ld	a4,-72(s0)
    80005840:	97ba                	add	a5,a5,a4
    80005842:	faf43c23          	sd	a5,-72(s0)
    80005846:	fec42783          	lw	a5,-20(s0)
    8000584a:	873e                	mv	a4,a5
    8000584c:	fb442783          	lw	a5,-76(s0)
    80005850:	2701                	sext.w	a4,a4
    80005852:	2781                	sext.w	a5,a5
    80005854:	eef76ce3          	bltu	a4,a5,8000574c <readi+0x7e>
    80005858:	a011                	j	8000585c <readi+0x18e>
      break;
    8000585a:	0001                	nop
  }
  return tot;
    8000585c:	fec42783          	lw	a5,-20(s0)
}
    80005860:	853e                	mv	a0,a5
    80005862:	60a6                	ld	ra,72(sp)
    80005864:	6406                	ld	s0,64(sp)
    80005866:	6161                	addi	sp,sp,80
    80005868:	8082                	ret

000000008000586a <writei>:
// Returns the number of bytes successfully written.
// If the return value is less than the requested n,
// there was an error of some kind.
int
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
    8000586a:	715d                	addi	sp,sp,-80
    8000586c:	e486                	sd	ra,72(sp)
    8000586e:	e0a2                	sd	s0,64(sp)
    80005870:	0880                	addi	s0,sp,80
    80005872:	fca43423          	sd	a0,-56(s0)
    80005876:	87ae                	mv	a5,a1
    80005878:	fac43c23          	sd	a2,-72(s0)
    8000587c:	fcf42223          	sw	a5,-60(s0)
    80005880:	87b6                	mv	a5,a3
    80005882:	fcf42023          	sw	a5,-64(s0)
    80005886:	87ba                	mv	a5,a4
    80005888:	faf42a23          	sw	a5,-76(s0)
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000588c:	fc843783          	ld	a5,-56(s0)
    80005890:	47fc                	lw	a5,76(a5)
    80005892:	fc042703          	lw	a4,-64(s0)
    80005896:	2701                	sext.w	a4,a4
    80005898:	00e7ee63          	bltu	a5,a4,800058b4 <writei+0x4a>
    8000589c:	fc042783          	lw	a5,-64(s0)
    800058a0:	873e                	mv	a4,a5
    800058a2:	fb442783          	lw	a5,-76(s0)
    800058a6:	9fb9                	addw	a5,a5,a4
    800058a8:	2781                	sext.w	a5,a5
    800058aa:	fc042703          	lw	a4,-64(s0)
    800058ae:	2701                	sext.w	a4,a4
    800058b0:	00e7f463          	bgeu	a5,a4,800058b8 <writei+0x4e>
    return -1;
    800058b4:	57fd                	li	a5,-1
    800058b6:	a295                	j	80005a1a <writei+0x1b0>
  if(off + n > MAXFILE*BSIZE)
    800058b8:	fc042783          	lw	a5,-64(s0)
    800058bc:	873e                	mv	a4,a5
    800058be:	fb442783          	lw	a5,-76(s0)
    800058c2:	9fb9                	addw	a5,a5,a4
    800058c4:	0007871b          	sext.w	a4,a5
    800058c8:	000437b7          	lui	a5,0x43
    800058cc:	00e7f463          	bgeu	a5,a4,800058d4 <writei+0x6a>
    return -1;
    800058d0:	57fd                	li	a5,-1
    800058d2:	a2a1                	j	80005a1a <writei+0x1b0>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800058d4:	fe042623          	sw	zero,-20(s0)
    800058d8:	a209                	j	800059da <writei+0x170>
    uint addr = bmap(ip, off/BSIZE);
    800058da:	fc042783          	lw	a5,-64(s0)
    800058de:	00a7d79b          	srliw	a5,a5,0xa
    800058e2:	2781                	sext.w	a5,a5
    800058e4:	85be                	mv	a1,a5
    800058e6:	fc843503          	ld	a0,-56(s0)
    800058ea:	00000097          	auipc	ra,0x0
    800058ee:	ac0080e7          	jalr	-1344(ra) # 800053aa <bmap>
    800058f2:	87aa                	mv	a5,a0
    800058f4:	fef42423          	sw	a5,-24(s0)
    if(addr == 0)
    800058f8:	fe842783          	lw	a5,-24(s0)
    800058fc:	2781                	sext.w	a5,a5
    800058fe:	cbe5                	beqz	a5,800059ee <writei+0x184>
      break;
    bp = bread(ip->dev, addr);
    80005900:	fc843783          	ld	a5,-56(s0)
    80005904:	439c                	lw	a5,0(a5)
    80005906:	fe842703          	lw	a4,-24(s0)
    8000590a:	85ba                	mv	a1,a4
    8000590c:	853e                	mv	a0,a5
    8000590e:	fffff097          	auipc	ra,0xfffff
    80005912:	e46080e7          	jalr	-442(ra) # 80004754 <bread>
    80005916:	fea43023          	sd	a0,-32(s0)
    m = min(n - tot, BSIZE - off%BSIZE);
    8000591a:	fc042783          	lw	a5,-64(s0)
    8000591e:	3ff7f793          	andi	a5,a5,1023
    80005922:	2781                	sext.w	a5,a5
    80005924:	40000713          	li	a4,1024
    80005928:	40f707bb          	subw	a5,a4,a5
    8000592c:	2781                	sext.w	a5,a5
    8000592e:	fb442703          	lw	a4,-76(s0)
    80005932:	86ba                	mv	a3,a4
    80005934:	fec42703          	lw	a4,-20(s0)
    80005938:	40e6873b          	subw	a4,a3,a4
    8000593c:	2701                	sext.w	a4,a4
    8000593e:	863a                	mv	a2,a4
    80005940:	0007869b          	sext.w	a3,a5
    80005944:	0006071b          	sext.w	a4,a2
    80005948:	00d77363          	bgeu	a4,a3,8000594e <writei+0xe4>
    8000594c:	87b2                	mv	a5,a2
    8000594e:	fcf42e23          	sw	a5,-36(s0)
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80005952:	fe043783          	ld	a5,-32(s0)
    80005956:	05878713          	addi	a4,a5,88 # 43058 <_entry-0x7ffbcfa8>
    8000595a:	fc046783          	lwu	a5,-64(s0)
    8000595e:	3ff7f793          	andi	a5,a5,1023
    80005962:	97ba                	add	a5,a5,a4
    80005964:	fdc46683          	lwu	a3,-36(s0)
    80005968:	fc442703          	lw	a4,-60(s0)
    8000596c:	fb843603          	ld	a2,-72(s0)
    80005970:	85ba                	mv	a1,a4
    80005972:	853e                	mv	a0,a5
    80005974:	ffffe097          	auipc	ra,0xffffe
    80005978:	d9c080e7          	jalr	-612(ra) # 80003710 <either_copyin>
    8000597c:	87aa                	mv	a5,a0
    8000597e:	873e                	mv	a4,a5
    80005980:	57fd                	li	a5,-1
    80005982:	00f71963          	bne	a4,a5,80005994 <writei+0x12a>
      brelse(bp);
    80005986:	fe043503          	ld	a0,-32(s0)
    8000598a:	fffff097          	auipc	ra,0xfffff
    8000598e:	e6c080e7          	jalr	-404(ra) # 800047f6 <brelse>
      break;
    80005992:	a8b9                	j	800059f0 <writei+0x186>
    }
    log_write(bp);
    80005994:	fe043503          	ld	a0,-32(s0)
    80005998:	00001097          	auipc	ra,0x1
    8000599c:	ace080e7          	jalr	-1330(ra) # 80006466 <log_write>
    brelse(bp);
    800059a0:	fe043503          	ld	a0,-32(s0)
    800059a4:	fffff097          	auipc	ra,0xfffff
    800059a8:	e52080e7          	jalr	-430(ra) # 800047f6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800059ac:	fec42783          	lw	a5,-20(s0)
    800059b0:	873e                	mv	a4,a5
    800059b2:	fdc42783          	lw	a5,-36(s0)
    800059b6:	9fb9                	addw	a5,a5,a4
    800059b8:	fef42623          	sw	a5,-20(s0)
    800059bc:	fc042783          	lw	a5,-64(s0)
    800059c0:	873e                	mv	a4,a5
    800059c2:	fdc42783          	lw	a5,-36(s0)
    800059c6:	9fb9                	addw	a5,a5,a4
    800059c8:	fcf42023          	sw	a5,-64(s0)
    800059cc:	fdc46783          	lwu	a5,-36(s0)
    800059d0:	fb843703          	ld	a4,-72(s0)
    800059d4:	97ba                	add	a5,a5,a4
    800059d6:	faf43c23          	sd	a5,-72(s0)
    800059da:	fec42783          	lw	a5,-20(s0)
    800059de:	873e                	mv	a4,a5
    800059e0:	fb442783          	lw	a5,-76(s0)
    800059e4:	2701                	sext.w	a4,a4
    800059e6:	2781                	sext.w	a5,a5
    800059e8:	eef769e3          	bltu	a4,a5,800058da <writei+0x70>
    800059ec:	a011                	j	800059f0 <writei+0x186>
      break;
    800059ee:	0001                	nop
  }

  if(off > ip->size)
    800059f0:	fc843783          	ld	a5,-56(s0)
    800059f4:	47fc                	lw	a5,76(a5)
    800059f6:	fc042703          	lw	a4,-64(s0)
    800059fa:	2701                	sext.w	a4,a4
    800059fc:	00e7f763          	bgeu	a5,a4,80005a0a <writei+0x1a0>
    ip->size = off;
    80005a00:	fc843783          	ld	a5,-56(s0)
    80005a04:	fc042703          	lw	a4,-64(s0)
    80005a08:	c7f8                	sw	a4,76(a5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80005a0a:	fc843503          	ld	a0,-56(s0)
    80005a0e:	fffff097          	auipc	ra,0xfffff
    80005a12:	4c2080e7          	jalr	1218(ra) # 80004ed0 <iupdate>

  return tot;
    80005a16:	fec42783          	lw	a5,-20(s0)
}
    80005a1a:	853e                	mv	a0,a5
    80005a1c:	60a6                	ld	ra,72(sp)
    80005a1e:	6406                	ld	s0,64(sp)
    80005a20:	6161                	addi	sp,sp,80
    80005a22:	8082                	ret

0000000080005a24 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80005a24:	1101                	addi	sp,sp,-32
    80005a26:	ec06                	sd	ra,24(sp)
    80005a28:	e822                	sd	s0,16(sp)
    80005a2a:	1000                	addi	s0,sp,32
    80005a2c:	fea43423          	sd	a0,-24(s0)
    80005a30:	feb43023          	sd	a1,-32(s0)
  return strncmp(s, t, DIRSIZ);
    80005a34:	4639                	li	a2,14
    80005a36:	fe043583          	ld	a1,-32(s0)
    80005a3a:	fe843503          	ld	a0,-24(s0)
    80005a3e:	ffffc097          	auipc	ra,0xffffc
    80005a42:	c5e080e7          	jalr	-930(ra) # 8000169c <strncmp>
    80005a46:	87aa                	mv	a5,a0
}
    80005a48:	853e                	mv	a0,a5
    80005a4a:	60e2                	ld	ra,24(sp)
    80005a4c:	6442                	ld	s0,16(sp)
    80005a4e:	6105                	addi	sp,sp,32
    80005a50:	8082                	ret

0000000080005a52 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80005a52:	715d                	addi	sp,sp,-80
    80005a54:	e486                	sd	ra,72(sp)
    80005a56:	e0a2                	sd	s0,64(sp)
    80005a58:	0880                	addi	s0,sp,80
    80005a5a:	fca43423          	sd	a0,-56(s0)
    80005a5e:	fcb43023          	sd	a1,-64(s0)
    80005a62:	fac43c23          	sd	a2,-72(s0)
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80005a66:	fc843783          	ld	a5,-56(s0)
    80005a6a:	04479703          	lh	a4,68(a5)
    80005a6e:	4785                	li	a5,1
    80005a70:	00f70a63          	beq	a4,a5,80005a84 <dirlookup+0x32>
    panic("dirlookup not DIR");
    80005a74:	00006517          	auipc	a0,0x6
    80005a78:	aa450513          	addi	a0,a0,-1372 # 8000b518 <etext+0x518>
    80005a7c:	ffffb097          	auipc	ra,0xffffb
    80005a80:	244080e7          	jalr	580(ra) # 80000cc0 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
    80005a84:	fe042623          	sw	zero,-20(s0)
    80005a88:	a849                	j	80005b1a <dirlookup+0xc8>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005a8a:	fd840793          	addi	a5,s0,-40
    80005a8e:	fec42683          	lw	a3,-20(s0)
    80005a92:	4741                	li	a4,16
    80005a94:	863e                	mv	a2,a5
    80005a96:	4581                	li	a1,0
    80005a98:	fc843503          	ld	a0,-56(s0)
    80005a9c:	00000097          	auipc	ra,0x0
    80005aa0:	c32080e7          	jalr	-974(ra) # 800056ce <readi>
    80005aa4:	87aa                	mv	a5,a0
    80005aa6:	873e                	mv	a4,a5
    80005aa8:	47c1                	li	a5,16
    80005aaa:	00f70a63          	beq	a4,a5,80005abe <dirlookup+0x6c>
      panic("dirlookup read");
    80005aae:	00006517          	auipc	a0,0x6
    80005ab2:	a8250513          	addi	a0,a0,-1406 # 8000b530 <etext+0x530>
    80005ab6:	ffffb097          	auipc	ra,0xffffb
    80005aba:	20a080e7          	jalr	522(ra) # 80000cc0 <panic>
    if(de.inum == 0)
    80005abe:	fd845783          	lhu	a5,-40(s0)
    80005ac2:	c7b1                	beqz	a5,80005b0e <dirlookup+0xbc>
      continue;
    if(namecmp(name, de.name) == 0){
    80005ac4:	fd840793          	addi	a5,s0,-40
    80005ac8:	0789                	addi	a5,a5,2
    80005aca:	85be                	mv	a1,a5
    80005acc:	fc043503          	ld	a0,-64(s0)
    80005ad0:	00000097          	auipc	ra,0x0
    80005ad4:	f54080e7          	jalr	-172(ra) # 80005a24 <namecmp>
    80005ad8:	87aa                	mv	a5,a0
    80005ada:	eb9d                	bnez	a5,80005b10 <dirlookup+0xbe>
      // entry matches path element
      if(poff)
    80005adc:	fb843783          	ld	a5,-72(s0)
    80005ae0:	c791                	beqz	a5,80005aec <dirlookup+0x9a>
        *poff = off;
    80005ae2:	fb843783          	ld	a5,-72(s0)
    80005ae6:	fec42703          	lw	a4,-20(s0)
    80005aea:	c398                	sw	a4,0(a5)
      inum = de.inum;
    80005aec:	fd845783          	lhu	a5,-40(s0)
    80005af0:	fef42423          	sw	a5,-24(s0)
      return iget(dp->dev, inum);
    80005af4:	fc843783          	ld	a5,-56(s0)
    80005af8:	439c                	lw	a5,0(a5)
    80005afa:	fe842703          	lw	a4,-24(s0)
    80005afe:	85ba                	mv	a1,a4
    80005b00:	853e                	mv	a0,a5
    80005b02:	fffff097          	auipc	ra,0xfffff
    80005b06:	4b6080e7          	jalr	1206(ra) # 80004fb8 <iget>
    80005b0a:	87aa                	mv	a5,a0
    80005b0c:	a005                	j	80005b2c <dirlookup+0xda>
      continue;
    80005b0e:	0001                	nop
  for(off = 0; off < dp->size; off += sizeof(de)){
    80005b10:	fec42783          	lw	a5,-20(s0)
    80005b14:	27c1                	addiw	a5,a5,16
    80005b16:	fef42623          	sw	a5,-20(s0)
    80005b1a:	fc843783          	ld	a5,-56(s0)
    80005b1e:	47fc                	lw	a5,76(a5)
    80005b20:	fec42703          	lw	a4,-20(s0)
    80005b24:	2701                	sext.w	a4,a4
    80005b26:	f6f762e3          	bltu	a4,a5,80005a8a <dirlookup+0x38>
    }
  }

  return 0;
    80005b2a:	4781                	li	a5,0
}
    80005b2c:	853e                	mv	a0,a5
    80005b2e:	60a6                	ld	ra,72(sp)
    80005b30:	6406                	ld	s0,64(sp)
    80005b32:	6161                	addi	sp,sp,80
    80005b34:	8082                	ret

0000000080005b36 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
// Returns 0 on success, -1 on failure (e.g. out of disk blocks).
int
dirlink(struct inode *dp, char *name, uint inum)
{
    80005b36:	715d                	addi	sp,sp,-80
    80005b38:	e486                	sd	ra,72(sp)
    80005b3a:	e0a2                	sd	s0,64(sp)
    80005b3c:	0880                	addi	s0,sp,80
    80005b3e:	fca43423          	sd	a0,-56(s0)
    80005b42:	fcb43023          	sd	a1,-64(s0)
    80005b46:	87b2                	mv	a5,a2
    80005b48:	faf42e23          	sw	a5,-68(s0)
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    80005b4c:	4601                	li	a2,0
    80005b4e:	fc043583          	ld	a1,-64(s0)
    80005b52:	fc843503          	ld	a0,-56(s0)
    80005b56:	00000097          	auipc	ra,0x0
    80005b5a:	efc080e7          	jalr	-260(ra) # 80005a52 <dirlookup>
    80005b5e:	fea43023          	sd	a0,-32(s0)
    80005b62:	fe043783          	ld	a5,-32(s0)
    80005b66:	cb89                	beqz	a5,80005b78 <dirlink+0x42>
    iput(ip);
    80005b68:	fe043503          	ld	a0,-32(s0)
    80005b6c:	fffff097          	auipc	ra,0xfffff
    80005b70:	742080e7          	jalr	1858(ra) # 800052ae <iput>
    return -1;
    80005b74:	57fd                	li	a5,-1
    80005b76:	a075                	j	80005c22 <dirlink+0xec>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    80005b78:	fe042623          	sw	zero,-20(s0)
    80005b7c:	a0a1                	j	80005bc4 <dirlink+0x8e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005b7e:	fd040793          	addi	a5,s0,-48
    80005b82:	fec42683          	lw	a3,-20(s0)
    80005b86:	4741                	li	a4,16
    80005b88:	863e                	mv	a2,a5
    80005b8a:	4581                	li	a1,0
    80005b8c:	fc843503          	ld	a0,-56(s0)
    80005b90:	00000097          	auipc	ra,0x0
    80005b94:	b3e080e7          	jalr	-1218(ra) # 800056ce <readi>
    80005b98:	87aa                	mv	a5,a0
    80005b9a:	873e                	mv	a4,a5
    80005b9c:	47c1                	li	a5,16
    80005b9e:	00f70a63          	beq	a4,a5,80005bb2 <dirlink+0x7c>
      panic("dirlink read");
    80005ba2:	00006517          	auipc	a0,0x6
    80005ba6:	99e50513          	addi	a0,a0,-1634 # 8000b540 <etext+0x540>
    80005baa:	ffffb097          	auipc	ra,0xffffb
    80005bae:	116080e7          	jalr	278(ra) # 80000cc0 <panic>
    if(de.inum == 0)
    80005bb2:	fd045783          	lhu	a5,-48(s0)
    80005bb6:	cf99                	beqz	a5,80005bd4 <dirlink+0x9e>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80005bb8:	fec42783          	lw	a5,-20(s0)
    80005bbc:	27c1                	addiw	a5,a5,16
    80005bbe:	2781                	sext.w	a5,a5
    80005bc0:	fef42623          	sw	a5,-20(s0)
    80005bc4:	fc843783          	ld	a5,-56(s0)
    80005bc8:	47f8                	lw	a4,76(a5)
    80005bca:	fec42783          	lw	a5,-20(s0)
    80005bce:	fae7e8e3          	bltu	a5,a4,80005b7e <dirlink+0x48>
    80005bd2:	a011                	j	80005bd6 <dirlink+0xa0>
      break;
    80005bd4:	0001                	nop
  }

  strncpy(de.name, name, DIRSIZ);
    80005bd6:	fd040793          	addi	a5,s0,-48
    80005bda:	0789                	addi	a5,a5,2
    80005bdc:	4639                	li	a2,14
    80005bde:	fc043583          	ld	a1,-64(s0)
    80005be2:	853e                	mv	a0,a5
    80005be4:	ffffc097          	auipc	ra,0xffffc
    80005be8:	b46080e7          	jalr	-1210(ra) # 8000172a <strncpy>
  de.inum = inum;
    80005bec:	fbc42783          	lw	a5,-68(s0)
    80005bf0:	17c2                	slli	a5,a5,0x30
    80005bf2:	93c1                	srli	a5,a5,0x30
    80005bf4:	fcf41823          	sh	a5,-48(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005bf8:	fd040793          	addi	a5,s0,-48
    80005bfc:	fec42683          	lw	a3,-20(s0)
    80005c00:	4741                	li	a4,16
    80005c02:	863e                	mv	a2,a5
    80005c04:	4581                	li	a1,0
    80005c06:	fc843503          	ld	a0,-56(s0)
    80005c0a:	00000097          	auipc	ra,0x0
    80005c0e:	c60080e7          	jalr	-928(ra) # 8000586a <writei>
    80005c12:	87aa                	mv	a5,a0
    80005c14:	873e                	mv	a4,a5
    80005c16:	47c1                	li	a5,16
    80005c18:	00f70463          	beq	a4,a5,80005c20 <dirlink+0xea>
    return -1;
    80005c1c:	57fd                	li	a5,-1
    80005c1e:	a011                	j	80005c22 <dirlink+0xec>

  return 0;
    80005c20:	4781                	li	a5,0
}
    80005c22:	853e                	mv	a0,a5
    80005c24:	60a6                	ld	ra,72(sp)
    80005c26:	6406                	ld	s0,64(sp)
    80005c28:	6161                	addi	sp,sp,80
    80005c2a:	8082                	ret

0000000080005c2c <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
    80005c2c:	7179                	addi	sp,sp,-48
    80005c2e:	f406                	sd	ra,40(sp)
    80005c30:	f022                	sd	s0,32(sp)
    80005c32:	1800                	addi	s0,sp,48
    80005c34:	fca43c23          	sd	a0,-40(s0)
    80005c38:	fcb43823          	sd	a1,-48(s0)
  char *s;
  int len;

  while(*path == '/')
    80005c3c:	a031                	j	80005c48 <skipelem+0x1c>
    path++;
    80005c3e:	fd843783          	ld	a5,-40(s0)
    80005c42:	0785                	addi	a5,a5,1
    80005c44:	fcf43c23          	sd	a5,-40(s0)
  while(*path == '/')
    80005c48:	fd843783          	ld	a5,-40(s0)
    80005c4c:	0007c783          	lbu	a5,0(a5)
    80005c50:	873e                	mv	a4,a5
    80005c52:	02f00793          	li	a5,47
    80005c56:	fef704e3          	beq	a4,a5,80005c3e <skipelem+0x12>
  if(*path == 0)
    80005c5a:	fd843783          	ld	a5,-40(s0)
    80005c5e:	0007c783          	lbu	a5,0(a5)
    80005c62:	e399                	bnez	a5,80005c68 <skipelem+0x3c>
    return 0;
    80005c64:	4781                	li	a5,0
    80005c66:	a06d                	j	80005d10 <skipelem+0xe4>
  s = path;
    80005c68:	fd843783          	ld	a5,-40(s0)
    80005c6c:	fef43423          	sd	a5,-24(s0)
  while(*path != '/' && *path != 0)
    80005c70:	a031                	j	80005c7c <skipelem+0x50>
    path++;
    80005c72:	fd843783          	ld	a5,-40(s0)
    80005c76:	0785                	addi	a5,a5,1
    80005c78:	fcf43c23          	sd	a5,-40(s0)
  while(*path != '/' && *path != 0)
    80005c7c:	fd843783          	ld	a5,-40(s0)
    80005c80:	0007c783          	lbu	a5,0(a5)
    80005c84:	873e                	mv	a4,a5
    80005c86:	02f00793          	li	a5,47
    80005c8a:	00f70763          	beq	a4,a5,80005c98 <skipelem+0x6c>
    80005c8e:	fd843783          	ld	a5,-40(s0)
    80005c92:	0007c783          	lbu	a5,0(a5)
    80005c96:	fff1                	bnez	a5,80005c72 <skipelem+0x46>
  len = path - s;
    80005c98:	fd843703          	ld	a4,-40(s0)
    80005c9c:	fe843783          	ld	a5,-24(s0)
    80005ca0:	40f707b3          	sub	a5,a4,a5
    80005ca4:	fef42223          	sw	a5,-28(s0)
  if(len >= DIRSIZ)
    80005ca8:	fe442783          	lw	a5,-28(s0)
    80005cac:	0007871b          	sext.w	a4,a5
    80005cb0:	47b5                	li	a5,13
    80005cb2:	00e7dc63          	bge	a5,a4,80005cca <skipelem+0x9e>
    memmove(name, s, DIRSIZ);
    80005cb6:	4639                	li	a2,14
    80005cb8:	fe843583          	ld	a1,-24(s0)
    80005cbc:	fd043503          	ld	a0,-48(s0)
    80005cc0:	ffffc097          	auipc	ra,0xffffc
    80005cc4:	8c4080e7          	jalr	-1852(ra) # 80001584 <memmove>
    80005cc8:	a80d                	j	80005cfa <skipelem+0xce>
  else {
    memmove(name, s, len);
    80005cca:	fe442783          	lw	a5,-28(s0)
    80005cce:	863e                	mv	a2,a5
    80005cd0:	fe843583          	ld	a1,-24(s0)
    80005cd4:	fd043503          	ld	a0,-48(s0)
    80005cd8:	ffffc097          	auipc	ra,0xffffc
    80005cdc:	8ac080e7          	jalr	-1876(ra) # 80001584 <memmove>
    name[len] = 0;
    80005ce0:	fe442783          	lw	a5,-28(s0)
    80005ce4:	fd043703          	ld	a4,-48(s0)
    80005ce8:	97ba                	add	a5,a5,a4
    80005cea:	00078023          	sb	zero,0(a5)
  }
  while(*path == '/')
    80005cee:	a031                	j	80005cfa <skipelem+0xce>
    path++;
    80005cf0:	fd843783          	ld	a5,-40(s0)
    80005cf4:	0785                	addi	a5,a5,1
    80005cf6:	fcf43c23          	sd	a5,-40(s0)
  while(*path == '/')
    80005cfa:	fd843783          	ld	a5,-40(s0)
    80005cfe:	0007c783          	lbu	a5,0(a5)
    80005d02:	873e                	mv	a4,a5
    80005d04:	02f00793          	li	a5,47
    80005d08:	fef704e3          	beq	a4,a5,80005cf0 <skipelem+0xc4>
  return path;
    80005d0c:	fd843783          	ld	a5,-40(s0)
}
    80005d10:	853e                	mv	a0,a5
    80005d12:	70a2                	ld	ra,40(sp)
    80005d14:	7402                	ld	s0,32(sp)
    80005d16:	6145                	addi	sp,sp,48
    80005d18:	8082                	ret

0000000080005d1a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80005d1a:	7139                	addi	sp,sp,-64
    80005d1c:	fc06                	sd	ra,56(sp)
    80005d1e:	f822                	sd	s0,48(sp)
    80005d20:	0080                	addi	s0,sp,64
    80005d22:	fca43c23          	sd	a0,-40(s0)
    80005d26:	87ae                	mv	a5,a1
    80005d28:	fcc43423          	sd	a2,-56(s0)
    80005d2c:	fcf42a23          	sw	a5,-44(s0)
  struct inode *ip, *next;

  if(*path == '/')
    80005d30:	fd843783          	ld	a5,-40(s0)
    80005d34:	0007c783          	lbu	a5,0(a5)
    80005d38:	873e                	mv	a4,a5
    80005d3a:	02f00793          	li	a5,47
    80005d3e:	00f71b63          	bne	a4,a5,80005d54 <namex+0x3a>
    ip = iget(ROOTDEV, ROOTINO);
    80005d42:	4585                	li	a1,1
    80005d44:	4505                	li	a0,1
    80005d46:	fffff097          	auipc	ra,0xfffff
    80005d4a:	272080e7          	jalr	626(ra) # 80004fb8 <iget>
    80005d4e:	fea43423          	sd	a0,-24(s0)
    80005d52:	a07d                	j	80005e00 <namex+0xe6>
  else
    ip = idup(myproc()->cwd);
    80005d54:	ffffd097          	auipc	ra,0xffffd
    80005d58:	b68080e7          	jalr	-1176(ra) # 800028bc <myproc>
    80005d5c:	87aa                	mv	a5,a0
    80005d5e:	1507b783          	ld	a5,336(a5)
    80005d62:	853e                	mv	a0,a5
    80005d64:	fffff097          	auipc	ra,0xfffff
    80005d68:	370080e7          	jalr	880(ra) # 800050d4 <idup>
    80005d6c:	fea43423          	sd	a0,-24(s0)

  while((path = skipelem(path, name)) != 0){
    80005d70:	a841                	j	80005e00 <namex+0xe6>
    ilock(ip);
    80005d72:	fe843503          	ld	a0,-24(s0)
    80005d76:	fffff097          	auipc	ra,0xfffff
    80005d7a:	3aa080e7          	jalr	938(ra) # 80005120 <ilock>
    if(ip->type != T_DIR){
    80005d7e:	fe843783          	ld	a5,-24(s0)
    80005d82:	04479703          	lh	a4,68(a5)
    80005d86:	4785                	li	a5,1
    80005d88:	00f70a63          	beq	a4,a5,80005d9c <namex+0x82>
      iunlockput(ip);
    80005d8c:	fe843503          	ld	a0,-24(s0)
    80005d90:	fffff097          	auipc	ra,0xfffff
    80005d94:	5ec080e7          	jalr	1516(ra) # 8000537c <iunlockput>
      return 0;
    80005d98:	4781                	li	a5,0
    80005d9a:	a871                	j	80005e36 <namex+0x11c>
    }
    if(nameiparent && *path == '\0'){
    80005d9c:	fd442783          	lw	a5,-44(s0)
    80005da0:	2781                	sext.w	a5,a5
    80005da2:	cf99                	beqz	a5,80005dc0 <namex+0xa6>
    80005da4:	fd843783          	ld	a5,-40(s0)
    80005da8:	0007c783          	lbu	a5,0(a5)
    80005dac:	eb91                	bnez	a5,80005dc0 <namex+0xa6>
      // Stop one level early.
      iunlock(ip);
    80005dae:	fe843503          	ld	a0,-24(s0)
    80005db2:	fffff097          	auipc	ra,0xfffff
    80005db6:	4a2080e7          	jalr	1186(ra) # 80005254 <iunlock>
      return ip;
    80005dba:	fe843783          	ld	a5,-24(s0)
    80005dbe:	a8a5                	j	80005e36 <namex+0x11c>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
    80005dc0:	4601                	li	a2,0
    80005dc2:	fc843583          	ld	a1,-56(s0)
    80005dc6:	fe843503          	ld	a0,-24(s0)
    80005dca:	00000097          	auipc	ra,0x0
    80005dce:	c88080e7          	jalr	-888(ra) # 80005a52 <dirlookup>
    80005dd2:	fea43023          	sd	a0,-32(s0)
    80005dd6:	fe043783          	ld	a5,-32(s0)
    80005dda:	eb89                	bnez	a5,80005dec <namex+0xd2>
      iunlockput(ip);
    80005ddc:	fe843503          	ld	a0,-24(s0)
    80005de0:	fffff097          	auipc	ra,0xfffff
    80005de4:	59c080e7          	jalr	1436(ra) # 8000537c <iunlockput>
      return 0;
    80005de8:	4781                	li	a5,0
    80005dea:	a0b1                	j	80005e36 <namex+0x11c>
    }
    iunlockput(ip);
    80005dec:	fe843503          	ld	a0,-24(s0)
    80005df0:	fffff097          	auipc	ra,0xfffff
    80005df4:	58c080e7          	jalr	1420(ra) # 8000537c <iunlockput>
    ip = next;
    80005df8:	fe043783          	ld	a5,-32(s0)
    80005dfc:	fef43423          	sd	a5,-24(s0)
  while((path = skipelem(path, name)) != 0){
    80005e00:	fc843583          	ld	a1,-56(s0)
    80005e04:	fd843503          	ld	a0,-40(s0)
    80005e08:	00000097          	auipc	ra,0x0
    80005e0c:	e24080e7          	jalr	-476(ra) # 80005c2c <skipelem>
    80005e10:	fca43c23          	sd	a0,-40(s0)
    80005e14:	fd843783          	ld	a5,-40(s0)
    80005e18:	ffa9                	bnez	a5,80005d72 <namex+0x58>
  }
  if(nameiparent){
    80005e1a:	fd442783          	lw	a5,-44(s0)
    80005e1e:	2781                	sext.w	a5,a5
    80005e20:	cb89                	beqz	a5,80005e32 <namex+0x118>
    iput(ip);
    80005e22:	fe843503          	ld	a0,-24(s0)
    80005e26:	fffff097          	auipc	ra,0xfffff
    80005e2a:	488080e7          	jalr	1160(ra) # 800052ae <iput>
    return 0;
    80005e2e:	4781                	li	a5,0
    80005e30:	a019                	j	80005e36 <namex+0x11c>
  }
  return ip;
    80005e32:	fe843783          	ld	a5,-24(s0)
}
    80005e36:	853e                	mv	a0,a5
    80005e38:	70e2                	ld	ra,56(sp)
    80005e3a:	7442                	ld	s0,48(sp)
    80005e3c:	6121                	addi	sp,sp,64
    80005e3e:	8082                	ret

0000000080005e40 <namei>:

struct inode*
namei(char *path)
{
    80005e40:	7179                	addi	sp,sp,-48
    80005e42:	f406                	sd	ra,40(sp)
    80005e44:	f022                	sd	s0,32(sp)
    80005e46:	1800                	addi	s0,sp,48
    80005e48:	fca43c23          	sd	a0,-40(s0)
  char name[DIRSIZ];
  return namex(path, 0, name);
    80005e4c:	fe040793          	addi	a5,s0,-32
    80005e50:	863e                	mv	a2,a5
    80005e52:	4581                	li	a1,0
    80005e54:	fd843503          	ld	a0,-40(s0)
    80005e58:	00000097          	auipc	ra,0x0
    80005e5c:	ec2080e7          	jalr	-318(ra) # 80005d1a <namex>
    80005e60:	87aa                	mv	a5,a0
}
    80005e62:	853e                	mv	a0,a5
    80005e64:	70a2                	ld	ra,40(sp)
    80005e66:	7402                	ld	s0,32(sp)
    80005e68:	6145                	addi	sp,sp,48
    80005e6a:	8082                	ret

0000000080005e6c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80005e6c:	1101                	addi	sp,sp,-32
    80005e6e:	ec06                	sd	ra,24(sp)
    80005e70:	e822                	sd	s0,16(sp)
    80005e72:	1000                	addi	s0,sp,32
    80005e74:	fea43423          	sd	a0,-24(s0)
    80005e78:	feb43023          	sd	a1,-32(s0)
  return namex(path, 1, name);
    80005e7c:	fe043603          	ld	a2,-32(s0)
    80005e80:	4585                	li	a1,1
    80005e82:	fe843503          	ld	a0,-24(s0)
    80005e86:	00000097          	auipc	ra,0x0
    80005e8a:	e94080e7          	jalr	-364(ra) # 80005d1a <namex>
    80005e8e:	87aa                	mv	a5,a0
}
    80005e90:	853e                	mv	a0,a5
    80005e92:	60e2                	ld	ra,24(sp)
    80005e94:	6442                	ld	s0,16(sp)
    80005e96:	6105                	addi	sp,sp,32
    80005e98:	8082                	ret

0000000080005e9a <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev, struct superblock *sb)
{
    80005e9a:	1101                	addi	sp,sp,-32
    80005e9c:	ec06                	sd	ra,24(sp)
    80005e9e:	e822                	sd	s0,16(sp)
    80005ea0:	1000                	addi	s0,sp,32
    80005ea2:	87aa                	mv	a5,a0
    80005ea4:	feb43023          	sd	a1,-32(s0)
    80005ea8:	fef42623          	sw	a5,-20(s0)
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  initlock(&log.lock, "log");
    80005eac:	00005597          	auipc	a1,0x5
    80005eb0:	6a458593          	addi	a1,a1,1700 # 8000b550 <etext+0x550>
    80005eb4:	0001e517          	auipc	a0,0x1e
    80005eb8:	c7450513          	addi	a0,a0,-908 # 80023b28 <log>
    80005ebc:	ffffb097          	auipc	ra,0xffffb
    80005ec0:	3d4080e7          	jalr	980(ra) # 80001290 <initlock>
  log.start = sb->logstart;
    80005ec4:	fe043783          	ld	a5,-32(s0)
    80005ec8:	4bdc                	lw	a5,20(a5)
    80005eca:	873e                	mv	a4,a5
    80005ecc:	0001e797          	auipc	a5,0x1e
    80005ed0:	c5c78793          	addi	a5,a5,-932 # 80023b28 <log>
    80005ed4:	cf98                	sw	a4,24(a5)
  log.size = sb->nlog;
    80005ed6:	fe043783          	ld	a5,-32(s0)
    80005eda:	4b9c                	lw	a5,16(a5)
    80005edc:	873e                	mv	a4,a5
    80005ede:	0001e797          	auipc	a5,0x1e
    80005ee2:	c4a78793          	addi	a5,a5,-950 # 80023b28 <log>
    80005ee6:	cfd8                	sw	a4,28(a5)
  log.dev = dev;
    80005ee8:	0001e797          	auipc	a5,0x1e
    80005eec:	c4078793          	addi	a5,a5,-960 # 80023b28 <log>
    80005ef0:	fec42703          	lw	a4,-20(s0)
    80005ef4:	d798                	sw	a4,40(a5)
  recover_from_log();
    80005ef6:	00000097          	auipc	ra,0x0
    80005efa:	262080e7          	jalr	610(ra) # 80006158 <recover_from_log>
}
    80005efe:	0001                	nop
    80005f00:	60e2                	ld	ra,24(sp)
    80005f02:	6442                	ld	s0,16(sp)
    80005f04:	6105                	addi	sp,sp,32
    80005f06:	8082                	ret

0000000080005f08 <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(int recovering)
{
    80005f08:	7139                	addi	sp,sp,-64
    80005f0a:	fc06                	sd	ra,56(sp)
    80005f0c:	f822                	sd	s0,48(sp)
    80005f0e:	0080                	addi	s0,sp,64
    80005f10:	87aa                	mv	a5,a0
    80005f12:	fcf42623          	sw	a5,-52(s0)
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    80005f16:	fe042623          	sw	zero,-20(s0)
    80005f1a:	a0d9                	j	80005fe0 <install_trans+0xd8>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80005f1c:	0001e797          	auipc	a5,0x1e
    80005f20:	c0c78793          	addi	a5,a5,-1012 # 80023b28 <log>
    80005f24:	579c                	lw	a5,40(a5)
    80005f26:	86be                	mv	a3,a5
    80005f28:	0001e797          	auipc	a5,0x1e
    80005f2c:	c0078793          	addi	a5,a5,-1024 # 80023b28 <log>
    80005f30:	4f9c                	lw	a5,24(a5)
    80005f32:	fec42703          	lw	a4,-20(s0)
    80005f36:	9fb9                	addw	a5,a5,a4
    80005f38:	2781                	sext.w	a5,a5
    80005f3a:	2785                	addiw	a5,a5,1
    80005f3c:	2781                	sext.w	a5,a5
    80005f3e:	85be                	mv	a1,a5
    80005f40:	8536                	mv	a0,a3
    80005f42:	fffff097          	auipc	ra,0xfffff
    80005f46:	812080e7          	jalr	-2030(ra) # 80004754 <bread>
    80005f4a:	fea43023          	sd	a0,-32(s0)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80005f4e:	0001e797          	auipc	a5,0x1e
    80005f52:	bda78793          	addi	a5,a5,-1062 # 80023b28 <log>
    80005f56:	579c                	lw	a5,40(a5)
    80005f58:	86be                	mv	a3,a5
    80005f5a:	0001e717          	auipc	a4,0x1e
    80005f5e:	bce70713          	addi	a4,a4,-1074 # 80023b28 <log>
    80005f62:	fec42783          	lw	a5,-20(s0)
    80005f66:	07a1                	addi	a5,a5,8
    80005f68:	078a                	slli	a5,a5,0x2
    80005f6a:	97ba                	add	a5,a5,a4
    80005f6c:	4b9c                	lw	a5,16(a5)
    80005f6e:	85be                	mv	a1,a5
    80005f70:	8536                	mv	a0,a3
    80005f72:	ffffe097          	auipc	ra,0xffffe
    80005f76:	7e2080e7          	jalr	2018(ra) # 80004754 <bread>
    80005f7a:	fca43c23          	sd	a0,-40(s0)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80005f7e:	fd843783          	ld	a5,-40(s0)
    80005f82:	05878713          	addi	a4,a5,88
    80005f86:	fe043783          	ld	a5,-32(s0)
    80005f8a:	05878793          	addi	a5,a5,88
    80005f8e:	40000613          	li	a2,1024
    80005f92:	85be                	mv	a1,a5
    80005f94:	853a                	mv	a0,a4
    80005f96:	ffffb097          	auipc	ra,0xffffb
    80005f9a:	5ee080e7          	jalr	1518(ra) # 80001584 <memmove>
    bwrite(dbuf);  // write dst to disk
    80005f9e:	fd843503          	ld	a0,-40(s0)
    80005fa2:	fffff097          	auipc	ra,0xfffff
    80005fa6:	80c080e7          	jalr	-2036(ra) # 800047ae <bwrite>
    if(recovering == 0)
    80005faa:	fcc42783          	lw	a5,-52(s0)
    80005fae:	2781                	sext.w	a5,a5
    80005fb0:	e799                	bnez	a5,80005fbe <install_trans+0xb6>
      bunpin(dbuf);
    80005fb2:	fd843503          	ld	a0,-40(s0)
    80005fb6:	fffff097          	auipc	ra,0xfffff
    80005fba:	976080e7          	jalr	-1674(ra) # 8000492c <bunpin>
    brelse(lbuf);
    80005fbe:	fe043503          	ld	a0,-32(s0)
    80005fc2:	fffff097          	auipc	ra,0xfffff
    80005fc6:	834080e7          	jalr	-1996(ra) # 800047f6 <brelse>
    brelse(dbuf);
    80005fca:	fd843503          	ld	a0,-40(s0)
    80005fce:	fffff097          	auipc	ra,0xfffff
    80005fd2:	828080e7          	jalr	-2008(ra) # 800047f6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80005fd6:	fec42783          	lw	a5,-20(s0)
    80005fda:	2785                	addiw	a5,a5,1
    80005fdc:	fef42623          	sw	a5,-20(s0)
    80005fe0:	0001e797          	auipc	a5,0x1e
    80005fe4:	b4878793          	addi	a5,a5,-1208 # 80023b28 <log>
    80005fe8:	57dc                	lw	a5,44(a5)
    80005fea:	fec42703          	lw	a4,-20(s0)
    80005fee:	2701                	sext.w	a4,a4
    80005ff0:	f2f746e3          	blt	a4,a5,80005f1c <install_trans+0x14>
  }
}
    80005ff4:	0001                	nop
    80005ff6:	0001                	nop
    80005ff8:	70e2                	ld	ra,56(sp)
    80005ffa:	7442                	ld	s0,48(sp)
    80005ffc:	6121                	addi	sp,sp,64
    80005ffe:	8082                	ret

0000000080006000 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
    80006000:	7179                	addi	sp,sp,-48
    80006002:	f406                	sd	ra,40(sp)
    80006004:	f022                	sd	s0,32(sp)
    80006006:	1800                	addi	s0,sp,48
  struct buf *buf = bread(log.dev, log.start);
    80006008:	0001e797          	auipc	a5,0x1e
    8000600c:	b2078793          	addi	a5,a5,-1248 # 80023b28 <log>
    80006010:	579c                	lw	a5,40(a5)
    80006012:	873e                	mv	a4,a5
    80006014:	0001e797          	auipc	a5,0x1e
    80006018:	b1478793          	addi	a5,a5,-1260 # 80023b28 <log>
    8000601c:	4f9c                	lw	a5,24(a5)
    8000601e:	85be                	mv	a1,a5
    80006020:	853a                	mv	a0,a4
    80006022:	ffffe097          	auipc	ra,0xffffe
    80006026:	732080e7          	jalr	1842(ra) # 80004754 <bread>
    8000602a:	fea43023          	sd	a0,-32(s0)
  struct logheader *lh = (struct logheader *) (buf->data);
    8000602e:	fe043783          	ld	a5,-32(s0)
    80006032:	05878793          	addi	a5,a5,88
    80006036:	fcf43c23          	sd	a5,-40(s0)
  int i;
  log.lh.n = lh->n;
    8000603a:	fd843783          	ld	a5,-40(s0)
    8000603e:	4398                	lw	a4,0(a5)
    80006040:	0001e797          	auipc	a5,0x1e
    80006044:	ae878793          	addi	a5,a5,-1304 # 80023b28 <log>
    80006048:	d7d8                	sw	a4,44(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000604a:	fe042623          	sw	zero,-20(s0)
    8000604e:	a03d                	j	8000607c <read_head+0x7c>
    log.lh.block[i] = lh->block[i];
    80006050:	fd843703          	ld	a4,-40(s0)
    80006054:	fec42783          	lw	a5,-20(s0)
    80006058:	078a                	slli	a5,a5,0x2
    8000605a:	97ba                	add	a5,a5,a4
    8000605c:	43d8                	lw	a4,4(a5)
    8000605e:	0001e697          	auipc	a3,0x1e
    80006062:	aca68693          	addi	a3,a3,-1334 # 80023b28 <log>
    80006066:	fec42783          	lw	a5,-20(s0)
    8000606a:	07a1                	addi	a5,a5,8
    8000606c:	078a                	slli	a5,a5,0x2
    8000606e:	97b6                	add	a5,a5,a3
    80006070:	cb98                	sw	a4,16(a5)
  for (i = 0; i < log.lh.n; i++) {
    80006072:	fec42783          	lw	a5,-20(s0)
    80006076:	2785                	addiw	a5,a5,1
    80006078:	fef42623          	sw	a5,-20(s0)
    8000607c:	0001e797          	auipc	a5,0x1e
    80006080:	aac78793          	addi	a5,a5,-1364 # 80023b28 <log>
    80006084:	57dc                	lw	a5,44(a5)
    80006086:	fec42703          	lw	a4,-20(s0)
    8000608a:	2701                	sext.w	a4,a4
    8000608c:	fcf742e3          	blt	a4,a5,80006050 <read_head+0x50>
  }
  brelse(buf);
    80006090:	fe043503          	ld	a0,-32(s0)
    80006094:	ffffe097          	auipc	ra,0xffffe
    80006098:	762080e7          	jalr	1890(ra) # 800047f6 <brelse>
}
    8000609c:	0001                	nop
    8000609e:	70a2                	ld	ra,40(sp)
    800060a0:	7402                	ld	s0,32(sp)
    800060a2:	6145                	addi	sp,sp,48
    800060a4:	8082                	ret

00000000800060a6 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800060a6:	7179                	addi	sp,sp,-48
    800060a8:	f406                	sd	ra,40(sp)
    800060aa:	f022                	sd	s0,32(sp)
    800060ac:	1800                	addi	s0,sp,48
  struct buf *buf = bread(log.dev, log.start);
    800060ae:	0001e797          	auipc	a5,0x1e
    800060b2:	a7a78793          	addi	a5,a5,-1414 # 80023b28 <log>
    800060b6:	579c                	lw	a5,40(a5)
    800060b8:	873e                	mv	a4,a5
    800060ba:	0001e797          	auipc	a5,0x1e
    800060be:	a6e78793          	addi	a5,a5,-1426 # 80023b28 <log>
    800060c2:	4f9c                	lw	a5,24(a5)
    800060c4:	85be                	mv	a1,a5
    800060c6:	853a                	mv	a0,a4
    800060c8:	ffffe097          	auipc	ra,0xffffe
    800060cc:	68c080e7          	jalr	1676(ra) # 80004754 <bread>
    800060d0:	fea43023          	sd	a0,-32(s0)
  struct logheader *hb = (struct logheader *) (buf->data);
    800060d4:	fe043783          	ld	a5,-32(s0)
    800060d8:	05878793          	addi	a5,a5,88
    800060dc:	fcf43c23          	sd	a5,-40(s0)
  int i;
  hb->n = log.lh.n;
    800060e0:	0001e797          	auipc	a5,0x1e
    800060e4:	a4878793          	addi	a5,a5,-1464 # 80023b28 <log>
    800060e8:	57d8                	lw	a4,44(a5)
    800060ea:	fd843783          	ld	a5,-40(s0)
    800060ee:	c398                	sw	a4,0(a5)
  for (i = 0; i < log.lh.n; i++) {
    800060f0:	fe042623          	sw	zero,-20(s0)
    800060f4:	a03d                	j	80006122 <write_head+0x7c>
    hb->block[i] = log.lh.block[i];
    800060f6:	0001e717          	auipc	a4,0x1e
    800060fa:	a3270713          	addi	a4,a4,-1486 # 80023b28 <log>
    800060fe:	fec42783          	lw	a5,-20(s0)
    80006102:	07a1                	addi	a5,a5,8
    80006104:	078a                	slli	a5,a5,0x2
    80006106:	97ba                	add	a5,a5,a4
    80006108:	4b98                	lw	a4,16(a5)
    8000610a:	fd843683          	ld	a3,-40(s0)
    8000610e:	fec42783          	lw	a5,-20(s0)
    80006112:	078a                	slli	a5,a5,0x2
    80006114:	97b6                	add	a5,a5,a3
    80006116:	c3d8                	sw	a4,4(a5)
  for (i = 0; i < log.lh.n; i++) {
    80006118:	fec42783          	lw	a5,-20(s0)
    8000611c:	2785                	addiw	a5,a5,1
    8000611e:	fef42623          	sw	a5,-20(s0)
    80006122:	0001e797          	auipc	a5,0x1e
    80006126:	a0678793          	addi	a5,a5,-1530 # 80023b28 <log>
    8000612a:	57dc                	lw	a5,44(a5)
    8000612c:	fec42703          	lw	a4,-20(s0)
    80006130:	2701                	sext.w	a4,a4
    80006132:	fcf742e3          	blt	a4,a5,800060f6 <write_head+0x50>
  }
  bwrite(buf);
    80006136:	fe043503          	ld	a0,-32(s0)
    8000613a:	ffffe097          	auipc	ra,0xffffe
    8000613e:	674080e7          	jalr	1652(ra) # 800047ae <bwrite>
  brelse(buf);
    80006142:	fe043503          	ld	a0,-32(s0)
    80006146:	ffffe097          	auipc	ra,0xffffe
    8000614a:	6b0080e7          	jalr	1712(ra) # 800047f6 <brelse>
}
    8000614e:	0001                	nop
    80006150:	70a2                	ld	ra,40(sp)
    80006152:	7402                	ld	s0,32(sp)
    80006154:	6145                	addi	sp,sp,48
    80006156:	8082                	ret

0000000080006158 <recover_from_log>:

static void
recover_from_log(void)
{
    80006158:	1141                	addi	sp,sp,-16
    8000615a:	e406                	sd	ra,8(sp)
    8000615c:	e022                	sd	s0,0(sp)
    8000615e:	0800                	addi	s0,sp,16
  read_head();
    80006160:	00000097          	auipc	ra,0x0
    80006164:	ea0080e7          	jalr	-352(ra) # 80006000 <read_head>
  install_trans(1); // if committed, copy from log to disk
    80006168:	4505                	li	a0,1
    8000616a:	00000097          	auipc	ra,0x0
    8000616e:	d9e080e7          	jalr	-610(ra) # 80005f08 <install_trans>
  log.lh.n = 0;
    80006172:	0001e797          	auipc	a5,0x1e
    80006176:	9b678793          	addi	a5,a5,-1610 # 80023b28 <log>
    8000617a:	0207a623          	sw	zero,44(a5)
  write_head(); // clear the log
    8000617e:	00000097          	auipc	ra,0x0
    80006182:	f28080e7          	jalr	-216(ra) # 800060a6 <write_head>
}
    80006186:	0001                	nop
    80006188:	60a2                	ld	ra,8(sp)
    8000618a:	6402                	ld	s0,0(sp)
    8000618c:	0141                	addi	sp,sp,16
    8000618e:	8082                	ret

0000000080006190 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
    80006190:	1141                	addi	sp,sp,-16
    80006192:	e406                	sd	ra,8(sp)
    80006194:	e022                	sd	s0,0(sp)
    80006196:	0800                	addi	s0,sp,16
  acquire(&log.lock);
    80006198:	0001e517          	auipc	a0,0x1e
    8000619c:	99050513          	addi	a0,a0,-1648 # 80023b28 <log>
    800061a0:	ffffb097          	auipc	ra,0xffffb
    800061a4:	124080e7          	jalr	292(ra) # 800012c4 <acquire>
  while(1){
    if(log.committing){
    800061a8:	0001e797          	auipc	a5,0x1e
    800061ac:	98078793          	addi	a5,a5,-1664 # 80023b28 <log>
    800061b0:	53dc                	lw	a5,36(a5)
    800061b2:	cf91                	beqz	a5,800061ce <begin_op+0x3e>
      sleep(&log, &log.lock);
    800061b4:	0001e597          	auipc	a1,0x1e
    800061b8:	97458593          	addi	a1,a1,-1676 # 80023b28 <log>
    800061bc:	0001e517          	auipc	a0,0x1e
    800061c0:	96c50513          	addi	a0,a0,-1684 # 80023b28 <log>
    800061c4:	ffffd097          	auipc	ra,0xffffd
    800061c8:	2b2080e7          	jalr	690(ra) # 80003476 <sleep>
    800061cc:	bff1                	j	800061a8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800061ce:	0001e797          	auipc	a5,0x1e
    800061d2:	95a78793          	addi	a5,a5,-1702 # 80023b28 <log>
    800061d6:	57d8                	lw	a4,44(a5)
    800061d8:	0001e797          	auipc	a5,0x1e
    800061dc:	95078793          	addi	a5,a5,-1712 # 80023b28 <log>
    800061e0:	539c                	lw	a5,32(a5)
    800061e2:	2785                	addiw	a5,a5,1
    800061e4:	2781                	sext.w	a5,a5
    800061e6:	86be                	mv	a3,a5
    800061e8:	87b6                	mv	a5,a3
    800061ea:	0027979b          	slliw	a5,a5,0x2
    800061ee:	9fb5                	addw	a5,a5,a3
    800061f0:	0017979b          	slliw	a5,a5,0x1
    800061f4:	2781                	sext.w	a5,a5
    800061f6:	9fb9                	addw	a5,a5,a4
    800061f8:	0007871b          	sext.w	a4,a5
    800061fc:	47f9                	li	a5,30
    800061fe:	00e7df63          	bge	a5,a4,8000621c <begin_op+0x8c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80006202:	0001e597          	auipc	a1,0x1e
    80006206:	92658593          	addi	a1,a1,-1754 # 80023b28 <log>
    8000620a:	0001e517          	auipc	a0,0x1e
    8000620e:	91e50513          	addi	a0,a0,-1762 # 80023b28 <log>
    80006212:	ffffd097          	auipc	ra,0xffffd
    80006216:	264080e7          	jalr	612(ra) # 80003476 <sleep>
    8000621a:	b779                	j	800061a8 <begin_op+0x18>
    } else {
      log.outstanding += 1;
    8000621c:	0001e797          	auipc	a5,0x1e
    80006220:	90c78793          	addi	a5,a5,-1780 # 80023b28 <log>
    80006224:	539c                	lw	a5,32(a5)
    80006226:	2785                	addiw	a5,a5,1
    80006228:	0007871b          	sext.w	a4,a5
    8000622c:	0001e797          	auipc	a5,0x1e
    80006230:	8fc78793          	addi	a5,a5,-1796 # 80023b28 <log>
    80006234:	d398                	sw	a4,32(a5)
      release(&log.lock);
    80006236:	0001e517          	auipc	a0,0x1e
    8000623a:	8f250513          	addi	a0,a0,-1806 # 80023b28 <log>
    8000623e:	ffffb097          	auipc	ra,0xffffb
    80006242:	0ea080e7          	jalr	234(ra) # 80001328 <release>
      break;
    80006246:	0001                	nop
    }
  }
}
    80006248:	0001                	nop
    8000624a:	60a2                	ld	ra,8(sp)
    8000624c:	6402                	ld	s0,0(sp)
    8000624e:	0141                	addi	sp,sp,16
    80006250:	8082                	ret

0000000080006252 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80006252:	1101                	addi	sp,sp,-32
    80006254:	ec06                	sd	ra,24(sp)
    80006256:	e822                	sd	s0,16(sp)
    80006258:	1000                	addi	s0,sp,32
  int do_commit = 0;
    8000625a:	fe042623          	sw	zero,-20(s0)

  acquire(&log.lock);
    8000625e:	0001e517          	auipc	a0,0x1e
    80006262:	8ca50513          	addi	a0,a0,-1846 # 80023b28 <log>
    80006266:	ffffb097          	auipc	ra,0xffffb
    8000626a:	05e080e7          	jalr	94(ra) # 800012c4 <acquire>
  log.outstanding -= 1;
    8000626e:	0001e797          	auipc	a5,0x1e
    80006272:	8ba78793          	addi	a5,a5,-1862 # 80023b28 <log>
    80006276:	539c                	lw	a5,32(a5)
    80006278:	37fd                	addiw	a5,a5,-1
    8000627a:	0007871b          	sext.w	a4,a5
    8000627e:	0001e797          	auipc	a5,0x1e
    80006282:	8aa78793          	addi	a5,a5,-1878 # 80023b28 <log>
    80006286:	d398                	sw	a4,32(a5)
  if(log.committing)
    80006288:	0001e797          	auipc	a5,0x1e
    8000628c:	8a078793          	addi	a5,a5,-1888 # 80023b28 <log>
    80006290:	53dc                	lw	a5,36(a5)
    80006292:	cb89                	beqz	a5,800062a4 <end_op+0x52>
    panic("log.committing");
    80006294:	00005517          	auipc	a0,0x5
    80006298:	2c450513          	addi	a0,a0,708 # 8000b558 <etext+0x558>
    8000629c:	ffffb097          	auipc	ra,0xffffb
    800062a0:	a24080e7          	jalr	-1500(ra) # 80000cc0 <panic>
  if(log.outstanding == 0){
    800062a4:	0001e797          	auipc	a5,0x1e
    800062a8:	88478793          	addi	a5,a5,-1916 # 80023b28 <log>
    800062ac:	539c                	lw	a5,32(a5)
    800062ae:	eb99                	bnez	a5,800062c4 <end_op+0x72>
    do_commit = 1;
    800062b0:	4785                	li	a5,1
    800062b2:	fef42623          	sw	a5,-20(s0)
    log.committing = 1;
    800062b6:	0001e797          	auipc	a5,0x1e
    800062ba:	87278793          	addi	a5,a5,-1934 # 80023b28 <log>
    800062be:	4705                	li	a4,1
    800062c0:	d3d8                	sw	a4,36(a5)
    800062c2:	a809                	j	800062d4 <end_op+0x82>
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
    800062c4:	0001e517          	auipc	a0,0x1e
    800062c8:	86450513          	addi	a0,a0,-1948 # 80023b28 <log>
    800062cc:	ffffd097          	auipc	ra,0xffffd
    800062d0:	226080e7          	jalr	550(ra) # 800034f2 <wakeup>
  }
  release(&log.lock);
    800062d4:	0001e517          	auipc	a0,0x1e
    800062d8:	85450513          	addi	a0,a0,-1964 # 80023b28 <log>
    800062dc:	ffffb097          	auipc	ra,0xffffb
    800062e0:	04c080e7          	jalr	76(ra) # 80001328 <release>

  if(do_commit){
    800062e4:	fec42783          	lw	a5,-20(s0)
    800062e8:	2781                	sext.w	a5,a5
    800062ea:	c3b9                	beqz	a5,80006330 <end_op+0xde>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    800062ec:	00000097          	auipc	ra,0x0
    800062f0:	12c080e7          	jalr	300(ra) # 80006418 <commit>
    acquire(&log.lock);
    800062f4:	0001e517          	auipc	a0,0x1e
    800062f8:	83450513          	addi	a0,a0,-1996 # 80023b28 <log>
    800062fc:	ffffb097          	auipc	ra,0xffffb
    80006300:	fc8080e7          	jalr	-56(ra) # 800012c4 <acquire>
    log.committing = 0;
    80006304:	0001e797          	auipc	a5,0x1e
    80006308:	82478793          	addi	a5,a5,-2012 # 80023b28 <log>
    8000630c:	0207a223          	sw	zero,36(a5)
    wakeup(&log);
    80006310:	0001e517          	auipc	a0,0x1e
    80006314:	81850513          	addi	a0,a0,-2024 # 80023b28 <log>
    80006318:	ffffd097          	auipc	ra,0xffffd
    8000631c:	1da080e7          	jalr	474(ra) # 800034f2 <wakeup>
    release(&log.lock);
    80006320:	0001e517          	auipc	a0,0x1e
    80006324:	80850513          	addi	a0,a0,-2040 # 80023b28 <log>
    80006328:	ffffb097          	auipc	ra,0xffffb
    8000632c:	000080e7          	jalr	ra # 80001328 <release>
  }
}
    80006330:	0001                	nop
    80006332:	60e2                	ld	ra,24(sp)
    80006334:	6442                	ld	s0,16(sp)
    80006336:	6105                	addi	sp,sp,32
    80006338:	8082                	ret

000000008000633a <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
    8000633a:	7179                	addi	sp,sp,-48
    8000633c:	f406                	sd	ra,40(sp)
    8000633e:	f022                	sd	s0,32(sp)
    80006340:	1800                	addi	s0,sp,48
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    80006342:	fe042623          	sw	zero,-20(s0)
    80006346:	a84d                	j	800063f8 <write_log+0xbe>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80006348:	0001d797          	auipc	a5,0x1d
    8000634c:	7e078793          	addi	a5,a5,2016 # 80023b28 <log>
    80006350:	579c                	lw	a5,40(a5)
    80006352:	86be                	mv	a3,a5
    80006354:	0001d797          	auipc	a5,0x1d
    80006358:	7d478793          	addi	a5,a5,2004 # 80023b28 <log>
    8000635c:	4f9c                	lw	a5,24(a5)
    8000635e:	fec42703          	lw	a4,-20(s0)
    80006362:	9fb9                	addw	a5,a5,a4
    80006364:	2781                	sext.w	a5,a5
    80006366:	2785                	addiw	a5,a5,1
    80006368:	2781                	sext.w	a5,a5
    8000636a:	85be                	mv	a1,a5
    8000636c:	8536                	mv	a0,a3
    8000636e:	ffffe097          	auipc	ra,0xffffe
    80006372:	3e6080e7          	jalr	998(ra) # 80004754 <bread>
    80006376:	fea43023          	sd	a0,-32(s0)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000637a:	0001d797          	auipc	a5,0x1d
    8000637e:	7ae78793          	addi	a5,a5,1966 # 80023b28 <log>
    80006382:	579c                	lw	a5,40(a5)
    80006384:	86be                	mv	a3,a5
    80006386:	0001d717          	auipc	a4,0x1d
    8000638a:	7a270713          	addi	a4,a4,1954 # 80023b28 <log>
    8000638e:	fec42783          	lw	a5,-20(s0)
    80006392:	07a1                	addi	a5,a5,8
    80006394:	078a                	slli	a5,a5,0x2
    80006396:	97ba                	add	a5,a5,a4
    80006398:	4b9c                	lw	a5,16(a5)
    8000639a:	85be                	mv	a1,a5
    8000639c:	8536                	mv	a0,a3
    8000639e:	ffffe097          	auipc	ra,0xffffe
    800063a2:	3b6080e7          	jalr	950(ra) # 80004754 <bread>
    800063a6:	fca43c23          	sd	a0,-40(s0)
    memmove(to->data, from->data, BSIZE);
    800063aa:	fe043783          	ld	a5,-32(s0)
    800063ae:	05878713          	addi	a4,a5,88
    800063b2:	fd843783          	ld	a5,-40(s0)
    800063b6:	05878793          	addi	a5,a5,88
    800063ba:	40000613          	li	a2,1024
    800063be:	85be                	mv	a1,a5
    800063c0:	853a                	mv	a0,a4
    800063c2:	ffffb097          	auipc	ra,0xffffb
    800063c6:	1c2080e7          	jalr	450(ra) # 80001584 <memmove>
    bwrite(to);  // write the log
    800063ca:	fe043503          	ld	a0,-32(s0)
    800063ce:	ffffe097          	auipc	ra,0xffffe
    800063d2:	3e0080e7          	jalr	992(ra) # 800047ae <bwrite>
    brelse(from);
    800063d6:	fd843503          	ld	a0,-40(s0)
    800063da:	ffffe097          	auipc	ra,0xffffe
    800063de:	41c080e7          	jalr	1052(ra) # 800047f6 <brelse>
    brelse(to);
    800063e2:	fe043503          	ld	a0,-32(s0)
    800063e6:	ffffe097          	auipc	ra,0xffffe
    800063ea:	410080e7          	jalr	1040(ra) # 800047f6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800063ee:	fec42783          	lw	a5,-20(s0)
    800063f2:	2785                	addiw	a5,a5,1
    800063f4:	fef42623          	sw	a5,-20(s0)
    800063f8:	0001d797          	auipc	a5,0x1d
    800063fc:	73078793          	addi	a5,a5,1840 # 80023b28 <log>
    80006400:	57dc                	lw	a5,44(a5)
    80006402:	fec42703          	lw	a4,-20(s0)
    80006406:	2701                	sext.w	a4,a4
    80006408:	f4f740e3          	blt	a4,a5,80006348 <write_log+0xe>
  }
}
    8000640c:	0001                	nop
    8000640e:	0001                	nop
    80006410:	70a2                	ld	ra,40(sp)
    80006412:	7402                	ld	s0,32(sp)
    80006414:	6145                	addi	sp,sp,48
    80006416:	8082                	ret

0000000080006418 <commit>:

static void
commit()
{
    80006418:	1141                	addi	sp,sp,-16
    8000641a:	e406                	sd	ra,8(sp)
    8000641c:	e022                	sd	s0,0(sp)
    8000641e:	0800                	addi	s0,sp,16
  if (log.lh.n > 0) {
    80006420:	0001d797          	auipc	a5,0x1d
    80006424:	70878793          	addi	a5,a5,1800 # 80023b28 <log>
    80006428:	57dc                	lw	a5,44(a5)
    8000642a:	02f05963          	blez	a5,8000645c <commit+0x44>
    write_log();     // Write modified blocks from cache to log
    8000642e:	00000097          	auipc	ra,0x0
    80006432:	f0c080e7          	jalr	-244(ra) # 8000633a <write_log>
    write_head();    // Write header to disk -- the real commit
    80006436:	00000097          	auipc	ra,0x0
    8000643a:	c70080e7          	jalr	-912(ra) # 800060a6 <write_head>
    install_trans(0); // Now install writes to home locations
    8000643e:	4501                	li	a0,0
    80006440:	00000097          	auipc	ra,0x0
    80006444:	ac8080e7          	jalr	-1336(ra) # 80005f08 <install_trans>
    log.lh.n = 0;
    80006448:	0001d797          	auipc	a5,0x1d
    8000644c:	6e078793          	addi	a5,a5,1760 # 80023b28 <log>
    80006450:	0207a623          	sw	zero,44(a5)
    write_head();    // Erase the transaction from the log
    80006454:	00000097          	auipc	ra,0x0
    80006458:	c52080e7          	jalr	-942(ra) # 800060a6 <write_head>
  }
}
    8000645c:	0001                	nop
    8000645e:	60a2                	ld	ra,8(sp)
    80006460:	6402                	ld	s0,0(sp)
    80006462:	0141                	addi	sp,sp,16
    80006464:	8082                	ret

0000000080006466 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80006466:	7179                	addi	sp,sp,-48
    80006468:	f406                	sd	ra,40(sp)
    8000646a:	f022                	sd	s0,32(sp)
    8000646c:	1800                	addi	s0,sp,48
    8000646e:	fca43c23          	sd	a0,-40(s0)
  int i;

  acquire(&log.lock);
    80006472:	0001d517          	auipc	a0,0x1d
    80006476:	6b650513          	addi	a0,a0,1718 # 80023b28 <log>
    8000647a:	ffffb097          	auipc	ra,0xffffb
    8000647e:	e4a080e7          	jalr	-438(ra) # 800012c4 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80006482:	0001d797          	auipc	a5,0x1d
    80006486:	6a678793          	addi	a5,a5,1702 # 80023b28 <log>
    8000648a:	57d8                	lw	a4,44(a5)
    8000648c:	47f5                	li	a5,29
    8000648e:	02e7c063          	blt	a5,a4,800064ae <log_write+0x48>
    80006492:	0001d797          	auipc	a5,0x1d
    80006496:	69678793          	addi	a5,a5,1686 # 80023b28 <log>
    8000649a:	57d8                	lw	a4,44(a5)
    8000649c:	0001d797          	auipc	a5,0x1d
    800064a0:	68c78793          	addi	a5,a5,1676 # 80023b28 <log>
    800064a4:	4fdc                	lw	a5,28(a5)
    800064a6:	37fd                	addiw	a5,a5,-1
    800064a8:	2781                	sext.w	a5,a5
    800064aa:	00f74a63          	blt	a4,a5,800064be <log_write+0x58>
    panic("too big a transaction");
    800064ae:	00005517          	auipc	a0,0x5
    800064b2:	0ba50513          	addi	a0,a0,186 # 8000b568 <etext+0x568>
    800064b6:	ffffb097          	auipc	ra,0xffffb
    800064ba:	80a080e7          	jalr	-2038(ra) # 80000cc0 <panic>
  if (log.outstanding < 1)
    800064be:	0001d797          	auipc	a5,0x1d
    800064c2:	66a78793          	addi	a5,a5,1642 # 80023b28 <log>
    800064c6:	539c                	lw	a5,32(a5)
    800064c8:	00f04a63          	bgtz	a5,800064dc <log_write+0x76>
    panic("log_write outside of trans");
    800064cc:	00005517          	auipc	a0,0x5
    800064d0:	0b450513          	addi	a0,a0,180 # 8000b580 <etext+0x580>
    800064d4:	ffffa097          	auipc	ra,0xffffa
    800064d8:	7ec080e7          	jalr	2028(ra) # 80000cc0 <panic>

  for (i = 0; i < log.lh.n; i++) {
    800064dc:	fe042623          	sw	zero,-20(s0)
    800064e0:	a035                	j	8000650c <log_write+0xa6>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800064e2:	0001d717          	auipc	a4,0x1d
    800064e6:	64670713          	addi	a4,a4,1606 # 80023b28 <log>
    800064ea:	fec42783          	lw	a5,-20(s0)
    800064ee:	07a1                	addi	a5,a5,8
    800064f0:	078a                	slli	a5,a5,0x2
    800064f2:	97ba                	add	a5,a5,a4
    800064f4:	4b9c                	lw	a5,16(a5)
    800064f6:	873e                	mv	a4,a5
    800064f8:	fd843783          	ld	a5,-40(s0)
    800064fc:	47dc                	lw	a5,12(a5)
    800064fe:	02f70263          	beq	a4,a5,80006522 <log_write+0xbc>
  for (i = 0; i < log.lh.n; i++) {
    80006502:	fec42783          	lw	a5,-20(s0)
    80006506:	2785                	addiw	a5,a5,1
    80006508:	fef42623          	sw	a5,-20(s0)
    8000650c:	0001d797          	auipc	a5,0x1d
    80006510:	61c78793          	addi	a5,a5,1564 # 80023b28 <log>
    80006514:	57dc                	lw	a5,44(a5)
    80006516:	fec42703          	lw	a4,-20(s0)
    8000651a:	2701                	sext.w	a4,a4
    8000651c:	fcf743e3          	blt	a4,a5,800064e2 <log_write+0x7c>
    80006520:	a011                	j	80006524 <log_write+0xbe>
      break;
    80006522:	0001                	nop
  }
  log.lh.block[i] = b->blockno;
    80006524:	fd843783          	ld	a5,-40(s0)
    80006528:	47dc                	lw	a5,12(a5)
    8000652a:	86be                	mv	a3,a5
    8000652c:	0001d717          	auipc	a4,0x1d
    80006530:	5fc70713          	addi	a4,a4,1532 # 80023b28 <log>
    80006534:	fec42783          	lw	a5,-20(s0)
    80006538:	07a1                	addi	a5,a5,8
    8000653a:	078a                	slli	a5,a5,0x2
    8000653c:	97ba                	add	a5,a5,a4
    8000653e:	cb94                	sw	a3,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    80006540:	0001d797          	auipc	a5,0x1d
    80006544:	5e878793          	addi	a5,a5,1512 # 80023b28 <log>
    80006548:	57dc                	lw	a5,44(a5)
    8000654a:	fec42703          	lw	a4,-20(s0)
    8000654e:	2701                	sext.w	a4,a4
    80006550:	02f71563          	bne	a4,a5,8000657a <log_write+0x114>
    bpin(b);
    80006554:	fd843503          	ld	a0,-40(s0)
    80006558:	ffffe097          	auipc	ra,0xffffe
    8000655c:	38c080e7          	jalr	908(ra) # 800048e4 <bpin>
    log.lh.n++;
    80006560:	0001d797          	auipc	a5,0x1d
    80006564:	5c878793          	addi	a5,a5,1480 # 80023b28 <log>
    80006568:	57dc                	lw	a5,44(a5)
    8000656a:	2785                	addiw	a5,a5,1
    8000656c:	0007871b          	sext.w	a4,a5
    80006570:	0001d797          	auipc	a5,0x1d
    80006574:	5b878793          	addi	a5,a5,1464 # 80023b28 <log>
    80006578:	d7d8                	sw	a4,44(a5)
  }
  release(&log.lock);
    8000657a:	0001d517          	auipc	a0,0x1d
    8000657e:	5ae50513          	addi	a0,a0,1454 # 80023b28 <log>
    80006582:	ffffb097          	auipc	ra,0xffffb
    80006586:	da6080e7          	jalr	-602(ra) # 80001328 <release>
}
    8000658a:	0001                	nop
    8000658c:	70a2                	ld	ra,40(sp)
    8000658e:	7402                	ld	s0,32(sp)
    80006590:	6145                	addi	sp,sp,48
    80006592:	8082                	ret

0000000080006594 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80006594:	1101                	addi	sp,sp,-32
    80006596:	ec06                	sd	ra,24(sp)
    80006598:	e822                	sd	s0,16(sp)
    8000659a:	1000                	addi	s0,sp,32
    8000659c:	fea43423          	sd	a0,-24(s0)
    800065a0:	feb43023          	sd	a1,-32(s0)
  initlock(&lk->lk, "sleep lock");
    800065a4:	fe843783          	ld	a5,-24(s0)
    800065a8:	07a1                	addi	a5,a5,8
    800065aa:	00005597          	auipc	a1,0x5
    800065ae:	ff658593          	addi	a1,a1,-10 # 8000b5a0 <etext+0x5a0>
    800065b2:	853e                	mv	a0,a5
    800065b4:	ffffb097          	auipc	ra,0xffffb
    800065b8:	cdc080e7          	jalr	-804(ra) # 80001290 <initlock>
  lk->name = name;
    800065bc:	fe843783          	ld	a5,-24(s0)
    800065c0:	fe043703          	ld	a4,-32(s0)
    800065c4:	f398                	sd	a4,32(a5)
  lk->locked = 0;
    800065c6:	fe843783          	ld	a5,-24(s0)
    800065ca:	0007a023          	sw	zero,0(a5)
  lk->pid = 0;
    800065ce:	fe843783          	ld	a5,-24(s0)
    800065d2:	0207a423          	sw	zero,40(a5)
}
    800065d6:	0001                	nop
    800065d8:	60e2                	ld	ra,24(sp)
    800065da:	6442                	ld	s0,16(sp)
    800065dc:	6105                	addi	sp,sp,32
    800065de:	8082                	ret

00000000800065e0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800065e0:	1101                	addi	sp,sp,-32
    800065e2:	ec06                	sd	ra,24(sp)
    800065e4:	e822                	sd	s0,16(sp)
    800065e6:	1000                	addi	s0,sp,32
    800065e8:	fea43423          	sd	a0,-24(s0)
  acquire(&lk->lk);
    800065ec:	fe843783          	ld	a5,-24(s0)
    800065f0:	07a1                	addi	a5,a5,8
    800065f2:	853e                	mv	a0,a5
    800065f4:	ffffb097          	auipc	ra,0xffffb
    800065f8:	cd0080e7          	jalr	-816(ra) # 800012c4 <acquire>
  while (lk->locked) {
    800065fc:	a819                	j	80006612 <acquiresleep+0x32>
    sleep(lk, &lk->lk);
    800065fe:	fe843783          	ld	a5,-24(s0)
    80006602:	07a1                	addi	a5,a5,8
    80006604:	85be                	mv	a1,a5
    80006606:	fe843503          	ld	a0,-24(s0)
    8000660a:	ffffd097          	auipc	ra,0xffffd
    8000660e:	e6c080e7          	jalr	-404(ra) # 80003476 <sleep>
  while (lk->locked) {
    80006612:	fe843783          	ld	a5,-24(s0)
    80006616:	439c                	lw	a5,0(a5)
    80006618:	f3fd                	bnez	a5,800065fe <acquiresleep+0x1e>
  }
  lk->locked = 1;
    8000661a:	fe843783          	ld	a5,-24(s0)
    8000661e:	4705                	li	a4,1
    80006620:	c398                	sw	a4,0(a5)
  lk->pid = myproc()->pid;
    80006622:	ffffc097          	auipc	ra,0xffffc
    80006626:	29a080e7          	jalr	666(ra) # 800028bc <myproc>
    8000662a:	87aa                	mv	a5,a0
    8000662c:	5b98                	lw	a4,48(a5)
    8000662e:	fe843783          	ld	a5,-24(s0)
    80006632:	d798                	sw	a4,40(a5)
  release(&lk->lk);
    80006634:	fe843783          	ld	a5,-24(s0)
    80006638:	07a1                	addi	a5,a5,8
    8000663a:	853e                	mv	a0,a5
    8000663c:	ffffb097          	auipc	ra,0xffffb
    80006640:	cec080e7          	jalr	-788(ra) # 80001328 <release>
}
    80006644:	0001                	nop
    80006646:	60e2                	ld	ra,24(sp)
    80006648:	6442                	ld	s0,16(sp)
    8000664a:	6105                	addi	sp,sp,32
    8000664c:	8082                	ret

000000008000664e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000664e:	1101                	addi	sp,sp,-32
    80006650:	ec06                	sd	ra,24(sp)
    80006652:	e822                	sd	s0,16(sp)
    80006654:	1000                	addi	s0,sp,32
    80006656:	fea43423          	sd	a0,-24(s0)
  acquire(&lk->lk);
    8000665a:	fe843783          	ld	a5,-24(s0)
    8000665e:	07a1                	addi	a5,a5,8
    80006660:	853e                	mv	a0,a5
    80006662:	ffffb097          	auipc	ra,0xffffb
    80006666:	c62080e7          	jalr	-926(ra) # 800012c4 <acquire>
  lk->locked = 0;
    8000666a:	fe843783          	ld	a5,-24(s0)
    8000666e:	0007a023          	sw	zero,0(a5)
  lk->pid = 0;
    80006672:	fe843783          	ld	a5,-24(s0)
    80006676:	0207a423          	sw	zero,40(a5)
  wakeup(lk);
    8000667a:	fe843503          	ld	a0,-24(s0)
    8000667e:	ffffd097          	auipc	ra,0xffffd
    80006682:	e74080e7          	jalr	-396(ra) # 800034f2 <wakeup>
  release(&lk->lk);
    80006686:	fe843783          	ld	a5,-24(s0)
    8000668a:	07a1                	addi	a5,a5,8
    8000668c:	853e                	mv	a0,a5
    8000668e:	ffffb097          	auipc	ra,0xffffb
    80006692:	c9a080e7          	jalr	-870(ra) # 80001328 <release>
}
    80006696:	0001                	nop
    80006698:	60e2                	ld	ra,24(sp)
    8000669a:	6442                	ld	s0,16(sp)
    8000669c:	6105                	addi	sp,sp,32
    8000669e:	8082                	ret

00000000800066a0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800066a0:	7139                	addi	sp,sp,-64
    800066a2:	fc06                	sd	ra,56(sp)
    800066a4:	f822                	sd	s0,48(sp)
    800066a6:	f426                	sd	s1,40(sp)
    800066a8:	0080                	addi	s0,sp,64
    800066aa:	fca43423          	sd	a0,-56(s0)
  int r;
  
  acquire(&lk->lk);
    800066ae:	fc843783          	ld	a5,-56(s0)
    800066b2:	07a1                	addi	a5,a5,8
    800066b4:	853e                	mv	a0,a5
    800066b6:	ffffb097          	auipc	ra,0xffffb
    800066ba:	c0e080e7          	jalr	-1010(ra) # 800012c4 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800066be:	fc843783          	ld	a5,-56(s0)
    800066c2:	439c                	lw	a5,0(a5)
    800066c4:	cf91                	beqz	a5,800066e0 <holdingsleep+0x40>
    800066c6:	fc843783          	ld	a5,-56(s0)
    800066ca:	5784                	lw	s1,40(a5)
    800066cc:	ffffc097          	auipc	ra,0xffffc
    800066d0:	1f0080e7          	jalr	496(ra) # 800028bc <myproc>
    800066d4:	87aa                	mv	a5,a0
    800066d6:	5b9c                	lw	a5,48(a5)
    800066d8:	00f49463          	bne	s1,a5,800066e0 <holdingsleep+0x40>
    800066dc:	4785                	li	a5,1
    800066de:	a011                	j	800066e2 <holdingsleep+0x42>
    800066e0:	4781                	li	a5,0
    800066e2:	fcf42e23          	sw	a5,-36(s0)
  release(&lk->lk);
    800066e6:	fc843783          	ld	a5,-56(s0)
    800066ea:	07a1                	addi	a5,a5,8
    800066ec:	853e                	mv	a0,a5
    800066ee:	ffffb097          	auipc	ra,0xffffb
    800066f2:	c3a080e7          	jalr	-966(ra) # 80001328 <release>
  return r;
    800066f6:	fdc42783          	lw	a5,-36(s0)
}
    800066fa:	853e                	mv	a0,a5
    800066fc:	70e2                	ld	ra,56(sp)
    800066fe:	7442                	ld	s0,48(sp)
    80006700:	74a2                	ld	s1,40(sp)
    80006702:	6121                	addi	sp,sp,64
    80006704:	8082                	ret

0000000080006706 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80006706:	1141                	addi	sp,sp,-16
    80006708:	e406                	sd	ra,8(sp)
    8000670a:	e022                	sd	s0,0(sp)
    8000670c:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000670e:	00005597          	auipc	a1,0x5
    80006712:	ea258593          	addi	a1,a1,-350 # 8000b5b0 <etext+0x5b0>
    80006716:	0001d517          	auipc	a0,0x1d
    8000671a:	55a50513          	addi	a0,a0,1370 # 80023c70 <ftable>
    8000671e:	ffffb097          	auipc	ra,0xffffb
    80006722:	b72080e7          	jalr	-1166(ra) # 80001290 <initlock>
}
    80006726:	0001                	nop
    80006728:	60a2                	ld	ra,8(sp)
    8000672a:	6402                	ld	s0,0(sp)
    8000672c:	0141                	addi	sp,sp,16
    8000672e:	8082                	ret

0000000080006730 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80006730:	1101                	addi	sp,sp,-32
    80006732:	ec06                	sd	ra,24(sp)
    80006734:	e822                	sd	s0,16(sp)
    80006736:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80006738:	0001d517          	auipc	a0,0x1d
    8000673c:	53850513          	addi	a0,a0,1336 # 80023c70 <ftable>
    80006740:	ffffb097          	auipc	ra,0xffffb
    80006744:	b84080e7          	jalr	-1148(ra) # 800012c4 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80006748:	0001d797          	auipc	a5,0x1d
    8000674c:	54078793          	addi	a5,a5,1344 # 80023c88 <ftable+0x18>
    80006750:	fef43423          	sd	a5,-24(s0)
    80006754:	a815                	j	80006788 <filealloc+0x58>
    if(f->ref == 0){
    80006756:	fe843783          	ld	a5,-24(s0)
    8000675a:	43dc                	lw	a5,4(a5)
    8000675c:	e385                	bnez	a5,8000677c <filealloc+0x4c>
      f->ref = 1;
    8000675e:	fe843783          	ld	a5,-24(s0)
    80006762:	4705                	li	a4,1
    80006764:	c3d8                	sw	a4,4(a5)
      release(&ftable.lock);
    80006766:	0001d517          	auipc	a0,0x1d
    8000676a:	50a50513          	addi	a0,a0,1290 # 80023c70 <ftable>
    8000676e:	ffffb097          	auipc	ra,0xffffb
    80006772:	bba080e7          	jalr	-1094(ra) # 80001328 <release>
      return f;
    80006776:	fe843783          	ld	a5,-24(s0)
    8000677a:	a805                	j	800067aa <filealloc+0x7a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000677c:	fe843783          	ld	a5,-24(s0)
    80006780:	02878793          	addi	a5,a5,40
    80006784:	fef43423          	sd	a5,-24(s0)
    80006788:	0001e797          	auipc	a5,0x1e
    8000678c:	4a078793          	addi	a5,a5,1184 # 80024c28 <disk>
    80006790:	fe843703          	ld	a4,-24(s0)
    80006794:	fcf761e3          	bltu	a4,a5,80006756 <filealloc+0x26>
    }
  }
  release(&ftable.lock);
    80006798:	0001d517          	auipc	a0,0x1d
    8000679c:	4d850513          	addi	a0,a0,1240 # 80023c70 <ftable>
    800067a0:	ffffb097          	auipc	ra,0xffffb
    800067a4:	b88080e7          	jalr	-1144(ra) # 80001328 <release>
  return 0;
    800067a8:	4781                	li	a5,0
}
    800067aa:	853e                	mv	a0,a5
    800067ac:	60e2                	ld	ra,24(sp)
    800067ae:	6442                	ld	s0,16(sp)
    800067b0:	6105                	addi	sp,sp,32
    800067b2:	8082                	ret

00000000800067b4 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800067b4:	1101                	addi	sp,sp,-32
    800067b6:	ec06                	sd	ra,24(sp)
    800067b8:	e822                	sd	s0,16(sp)
    800067ba:	1000                	addi	s0,sp,32
    800067bc:	fea43423          	sd	a0,-24(s0)
  acquire(&ftable.lock);
    800067c0:	0001d517          	auipc	a0,0x1d
    800067c4:	4b050513          	addi	a0,a0,1200 # 80023c70 <ftable>
    800067c8:	ffffb097          	auipc	ra,0xffffb
    800067cc:	afc080e7          	jalr	-1284(ra) # 800012c4 <acquire>
  if(f->ref < 1)
    800067d0:	fe843783          	ld	a5,-24(s0)
    800067d4:	43dc                	lw	a5,4(a5)
    800067d6:	00f04a63          	bgtz	a5,800067ea <filedup+0x36>
    panic("filedup");
    800067da:	00005517          	auipc	a0,0x5
    800067de:	dde50513          	addi	a0,a0,-546 # 8000b5b8 <etext+0x5b8>
    800067e2:	ffffa097          	auipc	ra,0xffffa
    800067e6:	4de080e7          	jalr	1246(ra) # 80000cc0 <panic>
  f->ref++;
    800067ea:	fe843783          	ld	a5,-24(s0)
    800067ee:	43dc                	lw	a5,4(a5)
    800067f0:	2785                	addiw	a5,a5,1
    800067f2:	0007871b          	sext.w	a4,a5
    800067f6:	fe843783          	ld	a5,-24(s0)
    800067fa:	c3d8                	sw	a4,4(a5)
  release(&ftable.lock);
    800067fc:	0001d517          	auipc	a0,0x1d
    80006800:	47450513          	addi	a0,a0,1140 # 80023c70 <ftable>
    80006804:	ffffb097          	auipc	ra,0xffffb
    80006808:	b24080e7          	jalr	-1244(ra) # 80001328 <release>
  return f;
    8000680c:	fe843783          	ld	a5,-24(s0)
}
    80006810:	853e                	mv	a0,a5
    80006812:	60e2                	ld	ra,24(sp)
    80006814:	6442                	ld	s0,16(sp)
    80006816:	6105                	addi	sp,sp,32
    80006818:	8082                	ret

000000008000681a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000681a:	715d                	addi	sp,sp,-80
    8000681c:	e486                	sd	ra,72(sp)
    8000681e:	e0a2                	sd	s0,64(sp)
    80006820:	0880                	addi	s0,sp,80
    80006822:	faa43c23          	sd	a0,-72(s0)
  struct file ff;

  acquire(&ftable.lock);
    80006826:	0001d517          	auipc	a0,0x1d
    8000682a:	44a50513          	addi	a0,a0,1098 # 80023c70 <ftable>
    8000682e:	ffffb097          	auipc	ra,0xffffb
    80006832:	a96080e7          	jalr	-1386(ra) # 800012c4 <acquire>
  if(f->ref < 1)
    80006836:	fb843783          	ld	a5,-72(s0)
    8000683a:	43dc                	lw	a5,4(a5)
    8000683c:	00f04a63          	bgtz	a5,80006850 <fileclose+0x36>
    panic("fileclose");
    80006840:	00005517          	auipc	a0,0x5
    80006844:	d8050513          	addi	a0,a0,-640 # 8000b5c0 <etext+0x5c0>
    80006848:	ffffa097          	auipc	ra,0xffffa
    8000684c:	478080e7          	jalr	1144(ra) # 80000cc0 <panic>
  if(--f->ref > 0){
    80006850:	fb843783          	ld	a5,-72(s0)
    80006854:	43dc                	lw	a5,4(a5)
    80006856:	37fd                	addiw	a5,a5,-1
    80006858:	0007871b          	sext.w	a4,a5
    8000685c:	fb843783          	ld	a5,-72(s0)
    80006860:	c3d8                	sw	a4,4(a5)
    80006862:	fb843783          	ld	a5,-72(s0)
    80006866:	43dc                	lw	a5,4(a5)
    80006868:	00f05b63          	blez	a5,8000687e <fileclose+0x64>
    release(&ftable.lock);
    8000686c:	0001d517          	auipc	a0,0x1d
    80006870:	40450513          	addi	a0,a0,1028 # 80023c70 <ftable>
    80006874:	ffffb097          	auipc	ra,0xffffb
    80006878:	ab4080e7          	jalr	-1356(ra) # 80001328 <release>
    8000687c:	a861                	j	80006914 <fileclose+0xfa>
    return;
  }
  ff = *f;
    8000687e:	fb843783          	ld	a5,-72(s0)
    80006882:	638c                	ld	a1,0(a5)
    80006884:	6790                	ld	a2,8(a5)
    80006886:	6b94                	ld	a3,16(a5)
    80006888:	6f98                	ld	a4,24(a5)
    8000688a:	739c                	ld	a5,32(a5)
    8000688c:	fcb43423          	sd	a1,-56(s0)
    80006890:	fcc43823          	sd	a2,-48(s0)
    80006894:	fcd43c23          	sd	a3,-40(s0)
    80006898:	fee43023          	sd	a4,-32(s0)
    8000689c:	fef43423          	sd	a5,-24(s0)
  f->ref = 0;
    800068a0:	fb843783          	ld	a5,-72(s0)
    800068a4:	0007a223          	sw	zero,4(a5)
  f->type = FD_NONE;
    800068a8:	fb843783          	ld	a5,-72(s0)
    800068ac:	0007a023          	sw	zero,0(a5)
  release(&ftable.lock);
    800068b0:	0001d517          	auipc	a0,0x1d
    800068b4:	3c050513          	addi	a0,a0,960 # 80023c70 <ftable>
    800068b8:	ffffb097          	auipc	ra,0xffffb
    800068bc:	a70080e7          	jalr	-1424(ra) # 80001328 <release>

  if(ff.type == FD_PIPE){
    800068c0:	fc842703          	lw	a4,-56(s0)
    800068c4:	4785                	li	a5,1
    800068c6:	00f71e63          	bne	a4,a5,800068e2 <fileclose+0xc8>
    pipeclose(ff.pipe, ff.writable);
    800068ca:	fd843783          	ld	a5,-40(s0)
    800068ce:	fd144703          	lbu	a4,-47(s0)
    800068d2:	2701                	sext.w	a4,a4
    800068d4:	85ba                	mv	a1,a4
    800068d6:	853e                	mv	a0,a5
    800068d8:	00000097          	auipc	ra,0x0
    800068dc:	58e080e7          	jalr	1422(ra) # 80006e66 <pipeclose>
    800068e0:	a815                	j	80006914 <fileclose+0xfa>
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800068e2:	fc842703          	lw	a4,-56(s0)
    800068e6:	4789                	li	a5,2
    800068e8:	00f70763          	beq	a4,a5,800068f6 <fileclose+0xdc>
    800068ec:	fc842703          	lw	a4,-56(s0)
    800068f0:	478d                	li	a5,3
    800068f2:	02f71163          	bne	a4,a5,80006914 <fileclose+0xfa>
    begin_op();
    800068f6:	00000097          	auipc	ra,0x0
    800068fa:	89a080e7          	jalr	-1894(ra) # 80006190 <begin_op>
    iput(ff.ip);
    800068fe:	fe043783          	ld	a5,-32(s0)
    80006902:	853e                	mv	a0,a5
    80006904:	fffff097          	auipc	ra,0xfffff
    80006908:	9aa080e7          	jalr	-1622(ra) # 800052ae <iput>
    end_op();
    8000690c:	00000097          	auipc	ra,0x0
    80006910:	946080e7          	jalr	-1722(ra) # 80006252 <end_op>
  }
}
    80006914:	60a6                	ld	ra,72(sp)
    80006916:	6406                	ld	s0,64(sp)
    80006918:	6161                	addi	sp,sp,80
    8000691a:	8082                	ret

000000008000691c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000691c:	7139                	addi	sp,sp,-64
    8000691e:	fc06                	sd	ra,56(sp)
    80006920:	f822                	sd	s0,48(sp)
    80006922:	0080                	addi	s0,sp,64
    80006924:	fca43423          	sd	a0,-56(s0)
    80006928:	fcb43023          	sd	a1,-64(s0)
  struct proc *p = myproc();
    8000692c:	ffffc097          	auipc	ra,0xffffc
    80006930:	f90080e7          	jalr	-112(ra) # 800028bc <myproc>
    80006934:	fea43423          	sd	a0,-24(s0)
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80006938:	fc843783          	ld	a5,-56(s0)
    8000693c:	4398                	lw	a4,0(a5)
    8000693e:	4789                	li	a5,2
    80006940:	00f70863          	beq	a4,a5,80006950 <filestat+0x34>
    80006944:	fc843783          	ld	a5,-56(s0)
    80006948:	4398                	lw	a4,0(a5)
    8000694a:	478d                	li	a5,3
    8000694c:	06f71263          	bne	a4,a5,800069b0 <filestat+0x94>
    ilock(f->ip);
    80006950:	fc843783          	ld	a5,-56(s0)
    80006954:	6f9c                	ld	a5,24(a5)
    80006956:	853e                	mv	a0,a5
    80006958:	ffffe097          	auipc	ra,0xffffe
    8000695c:	7c8080e7          	jalr	1992(ra) # 80005120 <ilock>
    stati(f->ip, &st);
    80006960:	fc843783          	ld	a5,-56(s0)
    80006964:	6f9c                	ld	a5,24(a5)
    80006966:	fd040713          	addi	a4,s0,-48
    8000696a:	85ba                	mv	a1,a4
    8000696c:	853e                	mv	a0,a5
    8000696e:	fffff097          	auipc	ra,0xfffff
    80006972:	cfa080e7          	jalr	-774(ra) # 80005668 <stati>
    iunlock(f->ip);
    80006976:	fc843783          	ld	a5,-56(s0)
    8000697a:	6f9c                	ld	a5,24(a5)
    8000697c:	853e                	mv	a0,a5
    8000697e:	fffff097          	auipc	ra,0xfffff
    80006982:	8d6080e7          	jalr	-1834(ra) # 80005254 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80006986:	fe843783          	ld	a5,-24(s0)
    8000698a:	6bbc                	ld	a5,80(a5)
    8000698c:	fd040713          	addi	a4,s0,-48
    80006990:	46e1                	li	a3,24
    80006992:	863a                	mv	a2,a4
    80006994:	fc043583          	ld	a1,-64(s0)
    80006998:	853e                	mv	a0,a5
    8000699a:	ffffc097          	auipc	ra,0xffffc
    8000699e:	9e0080e7          	jalr	-1568(ra) # 8000237a <copyout>
    800069a2:	87aa                	mv	a5,a0
    800069a4:	0007d463          	bgez	a5,800069ac <filestat+0x90>
      return -1;
    800069a8:	57fd                	li	a5,-1
    800069aa:	a021                	j	800069b2 <filestat+0x96>
    return 0;
    800069ac:	4781                	li	a5,0
    800069ae:	a011                	j	800069b2 <filestat+0x96>
  }
  return -1;
    800069b0:	57fd                	li	a5,-1
}
    800069b2:	853e                	mv	a0,a5
    800069b4:	70e2                	ld	ra,56(sp)
    800069b6:	7442                	ld	s0,48(sp)
    800069b8:	6121                	addi	sp,sp,64
    800069ba:	8082                	ret

00000000800069bc <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800069bc:	7139                	addi	sp,sp,-64
    800069be:	fc06                	sd	ra,56(sp)
    800069c0:	f822                	sd	s0,48(sp)
    800069c2:	0080                	addi	s0,sp,64
    800069c4:	fca43c23          	sd	a0,-40(s0)
    800069c8:	fcb43823          	sd	a1,-48(s0)
    800069cc:	87b2                	mv	a5,a2
    800069ce:	fcf42623          	sw	a5,-52(s0)
  int r = 0;
    800069d2:	fe042623          	sw	zero,-20(s0)

  if(f->readable == 0)
    800069d6:	fd843783          	ld	a5,-40(s0)
    800069da:	0087c783          	lbu	a5,8(a5)
    800069de:	e399                	bnez	a5,800069e4 <fileread+0x28>
    return -1;
    800069e0:	57fd                	li	a5,-1
    800069e2:	a21d                	j	80006b08 <fileread+0x14c>

  if(f->type == FD_PIPE){
    800069e4:	fd843783          	ld	a5,-40(s0)
    800069e8:	4398                	lw	a4,0(a5)
    800069ea:	4785                	li	a5,1
    800069ec:	02f71363          	bne	a4,a5,80006a12 <fileread+0x56>
    r = piperead(f->pipe, addr, n);
    800069f0:	fd843783          	ld	a5,-40(s0)
    800069f4:	6b9c                	ld	a5,16(a5)
    800069f6:	fcc42703          	lw	a4,-52(s0)
    800069fa:	863a                	mv	a2,a4
    800069fc:	fd043583          	ld	a1,-48(s0)
    80006a00:	853e                	mv	a0,a5
    80006a02:	00000097          	auipc	ra,0x0
    80006a06:	65e080e7          	jalr	1630(ra) # 80007060 <piperead>
    80006a0a:	87aa                	mv	a5,a0
    80006a0c:	fef42623          	sw	a5,-20(s0)
    80006a10:	a8d5                	j	80006b04 <fileread+0x148>
  } else if(f->type == FD_DEVICE){
    80006a12:	fd843783          	ld	a5,-40(s0)
    80006a16:	4398                	lw	a4,0(a5)
    80006a18:	478d                	li	a5,3
    80006a1a:	06f71363          	bne	a4,a5,80006a80 <fileread+0xc4>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80006a1e:	fd843783          	ld	a5,-40(s0)
    80006a22:	02479783          	lh	a5,36(a5)
    80006a26:	0207c563          	bltz	a5,80006a50 <fileread+0x94>
    80006a2a:	fd843783          	ld	a5,-40(s0)
    80006a2e:	02479703          	lh	a4,36(a5)
    80006a32:	47a5                	li	a5,9
    80006a34:	00e7ce63          	blt	a5,a4,80006a50 <fileread+0x94>
    80006a38:	fd843783          	ld	a5,-40(s0)
    80006a3c:	02479783          	lh	a5,36(a5)
    80006a40:	0001d717          	auipc	a4,0x1d
    80006a44:	19070713          	addi	a4,a4,400 # 80023bd0 <devsw>
    80006a48:	0792                	slli	a5,a5,0x4
    80006a4a:	97ba                	add	a5,a5,a4
    80006a4c:	639c                	ld	a5,0(a5)
    80006a4e:	e399                	bnez	a5,80006a54 <fileread+0x98>
      return -1;
    80006a50:	57fd                	li	a5,-1
    80006a52:	a85d                	j	80006b08 <fileread+0x14c>
    r = devsw[f->major].read(1, addr, n);
    80006a54:	fd843783          	ld	a5,-40(s0)
    80006a58:	02479783          	lh	a5,36(a5)
    80006a5c:	0001d717          	auipc	a4,0x1d
    80006a60:	17470713          	addi	a4,a4,372 # 80023bd0 <devsw>
    80006a64:	0792                	slli	a5,a5,0x4
    80006a66:	97ba                	add	a5,a5,a4
    80006a68:	639c                	ld	a5,0(a5)
    80006a6a:	fcc42703          	lw	a4,-52(s0)
    80006a6e:	863a                	mv	a2,a4
    80006a70:	fd043583          	ld	a1,-48(s0)
    80006a74:	4505                	li	a0,1
    80006a76:	9782                	jalr	a5
    80006a78:	87aa                	mv	a5,a0
    80006a7a:	fef42623          	sw	a5,-20(s0)
    80006a7e:	a059                	j	80006b04 <fileread+0x148>
  } else if(f->type == FD_INODE){
    80006a80:	fd843783          	ld	a5,-40(s0)
    80006a84:	4398                	lw	a4,0(a5)
    80006a86:	4789                	li	a5,2
    80006a88:	06f71663          	bne	a4,a5,80006af4 <fileread+0x138>
    ilock(f->ip);
    80006a8c:	fd843783          	ld	a5,-40(s0)
    80006a90:	6f9c                	ld	a5,24(a5)
    80006a92:	853e                	mv	a0,a5
    80006a94:	ffffe097          	auipc	ra,0xffffe
    80006a98:	68c080e7          	jalr	1676(ra) # 80005120 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80006a9c:	fd843783          	ld	a5,-40(s0)
    80006aa0:	6f88                	ld	a0,24(a5)
    80006aa2:	fd843783          	ld	a5,-40(s0)
    80006aa6:	539c                	lw	a5,32(a5)
    80006aa8:	fcc42703          	lw	a4,-52(s0)
    80006aac:	86be                	mv	a3,a5
    80006aae:	fd043603          	ld	a2,-48(s0)
    80006ab2:	4585                	li	a1,1
    80006ab4:	fffff097          	auipc	ra,0xfffff
    80006ab8:	c1a080e7          	jalr	-998(ra) # 800056ce <readi>
    80006abc:	87aa                	mv	a5,a0
    80006abe:	fef42623          	sw	a5,-20(s0)
    80006ac2:	fec42783          	lw	a5,-20(s0)
    80006ac6:	2781                	sext.w	a5,a5
    80006ac8:	00f05d63          	blez	a5,80006ae2 <fileread+0x126>
      f->off += r;
    80006acc:	fd843783          	ld	a5,-40(s0)
    80006ad0:	5398                	lw	a4,32(a5)
    80006ad2:	fec42783          	lw	a5,-20(s0)
    80006ad6:	9fb9                	addw	a5,a5,a4
    80006ad8:	0007871b          	sext.w	a4,a5
    80006adc:	fd843783          	ld	a5,-40(s0)
    80006ae0:	d398                	sw	a4,32(a5)
    iunlock(f->ip);
    80006ae2:	fd843783          	ld	a5,-40(s0)
    80006ae6:	6f9c                	ld	a5,24(a5)
    80006ae8:	853e                	mv	a0,a5
    80006aea:	ffffe097          	auipc	ra,0xffffe
    80006aee:	76a080e7          	jalr	1898(ra) # 80005254 <iunlock>
    80006af2:	a809                	j	80006b04 <fileread+0x148>
  } else {
    panic("fileread");
    80006af4:	00005517          	auipc	a0,0x5
    80006af8:	adc50513          	addi	a0,a0,-1316 # 8000b5d0 <etext+0x5d0>
    80006afc:	ffffa097          	auipc	ra,0xffffa
    80006b00:	1c4080e7          	jalr	452(ra) # 80000cc0 <panic>
  }

  return r;
    80006b04:	fec42783          	lw	a5,-20(s0)
}
    80006b08:	853e                	mv	a0,a5
    80006b0a:	70e2                	ld	ra,56(sp)
    80006b0c:	7442                	ld	s0,48(sp)
    80006b0e:	6121                	addi	sp,sp,64
    80006b10:	8082                	ret

0000000080006b12 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80006b12:	715d                	addi	sp,sp,-80
    80006b14:	e486                	sd	ra,72(sp)
    80006b16:	e0a2                	sd	s0,64(sp)
    80006b18:	0880                	addi	s0,sp,80
    80006b1a:	fca43423          	sd	a0,-56(s0)
    80006b1e:	fcb43023          	sd	a1,-64(s0)
    80006b22:	87b2                	mv	a5,a2
    80006b24:	faf42e23          	sw	a5,-68(s0)
  int r, ret = 0;
    80006b28:	fe042623          	sw	zero,-20(s0)

  if(f->writable == 0)
    80006b2c:	fc843783          	ld	a5,-56(s0)
    80006b30:	0097c783          	lbu	a5,9(a5)
    80006b34:	e399                	bnez	a5,80006b3a <filewrite+0x28>
    return -1;
    80006b36:	57fd                	li	a5,-1
    80006b38:	aac1                	j	80006d08 <filewrite+0x1f6>

  if(f->type == FD_PIPE){
    80006b3a:	fc843783          	ld	a5,-56(s0)
    80006b3e:	4398                	lw	a4,0(a5)
    80006b40:	4785                	li	a5,1
    80006b42:	02f71363          	bne	a4,a5,80006b68 <filewrite+0x56>
    ret = pipewrite(f->pipe, addr, n);
    80006b46:	fc843783          	ld	a5,-56(s0)
    80006b4a:	6b9c                	ld	a5,16(a5)
    80006b4c:	fbc42703          	lw	a4,-68(s0)
    80006b50:	863a                	mv	a2,a4
    80006b52:	fc043583          	ld	a1,-64(s0)
    80006b56:	853e                	mv	a0,a5
    80006b58:	00000097          	auipc	ra,0x0
    80006b5c:	3b6080e7          	jalr	950(ra) # 80006f0e <pipewrite>
    80006b60:	87aa                	mv	a5,a0
    80006b62:	fef42623          	sw	a5,-20(s0)
    80006b66:	aa79                	j	80006d04 <filewrite+0x1f2>
  } else if(f->type == FD_DEVICE){
    80006b68:	fc843783          	ld	a5,-56(s0)
    80006b6c:	4398                	lw	a4,0(a5)
    80006b6e:	478d                	li	a5,3
    80006b70:	06f71363          	bne	a4,a5,80006bd6 <filewrite+0xc4>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80006b74:	fc843783          	ld	a5,-56(s0)
    80006b78:	02479783          	lh	a5,36(a5)
    80006b7c:	0207c563          	bltz	a5,80006ba6 <filewrite+0x94>
    80006b80:	fc843783          	ld	a5,-56(s0)
    80006b84:	02479703          	lh	a4,36(a5)
    80006b88:	47a5                	li	a5,9
    80006b8a:	00e7ce63          	blt	a5,a4,80006ba6 <filewrite+0x94>
    80006b8e:	fc843783          	ld	a5,-56(s0)
    80006b92:	02479783          	lh	a5,36(a5)
    80006b96:	0001d717          	auipc	a4,0x1d
    80006b9a:	03a70713          	addi	a4,a4,58 # 80023bd0 <devsw>
    80006b9e:	0792                	slli	a5,a5,0x4
    80006ba0:	97ba                	add	a5,a5,a4
    80006ba2:	679c                	ld	a5,8(a5)
    80006ba4:	e399                	bnez	a5,80006baa <filewrite+0x98>
      return -1;
    80006ba6:	57fd                	li	a5,-1
    80006ba8:	a285                	j	80006d08 <filewrite+0x1f6>
    ret = devsw[f->major].write(1, addr, n);
    80006baa:	fc843783          	ld	a5,-56(s0)
    80006bae:	02479783          	lh	a5,36(a5)
    80006bb2:	0001d717          	auipc	a4,0x1d
    80006bb6:	01e70713          	addi	a4,a4,30 # 80023bd0 <devsw>
    80006bba:	0792                	slli	a5,a5,0x4
    80006bbc:	97ba                	add	a5,a5,a4
    80006bbe:	679c                	ld	a5,8(a5)
    80006bc0:	fbc42703          	lw	a4,-68(s0)
    80006bc4:	863a                	mv	a2,a4
    80006bc6:	fc043583          	ld	a1,-64(s0)
    80006bca:	4505                	li	a0,1
    80006bcc:	9782                	jalr	a5
    80006bce:	87aa                	mv	a5,a0
    80006bd0:	fef42623          	sw	a5,-20(s0)
    80006bd4:	aa05                	j	80006d04 <filewrite+0x1f2>
  } else if(f->type == FD_INODE){
    80006bd6:	fc843783          	ld	a5,-56(s0)
    80006bda:	4398                	lw	a4,0(a5)
    80006bdc:	4789                	li	a5,2
    80006bde:	10f71b63          	bne	a4,a5,80006cf4 <filewrite+0x1e2>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    80006be2:	6785                	lui	a5,0x1
    80006be4:	c0078793          	addi	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    80006be8:	fef42023          	sw	a5,-32(s0)
    int i = 0;
    80006bec:	fe042423          	sw	zero,-24(s0)
    while(i < n){
    80006bf0:	a0f9                	j	80006cbe <filewrite+0x1ac>
      int n1 = n - i;
    80006bf2:	fbc42783          	lw	a5,-68(s0)
    80006bf6:	873e                	mv	a4,a5
    80006bf8:	fe842783          	lw	a5,-24(s0)
    80006bfc:	40f707bb          	subw	a5,a4,a5
    80006c00:	fef42223          	sw	a5,-28(s0)
      if(n1 > max)
    80006c04:	fe442783          	lw	a5,-28(s0)
    80006c08:	873e                	mv	a4,a5
    80006c0a:	fe042783          	lw	a5,-32(s0)
    80006c0e:	2701                	sext.w	a4,a4
    80006c10:	2781                	sext.w	a5,a5
    80006c12:	00e7d663          	bge	a5,a4,80006c1e <filewrite+0x10c>
        n1 = max;
    80006c16:	fe042783          	lw	a5,-32(s0)
    80006c1a:	fef42223          	sw	a5,-28(s0)

      begin_op();
    80006c1e:	fffff097          	auipc	ra,0xfffff
    80006c22:	572080e7          	jalr	1394(ra) # 80006190 <begin_op>
      ilock(f->ip);
    80006c26:	fc843783          	ld	a5,-56(s0)
    80006c2a:	6f9c                	ld	a5,24(a5)
    80006c2c:	853e                	mv	a0,a5
    80006c2e:	ffffe097          	auipc	ra,0xffffe
    80006c32:	4f2080e7          	jalr	1266(ra) # 80005120 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80006c36:	fc843783          	ld	a5,-56(s0)
    80006c3a:	6f88                	ld	a0,24(a5)
    80006c3c:	fe842703          	lw	a4,-24(s0)
    80006c40:	fc043783          	ld	a5,-64(s0)
    80006c44:	00f70633          	add	a2,a4,a5
    80006c48:	fc843783          	ld	a5,-56(s0)
    80006c4c:	539c                	lw	a5,32(a5)
    80006c4e:	fe442703          	lw	a4,-28(s0)
    80006c52:	86be                	mv	a3,a5
    80006c54:	4585                	li	a1,1
    80006c56:	fffff097          	auipc	ra,0xfffff
    80006c5a:	c14080e7          	jalr	-1004(ra) # 8000586a <writei>
    80006c5e:	87aa                	mv	a5,a0
    80006c60:	fcf42e23          	sw	a5,-36(s0)
    80006c64:	fdc42783          	lw	a5,-36(s0)
    80006c68:	2781                	sext.w	a5,a5
    80006c6a:	00f05d63          	blez	a5,80006c84 <filewrite+0x172>
        f->off += r;
    80006c6e:	fc843783          	ld	a5,-56(s0)
    80006c72:	5398                	lw	a4,32(a5)
    80006c74:	fdc42783          	lw	a5,-36(s0)
    80006c78:	9fb9                	addw	a5,a5,a4
    80006c7a:	0007871b          	sext.w	a4,a5
    80006c7e:	fc843783          	ld	a5,-56(s0)
    80006c82:	d398                	sw	a4,32(a5)
      iunlock(f->ip);
    80006c84:	fc843783          	ld	a5,-56(s0)
    80006c88:	6f9c                	ld	a5,24(a5)
    80006c8a:	853e                	mv	a0,a5
    80006c8c:	ffffe097          	auipc	ra,0xffffe
    80006c90:	5c8080e7          	jalr	1480(ra) # 80005254 <iunlock>
      end_op();
    80006c94:	fffff097          	auipc	ra,0xfffff
    80006c98:	5be080e7          	jalr	1470(ra) # 80006252 <end_op>

      if(r != n1){
    80006c9c:	fdc42783          	lw	a5,-36(s0)
    80006ca0:	873e                	mv	a4,a5
    80006ca2:	fe442783          	lw	a5,-28(s0)
    80006ca6:	2701                	sext.w	a4,a4
    80006ca8:	2781                	sext.w	a5,a5
    80006caa:	02f71463          	bne	a4,a5,80006cd2 <filewrite+0x1c0>
        // error from writei
        break;
      }
      i += r;
    80006cae:	fe842783          	lw	a5,-24(s0)
    80006cb2:	873e                	mv	a4,a5
    80006cb4:	fdc42783          	lw	a5,-36(s0)
    80006cb8:	9fb9                	addw	a5,a5,a4
    80006cba:	fef42423          	sw	a5,-24(s0)
    while(i < n){
    80006cbe:	fe842783          	lw	a5,-24(s0)
    80006cc2:	873e                	mv	a4,a5
    80006cc4:	fbc42783          	lw	a5,-68(s0)
    80006cc8:	2701                	sext.w	a4,a4
    80006cca:	2781                	sext.w	a5,a5
    80006ccc:	f2f743e3          	blt	a4,a5,80006bf2 <filewrite+0xe0>
    80006cd0:	a011                	j	80006cd4 <filewrite+0x1c2>
        break;
    80006cd2:	0001                	nop
    }
    ret = (i == n ? n : -1);
    80006cd4:	fe842783          	lw	a5,-24(s0)
    80006cd8:	873e                	mv	a4,a5
    80006cda:	fbc42783          	lw	a5,-68(s0)
    80006cde:	2701                	sext.w	a4,a4
    80006ce0:	2781                	sext.w	a5,a5
    80006ce2:	00f71563          	bne	a4,a5,80006cec <filewrite+0x1da>
    80006ce6:	fbc42783          	lw	a5,-68(s0)
    80006cea:	a011                	j	80006cee <filewrite+0x1dc>
    80006cec:	57fd                	li	a5,-1
    80006cee:	fef42623          	sw	a5,-20(s0)
    80006cf2:	a809                	j	80006d04 <filewrite+0x1f2>
  } else {
    panic("filewrite");
    80006cf4:	00005517          	auipc	a0,0x5
    80006cf8:	8ec50513          	addi	a0,a0,-1812 # 8000b5e0 <etext+0x5e0>
    80006cfc:	ffffa097          	auipc	ra,0xffffa
    80006d00:	fc4080e7          	jalr	-60(ra) # 80000cc0 <panic>
  }

  return ret;
    80006d04:	fec42783          	lw	a5,-20(s0)
}
    80006d08:	853e                	mv	a0,a5
    80006d0a:	60a6                	ld	ra,72(sp)
    80006d0c:	6406                	ld	s0,64(sp)
    80006d0e:	6161                	addi	sp,sp,80
    80006d10:	8082                	ret

0000000080006d12 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80006d12:	7179                	addi	sp,sp,-48
    80006d14:	f406                	sd	ra,40(sp)
    80006d16:	f022                	sd	s0,32(sp)
    80006d18:	1800                	addi	s0,sp,48
    80006d1a:	fca43c23          	sd	a0,-40(s0)
    80006d1e:	fcb43823          	sd	a1,-48(s0)
  struct pipe *pi;

  pi = 0;
    80006d22:	fe043423          	sd	zero,-24(s0)
  *f0 = *f1 = 0;
    80006d26:	fd043783          	ld	a5,-48(s0)
    80006d2a:	0007b023          	sd	zero,0(a5)
    80006d2e:	fd043783          	ld	a5,-48(s0)
    80006d32:	6398                	ld	a4,0(a5)
    80006d34:	fd843783          	ld	a5,-40(s0)
    80006d38:	e398                	sd	a4,0(a5)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80006d3a:	00000097          	auipc	ra,0x0
    80006d3e:	9f6080e7          	jalr	-1546(ra) # 80006730 <filealloc>
    80006d42:	872a                	mv	a4,a0
    80006d44:	fd843783          	ld	a5,-40(s0)
    80006d48:	e398                	sd	a4,0(a5)
    80006d4a:	fd843783          	ld	a5,-40(s0)
    80006d4e:	639c                	ld	a5,0(a5)
    80006d50:	c3e9                	beqz	a5,80006e12 <pipealloc+0x100>
    80006d52:	00000097          	auipc	ra,0x0
    80006d56:	9de080e7          	jalr	-1570(ra) # 80006730 <filealloc>
    80006d5a:	872a                	mv	a4,a0
    80006d5c:	fd043783          	ld	a5,-48(s0)
    80006d60:	e398                	sd	a4,0(a5)
    80006d62:	fd043783          	ld	a5,-48(s0)
    80006d66:	639c                	ld	a5,0(a5)
    80006d68:	c7cd                	beqz	a5,80006e12 <pipealloc+0x100>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80006d6a:	ffffa097          	auipc	ra,0xffffa
    80006d6e:	3fa080e7          	jalr	1018(ra) # 80001164 <kalloc>
    80006d72:	fea43423          	sd	a0,-24(s0)
    80006d76:	fe843783          	ld	a5,-24(s0)
    80006d7a:	cfd1                	beqz	a5,80006e16 <pipealloc+0x104>
    goto bad;
  pi->readopen = 1;
    80006d7c:	fe843783          	ld	a5,-24(s0)
    80006d80:	4705                	li	a4,1
    80006d82:	22e7a023          	sw	a4,544(a5)
  pi->writeopen = 1;
    80006d86:	fe843783          	ld	a5,-24(s0)
    80006d8a:	4705                	li	a4,1
    80006d8c:	22e7a223          	sw	a4,548(a5)
  pi->nwrite = 0;
    80006d90:	fe843783          	ld	a5,-24(s0)
    80006d94:	2007ae23          	sw	zero,540(a5)
  pi->nread = 0;
    80006d98:	fe843783          	ld	a5,-24(s0)
    80006d9c:	2007ac23          	sw	zero,536(a5)
  initlock(&pi->lock, "pipe");
    80006da0:	fe843783          	ld	a5,-24(s0)
    80006da4:	00005597          	auipc	a1,0x5
    80006da8:	84c58593          	addi	a1,a1,-1972 # 8000b5f0 <etext+0x5f0>
    80006dac:	853e                	mv	a0,a5
    80006dae:	ffffa097          	auipc	ra,0xffffa
    80006db2:	4e2080e7          	jalr	1250(ra) # 80001290 <initlock>
  (*f0)->type = FD_PIPE;
    80006db6:	fd843783          	ld	a5,-40(s0)
    80006dba:	639c                	ld	a5,0(a5)
    80006dbc:	4705                	li	a4,1
    80006dbe:	c398                	sw	a4,0(a5)
  (*f0)->readable = 1;
    80006dc0:	fd843783          	ld	a5,-40(s0)
    80006dc4:	639c                	ld	a5,0(a5)
    80006dc6:	4705                	li	a4,1
    80006dc8:	00e78423          	sb	a4,8(a5)
  (*f0)->writable = 0;
    80006dcc:	fd843783          	ld	a5,-40(s0)
    80006dd0:	639c                	ld	a5,0(a5)
    80006dd2:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80006dd6:	fd843783          	ld	a5,-40(s0)
    80006dda:	639c                	ld	a5,0(a5)
    80006ddc:	fe843703          	ld	a4,-24(s0)
    80006de0:	eb98                	sd	a4,16(a5)
  (*f1)->type = FD_PIPE;
    80006de2:	fd043783          	ld	a5,-48(s0)
    80006de6:	639c                	ld	a5,0(a5)
    80006de8:	4705                	li	a4,1
    80006dea:	c398                	sw	a4,0(a5)
  (*f1)->readable = 0;
    80006dec:	fd043783          	ld	a5,-48(s0)
    80006df0:	639c                	ld	a5,0(a5)
    80006df2:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80006df6:	fd043783          	ld	a5,-48(s0)
    80006dfa:	639c                	ld	a5,0(a5)
    80006dfc:	4705                	li	a4,1
    80006dfe:	00e784a3          	sb	a4,9(a5)
  (*f1)->pipe = pi;
    80006e02:	fd043783          	ld	a5,-48(s0)
    80006e06:	639c                	ld	a5,0(a5)
    80006e08:	fe843703          	ld	a4,-24(s0)
    80006e0c:	eb98                	sd	a4,16(a5)
  return 0;
    80006e0e:	4781                	li	a5,0
    80006e10:	a0b1                	j	80006e5c <pipealloc+0x14a>
    goto bad;
    80006e12:	0001                	nop
    80006e14:	a011                	j	80006e18 <pipealloc+0x106>
    goto bad;
    80006e16:	0001                	nop

 bad:
  if(pi)
    80006e18:	fe843783          	ld	a5,-24(s0)
    80006e1c:	c799                	beqz	a5,80006e2a <pipealloc+0x118>
    kfree((char*)pi);
    80006e1e:	fe843503          	ld	a0,-24(s0)
    80006e22:	ffffa097          	auipc	ra,0xffffa
    80006e26:	29e080e7          	jalr	670(ra) # 800010c0 <kfree>
  if(*f0)
    80006e2a:	fd843783          	ld	a5,-40(s0)
    80006e2e:	639c                	ld	a5,0(a5)
    80006e30:	cb89                	beqz	a5,80006e42 <pipealloc+0x130>
    fileclose(*f0);
    80006e32:	fd843783          	ld	a5,-40(s0)
    80006e36:	639c                	ld	a5,0(a5)
    80006e38:	853e                	mv	a0,a5
    80006e3a:	00000097          	auipc	ra,0x0
    80006e3e:	9e0080e7          	jalr	-1568(ra) # 8000681a <fileclose>
  if(*f1)
    80006e42:	fd043783          	ld	a5,-48(s0)
    80006e46:	639c                	ld	a5,0(a5)
    80006e48:	cb89                	beqz	a5,80006e5a <pipealloc+0x148>
    fileclose(*f1);
    80006e4a:	fd043783          	ld	a5,-48(s0)
    80006e4e:	639c                	ld	a5,0(a5)
    80006e50:	853e                	mv	a0,a5
    80006e52:	00000097          	auipc	ra,0x0
    80006e56:	9c8080e7          	jalr	-1592(ra) # 8000681a <fileclose>
  return -1;
    80006e5a:	57fd                	li	a5,-1
}
    80006e5c:	853e                	mv	a0,a5
    80006e5e:	70a2                	ld	ra,40(sp)
    80006e60:	7402                	ld	s0,32(sp)
    80006e62:	6145                	addi	sp,sp,48
    80006e64:	8082                	ret

0000000080006e66 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80006e66:	1101                	addi	sp,sp,-32
    80006e68:	ec06                	sd	ra,24(sp)
    80006e6a:	e822                	sd	s0,16(sp)
    80006e6c:	1000                	addi	s0,sp,32
    80006e6e:	fea43423          	sd	a0,-24(s0)
    80006e72:	87ae                	mv	a5,a1
    80006e74:	fef42223          	sw	a5,-28(s0)
  acquire(&pi->lock);
    80006e78:	fe843783          	ld	a5,-24(s0)
    80006e7c:	853e                	mv	a0,a5
    80006e7e:	ffffa097          	auipc	ra,0xffffa
    80006e82:	446080e7          	jalr	1094(ra) # 800012c4 <acquire>
  if(writable){
    80006e86:	fe442783          	lw	a5,-28(s0)
    80006e8a:	2781                	sext.w	a5,a5
    80006e8c:	cf99                	beqz	a5,80006eaa <pipeclose+0x44>
    pi->writeopen = 0;
    80006e8e:	fe843783          	ld	a5,-24(s0)
    80006e92:	2207a223          	sw	zero,548(a5)
    wakeup(&pi->nread);
    80006e96:	fe843783          	ld	a5,-24(s0)
    80006e9a:	21878793          	addi	a5,a5,536
    80006e9e:	853e                	mv	a0,a5
    80006ea0:	ffffc097          	auipc	ra,0xffffc
    80006ea4:	652080e7          	jalr	1618(ra) # 800034f2 <wakeup>
    80006ea8:	a831                	j	80006ec4 <pipeclose+0x5e>
  } else {
    pi->readopen = 0;
    80006eaa:	fe843783          	ld	a5,-24(s0)
    80006eae:	2207a023          	sw	zero,544(a5)
    wakeup(&pi->nwrite);
    80006eb2:	fe843783          	ld	a5,-24(s0)
    80006eb6:	21c78793          	addi	a5,a5,540
    80006eba:	853e                	mv	a0,a5
    80006ebc:	ffffc097          	auipc	ra,0xffffc
    80006ec0:	636080e7          	jalr	1590(ra) # 800034f2 <wakeup>
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80006ec4:	fe843783          	ld	a5,-24(s0)
    80006ec8:	2207a783          	lw	a5,544(a5)
    80006ecc:	e785                	bnez	a5,80006ef4 <pipeclose+0x8e>
    80006ece:	fe843783          	ld	a5,-24(s0)
    80006ed2:	2247a783          	lw	a5,548(a5)
    80006ed6:	ef99                	bnez	a5,80006ef4 <pipeclose+0x8e>
    release(&pi->lock);
    80006ed8:	fe843783          	ld	a5,-24(s0)
    80006edc:	853e                	mv	a0,a5
    80006ede:	ffffa097          	auipc	ra,0xffffa
    80006ee2:	44a080e7          	jalr	1098(ra) # 80001328 <release>
    kfree((char*)pi);
    80006ee6:	fe843503          	ld	a0,-24(s0)
    80006eea:	ffffa097          	auipc	ra,0xffffa
    80006eee:	1d6080e7          	jalr	470(ra) # 800010c0 <kfree>
    80006ef2:	a809                	j	80006f04 <pipeclose+0x9e>
  } else
    release(&pi->lock);
    80006ef4:	fe843783          	ld	a5,-24(s0)
    80006ef8:	853e                	mv	a0,a5
    80006efa:	ffffa097          	auipc	ra,0xffffa
    80006efe:	42e080e7          	jalr	1070(ra) # 80001328 <release>
}
    80006f02:	0001                	nop
    80006f04:	0001                	nop
    80006f06:	60e2                	ld	ra,24(sp)
    80006f08:	6442                	ld	s0,16(sp)
    80006f0a:	6105                	addi	sp,sp,32
    80006f0c:	8082                	ret

0000000080006f0e <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80006f0e:	715d                	addi	sp,sp,-80
    80006f10:	e486                	sd	ra,72(sp)
    80006f12:	e0a2                	sd	s0,64(sp)
    80006f14:	0880                	addi	s0,sp,80
    80006f16:	fca43423          	sd	a0,-56(s0)
    80006f1a:	fcb43023          	sd	a1,-64(s0)
    80006f1e:	87b2                	mv	a5,a2
    80006f20:	faf42e23          	sw	a5,-68(s0)
  int i = 0;
    80006f24:	fe042623          	sw	zero,-20(s0)
  struct proc *pr = myproc();
    80006f28:	ffffc097          	auipc	ra,0xffffc
    80006f2c:	994080e7          	jalr	-1644(ra) # 800028bc <myproc>
    80006f30:	fea43023          	sd	a0,-32(s0)

  acquire(&pi->lock);
    80006f34:	fc843783          	ld	a5,-56(s0)
    80006f38:	853e                	mv	a0,a5
    80006f3a:	ffffa097          	auipc	ra,0xffffa
    80006f3e:	38a080e7          	jalr	906(ra) # 800012c4 <acquire>
  while(i < n){
    80006f42:	a8e9                	j	8000701c <pipewrite+0x10e>
    if(pi->readopen == 0 || killed(pr)){
    80006f44:	fc843783          	ld	a5,-56(s0)
    80006f48:	2207a783          	lw	a5,544(a5)
    80006f4c:	cb89                	beqz	a5,80006f5e <pipewrite+0x50>
    80006f4e:	fe043503          	ld	a0,-32(s0)
    80006f52:	ffffc097          	auipc	ra,0xffffc
    80006f56:	70a080e7          	jalr	1802(ra) # 8000365c <killed>
    80006f5a:	87aa                	mv	a5,a0
    80006f5c:	cb91                	beqz	a5,80006f70 <pipewrite+0x62>
      release(&pi->lock);
    80006f5e:	fc843783          	ld	a5,-56(s0)
    80006f62:	853e                	mv	a0,a5
    80006f64:	ffffa097          	auipc	ra,0xffffa
    80006f68:	3c4080e7          	jalr	964(ra) # 80001328 <release>
      return -1;
    80006f6c:	57fd                	li	a5,-1
    80006f6e:	a0e5                	j	80007056 <pipewrite+0x148>
    }
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80006f70:	fc843783          	ld	a5,-56(s0)
    80006f74:	21c7a703          	lw	a4,540(a5)
    80006f78:	fc843783          	ld	a5,-56(s0)
    80006f7c:	2187a783          	lw	a5,536(a5)
    80006f80:	2007879b          	addiw	a5,a5,512
    80006f84:	2781                	sext.w	a5,a5
    80006f86:	02f71863          	bne	a4,a5,80006fb6 <pipewrite+0xa8>
      wakeup(&pi->nread);
    80006f8a:	fc843783          	ld	a5,-56(s0)
    80006f8e:	21878793          	addi	a5,a5,536
    80006f92:	853e                	mv	a0,a5
    80006f94:	ffffc097          	auipc	ra,0xffffc
    80006f98:	55e080e7          	jalr	1374(ra) # 800034f2 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80006f9c:	fc843783          	ld	a5,-56(s0)
    80006fa0:	21c78793          	addi	a5,a5,540
    80006fa4:	fc843703          	ld	a4,-56(s0)
    80006fa8:	85ba                	mv	a1,a4
    80006faa:	853e                	mv	a0,a5
    80006fac:	ffffc097          	auipc	ra,0xffffc
    80006fb0:	4ca080e7          	jalr	1226(ra) # 80003476 <sleep>
    80006fb4:	a0a5                	j	8000701c <pipewrite+0x10e>
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80006fb6:	fe043783          	ld	a5,-32(s0)
    80006fba:	6ba8                	ld	a0,80(a5)
    80006fbc:	fec42703          	lw	a4,-20(s0)
    80006fc0:	fc043783          	ld	a5,-64(s0)
    80006fc4:	973e                	add	a4,a4,a5
    80006fc6:	fdf40793          	addi	a5,s0,-33
    80006fca:	4685                	li	a3,1
    80006fcc:	863a                	mv	a2,a4
    80006fce:	85be                	mv	a1,a5
    80006fd0:	ffffb097          	auipc	ra,0xffffb
    80006fd4:	478080e7          	jalr	1144(ra) # 80002448 <copyin>
    80006fd8:	87aa                	mv	a5,a0
    80006fda:	873e                	mv	a4,a5
    80006fdc:	57fd                	li	a5,-1
    80006fde:	04f70963          	beq	a4,a5,80007030 <pipewrite+0x122>
        break;
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80006fe2:	fc843783          	ld	a5,-56(s0)
    80006fe6:	21c7a783          	lw	a5,540(a5)
    80006fea:	0017871b          	addiw	a4,a5,1
    80006fee:	0007069b          	sext.w	a3,a4
    80006ff2:	fc843703          	ld	a4,-56(s0)
    80006ff6:	20d72e23          	sw	a3,540(a4)
    80006ffa:	1ff7f793          	andi	a5,a5,511
    80006ffe:	2781                	sext.w	a5,a5
    80007000:	fdf44703          	lbu	a4,-33(s0)
    80007004:	fc843683          	ld	a3,-56(s0)
    80007008:	1782                	slli	a5,a5,0x20
    8000700a:	9381                	srli	a5,a5,0x20
    8000700c:	97b6                	add	a5,a5,a3
    8000700e:	00e78c23          	sb	a4,24(a5)
      i++;
    80007012:	fec42783          	lw	a5,-20(s0)
    80007016:	2785                	addiw	a5,a5,1
    80007018:	fef42623          	sw	a5,-20(s0)
  while(i < n){
    8000701c:	fec42783          	lw	a5,-20(s0)
    80007020:	873e                	mv	a4,a5
    80007022:	fbc42783          	lw	a5,-68(s0)
    80007026:	2701                	sext.w	a4,a4
    80007028:	2781                	sext.w	a5,a5
    8000702a:	f0f74de3          	blt	a4,a5,80006f44 <pipewrite+0x36>
    8000702e:	a011                	j	80007032 <pipewrite+0x124>
        break;
    80007030:	0001                	nop
    }
  }
  wakeup(&pi->nread);
    80007032:	fc843783          	ld	a5,-56(s0)
    80007036:	21878793          	addi	a5,a5,536
    8000703a:	853e                	mv	a0,a5
    8000703c:	ffffc097          	auipc	ra,0xffffc
    80007040:	4b6080e7          	jalr	1206(ra) # 800034f2 <wakeup>
  release(&pi->lock);
    80007044:	fc843783          	ld	a5,-56(s0)
    80007048:	853e                	mv	a0,a5
    8000704a:	ffffa097          	auipc	ra,0xffffa
    8000704e:	2de080e7          	jalr	734(ra) # 80001328 <release>

  return i;
    80007052:	fec42783          	lw	a5,-20(s0)
}
    80007056:	853e                	mv	a0,a5
    80007058:	60a6                	ld	ra,72(sp)
    8000705a:	6406                	ld	s0,64(sp)
    8000705c:	6161                	addi	sp,sp,80
    8000705e:	8082                	ret

0000000080007060 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80007060:	715d                	addi	sp,sp,-80
    80007062:	e486                	sd	ra,72(sp)
    80007064:	e0a2                	sd	s0,64(sp)
    80007066:	0880                	addi	s0,sp,80
    80007068:	fca43423          	sd	a0,-56(s0)
    8000706c:	fcb43023          	sd	a1,-64(s0)
    80007070:	87b2                	mv	a5,a2
    80007072:	faf42e23          	sw	a5,-68(s0)
  int i;
  struct proc *pr = myproc();
    80007076:	ffffc097          	auipc	ra,0xffffc
    8000707a:	846080e7          	jalr	-1978(ra) # 800028bc <myproc>
    8000707e:	fea43023          	sd	a0,-32(s0)
  char ch;

  acquire(&pi->lock);
    80007082:	fc843783          	ld	a5,-56(s0)
    80007086:	853e                	mv	a0,a5
    80007088:	ffffa097          	auipc	ra,0xffffa
    8000708c:	23c080e7          	jalr	572(ra) # 800012c4 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80007090:	a835                	j	800070cc <piperead+0x6c>
    if(killed(pr)){
    80007092:	fe043503          	ld	a0,-32(s0)
    80007096:	ffffc097          	auipc	ra,0xffffc
    8000709a:	5c6080e7          	jalr	1478(ra) # 8000365c <killed>
    8000709e:	87aa                	mv	a5,a0
    800070a0:	cb91                	beqz	a5,800070b4 <piperead+0x54>
      release(&pi->lock);
    800070a2:	fc843783          	ld	a5,-56(s0)
    800070a6:	853e                	mv	a0,a5
    800070a8:	ffffa097          	auipc	ra,0xffffa
    800070ac:	280080e7          	jalr	640(ra) # 80001328 <release>
      return -1;
    800070b0:	57fd                	li	a5,-1
    800070b2:	a8dd                	j	800071a8 <piperead+0x148>
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800070b4:	fc843783          	ld	a5,-56(s0)
    800070b8:	21878793          	addi	a5,a5,536
    800070bc:	fc843703          	ld	a4,-56(s0)
    800070c0:	85ba                	mv	a1,a4
    800070c2:	853e                	mv	a0,a5
    800070c4:	ffffc097          	auipc	ra,0xffffc
    800070c8:	3b2080e7          	jalr	946(ra) # 80003476 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800070cc:	fc843783          	ld	a5,-56(s0)
    800070d0:	2187a703          	lw	a4,536(a5)
    800070d4:	fc843783          	ld	a5,-56(s0)
    800070d8:	21c7a783          	lw	a5,540(a5)
    800070dc:	00f71763          	bne	a4,a5,800070ea <piperead+0x8a>
    800070e0:	fc843783          	ld	a5,-56(s0)
    800070e4:	2247a783          	lw	a5,548(a5)
    800070e8:	f7cd                	bnez	a5,80007092 <piperead+0x32>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800070ea:	fe042623          	sw	zero,-20(s0)
    800070ee:	a8b5                	j	8000716a <piperead+0x10a>
    if(pi->nread == pi->nwrite)
    800070f0:	fc843783          	ld	a5,-56(s0)
    800070f4:	2187a703          	lw	a4,536(a5)
    800070f8:	fc843783          	ld	a5,-56(s0)
    800070fc:	21c7a783          	lw	a5,540(a5)
    80007100:	06f70f63          	beq	a4,a5,8000717e <piperead+0x11e>
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    80007104:	fc843783          	ld	a5,-56(s0)
    80007108:	2187a783          	lw	a5,536(a5)
    8000710c:	0017871b          	addiw	a4,a5,1
    80007110:	0007069b          	sext.w	a3,a4
    80007114:	fc843703          	ld	a4,-56(s0)
    80007118:	20d72c23          	sw	a3,536(a4)
    8000711c:	1ff7f793          	andi	a5,a5,511
    80007120:	2781                	sext.w	a5,a5
    80007122:	fc843703          	ld	a4,-56(s0)
    80007126:	1782                	slli	a5,a5,0x20
    80007128:	9381                	srli	a5,a5,0x20
    8000712a:	97ba                	add	a5,a5,a4
    8000712c:	0187c783          	lbu	a5,24(a5)
    80007130:	fcf40fa3          	sb	a5,-33(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80007134:	fe043783          	ld	a5,-32(s0)
    80007138:	6ba8                	ld	a0,80(a5)
    8000713a:	fec42703          	lw	a4,-20(s0)
    8000713e:	fc043783          	ld	a5,-64(s0)
    80007142:	97ba                	add	a5,a5,a4
    80007144:	fdf40713          	addi	a4,s0,-33
    80007148:	4685                	li	a3,1
    8000714a:	863a                	mv	a2,a4
    8000714c:	85be                	mv	a1,a5
    8000714e:	ffffb097          	auipc	ra,0xffffb
    80007152:	22c080e7          	jalr	556(ra) # 8000237a <copyout>
    80007156:	87aa                	mv	a5,a0
    80007158:	873e                	mv	a4,a5
    8000715a:	57fd                	li	a5,-1
    8000715c:	02f70363          	beq	a4,a5,80007182 <piperead+0x122>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80007160:	fec42783          	lw	a5,-20(s0)
    80007164:	2785                	addiw	a5,a5,1
    80007166:	fef42623          	sw	a5,-20(s0)
    8000716a:	fec42783          	lw	a5,-20(s0)
    8000716e:	873e                	mv	a4,a5
    80007170:	fbc42783          	lw	a5,-68(s0)
    80007174:	2701                	sext.w	a4,a4
    80007176:	2781                	sext.w	a5,a5
    80007178:	f6f74ce3          	blt	a4,a5,800070f0 <piperead+0x90>
    8000717c:	a021                	j	80007184 <piperead+0x124>
      break;
    8000717e:	0001                	nop
    80007180:	a011                	j	80007184 <piperead+0x124>
      break;
    80007182:	0001                	nop
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80007184:	fc843783          	ld	a5,-56(s0)
    80007188:	21c78793          	addi	a5,a5,540
    8000718c:	853e                	mv	a0,a5
    8000718e:	ffffc097          	auipc	ra,0xffffc
    80007192:	364080e7          	jalr	868(ra) # 800034f2 <wakeup>
  release(&pi->lock);
    80007196:	fc843783          	ld	a5,-56(s0)
    8000719a:	853e                	mv	a0,a5
    8000719c:	ffffa097          	auipc	ra,0xffffa
    800071a0:	18c080e7          	jalr	396(ra) # 80001328 <release>
  return i;
    800071a4:	fec42783          	lw	a5,-20(s0)
}
    800071a8:	853e                	mv	a0,a5
    800071aa:	60a6                	ld	ra,72(sp)
    800071ac:	6406                	ld	s0,64(sp)
    800071ae:	6161                	addi	sp,sp,80
    800071b0:	8082                	ret

00000000800071b2 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800071b2:	7179                	addi	sp,sp,-48
    800071b4:	f406                	sd	ra,40(sp)
    800071b6:	f022                	sd	s0,32(sp)
    800071b8:	1800                	addi	s0,sp,48
    800071ba:	87aa                	mv	a5,a0
    800071bc:	fcf42e23          	sw	a5,-36(s0)
    int perm = 0;
    800071c0:	fe042623          	sw	zero,-20(s0)
    if(flags & 0x1)
    800071c4:	fdc42783          	lw	a5,-36(s0)
    800071c8:	8b85                	andi	a5,a5,1
    800071ca:	2781                	sext.w	a5,a5
    800071cc:	c781                	beqz	a5,800071d4 <flags2perm+0x22>
      perm = PTE_X;
    800071ce:	47a1                	li	a5,8
    800071d0:	fef42623          	sw	a5,-20(s0)
    if(flags & 0x2)
    800071d4:	fdc42783          	lw	a5,-36(s0)
    800071d8:	8b89                	andi	a5,a5,2
    800071da:	2781                	sext.w	a5,a5
    800071dc:	c799                	beqz	a5,800071ea <flags2perm+0x38>
      perm |= PTE_W;
    800071de:	fec42783          	lw	a5,-20(s0)
    800071e2:	0047e793          	ori	a5,a5,4
    800071e6:	fef42623          	sw	a5,-20(s0)
    return perm;
    800071ea:	fec42783          	lw	a5,-20(s0)
}
    800071ee:	853e                	mv	a0,a5
    800071f0:	70a2                	ld	ra,40(sp)
    800071f2:	7402                	ld	s0,32(sp)
    800071f4:	6145                	addi	sp,sp,48
    800071f6:	8082                	ret

00000000800071f8 <exec>:

int
exec(char *path, char **argv)
{
    800071f8:	de010113          	addi	sp,sp,-544
    800071fc:	20113c23          	sd	ra,536(sp)
    80007200:	20813823          	sd	s0,528(sp)
    80007204:	20913423          	sd	s1,520(sp)
    80007208:	1400                	addi	s0,sp,544
    8000720a:	dea43423          	sd	a0,-536(s0)
    8000720e:	deb43023          	sd	a1,-544(s0)
  char *s, *last;
  int i, off;
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80007212:	fa043c23          	sd	zero,-72(s0)
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
    80007216:	fa043023          	sd	zero,-96(s0)
  struct proc *p = myproc();
    8000721a:	ffffb097          	auipc	ra,0xffffb
    8000721e:	6a2080e7          	jalr	1698(ra) # 800028bc <myproc>
    80007222:	f8a43c23          	sd	a0,-104(s0)

  begin_op();
    80007226:	fffff097          	auipc	ra,0xfffff
    8000722a:	f6a080e7          	jalr	-150(ra) # 80006190 <begin_op>

  if((ip = namei(path)) == 0){
    8000722e:	de843503          	ld	a0,-536(s0)
    80007232:	fffff097          	auipc	ra,0xfffff
    80007236:	c0e080e7          	jalr	-1010(ra) # 80005e40 <namei>
    8000723a:	faa43423          	sd	a0,-88(s0)
    8000723e:	fa843783          	ld	a5,-88(s0)
    80007242:	e799                	bnez	a5,80007250 <exec+0x58>
    end_op();
    80007244:	fffff097          	auipc	ra,0xfffff
    80007248:	00e080e7          	jalr	14(ra) # 80006252 <end_op>
    return -1;
    8000724c:	57fd                	li	a5,-1
    8000724e:	a181                	j	8000768e <exec+0x496>
  }
  ilock(ip);
    80007250:	fa843503          	ld	a0,-88(s0)
    80007254:	ffffe097          	auipc	ra,0xffffe
    80007258:	ecc080e7          	jalr	-308(ra) # 80005120 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000725c:	e3040793          	addi	a5,s0,-464
    80007260:	04000713          	li	a4,64
    80007264:	4681                	li	a3,0
    80007266:	863e                	mv	a2,a5
    80007268:	4581                	li	a1,0
    8000726a:	fa843503          	ld	a0,-88(s0)
    8000726e:	ffffe097          	auipc	ra,0xffffe
    80007272:	460080e7          	jalr	1120(ra) # 800056ce <readi>
    80007276:	87aa                	mv	a5,a0
    80007278:	873e                	mv	a4,a5
    8000727a:	04000793          	li	a5,64
    8000727e:	3af71263          	bne	a4,a5,80007622 <exec+0x42a>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80007282:	e3042703          	lw	a4,-464(s0)
    80007286:	464c47b7          	lui	a5,0x464c4
    8000728a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000728e:	38f71c63          	bne	a4,a5,80007626 <exec+0x42e>
    goto bad;

  if((pagetable = proc_pagetable(p)) == 0)
    80007292:	f9843503          	ld	a0,-104(s0)
    80007296:	ffffc097          	auipc	ra,0xffffc
    8000729a:	888080e7          	jalr	-1912(ra) # 80002b1e <proc_pagetable>
    8000729e:	faa43023          	sd	a0,-96(s0)
    800072a2:	fa043783          	ld	a5,-96(s0)
    800072a6:	38078263          	beqz	a5,8000762a <exec+0x432>
    goto bad;

  // Load program into memory.
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800072aa:	fc042623          	sw	zero,-52(s0)
    800072ae:	e5043783          	ld	a5,-432(s0)
    800072b2:	fcf42423          	sw	a5,-56(s0)
    800072b6:	a0ed                	j	800073a0 <exec+0x1a8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800072b8:	df840793          	addi	a5,s0,-520
    800072bc:	fc842683          	lw	a3,-56(s0)
    800072c0:	03800713          	li	a4,56
    800072c4:	863e                	mv	a2,a5
    800072c6:	4581                	li	a1,0
    800072c8:	fa843503          	ld	a0,-88(s0)
    800072cc:	ffffe097          	auipc	ra,0xffffe
    800072d0:	402080e7          	jalr	1026(ra) # 800056ce <readi>
    800072d4:	87aa                	mv	a5,a0
    800072d6:	873e                	mv	a4,a5
    800072d8:	03800793          	li	a5,56
    800072dc:	34f71963          	bne	a4,a5,8000762e <exec+0x436>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
    800072e0:	df842703          	lw	a4,-520(s0)
    800072e4:	4785                	li	a5,1
    800072e6:	0af71063          	bne	a4,a5,80007386 <exec+0x18e>
      continue;
    if(ph.memsz < ph.filesz)
    800072ea:	e2043703          	ld	a4,-480(s0)
    800072ee:	e1843783          	ld	a5,-488(s0)
    800072f2:	34f76063          	bltu	a4,a5,80007632 <exec+0x43a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800072f6:	e0843703          	ld	a4,-504(s0)
    800072fa:	e2043783          	ld	a5,-480(s0)
    800072fe:	973e                	add	a4,a4,a5
    80007300:	e0843783          	ld	a5,-504(s0)
    80007304:	32f76963          	bltu	a4,a5,80007636 <exec+0x43e>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
    80007308:	e0843703          	ld	a4,-504(s0)
    8000730c:	6785                	lui	a5,0x1
    8000730e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80007310:	8ff9                	and	a5,a5,a4
    80007312:	32079463          	bnez	a5,8000763a <exec+0x442>
      goto bad;
    uint64 sz1;
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80007316:	e0843703          	ld	a4,-504(s0)
    8000731a:	e2043783          	ld	a5,-480(s0)
    8000731e:	00f704b3          	add	s1,a4,a5
    80007322:	dfc42783          	lw	a5,-516(s0)
    80007326:	853e                	mv	a0,a5
    80007328:	00000097          	auipc	ra,0x0
    8000732c:	e8a080e7          	jalr	-374(ra) # 800071b2 <flags2perm>
    80007330:	87aa                	mv	a5,a0
    80007332:	86be                	mv	a3,a5
    80007334:	8626                	mv	a2,s1
    80007336:	fb843583          	ld	a1,-72(s0)
    8000733a:	fa043503          	ld	a0,-96(s0)
    8000733e:	ffffb097          	auipc	ra,0xffffb
    80007342:	c50080e7          	jalr	-944(ra) # 80001f8e <uvmalloc>
    80007346:	f6a43823          	sd	a0,-144(s0)
    8000734a:	f7043783          	ld	a5,-144(s0)
    8000734e:	2e078863          	beqz	a5,8000763e <exec+0x446>
      goto bad;
    sz = sz1;
    80007352:	f7043783          	ld	a5,-144(s0)
    80007356:	faf43c23          	sd	a5,-72(s0)
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000735a:	e0843783          	ld	a5,-504(s0)
    8000735e:	e0043703          	ld	a4,-512(s0)
    80007362:	0007069b          	sext.w	a3,a4
    80007366:	e1843703          	ld	a4,-488(s0)
    8000736a:	2701                	sext.w	a4,a4
    8000736c:	fa843603          	ld	a2,-88(s0)
    80007370:	85be                	mv	a1,a5
    80007372:	fa043503          	ld	a0,-96(s0)
    80007376:	00000097          	auipc	ra,0x0
    8000737a:	32c080e7          	jalr	812(ra) # 800076a2 <loadseg>
    8000737e:	87aa                	mv	a5,a0
    80007380:	2c07c163          	bltz	a5,80007642 <exec+0x44a>
    80007384:	a011                	j	80007388 <exec+0x190>
      continue;
    80007386:	0001                	nop
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80007388:	fcc42783          	lw	a5,-52(s0)
    8000738c:	2785                	addiw	a5,a5,1
    8000738e:	fcf42623          	sw	a5,-52(s0)
    80007392:	fc842783          	lw	a5,-56(s0)
    80007396:	0387879b          	addiw	a5,a5,56
    8000739a:	2781                	sext.w	a5,a5
    8000739c:	fcf42423          	sw	a5,-56(s0)
    800073a0:	e6845783          	lhu	a5,-408(s0)
    800073a4:	2781                	sext.w	a5,a5
    800073a6:	fcc42703          	lw	a4,-52(s0)
    800073aa:	2701                	sext.w	a4,a4
    800073ac:	f0f746e3          	blt	a4,a5,800072b8 <exec+0xc0>
      goto bad;
  }
  iunlockput(ip);
    800073b0:	fa843503          	ld	a0,-88(s0)
    800073b4:	ffffe097          	auipc	ra,0xffffe
    800073b8:	fc8080e7          	jalr	-56(ra) # 8000537c <iunlockput>
  end_op();
    800073bc:	fffff097          	auipc	ra,0xfffff
    800073c0:	e96080e7          	jalr	-362(ra) # 80006252 <end_op>
  ip = 0;
    800073c4:	fa043423          	sd	zero,-88(s0)

  p = myproc();
    800073c8:	ffffb097          	auipc	ra,0xffffb
    800073cc:	4f4080e7          	jalr	1268(ra) # 800028bc <myproc>
    800073d0:	f8a43c23          	sd	a0,-104(s0)
  uint64 oldsz = p->sz;
    800073d4:	f9843783          	ld	a5,-104(s0)
    800073d8:	67bc                	ld	a5,72(a5)
    800073da:	f8f43823          	sd	a5,-112(s0)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible as a stack guard.
  // Use the second as the user stack.
  sz = PGROUNDUP(sz);
    800073de:	fb843703          	ld	a4,-72(s0)
    800073e2:	6785                	lui	a5,0x1
    800073e4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800073e6:	973e                	add	a4,a4,a5
    800073e8:	77fd                	lui	a5,0xfffff
    800073ea:	8ff9                	and	a5,a5,a4
    800073ec:	faf43c23          	sd	a5,-72(s0)
  uint64 sz1;
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800073f0:	fb843703          	ld	a4,-72(s0)
    800073f4:	6789                	lui	a5,0x2
    800073f6:	97ba                	add	a5,a5,a4
    800073f8:	4691                	li	a3,4
    800073fa:	863e                	mv	a2,a5
    800073fc:	fb843583          	ld	a1,-72(s0)
    80007400:	fa043503          	ld	a0,-96(s0)
    80007404:	ffffb097          	auipc	ra,0xffffb
    80007408:	b8a080e7          	jalr	-1142(ra) # 80001f8e <uvmalloc>
    8000740c:	f8a43423          	sd	a0,-120(s0)
    80007410:	f8843783          	ld	a5,-120(s0)
    80007414:	22078963          	beqz	a5,80007646 <exec+0x44e>
    goto bad;
  sz = sz1;
    80007418:	f8843783          	ld	a5,-120(s0)
    8000741c:	faf43c23          	sd	a5,-72(s0)
  uvmclear(pagetable, sz-2*PGSIZE);
    80007420:	fb843703          	ld	a4,-72(s0)
    80007424:	77f9                	lui	a5,0xffffe
    80007426:	97ba                	add	a5,a5,a4
    80007428:	85be                	mv	a1,a5
    8000742a:	fa043503          	ld	a0,-96(s0)
    8000742e:	ffffb097          	auipc	ra,0xffffb
    80007432:	ef6080e7          	jalr	-266(ra) # 80002324 <uvmclear>
  sp = sz;
    80007436:	fb843783          	ld	a5,-72(s0)
    8000743a:	faf43823          	sd	a5,-80(s0)
  stackbase = sp - PGSIZE;
    8000743e:	fb043703          	ld	a4,-80(s0)
    80007442:	77fd                	lui	a5,0xfffff
    80007444:	97ba                	add	a5,a5,a4
    80007446:	f8f43023          	sd	a5,-128(s0)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    8000744a:	fc043023          	sd	zero,-64(s0)
    8000744e:	a07d                	j	800074fc <exec+0x304>
    if(argc >= MAXARG)
    80007450:	fc043703          	ld	a4,-64(s0)
    80007454:	47fd                	li	a5,31
    80007456:	1ee7ea63          	bltu	a5,a4,8000764a <exec+0x452>
      goto bad;
    sp -= strlen(argv[argc]) + 1;
    8000745a:	fc043783          	ld	a5,-64(s0)
    8000745e:	078e                	slli	a5,a5,0x3
    80007460:	de043703          	ld	a4,-544(s0)
    80007464:	97ba                	add	a5,a5,a4
    80007466:	639c                	ld	a5,0(a5)
    80007468:	853e                	mv	a0,a5
    8000746a:	ffffa097          	auipc	ra,0xffffa
    8000746e:	3c6080e7          	jalr	966(ra) # 80001830 <strlen>
    80007472:	87aa                	mv	a5,a0
    80007474:	2785                	addiw	a5,a5,1 # fffffffffffff001 <end+0xffffffff7ffda299>
    80007476:	2781                	sext.w	a5,a5
    80007478:	873e                	mv	a4,a5
    8000747a:	fb043783          	ld	a5,-80(s0)
    8000747e:	8f99                	sub	a5,a5,a4
    80007480:	faf43823          	sd	a5,-80(s0)
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80007484:	fb043783          	ld	a5,-80(s0)
    80007488:	9bc1                	andi	a5,a5,-16
    8000748a:	faf43823          	sd	a5,-80(s0)
    if(sp < stackbase)
    8000748e:	fb043703          	ld	a4,-80(s0)
    80007492:	f8043783          	ld	a5,-128(s0)
    80007496:	1af76c63          	bltu	a4,a5,8000764e <exec+0x456>
      goto bad;
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000749a:	fc043783          	ld	a5,-64(s0)
    8000749e:	078e                	slli	a5,a5,0x3
    800074a0:	de043703          	ld	a4,-544(s0)
    800074a4:	97ba                	add	a5,a5,a4
    800074a6:	6384                	ld	s1,0(a5)
    800074a8:	fc043783          	ld	a5,-64(s0)
    800074ac:	078e                	slli	a5,a5,0x3
    800074ae:	de043703          	ld	a4,-544(s0)
    800074b2:	97ba                	add	a5,a5,a4
    800074b4:	639c                	ld	a5,0(a5)
    800074b6:	853e                	mv	a0,a5
    800074b8:	ffffa097          	auipc	ra,0xffffa
    800074bc:	378080e7          	jalr	888(ra) # 80001830 <strlen>
    800074c0:	87aa                	mv	a5,a0
    800074c2:	2785                	addiw	a5,a5,1
    800074c4:	2781                	sext.w	a5,a5
    800074c6:	86be                	mv	a3,a5
    800074c8:	8626                	mv	a2,s1
    800074ca:	fb043583          	ld	a1,-80(s0)
    800074ce:	fa043503          	ld	a0,-96(s0)
    800074d2:	ffffb097          	auipc	ra,0xffffb
    800074d6:	ea8080e7          	jalr	-344(ra) # 8000237a <copyout>
    800074da:	87aa                	mv	a5,a0
    800074dc:	1607cb63          	bltz	a5,80007652 <exec+0x45a>
      goto bad;
    ustack[argc] = sp;
    800074e0:	fc043703          	ld	a4,-64(s0)
    800074e4:	e7040793          	addi	a5,s0,-400
    800074e8:	070e                	slli	a4,a4,0x3
    800074ea:	97ba                	add	a5,a5,a4
    800074ec:	fb043703          	ld	a4,-80(s0)
    800074f0:	e398                	sd	a4,0(a5)
  for(argc = 0; argv[argc]; argc++) {
    800074f2:	fc043783          	ld	a5,-64(s0)
    800074f6:	0785                	addi	a5,a5,1
    800074f8:	fcf43023          	sd	a5,-64(s0)
    800074fc:	fc043783          	ld	a5,-64(s0)
    80007500:	078e                	slli	a5,a5,0x3
    80007502:	de043703          	ld	a4,-544(s0)
    80007506:	97ba                	add	a5,a5,a4
    80007508:	639c                	ld	a5,0(a5)
    8000750a:	f3b9                	bnez	a5,80007450 <exec+0x258>
  }
  ustack[argc] = 0;
    8000750c:	fc043703          	ld	a4,-64(s0)
    80007510:	e7040793          	addi	a5,s0,-400
    80007514:	070e                	slli	a4,a4,0x3
    80007516:	97ba                	add	a5,a5,a4
    80007518:	0007b023          	sd	zero,0(a5)

  // push the array of argv[] pointers.
  sp -= (argc+1) * sizeof(uint64);
    8000751c:	fc043783          	ld	a5,-64(s0)
    80007520:	0785                	addi	a5,a5,1
    80007522:	078e                	slli	a5,a5,0x3
    80007524:	fb043703          	ld	a4,-80(s0)
    80007528:	40f707b3          	sub	a5,a4,a5
    8000752c:	faf43823          	sd	a5,-80(s0)
  sp -= sp % 16;
    80007530:	fb043783          	ld	a5,-80(s0)
    80007534:	9bc1                	andi	a5,a5,-16
    80007536:	faf43823          	sd	a5,-80(s0)
  if(sp < stackbase)
    8000753a:	fb043703          	ld	a4,-80(s0)
    8000753e:	f8043783          	ld	a5,-128(s0)
    80007542:	10f76a63          	bltu	a4,a5,80007656 <exec+0x45e>
    goto bad;
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80007546:	fc043783          	ld	a5,-64(s0)
    8000754a:	0785                	addi	a5,a5,1
    8000754c:	00379713          	slli	a4,a5,0x3
    80007550:	e7040793          	addi	a5,s0,-400
    80007554:	86ba                	mv	a3,a4
    80007556:	863e                	mv	a2,a5
    80007558:	fb043583          	ld	a1,-80(s0)
    8000755c:	fa043503          	ld	a0,-96(s0)
    80007560:	ffffb097          	auipc	ra,0xffffb
    80007564:	e1a080e7          	jalr	-486(ra) # 8000237a <copyout>
    80007568:	87aa                	mv	a5,a0
    8000756a:	0e07c863          	bltz	a5,8000765a <exec+0x462>
    goto bad;

  // arguments to user main(argc, argv)
  // argc is returned via the system call return
  // value, which goes in a0.
  p->trapframe->a1 = sp;
    8000756e:	f9843783          	ld	a5,-104(s0)
    80007572:	6fbc                	ld	a5,88(a5)
    80007574:	fb043703          	ld	a4,-80(s0)
    80007578:	ffb8                	sd	a4,120(a5)

  // Save program name for debugging.
  for(last=s=path; *s; s++)
    8000757a:	de843783          	ld	a5,-536(s0)
    8000757e:	fcf43c23          	sd	a5,-40(s0)
    80007582:	fd843783          	ld	a5,-40(s0)
    80007586:	fcf43823          	sd	a5,-48(s0)
    8000758a:	a025                	j	800075b2 <exec+0x3ba>
    if(*s == '/')
    8000758c:	fd843783          	ld	a5,-40(s0)
    80007590:	0007c783          	lbu	a5,0(a5)
    80007594:	873e                	mv	a4,a5
    80007596:	02f00793          	li	a5,47
    8000759a:	00f71763          	bne	a4,a5,800075a8 <exec+0x3b0>
      last = s+1;
    8000759e:	fd843783          	ld	a5,-40(s0)
    800075a2:	0785                	addi	a5,a5,1
    800075a4:	fcf43823          	sd	a5,-48(s0)
  for(last=s=path; *s; s++)
    800075a8:	fd843783          	ld	a5,-40(s0)
    800075ac:	0785                	addi	a5,a5,1
    800075ae:	fcf43c23          	sd	a5,-40(s0)
    800075b2:	fd843783          	ld	a5,-40(s0)
    800075b6:	0007c783          	lbu	a5,0(a5)
    800075ba:	fbe9                	bnez	a5,8000758c <exec+0x394>
  safestrcpy(p->name, last, sizeof(p->name));
    800075bc:	f9843783          	ld	a5,-104(s0)
    800075c0:	15878793          	addi	a5,a5,344
    800075c4:	4641                	li	a2,16
    800075c6:	fd043583          	ld	a1,-48(s0)
    800075ca:	853e                	mv	a0,a5
    800075cc:	ffffa097          	auipc	ra,0xffffa
    800075d0:	1e4080e7          	jalr	484(ra) # 800017b0 <safestrcpy>
    
  // Commit to the user image.
  oldpagetable = p->pagetable;
    800075d4:	f9843783          	ld	a5,-104(s0)
    800075d8:	6bbc                	ld	a5,80(a5)
    800075da:	f6f43c23          	sd	a5,-136(s0)
  p->pagetable = pagetable;
    800075de:	f9843783          	ld	a5,-104(s0)
    800075e2:	fa043703          	ld	a4,-96(s0)
    800075e6:	ebb8                	sd	a4,80(a5)
  p->sz = sz;
    800075e8:	f9843783          	ld	a5,-104(s0)
    800075ec:	fb843703          	ld	a4,-72(s0)
    800075f0:	e7b8                	sd	a4,72(a5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800075f2:	f9843783          	ld	a5,-104(s0)
    800075f6:	6fbc                	ld	a5,88(a5)
    800075f8:	e4843703          	ld	a4,-440(s0)
    800075fc:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800075fe:	f9843783          	ld	a5,-104(s0)
    80007602:	6fbc                	ld	a5,88(a5)
    80007604:	fb043703          	ld	a4,-80(s0)
    80007608:	fb98                	sd	a4,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000760a:	f9043583          	ld	a1,-112(s0)
    8000760e:	f7843503          	ld	a0,-136(s0)
    80007612:	ffffb097          	auipc	ra,0xffffb
    80007616:	5cc080e7          	jalr	1484(ra) # 80002bde <proc_freepagetable>

  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000761a:	fc043783          	ld	a5,-64(s0)
    8000761e:	2781                	sext.w	a5,a5
    80007620:	a0bd                	j	8000768e <exec+0x496>
    goto bad;
    80007622:	0001                	nop
    80007624:	a825                	j	8000765c <exec+0x464>
    goto bad;
    80007626:	0001                	nop
    80007628:	a815                	j	8000765c <exec+0x464>
    goto bad;
    8000762a:	0001                	nop
    8000762c:	a805                	j	8000765c <exec+0x464>
      goto bad;
    8000762e:	0001                	nop
    80007630:	a035                	j	8000765c <exec+0x464>
      goto bad;
    80007632:	0001                	nop
    80007634:	a025                	j	8000765c <exec+0x464>
      goto bad;
    80007636:	0001                	nop
    80007638:	a015                	j	8000765c <exec+0x464>
      goto bad;
    8000763a:	0001                	nop
    8000763c:	a005                	j	8000765c <exec+0x464>
      goto bad;
    8000763e:	0001                	nop
    80007640:	a831                	j	8000765c <exec+0x464>
      goto bad;
    80007642:	0001                	nop
    80007644:	a821                	j	8000765c <exec+0x464>
    goto bad;
    80007646:	0001                	nop
    80007648:	a811                	j	8000765c <exec+0x464>
      goto bad;
    8000764a:	0001                	nop
    8000764c:	a801                	j	8000765c <exec+0x464>
      goto bad;
    8000764e:	0001                	nop
    80007650:	a031                	j	8000765c <exec+0x464>
      goto bad;
    80007652:	0001                	nop
    80007654:	a021                	j	8000765c <exec+0x464>
    goto bad;
    80007656:	0001                	nop
    80007658:	a011                	j	8000765c <exec+0x464>
    goto bad;
    8000765a:	0001                	nop

 bad:
  if(pagetable)
    8000765c:	fa043783          	ld	a5,-96(s0)
    80007660:	cb89                	beqz	a5,80007672 <exec+0x47a>
    proc_freepagetable(pagetable, sz);
    80007662:	fb843583          	ld	a1,-72(s0)
    80007666:	fa043503          	ld	a0,-96(s0)
    8000766a:	ffffb097          	auipc	ra,0xffffb
    8000766e:	574080e7          	jalr	1396(ra) # 80002bde <proc_freepagetable>
  if(ip){
    80007672:	fa843783          	ld	a5,-88(s0)
    80007676:	cb99                	beqz	a5,8000768c <exec+0x494>
    iunlockput(ip);
    80007678:	fa843503          	ld	a0,-88(s0)
    8000767c:	ffffe097          	auipc	ra,0xffffe
    80007680:	d00080e7          	jalr	-768(ra) # 8000537c <iunlockput>
    end_op();
    80007684:	fffff097          	auipc	ra,0xfffff
    80007688:	bce080e7          	jalr	-1074(ra) # 80006252 <end_op>
  }
  return -1;
    8000768c:	57fd                	li	a5,-1
}
    8000768e:	853e                	mv	a0,a5
    80007690:	21813083          	ld	ra,536(sp)
    80007694:	21013403          	ld	s0,528(sp)
    80007698:	20813483          	ld	s1,520(sp)
    8000769c:	22010113          	addi	sp,sp,544
    800076a0:	8082                	ret

00000000800076a2 <loadseg>:
// va must be page-aligned
// and the pages from va to va+sz must already be mapped.
// Returns 0 on success, -1 on failure.
static int
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
    800076a2:	7139                	addi	sp,sp,-64
    800076a4:	fc06                	sd	ra,56(sp)
    800076a6:	f822                	sd	s0,48(sp)
    800076a8:	0080                	addi	s0,sp,64
    800076aa:	fca43c23          	sd	a0,-40(s0)
    800076ae:	fcb43823          	sd	a1,-48(s0)
    800076b2:	fcc43423          	sd	a2,-56(s0)
    800076b6:	87b6                	mv	a5,a3
    800076b8:	fcf42223          	sw	a5,-60(s0)
    800076bc:	87ba                	mv	a5,a4
    800076be:	fcf42023          	sw	a5,-64(s0)
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800076c2:	fe042623          	sw	zero,-20(s0)
    800076c6:	a075                	j	80007772 <loadseg+0xd0>
    pa = walkaddr(pagetable, va + i);
    800076c8:	fec46703          	lwu	a4,-20(s0)
    800076cc:	fd043783          	ld	a5,-48(s0)
    800076d0:	97ba                	add	a5,a5,a4
    800076d2:	85be                	mv	a1,a5
    800076d4:	fd843503          	ld	a0,-40(s0)
    800076d8:	ffffa097          	auipc	ra,0xffffa
    800076dc:	542080e7          	jalr	1346(ra) # 80001c1a <walkaddr>
    800076e0:	fea43023          	sd	a0,-32(s0)
    if(pa == 0)
    800076e4:	fe043783          	ld	a5,-32(s0)
    800076e8:	eb89                	bnez	a5,800076fa <loadseg+0x58>
      panic("loadseg: address should exist");
    800076ea:	00004517          	auipc	a0,0x4
    800076ee:	f0e50513          	addi	a0,a0,-242 # 8000b5f8 <etext+0x5f8>
    800076f2:	ffff9097          	auipc	ra,0xffff9
    800076f6:	5ce080e7          	jalr	1486(ra) # 80000cc0 <panic>
    if(sz - i < PGSIZE)
    800076fa:	fc042783          	lw	a5,-64(s0)
    800076fe:	873e                	mv	a4,a5
    80007700:	fec42783          	lw	a5,-20(s0)
    80007704:	40f707bb          	subw	a5,a4,a5
    80007708:	0007871b          	sext.w	a4,a5
    8000770c:	6785                	lui	a5,0x1
    8000770e:	00f77c63          	bgeu	a4,a5,80007726 <loadseg+0x84>
      n = sz - i;
    80007712:	fc042783          	lw	a5,-64(s0)
    80007716:	873e                	mv	a4,a5
    80007718:	fec42783          	lw	a5,-20(s0)
    8000771c:	40f707bb          	subw	a5,a4,a5
    80007720:	fef42423          	sw	a5,-24(s0)
    80007724:	a021                	j	8000772c <loadseg+0x8a>
    else
      n = PGSIZE;
    80007726:	6785                	lui	a5,0x1
    80007728:	fef42423          	sw	a5,-24(s0)
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000772c:	fc442783          	lw	a5,-60(s0)
    80007730:	873e                	mv	a4,a5
    80007732:	fec42783          	lw	a5,-20(s0)
    80007736:	9fb9                	addw	a5,a5,a4
    80007738:	2781                	sext.w	a5,a5
    8000773a:	fe842703          	lw	a4,-24(s0)
    8000773e:	86be                	mv	a3,a5
    80007740:	fe043603          	ld	a2,-32(s0)
    80007744:	4581                	li	a1,0
    80007746:	fc843503          	ld	a0,-56(s0)
    8000774a:	ffffe097          	auipc	ra,0xffffe
    8000774e:	f84080e7          	jalr	-124(ra) # 800056ce <readi>
    80007752:	87aa                	mv	a5,a0
    80007754:	873e                	mv	a4,a5
    80007756:	fe842783          	lw	a5,-24(s0)
    8000775a:	2781                	sext.w	a5,a5
    8000775c:	00e78463          	beq	a5,a4,80007764 <loadseg+0xc2>
      return -1;
    80007760:	57fd                	li	a5,-1
    80007762:	a015                	j	80007786 <loadseg+0xe4>
  for(i = 0; i < sz; i += PGSIZE){
    80007764:	fec42783          	lw	a5,-20(s0)
    80007768:	873e                	mv	a4,a5
    8000776a:	6785                	lui	a5,0x1
    8000776c:	9fb9                	addw	a5,a5,a4
    8000776e:	fef42623          	sw	a5,-20(s0)
    80007772:	fec42783          	lw	a5,-20(s0)
    80007776:	873e                	mv	a4,a5
    80007778:	fc042783          	lw	a5,-64(s0)
    8000777c:	2701                	sext.w	a4,a4
    8000777e:	2781                	sext.w	a5,a5
    80007780:	f4f764e3          	bltu	a4,a5,800076c8 <loadseg+0x26>
  }
  
  return 0;
    80007784:	4781                	li	a5,0
}
    80007786:	853e                	mv	a0,a5
    80007788:	70e2                	ld	ra,56(sp)
    8000778a:	7442                	ld	s0,48(sp)
    8000778c:	6121                	addi	sp,sp,64
    8000778e:	8082                	ret

0000000080007790 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80007790:	7139                	addi	sp,sp,-64
    80007792:	fc06                	sd	ra,56(sp)
    80007794:	f822                	sd	s0,48(sp)
    80007796:	0080                	addi	s0,sp,64
    80007798:	87aa                	mv	a5,a0
    8000779a:	fcb43823          	sd	a1,-48(s0)
    8000779e:	fcc43423          	sd	a2,-56(s0)
    800077a2:	fcf42e23          	sw	a5,-36(s0)
  int fd;
  struct file *f;

  argint(n, &fd);
    800077a6:	fe440713          	addi	a4,s0,-28
    800077aa:	fdc42783          	lw	a5,-36(s0)
    800077ae:	85ba                	mv	a1,a4
    800077b0:	853e                	mv	a0,a5
    800077b2:	ffffd097          	auipc	ra,0xffffd
    800077b6:	9f6080e7          	jalr	-1546(ra) # 800041a8 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800077ba:	fe442783          	lw	a5,-28(s0)
    800077be:	0207c763          	bltz	a5,800077ec <argfd+0x5c>
    800077c2:	fe442703          	lw	a4,-28(s0)
    800077c6:	47bd                	li	a5,15
    800077c8:	02e7c263          	blt	a5,a4,800077ec <argfd+0x5c>
    800077cc:	ffffb097          	auipc	ra,0xffffb
    800077d0:	0f0080e7          	jalr	240(ra) # 800028bc <myproc>
    800077d4:	872a                	mv	a4,a0
    800077d6:	fe442783          	lw	a5,-28(s0)
    800077da:	07e9                	addi	a5,a5,26 # 101a <_entry-0x7fffefe6>
    800077dc:	078e                	slli	a5,a5,0x3
    800077de:	97ba                	add	a5,a5,a4
    800077e0:	639c                	ld	a5,0(a5)
    800077e2:	fef43423          	sd	a5,-24(s0)
    800077e6:	fe843783          	ld	a5,-24(s0)
    800077ea:	e399                	bnez	a5,800077f0 <argfd+0x60>
    return -1;
    800077ec:	57fd                	li	a5,-1
    800077ee:	a015                	j	80007812 <argfd+0x82>
  if(pfd)
    800077f0:	fd043783          	ld	a5,-48(s0)
    800077f4:	c791                	beqz	a5,80007800 <argfd+0x70>
    *pfd = fd;
    800077f6:	fe442703          	lw	a4,-28(s0)
    800077fa:	fd043783          	ld	a5,-48(s0)
    800077fe:	c398                	sw	a4,0(a5)
  if(pf)
    80007800:	fc843783          	ld	a5,-56(s0)
    80007804:	c791                	beqz	a5,80007810 <argfd+0x80>
    *pf = f;
    80007806:	fc843783          	ld	a5,-56(s0)
    8000780a:	fe843703          	ld	a4,-24(s0)
    8000780e:	e398                	sd	a4,0(a5)
  return 0;
    80007810:	4781                	li	a5,0
}
    80007812:	853e                	mv	a0,a5
    80007814:	70e2                	ld	ra,56(sp)
    80007816:	7442                	ld	s0,48(sp)
    80007818:	6121                	addi	sp,sp,64
    8000781a:	8082                	ret

000000008000781c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000781c:	7179                	addi	sp,sp,-48
    8000781e:	f406                	sd	ra,40(sp)
    80007820:	f022                	sd	s0,32(sp)
    80007822:	1800                	addi	s0,sp,48
    80007824:	fca43c23          	sd	a0,-40(s0)
  int fd;
  struct proc *p = myproc();
    80007828:	ffffb097          	auipc	ra,0xffffb
    8000782c:	094080e7          	jalr	148(ra) # 800028bc <myproc>
    80007830:	fea43023          	sd	a0,-32(s0)

  for(fd = 0; fd < NOFILE; fd++){
    80007834:	fe042623          	sw	zero,-20(s0)
    80007838:	a825                	j	80007870 <fdalloc+0x54>
    if(p->ofile[fd] == 0){
    8000783a:	fe043703          	ld	a4,-32(s0)
    8000783e:	fec42783          	lw	a5,-20(s0)
    80007842:	07e9                	addi	a5,a5,26
    80007844:	078e                	slli	a5,a5,0x3
    80007846:	97ba                	add	a5,a5,a4
    80007848:	639c                	ld	a5,0(a5)
    8000784a:	ef91                	bnez	a5,80007866 <fdalloc+0x4a>
      p->ofile[fd] = f;
    8000784c:	fe043703          	ld	a4,-32(s0)
    80007850:	fec42783          	lw	a5,-20(s0)
    80007854:	07e9                	addi	a5,a5,26
    80007856:	078e                	slli	a5,a5,0x3
    80007858:	97ba                	add	a5,a5,a4
    8000785a:	fd843703          	ld	a4,-40(s0)
    8000785e:	e398                	sd	a4,0(a5)
      return fd;
    80007860:	fec42783          	lw	a5,-20(s0)
    80007864:	a831                	j	80007880 <fdalloc+0x64>
  for(fd = 0; fd < NOFILE; fd++){
    80007866:	fec42783          	lw	a5,-20(s0)
    8000786a:	2785                	addiw	a5,a5,1
    8000786c:	fef42623          	sw	a5,-20(s0)
    80007870:	fec42783          	lw	a5,-20(s0)
    80007874:	0007871b          	sext.w	a4,a5
    80007878:	47bd                	li	a5,15
    8000787a:	fce7d0e3          	bge	a5,a4,8000783a <fdalloc+0x1e>
    }
  }
  return -1;
    8000787e:	57fd                	li	a5,-1
}
    80007880:	853e                	mv	a0,a5
    80007882:	70a2                	ld	ra,40(sp)
    80007884:	7402                	ld	s0,32(sp)
    80007886:	6145                	addi	sp,sp,48
    80007888:	8082                	ret

000000008000788a <sys_dup>:

uint64
sys_dup(void)
{
    8000788a:	1101                	addi	sp,sp,-32
    8000788c:	ec06                	sd	ra,24(sp)
    8000788e:	e822                	sd	s0,16(sp)
    80007890:	1000                	addi	s0,sp,32
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    80007892:	fe040793          	addi	a5,s0,-32
    80007896:	863e                	mv	a2,a5
    80007898:	4581                	li	a1,0
    8000789a:	4501                	li	a0,0
    8000789c:	00000097          	auipc	ra,0x0
    800078a0:	ef4080e7          	jalr	-268(ra) # 80007790 <argfd>
    800078a4:	87aa                	mv	a5,a0
    800078a6:	0007d463          	bgez	a5,800078ae <sys_dup+0x24>
    return -1;
    800078aa:	57fd                	li	a5,-1
    800078ac:	a81d                	j	800078e2 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
    800078ae:	fe043783          	ld	a5,-32(s0)
    800078b2:	853e                	mv	a0,a5
    800078b4:	00000097          	auipc	ra,0x0
    800078b8:	f68080e7          	jalr	-152(ra) # 8000781c <fdalloc>
    800078bc:	87aa                	mv	a5,a0
    800078be:	fef42623          	sw	a5,-20(s0)
    800078c2:	fec42783          	lw	a5,-20(s0)
    800078c6:	2781                	sext.w	a5,a5
    800078c8:	0007d463          	bgez	a5,800078d0 <sys_dup+0x46>
    return -1;
    800078cc:	57fd                	li	a5,-1
    800078ce:	a811                	j	800078e2 <sys_dup+0x58>
  filedup(f);
    800078d0:	fe043783          	ld	a5,-32(s0)
    800078d4:	853e                	mv	a0,a5
    800078d6:	fffff097          	auipc	ra,0xfffff
    800078da:	ede080e7          	jalr	-290(ra) # 800067b4 <filedup>
  return fd;
    800078de:	fec42783          	lw	a5,-20(s0)
}
    800078e2:	853e                	mv	a0,a5
    800078e4:	60e2                	ld	ra,24(sp)
    800078e6:	6442                	ld	s0,16(sp)
    800078e8:	6105                	addi	sp,sp,32
    800078ea:	8082                	ret

00000000800078ec <sys_read>:

uint64
sys_read(void)
{
    800078ec:	7179                	addi	sp,sp,-48
    800078ee:	f406                	sd	ra,40(sp)
    800078f0:	f022                	sd	s0,32(sp)
    800078f2:	1800                	addi	s0,sp,48
  struct file *f;
  int n;
  uint64 p;

  argaddr(1, &p);
    800078f4:	fd840793          	addi	a5,s0,-40
    800078f8:	85be                	mv	a1,a5
    800078fa:	4505                	li	a0,1
    800078fc:	ffffd097          	auipc	ra,0xffffd
    80007900:	8e2080e7          	jalr	-1822(ra) # 800041de <argaddr>
  argint(2, &n);
    80007904:	fe440793          	addi	a5,s0,-28
    80007908:	85be                	mv	a1,a5
    8000790a:	4509                	li	a0,2
    8000790c:	ffffd097          	auipc	ra,0xffffd
    80007910:	89c080e7          	jalr	-1892(ra) # 800041a8 <argint>
  if(argfd(0, 0, &f) < 0)
    80007914:	fe840793          	addi	a5,s0,-24
    80007918:	863e                	mv	a2,a5
    8000791a:	4581                	li	a1,0
    8000791c:	4501                	li	a0,0
    8000791e:	00000097          	auipc	ra,0x0
    80007922:	e72080e7          	jalr	-398(ra) # 80007790 <argfd>
    80007926:	87aa                	mv	a5,a0
    80007928:	0007d463          	bgez	a5,80007930 <sys_read+0x44>
    return -1;
    8000792c:	57fd                	li	a5,-1
    8000792e:	a839                	j	8000794c <sys_read+0x60>
  return fileread(f, p, n);
    80007930:	fe843783          	ld	a5,-24(s0)
    80007934:	fd843703          	ld	a4,-40(s0)
    80007938:	fe442683          	lw	a3,-28(s0)
    8000793c:	8636                	mv	a2,a3
    8000793e:	85ba                	mv	a1,a4
    80007940:	853e                	mv	a0,a5
    80007942:	fffff097          	auipc	ra,0xfffff
    80007946:	07a080e7          	jalr	122(ra) # 800069bc <fileread>
    8000794a:	87aa                	mv	a5,a0
}
    8000794c:	853e                	mv	a0,a5
    8000794e:	70a2                	ld	ra,40(sp)
    80007950:	7402                	ld	s0,32(sp)
    80007952:	6145                	addi	sp,sp,48
    80007954:	8082                	ret

0000000080007956 <sys_write>:

uint64
sys_write(void)
{
    80007956:	7179                	addi	sp,sp,-48
    80007958:	f406                	sd	ra,40(sp)
    8000795a:	f022                	sd	s0,32(sp)
    8000795c:	1800                	addi	s0,sp,48
  struct file *f;
  int n;
  uint64 p;
  
  argaddr(1, &p);
    8000795e:	fd840793          	addi	a5,s0,-40
    80007962:	85be                	mv	a1,a5
    80007964:	4505                	li	a0,1
    80007966:	ffffd097          	auipc	ra,0xffffd
    8000796a:	878080e7          	jalr	-1928(ra) # 800041de <argaddr>
  argint(2, &n);
    8000796e:	fe440793          	addi	a5,s0,-28
    80007972:	85be                	mv	a1,a5
    80007974:	4509                	li	a0,2
    80007976:	ffffd097          	auipc	ra,0xffffd
    8000797a:	832080e7          	jalr	-1998(ra) # 800041a8 <argint>
  if(argfd(0, 0, &f) < 0)
    8000797e:	fe840793          	addi	a5,s0,-24
    80007982:	863e                	mv	a2,a5
    80007984:	4581                	li	a1,0
    80007986:	4501                	li	a0,0
    80007988:	00000097          	auipc	ra,0x0
    8000798c:	e08080e7          	jalr	-504(ra) # 80007790 <argfd>
    80007990:	87aa                	mv	a5,a0
    80007992:	0007d463          	bgez	a5,8000799a <sys_write+0x44>
    return -1;
    80007996:	57fd                	li	a5,-1
    80007998:	a839                	j	800079b6 <sys_write+0x60>

  return filewrite(f, p, n);
    8000799a:	fe843783          	ld	a5,-24(s0)
    8000799e:	fd843703          	ld	a4,-40(s0)
    800079a2:	fe442683          	lw	a3,-28(s0)
    800079a6:	8636                	mv	a2,a3
    800079a8:	85ba                	mv	a1,a4
    800079aa:	853e                	mv	a0,a5
    800079ac:	fffff097          	auipc	ra,0xfffff
    800079b0:	166080e7          	jalr	358(ra) # 80006b12 <filewrite>
    800079b4:	87aa                	mv	a5,a0
}
    800079b6:	853e                	mv	a0,a5
    800079b8:	70a2                	ld	ra,40(sp)
    800079ba:	7402                	ld	s0,32(sp)
    800079bc:	6145                	addi	sp,sp,48
    800079be:	8082                	ret

00000000800079c0 <sys_close>:

uint64
sys_close(void)
{
    800079c0:	1101                	addi	sp,sp,-32
    800079c2:	ec06                	sd	ra,24(sp)
    800079c4:	e822                	sd	s0,16(sp)
    800079c6:	1000                	addi	s0,sp,32
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    800079c8:	fe040713          	addi	a4,s0,-32
    800079cc:	fec40793          	addi	a5,s0,-20
    800079d0:	863a                	mv	a2,a4
    800079d2:	85be                	mv	a1,a5
    800079d4:	4501                	li	a0,0
    800079d6:	00000097          	auipc	ra,0x0
    800079da:	dba080e7          	jalr	-582(ra) # 80007790 <argfd>
    800079de:	87aa                	mv	a5,a0
    800079e0:	0007d463          	bgez	a5,800079e8 <sys_close+0x28>
    return -1;
    800079e4:	57fd                	li	a5,-1
    800079e6:	a02d                	j	80007a10 <sys_close+0x50>
  myproc()->ofile[fd] = 0;
    800079e8:	ffffb097          	auipc	ra,0xffffb
    800079ec:	ed4080e7          	jalr	-300(ra) # 800028bc <myproc>
    800079f0:	872a                	mv	a4,a0
    800079f2:	fec42783          	lw	a5,-20(s0)
    800079f6:	07e9                	addi	a5,a5,26
    800079f8:	078e                	slli	a5,a5,0x3
    800079fa:	97ba                	add	a5,a5,a4
    800079fc:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80007a00:	fe043783          	ld	a5,-32(s0)
    80007a04:	853e                	mv	a0,a5
    80007a06:	fffff097          	auipc	ra,0xfffff
    80007a0a:	e14080e7          	jalr	-492(ra) # 8000681a <fileclose>
  return 0;
    80007a0e:	4781                	li	a5,0
}
    80007a10:	853e                	mv	a0,a5
    80007a12:	60e2                	ld	ra,24(sp)
    80007a14:	6442                	ld	s0,16(sp)
    80007a16:	6105                	addi	sp,sp,32
    80007a18:	8082                	ret

0000000080007a1a <sys_fstat>:

uint64
sys_fstat(void)
{
    80007a1a:	1101                	addi	sp,sp,-32
    80007a1c:	ec06                	sd	ra,24(sp)
    80007a1e:	e822                	sd	s0,16(sp)
    80007a20:	1000                	addi	s0,sp,32
  struct file *f;
  uint64 st; // user pointer to struct stat

  argaddr(1, &st);
    80007a22:	fe040793          	addi	a5,s0,-32
    80007a26:	85be                	mv	a1,a5
    80007a28:	4505                	li	a0,1
    80007a2a:	ffffc097          	auipc	ra,0xffffc
    80007a2e:	7b4080e7          	jalr	1972(ra) # 800041de <argaddr>
  if(argfd(0, 0, &f) < 0)
    80007a32:	fe840793          	addi	a5,s0,-24
    80007a36:	863e                	mv	a2,a5
    80007a38:	4581                	li	a1,0
    80007a3a:	4501                	li	a0,0
    80007a3c:	00000097          	auipc	ra,0x0
    80007a40:	d54080e7          	jalr	-684(ra) # 80007790 <argfd>
    80007a44:	87aa                	mv	a5,a0
    80007a46:	0007d463          	bgez	a5,80007a4e <sys_fstat+0x34>
    return -1;
    80007a4a:	57fd                	li	a5,-1
    80007a4c:	a821                	j	80007a64 <sys_fstat+0x4a>
  return filestat(f, st);
    80007a4e:	fe843783          	ld	a5,-24(s0)
    80007a52:	fe043703          	ld	a4,-32(s0)
    80007a56:	85ba                	mv	a1,a4
    80007a58:	853e                	mv	a0,a5
    80007a5a:	fffff097          	auipc	ra,0xfffff
    80007a5e:	ec2080e7          	jalr	-318(ra) # 8000691c <filestat>
    80007a62:	87aa                	mv	a5,a0
}
    80007a64:	853e                	mv	a0,a5
    80007a66:	60e2                	ld	ra,24(sp)
    80007a68:	6442                	ld	s0,16(sp)
    80007a6a:	6105                	addi	sp,sp,32
    80007a6c:	8082                	ret

0000000080007a6e <sys_link>:

// Create the path new as a link to the same inode as old.
uint64
sys_link(void)
{
    80007a6e:	7169                	addi	sp,sp,-304
    80007a70:	f606                	sd	ra,296(sp)
    80007a72:	f222                	sd	s0,288(sp)
    80007a74:	1a00                	addi	s0,sp,304
  char name[DIRSIZ], new[MAXPATH], old[MAXPATH];
  struct inode *dp, *ip;

  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80007a76:	ed040793          	addi	a5,s0,-304
    80007a7a:	08000613          	li	a2,128
    80007a7e:	85be                	mv	a1,a5
    80007a80:	4501                	li	a0,0
    80007a82:	ffffc097          	auipc	ra,0xffffc
    80007a86:	78e080e7          	jalr	1934(ra) # 80004210 <argstr>
    80007a8a:	87aa                	mv	a5,a0
    80007a8c:	0007cf63          	bltz	a5,80007aaa <sys_link+0x3c>
    80007a90:	f5040793          	addi	a5,s0,-176
    80007a94:	08000613          	li	a2,128
    80007a98:	85be                	mv	a1,a5
    80007a9a:	4505                	li	a0,1
    80007a9c:	ffffc097          	auipc	ra,0xffffc
    80007aa0:	774080e7          	jalr	1908(ra) # 80004210 <argstr>
    80007aa4:	87aa                	mv	a5,a0
    80007aa6:	0007d463          	bgez	a5,80007aae <sys_link+0x40>
    return -1;
    80007aaa:	57fd                	li	a5,-1
    80007aac:	aaa5                	j	80007c24 <sys_link+0x1b6>

  begin_op();
    80007aae:	ffffe097          	auipc	ra,0xffffe
    80007ab2:	6e2080e7          	jalr	1762(ra) # 80006190 <begin_op>
  if((ip = namei(old)) == 0){
    80007ab6:	ed040793          	addi	a5,s0,-304
    80007aba:	853e                	mv	a0,a5
    80007abc:	ffffe097          	auipc	ra,0xffffe
    80007ac0:	384080e7          	jalr	900(ra) # 80005e40 <namei>
    80007ac4:	fea43423          	sd	a0,-24(s0)
    80007ac8:	fe843783          	ld	a5,-24(s0)
    80007acc:	e799                	bnez	a5,80007ada <sys_link+0x6c>
    end_op();
    80007ace:	ffffe097          	auipc	ra,0xffffe
    80007ad2:	784080e7          	jalr	1924(ra) # 80006252 <end_op>
    return -1;
    80007ad6:	57fd                	li	a5,-1
    80007ad8:	a2b1                	j	80007c24 <sys_link+0x1b6>
  }

  ilock(ip);
    80007ada:	fe843503          	ld	a0,-24(s0)
    80007ade:	ffffd097          	auipc	ra,0xffffd
    80007ae2:	642080e7          	jalr	1602(ra) # 80005120 <ilock>
  if(ip->type == T_DIR){
    80007ae6:	fe843783          	ld	a5,-24(s0)
    80007aea:	04479703          	lh	a4,68(a5)
    80007aee:	4785                	li	a5,1
    80007af0:	00f71e63          	bne	a4,a5,80007b0c <sys_link+0x9e>
    iunlockput(ip);
    80007af4:	fe843503          	ld	a0,-24(s0)
    80007af8:	ffffe097          	auipc	ra,0xffffe
    80007afc:	884080e7          	jalr	-1916(ra) # 8000537c <iunlockput>
    end_op();
    80007b00:	ffffe097          	auipc	ra,0xffffe
    80007b04:	752080e7          	jalr	1874(ra) # 80006252 <end_op>
    return -1;
    80007b08:	57fd                	li	a5,-1
    80007b0a:	aa29                	j	80007c24 <sys_link+0x1b6>
  }

  ip->nlink++;
    80007b0c:	fe843783          	ld	a5,-24(s0)
    80007b10:	04a79783          	lh	a5,74(a5)
    80007b14:	17c2                	slli	a5,a5,0x30
    80007b16:	93c1                	srli	a5,a5,0x30
    80007b18:	2785                	addiw	a5,a5,1
    80007b1a:	17c2                	slli	a5,a5,0x30
    80007b1c:	93c1                	srli	a5,a5,0x30
    80007b1e:	0107971b          	slliw	a4,a5,0x10
    80007b22:	4107571b          	sraiw	a4,a4,0x10
    80007b26:	fe843783          	ld	a5,-24(s0)
    80007b2a:	04e79523          	sh	a4,74(a5)
  iupdate(ip);
    80007b2e:	fe843503          	ld	a0,-24(s0)
    80007b32:	ffffd097          	auipc	ra,0xffffd
    80007b36:	39e080e7          	jalr	926(ra) # 80004ed0 <iupdate>
  iunlock(ip);
    80007b3a:	fe843503          	ld	a0,-24(s0)
    80007b3e:	ffffd097          	auipc	ra,0xffffd
    80007b42:	716080e7          	jalr	1814(ra) # 80005254 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
    80007b46:	fd040713          	addi	a4,s0,-48
    80007b4a:	f5040793          	addi	a5,s0,-176
    80007b4e:	85ba                	mv	a1,a4
    80007b50:	853e                	mv	a0,a5
    80007b52:	ffffe097          	auipc	ra,0xffffe
    80007b56:	31a080e7          	jalr	794(ra) # 80005e6c <nameiparent>
    80007b5a:	fea43023          	sd	a0,-32(s0)
    80007b5e:	fe043783          	ld	a5,-32(s0)
    80007b62:	cba5                	beqz	a5,80007bd2 <sys_link+0x164>
    goto bad;
  ilock(dp);
    80007b64:	fe043503          	ld	a0,-32(s0)
    80007b68:	ffffd097          	auipc	ra,0xffffd
    80007b6c:	5b8080e7          	jalr	1464(ra) # 80005120 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80007b70:	fe043783          	ld	a5,-32(s0)
    80007b74:	4398                	lw	a4,0(a5)
    80007b76:	fe843783          	ld	a5,-24(s0)
    80007b7a:	439c                	lw	a5,0(a5)
    80007b7c:	02f71263          	bne	a4,a5,80007ba0 <sys_link+0x132>
    80007b80:	fe843783          	ld	a5,-24(s0)
    80007b84:	43d8                	lw	a4,4(a5)
    80007b86:	fd040793          	addi	a5,s0,-48
    80007b8a:	863a                	mv	a2,a4
    80007b8c:	85be                	mv	a1,a5
    80007b8e:	fe043503          	ld	a0,-32(s0)
    80007b92:	ffffe097          	auipc	ra,0xffffe
    80007b96:	fa4080e7          	jalr	-92(ra) # 80005b36 <dirlink>
    80007b9a:	87aa                	mv	a5,a0
    80007b9c:	0007d963          	bgez	a5,80007bae <sys_link+0x140>
    iunlockput(dp);
    80007ba0:	fe043503          	ld	a0,-32(s0)
    80007ba4:	ffffd097          	auipc	ra,0xffffd
    80007ba8:	7d8080e7          	jalr	2008(ra) # 8000537c <iunlockput>
    goto bad;
    80007bac:	a025                	j	80007bd4 <sys_link+0x166>
  }
  iunlockput(dp);
    80007bae:	fe043503          	ld	a0,-32(s0)
    80007bb2:	ffffd097          	auipc	ra,0xffffd
    80007bb6:	7ca080e7          	jalr	1994(ra) # 8000537c <iunlockput>
  iput(ip);
    80007bba:	fe843503          	ld	a0,-24(s0)
    80007bbe:	ffffd097          	auipc	ra,0xffffd
    80007bc2:	6f0080e7          	jalr	1776(ra) # 800052ae <iput>

  end_op();
    80007bc6:	ffffe097          	auipc	ra,0xffffe
    80007bca:	68c080e7          	jalr	1676(ra) # 80006252 <end_op>

  return 0;
    80007bce:	4781                	li	a5,0
    80007bd0:	a891                	j	80007c24 <sys_link+0x1b6>
    goto bad;
    80007bd2:	0001                	nop

bad:
  ilock(ip);
    80007bd4:	fe843503          	ld	a0,-24(s0)
    80007bd8:	ffffd097          	auipc	ra,0xffffd
    80007bdc:	548080e7          	jalr	1352(ra) # 80005120 <ilock>
  ip->nlink--;
    80007be0:	fe843783          	ld	a5,-24(s0)
    80007be4:	04a79783          	lh	a5,74(a5)
    80007be8:	17c2                	slli	a5,a5,0x30
    80007bea:	93c1                	srli	a5,a5,0x30
    80007bec:	37fd                	addiw	a5,a5,-1
    80007bee:	17c2                	slli	a5,a5,0x30
    80007bf0:	93c1                	srli	a5,a5,0x30
    80007bf2:	0107971b          	slliw	a4,a5,0x10
    80007bf6:	4107571b          	sraiw	a4,a4,0x10
    80007bfa:	fe843783          	ld	a5,-24(s0)
    80007bfe:	04e79523          	sh	a4,74(a5)
  iupdate(ip);
    80007c02:	fe843503          	ld	a0,-24(s0)
    80007c06:	ffffd097          	auipc	ra,0xffffd
    80007c0a:	2ca080e7          	jalr	714(ra) # 80004ed0 <iupdate>
  iunlockput(ip);
    80007c0e:	fe843503          	ld	a0,-24(s0)
    80007c12:	ffffd097          	auipc	ra,0xffffd
    80007c16:	76a080e7          	jalr	1898(ra) # 8000537c <iunlockput>
  end_op();
    80007c1a:	ffffe097          	auipc	ra,0xffffe
    80007c1e:	638080e7          	jalr	1592(ra) # 80006252 <end_op>
  return -1;
    80007c22:	57fd                	li	a5,-1
}
    80007c24:	853e                	mv	a0,a5
    80007c26:	70b2                	ld	ra,296(sp)
    80007c28:	7412                	ld	s0,288(sp)
    80007c2a:	6155                	addi	sp,sp,304
    80007c2c:	8082                	ret

0000000080007c2e <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
    80007c2e:	7139                	addi	sp,sp,-64
    80007c30:	fc06                	sd	ra,56(sp)
    80007c32:	f822                	sd	s0,48(sp)
    80007c34:	0080                	addi	s0,sp,64
    80007c36:	fca43423          	sd	a0,-56(s0)
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80007c3a:	02000793          	li	a5,32
    80007c3e:	fef42623          	sw	a5,-20(s0)
    80007c42:	a0b1                	j	80007c8e <isdirempty+0x60>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80007c44:	fd840793          	addi	a5,s0,-40
    80007c48:	fec42683          	lw	a3,-20(s0)
    80007c4c:	4741                	li	a4,16
    80007c4e:	863e                	mv	a2,a5
    80007c50:	4581                	li	a1,0
    80007c52:	fc843503          	ld	a0,-56(s0)
    80007c56:	ffffe097          	auipc	ra,0xffffe
    80007c5a:	a78080e7          	jalr	-1416(ra) # 800056ce <readi>
    80007c5e:	87aa                	mv	a5,a0
    80007c60:	873e                	mv	a4,a5
    80007c62:	47c1                	li	a5,16
    80007c64:	00f70a63          	beq	a4,a5,80007c78 <isdirempty+0x4a>
      panic("isdirempty: readi");
    80007c68:	00004517          	auipc	a0,0x4
    80007c6c:	9b050513          	addi	a0,a0,-1616 # 8000b618 <etext+0x618>
    80007c70:	ffff9097          	auipc	ra,0xffff9
    80007c74:	050080e7          	jalr	80(ra) # 80000cc0 <panic>
    if(de.inum != 0)
    80007c78:	fd845783          	lhu	a5,-40(s0)
    80007c7c:	c399                	beqz	a5,80007c82 <isdirempty+0x54>
      return 0;
    80007c7e:	4781                	li	a5,0
    80007c80:	a839                	j	80007c9e <isdirempty+0x70>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80007c82:	fec42783          	lw	a5,-20(s0)
    80007c86:	27c1                	addiw	a5,a5,16
    80007c88:	2781                	sext.w	a5,a5
    80007c8a:	fef42623          	sw	a5,-20(s0)
    80007c8e:	fc843783          	ld	a5,-56(s0)
    80007c92:	47f8                	lw	a4,76(a5)
    80007c94:	fec42783          	lw	a5,-20(s0)
    80007c98:	fae7e6e3          	bltu	a5,a4,80007c44 <isdirempty+0x16>
  }
  return 1;
    80007c9c:	4785                	li	a5,1
}
    80007c9e:	853e                	mv	a0,a5
    80007ca0:	70e2                	ld	ra,56(sp)
    80007ca2:	7442                	ld	s0,48(sp)
    80007ca4:	6121                	addi	sp,sp,64
    80007ca6:	8082                	ret

0000000080007ca8 <sys_unlink>:

uint64
sys_unlink(void)
{
    80007ca8:	7155                	addi	sp,sp,-208
    80007caa:	e586                	sd	ra,200(sp)
    80007cac:	e1a2                	sd	s0,192(sp)
    80007cae:	0980                	addi	s0,sp,208
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], path[MAXPATH];
  uint off;

  if(argstr(0, path, MAXPATH) < 0)
    80007cb0:	f4040793          	addi	a5,s0,-192
    80007cb4:	08000613          	li	a2,128
    80007cb8:	85be                	mv	a1,a5
    80007cba:	4501                	li	a0,0
    80007cbc:	ffffc097          	auipc	ra,0xffffc
    80007cc0:	554080e7          	jalr	1364(ra) # 80004210 <argstr>
    80007cc4:	87aa                	mv	a5,a0
    80007cc6:	0007d463          	bgez	a5,80007cce <sys_unlink+0x26>
    return -1;
    80007cca:	57fd                	li	a5,-1
    80007ccc:	a2c5                	j	80007eac <sys_unlink+0x204>

  begin_op();
    80007cce:	ffffe097          	auipc	ra,0xffffe
    80007cd2:	4c2080e7          	jalr	1218(ra) # 80006190 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80007cd6:	fc040713          	addi	a4,s0,-64
    80007cda:	f4040793          	addi	a5,s0,-192
    80007cde:	85ba                	mv	a1,a4
    80007ce0:	853e                	mv	a0,a5
    80007ce2:	ffffe097          	auipc	ra,0xffffe
    80007ce6:	18a080e7          	jalr	394(ra) # 80005e6c <nameiparent>
    80007cea:	fea43423          	sd	a0,-24(s0)
    80007cee:	fe843783          	ld	a5,-24(s0)
    80007cf2:	e799                	bnez	a5,80007d00 <sys_unlink+0x58>
    end_op();
    80007cf4:	ffffe097          	auipc	ra,0xffffe
    80007cf8:	55e080e7          	jalr	1374(ra) # 80006252 <end_op>
    return -1;
    80007cfc:	57fd                	li	a5,-1
    80007cfe:	a27d                	j	80007eac <sys_unlink+0x204>
  }

  ilock(dp);
    80007d00:	fe843503          	ld	a0,-24(s0)
    80007d04:	ffffd097          	auipc	ra,0xffffd
    80007d08:	41c080e7          	jalr	1052(ra) # 80005120 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80007d0c:	fc040793          	addi	a5,s0,-64
    80007d10:	00004597          	auipc	a1,0x4
    80007d14:	92058593          	addi	a1,a1,-1760 # 8000b630 <etext+0x630>
    80007d18:	853e                	mv	a0,a5
    80007d1a:	ffffe097          	auipc	ra,0xffffe
    80007d1e:	d0a080e7          	jalr	-758(ra) # 80005a24 <namecmp>
    80007d22:	87aa                	mv	a5,a0
    80007d24:	16078663          	beqz	a5,80007e90 <sys_unlink+0x1e8>
    80007d28:	fc040793          	addi	a5,s0,-64
    80007d2c:	00004597          	auipc	a1,0x4
    80007d30:	90c58593          	addi	a1,a1,-1780 # 8000b638 <etext+0x638>
    80007d34:	853e                	mv	a0,a5
    80007d36:	ffffe097          	auipc	ra,0xffffe
    80007d3a:	cee080e7          	jalr	-786(ra) # 80005a24 <namecmp>
    80007d3e:	87aa                	mv	a5,a0
    80007d40:	14078863          	beqz	a5,80007e90 <sys_unlink+0x1e8>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    80007d44:	f3c40713          	addi	a4,s0,-196
    80007d48:	fc040793          	addi	a5,s0,-64
    80007d4c:	863a                	mv	a2,a4
    80007d4e:	85be                	mv	a1,a5
    80007d50:	fe843503          	ld	a0,-24(s0)
    80007d54:	ffffe097          	auipc	ra,0xffffe
    80007d58:	cfe080e7          	jalr	-770(ra) # 80005a52 <dirlookup>
    80007d5c:	fea43023          	sd	a0,-32(s0)
    80007d60:	fe043783          	ld	a5,-32(s0)
    80007d64:	12078863          	beqz	a5,80007e94 <sys_unlink+0x1ec>
    goto bad;
  ilock(ip);
    80007d68:	fe043503          	ld	a0,-32(s0)
    80007d6c:	ffffd097          	auipc	ra,0xffffd
    80007d70:	3b4080e7          	jalr	948(ra) # 80005120 <ilock>

  if(ip->nlink < 1)
    80007d74:	fe043783          	ld	a5,-32(s0)
    80007d78:	04a79783          	lh	a5,74(a5)
    80007d7c:	00f04a63          	bgtz	a5,80007d90 <sys_unlink+0xe8>
    panic("unlink: nlink < 1");
    80007d80:	00004517          	auipc	a0,0x4
    80007d84:	8c050513          	addi	a0,a0,-1856 # 8000b640 <etext+0x640>
    80007d88:	ffff9097          	auipc	ra,0xffff9
    80007d8c:	f38080e7          	jalr	-200(ra) # 80000cc0 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80007d90:	fe043783          	ld	a5,-32(s0)
    80007d94:	04479703          	lh	a4,68(a5)
    80007d98:	4785                	li	a5,1
    80007d9a:	02f71163          	bne	a4,a5,80007dbc <sys_unlink+0x114>
    80007d9e:	fe043503          	ld	a0,-32(s0)
    80007da2:	00000097          	auipc	ra,0x0
    80007da6:	e8c080e7          	jalr	-372(ra) # 80007c2e <isdirempty>
    80007daa:	87aa                	mv	a5,a0
    80007dac:	eb81                	bnez	a5,80007dbc <sys_unlink+0x114>
    iunlockput(ip);
    80007dae:	fe043503          	ld	a0,-32(s0)
    80007db2:	ffffd097          	auipc	ra,0xffffd
    80007db6:	5ca080e7          	jalr	1482(ra) # 8000537c <iunlockput>
    goto bad;
    80007dba:	a8f1                	j	80007e96 <sys_unlink+0x1ee>
  }

  memset(&de, 0, sizeof(de));
    80007dbc:	fd040793          	addi	a5,s0,-48
    80007dc0:	4641                	li	a2,16
    80007dc2:	4581                	li	a1,0
    80007dc4:	853e                	mv	a0,a5
    80007dc6:	ffff9097          	auipc	ra,0xffff9
    80007dca:	6d2080e7          	jalr	1746(ra) # 80001498 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80007dce:	fd040793          	addi	a5,s0,-48
    80007dd2:	f3c42683          	lw	a3,-196(s0)
    80007dd6:	4741                	li	a4,16
    80007dd8:	863e                	mv	a2,a5
    80007dda:	4581                	li	a1,0
    80007ddc:	fe843503          	ld	a0,-24(s0)
    80007de0:	ffffe097          	auipc	ra,0xffffe
    80007de4:	a8a080e7          	jalr	-1398(ra) # 8000586a <writei>
    80007de8:	87aa                	mv	a5,a0
    80007dea:	873e                	mv	a4,a5
    80007dec:	47c1                	li	a5,16
    80007dee:	00f70a63          	beq	a4,a5,80007e02 <sys_unlink+0x15a>
    panic("unlink: writei");
    80007df2:	00004517          	auipc	a0,0x4
    80007df6:	86650513          	addi	a0,a0,-1946 # 8000b658 <etext+0x658>
    80007dfa:	ffff9097          	auipc	ra,0xffff9
    80007dfe:	ec6080e7          	jalr	-314(ra) # 80000cc0 <panic>
  if(ip->type == T_DIR){
    80007e02:	fe043783          	ld	a5,-32(s0)
    80007e06:	04479703          	lh	a4,68(a5)
    80007e0a:	4785                	li	a5,1
    80007e0c:	02f71963          	bne	a4,a5,80007e3e <sys_unlink+0x196>
    dp->nlink--;
    80007e10:	fe843783          	ld	a5,-24(s0)
    80007e14:	04a79783          	lh	a5,74(a5)
    80007e18:	17c2                	slli	a5,a5,0x30
    80007e1a:	93c1                	srli	a5,a5,0x30
    80007e1c:	37fd                	addiw	a5,a5,-1
    80007e1e:	17c2                	slli	a5,a5,0x30
    80007e20:	93c1                	srli	a5,a5,0x30
    80007e22:	0107971b          	slliw	a4,a5,0x10
    80007e26:	4107571b          	sraiw	a4,a4,0x10
    80007e2a:	fe843783          	ld	a5,-24(s0)
    80007e2e:	04e79523          	sh	a4,74(a5)
    iupdate(dp);
    80007e32:	fe843503          	ld	a0,-24(s0)
    80007e36:	ffffd097          	auipc	ra,0xffffd
    80007e3a:	09a080e7          	jalr	154(ra) # 80004ed0 <iupdate>
  }
  iunlockput(dp);
    80007e3e:	fe843503          	ld	a0,-24(s0)
    80007e42:	ffffd097          	auipc	ra,0xffffd
    80007e46:	53a080e7          	jalr	1338(ra) # 8000537c <iunlockput>

  ip->nlink--;
    80007e4a:	fe043783          	ld	a5,-32(s0)
    80007e4e:	04a79783          	lh	a5,74(a5)
    80007e52:	17c2                	slli	a5,a5,0x30
    80007e54:	93c1                	srli	a5,a5,0x30
    80007e56:	37fd                	addiw	a5,a5,-1
    80007e58:	17c2                	slli	a5,a5,0x30
    80007e5a:	93c1                	srli	a5,a5,0x30
    80007e5c:	0107971b          	slliw	a4,a5,0x10
    80007e60:	4107571b          	sraiw	a4,a4,0x10
    80007e64:	fe043783          	ld	a5,-32(s0)
    80007e68:	04e79523          	sh	a4,74(a5)
  iupdate(ip);
    80007e6c:	fe043503          	ld	a0,-32(s0)
    80007e70:	ffffd097          	auipc	ra,0xffffd
    80007e74:	060080e7          	jalr	96(ra) # 80004ed0 <iupdate>
  iunlockput(ip);
    80007e78:	fe043503          	ld	a0,-32(s0)
    80007e7c:	ffffd097          	auipc	ra,0xffffd
    80007e80:	500080e7          	jalr	1280(ra) # 8000537c <iunlockput>

  end_op();
    80007e84:	ffffe097          	auipc	ra,0xffffe
    80007e88:	3ce080e7          	jalr	974(ra) # 80006252 <end_op>

  return 0;
    80007e8c:	4781                	li	a5,0
    80007e8e:	a839                	j	80007eac <sys_unlink+0x204>
    goto bad;
    80007e90:	0001                	nop
    80007e92:	a011                	j	80007e96 <sys_unlink+0x1ee>
    goto bad;
    80007e94:	0001                	nop

bad:
  iunlockput(dp);
    80007e96:	fe843503          	ld	a0,-24(s0)
    80007e9a:	ffffd097          	auipc	ra,0xffffd
    80007e9e:	4e2080e7          	jalr	1250(ra) # 8000537c <iunlockput>
  end_op();
    80007ea2:	ffffe097          	auipc	ra,0xffffe
    80007ea6:	3b0080e7          	jalr	944(ra) # 80006252 <end_op>
  return -1;
    80007eaa:	57fd                	li	a5,-1
}
    80007eac:	853e                	mv	a0,a5
    80007eae:	60ae                	ld	ra,200(sp)
    80007eb0:	640e                	ld	s0,192(sp)
    80007eb2:	6169                	addi	sp,sp,208
    80007eb4:	8082                	ret

0000000080007eb6 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
    80007eb6:	7139                	addi	sp,sp,-64
    80007eb8:	fc06                	sd	ra,56(sp)
    80007eba:	f822                	sd	s0,48(sp)
    80007ebc:	0080                	addi	s0,sp,64
    80007ebe:	fca43423          	sd	a0,-56(s0)
    80007ec2:	87ae                	mv	a5,a1
    80007ec4:	8736                	mv	a4,a3
    80007ec6:	fcf41323          	sh	a5,-58(s0)
    80007eca:	87b2                	mv	a5,a2
    80007ecc:	fcf41223          	sh	a5,-60(s0)
    80007ed0:	87ba                	mv	a5,a4
    80007ed2:	fcf41123          	sh	a5,-62(s0)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80007ed6:	fd040793          	addi	a5,s0,-48
    80007eda:	85be                	mv	a1,a5
    80007edc:	fc843503          	ld	a0,-56(s0)
    80007ee0:	ffffe097          	auipc	ra,0xffffe
    80007ee4:	f8c080e7          	jalr	-116(ra) # 80005e6c <nameiparent>
    80007ee8:	fea43423          	sd	a0,-24(s0)
    80007eec:	fe843783          	ld	a5,-24(s0)
    80007ef0:	e399                	bnez	a5,80007ef6 <create+0x40>
    return 0;
    80007ef2:	4781                	li	a5,0
    80007ef4:	a2cd                	j	800080d6 <create+0x220>

  ilock(dp);
    80007ef6:	fe843503          	ld	a0,-24(s0)
    80007efa:	ffffd097          	auipc	ra,0xffffd
    80007efe:	226080e7          	jalr	550(ra) # 80005120 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80007f02:	fd040793          	addi	a5,s0,-48
    80007f06:	4601                	li	a2,0
    80007f08:	85be                	mv	a1,a5
    80007f0a:	fe843503          	ld	a0,-24(s0)
    80007f0e:	ffffe097          	auipc	ra,0xffffe
    80007f12:	b44080e7          	jalr	-1212(ra) # 80005a52 <dirlookup>
    80007f16:	fea43023          	sd	a0,-32(s0)
    80007f1a:	fe043783          	ld	a5,-32(s0)
    80007f1e:	cfa9                	beqz	a5,80007f78 <create+0xc2>
    iunlockput(dp);
    80007f20:	fe843503          	ld	a0,-24(s0)
    80007f24:	ffffd097          	auipc	ra,0xffffd
    80007f28:	458080e7          	jalr	1112(ra) # 8000537c <iunlockput>
    ilock(ip);
    80007f2c:	fe043503          	ld	a0,-32(s0)
    80007f30:	ffffd097          	auipc	ra,0xffffd
    80007f34:	1f0080e7          	jalr	496(ra) # 80005120 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80007f38:	fc641783          	lh	a5,-58(s0)
    80007f3c:	0007871b          	sext.w	a4,a5
    80007f40:	4789                	li	a5,2
    80007f42:	02f71363          	bne	a4,a5,80007f68 <create+0xb2>
    80007f46:	fe043783          	ld	a5,-32(s0)
    80007f4a:	04479703          	lh	a4,68(a5)
    80007f4e:	4789                	li	a5,2
    80007f50:	00f70963          	beq	a4,a5,80007f62 <create+0xac>
    80007f54:	fe043783          	ld	a5,-32(s0)
    80007f58:	04479703          	lh	a4,68(a5)
    80007f5c:	478d                	li	a5,3
    80007f5e:	00f71563          	bne	a4,a5,80007f68 <create+0xb2>
      return ip;
    80007f62:	fe043783          	ld	a5,-32(s0)
    80007f66:	aa85                	j	800080d6 <create+0x220>
    iunlockput(ip);
    80007f68:	fe043503          	ld	a0,-32(s0)
    80007f6c:	ffffd097          	auipc	ra,0xffffd
    80007f70:	410080e7          	jalr	1040(ra) # 8000537c <iunlockput>
    return 0;
    80007f74:	4781                	li	a5,0
    80007f76:	a285                	j	800080d6 <create+0x220>
  }

  if((ip = ialloc(dp->dev, type)) == 0){
    80007f78:	fe843783          	ld	a5,-24(s0)
    80007f7c:	439c                	lw	a5,0(a5)
    80007f7e:	fc641703          	lh	a4,-58(s0)
    80007f82:	85ba                	mv	a1,a4
    80007f84:	853e                	mv	a0,a5
    80007f86:	ffffd097          	auipc	ra,0xffffd
    80007f8a:	e4c080e7          	jalr	-436(ra) # 80004dd2 <ialloc>
    80007f8e:	fea43023          	sd	a0,-32(s0)
    80007f92:	fe043783          	ld	a5,-32(s0)
    80007f96:	eb89                	bnez	a5,80007fa8 <create+0xf2>
    iunlockput(dp);
    80007f98:	fe843503          	ld	a0,-24(s0)
    80007f9c:	ffffd097          	auipc	ra,0xffffd
    80007fa0:	3e0080e7          	jalr	992(ra) # 8000537c <iunlockput>
    return 0;
    80007fa4:	4781                	li	a5,0
    80007fa6:	aa05                	j	800080d6 <create+0x220>
  }

  ilock(ip);
    80007fa8:	fe043503          	ld	a0,-32(s0)
    80007fac:	ffffd097          	auipc	ra,0xffffd
    80007fb0:	174080e7          	jalr	372(ra) # 80005120 <ilock>
  ip->major = major;
    80007fb4:	fe043783          	ld	a5,-32(s0)
    80007fb8:	fc445703          	lhu	a4,-60(s0)
    80007fbc:	04e79323          	sh	a4,70(a5)
  ip->minor = minor;
    80007fc0:	fe043783          	ld	a5,-32(s0)
    80007fc4:	fc245703          	lhu	a4,-62(s0)
    80007fc8:	04e79423          	sh	a4,72(a5)
  ip->nlink = 1;
    80007fcc:	fe043783          	ld	a5,-32(s0)
    80007fd0:	4705                	li	a4,1
    80007fd2:	04e79523          	sh	a4,74(a5)
  iupdate(ip);
    80007fd6:	fe043503          	ld	a0,-32(s0)
    80007fda:	ffffd097          	auipc	ra,0xffffd
    80007fde:	ef6080e7          	jalr	-266(ra) # 80004ed0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
    80007fe2:	fc641783          	lh	a5,-58(s0)
    80007fe6:	0007871b          	sext.w	a4,a5
    80007fea:	4785                	li	a5,1
    80007fec:	04f71463          	bne	a4,a5,80008034 <create+0x17e>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80007ff0:	fe043783          	ld	a5,-32(s0)
    80007ff4:	43dc                	lw	a5,4(a5)
    80007ff6:	863e                	mv	a2,a5
    80007ff8:	00003597          	auipc	a1,0x3
    80007ffc:	63858593          	addi	a1,a1,1592 # 8000b630 <etext+0x630>
    80008000:	fe043503          	ld	a0,-32(s0)
    80008004:	ffffe097          	auipc	ra,0xffffe
    80008008:	b32080e7          	jalr	-1230(ra) # 80005b36 <dirlink>
    8000800c:	87aa                	mv	a5,a0
    8000800e:	0807ca63          	bltz	a5,800080a2 <create+0x1ec>
    80008012:	fe843783          	ld	a5,-24(s0)
    80008016:	43dc                	lw	a5,4(a5)
    80008018:	863e                	mv	a2,a5
    8000801a:	00003597          	auipc	a1,0x3
    8000801e:	61e58593          	addi	a1,a1,1566 # 8000b638 <etext+0x638>
    80008022:	fe043503          	ld	a0,-32(s0)
    80008026:	ffffe097          	auipc	ra,0xffffe
    8000802a:	b10080e7          	jalr	-1264(ra) # 80005b36 <dirlink>
    8000802e:	87aa                	mv	a5,a0
    80008030:	0607c963          	bltz	a5,800080a2 <create+0x1ec>
      goto fail;
  }

  if(dirlink(dp, name, ip->inum) < 0)
    80008034:	fe043783          	ld	a5,-32(s0)
    80008038:	43d8                	lw	a4,4(a5)
    8000803a:	fd040793          	addi	a5,s0,-48
    8000803e:	863a                	mv	a2,a4
    80008040:	85be                	mv	a1,a5
    80008042:	fe843503          	ld	a0,-24(s0)
    80008046:	ffffe097          	auipc	ra,0xffffe
    8000804a:	af0080e7          	jalr	-1296(ra) # 80005b36 <dirlink>
    8000804e:	87aa                	mv	a5,a0
    80008050:	0407cb63          	bltz	a5,800080a6 <create+0x1f0>
    goto fail;

  if(type == T_DIR){
    80008054:	fc641783          	lh	a5,-58(s0)
    80008058:	0007871b          	sext.w	a4,a5
    8000805c:	4785                	li	a5,1
    8000805e:	02f71963          	bne	a4,a5,80008090 <create+0x1da>
    // now that success is guaranteed:
    dp->nlink++;  // for ".."
    80008062:	fe843783          	ld	a5,-24(s0)
    80008066:	04a79783          	lh	a5,74(a5)
    8000806a:	17c2                	slli	a5,a5,0x30
    8000806c:	93c1                	srli	a5,a5,0x30
    8000806e:	2785                	addiw	a5,a5,1
    80008070:	17c2                	slli	a5,a5,0x30
    80008072:	93c1                	srli	a5,a5,0x30
    80008074:	0107971b          	slliw	a4,a5,0x10
    80008078:	4107571b          	sraiw	a4,a4,0x10
    8000807c:	fe843783          	ld	a5,-24(s0)
    80008080:	04e79523          	sh	a4,74(a5)
    iupdate(dp);
    80008084:	fe843503          	ld	a0,-24(s0)
    80008088:	ffffd097          	auipc	ra,0xffffd
    8000808c:	e48080e7          	jalr	-440(ra) # 80004ed0 <iupdate>
  }

  iunlockput(dp);
    80008090:	fe843503          	ld	a0,-24(s0)
    80008094:	ffffd097          	auipc	ra,0xffffd
    80008098:	2e8080e7          	jalr	744(ra) # 8000537c <iunlockput>

  return ip;
    8000809c:	fe043783          	ld	a5,-32(s0)
    800080a0:	a81d                	j	800080d6 <create+0x220>
      goto fail;
    800080a2:	0001                	nop
    800080a4:	a011                	j	800080a8 <create+0x1f2>
    goto fail;
    800080a6:	0001                	nop

 fail:
  // something went wrong. de-allocate ip.
  ip->nlink = 0;
    800080a8:	fe043783          	ld	a5,-32(s0)
    800080ac:	04079523          	sh	zero,74(a5)
  iupdate(ip);
    800080b0:	fe043503          	ld	a0,-32(s0)
    800080b4:	ffffd097          	auipc	ra,0xffffd
    800080b8:	e1c080e7          	jalr	-484(ra) # 80004ed0 <iupdate>
  iunlockput(ip);
    800080bc:	fe043503          	ld	a0,-32(s0)
    800080c0:	ffffd097          	auipc	ra,0xffffd
    800080c4:	2bc080e7          	jalr	700(ra) # 8000537c <iunlockput>
  iunlockput(dp);
    800080c8:	fe843503          	ld	a0,-24(s0)
    800080cc:	ffffd097          	auipc	ra,0xffffd
    800080d0:	2b0080e7          	jalr	688(ra) # 8000537c <iunlockput>
  return 0;
    800080d4:	4781                	li	a5,0
}
    800080d6:	853e                	mv	a0,a5
    800080d8:	70e2                	ld	ra,56(sp)
    800080da:	7442                	ld	s0,48(sp)
    800080dc:	6121                	addi	sp,sp,64
    800080de:	8082                	ret

00000000800080e0 <sys_open>:

uint64
sys_open(void)
{
    800080e0:	7131                	addi	sp,sp,-192
    800080e2:	fd06                	sd	ra,184(sp)
    800080e4:	f922                	sd	s0,176(sp)
    800080e6:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800080e8:	f4c40793          	addi	a5,s0,-180
    800080ec:	85be                	mv	a1,a5
    800080ee:	4505                	li	a0,1
    800080f0:	ffffc097          	auipc	ra,0xffffc
    800080f4:	0b8080e7          	jalr	184(ra) # 800041a8 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800080f8:	f5040793          	addi	a5,s0,-176
    800080fc:	08000613          	li	a2,128
    80008100:	85be                	mv	a1,a5
    80008102:	4501                	li	a0,0
    80008104:	ffffc097          	auipc	ra,0xffffc
    80008108:	10c080e7          	jalr	268(ra) # 80004210 <argstr>
    8000810c:	87aa                	mv	a5,a0
    8000810e:	fef42223          	sw	a5,-28(s0)
    80008112:	fe442783          	lw	a5,-28(s0)
    80008116:	2781                	sext.w	a5,a5
    80008118:	0007d463          	bgez	a5,80008120 <sys_open+0x40>
    return -1;
    8000811c:	57fd                	li	a5,-1
    8000811e:	aad5                	j	80008312 <sys_open+0x232>

  begin_op();
    80008120:	ffffe097          	auipc	ra,0xffffe
    80008124:	070080e7          	jalr	112(ra) # 80006190 <begin_op>

  if(omode & O_CREATE){
    80008128:	f4c42783          	lw	a5,-180(s0)
    8000812c:	2007f793          	andi	a5,a5,512
    80008130:	2781                	sext.w	a5,a5
    80008132:	c795                	beqz	a5,8000815e <sys_open+0x7e>
    ip = create(path, T_FILE, 0, 0);
    80008134:	f5040793          	addi	a5,s0,-176
    80008138:	4681                	li	a3,0
    8000813a:	4601                	li	a2,0
    8000813c:	4589                	li	a1,2
    8000813e:	853e                	mv	a0,a5
    80008140:	00000097          	auipc	ra,0x0
    80008144:	d76080e7          	jalr	-650(ra) # 80007eb6 <create>
    80008148:	fea43423          	sd	a0,-24(s0)
    if(ip == 0){
    8000814c:	fe843783          	ld	a5,-24(s0)
    80008150:	e7ad                	bnez	a5,800081ba <sys_open+0xda>
      end_op();
    80008152:	ffffe097          	auipc	ra,0xffffe
    80008156:	100080e7          	jalr	256(ra) # 80006252 <end_op>
      return -1;
    8000815a:	57fd                	li	a5,-1
    8000815c:	aa5d                	j	80008312 <sys_open+0x232>
    }
  } else {
    if((ip = namei(path)) == 0){
    8000815e:	f5040793          	addi	a5,s0,-176
    80008162:	853e                	mv	a0,a5
    80008164:	ffffe097          	auipc	ra,0xffffe
    80008168:	cdc080e7          	jalr	-804(ra) # 80005e40 <namei>
    8000816c:	fea43423          	sd	a0,-24(s0)
    80008170:	fe843783          	ld	a5,-24(s0)
    80008174:	e799                	bnez	a5,80008182 <sys_open+0xa2>
      end_op();
    80008176:	ffffe097          	auipc	ra,0xffffe
    8000817a:	0dc080e7          	jalr	220(ra) # 80006252 <end_op>
      return -1;
    8000817e:	57fd                	li	a5,-1
    80008180:	aa49                	j	80008312 <sys_open+0x232>
    }
    ilock(ip);
    80008182:	fe843503          	ld	a0,-24(s0)
    80008186:	ffffd097          	auipc	ra,0xffffd
    8000818a:	f9a080e7          	jalr	-102(ra) # 80005120 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    8000818e:	fe843783          	ld	a5,-24(s0)
    80008192:	04479703          	lh	a4,68(a5)
    80008196:	4785                	li	a5,1
    80008198:	02f71163          	bne	a4,a5,800081ba <sys_open+0xda>
    8000819c:	f4c42783          	lw	a5,-180(s0)
    800081a0:	cf89                	beqz	a5,800081ba <sys_open+0xda>
      iunlockput(ip);
    800081a2:	fe843503          	ld	a0,-24(s0)
    800081a6:	ffffd097          	auipc	ra,0xffffd
    800081aa:	1d6080e7          	jalr	470(ra) # 8000537c <iunlockput>
      end_op();
    800081ae:	ffffe097          	auipc	ra,0xffffe
    800081b2:	0a4080e7          	jalr	164(ra) # 80006252 <end_op>
      return -1;
    800081b6:	57fd                	li	a5,-1
    800081b8:	aaa9                	j	80008312 <sys_open+0x232>
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800081ba:	fe843783          	ld	a5,-24(s0)
    800081be:	04479703          	lh	a4,68(a5)
    800081c2:	478d                	li	a5,3
    800081c4:	02f71b63          	bne	a4,a5,800081fa <sys_open+0x11a>
    800081c8:	fe843783          	ld	a5,-24(s0)
    800081cc:	04679783          	lh	a5,70(a5)
    800081d0:	0007c963          	bltz	a5,800081e2 <sys_open+0x102>
    800081d4:	fe843783          	ld	a5,-24(s0)
    800081d8:	04679703          	lh	a4,70(a5)
    800081dc:	47a5                	li	a5,9
    800081de:	00e7de63          	bge	a5,a4,800081fa <sys_open+0x11a>
    iunlockput(ip);
    800081e2:	fe843503          	ld	a0,-24(s0)
    800081e6:	ffffd097          	auipc	ra,0xffffd
    800081ea:	196080e7          	jalr	406(ra) # 8000537c <iunlockput>
    end_op();
    800081ee:	ffffe097          	auipc	ra,0xffffe
    800081f2:	064080e7          	jalr	100(ra) # 80006252 <end_op>
    return -1;
    800081f6:	57fd                	li	a5,-1
    800081f8:	aa29                	j	80008312 <sys_open+0x232>
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800081fa:	ffffe097          	auipc	ra,0xffffe
    800081fe:	536080e7          	jalr	1334(ra) # 80006730 <filealloc>
    80008202:	fca43c23          	sd	a0,-40(s0)
    80008206:	fd843783          	ld	a5,-40(s0)
    8000820a:	cf99                	beqz	a5,80008228 <sys_open+0x148>
    8000820c:	fd843503          	ld	a0,-40(s0)
    80008210:	fffff097          	auipc	ra,0xfffff
    80008214:	60c080e7          	jalr	1548(ra) # 8000781c <fdalloc>
    80008218:	87aa                	mv	a5,a0
    8000821a:	fcf42a23          	sw	a5,-44(s0)
    8000821e:	fd442783          	lw	a5,-44(s0)
    80008222:	2781                	sext.w	a5,a5
    80008224:	0207d763          	bgez	a5,80008252 <sys_open+0x172>
    if(f)
    80008228:	fd843783          	ld	a5,-40(s0)
    8000822c:	c799                	beqz	a5,8000823a <sys_open+0x15a>
      fileclose(f);
    8000822e:	fd843503          	ld	a0,-40(s0)
    80008232:	ffffe097          	auipc	ra,0xffffe
    80008236:	5e8080e7          	jalr	1512(ra) # 8000681a <fileclose>
    iunlockput(ip);
    8000823a:	fe843503          	ld	a0,-24(s0)
    8000823e:	ffffd097          	auipc	ra,0xffffd
    80008242:	13e080e7          	jalr	318(ra) # 8000537c <iunlockput>
    end_op();
    80008246:	ffffe097          	auipc	ra,0xffffe
    8000824a:	00c080e7          	jalr	12(ra) # 80006252 <end_op>
    return -1;
    8000824e:	57fd                	li	a5,-1
    80008250:	a0c9                	j	80008312 <sys_open+0x232>
  }

  if(ip->type == T_DEVICE){
    80008252:	fe843783          	ld	a5,-24(s0)
    80008256:	04479703          	lh	a4,68(a5)
    8000825a:	478d                	li	a5,3
    8000825c:	00f71f63          	bne	a4,a5,8000827a <sys_open+0x19a>
    f->type = FD_DEVICE;
    80008260:	fd843783          	ld	a5,-40(s0)
    80008264:	470d                	li	a4,3
    80008266:	c398                	sw	a4,0(a5)
    f->major = ip->major;
    80008268:	fe843783          	ld	a5,-24(s0)
    8000826c:	04679703          	lh	a4,70(a5)
    80008270:	fd843783          	ld	a5,-40(s0)
    80008274:	02e79223          	sh	a4,36(a5)
    80008278:	a809                	j	8000828a <sys_open+0x1aa>
  } else {
    f->type = FD_INODE;
    8000827a:	fd843783          	ld	a5,-40(s0)
    8000827e:	4709                	li	a4,2
    80008280:	c398                	sw	a4,0(a5)
    f->off = 0;
    80008282:	fd843783          	ld	a5,-40(s0)
    80008286:	0207a023          	sw	zero,32(a5)
  }
  f->ip = ip;
    8000828a:	fd843783          	ld	a5,-40(s0)
    8000828e:	fe843703          	ld	a4,-24(s0)
    80008292:	ef98                	sd	a4,24(a5)
  f->readable = !(omode & O_WRONLY);
    80008294:	f4c42783          	lw	a5,-180(s0)
    80008298:	8b85                	andi	a5,a5,1
    8000829a:	2781                	sext.w	a5,a5
    8000829c:	0017b793          	seqz	a5,a5
    800082a0:	0ff7f793          	zext.b	a5,a5
    800082a4:	873e                	mv	a4,a5
    800082a6:	fd843783          	ld	a5,-40(s0)
    800082aa:	00e78423          	sb	a4,8(a5)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800082ae:	f4c42783          	lw	a5,-180(s0)
    800082b2:	8b85                	andi	a5,a5,1
    800082b4:	2781                	sext.w	a5,a5
    800082b6:	e791                	bnez	a5,800082c2 <sys_open+0x1e2>
    800082b8:	f4c42783          	lw	a5,-180(s0)
    800082bc:	8b89                	andi	a5,a5,2
    800082be:	2781                	sext.w	a5,a5
    800082c0:	c399                	beqz	a5,800082c6 <sys_open+0x1e6>
    800082c2:	4785                	li	a5,1
    800082c4:	a011                	j	800082c8 <sys_open+0x1e8>
    800082c6:	4781                	li	a5,0
    800082c8:	0ff7f713          	zext.b	a4,a5
    800082cc:	fd843783          	ld	a5,-40(s0)
    800082d0:	00e784a3          	sb	a4,9(a5)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800082d4:	f4c42783          	lw	a5,-180(s0)
    800082d8:	4007f793          	andi	a5,a5,1024
    800082dc:	2781                	sext.w	a5,a5
    800082de:	cf91                	beqz	a5,800082fa <sys_open+0x21a>
    800082e0:	fe843783          	ld	a5,-24(s0)
    800082e4:	04479703          	lh	a4,68(a5)
    800082e8:	4789                	li	a5,2
    800082ea:	00f71863          	bne	a4,a5,800082fa <sys_open+0x21a>
    itrunc(ip);
    800082ee:	fe843503          	ld	a0,-24(s0)
    800082f2:	ffffd097          	auipc	ra,0xffffd
    800082f6:	234080e7          	jalr	564(ra) # 80005526 <itrunc>
  }

  iunlock(ip);
    800082fa:	fe843503          	ld	a0,-24(s0)
    800082fe:	ffffd097          	auipc	ra,0xffffd
    80008302:	f56080e7          	jalr	-170(ra) # 80005254 <iunlock>
  end_op();
    80008306:	ffffe097          	auipc	ra,0xffffe
    8000830a:	f4c080e7          	jalr	-180(ra) # 80006252 <end_op>

  return fd;
    8000830e:	fd442783          	lw	a5,-44(s0)
}
    80008312:	853e                	mv	a0,a5
    80008314:	70ea                	ld	ra,184(sp)
    80008316:	744a                	ld	s0,176(sp)
    80008318:	6129                	addi	sp,sp,192
    8000831a:	8082                	ret

000000008000831c <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000831c:	7135                	addi	sp,sp,-160
    8000831e:	ed06                	sd	ra,152(sp)
    80008320:	e922                	sd	s0,144(sp)
    80008322:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80008324:	ffffe097          	auipc	ra,0xffffe
    80008328:	e6c080e7          	jalr	-404(ra) # 80006190 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000832c:	f6840793          	addi	a5,s0,-152
    80008330:	08000613          	li	a2,128
    80008334:	85be                	mv	a1,a5
    80008336:	4501                	li	a0,0
    80008338:	ffffc097          	auipc	ra,0xffffc
    8000833c:	ed8080e7          	jalr	-296(ra) # 80004210 <argstr>
    80008340:	87aa                	mv	a5,a0
    80008342:	0207c163          	bltz	a5,80008364 <sys_mkdir+0x48>
    80008346:	f6840793          	addi	a5,s0,-152
    8000834a:	4681                	li	a3,0
    8000834c:	4601                	li	a2,0
    8000834e:	4585                	li	a1,1
    80008350:	853e                	mv	a0,a5
    80008352:	00000097          	auipc	ra,0x0
    80008356:	b64080e7          	jalr	-1180(ra) # 80007eb6 <create>
    8000835a:	fea43423          	sd	a0,-24(s0)
    8000835e:	fe843783          	ld	a5,-24(s0)
    80008362:	e799                	bnez	a5,80008370 <sys_mkdir+0x54>
    end_op();
    80008364:	ffffe097          	auipc	ra,0xffffe
    80008368:	eee080e7          	jalr	-274(ra) # 80006252 <end_op>
    return -1;
    8000836c:	57fd                	li	a5,-1
    8000836e:	a821                	j	80008386 <sys_mkdir+0x6a>
  }
  iunlockput(ip);
    80008370:	fe843503          	ld	a0,-24(s0)
    80008374:	ffffd097          	auipc	ra,0xffffd
    80008378:	008080e7          	jalr	8(ra) # 8000537c <iunlockput>
  end_op();
    8000837c:	ffffe097          	auipc	ra,0xffffe
    80008380:	ed6080e7          	jalr	-298(ra) # 80006252 <end_op>
  return 0;
    80008384:	4781                	li	a5,0
}
    80008386:	853e                	mv	a0,a5
    80008388:	60ea                	ld	ra,152(sp)
    8000838a:	644a                	ld	s0,144(sp)
    8000838c:	610d                	addi	sp,sp,160
    8000838e:	8082                	ret

0000000080008390 <sys_mknod>:

uint64
sys_mknod(void)
{
    80008390:	7135                	addi	sp,sp,-160
    80008392:	ed06                	sd	ra,152(sp)
    80008394:	e922                	sd	s0,144(sp)
    80008396:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80008398:	ffffe097          	auipc	ra,0xffffe
    8000839c:	df8080e7          	jalr	-520(ra) # 80006190 <begin_op>
  argint(1, &major);
    800083a0:	f6440793          	addi	a5,s0,-156
    800083a4:	85be                	mv	a1,a5
    800083a6:	4505                	li	a0,1
    800083a8:	ffffc097          	auipc	ra,0xffffc
    800083ac:	e00080e7          	jalr	-512(ra) # 800041a8 <argint>
  argint(2, &minor);
    800083b0:	f6040793          	addi	a5,s0,-160
    800083b4:	85be                	mv	a1,a5
    800083b6:	4509                	li	a0,2
    800083b8:	ffffc097          	auipc	ra,0xffffc
    800083bc:	df0080e7          	jalr	-528(ra) # 800041a8 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800083c0:	f6840793          	addi	a5,s0,-152
    800083c4:	08000613          	li	a2,128
    800083c8:	85be                	mv	a1,a5
    800083ca:	4501                	li	a0,0
    800083cc:	ffffc097          	auipc	ra,0xffffc
    800083d0:	e44080e7          	jalr	-444(ra) # 80004210 <argstr>
    800083d4:	87aa                	mv	a5,a0
    800083d6:	0207cc63          	bltz	a5,8000840e <sys_mknod+0x7e>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800083da:	f6442783          	lw	a5,-156(s0)
    800083de:	0107971b          	slliw	a4,a5,0x10
    800083e2:	4107571b          	sraiw	a4,a4,0x10
    800083e6:	f6042783          	lw	a5,-160(s0)
    800083ea:	0107969b          	slliw	a3,a5,0x10
    800083ee:	4106d69b          	sraiw	a3,a3,0x10
    800083f2:	f6840793          	addi	a5,s0,-152
    800083f6:	863a                	mv	a2,a4
    800083f8:	458d                	li	a1,3
    800083fa:	853e                	mv	a0,a5
    800083fc:	00000097          	auipc	ra,0x0
    80008400:	aba080e7          	jalr	-1350(ra) # 80007eb6 <create>
    80008404:	fea43423          	sd	a0,-24(s0)
  if((argstr(0, path, MAXPATH)) < 0 ||
    80008408:	fe843783          	ld	a5,-24(s0)
    8000840c:	e799                	bnez	a5,8000841a <sys_mknod+0x8a>
    end_op();
    8000840e:	ffffe097          	auipc	ra,0xffffe
    80008412:	e44080e7          	jalr	-444(ra) # 80006252 <end_op>
    return -1;
    80008416:	57fd                	li	a5,-1
    80008418:	a821                	j	80008430 <sys_mknod+0xa0>
  }
  iunlockput(ip);
    8000841a:	fe843503          	ld	a0,-24(s0)
    8000841e:	ffffd097          	auipc	ra,0xffffd
    80008422:	f5e080e7          	jalr	-162(ra) # 8000537c <iunlockput>
  end_op();
    80008426:	ffffe097          	auipc	ra,0xffffe
    8000842a:	e2c080e7          	jalr	-468(ra) # 80006252 <end_op>
  return 0;
    8000842e:	4781                	li	a5,0
}
    80008430:	853e                	mv	a0,a5
    80008432:	60ea                	ld	ra,152(sp)
    80008434:	644a                	ld	s0,144(sp)
    80008436:	610d                	addi	sp,sp,160
    80008438:	8082                	ret

000000008000843a <sys_chdir>:

uint64
sys_chdir(void)
{
    8000843a:	7135                	addi	sp,sp,-160
    8000843c:	ed06                	sd	ra,152(sp)
    8000843e:	e922                	sd	s0,144(sp)
    80008440:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80008442:	ffffa097          	auipc	ra,0xffffa
    80008446:	47a080e7          	jalr	1146(ra) # 800028bc <myproc>
    8000844a:	fea43423          	sd	a0,-24(s0)
  
  begin_op();
    8000844e:	ffffe097          	auipc	ra,0xffffe
    80008452:	d42080e7          	jalr	-702(ra) # 80006190 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80008456:	f6040793          	addi	a5,s0,-160
    8000845a:	08000613          	li	a2,128
    8000845e:	85be                	mv	a1,a5
    80008460:	4501                	li	a0,0
    80008462:	ffffc097          	auipc	ra,0xffffc
    80008466:	dae080e7          	jalr	-594(ra) # 80004210 <argstr>
    8000846a:	87aa                	mv	a5,a0
    8000846c:	0007ce63          	bltz	a5,80008488 <sys_chdir+0x4e>
    80008470:	f6040793          	addi	a5,s0,-160
    80008474:	853e                	mv	a0,a5
    80008476:	ffffe097          	auipc	ra,0xffffe
    8000847a:	9ca080e7          	jalr	-1590(ra) # 80005e40 <namei>
    8000847e:	fea43023          	sd	a0,-32(s0)
    80008482:	fe043783          	ld	a5,-32(s0)
    80008486:	e799                	bnez	a5,80008494 <sys_chdir+0x5a>
    end_op();
    80008488:	ffffe097          	auipc	ra,0xffffe
    8000848c:	dca080e7          	jalr	-566(ra) # 80006252 <end_op>
    return -1;
    80008490:	57fd                	li	a5,-1
    80008492:	a0a5                	j	800084fa <sys_chdir+0xc0>
  }
  ilock(ip);
    80008494:	fe043503          	ld	a0,-32(s0)
    80008498:	ffffd097          	auipc	ra,0xffffd
    8000849c:	c88080e7          	jalr	-888(ra) # 80005120 <ilock>
  if(ip->type != T_DIR){
    800084a0:	fe043783          	ld	a5,-32(s0)
    800084a4:	04479703          	lh	a4,68(a5)
    800084a8:	4785                	li	a5,1
    800084aa:	00f70e63          	beq	a4,a5,800084c6 <sys_chdir+0x8c>
    iunlockput(ip);
    800084ae:	fe043503          	ld	a0,-32(s0)
    800084b2:	ffffd097          	auipc	ra,0xffffd
    800084b6:	eca080e7          	jalr	-310(ra) # 8000537c <iunlockput>
    end_op();
    800084ba:	ffffe097          	auipc	ra,0xffffe
    800084be:	d98080e7          	jalr	-616(ra) # 80006252 <end_op>
    return -1;
    800084c2:	57fd                	li	a5,-1
    800084c4:	a81d                	j	800084fa <sys_chdir+0xc0>
  }
  iunlock(ip);
    800084c6:	fe043503          	ld	a0,-32(s0)
    800084ca:	ffffd097          	auipc	ra,0xffffd
    800084ce:	d8a080e7          	jalr	-630(ra) # 80005254 <iunlock>
  iput(p->cwd);
    800084d2:	fe843783          	ld	a5,-24(s0)
    800084d6:	1507b783          	ld	a5,336(a5)
    800084da:	853e                	mv	a0,a5
    800084dc:	ffffd097          	auipc	ra,0xffffd
    800084e0:	dd2080e7          	jalr	-558(ra) # 800052ae <iput>
  end_op();
    800084e4:	ffffe097          	auipc	ra,0xffffe
    800084e8:	d6e080e7          	jalr	-658(ra) # 80006252 <end_op>
  p->cwd = ip;
    800084ec:	fe843783          	ld	a5,-24(s0)
    800084f0:	fe043703          	ld	a4,-32(s0)
    800084f4:	14e7b823          	sd	a4,336(a5)
  return 0;
    800084f8:	4781                	li	a5,0
}
    800084fa:	853e                	mv	a0,a5
    800084fc:	60ea                	ld	ra,152(sp)
    800084fe:	644a                	ld	s0,144(sp)
    80008500:	610d                	addi	sp,sp,160
    80008502:	8082                	ret

0000000080008504 <sys_exec>:

uint64
sys_exec(void)
{
    80008504:	7161                	addi	sp,sp,-432
    80008506:	f706                	sd	ra,424(sp)
    80008508:	f322                	sd	s0,416(sp)
    8000850a:	1b00                	addi	s0,sp,432
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000850c:	e6040793          	addi	a5,s0,-416
    80008510:	85be                	mv	a1,a5
    80008512:	4505                	li	a0,1
    80008514:	ffffc097          	auipc	ra,0xffffc
    80008518:	cca080e7          	jalr	-822(ra) # 800041de <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000851c:	f6840793          	addi	a5,s0,-152
    80008520:	08000613          	li	a2,128
    80008524:	85be                	mv	a1,a5
    80008526:	4501                	li	a0,0
    80008528:	ffffc097          	auipc	ra,0xffffc
    8000852c:	ce8080e7          	jalr	-792(ra) # 80004210 <argstr>
    80008530:	87aa                	mv	a5,a0
    80008532:	0007d463          	bgez	a5,8000853a <sys_exec+0x36>
    return -1;
    80008536:	57fd                	li	a5,-1
    80008538:	a2bd                	j	800086a6 <sys_exec+0x1a2>
  }
  memset(argv, 0, sizeof(argv));
    8000853a:	e6840793          	addi	a5,s0,-408
    8000853e:	10000613          	li	a2,256
    80008542:	4581                	li	a1,0
    80008544:	853e                	mv	a0,a5
    80008546:	ffff9097          	auipc	ra,0xffff9
    8000854a:	f52080e7          	jalr	-174(ra) # 80001498 <memset>
  for(i=0;; i++){
    8000854e:	fe042623          	sw	zero,-20(s0)
    if(i >= NELEM(argv)){
    80008552:	fec42703          	lw	a4,-20(s0)
    80008556:	47fd                	li	a5,31
    80008558:	0ee7ee63          	bltu	a5,a4,80008654 <sys_exec+0x150>
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000855c:	fec42783          	lw	a5,-20(s0)
    80008560:	00379713          	slli	a4,a5,0x3
    80008564:	e6043783          	ld	a5,-416(s0)
    80008568:	97ba                	add	a5,a5,a4
    8000856a:	e5840713          	addi	a4,s0,-424
    8000856e:	85ba                	mv	a1,a4
    80008570:	853e                	mv	a0,a5
    80008572:	ffffc097          	auipc	ra,0xffffc
    80008576:	ac4080e7          	jalr	-1340(ra) # 80004036 <fetchaddr>
    8000857a:	87aa                	mv	a5,a0
    8000857c:	0c07ce63          	bltz	a5,80008658 <sys_exec+0x154>
      goto bad;
    }
    if(uarg == 0){
    80008580:	e5843783          	ld	a5,-424(s0)
    80008584:	eb95                	bnez	a5,800085b8 <sys_exec+0xb4>
      argv[i] = 0;
    80008586:	fec42703          	lw	a4,-20(s0)
    8000858a:	e6840793          	addi	a5,s0,-408
    8000858e:	070e                	slli	a4,a4,0x3
    80008590:	97ba                	add	a5,a5,a4
    80008592:	0007b023          	sd	zero,0(a5)
      break;
    80008596:	0001                	nop
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
      goto bad;
  }

  int ret = exec(path, argv);
    80008598:	e6840713          	addi	a4,s0,-408
    8000859c:	f6840793          	addi	a5,s0,-152
    800085a0:	85ba                	mv	a1,a4
    800085a2:	853e                	mv	a0,a5
    800085a4:	fffff097          	auipc	ra,0xfffff
    800085a8:	c54080e7          	jalr	-940(ra) # 800071f8 <exec>
    800085ac:	87aa                	mv	a5,a0
    800085ae:	fef42423          	sw	a5,-24(s0)

  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800085b2:	fe042623          	sw	zero,-20(s0)
    800085b6:	a8bd                	j	80008634 <sys_exec+0x130>
    argv[i] = kalloc();
    800085b8:	ffff9097          	auipc	ra,0xffff9
    800085bc:	bac080e7          	jalr	-1108(ra) # 80001164 <kalloc>
    800085c0:	86aa                	mv	a3,a0
    800085c2:	fec42703          	lw	a4,-20(s0)
    800085c6:	e6840793          	addi	a5,s0,-408
    800085ca:	070e                	slli	a4,a4,0x3
    800085cc:	97ba                	add	a5,a5,a4
    800085ce:	e394                	sd	a3,0(a5)
    if(argv[i] == 0)
    800085d0:	fec42703          	lw	a4,-20(s0)
    800085d4:	e6840793          	addi	a5,s0,-408
    800085d8:	070e                	slli	a4,a4,0x3
    800085da:	97ba                	add	a5,a5,a4
    800085dc:	639c                	ld	a5,0(a5)
    800085de:	cfbd                	beqz	a5,8000865c <sys_exec+0x158>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800085e0:	e5843683          	ld	a3,-424(s0)
    800085e4:	fec42703          	lw	a4,-20(s0)
    800085e8:	e6840793          	addi	a5,s0,-408
    800085ec:	070e                	slli	a4,a4,0x3
    800085ee:	97ba                	add	a5,a5,a4
    800085f0:	639c                	ld	a5,0(a5)
    800085f2:	6605                	lui	a2,0x1
    800085f4:	85be                	mv	a1,a5
    800085f6:	8536                	mv	a0,a3
    800085f8:	ffffc097          	auipc	ra,0xffffc
    800085fc:	aac080e7          	jalr	-1364(ra) # 800040a4 <fetchstr>
    80008600:	87aa                	mv	a5,a0
    80008602:	0407cf63          	bltz	a5,80008660 <sys_exec+0x15c>
  for(i=0;; i++){
    80008606:	fec42783          	lw	a5,-20(s0)
    8000860a:	2785                	addiw	a5,a5,1
    8000860c:	fef42623          	sw	a5,-20(s0)
    if(i >= NELEM(argv)){
    80008610:	b789                	j	80008552 <sys_exec+0x4e>
    kfree(argv[i]);
    80008612:	fec42703          	lw	a4,-20(s0)
    80008616:	e6840793          	addi	a5,s0,-408
    8000861a:	070e                	slli	a4,a4,0x3
    8000861c:	97ba                	add	a5,a5,a4
    8000861e:	639c                	ld	a5,0(a5)
    80008620:	853e                	mv	a0,a5
    80008622:	ffff9097          	auipc	ra,0xffff9
    80008626:	a9e080e7          	jalr	-1378(ra) # 800010c0 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000862a:	fec42783          	lw	a5,-20(s0)
    8000862e:	2785                	addiw	a5,a5,1
    80008630:	fef42623          	sw	a5,-20(s0)
    80008634:	fec42703          	lw	a4,-20(s0)
    80008638:	47fd                	li	a5,31
    8000863a:	00e7ea63          	bltu	a5,a4,8000864e <sys_exec+0x14a>
    8000863e:	fec42703          	lw	a4,-20(s0)
    80008642:	e6840793          	addi	a5,s0,-408
    80008646:	070e                	slli	a4,a4,0x3
    80008648:	97ba                	add	a5,a5,a4
    8000864a:	639c                	ld	a5,0(a5)
    8000864c:	f3f9                	bnez	a5,80008612 <sys_exec+0x10e>

  return ret;
    8000864e:	fe842783          	lw	a5,-24(s0)
    80008652:	a891                	j	800086a6 <sys_exec+0x1a2>
      goto bad;
    80008654:	0001                	nop
    80008656:	a031                	j	80008662 <sys_exec+0x15e>
      goto bad;
    80008658:	0001                	nop
    8000865a:	a021                	j	80008662 <sys_exec+0x15e>
      goto bad;
    8000865c:	0001                	nop
    8000865e:	a011                	j	80008662 <sys_exec+0x15e>
      goto bad;
    80008660:	0001                	nop

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80008662:	fe042623          	sw	zero,-20(s0)
    80008666:	a015                	j	8000868a <sys_exec+0x186>
    kfree(argv[i]);
    80008668:	fec42703          	lw	a4,-20(s0)
    8000866c:	e6840793          	addi	a5,s0,-408
    80008670:	070e                	slli	a4,a4,0x3
    80008672:	97ba                	add	a5,a5,a4
    80008674:	639c                	ld	a5,0(a5)
    80008676:	853e                	mv	a0,a5
    80008678:	ffff9097          	auipc	ra,0xffff9
    8000867c:	a48080e7          	jalr	-1464(ra) # 800010c0 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80008680:	fec42783          	lw	a5,-20(s0)
    80008684:	2785                	addiw	a5,a5,1
    80008686:	fef42623          	sw	a5,-20(s0)
    8000868a:	fec42703          	lw	a4,-20(s0)
    8000868e:	47fd                	li	a5,31
    80008690:	00e7ea63          	bltu	a5,a4,800086a4 <sys_exec+0x1a0>
    80008694:	fec42703          	lw	a4,-20(s0)
    80008698:	e6840793          	addi	a5,s0,-408
    8000869c:	070e                	slli	a4,a4,0x3
    8000869e:	97ba                	add	a5,a5,a4
    800086a0:	639c                	ld	a5,0(a5)
    800086a2:	f3f9                	bnez	a5,80008668 <sys_exec+0x164>
  return -1;
    800086a4:	57fd                	li	a5,-1
}
    800086a6:	853e                	mv	a0,a5
    800086a8:	70ba                	ld	ra,424(sp)
    800086aa:	741a                	ld	s0,416(sp)
    800086ac:	615d                	addi	sp,sp,432
    800086ae:	8082                	ret

00000000800086b0 <sys_pipe>:

uint64
sys_pipe(void)
{
    800086b0:	7139                	addi	sp,sp,-64
    800086b2:	fc06                	sd	ra,56(sp)
    800086b4:	f822                	sd	s0,48(sp)
    800086b6:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800086b8:	ffffa097          	auipc	ra,0xffffa
    800086bc:	204080e7          	jalr	516(ra) # 800028bc <myproc>
    800086c0:	fea43423          	sd	a0,-24(s0)

  argaddr(0, &fdarray);
    800086c4:	fe040793          	addi	a5,s0,-32
    800086c8:	85be                	mv	a1,a5
    800086ca:	4501                	li	a0,0
    800086cc:	ffffc097          	auipc	ra,0xffffc
    800086d0:	b12080e7          	jalr	-1262(ra) # 800041de <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800086d4:	fd040713          	addi	a4,s0,-48
    800086d8:	fd840793          	addi	a5,s0,-40
    800086dc:	85ba                	mv	a1,a4
    800086de:	853e                	mv	a0,a5
    800086e0:	ffffe097          	auipc	ra,0xffffe
    800086e4:	632080e7          	jalr	1586(ra) # 80006d12 <pipealloc>
    800086e8:	87aa                	mv	a5,a0
    800086ea:	0007d463          	bgez	a5,800086f2 <sys_pipe+0x42>
    return -1;
    800086ee:	57fd                	li	a5,-1
    800086f0:	a219                	j	800087f6 <sys_pipe+0x146>
  fd0 = -1;
    800086f2:	57fd                	li	a5,-1
    800086f4:	fcf42623          	sw	a5,-52(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800086f8:	fd843783          	ld	a5,-40(s0)
    800086fc:	853e                	mv	a0,a5
    800086fe:	fffff097          	auipc	ra,0xfffff
    80008702:	11e080e7          	jalr	286(ra) # 8000781c <fdalloc>
    80008706:	87aa                	mv	a5,a0
    80008708:	fcf42623          	sw	a5,-52(s0)
    8000870c:	fcc42783          	lw	a5,-52(s0)
    80008710:	0207c063          	bltz	a5,80008730 <sys_pipe+0x80>
    80008714:	fd043783          	ld	a5,-48(s0)
    80008718:	853e                	mv	a0,a5
    8000871a:	fffff097          	auipc	ra,0xfffff
    8000871e:	102080e7          	jalr	258(ra) # 8000781c <fdalloc>
    80008722:	87aa                	mv	a5,a0
    80008724:	fcf42423          	sw	a5,-56(s0)
    80008728:	fc842783          	lw	a5,-56(s0)
    8000872c:	0207df63          	bgez	a5,8000876a <sys_pipe+0xba>
    if(fd0 >= 0)
    80008730:	fcc42783          	lw	a5,-52(s0)
    80008734:	0007cb63          	bltz	a5,8000874a <sys_pipe+0x9a>
      p->ofile[fd0] = 0;
    80008738:	fcc42783          	lw	a5,-52(s0)
    8000873c:	fe843703          	ld	a4,-24(s0)
    80008740:	07e9                	addi	a5,a5,26
    80008742:	078e                	slli	a5,a5,0x3
    80008744:	97ba                	add	a5,a5,a4
    80008746:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000874a:	fd843783          	ld	a5,-40(s0)
    8000874e:	853e                	mv	a0,a5
    80008750:	ffffe097          	auipc	ra,0xffffe
    80008754:	0ca080e7          	jalr	202(ra) # 8000681a <fileclose>
    fileclose(wf);
    80008758:	fd043783          	ld	a5,-48(s0)
    8000875c:	853e                	mv	a0,a5
    8000875e:	ffffe097          	auipc	ra,0xffffe
    80008762:	0bc080e7          	jalr	188(ra) # 8000681a <fileclose>
    return -1;
    80008766:	57fd                	li	a5,-1
    80008768:	a079                	j	800087f6 <sys_pipe+0x146>
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000876a:	fe843783          	ld	a5,-24(s0)
    8000876e:	6bbc                	ld	a5,80(a5)
    80008770:	fe043703          	ld	a4,-32(s0)
    80008774:	fcc40613          	addi	a2,s0,-52
    80008778:	4691                	li	a3,4
    8000877a:	85ba                	mv	a1,a4
    8000877c:	853e                	mv	a0,a5
    8000877e:	ffffa097          	auipc	ra,0xffffa
    80008782:	bfc080e7          	jalr	-1028(ra) # 8000237a <copyout>
    80008786:	87aa                	mv	a5,a0
    80008788:	0207c463          	bltz	a5,800087b0 <sys_pipe+0x100>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000878c:	fe843783          	ld	a5,-24(s0)
    80008790:	6bb8                	ld	a4,80(a5)
    80008792:	fe043783          	ld	a5,-32(s0)
    80008796:	0791                	addi	a5,a5,4
    80008798:	fc840613          	addi	a2,s0,-56
    8000879c:	4691                	li	a3,4
    8000879e:	85be                	mv	a1,a5
    800087a0:	853a                	mv	a0,a4
    800087a2:	ffffa097          	auipc	ra,0xffffa
    800087a6:	bd8080e7          	jalr	-1064(ra) # 8000237a <copyout>
    800087aa:	87aa                	mv	a5,a0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800087ac:	0407d463          	bgez	a5,800087f4 <sys_pipe+0x144>
    p->ofile[fd0] = 0;
    800087b0:	fcc42783          	lw	a5,-52(s0)
    800087b4:	fe843703          	ld	a4,-24(s0)
    800087b8:	07e9                	addi	a5,a5,26
    800087ba:	078e                	slli	a5,a5,0x3
    800087bc:	97ba                	add	a5,a5,a4
    800087be:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800087c2:	fc842783          	lw	a5,-56(s0)
    800087c6:	fe843703          	ld	a4,-24(s0)
    800087ca:	07e9                	addi	a5,a5,26
    800087cc:	078e                	slli	a5,a5,0x3
    800087ce:	97ba                	add	a5,a5,a4
    800087d0:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800087d4:	fd843783          	ld	a5,-40(s0)
    800087d8:	853e                	mv	a0,a5
    800087da:	ffffe097          	auipc	ra,0xffffe
    800087de:	040080e7          	jalr	64(ra) # 8000681a <fileclose>
    fileclose(wf);
    800087e2:	fd043783          	ld	a5,-48(s0)
    800087e6:	853e                	mv	a0,a5
    800087e8:	ffffe097          	auipc	ra,0xffffe
    800087ec:	032080e7          	jalr	50(ra) # 8000681a <fileclose>
    return -1;
    800087f0:	57fd                	li	a5,-1
    800087f2:	a011                	j	800087f6 <sys_pipe+0x146>
  }
  return 0;
    800087f4:	4781                	li	a5,0
}
    800087f6:	853e                	mv	a0,a5
    800087f8:	70e2                	ld	ra,56(sp)
    800087fa:	7442                	ld	s0,48(sp)
    800087fc:	6121                	addi	sp,sp,64
    800087fe:	8082                	ret

0000000080008800 <kernelvec>:
    80008800:	7111                	addi	sp,sp,-256
    80008802:	e006                	sd	ra,0(sp)
    80008804:	e40a                	sd	sp,8(sp)
    80008806:	e80e                	sd	gp,16(sp)
    80008808:	ec12                	sd	tp,24(sp)
    8000880a:	f016                	sd	t0,32(sp)
    8000880c:	f41a                	sd	t1,40(sp)
    8000880e:	f81e                	sd	t2,48(sp)
    80008810:	fc22                	sd	s0,56(sp)
    80008812:	e0a6                	sd	s1,64(sp)
    80008814:	e4aa                	sd	a0,72(sp)
    80008816:	e8ae                	sd	a1,80(sp)
    80008818:	ecb2                	sd	a2,88(sp)
    8000881a:	f0b6                	sd	a3,96(sp)
    8000881c:	f4ba                	sd	a4,104(sp)
    8000881e:	f8be                	sd	a5,112(sp)
    80008820:	fcc2                	sd	a6,120(sp)
    80008822:	e146                	sd	a7,128(sp)
    80008824:	e54a                	sd	s2,136(sp)
    80008826:	e94e                	sd	s3,144(sp)
    80008828:	ed52                	sd	s4,152(sp)
    8000882a:	f156                	sd	s5,160(sp)
    8000882c:	f55a                	sd	s6,168(sp)
    8000882e:	f95e                	sd	s7,176(sp)
    80008830:	fd62                	sd	s8,184(sp)
    80008832:	e1e6                	sd	s9,192(sp)
    80008834:	e5ea                	sd	s10,200(sp)
    80008836:	e9ee                	sd	s11,208(sp)
    80008838:	edf2                	sd	t3,216(sp)
    8000883a:	f1f6                	sd	t4,224(sp)
    8000883c:	f5fa                	sd	t5,232(sp)
    8000883e:	f9fe                	sd	t6,240(sp)
    80008840:	d90fb0ef          	jal	80003dd0 <kerneltrap>
    80008844:	6082                	ld	ra,0(sp)
    80008846:	6122                	ld	sp,8(sp)
    80008848:	61c2                	ld	gp,16(sp)
    8000884a:	7282                	ld	t0,32(sp)
    8000884c:	7322                	ld	t1,40(sp)
    8000884e:	73c2                	ld	t2,48(sp)
    80008850:	7462                	ld	s0,56(sp)
    80008852:	6486                	ld	s1,64(sp)
    80008854:	6526                	ld	a0,72(sp)
    80008856:	65c6                	ld	a1,80(sp)
    80008858:	6666                	ld	a2,88(sp)
    8000885a:	7686                	ld	a3,96(sp)
    8000885c:	7726                	ld	a4,104(sp)
    8000885e:	77c6                	ld	a5,112(sp)
    80008860:	7866                	ld	a6,120(sp)
    80008862:	688a                	ld	a7,128(sp)
    80008864:	692a                	ld	s2,136(sp)
    80008866:	69ca                	ld	s3,144(sp)
    80008868:	6a6a                	ld	s4,152(sp)
    8000886a:	7a8a                	ld	s5,160(sp)
    8000886c:	7b2a                	ld	s6,168(sp)
    8000886e:	7bca                	ld	s7,176(sp)
    80008870:	7c6a                	ld	s8,184(sp)
    80008872:	6c8e                	ld	s9,192(sp)
    80008874:	6d2e                	ld	s10,200(sp)
    80008876:	6dce                	ld	s11,208(sp)
    80008878:	6e6e                	ld	t3,216(sp)
    8000887a:	7e8e                	ld	t4,224(sp)
    8000887c:	7f2e                	ld	t5,232(sp)
    8000887e:	7fce                	ld	t6,240(sp)
    80008880:	6111                	addi	sp,sp,256
    80008882:	10200073          	sret
    80008886:	00000013          	nop
    8000888a:	00000013          	nop
    8000888e:	0001                	nop

0000000080008890 <timervec>:
    80008890:	34051573          	csrrw	a0,mscratch,a0
    80008894:	e10c                	sd	a1,0(a0)
    80008896:	e510                	sd	a2,8(a0)
    80008898:	e914                	sd	a3,16(a0)
    8000889a:	6d0c                	ld	a1,24(a0)
    8000889c:	7110                	ld	a2,32(a0)
    8000889e:	6194                	ld	a3,0(a1)
    800088a0:	96b2                	add	a3,a3,a2
    800088a2:	e194                	sd	a3,0(a1)
    800088a4:	4589                	li	a1,2
    800088a6:	14459073          	csrw	sip,a1
    800088aa:	6914                	ld	a3,16(a0)
    800088ac:	6510                	ld	a2,8(a0)
    800088ae:	610c                	ld	a1,0(a0)
    800088b0:	34051573          	csrrw	a0,mscratch,a0
    800088b4:	30200073          	mret
	...

00000000800088ba <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800088ba:	1141                	addi	sp,sp,-16
    800088bc:	e406                	sd	ra,8(sp)
    800088be:	e022                	sd	s0,0(sp)
    800088c0:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800088c2:	0c0007b7          	lui	a5,0xc000
    800088c6:	02878793          	addi	a5,a5,40 # c000028 <_entry-0x73ffffd8>
    800088ca:	4705                	li	a4,1
    800088cc:	c398                	sw	a4,0(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800088ce:	0c0007b7          	lui	a5,0xc000
    800088d2:	0791                	addi	a5,a5,4 # c000004 <_entry-0x73fffffc>
    800088d4:	4705                	li	a4,1
    800088d6:	c398                	sw	a4,0(a5)
}
    800088d8:	0001                	nop
    800088da:	60a2                	ld	ra,8(sp)
    800088dc:	6402                	ld	s0,0(sp)
    800088de:	0141                	addi	sp,sp,16
    800088e0:	8082                	ret

00000000800088e2 <plicinithart>:

void
plicinithart(void)
{
    800088e2:	1101                	addi	sp,sp,-32
    800088e4:	ec06                	sd	ra,24(sp)
    800088e6:	e822                	sd	s0,16(sp)
    800088e8:	1000                	addi	s0,sp,32
  int hart = cpuid();
    800088ea:	ffffa097          	auipc	ra,0xffffa
    800088ee:	f74080e7          	jalr	-140(ra) # 8000285e <cpuid>
    800088f2:	87aa                	mv	a5,a0
    800088f4:	fef42623          	sw	a5,-20(s0)
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800088f8:	fec42783          	lw	a5,-20(s0)
    800088fc:	0087979b          	slliw	a5,a5,0x8
    80008900:	2781                	sext.w	a5,a5
    80008902:	873e                	mv	a4,a5
    80008904:	0c0027b7          	lui	a5,0xc002
    80008908:	08078793          	addi	a5,a5,128 # c002080 <_entry-0x73ffdf80>
    8000890c:	97ba                	add	a5,a5,a4
    8000890e:	873e                	mv	a4,a5
    80008910:	40200793          	li	a5,1026
    80008914:	c31c                	sw	a5,0(a4)

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80008916:	fec42783          	lw	a5,-20(s0)
    8000891a:	00d7979b          	slliw	a5,a5,0xd
    8000891e:	2781                	sext.w	a5,a5
    80008920:	873e                	mv	a4,a5
    80008922:	0c2017b7          	lui	a5,0xc201
    80008926:	97ba                	add	a5,a5,a4
    80008928:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    8000892c:	0001                	nop
    8000892e:	60e2                	ld	ra,24(sp)
    80008930:	6442                	ld	s0,16(sp)
    80008932:	6105                	addi	sp,sp,32
    80008934:	8082                	ret

0000000080008936 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80008936:	1101                	addi	sp,sp,-32
    80008938:	ec06                	sd	ra,24(sp)
    8000893a:	e822                	sd	s0,16(sp)
    8000893c:	1000                	addi	s0,sp,32
  int hart = cpuid();
    8000893e:	ffffa097          	auipc	ra,0xffffa
    80008942:	f20080e7          	jalr	-224(ra) # 8000285e <cpuid>
    80008946:	87aa                	mv	a5,a0
    80008948:	fef42623          	sw	a5,-20(s0)
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000894c:	fec42783          	lw	a5,-20(s0)
    80008950:	00d7979b          	slliw	a5,a5,0xd
    80008954:	2781                	sext.w	a5,a5
    80008956:	873e                	mv	a4,a5
    80008958:	0c2017b7          	lui	a5,0xc201
    8000895c:	0791                	addi	a5,a5,4 # c201004 <_entry-0x73dfeffc>
    8000895e:	97ba                	add	a5,a5,a4
    80008960:	439c                	lw	a5,0(a5)
    80008962:	fef42423          	sw	a5,-24(s0)
  return irq;
    80008966:	fe842783          	lw	a5,-24(s0)
}
    8000896a:	853e                	mv	a0,a5
    8000896c:	60e2                	ld	ra,24(sp)
    8000896e:	6442                	ld	s0,16(sp)
    80008970:	6105                	addi	sp,sp,32
    80008972:	8082                	ret

0000000080008974 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80008974:	7179                	addi	sp,sp,-48
    80008976:	f406                	sd	ra,40(sp)
    80008978:	f022                	sd	s0,32(sp)
    8000897a:	1800                	addi	s0,sp,48
    8000897c:	87aa                	mv	a5,a0
    8000897e:	fcf42e23          	sw	a5,-36(s0)
  int hart = cpuid();
    80008982:	ffffa097          	auipc	ra,0xffffa
    80008986:	edc080e7          	jalr	-292(ra) # 8000285e <cpuid>
    8000898a:	87aa                	mv	a5,a0
    8000898c:	fef42623          	sw	a5,-20(s0)
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80008990:	fec42783          	lw	a5,-20(s0)
    80008994:	00d7979b          	slliw	a5,a5,0xd
    80008998:	2781                	sext.w	a5,a5
    8000899a:	873e                	mv	a4,a5
    8000899c:	0c2017b7          	lui	a5,0xc201
    800089a0:	0791                	addi	a5,a5,4 # c201004 <_entry-0x73dfeffc>
    800089a2:	97ba                	add	a5,a5,a4
    800089a4:	873e                	mv	a4,a5
    800089a6:	fdc42783          	lw	a5,-36(s0)
    800089aa:	c31c                	sw	a5,0(a4)
}
    800089ac:	0001                	nop
    800089ae:	70a2                	ld	ra,40(sp)
    800089b0:	7402                	ld	s0,32(sp)
    800089b2:	6145                	addi	sp,sp,48
    800089b4:	8082                	ret

00000000800089b6 <virtio_disk_init>:
  
} disk;

void
virtio_disk_init(void)
{
    800089b6:	7179                	addi	sp,sp,-48
    800089b8:	f406                	sd	ra,40(sp)
    800089ba:	f022                	sd	s0,32(sp)
    800089bc:	1800                	addi	s0,sp,48
  uint32 status = 0;
    800089be:	fe042423          	sw	zero,-24(s0)

  initlock(&disk.vdisk_lock, "virtio_disk");
    800089c2:	00003597          	auipc	a1,0x3
    800089c6:	ca658593          	addi	a1,a1,-858 # 8000b668 <etext+0x668>
    800089ca:	0001c517          	auipc	a0,0x1c
    800089ce:	38650513          	addi	a0,a0,902 # 80024d50 <disk+0x128>
    800089d2:	ffff9097          	auipc	ra,0xffff9
    800089d6:	8be080e7          	jalr	-1858(ra) # 80001290 <initlock>

  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800089da:	100017b7          	lui	a5,0x10001
    800089de:	439c                	lw	a5,0(a5)
    800089e0:	0007871b          	sext.w	a4,a5
    800089e4:	747277b7          	lui	a5,0x74727
    800089e8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800089ec:	04f71063          	bne	a4,a5,80008a2c <virtio_disk_init+0x76>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800089f0:	100017b7          	lui	a5,0x10001
    800089f4:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800089f6:	439c                	lw	a5,0(a5)
    800089f8:	0007871b          	sext.w	a4,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800089fc:	4789                	li	a5,2
    800089fe:	02f71763          	bne	a4,a5,80008a2c <virtio_disk_init+0x76>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80008a02:	100017b7          	lui	a5,0x10001
    80008a06:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80008a08:	439c                	lw	a5,0(a5)
    80008a0a:	0007871b          	sext.w	a4,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80008a0e:	4789                	li	a5,2
    80008a10:	00f71e63          	bne	a4,a5,80008a2c <virtio_disk_init+0x76>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80008a14:	100017b7          	lui	a5,0x10001
    80008a18:	07b1                	addi	a5,a5,12 # 1000100c <_entry-0x6fffeff4>
    80008a1a:	439c                	lw	a5,0(a5)
    80008a1c:	0007871b          	sext.w	a4,a5
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80008a20:	554d47b7          	lui	a5,0x554d4
    80008a24:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80008a28:	00f70a63          	beq	a4,a5,80008a3c <virtio_disk_init+0x86>
    panic("could not find virtio disk");
    80008a2c:	00003517          	auipc	a0,0x3
    80008a30:	c4c50513          	addi	a0,a0,-948 # 8000b678 <etext+0x678>
    80008a34:	ffff8097          	auipc	ra,0xffff8
    80008a38:	28c080e7          	jalr	652(ra) # 80000cc0 <panic>
  }
  
  // reset device
  *R(VIRTIO_MMIO_STATUS) = status;
    80008a3c:	100017b7          	lui	a5,0x10001
    80008a40:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x6fffef90>
    80008a44:	fe842703          	lw	a4,-24(s0)
    80008a48:	c398                	sw	a4,0(a5)

  // set ACKNOWLEDGE status bit
  status |= VIRTIO_CONFIG_S_ACKNOWLEDGE;
    80008a4a:	fe842783          	lw	a5,-24(s0)
    80008a4e:	0017e793          	ori	a5,a5,1
    80008a52:	fef42423          	sw	a5,-24(s0)
  *R(VIRTIO_MMIO_STATUS) = status;
    80008a56:	100017b7          	lui	a5,0x10001
    80008a5a:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x6fffef90>
    80008a5e:	fe842703          	lw	a4,-24(s0)
    80008a62:	c398                	sw	a4,0(a5)

  // set DRIVER status bit
  status |= VIRTIO_CONFIG_S_DRIVER;
    80008a64:	fe842783          	lw	a5,-24(s0)
    80008a68:	0027e793          	ori	a5,a5,2
    80008a6c:	fef42423          	sw	a5,-24(s0)
  *R(VIRTIO_MMIO_STATUS) = status;
    80008a70:	100017b7          	lui	a5,0x10001
    80008a74:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x6fffef90>
    80008a78:	fe842703          	lw	a4,-24(s0)
    80008a7c:	c398                	sw	a4,0(a5)

  // negotiate features
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80008a7e:	100017b7          	lui	a5,0x10001
    80008a82:	07c1                	addi	a5,a5,16 # 10001010 <_entry-0x6fffeff0>
    80008a84:	439c                	lw	a5,0(a5)
    80008a86:	2781                	sext.w	a5,a5
    80008a88:	1782                	slli	a5,a5,0x20
    80008a8a:	9381                	srli	a5,a5,0x20
    80008a8c:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_BLK_F_RO);
    80008a90:	fe043783          	ld	a5,-32(s0)
    80008a94:	fdf7f793          	andi	a5,a5,-33
    80008a98:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_BLK_F_SCSI);
    80008a9c:	fe043783          	ld	a5,-32(s0)
    80008aa0:	f7f7f793          	andi	a5,a5,-129
    80008aa4:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_BLK_F_CONFIG_WCE);
    80008aa8:	fe043703          	ld	a4,-32(s0)
    80008aac:	77fd                	lui	a5,0xfffff
    80008aae:	7ff78793          	addi	a5,a5,2047 # fffffffffffff7ff <end+0xffffffff7ffdaa97>
    80008ab2:	8ff9                	and	a5,a5,a4
    80008ab4:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_BLK_F_MQ);
    80008ab8:	fe043703          	ld	a4,-32(s0)
    80008abc:	77fd                	lui	a5,0xfffff
    80008abe:	17fd                	addi	a5,a5,-1 # ffffffffffffefff <end+0xffffffff7ffda297>
    80008ac0:	8ff9                	and	a5,a5,a4
    80008ac2:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_F_ANY_LAYOUT);
    80008ac6:	fe043703          	ld	a4,-32(s0)
    80008aca:	f80007b7          	lui	a5,0xf8000
    80008ace:	17fd                	addi	a5,a5,-1 # fffffffff7ffffff <end+0xffffffff77fdb297>
    80008ad0:	8ff9                	and	a5,a5,a4
    80008ad2:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_RING_F_EVENT_IDX);
    80008ad6:	fe043703          	ld	a4,-32(s0)
    80008ada:	e00007b7          	lui	a5,0xe0000
    80008ade:	17fd                	addi	a5,a5,-1 # ffffffffdfffffff <end+0xffffffff5ffdb297>
    80008ae0:	8ff9                	and	a5,a5,a4
    80008ae2:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80008ae6:	fe043703          	ld	a4,-32(s0)
    80008aea:	f00007b7          	lui	a5,0xf0000
    80008aee:	17fd                	addi	a5,a5,-1 # ffffffffefffffff <end+0xffffffff6ffdb297>
    80008af0:	8ff9                	and	a5,a5,a4
    80008af2:	fef43023          	sd	a5,-32(s0)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80008af6:	100017b7          	lui	a5,0x10001
    80008afa:	02078793          	addi	a5,a5,32 # 10001020 <_entry-0x6fffefe0>
    80008afe:	fe043703          	ld	a4,-32(s0)
    80008b02:	2701                	sext.w	a4,a4
    80008b04:	c398                	sw	a4,0(a5)

  // tell device that feature negotiation is complete.
  status |= VIRTIO_CONFIG_S_FEATURES_OK;
    80008b06:	fe842783          	lw	a5,-24(s0)
    80008b0a:	0087e793          	ori	a5,a5,8
    80008b0e:	fef42423          	sw	a5,-24(s0)
  *R(VIRTIO_MMIO_STATUS) = status;
    80008b12:	100017b7          	lui	a5,0x10001
    80008b16:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x6fffef90>
    80008b1a:	fe842703          	lw	a4,-24(s0)
    80008b1e:	c398                	sw	a4,0(a5)

  // re-read status to ensure FEATURES_OK is set.
  status = *R(VIRTIO_MMIO_STATUS);
    80008b20:	100017b7          	lui	a5,0x10001
    80008b24:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x6fffef90>
    80008b28:	439c                	lw	a5,0(a5)
    80008b2a:	fef42423          	sw	a5,-24(s0)
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80008b2e:	fe842783          	lw	a5,-24(s0)
    80008b32:	8ba1                	andi	a5,a5,8
    80008b34:	2781                	sext.w	a5,a5
    80008b36:	eb89                	bnez	a5,80008b48 <virtio_disk_init+0x192>
    panic("virtio disk FEATURES_OK unset");
    80008b38:	00003517          	auipc	a0,0x3
    80008b3c:	b6050513          	addi	a0,a0,-1184 # 8000b698 <etext+0x698>
    80008b40:	ffff8097          	auipc	ra,0xffff8
    80008b44:	180080e7          	jalr	384(ra) # 80000cc0 <panic>

  // initialize queue 0.
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80008b48:	100017b7          	lui	a5,0x10001
    80008b4c:	03078793          	addi	a5,a5,48 # 10001030 <_entry-0x6fffefd0>
    80008b50:	0007a023          	sw	zero,0(a5)

  // ensure queue 0 is not in use.
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80008b54:	100017b7          	lui	a5,0x10001
    80008b58:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80008b5c:	439c                	lw	a5,0(a5)
    80008b5e:	2781                	sext.w	a5,a5
    80008b60:	cb89                	beqz	a5,80008b72 <virtio_disk_init+0x1bc>
    panic("virtio disk should not be ready");
    80008b62:	00003517          	auipc	a0,0x3
    80008b66:	b5650513          	addi	a0,a0,-1194 # 8000b6b8 <etext+0x6b8>
    80008b6a:	ffff8097          	auipc	ra,0xffff8
    80008b6e:	156080e7          	jalr	342(ra) # 80000cc0 <panic>

  // check maximum queue size.
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80008b72:	100017b7          	lui	a5,0x10001
    80008b76:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80008b7a:	439c                	lw	a5,0(a5)
    80008b7c:	fcf42e23          	sw	a5,-36(s0)
  if(max == 0)
    80008b80:	fdc42783          	lw	a5,-36(s0)
    80008b84:	2781                	sext.w	a5,a5
    80008b86:	eb89                	bnez	a5,80008b98 <virtio_disk_init+0x1e2>
    panic("virtio disk has no queue 0");
    80008b88:	00003517          	auipc	a0,0x3
    80008b8c:	b5050513          	addi	a0,a0,-1200 # 8000b6d8 <etext+0x6d8>
    80008b90:	ffff8097          	auipc	ra,0xffff8
    80008b94:	130080e7          	jalr	304(ra) # 80000cc0 <panic>
  if(max < NUM)
    80008b98:	fdc42783          	lw	a5,-36(s0)
    80008b9c:	0007871b          	sext.w	a4,a5
    80008ba0:	479d                	li	a5,7
    80008ba2:	00e7ea63          	bltu	a5,a4,80008bb6 <virtio_disk_init+0x200>
    panic("virtio disk max queue too short");
    80008ba6:	00003517          	auipc	a0,0x3
    80008baa:	b5250513          	addi	a0,a0,-1198 # 8000b6f8 <etext+0x6f8>
    80008bae:	ffff8097          	auipc	ra,0xffff8
    80008bb2:	112080e7          	jalr	274(ra) # 80000cc0 <panic>

  // allocate and zero queue memory.
  disk.desc = kalloc();
    80008bb6:	ffff8097          	auipc	ra,0xffff8
    80008bba:	5ae080e7          	jalr	1454(ra) # 80001164 <kalloc>
    80008bbe:	872a                	mv	a4,a0
    80008bc0:	0001c797          	auipc	a5,0x1c
    80008bc4:	06878793          	addi	a5,a5,104 # 80024c28 <disk>
    80008bc8:	e398                	sd	a4,0(a5)
  disk.avail = kalloc();
    80008bca:	ffff8097          	auipc	ra,0xffff8
    80008bce:	59a080e7          	jalr	1434(ra) # 80001164 <kalloc>
    80008bd2:	872a                	mv	a4,a0
    80008bd4:	0001c797          	auipc	a5,0x1c
    80008bd8:	05478793          	addi	a5,a5,84 # 80024c28 <disk>
    80008bdc:	e798                	sd	a4,8(a5)
  disk.used = kalloc();
    80008bde:	ffff8097          	auipc	ra,0xffff8
    80008be2:	586080e7          	jalr	1414(ra) # 80001164 <kalloc>
    80008be6:	872a                	mv	a4,a0
    80008be8:	0001c797          	auipc	a5,0x1c
    80008bec:	04078793          	addi	a5,a5,64 # 80024c28 <disk>
    80008bf0:	eb98                	sd	a4,16(a5)
  if(!disk.desc || !disk.avail || !disk.used)
    80008bf2:	0001c797          	auipc	a5,0x1c
    80008bf6:	03678793          	addi	a5,a5,54 # 80024c28 <disk>
    80008bfa:	639c                	ld	a5,0(a5)
    80008bfc:	cf89                	beqz	a5,80008c16 <virtio_disk_init+0x260>
    80008bfe:	0001c797          	auipc	a5,0x1c
    80008c02:	02a78793          	addi	a5,a5,42 # 80024c28 <disk>
    80008c06:	679c                	ld	a5,8(a5)
    80008c08:	c799                	beqz	a5,80008c16 <virtio_disk_init+0x260>
    80008c0a:	0001c797          	auipc	a5,0x1c
    80008c0e:	01e78793          	addi	a5,a5,30 # 80024c28 <disk>
    80008c12:	6b9c                	ld	a5,16(a5)
    80008c14:	eb89                	bnez	a5,80008c26 <virtio_disk_init+0x270>
    panic("virtio disk kalloc");
    80008c16:	00003517          	auipc	a0,0x3
    80008c1a:	b0250513          	addi	a0,a0,-1278 # 8000b718 <etext+0x718>
    80008c1e:	ffff8097          	auipc	ra,0xffff8
    80008c22:	0a2080e7          	jalr	162(ra) # 80000cc0 <panic>
  memset(disk.desc, 0, PGSIZE);
    80008c26:	0001c797          	auipc	a5,0x1c
    80008c2a:	00278793          	addi	a5,a5,2 # 80024c28 <disk>
    80008c2e:	639c                	ld	a5,0(a5)
    80008c30:	6605                	lui	a2,0x1
    80008c32:	4581                	li	a1,0
    80008c34:	853e                	mv	a0,a5
    80008c36:	ffff9097          	auipc	ra,0xffff9
    80008c3a:	862080e7          	jalr	-1950(ra) # 80001498 <memset>
  memset(disk.avail, 0, PGSIZE);
    80008c3e:	0001c797          	auipc	a5,0x1c
    80008c42:	fea78793          	addi	a5,a5,-22 # 80024c28 <disk>
    80008c46:	679c                	ld	a5,8(a5)
    80008c48:	6605                	lui	a2,0x1
    80008c4a:	4581                	li	a1,0
    80008c4c:	853e                	mv	a0,a5
    80008c4e:	ffff9097          	auipc	ra,0xffff9
    80008c52:	84a080e7          	jalr	-1974(ra) # 80001498 <memset>
  memset(disk.used, 0, PGSIZE);
    80008c56:	0001c797          	auipc	a5,0x1c
    80008c5a:	fd278793          	addi	a5,a5,-46 # 80024c28 <disk>
    80008c5e:	6b9c                	ld	a5,16(a5)
    80008c60:	6605                	lui	a2,0x1
    80008c62:	4581                	li	a1,0
    80008c64:	853e                	mv	a0,a5
    80008c66:	ffff9097          	auipc	ra,0xffff9
    80008c6a:	832080e7          	jalr	-1998(ra) # 80001498 <memset>

  // set queue size.
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80008c6e:	100017b7          	lui	a5,0x10001
    80008c72:	03878793          	addi	a5,a5,56 # 10001038 <_entry-0x6fffefc8>
    80008c76:	4721                	li	a4,8
    80008c78:	c398                	sw	a4,0(a5)

  // write physical addresses.
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80008c7a:	0001c797          	auipc	a5,0x1c
    80008c7e:	fae78793          	addi	a5,a5,-82 # 80024c28 <disk>
    80008c82:	639c                	ld	a5,0(a5)
    80008c84:	873e                	mv	a4,a5
    80008c86:	100017b7          	lui	a5,0x10001
    80008c8a:	08078793          	addi	a5,a5,128 # 10001080 <_entry-0x6fffef80>
    80008c8e:	2701                	sext.w	a4,a4
    80008c90:	c398                	sw	a4,0(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80008c92:	0001c797          	auipc	a5,0x1c
    80008c96:	f9678793          	addi	a5,a5,-106 # 80024c28 <disk>
    80008c9a:	639c                	ld	a5,0(a5)
    80008c9c:	0207d713          	srli	a4,a5,0x20
    80008ca0:	100017b7          	lui	a5,0x10001
    80008ca4:	08478793          	addi	a5,a5,132 # 10001084 <_entry-0x6fffef7c>
    80008ca8:	2701                	sext.w	a4,a4
    80008caa:	c398                	sw	a4,0(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80008cac:	0001c797          	auipc	a5,0x1c
    80008cb0:	f7c78793          	addi	a5,a5,-132 # 80024c28 <disk>
    80008cb4:	679c                	ld	a5,8(a5)
    80008cb6:	873e                	mv	a4,a5
    80008cb8:	100017b7          	lui	a5,0x10001
    80008cbc:	09078793          	addi	a5,a5,144 # 10001090 <_entry-0x6fffef70>
    80008cc0:	2701                	sext.w	a4,a4
    80008cc2:	c398                	sw	a4,0(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80008cc4:	0001c797          	auipc	a5,0x1c
    80008cc8:	f6478793          	addi	a5,a5,-156 # 80024c28 <disk>
    80008ccc:	679c                	ld	a5,8(a5)
    80008cce:	0207d713          	srli	a4,a5,0x20
    80008cd2:	100017b7          	lui	a5,0x10001
    80008cd6:	09478793          	addi	a5,a5,148 # 10001094 <_entry-0x6fffef6c>
    80008cda:	2701                	sext.w	a4,a4
    80008cdc:	c398                	sw	a4,0(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80008cde:	0001c797          	auipc	a5,0x1c
    80008ce2:	f4a78793          	addi	a5,a5,-182 # 80024c28 <disk>
    80008ce6:	6b9c                	ld	a5,16(a5)
    80008ce8:	873e                	mv	a4,a5
    80008cea:	100017b7          	lui	a5,0x10001
    80008cee:	0a078793          	addi	a5,a5,160 # 100010a0 <_entry-0x6fffef60>
    80008cf2:	2701                	sext.w	a4,a4
    80008cf4:	c398                	sw	a4,0(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80008cf6:	0001c797          	auipc	a5,0x1c
    80008cfa:	f3278793          	addi	a5,a5,-206 # 80024c28 <disk>
    80008cfe:	6b9c                	ld	a5,16(a5)
    80008d00:	0207d713          	srli	a4,a5,0x20
    80008d04:	100017b7          	lui	a5,0x10001
    80008d08:	0a478793          	addi	a5,a5,164 # 100010a4 <_entry-0x6fffef5c>
    80008d0c:	2701                	sext.w	a4,a4
    80008d0e:	c398                	sw	a4,0(a5)

  // queue is ready.
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80008d10:	100017b7          	lui	a5,0x10001
    80008d14:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80008d18:	4705                	li	a4,1
    80008d1a:	c398                	sw	a4,0(a5)

  // all NUM descriptors start out unused.
  for(int i = 0; i < NUM; i++)
    80008d1c:	fe042623          	sw	zero,-20(s0)
    80008d20:	a005                	j	80008d40 <virtio_disk_init+0x38a>
    disk.free[i] = 1;
    80008d22:	0001c717          	auipc	a4,0x1c
    80008d26:	f0670713          	addi	a4,a4,-250 # 80024c28 <disk>
    80008d2a:	fec42783          	lw	a5,-20(s0)
    80008d2e:	97ba                	add	a5,a5,a4
    80008d30:	4705                	li	a4,1
    80008d32:	00e78c23          	sb	a4,24(a5)
  for(int i = 0; i < NUM; i++)
    80008d36:	fec42783          	lw	a5,-20(s0)
    80008d3a:	2785                	addiw	a5,a5,1
    80008d3c:	fef42623          	sw	a5,-20(s0)
    80008d40:	fec42783          	lw	a5,-20(s0)
    80008d44:	0007871b          	sext.w	a4,a5
    80008d48:	479d                	li	a5,7
    80008d4a:	fce7dce3          	bge	a5,a4,80008d22 <virtio_disk_init+0x36c>

  // tell device we're completely ready.
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80008d4e:	fe842783          	lw	a5,-24(s0)
    80008d52:	0047e793          	ori	a5,a5,4
    80008d56:	fef42423          	sw	a5,-24(s0)
  *R(VIRTIO_MMIO_STATUS) = status;
    80008d5a:	100017b7          	lui	a5,0x10001
    80008d5e:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x6fffef90>
    80008d62:	fe842703          	lw	a4,-24(s0)
    80008d66:	c398                	sw	a4,0(a5)

  // plic.c and trap.c arrange for interrupts from VIRTIO0_IRQ.
}
    80008d68:	0001                	nop
    80008d6a:	70a2                	ld	ra,40(sp)
    80008d6c:	7402                	ld	s0,32(sp)
    80008d6e:	6145                	addi	sp,sp,48
    80008d70:	8082                	ret

0000000080008d72 <alloc_desc>:

// find a free descriptor, mark it non-free, return its index.
static int
alloc_desc()
{
    80008d72:	1101                	addi	sp,sp,-32
    80008d74:	ec06                	sd	ra,24(sp)
    80008d76:	e822                	sd	s0,16(sp)
    80008d78:	1000                	addi	s0,sp,32
  for(int i = 0; i < NUM; i++){
    80008d7a:	fe042623          	sw	zero,-20(s0)
    80008d7e:	a825                	j	80008db6 <alloc_desc+0x44>
    if(disk.free[i]){
    80008d80:	0001c717          	auipc	a4,0x1c
    80008d84:	ea870713          	addi	a4,a4,-344 # 80024c28 <disk>
    80008d88:	fec42783          	lw	a5,-20(s0)
    80008d8c:	97ba                	add	a5,a5,a4
    80008d8e:	0187c783          	lbu	a5,24(a5)
    80008d92:	cf89                	beqz	a5,80008dac <alloc_desc+0x3a>
      disk.free[i] = 0;
    80008d94:	0001c717          	auipc	a4,0x1c
    80008d98:	e9470713          	addi	a4,a4,-364 # 80024c28 <disk>
    80008d9c:	fec42783          	lw	a5,-20(s0)
    80008da0:	97ba                	add	a5,a5,a4
    80008da2:	00078c23          	sb	zero,24(a5)
      return i;
    80008da6:	fec42783          	lw	a5,-20(s0)
    80008daa:	a831                	j	80008dc6 <alloc_desc+0x54>
  for(int i = 0; i < NUM; i++){
    80008dac:	fec42783          	lw	a5,-20(s0)
    80008db0:	2785                	addiw	a5,a5,1
    80008db2:	fef42623          	sw	a5,-20(s0)
    80008db6:	fec42783          	lw	a5,-20(s0)
    80008dba:	0007871b          	sext.w	a4,a5
    80008dbe:	479d                	li	a5,7
    80008dc0:	fce7d0e3          	bge	a5,a4,80008d80 <alloc_desc+0xe>
    }
  }
  return -1;
    80008dc4:	57fd                	li	a5,-1
}
    80008dc6:	853e                	mv	a0,a5
    80008dc8:	60e2                	ld	ra,24(sp)
    80008dca:	6442                	ld	s0,16(sp)
    80008dcc:	6105                	addi	sp,sp,32
    80008dce:	8082                	ret

0000000080008dd0 <free_desc>:

// mark a descriptor as free.
static void
free_desc(int i)
{
    80008dd0:	1101                	addi	sp,sp,-32
    80008dd2:	ec06                	sd	ra,24(sp)
    80008dd4:	e822                	sd	s0,16(sp)
    80008dd6:	1000                	addi	s0,sp,32
    80008dd8:	87aa                	mv	a5,a0
    80008dda:	fef42623          	sw	a5,-20(s0)
  if(i >= NUM)
    80008dde:	fec42783          	lw	a5,-20(s0)
    80008de2:	0007871b          	sext.w	a4,a5
    80008de6:	479d                	li	a5,7
    80008de8:	00e7da63          	bge	a5,a4,80008dfc <free_desc+0x2c>
    panic("free_desc 1");
    80008dec:	00003517          	auipc	a0,0x3
    80008df0:	94450513          	addi	a0,a0,-1724 # 8000b730 <etext+0x730>
    80008df4:	ffff8097          	auipc	ra,0xffff8
    80008df8:	ecc080e7          	jalr	-308(ra) # 80000cc0 <panic>
  if(disk.free[i])
    80008dfc:	0001c717          	auipc	a4,0x1c
    80008e00:	e2c70713          	addi	a4,a4,-468 # 80024c28 <disk>
    80008e04:	fec42783          	lw	a5,-20(s0)
    80008e08:	97ba                	add	a5,a5,a4
    80008e0a:	0187c783          	lbu	a5,24(a5)
    80008e0e:	cb89                	beqz	a5,80008e20 <free_desc+0x50>
    panic("free_desc 2");
    80008e10:	00003517          	auipc	a0,0x3
    80008e14:	93050513          	addi	a0,a0,-1744 # 8000b740 <etext+0x740>
    80008e18:	ffff8097          	auipc	ra,0xffff8
    80008e1c:	ea8080e7          	jalr	-344(ra) # 80000cc0 <panic>
  disk.desc[i].addr = 0;
    80008e20:	0001c797          	auipc	a5,0x1c
    80008e24:	e0878793          	addi	a5,a5,-504 # 80024c28 <disk>
    80008e28:	6398                	ld	a4,0(a5)
    80008e2a:	fec42783          	lw	a5,-20(s0)
    80008e2e:	0792                	slli	a5,a5,0x4
    80008e30:	97ba                	add	a5,a5,a4
    80008e32:	0007b023          	sd	zero,0(a5)
  disk.desc[i].len = 0;
    80008e36:	0001c797          	auipc	a5,0x1c
    80008e3a:	df278793          	addi	a5,a5,-526 # 80024c28 <disk>
    80008e3e:	6398                	ld	a4,0(a5)
    80008e40:	fec42783          	lw	a5,-20(s0)
    80008e44:	0792                	slli	a5,a5,0x4
    80008e46:	97ba                	add	a5,a5,a4
    80008e48:	0007a423          	sw	zero,8(a5)
  disk.desc[i].flags = 0;
    80008e4c:	0001c797          	auipc	a5,0x1c
    80008e50:	ddc78793          	addi	a5,a5,-548 # 80024c28 <disk>
    80008e54:	6398                	ld	a4,0(a5)
    80008e56:	fec42783          	lw	a5,-20(s0)
    80008e5a:	0792                	slli	a5,a5,0x4
    80008e5c:	97ba                	add	a5,a5,a4
    80008e5e:	00079623          	sh	zero,12(a5)
  disk.desc[i].next = 0;
    80008e62:	0001c797          	auipc	a5,0x1c
    80008e66:	dc678793          	addi	a5,a5,-570 # 80024c28 <disk>
    80008e6a:	6398                	ld	a4,0(a5)
    80008e6c:	fec42783          	lw	a5,-20(s0)
    80008e70:	0792                	slli	a5,a5,0x4
    80008e72:	97ba                	add	a5,a5,a4
    80008e74:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80008e78:	0001c717          	auipc	a4,0x1c
    80008e7c:	db070713          	addi	a4,a4,-592 # 80024c28 <disk>
    80008e80:	fec42783          	lw	a5,-20(s0)
    80008e84:	97ba                	add	a5,a5,a4
    80008e86:	4705                	li	a4,1
    80008e88:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80008e8c:	0001c517          	auipc	a0,0x1c
    80008e90:	db450513          	addi	a0,a0,-588 # 80024c40 <disk+0x18>
    80008e94:	ffffa097          	auipc	ra,0xffffa
    80008e98:	65e080e7          	jalr	1630(ra) # 800034f2 <wakeup>
}
    80008e9c:	0001                	nop
    80008e9e:	60e2                	ld	ra,24(sp)
    80008ea0:	6442                	ld	s0,16(sp)
    80008ea2:	6105                	addi	sp,sp,32
    80008ea4:	8082                	ret

0000000080008ea6 <free_chain>:

// free a chain of descriptors.
static void
free_chain(int i)
{
    80008ea6:	7179                	addi	sp,sp,-48
    80008ea8:	f406                	sd	ra,40(sp)
    80008eaa:	f022                	sd	s0,32(sp)
    80008eac:	1800                	addi	s0,sp,48
    80008eae:	87aa                	mv	a5,a0
    80008eb0:	fcf42e23          	sw	a5,-36(s0)
  while(1){
    int flag = disk.desc[i].flags;
    80008eb4:	0001c797          	auipc	a5,0x1c
    80008eb8:	d7478793          	addi	a5,a5,-652 # 80024c28 <disk>
    80008ebc:	6398                	ld	a4,0(a5)
    80008ebe:	fdc42783          	lw	a5,-36(s0)
    80008ec2:	0792                	slli	a5,a5,0x4
    80008ec4:	97ba                	add	a5,a5,a4
    80008ec6:	00c7d783          	lhu	a5,12(a5)
    80008eca:	fef42623          	sw	a5,-20(s0)
    int nxt = disk.desc[i].next;
    80008ece:	0001c797          	auipc	a5,0x1c
    80008ed2:	d5a78793          	addi	a5,a5,-678 # 80024c28 <disk>
    80008ed6:	6398                	ld	a4,0(a5)
    80008ed8:	fdc42783          	lw	a5,-36(s0)
    80008edc:	0792                	slli	a5,a5,0x4
    80008ede:	97ba                	add	a5,a5,a4
    80008ee0:	00e7d783          	lhu	a5,14(a5)
    80008ee4:	fef42423          	sw	a5,-24(s0)
    free_desc(i);
    80008ee8:	fdc42783          	lw	a5,-36(s0)
    80008eec:	853e                	mv	a0,a5
    80008eee:	00000097          	auipc	ra,0x0
    80008ef2:	ee2080e7          	jalr	-286(ra) # 80008dd0 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80008ef6:	fec42783          	lw	a5,-20(s0)
    80008efa:	8b85                	andi	a5,a5,1
    80008efc:	2781                	sext.w	a5,a5
    80008efe:	c791                	beqz	a5,80008f0a <free_chain+0x64>
      i = nxt;
    80008f00:	fe842783          	lw	a5,-24(s0)
    80008f04:	fcf42e23          	sw	a5,-36(s0)
  while(1){
    80008f08:	b775                	j	80008eb4 <free_chain+0xe>
    else
      break;
    80008f0a:	0001                	nop
  }
}
    80008f0c:	0001                	nop
    80008f0e:	70a2                	ld	ra,40(sp)
    80008f10:	7402                	ld	s0,32(sp)
    80008f12:	6145                	addi	sp,sp,48
    80008f14:	8082                	ret

0000000080008f16 <alloc3_desc>:

// allocate three descriptors (they need not be contiguous).
// disk transfers always use three descriptors.
static int
alloc3_desc(int *idx)
{
    80008f16:	7139                	addi	sp,sp,-64
    80008f18:	fc06                	sd	ra,56(sp)
    80008f1a:	f822                	sd	s0,48(sp)
    80008f1c:	f426                	sd	s1,40(sp)
    80008f1e:	0080                	addi	s0,sp,64
    80008f20:	fca43423          	sd	a0,-56(s0)
  for(int i = 0; i < 3; i++){
    80008f24:	fc042e23          	sw	zero,-36(s0)
    80008f28:	a89d                	j	80008f9e <alloc3_desc+0x88>
    idx[i] = alloc_desc();
    80008f2a:	fdc42783          	lw	a5,-36(s0)
    80008f2e:	078a                	slli	a5,a5,0x2
    80008f30:	fc843703          	ld	a4,-56(s0)
    80008f34:	00f704b3          	add	s1,a4,a5
    80008f38:	00000097          	auipc	ra,0x0
    80008f3c:	e3a080e7          	jalr	-454(ra) # 80008d72 <alloc_desc>
    80008f40:	87aa                	mv	a5,a0
    80008f42:	c09c                	sw	a5,0(s1)
    if(idx[i] < 0){
    80008f44:	fdc42783          	lw	a5,-36(s0)
    80008f48:	078a                	slli	a5,a5,0x2
    80008f4a:	fc843703          	ld	a4,-56(s0)
    80008f4e:	97ba                	add	a5,a5,a4
    80008f50:	439c                	lw	a5,0(a5)
    80008f52:	0407d163          	bgez	a5,80008f94 <alloc3_desc+0x7e>
      for(int j = 0; j < i; j++)
    80008f56:	fc042c23          	sw	zero,-40(s0)
    80008f5a:	a015                	j	80008f7e <alloc3_desc+0x68>
        free_desc(idx[j]);
    80008f5c:	fd842783          	lw	a5,-40(s0)
    80008f60:	078a                	slli	a5,a5,0x2
    80008f62:	fc843703          	ld	a4,-56(s0)
    80008f66:	97ba                	add	a5,a5,a4
    80008f68:	439c                	lw	a5,0(a5)
    80008f6a:	853e                	mv	a0,a5
    80008f6c:	00000097          	auipc	ra,0x0
    80008f70:	e64080e7          	jalr	-412(ra) # 80008dd0 <free_desc>
      for(int j = 0; j < i; j++)
    80008f74:	fd842783          	lw	a5,-40(s0)
    80008f78:	2785                	addiw	a5,a5,1
    80008f7a:	fcf42c23          	sw	a5,-40(s0)
    80008f7e:	fd842783          	lw	a5,-40(s0)
    80008f82:	873e                	mv	a4,a5
    80008f84:	fdc42783          	lw	a5,-36(s0)
    80008f88:	2701                	sext.w	a4,a4
    80008f8a:	2781                	sext.w	a5,a5
    80008f8c:	fcf748e3          	blt	a4,a5,80008f5c <alloc3_desc+0x46>
      return -1;
    80008f90:	57fd                	li	a5,-1
    80008f92:	a831                	j	80008fae <alloc3_desc+0x98>
  for(int i = 0; i < 3; i++){
    80008f94:	fdc42783          	lw	a5,-36(s0)
    80008f98:	2785                	addiw	a5,a5,1
    80008f9a:	fcf42e23          	sw	a5,-36(s0)
    80008f9e:	fdc42783          	lw	a5,-36(s0)
    80008fa2:	0007871b          	sext.w	a4,a5
    80008fa6:	4789                	li	a5,2
    80008fa8:	f8e7d1e3          	bge	a5,a4,80008f2a <alloc3_desc+0x14>
    }
  }
  return 0;
    80008fac:	4781                	li	a5,0
}
    80008fae:	853e                	mv	a0,a5
    80008fb0:	70e2                	ld	ra,56(sp)
    80008fb2:	7442                	ld	s0,48(sp)
    80008fb4:	74a2                	ld	s1,40(sp)
    80008fb6:	6121                	addi	sp,sp,64
    80008fb8:	8082                	ret

0000000080008fba <virtio_disk_rw>:

void
virtio_disk_rw(struct buf *b, int write)
{
    80008fba:	7139                	addi	sp,sp,-64
    80008fbc:	fc06                	sd	ra,56(sp)
    80008fbe:	f822                	sd	s0,48(sp)
    80008fc0:	0080                	addi	s0,sp,64
    80008fc2:	fca43423          	sd	a0,-56(s0)
    80008fc6:	87ae                	mv	a5,a1
    80008fc8:	fcf42223          	sw	a5,-60(s0)
  uint64 sector = b->blockno * (BSIZE / 512);
    80008fcc:	fc843783          	ld	a5,-56(s0)
    80008fd0:	47dc                	lw	a5,12(a5)
    80008fd2:	0017979b          	slliw	a5,a5,0x1
    80008fd6:	2781                	sext.w	a5,a5
    80008fd8:	1782                	slli	a5,a5,0x20
    80008fda:	9381                	srli	a5,a5,0x20
    80008fdc:	fef43423          	sd	a5,-24(s0)

  acquire(&disk.vdisk_lock);
    80008fe0:	0001c517          	auipc	a0,0x1c
    80008fe4:	d7050513          	addi	a0,a0,-656 # 80024d50 <disk+0x128>
    80008fe8:	ffff8097          	auipc	ra,0xffff8
    80008fec:	2dc080e7          	jalr	732(ra) # 800012c4 <acquire>
  // data, one for a 1-byte status result.

  // allocate the three descriptors.
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
    80008ff0:	fd040793          	addi	a5,s0,-48
    80008ff4:	853e                	mv	a0,a5
    80008ff6:	00000097          	auipc	ra,0x0
    80008ffa:	f20080e7          	jalr	-224(ra) # 80008f16 <alloc3_desc>
    80008ffe:	87aa                	mv	a5,a0
    80009000:	cf91                	beqz	a5,8000901c <virtio_disk_rw+0x62>
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80009002:	0001c597          	auipc	a1,0x1c
    80009006:	d4e58593          	addi	a1,a1,-690 # 80024d50 <disk+0x128>
    8000900a:	0001c517          	auipc	a0,0x1c
    8000900e:	c3650513          	addi	a0,a0,-970 # 80024c40 <disk+0x18>
    80009012:	ffffa097          	auipc	ra,0xffffa
    80009016:	464080e7          	jalr	1124(ra) # 80003476 <sleep>
    if(alloc3_desc(idx) == 0) {
    8000901a:	bfd9                	j	80008ff0 <virtio_disk_rw+0x36>
      break;
    8000901c:	0001                	nop
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000901e:	fd042783          	lw	a5,-48(s0)
    80009022:	07a9                	addi	a5,a5,10
    80009024:	00479713          	slli	a4,a5,0x4
    80009028:	0001c797          	auipc	a5,0x1c
    8000902c:	c0078793          	addi	a5,a5,-1024 # 80024c28 <disk>
    80009030:	97ba                	add	a5,a5,a4
    80009032:	07a1                	addi	a5,a5,8
    80009034:	fef43023          	sd	a5,-32(s0)

  if(write)
    80009038:	fc442783          	lw	a5,-60(s0)
    8000903c:	2781                	sext.w	a5,a5
    8000903e:	c791                	beqz	a5,8000904a <virtio_disk_rw+0x90>
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80009040:	fe043783          	ld	a5,-32(s0)
    80009044:	4705                	li	a4,1
    80009046:	c398                	sw	a4,0(a5)
    80009048:	a029                	j	80009052 <virtio_disk_rw+0x98>
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    8000904a:	fe043783          	ld	a5,-32(s0)
    8000904e:	0007a023          	sw	zero,0(a5)
  buf0->reserved = 0;
    80009052:	fe043783          	ld	a5,-32(s0)
    80009056:	0007a223          	sw	zero,4(a5)
  buf0->sector = sector;
    8000905a:	fe043783          	ld	a5,-32(s0)
    8000905e:	fe843703          	ld	a4,-24(s0)
    80009062:	e798                	sd	a4,8(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80009064:	0001c797          	auipc	a5,0x1c
    80009068:	bc478793          	addi	a5,a5,-1084 # 80024c28 <disk>
    8000906c:	6398                	ld	a4,0(a5)
    8000906e:	fd042783          	lw	a5,-48(s0)
    80009072:	0792                	slli	a5,a5,0x4
    80009074:	97ba                	add	a5,a5,a4
    80009076:	fe043703          	ld	a4,-32(s0)
    8000907a:	e398                	sd	a4,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000907c:	0001c797          	auipc	a5,0x1c
    80009080:	bac78793          	addi	a5,a5,-1108 # 80024c28 <disk>
    80009084:	6398                	ld	a4,0(a5)
    80009086:	fd042783          	lw	a5,-48(s0)
    8000908a:	0792                	slli	a5,a5,0x4
    8000908c:	97ba                	add	a5,a5,a4
    8000908e:	4741                	li	a4,16
    80009090:	c798                	sw	a4,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80009092:	0001c797          	auipc	a5,0x1c
    80009096:	b9678793          	addi	a5,a5,-1130 # 80024c28 <disk>
    8000909a:	6398                	ld	a4,0(a5)
    8000909c:	fd042783          	lw	a5,-48(s0)
    800090a0:	0792                	slli	a5,a5,0x4
    800090a2:	97ba                	add	a5,a5,a4
    800090a4:	4705                	li	a4,1
    800090a6:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[0]].next = idx[1];
    800090aa:	fd442683          	lw	a3,-44(s0)
    800090ae:	0001c797          	auipc	a5,0x1c
    800090b2:	b7a78793          	addi	a5,a5,-1158 # 80024c28 <disk>
    800090b6:	6398                	ld	a4,0(a5)
    800090b8:	fd042783          	lw	a5,-48(s0)
    800090bc:	0792                	slli	a5,a5,0x4
    800090be:	97ba                	add	a5,a5,a4
    800090c0:	03069713          	slli	a4,a3,0x30
    800090c4:	9341                	srli	a4,a4,0x30
    800090c6:	00e79723          	sh	a4,14(a5)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800090ca:	fc843783          	ld	a5,-56(s0)
    800090ce:	05878693          	addi	a3,a5,88
    800090d2:	0001c797          	auipc	a5,0x1c
    800090d6:	b5678793          	addi	a5,a5,-1194 # 80024c28 <disk>
    800090da:	6398                	ld	a4,0(a5)
    800090dc:	fd442783          	lw	a5,-44(s0)
    800090e0:	0792                	slli	a5,a5,0x4
    800090e2:	97ba                	add	a5,a5,a4
    800090e4:	8736                	mv	a4,a3
    800090e6:	e398                	sd	a4,0(a5)
  disk.desc[idx[1]].len = BSIZE;
    800090e8:	0001c797          	auipc	a5,0x1c
    800090ec:	b4078793          	addi	a5,a5,-1216 # 80024c28 <disk>
    800090f0:	6398                	ld	a4,0(a5)
    800090f2:	fd442783          	lw	a5,-44(s0)
    800090f6:	0792                	slli	a5,a5,0x4
    800090f8:	97ba                	add	a5,a5,a4
    800090fa:	40000713          	li	a4,1024
    800090fe:	c798                	sw	a4,8(a5)
  if(write)
    80009100:	fc442783          	lw	a5,-60(s0)
    80009104:	2781                	sext.w	a5,a5
    80009106:	cf89                	beqz	a5,80009120 <virtio_disk_rw+0x166>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80009108:	0001c797          	auipc	a5,0x1c
    8000910c:	b2078793          	addi	a5,a5,-1248 # 80024c28 <disk>
    80009110:	6398                	ld	a4,0(a5)
    80009112:	fd442783          	lw	a5,-44(s0)
    80009116:	0792                	slli	a5,a5,0x4
    80009118:	97ba                	add	a5,a5,a4
    8000911a:	00079623          	sh	zero,12(a5)
    8000911e:	a829                	j	80009138 <virtio_disk_rw+0x17e>
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80009120:	0001c797          	auipc	a5,0x1c
    80009124:	b0878793          	addi	a5,a5,-1272 # 80024c28 <disk>
    80009128:	6398                	ld	a4,0(a5)
    8000912a:	fd442783          	lw	a5,-44(s0)
    8000912e:	0792                	slli	a5,a5,0x4
    80009130:	97ba                	add	a5,a5,a4
    80009132:	4709                	li	a4,2
    80009134:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80009138:	0001c797          	auipc	a5,0x1c
    8000913c:	af078793          	addi	a5,a5,-1296 # 80024c28 <disk>
    80009140:	6398                	ld	a4,0(a5)
    80009142:	fd442783          	lw	a5,-44(s0)
    80009146:	0792                	slli	a5,a5,0x4
    80009148:	97ba                	add	a5,a5,a4
    8000914a:	00c7d703          	lhu	a4,12(a5)
    8000914e:	0001c797          	auipc	a5,0x1c
    80009152:	ada78793          	addi	a5,a5,-1318 # 80024c28 <disk>
    80009156:	6394                	ld	a3,0(a5)
    80009158:	fd442783          	lw	a5,-44(s0)
    8000915c:	0792                	slli	a5,a5,0x4
    8000915e:	97b6                	add	a5,a5,a3
    80009160:	00176713          	ori	a4,a4,1
    80009164:	1742                	slli	a4,a4,0x30
    80009166:	9341                	srli	a4,a4,0x30
    80009168:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[1]].next = idx[2];
    8000916c:	fd842683          	lw	a3,-40(s0)
    80009170:	0001c797          	auipc	a5,0x1c
    80009174:	ab878793          	addi	a5,a5,-1352 # 80024c28 <disk>
    80009178:	6398                	ld	a4,0(a5)
    8000917a:	fd442783          	lw	a5,-44(s0)
    8000917e:	0792                	slli	a5,a5,0x4
    80009180:	97ba                	add	a5,a5,a4
    80009182:	03069713          	slli	a4,a3,0x30
    80009186:	9341                	srli	a4,a4,0x30
    80009188:	00e79723          	sh	a4,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000918c:	fd042783          	lw	a5,-48(s0)
    80009190:	0001c717          	auipc	a4,0x1c
    80009194:	a9870713          	addi	a4,a4,-1384 # 80024c28 <disk>
    80009198:	0789                	addi	a5,a5,2
    8000919a:	0792                	slli	a5,a5,0x4
    8000919c:	97ba                	add	a5,a5,a4
    8000919e:	577d                	li	a4,-1
    800091a0:	00e78823          	sb	a4,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800091a4:	fd042783          	lw	a5,-48(s0)
    800091a8:	0789                	addi	a5,a5,2
    800091aa:	00479713          	slli	a4,a5,0x4
    800091ae:	0001c797          	auipc	a5,0x1c
    800091b2:	a7a78793          	addi	a5,a5,-1414 # 80024c28 <disk>
    800091b6:	97ba                	add	a5,a5,a4
    800091b8:	01078693          	addi	a3,a5,16
    800091bc:	0001c797          	auipc	a5,0x1c
    800091c0:	a6c78793          	addi	a5,a5,-1428 # 80024c28 <disk>
    800091c4:	6398                	ld	a4,0(a5)
    800091c6:	fd842783          	lw	a5,-40(s0)
    800091ca:	0792                	slli	a5,a5,0x4
    800091cc:	97ba                	add	a5,a5,a4
    800091ce:	8736                	mv	a4,a3
    800091d0:	e398                	sd	a4,0(a5)
  disk.desc[idx[2]].len = 1;
    800091d2:	0001c797          	auipc	a5,0x1c
    800091d6:	a5678793          	addi	a5,a5,-1450 # 80024c28 <disk>
    800091da:	6398                	ld	a4,0(a5)
    800091dc:	fd842783          	lw	a5,-40(s0)
    800091e0:	0792                	slli	a5,a5,0x4
    800091e2:	97ba                	add	a5,a5,a4
    800091e4:	4705                	li	a4,1
    800091e6:	c798                	sw	a4,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800091e8:	0001c797          	auipc	a5,0x1c
    800091ec:	a4078793          	addi	a5,a5,-1472 # 80024c28 <disk>
    800091f0:	6398                	ld	a4,0(a5)
    800091f2:	fd842783          	lw	a5,-40(s0)
    800091f6:	0792                	slli	a5,a5,0x4
    800091f8:	97ba                	add	a5,a5,a4
    800091fa:	4709                	li	a4,2
    800091fc:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[2]].next = 0;
    80009200:	0001c797          	auipc	a5,0x1c
    80009204:	a2878793          	addi	a5,a5,-1496 # 80024c28 <disk>
    80009208:	6398                	ld	a4,0(a5)
    8000920a:	fd842783          	lw	a5,-40(s0)
    8000920e:	0792                	slli	a5,a5,0x4
    80009210:	97ba                	add	a5,a5,a4
    80009212:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80009216:	fc843783          	ld	a5,-56(s0)
    8000921a:	4705                	li	a4,1
    8000921c:	c3d8                	sw	a4,4(a5)
  disk.info[idx[0]].b = b;
    8000921e:	fd042783          	lw	a5,-48(s0)
    80009222:	0001c717          	auipc	a4,0x1c
    80009226:	a0670713          	addi	a4,a4,-1530 # 80024c28 <disk>
    8000922a:	0789                	addi	a5,a5,2
    8000922c:	0792                	slli	a5,a5,0x4
    8000922e:	97ba                	add	a5,a5,a4
    80009230:	fc843703          	ld	a4,-56(s0)
    80009234:	e798                	sd	a4,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80009236:	fd042703          	lw	a4,-48(s0)
    8000923a:	0001c797          	auipc	a5,0x1c
    8000923e:	9ee78793          	addi	a5,a5,-1554 # 80024c28 <disk>
    80009242:	6794                	ld	a3,8(a5)
    80009244:	0001c797          	auipc	a5,0x1c
    80009248:	9e478793          	addi	a5,a5,-1564 # 80024c28 <disk>
    8000924c:	679c                	ld	a5,8(a5)
    8000924e:	0027d783          	lhu	a5,2(a5)
    80009252:	2781                	sext.w	a5,a5
    80009254:	8b9d                	andi	a5,a5,7
    80009256:	2781                	sext.w	a5,a5
    80009258:	1742                	slli	a4,a4,0x30
    8000925a:	9341                	srli	a4,a4,0x30
    8000925c:	0786                	slli	a5,a5,0x1
    8000925e:	97b6                	add	a5,a5,a3
    80009260:	00e79223          	sh	a4,4(a5)

  __sync_synchronize();
    80009264:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80009268:	0001c797          	auipc	a5,0x1c
    8000926c:	9c078793          	addi	a5,a5,-1600 # 80024c28 <disk>
    80009270:	679c                	ld	a5,8(a5)
    80009272:	0027d703          	lhu	a4,2(a5)
    80009276:	0001c797          	auipc	a5,0x1c
    8000927a:	9b278793          	addi	a5,a5,-1614 # 80024c28 <disk>
    8000927e:	679c                	ld	a5,8(a5)
    80009280:	2705                	addiw	a4,a4,1
    80009282:	1742                	slli	a4,a4,0x30
    80009284:	9341                	srli	a4,a4,0x30
    80009286:	00e79123          	sh	a4,2(a5)

  __sync_synchronize();
    8000928a:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000928e:	100017b7          	lui	a5,0x10001
    80009292:	05078793          	addi	a5,a5,80 # 10001050 <_entry-0x6fffefb0>
    80009296:	0007a023          	sw	zero,0(a5)

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000929a:	a819                	j	800092b0 <virtio_disk_rw+0x2f6>
    sleep(b, &disk.vdisk_lock);
    8000929c:	0001c597          	auipc	a1,0x1c
    800092a0:	ab458593          	addi	a1,a1,-1356 # 80024d50 <disk+0x128>
    800092a4:	fc843503          	ld	a0,-56(s0)
    800092a8:	ffffa097          	auipc	ra,0xffffa
    800092ac:	1ce080e7          	jalr	462(ra) # 80003476 <sleep>
  while(b->disk == 1) {
    800092b0:	fc843783          	ld	a5,-56(s0)
    800092b4:	43d8                	lw	a4,4(a5)
    800092b6:	4785                	li	a5,1
    800092b8:	fef702e3          	beq	a4,a5,8000929c <virtio_disk_rw+0x2e2>
  }

  disk.info[idx[0]].b = 0;
    800092bc:	fd042783          	lw	a5,-48(s0)
    800092c0:	0001c717          	auipc	a4,0x1c
    800092c4:	96870713          	addi	a4,a4,-1688 # 80024c28 <disk>
    800092c8:	0789                	addi	a5,a5,2
    800092ca:	0792                	slli	a5,a5,0x4
    800092cc:	97ba                	add	a5,a5,a4
    800092ce:	0007b423          	sd	zero,8(a5)
  free_chain(idx[0]);
    800092d2:	fd042783          	lw	a5,-48(s0)
    800092d6:	853e                	mv	a0,a5
    800092d8:	00000097          	auipc	ra,0x0
    800092dc:	bce080e7          	jalr	-1074(ra) # 80008ea6 <free_chain>

  release(&disk.vdisk_lock);
    800092e0:	0001c517          	auipc	a0,0x1c
    800092e4:	a7050513          	addi	a0,a0,-1424 # 80024d50 <disk+0x128>
    800092e8:	ffff8097          	auipc	ra,0xffff8
    800092ec:	040080e7          	jalr	64(ra) # 80001328 <release>
}
    800092f0:	0001                	nop
    800092f2:	70e2                	ld	ra,56(sp)
    800092f4:	7442                	ld	s0,48(sp)
    800092f6:	6121                	addi	sp,sp,64
    800092f8:	8082                	ret

00000000800092fa <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800092fa:	1101                	addi	sp,sp,-32
    800092fc:	ec06                	sd	ra,24(sp)
    800092fe:	e822                	sd	s0,16(sp)
    80009300:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80009302:	0001c517          	auipc	a0,0x1c
    80009306:	a4e50513          	addi	a0,a0,-1458 # 80024d50 <disk+0x128>
    8000930a:	ffff8097          	auipc	ra,0xffff8
    8000930e:	fba080e7          	jalr	-70(ra) # 800012c4 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80009312:	100017b7          	lui	a5,0x10001
    80009316:	06078793          	addi	a5,a5,96 # 10001060 <_entry-0x6fffefa0>
    8000931a:	439c                	lw	a5,0(a5)
    8000931c:	0007871b          	sext.w	a4,a5
    80009320:	100017b7          	lui	a5,0x10001
    80009324:	06478793          	addi	a5,a5,100 # 10001064 <_entry-0x6fffef9c>
    80009328:	8b0d                	andi	a4,a4,3
    8000932a:	2701                	sext.w	a4,a4
    8000932c:	c398                	sw	a4,0(a5)

  __sync_synchronize();
    8000932e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80009332:	a045                	j	800093d2 <virtio_disk_intr+0xd8>
    __sync_synchronize();
    80009334:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80009338:	0001c797          	auipc	a5,0x1c
    8000933c:	8f078793          	addi	a5,a5,-1808 # 80024c28 <disk>
    80009340:	6b98                	ld	a4,16(a5)
    80009342:	0001c797          	auipc	a5,0x1c
    80009346:	8e678793          	addi	a5,a5,-1818 # 80024c28 <disk>
    8000934a:	0207d783          	lhu	a5,32(a5)
    8000934e:	2781                	sext.w	a5,a5
    80009350:	8b9d                	andi	a5,a5,7
    80009352:	2781                	sext.w	a5,a5
    80009354:	078e                	slli	a5,a5,0x3
    80009356:	97ba                	add	a5,a5,a4
    80009358:	43dc                	lw	a5,4(a5)
    8000935a:	fef42623          	sw	a5,-20(s0)

    if(disk.info[id].status != 0)
    8000935e:	0001c717          	auipc	a4,0x1c
    80009362:	8ca70713          	addi	a4,a4,-1846 # 80024c28 <disk>
    80009366:	fec42783          	lw	a5,-20(s0)
    8000936a:	0789                	addi	a5,a5,2
    8000936c:	0792                	slli	a5,a5,0x4
    8000936e:	97ba                	add	a5,a5,a4
    80009370:	0107c783          	lbu	a5,16(a5)
    80009374:	cb89                	beqz	a5,80009386 <virtio_disk_intr+0x8c>
      panic("virtio_disk_intr status");
    80009376:	00002517          	auipc	a0,0x2
    8000937a:	3da50513          	addi	a0,a0,986 # 8000b750 <etext+0x750>
    8000937e:	ffff8097          	auipc	ra,0xffff8
    80009382:	942080e7          	jalr	-1726(ra) # 80000cc0 <panic>

    struct buf *b = disk.info[id].b;
    80009386:	0001c717          	auipc	a4,0x1c
    8000938a:	8a270713          	addi	a4,a4,-1886 # 80024c28 <disk>
    8000938e:	fec42783          	lw	a5,-20(s0)
    80009392:	0789                	addi	a5,a5,2
    80009394:	0792                	slli	a5,a5,0x4
    80009396:	97ba                	add	a5,a5,a4
    80009398:	679c                	ld	a5,8(a5)
    8000939a:	fef43023          	sd	a5,-32(s0)
    b->disk = 0;   // disk is done with buf
    8000939e:	fe043783          	ld	a5,-32(s0)
    800093a2:	0007a223          	sw	zero,4(a5)
    wakeup(b);
    800093a6:	fe043503          	ld	a0,-32(s0)
    800093aa:	ffffa097          	auipc	ra,0xffffa
    800093ae:	148080e7          	jalr	328(ra) # 800034f2 <wakeup>

    disk.used_idx += 1;
    800093b2:	0001c797          	auipc	a5,0x1c
    800093b6:	87678793          	addi	a5,a5,-1930 # 80024c28 <disk>
    800093ba:	0207d783          	lhu	a5,32(a5)
    800093be:	2785                	addiw	a5,a5,1
    800093c0:	03079713          	slli	a4,a5,0x30
    800093c4:	9341                	srli	a4,a4,0x30
    800093c6:	0001c797          	auipc	a5,0x1c
    800093ca:	86278793          	addi	a5,a5,-1950 # 80024c28 <disk>
    800093ce:	02e79023          	sh	a4,32(a5)
  while(disk.used_idx != disk.used->idx){
    800093d2:	0001c797          	auipc	a5,0x1c
    800093d6:	85678793          	addi	a5,a5,-1962 # 80024c28 <disk>
    800093da:	0207d703          	lhu	a4,32(a5)
    800093de:	0001c797          	auipc	a5,0x1c
    800093e2:	84a78793          	addi	a5,a5,-1974 # 80024c28 <disk>
    800093e6:	6b9c                	ld	a5,16(a5)
    800093e8:	0027d783          	lhu	a5,2(a5)
    800093ec:	2701                	sext.w	a4,a4
    800093ee:	2781                	sext.w	a5,a5
    800093f0:	f4f712e3          	bne	a4,a5,80009334 <virtio_disk_intr+0x3a>
  }

  release(&disk.vdisk_lock);
    800093f4:	0001c517          	auipc	a0,0x1c
    800093f8:	95c50513          	addi	a0,a0,-1700 # 80024d50 <disk+0x128>
    800093fc:	ffff8097          	auipc	ra,0xffff8
    80009400:	f2c080e7          	jalr	-212(ra) # 80001328 <release>
}
    80009404:	0001                	nop
    80009406:	60e2                	ld	ra,24(sp)
    80009408:	6442                	ld	s0,16(sp)
    8000940a:	6105                	addi	sp,sp,32
    8000940c:	8082                	ret
	...

000000008000a000 <_trampoline>:
    8000a000:	14051073          	csrw	sscratch,a0
    8000a004:	02000537          	lui	a0,0x2000
    8000a008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000a00a:	0536                	slli	a0,a0,0xd
    8000a00c:	02153423          	sd	ra,40(a0)
    8000a010:	02253823          	sd	sp,48(a0)
    8000a014:	02353c23          	sd	gp,56(a0)
    8000a018:	04453023          	sd	tp,64(a0)
    8000a01c:	04553423          	sd	t0,72(a0)
    8000a020:	04653823          	sd	t1,80(a0)
    8000a024:	04753c23          	sd	t2,88(a0)
    8000a028:	f120                	sd	s0,96(a0)
    8000a02a:	f524                	sd	s1,104(a0)
    8000a02c:	fd2c                	sd	a1,120(a0)
    8000a02e:	e150                	sd	a2,128(a0)
    8000a030:	e554                	sd	a3,136(a0)
    8000a032:	e958                	sd	a4,144(a0)
    8000a034:	ed5c                	sd	a5,152(a0)
    8000a036:	0b053023          	sd	a6,160(a0)
    8000a03a:	0b153423          	sd	a7,168(a0)
    8000a03e:	0b253823          	sd	s2,176(a0)
    8000a042:	0b353c23          	sd	s3,184(a0)
    8000a046:	0d453023          	sd	s4,192(a0)
    8000a04a:	0d553423          	sd	s5,200(a0)
    8000a04e:	0d653823          	sd	s6,208(a0)
    8000a052:	0d753c23          	sd	s7,216(a0)
    8000a056:	0f853023          	sd	s8,224(a0)
    8000a05a:	0f953423          	sd	s9,232(a0)
    8000a05e:	0fa53823          	sd	s10,240(a0)
    8000a062:	0fb53c23          	sd	s11,248(a0)
    8000a066:	11c53023          	sd	t3,256(a0)
    8000a06a:	11d53423          	sd	t4,264(a0)
    8000a06e:	11e53823          	sd	t5,272(a0)
    8000a072:	11f53c23          	sd	t6,280(a0)
    8000a076:	140022f3          	csrr	t0,sscratch
    8000a07a:	06553823          	sd	t0,112(a0)
    8000a07e:	00853103          	ld	sp,8(a0)
    8000a082:	02053203          	ld	tp,32(a0)
    8000a086:	01053283          	ld	t0,16(a0)
    8000a08a:	00053303          	ld	t1,0(a0)
    8000a08e:	12000073          	sfence.vma
    8000a092:	18031073          	csrw	satp,t1
    8000a096:	12000073          	sfence.vma
    8000a09a:	8282                	jr	t0

000000008000a09c <userret>:
    8000a09c:	12000073          	sfence.vma
    8000a0a0:	18051073          	csrw	satp,a0
    8000a0a4:	12000073          	sfence.vma
    8000a0a8:	02000537          	lui	a0,0x2000
    8000a0ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000a0ae:	0536                	slli	a0,a0,0xd
    8000a0b0:	02853083          	ld	ra,40(a0)
    8000a0b4:	03053103          	ld	sp,48(a0)
    8000a0b8:	03853183          	ld	gp,56(a0)
    8000a0bc:	04053203          	ld	tp,64(a0)
    8000a0c0:	04853283          	ld	t0,72(a0)
    8000a0c4:	05053303          	ld	t1,80(a0)
    8000a0c8:	05853383          	ld	t2,88(a0)
    8000a0cc:	7120                	ld	s0,96(a0)
    8000a0ce:	7524                	ld	s1,104(a0)
    8000a0d0:	7d2c                	ld	a1,120(a0)
    8000a0d2:	6150                	ld	a2,128(a0)
    8000a0d4:	6554                	ld	a3,136(a0)
    8000a0d6:	6958                	ld	a4,144(a0)
    8000a0d8:	6d5c                	ld	a5,152(a0)
    8000a0da:	0a053803          	ld	a6,160(a0)
    8000a0de:	0a853883          	ld	a7,168(a0)
    8000a0e2:	0b053903          	ld	s2,176(a0)
    8000a0e6:	0b853983          	ld	s3,184(a0)
    8000a0ea:	0c053a03          	ld	s4,192(a0)
    8000a0ee:	0c853a83          	ld	s5,200(a0)
    8000a0f2:	0d053b03          	ld	s6,208(a0)
    8000a0f6:	0d853b83          	ld	s7,216(a0)
    8000a0fa:	0e053c03          	ld	s8,224(a0)
    8000a0fe:	0e853c83          	ld	s9,232(a0)
    8000a102:	0f053d03          	ld	s10,240(a0)
    8000a106:	0f853d83          	ld	s11,248(a0)
    8000a10a:	10053e03          	ld	t3,256(a0)
    8000a10e:	10853e83          	ld	t4,264(a0)
    8000a112:	11053f03          	ld	t5,272(a0)
    8000a116:	11853f83          	ld	t6,280(a0)
    8000a11a:	7928                	ld	a0,112(a0)
    8000a11c:	10200073          	sret
	...
