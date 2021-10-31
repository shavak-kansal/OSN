
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	ab813103          	ld	sp,-1352(sp) # 80008ab8 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	076000ef          	jal	ra,8000008c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	9732                	add	a4,a4,a2
    80000046:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00259693          	slli	a3,a1,0x2
    8000004c:	96ae                	add	a3,a3,a1
    8000004e:	068e                	slli	a3,a3,0x3
    80000050:	00009717          	auipc	a4,0x9
    80000054:	ff070713          	addi	a4,a4,-16 # 80009040 <timer_scratch>
    80000058:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005c:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000005e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000062:	00006797          	auipc	a5,0x6
    80000066:	2be78793          	addi	a5,a5,702 # 80006320 <timervec>
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
    80000086:	6422                	ld	s0,8(sp)
    80000088:	0141                	addi	sp,sp,16
    8000008a:	8082                	ret

000000008000008c <start>:
{
    8000008c:	1141                	addi	sp,sp,-16
    8000008e:	e406                	sd	ra,8(sp)
    80000090:	e022                	sd	s0,0(sp)
    80000092:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000094:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000098:	7779                	lui	a4,0xffffe
    8000009a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd67ff>
    8000009e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a0:	6705                	lui	a4,0x1
    800000a2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ac:	00001797          	auipc	a5,0x1
    800000b0:	dc678793          	addi	a5,a5,-570 # 80000e72 <main>
    800000b4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b8:	4781                	li	a5,0
    800000ba:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000be:	67c1                	lui	a5,0x10
    800000c0:	17fd                	addi	a5,a5,-1
    800000c2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000ca:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000ce:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d6:	57fd                	li	a5,-1
    800000d8:	83a9                	srli	a5,a5,0xa
    800000da:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000de:	47bd                	li	a5,15
    800000e0:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e4:	00000097          	auipc	ra,0x0
    800000e8:	f38080e7          	jalr	-200(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ec:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000f2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f4:	30200073          	mret
}
    800000f8:	60a2                	ld	ra,8(sp)
    800000fa:	6402                	ld	s0,0(sp)
    800000fc:	0141                	addi	sp,sp,16
    800000fe:	8082                	ret

0000000080000100 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80000100:	715d                	addi	sp,sp,-80
    80000102:	e486                	sd	ra,72(sp)
    80000104:	e0a2                	sd	s0,64(sp)
    80000106:	fc26                	sd	s1,56(sp)
    80000108:	f84a                	sd	s2,48(sp)
    8000010a:	f44e                	sd	s3,40(sp)
    8000010c:	f052                	sd	s4,32(sp)
    8000010e:	ec56                	sd	s5,24(sp)
    80000110:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80000112:	04c05763          	blez	a2,80000160 <consolewrite+0x60>
    80000116:	8a2a                	mv	s4,a0
    80000118:	84ae                	mv	s1,a1
    8000011a:	89b2                	mv	s3,a2
    8000011c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000011e:	5afd                	li	s5,-1
    80000120:	4685                	li	a3,1
    80000122:	8626                	mv	a2,s1
    80000124:	85d2                	mv	a1,s4
    80000126:	fbf40513          	addi	a0,s0,-65
    8000012a:	00002097          	auipc	ra,0x2
    8000012e:	3ba080e7          	jalr	954(ra) # 800024e4 <either_copyin>
    80000132:	01550d63          	beq	a0,s5,8000014c <consolewrite+0x4c>
      break;
    uartputc(c);
    80000136:	fbf44503          	lbu	a0,-65(s0)
    8000013a:	00000097          	auipc	ra,0x0
    8000013e:	77e080e7          	jalr	1918(ra) # 800008b8 <uartputc>
  for(i = 0; i < n; i++){
    80000142:	2905                	addiw	s2,s2,1
    80000144:	0485                	addi	s1,s1,1
    80000146:	fd299de3          	bne	s3,s2,80000120 <consolewrite+0x20>
    8000014a:	894e                	mv	s2,s3
  }

  return i;
}
    8000014c:	854a                	mv	a0,s2
    8000014e:	60a6                	ld	ra,72(sp)
    80000150:	6406                	ld	s0,64(sp)
    80000152:	74e2                	ld	s1,56(sp)
    80000154:	7942                	ld	s2,48(sp)
    80000156:	79a2                	ld	s3,40(sp)
    80000158:	7a02                	ld	s4,32(sp)
    8000015a:	6ae2                	ld	s5,24(sp)
    8000015c:	6161                	addi	sp,sp,80
    8000015e:	8082                	ret
  for(i = 0; i < n; i++){
    80000160:	4901                	li	s2,0
    80000162:	b7ed                	j	8000014c <consolewrite+0x4c>

0000000080000164 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000164:	7159                	addi	sp,sp,-112
    80000166:	f486                	sd	ra,104(sp)
    80000168:	f0a2                	sd	s0,96(sp)
    8000016a:	eca6                	sd	s1,88(sp)
    8000016c:	e8ca                	sd	s2,80(sp)
    8000016e:	e4ce                	sd	s3,72(sp)
    80000170:	e0d2                	sd	s4,64(sp)
    80000172:	fc56                	sd	s5,56(sp)
    80000174:	f85a                	sd	s6,48(sp)
    80000176:	f45e                	sd	s7,40(sp)
    80000178:	f062                	sd	s8,32(sp)
    8000017a:	ec66                	sd	s9,24(sp)
    8000017c:	e86a                	sd	s10,16(sp)
    8000017e:	1880                	addi	s0,sp,112
    80000180:	8aaa                	mv	s5,a0
    80000182:	8a2e                	mv	s4,a1
    80000184:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000186:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000018a:	00011517          	auipc	a0,0x11
    8000018e:	ff650513          	addi	a0,a0,-10 # 80011180 <cons>
    80000192:	00001097          	auipc	ra,0x1
    80000196:	a3e080e7          	jalr	-1474(ra) # 80000bd0 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019a:	00011497          	auipc	s1,0x11
    8000019e:	fe648493          	addi	s1,s1,-26 # 80011180 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a2:	00011917          	auipc	s2,0x11
    800001a6:	07690913          	addi	s2,s2,118 # 80011218 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800001aa:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001ac:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001ae:	4ca9                	li	s9,10
  while(n > 0){
    800001b0:	07305863          	blez	s3,80000220 <consoleread+0xbc>
    while(cons.r == cons.w){
    800001b4:	0984a783          	lw	a5,152(s1)
    800001b8:	09c4a703          	lw	a4,156(s1)
    800001bc:	02f71463          	bne	a4,a5,800001e4 <consoleread+0x80>
      if(myproc()->killed){
    800001c0:	00002097          	auipc	ra,0x2
    800001c4:	818080e7          	jalr	-2024(ra) # 800019d8 <myproc>
    800001c8:	551c                	lw	a5,40(a0)
    800001ca:	e7b5                	bnez	a5,80000236 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    800001cc:	85a6                	mv	a1,s1
    800001ce:	854a                	mv	a0,s2
    800001d0:	00002097          	auipc	ra,0x2
    800001d4:	eee080e7          	jalr	-274(ra) # 800020be <sleep>
    while(cons.r == cons.w){
    800001d8:	0984a783          	lw	a5,152(s1)
    800001dc:	09c4a703          	lw	a4,156(s1)
    800001e0:	fef700e3          	beq	a4,a5,800001c0 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800001e4:	0017871b          	addiw	a4,a5,1
    800001e8:	08e4ac23          	sw	a4,152(s1)
    800001ec:	07f7f713          	andi	a4,a5,127
    800001f0:	9726                	add	a4,a4,s1
    800001f2:	01874703          	lbu	a4,24(a4)
    800001f6:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    800001fa:	077d0563          	beq	s10,s7,80000264 <consoleread+0x100>
    cbuf = c;
    800001fe:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000202:	4685                	li	a3,1
    80000204:	f9f40613          	addi	a2,s0,-97
    80000208:	85d2                	mv	a1,s4
    8000020a:	8556                	mv	a0,s5
    8000020c:	00002097          	auipc	ra,0x2
    80000210:	282080e7          	jalr	642(ra) # 8000248e <either_copyout>
    80000214:	01850663          	beq	a0,s8,80000220 <consoleread+0xbc>
    dst++;
    80000218:	0a05                	addi	s4,s4,1
    --n;
    8000021a:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    8000021c:	f99d1ae3          	bne	s10,s9,800001b0 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80000220:	00011517          	auipc	a0,0x11
    80000224:	f6050513          	addi	a0,a0,-160 # 80011180 <cons>
    80000228:	00001097          	auipc	ra,0x1
    8000022c:	a5c080e7          	jalr	-1444(ra) # 80000c84 <release>

  return target - n;
    80000230:	413b053b          	subw	a0,s6,s3
    80000234:	a811                	j	80000248 <consoleread+0xe4>
        release(&cons.lock);
    80000236:	00011517          	auipc	a0,0x11
    8000023a:	f4a50513          	addi	a0,a0,-182 # 80011180 <cons>
    8000023e:	00001097          	auipc	ra,0x1
    80000242:	a46080e7          	jalr	-1466(ra) # 80000c84 <release>
        return -1;
    80000246:	557d                	li	a0,-1
}
    80000248:	70a6                	ld	ra,104(sp)
    8000024a:	7406                	ld	s0,96(sp)
    8000024c:	64e6                	ld	s1,88(sp)
    8000024e:	6946                	ld	s2,80(sp)
    80000250:	69a6                	ld	s3,72(sp)
    80000252:	6a06                	ld	s4,64(sp)
    80000254:	7ae2                	ld	s5,56(sp)
    80000256:	7b42                	ld	s6,48(sp)
    80000258:	7ba2                	ld	s7,40(sp)
    8000025a:	7c02                	ld	s8,32(sp)
    8000025c:	6ce2                	ld	s9,24(sp)
    8000025e:	6d42                	ld	s10,16(sp)
    80000260:	6165                	addi	sp,sp,112
    80000262:	8082                	ret
      if(n < target){
    80000264:	0009871b          	sext.w	a4,s3
    80000268:	fb677ce3          	bgeu	a4,s6,80000220 <consoleread+0xbc>
        cons.r--;
    8000026c:	00011717          	auipc	a4,0x11
    80000270:	faf72623          	sw	a5,-84(a4) # 80011218 <cons+0x98>
    80000274:	b775                	j	80000220 <consoleread+0xbc>

0000000080000276 <consputc>:
{
    80000276:	1141                	addi	sp,sp,-16
    80000278:	e406                	sd	ra,8(sp)
    8000027a:	e022                	sd	s0,0(sp)
    8000027c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000027e:	10000793          	li	a5,256
    80000282:	00f50a63          	beq	a0,a5,80000296 <consputc+0x20>
    uartputc_sync(c);
    80000286:	00000097          	auipc	ra,0x0
    8000028a:	560080e7          	jalr	1376(ra) # 800007e6 <uartputc_sync>
}
    8000028e:	60a2                	ld	ra,8(sp)
    80000290:	6402                	ld	s0,0(sp)
    80000292:	0141                	addi	sp,sp,16
    80000294:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000296:	4521                	li	a0,8
    80000298:	00000097          	auipc	ra,0x0
    8000029c:	54e080e7          	jalr	1358(ra) # 800007e6 <uartputc_sync>
    800002a0:	02000513          	li	a0,32
    800002a4:	00000097          	auipc	ra,0x0
    800002a8:	542080e7          	jalr	1346(ra) # 800007e6 <uartputc_sync>
    800002ac:	4521                	li	a0,8
    800002ae:	00000097          	auipc	ra,0x0
    800002b2:	538080e7          	jalr	1336(ra) # 800007e6 <uartputc_sync>
    800002b6:	bfe1                	j	8000028e <consputc+0x18>

00000000800002b8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002b8:	1101                	addi	sp,sp,-32
    800002ba:	ec06                	sd	ra,24(sp)
    800002bc:	e822                	sd	s0,16(sp)
    800002be:	e426                	sd	s1,8(sp)
    800002c0:	e04a                	sd	s2,0(sp)
    800002c2:	1000                	addi	s0,sp,32
    800002c4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002c6:	00011517          	auipc	a0,0x11
    800002ca:	eba50513          	addi	a0,a0,-326 # 80011180 <cons>
    800002ce:	00001097          	auipc	ra,0x1
    800002d2:	902080e7          	jalr	-1790(ra) # 80000bd0 <acquire>

  switch(c){
    800002d6:	47d5                	li	a5,21
    800002d8:	0af48663          	beq	s1,a5,80000384 <consoleintr+0xcc>
    800002dc:	0297ca63          	blt	a5,s1,80000310 <consoleintr+0x58>
    800002e0:	47a1                	li	a5,8
    800002e2:	0ef48763          	beq	s1,a5,800003d0 <consoleintr+0x118>
    800002e6:	47c1                	li	a5,16
    800002e8:	10f49a63          	bne	s1,a5,800003fc <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002ec:	00002097          	auipc	ra,0x2
    800002f0:	24e080e7          	jalr	590(ra) # 8000253a <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002f4:	00011517          	auipc	a0,0x11
    800002f8:	e8c50513          	addi	a0,a0,-372 # 80011180 <cons>
    800002fc:	00001097          	auipc	ra,0x1
    80000300:	988080e7          	jalr	-1656(ra) # 80000c84 <release>
}
    80000304:	60e2                	ld	ra,24(sp)
    80000306:	6442                	ld	s0,16(sp)
    80000308:	64a2                	ld	s1,8(sp)
    8000030a:	6902                	ld	s2,0(sp)
    8000030c:	6105                	addi	sp,sp,32
    8000030e:	8082                	ret
  switch(c){
    80000310:	07f00793          	li	a5,127
    80000314:	0af48e63          	beq	s1,a5,800003d0 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000318:	00011717          	auipc	a4,0x11
    8000031c:	e6870713          	addi	a4,a4,-408 # 80011180 <cons>
    80000320:	0a072783          	lw	a5,160(a4)
    80000324:	09872703          	lw	a4,152(a4)
    80000328:	9f99                	subw	a5,a5,a4
    8000032a:	07f00713          	li	a4,127
    8000032e:	fcf763e3          	bltu	a4,a5,800002f4 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000332:	47b5                	li	a5,13
    80000334:	0cf48763          	beq	s1,a5,80000402 <consoleintr+0x14a>
      consputc(c);
    80000338:	8526                	mv	a0,s1
    8000033a:	00000097          	auipc	ra,0x0
    8000033e:	f3c080e7          	jalr	-196(ra) # 80000276 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000342:	00011797          	auipc	a5,0x11
    80000346:	e3e78793          	addi	a5,a5,-450 # 80011180 <cons>
    8000034a:	0a07a703          	lw	a4,160(a5)
    8000034e:	0017069b          	addiw	a3,a4,1
    80000352:	0006861b          	sext.w	a2,a3
    80000356:	0ad7a023          	sw	a3,160(a5)
    8000035a:	07f77713          	andi	a4,a4,127
    8000035e:	97ba                	add	a5,a5,a4
    80000360:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80000364:	47a9                	li	a5,10
    80000366:	0cf48563          	beq	s1,a5,80000430 <consoleintr+0x178>
    8000036a:	4791                	li	a5,4
    8000036c:	0cf48263          	beq	s1,a5,80000430 <consoleintr+0x178>
    80000370:	00011797          	auipc	a5,0x11
    80000374:	ea87a783          	lw	a5,-344(a5) # 80011218 <cons+0x98>
    80000378:	0807879b          	addiw	a5,a5,128
    8000037c:	f6f61ce3          	bne	a2,a5,800002f4 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000380:	863e                	mv	a2,a5
    80000382:	a07d                	j	80000430 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80000384:	00011717          	auipc	a4,0x11
    80000388:	dfc70713          	addi	a4,a4,-516 # 80011180 <cons>
    8000038c:	0a072783          	lw	a5,160(a4)
    80000390:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80000394:	00011497          	auipc	s1,0x11
    80000398:	dec48493          	addi	s1,s1,-532 # 80011180 <cons>
    while(cons.e != cons.w &&
    8000039c:	4929                	li	s2,10
    8000039e:	f4f70be3          	beq	a4,a5,800002f4 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003a2:	37fd                	addiw	a5,a5,-1
    800003a4:	07f7f713          	andi	a4,a5,127
    800003a8:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003aa:	01874703          	lbu	a4,24(a4)
    800003ae:	f52703e3          	beq	a4,s2,800002f4 <consoleintr+0x3c>
      cons.e--;
    800003b2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003b6:	10000513          	li	a0,256
    800003ba:	00000097          	auipc	ra,0x0
    800003be:	ebc080e7          	jalr	-324(ra) # 80000276 <consputc>
    while(cons.e != cons.w &&
    800003c2:	0a04a783          	lw	a5,160(s1)
    800003c6:	09c4a703          	lw	a4,156(s1)
    800003ca:	fcf71ce3          	bne	a4,a5,800003a2 <consoleintr+0xea>
    800003ce:	b71d                	j	800002f4 <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003d0:	00011717          	auipc	a4,0x11
    800003d4:	db070713          	addi	a4,a4,-592 # 80011180 <cons>
    800003d8:	0a072783          	lw	a5,160(a4)
    800003dc:	09c72703          	lw	a4,156(a4)
    800003e0:	f0f70ae3          	beq	a4,a5,800002f4 <consoleintr+0x3c>
      cons.e--;
    800003e4:	37fd                	addiw	a5,a5,-1
    800003e6:	00011717          	auipc	a4,0x11
    800003ea:	e2f72d23          	sw	a5,-454(a4) # 80011220 <cons+0xa0>
      consputc(BACKSPACE);
    800003ee:	10000513          	li	a0,256
    800003f2:	00000097          	auipc	ra,0x0
    800003f6:	e84080e7          	jalr	-380(ra) # 80000276 <consputc>
    800003fa:	bded                	j	800002f4 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    800003fc:	ee048ce3          	beqz	s1,800002f4 <consoleintr+0x3c>
    80000400:	bf21                	j	80000318 <consoleintr+0x60>
      consputc(c);
    80000402:	4529                	li	a0,10
    80000404:	00000097          	auipc	ra,0x0
    80000408:	e72080e7          	jalr	-398(ra) # 80000276 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    8000040c:	00011797          	auipc	a5,0x11
    80000410:	d7478793          	addi	a5,a5,-652 # 80011180 <cons>
    80000414:	0a07a703          	lw	a4,160(a5)
    80000418:	0017069b          	addiw	a3,a4,1
    8000041c:	0006861b          	sext.w	a2,a3
    80000420:	0ad7a023          	sw	a3,160(a5)
    80000424:	07f77713          	andi	a4,a4,127
    80000428:	97ba                	add	a5,a5,a4
    8000042a:	4729                	li	a4,10
    8000042c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000430:	00011797          	auipc	a5,0x11
    80000434:	dec7a623          	sw	a2,-532(a5) # 8001121c <cons+0x9c>
        wakeup(&cons.r);
    80000438:	00011517          	auipc	a0,0x11
    8000043c:	de050513          	addi	a0,a0,-544 # 80011218 <cons+0x98>
    80000440:	00002097          	auipc	ra,0x2
    80000444:	e0a080e7          	jalr	-502(ra) # 8000224a <wakeup>
    80000448:	b575                	j	800002f4 <consoleintr+0x3c>

000000008000044a <consoleinit>:

void
consoleinit(void)
{
    8000044a:	1141                	addi	sp,sp,-16
    8000044c:	e406                	sd	ra,8(sp)
    8000044e:	e022                	sd	s0,0(sp)
    80000450:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000452:	00008597          	auipc	a1,0x8
    80000456:	bbe58593          	addi	a1,a1,-1090 # 80008010 <etext+0x10>
    8000045a:	00011517          	auipc	a0,0x11
    8000045e:	d2650513          	addi	a0,a0,-730 # 80011180 <cons>
    80000462:	00000097          	auipc	ra,0x0
    80000466:	6de080e7          	jalr	1758(ra) # 80000b40 <initlock>

  uartinit();
    8000046a:	00000097          	auipc	ra,0x0
    8000046e:	32c080e7          	jalr	812(ra) # 80000796 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000472:	00024797          	auipc	a5,0x24
    80000476:	8ce78793          	addi	a5,a5,-1842 # 80023d40 <devsw>
    8000047a:	00000717          	auipc	a4,0x0
    8000047e:	cea70713          	addi	a4,a4,-790 # 80000164 <consoleread>
    80000482:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000484:	00000717          	auipc	a4,0x0
    80000488:	c7c70713          	addi	a4,a4,-900 # 80000100 <consolewrite>
    8000048c:	ef98                	sd	a4,24(a5)
}
    8000048e:	60a2                	ld	ra,8(sp)
    80000490:	6402                	ld	s0,0(sp)
    80000492:	0141                	addi	sp,sp,16
    80000494:	8082                	ret

0000000080000496 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80000496:	7179                	addi	sp,sp,-48
    80000498:	f406                	sd	ra,40(sp)
    8000049a:	f022                	sd	s0,32(sp)
    8000049c:	ec26                	sd	s1,24(sp)
    8000049e:	e84a                	sd	s2,16(sp)
    800004a0:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004a2:	c219                	beqz	a2,800004a8 <printint+0x12>
    800004a4:	08054763          	bltz	a0,80000532 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    800004a8:	2501                	sext.w	a0,a0
    800004aa:	4881                	li	a7,0
    800004ac:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004b0:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004b2:	2581                	sext.w	a1,a1
    800004b4:	00008617          	auipc	a2,0x8
    800004b8:	b8c60613          	addi	a2,a2,-1140 # 80008040 <digits>
    800004bc:	883a                	mv	a6,a4
    800004be:	2705                	addiw	a4,a4,1
    800004c0:	02b577bb          	remuw	a5,a0,a1
    800004c4:	1782                	slli	a5,a5,0x20
    800004c6:	9381                	srli	a5,a5,0x20
    800004c8:	97b2                	add	a5,a5,a2
    800004ca:	0007c783          	lbu	a5,0(a5)
    800004ce:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004d2:	0005079b          	sext.w	a5,a0
    800004d6:	02b5553b          	divuw	a0,a0,a1
    800004da:	0685                	addi	a3,a3,1
    800004dc:	feb7f0e3          	bgeu	a5,a1,800004bc <printint+0x26>

  if(sign)
    800004e0:	00088c63          	beqz	a7,800004f8 <printint+0x62>
    buf[i++] = '-';
    800004e4:	fe070793          	addi	a5,a4,-32
    800004e8:	00878733          	add	a4,a5,s0
    800004ec:	02d00793          	li	a5,45
    800004f0:	fef70823          	sb	a5,-16(a4)
    800004f4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800004f8:	02e05763          	blez	a4,80000526 <printint+0x90>
    800004fc:	fd040793          	addi	a5,s0,-48
    80000500:	00e784b3          	add	s1,a5,a4
    80000504:	fff78913          	addi	s2,a5,-1
    80000508:	993a                	add	s2,s2,a4
    8000050a:	377d                	addiw	a4,a4,-1
    8000050c:	1702                	slli	a4,a4,0x20
    8000050e:	9301                	srli	a4,a4,0x20
    80000510:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000514:	fff4c503          	lbu	a0,-1(s1)
    80000518:	00000097          	auipc	ra,0x0
    8000051c:	d5e080e7          	jalr	-674(ra) # 80000276 <consputc>
  while(--i >= 0)
    80000520:	14fd                	addi	s1,s1,-1
    80000522:	ff2499e3          	bne	s1,s2,80000514 <printint+0x7e>
}
    80000526:	70a2                	ld	ra,40(sp)
    80000528:	7402                	ld	s0,32(sp)
    8000052a:	64e2                	ld	s1,24(sp)
    8000052c:	6942                	ld	s2,16(sp)
    8000052e:	6145                	addi	sp,sp,48
    80000530:	8082                	ret
    x = -xx;
    80000532:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80000536:	4885                	li	a7,1
    x = -xx;
    80000538:	bf95                	j	800004ac <printint+0x16>

000000008000053a <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000053a:	1101                	addi	sp,sp,-32
    8000053c:	ec06                	sd	ra,24(sp)
    8000053e:	e822                	sd	s0,16(sp)
    80000540:	e426                	sd	s1,8(sp)
    80000542:	1000                	addi	s0,sp,32
    80000544:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000546:	00011797          	auipc	a5,0x11
    8000054a:	ce07ad23          	sw	zero,-774(a5) # 80011240 <pr+0x18>
  printf("panic: ");
    8000054e:	00008517          	auipc	a0,0x8
    80000552:	aca50513          	addi	a0,a0,-1334 # 80008018 <etext+0x18>
    80000556:	00000097          	auipc	ra,0x0
    8000055a:	02e080e7          	jalr	46(ra) # 80000584 <printf>
  printf(s);
    8000055e:	8526                	mv	a0,s1
    80000560:	00000097          	auipc	ra,0x0
    80000564:	024080e7          	jalr	36(ra) # 80000584 <printf>
  printf("\n");
    80000568:	00008517          	auipc	a0,0x8
    8000056c:	f1850513          	addi	a0,a0,-232 # 80008480 <states.0+0x170>
    80000570:	00000097          	auipc	ra,0x0
    80000574:	014080e7          	jalr	20(ra) # 80000584 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000578:	4785                	li	a5,1
    8000057a:	00009717          	auipc	a4,0x9
    8000057e:	a8f72323          	sw	a5,-1402(a4) # 80009000 <panicked>
  for(;;)
    80000582:	a001                	j	80000582 <panic+0x48>

0000000080000584 <printf>:
{
    80000584:	7131                	addi	sp,sp,-192
    80000586:	fc86                	sd	ra,120(sp)
    80000588:	f8a2                	sd	s0,112(sp)
    8000058a:	f4a6                	sd	s1,104(sp)
    8000058c:	f0ca                	sd	s2,96(sp)
    8000058e:	ecce                	sd	s3,88(sp)
    80000590:	e8d2                	sd	s4,80(sp)
    80000592:	e4d6                	sd	s5,72(sp)
    80000594:	e0da                	sd	s6,64(sp)
    80000596:	fc5e                	sd	s7,56(sp)
    80000598:	f862                	sd	s8,48(sp)
    8000059a:	f466                	sd	s9,40(sp)
    8000059c:	f06a                	sd	s10,32(sp)
    8000059e:	ec6e                	sd	s11,24(sp)
    800005a0:	0100                	addi	s0,sp,128
    800005a2:	8a2a                	mv	s4,a0
    800005a4:	e40c                	sd	a1,8(s0)
    800005a6:	e810                	sd	a2,16(s0)
    800005a8:	ec14                	sd	a3,24(s0)
    800005aa:	f018                	sd	a4,32(s0)
    800005ac:	f41c                	sd	a5,40(s0)
    800005ae:	03043823          	sd	a6,48(s0)
    800005b2:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005b6:	00011d97          	auipc	s11,0x11
    800005ba:	c8adad83          	lw	s11,-886(s11) # 80011240 <pr+0x18>
  if(locking)
    800005be:	020d9b63          	bnez	s11,800005f4 <printf+0x70>
  if (fmt == 0)
    800005c2:	040a0263          	beqz	s4,80000606 <printf+0x82>
  va_start(ap, fmt);
    800005c6:	00840793          	addi	a5,s0,8
    800005ca:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005ce:	000a4503          	lbu	a0,0(s4)
    800005d2:	14050f63          	beqz	a0,80000730 <printf+0x1ac>
    800005d6:	4981                	li	s3,0
    if(c != '%'){
    800005d8:	02500a93          	li	s5,37
    switch(c){
    800005dc:	07000b93          	li	s7,112
  consputc('x');
    800005e0:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005e2:	00008b17          	auipc	s6,0x8
    800005e6:	a5eb0b13          	addi	s6,s6,-1442 # 80008040 <digits>
    switch(c){
    800005ea:	07300c93          	li	s9,115
    800005ee:	06400c13          	li	s8,100
    800005f2:	a82d                	j	8000062c <printf+0xa8>
    acquire(&pr.lock);
    800005f4:	00011517          	auipc	a0,0x11
    800005f8:	c3450513          	addi	a0,a0,-972 # 80011228 <pr>
    800005fc:	00000097          	auipc	ra,0x0
    80000600:	5d4080e7          	jalr	1492(ra) # 80000bd0 <acquire>
    80000604:	bf7d                	j	800005c2 <printf+0x3e>
    panic("null fmt");
    80000606:	00008517          	auipc	a0,0x8
    8000060a:	a2250513          	addi	a0,a0,-1502 # 80008028 <etext+0x28>
    8000060e:	00000097          	auipc	ra,0x0
    80000612:	f2c080e7          	jalr	-212(ra) # 8000053a <panic>
      consputc(c);
    80000616:	00000097          	auipc	ra,0x0
    8000061a:	c60080e7          	jalr	-928(ra) # 80000276 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000061e:	2985                	addiw	s3,s3,1
    80000620:	013a07b3          	add	a5,s4,s3
    80000624:	0007c503          	lbu	a0,0(a5)
    80000628:	10050463          	beqz	a0,80000730 <printf+0x1ac>
    if(c != '%'){
    8000062c:	ff5515e3          	bne	a0,s5,80000616 <printf+0x92>
    c = fmt[++i] & 0xff;
    80000630:	2985                	addiw	s3,s3,1
    80000632:	013a07b3          	add	a5,s4,s3
    80000636:	0007c783          	lbu	a5,0(a5)
    8000063a:	0007849b          	sext.w	s1,a5
    if(c == 0)
    8000063e:	cbed                	beqz	a5,80000730 <printf+0x1ac>
    switch(c){
    80000640:	05778a63          	beq	a5,s7,80000694 <printf+0x110>
    80000644:	02fbf663          	bgeu	s7,a5,80000670 <printf+0xec>
    80000648:	09978863          	beq	a5,s9,800006d8 <printf+0x154>
    8000064c:	07800713          	li	a4,120
    80000650:	0ce79563          	bne	a5,a4,8000071a <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80000654:	f8843783          	ld	a5,-120(s0)
    80000658:	00878713          	addi	a4,a5,8
    8000065c:	f8e43423          	sd	a4,-120(s0)
    80000660:	4605                	li	a2,1
    80000662:	85ea                	mv	a1,s10
    80000664:	4388                	lw	a0,0(a5)
    80000666:	00000097          	auipc	ra,0x0
    8000066a:	e30080e7          	jalr	-464(ra) # 80000496 <printint>
      break;
    8000066e:	bf45                	j	8000061e <printf+0x9a>
    switch(c){
    80000670:	09578f63          	beq	a5,s5,8000070e <printf+0x18a>
    80000674:	0b879363          	bne	a5,s8,8000071a <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80000678:	f8843783          	ld	a5,-120(s0)
    8000067c:	00878713          	addi	a4,a5,8
    80000680:	f8e43423          	sd	a4,-120(s0)
    80000684:	4605                	li	a2,1
    80000686:	45a9                	li	a1,10
    80000688:	4388                	lw	a0,0(a5)
    8000068a:	00000097          	auipc	ra,0x0
    8000068e:	e0c080e7          	jalr	-500(ra) # 80000496 <printint>
      break;
    80000692:	b771                	j	8000061e <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80000694:	f8843783          	ld	a5,-120(s0)
    80000698:	00878713          	addi	a4,a5,8
    8000069c:	f8e43423          	sd	a4,-120(s0)
    800006a0:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006a4:	03000513          	li	a0,48
    800006a8:	00000097          	auipc	ra,0x0
    800006ac:	bce080e7          	jalr	-1074(ra) # 80000276 <consputc>
  consputc('x');
    800006b0:	07800513          	li	a0,120
    800006b4:	00000097          	auipc	ra,0x0
    800006b8:	bc2080e7          	jalr	-1086(ra) # 80000276 <consputc>
    800006bc:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006be:	03c95793          	srli	a5,s2,0x3c
    800006c2:	97da                	add	a5,a5,s6
    800006c4:	0007c503          	lbu	a0,0(a5)
    800006c8:	00000097          	auipc	ra,0x0
    800006cc:	bae080e7          	jalr	-1106(ra) # 80000276 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006d0:	0912                	slli	s2,s2,0x4
    800006d2:	34fd                	addiw	s1,s1,-1
    800006d4:	f4ed                	bnez	s1,800006be <printf+0x13a>
    800006d6:	b7a1                	j	8000061e <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006d8:	f8843783          	ld	a5,-120(s0)
    800006dc:	00878713          	addi	a4,a5,8
    800006e0:	f8e43423          	sd	a4,-120(s0)
    800006e4:	6384                	ld	s1,0(a5)
    800006e6:	cc89                	beqz	s1,80000700 <printf+0x17c>
      for(; *s; s++)
    800006e8:	0004c503          	lbu	a0,0(s1)
    800006ec:	d90d                	beqz	a0,8000061e <printf+0x9a>
        consputc(*s);
    800006ee:	00000097          	auipc	ra,0x0
    800006f2:	b88080e7          	jalr	-1144(ra) # 80000276 <consputc>
      for(; *s; s++)
    800006f6:	0485                	addi	s1,s1,1
    800006f8:	0004c503          	lbu	a0,0(s1)
    800006fc:	f96d                	bnez	a0,800006ee <printf+0x16a>
    800006fe:	b705                	j	8000061e <printf+0x9a>
        s = "(null)";
    80000700:	00008497          	auipc	s1,0x8
    80000704:	92048493          	addi	s1,s1,-1760 # 80008020 <etext+0x20>
      for(; *s; s++)
    80000708:	02800513          	li	a0,40
    8000070c:	b7cd                	j	800006ee <printf+0x16a>
      consputc('%');
    8000070e:	8556                	mv	a0,s5
    80000710:	00000097          	auipc	ra,0x0
    80000714:	b66080e7          	jalr	-1178(ra) # 80000276 <consputc>
      break;
    80000718:	b719                	j	8000061e <printf+0x9a>
      consputc('%');
    8000071a:	8556                	mv	a0,s5
    8000071c:	00000097          	auipc	ra,0x0
    80000720:	b5a080e7          	jalr	-1190(ra) # 80000276 <consputc>
      consputc(c);
    80000724:	8526                	mv	a0,s1
    80000726:	00000097          	auipc	ra,0x0
    8000072a:	b50080e7          	jalr	-1200(ra) # 80000276 <consputc>
      break;
    8000072e:	bdc5                	j	8000061e <printf+0x9a>
  if(locking)
    80000730:	020d9163          	bnez	s11,80000752 <printf+0x1ce>
}
    80000734:	70e6                	ld	ra,120(sp)
    80000736:	7446                	ld	s0,112(sp)
    80000738:	74a6                	ld	s1,104(sp)
    8000073a:	7906                	ld	s2,96(sp)
    8000073c:	69e6                	ld	s3,88(sp)
    8000073e:	6a46                	ld	s4,80(sp)
    80000740:	6aa6                	ld	s5,72(sp)
    80000742:	6b06                	ld	s6,64(sp)
    80000744:	7be2                	ld	s7,56(sp)
    80000746:	7c42                	ld	s8,48(sp)
    80000748:	7ca2                	ld	s9,40(sp)
    8000074a:	7d02                	ld	s10,32(sp)
    8000074c:	6de2                	ld	s11,24(sp)
    8000074e:	6129                	addi	sp,sp,192
    80000750:	8082                	ret
    release(&pr.lock);
    80000752:	00011517          	auipc	a0,0x11
    80000756:	ad650513          	addi	a0,a0,-1322 # 80011228 <pr>
    8000075a:	00000097          	auipc	ra,0x0
    8000075e:	52a080e7          	jalr	1322(ra) # 80000c84 <release>
}
    80000762:	bfc9                	j	80000734 <printf+0x1b0>

0000000080000764 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000764:	1101                	addi	sp,sp,-32
    80000766:	ec06                	sd	ra,24(sp)
    80000768:	e822                	sd	s0,16(sp)
    8000076a:	e426                	sd	s1,8(sp)
    8000076c:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000076e:	00011497          	auipc	s1,0x11
    80000772:	aba48493          	addi	s1,s1,-1350 # 80011228 <pr>
    80000776:	00008597          	auipc	a1,0x8
    8000077a:	8c258593          	addi	a1,a1,-1854 # 80008038 <etext+0x38>
    8000077e:	8526                	mv	a0,s1
    80000780:	00000097          	auipc	ra,0x0
    80000784:	3c0080e7          	jalr	960(ra) # 80000b40 <initlock>
  pr.locking = 1;
    80000788:	4785                	li	a5,1
    8000078a:	cc9c                	sw	a5,24(s1)
}
    8000078c:	60e2                	ld	ra,24(sp)
    8000078e:	6442                	ld	s0,16(sp)
    80000790:	64a2                	ld	s1,8(sp)
    80000792:	6105                	addi	sp,sp,32
    80000794:	8082                	ret

0000000080000796 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80000796:	1141                	addi	sp,sp,-16
    80000798:	e406                	sd	ra,8(sp)
    8000079a:	e022                	sd	s0,0(sp)
    8000079c:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000079e:	100007b7          	lui	a5,0x10000
    800007a2:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007a6:	f8000713          	li	a4,-128
    800007aa:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007ae:	470d                	li	a4,3
    800007b0:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007b4:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007b8:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007bc:	469d                	li	a3,7
    800007be:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007c2:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007c6:	00008597          	auipc	a1,0x8
    800007ca:	89258593          	addi	a1,a1,-1902 # 80008058 <digits+0x18>
    800007ce:	00011517          	auipc	a0,0x11
    800007d2:	a7a50513          	addi	a0,a0,-1414 # 80011248 <uart_tx_lock>
    800007d6:	00000097          	auipc	ra,0x0
    800007da:	36a080e7          	jalr	874(ra) # 80000b40 <initlock>
}
    800007de:	60a2                	ld	ra,8(sp)
    800007e0:	6402                	ld	s0,0(sp)
    800007e2:	0141                	addi	sp,sp,16
    800007e4:	8082                	ret

00000000800007e6 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007e6:	1101                	addi	sp,sp,-32
    800007e8:	ec06                	sd	ra,24(sp)
    800007ea:	e822                	sd	s0,16(sp)
    800007ec:	e426                	sd	s1,8(sp)
    800007ee:	1000                	addi	s0,sp,32
    800007f0:	84aa                	mv	s1,a0
  push_off();
    800007f2:	00000097          	auipc	ra,0x0
    800007f6:	392080e7          	jalr	914(ra) # 80000b84 <push_off>

  if(panicked){
    800007fa:	00009797          	auipc	a5,0x9
    800007fe:	8067a783          	lw	a5,-2042(a5) # 80009000 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000802:	10000737          	lui	a4,0x10000
  if(panicked){
    80000806:	c391                	beqz	a5,8000080a <uartputc_sync+0x24>
    for(;;)
    80000808:	a001                	j	80000808 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000080a:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000080e:	0207f793          	andi	a5,a5,32
    80000812:	dfe5                	beqz	a5,8000080a <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000814:	0ff4f513          	zext.b	a0,s1
    80000818:	100007b7          	lui	a5,0x10000
    8000081c:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000820:	00000097          	auipc	ra,0x0
    80000824:	404080e7          	jalr	1028(ra) # 80000c24 <pop_off>
}
    80000828:	60e2                	ld	ra,24(sp)
    8000082a:	6442                	ld	s0,16(sp)
    8000082c:	64a2                	ld	s1,8(sp)
    8000082e:	6105                	addi	sp,sp,32
    80000830:	8082                	ret

0000000080000832 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000832:	00008797          	auipc	a5,0x8
    80000836:	7d67b783          	ld	a5,2006(a5) # 80009008 <uart_tx_r>
    8000083a:	00008717          	auipc	a4,0x8
    8000083e:	7d673703          	ld	a4,2006(a4) # 80009010 <uart_tx_w>
    80000842:	06f70a63          	beq	a4,a5,800008b6 <uartstart+0x84>
{
    80000846:	7139                	addi	sp,sp,-64
    80000848:	fc06                	sd	ra,56(sp)
    8000084a:	f822                	sd	s0,48(sp)
    8000084c:	f426                	sd	s1,40(sp)
    8000084e:	f04a                	sd	s2,32(sp)
    80000850:	ec4e                	sd	s3,24(sp)
    80000852:	e852                	sd	s4,16(sp)
    80000854:	e456                	sd	s5,8(sp)
    80000856:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000858:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000085c:	00011a17          	auipc	s4,0x11
    80000860:	9eca0a13          	addi	s4,s4,-1556 # 80011248 <uart_tx_lock>
    uart_tx_r += 1;
    80000864:	00008497          	auipc	s1,0x8
    80000868:	7a448493          	addi	s1,s1,1956 # 80009008 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000086c:	00008997          	auipc	s3,0x8
    80000870:	7a498993          	addi	s3,s3,1956 # 80009010 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000874:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80000878:	02077713          	andi	a4,a4,32
    8000087c:	c705                	beqz	a4,800008a4 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000087e:	01f7f713          	andi	a4,a5,31
    80000882:	9752                	add	a4,a4,s4
    80000884:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80000888:	0785                	addi	a5,a5,1
    8000088a:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    8000088c:	8526                	mv	a0,s1
    8000088e:	00002097          	auipc	ra,0x2
    80000892:	9bc080e7          	jalr	-1604(ra) # 8000224a <wakeup>
    
    WriteReg(THR, c);
    80000896:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000089a:	609c                	ld	a5,0(s1)
    8000089c:	0009b703          	ld	a4,0(s3)
    800008a0:	fcf71ae3          	bne	a4,a5,80000874 <uartstart+0x42>
  }
}
    800008a4:	70e2                	ld	ra,56(sp)
    800008a6:	7442                	ld	s0,48(sp)
    800008a8:	74a2                	ld	s1,40(sp)
    800008aa:	7902                	ld	s2,32(sp)
    800008ac:	69e2                	ld	s3,24(sp)
    800008ae:	6a42                	ld	s4,16(sp)
    800008b0:	6aa2                	ld	s5,8(sp)
    800008b2:	6121                	addi	sp,sp,64
    800008b4:	8082                	ret
    800008b6:	8082                	ret

00000000800008b8 <uartputc>:
{
    800008b8:	7179                	addi	sp,sp,-48
    800008ba:	f406                	sd	ra,40(sp)
    800008bc:	f022                	sd	s0,32(sp)
    800008be:	ec26                	sd	s1,24(sp)
    800008c0:	e84a                	sd	s2,16(sp)
    800008c2:	e44e                	sd	s3,8(sp)
    800008c4:	e052                	sd	s4,0(sp)
    800008c6:	1800                	addi	s0,sp,48
    800008c8:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800008ca:	00011517          	auipc	a0,0x11
    800008ce:	97e50513          	addi	a0,a0,-1666 # 80011248 <uart_tx_lock>
    800008d2:	00000097          	auipc	ra,0x0
    800008d6:	2fe080e7          	jalr	766(ra) # 80000bd0 <acquire>
  if(panicked){
    800008da:	00008797          	auipc	a5,0x8
    800008de:	7267a783          	lw	a5,1830(a5) # 80009000 <panicked>
    800008e2:	c391                	beqz	a5,800008e6 <uartputc+0x2e>
    for(;;)
    800008e4:	a001                	j	800008e4 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008e6:	00008717          	auipc	a4,0x8
    800008ea:	72a73703          	ld	a4,1834(a4) # 80009010 <uart_tx_w>
    800008ee:	00008797          	auipc	a5,0x8
    800008f2:	71a7b783          	ld	a5,1818(a5) # 80009008 <uart_tx_r>
    800008f6:	02078793          	addi	a5,a5,32
    800008fa:	02e79b63          	bne	a5,a4,80000930 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    800008fe:	00011997          	auipc	s3,0x11
    80000902:	94a98993          	addi	s3,s3,-1718 # 80011248 <uart_tx_lock>
    80000906:	00008497          	auipc	s1,0x8
    8000090a:	70248493          	addi	s1,s1,1794 # 80009008 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000090e:	00008917          	auipc	s2,0x8
    80000912:	70290913          	addi	s2,s2,1794 # 80009010 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80000916:	85ce                	mv	a1,s3
    80000918:	8526                	mv	a0,s1
    8000091a:	00001097          	auipc	ra,0x1
    8000091e:	7a4080e7          	jalr	1956(ra) # 800020be <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000922:	00093703          	ld	a4,0(s2)
    80000926:	609c                	ld	a5,0(s1)
    80000928:	02078793          	addi	a5,a5,32
    8000092c:	fee785e3          	beq	a5,a4,80000916 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000930:	00011497          	auipc	s1,0x11
    80000934:	91848493          	addi	s1,s1,-1768 # 80011248 <uart_tx_lock>
    80000938:	01f77793          	andi	a5,a4,31
    8000093c:	97a6                	add	a5,a5,s1
    8000093e:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80000942:	0705                	addi	a4,a4,1
    80000944:	00008797          	auipc	a5,0x8
    80000948:	6ce7b623          	sd	a4,1740(a5) # 80009010 <uart_tx_w>
      uartstart();
    8000094c:	00000097          	auipc	ra,0x0
    80000950:	ee6080e7          	jalr	-282(ra) # 80000832 <uartstart>
      release(&uart_tx_lock);
    80000954:	8526                	mv	a0,s1
    80000956:	00000097          	auipc	ra,0x0
    8000095a:	32e080e7          	jalr	814(ra) # 80000c84 <release>
}
    8000095e:	70a2                	ld	ra,40(sp)
    80000960:	7402                	ld	s0,32(sp)
    80000962:	64e2                	ld	s1,24(sp)
    80000964:	6942                	ld	s2,16(sp)
    80000966:	69a2                	ld	s3,8(sp)
    80000968:	6a02                	ld	s4,0(sp)
    8000096a:	6145                	addi	sp,sp,48
    8000096c:	8082                	ret

000000008000096e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000096e:	1141                	addi	sp,sp,-16
    80000970:	e422                	sd	s0,8(sp)
    80000972:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000974:	100007b7          	lui	a5,0x10000
    80000978:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000097c:	8b85                	andi	a5,a5,1
    8000097e:	cb81                	beqz	a5,8000098e <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80000980:	100007b7          	lui	a5,0x10000
    80000984:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80000988:	6422                	ld	s0,8(sp)
    8000098a:	0141                	addi	sp,sp,16
    8000098c:	8082                	ret
    return -1;
    8000098e:	557d                	li	a0,-1
    80000990:	bfe5                	j	80000988 <uartgetc+0x1a>

0000000080000992 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80000992:	1101                	addi	sp,sp,-32
    80000994:	ec06                	sd	ra,24(sp)
    80000996:	e822                	sd	s0,16(sp)
    80000998:	e426                	sd	s1,8(sp)
    8000099a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000099c:	54fd                	li	s1,-1
    8000099e:	a029                	j	800009a8 <uartintr+0x16>
      break;
    consoleintr(c);
    800009a0:	00000097          	auipc	ra,0x0
    800009a4:	918080e7          	jalr	-1768(ra) # 800002b8 <consoleintr>
    int c = uartgetc();
    800009a8:	00000097          	auipc	ra,0x0
    800009ac:	fc6080e7          	jalr	-58(ra) # 8000096e <uartgetc>
    if(c == -1)
    800009b0:	fe9518e3          	bne	a0,s1,800009a0 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009b4:	00011497          	auipc	s1,0x11
    800009b8:	89448493          	addi	s1,s1,-1900 # 80011248 <uart_tx_lock>
    800009bc:	8526                	mv	a0,s1
    800009be:	00000097          	auipc	ra,0x0
    800009c2:	212080e7          	jalr	530(ra) # 80000bd0 <acquire>
  uartstart();
    800009c6:	00000097          	auipc	ra,0x0
    800009ca:	e6c080e7          	jalr	-404(ra) # 80000832 <uartstart>
  release(&uart_tx_lock);
    800009ce:	8526                	mv	a0,s1
    800009d0:	00000097          	auipc	ra,0x0
    800009d4:	2b4080e7          	jalr	692(ra) # 80000c84 <release>
}
    800009d8:	60e2                	ld	ra,24(sp)
    800009da:	6442                	ld	s0,16(sp)
    800009dc:	64a2                	ld	s1,8(sp)
    800009de:	6105                	addi	sp,sp,32
    800009e0:	8082                	ret

00000000800009e2 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800009e2:	1101                	addi	sp,sp,-32
    800009e4:	ec06                	sd	ra,24(sp)
    800009e6:	e822                	sd	s0,16(sp)
    800009e8:	e426                	sd	s1,8(sp)
    800009ea:	e04a                	sd	s2,0(sp)
    800009ec:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800009ee:	03451793          	slli	a5,a0,0x34
    800009f2:	ebb9                	bnez	a5,80000a48 <kfree+0x66>
    800009f4:	84aa                	mv	s1,a0
    800009f6:	00027797          	auipc	a5,0x27
    800009fa:	60a78793          	addi	a5,a5,1546 # 80028000 <end>
    800009fe:	04f56563          	bltu	a0,a5,80000a48 <kfree+0x66>
    80000a02:	47c5                	li	a5,17
    80000a04:	07ee                	slli	a5,a5,0x1b
    80000a06:	04f57163          	bgeu	a0,a5,80000a48 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a0a:	6605                	lui	a2,0x1
    80000a0c:	4585                	li	a1,1
    80000a0e:	00000097          	auipc	ra,0x0
    80000a12:	2be080e7          	jalr	702(ra) # 80000ccc <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a16:	00011917          	auipc	s2,0x11
    80000a1a:	86a90913          	addi	s2,s2,-1942 # 80011280 <kmem>
    80000a1e:	854a                	mv	a0,s2
    80000a20:	00000097          	auipc	ra,0x0
    80000a24:	1b0080e7          	jalr	432(ra) # 80000bd0 <acquire>
  r->next = kmem.freelist;
    80000a28:	01893783          	ld	a5,24(s2)
    80000a2c:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a2e:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a32:	854a                	mv	a0,s2
    80000a34:	00000097          	auipc	ra,0x0
    80000a38:	250080e7          	jalr	592(ra) # 80000c84 <release>
}
    80000a3c:	60e2                	ld	ra,24(sp)
    80000a3e:	6442                	ld	s0,16(sp)
    80000a40:	64a2                	ld	s1,8(sp)
    80000a42:	6902                	ld	s2,0(sp)
    80000a44:	6105                	addi	sp,sp,32
    80000a46:	8082                	ret
    panic("kfree");
    80000a48:	00007517          	auipc	a0,0x7
    80000a4c:	61850513          	addi	a0,a0,1560 # 80008060 <digits+0x20>
    80000a50:	00000097          	auipc	ra,0x0
    80000a54:	aea080e7          	jalr	-1302(ra) # 8000053a <panic>

0000000080000a58 <freerange>:
{
    80000a58:	7179                	addi	sp,sp,-48
    80000a5a:	f406                	sd	ra,40(sp)
    80000a5c:	f022                	sd	s0,32(sp)
    80000a5e:	ec26                	sd	s1,24(sp)
    80000a60:	e84a                	sd	s2,16(sp)
    80000a62:	e44e                	sd	s3,8(sp)
    80000a64:	e052                	sd	s4,0(sp)
    80000a66:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a68:	6785                	lui	a5,0x1
    80000a6a:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000a6e:	00e504b3          	add	s1,a0,a4
    80000a72:	777d                	lui	a4,0xfffff
    80000a74:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a76:	94be                	add	s1,s1,a5
    80000a78:	0095ee63          	bltu	a1,s1,80000a94 <freerange+0x3c>
    80000a7c:	892e                	mv	s2,a1
    kfree(p);
    80000a7e:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a80:	6985                	lui	s3,0x1
    kfree(p);
    80000a82:	01448533          	add	a0,s1,s4
    80000a86:	00000097          	auipc	ra,0x0
    80000a8a:	f5c080e7          	jalr	-164(ra) # 800009e2 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a8e:	94ce                	add	s1,s1,s3
    80000a90:	fe9979e3          	bgeu	s2,s1,80000a82 <freerange+0x2a>
}
    80000a94:	70a2                	ld	ra,40(sp)
    80000a96:	7402                	ld	s0,32(sp)
    80000a98:	64e2                	ld	s1,24(sp)
    80000a9a:	6942                	ld	s2,16(sp)
    80000a9c:	69a2                	ld	s3,8(sp)
    80000a9e:	6a02                	ld	s4,0(sp)
    80000aa0:	6145                	addi	sp,sp,48
    80000aa2:	8082                	ret

0000000080000aa4 <kinit>:
{
    80000aa4:	1141                	addi	sp,sp,-16
    80000aa6:	e406                	sd	ra,8(sp)
    80000aa8:	e022                	sd	s0,0(sp)
    80000aaa:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000aac:	00007597          	auipc	a1,0x7
    80000ab0:	5bc58593          	addi	a1,a1,1468 # 80008068 <digits+0x28>
    80000ab4:	00010517          	auipc	a0,0x10
    80000ab8:	7cc50513          	addi	a0,a0,1996 # 80011280 <kmem>
    80000abc:	00000097          	auipc	ra,0x0
    80000ac0:	084080e7          	jalr	132(ra) # 80000b40 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000ac4:	45c5                	li	a1,17
    80000ac6:	05ee                	slli	a1,a1,0x1b
    80000ac8:	00027517          	auipc	a0,0x27
    80000acc:	53850513          	addi	a0,a0,1336 # 80028000 <end>
    80000ad0:	00000097          	auipc	ra,0x0
    80000ad4:	f88080e7          	jalr	-120(ra) # 80000a58 <freerange>
}
    80000ad8:	60a2                	ld	ra,8(sp)
    80000ada:	6402                	ld	s0,0(sp)
    80000adc:	0141                	addi	sp,sp,16
    80000ade:	8082                	ret

0000000080000ae0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000ae0:	1101                	addi	sp,sp,-32
    80000ae2:	ec06                	sd	ra,24(sp)
    80000ae4:	e822                	sd	s0,16(sp)
    80000ae6:	e426                	sd	s1,8(sp)
    80000ae8:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000aea:	00010497          	auipc	s1,0x10
    80000aee:	79648493          	addi	s1,s1,1942 # 80011280 <kmem>
    80000af2:	8526                	mv	a0,s1
    80000af4:	00000097          	auipc	ra,0x0
    80000af8:	0dc080e7          	jalr	220(ra) # 80000bd0 <acquire>
  r = kmem.freelist;
    80000afc:	6c84                	ld	s1,24(s1)
  if(r)
    80000afe:	c885                	beqz	s1,80000b2e <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b00:	609c                	ld	a5,0(s1)
    80000b02:	00010517          	auipc	a0,0x10
    80000b06:	77e50513          	addi	a0,a0,1918 # 80011280 <kmem>
    80000b0a:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b0c:	00000097          	auipc	ra,0x0
    80000b10:	178080e7          	jalr	376(ra) # 80000c84 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b14:	6605                	lui	a2,0x1
    80000b16:	4595                	li	a1,5
    80000b18:	8526                	mv	a0,s1
    80000b1a:	00000097          	auipc	ra,0x0
    80000b1e:	1b2080e7          	jalr	434(ra) # 80000ccc <memset>
  return (void*)r;
}
    80000b22:	8526                	mv	a0,s1
    80000b24:	60e2                	ld	ra,24(sp)
    80000b26:	6442                	ld	s0,16(sp)
    80000b28:	64a2                	ld	s1,8(sp)
    80000b2a:	6105                	addi	sp,sp,32
    80000b2c:	8082                	ret
  release(&kmem.lock);
    80000b2e:	00010517          	auipc	a0,0x10
    80000b32:	75250513          	addi	a0,a0,1874 # 80011280 <kmem>
    80000b36:	00000097          	auipc	ra,0x0
    80000b3a:	14e080e7          	jalr	334(ra) # 80000c84 <release>
  if(r)
    80000b3e:	b7d5                	j	80000b22 <kalloc+0x42>

0000000080000b40 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b40:	1141                	addi	sp,sp,-16
    80000b42:	e422                	sd	s0,8(sp)
    80000b44:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b46:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b48:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b4c:	00053823          	sd	zero,16(a0)
}
    80000b50:	6422                	ld	s0,8(sp)
    80000b52:	0141                	addi	sp,sp,16
    80000b54:	8082                	ret

0000000080000b56 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b56:	411c                	lw	a5,0(a0)
    80000b58:	e399                	bnez	a5,80000b5e <holding+0x8>
    80000b5a:	4501                	li	a0,0
  return r;
}
    80000b5c:	8082                	ret
{
    80000b5e:	1101                	addi	sp,sp,-32
    80000b60:	ec06                	sd	ra,24(sp)
    80000b62:	e822                	sd	s0,16(sp)
    80000b64:	e426                	sd	s1,8(sp)
    80000b66:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b68:	6904                	ld	s1,16(a0)
    80000b6a:	00001097          	auipc	ra,0x1
    80000b6e:	e52080e7          	jalr	-430(ra) # 800019bc <mycpu>
    80000b72:	40a48533          	sub	a0,s1,a0
    80000b76:	00153513          	seqz	a0,a0
}
    80000b7a:	60e2                	ld	ra,24(sp)
    80000b7c:	6442                	ld	s0,16(sp)
    80000b7e:	64a2                	ld	s1,8(sp)
    80000b80:	6105                	addi	sp,sp,32
    80000b82:	8082                	ret

0000000080000b84 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000b84:	1101                	addi	sp,sp,-32
    80000b86:	ec06                	sd	ra,24(sp)
    80000b88:	e822                	sd	s0,16(sp)
    80000b8a:	e426                	sd	s1,8(sp)
    80000b8c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b8e:	100024f3          	csrr	s1,sstatus
    80000b92:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000b96:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000b98:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000b9c:	00001097          	auipc	ra,0x1
    80000ba0:	e20080e7          	jalr	-480(ra) # 800019bc <mycpu>
    80000ba4:	5d3c                	lw	a5,120(a0)
    80000ba6:	cf89                	beqz	a5,80000bc0 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000ba8:	00001097          	auipc	ra,0x1
    80000bac:	e14080e7          	jalr	-492(ra) # 800019bc <mycpu>
    80000bb0:	5d3c                	lw	a5,120(a0)
    80000bb2:	2785                	addiw	a5,a5,1
    80000bb4:	dd3c                	sw	a5,120(a0)
}
    80000bb6:	60e2                	ld	ra,24(sp)
    80000bb8:	6442                	ld	s0,16(sp)
    80000bba:	64a2                	ld	s1,8(sp)
    80000bbc:	6105                	addi	sp,sp,32
    80000bbe:	8082                	ret
    mycpu()->intena = old;
    80000bc0:	00001097          	auipc	ra,0x1
    80000bc4:	dfc080e7          	jalr	-516(ra) # 800019bc <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bc8:	8085                	srli	s1,s1,0x1
    80000bca:	8885                	andi	s1,s1,1
    80000bcc:	dd64                	sw	s1,124(a0)
    80000bce:	bfe9                	j	80000ba8 <push_off+0x24>

0000000080000bd0 <acquire>:
{
    80000bd0:	1101                	addi	sp,sp,-32
    80000bd2:	ec06                	sd	ra,24(sp)
    80000bd4:	e822                	sd	s0,16(sp)
    80000bd6:	e426                	sd	s1,8(sp)
    80000bd8:	1000                	addi	s0,sp,32
    80000bda:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000bdc:	00000097          	auipc	ra,0x0
    80000be0:	fa8080e7          	jalr	-88(ra) # 80000b84 <push_off>
  if(holding(lk))
    80000be4:	8526                	mv	a0,s1
    80000be6:	00000097          	auipc	ra,0x0
    80000bea:	f70080e7          	jalr	-144(ra) # 80000b56 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bee:	4705                	li	a4,1
  if(holding(lk))
    80000bf0:	e115                	bnez	a0,80000c14 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bf2:	87ba                	mv	a5,a4
    80000bf4:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000bf8:	2781                	sext.w	a5,a5
    80000bfa:	ffe5                	bnez	a5,80000bf2 <acquire+0x22>
  __sync_synchronize();
    80000bfc:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c00:	00001097          	auipc	ra,0x1
    80000c04:	dbc080e7          	jalr	-580(ra) # 800019bc <mycpu>
    80000c08:	e888                	sd	a0,16(s1)
}
    80000c0a:	60e2                	ld	ra,24(sp)
    80000c0c:	6442                	ld	s0,16(sp)
    80000c0e:	64a2                	ld	s1,8(sp)
    80000c10:	6105                	addi	sp,sp,32
    80000c12:	8082                	ret
    panic("acquire");
    80000c14:	00007517          	auipc	a0,0x7
    80000c18:	45c50513          	addi	a0,a0,1116 # 80008070 <digits+0x30>
    80000c1c:	00000097          	auipc	ra,0x0
    80000c20:	91e080e7          	jalr	-1762(ra) # 8000053a <panic>

0000000080000c24 <pop_off>:

void
pop_off(void)
{
    80000c24:	1141                	addi	sp,sp,-16
    80000c26:	e406                	sd	ra,8(sp)
    80000c28:	e022                	sd	s0,0(sp)
    80000c2a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c2c:	00001097          	auipc	ra,0x1
    80000c30:	d90080e7          	jalr	-624(ra) # 800019bc <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c34:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c38:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c3a:	e78d                	bnez	a5,80000c64 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c3c:	5d3c                	lw	a5,120(a0)
    80000c3e:	02f05b63          	blez	a5,80000c74 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000c42:	37fd                	addiw	a5,a5,-1
    80000c44:	0007871b          	sext.w	a4,a5
    80000c48:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c4a:	eb09                	bnez	a4,80000c5c <pop_off+0x38>
    80000c4c:	5d7c                	lw	a5,124(a0)
    80000c4e:	c799                	beqz	a5,80000c5c <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c50:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c54:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c58:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c5c:	60a2                	ld	ra,8(sp)
    80000c5e:	6402                	ld	s0,0(sp)
    80000c60:	0141                	addi	sp,sp,16
    80000c62:	8082                	ret
    panic("pop_off - interruptible");
    80000c64:	00007517          	auipc	a0,0x7
    80000c68:	41450513          	addi	a0,a0,1044 # 80008078 <digits+0x38>
    80000c6c:	00000097          	auipc	ra,0x0
    80000c70:	8ce080e7          	jalr	-1842(ra) # 8000053a <panic>
    panic("pop_off");
    80000c74:	00007517          	auipc	a0,0x7
    80000c78:	41c50513          	addi	a0,a0,1052 # 80008090 <digits+0x50>
    80000c7c:	00000097          	auipc	ra,0x0
    80000c80:	8be080e7          	jalr	-1858(ra) # 8000053a <panic>

0000000080000c84 <release>:
{
    80000c84:	1101                	addi	sp,sp,-32
    80000c86:	ec06                	sd	ra,24(sp)
    80000c88:	e822                	sd	s0,16(sp)
    80000c8a:	e426                	sd	s1,8(sp)
    80000c8c:	1000                	addi	s0,sp,32
    80000c8e:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c90:	00000097          	auipc	ra,0x0
    80000c94:	ec6080e7          	jalr	-314(ra) # 80000b56 <holding>
    80000c98:	c115                	beqz	a0,80000cbc <release+0x38>
  lk->cpu = 0;
    80000c9a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000c9e:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000ca2:	0f50000f          	fence	iorw,ow
    80000ca6:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000caa:	00000097          	auipc	ra,0x0
    80000cae:	f7a080e7          	jalr	-134(ra) # 80000c24 <pop_off>
}
    80000cb2:	60e2                	ld	ra,24(sp)
    80000cb4:	6442                	ld	s0,16(sp)
    80000cb6:	64a2                	ld	s1,8(sp)
    80000cb8:	6105                	addi	sp,sp,32
    80000cba:	8082                	ret
    panic("release");
    80000cbc:	00007517          	auipc	a0,0x7
    80000cc0:	3dc50513          	addi	a0,a0,988 # 80008098 <digits+0x58>
    80000cc4:	00000097          	auipc	ra,0x0
    80000cc8:	876080e7          	jalr	-1930(ra) # 8000053a <panic>

0000000080000ccc <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000ccc:	1141                	addi	sp,sp,-16
    80000cce:	e422                	sd	s0,8(sp)
    80000cd0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cd2:	ca19                	beqz	a2,80000ce8 <memset+0x1c>
    80000cd4:	87aa                	mv	a5,a0
    80000cd6:	1602                	slli	a2,a2,0x20
    80000cd8:	9201                	srli	a2,a2,0x20
    80000cda:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000cde:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000ce2:	0785                	addi	a5,a5,1
    80000ce4:	fee79de3          	bne	a5,a4,80000cde <memset+0x12>
  }
  return dst;
}
    80000ce8:	6422                	ld	s0,8(sp)
    80000cea:	0141                	addi	sp,sp,16
    80000cec:	8082                	ret

0000000080000cee <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cee:	1141                	addi	sp,sp,-16
    80000cf0:	e422                	sd	s0,8(sp)
    80000cf2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000cf4:	ca05                	beqz	a2,80000d24 <memcmp+0x36>
    80000cf6:	fff6069b          	addiw	a3,a2,-1
    80000cfa:	1682                	slli	a3,a3,0x20
    80000cfc:	9281                	srli	a3,a3,0x20
    80000cfe:	0685                	addi	a3,a3,1
    80000d00:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d02:	00054783          	lbu	a5,0(a0)
    80000d06:	0005c703          	lbu	a4,0(a1)
    80000d0a:	00e79863          	bne	a5,a4,80000d1a <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d0e:	0505                	addi	a0,a0,1
    80000d10:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d12:	fed518e3          	bne	a0,a3,80000d02 <memcmp+0x14>
  }

  return 0;
    80000d16:	4501                	li	a0,0
    80000d18:	a019                	j	80000d1e <memcmp+0x30>
      return *s1 - *s2;
    80000d1a:	40e7853b          	subw	a0,a5,a4
}
    80000d1e:	6422                	ld	s0,8(sp)
    80000d20:	0141                	addi	sp,sp,16
    80000d22:	8082                	ret
  return 0;
    80000d24:	4501                	li	a0,0
    80000d26:	bfe5                	j	80000d1e <memcmp+0x30>

0000000080000d28 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d28:	1141                	addi	sp,sp,-16
    80000d2a:	e422                	sd	s0,8(sp)
    80000d2c:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d2e:	c205                	beqz	a2,80000d4e <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d30:	02a5e263          	bltu	a1,a0,80000d54 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d34:	1602                	slli	a2,a2,0x20
    80000d36:	9201                	srli	a2,a2,0x20
    80000d38:	00c587b3          	add	a5,a1,a2
{
    80000d3c:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d3e:	0585                	addi	a1,a1,1
    80000d40:	0705                	addi	a4,a4,1
    80000d42:	fff5c683          	lbu	a3,-1(a1)
    80000d46:	fed70fa3          	sb	a3,-1(a4) # ffffffffffffefff <end+0xffffffff7ffd6fff>
    while(n-- > 0)
    80000d4a:	fef59ae3          	bne	a1,a5,80000d3e <memmove+0x16>

  return dst;
}
    80000d4e:	6422                	ld	s0,8(sp)
    80000d50:	0141                	addi	sp,sp,16
    80000d52:	8082                	ret
  if(s < d && s + n > d){
    80000d54:	02061693          	slli	a3,a2,0x20
    80000d58:	9281                	srli	a3,a3,0x20
    80000d5a:	00d58733          	add	a4,a1,a3
    80000d5e:	fce57be3          	bgeu	a0,a4,80000d34 <memmove+0xc>
    d += n;
    80000d62:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d64:	fff6079b          	addiw	a5,a2,-1
    80000d68:	1782                	slli	a5,a5,0x20
    80000d6a:	9381                	srli	a5,a5,0x20
    80000d6c:	fff7c793          	not	a5,a5
    80000d70:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d72:	177d                	addi	a4,a4,-1
    80000d74:	16fd                	addi	a3,a3,-1
    80000d76:	00074603          	lbu	a2,0(a4)
    80000d7a:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d7e:	fee79ae3          	bne	a5,a4,80000d72 <memmove+0x4a>
    80000d82:	b7f1                	j	80000d4e <memmove+0x26>

0000000080000d84 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d84:	1141                	addi	sp,sp,-16
    80000d86:	e406                	sd	ra,8(sp)
    80000d88:	e022                	sd	s0,0(sp)
    80000d8a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d8c:	00000097          	auipc	ra,0x0
    80000d90:	f9c080e7          	jalr	-100(ra) # 80000d28 <memmove>
}
    80000d94:	60a2                	ld	ra,8(sp)
    80000d96:	6402                	ld	s0,0(sp)
    80000d98:	0141                	addi	sp,sp,16
    80000d9a:	8082                	ret

0000000080000d9c <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d9c:	1141                	addi	sp,sp,-16
    80000d9e:	e422                	sd	s0,8(sp)
    80000da0:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000da2:	ce11                	beqz	a2,80000dbe <strncmp+0x22>
    80000da4:	00054783          	lbu	a5,0(a0)
    80000da8:	cf89                	beqz	a5,80000dc2 <strncmp+0x26>
    80000daa:	0005c703          	lbu	a4,0(a1)
    80000dae:	00f71a63          	bne	a4,a5,80000dc2 <strncmp+0x26>
    n--, p++, q++;
    80000db2:	367d                	addiw	a2,a2,-1
    80000db4:	0505                	addi	a0,a0,1
    80000db6:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000db8:	f675                	bnez	a2,80000da4 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000dba:	4501                	li	a0,0
    80000dbc:	a809                	j	80000dce <strncmp+0x32>
    80000dbe:	4501                	li	a0,0
    80000dc0:	a039                	j	80000dce <strncmp+0x32>
  if(n == 0)
    80000dc2:	ca09                	beqz	a2,80000dd4 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000dc4:	00054503          	lbu	a0,0(a0)
    80000dc8:	0005c783          	lbu	a5,0(a1)
    80000dcc:	9d1d                	subw	a0,a0,a5
}
    80000dce:	6422                	ld	s0,8(sp)
    80000dd0:	0141                	addi	sp,sp,16
    80000dd2:	8082                	ret
    return 0;
    80000dd4:	4501                	li	a0,0
    80000dd6:	bfe5                	j	80000dce <strncmp+0x32>

0000000080000dd8 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000dd8:	1141                	addi	sp,sp,-16
    80000dda:	e422                	sd	s0,8(sp)
    80000ddc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000dde:	872a                	mv	a4,a0
    80000de0:	8832                	mv	a6,a2
    80000de2:	367d                	addiw	a2,a2,-1
    80000de4:	01005963          	blez	a6,80000df6 <strncpy+0x1e>
    80000de8:	0705                	addi	a4,a4,1
    80000dea:	0005c783          	lbu	a5,0(a1)
    80000dee:	fef70fa3          	sb	a5,-1(a4)
    80000df2:	0585                	addi	a1,a1,1
    80000df4:	f7f5                	bnez	a5,80000de0 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000df6:	86ba                	mv	a3,a4
    80000df8:	00c05c63          	blez	a2,80000e10 <strncpy+0x38>
    *s++ = 0;
    80000dfc:	0685                	addi	a3,a3,1
    80000dfe:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000e02:	40d707bb          	subw	a5,a4,a3
    80000e06:	37fd                	addiw	a5,a5,-1
    80000e08:	010787bb          	addw	a5,a5,a6
    80000e0c:	fef048e3          	bgtz	a5,80000dfc <strncpy+0x24>
  return os;
}
    80000e10:	6422                	ld	s0,8(sp)
    80000e12:	0141                	addi	sp,sp,16
    80000e14:	8082                	ret

0000000080000e16 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e16:	1141                	addi	sp,sp,-16
    80000e18:	e422                	sd	s0,8(sp)
    80000e1a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e1c:	02c05363          	blez	a2,80000e42 <safestrcpy+0x2c>
    80000e20:	fff6069b          	addiw	a3,a2,-1
    80000e24:	1682                	slli	a3,a3,0x20
    80000e26:	9281                	srli	a3,a3,0x20
    80000e28:	96ae                	add	a3,a3,a1
    80000e2a:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e2c:	00d58963          	beq	a1,a3,80000e3e <safestrcpy+0x28>
    80000e30:	0585                	addi	a1,a1,1
    80000e32:	0785                	addi	a5,a5,1
    80000e34:	fff5c703          	lbu	a4,-1(a1)
    80000e38:	fee78fa3          	sb	a4,-1(a5)
    80000e3c:	fb65                	bnez	a4,80000e2c <safestrcpy+0x16>
    ;
  *s = 0;
    80000e3e:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e42:	6422                	ld	s0,8(sp)
    80000e44:	0141                	addi	sp,sp,16
    80000e46:	8082                	ret

0000000080000e48 <strlen>:

int
strlen(const char *s)
{
    80000e48:	1141                	addi	sp,sp,-16
    80000e4a:	e422                	sd	s0,8(sp)
    80000e4c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e4e:	00054783          	lbu	a5,0(a0)
    80000e52:	cf91                	beqz	a5,80000e6e <strlen+0x26>
    80000e54:	0505                	addi	a0,a0,1
    80000e56:	87aa                	mv	a5,a0
    80000e58:	4685                	li	a3,1
    80000e5a:	9e89                	subw	a3,a3,a0
    80000e5c:	00f6853b          	addw	a0,a3,a5
    80000e60:	0785                	addi	a5,a5,1
    80000e62:	fff7c703          	lbu	a4,-1(a5)
    80000e66:	fb7d                	bnez	a4,80000e5c <strlen+0x14>
    ;
  return n;
}
    80000e68:	6422                	ld	s0,8(sp)
    80000e6a:	0141                	addi	sp,sp,16
    80000e6c:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e6e:	4501                	li	a0,0
    80000e70:	bfe5                	j	80000e68 <strlen+0x20>

0000000080000e72 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e72:	1141                	addi	sp,sp,-16
    80000e74:	e406                	sd	ra,8(sp)
    80000e76:	e022                	sd	s0,0(sp)
    80000e78:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e7a:	00001097          	auipc	ra,0x1
    80000e7e:	b32080e7          	jalr	-1230(ra) # 800019ac <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e82:	00008717          	auipc	a4,0x8
    80000e86:	19670713          	addi	a4,a4,406 # 80009018 <started>
  if(cpuid() == 0){
    80000e8a:	c139                	beqz	a0,80000ed0 <main+0x5e>
    while(started == 0)
    80000e8c:	431c                	lw	a5,0(a4)
    80000e8e:	2781                	sext.w	a5,a5
    80000e90:	dff5                	beqz	a5,80000e8c <main+0x1a>
      ;
    __sync_synchronize();
    80000e92:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000e96:	00001097          	auipc	ra,0x1
    80000e9a:	b16080e7          	jalr	-1258(ra) # 800019ac <cpuid>
    80000e9e:	85aa                	mv	a1,a0
    80000ea0:	00007517          	auipc	a0,0x7
    80000ea4:	21850513          	addi	a0,a0,536 # 800080b8 <digits+0x78>
    80000ea8:	fffff097          	auipc	ra,0xfffff
    80000eac:	6dc080e7          	jalr	1756(ra) # 80000584 <printf>
    kvminithart();    // turn on paging
    80000eb0:	00000097          	auipc	ra,0x0
    80000eb4:	0e0080e7          	jalr	224(ra) # 80000f90 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000eb8:	00002097          	auipc	ra,0x2
    80000ebc:	c9c080e7          	jalr	-868(ra) # 80002b54 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ec0:	00005097          	auipc	ra,0x5
    80000ec4:	4a0080e7          	jalr	1184(ra) # 80006360 <plicinithart>
  }

  scheduler();        
    80000ec8:	00002097          	auipc	ra,0x2
    80000ecc:	936080e7          	jalr	-1738(ra) # 800027fe <scheduler>
    consoleinit();
    80000ed0:	fffff097          	auipc	ra,0xfffff
    80000ed4:	57a080e7          	jalr	1402(ra) # 8000044a <consoleinit>
    printfinit();
    80000ed8:	00000097          	auipc	ra,0x0
    80000edc:	88c080e7          	jalr	-1908(ra) # 80000764 <printfinit>
    printf("\n");
    80000ee0:	00007517          	auipc	a0,0x7
    80000ee4:	5a050513          	addi	a0,a0,1440 # 80008480 <states.0+0x170>
    80000ee8:	fffff097          	auipc	ra,0xfffff
    80000eec:	69c080e7          	jalr	1692(ra) # 80000584 <printf>
    printf("xv6 kernel is booting\n");
    80000ef0:	00007517          	auipc	a0,0x7
    80000ef4:	1b050513          	addi	a0,a0,432 # 800080a0 <digits+0x60>
    80000ef8:	fffff097          	auipc	ra,0xfffff
    80000efc:	68c080e7          	jalr	1676(ra) # 80000584 <printf>
    printf("\n");
    80000f00:	00007517          	auipc	a0,0x7
    80000f04:	58050513          	addi	a0,a0,1408 # 80008480 <states.0+0x170>
    80000f08:	fffff097          	auipc	ra,0xfffff
    80000f0c:	67c080e7          	jalr	1660(ra) # 80000584 <printf>
    pq_init();
    80000f10:	00001097          	auipc	ra,0x1
    80000f14:	a62080e7          	jalr	-1438(ra) # 80001972 <pq_init>
    kinit();         // physical page allocator
    80000f18:	00000097          	auipc	ra,0x0
    80000f1c:	b8c080e7          	jalr	-1140(ra) # 80000aa4 <kinit>
    kvminit();       // create kernel page table
    80000f20:	00000097          	auipc	ra,0x0
    80000f24:	322080e7          	jalr	802(ra) # 80001242 <kvminit>
    kvminithart();   // turn on paging
    80000f28:	00000097          	auipc	ra,0x0
    80000f2c:	068080e7          	jalr	104(ra) # 80000f90 <kvminithart>
    procinit();      // process table
    80000f30:	00001097          	auipc	ra,0x1
    80000f34:	992080e7          	jalr	-1646(ra) # 800018c2 <procinit>
    trapinit();      // trap vectors
    80000f38:	00002097          	auipc	ra,0x2
    80000f3c:	bf4080e7          	jalr	-1036(ra) # 80002b2c <trapinit>
    trapinithart();  // install kernel trap vector
    80000f40:	00002097          	auipc	ra,0x2
    80000f44:	c14080e7          	jalr	-1004(ra) # 80002b54 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f48:	00005097          	auipc	ra,0x5
    80000f4c:	402080e7          	jalr	1026(ra) # 8000634a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f50:	00005097          	auipc	ra,0x5
    80000f54:	410080e7          	jalr	1040(ra) # 80006360 <plicinithart>
    binit();         // buffer cache
    80000f58:	00002097          	auipc	ra,0x2
    80000f5c:	5cc080e7          	jalr	1484(ra) # 80003524 <binit>
    iinit();         // inode table
    80000f60:	00003097          	auipc	ra,0x3
    80000f64:	c5a080e7          	jalr	-934(ra) # 80003bba <iinit>
    fileinit();      // file table
    80000f68:	00004097          	auipc	ra,0x4
    80000f6c:	c0c080e7          	jalr	-1012(ra) # 80004b74 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f70:	00005097          	auipc	ra,0x5
    80000f74:	510080e7          	jalr	1296(ra) # 80006480 <virtio_disk_init>
    userinit();      // first user process
    80000f78:	00001097          	auipc	ra,0x1
    80000f7c:	d82080e7          	jalr	-638(ra) # 80001cfa <userinit>
    __sync_synchronize();
    80000f80:	0ff0000f          	fence
    started = 1;
    80000f84:	4785                	li	a5,1
    80000f86:	00008717          	auipc	a4,0x8
    80000f8a:	08f72923          	sw	a5,146(a4) # 80009018 <started>
    80000f8e:	bf2d                	j	80000ec8 <main+0x56>

0000000080000f90 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f90:	1141                	addi	sp,sp,-16
    80000f92:	e422                	sd	s0,8(sp)
    80000f94:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000f96:	00008797          	auipc	a5,0x8
    80000f9a:	08a7b783          	ld	a5,138(a5) # 80009020 <kernel_pagetable>
    80000f9e:	83b1                	srli	a5,a5,0xc
    80000fa0:	577d                	li	a4,-1
    80000fa2:	177e                	slli	a4,a4,0x3f
    80000fa4:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000fa6:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000faa:	12000073          	sfence.vma
  sfence_vma();
}
    80000fae:	6422                	ld	s0,8(sp)
    80000fb0:	0141                	addi	sp,sp,16
    80000fb2:	8082                	ret

0000000080000fb4 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000fb4:	7139                	addi	sp,sp,-64
    80000fb6:	fc06                	sd	ra,56(sp)
    80000fb8:	f822                	sd	s0,48(sp)
    80000fba:	f426                	sd	s1,40(sp)
    80000fbc:	f04a                	sd	s2,32(sp)
    80000fbe:	ec4e                	sd	s3,24(sp)
    80000fc0:	e852                	sd	s4,16(sp)
    80000fc2:	e456                	sd	s5,8(sp)
    80000fc4:	e05a                	sd	s6,0(sp)
    80000fc6:	0080                	addi	s0,sp,64
    80000fc8:	84aa                	mv	s1,a0
    80000fca:	89ae                	mv	s3,a1
    80000fcc:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000fce:	57fd                	li	a5,-1
    80000fd0:	83e9                	srli	a5,a5,0x1a
    80000fd2:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000fd4:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000fd6:	04b7f263          	bgeu	a5,a1,8000101a <walk+0x66>
    panic("walk");
    80000fda:	00007517          	auipc	a0,0x7
    80000fde:	0f650513          	addi	a0,a0,246 # 800080d0 <digits+0x90>
    80000fe2:	fffff097          	auipc	ra,0xfffff
    80000fe6:	558080e7          	jalr	1368(ra) # 8000053a <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000fea:	060a8663          	beqz	s5,80001056 <walk+0xa2>
    80000fee:	00000097          	auipc	ra,0x0
    80000ff2:	af2080e7          	jalr	-1294(ra) # 80000ae0 <kalloc>
    80000ff6:	84aa                	mv	s1,a0
    80000ff8:	c529                	beqz	a0,80001042 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000ffa:	6605                	lui	a2,0x1
    80000ffc:	4581                	li	a1,0
    80000ffe:	00000097          	auipc	ra,0x0
    80001002:	cce080e7          	jalr	-818(ra) # 80000ccc <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001006:	00c4d793          	srli	a5,s1,0xc
    8000100a:	07aa                	slli	a5,a5,0xa
    8000100c:	0017e793          	ori	a5,a5,1
    80001010:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001014:	3a5d                	addiw	s4,s4,-9
    80001016:	036a0063          	beq	s4,s6,80001036 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    8000101a:	0149d933          	srl	s2,s3,s4
    8000101e:	1ff97913          	andi	s2,s2,511
    80001022:	090e                	slli	s2,s2,0x3
    80001024:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001026:	00093483          	ld	s1,0(s2)
    8000102a:	0014f793          	andi	a5,s1,1
    8000102e:	dfd5                	beqz	a5,80000fea <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001030:	80a9                	srli	s1,s1,0xa
    80001032:	04b2                	slli	s1,s1,0xc
    80001034:	b7c5                	j	80001014 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80001036:	00c9d513          	srli	a0,s3,0xc
    8000103a:	1ff57513          	andi	a0,a0,511
    8000103e:	050e                	slli	a0,a0,0x3
    80001040:	9526                	add	a0,a0,s1
}
    80001042:	70e2                	ld	ra,56(sp)
    80001044:	7442                	ld	s0,48(sp)
    80001046:	74a2                	ld	s1,40(sp)
    80001048:	7902                	ld	s2,32(sp)
    8000104a:	69e2                	ld	s3,24(sp)
    8000104c:	6a42                	ld	s4,16(sp)
    8000104e:	6aa2                	ld	s5,8(sp)
    80001050:	6b02                	ld	s6,0(sp)
    80001052:	6121                	addi	sp,sp,64
    80001054:	8082                	ret
        return 0;
    80001056:	4501                	li	a0,0
    80001058:	b7ed                	j	80001042 <walk+0x8e>

000000008000105a <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000105a:	57fd                	li	a5,-1
    8000105c:	83e9                	srli	a5,a5,0x1a
    8000105e:	00b7f463          	bgeu	a5,a1,80001066 <walkaddr+0xc>
    return 0;
    80001062:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001064:	8082                	ret
{
    80001066:	1141                	addi	sp,sp,-16
    80001068:	e406                	sd	ra,8(sp)
    8000106a:	e022                	sd	s0,0(sp)
    8000106c:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000106e:	4601                	li	a2,0
    80001070:	00000097          	auipc	ra,0x0
    80001074:	f44080e7          	jalr	-188(ra) # 80000fb4 <walk>
  if(pte == 0)
    80001078:	c105                	beqz	a0,80001098 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000107a:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000107c:	0117f693          	andi	a3,a5,17
    80001080:	4745                	li	a4,17
    return 0;
    80001082:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001084:	00e68663          	beq	a3,a4,80001090 <walkaddr+0x36>
}
    80001088:	60a2                	ld	ra,8(sp)
    8000108a:	6402                	ld	s0,0(sp)
    8000108c:	0141                	addi	sp,sp,16
    8000108e:	8082                	ret
  pa = PTE2PA(*pte);
    80001090:	83a9                	srli	a5,a5,0xa
    80001092:	00c79513          	slli	a0,a5,0xc
  return pa;
    80001096:	bfcd                	j	80001088 <walkaddr+0x2e>
    return 0;
    80001098:	4501                	li	a0,0
    8000109a:	b7fd                	j	80001088 <walkaddr+0x2e>

000000008000109c <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000109c:	715d                	addi	sp,sp,-80
    8000109e:	e486                	sd	ra,72(sp)
    800010a0:	e0a2                	sd	s0,64(sp)
    800010a2:	fc26                	sd	s1,56(sp)
    800010a4:	f84a                	sd	s2,48(sp)
    800010a6:	f44e                	sd	s3,40(sp)
    800010a8:	f052                	sd	s4,32(sp)
    800010aa:	ec56                	sd	s5,24(sp)
    800010ac:	e85a                	sd	s6,16(sp)
    800010ae:	e45e                	sd	s7,8(sp)
    800010b0:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800010b2:	c639                	beqz	a2,80001100 <mappages+0x64>
    800010b4:	8aaa                	mv	s5,a0
    800010b6:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800010b8:	777d                	lui	a4,0xfffff
    800010ba:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800010be:	fff58993          	addi	s3,a1,-1
    800010c2:	99b2                	add	s3,s3,a2
    800010c4:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800010c8:	893e                	mv	s2,a5
    800010ca:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800010ce:	6b85                	lui	s7,0x1
    800010d0:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800010d4:	4605                	li	a2,1
    800010d6:	85ca                	mv	a1,s2
    800010d8:	8556                	mv	a0,s5
    800010da:	00000097          	auipc	ra,0x0
    800010de:	eda080e7          	jalr	-294(ra) # 80000fb4 <walk>
    800010e2:	cd1d                	beqz	a0,80001120 <mappages+0x84>
    if(*pte & PTE_V)
    800010e4:	611c                	ld	a5,0(a0)
    800010e6:	8b85                	andi	a5,a5,1
    800010e8:	e785                	bnez	a5,80001110 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800010ea:	80b1                	srli	s1,s1,0xc
    800010ec:	04aa                	slli	s1,s1,0xa
    800010ee:	0164e4b3          	or	s1,s1,s6
    800010f2:	0014e493          	ori	s1,s1,1
    800010f6:	e104                	sd	s1,0(a0)
    if(a == last)
    800010f8:	05390063          	beq	s2,s3,80001138 <mappages+0x9c>
    a += PGSIZE;
    800010fc:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800010fe:	bfc9                	j	800010d0 <mappages+0x34>
    panic("mappages: size");
    80001100:	00007517          	auipc	a0,0x7
    80001104:	fd850513          	addi	a0,a0,-40 # 800080d8 <digits+0x98>
    80001108:	fffff097          	auipc	ra,0xfffff
    8000110c:	432080e7          	jalr	1074(ra) # 8000053a <panic>
      panic("mappages: remap");
    80001110:	00007517          	auipc	a0,0x7
    80001114:	fd850513          	addi	a0,a0,-40 # 800080e8 <digits+0xa8>
    80001118:	fffff097          	auipc	ra,0xfffff
    8000111c:	422080e7          	jalr	1058(ra) # 8000053a <panic>
      return -1;
    80001120:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001122:	60a6                	ld	ra,72(sp)
    80001124:	6406                	ld	s0,64(sp)
    80001126:	74e2                	ld	s1,56(sp)
    80001128:	7942                	ld	s2,48(sp)
    8000112a:	79a2                	ld	s3,40(sp)
    8000112c:	7a02                	ld	s4,32(sp)
    8000112e:	6ae2                	ld	s5,24(sp)
    80001130:	6b42                	ld	s6,16(sp)
    80001132:	6ba2                	ld	s7,8(sp)
    80001134:	6161                	addi	sp,sp,80
    80001136:	8082                	ret
  return 0;
    80001138:	4501                	li	a0,0
    8000113a:	b7e5                	j	80001122 <mappages+0x86>

000000008000113c <kvmmap>:
{
    8000113c:	1141                	addi	sp,sp,-16
    8000113e:	e406                	sd	ra,8(sp)
    80001140:	e022                	sd	s0,0(sp)
    80001142:	0800                	addi	s0,sp,16
    80001144:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001146:	86b2                	mv	a3,a2
    80001148:	863e                	mv	a2,a5
    8000114a:	00000097          	auipc	ra,0x0
    8000114e:	f52080e7          	jalr	-174(ra) # 8000109c <mappages>
    80001152:	e509                	bnez	a0,8000115c <kvmmap+0x20>
}
    80001154:	60a2                	ld	ra,8(sp)
    80001156:	6402                	ld	s0,0(sp)
    80001158:	0141                	addi	sp,sp,16
    8000115a:	8082                	ret
    panic("kvmmap");
    8000115c:	00007517          	auipc	a0,0x7
    80001160:	f9c50513          	addi	a0,a0,-100 # 800080f8 <digits+0xb8>
    80001164:	fffff097          	auipc	ra,0xfffff
    80001168:	3d6080e7          	jalr	982(ra) # 8000053a <panic>

000000008000116c <kvmmake>:
{
    8000116c:	1101                	addi	sp,sp,-32
    8000116e:	ec06                	sd	ra,24(sp)
    80001170:	e822                	sd	s0,16(sp)
    80001172:	e426                	sd	s1,8(sp)
    80001174:	e04a                	sd	s2,0(sp)
    80001176:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001178:	00000097          	auipc	ra,0x0
    8000117c:	968080e7          	jalr	-1688(ra) # 80000ae0 <kalloc>
    80001180:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001182:	6605                	lui	a2,0x1
    80001184:	4581                	li	a1,0
    80001186:	00000097          	auipc	ra,0x0
    8000118a:	b46080e7          	jalr	-1210(ra) # 80000ccc <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000118e:	4719                	li	a4,6
    80001190:	6685                	lui	a3,0x1
    80001192:	10000637          	lui	a2,0x10000
    80001196:	100005b7          	lui	a1,0x10000
    8000119a:	8526                	mv	a0,s1
    8000119c:	00000097          	auipc	ra,0x0
    800011a0:	fa0080e7          	jalr	-96(ra) # 8000113c <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800011a4:	4719                	li	a4,6
    800011a6:	6685                	lui	a3,0x1
    800011a8:	10001637          	lui	a2,0x10001
    800011ac:	100015b7          	lui	a1,0x10001
    800011b0:	8526                	mv	a0,s1
    800011b2:	00000097          	auipc	ra,0x0
    800011b6:	f8a080e7          	jalr	-118(ra) # 8000113c <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800011ba:	4719                	li	a4,6
    800011bc:	004006b7          	lui	a3,0x400
    800011c0:	0c000637          	lui	a2,0xc000
    800011c4:	0c0005b7          	lui	a1,0xc000
    800011c8:	8526                	mv	a0,s1
    800011ca:	00000097          	auipc	ra,0x0
    800011ce:	f72080e7          	jalr	-142(ra) # 8000113c <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800011d2:	00007917          	auipc	s2,0x7
    800011d6:	e2e90913          	addi	s2,s2,-466 # 80008000 <etext>
    800011da:	4729                	li	a4,10
    800011dc:	80007697          	auipc	a3,0x80007
    800011e0:	e2468693          	addi	a3,a3,-476 # 8000 <_entry-0x7fff8000>
    800011e4:	4605                	li	a2,1
    800011e6:	067e                	slli	a2,a2,0x1f
    800011e8:	85b2                	mv	a1,a2
    800011ea:	8526                	mv	a0,s1
    800011ec:	00000097          	auipc	ra,0x0
    800011f0:	f50080e7          	jalr	-176(ra) # 8000113c <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800011f4:	4719                	li	a4,6
    800011f6:	46c5                	li	a3,17
    800011f8:	06ee                	slli	a3,a3,0x1b
    800011fa:	412686b3          	sub	a3,a3,s2
    800011fe:	864a                	mv	a2,s2
    80001200:	85ca                	mv	a1,s2
    80001202:	8526                	mv	a0,s1
    80001204:	00000097          	auipc	ra,0x0
    80001208:	f38080e7          	jalr	-200(ra) # 8000113c <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000120c:	4729                	li	a4,10
    8000120e:	6685                	lui	a3,0x1
    80001210:	00006617          	auipc	a2,0x6
    80001214:	df060613          	addi	a2,a2,-528 # 80007000 <_trampoline>
    80001218:	040005b7          	lui	a1,0x4000
    8000121c:	15fd                	addi	a1,a1,-1
    8000121e:	05b2                	slli	a1,a1,0xc
    80001220:	8526                	mv	a0,s1
    80001222:	00000097          	auipc	ra,0x0
    80001226:	f1a080e7          	jalr	-230(ra) # 8000113c <kvmmap>
  proc_mapstacks(kpgtbl);
    8000122a:	8526                	mv	a0,s1
    8000122c:	00000097          	auipc	ra,0x0
    80001230:	600080e7          	jalr	1536(ra) # 8000182c <proc_mapstacks>
}
    80001234:	8526                	mv	a0,s1
    80001236:	60e2                	ld	ra,24(sp)
    80001238:	6442                	ld	s0,16(sp)
    8000123a:	64a2                	ld	s1,8(sp)
    8000123c:	6902                	ld	s2,0(sp)
    8000123e:	6105                	addi	sp,sp,32
    80001240:	8082                	ret

0000000080001242 <kvminit>:
{
    80001242:	1141                	addi	sp,sp,-16
    80001244:	e406                	sd	ra,8(sp)
    80001246:	e022                	sd	s0,0(sp)
    80001248:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000124a:	00000097          	auipc	ra,0x0
    8000124e:	f22080e7          	jalr	-222(ra) # 8000116c <kvmmake>
    80001252:	00008797          	auipc	a5,0x8
    80001256:	dca7b723          	sd	a0,-562(a5) # 80009020 <kernel_pagetable>
}
    8000125a:	60a2                	ld	ra,8(sp)
    8000125c:	6402                	ld	s0,0(sp)
    8000125e:	0141                	addi	sp,sp,16
    80001260:	8082                	ret

0000000080001262 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001262:	715d                	addi	sp,sp,-80
    80001264:	e486                	sd	ra,72(sp)
    80001266:	e0a2                	sd	s0,64(sp)
    80001268:	fc26                	sd	s1,56(sp)
    8000126a:	f84a                	sd	s2,48(sp)
    8000126c:	f44e                	sd	s3,40(sp)
    8000126e:	f052                	sd	s4,32(sp)
    80001270:	ec56                	sd	s5,24(sp)
    80001272:	e85a                	sd	s6,16(sp)
    80001274:	e45e                	sd	s7,8(sp)
    80001276:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001278:	03459793          	slli	a5,a1,0x34
    8000127c:	e795                	bnez	a5,800012a8 <uvmunmap+0x46>
    8000127e:	8a2a                	mv	s4,a0
    80001280:	892e                	mv	s2,a1
    80001282:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001284:	0632                	slli	a2,a2,0xc
    80001286:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000128a:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000128c:	6b05                	lui	s6,0x1
    8000128e:	0735e263          	bltu	a1,s3,800012f2 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80001292:	60a6                	ld	ra,72(sp)
    80001294:	6406                	ld	s0,64(sp)
    80001296:	74e2                	ld	s1,56(sp)
    80001298:	7942                	ld	s2,48(sp)
    8000129a:	79a2                	ld	s3,40(sp)
    8000129c:	7a02                	ld	s4,32(sp)
    8000129e:	6ae2                	ld	s5,24(sp)
    800012a0:	6b42                	ld	s6,16(sp)
    800012a2:	6ba2                	ld	s7,8(sp)
    800012a4:	6161                	addi	sp,sp,80
    800012a6:	8082                	ret
    panic("uvmunmap: not aligned");
    800012a8:	00007517          	auipc	a0,0x7
    800012ac:	e5850513          	addi	a0,a0,-424 # 80008100 <digits+0xc0>
    800012b0:	fffff097          	auipc	ra,0xfffff
    800012b4:	28a080e7          	jalr	650(ra) # 8000053a <panic>
      panic("uvmunmap: walk");
    800012b8:	00007517          	auipc	a0,0x7
    800012bc:	e6050513          	addi	a0,a0,-416 # 80008118 <digits+0xd8>
    800012c0:	fffff097          	auipc	ra,0xfffff
    800012c4:	27a080e7          	jalr	634(ra) # 8000053a <panic>
      panic("uvmunmap: not mapped");
    800012c8:	00007517          	auipc	a0,0x7
    800012cc:	e6050513          	addi	a0,a0,-416 # 80008128 <digits+0xe8>
    800012d0:	fffff097          	auipc	ra,0xfffff
    800012d4:	26a080e7          	jalr	618(ra) # 8000053a <panic>
      panic("uvmunmap: not a leaf");
    800012d8:	00007517          	auipc	a0,0x7
    800012dc:	e6850513          	addi	a0,a0,-408 # 80008140 <digits+0x100>
    800012e0:	fffff097          	auipc	ra,0xfffff
    800012e4:	25a080e7          	jalr	602(ra) # 8000053a <panic>
    *pte = 0;
    800012e8:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012ec:	995a                	add	s2,s2,s6
    800012ee:	fb3972e3          	bgeu	s2,s3,80001292 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800012f2:	4601                	li	a2,0
    800012f4:	85ca                	mv	a1,s2
    800012f6:	8552                	mv	a0,s4
    800012f8:	00000097          	auipc	ra,0x0
    800012fc:	cbc080e7          	jalr	-836(ra) # 80000fb4 <walk>
    80001300:	84aa                	mv	s1,a0
    80001302:	d95d                	beqz	a0,800012b8 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    80001304:	6108                	ld	a0,0(a0)
    80001306:	00157793          	andi	a5,a0,1
    8000130a:	dfdd                	beqz	a5,800012c8 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000130c:	3ff57793          	andi	a5,a0,1023
    80001310:	fd7784e3          	beq	a5,s7,800012d8 <uvmunmap+0x76>
    if(do_free){
    80001314:	fc0a8ae3          	beqz	s5,800012e8 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    80001318:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000131a:	0532                	slli	a0,a0,0xc
    8000131c:	fffff097          	auipc	ra,0xfffff
    80001320:	6c6080e7          	jalr	1734(ra) # 800009e2 <kfree>
    80001324:	b7d1                	j	800012e8 <uvmunmap+0x86>

0000000080001326 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001326:	1101                	addi	sp,sp,-32
    80001328:	ec06                	sd	ra,24(sp)
    8000132a:	e822                	sd	s0,16(sp)
    8000132c:	e426                	sd	s1,8(sp)
    8000132e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001330:	fffff097          	auipc	ra,0xfffff
    80001334:	7b0080e7          	jalr	1968(ra) # 80000ae0 <kalloc>
    80001338:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000133a:	c519                	beqz	a0,80001348 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000133c:	6605                	lui	a2,0x1
    8000133e:	4581                	li	a1,0
    80001340:	00000097          	auipc	ra,0x0
    80001344:	98c080e7          	jalr	-1652(ra) # 80000ccc <memset>
  return pagetable;
}
    80001348:	8526                	mv	a0,s1
    8000134a:	60e2                	ld	ra,24(sp)
    8000134c:	6442                	ld	s0,16(sp)
    8000134e:	64a2                	ld	s1,8(sp)
    80001350:	6105                	addi	sp,sp,32
    80001352:	8082                	ret

0000000080001354 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80001354:	7179                	addi	sp,sp,-48
    80001356:	f406                	sd	ra,40(sp)
    80001358:	f022                	sd	s0,32(sp)
    8000135a:	ec26                	sd	s1,24(sp)
    8000135c:	e84a                	sd	s2,16(sp)
    8000135e:	e44e                	sd	s3,8(sp)
    80001360:	e052                	sd	s4,0(sp)
    80001362:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001364:	6785                	lui	a5,0x1
    80001366:	04f67863          	bgeu	a2,a5,800013b6 <uvminit+0x62>
    8000136a:	8a2a                	mv	s4,a0
    8000136c:	89ae                	mv	s3,a1
    8000136e:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80001370:	fffff097          	auipc	ra,0xfffff
    80001374:	770080e7          	jalr	1904(ra) # 80000ae0 <kalloc>
    80001378:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000137a:	6605                	lui	a2,0x1
    8000137c:	4581                	li	a1,0
    8000137e:	00000097          	auipc	ra,0x0
    80001382:	94e080e7          	jalr	-1714(ra) # 80000ccc <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001386:	4779                	li	a4,30
    80001388:	86ca                	mv	a3,s2
    8000138a:	6605                	lui	a2,0x1
    8000138c:	4581                	li	a1,0
    8000138e:	8552                	mv	a0,s4
    80001390:	00000097          	auipc	ra,0x0
    80001394:	d0c080e7          	jalr	-756(ra) # 8000109c <mappages>
  memmove(mem, src, sz);
    80001398:	8626                	mv	a2,s1
    8000139a:	85ce                	mv	a1,s3
    8000139c:	854a                	mv	a0,s2
    8000139e:	00000097          	auipc	ra,0x0
    800013a2:	98a080e7          	jalr	-1654(ra) # 80000d28 <memmove>
}
    800013a6:	70a2                	ld	ra,40(sp)
    800013a8:	7402                	ld	s0,32(sp)
    800013aa:	64e2                	ld	s1,24(sp)
    800013ac:	6942                	ld	s2,16(sp)
    800013ae:	69a2                	ld	s3,8(sp)
    800013b0:	6a02                	ld	s4,0(sp)
    800013b2:	6145                	addi	sp,sp,48
    800013b4:	8082                	ret
    panic("inituvm: more than a page");
    800013b6:	00007517          	auipc	a0,0x7
    800013ba:	da250513          	addi	a0,a0,-606 # 80008158 <digits+0x118>
    800013be:	fffff097          	auipc	ra,0xfffff
    800013c2:	17c080e7          	jalr	380(ra) # 8000053a <panic>

00000000800013c6 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800013c6:	1101                	addi	sp,sp,-32
    800013c8:	ec06                	sd	ra,24(sp)
    800013ca:	e822                	sd	s0,16(sp)
    800013cc:	e426                	sd	s1,8(sp)
    800013ce:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800013d0:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800013d2:	00b67d63          	bgeu	a2,a1,800013ec <uvmdealloc+0x26>
    800013d6:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800013d8:	6785                	lui	a5,0x1
    800013da:	17fd                	addi	a5,a5,-1
    800013dc:	00f60733          	add	a4,a2,a5
    800013e0:	76fd                	lui	a3,0xfffff
    800013e2:	8f75                	and	a4,a4,a3
    800013e4:	97ae                	add	a5,a5,a1
    800013e6:	8ff5                	and	a5,a5,a3
    800013e8:	00f76863          	bltu	a4,a5,800013f8 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800013ec:	8526                	mv	a0,s1
    800013ee:	60e2                	ld	ra,24(sp)
    800013f0:	6442                	ld	s0,16(sp)
    800013f2:	64a2                	ld	s1,8(sp)
    800013f4:	6105                	addi	sp,sp,32
    800013f6:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800013f8:	8f99                	sub	a5,a5,a4
    800013fa:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800013fc:	4685                	li	a3,1
    800013fe:	0007861b          	sext.w	a2,a5
    80001402:	85ba                	mv	a1,a4
    80001404:	00000097          	auipc	ra,0x0
    80001408:	e5e080e7          	jalr	-418(ra) # 80001262 <uvmunmap>
    8000140c:	b7c5                	j	800013ec <uvmdealloc+0x26>

000000008000140e <uvmalloc>:
  if(newsz < oldsz)
    8000140e:	0ab66163          	bltu	a2,a1,800014b0 <uvmalloc+0xa2>
{
    80001412:	7139                	addi	sp,sp,-64
    80001414:	fc06                	sd	ra,56(sp)
    80001416:	f822                	sd	s0,48(sp)
    80001418:	f426                	sd	s1,40(sp)
    8000141a:	f04a                	sd	s2,32(sp)
    8000141c:	ec4e                	sd	s3,24(sp)
    8000141e:	e852                	sd	s4,16(sp)
    80001420:	e456                	sd	s5,8(sp)
    80001422:	0080                	addi	s0,sp,64
    80001424:	8aaa                	mv	s5,a0
    80001426:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001428:	6785                	lui	a5,0x1
    8000142a:	17fd                	addi	a5,a5,-1
    8000142c:	95be                	add	a1,a1,a5
    8000142e:	77fd                	lui	a5,0xfffff
    80001430:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001434:	08c9f063          	bgeu	s3,a2,800014b4 <uvmalloc+0xa6>
    80001438:	894e                	mv	s2,s3
    mem = kalloc();
    8000143a:	fffff097          	auipc	ra,0xfffff
    8000143e:	6a6080e7          	jalr	1702(ra) # 80000ae0 <kalloc>
    80001442:	84aa                	mv	s1,a0
    if(mem == 0){
    80001444:	c51d                	beqz	a0,80001472 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80001446:	6605                	lui	a2,0x1
    80001448:	4581                	li	a1,0
    8000144a:	00000097          	auipc	ra,0x0
    8000144e:	882080e7          	jalr	-1918(ra) # 80000ccc <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80001452:	4779                	li	a4,30
    80001454:	86a6                	mv	a3,s1
    80001456:	6605                	lui	a2,0x1
    80001458:	85ca                	mv	a1,s2
    8000145a:	8556                	mv	a0,s5
    8000145c:	00000097          	auipc	ra,0x0
    80001460:	c40080e7          	jalr	-960(ra) # 8000109c <mappages>
    80001464:	e905                	bnez	a0,80001494 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001466:	6785                	lui	a5,0x1
    80001468:	993e                	add	s2,s2,a5
    8000146a:	fd4968e3          	bltu	s2,s4,8000143a <uvmalloc+0x2c>
  return newsz;
    8000146e:	8552                	mv	a0,s4
    80001470:	a809                	j	80001482 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80001472:	864e                	mv	a2,s3
    80001474:	85ca                	mv	a1,s2
    80001476:	8556                	mv	a0,s5
    80001478:	00000097          	auipc	ra,0x0
    8000147c:	f4e080e7          	jalr	-178(ra) # 800013c6 <uvmdealloc>
      return 0;
    80001480:	4501                	li	a0,0
}
    80001482:	70e2                	ld	ra,56(sp)
    80001484:	7442                	ld	s0,48(sp)
    80001486:	74a2                	ld	s1,40(sp)
    80001488:	7902                	ld	s2,32(sp)
    8000148a:	69e2                	ld	s3,24(sp)
    8000148c:	6a42                	ld	s4,16(sp)
    8000148e:	6aa2                	ld	s5,8(sp)
    80001490:	6121                	addi	sp,sp,64
    80001492:	8082                	ret
      kfree(mem);
    80001494:	8526                	mv	a0,s1
    80001496:	fffff097          	auipc	ra,0xfffff
    8000149a:	54c080e7          	jalr	1356(ra) # 800009e2 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000149e:	864e                	mv	a2,s3
    800014a0:	85ca                	mv	a1,s2
    800014a2:	8556                	mv	a0,s5
    800014a4:	00000097          	auipc	ra,0x0
    800014a8:	f22080e7          	jalr	-222(ra) # 800013c6 <uvmdealloc>
      return 0;
    800014ac:	4501                	li	a0,0
    800014ae:	bfd1                	j	80001482 <uvmalloc+0x74>
    return oldsz;
    800014b0:	852e                	mv	a0,a1
}
    800014b2:	8082                	ret
  return newsz;
    800014b4:	8532                	mv	a0,a2
    800014b6:	b7f1                	j	80001482 <uvmalloc+0x74>

00000000800014b8 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800014b8:	7179                	addi	sp,sp,-48
    800014ba:	f406                	sd	ra,40(sp)
    800014bc:	f022                	sd	s0,32(sp)
    800014be:	ec26                	sd	s1,24(sp)
    800014c0:	e84a                	sd	s2,16(sp)
    800014c2:	e44e                	sd	s3,8(sp)
    800014c4:	e052                	sd	s4,0(sp)
    800014c6:	1800                	addi	s0,sp,48
    800014c8:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800014ca:	84aa                	mv	s1,a0
    800014cc:	6905                	lui	s2,0x1
    800014ce:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014d0:	4985                	li	s3,1
    800014d2:	a829                	j	800014ec <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800014d4:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800014d6:	00c79513          	slli	a0,a5,0xc
    800014da:	00000097          	auipc	ra,0x0
    800014de:	fde080e7          	jalr	-34(ra) # 800014b8 <freewalk>
      pagetable[i] = 0;
    800014e2:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800014e6:	04a1                	addi	s1,s1,8
    800014e8:	03248163          	beq	s1,s2,8000150a <freewalk+0x52>
    pte_t pte = pagetable[i];
    800014ec:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014ee:	00f7f713          	andi	a4,a5,15
    800014f2:	ff3701e3          	beq	a4,s3,800014d4 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800014f6:	8b85                	andi	a5,a5,1
    800014f8:	d7fd                	beqz	a5,800014e6 <freewalk+0x2e>
      panic("freewalk: leaf");
    800014fa:	00007517          	auipc	a0,0x7
    800014fe:	c7e50513          	addi	a0,a0,-898 # 80008178 <digits+0x138>
    80001502:	fffff097          	auipc	ra,0xfffff
    80001506:	038080e7          	jalr	56(ra) # 8000053a <panic>
    }
  }
  kfree((void*)pagetable);
    8000150a:	8552                	mv	a0,s4
    8000150c:	fffff097          	auipc	ra,0xfffff
    80001510:	4d6080e7          	jalr	1238(ra) # 800009e2 <kfree>
}
    80001514:	70a2                	ld	ra,40(sp)
    80001516:	7402                	ld	s0,32(sp)
    80001518:	64e2                	ld	s1,24(sp)
    8000151a:	6942                	ld	s2,16(sp)
    8000151c:	69a2                	ld	s3,8(sp)
    8000151e:	6a02                	ld	s4,0(sp)
    80001520:	6145                	addi	sp,sp,48
    80001522:	8082                	ret

0000000080001524 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001524:	1101                	addi	sp,sp,-32
    80001526:	ec06                	sd	ra,24(sp)
    80001528:	e822                	sd	s0,16(sp)
    8000152a:	e426                	sd	s1,8(sp)
    8000152c:	1000                	addi	s0,sp,32
    8000152e:	84aa                	mv	s1,a0
  if(sz > 0)
    80001530:	e999                	bnez	a1,80001546 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001532:	8526                	mv	a0,s1
    80001534:	00000097          	auipc	ra,0x0
    80001538:	f84080e7          	jalr	-124(ra) # 800014b8 <freewalk>
}
    8000153c:	60e2                	ld	ra,24(sp)
    8000153e:	6442                	ld	s0,16(sp)
    80001540:	64a2                	ld	s1,8(sp)
    80001542:	6105                	addi	sp,sp,32
    80001544:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001546:	6785                	lui	a5,0x1
    80001548:	17fd                	addi	a5,a5,-1
    8000154a:	95be                	add	a1,a1,a5
    8000154c:	4685                	li	a3,1
    8000154e:	00c5d613          	srli	a2,a1,0xc
    80001552:	4581                	li	a1,0
    80001554:	00000097          	auipc	ra,0x0
    80001558:	d0e080e7          	jalr	-754(ra) # 80001262 <uvmunmap>
    8000155c:	bfd9                	j	80001532 <uvmfree+0xe>

000000008000155e <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    8000155e:	c679                	beqz	a2,8000162c <uvmcopy+0xce>
{
    80001560:	715d                	addi	sp,sp,-80
    80001562:	e486                	sd	ra,72(sp)
    80001564:	e0a2                	sd	s0,64(sp)
    80001566:	fc26                	sd	s1,56(sp)
    80001568:	f84a                	sd	s2,48(sp)
    8000156a:	f44e                	sd	s3,40(sp)
    8000156c:	f052                	sd	s4,32(sp)
    8000156e:	ec56                	sd	s5,24(sp)
    80001570:	e85a                	sd	s6,16(sp)
    80001572:	e45e                	sd	s7,8(sp)
    80001574:	0880                	addi	s0,sp,80
    80001576:	8b2a                	mv	s6,a0
    80001578:	8aae                	mv	s5,a1
    8000157a:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    8000157c:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    8000157e:	4601                	li	a2,0
    80001580:	85ce                	mv	a1,s3
    80001582:	855a                	mv	a0,s6
    80001584:	00000097          	auipc	ra,0x0
    80001588:	a30080e7          	jalr	-1488(ra) # 80000fb4 <walk>
    8000158c:	c531                	beqz	a0,800015d8 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    8000158e:	6118                	ld	a4,0(a0)
    80001590:	00177793          	andi	a5,a4,1
    80001594:	cbb1                	beqz	a5,800015e8 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001596:	00a75593          	srli	a1,a4,0xa
    8000159a:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    8000159e:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800015a2:	fffff097          	auipc	ra,0xfffff
    800015a6:	53e080e7          	jalr	1342(ra) # 80000ae0 <kalloc>
    800015aa:	892a                	mv	s2,a0
    800015ac:	c939                	beqz	a0,80001602 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800015ae:	6605                	lui	a2,0x1
    800015b0:	85de                	mv	a1,s7
    800015b2:	fffff097          	auipc	ra,0xfffff
    800015b6:	776080e7          	jalr	1910(ra) # 80000d28 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800015ba:	8726                	mv	a4,s1
    800015bc:	86ca                	mv	a3,s2
    800015be:	6605                	lui	a2,0x1
    800015c0:	85ce                	mv	a1,s3
    800015c2:	8556                	mv	a0,s5
    800015c4:	00000097          	auipc	ra,0x0
    800015c8:	ad8080e7          	jalr	-1320(ra) # 8000109c <mappages>
    800015cc:	e515                	bnez	a0,800015f8 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    800015ce:	6785                	lui	a5,0x1
    800015d0:	99be                	add	s3,s3,a5
    800015d2:	fb49e6e3          	bltu	s3,s4,8000157e <uvmcopy+0x20>
    800015d6:	a081                	j	80001616 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    800015d8:	00007517          	auipc	a0,0x7
    800015dc:	bb050513          	addi	a0,a0,-1104 # 80008188 <digits+0x148>
    800015e0:	fffff097          	auipc	ra,0xfffff
    800015e4:	f5a080e7          	jalr	-166(ra) # 8000053a <panic>
      panic("uvmcopy: page not present");
    800015e8:	00007517          	auipc	a0,0x7
    800015ec:	bc050513          	addi	a0,a0,-1088 # 800081a8 <digits+0x168>
    800015f0:	fffff097          	auipc	ra,0xfffff
    800015f4:	f4a080e7          	jalr	-182(ra) # 8000053a <panic>
      kfree(mem);
    800015f8:	854a                	mv	a0,s2
    800015fa:	fffff097          	auipc	ra,0xfffff
    800015fe:	3e8080e7          	jalr	1000(ra) # 800009e2 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001602:	4685                	li	a3,1
    80001604:	00c9d613          	srli	a2,s3,0xc
    80001608:	4581                	li	a1,0
    8000160a:	8556                	mv	a0,s5
    8000160c:	00000097          	auipc	ra,0x0
    80001610:	c56080e7          	jalr	-938(ra) # 80001262 <uvmunmap>
  return -1;
    80001614:	557d                	li	a0,-1
}
    80001616:	60a6                	ld	ra,72(sp)
    80001618:	6406                	ld	s0,64(sp)
    8000161a:	74e2                	ld	s1,56(sp)
    8000161c:	7942                	ld	s2,48(sp)
    8000161e:	79a2                	ld	s3,40(sp)
    80001620:	7a02                	ld	s4,32(sp)
    80001622:	6ae2                	ld	s5,24(sp)
    80001624:	6b42                	ld	s6,16(sp)
    80001626:	6ba2                	ld	s7,8(sp)
    80001628:	6161                	addi	sp,sp,80
    8000162a:	8082                	ret
  return 0;
    8000162c:	4501                	li	a0,0
}
    8000162e:	8082                	ret

0000000080001630 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001630:	1141                	addi	sp,sp,-16
    80001632:	e406                	sd	ra,8(sp)
    80001634:	e022                	sd	s0,0(sp)
    80001636:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001638:	4601                	li	a2,0
    8000163a:	00000097          	auipc	ra,0x0
    8000163e:	97a080e7          	jalr	-1670(ra) # 80000fb4 <walk>
  if(pte == 0)
    80001642:	c901                	beqz	a0,80001652 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001644:	611c                	ld	a5,0(a0)
    80001646:	9bbd                	andi	a5,a5,-17
    80001648:	e11c                	sd	a5,0(a0)
}
    8000164a:	60a2                	ld	ra,8(sp)
    8000164c:	6402                	ld	s0,0(sp)
    8000164e:	0141                	addi	sp,sp,16
    80001650:	8082                	ret
    panic("uvmclear");
    80001652:	00007517          	auipc	a0,0x7
    80001656:	b7650513          	addi	a0,a0,-1162 # 800081c8 <digits+0x188>
    8000165a:	fffff097          	auipc	ra,0xfffff
    8000165e:	ee0080e7          	jalr	-288(ra) # 8000053a <panic>

0000000080001662 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001662:	c6bd                	beqz	a3,800016d0 <copyout+0x6e>
{
    80001664:	715d                	addi	sp,sp,-80
    80001666:	e486                	sd	ra,72(sp)
    80001668:	e0a2                	sd	s0,64(sp)
    8000166a:	fc26                	sd	s1,56(sp)
    8000166c:	f84a                	sd	s2,48(sp)
    8000166e:	f44e                	sd	s3,40(sp)
    80001670:	f052                	sd	s4,32(sp)
    80001672:	ec56                	sd	s5,24(sp)
    80001674:	e85a                	sd	s6,16(sp)
    80001676:	e45e                	sd	s7,8(sp)
    80001678:	e062                	sd	s8,0(sp)
    8000167a:	0880                	addi	s0,sp,80
    8000167c:	8b2a                	mv	s6,a0
    8000167e:	8c2e                	mv	s8,a1
    80001680:	8a32                	mv	s4,a2
    80001682:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001684:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001686:	6a85                	lui	s5,0x1
    80001688:	a015                	j	800016ac <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    8000168a:	9562                	add	a0,a0,s8
    8000168c:	0004861b          	sext.w	a2,s1
    80001690:	85d2                	mv	a1,s4
    80001692:	41250533          	sub	a0,a0,s2
    80001696:	fffff097          	auipc	ra,0xfffff
    8000169a:	692080e7          	jalr	1682(ra) # 80000d28 <memmove>

    len -= n;
    8000169e:	409989b3          	sub	s3,s3,s1
    src += n;
    800016a2:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    800016a4:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800016a8:	02098263          	beqz	s3,800016cc <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    800016ac:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800016b0:	85ca                	mv	a1,s2
    800016b2:	855a                	mv	a0,s6
    800016b4:	00000097          	auipc	ra,0x0
    800016b8:	9a6080e7          	jalr	-1626(ra) # 8000105a <walkaddr>
    if(pa0 == 0)
    800016bc:	cd01                	beqz	a0,800016d4 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    800016be:	418904b3          	sub	s1,s2,s8
    800016c2:	94d6                	add	s1,s1,s5
    800016c4:	fc99f3e3          	bgeu	s3,s1,8000168a <copyout+0x28>
    800016c8:	84ce                	mv	s1,s3
    800016ca:	b7c1                	j	8000168a <copyout+0x28>
  }
  return 0;
    800016cc:	4501                	li	a0,0
    800016ce:	a021                	j	800016d6 <copyout+0x74>
    800016d0:	4501                	li	a0,0
}
    800016d2:	8082                	ret
      return -1;
    800016d4:	557d                	li	a0,-1
}
    800016d6:	60a6                	ld	ra,72(sp)
    800016d8:	6406                	ld	s0,64(sp)
    800016da:	74e2                	ld	s1,56(sp)
    800016dc:	7942                	ld	s2,48(sp)
    800016de:	79a2                	ld	s3,40(sp)
    800016e0:	7a02                	ld	s4,32(sp)
    800016e2:	6ae2                	ld	s5,24(sp)
    800016e4:	6b42                	ld	s6,16(sp)
    800016e6:	6ba2                	ld	s7,8(sp)
    800016e8:	6c02                	ld	s8,0(sp)
    800016ea:	6161                	addi	sp,sp,80
    800016ec:	8082                	ret

00000000800016ee <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800016ee:	caa5                	beqz	a3,8000175e <copyin+0x70>
{
    800016f0:	715d                	addi	sp,sp,-80
    800016f2:	e486                	sd	ra,72(sp)
    800016f4:	e0a2                	sd	s0,64(sp)
    800016f6:	fc26                	sd	s1,56(sp)
    800016f8:	f84a                	sd	s2,48(sp)
    800016fa:	f44e                	sd	s3,40(sp)
    800016fc:	f052                	sd	s4,32(sp)
    800016fe:	ec56                	sd	s5,24(sp)
    80001700:	e85a                	sd	s6,16(sp)
    80001702:	e45e                	sd	s7,8(sp)
    80001704:	e062                	sd	s8,0(sp)
    80001706:	0880                	addi	s0,sp,80
    80001708:	8b2a                	mv	s6,a0
    8000170a:	8a2e                	mv	s4,a1
    8000170c:	8c32                	mv	s8,a2
    8000170e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001710:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001712:	6a85                	lui	s5,0x1
    80001714:	a01d                	j	8000173a <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001716:	018505b3          	add	a1,a0,s8
    8000171a:	0004861b          	sext.w	a2,s1
    8000171e:	412585b3          	sub	a1,a1,s2
    80001722:	8552                	mv	a0,s4
    80001724:	fffff097          	auipc	ra,0xfffff
    80001728:	604080e7          	jalr	1540(ra) # 80000d28 <memmove>

    len -= n;
    8000172c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001730:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001732:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001736:	02098263          	beqz	s3,8000175a <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    8000173a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000173e:	85ca                	mv	a1,s2
    80001740:	855a                	mv	a0,s6
    80001742:	00000097          	auipc	ra,0x0
    80001746:	918080e7          	jalr	-1768(ra) # 8000105a <walkaddr>
    if(pa0 == 0)
    8000174a:	cd01                	beqz	a0,80001762 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    8000174c:	418904b3          	sub	s1,s2,s8
    80001750:	94d6                	add	s1,s1,s5
    80001752:	fc99f2e3          	bgeu	s3,s1,80001716 <copyin+0x28>
    80001756:	84ce                	mv	s1,s3
    80001758:	bf7d                	j	80001716 <copyin+0x28>
  }
  return 0;
    8000175a:	4501                	li	a0,0
    8000175c:	a021                	j	80001764 <copyin+0x76>
    8000175e:	4501                	li	a0,0
}
    80001760:	8082                	ret
      return -1;
    80001762:	557d                	li	a0,-1
}
    80001764:	60a6                	ld	ra,72(sp)
    80001766:	6406                	ld	s0,64(sp)
    80001768:	74e2                	ld	s1,56(sp)
    8000176a:	7942                	ld	s2,48(sp)
    8000176c:	79a2                	ld	s3,40(sp)
    8000176e:	7a02                	ld	s4,32(sp)
    80001770:	6ae2                	ld	s5,24(sp)
    80001772:	6b42                	ld	s6,16(sp)
    80001774:	6ba2                	ld	s7,8(sp)
    80001776:	6c02                	ld	s8,0(sp)
    80001778:	6161                	addi	sp,sp,80
    8000177a:	8082                	ret

000000008000177c <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    8000177c:	c2dd                	beqz	a3,80001822 <copyinstr+0xa6>
{
    8000177e:	715d                	addi	sp,sp,-80
    80001780:	e486                	sd	ra,72(sp)
    80001782:	e0a2                	sd	s0,64(sp)
    80001784:	fc26                	sd	s1,56(sp)
    80001786:	f84a                	sd	s2,48(sp)
    80001788:	f44e                	sd	s3,40(sp)
    8000178a:	f052                	sd	s4,32(sp)
    8000178c:	ec56                	sd	s5,24(sp)
    8000178e:	e85a                	sd	s6,16(sp)
    80001790:	e45e                	sd	s7,8(sp)
    80001792:	0880                	addi	s0,sp,80
    80001794:	8a2a                	mv	s4,a0
    80001796:	8b2e                	mv	s6,a1
    80001798:	8bb2                	mv	s7,a2
    8000179a:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    8000179c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000179e:	6985                	lui	s3,0x1
    800017a0:	a02d                	j	800017ca <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800017a2:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800017a6:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800017a8:	37fd                	addiw	a5,a5,-1
    800017aa:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800017ae:	60a6                	ld	ra,72(sp)
    800017b0:	6406                	ld	s0,64(sp)
    800017b2:	74e2                	ld	s1,56(sp)
    800017b4:	7942                	ld	s2,48(sp)
    800017b6:	79a2                	ld	s3,40(sp)
    800017b8:	7a02                	ld	s4,32(sp)
    800017ba:	6ae2                	ld	s5,24(sp)
    800017bc:	6b42                	ld	s6,16(sp)
    800017be:	6ba2                	ld	s7,8(sp)
    800017c0:	6161                	addi	sp,sp,80
    800017c2:	8082                	ret
    srcva = va0 + PGSIZE;
    800017c4:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    800017c8:	c8a9                	beqz	s1,8000181a <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    800017ca:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800017ce:	85ca                	mv	a1,s2
    800017d0:	8552                	mv	a0,s4
    800017d2:	00000097          	auipc	ra,0x0
    800017d6:	888080e7          	jalr	-1912(ra) # 8000105a <walkaddr>
    if(pa0 == 0)
    800017da:	c131                	beqz	a0,8000181e <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    800017dc:	417906b3          	sub	a3,s2,s7
    800017e0:	96ce                	add	a3,a3,s3
    800017e2:	00d4f363          	bgeu	s1,a3,800017e8 <copyinstr+0x6c>
    800017e6:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    800017e8:	955e                	add	a0,a0,s7
    800017ea:	41250533          	sub	a0,a0,s2
    while(n > 0){
    800017ee:	daf9                	beqz	a3,800017c4 <copyinstr+0x48>
    800017f0:	87da                	mv	a5,s6
      if(*p == '\0'){
    800017f2:	41650633          	sub	a2,a0,s6
    800017f6:	fff48593          	addi	a1,s1,-1
    800017fa:	95da                	add	a1,a1,s6
    while(n > 0){
    800017fc:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    800017fe:	00f60733          	add	a4,a2,a5
    80001802:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd7000>
    80001806:	df51                	beqz	a4,800017a2 <copyinstr+0x26>
        *dst = *p;
    80001808:	00e78023          	sb	a4,0(a5)
      --max;
    8000180c:	40f584b3          	sub	s1,a1,a5
      dst++;
    80001810:	0785                	addi	a5,a5,1
    while(n > 0){
    80001812:	fed796e3          	bne	a5,a3,800017fe <copyinstr+0x82>
      dst++;
    80001816:	8b3e                	mv	s6,a5
    80001818:	b775                	j	800017c4 <copyinstr+0x48>
    8000181a:	4781                	li	a5,0
    8000181c:	b771                	j	800017a8 <copyinstr+0x2c>
      return -1;
    8000181e:	557d                	li	a0,-1
    80001820:	b779                	j	800017ae <copyinstr+0x32>
  int got_null = 0;
    80001822:	4781                	li	a5,0
  if(got_null){
    80001824:	37fd                	addiw	a5,a5,-1
    80001826:	0007851b          	sext.w	a0,a5
}
    8000182a:	8082                	ret

000000008000182c <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    8000182c:	7139                	addi	sp,sp,-64
    8000182e:	fc06                	sd	ra,56(sp)
    80001830:	f822                	sd	s0,48(sp)
    80001832:	f426                	sd	s1,40(sp)
    80001834:	f04a                	sd	s2,32(sp)
    80001836:	ec4e                	sd	s3,24(sp)
    80001838:	e852                	sd	s4,16(sp)
    8000183a:	e456                	sd	s5,8(sp)
    8000183c:	e05a                	sd	s6,0(sp)
    8000183e:	0080                	addi	s0,sp,64
    80001840:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80001842:	00011497          	auipc	s1,0x11
    80001846:	2b648493          	addi	s1,s1,694 # 80012af8 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    8000184a:	8b26                	mv	s6,s1
    8000184c:	00006a97          	auipc	s5,0x6
    80001850:	7b4a8a93          	addi	s5,s5,1972 # 80008000 <etext>
    80001854:	04000937          	lui	s2,0x4000
    80001858:	197d                	addi	s2,s2,-1
    8000185a:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000185c:	00018a17          	auipc	s4,0x18
    80001860:	29ca0a13          	addi	s4,s4,668 # 80019af8 <tickslock>
    char *pa = kalloc();
    80001864:	fffff097          	auipc	ra,0xfffff
    80001868:	27c080e7          	jalr	636(ra) # 80000ae0 <kalloc>
    8000186c:	862a                	mv	a2,a0
    if(pa == 0)
    8000186e:	c131                	beqz	a0,800018b2 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80001870:	416485b3          	sub	a1,s1,s6
    80001874:	8599                	srai	a1,a1,0x6
    80001876:	000ab783          	ld	a5,0(s5)
    8000187a:	02f585b3          	mul	a1,a1,a5
    8000187e:	2585                	addiw	a1,a1,1
    80001880:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001884:	4719                	li	a4,6
    80001886:	6685                	lui	a3,0x1
    80001888:	40b905b3          	sub	a1,s2,a1
    8000188c:	854e                	mv	a0,s3
    8000188e:	00000097          	auipc	ra,0x0
    80001892:	8ae080e7          	jalr	-1874(ra) # 8000113c <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001896:	1c048493          	addi	s1,s1,448
    8000189a:	fd4495e3          	bne	s1,s4,80001864 <proc_mapstacks+0x38>
  }
}
    8000189e:	70e2                	ld	ra,56(sp)
    800018a0:	7442                	ld	s0,48(sp)
    800018a2:	74a2                	ld	s1,40(sp)
    800018a4:	7902                	ld	s2,32(sp)
    800018a6:	69e2                	ld	s3,24(sp)
    800018a8:	6a42                	ld	s4,16(sp)
    800018aa:	6aa2                	ld	s5,8(sp)
    800018ac:	6b02                	ld	s6,0(sp)
    800018ae:	6121                	addi	sp,sp,64
    800018b0:	8082                	ret
      panic("kalloc");
    800018b2:	00007517          	auipc	a0,0x7
    800018b6:	92650513          	addi	a0,a0,-1754 # 800081d8 <digits+0x198>
    800018ba:	fffff097          	auipc	ra,0xfffff
    800018be:	c80080e7          	jalr	-896(ra) # 8000053a <panic>

00000000800018c2 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    800018c2:	7139                	addi	sp,sp,-64
    800018c4:	fc06                	sd	ra,56(sp)
    800018c6:	f822                	sd	s0,48(sp)
    800018c8:	f426                	sd	s1,40(sp)
    800018ca:	f04a                	sd	s2,32(sp)
    800018cc:	ec4e                	sd	s3,24(sp)
    800018ce:	e852                	sd	s4,16(sp)
    800018d0:	e456                	sd	s5,8(sp)
    800018d2:	e05a                	sd	s6,0(sp)
    800018d4:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    800018d6:	00007597          	auipc	a1,0x7
    800018da:	90a58593          	addi	a1,a1,-1782 # 800081e0 <digits+0x1a0>
    800018de:	00010517          	auipc	a0,0x10
    800018e2:	9c250513          	addi	a0,a0,-1598 # 800112a0 <pid_lock>
    800018e6:	fffff097          	auipc	ra,0xfffff
    800018ea:	25a080e7          	jalr	602(ra) # 80000b40 <initlock>
  initlock(&wait_lock, "wait_lock");
    800018ee:	00007597          	auipc	a1,0x7
    800018f2:	8fa58593          	addi	a1,a1,-1798 # 800081e8 <digits+0x1a8>
    800018f6:	00010517          	auipc	a0,0x10
    800018fa:	9c250513          	addi	a0,a0,-1598 # 800112b8 <wait_lock>
    800018fe:	fffff097          	auipc	ra,0xfffff
    80001902:	242080e7          	jalr	578(ra) # 80000b40 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001906:	00011497          	auipc	s1,0x11
    8000190a:	1f248493          	addi	s1,s1,498 # 80012af8 <proc>
      initlock(&p->lock, "proc");
    8000190e:	00007b17          	auipc	s6,0x7
    80001912:	8eab0b13          	addi	s6,s6,-1814 # 800081f8 <digits+0x1b8>
      p->kstack = KSTACK((int) (p - proc));
    80001916:	8aa6                	mv	s5,s1
    80001918:	00006a17          	auipc	s4,0x6
    8000191c:	6e8a0a13          	addi	s4,s4,1768 # 80008000 <etext>
    80001920:	04000937          	lui	s2,0x4000
    80001924:	197d                	addi	s2,s2,-1
    80001926:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001928:	00018997          	auipc	s3,0x18
    8000192c:	1d098993          	addi	s3,s3,464 # 80019af8 <tickslock>
      initlock(&p->lock, "proc");
    80001930:	85da                	mv	a1,s6
    80001932:	8526                	mv	a0,s1
    80001934:	fffff097          	auipc	ra,0xfffff
    80001938:	20c080e7          	jalr	524(ra) # 80000b40 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    8000193c:	415487b3          	sub	a5,s1,s5
    80001940:	8799                	srai	a5,a5,0x6
    80001942:	000a3703          	ld	a4,0(s4)
    80001946:	02e787b3          	mul	a5,a5,a4
    8000194a:	2785                	addiw	a5,a5,1
    8000194c:	00d7979b          	slliw	a5,a5,0xd
    80001950:	40f907b3          	sub	a5,s2,a5
    80001954:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001956:	1c048493          	addi	s1,s1,448
    8000195a:	fd349be3          	bne	s1,s3,80001930 <procinit+0x6e>
  }
}
    8000195e:	70e2                	ld	ra,56(sp)
    80001960:	7442                	ld	s0,48(sp)
    80001962:	74a2                	ld	s1,40(sp)
    80001964:	7902                	ld	s2,32(sp)
    80001966:	69e2                	ld	s3,24(sp)
    80001968:	6a42                	ld	s4,16(sp)
    8000196a:	6aa2                	ld	s5,8(sp)
    8000196c:	6b02                	ld	s6,0(sp)
    8000196e:	6121                	addi	sp,sp,64
    80001970:	8082                	ret

0000000080001972 <pq_init>:

void 
pq_init(void){
    80001972:	1141                	addi	sp,sp,-16
    80001974:	e422                	sd	s0,8(sp)
    80001976:	0800                	addi	s0,sp,16
  for(int i=0;i<5;i++){
    80001978:	00010717          	auipc	a4,0x10
    8000197c:	16070713          	addi	a4,a4,352 # 80011ad8 <mfq+0x408>
    80001980:	00011697          	auipc	a3,0x11
    80001984:	58068693          	addi	a3,a3,1408 # 80012f00 <proc+0x408>
    mfq[i].front = 0;
    80001988:	be072c23          	sw	zero,-1032(a4)
    mfq[i].rear = 0;
    8000198c:	be072e23          	sw	zero,-1028(a4)
    
    for(int j=0;j<2*NPROC;j++){
    80001990:	c0070793          	addi	a5,a4,-1024
      mfq[i].list[j] = 0;
    80001994:	0007b023          	sd	zero,0(a5)
    for(int j=0;j<2*NPROC;j++){
    80001998:	07a1                	addi	a5,a5,8
    8000199a:	fee79de3          	bne	a5,a4,80001994 <pq_init+0x22>
  for(int i=0;i<5;i++){
    8000199e:	40870713          	addi	a4,a4,1032
    800019a2:	fed713e3          	bne	a4,a3,80001988 <pq_init+0x16>
    }
  }
}
    800019a6:	6422                	ld	s0,8(sp)
    800019a8:	0141                	addi	sp,sp,16
    800019aa:	8082                	ret

00000000800019ac <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800019ac:	1141                	addi	sp,sp,-16
    800019ae:	e422                	sd	s0,8(sp)
    800019b0:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800019b2:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800019b4:	2501                	sext.w	a0,a0
    800019b6:	6422                	ld	s0,8(sp)
    800019b8:	0141                	addi	sp,sp,16
    800019ba:	8082                	ret

00000000800019bc <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    800019bc:	1141                	addi	sp,sp,-16
    800019be:	e422                	sd	s0,8(sp)
    800019c0:	0800                	addi	s0,sp,16
    800019c2:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800019c4:	2781                	sext.w	a5,a5
    800019c6:	079e                	slli	a5,a5,0x7
  return c;
}
    800019c8:	00010517          	auipc	a0,0x10
    800019cc:	90850513          	addi	a0,a0,-1784 # 800112d0 <cpus>
    800019d0:	953e                	add	a0,a0,a5
    800019d2:	6422                	ld	s0,8(sp)
    800019d4:	0141                	addi	sp,sp,16
    800019d6:	8082                	ret

00000000800019d8 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    800019d8:	1101                	addi	sp,sp,-32
    800019da:	ec06                	sd	ra,24(sp)
    800019dc:	e822                	sd	s0,16(sp)
    800019de:	e426                	sd	s1,8(sp)
    800019e0:	1000                	addi	s0,sp,32
  push_off();
    800019e2:	fffff097          	auipc	ra,0xfffff
    800019e6:	1a2080e7          	jalr	418(ra) # 80000b84 <push_off>
    800019ea:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800019ec:	2781                	sext.w	a5,a5
    800019ee:	079e                	slli	a5,a5,0x7
    800019f0:	00010717          	auipc	a4,0x10
    800019f4:	8b070713          	addi	a4,a4,-1872 # 800112a0 <pid_lock>
    800019f8:	97ba                	add	a5,a5,a4
    800019fa:	7b84                	ld	s1,48(a5)
  pop_off();
    800019fc:	fffff097          	auipc	ra,0xfffff
    80001a00:	228080e7          	jalr	552(ra) # 80000c24 <pop_off>
  return p;
}
    80001a04:	8526                	mv	a0,s1
    80001a06:	60e2                	ld	ra,24(sp)
    80001a08:	6442                	ld	s0,16(sp)
    80001a0a:	64a2                	ld	s1,8(sp)
    80001a0c:	6105                	addi	sp,sp,32
    80001a0e:	8082                	ret

0000000080001a10 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001a10:	1141                	addi	sp,sp,-16
    80001a12:	e406                	sd	ra,8(sp)
    80001a14:	e022                	sd	s0,0(sp)
    80001a16:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001a18:	00000097          	auipc	ra,0x0
    80001a1c:	fc0080e7          	jalr	-64(ra) # 800019d8 <myproc>
    80001a20:	fffff097          	auipc	ra,0xfffff
    80001a24:	264080e7          	jalr	612(ra) # 80000c84 <release>

  if (first) {
    80001a28:	00007797          	auipc	a5,0x7
    80001a2c:	f287a783          	lw	a5,-216(a5) # 80008950 <first.1>
    80001a30:	eb89                	bnez	a5,80001a42 <forkret+0x32>
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }
  usertrapret();
    80001a32:	00001097          	auipc	ra,0x1
    80001a36:	13a080e7          	jalr	314(ra) # 80002b6c <usertrapret>
}
    80001a3a:	60a2                	ld	ra,8(sp)
    80001a3c:	6402                	ld	s0,0(sp)
    80001a3e:	0141                	addi	sp,sp,16
    80001a40:	8082                	ret
    first = 0;
    80001a42:	00007797          	auipc	a5,0x7
    80001a46:	f007a723          	sw	zero,-242(a5) # 80008950 <first.1>
    fsinit(ROOTDEV);
    80001a4a:	4505                	li	a0,1
    80001a4c:	00002097          	auipc	ra,0x2
    80001a50:	0ee080e7          	jalr	238(ra) # 80003b3a <fsinit>
    80001a54:	bff9                	j	80001a32 <forkret+0x22>

0000000080001a56 <allocpid>:
allocpid() {
    80001a56:	1101                	addi	sp,sp,-32
    80001a58:	ec06                	sd	ra,24(sp)
    80001a5a:	e822                	sd	s0,16(sp)
    80001a5c:	e426                	sd	s1,8(sp)
    80001a5e:	e04a                	sd	s2,0(sp)
    80001a60:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001a62:	00010917          	auipc	s2,0x10
    80001a66:	83e90913          	addi	s2,s2,-1986 # 800112a0 <pid_lock>
    80001a6a:	854a                	mv	a0,s2
    80001a6c:	fffff097          	auipc	ra,0xfffff
    80001a70:	164080e7          	jalr	356(ra) # 80000bd0 <acquire>
  pid = nextpid;
    80001a74:	00007797          	auipc	a5,0x7
    80001a78:	ee078793          	addi	a5,a5,-288 # 80008954 <nextpid>
    80001a7c:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001a7e:	0014871b          	addiw	a4,s1,1
    80001a82:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001a84:	854a                	mv	a0,s2
    80001a86:	fffff097          	auipc	ra,0xfffff
    80001a8a:	1fe080e7          	jalr	510(ra) # 80000c84 <release>
}
    80001a8e:	8526                	mv	a0,s1
    80001a90:	60e2                	ld	ra,24(sp)
    80001a92:	6442                	ld	s0,16(sp)
    80001a94:	64a2                	ld	s1,8(sp)
    80001a96:	6902                	ld	s2,0(sp)
    80001a98:	6105                	addi	sp,sp,32
    80001a9a:	8082                	ret

0000000080001a9c <proc_pagetable>:
{
    80001a9c:	1101                	addi	sp,sp,-32
    80001a9e:	ec06                	sd	ra,24(sp)
    80001aa0:	e822                	sd	s0,16(sp)
    80001aa2:	e426                	sd	s1,8(sp)
    80001aa4:	e04a                	sd	s2,0(sp)
    80001aa6:	1000                	addi	s0,sp,32
    80001aa8:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001aaa:	00000097          	auipc	ra,0x0
    80001aae:	87c080e7          	jalr	-1924(ra) # 80001326 <uvmcreate>
    80001ab2:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001ab4:	c121                	beqz	a0,80001af4 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001ab6:	4729                	li	a4,10
    80001ab8:	00005697          	auipc	a3,0x5
    80001abc:	54868693          	addi	a3,a3,1352 # 80007000 <_trampoline>
    80001ac0:	6605                	lui	a2,0x1
    80001ac2:	040005b7          	lui	a1,0x4000
    80001ac6:	15fd                	addi	a1,a1,-1
    80001ac8:	05b2                	slli	a1,a1,0xc
    80001aca:	fffff097          	auipc	ra,0xfffff
    80001ace:	5d2080e7          	jalr	1490(ra) # 8000109c <mappages>
    80001ad2:	02054863          	bltz	a0,80001b02 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001ad6:	4719                	li	a4,6
    80001ad8:	05893683          	ld	a3,88(s2)
    80001adc:	6605                	lui	a2,0x1
    80001ade:	020005b7          	lui	a1,0x2000
    80001ae2:	15fd                	addi	a1,a1,-1
    80001ae4:	05b6                	slli	a1,a1,0xd
    80001ae6:	8526                	mv	a0,s1
    80001ae8:	fffff097          	auipc	ra,0xfffff
    80001aec:	5b4080e7          	jalr	1460(ra) # 8000109c <mappages>
    80001af0:	02054163          	bltz	a0,80001b12 <proc_pagetable+0x76>
}
    80001af4:	8526                	mv	a0,s1
    80001af6:	60e2                	ld	ra,24(sp)
    80001af8:	6442                	ld	s0,16(sp)
    80001afa:	64a2                	ld	s1,8(sp)
    80001afc:	6902                	ld	s2,0(sp)
    80001afe:	6105                	addi	sp,sp,32
    80001b00:	8082                	ret
    uvmfree(pagetable, 0);
    80001b02:	4581                	li	a1,0
    80001b04:	8526                	mv	a0,s1
    80001b06:	00000097          	auipc	ra,0x0
    80001b0a:	a1e080e7          	jalr	-1506(ra) # 80001524 <uvmfree>
    return 0;
    80001b0e:	4481                	li	s1,0
    80001b10:	b7d5                	j	80001af4 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b12:	4681                	li	a3,0
    80001b14:	4605                	li	a2,1
    80001b16:	040005b7          	lui	a1,0x4000
    80001b1a:	15fd                	addi	a1,a1,-1
    80001b1c:	05b2                	slli	a1,a1,0xc
    80001b1e:	8526                	mv	a0,s1
    80001b20:	fffff097          	auipc	ra,0xfffff
    80001b24:	742080e7          	jalr	1858(ra) # 80001262 <uvmunmap>
    uvmfree(pagetable, 0);
    80001b28:	4581                	li	a1,0
    80001b2a:	8526                	mv	a0,s1
    80001b2c:	00000097          	auipc	ra,0x0
    80001b30:	9f8080e7          	jalr	-1544(ra) # 80001524 <uvmfree>
    return 0;
    80001b34:	4481                	li	s1,0
    80001b36:	bf7d                	j	80001af4 <proc_pagetable+0x58>

0000000080001b38 <proc_freepagetable>:
{
    80001b38:	1101                	addi	sp,sp,-32
    80001b3a:	ec06                	sd	ra,24(sp)
    80001b3c:	e822                	sd	s0,16(sp)
    80001b3e:	e426                	sd	s1,8(sp)
    80001b40:	e04a                	sd	s2,0(sp)
    80001b42:	1000                	addi	s0,sp,32
    80001b44:	84aa                	mv	s1,a0
    80001b46:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b48:	4681                	li	a3,0
    80001b4a:	4605                	li	a2,1
    80001b4c:	040005b7          	lui	a1,0x4000
    80001b50:	15fd                	addi	a1,a1,-1
    80001b52:	05b2                	slli	a1,a1,0xc
    80001b54:	fffff097          	auipc	ra,0xfffff
    80001b58:	70e080e7          	jalr	1806(ra) # 80001262 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001b5c:	4681                	li	a3,0
    80001b5e:	4605                	li	a2,1
    80001b60:	020005b7          	lui	a1,0x2000
    80001b64:	15fd                	addi	a1,a1,-1
    80001b66:	05b6                	slli	a1,a1,0xd
    80001b68:	8526                	mv	a0,s1
    80001b6a:	fffff097          	auipc	ra,0xfffff
    80001b6e:	6f8080e7          	jalr	1784(ra) # 80001262 <uvmunmap>
  uvmfree(pagetable, sz);
    80001b72:	85ca                	mv	a1,s2
    80001b74:	8526                	mv	a0,s1
    80001b76:	00000097          	auipc	ra,0x0
    80001b7a:	9ae080e7          	jalr	-1618(ra) # 80001524 <uvmfree>
}
    80001b7e:	60e2                	ld	ra,24(sp)
    80001b80:	6442                	ld	s0,16(sp)
    80001b82:	64a2                	ld	s1,8(sp)
    80001b84:	6902                	ld	s2,0(sp)
    80001b86:	6105                	addi	sp,sp,32
    80001b88:	8082                	ret

0000000080001b8a <freeproc>:
{
    80001b8a:	1101                	addi	sp,sp,-32
    80001b8c:	ec06                	sd	ra,24(sp)
    80001b8e:	e822                	sd	s0,16(sp)
    80001b90:	e426                	sd	s1,8(sp)
    80001b92:	1000                	addi	s0,sp,32
    80001b94:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001b96:	6d28                	ld	a0,88(a0)
    80001b98:	c509                	beqz	a0,80001ba2 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001b9a:	fffff097          	auipc	ra,0xfffff
    80001b9e:	e48080e7          	jalr	-440(ra) # 800009e2 <kfree>
  p->trapframe = 0;
    80001ba2:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001ba6:	68a8                	ld	a0,80(s1)
    80001ba8:	c511                	beqz	a0,80001bb4 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001baa:	64ac                	ld	a1,72(s1)
    80001bac:	00000097          	auipc	ra,0x0
    80001bb0:	f8c080e7          	jalr	-116(ra) # 80001b38 <proc_freepagetable>
  p->pagetable = 0;
    80001bb4:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001bb8:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001bbc:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001bc0:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001bc4:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001bc8:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001bcc:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001bd0:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001bd4:	0004ac23          	sw	zero,24(s1)
}
    80001bd8:	60e2                	ld	ra,24(sp)
    80001bda:	6442                	ld	s0,16(sp)
    80001bdc:	64a2                	ld	s1,8(sp)
    80001bde:	6105                	addi	sp,sp,32
    80001be0:	8082                	ret

0000000080001be2 <allocproc>:
{
    80001be2:	1101                	addi	sp,sp,-32
    80001be4:	ec06                	sd	ra,24(sp)
    80001be6:	e822                	sd	s0,16(sp)
    80001be8:	e426                	sd	s1,8(sp)
    80001bea:	e04a                	sd	s2,0(sp)
    80001bec:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bee:	00011497          	auipc	s1,0x11
    80001bf2:	f0a48493          	addi	s1,s1,-246 # 80012af8 <proc>
    80001bf6:	00018917          	auipc	s2,0x18
    80001bfa:	f0290913          	addi	s2,s2,-254 # 80019af8 <tickslock>
    acquire(&p->lock);
    80001bfe:	8526                	mv	a0,s1
    80001c00:	fffff097          	auipc	ra,0xfffff
    80001c04:	fd0080e7          	jalr	-48(ra) # 80000bd0 <acquire>
    if(p->state == UNUSED) {
    80001c08:	4c9c                	lw	a5,24(s1)
    80001c0a:	cf81                	beqz	a5,80001c22 <allocproc+0x40>
      release(&p->lock);
    80001c0c:	8526                	mv	a0,s1
    80001c0e:	fffff097          	auipc	ra,0xfffff
    80001c12:	076080e7          	jalr	118(ra) # 80000c84 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c16:	1c048493          	addi	s1,s1,448
    80001c1a:	ff2492e3          	bne	s1,s2,80001bfe <allocproc+0x1c>
  return 0;
    80001c1e:	4481                	li	s1,0
    80001c20:	a871                	j	80001cbc <allocproc+0xda>
  p->pid = allocpid();
    80001c22:	00000097          	auipc	ra,0x0
    80001c26:	e34080e7          	jalr	-460(ra) # 80001a56 <allocpid>
    80001c2a:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001c2c:	4785                	li	a5,1
    80001c2e:	cc9c                	sw	a5,24(s1)
  p->birthtime = ticks;
    80001c30:	00007717          	auipc	a4,0x7
    80001c34:	40072703          	lw	a4,1024(a4) # 80009030 <ticks>
    80001c38:	16e4a623          	sw	a4,364(s1)
  p->inQ = 0;
    80001c3c:	1804a423          	sw	zero,392(s1)
  p->qEnter = ticks;
    80001c40:	18e4aa23          	sw	a4,404(s1)
  p->level = 0;
    80001c44:	1804a623          	sw	zero,396(s1)
  p->timeinQ = 1 << p->level;
    80001c48:	18f4a823          	sw	a5,400(s1)
  p->rtime = 0;
    80001c4c:	1a04a623          	sw	zero,428(s1)
  p->etime = 0;
    80001c50:	1a04aa23          	sw	zero,436(s1)
    p->timeineachq[i] = 0;
    80001c54:	1804ac23          	sw	zero,408(s1)
    80001c58:	1804ae23          	sw	zero,412(s1)
    80001c5c:	1a04a023          	sw	zero,416(s1)
    80001c60:	1a04a223          	sw	zero,420(s1)
    80001c64:	1a04a423          	sw	zero,424(s1)
  p->nrun = 0;
    80001c68:	1a04ac23          	sw	zero,440(s1)
  p->staticPriority = 60;
    80001c6c:	03c00793          	li	a5,60
    80001c70:	16f4a823          	sw	a5,368(s1)
  p->niceness = 5;
    80001c74:	4795                	li	a5,5
    80001c76:	16f4ac23          	sw	a5,376(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001c7a:	fffff097          	auipc	ra,0xfffff
    80001c7e:	e66080e7          	jalr	-410(ra) # 80000ae0 <kalloc>
    80001c82:	892a                	mv	s2,a0
    80001c84:	eca8                	sd	a0,88(s1)
    80001c86:	c131                	beqz	a0,80001cca <allocproc+0xe8>
  p->pagetable = proc_pagetable(p);
    80001c88:	8526                	mv	a0,s1
    80001c8a:	00000097          	auipc	ra,0x0
    80001c8e:	e12080e7          	jalr	-494(ra) # 80001a9c <proc_pagetable>
    80001c92:	892a                	mv	s2,a0
    80001c94:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001c96:	c531                	beqz	a0,80001ce2 <allocproc+0x100>
  memset(&p->context, 0, sizeof(p->context));
    80001c98:	07000613          	li	a2,112
    80001c9c:	4581                	li	a1,0
    80001c9e:	06048513          	addi	a0,s1,96
    80001ca2:	fffff097          	auipc	ra,0xfffff
    80001ca6:	02a080e7          	jalr	42(ra) # 80000ccc <memset>
  p->context.ra = (uint64)forkret;
    80001caa:	00000797          	auipc	a5,0x0
    80001cae:	d6678793          	addi	a5,a5,-666 # 80001a10 <forkret>
    80001cb2:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001cb4:	60bc                	ld	a5,64(s1)
    80001cb6:	6705                	lui	a4,0x1
    80001cb8:	97ba                	add	a5,a5,a4
    80001cba:	f4bc                	sd	a5,104(s1)
}
    80001cbc:	8526                	mv	a0,s1
    80001cbe:	60e2                	ld	ra,24(sp)
    80001cc0:	6442                	ld	s0,16(sp)
    80001cc2:	64a2                	ld	s1,8(sp)
    80001cc4:	6902                	ld	s2,0(sp)
    80001cc6:	6105                	addi	sp,sp,32
    80001cc8:	8082                	ret
    freeproc(p);
    80001cca:	8526                	mv	a0,s1
    80001ccc:	00000097          	auipc	ra,0x0
    80001cd0:	ebe080e7          	jalr	-322(ra) # 80001b8a <freeproc>
    release(&p->lock);
    80001cd4:	8526                	mv	a0,s1
    80001cd6:	fffff097          	auipc	ra,0xfffff
    80001cda:	fae080e7          	jalr	-82(ra) # 80000c84 <release>
    return 0;
    80001cde:	84ca                	mv	s1,s2
    80001ce0:	bff1                	j	80001cbc <allocproc+0xda>
    freeproc(p);
    80001ce2:	8526                	mv	a0,s1
    80001ce4:	00000097          	auipc	ra,0x0
    80001ce8:	ea6080e7          	jalr	-346(ra) # 80001b8a <freeproc>
    release(&p->lock);
    80001cec:	8526                	mv	a0,s1
    80001cee:	fffff097          	auipc	ra,0xfffff
    80001cf2:	f96080e7          	jalr	-106(ra) # 80000c84 <release>
    return 0;
    80001cf6:	84ca                	mv	s1,s2
    80001cf8:	b7d1                	j	80001cbc <allocproc+0xda>

0000000080001cfa <userinit>:
{
    80001cfa:	1101                	addi	sp,sp,-32
    80001cfc:	ec06                	sd	ra,24(sp)
    80001cfe:	e822                	sd	s0,16(sp)
    80001d00:	e426                	sd	s1,8(sp)
    80001d02:	1000                	addi	s0,sp,32
  p = allocproc();
    80001d04:	00000097          	auipc	ra,0x0
    80001d08:	ede080e7          	jalr	-290(ra) # 80001be2 <allocproc>
    80001d0c:	84aa                	mv	s1,a0
  initproc = p;
    80001d0e:	00007797          	auipc	a5,0x7
    80001d12:	30a7bd23          	sd	a0,794(a5) # 80009028 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001d16:	03400613          	li	a2,52
    80001d1a:	00007597          	auipc	a1,0x7
    80001d1e:	c4658593          	addi	a1,a1,-954 # 80008960 <initcode>
    80001d22:	6928                	ld	a0,80(a0)
    80001d24:	fffff097          	auipc	ra,0xfffff
    80001d28:	630080e7          	jalr	1584(ra) # 80001354 <uvminit>
  p->sz = PGSIZE;
    80001d2c:	6785                	lui	a5,0x1
    80001d2e:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001d30:	6cb8                	ld	a4,88(s1)
    80001d32:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001d36:	6cb8                	ld	a4,88(s1)
    80001d38:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001d3a:	4641                	li	a2,16
    80001d3c:	00006597          	auipc	a1,0x6
    80001d40:	4c458593          	addi	a1,a1,1220 # 80008200 <digits+0x1c0>
    80001d44:	15848513          	addi	a0,s1,344
    80001d48:	fffff097          	auipc	ra,0xfffff
    80001d4c:	0ce080e7          	jalr	206(ra) # 80000e16 <safestrcpy>
  p->cwd = namei("/");
    80001d50:	00006517          	auipc	a0,0x6
    80001d54:	4c050513          	addi	a0,a0,1216 # 80008210 <digits+0x1d0>
    80001d58:	00003097          	auipc	ra,0x3
    80001d5c:	818080e7          	jalr	-2024(ra) # 80004570 <namei>
    80001d60:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001d64:	478d                	li	a5,3
    80001d66:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001d68:	8526                	mv	a0,s1
    80001d6a:	fffff097          	auipc	ra,0xfffff
    80001d6e:	f1a080e7          	jalr	-230(ra) # 80000c84 <release>
}
    80001d72:	60e2                	ld	ra,24(sp)
    80001d74:	6442                	ld	s0,16(sp)
    80001d76:	64a2                	ld	s1,8(sp)
    80001d78:	6105                	addi	sp,sp,32
    80001d7a:	8082                	ret

0000000080001d7c <growproc>:
{
    80001d7c:	1101                	addi	sp,sp,-32
    80001d7e:	ec06                	sd	ra,24(sp)
    80001d80:	e822                	sd	s0,16(sp)
    80001d82:	e426                	sd	s1,8(sp)
    80001d84:	e04a                	sd	s2,0(sp)
    80001d86:	1000                	addi	s0,sp,32
    80001d88:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001d8a:	00000097          	auipc	ra,0x0
    80001d8e:	c4e080e7          	jalr	-946(ra) # 800019d8 <myproc>
    80001d92:	892a                	mv	s2,a0
  sz = p->sz;
    80001d94:	652c                	ld	a1,72(a0)
    80001d96:	0005879b          	sext.w	a5,a1
  if(n > 0){
    80001d9a:	00904f63          	bgtz	s1,80001db8 <growproc+0x3c>
  } else if(n < 0){
    80001d9e:	0204cd63          	bltz	s1,80001dd8 <growproc+0x5c>
  p->sz = sz;
    80001da2:	1782                	slli	a5,a5,0x20
    80001da4:	9381                	srli	a5,a5,0x20
    80001da6:	04f93423          	sd	a5,72(s2)
  return 0;
    80001daa:	4501                	li	a0,0
}
    80001dac:	60e2                	ld	ra,24(sp)
    80001dae:	6442                	ld	s0,16(sp)
    80001db0:	64a2                	ld	s1,8(sp)
    80001db2:	6902                	ld	s2,0(sp)
    80001db4:	6105                	addi	sp,sp,32
    80001db6:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001db8:	00f4863b          	addw	a2,s1,a5
    80001dbc:	1602                	slli	a2,a2,0x20
    80001dbe:	9201                	srli	a2,a2,0x20
    80001dc0:	1582                	slli	a1,a1,0x20
    80001dc2:	9181                	srli	a1,a1,0x20
    80001dc4:	6928                	ld	a0,80(a0)
    80001dc6:	fffff097          	auipc	ra,0xfffff
    80001dca:	648080e7          	jalr	1608(ra) # 8000140e <uvmalloc>
    80001dce:	0005079b          	sext.w	a5,a0
    80001dd2:	fbe1                	bnez	a5,80001da2 <growproc+0x26>
      return -1;
    80001dd4:	557d                	li	a0,-1
    80001dd6:	bfd9                	j	80001dac <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001dd8:	00f4863b          	addw	a2,s1,a5
    80001ddc:	1602                	slli	a2,a2,0x20
    80001dde:	9201                	srli	a2,a2,0x20
    80001de0:	1582                	slli	a1,a1,0x20
    80001de2:	9181                	srli	a1,a1,0x20
    80001de4:	6928                	ld	a0,80(a0)
    80001de6:	fffff097          	auipc	ra,0xfffff
    80001dea:	5e0080e7          	jalr	1504(ra) # 800013c6 <uvmdealloc>
    80001dee:	0005079b          	sext.w	a5,a0
    80001df2:	bf45                	j	80001da2 <growproc+0x26>

0000000080001df4 <fork>:
{
    80001df4:	7139                	addi	sp,sp,-64
    80001df6:	fc06                	sd	ra,56(sp)
    80001df8:	f822                	sd	s0,48(sp)
    80001dfa:	f426                	sd	s1,40(sp)
    80001dfc:	f04a                	sd	s2,32(sp)
    80001dfe:	ec4e                	sd	s3,24(sp)
    80001e00:	e852                	sd	s4,16(sp)
    80001e02:	e456                	sd	s5,8(sp)
    80001e04:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001e06:	00000097          	auipc	ra,0x0
    80001e0a:	bd2080e7          	jalr	-1070(ra) # 800019d8 <myproc>
    80001e0e:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001e10:	00000097          	auipc	ra,0x0
    80001e14:	dd2080e7          	jalr	-558(ra) # 80001be2 <allocproc>
    80001e18:	12050063          	beqz	a0,80001f38 <fork+0x144>
    80001e1c:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001e1e:	048ab603          	ld	a2,72(s5)
    80001e22:	692c                	ld	a1,80(a0)
    80001e24:	050ab503          	ld	a0,80(s5)
    80001e28:	fffff097          	auipc	ra,0xfffff
    80001e2c:	736080e7          	jalr	1846(ra) # 8000155e <uvmcopy>
    80001e30:	04054c63          	bltz	a0,80001e88 <fork+0x94>
  np->sz = p->sz;
    80001e34:	048ab783          	ld	a5,72(s5)
    80001e38:	04f9b423          	sd	a5,72(s3)
  np->trace_mask = p->trace_mask;
    80001e3c:	168aa783          	lw	a5,360(s5)
    80001e40:	16f9a423          	sw	a5,360(s3)
  *(np->trapframe) = *(p->trapframe);
    80001e44:	058ab683          	ld	a3,88(s5)
    80001e48:	87b6                	mv	a5,a3
    80001e4a:	0589b703          	ld	a4,88(s3)
    80001e4e:	12068693          	addi	a3,a3,288
    80001e52:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001e56:	6788                	ld	a0,8(a5)
    80001e58:	6b8c                	ld	a1,16(a5)
    80001e5a:	6f90                	ld	a2,24(a5)
    80001e5c:	01073023          	sd	a6,0(a4)
    80001e60:	e708                	sd	a0,8(a4)
    80001e62:	eb0c                	sd	a1,16(a4)
    80001e64:	ef10                	sd	a2,24(a4)
    80001e66:	02078793          	addi	a5,a5,32
    80001e6a:	02070713          	addi	a4,a4,32
    80001e6e:	fed792e3          	bne	a5,a3,80001e52 <fork+0x5e>
  np->trapframe->a0 = 0;
    80001e72:	0589b783          	ld	a5,88(s3)
    80001e76:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001e7a:	0d0a8493          	addi	s1,s5,208
    80001e7e:	0d098913          	addi	s2,s3,208
    80001e82:	150a8a13          	addi	s4,s5,336
    80001e86:	a00d                	j	80001ea8 <fork+0xb4>
    freeproc(np);
    80001e88:	854e                	mv	a0,s3
    80001e8a:	00000097          	auipc	ra,0x0
    80001e8e:	d00080e7          	jalr	-768(ra) # 80001b8a <freeproc>
    release(&np->lock);
    80001e92:	854e                	mv	a0,s3
    80001e94:	fffff097          	auipc	ra,0xfffff
    80001e98:	df0080e7          	jalr	-528(ra) # 80000c84 <release>
    return -1;
    80001e9c:	597d                	li	s2,-1
    80001e9e:	a059                	j	80001f24 <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    80001ea0:	04a1                	addi	s1,s1,8
    80001ea2:	0921                	addi	s2,s2,8
    80001ea4:	01448b63          	beq	s1,s4,80001eba <fork+0xc6>
    if(p->ofile[i])
    80001ea8:	6088                	ld	a0,0(s1)
    80001eaa:	d97d                	beqz	a0,80001ea0 <fork+0xac>
      np->ofile[i] = filedup(p->ofile[i]);
    80001eac:	00003097          	auipc	ra,0x3
    80001eb0:	d5a080e7          	jalr	-678(ra) # 80004c06 <filedup>
    80001eb4:	00a93023          	sd	a0,0(s2)
    80001eb8:	b7e5                	j	80001ea0 <fork+0xac>
  np->cwd = idup(p->cwd);
    80001eba:	150ab503          	ld	a0,336(s5)
    80001ebe:	00002097          	auipc	ra,0x2
    80001ec2:	eb8080e7          	jalr	-328(ra) # 80003d76 <idup>
    80001ec6:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001eca:	4641                	li	a2,16
    80001ecc:	158a8593          	addi	a1,s5,344
    80001ed0:	15898513          	addi	a0,s3,344
    80001ed4:	fffff097          	auipc	ra,0xfffff
    80001ed8:	f42080e7          	jalr	-190(ra) # 80000e16 <safestrcpy>
  pid = np->pid;
    80001edc:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    80001ee0:	854e                	mv	a0,s3
    80001ee2:	fffff097          	auipc	ra,0xfffff
    80001ee6:	da2080e7          	jalr	-606(ra) # 80000c84 <release>
  acquire(&wait_lock);
    80001eea:	0000f497          	auipc	s1,0xf
    80001eee:	3ce48493          	addi	s1,s1,974 # 800112b8 <wait_lock>
    80001ef2:	8526                	mv	a0,s1
    80001ef4:	fffff097          	auipc	ra,0xfffff
    80001ef8:	cdc080e7          	jalr	-804(ra) # 80000bd0 <acquire>
  np->parent = p;
    80001efc:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001f00:	8526                	mv	a0,s1
    80001f02:	fffff097          	auipc	ra,0xfffff
    80001f06:	d82080e7          	jalr	-638(ra) # 80000c84 <release>
  acquire(&np->lock);
    80001f0a:	854e                	mv	a0,s3
    80001f0c:	fffff097          	auipc	ra,0xfffff
    80001f10:	cc4080e7          	jalr	-828(ra) # 80000bd0 <acquire>
  np->state = RUNNABLE;
    80001f14:	478d                	li	a5,3
    80001f16:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001f1a:	854e                	mv	a0,s3
    80001f1c:	fffff097          	auipc	ra,0xfffff
    80001f20:	d68080e7          	jalr	-664(ra) # 80000c84 <release>
}
    80001f24:	854a                	mv	a0,s2
    80001f26:	70e2                	ld	ra,56(sp)
    80001f28:	7442                	ld	s0,48(sp)
    80001f2a:	74a2                	ld	s1,40(sp)
    80001f2c:	7902                	ld	s2,32(sp)
    80001f2e:	69e2                	ld	s3,24(sp)
    80001f30:	6a42                	ld	s4,16(sp)
    80001f32:	6aa2                	ld	s5,8(sp)
    80001f34:	6121                	addi	sp,sp,64
    80001f36:	8082                	ret
    return -1;
    80001f38:	597d                	li	s2,-1
    80001f3a:	b7ed                	j	80001f24 <fork+0x130>

0000000080001f3c <RunningTime>:
{
    80001f3c:	7179                	addi	sp,sp,-48
    80001f3e:	f406                	sd	ra,40(sp)
    80001f40:	f022                	sd	s0,32(sp)
    80001f42:	ec26                	sd	s1,24(sp)
    80001f44:	e84a                	sd	s2,16(sp)
    80001f46:	e44e                	sd	s3,8(sp)
    80001f48:	1800                	addi	s0,sp,48
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f4a:	00011497          	auipc	s1,0x11
    80001f4e:	bae48493          	addi	s1,s1,-1106 # 80012af8 <proc>
    if(p->state == RUNNING){
    80001f52:	4991                	li	s3,4
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f54:	00018917          	auipc	s2,0x18
    80001f58:	ba490913          	addi	s2,s2,-1116 # 80019af8 <tickslock>
    80001f5c:	a811                	j	80001f70 <RunningTime+0x34>
    release(&p->lock);
    80001f5e:	8526                	mv	a0,s1
    80001f60:	fffff097          	auipc	ra,0xfffff
    80001f64:	d24080e7          	jalr	-732(ra) # 80000c84 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f68:	1c048493          	addi	s1,s1,448
    80001f6c:	05248363          	beq	s1,s2,80001fb2 <RunningTime+0x76>
    acquire(&p->lock);
    80001f70:	8526                	mv	a0,s1
    80001f72:	fffff097          	auipc	ra,0xfffff
    80001f76:	c5e080e7          	jalr	-930(ra) # 80000bd0 <acquire>
    if(p->state == RUNNING){
    80001f7a:	4c9c                	lw	a5,24(s1)
    80001f7c:	ff3791e3          	bne	a5,s3,80001f5e <RunningTime+0x22>
      p->runtime++;  
    80001f80:	1804a783          	lw	a5,384(s1)
    80001f84:	2785                	addiw	a5,a5,1
    80001f86:	18f4a023          	sw	a5,384(s1)
      p->rtime++;  
    80001f8a:	1ac4a783          	lw	a5,428(s1)
    80001f8e:	2785                	addiw	a5,a5,1
    80001f90:	1af4a623          	sw	a5,428(s1)
      p->timeinQ--;
    80001f94:	1904a783          	lw	a5,400(s1)
    80001f98:	37fd                	addiw	a5,a5,-1
    80001f9a:	18f4a823          	sw	a5,400(s1)
      p->timeineachq[p->level]++;
    80001f9e:	18c4e783          	lwu	a5,396(s1)
    80001fa2:	078a                	slli	a5,a5,0x2
    80001fa4:	97a6                	add	a5,a5,s1
    80001fa6:	1987a703          	lw	a4,408(a5)
    80001faa:	2705                	addiw	a4,a4,1
    80001fac:	18e7ac23          	sw	a4,408(a5)
    80001fb0:	b77d                	j	80001f5e <RunningTime+0x22>
}
    80001fb2:	70a2                	ld	ra,40(sp)
    80001fb4:	7402                	ld	s0,32(sp)
    80001fb6:	64e2                	ld	s1,24(sp)
    80001fb8:	6942                	ld	s2,16(sp)
    80001fba:	69a2                	ld	s3,8(sp)
    80001fbc:	6145                	addi	sp,sp,48
    80001fbe:	8082                	ret

0000000080001fc0 <sched>:
{
    80001fc0:	1101                	addi	sp,sp,-32
    80001fc2:	ec06                	sd	ra,24(sp)
    80001fc4:	e822                	sd	s0,16(sp)
    80001fc6:	e426                	sd	s1,8(sp)
    80001fc8:	e04a                	sd	s2,0(sp)
    80001fca:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001fcc:	00000097          	auipc	ra,0x0
    80001fd0:	a0c080e7          	jalr	-1524(ra) # 800019d8 <myproc>
    80001fd4:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001fd6:	2781                	sext.w	a5,a5
    80001fd8:	079e                	slli	a5,a5,0x7
    80001fda:	0000f717          	auipc	a4,0xf
    80001fde:	2c670713          	addi	a4,a4,710 # 800112a0 <pid_lock>
    80001fe2:	97ba                	add	a5,a5,a4
    80001fe4:	0a87a703          	lw	a4,168(a5)
    80001fe8:	4785                	li	a5,1
    80001fea:	04f71e63          	bne	a4,a5,80002046 <sched+0x86>
  if(p->state == RUNNING)
    80001fee:	4d18                	lw	a4,24(a0)
    80001ff0:	4791                	li	a5,4
    80001ff2:	06f70263          	beq	a4,a5,80002056 <sched+0x96>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ff6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ffa:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001ffc:	e7ad                	bnez	a5,80002066 <sched+0xa6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001ffe:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002000:	0000f497          	auipc	s1,0xf
    80002004:	2a048493          	addi	s1,s1,672 # 800112a0 <pid_lock>
    80002008:	2781                	sext.w	a5,a5
    8000200a:	079e                	slli	a5,a5,0x7
    8000200c:	97a6                	add	a5,a5,s1
    8000200e:	0ac7a903          	lw	s2,172(a5)
    80002012:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002014:	2781                	sext.w	a5,a5
    80002016:	079e                	slli	a5,a5,0x7
    80002018:	0000f597          	auipc	a1,0xf
    8000201c:	2c058593          	addi	a1,a1,704 # 800112d8 <cpus+0x8>
    80002020:	95be                	add	a1,a1,a5
    80002022:	06050513          	addi	a0,a0,96
    80002026:	00001097          	auipc	ra,0x1
    8000202a:	a9c080e7          	jalr	-1380(ra) # 80002ac2 <swtch>
    8000202e:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002030:	2781                	sext.w	a5,a5
    80002032:	079e                	slli	a5,a5,0x7
    80002034:	94be                	add	s1,s1,a5
    80002036:	0b24a623          	sw	s2,172(s1)
}
    8000203a:	60e2                	ld	ra,24(sp)
    8000203c:	6442                	ld	s0,16(sp)
    8000203e:	64a2                	ld	s1,8(sp)
    80002040:	6902                	ld	s2,0(sp)
    80002042:	6105                	addi	sp,sp,32
    80002044:	8082                	ret
    panic("sched locks");
    80002046:	00006517          	auipc	a0,0x6
    8000204a:	1d250513          	addi	a0,a0,466 # 80008218 <digits+0x1d8>
    8000204e:	ffffe097          	auipc	ra,0xffffe
    80002052:	4ec080e7          	jalr	1260(ra) # 8000053a <panic>
    panic("sched running");
    80002056:	00006517          	auipc	a0,0x6
    8000205a:	1d250513          	addi	a0,a0,466 # 80008228 <digits+0x1e8>
    8000205e:	ffffe097          	auipc	ra,0xffffe
    80002062:	4dc080e7          	jalr	1244(ra) # 8000053a <panic>
    panic("sched interruptible");
    80002066:	00006517          	auipc	a0,0x6
    8000206a:	1d250513          	addi	a0,a0,466 # 80008238 <digits+0x1f8>
    8000206e:	ffffe097          	auipc	ra,0xffffe
    80002072:	4cc080e7          	jalr	1228(ra) # 8000053a <panic>

0000000080002076 <yield>:
{
    80002076:	1101                	addi	sp,sp,-32
    80002078:	ec06                	sd	ra,24(sp)
    8000207a:	e822                	sd	s0,16(sp)
    8000207c:	e426                	sd	s1,8(sp)
    8000207e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002080:	00000097          	auipc	ra,0x0
    80002084:	958080e7          	jalr	-1704(ra) # 800019d8 <myproc>
    80002088:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000208a:	fffff097          	auipc	ra,0xfffff
    8000208e:	b46080e7          	jalr	-1210(ra) # 80000bd0 <acquire>
  p->state = RUNNABLE;
    80002092:	478d                	li	a5,3
    80002094:	cc9c                	sw	a5,24(s1)
  p->sched2 = ticks;
    80002096:	00007797          	auipc	a5,0x7
    8000209a:	f9a7a783          	lw	a5,-102(a5) # 80009030 <ticks>
    8000209e:	18f4a223          	sw	a5,388(s1)
  sched();
    800020a2:	00000097          	auipc	ra,0x0
    800020a6:	f1e080e7          	jalr	-226(ra) # 80001fc0 <sched>
  release(&p->lock);
    800020aa:	8526                	mv	a0,s1
    800020ac:	fffff097          	auipc	ra,0xfffff
    800020b0:	bd8080e7          	jalr	-1064(ra) # 80000c84 <release>
}
    800020b4:	60e2                	ld	ra,24(sp)
    800020b6:	6442                	ld	s0,16(sp)
    800020b8:	64a2                	ld	s1,8(sp)
    800020ba:	6105                	addi	sp,sp,32
    800020bc:	8082                	ret

00000000800020be <sleep>:


// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk){
    800020be:	7179                	addi	sp,sp,-48
    800020c0:	f406                	sd	ra,40(sp)
    800020c2:	f022                	sd	s0,32(sp)
    800020c4:	ec26                	sd	s1,24(sp)
    800020c6:	e84a                	sd	s2,16(sp)
    800020c8:	e44e                	sd	s3,8(sp)
    800020ca:	1800                	addi	s0,sp,48
    800020cc:	89aa                	mv	s3,a0
    800020ce:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800020d0:	00000097          	auipc	ra,0x0
    800020d4:	908080e7          	jalr	-1784(ra) # 800019d8 <myproc>
    800020d8:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),ML
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800020da:	fffff097          	auipc	ra,0xfffff
    800020de:	af6080e7          	jalr	-1290(ra) # 80000bd0 <acquire>
  release(lk);
    800020e2:	854a                	mv	a0,s2
    800020e4:	fffff097          	auipc	ra,0xfffff
    800020e8:	ba0080e7          	jalr	-1120(ra) # 80000c84 <release>

  // Go to sleep.
  p->chan = chan;
    800020ec:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800020f0:	4789                	li	a5,2
    800020f2:	cc9c                	sw	a5,24(s1)

  sched();
    800020f4:	00000097          	auipc	ra,0x0
    800020f8:	ecc080e7          	jalr	-308(ra) # 80001fc0 <sched>

  // Tidy up.
  p->chan = 0;
    800020fc:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002100:	8526                	mv	a0,s1
    80002102:	fffff097          	auipc	ra,0xfffff
    80002106:	b82080e7          	jalr	-1150(ra) # 80000c84 <release>
  acquire(lk);
    8000210a:	854a                	mv	a0,s2
    8000210c:	fffff097          	auipc	ra,0xfffff
    80002110:	ac4080e7          	jalr	-1340(ra) # 80000bd0 <acquire>
}
    80002114:	70a2                	ld	ra,40(sp)
    80002116:	7402                	ld	s0,32(sp)
    80002118:	64e2                	ld	s1,24(sp)
    8000211a:	6942                	ld	s2,16(sp)
    8000211c:	69a2                	ld	s3,8(sp)
    8000211e:	6145                	addi	sp,sp,48
    80002120:	8082                	ret

0000000080002122 <wait>:
{
    80002122:	715d                	addi	sp,sp,-80
    80002124:	e486                	sd	ra,72(sp)
    80002126:	e0a2                	sd	s0,64(sp)
    80002128:	fc26                	sd	s1,56(sp)
    8000212a:	f84a                	sd	s2,48(sp)
    8000212c:	f44e                	sd	s3,40(sp)
    8000212e:	f052                	sd	s4,32(sp)
    80002130:	ec56                	sd	s5,24(sp)
    80002132:	e85a                	sd	s6,16(sp)
    80002134:	e45e                	sd	s7,8(sp)
    80002136:	e062                	sd	s8,0(sp)
    80002138:	0880                	addi	s0,sp,80
    8000213a:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000213c:	00000097          	auipc	ra,0x0
    80002140:	89c080e7          	jalr	-1892(ra) # 800019d8 <myproc>
    80002144:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002146:	0000f517          	auipc	a0,0xf
    8000214a:	17250513          	addi	a0,a0,370 # 800112b8 <wait_lock>
    8000214e:	fffff097          	auipc	ra,0xfffff
    80002152:	a82080e7          	jalr	-1406(ra) # 80000bd0 <acquire>
    havekids = 0;
    80002156:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80002158:	4a15                	li	s4,5
        havekids = 1;
    8000215a:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    8000215c:	00018997          	auipc	s3,0x18
    80002160:	99c98993          	addi	s3,s3,-1636 # 80019af8 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002164:	0000fc17          	auipc	s8,0xf
    80002168:	154c0c13          	addi	s8,s8,340 # 800112b8 <wait_lock>
    havekids = 0;
    8000216c:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000216e:	00011497          	auipc	s1,0x11
    80002172:	98a48493          	addi	s1,s1,-1654 # 80012af8 <proc>
    80002176:	a0bd                	j	800021e4 <wait+0xc2>
          pid = np->pid;
    80002178:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000217c:	000b0e63          	beqz	s6,80002198 <wait+0x76>
    80002180:	4691                	li	a3,4
    80002182:	02c48613          	addi	a2,s1,44
    80002186:	85da                	mv	a1,s6
    80002188:	05093503          	ld	a0,80(s2)
    8000218c:	fffff097          	auipc	ra,0xfffff
    80002190:	4d6080e7          	jalr	1238(ra) # 80001662 <copyout>
    80002194:	02054563          	bltz	a0,800021be <wait+0x9c>
          freeproc(np);
    80002198:	8526                	mv	a0,s1
    8000219a:	00000097          	auipc	ra,0x0
    8000219e:	9f0080e7          	jalr	-1552(ra) # 80001b8a <freeproc>
          release(&np->lock);
    800021a2:	8526                	mv	a0,s1
    800021a4:	fffff097          	auipc	ra,0xfffff
    800021a8:	ae0080e7          	jalr	-1312(ra) # 80000c84 <release>
          release(&wait_lock);
    800021ac:	0000f517          	auipc	a0,0xf
    800021b0:	10c50513          	addi	a0,a0,268 # 800112b8 <wait_lock>
    800021b4:	fffff097          	auipc	ra,0xfffff
    800021b8:	ad0080e7          	jalr	-1328(ra) # 80000c84 <release>
          return pid;
    800021bc:	a09d                	j	80002222 <wait+0x100>
            release(&np->lock);
    800021be:	8526                	mv	a0,s1
    800021c0:	fffff097          	auipc	ra,0xfffff
    800021c4:	ac4080e7          	jalr	-1340(ra) # 80000c84 <release>
            release(&wait_lock);
    800021c8:	0000f517          	auipc	a0,0xf
    800021cc:	0f050513          	addi	a0,a0,240 # 800112b8 <wait_lock>
    800021d0:	fffff097          	auipc	ra,0xfffff
    800021d4:	ab4080e7          	jalr	-1356(ra) # 80000c84 <release>
            return -1;
    800021d8:	59fd                	li	s3,-1
    800021da:	a0a1                	j	80002222 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    800021dc:	1c048493          	addi	s1,s1,448
    800021e0:	03348463          	beq	s1,s3,80002208 <wait+0xe6>
      if(np->parent == p){
    800021e4:	7c9c                	ld	a5,56(s1)
    800021e6:	ff279be3          	bne	a5,s2,800021dc <wait+0xba>
        acquire(&np->lock);
    800021ea:	8526                	mv	a0,s1
    800021ec:	fffff097          	auipc	ra,0xfffff
    800021f0:	9e4080e7          	jalr	-1564(ra) # 80000bd0 <acquire>
        if(np->state == ZOMBIE){
    800021f4:	4c9c                	lw	a5,24(s1)
    800021f6:	f94781e3          	beq	a5,s4,80002178 <wait+0x56>
        release(&np->lock);
    800021fa:	8526                	mv	a0,s1
    800021fc:	fffff097          	auipc	ra,0xfffff
    80002200:	a88080e7          	jalr	-1400(ra) # 80000c84 <release>
        havekids = 1;
    80002204:	8756                	mv	a4,s5
    80002206:	bfd9                	j	800021dc <wait+0xba>
    if(!havekids || p->killed){
    80002208:	c701                	beqz	a4,80002210 <wait+0xee>
    8000220a:	02892783          	lw	a5,40(s2)
    8000220e:	c79d                	beqz	a5,8000223c <wait+0x11a>
      release(&wait_lock);
    80002210:	0000f517          	auipc	a0,0xf
    80002214:	0a850513          	addi	a0,a0,168 # 800112b8 <wait_lock>
    80002218:	fffff097          	auipc	ra,0xfffff
    8000221c:	a6c080e7          	jalr	-1428(ra) # 80000c84 <release>
      return -1;
    80002220:	59fd                	li	s3,-1
}
    80002222:	854e                	mv	a0,s3
    80002224:	60a6                	ld	ra,72(sp)
    80002226:	6406                	ld	s0,64(sp)
    80002228:	74e2                	ld	s1,56(sp)
    8000222a:	7942                	ld	s2,48(sp)
    8000222c:	79a2                	ld	s3,40(sp)
    8000222e:	7a02                	ld	s4,32(sp)
    80002230:	6ae2                	ld	s5,24(sp)
    80002232:	6b42                	ld	s6,16(sp)
    80002234:	6ba2                	ld	s7,8(sp)
    80002236:	6c02                	ld	s8,0(sp)
    80002238:	6161                	addi	sp,sp,80
    8000223a:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000223c:	85e2                	mv	a1,s8
    8000223e:	854a                	mv	a0,s2
    80002240:	00000097          	auipc	ra,0x0
    80002244:	e7e080e7          	jalr	-386(ra) # 800020be <sleep>
    havekids = 0;
    80002248:	b715                	j	8000216c <wait+0x4a>

000000008000224a <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000224a:	7139                	addi	sp,sp,-64
    8000224c:	fc06                	sd	ra,56(sp)
    8000224e:	f822                	sd	s0,48(sp)
    80002250:	f426                	sd	s1,40(sp)
    80002252:	f04a                	sd	s2,32(sp)
    80002254:	ec4e                	sd	s3,24(sp)
    80002256:	e852                	sd	s4,16(sp)
    80002258:	e456                	sd	s5,8(sp)
    8000225a:	e05a                	sd	s6,0(sp)
    8000225c:	0080                	addi	s0,sp,64
    8000225e:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80002260:	00011497          	auipc	s1,0x11
    80002264:	89848493          	addi	s1,s1,-1896 # 80012af8 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80002268:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000226a:	4b0d                	li	s6,3
        p->sched2 = ticks;
    8000226c:	00007a97          	auipc	s5,0x7
    80002270:	dc4a8a93          	addi	s5,s5,-572 # 80009030 <ticks>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002274:	00018917          	auipc	s2,0x18
    80002278:	88490913          	addi	s2,s2,-1916 # 80019af8 <tickslock>
    8000227c:	a811                	j	80002290 <wakeup+0x46>
      }
      release(&p->lock);
    8000227e:	8526                	mv	a0,s1
    80002280:	fffff097          	auipc	ra,0xfffff
    80002284:	a04080e7          	jalr	-1532(ra) # 80000c84 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002288:	1c048493          	addi	s1,s1,448
    8000228c:	03248a63          	beq	s1,s2,800022c0 <wakeup+0x76>
    if(p != myproc()){
    80002290:	fffff097          	auipc	ra,0xfffff
    80002294:	748080e7          	jalr	1864(ra) # 800019d8 <myproc>
    80002298:	fea488e3          	beq	s1,a0,80002288 <wakeup+0x3e>
      acquire(&p->lock);
    8000229c:	8526                	mv	a0,s1
    8000229e:	fffff097          	auipc	ra,0xfffff
    800022a2:	932080e7          	jalr	-1742(ra) # 80000bd0 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800022a6:	4c9c                	lw	a5,24(s1)
    800022a8:	fd379be3          	bne	a5,s3,8000227e <wakeup+0x34>
    800022ac:	709c                	ld	a5,32(s1)
    800022ae:	fd4798e3          	bne	a5,s4,8000227e <wakeup+0x34>
        p->state = RUNNABLE;
    800022b2:	0164ac23          	sw	s6,24(s1)
        p->sched2 = ticks;
    800022b6:	000aa783          	lw	a5,0(s5)
    800022ba:	18f4a223          	sw	a5,388(s1)
    800022be:	b7c1                	j	8000227e <wakeup+0x34>
    }
  }
}
    800022c0:	70e2                	ld	ra,56(sp)
    800022c2:	7442                	ld	s0,48(sp)
    800022c4:	74a2                	ld	s1,40(sp)
    800022c6:	7902                	ld	s2,32(sp)
    800022c8:	69e2                	ld	s3,24(sp)
    800022ca:	6a42                	ld	s4,16(sp)
    800022cc:	6aa2                	ld	s5,8(sp)
    800022ce:	6b02                	ld	s6,0(sp)
    800022d0:	6121                	addi	sp,sp,64
    800022d2:	8082                	ret

00000000800022d4 <reparent>:
{
    800022d4:	7179                	addi	sp,sp,-48
    800022d6:	f406                	sd	ra,40(sp)
    800022d8:	f022                	sd	s0,32(sp)
    800022da:	ec26                	sd	s1,24(sp)
    800022dc:	e84a                	sd	s2,16(sp)
    800022de:	e44e                	sd	s3,8(sp)
    800022e0:	e052                	sd	s4,0(sp)
    800022e2:	1800                	addi	s0,sp,48
    800022e4:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800022e6:	00011497          	auipc	s1,0x11
    800022ea:	81248493          	addi	s1,s1,-2030 # 80012af8 <proc>
      pp->parent = initproc;
    800022ee:	00007a17          	auipc	s4,0x7
    800022f2:	d3aa0a13          	addi	s4,s4,-710 # 80009028 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800022f6:	00018997          	auipc	s3,0x18
    800022fa:	80298993          	addi	s3,s3,-2046 # 80019af8 <tickslock>
    800022fe:	a029                	j	80002308 <reparent+0x34>
    80002300:	1c048493          	addi	s1,s1,448
    80002304:	01348d63          	beq	s1,s3,8000231e <reparent+0x4a>
    if(pp->parent == p){
    80002308:	7c9c                	ld	a5,56(s1)
    8000230a:	ff279be3          	bne	a5,s2,80002300 <reparent+0x2c>
      pp->parent = initproc;
    8000230e:	000a3503          	ld	a0,0(s4)
    80002312:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80002314:	00000097          	auipc	ra,0x0
    80002318:	f36080e7          	jalr	-202(ra) # 8000224a <wakeup>
    8000231c:	b7d5                	j	80002300 <reparent+0x2c>
}
    8000231e:	70a2                	ld	ra,40(sp)
    80002320:	7402                	ld	s0,32(sp)
    80002322:	64e2                	ld	s1,24(sp)
    80002324:	6942                	ld	s2,16(sp)
    80002326:	69a2                	ld	s3,8(sp)
    80002328:	6a02                	ld	s4,0(sp)
    8000232a:	6145                	addi	sp,sp,48
    8000232c:	8082                	ret

000000008000232e <exit>:
{
    8000232e:	7179                	addi	sp,sp,-48
    80002330:	f406                	sd	ra,40(sp)
    80002332:	f022                	sd	s0,32(sp)
    80002334:	ec26                	sd	s1,24(sp)
    80002336:	e84a                	sd	s2,16(sp)
    80002338:	e44e                	sd	s3,8(sp)
    8000233a:	e052                	sd	s4,0(sp)
    8000233c:	1800                	addi	s0,sp,48
    8000233e:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002340:	fffff097          	auipc	ra,0xfffff
    80002344:	698080e7          	jalr	1688(ra) # 800019d8 <myproc>
    80002348:	89aa                	mv	s3,a0
  if(p == initproc)
    8000234a:	00007797          	auipc	a5,0x7
    8000234e:	cde7b783          	ld	a5,-802(a5) # 80009028 <initproc>
    80002352:	0d050493          	addi	s1,a0,208
    80002356:	15050913          	addi	s2,a0,336
    8000235a:	02a79363          	bne	a5,a0,80002380 <exit+0x52>
    panic("init exiting");
    8000235e:	00006517          	auipc	a0,0x6
    80002362:	ef250513          	addi	a0,a0,-270 # 80008250 <digits+0x210>
    80002366:	ffffe097          	auipc	ra,0xffffe
    8000236a:	1d4080e7          	jalr	468(ra) # 8000053a <panic>
      fileclose(f);
    8000236e:	00003097          	auipc	ra,0x3
    80002372:	8ea080e7          	jalr	-1814(ra) # 80004c58 <fileclose>
      p->ofile[fd] = 0;
    80002376:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000237a:	04a1                	addi	s1,s1,8
    8000237c:	01248563          	beq	s1,s2,80002386 <exit+0x58>
    if(p->ofile[fd]){
    80002380:	6088                	ld	a0,0(s1)
    80002382:	f575                	bnez	a0,8000236e <exit+0x40>
    80002384:	bfdd                	j	8000237a <exit+0x4c>
  begin_op();
    80002386:	00002097          	auipc	ra,0x2
    8000238a:	40a080e7          	jalr	1034(ra) # 80004790 <begin_op>
  iput(p->cwd);
    8000238e:	1509b503          	ld	a0,336(s3)
    80002392:	00002097          	auipc	ra,0x2
    80002396:	bdc080e7          	jalr	-1060(ra) # 80003f6e <iput>
  end_op();
    8000239a:	00002097          	auipc	ra,0x2
    8000239e:	474080e7          	jalr	1140(ra) # 8000480e <end_op>
  p->cwd = 0;
    800023a2:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800023a6:	0000f497          	auipc	s1,0xf
    800023aa:	f1248493          	addi	s1,s1,-238 # 800112b8 <wait_lock>
    800023ae:	8526                	mv	a0,s1
    800023b0:	fffff097          	auipc	ra,0xfffff
    800023b4:	820080e7          	jalr	-2016(ra) # 80000bd0 <acquire>
  reparent(p);
    800023b8:	854e                	mv	a0,s3
    800023ba:	00000097          	auipc	ra,0x0
    800023be:	f1a080e7          	jalr	-230(ra) # 800022d4 <reparent>
  wakeup(p->parent);
    800023c2:	0389b503          	ld	a0,56(s3)
    800023c6:	00000097          	auipc	ra,0x0
    800023ca:	e84080e7          	jalr	-380(ra) # 8000224a <wakeup>
  acquire(&p->lock);
    800023ce:	854e                	mv	a0,s3
    800023d0:	fffff097          	auipc	ra,0xfffff
    800023d4:	800080e7          	jalr	-2048(ra) # 80000bd0 <acquire>
  p->xstate = status;
    800023d8:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800023dc:	4795                	li	a5,5
    800023de:	00f9ac23          	sw	a5,24(s3)
  p->etime = ticks;
    800023e2:	00007797          	auipc	a5,0x7
    800023e6:	c4e7a783          	lw	a5,-946(a5) # 80009030 <ticks>
    800023ea:	1af9aa23          	sw	a5,436(s3)
  release(&wait_lock);
    800023ee:	8526                	mv	a0,s1
    800023f0:	fffff097          	auipc	ra,0xfffff
    800023f4:	894080e7          	jalr	-1900(ra) # 80000c84 <release>
  sched();
    800023f8:	00000097          	auipc	ra,0x0
    800023fc:	bc8080e7          	jalr	-1080(ra) # 80001fc0 <sched>
  panic("zombie exit"); 
    80002400:	00006517          	auipc	a0,0x6
    80002404:	e6050513          	addi	a0,a0,-416 # 80008260 <digits+0x220>
    80002408:	ffffe097          	auipc	ra,0xffffe
    8000240c:	132080e7          	jalr	306(ra) # 8000053a <panic>

0000000080002410 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002410:	7179                	addi	sp,sp,-48
    80002412:	f406                	sd	ra,40(sp)
    80002414:	f022                	sd	s0,32(sp)
    80002416:	ec26                	sd	s1,24(sp)
    80002418:	e84a                	sd	s2,16(sp)
    8000241a:	e44e                	sd	s3,8(sp)
    8000241c:	1800                	addi	s0,sp,48
    8000241e:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002420:	00010497          	auipc	s1,0x10
    80002424:	6d848493          	addi	s1,s1,1752 # 80012af8 <proc>
    80002428:	00017997          	auipc	s3,0x17
    8000242c:	6d098993          	addi	s3,s3,1744 # 80019af8 <tickslock>
    acquire(&p->lock);
    80002430:	8526                	mv	a0,s1
    80002432:	ffffe097          	auipc	ra,0xffffe
    80002436:	79e080e7          	jalr	1950(ra) # 80000bd0 <acquire>
    if(p->pid == pid){
    8000243a:	589c                	lw	a5,48(s1)
    8000243c:	01278d63          	beq	a5,s2,80002456 <kill+0x46>
        p->sched2 = ticks;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002440:	8526                	mv	a0,s1
    80002442:	fffff097          	auipc	ra,0xfffff
    80002446:	842080e7          	jalr	-1982(ra) # 80000c84 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000244a:	1c048493          	addi	s1,s1,448
    8000244e:	ff3491e3          	bne	s1,s3,80002430 <kill+0x20>
  }
  return -1;
    80002452:	557d                	li	a0,-1
    80002454:	a829                	j	8000246e <kill+0x5e>
      p->killed = 1;
    80002456:	4785                	li	a5,1
    80002458:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000245a:	4c98                	lw	a4,24(s1)
    8000245c:	4789                	li	a5,2
    8000245e:	00f70f63          	beq	a4,a5,8000247c <kill+0x6c>
      release(&p->lock);
    80002462:	8526                	mv	a0,s1
    80002464:	fffff097          	auipc	ra,0xfffff
    80002468:	820080e7          	jalr	-2016(ra) # 80000c84 <release>
      return 0;
    8000246c:	4501                	li	a0,0
}
    8000246e:	70a2                	ld	ra,40(sp)
    80002470:	7402                	ld	s0,32(sp)
    80002472:	64e2                	ld	s1,24(sp)
    80002474:	6942                	ld	s2,16(sp)
    80002476:	69a2                	ld	s3,8(sp)
    80002478:	6145                	addi	sp,sp,48
    8000247a:	8082                	ret
        p->state = RUNNABLE;
    8000247c:	478d                	li	a5,3
    8000247e:	cc9c                	sw	a5,24(s1)
        p->sched2 = ticks;
    80002480:	00007797          	auipc	a5,0x7
    80002484:	bb07a783          	lw	a5,-1104(a5) # 80009030 <ticks>
    80002488:	18f4a223          	sw	a5,388(s1)
    8000248c:	bfd9                	j	80002462 <kill+0x52>

000000008000248e <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000248e:	7179                	addi	sp,sp,-48
    80002490:	f406                	sd	ra,40(sp)
    80002492:	f022                	sd	s0,32(sp)
    80002494:	ec26                	sd	s1,24(sp)
    80002496:	e84a                	sd	s2,16(sp)
    80002498:	e44e                	sd	s3,8(sp)
    8000249a:	e052                	sd	s4,0(sp)
    8000249c:	1800                	addi	s0,sp,48
    8000249e:	84aa                	mv	s1,a0
    800024a0:	892e                	mv	s2,a1
    800024a2:	89b2                	mv	s3,a2
    800024a4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800024a6:	fffff097          	auipc	ra,0xfffff
    800024aa:	532080e7          	jalr	1330(ra) # 800019d8 <myproc>
  if(user_dst){
    800024ae:	c08d                	beqz	s1,800024d0 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800024b0:	86d2                	mv	a3,s4
    800024b2:	864e                	mv	a2,s3
    800024b4:	85ca                	mv	a1,s2
    800024b6:	6928                	ld	a0,80(a0)
    800024b8:	fffff097          	auipc	ra,0xfffff
    800024bc:	1aa080e7          	jalr	426(ra) # 80001662 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800024c0:	70a2                	ld	ra,40(sp)
    800024c2:	7402                	ld	s0,32(sp)
    800024c4:	64e2                	ld	s1,24(sp)
    800024c6:	6942                	ld	s2,16(sp)
    800024c8:	69a2                	ld	s3,8(sp)
    800024ca:	6a02                	ld	s4,0(sp)
    800024cc:	6145                	addi	sp,sp,48
    800024ce:	8082                	ret
    memmove((char *)dst, src, len);
    800024d0:	000a061b          	sext.w	a2,s4
    800024d4:	85ce                	mv	a1,s3
    800024d6:	854a                	mv	a0,s2
    800024d8:	fffff097          	auipc	ra,0xfffff
    800024dc:	850080e7          	jalr	-1968(ra) # 80000d28 <memmove>
    return 0;
    800024e0:	8526                	mv	a0,s1
    800024e2:	bff9                	j	800024c0 <either_copyout+0x32>

00000000800024e4 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800024e4:	7179                	addi	sp,sp,-48
    800024e6:	f406                	sd	ra,40(sp)
    800024e8:	f022                	sd	s0,32(sp)
    800024ea:	ec26                	sd	s1,24(sp)
    800024ec:	e84a                	sd	s2,16(sp)
    800024ee:	e44e                	sd	s3,8(sp)
    800024f0:	e052                	sd	s4,0(sp)
    800024f2:	1800                	addi	s0,sp,48
    800024f4:	892a                	mv	s2,a0
    800024f6:	84ae                	mv	s1,a1
    800024f8:	89b2                	mv	s3,a2
    800024fa:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800024fc:	fffff097          	auipc	ra,0xfffff
    80002500:	4dc080e7          	jalr	1244(ra) # 800019d8 <myproc>
  if(user_src){
    80002504:	c08d                	beqz	s1,80002526 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002506:	86d2                	mv	a3,s4
    80002508:	864e                	mv	a2,s3
    8000250a:	85ca                	mv	a1,s2
    8000250c:	6928                	ld	a0,80(a0)
    8000250e:	fffff097          	auipc	ra,0xfffff
    80002512:	1e0080e7          	jalr	480(ra) # 800016ee <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002516:	70a2                	ld	ra,40(sp)
    80002518:	7402                	ld	s0,32(sp)
    8000251a:	64e2                	ld	s1,24(sp)
    8000251c:	6942                	ld	s2,16(sp)
    8000251e:	69a2                	ld	s3,8(sp)
    80002520:	6a02                	ld	s4,0(sp)
    80002522:	6145                	addi	sp,sp,48
    80002524:	8082                	ret
    memmove(dst, (char*)src, len);
    80002526:	000a061b          	sext.w	a2,s4
    8000252a:	85ce                	mv	a1,s3
    8000252c:	854a                	mv	a0,s2
    8000252e:	ffffe097          	auipc	ra,0xffffe
    80002532:	7fa080e7          	jalr	2042(ra) # 80000d28 <memmove>
    return 0;
    80002536:	8526                	mv	a0,s1
    80002538:	bff9                	j	80002516 <either_copyin+0x32>

000000008000253a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000253a:	7159                	addi	sp,sp,-112
    8000253c:	f486                	sd	ra,104(sp)
    8000253e:	f0a2                	sd	s0,96(sp)
    80002540:	eca6                	sd	s1,88(sp)
    80002542:	e8ca                	sd	s2,80(sp)
    80002544:	e4ce                	sd	s3,72(sp)
    80002546:	e0d2                	sd	s4,64(sp)
    80002548:	fc56                	sd	s5,56(sp)
    8000254a:	f85a                	sd	s6,48(sp)
    8000254c:	f45e                	sd	s7,40(sp)
    8000254e:	f062                	sd	s8,32(sp)
    80002550:	1880                	addi	s0,sp,112
    printf("%d\t%d\t%s\t%d\t%d\t%d\n", p->pid, p->dynamicPriority, state, p->rtime, ticks - p->birthtime - p->rtime, p->nrun);
    printf("\n");
  }
  #endif
  #ifdef MLFQ
  printf("\n");
    80002552:	00006517          	auipc	a0,0x6
    80002556:	f2e50513          	addi	a0,a0,-210 # 80008480 <states.0+0x170>
    8000255a:	ffffe097          	auipc	ra,0xffffe
    8000255e:	02a080e7          	jalr	42(ra) # 80000584 <printf>
  printf("PID\tPriority\tState\trtime\twtime\tnrun\tq0\tq1\tq2\tq3\tq4\n");
    80002562:	00006517          	auipc	a0,0x6
    80002566:	d1650513          	addi	a0,a0,-746 # 80008278 <digits+0x238>
    8000256a:	ffffe097          	auipc	ra,0xffffe
    8000256e:	01a080e7          	jalr	26(ra) # 80000584 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002572:	00010497          	auipc	s1,0x10
    80002576:	58648493          	addi	s1,s1,1414 # 80012af8 <proc>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000257a:	4b95                	li	s7,5
      state = states[p->state];
    else
      state = "???";
    8000257c:	00006997          	auipc	s3,0x6
    80002580:	cf498993          	addi	s3,s3,-780 # 80008270 <digits+0x230>
    printf("%d\t%d\t\t%s\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n", p->pid, p->level, state, p->rtime, ticks - p->qEnter, p->nrun, p->timeineachq[0], p->timeineachq[1], p->timeineachq[2], p->timeineachq[3], p->timeineachq[4]);
    80002584:	00007b17          	auipc	s6,0x7
    80002588:	aacb0b13          	addi	s6,s6,-1364 # 80009030 <ticks>
    8000258c:	00006a97          	auipc	s5,0x6
    80002590:	d24a8a93          	addi	s5,s5,-732 # 800082b0 <digits+0x270>
    printf("\n");
    80002594:	00006a17          	auipc	s4,0x6
    80002598:	eeca0a13          	addi	s4,s4,-276 # 80008480 <states.0+0x170>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000259c:	00006c17          	auipc	s8,0x6
    800025a0:	d74c0c13          	addi	s8,s8,-652 # 80008310 <states.0>
  for(p = proc; p < &proc[NPROC]; p++){
    800025a4:	00017917          	auipc	s2,0x17
    800025a8:	55490913          	addi	s2,s2,1364 # 80019af8 <tickslock>
    800025ac:	a891                	j	80002600 <procdump+0xc6>
    printf("%d\t%d\t\t%s\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n", p->pid, p->level, state, p->rtime, ticks - p->qEnter, p->nrun, p->timeineachq[0], p->timeineachq[1], p->timeineachq[2], p->timeineachq[3], p->timeineachq[4]);
    800025ae:	000b2703          	lw	a4,0(s6)
    800025b2:	1944a783          	lw	a5,404(s1)
    800025b6:	1a84a603          	lw	a2,424(s1)
    800025ba:	ec32                	sd	a2,24(sp)
    800025bc:	1a44a603          	lw	a2,420(s1)
    800025c0:	e832                	sd	a2,16(sp)
    800025c2:	1a04a603          	lw	a2,416(s1)
    800025c6:	e432                	sd	a2,8(sp)
    800025c8:	19c4a603          	lw	a2,412(s1)
    800025cc:	e032                	sd	a2,0(sp)
    800025ce:	1984a883          	lw	a7,408(s1)
    800025d2:	1b84a803          	lw	a6,440(s1)
    800025d6:	40f707bb          	subw	a5,a4,a5
    800025da:	1ac4a703          	lw	a4,428(s1)
    800025de:	18c4a603          	lw	a2,396(s1)
    800025e2:	588c                	lw	a1,48(s1)
    800025e4:	8556                	mv	a0,s5
    800025e6:	ffffe097          	auipc	ra,0xffffe
    800025ea:	f9e080e7          	jalr	-98(ra) # 80000584 <printf>
    printf("\n");
    800025ee:	8552                	mv	a0,s4
    800025f0:	ffffe097          	auipc	ra,0xffffe
    800025f4:	f94080e7          	jalr	-108(ra) # 80000584 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800025f8:	1c048493          	addi	s1,s1,448
    800025fc:	03248063          	beq	s1,s2,8000261c <procdump+0xe2>
    if(p->state == UNUSED)
    80002600:	4c9c                	lw	a5,24(s1)
    80002602:	dbfd                	beqz	a5,800025f8 <procdump+0xbe>
      state = "???";
    80002604:	86ce                	mv	a3,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002606:	fafbe4e3          	bltu	s7,a5,800025ae <procdump+0x74>
    8000260a:	02079713          	slli	a4,a5,0x20
    8000260e:	01d75793          	srli	a5,a4,0x1d
    80002612:	97e2                	add	a5,a5,s8
    80002614:	6394                	ld	a3,0(a5)
    80002616:	fec1                	bnez	a3,800025ae <procdump+0x74>
      state = "???";
    80002618:	86ce                	mv	a3,s3
    8000261a:	bf51                	j	800025ae <procdump+0x74>
  }
  #endif
}
    8000261c:	70a6                	ld	ra,104(sp)
    8000261e:	7406                	ld	s0,96(sp)
    80002620:	64e6                	ld	s1,88(sp)
    80002622:	6946                	ld	s2,80(sp)
    80002624:	69a6                	ld	s3,72(sp)
    80002626:	6a06                	ld	s4,64(sp)
    80002628:	7ae2                	ld	s5,56(sp)
    8000262a:	7b42                	ld	s6,48(sp)
    8000262c:	7ba2                	ld	s7,40(sp)
    8000262e:	7c02                	ld	s8,32(sp)
    80002630:	6165                	addi	sp,sp,112
    80002632:	8082                	ret

0000000080002634 <_setpriority>:

int _setpriority(int pid, int priority)
{ 
    80002634:	1141                	addi	sp,sp,-16
    80002636:	e422                	sd	s0,8(sp)
    80002638:	0800                	addi	s0,sp,16
  int temp = 0;
  struct proc *p;
  for(p = proc; p < &proc[NPROC]; p++){
    8000263a:	00010797          	auipc	a5,0x10
    8000263e:	4be78793          	addi	a5,a5,1214 # 80012af8 <proc>
    80002642:	00017697          	auipc	a3,0x17
    80002646:	4b668693          	addi	a3,a3,1206 # 80019af8 <tickslock>
    if(p->pid == pid){
    8000264a:	5b98                	lw	a4,48(a5)
    8000264c:	00a70863          	beq	a4,a0,8000265c <_setpriority+0x28>
  for(p = proc; p < &proc[NPROC]; p++){
    80002650:	1c078793          	addi	a5,a5,448
    80002654:	fed79be3          	bne	a5,a3,8000264a <_setpriority+0x16>
  int temp = 0;
    80002658:	4501                	li	a0,0
    8000265a:	a801                	j	8000266a <_setpriority+0x36>
      temp = p->staticPriority;
    8000265c:	1707a503          	lw	a0,368(a5)
      p->staticPriority = priority;
    80002660:	16b7a823          	sw	a1,368(a5)
      p->niceness = 5;
    80002664:	4715                	li	a4,5
    80002666:	16e7ac23          	sw	a4,376(a5)
      break;
    }
  }
  return temp;
}
    8000266a:	6422                	ld	s0,8(sp)
    8000266c:	0141                	addi	sp,sp,16
    8000266e:	8082                	ret

0000000080002670 <ProcQueueEnqueue>:

void ProcQueueEnqueue(ProcQueue *q, struct proc *p){
    80002670:	1141                	addi	sp,sp,-16
    80002672:	e422                	sd	s0,8(sp)
    80002674:	0800                	addi	s0,sp,16
  if(q->front == -1) q->front++;
    80002676:	4118                	lw	a4,0(a0)
    80002678:	57fd                	li	a5,-1
    8000267a:	02f70663          	beq	a4,a5,800026a6 <ProcQueueEnqueue+0x36>
  q->rear = (q->rear+1)%NPROC;
    8000267e:	415c                	lw	a5,4(a0)
    80002680:	2785                	addiw	a5,a5,1
    80002682:	41f7d71b          	sraiw	a4,a5,0x1f
    80002686:	01a7571b          	srliw	a4,a4,0x1a
    8000268a:	9fb9                	addw	a5,a5,a4
    8000268c:	03f7f793          	andi	a5,a5,63
    80002690:	9f99                	subw	a5,a5,a4
    80002692:	0007871b          	sext.w	a4,a5
    80002696:	c15c                	sw	a5,4(a0)

  q->list[q->rear] = p;
    80002698:	00371793          	slli	a5,a4,0x3
    8000269c:	953e                	add	a0,a0,a5
    8000269e:	e50c                	sd	a1,8(a0)
}
    800026a0:	6422                	ld	s0,8(sp)
    800026a2:	0141                	addi	sp,sp,16
    800026a4:	8082                	ret
  if(q->front == -1) q->front++;
    800026a6:	00052023          	sw	zero,0(a0)
    800026aa:	bfd1                	j	8000267e <ProcQueueEnqueue+0xe>

00000000800026ac <ProcQueueDequeue>:

struct proc* ProcQueueDequeue(ProcQueue *q){
    800026ac:	1141                	addi	sp,sp,-16
    800026ae:	e422                	sd	s0,8(sp)
    800026b0:	0800                	addi	s0,sp,16
  if(q->front == -1)
    800026b2:	411c                	lw	a5,0(a0)
    800026b4:	56fd                	li	a3,-1
    800026b6:	02d78d63          	beq	a5,a3,800026f0 <ProcQueueDequeue+0x44>
    800026ba:	872a                	mv	a4,a0
    return 0;

  struct proc* ret = q->list[q->front];
    800026bc:	00379693          	slli	a3,a5,0x3
    800026c0:	96aa                	add	a3,a3,a0
    800026c2:	6688                	ld	a0,8(a3)
  if(q->front == q->rear){
    800026c4:	4350                	lw	a2,4(a4)
    800026c6:	00f60f63          	beq	a2,a5,800026e4 <ProcQueueDequeue+0x38>
    q->list[q->front] = 0;
    q->front = q->rear = -1;
  }
  else 
    q->front = ((q->front+1) % NPROC);
    800026ca:	2785                	addiw	a5,a5,1
    800026cc:	41f7d69b          	sraiw	a3,a5,0x1f
    800026d0:	01a6d69b          	srliw	a3,a3,0x1a
    800026d4:	9fb5                	addw	a5,a5,a3
    800026d6:	03f7f793          	andi	a5,a5,63
    800026da:	9f95                	subw	a5,a5,a3
    800026dc:	c31c                	sw	a5,0(a4)

  return ret;
}
    800026de:	6422                	ld	s0,8(sp)
    800026e0:	0141                	addi	sp,sp,16
    800026e2:	8082                	ret
    q->list[q->front] = 0;
    800026e4:	0006b423          	sd	zero,8(a3)
    q->front = q->rear = -1;
    800026e8:	57fd                	li	a5,-1
    800026ea:	c35c                	sw	a5,4(a4)
    800026ec:	c31c                	sw	a5,0(a4)
    800026ee:	bfc5                	j	800026de <ProcQueueDequeue+0x32>
    return 0;
    800026f0:	4501                	li	a0,0
    800026f2:	b7f5                	j	800026de <ProcQueueDequeue+0x32>

00000000800026f4 <ProcQueueRemove>:

void ProcQueueRemove(ProcQueue *q, int pid){
    800026f4:	1141                	addi	sp,sp,-16
    800026f6:	e422                	sd	s0,8(sp)
    800026f8:	0800                	addi	s0,sp,16

  int i=q->front;
    800026fa:	00052803          	lw	a6,0(a0)

  while(i<q->rear){
    800026fe:	4154                	lw	a3,4(a0)
    80002700:	00381613          	slli	a2,a6,0x3
    80002704:	962a                	add	a2,a2,a0
    80002706:	00d85a63          	bge	a6,a3,8000271a <ProcQueueRemove+0x26>
    if(q->list[i]->pid == pid){
    8000270a:	661c                	ld	a5,8(a2)
    8000270c:	5b98                	lw	a4,48(a5)
    8000270e:	feb71ce3          	bne	a4,a1,80002706 <ProcQueueRemove+0x12>
      struct proc *p = q->list[i]; 
      q->list[i] = q->list[i+1];
    80002712:	6a18                	ld	a4,16(a2)
    80002714:	e618                	sd	a4,8(a2)
      q->list[i+1] = p;
    80002716:	ea1c                	sd	a5,16(a2)
    80002718:	b7fd                	j	80002706 <ProcQueueRemove+0x12>
    }
  }
  
  q->list[q->rear] = 0;
    8000271a:	00369793          	slli	a5,a3,0x3
    8000271e:	97aa                	add	a5,a5,a0
    80002720:	0007b423          	sd	zero,8(a5)
  q->rear--;
    80002724:	36fd                	addiw	a3,a3,-1
    80002726:	c154                	sw	a3,4(a0)
}
    80002728:	6422                	ld	s0,8(sp)
    8000272a:	0141                	addi	sp,sp,16
    8000272c:	8082                	ret

000000008000272e <ageing>:

void ageing(void){
    8000272e:	711d                	addi	sp,sp,-96
    80002730:	ec86                	sd	ra,88(sp)
    80002732:	e8a2                	sd	s0,80(sp)
    80002734:	e4a6                	sd	s1,72(sp)
    80002736:	e0ca                	sd	s2,64(sp)
    80002738:	fc4e                	sd	s3,56(sp)
    8000273a:	f852                	sd	s4,48(sp)
    8000273c:	f456                	sd	s5,40(sp)
    8000273e:	f05a                	sd	s6,32(sp)
    80002740:	ec5e                	sd	s7,24(sp)
    80002742:	e862                	sd	s8,16(sp)
    80002744:	e466                	sd	s9,8(sp)
    80002746:	1080                	addi	s0,sp,96
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80002748:	00010497          	auipc	s1,0x10
    8000274c:	3b048493          	addi	s1,s1,944 # 80012af8 <proc>
    acquire(&p->lock);
    if(p->state == RUNNABLE && (ticks - p->qEnter > 24)){
    80002750:	498d                	li	s3,3
    80002752:	00007a97          	auipc	s5,0x7
    80002756:	8dea8a93          	addi	s5,s5,-1826 # 80009030 <ticks>
    8000275a:	4a61                	li	s4,24
      if(p->inQ == 1){
    8000275c:	4b05                	li	s6,1
        ProcQueueRemove(&mfq[p->level], p->pid);        
        p->inQ = 0;
      }
      if(p->level > 0){
        p->level--;
        p->timeinQ = 1 << p->level;
    8000275e:	4b85                	li	s7,1
        ProcQueueRemove(&mfq[p->level], p->pid);        
    80002760:	0000fc17          	auipc	s8,0xf
    80002764:	f70c0c13          	addi	s8,s8,-144 # 800116d0 <mfq>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002768:	00017917          	auipc	s2,0x17
    8000276c:	39090913          	addi	s2,s2,912 # 80019af8 <tickslock>
    80002770:	a81d                	j	800027a6 <ageing+0x78>
        ProcQueueRemove(&mfq[p->level], p->pid);        
    80002772:	18c4e783          	lwu	a5,396(s1)
    80002776:	00779513          	slli	a0,a5,0x7
    8000277a:	953e                	add	a0,a0,a5
    8000277c:	050e                	slli	a0,a0,0x3
    8000277e:	588c                	lw	a1,48(s1)
    80002780:	9562                	add	a0,a0,s8
    80002782:	00000097          	auipc	ra,0x0
    80002786:	f72080e7          	jalr	-142(ra) # 800026f4 <ProcQueueRemove>
        p->inQ = 0;
    8000278a:	1804a423          	sw	zero,392(s1)
    8000278e:	a081                	j	800027ce <ageing+0xa0>
        //ProcQueueEnqueue(&mfq[p->level], p);
        //p->inQ = 1;
      }
      p->qEnter = ticks;
    80002790:	1994aa23          	sw	s9,404(s1)
    }
    release(&p->lock);
    80002794:	8526                	mv	a0,s1
    80002796:	ffffe097          	auipc	ra,0xffffe
    8000279a:	4ee080e7          	jalr	1262(ra) # 80000c84 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000279e:	1c048493          	addi	s1,s1,448
    800027a2:	05248163          	beq	s1,s2,800027e4 <ageing+0xb6>
    acquire(&p->lock);
    800027a6:	8526                	mv	a0,s1
    800027a8:	ffffe097          	auipc	ra,0xffffe
    800027ac:	428080e7          	jalr	1064(ra) # 80000bd0 <acquire>
    if(p->state == RUNNABLE && (ticks - p->qEnter > 24)){
    800027b0:	4c9c                	lw	a5,24(s1)
    800027b2:	ff3791e3          	bne	a5,s3,80002794 <ageing+0x66>
    800027b6:	000aac83          	lw	s9,0(s5)
    800027ba:	1944a783          	lw	a5,404(s1)
    800027be:	40fc87bb          	subw	a5,s9,a5
    800027c2:	fcfa79e3          	bgeu	s4,a5,80002794 <ageing+0x66>
      if(p->inQ == 1){
    800027c6:	1884a783          	lw	a5,392(s1)
    800027ca:	fb6784e3          	beq	a5,s6,80002772 <ageing+0x44>
      if(p->level > 0){
    800027ce:	18c4a783          	lw	a5,396(s1)
    800027d2:	dfdd                	beqz	a5,80002790 <ageing+0x62>
        p->level--;
    800027d4:	37fd                	addiw	a5,a5,-1
    800027d6:	18f4a623          	sw	a5,396(s1)
        p->timeinQ = 1 << p->level;
    800027da:	00fb97bb          	sllw	a5,s7,a5
    800027de:	18f4a823          	sw	a5,400(s1)
    800027e2:	b77d                	j	80002790 <ageing+0x62>
  }
}
    800027e4:	60e6                	ld	ra,88(sp)
    800027e6:	6446                	ld	s0,80(sp)
    800027e8:	64a6                	ld	s1,72(sp)
    800027ea:	6906                	ld	s2,64(sp)
    800027ec:	79e2                	ld	s3,56(sp)
    800027ee:	7a42                	ld	s4,48(sp)
    800027f0:	7aa2                	ld	s5,40(sp)
    800027f2:	7b02                	ld	s6,32(sp)
    800027f4:	6be2                	ld	s7,24(sp)
    800027f6:	6c42                	ld	s8,16(sp)
    800027f8:	6ca2                	ld	s9,8(sp)
    800027fa:	6125                	addi	sp,sp,96
    800027fc:	8082                	ret

00000000800027fe <scheduler>:
{
    800027fe:	7159                	addi	sp,sp,-112
    80002800:	f486                	sd	ra,104(sp)
    80002802:	f0a2                	sd	s0,96(sp)
    80002804:	eca6                	sd	s1,88(sp)
    80002806:	e8ca                	sd	s2,80(sp)
    80002808:	e4ce                	sd	s3,72(sp)
    8000280a:	e0d2                	sd	s4,64(sp)
    8000280c:	fc56                	sd	s5,56(sp)
    8000280e:	f85a                	sd	s6,48(sp)
    80002810:	f45e                	sd	s7,40(sp)
    80002812:	f062                	sd	s8,32(sp)
    80002814:	ec66                	sd	s9,24(sp)
    80002816:	e86a                	sd	s10,16(sp)
    80002818:	e46e                	sd	s11,8(sp)
    8000281a:	1880                	addi	s0,sp,112
  printf("MLFQ Scheduler");
    8000281c:	00006517          	auipc	a0,0x6
    80002820:	abc50513          	addi	a0,a0,-1348 # 800082d8 <digits+0x298>
    80002824:	ffffe097          	auipc	ra,0xffffe
    80002828:	d60080e7          	jalr	-672(ra) # 80000584 <printf>
    8000282c:	8792                	mv	a5,tp
  int id = r_tp();
    8000282e:	2781                	sext.w	a5,a5
  c->proc = 0;
    80002830:	00779c13          	slli	s8,a5,0x7
    80002834:	0000f717          	auipc	a4,0xf
    80002838:	a6c70713          	addi	a4,a4,-1428 # 800112a0 <pid_lock>
    8000283c:	9762                	add	a4,a4,s8
    8000283e:	02073823          	sd	zero,48(a4)
      swtch(&c->context, &low->context);
    80002842:	0000f717          	auipc	a4,0xf
    80002846:	a9670713          	addi	a4,a4,-1386 # 800112d8 <cpus+0x8>
    8000284a:	9c3a                	add	s8,s8,a4
        p->inQ = 1;
    8000284c:	4a85                	li	s5,1
        ProcQueueEnqueue(&(mfq[p->level]), p);
    8000284e:	0000fa17          	auipc	s4,0xf
    80002852:	e82a0a13          	addi	s4,s4,-382 # 800116d0 <mfq>
    for(p = proc; p < &proc[NPROC]; p++) {
    80002856:	00017997          	auipc	s3,0x17
    8000285a:	2a298993          	addi	s3,s3,674 # 80019af8 <tickslock>
      c->proc = low;
    8000285e:	079e                	slli	a5,a5,0x7
    80002860:	0000fb17          	auipc	s6,0xf
    80002864:	a40b0b13          	addi	s6,s6,-1472 # 800112a0 <pid_lock>
    80002868:	9b3e                	add	s6,s6,a5
    8000286a:	a0d5                	j	8000294e <scheduler+0x150>
      release(&p->lock);
    8000286c:	8526                	mv	a0,s1
    8000286e:	ffffe097          	auipc	ra,0xffffe
    80002872:	416080e7          	jalr	1046(ra) # 80000c84 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80002876:	1c048493          	addi	s1,s1,448
    8000287a:	03348c63          	beq	s1,s3,800028b2 <scheduler+0xb4>
      acquire(&p->lock);
    8000287e:	8526                	mv	a0,s1
    80002880:	ffffe097          	auipc	ra,0xffffe
    80002884:	350080e7          	jalr	848(ra) # 80000bd0 <acquire>
      if((p->state == RUNNABLE) && (!p->inQ)){
    80002888:	4c9c                	lw	a5,24(s1)
    8000288a:	ff2791e3          	bne	a5,s2,8000286c <scheduler+0x6e>
    8000288e:	1884a783          	lw	a5,392(s1)
    80002892:	ffe9                	bnez	a5,8000286c <scheduler+0x6e>
        p->inQ = 1;
    80002894:	1954a423          	sw	s5,392(s1)
        ProcQueueEnqueue(&(mfq[p->level]), p);
    80002898:	18c4e783          	lwu	a5,396(s1)
    8000289c:	00779513          	slli	a0,a5,0x7
    800028a0:	953e                	add	a0,a0,a5
    800028a2:	050e                	slli	a0,a0,0x3
    800028a4:	85a6                	mv	a1,s1
    800028a6:	9552                	add	a0,a0,s4
    800028a8:	00000097          	auipc	ra,0x0
    800028ac:	dc8080e7          	jalr	-568(ra) # 80002670 <ProcQueueEnqueue>
    800028b0:	bf75                	j	8000286c <scheduler+0x6e>
    800028b2:	0000fd97          	auipc	s11,0xf
    800028b6:	e1ed8d93          	addi	s11,s11,-482 # 800116d0 <mfq>
      struct proc *temp = ProcQueueDequeue(&(mfq[i]));
    800028ba:	8cee                	mv	s9,s11
    800028bc:	856e                	mv	a0,s11
    800028be:	00000097          	auipc	ra,0x0
    800028c2:	dee080e7          	jalr	-530(ra) # 800026ac <ProcQueueDequeue>
    800028c6:	84aa                	mv	s1,a0
      while(temp!=0){
    800028c8:	c51d                	beqz	a0,800028f6 <scheduler+0xf8>
        acquire(&temp->lock);
    800028ca:	8526                	mv	a0,s1
    800028cc:	ffffe097          	auipc	ra,0xffffe
    800028d0:	304080e7          	jalr	772(ra) # 80000bd0 <acquire>
        temp->inQ = 0;
    800028d4:	1804a423          	sw	zero,392(s1)
        if(temp->state == RUNNABLE){
    800028d8:	4c9c                	lw	a5,24(s1)
    800028da:	03278363          	beq	a5,s2,80002900 <scheduler+0x102>
        release(&temp->lock);
    800028de:	8526                	mv	a0,s1
    800028e0:	ffffe097          	auipc	ra,0xffffe
    800028e4:	3a4080e7          	jalr	932(ra) # 80000c84 <release>
        temp = ProcQueueDequeue(&(mfq[i]));
    800028e8:	8566                	mv	a0,s9
    800028ea:	00000097          	auipc	ra,0x0
    800028ee:	dc2080e7          	jalr	-574(ra) # 800026ac <ProcQueueDequeue>
    800028f2:	84aa                	mv	s1,a0
      while(temp!=0){
    800028f4:	f979                	bnez	a0,800028ca <scheduler+0xcc>
    for(int i=0;i<5;i++){
    800028f6:	408d8d93          	addi	s11,s11,1032
    800028fa:	fd7d90e3          	bne	s11,s7,800028ba <scheduler+0xbc>
    800028fe:	a8a9                	j	80002958 <scheduler+0x15a>
          temp->qEnter = ticks;
    80002900:	00006917          	auipc	s2,0x6
    80002904:	73090913          	addi	s2,s2,1840 # 80009030 <ticks>
    80002908:	00092703          	lw	a4,0(s2)
    8000290c:	18e4aa23          	sw	a4,404(s1)
      low->nrun++;
    80002910:	1b84a783          	lw	a5,440(s1)
    80002914:	2785                	addiw	a5,a5,1
    80002916:	1af4ac23          	sw	a5,440(s1)
      low->state = RUNNING;
    8000291a:	4791                	li	a5,4
    8000291c:	cc9c                	sw	a5,24(s1)
      low->runtime=0;
    8000291e:	1804a023          	sw	zero,384(s1)
      low->sched1=ticks;
    80002922:	16e4ae23          	sw	a4,380(s1)
      c->proc = low;
    80002926:	029b3823          	sd	s1,48(s6)
      swtch(&c->context, &low->context);
    8000292a:	06048593          	addi	a1,s1,96
    8000292e:	8562                	mv	a0,s8
    80002930:	00000097          	auipc	ra,0x0
    80002934:	192080e7          	jalr	402(ra) # 80002ac2 <swtch>
      c->proc = 0;
    80002938:	020b3823          	sd	zero,48(s6)
      low->qEnter = ticks;
    8000293c:	00092783          	lw	a5,0(s2)
    80002940:	18f4aa23          	sw	a5,404(s1)
      release(&low->lock);
    80002944:	8526                	mv	a0,s1
    80002946:	ffffe097          	auipc	ra,0xffffe
    8000294a:	33e080e7          	jalr	830(ra) # 80000c84 <release>
      if((p->state == RUNNABLE) && (!p->inQ)){
    8000294e:	490d                	li	s2,3
    80002950:	00010b97          	auipc	s7,0x10
    80002954:	1a8b8b93          	addi	s7,s7,424 # 80012af8 <proc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002958:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000295c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002960:	10079073          	csrw	sstatus,a5
    ageing();
    80002964:	00000097          	auipc	ra,0x0
    80002968:	dca080e7          	jalr	-566(ra) # 8000272e <ageing>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000296c:	00010497          	auipc	s1,0x10
    80002970:	18c48493          	addi	s1,s1,396 # 80012af8 <proc>
    80002974:	b729                	j	8000287e <scheduler+0x80>

0000000080002976 <waitx>:


int
waitx(uint64 addr, uint* rtime, uint* wtime)
{
    80002976:	711d                	addi	sp,sp,-96
    80002978:	ec86                	sd	ra,88(sp)
    8000297a:	e8a2                	sd	s0,80(sp)
    8000297c:	e4a6                	sd	s1,72(sp)
    8000297e:	e0ca                	sd	s2,64(sp)
    80002980:	fc4e                	sd	s3,56(sp)
    80002982:	f852                	sd	s4,48(sp)
    80002984:	f456                	sd	s5,40(sp)
    80002986:	f05a                	sd	s6,32(sp)
    80002988:	ec5e                	sd	s7,24(sp)
    8000298a:	e862                	sd	s8,16(sp)
    8000298c:	e466                	sd	s9,8(sp)
    8000298e:	e06a                	sd	s10,0(sp)
    80002990:	1080                	addi	s0,sp,96
    80002992:	8b2a                	mv	s6,a0
    80002994:	8c2e                	mv	s8,a1
    80002996:	8bb2                	mv	s7,a2
  struct proc *np;
  int havekids, pid;
  struct proc *p = myproc();
    80002998:	fffff097          	auipc	ra,0xfffff
    8000299c:	040080e7          	jalr	64(ra) # 800019d8 <myproc>
    800029a0:	892a                	mv	s2,a0

  acquire(&wait_lock);
    800029a2:	0000f517          	auipc	a0,0xf
    800029a6:	91650513          	addi	a0,a0,-1770 # 800112b8 <wait_lock>
    800029aa:	ffffe097          	auipc	ra,0xffffe
    800029ae:	226080e7          	jalr	550(ra) # 80000bd0 <acquire>

  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    800029b2:	4c81                	li	s9,0
      if(np->parent == p){
        // make sure the child isn't still in exit() or swtch().
        acquire(&np->lock);

        havekids = 1;
        if(np->state == ZOMBIE){
    800029b4:	4a15                	li	s4,5
        havekids = 1;
    800029b6:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800029b8:	00017997          	auipc	s3,0x17
    800029bc:	14098993          	addi	s3,s3,320 # 80019af8 <tickslock>
      release(&wait_lock);
      return -1;
    }

    // Wait for a child to exit.
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800029c0:	0000fd17          	auipc	s10,0xf
    800029c4:	8f8d0d13          	addi	s10,s10,-1800 # 800112b8 <wait_lock>
    havekids = 0;
    800029c8:	8766                	mv	a4,s9
    for(np = proc; np < &proc[NPROC]; np++){
    800029ca:	00010497          	auipc	s1,0x10
    800029ce:	12e48493          	addi	s1,s1,302 # 80012af8 <proc>
    800029d2:	a059                	j	80002a58 <waitx+0xe2>
          pid = np->pid;
    800029d4:	0304a983          	lw	s3,48(s1)
          *rtime = np->rtime;
    800029d8:	1ac4a783          	lw	a5,428(s1)
    800029dc:	00fc2023          	sw	a5,0(s8)
          *wtime = np->etime - np->birthtime - np->rtime;
    800029e0:	16c4a703          	lw	a4,364(s1)
    800029e4:	9f3d                	addw	a4,a4,a5
    800029e6:	1b44a783          	lw	a5,436(s1)
    800029ea:	9f99                	subw	a5,a5,a4
    800029ec:	00fba023          	sw	a5,0(s7)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800029f0:	000b0e63          	beqz	s6,80002a0c <waitx+0x96>
    800029f4:	4691                	li	a3,4
    800029f6:	02c48613          	addi	a2,s1,44
    800029fa:	85da                	mv	a1,s6
    800029fc:	05093503          	ld	a0,80(s2)
    80002a00:	fffff097          	auipc	ra,0xfffff
    80002a04:	c62080e7          	jalr	-926(ra) # 80001662 <copyout>
    80002a08:	02054563          	bltz	a0,80002a32 <waitx+0xbc>
          freeproc(np);
    80002a0c:	8526                	mv	a0,s1
    80002a0e:	fffff097          	auipc	ra,0xfffff
    80002a12:	17c080e7          	jalr	380(ra) # 80001b8a <freeproc>
          release(&np->lock);
    80002a16:	8526                	mv	a0,s1
    80002a18:	ffffe097          	auipc	ra,0xffffe
    80002a1c:	26c080e7          	jalr	620(ra) # 80000c84 <release>
          release(&wait_lock);
    80002a20:	0000f517          	auipc	a0,0xf
    80002a24:	89850513          	addi	a0,a0,-1896 # 800112b8 <wait_lock>
    80002a28:	ffffe097          	auipc	ra,0xffffe
    80002a2c:	25c080e7          	jalr	604(ra) # 80000c84 <release>
          return pid;
    80002a30:	a09d                	j	80002a96 <waitx+0x120>
            release(&np->lock);
    80002a32:	8526                	mv	a0,s1
    80002a34:	ffffe097          	auipc	ra,0xffffe
    80002a38:	250080e7          	jalr	592(ra) # 80000c84 <release>
            release(&wait_lock);
    80002a3c:	0000f517          	auipc	a0,0xf
    80002a40:	87c50513          	addi	a0,a0,-1924 # 800112b8 <wait_lock>
    80002a44:	ffffe097          	auipc	ra,0xffffe
    80002a48:	240080e7          	jalr	576(ra) # 80000c84 <release>
            return -1;
    80002a4c:	59fd                	li	s3,-1
    80002a4e:	a0a1                	j	80002a96 <waitx+0x120>
    for(np = proc; np < &proc[NPROC]; np++){
    80002a50:	1c048493          	addi	s1,s1,448
    80002a54:	03348463          	beq	s1,s3,80002a7c <waitx+0x106>
      if(np->parent == p){
    80002a58:	7c9c                	ld	a5,56(s1)
    80002a5a:	ff279be3          	bne	a5,s2,80002a50 <waitx+0xda>
        acquire(&np->lock);
    80002a5e:	8526                	mv	a0,s1
    80002a60:	ffffe097          	auipc	ra,0xffffe
    80002a64:	170080e7          	jalr	368(ra) # 80000bd0 <acquire>
        if(np->state == ZOMBIE){
    80002a68:	4c9c                	lw	a5,24(s1)
    80002a6a:	f74785e3          	beq	a5,s4,800029d4 <waitx+0x5e>
        release(&np->lock);
    80002a6e:	8526                	mv	a0,s1
    80002a70:	ffffe097          	auipc	ra,0xffffe
    80002a74:	214080e7          	jalr	532(ra) # 80000c84 <release>
        havekids = 1;
    80002a78:	8756                	mv	a4,s5
    80002a7a:	bfd9                	j	80002a50 <waitx+0xda>
    if(!havekids || p->killed){
    80002a7c:	c701                	beqz	a4,80002a84 <waitx+0x10e>
    80002a7e:	02892783          	lw	a5,40(s2)
    80002a82:	cb8d                	beqz	a5,80002ab4 <waitx+0x13e>
      release(&wait_lock);
    80002a84:	0000f517          	auipc	a0,0xf
    80002a88:	83450513          	addi	a0,a0,-1996 # 800112b8 <wait_lock>
    80002a8c:	ffffe097          	auipc	ra,0xffffe
    80002a90:	1f8080e7          	jalr	504(ra) # 80000c84 <release>
      return -1;
    80002a94:	59fd                	li	s3,-1
  }
    80002a96:	854e                	mv	a0,s3
    80002a98:	60e6                	ld	ra,88(sp)
    80002a9a:	6446                	ld	s0,80(sp)
    80002a9c:	64a6                	ld	s1,72(sp)
    80002a9e:	6906                	ld	s2,64(sp)
    80002aa0:	79e2                	ld	s3,56(sp)
    80002aa2:	7a42                	ld	s4,48(sp)
    80002aa4:	7aa2                	ld	s5,40(sp)
    80002aa6:	7b02                	ld	s6,32(sp)
    80002aa8:	6be2                	ld	s7,24(sp)
    80002aaa:	6c42                	ld	s8,16(sp)
    80002aac:	6ca2                	ld	s9,8(sp)
    80002aae:	6d02                	ld	s10,0(sp)
    80002ab0:	6125                	addi	sp,sp,96
    80002ab2:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002ab4:	85ea                	mv	a1,s10
    80002ab6:	854a                	mv	a0,s2
    80002ab8:	fffff097          	auipc	ra,0xfffff
    80002abc:	606080e7          	jalr	1542(ra) # 800020be <sleep>
    havekids = 0;
    80002ac0:	b721                	j	800029c8 <waitx+0x52>

0000000080002ac2 <swtch>:
    80002ac2:	00153023          	sd	ra,0(a0)
    80002ac6:	00253423          	sd	sp,8(a0)
    80002aca:	e900                	sd	s0,16(a0)
    80002acc:	ed04                	sd	s1,24(a0)
    80002ace:	03253023          	sd	s2,32(a0)
    80002ad2:	03353423          	sd	s3,40(a0)
    80002ad6:	03453823          	sd	s4,48(a0)
    80002ada:	03553c23          	sd	s5,56(a0)
    80002ade:	05653023          	sd	s6,64(a0)
    80002ae2:	05753423          	sd	s7,72(a0)
    80002ae6:	05853823          	sd	s8,80(a0)
    80002aea:	05953c23          	sd	s9,88(a0)
    80002aee:	07a53023          	sd	s10,96(a0)
    80002af2:	07b53423          	sd	s11,104(a0)
    80002af6:	0005b083          	ld	ra,0(a1)
    80002afa:	0085b103          	ld	sp,8(a1)
    80002afe:	6980                	ld	s0,16(a1)
    80002b00:	6d84                	ld	s1,24(a1)
    80002b02:	0205b903          	ld	s2,32(a1)
    80002b06:	0285b983          	ld	s3,40(a1)
    80002b0a:	0305ba03          	ld	s4,48(a1)
    80002b0e:	0385ba83          	ld	s5,56(a1)
    80002b12:	0405bb03          	ld	s6,64(a1)
    80002b16:	0485bb83          	ld	s7,72(a1)
    80002b1a:	0505bc03          	ld	s8,80(a1)
    80002b1e:	0585bc83          	ld	s9,88(a1)
    80002b22:	0605bd03          	ld	s10,96(a1)
    80002b26:	0685bd83          	ld	s11,104(a1)
    80002b2a:	8082                	ret

0000000080002b2c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002b2c:	1141                	addi	sp,sp,-16
    80002b2e:	e406                	sd	ra,8(sp)
    80002b30:	e022                	sd	s0,0(sp)
    80002b32:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002b34:	00006597          	auipc	a1,0x6
    80002b38:	80c58593          	addi	a1,a1,-2036 # 80008340 <states.0+0x30>
    80002b3c:	00017517          	auipc	a0,0x17
    80002b40:	fbc50513          	addi	a0,a0,-68 # 80019af8 <tickslock>
    80002b44:	ffffe097          	auipc	ra,0xffffe
    80002b48:	ffc080e7          	jalr	-4(ra) # 80000b40 <initlock>
}
    80002b4c:	60a2                	ld	ra,8(sp)
    80002b4e:	6402                	ld	s0,0(sp)
    80002b50:	0141                	addi	sp,sp,16
    80002b52:	8082                	ret

0000000080002b54 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002b54:	1141                	addi	sp,sp,-16
    80002b56:	e422                	sd	s0,8(sp)
    80002b58:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002b5a:	00003797          	auipc	a5,0x3
    80002b5e:	73678793          	addi	a5,a5,1846 # 80006290 <kernelvec>
    80002b62:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002b66:	6422                	ld	s0,8(sp)
    80002b68:	0141                	addi	sp,sp,16
    80002b6a:	8082                	ret

0000000080002b6c <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002b6c:	1141                	addi	sp,sp,-16
    80002b6e:	e406                	sd	ra,8(sp)
    80002b70:	e022                	sd	s0,0(sp)
    80002b72:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002b74:	fffff097          	auipc	ra,0xfffff
    80002b78:	e64080e7          	jalr	-412(ra) # 800019d8 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b7c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002b80:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002b82:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002b86:	00004697          	auipc	a3,0x4
    80002b8a:	47a68693          	addi	a3,a3,1146 # 80007000 <_trampoline>
    80002b8e:	00004717          	auipc	a4,0x4
    80002b92:	47270713          	addi	a4,a4,1138 # 80007000 <_trampoline>
    80002b96:	8f15                	sub	a4,a4,a3
    80002b98:	040007b7          	lui	a5,0x4000
    80002b9c:	17fd                	addi	a5,a5,-1
    80002b9e:	07b2                	slli	a5,a5,0xc
    80002ba0:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002ba2:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002ba6:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002ba8:	18002673          	csrr	a2,satp
    80002bac:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002bae:	6d30                	ld	a2,88(a0)
    80002bb0:	6138                	ld	a4,64(a0)
    80002bb2:	6585                	lui	a1,0x1
    80002bb4:	972e                	add	a4,a4,a1
    80002bb6:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002bb8:	6d38                	ld	a4,88(a0)
    80002bba:	00000617          	auipc	a2,0x0
    80002bbe:	14660613          	addi	a2,a2,326 # 80002d00 <usertrap>
    80002bc2:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002bc4:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002bc6:	8612                	mv	a2,tp
    80002bc8:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002bca:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002bce:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002bd2:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002bd6:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002bda:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002bdc:	6f18                	ld	a4,24(a4)
    80002bde:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002be2:	692c                	ld	a1,80(a0)
    80002be4:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80002be6:	00004717          	auipc	a4,0x4
    80002bea:	4aa70713          	addi	a4,a4,1194 # 80007090 <userret>
    80002bee:	8f15                	sub	a4,a4,a3
    80002bf0:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80002bf2:	577d                	li	a4,-1
    80002bf4:	177e                	slli	a4,a4,0x3f
    80002bf6:	8dd9                	or	a1,a1,a4
    80002bf8:	02000537          	lui	a0,0x2000
    80002bfc:	157d                	addi	a0,a0,-1
    80002bfe:	0536                	slli	a0,a0,0xd
    80002c00:	9782                	jalr	a5
}
    80002c02:	60a2                	ld	ra,8(sp)
    80002c04:	6402                	ld	s0,0(sp)
    80002c06:	0141                	addi	sp,sp,16
    80002c08:	8082                	ret

0000000080002c0a <clockintr>:



void
clockintr()
{
    80002c0a:	1101                	addi	sp,sp,-32
    80002c0c:	ec06                	sd	ra,24(sp)
    80002c0e:	e822                	sd	s0,16(sp)
    80002c10:	e426                	sd	s1,8(sp)
    80002c12:	e04a                	sd	s2,0(sp)
    80002c14:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002c16:	00017917          	auipc	s2,0x17
    80002c1a:	ee290913          	addi	s2,s2,-286 # 80019af8 <tickslock>
    80002c1e:	854a                	mv	a0,s2
    80002c20:	ffffe097          	auipc	ra,0xffffe
    80002c24:	fb0080e7          	jalr	-80(ra) # 80000bd0 <acquire>
  ticks++;
    80002c28:	00006497          	auipc	s1,0x6
    80002c2c:	40848493          	addi	s1,s1,1032 # 80009030 <ticks>
    80002c30:	409c                	lw	a5,0(s1)
    80002c32:	2785                	addiw	a5,a5,1
    80002c34:	c09c                	sw	a5,0(s1)

  RunningTime();
    80002c36:	fffff097          	auipc	ra,0xfffff
    80002c3a:	306080e7          	jalr	774(ra) # 80001f3c <RunningTime>
  //   RunningTime();
  // #elif MLFQ
  //   RunningTime();
  // #endif
  
  wakeup(&ticks);
    80002c3e:	8526                	mv	a0,s1
    80002c40:	fffff097          	auipc	ra,0xfffff
    80002c44:	60a080e7          	jalr	1546(ra) # 8000224a <wakeup>
  release(&tickslock);
    80002c48:	854a                	mv	a0,s2
    80002c4a:	ffffe097          	auipc	ra,0xffffe
    80002c4e:	03a080e7          	jalr	58(ra) # 80000c84 <release>
}
    80002c52:	60e2                	ld	ra,24(sp)
    80002c54:	6442                	ld	s0,16(sp)
    80002c56:	64a2                	ld	s1,8(sp)
    80002c58:	6902                	ld	s2,0(sp)
    80002c5a:	6105                	addi	sp,sp,32
    80002c5c:	8082                	ret

0000000080002c5e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002c5e:	1101                	addi	sp,sp,-32
    80002c60:	ec06                	sd	ra,24(sp)
    80002c62:	e822                	sd	s0,16(sp)
    80002c64:	e426                	sd	s1,8(sp)
    80002c66:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002c68:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80002c6c:	00074d63          	bltz	a4,80002c86 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80002c70:	57fd                	li	a5,-1
    80002c72:	17fe                	slli	a5,a5,0x3f
    80002c74:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002c76:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002c78:	06f70363          	beq	a4,a5,80002cde <devintr+0x80>
  }
}
    80002c7c:	60e2                	ld	ra,24(sp)
    80002c7e:	6442                	ld	s0,16(sp)
    80002c80:	64a2                	ld	s1,8(sp)
    80002c82:	6105                	addi	sp,sp,32
    80002c84:	8082                	ret
     (scause & 0xff) == 9){
    80002c86:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80002c8a:	46a5                	li	a3,9
    80002c8c:	fed792e3          	bne	a5,a3,80002c70 <devintr+0x12>
    int irq = plic_claim();
    80002c90:	00003097          	auipc	ra,0x3
    80002c94:	708080e7          	jalr	1800(ra) # 80006398 <plic_claim>
    80002c98:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002c9a:	47a9                	li	a5,10
    80002c9c:	02f50763          	beq	a0,a5,80002cca <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80002ca0:	4785                	li	a5,1
    80002ca2:	02f50963          	beq	a0,a5,80002cd4 <devintr+0x76>
    return 1;
    80002ca6:	4505                	li	a0,1
    } else if(irq){
    80002ca8:	d8f1                	beqz	s1,80002c7c <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002caa:	85a6                	mv	a1,s1
    80002cac:	00005517          	auipc	a0,0x5
    80002cb0:	69c50513          	addi	a0,a0,1692 # 80008348 <states.0+0x38>
    80002cb4:	ffffe097          	auipc	ra,0xffffe
    80002cb8:	8d0080e7          	jalr	-1840(ra) # 80000584 <printf>
      plic_complete(irq);
    80002cbc:	8526                	mv	a0,s1
    80002cbe:	00003097          	auipc	ra,0x3
    80002cc2:	6fe080e7          	jalr	1790(ra) # 800063bc <plic_complete>
    return 1;
    80002cc6:	4505                	li	a0,1
    80002cc8:	bf55                	j	80002c7c <devintr+0x1e>
      uartintr();
    80002cca:	ffffe097          	auipc	ra,0xffffe
    80002cce:	cc8080e7          	jalr	-824(ra) # 80000992 <uartintr>
    80002cd2:	b7ed                	j	80002cbc <devintr+0x5e>
      virtio_disk_intr();
    80002cd4:	00004097          	auipc	ra,0x4
    80002cd8:	b74080e7          	jalr	-1164(ra) # 80006848 <virtio_disk_intr>
    80002cdc:	b7c5                	j	80002cbc <devintr+0x5e>
    if(cpuid() == 0){
    80002cde:	fffff097          	auipc	ra,0xfffff
    80002ce2:	cce080e7          	jalr	-818(ra) # 800019ac <cpuid>
    80002ce6:	c901                	beqz	a0,80002cf6 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002ce8:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002cec:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002cee:	14479073          	csrw	sip,a5
    return 2;
    80002cf2:	4509                	li	a0,2
    80002cf4:	b761                	j	80002c7c <devintr+0x1e>
      clockintr();
    80002cf6:	00000097          	auipc	ra,0x0
    80002cfa:	f14080e7          	jalr	-236(ra) # 80002c0a <clockintr>
    80002cfe:	b7ed                	j	80002ce8 <devintr+0x8a>

0000000080002d00 <usertrap>:
{
    80002d00:	1101                	addi	sp,sp,-32
    80002d02:	ec06                	sd	ra,24(sp)
    80002d04:	e822                	sd	s0,16(sp)
    80002d06:	e426                	sd	s1,8(sp)
    80002d08:	e04a                	sd	s2,0(sp)
    80002d0a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d0c:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002d10:	1007f793          	andi	a5,a5,256
    80002d14:	e3ad                	bnez	a5,80002d76 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002d16:	00003797          	auipc	a5,0x3
    80002d1a:	57a78793          	addi	a5,a5,1402 # 80006290 <kernelvec>
    80002d1e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002d22:	fffff097          	auipc	ra,0xfffff
    80002d26:	cb6080e7          	jalr	-842(ra) # 800019d8 <myproc>
    80002d2a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002d2c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002d2e:	14102773          	csrr	a4,sepc
    80002d32:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002d34:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002d38:	47a1                	li	a5,8
    80002d3a:	04f71c63          	bne	a4,a5,80002d92 <usertrap+0x92>
    if(p->killed)
    80002d3e:	551c                	lw	a5,40(a0)
    80002d40:	e3b9                	bnez	a5,80002d86 <usertrap+0x86>
    p->trapframe->epc += 4;
    80002d42:	6cb8                	ld	a4,88(s1)
    80002d44:	6f1c                	ld	a5,24(a4)
    80002d46:	0791                	addi	a5,a5,4
    80002d48:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d4a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002d4e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002d52:	10079073          	csrw	sstatus,a5
    syscall();
    80002d56:	00000097          	auipc	ra,0x0
    80002d5a:	34c080e7          	jalr	844(ra) # 800030a2 <syscall>
  if(p->killed)
    80002d5e:	549c                	lw	a5,40(s1)
    80002d60:	efc5                	bnez	a5,80002e18 <usertrap+0x118>
  usertrapret();
    80002d62:	00000097          	auipc	ra,0x0
    80002d66:	e0a080e7          	jalr	-502(ra) # 80002b6c <usertrapret>
}
    80002d6a:	60e2                	ld	ra,24(sp)
    80002d6c:	6442                	ld	s0,16(sp)
    80002d6e:	64a2                	ld	s1,8(sp)
    80002d70:	6902                	ld	s2,0(sp)
    80002d72:	6105                	addi	sp,sp,32
    80002d74:	8082                	ret
    panic("usertrap: not from user mode");
    80002d76:	00005517          	auipc	a0,0x5
    80002d7a:	5f250513          	addi	a0,a0,1522 # 80008368 <states.0+0x58>
    80002d7e:	ffffd097          	auipc	ra,0xffffd
    80002d82:	7bc080e7          	jalr	1980(ra) # 8000053a <panic>
      exit(-1);
    80002d86:	557d                	li	a0,-1
    80002d88:	fffff097          	auipc	ra,0xfffff
    80002d8c:	5a6080e7          	jalr	1446(ra) # 8000232e <exit>
    80002d90:	bf4d                	j	80002d42 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80002d92:	00000097          	auipc	ra,0x0
    80002d96:	ecc080e7          	jalr	-308(ra) # 80002c5e <devintr>
    80002d9a:	892a                	mv	s2,a0
    80002d9c:	c501                	beqz	a0,80002da4 <usertrap+0xa4>
  if(p->killed)
    80002d9e:	549c                	lw	a5,40(s1)
    80002da0:	c3a1                	beqz	a5,80002de0 <usertrap+0xe0>
    80002da2:	a815                	j	80002dd6 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002da4:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002da8:	5890                	lw	a2,48(s1)
    80002daa:	00005517          	auipc	a0,0x5
    80002dae:	5de50513          	addi	a0,a0,1502 # 80008388 <states.0+0x78>
    80002db2:	ffffd097          	auipc	ra,0xffffd
    80002db6:	7d2080e7          	jalr	2002(ra) # 80000584 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002dba:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002dbe:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002dc2:	00005517          	auipc	a0,0x5
    80002dc6:	5f650513          	addi	a0,a0,1526 # 800083b8 <states.0+0xa8>
    80002dca:	ffffd097          	auipc	ra,0xffffd
    80002dce:	7ba080e7          	jalr	1978(ra) # 80000584 <printf>
    p->killed = 1;
    80002dd2:	4785                	li	a5,1
    80002dd4:	d49c                	sw	a5,40(s1)
    exit(-1);
    80002dd6:	557d                	li	a0,-1
    80002dd8:	fffff097          	auipc	ra,0xfffff
    80002ddc:	556080e7          	jalr	1366(ra) # 8000232e <exit>
  if(which_dev == 2/*  && myproc() != 0 && myproc()->state == RUNNING  */){
    80002de0:	4789                	li	a5,2
    80002de2:	f8f910e3          	bne	s2,a5,80002d62 <usertrap+0x62>
    struct proc *p1 = myproc();
    80002de6:	fffff097          	auipc	ra,0xfffff
    80002dea:	bf2080e7          	jalr	-1038(ra) # 800019d8 <myproc>
    if(p1->timeinQ <=0){
    80002dee:	19052783          	lw	a5,400(a0)
    80002df2:	fba5                	bnez	a5,80002d62 <usertrap+0x62>
      if(p1->level<4){
    80002df4:	18c52783          	lw	a5,396(a0)
    80002df8:	470d                	li	a4,3
    80002dfa:	02f76163          	bltu	a4,a5,80002e1c <usertrap+0x11c>
        p1->level++;
    80002dfe:	2785                	addiw	a5,a5,1
    80002e00:	18f52623          	sw	a5,396(a0)
        p1->timeinQ = 1 << p1->level;  
    80002e04:	4705                	li	a4,1
    80002e06:	00f717bb          	sllw	a5,a4,a5
    80002e0a:	18f52823          	sw	a5,400(a0)
      yield();
    80002e0e:	fffff097          	auipc	ra,0xfffff
    80002e12:	268080e7          	jalr	616(ra) # 80002076 <yield>
    80002e16:	b7b1                	j	80002d62 <usertrap+0x62>
  int which_dev = 0;
    80002e18:	4901                	li	s2,0
    80002e1a:	bf75                	j	80002dd6 <usertrap+0xd6>
      else if(p1->level==4){
    80002e1c:	4711                	li	a4,4
    80002e1e:	fee798e3          	bne	a5,a4,80002e0e <usertrap+0x10e>
        p1->timeinQ = 1 << p1->level;
    80002e22:	47c1                	li	a5,16
    80002e24:	18f52823          	sw	a5,400(a0)
    80002e28:	b7dd                	j	80002e0e <usertrap+0x10e>

0000000080002e2a <kerneltrap>:
{
    80002e2a:	7179                	addi	sp,sp,-48
    80002e2c:	f406                	sd	ra,40(sp)
    80002e2e:	f022                	sd	s0,32(sp)
    80002e30:	ec26                	sd	s1,24(sp)
    80002e32:	e84a                	sd	s2,16(sp)
    80002e34:	e44e                	sd	s3,8(sp)
    80002e36:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002e38:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e3c:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002e40:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002e44:	1004f793          	andi	a5,s1,256
    80002e48:	cb85                	beqz	a5,80002e78 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e4a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002e4e:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002e50:	ef85                	bnez	a5,80002e88 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002e52:	00000097          	auipc	ra,0x0
    80002e56:	e0c080e7          	jalr	-500(ra) # 80002c5e <devintr>
    80002e5a:	cd1d                	beqz	a0,80002e98 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING){
    80002e5c:	4789                	li	a5,2
    80002e5e:	06f50a63          	beq	a0,a5,80002ed2 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002e62:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002e66:	10049073          	csrw	sstatus,s1
}
    80002e6a:	70a2                	ld	ra,40(sp)
    80002e6c:	7402                	ld	s0,32(sp)
    80002e6e:	64e2                	ld	s1,24(sp)
    80002e70:	6942                	ld	s2,16(sp)
    80002e72:	69a2                	ld	s3,8(sp)
    80002e74:	6145                	addi	sp,sp,48
    80002e76:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002e78:	00005517          	auipc	a0,0x5
    80002e7c:	56050513          	addi	a0,a0,1376 # 800083d8 <states.0+0xc8>
    80002e80:	ffffd097          	auipc	ra,0xffffd
    80002e84:	6ba080e7          	jalr	1722(ra) # 8000053a <panic>
    panic("kerneltrap: interrupts enabled");
    80002e88:	00005517          	auipc	a0,0x5
    80002e8c:	57850513          	addi	a0,a0,1400 # 80008400 <states.0+0xf0>
    80002e90:	ffffd097          	auipc	ra,0xffffd
    80002e94:	6aa080e7          	jalr	1706(ra) # 8000053a <panic>
    printf("scause %p\n", scause);
    80002e98:	85ce                	mv	a1,s3
    80002e9a:	00005517          	auipc	a0,0x5
    80002e9e:	58650513          	addi	a0,a0,1414 # 80008420 <states.0+0x110>
    80002ea2:	ffffd097          	auipc	ra,0xffffd
    80002ea6:	6e2080e7          	jalr	1762(ra) # 80000584 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002eaa:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002eae:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002eb2:	00005517          	auipc	a0,0x5
    80002eb6:	57e50513          	addi	a0,a0,1406 # 80008430 <states.0+0x120>
    80002eba:	ffffd097          	auipc	ra,0xffffd
    80002ebe:	6ca080e7          	jalr	1738(ra) # 80000584 <printf>
    panic("kerneltrap");
    80002ec2:	00005517          	auipc	a0,0x5
    80002ec6:	58650513          	addi	a0,a0,1414 # 80008448 <states.0+0x138>
    80002eca:	ffffd097          	auipc	ra,0xffffd
    80002ece:	670080e7          	jalr	1648(ra) # 8000053a <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING){
    80002ed2:	fffff097          	auipc	ra,0xfffff
    80002ed6:	b06080e7          	jalr	-1274(ra) # 800019d8 <myproc>
    80002eda:	d541                	beqz	a0,80002e62 <kerneltrap+0x38>
    80002edc:	fffff097          	auipc	ra,0xfffff
    80002ee0:	afc080e7          	jalr	-1284(ra) # 800019d8 <myproc>
    80002ee4:	4d18                	lw	a4,24(a0)
    80002ee6:	4791                	li	a5,4
    80002ee8:	f6f71de3          	bne	a4,a5,80002e62 <kerneltrap+0x38>
    struct proc *p = myproc();
    80002eec:	fffff097          	auipc	ra,0xfffff
    80002ef0:	aec080e7          	jalr	-1300(ra) # 800019d8 <myproc>
    if(p->timeinQ <=0){
    80002ef4:	19052783          	lw	a5,400(a0)
    80002ef8:	f7ad                	bnez	a5,80002e62 <kerneltrap+0x38>
      if(p->level<4){
    80002efa:	18c52783          	lw	a5,396(a0)
    80002efe:	470d                	li	a4,3
    80002f00:	00f76f63          	bltu	a4,a5,80002f1e <kerneltrap+0xf4>
        p->level++;
    80002f04:	2785                	addiw	a5,a5,1
    80002f06:	18f52623          	sw	a5,396(a0)
        p->timeinQ =(1<<(p->level));
    80002f0a:	4705                	li	a4,1
    80002f0c:	00f717bb          	sllw	a5,a4,a5
    80002f10:	18f52823          	sw	a5,400(a0)
      yield();
    80002f14:	fffff097          	auipc	ra,0xfffff
    80002f18:	162080e7          	jalr	354(ra) # 80002076 <yield>
    80002f1c:	b799                	j	80002e62 <kerneltrap+0x38>
      else if(p->level==4){
    80002f1e:	4711                	li	a4,4
    80002f20:	fee79ae3          	bne	a5,a4,80002f14 <kerneltrap+0xea>
        p->timeinQ = 1 << p->level;
    80002f24:	47c1                	li	a5,16
    80002f26:	18f52823          	sw	a5,400(a0)
    80002f2a:	b7ed                	j	80002f14 <kerneltrap+0xea>

0000000080002f2c <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002f2c:	1101                	addi	sp,sp,-32
    80002f2e:	ec06                	sd	ra,24(sp)
    80002f30:	e822                	sd	s0,16(sp)
    80002f32:	e426                	sd	s1,8(sp)
    80002f34:	1000                	addi	s0,sp,32
    80002f36:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002f38:	fffff097          	auipc	ra,0xfffff
    80002f3c:	aa0080e7          	jalr	-1376(ra) # 800019d8 <myproc>
  switch (n) {
    80002f40:	4795                	li	a5,5
    80002f42:	0497e163          	bltu	a5,s1,80002f84 <argraw+0x58>
    80002f46:	048a                	slli	s1,s1,0x2
    80002f48:	00005717          	auipc	a4,0x5
    80002f4c:	61870713          	addi	a4,a4,1560 # 80008560 <states.0+0x250>
    80002f50:	94ba                	add	s1,s1,a4
    80002f52:	409c                	lw	a5,0(s1)
    80002f54:	97ba                	add	a5,a5,a4
    80002f56:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002f58:	6d3c                	ld	a5,88(a0)
    80002f5a:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002f5c:	60e2                	ld	ra,24(sp)
    80002f5e:	6442                	ld	s0,16(sp)
    80002f60:	64a2                	ld	s1,8(sp)
    80002f62:	6105                	addi	sp,sp,32
    80002f64:	8082                	ret
    return p->trapframe->a1;
    80002f66:	6d3c                	ld	a5,88(a0)
    80002f68:	7fa8                	ld	a0,120(a5)
    80002f6a:	bfcd                	j	80002f5c <argraw+0x30>
    return p->trapframe->a2;
    80002f6c:	6d3c                	ld	a5,88(a0)
    80002f6e:	63c8                	ld	a0,128(a5)
    80002f70:	b7f5                	j	80002f5c <argraw+0x30>
    return p->trapframe->a3;
    80002f72:	6d3c                	ld	a5,88(a0)
    80002f74:	67c8                	ld	a0,136(a5)
    80002f76:	b7dd                	j	80002f5c <argraw+0x30>
    return p->trapframe->a4;
    80002f78:	6d3c                	ld	a5,88(a0)
    80002f7a:	6bc8                	ld	a0,144(a5)
    80002f7c:	b7c5                	j	80002f5c <argraw+0x30>
    return p->trapframe->a5;
    80002f7e:	6d3c                	ld	a5,88(a0)
    80002f80:	6fc8                	ld	a0,152(a5)
    80002f82:	bfe9                	j	80002f5c <argraw+0x30>
  panic("argraw");
    80002f84:	00005517          	auipc	a0,0x5
    80002f88:	4d450513          	addi	a0,a0,1236 # 80008458 <states.0+0x148>
    80002f8c:	ffffd097          	auipc	ra,0xffffd
    80002f90:	5ae080e7          	jalr	1454(ra) # 8000053a <panic>

0000000080002f94 <fetchaddr>:
{
    80002f94:	1101                	addi	sp,sp,-32
    80002f96:	ec06                	sd	ra,24(sp)
    80002f98:	e822                	sd	s0,16(sp)
    80002f9a:	e426                	sd	s1,8(sp)
    80002f9c:	e04a                	sd	s2,0(sp)
    80002f9e:	1000                	addi	s0,sp,32
    80002fa0:	84aa                	mv	s1,a0
    80002fa2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002fa4:	fffff097          	auipc	ra,0xfffff
    80002fa8:	a34080e7          	jalr	-1484(ra) # 800019d8 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002fac:	653c                	ld	a5,72(a0)
    80002fae:	02f4f863          	bgeu	s1,a5,80002fde <fetchaddr+0x4a>
    80002fb2:	00848713          	addi	a4,s1,8
    80002fb6:	02e7e663          	bltu	a5,a4,80002fe2 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002fba:	46a1                	li	a3,8
    80002fbc:	8626                	mv	a2,s1
    80002fbe:	85ca                	mv	a1,s2
    80002fc0:	6928                	ld	a0,80(a0)
    80002fc2:	ffffe097          	auipc	ra,0xffffe
    80002fc6:	72c080e7          	jalr	1836(ra) # 800016ee <copyin>
    80002fca:	00a03533          	snez	a0,a0
    80002fce:	40a00533          	neg	a0,a0
}
    80002fd2:	60e2                	ld	ra,24(sp)
    80002fd4:	6442                	ld	s0,16(sp)
    80002fd6:	64a2                	ld	s1,8(sp)
    80002fd8:	6902                	ld	s2,0(sp)
    80002fda:	6105                	addi	sp,sp,32
    80002fdc:	8082                	ret
    return -1;
    80002fde:	557d                	li	a0,-1
    80002fe0:	bfcd                	j	80002fd2 <fetchaddr+0x3e>
    80002fe2:	557d                	li	a0,-1
    80002fe4:	b7fd                	j	80002fd2 <fetchaddr+0x3e>

0000000080002fe6 <fetchstr>:
{
    80002fe6:	7179                	addi	sp,sp,-48
    80002fe8:	f406                	sd	ra,40(sp)
    80002fea:	f022                	sd	s0,32(sp)
    80002fec:	ec26                	sd	s1,24(sp)
    80002fee:	e84a                	sd	s2,16(sp)
    80002ff0:	e44e                	sd	s3,8(sp)
    80002ff2:	1800                	addi	s0,sp,48
    80002ff4:	892a                	mv	s2,a0
    80002ff6:	84ae                	mv	s1,a1
    80002ff8:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002ffa:	fffff097          	auipc	ra,0xfffff
    80002ffe:	9de080e7          	jalr	-1570(ra) # 800019d8 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80003002:	86ce                	mv	a3,s3
    80003004:	864a                	mv	a2,s2
    80003006:	85a6                	mv	a1,s1
    80003008:	6928                	ld	a0,80(a0)
    8000300a:	ffffe097          	auipc	ra,0xffffe
    8000300e:	772080e7          	jalr	1906(ra) # 8000177c <copyinstr>
  if(err < 0)
    80003012:	00054763          	bltz	a0,80003020 <fetchstr+0x3a>
  return strlen(buf);
    80003016:	8526                	mv	a0,s1
    80003018:	ffffe097          	auipc	ra,0xffffe
    8000301c:	e30080e7          	jalr	-464(ra) # 80000e48 <strlen>
}
    80003020:	70a2                	ld	ra,40(sp)
    80003022:	7402                	ld	s0,32(sp)
    80003024:	64e2                	ld	s1,24(sp)
    80003026:	6942                	ld	s2,16(sp)
    80003028:	69a2                	ld	s3,8(sp)
    8000302a:	6145                	addi	sp,sp,48
    8000302c:	8082                	ret

000000008000302e <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    8000302e:	1101                	addi	sp,sp,-32
    80003030:	ec06                	sd	ra,24(sp)
    80003032:	e822                	sd	s0,16(sp)
    80003034:	e426                	sd	s1,8(sp)
    80003036:	1000                	addi	s0,sp,32
    80003038:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000303a:	00000097          	auipc	ra,0x0
    8000303e:	ef2080e7          	jalr	-270(ra) # 80002f2c <argraw>
    80003042:	c088                	sw	a0,0(s1)
  return 0;
}
    80003044:	4501                	li	a0,0
    80003046:	60e2                	ld	ra,24(sp)
    80003048:	6442                	ld	s0,16(sp)
    8000304a:	64a2                	ld	s1,8(sp)
    8000304c:	6105                	addi	sp,sp,32
    8000304e:	8082                	ret

0000000080003050 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80003050:	1101                	addi	sp,sp,-32
    80003052:	ec06                	sd	ra,24(sp)
    80003054:	e822                	sd	s0,16(sp)
    80003056:	e426                	sd	s1,8(sp)
    80003058:	1000                	addi	s0,sp,32
    8000305a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000305c:	00000097          	auipc	ra,0x0
    80003060:	ed0080e7          	jalr	-304(ra) # 80002f2c <argraw>
    80003064:	e088                	sd	a0,0(s1)
  return 0;
}
    80003066:	4501                	li	a0,0
    80003068:	60e2                	ld	ra,24(sp)
    8000306a:	6442                	ld	s0,16(sp)
    8000306c:	64a2                	ld	s1,8(sp)
    8000306e:	6105                	addi	sp,sp,32
    80003070:	8082                	ret

0000000080003072 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80003072:	1101                	addi	sp,sp,-32
    80003074:	ec06                	sd	ra,24(sp)
    80003076:	e822                	sd	s0,16(sp)
    80003078:	e426                	sd	s1,8(sp)
    8000307a:	e04a                	sd	s2,0(sp)
    8000307c:	1000                	addi	s0,sp,32
    8000307e:	84ae                	mv	s1,a1
    80003080:	8932                	mv	s2,a2
  *ip = argraw(n);
    80003082:	00000097          	auipc	ra,0x0
    80003086:	eaa080e7          	jalr	-342(ra) # 80002f2c <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    8000308a:	864a                	mv	a2,s2
    8000308c:	85a6                	mv	a1,s1
    8000308e:	00000097          	auipc	ra,0x0
    80003092:	f58080e7          	jalr	-168(ra) # 80002fe6 <fetchstr>
}
    80003096:	60e2                	ld	ra,24(sp)
    80003098:	6442                	ld	s0,16(sp)
    8000309a:	64a2                	ld	s1,8(sp)
    8000309c:	6902                	ld	s2,0(sp)
    8000309e:	6105                	addi	sp,sp,32
    800030a0:	8082                	ret

00000000800030a2 <syscall>:
};


void
syscall(void)
{
    800030a2:	7139                	addi	sp,sp,-64
    800030a4:	fc06                	sd	ra,56(sp)
    800030a6:	f822                	sd	s0,48(sp)
    800030a8:	f426                	sd	s1,40(sp)
    800030aa:	f04a                	sd	s2,32(sp)
    800030ac:	ec4e                	sd	s3,24(sp)
    800030ae:	e852                	sd	s4,16(sp)
    800030b0:	0080                	addi	s0,sp,64
  int num;
  struct proc *p = myproc();
    800030b2:	fffff097          	auipc	ra,0xfffff
    800030b6:	926080e7          	jalr	-1754(ra) # 800019d8 <myproc>
    800030ba:	892a                	mv	s2,a0

  
  num = p->trapframe->a7;
    800030bc:	6d3c                	ld	a5,88(a0)
    800030be:	77c4                	ld	s1,168(a5)
    800030c0:	00048a1b          	sext.w	s4,s1

  int a;
  
  if(syscall_argcnt[num -1 ] > 0)
    800030c4:	fff4899b          	addiw	s3,s1,-1
    800030c8:	00299713          	slli	a4,s3,0x2
    800030cc:	00006797          	auipc	a5,0x6
    800030d0:	8cc78793          	addi	a5,a5,-1844 # 80008998 <syscall_argcnt>
    800030d4:	97ba                	add	a5,a5,a4
    800030d6:	439c                	lw	a5,0(a5)
    800030d8:	0cf04863          	bgtz	a5,800031a8 <syscall+0x106>
    argint(0, &a);
  
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800030dc:	34fd                	addiw	s1,s1,-1
    800030de:	47dd                	li	a5,23
    800030e0:	0e97e763          	bltu	a5,s1,800031ce <syscall+0x12c>
    800030e4:	003a1713          	slli	a4,s4,0x3
    800030e8:	00005797          	auipc	a5,0x5
    800030ec:	49078793          	addi	a5,a5,1168 # 80008578 <syscalls>
    800030f0:	97ba                	add	a5,a5,a4
    800030f2:	639c                	ld	a5,0(a5)
    800030f4:	cfe9                	beqz	a5,800031ce <syscall+0x12c>
    p->trapframe->a0 = syscalls[num]();
    800030f6:	05893483          	ld	s1,88(s2)
    800030fa:	9782                	jalr	a5
    800030fc:	f8a8                	sd	a0,112(s1)

    int mask = myproc()->trace_mask;
    800030fe:	fffff097          	auipc	ra,0xfffff
    80003102:	8da080e7          	jalr	-1830(ra) # 800019d8 <myproc>

    if((mask ) & (1 << num)){
    80003106:	16852483          	lw	s1,360(a0)
    8000310a:	4144d4bb          	sraw	s1,s1,s4
    8000310e:	8885                	andi	s1,s1,1
    80003110:	c0e5                	beqz	s1,800031f0 <syscall+0x14e>
      printf("syscall %s (", syscall_names[num-1]); 
    80003112:	00006a17          	auipc	s4,0x6
    80003116:	886a0a13          	addi	s4,s4,-1914 # 80008998 <syscall_argcnt>
    8000311a:	00399793          	slli	a5,s3,0x3
    8000311e:	97d2                	add	a5,a5,s4
    80003120:	73ac                	ld	a1,96(a5)
    80003122:	00005517          	auipc	a0,0x5
    80003126:	33e50513          	addi	a0,a0,830 # 80008460 <states.0+0x150>
    8000312a:	ffffd097          	auipc	ra,0xffffd
    8000312e:	45a080e7          	jalr	1114(ra) # 80000584 <printf>
      
      if(syscall_argcnt[num -1 ] > 0)
    80003132:	00299793          	slli	a5,s3,0x2
    80003136:	9a3e                	add	s4,s4,a5
    80003138:	000a2783          	lw	a5,0(s4)
    8000313c:	06f04e63          	bgtz	a5,800031b8 <syscall+0x116>
        printf("%d ", a);

      for(int i=1;i<syscall_argcnt[num-1];i++){
    80003140:	00299713          	slli	a4,s3,0x2
    80003144:	00006797          	auipc	a5,0x6
    80003148:	85478793          	addi	a5,a5,-1964 # 80008998 <syscall_argcnt>
    8000314c:	97ba                	add	a5,a5,a4
    8000314e:	4398                	lw	a4,0(a5)
    80003150:	4785                	li	a5,1
    80003152:	02e7df63          	bge	a5,a4,80003190 <syscall+0xee>
        int n;
        argint(i, &n);
        printf("%d ", n);
    80003156:	00005a17          	auipc	s4,0x5
    8000315a:	31aa0a13          	addi	s4,s4,794 # 80008470 <states.0+0x160>
      for(int i=1;i<syscall_argcnt[num-1];i++){
    8000315e:	098a                	slli	s3,s3,0x2
    80003160:	00006797          	auipc	a5,0x6
    80003164:	83878793          	addi	a5,a5,-1992 # 80008998 <syscall_argcnt>
    80003168:	99be                	add	s3,s3,a5
        argint(i, &n);
    8000316a:	fc840593          	addi	a1,s0,-56
    8000316e:	8526                	mv	a0,s1
    80003170:	00000097          	auipc	ra,0x0
    80003174:	ebe080e7          	jalr	-322(ra) # 8000302e <argint>
        printf("%d ", n);
    80003178:	fc842583          	lw	a1,-56(s0)
    8000317c:	8552                	mv	a0,s4
    8000317e:	ffffd097          	auipc	ra,0xffffd
    80003182:	406080e7          	jalr	1030(ra) # 80000584 <printf>
      for(int i=1;i<syscall_argcnt[num-1];i++){
    80003186:	2485                	addiw	s1,s1,1
    80003188:	0009a783          	lw	a5,0(s3)
    8000318c:	fcf4cfe3          	blt	s1,a5,8000316a <syscall+0xc8>
      }
      printf("\b) -> %d\n", p->trapframe->a0);
    80003190:	05893783          	ld	a5,88(s2)
    80003194:	7bac                	ld	a1,112(a5)
    80003196:	00005517          	auipc	a0,0x5
    8000319a:	2e250513          	addi	a0,a0,738 # 80008478 <states.0+0x168>
    8000319e:	ffffd097          	auipc	ra,0xffffd
    800031a2:	3e6080e7          	jalr	998(ra) # 80000584 <printf>
    800031a6:	a0a9                	j	800031f0 <syscall+0x14e>
    argint(0, &a);
    800031a8:	fcc40593          	addi	a1,s0,-52
    800031ac:	4501                	li	a0,0
    800031ae:	00000097          	auipc	ra,0x0
    800031b2:	e80080e7          	jalr	-384(ra) # 8000302e <argint>
    800031b6:	b71d                	j	800030dc <syscall+0x3a>
        printf("%d ", a);
    800031b8:	fcc42583          	lw	a1,-52(s0)
    800031bc:	00005517          	auipc	a0,0x5
    800031c0:	2b450513          	addi	a0,a0,692 # 80008470 <states.0+0x160>
    800031c4:	ffffd097          	auipc	ra,0xffffd
    800031c8:	3c0080e7          	jalr	960(ra) # 80000584 <printf>
    800031cc:	bf95                	j	80003140 <syscall+0x9e>

    }
  } else {
    printf("%d %s: unknown sys call %d\n",
    800031ce:	86d2                	mv	a3,s4
    800031d0:	15890613          	addi	a2,s2,344
    800031d4:	03092583          	lw	a1,48(s2)
    800031d8:	00005517          	auipc	a0,0x5
    800031dc:	2b050513          	addi	a0,a0,688 # 80008488 <states.0+0x178>
    800031e0:	ffffd097          	auipc	ra,0xffffd
    800031e4:	3a4080e7          	jalr	932(ra) # 80000584 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800031e8:	05893783          	ld	a5,88(s2)
    800031ec:	577d                	li	a4,-1
    800031ee:	fbb8                	sd	a4,112(a5)
  }
}
    800031f0:	70e2                	ld	ra,56(sp)
    800031f2:	7442                	ld	s0,48(sp)
    800031f4:	74a2                	ld	s1,40(sp)
    800031f6:	7902                	ld	s2,32(sp)
    800031f8:	69e2                	ld	s3,24(sp)
    800031fa:	6a42                	ld	s4,16(sp)
    800031fc:	6121                	addi	sp,sp,64
    800031fe:	8082                	ret

0000000080003200 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80003200:	1101                	addi	sp,sp,-32
    80003202:	ec06                	sd	ra,24(sp)
    80003204:	e822                	sd	s0,16(sp)
    80003206:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80003208:	fec40593          	addi	a1,s0,-20
    8000320c:	4501                	li	a0,0
    8000320e:	00000097          	auipc	ra,0x0
    80003212:	e20080e7          	jalr	-480(ra) # 8000302e <argint>
    return -1;
    80003216:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80003218:	00054963          	bltz	a0,8000322a <sys_exit+0x2a>
  exit(n);
    8000321c:	fec42503          	lw	a0,-20(s0)
    80003220:	fffff097          	auipc	ra,0xfffff
    80003224:	10e080e7          	jalr	270(ra) # 8000232e <exit>
  return 0;  // not reached
    80003228:	4781                	li	a5,0
}
    8000322a:	853e                	mv	a0,a5
    8000322c:	60e2                	ld	ra,24(sp)
    8000322e:	6442                	ld	s0,16(sp)
    80003230:	6105                	addi	sp,sp,32
    80003232:	8082                	ret

0000000080003234 <sys_getpid>:

uint64
sys_getpid(void)
{
    80003234:	1141                	addi	sp,sp,-16
    80003236:	e406                	sd	ra,8(sp)
    80003238:	e022                	sd	s0,0(sp)
    8000323a:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000323c:	ffffe097          	auipc	ra,0xffffe
    80003240:	79c080e7          	jalr	1948(ra) # 800019d8 <myproc>
}
    80003244:	5908                	lw	a0,48(a0)
    80003246:	60a2                	ld	ra,8(sp)
    80003248:	6402                	ld	s0,0(sp)
    8000324a:	0141                	addi	sp,sp,16
    8000324c:	8082                	ret

000000008000324e <sys_fork>:

uint64
sys_fork(void)
{
    8000324e:	1141                	addi	sp,sp,-16
    80003250:	e406                	sd	ra,8(sp)
    80003252:	e022                	sd	s0,0(sp)
    80003254:	0800                	addi	s0,sp,16
  return fork();
    80003256:	fffff097          	auipc	ra,0xfffff
    8000325a:	b9e080e7          	jalr	-1122(ra) # 80001df4 <fork>
}
    8000325e:	60a2                	ld	ra,8(sp)
    80003260:	6402                	ld	s0,0(sp)
    80003262:	0141                	addi	sp,sp,16
    80003264:	8082                	ret

0000000080003266 <sys_wait>:

uint64
sys_wait(void)
{
    80003266:	1101                	addi	sp,sp,-32
    80003268:	ec06                	sd	ra,24(sp)
    8000326a:	e822                	sd	s0,16(sp)
    8000326c:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    8000326e:	fe840593          	addi	a1,s0,-24
    80003272:	4501                	li	a0,0
    80003274:	00000097          	auipc	ra,0x0
    80003278:	ddc080e7          	jalr	-548(ra) # 80003050 <argaddr>
    8000327c:	87aa                	mv	a5,a0
    return -1;
    8000327e:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80003280:	0007c863          	bltz	a5,80003290 <sys_wait+0x2a>
  return wait(p);
    80003284:	fe843503          	ld	a0,-24(s0)
    80003288:	fffff097          	auipc	ra,0xfffff
    8000328c:	e9a080e7          	jalr	-358(ra) # 80002122 <wait>
}
    80003290:	60e2                	ld	ra,24(sp)
    80003292:	6442                	ld	s0,16(sp)
    80003294:	6105                	addi	sp,sp,32
    80003296:	8082                	ret

0000000080003298 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80003298:	7179                	addi	sp,sp,-48
    8000329a:	f406                	sd	ra,40(sp)
    8000329c:	f022                	sd	s0,32(sp)
    8000329e:	ec26                	sd	s1,24(sp)
    800032a0:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800032a2:	fdc40593          	addi	a1,s0,-36
    800032a6:	4501                	li	a0,0
    800032a8:	00000097          	auipc	ra,0x0
    800032ac:	d86080e7          	jalr	-634(ra) # 8000302e <argint>
    800032b0:	87aa                	mv	a5,a0
    return -1;
    800032b2:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800032b4:	0207c063          	bltz	a5,800032d4 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    800032b8:	ffffe097          	auipc	ra,0xffffe
    800032bc:	720080e7          	jalr	1824(ra) # 800019d8 <myproc>
    800032c0:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    800032c2:	fdc42503          	lw	a0,-36(s0)
    800032c6:	fffff097          	auipc	ra,0xfffff
    800032ca:	ab6080e7          	jalr	-1354(ra) # 80001d7c <growproc>
    800032ce:	00054863          	bltz	a0,800032de <sys_sbrk+0x46>
    return -1;
  return addr;
    800032d2:	8526                	mv	a0,s1
}
    800032d4:	70a2                	ld	ra,40(sp)
    800032d6:	7402                	ld	s0,32(sp)
    800032d8:	64e2                	ld	s1,24(sp)
    800032da:	6145                	addi	sp,sp,48
    800032dc:	8082                	ret
    return -1;
    800032de:	557d                	li	a0,-1
    800032e0:	bfd5                	j	800032d4 <sys_sbrk+0x3c>

00000000800032e2 <sys_sleep>:

uint64
sys_sleep(void)
{
    800032e2:	7139                	addi	sp,sp,-64
    800032e4:	fc06                	sd	ra,56(sp)
    800032e6:	f822                	sd	s0,48(sp)
    800032e8:	f426                	sd	s1,40(sp)
    800032ea:	f04a                	sd	s2,32(sp)
    800032ec:	ec4e                	sd	s3,24(sp)
    800032ee:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800032f0:	fcc40593          	addi	a1,s0,-52
    800032f4:	4501                	li	a0,0
    800032f6:	00000097          	auipc	ra,0x0
    800032fa:	d38080e7          	jalr	-712(ra) # 8000302e <argint>
    return -1;
    800032fe:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80003300:	06054563          	bltz	a0,8000336a <sys_sleep+0x88>
  acquire(&tickslock);
    80003304:	00016517          	auipc	a0,0x16
    80003308:	7f450513          	addi	a0,a0,2036 # 80019af8 <tickslock>
    8000330c:	ffffe097          	auipc	ra,0xffffe
    80003310:	8c4080e7          	jalr	-1852(ra) # 80000bd0 <acquire>
  ticks0 = ticks;
    80003314:	00006917          	auipc	s2,0x6
    80003318:	d1c92903          	lw	s2,-740(s2) # 80009030 <ticks>
  while(ticks - ticks0 < n){
    8000331c:	fcc42783          	lw	a5,-52(s0)
    80003320:	cf85                	beqz	a5,80003358 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80003322:	00016997          	auipc	s3,0x16
    80003326:	7d698993          	addi	s3,s3,2006 # 80019af8 <tickslock>
    8000332a:	00006497          	auipc	s1,0x6
    8000332e:	d0648493          	addi	s1,s1,-762 # 80009030 <ticks>
    if(myproc()->killed){
    80003332:	ffffe097          	auipc	ra,0xffffe
    80003336:	6a6080e7          	jalr	1702(ra) # 800019d8 <myproc>
    8000333a:	551c                	lw	a5,40(a0)
    8000333c:	ef9d                	bnez	a5,8000337a <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    8000333e:	85ce                	mv	a1,s3
    80003340:	8526                	mv	a0,s1
    80003342:	fffff097          	auipc	ra,0xfffff
    80003346:	d7c080e7          	jalr	-644(ra) # 800020be <sleep>
  while(ticks - ticks0 < n){
    8000334a:	409c                	lw	a5,0(s1)
    8000334c:	412787bb          	subw	a5,a5,s2
    80003350:	fcc42703          	lw	a4,-52(s0)
    80003354:	fce7efe3          	bltu	a5,a4,80003332 <sys_sleep+0x50>
  }
  release(&tickslock);
    80003358:	00016517          	auipc	a0,0x16
    8000335c:	7a050513          	addi	a0,a0,1952 # 80019af8 <tickslock>
    80003360:	ffffe097          	auipc	ra,0xffffe
    80003364:	924080e7          	jalr	-1756(ra) # 80000c84 <release>
  return 0;
    80003368:	4781                	li	a5,0
}
    8000336a:	853e                	mv	a0,a5
    8000336c:	70e2                	ld	ra,56(sp)
    8000336e:	7442                	ld	s0,48(sp)
    80003370:	74a2                	ld	s1,40(sp)
    80003372:	7902                	ld	s2,32(sp)
    80003374:	69e2                	ld	s3,24(sp)
    80003376:	6121                	addi	sp,sp,64
    80003378:	8082                	ret
      release(&tickslock);
    8000337a:	00016517          	auipc	a0,0x16
    8000337e:	77e50513          	addi	a0,a0,1918 # 80019af8 <tickslock>
    80003382:	ffffe097          	auipc	ra,0xffffe
    80003386:	902080e7          	jalr	-1790(ra) # 80000c84 <release>
      return -1;
    8000338a:	57fd                	li	a5,-1
    8000338c:	bff9                	j	8000336a <sys_sleep+0x88>

000000008000338e <sys_kill>:

uint64
sys_kill(void)
{
    8000338e:	1101                	addi	sp,sp,-32
    80003390:	ec06                	sd	ra,24(sp)
    80003392:	e822                	sd	s0,16(sp)
    80003394:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80003396:	fec40593          	addi	a1,s0,-20
    8000339a:	4501                	li	a0,0
    8000339c:	00000097          	auipc	ra,0x0
    800033a0:	c92080e7          	jalr	-878(ra) # 8000302e <argint>
    800033a4:	87aa                	mv	a5,a0
    return -1;
    800033a6:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800033a8:	0007c863          	bltz	a5,800033b8 <sys_kill+0x2a>
  return kill(pid);
    800033ac:	fec42503          	lw	a0,-20(s0)
    800033b0:	fffff097          	auipc	ra,0xfffff
    800033b4:	060080e7          	jalr	96(ra) # 80002410 <kill>
}
    800033b8:	60e2                	ld	ra,24(sp)
    800033ba:	6442                	ld	s0,16(sp)
    800033bc:	6105                	addi	sp,sp,32
    800033be:	8082                	ret

00000000800033c0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800033c0:	1101                	addi	sp,sp,-32
    800033c2:	ec06                	sd	ra,24(sp)
    800033c4:	e822                	sd	s0,16(sp)
    800033c6:	e426                	sd	s1,8(sp)
    800033c8:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800033ca:	00016517          	auipc	a0,0x16
    800033ce:	72e50513          	addi	a0,a0,1838 # 80019af8 <tickslock>
    800033d2:	ffffd097          	auipc	ra,0xffffd
    800033d6:	7fe080e7          	jalr	2046(ra) # 80000bd0 <acquire>
  xticks = ticks;
    800033da:	00006497          	auipc	s1,0x6
    800033de:	c564a483          	lw	s1,-938(s1) # 80009030 <ticks>
  release(&tickslock);
    800033e2:	00016517          	auipc	a0,0x16
    800033e6:	71650513          	addi	a0,a0,1814 # 80019af8 <tickslock>
    800033ea:	ffffe097          	auipc	ra,0xffffe
    800033ee:	89a080e7          	jalr	-1894(ra) # 80000c84 <release>
  return xticks;
}
    800033f2:	02049513          	slli	a0,s1,0x20
    800033f6:	9101                	srli	a0,a0,0x20
    800033f8:	60e2                	ld	ra,24(sp)
    800033fa:	6442                	ld	s0,16(sp)
    800033fc:	64a2                	ld	s1,8(sp)
    800033fe:	6105                	addi	sp,sp,32
    80003400:	8082                	ret

0000000080003402 <sys_trace>:

uint64 
sys_trace(void)
{
    80003402:	1101                	addi	sp,sp,-32
    80003404:	ec06                	sd	ra,24(sp)
    80003406:	e822                	sd	s0,16(sp)
    80003408:	1000                	addi	s0,sp,32
  int n;

  if (argint(0, &n) < 0)
    8000340a:	fec40593          	addi	a1,s0,-20
    8000340e:	4501                	li	a0,0
    80003410:	00000097          	auipc	ra,0x0
    80003414:	c1e080e7          	jalr	-994(ra) # 8000302e <argint>
    return -1;
    80003418:	57fd                	li	a5,-1
  if (argint(0, &n) < 0)
    8000341a:	00054b63          	bltz	a0,80003430 <sys_trace+0x2e>
  else 
    myproc()->trace_mask = n;
    8000341e:	ffffe097          	auipc	ra,0xffffe
    80003422:	5ba080e7          	jalr	1466(ra) # 800019d8 <myproc>
    80003426:	fec42783          	lw	a5,-20(s0)
    8000342a:	16f52423          	sw	a5,360(a0)

  return 0;  
    8000342e:	4781                	li	a5,0
}
    80003430:	853e                	mv	a0,a5
    80003432:	60e2                	ld	ra,24(sp)
    80003434:	6442                	ld	s0,16(sp)
    80003436:	6105                	addi	sp,sp,32
    80003438:	8082                	ret

000000008000343a <sys_set_priority>:

uint64 
sys_set_priority(void)
{
    8000343a:	1101                	addi	sp,sp,-32
    8000343c:	ec06                	sd	ra,24(sp)
    8000343e:	e822                	sd	s0,16(sp)
    80003440:	1000                	addi	s0,sp,32
  
  int new_priority;
  int procid;

  argint(0, &new_priority);
    80003442:	fec40593          	addi	a1,s0,-20
    80003446:	4501                	li	a0,0
    80003448:	00000097          	auipc	ra,0x0
    8000344c:	be6080e7          	jalr	-1050(ra) # 8000302e <argint>
  argint(1, &procid);
    80003450:	fe840593          	addi	a1,s0,-24
    80003454:	4505                	li	a0,1
    80003456:	00000097          	auipc	ra,0x0
    8000345a:	bd8080e7          	jalr	-1064(ra) # 8000302e <argint>

  int ret = _setpriority(new_priority, procid);
    8000345e:	fe842583          	lw	a1,-24(s0)
    80003462:	fec42503          	lw	a0,-20(s0)
    80003466:	fffff097          	auipc	ra,0xfffff
    8000346a:	1ce080e7          	jalr	462(ra) # 80002634 <_setpriority>
  return ret;
}
    8000346e:	60e2                	ld	ra,24(sp)
    80003470:	6442                	ld	s0,16(sp)
    80003472:	6105                	addi	sp,sp,32
    80003474:	8082                	ret

0000000080003476 <sys_waitx>:

uint64
sys_waitx(void)
{
    80003476:	7139                	addi	sp,sp,-64
    80003478:	fc06                	sd	ra,56(sp)
    8000347a:	f822                	sd	s0,48(sp)
    8000347c:	f426                	sd	s1,40(sp)
    8000347e:	f04a                	sd	s2,32(sp)
    80003480:	0080                	addi	s0,sp,64
  uint64 addr, addr1, addr2;
  uint wtime, rtime;
  if(argaddr(0, &addr) < 0)
    80003482:	fd840593          	addi	a1,s0,-40
    80003486:	4501                	li	a0,0
    80003488:	00000097          	auipc	ra,0x0
    8000348c:	bc8080e7          	jalr	-1080(ra) # 80003050 <argaddr>
    return -1;
    80003490:	57fd                	li	a5,-1
  if(argaddr(0, &addr) < 0)
    80003492:	08054063          	bltz	a0,80003512 <sys_waitx+0x9c>
  if(argaddr(1, &addr1) < 0) // user virtual memory
    80003496:	fd040593          	addi	a1,s0,-48
    8000349a:	4505                	li	a0,1
    8000349c:	00000097          	auipc	ra,0x0
    800034a0:	bb4080e7          	jalr	-1100(ra) # 80003050 <argaddr>
    return -1;
    800034a4:	57fd                	li	a5,-1
  if(argaddr(1, &addr1) < 0) // user virtual memory
    800034a6:	06054663          	bltz	a0,80003512 <sys_waitx+0x9c>
  if(argaddr(2, &addr2) < 0)
    800034aa:	fc840593          	addi	a1,s0,-56
    800034ae:	4509                	li	a0,2
    800034b0:	00000097          	auipc	ra,0x0
    800034b4:	ba0080e7          	jalr	-1120(ra) # 80003050 <argaddr>
    return -1;
    800034b8:	57fd                	li	a5,-1
  if(argaddr(2, &addr2) < 0)
    800034ba:	04054c63          	bltz	a0,80003512 <sys_waitx+0x9c>
  int ret = waitx(addr, &wtime, &rtime);
    800034be:	fc040613          	addi	a2,s0,-64
    800034c2:	fc440593          	addi	a1,s0,-60
    800034c6:	fd843503          	ld	a0,-40(s0)
    800034ca:	fffff097          	auipc	ra,0xfffff
    800034ce:	4ac080e7          	jalr	1196(ra) # 80002976 <waitx>
    800034d2:	892a                	mv	s2,a0
  struct proc* p = myproc();
    800034d4:	ffffe097          	auipc	ra,0xffffe
    800034d8:	504080e7          	jalr	1284(ra) # 800019d8 <myproc>
    800034dc:	84aa                	mv	s1,a0
  if (copyout(p->pagetable, addr1,(char*)&wtime, sizeof(int)) < 0)
    800034de:	4691                	li	a3,4
    800034e0:	fc440613          	addi	a2,s0,-60
    800034e4:	fd043583          	ld	a1,-48(s0)
    800034e8:	6928                	ld	a0,80(a0)
    800034ea:	ffffe097          	auipc	ra,0xffffe
    800034ee:	178080e7          	jalr	376(ra) # 80001662 <copyout>
    return -1;
    800034f2:	57fd                	li	a5,-1
  if (copyout(p->pagetable, addr1,(char*)&wtime, sizeof(int)) < 0)
    800034f4:	00054f63          	bltz	a0,80003512 <sys_waitx+0x9c>
  if (copyout(p->pagetable, addr2,(char*)&rtime, sizeof(int)) < 0)
    800034f8:	4691                	li	a3,4
    800034fa:	fc040613          	addi	a2,s0,-64
    800034fe:	fc843583          	ld	a1,-56(s0)
    80003502:	68a8                	ld	a0,80(s1)
    80003504:	ffffe097          	auipc	ra,0xffffe
    80003508:	15e080e7          	jalr	350(ra) # 80001662 <copyout>
    8000350c:	00054a63          	bltz	a0,80003520 <sys_waitx+0xaa>
    return -1;
  return ret;
    80003510:	87ca                	mv	a5,s2
    80003512:	853e                	mv	a0,a5
    80003514:	70e2                	ld	ra,56(sp)
    80003516:	7442                	ld	s0,48(sp)
    80003518:	74a2                	ld	s1,40(sp)
    8000351a:	7902                	ld	s2,32(sp)
    8000351c:	6121                	addi	sp,sp,64
    8000351e:	8082                	ret
    return -1;
    80003520:	57fd                	li	a5,-1
    80003522:	bfc5                	j	80003512 <sys_waitx+0x9c>

0000000080003524 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003524:	7179                	addi	sp,sp,-48
    80003526:	f406                	sd	ra,40(sp)
    80003528:	f022                	sd	s0,32(sp)
    8000352a:	ec26                	sd	s1,24(sp)
    8000352c:	e84a                	sd	s2,16(sp)
    8000352e:	e44e                	sd	s3,8(sp)
    80003530:	e052                	sd	s4,0(sp)
    80003532:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003534:	00005597          	auipc	a1,0x5
    80003538:	10c58593          	addi	a1,a1,268 # 80008640 <syscalls+0xc8>
    8000353c:	00016517          	auipc	a0,0x16
    80003540:	5d450513          	addi	a0,a0,1492 # 80019b10 <bcache>
    80003544:	ffffd097          	auipc	ra,0xffffd
    80003548:	5fc080e7          	jalr	1532(ra) # 80000b40 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000354c:	0001e797          	auipc	a5,0x1e
    80003550:	5c478793          	addi	a5,a5,1476 # 80021b10 <bcache+0x8000>
    80003554:	0001f717          	auipc	a4,0x1f
    80003558:	82470713          	addi	a4,a4,-2012 # 80021d78 <bcache+0x8268>
    8000355c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003560:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003564:	00016497          	auipc	s1,0x16
    80003568:	5c448493          	addi	s1,s1,1476 # 80019b28 <bcache+0x18>
    b->next = bcache.head.next;
    8000356c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000356e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003570:	00005a17          	auipc	s4,0x5
    80003574:	0d8a0a13          	addi	s4,s4,216 # 80008648 <syscalls+0xd0>
    b->next = bcache.head.next;
    80003578:	2b893783          	ld	a5,696(s2)
    8000357c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000357e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003582:	85d2                	mv	a1,s4
    80003584:	01048513          	addi	a0,s1,16
    80003588:	00001097          	auipc	ra,0x1
    8000358c:	4c2080e7          	jalr	1218(ra) # 80004a4a <initsleeplock>
    bcache.head.next->prev = b;
    80003590:	2b893783          	ld	a5,696(s2)
    80003594:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003596:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000359a:	45848493          	addi	s1,s1,1112
    8000359e:	fd349de3          	bne	s1,s3,80003578 <binit+0x54>
  }
}
    800035a2:	70a2                	ld	ra,40(sp)
    800035a4:	7402                	ld	s0,32(sp)
    800035a6:	64e2                	ld	s1,24(sp)
    800035a8:	6942                	ld	s2,16(sp)
    800035aa:	69a2                	ld	s3,8(sp)
    800035ac:	6a02                	ld	s4,0(sp)
    800035ae:	6145                	addi	sp,sp,48
    800035b0:	8082                	ret

00000000800035b2 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800035b2:	7179                	addi	sp,sp,-48
    800035b4:	f406                	sd	ra,40(sp)
    800035b6:	f022                	sd	s0,32(sp)
    800035b8:	ec26                	sd	s1,24(sp)
    800035ba:	e84a                	sd	s2,16(sp)
    800035bc:	e44e                	sd	s3,8(sp)
    800035be:	1800                	addi	s0,sp,48
    800035c0:	892a                	mv	s2,a0
    800035c2:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800035c4:	00016517          	auipc	a0,0x16
    800035c8:	54c50513          	addi	a0,a0,1356 # 80019b10 <bcache>
    800035cc:	ffffd097          	auipc	ra,0xffffd
    800035d0:	604080e7          	jalr	1540(ra) # 80000bd0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800035d4:	0001e497          	auipc	s1,0x1e
    800035d8:	7f44b483          	ld	s1,2036(s1) # 80021dc8 <bcache+0x82b8>
    800035dc:	0001e797          	auipc	a5,0x1e
    800035e0:	79c78793          	addi	a5,a5,1948 # 80021d78 <bcache+0x8268>
    800035e4:	02f48f63          	beq	s1,a5,80003622 <bread+0x70>
    800035e8:	873e                	mv	a4,a5
    800035ea:	a021                	j	800035f2 <bread+0x40>
    800035ec:	68a4                	ld	s1,80(s1)
    800035ee:	02e48a63          	beq	s1,a4,80003622 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800035f2:	449c                	lw	a5,8(s1)
    800035f4:	ff279ce3          	bne	a5,s2,800035ec <bread+0x3a>
    800035f8:	44dc                	lw	a5,12(s1)
    800035fa:	ff3799e3          	bne	a5,s3,800035ec <bread+0x3a>
      b->refcnt++;
    800035fe:	40bc                	lw	a5,64(s1)
    80003600:	2785                	addiw	a5,a5,1
    80003602:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003604:	00016517          	auipc	a0,0x16
    80003608:	50c50513          	addi	a0,a0,1292 # 80019b10 <bcache>
    8000360c:	ffffd097          	auipc	ra,0xffffd
    80003610:	678080e7          	jalr	1656(ra) # 80000c84 <release>
      acquiresleep(&b->lock);
    80003614:	01048513          	addi	a0,s1,16
    80003618:	00001097          	auipc	ra,0x1
    8000361c:	46c080e7          	jalr	1132(ra) # 80004a84 <acquiresleep>
      return b;
    80003620:	a8b9                	j	8000367e <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003622:	0001e497          	auipc	s1,0x1e
    80003626:	79e4b483          	ld	s1,1950(s1) # 80021dc0 <bcache+0x82b0>
    8000362a:	0001e797          	auipc	a5,0x1e
    8000362e:	74e78793          	addi	a5,a5,1870 # 80021d78 <bcache+0x8268>
    80003632:	00f48863          	beq	s1,a5,80003642 <bread+0x90>
    80003636:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003638:	40bc                	lw	a5,64(s1)
    8000363a:	cf81                	beqz	a5,80003652 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000363c:	64a4                	ld	s1,72(s1)
    8000363e:	fee49de3          	bne	s1,a4,80003638 <bread+0x86>
  panic("bget: no buffers");
    80003642:	00005517          	auipc	a0,0x5
    80003646:	00e50513          	addi	a0,a0,14 # 80008650 <syscalls+0xd8>
    8000364a:	ffffd097          	auipc	ra,0xffffd
    8000364e:	ef0080e7          	jalr	-272(ra) # 8000053a <panic>
      b->dev = dev;
    80003652:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003656:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000365a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000365e:	4785                	li	a5,1
    80003660:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003662:	00016517          	auipc	a0,0x16
    80003666:	4ae50513          	addi	a0,a0,1198 # 80019b10 <bcache>
    8000366a:	ffffd097          	auipc	ra,0xffffd
    8000366e:	61a080e7          	jalr	1562(ra) # 80000c84 <release>
      acquiresleep(&b->lock);
    80003672:	01048513          	addi	a0,s1,16
    80003676:	00001097          	auipc	ra,0x1
    8000367a:	40e080e7          	jalr	1038(ra) # 80004a84 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000367e:	409c                	lw	a5,0(s1)
    80003680:	cb89                	beqz	a5,80003692 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003682:	8526                	mv	a0,s1
    80003684:	70a2                	ld	ra,40(sp)
    80003686:	7402                	ld	s0,32(sp)
    80003688:	64e2                	ld	s1,24(sp)
    8000368a:	6942                	ld	s2,16(sp)
    8000368c:	69a2                	ld	s3,8(sp)
    8000368e:	6145                	addi	sp,sp,48
    80003690:	8082                	ret
    virtio_disk_rw(b, 0);
    80003692:	4581                	li	a1,0
    80003694:	8526                	mv	a0,s1
    80003696:	00003097          	auipc	ra,0x3
    8000369a:	f2c080e7          	jalr	-212(ra) # 800065c2 <virtio_disk_rw>
    b->valid = 1;
    8000369e:	4785                	li	a5,1
    800036a0:	c09c                	sw	a5,0(s1)
  return b;
    800036a2:	b7c5                	j	80003682 <bread+0xd0>

00000000800036a4 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800036a4:	1101                	addi	sp,sp,-32
    800036a6:	ec06                	sd	ra,24(sp)
    800036a8:	e822                	sd	s0,16(sp)
    800036aa:	e426                	sd	s1,8(sp)
    800036ac:	1000                	addi	s0,sp,32
    800036ae:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800036b0:	0541                	addi	a0,a0,16
    800036b2:	00001097          	auipc	ra,0x1
    800036b6:	46c080e7          	jalr	1132(ra) # 80004b1e <holdingsleep>
    800036ba:	cd01                	beqz	a0,800036d2 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800036bc:	4585                	li	a1,1
    800036be:	8526                	mv	a0,s1
    800036c0:	00003097          	auipc	ra,0x3
    800036c4:	f02080e7          	jalr	-254(ra) # 800065c2 <virtio_disk_rw>
}
    800036c8:	60e2                	ld	ra,24(sp)
    800036ca:	6442                	ld	s0,16(sp)
    800036cc:	64a2                	ld	s1,8(sp)
    800036ce:	6105                	addi	sp,sp,32
    800036d0:	8082                	ret
    panic("bwrite");
    800036d2:	00005517          	auipc	a0,0x5
    800036d6:	f9650513          	addi	a0,a0,-106 # 80008668 <syscalls+0xf0>
    800036da:	ffffd097          	auipc	ra,0xffffd
    800036de:	e60080e7          	jalr	-416(ra) # 8000053a <panic>

00000000800036e2 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800036e2:	1101                	addi	sp,sp,-32
    800036e4:	ec06                	sd	ra,24(sp)
    800036e6:	e822                	sd	s0,16(sp)
    800036e8:	e426                	sd	s1,8(sp)
    800036ea:	e04a                	sd	s2,0(sp)
    800036ec:	1000                	addi	s0,sp,32
    800036ee:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800036f0:	01050913          	addi	s2,a0,16
    800036f4:	854a                	mv	a0,s2
    800036f6:	00001097          	auipc	ra,0x1
    800036fa:	428080e7          	jalr	1064(ra) # 80004b1e <holdingsleep>
    800036fe:	c92d                	beqz	a0,80003770 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80003700:	854a                	mv	a0,s2
    80003702:	00001097          	auipc	ra,0x1
    80003706:	3d8080e7          	jalr	984(ra) # 80004ada <releasesleep>

  acquire(&bcache.lock);
    8000370a:	00016517          	auipc	a0,0x16
    8000370e:	40650513          	addi	a0,a0,1030 # 80019b10 <bcache>
    80003712:	ffffd097          	auipc	ra,0xffffd
    80003716:	4be080e7          	jalr	1214(ra) # 80000bd0 <acquire>
  b->refcnt--;
    8000371a:	40bc                	lw	a5,64(s1)
    8000371c:	37fd                	addiw	a5,a5,-1
    8000371e:	0007871b          	sext.w	a4,a5
    80003722:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003724:	eb05                	bnez	a4,80003754 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003726:	68bc                	ld	a5,80(s1)
    80003728:	64b8                	ld	a4,72(s1)
    8000372a:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000372c:	64bc                	ld	a5,72(s1)
    8000372e:	68b8                	ld	a4,80(s1)
    80003730:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003732:	0001e797          	auipc	a5,0x1e
    80003736:	3de78793          	addi	a5,a5,990 # 80021b10 <bcache+0x8000>
    8000373a:	2b87b703          	ld	a4,696(a5)
    8000373e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003740:	0001e717          	auipc	a4,0x1e
    80003744:	63870713          	addi	a4,a4,1592 # 80021d78 <bcache+0x8268>
    80003748:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000374a:	2b87b703          	ld	a4,696(a5)
    8000374e:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003750:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003754:	00016517          	auipc	a0,0x16
    80003758:	3bc50513          	addi	a0,a0,956 # 80019b10 <bcache>
    8000375c:	ffffd097          	auipc	ra,0xffffd
    80003760:	528080e7          	jalr	1320(ra) # 80000c84 <release>
}
    80003764:	60e2                	ld	ra,24(sp)
    80003766:	6442                	ld	s0,16(sp)
    80003768:	64a2                	ld	s1,8(sp)
    8000376a:	6902                	ld	s2,0(sp)
    8000376c:	6105                	addi	sp,sp,32
    8000376e:	8082                	ret
    panic("brelse");
    80003770:	00005517          	auipc	a0,0x5
    80003774:	f0050513          	addi	a0,a0,-256 # 80008670 <syscalls+0xf8>
    80003778:	ffffd097          	auipc	ra,0xffffd
    8000377c:	dc2080e7          	jalr	-574(ra) # 8000053a <panic>

0000000080003780 <bpin>:

void
bpin(struct buf *b) {
    80003780:	1101                	addi	sp,sp,-32
    80003782:	ec06                	sd	ra,24(sp)
    80003784:	e822                	sd	s0,16(sp)
    80003786:	e426                	sd	s1,8(sp)
    80003788:	1000                	addi	s0,sp,32
    8000378a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000378c:	00016517          	auipc	a0,0x16
    80003790:	38450513          	addi	a0,a0,900 # 80019b10 <bcache>
    80003794:	ffffd097          	auipc	ra,0xffffd
    80003798:	43c080e7          	jalr	1084(ra) # 80000bd0 <acquire>
  b->refcnt++;
    8000379c:	40bc                	lw	a5,64(s1)
    8000379e:	2785                	addiw	a5,a5,1
    800037a0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800037a2:	00016517          	auipc	a0,0x16
    800037a6:	36e50513          	addi	a0,a0,878 # 80019b10 <bcache>
    800037aa:	ffffd097          	auipc	ra,0xffffd
    800037ae:	4da080e7          	jalr	1242(ra) # 80000c84 <release>
}
    800037b2:	60e2                	ld	ra,24(sp)
    800037b4:	6442                	ld	s0,16(sp)
    800037b6:	64a2                	ld	s1,8(sp)
    800037b8:	6105                	addi	sp,sp,32
    800037ba:	8082                	ret

00000000800037bc <bunpin>:

void
bunpin(struct buf *b) {
    800037bc:	1101                	addi	sp,sp,-32
    800037be:	ec06                	sd	ra,24(sp)
    800037c0:	e822                	sd	s0,16(sp)
    800037c2:	e426                	sd	s1,8(sp)
    800037c4:	1000                	addi	s0,sp,32
    800037c6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800037c8:	00016517          	auipc	a0,0x16
    800037cc:	34850513          	addi	a0,a0,840 # 80019b10 <bcache>
    800037d0:	ffffd097          	auipc	ra,0xffffd
    800037d4:	400080e7          	jalr	1024(ra) # 80000bd0 <acquire>
  b->refcnt--;
    800037d8:	40bc                	lw	a5,64(s1)
    800037da:	37fd                	addiw	a5,a5,-1
    800037dc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800037de:	00016517          	auipc	a0,0x16
    800037e2:	33250513          	addi	a0,a0,818 # 80019b10 <bcache>
    800037e6:	ffffd097          	auipc	ra,0xffffd
    800037ea:	49e080e7          	jalr	1182(ra) # 80000c84 <release>
}
    800037ee:	60e2                	ld	ra,24(sp)
    800037f0:	6442                	ld	s0,16(sp)
    800037f2:	64a2                	ld	s1,8(sp)
    800037f4:	6105                	addi	sp,sp,32
    800037f6:	8082                	ret

00000000800037f8 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800037f8:	1101                	addi	sp,sp,-32
    800037fa:	ec06                	sd	ra,24(sp)
    800037fc:	e822                	sd	s0,16(sp)
    800037fe:	e426                	sd	s1,8(sp)
    80003800:	e04a                	sd	s2,0(sp)
    80003802:	1000                	addi	s0,sp,32
    80003804:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003806:	00d5d59b          	srliw	a1,a1,0xd
    8000380a:	0001f797          	auipc	a5,0x1f
    8000380e:	9e27a783          	lw	a5,-1566(a5) # 800221ec <sb+0x1c>
    80003812:	9dbd                	addw	a1,a1,a5
    80003814:	00000097          	auipc	ra,0x0
    80003818:	d9e080e7          	jalr	-610(ra) # 800035b2 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000381c:	0074f713          	andi	a4,s1,7
    80003820:	4785                	li	a5,1
    80003822:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003826:	14ce                	slli	s1,s1,0x33
    80003828:	90d9                	srli	s1,s1,0x36
    8000382a:	00950733          	add	a4,a0,s1
    8000382e:	05874703          	lbu	a4,88(a4)
    80003832:	00e7f6b3          	and	a3,a5,a4
    80003836:	c69d                	beqz	a3,80003864 <bfree+0x6c>
    80003838:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000383a:	94aa                	add	s1,s1,a0
    8000383c:	fff7c793          	not	a5,a5
    80003840:	8f7d                	and	a4,a4,a5
    80003842:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003846:	00001097          	auipc	ra,0x1
    8000384a:	120080e7          	jalr	288(ra) # 80004966 <log_write>
  brelse(bp);
    8000384e:	854a                	mv	a0,s2
    80003850:	00000097          	auipc	ra,0x0
    80003854:	e92080e7          	jalr	-366(ra) # 800036e2 <brelse>
}
    80003858:	60e2                	ld	ra,24(sp)
    8000385a:	6442                	ld	s0,16(sp)
    8000385c:	64a2                	ld	s1,8(sp)
    8000385e:	6902                	ld	s2,0(sp)
    80003860:	6105                	addi	sp,sp,32
    80003862:	8082                	ret
    panic("freeing free block");
    80003864:	00005517          	auipc	a0,0x5
    80003868:	e1450513          	addi	a0,a0,-492 # 80008678 <syscalls+0x100>
    8000386c:	ffffd097          	auipc	ra,0xffffd
    80003870:	cce080e7          	jalr	-818(ra) # 8000053a <panic>

0000000080003874 <balloc>:
{
    80003874:	711d                	addi	sp,sp,-96
    80003876:	ec86                	sd	ra,88(sp)
    80003878:	e8a2                	sd	s0,80(sp)
    8000387a:	e4a6                	sd	s1,72(sp)
    8000387c:	e0ca                	sd	s2,64(sp)
    8000387e:	fc4e                	sd	s3,56(sp)
    80003880:	f852                	sd	s4,48(sp)
    80003882:	f456                	sd	s5,40(sp)
    80003884:	f05a                	sd	s6,32(sp)
    80003886:	ec5e                	sd	s7,24(sp)
    80003888:	e862                	sd	s8,16(sp)
    8000388a:	e466                	sd	s9,8(sp)
    8000388c:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000388e:	0001f797          	auipc	a5,0x1f
    80003892:	9467a783          	lw	a5,-1722(a5) # 800221d4 <sb+0x4>
    80003896:	cbc1                	beqz	a5,80003926 <balloc+0xb2>
    80003898:	8baa                	mv	s7,a0
    8000389a:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000389c:	0001fb17          	auipc	s6,0x1f
    800038a0:	934b0b13          	addi	s6,s6,-1740 # 800221d0 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800038a4:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800038a6:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800038a8:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800038aa:	6c89                	lui	s9,0x2
    800038ac:	a831                	j	800038c8 <balloc+0x54>
    brelse(bp);
    800038ae:	854a                	mv	a0,s2
    800038b0:	00000097          	auipc	ra,0x0
    800038b4:	e32080e7          	jalr	-462(ra) # 800036e2 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800038b8:	015c87bb          	addw	a5,s9,s5
    800038bc:	00078a9b          	sext.w	s5,a5
    800038c0:	004b2703          	lw	a4,4(s6)
    800038c4:	06eaf163          	bgeu	s5,a4,80003926 <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    800038c8:	41fad79b          	sraiw	a5,s5,0x1f
    800038cc:	0137d79b          	srliw	a5,a5,0x13
    800038d0:	015787bb          	addw	a5,a5,s5
    800038d4:	40d7d79b          	sraiw	a5,a5,0xd
    800038d8:	01cb2583          	lw	a1,28(s6)
    800038dc:	9dbd                	addw	a1,a1,a5
    800038de:	855e                	mv	a0,s7
    800038e0:	00000097          	auipc	ra,0x0
    800038e4:	cd2080e7          	jalr	-814(ra) # 800035b2 <bread>
    800038e8:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800038ea:	004b2503          	lw	a0,4(s6)
    800038ee:	000a849b          	sext.w	s1,s5
    800038f2:	8762                	mv	a4,s8
    800038f4:	faa4fde3          	bgeu	s1,a0,800038ae <balloc+0x3a>
      m = 1 << (bi % 8);
    800038f8:	00777693          	andi	a3,a4,7
    800038fc:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003900:	41f7579b          	sraiw	a5,a4,0x1f
    80003904:	01d7d79b          	srliw	a5,a5,0x1d
    80003908:	9fb9                	addw	a5,a5,a4
    8000390a:	4037d79b          	sraiw	a5,a5,0x3
    8000390e:	00f90633          	add	a2,s2,a5
    80003912:	05864603          	lbu	a2,88(a2)
    80003916:	00c6f5b3          	and	a1,a3,a2
    8000391a:	cd91                	beqz	a1,80003936 <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000391c:	2705                	addiw	a4,a4,1
    8000391e:	2485                	addiw	s1,s1,1
    80003920:	fd471ae3          	bne	a4,s4,800038f4 <balloc+0x80>
    80003924:	b769                	j	800038ae <balloc+0x3a>
  panic("balloc: out of blocks");
    80003926:	00005517          	auipc	a0,0x5
    8000392a:	d6a50513          	addi	a0,a0,-662 # 80008690 <syscalls+0x118>
    8000392e:	ffffd097          	auipc	ra,0xffffd
    80003932:	c0c080e7          	jalr	-1012(ra) # 8000053a <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003936:	97ca                	add	a5,a5,s2
    80003938:	8e55                	or	a2,a2,a3
    8000393a:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000393e:	854a                	mv	a0,s2
    80003940:	00001097          	auipc	ra,0x1
    80003944:	026080e7          	jalr	38(ra) # 80004966 <log_write>
        brelse(bp);
    80003948:	854a                	mv	a0,s2
    8000394a:	00000097          	auipc	ra,0x0
    8000394e:	d98080e7          	jalr	-616(ra) # 800036e2 <brelse>
  bp = bread(dev, bno);
    80003952:	85a6                	mv	a1,s1
    80003954:	855e                	mv	a0,s7
    80003956:	00000097          	auipc	ra,0x0
    8000395a:	c5c080e7          	jalr	-932(ra) # 800035b2 <bread>
    8000395e:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003960:	40000613          	li	a2,1024
    80003964:	4581                	li	a1,0
    80003966:	05850513          	addi	a0,a0,88
    8000396a:	ffffd097          	auipc	ra,0xffffd
    8000396e:	362080e7          	jalr	866(ra) # 80000ccc <memset>
  log_write(bp);
    80003972:	854a                	mv	a0,s2
    80003974:	00001097          	auipc	ra,0x1
    80003978:	ff2080e7          	jalr	-14(ra) # 80004966 <log_write>
  brelse(bp);
    8000397c:	854a                	mv	a0,s2
    8000397e:	00000097          	auipc	ra,0x0
    80003982:	d64080e7          	jalr	-668(ra) # 800036e2 <brelse>
}
    80003986:	8526                	mv	a0,s1
    80003988:	60e6                	ld	ra,88(sp)
    8000398a:	6446                	ld	s0,80(sp)
    8000398c:	64a6                	ld	s1,72(sp)
    8000398e:	6906                	ld	s2,64(sp)
    80003990:	79e2                	ld	s3,56(sp)
    80003992:	7a42                	ld	s4,48(sp)
    80003994:	7aa2                	ld	s5,40(sp)
    80003996:	7b02                	ld	s6,32(sp)
    80003998:	6be2                	ld	s7,24(sp)
    8000399a:	6c42                	ld	s8,16(sp)
    8000399c:	6ca2                	ld	s9,8(sp)
    8000399e:	6125                	addi	sp,sp,96
    800039a0:	8082                	ret

00000000800039a2 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800039a2:	7179                	addi	sp,sp,-48
    800039a4:	f406                	sd	ra,40(sp)
    800039a6:	f022                	sd	s0,32(sp)
    800039a8:	ec26                	sd	s1,24(sp)
    800039aa:	e84a                	sd	s2,16(sp)
    800039ac:	e44e                	sd	s3,8(sp)
    800039ae:	e052                	sd	s4,0(sp)
    800039b0:	1800                	addi	s0,sp,48
    800039b2:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800039b4:	47ad                	li	a5,11
    800039b6:	04b7fe63          	bgeu	a5,a1,80003a12 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800039ba:	ff45849b          	addiw	s1,a1,-12
    800039be:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800039c2:	0ff00793          	li	a5,255
    800039c6:	0ae7e463          	bltu	a5,a4,80003a6e <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800039ca:	08052583          	lw	a1,128(a0)
    800039ce:	c5b5                	beqz	a1,80003a3a <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800039d0:	00092503          	lw	a0,0(s2)
    800039d4:	00000097          	auipc	ra,0x0
    800039d8:	bde080e7          	jalr	-1058(ra) # 800035b2 <bread>
    800039dc:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800039de:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800039e2:	02049713          	slli	a4,s1,0x20
    800039e6:	01e75593          	srli	a1,a4,0x1e
    800039ea:	00b784b3          	add	s1,a5,a1
    800039ee:	0004a983          	lw	s3,0(s1)
    800039f2:	04098e63          	beqz	s3,80003a4e <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800039f6:	8552                	mv	a0,s4
    800039f8:	00000097          	auipc	ra,0x0
    800039fc:	cea080e7          	jalr	-790(ra) # 800036e2 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003a00:	854e                	mv	a0,s3
    80003a02:	70a2                	ld	ra,40(sp)
    80003a04:	7402                	ld	s0,32(sp)
    80003a06:	64e2                	ld	s1,24(sp)
    80003a08:	6942                	ld	s2,16(sp)
    80003a0a:	69a2                	ld	s3,8(sp)
    80003a0c:	6a02                	ld	s4,0(sp)
    80003a0e:	6145                	addi	sp,sp,48
    80003a10:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80003a12:	02059793          	slli	a5,a1,0x20
    80003a16:	01e7d593          	srli	a1,a5,0x1e
    80003a1a:	00b504b3          	add	s1,a0,a1
    80003a1e:	0504a983          	lw	s3,80(s1)
    80003a22:	fc099fe3          	bnez	s3,80003a00 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80003a26:	4108                	lw	a0,0(a0)
    80003a28:	00000097          	auipc	ra,0x0
    80003a2c:	e4c080e7          	jalr	-436(ra) # 80003874 <balloc>
    80003a30:	0005099b          	sext.w	s3,a0
    80003a34:	0534a823          	sw	s3,80(s1)
    80003a38:	b7e1                	j	80003a00 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80003a3a:	4108                	lw	a0,0(a0)
    80003a3c:	00000097          	auipc	ra,0x0
    80003a40:	e38080e7          	jalr	-456(ra) # 80003874 <balloc>
    80003a44:	0005059b          	sext.w	a1,a0
    80003a48:	08b92023          	sw	a1,128(s2)
    80003a4c:	b751                	j	800039d0 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80003a4e:	00092503          	lw	a0,0(s2)
    80003a52:	00000097          	auipc	ra,0x0
    80003a56:	e22080e7          	jalr	-478(ra) # 80003874 <balloc>
    80003a5a:	0005099b          	sext.w	s3,a0
    80003a5e:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80003a62:	8552                	mv	a0,s4
    80003a64:	00001097          	auipc	ra,0x1
    80003a68:	f02080e7          	jalr	-254(ra) # 80004966 <log_write>
    80003a6c:	b769                	j	800039f6 <bmap+0x54>
  panic("bmap: out of range");
    80003a6e:	00005517          	auipc	a0,0x5
    80003a72:	c3a50513          	addi	a0,a0,-966 # 800086a8 <syscalls+0x130>
    80003a76:	ffffd097          	auipc	ra,0xffffd
    80003a7a:	ac4080e7          	jalr	-1340(ra) # 8000053a <panic>

0000000080003a7e <iget>:
{
    80003a7e:	7179                	addi	sp,sp,-48
    80003a80:	f406                	sd	ra,40(sp)
    80003a82:	f022                	sd	s0,32(sp)
    80003a84:	ec26                	sd	s1,24(sp)
    80003a86:	e84a                	sd	s2,16(sp)
    80003a88:	e44e                	sd	s3,8(sp)
    80003a8a:	e052                	sd	s4,0(sp)
    80003a8c:	1800                	addi	s0,sp,48
    80003a8e:	89aa                	mv	s3,a0
    80003a90:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003a92:	0001e517          	auipc	a0,0x1e
    80003a96:	75e50513          	addi	a0,a0,1886 # 800221f0 <itable>
    80003a9a:	ffffd097          	auipc	ra,0xffffd
    80003a9e:	136080e7          	jalr	310(ra) # 80000bd0 <acquire>
  empty = 0;
    80003aa2:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003aa4:	0001e497          	auipc	s1,0x1e
    80003aa8:	76448493          	addi	s1,s1,1892 # 80022208 <itable+0x18>
    80003aac:	00020697          	auipc	a3,0x20
    80003ab0:	1ec68693          	addi	a3,a3,492 # 80023c98 <log>
    80003ab4:	a039                	j	80003ac2 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003ab6:	02090b63          	beqz	s2,80003aec <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003aba:	08848493          	addi	s1,s1,136
    80003abe:	02d48a63          	beq	s1,a3,80003af2 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003ac2:	449c                	lw	a5,8(s1)
    80003ac4:	fef059e3          	blez	a5,80003ab6 <iget+0x38>
    80003ac8:	4098                	lw	a4,0(s1)
    80003aca:	ff3716e3          	bne	a4,s3,80003ab6 <iget+0x38>
    80003ace:	40d8                	lw	a4,4(s1)
    80003ad0:	ff4713e3          	bne	a4,s4,80003ab6 <iget+0x38>
      ip->ref++;
    80003ad4:	2785                	addiw	a5,a5,1
    80003ad6:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003ad8:	0001e517          	auipc	a0,0x1e
    80003adc:	71850513          	addi	a0,a0,1816 # 800221f0 <itable>
    80003ae0:	ffffd097          	auipc	ra,0xffffd
    80003ae4:	1a4080e7          	jalr	420(ra) # 80000c84 <release>
      return ip;
    80003ae8:	8926                	mv	s2,s1
    80003aea:	a03d                	j	80003b18 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003aec:	f7f9                	bnez	a5,80003aba <iget+0x3c>
    80003aee:	8926                	mv	s2,s1
    80003af0:	b7e9                	j	80003aba <iget+0x3c>
  if(empty == 0)
    80003af2:	02090c63          	beqz	s2,80003b2a <iget+0xac>
  ip->dev = dev;
    80003af6:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003afa:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003afe:	4785                	li	a5,1
    80003b00:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003b04:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003b08:	0001e517          	auipc	a0,0x1e
    80003b0c:	6e850513          	addi	a0,a0,1768 # 800221f0 <itable>
    80003b10:	ffffd097          	auipc	ra,0xffffd
    80003b14:	174080e7          	jalr	372(ra) # 80000c84 <release>
}
    80003b18:	854a                	mv	a0,s2
    80003b1a:	70a2                	ld	ra,40(sp)
    80003b1c:	7402                	ld	s0,32(sp)
    80003b1e:	64e2                	ld	s1,24(sp)
    80003b20:	6942                	ld	s2,16(sp)
    80003b22:	69a2                	ld	s3,8(sp)
    80003b24:	6a02                	ld	s4,0(sp)
    80003b26:	6145                	addi	sp,sp,48
    80003b28:	8082                	ret
    panic("iget: no inodes");
    80003b2a:	00005517          	auipc	a0,0x5
    80003b2e:	b9650513          	addi	a0,a0,-1130 # 800086c0 <syscalls+0x148>
    80003b32:	ffffd097          	auipc	ra,0xffffd
    80003b36:	a08080e7          	jalr	-1528(ra) # 8000053a <panic>

0000000080003b3a <fsinit>:
fsinit(int dev) {
    80003b3a:	7179                	addi	sp,sp,-48
    80003b3c:	f406                	sd	ra,40(sp)
    80003b3e:	f022                	sd	s0,32(sp)
    80003b40:	ec26                	sd	s1,24(sp)
    80003b42:	e84a                	sd	s2,16(sp)
    80003b44:	e44e                	sd	s3,8(sp)
    80003b46:	1800                	addi	s0,sp,48
    80003b48:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003b4a:	4585                	li	a1,1
    80003b4c:	00000097          	auipc	ra,0x0
    80003b50:	a66080e7          	jalr	-1434(ra) # 800035b2 <bread>
    80003b54:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003b56:	0001e997          	auipc	s3,0x1e
    80003b5a:	67a98993          	addi	s3,s3,1658 # 800221d0 <sb>
    80003b5e:	02000613          	li	a2,32
    80003b62:	05850593          	addi	a1,a0,88
    80003b66:	854e                	mv	a0,s3
    80003b68:	ffffd097          	auipc	ra,0xffffd
    80003b6c:	1c0080e7          	jalr	448(ra) # 80000d28 <memmove>
  brelse(bp);
    80003b70:	8526                	mv	a0,s1
    80003b72:	00000097          	auipc	ra,0x0
    80003b76:	b70080e7          	jalr	-1168(ra) # 800036e2 <brelse>
  if(sb.magic != FSMAGIC)
    80003b7a:	0009a703          	lw	a4,0(s3)
    80003b7e:	102037b7          	lui	a5,0x10203
    80003b82:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003b86:	02f71263          	bne	a4,a5,80003baa <fsinit+0x70>
  initlog(dev, &sb);
    80003b8a:	0001e597          	auipc	a1,0x1e
    80003b8e:	64658593          	addi	a1,a1,1606 # 800221d0 <sb>
    80003b92:	854a                	mv	a0,s2
    80003b94:	00001097          	auipc	ra,0x1
    80003b98:	b56080e7          	jalr	-1194(ra) # 800046ea <initlog>
}
    80003b9c:	70a2                	ld	ra,40(sp)
    80003b9e:	7402                	ld	s0,32(sp)
    80003ba0:	64e2                	ld	s1,24(sp)
    80003ba2:	6942                	ld	s2,16(sp)
    80003ba4:	69a2                	ld	s3,8(sp)
    80003ba6:	6145                	addi	sp,sp,48
    80003ba8:	8082                	ret
    panic("invalid file system");
    80003baa:	00005517          	auipc	a0,0x5
    80003bae:	b2650513          	addi	a0,a0,-1242 # 800086d0 <syscalls+0x158>
    80003bb2:	ffffd097          	auipc	ra,0xffffd
    80003bb6:	988080e7          	jalr	-1656(ra) # 8000053a <panic>

0000000080003bba <iinit>:
{
    80003bba:	7179                	addi	sp,sp,-48
    80003bbc:	f406                	sd	ra,40(sp)
    80003bbe:	f022                	sd	s0,32(sp)
    80003bc0:	ec26                	sd	s1,24(sp)
    80003bc2:	e84a                	sd	s2,16(sp)
    80003bc4:	e44e                	sd	s3,8(sp)
    80003bc6:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003bc8:	00005597          	auipc	a1,0x5
    80003bcc:	b2058593          	addi	a1,a1,-1248 # 800086e8 <syscalls+0x170>
    80003bd0:	0001e517          	auipc	a0,0x1e
    80003bd4:	62050513          	addi	a0,a0,1568 # 800221f0 <itable>
    80003bd8:	ffffd097          	auipc	ra,0xffffd
    80003bdc:	f68080e7          	jalr	-152(ra) # 80000b40 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003be0:	0001e497          	auipc	s1,0x1e
    80003be4:	63848493          	addi	s1,s1,1592 # 80022218 <itable+0x28>
    80003be8:	00020997          	auipc	s3,0x20
    80003bec:	0c098993          	addi	s3,s3,192 # 80023ca8 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003bf0:	00005917          	auipc	s2,0x5
    80003bf4:	b0090913          	addi	s2,s2,-1280 # 800086f0 <syscalls+0x178>
    80003bf8:	85ca                	mv	a1,s2
    80003bfa:	8526                	mv	a0,s1
    80003bfc:	00001097          	auipc	ra,0x1
    80003c00:	e4e080e7          	jalr	-434(ra) # 80004a4a <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003c04:	08848493          	addi	s1,s1,136
    80003c08:	ff3498e3          	bne	s1,s3,80003bf8 <iinit+0x3e>
}
    80003c0c:	70a2                	ld	ra,40(sp)
    80003c0e:	7402                	ld	s0,32(sp)
    80003c10:	64e2                	ld	s1,24(sp)
    80003c12:	6942                	ld	s2,16(sp)
    80003c14:	69a2                	ld	s3,8(sp)
    80003c16:	6145                	addi	sp,sp,48
    80003c18:	8082                	ret

0000000080003c1a <ialloc>:
{
    80003c1a:	715d                	addi	sp,sp,-80
    80003c1c:	e486                	sd	ra,72(sp)
    80003c1e:	e0a2                	sd	s0,64(sp)
    80003c20:	fc26                	sd	s1,56(sp)
    80003c22:	f84a                	sd	s2,48(sp)
    80003c24:	f44e                	sd	s3,40(sp)
    80003c26:	f052                	sd	s4,32(sp)
    80003c28:	ec56                	sd	s5,24(sp)
    80003c2a:	e85a                	sd	s6,16(sp)
    80003c2c:	e45e                	sd	s7,8(sp)
    80003c2e:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003c30:	0001e717          	auipc	a4,0x1e
    80003c34:	5ac72703          	lw	a4,1452(a4) # 800221dc <sb+0xc>
    80003c38:	4785                	li	a5,1
    80003c3a:	04e7fa63          	bgeu	a5,a4,80003c8e <ialloc+0x74>
    80003c3e:	8aaa                	mv	s5,a0
    80003c40:	8bae                	mv	s7,a1
    80003c42:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003c44:	0001ea17          	auipc	s4,0x1e
    80003c48:	58ca0a13          	addi	s4,s4,1420 # 800221d0 <sb>
    80003c4c:	00048b1b          	sext.w	s6,s1
    80003c50:	0044d593          	srli	a1,s1,0x4
    80003c54:	018a2783          	lw	a5,24(s4)
    80003c58:	9dbd                	addw	a1,a1,a5
    80003c5a:	8556                	mv	a0,s5
    80003c5c:	00000097          	auipc	ra,0x0
    80003c60:	956080e7          	jalr	-1706(ra) # 800035b2 <bread>
    80003c64:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003c66:	05850993          	addi	s3,a0,88
    80003c6a:	00f4f793          	andi	a5,s1,15
    80003c6e:	079a                	slli	a5,a5,0x6
    80003c70:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003c72:	00099783          	lh	a5,0(s3)
    80003c76:	c785                	beqz	a5,80003c9e <ialloc+0x84>
    brelse(bp);
    80003c78:	00000097          	auipc	ra,0x0
    80003c7c:	a6a080e7          	jalr	-1430(ra) # 800036e2 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003c80:	0485                	addi	s1,s1,1
    80003c82:	00ca2703          	lw	a4,12(s4)
    80003c86:	0004879b          	sext.w	a5,s1
    80003c8a:	fce7e1e3          	bltu	a5,a4,80003c4c <ialloc+0x32>
  panic("ialloc: no inodes");
    80003c8e:	00005517          	auipc	a0,0x5
    80003c92:	a6a50513          	addi	a0,a0,-1430 # 800086f8 <syscalls+0x180>
    80003c96:	ffffd097          	auipc	ra,0xffffd
    80003c9a:	8a4080e7          	jalr	-1884(ra) # 8000053a <panic>
      memset(dip, 0, sizeof(*dip));
    80003c9e:	04000613          	li	a2,64
    80003ca2:	4581                	li	a1,0
    80003ca4:	854e                	mv	a0,s3
    80003ca6:	ffffd097          	auipc	ra,0xffffd
    80003caa:	026080e7          	jalr	38(ra) # 80000ccc <memset>
      dip->type = type;
    80003cae:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003cb2:	854a                	mv	a0,s2
    80003cb4:	00001097          	auipc	ra,0x1
    80003cb8:	cb2080e7          	jalr	-846(ra) # 80004966 <log_write>
      brelse(bp);
    80003cbc:	854a                	mv	a0,s2
    80003cbe:	00000097          	auipc	ra,0x0
    80003cc2:	a24080e7          	jalr	-1500(ra) # 800036e2 <brelse>
      return iget(dev, inum);
    80003cc6:	85da                	mv	a1,s6
    80003cc8:	8556                	mv	a0,s5
    80003cca:	00000097          	auipc	ra,0x0
    80003cce:	db4080e7          	jalr	-588(ra) # 80003a7e <iget>
}
    80003cd2:	60a6                	ld	ra,72(sp)
    80003cd4:	6406                	ld	s0,64(sp)
    80003cd6:	74e2                	ld	s1,56(sp)
    80003cd8:	7942                	ld	s2,48(sp)
    80003cda:	79a2                	ld	s3,40(sp)
    80003cdc:	7a02                	ld	s4,32(sp)
    80003cde:	6ae2                	ld	s5,24(sp)
    80003ce0:	6b42                	ld	s6,16(sp)
    80003ce2:	6ba2                	ld	s7,8(sp)
    80003ce4:	6161                	addi	sp,sp,80
    80003ce6:	8082                	ret

0000000080003ce8 <iupdate>:
{
    80003ce8:	1101                	addi	sp,sp,-32
    80003cea:	ec06                	sd	ra,24(sp)
    80003cec:	e822                	sd	s0,16(sp)
    80003cee:	e426                	sd	s1,8(sp)
    80003cf0:	e04a                	sd	s2,0(sp)
    80003cf2:	1000                	addi	s0,sp,32
    80003cf4:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003cf6:	415c                	lw	a5,4(a0)
    80003cf8:	0047d79b          	srliw	a5,a5,0x4
    80003cfc:	0001e597          	auipc	a1,0x1e
    80003d00:	4ec5a583          	lw	a1,1260(a1) # 800221e8 <sb+0x18>
    80003d04:	9dbd                	addw	a1,a1,a5
    80003d06:	4108                	lw	a0,0(a0)
    80003d08:	00000097          	auipc	ra,0x0
    80003d0c:	8aa080e7          	jalr	-1878(ra) # 800035b2 <bread>
    80003d10:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003d12:	05850793          	addi	a5,a0,88
    80003d16:	40d8                	lw	a4,4(s1)
    80003d18:	8b3d                	andi	a4,a4,15
    80003d1a:	071a                	slli	a4,a4,0x6
    80003d1c:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003d1e:	04449703          	lh	a4,68(s1)
    80003d22:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003d26:	04649703          	lh	a4,70(s1)
    80003d2a:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003d2e:	04849703          	lh	a4,72(s1)
    80003d32:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003d36:	04a49703          	lh	a4,74(s1)
    80003d3a:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003d3e:	44f8                	lw	a4,76(s1)
    80003d40:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003d42:	03400613          	li	a2,52
    80003d46:	05048593          	addi	a1,s1,80
    80003d4a:	00c78513          	addi	a0,a5,12
    80003d4e:	ffffd097          	auipc	ra,0xffffd
    80003d52:	fda080e7          	jalr	-38(ra) # 80000d28 <memmove>
  log_write(bp);
    80003d56:	854a                	mv	a0,s2
    80003d58:	00001097          	auipc	ra,0x1
    80003d5c:	c0e080e7          	jalr	-1010(ra) # 80004966 <log_write>
  brelse(bp);
    80003d60:	854a                	mv	a0,s2
    80003d62:	00000097          	auipc	ra,0x0
    80003d66:	980080e7          	jalr	-1664(ra) # 800036e2 <brelse>
}
    80003d6a:	60e2                	ld	ra,24(sp)
    80003d6c:	6442                	ld	s0,16(sp)
    80003d6e:	64a2                	ld	s1,8(sp)
    80003d70:	6902                	ld	s2,0(sp)
    80003d72:	6105                	addi	sp,sp,32
    80003d74:	8082                	ret

0000000080003d76 <idup>:
{
    80003d76:	1101                	addi	sp,sp,-32
    80003d78:	ec06                	sd	ra,24(sp)
    80003d7a:	e822                	sd	s0,16(sp)
    80003d7c:	e426                	sd	s1,8(sp)
    80003d7e:	1000                	addi	s0,sp,32
    80003d80:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003d82:	0001e517          	auipc	a0,0x1e
    80003d86:	46e50513          	addi	a0,a0,1134 # 800221f0 <itable>
    80003d8a:	ffffd097          	auipc	ra,0xffffd
    80003d8e:	e46080e7          	jalr	-442(ra) # 80000bd0 <acquire>
  ip->ref++;
    80003d92:	449c                	lw	a5,8(s1)
    80003d94:	2785                	addiw	a5,a5,1
    80003d96:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003d98:	0001e517          	auipc	a0,0x1e
    80003d9c:	45850513          	addi	a0,a0,1112 # 800221f0 <itable>
    80003da0:	ffffd097          	auipc	ra,0xffffd
    80003da4:	ee4080e7          	jalr	-284(ra) # 80000c84 <release>
}
    80003da8:	8526                	mv	a0,s1
    80003daa:	60e2                	ld	ra,24(sp)
    80003dac:	6442                	ld	s0,16(sp)
    80003dae:	64a2                	ld	s1,8(sp)
    80003db0:	6105                	addi	sp,sp,32
    80003db2:	8082                	ret

0000000080003db4 <ilock>:
{
    80003db4:	1101                	addi	sp,sp,-32
    80003db6:	ec06                	sd	ra,24(sp)
    80003db8:	e822                	sd	s0,16(sp)
    80003dba:	e426                	sd	s1,8(sp)
    80003dbc:	e04a                	sd	s2,0(sp)
    80003dbe:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003dc0:	c115                	beqz	a0,80003de4 <ilock+0x30>
    80003dc2:	84aa                	mv	s1,a0
    80003dc4:	451c                	lw	a5,8(a0)
    80003dc6:	00f05f63          	blez	a5,80003de4 <ilock+0x30>
  acquiresleep(&ip->lock);
    80003dca:	0541                	addi	a0,a0,16
    80003dcc:	00001097          	auipc	ra,0x1
    80003dd0:	cb8080e7          	jalr	-840(ra) # 80004a84 <acquiresleep>
  if(ip->valid == 0){
    80003dd4:	40bc                	lw	a5,64(s1)
    80003dd6:	cf99                	beqz	a5,80003df4 <ilock+0x40>
}
    80003dd8:	60e2                	ld	ra,24(sp)
    80003dda:	6442                	ld	s0,16(sp)
    80003ddc:	64a2                	ld	s1,8(sp)
    80003dde:	6902                	ld	s2,0(sp)
    80003de0:	6105                	addi	sp,sp,32
    80003de2:	8082                	ret
    panic("ilock");
    80003de4:	00005517          	auipc	a0,0x5
    80003de8:	92c50513          	addi	a0,a0,-1748 # 80008710 <syscalls+0x198>
    80003dec:	ffffc097          	auipc	ra,0xffffc
    80003df0:	74e080e7          	jalr	1870(ra) # 8000053a <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003df4:	40dc                	lw	a5,4(s1)
    80003df6:	0047d79b          	srliw	a5,a5,0x4
    80003dfa:	0001e597          	auipc	a1,0x1e
    80003dfe:	3ee5a583          	lw	a1,1006(a1) # 800221e8 <sb+0x18>
    80003e02:	9dbd                	addw	a1,a1,a5
    80003e04:	4088                	lw	a0,0(s1)
    80003e06:	fffff097          	auipc	ra,0xfffff
    80003e0a:	7ac080e7          	jalr	1964(ra) # 800035b2 <bread>
    80003e0e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003e10:	05850593          	addi	a1,a0,88
    80003e14:	40dc                	lw	a5,4(s1)
    80003e16:	8bbd                	andi	a5,a5,15
    80003e18:	079a                	slli	a5,a5,0x6
    80003e1a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003e1c:	00059783          	lh	a5,0(a1)
    80003e20:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003e24:	00259783          	lh	a5,2(a1)
    80003e28:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003e2c:	00459783          	lh	a5,4(a1)
    80003e30:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003e34:	00659783          	lh	a5,6(a1)
    80003e38:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003e3c:	459c                	lw	a5,8(a1)
    80003e3e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003e40:	03400613          	li	a2,52
    80003e44:	05b1                	addi	a1,a1,12
    80003e46:	05048513          	addi	a0,s1,80
    80003e4a:	ffffd097          	auipc	ra,0xffffd
    80003e4e:	ede080e7          	jalr	-290(ra) # 80000d28 <memmove>
    brelse(bp);
    80003e52:	854a                	mv	a0,s2
    80003e54:	00000097          	auipc	ra,0x0
    80003e58:	88e080e7          	jalr	-1906(ra) # 800036e2 <brelse>
    ip->valid = 1;
    80003e5c:	4785                	li	a5,1
    80003e5e:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003e60:	04449783          	lh	a5,68(s1)
    80003e64:	fbb5                	bnez	a5,80003dd8 <ilock+0x24>
      panic("ilock: no type");
    80003e66:	00005517          	auipc	a0,0x5
    80003e6a:	8b250513          	addi	a0,a0,-1870 # 80008718 <syscalls+0x1a0>
    80003e6e:	ffffc097          	auipc	ra,0xffffc
    80003e72:	6cc080e7          	jalr	1740(ra) # 8000053a <panic>

0000000080003e76 <iunlock>:
{
    80003e76:	1101                	addi	sp,sp,-32
    80003e78:	ec06                	sd	ra,24(sp)
    80003e7a:	e822                	sd	s0,16(sp)
    80003e7c:	e426                	sd	s1,8(sp)
    80003e7e:	e04a                	sd	s2,0(sp)
    80003e80:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003e82:	c905                	beqz	a0,80003eb2 <iunlock+0x3c>
    80003e84:	84aa                	mv	s1,a0
    80003e86:	01050913          	addi	s2,a0,16
    80003e8a:	854a                	mv	a0,s2
    80003e8c:	00001097          	auipc	ra,0x1
    80003e90:	c92080e7          	jalr	-878(ra) # 80004b1e <holdingsleep>
    80003e94:	cd19                	beqz	a0,80003eb2 <iunlock+0x3c>
    80003e96:	449c                	lw	a5,8(s1)
    80003e98:	00f05d63          	blez	a5,80003eb2 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003e9c:	854a                	mv	a0,s2
    80003e9e:	00001097          	auipc	ra,0x1
    80003ea2:	c3c080e7          	jalr	-964(ra) # 80004ada <releasesleep>
}
    80003ea6:	60e2                	ld	ra,24(sp)
    80003ea8:	6442                	ld	s0,16(sp)
    80003eaa:	64a2                	ld	s1,8(sp)
    80003eac:	6902                	ld	s2,0(sp)
    80003eae:	6105                	addi	sp,sp,32
    80003eb0:	8082                	ret
    panic("iunlock");
    80003eb2:	00005517          	auipc	a0,0x5
    80003eb6:	87650513          	addi	a0,a0,-1930 # 80008728 <syscalls+0x1b0>
    80003eba:	ffffc097          	auipc	ra,0xffffc
    80003ebe:	680080e7          	jalr	1664(ra) # 8000053a <panic>

0000000080003ec2 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003ec2:	7179                	addi	sp,sp,-48
    80003ec4:	f406                	sd	ra,40(sp)
    80003ec6:	f022                	sd	s0,32(sp)
    80003ec8:	ec26                	sd	s1,24(sp)
    80003eca:	e84a                	sd	s2,16(sp)
    80003ecc:	e44e                	sd	s3,8(sp)
    80003ece:	e052                	sd	s4,0(sp)
    80003ed0:	1800                	addi	s0,sp,48
    80003ed2:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003ed4:	05050493          	addi	s1,a0,80
    80003ed8:	08050913          	addi	s2,a0,128
    80003edc:	a021                	j	80003ee4 <itrunc+0x22>
    80003ede:	0491                	addi	s1,s1,4
    80003ee0:	01248d63          	beq	s1,s2,80003efa <itrunc+0x38>
    if(ip->addrs[i]){
    80003ee4:	408c                	lw	a1,0(s1)
    80003ee6:	dde5                	beqz	a1,80003ede <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003ee8:	0009a503          	lw	a0,0(s3)
    80003eec:	00000097          	auipc	ra,0x0
    80003ef0:	90c080e7          	jalr	-1780(ra) # 800037f8 <bfree>
      ip->addrs[i] = 0;
    80003ef4:	0004a023          	sw	zero,0(s1)
    80003ef8:	b7dd                	j	80003ede <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003efa:	0809a583          	lw	a1,128(s3)
    80003efe:	e185                	bnez	a1,80003f1e <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003f00:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003f04:	854e                	mv	a0,s3
    80003f06:	00000097          	auipc	ra,0x0
    80003f0a:	de2080e7          	jalr	-542(ra) # 80003ce8 <iupdate>
}
    80003f0e:	70a2                	ld	ra,40(sp)
    80003f10:	7402                	ld	s0,32(sp)
    80003f12:	64e2                	ld	s1,24(sp)
    80003f14:	6942                	ld	s2,16(sp)
    80003f16:	69a2                	ld	s3,8(sp)
    80003f18:	6a02                	ld	s4,0(sp)
    80003f1a:	6145                	addi	sp,sp,48
    80003f1c:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003f1e:	0009a503          	lw	a0,0(s3)
    80003f22:	fffff097          	auipc	ra,0xfffff
    80003f26:	690080e7          	jalr	1680(ra) # 800035b2 <bread>
    80003f2a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003f2c:	05850493          	addi	s1,a0,88
    80003f30:	45850913          	addi	s2,a0,1112
    80003f34:	a021                	j	80003f3c <itrunc+0x7a>
    80003f36:	0491                	addi	s1,s1,4
    80003f38:	01248b63          	beq	s1,s2,80003f4e <itrunc+0x8c>
      if(a[j])
    80003f3c:	408c                	lw	a1,0(s1)
    80003f3e:	dde5                	beqz	a1,80003f36 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003f40:	0009a503          	lw	a0,0(s3)
    80003f44:	00000097          	auipc	ra,0x0
    80003f48:	8b4080e7          	jalr	-1868(ra) # 800037f8 <bfree>
    80003f4c:	b7ed                	j	80003f36 <itrunc+0x74>
    brelse(bp);
    80003f4e:	8552                	mv	a0,s4
    80003f50:	fffff097          	auipc	ra,0xfffff
    80003f54:	792080e7          	jalr	1938(ra) # 800036e2 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003f58:	0809a583          	lw	a1,128(s3)
    80003f5c:	0009a503          	lw	a0,0(s3)
    80003f60:	00000097          	auipc	ra,0x0
    80003f64:	898080e7          	jalr	-1896(ra) # 800037f8 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003f68:	0809a023          	sw	zero,128(s3)
    80003f6c:	bf51                	j	80003f00 <itrunc+0x3e>

0000000080003f6e <iput>:
{
    80003f6e:	1101                	addi	sp,sp,-32
    80003f70:	ec06                	sd	ra,24(sp)
    80003f72:	e822                	sd	s0,16(sp)
    80003f74:	e426                	sd	s1,8(sp)
    80003f76:	e04a                	sd	s2,0(sp)
    80003f78:	1000                	addi	s0,sp,32
    80003f7a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003f7c:	0001e517          	auipc	a0,0x1e
    80003f80:	27450513          	addi	a0,a0,628 # 800221f0 <itable>
    80003f84:	ffffd097          	auipc	ra,0xffffd
    80003f88:	c4c080e7          	jalr	-948(ra) # 80000bd0 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003f8c:	4498                	lw	a4,8(s1)
    80003f8e:	4785                	li	a5,1
    80003f90:	02f70363          	beq	a4,a5,80003fb6 <iput+0x48>
  ip->ref--;
    80003f94:	449c                	lw	a5,8(s1)
    80003f96:	37fd                	addiw	a5,a5,-1
    80003f98:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003f9a:	0001e517          	auipc	a0,0x1e
    80003f9e:	25650513          	addi	a0,a0,598 # 800221f0 <itable>
    80003fa2:	ffffd097          	auipc	ra,0xffffd
    80003fa6:	ce2080e7          	jalr	-798(ra) # 80000c84 <release>
}
    80003faa:	60e2                	ld	ra,24(sp)
    80003fac:	6442                	ld	s0,16(sp)
    80003fae:	64a2                	ld	s1,8(sp)
    80003fb0:	6902                	ld	s2,0(sp)
    80003fb2:	6105                	addi	sp,sp,32
    80003fb4:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003fb6:	40bc                	lw	a5,64(s1)
    80003fb8:	dff1                	beqz	a5,80003f94 <iput+0x26>
    80003fba:	04a49783          	lh	a5,74(s1)
    80003fbe:	fbf9                	bnez	a5,80003f94 <iput+0x26>
    acquiresleep(&ip->lock);
    80003fc0:	01048913          	addi	s2,s1,16
    80003fc4:	854a                	mv	a0,s2
    80003fc6:	00001097          	auipc	ra,0x1
    80003fca:	abe080e7          	jalr	-1346(ra) # 80004a84 <acquiresleep>
    release(&itable.lock);
    80003fce:	0001e517          	auipc	a0,0x1e
    80003fd2:	22250513          	addi	a0,a0,546 # 800221f0 <itable>
    80003fd6:	ffffd097          	auipc	ra,0xffffd
    80003fda:	cae080e7          	jalr	-850(ra) # 80000c84 <release>
    itrunc(ip);
    80003fde:	8526                	mv	a0,s1
    80003fe0:	00000097          	auipc	ra,0x0
    80003fe4:	ee2080e7          	jalr	-286(ra) # 80003ec2 <itrunc>
    ip->type = 0;
    80003fe8:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003fec:	8526                	mv	a0,s1
    80003fee:	00000097          	auipc	ra,0x0
    80003ff2:	cfa080e7          	jalr	-774(ra) # 80003ce8 <iupdate>
    ip->valid = 0;
    80003ff6:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003ffa:	854a                	mv	a0,s2
    80003ffc:	00001097          	auipc	ra,0x1
    80004000:	ade080e7          	jalr	-1314(ra) # 80004ada <releasesleep>
    acquire(&itable.lock);
    80004004:	0001e517          	auipc	a0,0x1e
    80004008:	1ec50513          	addi	a0,a0,492 # 800221f0 <itable>
    8000400c:	ffffd097          	auipc	ra,0xffffd
    80004010:	bc4080e7          	jalr	-1084(ra) # 80000bd0 <acquire>
    80004014:	b741                	j	80003f94 <iput+0x26>

0000000080004016 <iunlockput>:
{
    80004016:	1101                	addi	sp,sp,-32
    80004018:	ec06                	sd	ra,24(sp)
    8000401a:	e822                	sd	s0,16(sp)
    8000401c:	e426                	sd	s1,8(sp)
    8000401e:	1000                	addi	s0,sp,32
    80004020:	84aa                	mv	s1,a0
  iunlock(ip);
    80004022:	00000097          	auipc	ra,0x0
    80004026:	e54080e7          	jalr	-428(ra) # 80003e76 <iunlock>
  iput(ip);
    8000402a:	8526                	mv	a0,s1
    8000402c:	00000097          	auipc	ra,0x0
    80004030:	f42080e7          	jalr	-190(ra) # 80003f6e <iput>
}
    80004034:	60e2                	ld	ra,24(sp)
    80004036:	6442                	ld	s0,16(sp)
    80004038:	64a2                	ld	s1,8(sp)
    8000403a:	6105                	addi	sp,sp,32
    8000403c:	8082                	ret

000000008000403e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000403e:	1141                	addi	sp,sp,-16
    80004040:	e422                	sd	s0,8(sp)
    80004042:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80004044:	411c                	lw	a5,0(a0)
    80004046:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80004048:	415c                	lw	a5,4(a0)
    8000404a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000404c:	04451783          	lh	a5,68(a0)
    80004050:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80004054:	04a51783          	lh	a5,74(a0)
    80004058:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000405c:	04c56783          	lwu	a5,76(a0)
    80004060:	e99c                	sd	a5,16(a1)
}
    80004062:	6422                	ld	s0,8(sp)
    80004064:	0141                	addi	sp,sp,16
    80004066:	8082                	ret

0000000080004068 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004068:	457c                	lw	a5,76(a0)
    8000406a:	0ed7e963          	bltu	a5,a3,8000415c <readi+0xf4>
{
    8000406e:	7159                	addi	sp,sp,-112
    80004070:	f486                	sd	ra,104(sp)
    80004072:	f0a2                	sd	s0,96(sp)
    80004074:	eca6                	sd	s1,88(sp)
    80004076:	e8ca                	sd	s2,80(sp)
    80004078:	e4ce                	sd	s3,72(sp)
    8000407a:	e0d2                	sd	s4,64(sp)
    8000407c:	fc56                	sd	s5,56(sp)
    8000407e:	f85a                	sd	s6,48(sp)
    80004080:	f45e                	sd	s7,40(sp)
    80004082:	f062                	sd	s8,32(sp)
    80004084:	ec66                	sd	s9,24(sp)
    80004086:	e86a                	sd	s10,16(sp)
    80004088:	e46e                	sd	s11,8(sp)
    8000408a:	1880                	addi	s0,sp,112
    8000408c:	8baa                	mv	s7,a0
    8000408e:	8c2e                	mv	s8,a1
    80004090:	8ab2                	mv	s5,a2
    80004092:	84b6                	mv	s1,a3
    80004094:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80004096:	9f35                	addw	a4,a4,a3
    return 0;
    80004098:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000409a:	0ad76063          	bltu	a4,a3,8000413a <readi+0xd2>
  if(off + n > ip->size)
    8000409e:	00e7f463          	bgeu	a5,a4,800040a6 <readi+0x3e>
    n = ip->size - off;
    800040a2:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800040a6:	0a0b0963          	beqz	s6,80004158 <readi+0xf0>
    800040aa:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800040ac:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800040b0:	5cfd                	li	s9,-1
    800040b2:	a82d                	j	800040ec <readi+0x84>
    800040b4:	020a1d93          	slli	s11,s4,0x20
    800040b8:	020ddd93          	srli	s11,s11,0x20
    800040bc:	05890613          	addi	a2,s2,88
    800040c0:	86ee                	mv	a3,s11
    800040c2:	963a                	add	a2,a2,a4
    800040c4:	85d6                	mv	a1,s5
    800040c6:	8562                	mv	a0,s8
    800040c8:	ffffe097          	auipc	ra,0xffffe
    800040cc:	3c6080e7          	jalr	966(ra) # 8000248e <either_copyout>
    800040d0:	05950d63          	beq	a0,s9,8000412a <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800040d4:	854a                	mv	a0,s2
    800040d6:	fffff097          	auipc	ra,0xfffff
    800040da:	60c080e7          	jalr	1548(ra) # 800036e2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800040de:	013a09bb          	addw	s3,s4,s3
    800040e2:	009a04bb          	addw	s1,s4,s1
    800040e6:	9aee                	add	s5,s5,s11
    800040e8:	0569f763          	bgeu	s3,s6,80004136 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800040ec:	000ba903          	lw	s2,0(s7)
    800040f0:	00a4d59b          	srliw	a1,s1,0xa
    800040f4:	855e                	mv	a0,s7
    800040f6:	00000097          	auipc	ra,0x0
    800040fa:	8ac080e7          	jalr	-1876(ra) # 800039a2 <bmap>
    800040fe:	0005059b          	sext.w	a1,a0
    80004102:	854a                	mv	a0,s2
    80004104:	fffff097          	auipc	ra,0xfffff
    80004108:	4ae080e7          	jalr	1198(ra) # 800035b2 <bread>
    8000410c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000410e:	3ff4f713          	andi	a4,s1,1023
    80004112:	40ed07bb          	subw	a5,s10,a4
    80004116:	413b06bb          	subw	a3,s6,s3
    8000411a:	8a3e                	mv	s4,a5
    8000411c:	2781                	sext.w	a5,a5
    8000411e:	0006861b          	sext.w	a2,a3
    80004122:	f8f679e3          	bgeu	a2,a5,800040b4 <readi+0x4c>
    80004126:	8a36                	mv	s4,a3
    80004128:	b771                	j	800040b4 <readi+0x4c>
      brelse(bp);
    8000412a:	854a                	mv	a0,s2
    8000412c:	fffff097          	auipc	ra,0xfffff
    80004130:	5b6080e7          	jalr	1462(ra) # 800036e2 <brelse>
      tot = -1;
    80004134:	59fd                	li	s3,-1
  }
  return tot;
    80004136:	0009851b          	sext.w	a0,s3
}
    8000413a:	70a6                	ld	ra,104(sp)
    8000413c:	7406                	ld	s0,96(sp)
    8000413e:	64e6                	ld	s1,88(sp)
    80004140:	6946                	ld	s2,80(sp)
    80004142:	69a6                	ld	s3,72(sp)
    80004144:	6a06                	ld	s4,64(sp)
    80004146:	7ae2                	ld	s5,56(sp)
    80004148:	7b42                	ld	s6,48(sp)
    8000414a:	7ba2                	ld	s7,40(sp)
    8000414c:	7c02                	ld	s8,32(sp)
    8000414e:	6ce2                	ld	s9,24(sp)
    80004150:	6d42                	ld	s10,16(sp)
    80004152:	6da2                	ld	s11,8(sp)
    80004154:	6165                	addi	sp,sp,112
    80004156:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004158:	89da                	mv	s3,s6
    8000415a:	bff1                	j	80004136 <readi+0xce>
    return 0;
    8000415c:	4501                	li	a0,0
}
    8000415e:	8082                	ret

0000000080004160 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004160:	457c                	lw	a5,76(a0)
    80004162:	10d7e863          	bltu	a5,a3,80004272 <writei+0x112>
{
    80004166:	7159                	addi	sp,sp,-112
    80004168:	f486                	sd	ra,104(sp)
    8000416a:	f0a2                	sd	s0,96(sp)
    8000416c:	eca6                	sd	s1,88(sp)
    8000416e:	e8ca                	sd	s2,80(sp)
    80004170:	e4ce                	sd	s3,72(sp)
    80004172:	e0d2                	sd	s4,64(sp)
    80004174:	fc56                	sd	s5,56(sp)
    80004176:	f85a                	sd	s6,48(sp)
    80004178:	f45e                	sd	s7,40(sp)
    8000417a:	f062                	sd	s8,32(sp)
    8000417c:	ec66                	sd	s9,24(sp)
    8000417e:	e86a                	sd	s10,16(sp)
    80004180:	e46e                	sd	s11,8(sp)
    80004182:	1880                	addi	s0,sp,112
    80004184:	8b2a                	mv	s6,a0
    80004186:	8c2e                	mv	s8,a1
    80004188:	8ab2                	mv	s5,a2
    8000418a:	8936                	mv	s2,a3
    8000418c:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    8000418e:	00e687bb          	addw	a5,a3,a4
    80004192:	0ed7e263          	bltu	a5,a3,80004276 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80004196:	00043737          	lui	a4,0x43
    8000419a:	0ef76063          	bltu	a4,a5,8000427a <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000419e:	0c0b8863          	beqz	s7,8000426e <writei+0x10e>
    800041a2:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800041a4:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800041a8:	5cfd                	li	s9,-1
    800041aa:	a091                	j	800041ee <writei+0x8e>
    800041ac:	02099d93          	slli	s11,s3,0x20
    800041b0:	020ddd93          	srli	s11,s11,0x20
    800041b4:	05848513          	addi	a0,s1,88
    800041b8:	86ee                	mv	a3,s11
    800041ba:	8656                	mv	a2,s5
    800041bc:	85e2                	mv	a1,s8
    800041be:	953a                	add	a0,a0,a4
    800041c0:	ffffe097          	auipc	ra,0xffffe
    800041c4:	324080e7          	jalr	804(ra) # 800024e4 <either_copyin>
    800041c8:	07950263          	beq	a0,s9,8000422c <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800041cc:	8526                	mv	a0,s1
    800041ce:	00000097          	auipc	ra,0x0
    800041d2:	798080e7          	jalr	1944(ra) # 80004966 <log_write>
    brelse(bp);
    800041d6:	8526                	mv	a0,s1
    800041d8:	fffff097          	auipc	ra,0xfffff
    800041dc:	50a080e7          	jalr	1290(ra) # 800036e2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800041e0:	01498a3b          	addw	s4,s3,s4
    800041e4:	0129893b          	addw	s2,s3,s2
    800041e8:	9aee                	add	s5,s5,s11
    800041ea:	057a7663          	bgeu	s4,s7,80004236 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800041ee:	000b2483          	lw	s1,0(s6)
    800041f2:	00a9559b          	srliw	a1,s2,0xa
    800041f6:	855a                	mv	a0,s6
    800041f8:	fffff097          	auipc	ra,0xfffff
    800041fc:	7aa080e7          	jalr	1962(ra) # 800039a2 <bmap>
    80004200:	0005059b          	sext.w	a1,a0
    80004204:	8526                	mv	a0,s1
    80004206:	fffff097          	auipc	ra,0xfffff
    8000420a:	3ac080e7          	jalr	940(ra) # 800035b2 <bread>
    8000420e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004210:	3ff97713          	andi	a4,s2,1023
    80004214:	40ed07bb          	subw	a5,s10,a4
    80004218:	414b86bb          	subw	a3,s7,s4
    8000421c:	89be                	mv	s3,a5
    8000421e:	2781                	sext.w	a5,a5
    80004220:	0006861b          	sext.w	a2,a3
    80004224:	f8f674e3          	bgeu	a2,a5,800041ac <writei+0x4c>
    80004228:	89b6                	mv	s3,a3
    8000422a:	b749                	j	800041ac <writei+0x4c>
      brelse(bp);
    8000422c:	8526                	mv	a0,s1
    8000422e:	fffff097          	auipc	ra,0xfffff
    80004232:	4b4080e7          	jalr	1204(ra) # 800036e2 <brelse>
  }

  if(off > ip->size)
    80004236:	04cb2783          	lw	a5,76(s6)
    8000423a:	0127f463          	bgeu	a5,s2,80004242 <writei+0xe2>
    ip->size = off;
    8000423e:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80004242:	855a                	mv	a0,s6
    80004244:	00000097          	auipc	ra,0x0
    80004248:	aa4080e7          	jalr	-1372(ra) # 80003ce8 <iupdate>

  return tot;
    8000424c:	000a051b          	sext.w	a0,s4
}
    80004250:	70a6                	ld	ra,104(sp)
    80004252:	7406                	ld	s0,96(sp)
    80004254:	64e6                	ld	s1,88(sp)
    80004256:	6946                	ld	s2,80(sp)
    80004258:	69a6                	ld	s3,72(sp)
    8000425a:	6a06                	ld	s4,64(sp)
    8000425c:	7ae2                	ld	s5,56(sp)
    8000425e:	7b42                	ld	s6,48(sp)
    80004260:	7ba2                	ld	s7,40(sp)
    80004262:	7c02                	ld	s8,32(sp)
    80004264:	6ce2                	ld	s9,24(sp)
    80004266:	6d42                	ld	s10,16(sp)
    80004268:	6da2                	ld	s11,8(sp)
    8000426a:	6165                	addi	sp,sp,112
    8000426c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000426e:	8a5e                	mv	s4,s7
    80004270:	bfc9                	j	80004242 <writei+0xe2>
    return -1;
    80004272:	557d                	li	a0,-1
}
    80004274:	8082                	ret
    return -1;
    80004276:	557d                	li	a0,-1
    80004278:	bfe1                	j	80004250 <writei+0xf0>
    return -1;
    8000427a:	557d                	li	a0,-1
    8000427c:	bfd1                	j	80004250 <writei+0xf0>

000000008000427e <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000427e:	1141                	addi	sp,sp,-16
    80004280:	e406                	sd	ra,8(sp)
    80004282:	e022                	sd	s0,0(sp)
    80004284:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80004286:	4639                	li	a2,14
    80004288:	ffffd097          	auipc	ra,0xffffd
    8000428c:	b14080e7          	jalr	-1260(ra) # 80000d9c <strncmp>
}
    80004290:	60a2                	ld	ra,8(sp)
    80004292:	6402                	ld	s0,0(sp)
    80004294:	0141                	addi	sp,sp,16
    80004296:	8082                	ret

0000000080004298 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80004298:	7139                	addi	sp,sp,-64
    8000429a:	fc06                	sd	ra,56(sp)
    8000429c:	f822                	sd	s0,48(sp)
    8000429e:	f426                	sd	s1,40(sp)
    800042a0:	f04a                	sd	s2,32(sp)
    800042a2:	ec4e                	sd	s3,24(sp)
    800042a4:	e852                	sd	s4,16(sp)
    800042a6:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800042a8:	04451703          	lh	a4,68(a0)
    800042ac:	4785                	li	a5,1
    800042ae:	00f71a63          	bne	a4,a5,800042c2 <dirlookup+0x2a>
    800042b2:	892a                	mv	s2,a0
    800042b4:	89ae                	mv	s3,a1
    800042b6:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800042b8:	457c                	lw	a5,76(a0)
    800042ba:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800042bc:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800042be:	e79d                	bnez	a5,800042ec <dirlookup+0x54>
    800042c0:	a8a5                	j	80004338 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800042c2:	00004517          	auipc	a0,0x4
    800042c6:	46e50513          	addi	a0,a0,1134 # 80008730 <syscalls+0x1b8>
    800042ca:	ffffc097          	auipc	ra,0xffffc
    800042ce:	270080e7          	jalr	624(ra) # 8000053a <panic>
      panic("dirlookup read");
    800042d2:	00004517          	auipc	a0,0x4
    800042d6:	47650513          	addi	a0,a0,1142 # 80008748 <syscalls+0x1d0>
    800042da:	ffffc097          	auipc	ra,0xffffc
    800042de:	260080e7          	jalr	608(ra) # 8000053a <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800042e2:	24c1                	addiw	s1,s1,16
    800042e4:	04c92783          	lw	a5,76(s2)
    800042e8:	04f4f763          	bgeu	s1,a5,80004336 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800042ec:	4741                	li	a4,16
    800042ee:	86a6                	mv	a3,s1
    800042f0:	fc040613          	addi	a2,s0,-64
    800042f4:	4581                	li	a1,0
    800042f6:	854a                	mv	a0,s2
    800042f8:	00000097          	auipc	ra,0x0
    800042fc:	d70080e7          	jalr	-656(ra) # 80004068 <readi>
    80004300:	47c1                	li	a5,16
    80004302:	fcf518e3          	bne	a0,a5,800042d2 <dirlookup+0x3a>
    if(de.inum == 0)
    80004306:	fc045783          	lhu	a5,-64(s0)
    8000430a:	dfe1                	beqz	a5,800042e2 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000430c:	fc240593          	addi	a1,s0,-62
    80004310:	854e                	mv	a0,s3
    80004312:	00000097          	auipc	ra,0x0
    80004316:	f6c080e7          	jalr	-148(ra) # 8000427e <namecmp>
    8000431a:	f561                	bnez	a0,800042e2 <dirlookup+0x4a>
      if(poff)
    8000431c:	000a0463          	beqz	s4,80004324 <dirlookup+0x8c>
        *poff = off;
    80004320:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80004324:	fc045583          	lhu	a1,-64(s0)
    80004328:	00092503          	lw	a0,0(s2)
    8000432c:	fffff097          	auipc	ra,0xfffff
    80004330:	752080e7          	jalr	1874(ra) # 80003a7e <iget>
    80004334:	a011                	j	80004338 <dirlookup+0xa0>
  return 0;
    80004336:	4501                	li	a0,0
}
    80004338:	70e2                	ld	ra,56(sp)
    8000433a:	7442                	ld	s0,48(sp)
    8000433c:	74a2                	ld	s1,40(sp)
    8000433e:	7902                	ld	s2,32(sp)
    80004340:	69e2                	ld	s3,24(sp)
    80004342:	6a42                	ld	s4,16(sp)
    80004344:	6121                	addi	sp,sp,64
    80004346:	8082                	ret

0000000080004348 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80004348:	711d                	addi	sp,sp,-96
    8000434a:	ec86                	sd	ra,88(sp)
    8000434c:	e8a2                	sd	s0,80(sp)
    8000434e:	e4a6                	sd	s1,72(sp)
    80004350:	e0ca                	sd	s2,64(sp)
    80004352:	fc4e                	sd	s3,56(sp)
    80004354:	f852                	sd	s4,48(sp)
    80004356:	f456                	sd	s5,40(sp)
    80004358:	f05a                	sd	s6,32(sp)
    8000435a:	ec5e                	sd	s7,24(sp)
    8000435c:	e862                	sd	s8,16(sp)
    8000435e:	e466                	sd	s9,8(sp)
    80004360:	e06a                	sd	s10,0(sp)
    80004362:	1080                	addi	s0,sp,96
    80004364:	84aa                	mv	s1,a0
    80004366:	8b2e                	mv	s6,a1
    80004368:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000436a:	00054703          	lbu	a4,0(a0)
    8000436e:	02f00793          	li	a5,47
    80004372:	02f70363          	beq	a4,a5,80004398 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80004376:	ffffd097          	auipc	ra,0xffffd
    8000437a:	662080e7          	jalr	1634(ra) # 800019d8 <myproc>
    8000437e:	15053503          	ld	a0,336(a0)
    80004382:	00000097          	auipc	ra,0x0
    80004386:	9f4080e7          	jalr	-1548(ra) # 80003d76 <idup>
    8000438a:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000438c:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80004390:	4cb5                	li	s9,13
  len = path - s;
    80004392:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004394:	4c05                	li	s8,1
    80004396:	a87d                	j	80004454 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80004398:	4585                	li	a1,1
    8000439a:	4505                	li	a0,1
    8000439c:	fffff097          	auipc	ra,0xfffff
    800043a0:	6e2080e7          	jalr	1762(ra) # 80003a7e <iget>
    800043a4:	8a2a                	mv	s4,a0
    800043a6:	b7dd                	j	8000438c <namex+0x44>
      iunlockput(ip);
    800043a8:	8552                	mv	a0,s4
    800043aa:	00000097          	auipc	ra,0x0
    800043ae:	c6c080e7          	jalr	-916(ra) # 80004016 <iunlockput>
      return 0;
    800043b2:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800043b4:	8552                	mv	a0,s4
    800043b6:	60e6                	ld	ra,88(sp)
    800043b8:	6446                	ld	s0,80(sp)
    800043ba:	64a6                	ld	s1,72(sp)
    800043bc:	6906                	ld	s2,64(sp)
    800043be:	79e2                	ld	s3,56(sp)
    800043c0:	7a42                	ld	s4,48(sp)
    800043c2:	7aa2                	ld	s5,40(sp)
    800043c4:	7b02                	ld	s6,32(sp)
    800043c6:	6be2                	ld	s7,24(sp)
    800043c8:	6c42                	ld	s8,16(sp)
    800043ca:	6ca2                	ld	s9,8(sp)
    800043cc:	6d02                	ld	s10,0(sp)
    800043ce:	6125                	addi	sp,sp,96
    800043d0:	8082                	ret
      iunlock(ip);
    800043d2:	8552                	mv	a0,s4
    800043d4:	00000097          	auipc	ra,0x0
    800043d8:	aa2080e7          	jalr	-1374(ra) # 80003e76 <iunlock>
      return ip;
    800043dc:	bfe1                	j	800043b4 <namex+0x6c>
      iunlockput(ip);
    800043de:	8552                	mv	a0,s4
    800043e0:	00000097          	auipc	ra,0x0
    800043e4:	c36080e7          	jalr	-970(ra) # 80004016 <iunlockput>
      return 0;
    800043e8:	8a4e                	mv	s4,s3
    800043ea:	b7e9                	j	800043b4 <namex+0x6c>
  len = path - s;
    800043ec:	40998633          	sub	a2,s3,s1
    800043f0:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    800043f4:	09acd863          	bge	s9,s10,80004484 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    800043f8:	4639                	li	a2,14
    800043fa:	85a6                	mv	a1,s1
    800043fc:	8556                	mv	a0,s5
    800043fe:	ffffd097          	auipc	ra,0xffffd
    80004402:	92a080e7          	jalr	-1750(ra) # 80000d28 <memmove>
    80004406:	84ce                	mv	s1,s3
  while(*path == '/')
    80004408:	0004c783          	lbu	a5,0(s1)
    8000440c:	01279763          	bne	a5,s2,8000441a <namex+0xd2>
    path++;
    80004410:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004412:	0004c783          	lbu	a5,0(s1)
    80004416:	ff278de3          	beq	a5,s2,80004410 <namex+0xc8>
    ilock(ip);
    8000441a:	8552                	mv	a0,s4
    8000441c:	00000097          	auipc	ra,0x0
    80004420:	998080e7          	jalr	-1640(ra) # 80003db4 <ilock>
    if(ip->type != T_DIR){
    80004424:	044a1783          	lh	a5,68(s4)
    80004428:	f98790e3          	bne	a5,s8,800043a8 <namex+0x60>
    if(nameiparent && *path == '\0'){
    8000442c:	000b0563          	beqz	s6,80004436 <namex+0xee>
    80004430:	0004c783          	lbu	a5,0(s1)
    80004434:	dfd9                	beqz	a5,800043d2 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004436:	865e                	mv	a2,s7
    80004438:	85d6                	mv	a1,s5
    8000443a:	8552                	mv	a0,s4
    8000443c:	00000097          	auipc	ra,0x0
    80004440:	e5c080e7          	jalr	-420(ra) # 80004298 <dirlookup>
    80004444:	89aa                	mv	s3,a0
    80004446:	dd41                	beqz	a0,800043de <namex+0x96>
    iunlockput(ip);
    80004448:	8552                	mv	a0,s4
    8000444a:	00000097          	auipc	ra,0x0
    8000444e:	bcc080e7          	jalr	-1076(ra) # 80004016 <iunlockput>
    ip = next;
    80004452:	8a4e                	mv	s4,s3
  while(*path == '/')
    80004454:	0004c783          	lbu	a5,0(s1)
    80004458:	01279763          	bne	a5,s2,80004466 <namex+0x11e>
    path++;
    8000445c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000445e:	0004c783          	lbu	a5,0(s1)
    80004462:	ff278de3          	beq	a5,s2,8000445c <namex+0x114>
  if(*path == 0)
    80004466:	cb9d                	beqz	a5,8000449c <namex+0x154>
  while(*path != '/' && *path != 0)
    80004468:	0004c783          	lbu	a5,0(s1)
    8000446c:	89a6                	mv	s3,s1
  len = path - s;
    8000446e:	8d5e                	mv	s10,s7
    80004470:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80004472:	01278963          	beq	a5,s2,80004484 <namex+0x13c>
    80004476:	dbbd                	beqz	a5,800043ec <namex+0xa4>
    path++;
    80004478:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    8000447a:	0009c783          	lbu	a5,0(s3)
    8000447e:	ff279ce3          	bne	a5,s2,80004476 <namex+0x12e>
    80004482:	b7ad                	j	800043ec <namex+0xa4>
    memmove(name, s, len);
    80004484:	2601                	sext.w	a2,a2
    80004486:	85a6                	mv	a1,s1
    80004488:	8556                	mv	a0,s5
    8000448a:	ffffd097          	auipc	ra,0xffffd
    8000448e:	89e080e7          	jalr	-1890(ra) # 80000d28 <memmove>
    name[len] = 0;
    80004492:	9d56                	add	s10,s10,s5
    80004494:	000d0023          	sb	zero,0(s10)
    80004498:	84ce                	mv	s1,s3
    8000449a:	b7bd                	j	80004408 <namex+0xc0>
  if(nameiparent){
    8000449c:	f00b0ce3          	beqz	s6,800043b4 <namex+0x6c>
    iput(ip);
    800044a0:	8552                	mv	a0,s4
    800044a2:	00000097          	auipc	ra,0x0
    800044a6:	acc080e7          	jalr	-1332(ra) # 80003f6e <iput>
    return 0;
    800044aa:	4a01                	li	s4,0
    800044ac:	b721                	j	800043b4 <namex+0x6c>

00000000800044ae <dirlink>:
{
    800044ae:	7139                	addi	sp,sp,-64
    800044b0:	fc06                	sd	ra,56(sp)
    800044b2:	f822                	sd	s0,48(sp)
    800044b4:	f426                	sd	s1,40(sp)
    800044b6:	f04a                	sd	s2,32(sp)
    800044b8:	ec4e                	sd	s3,24(sp)
    800044ba:	e852                	sd	s4,16(sp)
    800044bc:	0080                	addi	s0,sp,64
    800044be:	892a                	mv	s2,a0
    800044c0:	8a2e                	mv	s4,a1
    800044c2:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800044c4:	4601                	li	a2,0
    800044c6:	00000097          	auipc	ra,0x0
    800044ca:	dd2080e7          	jalr	-558(ra) # 80004298 <dirlookup>
    800044ce:	e93d                	bnez	a0,80004544 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800044d0:	04c92483          	lw	s1,76(s2)
    800044d4:	c49d                	beqz	s1,80004502 <dirlink+0x54>
    800044d6:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800044d8:	4741                	li	a4,16
    800044da:	86a6                	mv	a3,s1
    800044dc:	fc040613          	addi	a2,s0,-64
    800044e0:	4581                	li	a1,0
    800044e2:	854a                	mv	a0,s2
    800044e4:	00000097          	auipc	ra,0x0
    800044e8:	b84080e7          	jalr	-1148(ra) # 80004068 <readi>
    800044ec:	47c1                	li	a5,16
    800044ee:	06f51163          	bne	a0,a5,80004550 <dirlink+0xa2>
    if(de.inum == 0)
    800044f2:	fc045783          	lhu	a5,-64(s0)
    800044f6:	c791                	beqz	a5,80004502 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800044f8:	24c1                	addiw	s1,s1,16
    800044fa:	04c92783          	lw	a5,76(s2)
    800044fe:	fcf4ede3          	bltu	s1,a5,800044d8 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80004502:	4639                	li	a2,14
    80004504:	85d2                	mv	a1,s4
    80004506:	fc240513          	addi	a0,s0,-62
    8000450a:	ffffd097          	auipc	ra,0xffffd
    8000450e:	8ce080e7          	jalr	-1842(ra) # 80000dd8 <strncpy>
  de.inum = inum;
    80004512:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004516:	4741                	li	a4,16
    80004518:	86a6                	mv	a3,s1
    8000451a:	fc040613          	addi	a2,s0,-64
    8000451e:	4581                	li	a1,0
    80004520:	854a                	mv	a0,s2
    80004522:	00000097          	auipc	ra,0x0
    80004526:	c3e080e7          	jalr	-962(ra) # 80004160 <writei>
    8000452a:	872a                	mv	a4,a0
    8000452c:	47c1                	li	a5,16
  return 0;
    8000452e:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004530:	02f71863          	bne	a4,a5,80004560 <dirlink+0xb2>
}
    80004534:	70e2                	ld	ra,56(sp)
    80004536:	7442                	ld	s0,48(sp)
    80004538:	74a2                	ld	s1,40(sp)
    8000453a:	7902                	ld	s2,32(sp)
    8000453c:	69e2                	ld	s3,24(sp)
    8000453e:	6a42                	ld	s4,16(sp)
    80004540:	6121                	addi	sp,sp,64
    80004542:	8082                	ret
    iput(ip);
    80004544:	00000097          	auipc	ra,0x0
    80004548:	a2a080e7          	jalr	-1494(ra) # 80003f6e <iput>
    return -1;
    8000454c:	557d                	li	a0,-1
    8000454e:	b7dd                	j	80004534 <dirlink+0x86>
      panic("dirlink read");
    80004550:	00004517          	auipc	a0,0x4
    80004554:	20850513          	addi	a0,a0,520 # 80008758 <syscalls+0x1e0>
    80004558:	ffffc097          	auipc	ra,0xffffc
    8000455c:	fe2080e7          	jalr	-30(ra) # 8000053a <panic>
    panic("dirlink");
    80004560:	00004517          	auipc	a0,0x4
    80004564:	30050513          	addi	a0,a0,768 # 80008860 <syscalls+0x2e8>
    80004568:	ffffc097          	auipc	ra,0xffffc
    8000456c:	fd2080e7          	jalr	-46(ra) # 8000053a <panic>

0000000080004570 <namei>:

struct inode*
namei(char *path)
{
    80004570:	1101                	addi	sp,sp,-32
    80004572:	ec06                	sd	ra,24(sp)
    80004574:	e822                	sd	s0,16(sp)
    80004576:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004578:	fe040613          	addi	a2,s0,-32
    8000457c:	4581                	li	a1,0
    8000457e:	00000097          	auipc	ra,0x0
    80004582:	dca080e7          	jalr	-566(ra) # 80004348 <namex>
}
    80004586:	60e2                	ld	ra,24(sp)
    80004588:	6442                	ld	s0,16(sp)
    8000458a:	6105                	addi	sp,sp,32
    8000458c:	8082                	ret

000000008000458e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000458e:	1141                	addi	sp,sp,-16
    80004590:	e406                	sd	ra,8(sp)
    80004592:	e022                	sd	s0,0(sp)
    80004594:	0800                	addi	s0,sp,16
    80004596:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004598:	4585                	li	a1,1
    8000459a:	00000097          	auipc	ra,0x0
    8000459e:	dae080e7          	jalr	-594(ra) # 80004348 <namex>
}
    800045a2:	60a2                	ld	ra,8(sp)
    800045a4:	6402                	ld	s0,0(sp)
    800045a6:	0141                	addi	sp,sp,16
    800045a8:	8082                	ret

00000000800045aa <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800045aa:	1101                	addi	sp,sp,-32
    800045ac:	ec06                	sd	ra,24(sp)
    800045ae:	e822                	sd	s0,16(sp)
    800045b0:	e426                	sd	s1,8(sp)
    800045b2:	e04a                	sd	s2,0(sp)
    800045b4:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800045b6:	0001f917          	auipc	s2,0x1f
    800045ba:	6e290913          	addi	s2,s2,1762 # 80023c98 <log>
    800045be:	01892583          	lw	a1,24(s2)
    800045c2:	02892503          	lw	a0,40(s2)
    800045c6:	fffff097          	auipc	ra,0xfffff
    800045ca:	fec080e7          	jalr	-20(ra) # 800035b2 <bread>
    800045ce:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800045d0:	02c92683          	lw	a3,44(s2)
    800045d4:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800045d6:	02d05863          	blez	a3,80004606 <write_head+0x5c>
    800045da:	0001f797          	auipc	a5,0x1f
    800045de:	6ee78793          	addi	a5,a5,1774 # 80023cc8 <log+0x30>
    800045e2:	05c50713          	addi	a4,a0,92
    800045e6:	36fd                	addiw	a3,a3,-1
    800045e8:	02069613          	slli	a2,a3,0x20
    800045ec:	01e65693          	srli	a3,a2,0x1e
    800045f0:	0001f617          	auipc	a2,0x1f
    800045f4:	6dc60613          	addi	a2,a2,1756 # 80023ccc <log+0x34>
    800045f8:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800045fa:	4390                	lw	a2,0(a5)
    800045fc:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800045fe:	0791                	addi	a5,a5,4
    80004600:	0711                	addi	a4,a4,4
    80004602:	fed79ce3          	bne	a5,a3,800045fa <write_head+0x50>
  }
  bwrite(buf);
    80004606:	8526                	mv	a0,s1
    80004608:	fffff097          	auipc	ra,0xfffff
    8000460c:	09c080e7          	jalr	156(ra) # 800036a4 <bwrite>
  brelse(buf);
    80004610:	8526                	mv	a0,s1
    80004612:	fffff097          	auipc	ra,0xfffff
    80004616:	0d0080e7          	jalr	208(ra) # 800036e2 <brelse>
}
    8000461a:	60e2                	ld	ra,24(sp)
    8000461c:	6442                	ld	s0,16(sp)
    8000461e:	64a2                	ld	s1,8(sp)
    80004620:	6902                	ld	s2,0(sp)
    80004622:	6105                	addi	sp,sp,32
    80004624:	8082                	ret

0000000080004626 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004626:	0001f797          	auipc	a5,0x1f
    8000462a:	69e7a783          	lw	a5,1694(a5) # 80023cc4 <log+0x2c>
    8000462e:	0af05d63          	blez	a5,800046e8 <install_trans+0xc2>
{
    80004632:	7139                	addi	sp,sp,-64
    80004634:	fc06                	sd	ra,56(sp)
    80004636:	f822                	sd	s0,48(sp)
    80004638:	f426                	sd	s1,40(sp)
    8000463a:	f04a                	sd	s2,32(sp)
    8000463c:	ec4e                	sd	s3,24(sp)
    8000463e:	e852                	sd	s4,16(sp)
    80004640:	e456                	sd	s5,8(sp)
    80004642:	e05a                	sd	s6,0(sp)
    80004644:	0080                	addi	s0,sp,64
    80004646:	8b2a                	mv	s6,a0
    80004648:	0001fa97          	auipc	s5,0x1f
    8000464c:	680a8a93          	addi	s5,s5,1664 # 80023cc8 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004650:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004652:	0001f997          	auipc	s3,0x1f
    80004656:	64698993          	addi	s3,s3,1606 # 80023c98 <log>
    8000465a:	a00d                	j	8000467c <install_trans+0x56>
    brelse(lbuf);
    8000465c:	854a                	mv	a0,s2
    8000465e:	fffff097          	auipc	ra,0xfffff
    80004662:	084080e7          	jalr	132(ra) # 800036e2 <brelse>
    brelse(dbuf);
    80004666:	8526                	mv	a0,s1
    80004668:	fffff097          	auipc	ra,0xfffff
    8000466c:	07a080e7          	jalr	122(ra) # 800036e2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004670:	2a05                	addiw	s4,s4,1
    80004672:	0a91                	addi	s5,s5,4
    80004674:	02c9a783          	lw	a5,44(s3)
    80004678:	04fa5e63          	bge	s4,a5,800046d4 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000467c:	0189a583          	lw	a1,24(s3)
    80004680:	014585bb          	addw	a1,a1,s4
    80004684:	2585                	addiw	a1,a1,1
    80004686:	0289a503          	lw	a0,40(s3)
    8000468a:	fffff097          	auipc	ra,0xfffff
    8000468e:	f28080e7          	jalr	-216(ra) # 800035b2 <bread>
    80004692:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004694:	000aa583          	lw	a1,0(s5)
    80004698:	0289a503          	lw	a0,40(s3)
    8000469c:	fffff097          	auipc	ra,0xfffff
    800046a0:	f16080e7          	jalr	-234(ra) # 800035b2 <bread>
    800046a4:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800046a6:	40000613          	li	a2,1024
    800046aa:	05890593          	addi	a1,s2,88
    800046ae:	05850513          	addi	a0,a0,88
    800046b2:	ffffc097          	auipc	ra,0xffffc
    800046b6:	676080e7          	jalr	1654(ra) # 80000d28 <memmove>
    bwrite(dbuf);  // write dst to disk
    800046ba:	8526                	mv	a0,s1
    800046bc:	fffff097          	auipc	ra,0xfffff
    800046c0:	fe8080e7          	jalr	-24(ra) # 800036a4 <bwrite>
    if(recovering == 0)
    800046c4:	f80b1ce3          	bnez	s6,8000465c <install_trans+0x36>
      bunpin(dbuf);
    800046c8:	8526                	mv	a0,s1
    800046ca:	fffff097          	auipc	ra,0xfffff
    800046ce:	0f2080e7          	jalr	242(ra) # 800037bc <bunpin>
    800046d2:	b769                	j	8000465c <install_trans+0x36>
}
    800046d4:	70e2                	ld	ra,56(sp)
    800046d6:	7442                	ld	s0,48(sp)
    800046d8:	74a2                	ld	s1,40(sp)
    800046da:	7902                	ld	s2,32(sp)
    800046dc:	69e2                	ld	s3,24(sp)
    800046de:	6a42                	ld	s4,16(sp)
    800046e0:	6aa2                	ld	s5,8(sp)
    800046e2:	6b02                	ld	s6,0(sp)
    800046e4:	6121                	addi	sp,sp,64
    800046e6:	8082                	ret
    800046e8:	8082                	ret

00000000800046ea <initlog>:
{
    800046ea:	7179                	addi	sp,sp,-48
    800046ec:	f406                	sd	ra,40(sp)
    800046ee:	f022                	sd	s0,32(sp)
    800046f0:	ec26                	sd	s1,24(sp)
    800046f2:	e84a                	sd	s2,16(sp)
    800046f4:	e44e                	sd	s3,8(sp)
    800046f6:	1800                	addi	s0,sp,48
    800046f8:	892a                	mv	s2,a0
    800046fa:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800046fc:	0001f497          	auipc	s1,0x1f
    80004700:	59c48493          	addi	s1,s1,1436 # 80023c98 <log>
    80004704:	00004597          	auipc	a1,0x4
    80004708:	06458593          	addi	a1,a1,100 # 80008768 <syscalls+0x1f0>
    8000470c:	8526                	mv	a0,s1
    8000470e:	ffffc097          	auipc	ra,0xffffc
    80004712:	432080e7          	jalr	1074(ra) # 80000b40 <initlock>
  log.start = sb->logstart;
    80004716:	0149a583          	lw	a1,20(s3)
    8000471a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000471c:	0109a783          	lw	a5,16(s3)
    80004720:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004722:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004726:	854a                	mv	a0,s2
    80004728:	fffff097          	auipc	ra,0xfffff
    8000472c:	e8a080e7          	jalr	-374(ra) # 800035b2 <bread>
  log.lh.n = lh->n;
    80004730:	4d34                	lw	a3,88(a0)
    80004732:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004734:	02d05663          	blez	a3,80004760 <initlog+0x76>
    80004738:	05c50793          	addi	a5,a0,92
    8000473c:	0001f717          	auipc	a4,0x1f
    80004740:	58c70713          	addi	a4,a4,1420 # 80023cc8 <log+0x30>
    80004744:	36fd                	addiw	a3,a3,-1
    80004746:	02069613          	slli	a2,a3,0x20
    8000474a:	01e65693          	srli	a3,a2,0x1e
    8000474e:	06050613          	addi	a2,a0,96
    80004752:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80004754:	4390                	lw	a2,0(a5)
    80004756:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004758:	0791                	addi	a5,a5,4
    8000475a:	0711                	addi	a4,a4,4
    8000475c:	fed79ce3          	bne	a5,a3,80004754 <initlog+0x6a>
  brelse(buf);
    80004760:	fffff097          	auipc	ra,0xfffff
    80004764:	f82080e7          	jalr	-126(ra) # 800036e2 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004768:	4505                	li	a0,1
    8000476a:	00000097          	auipc	ra,0x0
    8000476e:	ebc080e7          	jalr	-324(ra) # 80004626 <install_trans>
  log.lh.n = 0;
    80004772:	0001f797          	auipc	a5,0x1f
    80004776:	5407a923          	sw	zero,1362(a5) # 80023cc4 <log+0x2c>
  write_head(); // clear the log
    8000477a:	00000097          	auipc	ra,0x0
    8000477e:	e30080e7          	jalr	-464(ra) # 800045aa <write_head>
}
    80004782:	70a2                	ld	ra,40(sp)
    80004784:	7402                	ld	s0,32(sp)
    80004786:	64e2                	ld	s1,24(sp)
    80004788:	6942                	ld	s2,16(sp)
    8000478a:	69a2                	ld	s3,8(sp)
    8000478c:	6145                	addi	sp,sp,48
    8000478e:	8082                	ret

0000000080004790 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004790:	1101                	addi	sp,sp,-32
    80004792:	ec06                	sd	ra,24(sp)
    80004794:	e822                	sd	s0,16(sp)
    80004796:	e426                	sd	s1,8(sp)
    80004798:	e04a                	sd	s2,0(sp)
    8000479a:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000479c:	0001f517          	auipc	a0,0x1f
    800047a0:	4fc50513          	addi	a0,a0,1276 # 80023c98 <log>
    800047a4:	ffffc097          	auipc	ra,0xffffc
    800047a8:	42c080e7          	jalr	1068(ra) # 80000bd0 <acquire>
  while(1){
    if(log.committing){
    800047ac:	0001f497          	auipc	s1,0x1f
    800047b0:	4ec48493          	addi	s1,s1,1260 # 80023c98 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800047b4:	4979                	li	s2,30
    800047b6:	a039                	j	800047c4 <begin_op+0x34>
      sleep(&log, &log.lock);
    800047b8:	85a6                	mv	a1,s1
    800047ba:	8526                	mv	a0,s1
    800047bc:	ffffe097          	auipc	ra,0xffffe
    800047c0:	902080e7          	jalr	-1790(ra) # 800020be <sleep>
    if(log.committing){
    800047c4:	50dc                	lw	a5,36(s1)
    800047c6:	fbed                	bnez	a5,800047b8 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800047c8:	5098                	lw	a4,32(s1)
    800047ca:	2705                	addiw	a4,a4,1
    800047cc:	0007069b          	sext.w	a3,a4
    800047d0:	0027179b          	slliw	a5,a4,0x2
    800047d4:	9fb9                	addw	a5,a5,a4
    800047d6:	0017979b          	slliw	a5,a5,0x1
    800047da:	54d8                	lw	a4,44(s1)
    800047dc:	9fb9                	addw	a5,a5,a4
    800047de:	00f95963          	bge	s2,a5,800047f0 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800047e2:	85a6                	mv	a1,s1
    800047e4:	8526                	mv	a0,s1
    800047e6:	ffffe097          	auipc	ra,0xffffe
    800047ea:	8d8080e7          	jalr	-1832(ra) # 800020be <sleep>
    800047ee:	bfd9                	j	800047c4 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800047f0:	0001f517          	auipc	a0,0x1f
    800047f4:	4a850513          	addi	a0,a0,1192 # 80023c98 <log>
    800047f8:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800047fa:	ffffc097          	auipc	ra,0xffffc
    800047fe:	48a080e7          	jalr	1162(ra) # 80000c84 <release>
      break;
    }
  }
}
    80004802:	60e2                	ld	ra,24(sp)
    80004804:	6442                	ld	s0,16(sp)
    80004806:	64a2                	ld	s1,8(sp)
    80004808:	6902                	ld	s2,0(sp)
    8000480a:	6105                	addi	sp,sp,32
    8000480c:	8082                	ret

000000008000480e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000480e:	7139                	addi	sp,sp,-64
    80004810:	fc06                	sd	ra,56(sp)
    80004812:	f822                	sd	s0,48(sp)
    80004814:	f426                	sd	s1,40(sp)
    80004816:	f04a                	sd	s2,32(sp)
    80004818:	ec4e                	sd	s3,24(sp)
    8000481a:	e852                	sd	s4,16(sp)
    8000481c:	e456                	sd	s5,8(sp)
    8000481e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004820:	0001f497          	auipc	s1,0x1f
    80004824:	47848493          	addi	s1,s1,1144 # 80023c98 <log>
    80004828:	8526                	mv	a0,s1
    8000482a:	ffffc097          	auipc	ra,0xffffc
    8000482e:	3a6080e7          	jalr	934(ra) # 80000bd0 <acquire>
  log.outstanding -= 1;
    80004832:	509c                	lw	a5,32(s1)
    80004834:	37fd                	addiw	a5,a5,-1
    80004836:	0007891b          	sext.w	s2,a5
    8000483a:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000483c:	50dc                	lw	a5,36(s1)
    8000483e:	e7b9                	bnez	a5,8000488c <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80004840:	04091e63          	bnez	s2,8000489c <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004844:	0001f497          	auipc	s1,0x1f
    80004848:	45448493          	addi	s1,s1,1108 # 80023c98 <log>
    8000484c:	4785                	li	a5,1
    8000484e:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004850:	8526                	mv	a0,s1
    80004852:	ffffc097          	auipc	ra,0xffffc
    80004856:	432080e7          	jalr	1074(ra) # 80000c84 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000485a:	54dc                	lw	a5,44(s1)
    8000485c:	06f04763          	bgtz	a5,800048ca <end_op+0xbc>
    acquire(&log.lock);
    80004860:	0001f497          	auipc	s1,0x1f
    80004864:	43848493          	addi	s1,s1,1080 # 80023c98 <log>
    80004868:	8526                	mv	a0,s1
    8000486a:	ffffc097          	auipc	ra,0xffffc
    8000486e:	366080e7          	jalr	870(ra) # 80000bd0 <acquire>
    log.committing = 0;
    80004872:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004876:	8526                	mv	a0,s1
    80004878:	ffffe097          	auipc	ra,0xffffe
    8000487c:	9d2080e7          	jalr	-1582(ra) # 8000224a <wakeup>
    release(&log.lock);
    80004880:	8526                	mv	a0,s1
    80004882:	ffffc097          	auipc	ra,0xffffc
    80004886:	402080e7          	jalr	1026(ra) # 80000c84 <release>
}
    8000488a:	a03d                	j	800048b8 <end_op+0xaa>
    panic("log.committing");
    8000488c:	00004517          	auipc	a0,0x4
    80004890:	ee450513          	addi	a0,a0,-284 # 80008770 <syscalls+0x1f8>
    80004894:	ffffc097          	auipc	ra,0xffffc
    80004898:	ca6080e7          	jalr	-858(ra) # 8000053a <panic>
    wakeup(&log);
    8000489c:	0001f497          	auipc	s1,0x1f
    800048a0:	3fc48493          	addi	s1,s1,1020 # 80023c98 <log>
    800048a4:	8526                	mv	a0,s1
    800048a6:	ffffe097          	auipc	ra,0xffffe
    800048aa:	9a4080e7          	jalr	-1628(ra) # 8000224a <wakeup>
  release(&log.lock);
    800048ae:	8526                	mv	a0,s1
    800048b0:	ffffc097          	auipc	ra,0xffffc
    800048b4:	3d4080e7          	jalr	980(ra) # 80000c84 <release>
}
    800048b8:	70e2                	ld	ra,56(sp)
    800048ba:	7442                	ld	s0,48(sp)
    800048bc:	74a2                	ld	s1,40(sp)
    800048be:	7902                	ld	s2,32(sp)
    800048c0:	69e2                	ld	s3,24(sp)
    800048c2:	6a42                	ld	s4,16(sp)
    800048c4:	6aa2                	ld	s5,8(sp)
    800048c6:	6121                	addi	sp,sp,64
    800048c8:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800048ca:	0001fa97          	auipc	s5,0x1f
    800048ce:	3fea8a93          	addi	s5,s5,1022 # 80023cc8 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800048d2:	0001fa17          	auipc	s4,0x1f
    800048d6:	3c6a0a13          	addi	s4,s4,966 # 80023c98 <log>
    800048da:	018a2583          	lw	a1,24(s4)
    800048de:	012585bb          	addw	a1,a1,s2
    800048e2:	2585                	addiw	a1,a1,1
    800048e4:	028a2503          	lw	a0,40(s4)
    800048e8:	fffff097          	auipc	ra,0xfffff
    800048ec:	cca080e7          	jalr	-822(ra) # 800035b2 <bread>
    800048f0:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800048f2:	000aa583          	lw	a1,0(s5)
    800048f6:	028a2503          	lw	a0,40(s4)
    800048fa:	fffff097          	auipc	ra,0xfffff
    800048fe:	cb8080e7          	jalr	-840(ra) # 800035b2 <bread>
    80004902:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004904:	40000613          	li	a2,1024
    80004908:	05850593          	addi	a1,a0,88
    8000490c:	05848513          	addi	a0,s1,88
    80004910:	ffffc097          	auipc	ra,0xffffc
    80004914:	418080e7          	jalr	1048(ra) # 80000d28 <memmove>
    bwrite(to);  // write the log
    80004918:	8526                	mv	a0,s1
    8000491a:	fffff097          	auipc	ra,0xfffff
    8000491e:	d8a080e7          	jalr	-630(ra) # 800036a4 <bwrite>
    brelse(from);
    80004922:	854e                	mv	a0,s3
    80004924:	fffff097          	auipc	ra,0xfffff
    80004928:	dbe080e7          	jalr	-578(ra) # 800036e2 <brelse>
    brelse(to);
    8000492c:	8526                	mv	a0,s1
    8000492e:	fffff097          	auipc	ra,0xfffff
    80004932:	db4080e7          	jalr	-588(ra) # 800036e2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004936:	2905                	addiw	s2,s2,1
    80004938:	0a91                	addi	s5,s5,4
    8000493a:	02ca2783          	lw	a5,44(s4)
    8000493e:	f8f94ee3          	blt	s2,a5,800048da <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004942:	00000097          	auipc	ra,0x0
    80004946:	c68080e7          	jalr	-920(ra) # 800045aa <write_head>
    install_trans(0); // Now install writes to home locations
    8000494a:	4501                	li	a0,0
    8000494c:	00000097          	auipc	ra,0x0
    80004950:	cda080e7          	jalr	-806(ra) # 80004626 <install_trans>
    log.lh.n = 0;
    80004954:	0001f797          	auipc	a5,0x1f
    80004958:	3607a823          	sw	zero,880(a5) # 80023cc4 <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000495c:	00000097          	auipc	ra,0x0
    80004960:	c4e080e7          	jalr	-946(ra) # 800045aa <write_head>
    80004964:	bdf5                	j	80004860 <end_op+0x52>

0000000080004966 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004966:	1101                	addi	sp,sp,-32
    80004968:	ec06                	sd	ra,24(sp)
    8000496a:	e822                	sd	s0,16(sp)
    8000496c:	e426                	sd	s1,8(sp)
    8000496e:	e04a                	sd	s2,0(sp)
    80004970:	1000                	addi	s0,sp,32
    80004972:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004974:	0001f917          	auipc	s2,0x1f
    80004978:	32490913          	addi	s2,s2,804 # 80023c98 <log>
    8000497c:	854a                	mv	a0,s2
    8000497e:	ffffc097          	auipc	ra,0xffffc
    80004982:	252080e7          	jalr	594(ra) # 80000bd0 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004986:	02c92603          	lw	a2,44(s2)
    8000498a:	47f5                	li	a5,29
    8000498c:	06c7c563          	blt	a5,a2,800049f6 <log_write+0x90>
    80004990:	0001f797          	auipc	a5,0x1f
    80004994:	3247a783          	lw	a5,804(a5) # 80023cb4 <log+0x1c>
    80004998:	37fd                	addiw	a5,a5,-1
    8000499a:	04f65e63          	bge	a2,a5,800049f6 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000499e:	0001f797          	auipc	a5,0x1f
    800049a2:	31a7a783          	lw	a5,794(a5) # 80023cb8 <log+0x20>
    800049a6:	06f05063          	blez	a5,80004a06 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800049aa:	4781                	li	a5,0
    800049ac:	06c05563          	blez	a2,80004a16 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800049b0:	44cc                	lw	a1,12(s1)
    800049b2:	0001f717          	auipc	a4,0x1f
    800049b6:	31670713          	addi	a4,a4,790 # 80023cc8 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800049ba:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800049bc:	4314                	lw	a3,0(a4)
    800049be:	04b68c63          	beq	a3,a1,80004a16 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800049c2:	2785                	addiw	a5,a5,1
    800049c4:	0711                	addi	a4,a4,4
    800049c6:	fef61be3          	bne	a2,a5,800049bc <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800049ca:	0621                	addi	a2,a2,8
    800049cc:	060a                	slli	a2,a2,0x2
    800049ce:	0001f797          	auipc	a5,0x1f
    800049d2:	2ca78793          	addi	a5,a5,714 # 80023c98 <log>
    800049d6:	97b2                	add	a5,a5,a2
    800049d8:	44d8                	lw	a4,12(s1)
    800049da:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800049dc:	8526                	mv	a0,s1
    800049de:	fffff097          	auipc	ra,0xfffff
    800049e2:	da2080e7          	jalr	-606(ra) # 80003780 <bpin>
    log.lh.n++;
    800049e6:	0001f717          	auipc	a4,0x1f
    800049ea:	2b270713          	addi	a4,a4,690 # 80023c98 <log>
    800049ee:	575c                	lw	a5,44(a4)
    800049f0:	2785                	addiw	a5,a5,1
    800049f2:	d75c                	sw	a5,44(a4)
    800049f4:	a82d                	j	80004a2e <log_write+0xc8>
    panic("too big a transaction");
    800049f6:	00004517          	auipc	a0,0x4
    800049fa:	d8a50513          	addi	a0,a0,-630 # 80008780 <syscalls+0x208>
    800049fe:	ffffc097          	auipc	ra,0xffffc
    80004a02:	b3c080e7          	jalr	-1220(ra) # 8000053a <panic>
    panic("log_write outside of trans");
    80004a06:	00004517          	auipc	a0,0x4
    80004a0a:	d9250513          	addi	a0,a0,-622 # 80008798 <syscalls+0x220>
    80004a0e:	ffffc097          	auipc	ra,0xffffc
    80004a12:	b2c080e7          	jalr	-1236(ra) # 8000053a <panic>
  log.lh.block[i] = b->blockno;
    80004a16:	00878693          	addi	a3,a5,8
    80004a1a:	068a                	slli	a3,a3,0x2
    80004a1c:	0001f717          	auipc	a4,0x1f
    80004a20:	27c70713          	addi	a4,a4,636 # 80023c98 <log>
    80004a24:	9736                	add	a4,a4,a3
    80004a26:	44d4                	lw	a3,12(s1)
    80004a28:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004a2a:	faf609e3          	beq	a2,a5,800049dc <log_write+0x76>
  }
  release(&log.lock);
    80004a2e:	0001f517          	auipc	a0,0x1f
    80004a32:	26a50513          	addi	a0,a0,618 # 80023c98 <log>
    80004a36:	ffffc097          	auipc	ra,0xffffc
    80004a3a:	24e080e7          	jalr	590(ra) # 80000c84 <release>
}
    80004a3e:	60e2                	ld	ra,24(sp)
    80004a40:	6442                	ld	s0,16(sp)
    80004a42:	64a2                	ld	s1,8(sp)
    80004a44:	6902                	ld	s2,0(sp)
    80004a46:	6105                	addi	sp,sp,32
    80004a48:	8082                	ret

0000000080004a4a <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004a4a:	1101                	addi	sp,sp,-32
    80004a4c:	ec06                	sd	ra,24(sp)
    80004a4e:	e822                	sd	s0,16(sp)
    80004a50:	e426                	sd	s1,8(sp)
    80004a52:	e04a                	sd	s2,0(sp)
    80004a54:	1000                	addi	s0,sp,32
    80004a56:	84aa                	mv	s1,a0
    80004a58:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004a5a:	00004597          	auipc	a1,0x4
    80004a5e:	d5e58593          	addi	a1,a1,-674 # 800087b8 <syscalls+0x240>
    80004a62:	0521                	addi	a0,a0,8
    80004a64:	ffffc097          	auipc	ra,0xffffc
    80004a68:	0dc080e7          	jalr	220(ra) # 80000b40 <initlock>
  lk->name = name;
    80004a6c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004a70:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004a74:	0204a423          	sw	zero,40(s1)
}
    80004a78:	60e2                	ld	ra,24(sp)
    80004a7a:	6442                	ld	s0,16(sp)
    80004a7c:	64a2                	ld	s1,8(sp)
    80004a7e:	6902                	ld	s2,0(sp)
    80004a80:	6105                	addi	sp,sp,32
    80004a82:	8082                	ret

0000000080004a84 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004a84:	1101                	addi	sp,sp,-32
    80004a86:	ec06                	sd	ra,24(sp)
    80004a88:	e822                	sd	s0,16(sp)
    80004a8a:	e426                	sd	s1,8(sp)
    80004a8c:	e04a                	sd	s2,0(sp)
    80004a8e:	1000                	addi	s0,sp,32
    80004a90:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004a92:	00850913          	addi	s2,a0,8
    80004a96:	854a                	mv	a0,s2
    80004a98:	ffffc097          	auipc	ra,0xffffc
    80004a9c:	138080e7          	jalr	312(ra) # 80000bd0 <acquire>
  while (lk->locked) {
    80004aa0:	409c                	lw	a5,0(s1)
    80004aa2:	cb89                	beqz	a5,80004ab4 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004aa4:	85ca                	mv	a1,s2
    80004aa6:	8526                	mv	a0,s1
    80004aa8:	ffffd097          	auipc	ra,0xffffd
    80004aac:	616080e7          	jalr	1558(ra) # 800020be <sleep>
  while (lk->locked) {
    80004ab0:	409c                	lw	a5,0(s1)
    80004ab2:	fbed                	bnez	a5,80004aa4 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004ab4:	4785                	li	a5,1
    80004ab6:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004ab8:	ffffd097          	auipc	ra,0xffffd
    80004abc:	f20080e7          	jalr	-224(ra) # 800019d8 <myproc>
    80004ac0:	591c                	lw	a5,48(a0)
    80004ac2:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004ac4:	854a                	mv	a0,s2
    80004ac6:	ffffc097          	auipc	ra,0xffffc
    80004aca:	1be080e7          	jalr	446(ra) # 80000c84 <release>
}
    80004ace:	60e2                	ld	ra,24(sp)
    80004ad0:	6442                	ld	s0,16(sp)
    80004ad2:	64a2                	ld	s1,8(sp)
    80004ad4:	6902                	ld	s2,0(sp)
    80004ad6:	6105                	addi	sp,sp,32
    80004ad8:	8082                	ret

0000000080004ada <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004ada:	1101                	addi	sp,sp,-32
    80004adc:	ec06                	sd	ra,24(sp)
    80004ade:	e822                	sd	s0,16(sp)
    80004ae0:	e426                	sd	s1,8(sp)
    80004ae2:	e04a                	sd	s2,0(sp)
    80004ae4:	1000                	addi	s0,sp,32
    80004ae6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004ae8:	00850913          	addi	s2,a0,8
    80004aec:	854a                	mv	a0,s2
    80004aee:	ffffc097          	auipc	ra,0xffffc
    80004af2:	0e2080e7          	jalr	226(ra) # 80000bd0 <acquire>
  lk->locked = 0;
    80004af6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004afa:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004afe:	8526                	mv	a0,s1
    80004b00:	ffffd097          	auipc	ra,0xffffd
    80004b04:	74a080e7          	jalr	1866(ra) # 8000224a <wakeup>
  release(&lk->lk);
    80004b08:	854a                	mv	a0,s2
    80004b0a:	ffffc097          	auipc	ra,0xffffc
    80004b0e:	17a080e7          	jalr	378(ra) # 80000c84 <release>
}
    80004b12:	60e2                	ld	ra,24(sp)
    80004b14:	6442                	ld	s0,16(sp)
    80004b16:	64a2                	ld	s1,8(sp)
    80004b18:	6902                	ld	s2,0(sp)
    80004b1a:	6105                	addi	sp,sp,32
    80004b1c:	8082                	ret

0000000080004b1e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004b1e:	7179                	addi	sp,sp,-48
    80004b20:	f406                	sd	ra,40(sp)
    80004b22:	f022                	sd	s0,32(sp)
    80004b24:	ec26                	sd	s1,24(sp)
    80004b26:	e84a                	sd	s2,16(sp)
    80004b28:	e44e                	sd	s3,8(sp)
    80004b2a:	1800                	addi	s0,sp,48
    80004b2c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004b2e:	00850913          	addi	s2,a0,8
    80004b32:	854a                	mv	a0,s2
    80004b34:	ffffc097          	auipc	ra,0xffffc
    80004b38:	09c080e7          	jalr	156(ra) # 80000bd0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004b3c:	409c                	lw	a5,0(s1)
    80004b3e:	ef99                	bnez	a5,80004b5c <holdingsleep+0x3e>
    80004b40:	4481                	li	s1,0
  release(&lk->lk);
    80004b42:	854a                	mv	a0,s2
    80004b44:	ffffc097          	auipc	ra,0xffffc
    80004b48:	140080e7          	jalr	320(ra) # 80000c84 <release>
  return r;
}
    80004b4c:	8526                	mv	a0,s1
    80004b4e:	70a2                	ld	ra,40(sp)
    80004b50:	7402                	ld	s0,32(sp)
    80004b52:	64e2                	ld	s1,24(sp)
    80004b54:	6942                	ld	s2,16(sp)
    80004b56:	69a2                	ld	s3,8(sp)
    80004b58:	6145                	addi	sp,sp,48
    80004b5a:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004b5c:	0284a983          	lw	s3,40(s1)
    80004b60:	ffffd097          	auipc	ra,0xffffd
    80004b64:	e78080e7          	jalr	-392(ra) # 800019d8 <myproc>
    80004b68:	5904                	lw	s1,48(a0)
    80004b6a:	413484b3          	sub	s1,s1,s3
    80004b6e:	0014b493          	seqz	s1,s1
    80004b72:	bfc1                	j	80004b42 <holdingsleep+0x24>

0000000080004b74 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004b74:	1141                	addi	sp,sp,-16
    80004b76:	e406                	sd	ra,8(sp)
    80004b78:	e022                	sd	s0,0(sp)
    80004b7a:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004b7c:	00004597          	auipc	a1,0x4
    80004b80:	c4c58593          	addi	a1,a1,-948 # 800087c8 <syscalls+0x250>
    80004b84:	0001f517          	auipc	a0,0x1f
    80004b88:	25c50513          	addi	a0,a0,604 # 80023de0 <ftable>
    80004b8c:	ffffc097          	auipc	ra,0xffffc
    80004b90:	fb4080e7          	jalr	-76(ra) # 80000b40 <initlock>
}
    80004b94:	60a2                	ld	ra,8(sp)
    80004b96:	6402                	ld	s0,0(sp)
    80004b98:	0141                	addi	sp,sp,16
    80004b9a:	8082                	ret

0000000080004b9c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004b9c:	1101                	addi	sp,sp,-32
    80004b9e:	ec06                	sd	ra,24(sp)
    80004ba0:	e822                	sd	s0,16(sp)
    80004ba2:	e426                	sd	s1,8(sp)
    80004ba4:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004ba6:	0001f517          	auipc	a0,0x1f
    80004baa:	23a50513          	addi	a0,a0,570 # 80023de0 <ftable>
    80004bae:	ffffc097          	auipc	ra,0xffffc
    80004bb2:	022080e7          	jalr	34(ra) # 80000bd0 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004bb6:	0001f497          	auipc	s1,0x1f
    80004bba:	24248493          	addi	s1,s1,578 # 80023df8 <ftable+0x18>
    80004bbe:	00020717          	auipc	a4,0x20
    80004bc2:	1da70713          	addi	a4,a4,474 # 80024d98 <ftable+0xfb8>
    if(f->ref == 0){
    80004bc6:	40dc                	lw	a5,4(s1)
    80004bc8:	cf99                	beqz	a5,80004be6 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004bca:	02848493          	addi	s1,s1,40
    80004bce:	fee49ce3          	bne	s1,a4,80004bc6 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004bd2:	0001f517          	auipc	a0,0x1f
    80004bd6:	20e50513          	addi	a0,a0,526 # 80023de0 <ftable>
    80004bda:	ffffc097          	auipc	ra,0xffffc
    80004bde:	0aa080e7          	jalr	170(ra) # 80000c84 <release>
  return 0;
    80004be2:	4481                	li	s1,0
    80004be4:	a819                	j	80004bfa <filealloc+0x5e>
      f->ref = 1;
    80004be6:	4785                	li	a5,1
    80004be8:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004bea:	0001f517          	auipc	a0,0x1f
    80004bee:	1f650513          	addi	a0,a0,502 # 80023de0 <ftable>
    80004bf2:	ffffc097          	auipc	ra,0xffffc
    80004bf6:	092080e7          	jalr	146(ra) # 80000c84 <release>
}
    80004bfa:	8526                	mv	a0,s1
    80004bfc:	60e2                	ld	ra,24(sp)
    80004bfe:	6442                	ld	s0,16(sp)
    80004c00:	64a2                	ld	s1,8(sp)
    80004c02:	6105                	addi	sp,sp,32
    80004c04:	8082                	ret

0000000080004c06 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004c06:	1101                	addi	sp,sp,-32
    80004c08:	ec06                	sd	ra,24(sp)
    80004c0a:	e822                	sd	s0,16(sp)
    80004c0c:	e426                	sd	s1,8(sp)
    80004c0e:	1000                	addi	s0,sp,32
    80004c10:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004c12:	0001f517          	auipc	a0,0x1f
    80004c16:	1ce50513          	addi	a0,a0,462 # 80023de0 <ftable>
    80004c1a:	ffffc097          	auipc	ra,0xffffc
    80004c1e:	fb6080e7          	jalr	-74(ra) # 80000bd0 <acquire>
  if(f->ref < 1)
    80004c22:	40dc                	lw	a5,4(s1)
    80004c24:	02f05263          	blez	a5,80004c48 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004c28:	2785                	addiw	a5,a5,1
    80004c2a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004c2c:	0001f517          	auipc	a0,0x1f
    80004c30:	1b450513          	addi	a0,a0,436 # 80023de0 <ftable>
    80004c34:	ffffc097          	auipc	ra,0xffffc
    80004c38:	050080e7          	jalr	80(ra) # 80000c84 <release>
  return f;
}
    80004c3c:	8526                	mv	a0,s1
    80004c3e:	60e2                	ld	ra,24(sp)
    80004c40:	6442                	ld	s0,16(sp)
    80004c42:	64a2                	ld	s1,8(sp)
    80004c44:	6105                	addi	sp,sp,32
    80004c46:	8082                	ret
    panic("filedup");
    80004c48:	00004517          	auipc	a0,0x4
    80004c4c:	b8850513          	addi	a0,a0,-1144 # 800087d0 <syscalls+0x258>
    80004c50:	ffffc097          	auipc	ra,0xffffc
    80004c54:	8ea080e7          	jalr	-1814(ra) # 8000053a <panic>

0000000080004c58 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004c58:	7139                	addi	sp,sp,-64
    80004c5a:	fc06                	sd	ra,56(sp)
    80004c5c:	f822                	sd	s0,48(sp)
    80004c5e:	f426                	sd	s1,40(sp)
    80004c60:	f04a                	sd	s2,32(sp)
    80004c62:	ec4e                	sd	s3,24(sp)
    80004c64:	e852                	sd	s4,16(sp)
    80004c66:	e456                	sd	s5,8(sp)
    80004c68:	0080                	addi	s0,sp,64
    80004c6a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004c6c:	0001f517          	auipc	a0,0x1f
    80004c70:	17450513          	addi	a0,a0,372 # 80023de0 <ftable>
    80004c74:	ffffc097          	auipc	ra,0xffffc
    80004c78:	f5c080e7          	jalr	-164(ra) # 80000bd0 <acquire>
  if(f->ref < 1)
    80004c7c:	40dc                	lw	a5,4(s1)
    80004c7e:	06f05163          	blez	a5,80004ce0 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004c82:	37fd                	addiw	a5,a5,-1
    80004c84:	0007871b          	sext.w	a4,a5
    80004c88:	c0dc                	sw	a5,4(s1)
    80004c8a:	06e04363          	bgtz	a4,80004cf0 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004c8e:	0004a903          	lw	s2,0(s1)
    80004c92:	0094ca83          	lbu	s5,9(s1)
    80004c96:	0104ba03          	ld	s4,16(s1)
    80004c9a:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004c9e:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004ca2:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004ca6:	0001f517          	auipc	a0,0x1f
    80004caa:	13a50513          	addi	a0,a0,314 # 80023de0 <ftable>
    80004cae:	ffffc097          	auipc	ra,0xffffc
    80004cb2:	fd6080e7          	jalr	-42(ra) # 80000c84 <release>

  if(ff.type == FD_PIPE){
    80004cb6:	4785                	li	a5,1
    80004cb8:	04f90d63          	beq	s2,a5,80004d12 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004cbc:	3979                	addiw	s2,s2,-2
    80004cbe:	4785                	li	a5,1
    80004cc0:	0527e063          	bltu	a5,s2,80004d00 <fileclose+0xa8>
    begin_op();
    80004cc4:	00000097          	auipc	ra,0x0
    80004cc8:	acc080e7          	jalr	-1332(ra) # 80004790 <begin_op>
    iput(ff.ip);
    80004ccc:	854e                	mv	a0,s3
    80004cce:	fffff097          	auipc	ra,0xfffff
    80004cd2:	2a0080e7          	jalr	672(ra) # 80003f6e <iput>
    end_op();
    80004cd6:	00000097          	auipc	ra,0x0
    80004cda:	b38080e7          	jalr	-1224(ra) # 8000480e <end_op>
    80004cde:	a00d                	j	80004d00 <fileclose+0xa8>
    panic("fileclose");
    80004ce0:	00004517          	auipc	a0,0x4
    80004ce4:	af850513          	addi	a0,a0,-1288 # 800087d8 <syscalls+0x260>
    80004ce8:	ffffc097          	auipc	ra,0xffffc
    80004cec:	852080e7          	jalr	-1966(ra) # 8000053a <panic>
    release(&ftable.lock);
    80004cf0:	0001f517          	auipc	a0,0x1f
    80004cf4:	0f050513          	addi	a0,a0,240 # 80023de0 <ftable>
    80004cf8:	ffffc097          	auipc	ra,0xffffc
    80004cfc:	f8c080e7          	jalr	-116(ra) # 80000c84 <release>
  }
}
    80004d00:	70e2                	ld	ra,56(sp)
    80004d02:	7442                	ld	s0,48(sp)
    80004d04:	74a2                	ld	s1,40(sp)
    80004d06:	7902                	ld	s2,32(sp)
    80004d08:	69e2                	ld	s3,24(sp)
    80004d0a:	6a42                	ld	s4,16(sp)
    80004d0c:	6aa2                	ld	s5,8(sp)
    80004d0e:	6121                	addi	sp,sp,64
    80004d10:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004d12:	85d6                	mv	a1,s5
    80004d14:	8552                	mv	a0,s4
    80004d16:	00000097          	auipc	ra,0x0
    80004d1a:	34c080e7          	jalr	844(ra) # 80005062 <pipeclose>
    80004d1e:	b7cd                	j	80004d00 <fileclose+0xa8>

0000000080004d20 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004d20:	715d                	addi	sp,sp,-80
    80004d22:	e486                	sd	ra,72(sp)
    80004d24:	e0a2                	sd	s0,64(sp)
    80004d26:	fc26                	sd	s1,56(sp)
    80004d28:	f84a                	sd	s2,48(sp)
    80004d2a:	f44e                	sd	s3,40(sp)
    80004d2c:	0880                	addi	s0,sp,80
    80004d2e:	84aa                	mv	s1,a0
    80004d30:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004d32:	ffffd097          	auipc	ra,0xffffd
    80004d36:	ca6080e7          	jalr	-858(ra) # 800019d8 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004d3a:	409c                	lw	a5,0(s1)
    80004d3c:	37f9                	addiw	a5,a5,-2
    80004d3e:	4705                	li	a4,1
    80004d40:	04f76763          	bltu	a4,a5,80004d8e <filestat+0x6e>
    80004d44:	892a                	mv	s2,a0
    ilock(f->ip);
    80004d46:	6c88                	ld	a0,24(s1)
    80004d48:	fffff097          	auipc	ra,0xfffff
    80004d4c:	06c080e7          	jalr	108(ra) # 80003db4 <ilock>
    stati(f->ip, &st);
    80004d50:	fb840593          	addi	a1,s0,-72
    80004d54:	6c88                	ld	a0,24(s1)
    80004d56:	fffff097          	auipc	ra,0xfffff
    80004d5a:	2e8080e7          	jalr	744(ra) # 8000403e <stati>
    iunlock(f->ip);
    80004d5e:	6c88                	ld	a0,24(s1)
    80004d60:	fffff097          	auipc	ra,0xfffff
    80004d64:	116080e7          	jalr	278(ra) # 80003e76 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004d68:	46e1                	li	a3,24
    80004d6a:	fb840613          	addi	a2,s0,-72
    80004d6e:	85ce                	mv	a1,s3
    80004d70:	05093503          	ld	a0,80(s2)
    80004d74:	ffffd097          	auipc	ra,0xffffd
    80004d78:	8ee080e7          	jalr	-1810(ra) # 80001662 <copyout>
    80004d7c:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004d80:	60a6                	ld	ra,72(sp)
    80004d82:	6406                	ld	s0,64(sp)
    80004d84:	74e2                	ld	s1,56(sp)
    80004d86:	7942                	ld	s2,48(sp)
    80004d88:	79a2                	ld	s3,40(sp)
    80004d8a:	6161                	addi	sp,sp,80
    80004d8c:	8082                	ret
  return -1;
    80004d8e:	557d                	li	a0,-1
    80004d90:	bfc5                	j	80004d80 <filestat+0x60>

0000000080004d92 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004d92:	7179                	addi	sp,sp,-48
    80004d94:	f406                	sd	ra,40(sp)
    80004d96:	f022                	sd	s0,32(sp)
    80004d98:	ec26                	sd	s1,24(sp)
    80004d9a:	e84a                	sd	s2,16(sp)
    80004d9c:	e44e                	sd	s3,8(sp)
    80004d9e:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004da0:	00854783          	lbu	a5,8(a0)
    80004da4:	c3d5                	beqz	a5,80004e48 <fileread+0xb6>
    80004da6:	84aa                	mv	s1,a0
    80004da8:	89ae                	mv	s3,a1
    80004daa:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004dac:	411c                	lw	a5,0(a0)
    80004dae:	4705                	li	a4,1
    80004db0:	04e78963          	beq	a5,a4,80004e02 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004db4:	470d                	li	a4,3
    80004db6:	04e78d63          	beq	a5,a4,80004e10 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004dba:	4709                	li	a4,2
    80004dbc:	06e79e63          	bne	a5,a4,80004e38 <fileread+0xa6>
    ilock(f->ip);
    80004dc0:	6d08                	ld	a0,24(a0)
    80004dc2:	fffff097          	auipc	ra,0xfffff
    80004dc6:	ff2080e7          	jalr	-14(ra) # 80003db4 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004dca:	874a                	mv	a4,s2
    80004dcc:	5094                	lw	a3,32(s1)
    80004dce:	864e                	mv	a2,s3
    80004dd0:	4585                	li	a1,1
    80004dd2:	6c88                	ld	a0,24(s1)
    80004dd4:	fffff097          	auipc	ra,0xfffff
    80004dd8:	294080e7          	jalr	660(ra) # 80004068 <readi>
    80004ddc:	892a                	mv	s2,a0
    80004dde:	00a05563          	blez	a0,80004de8 <fileread+0x56>
      f->off += r;
    80004de2:	509c                	lw	a5,32(s1)
    80004de4:	9fa9                	addw	a5,a5,a0
    80004de6:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004de8:	6c88                	ld	a0,24(s1)
    80004dea:	fffff097          	auipc	ra,0xfffff
    80004dee:	08c080e7          	jalr	140(ra) # 80003e76 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004df2:	854a                	mv	a0,s2
    80004df4:	70a2                	ld	ra,40(sp)
    80004df6:	7402                	ld	s0,32(sp)
    80004df8:	64e2                	ld	s1,24(sp)
    80004dfa:	6942                	ld	s2,16(sp)
    80004dfc:	69a2                	ld	s3,8(sp)
    80004dfe:	6145                	addi	sp,sp,48
    80004e00:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004e02:	6908                	ld	a0,16(a0)
    80004e04:	00000097          	auipc	ra,0x0
    80004e08:	3c0080e7          	jalr	960(ra) # 800051c4 <piperead>
    80004e0c:	892a                	mv	s2,a0
    80004e0e:	b7d5                	j	80004df2 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004e10:	02451783          	lh	a5,36(a0)
    80004e14:	03079693          	slli	a3,a5,0x30
    80004e18:	92c1                	srli	a3,a3,0x30
    80004e1a:	4725                	li	a4,9
    80004e1c:	02d76863          	bltu	a4,a3,80004e4c <fileread+0xba>
    80004e20:	0792                	slli	a5,a5,0x4
    80004e22:	0001f717          	auipc	a4,0x1f
    80004e26:	f1e70713          	addi	a4,a4,-226 # 80023d40 <devsw>
    80004e2a:	97ba                	add	a5,a5,a4
    80004e2c:	639c                	ld	a5,0(a5)
    80004e2e:	c38d                	beqz	a5,80004e50 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004e30:	4505                	li	a0,1
    80004e32:	9782                	jalr	a5
    80004e34:	892a                	mv	s2,a0
    80004e36:	bf75                	j	80004df2 <fileread+0x60>
    panic("fileread");
    80004e38:	00004517          	auipc	a0,0x4
    80004e3c:	9b050513          	addi	a0,a0,-1616 # 800087e8 <syscalls+0x270>
    80004e40:	ffffb097          	auipc	ra,0xffffb
    80004e44:	6fa080e7          	jalr	1786(ra) # 8000053a <panic>
    return -1;
    80004e48:	597d                	li	s2,-1
    80004e4a:	b765                	j	80004df2 <fileread+0x60>
      return -1;
    80004e4c:	597d                	li	s2,-1
    80004e4e:	b755                	j	80004df2 <fileread+0x60>
    80004e50:	597d                	li	s2,-1
    80004e52:	b745                	j	80004df2 <fileread+0x60>

0000000080004e54 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80004e54:	715d                	addi	sp,sp,-80
    80004e56:	e486                	sd	ra,72(sp)
    80004e58:	e0a2                	sd	s0,64(sp)
    80004e5a:	fc26                	sd	s1,56(sp)
    80004e5c:	f84a                	sd	s2,48(sp)
    80004e5e:	f44e                	sd	s3,40(sp)
    80004e60:	f052                	sd	s4,32(sp)
    80004e62:	ec56                	sd	s5,24(sp)
    80004e64:	e85a                	sd	s6,16(sp)
    80004e66:	e45e                	sd	s7,8(sp)
    80004e68:	e062                	sd	s8,0(sp)
    80004e6a:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80004e6c:	00954783          	lbu	a5,9(a0)
    80004e70:	10078663          	beqz	a5,80004f7c <filewrite+0x128>
    80004e74:	892a                	mv	s2,a0
    80004e76:	8b2e                	mv	s6,a1
    80004e78:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004e7a:	411c                	lw	a5,0(a0)
    80004e7c:	4705                	li	a4,1
    80004e7e:	02e78263          	beq	a5,a4,80004ea2 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004e82:	470d                	li	a4,3
    80004e84:	02e78663          	beq	a5,a4,80004eb0 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004e88:	4709                	li	a4,2
    80004e8a:	0ee79163          	bne	a5,a4,80004f6c <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004e8e:	0ac05d63          	blez	a2,80004f48 <filewrite+0xf4>
    int i = 0;
    80004e92:	4981                	li	s3,0
    80004e94:	6b85                	lui	s7,0x1
    80004e96:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004e9a:	6c05                	lui	s8,0x1
    80004e9c:	c00c0c1b          	addiw	s8,s8,-1024
    80004ea0:	a861                	j	80004f38 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80004ea2:	6908                	ld	a0,16(a0)
    80004ea4:	00000097          	auipc	ra,0x0
    80004ea8:	22e080e7          	jalr	558(ra) # 800050d2 <pipewrite>
    80004eac:	8a2a                	mv	s4,a0
    80004eae:	a045                	j	80004f4e <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004eb0:	02451783          	lh	a5,36(a0)
    80004eb4:	03079693          	slli	a3,a5,0x30
    80004eb8:	92c1                	srli	a3,a3,0x30
    80004eba:	4725                	li	a4,9
    80004ebc:	0cd76263          	bltu	a4,a3,80004f80 <filewrite+0x12c>
    80004ec0:	0792                	slli	a5,a5,0x4
    80004ec2:	0001f717          	auipc	a4,0x1f
    80004ec6:	e7e70713          	addi	a4,a4,-386 # 80023d40 <devsw>
    80004eca:	97ba                	add	a5,a5,a4
    80004ecc:	679c                	ld	a5,8(a5)
    80004ece:	cbdd                	beqz	a5,80004f84 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80004ed0:	4505                	li	a0,1
    80004ed2:	9782                	jalr	a5
    80004ed4:	8a2a                	mv	s4,a0
    80004ed6:	a8a5                	j	80004f4e <filewrite+0xfa>
    80004ed8:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004edc:	00000097          	auipc	ra,0x0
    80004ee0:	8b4080e7          	jalr	-1868(ra) # 80004790 <begin_op>
      ilock(f->ip);
    80004ee4:	01893503          	ld	a0,24(s2)
    80004ee8:	fffff097          	auipc	ra,0xfffff
    80004eec:	ecc080e7          	jalr	-308(ra) # 80003db4 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004ef0:	8756                	mv	a4,s5
    80004ef2:	02092683          	lw	a3,32(s2)
    80004ef6:	01698633          	add	a2,s3,s6
    80004efa:	4585                	li	a1,1
    80004efc:	01893503          	ld	a0,24(s2)
    80004f00:	fffff097          	auipc	ra,0xfffff
    80004f04:	260080e7          	jalr	608(ra) # 80004160 <writei>
    80004f08:	84aa                	mv	s1,a0
    80004f0a:	00a05763          	blez	a0,80004f18 <filewrite+0xc4>
        f->off += r;
    80004f0e:	02092783          	lw	a5,32(s2)
    80004f12:	9fa9                	addw	a5,a5,a0
    80004f14:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004f18:	01893503          	ld	a0,24(s2)
    80004f1c:	fffff097          	auipc	ra,0xfffff
    80004f20:	f5a080e7          	jalr	-166(ra) # 80003e76 <iunlock>
      end_op();
    80004f24:	00000097          	auipc	ra,0x0
    80004f28:	8ea080e7          	jalr	-1814(ra) # 8000480e <end_op>

      if(r != n1){
    80004f2c:	009a9f63          	bne	s5,s1,80004f4a <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80004f30:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004f34:	0149db63          	bge	s3,s4,80004f4a <filewrite+0xf6>
      int n1 = n - i;
    80004f38:	413a04bb          	subw	s1,s4,s3
    80004f3c:	0004879b          	sext.w	a5,s1
    80004f40:	f8fbdce3          	bge	s7,a5,80004ed8 <filewrite+0x84>
    80004f44:	84e2                	mv	s1,s8
    80004f46:	bf49                	j	80004ed8 <filewrite+0x84>
    int i = 0;
    80004f48:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004f4a:	013a1f63          	bne	s4,s3,80004f68 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004f4e:	8552                	mv	a0,s4
    80004f50:	60a6                	ld	ra,72(sp)
    80004f52:	6406                	ld	s0,64(sp)
    80004f54:	74e2                	ld	s1,56(sp)
    80004f56:	7942                	ld	s2,48(sp)
    80004f58:	79a2                	ld	s3,40(sp)
    80004f5a:	7a02                	ld	s4,32(sp)
    80004f5c:	6ae2                	ld	s5,24(sp)
    80004f5e:	6b42                	ld	s6,16(sp)
    80004f60:	6ba2                	ld	s7,8(sp)
    80004f62:	6c02                	ld	s8,0(sp)
    80004f64:	6161                	addi	sp,sp,80
    80004f66:	8082                	ret
    ret = (i == n ? n : -1);
    80004f68:	5a7d                	li	s4,-1
    80004f6a:	b7d5                	j	80004f4e <filewrite+0xfa>
    panic("filewrite");
    80004f6c:	00004517          	auipc	a0,0x4
    80004f70:	88c50513          	addi	a0,a0,-1908 # 800087f8 <syscalls+0x280>
    80004f74:	ffffb097          	auipc	ra,0xffffb
    80004f78:	5c6080e7          	jalr	1478(ra) # 8000053a <panic>
    return -1;
    80004f7c:	5a7d                	li	s4,-1
    80004f7e:	bfc1                	j	80004f4e <filewrite+0xfa>
      return -1;
    80004f80:	5a7d                	li	s4,-1
    80004f82:	b7f1                	j	80004f4e <filewrite+0xfa>
    80004f84:	5a7d                	li	s4,-1
    80004f86:	b7e1                	j	80004f4e <filewrite+0xfa>

0000000080004f88 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004f88:	7179                	addi	sp,sp,-48
    80004f8a:	f406                	sd	ra,40(sp)
    80004f8c:	f022                	sd	s0,32(sp)
    80004f8e:	ec26                	sd	s1,24(sp)
    80004f90:	e84a                	sd	s2,16(sp)
    80004f92:	e44e                	sd	s3,8(sp)
    80004f94:	e052                	sd	s4,0(sp)
    80004f96:	1800                	addi	s0,sp,48
    80004f98:	84aa                	mv	s1,a0
    80004f9a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004f9c:	0005b023          	sd	zero,0(a1)
    80004fa0:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004fa4:	00000097          	auipc	ra,0x0
    80004fa8:	bf8080e7          	jalr	-1032(ra) # 80004b9c <filealloc>
    80004fac:	e088                	sd	a0,0(s1)
    80004fae:	c551                	beqz	a0,8000503a <pipealloc+0xb2>
    80004fb0:	00000097          	auipc	ra,0x0
    80004fb4:	bec080e7          	jalr	-1044(ra) # 80004b9c <filealloc>
    80004fb8:	00aa3023          	sd	a0,0(s4)
    80004fbc:	c92d                	beqz	a0,8000502e <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004fbe:	ffffc097          	auipc	ra,0xffffc
    80004fc2:	b22080e7          	jalr	-1246(ra) # 80000ae0 <kalloc>
    80004fc6:	892a                	mv	s2,a0
    80004fc8:	c125                	beqz	a0,80005028 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004fca:	4985                	li	s3,1
    80004fcc:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004fd0:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004fd4:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004fd8:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004fdc:	00003597          	auipc	a1,0x3
    80004fe0:	4e458593          	addi	a1,a1,1252 # 800084c0 <states.0+0x1b0>
    80004fe4:	ffffc097          	auipc	ra,0xffffc
    80004fe8:	b5c080e7          	jalr	-1188(ra) # 80000b40 <initlock>
  (*f0)->type = FD_PIPE;
    80004fec:	609c                	ld	a5,0(s1)
    80004fee:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004ff2:	609c                	ld	a5,0(s1)
    80004ff4:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004ff8:	609c                	ld	a5,0(s1)
    80004ffa:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004ffe:	609c                	ld	a5,0(s1)
    80005000:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80005004:	000a3783          	ld	a5,0(s4)
    80005008:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000500c:	000a3783          	ld	a5,0(s4)
    80005010:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80005014:	000a3783          	ld	a5,0(s4)
    80005018:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000501c:	000a3783          	ld	a5,0(s4)
    80005020:	0127b823          	sd	s2,16(a5)
  return 0;
    80005024:	4501                	li	a0,0
    80005026:	a025                	j	8000504e <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80005028:	6088                	ld	a0,0(s1)
    8000502a:	e501                	bnez	a0,80005032 <pipealloc+0xaa>
    8000502c:	a039                	j	8000503a <pipealloc+0xb2>
    8000502e:	6088                	ld	a0,0(s1)
    80005030:	c51d                	beqz	a0,8000505e <pipealloc+0xd6>
    fileclose(*f0);
    80005032:	00000097          	auipc	ra,0x0
    80005036:	c26080e7          	jalr	-986(ra) # 80004c58 <fileclose>
  if(*f1)
    8000503a:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000503e:	557d                	li	a0,-1
  if(*f1)
    80005040:	c799                	beqz	a5,8000504e <pipealloc+0xc6>
    fileclose(*f1);
    80005042:	853e                	mv	a0,a5
    80005044:	00000097          	auipc	ra,0x0
    80005048:	c14080e7          	jalr	-1004(ra) # 80004c58 <fileclose>
  return -1;
    8000504c:	557d                	li	a0,-1
}
    8000504e:	70a2                	ld	ra,40(sp)
    80005050:	7402                	ld	s0,32(sp)
    80005052:	64e2                	ld	s1,24(sp)
    80005054:	6942                	ld	s2,16(sp)
    80005056:	69a2                	ld	s3,8(sp)
    80005058:	6a02                	ld	s4,0(sp)
    8000505a:	6145                	addi	sp,sp,48
    8000505c:	8082                	ret
  return -1;
    8000505e:	557d                	li	a0,-1
    80005060:	b7fd                	j	8000504e <pipealloc+0xc6>

0000000080005062 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80005062:	1101                	addi	sp,sp,-32
    80005064:	ec06                	sd	ra,24(sp)
    80005066:	e822                	sd	s0,16(sp)
    80005068:	e426                	sd	s1,8(sp)
    8000506a:	e04a                	sd	s2,0(sp)
    8000506c:	1000                	addi	s0,sp,32
    8000506e:	84aa                	mv	s1,a0
    80005070:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80005072:	ffffc097          	auipc	ra,0xffffc
    80005076:	b5e080e7          	jalr	-1186(ra) # 80000bd0 <acquire>
  if(writable){
    8000507a:	02090d63          	beqz	s2,800050b4 <pipeclose+0x52>
    pi->writeopen = 0;
    8000507e:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80005082:	21848513          	addi	a0,s1,536
    80005086:	ffffd097          	auipc	ra,0xffffd
    8000508a:	1c4080e7          	jalr	452(ra) # 8000224a <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000508e:	2204b783          	ld	a5,544(s1)
    80005092:	eb95                	bnez	a5,800050c6 <pipeclose+0x64>
    release(&pi->lock);
    80005094:	8526                	mv	a0,s1
    80005096:	ffffc097          	auipc	ra,0xffffc
    8000509a:	bee080e7          	jalr	-1042(ra) # 80000c84 <release>
    kfree((char*)pi);
    8000509e:	8526                	mv	a0,s1
    800050a0:	ffffc097          	auipc	ra,0xffffc
    800050a4:	942080e7          	jalr	-1726(ra) # 800009e2 <kfree>
  } else
    release(&pi->lock);
}
    800050a8:	60e2                	ld	ra,24(sp)
    800050aa:	6442                	ld	s0,16(sp)
    800050ac:	64a2                	ld	s1,8(sp)
    800050ae:	6902                	ld	s2,0(sp)
    800050b0:	6105                	addi	sp,sp,32
    800050b2:	8082                	ret
    pi->readopen = 0;
    800050b4:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800050b8:	21c48513          	addi	a0,s1,540
    800050bc:	ffffd097          	auipc	ra,0xffffd
    800050c0:	18e080e7          	jalr	398(ra) # 8000224a <wakeup>
    800050c4:	b7e9                	j	8000508e <pipeclose+0x2c>
    release(&pi->lock);
    800050c6:	8526                	mv	a0,s1
    800050c8:	ffffc097          	auipc	ra,0xffffc
    800050cc:	bbc080e7          	jalr	-1092(ra) # 80000c84 <release>
}
    800050d0:	bfe1                	j	800050a8 <pipeclose+0x46>

00000000800050d2 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800050d2:	711d                	addi	sp,sp,-96
    800050d4:	ec86                	sd	ra,88(sp)
    800050d6:	e8a2                	sd	s0,80(sp)
    800050d8:	e4a6                	sd	s1,72(sp)
    800050da:	e0ca                	sd	s2,64(sp)
    800050dc:	fc4e                	sd	s3,56(sp)
    800050de:	f852                	sd	s4,48(sp)
    800050e0:	f456                	sd	s5,40(sp)
    800050e2:	f05a                	sd	s6,32(sp)
    800050e4:	ec5e                	sd	s7,24(sp)
    800050e6:	e862                	sd	s8,16(sp)
    800050e8:	1080                	addi	s0,sp,96
    800050ea:	84aa                	mv	s1,a0
    800050ec:	8aae                	mv	s5,a1
    800050ee:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800050f0:	ffffd097          	auipc	ra,0xffffd
    800050f4:	8e8080e7          	jalr	-1816(ra) # 800019d8 <myproc>
    800050f8:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800050fa:	8526                	mv	a0,s1
    800050fc:	ffffc097          	auipc	ra,0xffffc
    80005100:	ad4080e7          	jalr	-1324(ra) # 80000bd0 <acquire>
  while(i < n){
    80005104:	0b405363          	blez	s4,800051aa <pipewrite+0xd8>
  int i = 0;
    80005108:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000510a:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000510c:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80005110:	21c48b93          	addi	s7,s1,540
    80005114:	a089                	j	80005156 <pipewrite+0x84>
      release(&pi->lock);
    80005116:	8526                	mv	a0,s1
    80005118:	ffffc097          	auipc	ra,0xffffc
    8000511c:	b6c080e7          	jalr	-1172(ra) # 80000c84 <release>
      return -1;
    80005120:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80005122:	854a                	mv	a0,s2
    80005124:	60e6                	ld	ra,88(sp)
    80005126:	6446                	ld	s0,80(sp)
    80005128:	64a6                	ld	s1,72(sp)
    8000512a:	6906                	ld	s2,64(sp)
    8000512c:	79e2                	ld	s3,56(sp)
    8000512e:	7a42                	ld	s4,48(sp)
    80005130:	7aa2                	ld	s5,40(sp)
    80005132:	7b02                	ld	s6,32(sp)
    80005134:	6be2                	ld	s7,24(sp)
    80005136:	6c42                	ld	s8,16(sp)
    80005138:	6125                	addi	sp,sp,96
    8000513a:	8082                	ret
      wakeup(&pi->nread);
    8000513c:	8562                	mv	a0,s8
    8000513e:	ffffd097          	auipc	ra,0xffffd
    80005142:	10c080e7          	jalr	268(ra) # 8000224a <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80005146:	85a6                	mv	a1,s1
    80005148:	855e                	mv	a0,s7
    8000514a:	ffffd097          	auipc	ra,0xffffd
    8000514e:	f74080e7          	jalr	-140(ra) # 800020be <sleep>
  while(i < n){
    80005152:	05495d63          	bge	s2,s4,800051ac <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80005156:	2204a783          	lw	a5,544(s1)
    8000515a:	dfd5                	beqz	a5,80005116 <pipewrite+0x44>
    8000515c:	0289a783          	lw	a5,40(s3)
    80005160:	fbdd                	bnez	a5,80005116 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80005162:	2184a783          	lw	a5,536(s1)
    80005166:	21c4a703          	lw	a4,540(s1)
    8000516a:	2007879b          	addiw	a5,a5,512
    8000516e:	fcf707e3          	beq	a4,a5,8000513c <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80005172:	4685                	li	a3,1
    80005174:	01590633          	add	a2,s2,s5
    80005178:	faf40593          	addi	a1,s0,-81
    8000517c:	0509b503          	ld	a0,80(s3)
    80005180:	ffffc097          	auipc	ra,0xffffc
    80005184:	56e080e7          	jalr	1390(ra) # 800016ee <copyin>
    80005188:	03650263          	beq	a0,s6,800051ac <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000518c:	21c4a783          	lw	a5,540(s1)
    80005190:	0017871b          	addiw	a4,a5,1
    80005194:	20e4ae23          	sw	a4,540(s1)
    80005198:	1ff7f793          	andi	a5,a5,511
    8000519c:	97a6                	add	a5,a5,s1
    8000519e:	faf44703          	lbu	a4,-81(s0)
    800051a2:	00e78c23          	sb	a4,24(a5)
      i++;
    800051a6:	2905                	addiw	s2,s2,1
    800051a8:	b76d                	j	80005152 <pipewrite+0x80>
  int i = 0;
    800051aa:	4901                	li	s2,0
  wakeup(&pi->nread);
    800051ac:	21848513          	addi	a0,s1,536
    800051b0:	ffffd097          	auipc	ra,0xffffd
    800051b4:	09a080e7          	jalr	154(ra) # 8000224a <wakeup>
  release(&pi->lock);
    800051b8:	8526                	mv	a0,s1
    800051ba:	ffffc097          	auipc	ra,0xffffc
    800051be:	aca080e7          	jalr	-1334(ra) # 80000c84 <release>
  return i;
    800051c2:	b785                	j	80005122 <pipewrite+0x50>

00000000800051c4 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800051c4:	715d                	addi	sp,sp,-80
    800051c6:	e486                	sd	ra,72(sp)
    800051c8:	e0a2                	sd	s0,64(sp)
    800051ca:	fc26                	sd	s1,56(sp)
    800051cc:	f84a                	sd	s2,48(sp)
    800051ce:	f44e                	sd	s3,40(sp)
    800051d0:	f052                	sd	s4,32(sp)
    800051d2:	ec56                	sd	s5,24(sp)
    800051d4:	e85a                	sd	s6,16(sp)
    800051d6:	0880                	addi	s0,sp,80
    800051d8:	84aa                	mv	s1,a0
    800051da:	892e                	mv	s2,a1
    800051dc:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800051de:	ffffc097          	auipc	ra,0xffffc
    800051e2:	7fa080e7          	jalr	2042(ra) # 800019d8 <myproc>
    800051e6:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800051e8:	8526                	mv	a0,s1
    800051ea:	ffffc097          	auipc	ra,0xffffc
    800051ee:	9e6080e7          	jalr	-1562(ra) # 80000bd0 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800051f2:	2184a703          	lw	a4,536(s1)
    800051f6:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800051fa:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800051fe:	02f71463          	bne	a4,a5,80005226 <piperead+0x62>
    80005202:	2244a783          	lw	a5,548(s1)
    80005206:	c385                	beqz	a5,80005226 <piperead+0x62>
    if(pr->killed){
    80005208:	028a2783          	lw	a5,40(s4)
    8000520c:	ebc9                	bnez	a5,8000529e <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000520e:	85a6                	mv	a1,s1
    80005210:	854e                	mv	a0,s3
    80005212:	ffffd097          	auipc	ra,0xffffd
    80005216:	eac080e7          	jalr	-340(ra) # 800020be <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000521a:	2184a703          	lw	a4,536(s1)
    8000521e:	21c4a783          	lw	a5,540(s1)
    80005222:	fef700e3          	beq	a4,a5,80005202 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005226:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005228:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000522a:	05505463          	blez	s5,80005272 <piperead+0xae>
    if(pi->nread == pi->nwrite)
    8000522e:	2184a783          	lw	a5,536(s1)
    80005232:	21c4a703          	lw	a4,540(s1)
    80005236:	02f70e63          	beq	a4,a5,80005272 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000523a:	0017871b          	addiw	a4,a5,1
    8000523e:	20e4ac23          	sw	a4,536(s1)
    80005242:	1ff7f793          	andi	a5,a5,511
    80005246:	97a6                	add	a5,a5,s1
    80005248:	0187c783          	lbu	a5,24(a5)
    8000524c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005250:	4685                	li	a3,1
    80005252:	fbf40613          	addi	a2,s0,-65
    80005256:	85ca                	mv	a1,s2
    80005258:	050a3503          	ld	a0,80(s4)
    8000525c:	ffffc097          	auipc	ra,0xffffc
    80005260:	406080e7          	jalr	1030(ra) # 80001662 <copyout>
    80005264:	01650763          	beq	a0,s6,80005272 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005268:	2985                	addiw	s3,s3,1
    8000526a:	0905                	addi	s2,s2,1
    8000526c:	fd3a91e3          	bne	s5,s3,8000522e <piperead+0x6a>
    80005270:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80005272:	21c48513          	addi	a0,s1,540
    80005276:	ffffd097          	auipc	ra,0xffffd
    8000527a:	fd4080e7          	jalr	-44(ra) # 8000224a <wakeup>
  release(&pi->lock);
    8000527e:	8526                	mv	a0,s1
    80005280:	ffffc097          	auipc	ra,0xffffc
    80005284:	a04080e7          	jalr	-1532(ra) # 80000c84 <release>
  return i;
}
    80005288:	854e                	mv	a0,s3
    8000528a:	60a6                	ld	ra,72(sp)
    8000528c:	6406                	ld	s0,64(sp)
    8000528e:	74e2                	ld	s1,56(sp)
    80005290:	7942                	ld	s2,48(sp)
    80005292:	79a2                	ld	s3,40(sp)
    80005294:	7a02                	ld	s4,32(sp)
    80005296:	6ae2                	ld	s5,24(sp)
    80005298:	6b42                	ld	s6,16(sp)
    8000529a:	6161                	addi	sp,sp,80
    8000529c:	8082                	ret
      release(&pi->lock);
    8000529e:	8526                	mv	a0,s1
    800052a0:	ffffc097          	auipc	ra,0xffffc
    800052a4:	9e4080e7          	jalr	-1564(ra) # 80000c84 <release>
      return -1;
    800052a8:	59fd                	li	s3,-1
    800052aa:	bff9                	j	80005288 <piperead+0xc4>

00000000800052ac <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800052ac:	de010113          	addi	sp,sp,-544
    800052b0:	20113c23          	sd	ra,536(sp)
    800052b4:	20813823          	sd	s0,528(sp)
    800052b8:	20913423          	sd	s1,520(sp)
    800052bc:	21213023          	sd	s2,512(sp)
    800052c0:	ffce                	sd	s3,504(sp)
    800052c2:	fbd2                	sd	s4,496(sp)
    800052c4:	f7d6                	sd	s5,488(sp)
    800052c6:	f3da                	sd	s6,480(sp)
    800052c8:	efde                	sd	s7,472(sp)
    800052ca:	ebe2                	sd	s8,464(sp)
    800052cc:	e7e6                	sd	s9,456(sp)
    800052ce:	e3ea                	sd	s10,448(sp)
    800052d0:	ff6e                	sd	s11,440(sp)
    800052d2:	1400                	addi	s0,sp,544
    800052d4:	892a                	mv	s2,a0
    800052d6:	dea43423          	sd	a0,-536(s0)
    800052da:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800052de:	ffffc097          	auipc	ra,0xffffc
    800052e2:	6fa080e7          	jalr	1786(ra) # 800019d8 <myproc>
    800052e6:	84aa                	mv	s1,a0

  begin_op();
    800052e8:	fffff097          	auipc	ra,0xfffff
    800052ec:	4a8080e7          	jalr	1192(ra) # 80004790 <begin_op>

  if((ip = namei(path)) == 0){
    800052f0:	854a                	mv	a0,s2
    800052f2:	fffff097          	auipc	ra,0xfffff
    800052f6:	27e080e7          	jalr	638(ra) # 80004570 <namei>
    800052fa:	c93d                	beqz	a0,80005370 <exec+0xc4>
    800052fc:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800052fe:	fffff097          	auipc	ra,0xfffff
    80005302:	ab6080e7          	jalr	-1354(ra) # 80003db4 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80005306:	04000713          	li	a4,64
    8000530a:	4681                	li	a3,0
    8000530c:	e5040613          	addi	a2,s0,-432
    80005310:	4581                	li	a1,0
    80005312:	8556                	mv	a0,s5
    80005314:	fffff097          	auipc	ra,0xfffff
    80005318:	d54080e7          	jalr	-684(ra) # 80004068 <readi>
    8000531c:	04000793          	li	a5,64
    80005320:	00f51a63          	bne	a0,a5,80005334 <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80005324:	e5042703          	lw	a4,-432(s0)
    80005328:	464c47b7          	lui	a5,0x464c4
    8000532c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005330:	04f70663          	beq	a4,a5,8000537c <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80005334:	8556                	mv	a0,s5
    80005336:	fffff097          	auipc	ra,0xfffff
    8000533a:	ce0080e7          	jalr	-800(ra) # 80004016 <iunlockput>
    end_op();
    8000533e:	fffff097          	auipc	ra,0xfffff
    80005342:	4d0080e7          	jalr	1232(ra) # 8000480e <end_op>
  }
  return -1;
    80005346:	557d                	li	a0,-1
}
    80005348:	21813083          	ld	ra,536(sp)
    8000534c:	21013403          	ld	s0,528(sp)
    80005350:	20813483          	ld	s1,520(sp)
    80005354:	20013903          	ld	s2,512(sp)
    80005358:	79fe                	ld	s3,504(sp)
    8000535a:	7a5e                	ld	s4,496(sp)
    8000535c:	7abe                	ld	s5,488(sp)
    8000535e:	7b1e                	ld	s6,480(sp)
    80005360:	6bfe                	ld	s7,472(sp)
    80005362:	6c5e                	ld	s8,464(sp)
    80005364:	6cbe                	ld	s9,456(sp)
    80005366:	6d1e                	ld	s10,448(sp)
    80005368:	7dfa                	ld	s11,440(sp)
    8000536a:	22010113          	addi	sp,sp,544
    8000536e:	8082                	ret
    end_op();
    80005370:	fffff097          	auipc	ra,0xfffff
    80005374:	49e080e7          	jalr	1182(ra) # 8000480e <end_op>
    return -1;
    80005378:	557d                	li	a0,-1
    8000537a:	b7f9                	j	80005348 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    8000537c:	8526                	mv	a0,s1
    8000537e:	ffffc097          	auipc	ra,0xffffc
    80005382:	71e080e7          	jalr	1822(ra) # 80001a9c <proc_pagetable>
    80005386:	8b2a                	mv	s6,a0
    80005388:	d555                	beqz	a0,80005334 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000538a:	e7042783          	lw	a5,-400(s0)
    8000538e:	e8845703          	lhu	a4,-376(s0)
    80005392:	c735                	beqz	a4,800053fe <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005394:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005396:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    8000539a:	6a05                	lui	s4,0x1
    8000539c:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800053a0:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800053a4:	6d85                	lui	s11,0x1
    800053a6:	7d7d                	lui	s10,0xfffff
    800053a8:	ac1d                	j	800055de <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800053aa:	00003517          	auipc	a0,0x3
    800053ae:	45e50513          	addi	a0,a0,1118 # 80008808 <syscalls+0x290>
    800053b2:	ffffb097          	auipc	ra,0xffffb
    800053b6:	188080e7          	jalr	392(ra) # 8000053a <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800053ba:	874a                	mv	a4,s2
    800053bc:	009c86bb          	addw	a3,s9,s1
    800053c0:	4581                	li	a1,0
    800053c2:	8556                	mv	a0,s5
    800053c4:	fffff097          	auipc	ra,0xfffff
    800053c8:	ca4080e7          	jalr	-860(ra) # 80004068 <readi>
    800053cc:	2501                	sext.w	a0,a0
    800053ce:	1aa91863          	bne	s2,a0,8000557e <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    800053d2:	009d84bb          	addw	s1,s11,s1
    800053d6:	013d09bb          	addw	s3,s10,s3
    800053da:	1f74f263          	bgeu	s1,s7,800055be <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    800053de:	02049593          	slli	a1,s1,0x20
    800053e2:	9181                	srli	a1,a1,0x20
    800053e4:	95e2                	add	a1,a1,s8
    800053e6:	855a                	mv	a0,s6
    800053e8:	ffffc097          	auipc	ra,0xffffc
    800053ec:	c72080e7          	jalr	-910(ra) # 8000105a <walkaddr>
    800053f0:	862a                	mv	a2,a0
    if(pa == 0)
    800053f2:	dd45                	beqz	a0,800053aa <exec+0xfe>
      n = PGSIZE;
    800053f4:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800053f6:	fd49f2e3          	bgeu	s3,s4,800053ba <exec+0x10e>
      n = sz - i;
    800053fa:	894e                	mv	s2,s3
    800053fc:	bf7d                	j	800053ba <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800053fe:	4481                	li	s1,0
  iunlockput(ip);
    80005400:	8556                	mv	a0,s5
    80005402:	fffff097          	auipc	ra,0xfffff
    80005406:	c14080e7          	jalr	-1004(ra) # 80004016 <iunlockput>
  end_op();
    8000540a:	fffff097          	auipc	ra,0xfffff
    8000540e:	404080e7          	jalr	1028(ra) # 8000480e <end_op>
  p = myproc();
    80005412:	ffffc097          	auipc	ra,0xffffc
    80005416:	5c6080e7          	jalr	1478(ra) # 800019d8 <myproc>
    8000541a:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    8000541c:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80005420:	6785                	lui	a5,0x1
    80005422:	17fd                	addi	a5,a5,-1
    80005424:	97a6                	add	a5,a5,s1
    80005426:	777d                	lui	a4,0xfffff
    80005428:	8ff9                	and	a5,a5,a4
    8000542a:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000542e:	6609                	lui	a2,0x2
    80005430:	963e                	add	a2,a2,a5
    80005432:	85be                	mv	a1,a5
    80005434:	855a                	mv	a0,s6
    80005436:	ffffc097          	auipc	ra,0xffffc
    8000543a:	fd8080e7          	jalr	-40(ra) # 8000140e <uvmalloc>
    8000543e:	8c2a                	mv	s8,a0
  ip = 0;
    80005440:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80005442:	12050e63          	beqz	a0,8000557e <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    80005446:	75f9                	lui	a1,0xffffe
    80005448:	95aa                	add	a1,a1,a0
    8000544a:	855a                	mv	a0,s6
    8000544c:	ffffc097          	auipc	ra,0xffffc
    80005450:	1e4080e7          	jalr	484(ra) # 80001630 <uvmclear>
  stackbase = sp - PGSIZE;
    80005454:	7afd                	lui	s5,0xfffff
    80005456:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80005458:	df043783          	ld	a5,-528(s0)
    8000545c:	6388                	ld	a0,0(a5)
    8000545e:	c925                	beqz	a0,800054ce <exec+0x222>
    80005460:	e9040993          	addi	s3,s0,-368
    80005464:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80005468:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000546a:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000546c:	ffffc097          	auipc	ra,0xffffc
    80005470:	9dc080e7          	jalr	-1572(ra) # 80000e48 <strlen>
    80005474:	0015079b          	addiw	a5,a0,1
    80005478:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000547c:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80005480:	13596363          	bltu	s2,s5,800055a6 <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005484:	df043d83          	ld	s11,-528(s0)
    80005488:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    8000548c:	8552                	mv	a0,s4
    8000548e:	ffffc097          	auipc	ra,0xffffc
    80005492:	9ba080e7          	jalr	-1606(ra) # 80000e48 <strlen>
    80005496:	0015069b          	addiw	a3,a0,1
    8000549a:	8652                	mv	a2,s4
    8000549c:	85ca                	mv	a1,s2
    8000549e:	855a                	mv	a0,s6
    800054a0:	ffffc097          	auipc	ra,0xffffc
    800054a4:	1c2080e7          	jalr	450(ra) # 80001662 <copyout>
    800054a8:	10054363          	bltz	a0,800055ae <exec+0x302>
    ustack[argc] = sp;
    800054ac:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800054b0:	0485                	addi	s1,s1,1
    800054b2:	008d8793          	addi	a5,s11,8
    800054b6:	def43823          	sd	a5,-528(s0)
    800054ba:	008db503          	ld	a0,8(s11)
    800054be:	c911                	beqz	a0,800054d2 <exec+0x226>
    if(argc >= MAXARG)
    800054c0:	09a1                	addi	s3,s3,8
    800054c2:	fb3c95e3          	bne	s9,s3,8000546c <exec+0x1c0>
  sz = sz1;
    800054c6:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800054ca:	4a81                	li	s5,0
    800054cc:	a84d                	j	8000557e <exec+0x2d2>
  sp = sz;
    800054ce:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800054d0:	4481                	li	s1,0
  ustack[argc] = 0;
    800054d2:	00349793          	slli	a5,s1,0x3
    800054d6:	f9078793          	addi	a5,a5,-112 # f90 <_entry-0x7ffff070>
    800054da:	97a2                	add	a5,a5,s0
    800054dc:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800054e0:	00148693          	addi	a3,s1,1
    800054e4:	068e                	slli	a3,a3,0x3
    800054e6:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800054ea:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800054ee:	01597663          	bgeu	s2,s5,800054fa <exec+0x24e>
  sz = sz1;
    800054f2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800054f6:	4a81                	li	s5,0
    800054f8:	a059                	j	8000557e <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800054fa:	e9040613          	addi	a2,s0,-368
    800054fe:	85ca                	mv	a1,s2
    80005500:	855a                	mv	a0,s6
    80005502:	ffffc097          	auipc	ra,0xffffc
    80005506:	160080e7          	jalr	352(ra) # 80001662 <copyout>
    8000550a:	0a054663          	bltz	a0,800055b6 <exec+0x30a>
  p->trapframe->a1 = sp;
    8000550e:	058bb783          	ld	a5,88(s7)
    80005512:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005516:	de843783          	ld	a5,-536(s0)
    8000551a:	0007c703          	lbu	a4,0(a5)
    8000551e:	cf11                	beqz	a4,8000553a <exec+0x28e>
    80005520:	0785                	addi	a5,a5,1
    if(*s == '/')
    80005522:	02f00693          	li	a3,47
    80005526:	a039                	j	80005534 <exec+0x288>
      last = s+1;
    80005528:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    8000552c:	0785                	addi	a5,a5,1
    8000552e:	fff7c703          	lbu	a4,-1(a5)
    80005532:	c701                	beqz	a4,8000553a <exec+0x28e>
    if(*s == '/')
    80005534:	fed71ce3          	bne	a4,a3,8000552c <exec+0x280>
    80005538:	bfc5                	j	80005528 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    8000553a:	4641                	li	a2,16
    8000553c:	de843583          	ld	a1,-536(s0)
    80005540:	158b8513          	addi	a0,s7,344
    80005544:	ffffc097          	auipc	ra,0xffffc
    80005548:	8d2080e7          	jalr	-1838(ra) # 80000e16 <safestrcpy>
  oldpagetable = p->pagetable;
    8000554c:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80005550:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80005554:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005558:	058bb783          	ld	a5,88(s7)
    8000555c:	e6843703          	ld	a4,-408(s0)
    80005560:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80005562:	058bb783          	ld	a5,88(s7)
    80005566:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000556a:	85ea                	mv	a1,s10
    8000556c:	ffffc097          	auipc	ra,0xffffc
    80005570:	5cc080e7          	jalr	1484(ra) # 80001b38 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005574:	0004851b          	sext.w	a0,s1
    80005578:	bbc1                	j	80005348 <exec+0x9c>
    8000557a:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    8000557e:	df843583          	ld	a1,-520(s0)
    80005582:	855a                	mv	a0,s6
    80005584:	ffffc097          	auipc	ra,0xffffc
    80005588:	5b4080e7          	jalr	1460(ra) # 80001b38 <proc_freepagetable>
  if(ip){
    8000558c:	da0a94e3          	bnez	s5,80005334 <exec+0x88>
  return -1;
    80005590:	557d                	li	a0,-1
    80005592:	bb5d                	j	80005348 <exec+0x9c>
    80005594:	de943c23          	sd	s1,-520(s0)
    80005598:	b7dd                	j	8000557e <exec+0x2d2>
    8000559a:	de943c23          	sd	s1,-520(s0)
    8000559e:	b7c5                	j	8000557e <exec+0x2d2>
    800055a0:	de943c23          	sd	s1,-520(s0)
    800055a4:	bfe9                	j	8000557e <exec+0x2d2>
  sz = sz1;
    800055a6:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800055aa:	4a81                	li	s5,0
    800055ac:	bfc9                	j	8000557e <exec+0x2d2>
  sz = sz1;
    800055ae:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800055b2:	4a81                	li	s5,0
    800055b4:	b7e9                	j	8000557e <exec+0x2d2>
  sz = sz1;
    800055b6:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800055ba:	4a81                	li	s5,0
    800055bc:	b7c9                	j	8000557e <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800055be:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800055c2:	e0843783          	ld	a5,-504(s0)
    800055c6:	0017869b          	addiw	a3,a5,1
    800055ca:	e0d43423          	sd	a3,-504(s0)
    800055ce:	e0043783          	ld	a5,-512(s0)
    800055d2:	0387879b          	addiw	a5,a5,56
    800055d6:	e8845703          	lhu	a4,-376(s0)
    800055da:	e2e6d3e3          	bge	a3,a4,80005400 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800055de:	2781                	sext.w	a5,a5
    800055e0:	e0f43023          	sd	a5,-512(s0)
    800055e4:	03800713          	li	a4,56
    800055e8:	86be                	mv	a3,a5
    800055ea:	e1840613          	addi	a2,s0,-488
    800055ee:	4581                	li	a1,0
    800055f0:	8556                	mv	a0,s5
    800055f2:	fffff097          	auipc	ra,0xfffff
    800055f6:	a76080e7          	jalr	-1418(ra) # 80004068 <readi>
    800055fa:	03800793          	li	a5,56
    800055fe:	f6f51ee3          	bne	a0,a5,8000557a <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    80005602:	e1842783          	lw	a5,-488(s0)
    80005606:	4705                	li	a4,1
    80005608:	fae79de3          	bne	a5,a4,800055c2 <exec+0x316>
    if(ph.memsz < ph.filesz)
    8000560c:	e4043603          	ld	a2,-448(s0)
    80005610:	e3843783          	ld	a5,-456(s0)
    80005614:	f8f660e3          	bltu	a2,a5,80005594 <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005618:	e2843783          	ld	a5,-472(s0)
    8000561c:	963e                	add	a2,a2,a5
    8000561e:	f6f66ee3          	bltu	a2,a5,8000559a <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80005622:	85a6                	mv	a1,s1
    80005624:	855a                	mv	a0,s6
    80005626:	ffffc097          	auipc	ra,0xffffc
    8000562a:	de8080e7          	jalr	-536(ra) # 8000140e <uvmalloc>
    8000562e:	dea43c23          	sd	a0,-520(s0)
    80005632:	d53d                	beqz	a0,800055a0 <exec+0x2f4>
    if((ph.vaddr % PGSIZE) != 0)
    80005634:	e2843c03          	ld	s8,-472(s0)
    80005638:	de043783          	ld	a5,-544(s0)
    8000563c:	00fc77b3          	and	a5,s8,a5
    80005640:	ff9d                	bnez	a5,8000557e <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005642:	e2042c83          	lw	s9,-480(s0)
    80005646:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000564a:	f60b8ae3          	beqz	s7,800055be <exec+0x312>
    8000564e:	89de                	mv	s3,s7
    80005650:	4481                	li	s1,0
    80005652:	b371                	j	800053de <exec+0x132>

0000000080005654 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005654:	7179                	addi	sp,sp,-48
    80005656:	f406                	sd	ra,40(sp)
    80005658:	f022                	sd	s0,32(sp)
    8000565a:	ec26                	sd	s1,24(sp)
    8000565c:	e84a                	sd	s2,16(sp)
    8000565e:	1800                	addi	s0,sp,48
    80005660:	892e                	mv	s2,a1
    80005662:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80005664:	fdc40593          	addi	a1,s0,-36
    80005668:	ffffe097          	auipc	ra,0xffffe
    8000566c:	9c6080e7          	jalr	-1594(ra) # 8000302e <argint>
    80005670:	04054063          	bltz	a0,800056b0 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005674:	fdc42703          	lw	a4,-36(s0)
    80005678:	47bd                	li	a5,15
    8000567a:	02e7ed63          	bltu	a5,a4,800056b4 <argfd+0x60>
    8000567e:	ffffc097          	auipc	ra,0xffffc
    80005682:	35a080e7          	jalr	858(ra) # 800019d8 <myproc>
    80005686:	fdc42703          	lw	a4,-36(s0)
    8000568a:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffd701a>
    8000568e:	078e                	slli	a5,a5,0x3
    80005690:	953e                	add	a0,a0,a5
    80005692:	611c                	ld	a5,0(a0)
    80005694:	c395                	beqz	a5,800056b8 <argfd+0x64>
    return -1;
  if(pfd)
    80005696:	00090463          	beqz	s2,8000569e <argfd+0x4a>
    *pfd = fd;
    8000569a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000569e:	4501                	li	a0,0
  if(pf)
    800056a0:	c091                	beqz	s1,800056a4 <argfd+0x50>
    *pf = f;
    800056a2:	e09c                	sd	a5,0(s1)
}
    800056a4:	70a2                	ld	ra,40(sp)
    800056a6:	7402                	ld	s0,32(sp)
    800056a8:	64e2                	ld	s1,24(sp)
    800056aa:	6942                	ld	s2,16(sp)
    800056ac:	6145                	addi	sp,sp,48
    800056ae:	8082                	ret
    return -1;
    800056b0:	557d                	li	a0,-1
    800056b2:	bfcd                	j	800056a4 <argfd+0x50>
    return -1;
    800056b4:	557d                	li	a0,-1
    800056b6:	b7fd                	j	800056a4 <argfd+0x50>
    800056b8:	557d                	li	a0,-1
    800056ba:	b7ed                	j	800056a4 <argfd+0x50>

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
    800056cc:	310080e7          	jalr	784(ra) # 800019d8 <myproc>
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
    8000570a:	f052                	sd	s4,32(sp)
    8000570c:	ec56                	sd	s5,24(sp)
    8000570e:	0880                	addi	s0,sp,80
    80005710:	89ae                	mv	s3,a1
    80005712:	8ab2                	mv	s5,a2
    80005714:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005716:	fb040593          	addi	a1,s0,-80
    8000571a:	fffff097          	auipc	ra,0xfffff
    8000571e:	e74080e7          	jalr	-396(ra) # 8000458e <nameiparent>
    80005722:	892a                	mv	s2,a0
    80005724:	12050e63          	beqz	a0,80005860 <create+0x162>
    return 0;

  ilock(dp);
    80005728:	ffffe097          	auipc	ra,0xffffe
    8000572c:	68c080e7          	jalr	1676(ra) # 80003db4 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005730:	4601                	li	a2,0
    80005732:	fb040593          	addi	a1,s0,-80
    80005736:	854a                	mv	a0,s2
    80005738:	fffff097          	auipc	ra,0xfffff
    8000573c:	b60080e7          	jalr	-1184(ra) # 80004298 <dirlookup>
    80005740:	84aa                	mv	s1,a0
    80005742:	c921                	beqz	a0,80005792 <create+0x94>
    iunlockput(dp);
    80005744:	854a                	mv	a0,s2
    80005746:	fffff097          	auipc	ra,0xfffff
    8000574a:	8d0080e7          	jalr	-1840(ra) # 80004016 <iunlockput>
    ilock(ip);
    8000574e:	8526                	mv	a0,s1
    80005750:	ffffe097          	auipc	ra,0xffffe
    80005754:	664080e7          	jalr	1636(ra) # 80003db4 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005758:	2981                	sext.w	s3,s3
    8000575a:	4789                	li	a5,2
    8000575c:	02f99463          	bne	s3,a5,80005784 <create+0x86>
    80005760:	0444d783          	lhu	a5,68(s1)
    80005764:	37f9                	addiw	a5,a5,-2
    80005766:	17c2                	slli	a5,a5,0x30
    80005768:	93c1                	srli	a5,a5,0x30
    8000576a:	4705                	li	a4,1
    8000576c:	00f76c63          	bltu	a4,a5,80005784 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80005770:	8526                	mv	a0,s1
    80005772:	60a6                	ld	ra,72(sp)
    80005774:	6406                	ld	s0,64(sp)
    80005776:	74e2                	ld	s1,56(sp)
    80005778:	7942                	ld	s2,48(sp)
    8000577a:	79a2                	ld	s3,40(sp)
    8000577c:	7a02                	ld	s4,32(sp)
    8000577e:	6ae2                	ld	s5,24(sp)
    80005780:	6161                	addi	sp,sp,80
    80005782:	8082                	ret
    iunlockput(ip);
    80005784:	8526                	mv	a0,s1
    80005786:	fffff097          	auipc	ra,0xfffff
    8000578a:	890080e7          	jalr	-1904(ra) # 80004016 <iunlockput>
    return 0;
    8000578e:	4481                	li	s1,0
    80005790:	b7c5                	j	80005770 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80005792:	85ce                	mv	a1,s3
    80005794:	00092503          	lw	a0,0(s2)
    80005798:	ffffe097          	auipc	ra,0xffffe
    8000579c:	482080e7          	jalr	1154(ra) # 80003c1a <ialloc>
    800057a0:	84aa                	mv	s1,a0
    800057a2:	c521                	beqz	a0,800057ea <create+0xec>
  ilock(ip);
    800057a4:	ffffe097          	auipc	ra,0xffffe
    800057a8:	610080e7          	jalr	1552(ra) # 80003db4 <ilock>
  ip->major = major;
    800057ac:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800057b0:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800057b4:	4a05                	li	s4,1
    800057b6:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    800057ba:	8526                	mv	a0,s1
    800057bc:	ffffe097          	auipc	ra,0xffffe
    800057c0:	52c080e7          	jalr	1324(ra) # 80003ce8 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800057c4:	2981                	sext.w	s3,s3
    800057c6:	03498a63          	beq	s3,s4,800057fa <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800057ca:	40d0                	lw	a2,4(s1)
    800057cc:	fb040593          	addi	a1,s0,-80
    800057d0:	854a                	mv	a0,s2
    800057d2:	fffff097          	auipc	ra,0xfffff
    800057d6:	cdc080e7          	jalr	-804(ra) # 800044ae <dirlink>
    800057da:	06054b63          	bltz	a0,80005850 <create+0x152>
  iunlockput(dp);
    800057de:	854a                	mv	a0,s2
    800057e0:	fffff097          	auipc	ra,0xfffff
    800057e4:	836080e7          	jalr	-1994(ra) # 80004016 <iunlockput>
  return ip;
    800057e8:	b761                	j	80005770 <create+0x72>
    panic("create: ialloc");
    800057ea:	00003517          	auipc	a0,0x3
    800057ee:	03e50513          	addi	a0,a0,62 # 80008828 <syscalls+0x2b0>
    800057f2:	ffffb097          	auipc	ra,0xffffb
    800057f6:	d48080e7          	jalr	-696(ra) # 8000053a <panic>
    dp->nlink++;  // for ".."
    800057fa:	04a95783          	lhu	a5,74(s2)
    800057fe:	2785                	addiw	a5,a5,1
    80005800:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80005804:	854a                	mv	a0,s2
    80005806:	ffffe097          	auipc	ra,0xffffe
    8000580a:	4e2080e7          	jalr	1250(ra) # 80003ce8 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000580e:	40d0                	lw	a2,4(s1)
    80005810:	00003597          	auipc	a1,0x3
    80005814:	02858593          	addi	a1,a1,40 # 80008838 <syscalls+0x2c0>
    80005818:	8526                	mv	a0,s1
    8000581a:	fffff097          	auipc	ra,0xfffff
    8000581e:	c94080e7          	jalr	-876(ra) # 800044ae <dirlink>
    80005822:	00054f63          	bltz	a0,80005840 <create+0x142>
    80005826:	00492603          	lw	a2,4(s2)
    8000582a:	00003597          	auipc	a1,0x3
    8000582e:	01658593          	addi	a1,a1,22 # 80008840 <syscalls+0x2c8>
    80005832:	8526                	mv	a0,s1
    80005834:	fffff097          	auipc	ra,0xfffff
    80005838:	c7a080e7          	jalr	-902(ra) # 800044ae <dirlink>
    8000583c:	f80557e3          	bgez	a0,800057ca <create+0xcc>
      panic("create dots");
    80005840:	00003517          	auipc	a0,0x3
    80005844:	00850513          	addi	a0,a0,8 # 80008848 <syscalls+0x2d0>
    80005848:	ffffb097          	auipc	ra,0xffffb
    8000584c:	cf2080e7          	jalr	-782(ra) # 8000053a <panic>
    panic("create: dirlink");
    80005850:	00003517          	auipc	a0,0x3
    80005854:	00850513          	addi	a0,a0,8 # 80008858 <syscalls+0x2e0>
    80005858:	ffffb097          	auipc	ra,0xffffb
    8000585c:	ce2080e7          	jalr	-798(ra) # 8000053a <panic>
    return 0;
    80005860:	84aa                	mv	s1,a0
    80005862:	b739                	j	80005770 <create+0x72>

0000000080005864 <sys_dup>:
{
    80005864:	7179                	addi	sp,sp,-48
    80005866:	f406                	sd	ra,40(sp)
    80005868:	f022                	sd	s0,32(sp)
    8000586a:	ec26                	sd	s1,24(sp)
    8000586c:	e84a                	sd	s2,16(sp)
    8000586e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005870:	fd840613          	addi	a2,s0,-40
    80005874:	4581                	li	a1,0
    80005876:	4501                	li	a0,0
    80005878:	00000097          	auipc	ra,0x0
    8000587c:	ddc080e7          	jalr	-548(ra) # 80005654 <argfd>
    return -1;
    80005880:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005882:	02054363          	bltz	a0,800058a8 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    80005886:	fd843903          	ld	s2,-40(s0)
    8000588a:	854a                	mv	a0,s2
    8000588c:	00000097          	auipc	ra,0x0
    80005890:	e30080e7          	jalr	-464(ra) # 800056bc <fdalloc>
    80005894:	84aa                	mv	s1,a0
    return -1;
    80005896:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005898:	00054863          	bltz	a0,800058a8 <sys_dup+0x44>
  filedup(f);
    8000589c:	854a                	mv	a0,s2
    8000589e:	fffff097          	auipc	ra,0xfffff
    800058a2:	368080e7          	jalr	872(ra) # 80004c06 <filedup>
  return fd;
    800058a6:	87a6                	mv	a5,s1
}
    800058a8:	853e                	mv	a0,a5
    800058aa:	70a2                	ld	ra,40(sp)
    800058ac:	7402                	ld	s0,32(sp)
    800058ae:	64e2                	ld	s1,24(sp)
    800058b0:	6942                	ld	s2,16(sp)
    800058b2:	6145                	addi	sp,sp,48
    800058b4:	8082                	ret

00000000800058b6 <sys_read>:
{
    800058b6:	7179                	addi	sp,sp,-48
    800058b8:	f406                	sd	ra,40(sp)
    800058ba:	f022                	sd	s0,32(sp)
    800058bc:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800058be:	fe840613          	addi	a2,s0,-24
    800058c2:	4581                	li	a1,0
    800058c4:	4501                	li	a0,0
    800058c6:	00000097          	auipc	ra,0x0
    800058ca:	d8e080e7          	jalr	-626(ra) # 80005654 <argfd>
    return -1;
    800058ce:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800058d0:	04054163          	bltz	a0,80005912 <sys_read+0x5c>
    800058d4:	fe440593          	addi	a1,s0,-28
    800058d8:	4509                	li	a0,2
    800058da:	ffffd097          	auipc	ra,0xffffd
    800058de:	754080e7          	jalr	1876(ra) # 8000302e <argint>
    return -1;
    800058e2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800058e4:	02054763          	bltz	a0,80005912 <sys_read+0x5c>
    800058e8:	fd840593          	addi	a1,s0,-40
    800058ec:	4505                	li	a0,1
    800058ee:	ffffd097          	auipc	ra,0xffffd
    800058f2:	762080e7          	jalr	1890(ra) # 80003050 <argaddr>
    return -1;
    800058f6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800058f8:	00054d63          	bltz	a0,80005912 <sys_read+0x5c>
  return fileread(f, p, n);
    800058fc:	fe442603          	lw	a2,-28(s0)
    80005900:	fd843583          	ld	a1,-40(s0)
    80005904:	fe843503          	ld	a0,-24(s0)
    80005908:	fffff097          	auipc	ra,0xfffff
    8000590c:	48a080e7          	jalr	1162(ra) # 80004d92 <fileread>
    80005910:	87aa                	mv	a5,a0
}
    80005912:	853e                	mv	a0,a5
    80005914:	70a2                	ld	ra,40(sp)
    80005916:	7402                	ld	s0,32(sp)
    80005918:	6145                	addi	sp,sp,48
    8000591a:	8082                	ret

000000008000591c <sys_write>:
{
    8000591c:	7179                	addi	sp,sp,-48
    8000591e:	f406                	sd	ra,40(sp)
    80005920:	f022                	sd	s0,32(sp)
    80005922:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005924:	fe840613          	addi	a2,s0,-24
    80005928:	4581                	li	a1,0
    8000592a:	4501                	li	a0,0
    8000592c:	00000097          	auipc	ra,0x0
    80005930:	d28080e7          	jalr	-728(ra) # 80005654 <argfd>
    return -1;
    80005934:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005936:	04054163          	bltz	a0,80005978 <sys_write+0x5c>
    8000593a:	fe440593          	addi	a1,s0,-28
    8000593e:	4509                	li	a0,2
    80005940:	ffffd097          	auipc	ra,0xffffd
    80005944:	6ee080e7          	jalr	1774(ra) # 8000302e <argint>
    return -1;
    80005948:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000594a:	02054763          	bltz	a0,80005978 <sys_write+0x5c>
    8000594e:	fd840593          	addi	a1,s0,-40
    80005952:	4505                	li	a0,1
    80005954:	ffffd097          	auipc	ra,0xffffd
    80005958:	6fc080e7          	jalr	1788(ra) # 80003050 <argaddr>
    return -1;
    8000595c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000595e:	00054d63          	bltz	a0,80005978 <sys_write+0x5c>
  return filewrite(f, p, n);
    80005962:	fe442603          	lw	a2,-28(s0)
    80005966:	fd843583          	ld	a1,-40(s0)
    8000596a:	fe843503          	ld	a0,-24(s0)
    8000596e:	fffff097          	auipc	ra,0xfffff
    80005972:	4e6080e7          	jalr	1254(ra) # 80004e54 <filewrite>
    80005976:	87aa                	mv	a5,a0
}
    80005978:	853e                	mv	a0,a5
    8000597a:	70a2                	ld	ra,40(sp)
    8000597c:	7402                	ld	s0,32(sp)
    8000597e:	6145                	addi	sp,sp,48
    80005980:	8082                	ret

0000000080005982 <sys_close>:
{
    80005982:	1101                	addi	sp,sp,-32
    80005984:	ec06                	sd	ra,24(sp)
    80005986:	e822                	sd	s0,16(sp)
    80005988:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000598a:	fe040613          	addi	a2,s0,-32
    8000598e:	fec40593          	addi	a1,s0,-20
    80005992:	4501                	li	a0,0
    80005994:	00000097          	auipc	ra,0x0
    80005998:	cc0080e7          	jalr	-832(ra) # 80005654 <argfd>
    return -1;
    8000599c:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000599e:	02054463          	bltz	a0,800059c6 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800059a2:	ffffc097          	auipc	ra,0xffffc
    800059a6:	036080e7          	jalr	54(ra) # 800019d8 <myproc>
    800059aa:	fec42783          	lw	a5,-20(s0)
    800059ae:	07e9                	addi	a5,a5,26
    800059b0:	078e                	slli	a5,a5,0x3
    800059b2:	953e                	add	a0,a0,a5
    800059b4:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800059b8:	fe043503          	ld	a0,-32(s0)
    800059bc:	fffff097          	auipc	ra,0xfffff
    800059c0:	29c080e7          	jalr	668(ra) # 80004c58 <fileclose>
  return 0;
    800059c4:	4781                	li	a5,0
}
    800059c6:	853e                	mv	a0,a5
    800059c8:	60e2                	ld	ra,24(sp)
    800059ca:	6442                	ld	s0,16(sp)
    800059cc:	6105                	addi	sp,sp,32
    800059ce:	8082                	ret

00000000800059d0 <sys_fstat>:
{
    800059d0:	1101                	addi	sp,sp,-32
    800059d2:	ec06                	sd	ra,24(sp)
    800059d4:	e822                	sd	s0,16(sp)
    800059d6:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800059d8:	fe840613          	addi	a2,s0,-24
    800059dc:	4581                	li	a1,0
    800059de:	4501                	li	a0,0
    800059e0:	00000097          	auipc	ra,0x0
    800059e4:	c74080e7          	jalr	-908(ra) # 80005654 <argfd>
    return -1;
    800059e8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800059ea:	02054563          	bltz	a0,80005a14 <sys_fstat+0x44>
    800059ee:	fe040593          	addi	a1,s0,-32
    800059f2:	4505                	li	a0,1
    800059f4:	ffffd097          	auipc	ra,0xffffd
    800059f8:	65c080e7          	jalr	1628(ra) # 80003050 <argaddr>
    return -1;
    800059fc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800059fe:	00054b63          	bltz	a0,80005a14 <sys_fstat+0x44>
  return filestat(f, st);
    80005a02:	fe043583          	ld	a1,-32(s0)
    80005a06:	fe843503          	ld	a0,-24(s0)
    80005a0a:	fffff097          	auipc	ra,0xfffff
    80005a0e:	316080e7          	jalr	790(ra) # 80004d20 <filestat>
    80005a12:	87aa                	mv	a5,a0
}
    80005a14:	853e                	mv	a0,a5
    80005a16:	60e2                	ld	ra,24(sp)
    80005a18:	6442                	ld	s0,16(sp)
    80005a1a:	6105                	addi	sp,sp,32
    80005a1c:	8082                	ret

0000000080005a1e <sys_link>:
{
    80005a1e:	7169                	addi	sp,sp,-304
    80005a20:	f606                	sd	ra,296(sp)
    80005a22:	f222                	sd	s0,288(sp)
    80005a24:	ee26                	sd	s1,280(sp)
    80005a26:	ea4a                	sd	s2,272(sp)
    80005a28:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005a2a:	08000613          	li	a2,128
    80005a2e:	ed040593          	addi	a1,s0,-304
    80005a32:	4501                	li	a0,0
    80005a34:	ffffd097          	auipc	ra,0xffffd
    80005a38:	63e080e7          	jalr	1598(ra) # 80003072 <argstr>
    return -1;
    80005a3c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005a3e:	10054e63          	bltz	a0,80005b5a <sys_link+0x13c>
    80005a42:	08000613          	li	a2,128
    80005a46:	f5040593          	addi	a1,s0,-176
    80005a4a:	4505                	li	a0,1
    80005a4c:	ffffd097          	auipc	ra,0xffffd
    80005a50:	626080e7          	jalr	1574(ra) # 80003072 <argstr>
    return -1;
    80005a54:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005a56:	10054263          	bltz	a0,80005b5a <sys_link+0x13c>
  begin_op();
    80005a5a:	fffff097          	auipc	ra,0xfffff
    80005a5e:	d36080e7          	jalr	-714(ra) # 80004790 <begin_op>
  if((ip = namei(old)) == 0){
    80005a62:	ed040513          	addi	a0,s0,-304
    80005a66:	fffff097          	auipc	ra,0xfffff
    80005a6a:	b0a080e7          	jalr	-1270(ra) # 80004570 <namei>
    80005a6e:	84aa                	mv	s1,a0
    80005a70:	c551                	beqz	a0,80005afc <sys_link+0xde>
  ilock(ip);
    80005a72:	ffffe097          	auipc	ra,0xffffe
    80005a76:	342080e7          	jalr	834(ra) # 80003db4 <ilock>
  if(ip->type == T_DIR){
    80005a7a:	04449703          	lh	a4,68(s1)
    80005a7e:	4785                	li	a5,1
    80005a80:	08f70463          	beq	a4,a5,80005b08 <sys_link+0xea>
  ip->nlink++;
    80005a84:	04a4d783          	lhu	a5,74(s1)
    80005a88:	2785                	addiw	a5,a5,1
    80005a8a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005a8e:	8526                	mv	a0,s1
    80005a90:	ffffe097          	auipc	ra,0xffffe
    80005a94:	258080e7          	jalr	600(ra) # 80003ce8 <iupdate>
  iunlock(ip);
    80005a98:	8526                	mv	a0,s1
    80005a9a:	ffffe097          	auipc	ra,0xffffe
    80005a9e:	3dc080e7          	jalr	988(ra) # 80003e76 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005aa2:	fd040593          	addi	a1,s0,-48
    80005aa6:	f5040513          	addi	a0,s0,-176
    80005aaa:	fffff097          	auipc	ra,0xfffff
    80005aae:	ae4080e7          	jalr	-1308(ra) # 8000458e <nameiparent>
    80005ab2:	892a                	mv	s2,a0
    80005ab4:	c935                	beqz	a0,80005b28 <sys_link+0x10a>
  ilock(dp);
    80005ab6:	ffffe097          	auipc	ra,0xffffe
    80005aba:	2fe080e7          	jalr	766(ra) # 80003db4 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005abe:	00092703          	lw	a4,0(s2)
    80005ac2:	409c                	lw	a5,0(s1)
    80005ac4:	04f71d63          	bne	a4,a5,80005b1e <sys_link+0x100>
    80005ac8:	40d0                	lw	a2,4(s1)
    80005aca:	fd040593          	addi	a1,s0,-48
    80005ace:	854a                	mv	a0,s2
    80005ad0:	fffff097          	auipc	ra,0xfffff
    80005ad4:	9de080e7          	jalr	-1570(ra) # 800044ae <dirlink>
    80005ad8:	04054363          	bltz	a0,80005b1e <sys_link+0x100>
  iunlockput(dp);
    80005adc:	854a                	mv	a0,s2
    80005ade:	ffffe097          	auipc	ra,0xffffe
    80005ae2:	538080e7          	jalr	1336(ra) # 80004016 <iunlockput>
  iput(ip);
    80005ae6:	8526                	mv	a0,s1
    80005ae8:	ffffe097          	auipc	ra,0xffffe
    80005aec:	486080e7          	jalr	1158(ra) # 80003f6e <iput>
  end_op();
    80005af0:	fffff097          	auipc	ra,0xfffff
    80005af4:	d1e080e7          	jalr	-738(ra) # 8000480e <end_op>
  return 0;
    80005af8:	4781                	li	a5,0
    80005afa:	a085                	j	80005b5a <sys_link+0x13c>
    end_op();
    80005afc:	fffff097          	auipc	ra,0xfffff
    80005b00:	d12080e7          	jalr	-750(ra) # 8000480e <end_op>
    return -1;
    80005b04:	57fd                	li	a5,-1
    80005b06:	a891                	j	80005b5a <sys_link+0x13c>
    iunlockput(ip);
    80005b08:	8526                	mv	a0,s1
    80005b0a:	ffffe097          	auipc	ra,0xffffe
    80005b0e:	50c080e7          	jalr	1292(ra) # 80004016 <iunlockput>
    end_op();
    80005b12:	fffff097          	auipc	ra,0xfffff
    80005b16:	cfc080e7          	jalr	-772(ra) # 8000480e <end_op>
    return -1;
    80005b1a:	57fd                	li	a5,-1
    80005b1c:	a83d                	j	80005b5a <sys_link+0x13c>
    iunlockput(dp);
    80005b1e:	854a                	mv	a0,s2
    80005b20:	ffffe097          	auipc	ra,0xffffe
    80005b24:	4f6080e7          	jalr	1270(ra) # 80004016 <iunlockput>
  ilock(ip);
    80005b28:	8526                	mv	a0,s1
    80005b2a:	ffffe097          	auipc	ra,0xffffe
    80005b2e:	28a080e7          	jalr	650(ra) # 80003db4 <ilock>
  ip->nlink--;
    80005b32:	04a4d783          	lhu	a5,74(s1)
    80005b36:	37fd                	addiw	a5,a5,-1
    80005b38:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005b3c:	8526                	mv	a0,s1
    80005b3e:	ffffe097          	auipc	ra,0xffffe
    80005b42:	1aa080e7          	jalr	426(ra) # 80003ce8 <iupdate>
  iunlockput(ip);
    80005b46:	8526                	mv	a0,s1
    80005b48:	ffffe097          	auipc	ra,0xffffe
    80005b4c:	4ce080e7          	jalr	1230(ra) # 80004016 <iunlockput>
  end_op();
    80005b50:	fffff097          	auipc	ra,0xfffff
    80005b54:	cbe080e7          	jalr	-834(ra) # 8000480e <end_op>
  return -1;
    80005b58:	57fd                	li	a5,-1
}
    80005b5a:	853e                	mv	a0,a5
    80005b5c:	70b2                	ld	ra,296(sp)
    80005b5e:	7412                	ld	s0,288(sp)
    80005b60:	64f2                	ld	s1,280(sp)
    80005b62:	6952                	ld	s2,272(sp)
    80005b64:	6155                	addi	sp,sp,304
    80005b66:	8082                	ret

0000000080005b68 <sys_unlink>:
{
    80005b68:	7151                	addi	sp,sp,-240
    80005b6a:	f586                	sd	ra,232(sp)
    80005b6c:	f1a2                	sd	s0,224(sp)
    80005b6e:	eda6                	sd	s1,216(sp)
    80005b70:	e9ca                	sd	s2,208(sp)
    80005b72:	e5ce                	sd	s3,200(sp)
    80005b74:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005b76:	08000613          	li	a2,128
    80005b7a:	f3040593          	addi	a1,s0,-208
    80005b7e:	4501                	li	a0,0
    80005b80:	ffffd097          	auipc	ra,0xffffd
    80005b84:	4f2080e7          	jalr	1266(ra) # 80003072 <argstr>
    80005b88:	18054163          	bltz	a0,80005d0a <sys_unlink+0x1a2>
  begin_op();
    80005b8c:	fffff097          	auipc	ra,0xfffff
    80005b90:	c04080e7          	jalr	-1020(ra) # 80004790 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005b94:	fb040593          	addi	a1,s0,-80
    80005b98:	f3040513          	addi	a0,s0,-208
    80005b9c:	fffff097          	auipc	ra,0xfffff
    80005ba0:	9f2080e7          	jalr	-1550(ra) # 8000458e <nameiparent>
    80005ba4:	84aa                	mv	s1,a0
    80005ba6:	c979                	beqz	a0,80005c7c <sys_unlink+0x114>
  ilock(dp);
    80005ba8:	ffffe097          	auipc	ra,0xffffe
    80005bac:	20c080e7          	jalr	524(ra) # 80003db4 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005bb0:	00003597          	auipc	a1,0x3
    80005bb4:	c8858593          	addi	a1,a1,-888 # 80008838 <syscalls+0x2c0>
    80005bb8:	fb040513          	addi	a0,s0,-80
    80005bbc:	ffffe097          	auipc	ra,0xffffe
    80005bc0:	6c2080e7          	jalr	1730(ra) # 8000427e <namecmp>
    80005bc4:	14050a63          	beqz	a0,80005d18 <sys_unlink+0x1b0>
    80005bc8:	00003597          	auipc	a1,0x3
    80005bcc:	c7858593          	addi	a1,a1,-904 # 80008840 <syscalls+0x2c8>
    80005bd0:	fb040513          	addi	a0,s0,-80
    80005bd4:	ffffe097          	auipc	ra,0xffffe
    80005bd8:	6aa080e7          	jalr	1706(ra) # 8000427e <namecmp>
    80005bdc:	12050e63          	beqz	a0,80005d18 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005be0:	f2c40613          	addi	a2,s0,-212
    80005be4:	fb040593          	addi	a1,s0,-80
    80005be8:	8526                	mv	a0,s1
    80005bea:	ffffe097          	auipc	ra,0xffffe
    80005bee:	6ae080e7          	jalr	1710(ra) # 80004298 <dirlookup>
    80005bf2:	892a                	mv	s2,a0
    80005bf4:	12050263          	beqz	a0,80005d18 <sys_unlink+0x1b0>
  ilock(ip);
    80005bf8:	ffffe097          	auipc	ra,0xffffe
    80005bfc:	1bc080e7          	jalr	444(ra) # 80003db4 <ilock>
  if(ip->nlink < 1)
    80005c00:	04a91783          	lh	a5,74(s2)
    80005c04:	08f05263          	blez	a5,80005c88 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005c08:	04491703          	lh	a4,68(s2)
    80005c0c:	4785                	li	a5,1
    80005c0e:	08f70563          	beq	a4,a5,80005c98 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005c12:	4641                	li	a2,16
    80005c14:	4581                	li	a1,0
    80005c16:	fc040513          	addi	a0,s0,-64
    80005c1a:	ffffb097          	auipc	ra,0xffffb
    80005c1e:	0b2080e7          	jalr	178(ra) # 80000ccc <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005c22:	4741                	li	a4,16
    80005c24:	f2c42683          	lw	a3,-212(s0)
    80005c28:	fc040613          	addi	a2,s0,-64
    80005c2c:	4581                	li	a1,0
    80005c2e:	8526                	mv	a0,s1
    80005c30:	ffffe097          	auipc	ra,0xffffe
    80005c34:	530080e7          	jalr	1328(ra) # 80004160 <writei>
    80005c38:	47c1                	li	a5,16
    80005c3a:	0af51563          	bne	a0,a5,80005ce4 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005c3e:	04491703          	lh	a4,68(s2)
    80005c42:	4785                	li	a5,1
    80005c44:	0af70863          	beq	a4,a5,80005cf4 <sys_unlink+0x18c>
  iunlockput(dp);
    80005c48:	8526                	mv	a0,s1
    80005c4a:	ffffe097          	auipc	ra,0xffffe
    80005c4e:	3cc080e7          	jalr	972(ra) # 80004016 <iunlockput>
  ip->nlink--;
    80005c52:	04a95783          	lhu	a5,74(s2)
    80005c56:	37fd                	addiw	a5,a5,-1
    80005c58:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005c5c:	854a                	mv	a0,s2
    80005c5e:	ffffe097          	auipc	ra,0xffffe
    80005c62:	08a080e7          	jalr	138(ra) # 80003ce8 <iupdate>
  iunlockput(ip);
    80005c66:	854a                	mv	a0,s2
    80005c68:	ffffe097          	auipc	ra,0xffffe
    80005c6c:	3ae080e7          	jalr	942(ra) # 80004016 <iunlockput>
  end_op();
    80005c70:	fffff097          	auipc	ra,0xfffff
    80005c74:	b9e080e7          	jalr	-1122(ra) # 8000480e <end_op>
  return 0;
    80005c78:	4501                	li	a0,0
    80005c7a:	a84d                	j	80005d2c <sys_unlink+0x1c4>
    end_op();
    80005c7c:	fffff097          	auipc	ra,0xfffff
    80005c80:	b92080e7          	jalr	-1134(ra) # 8000480e <end_op>
    return -1;
    80005c84:	557d                	li	a0,-1
    80005c86:	a05d                	j	80005d2c <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005c88:	00003517          	auipc	a0,0x3
    80005c8c:	be050513          	addi	a0,a0,-1056 # 80008868 <syscalls+0x2f0>
    80005c90:	ffffb097          	auipc	ra,0xffffb
    80005c94:	8aa080e7          	jalr	-1878(ra) # 8000053a <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005c98:	04c92703          	lw	a4,76(s2)
    80005c9c:	02000793          	li	a5,32
    80005ca0:	f6e7f9e3          	bgeu	a5,a4,80005c12 <sys_unlink+0xaa>
    80005ca4:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005ca8:	4741                	li	a4,16
    80005caa:	86ce                	mv	a3,s3
    80005cac:	f1840613          	addi	a2,s0,-232
    80005cb0:	4581                	li	a1,0
    80005cb2:	854a                	mv	a0,s2
    80005cb4:	ffffe097          	auipc	ra,0xffffe
    80005cb8:	3b4080e7          	jalr	948(ra) # 80004068 <readi>
    80005cbc:	47c1                	li	a5,16
    80005cbe:	00f51b63          	bne	a0,a5,80005cd4 <sys_unlink+0x16c>
    if(de.inum != 0)
    80005cc2:	f1845783          	lhu	a5,-232(s0)
    80005cc6:	e7a1                	bnez	a5,80005d0e <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005cc8:	29c1                	addiw	s3,s3,16
    80005cca:	04c92783          	lw	a5,76(s2)
    80005cce:	fcf9ede3          	bltu	s3,a5,80005ca8 <sys_unlink+0x140>
    80005cd2:	b781                	j	80005c12 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005cd4:	00003517          	auipc	a0,0x3
    80005cd8:	bac50513          	addi	a0,a0,-1108 # 80008880 <syscalls+0x308>
    80005cdc:	ffffb097          	auipc	ra,0xffffb
    80005ce0:	85e080e7          	jalr	-1954(ra) # 8000053a <panic>
    panic("unlink: writei");
    80005ce4:	00003517          	auipc	a0,0x3
    80005ce8:	bb450513          	addi	a0,a0,-1100 # 80008898 <syscalls+0x320>
    80005cec:	ffffb097          	auipc	ra,0xffffb
    80005cf0:	84e080e7          	jalr	-1970(ra) # 8000053a <panic>
    dp->nlink--;
    80005cf4:	04a4d783          	lhu	a5,74(s1)
    80005cf8:	37fd                	addiw	a5,a5,-1
    80005cfa:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005cfe:	8526                	mv	a0,s1
    80005d00:	ffffe097          	auipc	ra,0xffffe
    80005d04:	fe8080e7          	jalr	-24(ra) # 80003ce8 <iupdate>
    80005d08:	b781                	j	80005c48 <sys_unlink+0xe0>
    return -1;
    80005d0a:	557d                	li	a0,-1
    80005d0c:	a005                	j	80005d2c <sys_unlink+0x1c4>
    iunlockput(ip);
    80005d0e:	854a                	mv	a0,s2
    80005d10:	ffffe097          	auipc	ra,0xffffe
    80005d14:	306080e7          	jalr	774(ra) # 80004016 <iunlockput>
  iunlockput(dp);
    80005d18:	8526                	mv	a0,s1
    80005d1a:	ffffe097          	auipc	ra,0xffffe
    80005d1e:	2fc080e7          	jalr	764(ra) # 80004016 <iunlockput>
  end_op();
    80005d22:	fffff097          	auipc	ra,0xfffff
    80005d26:	aec080e7          	jalr	-1300(ra) # 8000480e <end_op>
  return -1;
    80005d2a:	557d                	li	a0,-1
}
    80005d2c:	70ae                	ld	ra,232(sp)
    80005d2e:	740e                	ld	s0,224(sp)
    80005d30:	64ee                	ld	s1,216(sp)
    80005d32:	694e                	ld	s2,208(sp)
    80005d34:	69ae                	ld	s3,200(sp)
    80005d36:	616d                	addi	sp,sp,240
    80005d38:	8082                	ret

0000000080005d3a <sys_open>:

uint64
sys_open(void)
{
    80005d3a:	7131                	addi	sp,sp,-192
    80005d3c:	fd06                	sd	ra,184(sp)
    80005d3e:	f922                	sd	s0,176(sp)
    80005d40:	f526                	sd	s1,168(sp)
    80005d42:	f14a                	sd	s2,160(sp)
    80005d44:	ed4e                	sd	s3,152(sp)
    80005d46:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005d48:	08000613          	li	a2,128
    80005d4c:	f5040593          	addi	a1,s0,-176
    80005d50:	4501                	li	a0,0
    80005d52:	ffffd097          	auipc	ra,0xffffd
    80005d56:	320080e7          	jalr	800(ra) # 80003072 <argstr>
    return -1;
    80005d5a:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005d5c:	0c054163          	bltz	a0,80005e1e <sys_open+0xe4>
    80005d60:	f4c40593          	addi	a1,s0,-180
    80005d64:	4505                	li	a0,1
    80005d66:	ffffd097          	auipc	ra,0xffffd
    80005d6a:	2c8080e7          	jalr	712(ra) # 8000302e <argint>
    80005d6e:	0a054863          	bltz	a0,80005e1e <sys_open+0xe4>

  begin_op();
    80005d72:	fffff097          	auipc	ra,0xfffff
    80005d76:	a1e080e7          	jalr	-1506(ra) # 80004790 <begin_op>

  if(omode & O_CREATE){
    80005d7a:	f4c42783          	lw	a5,-180(s0)
    80005d7e:	2007f793          	andi	a5,a5,512
    80005d82:	cbdd                	beqz	a5,80005e38 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005d84:	4681                	li	a3,0
    80005d86:	4601                	li	a2,0
    80005d88:	4589                	li	a1,2
    80005d8a:	f5040513          	addi	a0,s0,-176
    80005d8e:	00000097          	auipc	ra,0x0
    80005d92:	970080e7          	jalr	-1680(ra) # 800056fe <create>
    80005d96:	892a                	mv	s2,a0
    if(ip == 0){
    80005d98:	c959                	beqz	a0,80005e2e <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005d9a:	04491703          	lh	a4,68(s2)
    80005d9e:	478d                	li	a5,3
    80005da0:	00f71763          	bne	a4,a5,80005dae <sys_open+0x74>
    80005da4:	04695703          	lhu	a4,70(s2)
    80005da8:	47a5                	li	a5,9
    80005daa:	0ce7ec63          	bltu	a5,a4,80005e82 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005dae:	fffff097          	auipc	ra,0xfffff
    80005db2:	dee080e7          	jalr	-530(ra) # 80004b9c <filealloc>
    80005db6:	89aa                	mv	s3,a0
    80005db8:	10050263          	beqz	a0,80005ebc <sys_open+0x182>
    80005dbc:	00000097          	auipc	ra,0x0
    80005dc0:	900080e7          	jalr	-1792(ra) # 800056bc <fdalloc>
    80005dc4:	84aa                	mv	s1,a0
    80005dc6:	0e054663          	bltz	a0,80005eb2 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005dca:	04491703          	lh	a4,68(s2)
    80005dce:	478d                	li	a5,3
    80005dd0:	0cf70463          	beq	a4,a5,80005e98 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005dd4:	4789                	li	a5,2
    80005dd6:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005dda:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005dde:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005de2:	f4c42783          	lw	a5,-180(s0)
    80005de6:	0017c713          	xori	a4,a5,1
    80005dea:	8b05                	andi	a4,a4,1
    80005dec:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005df0:	0037f713          	andi	a4,a5,3
    80005df4:	00e03733          	snez	a4,a4
    80005df8:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005dfc:	4007f793          	andi	a5,a5,1024
    80005e00:	c791                	beqz	a5,80005e0c <sys_open+0xd2>
    80005e02:	04491703          	lh	a4,68(s2)
    80005e06:	4789                	li	a5,2
    80005e08:	08f70f63          	beq	a4,a5,80005ea6 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005e0c:	854a                	mv	a0,s2
    80005e0e:	ffffe097          	auipc	ra,0xffffe
    80005e12:	068080e7          	jalr	104(ra) # 80003e76 <iunlock>
  end_op();
    80005e16:	fffff097          	auipc	ra,0xfffff
    80005e1a:	9f8080e7          	jalr	-1544(ra) # 8000480e <end_op>

  return fd;
}
    80005e1e:	8526                	mv	a0,s1
    80005e20:	70ea                	ld	ra,184(sp)
    80005e22:	744a                	ld	s0,176(sp)
    80005e24:	74aa                	ld	s1,168(sp)
    80005e26:	790a                	ld	s2,160(sp)
    80005e28:	69ea                	ld	s3,152(sp)
    80005e2a:	6129                	addi	sp,sp,192
    80005e2c:	8082                	ret
      end_op();
    80005e2e:	fffff097          	auipc	ra,0xfffff
    80005e32:	9e0080e7          	jalr	-1568(ra) # 8000480e <end_op>
      return -1;
    80005e36:	b7e5                	j	80005e1e <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80005e38:	f5040513          	addi	a0,s0,-176
    80005e3c:	ffffe097          	auipc	ra,0xffffe
    80005e40:	734080e7          	jalr	1844(ra) # 80004570 <namei>
    80005e44:	892a                	mv	s2,a0
    80005e46:	c905                	beqz	a0,80005e76 <sys_open+0x13c>
    ilock(ip);
    80005e48:	ffffe097          	auipc	ra,0xffffe
    80005e4c:	f6c080e7          	jalr	-148(ra) # 80003db4 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005e50:	04491703          	lh	a4,68(s2)
    80005e54:	4785                	li	a5,1
    80005e56:	f4f712e3          	bne	a4,a5,80005d9a <sys_open+0x60>
    80005e5a:	f4c42783          	lw	a5,-180(s0)
    80005e5e:	dba1                	beqz	a5,80005dae <sys_open+0x74>
      iunlockput(ip);
    80005e60:	854a                	mv	a0,s2
    80005e62:	ffffe097          	auipc	ra,0xffffe
    80005e66:	1b4080e7          	jalr	436(ra) # 80004016 <iunlockput>
      end_op();
    80005e6a:	fffff097          	auipc	ra,0xfffff
    80005e6e:	9a4080e7          	jalr	-1628(ra) # 8000480e <end_op>
      return -1;
    80005e72:	54fd                	li	s1,-1
    80005e74:	b76d                	j	80005e1e <sys_open+0xe4>
      end_op();
    80005e76:	fffff097          	auipc	ra,0xfffff
    80005e7a:	998080e7          	jalr	-1640(ra) # 8000480e <end_op>
      return -1;
    80005e7e:	54fd                	li	s1,-1
    80005e80:	bf79                	j	80005e1e <sys_open+0xe4>
    iunlockput(ip);
    80005e82:	854a                	mv	a0,s2
    80005e84:	ffffe097          	auipc	ra,0xffffe
    80005e88:	192080e7          	jalr	402(ra) # 80004016 <iunlockput>
    end_op();
    80005e8c:	fffff097          	auipc	ra,0xfffff
    80005e90:	982080e7          	jalr	-1662(ra) # 8000480e <end_op>
    return -1;
    80005e94:	54fd                	li	s1,-1
    80005e96:	b761                	j	80005e1e <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005e98:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005e9c:	04691783          	lh	a5,70(s2)
    80005ea0:	02f99223          	sh	a5,36(s3)
    80005ea4:	bf2d                	j	80005dde <sys_open+0xa4>
    itrunc(ip);
    80005ea6:	854a                	mv	a0,s2
    80005ea8:	ffffe097          	auipc	ra,0xffffe
    80005eac:	01a080e7          	jalr	26(ra) # 80003ec2 <itrunc>
    80005eb0:	bfb1                	j	80005e0c <sys_open+0xd2>
      fileclose(f);
    80005eb2:	854e                	mv	a0,s3
    80005eb4:	fffff097          	auipc	ra,0xfffff
    80005eb8:	da4080e7          	jalr	-604(ra) # 80004c58 <fileclose>
    iunlockput(ip);
    80005ebc:	854a                	mv	a0,s2
    80005ebe:	ffffe097          	auipc	ra,0xffffe
    80005ec2:	158080e7          	jalr	344(ra) # 80004016 <iunlockput>
    end_op();
    80005ec6:	fffff097          	auipc	ra,0xfffff
    80005eca:	948080e7          	jalr	-1720(ra) # 8000480e <end_op>
    return -1;
    80005ece:	54fd                	li	s1,-1
    80005ed0:	b7b9                	j	80005e1e <sys_open+0xe4>

0000000080005ed2 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005ed2:	7175                	addi	sp,sp,-144
    80005ed4:	e506                	sd	ra,136(sp)
    80005ed6:	e122                	sd	s0,128(sp)
    80005ed8:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005eda:	fffff097          	auipc	ra,0xfffff
    80005ede:	8b6080e7          	jalr	-1866(ra) # 80004790 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005ee2:	08000613          	li	a2,128
    80005ee6:	f7040593          	addi	a1,s0,-144
    80005eea:	4501                	li	a0,0
    80005eec:	ffffd097          	auipc	ra,0xffffd
    80005ef0:	186080e7          	jalr	390(ra) # 80003072 <argstr>
    80005ef4:	02054963          	bltz	a0,80005f26 <sys_mkdir+0x54>
    80005ef8:	4681                	li	a3,0
    80005efa:	4601                	li	a2,0
    80005efc:	4585                	li	a1,1
    80005efe:	f7040513          	addi	a0,s0,-144
    80005f02:	fffff097          	auipc	ra,0xfffff
    80005f06:	7fc080e7          	jalr	2044(ra) # 800056fe <create>
    80005f0a:	cd11                	beqz	a0,80005f26 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005f0c:	ffffe097          	auipc	ra,0xffffe
    80005f10:	10a080e7          	jalr	266(ra) # 80004016 <iunlockput>
  end_op();
    80005f14:	fffff097          	auipc	ra,0xfffff
    80005f18:	8fa080e7          	jalr	-1798(ra) # 8000480e <end_op>
  return 0;
    80005f1c:	4501                	li	a0,0
}
    80005f1e:	60aa                	ld	ra,136(sp)
    80005f20:	640a                	ld	s0,128(sp)
    80005f22:	6149                	addi	sp,sp,144
    80005f24:	8082                	ret
    end_op();
    80005f26:	fffff097          	auipc	ra,0xfffff
    80005f2a:	8e8080e7          	jalr	-1816(ra) # 8000480e <end_op>
    return -1;
    80005f2e:	557d                	li	a0,-1
    80005f30:	b7fd                	j	80005f1e <sys_mkdir+0x4c>

0000000080005f32 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005f32:	7135                	addi	sp,sp,-160
    80005f34:	ed06                	sd	ra,152(sp)
    80005f36:	e922                	sd	s0,144(sp)
    80005f38:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005f3a:	fffff097          	auipc	ra,0xfffff
    80005f3e:	856080e7          	jalr	-1962(ra) # 80004790 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005f42:	08000613          	li	a2,128
    80005f46:	f7040593          	addi	a1,s0,-144
    80005f4a:	4501                	li	a0,0
    80005f4c:	ffffd097          	auipc	ra,0xffffd
    80005f50:	126080e7          	jalr	294(ra) # 80003072 <argstr>
    80005f54:	04054a63          	bltz	a0,80005fa8 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80005f58:	f6c40593          	addi	a1,s0,-148
    80005f5c:	4505                	li	a0,1
    80005f5e:	ffffd097          	auipc	ra,0xffffd
    80005f62:	0d0080e7          	jalr	208(ra) # 8000302e <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005f66:	04054163          	bltz	a0,80005fa8 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005f6a:	f6840593          	addi	a1,s0,-152
    80005f6e:	4509                	li	a0,2
    80005f70:	ffffd097          	auipc	ra,0xffffd
    80005f74:	0be080e7          	jalr	190(ra) # 8000302e <argint>
     argint(1, &major) < 0 ||
    80005f78:	02054863          	bltz	a0,80005fa8 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005f7c:	f6841683          	lh	a3,-152(s0)
    80005f80:	f6c41603          	lh	a2,-148(s0)
    80005f84:	458d                	li	a1,3
    80005f86:	f7040513          	addi	a0,s0,-144
    80005f8a:	fffff097          	auipc	ra,0xfffff
    80005f8e:	774080e7          	jalr	1908(ra) # 800056fe <create>
     argint(2, &minor) < 0 ||
    80005f92:	c919                	beqz	a0,80005fa8 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005f94:	ffffe097          	auipc	ra,0xffffe
    80005f98:	082080e7          	jalr	130(ra) # 80004016 <iunlockput>
  end_op();
    80005f9c:	fffff097          	auipc	ra,0xfffff
    80005fa0:	872080e7          	jalr	-1934(ra) # 8000480e <end_op>
  return 0;
    80005fa4:	4501                	li	a0,0
    80005fa6:	a031                	j	80005fb2 <sys_mknod+0x80>
    end_op();
    80005fa8:	fffff097          	auipc	ra,0xfffff
    80005fac:	866080e7          	jalr	-1946(ra) # 8000480e <end_op>
    return -1;
    80005fb0:	557d                	li	a0,-1
}
    80005fb2:	60ea                	ld	ra,152(sp)
    80005fb4:	644a                	ld	s0,144(sp)
    80005fb6:	610d                	addi	sp,sp,160
    80005fb8:	8082                	ret

0000000080005fba <sys_chdir>:

uint64
sys_chdir(void)
{
    80005fba:	7135                	addi	sp,sp,-160
    80005fbc:	ed06                	sd	ra,152(sp)
    80005fbe:	e922                	sd	s0,144(sp)
    80005fc0:	e526                	sd	s1,136(sp)
    80005fc2:	e14a                	sd	s2,128(sp)
    80005fc4:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005fc6:	ffffc097          	auipc	ra,0xffffc
    80005fca:	a12080e7          	jalr	-1518(ra) # 800019d8 <myproc>
    80005fce:	892a                	mv	s2,a0
  
  begin_op();
    80005fd0:	ffffe097          	auipc	ra,0xffffe
    80005fd4:	7c0080e7          	jalr	1984(ra) # 80004790 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005fd8:	08000613          	li	a2,128
    80005fdc:	f6040593          	addi	a1,s0,-160
    80005fe0:	4501                	li	a0,0
    80005fe2:	ffffd097          	auipc	ra,0xffffd
    80005fe6:	090080e7          	jalr	144(ra) # 80003072 <argstr>
    80005fea:	04054b63          	bltz	a0,80006040 <sys_chdir+0x86>
    80005fee:	f6040513          	addi	a0,s0,-160
    80005ff2:	ffffe097          	auipc	ra,0xffffe
    80005ff6:	57e080e7          	jalr	1406(ra) # 80004570 <namei>
    80005ffa:	84aa                	mv	s1,a0
    80005ffc:	c131                	beqz	a0,80006040 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005ffe:	ffffe097          	auipc	ra,0xffffe
    80006002:	db6080e7          	jalr	-586(ra) # 80003db4 <ilock>
  if(ip->type != T_DIR){
    80006006:	04449703          	lh	a4,68(s1)
    8000600a:	4785                	li	a5,1
    8000600c:	04f71063          	bne	a4,a5,8000604c <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80006010:	8526                	mv	a0,s1
    80006012:	ffffe097          	auipc	ra,0xffffe
    80006016:	e64080e7          	jalr	-412(ra) # 80003e76 <iunlock>
  iput(p->cwd);
    8000601a:	15093503          	ld	a0,336(s2)
    8000601e:	ffffe097          	auipc	ra,0xffffe
    80006022:	f50080e7          	jalr	-176(ra) # 80003f6e <iput>
  end_op();
    80006026:	ffffe097          	auipc	ra,0xffffe
    8000602a:	7e8080e7          	jalr	2024(ra) # 8000480e <end_op>
  p->cwd = ip;
    8000602e:	14993823          	sd	s1,336(s2)
  return 0;
    80006032:	4501                	li	a0,0
}
    80006034:	60ea                	ld	ra,152(sp)
    80006036:	644a                	ld	s0,144(sp)
    80006038:	64aa                	ld	s1,136(sp)
    8000603a:	690a                	ld	s2,128(sp)
    8000603c:	610d                	addi	sp,sp,160
    8000603e:	8082                	ret
    end_op();
    80006040:	ffffe097          	auipc	ra,0xffffe
    80006044:	7ce080e7          	jalr	1998(ra) # 8000480e <end_op>
    return -1;
    80006048:	557d                	li	a0,-1
    8000604a:	b7ed                	j	80006034 <sys_chdir+0x7a>
    iunlockput(ip);
    8000604c:	8526                	mv	a0,s1
    8000604e:	ffffe097          	auipc	ra,0xffffe
    80006052:	fc8080e7          	jalr	-56(ra) # 80004016 <iunlockput>
    end_op();
    80006056:	ffffe097          	auipc	ra,0xffffe
    8000605a:	7b8080e7          	jalr	1976(ra) # 8000480e <end_op>
    return -1;
    8000605e:	557d                	li	a0,-1
    80006060:	bfd1                	j	80006034 <sys_chdir+0x7a>

0000000080006062 <sys_exec>:

uint64
sys_exec(void)
{
    80006062:	7145                	addi	sp,sp,-464
    80006064:	e786                	sd	ra,456(sp)
    80006066:	e3a2                	sd	s0,448(sp)
    80006068:	ff26                	sd	s1,440(sp)
    8000606a:	fb4a                	sd	s2,432(sp)
    8000606c:	f74e                	sd	s3,424(sp)
    8000606e:	f352                	sd	s4,416(sp)
    80006070:	ef56                	sd	s5,408(sp)
    80006072:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80006074:	08000613          	li	a2,128
    80006078:	f4040593          	addi	a1,s0,-192
    8000607c:	4501                	li	a0,0
    8000607e:	ffffd097          	auipc	ra,0xffffd
    80006082:	ff4080e7          	jalr	-12(ra) # 80003072 <argstr>
    return -1;
    80006086:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80006088:	0c054b63          	bltz	a0,8000615e <sys_exec+0xfc>
    8000608c:	e3840593          	addi	a1,s0,-456
    80006090:	4505                	li	a0,1
    80006092:	ffffd097          	auipc	ra,0xffffd
    80006096:	fbe080e7          	jalr	-66(ra) # 80003050 <argaddr>
    8000609a:	0c054263          	bltz	a0,8000615e <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    8000609e:	10000613          	li	a2,256
    800060a2:	4581                	li	a1,0
    800060a4:	e4040513          	addi	a0,s0,-448
    800060a8:	ffffb097          	auipc	ra,0xffffb
    800060ac:	c24080e7          	jalr	-988(ra) # 80000ccc <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800060b0:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    800060b4:	89a6                	mv	s3,s1
    800060b6:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800060b8:	02000a13          	li	s4,32
    800060bc:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800060c0:	00391513          	slli	a0,s2,0x3
    800060c4:	e3040593          	addi	a1,s0,-464
    800060c8:	e3843783          	ld	a5,-456(s0)
    800060cc:	953e                	add	a0,a0,a5
    800060ce:	ffffd097          	auipc	ra,0xffffd
    800060d2:	ec6080e7          	jalr	-314(ra) # 80002f94 <fetchaddr>
    800060d6:	02054a63          	bltz	a0,8000610a <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    800060da:	e3043783          	ld	a5,-464(s0)
    800060de:	c3b9                	beqz	a5,80006124 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800060e0:	ffffb097          	auipc	ra,0xffffb
    800060e4:	a00080e7          	jalr	-1536(ra) # 80000ae0 <kalloc>
    800060e8:	85aa                	mv	a1,a0
    800060ea:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800060ee:	cd11                	beqz	a0,8000610a <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800060f0:	6605                	lui	a2,0x1
    800060f2:	e3043503          	ld	a0,-464(s0)
    800060f6:	ffffd097          	auipc	ra,0xffffd
    800060fa:	ef0080e7          	jalr	-272(ra) # 80002fe6 <fetchstr>
    800060fe:	00054663          	bltz	a0,8000610a <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80006102:	0905                	addi	s2,s2,1
    80006104:	09a1                	addi	s3,s3,8
    80006106:	fb491be3          	bne	s2,s4,800060bc <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000610a:	f4040913          	addi	s2,s0,-192
    8000610e:	6088                	ld	a0,0(s1)
    80006110:	c531                	beqz	a0,8000615c <sys_exec+0xfa>
    kfree(argv[i]);
    80006112:	ffffb097          	auipc	ra,0xffffb
    80006116:	8d0080e7          	jalr	-1840(ra) # 800009e2 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000611a:	04a1                	addi	s1,s1,8
    8000611c:	ff2499e3          	bne	s1,s2,8000610e <sys_exec+0xac>
  return -1;
    80006120:	597d                	li	s2,-1
    80006122:	a835                	j	8000615e <sys_exec+0xfc>
      argv[i] = 0;
    80006124:	0a8e                	slli	s5,s5,0x3
    80006126:	fc0a8793          	addi	a5,s5,-64 # ffffffffffffefc0 <end+0xffffffff7ffd6fc0>
    8000612a:	00878ab3          	add	s5,a5,s0
    8000612e:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80006132:	e4040593          	addi	a1,s0,-448
    80006136:	f4040513          	addi	a0,s0,-192
    8000613a:	fffff097          	auipc	ra,0xfffff
    8000613e:	172080e7          	jalr	370(ra) # 800052ac <exec>
    80006142:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006144:	f4040993          	addi	s3,s0,-192
    80006148:	6088                	ld	a0,0(s1)
    8000614a:	c911                	beqz	a0,8000615e <sys_exec+0xfc>
    kfree(argv[i]);
    8000614c:	ffffb097          	auipc	ra,0xffffb
    80006150:	896080e7          	jalr	-1898(ra) # 800009e2 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006154:	04a1                	addi	s1,s1,8
    80006156:	ff3499e3          	bne	s1,s3,80006148 <sys_exec+0xe6>
    8000615a:	a011                	j	8000615e <sys_exec+0xfc>
  return -1;
    8000615c:	597d                	li	s2,-1
}
    8000615e:	854a                	mv	a0,s2
    80006160:	60be                	ld	ra,456(sp)
    80006162:	641e                	ld	s0,448(sp)
    80006164:	74fa                	ld	s1,440(sp)
    80006166:	795a                	ld	s2,432(sp)
    80006168:	79ba                	ld	s3,424(sp)
    8000616a:	7a1a                	ld	s4,416(sp)
    8000616c:	6afa                	ld	s5,408(sp)
    8000616e:	6179                	addi	sp,sp,464
    80006170:	8082                	ret

0000000080006172 <sys_pipe>:

uint64
sys_pipe(void)
{
    80006172:	7139                	addi	sp,sp,-64
    80006174:	fc06                	sd	ra,56(sp)
    80006176:	f822                	sd	s0,48(sp)
    80006178:	f426                	sd	s1,40(sp)
    8000617a:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000617c:	ffffc097          	auipc	ra,0xffffc
    80006180:	85c080e7          	jalr	-1956(ra) # 800019d8 <myproc>
    80006184:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80006186:	fd840593          	addi	a1,s0,-40
    8000618a:	4501                	li	a0,0
    8000618c:	ffffd097          	auipc	ra,0xffffd
    80006190:	ec4080e7          	jalr	-316(ra) # 80003050 <argaddr>
    return -1;
    80006194:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80006196:	0e054063          	bltz	a0,80006276 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    8000619a:	fc840593          	addi	a1,s0,-56
    8000619e:	fd040513          	addi	a0,s0,-48
    800061a2:	fffff097          	auipc	ra,0xfffff
    800061a6:	de6080e7          	jalr	-538(ra) # 80004f88 <pipealloc>
    return -1;
    800061aa:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800061ac:	0c054563          	bltz	a0,80006276 <sys_pipe+0x104>
  fd0 = -1;
    800061b0:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800061b4:	fd043503          	ld	a0,-48(s0)
    800061b8:	fffff097          	auipc	ra,0xfffff
    800061bc:	504080e7          	jalr	1284(ra) # 800056bc <fdalloc>
    800061c0:	fca42223          	sw	a0,-60(s0)
    800061c4:	08054c63          	bltz	a0,8000625c <sys_pipe+0xea>
    800061c8:	fc843503          	ld	a0,-56(s0)
    800061cc:	fffff097          	auipc	ra,0xfffff
    800061d0:	4f0080e7          	jalr	1264(ra) # 800056bc <fdalloc>
    800061d4:	fca42023          	sw	a0,-64(s0)
    800061d8:	06054963          	bltz	a0,8000624a <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800061dc:	4691                	li	a3,4
    800061de:	fc440613          	addi	a2,s0,-60
    800061e2:	fd843583          	ld	a1,-40(s0)
    800061e6:	68a8                	ld	a0,80(s1)
    800061e8:	ffffb097          	auipc	ra,0xffffb
    800061ec:	47a080e7          	jalr	1146(ra) # 80001662 <copyout>
    800061f0:	02054063          	bltz	a0,80006210 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800061f4:	4691                	li	a3,4
    800061f6:	fc040613          	addi	a2,s0,-64
    800061fa:	fd843583          	ld	a1,-40(s0)
    800061fe:	0591                	addi	a1,a1,4
    80006200:	68a8                	ld	a0,80(s1)
    80006202:	ffffb097          	auipc	ra,0xffffb
    80006206:	460080e7          	jalr	1120(ra) # 80001662 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000620a:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000620c:	06055563          	bgez	a0,80006276 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80006210:	fc442783          	lw	a5,-60(s0)
    80006214:	07e9                	addi	a5,a5,26
    80006216:	078e                	slli	a5,a5,0x3
    80006218:	97a6                	add	a5,a5,s1
    8000621a:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000621e:	fc042783          	lw	a5,-64(s0)
    80006222:	07e9                	addi	a5,a5,26
    80006224:	078e                	slli	a5,a5,0x3
    80006226:	00f48533          	add	a0,s1,a5
    8000622a:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000622e:	fd043503          	ld	a0,-48(s0)
    80006232:	fffff097          	auipc	ra,0xfffff
    80006236:	a26080e7          	jalr	-1498(ra) # 80004c58 <fileclose>
    fileclose(wf);
    8000623a:	fc843503          	ld	a0,-56(s0)
    8000623e:	fffff097          	auipc	ra,0xfffff
    80006242:	a1a080e7          	jalr	-1510(ra) # 80004c58 <fileclose>
    return -1;
    80006246:	57fd                	li	a5,-1
    80006248:	a03d                	j	80006276 <sys_pipe+0x104>
    if(fd0 >= 0)
    8000624a:	fc442783          	lw	a5,-60(s0)
    8000624e:	0007c763          	bltz	a5,8000625c <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80006252:	07e9                	addi	a5,a5,26
    80006254:	078e                	slli	a5,a5,0x3
    80006256:	97a6                	add	a5,a5,s1
    80006258:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000625c:	fd043503          	ld	a0,-48(s0)
    80006260:	fffff097          	auipc	ra,0xfffff
    80006264:	9f8080e7          	jalr	-1544(ra) # 80004c58 <fileclose>
    fileclose(wf);
    80006268:	fc843503          	ld	a0,-56(s0)
    8000626c:	fffff097          	auipc	ra,0xfffff
    80006270:	9ec080e7          	jalr	-1556(ra) # 80004c58 <fileclose>
    return -1;
    80006274:	57fd                	li	a5,-1
}
    80006276:	853e                	mv	a0,a5
    80006278:	70e2                	ld	ra,56(sp)
    8000627a:	7442                	ld	s0,48(sp)
    8000627c:	74a2                	ld	s1,40(sp)
    8000627e:	6121                	addi	sp,sp,64
    80006280:	8082                	ret
	...

0000000080006290 <kernelvec>:
    80006290:	7111                	addi	sp,sp,-256
    80006292:	e006                	sd	ra,0(sp)
    80006294:	e40a                	sd	sp,8(sp)
    80006296:	e80e                	sd	gp,16(sp)
    80006298:	ec12                	sd	tp,24(sp)
    8000629a:	f016                	sd	t0,32(sp)
    8000629c:	f41a                	sd	t1,40(sp)
    8000629e:	f81e                	sd	t2,48(sp)
    800062a0:	fc22                	sd	s0,56(sp)
    800062a2:	e0a6                	sd	s1,64(sp)
    800062a4:	e4aa                	sd	a0,72(sp)
    800062a6:	e8ae                	sd	a1,80(sp)
    800062a8:	ecb2                	sd	a2,88(sp)
    800062aa:	f0b6                	sd	a3,96(sp)
    800062ac:	f4ba                	sd	a4,104(sp)
    800062ae:	f8be                	sd	a5,112(sp)
    800062b0:	fcc2                	sd	a6,120(sp)
    800062b2:	e146                	sd	a7,128(sp)
    800062b4:	e54a                	sd	s2,136(sp)
    800062b6:	e94e                	sd	s3,144(sp)
    800062b8:	ed52                	sd	s4,152(sp)
    800062ba:	f156                	sd	s5,160(sp)
    800062bc:	f55a                	sd	s6,168(sp)
    800062be:	f95e                	sd	s7,176(sp)
    800062c0:	fd62                	sd	s8,184(sp)
    800062c2:	e1e6                	sd	s9,192(sp)
    800062c4:	e5ea                	sd	s10,200(sp)
    800062c6:	e9ee                	sd	s11,208(sp)
    800062c8:	edf2                	sd	t3,216(sp)
    800062ca:	f1f6                	sd	t4,224(sp)
    800062cc:	f5fa                	sd	t5,232(sp)
    800062ce:	f9fe                	sd	t6,240(sp)
    800062d0:	b5bfc0ef          	jal	ra,80002e2a <kerneltrap>
    800062d4:	6082                	ld	ra,0(sp)
    800062d6:	6122                	ld	sp,8(sp)
    800062d8:	61c2                	ld	gp,16(sp)
    800062da:	7282                	ld	t0,32(sp)
    800062dc:	7322                	ld	t1,40(sp)
    800062de:	73c2                	ld	t2,48(sp)
    800062e0:	7462                	ld	s0,56(sp)
    800062e2:	6486                	ld	s1,64(sp)
    800062e4:	6526                	ld	a0,72(sp)
    800062e6:	65c6                	ld	a1,80(sp)
    800062e8:	6666                	ld	a2,88(sp)
    800062ea:	7686                	ld	a3,96(sp)
    800062ec:	7726                	ld	a4,104(sp)
    800062ee:	77c6                	ld	a5,112(sp)
    800062f0:	7866                	ld	a6,120(sp)
    800062f2:	688a                	ld	a7,128(sp)
    800062f4:	692a                	ld	s2,136(sp)
    800062f6:	69ca                	ld	s3,144(sp)
    800062f8:	6a6a                	ld	s4,152(sp)
    800062fa:	7a8a                	ld	s5,160(sp)
    800062fc:	7b2a                	ld	s6,168(sp)
    800062fe:	7bca                	ld	s7,176(sp)
    80006300:	7c6a                	ld	s8,184(sp)
    80006302:	6c8e                	ld	s9,192(sp)
    80006304:	6d2e                	ld	s10,200(sp)
    80006306:	6dce                	ld	s11,208(sp)
    80006308:	6e6e                	ld	t3,216(sp)
    8000630a:	7e8e                	ld	t4,224(sp)
    8000630c:	7f2e                	ld	t5,232(sp)
    8000630e:	7fce                	ld	t6,240(sp)
    80006310:	6111                	addi	sp,sp,256
    80006312:	10200073          	sret
    80006316:	00000013          	nop
    8000631a:	00000013          	nop
    8000631e:	0001                	nop

0000000080006320 <timervec>:
    80006320:	34051573          	csrrw	a0,mscratch,a0
    80006324:	e10c                	sd	a1,0(a0)
    80006326:	e510                	sd	a2,8(a0)
    80006328:	e914                	sd	a3,16(a0)
    8000632a:	6d0c                	ld	a1,24(a0)
    8000632c:	7110                	ld	a2,32(a0)
    8000632e:	6194                	ld	a3,0(a1)
    80006330:	96b2                	add	a3,a3,a2
    80006332:	e194                	sd	a3,0(a1)
    80006334:	4589                	li	a1,2
    80006336:	14459073          	csrw	sip,a1
    8000633a:	6914                	ld	a3,16(a0)
    8000633c:	6510                	ld	a2,8(a0)
    8000633e:	610c                	ld	a1,0(a0)
    80006340:	34051573          	csrrw	a0,mscratch,a0
    80006344:	30200073          	mret
	...

000000008000634a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000634a:	1141                	addi	sp,sp,-16
    8000634c:	e422                	sd	s0,8(sp)
    8000634e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006350:	0c0007b7          	lui	a5,0xc000
    80006354:	4705                	li	a4,1
    80006356:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006358:	c3d8                	sw	a4,4(a5)
}
    8000635a:	6422                	ld	s0,8(sp)
    8000635c:	0141                	addi	sp,sp,16
    8000635e:	8082                	ret

0000000080006360 <plicinithart>:

void
plicinithart(void)
{
    80006360:	1141                	addi	sp,sp,-16
    80006362:	e406                	sd	ra,8(sp)
    80006364:	e022                	sd	s0,0(sp)
    80006366:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006368:	ffffb097          	auipc	ra,0xffffb
    8000636c:	644080e7          	jalr	1604(ra) # 800019ac <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006370:	0085171b          	slliw	a4,a0,0x8
    80006374:	0c0027b7          	lui	a5,0xc002
    80006378:	97ba                	add	a5,a5,a4
    8000637a:	40200713          	li	a4,1026
    8000637e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006382:	00d5151b          	slliw	a0,a0,0xd
    80006386:	0c2017b7          	lui	a5,0xc201
    8000638a:	97aa                	add	a5,a5,a0
    8000638c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80006390:	60a2                	ld	ra,8(sp)
    80006392:	6402                	ld	s0,0(sp)
    80006394:	0141                	addi	sp,sp,16
    80006396:	8082                	ret

0000000080006398 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80006398:	1141                	addi	sp,sp,-16
    8000639a:	e406                	sd	ra,8(sp)
    8000639c:	e022                	sd	s0,0(sp)
    8000639e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800063a0:	ffffb097          	auipc	ra,0xffffb
    800063a4:	60c080e7          	jalr	1548(ra) # 800019ac <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800063a8:	00d5151b          	slliw	a0,a0,0xd
    800063ac:	0c2017b7          	lui	a5,0xc201
    800063b0:	97aa                	add	a5,a5,a0
  return irq;
}
    800063b2:	43c8                	lw	a0,4(a5)
    800063b4:	60a2                	ld	ra,8(sp)
    800063b6:	6402                	ld	s0,0(sp)
    800063b8:	0141                	addi	sp,sp,16
    800063ba:	8082                	ret

00000000800063bc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800063bc:	1101                	addi	sp,sp,-32
    800063be:	ec06                	sd	ra,24(sp)
    800063c0:	e822                	sd	s0,16(sp)
    800063c2:	e426                	sd	s1,8(sp)
    800063c4:	1000                	addi	s0,sp,32
    800063c6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800063c8:	ffffb097          	auipc	ra,0xffffb
    800063cc:	5e4080e7          	jalr	1508(ra) # 800019ac <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800063d0:	00d5151b          	slliw	a0,a0,0xd
    800063d4:	0c2017b7          	lui	a5,0xc201
    800063d8:	97aa                	add	a5,a5,a0
    800063da:	c3c4                	sw	s1,4(a5)
}
    800063dc:	60e2                	ld	ra,24(sp)
    800063de:	6442                	ld	s0,16(sp)
    800063e0:	64a2                	ld	s1,8(sp)
    800063e2:	6105                	addi	sp,sp,32
    800063e4:	8082                	ret

00000000800063e6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800063e6:	1141                	addi	sp,sp,-16
    800063e8:	e406                	sd	ra,8(sp)
    800063ea:	e022                	sd	s0,0(sp)
    800063ec:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800063ee:	479d                	li	a5,7
    800063f0:	06a7c863          	blt	a5,a0,80006460 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    800063f4:	0001f717          	auipc	a4,0x1f
    800063f8:	c0c70713          	addi	a4,a4,-1012 # 80025000 <disk>
    800063fc:	972a                	add	a4,a4,a0
    800063fe:	6789                	lui	a5,0x2
    80006400:	97ba                	add	a5,a5,a4
    80006402:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80006406:	e7ad                	bnez	a5,80006470 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006408:	00451793          	slli	a5,a0,0x4
    8000640c:	00021717          	auipc	a4,0x21
    80006410:	bf470713          	addi	a4,a4,-1036 # 80027000 <disk+0x2000>
    80006414:	6314                	ld	a3,0(a4)
    80006416:	96be                	add	a3,a3,a5
    80006418:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000641c:	6314                	ld	a3,0(a4)
    8000641e:	96be                	add	a3,a3,a5
    80006420:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80006424:	6314                	ld	a3,0(a4)
    80006426:	96be                	add	a3,a3,a5
    80006428:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000642c:	6318                	ld	a4,0(a4)
    8000642e:	97ba                	add	a5,a5,a4
    80006430:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80006434:	0001f717          	auipc	a4,0x1f
    80006438:	bcc70713          	addi	a4,a4,-1076 # 80025000 <disk>
    8000643c:	972a                	add	a4,a4,a0
    8000643e:	6789                	lui	a5,0x2
    80006440:	97ba                	add	a5,a5,a4
    80006442:	4705                	li	a4,1
    80006444:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80006448:	00021517          	auipc	a0,0x21
    8000644c:	bd050513          	addi	a0,a0,-1072 # 80027018 <disk+0x2018>
    80006450:	ffffc097          	auipc	ra,0xffffc
    80006454:	dfa080e7          	jalr	-518(ra) # 8000224a <wakeup>
}
    80006458:	60a2                	ld	ra,8(sp)
    8000645a:	6402                	ld	s0,0(sp)
    8000645c:	0141                	addi	sp,sp,16
    8000645e:	8082                	ret
    panic("free_desc 1");
    80006460:	00002517          	auipc	a0,0x2
    80006464:	44850513          	addi	a0,a0,1096 # 800088a8 <syscalls+0x330>
    80006468:	ffffa097          	auipc	ra,0xffffa
    8000646c:	0d2080e7          	jalr	210(ra) # 8000053a <panic>
    panic("free_desc 2");
    80006470:	00002517          	auipc	a0,0x2
    80006474:	44850513          	addi	a0,a0,1096 # 800088b8 <syscalls+0x340>
    80006478:	ffffa097          	auipc	ra,0xffffa
    8000647c:	0c2080e7          	jalr	194(ra) # 8000053a <panic>

0000000080006480 <virtio_disk_init>:
{
    80006480:	1101                	addi	sp,sp,-32
    80006482:	ec06                	sd	ra,24(sp)
    80006484:	e822                	sd	s0,16(sp)
    80006486:	e426                	sd	s1,8(sp)
    80006488:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000648a:	00002597          	auipc	a1,0x2
    8000648e:	43e58593          	addi	a1,a1,1086 # 800088c8 <syscalls+0x350>
    80006492:	00021517          	auipc	a0,0x21
    80006496:	c9650513          	addi	a0,a0,-874 # 80027128 <disk+0x2128>
    8000649a:	ffffa097          	auipc	ra,0xffffa
    8000649e:	6a6080e7          	jalr	1702(ra) # 80000b40 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800064a2:	100017b7          	lui	a5,0x10001
    800064a6:	4398                	lw	a4,0(a5)
    800064a8:	2701                	sext.w	a4,a4
    800064aa:	747277b7          	lui	a5,0x74727
    800064ae:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800064b2:	0ef71063          	bne	a4,a5,80006592 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800064b6:	100017b7          	lui	a5,0x10001
    800064ba:	43dc                	lw	a5,4(a5)
    800064bc:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800064be:	4705                	li	a4,1
    800064c0:	0ce79963          	bne	a5,a4,80006592 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800064c4:	100017b7          	lui	a5,0x10001
    800064c8:	479c                	lw	a5,8(a5)
    800064ca:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800064cc:	4709                	li	a4,2
    800064ce:	0ce79263          	bne	a5,a4,80006592 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800064d2:	100017b7          	lui	a5,0x10001
    800064d6:	47d8                	lw	a4,12(a5)
    800064d8:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800064da:	554d47b7          	lui	a5,0x554d4
    800064de:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800064e2:	0af71863          	bne	a4,a5,80006592 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    800064e6:	100017b7          	lui	a5,0x10001
    800064ea:	4705                	li	a4,1
    800064ec:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800064ee:	470d                	li	a4,3
    800064f0:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800064f2:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800064f4:	c7ffe6b7          	lui	a3,0xc7ffe
    800064f8:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd675f>
    800064fc:	8f75                	and	a4,a4,a3
    800064fe:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006500:	472d                	li	a4,11
    80006502:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006504:	473d                	li	a4,15
    80006506:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80006508:	6705                	lui	a4,0x1
    8000650a:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000650c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006510:	5bdc                	lw	a5,52(a5)
    80006512:	2781                	sext.w	a5,a5
  if(max == 0)
    80006514:	c7d9                	beqz	a5,800065a2 <virtio_disk_init+0x122>
  if(max < NUM)
    80006516:	471d                	li	a4,7
    80006518:	08f77d63          	bgeu	a4,a5,800065b2 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000651c:	100014b7          	lui	s1,0x10001
    80006520:	47a1                	li	a5,8
    80006522:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80006524:	6609                	lui	a2,0x2
    80006526:	4581                	li	a1,0
    80006528:	0001f517          	auipc	a0,0x1f
    8000652c:	ad850513          	addi	a0,a0,-1320 # 80025000 <disk>
    80006530:	ffffa097          	auipc	ra,0xffffa
    80006534:	79c080e7          	jalr	1948(ra) # 80000ccc <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80006538:	0001f717          	auipc	a4,0x1f
    8000653c:	ac870713          	addi	a4,a4,-1336 # 80025000 <disk>
    80006540:	00c75793          	srli	a5,a4,0xc
    80006544:	2781                	sext.w	a5,a5
    80006546:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    80006548:	00021797          	auipc	a5,0x21
    8000654c:	ab878793          	addi	a5,a5,-1352 # 80027000 <disk+0x2000>
    80006550:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80006552:	0001f717          	auipc	a4,0x1f
    80006556:	b2e70713          	addi	a4,a4,-1234 # 80025080 <disk+0x80>
    8000655a:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000655c:	00020717          	auipc	a4,0x20
    80006560:	aa470713          	addi	a4,a4,-1372 # 80026000 <disk+0x1000>
    80006564:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80006566:	4705                	li	a4,1
    80006568:	00e78c23          	sb	a4,24(a5)
    8000656c:	00e78ca3          	sb	a4,25(a5)
    80006570:	00e78d23          	sb	a4,26(a5)
    80006574:	00e78da3          	sb	a4,27(a5)
    80006578:	00e78e23          	sb	a4,28(a5)
    8000657c:	00e78ea3          	sb	a4,29(a5)
    80006580:	00e78f23          	sb	a4,30(a5)
    80006584:	00e78fa3          	sb	a4,31(a5)
}
    80006588:	60e2                	ld	ra,24(sp)
    8000658a:	6442                	ld	s0,16(sp)
    8000658c:	64a2                	ld	s1,8(sp)
    8000658e:	6105                	addi	sp,sp,32
    80006590:	8082                	ret
    panic("could not find virtio disk");
    80006592:	00002517          	auipc	a0,0x2
    80006596:	34650513          	addi	a0,a0,838 # 800088d8 <syscalls+0x360>
    8000659a:	ffffa097          	auipc	ra,0xffffa
    8000659e:	fa0080e7          	jalr	-96(ra) # 8000053a <panic>
    panic("virtio disk has no queue 0");
    800065a2:	00002517          	auipc	a0,0x2
    800065a6:	35650513          	addi	a0,a0,854 # 800088f8 <syscalls+0x380>
    800065aa:	ffffa097          	auipc	ra,0xffffa
    800065ae:	f90080e7          	jalr	-112(ra) # 8000053a <panic>
    panic("virtio disk max queue too short");
    800065b2:	00002517          	auipc	a0,0x2
    800065b6:	36650513          	addi	a0,a0,870 # 80008918 <syscalls+0x3a0>
    800065ba:	ffffa097          	auipc	ra,0xffffa
    800065be:	f80080e7          	jalr	-128(ra) # 8000053a <panic>

00000000800065c2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800065c2:	7119                	addi	sp,sp,-128
    800065c4:	fc86                	sd	ra,120(sp)
    800065c6:	f8a2                	sd	s0,112(sp)
    800065c8:	f4a6                	sd	s1,104(sp)
    800065ca:	f0ca                	sd	s2,96(sp)
    800065cc:	ecce                	sd	s3,88(sp)
    800065ce:	e8d2                	sd	s4,80(sp)
    800065d0:	e4d6                	sd	s5,72(sp)
    800065d2:	e0da                	sd	s6,64(sp)
    800065d4:	fc5e                	sd	s7,56(sp)
    800065d6:	f862                	sd	s8,48(sp)
    800065d8:	f466                	sd	s9,40(sp)
    800065da:	f06a                	sd	s10,32(sp)
    800065dc:	ec6e                	sd	s11,24(sp)
    800065de:	0100                	addi	s0,sp,128
    800065e0:	8aaa                	mv	s5,a0
    800065e2:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800065e4:	00c52c83          	lw	s9,12(a0)
    800065e8:	001c9c9b          	slliw	s9,s9,0x1
    800065ec:	1c82                	slli	s9,s9,0x20
    800065ee:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800065f2:	00021517          	auipc	a0,0x21
    800065f6:	b3650513          	addi	a0,a0,-1226 # 80027128 <disk+0x2128>
    800065fa:	ffffa097          	auipc	ra,0xffffa
    800065fe:	5d6080e7          	jalr	1494(ra) # 80000bd0 <acquire>
  for(int i = 0; i < 3; i++){
    80006602:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80006604:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006606:	0001fc17          	auipc	s8,0x1f
    8000660a:	9fac0c13          	addi	s8,s8,-1542 # 80025000 <disk>
    8000660e:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    80006610:	4b0d                	li	s6,3
    80006612:	a0ad                	j	8000667c <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80006614:	00fc0733          	add	a4,s8,a5
    80006618:	975e                	add	a4,a4,s7
    8000661a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000661e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006620:	0207c563          	bltz	a5,8000664a <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80006624:	2905                	addiw	s2,s2,1
    80006626:	0611                	addi	a2,a2,4
    80006628:	19690c63          	beq	s2,s6,800067c0 <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    8000662c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000662e:	00021717          	auipc	a4,0x21
    80006632:	9ea70713          	addi	a4,a4,-1558 # 80027018 <disk+0x2018>
    80006636:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80006638:	00074683          	lbu	a3,0(a4)
    8000663c:	fee1                	bnez	a3,80006614 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    8000663e:	2785                	addiw	a5,a5,1
    80006640:	0705                	addi	a4,a4,1
    80006642:	fe979be3          	bne	a5,s1,80006638 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80006646:	57fd                	li	a5,-1
    80006648:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000664a:	01205d63          	blez	s2,80006664 <virtio_disk_rw+0xa2>
    8000664e:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80006650:	000a2503          	lw	a0,0(s4)
    80006654:	00000097          	auipc	ra,0x0
    80006658:	d92080e7          	jalr	-622(ra) # 800063e6 <free_desc>
      for(int j = 0; j < i; j++)
    8000665c:	2d85                	addiw	s11,s11,1
    8000665e:	0a11                	addi	s4,s4,4
    80006660:	ff2d98e3          	bne	s11,s2,80006650 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006664:	00021597          	auipc	a1,0x21
    80006668:	ac458593          	addi	a1,a1,-1340 # 80027128 <disk+0x2128>
    8000666c:	00021517          	auipc	a0,0x21
    80006670:	9ac50513          	addi	a0,a0,-1620 # 80027018 <disk+0x2018>
    80006674:	ffffc097          	auipc	ra,0xffffc
    80006678:	a4a080e7          	jalr	-1462(ra) # 800020be <sleep>
  for(int i = 0; i < 3; i++){
    8000667c:	f8040a13          	addi	s4,s0,-128
{
    80006680:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80006682:	894e                	mv	s2,s3
    80006684:	b765                	j	8000662c <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80006686:	00021697          	auipc	a3,0x21
    8000668a:	97a6b683          	ld	a3,-1670(a3) # 80027000 <disk+0x2000>
    8000668e:	96ba                	add	a3,a3,a4
    80006690:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006694:	0001f817          	auipc	a6,0x1f
    80006698:	96c80813          	addi	a6,a6,-1684 # 80025000 <disk>
    8000669c:	00021697          	auipc	a3,0x21
    800066a0:	96468693          	addi	a3,a3,-1692 # 80027000 <disk+0x2000>
    800066a4:	6290                	ld	a2,0(a3)
    800066a6:	963a                	add	a2,a2,a4
    800066a8:	00c65583          	lhu	a1,12(a2) # 200c <_entry-0x7fffdff4>
    800066ac:	0015e593          	ori	a1,a1,1
    800066b0:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    800066b4:	f8842603          	lw	a2,-120(s0)
    800066b8:	628c                	ld	a1,0(a3)
    800066ba:	972e                	add	a4,a4,a1
    800066bc:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800066c0:	20050593          	addi	a1,a0,512
    800066c4:	0592                	slli	a1,a1,0x4
    800066c6:	95c2                	add	a1,a1,a6
    800066c8:	577d                	li	a4,-1
    800066ca:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800066ce:	00461713          	slli	a4,a2,0x4
    800066d2:	6290                	ld	a2,0(a3)
    800066d4:	963a                	add	a2,a2,a4
    800066d6:	03078793          	addi	a5,a5,48
    800066da:	97c2                	add	a5,a5,a6
    800066dc:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    800066de:	629c                	ld	a5,0(a3)
    800066e0:	97ba                	add	a5,a5,a4
    800066e2:	4605                	li	a2,1
    800066e4:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800066e6:	629c                	ld	a5,0(a3)
    800066e8:	97ba                	add	a5,a5,a4
    800066ea:	4809                	li	a6,2
    800066ec:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800066f0:	629c                	ld	a5,0(a3)
    800066f2:	97ba                	add	a5,a5,a4
    800066f4:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800066f8:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    800066fc:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006700:	6698                	ld	a4,8(a3)
    80006702:	00275783          	lhu	a5,2(a4)
    80006706:	8b9d                	andi	a5,a5,7
    80006708:	0786                	slli	a5,a5,0x1
    8000670a:	973e                	add	a4,a4,a5
    8000670c:	00a71223          	sh	a0,4(a4)

  __sync_synchronize();
    80006710:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80006714:	6698                	ld	a4,8(a3)
    80006716:	00275783          	lhu	a5,2(a4)
    8000671a:	2785                	addiw	a5,a5,1
    8000671c:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006720:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006724:	100017b7          	lui	a5,0x10001
    80006728:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000672c:	004aa783          	lw	a5,4(s5)
    80006730:	02c79163          	bne	a5,a2,80006752 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80006734:	00021917          	auipc	s2,0x21
    80006738:	9f490913          	addi	s2,s2,-1548 # 80027128 <disk+0x2128>
  while(b->disk == 1) {
    8000673c:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000673e:	85ca                	mv	a1,s2
    80006740:	8556                	mv	a0,s5
    80006742:	ffffc097          	auipc	ra,0xffffc
    80006746:	97c080e7          	jalr	-1668(ra) # 800020be <sleep>
  while(b->disk == 1) {
    8000674a:	004aa783          	lw	a5,4(s5)
    8000674e:	fe9788e3          	beq	a5,s1,8000673e <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80006752:	f8042903          	lw	s2,-128(s0)
    80006756:	20090713          	addi	a4,s2,512
    8000675a:	0712                	slli	a4,a4,0x4
    8000675c:	0001f797          	auipc	a5,0x1f
    80006760:	8a478793          	addi	a5,a5,-1884 # 80025000 <disk>
    80006764:	97ba                	add	a5,a5,a4
    80006766:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    8000676a:	00021997          	auipc	s3,0x21
    8000676e:	89698993          	addi	s3,s3,-1898 # 80027000 <disk+0x2000>
    80006772:	00491713          	slli	a4,s2,0x4
    80006776:	0009b783          	ld	a5,0(s3)
    8000677a:	97ba                	add	a5,a5,a4
    8000677c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006780:	854a                	mv	a0,s2
    80006782:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006786:	00000097          	auipc	ra,0x0
    8000678a:	c60080e7          	jalr	-928(ra) # 800063e6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000678e:	8885                	andi	s1,s1,1
    80006790:	f0ed                	bnez	s1,80006772 <virtio_disk_rw+0x1b0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006792:	00021517          	auipc	a0,0x21
    80006796:	99650513          	addi	a0,a0,-1642 # 80027128 <disk+0x2128>
    8000679a:	ffffa097          	auipc	ra,0xffffa
    8000679e:	4ea080e7          	jalr	1258(ra) # 80000c84 <release>
}
    800067a2:	70e6                	ld	ra,120(sp)
    800067a4:	7446                	ld	s0,112(sp)
    800067a6:	74a6                	ld	s1,104(sp)
    800067a8:	7906                	ld	s2,96(sp)
    800067aa:	69e6                	ld	s3,88(sp)
    800067ac:	6a46                	ld	s4,80(sp)
    800067ae:	6aa6                	ld	s5,72(sp)
    800067b0:	6b06                	ld	s6,64(sp)
    800067b2:	7be2                	ld	s7,56(sp)
    800067b4:	7c42                	ld	s8,48(sp)
    800067b6:	7ca2                	ld	s9,40(sp)
    800067b8:	7d02                	ld	s10,32(sp)
    800067ba:	6de2                	ld	s11,24(sp)
    800067bc:	6109                	addi	sp,sp,128
    800067be:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800067c0:	f8042503          	lw	a0,-128(s0)
    800067c4:	20050793          	addi	a5,a0,512
    800067c8:	0792                	slli	a5,a5,0x4
  if(write)
    800067ca:	0001f817          	auipc	a6,0x1f
    800067ce:	83680813          	addi	a6,a6,-1994 # 80025000 <disk>
    800067d2:	00f80733          	add	a4,a6,a5
    800067d6:	01a036b3          	snez	a3,s10
    800067da:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    800067de:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800067e2:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    800067e6:	7679                	lui	a2,0xffffe
    800067e8:	963e                	add	a2,a2,a5
    800067ea:	00021697          	auipc	a3,0x21
    800067ee:	81668693          	addi	a3,a3,-2026 # 80027000 <disk+0x2000>
    800067f2:	6298                	ld	a4,0(a3)
    800067f4:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800067f6:	0a878593          	addi	a1,a5,168
    800067fa:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    800067fc:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800067fe:	6298                	ld	a4,0(a3)
    80006800:	9732                	add	a4,a4,a2
    80006802:	45c1                	li	a1,16
    80006804:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006806:	6298                	ld	a4,0(a3)
    80006808:	9732                	add	a4,a4,a2
    8000680a:	4585                	li	a1,1
    8000680c:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80006810:	f8442703          	lw	a4,-124(s0)
    80006814:	628c                	ld	a1,0(a3)
    80006816:	962e                	add	a2,a2,a1
    80006818:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd600e>
  disk.desc[idx[1]].addr = (uint64) b->data;
    8000681c:	0712                	slli	a4,a4,0x4
    8000681e:	6290                	ld	a2,0(a3)
    80006820:	963a                	add	a2,a2,a4
    80006822:	058a8593          	addi	a1,s5,88
    80006826:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80006828:	6294                	ld	a3,0(a3)
    8000682a:	96ba                	add	a3,a3,a4
    8000682c:	40000613          	li	a2,1024
    80006830:	c690                	sw	a2,8(a3)
  if(write)
    80006832:	e40d1ae3          	bnez	s10,80006686 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80006836:	00020697          	auipc	a3,0x20
    8000683a:	7ca6b683          	ld	a3,1994(a3) # 80027000 <disk+0x2000>
    8000683e:	96ba                	add	a3,a3,a4
    80006840:	4609                	li	a2,2
    80006842:	00c69623          	sh	a2,12(a3)
    80006846:	b5b9                	j	80006694 <virtio_disk_rw+0xd2>

0000000080006848 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006848:	1101                	addi	sp,sp,-32
    8000684a:	ec06                	sd	ra,24(sp)
    8000684c:	e822                	sd	s0,16(sp)
    8000684e:	e426                	sd	s1,8(sp)
    80006850:	e04a                	sd	s2,0(sp)
    80006852:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006854:	00021517          	auipc	a0,0x21
    80006858:	8d450513          	addi	a0,a0,-1836 # 80027128 <disk+0x2128>
    8000685c:	ffffa097          	auipc	ra,0xffffa
    80006860:	374080e7          	jalr	884(ra) # 80000bd0 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006864:	10001737          	lui	a4,0x10001
    80006868:	533c                	lw	a5,96(a4)
    8000686a:	8b8d                	andi	a5,a5,3
    8000686c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000686e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006872:	00020797          	auipc	a5,0x20
    80006876:	78e78793          	addi	a5,a5,1934 # 80027000 <disk+0x2000>
    8000687a:	6b94                	ld	a3,16(a5)
    8000687c:	0207d703          	lhu	a4,32(a5)
    80006880:	0026d783          	lhu	a5,2(a3)
    80006884:	06f70163          	beq	a4,a5,800068e6 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006888:	0001e917          	auipc	s2,0x1e
    8000688c:	77890913          	addi	s2,s2,1912 # 80025000 <disk>
    80006890:	00020497          	auipc	s1,0x20
    80006894:	77048493          	addi	s1,s1,1904 # 80027000 <disk+0x2000>
    __sync_synchronize();
    80006898:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000689c:	6898                	ld	a4,16(s1)
    8000689e:	0204d783          	lhu	a5,32(s1)
    800068a2:	8b9d                	andi	a5,a5,7
    800068a4:	078e                	slli	a5,a5,0x3
    800068a6:	97ba                	add	a5,a5,a4
    800068a8:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800068aa:	20078713          	addi	a4,a5,512
    800068ae:	0712                	slli	a4,a4,0x4
    800068b0:	974a                	add	a4,a4,s2
    800068b2:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800068b6:	e731                	bnez	a4,80006902 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800068b8:	20078793          	addi	a5,a5,512
    800068bc:	0792                	slli	a5,a5,0x4
    800068be:	97ca                	add	a5,a5,s2
    800068c0:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800068c2:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800068c6:	ffffc097          	auipc	ra,0xffffc
    800068ca:	984080e7          	jalr	-1660(ra) # 8000224a <wakeup>

    disk.used_idx += 1;
    800068ce:	0204d783          	lhu	a5,32(s1)
    800068d2:	2785                	addiw	a5,a5,1
    800068d4:	17c2                	slli	a5,a5,0x30
    800068d6:	93c1                	srli	a5,a5,0x30
    800068d8:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800068dc:	6898                	ld	a4,16(s1)
    800068de:	00275703          	lhu	a4,2(a4)
    800068e2:	faf71be3          	bne	a4,a5,80006898 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800068e6:	00021517          	auipc	a0,0x21
    800068ea:	84250513          	addi	a0,a0,-1982 # 80027128 <disk+0x2128>
    800068ee:	ffffa097          	auipc	ra,0xffffa
    800068f2:	396080e7          	jalr	918(ra) # 80000c84 <release>
}
    800068f6:	60e2                	ld	ra,24(sp)
    800068f8:	6442                	ld	s0,16(sp)
    800068fa:	64a2                	ld	s1,8(sp)
    800068fc:	6902                	ld	s2,0(sp)
    800068fe:	6105                	addi	sp,sp,32
    80006900:	8082                	ret
      panic("virtio_disk_intr status");
    80006902:	00002517          	auipc	a0,0x2
    80006906:	03650513          	addi	a0,a0,54 # 80008938 <syscalls+0x3c0>
    8000690a:	ffffa097          	auipc	ra,0xffffa
    8000690e:	c30080e7          	jalr	-976(ra) # 8000053a <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
