
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e422                	sd	s0,8(sp)
       4:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       6:	611c                	ld	a5,0(a0)
       8:	80000737          	lui	a4,0x80000
       c:	ffe74713          	xori	a4,a4,-2
      10:	02e7f7b3          	remu	a5,a5,a4
      14:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      16:	66fd                	lui	a3,0x1f
      18:	31d68693          	addi	a3,a3,797 # 1f31d <__global_pointer$+0x1d43c>
      1c:	02d7e733          	rem	a4,a5,a3
    x = 16807 * lo - 2836 * hi;
      20:	6611                	lui	a2,0x4
      22:	1a760613          	addi	a2,a2,423 # 41a7 <__global_pointer$+0x22c6>
      26:	02c70733          	mul	a4,a4,a2
    hi = x / 127773;
      2a:	02d7c7b3          	div	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      2e:	76fd                	lui	a3,0xfffff
      30:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <__global_pointer$+0xffffffffffffd60b>
      34:	02d787b3          	mul	a5,a5,a3
      38:	97ba                	add	a5,a5,a4
    if (x < 0)
      3a:	0007c963          	bltz	a5,4c <do_rand+0x4c>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      3e:	17fd                	addi	a5,a5,-1
    *ctx = x;
      40:	e11c                	sd	a5,0(a0)
    return (x);
}
      42:	0007851b          	sext.w	a0,a5
      46:	6422                	ld	s0,8(sp)
      48:	0141                	addi	sp,sp,16
      4a:	8082                	ret
        x += 0x7fffffff;
      4c:	80000737          	lui	a4,0x80000
      50:	fff74713          	not	a4,a4
      54:	97ba                	add	a5,a5,a4
      56:	b7e5                	j	3e <do_rand+0x3e>

0000000000000058 <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      58:	1141                	addi	sp,sp,-16
      5a:	e406                	sd	ra,8(sp)
      5c:	e022                	sd	s0,0(sp)
      5e:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
      60:	00001517          	auipc	a0,0x1
      64:	68850513          	addi	a0,a0,1672 # 16e8 <rand_next>
      68:	00000097          	auipc	ra,0x0
      6c:	f98080e7          	jalr	-104(ra) # 0 <do_rand>
}
      70:	60a2                	ld	ra,8(sp)
      72:	6402                	ld	s0,0(sp)
      74:	0141                	addi	sp,sp,16
      76:	8082                	ret

0000000000000078 <go>:

