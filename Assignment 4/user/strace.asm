
user/_strace:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/param.h"

int main(int argc, char *argv[]){
   0:	712d                	addi	sp,sp,-288
   2:	ee06                	sd	ra,280(sp)
   4:	ea22                	sd	s0,272(sp)
   6:	e626                	sd	s1,264(sp)
   8:	e24a                	sd	s2,256(sp)
   a:	1200                	addi	s0,sp,288
   c:	892a                	mv	s2,a0
   e:	84ae                	mv	s1,a1

    int n = atoi(argv[1]);
  10:	6588                	ld	a0,8(a1)
  12:	00000097          	auipc	ra,0x0
  16:	1c8080e7          	jalr	456(ra) # 1da <atoi>
    
    char *exec_args[MAXARG];

    trace(n);
  1a:	00000097          	auipc	ra,0x0
  1e:	35a080e7          	jalr	858(ra) # 374 <trace>

    for(int i=2;i<argc;i++)
  22:	4789                	li	a5,2
  24:	0327d563          	bge	a5,s2,4e <main+0x4e>
  28:	01048593          	addi	a1,s1,16
  2c:	ee040793          	addi	a5,s0,-288
  30:	ffd9071b          	addiw	a4,s2,-3
  34:	02071693          	slli	a3,a4,0x20
  38:	01d6d713          	srli	a4,a3,0x1d
  3c:	ee840693          	addi	a3,s0,-280
  40:	9736                	add	a4,a4,a3
        exec_args[i-2] = argv[i];
  42:	6194                	ld	a3,0(a1)
  44:	e394                	sd	a3,0(a5)
    for(int i=2;i<argc;i++)
  46:	05a1                	addi	a1,a1,8
  48:	07a1                	addi	a5,a5,8
  4a:	fee79ce3          	bne	a5,a4,42 <main+0x42>

    exec(exec_args[0], exec_args);
  4e:	ee040593          	addi	a1,s0,-288
  52:	ee043503          	ld	a0,-288(s0)
  56:	00000097          	auipc	ra,0x0
  5a:	2b6080e7          	jalr	694(ra) # 30c <exec>
    exit(0);
  5e:	4501                	li	a0,0
  60:	00000097          	auipc	ra,0x0
  64:	274080e7          	jalr	628(ra) # 2d4 <exit>

0000000000000068 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  68:	1141                	addi	sp,sp,-16
  6a:	e422                	sd	s0,8(sp)
  6c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  6e:	87aa                	mv	a5,a0
  70:	0585                	addi	a1,a1,1
  72:	0785                	addi	a5,a5,1
  74:	fff5c703          	lbu	a4,-1(a1)
  78:	fee78fa3          	sb	a4,-1(a5)
  7c:	fb75                	bnez	a4,70 <strcpy+0x8>
    ;
  return os;
}
  7e:	6422                	ld	s0,8(sp)
  80:	0141                	addi	sp,sp,16
  82:	8082                	ret

0000000000000084 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  84:	1141                	addi	sp,sp,-16
  86:	e422                	sd	s0,8(sp)
  88:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  8a:	00054783          	lbu	a5,0(a0)
  8e:	cb91                	beqz	a5,a2 <strcmp+0x1e>
  90:	0005c703          	lbu	a4,0(a1)
  94:	00f71763          	bne	a4,a5,a2 <strcmp+0x1e>
    p++, q++;
  98:	0505                	addi	a0,a0,1
  9a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  9c:	00054783          	lbu	a5,0(a0)
  a0:	fbe5                	bnez	a5,90 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  a2:	0005c503          	lbu	a0,0(a1)
}
  a6:	40a7853b          	subw	a0,a5,a0
  aa:	6422                	ld	s0,8(sp)
  ac:	0141                	addi	sp,sp,16
  ae:	8082                	ret

00000000000000b0 <strlen>:

uint
strlen(const char *s)
{
  b0:	1141                	addi	sp,sp,-16
  b2:	e422                	sd	s0,8(sp)
  b4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  b6:	00054783          	lbu	a5,0(a0)
  ba:	cf91                	beqz	a5,d6 <strlen+0x26>
  bc:	0505                	addi	a0,a0,1
  be:	87aa                	mv	a5,a0
  c0:	4685                	li	a3,1
  c2:	9e89                	subw	a3,a3,a0
  c4:	00f6853b          	addw	a0,a3,a5
  c8:	0785                	addi	a5,a5,1
  ca:	fff7c703          	lbu	a4,-1(a5)
  ce:	fb7d                	bnez	a4,c4 <strlen+0x14>
    ;
  return n;
}
  d0:	6422                	ld	s0,8(sp)
  d2:	0141                	addi	sp,sp,16
  d4:	8082                	ret
  for(n = 0; s[n]; n++)
  d6:	4501                	li	a0,0
  d8:	bfe5                	j	d0 <strlen+0x20>

00000000000000da <memset>:

