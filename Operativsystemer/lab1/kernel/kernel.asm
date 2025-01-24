
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000c117          	auipc	sp,0xc
    80000004:	8d010113          	addi	sp,sp,-1840 # 8000b8d0 <stack0>
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
    80000214:	7ff78793          	addi	a5,a5,2047 # ffffffffffffe7ff <end+0xffffffff7ffd9ab7>
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
    80000328:	5ac70713          	addi	a4,a4,1452 # 800138d0 <timer_scratch>
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
    8000036c:	4b878793          	addi	a5,a5,1208 # 80008820 <timervec>
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
    800004bc:	55850513          	addi	a0,a0,1368 # 80013a10 <cons>
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
    800004e6:	52e50513          	addi	a0,a0,1326 # 80013a10 <cons>
    800004ea:	00001097          	auipc	ra,0x1
    800004ee:	e3e080e7          	jalr	-450(ra) # 80001328 <release>
        return -1;
    800004f2:	57fd                	li	a5,-1
    800004f4:	aa15                	j	80000628 <consoleread+0x192>
      }
      sleep(&cons.r, &cons.lock);
    800004f6:	00013597          	auipc	a1,0x13
    800004fa:	51a58593          	addi	a1,a1,1306 # 80013a10 <cons>
    800004fe:	00013517          	auipc	a0,0x13
    80000502:	5aa50513          	addi	a0,a0,1450 # 80013aa8 <cons+0x98>
    80000506:	00003097          	auipc	ra,0x3
    8000050a:	f70080e7          	jalr	-144(ra) # 80003476 <sleep>
    while(cons.r == cons.w){
    8000050e:	00013797          	auipc	a5,0x13
    80000512:	50278793          	addi	a5,a5,1282 # 80013a10 <cons>
    80000516:	0987a703          	lw	a4,152(a5)
    8000051a:	00013797          	auipc	a5,0x13
    8000051e:	4f678793          	addi	a5,a5,1270 # 80013a10 <cons>
    80000522:	09c7a783          	lw	a5,156(a5)
    80000526:	faf702e3          	beq	a4,a5,800004ca <consoleread+0x34>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    8000052a:	00013797          	auipc	a5,0x13
    8000052e:	4e678793          	addi	a5,a5,1254 # 80013a10 <cons>
    80000532:	0987a783          	lw	a5,152(a5)
    80000536:	0017871b          	addiw	a4,a5,1
    8000053a:	0007069b          	sext.w	a3,a4
    8000053e:	00013717          	auipc	a4,0x13
    80000542:	4d270713          	addi	a4,a4,1234 # 80013a10 <cons>
    80000546:	08d72c23          	sw	a3,152(a4)
    8000054a:	07f7f793          	andi	a5,a5,127
    8000054e:	2781                	sext.w	a5,a5
    80000550:	00013717          	auipc	a4,0x13
    80000554:	4c070713          	addi	a4,a4,1216 # 80013a10 <cons>
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
    80000586:	48e78793          	addi	a5,a5,1166 # 80013a10 <cons>
    8000058a:	0987a783          	lw	a5,152(a5)
    8000058e:	37fd                	addiw	a5,a5,-1
    80000590:	0007871b          	sext.w	a4,a5
    80000594:	00013797          	auipc	a5,0x13
    80000598:	47c78793          	addi	a5,a5,1148 # 80013a10 <cons>
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
    8000060e:	40650513          	addi	a0,a0,1030 # 80013a10 <cons>
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
    80000644:	3d050513          	addi	a0,a0,976 # 80013a10 <cons>
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
    800006b6:	35e78793          	addi	a5,a5,862 # 80013a10 <cons>
    800006ba:	0a07a783          	lw	a5,160(a5)
    800006be:	37fd                	addiw	a5,a5,-1
    800006c0:	0007871b          	sext.w	a4,a5
    800006c4:	00013797          	auipc	a5,0x13
    800006c8:	34c78793          	addi	a5,a5,844 # 80013a10 <cons>
    800006cc:	0ae7a023          	sw	a4,160(a5)
      consputc(BACKSPACE);
    800006d0:	10000513          	li	a0,256
    800006d4:	00000097          	auipc	ra,0x0
    800006d8:	ce0080e7          	jalr	-800(ra) # 800003b4 <consputc>
    while(cons.e != cons.w &&
    800006dc:	00013797          	auipc	a5,0x13
    800006e0:	33478793          	addi	a5,a5,820 # 80013a10 <cons>
    800006e4:	0a07a703          	lw	a4,160(a5)
    800006e8:	00013797          	auipc	a5,0x13
    800006ec:	32878793          	addi	a5,a5,808 # 80013a10 <cons>
    800006f0:	09c7a783          	lw	a5,156(a5)
    800006f4:	18f70363          	beq	a4,a5,8000087a <consoleintr+0x248>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800006f8:	00013797          	auipc	a5,0x13
    800006fc:	31878793          	addi	a5,a5,792 # 80013a10 <cons>
    80000700:	0a07a783          	lw	a5,160(a5)
    80000704:	37fd                	addiw	a5,a5,-1
    80000706:	2781                	sext.w	a5,a5
    80000708:	07f7f793          	andi	a5,a5,127
    8000070c:	2781                	sext.w	a5,a5
    8000070e:	00013717          	auipc	a4,0x13
    80000712:	30270713          	addi	a4,a4,770 # 80013a10 <cons>
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
    8000072e:	2e678793          	addi	a5,a5,742 # 80013a10 <cons>
    80000732:	0a07a703          	lw	a4,160(a5)
    80000736:	00013797          	auipc	a5,0x13
    8000073a:	2da78793          	addi	a5,a5,730 # 80013a10 <cons>
    8000073e:	09c7a783          	lw	a5,156(a5)
    80000742:	12f70e63          	beq	a4,a5,8000087e <consoleintr+0x24c>
      cons.e--;
    80000746:	00013797          	auipc	a5,0x13
    8000074a:	2ca78793          	addi	a5,a5,714 # 80013a10 <cons>
    8000074e:	0a07a783          	lw	a5,160(a5)
    80000752:	37fd                	addiw	a5,a5,-1
    80000754:	0007871b          	sext.w	a4,a5
    80000758:	00013797          	auipc	a5,0x13
    8000075c:	2b878793          	addi	a5,a5,696 # 80013a10 <cons>
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
    80000780:	29478793          	addi	a5,a5,660 # 80013a10 <cons>
    80000784:	0a07a703          	lw	a4,160(a5)
    80000788:	00013797          	auipc	a5,0x13
    8000078c:	28878793          	addi	a5,a5,648 # 80013a10 <cons>
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
    800007d0:	24478793          	addi	a5,a5,580 # 80013a10 <cons>
    800007d4:	0a07a783          	lw	a5,160(a5)
    800007d8:	0017871b          	addiw	a4,a5,1
    800007dc:	0007069b          	sext.w	a3,a4
    800007e0:	00013717          	auipc	a4,0x13
    800007e4:	23070713          	addi	a4,a4,560 # 80013a10 <cons>
    800007e8:	0ad72023          	sw	a3,160(a4)
    800007ec:	07f7f793          	andi	a5,a5,127
    800007f0:	2781                	sext.w	a5,a5
    800007f2:	fec42703          	lw	a4,-20(s0)
    800007f6:	0ff77713          	zext.b	a4,a4
    800007fa:	00013697          	auipc	a3,0x13
    800007fe:	21668693          	addi	a3,a3,534 # 80013a10 <cons>
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
    8000082c:	1e878793          	addi	a5,a5,488 # 80013a10 <cons>
    80000830:	0a07a703          	lw	a4,160(a5)
    80000834:	00013797          	auipc	a5,0x13
    80000838:	1dc78793          	addi	a5,a5,476 # 80013a10 <cons>
    8000083c:	0987a783          	lw	a5,152(a5)
    80000840:	40f707bb          	subw	a5,a4,a5
    80000844:	0007871b          	sext.w	a4,a5
    80000848:	08000793          	li	a5,128
    8000084c:	02f71b63          	bne	a4,a5,80000882 <consoleintr+0x250>
        // wake up consoleread() if a whole line (or end-of-file)
        // has arrived.
        cons.w = cons.e;
    80000850:	00013797          	auipc	a5,0x13
    80000854:	1c078793          	addi	a5,a5,448 # 80013a10 <cons>
    80000858:	0a07a703          	lw	a4,160(a5)
    8000085c:	00013797          	auipc	a5,0x13
    80000860:	1b478793          	addi	a5,a5,436 # 80013a10 <cons>
    80000864:	08e7ae23          	sw	a4,156(a5)
        wakeup(&cons.r);
    80000868:	00013517          	auipc	a0,0x13
    8000086c:	24050513          	addi	a0,a0,576 # 80013aa8 <cons+0x98>
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
    80000888:	18c50513          	addi	a0,a0,396 # 80013a10 <cons>
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
    800008b2:	16250513          	addi	a0,a0,354 # 80013a10 <cons>
    800008b6:	00001097          	auipc	ra,0x1
    800008ba:	9da080e7          	jalr	-1574(ra) # 80001290 <initlock>

  uartinit();
    800008be:	00000097          	auipc	ra,0x0
    800008c2:	48c080e7          	jalr	1164(ra) # 80000d4a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800008c6:	00023797          	auipc	a5,0x23
    800008ca:	2ea78793          	addi	a5,a5,746 # 80023bb0 <devsw>
    800008ce:	00000717          	auipc	a4,0x0
    800008d2:	bc870713          	addi	a4,a4,-1080 # 80000496 <consoleread>
    800008d6:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800008d8:	00023797          	auipc	a5,0x23
    800008dc:	2d878793          	addi	a5,a5,728 # 80023bb0 <devsw>
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
    8000096e:	e0668693          	addi	a3,a3,-506 # 8000b770 <digits>
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
    80000a2a:	d4a70713          	addi	a4,a4,-694 # 8000b770 <digits>
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
    80000a8c:	03078793          	addi	a5,a5,48 # 80013ab8 <pr>
    80000a90:	4f9c                	lw	a5,24(a5)
    80000a92:	fcf42e23          	sw	a5,-36(s0)
  if(locking)
    80000a96:	fdc42783          	lw	a5,-36(s0)
    80000a9a:	2781                	sext.w	a5,a5
    80000a9c:	cb89                	beqz	a5,80000aae <printf+0x44>
    acquire(&pr.lock);
    80000a9e:	00013517          	auipc	a0,0x13
    80000aa2:	01a50513          	addi	a0,a0,26 # 80013ab8 <pr>
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
    80000caa:	e1250513          	addi	a0,a0,-494 # 80013ab8 <pr>
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
    80000cd0:	dec78793          	addi	a5,a5,-532 # 80013ab8 <pr>
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
    80000d08:	b9c78793          	addi	a5,a5,-1124 # 8000b8a0 <panicked>
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
    80000d28:	d9450513          	addi	a0,a0,-620 # 80013ab8 <pr>
    80000d2c:	00000097          	auipc	ra,0x0
    80000d30:	564080e7          	jalr	1380(ra) # 80001290 <initlock>
  pr.locking = 1;
    80000d34:	00013797          	auipc	a5,0x13
    80000d38:	d8478793          	addi	a5,a5,-636 # 80013ab8 <pr>
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
    80000dae:	d2e50513          	addi	a0,a0,-722 # 80013ad8 <uart_tx_lock>
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
    80000dd6:	d0650513          	addi	a0,a0,-762 # 80013ad8 <uart_tx_lock>
    80000dda:	00000097          	auipc	ra,0x0
    80000dde:	4ea080e7          	jalr	1258(ra) # 800012c4 <acquire>

  if(panicked){
    80000de2:	0000b797          	auipc	a5,0xb
    80000de6:	abe78793          	addi	a5,a5,-1346 # 8000b8a0 <panicked>
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
    80000df8:	ce458593          	addi	a1,a1,-796 # 80013ad8 <uart_tx_lock>
    80000dfc:	0000b517          	auipc	a0,0xb
    80000e00:	ab450513          	addi	a0,a0,-1356 # 8000b8b0 <uart_tx_r>
    80000e04:	00002097          	auipc	ra,0x2
    80000e08:	672080e7          	jalr	1650(ra) # 80003476 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000e0c:	0000b797          	auipc	a5,0xb
    80000e10:	aa478793          	addi	a5,a5,-1372 # 8000b8b0 <uart_tx_r>
    80000e14:	639c                	ld	a5,0(a5)
    80000e16:	02078713          	addi	a4,a5,32
    80000e1a:	0000b797          	auipc	a5,0xb
    80000e1e:	a8e78793          	addi	a5,a5,-1394 # 8000b8a8 <uart_tx_w>
    80000e22:	639c                	ld	a5,0(a5)
    80000e24:	fcf708e3          	beq	a4,a5,80000df4 <uartputc+0x30>
  }
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000e28:	0000b797          	auipc	a5,0xb
    80000e2c:	a8078793          	addi	a5,a5,-1408 # 8000b8a8 <uart_tx_w>
    80000e30:	639c                	ld	a5,0(a5)
    80000e32:	8bfd                	andi	a5,a5,31
    80000e34:	fec42703          	lw	a4,-20(s0)
    80000e38:	0ff77713          	zext.b	a4,a4
    80000e3c:	00013697          	auipc	a3,0x13
    80000e40:	cb468693          	addi	a3,a3,-844 # 80013af0 <uart_tx_buf>
    80000e44:	97b6                	add	a5,a5,a3
    80000e46:	00e78023          	sb	a4,0(a5)
  uart_tx_w += 1;
    80000e4a:	0000b797          	auipc	a5,0xb
    80000e4e:	a5e78793          	addi	a5,a5,-1442 # 8000b8a8 <uart_tx_w>
    80000e52:	639c                	ld	a5,0(a5)
    80000e54:	00178713          	addi	a4,a5,1
    80000e58:	0000b797          	auipc	a5,0xb
    80000e5c:	a5078793          	addi	a5,a5,-1456 # 8000b8a8 <uart_tx_w>
    80000e60:	e398                	sd	a4,0(a5)
  uartstart();
    80000e62:	00000097          	auipc	ra,0x0
    80000e66:	086080e7          	jalr	134(ra) # 80000ee8 <uartstart>
  release(&uart_tx_lock);
    80000e6a:	00013517          	auipc	a0,0x13
    80000e6e:	c6e50513          	addi	a0,a0,-914 # 80013ad8 <uart_tx_lock>
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
    80000e9e:	a0678793          	addi	a5,a5,-1530 # 8000b8a0 <panicked>
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
    80000ef4:	9b878793          	addi	a5,a5,-1608 # 8000b8a8 <uart_tx_w>
    80000ef8:	6398                	ld	a4,0(a5)
    80000efa:	0000b797          	auipc	a5,0xb
    80000efe:	9b678793          	addi	a5,a5,-1610 # 8000b8b0 <uart_tx_r>
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
    80000f24:	99078793          	addi	a5,a5,-1648 # 8000b8b0 <uart_tx_r>
    80000f28:	639c                	ld	a5,0(a5)
    80000f2a:	8bfd                	andi	a5,a5,31
    80000f2c:	00013717          	auipc	a4,0x13
    80000f30:	bc470713          	addi	a4,a4,-1084 # 80013af0 <uart_tx_buf>
    80000f34:	97ba                	add	a5,a5,a4
    80000f36:	0007c783          	lbu	a5,0(a5)
    80000f3a:	fef42623          	sw	a5,-20(s0)
    uart_tx_r += 1;
    80000f3e:	0000b797          	auipc	a5,0xb
    80000f42:	97278793          	addi	a5,a5,-1678 # 8000b8b0 <uart_tx_r>
    80000f46:	639c                	ld	a5,0(a5)
    80000f48:	00178713          	addi	a4,a5,1
    80000f4c:	0000b797          	auipc	a5,0xb
    80000f50:	96478793          	addi	a5,a5,-1692 # 8000b8b0 <uart_tx_r>
    80000f54:	e398                	sd	a4,0(a5)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80000f56:	0000b517          	auipc	a0,0xb
    80000f5a:	95a50513          	addi	a0,a0,-1702 # 8000b8b0 <uart_tx_r>
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
    80000ffa:	ae250513          	addi	a0,a0,-1310 # 80013ad8 <uart_tx_lock>
    80000ffe:	00000097          	auipc	ra,0x0
    80001002:	2c6080e7          	jalr	710(ra) # 800012c4 <acquire>
  uartstart();
    80001006:	00000097          	auipc	ra,0x0
    8000100a:	ee2080e7          	jalr	-286(ra) # 80000ee8 <uartstart>
  release(&uart_tx_lock);
    8000100e:	00013517          	auipc	a0,0x13
    80001012:	aca50513          	addi	a0,a0,-1334 # 80013ad8 <uart_tx_lock>
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
    8000103c:	ad850513          	addi	a0,a0,-1320 # 80013b10 <kmem>
    80001040:	00000097          	auipc	ra,0x0
    80001044:	250080e7          	jalr	592(ra) # 80001290 <initlock>
  freerange(end, (void*)PHYSTOP);
    80001048:	47c5                	li	a5,17
    8000104a:	01b79593          	slli	a1,a5,0x1b
    8000104e:	00024517          	auipc	a0,0x24
    80001052:	cfa50513          	addi	a0,a0,-774 # 80024d48 <end>
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
    800010e0:	c6c78793          	addi	a5,a5,-916 # 80024d48 <end>
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
    80001120:	9f450513          	addi	a0,a0,-1548 # 80013b10 <kmem>
    80001124:	00000097          	auipc	ra,0x0
    80001128:	1a0080e7          	jalr	416(ra) # 800012c4 <acquire>
  r->next = kmem.freelist;
    8000112c:	00013797          	auipc	a5,0x13
    80001130:	9e478793          	addi	a5,a5,-1564 # 80013b10 <kmem>
    80001134:	6f98                	ld	a4,24(a5)
    80001136:	fe843783          	ld	a5,-24(s0)
    8000113a:	e398                	sd	a4,0(a5)
  kmem.freelist = r;
    8000113c:	00013797          	auipc	a5,0x13
    80001140:	9d478793          	addi	a5,a5,-1580 # 80013b10 <kmem>
    80001144:	fe843703          	ld	a4,-24(s0)
    80001148:	ef98                	sd	a4,24(a5)
  release(&kmem.lock);
    8000114a:	00013517          	auipc	a0,0x13
    8000114e:	9c650513          	addi	a0,a0,-1594 # 80013b10 <kmem>
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
    80001170:	9a450513          	addi	a0,a0,-1628 # 80013b10 <kmem>
    80001174:	00000097          	auipc	ra,0x0
    80001178:	150080e7          	jalr	336(ra) # 800012c4 <acquire>
  r = kmem.freelist;
    8000117c:	00013797          	auipc	a5,0x13
    80001180:	99478793          	addi	a5,a5,-1644 # 80013b10 <kmem>
    80001184:	6f9c                	ld	a5,24(a5)
    80001186:	fef43423          	sd	a5,-24(s0)
  if(r)
    8000118a:	fe843783          	ld	a5,-24(s0)
    8000118e:	cb89                	beqz	a5,800011a0 <kalloc+0x3c>
    kmem.freelist = r->next;
    80001190:	fe843783          	ld	a5,-24(s0)
    80001194:	6398                	ld	a4,0(a5)
    80001196:	00013797          	auipc	a5,0x13
    8000119a:	97a78793          	addi	a5,a5,-1670 # 80013b10 <kmem>
    8000119e:	ef98                	sd	a4,24(a5)
  release(&kmem.lock);
    800011a0:	00013517          	auipc	a0,0x13
    800011a4:	97050513          	addi	a0,a0,-1680 # 80013b10 <kmem>
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
    800018e2:	1b8080e7          	jalr	440(ra) # 80003a96 <trapinit>
    trapinithart();  // install kernel trap vector
    800018e6:	00002097          	auipc	ra,0x2
    800018ea:	1da080e7          	jalr	474(ra) # 80003ac0 <trapinithart>
    plicinit();      // set up interrupt controller
    800018ee:	00007097          	auipc	ra,0x7
    800018f2:	f5c080e7          	jalr	-164(ra) # 8000884a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800018f6:	00007097          	auipc	ra,0x7
    800018fa:	f7c080e7          	jalr	-132(ra) # 80008872 <plicinithart>
    binit();         // buffer cache
    800018fe:	00003097          	auipc	ra,0x3
    80001902:	bae080e7          	jalr	-1106(ra) # 800044ac <binit>
    iinit();         // inode table
    80001906:	00003097          	auipc	ra,0x3
    8000190a:	3dc080e7          	jalr	988(ra) # 80004ce2 <iinit>
    fileinit();      // file table
    8000190e:	00005097          	auipc	ra,0x5
    80001912:	d86080e7          	jalr	-634(ra) # 80006694 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80001916:	00007097          	auipc	ra,0x7
    8000191a:	030080e7          	jalr	48(ra) # 80008946 <virtio_disk_init>
    userinit();      // first user process
    8000191e:	00001097          	auipc	ra,0x1
    80001922:	31e080e7          	jalr	798(ra) # 80002c3c <userinit>
    __sync_synchronize();
    80001926:	0330000f          	fence	rw,rw
    started = 1;
    8000192a:	00012797          	auipc	a5,0x12
    8000192e:	20678793          	addi	a5,a5,518 # 80013b30 <started>
    80001932:	4705                	li	a4,1
    80001934:	c398                	sw	a4,0(a5)
    80001936:	a0a9                	j	80001980 <main+0x116>
  } else {
    while(started == 0)
    80001938:	0001                	nop
    8000193a:	00012797          	auipc	a5,0x12
    8000193e:	1f678793          	addi	a5,a5,502 # 80013b30 <started>
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
    80001974:	150080e7          	jalr	336(ra) # 80003ac0 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80001978:	00007097          	auipc	ra,0x7
    8000197c:	efa080e7          	jalr	-262(ra) # 80008872 <plicinithart>
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
    80001ad8:	de478793          	addi	a5,a5,-540 # 8000b8b8 <kernel_pagetable>
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
    80001afc:	dc078793          	addi	a5,a5,-576 # 8000b8b8 <kernel_pagetable>
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
    80001d36:	fff78713          	addi	a4,a5,-1 # ffffffffffffefff <end+0xffffffff7ffda2b7>
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
    80002178:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0xffffffff7ffda2b8>
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
    800026e4:	85878793          	addi	a5,a5,-1960 # 80013f38 <proc>
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
    80002718:	82478793          	addi	a5,a5,-2012 # 80013f38 <proc>
    8000271c:	40f707b3          	sub	a5,a4,a5
    80002720:	4037d713          	srai	a4,a5,0x3
    80002724:	00009797          	auipc	a5,0x9
    80002728:	b9478793          	addi	a5,a5,-1132 # 8000b2b8 <etext+0x2b8>
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
    8000277c:	1c078793          	addi	a5,a5,448 # 80019938 <pid_lock>
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
    800027a4:	19850513          	addi	a0,a0,408 # 80019938 <pid_lock>
    800027a8:	fffff097          	auipc	ra,0xfffff
    800027ac:	ae8080e7          	jalr	-1304(ra) # 80001290 <initlock>
  initlock(&wait_lock, "wait_lock");
    800027b0:	00009597          	auipc	a1,0x9
    800027b4:	a2058593          	addi	a1,a1,-1504 # 8000b1d0 <etext+0x1d0>
    800027b8:	00017517          	auipc	a0,0x17
    800027bc:	19850513          	addi	a0,a0,408 # 80019950 <wait_lock>
    800027c0:	fffff097          	auipc	ra,0xfffff
    800027c4:	ad0080e7          	jalr	-1328(ra) # 80001290 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    800027c8:	00011797          	auipc	a5,0x11
    800027cc:	77078793          	addi	a5,a5,1904 # 80013f38 <proc>
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
    800027fc:	74078793          	addi	a5,a5,1856 # 80013f38 <proc>
    80002800:	40f707b3          	sub	a5,a4,a5
    80002804:	4037d713          	srai	a4,a5,0x3
    80002808:	00009797          	auipc	a5,0x9
    8000280c:	ab078793          	addi	a5,a5,-1360 # 8000b2b8 <etext+0x2b8>
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
    8000284a:	0f278793          	addi	a5,a5,242 # 80019938 <pid_lock>
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
    800028a4:	29878793          	addi	a5,a5,664 # 80013b38 <cpus>
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
    80002904:	03850513          	addi	a0,a0,56 # 80019938 <pid_lock>
    80002908:	fffff097          	auipc	ra,0xfffff
    8000290c:	9bc080e7          	jalr	-1604(ra) # 800012c4 <acquire>
  pid = nextpid;
    80002910:	00009797          	auipc	a5,0x9
    80002914:	e5078793          	addi	a5,a5,-432 # 8000b760 <nextpid>
    80002918:	439c                	lw	a5,0(a5)
    8000291a:	fef42623          	sw	a5,-20(s0)
  nextpid = nextpid + 1;
    8000291e:	00009797          	auipc	a5,0x9
    80002922:	e4278793          	addi	a5,a5,-446 # 8000b760 <nextpid>
    80002926:	439c                	lw	a5,0(a5)
    80002928:	2785                	addiw	a5,a5,1
    8000292a:	0007871b          	sext.w	a4,a5
    8000292e:	00009797          	auipc	a5,0x9
    80002932:	e3278793          	addi	a5,a5,-462 # 8000b760 <nextpid>
    80002936:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80002938:	00017517          	auipc	a0,0x17
    8000293c:	00050513          	mv	a0,a0
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
    80002962:	5da78793          	addi	a5,a5,1498 # 80013f38 <proc>
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
    800029a4:	f9878793          	addi	a5,a5,-104 # 80019938 <pid_lock>
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
    80002c54:	c7078793          	addi	a5,a5,-912 # 8000b8c0 <initproc>
    80002c58:	fe843703          	ld	a4,-24(s0)
    80002c5c:	e398                	sd	a4,0(a5)
  
  // allocate one user page and copy initcode's instructions
  // and data into it.
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80002c5e:	fe843783          	ld	a5,-24(s0)
    80002c62:	6bbc                	ld	a5,80(a5)
    80002c64:	03400613          	li	a2,52
    80002c68:	00009597          	auipc	a1,0x9
    80002c6c:	b2058593          	addi	a1,a1,-1248 # 8000b788 <initcode>
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
    80002cbe:	114080e7          	jalr	276(ra) # 80005dce <namei>
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
    80002e5e:	8e8080e7          	jalr	-1816(ra) # 80006742 <filedup>
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
    80002e9a:	1cc080e7          	jalr	460(ra) # 80005062 <idup>
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
    80002ee2:	a7250513          	addi	a0,a0,-1422 # 80019950 <wait_lock>
    80002ee6:	ffffe097          	auipc	ra,0xffffe
    80002eea:	3de080e7          	jalr	990(ra) # 800012c4 <acquire>
  np->parent = p;
    80002eee:	fd843783          	ld	a5,-40(s0)
    80002ef2:	fe043703          	ld	a4,-32(s0)
    80002ef6:	ff98                	sd	a4,56(a5)
  release(&wait_lock);
    80002ef8:	00017517          	auipc	a0,0x17
    80002efc:	a5850513          	addi	a0,a0,-1448 # 80019950 <wait_lock>
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
    80002f4a:	ff278793          	addi	a5,a5,-14 # 80013f38 <proc>
    80002f4e:	fef43423          	sd	a5,-24(s0)
    80002f52:	a081                	j	80002f92 <reparent+0x58>
    if(pp->parent == p){
    80002f54:	fe843783          	ld	a5,-24(s0)
    80002f58:	7f9c                	ld	a5,56(a5)
    80002f5a:	fd843703          	ld	a4,-40(s0)
    80002f5e:	02f71463          	bne	a4,a5,80002f86 <reparent+0x4c>
      pp->parent = initproc;
    80002f62:	00009797          	auipc	a5,0x9
    80002f66:	95e78793          	addi	a5,a5,-1698 # 8000b8c0 <initproc>
    80002f6a:	6398                	ld	a4,0(a5)
    80002f6c:	fe843783          	ld	a5,-24(s0)
    80002f70:	ff98                	sd	a4,56(a5)
      wakeup(initproc);
    80002f72:	00009797          	auipc	a5,0x9
    80002f76:	94e78793          	addi	a5,a5,-1714 # 8000b8c0 <initproc>
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
    80002f9a:	9a278793          	addi	a5,a5,-1630 # 80019938 <pid_lock>
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
    80002fcc:	8f878793          	addi	a5,a5,-1800 # 8000b8c0 <initproc>
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
    8000301a:	00003097          	auipc	ra,0x3
    8000301e:	78e080e7          	jalr	1934(ra) # 800067a8 <fileclose>
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
    80003050:	0d2080e7          	jalr	210(ra) # 8000611e <begin_op>
  iput(p->cwd);
    80003054:	fe043783          	ld	a5,-32(s0)
    80003058:	1507b783          	ld	a5,336(a5)
    8000305c:	853e                	mv	a0,a5
    8000305e:	00002097          	auipc	ra,0x2
    80003062:	1de080e7          	jalr	478(ra) # 8000523c <iput>
  end_op();
    80003066:	00003097          	auipc	ra,0x3
    8000306a:	17a080e7          	jalr	378(ra) # 800061e0 <end_op>
  p->cwd = 0;
    8000306e:	fe043783          	ld	a5,-32(s0)
    80003072:	1407b823          	sd	zero,336(a5)

  acquire(&wait_lock);
    80003076:	00017517          	auipc	a0,0x17
    8000307a:	8da50513          	addi	a0,a0,-1830 # 80019950 <wait_lock>
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
    800030c6:	88e50513          	addi	a0,a0,-1906 # 80019950 <wait_lock>
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
    80003106:	84e50513          	addi	a0,a0,-1970 # 80019950 <wait_lock>
    8000310a:	ffffe097          	auipc	ra,0xffffe
    8000310e:	1ba080e7          	jalr	442(ra) # 800012c4 <acquire>

  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    80003112:	fe042223          	sw	zero,-28(s0)
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80003116:	00011797          	auipc	a5,0x11
    8000311a:	e2278793          	addi	a5,a5,-478 # 80013f38 <proc>
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
    8000319a:	7ba50513          	addi	a0,a0,1978 # 80019950 <wait_lock>
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
    800031c8:	78c50513          	addi	a0,a0,1932 # 80019950 <wait_lock>
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
    800031fc:	74078793          	addi	a5,a5,1856 # 80019938 <pid_lock>
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
    80003220:	73450513          	addi	a0,a0,1844 # 80019950 <wait_lock>
    80003224:	ffffe097          	auipc	ra,0xffffe
    80003228:	104080e7          	jalr	260(ra) # 80001328 <release>
      return -1;
    8000322c:	57fd                	li	a5,-1
    8000322e:	a821                	j	80003246 <wait+0x15c>
    }
    
    // Wait for a child to exit.
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80003230:	00016597          	auipc	a1,0x16
    80003234:	72058593          	addi	a1,a1,1824 # 80019950 <wait_lock>
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
    80003278:	cc478793          	addi	a5,a5,-828 # 80013f38 <proc>
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
    800032c6:	5a2080e7          	jalr	1442(ra) # 80003864 <swtch>

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
    800032f4:	64878793          	addi	a5,a5,1608 # 80019938 <pid_lock>
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
    800033bc:	4ac080e7          	jalr	1196(ra) # 80003864 <swtch>
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
    80003446:	32278793          	addi	a5,a5,802 # 8000b764 <first.1>
    8000344a:	439c                	lw	a5,0(a5)
    8000344c:	cf81                	beqz	a5,80003464 <forkret+0x3e>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    first = 0;
    8000344e:	00008797          	auipc	a5,0x8
    80003452:	31678793          	addi	a5,a5,790 # 8000b764 <first.1>
    80003456:	0007a023          	sw	zero,0(a5)
    fsinit(ROOTDEV);
    8000345a:	4505                	li	a0,1
    8000345c:	00001097          	auipc	ra,0x1
    80003460:	4fc080e7          	jalr	1276(ra) # 80004958 <fsinit>
  }

  usertrapret();
    80003464:	00000097          	auipc	ra,0x0
    80003468:	7de080e7          	jalr	2014(ra) # 80003c42 <usertrapret>
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
    80003502:	a3a78793          	addi	a5,a5,-1478 # 80013f38 <proc>
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
    80003570:	3cc78793          	addi	a5,a5,972 # 80019938 <pid_lock>
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
    80003596:	9a678793          	addi	a5,a5,-1626 # 80013f38 <proc>
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
    8000360e:	32e78793          	addi	a5,a5,814 # 80019938 <pid_lock>
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
    800037a0:	79c78793          	addi	a5,a5,1948 # 80013f38 <proc>
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
    800037c8:	ffc70713          	addi	a4,a4,-4 # 8000b7c0 <states.0>
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
    800037e2:	fe270713          	addi	a4,a4,-30 # 8000b7c0 <states.0>
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
    80003850:	0ec78793          	addi	a5,a5,236 # 80019938 <pid_lock>
    80003854:	f4f76be3          	bltu	a4,a5,800037aa <procdump+0x26>
  }
}
    80003858:	0001                	nop
    8000385a:	0001                	nop
    8000385c:	60e2                	ld	ra,24(sp)
    8000385e:	6442                	ld	s0,16(sp)
    80003860:	6105                	addi	sp,sp,32
    80003862:	8082                	ret

0000000080003864 <swtch>:
    80003864:	00153023          	sd	ra,0(a0)
    80003868:	00253423          	sd	sp,8(a0)
    8000386c:	e900                	sd	s0,16(a0)
    8000386e:	ed04                	sd	s1,24(a0)
    80003870:	03253023          	sd	s2,32(a0)
    80003874:	03353423          	sd	s3,40(a0)
    80003878:	03453823          	sd	s4,48(a0)
    8000387c:	03553c23          	sd	s5,56(a0)
    80003880:	05653023          	sd	s6,64(a0)
    80003884:	05753423          	sd	s7,72(a0)
    80003888:	05853823          	sd	s8,80(a0)
    8000388c:	05953c23          	sd	s9,88(a0)
    80003890:	07a53023          	sd	s10,96(a0)
    80003894:	07b53423          	sd	s11,104(a0)
    80003898:	0005b083          	ld	ra,0(a1)
    8000389c:	0085b103          	ld	sp,8(a1)
    800038a0:	6980                	ld	s0,16(a1)
    800038a2:	6d84                	ld	s1,24(a1)
    800038a4:	0205b903          	ld	s2,32(a1)
    800038a8:	0285b983          	ld	s3,40(a1)
    800038ac:	0305ba03          	ld	s4,48(a1)
    800038b0:	0385ba83          	ld	s5,56(a1)
    800038b4:	0405bb03          	ld	s6,64(a1)
    800038b8:	0485bb83          	ld	s7,72(a1)
    800038bc:	0505bc03          	ld	s8,80(a1)
    800038c0:	0585bc83          	ld	s9,88(a1)
    800038c4:	0605bd03          	ld	s10,96(a1)
    800038c8:	0685bd83          	ld	s11,104(a1)
    800038cc:	8082                	ret

00000000800038ce <r_sstatus>:
{
    800038ce:	1101                	addi	sp,sp,-32
    800038d0:	ec06                	sd	ra,24(sp)
    800038d2:	e822                	sd	s0,16(sp)
    800038d4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800038d6:	100027f3          	csrr	a5,sstatus
    800038da:	fef43423          	sd	a5,-24(s0)
  return x;
    800038de:	fe843783          	ld	a5,-24(s0)
}
    800038e2:	853e                	mv	a0,a5
    800038e4:	60e2                	ld	ra,24(sp)
    800038e6:	6442                	ld	s0,16(sp)
    800038e8:	6105                	addi	sp,sp,32
    800038ea:	8082                	ret

00000000800038ec <w_sstatus>:
{
    800038ec:	1101                	addi	sp,sp,-32
    800038ee:	ec06                	sd	ra,24(sp)
    800038f0:	e822                	sd	s0,16(sp)
    800038f2:	1000                	addi	s0,sp,32
    800038f4:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800038f8:	fe843783          	ld	a5,-24(s0)
    800038fc:	10079073          	csrw	sstatus,a5
}
    80003900:	0001                	nop
    80003902:	60e2                	ld	ra,24(sp)
    80003904:	6442                	ld	s0,16(sp)
    80003906:	6105                	addi	sp,sp,32
    80003908:	8082                	ret

000000008000390a <r_sip>:
{
    8000390a:	1101                	addi	sp,sp,-32
    8000390c:	ec06                	sd	ra,24(sp)
    8000390e:	e822                	sd	s0,16(sp)
    80003910:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sip" : "=r" (x) );
    80003912:	144027f3          	csrr	a5,sip
    80003916:	fef43423          	sd	a5,-24(s0)
  return x;
    8000391a:	fe843783          	ld	a5,-24(s0)
}
    8000391e:	853e                	mv	a0,a5
    80003920:	60e2                	ld	ra,24(sp)
    80003922:	6442                	ld	s0,16(sp)
    80003924:	6105                	addi	sp,sp,32
    80003926:	8082                	ret

0000000080003928 <w_sip>:
{
    80003928:	1101                	addi	sp,sp,-32
    8000392a:	ec06                	sd	ra,24(sp)
    8000392c:	e822                	sd	s0,16(sp)
    8000392e:	1000                	addi	s0,sp,32
    80003930:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw sip, %0" : : "r" (x));
    80003934:	fe843783          	ld	a5,-24(s0)
    80003938:	14479073          	csrw	sip,a5
}
    8000393c:	0001                	nop
    8000393e:	60e2                	ld	ra,24(sp)
    80003940:	6442                	ld	s0,16(sp)
    80003942:	6105                	addi	sp,sp,32
    80003944:	8082                	ret

0000000080003946 <w_sepc>:
{
    80003946:	1101                	addi	sp,sp,-32
    80003948:	ec06                	sd	ra,24(sp)
    8000394a:	e822                	sd	s0,16(sp)
    8000394c:	1000                	addi	s0,sp,32
    8000394e:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80003952:	fe843783          	ld	a5,-24(s0)
    80003956:	14179073          	csrw	sepc,a5
}
    8000395a:	0001                	nop
    8000395c:	60e2                	ld	ra,24(sp)
    8000395e:	6442                	ld	s0,16(sp)
    80003960:	6105                	addi	sp,sp,32
    80003962:	8082                	ret

0000000080003964 <r_sepc>:
{
    80003964:	1101                	addi	sp,sp,-32
    80003966:	ec06                	sd	ra,24(sp)
    80003968:	e822                	sd	s0,16(sp)
    8000396a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000396c:	141027f3          	csrr	a5,sepc
    80003970:	fef43423          	sd	a5,-24(s0)
  return x;
    80003974:	fe843783          	ld	a5,-24(s0)
}
    80003978:	853e                	mv	a0,a5
    8000397a:	60e2                	ld	ra,24(sp)
    8000397c:	6442                	ld	s0,16(sp)
    8000397e:	6105                	addi	sp,sp,32
    80003980:	8082                	ret

0000000080003982 <w_stvec>:
{
    80003982:	1101                	addi	sp,sp,-32
    80003984:	ec06                	sd	ra,24(sp)
    80003986:	e822                	sd	s0,16(sp)
    80003988:	1000                	addi	s0,sp,32
    8000398a:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000398e:	fe843783          	ld	a5,-24(s0)
    80003992:	10579073          	csrw	stvec,a5
}
    80003996:	0001                	nop
    80003998:	60e2                	ld	ra,24(sp)
    8000399a:	6442                	ld	s0,16(sp)
    8000399c:	6105                	addi	sp,sp,32
    8000399e:	8082                	ret

00000000800039a0 <r_satp>:
{
    800039a0:	1101                	addi	sp,sp,-32
    800039a2:	ec06                	sd	ra,24(sp)
    800039a4:	e822                	sd	s0,16(sp)
    800039a6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, satp" : "=r" (x) );
    800039a8:	180027f3          	csrr	a5,satp
    800039ac:	fef43423          	sd	a5,-24(s0)
  return x;
    800039b0:	fe843783          	ld	a5,-24(s0)
}
    800039b4:	853e                	mv	a0,a5
    800039b6:	60e2                	ld	ra,24(sp)
    800039b8:	6442                	ld	s0,16(sp)
    800039ba:	6105                	addi	sp,sp,32
    800039bc:	8082                	ret

00000000800039be <r_scause>:
{
    800039be:	1101                	addi	sp,sp,-32
    800039c0:	ec06                	sd	ra,24(sp)
    800039c2:	e822                	sd	s0,16(sp)
    800039c4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800039c6:	142027f3          	csrr	a5,scause
    800039ca:	fef43423          	sd	a5,-24(s0)
  return x;
    800039ce:	fe843783          	ld	a5,-24(s0)
}
    800039d2:	853e                	mv	a0,a5
    800039d4:	60e2                	ld	ra,24(sp)
    800039d6:	6442                	ld	s0,16(sp)
    800039d8:	6105                	addi	sp,sp,32
    800039da:	8082                	ret

00000000800039dc <r_stval>:
{
    800039dc:	1101                	addi	sp,sp,-32
    800039de:	ec06                	sd	ra,24(sp)
    800039e0:	e822                	sd	s0,16(sp)
    800039e2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, stval" : "=r" (x) );
    800039e4:	143027f3          	csrr	a5,stval
    800039e8:	fef43423          	sd	a5,-24(s0)
  return x;
    800039ec:	fe843783          	ld	a5,-24(s0)
}
    800039f0:	853e                	mv	a0,a5
    800039f2:	60e2                	ld	ra,24(sp)
    800039f4:	6442                	ld	s0,16(sp)
    800039f6:	6105                	addi	sp,sp,32
    800039f8:	8082                	ret

00000000800039fa <intr_on>:
{
    800039fa:	1141                	addi	sp,sp,-16
    800039fc:	e406                	sd	ra,8(sp)
    800039fe:	e022                	sd	s0,0(sp)
    80003a00:	0800                	addi	s0,sp,16
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80003a02:	00000097          	auipc	ra,0x0
    80003a06:	ecc080e7          	jalr	-308(ra) # 800038ce <r_sstatus>
    80003a0a:	87aa                	mv	a5,a0
    80003a0c:	0027e793          	ori	a5,a5,2
    80003a10:	853e                	mv	a0,a5
    80003a12:	00000097          	auipc	ra,0x0
    80003a16:	eda080e7          	jalr	-294(ra) # 800038ec <w_sstatus>
}
    80003a1a:	0001                	nop
    80003a1c:	60a2                	ld	ra,8(sp)
    80003a1e:	6402                	ld	s0,0(sp)
    80003a20:	0141                	addi	sp,sp,16
    80003a22:	8082                	ret

0000000080003a24 <intr_off>:
{
    80003a24:	1141                	addi	sp,sp,-16
    80003a26:	e406                	sd	ra,8(sp)
    80003a28:	e022                	sd	s0,0(sp)
    80003a2a:	0800                	addi	s0,sp,16
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80003a2c:	00000097          	auipc	ra,0x0
    80003a30:	ea2080e7          	jalr	-350(ra) # 800038ce <r_sstatus>
    80003a34:	87aa                	mv	a5,a0
    80003a36:	9bf5                	andi	a5,a5,-3
    80003a38:	853e                	mv	a0,a5
    80003a3a:	00000097          	auipc	ra,0x0
    80003a3e:	eb2080e7          	jalr	-334(ra) # 800038ec <w_sstatus>
}
    80003a42:	0001                	nop
    80003a44:	60a2                	ld	ra,8(sp)
    80003a46:	6402                	ld	s0,0(sp)
    80003a48:	0141                	addi	sp,sp,16
    80003a4a:	8082                	ret

0000000080003a4c <intr_get>:
{
    80003a4c:	1101                	addi	sp,sp,-32
    80003a4e:	ec06                	sd	ra,24(sp)
    80003a50:	e822                	sd	s0,16(sp)
    80003a52:	1000                	addi	s0,sp,32
  uint64 x = r_sstatus();
    80003a54:	00000097          	auipc	ra,0x0
    80003a58:	e7a080e7          	jalr	-390(ra) # 800038ce <r_sstatus>
    80003a5c:	fea43423          	sd	a0,-24(s0)
  return (x & SSTATUS_SIE) != 0;
    80003a60:	fe843783          	ld	a5,-24(s0)
    80003a64:	8b89                	andi	a5,a5,2
    80003a66:	00f037b3          	snez	a5,a5
    80003a6a:	0ff7f793          	zext.b	a5,a5
    80003a6e:	2781                	sext.w	a5,a5
}
    80003a70:	853e                	mv	a0,a5
    80003a72:	60e2                	ld	ra,24(sp)
    80003a74:	6442                	ld	s0,16(sp)
    80003a76:	6105                	addi	sp,sp,32
    80003a78:	8082                	ret

0000000080003a7a <r_tp>:
{
    80003a7a:	1101                	addi	sp,sp,-32
    80003a7c:	ec06                	sd	ra,24(sp)
    80003a7e:	e822                	sd	s0,16(sp)
    80003a80:	1000                	addi	s0,sp,32
  asm volatile("mv %0, tp" : "=r" (x) );
    80003a82:	8792                	mv	a5,tp
    80003a84:	fef43423          	sd	a5,-24(s0)
  return x;
    80003a88:	fe843783          	ld	a5,-24(s0)
}
    80003a8c:	853e                	mv	a0,a5
    80003a8e:	60e2                	ld	ra,24(sp)
    80003a90:	6442                	ld	s0,16(sp)
    80003a92:	6105                	addi	sp,sp,32
    80003a94:	8082                	ret

0000000080003a96 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80003a96:	1141                	addi	sp,sp,-16
    80003a98:	e406                	sd	ra,8(sp)
    80003a9a:	e022                	sd	s0,0(sp)
    80003a9c:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80003a9e:	00008597          	auipc	a1,0x8
    80003aa2:	82258593          	addi	a1,a1,-2014 # 8000b2c0 <etext+0x2c0>
    80003aa6:	00016517          	auipc	a0,0x16
    80003aaa:	ec250513          	addi	a0,a0,-318 # 80019968 <tickslock>
    80003aae:	ffffd097          	auipc	ra,0xffffd
    80003ab2:	7e2080e7          	jalr	2018(ra) # 80001290 <initlock>
}
    80003ab6:	0001                	nop
    80003ab8:	60a2                	ld	ra,8(sp)
    80003aba:	6402                	ld	s0,0(sp)
    80003abc:	0141                	addi	sp,sp,16
    80003abe:	8082                	ret

0000000080003ac0 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80003ac0:	1141                	addi	sp,sp,-16
    80003ac2:	e406                	sd	ra,8(sp)
    80003ac4:	e022                	sd	s0,0(sp)
    80003ac6:	0800                	addi	s0,sp,16
  w_stvec((uint64)kernelvec);
    80003ac8:	00005797          	auipc	a5,0x5
    80003acc:	cc878793          	addi	a5,a5,-824 # 80008790 <kernelvec>
    80003ad0:	853e                	mv	a0,a5
    80003ad2:	00000097          	auipc	ra,0x0
    80003ad6:	eb0080e7          	jalr	-336(ra) # 80003982 <w_stvec>
}
    80003ada:	0001                	nop
    80003adc:	60a2                	ld	ra,8(sp)
    80003ade:	6402                	ld	s0,0(sp)
    80003ae0:	0141                	addi	sp,sp,16
    80003ae2:	8082                	ret

0000000080003ae4 <usertrap>:
// handle an interrupt, exception, or system call from user space.
// called from trampoline.S
//
void
usertrap(void)
{
    80003ae4:	7179                	addi	sp,sp,-48
    80003ae6:	f406                	sd	ra,40(sp)
    80003ae8:	f022                	sd	s0,32(sp)
    80003aea:	ec26                	sd	s1,24(sp)
    80003aec:	1800                	addi	s0,sp,48
  int which_dev = 0;
    80003aee:	fc042e23          	sw	zero,-36(s0)

  if((r_sstatus() & SSTATUS_SPP) != 0)
    80003af2:	00000097          	auipc	ra,0x0
    80003af6:	ddc080e7          	jalr	-548(ra) # 800038ce <r_sstatus>
    80003afa:	87aa                	mv	a5,a0
    80003afc:	1007f793          	andi	a5,a5,256
    80003b00:	cb89                	beqz	a5,80003b12 <usertrap+0x2e>
    panic("usertrap: not from user mode");
    80003b02:	00007517          	auipc	a0,0x7
    80003b06:	7c650513          	addi	a0,a0,1990 # 8000b2c8 <etext+0x2c8>
    80003b0a:	ffffd097          	auipc	ra,0xffffd
    80003b0e:	1b6080e7          	jalr	438(ra) # 80000cc0 <panic>

  // send interrupts and exceptions to kerneltrap(),
  // since we're now in the kernel.
  w_stvec((uint64)kernelvec);
    80003b12:	00005797          	auipc	a5,0x5
    80003b16:	c7e78793          	addi	a5,a5,-898 # 80008790 <kernelvec>
    80003b1a:	853e                	mv	a0,a5
    80003b1c:	00000097          	auipc	ra,0x0
    80003b20:	e66080e7          	jalr	-410(ra) # 80003982 <w_stvec>

  struct proc *p = myproc();
    80003b24:	fffff097          	auipc	ra,0xfffff
    80003b28:	d98080e7          	jalr	-616(ra) # 800028bc <myproc>
    80003b2c:	fca43823          	sd	a0,-48(s0)
  
  // save user program counter.
  p->trapframe->epc = r_sepc();
    80003b30:	fd043783          	ld	a5,-48(s0)
    80003b34:	6fa4                	ld	s1,88(a5)
    80003b36:	00000097          	auipc	ra,0x0
    80003b3a:	e2e080e7          	jalr	-466(ra) # 80003964 <r_sepc>
    80003b3e:	87aa                	mv	a5,a0
    80003b40:	ec9c                	sd	a5,24(s1)
  
  if(r_scause() == 8){
    80003b42:	00000097          	auipc	ra,0x0
    80003b46:	e7c080e7          	jalr	-388(ra) # 800039be <r_scause>
    80003b4a:	872a                	mv	a4,a0
    80003b4c:	47a1                	li	a5,8
    80003b4e:	04f71163          	bne	a4,a5,80003b90 <usertrap+0xac>
    // system call

    if(killed(p))
    80003b52:	fd043503          	ld	a0,-48(s0)
    80003b56:	00000097          	auipc	ra,0x0
    80003b5a:	b06080e7          	jalr	-1274(ra) # 8000365c <killed>
    80003b5e:	87aa                	mv	a5,a0
    80003b60:	c791                	beqz	a5,80003b6c <usertrap+0x88>
      exit(-1);
    80003b62:	557d                	li	a0,-1
    80003b64:	fffff097          	auipc	ra,0xfffff
    80003b68:	44a080e7          	jalr	1098(ra) # 80002fae <exit>

    // sepc points to the ecall instruction,
    // but we want to return to the next instruction.
    p->trapframe->epc += 4;
    80003b6c:	fd043783          	ld	a5,-48(s0)
    80003b70:	6fbc                	ld	a5,88(a5)
    80003b72:	6f98                	ld	a4,24(a5)
    80003b74:	fd043783          	ld	a5,-48(s0)
    80003b78:	6fbc                	ld	a5,88(a5)
    80003b7a:	0711                	addi	a4,a4,4
    80003b7c:	ef98                	sd	a4,24(a5)

    // an interrupt will change sepc, scause, and sstatus,
    // so enable only now that we're done with those registers.
    intr_on();
    80003b7e:	00000097          	auipc	ra,0x0
    80003b82:	e7c080e7          	jalr	-388(ra) # 800039fa <intr_on>

    syscall();
    80003b86:	00000097          	auipc	ra,0x0
    80003b8a:	66a080e7          	jalr	1642(ra) # 800041f0 <syscall>
    80003b8e:	a885                	j	80003bfe <usertrap+0x11a>
  } else if((which_dev = devintr()) != 0){
    80003b90:	00000097          	auipc	ra,0x0
    80003b94:	34c080e7          	jalr	844(ra) # 80003edc <devintr>
    80003b98:	87aa                	mv	a5,a0
    80003b9a:	fcf42e23          	sw	a5,-36(s0)
    80003b9e:	fdc42783          	lw	a5,-36(s0)
    80003ba2:	2781                	sext.w	a5,a5
    80003ba4:	efa9                	bnez	a5,80003bfe <usertrap+0x11a>
    // ok
  } else {
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80003ba6:	00000097          	auipc	ra,0x0
    80003baa:	e18080e7          	jalr	-488(ra) # 800039be <r_scause>
    80003bae:	872a                	mv	a4,a0
    80003bb0:	fd043783          	ld	a5,-48(s0)
    80003bb4:	5b9c                	lw	a5,48(a5)
    80003bb6:	863e                	mv	a2,a5
    80003bb8:	85ba                	mv	a1,a4
    80003bba:	00007517          	auipc	a0,0x7
    80003bbe:	72e50513          	addi	a0,a0,1838 # 8000b2e8 <etext+0x2e8>
    80003bc2:	ffffd097          	auipc	ra,0xffffd
    80003bc6:	ea8080e7          	jalr	-344(ra) # 80000a6a <printf>
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003bca:	00000097          	auipc	ra,0x0
    80003bce:	d9a080e7          	jalr	-614(ra) # 80003964 <r_sepc>
    80003bd2:	84aa                	mv	s1,a0
    80003bd4:	00000097          	auipc	ra,0x0
    80003bd8:	e08080e7          	jalr	-504(ra) # 800039dc <r_stval>
    80003bdc:	87aa                	mv	a5,a0
    80003bde:	863e                	mv	a2,a5
    80003be0:	85a6                	mv	a1,s1
    80003be2:	00007517          	auipc	a0,0x7
    80003be6:	73650513          	addi	a0,a0,1846 # 8000b318 <etext+0x318>
    80003bea:	ffffd097          	auipc	ra,0xffffd
    80003bee:	e80080e7          	jalr	-384(ra) # 80000a6a <printf>
    setkilled(p);
    80003bf2:	fd043503          	ld	a0,-48(s0)
    80003bf6:	00000097          	auipc	ra,0x0
    80003bfa:	a2c080e7          	jalr	-1492(ra) # 80003622 <setkilled>
  }

  if(killed(p))
    80003bfe:	fd043503          	ld	a0,-48(s0)
    80003c02:	00000097          	auipc	ra,0x0
    80003c06:	a5a080e7          	jalr	-1446(ra) # 8000365c <killed>
    80003c0a:	87aa                	mv	a5,a0
    80003c0c:	c791                	beqz	a5,80003c18 <usertrap+0x134>
    exit(-1);
    80003c0e:	557d                	li	a0,-1
    80003c10:	fffff097          	auipc	ra,0xfffff
    80003c14:	39e080e7          	jalr	926(ra) # 80002fae <exit>

  // give up the CPU if this is a timer interrupt.
  if(which_dev == 2)
    80003c18:	fdc42783          	lw	a5,-36(s0)
    80003c1c:	0007871b          	sext.w	a4,a5
    80003c20:	4789                	li	a5,2
    80003c22:	00f71663          	bne	a4,a5,80003c2e <usertrap+0x14a>
    yield();
    80003c26:	fffff097          	auipc	ra,0xfffff
    80003c2a:	7b6080e7          	jalr	1974(ra) # 800033dc <yield>

  usertrapret();
    80003c2e:	00000097          	auipc	ra,0x0
    80003c32:	014080e7          	jalr	20(ra) # 80003c42 <usertrapret>
}
    80003c36:	0001                	nop
    80003c38:	70a2                	ld	ra,40(sp)
    80003c3a:	7402                	ld	s0,32(sp)
    80003c3c:	64e2                	ld	s1,24(sp)
    80003c3e:	6145                	addi	sp,sp,48
    80003c40:	8082                	ret

0000000080003c42 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80003c42:	715d                	addi	sp,sp,-80
    80003c44:	e486                	sd	ra,72(sp)
    80003c46:	e0a2                	sd	s0,64(sp)
    80003c48:	fc26                	sd	s1,56(sp)
    80003c4a:	0880                	addi	s0,sp,80
  struct proc *p = myproc();
    80003c4c:	fffff097          	auipc	ra,0xfffff
    80003c50:	c70080e7          	jalr	-912(ra) # 800028bc <myproc>
    80003c54:	fca43c23          	sd	a0,-40(s0)

  // we're about to switch the destination of traps from
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();
    80003c58:	00000097          	auipc	ra,0x0
    80003c5c:	dcc080e7          	jalr	-564(ra) # 80003a24 <intr_off>

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80003c60:	00006717          	auipc	a4,0x6
    80003c64:	3a070713          	addi	a4,a4,928 # 8000a000 <_trampoline>
    80003c68:	00006797          	auipc	a5,0x6
    80003c6c:	39878793          	addi	a5,a5,920 # 8000a000 <_trampoline>
    80003c70:	8f1d                	sub	a4,a4,a5
    80003c72:	040007b7          	lui	a5,0x4000
    80003c76:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80003c78:	07b2                	slli	a5,a5,0xc
    80003c7a:	97ba                	add	a5,a5,a4
    80003c7c:	fcf43823          	sd	a5,-48(s0)
  w_stvec(trampoline_uservec);
    80003c80:	fd043503          	ld	a0,-48(s0)
    80003c84:	00000097          	auipc	ra,0x0
    80003c88:	cfe080e7          	jalr	-770(ra) # 80003982 <w_stvec>

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80003c8c:	fd843783          	ld	a5,-40(s0)
    80003c90:	6fa4                	ld	s1,88(a5)
    80003c92:	00000097          	auipc	ra,0x0
    80003c96:	d0e080e7          	jalr	-754(ra) # 800039a0 <r_satp>
    80003c9a:	87aa                	mv	a5,a0
    80003c9c:	e09c                	sd	a5,0(s1)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80003c9e:	fd843783          	ld	a5,-40(s0)
    80003ca2:	63b4                	ld	a3,64(a5)
    80003ca4:	fd843783          	ld	a5,-40(s0)
    80003ca8:	6fbc                	ld	a5,88(a5)
    80003caa:	6705                	lui	a4,0x1
    80003cac:	9736                	add	a4,a4,a3
    80003cae:	e798                	sd	a4,8(a5)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80003cb0:	fd843783          	ld	a5,-40(s0)
    80003cb4:	6fbc                	ld	a5,88(a5)
    80003cb6:	00000717          	auipc	a4,0x0
    80003cba:	e2e70713          	addi	a4,a4,-466 # 80003ae4 <usertrap>
    80003cbe:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80003cc0:	fd843783          	ld	a5,-40(s0)
    80003cc4:	6fa4                	ld	s1,88(a5)
    80003cc6:	00000097          	auipc	ra,0x0
    80003cca:	db4080e7          	jalr	-588(ra) # 80003a7a <r_tp>
    80003cce:	87aa                	mv	a5,a0
    80003cd0:	f09c                	sd	a5,32(s1)

  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
    80003cd2:	00000097          	auipc	ra,0x0
    80003cd6:	bfc080e7          	jalr	-1028(ra) # 800038ce <r_sstatus>
    80003cda:	fca43423          	sd	a0,-56(s0)
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80003cde:	fc843783          	ld	a5,-56(s0)
    80003ce2:	eff7f793          	andi	a5,a5,-257
    80003ce6:	fcf43423          	sd	a5,-56(s0)
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80003cea:	fc843783          	ld	a5,-56(s0)
    80003cee:	0207e793          	ori	a5,a5,32
    80003cf2:	fcf43423          	sd	a5,-56(s0)
  w_sstatus(x);
    80003cf6:	fc843503          	ld	a0,-56(s0)
    80003cfa:	00000097          	auipc	ra,0x0
    80003cfe:	bf2080e7          	jalr	-1038(ra) # 800038ec <w_sstatus>

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80003d02:	fd843783          	ld	a5,-40(s0)
    80003d06:	6fbc                	ld	a5,88(a5)
    80003d08:	6f9c                	ld	a5,24(a5)
    80003d0a:	853e                	mv	a0,a5
    80003d0c:	00000097          	auipc	ra,0x0
    80003d10:	c3a080e7          	jalr	-966(ra) # 80003946 <w_sepc>

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80003d14:	fd843783          	ld	a5,-40(s0)
    80003d18:	6bbc                	ld	a5,80(a5)
    80003d1a:	00c7d713          	srli	a4,a5,0xc
    80003d1e:	57fd                	li	a5,-1
    80003d20:	17fe                	slli	a5,a5,0x3f
    80003d22:	8fd9                	or	a5,a5,a4
    80003d24:	fcf43023          	sd	a5,-64(s0)

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80003d28:	00006717          	auipc	a4,0x6
    80003d2c:	37470713          	addi	a4,a4,884 # 8000a09c <userret>
    80003d30:	00006797          	auipc	a5,0x6
    80003d34:	2d078793          	addi	a5,a5,720 # 8000a000 <_trampoline>
    80003d38:	8f1d                	sub	a4,a4,a5
    80003d3a:	040007b7          	lui	a5,0x4000
    80003d3e:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80003d40:	07b2                	slli	a5,a5,0xc
    80003d42:	97ba                	add	a5,a5,a4
    80003d44:	faf43c23          	sd	a5,-72(s0)
  ((void (*)(uint64))trampoline_userret)(satp);
    80003d48:	fb843783          	ld	a5,-72(s0)
    80003d4c:	fc043503          	ld	a0,-64(s0)
    80003d50:	9782                	jalr	a5
}
    80003d52:	0001                	nop
    80003d54:	60a6                	ld	ra,72(sp)
    80003d56:	6406                	ld	s0,64(sp)
    80003d58:	74e2                	ld	s1,56(sp)
    80003d5a:	6161                	addi	sp,sp,80
    80003d5c:	8082                	ret

0000000080003d5e <kerneltrap>:

// interrupts and exceptions from kernel code go here via kernelvec,
// on whatever the current kernel stack is.
void 
kerneltrap()
{
    80003d5e:	7139                	addi	sp,sp,-64
    80003d60:	fc06                	sd	ra,56(sp)
    80003d62:	f822                	sd	s0,48(sp)
    80003d64:	f426                	sd	s1,40(sp)
    80003d66:	0080                	addi	s0,sp,64
  int which_dev = 0;
    80003d68:	fc042e23          	sw	zero,-36(s0)
  uint64 sepc = r_sepc();
    80003d6c:	00000097          	auipc	ra,0x0
    80003d70:	bf8080e7          	jalr	-1032(ra) # 80003964 <r_sepc>
    80003d74:	fca43823          	sd	a0,-48(s0)
  uint64 sstatus = r_sstatus();
    80003d78:	00000097          	auipc	ra,0x0
    80003d7c:	b56080e7          	jalr	-1194(ra) # 800038ce <r_sstatus>
    80003d80:	fca43423          	sd	a0,-56(s0)
  uint64 scause = r_scause();
    80003d84:	00000097          	auipc	ra,0x0
    80003d88:	c3a080e7          	jalr	-966(ra) # 800039be <r_scause>
    80003d8c:	fca43023          	sd	a0,-64(s0)
  
  if((sstatus & SSTATUS_SPP) == 0)
    80003d90:	fc843783          	ld	a5,-56(s0)
    80003d94:	1007f793          	andi	a5,a5,256
    80003d98:	eb89                	bnez	a5,80003daa <kerneltrap+0x4c>
    panic("kerneltrap: not from supervisor mode");
    80003d9a:	00007517          	auipc	a0,0x7
    80003d9e:	59e50513          	addi	a0,a0,1438 # 8000b338 <etext+0x338>
    80003da2:	ffffd097          	auipc	ra,0xffffd
    80003da6:	f1e080e7          	jalr	-226(ra) # 80000cc0 <panic>
  if(intr_get() != 0)
    80003daa:	00000097          	auipc	ra,0x0
    80003dae:	ca2080e7          	jalr	-862(ra) # 80003a4c <intr_get>
    80003db2:	87aa                	mv	a5,a0
    80003db4:	cb89                	beqz	a5,80003dc6 <kerneltrap+0x68>
    panic("kerneltrap: interrupts enabled");
    80003db6:	00007517          	auipc	a0,0x7
    80003dba:	5aa50513          	addi	a0,a0,1450 # 8000b360 <etext+0x360>
    80003dbe:	ffffd097          	auipc	ra,0xffffd
    80003dc2:	f02080e7          	jalr	-254(ra) # 80000cc0 <panic>

  if((which_dev = devintr()) == 0){
    80003dc6:	00000097          	auipc	ra,0x0
    80003dca:	116080e7          	jalr	278(ra) # 80003edc <devintr>
    80003dce:	87aa                	mv	a5,a0
    80003dd0:	fcf42e23          	sw	a5,-36(s0)
    80003dd4:	fdc42783          	lw	a5,-36(s0)
    80003dd8:	2781                	sext.w	a5,a5
    80003dda:	e7b9                	bnez	a5,80003e28 <kerneltrap+0xca>
    printf("scause %p\n", scause);
    80003ddc:	fc043583          	ld	a1,-64(s0)
    80003de0:	00007517          	auipc	a0,0x7
    80003de4:	5a050513          	addi	a0,a0,1440 # 8000b380 <etext+0x380>
    80003de8:	ffffd097          	auipc	ra,0xffffd
    80003dec:	c82080e7          	jalr	-894(ra) # 80000a6a <printf>
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003df0:	00000097          	auipc	ra,0x0
    80003df4:	b74080e7          	jalr	-1164(ra) # 80003964 <r_sepc>
    80003df8:	84aa                	mv	s1,a0
    80003dfa:	00000097          	auipc	ra,0x0
    80003dfe:	be2080e7          	jalr	-1054(ra) # 800039dc <r_stval>
    80003e02:	87aa                	mv	a5,a0
    80003e04:	863e                	mv	a2,a5
    80003e06:	85a6                	mv	a1,s1
    80003e08:	00007517          	auipc	a0,0x7
    80003e0c:	58850513          	addi	a0,a0,1416 # 8000b390 <etext+0x390>
    80003e10:	ffffd097          	auipc	ra,0xffffd
    80003e14:	c5a080e7          	jalr	-934(ra) # 80000a6a <printf>
    panic("kerneltrap");
    80003e18:	00007517          	auipc	a0,0x7
    80003e1c:	59050513          	addi	a0,a0,1424 # 8000b3a8 <etext+0x3a8>
    80003e20:	ffffd097          	auipc	ra,0xffffd
    80003e24:	ea0080e7          	jalr	-352(ra) # 80000cc0 <panic>
  }

  // give up the CPU if this is a timer interrupt.
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80003e28:	fdc42783          	lw	a5,-36(s0)
    80003e2c:	0007871b          	sext.w	a4,a5
    80003e30:	4789                	li	a5,2
    80003e32:	02f71563          	bne	a4,a5,80003e5c <kerneltrap+0xfe>
    80003e36:	fffff097          	auipc	ra,0xfffff
    80003e3a:	a86080e7          	jalr	-1402(ra) # 800028bc <myproc>
    80003e3e:	87aa                	mv	a5,a0
    80003e40:	cf91                	beqz	a5,80003e5c <kerneltrap+0xfe>
    80003e42:	fffff097          	auipc	ra,0xfffff
    80003e46:	a7a080e7          	jalr	-1414(ra) # 800028bc <myproc>
    80003e4a:	87aa                	mv	a5,a0
    80003e4c:	4f98                	lw	a4,24(a5)
    80003e4e:	4791                	li	a5,4
    80003e50:	00f71663          	bne	a4,a5,80003e5c <kerneltrap+0xfe>
    yield();
    80003e54:	fffff097          	auipc	ra,0xfffff
    80003e58:	588080e7          	jalr	1416(ra) # 800033dc <yield>

  // the yield() may have caused some traps to occur,
  // so restore trap registers for use by kernelvec.S's sepc instruction.
  w_sepc(sepc);
    80003e5c:	fd043503          	ld	a0,-48(s0)
    80003e60:	00000097          	auipc	ra,0x0
    80003e64:	ae6080e7          	jalr	-1306(ra) # 80003946 <w_sepc>
  w_sstatus(sstatus);
    80003e68:	fc843503          	ld	a0,-56(s0)
    80003e6c:	00000097          	auipc	ra,0x0
    80003e70:	a80080e7          	jalr	-1408(ra) # 800038ec <w_sstatus>
}
    80003e74:	0001                	nop
    80003e76:	70e2                	ld	ra,56(sp)
    80003e78:	7442                	ld	s0,48(sp)
    80003e7a:	74a2                	ld	s1,40(sp)
    80003e7c:	6121                	addi	sp,sp,64
    80003e7e:	8082                	ret

0000000080003e80 <clockintr>:

void
clockintr()
{
    80003e80:	1141                	addi	sp,sp,-16
    80003e82:	e406                	sd	ra,8(sp)
    80003e84:	e022                	sd	s0,0(sp)
    80003e86:	0800                	addi	s0,sp,16
  acquire(&tickslock);
    80003e88:	00016517          	auipc	a0,0x16
    80003e8c:	ae050513          	addi	a0,a0,-1312 # 80019968 <tickslock>
    80003e90:	ffffd097          	auipc	ra,0xffffd
    80003e94:	434080e7          	jalr	1076(ra) # 800012c4 <acquire>
  ticks++;
    80003e98:	00008797          	auipc	a5,0x8
    80003e9c:	a3078793          	addi	a5,a5,-1488 # 8000b8c8 <ticks>
    80003ea0:	439c                	lw	a5,0(a5)
    80003ea2:	2785                	addiw	a5,a5,1
    80003ea4:	0007871b          	sext.w	a4,a5
    80003ea8:	00008797          	auipc	a5,0x8
    80003eac:	a2078793          	addi	a5,a5,-1504 # 8000b8c8 <ticks>
    80003eb0:	c398                	sw	a4,0(a5)
  wakeup(&ticks);
    80003eb2:	00008517          	auipc	a0,0x8
    80003eb6:	a1650513          	addi	a0,a0,-1514 # 8000b8c8 <ticks>
    80003eba:	fffff097          	auipc	ra,0xfffff
    80003ebe:	638080e7          	jalr	1592(ra) # 800034f2 <wakeup>
  release(&tickslock);
    80003ec2:	00016517          	auipc	a0,0x16
    80003ec6:	aa650513          	addi	a0,a0,-1370 # 80019968 <tickslock>
    80003eca:	ffffd097          	auipc	ra,0xffffd
    80003ece:	45e080e7          	jalr	1118(ra) # 80001328 <release>
}
    80003ed2:	0001                	nop
    80003ed4:	60a2                	ld	ra,8(sp)
    80003ed6:	6402                	ld	s0,0(sp)
    80003ed8:	0141                	addi	sp,sp,16
    80003eda:	8082                	ret

0000000080003edc <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80003edc:	1101                	addi	sp,sp,-32
    80003ede:	ec06                	sd	ra,24(sp)
    80003ee0:	e822                	sd	s0,16(sp)
    80003ee2:	1000                	addi	s0,sp,32
  uint64 scause = r_scause();
    80003ee4:	00000097          	auipc	ra,0x0
    80003ee8:	ada080e7          	jalr	-1318(ra) # 800039be <r_scause>
    80003eec:	fea43423          	sd	a0,-24(s0)

  if((scause & 0x8000000000000000L) &&
    80003ef0:	fe843783          	ld	a5,-24(s0)
    80003ef4:	0807d463          	bgez	a5,80003f7c <devintr+0xa0>
     (scause & 0xff) == 9){
    80003ef8:	fe843783          	ld	a5,-24(s0)
    80003efc:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80003f00:	47a5                	li	a5,9
    80003f02:	06f71d63          	bne	a4,a5,80003f7c <devintr+0xa0>
    // this is a supervisor external interrupt, via PLIC.

    // irq indicates which device interrupted.
    int irq = plic_claim();
    80003f06:	00005097          	auipc	ra,0x5
    80003f0a:	9c0080e7          	jalr	-1600(ra) # 800088c6 <plic_claim>
    80003f0e:	87aa                	mv	a5,a0
    80003f10:	fef42223          	sw	a5,-28(s0)

    if(irq == UART0_IRQ){
    80003f14:	fe442783          	lw	a5,-28(s0)
    80003f18:	0007871b          	sext.w	a4,a5
    80003f1c:	47a9                	li	a5,10
    80003f1e:	00f71763          	bne	a4,a5,80003f2c <devintr+0x50>
      uartintr();
    80003f22:	ffffd097          	auipc	ra,0xffffd
    80003f26:	09e080e7          	jalr	158(ra) # 80000fc0 <uartintr>
    80003f2a:	a825                	j	80003f62 <devintr+0x86>
    } else if(irq == VIRTIO0_IRQ){
    80003f2c:	fe442783          	lw	a5,-28(s0)
    80003f30:	0007871b          	sext.w	a4,a5
    80003f34:	4785                	li	a5,1
    80003f36:	00f71763          	bne	a4,a5,80003f44 <devintr+0x68>
      virtio_disk_intr();
    80003f3a:	00005097          	auipc	ra,0x5
    80003f3e:	350080e7          	jalr	848(ra) # 8000928a <virtio_disk_intr>
    80003f42:	a005                	j	80003f62 <devintr+0x86>
    } else if(irq){
    80003f44:	fe442783          	lw	a5,-28(s0)
    80003f48:	2781                	sext.w	a5,a5
    80003f4a:	cf81                	beqz	a5,80003f62 <devintr+0x86>
      printf("unexpected interrupt irq=%d\n", irq);
    80003f4c:	fe442783          	lw	a5,-28(s0)
    80003f50:	85be                	mv	a1,a5
    80003f52:	00007517          	auipc	a0,0x7
    80003f56:	46650513          	addi	a0,a0,1126 # 8000b3b8 <etext+0x3b8>
    80003f5a:	ffffd097          	auipc	ra,0xffffd
    80003f5e:	b10080e7          	jalr	-1264(ra) # 80000a6a <printf>
    }

    // the PLIC allows each device to raise at most one
    // interrupt at a time; tell the PLIC the device is
    // now allowed to interrupt again.
    if(irq)
    80003f62:	fe442783          	lw	a5,-28(s0)
    80003f66:	2781                	sext.w	a5,a5
    80003f68:	cb81                	beqz	a5,80003f78 <devintr+0x9c>
      plic_complete(irq);
    80003f6a:	fe442783          	lw	a5,-28(s0)
    80003f6e:	853e                	mv	a0,a5
    80003f70:	00005097          	auipc	ra,0x5
    80003f74:	994080e7          	jalr	-1644(ra) # 80008904 <plic_complete>

    return 1;
    80003f78:	4785                	li	a5,1
    80003f7a:	a081                	j	80003fba <devintr+0xde>
  } else if(scause == 0x8000000000000001L){
    80003f7c:	fe843703          	ld	a4,-24(s0)
    80003f80:	57fd                	li	a5,-1
    80003f82:	17fe                	slli	a5,a5,0x3f
    80003f84:	0785                	addi	a5,a5,1
    80003f86:	02f71963          	bne	a4,a5,80003fb8 <devintr+0xdc>
    // software interrupt from a machine-mode timer interrupt,
    // forwarded by timervec in kernelvec.S.

    if(cpuid() == 0){
    80003f8a:	fffff097          	auipc	ra,0xfffff
    80003f8e:	8d4080e7          	jalr	-1836(ra) # 8000285e <cpuid>
    80003f92:	87aa                	mv	a5,a0
    80003f94:	e789                	bnez	a5,80003f9e <devintr+0xc2>
      clockintr();
    80003f96:	00000097          	auipc	ra,0x0
    80003f9a:	eea080e7          	jalr	-278(ra) # 80003e80 <clockintr>
    }
    
    // acknowledge the software interrupt by clearing
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);
    80003f9e:	00000097          	auipc	ra,0x0
    80003fa2:	96c080e7          	jalr	-1684(ra) # 8000390a <r_sip>
    80003fa6:	87aa                	mv	a5,a0
    80003fa8:	9bf5                	andi	a5,a5,-3
    80003faa:	853e                	mv	a0,a5
    80003fac:	00000097          	auipc	ra,0x0
    80003fb0:	97c080e7          	jalr	-1668(ra) # 80003928 <w_sip>

    return 2;
    80003fb4:	4789                	li	a5,2
    80003fb6:	a011                	j	80003fba <devintr+0xde>
  } else {
    return 0;
    80003fb8:	4781                	li	a5,0
  }
}
    80003fba:	853e                	mv	a0,a5
    80003fbc:	60e2                	ld	ra,24(sp)
    80003fbe:	6442                	ld	s0,16(sp)
    80003fc0:	6105                	addi	sp,sp,32
    80003fc2:	8082                	ret

0000000080003fc4 <fetchaddr>:
#include "defs.h"

// Fetch the uint64 at addr from the current process.
int
fetchaddr(uint64 addr, uint64 *ip)
{
    80003fc4:	7179                	addi	sp,sp,-48
    80003fc6:	f406                	sd	ra,40(sp)
    80003fc8:	f022                	sd	s0,32(sp)
    80003fca:	1800                	addi	s0,sp,48
    80003fcc:	fca43c23          	sd	a0,-40(s0)
    80003fd0:	fcb43823          	sd	a1,-48(s0)
  struct proc *p = myproc();
    80003fd4:	fffff097          	auipc	ra,0xfffff
    80003fd8:	8e8080e7          	jalr	-1816(ra) # 800028bc <myproc>
    80003fdc:	fea43423          	sd	a0,-24(s0)
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80003fe0:	fe843783          	ld	a5,-24(s0)
    80003fe4:	67bc                	ld	a5,72(a5)
    80003fe6:	fd843703          	ld	a4,-40(s0)
    80003fea:	00f77b63          	bgeu	a4,a5,80004000 <fetchaddr+0x3c>
    80003fee:	fd843783          	ld	a5,-40(s0)
    80003ff2:	00878713          	addi	a4,a5,8
    80003ff6:	fe843783          	ld	a5,-24(s0)
    80003ffa:	67bc                	ld	a5,72(a5)
    80003ffc:	00e7f463          	bgeu	a5,a4,80004004 <fetchaddr+0x40>
    return -1;
    80004000:	57fd                	li	a5,-1
    80004002:	a01d                	j	80004028 <fetchaddr+0x64>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80004004:	fe843783          	ld	a5,-24(s0)
    80004008:	6bbc                	ld	a5,80(a5)
    8000400a:	46a1                	li	a3,8
    8000400c:	fd843603          	ld	a2,-40(s0)
    80004010:	fd043583          	ld	a1,-48(s0)
    80004014:	853e                	mv	a0,a5
    80004016:	ffffe097          	auipc	ra,0xffffe
    8000401a:	432080e7          	jalr	1074(ra) # 80002448 <copyin>
    8000401e:	87aa                	mv	a5,a0
    80004020:	c399                	beqz	a5,80004026 <fetchaddr+0x62>
    return -1;
    80004022:	57fd                	li	a5,-1
    80004024:	a011                	j	80004028 <fetchaddr+0x64>
  return 0;
    80004026:	4781                	li	a5,0
}
    80004028:	853e                	mv	a0,a5
    8000402a:	70a2                	ld	ra,40(sp)
    8000402c:	7402                	ld	s0,32(sp)
    8000402e:	6145                	addi	sp,sp,48
    80004030:	8082                	ret

0000000080004032 <fetchstr>:

// Fetch the nul-terminated string at addr from the current process.
// Returns length of string, not including nul, or -1 for error.
int
fetchstr(uint64 addr, char *buf, int max)
{
    80004032:	7139                	addi	sp,sp,-64
    80004034:	fc06                	sd	ra,56(sp)
    80004036:	f822                	sd	s0,48(sp)
    80004038:	0080                	addi	s0,sp,64
    8000403a:	fca43c23          	sd	a0,-40(s0)
    8000403e:	fcb43823          	sd	a1,-48(s0)
    80004042:	87b2                	mv	a5,a2
    80004044:	fcf42623          	sw	a5,-52(s0)
  struct proc *p = myproc();
    80004048:	fffff097          	auipc	ra,0xfffff
    8000404c:	874080e7          	jalr	-1932(ra) # 800028bc <myproc>
    80004050:	fea43423          	sd	a0,-24(s0)
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80004054:	fe843783          	ld	a5,-24(s0)
    80004058:	6bbc                	ld	a5,80(a5)
    8000405a:	fcc42703          	lw	a4,-52(s0)
    8000405e:	86ba                	mv	a3,a4
    80004060:	fd843603          	ld	a2,-40(s0)
    80004064:	fd043583          	ld	a1,-48(s0)
    80004068:	853e                	mv	a0,a5
    8000406a:	ffffe097          	auipc	ra,0xffffe
    8000406e:	4ac080e7          	jalr	1196(ra) # 80002516 <copyinstr>
    80004072:	87aa                	mv	a5,a0
    80004074:	0007d463          	bgez	a5,8000407c <fetchstr+0x4a>
    return -1;
    80004078:	57fd                	li	a5,-1
    8000407a:	a801                	j	8000408a <fetchstr+0x58>
  return strlen(buf);
    8000407c:	fd043503          	ld	a0,-48(s0)
    80004080:	ffffd097          	auipc	ra,0xffffd
    80004084:	7b0080e7          	jalr	1968(ra) # 80001830 <strlen>
    80004088:	87aa                	mv	a5,a0
}
    8000408a:	853e                	mv	a0,a5
    8000408c:	70e2                	ld	ra,56(sp)
    8000408e:	7442                	ld	s0,48(sp)
    80004090:	6121                	addi	sp,sp,64
    80004092:	8082                	ret

0000000080004094 <argraw>:

static uint64
argraw(int n)
{
    80004094:	7179                	addi	sp,sp,-48
    80004096:	f406                	sd	ra,40(sp)
    80004098:	f022                	sd	s0,32(sp)
    8000409a:	1800                	addi	s0,sp,48
    8000409c:	87aa                	mv	a5,a0
    8000409e:	fcf42e23          	sw	a5,-36(s0)
  struct proc *p = myproc();
    800040a2:	fffff097          	auipc	ra,0xfffff
    800040a6:	81a080e7          	jalr	-2022(ra) # 800028bc <myproc>
    800040aa:	fea43423          	sd	a0,-24(s0)
  switch (n) {
    800040ae:	fdc42783          	lw	a5,-36(s0)
    800040b2:	0007871b          	sext.w	a4,a5
    800040b6:	4795                	li	a5,5
    800040b8:	06e7e263          	bltu	a5,a4,8000411c <argraw+0x88>
    800040bc:	fdc46783          	lwu	a5,-36(s0)
    800040c0:	00279713          	slli	a4,a5,0x2
    800040c4:	00007797          	auipc	a5,0x7
    800040c8:	31c78793          	addi	a5,a5,796 # 8000b3e0 <etext+0x3e0>
    800040cc:	97ba                	add	a5,a5,a4
    800040ce:	439c                	lw	a5,0(a5)
    800040d0:	0007871b          	sext.w	a4,a5
    800040d4:	00007797          	auipc	a5,0x7
    800040d8:	30c78793          	addi	a5,a5,780 # 8000b3e0 <etext+0x3e0>
    800040dc:	97ba                	add	a5,a5,a4
    800040de:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800040e0:	fe843783          	ld	a5,-24(s0)
    800040e4:	6fbc                	ld	a5,88(a5)
    800040e6:	7bbc                	ld	a5,112(a5)
    800040e8:	a091                	j	8000412c <argraw+0x98>
  case 1:
    return p->trapframe->a1;
    800040ea:	fe843783          	ld	a5,-24(s0)
    800040ee:	6fbc                	ld	a5,88(a5)
    800040f0:	7fbc                	ld	a5,120(a5)
    800040f2:	a82d                	j	8000412c <argraw+0x98>
  case 2:
    return p->trapframe->a2;
    800040f4:	fe843783          	ld	a5,-24(s0)
    800040f8:	6fbc                	ld	a5,88(a5)
    800040fa:	63dc                	ld	a5,128(a5)
    800040fc:	a805                	j	8000412c <argraw+0x98>
  case 3:
    return p->trapframe->a3;
    800040fe:	fe843783          	ld	a5,-24(s0)
    80004102:	6fbc                	ld	a5,88(a5)
    80004104:	67dc                	ld	a5,136(a5)
    80004106:	a01d                	j	8000412c <argraw+0x98>
  case 4:
    return p->trapframe->a4;
    80004108:	fe843783          	ld	a5,-24(s0)
    8000410c:	6fbc                	ld	a5,88(a5)
    8000410e:	6bdc                	ld	a5,144(a5)
    80004110:	a831                	j	8000412c <argraw+0x98>
  case 5:
    return p->trapframe->a5;
    80004112:	fe843783          	ld	a5,-24(s0)
    80004116:	6fbc                	ld	a5,88(a5)
    80004118:	6fdc                	ld	a5,152(a5)
    8000411a:	a809                	j	8000412c <argraw+0x98>
  }
  panic("argraw");
    8000411c:	00007517          	auipc	a0,0x7
    80004120:	2bc50513          	addi	a0,a0,700 # 8000b3d8 <etext+0x3d8>
    80004124:	ffffd097          	auipc	ra,0xffffd
    80004128:	b9c080e7          	jalr	-1124(ra) # 80000cc0 <panic>
  return -1;
}
    8000412c:	853e                	mv	a0,a5
    8000412e:	70a2                	ld	ra,40(sp)
    80004130:	7402                	ld	s0,32(sp)
    80004132:	6145                	addi	sp,sp,48
    80004134:	8082                	ret

0000000080004136 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80004136:	1101                	addi	sp,sp,-32
    80004138:	ec06                	sd	ra,24(sp)
    8000413a:	e822                	sd	s0,16(sp)
    8000413c:	1000                	addi	s0,sp,32
    8000413e:	87aa                	mv	a5,a0
    80004140:	feb43023          	sd	a1,-32(s0)
    80004144:	fef42623          	sw	a5,-20(s0)
  *ip = argraw(n);
    80004148:	fec42783          	lw	a5,-20(s0)
    8000414c:	853e                	mv	a0,a5
    8000414e:	00000097          	auipc	ra,0x0
    80004152:	f46080e7          	jalr	-186(ra) # 80004094 <argraw>
    80004156:	87aa                	mv	a5,a0
    80004158:	0007871b          	sext.w	a4,a5
    8000415c:	fe043783          	ld	a5,-32(s0)
    80004160:	c398                	sw	a4,0(a5)
}
    80004162:	0001                	nop
    80004164:	60e2                	ld	ra,24(sp)
    80004166:	6442                	ld	s0,16(sp)
    80004168:	6105                	addi	sp,sp,32
    8000416a:	8082                	ret

000000008000416c <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    8000416c:	1101                	addi	sp,sp,-32
    8000416e:	ec06                	sd	ra,24(sp)
    80004170:	e822                	sd	s0,16(sp)
    80004172:	1000                	addi	s0,sp,32
    80004174:	87aa                	mv	a5,a0
    80004176:	feb43023          	sd	a1,-32(s0)
    8000417a:	fef42623          	sw	a5,-20(s0)
  *ip = argraw(n);
    8000417e:	fec42783          	lw	a5,-20(s0)
    80004182:	853e                	mv	a0,a5
    80004184:	00000097          	auipc	ra,0x0
    80004188:	f10080e7          	jalr	-240(ra) # 80004094 <argraw>
    8000418c:	872a                	mv	a4,a0
    8000418e:	fe043783          	ld	a5,-32(s0)
    80004192:	e398                	sd	a4,0(a5)
}
    80004194:	0001                	nop
    80004196:	60e2                	ld	ra,24(sp)
    80004198:	6442                	ld	s0,16(sp)
    8000419a:	6105                	addi	sp,sp,32
    8000419c:	8082                	ret

000000008000419e <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000419e:	7179                	addi	sp,sp,-48
    800041a0:	f406                	sd	ra,40(sp)
    800041a2:	f022                	sd	s0,32(sp)
    800041a4:	1800                	addi	s0,sp,48
    800041a6:	87aa                	mv	a5,a0
    800041a8:	fcb43823          	sd	a1,-48(s0)
    800041ac:	8732                	mv	a4,a2
    800041ae:	fcf42e23          	sw	a5,-36(s0)
    800041b2:	87ba                	mv	a5,a4
    800041b4:	fcf42c23          	sw	a5,-40(s0)
  uint64 addr;
  argaddr(n, &addr);
    800041b8:	fe840713          	addi	a4,s0,-24
    800041bc:	fdc42783          	lw	a5,-36(s0)
    800041c0:	85ba                	mv	a1,a4
    800041c2:	853e                	mv	a0,a5
    800041c4:	00000097          	auipc	ra,0x0
    800041c8:	fa8080e7          	jalr	-88(ra) # 8000416c <argaddr>
  return fetchstr(addr, buf, max);
    800041cc:	fe843783          	ld	a5,-24(s0)
    800041d0:	fd842703          	lw	a4,-40(s0)
    800041d4:	863a                	mv	a2,a4
    800041d6:	fd043583          	ld	a1,-48(s0)
    800041da:	853e                	mv	a0,a5
    800041dc:	00000097          	auipc	ra,0x0
    800041e0:	e56080e7          	jalr	-426(ra) # 80004032 <fetchstr>
    800041e4:	87aa                	mv	a5,a0
}
    800041e6:	853e                	mv	a0,a5
    800041e8:	70a2                	ld	ra,40(sp)
    800041ea:	7402                	ld	s0,32(sp)
    800041ec:	6145                	addi	sp,sp,48
    800041ee:	8082                	ret

00000000800041f0 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    800041f0:	7179                	addi	sp,sp,-48
    800041f2:	f406                	sd	ra,40(sp)
    800041f4:	f022                	sd	s0,32(sp)
    800041f6:	ec26                	sd	s1,24(sp)
    800041f8:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    800041fa:	ffffe097          	auipc	ra,0xffffe
    800041fe:	6c2080e7          	jalr	1730(ra) # 800028bc <myproc>
    80004202:	fca43c23          	sd	a0,-40(s0)

  num = p->trapframe->a7;
    80004206:	fd843783          	ld	a5,-40(s0)
    8000420a:	6fbc                	ld	a5,88(a5)
    8000420c:	77dc                	ld	a5,168(a5)
    8000420e:	fcf42a23          	sw	a5,-44(s0)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80004212:	fd442783          	lw	a5,-44(s0)
    80004216:	2781                	sext.w	a5,a5
    80004218:	04f05163          	blez	a5,8000425a <syscall+0x6a>
    8000421c:	fd442703          	lw	a4,-44(s0)
    80004220:	47d5                	li	a5,21
    80004222:	02e7ec63          	bltu	a5,a4,8000425a <syscall+0x6a>
    80004226:	00007717          	auipc	a4,0x7
    8000422a:	5ca70713          	addi	a4,a4,1482 # 8000b7f0 <syscalls>
    8000422e:	fd442783          	lw	a5,-44(s0)
    80004232:	078e                	slli	a5,a5,0x3
    80004234:	97ba                	add	a5,a5,a4
    80004236:	639c                	ld	a5,0(a5)
    80004238:	c38d                	beqz	a5,8000425a <syscall+0x6a>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000423a:	00007717          	auipc	a4,0x7
    8000423e:	5b670713          	addi	a4,a4,1462 # 8000b7f0 <syscalls>
    80004242:	fd442783          	lw	a5,-44(s0)
    80004246:	078e                	slli	a5,a5,0x3
    80004248:	97ba                	add	a5,a5,a4
    8000424a:	639c                	ld	a5,0(a5)
    8000424c:	fd843703          	ld	a4,-40(s0)
    80004250:	6f24                	ld	s1,88(a4)
    80004252:	9782                	jalr	a5
    80004254:	87aa                	mv	a5,a0
    80004256:	f8bc                	sd	a5,112(s1)
    80004258:	a815                	j	8000428c <syscall+0x9c>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000425a:	fd843783          	ld	a5,-40(s0)
    8000425e:	5b98                	lw	a4,48(a5)
            p->pid, p->name, num);
    80004260:	fd843783          	ld	a5,-40(s0)
    80004264:	15878793          	addi	a5,a5,344
    printf("%d %s: unknown sys call %d\n",
    80004268:	fd442683          	lw	a3,-44(s0)
    8000426c:	863e                	mv	a2,a5
    8000426e:	85ba                	mv	a1,a4
    80004270:	00007517          	auipc	a0,0x7
    80004274:	18850513          	addi	a0,a0,392 # 8000b3f8 <etext+0x3f8>
    80004278:	ffffc097          	auipc	ra,0xffffc
    8000427c:	7f2080e7          	jalr	2034(ra) # 80000a6a <printf>
    p->trapframe->a0 = -1;
    80004280:	fd843783          	ld	a5,-40(s0)
    80004284:	6fbc                	ld	a5,88(a5)
    80004286:	577d                	li	a4,-1
    80004288:	fbb8                	sd	a4,112(a5)
  }
}
    8000428a:	0001                	nop
    8000428c:	0001                	nop
    8000428e:	70a2                	ld	ra,40(sp)
    80004290:	7402                	ld	s0,32(sp)
    80004292:	64e2                	ld	s1,24(sp)
    80004294:	6145                	addi	sp,sp,48
    80004296:	8082                	ret

0000000080004298 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80004298:	1101                	addi	sp,sp,-32
    8000429a:	ec06                	sd	ra,24(sp)
    8000429c:	e822                	sd	s0,16(sp)
    8000429e:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800042a0:	fec40793          	addi	a5,s0,-20
    800042a4:	85be                	mv	a1,a5
    800042a6:	4501                	li	a0,0
    800042a8:	00000097          	auipc	ra,0x0
    800042ac:	e8e080e7          	jalr	-370(ra) # 80004136 <argint>
  exit(n);
    800042b0:	fec42783          	lw	a5,-20(s0)
    800042b4:	853e                	mv	a0,a5
    800042b6:	fffff097          	auipc	ra,0xfffff
    800042ba:	cf8080e7          	jalr	-776(ra) # 80002fae <exit>
  return 0;  // not reached
    800042be:	4781                	li	a5,0
}
    800042c0:	853e                	mv	a0,a5
    800042c2:	60e2                	ld	ra,24(sp)
    800042c4:	6442                	ld	s0,16(sp)
    800042c6:	6105                	addi	sp,sp,32
    800042c8:	8082                	ret

00000000800042ca <sys_getpid>:

uint64
sys_getpid(void)
{
    800042ca:	1141                	addi	sp,sp,-16
    800042cc:	e406                	sd	ra,8(sp)
    800042ce:	e022                	sd	s0,0(sp)
    800042d0:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800042d2:	ffffe097          	auipc	ra,0xffffe
    800042d6:	5ea080e7          	jalr	1514(ra) # 800028bc <myproc>
    800042da:	87aa                	mv	a5,a0
    800042dc:	5b9c                	lw	a5,48(a5)
}
    800042de:	853e                	mv	a0,a5
    800042e0:	60a2                	ld	ra,8(sp)
    800042e2:	6402                	ld	s0,0(sp)
    800042e4:	0141                	addi	sp,sp,16
    800042e6:	8082                	ret

00000000800042e8 <sys_fork>:

uint64
sys_fork(void)
{
    800042e8:	1141                	addi	sp,sp,-16
    800042ea:	e406                	sd	ra,8(sp)
    800042ec:	e022                	sd	s0,0(sp)
    800042ee:	0800                	addi	s0,sp,16
  return fork();
    800042f0:	fffff097          	auipc	ra,0xfffff
    800042f4:	a9c080e7          	jalr	-1380(ra) # 80002d8c <fork>
    800042f8:	87aa                	mv	a5,a0
}
    800042fa:	853e                	mv	a0,a5
    800042fc:	60a2                	ld	ra,8(sp)
    800042fe:	6402                	ld	s0,0(sp)
    80004300:	0141                	addi	sp,sp,16
    80004302:	8082                	ret

0000000080004304 <sys_wait>:

uint64
sys_wait(void)
{
    80004304:	1101                	addi	sp,sp,-32
    80004306:	ec06                	sd	ra,24(sp)
    80004308:	e822                	sd	s0,16(sp)
    8000430a:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000430c:	fe840793          	addi	a5,s0,-24
    80004310:	85be                	mv	a1,a5
    80004312:	4501                	li	a0,0
    80004314:	00000097          	auipc	ra,0x0
    80004318:	e58080e7          	jalr	-424(ra) # 8000416c <argaddr>
  return wait(p);
    8000431c:	fe843783          	ld	a5,-24(s0)
    80004320:	853e                	mv	a0,a5
    80004322:	fffff097          	auipc	ra,0xfffff
    80004326:	dc8080e7          	jalr	-568(ra) # 800030ea <wait>
    8000432a:	87aa                	mv	a5,a0
}
    8000432c:	853e                	mv	a0,a5
    8000432e:	60e2                	ld	ra,24(sp)
    80004330:	6442                	ld	s0,16(sp)
    80004332:	6105                	addi	sp,sp,32
    80004334:	8082                	ret

0000000080004336 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80004336:	1101                	addi	sp,sp,-32
    80004338:	ec06                	sd	ra,24(sp)
    8000433a:	e822                	sd	s0,16(sp)
    8000433c:	1000                	addi	s0,sp,32
  uint64 addr;
  int n;

  argint(0, &n);
    8000433e:	fe440793          	addi	a5,s0,-28
    80004342:	85be                	mv	a1,a5
    80004344:	4501                	li	a0,0
    80004346:	00000097          	auipc	ra,0x0
    8000434a:	df0080e7          	jalr	-528(ra) # 80004136 <argint>
  addr = myproc()->sz;
    8000434e:	ffffe097          	auipc	ra,0xffffe
    80004352:	56e080e7          	jalr	1390(ra) # 800028bc <myproc>
    80004356:	87aa                	mv	a5,a0
    80004358:	67bc                	ld	a5,72(a5)
    8000435a:	fef43423          	sd	a5,-24(s0)
  if(growproc(n) < 0)
    8000435e:	fe442783          	lw	a5,-28(s0)
    80004362:	853e                	mv	a0,a5
    80004364:	fffff097          	auipc	ra,0xfffff
    80004368:	988080e7          	jalr	-1656(ra) # 80002cec <growproc>
    8000436c:	87aa                	mv	a5,a0
    8000436e:	0007d463          	bgez	a5,80004376 <sys_sbrk+0x40>
    return -1;
    80004372:	57fd                	li	a5,-1
    80004374:	a019                	j	8000437a <sys_sbrk+0x44>
  return addr;
    80004376:	fe843783          	ld	a5,-24(s0)
}
    8000437a:	853e                	mv	a0,a5
    8000437c:	60e2                	ld	ra,24(sp)
    8000437e:	6442                	ld	s0,16(sp)
    80004380:	6105                	addi	sp,sp,32
    80004382:	8082                	ret

0000000080004384 <sys_sleep>:

uint64
sys_sleep(void)
{
    80004384:	1101                	addi	sp,sp,-32
    80004386:	ec06                	sd	ra,24(sp)
    80004388:	e822                	sd	s0,16(sp)
    8000438a:	1000                	addi	s0,sp,32
  int n;
  uint ticks0;

  argint(0, &n);
    8000438c:	fe840793          	addi	a5,s0,-24
    80004390:	85be                	mv	a1,a5
    80004392:	4501                	li	a0,0
    80004394:	00000097          	auipc	ra,0x0
    80004398:	da2080e7          	jalr	-606(ra) # 80004136 <argint>
  acquire(&tickslock);
    8000439c:	00015517          	auipc	a0,0x15
    800043a0:	5cc50513          	addi	a0,a0,1484 # 80019968 <tickslock>
    800043a4:	ffffd097          	auipc	ra,0xffffd
    800043a8:	f20080e7          	jalr	-224(ra) # 800012c4 <acquire>
  ticks0 = ticks;
    800043ac:	00007797          	auipc	a5,0x7
    800043b0:	51c78793          	addi	a5,a5,1308 # 8000b8c8 <ticks>
    800043b4:	439c                	lw	a5,0(a5)
    800043b6:	fef42623          	sw	a5,-20(s0)
  while(ticks - ticks0 < n){
    800043ba:	a099                	j	80004400 <sys_sleep+0x7c>
    if(killed(myproc())){
    800043bc:	ffffe097          	auipc	ra,0xffffe
    800043c0:	500080e7          	jalr	1280(ra) # 800028bc <myproc>
    800043c4:	87aa                	mv	a5,a0
    800043c6:	853e                	mv	a0,a5
    800043c8:	fffff097          	auipc	ra,0xfffff
    800043cc:	294080e7          	jalr	660(ra) # 8000365c <killed>
    800043d0:	87aa                	mv	a5,a0
    800043d2:	cb99                	beqz	a5,800043e8 <sys_sleep+0x64>
      release(&tickslock);
    800043d4:	00015517          	auipc	a0,0x15
    800043d8:	59450513          	addi	a0,a0,1428 # 80019968 <tickslock>
    800043dc:	ffffd097          	auipc	ra,0xffffd
    800043e0:	f4c080e7          	jalr	-180(ra) # 80001328 <release>
      return -1;
    800043e4:	57fd                	li	a5,-1
    800043e6:	a099                	j	8000442c <sys_sleep+0xa8>
    }
    sleep(&ticks, &tickslock);
    800043e8:	00015597          	auipc	a1,0x15
    800043ec:	58058593          	addi	a1,a1,1408 # 80019968 <tickslock>
    800043f0:	00007517          	auipc	a0,0x7
    800043f4:	4d850513          	addi	a0,a0,1240 # 8000b8c8 <ticks>
    800043f8:	fffff097          	auipc	ra,0xfffff
    800043fc:	07e080e7          	jalr	126(ra) # 80003476 <sleep>
  while(ticks - ticks0 < n){
    80004400:	00007797          	auipc	a5,0x7
    80004404:	4c878793          	addi	a5,a5,1224 # 8000b8c8 <ticks>
    80004408:	439c                	lw	a5,0(a5)
    8000440a:	fec42703          	lw	a4,-20(s0)
    8000440e:	9f99                	subw	a5,a5,a4
    80004410:	2781                	sext.w	a5,a5
    80004412:	fe842703          	lw	a4,-24(s0)
    80004416:	fae7e3e3          	bltu	a5,a4,800043bc <sys_sleep+0x38>
  }
  release(&tickslock);
    8000441a:	00015517          	auipc	a0,0x15
    8000441e:	54e50513          	addi	a0,a0,1358 # 80019968 <tickslock>
    80004422:	ffffd097          	auipc	ra,0xffffd
    80004426:	f06080e7          	jalr	-250(ra) # 80001328 <release>
  return 0;
    8000442a:	4781                	li	a5,0
}
    8000442c:	853e                	mv	a0,a5
    8000442e:	60e2                	ld	ra,24(sp)
    80004430:	6442                	ld	s0,16(sp)
    80004432:	6105                	addi	sp,sp,32
    80004434:	8082                	ret

0000000080004436 <sys_kill>:

uint64
sys_kill(void)
{
    80004436:	1101                	addi	sp,sp,-32
    80004438:	ec06                	sd	ra,24(sp)
    8000443a:	e822                	sd	s0,16(sp)
    8000443c:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    8000443e:	fec40793          	addi	a5,s0,-20
    80004442:	85be                	mv	a1,a5
    80004444:	4501                	li	a0,0
    80004446:	00000097          	auipc	ra,0x0
    8000444a:	cf0080e7          	jalr	-784(ra) # 80004136 <argint>
  return kill(pid);
    8000444e:	fec42783          	lw	a5,-20(s0)
    80004452:	853e                	mv	a0,a5
    80004454:	fffff097          	auipc	ra,0xfffff
    80004458:	130080e7          	jalr	304(ra) # 80003584 <kill>
    8000445c:	87aa                	mv	a5,a0
}
    8000445e:	853e                	mv	a0,a5
    80004460:	60e2                	ld	ra,24(sp)
    80004462:	6442                	ld	s0,16(sp)
    80004464:	6105                	addi	sp,sp,32
    80004466:	8082                	ret

0000000080004468 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80004468:	1101                	addi	sp,sp,-32
    8000446a:	ec06                	sd	ra,24(sp)
    8000446c:	e822                	sd	s0,16(sp)
    8000446e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80004470:	00015517          	auipc	a0,0x15
    80004474:	4f850513          	addi	a0,a0,1272 # 80019968 <tickslock>
    80004478:	ffffd097          	auipc	ra,0xffffd
    8000447c:	e4c080e7          	jalr	-436(ra) # 800012c4 <acquire>
  xticks = ticks;
    80004480:	00007797          	auipc	a5,0x7
    80004484:	44878793          	addi	a5,a5,1096 # 8000b8c8 <ticks>
    80004488:	439c                	lw	a5,0(a5)
    8000448a:	fef42623          	sw	a5,-20(s0)
  release(&tickslock);
    8000448e:	00015517          	auipc	a0,0x15
    80004492:	4da50513          	addi	a0,a0,1242 # 80019968 <tickslock>
    80004496:	ffffd097          	auipc	ra,0xffffd
    8000449a:	e92080e7          	jalr	-366(ra) # 80001328 <release>
  return xticks;
    8000449e:	fec46783          	lwu	a5,-20(s0)
}
    800044a2:	853e                	mv	a0,a5
    800044a4:	60e2                	ld	ra,24(sp)
    800044a6:	6442                	ld	s0,16(sp)
    800044a8:	6105                	addi	sp,sp,32
    800044aa:	8082                	ret

00000000800044ac <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800044ac:	1101                	addi	sp,sp,-32
    800044ae:	ec06                	sd	ra,24(sp)
    800044b0:	e822                	sd	s0,16(sp)
    800044b2:	1000                	addi	s0,sp,32
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800044b4:	00007597          	auipc	a1,0x7
    800044b8:	f6458593          	addi	a1,a1,-156 # 8000b418 <etext+0x418>
    800044bc:	00015517          	auipc	a0,0x15
    800044c0:	4c450513          	addi	a0,a0,1220 # 80019980 <bcache>
    800044c4:	ffffd097          	auipc	ra,0xffffd
    800044c8:	dcc080e7          	jalr	-564(ra) # 80001290 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800044cc:	00015717          	auipc	a4,0x15
    800044d0:	4b470713          	addi	a4,a4,1204 # 80019980 <bcache>
    800044d4:	67a1                	lui	a5,0x8
    800044d6:	97ba                	add	a5,a5,a4
    800044d8:	0001d717          	auipc	a4,0x1d
    800044dc:	71070713          	addi	a4,a4,1808 # 80021be8 <bcache+0x8268>
    800044e0:	2ae7b823          	sd	a4,688(a5) # 82b0 <_entry-0x7fff7d50>
  bcache.head.next = &bcache.head;
    800044e4:	00015717          	auipc	a4,0x15
    800044e8:	49c70713          	addi	a4,a4,1180 # 80019980 <bcache>
    800044ec:	67a1                	lui	a5,0x8
    800044ee:	97ba                	add	a5,a5,a4
    800044f0:	0001d717          	auipc	a4,0x1d
    800044f4:	6f870713          	addi	a4,a4,1784 # 80021be8 <bcache+0x8268>
    800044f8:	2ae7bc23          	sd	a4,696(a5) # 82b8 <_entry-0x7fff7d48>
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800044fc:	00015797          	auipc	a5,0x15
    80004500:	49c78793          	addi	a5,a5,1180 # 80019998 <bcache+0x18>
    80004504:	fef43423          	sd	a5,-24(s0)
    80004508:	a895                	j	8000457c <binit+0xd0>
    b->next = bcache.head.next;
    8000450a:	00015717          	auipc	a4,0x15
    8000450e:	47670713          	addi	a4,a4,1142 # 80019980 <bcache>
    80004512:	67a1                	lui	a5,0x8
    80004514:	97ba                	add	a5,a5,a4
    80004516:	2b87b703          	ld	a4,696(a5) # 82b8 <_entry-0x7fff7d48>
    8000451a:	fe843783          	ld	a5,-24(s0)
    8000451e:	ebb8                	sd	a4,80(a5)
    b->prev = &bcache.head;
    80004520:	fe843783          	ld	a5,-24(s0)
    80004524:	0001d717          	auipc	a4,0x1d
    80004528:	6c470713          	addi	a4,a4,1732 # 80021be8 <bcache+0x8268>
    8000452c:	e7b8                	sd	a4,72(a5)
    initsleeplock(&b->lock, "buffer");
    8000452e:	fe843783          	ld	a5,-24(s0)
    80004532:	07c1                	addi	a5,a5,16
    80004534:	00007597          	auipc	a1,0x7
    80004538:	eec58593          	addi	a1,a1,-276 # 8000b420 <etext+0x420>
    8000453c:	853e                	mv	a0,a5
    8000453e:	00002097          	auipc	ra,0x2
    80004542:	fe4080e7          	jalr	-28(ra) # 80006522 <initsleeplock>
    bcache.head.next->prev = b;
    80004546:	00015717          	auipc	a4,0x15
    8000454a:	43a70713          	addi	a4,a4,1082 # 80019980 <bcache>
    8000454e:	67a1                	lui	a5,0x8
    80004550:	97ba                	add	a5,a5,a4
    80004552:	2b87b783          	ld	a5,696(a5) # 82b8 <_entry-0x7fff7d48>
    80004556:	fe843703          	ld	a4,-24(s0)
    8000455a:	e7b8                	sd	a4,72(a5)
    bcache.head.next = b;
    8000455c:	00015717          	auipc	a4,0x15
    80004560:	42470713          	addi	a4,a4,1060 # 80019980 <bcache>
    80004564:	67a1                	lui	a5,0x8
    80004566:	97ba                	add	a5,a5,a4
    80004568:	fe843703          	ld	a4,-24(s0)
    8000456c:	2ae7bc23          	sd	a4,696(a5) # 82b8 <_entry-0x7fff7d48>
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80004570:	fe843783          	ld	a5,-24(s0)
    80004574:	45878793          	addi	a5,a5,1112
    80004578:	fef43423          	sd	a5,-24(s0)
    8000457c:	0001d797          	auipc	a5,0x1d
    80004580:	66c78793          	addi	a5,a5,1644 # 80021be8 <bcache+0x8268>
    80004584:	fe843703          	ld	a4,-24(s0)
    80004588:	f8f761e3          	bltu	a4,a5,8000450a <binit+0x5e>
  }
}
    8000458c:	0001                	nop
    8000458e:	0001                	nop
    80004590:	60e2                	ld	ra,24(sp)
    80004592:	6442                	ld	s0,16(sp)
    80004594:	6105                	addi	sp,sp,32
    80004596:	8082                	ret

0000000080004598 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
    80004598:	7179                	addi	sp,sp,-48
    8000459a:	f406                	sd	ra,40(sp)
    8000459c:	f022                	sd	s0,32(sp)
    8000459e:	1800                	addi	s0,sp,48
    800045a0:	87aa                	mv	a5,a0
    800045a2:	872e                	mv	a4,a1
    800045a4:	fcf42e23          	sw	a5,-36(s0)
    800045a8:	87ba                	mv	a5,a4
    800045aa:	fcf42c23          	sw	a5,-40(s0)
  struct buf *b;

  acquire(&bcache.lock);
    800045ae:	00015517          	auipc	a0,0x15
    800045b2:	3d250513          	addi	a0,a0,978 # 80019980 <bcache>
    800045b6:	ffffd097          	auipc	ra,0xffffd
    800045ba:	d0e080e7          	jalr	-754(ra) # 800012c4 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800045be:	00015717          	auipc	a4,0x15
    800045c2:	3c270713          	addi	a4,a4,962 # 80019980 <bcache>
    800045c6:	67a1                	lui	a5,0x8
    800045c8:	97ba                	add	a5,a5,a4
    800045ca:	2b87b783          	ld	a5,696(a5) # 82b8 <_entry-0x7fff7d48>
    800045ce:	fef43423          	sd	a5,-24(s0)
    800045d2:	a095                	j	80004636 <bget+0x9e>
    if(b->dev == dev && b->blockno == blockno){
    800045d4:	fe843783          	ld	a5,-24(s0)
    800045d8:	479c                	lw	a5,8(a5)
    800045da:	fdc42703          	lw	a4,-36(s0)
    800045de:	2701                	sext.w	a4,a4
    800045e0:	04f71663          	bne	a4,a5,8000462c <bget+0x94>
    800045e4:	fe843783          	ld	a5,-24(s0)
    800045e8:	47dc                	lw	a5,12(a5)
    800045ea:	fd842703          	lw	a4,-40(s0)
    800045ee:	2701                	sext.w	a4,a4
    800045f0:	02f71e63          	bne	a4,a5,8000462c <bget+0x94>
      b->refcnt++;
    800045f4:	fe843783          	ld	a5,-24(s0)
    800045f8:	43bc                	lw	a5,64(a5)
    800045fa:	2785                	addiw	a5,a5,1
    800045fc:	0007871b          	sext.w	a4,a5
    80004600:	fe843783          	ld	a5,-24(s0)
    80004604:	c3b8                	sw	a4,64(a5)
      release(&bcache.lock);
    80004606:	00015517          	auipc	a0,0x15
    8000460a:	37a50513          	addi	a0,a0,890 # 80019980 <bcache>
    8000460e:	ffffd097          	auipc	ra,0xffffd
    80004612:	d1a080e7          	jalr	-742(ra) # 80001328 <release>
      acquiresleep(&b->lock);
    80004616:	fe843783          	ld	a5,-24(s0)
    8000461a:	07c1                	addi	a5,a5,16
    8000461c:	853e                	mv	a0,a5
    8000461e:	00002097          	auipc	ra,0x2
    80004622:	f50080e7          	jalr	-176(ra) # 8000656e <acquiresleep>
      return b;
    80004626:	fe843783          	ld	a5,-24(s0)
    8000462a:	a07d                	j	800046d8 <bget+0x140>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000462c:	fe843783          	ld	a5,-24(s0)
    80004630:	6bbc                	ld	a5,80(a5)
    80004632:	fef43423          	sd	a5,-24(s0)
    80004636:	fe843703          	ld	a4,-24(s0)
    8000463a:	0001d797          	auipc	a5,0x1d
    8000463e:	5ae78793          	addi	a5,a5,1454 # 80021be8 <bcache+0x8268>
    80004642:	f8f719e3          	bne	a4,a5,800045d4 <bget+0x3c>
    }
  }

  // Not cached.
  // Recycle the least recently used (LRU) unused buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80004646:	00015717          	auipc	a4,0x15
    8000464a:	33a70713          	addi	a4,a4,826 # 80019980 <bcache>
    8000464e:	67a1                	lui	a5,0x8
    80004650:	97ba                	add	a5,a5,a4
    80004652:	2b07b783          	ld	a5,688(a5) # 82b0 <_entry-0x7fff7d50>
    80004656:	fef43423          	sd	a5,-24(s0)
    8000465a:	a8b9                	j	800046b8 <bget+0x120>
    if(b->refcnt == 0) {
    8000465c:	fe843783          	ld	a5,-24(s0)
    80004660:	43bc                	lw	a5,64(a5)
    80004662:	e7b1                	bnez	a5,800046ae <bget+0x116>
      b->dev = dev;
    80004664:	fe843783          	ld	a5,-24(s0)
    80004668:	fdc42703          	lw	a4,-36(s0)
    8000466c:	c798                	sw	a4,8(a5)
      b->blockno = blockno;
    8000466e:	fe843783          	ld	a5,-24(s0)
    80004672:	fd842703          	lw	a4,-40(s0)
    80004676:	c7d8                	sw	a4,12(a5)
      b->valid = 0;
    80004678:	fe843783          	ld	a5,-24(s0)
    8000467c:	0007a023          	sw	zero,0(a5)
      b->refcnt = 1;
    80004680:	fe843783          	ld	a5,-24(s0)
    80004684:	4705                	li	a4,1
    80004686:	c3b8                	sw	a4,64(a5)
      release(&bcache.lock);
    80004688:	00015517          	auipc	a0,0x15
    8000468c:	2f850513          	addi	a0,a0,760 # 80019980 <bcache>
    80004690:	ffffd097          	auipc	ra,0xffffd
    80004694:	c98080e7          	jalr	-872(ra) # 80001328 <release>
      acquiresleep(&b->lock);
    80004698:	fe843783          	ld	a5,-24(s0)
    8000469c:	07c1                	addi	a5,a5,16
    8000469e:	853e                	mv	a0,a5
    800046a0:	00002097          	auipc	ra,0x2
    800046a4:	ece080e7          	jalr	-306(ra) # 8000656e <acquiresleep>
      return b;
    800046a8:	fe843783          	ld	a5,-24(s0)
    800046ac:	a035                	j	800046d8 <bget+0x140>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800046ae:	fe843783          	ld	a5,-24(s0)
    800046b2:	67bc                	ld	a5,72(a5)
    800046b4:	fef43423          	sd	a5,-24(s0)
    800046b8:	fe843703          	ld	a4,-24(s0)
    800046bc:	0001d797          	auipc	a5,0x1d
    800046c0:	52c78793          	addi	a5,a5,1324 # 80021be8 <bcache+0x8268>
    800046c4:	f8f71ce3          	bne	a4,a5,8000465c <bget+0xc4>
    }
  }
  panic("bget: no buffers");
    800046c8:	00007517          	auipc	a0,0x7
    800046cc:	d6050513          	addi	a0,a0,-672 # 8000b428 <etext+0x428>
    800046d0:	ffffc097          	auipc	ra,0xffffc
    800046d4:	5f0080e7          	jalr	1520(ra) # 80000cc0 <panic>
}
    800046d8:	853e                	mv	a0,a5
    800046da:	70a2                	ld	ra,40(sp)
    800046dc:	7402                	ld	s0,32(sp)
    800046de:	6145                	addi	sp,sp,48
    800046e0:	8082                	ret

00000000800046e2 <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800046e2:	7179                	addi	sp,sp,-48
    800046e4:	f406                	sd	ra,40(sp)
    800046e6:	f022                	sd	s0,32(sp)
    800046e8:	1800                	addi	s0,sp,48
    800046ea:	87aa                	mv	a5,a0
    800046ec:	872e                	mv	a4,a1
    800046ee:	fcf42e23          	sw	a5,-36(s0)
    800046f2:	87ba                	mv	a5,a4
    800046f4:	fcf42c23          	sw	a5,-40(s0)
  struct buf *b;

  b = bget(dev, blockno);
    800046f8:	fd842703          	lw	a4,-40(s0)
    800046fc:	fdc42783          	lw	a5,-36(s0)
    80004700:	85ba                	mv	a1,a4
    80004702:	853e                	mv	a0,a5
    80004704:	00000097          	auipc	ra,0x0
    80004708:	e94080e7          	jalr	-364(ra) # 80004598 <bget>
    8000470c:	fea43423          	sd	a0,-24(s0)
  if(!b->valid) {
    80004710:	fe843783          	ld	a5,-24(s0)
    80004714:	439c                	lw	a5,0(a5)
    80004716:	ef81                	bnez	a5,8000472e <bread+0x4c>
    virtio_disk_rw(b, 0);
    80004718:	4581                	li	a1,0
    8000471a:	fe843503          	ld	a0,-24(s0)
    8000471e:	00005097          	auipc	ra,0x5
    80004722:	82c080e7          	jalr	-2004(ra) # 80008f4a <virtio_disk_rw>
    b->valid = 1;
    80004726:	fe843783          	ld	a5,-24(s0)
    8000472a:	4705                	li	a4,1
    8000472c:	c398                	sw	a4,0(a5)
  }
  return b;
    8000472e:	fe843783          	ld	a5,-24(s0)
}
    80004732:	853e                	mv	a0,a5
    80004734:	70a2                	ld	ra,40(sp)
    80004736:	7402                	ld	s0,32(sp)
    80004738:	6145                	addi	sp,sp,48
    8000473a:	8082                	ret

000000008000473c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000473c:	1101                	addi	sp,sp,-32
    8000473e:	ec06                	sd	ra,24(sp)
    80004740:	e822                	sd	s0,16(sp)
    80004742:	1000                	addi	s0,sp,32
    80004744:	fea43423          	sd	a0,-24(s0)
  if(!holdingsleep(&b->lock))
    80004748:	fe843783          	ld	a5,-24(s0)
    8000474c:	07c1                	addi	a5,a5,16
    8000474e:	853e                	mv	a0,a5
    80004750:	00002097          	auipc	ra,0x2
    80004754:	ede080e7          	jalr	-290(ra) # 8000662e <holdingsleep>
    80004758:	87aa                	mv	a5,a0
    8000475a:	eb89                	bnez	a5,8000476c <bwrite+0x30>
    panic("bwrite");
    8000475c:	00007517          	auipc	a0,0x7
    80004760:	ce450513          	addi	a0,a0,-796 # 8000b440 <etext+0x440>
    80004764:	ffffc097          	auipc	ra,0xffffc
    80004768:	55c080e7          	jalr	1372(ra) # 80000cc0 <panic>
  virtio_disk_rw(b, 1);
    8000476c:	4585                	li	a1,1
    8000476e:	fe843503          	ld	a0,-24(s0)
    80004772:	00004097          	auipc	ra,0x4
    80004776:	7d8080e7          	jalr	2008(ra) # 80008f4a <virtio_disk_rw>
}
    8000477a:	0001                	nop
    8000477c:	60e2                	ld	ra,24(sp)
    8000477e:	6442                	ld	s0,16(sp)
    80004780:	6105                	addi	sp,sp,32
    80004782:	8082                	ret

0000000080004784 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80004784:	1101                	addi	sp,sp,-32
    80004786:	ec06                	sd	ra,24(sp)
    80004788:	e822                	sd	s0,16(sp)
    8000478a:	1000                	addi	s0,sp,32
    8000478c:	fea43423          	sd	a0,-24(s0)
  if(!holdingsleep(&b->lock))
    80004790:	fe843783          	ld	a5,-24(s0)
    80004794:	07c1                	addi	a5,a5,16
    80004796:	853e                	mv	a0,a5
    80004798:	00002097          	auipc	ra,0x2
    8000479c:	e96080e7          	jalr	-362(ra) # 8000662e <holdingsleep>
    800047a0:	87aa                	mv	a5,a0
    800047a2:	eb89                	bnez	a5,800047b4 <brelse+0x30>
    panic("brelse");
    800047a4:	00007517          	auipc	a0,0x7
    800047a8:	ca450513          	addi	a0,a0,-860 # 8000b448 <etext+0x448>
    800047ac:	ffffc097          	auipc	ra,0xffffc
    800047b0:	514080e7          	jalr	1300(ra) # 80000cc0 <panic>

  releasesleep(&b->lock);
    800047b4:	fe843783          	ld	a5,-24(s0)
    800047b8:	07c1                	addi	a5,a5,16
    800047ba:	853e                	mv	a0,a5
    800047bc:	00002097          	auipc	ra,0x2
    800047c0:	e20080e7          	jalr	-480(ra) # 800065dc <releasesleep>

  acquire(&bcache.lock);
    800047c4:	00015517          	auipc	a0,0x15
    800047c8:	1bc50513          	addi	a0,a0,444 # 80019980 <bcache>
    800047cc:	ffffd097          	auipc	ra,0xffffd
    800047d0:	af8080e7          	jalr	-1288(ra) # 800012c4 <acquire>
  b->refcnt--;
    800047d4:	fe843783          	ld	a5,-24(s0)
    800047d8:	43bc                	lw	a5,64(a5)
    800047da:	37fd                	addiw	a5,a5,-1
    800047dc:	0007871b          	sext.w	a4,a5
    800047e0:	fe843783          	ld	a5,-24(s0)
    800047e4:	c3b8                	sw	a4,64(a5)
  if (b->refcnt == 0) {
    800047e6:	fe843783          	ld	a5,-24(s0)
    800047ea:	43bc                	lw	a5,64(a5)
    800047ec:	e7b5                	bnez	a5,80004858 <brelse+0xd4>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800047ee:	fe843783          	ld	a5,-24(s0)
    800047f2:	6bbc                	ld	a5,80(a5)
    800047f4:	fe843703          	ld	a4,-24(s0)
    800047f8:	6738                	ld	a4,72(a4)
    800047fa:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800047fc:	fe843783          	ld	a5,-24(s0)
    80004800:	67bc                	ld	a5,72(a5)
    80004802:	fe843703          	ld	a4,-24(s0)
    80004806:	6b38                	ld	a4,80(a4)
    80004808:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000480a:	00015717          	auipc	a4,0x15
    8000480e:	17670713          	addi	a4,a4,374 # 80019980 <bcache>
    80004812:	67a1                	lui	a5,0x8
    80004814:	97ba                	add	a5,a5,a4
    80004816:	2b87b703          	ld	a4,696(a5) # 82b8 <_entry-0x7fff7d48>
    8000481a:	fe843783          	ld	a5,-24(s0)
    8000481e:	ebb8                	sd	a4,80(a5)
    b->prev = &bcache.head;
    80004820:	fe843783          	ld	a5,-24(s0)
    80004824:	0001d717          	auipc	a4,0x1d
    80004828:	3c470713          	addi	a4,a4,964 # 80021be8 <bcache+0x8268>
    8000482c:	e7b8                	sd	a4,72(a5)
    bcache.head.next->prev = b;
    8000482e:	00015717          	auipc	a4,0x15
    80004832:	15270713          	addi	a4,a4,338 # 80019980 <bcache>
    80004836:	67a1                	lui	a5,0x8
    80004838:	97ba                	add	a5,a5,a4
    8000483a:	2b87b783          	ld	a5,696(a5) # 82b8 <_entry-0x7fff7d48>
    8000483e:	fe843703          	ld	a4,-24(s0)
    80004842:	e7b8                	sd	a4,72(a5)
    bcache.head.next = b;
    80004844:	00015717          	auipc	a4,0x15
    80004848:	13c70713          	addi	a4,a4,316 # 80019980 <bcache>
    8000484c:	67a1                	lui	a5,0x8
    8000484e:	97ba                	add	a5,a5,a4
    80004850:	fe843703          	ld	a4,-24(s0)
    80004854:	2ae7bc23          	sd	a4,696(a5) # 82b8 <_entry-0x7fff7d48>
  }
  
  release(&bcache.lock);
    80004858:	00015517          	auipc	a0,0x15
    8000485c:	12850513          	addi	a0,a0,296 # 80019980 <bcache>
    80004860:	ffffd097          	auipc	ra,0xffffd
    80004864:	ac8080e7          	jalr	-1336(ra) # 80001328 <release>
}
    80004868:	0001                	nop
    8000486a:	60e2                	ld	ra,24(sp)
    8000486c:	6442                	ld	s0,16(sp)
    8000486e:	6105                	addi	sp,sp,32
    80004870:	8082                	ret

0000000080004872 <bpin>:

void
bpin(struct buf *b) {
    80004872:	1101                	addi	sp,sp,-32
    80004874:	ec06                	sd	ra,24(sp)
    80004876:	e822                	sd	s0,16(sp)
    80004878:	1000                	addi	s0,sp,32
    8000487a:	fea43423          	sd	a0,-24(s0)
  acquire(&bcache.lock);
    8000487e:	00015517          	auipc	a0,0x15
    80004882:	10250513          	addi	a0,a0,258 # 80019980 <bcache>
    80004886:	ffffd097          	auipc	ra,0xffffd
    8000488a:	a3e080e7          	jalr	-1474(ra) # 800012c4 <acquire>
  b->refcnt++;
    8000488e:	fe843783          	ld	a5,-24(s0)
    80004892:	43bc                	lw	a5,64(a5)
    80004894:	2785                	addiw	a5,a5,1
    80004896:	0007871b          	sext.w	a4,a5
    8000489a:	fe843783          	ld	a5,-24(s0)
    8000489e:	c3b8                	sw	a4,64(a5)
  release(&bcache.lock);
    800048a0:	00015517          	auipc	a0,0x15
    800048a4:	0e050513          	addi	a0,a0,224 # 80019980 <bcache>
    800048a8:	ffffd097          	auipc	ra,0xffffd
    800048ac:	a80080e7          	jalr	-1408(ra) # 80001328 <release>
}
    800048b0:	0001                	nop
    800048b2:	60e2                	ld	ra,24(sp)
    800048b4:	6442                	ld	s0,16(sp)
    800048b6:	6105                	addi	sp,sp,32
    800048b8:	8082                	ret

00000000800048ba <bunpin>:

void
bunpin(struct buf *b) {
    800048ba:	1101                	addi	sp,sp,-32
    800048bc:	ec06                	sd	ra,24(sp)
    800048be:	e822                	sd	s0,16(sp)
    800048c0:	1000                	addi	s0,sp,32
    800048c2:	fea43423          	sd	a0,-24(s0)
  acquire(&bcache.lock);
    800048c6:	00015517          	auipc	a0,0x15
    800048ca:	0ba50513          	addi	a0,a0,186 # 80019980 <bcache>
    800048ce:	ffffd097          	auipc	ra,0xffffd
    800048d2:	9f6080e7          	jalr	-1546(ra) # 800012c4 <acquire>
  b->refcnt--;
    800048d6:	fe843783          	ld	a5,-24(s0)
    800048da:	43bc                	lw	a5,64(a5)
    800048dc:	37fd                	addiw	a5,a5,-1
    800048de:	0007871b          	sext.w	a4,a5
    800048e2:	fe843783          	ld	a5,-24(s0)
    800048e6:	c3b8                	sw	a4,64(a5)
  release(&bcache.lock);
    800048e8:	00015517          	auipc	a0,0x15
    800048ec:	09850513          	addi	a0,a0,152 # 80019980 <bcache>
    800048f0:	ffffd097          	auipc	ra,0xffffd
    800048f4:	a38080e7          	jalr	-1480(ra) # 80001328 <release>
}
    800048f8:	0001                	nop
    800048fa:	60e2                	ld	ra,24(sp)
    800048fc:	6442                	ld	s0,16(sp)
    800048fe:	6105                	addi	sp,sp,32
    80004900:	8082                	ret

0000000080004902 <readsb>:
struct superblock sb; 

// Read the super block.
static void
readsb(int dev, struct superblock *sb)
{
    80004902:	7179                	addi	sp,sp,-48
    80004904:	f406                	sd	ra,40(sp)
    80004906:	f022                	sd	s0,32(sp)
    80004908:	1800                	addi	s0,sp,48
    8000490a:	87aa                	mv	a5,a0
    8000490c:	fcb43823          	sd	a1,-48(s0)
    80004910:	fcf42e23          	sw	a5,-36(s0)
  struct buf *bp;

  bp = bread(dev, 1);
    80004914:	fdc42783          	lw	a5,-36(s0)
    80004918:	4585                	li	a1,1
    8000491a:	853e                	mv	a0,a5
    8000491c:	00000097          	auipc	ra,0x0
    80004920:	dc6080e7          	jalr	-570(ra) # 800046e2 <bread>
    80004924:	fea43423          	sd	a0,-24(s0)
  memmove(sb, bp->data, sizeof(*sb));
    80004928:	fe843783          	ld	a5,-24(s0)
    8000492c:	05878793          	addi	a5,a5,88
    80004930:	02000613          	li	a2,32
    80004934:	85be                	mv	a1,a5
    80004936:	fd043503          	ld	a0,-48(s0)
    8000493a:	ffffd097          	auipc	ra,0xffffd
    8000493e:	c4a080e7          	jalr	-950(ra) # 80001584 <memmove>
  brelse(bp);
    80004942:	fe843503          	ld	a0,-24(s0)
    80004946:	00000097          	auipc	ra,0x0
    8000494a:	e3e080e7          	jalr	-450(ra) # 80004784 <brelse>
}
    8000494e:	0001                	nop
    80004950:	70a2                	ld	ra,40(sp)
    80004952:	7402                	ld	s0,32(sp)
    80004954:	6145                	addi	sp,sp,48
    80004956:	8082                	ret

0000000080004958 <fsinit>:

// Init fs
void
fsinit(int dev) {
    80004958:	1101                	addi	sp,sp,-32
    8000495a:	ec06                	sd	ra,24(sp)
    8000495c:	e822                	sd	s0,16(sp)
    8000495e:	1000                	addi	s0,sp,32
    80004960:	87aa                	mv	a5,a0
    80004962:	fef42623          	sw	a5,-20(s0)
  readsb(dev, &sb);
    80004966:	fec42783          	lw	a5,-20(s0)
    8000496a:	0001d597          	auipc	a1,0x1d
    8000496e:	6d658593          	addi	a1,a1,1750 # 80022040 <sb>
    80004972:	853e                	mv	a0,a5
    80004974:	00000097          	auipc	ra,0x0
    80004978:	f8e080e7          	jalr	-114(ra) # 80004902 <readsb>
  if(sb.magic != FSMAGIC)
    8000497c:	0001d797          	auipc	a5,0x1d
    80004980:	6c478793          	addi	a5,a5,1732 # 80022040 <sb>
    80004984:	4398                	lw	a4,0(a5)
    80004986:	102037b7          	lui	a5,0x10203
    8000498a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000498e:	00f70a63          	beq	a4,a5,800049a2 <fsinit+0x4a>
    panic("invalid file system");
    80004992:	00007517          	auipc	a0,0x7
    80004996:	abe50513          	addi	a0,a0,-1346 # 8000b450 <etext+0x450>
    8000499a:	ffffc097          	auipc	ra,0xffffc
    8000499e:	326080e7          	jalr	806(ra) # 80000cc0 <panic>
  initlog(dev, &sb);
    800049a2:	fec42783          	lw	a5,-20(s0)
    800049a6:	0001d597          	auipc	a1,0x1d
    800049aa:	69a58593          	addi	a1,a1,1690 # 80022040 <sb>
    800049ae:	853e                	mv	a0,a5
    800049b0:	00001097          	auipc	ra,0x1
    800049b4:	478080e7          	jalr	1144(ra) # 80005e28 <initlog>
}
    800049b8:	0001                	nop
    800049ba:	60e2                	ld	ra,24(sp)
    800049bc:	6442                	ld	s0,16(sp)
    800049be:	6105                	addi	sp,sp,32
    800049c0:	8082                	ret

00000000800049c2 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
    800049c2:	7179                	addi	sp,sp,-48
    800049c4:	f406                	sd	ra,40(sp)
    800049c6:	f022                	sd	s0,32(sp)
    800049c8:	1800                	addi	s0,sp,48
    800049ca:	87aa                	mv	a5,a0
    800049cc:	872e                	mv	a4,a1
    800049ce:	fcf42e23          	sw	a5,-36(s0)
    800049d2:	87ba                	mv	a5,a4
    800049d4:	fcf42c23          	sw	a5,-40(s0)
  struct buf *bp;

  bp = bread(dev, bno);
    800049d8:	fdc42783          	lw	a5,-36(s0)
    800049dc:	fd842703          	lw	a4,-40(s0)
    800049e0:	85ba                	mv	a1,a4
    800049e2:	853e                	mv	a0,a5
    800049e4:	00000097          	auipc	ra,0x0
    800049e8:	cfe080e7          	jalr	-770(ra) # 800046e2 <bread>
    800049ec:	fea43423          	sd	a0,-24(s0)
  memset(bp->data, 0, BSIZE);
    800049f0:	fe843783          	ld	a5,-24(s0)
    800049f4:	05878793          	addi	a5,a5,88
    800049f8:	40000613          	li	a2,1024
    800049fc:	4581                	li	a1,0
    800049fe:	853e                	mv	a0,a5
    80004a00:	ffffd097          	auipc	ra,0xffffd
    80004a04:	a98080e7          	jalr	-1384(ra) # 80001498 <memset>
  log_write(bp);
    80004a08:	fe843503          	ld	a0,-24(s0)
    80004a0c:	00002097          	auipc	ra,0x2
    80004a10:	9e8080e7          	jalr	-1560(ra) # 800063f4 <log_write>
  brelse(bp);
    80004a14:	fe843503          	ld	a0,-24(s0)
    80004a18:	00000097          	auipc	ra,0x0
    80004a1c:	d6c080e7          	jalr	-660(ra) # 80004784 <brelse>
}
    80004a20:	0001                	nop
    80004a22:	70a2                	ld	ra,40(sp)
    80004a24:	7402                	ld	s0,32(sp)
    80004a26:	6145                	addi	sp,sp,48
    80004a28:	8082                	ret

0000000080004a2a <balloc>:

// Allocate a zeroed disk block.
// returns 0 if out of disk space.
static uint
balloc(uint dev)
{
    80004a2a:	7139                	addi	sp,sp,-64
    80004a2c:	fc06                	sd	ra,56(sp)
    80004a2e:	f822                	sd	s0,48(sp)
    80004a30:	0080                	addi	s0,sp,64
    80004a32:	87aa                	mv	a5,a0
    80004a34:	fcf42623          	sw	a5,-52(s0)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
    80004a38:	fe043023          	sd	zero,-32(s0)
  for(b = 0; b < sb.size; b += BPB){
    80004a3c:	fe042623          	sw	zero,-20(s0)
    80004a40:	aab9                	j	80004b9e <balloc+0x174>
    bp = bread(dev, BBLOCK(b, sb));
    80004a42:	fec42783          	lw	a5,-20(s0)
    80004a46:	41f7d71b          	sraiw	a4,a5,0x1f
    80004a4a:	0137571b          	srliw	a4,a4,0x13
    80004a4e:	9fb9                	addw	a5,a5,a4
    80004a50:	40d7d79b          	sraiw	a5,a5,0xd
    80004a54:	2781                	sext.w	a5,a5
    80004a56:	873e                	mv	a4,a5
    80004a58:	0001d797          	auipc	a5,0x1d
    80004a5c:	5e878793          	addi	a5,a5,1512 # 80022040 <sb>
    80004a60:	4fdc                	lw	a5,28(a5)
    80004a62:	9fb9                	addw	a5,a5,a4
    80004a64:	0007871b          	sext.w	a4,a5
    80004a68:	fcc42783          	lw	a5,-52(s0)
    80004a6c:	85ba                	mv	a1,a4
    80004a6e:	853e                	mv	a0,a5
    80004a70:	00000097          	auipc	ra,0x0
    80004a74:	c72080e7          	jalr	-910(ra) # 800046e2 <bread>
    80004a78:	fea43023          	sd	a0,-32(s0)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80004a7c:	fe042423          	sw	zero,-24(s0)
    80004a80:	a8e1                	j	80004b58 <balloc+0x12e>
      m = 1 << (bi % 8);
    80004a82:	fe842783          	lw	a5,-24(s0)
    80004a86:	8b9d                	andi	a5,a5,7
    80004a88:	2781                	sext.w	a5,a5
    80004a8a:	4705                	li	a4,1
    80004a8c:	00f717bb          	sllw	a5,a4,a5
    80004a90:	fcf42e23          	sw	a5,-36(s0)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80004a94:	fe842783          	lw	a5,-24(s0)
    80004a98:	41f7d71b          	sraiw	a4,a5,0x1f
    80004a9c:	01d7571b          	srliw	a4,a4,0x1d
    80004aa0:	9fb9                	addw	a5,a5,a4
    80004aa2:	4037d79b          	sraiw	a5,a5,0x3
    80004aa6:	2781                	sext.w	a5,a5
    80004aa8:	fe043703          	ld	a4,-32(s0)
    80004aac:	97ba                	add	a5,a5,a4
    80004aae:	0587c783          	lbu	a5,88(a5)
    80004ab2:	2781                	sext.w	a5,a5
    80004ab4:	fdc42703          	lw	a4,-36(s0)
    80004ab8:	8ff9                	and	a5,a5,a4
    80004aba:	2781                	sext.w	a5,a5
    80004abc:	ebc9                	bnez	a5,80004b4e <balloc+0x124>
        bp->data[bi/8] |= m;  // Mark block in use.
    80004abe:	fe842783          	lw	a5,-24(s0)
    80004ac2:	41f7d71b          	sraiw	a4,a5,0x1f
    80004ac6:	01d7571b          	srliw	a4,a4,0x1d
    80004aca:	9fb9                	addw	a5,a5,a4
    80004acc:	4037d79b          	sraiw	a5,a5,0x3
    80004ad0:	2781                	sext.w	a5,a5
    80004ad2:	fe043703          	ld	a4,-32(s0)
    80004ad6:	973e                	add	a4,a4,a5
    80004ad8:	05874703          	lbu	a4,88(a4)
    80004adc:	0187169b          	slliw	a3,a4,0x18
    80004ae0:	4186d69b          	sraiw	a3,a3,0x18
    80004ae4:	fdc42703          	lw	a4,-36(s0)
    80004ae8:	0187171b          	slliw	a4,a4,0x18
    80004aec:	4187571b          	sraiw	a4,a4,0x18
    80004af0:	8f55                	or	a4,a4,a3
    80004af2:	0187171b          	slliw	a4,a4,0x18
    80004af6:	4187571b          	sraiw	a4,a4,0x18
    80004afa:	0ff77713          	zext.b	a4,a4
    80004afe:	fe043683          	ld	a3,-32(s0)
    80004b02:	97b6                	add	a5,a5,a3
    80004b04:	04e78c23          	sb	a4,88(a5)
        log_write(bp);
    80004b08:	fe043503          	ld	a0,-32(s0)
    80004b0c:	00002097          	auipc	ra,0x2
    80004b10:	8e8080e7          	jalr	-1816(ra) # 800063f4 <log_write>
        brelse(bp);
    80004b14:	fe043503          	ld	a0,-32(s0)
    80004b18:	00000097          	auipc	ra,0x0
    80004b1c:	c6c080e7          	jalr	-916(ra) # 80004784 <brelse>
        bzero(dev, b + bi);
    80004b20:	fcc42783          	lw	a5,-52(s0)
    80004b24:	fec42703          	lw	a4,-20(s0)
    80004b28:	86ba                	mv	a3,a4
    80004b2a:	fe842703          	lw	a4,-24(s0)
    80004b2e:	9f35                	addw	a4,a4,a3
    80004b30:	2701                	sext.w	a4,a4
    80004b32:	85ba                	mv	a1,a4
    80004b34:	853e                	mv	a0,a5
    80004b36:	00000097          	auipc	ra,0x0
    80004b3a:	e8c080e7          	jalr	-372(ra) # 800049c2 <bzero>
        return b + bi;
    80004b3e:	fec42783          	lw	a5,-20(s0)
    80004b42:	873e                	mv	a4,a5
    80004b44:	fe842783          	lw	a5,-24(s0)
    80004b48:	9fb9                	addw	a5,a5,a4
    80004b4a:	2781                	sext.w	a5,a5
    80004b4c:	a89d                	j	80004bc2 <balloc+0x198>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80004b4e:	fe842783          	lw	a5,-24(s0)
    80004b52:	2785                	addiw	a5,a5,1
    80004b54:	fef42423          	sw	a5,-24(s0)
    80004b58:	fe842783          	lw	a5,-24(s0)
    80004b5c:	0007871b          	sext.w	a4,a5
    80004b60:	6789                	lui	a5,0x2
    80004b62:	02f75163          	bge	a4,a5,80004b84 <balloc+0x15a>
    80004b66:	fec42783          	lw	a5,-20(s0)
    80004b6a:	873e                	mv	a4,a5
    80004b6c:	fe842783          	lw	a5,-24(s0)
    80004b70:	9fb9                	addw	a5,a5,a4
    80004b72:	2781                	sext.w	a5,a5
    80004b74:	873e                	mv	a4,a5
    80004b76:	0001d797          	auipc	a5,0x1d
    80004b7a:	4ca78793          	addi	a5,a5,1226 # 80022040 <sb>
    80004b7e:	43dc                	lw	a5,4(a5)
    80004b80:	f0f761e3          	bltu	a4,a5,80004a82 <balloc+0x58>
      }
    }
    brelse(bp);
    80004b84:	fe043503          	ld	a0,-32(s0)
    80004b88:	00000097          	auipc	ra,0x0
    80004b8c:	bfc080e7          	jalr	-1028(ra) # 80004784 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80004b90:	fec42783          	lw	a5,-20(s0)
    80004b94:	873e                	mv	a4,a5
    80004b96:	6789                	lui	a5,0x2
    80004b98:	9fb9                	addw	a5,a5,a4
    80004b9a:	fef42623          	sw	a5,-20(s0)
    80004b9e:	0001d797          	auipc	a5,0x1d
    80004ba2:	4a278793          	addi	a5,a5,1186 # 80022040 <sb>
    80004ba6:	43d8                	lw	a4,4(a5)
    80004ba8:	fec42783          	lw	a5,-20(s0)
    80004bac:	e8e7ebe3          	bltu	a5,a4,80004a42 <balloc+0x18>
  }
  printf("balloc: out of blocks\n");
    80004bb0:	00007517          	auipc	a0,0x7
    80004bb4:	8b850513          	addi	a0,a0,-1864 # 8000b468 <etext+0x468>
    80004bb8:	ffffc097          	auipc	ra,0xffffc
    80004bbc:	eb2080e7          	jalr	-334(ra) # 80000a6a <printf>
  return 0;
    80004bc0:	4781                	li	a5,0
}
    80004bc2:	853e                	mv	a0,a5
    80004bc4:	70e2                	ld	ra,56(sp)
    80004bc6:	7442                	ld	s0,48(sp)
    80004bc8:	6121                	addi	sp,sp,64
    80004bca:	8082                	ret

0000000080004bcc <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80004bcc:	7179                	addi	sp,sp,-48
    80004bce:	f406                	sd	ra,40(sp)
    80004bd0:	f022                	sd	s0,32(sp)
    80004bd2:	1800                	addi	s0,sp,48
    80004bd4:	87aa                	mv	a5,a0
    80004bd6:	872e                	mv	a4,a1
    80004bd8:	fcf42e23          	sw	a5,-36(s0)
    80004bdc:	87ba                	mv	a5,a4
    80004bde:	fcf42c23          	sw	a5,-40(s0)
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80004be2:	fdc42683          	lw	a3,-36(s0)
    80004be6:	fd842783          	lw	a5,-40(s0)
    80004bea:	00d7d79b          	srliw	a5,a5,0xd
    80004bee:	0007871b          	sext.w	a4,a5
    80004bf2:	0001d797          	auipc	a5,0x1d
    80004bf6:	44e78793          	addi	a5,a5,1102 # 80022040 <sb>
    80004bfa:	4fdc                	lw	a5,28(a5)
    80004bfc:	9fb9                	addw	a5,a5,a4
    80004bfe:	2781                	sext.w	a5,a5
    80004c00:	85be                	mv	a1,a5
    80004c02:	8536                	mv	a0,a3
    80004c04:	00000097          	auipc	ra,0x0
    80004c08:	ade080e7          	jalr	-1314(ra) # 800046e2 <bread>
    80004c0c:	fea43423          	sd	a0,-24(s0)
  bi = b % BPB;
    80004c10:	fd842703          	lw	a4,-40(s0)
    80004c14:	6789                	lui	a5,0x2
    80004c16:	17fd                	addi	a5,a5,-1 # 1fff <_entry-0x7fffe001>
    80004c18:	8ff9                	and	a5,a5,a4
    80004c1a:	fef42223          	sw	a5,-28(s0)
  m = 1 << (bi % 8);
    80004c1e:	fe442783          	lw	a5,-28(s0)
    80004c22:	8b9d                	andi	a5,a5,7
    80004c24:	2781                	sext.w	a5,a5
    80004c26:	4705                	li	a4,1
    80004c28:	00f717bb          	sllw	a5,a4,a5
    80004c2c:	fef42023          	sw	a5,-32(s0)
  if((bp->data[bi/8] & m) == 0)
    80004c30:	fe442783          	lw	a5,-28(s0)
    80004c34:	41f7d71b          	sraiw	a4,a5,0x1f
    80004c38:	01d7571b          	srliw	a4,a4,0x1d
    80004c3c:	9fb9                	addw	a5,a5,a4
    80004c3e:	4037d79b          	sraiw	a5,a5,0x3
    80004c42:	2781                	sext.w	a5,a5
    80004c44:	fe843703          	ld	a4,-24(s0)
    80004c48:	97ba                	add	a5,a5,a4
    80004c4a:	0587c783          	lbu	a5,88(a5)
    80004c4e:	2781                	sext.w	a5,a5
    80004c50:	fe042703          	lw	a4,-32(s0)
    80004c54:	8ff9                	and	a5,a5,a4
    80004c56:	2781                	sext.w	a5,a5
    80004c58:	eb89                	bnez	a5,80004c6a <bfree+0x9e>
    panic("freeing free block");
    80004c5a:	00007517          	auipc	a0,0x7
    80004c5e:	82650513          	addi	a0,a0,-2010 # 8000b480 <etext+0x480>
    80004c62:	ffffc097          	auipc	ra,0xffffc
    80004c66:	05e080e7          	jalr	94(ra) # 80000cc0 <panic>
  bp->data[bi/8] &= ~m;
    80004c6a:	fe442783          	lw	a5,-28(s0)
    80004c6e:	41f7d71b          	sraiw	a4,a5,0x1f
    80004c72:	01d7571b          	srliw	a4,a4,0x1d
    80004c76:	9fb9                	addw	a5,a5,a4
    80004c78:	4037d79b          	sraiw	a5,a5,0x3
    80004c7c:	2781                	sext.w	a5,a5
    80004c7e:	fe843703          	ld	a4,-24(s0)
    80004c82:	973e                	add	a4,a4,a5
    80004c84:	05874703          	lbu	a4,88(a4)
    80004c88:	0187169b          	slliw	a3,a4,0x18
    80004c8c:	4186d69b          	sraiw	a3,a3,0x18
    80004c90:	fe042703          	lw	a4,-32(s0)
    80004c94:	0187171b          	slliw	a4,a4,0x18
    80004c98:	4187571b          	sraiw	a4,a4,0x18
    80004c9c:	fff74713          	not	a4,a4
    80004ca0:	0187171b          	slliw	a4,a4,0x18
    80004ca4:	4187571b          	sraiw	a4,a4,0x18
    80004ca8:	8f75                	and	a4,a4,a3
    80004caa:	0187171b          	slliw	a4,a4,0x18
    80004cae:	4187571b          	sraiw	a4,a4,0x18
    80004cb2:	0ff77713          	zext.b	a4,a4
    80004cb6:	fe843683          	ld	a3,-24(s0)
    80004cba:	97b6                	add	a5,a5,a3
    80004cbc:	04e78c23          	sb	a4,88(a5)
  log_write(bp);
    80004cc0:	fe843503          	ld	a0,-24(s0)
    80004cc4:	00001097          	auipc	ra,0x1
    80004cc8:	730080e7          	jalr	1840(ra) # 800063f4 <log_write>
  brelse(bp);
    80004ccc:	fe843503          	ld	a0,-24(s0)
    80004cd0:	00000097          	auipc	ra,0x0
    80004cd4:	ab4080e7          	jalr	-1356(ra) # 80004784 <brelse>
}
    80004cd8:	0001                	nop
    80004cda:	70a2                	ld	ra,40(sp)
    80004cdc:	7402                	ld	s0,32(sp)
    80004cde:	6145                	addi	sp,sp,48
    80004ce0:	8082                	ret

0000000080004ce2 <iinit>:
  struct inode inode[NINODE];
} itable;

void
iinit()
{
    80004ce2:	1101                	addi	sp,sp,-32
    80004ce4:	ec06                	sd	ra,24(sp)
    80004ce6:	e822                	sd	s0,16(sp)
    80004ce8:	1000                	addi	s0,sp,32
  int i = 0;
    80004cea:	fe042623          	sw	zero,-20(s0)
  
  initlock(&itable.lock, "itable");
    80004cee:	00006597          	auipc	a1,0x6
    80004cf2:	7aa58593          	addi	a1,a1,1962 # 8000b498 <etext+0x498>
    80004cf6:	0001d517          	auipc	a0,0x1d
    80004cfa:	36a50513          	addi	a0,a0,874 # 80022060 <itable>
    80004cfe:	ffffc097          	auipc	ra,0xffffc
    80004d02:	592080e7          	jalr	1426(ra) # 80001290 <initlock>
  for(i = 0; i < NINODE; i++) {
    80004d06:	fe042623          	sw	zero,-20(s0)
    80004d0a:	a82d                	j	80004d44 <iinit+0x62>
    initsleeplock(&itable.inode[i].lock, "inode");
    80004d0c:	fec42703          	lw	a4,-20(s0)
    80004d10:	87ba                	mv	a5,a4
    80004d12:	0792                	slli	a5,a5,0x4
    80004d14:	97ba                	add	a5,a5,a4
    80004d16:	078e                	slli	a5,a5,0x3
    80004d18:	02078713          	addi	a4,a5,32
    80004d1c:	0001d797          	auipc	a5,0x1d
    80004d20:	34478793          	addi	a5,a5,836 # 80022060 <itable>
    80004d24:	97ba                	add	a5,a5,a4
    80004d26:	07a1                	addi	a5,a5,8
    80004d28:	00006597          	auipc	a1,0x6
    80004d2c:	77858593          	addi	a1,a1,1912 # 8000b4a0 <etext+0x4a0>
    80004d30:	853e                	mv	a0,a5
    80004d32:	00001097          	auipc	ra,0x1
    80004d36:	7f0080e7          	jalr	2032(ra) # 80006522 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80004d3a:	fec42783          	lw	a5,-20(s0)
    80004d3e:	2785                	addiw	a5,a5,1
    80004d40:	fef42623          	sw	a5,-20(s0)
    80004d44:	fec42783          	lw	a5,-20(s0)
    80004d48:	0007871b          	sext.w	a4,a5
    80004d4c:	03100793          	li	a5,49
    80004d50:	fae7dee3          	bge	a5,a4,80004d0c <iinit+0x2a>
  }
}
    80004d54:	0001                	nop
    80004d56:	0001                	nop
    80004d58:	60e2                	ld	ra,24(sp)
    80004d5a:	6442                	ld	s0,16(sp)
    80004d5c:	6105                	addi	sp,sp,32
    80004d5e:	8082                	ret

0000000080004d60 <ialloc>:
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode,
// or NULL if there is no free inode.
struct inode*
ialloc(uint dev, short type)
{
    80004d60:	7139                	addi	sp,sp,-64
    80004d62:	fc06                	sd	ra,56(sp)
    80004d64:	f822                	sd	s0,48(sp)
    80004d66:	0080                	addi	s0,sp,64
    80004d68:	87aa                	mv	a5,a0
    80004d6a:	872e                	mv	a4,a1
    80004d6c:	fcf42623          	sw	a5,-52(s0)
    80004d70:	87ba                	mv	a5,a4
    80004d72:	fcf41523          	sh	a5,-54(s0)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    80004d76:	4785                	li	a5,1
    80004d78:	fef42623          	sw	a5,-20(s0)
    80004d7c:	a855                	j	80004e30 <ialloc+0xd0>
    bp = bread(dev, IBLOCK(inum, sb));
    80004d7e:	fec42783          	lw	a5,-20(s0)
    80004d82:	8391                	srli	a5,a5,0x4
    80004d84:	0007871b          	sext.w	a4,a5
    80004d88:	0001d797          	auipc	a5,0x1d
    80004d8c:	2b878793          	addi	a5,a5,696 # 80022040 <sb>
    80004d90:	4f9c                	lw	a5,24(a5)
    80004d92:	9fb9                	addw	a5,a5,a4
    80004d94:	0007871b          	sext.w	a4,a5
    80004d98:	fcc42783          	lw	a5,-52(s0)
    80004d9c:	85ba                	mv	a1,a4
    80004d9e:	853e                	mv	a0,a5
    80004da0:	00000097          	auipc	ra,0x0
    80004da4:	942080e7          	jalr	-1726(ra) # 800046e2 <bread>
    80004da8:	fea43023          	sd	a0,-32(s0)
    dip = (struct dinode*)bp->data + inum%IPB;
    80004dac:	fe043783          	ld	a5,-32(s0)
    80004db0:	05878713          	addi	a4,a5,88
    80004db4:	fec42783          	lw	a5,-20(s0)
    80004db8:	8bbd                	andi	a5,a5,15
    80004dba:	079a                	slli	a5,a5,0x6
    80004dbc:	97ba                	add	a5,a5,a4
    80004dbe:	fcf43c23          	sd	a5,-40(s0)
    if(dip->type == 0){  // a free inode
    80004dc2:	fd843783          	ld	a5,-40(s0)
    80004dc6:	00079783          	lh	a5,0(a5)
    80004dca:	eba1                	bnez	a5,80004e1a <ialloc+0xba>
      memset(dip, 0, sizeof(*dip));
    80004dcc:	04000613          	li	a2,64
    80004dd0:	4581                	li	a1,0
    80004dd2:	fd843503          	ld	a0,-40(s0)
    80004dd6:	ffffc097          	auipc	ra,0xffffc
    80004dda:	6c2080e7          	jalr	1730(ra) # 80001498 <memset>
      dip->type = type;
    80004dde:	fd843783          	ld	a5,-40(s0)
    80004de2:	fca45703          	lhu	a4,-54(s0)
    80004de6:	00e79023          	sh	a4,0(a5)
      log_write(bp);   // mark it allocated on the disk
    80004dea:	fe043503          	ld	a0,-32(s0)
    80004dee:	00001097          	auipc	ra,0x1
    80004df2:	606080e7          	jalr	1542(ra) # 800063f4 <log_write>
      brelse(bp);
    80004df6:	fe043503          	ld	a0,-32(s0)
    80004dfa:	00000097          	auipc	ra,0x0
    80004dfe:	98a080e7          	jalr	-1654(ra) # 80004784 <brelse>
      return iget(dev, inum);
    80004e02:	fec42703          	lw	a4,-20(s0)
    80004e06:	fcc42783          	lw	a5,-52(s0)
    80004e0a:	85ba                	mv	a1,a4
    80004e0c:	853e                	mv	a0,a5
    80004e0e:	00000097          	auipc	ra,0x0
    80004e12:	138080e7          	jalr	312(ra) # 80004f46 <iget>
    80004e16:	87aa                	mv	a5,a0
    80004e18:	a835                	j	80004e54 <ialloc+0xf4>
    }
    brelse(bp);
    80004e1a:	fe043503          	ld	a0,-32(s0)
    80004e1e:	00000097          	auipc	ra,0x0
    80004e22:	966080e7          	jalr	-1690(ra) # 80004784 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80004e26:	fec42783          	lw	a5,-20(s0)
    80004e2a:	2785                	addiw	a5,a5,1
    80004e2c:	fef42623          	sw	a5,-20(s0)
    80004e30:	0001d797          	auipc	a5,0x1d
    80004e34:	21078793          	addi	a5,a5,528 # 80022040 <sb>
    80004e38:	47d8                	lw	a4,12(a5)
    80004e3a:	fec42783          	lw	a5,-20(s0)
    80004e3e:	f4e7e0e3          	bltu	a5,a4,80004d7e <ialloc+0x1e>
  }
  printf("ialloc: no inodes\n");
    80004e42:	00006517          	auipc	a0,0x6
    80004e46:	66650513          	addi	a0,a0,1638 # 8000b4a8 <etext+0x4a8>
    80004e4a:	ffffc097          	auipc	ra,0xffffc
    80004e4e:	c20080e7          	jalr	-992(ra) # 80000a6a <printf>
  return 0;
    80004e52:	4781                	li	a5,0
}
    80004e54:	853e                	mv	a0,a5
    80004e56:	70e2                	ld	ra,56(sp)
    80004e58:	7442                	ld	s0,48(sp)
    80004e5a:	6121                	addi	sp,sp,64
    80004e5c:	8082                	ret

0000000080004e5e <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
    80004e5e:	7179                	addi	sp,sp,-48
    80004e60:	f406                	sd	ra,40(sp)
    80004e62:	f022                	sd	s0,32(sp)
    80004e64:	1800                	addi	s0,sp,48
    80004e66:	fca43c23          	sd	a0,-40(s0)
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80004e6a:	fd843783          	ld	a5,-40(s0)
    80004e6e:	4394                	lw	a3,0(a5)
    80004e70:	fd843783          	ld	a5,-40(s0)
    80004e74:	43dc                	lw	a5,4(a5)
    80004e76:	0047d79b          	srliw	a5,a5,0x4
    80004e7a:	0007871b          	sext.w	a4,a5
    80004e7e:	0001d797          	auipc	a5,0x1d
    80004e82:	1c278793          	addi	a5,a5,450 # 80022040 <sb>
    80004e86:	4f9c                	lw	a5,24(a5)
    80004e88:	9fb9                	addw	a5,a5,a4
    80004e8a:	2781                	sext.w	a5,a5
    80004e8c:	85be                	mv	a1,a5
    80004e8e:	8536                	mv	a0,a3
    80004e90:	00000097          	auipc	ra,0x0
    80004e94:	852080e7          	jalr	-1966(ra) # 800046e2 <bread>
    80004e98:	fea43423          	sd	a0,-24(s0)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80004e9c:	fe843783          	ld	a5,-24(s0)
    80004ea0:	05878713          	addi	a4,a5,88
    80004ea4:	fd843783          	ld	a5,-40(s0)
    80004ea8:	43dc                	lw	a5,4(a5)
    80004eaa:	1782                	slli	a5,a5,0x20
    80004eac:	9381                	srli	a5,a5,0x20
    80004eae:	8bbd                	andi	a5,a5,15
    80004eb0:	079a                	slli	a5,a5,0x6
    80004eb2:	97ba                	add	a5,a5,a4
    80004eb4:	fef43023          	sd	a5,-32(s0)
  dip->type = ip->type;
    80004eb8:	fd843783          	ld	a5,-40(s0)
    80004ebc:	04479703          	lh	a4,68(a5)
    80004ec0:	fe043783          	ld	a5,-32(s0)
    80004ec4:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80004ec8:	fd843783          	ld	a5,-40(s0)
    80004ecc:	04679703          	lh	a4,70(a5)
    80004ed0:	fe043783          	ld	a5,-32(s0)
    80004ed4:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80004ed8:	fd843783          	ld	a5,-40(s0)
    80004edc:	04879703          	lh	a4,72(a5)
    80004ee0:	fe043783          	ld	a5,-32(s0)
    80004ee4:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80004ee8:	fd843783          	ld	a5,-40(s0)
    80004eec:	04a79703          	lh	a4,74(a5)
    80004ef0:	fe043783          	ld	a5,-32(s0)
    80004ef4:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80004ef8:	fd843783          	ld	a5,-40(s0)
    80004efc:	47f8                	lw	a4,76(a5)
    80004efe:	fe043783          	ld	a5,-32(s0)
    80004f02:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80004f04:	fe043783          	ld	a5,-32(s0)
    80004f08:	00c78713          	addi	a4,a5,12
    80004f0c:	fd843783          	ld	a5,-40(s0)
    80004f10:	05078793          	addi	a5,a5,80
    80004f14:	03400613          	li	a2,52
    80004f18:	85be                	mv	a1,a5
    80004f1a:	853a                	mv	a0,a4
    80004f1c:	ffffc097          	auipc	ra,0xffffc
    80004f20:	668080e7          	jalr	1640(ra) # 80001584 <memmove>
  log_write(bp);
    80004f24:	fe843503          	ld	a0,-24(s0)
    80004f28:	00001097          	auipc	ra,0x1
    80004f2c:	4cc080e7          	jalr	1228(ra) # 800063f4 <log_write>
  brelse(bp);
    80004f30:	fe843503          	ld	a0,-24(s0)
    80004f34:	00000097          	auipc	ra,0x0
    80004f38:	850080e7          	jalr	-1968(ra) # 80004784 <brelse>
}
    80004f3c:	0001                	nop
    80004f3e:	70a2                	ld	ra,40(sp)
    80004f40:	7402                	ld	s0,32(sp)
    80004f42:	6145                	addi	sp,sp,48
    80004f44:	8082                	ret

0000000080004f46 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
    80004f46:	7179                	addi	sp,sp,-48
    80004f48:	f406                	sd	ra,40(sp)
    80004f4a:	f022                	sd	s0,32(sp)
    80004f4c:	1800                	addi	s0,sp,48
    80004f4e:	87aa                	mv	a5,a0
    80004f50:	872e                	mv	a4,a1
    80004f52:	fcf42e23          	sw	a5,-36(s0)
    80004f56:	87ba                	mv	a5,a4
    80004f58:	fcf42c23          	sw	a5,-40(s0)
  struct inode *ip, *empty;

  acquire(&itable.lock);
    80004f5c:	0001d517          	auipc	a0,0x1d
    80004f60:	10450513          	addi	a0,a0,260 # 80022060 <itable>
    80004f64:	ffffc097          	auipc	ra,0xffffc
    80004f68:	360080e7          	jalr	864(ra) # 800012c4 <acquire>

  // Is the inode already in the table?
  empty = 0;
    80004f6c:	fe043023          	sd	zero,-32(s0)
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80004f70:	0001d797          	auipc	a5,0x1d
    80004f74:	10878793          	addi	a5,a5,264 # 80022078 <itable+0x18>
    80004f78:	fef43423          	sd	a5,-24(s0)
    80004f7c:	a89d                	j	80004ff2 <iget+0xac>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80004f7e:	fe843783          	ld	a5,-24(s0)
    80004f82:	479c                	lw	a5,8(a5)
    80004f84:	04f05663          	blez	a5,80004fd0 <iget+0x8a>
    80004f88:	fe843783          	ld	a5,-24(s0)
    80004f8c:	439c                	lw	a5,0(a5)
    80004f8e:	fdc42703          	lw	a4,-36(s0)
    80004f92:	2701                	sext.w	a4,a4
    80004f94:	02f71e63          	bne	a4,a5,80004fd0 <iget+0x8a>
    80004f98:	fe843783          	ld	a5,-24(s0)
    80004f9c:	43dc                	lw	a5,4(a5)
    80004f9e:	fd842703          	lw	a4,-40(s0)
    80004fa2:	2701                	sext.w	a4,a4
    80004fa4:	02f71663          	bne	a4,a5,80004fd0 <iget+0x8a>
      ip->ref++;
    80004fa8:	fe843783          	ld	a5,-24(s0)
    80004fac:	479c                	lw	a5,8(a5)
    80004fae:	2785                	addiw	a5,a5,1
    80004fb0:	0007871b          	sext.w	a4,a5
    80004fb4:	fe843783          	ld	a5,-24(s0)
    80004fb8:	c798                	sw	a4,8(a5)
      release(&itable.lock);
    80004fba:	0001d517          	auipc	a0,0x1d
    80004fbe:	0a650513          	addi	a0,a0,166 # 80022060 <itable>
    80004fc2:	ffffc097          	auipc	ra,0xffffc
    80004fc6:	366080e7          	jalr	870(ra) # 80001328 <release>
      return ip;
    80004fca:	fe843783          	ld	a5,-24(s0)
    80004fce:	a069                	j	80005058 <iget+0x112>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80004fd0:	fe043783          	ld	a5,-32(s0)
    80004fd4:	eb89                	bnez	a5,80004fe6 <iget+0xa0>
    80004fd6:	fe843783          	ld	a5,-24(s0)
    80004fda:	479c                	lw	a5,8(a5)
    80004fdc:	e789                	bnez	a5,80004fe6 <iget+0xa0>
      empty = ip;
    80004fde:	fe843783          	ld	a5,-24(s0)
    80004fe2:	fef43023          	sd	a5,-32(s0)
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80004fe6:	fe843783          	ld	a5,-24(s0)
    80004fea:	08878793          	addi	a5,a5,136
    80004fee:	fef43423          	sd	a5,-24(s0)
    80004ff2:	fe843703          	ld	a4,-24(s0)
    80004ff6:	0001f797          	auipc	a5,0x1f
    80004ffa:	b1278793          	addi	a5,a5,-1262 # 80023b08 <log>
    80004ffe:	f8f760e3          	bltu	a4,a5,80004f7e <iget+0x38>
  }

  // Recycle an inode entry.
  if(empty == 0)
    80005002:	fe043783          	ld	a5,-32(s0)
    80005006:	eb89                	bnez	a5,80005018 <iget+0xd2>
    panic("iget: no inodes");
    80005008:	00006517          	auipc	a0,0x6
    8000500c:	4b850513          	addi	a0,a0,1208 # 8000b4c0 <etext+0x4c0>
    80005010:	ffffc097          	auipc	ra,0xffffc
    80005014:	cb0080e7          	jalr	-848(ra) # 80000cc0 <panic>

  ip = empty;
    80005018:	fe043783          	ld	a5,-32(s0)
    8000501c:	fef43423          	sd	a5,-24(s0)
  ip->dev = dev;
    80005020:	fe843783          	ld	a5,-24(s0)
    80005024:	fdc42703          	lw	a4,-36(s0)
    80005028:	c398                	sw	a4,0(a5)
  ip->inum = inum;
    8000502a:	fe843783          	ld	a5,-24(s0)
    8000502e:	fd842703          	lw	a4,-40(s0)
    80005032:	c3d8                	sw	a4,4(a5)
  ip->ref = 1;
    80005034:	fe843783          	ld	a5,-24(s0)
    80005038:	4705                	li	a4,1
    8000503a:	c798                	sw	a4,8(a5)
  ip->valid = 0;
    8000503c:	fe843783          	ld	a5,-24(s0)
    80005040:	0407a023          	sw	zero,64(a5)
  release(&itable.lock);
    80005044:	0001d517          	auipc	a0,0x1d
    80005048:	01c50513          	addi	a0,a0,28 # 80022060 <itable>
    8000504c:	ffffc097          	auipc	ra,0xffffc
    80005050:	2dc080e7          	jalr	732(ra) # 80001328 <release>

  return ip;
    80005054:	fe843783          	ld	a5,-24(s0)
}
    80005058:	853e                	mv	a0,a5
    8000505a:	70a2                	ld	ra,40(sp)
    8000505c:	7402                	ld	s0,32(sp)
    8000505e:	6145                	addi	sp,sp,48
    80005060:	8082                	ret

0000000080005062 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
    80005062:	1101                	addi	sp,sp,-32
    80005064:	ec06                	sd	ra,24(sp)
    80005066:	e822                	sd	s0,16(sp)
    80005068:	1000                	addi	s0,sp,32
    8000506a:	fea43423          	sd	a0,-24(s0)
  acquire(&itable.lock);
    8000506e:	0001d517          	auipc	a0,0x1d
    80005072:	ff250513          	addi	a0,a0,-14 # 80022060 <itable>
    80005076:	ffffc097          	auipc	ra,0xffffc
    8000507a:	24e080e7          	jalr	590(ra) # 800012c4 <acquire>
  ip->ref++;
    8000507e:	fe843783          	ld	a5,-24(s0)
    80005082:	479c                	lw	a5,8(a5)
    80005084:	2785                	addiw	a5,a5,1
    80005086:	0007871b          	sext.w	a4,a5
    8000508a:	fe843783          	ld	a5,-24(s0)
    8000508e:	c798                	sw	a4,8(a5)
  release(&itable.lock);
    80005090:	0001d517          	auipc	a0,0x1d
    80005094:	fd050513          	addi	a0,a0,-48 # 80022060 <itable>
    80005098:	ffffc097          	auipc	ra,0xffffc
    8000509c:	290080e7          	jalr	656(ra) # 80001328 <release>
  return ip;
    800050a0:	fe843783          	ld	a5,-24(s0)
}
    800050a4:	853e                	mv	a0,a5
    800050a6:	60e2                	ld	ra,24(sp)
    800050a8:	6442                	ld	s0,16(sp)
    800050aa:	6105                	addi	sp,sp,32
    800050ac:	8082                	ret

00000000800050ae <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
    800050ae:	7179                	addi	sp,sp,-48
    800050b0:	f406                	sd	ra,40(sp)
    800050b2:	f022                	sd	s0,32(sp)
    800050b4:	1800                	addi	s0,sp,48
    800050b6:	fca43c23          	sd	a0,-40(s0)
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    800050ba:	fd843783          	ld	a5,-40(s0)
    800050be:	c791                	beqz	a5,800050ca <ilock+0x1c>
    800050c0:	fd843783          	ld	a5,-40(s0)
    800050c4:	479c                	lw	a5,8(a5)
    800050c6:	00f04a63          	bgtz	a5,800050da <ilock+0x2c>
    panic("ilock");
    800050ca:	00006517          	auipc	a0,0x6
    800050ce:	40650513          	addi	a0,a0,1030 # 8000b4d0 <etext+0x4d0>
    800050d2:	ffffc097          	auipc	ra,0xffffc
    800050d6:	bee080e7          	jalr	-1042(ra) # 80000cc0 <panic>

  acquiresleep(&ip->lock);
    800050da:	fd843783          	ld	a5,-40(s0)
    800050de:	07c1                	addi	a5,a5,16
    800050e0:	853e                	mv	a0,a5
    800050e2:	00001097          	auipc	ra,0x1
    800050e6:	48c080e7          	jalr	1164(ra) # 8000656e <acquiresleep>

  if(ip->valid == 0){
    800050ea:	fd843783          	ld	a5,-40(s0)
    800050ee:	43bc                	lw	a5,64(a5)
    800050f0:	e7e5                	bnez	a5,800051d8 <ilock+0x12a>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800050f2:	fd843783          	ld	a5,-40(s0)
    800050f6:	4394                	lw	a3,0(a5)
    800050f8:	fd843783          	ld	a5,-40(s0)
    800050fc:	43dc                	lw	a5,4(a5)
    800050fe:	0047d79b          	srliw	a5,a5,0x4
    80005102:	0007871b          	sext.w	a4,a5
    80005106:	0001d797          	auipc	a5,0x1d
    8000510a:	f3a78793          	addi	a5,a5,-198 # 80022040 <sb>
    8000510e:	4f9c                	lw	a5,24(a5)
    80005110:	9fb9                	addw	a5,a5,a4
    80005112:	2781                	sext.w	a5,a5
    80005114:	85be                	mv	a1,a5
    80005116:	8536                	mv	a0,a3
    80005118:	fffff097          	auipc	ra,0xfffff
    8000511c:	5ca080e7          	jalr	1482(ra) # 800046e2 <bread>
    80005120:	fea43423          	sd	a0,-24(s0)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80005124:	fe843783          	ld	a5,-24(s0)
    80005128:	05878713          	addi	a4,a5,88
    8000512c:	fd843783          	ld	a5,-40(s0)
    80005130:	43dc                	lw	a5,4(a5)
    80005132:	1782                	slli	a5,a5,0x20
    80005134:	9381                	srli	a5,a5,0x20
    80005136:	8bbd                	andi	a5,a5,15
    80005138:	079a                	slli	a5,a5,0x6
    8000513a:	97ba                	add	a5,a5,a4
    8000513c:	fef43023          	sd	a5,-32(s0)
    ip->type = dip->type;
    80005140:	fe043783          	ld	a5,-32(s0)
    80005144:	00079703          	lh	a4,0(a5)
    80005148:	fd843783          	ld	a5,-40(s0)
    8000514c:	04e79223          	sh	a4,68(a5)
    ip->major = dip->major;
    80005150:	fe043783          	ld	a5,-32(s0)
    80005154:	00279703          	lh	a4,2(a5)
    80005158:	fd843783          	ld	a5,-40(s0)
    8000515c:	04e79323          	sh	a4,70(a5)
    ip->minor = dip->minor;
    80005160:	fe043783          	ld	a5,-32(s0)
    80005164:	00479703          	lh	a4,4(a5)
    80005168:	fd843783          	ld	a5,-40(s0)
    8000516c:	04e79423          	sh	a4,72(a5)
    ip->nlink = dip->nlink;
    80005170:	fe043783          	ld	a5,-32(s0)
    80005174:	00679703          	lh	a4,6(a5)
    80005178:	fd843783          	ld	a5,-40(s0)
    8000517c:	04e79523          	sh	a4,74(a5)
    ip->size = dip->size;
    80005180:	fe043783          	ld	a5,-32(s0)
    80005184:	4798                	lw	a4,8(a5)
    80005186:	fd843783          	ld	a5,-40(s0)
    8000518a:	c7f8                	sw	a4,76(a5)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000518c:	fd843783          	ld	a5,-40(s0)
    80005190:	05078713          	addi	a4,a5,80
    80005194:	fe043783          	ld	a5,-32(s0)
    80005198:	07b1                	addi	a5,a5,12
    8000519a:	03400613          	li	a2,52
    8000519e:	85be                	mv	a1,a5
    800051a0:	853a                	mv	a0,a4
    800051a2:	ffffc097          	auipc	ra,0xffffc
    800051a6:	3e2080e7          	jalr	994(ra) # 80001584 <memmove>
    brelse(bp);
    800051aa:	fe843503          	ld	a0,-24(s0)
    800051ae:	fffff097          	auipc	ra,0xfffff
    800051b2:	5d6080e7          	jalr	1494(ra) # 80004784 <brelse>
    ip->valid = 1;
    800051b6:	fd843783          	ld	a5,-40(s0)
    800051ba:	4705                	li	a4,1
    800051bc:	c3b8                	sw	a4,64(a5)
    if(ip->type == 0)
    800051be:	fd843783          	ld	a5,-40(s0)
    800051c2:	04479783          	lh	a5,68(a5)
    800051c6:	eb89                	bnez	a5,800051d8 <ilock+0x12a>
      panic("ilock: no type");
    800051c8:	00006517          	auipc	a0,0x6
    800051cc:	31050513          	addi	a0,a0,784 # 8000b4d8 <etext+0x4d8>
    800051d0:	ffffc097          	auipc	ra,0xffffc
    800051d4:	af0080e7          	jalr	-1296(ra) # 80000cc0 <panic>
  }
}
    800051d8:	0001                	nop
    800051da:	70a2                	ld	ra,40(sp)
    800051dc:	7402                	ld	s0,32(sp)
    800051de:	6145                	addi	sp,sp,48
    800051e0:	8082                	ret

00000000800051e2 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
    800051e2:	1101                	addi	sp,sp,-32
    800051e4:	ec06                	sd	ra,24(sp)
    800051e6:	e822                	sd	s0,16(sp)
    800051e8:	1000                	addi	s0,sp,32
    800051ea:	fea43423          	sd	a0,-24(s0)
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800051ee:	fe843783          	ld	a5,-24(s0)
    800051f2:	c385                	beqz	a5,80005212 <iunlock+0x30>
    800051f4:	fe843783          	ld	a5,-24(s0)
    800051f8:	07c1                	addi	a5,a5,16
    800051fa:	853e                	mv	a0,a5
    800051fc:	00001097          	auipc	ra,0x1
    80005200:	432080e7          	jalr	1074(ra) # 8000662e <holdingsleep>
    80005204:	87aa                	mv	a5,a0
    80005206:	c791                	beqz	a5,80005212 <iunlock+0x30>
    80005208:	fe843783          	ld	a5,-24(s0)
    8000520c:	479c                	lw	a5,8(a5)
    8000520e:	00f04a63          	bgtz	a5,80005222 <iunlock+0x40>
    panic("iunlock");
    80005212:	00006517          	auipc	a0,0x6
    80005216:	2d650513          	addi	a0,a0,726 # 8000b4e8 <etext+0x4e8>
    8000521a:	ffffc097          	auipc	ra,0xffffc
    8000521e:	aa6080e7          	jalr	-1370(ra) # 80000cc0 <panic>

  releasesleep(&ip->lock);
    80005222:	fe843783          	ld	a5,-24(s0)
    80005226:	07c1                	addi	a5,a5,16
    80005228:	853e                	mv	a0,a5
    8000522a:	00001097          	auipc	ra,0x1
    8000522e:	3b2080e7          	jalr	946(ra) # 800065dc <releasesleep>
}
    80005232:	0001                	nop
    80005234:	60e2                	ld	ra,24(sp)
    80005236:	6442                	ld	s0,16(sp)
    80005238:	6105                	addi	sp,sp,32
    8000523a:	8082                	ret

000000008000523c <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
    8000523c:	1101                	addi	sp,sp,-32
    8000523e:	ec06                	sd	ra,24(sp)
    80005240:	e822                	sd	s0,16(sp)
    80005242:	1000                	addi	s0,sp,32
    80005244:	fea43423          	sd	a0,-24(s0)
  acquire(&itable.lock);
    80005248:	0001d517          	auipc	a0,0x1d
    8000524c:	e1850513          	addi	a0,a0,-488 # 80022060 <itable>
    80005250:	ffffc097          	auipc	ra,0xffffc
    80005254:	074080e7          	jalr	116(ra) # 800012c4 <acquire>

  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80005258:	fe843783          	ld	a5,-24(s0)
    8000525c:	4798                	lw	a4,8(a5)
    8000525e:	4785                	li	a5,1
    80005260:	06f71f63          	bne	a4,a5,800052de <iput+0xa2>
    80005264:	fe843783          	ld	a5,-24(s0)
    80005268:	43bc                	lw	a5,64(a5)
    8000526a:	cbb5                	beqz	a5,800052de <iput+0xa2>
    8000526c:	fe843783          	ld	a5,-24(s0)
    80005270:	04a79783          	lh	a5,74(a5)
    80005274:	e7ad                	bnez	a5,800052de <iput+0xa2>
    // inode has no links and no other references: truncate and free.

    // ip->ref == 1 means no other process can have ip locked,
    // so this acquiresleep() won't block (or deadlock).
    acquiresleep(&ip->lock);
    80005276:	fe843783          	ld	a5,-24(s0)
    8000527a:	07c1                	addi	a5,a5,16
    8000527c:	853e                	mv	a0,a5
    8000527e:	00001097          	auipc	ra,0x1
    80005282:	2f0080e7          	jalr	752(ra) # 8000656e <acquiresleep>

    release(&itable.lock);
    80005286:	0001d517          	auipc	a0,0x1d
    8000528a:	dda50513          	addi	a0,a0,-550 # 80022060 <itable>
    8000528e:	ffffc097          	auipc	ra,0xffffc
    80005292:	09a080e7          	jalr	154(ra) # 80001328 <release>

    itrunc(ip);
    80005296:	fe843503          	ld	a0,-24(s0)
    8000529a:	00000097          	auipc	ra,0x0
    8000529e:	21a080e7          	jalr	538(ra) # 800054b4 <itrunc>
    ip->type = 0;
    800052a2:	fe843783          	ld	a5,-24(s0)
    800052a6:	04079223          	sh	zero,68(a5)
    iupdate(ip);
    800052aa:	fe843503          	ld	a0,-24(s0)
    800052ae:	00000097          	auipc	ra,0x0
    800052b2:	bb0080e7          	jalr	-1104(ra) # 80004e5e <iupdate>
    ip->valid = 0;
    800052b6:	fe843783          	ld	a5,-24(s0)
    800052ba:	0407a023          	sw	zero,64(a5)

    releasesleep(&ip->lock);
    800052be:	fe843783          	ld	a5,-24(s0)
    800052c2:	07c1                	addi	a5,a5,16
    800052c4:	853e                	mv	a0,a5
    800052c6:	00001097          	auipc	ra,0x1
    800052ca:	316080e7          	jalr	790(ra) # 800065dc <releasesleep>

    acquire(&itable.lock);
    800052ce:	0001d517          	auipc	a0,0x1d
    800052d2:	d9250513          	addi	a0,a0,-622 # 80022060 <itable>
    800052d6:	ffffc097          	auipc	ra,0xffffc
    800052da:	fee080e7          	jalr	-18(ra) # 800012c4 <acquire>
  }

  ip->ref--;
    800052de:	fe843783          	ld	a5,-24(s0)
    800052e2:	479c                	lw	a5,8(a5)
    800052e4:	37fd                	addiw	a5,a5,-1
    800052e6:	0007871b          	sext.w	a4,a5
    800052ea:	fe843783          	ld	a5,-24(s0)
    800052ee:	c798                	sw	a4,8(a5)
  release(&itable.lock);
    800052f0:	0001d517          	auipc	a0,0x1d
    800052f4:	d7050513          	addi	a0,a0,-656 # 80022060 <itable>
    800052f8:	ffffc097          	auipc	ra,0xffffc
    800052fc:	030080e7          	jalr	48(ra) # 80001328 <release>
}
    80005300:	0001                	nop
    80005302:	60e2                	ld	ra,24(sp)
    80005304:	6442                	ld	s0,16(sp)
    80005306:	6105                	addi	sp,sp,32
    80005308:	8082                	ret

000000008000530a <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
    8000530a:	1101                	addi	sp,sp,-32
    8000530c:	ec06                	sd	ra,24(sp)
    8000530e:	e822                	sd	s0,16(sp)
    80005310:	1000                	addi	s0,sp,32
    80005312:	fea43423          	sd	a0,-24(s0)
  iunlock(ip);
    80005316:	fe843503          	ld	a0,-24(s0)
    8000531a:	00000097          	auipc	ra,0x0
    8000531e:	ec8080e7          	jalr	-312(ra) # 800051e2 <iunlock>
  iput(ip);
    80005322:	fe843503          	ld	a0,-24(s0)
    80005326:	00000097          	auipc	ra,0x0
    8000532a:	f16080e7          	jalr	-234(ra) # 8000523c <iput>
}
    8000532e:	0001                	nop
    80005330:	60e2                	ld	ra,24(sp)
    80005332:	6442                	ld	s0,16(sp)
    80005334:	6105                	addi	sp,sp,32
    80005336:	8082                	ret

0000000080005338 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80005338:	7139                	addi	sp,sp,-64
    8000533a:	fc06                	sd	ra,56(sp)
    8000533c:	f822                	sd	s0,48(sp)
    8000533e:	0080                	addi	s0,sp,64
    80005340:	fca43423          	sd	a0,-56(s0)
    80005344:	87ae                	mv	a5,a1
    80005346:	fcf42223          	sw	a5,-60(s0)
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000534a:	fc442783          	lw	a5,-60(s0)
    8000534e:	0007871b          	sext.w	a4,a5
    80005352:	47ad                	li	a5,11
    80005354:	04e7ee63          	bltu	a5,a4,800053b0 <bmap+0x78>
    if((addr = ip->addrs[bn]) == 0){
    80005358:	fc843703          	ld	a4,-56(s0)
    8000535c:	fc446783          	lwu	a5,-60(s0)
    80005360:	07d1                	addi	a5,a5,20
    80005362:	078a                	slli	a5,a5,0x2
    80005364:	97ba                	add	a5,a5,a4
    80005366:	439c                	lw	a5,0(a5)
    80005368:	fef42623          	sw	a5,-20(s0)
    8000536c:	fec42783          	lw	a5,-20(s0)
    80005370:	2781                	sext.w	a5,a5
    80005372:	ef85                	bnez	a5,800053aa <bmap+0x72>
      addr = balloc(ip->dev);
    80005374:	fc843783          	ld	a5,-56(s0)
    80005378:	439c                	lw	a5,0(a5)
    8000537a:	853e                	mv	a0,a5
    8000537c:	fffff097          	auipc	ra,0xfffff
    80005380:	6ae080e7          	jalr	1710(ra) # 80004a2a <balloc>
    80005384:	87aa                	mv	a5,a0
    80005386:	fef42623          	sw	a5,-20(s0)
      if(addr == 0)
    8000538a:	fec42783          	lw	a5,-20(s0)
    8000538e:	2781                	sext.w	a5,a5
    80005390:	e399                	bnez	a5,80005396 <bmap+0x5e>
        return 0;
    80005392:	4781                	li	a5,0
    80005394:	aa19                	j	800054aa <bmap+0x172>
      ip->addrs[bn] = addr;
    80005396:	fc843703          	ld	a4,-56(s0)
    8000539a:	fc446783          	lwu	a5,-60(s0)
    8000539e:	07d1                	addi	a5,a5,20
    800053a0:	078a                	slli	a5,a5,0x2
    800053a2:	97ba                	add	a5,a5,a4
    800053a4:	fec42703          	lw	a4,-20(s0)
    800053a8:	c398                	sw	a4,0(a5)
    }
    return addr;
    800053aa:	fec42783          	lw	a5,-20(s0)
    800053ae:	a8f5                	j	800054aa <bmap+0x172>
  }
  bn -= NDIRECT;
    800053b0:	fc442783          	lw	a5,-60(s0)
    800053b4:	37d1                	addiw	a5,a5,-12
    800053b6:	fcf42223          	sw	a5,-60(s0)

  if(bn < NINDIRECT){
    800053ba:	fc442783          	lw	a5,-60(s0)
    800053be:	0007871b          	sext.w	a4,a5
    800053c2:	0ff00793          	li	a5,255
    800053c6:	0ce7ea63          	bltu	a5,a4,8000549a <bmap+0x162>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800053ca:	fc843783          	ld	a5,-56(s0)
    800053ce:	0807a783          	lw	a5,128(a5)
    800053d2:	fef42623          	sw	a5,-20(s0)
    800053d6:	fec42783          	lw	a5,-20(s0)
    800053da:	2781                	sext.w	a5,a5
    800053dc:	eb85                	bnez	a5,8000540c <bmap+0xd4>
      addr = balloc(ip->dev);
    800053de:	fc843783          	ld	a5,-56(s0)
    800053e2:	439c                	lw	a5,0(a5)
    800053e4:	853e                	mv	a0,a5
    800053e6:	fffff097          	auipc	ra,0xfffff
    800053ea:	644080e7          	jalr	1604(ra) # 80004a2a <balloc>
    800053ee:	87aa                	mv	a5,a0
    800053f0:	fef42623          	sw	a5,-20(s0)
      if(addr == 0)
    800053f4:	fec42783          	lw	a5,-20(s0)
    800053f8:	2781                	sext.w	a5,a5
    800053fa:	e399                	bnez	a5,80005400 <bmap+0xc8>
        return 0;
    800053fc:	4781                	li	a5,0
    800053fe:	a075                	j	800054aa <bmap+0x172>
      ip->addrs[NDIRECT] = addr;
    80005400:	fc843783          	ld	a5,-56(s0)
    80005404:	fec42703          	lw	a4,-20(s0)
    80005408:	08e7a023          	sw	a4,128(a5)
    }
    bp = bread(ip->dev, addr);
    8000540c:	fc843783          	ld	a5,-56(s0)
    80005410:	439c                	lw	a5,0(a5)
    80005412:	fec42703          	lw	a4,-20(s0)
    80005416:	85ba                	mv	a1,a4
    80005418:	853e                	mv	a0,a5
    8000541a:	fffff097          	auipc	ra,0xfffff
    8000541e:	2c8080e7          	jalr	712(ra) # 800046e2 <bread>
    80005422:	fea43023          	sd	a0,-32(s0)
    a = (uint*)bp->data;
    80005426:	fe043783          	ld	a5,-32(s0)
    8000542a:	05878793          	addi	a5,a5,88
    8000542e:	fcf43c23          	sd	a5,-40(s0)
    if((addr = a[bn]) == 0){
    80005432:	fc446783          	lwu	a5,-60(s0)
    80005436:	078a                	slli	a5,a5,0x2
    80005438:	fd843703          	ld	a4,-40(s0)
    8000543c:	97ba                	add	a5,a5,a4
    8000543e:	439c                	lw	a5,0(a5)
    80005440:	fef42623          	sw	a5,-20(s0)
    80005444:	fec42783          	lw	a5,-20(s0)
    80005448:	2781                	sext.w	a5,a5
    8000544a:	ef9d                	bnez	a5,80005488 <bmap+0x150>
      addr = balloc(ip->dev);
    8000544c:	fc843783          	ld	a5,-56(s0)
    80005450:	439c                	lw	a5,0(a5)
    80005452:	853e                	mv	a0,a5
    80005454:	fffff097          	auipc	ra,0xfffff
    80005458:	5d6080e7          	jalr	1494(ra) # 80004a2a <balloc>
    8000545c:	87aa                	mv	a5,a0
    8000545e:	fef42623          	sw	a5,-20(s0)
      if(addr){
    80005462:	fec42783          	lw	a5,-20(s0)
    80005466:	2781                	sext.w	a5,a5
    80005468:	c385                	beqz	a5,80005488 <bmap+0x150>
        a[bn] = addr;
    8000546a:	fc446783          	lwu	a5,-60(s0)
    8000546e:	078a                	slli	a5,a5,0x2
    80005470:	fd843703          	ld	a4,-40(s0)
    80005474:	97ba                	add	a5,a5,a4
    80005476:	fec42703          	lw	a4,-20(s0)
    8000547a:	c398                	sw	a4,0(a5)
        log_write(bp);
    8000547c:	fe043503          	ld	a0,-32(s0)
    80005480:	00001097          	auipc	ra,0x1
    80005484:	f74080e7          	jalr	-140(ra) # 800063f4 <log_write>
      }
    }
    brelse(bp);
    80005488:	fe043503          	ld	a0,-32(s0)
    8000548c:	fffff097          	auipc	ra,0xfffff
    80005490:	2f8080e7          	jalr	760(ra) # 80004784 <brelse>
    return addr;
    80005494:	fec42783          	lw	a5,-20(s0)
    80005498:	a809                	j	800054aa <bmap+0x172>
  }

  panic("bmap: out of range");
    8000549a:	00006517          	auipc	a0,0x6
    8000549e:	05650513          	addi	a0,a0,86 # 8000b4f0 <etext+0x4f0>
    800054a2:	ffffc097          	auipc	ra,0xffffc
    800054a6:	81e080e7          	jalr	-2018(ra) # 80000cc0 <panic>
}
    800054aa:	853e                	mv	a0,a5
    800054ac:	70e2                	ld	ra,56(sp)
    800054ae:	7442                	ld	s0,48(sp)
    800054b0:	6121                	addi	sp,sp,64
    800054b2:	8082                	ret

00000000800054b4 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800054b4:	7139                	addi	sp,sp,-64
    800054b6:	fc06                	sd	ra,56(sp)
    800054b8:	f822                	sd	s0,48(sp)
    800054ba:	0080                	addi	s0,sp,64
    800054bc:	fca43423          	sd	a0,-56(s0)
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800054c0:	fe042623          	sw	zero,-20(s0)
    800054c4:	a891                	j	80005518 <itrunc+0x64>
    if(ip->addrs[i]){
    800054c6:	fc843703          	ld	a4,-56(s0)
    800054ca:	fec42783          	lw	a5,-20(s0)
    800054ce:	07d1                	addi	a5,a5,20
    800054d0:	078a                	slli	a5,a5,0x2
    800054d2:	97ba                	add	a5,a5,a4
    800054d4:	439c                	lw	a5,0(a5)
    800054d6:	cf85                	beqz	a5,8000550e <itrunc+0x5a>
      bfree(ip->dev, ip->addrs[i]);
    800054d8:	fc843783          	ld	a5,-56(s0)
    800054dc:	439c                	lw	a5,0(a5)
    800054de:	86be                	mv	a3,a5
    800054e0:	fc843703          	ld	a4,-56(s0)
    800054e4:	fec42783          	lw	a5,-20(s0)
    800054e8:	07d1                	addi	a5,a5,20
    800054ea:	078a                	slli	a5,a5,0x2
    800054ec:	97ba                	add	a5,a5,a4
    800054ee:	439c                	lw	a5,0(a5)
    800054f0:	85be                	mv	a1,a5
    800054f2:	8536                	mv	a0,a3
    800054f4:	fffff097          	auipc	ra,0xfffff
    800054f8:	6d8080e7          	jalr	1752(ra) # 80004bcc <bfree>
      ip->addrs[i] = 0;
    800054fc:	fc843703          	ld	a4,-56(s0)
    80005500:	fec42783          	lw	a5,-20(s0)
    80005504:	07d1                	addi	a5,a5,20
    80005506:	078a                	slli	a5,a5,0x2
    80005508:	97ba                	add	a5,a5,a4
    8000550a:	0007a023          	sw	zero,0(a5)
  for(i = 0; i < NDIRECT; i++){
    8000550e:	fec42783          	lw	a5,-20(s0)
    80005512:	2785                	addiw	a5,a5,1
    80005514:	fef42623          	sw	a5,-20(s0)
    80005518:	fec42783          	lw	a5,-20(s0)
    8000551c:	0007871b          	sext.w	a4,a5
    80005520:	47ad                	li	a5,11
    80005522:	fae7d2e3          	bge	a5,a4,800054c6 <itrunc+0x12>
    }
  }

  if(ip->addrs[NDIRECT]){
    80005526:	fc843783          	ld	a5,-56(s0)
    8000552a:	0807a783          	lw	a5,128(a5)
    8000552e:	c7cd                	beqz	a5,800055d8 <itrunc+0x124>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80005530:	fc843783          	ld	a5,-56(s0)
    80005534:	4398                	lw	a4,0(a5)
    80005536:	fc843783          	ld	a5,-56(s0)
    8000553a:	0807a783          	lw	a5,128(a5)
    8000553e:	85be                	mv	a1,a5
    80005540:	853a                	mv	a0,a4
    80005542:	fffff097          	auipc	ra,0xfffff
    80005546:	1a0080e7          	jalr	416(ra) # 800046e2 <bread>
    8000554a:	fea43023          	sd	a0,-32(s0)
    a = (uint*)bp->data;
    8000554e:	fe043783          	ld	a5,-32(s0)
    80005552:	05878793          	addi	a5,a5,88
    80005556:	fcf43c23          	sd	a5,-40(s0)
    for(j = 0; j < NINDIRECT; j++){
    8000555a:	fe042423          	sw	zero,-24(s0)
    8000555e:	a83d                	j	8000559c <itrunc+0xe8>
      if(a[j])
    80005560:	fe842783          	lw	a5,-24(s0)
    80005564:	078a                	slli	a5,a5,0x2
    80005566:	fd843703          	ld	a4,-40(s0)
    8000556a:	97ba                	add	a5,a5,a4
    8000556c:	439c                	lw	a5,0(a5)
    8000556e:	c395                	beqz	a5,80005592 <itrunc+0xde>
        bfree(ip->dev, a[j]);
    80005570:	fc843783          	ld	a5,-56(s0)
    80005574:	439c                	lw	a5,0(a5)
    80005576:	86be                	mv	a3,a5
    80005578:	fe842783          	lw	a5,-24(s0)
    8000557c:	078a                	slli	a5,a5,0x2
    8000557e:	fd843703          	ld	a4,-40(s0)
    80005582:	97ba                	add	a5,a5,a4
    80005584:	439c                	lw	a5,0(a5)
    80005586:	85be                	mv	a1,a5
    80005588:	8536                	mv	a0,a3
    8000558a:	fffff097          	auipc	ra,0xfffff
    8000558e:	642080e7          	jalr	1602(ra) # 80004bcc <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80005592:	fe842783          	lw	a5,-24(s0)
    80005596:	2785                	addiw	a5,a5,1
    80005598:	fef42423          	sw	a5,-24(s0)
    8000559c:	fe842703          	lw	a4,-24(s0)
    800055a0:	0ff00793          	li	a5,255
    800055a4:	fae7fee3          	bgeu	a5,a4,80005560 <itrunc+0xac>
    }
    brelse(bp);
    800055a8:	fe043503          	ld	a0,-32(s0)
    800055ac:	fffff097          	auipc	ra,0xfffff
    800055b0:	1d8080e7          	jalr	472(ra) # 80004784 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800055b4:	fc843783          	ld	a5,-56(s0)
    800055b8:	439c                	lw	a5,0(a5)
    800055ba:	873e                	mv	a4,a5
    800055bc:	fc843783          	ld	a5,-56(s0)
    800055c0:	0807a783          	lw	a5,128(a5)
    800055c4:	85be                	mv	a1,a5
    800055c6:	853a                	mv	a0,a4
    800055c8:	fffff097          	auipc	ra,0xfffff
    800055cc:	604080e7          	jalr	1540(ra) # 80004bcc <bfree>
    ip->addrs[NDIRECT] = 0;
    800055d0:	fc843783          	ld	a5,-56(s0)
    800055d4:	0807a023          	sw	zero,128(a5)
  }

  ip->size = 0;
    800055d8:	fc843783          	ld	a5,-56(s0)
    800055dc:	0407a623          	sw	zero,76(a5)
  iupdate(ip);
    800055e0:	fc843503          	ld	a0,-56(s0)
    800055e4:	00000097          	auipc	ra,0x0
    800055e8:	87a080e7          	jalr	-1926(ra) # 80004e5e <iupdate>
}
    800055ec:	0001                	nop
    800055ee:	70e2                	ld	ra,56(sp)
    800055f0:	7442                	ld	s0,48(sp)
    800055f2:	6121                	addi	sp,sp,64
    800055f4:	8082                	ret

00000000800055f6 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800055f6:	1101                	addi	sp,sp,-32
    800055f8:	ec06                	sd	ra,24(sp)
    800055fa:	e822                	sd	s0,16(sp)
    800055fc:	1000                	addi	s0,sp,32
    800055fe:	fea43423          	sd	a0,-24(s0)
    80005602:	feb43023          	sd	a1,-32(s0)
  st->dev = ip->dev;
    80005606:	fe843783          	ld	a5,-24(s0)
    8000560a:	439c                	lw	a5,0(a5)
    8000560c:	873e                	mv	a4,a5
    8000560e:	fe043783          	ld	a5,-32(s0)
    80005612:	c398                	sw	a4,0(a5)
  st->ino = ip->inum;
    80005614:	fe843783          	ld	a5,-24(s0)
    80005618:	43d8                	lw	a4,4(a5)
    8000561a:	fe043783          	ld	a5,-32(s0)
    8000561e:	c3d8                	sw	a4,4(a5)
  st->type = ip->type;
    80005620:	fe843783          	ld	a5,-24(s0)
    80005624:	04479703          	lh	a4,68(a5)
    80005628:	fe043783          	ld	a5,-32(s0)
    8000562c:	00e79423          	sh	a4,8(a5)
  st->nlink = ip->nlink;
    80005630:	fe843783          	ld	a5,-24(s0)
    80005634:	04a79703          	lh	a4,74(a5)
    80005638:	fe043783          	ld	a5,-32(s0)
    8000563c:	00e79523          	sh	a4,10(a5)
  st->size = ip->size;
    80005640:	fe843783          	ld	a5,-24(s0)
    80005644:	47fc                	lw	a5,76(a5)
    80005646:	02079713          	slli	a4,a5,0x20
    8000564a:	9301                	srli	a4,a4,0x20
    8000564c:	fe043783          	ld	a5,-32(s0)
    80005650:	eb98                	sd	a4,16(a5)
}
    80005652:	0001                	nop
    80005654:	60e2                	ld	ra,24(sp)
    80005656:	6442                	ld	s0,16(sp)
    80005658:	6105                	addi	sp,sp,32
    8000565a:	8082                	ret

000000008000565c <readi>:
// Caller must hold ip->lock.
// If user_dst==1, then dst is a user virtual address;
// otherwise, dst is a kernel address.
int
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
    8000565c:	715d                	addi	sp,sp,-80
    8000565e:	e486                	sd	ra,72(sp)
    80005660:	e0a2                	sd	s0,64(sp)
    80005662:	0880                	addi	s0,sp,80
    80005664:	fca43423          	sd	a0,-56(s0)
    80005668:	87ae                	mv	a5,a1
    8000566a:	fac43c23          	sd	a2,-72(s0)
    8000566e:	fcf42223          	sw	a5,-60(s0)
    80005672:	87b6                	mv	a5,a3
    80005674:	fcf42023          	sw	a5,-64(s0)
    80005678:	87ba                	mv	a5,a4
    8000567a:	faf42a23          	sw	a5,-76(s0)
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000567e:	fc843783          	ld	a5,-56(s0)
    80005682:	47fc                	lw	a5,76(a5)
    80005684:	fc042703          	lw	a4,-64(s0)
    80005688:	2701                	sext.w	a4,a4
    8000568a:	00e7ee63          	bltu	a5,a4,800056a6 <readi+0x4a>
    8000568e:	fc042783          	lw	a5,-64(s0)
    80005692:	873e                	mv	a4,a5
    80005694:	fb442783          	lw	a5,-76(s0)
    80005698:	9fb9                	addw	a5,a5,a4
    8000569a:	2781                	sext.w	a5,a5
    8000569c:	fc042703          	lw	a4,-64(s0)
    800056a0:	2701                	sext.w	a4,a4
    800056a2:	00e7f463          	bgeu	a5,a4,800056aa <readi+0x4e>
    return 0;
    800056a6:	4781                	li	a5,0
    800056a8:	a299                	j	800057ee <readi+0x192>
  if(off + n > ip->size)
    800056aa:	fc042783          	lw	a5,-64(s0)
    800056ae:	873e                	mv	a4,a5
    800056b0:	fb442783          	lw	a5,-76(s0)
    800056b4:	9fb9                	addw	a5,a5,a4
    800056b6:	0007871b          	sext.w	a4,a5
    800056ba:	fc843783          	ld	a5,-56(s0)
    800056be:	47fc                	lw	a5,76(a5)
    800056c0:	00e7fa63          	bgeu	a5,a4,800056d4 <readi+0x78>
    n = ip->size - off;
    800056c4:	fc843783          	ld	a5,-56(s0)
    800056c8:	47fc                	lw	a5,76(a5)
    800056ca:	fc042703          	lw	a4,-64(s0)
    800056ce:	9f99                	subw	a5,a5,a4
    800056d0:	faf42a23          	sw	a5,-76(s0)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800056d4:	fe042623          	sw	zero,-20(s0)
    800056d8:	a8f5                	j	800057d4 <readi+0x178>
    uint addr = bmap(ip, off/BSIZE);
    800056da:	fc042783          	lw	a5,-64(s0)
    800056de:	00a7d79b          	srliw	a5,a5,0xa
    800056e2:	2781                	sext.w	a5,a5
    800056e4:	85be                	mv	a1,a5
    800056e6:	fc843503          	ld	a0,-56(s0)
    800056ea:	00000097          	auipc	ra,0x0
    800056ee:	c4e080e7          	jalr	-946(ra) # 80005338 <bmap>
    800056f2:	87aa                	mv	a5,a0
    800056f4:	fef42423          	sw	a5,-24(s0)
    if(addr == 0)
    800056f8:	fe842783          	lw	a5,-24(s0)
    800056fc:	2781                	sext.w	a5,a5
    800056fe:	c7ed                	beqz	a5,800057e8 <readi+0x18c>
      break;
    bp = bread(ip->dev, addr);
    80005700:	fc843783          	ld	a5,-56(s0)
    80005704:	439c                	lw	a5,0(a5)
    80005706:	fe842703          	lw	a4,-24(s0)
    8000570a:	85ba                	mv	a1,a4
    8000570c:	853e                	mv	a0,a5
    8000570e:	fffff097          	auipc	ra,0xfffff
    80005712:	fd4080e7          	jalr	-44(ra) # 800046e2 <bread>
    80005716:	fea43023          	sd	a0,-32(s0)
    m = min(n - tot, BSIZE - off%BSIZE);
    8000571a:	fc042783          	lw	a5,-64(s0)
    8000571e:	3ff7f793          	andi	a5,a5,1023
    80005722:	2781                	sext.w	a5,a5
    80005724:	40000713          	li	a4,1024
    80005728:	40f707bb          	subw	a5,a4,a5
    8000572c:	2781                	sext.w	a5,a5
    8000572e:	fb442703          	lw	a4,-76(s0)
    80005732:	86ba                	mv	a3,a4
    80005734:	fec42703          	lw	a4,-20(s0)
    80005738:	40e6873b          	subw	a4,a3,a4
    8000573c:	2701                	sext.w	a4,a4
    8000573e:	863a                	mv	a2,a4
    80005740:	0007869b          	sext.w	a3,a5
    80005744:	0006071b          	sext.w	a4,a2
    80005748:	00d77363          	bgeu	a4,a3,8000574e <readi+0xf2>
    8000574c:	87b2                	mv	a5,a2
    8000574e:	fcf42e23          	sw	a5,-36(s0)
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80005752:	fe043783          	ld	a5,-32(s0)
    80005756:	05878713          	addi	a4,a5,88
    8000575a:	fc046783          	lwu	a5,-64(s0)
    8000575e:	3ff7f793          	andi	a5,a5,1023
    80005762:	973e                	add	a4,a4,a5
    80005764:	fdc46683          	lwu	a3,-36(s0)
    80005768:	fc442783          	lw	a5,-60(s0)
    8000576c:	863a                	mv	a2,a4
    8000576e:	fb843583          	ld	a1,-72(s0)
    80005772:	853e                	mv	a0,a5
    80005774:	ffffe097          	auipc	ra,0xffffe
    80005778:	f28080e7          	jalr	-216(ra) # 8000369c <either_copyout>
    8000577c:	87aa                	mv	a5,a0
    8000577e:	873e                	mv	a4,a5
    80005780:	57fd                	li	a5,-1
    80005782:	00f71c63          	bne	a4,a5,8000579a <readi+0x13e>
      brelse(bp);
    80005786:	fe043503          	ld	a0,-32(s0)
    8000578a:	fffff097          	auipc	ra,0xfffff
    8000578e:	ffa080e7          	jalr	-6(ra) # 80004784 <brelse>
      tot = -1;
    80005792:	57fd                	li	a5,-1
    80005794:	fef42623          	sw	a5,-20(s0)
      break;
    80005798:	a889                	j	800057ea <readi+0x18e>
    }
    brelse(bp);
    8000579a:	fe043503          	ld	a0,-32(s0)
    8000579e:	fffff097          	auipc	ra,0xfffff
    800057a2:	fe6080e7          	jalr	-26(ra) # 80004784 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800057a6:	fec42783          	lw	a5,-20(s0)
    800057aa:	873e                	mv	a4,a5
    800057ac:	fdc42783          	lw	a5,-36(s0)
    800057b0:	9fb9                	addw	a5,a5,a4
    800057b2:	fef42623          	sw	a5,-20(s0)
    800057b6:	fc042783          	lw	a5,-64(s0)
    800057ba:	873e                	mv	a4,a5
    800057bc:	fdc42783          	lw	a5,-36(s0)
    800057c0:	9fb9                	addw	a5,a5,a4
    800057c2:	fcf42023          	sw	a5,-64(s0)
    800057c6:	fdc46783          	lwu	a5,-36(s0)
    800057ca:	fb843703          	ld	a4,-72(s0)
    800057ce:	97ba                	add	a5,a5,a4
    800057d0:	faf43c23          	sd	a5,-72(s0)
    800057d4:	fec42783          	lw	a5,-20(s0)
    800057d8:	873e                	mv	a4,a5
    800057da:	fb442783          	lw	a5,-76(s0)
    800057de:	2701                	sext.w	a4,a4
    800057e0:	2781                	sext.w	a5,a5
    800057e2:	eef76ce3          	bltu	a4,a5,800056da <readi+0x7e>
    800057e6:	a011                	j	800057ea <readi+0x18e>
      break;
    800057e8:	0001                	nop
  }
  return tot;
    800057ea:	fec42783          	lw	a5,-20(s0)
}
    800057ee:	853e                	mv	a0,a5
    800057f0:	60a6                	ld	ra,72(sp)
    800057f2:	6406                	ld	s0,64(sp)
    800057f4:	6161                	addi	sp,sp,80
    800057f6:	8082                	ret

00000000800057f8 <writei>:
// Returns the number of bytes successfully written.
// If the return value is less than the requested n,
// there was an error of some kind.
int
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
    800057f8:	715d                	addi	sp,sp,-80
    800057fa:	e486                	sd	ra,72(sp)
    800057fc:	e0a2                	sd	s0,64(sp)
    800057fe:	0880                	addi	s0,sp,80
    80005800:	fca43423          	sd	a0,-56(s0)
    80005804:	87ae                	mv	a5,a1
    80005806:	fac43c23          	sd	a2,-72(s0)
    8000580a:	fcf42223          	sw	a5,-60(s0)
    8000580e:	87b6                	mv	a5,a3
    80005810:	fcf42023          	sw	a5,-64(s0)
    80005814:	87ba                	mv	a5,a4
    80005816:	faf42a23          	sw	a5,-76(s0)
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000581a:	fc843783          	ld	a5,-56(s0)
    8000581e:	47fc                	lw	a5,76(a5)
    80005820:	fc042703          	lw	a4,-64(s0)
    80005824:	2701                	sext.w	a4,a4
    80005826:	00e7ee63          	bltu	a5,a4,80005842 <writei+0x4a>
    8000582a:	fc042783          	lw	a5,-64(s0)
    8000582e:	873e                	mv	a4,a5
    80005830:	fb442783          	lw	a5,-76(s0)
    80005834:	9fb9                	addw	a5,a5,a4
    80005836:	2781                	sext.w	a5,a5
    80005838:	fc042703          	lw	a4,-64(s0)
    8000583c:	2701                	sext.w	a4,a4
    8000583e:	00e7f463          	bgeu	a5,a4,80005846 <writei+0x4e>
    return -1;
    80005842:	57fd                	li	a5,-1
    80005844:	a295                	j	800059a8 <writei+0x1b0>
  if(off + n > MAXFILE*BSIZE)
    80005846:	fc042783          	lw	a5,-64(s0)
    8000584a:	873e                	mv	a4,a5
    8000584c:	fb442783          	lw	a5,-76(s0)
    80005850:	9fb9                	addw	a5,a5,a4
    80005852:	0007871b          	sext.w	a4,a5
    80005856:	000437b7          	lui	a5,0x43
    8000585a:	00e7f463          	bgeu	a5,a4,80005862 <writei+0x6a>
    return -1;
    8000585e:	57fd                	li	a5,-1
    80005860:	a2a1                	j	800059a8 <writei+0x1b0>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80005862:	fe042623          	sw	zero,-20(s0)
    80005866:	a209                	j	80005968 <writei+0x170>
    uint addr = bmap(ip, off/BSIZE);
    80005868:	fc042783          	lw	a5,-64(s0)
    8000586c:	00a7d79b          	srliw	a5,a5,0xa
    80005870:	2781                	sext.w	a5,a5
    80005872:	85be                	mv	a1,a5
    80005874:	fc843503          	ld	a0,-56(s0)
    80005878:	00000097          	auipc	ra,0x0
    8000587c:	ac0080e7          	jalr	-1344(ra) # 80005338 <bmap>
    80005880:	87aa                	mv	a5,a0
    80005882:	fef42423          	sw	a5,-24(s0)
    if(addr == 0)
    80005886:	fe842783          	lw	a5,-24(s0)
    8000588a:	2781                	sext.w	a5,a5
    8000588c:	cbe5                	beqz	a5,8000597c <writei+0x184>
      break;
    bp = bread(ip->dev, addr);
    8000588e:	fc843783          	ld	a5,-56(s0)
    80005892:	439c                	lw	a5,0(a5)
    80005894:	fe842703          	lw	a4,-24(s0)
    80005898:	85ba                	mv	a1,a4
    8000589a:	853e                	mv	a0,a5
    8000589c:	fffff097          	auipc	ra,0xfffff
    800058a0:	e46080e7          	jalr	-442(ra) # 800046e2 <bread>
    800058a4:	fea43023          	sd	a0,-32(s0)
    m = min(n - tot, BSIZE - off%BSIZE);
    800058a8:	fc042783          	lw	a5,-64(s0)
    800058ac:	3ff7f793          	andi	a5,a5,1023
    800058b0:	2781                	sext.w	a5,a5
    800058b2:	40000713          	li	a4,1024
    800058b6:	40f707bb          	subw	a5,a4,a5
    800058ba:	2781                	sext.w	a5,a5
    800058bc:	fb442703          	lw	a4,-76(s0)
    800058c0:	86ba                	mv	a3,a4
    800058c2:	fec42703          	lw	a4,-20(s0)
    800058c6:	40e6873b          	subw	a4,a3,a4
    800058ca:	2701                	sext.w	a4,a4
    800058cc:	863a                	mv	a2,a4
    800058ce:	0007869b          	sext.w	a3,a5
    800058d2:	0006071b          	sext.w	a4,a2
    800058d6:	00d77363          	bgeu	a4,a3,800058dc <writei+0xe4>
    800058da:	87b2                	mv	a5,a2
    800058dc:	fcf42e23          	sw	a5,-36(s0)
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800058e0:	fe043783          	ld	a5,-32(s0)
    800058e4:	05878713          	addi	a4,a5,88 # 43058 <_entry-0x7ffbcfa8>
    800058e8:	fc046783          	lwu	a5,-64(s0)
    800058ec:	3ff7f793          	andi	a5,a5,1023
    800058f0:	97ba                	add	a5,a5,a4
    800058f2:	fdc46683          	lwu	a3,-36(s0)
    800058f6:	fc442703          	lw	a4,-60(s0)
    800058fa:	fb843603          	ld	a2,-72(s0)
    800058fe:	85ba                	mv	a1,a4
    80005900:	853e                	mv	a0,a5
    80005902:	ffffe097          	auipc	ra,0xffffe
    80005906:	e0e080e7          	jalr	-498(ra) # 80003710 <either_copyin>
    8000590a:	87aa                	mv	a5,a0
    8000590c:	873e                	mv	a4,a5
    8000590e:	57fd                	li	a5,-1
    80005910:	00f71963          	bne	a4,a5,80005922 <writei+0x12a>
      brelse(bp);
    80005914:	fe043503          	ld	a0,-32(s0)
    80005918:	fffff097          	auipc	ra,0xfffff
    8000591c:	e6c080e7          	jalr	-404(ra) # 80004784 <brelse>
      break;
    80005920:	a8b9                	j	8000597e <writei+0x186>
    }
    log_write(bp);
    80005922:	fe043503          	ld	a0,-32(s0)
    80005926:	00001097          	auipc	ra,0x1
    8000592a:	ace080e7          	jalr	-1330(ra) # 800063f4 <log_write>
    brelse(bp);
    8000592e:	fe043503          	ld	a0,-32(s0)
    80005932:	fffff097          	auipc	ra,0xfffff
    80005936:	e52080e7          	jalr	-430(ra) # 80004784 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000593a:	fec42783          	lw	a5,-20(s0)
    8000593e:	873e                	mv	a4,a5
    80005940:	fdc42783          	lw	a5,-36(s0)
    80005944:	9fb9                	addw	a5,a5,a4
    80005946:	fef42623          	sw	a5,-20(s0)
    8000594a:	fc042783          	lw	a5,-64(s0)
    8000594e:	873e                	mv	a4,a5
    80005950:	fdc42783          	lw	a5,-36(s0)
    80005954:	9fb9                	addw	a5,a5,a4
    80005956:	fcf42023          	sw	a5,-64(s0)
    8000595a:	fdc46783          	lwu	a5,-36(s0)
    8000595e:	fb843703          	ld	a4,-72(s0)
    80005962:	97ba                	add	a5,a5,a4
    80005964:	faf43c23          	sd	a5,-72(s0)
    80005968:	fec42783          	lw	a5,-20(s0)
    8000596c:	873e                	mv	a4,a5
    8000596e:	fb442783          	lw	a5,-76(s0)
    80005972:	2701                	sext.w	a4,a4
    80005974:	2781                	sext.w	a5,a5
    80005976:	eef769e3          	bltu	a4,a5,80005868 <writei+0x70>
    8000597a:	a011                	j	8000597e <writei+0x186>
      break;
    8000597c:	0001                	nop
  }

  if(off > ip->size)
    8000597e:	fc843783          	ld	a5,-56(s0)
    80005982:	47fc                	lw	a5,76(a5)
    80005984:	fc042703          	lw	a4,-64(s0)
    80005988:	2701                	sext.w	a4,a4
    8000598a:	00e7f763          	bgeu	a5,a4,80005998 <writei+0x1a0>
    ip->size = off;
    8000598e:	fc843783          	ld	a5,-56(s0)
    80005992:	fc042703          	lw	a4,-64(s0)
    80005996:	c7f8                	sw	a4,76(a5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80005998:	fc843503          	ld	a0,-56(s0)
    8000599c:	fffff097          	auipc	ra,0xfffff
    800059a0:	4c2080e7          	jalr	1218(ra) # 80004e5e <iupdate>

  return tot;
    800059a4:	fec42783          	lw	a5,-20(s0)
}
    800059a8:	853e                	mv	a0,a5
    800059aa:	60a6                	ld	ra,72(sp)
    800059ac:	6406                	ld	s0,64(sp)
    800059ae:	6161                	addi	sp,sp,80
    800059b0:	8082                	ret

00000000800059b2 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800059b2:	1101                	addi	sp,sp,-32
    800059b4:	ec06                	sd	ra,24(sp)
    800059b6:	e822                	sd	s0,16(sp)
    800059b8:	1000                	addi	s0,sp,32
    800059ba:	fea43423          	sd	a0,-24(s0)
    800059be:	feb43023          	sd	a1,-32(s0)
  return strncmp(s, t, DIRSIZ);
    800059c2:	4639                	li	a2,14
    800059c4:	fe043583          	ld	a1,-32(s0)
    800059c8:	fe843503          	ld	a0,-24(s0)
    800059cc:	ffffc097          	auipc	ra,0xffffc
    800059d0:	cd0080e7          	jalr	-816(ra) # 8000169c <strncmp>
    800059d4:	87aa                	mv	a5,a0
}
    800059d6:	853e                	mv	a0,a5
    800059d8:	60e2                	ld	ra,24(sp)
    800059da:	6442                	ld	s0,16(sp)
    800059dc:	6105                	addi	sp,sp,32
    800059de:	8082                	ret

00000000800059e0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800059e0:	715d                	addi	sp,sp,-80
    800059e2:	e486                	sd	ra,72(sp)
    800059e4:	e0a2                	sd	s0,64(sp)
    800059e6:	0880                	addi	s0,sp,80
    800059e8:	fca43423          	sd	a0,-56(s0)
    800059ec:	fcb43023          	sd	a1,-64(s0)
    800059f0:	fac43c23          	sd	a2,-72(s0)
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800059f4:	fc843783          	ld	a5,-56(s0)
    800059f8:	04479703          	lh	a4,68(a5)
    800059fc:	4785                	li	a5,1
    800059fe:	00f70a63          	beq	a4,a5,80005a12 <dirlookup+0x32>
    panic("dirlookup not DIR");
    80005a02:	00006517          	auipc	a0,0x6
    80005a06:	b0650513          	addi	a0,a0,-1274 # 8000b508 <etext+0x508>
    80005a0a:	ffffb097          	auipc	ra,0xffffb
    80005a0e:	2b6080e7          	jalr	694(ra) # 80000cc0 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
    80005a12:	fe042623          	sw	zero,-20(s0)
    80005a16:	a849                	j	80005aa8 <dirlookup+0xc8>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005a18:	fd840793          	addi	a5,s0,-40
    80005a1c:	fec42683          	lw	a3,-20(s0)
    80005a20:	4741                	li	a4,16
    80005a22:	863e                	mv	a2,a5
    80005a24:	4581                	li	a1,0
    80005a26:	fc843503          	ld	a0,-56(s0)
    80005a2a:	00000097          	auipc	ra,0x0
    80005a2e:	c32080e7          	jalr	-974(ra) # 8000565c <readi>
    80005a32:	87aa                	mv	a5,a0
    80005a34:	873e                	mv	a4,a5
    80005a36:	47c1                	li	a5,16
    80005a38:	00f70a63          	beq	a4,a5,80005a4c <dirlookup+0x6c>
      panic("dirlookup read");
    80005a3c:	00006517          	auipc	a0,0x6
    80005a40:	ae450513          	addi	a0,a0,-1308 # 8000b520 <etext+0x520>
    80005a44:	ffffb097          	auipc	ra,0xffffb
    80005a48:	27c080e7          	jalr	636(ra) # 80000cc0 <panic>
    if(de.inum == 0)
    80005a4c:	fd845783          	lhu	a5,-40(s0)
    80005a50:	c7b1                	beqz	a5,80005a9c <dirlookup+0xbc>
      continue;
    if(namecmp(name, de.name) == 0){
    80005a52:	fd840793          	addi	a5,s0,-40
    80005a56:	0789                	addi	a5,a5,2
    80005a58:	85be                	mv	a1,a5
    80005a5a:	fc043503          	ld	a0,-64(s0)
    80005a5e:	00000097          	auipc	ra,0x0
    80005a62:	f54080e7          	jalr	-172(ra) # 800059b2 <namecmp>
    80005a66:	87aa                	mv	a5,a0
    80005a68:	eb9d                	bnez	a5,80005a9e <dirlookup+0xbe>
      // entry matches path element
      if(poff)
    80005a6a:	fb843783          	ld	a5,-72(s0)
    80005a6e:	c791                	beqz	a5,80005a7a <dirlookup+0x9a>
        *poff = off;
    80005a70:	fb843783          	ld	a5,-72(s0)
    80005a74:	fec42703          	lw	a4,-20(s0)
    80005a78:	c398                	sw	a4,0(a5)
      inum = de.inum;
    80005a7a:	fd845783          	lhu	a5,-40(s0)
    80005a7e:	fef42423          	sw	a5,-24(s0)
      return iget(dp->dev, inum);
    80005a82:	fc843783          	ld	a5,-56(s0)
    80005a86:	439c                	lw	a5,0(a5)
    80005a88:	fe842703          	lw	a4,-24(s0)
    80005a8c:	85ba                	mv	a1,a4
    80005a8e:	853e                	mv	a0,a5
    80005a90:	fffff097          	auipc	ra,0xfffff
    80005a94:	4b6080e7          	jalr	1206(ra) # 80004f46 <iget>
    80005a98:	87aa                	mv	a5,a0
    80005a9a:	a005                	j	80005aba <dirlookup+0xda>
      continue;
    80005a9c:	0001                	nop
  for(off = 0; off < dp->size; off += sizeof(de)){
    80005a9e:	fec42783          	lw	a5,-20(s0)
    80005aa2:	27c1                	addiw	a5,a5,16
    80005aa4:	fef42623          	sw	a5,-20(s0)
    80005aa8:	fc843783          	ld	a5,-56(s0)
    80005aac:	47fc                	lw	a5,76(a5)
    80005aae:	fec42703          	lw	a4,-20(s0)
    80005ab2:	2701                	sext.w	a4,a4
    80005ab4:	f6f762e3          	bltu	a4,a5,80005a18 <dirlookup+0x38>
    }
  }

  return 0;
    80005ab8:	4781                	li	a5,0
}
    80005aba:	853e                	mv	a0,a5
    80005abc:	60a6                	ld	ra,72(sp)
    80005abe:	6406                	ld	s0,64(sp)
    80005ac0:	6161                	addi	sp,sp,80
    80005ac2:	8082                	ret

0000000080005ac4 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
// Returns 0 on success, -1 on failure (e.g. out of disk blocks).
int
dirlink(struct inode *dp, char *name, uint inum)
{
    80005ac4:	715d                	addi	sp,sp,-80
    80005ac6:	e486                	sd	ra,72(sp)
    80005ac8:	e0a2                	sd	s0,64(sp)
    80005aca:	0880                	addi	s0,sp,80
    80005acc:	fca43423          	sd	a0,-56(s0)
    80005ad0:	fcb43023          	sd	a1,-64(s0)
    80005ad4:	87b2                	mv	a5,a2
    80005ad6:	faf42e23          	sw	a5,-68(s0)
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    80005ada:	4601                	li	a2,0
    80005adc:	fc043583          	ld	a1,-64(s0)
    80005ae0:	fc843503          	ld	a0,-56(s0)
    80005ae4:	00000097          	auipc	ra,0x0
    80005ae8:	efc080e7          	jalr	-260(ra) # 800059e0 <dirlookup>
    80005aec:	fea43023          	sd	a0,-32(s0)
    80005af0:	fe043783          	ld	a5,-32(s0)
    80005af4:	cb89                	beqz	a5,80005b06 <dirlink+0x42>
    iput(ip);
    80005af6:	fe043503          	ld	a0,-32(s0)
    80005afa:	fffff097          	auipc	ra,0xfffff
    80005afe:	742080e7          	jalr	1858(ra) # 8000523c <iput>
    return -1;
    80005b02:	57fd                	li	a5,-1
    80005b04:	a075                	j	80005bb0 <dirlink+0xec>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    80005b06:	fe042623          	sw	zero,-20(s0)
    80005b0a:	a0a1                	j	80005b52 <dirlink+0x8e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005b0c:	fd040793          	addi	a5,s0,-48
    80005b10:	fec42683          	lw	a3,-20(s0)
    80005b14:	4741                	li	a4,16
    80005b16:	863e                	mv	a2,a5
    80005b18:	4581                	li	a1,0
    80005b1a:	fc843503          	ld	a0,-56(s0)
    80005b1e:	00000097          	auipc	ra,0x0
    80005b22:	b3e080e7          	jalr	-1218(ra) # 8000565c <readi>
    80005b26:	87aa                	mv	a5,a0
    80005b28:	873e                	mv	a4,a5
    80005b2a:	47c1                	li	a5,16
    80005b2c:	00f70a63          	beq	a4,a5,80005b40 <dirlink+0x7c>
      panic("dirlink read");
    80005b30:	00006517          	auipc	a0,0x6
    80005b34:	a0050513          	addi	a0,a0,-1536 # 8000b530 <etext+0x530>
    80005b38:	ffffb097          	auipc	ra,0xffffb
    80005b3c:	188080e7          	jalr	392(ra) # 80000cc0 <panic>
    if(de.inum == 0)
    80005b40:	fd045783          	lhu	a5,-48(s0)
    80005b44:	cf99                	beqz	a5,80005b62 <dirlink+0x9e>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80005b46:	fec42783          	lw	a5,-20(s0)
    80005b4a:	27c1                	addiw	a5,a5,16
    80005b4c:	2781                	sext.w	a5,a5
    80005b4e:	fef42623          	sw	a5,-20(s0)
    80005b52:	fc843783          	ld	a5,-56(s0)
    80005b56:	47f8                	lw	a4,76(a5)
    80005b58:	fec42783          	lw	a5,-20(s0)
    80005b5c:	fae7e8e3          	bltu	a5,a4,80005b0c <dirlink+0x48>
    80005b60:	a011                	j	80005b64 <dirlink+0xa0>
      break;
    80005b62:	0001                	nop
  }

  strncpy(de.name, name, DIRSIZ);
    80005b64:	fd040793          	addi	a5,s0,-48
    80005b68:	0789                	addi	a5,a5,2
    80005b6a:	4639                	li	a2,14
    80005b6c:	fc043583          	ld	a1,-64(s0)
    80005b70:	853e                	mv	a0,a5
    80005b72:	ffffc097          	auipc	ra,0xffffc
    80005b76:	bb8080e7          	jalr	-1096(ra) # 8000172a <strncpy>
  de.inum = inum;
    80005b7a:	fbc42783          	lw	a5,-68(s0)
    80005b7e:	17c2                	slli	a5,a5,0x30
    80005b80:	93c1                	srli	a5,a5,0x30
    80005b82:	fcf41823          	sh	a5,-48(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005b86:	fd040793          	addi	a5,s0,-48
    80005b8a:	fec42683          	lw	a3,-20(s0)
    80005b8e:	4741                	li	a4,16
    80005b90:	863e                	mv	a2,a5
    80005b92:	4581                	li	a1,0
    80005b94:	fc843503          	ld	a0,-56(s0)
    80005b98:	00000097          	auipc	ra,0x0
    80005b9c:	c60080e7          	jalr	-928(ra) # 800057f8 <writei>
    80005ba0:	87aa                	mv	a5,a0
    80005ba2:	873e                	mv	a4,a5
    80005ba4:	47c1                	li	a5,16
    80005ba6:	00f70463          	beq	a4,a5,80005bae <dirlink+0xea>
    return -1;
    80005baa:	57fd                	li	a5,-1
    80005bac:	a011                	j	80005bb0 <dirlink+0xec>

  return 0;
    80005bae:	4781                	li	a5,0
}
    80005bb0:	853e                	mv	a0,a5
    80005bb2:	60a6                	ld	ra,72(sp)
    80005bb4:	6406                	ld	s0,64(sp)
    80005bb6:	6161                	addi	sp,sp,80
    80005bb8:	8082                	ret

0000000080005bba <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
    80005bba:	7179                	addi	sp,sp,-48
    80005bbc:	f406                	sd	ra,40(sp)
    80005bbe:	f022                	sd	s0,32(sp)
    80005bc0:	1800                	addi	s0,sp,48
    80005bc2:	fca43c23          	sd	a0,-40(s0)
    80005bc6:	fcb43823          	sd	a1,-48(s0)
  char *s;
  int len;

  while(*path == '/')
    80005bca:	a031                	j	80005bd6 <skipelem+0x1c>
    path++;
    80005bcc:	fd843783          	ld	a5,-40(s0)
    80005bd0:	0785                	addi	a5,a5,1
    80005bd2:	fcf43c23          	sd	a5,-40(s0)
  while(*path == '/')
    80005bd6:	fd843783          	ld	a5,-40(s0)
    80005bda:	0007c783          	lbu	a5,0(a5)
    80005bde:	873e                	mv	a4,a5
    80005be0:	02f00793          	li	a5,47
    80005be4:	fef704e3          	beq	a4,a5,80005bcc <skipelem+0x12>
  if(*path == 0)
    80005be8:	fd843783          	ld	a5,-40(s0)
    80005bec:	0007c783          	lbu	a5,0(a5)
    80005bf0:	e399                	bnez	a5,80005bf6 <skipelem+0x3c>
    return 0;
    80005bf2:	4781                	li	a5,0
    80005bf4:	a06d                	j	80005c9e <skipelem+0xe4>
  s = path;
    80005bf6:	fd843783          	ld	a5,-40(s0)
    80005bfa:	fef43423          	sd	a5,-24(s0)
  while(*path != '/' && *path != 0)
    80005bfe:	a031                	j	80005c0a <skipelem+0x50>
    path++;
    80005c00:	fd843783          	ld	a5,-40(s0)
    80005c04:	0785                	addi	a5,a5,1
    80005c06:	fcf43c23          	sd	a5,-40(s0)
  while(*path != '/' && *path != 0)
    80005c0a:	fd843783          	ld	a5,-40(s0)
    80005c0e:	0007c783          	lbu	a5,0(a5)
    80005c12:	873e                	mv	a4,a5
    80005c14:	02f00793          	li	a5,47
    80005c18:	00f70763          	beq	a4,a5,80005c26 <skipelem+0x6c>
    80005c1c:	fd843783          	ld	a5,-40(s0)
    80005c20:	0007c783          	lbu	a5,0(a5)
    80005c24:	fff1                	bnez	a5,80005c00 <skipelem+0x46>
  len = path - s;
    80005c26:	fd843703          	ld	a4,-40(s0)
    80005c2a:	fe843783          	ld	a5,-24(s0)
    80005c2e:	40f707b3          	sub	a5,a4,a5
    80005c32:	fef42223          	sw	a5,-28(s0)
  if(len >= DIRSIZ)
    80005c36:	fe442783          	lw	a5,-28(s0)
    80005c3a:	0007871b          	sext.w	a4,a5
    80005c3e:	47b5                	li	a5,13
    80005c40:	00e7dc63          	bge	a5,a4,80005c58 <skipelem+0x9e>
    memmove(name, s, DIRSIZ);
    80005c44:	4639                	li	a2,14
    80005c46:	fe843583          	ld	a1,-24(s0)
    80005c4a:	fd043503          	ld	a0,-48(s0)
    80005c4e:	ffffc097          	auipc	ra,0xffffc
    80005c52:	936080e7          	jalr	-1738(ra) # 80001584 <memmove>
    80005c56:	a80d                	j	80005c88 <skipelem+0xce>
  else {
    memmove(name, s, len);
    80005c58:	fe442783          	lw	a5,-28(s0)
    80005c5c:	863e                	mv	a2,a5
    80005c5e:	fe843583          	ld	a1,-24(s0)
    80005c62:	fd043503          	ld	a0,-48(s0)
    80005c66:	ffffc097          	auipc	ra,0xffffc
    80005c6a:	91e080e7          	jalr	-1762(ra) # 80001584 <memmove>
    name[len] = 0;
    80005c6e:	fe442783          	lw	a5,-28(s0)
    80005c72:	fd043703          	ld	a4,-48(s0)
    80005c76:	97ba                	add	a5,a5,a4
    80005c78:	00078023          	sb	zero,0(a5)
  }
  while(*path == '/')
    80005c7c:	a031                	j	80005c88 <skipelem+0xce>
    path++;
    80005c7e:	fd843783          	ld	a5,-40(s0)
    80005c82:	0785                	addi	a5,a5,1
    80005c84:	fcf43c23          	sd	a5,-40(s0)
  while(*path == '/')
    80005c88:	fd843783          	ld	a5,-40(s0)
    80005c8c:	0007c783          	lbu	a5,0(a5)
    80005c90:	873e                	mv	a4,a5
    80005c92:	02f00793          	li	a5,47
    80005c96:	fef704e3          	beq	a4,a5,80005c7e <skipelem+0xc4>
  return path;
    80005c9a:	fd843783          	ld	a5,-40(s0)
}
    80005c9e:	853e                	mv	a0,a5
    80005ca0:	70a2                	ld	ra,40(sp)
    80005ca2:	7402                	ld	s0,32(sp)
    80005ca4:	6145                	addi	sp,sp,48
    80005ca6:	8082                	ret

0000000080005ca8 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80005ca8:	7139                	addi	sp,sp,-64
    80005caa:	fc06                	sd	ra,56(sp)
    80005cac:	f822                	sd	s0,48(sp)
    80005cae:	0080                	addi	s0,sp,64
    80005cb0:	fca43c23          	sd	a0,-40(s0)
    80005cb4:	87ae                	mv	a5,a1
    80005cb6:	fcc43423          	sd	a2,-56(s0)
    80005cba:	fcf42a23          	sw	a5,-44(s0)
  struct inode *ip, *next;

  if(*path == '/')
    80005cbe:	fd843783          	ld	a5,-40(s0)
    80005cc2:	0007c783          	lbu	a5,0(a5)
    80005cc6:	873e                	mv	a4,a5
    80005cc8:	02f00793          	li	a5,47
    80005ccc:	00f71b63          	bne	a4,a5,80005ce2 <namex+0x3a>
    ip = iget(ROOTDEV, ROOTINO);
    80005cd0:	4585                	li	a1,1
    80005cd2:	4505                	li	a0,1
    80005cd4:	fffff097          	auipc	ra,0xfffff
    80005cd8:	272080e7          	jalr	626(ra) # 80004f46 <iget>
    80005cdc:	fea43423          	sd	a0,-24(s0)
    80005ce0:	a07d                	j	80005d8e <namex+0xe6>
  else
    ip = idup(myproc()->cwd);
    80005ce2:	ffffd097          	auipc	ra,0xffffd
    80005ce6:	bda080e7          	jalr	-1062(ra) # 800028bc <myproc>
    80005cea:	87aa                	mv	a5,a0
    80005cec:	1507b783          	ld	a5,336(a5)
    80005cf0:	853e                	mv	a0,a5
    80005cf2:	fffff097          	auipc	ra,0xfffff
    80005cf6:	370080e7          	jalr	880(ra) # 80005062 <idup>
    80005cfa:	fea43423          	sd	a0,-24(s0)

  while((path = skipelem(path, name)) != 0){
    80005cfe:	a841                	j	80005d8e <namex+0xe6>
    ilock(ip);
    80005d00:	fe843503          	ld	a0,-24(s0)
    80005d04:	fffff097          	auipc	ra,0xfffff
    80005d08:	3aa080e7          	jalr	938(ra) # 800050ae <ilock>
    if(ip->type != T_DIR){
    80005d0c:	fe843783          	ld	a5,-24(s0)
    80005d10:	04479703          	lh	a4,68(a5)
    80005d14:	4785                	li	a5,1
    80005d16:	00f70a63          	beq	a4,a5,80005d2a <namex+0x82>
      iunlockput(ip);
    80005d1a:	fe843503          	ld	a0,-24(s0)
    80005d1e:	fffff097          	auipc	ra,0xfffff
    80005d22:	5ec080e7          	jalr	1516(ra) # 8000530a <iunlockput>
      return 0;
    80005d26:	4781                	li	a5,0
    80005d28:	a871                	j	80005dc4 <namex+0x11c>
    }
    if(nameiparent && *path == '\0'){
    80005d2a:	fd442783          	lw	a5,-44(s0)
    80005d2e:	2781                	sext.w	a5,a5
    80005d30:	cf99                	beqz	a5,80005d4e <namex+0xa6>
    80005d32:	fd843783          	ld	a5,-40(s0)
    80005d36:	0007c783          	lbu	a5,0(a5)
    80005d3a:	eb91                	bnez	a5,80005d4e <namex+0xa6>
      // Stop one level early.
      iunlock(ip);
    80005d3c:	fe843503          	ld	a0,-24(s0)
    80005d40:	fffff097          	auipc	ra,0xfffff
    80005d44:	4a2080e7          	jalr	1186(ra) # 800051e2 <iunlock>
      return ip;
    80005d48:	fe843783          	ld	a5,-24(s0)
    80005d4c:	a8a5                	j	80005dc4 <namex+0x11c>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
    80005d4e:	4601                	li	a2,0
    80005d50:	fc843583          	ld	a1,-56(s0)
    80005d54:	fe843503          	ld	a0,-24(s0)
    80005d58:	00000097          	auipc	ra,0x0
    80005d5c:	c88080e7          	jalr	-888(ra) # 800059e0 <dirlookup>
    80005d60:	fea43023          	sd	a0,-32(s0)
    80005d64:	fe043783          	ld	a5,-32(s0)
    80005d68:	eb89                	bnez	a5,80005d7a <namex+0xd2>
      iunlockput(ip);
    80005d6a:	fe843503          	ld	a0,-24(s0)
    80005d6e:	fffff097          	auipc	ra,0xfffff
    80005d72:	59c080e7          	jalr	1436(ra) # 8000530a <iunlockput>
      return 0;
    80005d76:	4781                	li	a5,0
    80005d78:	a0b1                	j	80005dc4 <namex+0x11c>
    }
    iunlockput(ip);
    80005d7a:	fe843503          	ld	a0,-24(s0)
    80005d7e:	fffff097          	auipc	ra,0xfffff
    80005d82:	58c080e7          	jalr	1420(ra) # 8000530a <iunlockput>
    ip = next;
    80005d86:	fe043783          	ld	a5,-32(s0)
    80005d8a:	fef43423          	sd	a5,-24(s0)
  while((path = skipelem(path, name)) != 0){
    80005d8e:	fc843583          	ld	a1,-56(s0)
    80005d92:	fd843503          	ld	a0,-40(s0)
    80005d96:	00000097          	auipc	ra,0x0
    80005d9a:	e24080e7          	jalr	-476(ra) # 80005bba <skipelem>
    80005d9e:	fca43c23          	sd	a0,-40(s0)
    80005da2:	fd843783          	ld	a5,-40(s0)
    80005da6:	ffa9                	bnez	a5,80005d00 <namex+0x58>
  }
  if(nameiparent){
    80005da8:	fd442783          	lw	a5,-44(s0)
    80005dac:	2781                	sext.w	a5,a5
    80005dae:	cb89                	beqz	a5,80005dc0 <namex+0x118>
    iput(ip);
    80005db0:	fe843503          	ld	a0,-24(s0)
    80005db4:	fffff097          	auipc	ra,0xfffff
    80005db8:	488080e7          	jalr	1160(ra) # 8000523c <iput>
    return 0;
    80005dbc:	4781                	li	a5,0
    80005dbe:	a019                	j	80005dc4 <namex+0x11c>
  }
  return ip;
    80005dc0:	fe843783          	ld	a5,-24(s0)
}
    80005dc4:	853e                	mv	a0,a5
    80005dc6:	70e2                	ld	ra,56(sp)
    80005dc8:	7442                	ld	s0,48(sp)
    80005dca:	6121                	addi	sp,sp,64
    80005dcc:	8082                	ret

0000000080005dce <namei>:

struct inode*
namei(char *path)
{
    80005dce:	7179                	addi	sp,sp,-48
    80005dd0:	f406                	sd	ra,40(sp)
    80005dd2:	f022                	sd	s0,32(sp)
    80005dd4:	1800                	addi	s0,sp,48
    80005dd6:	fca43c23          	sd	a0,-40(s0)
  char name[DIRSIZ];
  return namex(path, 0, name);
    80005dda:	fe040793          	addi	a5,s0,-32
    80005dde:	863e                	mv	a2,a5
    80005de0:	4581                	li	a1,0
    80005de2:	fd843503          	ld	a0,-40(s0)
    80005de6:	00000097          	auipc	ra,0x0
    80005dea:	ec2080e7          	jalr	-318(ra) # 80005ca8 <namex>
    80005dee:	87aa                	mv	a5,a0
}
    80005df0:	853e                	mv	a0,a5
    80005df2:	70a2                	ld	ra,40(sp)
    80005df4:	7402                	ld	s0,32(sp)
    80005df6:	6145                	addi	sp,sp,48
    80005df8:	8082                	ret

0000000080005dfa <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80005dfa:	1101                	addi	sp,sp,-32
    80005dfc:	ec06                	sd	ra,24(sp)
    80005dfe:	e822                	sd	s0,16(sp)
    80005e00:	1000                	addi	s0,sp,32
    80005e02:	fea43423          	sd	a0,-24(s0)
    80005e06:	feb43023          	sd	a1,-32(s0)
  return namex(path, 1, name);
    80005e0a:	fe043603          	ld	a2,-32(s0)
    80005e0e:	4585                	li	a1,1
    80005e10:	fe843503          	ld	a0,-24(s0)
    80005e14:	00000097          	auipc	ra,0x0
    80005e18:	e94080e7          	jalr	-364(ra) # 80005ca8 <namex>
    80005e1c:	87aa                	mv	a5,a0
}
    80005e1e:	853e                	mv	a0,a5
    80005e20:	60e2                	ld	ra,24(sp)
    80005e22:	6442                	ld	s0,16(sp)
    80005e24:	6105                	addi	sp,sp,32
    80005e26:	8082                	ret

0000000080005e28 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev, struct superblock *sb)
{
    80005e28:	1101                	addi	sp,sp,-32
    80005e2a:	ec06                	sd	ra,24(sp)
    80005e2c:	e822                	sd	s0,16(sp)
    80005e2e:	1000                	addi	s0,sp,32
    80005e30:	87aa                	mv	a5,a0
    80005e32:	feb43023          	sd	a1,-32(s0)
    80005e36:	fef42623          	sw	a5,-20(s0)
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  initlock(&log.lock, "log");
    80005e3a:	00005597          	auipc	a1,0x5
    80005e3e:	70658593          	addi	a1,a1,1798 # 8000b540 <etext+0x540>
    80005e42:	0001e517          	auipc	a0,0x1e
    80005e46:	cc650513          	addi	a0,a0,-826 # 80023b08 <log>
    80005e4a:	ffffb097          	auipc	ra,0xffffb
    80005e4e:	446080e7          	jalr	1094(ra) # 80001290 <initlock>
  log.start = sb->logstart;
    80005e52:	fe043783          	ld	a5,-32(s0)
    80005e56:	4bdc                	lw	a5,20(a5)
    80005e58:	873e                	mv	a4,a5
    80005e5a:	0001e797          	auipc	a5,0x1e
    80005e5e:	cae78793          	addi	a5,a5,-850 # 80023b08 <log>
    80005e62:	cf98                	sw	a4,24(a5)
  log.size = sb->nlog;
    80005e64:	fe043783          	ld	a5,-32(s0)
    80005e68:	4b9c                	lw	a5,16(a5)
    80005e6a:	873e                	mv	a4,a5
    80005e6c:	0001e797          	auipc	a5,0x1e
    80005e70:	c9c78793          	addi	a5,a5,-868 # 80023b08 <log>
    80005e74:	cfd8                	sw	a4,28(a5)
  log.dev = dev;
    80005e76:	0001e797          	auipc	a5,0x1e
    80005e7a:	c9278793          	addi	a5,a5,-878 # 80023b08 <log>
    80005e7e:	fec42703          	lw	a4,-20(s0)
    80005e82:	d798                	sw	a4,40(a5)
  recover_from_log();
    80005e84:	00000097          	auipc	ra,0x0
    80005e88:	262080e7          	jalr	610(ra) # 800060e6 <recover_from_log>
}
    80005e8c:	0001                	nop
    80005e8e:	60e2                	ld	ra,24(sp)
    80005e90:	6442                	ld	s0,16(sp)
    80005e92:	6105                	addi	sp,sp,32
    80005e94:	8082                	ret

0000000080005e96 <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(int recovering)
{
    80005e96:	7139                	addi	sp,sp,-64
    80005e98:	fc06                	sd	ra,56(sp)
    80005e9a:	f822                	sd	s0,48(sp)
    80005e9c:	0080                	addi	s0,sp,64
    80005e9e:	87aa                	mv	a5,a0
    80005ea0:	fcf42623          	sw	a5,-52(s0)
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    80005ea4:	fe042623          	sw	zero,-20(s0)
    80005ea8:	a0d9                	j	80005f6e <install_trans+0xd8>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80005eaa:	0001e797          	auipc	a5,0x1e
    80005eae:	c5e78793          	addi	a5,a5,-930 # 80023b08 <log>
    80005eb2:	579c                	lw	a5,40(a5)
    80005eb4:	86be                	mv	a3,a5
    80005eb6:	0001e797          	auipc	a5,0x1e
    80005eba:	c5278793          	addi	a5,a5,-942 # 80023b08 <log>
    80005ebe:	4f9c                	lw	a5,24(a5)
    80005ec0:	fec42703          	lw	a4,-20(s0)
    80005ec4:	9fb9                	addw	a5,a5,a4
    80005ec6:	2781                	sext.w	a5,a5
    80005ec8:	2785                	addiw	a5,a5,1
    80005eca:	2781                	sext.w	a5,a5
    80005ecc:	85be                	mv	a1,a5
    80005ece:	8536                	mv	a0,a3
    80005ed0:	fffff097          	auipc	ra,0xfffff
    80005ed4:	812080e7          	jalr	-2030(ra) # 800046e2 <bread>
    80005ed8:	fea43023          	sd	a0,-32(s0)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80005edc:	0001e797          	auipc	a5,0x1e
    80005ee0:	c2c78793          	addi	a5,a5,-980 # 80023b08 <log>
    80005ee4:	579c                	lw	a5,40(a5)
    80005ee6:	86be                	mv	a3,a5
    80005ee8:	0001e717          	auipc	a4,0x1e
    80005eec:	c2070713          	addi	a4,a4,-992 # 80023b08 <log>
    80005ef0:	fec42783          	lw	a5,-20(s0)
    80005ef4:	07a1                	addi	a5,a5,8
    80005ef6:	078a                	slli	a5,a5,0x2
    80005ef8:	97ba                	add	a5,a5,a4
    80005efa:	4b9c                	lw	a5,16(a5)
    80005efc:	85be                	mv	a1,a5
    80005efe:	8536                	mv	a0,a3
    80005f00:	ffffe097          	auipc	ra,0xffffe
    80005f04:	7e2080e7          	jalr	2018(ra) # 800046e2 <bread>
    80005f08:	fca43c23          	sd	a0,-40(s0)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80005f0c:	fd843783          	ld	a5,-40(s0)
    80005f10:	05878713          	addi	a4,a5,88
    80005f14:	fe043783          	ld	a5,-32(s0)
    80005f18:	05878793          	addi	a5,a5,88
    80005f1c:	40000613          	li	a2,1024
    80005f20:	85be                	mv	a1,a5
    80005f22:	853a                	mv	a0,a4
    80005f24:	ffffb097          	auipc	ra,0xffffb
    80005f28:	660080e7          	jalr	1632(ra) # 80001584 <memmove>
    bwrite(dbuf);  // write dst to disk
    80005f2c:	fd843503          	ld	a0,-40(s0)
    80005f30:	fffff097          	auipc	ra,0xfffff
    80005f34:	80c080e7          	jalr	-2036(ra) # 8000473c <bwrite>
    if(recovering == 0)
    80005f38:	fcc42783          	lw	a5,-52(s0)
    80005f3c:	2781                	sext.w	a5,a5
    80005f3e:	e799                	bnez	a5,80005f4c <install_trans+0xb6>
      bunpin(dbuf);
    80005f40:	fd843503          	ld	a0,-40(s0)
    80005f44:	fffff097          	auipc	ra,0xfffff
    80005f48:	976080e7          	jalr	-1674(ra) # 800048ba <bunpin>
    brelse(lbuf);
    80005f4c:	fe043503          	ld	a0,-32(s0)
    80005f50:	fffff097          	auipc	ra,0xfffff
    80005f54:	834080e7          	jalr	-1996(ra) # 80004784 <brelse>
    brelse(dbuf);
    80005f58:	fd843503          	ld	a0,-40(s0)
    80005f5c:	fffff097          	auipc	ra,0xfffff
    80005f60:	828080e7          	jalr	-2008(ra) # 80004784 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80005f64:	fec42783          	lw	a5,-20(s0)
    80005f68:	2785                	addiw	a5,a5,1
    80005f6a:	fef42623          	sw	a5,-20(s0)
    80005f6e:	0001e797          	auipc	a5,0x1e
    80005f72:	b9a78793          	addi	a5,a5,-1126 # 80023b08 <log>
    80005f76:	57dc                	lw	a5,44(a5)
    80005f78:	fec42703          	lw	a4,-20(s0)
    80005f7c:	2701                	sext.w	a4,a4
    80005f7e:	f2f746e3          	blt	a4,a5,80005eaa <install_trans+0x14>
  }
}
    80005f82:	0001                	nop
    80005f84:	0001                	nop
    80005f86:	70e2                	ld	ra,56(sp)
    80005f88:	7442                	ld	s0,48(sp)
    80005f8a:	6121                	addi	sp,sp,64
    80005f8c:	8082                	ret

0000000080005f8e <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
    80005f8e:	7179                	addi	sp,sp,-48
    80005f90:	f406                	sd	ra,40(sp)
    80005f92:	f022                	sd	s0,32(sp)
    80005f94:	1800                	addi	s0,sp,48
  struct buf *buf = bread(log.dev, log.start);
    80005f96:	0001e797          	auipc	a5,0x1e
    80005f9a:	b7278793          	addi	a5,a5,-1166 # 80023b08 <log>
    80005f9e:	579c                	lw	a5,40(a5)
    80005fa0:	873e                	mv	a4,a5
    80005fa2:	0001e797          	auipc	a5,0x1e
    80005fa6:	b6678793          	addi	a5,a5,-1178 # 80023b08 <log>
    80005faa:	4f9c                	lw	a5,24(a5)
    80005fac:	85be                	mv	a1,a5
    80005fae:	853a                	mv	a0,a4
    80005fb0:	ffffe097          	auipc	ra,0xffffe
    80005fb4:	732080e7          	jalr	1842(ra) # 800046e2 <bread>
    80005fb8:	fea43023          	sd	a0,-32(s0)
  struct logheader *lh = (struct logheader *) (buf->data);
    80005fbc:	fe043783          	ld	a5,-32(s0)
    80005fc0:	05878793          	addi	a5,a5,88
    80005fc4:	fcf43c23          	sd	a5,-40(s0)
  int i;
  log.lh.n = lh->n;
    80005fc8:	fd843783          	ld	a5,-40(s0)
    80005fcc:	4398                	lw	a4,0(a5)
    80005fce:	0001e797          	auipc	a5,0x1e
    80005fd2:	b3a78793          	addi	a5,a5,-1222 # 80023b08 <log>
    80005fd6:	d7d8                	sw	a4,44(a5)
  for (i = 0; i < log.lh.n; i++) {
    80005fd8:	fe042623          	sw	zero,-20(s0)
    80005fdc:	a03d                	j	8000600a <read_head+0x7c>
    log.lh.block[i] = lh->block[i];
    80005fde:	fd843703          	ld	a4,-40(s0)
    80005fe2:	fec42783          	lw	a5,-20(s0)
    80005fe6:	078a                	slli	a5,a5,0x2
    80005fe8:	97ba                	add	a5,a5,a4
    80005fea:	43d8                	lw	a4,4(a5)
    80005fec:	0001e697          	auipc	a3,0x1e
    80005ff0:	b1c68693          	addi	a3,a3,-1252 # 80023b08 <log>
    80005ff4:	fec42783          	lw	a5,-20(s0)
    80005ff8:	07a1                	addi	a5,a5,8
    80005ffa:	078a                	slli	a5,a5,0x2
    80005ffc:	97b6                	add	a5,a5,a3
    80005ffe:	cb98                	sw	a4,16(a5)
  for (i = 0; i < log.lh.n; i++) {
    80006000:	fec42783          	lw	a5,-20(s0)
    80006004:	2785                	addiw	a5,a5,1
    80006006:	fef42623          	sw	a5,-20(s0)
    8000600a:	0001e797          	auipc	a5,0x1e
    8000600e:	afe78793          	addi	a5,a5,-1282 # 80023b08 <log>
    80006012:	57dc                	lw	a5,44(a5)
    80006014:	fec42703          	lw	a4,-20(s0)
    80006018:	2701                	sext.w	a4,a4
    8000601a:	fcf742e3          	blt	a4,a5,80005fde <read_head+0x50>
  }
  brelse(buf);
    8000601e:	fe043503          	ld	a0,-32(s0)
    80006022:	ffffe097          	auipc	ra,0xffffe
    80006026:	762080e7          	jalr	1890(ra) # 80004784 <brelse>
}
    8000602a:	0001                	nop
    8000602c:	70a2                	ld	ra,40(sp)
    8000602e:	7402                	ld	s0,32(sp)
    80006030:	6145                	addi	sp,sp,48
    80006032:	8082                	ret

0000000080006034 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80006034:	7179                	addi	sp,sp,-48
    80006036:	f406                	sd	ra,40(sp)
    80006038:	f022                	sd	s0,32(sp)
    8000603a:	1800                	addi	s0,sp,48
  struct buf *buf = bread(log.dev, log.start);
    8000603c:	0001e797          	auipc	a5,0x1e
    80006040:	acc78793          	addi	a5,a5,-1332 # 80023b08 <log>
    80006044:	579c                	lw	a5,40(a5)
    80006046:	873e                	mv	a4,a5
    80006048:	0001e797          	auipc	a5,0x1e
    8000604c:	ac078793          	addi	a5,a5,-1344 # 80023b08 <log>
    80006050:	4f9c                	lw	a5,24(a5)
    80006052:	85be                	mv	a1,a5
    80006054:	853a                	mv	a0,a4
    80006056:	ffffe097          	auipc	ra,0xffffe
    8000605a:	68c080e7          	jalr	1676(ra) # 800046e2 <bread>
    8000605e:	fea43023          	sd	a0,-32(s0)
  struct logheader *hb = (struct logheader *) (buf->data);
    80006062:	fe043783          	ld	a5,-32(s0)
    80006066:	05878793          	addi	a5,a5,88
    8000606a:	fcf43c23          	sd	a5,-40(s0)
  int i;
  hb->n = log.lh.n;
    8000606e:	0001e797          	auipc	a5,0x1e
    80006072:	a9a78793          	addi	a5,a5,-1382 # 80023b08 <log>
    80006076:	57d8                	lw	a4,44(a5)
    80006078:	fd843783          	ld	a5,-40(s0)
    8000607c:	c398                	sw	a4,0(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000607e:	fe042623          	sw	zero,-20(s0)
    80006082:	a03d                	j	800060b0 <write_head+0x7c>
    hb->block[i] = log.lh.block[i];
    80006084:	0001e717          	auipc	a4,0x1e
    80006088:	a8470713          	addi	a4,a4,-1404 # 80023b08 <log>
    8000608c:	fec42783          	lw	a5,-20(s0)
    80006090:	07a1                	addi	a5,a5,8
    80006092:	078a                	slli	a5,a5,0x2
    80006094:	97ba                	add	a5,a5,a4
    80006096:	4b98                	lw	a4,16(a5)
    80006098:	fd843683          	ld	a3,-40(s0)
    8000609c:	fec42783          	lw	a5,-20(s0)
    800060a0:	078a                	slli	a5,a5,0x2
    800060a2:	97b6                	add	a5,a5,a3
    800060a4:	c3d8                	sw	a4,4(a5)
  for (i = 0; i < log.lh.n; i++) {
    800060a6:	fec42783          	lw	a5,-20(s0)
    800060aa:	2785                	addiw	a5,a5,1
    800060ac:	fef42623          	sw	a5,-20(s0)
    800060b0:	0001e797          	auipc	a5,0x1e
    800060b4:	a5878793          	addi	a5,a5,-1448 # 80023b08 <log>
    800060b8:	57dc                	lw	a5,44(a5)
    800060ba:	fec42703          	lw	a4,-20(s0)
    800060be:	2701                	sext.w	a4,a4
    800060c0:	fcf742e3          	blt	a4,a5,80006084 <write_head+0x50>
  }
  bwrite(buf);
    800060c4:	fe043503          	ld	a0,-32(s0)
    800060c8:	ffffe097          	auipc	ra,0xffffe
    800060cc:	674080e7          	jalr	1652(ra) # 8000473c <bwrite>
  brelse(buf);
    800060d0:	fe043503          	ld	a0,-32(s0)
    800060d4:	ffffe097          	auipc	ra,0xffffe
    800060d8:	6b0080e7          	jalr	1712(ra) # 80004784 <brelse>
}
    800060dc:	0001                	nop
    800060de:	70a2                	ld	ra,40(sp)
    800060e0:	7402                	ld	s0,32(sp)
    800060e2:	6145                	addi	sp,sp,48
    800060e4:	8082                	ret

00000000800060e6 <recover_from_log>:

static void
recover_from_log(void)
{
    800060e6:	1141                	addi	sp,sp,-16
    800060e8:	e406                	sd	ra,8(sp)
    800060ea:	e022                	sd	s0,0(sp)
    800060ec:	0800                	addi	s0,sp,16
  read_head();
    800060ee:	00000097          	auipc	ra,0x0
    800060f2:	ea0080e7          	jalr	-352(ra) # 80005f8e <read_head>
  install_trans(1); // if committed, copy from log to disk
    800060f6:	4505                	li	a0,1
    800060f8:	00000097          	auipc	ra,0x0
    800060fc:	d9e080e7          	jalr	-610(ra) # 80005e96 <install_trans>
  log.lh.n = 0;
    80006100:	0001e797          	auipc	a5,0x1e
    80006104:	a0878793          	addi	a5,a5,-1528 # 80023b08 <log>
    80006108:	0207a623          	sw	zero,44(a5)
  write_head(); // clear the log
    8000610c:	00000097          	auipc	ra,0x0
    80006110:	f28080e7          	jalr	-216(ra) # 80006034 <write_head>
}
    80006114:	0001                	nop
    80006116:	60a2                	ld	ra,8(sp)
    80006118:	6402                	ld	s0,0(sp)
    8000611a:	0141                	addi	sp,sp,16
    8000611c:	8082                	ret

000000008000611e <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
    8000611e:	1141                	addi	sp,sp,-16
    80006120:	e406                	sd	ra,8(sp)
    80006122:	e022                	sd	s0,0(sp)
    80006124:	0800                	addi	s0,sp,16
  acquire(&log.lock);
    80006126:	0001e517          	auipc	a0,0x1e
    8000612a:	9e250513          	addi	a0,a0,-1566 # 80023b08 <log>
    8000612e:	ffffb097          	auipc	ra,0xffffb
    80006132:	196080e7          	jalr	406(ra) # 800012c4 <acquire>
  while(1){
    if(log.committing){
    80006136:	0001e797          	auipc	a5,0x1e
    8000613a:	9d278793          	addi	a5,a5,-1582 # 80023b08 <log>
    8000613e:	53dc                	lw	a5,36(a5)
    80006140:	cf91                	beqz	a5,8000615c <begin_op+0x3e>
      sleep(&log, &log.lock);
    80006142:	0001e597          	auipc	a1,0x1e
    80006146:	9c658593          	addi	a1,a1,-1594 # 80023b08 <log>
    8000614a:	0001e517          	auipc	a0,0x1e
    8000614e:	9be50513          	addi	a0,a0,-1602 # 80023b08 <log>
    80006152:	ffffd097          	auipc	ra,0xffffd
    80006156:	324080e7          	jalr	804(ra) # 80003476 <sleep>
    8000615a:	bff1                	j	80006136 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000615c:	0001e797          	auipc	a5,0x1e
    80006160:	9ac78793          	addi	a5,a5,-1620 # 80023b08 <log>
    80006164:	57d8                	lw	a4,44(a5)
    80006166:	0001e797          	auipc	a5,0x1e
    8000616a:	9a278793          	addi	a5,a5,-1630 # 80023b08 <log>
    8000616e:	539c                	lw	a5,32(a5)
    80006170:	2785                	addiw	a5,a5,1
    80006172:	2781                	sext.w	a5,a5
    80006174:	86be                	mv	a3,a5
    80006176:	87b6                	mv	a5,a3
    80006178:	0027979b          	slliw	a5,a5,0x2
    8000617c:	9fb5                	addw	a5,a5,a3
    8000617e:	0017979b          	slliw	a5,a5,0x1
    80006182:	2781                	sext.w	a5,a5
    80006184:	9fb9                	addw	a5,a5,a4
    80006186:	0007871b          	sext.w	a4,a5
    8000618a:	47f9                	li	a5,30
    8000618c:	00e7df63          	bge	a5,a4,800061aa <begin_op+0x8c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80006190:	0001e597          	auipc	a1,0x1e
    80006194:	97858593          	addi	a1,a1,-1672 # 80023b08 <log>
    80006198:	0001e517          	auipc	a0,0x1e
    8000619c:	97050513          	addi	a0,a0,-1680 # 80023b08 <log>
    800061a0:	ffffd097          	auipc	ra,0xffffd
    800061a4:	2d6080e7          	jalr	726(ra) # 80003476 <sleep>
    800061a8:	b779                	j	80006136 <begin_op+0x18>
    } else {
      log.outstanding += 1;
    800061aa:	0001e797          	auipc	a5,0x1e
    800061ae:	95e78793          	addi	a5,a5,-1698 # 80023b08 <log>
    800061b2:	539c                	lw	a5,32(a5)
    800061b4:	2785                	addiw	a5,a5,1
    800061b6:	0007871b          	sext.w	a4,a5
    800061ba:	0001e797          	auipc	a5,0x1e
    800061be:	94e78793          	addi	a5,a5,-1714 # 80023b08 <log>
    800061c2:	d398                	sw	a4,32(a5)
      release(&log.lock);
    800061c4:	0001e517          	auipc	a0,0x1e
    800061c8:	94450513          	addi	a0,a0,-1724 # 80023b08 <log>
    800061cc:	ffffb097          	auipc	ra,0xffffb
    800061d0:	15c080e7          	jalr	348(ra) # 80001328 <release>
      break;
    800061d4:	0001                	nop
    }
  }
}
    800061d6:	0001                	nop
    800061d8:	60a2                	ld	ra,8(sp)
    800061da:	6402                	ld	s0,0(sp)
    800061dc:	0141                	addi	sp,sp,16
    800061de:	8082                	ret

00000000800061e0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800061e0:	1101                	addi	sp,sp,-32
    800061e2:	ec06                	sd	ra,24(sp)
    800061e4:	e822                	sd	s0,16(sp)
    800061e6:	1000                	addi	s0,sp,32
  int do_commit = 0;
    800061e8:	fe042623          	sw	zero,-20(s0)

  acquire(&log.lock);
    800061ec:	0001e517          	auipc	a0,0x1e
    800061f0:	91c50513          	addi	a0,a0,-1764 # 80023b08 <log>
    800061f4:	ffffb097          	auipc	ra,0xffffb
    800061f8:	0d0080e7          	jalr	208(ra) # 800012c4 <acquire>
  log.outstanding -= 1;
    800061fc:	0001e797          	auipc	a5,0x1e
    80006200:	90c78793          	addi	a5,a5,-1780 # 80023b08 <log>
    80006204:	539c                	lw	a5,32(a5)
    80006206:	37fd                	addiw	a5,a5,-1
    80006208:	0007871b          	sext.w	a4,a5
    8000620c:	0001e797          	auipc	a5,0x1e
    80006210:	8fc78793          	addi	a5,a5,-1796 # 80023b08 <log>
    80006214:	d398                	sw	a4,32(a5)
  if(log.committing)
    80006216:	0001e797          	auipc	a5,0x1e
    8000621a:	8f278793          	addi	a5,a5,-1806 # 80023b08 <log>
    8000621e:	53dc                	lw	a5,36(a5)
    80006220:	cb89                	beqz	a5,80006232 <end_op+0x52>
    panic("log.committing");
    80006222:	00005517          	auipc	a0,0x5
    80006226:	32650513          	addi	a0,a0,806 # 8000b548 <etext+0x548>
    8000622a:	ffffb097          	auipc	ra,0xffffb
    8000622e:	a96080e7          	jalr	-1386(ra) # 80000cc0 <panic>
  if(log.outstanding == 0){
    80006232:	0001e797          	auipc	a5,0x1e
    80006236:	8d678793          	addi	a5,a5,-1834 # 80023b08 <log>
    8000623a:	539c                	lw	a5,32(a5)
    8000623c:	eb99                	bnez	a5,80006252 <end_op+0x72>
    do_commit = 1;
    8000623e:	4785                	li	a5,1
    80006240:	fef42623          	sw	a5,-20(s0)
    log.committing = 1;
    80006244:	0001e797          	auipc	a5,0x1e
    80006248:	8c478793          	addi	a5,a5,-1852 # 80023b08 <log>
    8000624c:	4705                	li	a4,1
    8000624e:	d3d8                	sw	a4,36(a5)
    80006250:	a809                	j	80006262 <end_op+0x82>
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
    80006252:	0001e517          	auipc	a0,0x1e
    80006256:	8b650513          	addi	a0,a0,-1866 # 80023b08 <log>
    8000625a:	ffffd097          	auipc	ra,0xffffd
    8000625e:	298080e7          	jalr	664(ra) # 800034f2 <wakeup>
  }
  release(&log.lock);
    80006262:	0001e517          	auipc	a0,0x1e
    80006266:	8a650513          	addi	a0,a0,-1882 # 80023b08 <log>
    8000626a:	ffffb097          	auipc	ra,0xffffb
    8000626e:	0be080e7          	jalr	190(ra) # 80001328 <release>

  if(do_commit){
    80006272:	fec42783          	lw	a5,-20(s0)
    80006276:	2781                	sext.w	a5,a5
    80006278:	c3b9                	beqz	a5,800062be <end_op+0xde>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    8000627a:	00000097          	auipc	ra,0x0
    8000627e:	12c080e7          	jalr	300(ra) # 800063a6 <commit>
    acquire(&log.lock);
    80006282:	0001e517          	auipc	a0,0x1e
    80006286:	88650513          	addi	a0,a0,-1914 # 80023b08 <log>
    8000628a:	ffffb097          	auipc	ra,0xffffb
    8000628e:	03a080e7          	jalr	58(ra) # 800012c4 <acquire>
    log.committing = 0;
    80006292:	0001e797          	auipc	a5,0x1e
    80006296:	87678793          	addi	a5,a5,-1930 # 80023b08 <log>
    8000629a:	0207a223          	sw	zero,36(a5)
    wakeup(&log);
    8000629e:	0001e517          	auipc	a0,0x1e
    800062a2:	86a50513          	addi	a0,a0,-1942 # 80023b08 <log>
    800062a6:	ffffd097          	auipc	ra,0xffffd
    800062aa:	24c080e7          	jalr	588(ra) # 800034f2 <wakeup>
    release(&log.lock);
    800062ae:	0001e517          	auipc	a0,0x1e
    800062b2:	85a50513          	addi	a0,a0,-1958 # 80023b08 <log>
    800062b6:	ffffb097          	auipc	ra,0xffffb
    800062ba:	072080e7          	jalr	114(ra) # 80001328 <release>
  }
}
    800062be:	0001                	nop
    800062c0:	60e2                	ld	ra,24(sp)
    800062c2:	6442                	ld	s0,16(sp)
    800062c4:	6105                	addi	sp,sp,32
    800062c6:	8082                	ret

00000000800062c8 <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
    800062c8:	7179                	addi	sp,sp,-48
    800062ca:	f406                	sd	ra,40(sp)
    800062cc:	f022                	sd	s0,32(sp)
    800062ce:	1800                	addi	s0,sp,48
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    800062d0:	fe042623          	sw	zero,-20(s0)
    800062d4:	a84d                	j	80006386 <write_log+0xbe>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800062d6:	0001e797          	auipc	a5,0x1e
    800062da:	83278793          	addi	a5,a5,-1998 # 80023b08 <log>
    800062de:	579c                	lw	a5,40(a5)
    800062e0:	86be                	mv	a3,a5
    800062e2:	0001e797          	auipc	a5,0x1e
    800062e6:	82678793          	addi	a5,a5,-2010 # 80023b08 <log>
    800062ea:	4f9c                	lw	a5,24(a5)
    800062ec:	fec42703          	lw	a4,-20(s0)
    800062f0:	9fb9                	addw	a5,a5,a4
    800062f2:	2781                	sext.w	a5,a5
    800062f4:	2785                	addiw	a5,a5,1
    800062f6:	2781                	sext.w	a5,a5
    800062f8:	85be                	mv	a1,a5
    800062fa:	8536                	mv	a0,a3
    800062fc:	ffffe097          	auipc	ra,0xffffe
    80006300:	3e6080e7          	jalr	998(ra) # 800046e2 <bread>
    80006304:	fea43023          	sd	a0,-32(s0)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80006308:	0001e797          	auipc	a5,0x1e
    8000630c:	80078793          	addi	a5,a5,-2048 # 80023b08 <log>
    80006310:	579c                	lw	a5,40(a5)
    80006312:	86be                	mv	a3,a5
    80006314:	0001d717          	auipc	a4,0x1d
    80006318:	7f470713          	addi	a4,a4,2036 # 80023b08 <log>
    8000631c:	fec42783          	lw	a5,-20(s0)
    80006320:	07a1                	addi	a5,a5,8
    80006322:	078a                	slli	a5,a5,0x2
    80006324:	97ba                	add	a5,a5,a4
    80006326:	4b9c                	lw	a5,16(a5)
    80006328:	85be                	mv	a1,a5
    8000632a:	8536                	mv	a0,a3
    8000632c:	ffffe097          	auipc	ra,0xffffe
    80006330:	3b6080e7          	jalr	950(ra) # 800046e2 <bread>
    80006334:	fca43c23          	sd	a0,-40(s0)
    memmove(to->data, from->data, BSIZE);
    80006338:	fe043783          	ld	a5,-32(s0)
    8000633c:	05878713          	addi	a4,a5,88
    80006340:	fd843783          	ld	a5,-40(s0)
    80006344:	05878793          	addi	a5,a5,88
    80006348:	40000613          	li	a2,1024
    8000634c:	85be                	mv	a1,a5
    8000634e:	853a                	mv	a0,a4
    80006350:	ffffb097          	auipc	ra,0xffffb
    80006354:	234080e7          	jalr	564(ra) # 80001584 <memmove>
    bwrite(to);  // write the log
    80006358:	fe043503          	ld	a0,-32(s0)
    8000635c:	ffffe097          	auipc	ra,0xffffe
    80006360:	3e0080e7          	jalr	992(ra) # 8000473c <bwrite>
    brelse(from);
    80006364:	fd843503          	ld	a0,-40(s0)
    80006368:	ffffe097          	auipc	ra,0xffffe
    8000636c:	41c080e7          	jalr	1052(ra) # 80004784 <brelse>
    brelse(to);
    80006370:	fe043503          	ld	a0,-32(s0)
    80006374:	ffffe097          	auipc	ra,0xffffe
    80006378:	410080e7          	jalr	1040(ra) # 80004784 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000637c:	fec42783          	lw	a5,-20(s0)
    80006380:	2785                	addiw	a5,a5,1
    80006382:	fef42623          	sw	a5,-20(s0)
    80006386:	0001d797          	auipc	a5,0x1d
    8000638a:	78278793          	addi	a5,a5,1922 # 80023b08 <log>
    8000638e:	57dc                	lw	a5,44(a5)
    80006390:	fec42703          	lw	a4,-20(s0)
    80006394:	2701                	sext.w	a4,a4
    80006396:	f4f740e3          	blt	a4,a5,800062d6 <write_log+0xe>
  }
}
    8000639a:	0001                	nop
    8000639c:	0001                	nop
    8000639e:	70a2                	ld	ra,40(sp)
    800063a0:	7402                	ld	s0,32(sp)
    800063a2:	6145                	addi	sp,sp,48
    800063a4:	8082                	ret

00000000800063a6 <commit>:

static void
commit()
{
    800063a6:	1141                	addi	sp,sp,-16
    800063a8:	e406                	sd	ra,8(sp)
    800063aa:	e022                	sd	s0,0(sp)
    800063ac:	0800                	addi	s0,sp,16
  if (log.lh.n > 0) {
    800063ae:	0001d797          	auipc	a5,0x1d
    800063b2:	75a78793          	addi	a5,a5,1882 # 80023b08 <log>
    800063b6:	57dc                	lw	a5,44(a5)
    800063b8:	02f05963          	blez	a5,800063ea <commit+0x44>
    write_log();     // Write modified blocks from cache to log
    800063bc:	00000097          	auipc	ra,0x0
    800063c0:	f0c080e7          	jalr	-244(ra) # 800062c8 <write_log>
    write_head();    // Write header to disk -- the real commit
    800063c4:	00000097          	auipc	ra,0x0
    800063c8:	c70080e7          	jalr	-912(ra) # 80006034 <write_head>
    install_trans(0); // Now install writes to home locations
    800063cc:	4501                	li	a0,0
    800063ce:	00000097          	auipc	ra,0x0
    800063d2:	ac8080e7          	jalr	-1336(ra) # 80005e96 <install_trans>
    log.lh.n = 0;
    800063d6:	0001d797          	auipc	a5,0x1d
    800063da:	73278793          	addi	a5,a5,1842 # 80023b08 <log>
    800063de:	0207a623          	sw	zero,44(a5)
    write_head();    // Erase the transaction from the log
    800063e2:	00000097          	auipc	ra,0x0
    800063e6:	c52080e7          	jalr	-942(ra) # 80006034 <write_head>
  }
}
    800063ea:	0001                	nop
    800063ec:	60a2                	ld	ra,8(sp)
    800063ee:	6402                	ld	s0,0(sp)
    800063f0:	0141                	addi	sp,sp,16
    800063f2:	8082                	ret

00000000800063f4 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800063f4:	7179                	addi	sp,sp,-48
    800063f6:	f406                	sd	ra,40(sp)
    800063f8:	f022                	sd	s0,32(sp)
    800063fa:	1800                	addi	s0,sp,48
    800063fc:	fca43c23          	sd	a0,-40(s0)
  int i;

  acquire(&log.lock);
    80006400:	0001d517          	auipc	a0,0x1d
    80006404:	70850513          	addi	a0,a0,1800 # 80023b08 <log>
    80006408:	ffffb097          	auipc	ra,0xffffb
    8000640c:	ebc080e7          	jalr	-324(ra) # 800012c4 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80006410:	0001d797          	auipc	a5,0x1d
    80006414:	6f878793          	addi	a5,a5,1784 # 80023b08 <log>
    80006418:	57d8                	lw	a4,44(a5)
    8000641a:	47f5                	li	a5,29
    8000641c:	02e7c063          	blt	a5,a4,8000643c <log_write+0x48>
    80006420:	0001d797          	auipc	a5,0x1d
    80006424:	6e878793          	addi	a5,a5,1768 # 80023b08 <log>
    80006428:	57d8                	lw	a4,44(a5)
    8000642a:	0001d797          	auipc	a5,0x1d
    8000642e:	6de78793          	addi	a5,a5,1758 # 80023b08 <log>
    80006432:	4fdc                	lw	a5,28(a5)
    80006434:	37fd                	addiw	a5,a5,-1
    80006436:	2781                	sext.w	a5,a5
    80006438:	00f74a63          	blt	a4,a5,8000644c <log_write+0x58>
    panic("too big a transaction");
    8000643c:	00005517          	auipc	a0,0x5
    80006440:	11c50513          	addi	a0,a0,284 # 8000b558 <etext+0x558>
    80006444:	ffffb097          	auipc	ra,0xffffb
    80006448:	87c080e7          	jalr	-1924(ra) # 80000cc0 <panic>
  if (log.outstanding < 1)
    8000644c:	0001d797          	auipc	a5,0x1d
    80006450:	6bc78793          	addi	a5,a5,1724 # 80023b08 <log>
    80006454:	539c                	lw	a5,32(a5)
    80006456:	00f04a63          	bgtz	a5,8000646a <log_write+0x76>
    panic("log_write outside of trans");
    8000645a:	00005517          	auipc	a0,0x5
    8000645e:	11650513          	addi	a0,a0,278 # 8000b570 <etext+0x570>
    80006462:	ffffb097          	auipc	ra,0xffffb
    80006466:	85e080e7          	jalr	-1954(ra) # 80000cc0 <panic>

  for (i = 0; i < log.lh.n; i++) {
    8000646a:	fe042623          	sw	zero,-20(s0)
    8000646e:	a035                	j	8000649a <log_write+0xa6>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80006470:	0001d717          	auipc	a4,0x1d
    80006474:	69870713          	addi	a4,a4,1688 # 80023b08 <log>
    80006478:	fec42783          	lw	a5,-20(s0)
    8000647c:	07a1                	addi	a5,a5,8
    8000647e:	078a                	slli	a5,a5,0x2
    80006480:	97ba                	add	a5,a5,a4
    80006482:	4b9c                	lw	a5,16(a5)
    80006484:	873e                	mv	a4,a5
    80006486:	fd843783          	ld	a5,-40(s0)
    8000648a:	47dc                	lw	a5,12(a5)
    8000648c:	02f70263          	beq	a4,a5,800064b0 <log_write+0xbc>
  for (i = 0; i < log.lh.n; i++) {
    80006490:	fec42783          	lw	a5,-20(s0)
    80006494:	2785                	addiw	a5,a5,1
    80006496:	fef42623          	sw	a5,-20(s0)
    8000649a:	0001d797          	auipc	a5,0x1d
    8000649e:	66e78793          	addi	a5,a5,1646 # 80023b08 <log>
    800064a2:	57dc                	lw	a5,44(a5)
    800064a4:	fec42703          	lw	a4,-20(s0)
    800064a8:	2701                	sext.w	a4,a4
    800064aa:	fcf743e3          	blt	a4,a5,80006470 <log_write+0x7c>
    800064ae:	a011                	j	800064b2 <log_write+0xbe>
      break;
    800064b0:	0001                	nop
  }
  log.lh.block[i] = b->blockno;
    800064b2:	fd843783          	ld	a5,-40(s0)
    800064b6:	47dc                	lw	a5,12(a5)
    800064b8:	86be                	mv	a3,a5
    800064ba:	0001d717          	auipc	a4,0x1d
    800064be:	64e70713          	addi	a4,a4,1614 # 80023b08 <log>
    800064c2:	fec42783          	lw	a5,-20(s0)
    800064c6:	07a1                	addi	a5,a5,8
    800064c8:	078a                	slli	a5,a5,0x2
    800064ca:	97ba                	add	a5,a5,a4
    800064cc:	cb94                	sw	a3,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    800064ce:	0001d797          	auipc	a5,0x1d
    800064d2:	63a78793          	addi	a5,a5,1594 # 80023b08 <log>
    800064d6:	57dc                	lw	a5,44(a5)
    800064d8:	fec42703          	lw	a4,-20(s0)
    800064dc:	2701                	sext.w	a4,a4
    800064de:	02f71563          	bne	a4,a5,80006508 <log_write+0x114>
    bpin(b);
    800064e2:	fd843503          	ld	a0,-40(s0)
    800064e6:	ffffe097          	auipc	ra,0xffffe
    800064ea:	38c080e7          	jalr	908(ra) # 80004872 <bpin>
    log.lh.n++;
    800064ee:	0001d797          	auipc	a5,0x1d
    800064f2:	61a78793          	addi	a5,a5,1562 # 80023b08 <log>
    800064f6:	57dc                	lw	a5,44(a5)
    800064f8:	2785                	addiw	a5,a5,1
    800064fa:	0007871b          	sext.w	a4,a5
    800064fe:	0001d797          	auipc	a5,0x1d
    80006502:	60a78793          	addi	a5,a5,1546 # 80023b08 <log>
    80006506:	d7d8                	sw	a4,44(a5)
  }
  release(&log.lock);
    80006508:	0001d517          	auipc	a0,0x1d
    8000650c:	60050513          	addi	a0,a0,1536 # 80023b08 <log>
    80006510:	ffffb097          	auipc	ra,0xffffb
    80006514:	e18080e7          	jalr	-488(ra) # 80001328 <release>
}
    80006518:	0001                	nop
    8000651a:	70a2                	ld	ra,40(sp)
    8000651c:	7402                	ld	s0,32(sp)
    8000651e:	6145                	addi	sp,sp,48
    80006520:	8082                	ret

0000000080006522 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80006522:	1101                	addi	sp,sp,-32
    80006524:	ec06                	sd	ra,24(sp)
    80006526:	e822                	sd	s0,16(sp)
    80006528:	1000                	addi	s0,sp,32
    8000652a:	fea43423          	sd	a0,-24(s0)
    8000652e:	feb43023          	sd	a1,-32(s0)
  initlock(&lk->lk, "sleep lock");
    80006532:	fe843783          	ld	a5,-24(s0)
    80006536:	07a1                	addi	a5,a5,8
    80006538:	00005597          	auipc	a1,0x5
    8000653c:	05858593          	addi	a1,a1,88 # 8000b590 <etext+0x590>
    80006540:	853e                	mv	a0,a5
    80006542:	ffffb097          	auipc	ra,0xffffb
    80006546:	d4e080e7          	jalr	-690(ra) # 80001290 <initlock>
  lk->name = name;
    8000654a:	fe843783          	ld	a5,-24(s0)
    8000654e:	fe043703          	ld	a4,-32(s0)
    80006552:	f398                	sd	a4,32(a5)
  lk->locked = 0;
    80006554:	fe843783          	ld	a5,-24(s0)
    80006558:	0007a023          	sw	zero,0(a5)
  lk->pid = 0;
    8000655c:	fe843783          	ld	a5,-24(s0)
    80006560:	0207a423          	sw	zero,40(a5)
}
    80006564:	0001                	nop
    80006566:	60e2                	ld	ra,24(sp)
    80006568:	6442                	ld	s0,16(sp)
    8000656a:	6105                	addi	sp,sp,32
    8000656c:	8082                	ret

000000008000656e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000656e:	1101                	addi	sp,sp,-32
    80006570:	ec06                	sd	ra,24(sp)
    80006572:	e822                	sd	s0,16(sp)
    80006574:	1000                	addi	s0,sp,32
    80006576:	fea43423          	sd	a0,-24(s0)
  acquire(&lk->lk);
    8000657a:	fe843783          	ld	a5,-24(s0)
    8000657e:	07a1                	addi	a5,a5,8
    80006580:	853e                	mv	a0,a5
    80006582:	ffffb097          	auipc	ra,0xffffb
    80006586:	d42080e7          	jalr	-702(ra) # 800012c4 <acquire>
  while (lk->locked) {
    8000658a:	a819                	j	800065a0 <acquiresleep+0x32>
    sleep(lk, &lk->lk);
    8000658c:	fe843783          	ld	a5,-24(s0)
    80006590:	07a1                	addi	a5,a5,8
    80006592:	85be                	mv	a1,a5
    80006594:	fe843503          	ld	a0,-24(s0)
    80006598:	ffffd097          	auipc	ra,0xffffd
    8000659c:	ede080e7          	jalr	-290(ra) # 80003476 <sleep>
  while (lk->locked) {
    800065a0:	fe843783          	ld	a5,-24(s0)
    800065a4:	439c                	lw	a5,0(a5)
    800065a6:	f3fd                	bnez	a5,8000658c <acquiresleep+0x1e>
  }
  lk->locked = 1;
    800065a8:	fe843783          	ld	a5,-24(s0)
    800065ac:	4705                	li	a4,1
    800065ae:	c398                	sw	a4,0(a5)
  lk->pid = myproc()->pid;
    800065b0:	ffffc097          	auipc	ra,0xffffc
    800065b4:	30c080e7          	jalr	780(ra) # 800028bc <myproc>
    800065b8:	87aa                	mv	a5,a0
    800065ba:	5b98                	lw	a4,48(a5)
    800065bc:	fe843783          	ld	a5,-24(s0)
    800065c0:	d798                	sw	a4,40(a5)
  release(&lk->lk);
    800065c2:	fe843783          	ld	a5,-24(s0)
    800065c6:	07a1                	addi	a5,a5,8
    800065c8:	853e                	mv	a0,a5
    800065ca:	ffffb097          	auipc	ra,0xffffb
    800065ce:	d5e080e7          	jalr	-674(ra) # 80001328 <release>
}
    800065d2:	0001                	nop
    800065d4:	60e2                	ld	ra,24(sp)
    800065d6:	6442                	ld	s0,16(sp)
    800065d8:	6105                	addi	sp,sp,32
    800065da:	8082                	ret

00000000800065dc <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800065dc:	1101                	addi	sp,sp,-32
    800065de:	ec06                	sd	ra,24(sp)
    800065e0:	e822                	sd	s0,16(sp)
    800065e2:	1000                	addi	s0,sp,32
    800065e4:	fea43423          	sd	a0,-24(s0)
  acquire(&lk->lk);
    800065e8:	fe843783          	ld	a5,-24(s0)
    800065ec:	07a1                	addi	a5,a5,8
    800065ee:	853e                	mv	a0,a5
    800065f0:	ffffb097          	auipc	ra,0xffffb
    800065f4:	cd4080e7          	jalr	-812(ra) # 800012c4 <acquire>
  lk->locked = 0;
    800065f8:	fe843783          	ld	a5,-24(s0)
    800065fc:	0007a023          	sw	zero,0(a5)
  lk->pid = 0;
    80006600:	fe843783          	ld	a5,-24(s0)
    80006604:	0207a423          	sw	zero,40(a5)
  wakeup(lk);
    80006608:	fe843503          	ld	a0,-24(s0)
    8000660c:	ffffd097          	auipc	ra,0xffffd
    80006610:	ee6080e7          	jalr	-282(ra) # 800034f2 <wakeup>
  release(&lk->lk);
    80006614:	fe843783          	ld	a5,-24(s0)
    80006618:	07a1                	addi	a5,a5,8
    8000661a:	853e                	mv	a0,a5
    8000661c:	ffffb097          	auipc	ra,0xffffb
    80006620:	d0c080e7          	jalr	-756(ra) # 80001328 <release>
}
    80006624:	0001                	nop
    80006626:	60e2                	ld	ra,24(sp)
    80006628:	6442                	ld	s0,16(sp)
    8000662a:	6105                	addi	sp,sp,32
    8000662c:	8082                	ret

000000008000662e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000662e:	7139                	addi	sp,sp,-64
    80006630:	fc06                	sd	ra,56(sp)
    80006632:	f822                	sd	s0,48(sp)
    80006634:	f426                	sd	s1,40(sp)
    80006636:	0080                	addi	s0,sp,64
    80006638:	fca43423          	sd	a0,-56(s0)
  int r;
  
  acquire(&lk->lk);
    8000663c:	fc843783          	ld	a5,-56(s0)
    80006640:	07a1                	addi	a5,a5,8
    80006642:	853e                	mv	a0,a5
    80006644:	ffffb097          	auipc	ra,0xffffb
    80006648:	c80080e7          	jalr	-896(ra) # 800012c4 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000664c:	fc843783          	ld	a5,-56(s0)
    80006650:	439c                	lw	a5,0(a5)
    80006652:	cf91                	beqz	a5,8000666e <holdingsleep+0x40>
    80006654:	fc843783          	ld	a5,-56(s0)
    80006658:	5784                	lw	s1,40(a5)
    8000665a:	ffffc097          	auipc	ra,0xffffc
    8000665e:	262080e7          	jalr	610(ra) # 800028bc <myproc>
    80006662:	87aa                	mv	a5,a0
    80006664:	5b9c                	lw	a5,48(a5)
    80006666:	00f49463          	bne	s1,a5,8000666e <holdingsleep+0x40>
    8000666a:	4785                	li	a5,1
    8000666c:	a011                	j	80006670 <holdingsleep+0x42>
    8000666e:	4781                	li	a5,0
    80006670:	fcf42e23          	sw	a5,-36(s0)
  release(&lk->lk);
    80006674:	fc843783          	ld	a5,-56(s0)
    80006678:	07a1                	addi	a5,a5,8
    8000667a:	853e                	mv	a0,a5
    8000667c:	ffffb097          	auipc	ra,0xffffb
    80006680:	cac080e7          	jalr	-852(ra) # 80001328 <release>
  return r;
    80006684:	fdc42783          	lw	a5,-36(s0)
}
    80006688:	853e                	mv	a0,a5
    8000668a:	70e2                	ld	ra,56(sp)
    8000668c:	7442                	ld	s0,48(sp)
    8000668e:	74a2                	ld	s1,40(sp)
    80006690:	6121                	addi	sp,sp,64
    80006692:	8082                	ret

0000000080006694 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80006694:	1141                	addi	sp,sp,-16
    80006696:	e406                	sd	ra,8(sp)
    80006698:	e022                	sd	s0,0(sp)
    8000669a:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000669c:	00005597          	auipc	a1,0x5
    800066a0:	f0458593          	addi	a1,a1,-252 # 8000b5a0 <etext+0x5a0>
    800066a4:	0001d517          	auipc	a0,0x1d
    800066a8:	5ac50513          	addi	a0,a0,1452 # 80023c50 <ftable>
    800066ac:	ffffb097          	auipc	ra,0xffffb
    800066b0:	be4080e7          	jalr	-1052(ra) # 80001290 <initlock>
}
    800066b4:	0001                	nop
    800066b6:	60a2                	ld	ra,8(sp)
    800066b8:	6402                	ld	s0,0(sp)
    800066ba:	0141                	addi	sp,sp,16
    800066bc:	8082                	ret

00000000800066be <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800066be:	1101                	addi	sp,sp,-32
    800066c0:	ec06                	sd	ra,24(sp)
    800066c2:	e822                	sd	s0,16(sp)
    800066c4:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800066c6:	0001d517          	auipc	a0,0x1d
    800066ca:	58a50513          	addi	a0,a0,1418 # 80023c50 <ftable>
    800066ce:	ffffb097          	auipc	ra,0xffffb
    800066d2:	bf6080e7          	jalr	-1034(ra) # 800012c4 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800066d6:	0001d797          	auipc	a5,0x1d
    800066da:	59278793          	addi	a5,a5,1426 # 80023c68 <ftable+0x18>
    800066de:	fef43423          	sd	a5,-24(s0)
    800066e2:	a815                	j	80006716 <filealloc+0x58>
    if(f->ref == 0){
    800066e4:	fe843783          	ld	a5,-24(s0)
    800066e8:	43dc                	lw	a5,4(a5)
    800066ea:	e385                	bnez	a5,8000670a <filealloc+0x4c>
      f->ref = 1;
    800066ec:	fe843783          	ld	a5,-24(s0)
    800066f0:	4705                	li	a4,1
    800066f2:	c3d8                	sw	a4,4(a5)
      release(&ftable.lock);
    800066f4:	0001d517          	auipc	a0,0x1d
    800066f8:	55c50513          	addi	a0,a0,1372 # 80023c50 <ftable>
    800066fc:	ffffb097          	auipc	ra,0xffffb
    80006700:	c2c080e7          	jalr	-980(ra) # 80001328 <release>
      return f;
    80006704:	fe843783          	ld	a5,-24(s0)
    80006708:	a805                	j	80006738 <filealloc+0x7a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000670a:	fe843783          	ld	a5,-24(s0)
    8000670e:	02878793          	addi	a5,a5,40
    80006712:	fef43423          	sd	a5,-24(s0)
    80006716:	0001e797          	auipc	a5,0x1e
    8000671a:	4f278793          	addi	a5,a5,1266 # 80024c08 <disk>
    8000671e:	fe843703          	ld	a4,-24(s0)
    80006722:	fcf761e3          	bltu	a4,a5,800066e4 <filealloc+0x26>
    }
  }
  release(&ftable.lock);
    80006726:	0001d517          	auipc	a0,0x1d
    8000672a:	52a50513          	addi	a0,a0,1322 # 80023c50 <ftable>
    8000672e:	ffffb097          	auipc	ra,0xffffb
    80006732:	bfa080e7          	jalr	-1030(ra) # 80001328 <release>
  return 0;
    80006736:	4781                	li	a5,0
}
    80006738:	853e                	mv	a0,a5
    8000673a:	60e2                	ld	ra,24(sp)
    8000673c:	6442                	ld	s0,16(sp)
    8000673e:	6105                	addi	sp,sp,32
    80006740:	8082                	ret

0000000080006742 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80006742:	1101                	addi	sp,sp,-32
    80006744:	ec06                	sd	ra,24(sp)
    80006746:	e822                	sd	s0,16(sp)
    80006748:	1000                	addi	s0,sp,32
    8000674a:	fea43423          	sd	a0,-24(s0)
  acquire(&ftable.lock);
    8000674e:	0001d517          	auipc	a0,0x1d
    80006752:	50250513          	addi	a0,a0,1282 # 80023c50 <ftable>
    80006756:	ffffb097          	auipc	ra,0xffffb
    8000675a:	b6e080e7          	jalr	-1170(ra) # 800012c4 <acquire>
  if(f->ref < 1)
    8000675e:	fe843783          	ld	a5,-24(s0)
    80006762:	43dc                	lw	a5,4(a5)
    80006764:	00f04a63          	bgtz	a5,80006778 <filedup+0x36>
    panic("filedup");
    80006768:	00005517          	auipc	a0,0x5
    8000676c:	e4050513          	addi	a0,a0,-448 # 8000b5a8 <etext+0x5a8>
    80006770:	ffffa097          	auipc	ra,0xffffa
    80006774:	550080e7          	jalr	1360(ra) # 80000cc0 <panic>
  f->ref++;
    80006778:	fe843783          	ld	a5,-24(s0)
    8000677c:	43dc                	lw	a5,4(a5)
    8000677e:	2785                	addiw	a5,a5,1
    80006780:	0007871b          	sext.w	a4,a5
    80006784:	fe843783          	ld	a5,-24(s0)
    80006788:	c3d8                	sw	a4,4(a5)
  release(&ftable.lock);
    8000678a:	0001d517          	auipc	a0,0x1d
    8000678e:	4c650513          	addi	a0,a0,1222 # 80023c50 <ftable>
    80006792:	ffffb097          	auipc	ra,0xffffb
    80006796:	b96080e7          	jalr	-1130(ra) # 80001328 <release>
  return f;
    8000679a:	fe843783          	ld	a5,-24(s0)
}
    8000679e:	853e                	mv	a0,a5
    800067a0:	60e2                	ld	ra,24(sp)
    800067a2:	6442                	ld	s0,16(sp)
    800067a4:	6105                	addi	sp,sp,32
    800067a6:	8082                	ret

00000000800067a8 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800067a8:	715d                	addi	sp,sp,-80
    800067aa:	e486                	sd	ra,72(sp)
    800067ac:	e0a2                	sd	s0,64(sp)
    800067ae:	0880                	addi	s0,sp,80
    800067b0:	faa43c23          	sd	a0,-72(s0)
  struct file ff;

  acquire(&ftable.lock);
    800067b4:	0001d517          	auipc	a0,0x1d
    800067b8:	49c50513          	addi	a0,a0,1180 # 80023c50 <ftable>
    800067bc:	ffffb097          	auipc	ra,0xffffb
    800067c0:	b08080e7          	jalr	-1272(ra) # 800012c4 <acquire>
  if(f->ref < 1)
    800067c4:	fb843783          	ld	a5,-72(s0)
    800067c8:	43dc                	lw	a5,4(a5)
    800067ca:	00f04a63          	bgtz	a5,800067de <fileclose+0x36>
    panic("fileclose");
    800067ce:	00005517          	auipc	a0,0x5
    800067d2:	de250513          	addi	a0,a0,-542 # 8000b5b0 <etext+0x5b0>
    800067d6:	ffffa097          	auipc	ra,0xffffa
    800067da:	4ea080e7          	jalr	1258(ra) # 80000cc0 <panic>
  if(--f->ref > 0){
    800067de:	fb843783          	ld	a5,-72(s0)
    800067e2:	43dc                	lw	a5,4(a5)
    800067e4:	37fd                	addiw	a5,a5,-1
    800067e6:	0007871b          	sext.w	a4,a5
    800067ea:	fb843783          	ld	a5,-72(s0)
    800067ee:	c3d8                	sw	a4,4(a5)
    800067f0:	fb843783          	ld	a5,-72(s0)
    800067f4:	43dc                	lw	a5,4(a5)
    800067f6:	00f05b63          	blez	a5,8000680c <fileclose+0x64>
    release(&ftable.lock);
    800067fa:	0001d517          	auipc	a0,0x1d
    800067fe:	45650513          	addi	a0,a0,1110 # 80023c50 <ftable>
    80006802:	ffffb097          	auipc	ra,0xffffb
    80006806:	b26080e7          	jalr	-1242(ra) # 80001328 <release>
    8000680a:	a861                	j	800068a2 <fileclose+0xfa>
    return;
  }
  ff = *f;
    8000680c:	fb843783          	ld	a5,-72(s0)
    80006810:	638c                	ld	a1,0(a5)
    80006812:	6790                	ld	a2,8(a5)
    80006814:	6b94                	ld	a3,16(a5)
    80006816:	6f98                	ld	a4,24(a5)
    80006818:	739c                	ld	a5,32(a5)
    8000681a:	fcb43423          	sd	a1,-56(s0)
    8000681e:	fcc43823          	sd	a2,-48(s0)
    80006822:	fcd43c23          	sd	a3,-40(s0)
    80006826:	fee43023          	sd	a4,-32(s0)
    8000682a:	fef43423          	sd	a5,-24(s0)
  f->ref = 0;
    8000682e:	fb843783          	ld	a5,-72(s0)
    80006832:	0007a223          	sw	zero,4(a5)
  f->type = FD_NONE;
    80006836:	fb843783          	ld	a5,-72(s0)
    8000683a:	0007a023          	sw	zero,0(a5)
  release(&ftable.lock);
    8000683e:	0001d517          	auipc	a0,0x1d
    80006842:	41250513          	addi	a0,a0,1042 # 80023c50 <ftable>
    80006846:	ffffb097          	auipc	ra,0xffffb
    8000684a:	ae2080e7          	jalr	-1310(ra) # 80001328 <release>

  if(ff.type == FD_PIPE){
    8000684e:	fc842703          	lw	a4,-56(s0)
    80006852:	4785                	li	a5,1
    80006854:	00f71e63          	bne	a4,a5,80006870 <fileclose+0xc8>
    pipeclose(ff.pipe, ff.writable);
    80006858:	fd843783          	ld	a5,-40(s0)
    8000685c:	fd144703          	lbu	a4,-47(s0)
    80006860:	2701                	sext.w	a4,a4
    80006862:	85ba                	mv	a1,a4
    80006864:	853e                	mv	a0,a5
    80006866:	00000097          	auipc	ra,0x0
    8000686a:	58e080e7          	jalr	1422(ra) # 80006df4 <pipeclose>
    8000686e:	a815                	j	800068a2 <fileclose+0xfa>
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80006870:	fc842703          	lw	a4,-56(s0)
    80006874:	4789                	li	a5,2
    80006876:	00f70763          	beq	a4,a5,80006884 <fileclose+0xdc>
    8000687a:	fc842703          	lw	a4,-56(s0)
    8000687e:	478d                	li	a5,3
    80006880:	02f71163          	bne	a4,a5,800068a2 <fileclose+0xfa>
    begin_op();
    80006884:	00000097          	auipc	ra,0x0
    80006888:	89a080e7          	jalr	-1894(ra) # 8000611e <begin_op>
    iput(ff.ip);
    8000688c:	fe043783          	ld	a5,-32(s0)
    80006890:	853e                	mv	a0,a5
    80006892:	fffff097          	auipc	ra,0xfffff
    80006896:	9aa080e7          	jalr	-1622(ra) # 8000523c <iput>
    end_op();
    8000689a:	00000097          	auipc	ra,0x0
    8000689e:	946080e7          	jalr	-1722(ra) # 800061e0 <end_op>
  }
}
    800068a2:	60a6                	ld	ra,72(sp)
    800068a4:	6406                	ld	s0,64(sp)
    800068a6:	6161                	addi	sp,sp,80
    800068a8:	8082                	ret

00000000800068aa <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800068aa:	7139                	addi	sp,sp,-64
    800068ac:	fc06                	sd	ra,56(sp)
    800068ae:	f822                	sd	s0,48(sp)
    800068b0:	0080                	addi	s0,sp,64
    800068b2:	fca43423          	sd	a0,-56(s0)
    800068b6:	fcb43023          	sd	a1,-64(s0)
  struct proc *p = myproc();
    800068ba:	ffffc097          	auipc	ra,0xffffc
    800068be:	002080e7          	jalr	2(ra) # 800028bc <myproc>
    800068c2:	fea43423          	sd	a0,-24(s0)
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800068c6:	fc843783          	ld	a5,-56(s0)
    800068ca:	4398                	lw	a4,0(a5)
    800068cc:	4789                	li	a5,2
    800068ce:	00f70863          	beq	a4,a5,800068de <filestat+0x34>
    800068d2:	fc843783          	ld	a5,-56(s0)
    800068d6:	4398                	lw	a4,0(a5)
    800068d8:	478d                	li	a5,3
    800068da:	06f71263          	bne	a4,a5,8000693e <filestat+0x94>
    ilock(f->ip);
    800068de:	fc843783          	ld	a5,-56(s0)
    800068e2:	6f9c                	ld	a5,24(a5)
    800068e4:	853e                	mv	a0,a5
    800068e6:	ffffe097          	auipc	ra,0xffffe
    800068ea:	7c8080e7          	jalr	1992(ra) # 800050ae <ilock>
    stati(f->ip, &st);
    800068ee:	fc843783          	ld	a5,-56(s0)
    800068f2:	6f9c                	ld	a5,24(a5)
    800068f4:	fd040713          	addi	a4,s0,-48
    800068f8:	85ba                	mv	a1,a4
    800068fa:	853e                	mv	a0,a5
    800068fc:	fffff097          	auipc	ra,0xfffff
    80006900:	cfa080e7          	jalr	-774(ra) # 800055f6 <stati>
    iunlock(f->ip);
    80006904:	fc843783          	ld	a5,-56(s0)
    80006908:	6f9c                	ld	a5,24(a5)
    8000690a:	853e                	mv	a0,a5
    8000690c:	fffff097          	auipc	ra,0xfffff
    80006910:	8d6080e7          	jalr	-1834(ra) # 800051e2 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80006914:	fe843783          	ld	a5,-24(s0)
    80006918:	6bbc                	ld	a5,80(a5)
    8000691a:	fd040713          	addi	a4,s0,-48
    8000691e:	46e1                	li	a3,24
    80006920:	863a                	mv	a2,a4
    80006922:	fc043583          	ld	a1,-64(s0)
    80006926:	853e                	mv	a0,a5
    80006928:	ffffc097          	auipc	ra,0xffffc
    8000692c:	a52080e7          	jalr	-1454(ra) # 8000237a <copyout>
    80006930:	87aa                	mv	a5,a0
    80006932:	0007d463          	bgez	a5,8000693a <filestat+0x90>
      return -1;
    80006936:	57fd                	li	a5,-1
    80006938:	a021                	j	80006940 <filestat+0x96>
    return 0;
    8000693a:	4781                	li	a5,0
    8000693c:	a011                	j	80006940 <filestat+0x96>
  }
  return -1;
    8000693e:	57fd                	li	a5,-1
}
    80006940:	853e                	mv	a0,a5
    80006942:	70e2                	ld	ra,56(sp)
    80006944:	7442                	ld	s0,48(sp)
    80006946:	6121                	addi	sp,sp,64
    80006948:	8082                	ret

000000008000694a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000694a:	7139                	addi	sp,sp,-64
    8000694c:	fc06                	sd	ra,56(sp)
    8000694e:	f822                	sd	s0,48(sp)
    80006950:	0080                	addi	s0,sp,64
    80006952:	fca43c23          	sd	a0,-40(s0)
    80006956:	fcb43823          	sd	a1,-48(s0)
    8000695a:	87b2                	mv	a5,a2
    8000695c:	fcf42623          	sw	a5,-52(s0)
  int r = 0;
    80006960:	fe042623          	sw	zero,-20(s0)

  if(f->readable == 0)
    80006964:	fd843783          	ld	a5,-40(s0)
    80006968:	0087c783          	lbu	a5,8(a5)
    8000696c:	e399                	bnez	a5,80006972 <fileread+0x28>
    return -1;
    8000696e:	57fd                	li	a5,-1
    80006970:	a21d                	j	80006a96 <fileread+0x14c>

  if(f->type == FD_PIPE){
    80006972:	fd843783          	ld	a5,-40(s0)
    80006976:	4398                	lw	a4,0(a5)
    80006978:	4785                	li	a5,1
    8000697a:	02f71363          	bne	a4,a5,800069a0 <fileread+0x56>
    r = piperead(f->pipe, addr, n);
    8000697e:	fd843783          	ld	a5,-40(s0)
    80006982:	6b9c                	ld	a5,16(a5)
    80006984:	fcc42703          	lw	a4,-52(s0)
    80006988:	863a                	mv	a2,a4
    8000698a:	fd043583          	ld	a1,-48(s0)
    8000698e:	853e                	mv	a0,a5
    80006990:	00000097          	auipc	ra,0x0
    80006994:	65e080e7          	jalr	1630(ra) # 80006fee <piperead>
    80006998:	87aa                	mv	a5,a0
    8000699a:	fef42623          	sw	a5,-20(s0)
    8000699e:	a8d5                	j	80006a92 <fileread+0x148>
  } else if(f->type == FD_DEVICE){
    800069a0:	fd843783          	ld	a5,-40(s0)
    800069a4:	4398                	lw	a4,0(a5)
    800069a6:	478d                	li	a5,3
    800069a8:	06f71363          	bne	a4,a5,80006a0e <fileread+0xc4>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800069ac:	fd843783          	ld	a5,-40(s0)
    800069b0:	02479783          	lh	a5,36(a5)
    800069b4:	0207c563          	bltz	a5,800069de <fileread+0x94>
    800069b8:	fd843783          	ld	a5,-40(s0)
    800069bc:	02479703          	lh	a4,36(a5)
    800069c0:	47a5                	li	a5,9
    800069c2:	00e7ce63          	blt	a5,a4,800069de <fileread+0x94>
    800069c6:	fd843783          	ld	a5,-40(s0)
    800069ca:	02479783          	lh	a5,36(a5)
    800069ce:	0001d717          	auipc	a4,0x1d
    800069d2:	1e270713          	addi	a4,a4,482 # 80023bb0 <devsw>
    800069d6:	0792                	slli	a5,a5,0x4
    800069d8:	97ba                	add	a5,a5,a4
    800069da:	639c                	ld	a5,0(a5)
    800069dc:	e399                	bnez	a5,800069e2 <fileread+0x98>
      return -1;
    800069de:	57fd                	li	a5,-1
    800069e0:	a85d                	j	80006a96 <fileread+0x14c>
    r = devsw[f->major].read(1, addr, n);
    800069e2:	fd843783          	ld	a5,-40(s0)
    800069e6:	02479783          	lh	a5,36(a5)
    800069ea:	0001d717          	auipc	a4,0x1d
    800069ee:	1c670713          	addi	a4,a4,454 # 80023bb0 <devsw>
    800069f2:	0792                	slli	a5,a5,0x4
    800069f4:	97ba                	add	a5,a5,a4
    800069f6:	639c                	ld	a5,0(a5)
    800069f8:	fcc42703          	lw	a4,-52(s0)
    800069fc:	863a                	mv	a2,a4
    800069fe:	fd043583          	ld	a1,-48(s0)
    80006a02:	4505                	li	a0,1
    80006a04:	9782                	jalr	a5
    80006a06:	87aa                	mv	a5,a0
    80006a08:	fef42623          	sw	a5,-20(s0)
    80006a0c:	a059                	j	80006a92 <fileread+0x148>
  } else if(f->type == FD_INODE){
    80006a0e:	fd843783          	ld	a5,-40(s0)
    80006a12:	4398                	lw	a4,0(a5)
    80006a14:	4789                	li	a5,2
    80006a16:	06f71663          	bne	a4,a5,80006a82 <fileread+0x138>
    ilock(f->ip);
    80006a1a:	fd843783          	ld	a5,-40(s0)
    80006a1e:	6f9c                	ld	a5,24(a5)
    80006a20:	853e                	mv	a0,a5
    80006a22:	ffffe097          	auipc	ra,0xffffe
    80006a26:	68c080e7          	jalr	1676(ra) # 800050ae <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80006a2a:	fd843783          	ld	a5,-40(s0)
    80006a2e:	6f88                	ld	a0,24(a5)
    80006a30:	fd843783          	ld	a5,-40(s0)
    80006a34:	539c                	lw	a5,32(a5)
    80006a36:	fcc42703          	lw	a4,-52(s0)
    80006a3a:	86be                	mv	a3,a5
    80006a3c:	fd043603          	ld	a2,-48(s0)
    80006a40:	4585                	li	a1,1
    80006a42:	fffff097          	auipc	ra,0xfffff
    80006a46:	c1a080e7          	jalr	-998(ra) # 8000565c <readi>
    80006a4a:	87aa                	mv	a5,a0
    80006a4c:	fef42623          	sw	a5,-20(s0)
    80006a50:	fec42783          	lw	a5,-20(s0)
    80006a54:	2781                	sext.w	a5,a5
    80006a56:	00f05d63          	blez	a5,80006a70 <fileread+0x126>
      f->off += r;
    80006a5a:	fd843783          	ld	a5,-40(s0)
    80006a5e:	5398                	lw	a4,32(a5)
    80006a60:	fec42783          	lw	a5,-20(s0)
    80006a64:	9fb9                	addw	a5,a5,a4
    80006a66:	0007871b          	sext.w	a4,a5
    80006a6a:	fd843783          	ld	a5,-40(s0)
    80006a6e:	d398                	sw	a4,32(a5)
    iunlock(f->ip);
    80006a70:	fd843783          	ld	a5,-40(s0)
    80006a74:	6f9c                	ld	a5,24(a5)
    80006a76:	853e                	mv	a0,a5
    80006a78:	ffffe097          	auipc	ra,0xffffe
    80006a7c:	76a080e7          	jalr	1898(ra) # 800051e2 <iunlock>
    80006a80:	a809                	j	80006a92 <fileread+0x148>
  } else {
    panic("fileread");
    80006a82:	00005517          	auipc	a0,0x5
    80006a86:	b3e50513          	addi	a0,a0,-1218 # 8000b5c0 <etext+0x5c0>
    80006a8a:	ffffa097          	auipc	ra,0xffffa
    80006a8e:	236080e7          	jalr	566(ra) # 80000cc0 <panic>
  }

  return r;
    80006a92:	fec42783          	lw	a5,-20(s0)
}
    80006a96:	853e                	mv	a0,a5
    80006a98:	70e2                	ld	ra,56(sp)
    80006a9a:	7442                	ld	s0,48(sp)
    80006a9c:	6121                	addi	sp,sp,64
    80006a9e:	8082                	ret

0000000080006aa0 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80006aa0:	715d                	addi	sp,sp,-80
    80006aa2:	e486                	sd	ra,72(sp)
    80006aa4:	e0a2                	sd	s0,64(sp)
    80006aa6:	0880                	addi	s0,sp,80
    80006aa8:	fca43423          	sd	a0,-56(s0)
    80006aac:	fcb43023          	sd	a1,-64(s0)
    80006ab0:	87b2                	mv	a5,a2
    80006ab2:	faf42e23          	sw	a5,-68(s0)
  int r, ret = 0;
    80006ab6:	fe042623          	sw	zero,-20(s0)

  if(f->writable == 0)
    80006aba:	fc843783          	ld	a5,-56(s0)
    80006abe:	0097c783          	lbu	a5,9(a5)
    80006ac2:	e399                	bnez	a5,80006ac8 <filewrite+0x28>
    return -1;
    80006ac4:	57fd                	li	a5,-1
    80006ac6:	aac1                	j	80006c96 <filewrite+0x1f6>

  if(f->type == FD_PIPE){
    80006ac8:	fc843783          	ld	a5,-56(s0)
    80006acc:	4398                	lw	a4,0(a5)
    80006ace:	4785                	li	a5,1
    80006ad0:	02f71363          	bne	a4,a5,80006af6 <filewrite+0x56>
    ret = pipewrite(f->pipe, addr, n);
    80006ad4:	fc843783          	ld	a5,-56(s0)
    80006ad8:	6b9c                	ld	a5,16(a5)
    80006ada:	fbc42703          	lw	a4,-68(s0)
    80006ade:	863a                	mv	a2,a4
    80006ae0:	fc043583          	ld	a1,-64(s0)
    80006ae4:	853e                	mv	a0,a5
    80006ae6:	00000097          	auipc	ra,0x0
    80006aea:	3b6080e7          	jalr	950(ra) # 80006e9c <pipewrite>
    80006aee:	87aa                	mv	a5,a0
    80006af0:	fef42623          	sw	a5,-20(s0)
    80006af4:	aa79                	j	80006c92 <filewrite+0x1f2>
  } else if(f->type == FD_DEVICE){
    80006af6:	fc843783          	ld	a5,-56(s0)
    80006afa:	4398                	lw	a4,0(a5)
    80006afc:	478d                	li	a5,3
    80006afe:	06f71363          	bne	a4,a5,80006b64 <filewrite+0xc4>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80006b02:	fc843783          	ld	a5,-56(s0)
    80006b06:	02479783          	lh	a5,36(a5)
    80006b0a:	0207c563          	bltz	a5,80006b34 <filewrite+0x94>
    80006b0e:	fc843783          	ld	a5,-56(s0)
    80006b12:	02479703          	lh	a4,36(a5)
    80006b16:	47a5                	li	a5,9
    80006b18:	00e7ce63          	blt	a5,a4,80006b34 <filewrite+0x94>
    80006b1c:	fc843783          	ld	a5,-56(s0)
    80006b20:	02479783          	lh	a5,36(a5)
    80006b24:	0001d717          	auipc	a4,0x1d
    80006b28:	08c70713          	addi	a4,a4,140 # 80023bb0 <devsw>
    80006b2c:	0792                	slli	a5,a5,0x4
    80006b2e:	97ba                	add	a5,a5,a4
    80006b30:	679c                	ld	a5,8(a5)
    80006b32:	e399                	bnez	a5,80006b38 <filewrite+0x98>
      return -1;
    80006b34:	57fd                	li	a5,-1
    80006b36:	a285                	j	80006c96 <filewrite+0x1f6>
    ret = devsw[f->major].write(1, addr, n);
    80006b38:	fc843783          	ld	a5,-56(s0)
    80006b3c:	02479783          	lh	a5,36(a5)
    80006b40:	0001d717          	auipc	a4,0x1d
    80006b44:	07070713          	addi	a4,a4,112 # 80023bb0 <devsw>
    80006b48:	0792                	slli	a5,a5,0x4
    80006b4a:	97ba                	add	a5,a5,a4
    80006b4c:	679c                	ld	a5,8(a5)
    80006b4e:	fbc42703          	lw	a4,-68(s0)
    80006b52:	863a                	mv	a2,a4
    80006b54:	fc043583          	ld	a1,-64(s0)
    80006b58:	4505                	li	a0,1
    80006b5a:	9782                	jalr	a5
    80006b5c:	87aa                	mv	a5,a0
    80006b5e:	fef42623          	sw	a5,-20(s0)
    80006b62:	aa05                	j	80006c92 <filewrite+0x1f2>
  } else if(f->type == FD_INODE){
    80006b64:	fc843783          	ld	a5,-56(s0)
    80006b68:	4398                	lw	a4,0(a5)
    80006b6a:	4789                	li	a5,2
    80006b6c:	10f71b63          	bne	a4,a5,80006c82 <filewrite+0x1e2>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    80006b70:	6785                	lui	a5,0x1
    80006b72:	c0078793          	addi	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    80006b76:	fef42023          	sw	a5,-32(s0)
    int i = 0;
    80006b7a:	fe042423          	sw	zero,-24(s0)
    while(i < n){
    80006b7e:	a0f9                	j	80006c4c <filewrite+0x1ac>
      int n1 = n - i;
    80006b80:	fbc42783          	lw	a5,-68(s0)
    80006b84:	873e                	mv	a4,a5
    80006b86:	fe842783          	lw	a5,-24(s0)
    80006b8a:	40f707bb          	subw	a5,a4,a5
    80006b8e:	fef42223          	sw	a5,-28(s0)
      if(n1 > max)
    80006b92:	fe442783          	lw	a5,-28(s0)
    80006b96:	873e                	mv	a4,a5
    80006b98:	fe042783          	lw	a5,-32(s0)
    80006b9c:	2701                	sext.w	a4,a4
    80006b9e:	2781                	sext.w	a5,a5
    80006ba0:	00e7d663          	bge	a5,a4,80006bac <filewrite+0x10c>
        n1 = max;
    80006ba4:	fe042783          	lw	a5,-32(s0)
    80006ba8:	fef42223          	sw	a5,-28(s0)

      begin_op();
    80006bac:	fffff097          	auipc	ra,0xfffff
    80006bb0:	572080e7          	jalr	1394(ra) # 8000611e <begin_op>
      ilock(f->ip);
    80006bb4:	fc843783          	ld	a5,-56(s0)
    80006bb8:	6f9c                	ld	a5,24(a5)
    80006bba:	853e                	mv	a0,a5
    80006bbc:	ffffe097          	auipc	ra,0xffffe
    80006bc0:	4f2080e7          	jalr	1266(ra) # 800050ae <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80006bc4:	fc843783          	ld	a5,-56(s0)
    80006bc8:	6f88                	ld	a0,24(a5)
    80006bca:	fe842703          	lw	a4,-24(s0)
    80006bce:	fc043783          	ld	a5,-64(s0)
    80006bd2:	00f70633          	add	a2,a4,a5
    80006bd6:	fc843783          	ld	a5,-56(s0)
    80006bda:	539c                	lw	a5,32(a5)
    80006bdc:	fe442703          	lw	a4,-28(s0)
    80006be0:	86be                	mv	a3,a5
    80006be2:	4585                	li	a1,1
    80006be4:	fffff097          	auipc	ra,0xfffff
    80006be8:	c14080e7          	jalr	-1004(ra) # 800057f8 <writei>
    80006bec:	87aa                	mv	a5,a0
    80006bee:	fcf42e23          	sw	a5,-36(s0)
    80006bf2:	fdc42783          	lw	a5,-36(s0)
    80006bf6:	2781                	sext.w	a5,a5
    80006bf8:	00f05d63          	blez	a5,80006c12 <filewrite+0x172>
        f->off += r;
    80006bfc:	fc843783          	ld	a5,-56(s0)
    80006c00:	5398                	lw	a4,32(a5)
    80006c02:	fdc42783          	lw	a5,-36(s0)
    80006c06:	9fb9                	addw	a5,a5,a4
    80006c08:	0007871b          	sext.w	a4,a5
    80006c0c:	fc843783          	ld	a5,-56(s0)
    80006c10:	d398                	sw	a4,32(a5)
      iunlock(f->ip);
    80006c12:	fc843783          	ld	a5,-56(s0)
    80006c16:	6f9c                	ld	a5,24(a5)
    80006c18:	853e                	mv	a0,a5
    80006c1a:	ffffe097          	auipc	ra,0xffffe
    80006c1e:	5c8080e7          	jalr	1480(ra) # 800051e2 <iunlock>
      end_op();
    80006c22:	fffff097          	auipc	ra,0xfffff
    80006c26:	5be080e7          	jalr	1470(ra) # 800061e0 <end_op>

      if(r != n1){
    80006c2a:	fdc42783          	lw	a5,-36(s0)
    80006c2e:	873e                	mv	a4,a5
    80006c30:	fe442783          	lw	a5,-28(s0)
    80006c34:	2701                	sext.w	a4,a4
    80006c36:	2781                	sext.w	a5,a5
    80006c38:	02f71463          	bne	a4,a5,80006c60 <filewrite+0x1c0>
        // error from writei
        break;
      }
      i += r;
    80006c3c:	fe842783          	lw	a5,-24(s0)
    80006c40:	873e                	mv	a4,a5
    80006c42:	fdc42783          	lw	a5,-36(s0)
    80006c46:	9fb9                	addw	a5,a5,a4
    80006c48:	fef42423          	sw	a5,-24(s0)
    while(i < n){
    80006c4c:	fe842783          	lw	a5,-24(s0)
    80006c50:	873e                	mv	a4,a5
    80006c52:	fbc42783          	lw	a5,-68(s0)
    80006c56:	2701                	sext.w	a4,a4
    80006c58:	2781                	sext.w	a5,a5
    80006c5a:	f2f743e3          	blt	a4,a5,80006b80 <filewrite+0xe0>
    80006c5e:	a011                	j	80006c62 <filewrite+0x1c2>
        break;
    80006c60:	0001                	nop
    }
    ret = (i == n ? n : -1);
    80006c62:	fe842783          	lw	a5,-24(s0)
    80006c66:	873e                	mv	a4,a5
    80006c68:	fbc42783          	lw	a5,-68(s0)
    80006c6c:	2701                	sext.w	a4,a4
    80006c6e:	2781                	sext.w	a5,a5
    80006c70:	00f71563          	bne	a4,a5,80006c7a <filewrite+0x1da>
    80006c74:	fbc42783          	lw	a5,-68(s0)
    80006c78:	a011                	j	80006c7c <filewrite+0x1dc>
    80006c7a:	57fd                	li	a5,-1
    80006c7c:	fef42623          	sw	a5,-20(s0)
    80006c80:	a809                	j	80006c92 <filewrite+0x1f2>
  } else {
    panic("filewrite");
    80006c82:	00005517          	auipc	a0,0x5
    80006c86:	94e50513          	addi	a0,a0,-1714 # 8000b5d0 <etext+0x5d0>
    80006c8a:	ffffa097          	auipc	ra,0xffffa
    80006c8e:	036080e7          	jalr	54(ra) # 80000cc0 <panic>
  }

  return ret;
    80006c92:	fec42783          	lw	a5,-20(s0)
}
    80006c96:	853e                	mv	a0,a5
    80006c98:	60a6                	ld	ra,72(sp)
    80006c9a:	6406                	ld	s0,64(sp)
    80006c9c:	6161                	addi	sp,sp,80
    80006c9e:	8082                	ret

0000000080006ca0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80006ca0:	7179                	addi	sp,sp,-48
    80006ca2:	f406                	sd	ra,40(sp)
    80006ca4:	f022                	sd	s0,32(sp)
    80006ca6:	1800                	addi	s0,sp,48
    80006ca8:	fca43c23          	sd	a0,-40(s0)
    80006cac:	fcb43823          	sd	a1,-48(s0)
  struct pipe *pi;

  pi = 0;
    80006cb0:	fe043423          	sd	zero,-24(s0)
  *f0 = *f1 = 0;
    80006cb4:	fd043783          	ld	a5,-48(s0)
    80006cb8:	0007b023          	sd	zero,0(a5)
    80006cbc:	fd043783          	ld	a5,-48(s0)
    80006cc0:	6398                	ld	a4,0(a5)
    80006cc2:	fd843783          	ld	a5,-40(s0)
    80006cc6:	e398                	sd	a4,0(a5)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80006cc8:	00000097          	auipc	ra,0x0
    80006ccc:	9f6080e7          	jalr	-1546(ra) # 800066be <filealloc>
    80006cd0:	872a                	mv	a4,a0
    80006cd2:	fd843783          	ld	a5,-40(s0)
    80006cd6:	e398                	sd	a4,0(a5)
    80006cd8:	fd843783          	ld	a5,-40(s0)
    80006cdc:	639c                	ld	a5,0(a5)
    80006cde:	c3e9                	beqz	a5,80006da0 <pipealloc+0x100>
    80006ce0:	00000097          	auipc	ra,0x0
    80006ce4:	9de080e7          	jalr	-1570(ra) # 800066be <filealloc>
    80006ce8:	872a                	mv	a4,a0
    80006cea:	fd043783          	ld	a5,-48(s0)
    80006cee:	e398                	sd	a4,0(a5)
    80006cf0:	fd043783          	ld	a5,-48(s0)
    80006cf4:	639c                	ld	a5,0(a5)
    80006cf6:	c7cd                	beqz	a5,80006da0 <pipealloc+0x100>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80006cf8:	ffffa097          	auipc	ra,0xffffa
    80006cfc:	46c080e7          	jalr	1132(ra) # 80001164 <kalloc>
    80006d00:	fea43423          	sd	a0,-24(s0)
    80006d04:	fe843783          	ld	a5,-24(s0)
    80006d08:	cfd1                	beqz	a5,80006da4 <pipealloc+0x104>
    goto bad;
  pi->readopen = 1;
    80006d0a:	fe843783          	ld	a5,-24(s0)
    80006d0e:	4705                	li	a4,1
    80006d10:	22e7a023          	sw	a4,544(a5)
  pi->writeopen = 1;
    80006d14:	fe843783          	ld	a5,-24(s0)
    80006d18:	4705                	li	a4,1
    80006d1a:	22e7a223          	sw	a4,548(a5)
  pi->nwrite = 0;
    80006d1e:	fe843783          	ld	a5,-24(s0)
    80006d22:	2007ae23          	sw	zero,540(a5)
  pi->nread = 0;
    80006d26:	fe843783          	ld	a5,-24(s0)
    80006d2a:	2007ac23          	sw	zero,536(a5)
  initlock(&pi->lock, "pipe");
    80006d2e:	fe843783          	ld	a5,-24(s0)
    80006d32:	00005597          	auipc	a1,0x5
    80006d36:	8ae58593          	addi	a1,a1,-1874 # 8000b5e0 <etext+0x5e0>
    80006d3a:	853e                	mv	a0,a5
    80006d3c:	ffffa097          	auipc	ra,0xffffa
    80006d40:	554080e7          	jalr	1364(ra) # 80001290 <initlock>
  (*f0)->type = FD_PIPE;
    80006d44:	fd843783          	ld	a5,-40(s0)
    80006d48:	639c                	ld	a5,0(a5)
    80006d4a:	4705                	li	a4,1
    80006d4c:	c398                	sw	a4,0(a5)
  (*f0)->readable = 1;
    80006d4e:	fd843783          	ld	a5,-40(s0)
    80006d52:	639c                	ld	a5,0(a5)
    80006d54:	4705                	li	a4,1
    80006d56:	00e78423          	sb	a4,8(a5)
  (*f0)->writable = 0;
    80006d5a:	fd843783          	ld	a5,-40(s0)
    80006d5e:	639c                	ld	a5,0(a5)
    80006d60:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80006d64:	fd843783          	ld	a5,-40(s0)
    80006d68:	639c                	ld	a5,0(a5)
    80006d6a:	fe843703          	ld	a4,-24(s0)
    80006d6e:	eb98                	sd	a4,16(a5)
  (*f1)->type = FD_PIPE;
    80006d70:	fd043783          	ld	a5,-48(s0)
    80006d74:	639c                	ld	a5,0(a5)
    80006d76:	4705                	li	a4,1
    80006d78:	c398                	sw	a4,0(a5)
  (*f1)->readable = 0;
    80006d7a:	fd043783          	ld	a5,-48(s0)
    80006d7e:	639c                	ld	a5,0(a5)
    80006d80:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80006d84:	fd043783          	ld	a5,-48(s0)
    80006d88:	639c                	ld	a5,0(a5)
    80006d8a:	4705                	li	a4,1
    80006d8c:	00e784a3          	sb	a4,9(a5)
  (*f1)->pipe = pi;
    80006d90:	fd043783          	ld	a5,-48(s0)
    80006d94:	639c                	ld	a5,0(a5)
    80006d96:	fe843703          	ld	a4,-24(s0)
    80006d9a:	eb98                	sd	a4,16(a5)
  return 0;
    80006d9c:	4781                	li	a5,0
    80006d9e:	a0b1                	j	80006dea <pipealloc+0x14a>
    goto bad;
    80006da0:	0001                	nop
    80006da2:	a011                	j	80006da6 <pipealloc+0x106>
    goto bad;
    80006da4:	0001                	nop

 bad:
  if(pi)
    80006da6:	fe843783          	ld	a5,-24(s0)
    80006daa:	c799                	beqz	a5,80006db8 <pipealloc+0x118>
    kfree((char*)pi);
    80006dac:	fe843503          	ld	a0,-24(s0)
    80006db0:	ffffa097          	auipc	ra,0xffffa
    80006db4:	310080e7          	jalr	784(ra) # 800010c0 <kfree>
  if(*f0)
    80006db8:	fd843783          	ld	a5,-40(s0)
    80006dbc:	639c                	ld	a5,0(a5)
    80006dbe:	cb89                	beqz	a5,80006dd0 <pipealloc+0x130>
    fileclose(*f0);
    80006dc0:	fd843783          	ld	a5,-40(s0)
    80006dc4:	639c                	ld	a5,0(a5)
    80006dc6:	853e                	mv	a0,a5
    80006dc8:	00000097          	auipc	ra,0x0
    80006dcc:	9e0080e7          	jalr	-1568(ra) # 800067a8 <fileclose>
  if(*f1)
    80006dd0:	fd043783          	ld	a5,-48(s0)
    80006dd4:	639c                	ld	a5,0(a5)
    80006dd6:	cb89                	beqz	a5,80006de8 <pipealloc+0x148>
    fileclose(*f1);
    80006dd8:	fd043783          	ld	a5,-48(s0)
    80006ddc:	639c                	ld	a5,0(a5)
    80006dde:	853e                	mv	a0,a5
    80006de0:	00000097          	auipc	ra,0x0
    80006de4:	9c8080e7          	jalr	-1592(ra) # 800067a8 <fileclose>
  return -1;
    80006de8:	57fd                	li	a5,-1
}
    80006dea:	853e                	mv	a0,a5
    80006dec:	70a2                	ld	ra,40(sp)
    80006dee:	7402                	ld	s0,32(sp)
    80006df0:	6145                	addi	sp,sp,48
    80006df2:	8082                	ret

0000000080006df4 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80006df4:	1101                	addi	sp,sp,-32
    80006df6:	ec06                	sd	ra,24(sp)
    80006df8:	e822                	sd	s0,16(sp)
    80006dfa:	1000                	addi	s0,sp,32
    80006dfc:	fea43423          	sd	a0,-24(s0)
    80006e00:	87ae                	mv	a5,a1
    80006e02:	fef42223          	sw	a5,-28(s0)
  acquire(&pi->lock);
    80006e06:	fe843783          	ld	a5,-24(s0)
    80006e0a:	853e                	mv	a0,a5
    80006e0c:	ffffa097          	auipc	ra,0xffffa
    80006e10:	4b8080e7          	jalr	1208(ra) # 800012c4 <acquire>
  if(writable){
    80006e14:	fe442783          	lw	a5,-28(s0)
    80006e18:	2781                	sext.w	a5,a5
    80006e1a:	cf99                	beqz	a5,80006e38 <pipeclose+0x44>
    pi->writeopen = 0;
    80006e1c:	fe843783          	ld	a5,-24(s0)
    80006e20:	2207a223          	sw	zero,548(a5)
    wakeup(&pi->nread);
    80006e24:	fe843783          	ld	a5,-24(s0)
    80006e28:	21878793          	addi	a5,a5,536
    80006e2c:	853e                	mv	a0,a5
    80006e2e:	ffffc097          	auipc	ra,0xffffc
    80006e32:	6c4080e7          	jalr	1732(ra) # 800034f2 <wakeup>
    80006e36:	a831                	j	80006e52 <pipeclose+0x5e>
  } else {
    pi->readopen = 0;
    80006e38:	fe843783          	ld	a5,-24(s0)
    80006e3c:	2207a023          	sw	zero,544(a5)
    wakeup(&pi->nwrite);
    80006e40:	fe843783          	ld	a5,-24(s0)
    80006e44:	21c78793          	addi	a5,a5,540
    80006e48:	853e                	mv	a0,a5
    80006e4a:	ffffc097          	auipc	ra,0xffffc
    80006e4e:	6a8080e7          	jalr	1704(ra) # 800034f2 <wakeup>
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80006e52:	fe843783          	ld	a5,-24(s0)
    80006e56:	2207a783          	lw	a5,544(a5)
    80006e5a:	e785                	bnez	a5,80006e82 <pipeclose+0x8e>
    80006e5c:	fe843783          	ld	a5,-24(s0)
    80006e60:	2247a783          	lw	a5,548(a5)
    80006e64:	ef99                	bnez	a5,80006e82 <pipeclose+0x8e>
    release(&pi->lock);
    80006e66:	fe843783          	ld	a5,-24(s0)
    80006e6a:	853e                	mv	a0,a5
    80006e6c:	ffffa097          	auipc	ra,0xffffa
    80006e70:	4bc080e7          	jalr	1212(ra) # 80001328 <release>
    kfree((char*)pi);
    80006e74:	fe843503          	ld	a0,-24(s0)
    80006e78:	ffffa097          	auipc	ra,0xffffa
    80006e7c:	248080e7          	jalr	584(ra) # 800010c0 <kfree>
    80006e80:	a809                	j	80006e92 <pipeclose+0x9e>
  } else
    release(&pi->lock);
    80006e82:	fe843783          	ld	a5,-24(s0)
    80006e86:	853e                	mv	a0,a5
    80006e88:	ffffa097          	auipc	ra,0xffffa
    80006e8c:	4a0080e7          	jalr	1184(ra) # 80001328 <release>
}
    80006e90:	0001                	nop
    80006e92:	0001                	nop
    80006e94:	60e2                	ld	ra,24(sp)
    80006e96:	6442                	ld	s0,16(sp)
    80006e98:	6105                	addi	sp,sp,32
    80006e9a:	8082                	ret

0000000080006e9c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80006e9c:	715d                	addi	sp,sp,-80
    80006e9e:	e486                	sd	ra,72(sp)
    80006ea0:	e0a2                	sd	s0,64(sp)
    80006ea2:	0880                	addi	s0,sp,80
    80006ea4:	fca43423          	sd	a0,-56(s0)
    80006ea8:	fcb43023          	sd	a1,-64(s0)
    80006eac:	87b2                	mv	a5,a2
    80006eae:	faf42e23          	sw	a5,-68(s0)
  int i = 0;
    80006eb2:	fe042623          	sw	zero,-20(s0)
  struct proc *pr = myproc();
    80006eb6:	ffffc097          	auipc	ra,0xffffc
    80006eba:	a06080e7          	jalr	-1530(ra) # 800028bc <myproc>
    80006ebe:	fea43023          	sd	a0,-32(s0)

  acquire(&pi->lock);
    80006ec2:	fc843783          	ld	a5,-56(s0)
    80006ec6:	853e                	mv	a0,a5
    80006ec8:	ffffa097          	auipc	ra,0xffffa
    80006ecc:	3fc080e7          	jalr	1020(ra) # 800012c4 <acquire>
  while(i < n){
    80006ed0:	a8e9                	j	80006faa <pipewrite+0x10e>
    if(pi->readopen == 0 || killed(pr)){
    80006ed2:	fc843783          	ld	a5,-56(s0)
    80006ed6:	2207a783          	lw	a5,544(a5)
    80006eda:	cb89                	beqz	a5,80006eec <pipewrite+0x50>
    80006edc:	fe043503          	ld	a0,-32(s0)
    80006ee0:	ffffc097          	auipc	ra,0xffffc
    80006ee4:	77c080e7          	jalr	1916(ra) # 8000365c <killed>
    80006ee8:	87aa                	mv	a5,a0
    80006eea:	cb91                	beqz	a5,80006efe <pipewrite+0x62>
      release(&pi->lock);
    80006eec:	fc843783          	ld	a5,-56(s0)
    80006ef0:	853e                	mv	a0,a5
    80006ef2:	ffffa097          	auipc	ra,0xffffa
    80006ef6:	436080e7          	jalr	1078(ra) # 80001328 <release>
      return -1;
    80006efa:	57fd                	li	a5,-1
    80006efc:	a0e5                	j	80006fe4 <pipewrite+0x148>
    }
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80006efe:	fc843783          	ld	a5,-56(s0)
    80006f02:	21c7a703          	lw	a4,540(a5)
    80006f06:	fc843783          	ld	a5,-56(s0)
    80006f0a:	2187a783          	lw	a5,536(a5)
    80006f0e:	2007879b          	addiw	a5,a5,512
    80006f12:	2781                	sext.w	a5,a5
    80006f14:	02f71863          	bne	a4,a5,80006f44 <pipewrite+0xa8>
      wakeup(&pi->nread);
    80006f18:	fc843783          	ld	a5,-56(s0)
    80006f1c:	21878793          	addi	a5,a5,536
    80006f20:	853e                	mv	a0,a5
    80006f22:	ffffc097          	auipc	ra,0xffffc
    80006f26:	5d0080e7          	jalr	1488(ra) # 800034f2 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80006f2a:	fc843783          	ld	a5,-56(s0)
    80006f2e:	21c78793          	addi	a5,a5,540
    80006f32:	fc843703          	ld	a4,-56(s0)
    80006f36:	85ba                	mv	a1,a4
    80006f38:	853e                	mv	a0,a5
    80006f3a:	ffffc097          	auipc	ra,0xffffc
    80006f3e:	53c080e7          	jalr	1340(ra) # 80003476 <sleep>
    80006f42:	a0a5                	j	80006faa <pipewrite+0x10e>
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80006f44:	fe043783          	ld	a5,-32(s0)
    80006f48:	6ba8                	ld	a0,80(a5)
    80006f4a:	fec42703          	lw	a4,-20(s0)
    80006f4e:	fc043783          	ld	a5,-64(s0)
    80006f52:	973e                	add	a4,a4,a5
    80006f54:	fdf40793          	addi	a5,s0,-33
    80006f58:	4685                	li	a3,1
    80006f5a:	863a                	mv	a2,a4
    80006f5c:	85be                	mv	a1,a5
    80006f5e:	ffffb097          	auipc	ra,0xffffb
    80006f62:	4ea080e7          	jalr	1258(ra) # 80002448 <copyin>
    80006f66:	87aa                	mv	a5,a0
    80006f68:	873e                	mv	a4,a5
    80006f6a:	57fd                	li	a5,-1
    80006f6c:	04f70963          	beq	a4,a5,80006fbe <pipewrite+0x122>
        break;
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80006f70:	fc843783          	ld	a5,-56(s0)
    80006f74:	21c7a783          	lw	a5,540(a5)
    80006f78:	0017871b          	addiw	a4,a5,1
    80006f7c:	0007069b          	sext.w	a3,a4
    80006f80:	fc843703          	ld	a4,-56(s0)
    80006f84:	20d72e23          	sw	a3,540(a4)
    80006f88:	1ff7f793          	andi	a5,a5,511
    80006f8c:	2781                	sext.w	a5,a5
    80006f8e:	fdf44703          	lbu	a4,-33(s0)
    80006f92:	fc843683          	ld	a3,-56(s0)
    80006f96:	1782                	slli	a5,a5,0x20
    80006f98:	9381                	srli	a5,a5,0x20
    80006f9a:	97b6                	add	a5,a5,a3
    80006f9c:	00e78c23          	sb	a4,24(a5)
      i++;
    80006fa0:	fec42783          	lw	a5,-20(s0)
    80006fa4:	2785                	addiw	a5,a5,1
    80006fa6:	fef42623          	sw	a5,-20(s0)
  while(i < n){
    80006faa:	fec42783          	lw	a5,-20(s0)
    80006fae:	873e                	mv	a4,a5
    80006fb0:	fbc42783          	lw	a5,-68(s0)
    80006fb4:	2701                	sext.w	a4,a4
    80006fb6:	2781                	sext.w	a5,a5
    80006fb8:	f0f74de3          	blt	a4,a5,80006ed2 <pipewrite+0x36>
    80006fbc:	a011                	j	80006fc0 <pipewrite+0x124>
        break;
    80006fbe:	0001                	nop
    }
  }
  wakeup(&pi->nread);
    80006fc0:	fc843783          	ld	a5,-56(s0)
    80006fc4:	21878793          	addi	a5,a5,536
    80006fc8:	853e                	mv	a0,a5
    80006fca:	ffffc097          	auipc	ra,0xffffc
    80006fce:	528080e7          	jalr	1320(ra) # 800034f2 <wakeup>
  release(&pi->lock);
    80006fd2:	fc843783          	ld	a5,-56(s0)
    80006fd6:	853e                	mv	a0,a5
    80006fd8:	ffffa097          	auipc	ra,0xffffa
    80006fdc:	350080e7          	jalr	848(ra) # 80001328 <release>

  return i;
    80006fe0:	fec42783          	lw	a5,-20(s0)
}
    80006fe4:	853e                	mv	a0,a5
    80006fe6:	60a6                	ld	ra,72(sp)
    80006fe8:	6406                	ld	s0,64(sp)
    80006fea:	6161                	addi	sp,sp,80
    80006fec:	8082                	ret

0000000080006fee <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80006fee:	715d                	addi	sp,sp,-80
    80006ff0:	e486                	sd	ra,72(sp)
    80006ff2:	e0a2                	sd	s0,64(sp)
    80006ff4:	0880                	addi	s0,sp,80
    80006ff6:	fca43423          	sd	a0,-56(s0)
    80006ffa:	fcb43023          	sd	a1,-64(s0)
    80006ffe:	87b2                	mv	a5,a2
    80007000:	faf42e23          	sw	a5,-68(s0)
  int i;
  struct proc *pr = myproc();
    80007004:	ffffc097          	auipc	ra,0xffffc
    80007008:	8b8080e7          	jalr	-1864(ra) # 800028bc <myproc>
    8000700c:	fea43023          	sd	a0,-32(s0)
  char ch;

  acquire(&pi->lock);
    80007010:	fc843783          	ld	a5,-56(s0)
    80007014:	853e                	mv	a0,a5
    80007016:	ffffa097          	auipc	ra,0xffffa
    8000701a:	2ae080e7          	jalr	686(ra) # 800012c4 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000701e:	a835                	j	8000705a <piperead+0x6c>
    if(killed(pr)){
    80007020:	fe043503          	ld	a0,-32(s0)
    80007024:	ffffc097          	auipc	ra,0xffffc
    80007028:	638080e7          	jalr	1592(ra) # 8000365c <killed>
    8000702c:	87aa                	mv	a5,a0
    8000702e:	cb91                	beqz	a5,80007042 <piperead+0x54>
      release(&pi->lock);
    80007030:	fc843783          	ld	a5,-56(s0)
    80007034:	853e                	mv	a0,a5
    80007036:	ffffa097          	auipc	ra,0xffffa
    8000703a:	2f2080e7          	jalr	754(ra) # 80001328 <release>
      return -1;
    8000703e:	57fd                	li	a5,-1
    80007040:	a8dd                	j	80007136 <piperead+0x148>
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80007042:	fc843783          	ld	a5,-56(s0)
    80007046:	21878793          	addi	a5,a5,536
    8000704a:	fc843703          	ld	a4,-56(s0)
    8000704e:	85ba                	mv	a1,a4
    80007050:	853e                	mv	a0,a5
    80007052:	ffffc097          	auipc	ra,0xffffc
    80007056:	424080e7          	jalr	1060(ra) # 80003476 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000705a:	fc843783          	ld	a5,-56(s0)
    8000705e:	2187a703          	lw	a4,536(a5)
    80007062:	fc843783          	ld	a5,-56(s0)
    80007066:	21c7a783          	lw	a5,540(a5)
    8000706a:	00f71763          	bne	a4,a5,80007078 <piperead+0x8a>
    8000706e:	fc843783          	ld	a5,-56(s0)
    80007072:	2247a783          	lw	a5,548(a5)
    80007076:	f7cd                	bnez	a5,80007020 <piperead+0x32>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80007078:	fe042623          	sw	zero,-20(s0)
    8000707c:	a8b5                	j	800070f8 <piperead+0x10a>
    if(pi->nread == pi->nwrite)
    8000707e:	fc843783          	ld	a5,-56(s0)
    80007082:	2187a703          	lw	a4,536(a5)
    80007086:	fc843783          	ld	a5,-56(s0)
    8000708a:	21c7a783          	lw	a5,540(a5)
    8000708e:	06f70f63          	beq	a4,a5,8000710c <piperead+0x11e>
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    80007092:	fc843783          	ld	a5,-56(s0)
    80007096:	2187a783          	lw	a5,536(a5)
    8000709a:	0017871b          	addiw	a4,a5,1
    8000709e:	0007069b          	sext.w	a3,a4
    800070a2:	fc843703          	ld	a4,-56(s0)
    800070a6:	20d72c23          	sw	a3,536(a4)
    800070aa:	1ff7f793          	andi	a5,a5,511
    800070ae:	2781                	sext.w	a5,a5
    800070b0:	fc843703          	ld	a4,-56(s0)
    800070b4:	1782                	slli	a5,a5,0x20
    800070b6:	9381                	srli	a5,a5,0x20
    800070b8:	97ba                	add	a5,a5,a4
    800070ba:	0187c783          	lbu	a5,24(a5)
    800070be:	fcf40fa3          	sb	a5,-33(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800070c2:	fe043783          	ld	a5,-32(s0)
    800070c6:	6ba8                	ld	a0,80(a5)
    800070c8:	fec42703          	lw	a4,-20(s0)
    800070cc:	fc043783          	ld	a5,-64(s0)
    800070d0:	97ba                	add	a5,a5,a4
    800070d2:	fdf40713          	addi	a4,s0,-33
    800070d6:	4685                	li	a3,1
    800070d8:	863a                	mv	a2,a4
    800070da:	85be                	mv	a1,a5
    800070dc:	ffffb097          	auipc	ra,0xffffb
    800070e0:	29e080e7          	jalr	670(ra) # 8000237a <copyout>
    800070e4:	87aa                	mv	a5,a0
    800070e6:	873e                	mv	a4,a5
    800070e8:	57fd                	li	a5,-1
    800070ea:	02f70363          	beq	a4,a5,80007110 <piperead+0x122>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800070ee:	fec42783          	lw	a5,-20(s0)
    800070f2:	2785                	addiw	a5,a5,1
    800070f4:	fef42623          	sw	a5,-20(s0)
    800070f8:	fec42783          	lw	a5,-20(s0)
    800070fc:	873e                	mv	a4,a5
    800070fe:	fbc42783          	lw	a5,-68(s0)
    80007102:	2701                	sext.w	a4,a4
    80007104:	2781                	sext.w	a5,a5
    80007106:	f6f74ce3          	blt	a4,a5,8000707e <piperead+0x90>
    8000710a:	a021                	j	80007112 <piperead+0x124>
      break;
    8000710c:	0001                	nop
    8000710e:	a011                	j	80007112 <piperead+0x124>
      break;
    80007110:	0001                	nop
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80007112:	fc843783          	ld	a5,-56(s0)
    80007116:	21c78793          	addi	a5,a5,540
    8000711a:	853e                	mv	a0,a5
    8000711c:	ffffc097          	auipc	ra,0xffffc
    80007120:	3d6080e7          	jalr	982(ra) # 800034f2 <wakeup>
  release(&pi->lock);
    80007124:	fc843783          	ld	a5,-56(s0)
    80007128:	853e                	mv	a0,a5
    8000712a:	ffffa097          	auipc	ra,0xffffa
    8000712e:	1fe080e7          	jalr	510(ra) # 80001328 <release>
  return i;
    80007132:	fec42783          	lw	a5,-20(s0)
}
    80007136:	853e                	mv	a0,a5
    80007138:	60a6                	ld	ra,72(sp)
    8000713a:	6406                	ld	s0,64(sp)
    8000713c:	6161                	addi	sp,sp,80
    8000713e:	8082                	ret

0000000080007140 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80007140:	7179                	addi	sp,sp,-48
    80007142:	f406                	sd	ra,40(sp)
    80007144:	f022                	sd	s0,32(sp)
    80007146:	1800                	addi	s0,sp,48
    80007148:	87aa                	mv	a5,a0
    8000714a:	fcf42e23          	sw	a5,-36(s0)
    int perm = 0;
    8000714e:	fe042623          	sw	zero,-20(s0)
    if(flags & 0x1)
    80007152:	fdc42783          	lw	a5,-36(s0)
    80007156:	8b85                	andi	a5,a5,1
    80007158:	2781                	sext.w	a5,a5
    8000715a:	c781                	beqz	a5,80007162 <flags2perm+0x22>
      perm = PTE_X;
    8000715c:	47a1                	li	a5,8
    8000715e:	fef42623          	sw	a5,-20(s0)
    if(flags & 0x2)
    80007162:	fdc42783          	lw	a5,-36(s0)
    80007166:	8b89                	andi	a5,a5,2
    80007168:	2781                	sext.w	a5,a5
    8000716a:	c799                	beqz	a5,80007178 <flags2perm+0x38>
      perm |= PTE_W;
    8000716c:	fec42783          	lw	a5,-20(s0)
    80007170:	0047e793          	ori	a5,a5,4
    80007174:	fef42623          	sw	a5,-20(s0)
    return perm;
    80007178:	fec42783          	lw	a5,-20(s0)
}
    8000717c:	853e                	mv	a0,a5
    8000717e:	70a2                	ld	ra,40(sp)
    80007180:	7402                	ld	s0,32(sp)
    80007182:	6145                	addi	sp,sp,48
    80007184:	8082                	ret

0000000080007186 <exec>:

int
exec(char *path, char **argv)
{
    80007186:	de010113          	addi	sp,sp,-544
    8000718a:	20113c23          	sd	ra,536(sp)
    8000718e:	20813823          	sd	s0,528(sp)
    80007192:	20913423          	sd	s1,520(sp)
    80007196:	1400                	addi	s0,sp,544
    80007198:	dea43423          	sd	a0,-536(s0)
    8000719c:	deb43023          	sd	a1,-544(s0)
  char *s, *last;
  int i, off;
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800071a0:	fa043c23          	sd	zero,-72(s0)
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
    800071a4:	fa043023          	sd	zero,-96(s0)
  struct proc *p = myproc();
    800071a8:	ffffb097          	auipc	ra,0xffffb
    800071ac:	714080e7          	jalr	1812(ra) # 800028bc <myproc>
    800071b0:	f8a43c23          	sd	a0,-104(s0)

  begin_op();
    800071b4:	fffff097          	auipc	ra,0xfffff
    800071b8:	f6a080e7          	jalr	-150(ra) # 8000611e <begin_op>

  if((ip = namei(path)) == 0){
    800071bc:	de843503          	ld	a0,-536(s0)
    800071c0:	fffff097          	auipc	ra,0xfffff
    800071c4:	c0e080e7          	jalr	-1010(ra) # 80005dce <namei>
    800071c8:	faa43423          	sd	a0,-88(s0)
    800071cc:	fa843783          	ld	a5,-88(s0)
    800071d0:	e799                	bnez	a5,800071de <exec+0x58>
    end_op();
    800071d2:	fffff097          	auipc	ra,0xfffff
    800071d6:	00e080e7          	jalr	14(ra) # 800061e0 <end_op>
    return -1;
    800071da:	57fd                	li	a5,-1
    800071dc:	a181                	j	8000761c <exec+0x496>
  }
  ilock(ip);
    800071de:	fa843503          	ld	a0,-88(s0)
    800071e2:	ffffe097          	auipc	ra,0xffffe
    800071e6:	ecc080e7          	jalr	-308(ra) # 800050ae <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800071ea:	e3040793          	addi	a5,s0,-464
    800071ee:	04000713          	li	a4,64
    800071f2:	4681                	li	a3,0
    800071f4:	863e                	mv	a2,a5
    800071f6:	4581                	li	a1,0
    800071f8:	fa843503          	ld	a0,-88(s0)
    800071fc:	ffffe097          	auipc	ra,0xffffe
    80007200:	460080e7          	jalr	1120(ra) # 8000565c <readi>
    80007204:	87aa                	mv	a5,a0
    80007206:	873e                	mv	a4,a5
    80007208:	04000793          	li	a5,64
    8000720c:	3af71263          	bne	a4,a5,800075b0 <exec+0x42a>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80007210:	e3042703          	lw	a4,-464(s0)
    80007214:	464c47b7          	lui	a5,0x464c4
    80007218:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000721c:	38f71c63          	bne	a4,a5,800075b4 <exec+0x42e>
    goto bad;

  if((pagetable = proc_pagetable(p)) == 0)
    80007220:	f9843503          	ld	a0,-104(s0)
    80007224:	ffffc097          	auipc	ra,0xffffc
    80007228:	8fa080e7          	jalr	-1798(ra) # 80002b1e <proc_pagetable>
    8000722c:	faa43023          	sd	a0,-96(s0)
    80007230:	fa043783          	ld	a5,-96(s0)
    80007234:	38078263          	beqz	a5,800075b8 <exec+0x432>
    goto bad;

  // Load program into memory.
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80007238:	fc042623          	sw	zero,-52(s0)
    8000723c:	e5043783          	ld	a5,-432(s0)
    80007240:	fcf42423          	sw	a5,-56(s0)
    80007244:	a0ed                	j	8000732e <exec+0x1a8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80007246:	df840793          	addi	a5,s0,-520
    8000724a:	fc842683          	lw	a3,-56(s0)
    8000724e:	03800713          	li	a4,56
    80007252:	863e                	mv	a2,a5
    80007254:	4581                	li	a1,0
    80007256:	fa843503          	ld	a0,-88(s0)
    8000725a:	ffffe097          	auipc	ra,0xffffe
    8000725e:	402080e7          	jalr	1026(ra) # 8000565c <readi>
    80007262:	87aa                	mv	a5,a0
    80007264:	873e                	mv	a4,a5
    80007266:	03800793          	li	a5,56
    8000726a:	34f71963          	bne	a4,a5,800075bc <exec+0x436>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
    8000726e:	df842703          	lw	a4,-520(s0)
    80007272:	4785                	li	a5,1
    80007274:	0af71063          	bne	a4,a5,80007314 <exec+0x18e>
      continue;
    if(ph.memsz < ph.filesz)
    80007278:	e2043703          	ld	a4,-480(s0)
    8000727c:	e1843783          	ld	a5,-488(s0)
    80007280:	34f76063          	bltu	a4,a5,800075c0 <exec+0x43a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80007284:	e0843703          	ld	a4,-504(s0)
    80007288:	e2043783          	ld	a5,-480(s0)
    8000728c:	973e                	add	a4,a4,a5
    8000728e:	e0843783          	ld	a5,-504(s0)
    80007292:	32f76963          	bltu	a4,a5,800075c4 <exec+0x43e>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
    80007296:	e0843703          	ld	a4,-504(s0)
    8000729a:	6785                	lui	a5,0x1
    8000729c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000729e:	8ff9                	and	a5,a5,a4
    800072a0:	32079463          	bnez	a5,800075c8 <exec+0x442>
      goto bad;
    uint64 sz1;
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800072a4:	e0843703          	ld	a4,-504(s0)
    800072a8:	e2043783          	ld	a5,-480(s0)
    800072ac:	00f704b3          	add	s1,a4,a5
    800072b0:	dfc42783          	lw	a5,-516(s0)
    800072b4:	853e                	mv	a0,a5
    800072b6:	00000097          	auipc	ra,0x0
    800072ba:	e8a080e7          	jalr	-374(ra) # 80007140 <flags2perm>
    800072be:	87aa                	mv	a5,a0
    800072c0:	86be                	mv	a3,a5
    800072c2:	8626                	mv	a2,s1
    800072c4:	fb843583          	ld	a1,-72(s0)
    800072c8:	fa043503          	ld	a0,-96(s0)
    800072cc:	ffffb097          	auipc	ra,0xffffb
    800072d0:	cc2080e7          	jalr	-830(ra) # 80001f8e <uvmalloc>
    800072d4:	f6a43823          	sd	a0,-144(s0)
    800072d8:	f7043783          	ld	a5,-144(s0)
    800072dc:	2e078863          	beqz	a5,800075cc <exec+0x446>
      goto bad;
    sz = sz1;
    800072e0:	f7043783          	ld	a5,-144(s0)
    800072e4:	faf43c23          	sd	a5,-72(s0)
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800072e8:	e0843783          	ld	a5,-504(s0)
    800072ec:	e0043703          	ld	a4,-512(s0)
    800072f0:	0007069b          	sext.w	a3,a4
    800072f4:	e1843703          	ld	a4,-488(s0)
    800072f8:	2701                	sext.w	a4,a4
    800072fa:	fa843603          	ld	a2,-88(s0)
    800072fe:	85be                	mv	a1,a5
    80007300:	fa043503          	ld	a0,-96(s0)
    80007304:	00000097          	auipc	ra,0x0
    80007308:	32c080e7          	jalr	812(ra) # 80007630 <loadseg>
    8000730c:	87aa                	mv	a5,a0
    8000730e:	2c07c163          	bltz	a5,800075d0 <exec+0x44a>
    80007312:	a011                	j	80007316 <exec+0x190>
      continue;
    80007314:	0001                	nop
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80007316:	fcc42783          	lw	a5,-52(s0)
    8000731a:	2785                	addiw	a5,a5,1
    8000731c:	fcf42623          	sw	a5,-52(s0)
    80007320:	fc842783          	lw	a5,-56(s0)
    80007324:	0387879b          	addiw	a5,a5,56
    80007328:	2781                	sext.w	a5,a5
    8000732a:	fcf42423          	sw	a5,-56(s0)
    8000732e:	e6845783          	lhu	a5,-408(s0)
    80007332:	2781                	sext.w	a5,a5
    80007334:	fcc42703          	lw	a4,-52(s0)
    80007338:	2701                	sext.w	a4,a4
    8000733a:	f0f746e3          	blt	a4,a5,80007246 <exec+0xc0>
      goto bad;
  }
  iunlockput(ip);
    8000733e:	fa843503          	ld	a0,-88(s0)
    80007342:	ffffe097          	auipc	ra,0xffffe
    80007346:	fc8080e7          	jalr	-56(ra) # 8000530a <iunlockput>
  end_op();
    8000734a:	fffff097          	auipc	ra,0xfffff
    8000734e:	e96080e7          	jalr	-362(ra) # 800061e0 <end_op>
  ip = 0;
    80007352:	fa043423          	sd	zero,-88(s0)

  p = myproc();
    80007356:	ffffb097          	auipc	ra,0xffffb
    8000735a:	566080e7          	jalr	1382(ra) # 800028bc <myproc>
    8000735e:	f8a43c23          	sd	a0,-104(s0)
  uint64 oldsz = p->sz;
    80007362:	f9843783          	ld	a5,-104(s0)
    80007366:	67bc                	ld	a5,72(a5)
    80007368:	f8f43823          	sd	a5,-112(s0)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible as a stack guard.
  // Use the second as the user stack.
  sz = PGROUNDUP(sz);
    8000736c:	fb843703          	ld	a4,-72(s0)
    80007370:	6785                	lui	a5,0x1
    80007372:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80007374:	973e                	add	a4,a4,a5
    80007376:	77fd                	lui	a5,0xfffff
    80007378:	8ff9                	and	a5,a5,a4
    8000737a:	faf43c23          	sd	a5,-72(s0)
  uint64 sz1;
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000737e:	fb843703          	ld	a4,-72(s0)
    80007382:	6789                	lui	a5,0x2
    80007384:	97ba                	add	a5,a5,a4
    80007386:	4691                	li	a3,4
    80007388:	863e                	mv	a2,a5
    8000738a:	fb843583          	ld	a1,-72(s0)
    8000738e:	fa043503          	ld	a0,-96(s0)
    80007392:	ffffb097          	auipc	ra,0xffffb
    80007396:	bfc080e7          	jalr	-1028(ra) # 80001f8e <uvmalloc>
    8000739a:	f8a43423          	sd	a0,-120(s0)
    8000739e:	f8843783          	ld	a5,-120(s0)
    800073a2:	22078963          	beqz	a5,800075d4 <exec+0x44e>
    goto bad;
  sz = sz1;
    800073a6:	f8843783          	ld	a5,-120(s0)
    800073aa:	faf43c23          	sd	a5,-72(s0)
  uvmclear(pagetable, sz-2*PGSIZE);
    800073ae:	fb843703          	ld	a4,-72(s0)
    800073b2:	77f9                	lui	a5,0xffffe
    800073b4:	97ba                	add	a5,a5,a4
    800073b6:	85be                	mv	a1,a5
    800073b8:	fa043503          	ld	a0,-96(s0)
    800073bc:	ffffb097          	auipc	ra,0xffffb
    800073c0:	f68080e7          	jalr	-152(ra) # 80002324 <uvmclear>
  sp = sz;
    800073c4:	fb843783          	ld	a5,-72(s0)
    800073c8:	faf43823          	sd	a5,-80(s0)
  stackbase = sp - PGSIZE;
    800073cc:	fb043703          	ld	a4,-80(s0)
    800073d0:	77fd                	lui	a5,0xfffff
    800073d2:	97ba                	add	a5,a5,a4
    800073d4:	f8f43023          	sd	a5,-128(s0)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    800073d8:	fc043023          	sd	zero,-64(s0)
    800073dc:	a07d                	j	8000748a <exec+0x304>
    if(argc >= MAXARG)
    800073de:	fc043703          	ld	a4,-64(s0)
    800073e2:	47fd                	li	a5,31
    800073e4:	1ee7ea63          	bltu	a5,a4,800075d8 <exec+0x452>
      goto bad;
    sp -= strlen(argv[argc]) + 1;
    800073e8:	fc043783          	ld	a5,-64(s0)
    800073ec:	078e                	slli	a5,a5,0x3
    800073ee:	de043703          	ld	a4,-544(s0)
    800073f2:	97ba                	add	a5,a5,a4
    800073f4:	639c                	ld	a5,0(a5)
    800073f6:	853e                	mv	a0,a5
    800073f8:	ffffa097          	auipc	ra,0xffffa
    800073fc:	438080e7          	jalr	1080(ra) # 80001830 <strlen>
    80007400:	87aa                	mv	a5,a0
    80007402:	2785                	addiw	a5,a5,1 # fffffffffffff001 <end+0xffffffff7ffda2b9>
    80007404:	2781                	sext.w	a5,a5
    80007406:	873e                	mv	a4,a5
    80007408:	fb043783          	ld	a5,-80(s0)
    8000740c:	8f99                	sub	a5,a5,a4
    8000740e:	faf43823          	sd	a5,-80(s0)
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80007412:	fb043783          	ld	a5,-80(s0)
    80007416:	9bc1                	andi	a5,a5,-16
    80007418:	faf43823          	sd	a5,-80(s0)
    if(sp < stackbase)
    8000741c:	fb043703          	ld	a4,-80(s0)
    80007420:	f8043783          	ld	a5,-128(s0)
    80007424:	1af76c63          	bltu	a4,a5,800075dc <exec+0x456>
      goto bad;
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80007428:	fc043783          	ld	a5,-64(s0)
    8000742c:	078e                	slli	a5,a5,0x3
    8000742e:	de043703          	ld	a4,-544(s0)
    80007432:	97ba                	add	a5,a5,a4
    80007434:	6384                	ld	s1,0(a5)
    80007436:	fc043783          	ld	a5,-64(s0)
    8000743a:	078e                	slli	a5,a5,0x3
    8000743c:	de043703          	ld	a4,-544(s0)
    80007440:	97ba                	add	a5,a5,a4
    80007442:	639c                	ld	a5,0(a5)
    80007444:	853e                	mv	a0,a5
    80007446:	ffffa097          	auipc	ra,0xffffa
    8000744a:	3ea080e7          	jalr	1002(ra) # 80001830 <strlen>
    8000744e:	87aa                	mv	a5,a0
    80007450:	2785                	addiw	a5,a5,1
    80007452:	2781                	sext.w	a5,a5
    80007454:	86be                	mv	a3,a5
    80007456:	8626                	mv	a2,s1
    80007458:	fb043583          	ld	a1,-80(s0)
    8000745c:	fa043503          	ld	a0,-96(s0)
    80007460:	ffffb097          	auipc	ra,0xffffb
    80007464:	f1a080e7          	jalr	-230(ra) # 8000237a <copyout>
    80007468:	87aa                	mv	a5,a0
    8000746a:	1607cb63          	bltz	a5,800075e0 <exec+0x45a>
      goto bad;
    ustack[argc] = sp;
    8000746e:	fc043703          	ld	a4,-64(s0)
    80007472:	e7040793          	addi	a5,s0,-400
    80007476:	070e                	slli	a4,a4,0x3
    80007478:	97ba                	add	a5,a5,a4
    8000747a:	fb043703          	ld	a4,-80(s0)
    8000747e:	e398                	sd	a4,0(a5)
  for(argc = 0; argv[argc]; argc++) {
    80007480:	fc043783          	ld	a5,-64(s0)
    80007484:	0785                	addi	a5,a5,1
    80007486:	fcf43023          	sd	a5,-64(s0)
    8000748a:	fc043783          	ld	a5,-64(s0)
    8000748e:	078e                	slli	a5,a5,0x3
    80007490:	de043703          	ld	a4,-544(s0)
    80007494:	97ba                	add	a5,a5,a4
    80007496:	639c                	ld	a5,0(a5)
    80007498:	f3b9                	bnez	a5,800073de <exec+0x258>
  }
  ustack[argc] = 0;
    8000749a:	fc043703          	ld	a4,-64(s0)
    8000749e:	e7040793          	addi	a5,s0,-400
    800074a2:	070e                	slli	a4,a4,0x3
    800074a4:	97ba                	add	a5,a5,a4
    800074a6:	0007b023          	sd	zero,0(a5)

  // push the array of argv[] pointers.
  sp -= (argc+1) * sizeof(uint64);
    800074aa:	fc043783          	ld	a5,-64(s0)
    800074ae:	0785                	addi	a5,a5,1
    800074b0:	078e                	slli	a5,a5,0x3
    800074b2:	fb043703          	ld	a4,-80(s0)
    800074b6:	40f707b3          	sub	a5,a4,a5
    800074ba:	faf43823          	sd	a5,-80(s0)
  sp -= sp % 16;
    800074be:	fb043783          	ld	a5,-80(s0)
    800074c2:	9bc1                	andi	a5,a5,-16
    800074c4:	faf43823          	sd	a5,-80(s0)
  if(sp < stackbase)
    800074c8:	fb043703          	ld	a4,-80(s0)
    800074cc:	f8043783          	ld	a5,-128(s0)
    800074d0:	10f76a63          	bltu	a4,a5,800075e4 <exec+0x45e>
    goto bad;
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800074d4:	fc043783          	ld	a5,-64(s0)
    800074d8:	0785                	addi	a5,a5,1
    800074da:	00379713          	slli	a4,a5,0x3
    800074de:	e7040793          	addi	a5,s0,-400
    800074e2:	86ba                	mv	a3,a4
    800074e4:	863e                	mv	a2,a5
    800074e6:	fb043583          	ld	a1,-80(s0)
    800074ea:	fa043503          	ld	a0,-96(s0)
    800074ee:	ffffb097          	auipc	ra,0xffffb
    800074f2:	e8c080e7          	jalr	-372(ra) # 8000237a <copyout>
    800074f6:	87aa                	mv	a5,a0
    800074f8:	0e07c863          	bltz	a5,800075e8 <exec+0x462>
    goto bad;

  // arguments to user main(argc, argv)
  // argc is returned via the system call return
  // value, which goes in a0.
  p->trapframe->a1 = sp;
    800074fc:	f9843783          	ld	a5,-104(s0)
    80007500:	6fbc                	ld	a5,88(a5)
    80007502:	fb043703          	ld	a4,-80(s0)
    80007506:	ffb8                	sd	a4,120(a5)

  // Save program name for debugging.
  for(last=s=path; *s; s++)
    80007508:	de843783          	ld	a5,-536(s0)
    8000750c:	fcf43c23          	sd	a5,-40(s0)
    80007510:	fd843783          	ld	a5,-40(s0)
    80007514:	fcf43823          	sd	a5,-48(s0)
    80007518:	a025                	j	80007540 <exec+0x3ba>
    if(*s == '/')
    8000751a:	fd843783          	ld	a5,-40(s0)
    8000751e:	0007c783          	lbu	a5,0(a5)
    80007522:	873e                	mv	a4,a5
    80007524:	02f00793          	li	a5,47
    80007528:	00f71763          	bne	a4,a5,80007536 <exec+0x3b0>
      last = s+1;
    8000752c:	fd843783          	ld	a5,-40(s0)
    80007530:	0785                	addi	a5,a5,1
    80007532:	fcf43823          	sd	a5,-48(s0)
  for(last=s=path; *s; s++)
    80007536:	fd843783          	ld	a5,-40(s0)
    8000753a:	0785                	addi	a5,a5,1
    8000753c:	fcf43c23          	sd	a5,-40(s0)
    80007540:	fd843783          	ld	a5,-40(s0)
    80007544:	0007c783          	lbu	a5,0(a5)
    80007548:	fbe9                	bnez	a5,8000751a <exec+0x394>
  safestrcpy(p->name, last, sizeof(p->name));
    8000754a:	f9843783          	ld	a5,-104(s0)
    8000754e:	15878793          	addi	a5,a5,344
    80007552:	4641                	li	a2,16
    80007554:	fd043583          	ld	a1,-48(s0)
    80007558:	853e                	mv	a0,a5
    8000755a:	ffffa097          	auipc	ra,0xffffa
    8000755e:	256080e7          	jalr	598(ra) # 800017b0 <safestrcpy>
    
  // Commit to the user image.
  oldpagetable = p->pagetable;
    80007562:	f9843783          	ld	a5,-104(s0)
    80007566:	6bbc                	ld	a5,80(a5)
    80007568:	f6f43c23          	sd	a5,-136(s0)
  p->pagetable = pagetable;
    8000756c:	f9843783          	ld	a5,-104(s0)
    80007570:	fa043703          	ld	a4,-96(s0)
    80007574:	ebb8                	sd	a4,80(a5)
  p->sz = sz;
    80007576:	f9843783          	ld	a5,-104(s0)
    8000757a:	fb843703          	ld	a4,-72(s0)
    8000757e:	e7b8                	sd	a4,72(a5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80007580:	f9843783          	ld	a5,-104(s0)
    80007584:	6fbc                	ld	a5,88(a5)
    80007586:	e4843703          	ld	a4,-440(s0)
    8000758a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000758c:	f9843783          	ld	a5,-104(s0)
    80007590:	6fbc                	ld	a5,88(a5)
    80007592:	fb043703          	ld	a4,-80(s0)
    80007596:	fb98                	sd	a4,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80007598:	f9043583          	ld	a1,-112(s0)
    8000759c:	f7843503          	ld	a0,-136(s0)
    800075a0:	ffffb097          	auipc	ra,0xffffb
    800075a4:	63e080e7          	jalr	1598(ra) # 80002bde <proc_freepagetable>

  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800075a8:	fc043783          	ld	a5,-64(s0)
    800075ac:	2781                	sext.w	a5,a5
    800075ae:	a0bd                	j	8000761c <exec+0x496>
    goto bad;
    800075b0:	0001                	nop
    800075b2:	a825                	j	800075ea <exec+0x464>
    goto bad;
    800075b4:	0001                	nop
    800075b6:	a815                	j	800075ea <exec+0x464>
    goto bad;
    800075b8:	0001                	nop
    800075ba:	a805                	j	800075ea <exec+0x464>
      goto bad;
    800075bc:	0001                	nop
    800075be:	a035                	j	800075ea <exec+0x464>
      goto bad;
    800075c0:	0001                	nop
    800075c2:	a025                	j	800075ea <exec+0x464>
      goto bad;
    800075c4:	0001                	nop
    800075c6:	a015                	j	800075ea <exec+0x464>
      goto bad;
    800075c8:	0001                	nop
    800075ca:	a005                	j	800075ea <exec+0x464>
      goto bad;
    800075cc:	0001                	nop
    800075ce:	a831                	j	800075ea <exec+0x464>
      goto bad;
    800075d0:	0001                	nop
    800075d2:	a821                	j	800075ea <exec+0x464>
    goto bad;
    800075d4:	0001                	nop
    800075d6:	a811                	j	800075ea <exec+0x464>
      goto bad;
    800075d8:	0001                	nop
    800075da:	a801                	j	800075ea <exec+0x464>
      goto bad;
    800075dc:	0001                	nop
    800075de:	a031                	j	800075ea <exec+0x464>
      goto bad;
    800075e0:	0001                	nop
    800075e2:	a021                	j	800075ea <exec+0x464>
    goto bad;
    800075e4:	0001                	nop
    800075e6:	a011                	j	800075ea <exec+0x464>
    goto bad;
    800075e8:	0001                	nop

 bad:
  if(pagetable)
    800075ea:	fa043783          	ld	a5,-96(s0)
    800075ee:	cb89                	beqz	a5,80007600 <exec+0x47a>
    proc_freepagetable(pagetable, sz);
    800075f0:	fb843583          	ld	a1,-72(s0)
    800075f4:	fa043503          	ld	a0,-96(s0)
    800075f8:	ffffb097          	auipc	ra,0xffffb
    800075fc:	5e6080e7          	jalr	1510(ra) # 80002bde <proc_freepagetable>
  if(ip){
    80007600:	fa843783          	ld	a5,-88(s0)
    80007604:	cb99                	beqz	a5,8000761a <exec+0x494>
    iunlockput(ip);
    80007606:	fa843503          	ld	a0,-88(s0)
    8000760a:	ffffe097          	auipc	ra,0xffffe
    8000760e:	d00080e7          	jalr	-768(ra) # 8000530a <iunlockput>
    end_op();
    80007612:	fffff097          	auipc	ra,0xfffff
    80007616:	bce080e7          	jalr	-1074(ra) # 800061e0 <end_op>
  }
  return -1;
    8000761a:	57fd                	li	a5,-1
}
    8000761c:	853e                	mv	a0,a5
    8000761e:	21813083          	ld	ra,536(sp)
    80007622:	21013403          	ld	s0,528(sp)
    80007626:	20813483          	ld	s1,520(sp)
    8000762a:	22010113          	addi	sp,sp,544
    8000762e:	8082                	ret

0000000080007630 <loadseg>:
// va must be page-aligned
// and the pages from va to va+sz must already be mapped.
// Returns 0 on success, -1 on failure.
static int
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
    80007630:	7139                	addi	sp,sp,-64
    80007632:	fc06                	sd	ra,56(sp)
    80007634:	f822                	sd	s0,48(sp)
    80007636:	0080                	addi	s0,sp,64
    80007638:	fca43c23          	sd	a0,-40(s0)
    8000763c:	fcb43823          	sd	a1,-48(s0)
    80007640:	fcc43423          	sd	a2,-56(s0)
    80007644:	87b6                	mv	a5,a3
    80007646:	fcf42223          	sw	a5,-60(s0)
    8000764a:	87ba                	mv	a5,a4
    8000764c:	fcf42023          	sw	a5,-64(s0)
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80007650:	fe042623          	sw	zero,-20(s0)
    80007654:	a075                	j	80007700 <loadseg+0xd0>
    pa = walkaddr(pagetable, va + i);
    80007656:	fec46703          	lwu	a4,-20(s0)
    8000765a:	fd043783          	ld	a5,-48(s0)
    8000765e:	97ba                	add	a5,a5,a4
    80007660:	85be                	mv	a1,a5
    80007662:	fd843503          	ld	a0,-40(s0)
    80007666:	ffffa097          	auipc	ra,0xffffa
    8000766a:	5b4080e7          	jalr	1460(ra) # 80001c1a <walkaddr>
    8000766e:	fea43023          	sd	a0,-32(s0)
    if(pa == 0)
    80007672:	fe043783          	ld	a5,-32(s0)
    80007676:	eb89                	bnez	a5,80007688 <loadseg+0x58>
      panic("loadseg: address should exist");
    80007678:	00004517          	auipc	a0,0x4
    8000767c:	f7050513          	addi	a0,a0,-144 # 8000b5e8 <etext+0x5e8>
    80007680:	ffff9097          	auipc	ra,0xffff9
    80007684:	640080e7          	jalr	1600(ra) # 80000cc0 <panic>
    if(sz - i < PGSIZE)
    80007688:	fc042783          	lw	a5,-64(s0)
    8000768c:	873e                	mv	a4,a5
    8000768e:	fec42783          	lw	a5,-20(s0)
    80007692:	40f707bb          	subw	a5,a4,a5
    80007696:	0007871b          	sext.w	a4,a5
    8000769a:	6785                	lui	a5,0x1
    8000769c:	00f77c63          	bgeu	a4,a5,800076b4 <loadseg+0x84>
      n = sz - i;
    800076a0:	fc042783          	lw	a5,-64(s0)
    800076a4:	873e                	mv	a4,a5
    800076a6:	fec42783          	lw	a5,-20(s0)
    800076aa:	40f707bb          	subw	a5,a4,a5
    800076ae:	fef42423          	sw	a5,-24(s0)
    800076b2:	a021                	j	800076ba <loadseg+0x8a>
    else
      n = PGSIZE;
    800076b4:	6785                	lui	a5,0x1
    800076b6:	fef42423          	sw	a5,-24(s0)
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800076ba:	fc442783          	lw	a5,-60(s0)
    800076be:	873e                	mv	a4,a5
    800076c0:	fec42783          	lw	a5,-20(s0)
    800076c4:	9fb9                	addw	a5,a5,a4
    800076c6:	2781                	sext.w	a5,a5
    800076c8:	fe842703          	lw	a4,-24(s0)
    800076cc:	86be                	mv	a3,a5
    800076ce:	fe043603          	ld	a2,-32(s0)
    800076d2:	4581                	li	a1,0
    800076d4:	fc843503          	ld	a0,-56(s0)
    800076d8:	ffffe097          	auipc	ra,0xffffe
    800076dc:	f84080e7          	jalr	-124(ra) # 8000565c <readi>
    800076e0:	87aa                	mv	a5,a0
    800076e2:	873e                	mv	a4,a5
    800076e4:	fe842783          	lw	a5,-24(s0)
    800076e8:	2781                	sext.w	a5,a5
    800076ea:	00e78463          	beq	a5,a4,800076f2 <loadseg+0xc2>
      return -1;
    800076ee:	57fd                	li	a5,-1
    800076f0:	a015                	j	80007714 <loadseg+0xe4>
  for(i = 0; i < sz; i += PGSIZE){
    800076f2:	fec42783          	lw	a5,-20(s0)
    800076f6:	873e                	mv	a4,a5
    800076f8:	6785                	lui	a5,0x1
    800076fa:	9fb9                	addw	a5,a5,a4
    800076fc:	fef42623          	sw	a5,-20(s0)
    80007700:	fec42783          	lw	a5,-20(s0)
    80007704:	873e                	mv	a4,a5
    80007706:	fc042783          	lw	a5,-64(s0)
    8000770a:	2701                	sext.w	a4,a4
    8000770c:	2781                	sext.w	a5,a5
    8000770e:	f4f764e3          	bltu	a4,a5,80007656 <loadseg+0x26>
  }
  
  return 0;
    80007712:	4781                	li	a5,0
}
    80007714:	853e                	mv	a0,a5
    80007716:	70e2                	ld	ra,56(sp)
    80007718:	7442                	ld	s0,48(sp)
    8000771a:	6121                	addi	sp,sp,64
    8000771c:	8082                	ret

000000008000771e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000771e:	7139                	addi	sp,sp,-64
    80007720:	fc06                	sd	ra,56(sp)
    80007722:	f822                	sd	s0,48(sp)
    80007724:	0080                	addi	s0,sp,64
    80007726:	87aa                	mv	a5,a0
    80007728:	fcb43823          	sd	a1,-48(s0)
    8000772c:	fcc43423          	sd	a2,-56(s0)
    80007730:	fcf42e23          	sw	a5,-36(s0)
  int fd;
  struct file *f;

  argint(n, &fd);
    80007734:	fe440713          	addi	a4,s0,-28
    80007738:	fdc42783          	lw	a5,-36(s0)
    8000773c:	85ba                	mv	a1,a4
    8000773e:	853e                	mv	a0,a5
    80007740:	ffffd097          	auipc	ra,0xffffd
    80007744:	9f6080e7          	jalr	-1546(ra) # 80004136 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80007748:	fe442783          	lw	a5,-28(s0)
    8000774c:	0207c763          	bltz	a5,8000777a <argfd+0x5c>
    80007750:	fe442703          	lw	a4,-28(s0)
    80007754:	47bd                	li	a5,15
    80007756:	02e7c263          	blt	a5,a4,8000777a <argfd+0x5c>
    8000775a:	ffffb097          	auipc	ra,0xffffb
    8000775e:	162080e7          	jalr	354(ra) # 800028bc <myproc>
    80007762:	872a                	mv	a4,a0
    80007764:	fe442783          	lw	a5,-28(s0)
    80007768:	07e9                	addi	a5,a5,26 # 101a <_entry-0x7fffefe6>
    8000776a:	078e                	slli	a5,a5,0x3
    8000776c:	97ba                	add	a5,a5,a4
    8000776e:	639c                	ld	a5,0(a5)
    80007770:	fef43423          	sd	a5,-24(s0)
    80007774:	fe843783          	ld	a5,-24(s0)
    80007778:	e399                	bnez	a5,8000777e <argfd+0x60>
    return -1;
    8000777a:	57fd                	li	a5,-1
    8000777c:	a015                	j	800077a0 <argfd+0x82>
  if(pfd)
    8000777e:	fd043783          	ld	a5,-48(s0)
    80007782:	c791                	beqz	a5,8000778e <argfd+0x70>
    *pfd = fd;
    80007784:	fe442703          	lw	a4,-28(s0)
    80007788:	fd043783          	ld	a5,-48(s0)
    8000778c:	c398                	sw	a4,0(a5)
  if(pf)
    8000778e:	fc843783          	ld	a5,-56(s0)
    80007792:	c791                	beqz	a5,8000779e <argfd+0x80>
    *pf = f;
    80007794:	fc843783          	ld	a5,-56(s0)
    80007798:	fe843703          	ld	a4,-24(s0)
    8000779c:	e398                	sd	a4,0(a5)
  return 0;
    8000779e:	4781                	li	a5,0
}
    800077a0:	853e                	mv	a0,a5
    800077a2:	70e2                	ld	ra,56(sp)
    800077a4:	7442                	ld	s0,48(sp)
    800077a6:	6121                	addi	sp,sp,64
    800077a8:	8082                	ret

00000000800077aa <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800077aa:	7179                	addi	sp,sp,-48
    800077ac:	f406                	sd	ra,40(sp)
    800077ae:	f022                	sd	s0,32(sp)
    800077b0:	1800                	addi	s0,sp,48
    800077b2:	fca43c23          	sd	a0,-40(s0)
  int fd;
  struct proc *p = myproc();
    800077b6:	ffffb097          	auipc	ra,0xffffb
    800077ba:	106080e7          	jalr	262(ra) # 800028bc <myproc>
    800077be:	fea43023          	sd	a0,-32(s0)

  for(fd = 0; fd < NOFILE; fd++){
    800077c2:	fe042623          	sw	zero,-20(s0)
    800077c6:	a825                	j	800077fe <fdalloc+0x54>
    if(p->ofile[fd] == 0){
    800077c8:	fe043703          	ld	a4,-32(s0)
    800077cc:	fec42783          	lw	a5,-20(s0)
    800077d0:	07e9                	addi	a5,a5,26
    800077d2:	078e                	slli	a5,a5,0x3
    800077d4:	97ba                	add	a5,a5,a4
    800077d6:	639c                	ld	a5,0(a5)
    800077d8:	ef91                	bnez	a5,800077f4 <fdalloc+0x4a>
      p->ofile[fd] = f;
    800077da:	fe043703          	ld	a4,-32(s0)
    800077de:	fec42783          	lw	a5,-20(s0)
    800077e2:	07e9                	addi	a5,a5,26
    800077e4:	078e                	slli	a5,a5,0x3
    800077e6:	97ba                	add	a5,a5,a4
    800077e8:	fd843703          	ld	a4,-40(s0)
    800077ec:	e398                	sd	a4,0(a5)
      return fd;
    800077ee:	fec42783          	lw	a5,-20(s0)
    800077f2:	a831                	j	8000780e <fdalloc+0x64>
  for(fd = 0; fd < NOFILE; fd++){
    800077f4:	fec42783          	lw	a5,-20(s0)
    800077f8:	2785                	addiw	a5,a5,1
    800077fa:	fef42623          	sw	a5,-20(s0)
    800077fe:	fec42783          	lw	a5,-20(s0)
    80007802:	0007871b          	sext.w	a4,a5
    80007806:	47bd                	li	a5,15
    80007808:	fce7d0e3          	bge	a5,a4,800077c8 <fdalloc+0x1e>
    }
  }
  return -1;
    8000780c:	57fd                	li	a5,-1
}
    8000780e:	853e                	mv	a0,a5
    80007810:	70a2                	ld	ra,40(sp)
    80007812:	7402                	ld	s0,32(sp)
    80007814:	6145                	addi	sp,sp,48
    80007816:	8082                	ret

0000000080007818 <sys_dup>:

uint64
sys_dup(void)
{
    80007818:	1101                	addi	sp,sp,-32
    8000781a:	ec06                	sd	ra,24(sp)
    8000781c:	e822                	sd	s0,16(sp)
    8000781e:	1000                	addi	s0,sp,32
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    80007820:	fe040793          	addi	a5,s0,-32
    80007824:	863e                	mv	a2,a5
    80007826:	4581                	li	a1,0
    80007828:	4501                	li	a0,0
    8000782a:	00000097          	auipc	ra,0x0
    8000782e:	ef4080e7          	jalr	-268(ra) # 8000771e <argfd>
    80007832:	87aa                	mv	a5,a0
    80007834:	0007d463          	bgez	a5,8000783c <sys_dup+0x24>
    return -1;
    80007838:	57fd                	li	a5,-1
    8000783a:	a81d                	j	80007870 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
    8000783c:	fe043783          	ld	a5,-32(s0)
    80007840:	853e                	mv	a0,a5
    80007842:	00000097          	auipc	ra,0x0
    80007846:	f68080e7          	jalr	-152(ra) # 800077aa <fdalloc>
    8000784a:	87aa                	mv	a5,a0
    8000784c:	fef42623          	sw	a5,-20(s0)
    80007850:	fec42783          	lw	a5,-20(s0)
    80007854:	2781                	sext.w	a5,a5
    80007856:	0007d463          	bgez	a5,8000785e <sys_dup+0x46>
    return -1;
    8000785a:	57fd                	li	a5,-1
    8000785c:	a811                	j	80007870 <sys_dup+0x58>
  filedup(f);
    8000785e:	fe043783          	ld	a5,-32(s0)
    80007862:	853e                	mv	a0,a5
    80007864:	fffff097          	auipc	ra,0xfffff
    80007868:	ede080e7          	jalr	-290(ra) # 80006742 <filedup>
  return fd;
    8000786c:	fec42783          	lw	a5,-20(s0)
}
    80007870:	853e                	mv	a0,a5
    80007872:	60e2                	ld	ra,24(sp)
    80007874:	6442                	ld	s0,16(sp)
    80007876:	6105                	addi	sp,sp,32
    80007878:	8082                	ret

000000008000787a <sys_read>:

uint64
sys_read(void)
{
    8000787a:	7179                	addi	sp,sp,-48
    8000787c:	f406                	sd	ra,40(sp)
    8000787e:	f022                	sd	s0,32(sp)
    80007880:	1800                	addi	s0,sp,48
  struct file *f;
  int n;
  uint64 p;

  argaddr(1, &p);
    80007882:	fd840793          	addi	a5,s0,-40
    80007886:	85be                	mv	a1,a5
    80007888:	4505                	li	a0,1
    8000788a:	ffffd097          	auipc	ra,0xffffd
    8000788e:	8e2080e7          	jalr	-1822(ra) # 8000416c <argaddr>
  argint(2, &n);
    80007892:	fe440793          	addi	a5,s0,-28
    80007896:	85be                	mv	a1,a5
    80007898:	4509                	li	a0,2
    8000789a:	ffffd097          	auipc	ra,0xffffd
    8000789e:	89c080e7          	jalr	-1892(ra) # 80004136 <argint>
  if(argfd(0, 0, &f) < 0)
    800078a2:	fe840793          	addi	a5,s0,-24
    800078a6:	863e                	mv	a2,a5
    800078a8:	4581                	li	a1,0
    800078aa:	4501                	li	a0,0
    800078ac:	00000097          	auipc	ra,0x0
    800078b0:	e72080e7          	jalr	-398(ra) # 8000771e <argfd>
    800078b4:	87aa                	mv	a5,a0
    800078b6:	0007d463          	bgez	a5,800078be <sys_read+0x44>
    return -1;
    800078ba:	57fd                	li	a5,-1
    800078bc:	a839                	j	800078da <sys_read+0x60>
  return fileread(f, p, n);
    800078be:	fe843783          	ld	a5,-24(s0)
    800078c2:	fd843703          	ld	a4,-40(s0)
    800078c6:	fe442683          	lw	a3,-28(s0)
    800078ca:	8636                	mv	a2,a3
    800078cc:	85ba                	mv	a1,a4
    800078ce:	853e                	mv	a0,a5
    800078d0:	fffff097          	auipc	ra,0xfffff
    800078d4:	07a080e7          	jalr	122(ra) # 8000694a <fileread>
    800078d8:	87aa                	mv	a5,a0
}
    800078da:	853e                	mv	a0,a5
    800078dc:	70a2                	ld	ra,40(sp)
    800078de:	7402                	ld	s0,32(sp)
    800078e0:	6145                	addi	sp,sp,48
    800078e2:	8082                	ret

00000000800078e4 <sys_write>:

uint64
sys_write(void)
{
    800078e4:	7179                	addi	sp,sp,-48
    800078e6:	f406                	sd	ra,40(sp)
    800078e8:	f022                	sd	s0,32(sp)
    800078ea:	1800                	addi	s0,sp,48
  struct file *f;
  int n;
  uint64 p;
  
  argaddr(1, &p);
    800078ec:	fd840793          	addi	a5,s0,-40
    800078f0:	85be                	mv	a1,a5
    800078f2:	4505                	li	a0,1
    800078f4:	ffffd097          	auipc	ra,0xffffd
    800078f8:	878080e7          	jalr	-1928(ra) # 8000416c <argaddr>
  argint(2, &n);
    800078fc:	fe440793          	addi	a5,s0,-28
    80007900:	85be                	mv	a1,a5
    80007902:	4509                	li	a0,2
    80007904:	ffffd097          	auipc	ra,0xffffd
    80007908:	832080e7          	jalr	-1998(ra) # 80004136 <argint>
  if(argfd(0, 0, &f) < 0)
    8000790c:	fe840793          	addi	a5,s0,-24
    80007910:	863e                	mv	a2,a5
    80007912:	4581                	li	a1,0
    80007914:	4501                	li	a0,0
    80007916:	00000097          	auipc	ra,0x0
    8000791a:	e08080e7          	jalr	-504(ra) # 8000771e <argfd>
    8000791e:	87aa                	mv	a5,a0
    80007920:	0007d463          	bgez	a5,80007928 <sys_write+0x44>
    return -1;
    80007924:	57fd                	li	a5,-1
    80007926:	a839                	j	80007944 <sys_write+0x60>

  return filewrite(f, p, n);
    80007928:	fe843783          	ld	a5,-24(s0)
    8000792c:	fd843703          	ld	a4,-40(s0)
    80007930:	fe442683          	lw	a3,-28(s0)
    80007934:	8636                	mv	a2,a3
    80007936:	85ba                	mv	a1,a4
    80007938:	853e                	mv	a0,a5
    8000793a:	fffff097          	auipc	ra,0xfffff
    8000793e:	166080e7          	jalr	358(ra) # 80006aa0 <filewrite>
    80007942:	87aa                	mv	a5,a0
}
    80007944:	853e                	mv	a0,a5
    80007946:	70a2                	ld	ra,40(sp)
    80007948:	7402                	ld	s0,32(sp)
    8000794a:	6145                	addi	sp,sp,48
    8000794c:	8082                	ret

000000008000794e <sys_close>:

uint64
sys_close(void)
{
    8000794e:	1101                	addi	sp,sp,-32
    80007950:	ec06                	sd	ra,24(sp)
    80007952:	e822                	sd	s0,16(sp)
    80007954:	1000                	addi	s0,sp,32
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    80007956:	fe040713          	addi	a4,s0,-32
    8000795a:	fec40793          	addi	a5,s0,-20
    8000795e:	863a                	mv	a2,a4
    80007960:	85be                	mv	a1,a5
    80007962:	4501                	li	a0,0
    80007964:	00000097          	auipc	ra,0x0
    80007968:	dba080e7          	jalr	-582(ra) # 8000771e <argfd>
    8000796c:	87aa                	mv	a5,a0
    8000796e:	0007d463          	bgez	a5,80007976 <sys_close+0x28>
    return -1;
    80007972:	57fd                	li	a5,-1
    80007974:	a02d                	j	8000799e <sys_close+0x50>
  myproc()->ofile[fd] = 0;
    80007976:	ffffb097          	auipc	ra,0xffffb
    8000797a:	f46080e7          	jalr	-186(ra) # 800028bc <myproc>
    8000797e:	872a                	mv	a4,a0
    80007980:	fec42783          	lw	a5,-20(s0)
    80007984:	07e9                	addi	a5,a5,26
    80007986:	078e                	slli	a5,a5,0x3
    80007988:	97ba                	add	a5,a5,a4
    8000798a:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    8000798e:	fe043783          	ld	a5,-32(s0)
    80007992:	853e                	mv	a0,a5
    80007994:	fffff097          	auipc	ra,0xfffff
    80007998:	e14080e7          	jalr	-492(ra) # 800067a8 <fileclose>
  return 0;
    8000799c:	4781                	li	a5,0
}
    8000799e:	853e                	mv	a0,a5
    800079a0:	60e2                	ld	ra,24(sp)
    800079a2:	6442                	ld	s0,16(sp)
    800079a4:	6105                	addi	sp,sp,32
    800079a6:	8082                	ret

00000000800079a8 <sys_fstat>:

uint64
sys_fstat(void)
{
    800079a8:	1101                	addi	sp,sp,-32
    800079aa:	ec06                	sd	ra,24(sp)
    800079ac:	e822                	sd	s0,16(sp)
    800079ae:	1000                	addi	s0,sp,32
  struct file *f;
  uint64 st; // user pointer to struct stat

  argaddr(1, &st);
    800079b0:	fe040793          	addi	a5,s0,-32
    800079b4:	85be                	mv	a1,a5
    800079b6:	4505                	li	a0,1
    800079b8:	ffffc097          	auipc	ra,0xffffc
    800079bc:	7b4080e7          	jalr	1972(ra) # 8000416c <argaddr>
  if(argfd(0, 0, &f) < 0)
    800079c0:	fe840793          	addi	a5,s0,-24
    800079c4:	863e                	mv	a2,a5
    800079c6:	4581                	li	a1,0
    800079c8:	4501                	li	a0,0
    800079ca:	00000097          	auipc	ra,0x0
    800079ce:	d54080e7          	jalr	-684(ra) # 8000771e <argfd>
    800079d2:	87aa                	mv	a5,a0
    800079d4:	0007d463          	bgez	a5,800079dc <sys_fstat+0x34>
    return -1;
    800079d8:	57fd                	li	a5,-1
    800079da:	a821                	j	800079f2 <sys_fstat+0x4a>
  return filestat(f, st);
    800079dc:	fe843783          	ld	a5,-24(s0)
    800079e0:	fe043703          	ld	a4,-32(s0)
    800079e4:	85ba                	mv	a1,a4
    800079e6:	853e                	mv	a0,a5
    800079e8:	fffff097          	auipc	ra,0xfffff
    800079ec:	ec2080e7          	jalr	-318(ra) # 800068aa <filestat>
    800079f0:	87aa                	mv	a5,a0
}
    800079f2:	853e                	mv	a0,a5
    800079f4:	60e2                	ld	ra,24(sp)
    800079f6:	6442                	ld	s0,16(sp)
    800079f8:	6105                	addi	sp,sp,32
    800079fa:	8082                	ret

00000000800079fc <sys_link>:

// Create the path new as a link to the same inode as old.
uint64
sys_link(void)
{
    800079fc:	7169                	addi	sp,sp,-304
    800079fe:	f606                	sd	ra,296(sp)
    80007a00:	f222                	sd	s0,288(sp)
    80007a02:	1a00                	addi	s0,sp,304
  char name[DIRSIZ], new[MAXPATH], old[MAXPATH];
  struct inode *dp, *ip;

  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80007a04:	ed040793          	addi	a5,s0,-304
    80007a08:	08000613          	li	a2,128
    80007a0c:	85be                	mv	a1,a5
    80007a0e:	4501                	li	a0,0
    80007a10:	ffffc097          	auipc	ra,0xffffc
    80007a14:	78e080e7          	jalr	1934(ra) # 8000419e <argstr>
    80007a18:	87aa                	mv	a5,a0
    80007a1a:	0007cf63          	bltz	a5,80007a38 <sys_link+0x3c>
    80007a1e:	f5040793          	addi	a5,s0,-176
    80007a22:	08000613          	li	a2,128
    80007a26:	85be                	mv	a1,a5
    80007a28:	4505                	li	a0,1
    80007a2a:	ffffc097          	auipc	ra,0xffffc
    80007a2e:	774080e7          	jalr	1908(ra) # 8000419e <argstr>
    80007a32:	87aa                	mv	a5,a0
    80007a34:	0007d463          	bgez	a5,80007a3c <sys_link+0x40>
    return -1;
    80007a38:	57fd                	li	a5,-1
    80007a3a:	aaa5                	j	80007bb2 <sys_link+0x1b6>

  begin_op();
    80007a3c:	ffffe097          	auipc	ra,0xffffe
    80007a40:	6e2080e7          	jalr	1762(ra) # 8000611e <begin_op>
  if((ip = namei(old)) == 0){
    80007a44:	ed040793          	addi	a5,s0,-304
    80007a48:	853e                	mv	a0,a5
    80007a4a:	ffffe097          	auipc	ra,0xffffe
    80007a4e:	384080e7          	jalr	900(ra) # 80005dce <namei>
    80007a52:	fea43423          	sd	a0,-24(s0)
    80007a56:	fe843783          	ld	a5,-24(s0)
    80007a5a:	e799                	bnez	a5,80007a68 <sys_link+0x6c>
    end_op();
    80007a5c:	ffffe097          	auipc	ra,0xffffe
    80007a60:	784080e7          	jalr	1924(ra) # 800061e0 <end_op>
    return -1;
    80007a64:	57fd                	li	a5,-1
    80007a66:	a2b1                	j	80007bb2 <sys_link+0x1b6>
  }

  ilock(ip);
    80007a68:	fe843503          	ld	a0,-24(s0)
    80007a6c:	ffffd097          	auipc	ra,0xffffd
    80007a70:	642080e7          	jalr	1602(ra) # 800050ae <ilock>
  if(ip->type == T_DIR){
    80007a74:	fe843783          	ld	a5,-24(s0)
    80007a78:	04479703          	lh	a4,68(a5)
    80007a7c:	4785                	li	a5,1
    80007a7e:	00f71e63          	bne	a4,a5,80007a9a <sys_link+0x9e>
    iunlockput(ip);
    80007a82:	fe843503          	ld	a0,-24(s0)
    80007a86:	ffffe097          	auipc	ra,0xffffe
    80007a8a:	884080e7          	jalr	-1916(ra) # 8000530a <iunlockput>
    end_op();
    80007a8e:	ffffe097          	auipc	ra,0xffffe
    80007a92:	752080e7          	jalr	1874(ra) # 800061e0 <end_op>
    return -1;
    80007a96:	57fd                	li	a5,-1
    80007a98:	aa29                	j	80007bb2 <sys_link+0x1b6>
  }

  ip->nlink++;
    80007a9a:	fe843783          	ld	a5,-24(s0)
    80007a9e:	04a79783          	lh	a5,74(a5)
    80007aa2:	17c2                	slli	a5,a5,0x30
    80007aa4:	93c1                	srli	a5,a5,0x30
    80007aa6:	2785                	addiw	a5,a5,1
    80007aa8:	17c2                	slli	a5,a5,0x30
    80007aaa:	93c1                	srli	a5,a5,0x30
    80007aac:	0107971b          	slliw	a4,a5,0x10
    80007ab0:	4107571b          	sraiw	a4,a4,0x10
    80007ab4:	fe843783          	ld	a5,-24(s0)
    80007ab8:	04e79523          	sh	a4,74(a5)
  iupdate(ip);
    80007abc:	fe843503          	ld	a0,-24(s0)
    80007ac0:	ffffd097          	auipc	ra,0xffffd
    80007ac4:	39e080e7          	jalr	926(ra) # 80004e5e <iupdate>
  iunlock(ip);
    80007ac8:	fe843503          	ld	a0,-24(s0)
    80007acc:	ffffd097          	auipc	ra,0xffffd
    80007ad0:	716080e7          	jalr	1814(ra) # 800051e2 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
    80007ad4:	fd040713          	addi	a4,s0,-48
    80007ad8:	f5040793          	addi	a5,s0,-176
    80007adc:	85ba                	mv	a1,a4
    80007ade:	853e                	mv	a0,a5
    80007ae0:	ffffe097          	auipc	ra,0xffffe
    80007ae4:	31a080e7          	jalr	794(ra) # 80005dfa <nameiparent>
    80007ae8:	fea43023          	sd	a0,-32(s0)
    80007aec:	fe043783          	ld	a5,-32(s0)
    80007af0:	cba5                	beqz	a5,80007b60 <sys_link+0x164>
    goto bad;
  ilock(dp);
    80007af2:	fe043503          	ld	a0,-32(s0)
    80007af6:	ffffd097          	auipc	ra,0xffffd
    80007afa:	5b8080e7          	jalr	1464(ra) # 800050ae <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80007afe:	fe043783          	ld	a5,-32(s0)
    80007b02:	4398                	lw	a4,0(a5)
    80007b04:	fe843783          	ld	a5,-24(s0)
    80007b08:	439c                	lw	a5,0(a5)
    80007b0a:	02f71263          	bne	a4,a5,80007b2e <sys_link+0x132>
    80007b0e:	fe843783          	ld	a5,-24(s0)
    80007b12:	43d8                	lw	a4,4(a5)
    80007b14:	fd040793          	addi	a5,s0,-48
    80007b18:	863a                	mv	a2,a4
    80007b1a:	85be                	mv	a1,a5
    80007b1c:	fe043503          	ld	a0,-32(s0)
    80007b20:	ffffe097          	auipc	ra,0xffffe
    80007b24:	fa4080e7          	jalr	-92(ra) # 80005ac4 <dirlink>
    80007b28:	87aa                	mv	a5,a0
    80007b2a:	0007d963          	bgez	a5,80007b3c <sys_link+0x140>
    iunlockput(dp);
    80007b2e:	fe043503          	ld	a0,-32(s0)
    80007b32:	ffffd097          	auipc	ra,0xffffd
    80007b36:	7d8080e7          	jalr	2008(ra) # 8000530a <iunlockput>
    goto bad;
    80007b3a:	a025                	j	80007b62 <sys_link+0x166>
  }
  iunlockput(dp);
    80007b3c:	fe043503          	ld	a0,-32(s0)
    80007b40:	ffffd097          	auipc	ra,0xffffd
    80007b44:	7ca080e7          	jalr	1994(ra) # 8000530a <iunlockput>
  iput(ip);
    80007b48:	fe843503          	ld	a0,-24(s0)
    80007b4c:	ffffd097          	auipc	ra,0xffffd
    80007b50:	6f0080e7          	jalr	1776(ra) # 8000523c <iput>

  end_op();
    80007b54:	ffffe097          	auipc	ra,0xffffe
    80007b58:	68c080e7          	jalr	1676(ra) # 800061e0 <end_op>

  return 0;
    80007b5c:	4781                	li	a5,0
    80007b5e:	a891                	j	80007bb2 <sys_link+0x1b6>
    goto bad;
    80007b60:	0001                	nop

bad:
  ilock(ip);
    80007b62:	fe843503          	ld	a0,-24(s0)
    80007b66:	ffffd097          	auipc	ra,0xffffd
    80007b6a:	548080e7          	jalr	1352(ra) # 800050ae <ilock>
  ip->nlink--;
    80007b6e:	fe843783          	ld	a5,-24(s0)
    80007b72:	04a79783          	lh	a5,74(a5)
    80007b76:	17c2                	slli	a5,a5,0x30
    80007b78:	93c1                	srli	a5,a5,0x30
    80007b7a:	37fd                	addiw	a5,a5,-1
    80007b7c:	17c2                	slli	a5,a5,0x30
    80007b7e:	93c1                	srli	a5,a5,0x30
    80007b80:	0107971b          	slliw	a4,a5,0x10
    80007b84:	4107571b          	sraiw	a4,a4,0x10
    80007b88:	fe843783          	ld	a5,-24(s0)
    80007b8c:	04e79523          	sh	a4,74(a5)
  iupdate(ip);
    80007b90:	fe843503          	ld	a0,-24(s0)
    80007b94:	ffffd097          	auipc	ra,0xffffd
    80007b98:	2ca080e7          	jalr	714(ra) # 80004e5e <iupdate>
  iunlockput(ip);
    80007b9c:	fe843503          	ld	a0,-24(s0)
    80007ba0:	ffffd097          	auipc	ra,0xffffd
    80007ba4:	76a080e7          	jalr	1898(ra) # 8000530a <iunlockput>
  end_op();
    80007ba8:	ffffe097          	auipc	ra,0xffffe
    80007bac:	638080e7          	jalr	1592(ra) # 800061e0 <end_op>
  return -1;
    80007bb0:	57fd                	li	a5,-1
}
    80007bb2:	853e                	mv	a0,a5
    80007bb4:	70b2                	ld	ra,296(sp)
    80007bb6:	7412                	ld	s0,288(sp)
    80007bb8:	6155                	addi	sp,sp,304
    80007bba:	8082                	ret

0000000080007bbc <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
    80007bbc:	7139                	addi	sp,sp,-64
    80007bbe:	fc06                	sd	ra,56(sp)
    80007bc0:	f822                	sd	s0,48(sp)
    80007bc2:	0080                	addi	s0,sp,64
    80007bc4:	fca43423          	sd	a0,-56(s0)
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80007bc8:	02000793          	li	a5,32
    80007bcc:	fef42623          	sw	a5,-20(s0)
    80007bd0:	a0b1                	j	80007c1c <isdirempty+0x60>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80007bd2:	fd840793          	addi	a5,s0,-40
    80007bd6:	fec42683          	lw	a3,-20(s0)
    80007bda:	4741                	li	a4,16
    80007bdc:	863e                	mv	a2,a5
    80007bde:	4581                	li	a1,0
    80007be0:	fc843503          	ld	a0,-56(s0)
    80007be4:	ffffe097          	auipc	ra,0xffffe
    80007be8:	a78080e7          	jalr	-1416(ra) # 8000565c <readi>
    80007bec:	87aa                	mv	a5,a0
    80007bee:	873e                	mv	a4,a5
    80007bf0:	47c1                	li	a5,16
    80007bf2:	00f70a63          	beq	a4,a5,80007c06 <isdirempty+0x4a>
      panic("isdirempty: readi");
    80007bf6:	00004517          	auipc	a0,0x4
    80007bfa:	a1250513          	addi	a0,a0,-1518 # 8000b608 <etext+0x608>
    80007bfe:	ffff9097          	auipc	ra,0xffff9
    80007c02:	0c2080e7          	jalr	194(ra) # 80000cc0 <panic>
    if(de.inum != 0)
    80007c06:	fd845783          	lhu	a5,-40(s0)
    80007c0a:	c399                	beqz	a5,80007c10 <isdirempty+0x54>
      return 0;
    80007c0c:	4781                	li	a5,0
    80007c0e:	a839                	j	80007c2c <isdirempty+0x70>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80007c10:	fec42783          	lw	a5,-20(s0)
    80007c14:	27c1                	addiw	a5,a5,16
    80007c16:	2781                	sext.w	a5,a5
    80007c18:	fef42623          	sw	a5,-20(s0)
    80007c1c:	fc843783          	ld	a5,-56(s0)
    80007c20:	47f8                	lw	a4,76(a5)
    80007c22:	fec42783          	lw	a5,-20(s0)
    80007c26:	fae7e6e3          	bltu	a5,a4,80007bd2 <isdirempty+0x16>
  }
  return 1;
    80007c2a:	4785                	li	a5,1
}
    80007c2c:	853e                	mv	a0,a5
    80007c2e:	70e2                	ld	ra,56(sp)
    80007c30:	7442                	ld	s0,48(sp)
    80007c32:	6121                	addi	sp,sp,64
    80007c34:	8082                	ret

0000000080007c36 <sys_unlink>:

uint64
sys_unlink(void)
{
    80007c36:	7155                	addi	sp,sp,-208
    80007c38:	e586                	sd	ra,200(sp)
    80007c3a:	e1a2                	sd	s0,192(sp)
    80007c3c:	0980                	addi	s0,sp,208
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], path[MAXPATH];
  uint off;

  if(argstr(0, path, MAXPATH) < 0)
    80007c3e:	f4040793          	addi	a5,s0,-192
    80007c42:	08000613          	li	a2,128
    80007c46:	85be                	mv	a1,a5
    80007c48:	4501                	li	a0,0
    80007c4a:	ffffc097          	auipc	ra,0xffffc
    80007c4e:	554080e7          	jalr	1364(ra) # 8000419e <argstr>
    80007c52:	87aa                	mv	a5,a0
    80007c54:	0007d463          	bgez	a5,80007c5c <sys_unlink+0x26>
    return -1;
    80007c58:	57fd                	li	a5,-1
    80007c5a:	a2c5                	j	80007e3a <sys_unlink+0x204>

  begin_op();
    80007c5c:	ffffe097          	auipc	ra,0xffffe
    80007c60:	4c2080e7          	jalr	1218(ra) # 8000611e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80007c64:	fc040713          	addi	a4,s0,-64
    80007c68:	f4040793          	addi	a5,s0,-192
    80007c6c:	85ba                	mv	a1,a4
    80007c6e:	853e                	mv	a0,a5
    80007c70:	ffffe097          	auipc	ra,0xffffe
    80007c74:	18a080e7          	jalr	394(ra) # 80005dfa <nameiparent>
    80007c78:	fea43423          	sd	a0,-24(s0)
    80007c7c:	fe843783          	ld	a5,-24(s0)
    80007c80:	e799                	bnez	a5,80007c8e <sys_unlink+0x58>
    end_op();
    80007c82:	ffffe097          	auipc	ra,0xffffe
    80007c86:	55e080e7          	jalr	1374(ra) # 800061e0 <end_op>
    return -1;
    80007c8a:	57fd                	li	a5,-1
    80007c8c:	a27d                	j	80007e3a <sys_unlink+0x204>
  }

  ilock(dp);
    80007c8e:	fe843503          	ld	a0,-24(s0)
    80007c92:	ffffd097          	auipc	ra,0xffffd
    80007c96:	41c080e7          	jalr	1052(ra) # 800050ae <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80007c9a:	fc040793          	addi	a5,s0,-64
    80007c9e:	00004597          	auipc	a1,0x4
    80007ca2:	98258593          	addi	a1,a1,-1662 # 8000b620 <etext+0x620>
    80007ca6:	853e                	mv	a0,a5
    80007ca8:	ffffe097          	auipc	ra,0xffffe
    80007cac:	d0a080e7          	jalr	-758(ra) # 800059b2 <namecmp>
    80007cb0:	87aa                	mv	a5,a0
    80007cb2:	16078663          	beqz	a5,80007e1e <sys_unlink+0x1e8>
    80007cb6:	fc040793          	addi	a5,s0,-64
    80007cba:	00004597          	auipc	a1,0x4
    80007cbe:	96e58593          	addi	a1,a1,-1682 # 8000b628 <etext+0x628>
    80007cc2:	853e                	mv	a0,a5
    80007cc4:	ffffe097          	auipc	ra,0xffffe
    80007cc8:	cee080e7          	jalr	-786(ra) # 800059b2 <namecmp>
    80007ccc:	87aa                	mv	a5,a0
    80007cce:	14078863          	beqz	a5,80007e1e <sys_unlink+0x1e8>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    80007cd2:	f3c40713          	addi	a4,s0,-196
    80007cd6:	fc040793          	addi	a5,s0,-64
    80007cda:	863a                	mv	a2,a4
    80007cdc:	85be                	mv	a1,a5
    80007cde:	fe843503          	ld	a0,-24(s0)
    80007ce2:	ffffe097          	auipc	ra,0xffffe
    80007ce6:	cfe080e7          	jalr	-770(ra) # 800059e0 <dirlookup>
    80007cea:	fea43023          	sd	a0,-32(s0)
    80007cee:	fe043783          	ld	a5,-32(s0)
    80007cf2:	12078863          	beqz	a5,80007e22 <sys_unlink+0x1ec>
    goto bad;
  ilock(ip);
    80007cf6:	fe043503          	ld	a0,-32(s0)
    80007cfa:	ffffd097          	auipc	ra,0xffffd
    80007cfe:	3b4080e7          	jalr	948(ra) # 800050ae <ilock>

  if(ip->nlink < 1)
    80007d02:	fe043783          	ld	a5,-32(s0)
    80007d06:	04a79783          	lh	a5,74(a5)
    80007d0a:	00f04a63          	bgtz	a5,80007d1e <sys_unlink+0xe8>
    panic("unlink: nlink < 1");
    80007d0e:	00004517          	auipc	a0,0x4
    80007d12:	92250513          	addi	a0,a0,-1758 # 8000b630 <etext+0x630>
    80007d16:	ffff9097          	auipc	ra,0xffff9
    80007d1a:	faa080e7          	jalr	-86(ra) # 80000cc0 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80007d1e:	fe043783          	ld	a5,-32(s0)
    80007d22:	04479703          	lh	a4,68(a5)
    80007d26:	4785                	li	a5,1
    80007d28:	02f71163          	bne	a4,a5,80007d4a <sys_unlink+0x114>
    80007d2c:	fe043503          	ld	a0,-32(s0)
    80007d30:	00000097          	auipc	ra,0x0
    80007d34:	e8c080e7          	jalr	-372(ra) # 80007bbc <isdirempty>
    80007d38:	87aa                	mv	a5,a0
    80007d3a:	eb81                	bnez	a5,80007d4a <sys_unlink+0x114>
    iunlockput(ip);
    80007d3c:	fe043503          	ld	a0,-32(s0)
    80007d40:	ffffd097          	auipc	ra,0xffffd
    80007d44:	5ca080e7          	jalr	1482(ra) # 8000530a <iunlockput>
    goto bad;
    80007d48:	a8f1                	j	80007e24 <sys_unlink+0x1ee>
  }

  memset(&de, 0, sizeof(de));
    80007d4a:	fd040793          	addi	a5,s0,-48
    80007d4e:	4641                	li	a2,16
    80007d50:	4581                	li	a1,0
    80007d52:	853e                	mv	a0,a5
    80007d54:	ffff9097          	auipc	ra,0xffff9
    80007d58:	744080e7          	jalr	1860(ra) # 80001498 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80007d5c:	fd040793          	addi	a5,s0,-48
    80007d60:	f3c42683          	lw	a3,-196(s0)
    80007d64:	4741                	li	a4,16
    80007d66:	863e                	mv	a2,a5
    80007d68:	4581                	li	a1,0
    80007d6a:	fe843503          	ld	a0,-24(s0)
    80007d6e:	ffffe097          	auipc	ra,0xffffe
    80007d72:	a8a080e7          	jalr	-1398(ra) # 800057f8 <writei>
    80007d76:	87aa                	mv	a5,a0
    80007d78:	873e                	mv	a4,a5
    80007d7a:	47c1                	li	a5,16
    80007d7c:	00f70a63          	beq	a4,a5,80007d90 <sys_unlink+0x15a>
    panic("unlink: writei");
    80007d80:	00004517          	auipc	a0,0x4
    80007d84:	8c850513          	addi	a0,a0,-1848 # 8000b648 <etext+0x648>
    80007d88:	ffff9097          	auipc	ra,0xffff9
    80007d8c:	f38080e7          	jalr	-200(ra) # 80000cc0 <panic>
  if(ip->type == T_DIR){
    80007d90:	fe043783          	ld	a5,-32(s0)
    80007d94:	04479703          	lh	a4,68(a5)
    80007d98:	4785                	li	a5,1
    80007d9a:	02f71963          	bne	a4,a5,80007dcc <sys_unlink+0x196>
    dp->nlink--;
    80007d9e:	fe843783          	ld	a5,-24(s0)
    80007da2:	04a79783          	lh	a5,74(a5)
    80007da6:	17c2                	slli	a5,a5,0x30
    80007da8:	93c1                	srli	a5,a5,0x30
    80007daa:	37fd                	addiw	a5,a5,-1
    80007dac:	17c2                	slli	a5,a5,0x30
    80007dae:	93c1                	srli	a5,a5,0x30
    80007db0:	0107971b          	slliw	a4,a5,0x10
    80007db4:	4107571b          	sraiw	a4,a4,0x10
    80007db8:	fe843783          	ld	a5,-24(s0)
    80007dbc:	04e79523          	sh	a4,74(a5)
    iupdate(dp);
    80007dc0:	fe843503          	ld	a0,-24(s0)
    80007dc4:	ffffd097          	auipc	ra,0xffffd
    80007dc8:	09a080e7          	jalr	154(ra) # 80004e5e <iupdate>
  }
  iunlockput(dp);
    80007dcc:	fe843503          	ld	a0,-24(s0)
    80007dd0:	ffffd097          	auipc	ra,0xffffd
    80007dd4:	53a080e7          	jalr	1338(ra) # 8000530a <iunlockput>

  ip->nlink--;
    80007dd8:	fe043783          	ld	a5,-32(s0)
    80007ddc:	04a79783          	lh	a5,74(a5)
    80007de0:	17c2                	slli	a5,a5,0x30
    80007de2:	93c1                	srli	a5,a5,0x30
    80007de4:	37fd                	addiw	a5,a5,-1
    80007de6:	17c2                	slli	a5,a5,0x30
    80007de8:	93c1                	srli	a5,a5,0x30
    80007dea:	0107971b          	slliw	a4,a5,0x10
    80007dee:	4107571b          	sraiw	a4,a4,0x10
    80007df2:	fe043783          	ld	a5,-32(s0)
    80007df6:	04e79523          	sh	a4,74(a5)
  iupdate(ip);
    80007dfa:	fe043503          	ld	a0,-32(s0)
    80007dfe:	ffffd097          	auipc	ra,0xffffd
    80007e02:	060080e7          	jalr	96(ra) # 80004e5e <iupdate>
  iunlockput(ip);
    80007e06:	fe043503          	ld	a0,-32(s0)
    80007e0a:	ffffd097          	auipc	ra,0xffffd
    80007e0e:	500080e7          	jalr	1280(ra) # 8000530a <iunlockput>

  end_op();
    80007e12:	ffffe097          	auipc	ra,0xffffe
    80007e16:	3ce080e7          	jalr	974(ra) # 800061e0 <end_op>

  return 0;
    80007e1a:	4781                	li	a5,0
    80007e1c:	a839                	j	80007e3a <sys_unlink+0x204>
    goto bad;
    80007e1e:	0001                	nop
    80007e20:	a011                	j	80007e24 <sys_unlink+0x1ee>
    goto bad;
    80007e22:	0001                	nop

bad:
  iunlockput(dp);
    80007e24:	fe843503          	ld	a0,-24(s0)
    80007e28:	ffffd097          	auipc	ra,0xffffd
    80007e2c:	4e2080e7          	jalr	1250(ra) # 8000530a <iunlockput>
  end_op();
    80007e30:	ffffe097          	auipc	ra,0xffffe
    80007e34:	3b0080e7          	jalr	944(ra) # 800061e0 <end_op>
  return -1;
    80007e38:	57fd                	li	a5,-1
}
    80007e3a:	853e                	mv	a0,a5
    80007e3c:	60ae                	ld	ra,200(sp)
    80007e3e:	640e                	ld	s0,192(sp)
    80007e40:	6169                	addi	sp,sp,208
    80007e42:	8082                	ret

0000000080007e44 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
    80007e44:	7139                	addi	sp,sp,-64
    80007e46:	fc06                	sd	ra,56(sp)
    80007e48:	f822                	sd	s0,48(sp)
    80007e4a:	0080                	addi	s0,sp,64
    80007e4c:	fca43423          	sd	a0,-56(s0)
    80007e50:	87ae                	mv	a5,a1
    80007e52:	8736                	mv	a4,a3
    80007e54:	fcf41323          	sh	a5,-58(s0)
    80007e58:	87b2                	mv	a5,a2
    80007e5a:	fcf41223          	sh	a5,-60(s0)
    80007e5e:	87ba                	mv	a5,a4
    80007e60:	fcf41123          	sh	a5,-62(s0)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80007e64:	fd040793          	addi	a5,s0,-48
    80007e68:	85be                	mv	a1,a5
    80007e6a:	fc843503          	ld	a0,-56(s0)
    80007e6e:	ffffe097          	auipc	ra,0xffffe
    80007e72:	f8c080e7          	jalr	-116(ra) # 80005dfa <nameiparent>
    80007e76:	fea43423          	sd	a0,-24(s0)
    80007e7a:	fe843783          	ld	a5,-24(s0)
    80007e7e:	e399                	bnez	a5,80007e84 <create+0x40>
    return 0;
    80007e80:	4781                	li	a5,0
    80007e82:	a2cd                	j	80008064 <create+0x220>

  ilock(dp);
    80007e84:	fe843503          	ld	a0,-24(s0)
    80007e88:	ffffd097          	auipc	ra,0xffffd
    80007e8c:	226080e7          	jalr	550(ra) # 800050ae <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80007e90:	fd040793          	addi	a5,s0,-48
    80007e94:	4601                	li	a2,0
    80007e96:	85be                	mv	a1,a5
    80007e98:	fe843503          	ld	a0,-24(s0)
    80007e9c:	ffffe097          	auipc	ra,0xffffe
    80007ea0:	b44080e7          	jalr	-1212(ra) # 800059e0 <dirlookup>
    80007ea4:	fea43023          	sd	a0,-32(s0)
    80007ea8:	fe043783          	ld	a5,-32(s0)
    80007eac:	cfa9                	beqz	a5,80007f06 <create+0xc2>
    iunlockput(dp);
    80007eae:	fe843503          	ld	a0,-24(s0)
    80007eb2:	ffffd097          	auipc	ra,0xffffd
    80007eb6:	458080e7          	jalr	1112(ra) # 8000530a <iunlockput>
    ilock(ip);
    80007eba:	fe043503          	ld	a0,-32(s0)
    80007ebe:	ffffd097          	auipc	ra,0xffffd
    80007ec2:	1f0080e7          	jalr	496(ra) # 800050ae <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80007ec6:	fc641783          	lh	a5,-58(s0)
    80007eca:	0007871b          	sext.w	a4,a5
    80007ece:	4789                	li	a5,2
    80007ed0:	02f71363          	bne	a4,a5,80007ef6 <create+0xb2>
    80007ed4:	fe043783          	ld	a5,-32(s0)
    80007ed8:	04479703          	lh	a4,68(a5)
    80007edc:	4789                	li	a5,2
    80007ede:	00f70963          	beq	a4,a5,80007ef0 <create+0xac>
    80007ee2:	fe043783          	ld	a5,-32(s0)
    80007ee6:	04479703          	lh	a4,68(a5)
    80007eea:	478d                	li	a5,3
    80007eec:	00f71563          	bne	a4,a5,80007ef6 <create+0xb2>
      return ip;
    80007ef0:	fe043783          	ld	a5,-32(s0)
    80007ef4:	aa85                	j	80008064 <create+0x220>
    iunlockput(ip);
    80007ef6:	fe043503          	ld	a0,-32(s0)
    80007efa:	ffffd097          	auipc	ra,0xffffd
    80007efe:	410080e7          	jalr	1040(ra) # 8000530a <iunlockput>
    return 0;
    80007f02:	4781                	li	a5,0
    80007f04:	a285                	j	80008064 <create+0x220>
  }

  if((ip = ialloc(dp->dev, type)) == 0){
    80007f06:	fe843783          	ld	a5,-24(s0)
    80007f0a:	439c                	lw	a5,0(a5)
    80007f0c:	fc641703          	lh	a4,-58(s0)
    80007f10:	85ba                	mv	a1,a4
    80007f12:	853e                	mv	a0,a5
    80007f14:	ffffd097          	auipc	ra,0xffffd
    80007f18:	e4c080e7          	jalr	-436(ra) # 80004d60 <ialloc>
    80007f1c:	fea43023          	sd	a0,-32(s0)
    80007f20:	fe043783          	ld	a5,-32(s0)
    80007f24:	eb89                	bnez	a5,80007f36 <create+0xf2>
    iunlockput(dp);
    80007f26:	fe843503          	ld	a0,-24(s0)
    80007f2a:	ffffd097          	auipc	ra,0xffffd
    80007f2e:	3e0080e7          	jalr	992(ra) # 8000530a <iunlockput>
    return 0;
    80007f32:	4781                	li	a5,0
    80007f34:	aa05                	j	80008064 <create+0x220>
  }

  ilock(ip);
    80007f36:	fe043503          	ld	a0,-32(s0)
    80007f3a:	ffffd097          	auipc	ra,0xffffd
    80007f3e:	174080e7          	jalr	372(ra) # 800050ae <ilock>
  ip->major = major;
    80007f42:	fe043783          	ld	a5,-32(s0)
    80007f46:	fc445703          	lhu	a4,-60(s0)
    80007f4a:	04e79323          	sh	a4,70(a5)
  ip->minor = minor;
    80007f4e:	fe043783          	ld	a5,-32(s0)
    80007f52:	fc245703          	lhu	a4,-62(s0)
    80007f56:	04e79423          	sh	a4,72(a5)
  ip->nlink = 1;
    80007f5a:	fe043783          	ld	a5,-32(s0)
    80007f5e:	4705                	li	a4,1
    80007f60:	04e79523          	sh	a4,74(a5)
  iupdate(ip);
    80007f64:	fe043503          	ld	a0,-32(s0)
    80007f68:	ffffd097          	auipc	ra,0xffffd
    80007f6c:	ef6080e7          	jalr	-266(ra) # 80004e5e <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
    80007f70:	fc641783          	lh	a5,-58(s0)
    80007f74:	0007871b          	sext.w	a4,a5
    80007f78:	4785                	li	a5,1
    80007f7a:	04f71463          	bne	a4,a5,80007fc2 <create+0x17e>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80007f7e:	fe043783          	ld	a5,-32(s0)
    80007f82:	43dc                	lw	a5,4(a5)
    80007f84:	863e                	mv	a2,a5
    80007f86:	00003597          	auipc	a1,0x3
    80007f8a:	69a58593          	addi	a1,a1,1690 # 8000b620 <etext+0x620>
    80007f8e:	fe043503          	ld	a0,-32(s0)
    80007f92:	ffffe097          	auipc	ra,0xffffe
    80007f96:	b32080e7          	jalr	-1230(ra) # 80005ac4 <dirlink>
    80007f9a:	87aa                	mv	a5,a0
    80007f9c:	0807ca63          	bltz	a5,80008030 <create+0x1ec>
    80007fa0:	fe843783          	ld	a5,-24(s0)
    80007fa4:	43dc                	lw	a5,4(a5)
    80007fa6:	863e                	mv	a2,a5
    80007fa8:	00003597          	auipc	a1,0x3
    80007fac:	68058593          	addi	a1,a1,1664 # 8000b628 <etext+0x628>
    80007fb0:	fe043503          	ld	a0,-32(s0)
    80007fb4:	ffffe097          	auipc	ra,0xffffe
    80007fb8:	b10080e7          	jalr	-1264(ra) # 80005ac4 <dirlink>
    80007fbc:	87aa                	mv	a5,a0
    80007fbe:	0607c963          	bltz	a5,80008030 <create+0x1ec>
      goto fail;
  }

  if(dirlink(dp, name, ip->inum) < 0)
    80007fc2:	fe043783          	ld	a5,-32(s0)
    80007fc6:	43d8                	lw	a4,4(a5)
    80007fc8:	fd040793          	addi	a5,s0,-48
    80007fcc:	863a                	mv	a2,a4
    80007fce:	85be                	mv	a1,a5
    80007fd0:	fe843503          	ld	a0,-24(s0)
    80007fd4:	ffffe097          	auipc	ra,0xffffe
    80007fd8:	af0080e7          	jalr	-1296(ra) # 80005ac4 <dirlink>
    80007fdc:	87aa                	mv	a5,a0
    80007fde:	0407cb63          	bltz	a5,80008034 <create+0x1f0>
    goto fail;

  if(type == T_DIR){
    80007fe2:	fc641783          	lh	a5,-58(s0)
    80007fe6:	0007871b          	sext.w	a4,a5
    80007fea:	4785                	li	a5,1
    80007fec:	02f71963          	bne	a4,a5,8000801e <create+0x1da>
    // now that success is guaranteed:
    dp->nlink++;  // for ".."
    80007ff0:	fe843783          	ld	a5,-24(s0)
    80007ff4:	04a79783          	lh	a5,74(a5)
    80007ff8:	17c2                	slli	a5,a5,0x30
    80007ffa:	93c1                	srli	a5,a5,0x30
    80007ffc:	2785                	addiw	a5,a5,1
    80007ffe:	17c2                	slli	a5,a5,0x30
    80008000:	93c1                	srli	a5,a5,0x30
    80008002:	0107971b          	slliw	a4,a5,0x10
    80008006:	4107571b          	sraiw	a4,a4,0x10
    8000800a:	fe843783          	ld	a5,-24(s0)
    8000800e:	04e79523          	sh	a4,74(a5)
    iupdate(dp);
    80008012:	fe843503          	ld	a0,-24(s0)
    80008016:	ffffd097          	auipc	ra,0xffffd
    8000801a:	e48080e7          	jalr	-440(ra) # 80004e5e <iupdate>
  }

  iunlockput(dp);
    8000801e:	fe843503          	ld	a0,-24(s0)
    80008022:	ffffd097          	auipc	ra,0xffffd
    80008026:	2e8080e7          	jalr	744(ra) # 8000530a <iunlockput>

  return ip;
    8000802a:	fe043783          	ld	a5,-32(s0)
    8000802e:	a81d                	j	80008064 <create+0x220>
      goto fail;
    80008030:	0001                	nop
    80008032:	a011                	j	80008036 <create+0x1f2>
    goto fail;
    80008034:	0001                	nop

 fail:
  // something went wrong. de-allocate ip.
  ip->nlink = 0;
    80008036:	fe043783          	ld	a5,-32(s0)
    8000803a:	04079523          	sh	zero,74(a5)
  iupdate(ip);
    8000803e:	fe043503          	ld	a0,-32(s0)
    80008042:	ffffd097          	auipc	ra,0xffffd
    80008046:	e1c080e7          	jalr	-484(ra) # 80004e5e <iupdate>
  iunlockput(ip);
    8000804a:	fe043503          	ld	a0,-32(s0)
    8000804e:	ffffd097          	auipc	ra,0xffffd
    80008052:	2bc080e7          	jalr	700(ra) # 8000530a <iunlockput>
  iunlockput(dp);
    80008056:	fe843503          	ld	a0,-24(s0)
    8000805a:	ffffd097          	auipc	ra,0xffffd
    8000805e:	2b0080e7          	jalr	688(ra) # 8000530a <iunlockput>
  return 0;
    80008062:	4781                	li	a5,0
}
    80008064:	853e                	mv	a0,a5
    80008066:	70e2                	ld	ra,56(sp)
    80008068:	7442                	ld	s0,48(sp)
    8000806a:	6121                	addi	sp,sp,64
    8000806c:	8082                	ret

000000008000806e <sys_open>:

uint64
sys_open(void)
{
    8000806e:	7131                	addi	sp,sp,-192
    80008070:	fd06                	sd	ra,184(sp)
    80008072:	f922                	sd	s0,176(sp)
    80008074:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80008076:	f4c40793          	addi	a5,s0,-180
    8000807a:	85be                	mv	a1,a5
    8000807c:	4505                	li	a0,1
    8000807e:	ffffc097          	auipc	ra,0xffffc
    80008082:	0b8080e7          	jalr	184(ra) # 80004136 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80008086:	f5040793          	addi	a5,s0,-176
    8000808a:	08000613          	li	a2,128
    8000808e:	85be                	mv	a1,a5
    80008090:	4501                	li	a0,0
    80008092:	ffffc097          	auipc	ra,0xffffc
    80008096:	10c080e7          	jalr	268(ra) # 8000419e <argstr>
    8000809a:	87aa                	mv	a5,a0
    8000809c:	fef42223          	sw	a5,-28(s0)
    800080a0:	fe442783          	lw	a5,-28(s0)
    800080a4:	2781                	sext.w	a5,a5
    800080a6:	0007d463          	bgez	a5,800080ae <sys_open+0x40>
    return -1;
    800080aa:	57fd                	li	a5,-1
    800080ac:	aad5                	j	800082a0 <sys_open+0x232>

  begin_op();
    800080ae:	ffffe097          	auipc	ra,0xffffe
    800080b2:	070080e7          	jalr	112(ra) # 8000611e <begin_op>

  if(omode & O_CREATE){
    800080b6:	f4c42783          	lw	a5,-180(s0)
    800080ba:	2007f793          	andi	a5,a5,512
    800080be:	2781                	sext.w	a5,a5
    800080c0:	c795                	beqz	a5,800080ec <sys_open+0x7e>
    ip = create(path, T_FILE, 0, 0);
    800080c2:	f5040793          	addi	a5,s0,-176
    800080c6:	4681                	li	a3,0
    800080c8:	4601                	li	a2,0
    800080ca:	4589                	li	a1,2
    800080cc:	853e                	mv	a0,a5
    800080ce:	00000097          	auipc	ra,0x0
    800080d2:	d76080e7          	jalr	-650(ra) # 80007e44 <create>
    800080d6:	fea43423          	sd	a0,-24(s0)
    if(ip == 0){
    800080da:	fe843783          	ld	a5,-24(s0)
    800080de:	e7ad                	bnez	a5,80008148 <sys_open+0xda>
      end_op();
    800080e0:	ffffe097          	auipc	ra,0xffffe
    800080e4:	100080e7          	jalr	256(ra) # 800061e0 <end_op>
      return -1;
    800080e8:	57fd                	li	a5,-1
    800080ea:	aa5d                	j	800082a0 <sys_open+0x232>
    }
  } else {
    if((ip = namei(path)) == 0){
    800080ec:	f5040793          	addi	a5,s0,-176
    800080f0:	853e                	mv	a0,a5
    800080f2:	ffffe097          	auipc	ra,0xffffe
    800080f6:	cdc080e7          	jalr	-804(ra) # 80005dce <namei>
    800080fa:	fea43423          	sd	a0,-24(s0)
    800080fe:	fe843783          	ld	a5,-24(s0)
    80008102:	e799                	bnez	a5,80008110 <sys_open+0xa2>
      end_op();
    80008104:	ffffe097          	auipc	ra,0xffffe
    80008108:	0dc080e7          	jalr	220(ra) # 800061e0 <end_op>
      return -1;
    8000810c:	57fd                	li	a5,-1
    8000810e:	aa49                	j	800082a0 <sys_open+0x232>
    }
    ilock(ip);
    80008110:	fe843503          	ld	a0,-24(s0)
    80008114:	ffffd097          	auipc	ra,0xffffd
    80008118:	f9a080e7          	jalr	-102(ra) # 800050ae <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    8000811c:	fe843783          	ld	a5,-24(s0)
    80008120:	04479703          	lh	a4,68(a5)
    80008124:	4785                	li	a5,1
    80008126:	02f71163          	bne	a4,a5,80008148 <sys_open+0xda>
    8000812a:	f4c42783          	lw	a5,-180(s0)
    8000812e:	cf89                	beqz	a5,80008148 <sys_open+0xda>
      iunlockput(ip);
    80008130:	fe843503          	ld	a0,-24(s0)
    80008134:	ffffd097          	auipc	ra,0xffffd
    80008138:	1d6080e7          	jalr	470(ra) # 8000530a <iunlockput>
      end_op();
    8000813c:	ffffe097          	auipc	ra,0xffffe
    80008140:	0a4080e7          	jalr	164(ra) # 800061e0 <end_op>
      return -1;
    80008144:	57fd                	li	a5,-1
    80008146:	aaa9                	j	800082a0 <sys_open+0x232>
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80008148:	fe843783          	ld	a5,-24(s0)
    8000814c:	04479703          	lh	a4,68(a5)
    80008150:	478d                	li	a5,3
    80008152:	02f71b63          	bne	a4,a5,80008188 <sys_open+0x11a>
    80008156:	fe843783          	ld	a5,-24(s0)
    8000815a:	04679783          	lh	a5,70(a5)
    8000815e:	0007c963          	bltz	a5,80008170 <sys_open+0x102>
    80008162:	fe843783          	ld	a5,-24(s0)
    80008166:	04679703          	lh	a4,70(a5)
    8000816a:	47a5                	li	a5,9
    8000816c:	00e7de63          	bge	a5,a4,80008188 <sys_open+0x11a>
    iunlockput(ip);
    80008170:	fe843503          	ld	a0,-24(s0)
    80008174:	ffffd097          	auipc	ra,0xffffd
    80008178:	196080e7          	jalr	406(ra) # 8000530a <iunlockput>
    end_op();
    8000817c:	ffffe097          	auipc	ra,0xffffe
    80008180:	064080e7          	jalr	100(ra) # 800061e0 <end_op>
    return -1;
    80008184:	57fd                	li	a5,-1
    80008186:	aa29                	j	800082a0 <sys_open+0x232>
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80008188:	ffffe097          	auipc	ra,0xffffe
    8000818c:	536080e7          	jalr	1334(ra) # 800066be <filealloc>
    80008190:	fca43c23          	sd	a0,-40(s0)
    80008194:	fd843783          	ld	a5,-40(s0)
    80008198:	cf99                	beqz	a5,800081b6 <sys_open+0x148>
    8000819a:	fd843503          	ld	a0,-40(s0)
    8000819e:	fffff097          	auipc	ra,0xfffff
    800081a2:	60c080e7          	jalr	1548(ra) # 800077aa <fdalloc>
    800081a6:	87aa                	mv	a5,a0
    800081a8:	fcf42a23          	sw	a5,-44(s0)
    800081ac:	fd442783          	lw	a5,-44(s0)
    800081b0:	2781                	sext.w	a5,a5
    800081b2:	0207d763          	bgez	a5,800081e0 <sys_open+0x172>
    if(f)
    800081b6:	fd843783          	ld	a5,-40(s0)
    800081ba:	c799                	beqz	a5,800081c8 <sys_open+0x15a>
      fileclose(f);
    800081bc:	fd843503          	ld	a0,-40(s0)
    800081c0:	ffffe097          	auipc	ra,0xffffe
    800081c4:	5e8080e7          	jalr	1512(ra) # 800067a8 <fileclose>
    iunlockput(ip);
    800081c8:	fe843503          	ld	a0,-24(s0)
    800081cc:	ffffd097          	auipc	ra,0xffffd
    800081d0:	13e080e7          	jalr	318(ra) # 8000530a <iunlockput>
    end_op();
    800081d4:	ffffe097          	auipc	ra,0xffffe
    800081d8:	00c080e7          	jalr	12(ra) # 800061e0 <end_op>
    return -1;
    800081dc:	57fd                	li	a5,-1
    800081de:	a0c9                	j	800082a0 <sys_open+0x232>
  }

  if(ip->type == T_DEVICE){
    800081e0:	fe843783          	ld	a5,-24(s0)
    800081e4:	04479703          	lh	a4,68(a5)
    800081e8:	478d                	li	a5,3
    800081ea:	00f71f63          	bne	a4,a5,80008208 <sys_open+0x19a>
    f->type = FD_DEVICE;
    800081ee:	fd843783          	ld	a5,-40(s0)
    800081f2:	470d                	li	a4,3
    800081f4:	c398                	sw	a4,0(a5)
    f->major = ip->major;
    800081f6:	fe843783          	ld	a5,-24(s0)
    800081fa:	04679703          	lh	a4,70(a5)
    800081fe:	fd843783          	ld	a5,-40(s0)
    80008202:	02e79223          	sh	a4,36(a5)
    80008206:	a809                	j	80008218 <sys_open+0x1aa>
  } else {
    f->type = FD_INODE;
    80008208:	fd843783          	ld	a5,-40(s0)
    8000820c:	4709                	li	a4,2
    8000820e:	c398                	sw	a4,0(a5)
    f->off = 0;
    80008210:	fd843783          	ld	a5,-40(s0)
    80008214:	0207a023          	sw	zero,32(a5)
  }
  f->ip = ip;
    80008218:	fd843783          	ld	a5,-40(s0)
    8000821c:	fe843703          	ld	a4,-24(s0)
    80008220:	ef98                	sd	a4,24(a5)
  f->readable = !(omode & O_WRONLY);
    80008222:	f4c42783          	lw	a5,-180(s0)
    80008226:	8b85                	andi	a5,a5,1
    80008228:	2781                	sext.w	a5,a5
    8000822a:	0017b793          	seqz	a5,a5
    8000822e:	0ff7f793          	zext.b	a5,a5
    80008232:	873e                	mv	a4,a5
    80008234:	fd843783          	ld	a5,-40(s0)
    80008238:	00e78423          	sb	a4,8(a5)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000823c:	f4c42783          	lw	a5,-180(s0)
    80008240:	8b85                	andi	a5,a5,1
    80008242:	2781                	sext.w	a5,a5
    80008244:	e791                	bnez	a5,80008250 <sys_open+0x1e2>
    80008246:	f4c42783          	lw	a5,-180(s0)
    8000824a:	8b89                	andi	a5,a5,2
    8000824c:	2781                	sext.w	a5,a5
    8000824e:	c399                	beqz	a5,80008254 <sys_open+0x1e6>
    80008250:	4785                	li	a5,1
    80008252:	a011                	j	80008256 <sys_open+0x1e8>
    80008254:	4781                	li	a5,0
    80008256:	0ff7f713          	zext.b	a4,a5
    8000825a:	fd843783          	ld	a5,-40(s0)
    8000825e:	00e784a3          	sb	a4,9(a5)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80008262:	f4c42783          	lw	a5,-180(s0)
    80008266:	4007f793          	andi	a5,a5,1024
    8000826a:	2781                	sext.w	a5,a5
    8000826c:	cf91                	beqz	a5,80008288 <sys_open+0x21a>
    8000826e:	fe843783          	ld	a5,-24(s0)
    80008272:	04479703          	lh	a4,68(a5)
    80008276:	4789                	li	a5,2
    80008278:	00f71863          	bne	a4,a5,80008288 <sys_open+0x21a>
    itrunc(ip);
    8000827c:	fe843503          	ld	a0,-24(s0)
    80008280:	ffffd097          	auipc	ra,0xffffd
    80008284:	234080e7          	jalr	564(ra) # 800054b4 <itrunc>
  }

  iunlock(ip);
    80008288:	fe843503          	ld	a0,-24(s0)
    8000828c:	ffffd097          	auipc	ra,0xffffd
    80008290:	f56080e7          	jalr	-170(ra) # 800051e2 <iunlock>
  end_op();
    80008294:	ffffe097          	auipc	ra,0xffffe
    80008298:	f4c080e7          	jalr	-180(ra) # 800061e0 <end_op>

  return fd;
    8000829c:	fd442783          	lw	a5,-44(s0)
}
    800082a0:	853e                	mv	a0,a5
    800082a2:	70ea                	ld	ra,184(sp)
    800082a4:	744a                	ld	s0,176(sp)
    800082a6:	6129                	addi	sp,sp,192
    800082a8:	8082                	ret

00000000800082aa <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800082aa:	7135                	addi	sp,sp,-160
    800082ac:	ed06                	sd	ra,152(sp)
    800082ae:	e922                	sd	s0,144(sp)
    800082b0:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800082b2:	ffffe097          	auipc	ra,0xffffe
    800082b6:	e6c080e7          	jalr	-404(ra) # 8000611e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800082ba:	f6840793          	addi	a5,s0,-152
    800082be:	08000613          	li	a2,128
    800082c2:	85be                	mv	a1,a5
    800082c4:	4501                	li	a0,0
    800082c6:	ffffc097          	auipc	ra,0xffffc
    800082ca:	ed8080e7          	jalr	-296(ra) # 8000419e <argstr>
    800082ce:	87aa                	mv	a5,a0
    800082d0:	0207c163          	bltz	a5,800082f2 <sys_mkdir+0x48>
    800082d4:	f6840793          	addi	a5,s0,-152
    800082d8:	4681                	li	a3,0
    800082da:	4601                	li	a2,0
    800082dc:	4585                	li	a1,1
    800082de:	853e                	mv	a0,a5
    800082e0:	00000097          	auipc	ra,0x0
    800082e4:	b64080e7          	jalr	-1180(ra) # 80007e44 <create>
    800082e8:	fea43423          	sd	a0,-24(s0)
    800082ec:	fe843783          	ld	a5,-24(s0)
    800082f0:	e799                	bnez	a5,800082fe <sys_mkdir+0x54>
    end_op();
    800082f2:	ffffe097          	auipc	ra,0xffffe
    800082f6:	eee080e7          	jalr	-274(ra) # 800061e0 <end_op>
    return -1;
    800082fa:	57fd                	li	a5,-1
    800082fc:	a821                	j	80008314 <sys_mkdir+0x6a>
  }
  iunlockput(ip);
    800082fe:	fe843503          	ld	a0,-24(s0)
    80008302:	ffffd097          	auipc	ra,0xffffd
    80008306:	008080e7          	jalr	8(ra) # 8000530a <iunlockput>
  end_op();
    8000830a:	ffffe097          	auipc	ra,0xffffe
    8000830e:	ed6080e7          	jalr	-298(ra) # 800061e0 <end_op>
  return 0;
    80008312:	4781                	li	a5,0
}
    80008314:	853e                	mv	a0,a5
    80008316:	60ea                	ld	ra,152(sp)
    80008318:	644a                	ld	s0,144(sp)
    8000831a:	610d                	addi	sp,sp,160
    8000831c:	8082                	ret

000000008000831e <sys_mknod>:

uint64
sys_mknod(void)
{
    8000831e:	7135                	addi	sp,sp,-160
    80008320:	ed06                	sd	ra,152(sp)
    80008322:	e922                	sd	s0,144(sp)
    80008324:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80008326:	ffffe097          	auipc	ra,0xffffe
    8000832a:	df8080e7          	jalr	-520(ra) # 8000611e <begin_op>
  argint(1, &major);
    8000832e:	f6440793          	addi	a5,s0,-156
    80008332:	85be                	mv	a1,a5
    80008334:	4505                	li	a0,1
    80008336:	ffffc097          	auipc	ra,0xffffc
    8000833a:	e00080e7          	jalr	-512(ra) # 80004136 <argint>
  argint(2, &minor);
    8000833e:	f6040793          	addi	a5,s0,-160
    80008342:	85be                	mv	a1,a5
    80008344:	4509                	li	a0,2
    80008346:	ffffc097          	auipc	ra,0xffffc
    8000834a:	df0080e7          	jalr	-528(ra) # 80004136 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000834e:	f6840793          	addi	a5,s0,-152
    80008352:	08000613          	li	a2,128
    80008356:	85be                	mv	a1,a5
    80008358:	4501                	li	a0,0
    8000835a:	ffffc097          	auipc	ra,0xffffc
    8000835e:	e44080e7          	jalr	-444(ra) # 8000419e <argstr>
    80008362:	87aa                	mv	a5,a0
    80008364:	0207cc63          	bltz	a5,8000839c <sys_mknod+0x7e>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80008368:	f6442783          	lw	a5,-156(s0)
    8000836c:	0107971b          	slliw	a4,a5,0x10
    80008370:	4107571b          	sraiw	a4,a4,0x10
    80008374:	f6042783          	lw	a5,-160(s0)
    80008378:	0107969b          	slliw	a3,a5,0x10
    8000837c:	4106d69b          	sraiw	a3,a3,0x10
    80008380:	f6840793          	addi	a5,s0,-152
    80008384:	863a                	mv	a2,a4
    80008386:	458d                	li	a1,3
    80008388:	853e                	mv	a0,a5
    8000838a:	00000097          	auipc	ra,0x0
    8000838e:	aba080e7          	jalr	-1350(ra) # 80007e44 <create>
    80008392:	fea43423          	sd	a0,-24(s0)
  if((argstr(0, path, MAXPATH)) < 0 ||
    80008396:	fe843783          	ld	a5,-24(s0)
    8000839a:	e799                	bnez	a5,800083a8 <sys_mknod+0x8a>
    end_op();
    8000839c:	ffffe097          	auipc	ra,0xffffe
    800083a0:	e44080e7          	jalr	-444(ra) # 800061e0 <end_op>
    return -1;
    800083a4:	57fd                	li	a5,-1
    800083a6:	a821                	j	800083be <sys_mknod+0xa0>
  }
  iunlockput(ip);
    800083a8:	fe843503          	ld	a0,-24(s0)
    800083ac:	ffffd097          	auipc	ra,0xffffd
    800083b0:	f5e080e7          	jalr	-162(ra) # 8000530a <iunlockput>
  end_op();
    800083b4:	ffffe097          	auipc	ra,0xffffe
    800083b8:	e2c080e7          	jalr	-468(ra) # 800061e0 <end_op>
  return 0;
    800083bc:	4781                	li	a5,0
}
    800083be:	853e                	mv	a0,a5
    800083c0:	60ea                	ld	ra,152(sp)
    800083c2:	644a                	ld	s0,144(sp)
    800083c4:	610d                	addi	sp,sp,160
    800083c6:	8082                	ret

00000000800083c8 <sys_chdir>:

uint64
sys_chdir(void)
{
    800083c8:	7135                	addi	sp,sp,-160
    800083ca:	ed06                	sd	ra,152(sp)
    800083cc:	e922                	sd	s0,144(sp)
    800083ce:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800083d0:	ffffa097          	auipc	ra,0xffffa
    800083d4:	4ec080e7          	jalr	1260(ra) # 800028bc <myproc>
    800083d8:	fea43423          	sd	a0,-24(s0)
  
  begin_op();
    800083dc:	ffffe097          	auipc	ra,0xffffe
    800083e0:	d42080e7          	jalr	-702(ra) # 8000611e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800083e4:	f6040793          	addi	a5,s0,-160
    800083e8:	08000613          	li	a2,128
    800083ec:	85be                	mv	a1,a5
    800083ee:	4501                	li	a0,0
    800083f0:	ffffc097          	auipc	ra,0xffffc
    800083f4:	dae080e7          	jalr	-594(ra) # 8000419e <argstr>
    800083f8:	87aa                	mv	a5,a0
    800083fa:	0007ce63          	bltz	a5,80008416 <sys_chdir+0x4e>
    800083fe:	f6040793          	addi	a5,s0,-160
    80008402:	853e                	mv	a0,a5
    80008404:	ffffe097          	auipc	ra,0xffffe
    80008408:	9ca080e7          	jalr	-1590(ra) # 80005dce <namei>
    8000840c:	fea43023          	sd	a0,-32(s0)
    80008410:	fe043783          	ld	a5,-32(s0)
    80008414:	e799                	bnez	a5,80008422 <sys_chdir+0x5a>
    end_op();
    80008416:	ffffe097          	auipc	ra,0xffffe
    8000841a:	dca080e7          	jalr	-566(ra) # 800061e0 <end_op>
    return -1;
    8000841e:	57fd                	li	a5,-1
    80008420:	a0a5                	j	80008488 <sys_chdir+0xc0>
  }
  ilock(ip);
    80008422:	fe043503          	ld	a0,-32(s0)
    80008426:	ffffd097          	auipc	ra,0xffffd
    8000842a:	c88080e7          	jalr	-888(ra) # 800050ae <ilock>
  if(ip->type != T_DIR){
    8000842e:	fe043783          	ld	a5,-32(s0)
    80008432:	04479703          	lh	a4,68(a5)
    80008436:	4785                	li	a5,1
    80008438:	00f70e63          	beq	a4,a5,80008454 <sys_chdir+0x8c>
    iunlockput(ip);
    8000843c:	fe043503          	ld	a0,-32(s0)
    80008440:	ffffd097          	auipc	ra,0xffffd
    80008444:	eca080e7          	jalr	-310(ra) # 8000530a <iunlockput>
    end_op();
    80008448:	ffffe097          	auipc	ra,0xffffe
    8000844c:	d98080e7          	jalr	-616(ra) # 800061e0 <end_op>
    return -1;
    80008450:	57fd                	li	a5,-1
    80008452:	a81d                	j	80008488 <sys_chdir+0xc0>
  }
  iunlock(ip);
    80008454:	fe043503          	ld	a0,-32(s0)
    80008458:	ffffd097          	auipc	ra,0xffffd
    8000845c:	d8a080e7          	jalr	-630(ra) # 800051e2 <iunlock>
  iput(p->cwd);
    80008460:	fe843783          	ld	a5,-24(s0)
    80008464:	1507b783          	ld	a5,336(a5)
    80008468:	853e                	mv	a0,a5
    8000846a:	ffffd097          	auipc	ra,0xffffd
    8000846e:	dd2080e7          	jalr	-558(ra) # 8000523c <iput>
  end_op();
    80008472:	ffffe097          	auipc	ra,0xffffe
    80008476:	d6e080e7          	jalr	-658(ra) # 800061e0 <end_op>
  p->cwd = ip;
    8000847a:	fe843783          	ld	a5,-24(s0)
    8000847e:	fe043703          	ld	a4,-32(s0)
    80008482:	14e7b823          	sd	a4,336(a5)
  return 0;
    80008486:	4781                	li	a5,0
}
    80008488:	853e                	mv	a0,a5
    8000848a:	60ea                	ld	ra,152(sp)
    8000848c:	644a                	ld	s0,144(sp)
    8000848e:	610d                	addi	sp,sp,160
    80008490:	8082                	ret

0000000080008492 <sys_exec>:

uint64
sys_exec(void)
{
    80008492:	7161                	addi	sp,sp,-432
    80008494:	f706                	sd	ra,424(sp)
    80008496:	f322                	sd	s0,416(sp)
    80008498:	1b00                	addi	s0,sp,432
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000849a:	e6040793          	addi	a5,s0,-416
    8000849e:	85be                	mv	a1,a5
    800084a0:	4505                	li	a0,1
    800084a2:	ffffc097          	auipc	ra,0xffffc
    800084a6:	cca080e7          	jalr	-822(ra) # 8000416c <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800084aa:	f6840793          	addi	a5,s0,-152
    800084ae:	08000613          	li	a2,128
    800084b2:	85be                	mv	a1,a5
    800084b4:	4501                	li	a0,0
    800084b6:	ffffc097          	auipc	ra,0xffffc
    800084ba:	ce8080e7          	jalr	-792(ra) # 8000419e <argstr>
    800084be:	87aa                	mv	a5,a0
    800084c0:	0007d463          	bgez	a5,800084c8 <sys_exec+0x36>
    return -1;
    800084c4:	57fd                	li	a5,-1
    800084c6:	a2bd                	j	80008634 <sys_exec+0x1a2>
  }
  memset(argv, 0, sizeof(argv));
    800084c8:	e6840793          	addi	a5,s0,-408
    800084cc:	10000613          	li	a2,256
    800084d0:	4581                	li	a1,0
    800084d2:	853e                	mv	a0,a5
    800084d4:	ffff9097          	auipc	ra,0xffff9
    800084d8:	fc4080e7          	jalr	-60(ra) # 80001498 <memset>
  for(i=0;; i++){
    800084dc:	fe042623          	sw	zero,-20(s0)
    if(i >= NELEM(argv)){
    800084e0:	fec42703          	lw	a4,-20(s0)
    800084e4:	47fd                	li	a5,31
    800084e6:	0ee7ee63          	bltu	a5,a4,800085e2 <sys_exec+0x150>
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800084ea:	fec42783          	lw	a5,-20(s0)
    800084ee:	00379713          	slli	a4,a5,0x3
    800084f2:	e6043783          	ld	a5,-416(s0)
    800084f6:	97ba                	add	a5,a5,a4
    800084f8:	e5840713          	addi	a4,s0,-424
    800084fc:	85ba                	mv	a1,a4
    800084fe:	853e                	mv	a0,a5
    80008500:	ffffc097          	auipc	ra,0xffffc
    80008504:	ac4080e7          	jalr	-1340(ra) # 80003fc4 <fetchaddr>
    80008508:	87aa                	mv	a5,a0
    8000850a:	0c07ce63          	bltz	a5,800085e6 <sys_exec+0x154>
      goto bad;
    }
    if(uarg == 0){
    8000850e:	e5843783          	ld	a5,-424(s0)
    80008512:	eb95                	bnez	a5,80008546 <sys_exec+0xb4>
      argv[i] = 0;
    80008514:	fec42703          	lw	a4,-20(s0)
    80008518:	e6840793          	addi	a5,s0,-408
    8000851c:	070e                	slli	a4,a4,0x3
    8000851e:	97ba                	add	a5,a5,a4
    80008520:	0007b023          	sd	zero,0(a5)
      break;
    80008524:	0001                	nop
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
      goto bad;
  }

  int ret = exec(path, argv);
    80008526:	e6840713          	addi	a4,s0,-408
    8000852a:	f6840793          	addi	a5,s0,-152
    8000852e:	85ba                	mv	a1,a4
    80008530:	853e                	mv	a0,a5
    80008532:	fffff097          	auipc	ra,0xfffff
    80008536:	c54080e7          	jalr	-940(ra) # 80007186 <exec>
    8000853a:	87aa                	mv	a5,a0
    8000853c:	fef42423          	sw	a5,-24(s0)

  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80008540:	fe042623          	sw	zero,-20(s0)
    80008544:	a8bd                	j	800085c2 <sys_exec+0x130>
    argv[i] = kalloc();
    80008546:	ffff9097          	auipc	ra,0xffff9
    8000854a:	c1e080e7          	jalr	-994(ra) # 80001164 <kalloc>
    8000854e:	86aa                	mv	a3,a0
    80008550:	fec42703          	lw	a4,-20(s0)
    80008554:	e6840793          	addi	a5,s0,-408
    80008558:	070e                	slli	a4,a4,0x3
    8000855a:	97ba                	add	a5,a5,a4
    8000855c:	e394                	sd	a3,0(a5)
    if(argv[i] == 0)
    8000855e:	fec42703          	lw	a4,-20(s0)
    80008562:	e6840793          	addi	a5,s0,-408
    80008566:	070e                	slli	a4,a4,0x3
    80008568:	97ba                	add	a5,a5,a4
    8000856a:	639c                	ld	a5,0(a5)
    8000856c:	cfbd                	beqz	a5,800085ea <sys_exec+0x158>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000856e:	e5843683          	ld	a3,-424(s0)
    80008572:	fec42703          	lw	a4,-20(s0)
    80008576:	e6840793          	addi	a5,s0,-408
    8000857a:	070e                	slli	a4,a4,0x3
    8000857c:	97ba                	add	a5,a5,a4
    8000857e:	639c                	ld	a5,0(a5)
    80008580:	6605                	lui	a2,0x1
    80008582:	85be                	mv	a1,a5
    80008584:	8536                	mv	a0,a3
    80008586:	ffffc097          	auipc	ra,0xffffc
    8000858a:	aac080e7          	jalr	-1364(ra) # 80004032 <fetchstr>
    8000858e:	87aa                	mv	a5,a0
    80008590:	0407cf63          	bltz	a5,800085ee <sys_exec+0x15c>
  for(i=0;; i++){
    80008594:	fec42783          	lw	a5,-20(s0)
    80008598:	2785                	addiw	a5,a5,1
    8000859a:	fef42623          	sw	a5,-20(s0)
    if(i >= NELEM(argv)){
    8000859e:	b789                	j	800084e0 <sys_exec+0x4e>
    kfree(argv[i]);
    800085a0:	fec42703          	lw	a4,-20(s0)
    800085a4:	e6840793          	addi	a5,s0,-408
    800085a8:	070e                	slli	a4,a4,0x3
    800085aa:	97ba                	add	a5,a5,a4
    800085ac:	639c                	ld	a5,0(a5)
    800085ae:	853e                	mv	a0,a5
    800085b0:	ffff9097          	auipc	ra,0xffff9
    800085b4:	b10080e7          	jalr	-1264(ra) # 800010c0 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800085b8:	fec42783          	lw	a5,-20(s0)
    800085bc:	2785                	addiw	a5,a5,1
    800085be:	fef42623          	sw	a5,-20(s0)
    800085c2:	fec42703          	lw	a4,-20(s0)
    800085c6:	47fd                	li	a5,31
    800085c8:	00e7ea63          	bltu	a5,a4,800085dc <sys_exec+0x14a>
    800085cc:	fec42703          	lw	a4,-20(s0)
    800085d0:	e6840793          	addi	a5,s0,-408
    800085d4:	070e                	slli	a4,a4,0x3
    800085d6:	97ba                	add	a5,a5,a4
    800085d8:	639c                	ld	a5,0(a5)
    800085da:	f3f9                	bnez	a5,800085a0 <sys_exec+0x10e>

  return ret;
    800085dc:	fe842783          	lw	a5,-24(s0)
    800085e0:	a891                	j	80008634 <sys_exec+0x1a2>
      goto bad;
    800085e2:	0001                	nop
    800085e4:	a031                	j	800085f0 <sys_exec+0x15e>
      goto bad;
    800085e6:	0001                	nop
    800085e8:	a021                	j	800085f0 <sys_exec+0x15e>
      goto bad;
    800085ea:	0001                	nop
    800085ec:	a011                	j	800085f0 <sys_exec+0x15e>
      goto bad;
    800085ee:	0001                	nop

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800085f0:	fe042623          	sw	zero,-20(s0)
    800085f4:	a015                	j	80008618 <sys_exec+0x186>
    kfree(argv[i]);
    800085f6:	fec42703          	lw	a4,-20(s0)
    800085fa:	e6840793          	addi	a5,s0,-408
    800085fe:	070e                	slli	a4,a4,0x3
    80008600:	97ba                	add	a5,a5,a4
    80008602:	639c                	ld	a5,0(a5)
    80008604:	853e                	mv	a0,a5
    80008606:	ffff9097          	auipc	ra,0xffff9
    8000860a:	aba080e7          	jalr	-1350(ra) # 800010c0 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000860e:	fec42783          	lw	a5,-20(s0)
    80008612:	2785                	addiw	a5,a5,1
    80008614:	fef42623          	sw	a5,-20(s0)
    80008618:	fec42703          	lw	a4,-20(s0)
    8000861c:	47fd                	li	a5,31
    8000861e:	00e7ea63          	bltu	a5,a4,80008632 <sys_exec+0x1a0>
    80008622:	fec42703          	lw	a4,-20(s0)
    80008626:	e6840793          	addi	a5,s0,-408
    8000862a:	070e                	slli	a4,a4,0x3
    8000862c:	97ba                	add	a5,a5,a4
    8000862e:	639c                	ld	a5,0(a5)
    80008630:	f3f9                	bnez	a5,800085f6 <sys_exec+0x164>
  return -1;
    80008632:	57fd                	li	a5,-1
}
    80008634:	853e                	mv	a0,a5
    80008636:	70ba                	ld	ra,424(sp)
    80008638:	741a                	ld	s0,416(sp)
    8000863a:	615d                	addi	sp,sp,432
    8000863c:	8082                	ret

000000008000863e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000863e:	7139                	addi	sp,sp,-64
    80008640:	fc06                	sd	ra,56(sp)
    80008642:	f822                	sd	s0,48(sp)
    80008644:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80008646:	ffffa097          	auipc	ra,0xffffa
    8000864a:	276080e7          	jalr	630(ra) # 800028bc <myproc>
    8000864e:	fea43423          	sd	a0,-24(s0)

  argaddr(0, &fdarray);
    80008652:	fe040793          	addi	a5,s0,-32
    80008656:	85be                	mv	a1,a5
    80008658:	4501                	li	a0,0
    8000865a:	ffffc097          	auipc	ra,0xffffc
    8000865e:	b12080e7          	jalr	-1262(ra) # 8000416c <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80008662:	fd040713          	addi	a4,s0,-48
    80008666:	fd840793          	addi	a5,s0,-40
    8000866a:	85ba                	mv	a1,a4
    8000866c:	853e                	mv	a0,a5
    8000866e:	ffffe097          	auipc	ra,0xffffe
    80008672:	632080e7          	jalr	1586(ra) # 80006ca0 <pipealloc>
    80008676:	87aa                	mv	a5,a0
    80008678:	0007d463          	bgez	a5,80008680 <sys_pipe+0x42>
    return -1;
    8000867c:	57fd                	li	a5,-1
    8000867e:	a219                	j	80008784 <sys_pipe+0x146>
  fd0 = -1;
    80008680:	57fd                	li	a5,-1
    80008682:	fcf42623          	sw	a5,-52(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80008686:	fd843783          	ld	a5,-40(s0)
    8000868a:	853e                	mv	a0,a5
    8000868c:	fffff097          	auipc	ra,0xfffff
    80008690:	11e080e7          	jalr	286(ra) # 800077aa <fdalloc>
    80008694:	87aa                	mv	a5,a0
    80008696:	fcf42623          	sw	a5,-52(s0)
    8000869a:	fcc42783          	lw	a5,-52(s0)
    8000869e:	0207c063          	bltz	a5,800086be <sys_pipe+0x80>
    800086a2:	fd043783          	ld	a5,-48(s0)
    800086a6:	853e                	mv	a0,a5
    800086a8:	fffff097          	auipc	ra,0xfffff
    800086ac:	102080e7          	jalr	258(ra) # 800077aa <fdalloc>
    800086b0:	87aa                	mv	a5,a0
    800086b2:	fcf42423          	sw	a5,-56(s0)
    800086b6:	fc842783          	lw	a5,-56(s0)
    800086ba:	0207df63          	bgez	a5,800086f8 <sys_pipe+0xba>
    if(fd0 >= 0)
    800086be:	fcc42783          	lw	a5,-52(s0)
    800086c2:	0007cb63          	bltz	a5,800086d8 <sys_pipe+0x9a>
      p->ofile[fd0] = 0;
    800086c6:	fcc42783          	lw	a5,-52(s0)
    800086ca:	fe843703          	ld	a4,-24(s0)
    800086ce:	07e9                	addi	a5,a5,26
    800086d0:	078e                	slli	a5,a5,0x3
    800086d2:	97ba                	add	a5,a5,a4
    800086d4:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800086d8:	fd843783          	ld	a5,-40(s0)
    800086dc:	853e                	mv	a0,a5
    800086de:	ffffe097          	auipc	ra,0xffffe
    800086e2:	0ca080e7          	jalr	202(ra) # 800067a8 <fileclose>
    fileclose(wf);
    800086e6:	fd043783          	ld	a5,-48(s0)
    800086ea:	853e                	mv	a0,a5
    800086ec:	ffffe097          	auipc	ra,0xffffe
    800086f0:	0bc080e7          	jalr	188(ra) # 800067a8 <fileclose>
    return -1;
    800086f4:	57fd                	li	a5,-1
    800086f6:	a079                	j	80008784 <sys_pipe+0x146>
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800086f8:	fe843783          	ld	a5,-24(s0)
    800086fc:	6bbc                	ld	a5,80(a5)
    800086fe:	fe043703          	ld	a4,-32(s0)
    80008702:	fcc40613          	addi	a2,s0,-52
    80008706:	4691                	li	a3,4
    80008708:	85ba                	mv	a1,a4
    8000870a:	853e                	mv	a0,a5
    8000870c:	ffffa097          	auipc	ra,0xffffa
    80008710:	c6e080e7          	jalr	-914(ra) # 8000237a <copyout>
    80008714:	87aa                	mv	a5,a0
    80008716:	0207c463          	bltz	a5,8000873e <sys_pipe+0x100>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000871a:	fe843783          	ld	a5,-24(s0)
    8000871e:	6bb8                	ld	a4,80(a5)
    80008720:	fe043783          	ld	a5,-32(s0)
    80008724:	0791                	addi	a5,a5,4
    80008726:	fc840613          	addi	a2,s0,-56
    8000872a:	4691                	li	a3,4
    8000872c:	85be                	mv	a1,a5
    8000872e:	853a                	mv	a0,a4
    80008730:	ffffa097          	auipc	ra,0xffffa
    80008734:	c4a080e7          	jalr	-950(ra) # 8000237a <copyout>
    80008738:	87aa                	mv	a5,a0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000873a:	0407d463          	bgez	a5,80008782 <sys_pipe+0x144>
    p->ofile[fd0] = 0;
    8000873e:	fcc42783          	lw	a5,-52(s0)
    80008742:	fe843703          	ld	a4,-24(s0)
    80008746:	07e9                	addi	a5,a5,26
    80008748:	078e                	slli	a5,a5,0x3
    8000874a:	97ba                	add	a5,a5,a4
    8000874c:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80008750:	fc842783          	lw	a5,-56(s0)
    80008754:	fe843703          	ld	a4,-24(s0)
    80008758:	07e9                	addi	a5,a5,26
    8000875a:	078e                	slli	a5,a5,0x3
    8000875c:	97ba                	add	a5,a5,a4
    8000875e:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80008762:	fd843783          	ld	a5,-40(s0)
    80008766:	853e                	mv	a0,a5
    80008768:	ffffe097          	auipc	ra,0xffffe
    8000876c:	040080e7          	jalr	64(ra) # 800067a8 <fileclose>
    fileclose(wf);
    80008770:	fd043783          	ld	a5,-48(s0)
    80008774:	853e                	mv	a0,a5
    80008776:	ffffe097          	auipc	ra,0xffffe
    8000877a:	032080e7          	jalr	50(ra) # 800067a8 <fileclose>
    return -1;
    8000877e:	57fd                	li	a5,-1
    80008780:	a011                	j	80008784 <sys_pipe+0x146>
  }
  return 0;
    80008782:	4781                	li	a5,0
}
    80008784:	853e                	mv	a0,a5
    80008786:	70e2                	ld	ra,56(sp)
    80008788:	7442                	ld	s0,48(sp)
    8000878a:	6121                	addi	sp,sp,64
    8000878c:	8082                	ret
	...

0000000080008790 <kernelvec>:
    80008790:	7111                	addi	sp,sp,-256
    80008792:	e006                	sd	ra,0(sp)
    80008794:	e40a                	sd	sp,8(sp)
    80008796:	e80e                	sd	gp,16(sp)
    80008798:	ec12                	sd	tp,24(sp)
    8000879a:	f016                	sd	t0,32(sp)
    8000879c:	f41a                	sd	t1,40(sp)
    8000879e:	f81e                	sd	t2,48(sp)
    800087a0:	fc22                	sd	s0,56(sp)
    800087a2:	e0a6                	sd	s1,64(sp)
    800087a4:	e4aa                	sd	a0,72(sp)
    800087a6:	e8ae                	sd	a1,80(sp)
    800087a8:	ecb2                	sd	a2,88(sp)
    800087aa:	f0b6                	sd	a3,96(sp)
    800087ac:	f4ba                	sd	a4,104(sp)
    800087ae:	f8be                	sd	a5,112(sp)
    800087b0:	fcc2                	sd	a6,120(sp)
    800087b2:	e146                	sd	a7,128(sp)
    800087b4:	e54a                	sd	s2,136(sp)
    800087b6:	e94e                	sd	s3,144(sp)
    800087b8:	ed52                	sd	s4,152(sp)
    800087ba:	f156                	sd	s5,160(sp)
    800087bc:	f55a                	sd	s6,168(sp)
    800087be:	f95e                	sd	s7,176(sp)
    800087c0:	fd62                	sd	s8,184(sp)
    800087c2:	e1e6                	sd	s9,192(sp)
    800087c4:	e5ea                	sd	s10,200(sp)
    800087c6:	e9ee                	sd	s11,208(sp)
    800087c8:	edf2                	sd	t3,216(sp)
    800087ca:	f1f6                	sd	t4,224(sp)
    800087cc:	f5fa                	sd	t5,232(sp)
    800087ce:	f9fe                	sd	t6,240(sp)
    800087d0:	d8efb0ef          	jal	80003d5e <kerneltrap>
    800087d4:	6082                	ld	ra,0(sp)
    800087d6:	6122                	ld	sp,8(sp)
    800087d8:	61c2                	ld	gp,16(sp)
    800087da:	7282                	ld	t0,32(sp)
    800087dc:	7322                	ld	t1,40(sp)
    800087de:	73c2                	ld	t2,48(sp)
    800087e0:	7462                	ld	s0,56(sp)
    800087e2:	6486                	ld	s1,64(sp)
    800087e4:	6526                	ld	a0,72(sp)
    800087e6:	65c6                	ld	a1,80(sp)
    800087e8:	6666                	ld	a2,88(sp)
    800087ea:	7686                	ld	a3,96(sp)
    800087ec:	7726                	ld	a4,104(sp)
    800087ee:	77c6                	ld	a5,112(sp)
    800087f0:	7866                	ld	a6,120(sp)
    800087f2:	688a                	ld	a7,128(sp)
    800087f4:	692a                	ld	s2,136(sp)
    800087f6:	69ca                	ld	s3,144(sp)
    800087f8:	6a6a                	ld	s4,152(sp)
    800087fa:	7a8a                	ld	s5,160(sp)
    800087fc:	7b2a                	ld	s6,168(sp)
    800087fe:	7bca                	ld	s7,176(sp)
    80008800:	7c6a                	ld	s8,184(sp)
    80008802:	6c8e                	ld	s9,192(sp)
    80008804:	6d2e                	ld	s10,200(sp)
    80008806:	6dce                	ld	s11,208(sp)
    80008808:	6e6e                	ld	t3,216(sp)
    8000880a:	7e8e                	ld	t4,224(sp)
    8000880c:	7f2e                	ld	t5,232(sp)
    8000880e:	7fce                	ld	t6,240(sp)
    80008810:	6111                	addi	sp,sp,256
    80008812:	10200073          	sret
    80008816:	00000013          	nop
    8000881a:	00000013          	nop
    8000881e:	0001                	nop

0000000080008820 <timervec>:
    80008820:	34051573          	csrrw	a0,mscratch,a0
    80008824:	e10c                	sd	a1,0(a0)
    80008826:	e510                	sd	a2,8(a0)
    80008828:	e914                	sd	a3,16(a0)
    8000882a:	6d0c                	ld	a1,24(a0)
    8000882c:	7110                	ld	a2,32(a0)
    8000882e:	6194                	ld	a3,0(a1)
    80008830:	96b2                	add	a3,a3,a2
    80008832:	e194                	sd	a3,0(a1)
    80008834:	4589                	li	a1,2
    80008836:	14459073          	csrw	sip,a1
    8000883a:	6914                	ld	a3,16(a0)
    8000883c:	6510                	ld	a2,8(a0)
    8000883e:	610c                	ld	a1,0(a0)
    80008840:	34051573          	csrrw	a0,mscratch,a0
    80008844:	30200073          	mret
	...

000000008000884a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000884a:	1141                	addi	sp,sp,-16
    8000884c:	e406                	sd	ra,8(sp)
    8000884e:	e022                	sd	s0,0(sp)
    80008850:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80008852:	0c0007b7          	lui	a5,0xc000
    80008856:	02878793          	addi	a5,a5,40 # c000028 <_entry-0x73ffffd8>
    8000885a:	4705                	li	a4,1
    8000885c:	c398                	sw	a4,0(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000885e:	0c0007b7          	lui	a5,0xc000
    80008862:	0791                	addi	a5,a5,4 # c000004 <_entry-0x73fffffc>
    80008864:	4705                	li	a4,1
    80008866:	c398                	sw	a4,0(a5)
}
    80008868:	0001                	nop
    8000886a:	60a2                	ld	ra,8(sp)
    8000886c:	6402                	ld	s0,0(sp)
    8000886e:	0141                	addi	sp,sp,16
    80008870:	8082                	ret

0000000080008872 <plicinithart>:

void
plicinithart(void)
{
    80008872:	1101                	addi	sp,sp,-32
    80008874:	ec06                	sd	ra,24(sp)
    80008876:	e822                	sd	s0,16(sp)
    80008878:	1000                	addi	s0,sp,32
  int hart = cpuid();
    8000887a:	ffffa097          	auipc	ra,0xffffa
    8000887e:	fe4080e7          	jalr	-28(ra) # 8000285e <cpuid>
    80008882:	87aa                	mv	a5,a0
    80008884:	fef42623          	sw	a5,-20(s0)
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80008888:	fec42783          	lw	a5,-20(s0)
    8000888c:	0087979b          	slliw	a5,a5,0x8
    80008890:	2781                	sext.w	a5,a5
    80008892:	873e                	mv	a4,a5
    80008894:	0c0027b7          	lui	a5,0xc002
    80008898:	08078793          	addi	a5,a5,128 # c002080 <_entry-0x73ffdf80>
    8000889c:	97ba                	add	a5,a5,a4
    8000889e:	873e                	mv	a4,a5
    800088a0:	40200793          	li	a5,1026
    800088a4:	c31c                	sw	a5,0(a4)

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800088a6:	fec42783          	lw	a5,-20(s0)
    800088aa:	00d7979b          	slliw	a5,a5,0xd
    800088ae:	2781                	sext.w	a5,a5
    800088b0:	873e                	mv	a4,a5
    800088b2:	0c2017b7          	lui	a5,0xc201
    800088b6:	97ba                	add	a5,a5,a4
    800088b8:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800088bc:	0001                	nop
    800088be:	60e2                	ld	ra,24(sp)
    800088c0:	6442                	ld	s0,16(sp)
    800088c2:	6105                	addi	sp,sp,32
    800088c4:	8082                	ret

00000000800088c6 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800088c6:	1101                	addi	sp,sp,-32
    800088c8:	ec06                	sd	ra,24(sp)
    800088ca:	e822                	sd	s0,16(sp)
    800088cc:	1000                	addi	s0,sp,32
  int hart = cpuid();
    800088ce:	ffffa097          	auipc	ra,0xffffa
    800088d2:	f90080e7          	jalr	-112(ra) # 8000285e <cpuid>
    800088d6:	87aa                	mv	a5,a0
    800088d8:	fef42623          	sw	a5,-20(s0)
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800088dc:	fec42783          	lw	a5,-20(s0)
    800088e0:	00d7979b          	slliw	a5,a5,0xd
    800088e4:	2781                	sext.w	a5,a5
    800088e6:	873e                	mv	a4,a5
    800088e8:	0c2017b7          	lui	a5,0xc201
    800088ec:	0791                	addi	a5,a5,4 # c201004 <_entry-0x73dfeffc>
    800088ee:	97ba                	add	a5,a5,a4
    800088f0:	439c                	lw	a5,0(a5)
    800088f2:	fef42423          	sw	a5,-24(s0)
  return irq;
    800088f6:	fe842783          	lw	a5,-24(s0)
}
    800088fa:	853e                	mv	a0,a5
    800088fc:	60e2                	ld	ra,24(sp)
    800088fe:	6442                	ld	s0,16(sp)
    80008900:	6105                	addi	sp,sp,32
    80008902:	8082                	ret

0000000080008904 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80008904:	7179                	addi	sp,sp,-48
    80008906:	f406                	sd	ra,40(sp)
    80008908:	f022                	sd	s0,32(sp)
    8000890a:	1800                	addi	s0,sp,48
    8000890c:	87aa                	mv	a5,a0
    8000890e:	fcf42e23          	sw	a5,-36(s0)
  int hart = cpuid();
    80008912:	ffffa097          	auipc	ra,0xffffa
    80008916:	f4c080e7          	jalr	-180(ra) # 8000285e <cpuid>
    8000891a:	87aa                	mv	a5,a0
    8000891c:	fef42623          	sw	a5,-20(s0)
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80008920:	fec42783          	lw	a5,-20(s0)
    80008924:	00d7979b          	slliw	a5,a5,0xd
    80008928:	2781                	sext.w	a5,a5
    8000892a:	873e                	mv	a4,a5
    8000892c:	0c2017b7          	lui	a5,0xc201
    80008930:	0791                	addi	a5,a5,4 # c201004 <_entry-0x73dfeffc>
    80008932:	97ba                	add	a5,a5,a4
    80008934:	873e                	mv	a4,a5
    80008936:	fdc42783          	lw	a5,-36(s0)
    8000893a:	c31c                	sw	a5,0(a4)
}
    8000893c:	0001                	nop
    8000893e:	70a2                	ld	ra,40(sp)
    80008940:	7402                	ld	s0,32(sp)
    80008942:	6145                	addi	sp,sp,48
    80008944:	8082                	ret

0000000080008946 <virtio_disk_init>:
  
} disk;

void
virtio_disk_init(void)
{
    80008946:	7179                	addi	sp,sp,-48
    80008948:	f406                	sd	ra,40(sp)
    8000894a:	f022                	sd	s0,32(sp)
    8000894c:	1800                	addi	s0,sp,48
  uint32 status = 0;
    8000894e:	fe042423          	sw	zero,-24(s0)

  initlock(&disk.vdisk_lock, "virtio_disk");
    80008952:	00003597          	auipc	a1,0x3
    80008956:	d0658593          	addi	a1,a1,-762 # 8000b658 <etext+0x658>
    8000895a:	0001c517          	auipc	a0,0x1c
    8000895e:	3d650513          	addi	a0,a0,982 # 80024d30 <disk+0x128>
    80008962:	ffff9097          	auipc	ra,0xffff9
    80008966:	92e080e7          	jalr	-1746(ra) # 80001290 <initlock>

  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000896a:	100017b7          	lui	a5,0x10001
    8000896e:	439c                	lw	a5,0(a5)
    80008970:	0007871b          	sext.w	a4,a5
    80008974:	747277b7          	lui	a5,0x74727
    80008978:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000897c:	04f71063          	bne	a4,a5,800089bc <virtio_disk_init+0x76>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80008980:	100017b7          	lui	a5,0x10001
    80008984:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80008986:	439c                	lw	a5,0(a5)
    80008988:	0007871b          	sext.w	a4,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000898c:	4789                	li	a5,2
    8000898e:	02f71763          	bne	a4,a5,800089bc <virtio_disk_init+0x76>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80008992:	100017b7          	lui	a5,0x10001
    80008996:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80008998:	439c                	lw	a5,0(a5)
    8000899a:	0007871b          	sext.w	a4,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000899e:	4789                	li	a5,2
    800089a0:	00f71e63          	bne	a4,a5,800089bc <virtio_disk_init+0x76>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800089a4:	100017b7          	lui	a5,0x10001
    800089a8:	07b1                	addi	a5,a5,12 # 1000100c <_entry-0x6fffeff4>
    800089aa:	439c                	lw	a5,0(a5)
    800089ac:	0007871b          	sext.w	a4,a5
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800089b0:	554d47b7          	lui	a5,0x554d4
    800089b4:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800089b8:	00f70a63          	beq	a4,a5,800089cc <virtio_disk_init+0x86>
    panic("could not find virtio disk");
    800089bc:	00003517          	auipc	a0,0x3
    800089c0:	cac50513          	addi	a0,a0,-852 # 8000b668 <etext+0x668>
    800089c4:	ffff8097          	auipc	ra,0xffff8
    800089c8:	2fc080e7          	jalr	764(ra) # 80000cc0 <panic>
  }
  
  // reset device
  *R(VIRTIO_MMIO_STATUS) = status;
    800089cc:	100017b7          	lui	a5,0x10001
    800089d0:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x6fffef90>
    800089d4:	fe842703          	lw	a4,-24(s0)
    800089d8:	c398                	sw	a4,0(a5)

  // set ACKNOWLEDGE status bit
  status |= VIRTIO_CONFIG_S_ACKNOWLEDGE;
    800089da:	fe842783          	lw	a5,-24(s0)
    800089de:	0017e793          	ori	a5,a5,1
    800089e2:	fef42423          	sw	a5,-24(s0)
  *R(VIRTIO_MMIO_STATUS) = status;
    800089e6:	100017b7          	lui	a5,0x10001
    800089ea:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x6fffef90>
    800089ee:	fe842703          	lw	a4,-24(s0)
    800089f2:	c398                	sw	a4,0(a5)

  // set DRIVER status bit
  status |= VIRTIO_CONFIG_S_DRIVER;
    800089f4:	fe842783          	lw	a5,-24(s0)
    800089f8:	0027e793          	ori	a5,a5,2
    800089fc:	fef42423          	sw	a5,-24(s0)
  *R(VIRTIO_MMIO_STATUS) = status;
    80008a00:	100017b7          	lui	a5,0x10001
    80008a04:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x6fffef90>
    80008a08:	fe842703          	lw	a4,-24(s0)
    80008a0c:	c398                	sw	a4,0(a5)

  // negotiate features
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80008a0e:	100017b7          	lui	a5,0x10001
    80008a12:	07c1                	addi	a5,a5,16 # 10001010 <_entry-0x6fffeff0>
    80008a14:	439c                	lw	a5,0(a5)
    80008a16:	2781                	sext.w	a5,a5
    80008a18:	1782                	slli	a5,a5,0x20
    80008a1a:	9381                	srli	a5,a5,0x20
    80008a1c:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_BLK_F_RO);
    80008a20:	fe043783          	ld	a5,-32(s0)
    80008a24:	fdf7f793          	andi	a5,a5,-33
    80008a28:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_BLK_F_SCSI);
    80008a2c:	fe043783          	ld	a5,-32(s0)
    80008a30:	f7f7f793          	andi	a5,a5,-129
    80008a34:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_BLK_F_CONFIG_WCE);
    80008a38:	fe043703          	ld	a4,-32(s0)
    80008a3c:	77fd                	lui	a5,0xfffff
    80008a3e:	7ff78793          	addi	a5,a5,2047 # fffffffffffff7ff <end+0xffffffff7ffdaab7>
    80008a42:	8ff9                	and	a5,a5,a4
    80008a44:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_BLK_F_MQ);
    80008a48:	fe043703          	ld	a4,-32(s0)
    80008a4c:	77fd                	lui	a5,0xfffff
    80008a4e:	17fd                	addi	a5,a5,-1 # ffffffffffffefff <end+0xffffffff7ffda2b7>
    80008a50:	8ff9                	and	a5,a5,a4
    80008a52:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_F_ANY_LAYOUT);
    80008a56:	fe043703          	ld	a4,-32(s0)
    80008a5a:	f80007b7          	lui	a5,0xf8000
    80008a5e:	17fd                	addi	a5,a5,-1 # fffffffff7ffffff <end+0xffffffff77fdb2b7>
    80008a60:	8ff9                	and	a5,a5,a4
    80008a62:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_RING_F_EVENT_IDX);
    80008a66:	fe043703          	ld	a4,-32(s0)
    80008a6a:	e00007b7          	lui	a5,0xe0000
    80008a6e:	17fd                	addi	a5,a5,-1 # ffffffffdfffffff <end+0xffffffff5ffdb2b7>
    80008a70:	8ff9                	and	a5,a5,a4
    80008a72:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80008a76:	fe043703          	ld	a4,-32(s0)
    80008a7a:	f00007b7          	lui	a5,0xf0000
    80008a7e:	17fd                	addi	a5,a5,-1 # ffffffffefffffff <end+0xffffffff6ffdb2b7>
    80008a80:	8ff9                	and	a5,a5,a4
    80008a82:	fef43023          	sd	a5,-32(s0)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80008a86:	100017b7          	lui	a5,0x10001
    80008a8a:	02078793          	addi	a5,a5,32 # 10001020 <_entry-0x6fffefe0>
    80008a8e:	fe043703          	ld	a4,-32(s0)
    80008a92:	2701                	sext.w	a4,a4
    80008a94:	c398                	sw	a4,0(a5)

  // tell device that feature negotiation is complete.
  status |= VIRTIO_CONFIG_S_FEATURES_OK;
    80008a96:	fe842783          	lw	a5,-24(s0)
    80008a9a:	0087e793          	ori	a5,a5,8
    80008a9e:	fef42423          	sw	a5,-24(s0)
  *R(VIRTIO_MMIO_STATUS) = status;
    80008aa2:	100017b7          	lui	a5,0x10001
    80008aa6:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x6fffef90>
    80008aaa:	fe842703          	lw	a4,-24(s0)
    80008aae:	c398                	sw	a4,0(a5)

  // re-read status to ensure FEATURES_OK is set.
  status = *R(VIRTIO_MMIO_STATUS);
    80008ab0:	100017b7          	lui	a5,0x10001
    80008ab4:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x6fffef90>
    80008ab8:	439c                	lw	a5,0(a5)
    80008aba:	fef42423          	sw	a5,-24(s0)
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80008abe:	fe842783          	lw	a5,-24(s0)
    80008ac2:	8ba1                	andi	a5,a5,8
    80008ac4:	2781                	sext.w	a5,a5
    80008ac6:	eb89                	bnez	a5,80008ad8 <virtio_disk_init+0x192>
    panic("virtio disk FEATURES_OK unset");
    80008ac8:	00003517          	auipc	a0,0x3
    80008acc:	bc050513          	addi	a0,a0,-1088 # 8000b688 <etext+0x688>
    80008ad0:	ffff8097          	auipc	ra,0xffff8
    80008ad4:	1f0080e7          	jalr	496(ra) # 80000cc0 <panic>

  // initialize queue 0.
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80008ad8:	100017b7          	lui	a5,0x10001
    80008adc:	03078793          	addi	a5,a5,48 # 10001030 <_entry-0x6fffefd0>
    80008ae0:	0007a023          	sw	zero,0(a5)

  // ensure queue 0 is not in use.
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80008ae4:	100017b7          	lui	a5,0x10001
    80008ae8:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80008aec:	439c                	lw	a5,0(a5)
    80008aee:	2781                	sext.w	a5,a5
    80008af0:	cb89                	beqz	a5,80008b02 <virtio_disk_init+0x1bc>
    panic("virtio disk should not be ready");
    80008af2:	00003517          	auipc	a0,0x3
    80008af6:	bb650513          	addi	a0,a0,-1098 # 8000b6a8 <etext+0x6a8>
    80008afa:	ffff8097          	auipc	ra,0xffff8
    80008afe:	1c6080e7          	jalr	454(ra) # 80000cc0 <panic>

  // check maximum queue size.
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80008b02:	100017b7          	lui	a5,0x10001
    80008b06:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80008b0a:	439c                	lw	a5,0(a5)
    80008b0c:	fcf42e23          	sw	a5,-36(s0)
  if(max == 0)
    80008b10:	fdc42783          	lw	a5,-36(s0)
    80008b14:	2781                	sext.w	a5,a5
    80008b16:	eb89                	bnez	a5,80008b28 <virtio_disk_init+0x1e2>
    panic("virtio disk has no queue 0");
    80008b18:	00003517          	auipc	a0,0x3
    80008b1c:	bb050513          	addi	a0,a0,-1104 # 8000b6c8 <etext+0x6c8>
    80008b20:	ffff8097          	auipc	ra,0xffff8
    80008b24:	1a0080e7          	jalr	416(ra) # 80000cc0 <panic>
  if(max < NUM)
    80008b28:	fdc42783          	lw	a5,-36(s0)
    80008b2c:	0007871b          	sext.w	a4,a5
    80008b30:	479d                	li	a5,7
    80008b32:	00e7ea63          	bltu	a5,a4,80008b46 <virtio_disk_init+0x200>
    panic("virtio disk max queue too short");
    80008b36:	00003517          	auipc	a0,0x3
    80008b3a:	bb250513          	addi	a0,a0,-1102 # 8000b6e8 <etext+0x6e8>
    80008b3e:	ffff8097          	auipc	ra,0xffff8
    80008b42:	182080e7          	jalr	386(ra) # 80000cc0 <panic>

  // allocate and zero queue memory.
  disk.desc = kalloc();
    80008b46:	ffff8097          	auipc	ra,0xffff8
    80008b4a:	61e080e7          	jalr	1566(ra) # 80001164 <kalloc>
    80008b4e:	872a                	mv	a4,a0
    80008b50:	0001c797          	auipc	a5,0x1c
    80008b54:	0b878793          	addi	a5,a5,184 # 80024c08 <disk>
    80008b58:	e398                	sd	a4,0(a5)
  disk.avail = kalloc();
    80008b5a:	ffff8097          	auipc	ra,0xffff8
    80008b5e:	60a080e7          	jalr	1546(ra) # 80001164 <kalloc>
    80008b62:	872a                	mv	a4,a0
    80008b64:	0001c797          	auipc	a5,0x1c
    80008b68:	0a478793          	addi	a5,a5,164 # 80024c08 <disk>
    80008b6c:	e798                	sd	a4,8(a5)
  disk.used = kalloc();
    80008b6e:	ffff8097          	auipc	ra,0xffff8
    80008b72:	5f6080e7          	jalr	1526(ra) # 80001164 <kalloc>
    80008b76:	872a                	mv	a4,a0
    80008b78:	0001c797          	auipc	a5,0x1c
    80008b7c:	09078793          	addi	a5,a5,144 # 80024c08 <disk>
    80008b80:	eb98                	sd	a4,16(a5)
  if(!disk.desc || !disk.avail || !disk.used)
    80008b82:	0001c797          	auipc	a5,0x1c
    80008b86:	08678793          	addi	a5,a5,134 # 80024c08 <disk>
    80008b8a:	639c                	ld	a5,0(a5)
    80008b8c:	cf89                	beqz	a5,80008ba6 <virtio_disk_init+0x260>
    80008b8e:	0001c797          	auipc	a5,0x1c
    80008b92:	07a78793          	addi	a5,a5,122 # 80024c08 <disk>
    80008b96:	679c                	ld	a5,8(a5)
    80008b98:	c799                	beqz	a5,80008ba6 <virtio_disk_init+0x260>
    80008b9a:	0001c797          	auipc	a5,0x1c
    80008b9e:	06e78793          	addi	a5,a5,110 # 80024c08 <disk>
    80008ba2:	6b9c                	ld	a5,16(a5)
    80008ba4:	eb89                	bnez	a5,80008bb6 <virtio_disk_init+0x270>
    panic("virtio disk kalloc");
    80008ba6:	00003517          	auipc	a0,0x3
    80008baa:	b6250513          	addi	a0,a0,-1182 # 8000b708 <etext+0x708>
    80008bae:	ffff8097          	auipc	ra,0xffff8
    80008bb2:	112080e7          	jalr	274(ra) # 80000cc0 <panic>
  memset(disk.desc, 0, PGSIZE);
    80008bb6:	0001c797          	auipc	a5,0x1c
    80008bba:	05278793          	addi	a5,a5,82 # 80024c08 <disk>
    80008bbe:	639c                	ld	a5,0(a5)
    80008bc0:	6605                	lui	a2,0x1
    80008bc2:	4581                	li	a1,0
    80008bc4:	853e                	mv	a0,a5
    80008bc6:	ffff9097          	auipc	ra,0xffff9
    80008bca:	8d2080e7          	jalr	-1838(ra) # 80001498 <memset>
  memset(disk.avail, 0, PGSIZE);
    80008bce:	0001c797          	auipc	a5,0x1c
    80008bd2:	03a78793          	addi	a5,a5,58 # 80024c08 <disk>
    80008bd6:	679c                	ld	a5,8(a5)
    80008bd8:	6605                	lui	a2,0x1
    80008bda:	4581                	li	a1,0
    80008bdc:	853e                	mv	a0,a5
    80008bde:	ffff9097          	auipc	ra,0xffff9
    80008be2:	8ba080e7          	jalr	-1862(ra) # 80001498 <memset>
  memset(disk.used, 0, PGSIZE);
    80008be6:	0001c797          	auipc	a5,0x1c
    80008bea:	02278793          	addi	a5,a5,34 # 80024c08 <disk>
    80008bee:	6b9c                	ld	a5,16(a5)
    80008bf0:	6605                	lui	a2,0x1
    80008bf2:	4581                	li	a1,0
    80008bf4:	853e                	mv	a0,a5
    80008bf6:	ffff9097          	auipc	ra,0xffff9
    80008bfa:	8a2080e7          	jalr	-1886(ra) # 80001498 <memset>

  // set queue size.
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80008bfe:	100017b7          	lui	a5,0x10001
    80008c02:	03878793          	addi	a5,a5,56 # 10001038 <_entry-0x6fffefc8>
    80008c06:	4721                	li	a4,8
    80008c08:	c398                	sw	a4,0(a5)

  // write physical addresses.
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80008c0a:	0001c797          	auipc	a5,0x1c
    80008c0e:	ffe78793          	addi	a5,a5,-2 # 80024c08 <disk>
    80008c12:	639c                	ld	a5,0(a5)
    80008c14:	873e                	mv	a4,a5
    80008c16:	100017b7          	lui	a5,0x10001
    80008c1a:	08078793          	addi	a5,a5,128 # 10001080 <_entry-0x6fffef80>
    80008c1e:	2701                	sext.w	a4,a4
    80008c20:	c398                	sw	a4,0(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80008c22:	0001c797          	auipc	a5,0x1c
    80008c26:	fe678793          	addi	a5,a5,-26 # 80024c08 <disk>
    80008c2a:	639c                	ld	a5,0(a5)
    80008c2c:	0207d713          	srli	a4,a5,0x20
    80008c30:	100017b7          	lui	a5,0x10001
    80008c34:	08478793          	addi	a5,a5,132 # 10001084 <_entry-0x6fffef7c>
    80008c38:	2701                	sext.w	a4,a4
    80008c3a:	c398                	sw	a4,0(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80008c3c:	0001c797          	auipc	a5,0x1c
    80008c40:	fcc78793          	addi	a5,a5,-52 # 80024c08 <disk>
    80008c44:	679c                	ld	a5,8(a5)
    80008c46:	873e                	mv	a4,a5
    80008c48:	100017b7          	lui	a5,0x10001
    80008c4c:	09078793          	addi	a5,a5,144 # 10001090 <_entry-0x6fffef70>
    80008c50:	2701                	sext.w	a4,a4
    80008c52:	c398                	sw	a4,0(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80008c54:	0001c797          	auipc	a5,0x1c
    80008c58:	fb478793          	addi	a5,a5,-76 # 80024c08 <disk>
    80008c5c:	679c                	ld	a5,8(a5)
    80008c5e:	0207d713          	srli	a4,a5,0x20
    80008c62:	100017b7          	lui	a5,0x10001
    80008c66:	09478793          	addi	a5,a5,148 # 10001094 <_entry-0x6fffef6c>
    80008c6a:	2701                	sext.w	a4,a4
    80008c6c:	c398                	sw	a4,0(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80008c6e:	0001c797          	auipc	a5,0x1c
    80008c72:	f9a78793          	addi	a5,a5,-102 # 80024c08 <disk>
    80008c76:	6b9c                	ld	a5,16(a5)
    80008c78:	873e                	mv	a4,a5
    80008c7a:	100017b7          	lui	a5,0x10001
    80008c7e:	0a078793          	addi	a5,a5,160 # 100010a0 <_entry-0x6fffef60>
    80008c82:	2701                	sext.w	a4,a4
    80008c84:	c398                	sw	a4,0(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80008c86:	0001c797          	auipc	a5,0x1c
    80008c8a:	f8278793          	addi	a5,a5,-126 # 80024c08 <disk>
    80008c8e:	6b9c                	ld	a5,16(a5)
    80008c90:	0207d713          	srli	a4,a5,0x20
    80008c94:	100017b7          	lui	a5,0x10001
    80008c98:	0a478793          	addi	a5,a5,164 # 100010a4 <_entry-0x6fffef5c>
    80008c9c:	2701                	sext.w	a4,a4
    80008c9e:	c398                	sw	a4,0(a5)

  // queue is ready.
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80008ca0:	100017b7          	lui	a5,0x10001
    80008ca4:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80008ca8:	4705                	li	a4,1
    80008caa:	c398                	sw	a4,0(a5)

  // all NUM descriptors start out unused.
  for(int i = 0; i < NUM; i++)
    80008cac:	fe042623          	sw	zero,-20(s0)
    80008cb0:	a005                	j	80008cd0 <virtio_disk_init+0x38a>
    disk.free[i] = 1;
    80008cb2:	0001c717          	auipc	a4,0x1c
    80008cb6:	f5670713          	addi	a4,a4,-170 # 80024c08 <disk>
    80008cba:	fec42783          	lw	a5,-20(s0)
    80008cbe:	97ba                	add	a5,a5,a4
    80008cc0:	4705                	li	a4,1
    80008cc2:	00e78c23          	sb	a4,24(a5)
  for(int i = 0; i < NUM; i++)
    80008cc6:	fec42783          	lw	a5,-20(s0)
    80008cca:	2785                	addiw	a5,a5,1
    80008ccc:	fef42623          	sw	a5,-20(s0)
    80008cd0:	fec42783          	lw	a5,-20(s0)
    80008cd4:	0007871b          	sext.w	a4,a5
    80008cd8:	479d                	li	a5,7
    80008cda:	fce7dce3          	bge	a5,a4,80008cb2 <virtio_disk_init+0x36c>

  // tell device we're completely ready.
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80008cde:	fe842783          	lw	a5,-24(s0)
    80008ce2:	0047e793          	ori	a5,a5,4
    80008ce6:	fef42423          	sw	a5,-24(s0)
  *R(VIRTIO_MMIO_STATUS) = status;
    80008cea:	100017b7          	lui	a5,0x10001
    80008cee:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x6fffef90>
    80008cf2:	fe842703          	lw	a4,-24(s0)
    80008cf6:	c398                	sw	a4,0(a5)

  // plic.c and trap.c arrange for interrupts from VIRTIO0_IRQ.
}
    80008cf8:	0001                	nop
    80008cfa:	70a2                	ld	ra,40(sp)
    80008cfc:	7402                	ld	s0,32(sp)
    80008cfe:	6145                	addi	sp,sp,48
    80008d00:	8082                	ret

0000000080008d02 <alloc_desc>:

// find a free descriptor, mark it non-free, return its index.
static int
alloc_desc()
{
    80008d02:	1101                	addi	sp,sp,-32
    80008d04:	ec06                	sd	ra,24(sp)
    80008d06:	e822                	sd	s0,16(sp)
    80008d08:	1000                	addi	s0,sp,32
  for(int i = 0; i < NUM; i++){
    80008d0a:	fe042623          	sw	zero,-20(s0)
    80008d0e:	a825                	j	80008d46 <alloc_desc+0x44>
    if(disk.free[i]){
    80008d10:	0001c717          	auipc	a4,0x1c
    80008d14:	ef870713          	addi	a4,a4,-264 # 80024c08 <disk>
    80008d18:	fec42783          	lw	a5,-20(s0)
    80008d1c:	97ba                	add	a5,a5,a4
    80008d1e:	0187c783          	lbu	a5,24(a5)
    80008d22:	cf89                	beqz	a5,80008d3c <alloc_desc+0x3a>
      disk.free[i] = 0;
    80008d24:	0001c717          	auipc	a4,0x1c
    80008d28:	ee470713          	addi	a4,a4,-284 # 80024c08 <disk>
    80008d2c:	fec42783          	lw	a5,-20(s0)
    80008d30:	97ba                	add	a5,a5,a4
    80008d32:	00078c23          	sb	zero,24(a5)
      return i;
    80008d36:	fec42783          	lw	a5,-20(s0)
    80008d3a:	a831                	j	80008d56 <alloc_desc+0x54>
  for(int i = 0; i < NUM; i++){
    80008d3c:	fec42783          	lw	a5,-20(s0)
    80008d40:	2785                	addiw	a5,a5,1
    80008d42:	fef42623          	sw	a5,-20(s0)
    80008d46:	fec42783          	lw	a5,-20(s0)
    80008d4a:	0007871b          	sext.w	a4,a5
    80008d4e:	479d                	li	a5,7
    80008d50:	fce7d0e3          	bge	a5,a4,80008d10 <alloc_desc+0xe>
    }
  }
  return -1;
    80008d54:	57fd                	li	a5,-1
}
    80008d56:	853e                	mv	a0,a5
    80008d58:	60e2                	ld	ra,24(sp)
    80008d5a:	6442                	ld	s0,16(sp)
    80008d5c:	6105                	addi	sp,sp,32
    80008d5e:	8082                	ret

0000000080008d60 <free_desc>:

// mark a descriptor as free.
static void
free_desc(int i)
{
    80008d60:	1101                	addi	sp,sp,-32
    80008d62:	ec06                	sd	ra,24(sp)
    80008d64:	e822                	sd	s0,16(sp)
    80008d66:	1000                	addi	s0,sp,32
    80008d68:	87aa                	mv	a5,a0
    80008d6a:	fef42623          	sw	a5,-20(s0)
  if(i >= NUM)
    80008d6e:	fec42783          	lw	a5,-20(s0)
    80008d72:	0007871b          	sext.w	a4,a5
    80008d76:	479d                	li	a5,7
    80008d78:	00e7da63          	bge	a5,a4,80008d8c <free_desc+0x2c>
    panic("free_desc 1");
    80008d7c:	00003517          	auipc	a0,0x3
    80008d80:	9a450513          	addi	a0,a0,-1628 # 8000b720 <etext+0x720>
    80008d84:	ffff8097          	auipc	ra,0xffff8
    80008d88:	f3c080e7          	jalr	-196(ra) # 80000cc0 <panic>
  if(disk.free[i])
    80008d8c:	0001c717          	auipc	a4,0x1c
    80008d90:	e7c70713          	addi	a4,a4,-388 # 80024c08 <disk>
    80008d94:	fec42783          	lw	a5,-20(s0)
    80008d98:	97ba                	add	a5,a5,a4
    80008d9a:	0187c783          	lbu	a5,24(a5)
    80008d9e:	cb89                	beqz	a5,80008db0 <free_desc+0x50>
    panic("free_desc 2");
    80008da0:	00003517          	auipc	a0,0x3
    80008da4:	99050513          	addi	a0,a0,-1648 # 8000b730 <etext+0x730>
    80008da8:	ffff8097          	auipc	ra,0xffff8
    80008dac:	f18080e7          	jalr	-232(ra) # 80000cc0 <panic>
  disk.desc[i].addr = 0;
    80008db0:	0001c797          	auipc	a5,0x1c
    80008db4:	e5878793          	addi	a5,a5,-424 # 80024c08 <disk>
    80008db8:	6398                	ld	a4,0(a5)
    80008dba:	fec42783          	lw	a5,-20(s0)
    80008dbe:	0792                	slli	a5,a5,0x4
    80008dc0:	97ba                	add	a5,a5,a4
    80008dc2:	0007b023          	sd	zero,0(a5)
  disk.desc[i].len = 0;
    80008dc6:	0001c797          	auipc	a5,0x1c
    80008dca:	e4278793          	addi	a5,a5,-446 # 80024c08 <disk>
    80008dce:	6398                	ld	a4,0(a5)
    80008dd0:	fec42783          	lw	a5,-20(s0)
    80008dd4:	0792                	slli	a5,a5,0x4
    80008dd6:	97ba                	add	a5,a5,a4
    80008dd8:	0007a423          	sw	zero,8(a5)
  disk.desc[i].flags = 0;
    80008ddc:	0001c797          	auipc	a5,0x1c
    80008de0:	e2c78793          	addi	a5,a5,-468 # 80024c08 <disk>
    80008de4:	6398                	ld	a4,0(a5)
    80008de6:	fec42783          	lw	a5,-20(s0)
    80008dea:	0792                	slli	a5,a5,0x4
    80008dec:	97ba                	add	a5,a5,a4
    80008dee:	00079623          	sh	zero,12(a5)
  disk.desc[i].next = 0;
    80008df2:	0001c797          	auipc	a5,0x1c
    80008df6:	e1678793          	addi	a5,a5,-490 # 80024c08 <disk>
    80008dfa:	6398                	ld	a4,0(a5)
    80008dfc:	fec42783          	lw	a5,-20(s0)
    80008e00:	0792                	slli	a5,a5,0x4
    80008e02:	97ba                	add	a5,a5,a4
    80008e04:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80008e08:	0001c717          	auipc	a4,0x1c
    80008e0c:	e0070713          	addi	a4,a4,-512 # 80024c08 <disk>
    80008e10:	fec42783          	lw	a5,-20(s0)
    80008e14:	97ba                	add	a5,a5,a4
    80008e16:	4705                	li	a4,1
    80008e18:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80008e1c:	0001c517          	auipc	a0,0x1c
    80008e20:	e0450513          	addi	a0,a0,-508 # 80024c20 <disk+0x18>
    80008e24:	ffffa097          	auipc	ra,0xffffa
    80008e28:	6ce080e7          	jalr	1742(ra) # 800034f2 <wakeup>
}
    80008e2c:	0001                	nop
    80008e2e:	60e2                	ld	ra,24(sp)
    80008e30:	6442                	ld	s0,16(sp)
    80008e32:	6105                	addi	sp,sp,32
    80008e34:	8082                	ret

0000000080008e36 <free_chain>:

// free a chain of descriptors.
static void
free_chain(int i)
{
    80008e36:	7179                	addi	sp,sp,-48
    80008e38:	f406                	sd	ra,40(sp)
    80008e3a:	f022                	sd	s0,32(sp)
    80008e3c:	1800                	addi	s0,sp,48
    80008e3e:	87aa                	mv	a5,a0
    80008e40:	fcf42e23          	sw	a5,-36(s0)
  while(1){
    int flag = disk.desc[i].flags;
    80008e44:	0001c797          	auipc	a5,0x1c
    80008e48:	dc478793          	addi	a5,a5,-572 # 80024c08 <disk>
    80008e4c:	6398                	ld	a4,0(a5)
    80008e4e:	fdc42783          	lw	a5,-36(s0)
    80008e52:	0792                	slli	a5,a5,0x4
    80008e54:	97ba                	add	a5,a5,a4
    80008e56:	00c7d783          	lhu	a5,12(a5)
    80008e5a:	fef42623          	sw	a5,-20(s0)
    int nxt = disk.desc[i].next;
    80008e5e:	0001c797          	auipc	a5,0x1c
    80008e62:	daa78793          	addi	a5,a5,-598 # 80024c08 <disk>
    80008e66:	6398                	ld	a4,0(a5)
    80008e68:	fdc42783          	lw	a5,-36(s0)
    80008e6c:	0792                	slli	a5,a5,0x4
    80008e6e:	97ba                	add	a5,a5,a4
    80008e70:	00e7d783          	lhu	a5,14(a5)
    80008e74:	fef42423          	sw	a5,-24(s0)
    free_desc(i);
    80008e78:	fdc42783          	lw	a5,-36(s0)
    80008e7c:	853e                	mv	a0,a5
    80008e7e:	00000097          	auipc	ra,0x0
    80008e82:	ee2080e7          	jalr	-286(ra) # 80008d60 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80008e86:	fec42783          	lw	a5,-20(s0)
    80008e8a:	8b85                	andi	a5,a5,1
    80008e8c:	2781                	sext.w	a5,a5
    80008e8e:	c791                	beqz	a5,80008e9a <free_chain+0x64>
      i = nxt;
    80008e90:	fe842783          	lw	a5,-24(s0)
    80008e94:	fcf42e23          	sw	a5,-36(s0)
  while(1){
    80008e98:	b775                	j	80008e44 <free_chain+0xe>
    else
      break;
    80008e9a:	0001                	nop
  }
}
    80008e9c:	0001                	nop
    80008e9e:	70a2                	ld	ra,40(sp)
    80008ea0:	7402                	ld	s0,32(sp)
    80008ea2:	6145                	addi	sp,sp,48
    80008ea4:	8082                	ret

0000000080008ea6 <alloc3_desc>:

// allocate three descriptors (they need not be contiguous).
// disk transfers always use three descriptors.
static int
alloc3_desc(int *idx)
{
    80008ea6:	7139                	addi	sp,sp,-64
    80008ea8:	fc06                	sd	ra,56(sp)
    80008eaa:	f822                	sd	s0,48(sp)
    80008eac:	f426                	sd	s1,40(sp)
    80008eae:	0080                	addi	s0,sp,64
    80008eb0:	fca43423          	sd	a0,-56(s0)
  for(int i = 0; i < 3; i++){
    80008eb4:	fc042e23          	sw	zero,-36(s0)
    80008eb8:	a89d                	j	80008f2e <alloc3_desc+0x88>
    idx[i] = alloc_desc();
    80008eba:	fdc42783          	lw	a5,-36(s0)
    80008ebe:	078a                	slli	a5,a5,0x2
    80008ec0:	fc843703          	ld	a4,-56(s0)
    80008ec4:	00f704b3          	add	s1,a4,a5
    80008ec8:	00000097          	auipc	ra,0x0
    80008ecc:	e3a080e7          	jalr	-454(ra) # 80008d02 <alloc_desc>
    80008ed0:	87aa                	mv	a5,a0
    80008ed2:	c09c                	sw	a5,0(s1)
    if(idx[i] < 0){
    80008ed4:	fdc42783          	lw	a5,-36(s0)
    80008ed8:	078a                	slli	a5,a5,0x2
    80008eda:	fc843703          	ld	a4,-56(s0)
    80008ede:	97ba                	add	a5,a5,a4
    80008ee0:	439c                	lw	a5,0(a5)
    80008ee2:	0407d163          	bgez	a5,80008f24 <alloc3_desc+0x7e>
      for(int j = 0; j < i; j++)
    80008ee6:	fc042c23          	sw	zero,-40(s0)
    80008eea:	a015                	j	80008f0e <alloc3_desc+0x68>
        free_desc(idx[j]);
    80008eec:	fd842783          	lw	a5,-40(s0)
    80008ef0:	078a                	slli	a5,a5,0x2
    80008ef2:	fc843703          	ld	a4,-56(s0)
    80008ef6:	97ba                	add	a5,a5,a4
    80008ef8:	439c                	lw	a5,0(a5)
    80008efa:	853e                	mv	a0,a5
    80008efc:	00000097          	auipc	ra,0x0
    80008f00:	e64080e7          	jalr	-412(ra) # 80008d60 <free_desc>
      for(int j = 0; j < i; j++)
    80008f04:	fd842783          	lw	a5,-40(s0)
    80008f08:	2785                	addiw	a5,a5,1
    80008f0a:	fcf42c23          	sw	a5,-40(s0)
    80008f0e:	fd842783          	lw	a5,-40(s0)
    80008f12:	873e                	mv	a4,a5
    80008f14:	fdc42783          	lw	a5,-36(s0)
    80008f18:	2701                	sext.w	a4,a4
    80008f1a:	2781                	sext.w	a5,a5
    80008f1c:	fcf748e3          	blt	a4,a5,80008eec <alloc3_desc+0x46>
      return -1;
    80008f20:	57fd                	li	a5,-1
    80008f22:	a831                	j	80008f3e <alloc3_desc+0x98>
  for(int i = 0; i < 3; i++){
    80008f24:	fdc42783          	lw	a5,-36(s0)
    80008f28:	2785                	addiw	a5,a5,1
    80008f2a:	fcf42e23          	sw	a5,-36(s0)
    80008f2e:	fdc42783          	lw	a5,-36(s0)
    80008f32:	0007871b          	sext.w	a4,a5
    80008f36:	4789                	li	a5,2
    80008f38:	f8e7d1e3          	bge	a5,a4,80008eba <alloc3_desc+0x14>
    }
  }
  return 0;
    80008f3c:	4781                	li	a5,0
}
    80008f3e:	853e                	mv	a0,a5
    80008f40:	70e2                	ld	ra,56(sp)
    80008f42:	7442                	ld	s0,48(sp)
    80008f44:	74a2                	ld	s1,40(sp)
    80008f46:	6121                	addi	sp,sp,64
    80008f48:	8082                	ret

0000000080008f4a <virtio_disk_rw>:

void
virtio_disk_rw(struct buf *b, int write)
{
    80008f4a:	7139                	addi	sp,sp,-64
    80008f4c:	fc06                	sd	ra,56(sp)
    80008f4e:	f822                	sd	s0,48(sp)
    80008f50:	0080                	addi	s0,sp,64
    80008f52:	fca43423          	sd	a0,-56(s0)
    80008f56:	87ae                	mv	a5,a1
    80008f58:	fcf42223          	sw	a5,-60(s0)
  uint64 sector = b->blockno * (BSIZE / 512);
    80008f5c:	fc843783          	ld	a5,-56(s0)
    80008f60:	47dc                	lw	a5,12(a5)
    80008f62:	0017979b          	slliw	a5,a5,0x1
    80008f66:	2781                	sext.w	a5,a5
    80008f68:	1782                	slli	a5,a5,0x20
    80008f6a:	9381                	srli	a5,a5,0x20
    80008f6c:	fef43423          	sd	a5,-24(s0)

  acquire(&disk.vdisk_lock);
    80008f70:	0001c517          	auipc	a0,0x1c
    80008f74:	dc050513          	addi	a0,a0,-576 # 80024d30 <disk+0x128>
    80008f78:	ffff8097          	auipc	ra,0xffff8
    80008f7c:	34c080e7          	jalr	844(ra) # 800012c4 <acquire>
  // data, one for a 1-byte status result.

  // allocate the three descriptors.
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
    80008f80:	fd040793          	addi	a5,s0,-48
    80008f84:	853e                	mv	a0,a5
    80008f86:	00000097          	auipc	ra,0x0
    80008f8a:	f20080e7          	jalr	-224(ra) # 80008ea6 <alloc3_desc>
    80008f8e:	87aa                	mv	a5,a0
    80008f90:	cf91                	beqz	a5,80008fac <virtio_disk_rw+0x62>
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80008f92:	0001c597          	auipc	a1,0x1c
    80008f96:	d9e58593          	addi	a1,a1,-610 # 80024d30 <disk+0x128>
    80008f9a:	0001c517          	auipc	a0,0x1c
    80008f9e:	c8650513          	addi	a0,a0,-890 # 80024c20 <disk+0x18>
    80008fa2:	ffffa097          	auipc	ra,0xffffa
    80008fa6:	4d4080e7          	jalr	1236(ra) # 80003476 <sleep>
    if(alloc3_desc(idx) == 0) {
    80008faa:	bfd9                	j	80008f80 <virtio_disk_rw+0x36>
      break;
    80008fac:	0001                	nop
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80008fae:	fd042783          	lw	a5,-48(s0)
    80008fb2:	07a9                	addi	a5,a5,10
    80008fb4:	00479713          	slli	a4,a5,0x4
    80008fb8:	0001c797          	auipc	a5,0x1c
    80008fbc:	c5078793          	addi	a5,a5,-944 # 80024c08 <disk>
    80008fc0:	97ba                	add	a5,a5,a4
    80008fc2:	07a1                	addi	a5,a5,8
    80008fc4:	fef43023          	sd	a5,-32(s0)

  if(write)
    80008fc8:	fc442783          	lw	a5,-60(s0)
    80008fcc:	2781                	sext.w	a5,a5
    80008fce:	c791                	beqz	a5,80008fda <virtio_disk_rw+0x90>
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80008fd0:	fe043783          	ld	a5,-32(s0)
    80008fd4:	4705                	li	a4,1
    80008fd6:	c398                	sw	a4,0(a5)
    80008fd8:	a029                	j	80008fe2 <virtio_disk_rw+0x98>
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80008fda:	fe043783          	ld	a5,-32(s0)
    80008fde:	0007a023          	sw	zero,0(a5)
  buf0->reserved = 0;
    80008fe2:	fe043783          	ld	a5,-32(s0)
    80008fe6:	0007a223          	sw	zero,4(a5)
  buf0->sector = sector;
    80008fea:	fe043783          	ld	a5,-32(s0)
    80008fee:	fe843703          	ld	a4,-24(s0)
    80008ff2:	e798                	sd	a4,8(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80008ff4:	0001c797          	auipc	a5,0x1c
    80008ff8:	c1478793          	addi	a5,a5,-1004 # 80024c08 <disk>
    80008ffc:	6398                	ld	a4,0(a5)
    80008ffe:	fd042783          	lw	a5,-48(s0)
    80009002:	0792                	slli	a5,a5,0x4
    80009004:	97ba                	add	a5,a5,a4
    80009006:	fe043703          	ld	a4,-32(s0)
    8000900a:	e398                	sd	a4,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000900c:	0001c797          	auipc	a5,0x1c
    80009010:	bfc78793          	addi	a5,a5,-1028 # 80024c08 <disk>
    80009014:	6398                	ld	a4,0(a5)
    80009016:	fd042783          	lw	a5,-48(s0)
    8000901a:	0792                	slli	a5,a5,0x4
    8000901c:	97ba                	add	a5,a5,a4
    8000901e:	4741                	li	a4,16
    80009020:	c798                	sw	a4,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80009022:	0001c797          	auipc	a5,0x1c
    80009026:	be678793          	addi	a5,a5,-1050 # 80024c08 <disk>
    8000902a:	6398                	ld	a4,0(a5)
    8000902c:	fd042783          	lw	a5,-48(s0)
    80009030:	0792                	slli	a5,a5,0x4
    80009032:	97ba                	add	a5,a5,a4
    80009034:	4705                	li	a4,1
    80009036:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[0]].next = idx[1];
    8000903a:	fd442683          	lw	a3,-44(s0)
    8000903e:	0001c797          	auipc	a5,0x1c
    80009042:	bca78793          	addi	a5,a5,-1078 # 80024c08 <disk>
    80009046:	6398                	ld	a4,0(a5)
    80009048:	fd042783          	lw	a5,-48(s0)
    8000904c:	0792                	slli	a5,a5,0x4
    8000904e:	97ba                	add	a5,a5,a4
    80009050:	03069713          	slli	a4,a3,0x30
    80009054:	9341                	srli	a4,a4,0x30
    80009056:	00e79723          	sh	a4,14(a5)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000905a:	fc843783          	ld	a5,-56(s0)
    8000905e:	05878693          	addi	a3,a5,88
    80009062:	0001c797          	auipc	a5,0x1c
    80009066:	ba678793          	addi	a5,a5,-1114 # 80024c08 <disk>
    8000906a:	6398                	ld	a4,0(a5)
    8000906c:	fd442783          	lw	a5,-44(s0)
    80009070:	0792                	slli	a5,a5,0x4
    80009072:	97ba                	add	a5,a5,a4
    80009074:	8736                	mv	a4,a3
    80009076:	e398                	sd	a4,0(a5)
  disk.desc[idx[1]].len = BSIZE;
    80009078:	0001c797          	auipc	a5,0x1c
    8000907c:	b9078793          	addi	a5,a5,-1136 # 80024c08 <disk>
    80009080:	6398                	ld	a4,0(a5)
    80009082:	fd442783          	lw	a5,-44(s0)
    80009086:	0792                	slli	a5,a5,0x4
    80009088:	97ba                	add	a5,a5,a4
    8000908a:	40000713          	li	a4,1024
    8000908e:	c798                	sw	a4,8(a5)
  if(write)
    80009090:	fc442783          	lw	a5,-60(s0)
    80009094:	2781                	sext.w	a5,a5
    80009096:	cf89                	beqz	a5,800090b0 <virtio_disk_rw+0x166>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80009098:	0001c797          	auipc	a5,0x1c
    8000909c:	b7078793          	addi	a5,a5,-1168 # 80024c08 <disk>
    800090a0:	6398                	ld	a4,0(a5)
    800090a2:	fd442783          	lw	a5,-44(s0)
    800090a6:	0792                	slli	a5,a5,0x4
    800090a8:	97ba                	add	a5,a5,a4
    800090aa:	00079623          	sh	zero,12(a5)
    800090ae:	a829                	j	800090c8 <virtio_disk_rw+0x17e>
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800090b0:	0001c797          	auipc	a5,0x1c
    800090b4:	b5878793          	addi	a5,a5,-1192 # 80024c08 <disk>
    800090b8:	6398                	ld	a4,0(a5)
    800090ba:	fd442783          	lw	a5,-44(s0)
    800090be:	0792                	slli	a5,a5,0x4
    800090c0:	97ba                	add	a5,a5,a4
    800090c2:	4709                	li	a4,2
    800090c4:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800090c8:	0001c797          	auipc	a5,0x1c
    800090cc:	b4078793          	addi	a5,a5,-1216 # 80024c08 <disk>
    800090d0:	6398                	ld	a4,0(a5)
    800090d2:	fd442783          	lw	a5,-44(s0)
    800090d6:	0792                	slli	a5,a5,0x4
    800090d8:	97ba                	add	a5,a5,a4
    800090da:	00c7d703          	lhu	a4,12(a5)
    800090de:	0001c797          	auipc	a5,0x1c
    800090e2:	b2a78793          	addi	a5,a5,-1238 # 80024c08 <disk>
    800090e6:	6394                	ld	a3,0(a5)
    800090e8:	fd442783          	lw	a5,-44(s0)
    800090ec:	0792                	slli	a5,a5,0x4
    800090ee:	97b6                	add	a5,a5,a3
    800090f0:	00176713          	ori	a4,a4,1
    800090f4:	1742                	slli	a4,a4,0x30
    800090f6:	9341                	srli	a4,a4,0x30
    800090f8:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[1]].next = idx[2];
    800090fc:	fd842683          	lw	a3,-40(s0)
    80009100:	0001c797          	auipc	a5,0x1c
    80009104:	b0878793          	addi	a5,a5,-1272 # 80024c08 <disk>
    80009108:	6398                	ld	a4,0(a5)
    8000910a:	fd442783          	lw	a5,-44(s0)
    8000910e:	0792                	slli	a5,a5,0x4
    80009110:	97ba                	add	a5,a5,a4
    80009112:	03069713          	slli	a4,a3,0x30
    80009116:	9341                	srli	a4,a4,0x30
    80009118:	00e79723          	sh	a4,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000911c:	fd042783          	lw	a5,-48(s0)
    80009120:	0001c717          	auipc	a4,0x1c
    80009124:	ae870713          	addi	a4,a4,-1304 # 80024c08 <disk>
    80009128:	0789                	addi	a5,a5,2
    8000912a:	0792                	slli	a5,a5,0x4
    8000912c:	97ba                	add	a5,a5,a4
    8000912e:	577d                	li	a4,-1
    80009130:	00e78823          	sb	a4,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80009134:	fd042783          	lw	a5,-48(s0)
    80009138:	0789                	addi	a5,a5,2
    8000913a:	00479713          	slli	a4,a5,0x4
    8000913e:	0001c797          	auipc	a5,0x1c
    80009142:	aca78793          	addi	a5,a5,-1334 # 80024c08 <disk>
    80009146:	97ba                	add	a5,a5,a4
    80009148:	01078693          	addi	a3,a5,16
    8000914c:	0001c797          	auipc	a5,0x1c
    80009150:	abc78793          	addi	a5,a5,-1348 # 80024c08 <disk>
    80009154:	6398                	ld	a4,0(a5)
    80009156:	fd842783          	lw	a5,-40(s0)
    8000915a:	0792                	slli	a5,a5,0x4
    8000915c:	97ba                	add	a5,a5,a4
    8000915e:	8736                	mv	a4,a3
    80009160:	e398                	sd	a4,0(a5)
  disk.desc[idx[2]].len = 1;
    80009162:	0001c797          	auipc	a5,0x1c
    80009166:	aa678793          	addi	a5,a5,-1370 # 80024c08 <disk>
    8000916a:	6398                	ld	a4,0(a5)
    8000916c:	fd842783          	lw	a5,-40(s0)
    80009170:	0792                	slli	a5,a5,0x4
    80009172:	97ba                	add	a5,a5,a4
    80009174:	4705                	li	a4,1
    80009176:	c798                	sw	a4,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80009178:	0001c797          	auipc	a5,0x1c
    8000917c:	a9078793          	addi	a5,a5,-1392 # 80024c08 <disk>
    80009180:	6398                	ld	a4,0(a5)
    80009182:	fd842783          	lw	a5,-40(s0)
    80009186:	0792                	slli	a5,a5,0x4
    80009188:	97ba                	add	a5,a5,a4
    8000918a:	4709                	li	a4,2
    8000918c:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[2]].next = 0;
    80009190:	0001c797          	auipc	a5,0x1c
    80009194:	a7878793          	addi	a5,a5,-1416 # 80024c08 <disk>
    80009198:	6398                	ld	a4,0(a5)
    8000919a:	fd842783          	lw	a5,-40(s0)
    8000919e:	0792                	slli	a5,a5,0x4
    800091a0:	97ba                	add	a5,a5,a4
    800091a2:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800091a6:	fc843783          	ld	a5,-56(s0)
    800091aa:	4705                	li	a4,1
    800091ac:	c3d8                	sw	a4,4(a5)
  disk.info[idx[0]].b = b;
    800091ae:	fd042783          	lw	a5,-48(s0)
    800091b2:	0001c717          	auipc	a4,0x1c
    800091b6:	a5670713          	addi	a4,a4,-1450 # 80024c08 <disk>
    800091ba:	0789                	addi	a5,a5,2
    800091bc:	0792                	slli	a5,a5,0x4
    800091be:	97ba                	add	a5,a5,a4
    800091c0:	fc843703          	ld	a4,-56(s0)
    800091c4:	e798                	sd	a4,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800091c6:	fd042703          	lw	a4,-48(s0)
    800091ca:	0001c797          	auipc	a5,0x1c
    800091ce:	a3e78793          	addi	a5,a5,-1474 # 80024c08 <disk>
    800091d2:	6794                	ld	a3,8(a5)
    800091d4:	0001c797          	auipc	a5,0x1c
    800091d8:	a3478793          	addi	a5,a5,-1484 # 80024c08 <disk>
    800091dc:	679c                	ld	a5,8(a5)
    800091de:	0027d783          	lhu	a5,2(a5)
    800091e2:	2781                	sext.w	a5,a5
    800091e4:	8b9d                	andi	a5,a5,7
    800091e6:	2781                	sext.w	a5,a5
    800091e8:	1742                	slli	a4,a4,0x30
    800091ea:	9341                	srli	a4,a4,0x30
    800091ec:	0786                	slli	a5,a5,0x1
    800091ee:	97b6                	add	a5,a5,a3
    800091f0:	00e79223          	sh	a4,4(a5)

  __sync_synchronize();
    800091f4:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800091f8:	0001c797          	auipc	a5,0x1c
    800091fc:	a1078793          	addi	a5,a5,-1520 # 80024c08 <disk>
    80009200:	679c                	ld	a5,8(a5)
    80009202:	0027d703          	lhu	a4,2(a5)
    80009206:	0001c797          	auipc	a5,0x1c
    8000920a:	a0278793          	addi	a5,a5,-1534 # 80024c08 <disk>
    8000920e:	679c                	ld	a5,8(a5)
    80009210:	2705                	addiw	a4,a4,1
    80009212:	1742                	slli	a4,a4,0x30
    80009214:	9341                	srli	a4,a4,0x30
    80009216:	00e79123          	sh	a4,2(a5)

  __sync_synchronize();
    8000921a:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000921e:	100017b7          	lui	a5,0x10001
    80009222:	05078793          	addi	a5,a5,80 # 10001050 <_entry-0x6fffefb0>
    80009226:	0007a023          	sw	zero,0(a5)

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000922a:	a819                	j	80009240 <virtio_disk_rw+0x2f6>
    sleep(b, &disk.vdisk_lock);
    8000922c:	0001c597          	auipc	a1,0x1c
    80009230:	b0458593          	addi	a1,a1,-1276 # 80024d30 <disk+0x128>
    80009234:	fc843503          	ld	a0,-56(s0)
    80009238:	ffffa097          	auipc	ra,0xffffa
    8000923c:	23e080e7          	jalr	574(ra) # 80003476 <sleep>
  while(b->disk == 1) {
    80009240:	fc843783          	ld	a5,-56(s0)
    80009244:	43d8                	lw	a4,4(a5)
    80009246:	4785                	li	a5,1
    80009248:	fef702e3          	beq	a4,a5,8000922c <virtio_disk_rw+0x2e2>
  }

  disk.info[idx[0]].b = 0;
    8000924c:	fd042783          	lw	a5,-48(s0)
    80009250:	0001c717          	auipc	a4,0x1c
    80009254:	9b870713          	addi	a4,a4,-1608 # 80024c08 <disk>
    80009258:	0789                	addi	a5,a5,2
    8000925a:	0792                	slli	a5,a5,0x4
    8000925c:	97ba                	add	a5,a5,a4
    8000925e:	0007b423          	sd	zero,8(a5)
  free_chain(idx[0]);
    80009262:	fd042783          	lw	a5,-48(s0)
    80009266:	853e                	mv	a0,a5
    80009268:	00000097          	auipc	ra,0x0
    8000926c:	bce080e7          	jalr	-1074(ra) # 80008e36 <free_chain>

  release(&disk.vdisk_lock);
    80009270:	0001c517          	auipc	a0,0x1c
    80009274:	ac050513          	addi	a0,a0,-1344 # 80024d30 <disk+0x128>
    80009278:	ffff8097          	auipc	ra,0xffff8
    8000927c:	0b0080e7          	jalr	176(ra) # 80001328 <release>
}
    80009280:	0001                	nop
    80009282:	70e2                	ld	ra,56(sp)
    80009284:	7442                	ld	s0,48(sp)
    80009286:	6121                	addi	sp,sp,64
    80009288:	8082                	ret

000000008000928a <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000928a:	1101                	addi	sp,sp,-32
    8000928c:	ec06                	sd	ra,24(sp)
    8000928e:	e822                	sd	s0,16(sp)
    80009290:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80009292:	0001c517          	auipc	a0,0x1c
    80009296:	a9e50513          	addi	a0,a0,-1378 # 80024d30 <disk+0x128>
    8000929a:	ffff8097          	auipc	ra,0xffff8
    8000929e:	02a080e7          	jalr	42(ra) # 800012c4 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800092a2:	100017b7          	lui	a5,0x10001
    800092a6:	06078793          	addi	a5,a5,96 # 10001060 <_entry-0x6fffefa0>
    800092aa:	439c                	lw	a5,0(a5)
    800092ac:	0007871b          	sext.w	a4,a5
    800092b0:	100017b7          	lui	a5,0x10001
    800092b4:	06478793          	addi	a5,a5,100 # 10001064 <_entry-0x6fffef9c>
    800092b8:	8b0d                	andi	a4,a4,3
    800092ba:	2701                	sext.w	a4,a4
    800092bc:	c398                	sw	a4,0(a5)

  __sync_synchronize();
    800092be:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800092c2:	a045                	j	80009362 <virtio_disk_intr+0xd8>
    __sync_synchronize();
    800092c4:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800092c8:	0001c797          	auipc	a5,0x1c
    800092cc:	94078793          	addi	a5,a5,-1728 # 80024c08 <disk>
    800092d0:	6b98                	ld	a4,16(a5)
    800092d2:	0001c797          	auipc	a5,0x1c
    800092d6:	93678793          	addi	a5,a5,-1738 # 80024c08 <disk>
    800092da:	0207d783          	lhu	a5,32(a5)
    800092de:	2781                	sext.w	a5,a5
    800092e0:	8b9d                	andi	a5,a5,7
    800092e2:	2781                	sext.w	a5,a5
    800092e4:	078e                	slli	a5,a5,0x3
    800092e6:	97ba                	add	a5,a5,a4
    800092e8:	43dc                	lw	a5,4(a5)
    800092ea:	fef42623          	sw	a5,-20(s0)

    if(disk.info[id].status != 0)
    800092ee:	0001c717          	auipc	a4,0x1c
    800092f2:	91a70713          	addi	a4,a4,-1766 # 80024c08 <disk>
    800092f6:	fec42783          	lw	a5,-20(s0)
    800092fa:	0789                	addi	a5,a5,2
    800092fc:	0792                	slli	a5,a5,0x4
    800092fe:	97ba                	add	a5,a5,a4
    80009300:	0107c783          	lbu	a5,16(a5)
    80009304:	cb89                	beqz	a5,80009316 <virtio_disk_intr+0x8c>
      panic("virtio_disk_intr status");
    80009306:	00002517          	auipc	a0,0x2
    8000930a:	43a50513          	addi	a0,a0,1082 # 8000b740 <etext+0x740>
    8000930e:	ffff8097          	auipc	ra,0xffff8
    80009312:	9b2080e7          	jalr	-1614(ra) # 80000cc0 <panic>

    struct buf *b = disk.info[id].b;
    80009316:	0001c717          	auipc	a4,0x1c
    8000931a:	8f270713          	addi	a4,a4,-1806 # 80024c08 <disk>
    8000931e:	fec42783          	lw	a5,-20(s0)
    80009322:	0789                	addi	a5,a5,2
    80009324:	0792                	slli	a5,a5,0x4
    80009326:	97ba                	add	a5,a5,a4
    80009328:	679c                	ld	a5,8(a5)
    8000932a:	fef43023          	sd	a5,-32(s0)
    b->disk = 0;   // disk is done with buf
    8000932e:	fe043783          	ld	a5,-32(s0)
    80009332:	0007a223          	sw	zero,4(a5)
    wakeup(b);
    80009336:	fe043503          	ld	a0,-32(s0)
    8000933a:	ffffa097          	auipc	ra,0xffffa
    8000933e:	1b8080e7          	jalr	440(ra) # 800034f2 <wakeup>

    disk.used_idx += 1;
    80009342:	0001c797          	auipc	a5,0x1c
    80009346:	8c678793          	addi	a5,a5,-1850 # 80024c08 <disk>
    8000934a:	0207d783          	lhu	a5,32(a5)
    8000934e:	2785                	addiw	a5,a5,1
    80009350:	03079713          	slli	a4,a5,0x30
    80009354:	9341                	srli	a4,a4,0x30
    80009356:	0001c797          	auipc	a5,0x1c
    8000935a:	8b278793          	addi	a5,a5,-1870 # 80024c08 <disk>
    8000935e:	02e79023          	sh	a4,32(a5)
  while(disk.used_idx != disk.used->idx){
    80009362:	0001c797          	auipc	a5,0x1c
    80009366:	8a678793          	addi	a5,a5,-1882 # 80024c08 <disk>
    8000936a:	0207d703          	lhu	a4,32(a5)
    8000936e:	0001c797          	auipc	a5,0x1c
    80009372:	89a78793          	addi	a5,a5,-1894 # 80024c08 <disk>
    80009376:	6b9c                	ld	a5,16(a5)
    80009378:	0027d783          	lhu	a5,2(a5)
    8000937c:	2701                	sext.w	a4,a4
    8000937e:	2781                	sext.w	a5,a5
    80009380:	f4f712e3          	bne	a4,a5,800092c4 <virtio_disk_intr+0x3a>
  }

  release(&disk.vdisk_lock);
    80009384:	0001c517          	auipc	a0,0x1c
    80009388:	9ac50513          	addi	a0,a0,-1620 # 80024d30 <disk+0x128>
    8000938c:	ffff8097          	auipc	ra,0xffff8
    80009390:	f9c080e7          	jalr	-100(ra) # 80001328 <release>
}
    80009394:	0001                	nop
    80009396:	60e2                	ld	ra,24(sp)
    80009398:	6442                	ld	s0,16(sp)
    8000939a:	6105                	addi	sp,sp,32
    8000939c:	8082                	ret
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