void
go(int which_child)
{
      78:	7159                	addi	sp,sp,-112
      7a:	f486                	sd	ra,104(sp)
      7c:	f0a2                	sd	s0,96(sp)
      7e:	eca6                	sd	s1,88(sp)
      80:	e8ca                	sd	s2,80(sp)
      82:	e4ce                	sd	s3,72(sp)
      84:	e0d2                	sd	s4,64(sp)
      86:	fc56                	sd	s5,56(sp)
      88:	f85a                	sd	s6,48(sp)
      8a:	1880                	addi	s0,sp,112
      8c:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      8e:	4501                	li	a0,0
      90:	00001097          	auipc	ra,0x1
      94:	df0080e7          	jalr	-528(ra) # e80 <sbrk>
      98:	8aaa                	mv	s5,a0
  uint64 iters = 0;

  mkdir("grindir");
      9a:	00001517          	auipc	a0,0x1
      9e:	28e50513          	addi	a0,a0,654 # 1328 <malloc+0xe6>
      a2:	00001097          	auipc	ra,0x1
      a6:	dbe080e7          	jalr	-578(ra) # e60 <mkdir>
  if(chdir("grindir") != 0){
      aa:	00001517          	auipc	a0,0x1
      ae:	27e50513          	addi	a0,a0,638 # 1328 <malloc+0xe6>
      b2:	00001097          	auipc	ra,0x1
      b6:	db6080e7          	jalr	-586(ra) # e68 <chdir>
      ba:	cd11                	beqz	a0,d6 <go+0x5e>
    printf("grind: chdir grindir failed\n");
      bc:	00001517          	auipc	a0,0x1
      c0:	27450513          	addi	a0,a0,628 # 1330 <malloc+0xee>
      c4:	00001097          	auipc	ra,0x1
      c8:	0c6080e7          	jalr	198(ra) # 118a <printf>
    exit(1);
      cc:	4505                	li	a0,1
      ce:	00001097          	auipc	ra,0x1
      d2:	d2a080e7          	jalr	-726(ra) # df8 <exit>
  }
  chdir("/");
      d6:	00001517          	auipc	a0,0x1
      da:	27a50513          	addi	a0,a0,634 # 1350 <malloc+0x10e>
      de:	00001097          	auipc	ra,0x1
      e2:	d8a080e7          	jalr	-630(ra) # e68 <chdir>
  
  while(1){
    iters++;
    if((iters % 500) == 0)
      e6:	00001997          	auipc	s3,0x1
      ea:	27a98993          	addi	s3,s3,634 # 1360 <malloc+0x11e>
      ee:	c489                	beqz	s1,f8 <go+0x80>
      f0:	00001997          	auipc	s3,0x1
      f4:	26898993          	addi	s3,s3,616 # 1358 <malloc+0x116>
    iters++;
      f8:	4485                	li	s1,1
  int fd = -1;
      fa:	5a7d                	li	s4,-1
      fc:	00001917          	auipc	s2,0x1
     100:	51490913          	addi	s2,s2,1300 # 1610 <malloc+0x3ce>
     104:	a825                	j	13c <go+0xc4>
      write(1, which_child?"B":"A", 1);
    int what = rand() % 23;
    if(what == 1){
      close(open("grindir/../a", O_CREATE|O_RDWR));
     106:	20200593          	li	a1,514
     10a:	00001517          	auipc	a0,0x1
     10e:	25e50513          	addi	a0,a0,606 # 1368 <malloc+0x126>
     112:	00001097          	auipc	ra,0x1
     116:	d26080e7          	jalr	-730(ra) # e38 <open>
     11a:	00001097          	auipc	ra,0x1
     11e:	d06080e7          	jalr	-762(ra) # e20 <close>
    iters++;
     122:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
     124:	1f400793          	li	a5,500
     128:	02f4f7b3          	remu	a5,s1,a5
     12c:	eb81                	bnez	a5,13c <go+0xc4>
      write(1, which_child?"B":"A", 1);
     12e:	4605                	li	a2,1
     130:	85ce                	mv	a1,s3
     132:	4505                	li	a0,1
     134:	00001097          	auipc	ra,0x1
     138:	ce4080e7          	jalr	-796(ra) # e18 <write>
    int what = rand() % 23;
     13c:	00000097          	auipc	ra,0x0
     140:	f1c080e7          	jalr	-228(ra) # 58 <rand>
     144:	47dd                	li	a5,23
     146:	02f5653b          	remw	a0,a0,a5
    if(what == 1){
     14a:	4785                	li	a5,1
     14c:	faf50de3          	beq	a0,a5,106 <go+0x8e>
    } else if(what == 2){
     150:	47d9                	li	a5,22
     152:	fca7e8e3          	bltu	a5,a0,122 <go+0xaa>
     156:	050a                	slli	a0,a0,0x2
     158:	954a                	add	a0,a0,s2
     15a:	411c                	lw	a5,0(a0)
     15c:	97ca                	add	a5,a5,s2
     15e:	8782                	jr	a5
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     160:	20200593          	li	a1,514
     164:	00001517          	auipc	a0,0x1
     168:	21450513          	addi	a0,a0,532 # 1378 <malloc+0x136>
     16c:	00001097          	auipc	ra,0x1
     170:	ccc080e7          	jalr	-820(ra) # e38 <open>
     174:	00001097          	auipc	ra,0x1
     178:	cac080e7          	jalr	-852(ra) # e20 <close>
     17c:	b75d                	j	122 <go+0xaa>
    } else if(what == 3){
      unlink("grindir/../a");
     17e:	00001517          	auipc	a0,0x1
     182:	1ea50513          	addi	a0,a0,490 # 1368 <malloc+0x126>
     186:	00001097          	auipc	ra,0x1
     18a:	cc2080e7          	jalr	-830(ra) # e48 <unlink>
     18e:	bf51                	j	122 <go+0xaa>
    } else if(what == 4){
      if(chdir("grindir") != 0){
     190:	00001517          	auipc	a0,0x1
     194:	19850513          	addi	a0,a0,408 # 1328 <malloc+0xe6>
     198:	00001097          	auipc	ra,0x1
     19c:	cd0080e7          	jalr	-816(ra) # e68 <chdir>
     1a0:	e115                	bnez	a0,1c4 <go+0x14c>
        printf("grind: chdir grindir failed\n");
        exit(1);
      }
      unlink("../b");
     1a2:	00001517          	auipc	a0,0x1
     1a6:	1ee50513          	addi	a0,a0,494 # 1390 <malloc+0x14e>
     1aa:	00001097          	auipc	ra,0x1
     1ae:	c9e080e7          	jalr	-866(ra) # e48 <unlink>
      chdir("/");
     1b2:	00001517          	auipc	a0,0x1
     1b6:	19e50513          	addi	a0,a0,414 # 1350 <malloc+0x10e>
     1ba:	00001097          	auipc	ra,0x1
     1be:	cae080e7          	jalr	-850(ra) # e68 <chdir>
     1c2:	b785                	j	122 <go+0xaa>
        printf("grind: chdir grindir failed\n");
     1c4:	00001517          	auipc	a0,0x1
     1c8:	16c50513          	addi	a0,a0,364 # 1330 <malloc+0xee>
     1cc:	00001097          	auipc	ra,0x1
     1d0:	fbe080e7          	jalr	-66(ra) # 118a <printf>
        exit(1);
     1d4:	4505                	li	a0,1
     1d6:	00001097          	auipc	ra,0x1
     1da:	c22080e7          	jalr	-990(ra) # df8 <exit>
    } else if(what == 5){
      close(fd);
     1de:	8552                	mv	a0,s4
     1e0:	00001097          	auipc	ra,0x1
     1e4:	c40080e7          	jalr	-960(ra) # e20 <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     1e8:	20200593          	li	a1,514
     1ec:	00001517          	auipc	a0,0x1
     1f0:	1ac50513          	addi	a0,a0,428 # 1398 <malloc+0x156>
     1f4:	00001097          	auipc	ra,0x1
     1f8:	c44080e7          	jalr	-956(ra) # e38 <open>
     1fc:	8a2a                	mv	s4,a0
     1fe:	b715                	j	122 <go+0xaa>
    } else if(what == 6){
      close(fd);
     200:	8552                	mv	a0,s4
     202:	00001097          	auipc	ra,0x1
     206:	c1e080e7          	jalr	-994(ra) # e20 <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     20a:	20200593          	li	a1,514
     20e:	00001517          	auipc	a0,0x1
     212:	19a50513          	addi	a0,a0,410 # 13a8 <malloc+0x166>
     216:	00001097          	auipc	ra,0x1
     21a:	c22080e7          	jalr	-990(ra) # e38 <open>
     21e:	8a2a                	mv	s4,a0
     220:	b709                	j	122 <go+0xaa>
    } else if(what == 7){
      write(fd, buf, sizeof(buf));
     222:	3e700613          	li	a2,999
     226:	00001597          	auipc	a1,0x1
     22a:	4d258593          	addi	a1,a1,1234 # 16f8 <buf.0>
     22e:	8552                	mv	a0,s4
     230:	00001097          	auipc	ra,0x1
     234:	be8080e7          	jalr	-1048(ra) # e18 <write>
     238:	b5ed                	j	122 <go+0xaa>
    } else if(what == 8){
      read(fd, buf, sizeof(buf));
     23a:	3e700613          	li	a2,999
     23e:	00001597          	auipc	a1,0x1
     242:	4ba58593          	addi	a1,a1,1210 # 16f8 <buf.0>
     246:	8552                	mv	a0,s4
     248:	00001097          	auipc	ra,0x1
     24c:	bc8080e7          	jalr	-1080(ra) # e10 <read>
     250:	bdc9                	j	122 <go+0xaa>
    } else if(what == 9){
      mkdir("grindir/../a");
     252:	00001517          	auipc	a0,0x1
     256:	11650513          	addi	a0,a0,278 # 1368 <malloc+0x126>
     25a:	00001097          	auipc	ra,0x1
     25e:	c06080e7          	jalr	-1018(ra) # e60 <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     262:	20200593          	li	a1,514
     266:	00001517          	auipc	a0,0x1
     26a:	15a50513          	addi	a0,a0,346 # 13c0 <malloc+0x17e>
     26e:	00001097          	auipc	ra,0x1
     272:	bca080e7          	jalr	-1078(ra) # e38 <open>
     276:	00001097          	auipc	ra,0x1
     27a:	baa080e7          	jalr	-1110(ra) # e20 <close>
      unlink("a/a");
     27e:	00001517          	auipc	a0,0x1
     282:	15250513          	addi	a0,a0,338 # 13d0 <malloc+0x18e>
     286:	00001097          	auipc	ra,0x1
     28a:	bc2080e7          	jalr	-1086(ra) # e48 <unlink>
     28e:	bd51                	j	122 <go+0xaa>
    } else if(what == 10){
      mkdir("/../b");
     290:	00001517          	auipc	a0,0x1
     294:	14850513          	addi	a0,a0,328 # 13d8 <malloc+0x196>
     298:	00001097          	auipc	ra,0x1
     29c:	bc8080e7          	jalr	-1080(ra) # e60 <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     2a0:	20200593          	li	a1,514
     2a4:	00001517          	auipc	a0,0x1
     2a8:	13c50513          	addi	a0,a0,316 # 13e0 <malloc+0x19e>
     2ac:	00001097          	auipc	ra,0x1
     2b0:	b8c080e7          	jalr	-1140(ra) # e38 <open>
     2b4:	00001097          	auipc	ra,0x1
     2b8:	b6c080e7          	jalr	-1172(ra) # e20 <close>
      unlink("b/b");
     2bc:	00001517          	auipc	a0,0x1
     2c0:	13450513          	addi	a0,a0,308 # 13f0 <malloc+0x1ae>
     2c4:	00001097          	auipc	ra,0x1
     2c8:	b84080e7          	jalr	-1148(ra) # e48 <unlink>
     2cc:	bd99                	j	122 <go+0xaa>
    } else if(what == 11){
      unlink("b");
     2ce:	00001517          	auipc	a0,0x1
     2d2:	0ea50513          	addi	a0,a0,234 # 13b8 <malloc+0x176>
     2d6:	00001097          	auipc	ra,0x1
     2da:	b72080e7          	jalr	-1166(ra) # e48 <unlink>
      link("../grindir/./../a", "../b");
     2de:	00001597          	auipc	a1,0x1
     2e2:	0b258593          	addi	a1,a1,178 # 1390 <malloc+0x14e>
     2e6:	00001517          	auipc	a0,0x1
     2ea:	11250513          	addi	a0,a0,274 # 13f8 <malloc+0x1b6>
     2ee:	00001097          	auipc	ra,0x1
     2f2:	b6a080e7          	jalr	-1174(ra) # e58 <link>
     2f6:	b535                	j	122 <go+0xaa>
    } else if(what == 12){
      unlink("../grindir/../a");
     2f8:	00001517          	auipc	a0,0x1
     2fc:	11850513          	addi	a0,a0,280 # 1410 <malloc+0x1ce>
     300:	00001097          	auipc	ra,0x1
     304:	b48080e7          	jalr	-1208(ra) # e48 <unlink>
      link(".././b", "/grindir/../a");
     308:	00001597          	auipc	a1,0x1
     30c:	09058593          	addi	a1,a1,144 # 1398 <malloc+0x156>
     310:	00001517          	auipc	a0,0x1
     314:	11050513          	addi	a0,a0,272 # 1420 <malloc+0x1de>
     318:	00001097          	auipc	ra,0x1
     31c:	b40080e7          	jalr	-1216(ra) # e58 <link>
     320:	b509                	j	122 <go+0xaa>
    } else if(what == 13){
      int pid = fork();
     322:	00001097          	auipc	ra,0x1
     326:	ace080e7          	jalr	-1330(ra) # df0 <fork>
      if(pid == 0){
     32a:	c909                	beqz	a0,33c <go+0x2c4>
        exit(0);
      } else if(pid < 0){
     32c:	00054c63          	bltz	a0,344 <go+0x2cc>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     330:	4501                	li	a0,0
     332:	00001097          	auipc	ra,0x1
     336:	ace080e7          	jalr	-1330(ra) # e00 <wait>
     33a:	b3e5                	j	122 <go+0xaa>
        exit(0);
     33c:	00001097          	auipc	ra,0x1
     340:	abc080e7          	jalr	-1348(ra) # df8 <exit>
        printf("grind: fork failed\n");
     344:	00001517          	auipc	a0,0x1
     348:	0e450513          	addi	a0,a0,228 # 1428 <malloc+0x1e6>
     34c:	00001097          	auipc	ra,0x1
     350:	e3e080e7          	jalr	-450(ra) # 118a <printf>
        exit(1);
     354:	4505                	li	a0,1
     356:	00001097          	auipc	ra,0x1
     35a:	aa2080e7          	jalr	-1374(ra) # df8 <exit>
    } else if(what == 14){
      int pid = fork();
     35e:	00001097          	auipc	ra,0x1
     362:	a92080e7          	jalr	-1390(ra) # df0 <fork>
      if(pid == 0){
     366:	c909                	beqz	a0,378 <go+0x300>
        fork();
        fork();
        exit(0);
      } else if(pid < 0){
     368:	02054563          	bltz	a0,392 <go+0x31a>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     36c:	4501                	li	a0,0
     36e:	00001097          	auipc	ra,0x1
     372:	a92080e7          	jalr	-1390(ra) # e00 <wait>
     376:	b375                	j	122 <go+0xaa>
        fork();
     378:	00001097          	auipc	ra,0x1
     37c:	a78080e7          	jalr	-1416(ra) # df0 <fork>
        fork();
     380:	00001097          	auipc	ra,0x1
     384:	a70080e7          	jalr	-1424(ra) # df0 <fork>
        exit(0);
     388:	4501                	li	a0,0
     38a:	00001097          	auipc	ra,0x1
     38e:	a6e080e7          	jalr	-1426(ra) # df8 <exit>
        printf("grind: fork failed\n");
     392:	00001517          	auipc	a0,0x1
     396:	09650513          	addi	a0,a0,150 # 1428 <malloc+0x1e6>
     39a:	00001097          	auipc	ra,0x1
     39e:	df0080e7          	jalr	-528(ra) # 118a <printf>
        exit(1);
     3a2:	4505                	li	a0,1
     3a4:	00001097          	auipc	ra,0x1
     3a8:	a54080e7          	jalr	-1452(ra) # df8 <exit>
    } else if(what == 15){
      sbrk(6011);
     3ac:	6505                	lui	a0,0x1
     3ae:	77b50513          	addi	a0,a0,1915 # 177b <buf.0+0x83>
     3b2:	00001097          	auipc	ra,0x1
     3b6:	ace080e7          	jalr	-1330(ra) # e80 <sbrk>
     3ba:	b3a5                	j	122 <go+0xaa>
    } else if(what == 16){
      if(sbrk(0) > break0)
     3bc:	4501                	li	a0,0
     3be:	00001097          	auipc	ra,0x1
     3c2:	ac2080e7          	jalr	-1342(ra) # e80 <sbrk>
     3c6:	d4aafee3          	bgeu	s5,a0,122 <go+0xaa>
        sbrk(-(sbrk(0) - break0));
     3ca:	4501                	li	a0,0
     3cc:	00001097          	auipc	ra,0x1
     3d0:	ab4080e7          	jalr	-1356(ra) # e80 <sbrk>
     3d4:	40aa853b          	subw	a0,s5,a0
     3d8:	00001097          	auipc	ra,0x1
     3dc:	aa8080e7          	jalr	-1368(ra) # e80 <sbrk>
     3e0:	b389                	j	122 <go+0xaa>
    } else if(what == 17){
      int pid = fork();
     3e2:	00001097          	auipc	ra,0x1
     3e6:	a0e080e7          	jalr	-1522(ra) # df0 <fork>
     3ea:	8b2a                	mv	s6,a0
      if(pid == 0){
     3ec:	c51d                	beqz	a0,41a <go+0x3a2>
        close(open("a", O_CREATE|O_RDWR));
        exit(0);
      } else if(pid < 0){
     3ee:	04054963          	bltz	a0,440 <go+0x3c8>
        printf("grind: fork failed\n");
        exit(1);
      }
      if(chdir("../grindir/..") != 0){
     3f2:	00001517          	auipc	a0,0x1
     3f6:	04e50513          	addi	a0,a0,78 # 1440 <malloc+0x1fe>
     3fa:	00001097          	auipc	ra,0x1
     3fe:	a6e080e7          	jalr	-1426(ra) # e68 <chdir>
     402:	ed21                	bnez	a0,45a <go+0x3e2>
        printf("grind: chdir failed\n");
        exit(1);
      }
      kill(pid);
     404:	855a                	mv	a0,s6
     406:	00001097          	auipc	ra,0x1
     40a:	a22080e7          	jalr	-1502(ra) # e28 <kill>
      wait(0);
     40e:	4501                	li	a0,0
     410:	00001097          	auipc	ra,0x1
     414:	9f0080e7          	jalr	-1552(ra) # e00 <wait>
     418:	b329                	j	122 <go+0xaa>
        close(open("a", O_CREATE|O_RDWR));
     41a:	20200593          	li	a1,514
     41e:	00001517          	auipc	a0,0x1
     422:	fea50513          	addi	a0,a0,-22 # 1408 <malloc+0x1c6>
     426:	00001097          	auipc	ra,0x1
     42a:	a12080e7          	jalr	-1518(ra) # e38 <open>
     42e:	00001097          	auipc	ra,0x1
     432:	9f2080e7          	jalr	-1550(ra) # e20 <close>
        exit(0);
     436:	4501                	li	a0,0
     438:	00001097          	auipc	ra,0x1
     43c:	9c0080e7          	jalr	-1600(ra) # df8 <exit>
        printf("grind: fork failed\n");
     440:	00001517          	auipc	a0,0x1
     444:	fe850513          	addi	a0,a0,-24 # 1428 <malloc+0x1e6>
     448:	00001097          	auipc	ra,0x1
     44c:	d42080e7          	jalr	-702(ra) # 118a <printf>
        exit(1);
     450:	4505                	li	a0,1
     452:	00001097          	auipc	ra,0x1
     456:	9a6080e7          	jalr	-1626(ra) # df8 <exit>
        printf("grind: chdir failed\n");
     45a:	00001517          	auipc	a0,0x1
     45e:	ff650513          	addi	a0,a0,-10 # 1450 <malloc+0x20e>
     462:	00001097          	auipc	ra,0x1
     466:	d28080e7          	jalr	-728(ra) # 118a <printf>
        exit(1);
     46a:	4505                	li	a0,1
     46c:	00001097          	auipc	ra,0x1
     470:	98c080e7          	jalr	-1652(ra) # df8 <exit>
    } else if(what == 18){
      int pid = fork();
     474:	00001097          	auipc	ra,0x1
     478:	97c080e7          	jalr	-1668(ra) # df0 <fork>
      if(pid == 0){
     47c:	c909                	beqz	a0,48e <go+0x416>
        kill(getpid());
        exit(0);
      } else if(pid < 0){
     47e:	02054563          	bltz	a0,4a8 <go+0x430>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     482:	4501                	li	a0,0
     484:	00001097          	auipc	ra,0x1
     488:	97c080e7          	jalr	-1668(ra) # e00 <wait>
     48c:	b959                	j	122 <go+0xaa>
        kill(getpid());
     48e:	00001097          	auipc	ra,0x1
     492:	9ea080e7          	jalr	-1558(ra) # e78 <getpid>
     496:	00001097          	auipc	ra,0x1
     49a:	992080e7          	jalr	-1646(ra) # e28 <kill>
        exit(0);
     49e:	4501                	li	a0,0
     4a0:	00001097          	auipc	ra,0x1
     4a4:	958080e7          	jalr	-1704(ra) # df8 <exit>
        printf("grind: fork failed\n");
     4a8:	00001517          	auipc	a0,0x1
     4ac:	f8050513          	addi	a0,a0,-128 # 1428 <malloc+0x1e6>
     4b0:	00001097          	auipc	ra,0x1
     4b4:	cda080e7          	jalr	-806(ra) # 118a <printf>
        exit(1);
     4b8:	4505                	li	a0,1
     4ba:	00001097          	auipc	ra,0x1
     4be:	93e080e7          	jalr	-1730(ra) # df8 <exit>
    } else if(what == 19){
      int fds[2];
      if(pipe(fds) < 0){
     4c2:	fa840513          	addi	a0,s0,-88
     4c6:	00001097          	auipc	ra,0x1
     4ca:	942080e7          	jalr	-1726(ra) # e08 <pipe>
     4ce:	02054b63          	bltz	a0,504 <go+0x48c>
        printf("grind: pipe failed\n");
        exit(1);
      }
      int pid = fork();
     4d2:	00001097          	auipc	ra,0x1
     4d6:	91e080e7          	jalr	-1762(ra) # df0 <fork>
      if(pid == 0){
     4da:	c131                	beqz	a0,51e <go+0x4a6>
          printf("grind: pipe write failed\n");
        char c;
        if(read(fds[0], &c, 1) != 1)
          printf("grind: pipe read failed\n");
        exit(0);
      } else if(pid < 0){
     4dc:	0a054a63          	bltz	a0,590 <go+0x518>
        printf("grind: fork failed\n");
        exit(1);
      }
      close(fds[0]);
     4e0:	fa842503          	lw	a0,-88(s0)
     4e4:	00001097          	auipc	ra,0x1
     4e8:	93c080e7          	jalr	-1732(ra) # e20 <close>
      close(fds[1]);
     4ec:	fac42503          	lw	a0,-84(s0)
     4f0:	00001097          	auipc	ra,0x1
     4f4:	930080e7          	jalr	-1744(ra) # e20 <close>
      wait(0);
     4f8:	4501                	li	a0,0
     4fa:	00001097          	auipc	ra,0x1
     4fe:	906080e7          	jalr	-1786(ra) # e00 <wait>
     502:	b105                	j	122 <go+0xaa>
        printf("grind: pipe failed\n");
     504:	00001517          	auipc	a0,0x1
     508:	f6450513          	addi	a0,a0,-156 # 1468 <malloc+0x226>
     50c:	00001097          	auipc	ra,0x1
     510:	c7e080e7          	jalr	-898(ra) # 118a <printf>
        exit(1);
     514:	4505                	li	a0,1
     516:	00001097          	auipc	ra,0x1
     51a:	8e2080e7          	jalr	-1822(ra) # df8 <exit>
        fork();
     51e:	00001097          	auipc	ra,0x1
     522:	8d2080e7          	jalr	-1838(ra) # df0 <fork>
        fork();
     526:	00001097          	auipc	ra,0x1
     52a:	8ca080e7          	jalr	-1846(ra) # df0 <fork>
        if(write(fds[1], "x", 1) != 1)
     52e:	4605                	li	a2,1
     530:	00001597          	auipc	a1,0x1
     534:	f5058593          	addi	a1,a1,-176 # 1480 <malloc+0x23e>
     538:	fac42503          	lw	a0,-84(s0)
     53c:	00001097          	auipc	ra,0x1
     540:	8dc080e7          	jalr	-1828(ra) # e18 <write>
     544:	4785                	li	a5,1
     546:	02f51363          	bne	a0,a5,56c <go+0x4f4>
        if(read(fds[0], &c, 1) != 1)
     54a:	4605                	li	a2,1
     54c:	fa040593          	addi	a1,s0,-96
     550:	fa842503          	lw	a0,-88(s0)
     554:	00001097          	auipc	ra,0x1
     558:	8bc080e7          	jalr	-1860(ra) # e10 <read>
     55c:	4785                	li	a5,1
     55e:	02f51063          	bne	a0,a5,57e <go+0x506>
        exit(0);
     562:	4501                	li	a0,0
     564:	00001097          	auipc	ra,0x1
     568:	894080e7          	jalr	-1900(ra) # df8 <exit>
          printf("grind: pipe write failed\n");
     56c:	00001517          	auipc	a0,0x1
     570:	f1c50513          	addi	a0,a0,-228 # 1488 <malloc+0x246>
     574:	00001097          	auipc	ra,0x1
     578:	c16080e7          	jalr	-1002(ra) # 118a <printf>
     57c:	b7f9                	j	54a <go+0x4d2>
          printf("grind: pipe read failed\n");
     57e:	00001517          	auipc	a0,0x1
     582:	f2a50513          	addi	a0,a0,-214 # 14a8 <malloc+0x266>
     586:	00001097          	auipc	ra,0x1
     58a:	c04080e7          	jalr	-1020(ra) # 118a <printf>
     58e:	bfd1                	j	562 <go+0x4ea>
        printf("grind: fork failed\n");
     590:	00001517          	auipc	a0,0x1
     594:	e9850513          	addi	a0,a0,-360 # 1428 <malloc+0x1e6>
     598:	00001097          	auipc	ra,0x1
     59c:	bf2080e7          	jalr	-1038(ra) # 118a <printf>
        exit(1);
     5a0:	4505                	li	a0,1
     5a2:	00001097          	auipc	ra,0x1
     5a6:	856080e7          	jalr	-1962(ra) # df8 <exit>
    } else if(what == 20){
      int pid = fork();
     5aa:	00001097          	auipc	ra,0x1
     5ae:	846080e7          	jalr	-1978(ra) # df0 <fork>
      if(pid == 0){
     5b2:	c909                	beqz	a0,5c4 <go+0x54c>
        chdir("a");
        unlink("../a");
        fd = open("x", O_CREATE|O_RDWR);
        unlink("x");
        exit(0);
      } else if(pid < 0){
     5b4:	06054f63          	bltz	a0,632 <go+0x5ba>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     5b8:	4501                	li	a0,0
     5ba:	00001097          	auipc	ra,0x1
     5be:	846080e7          	jalr	-1978(ra) # e00 <wait>
     5c2:	b685                	j	122 <go+0xaa>
        unlink("a");
     5c4:	00001517          	auipc	a0,0x1
     5c8:	e4450513          	addi	a0,a0,-444 # 1408 <malloc+0x1c6>
     5cc:	00001097          	auipc	ra,0x1
     5d0:	87c080e7          	jalr	-1924(ra) # e48 <unlink>
        mkdir("a");
     5d4:	00001517          	auipc	a0,0x1
     5d8:	e3450513          	addi	a0,a0,-460 # 1408 <malloc+0x1c6>
     5dc:	00001097          	auipc	ra,0x1
     5e0:	884080e7          	jalr	-1916(ra) # e60 <mkdir>
        chdir("a");
     5e4:	00001517          	auipc	a0,0x1
     5e8:	e2450513          	addi	a0,a0,-476 # 1408 <malloc+0x1c6>
     5ec:	00001097          	auipc	ra,0x1
     5f0:	87c080e7          	jalr	-1924(ra) # e68 <chdir>
        unlink("../a");
     5f4:	00001517          	auipc	a0,0x1
     5f8:	d7c50513          	addi	a0,a0,-644 # 1370 <malloc+0x12e>
     5fc:	00001097          	auipc	ra,0x1
     600:	84c080e7          	jalr	-1972(ra) # e48 <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     604:	20200593          	li	a1,514
     608:	00001517          	auipc	a0,0x1
     60c:	e7850513          	addi	a0,a0,-392 # 1480 <malloc+0x23e>
     610:	00001097          	auipc	ra,0x1
     614:	828080e7          	jalr	-2008(ra) # e38 <open>
        unlink("x");
     618:	00001517          	auipc	a0,0x1
     61c:	e6850513          	addi	a0,a0,-408 # 1480 <malloc+0x23e>
     620:	00001097          	auipc	ra,0x1
     624:	828080e7          	jalr	-2008(ra) # e48 <unlink>
        exit(0);
     628:	4501                	li	a0,0
     62a:	00000097          	auipc	ra,0x0
     62e:	7ce080e7          	jalr	1998(ra) # df8 <exit>
        printf("grind: fork failed\n");
     632:	00001517          	auipc	a0,0x1
     636:	df650513          	addi	a0,a0,-522 # 1428 <malloc+0x1e6>
     63a:	00001097          	auipc	ra,0x1
     63e:	b50080e7          	jalr	-1200(ra) # 118a <printf>
        exit(1);
     642:	4505                	li	a0,1
     644:	00000097          	auipc	ra,0x0
     648:	7b4080e7          	jalr	1972(ra) # df8 <exit>
    } else if(what == 21){
      unlink("c");
     64c:	00001517          	auipc	a0,0x1
     650:	e7c50513          	addi	a0,a0,-388 # 14c8 <malloc+0x286>
     654:	00000097          	auipc	ra,0x0
     658:	7f4080e7          	jalr	2036(ra) # e48 <unlink>
      // should always succeed. check that there are free i-nodes,
      // file descriptors, blocks.
      int fd1 = open("c", O_CREATE|O_RDWR);
     65c:	20200593          	li	a1,514
     660:	00001517          	auipc	a0,0x1
     664:	e6850513          	addi	a0,a0,-408 # 14c8 <malloc+0x286>
     668:	00000097          	auipc	ra,0x0
     66c:	7d0080e7          	jalr	2000(ra) # e38 <open>
     670:	8b2a                	mv	s6,a0
      if(fd1 < 0){
     672:	04054f63          	bltz	a0,6d0 <go+0x658>
        printf("grind: create c failed\n");
        exit(1);
      }
      if(write(fd1, "x", 1) != 1){
     676:	4605                	li	a2,1
     678:	00001597          	auipc	a1,0x1
     67c:	e0858593          	addi	a1,a1,-504 # 1480 <malloc+0x23e>
     680:	00000097          	auipc	ra,0x0
     684:	798080e7          	jalr	1944(ra) # e18 <write>
     688:	4785                	li	a5,1
     68a:	06f51063          	bne	a0,a5,6ea <go+0x672>
        printf("grind: write c failed\n");
        exit(1);
      }
      struct stat st;
      if(fstat(fd1, &st) != 0){
     68e:	fa840593          	addi	a1,s0,-88
     692:	855a                	mv	a0,s6
     694:	00000097          	auipc	ra,0x0
     698:	7bc080e7          	jalr	1980(ra) # e50 <fstat>
     69c:	e525                	bnez	a0,704 <go+0x68c>
        printf("grind: fstat failed\n");
        exit(1);
      }
      if(st.size != 1){
     69e:	fb843583          	ld	a1,-72(s0)
     6a2:	4785                	li	a5,1
     6a4:	06f59d63          	bne	a1,a5,71e <go+0x6a6>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
        exit(1);
      }
      if(st.ino > 200){
     6a8:	fac42583          	lw	a1,-84(s0)
     6ac:	0c800793          	li	a5,200
     6b0:	08b7e563          	bltu	a5,a1,73a <go+0x6c2>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
        exit(1);
      }
      close(fd1);
     6b4:	855a                	mv	a0,s6
     6b6:	00000097          	auipc	ra,0x0
     6ba:	76a080e7          	jalr	1898(ra) # e20 <close>
      unlink("c");
     6be:	00001517          	auipc	a0,0x1
     6c2:	e0a50513          	addi	a0,a0,-502 # 14c8 <malloc+0x286>
     6c6:	00000097          	auipc	ra,0x0
     6ca:	782080e7          	jalr	1922(ra) # e48 <unlink>
     6ce:	bc91                	j	122 <go+0xaa>
        printf("grind: create c failed\n");
     6d0:	00001517          	auipc	a0,0x1
     6d4:	e0050513          	addi	a0,a0,-512 # 14d0 <malloc+0x28e>
     6d8:	00001097          	auipc	ra,0x1
     6dc:	ab2080e7          	jalr	-1358(ra) # 118a <printf>
        exit(1);
     6e0:	4505                	li	a0,1
     6e2:	00000097          	auipc	ra,0x0
     6e6:	716080e7          	jalr	1814(ra) # df8 <exit>
        printf("grind: write c failed\n");
     6ea:	00001517          	auipc	a0,0x1
     6ee:	dfe50513          	addi	a0,a0,-514 # 14e8 <malloc+0x2a6>
     6f2:	00001097          	auipc	ra,0x1
     6f6:	a98080e7          	jalr	-1384(ra) # 118a <printf>
        exit(1);
     6fa:	4505                	li	a0,1
     6fc:	00000097          	auipc	ra,0x0
     700:	6fc080e7          	jalr	1788(ra) # df8 <exit>
        printf("grind: fstat failed\n");
     704:	00001517          	auipc	a0,0x1
     708:	dfc50513          	addi	a0,a0,-516 # 1500 <malloc+0x2be>
     70c:	00001097          	auipc	ra,0x1
     710:	a7e080e7          	jalr	-1410(ra) # 118a <printf>
        exit(1);
     714:	4505                	li	a0,1
     716:	00000097          	auipc	ra,0x0
     71a:	6e2080e7          	jalr	1762(ra) # df8 <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     71e:	2581                	sext.w	a1,a1
     720:	00001517          	auipc	a0,0x1
     724:	df850513          	addi	a0,a0,-520 # 1518 <malloc+0x2d6>
     728:	00001097          	auipc	ra,0x1
     72c:	a62080e7          	jalr	-1438(ra) # 118a <printf>
        exit(1);
     730:	4505                	li	a0,1
     732:	00000097          	auipc	ra,0x0
     736:	6c6080e7          	jalr	1734(ra) # df8 <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     73a:	00001517          	auipc	a0,0x1
     73e:	e0650513          	addi	a0,a0,-506 # 1540 <malloc+0x2fe>
     742:	00001097          	auipc	ra,0x1
     746:	a48080e7          	jalr	-1464(ra) # 118a <printf>
        exit(1);
     74a:	4505                	li	a0,1
     74c:	00000097          	auipc	ra,0x0
     750:	6ac080e7          	jalr	1708(ra) # df8 <exit>
    } else if(what == 22){
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     754:	f9840513          	addi	a0,s0,-104
     758:	00000097          	auipc	ra,0x0
     75c:	6b0080e7          	jalr	1712(ra) # e08 <pipe>
     760:	10054063          	bltz	a0,860 <go+0x7e8>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     764:	fa040513          	addi	a0,s0,-96
     768:	00000097          	auipc	ra,0x0
     76c:	6a0080e7          	jalr	1696(ra) # e08 <pipe>
     770:	10054663          	bltz	a0,87c <go+0x804>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     774:	00000097          	auipc	ra,0x0
     778:	67c080e7          	jalr	1660(ra) # df0 <fork>
      if(pid1 == 0){
     77c:	10050e63          	beqz	a0,898 <go+0x820>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     780:	1c054663          	bltz	a0,94c <go+0x8d4>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     784:	00000097          	auipc	ra,0x0
     788:	66c080e7          	jalr	1644(ra) # df0 <fork>
      if(pid2 == 0){
     78c:	1c050e63          	beqz	a0,968 <go+0x8f0>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     790:	2a054a63          	bltz	a0,a44 <go+0x9cc>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     794:	f9842503          	lw	a0,-104(s0)
     798:	00000097          	auipc	ra,0x0
     79c:	688080e7          	jalr	1672(ra) # e20 <close>
      close(aa[1]);
     7a0:	f9c42503          	lw	a0,-100(s0)
     7a4:	00000097          	auipc	ra,0x0
     7a8:	67c080e7          	jalr	1660(ra) # e20 <close>
      close(bb[1]);
     7ac:	fa442503          	lw	a0,-92(s0)
     7b0:	00000097          	auipc	ra,0x0
     7b4:	670080e7          	jalr	1648(ra) # e20 <close>
      char buf[4] = { 0, 0, 0, 0 };
     7b8:	f8042823          	sw	zero,-112(s0)
      read(bb[0], buf+0, 1);
     7bc:	4605                	li	a2,1
     7be:	f9040593          	addi	a1,s0,-112
     7c2:	fa042503          	lw	a0,-96(s0)
     7c6:	00000097          	auipc	ra,0x0
     7ca:	64a080e7          	jalr	1610(ra) # e10 <read>
      read(bb[0], buf+1, 1);
     7ce:	4605                	li	a2,1
     7d0:	f9140593          	addi	a1,s0,-111
     7d4:	fa042503          	lw	a0,-96(s0)
     7d8:	00000097          	auipc	ra,0x0
     7dc:	638080e7          	jalr	1592(ra) # e10 <read>
      read(bb[0], buf+2, 1);
     7e0:	4605                	li	a2,1
     7e2:	f9240593          	addi	a1,s0,-110
     7e6:	fa042503          	lw	a0,-96(s0)
     7ea:	00000097          	auipc	ra,0x0
     7ee:	626080e7          	jalr	1574(ra) # e10 <read>
      close(bb[0]);
     7f2:	fa042503          	lw	a0,-96(s0)
     7f6:	00000097          	auipc	ra,0x0
     7fa:	62a080e7          	jalr	1578(ra) # e20 <close>
      int st1, st2;
      wait(&st1);
     7fe:	f9440513          	addi	a0,s0,-108
     802:	00000097          	auipc	ra,0x0
     806:	5fe080e7          	jalr	1534(ra) # e00 <wait>
      wait(&st2);
     80a:	fa840513          	addi	a0,s0,-88
     80e:	00000097          	auipc	ra,0x0
     812:	5f2080e7          	jalr	1522(ra) # e00 <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     816:	f9442783          	lw	a5,-108(s0)
     81a:	fa842703          	lw	a4,-88(s0)
     81e:	8fd9                	or	a5,a5,a4
     820:	ef89                	bnez	a5,83a <go+0x7c2>
     822:	00001597          	auipc	a1,0x1
     826:	dbe58593          	addi	a1,a1,-578 # 15e0 <malloc+0x39e>
     82a:	f9040513          	addi	a0,s0,-112
     82e:	00000097          	auipc	ra,0x0
     832:	37a080e7          	jalr	890(ra) # ba8 <strcmp>
     836:	8e0506e3          	beqz	a0,122 <go+0xaa>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     83a:	f9040693          	addi	a3,s0,-112
     83e:	fa842603          	lw	a2,-88(s0)
     842:	f9442583          	lw	a1,-108(s0)
     846:	00001517          	auipc	a0,0x1
     84a:	da250513          	addi	a0,a0,-606 # 15e8 <malloc+0x3a6>
     84e:	00001097          	auipc	ra,0x1
     852:	93c080e7          	jalr	-1732(ra) # 118a <printf>
        exit(1);
     856:	4505                	li	a0,1
     858:	00000097          	auipc	ra,0x0
     85c:	5a0080e7          	jalr	1440(ra) # df8 <exit>
        fprintf(2, "grind: pipe failed\n");
     860:	00001597          	auipc	a1,0x1
     864:	c0858593          	addi	a1,a1,-1016 # 1468 <malloc+0x226>
     868:	4509                	li	a0,2
     86a:	00001097          	auipc	ra,0x1
     86e:	8f2080e7          	jalr	-1806(ra) # 115c <fprintf>
        exit(1);
     872:	4505                	li	a0,1
     874:	00000097          	auipc	ra,0x0
     878:	584080e7          	jalr	1412(ra) # df8 <exit>
        fprintf(2, "grind: pipe failed\n");
     87c:	00001597          	auipc	a1,0x1
     880:	bec58593          	addi	a1,a1,-1044 # 1468 <malloc+0x226>
     884:	4509                	li	a0,2
     886:	00001097          	auipc	ra,0x1
     88a:	8d6080e7          	jalr	-1834(ra) # 115c <fprintf>
        exit(1);
     88e:	4505                	li	a0,1
     890:	00000097          	auipc	ra,0x0
     894:	568080e7          	jalr	1384(ra) # df8 <exit>
        close(bb[0]);
     898:	fa042503          	lw	a0,-96(s0)
     89c:	00000097          	auipc	ra,0x0
     8a0:	584080e7          	jalr	1412(ra) # e20 <close>
        close(bb[1]);
     8a4:	fa442503          	lw	a0,-92(s0)
     8a8:	00000097          	auipc	ra,0x0
     8ac:	578080e7          	jalr	1400(ra) # e20 <close>
        close(aa[0]);
     8b0:	f9842503          	lw	a0,-104(s0)
     8b4:	00000097          	auipc	ra,0x0
     8b8:	56c080e7          	jalr	1388(ra) # e20 <close>
        close(1);
     8bc:	4505                	li	a0,1
     8be:	00000097          	auipc	ra,0x0
     8c2:	562080e7          	jalr	1378(ra) # e20 <close>
        if(dup(aa[1]) != 1){
     8c6:	f9c42503          	lw	a0,-100(s0)
     8ca:	00000097          	auipc	ra,0x0
     8ce:	5a6080e7          	jalr	1446(ra) # e70 <dup>
     8d2:	4785                	li	a5,1
     8d4:	02f50063          	beq	a0,a5,8f4 <go+0x87c>
          fprintf(2, "grind: dup failed\n");
     8d8:	00001597          	auipc	a1,0x1
     8dc:	c9058593          	addi	a1,a1,-880 # 1568 <malloc+0x326>
     8e0:	4509                	li	a0,2
     8e2:	00001097          	auipc	ra,0x1
     8e6:	87a080e7          	jalr	-1926(ra) # 115c <fprintf>
          exit(1);
     8ea:	4505                	li	a0,1
     8ec:	00000097          	auipc	ra,0x0
     8f0:	50c080e7          	jalr	1292(ra) # df8 <exit>
        close(aa[1]);
     8f4:	f9c42503          	lw	a0,-100(s0)
     8f8:	00000097          	auipc	ra,0x0
     8fc:	528080e7          	jalr	1320(ra) # e20 <close>
        char *args[3] = { "echo", "hi", 0 };
     900:	00001797          	auipc	a5,0x1
     904:	c8078793          	addi	a5,a5,-896 # 1580 <malloc+0x33e>
     908:	faf43423          	sd	a5,-88(s0)
     90c:	00001797          	auipc	a5,0x1
     910:	c7c78793          	addi	a5,a5,-900 # 1588 <malloc+0x346>
     914:	faf43823          	sd	a5,-80(s0)
     918:	fa043c23          	sd	zero,-72(s0)
        exec("grindir/../echo", args);
     91c:	fa840593          	addi	a1,s0,-88
     920:	00001517          	auipc	a0,0x1
     924:	c7050513          	addi	a0,a0,-912 # 1590 <malloc+0x34e>
     928:	00000097          	auipc	ra,0x0
     92c:	508080e7          	jalr	1288(ra) # e30 <exec>
        fprintf(2, "grind: echo: not found\n");
     930:	00001597          	auipc	a1,0x1
     934:	c7058593          	addi	a1,a1,-912 # 15a0 <malloc+0x35e>
     938:	4509                	li	a0,2
     93a:	00001097          	auipc	ra,0x1
     93e:	822080e7          	jalr	-2014(ra) # 115c <fprintf>
        exit(2);
     942:	4509                	li	a0,2
     944:	00000097          	auipc	ra,0x0
     948:	4b4080e7          	jalr	1204(ra) # df8 <exit>
        fprintf(2, "grind: fork failed\n");
     94c:	00001597          	auipc	a1,0x1
     950:	adc58593          	addi	a1,a1,-1316 # 1428 <malloc+0x1e6>
     954:	4509                	li	a0,2
     956:	00001097          	auipc	ra,0x1
     95a:	806080e7          	jalr	-2042(ra) # 115c <fprintf>
        exit(3);
     95e:	450d                	li	a0,3
     960:	00000097          	auipc	ra,0x0
     964:	498080e7          	jalr	1176(ra) # df8 <exit>
        close(aa[1]);
     968:	f9c42503          	lw	a0,-100(s0)
     96c:	00000097          	auipc	ra,0x0
     970:	4b4080e7          	jalr	1204(ra) # e20 <close>
        close(bb[0]);
     974:	fa042503          	lw	a0,-96(s0)
     978:	00000097          	auipc	ra,0x0
     97c:	4a8080e7          	jalr	1192(ra) # e20 <close>
        close(0);
     980:	4501                	li	a0,0
     982:	00000097          	auipc	ra,0x0
     986:	49e080e7          	jalr	1182(ra) # e20 <close>
        if(dup(aa[0]) != 0){
     98a:	f9842503          	lw	a0,-104(s0)
     98e:	00000097          	auipc	ra,0x0
     992:	4e2080e7          	jalr	1250(ra) # e70 <dup>
     996:	cd19                	beqz	a0,9b4 <go+0x93c>
          fprintf(2, "grind: dup failed\n");
     998:	00001597          	auipc	a1,0x1
     99c:	bd058593          	addi	a1,a1,-1072 # 1568 <malloc+0x326>
     9a0:	4509                	li	a0,2
     9a2:	00000097          	auipc	ra,0x0
     9a6:	7ba080e7          	jalr	1978(ra) # 115c <fprintf>
          exit(4);
     9aa:	4511                	li	a0,4
     9ac:	00000097          	auipc	ra,0x0
     9b0:	44c080e7          	jalr	1100(ra) # df8 <exit>
        close(aa[0]);
     9b4:	f9842503          	lw	a0,-104(s0)
     9b8:	00000097          	auipc	ra,0x0
     9bc:	468080e7          	jalr	1128(ra) # e20 <close>
        close(1);
     9c0:	4505                	li	a0,1
     9c2:	00000097          	auipc	ra,0x0
     9c6:	45e080e7          	jalr	1118(ra) # e20 <close>
        if(dup(bb[1]) != 1){
     9ca:	fa442503          	lw	a0,-92(s0)
     9ce:	00000097          	auipc	ra,0x0
     9d2:	4a2080e7          	jalr	1186(ra) # e70 <dup>
     9d6:	4785                	li	a5,1
     9d8:	02f50063          	beq	a0,a5,9f8 <go+0x980>
          fprintf(2, "grind: dup failed\n");
     9dc:	00001597          	auipc	a1,0x1
     9e0:	b8c58593          	addi	a1,a1,-1140 # 1568 <malloc+0x326>
     9e4:	4509                	li	a0,2
     9e6:	00000097          	auipc	ra,0x0
     9ea:	776080e7          	jalr	1910(ra) # 115c <fprintf>
          exit(5);
     9ee:	4515                	li	a0,5
     9f0:	00000097          	auipc	ra,0x0
     9f4:	408080e7          	jalr	1032(ra) # df8 <exit>
        close(bb[1]);
     9f8:	fa442503          	lw	a0,-92(s0)
     9fc:	00000097          	auipc	ra,0x0
     a00:	424080e7          	jalr	1060(ra) # e20 <close>
        char *args[2] = { "cat", 0 };
     a04:	00001797          	auipc	a5,0x1
     a08:	bb478793          	addi	a5,a5,-1100 # 15b8 <malloc+0x376>
     a0c:	faf43423          	sd	a5,-88(s0)
     a10:	fa043823          	sd	zero,-80(s0)
        exec("/cat", args);
     a14:	fa840593          	addi	a1,s0,-88
     a18:	00001517          	auipc	a0,0x1
     a1c:	ba850513          	addi	a0,a0,-1112 # 15c0 <malloc+0x37e>
     a20:	00000097          	auipc	ra,0x0
     a24:	410080e7          	jalr	1040(ra) # e30 <exec>
        fprintf(2, "grind: cat: not found\n");
     a28:	00001597          	auipc	a1,0x1
     a2c:	ba058593          	addi	a1,a1,-1120 # 15c8 <malloc+0x386>
     a30:	4509                	li	a0,2
     a32:	00000097          	auipc	ra,0x0
     a36:	72a080e7          	jalr	1834(ra) # 115c <fprintf>
        exit(6);
     a3a:	4519                	li	a0,6
     a3c:	00000097          	auipc	ra,0x0
     a40:	3bc080e7          	jalr	956(ra) # df8 <exit>
        fprintf(2, "grind: fork failed\n");
     a44:	00001597          	auipc	a1,0x1
     a48:	9e458593          	addi	a1,a1,-1564 # 1428 <malloc+0x1e6>
     a4c:	4509                	li	a0,2
     a4e:	00000097          	auipc	ra,0x0
     a52:	70e080e7          	jalr	1806(ra) # 115c <fprintf>
        exit(7);
     a56:	451d                	li	a0,7
     a58:	00000097          	auipc	ra,0x0
     a5c:	3a0080e7          	jalr	928(ra) # df8 <exit>

0000000000000a60 <iter>:
  }
}

void
iter()
{
     a60:	7179                	addi	sp,sp,-48
     a62:	f406                	sd	ra,40(sp)
     a64:	f022                	sd	s0,32(sp)
     a66:	ec26                	sd	s1,24(sp)
     a68:	e84a                	sd	s2,16(sp)
     a6a:	1800                	addi	s0,sp,48
  unlink("a");
     a6c:	00001517          	auipc	a0,0x1
     a70:	99c50513          	addi	a0,a0,-1636 # 1408 <malloc+0x1c6>
     a74:	00000097          	auipc	ra,0x0
     a78:	3d4080e7          	jalr	980(ra) # e48 <unlink>
  unlink("b");
     a7c:	00001517          	auipc	a0,0x1
     a80:	93c50513          	addi	a0,a0,-1732 # 13b8 <malloc+0x176>
     a84:	00000097          	auipc	ra,0x0
     a88:	3c4080e7          	jalr	964(ra) # e48 <unlink>
  
  int pid1 = fork();
     a8c:	00000097          	auipc	ra,0x0
     a90:	364080e7          	jalr	868(ra) # df0 <fork>
  if(pid1 < 0){
     a94:	00054e63          	bltz	a0,ab0 <iter+0x50>
     a98:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     a9a:	e905                	bnez	a0,aca <iter+0x6a>
    rand_next = 31;
     a9c:	47fd                	li	a5,31
     a9e:	00001717          	auipc	a4,0x1
     aa2:	c4f73523          	sd	a5,-950(a4) # 16e8 <rand_next>
    go(0);
     aa6:	4501                	li	a0,0
     aa8:	fffff097          	auipc	ra,0xfffff
     aac:	5d0080e7          	jalr	1488(ra) # 78 <go>
    printf("grind: fork failed\n");
     ab0:	00001517          	auipc	a0,0x1
     ab4:	97850513          	addi	a0,a0,-1672 # 1428 <malloc+0x1e6>
     ab8:	00000097          	auipc	ra,0x0
     abc:	6d2080e7          	jalr	1746(ra) # 118a <printf>
    exit(1);
     ac0:	4505                	li	a0,1
     ac2:	00000097          	auipc	ra,0x0
     ac6:	336080e7          	jalr	822(ra) # df8 <exit>
    exit(0);
  }

  int pid2 = fork();
     aca:	00000097          	auipc	ra,0x0
     ace:	326080e7          	jalr	806(ra) # df0 <fork>
     ad2:	892a                	mv	s2,a0
  if(pid2 < 0){
     ad4:	00054f63          	bltz	a0,af2 <iter+0x92>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     ad8:	e915                	bnez	a0,b0c <iter+0xac>
    rand_next = 7177;
     ada:	6789                	lui	a5,0x2
     adc:	c0978793          	addi	a5,a5,-1015 # 1c09 <__BSS_END__+0x119>
     ae0:	00001717          	auipc	a4,0x1
     ae4:	c0f73423          	sd	a5,-1016(a4) # 16e8 <rand_next>
    go(1);
     ae8:	4505                	li	a0,1
     aea:	fffff097          	auipc	ra,0xfffff
     aee:	58e080e7          	jalr	1422(ra) # 78 <go>
    printf("grind: fork failed\n");
     af2:	00001517          	auipc	a0,0x1
     af6:	93650513          	addi	a0,a0,-1738 # 1428 <malloc+0x1e6>
     afa:	00000097          	auipc	ra,0x0
     afe:	690080e7          	jalr	1680(ra) # 118a <printf>
    exit(1);
     b02:	4505                	li	a0,1
     b04:	00000097          	auipc	ra,0x0
     b08:	2f4080e7          	jalr	756(ra) # df8 <exit>
    exit(0);
  }

  int st1 = -1;
     b0c:	57fd                	li	a5,-1
     b0e:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     b12:	fdc40513          	addi	a0,s0,-36
     b16:	00000097          	auipc	ra,0x0
     b1a:	2ea080e7          	jalr	746(ra) # e00 <wait>
  if(st1 != 0){
     b1e:	fdc42783          	lw	a5,-36(s0)
     b22:	ef99                	bnez	a5,b40 <iter+0xe0>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     b24:	57fd                	li	a5,-1
     b26:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     b2a:	fd840513          	addi	a0,s0,-40
     b2e:	00000097          	auipc	ra,0x0
     b32:	2d2080e7          	jalr	722(ra) # e00 <wait>

  exit(0);
     b36:	4501                	li	a0,0
     b38:	00000097          	auipc	ra,0x0
     b3c:	2c0080e7          	jalr	704(ra) # df8 <exit>
    kill(pid1);
     b40:	8526                	mv	a0,s1
     b42:	00000097          	auipc	ra,0x0
     b46:	2e6080e7          	jalr	742(ra) # e28 <kill>
    kill(pid2);
     b4a:	854a                	mv	a0,s2
     b4c:	00000097          	auipc	ra,0x0
     b50:	2dc080e7          	jalr	732(ra) # e28 <kill>
     b54:	bfc1                	j	b24 <iter+0xc4>

0000000000000b56 <main>:
}

int
main()
{
     b56:	1141                	addi	sp,sp,-16
     b58:	e406                	sd	ra,8(sp)
     b5a:	e022                	sd	s0,0(sp)
     b5c:	0800                	addi	s0,sp,16
     b5e:	a811                	j	b72 <main+0x1c>
  while(1){
    int pid = fork();
    if(pid == 0){
      iter();
     b60:	00000097          	auipc	ra,0x0
     b64:	f00080e7          	jalr	-256(ra) # a60 <iter>
      exit(0);
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
     b68:	4551                	li	a0,20
     b6a:	00000097          	auipc	ra,0x0
     b6e:	31e080e7          	jalr	798(ra) # e88 <sleep>
    int pid = fork();
     b72:	00000097          	auipc	ra,0x0
     b76:	27e080e7          	jalr	638(ra) # df0 <fork>
    if(pid == 0){
     b7a:	d17d                	beqz	a0,b60 <main+0xa>
    if(pid > 0){
     b7c:	fea056e3          	blez	a0,b68 <main+0x12>
      wait(0);
     b80:	4501                	li	a0,0
     b82:	00000097          	auipc	ra,0x0
     b86:	27e080e7          	jalr	638(ra) # e00 <wait>
     b8a:	bff9                	j	b68 <main+0x12>

0000000000000b8c <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
     b8c:	1141                	addi	sp,sp,-16
     b8e:	e422                	sd	s0,8(sp)
     b90:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     b92:	87aa                	mv	a5,a0
     b94:	0585                	addi	a1,a1,1
     b96:	0785                	addi	a5,a5,1
     b98:	fff5c703          	lbu	a4,-1(a1)
     b9c:	fee78fa3          	sb	a4,-1(a5)
     ba0:	fb75                	bnez	a4,b94 <strcpy+0x8>
    ;
  return os;
}
     ba2:	6422                	ld	s0,8(sp)
     ba4:	0141                	addi	sp,sp,16
     ba6:	8082                	ret

0000000000000ba8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     ba8:	1141                	addi	sp,sp,-16
     baa:	e422                	sd	s0,8(sp)
     bac:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     bae:	00054783          	lbu	a5,0(a0)
     bb2:	cb91                	beqz	a5,bc6 <strcmp+0x1e>
     bb4:	0005c703          	lbu	a4,0(a1)
     bb8:	00f71763          	bne	a4,a5,bc6 <strcmp+0x1e>
    p++, q++;
     bbc:	0505                	addi	a0,a0,1
     bbe:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     bc0:	00054783          	lbu	a5,0(a0)
     bc4:	fbe5                	bnez	a5,bb4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     bc6:	0005c503          	lbu	a0,0(a1)
}
     bca:	40a7853b          	subw	a0,a5,a0
     bce:	6422                	ld	s0,8(sp)
     bd0:	0141                	addi	sp,sp,16
     bd2:	8082                	ret

0000000000000bd4 <strlen>:

uint
strlen(const char *s)
{
     bd4:	1141                	addi	sp,sp,-16
     bd6:	e422                	sd	s0,8(sp)
     bd8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     bda:	00054783          	lbu	a5,0(a0)
     bde:	cf91                	beqz	a5,bfa <strlen+0x26>
     be0:	0505                	addi	a0,a0,1
     be2:	87aa                	mv	a5,a0
     be4:	4685                	li	a3,1
     be6:	9e89                	subw	a3,a3,a0
     be8:	00f6853b          	addw	a0,a3,a5
     bec:	0785                	addi	a5,a5,1
     bee:	fff7c703          	lbu	a4,-1(a5)
     bf2:	fb7d                	bnez	a4,be8 <strlen+0x14>
    ;
  return n;
}
     bf4:	6422                	ld	s0,8(sp)
     bf6:	0141                	addi	sp,sp,16
     bf8:	8082                	ret
  for(n = 0; s[n]; n++)
     bfa:	4501                	li	a0,0
     bfc:	bfe5                	j	bf4 <strlen+0x20>

0000000000000bfe <memset>:

void*
memset(void *dst, int c, uint n)
{
     bfe:	1141                	addi	sp,sp,-16
     c00:	e422                	sd	s0,8(sp)
     c02:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     c04:	ca19                	beqz	a2,c1a <memset+0x1c>
     c06:	87aa                	mv	a5,a0
     c08:	1602                	slli	a2,a2,0x20
     c0a:	9201                	srli	a2,a2,0x20
     c0c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     c10:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     c14:	0785                	addi	a5,a5,1
     c16:	fee79de3          	bne	a5,a4,c10 <memset+0x12>
  }
  return dst;
}
     c1a:	6422                	ld	s0,8(sp)
     c1c:	0141                	addi	sp,sp,16
     c1e:	8082                	ret

0000000000000c20 <strchr>:

char*
strchr(const char *s, char c)
{
     c20:	1141                	addi	sp,sp,-16
     c22:	e422                	sd	s0,8(sp)
     c24:	0800                	addi	s0,sp,16
  for(; *s; s++)
     c26:	00054783          	lbu	a5,0(a0)
     c2a:	cb99                	beqz	a5,c40 <strchr+0x20>
    if(*s == c)
     c2c:	00f58763          	beq	a1,a5,c3a <strchr+0x1a>
  for(; *s; s++)
     c30:	0505                	addi	a0,a0,1
     c32:	00054783          	lbu	a5,0(a0)
     c36:	fbfd                	bnez	a5,c2c <strchr+0xc>
      return (char*)s;
  return 0;
     c38:	4501                	li	a0,0
}
     c3a:	6422                	ld	s0,8(sp)
     c3c:	0141                	addi	sp,sp,16
     c3e:	8082                	ret
  return 0;
     c40:	4501                	li	a0,0
     c42:	bfe5                	j	c3a <strchr+0x1a>

0000000000000c44 <gets>:

char*
gets(char *buf, int max)
{
     c44:	711d                	addi	sp,sp,-96
     c46:	ec86                	sd	ra,88(sp)
     c48:	e8a2                	sd	s0,80(sp)
     c4a:	e4a6                	sd	s1,72(sp)
     c4c:	e0ca                	sd	s2,64(sp)
     c4e:	fc4e                	sd	s3,56(sp)
     c50:	f852                	sd	s4,48(sp)
     c52:	f456                	sd	s5,40(sp)
     c54:	f05a                	sd	s6,32(sp)
     c56:	ec5e                	sd	s7,24(sp)
     c58:	1080                	addi	s0,sp,96
     c5a:	8baa                	mv	s7,a0
     c5c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c5e:	892a                	mv	s2,a0
     c60:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     c62:	4aa9                	li	s5,10
     c64:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     c66:	89a6                	mv	s3,s1
     c68:	2485                	addiw	s1,s1,1
     c6a:	0344d863          	bge	s1,s4,c9a <gets+0x56>
    cc = read(0, &c, 1);
     c6e:	4605                	li	a2,1
     c70:	faf40593          	addi	a1,s0,-81
     c74:	4501                	li	a0,0
     c76:	00000097          	auipc	ra,0x0
     c7a:	19a080e7          	jalr	410(ra) # e10 <read>
    if(cc < 1)
     c7e:	00a05e63          	blez	a0,c9a <gets+0x56>
    buf[i++] = c;
     c82:	faf44783          	lbu	a5,-81(s0)
     c86:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     c8a:	01578763          	beq	a5,s5,c98 <gets+0x54>
     c8e:	0905                	addi	s2,s2,1
     c90:	fd679be3          	bne	a5,s6,c66 <gets+0x22>
  for(i=0; i+1 < max; ){
     c94:	89a6                	mv	s3,s1
     c96:	a011                	j	c9a <gets+0x56>
     c98:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     c9a:	99de                	add	s3,s3,s7
     c9c:	00098023          	sb	zero,0(s3)
  return buf;
}
     ca0:	855e                	mv	a0,s7
     ca2:	60e6                	ld	ra,88(sp)
     ca4:	6446                	ld	s0,80(sp)
     ca6:	64a6                	ld	s1,72(sp)
     ca8:	6906                	ld	s2,64(sp)
     caa:	79e2                	ld	s3,56(sp)
     cac:	7a42                	ld	s4,48(sp)
     cae:	7aa2                	ld	s5,40(sp)
     cb0:	7b02                	ld	s6,32(sp)
     cb2:	6be2                	ld	s7,24(sp)
     cb4:	6125                	addi	sp,sp,96
     cb6:	8082                	ret

0000000000000cb8 <stat>:

int
stat(const char *n, struct stat *st)
{
     cb8:	1101                	addi	sp,sp,-32
     cba:	ec06                	sd	ra,24(sp)
     cbc:	e822                	sd	s0,16(sp)
     cbe:	e426                	sd	s1,8(sp)
     cc0:	e04a                	sd	s2,0(sp)
     cc2:	1000                	addi	s0,sp,32
     cc4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     cc6:	4581                	li	a1,0
     cc8:	00000097          	auipc	ra,0x0
     ccc:	170080e7          	jalr	368(ra) # e38 <open>
  if(fd < 0)
     cd0:	02054563          	bltz	a0,cfa <stat+0x42>
     cd4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     cd6:	85ca                	mv	a1,s2
     cd8:	00000097          	auipc	ra,0x0
     cdc:	178080e7          	jalr	376(ra) # e50 <fstat>
     ce0:	892a                	mv	s2,a0
  close(fd);
     ce2:	8526                	mv	a0,s1
     ce4:	00000097          	auipc	ra,0x0
     ce8:	13c080e7          	jalr	316(ra) # e20 <close>
  return r;
}
     cec:	854a                	mv	a0,s2
     cee:	60e2                	ld	ra,24(sp)
     cf0:	6442                	ld	s0,16(sp)
     cf2:	64a2                	ld	s1,8(sp)
     cf4:	6902                	ld	s2,0(sp)
     cf6:	6105                	addi	sp,sp,32
     cf8:	8082                	ret
    return -1;
     cfa:	597d                	li	s2,-1
     cfc:	bfc5                	j	cec <stat+0x34>

0000000000000cfe <atoi>:

int
atoi(const char *s)
{
     cfe:	1141                	addi	sp,sp,-16
     d00:	e422                	sd	s0,8(sp)
     d02:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d04:	00054683          	lbu	a3,0(a0)
     d08:	fd06879b          	addiw	a5,a3,-48
     d0c:	0ff7f793          	zext.b	a5,a5
     d10:	4625                	li	a2,9
     d12:	02f66863          	bltu	a2,a5,d42 <atoi+0x44>
     d16:	872a                	mv	a4,a0
  n = 0;
     d18:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     d1a:	0705                	addi	a4,a4,1
     d1c:	0025179b          	slliw	a5,a0,0x2
     d20:	9fa9                	addw	a5,a5,a0
     d22:	0017979b          	slliw	a5,a5,0x1
     d26:	9fb5                	addw	a5,a5,a3
     d28:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     d2c:	00074683          	lbu	a3,0(a4)
     d30:	fd06879b          	addiw	a5,a3,-48
     d34:	0ff7f793          	zext.b	a5,a5
     d38:	fef671e3          	bgeu	a2,a5,d1a <atoi+0x1c>
  return n;
}
     d3c:	6422                	ld	s0,8(sp)
     d3e:	0141                	addi	sp,sp,16
     d40:	8082                	ret
  n = 0;
     d42:	4501                	li	a0,0
     d44:	bfe5                	j	d3c <atoi+0x3e>

0000000000000d46 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     d46:	1141                	addi	sp,sp,-16
     d48:	e422                	sd	s0,8(sp)
     d4a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     d4c:	02b57463          	bgeu	a0,a1,d74 <memmove+0x2e>
    while(n-- > 0)
     d50:	00c05f63          	blez	a2,d6e <memmove+0x28>
     d54:	1602                	slli	a2,a2,0x20
     d56:	9201                	srli	a2,a2,0x20
     d58:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     d5c:	872a                	mv	a4,a0
      *dst++ = *src++;
     d5e:	0585                	addi	a1,a1,1
     d60:	0705                	addi	a4,a4,1
     d62:	fff5c683          	lbu	a3,-1(a1)
     d66:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     d6a:	fee79ae3          	bne	a5,a4,d5e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     d6e:	6422                	ld	s0,8(sp)
     d70:	0141                	addi	sp,sp,16
     d72:	8082                	ret
    dst += n;
     d74:	00c50733          	add	a4,a0,a2
    src += n;
     d78:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     d7a:	fec05ae3          	blez	a2,d6e <memmove+0x28>
     d7e:	fff6079b          	addiw	a5,a2,-1
     d82:	1782                	slli	a5,a5,0x20
     d84:	9381                	srli	a5,a5,0x20
     d86:	fff7c793          	not	a5,a5
     d8a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     d8c:	15fd                	addi	a1,a1,-1
     d8e:	177d                	addi	a4,a4,-1
     d90:	0005c683          	lbu	a3,0(a1)
     d94:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     d98:	fee79ae3          	bne	a5,a4,d8c <memmove+0x46>
     d9c:	bfc9                	j	d6e <memmove+0x28>

0000000000000d9e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     d9e:	1141                	addi	sp,sp,-16
     da0:	e422                	sd	s0,8(sp)
     da2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     da4:	ca05                	beqz	a2,dd4 <memcmp+0x36>
     da6:	fff6069b          	addiw	a3,a2,-1
     daa:	1682                	slli	a3,a3,0x20
     dac:	9281                	srli	a3,a3,0x20
     dae:	0685                	addi	a3,a3,1
     db0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     db2:	00054783          	lbu	a5,0(a0)
     db6:	0005c703          	lbu	a4,0(a1)
     dba:	00e79863          	bne	a5,a4,dca <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     dbe:	0505                	addi	a0,a0,1
    p2++;
     dc0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     dc2:	fed518e3          	bne	a0,a3,db2 <memcmp+0x14>
  }
  return 0;
     dc6:	4501                	li	a0,0
     dc8:	a019                	j	dce <memcmp+0x30>
      return *p1 - *p2;
     dca:	40e7853b          	subw	a0,a5,a4
}
     dce:	6422                	ld	s0,8(sp)
     dd0:	0141                	addi	sp,sp,16
     dd2:	8082                	ret
  return 0;
     dd4:	4501                	li	a0,0
     dd6:	bfe5                	j	dce <memcmp+0x30>

0000000000000dd8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     dd8:	1141                	addi	sp,sp,-16
     dda:	e406                	sd	ra,8(sp)
     ddc:	e022                	sd	s0,0(sp)
     dde:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     de0:	00000097          	auipc	ra,0x0
     de4:	f66080e7          	jalr	-154(ra) # d46 <memmove>
}
     de8:	60a2                	ld	ra,8(sp)
     dea:	6402                	ld	s0,0(sp)
     dec:	0141                	addi	sp,sp,16
     dee:	8082                	ret

0000000000000df0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     df0:	4885                	li	a7,1
 ecall
     df2:	00000073          	ecall
 ret
     df6:	8082                	ret

0000000000000df8 <exit>:
.global exit
exit:
 li a7, SYS_exit
     df8:	4889                	li	a7,2
 ecall
     dfa:	00000073          	ecall
 ret
     dfe:	8082                	ret

0000000000000e00 <wait>:
.global wait
wait:
 li a7, SYS_wait
     e00:	488d                	li	a7,3
 ecall
     e02:	00000073          	ecall
 ret
     e06:	8082                	ret

0000000000000e08 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     e08:	4891                	li	a7,4
 ecall
     e0a:	00000073          	ecall
 ret
     e0e:	8082                	ret

0000000000000e10 <read>:
.global read
read:
 li a7, SYS_read
     e10:	4895                	li	a7,5
 ecall
     e12:	00000073          	ecall
 ret
     e16:	8082                	ret

0000000000000e18 <write>:
.global write
write:
 li a7, SYS_write
     e18:	48c1                	li	a7,16
 ecall
     e1a:	00000073          	ecall
 ret
     e1e:	8082                	ret

0000000000000e20 <close>:
.global close
close:
 li a7, SYS_close
     e20:	48d5                	li	a7,21
 ecall
     e22:	00000073          	ecall
 ret
     e26:	8082                	ret

0000000000000e28 <kill>:
.global kill
kill:
 li a7, SYS_kill
     e28:	4899                	li	a7,6
 ecall
     e2a:	00000073          	ecall
 ret
     e2e:	8082                	ret

0000000000000e30 <exec>:
.global exec
exec:
 li a7, SYS_exec
     e30:	489d                	li	a7,7
 ecall
     e32:	00000073          	ecall
 ret
     e36:	8082                	ret

0000000000000e38 <open>:
.global open
open:
 li a7, SYS_open
     e38:	48bd                	li	a7,15
 ecall
     e3a:	00000073          	ecall
 ret
     e3e:	8082                	ret

0000000000000e40 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     e40:	48c5                	li	a7,17
 ecall
     e42:	00000073          	ecall
 ret
     e46:	8082                	ret

0000000000000e48 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     e48:	48c9                	li	a7,18
 ecall
     e4a:	00000073          	ecall
 ret
     e4e:	8082                	ret

0000000000000e50 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     e50:	48a1                	li	a7,8
 ecall
     e52:	00000073          	ecall
 ret
     e56:	8082                	ret

0000000000000e58 <link>:
.global link
link:
 li a7, SYS_link
     e58:	48cd                	li	a7,19
 ecall
     e5a:	00000073          	ecall
 ret
     e5e:	8082                	ret

0000000000000e60 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     e60:	48d1                	li	a7,20
 ecall
     e62:	00000073          	ecall
 ret
     e66:	8082                	ret

0000000000000e68 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     e68:	48a5                	li	a7,9
 ecall
     e6a:	00000073          	ecall
 ret
     e6e:	8082                	ret

0000000000000e70 <dup>:
.global dup
dup:
 li a7, SYS_dup
     e70:	48a9                	li	a7,10
 ecall
     e72:	00000073          	ecall
 ret
     e76:	8082                	ret

0000000000000e78 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     e78:	48ad                	li	a7,11
 ecall
     e7a:	00000073          	ecall
 ret
     e7e:	8082                	ret

0000000000000e80 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     e80:	48b1                	li	a7,12
 ecall
     e82:	00000073          	ecall
 ret
     e86:	8082                	ret

0000000000000e88 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     e88:	48b5                	li	a7,13
 ecall
     e8a:	00000073          	ecall
 ret
     e8e:	8082                	ret

0000000000000e90 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     e90:	48b9                	li	a7,14
 ecall
     e92:	00000073          	ecall
 ret
     e96:	8082                	ret

0000000000000e98 <trace>:
.global trace
trace:
 li a7, SYS_trace
     e98:	48d9                	li	a7,22
 ecall
     e9a:	00000073          	ecall
 ret
     e9e:	8082                	ret

0000000000000ea0 <set_priority>:
.global set_priority
set_priority:
 li a7, SYS_set_priority
     ea0:	48dd                	li	a7,23
 ecall
     ea2:	00000073          	ecall
 ret
     ea6:	8082                	ret

0000000000000ea8 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
     ea8:	48e1                	li	a7,24
 ecall
     eaa:	00000073          	ecall
 ret
     eae:	8082                	ret

0000000000000eb0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     eb0:	1101                	addi	sp,sp,-32
     eb2:	ec06                	sd	ra,24(sp)
     eb4:	e822                	sd	s0,16(sp)
     eb6:	1000                	addi	s0,sp,32
     eb8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     ebc:	4605                	li	a2,1
     ebe:	fef40593          	addi	a1,s0,-17
     ec2:	00000097          	auipc	ra,0x0
     ec6:	f56080e7          	jalr	-170(ra) # e18 <write>
}
     eca:	60e2                	ld	ra,24(sp)
     ecc:	6442                	ld	s0,16(sp)
     ece:	6105                	addi	sp,sp,32
     ed0:	8082                	ret

0000000000000ed2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     ed2:	7139                	addi	sp,sp,-64
     ed4:	fc06                	sd	ra,56(sp)
     ed6:	f822                	sd	s0,48(sp)
     ed8:	f426                	sd	s1,40(sp)
     eda:	f04a                	sd	s2,32(sp)
     edc:	ec4e                	sd	s3,24(sp)
     ede:	0080                	addi	s0,sp,64
     ee0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     ee2:	c299                	beqz	a3,ee8 <printint+0x16>
     ee4:	0805c963          	bltz	a1,f76 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     ee8:	2581                	sext.w	a1,a1
  neg = 0;
     eea:	4881                	li	a7,0
     eec:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     ef0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     ef2:	2601                	sext.w	a2,a2
     ef4:	00000517          	auipc	a0,0x0
     ef8:	7dc50513          	addi	a0,a0,2012 # 16d0 <digits>
     efc:	883a                	mv	a6,a4
     efe:	2705                	addiw	a4,a4,1
     f00:	02c5f7bb          	remuw	a5,a1,a2
     f04:	1782                	slli	a5,a5,0x20
     f06:	9381                	srli	a5,a5,0x20
     f08:	97aa                	add	a5,a5,a0
     f0a:	0007c783          	lbu	a5,0(a5)
     f0e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     f12:	0005879b          	sext.w	a5,a1
     f16:	02c5d5bb          	divuw	a1,a1,a2
     f1a:	0685                	addi	a3,a3,1
     f1c:	fec7f0e3          	bgeu	a5,a2,efc <printint+0x2a>
  if(neg)
     f20:	00088c63          	beqz	a7,f38 <printint+0x66>
    buf[i++] = '-';
     f24:	fd070793          	addi	a5,a4,-48
     f28:	00878733          	add	a4,a5,s0
     f2c:	02d00793          	li	a5,45
     f30:	fef70823          	sb	a5,-16(a4)
     f34:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     f38:	02e05863          	blez	a4,f68 <printint+0x96>
     f3c:	fc040793          	addi	a5,s0,-64
     f40:	00e78933          	add	s2,a5,a4
     f44:	fff78993          	addi	s3,a5,-1
     f48:	99ba                	add	s3,s3,a4
     f4a:	377d                	addiw	a4,a4,-1
     f4c:	1702                	slli	a4,a4,0x20
     f4e:	9301                	srli	a4,a4,0x20
     f50:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     f54:	fff94583          	lbu	a1,-1(s2)
     f58:	8526                	mv	a0,s1
     f5a:	00000097          	auipc	ra,0x0
     f5e:	f56080e7          	jalr	-170(ra) # eb0 <putc>
  while(--i >= 0)
     f62:	197d                	addi	s2,s2,-1
     f64:	ff3918e3          	bne	s2,s3,f54 <printint+0x82>
}
     f68:	70e2                	ld	ra,56(sp)
     f6a:	7442                	ld	s0,48(sp)
     f6c:	74a2                	ld	s1,40(sp)
     f6e:	7902                	ld	s2,32(sp)
     f70:	69e2                	ld	s3,24(sp)
     f72:	6121                	addi	sp,sp,64
     f74:	8082                	ret
    x = -xx;
     f76:	40b005bb          	negw	a1,a1
    neg = 1;
     f7a:	4885                	li	a7,1
    x = -xx;
     f7c:	bf85                	j	eec <printint+0x1a>

0000000000000f7e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     f7e:	7119                	addi	sp,sp,-128
     f80:	fc86                	sd	ra,120(sp)
     f82:	f8a2                	sd	s0,112(sp)
     f84:	f4a6                	sd	s1,104(sp)
     f86:	f0ca                	sd	s2,96(sp)
     f88:	ecce                	sd	s3,88(sp)
     f8a:	e8d2                	sd	s4,80(sp)
     f8c:	e4d6                	sd	s5,72(sp)
     f8e:	e0da                	sd	s6,64(sp)
     f90:	fc5e                	sd	s7,56(sp)
     f92:	f862                	sd	s8,48(sp)
     f94:	f466                	sd	s9,40(sp)
     f96:	f06a                	sd	s10,32(sp)
     f98:	ec6e                	sd	s11,24(sp)
     f9a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     f9c:	0005c903          	lbu	s2,0(a1)
     fa0:	18090f63          	beqz	s2,113e <vprintf+0x1c0>
     fa4:	8aaa                	mv	s5,a0
     fa6:	8b32                	mv	s6,a2
     fa8:	00158493          	addi	s1,a1,1
  state = 0;
     fac:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     fae:	02500a13          	li	s4,37
     fb2:	4c55                	li	s8,21
     fb4:	00000c97          	auipc	s9,0x0
     fb8:	6c4c8c93          	addi	s9,s9,1732 # 1678 <malloc+0x436>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     fbc:	02800d93          	li	s11,40
  putc(fd, 'x');
     fc0:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     fc2:	00000b97          	auipc	s7,0x0
     fc6:	70eb8b93          	addi	s7,s7,1806 # 16d0 <digits>
     fca:	a839                	j	fe8 <vprintf+0x6a>
        putc(fd, c);
     fcc:	85ca                	mv	a1,s2
     fce:	8556                	mv	a0,s5
     fd0:	00000097          	auipc	ra,0x0
     fd4:	ee0080e7          	jalr	-288(ra) # eb0 <putc>
     fd8:	a019                	j	fde <vprintf+0x60>
    } else if(state == '%'){
     fda:	01498d63          	beq	s3,s4,ff4 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
     fde:	0485                	addi	s1,s1,1
     fe0:	fff4c903          	lbu	s2,-1(s1)
     fe4:	14090d63          	beqz	s2,113e <vprintf+0x1c0>
    if(state == 0){
     fe8:	fe0999e3          	bnez	s3,fda <vprintf+0x5c>
      if(c == '%'){
     fec:	ff4910e3          	bne	s2,s4,fcc <vprintf+0x4e>
        state = '%';
     ff0:	89d2                	mv	s3,s4
     ff2:	b7f5                	j	fde <vprintf+0x60>
      if(c == 'd'){
     ff4:	11490c63          	beq	s2,s4,110c <vprintf+0x18e>
     ff8:	f9d9079b          	addiw	a5,s2,-99
     ffc:	0ff7f793          	zext.b	a5,a5
    1000:	10fc6e63          	bltu	s8,a5,111c <vprintf+0x19e>
    1004:	f9d9079b          	addiw	a5,s2,-99
    1008:	0ff7f713          	zext.b	a4,a5
    100c:	10ec6863          	bltu	s8,a4,111c <vprintf+0x19e>
    1010:	00271793          	slli	a5,a4,0x2
    1014:	97e6                	add	a5,a5,s9
    1016:	439c                	lw	a5,0(a5)
    1018:	97e6                	add	a5,a5,s9
    101a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    101c:	008b0913          	addi	s2,s6,8
    1020:	4685                	li	a3,1
    1022:	4629                	li	a2,10
    1024:	000b2583          	lw	a1,0(s6)
    1028:	8556                	mv	a0,s5
    102a:	00000097          	auipc	ra,0x0
    102e:	ea8080e7          	jalr	-344(ra) # ed2 <printint>
    1032:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1034:	4981                	li	s3,0
    1036:	b765                	j	fde <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1038:	008b0913          	addi	s2,s6,8
    103c:	4681                	li	a3,0
    103e:	4629                	li	a2,10
    1040:	000b2583          	lw	a1,0(s6)
    1044:	8556                	mv	a0,s5
    1046:	00000097          	auipc	ra,0x0
    104a:	e8c080e7          	jalr	-372(ra) # ed2 <printint>
    104e:	8b4a                	mv	s6,s2
      state = 0;
    1050:	4981                	li	s3,0
    1052:	b771                	j	fde <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    1054:	008b0913          	addi	s2,s6,8
    1058:	4681                	li	a3,0
    105a:	866a                	mv	a2,s10
    105c:	000b2583          	lw	a1,0(s6)
    1060:	8556                	mv	a0,s5
    1062:	00000097          	auipc	ra,0x0
    1066:	e70080e7          	jalr	-400(ra) # ed2 <printint>
    106a:	8b4a                	mv	s6,s2
      state = 0;
    106c:	4981                	li	s3,0
    106e:	bf85                	j	fde <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    1070:	008b0793          	addi	a5,s6,8
    1074:	f8f43423          	sd	a5,-120(s0)
    1078:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    107c:	03000593          	li	a1,48
    1080:	8556                	mv	a0,s5
    1082:	00000097          	auipc	ra,0x0
    1086:	e2e080e7          	jalr	-466(ra) # eb0 <putc>
  putc(fd, 'x');
    108a:	07800593          	li	a1,120
    108e:	8556                	mv	a0,s5
    1090:	00000097          	auipc	ra,0x0
    1094:	e20080e7          	jalr	-480(ra) # eb0 <putc>
    1098:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    109a:	03c9d793          	srli	a5,s3,0x3c
    109e:	97de                	add	a5,a5,s7
    10a0:	0007c583          	lbu	a1,0(a5)
    10a4:	8556                	mv	a0,s5
    10a6:	00000097          	auipc	ra,0x0
    10aa:	e0a080e7          	jalr	-502(ra) # eb0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    10ae:	0992                	slli	s3,s3,0x4
    10b0:	397d                	addiw	s2,s2,-1
    10b2:	fe0914e3          	bnez	s2,109a <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
    10b6:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    10ba:	4981                	li	s3,0
    10bc:	b70d                	j	fde <vprintf+0x60>
        s = va_arg(ap, char*);
    10be:	008b0913          	addi	s2,s6,8
    10c2:	000b3983          	ld	s3,0(s6)
        if(s == 0)
    10c6:	02098163          	beqz	s3,10e8 <vprintf+0x16a>
        while(*s != 0){
    10ca:	0009c583          	lbu	a1,0(s3)
    10ce:	c5ad                	beqz	a1,1138 <vprintf+0x1ba>
          putc(fd, *s);
    10d0:	8556                	mv	a0,s5
    10d2:	00000097          	auipc	ra,0x0
    10d6:	dde080e7          	jalr	-546(ra) # eb0 <putc>
          s++;
    10da:	0985                	addi	s3,s3,1
        while(*s != 0){
    10dc:	0009c583          	lbu	a1,0(s3)
    10e0:	f9e5                	bnez	a1,10d0 <vprintf+0x152>
        s = va_arg(ap, char*);
    10e2:	8b4a                	mv	s6,s2
      state = 0;
    10e4:	4981                	li	s3,0
    10e6:	bde5                	j	fde <vprintf+0x60>
          s = "(null)";
    10e8:	00000997          	auipc	s3,0x0
    10ec:	58898993          	addi	s3,s3,1416 # 1670 <malloc+0x42e>
        while(*s != 0){
    10f0:	85ee                	mv	a1,s11
    10f2:	bff9                	j	10d0 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
    10f4:	008b0913          	addi	s2,s6,8
    10f8:	000b4583          	lbu	a1,0(s6)
    10fc:	8556                	mv	a0,s5
    10fe:	00000097          	auipc	ra,0x0
    1102:	db2080e7          	jalr	-590(ra) # eb0 <putc>
    1106:	8b4a                	mv	s6,s2
      state = 0;
    1108:	4981                	li	s3,0
    110a:	bdd1                	j	fde <vprintf+0x60>
        putc(fd, c);
    110c:	85d2                	mv	a1,s4
    110e:	8556                	mv	a0,s5
    1110:	00000097          	auipc	ra,0x0
    1114:	da0080e7          	jalr	-608(ra) # eb0 <putc>
      state = 0;
    1118:	4981                	li	s3,0
    111a:	b5d1                	j	fde <vprintf+0x60>
        putc(fd, '%');
    111c:	85d2                	mv	a1,s4
    111e:	8556                	mv	a0,s5
    1120:	00000097          	auipc	ra,0x0
    1124:	d90080e7          	jalr	-624(ra) # eb0 <putc>
        putc(fd, c);
    1128:	85ca                	mv	a1,s2
    112a:	8556                	mv	a0,s5
    112c:	00000097          	auipc	ra,0x0
    1130:	d84080e7          	jalr	-636(ra) # eb0 <putc>
      state = 0;
    1134:	4981                	li	s3,0
    1136:	b565                	j	fde <vprintf+0x60>
        s = va_arg(ap, char*);
    1138:	8b4a                	mv	s6,s2
      state = 0;
    113a:	4981                	li	s3,0
    113c:	b54d                	j	fde <vprintf+0x60>
    }
  }
}
    113e:	70e6                	ld	ra,120(sp)
    1140:	7446                	ld	s0,112(sp)
    1142:	74a6                	ld	s1,104(sp)
    1144:	7906                	ld	s2,96(sp)
    1146:	69e6                	ld	s3,88(sp)
    1148:	6a46                	ld	s4,80(sp)
    114a:	6aa6                	ld	s5,72(sp)
    114c:	6b06                	ld	s6,64(sp)
    114e:	7be2                	ld	s7,56(sp)
    1150:	7c42                	ld	s8,48(sp)
    1152:	7ca2                	ld	s9,40(sp)
    1154:	7d02                	ld	s10,32(sp)
    1156:	6de2                	ld	s11,24(sp)
    1158:	6109                	addi	sp,sp,128
    115a:	8082                	ret

000000000000115c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    115c:	715d                	addi	sp,sp,-80
    115e:	ec06                	sd	ra,24(sp)
    1160:	e822                	sd	s0,16(sp)
    1162:	1000                	addi	s0,sp,32
    1164:	e010                	sd	a2,0(s0)
    1166:	e414                	sd	a3,8(s0)
    1168:	e818                	sd	a4,16(s0)
    116a:	ec1c                	sd	a5,24(s0)
    116c:	03043023          	sd	a6,32(s0)
    1170:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1174:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1178:	8622                	mv	a2,s0
    117a:	00000097          	auipc	ra,0x0
    117e:	e04080e7          	jalr	-508(ra) # f7e <vprintf>
}
    1182:	60e2                	ld	ra,24(sp)
    1184:	6442                	ld	s0,16(sp)
    1186:	6161                	addi	sp,sp,80
    1188:	8082                	ret

000000000000118a <printf>:

void
printf(const char *fmt, ...)
{
    118a:	711d                	addi	sp,sp,-96
    118c:	ec06                	sd	ra,24(sp)
    118e:	e822                	sd	s0,16(sp)
    1190:	1000                	addi	s0,sp,32
    1192:	e40c                	sd	a1,8(s0)
    1194:	e810                	sd	a2,16(s0)
    1196:	ec14                	sd	a3,24(s0)
    1198:	f018                	sd	a4,32(s0)
    119a:	f41c                	sd	a5,40(s0)
    119c:	03043823          	sd	a6,48(s0)
    11a0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    11a4:	00840613          	addi	a2,s0,8
    11a8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    11ac:	85aa                	mv	a1,a0
    11ae:	4505                	li	a0,1
    11b0:	00000097          	auipc	ra,0x0
    11b4:	dce080e7          	jalr	-562(ra) # f7e <vprintf>
}
    11b8:	60e2                	ld	ra,24(sp)
    11ba:	6442                	ld	s0,16(sp)
    11bc:	6125                	addi	sp,sp,96
    11be:	8082                	ret

00000000000011c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    11c0:	1141                	addi	sp,sp,-16
    11c2:	e422                	sd	s0,8(sp)
    11c4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    11c6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11ca:	00000797          	auipc	a5,0x0
    11ce:	5267b783          	ld	a5,1318(a5) # 16f0 <freep>
    11d2:	a02d                	j	11fc <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    11d4:	4618                	lw	a4,8(a2)
    11d6:	9f2d                	addw	a4,a4,a1
    11d8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    11dc:	6398                	ld	a4,0(a5)
    11de:	6310                	ld	a2,0(a4)
    11e0:	a83d                	j	121e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    11e2:	ff852703          	lw	a4,-8(a0)
    11e6:	9f31                	addw	a4,a4,a2
    11e8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    11ea:	ff053683          	ld	a3,-16(a0)
    11ee:	a091                	j	1232 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11f0:	6398                	ld	a4,0(a5)
    11f2:	00e7e463          	bltu	a5,a4,11fa <free+0x3a>
    11f6:	00e6ea63          	bltu	a3,a4,120a <free+0x4a>
{
    11fa:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11fc:	fed7fae3          	bgeu	a5,a3,11f0 <free+0x30>
    1200:	6398                	ld	a4,0(a5)
    1202:	00e6e463          	bltu	a3,a4,120a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1206:	fee7eae3          	bltu	a5,a4,11fa <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    120a:	ff852583          	lw	a1,-8(a0)
    120e:	6390                	ld	a2,0(a5)
    1210:	02059813          	slli	a6,a1,0x20
    1214:	01c85713          	srli	a4,a6,0x1c
    1218:	9736                	add	a4,a4,a3
    121a:	fae60de3          	beq	a2,a4,11d4 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    121e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1222:	4790                	lw	a2,8(a5)
    1224:	02061593          	slli	a1,a2,0x20
    1228:	01c5d713          	srli	a4,a1,0x1c
    122c:	973e                	add	a4,a4,a5
    122e:	fae68ae3          	beq	a3,a4,11e2 <free+0x22>
    p->s.ptr = bp->s.ptr;
    1232:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1234:	00000717          	auipc	a4,0x0
    1238:	4af73e23          	sd	a5,1212(a4) # 16f0 <freep>
}
    123c:	6422                	ld	s0,8(sp)
    123e:	0141                	addi	sp,sp,16
    1240:	8082                	ret

0000000000001242 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1242:	7139                	addi	sp,sp,-64
    1244:	fc06                	sd	ra,56(sp)
    1246:	f822                	sd	s0,48(sp)
    1248:	f426                	sd	s1,40(sp)
    124a:	f04a                	sd	s2,32(sp)
    124c:	ec4e                	sd	s3,24(sp)
    124e:	e852                	sd	s4,16(sp)
    1250:	e456                	sd	s5,8(sp)
    1252:	e05a                	sd	s6,0(sp)
    1254:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1256:	02051493          	slli	s1,a0,0x20
    125a:	9081                	srli	s1,s1,0x20
    125c:	04bd                	addi	s1,s1,15
    125e:	8091                	srli	s1,s1,0x4
    1260:	0014899b          	addiw	s3,s1,1
    1264:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1266:	00000517          	auipc	a0,0x0
    126a:	48a53503          	ld	a0,1162(a0) # 16f0 <freep>
    126e:	c515                	beqz	a0,129a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1270:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1272:	4798                	lw	a4,8(a5)
    1274:	02977f63          	bgeu	a4,s1,12b2 <malloc+0x70>
    1278:	8a4e                	mv	s4,s3
    127a:	0009871b          	sext.w	a4,s3
    127e:	6685                	lui	a3,0x1
    1280:	00d77363          	bgeu	a4,a3,1286 <malloc+0x44>
    1284:	6a05                	lui	s4,0x1
    1286:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    128a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    128e:	00000917          	auipc	s2,0x0
    1292:	46290913          	addi	s2,s2,1122 # 16f0 <freep>
  if(p == (char*)-1)
    1296:	5afd                	li	s5,-1
    1298:	a895                	j	130c <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    129a:	00001797          	auipc	a5,0x1
    129e:	84678793          	addi	a5,a5,-1978 # 1ae0 <base>
    12a2:	00000717          	auipc	a4,0x0
    12a6:	44f73723          	sd	a5,1102(a4) # 16f0 <freep>
    12aa:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    12ac:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    12b0:	b7e1                	j	1278 <malloc+0x36>
      if(p->s.size == nunits)
    12b2:	02e48c63          	beq	s1,a4,12ea <malloc+0xa8>
        p->s.size -= nunits;
    12b6:	4137073b          	subw	a4,a4,s3
    12ba:	c798                	sw	a4,8(a5)
        p += p->s.size;
    12bc:	02071693          	slli	a3,a4,0x20
    12c0:	01c6d713          	srli	a4,a3,0x1c
    12c4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    12c6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    12ca:	00000717          	auipc	a4,0x0
    12ce:	42a73323          	sd	a0,1062(a4) # 16f0 <freep>
      return (void*)(p + 1);
    12d2:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    12d6:	70e2                	ld	ra,56(sp)
    12d8:	7442                	ld	s0,48(sp)
    12da:	74a2                	ld	s1,40(sp)
    12dc:	7902                	ld	s2,32(sp)
    12de:	69e2                	ld	s3,24(sp)
    12e0:	6a42                	ld	s4,16(sp)
    12e2:	6aa2                	ld	s5,8(sp)
    12e4:	6b02                	ld	s6,0(sp)
    12e6:	6121                	addi	sp,sp,64
    12e8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    12ea:	6398                	ld	a4,0(a5)
    12ec:	e118                	sd	a4,0(a0)
    12ee:	bff1                	j	12ca <malloc+0x88>
  hp->s.size = nu;
    12f0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    12f4:	0541                	addi	a0,a0,16
    12f6:	00000097          	auipc	ra,0x0
    12fa:	eca080e7          	jalr	-310(ra) # 11c0 <free>
  return freep;
    12fe:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1302:	d971                	beqz	a0,12d6 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1304:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1306:	4798                	lw	a4,8(a5)
    1308:	fa9775e3          	bgeu	a4,s1,12b2 <malloc+0x70>
    if(p == freep)
    130c:	00093703          	ld	a4,0(s2)
    1310:	853e                	mv	a0,a5
    1312:	fef719e3          	bne	a4,a5,1304 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    1316:	8552                	mv	a0,s4
    1318:	00000097          	auipc	ra,0x0
    131c:	b68080e7          	jalr	-1176(ra) # e80 <sbrk>
  if(p == (char*)-1)
    1320:	fd5518e3          	bne	a0,s5,12f0 <malloc+0xae>
        return 0;
    1324:	4501                	li	a0,0
    1326:	bf45                	j	12d6 <malloc+0x94>