void*
memset(void *dst, int c, uint n)
{
  da:	1141                	addi	sp,sp,-16
  dc:	e422                	sd	s0,8(sp)
  de:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  e0:	ca19                	beqz	a2,f6 <memset+0x1c>
  e2:	87aa                	mv	a5,a0
  e4:	1602                	slli	a2,a2,0x20
  e6:	9201                	srli	a2,a2,0x20
  e8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  ec:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  f0:	0785                	addi	a5,a5,1
  f2:	fee79de3          	bne	a5,a4,ec <memset+0x12>
  }
  return dst;
}
  f6:	6422                	ld	s0,8(sp)
  f8:	0141                	addi	sp,sp,16
  fa:	8082                	ret

00000000000000fc <strchr>:

char*
strchr(const char *s, char c)
{
  fc:	1141                	addi	sp,sp,-16
  fe:	e422                	sd	s0,8(sp)
 100:	0800                	addi	s0,sp,16
  for(; *s; s++)
 102:	00054783          	lbu	a5,0(a0)
 106:	cb99                	beqz	a5,11c <strchr+0x20>
    if(*s == c)
 108:	00f58763          	beq	a1,a5,116 <strchr+0x1a>
  for(; *s; s++)
 10c:	0505                	addi	a0,a0,1
 10e:	00054783          	lbu	a5,0(a0)
 112:	fbfd                	bnez	a5,108 <strchr+0xc>
      return (char*)s;
  return 0;
 114:	4501                	li	a0,0
}
 116:	6422                	ld	s0,8(sp)
 118:	0141                	addi	sp,sp,16
 11a:	8082                	ret
  return 0;
 11c:	4501                	li	a0,0
 11e:	bfe5                	j	116 <strchr+0x1a>

0000000000000120 <gets>:

char*
gets(char *buf, int max)
{
 120:	711d                	addi	sp,sp,-96
 122:	ec86                	sd	ra,88(sp)
 124:	e8a2                	sd	s0,80(sp)
 126:	e4a6                	sd	s1,72(sp)
 128:	e0ca                	sd	s2,64(sp)
 12a:	fc4e                	sd	s3,56(sp)
 12c:	f852                	sd	s4,48(sp)
 12e:	f456                	sd	s5,40(sp)
 130:	f05a                	sd	s6,32(sp)
 132:	ec5e                	sd	s7,24(sp)
 134:	1080                	addi	s0,sp,96
 136:	8baa                	mv	s7,a0
 138:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13a:	892a                	mv	s2,a0
 13c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 13e:	4aa9                	li	s5,10
 140:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 142:	89a6                	mv	s3,s1
 144:	2485                	addiw	s1,s1,1
 146:	0344d863          	bge	s1,s4,176 <gets+0x56>
    cc = read(0, &c, 1);
 14a:	4605                	li	a2,1
 14c:	faf40593          	addi	a1,s0,-81
 150:	4501                	li	a0,0
 152:	00000097          	auipc	ra,0x0
 156:	19a080e7          	jalr	410(ra) # 2ec <read>
    if(cc < 1)
 15a:	00a05e63          	blez	a0,176 <gets+0x56>
    buf[i++] = c;
 15e:	faf44783          	lbu	a5,-81(s0)
 162:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 166:	01578763          	beq	a5,s5,174 <gets+0x54>
 16a:	0905                	addi	s2,s2,1
 16c:	fd679be3          	bne	a5,s6,142 <gets+0x22>
  for(i=0; i+1 < max; ){
 170:	89a6                	mv	s3,s1
 172:	a011                	j	176 <gets+0x56>
 174:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 176:	99de                	add	s3,s3,s7
 178:	00098023          	sb	zero,0(s3)
  return buf;
}
 17c:	855e                	mv	a0,s7
 17e:	60e6                	ld	ra,88(sp)
 180:	6446                	ld	s0,80(sp)
 182:	64a6                	ld	s1,72(sp)
 184:	6906                	ld	s2,64(sp)
 186:	79e2                	ld	s3,56(sp)
 188:	7a42                	ld	s4,48(sp)
 18a:	7aa2                	ld	s5,40(sp)
 18c:	7b02                	ld	s6,32(sp)
 18e:	6be2                	ld	s7,24(sp)
 190:	6125                	addi	sp,sp,96
 192:	8082                	ret

0000000000000194 <stat>:

int
stat(const char *n, struct stat *st)
{
 194:	1101                	addi	sp,sp,-32
 196:	ec06                	sd	ra,24(sp)
 198:	e822                	sd	s0,16(sp)
 19a:	e426                	sd	s1,8(sp)
 19c:	e04a                	sd	s2,0(sp)
 19e:	1000                	addi	s0,sp,32
 1a0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a2:	4581                	li	a1,0
 1a4:	00000097          	auipc	ra,0x0
 1a8:	170080e7          	jalr	368(ra) # 314 <open>
  if(fd < 0)
 1ac:	02054563          	bltz	a0,1d6 <stat+0x42>
 1b0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1b2:	85ca                	mv	a1,s2
 1b4:	00000097          	auipc	ra,0x0
 1b8:	178080e7          	jalr	376(ra) # 32c <fstat>
 1bc:	892a                	mv	s2,a0
  close(fd);
 1be:	8526                	mv	a0,s1
 1c0:	00000097          	auipc	ra,0x0
 1c4:	13c080e7          	jalr	316(ra) # 2fc <close>
  return r;
}
 1c8:	854a                	mv	a0,s2
 1ca:	60e2                	ld	ra,24(sp)
 1cc:	6442                	ld	s0,16(sp)
 1ce:	64a2                	ld	s1,8(sp)
 1d0:	6902                	ld	s2,0(sp)
 1d2:	6105                	addi	sp,sp,32
 1d4:	8082                	ret
    return -1;
 1d6:	597d                	li	s2,-1
 1d8:	bfc5                	j	1c8 <stat+0x34>

00000000000001da <atoi>:

int
atoi(const char *s)
{
 1da:	1141                	addi	sp,sp,-16
 1dc:	e422                	sd	s0,8(sp)
 1de:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1e0:	00054683          	lbu	a3,0(a0)
 1e4:	fd06879b          	addiw	a5,a3,-48
 1e8:	0ff7f793          	zext.b	a5,a5
 1ec:	4625                	li	a2,9
 1ee:	02f66863          	bltu	a2,a5,21e <atoi+0x44>
 1f2:	872a                	mv	a4,a0
  n = 0;
 1f4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1f6:	0705                	addi	a4,a4,1
 1f8:	0025179b          	slliw	a5,a0,0x2
 1fc:	9fa9                	addw	a5,a5,a0
 1fe:	0017979b          	slliw	a5,a5,0x1
 202:	9fb5                	addw	a5,a5,a3
 204:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 208:	00074683          	lbu	a3,0(a4)
 20c:	fd06879b          	addiw	a5,a3,-48
 210:	0ff7f793          	zext.b	a5,a5
 214:	fef671e3          	bgeu	a2,a5,1f6 <atoi+0x1c>
  return n;
}
 218:	6422                	ld	s0,8(sp)
 21a:	0141                	addi	sp,sp,16
 21c:	8082                	ret
  n = 0;
 21e:	4501                	li	a0,0
 220:	bfe5                	j	218 <atoi+0x3e>

0000000000000222 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 222:	1141                	addi	sp,sp,-16
 224:	e422                	sd	s0,8(sp)
 226:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 228:	02b57463          	bgeu	a0,a1,250 <memmove+0x2e>
    while(n-- > 0)
 22c:	00c05f63          	blez	a2,24a <memmove+0x28>
 230:	1602                	slli	a2,a2,0x20
 232:	9201                	srli	a2,a2,0x20
 234:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 238:	872a                	mv	a4,a0
      *dst++ = *src++;
 23a:	0585                	addi	a1,a1,1
 23c:	0705                	addi	a4,a4,1
 23e:	fff5c683          	lbu	a3,-1(a1)
 242:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 246:	fee79ae3          	bne	a5,a4,23a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 24a:	6422                	ld	s0,8(sp)
 24c:	0141                	addi	sp,sp,16
 24e:	8082                	ret
    dst += n;
 250:	00c50733          	add	a4,a0,a2
    src += n;
 254:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 256:	fec05ae3          	blez	a2,24a <memmove+0x28>
 25a:	fff6079b          	addiw	a5,a2,-1
 25e:	1782                	slli	a5,a5,0x20
 260:	9381                	srli	a5,a5,0x20
 262:	fff7c793          	not	a5,a5
 266:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 268:	15fd                	addi	a1,a1,-1
 26a:	177d                	addi	a4,a4,-1
 26c:	0005c683          	lbu	a3,0(a1)
 270:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 274:	fee79ae3          	bne	a5,a4,268 <memmove+0x46>
 278:	bfc9                	j	24a <memmove+0x28>

000000000000027a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 27a:	1141                	addi	sp,sp,-16
 27c:	e422                	sd	s0,8(sp)
 27e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 280:	ca05                	beqz	a2,2b0 <memcmp+0x36>
 282:	fff6069b          	addiw	a3,a2,-1
 286:	1682                	slli	a3,a3,0x20
 288:	9281                	srli	a3,a3,0x20
 28a:	0685                	addi	a3,a3,1
 28c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 28e:	00054783          	lbu	a5,0(a0)
 292:	0005c703          	lbu	a4,0(a1)
 296:	00e79863          	bne	a5,a4,2a6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 29a:	0505                	addi	a0,a0,1
    p2++;
 29c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 29e:	fed518e3          	bne	a0,a3,28e <memcmp+0x14>
  }
  return 0;
 2a2:	4501                	li	a0,0
 2a4:	a019                	j	2aa <memcmp+0x30>
      return *p1 - *p2;
 2a6:	40e7853b          	subw	a0,a5,a4
}
 2aa:	6422                	ld	s0,8(sp)
 2ac:	0141                	addi	sp,sp,16
 2ae:	8082                	ret
  return 0;
 2b0:	4501                	li	a0,0
 2b2:	bfe5                	j	2aa <memcmp+0x30>

00000000000002b4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e406                	sd	ra,8(sp)
 2b8:	e022                	sd	s0,0(sp)
 2ba:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2bc:	00000097          	auipc	ra,0x0
 2c0:	f66080e7          	jalr	-154(ra) # 222 <memmove>
}
 2c4:	60a2                	ld	ra,8(sp)
 2c6:	6402                	ld	s0,0(sp)
 2c8:	0141                	addi	sp,sp,16
 2ca:	8082                	ret

00000000000002cc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2cc:	4885                	li	a7,1
 ecall
 2ce:	00000073          	ecall
 ret
 2d2:	8082                	ret

00000000000002d4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2d4:	4889                	li	a7,2
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <wait>:
.global wait
wait:
 li a7, SYS_wait
 2dc:	488d                	li	a7,3
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2e4:	4891                	li	a7,4
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <read>:
.global read
read:
 li a7, SYS_read
 2ec:	4895                	li	a7,5
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <write>:
.global write
write:
 li a7, SYS_write
 2f4:	48c1                	li	a7,16
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <close>:
.global close
close:
 li a7, SYS_close
 2fc:	48d5                	li	a7,21
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <kill>:
.global kill
kill:
 li a7, SYS_kill
 304:	4899                	li	a7,6
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <exec>:
.global exec
exec:
 li a7, SYS_exec
 30c:	489d                	li	a7,7
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <open>:
.global open
open:
 li a7, SYS_open
 314:	48bd                	li	a7,15
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 31c:	48c5                	li	a7,17
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 324:	48c9                	li	a7,18
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 32c:	48a1                	li	a7,8
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <link>:
.global link
link:
 li a7, SYS_link
 334:	48cd                	li	a7,19
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 33c:	48d1                	li	a7,20
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 344:	48a5                	li	a7,9
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <dup>:
.global dup
dup:
 li a7, SYS_dup
 34c:	48a9                	li	a7,10
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 354:	48ad                	li	a7,11
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 35c:	48b1                	li	a7,12
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 364:	48b5                	li	a7,13
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 36c:	48b9                	li	a7,14
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <trace>:
.global trace
trace:
 li a7, SYS_trace
 374:	48d9                	li	a7,22
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <set_priority>:
.global set_priority
set_priority:
 li a7, SYS_set_priority
 37c:	48dd                	li	a7,23
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 384:	48e1                	li	a7,24
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 38c:	1101                	addi	sp,sp,-32
 38e:	ec06                	sd	ra,24(sp)
 390:	e822                	sd	s0,16(sp)
 392:	1000                	addi	s0,sp,32
 394:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 398:	4605                	li	a2,1
 39a:	fef40593          	addi	a1,s0,-17
 39e:	00000097          	auipc	ra,0x0
 3a2:	f56080e7          	jalr	-170(ra) # 2f4 <write>
}
 3a6:	60e2                	ld	ra,24(sp)
 3a8:	6442                	ld	s0,16(sp)
 3aa:	6105                	addi	sp,sp,32
 3ac:	8082                	ret

00000000000003ae <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ae:	7139                	addi	sp,sp,-64
 3b0:	fc06                	sd	ra,56(sp)
 3b2:	f822                	sd	s0,48(sp)
 3b4:	f426                	sd	s1,40(sp)
 3b6:	f04a                	sd	s2,32(sp)
 3b8:	ec4e                	sd	s3,24(sp)
 3ba:	0080                	addi	s0,sp,64
 3bc:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3be:	c299                	beqz	a3,3c4 <printint+0x16>
 3c0:	0805c963          	bltz	a1,452 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3c4:	2581                	sext.w	a1,a1
  neg = 0;
 3c6:	4881                	li	a7,0
 3c8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3cc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3ce:	2601                	sext.w	a2,a2
 3d0:	00000517          	auipc	a0,0x0
 3d4:	49850513          	addi	a0,a0,1176 # 868 <digits>
 3d8:	883a                	mv	a6,a4
 3da:	2705                	addiw	a4,a4,1
 3dc:	02c5f7bb          	remuw	a5,a1,a2
 3e0:	1782                	slli	a5,a5,0x20
 3e2:	9381                	srli	a5,a5,0x20
 3e4:	97aa                	add	a5,a5,a0
 3e6:	0007c783          	lbu	a5,0(a5)
 3ea:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3ee:	0005879b          	sext.w	a5,a1
 3f2:	02c5d5bb          	divuw	a1,a1,a2
 3f6:	0685                	addi	a3,a3,1
 3f8:	fec7f0e3          	bgeu	a5,a2,3d8 <printint+0x2a>
  if(neg)
 3fc:	00088c63          	beqz	a7,414 <printint+0x66>
    buf[i++] = '-';
 400:	fd070793          	addi	a5,a4,-48
 404:	00878733          	add	a4,a5,s0
 408:	02d00793          	li	a5,45
 40c:	fef70823          	sb	a5,-16(a4)
 410:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 414:	02e05863          	blez	a4,444 <printint+0x96>
 418:	fc040793          	addi	a5,s0,-64
 41c:	00e78933          	add	s2,a5,a4
 420:	fff78993          	addi	s3,a5,-1
 424:	99ba                	add	s3,s3,a4
 426:	377d                	addiw	a4,a4,-1
 428:	1702                	slli	a4,a4,0x20
 42a:	9301                	srli	a4,a4,0x20
 42c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 430:	fff94583          	lbu	a1,-1(s2)
 434:	8526                	mv	a0,s1
 436:	00000097          	auipc	ra,0x0
 43a:	f56080e7          	jalr	-170(ra) # 38c <putc>
  while(--i >= 0)
 43e:	197d                	addi	s2,s2,-1
 440:	ff3918e3          	bne	s2,s3,430 <printint+0x82>
}
 444:	70e2                	ld	ra,56(sp)
 446:	7442                	ld	s0,48(sp)
 448:	74a2                	ld	s1,40(sp)
 44a:	7902                	ld	s2,32(sp)
 44c:	69e2                	ld	s3,24(sp)
 44e:	6121                	addi	sp,sp,64
 450:	8082                	ret
    x = -xx;
 452:	40b005bb          	negw	a1,a1
    neg = 1;
 456:	4885                	li	a7,1
    x = -xx;
 458:	bf85                	j	3c8 <printint+0x1a>

000000000000045a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 45a:	7119                	addi	sp,sp,-128
 45c:	fc86                	sd	ra,120(sp)
 45e:	f8a2                	sd	s0,112(sp)
 460:	f4a6                	sd	s1,104(sp)
 462:	f0ca                	sd	s2,96(sp)
 464:	ecce                	sd	s3,88(sp)
 466:	e8d2                	sd	s4,80(sp)
 468:	e4d6                	sd	s5,72(sp)
 46a:	e0da                	sd	s6,64(sp)
 46c:	fc5e                	sd	s7,56(sp)
 46e:	f862                	sd	s8,48(sp)
 470:	f466                	sd	s9,40(sp)
 472:	f06a                	sd	s10,32(sp)
 474:	ec6e                	sd	s11,24(sp)
 476:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 478:	0005c903          	lbu	s2,0(a1)
 47c:	18090f63          	beqz	s2,61a <vprintf+0x1c0>
 480:	8aaa                	mv	s5,a0
 482:	8b32                	mv	s6,a2
 484:	00158493          	addi	s1,a1,1
  state = 0;
 488:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 48a:	02500a13          	li	s4,37
 48e:	4c55                	li	s8,21
 490:	00000c97          	auipc	s9,0x0
 494:	380c8c93          	addi	s9,s9,896 # 810 <malloc+0xf2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 498:	02800d93          	li	s11,40
  putc(fd, 'x');
 49c:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 49e:	00000b97          	auipc	s7,0x0
 4a2:	3cab8b93          	addi	s7,s7,970 # 868 <digits>
 4a6:	a839                	j	4c4 <vprintf+0x6a>
        putc(fd, c);
 4a8:	85ca                	mv	a1,s2
 4aa:	8556                	mv	a0,s5
 4ac:	00000097          	auipc	ra,0x0
 4b0:	ee0080e7          	jalr	-288(ra) # 38c <putc>
 4b4:	a019                	j	4ba <vprintf+0x60>
    } else if(state == '%'){
 4b6:	01498d63          	beq	s3,s4,4d0 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 4ba:	0485                	addi	s1,s1,1
 4bc:	fff4c903          	lbu	s2,-1(s1)
 4c0:	14090d63          	beqz	s2,61a <vprintf+0x1c0>
    if(state == 0){
 4c4:	fe0999e3          	bnez	s3,4b6 <vprintf+0x5c>
      if(c == '%'){
 4c8:	ff4910e3          	bne	s2,s4,4a8 <vprintf+0x4e>
        state = '%';
 4cc:	89d2                	mv	s3,s4
 4ce:	b7f5                	j	4ba <vprintf+0x60>
      if(c == 'd'){
 4d0:	11490c63          	beq	s2,s4,5e8 <vprintf+0x18e>
 4d4:	f9d9079b          	addiw	a5,s2,-99
 4d8:	0ff7f793          	zext.b	a5,a5
 4dc:	10fc6e63          	bltu	s8,a5,5f8 <vprintf+0x19e>
 4e0:	f9d9079b          	addiw	a5,s2,-99
 4e4:	0ff7f713          	zext.b	a4,a5
 4e8:	10ec6863          	bltu	s8,a4,5f8 <vprintf+0x19e>
 4ec:	00271793          	slli	a5,a4,0x2
 4f0:	97e6                	add	a5,a5,s9
 4f2:	439c                	lw	a5,0(a5)
 4f4:	97e6                	add	a5,a5,s9
 4f6:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4f8:	008b0913          	addi	s2,s6,8
 4fc:	4685                	li	a3,1
 4fe:	4629                	li	a2,10
 500:	000b2583          	lw	a1,0(s6)
 504:	8556                	mv	a0,s5
 506:	00000097          	auipc	ra,0x0
 50a:	ea8080e7          	jalr	-344(ra) # 3ae <printint>
 50e:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 510:	4981                	li	s3,0
 512:	b765                	j	4ba <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 514:	008b0913          	addi	s2,s6,8
 518:	4681                	li	a3,0
 51a:	4629                	li	a2,10
 51c:	000b2583          	lw	a1,0(s6)
 520:	8556                	mv	a0,s5
 522:	00000097          	auipc	ra,0x0
 526:	e8c080e7          	jalr	-372(ra) # 3ae <printint>
 52a:	8b4a                	mv	s6,s2
      state = 0;
 52c:	4981                	li	s3,0
 52e:	b771                	j	4ba <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 530:	008b0913          	addi	s2,s6,8
 534:	4681                	li	a3,0
 536:	866a                	mv	a2,s10
 538:	000b2583          	lw	a1,0(s6)
 53c:	8556                	mv	a0,s5
 53e:	00000097          	auipc	ra,0x0
 542:	e70080e7          	jalr	-400(ra) # 3ae <printint>
 546:	8b4a                	mv	s6,s2
      state = 0;
 548:	4981                	li	s3,0
 54a:	bf85                	j	4ba <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 54c:	008b0793          	addi	a5,s6,8
 550:	f8f43423          	sd	a5,-120(s0)
 554:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 558:	03000593          	li	a1,48
 55c:	8556                	mv	a0,s5
 55e:	00000097          	auipc	ra,0x0
 562:	e2e080e7          	jalr	-466(ra) # 38c <putc>
  putc(fd, 'x');
 566:	07800593          	li	a1,120
 56a:	8556                	mv	a0,s5
 56c:	00000097          	auipc	ra,0x0
 570:	e20080e7          	jalr	-480(ra) # 38c <putc>
 574:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 576:	03c9d793          	srli	a5,s3,0x3c
 57a:	97de                	add	a5,a5,s7
 57c:	0007c583          	lbu	a1,0(a5)
 580:	8556                	mv	a0,s5
 582:	00000097          	auipc	ra,0x0
 586:	e0a080e7          	jalr	-502(ra) # 38c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 58a:	0992                	slli	s3,s3,0x4
 58c:	397d                	addiw	s2,s2,-1
 58e:	fe0914e3          	bnez	s2,576 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 592:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 596:	4981                	li	s3,0
 598:	b70d                	j	4ba <vprintf+0x60>
        s = va_arg(ap, char*);
 59a:	008b0913          	addi	s2,s6,8
 59e:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 5a2:	02098163          	beqz	s3,5c4 <vprintf+0x16a>
        while(*s != 0){
 5a6:	0009c583          	lbu	a1,0(s3)
 5aa:	c5ad                	beqz	a1,614 <vprintf+0x1ba>
          putc(fd, *s);
 5ac:	8556                	mv	a0,s5
 5ae:	00000097          	auipc	ra,0x0
 5b2:	dde080e7          	jalr	-546(ra) # 38c <putc>
          s++;
 5b6:	0985                	addi	s3,s3,1
        while(*s != 0){
 5b8:	0009c583          	lbu	a1,0(s3)
 5bc:	f9e5                	bnez	a1,5ac <vprintf+0x152>
        s = va_arg(ap, char*);
 5be:	8b4a                	mv	s6,s2
      state = 0;
 5c0:	4981                	li	s3,0
 5c2:	bde5                	j	4ba <vprintf+0x60>
          s = "(null)";
 5c4:	00000997          	auipc	s3,0x0
 5c8:	24498993          	addi	s3,s3,580 # 808 <malloc+0xea>
        while(*s != 0){
 5cc:	85ee                	mv	a1,s11
 5ce:	bff9                	j	5ac <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 5d0:	008b0913          	addi	s2,s6,8
 5d4:	000b4583          	lbu	a1,0(s6)
 5d8:	8556                	mv	a0,s5
 5da:	00000097          	auipc	ra,0x0
 5de:	db2080e7          	jalr	-590(ra) # 38c <putc>
 5e2:	8b4a                	mv	s6,s2
      state = 0;
 5e4:	4981                	li	s3,0
 5e6:	bdd1                	j	4ba <vprintf+0x60>
        putc(fd, c);
 5e8:	85d2                	mv	a1,s4
 5ea:	8556                	mv	a0,s5
 5ec:	00000097          	auipc	ra,0x0
 5f0:	da0080e7          	jalr	-608(ra) # 38c <putc>
      state = 0;
 5f4:	4981                	li	s3,0
 5f6:	b5d1                	j	4ba <vprintf+0x60>
        putc(fd, '%');
 5f8:	85d2                	mv	a1,s4
 5fa:	8556                	mv	a0,s5
 5fc:	00000097          	auipc	ra,0x0
 600:	d90080e7          	jalr	-624(ra) # 38c <putc>
        putc(fd, c);
 604:	85ca                	mv	a1,s2
 606:	8556                	mv	a0,s5
 608:	00000097          	auipc	ra,0x0
 60c:	d84080e7          	jalr	-636(ra) # 38c <putc>
      state = 0;
 610:	4981                	li	s3,0
 612:	b565                	j	4ba <vprintf+0x60>
        s = va_arg(ap, char*);
 614:	8b4a                	mv	s6,s2
      state = 0;
 616:	4981                	li	s3,0
 618:	b54d                	j	4ba <vprintf+0x60>
    }
  }
}
 61a:	70e6                	ld	ra,120(sp)
 61c:	7446                	ld	s0,112(sp)
 61e:	74a6                	ld	s1,104(sp)
 620:	7906                	ld	s2,96(sp)
 622:	69e6                	ld	s3,88(sp)
 624:	6a46                	ld	s4,80(sp)
 626:	6aa6                	ld	s5,72(sp)
 628:	6b06                	ld	s6,64(sp)
 62a:	7be2                	ld	s7,56(sp)
 62c:	7c42                	ld	s8,48(sp)
 62e:	7ca2                	ld	s9,40(sp)
 630:	7d02                	ld	s10,32(sp)
 632:	6de2                	ld	s11,24(sp)
 634:	6109                	addi	sp,sp,128
 636:	8082                	ret

0000000000000638 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 638:	715d                	addi	sp,sp,-80
 63a:	ec06                	sd	ra,24(sp)
 63c:	e822                	sd	s0,16(sp)
 63e:	1000                	addi	s0,sp,32
 640:	e010                	sd	a2,0(s0)
 642:	e414                	sd	a3,8(s0)
 644:	e818                	sd	a4,16(s0)
 646:	ec1c                	sd	a5,24(s0)
 648:	03043023          	sd	a6,32(s0)
 64c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 650:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 654:	8622                	mv	a2,s0
 656:	00000097          	auipc	ra,0x0
 65a:	e04080e7          	jalr	-508(ra) # 45a <vprintf>
}
 65e:	60e2                	ld	ra,24(sp)
 660:	6442                	ld	s0,16(sp)
 662:	6161                	addi	sp,sp,80
 664:	8082                	ret

0000000000000666 <printf>:

void
printf(const char *fmt, ...)
{
 666:	711d                	addi	sp,sp,-96
 668:	ec06                	sd	ra,24(sp)
 66a:	e822                	sd	s0,16(sp)
 66c:	1000                	addi	s0,sp,32
 66e:	e40c                	sd	a1,8(s0)
 670:	e810                	sd	a2,16(s0)
 672:	ec14                	sd	a3,24(s0)
 674:	f018                	sd	a4,32(s0)
 676:	f41c                	sd	a5,40(s0)
 678:	03043823          	sd	a6,48(s0)
 67c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 680:	00840613          	addi	a2,s0,8
 684:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 688:	85aa                	mv	a1,a0
 68a:	4505                	li	a0,1
 68c:	00000097          	auipc	ra,0x0
 690:	dce080e7          	jalr	-562(ra) # 45a <vprintf>
}
 694:	60e2                	ld	ra,24(sp)
 696:	6442                	ld	s0,16(sp)
 698:	6125                	addi	sp,sp,96
 69a:	8082                	ret

000000000000069c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 69c:	1141                	addi	sp,sp,-16
 69e:	e422                	sd	s0,8(sp)
 6a0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6a2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a6:	00000797          	auipc	a5,0x0
 6aa:	1da7b783          	ld	a5,474(a5) # 880 <freep>
 6ae:	a02d                	j	6d8 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6b0:	4618                	lw	a4,8(a2)
 6b2:	9f2d                	addw	a4,a4,a1
 6b4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6b8:	6398                	ld	a4,0(a5)
 6ba:	6310                	ld	a2,0(a4)
 6bc:	a83d                	j	6fa <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6be:	ff852703          	lw	a4,-8(a0)
 6c2:	9f31                	addw	a4,a4,a2
 6c4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6c6:	ff053683          	ld	a3,-16(a0)
 6ca:	a091                	j	70e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6cc:	6398                	ld	a4,0(a5)
 6ce:	00e7e463          	bltu	a5,a4,6d6 <free+0x3a>
 6d2:	00e6ea63          	bltu	a3,a4,6e6 <free+0x4a>
{
 6d6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d8:	fed7fae3          	bgeu	a5,a3,6cc <free+0x30>
 6dc:	6398                	ld	a4,0(a5)
 6de:	00e6e463          	bltu	a3,a4,6e6 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e2:	fee7eae3          	bltu	a5,a4,6d6 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6e6:	ff852583          	lw	a1,-8(a0)
 6ea:	6390                	ld	a2,0(a5)
 6ec:	02059813          	slli	a6,a1,0x20
 6f0:	01c85713          	srli	a4,a6,0x1c
 6f4:	9736                	add	a4,a4,a3
 6f6:	fae60de3          	beq	a2,a4,6b0 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 6fa:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6fe:	4790                	lw	a2,8(a5)
 700:	02061593          	slli	a1,a2,0x20
 704:	01c5d713          	srli	a4,a1,0x1c
 708:	973e                	add	a4,a4,a5
 70a:	fae68ae3          	beq	a3,a4,6be <free+0x22>
    p->s.ptr = bp->s.ptr;
 70e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 710:	00000717          	auipc	a4,0x0
 714:	16f73823          	sd	a5,368(a4) # 880 <freep>
}
 718:	6422                	ld	s0,8(sp)
 71a:	0141                	addi	sp,sp,16
 71c:	8082                	ret

000000000000071e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 71e:	7139                	addi	sp,sp,-64
 720:	fc06                	sd	ra,56(sp)
 722:	f822                	sd	s0,48(sp)
 724:	f426                	sd	s1,40(sp)
 726:	f04a                	sd	s2,32(sp)
 728:	ec4e                	sd	s3,24(sp)
 72a:	e852                	sd	s4,16(sp)
 72c:	e456                	sd	s5,8(sp)
 72e:	e05a                	sd	s6,0(sp)
 730:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 732:	02051493          	slli	s1,a0,0x20
 736:	9081                	srli	s1,s1,0x20
 738:	04bd                	addi	s1,s1,15
 73a:	8091                	srli	s1,s1,0x4
 73c:	0014899b          	addiw	s3,s1,1
 740:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 742:	00000517          	auipc	a0,0x0
 746:	13e53503          	ld	a0,318(a0) # 880 <freep>
 74a:	c515                	beqz	a0,776 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 74c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 74e:	4798                	lw	a4,8(a5)
 750:	02977f63          	bgeu	a4,s1,78e <malloc+0x70>
 754:	8a4e                	mv	s4,s3
 756:	0009871b          	sext.w	a4,s3
 75a:	6685                	lui	a3,0x1
 75c:	00d77363          	bgeu	a4,a3,762 <malloc+0x44>
 760:	6a05                	lui	s4,0x1
 762:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 766:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 76a:	00000917          	auipc	s2,0x0
 76e:	11690913          	addi	s2,s2,278 # 880 <freep>
  if(p == (char*)-1)
 772:	5afd                	li	s5,-1
 774:	a895                	j	7e8 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 776:	00000797          	auipc	a5,0x0
 77a:	11278793          	addi	a5,a5,274 # 888 <base>
 77e:	00000717          	auipc	a4,0x0
 782:	10f73123          	sd	a5,258(a4) # 880 <freep>
 786:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 788:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 78c:	b7e1                	j	754 <malloc+0x36>
      if(p->s.size == nunits)
 78e:	02e48c63          	beq	s1,a4,7c6 <malloc+0xa8>
        p->s.size -= nunits;
 792:	4137073b          	subw	a4,a4,s3
 796:	c798                	sw	a4,8(a5)
        p += p->s.size;
 798:	02071693          	slli	a3,a4,0x20
 79c:	01c6d713          	srli	a4,a3,0x1c
 7a0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7a2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7a6:	00000717          	auipc	a4,0x0
 7aa:	0ca73d23          	sd	a0,218(a4) # 880 <freep>
      return (void*)(p + 1);
 7ae:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7b2:	70e2                	ld	ra,56(sp)
 7b4:	7442                	ld	s0,48(sp)
 7b6:	74a2                	ld	s1,40(sp)
 7b8:	7902                	ld	s2,32(sp)
 7ba:	69e2                	ld	s3,24(sp)
 7bc:	6a42                	ld	s4,16(sp)
 7be:	6aa2                	ld	s5,8(sp)
 7c0:	6b02                	ld	s6,0(sp)
 7c2:	6121                	addi	sp,sp,64
 7c4:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7c6:	6398                	ld	a4,0(a5)
 7c8:	e118                	sd	a4,0(a0)
 7ca:	bff1                	j	7a6 <malloc+0x88>
  hp->s.size = nu;
 7cc:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7d0:	0541                	addi	a0,a0,16
 7d2:	00000097          	auipc	ra,0x0
 7d6:	eca080e7          	jalr	-310(ra) # 69c <free>
  return freep;
 7da:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7de:	d971                	beqz	a0,7b2 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7e2:	4798                	lw	a4,8(a5)
 7e4:	fa9775e3          	bgeu	a4,s1,78e <malloc+0x70>
    if(p == freep)
 7e8:	00093703          	ld	a4,0(s2)
 7ec:	853e                	mv	a0,a5
 7ee:	fef719e3          	bne	a4,a5,7e0 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 7f2:	8552                	mv	a0,s4
 7f4:	00000097          	auipc	ra,0x0
 7f8:	b68080e7          	jalr	-1176(ra) # 35c <sbrk>
  if(p == (char*)-1)
 7fc:	fd5518e3          	bne	a0,s5,7cc <malloc+0xae>
        return 0;
 800:	4501                	li	a0,0
 802:	bf45                	j	7b2 <malloc+0x94>
