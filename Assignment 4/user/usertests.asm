
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00005097          	auipc	ra,0x5
      14:	7b0080e7          	jalr	1968(ra) # 57c0 <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00005097          	auipc	ra,0x5
      26:	79e080e7          	jalr	1950(ra) # 57c0 <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if(fd >= 0){
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	c7250513          	addi	a0,a0,-910 # 5cb0 <malloc+0xe6>
      46:	00006097          	auipc	ra,0x6
      4a:	acc080e7          	jalr	-1332(ra) # 5b12 <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00005097          	auipc	ra,0x5
      54:	730080e7          	jalr	1840(ra) # 5780 <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	00009797          	auipc	a5,0x9
      5c:	58078793          	addi	a5,a5,1408 # 95d8 <uninit>
      60:	0000c697          	auipc	a3,0xc
      64:	c8868693          	addi	a3,a3,-888 # bce8 <buf>
    if(uninit[i] != '\0'){
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	c5050513          	addi	a0,a0,-944 # 5cd0 <malloc+0x106>
      88:	00006097          	auipc	ra,0x6
      8c:	a8a080e7          	jalr	-1398(ra) # 5b12 <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00005097          	auipc	ra,0x5
      96:	6ee080e7          	jalr	1774(ra) # 5780 <exit>

000000000000009a <opentest>:
{
      9a:	1101                	addi	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	addi	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	c4050513          	addi	a0,a0,-960 # 5ce8 <malloc+0x11e>
      b0:	00005097          	auipc	ra,0x5
      b4:	710080e7          	jalr	1808(ra) # 57c0 <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00005097          	auipc	ra,0x5
      c0:	6ec080e7          	jalr	1772(ra) # 57a8 <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	c4250513          	addi	a0,a0,-958 # 5d08 <malloc+0x13e>
      ce:	00005097          	auipc	ra,0x5
      d2:	6f2080e7          	jalr	1778(ra) # 57c0 <open>
  if(fd >= 0){
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	addi	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	c0a50513          	addi	a0,a0,-1014 # 5cf0 <malloc+0x126>
      ee:	00006097          	auipc	ra,0x6
      f2:	a24080e7          	jalr	-1500(ra) # 5b12 <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00005097          	auipc	ra,0x5
      fc:	688080e7          	jalr	1672(ra) # 5780 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	c1650513          	addi	a0,a0,-1002 # 5d18 <malloc+0x14e>
     10a:	00006097          	auipc	ra,0x6
     10e:	a08080e7          	jalr	-1528(ra) # 5b12 <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00005097          	auipc	ra,0x5
     118:	66c080e7          	jalr	1644(ra) # 5780 <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	c1450513          	addi	a0,a0,-1004 # 5d40 <malloc+0x176>
     134:	00005097          	auipc	ra,0x5
     138:	69c080e7          	jalr	1692(ra) # 57d0 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	c0050513          	addi	a0,a0,-1024 # 5d40 <malloc+0x176>
     148:	00005097          	auipc	ra,0x5
     14c:	678080e7          	jalr	1656(ra) # 57c0 <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	bfc58593          	addi	a1,a1,-1028 # 5d50 <malloc+0x186>
     15c:	00005097          	auipc	ra,0x5
     160:	644080e7          	jalr	1604(ra) # 57a0 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	bd850513          	addi	a0,a0,-1064 # 5d40 <malloc+0x176>
     170:	00005097          	auipc	ra,0x5
     174:	650080e7          	jalr	1616(ra) # 57c0 <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	bdc58593          	addi	a1,a1,-1060 # 5d58 <malloc+0x18e>
     184:	8526                	mv	a0,s1
     186:	00005097          	auipc	ra,0x5
     18a:	61a080e7          	jalr	1562(ra) # 57a0 <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	bac50513          	addi	a0,a0,-1108 # 5d40 <malloc+0x176>
     19c:	00005097          	auipc	ra,0x5
     1a0:	634080e7          	jalr	1588(ra) # 57d0 <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00005097          	auipc	ra,0x5
     1aa:	602080e7          	jalr	1538(ra) # 57a8 <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00005097          	auipc	ra,0x5
     1b4:	5f8080e7          	jalr	1528(ra) # 57a8 <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	addi	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	b9650513          	addi	a0,a0,-1130 # 5d60 <malloc+0x196>
     1d2:	00006097          	auipc	ra,0x6
     1d6:	940080e7          	jalr	-1728(ra) # 5b12 <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00005097          	auipc	ra,0x5
     1e0:	5a4080e7          	jalr	1444(ra) # 5780 <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	addi	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1f0:	06100793          	li	a5,97
     1f4:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1f8:	fc040d23          	sb	zero,-38(s0)
     1fc:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     200:	06400913          	li	s2,100
    name[1] = '0' + i;
     204:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     208:	20200593          	li	a1,514
     20c:	fd840513          	addi	a0,s0,-40
     210:	00005097          	auipc	ra,0x5
     214:	5b0080e7          	jalr	1456(ra) # 57c0 <open>
    close(fd);
     218:	00005097          	auipc	ra,0x5
     21c:	590080e7          	jalr	1424(ra) # 57a8 <close>
  for(i = 0; i < N; i++){
     220:	2485                	addiw	s1,s1,1
     222:	0ff4f493          	zext.b	s1,s1
     226:	fd249fe3          	bne	s1,s2,204 <createtest+0x20>
  name[0] = 'a';
     22a:	06100793          	li	a5,97
     22e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     232:	fc040d23          	sb	zero,-38(s0)
     236:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     23a:	06400913          	li	s2,100
    name[1] = '0' + i;
     23e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     242:	fd840513          	addi	a0,s0,-40
     246:	00005097          	auipc	ra,0x5
     24a:	58a080e7          	jalr	1418(ra) # 57d0 <unlink>
  for(i = 0; i < N; i++){
     24e:	2485                	addiw	s1,s1,1
     250:	0ff4f493          	zext.b	s1,s1
     254:	ff2495e3          	bne	s1,s2,23e <createtest+0x5a>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	6145                	addi	sp,sp,48
     262:	8082                	ret

0000000000000264 <bigwrite>:
{
     264:	715d                	addi	sp,sp,-80
     266:	e486                	sd	ra,72(sp)
     268:	e0a2                	sd	s0,64(sp)
     26a:	fc26                	sd	s1,56(sp)
     26c:	f84a                	sd	s2,48(sp)
     26e:	f44e                	sd	s3,40(sp)
     270:	f052                	sd	s4,32(sp)
     272:	ec56                	sd	s5,24(sp)
     274:	e85a                	sd	s6,16(sp)
     276:	e45e                	sd	s7,8(sp)
     278:	0880                	addi	s0,sp,80
     27a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     27c:	00006517          	auipc	a0,0x6
     280:	b0c50513          	addi	a0,a0,-1268 # 5d88 <malloc+0x1be>
     284:	00005097          	auipc	ra,0x5
     288:	54c080e7          	jalr	1356(ra) # 57d0 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	af8a8a93          	addi	s5,s5,-1288 # 5d88 <malloc+0x1be>
      int cc = write(fd, buf, sz);
     298:	0000ca17          	auipc	s4,0xc
     29c:	a50a0a13          	addi	s4,s4,-1456 # bce8 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	addi	s6,s6,457 # 31c9 <dirtest+0x97>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00005097          	auipc	ra,0x5
     2b0:	514080e7          	jalr	1300(ra) # 57c0 <open>
     2b4:	892a                	mv	s2,a0
    if(fd < 0){
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00005097          	auipc	ra,0x5
     2c2:	4e2080e7          	jalr	1250(ra) # 57a0 <write>
     2c6:	89aa                	mv	s3,a0
      if(cc != sz){
     2c8:	06a49263          	bne	s1,a0,32c <bigwrite+0xc8>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00005097          	auipc	ra,0x5
     2d6:	4ce080e7          	jalr	1230(ra) # 57a0 <write>
      if(cc != sz){
     2da:	04951a63          	bne	a0,s1,32e <bigwrite+0xca>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00005097          	auipc	ra,0x5
     2e4:	4c8080e7          	jalr	1224(ra) # 57a8 <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00005097          	auipc	ra,0x5
     2ee:	4e6080e7          	jalr	1254(ra) # 57d0 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2f2:	1d74849b          	addiw	s1,s1,471
     2f6:	fb6498e3          	bne	s1,s6,2a6 <bigwrite+0x42>
}
     2fa:	60a6                	ld	ra,72(sp)
     2fc:	6406                	ld	s0,64(sp)
     2fe:	74e2                	ld	s1,56(sp)
     300:	7942                	ld	s2,48(sp)
     302:	79a2                	ld	s3,40(sp)
     304:	7a02                	ld	s4,32(sp)
     306:	6ae2                	ld	s5,24(sp)
     308:	6b42                	ld	s6,16(sp)
     30a:	6ba2                	ld	s7,8(sp)
     30c:	6161                	addi	sp,sp,80
     30e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     310:	85de                	mv	a1,s7
     312:	00006517          	auipc	a0,0x6
     316:	a8650513          	addi	a0,a0,-1402 # 5d98 <malloc+0x1ce>
     31a:	00005097          	auipc	ra,0x5
     31e:	7f8080e7          	jalr	2040(ra) # 5b12 <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00005097          	auipc	ra,0x5
     328:	45c080e7          	jalr	1116(ra) # 5780 <exit>
      if(cc != sz){
     32c:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     32e:	86aa                	mv	a3,a0
     330:	864e                	mv	a2,s3
     332:	85de                	mv	a1,s7
     334:	00006517          	auipc	a0,0x6
     338:	a8450513          	addi	a0,a0,-1404 # 5db8 <malloc+0x1ee>
     33c:	00005097          	auipc	ra,0x5
     340:	7d6080e7          	jalr	2006(ra) # 5b12 <printf>
        exit(1);
     344:	4505                	li	a0,1
     346:	00005097          	auipc	ra,0x5
     34a:	43a080e7          	jalr	1082(ra) # 5780 <exit>

000000000000034e <copyin>:
{
     34e:	715d                	addi	sp,sp,-80
     350:	e486                	sd	ra,72(sp)
     352:	e0a2                	sd	s0,64(sp)
     354:	fc26                	sd	s1,56(sp)
     356:	f84a                	sd	s2,48(sp)
     358:	f44e                	sd	s3,40(sp)
     35a:	f052                	sd	s4,32(sp)
     35c:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     35e:	4785                	li	a5,1
     360:	07fe                	slli	a5,a5,0x1f
     362:	fcf43023          	sd	a5,-64(s0)
     366:	57fd                	li	a5,-1
     368:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     36c:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     370:	00006a17          	auipc	s4,0x6
     374:	a60a0a13          	addi	s4,s4,-1440 # 5dd0 <malloc+0x206>
    uint64 addr = addrs[ai];
     378:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     37c:	20100593          	li	a1,513
     380:	8552                	mv	a0,s4
     382:	00005097          	auipc	ra,0x5
     386:	43e080e7          	jalr	1086(ra) # 57c0 <open>
     38a:	84aa                	mv	s1,a0
    if(fd < 0){
     38c:	08054863          	bltz	a0,41c <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     390:	6609                	lui	a2,0x2
     392:	85ce                	mv	a1,s3
     394:	00005097          	auipc	ra,0x5
     398:	40c080e7          	jalr	1036(ra) # 57a0 <write>
    if(n >= 0){
     39c:	08055d63          	bgez	a0,436 <copyin+0xe8>
    close(fd);
     3a0:	8526                	mv	a0,s1
     3a2:	00005097          	auipc	ra,0x5
     3a6:	406080e7          	jalr	1030(ra) # 57a8 <close>
    unlink("copyin1");
     3aa:	8552                	mv	a0,s4
     3ac:	00005097          	auipc	ra,0x5
     3b0:	424080e7          	jalr	1060(ra) # 57d0 <unlink>
    n = write(1, (char*)addr, 8192);
     3b4:	6609                	lui	a2,0x2
     3b6:	85ce                	mv	a1,s3
     3b8:	4505                	li	a0,1
     3ba:	00005097          	auipc	ra,0x5
     3be:	3e6080e7          	jalr	998(ra) # 57a0 <write>
    if(n > 0){
     3c2:	08a04963          	bgtz	a0,454 <copyin+0x106>
    if(pipe(fds) < 0){
     3c6:	fb840513          	addi	a0,s0,-72
     3ca:	00005097          	auipc	ra,0x5
     3ce:	3c6080e7          	jalr	966(ra) # 5790 <pipe>
     3d2:	0a054063          	bltz	a0,472 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     3d6:	6609                	lui	a2,0x2
     3d8:	85ce                	mv	a1,s3
     3da:	fbc42503          	lw	a0,-68(s0)
     3de:	00005097          	auipc	ra,0x5
     3e2:	3c2080e7          	jalr	962(ra) # 57a0 <write>
    if(n > 0){
     3e6:	0aa04363          	bgtz	a0,48c <copyin+0x13e>
    close(fds[0]);
     3ea:	fb842503          	lw	a0,-72(s0)
     3ee:	00005097          	auipc	ra,0x5
     3f2:	3ba080e7          	jalr	954(ra) # 57a8 <close>
    close(fds[1]);
     3f6:	fbc42503          	lw	a0,-68(s0)
     3fa:	00005097          	auipc	ra,0x5
     3fe:	3ae080e7          	jalr	942(ra) # 57a8 <close>
  for(int ai = 0; ai < 2; ai++){
     402:	0921                	addi	s2,s2,8
     404:	fd040793          	addi	a5,s0,-48
     408:	f6f918e3          	bne	s2,a5,378 <copyin+0x2a>
}
     40c:	60a6                	ld	ra,72(sp)
     40e:	6406                	ld	s0,64(sp)
     410:	74e2                	ld	s1,56(sp)
     412:	7942                	ld	s2,48(sp)
     414:	79a2                	ld	s3,40(sp)
     416:	7a02                	ld	s4,32(sp)
     418:	6161                	addi	sp,sp,80
     41a:	8082                	ret
      printf("open(copyin1) failed\n");
     41c:	00006517          	auipc	a0,0x6
     420:	9bc50513          	addi	a0,a0,-1604 # 5dd8 <malloc+0x20e>
     424:	00005097          	auipc	ra,0x5
     428:	6ee080e7          	jalr	1774(ra) # 5b12 <printf>
      exit(1);
     42c:	4505                	li	a0,1
     42e:	00005097          	auipc	ra,0x5
     432:	352080e7          	jalr	850(ra) # 5780 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     436:	862a                	mv	a2,a0
     438:	85ce                	mv	a1,s3
     43a:	00006517          	auipc	a0,0x6
     43e:	9b650513          	addi	a0,a0,-1610 # 5df0 <malloc+0x226>
     442:	00005097          	auipc	ra,0x5
     446:	6d0080e7          	jalr	1744(ra) # 5b12 <printf>
      exit(1);
     44a:	4505                	li	a0,1
     44c:	00005097          	auipc	ra,0x5
     450:	334080e7          	jalr	820(ra) # 5780 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     454:	862a                	mv	a2,a0
     456:	85ce                	mv	a1,s3
     458:	00006517          	auipc	a0,0x6
     45c:	9c850513          	addi	a0,a0,-1592 # 5e20 <malloc+0x256>
     460:	00005097          	auipc	ra,0x5
     464:	6b2080e7          	jalr	1714(ra) # 5b12 <printf>
      exit(1);
     468:	4505                	li	a0,1
     46a:	00005097          	auipc	ra,0x5
     46e:	316080e7          	jalr	790(ra) # 5780 <exit>
      printf("pipe() failed\n");
     472:	00006517          	auipc	a0,0x6
     476:	9de50513          	addi	a0,a0,-1570 # 5e50 <malloc+0x286>
     47a:	00005097          	auipc	ra,0x5
     47e:	698080e7          	jalr	1688(ra) # 5b12 <printf>
      exit(1);
     482:	4505                	li	a0,1
     484:	00005097          	auipc	ra,0x5
     488:	2fc080e7          	jalr	764(ra) # 5780 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     48c:	862a                	mv	a2,a0
     48e:	85ce                	mv	a1,s3
     490:	00006517          	auipc	a0,0x6
     494:	9d050513          	addi	a0,a0,-1584 # 5e60 <malloc+0x296>
     498:	00005097          	auipc	ra,0x5
     49c:	67a080e7          	jalr	1658(ra) # 5b12 <printf>
      exit(1);
     4a0:	4505                	li	a0,1
     4a2:	00005097          	auipc	ra,0x5
     4a6:	2de080e7          	jalr	734(ra) # 5780 <exit>

00000000000004aa <copyout>:
{
     4aa:	711d                	addi	sp,sp,-96
     4ac:	ec86                	sd	ra,88(sp)
     4ae:	e8a2                	sd	s0,80(sp)
     4b0:	e4a6                	sd	s1,72(sp)
     4b2:	e0ca                	sd	s2,64(sp)
     4b4:	fc4e                	sd	s3,56(sp)
     4b6:	f852                	sd	s4,48(sp)
     4b8:	f456                	sd	s5,40(sp)
     4ba:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     4bc:	4785                	li	a5,1
     4be:	07fe                	slli	a5,a5,0x1f
     4c0:	faf43823          	sd	a5,-80(s0)
     4c4:	57fd                	li	a5,-1
     4c6:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     4ca:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     4ce:	00006a17          	auipc	s4,0x6
     4d2:	9c2a0a13          	addi	s4,s4,-1598 # 5e90 <malloc+0x2c6>
    n = write(fds[1], "x", 1);
     4d6:	00006a97          	auipc	s5,0x6
     4da:	882a8a93          	addi	s5,s5,-1918 # 5d58 <malloc+0x18e>
    uint64 addr = addrs[ai];
     4de:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     4e2:	4581                	li	a1,0
     4e4:	8552                	mv	a0,s4
     4e6:	00005097          	auipc	ra,0x5
     4ea:	2da080e7          	jalr	730(ra) # 57c0 <open>
     4ee:	84aa                	mv	s1,a0
    if(fd < 0){
     4f0:	08054663          	bltz	a0,57c <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     4f4:	6609                	lui	a2,0x2
     4f6:	85ce                	mv	a1,s3
     4f8:	00005097          	auipc	ra,0x5
     4fc:	2a0080e7          	jalr	672(ra) # 5798 <read>
    if(n > 0){
     500:	08a04b63          	bgtz	a0,596 <copyout+0xec>
    close(fd);
     504:	8526                	mv	a0,s1
     506:	00005097          	auipc	ra,0x5
     50a:	2a2080e7          	jalr	674(ra) # 57a8 <close>
    if(pipe(fds) < 0){
     50e:	fa840513          	addi	a0,s0,-88
     512:	00005097          	auipc	ra,0x5
     516:	27e080e7          	jalr	638(ra) # 5790 <pipe>
     51a:	08054d63          	bltz	a0,5b4 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     51e:	4605                	li	a2,1
     520:	85d6                	mv	a1,s5
     522:	fac42503          	lw	a0,-84(s0)
     526:	00005097          	auipc	ra,0x5
     52a:	27a080e7          	jalr	634(ra) # 57a0 <write>
    if(n != 1){
     52e:	4785                	li	a5,1
     530:	08f51f63          	bne	a0,a5,5ce <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     534:	6609                	lui	a2,0x2
     536:	85ce                	mv	a1,s3
     538:	fa842503          	lw	a0,-88(s0)
     53c:	00005097          	auipc	ra,0x5
     540:	25c080e7          	jalr	604(ra) # 5798 <read>
    if(n > 0){
     544:	0aa04263          	bgtz	a0,5e8 <copyout+0x13e>
    close(fds[0]);
     548:	fa842503          	lw	a0,-88(s0)
     54c:	00005097          	auipc	ra,0x5
     550:	25c080e7          	jalr	604(ra) # 57a8 <close>
    close(fds[1]);
     554:	fac42503          	lw	a0,-84(s0)
     558:	00005097          	auipc	ra,0x5
     55c:	250080e7          	jalr	592(ra) # 57a8 <close>
  for(int ai = 0; ai < 2; ai++){
     560:	0921                	addi	s2,s2,8
     562:	fc040793          	addi	a5,s0,-64
     566:	f6f91ce3          	bne	s2,a5,4de <copyout+0x34>
}
     56a:	60e6                	ld	ra,88(sp)
     56c:	6446                	ld	s0,80(sp)
     56e:	64a6                	ld	s1,72(sp)
     570:	6906                	ld	s2,64(sp)
     572:	79e2                	ld	s3,56(sp)
     574:	7a42                	ld	s4,48(sp)
     576:	7aa2                	ld	s5,40(sp)
     578:	6125                	addi	sp,sp,96
     57a:	8082                	ret
      printf("open(README) failed\n");
     57c:	00006517          	auipc	a0,0x6
     580:	91c50513          	addi	a0,a0,-1764 # 5e98 <malloc+0x2ce>
     584:	00005097          	auipc	ra,0x5
     588:	58e080e7          	jalr	1422(ra) # 5b12 <printf>
      exit(1);
     58c:	4505                	li	a0,1
     58e:	00005097          	auipc	ra,0x5
     592:	1f2080e7          	jalr	498(ra) # 5780 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     596:	862a                	mv	a2,a0
     598:	85ce                	mv	a1,s3
     59a:	00006517          	auipc	a0,0x6
     59e:	91650513          	addi	a0,a0,-1770 # 5eb0 <malloc+0x2e6>
     5a2:	00005097          	auipc	ra,0x5
     5a6:	570080e7          	jalr	1392(ra) # 5b12 <printf>
      exit(1);
     5aa:	4505                	li	a0,1
     5ac:	00005097          	auipc	ra,0x5
     5b0:	1d4080e7          	jalr	468(ra) # 5780 <exit>
      printf("pipe() failed\n");
     5b4:	00006517          	auipc	a0,0x6
     5b8:	89c50513          	addi	a0,a0,-1892 # 5e50 <malloc+0x286>
     5bc:	00005097          	auipc	ra,0x5
     5c0:	556080e7          	jalr	1366(ra) # 5b12 <printf>
      exit(1);
     5c4:	4505                	li	a0,1
     5c6:	00005097          	auipc	ra,0x5
     5ca:	1ba080e7          	jalr	442(ra) # 5780 <exit>
      printf("pipe write failed\n");
     5ce:	00006517          	auipc	a0,0x6
     5d2:	91250513          	addi	a0,a0,-1774 # 5ee0 <malloc+0x316>
     5d6:	00005097          	auipc	ra,0x5
     5da:	53c080e7          	jalr	1340(ra) # 5b12 <printf>
      exit(1);
     5de:	4505                	li	a0,1
     5e0:	00005097          	auipc	ra,0x5
     5e4:	1a0080e7          	jalr	416(ra) # 5780 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5e8:	862a                	mv	a2,a0
     5ea:	85ce                	mv	a1,s3
     5ec:	00006517          	auipc	a0,0x6
     5f0:	90c50513          	addi	a0,a0,-1780 # 5ef8 <malloc+0x32e>
     5f4:	00005097          	auipc	ra,0x5
     5f8:	51e080e7          	jalr	1310(ra) # 5b12 <printf>
      exit(1);
     5fc:	4505                	li	a0,1
     5fe:	00005097          	auipc	ra,0x5
     602:	182080e7          	jalr	386(ra) # 5780 <exit>

0000000000000606 <truncate1>:
{
     606:	711d                	addi	sp,sp,-96
     608:	ec86                	sd	ra,88(sp)
     60a:	e8a2                	sd	s0,80(sp)
     60c:	e4a6                	sd	s1,72(sp)
     60e:	e0ca                	sd	s2,64(sp)
     610:	fc4e                	sd	s3,56(sp)
     612:	f852                	sd	s4,48(sp)
     614:	f456                	sd	s5,40(sp)
     616:	1080                	addi	s0,sp,96
     618:	8aaa                	mv	s5,a0
  unlink("truncfile");
     61a:	00005517          	auipc	a0,0x5
     61e:	72650513          	addi	a0,a0,1830 # 5d40 <malloc+0x176>
     622:	00005097          	auipc	ra,0x5
     626:	1ae080e7          	jalr	430(ra) # 57d0 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     62a:	60100593          	li	a1,1537
     62e:	00005517          	auipc	a0,0x5
     632:	71250513          	addi	a0,a0,1810 # 5d40 <malloc+0x176>
     636:	00005097          	auipc	ra,0x5
     63a:	18a080e7          	jalr	394(ra) # 57c0 <open>
     63e:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     640:	4611                	li	a2,4
     642:	00005597          	auipc	a1,0x5
     646:	70e58593          	addi	a1,a1,1806 # 5d50 <malloc+0x186>
     64a:	00005097          	auipc	ra,0x5
     64e:	156080e7          	jalr	342(ra) # 57a0 <write>
  close(fd1);
     652:	8526                	mv	a0,s1
     654:	00005097          	auipc	ra,0x5
     658:	154080e7          	jalr	340(ra) # 57a8 <close>
  int fd2 = open("truncfile", O_RDONLY);
     65c:	4581                	li	a1,0
     65e:	00005517          	auipc	a0,0x5
     662:	6e250513          	addi	a0,a0,1762 # 5d40 <malloc+0x176>
     666:	00005097          	auipc	ra,0x5
     66a:	15a080e7          	jalr	346(ra) # 57c0 <open>
     66e:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     670:	02000613          	li	a2,32
     674:	fa040593          	addi	a1,s0,-96
     678:	00005097          	auipc	ra,0x5
     67c:	120080e7          	jalr	288(ra) # 5798 <read>
  if(n != 4){
     680:	4791                	li	a5,4
     682:	0cf51e63          	bne	a0,a5,75e <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     686:	40100593          	li	a1,1025
     68a:	00005517          	auipc	a0,0x5
     68e:	6b650513          	addi	a0,a0,1718 # 5d40 <malloc+0x176>
     692:	00005097          	auipc	ra,0x5
     696:	12e080e7          	jalr	302(ra) # 57c0 <open>
     69a:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     69c:	4581                	li	a1,0
     69e:	00005517          	auipc	a0,0x5
     6a2:	6a250513          	addi	a0,a0,1698 # 5d40 <malloc+0x176>
     6a6:	00005097          	auipc	ra,0x5
     6aa:	11a080e7          	jalr	282(ra) # 57c0 <open>
     6ae:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     6b0:	02000613          	li	a2,32
     6b4:	fa040593          	addi	a1,s0,-96
     6b8:	00005097          	auipc	ra,0x5
     6bc:	0e0080e7          	jalr	224(ra) # 5798 <read>
     6c0:	8a2a                	mv	s4,a0
  if(n != 0){
     6c2:	ed4d                	bnez	a0,77c <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     6c4:	02000613          	li	a2,32
     6c8:	fa040593          	addi	a1,s0,-96
     6cc:	8526                	mv	a0,s1
     6ce:	00005097          	auipc	ra,0x5
     6d2:	0ca080e7          	jalr	202(ra) # 5798 <read>
     6d6:	8a2a                	mv	s4,a0
  if(n != 0){
     6d8:	e971                	bnez	a0,7ac <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     6da:	4619                	li	a2,6
     6dc:	00006597          	auipc	a1,0x6
     6e0:	8ac58593          	addi	a1,a1,-1876 # 5f88 <malloc+0x3be>
     6e4:	854e                	mv	a0,s3
     6e6:	00005097          	auipc	ra,0x5
     6ea:	0ba080e7          	jalr	186(ra) # 57a0 <write>
  n = read(fd3, buf, sizeof(buf));
     6ee:	02000613          	li	a2,32
     6f2:	fa040593          	addi	a1,s0,-96
     6f6:	854a                	mv	a0,s2
     6f8:	00005097          	auipc	ra,0x5
     6fc:	0a0080e7          	jalr	160(ra) # 5798 <read>
  if(n != 6){
     700:	4799                	li	a5,6
     702:	0cf51d63          	bne	a0,a5,7dc <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     706:	02000613          	li	a2,32
     70a:	fa040593          	addi	a1,s0,-96
     70e:	8526                	mv	a0,s1
     710:	00005097          	auipc	ra,0x5
     714:	088080e7          	jalr	136(ra) # 5798 <read>
  if(n != 2){
     718:	4789                	li	a5,2
     71a:	0ef51063          	bne	a0,a5,7fa <truncate1+0x1f4>
  unlink("truncfile");
     71e:	00005517          	auipc	a0,0x5
     722:	62250513          	addi	a0,a0,1570 # 5d40 <malloc+0x176>
     726:	00005097          	auipc	ra,0x5
     72a:	0aa080e7          	jalr	170(ra) # 57d0 <unlink>
  close(fd1);
     72e:	854e                	mv	a0,s3
     730:	00005097          	auipc	ra,0x5
     734:	078080e7          	jalr	120(ra) # 57a8 <close>
  close(fd2);
     738:	8526                	mv	a0,s1
     73a:	00005097          	auipc	ra,0x5
     73e:	06e080e7          	jalr	110(ra) # 57a8 <close>
  close(fd3);
     742:	854a                	mv	a0,s2
     744:	00005097          	auipc	ra,0x5
     748:	064080e7          	jalr	100(ra) # 57a8 <close>
}
     74c:	60e6                	ld	ra,88(sp)
     74e:	6446                	ld	s0,80(sp)
     750:	64a6                	ld	s1,72(sp)
     752:	6906                	ld	s2,64(sp)
     754:	79e2                	ld	s3,56(sp)
     756:	7a42                	ld	s4,48(sp)
     758:	7aa2                	ld	s5,40(sp)
     75a:	6125                	addi	sp,sp,96
     75c:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     75e:	862a                	mv	a2,a0
     760:	85d6                	mv	a1,s5
     762:	00005517          	auipc	a0,0x5
     766:	7c650513          	addi	a0,a0,1990 # 5f28 <malloc+0x35e>
     76a:	00005097          	auipc	ra,0x5
     76e:	3a8080e7          	jalr	936(ra) # 5b12 <printf>
    exit(1);
     772:	4505                	li	a0,1
     774:	00005097          	auipc	ra,0x5
     778:	00c080e7          	jalr	12(ra) # 5780 <exit>
    printf("aaa fd3=%d\n", fd3);
     77c:	85ca                	mv	a1,s2
     77e:	00005517          	auipc	a0,0x5
     782:	7ca50513          	addi	a0,a0,1994 # 5f48 <malloc+0x37e>
     786:	00005097          	auipc	ra,0x5
     78a:	38c080e7          	jalr	908(ra) # 5b12 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     78e:	8652                	mv	a2,s4
     790:	85d6                	mv	a1,s5
     792:	00005517          	auipc	a0,0x5
     796:	7c650513          	addi	a0,a0,1990 # 5f58 <malloc+0x38e>
     79a:	00005097          	auipc	ra,0x5
     79e:	378080e7          	jalr	888(ra) # 5b12 <printf>
    exit(1);
     7a2:	4505                	li	a0,1
     7a4:	00005097          	auipc	ra,0x5
     7a8:	fdc080e7          	jalr	-36(ra) # 5780 <exit>
    printf("bbb fd2=%d\n", fd2);
     7ac:	85a6                	mv	a1,s1
     7ae:	00005517          	auipc	a0,0x5
     7b2:	7ca50513          	addi	a0,a0,1994 # 5f78 <malloc+0x3ae>
     7b6:	00005097          	auipc	ra,0x5
     7ba:	35c080e7          	jalr	860(ra) # 5b12 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7be:	8652                	mv	a2,s4
     7c0:	85d6                	mv	a1,s5
     7c2:	00005517          	auipc	a0,0x5
     7c6:	79650513          	addi	a0,a0,1942 # 5f58 <malloc+0x38e>
     7ca:	00005097          	auipc	ra,0x5
     7ce:	348080e7          	jalr	840(ra) # 5b12 <printf>
    exit(1);
     7d2:	4505                	li	a0,1
     7d4:	00005097          	auipc	ra,0x5
     7d8:	fac080e7          	jalr	-84(ra) # 5780 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     7dc:	862a                	mv	a2,a0
     7de:	85d6                	mv	a1,s5
     7e0:	00005517          	auipc	a0,0x5
     7e4:	7b050513          	addi	a0,a0,1968 # 5f90 <malloc+0x3c6>
     7e8:	00005097          	auipc	ra,0x5
     7ec:	32a080e7          	jalr	810(ra) # 5b12 <printf>
    exit(1);
     7f0:	4505                	li	a0,1
     7f2:	00005097          	auipc	ra,0x5
     7f6:	f8e080e7          	jalr	-114(ra) # 5780 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     7fa:	862a                	mv	a2,a0
     7fc:	85d6                	mv	a1,s5
     7fe:	00005517          	auipc	a0,0x5
     802:	7b250513          	addi	a0,a0,1970 # 5fb0 <malloc+0x3e6>
     806:	00005097          	auipc	ra,0x5
     80a:	30c080e7          	jalr	780(ra) # 5b12 <printf>
    exit(1);
     80e:	4505                	li	a0,1
     810:	00005097          	auipc	ra,0x5
     814:	f70080e7          	jalr	-144(ra) # 5780 <exit>

0000000000000818 <writetest>:
{
     818:	7139                	addi	sp,sp,-64
     81a:	fc06                	sd	ra,56(sp)
     81c:	f822                	sd	s0,48(sp)
     81e:	f426                	sd	s1,40(sp)
     820:	f04a                	sd	s2,32(sp)
     822:	ec4e                	sd	s3,24(sp)
     824:	e852                	sd	s4,16(sp)
     826:	e456                	sd	s5,8(sp)
     828:	e05a                	sd	s6,0(sp)
     82a:	0080                	addi	s0,sp,64
     82c:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     82e:	20200593          	li	a1,514
     832:	00005517          	auipc	a0,0x5
     836:	79e50513          	addi	a0,a0,1950 # 5fd0 <malloc+0x406>
     83a:	00005097          	auipc	ra,0x5
     83e:	f86080e7          	jalr	-122(ra) # 57c0 <open>
  if(fd < 0){
     842:	0a054d63          	bltz	a0,8fc <writetest+0xe4>
     846:	892a                	mv	s2,a0
     848:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     84a:	00005997          	auipc	s3,0x5
     84e:	7ae98993          	addi	s3,s3,1966 # 5ff8 <malloc+0x42e>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     852:	00005a97          	auipc	s5,0x5
     856:	7dea8a93          	addi	s5,s5,2014 # 6030 <malloc+0x466>
  for(i = 0; i < N; i++){
     85a:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     85e:	4629                	li	a2,10
     860:	85ce                	mv	a1,s3
     862:	854a                	mv	a0,s2
     864:	00005097          	auipc	ra,0x5
     868:	f3c080e7          	jalr	-196(ra) # 57a0 <write>
     86c:	47a9                	li	a5,10
     86e:	0af51563          	bne	a0,a5,918 <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     872:	4629                	li	a2,10
     874:	85d6                	mv	a1,s5
     876:	854a                	mv	a0,s2
     878:	00005097          	auipc	ra,0x5
     87c:	f28080e7          	jalr	-216(ra) # 57a0 <write>
     880:	47a9                	li	a5,10
     882:	0af51a63          	bne	a0,a5,936 <writetest+0x11e>
  for(i = 0; i < N; i++){
     886:	2485                	addiw	s1,s1,1
     888:	fd449be3          	bne	s1,s4,85e <writetest+0x46>
  close(fd);
     88c:	854a                	mv	a0,s2
     88e:	00005097          	auipc	ra,0x5
     892:	f1a080e7          	jalr	-230(ra) # 57a8 <close>
  fd = open("small", O_RDONLY);
     896:	4581                	li	a1,0
     898:	00005517          	auipc	a0,0x5
     89c:	73850513          	addi	a0,a0,1848 # 5fd0 <malloc+0x406>
     8a0:	00005097          	auipc	ra,0x5
     8a4:	f20080e7          	jalr	-224(ra) # 57c0 <open>
     8a8:	84aa                	mv	s1,a0
  if(fd < 0){
     8aa:	0a054563          	bltz	a0,954 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     8ae:	7d000613          	li	a2,2000
     8b2:	0000b597          	auipc	a1,0xb
     8b6:	43658593          	addi	a1,a1,1078 # bce8 <buf>
     8ba:	00005097          	auipc	ra,0x5
     8be:	ede080e7          	jalr	-290(ra) # 5798 <read>
  if(i != N*SZ*2){
     8c2:	7d000793          	li	a5,2000
     8c6:	0af51563          	bne	a0,a5,970 <writetest+0x158>
  close(fd);
     8ca:	8526                	mv	a0,s1
     8cc:	00005097          	auipc	ra,0x5
     8d0:	edc080e7          	jalr	-292(ra) # 57a8 <close>
  if(unlink("small") < 0){
     8d4:	00005517          	auipc	a0,0x5
     8d8:	6fc50513          	addi	a0,a0,1788 # 5fd0 <malloc+0x406>
     8dc:	00005097          	auipc	ra,0x5
     8e0:	ef4080e7          	jalr	-268(ra) # 57d0 <unlink>
     8e4:	0a054463          	bltz	a0,98c <writetest+0x174>
}
     8e8:	70e2                	ld	ra,56(sp)
     8ea:	7442                	ld	s0,48(sp)
     8ec:	74a2                	ld	s1,40(sp)
     8ee:	7902                	ld	s2,32(sp)
     8f0:	69e2                	ld	s3,24(sp)
     8f2:	6a42                	ld	s4,16(sp)
     8f4:	6aa2                	ld	s5,8(sp)
     8f6:	6b02                	ld	s6,0(sp)
     8f8:	6121                	addi	sp,sp,64
     8fa:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     8fc:	85da                	mv	a1,s6
     8fe:	00005517          	auipc	a0,0x5
     902:	6da50513          	addi	a0,a0,1754 # 5fd8 <malloc+0x40e>
     906:	00005097          	auipc	ra,0x5
     90a:	20c080e7          	jalr	524(ra) # 5b12 <printf>
    exit(1);
     90e:	4505                	li	a0,1
     910:	00005097          	auipc	ra,0x5
     914:	e70080e7          	jalr	-400(ra) # 5780 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     918:	8626                	mv	a2,s1
     91a:	85da                	mv	a1,s6
     91c:	00005517          	auipc	a0,0x5
     920:	6ec50513          	addi	a0,a0,1772 # 6008 <malloc+0x43e>
     924:	00005097          	auipc	ra,0x5
     928:	1ee080e7          	jalr	494(ra) # 5b12 <printf>
      exit(1);
     92c:	4505                	li	a0,1
     92e:	00005097          	auipc	ra,0x5
     932:	e52080e7          	jalr	-430(ra) # 5780 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     936:	8626                	mv	a2,s1
     938:	85da                	mv	a1,s6
     93a:	00005517          	auipc	a0,0x5
     93e:	70650513          	addi	a0,a0,1798 # 6040 <malloc+0x476>
     942:	00005097          	auipc	ra,0x5
     946:	1d0080e7          	jalr	464(ra) # 5b12 <printf>
      exit(1);
     94a:	4505                	li	a0,1
     94c:	00005097          	auipc	ra,0x5
     950:	e34080e7          	jalr	-460(ra) # 5780 <exit>
    printf("%s: error: open small failed!\n", s);
     954:	85da                	mv	a1,s6
     956:	00005517          	auipc	a0,0x5
     95a:	71250513          	addi	a0,a0,1810 # 6068 <malloc+0x49e>
     95e:	00005097          	auipc	ra,0x5
     962:	1b4080e7          	jalr	436(ra) # 5b12 <printf>
    exit(1);
     966:	4505                	li	a0,1
     968:	00005097          	auipc	ra,0x5
     96c:	e18080e7          	jalr	-488(ra) # 5780 <exit>
    printf("%s: read failed\n", s);
     970:	85da                	mv	a1,s6
     972:	00005517          	auipc	a0,0x5
     976:	71650513          	addi	a0,a0,1814 # 6088 <malloc+0x4be>
     97a:	00005097          	auipc	ra,0x5
     97e:	198080e7          	jalr	408(ra) # 5b12 <printf>
    exit(1);
     982:	4505                	li	a0,1
     984:	00005097          	auipc	ra,0x5
     988:	dfc080e7          	jalr	-516(ra) # 5780 <exit>
    printf("%s: unlink small failed\n", s);
     98c:	85da                	mv	a1,s6
     98e:	00005517          	auipc	a0,0x5
     992:	71250513          	addi	a0,a0,1810 # 60a0 <malloc+0x4d6>
     996:	00005097          	auipc	ra,0x5
     99a:	17c080e7          	jalr	380(ra) # 5b12 <printf>
    exit(1);
     99e:	4505                	li	a0,1
     9a0:	00005097          	auipc	ra,0x5
     9a4:	de0080e7          	jalr	-544(ra) # 5780 <exit>

00000000000009a8 <writebig>:
{
     9a8:	7139                	addi	sp,sp,-64
     9aa:	fc06                	sd	ra,56(sp)
     9ac:	f822                	sd	s0,48(sp)
     9ae:	f426                	sd	s1,40(sp)
     9b0:	f04a                	sd	s2,32(sp)
     9b2:	ec4e                	sd	s3,24(sp)
     9b4:	e852                	sd	s4,16(sp)
     9b6:	e456                	sd	s5,8(sp)
     9b8:	0080                	addi	s0,sp,64
     9ba:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     9bc:	20200593          	li	a1,514
     9c0:	00005517          	auipc	a0,0x5
     9c4:	70050513          	addi	a0,a0,1792 # 60c0 <malloc+0x4f6>
     9c8:	00005097          	auipc	ra,0x5
     9cc:	df8080e7          	jalr	-520(ra) # 57c0 <open>
     9d0:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     9d2:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9d4:	0000b917          	auipc	s2,0xb
     9d8:	31490913          	addi	s2,s2,788 # bce8 <buf>
  for(i = 0; i < MAXFILE; i++){
     9dc:	10c00a13          	li	s4,268
  if(fd < 0){
     9e0:	06054c63          	bltz	a0,a58 <writebig+0xb0>
    ((int*)buf)[0] = i;
     9e4:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     9e8:	40000613          	li	a2,1024
     9ec:	85ca                	mv	a1,s2
     9ee:	854e                	mv	a0,s3
     9f0:	00005097          	auipc	ra,0x5
     9f4:	db0080e7          	jalr	-592(ra) # 57a0 <write>
     9f8:	40000793          	li	a5,1024
     9fc:	06f51c63          	bne	a0,a5,a74 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     a00:	2485                	addiw	s1,s1,1
     a02:	ff4491e3          	bne	s1,s4,9e4 <writebig+0x3c>
  close(fd);
     a06:	854e                	mv	a0,s3
     a08:	00005097          	auipc	ra,0x5
     a0c:	da0080e7          	jalr	-608(ra) # 57a8 <close>
  fd = open("big", O_RDONLY);
     a10:	4581                	li	a1,0
     a12:	00005517          	auipc	a0,0x5
     a16:	6ae50513          	addi	a0,a0,1710 # 60c0 <malloc+0x4f6>
     a1a:	00005097          	auipc	ra,0x5
     a1e:	da6080e7          	jalr	-602(ra) # 57c0 <open>
     a22:	89aa                	mv	s3,a0
  n = 0;
     a24:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a26:	0000b917          	auipc	s2,0xb
     a2a:	2c290913          	addi	s2,s2,706 # bce8 <buf>
  if(fd < 0){
     a2e:	06054263          	bltz	a0,a92 <writebig+0xea>
    i = read(fd, buf, BSIZE);
     a32:	40000613          	li	a2,1024
     a36:	85ca                	mv	a1,s2
     a38:	854e                	mv	a0,s3
     a3a:	00005097          	auipc	ra,0x5
     a3e:	d5e080e7          	jalr	-674(ra) # 5798 <read>
    if(i == 0){
     a42:	c535                	beqz	a0,aae <writebig+0x106>
    } else if(i != BSIZE){
     a44:	40000793          	li	a5,1024
     a48:	0af51f63          	bne	a0,a5,b06 <writebig+0x15e>
    if(((int*)buf)[0] != n){
     a4c:	00092683          	lw	a3,0(s2)
     a50:	0c969a63          	bne	a3,s1,b24 <writebig+0x17c>
    n++;
     a54:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a56:	bff1                	j	a32 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     a58:	85d6                	mv	a1,s5
     a5a:	00005517          	auipc	a0,0x5
     a5e:	66e50513          	addi	a0,a0,1646 # 60c8 <malloc+0x4fe>
     a62:	00005097          	auipc	ra,0x5
     a66:	0b0080e7          	jalr	176(ra) # 5b12 <printf>
    exit(1);
     a6a:	4505                	li	a0,1
     a6c:	00005097          	auipc	ra,0x5
     a70:	d14080e7          	jalr	-748(ra) # 5780 <exit>
      printf("%s: error: write big file failed\n", s, i);
     a74:	8626                	mv	a2,s1
     a76:	85d6                	mv	a1,s5
     a78:	00005517          	auipc	a0,0x5
     a7c:	67050513          	addi	a0,a0,1648 # 60e8 <malloc+0x51e>
     a80:	00005097          	auipc	ra,0x5
     a84:	092080e7          	jalr	146(ra) # 5b12 <printf>
      exit(1);
     a88:	4505                	li	a0,1
     a8a:	00005097          	auipc	ra,0x5
     a8e:	cf6080e7          	jalr	-778(ra) # 5780 <exit>
    printf("%s: error: open big failed!\n", s);
     a92:	85d6                	mv	a1,s5
     a94:	00005517          	auipc	a0,0x5
     a98:	67c50513          	addi	a0,a0,1660 # 6110 <malloc+0x546>
     a9c:	00005097          	auipc	ra,0x5
     aa0:	076080e7          	jalr	118(ra) # 5b12 <printf>
    exit(1);
     aa4:	4505                	li	a0,1
     aa6:	00005097          	auipc	ra,0x5
     aaa:	cda080e7          	jalr	-806(ra) # 5780 <exit>
      if(n == MAXFILE - 1){
     aae:	10b00793          	li	a5,267
     ab2:	02f48a63          	beq	s1,a5,ae6 <writebig+0x13e>
  close(fd);
     ab6:	854e                	mv	a0,s3
     ab8:	00005097          	auipc	ra,0x5
     abc:	cf0080e7          	jalr	-784(ra) # 57a8 <close>
  if(unlink("big") < 0){
     ac0:	00005517          	auipc	a0,0x5
     ac4:	60050513          	addi	a0,a0,1536 # 60c0 <malloc+0x4f6>
     ac8:	00005097          	auipc	ra,0x5
     acc:	d08080e7          	jalr	-760(ra) # 57d0 <unlink>
     ad0:	06054963          	bltz	a0,b42 <writebig+0x19a>
}
     ad4:	70e2                	ld	ra,56(sp)
     ad6:	7442                	ld	s0,48(sp)
     ad8:	74a2                	ld	s1,40(sp)
     ada:	7902                	ld	s2,32(sp)
     adc:	69e2                	ld	s3,24(sp)
     ade:	6a42                	ld	s4,16(sp)
     ae0:	6aa2                	ld	s5,8(sp)
     ae2:	6121                	addi	sp,sp,64
     ae4:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     ae6:	10b00613          	li	a2,267
     aea:	85d6                	mv	a1,s5
     aec:	00005517          	auipc	a0,0x5
     af0:	64450513          	addi	a0,a0,1604 # 6130 <malloc+0x566>
     af4:	00005097          	auipc	ra,0x5
     af8:	01e080e7          	jalr	30(ra) # 5b12 <printf>
        exit(1);
     afc:	4505                	li	a0,1
     afe:	00005097          	auipc	ra,0x5
     b02:	c82080e7          	jalr	-894(ra) # 5780 <exit>
      printf("%s: read failed %d\n", s, i);
     b06:	862a                	mv	a2,a0
     b08:	85d6                	mv	a1,s5
     b0a:	00005517          	auipc	a0,0x5
     b0e:	64e50513          	addi	a0,a0,1614 # 6158 <malloc+0x58e>
     b12:	00005097          	auipc	ra,0x5
     b16:	000080e7          	jalr	ra # 5b12 <printf>
      exit(1);
     b1a:	4505                	li	a0,1
     b1c:	00005097          	auipc	ra,0x5
     b20:	c64080e7          	jalr	-924(ra) # 5780 <exit>
      printf("%s: read content of block %d is %d\n", s,
     b24:	8626                	mv	a2,s1
     b26:	85d6                	mv	a1,s5
     b28:	00005517          	auipc	a0,0x5
     b2c:	64850513          	addi	a0,a0,1608 # 6170 <malloc+0x5a6>
     b30:	00005097          	auipc	ra,0x5
     b34:	fe2080e7          	jalr	-30(ra) # 5b12 <printf>
      exit(1);
     b38:	4505                	li	a0,1
     b3a:	00005097          	auipc	ra,0x5
     b3e:	c46080e7          	jalr	-954(ra) # 5780 <exit>
    printf("%s: unlink big failed\n", s);
     b42:	85d6                	mv	a1,s5
     b44:	00005517          	auipc	a0,0x5
     b48:	65450513          	addi	a0,a0,1620 # 6198 <malloc+0x5ce>
     b4c:	00005097          	auipc	ra,0x5
     b50:	fc6080e7          	jalr	-58(ra) # 5b12 <printf>
    exit(1);
     b54:	4505                	li	a0,1
     b56:	00005097          	auipc	ra,0x5
     b5a:	c2a080e7          	jalr	-982(ra) # 5780 <exit>

0000000000000b5e <unlinkread>:
{
     b5e:	7179                	addi	sp,sp,-48
     b60:	f406                	sd	ra,40(sp)
     b62:	f022                	sd	s0,32(sp)
     b64:	ec26                	sd	s1,24(sp)
     b66:	e84a                	sd	s2,16(sp)
     b68:	e44e                	sd	s3,8(sp)
     b6a:	1800                	addi	s0,sp,48
     b6c:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b6e:	20200593          	li	a1,514
     b72:	00005517          	auipc	a0,0x5
     b76:	63e50513          	addi	a0,a0,1598 # 61b0 <malloc+0x5e6>
     b7a:	00005097          	auipc	ra,0x5
     b7e:	c46080e7          	jalr	-954(ra) # 57c0 <open>
  if(fd < 0){
     b82:	0e054563          	bltz	a0,c6c <unlinkread+0x10e>
     b86:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b88:	4615                	li	a2,5
     b8a:	00005597          	auipc	a1,0x5
     b8e:	65658593          	addi	a1,a1,1622 # 61e0 <malloc+0x616>
     b92:	00005097          	auipc	ra,0x5
     b96:	c0e080e7          	jalr	-1010(ra) # 57a0 <write>
  close(fd);
     b9a:	8526                	mv	a0,s1
     b9c:	00005097          	auipc	ra,0x5
     ba0:	c0c080e7          	jalr	-1012(ra) # 57a8 <close>
  fd = open("unlinkread", O_RDWR);
     ba4:	4589                	li	a1,2
     ba6:	00005517          	auipc	a0,0x5
     baa:	60a50513          	addi	a0,a0,1546 # 61b0 <malloc+0x5e6>
     bae:	00005097          	auipc	ra,0x5
     bb2:	c12080e7          	jalr	-1006(ra) # 57c0 <open>
     bb6:	84aa                	mv	s1,a0
  if(fd < 0){
     bb8:	0c054863          	bltz	a0,c88 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     bbc:	00005517          	auipc	a0,0x5
     bc0:	5f450513          	addi	a0,a0,1524 # 61b0 <malloc+0x5e6>
     bc4:	00005097          	auipc	ra,0x5
     bc8:	c0c080e7          	jalr	-1012(ra) # 57d0 <unlink>
     bcc:	ed61                	bnez	a0,ca4 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bce:	20200593          	li	a1,514
     bd2:	00005517          	auipc	a0,0x5
     bd6:	5de50513          	addi	a0,a0,1502 # 61b0 <malloc+0x5e6>
     bda:	00005097          	auipc	ra,0x5
     bde:	be6080e7          	jalr	-1050(ra) # 57c0 <open>
     be2:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     be4:	460d                	li	a2,3
     be6:	00005597          	auipc	a1,0x5
     bea:	64258593          	addi	a1,a1,1602 # 6228 <malloc+0x65e>
     bee:	00005097          	auipc	ra,0x5
     bf2:	bb2080e7          	jalr	-1102(ra) # 57a0 <write>
  close(fd1);
     bf6:	854a                	mv	a0,s2
     bf8:	00005097          	auipc	ra,0x5
     bfc:	bb0080e7          	jalr	-1104(ra) # 57a8 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     c00:	660d                	lui	a2,0x3
     c02:	0000b597          	auipc	a1,0xb
     c06:	0e658593          	addi	a1,a1,230 # bce8 <buf>
     c0a:	8526                	mv	a0,s1
     c0c:	00005097          	auipc	ra,0x5
     c10:	b8c080e7          	jalr	-1140(ra) # 5798 <read>
     c14:	4795                	li	a5,5
     c16:	0af51563          	bne	a0,a5,cc0 <unlinkread+0x162>
  if(buf[0] != 'h'){
     c1a:	0000b717          	auipc	a4,0xb
     c1e:	0ce74703          	lbu	a4,206(a4) # bce8 <buf>
     c22:	06800793          	li	a5,104
     c26:	0af71b63          	bne	a4,a5,cdc <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     c2a:	4629                	li	a2,10
     c2c:	0000b597          	auipc	a1,0xb
     c30:	0bc58593          	addi	a1,a1,188 # bce8 <buf>
     c34:	8526                	mv	a0,s1
     c36:	00005097          	auipc	ra,0x5
     c3a:	b6a080e7          	jalr	-1174(ra) # 57a0 <write>
     c3e:	47a9                	li	a5,10
     c40:	0af51c63          	bne	a0,a5,cf8 <unlinkread+0x19a>
  close(fd);
     c44:	8526                	mv	a0,s1
     c46:	00005097          	auipc	ra,0x5
     c4a:	b62080e7          	jalr	-1182(ra) # 57a8 <close>
  unlink("unlinkread");
     c4e:	00005517          	auipc	a0,0x5
     c52:	56250513          	addi	a0,a0,1378 # 61b0 <malloc+0x5e6>
     c56:	00005097          	auipc	ra,0x5
     c5a:	b7a080e7          	jalr	-1158(ra) # 57d0 <unlink>
}
     c5e:	70a2                	ld	ra,40(sp)
     c60:	7402                	ld	s0,32(sp)
     c62:	64e2                	ld	s1,24(sp)
     c64:	6942                	ld	s2,16(sp)
     c66:	69a2                	ld	s3,8(sp)
     c68:	6145                	addi	sp,sp,48
     c6a:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c6c:	85ce                	mv	a1,s3
     c6e:	00005517          	auipc	a0,0x5
     c72:	55250513          	addi	a0,a0,1362 # 61c0 <malloc+0x5f6>
     c76:	00005097          	auipc	ra,0x5
     c7a:	e9c080e7          	jalr	-356(ra) # 5b12 <printf>
    exit(1);
     c7e:	4505                	li	a0,1
     c80:	00005097          	auipc	ra,0x5
     c84:	b00080e7          	jalr	-1280(ra) # 5780 <exit>
    printf("%s: open unlinkread failed\n", s);
     c88:	85ce                	mv	a1,s3
     c8a:	00005517          	auipc	a0,0x5
     c8e:	55e50513          	addi	a0,a0,1374 # 61e8 <malloc+0x61e>
     c92:	00005097          	auipc	ra,0x5
     c96:	e80080e7          	jalr	-384(ra) # 5b12 <printf>
    exit(1);
     c9a:	4505                	li	a0,1
     c9c:	00005097          	auipc	ra,0x5
     ca0:	ae4080e7          	jalr	-1308(ra) # 5780 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     ca4:	85ce                	mv	a1,s3
     ca6:	00005517          	auipc	a0,0x5
     caa:	56250513          	addi	a0,a0,1378 # 6208 <malloc+0x63e>
     cae:	00005097          	auipc	ra,0x5
     cb2:	e64080e7          	jalr	-412(ra) # 5b12 <printf>
    exit(1);
     cb6:	4505                	li	a0,1
     cb8:	00005097          	auipc	ra,0x5
     cbc:	ac8080e7          	jalr	-1336(ra) # 5780 <exit>
    printf("%s: unlinkread read failed", s);
     cc0:	85ce                	mv	a1,s3
     cc2:	00005517          	auipc	a0,0x5
     cc6:	56e50513          	addi	a0,a0,1390 # 6230 <malloc+0x666>
     cca:	00005097          	auipc	ra,0x5
     cce:	e48080e7          	jalr	-440(ra) # 5b12 <printf>
    exit(1);
     cd2:	4505                	li	a0,1
     cd4:	00005097          	auipc	ra,0x5
     cd8:	aac080e7          	jalr	-1364(ra) # 5780 <exit>
    printf("%s: unlinkread wrong data\n", s);
     cdc:	85ce                	mv	a1,s3
     cde:	00005517          	auipc	a0,0x5
     ce2:	57250513          	addi	a0,a0,1394 # 6250 <malloc+0x686>
     ce6:	00005097          	auipc	ra,0x5
     cea:	e2c080e7          	jalr	-468(ra) # 5b12 <printf>
    exit(1);
     cee:	4505                	li	a0,1
     cf0:	00005097          	auipc	ra,0x5
     cf4:	a90080e7          	jalr	-1392(ra) # 5780 <exit>
    printf("%s: unlinkread write failed\n", s);
     cf8:	85ce                	mv	a1,s3
     cfa:	00005517          	auipc	a0,0x5
     cfe:	57650513          	addi	a0,a0,1398 # 6270 <malloc+0x6a6>
     d02:	00005097          	auipc	ra,0x5
     d06:	e10080e7          	jalr	-496(ra) # 5b12 <printf>
    exit(1);
     d0a:	4505                	li	a0,1
     d0c:	00005097          	auipc	ra,0x5
     d10:	a74080e7          	jalr	-1420(ra) # 5780 <exit>

0000000000000d14 <linktest>:
{
     d14:	1101                	addi	sp,sp,-32
     d16:	ec06                	sd	ra,24(sp)
     d18:	e822                	sd	s0,16(sp)
     d1a:	e426                	sd	s1,8(sp)
     d1c:	e04a                	sd	s2,0(sp)
     d1e:	1000                	addi	s0,sp,32
     d20:	892a                	mv	s2,a0
  unlink("lf1");
     d22:	00005517          	auipc	a0,0x5
     d26:	56e50513          	addi	a0,a0,1390 # 6290 <malloc+0x6c6>
     d2a:	00005097          	auipc	ra,0x5
     d2e:	aa6080e7          	jalr	-1370(ra) # 57d0 <unlink>
  unlink("lf2");
     d32:	00005517          	auipc	a0,0x5
     d36:	56650513          	addi	a0,a0,1382 # 6298 <malloc+0x6ce>
     d3a:	00005097          	auipc	ra,0x5
     d3e:	a96080e7          	jalr	-1386(ra) # 57d0 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     d42:	20200593          	li	a1,514
     d46:	00005517          	auipc	a0,0x5
     d4a:	54a50513          	addi	a0,a0,1354 # 6290 <malloc+0x6c6>
     d4e:	00005097          	auipc	ra,0x5
     d52:	a72080e7          	jalr	-1422(ra) # 57c0 <open>
  if(fd < 0){
     d56:	10054763          	bltz	a0,e64 <linktest+0x150>
     d5a:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d5c:	4615                	li	a2,5
     d5e:	00005597          	auipc	a1,0x5
     d62:	48258593          	addi	a1,a1,1154 # 61e0 <malloc+0x616>
     d66:	00005097          	auipc	ra,0x5
     d6a:	a3a080e7          	jalr	-1478(ra) # 57a0 <write>
     d6e:	4795                	li	a5,5
     d70:	10f51863          	bne	a0,a5,e80 <linktest+0x16c>
  close(fd);
     d74:	8526                	mv	a0,s1
     d76:	00005097          	auipc	ra,0x5
     d7a:	a32080e7          	jalr	-1486(ra) # 57a8 <close>
  if(link("lf1", "lf2") < 0){
     d7e:	00005597          	auipc	a1,0x5
     d82:	51a58593          	addi	a1,a1,1306 # 6298 <malloc+0x6ce>
     d86:	00005517          	auipc	a0,0x5
     d8a:	50a50513          	addi	a0,a0,1290 # 6290 <malloc+0x6c6>
     d8e:	00005097          	auipc	ra,0x5
     d92:	a52080e7          	jalr	-1454(ra) # 57e0 <link>
     d96:	10054363          	bltz	a0,e9c <linktest+0x188>
  unlink("lf1");
     d9a:	00005517          	auipc	a0,0x5
     d9e:	4f650513          	addi	a0,a0,1270 # 6290 <malloc+0x6c6>
     da2:	00005097          	auipc	ra,0x5
     da6:	a2e080e7          	jalr	-1490(ra) # 57d0 <unlink>
  if(open("lf1", 0) >= 0){
     daa:	4581                	li	a1,0
     dac:	00005517          	auipc	a0,0x5
     db0:	4e450513          	addi	a0,a0,1252 # 6290 <malloc+0x6c6>
     db4:	00005097          	auipc	ra,0x5
     db8:	a0c080e7          	jalr	-1524(ra) # 57c0 <open>
     dbc:	0e055e63          	bgez	a0,eb8 <linktest+0x1a4>
  fd = open("lf2", 0);
     dc0:	4581                	li	a1,0
     dc2:	00005517          	auipc	a0,0x5
     dc6:	4d650513          	addi	a0,a0,1238 # 6298 <malloc+0x6ce>
     dca:	00005097          	auipc	ra,0x5
     dce:	9f6080e7          	jalr	-1546(ra) # 57c0 <open>
     dd2:	84aa                	mv	s1,a0
  if(fd < 0){
     dd4:	10054063          	bltz	a0,ed4 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     dd8:	660d                	lui	a2,0x3
     dda:	0000b597          	auipc	a1,0xb
     dde:	f0e58593          	addi	a1,a1,-242 # bce8 <buf>
     de2:	00005097          	auipc	ra,0x5
     de6:	9b6080e7          	jalr	-1610(ra) # 5798 <read>
     dea:	4795                	li	a5,5
     dec:	10f51263          	bne	a0,a5,ef0 <linktest+0x1dc>
  close(fd);
     df0:	8526                	mv	a0,s1
     df2:	00005097          	auipc	ra,0x5
     df6:	9b6080e7          	jalr	-1610(ra) # 57a8 <close>
  if(link("lf2", "lf2") >= 0){
     dfa:	00005597          	auipc	a1,0x5
     dfe:	49e58593          	addi	a1,a1,1182 # 6298 <malloc+0x6ce>
     e02:	852e                	mv	a0,a1
     e04:	00005097          	auipc	ra,0x5
     e08:	9dc080e7          	jalr	-1572(ra) # 57e0 <link>
     e0c:	10055063          	bgez	a0,f0c <linktest+0x1f8>
  unlink("lf2");
     e10:	00005517          	auipc	a0,0x5
     e14:	48850513          	addi	a0,a0,1160 # 6298 <malloc+0x6ce>
     e18:	00005097          	auipc	ra,0x5
     e1c:	9b8080e7          	jalr	-1608(ra) # 57d0 <unlink>
  if(link("lf2", "lf1") >= 0){
     e20:	00005597          	auipc	a1,0x5
     e24:	47058593          	addi	a1,a1,1136 # 6290 <malloc+0x6c6>
     e28:	00005517          	auipc	a0,0x5
     e2c:	47050513          	addi	a0,a0,1136 # 6298 <malloc+0x6ce>
     e30:	00005097          	auipc	ra,0x5
     e34:	9b0080e7          	jalr	-1616(ra) # 57e0 <link>
     e38:	0e055863          	bgez	a0,f28 <linktest+0x214>
  if(link(".", "lf1") >= 0){
     e3c:	00005597          	auipc	a1,0x5
     e40:	45458593          	addi	a1,a1,1108 # 6290 <malloc+0x6c6>
     e44:	00005517          	auipc	a0,0x5
     e48:	55c50513          	addi	a0,a0,1372 # 63a0 <malloc+0x7d6>
     e4c:	00005097          	auipc	ra,0x5
     e50:	994080e7          	jalr	-1644(ra) # 57e0 <link>
     e54:	0e055863          	bgez	a0,f44 <linktest+0x230>
}
     e58:	60e2                	ld	ra,24(sp)
     e5a:	6442                	ld	s0,16(sp)
     e5c:	64a2                	ld	s1,8(sp)
     e5e:	6902                	ld	s2,0(sp)
     e60:	6105                	addi	sp,sp,32
     e62:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     e64:	85ca                	mv	a1,s2
     e66:	00005517          	auipc	a0,0x5
     e6a:	43a50513          	addi	a0,a0,1082 # 62a0 <malloc+0x6d6>
     e6e:	00005097          	auipc	ra,0x5
     e72:	ca4080e7          	jalr	-860(ra) # 5b12 <printf>
    exit(1);
     e76:	4505                	li	a0,1
     e78:	00005097          	auipc	ra,0x5
     e7c:	908080e7          	jalr	-1784(ra) # 5780 <exit>
    printf("%s: write lf1 failed\n", s);
     e80:	85ca                	mv	a1,s2
     e82:	00005517          	auipc	a0,0x5
     e86:	43650513          	addi	a0,a0,1078 # 62b8 <malloc+0x6ee>
     e8a:	00005097          	auipc	ra,0x5
     e8e:	c88080e7          	jalr	-888(ra) # 5b12 <printf>
    exit(1);
     e92:	4505                	li	a0,1
     e94:	00005097          	auipc	ra,0x5
     e98:	8ec080e7          	jalr	-1812(ra) # 5780 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     e9c:	85ca                	mv	a1,s2
     e9e:	00005517          	auipc	a0,0x5
     ea2:	43250513          	addi	a0,a0,1074 # 62d0 <malloc+0x706>
     ea6:	00005097          	auipc	ra,0x5
     eaa:	c6c080e7          	jalr	-916(ra) # 5b12 <printf>
    exit(1);
     eae:	4505                	li	a0,1
     eb0:	00005097          	auipc	ra,0x5
     eb4:	8d0080e7          	jalr	-1840(ra) # 5780 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     eb8:	85ca                	mv	a1,s2
     eba:	00005517          	auipc	a0,0x5
     ebe:	43650513          	addi	a0,a0,1078 # 62f0 <malloc+0x726>
     ec2:	00005097          	auipc	ra,0x5
     ec6:	c50080e7          	jalr	-944(ra) # 5b12 <printf>
    exit(1);
     eca:	4505                	li	a0,1
     ecc:	00005097          	auipc	ra,0x5
     ed0:	8b4080e7          	jalr	-1868(ra) # 5780 <exit>
    printf("%s: open lf2 failed\n", s);
     ed4:	85ca                	mv	a1,s2
     ed6:	00005517          	auipc	a0,0x5
     eda:	44a50513          	addi	a0,a0,1098 # 6320 <malloc+0x756>
     ede:	00005097          	auipc	ra,0x5
     ee2:	c34080e7          	jalr	-972(ra) # 5b12 <printf>
    exit(1);
     ee6:	4505                	li	a0,1
     ee8:	00005097          	auipc	ra,0x5
     eec:	898080e7          	jalr	-1896(ra) # 5780 <exit>
    printf("%s: read lf2 failed\n", s);
     ef0:	85ca                	mv	a1,s2
     ef2:	00005517          	auipc	a0,0x5
     ef6:	44650513          	addi	a0,a0,1094 # 6338 <malloc+0x76e>
     efa:	00005097          	auipc	ra,0x5
     efe:	c18080e7          	jalr	-1000(ra) # 5b12 <printf>
    exit(1);
     f02:	4505                	li	a0,1
     f04:	00005097          	auipc	ra,0x5
     f08:	87c080e7          	jalr	-1924(ra) # 5780 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     f0c:	85ca                	mv	a1,s2
     f0e:	00005517          	auipc	a0,0x5
     f12:	44250513          	addi	a0,a0,1090 # 6350 <malloc+0x786>
     f16:	00005097          	auipc	ra,0x5
     f1a:	bfc080e7          	jalr	-1028(ra) # 5b12 <printf>
    exit(1);
     f1e:	4505                	li	a0,1
     f20:	00005097          	auipc	ra,0x5
     f24:	860080e7          	jalr	-1952(ra) # 5780 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     f28:	85ca                	mv	a1,s2
     f2a:	00005517          	auipc	a0,0x5
     f2e:	44e50513          	addi	a0,a0,1102 # 6378 <malloc+0x7ae>
     f32:	00005097          	auipc	ra,0x5
     f36:	be0080e7          	jalr	-1056(ra) # 5b12 <printf>
    exit(1);
     f3a:	4505                	li	a0,1
     f3c:	00005097          	auipc	ra,0x5
     f40:	844080e7          	jalr	-1980(ra) # 5780 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     f44:	85ca                	mv	a1,s2
     f46:	00005517          	auipc	a0,0x5
     f4a:	46250513          	addi	a0,a0,1122 # 63a8 <malloc+0x7de>
     f4e:	00005097          	auipc	ra,0x5
     f52:	bc4080e7          	jalr	-1084(ra) # 5b12 <printf>
    exit(1);
     f56:	4505                	li	a0,1
     f58:	00005097          	auipc	ra,0x5
     f5c:	828080e7          	jalr	-2008(ra) # 5780 <exit>

0000000000000f60 <bigdir>:
{
     f60:	715d                	addi	sp,sp,-80
     f62:	e486                	sd	ra,72(sp)
     f64:	e0a2                	sd	s0,64(sp)
     f66:	fc26                	sd	s1,56(sp)
     f68:	f84a                	sd	s2,48(sp)
     f6a:	f44e                	sd	s3,40(sp)
     f6c:	f052                	sd	s4,32(sp)
     f6e:	ec56                	sd	s5,24(sp)
     f70:	e85a                	sd	s6,16(sp)
     f72:	0880                	addi	s0,sp,80
     f74:	89aa                	mv	s3,a0
  unlink("bd");
     f76:	00005517          	auipc	a0,0x5
     f7a:	45250513          	addi	a0,a0,1106 # 63c8 <malloc+0x7fe>
     f7e:	00005097          	auipc	ra,0x5
     f82:	852080e7          	jalr	-1966(ra) # 57d0 <unlink>
  fd = open("bd", O_CREATE);
     f86:	20000593          	li	a1,512
     f8a:	00005517          	auipc	a0,0x5
     f8e:	43e50513          	addi	a0,a0,1086 # 63c8 <malloc+0x7fe>
     f92:	00005097          	auipc	ra,0x5
     f96:	82e080e7          	jalr	-2002(ra) # 57c0 <open>
  if(fd < 0){
     f9a:	0c054963          	bltz	a0,106c <bigdir+0x10c>
  close(fd);
     f9e:	00005097          	auipc	ra,0x5
     fa2:	80a080e7          	jalr	-2038(ra) # 57a8 <close>
  for(i = 0; i < N; i++){
     fa6:	4901                	li	s2,0
    name[0] = 'x';
     fa8:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     fac:	00005a17          	auipc	s4,0x5
     fb0:	41ca0a13          	addi	s4,s4,1052 # 63c8 <malloc+0x7fe>
  for(i = 0; i < N; i++){
     fb4:	1f400b13          	li	s6,500
    name[0] = 'x';
     fb8:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     fbc:	41f9571b          	sraiw	a4,s2,0x1f
     fc0:	01a7571b          	srliw	a4,a4,0x1a
     fc4:	012707bb          	addw	a5,a4,s2
     fc8:	4067d69b          	sraiw	a3,a5,0x6
     fcc:	0306869b          	addiw	a3,a3,48
     fd0:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     fd4:	03f7f793          	andi	a5,a5,63
     fd8:	9f99                	subw	a5,a5,a4
     fda:	0307879b          	addiw	a5,a5,48
     fde:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     fe2:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
     fe6:	fb040593          	addi	a1,s0,-80
     fea:	8552                	mv	a0,s4
     fec:	00004097          	auipc	ra,0x4
     ff0:	7f4080e7          	jalr	2036(ra) # 57e0 <link>
     ff4:	84aa                	mv	s1,a0
     ff6:	e949                	bnez	a0,1088 <bigdir+0x128>
  for(i = 0; i < N; i++){
     ff8:	2905                	addiw	s2,s2,1
     ffa:	fb691fe3          	bne	s2,s6,fb8 <bigdir+0x58>
  unlink("bd");
     ffe:	00005517          	auipc	a0,0x5
    1002:	3ca50513          	addi	a0,a0,970 # 63c8 <malloc+0x7fe>
    1006:	00004097          	auipc	ra,0x4
    100a:	7ca080e7          	jalr	1994(ra) # 57d0 <unlink>
    name[0] = 'x';
    100e:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1012:	1f400a13          	li	s4,500
    name[0] = 'x';
    1016:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    101a:	41f4d71b          	sraiw	a4,s1,0x1f
    101e:	01a7571b          	srliw	a4,a4,0x1a
    1022:	009707bb          	addw	a5,a4,s1
    1026:	4067d69b          	sraiw	a3,a5,0x6
    102a:	0306869b          	addiw	a3,a3,48
    102e:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1032:	03f7f793          	andi	a5,a5,63
    1036:	9f99                	subw	a5,a5,a4
    1038:	0307879b          	addiw	a5,a5,48
    103c:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1040:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    1044:	fb040513          	addi	a0,s0,-80
    1048:	00004097          	auipc	ra,0x4
    104c:	788080e7          	jalr	1928(ra) # 57d0 <unlink>
    1050:	ed21                	bnez	a0,10a8 <bigdir+0x148>
  for(i = 0; i < N; i++){
    1052:	2485                	addiw	s1,s1,1
    1054:	fd4491e3          	bne	s1,s4,1016 <bigdir+0xb6>
}
    1058:	60a6                	ld	ra,72(sp)
    105a:	6406                	ld	s0,64(sp)
    105c:	74e2                	ld	s1,56(sp)
    105e:	7942                	ld	s2,48(sp)
    1060:	79a2                	ld	s3,40(sp)
    1062:	7a02                	ld	s4,32(sp)
    1064:	6ae2                	ld	s5,24(sp)
    1066:	6b42                	ld	s6,16(sp)
    1068:	6161                	addi	sp,sp,80
    106a:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    106c:	85ce                	mv	a1,s3
    106e:	00005517          	auipc	a0,0x5
    1072:	36250513          	addi	a0,a0,866 # 63d0 <malloc+0x806>
    1076:	00005097          	auipc	ra,0x5
    107a:	a9c080e7          	jalr	-1380(ra) # 5b12 <printf>
    exit(1);
    107e:	4505                	li	a0,1
    1080:	00004097          	auipc	ra,0x4
    1084:	700080e7          	jalr	1792(ra) # 5780 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    1088:	fb040613          	addi	a2,s0,-80
    108c:	85ce                	mv	a1,s3
    108e:	00005517          	auipc	a0,0x5
    1092:	36250513          	addi	a0,a0,866 # 63f0 <malloc+0x826>
    1096:	00005097          	auipc	ra,0x5
    109a:	a7c080e7          	jalr	-1412(ra) # 5b12 <printf>
      exit(1);
    109e:	4505                	li	a0,1
    10a0:	00004097          	auipc	ra,0x4
    10a4:	6e0080e7          	jalr	1760(ra) # 5780 <exit>
      printf("%s: bigdir unlink failed", s);
    10a8:	85ce                	mv	a1,s3
    10aa:	00005517          	auipc	a0,0x5
    10ae:	36650513          	addi	a0,a0,870 # 6410 <malloc+0x846>
    10b2:	00005097          	auipc	ra,0x5
    10b6:	a60080e7          	jalr	-1440(ra) # 5b12 <printf>
      exit(1);
    10ba:	4505                	li	a0,1
    10bc:	00004097          	auipc	ra,0x4
    10c0:	6c4080e7          	jalr	1732(ra) # 5780 <exit>

00000000000010c4 <validatetest>:
{
    10c4:	7139                	addi	sp,sp,-64
    10c6:	fc06                	sd	ra,56(sp)
    10c8:	f822                	sd	s0,48(sp)
    10ca:	f426                	sd	s1,40(sp)
    10cc:	f04a                	sd	s2,32(sp)
    10ce:	ec4e                	sd	s3,24(sp)
    10d0:	e852                	sd	s4,16(sp)
    10d2:	e456                	sd	s5,8(sp)
    10d4:	e05a                	sd	s6,0(sp)
    10d6:	0080                	addi	s0,sp,64
    10d8:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10da:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    10dc:	00005997          	auipc	s3,0x5
    10e0:	35498993          	addi	s3,s3,852 # 6430 <malloc+0x866>
    10e4:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10e6:	6a85                	lui	s5,0x1
    10e8:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    10ec:	85a6                	mv	a1,s1
    10ee:	854e                	mv	a0,s3
    10f0:	00004097          	auipc	ra,0x4
    10f4:	6f0080e7          	jalr	1776(ra) # 57e0 <link>
    10f8:	01251f63          	bne	a0,s2,1116 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10fc:	94d6                	add	s1,s1,s5
    10fe:	ff4497e3          	bne	s1,s4,10ec <validatetest+0x28>
}
    1102:	70e2                	ld	ra,56(sp)
    1104:	7442                	ld	s0,48(sp)
    1106:	74a2                	ld	s1,40(sp)
    1108:	7902                	ld	s2,32(sp)
    110a:	69e2                	ld	s3,24(sp)
    110c:	6a42                	ld	s4,16(sp)
    110e:	6aa2                	ld	s5,8(sp)
    1110:	6b02                	ld	s6,0(sp)
    1112:	6121                	addi	sp,sp,64
    1114:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1116:	85da                	mv	a1,s6
    1118:	00005517          	auipc	a0,0x5
    111c:	32850513          	addi	a0,a0,808 # 6440 <malloc+0x876>
    1120:	00005097          	auipc	ra,0x5
    1124:	9f2080e7          	jalr	-1550(ra) # 5b12 <printf>
      exit(1);
    1128:	4505                	li	a0,1
    112a:	00004097          	auipc	ra,0x4
    112e:	656080e7          	jalr	1622(ra) # 5780 <exit>

0000000000001132 <pgbug>:
// regression test. copyin(), copyout(), and copyinstr() used to cast
// the virtual page address to uint, which (with certain wild system
// call arguments) resulted in a kernel page faults.
void
pgbug(char *s)
{
    1132:	7179                	addi	sp,sp,-48
    1134:	f406                	sd	ra,40(sp)
    1136:	f022                	sd	s0,32(sp)
    1138:	ec26                	sd	s1,24(sp)
    113a:	1800                	addi	s0,sp,48
  char *argv[1];
  argv[0] = 0;
    113c:	fc043c23          	sd	zero,-40(s0)
  exec((char*)0xeaeb0b5b00002f5e, argv);
    1140:	00007497          	auipc	s1,0x7
    1144:	3804b483          	ld	s1,896(s1) # 84c0 <__SDATA_BEGIN__>
    1148:	fd840593          	addi	a1,s0,-40
    114c:	8526                	mv	a0,s1
    114e:	00004097          	auipc	ra,0x4
    1152:	66a080e7          	jalr	1642(ra) # 57b8 <exec>

  pipe((int*)0xeaeb0b5b00002f5e);
    1156:	8526                	mv	a0,s1
    1158:	00004097          	auipc	ra,0x4
    115c:	638080e7          	jalr	1592(ra) # 5790 <pipe>

  exit(0);
    1160:	4501                	li	a0,0
    1162:	00004097          	auipc	ra,0x4
    1166:	61e080e7          	jalr	1566(ra) # 5780 <exit>

000000000000116a <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    116a:	7139                	addi	sp,sp,-64
    116c:	fc06                	sd	ra,56(sp)
    116e:	f822                	sd	s0,48(sp)
    1170:	f426                	sd	s1,40(sp)
    1172:	f04a                	sd	s2,32(sp)
    1174:	ec4e                	sd	s3,24(sp)
    1176:	0080                	addi	s0,sp,64
    1178:	64b1                	lui	s1,0xc
    117a:	35048493          	addi	s1,s1,848 # c350 <buf+0x668>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    117e:	597d                	li	s2,-1
    1180:	02095913          	srli	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    1184:	00005997          	auipc	s3,0x5
    1188:	b6498993          	addi	s3,s3,-1180 # 5ce8 <malloc+0x11e>
    argv[0] = (char*)0xffffffff;
    118c:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1190:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1194:	fc040593          	addi	a1,s0,-64
    1198:	854e                	mv	a0,s3
    119a:	00004097          	auipc	ra,0x4
    119e:	61e080e7          	jalr	1566(ra) # 57b8 <exec>
  for(int i = 0; i < 50000; i++){
    11a2:	34fd                	addiw	s1,s1,-1
    11a4:	f4e5                	bnez	s1,118c <badarg+0x22>
  }
  
  exit(0);
    11a6:	4501                	li	a0,0
    11a8:	00004097          	auipc	ra,0x4
    11ac:	5d8080e7          	jalr	1496(ra) # 5780 <exit>

00000000000011b0 <copyinstr2>:
{
    11b0:	7155                	addi	sp,sp,-208
    11b2:	e586                	sd	ra,200(sp)
    11b4:	e1a2                	sd	s0,192(sp)
    11b6:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    11b8:	f6840793          	addi	a5,s0,-152
    11bc:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    11c0:	07800713          	li	a4,120
    11c4:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    11c8:	0785                	addi	a5,a5,1
    11ca:	fed79de3          	bne	a5,a3,11c4 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    11ce:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    11d2:	f6840513          	addi	a0,s0,-152
    11d6:	00004097          	auipc	ra,0x4
    11da:	5fa080e7          	jalr	1530(ra) # 57d0 <unlink>
  if(ret != -1){
    11de:	57fd                	li	a5,-1
    11e0:	0ef51063          	bne	a0,a5,12c0 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    11e4:	20100593          	li	a1,513
    11e8:	f6840513          	addi	a0,s0,-152
    11ec:	00004097          	auipc	ra,0x4
    11f0:	5d4080e7          	jalr	1492(ra) # 57c0 <open>
  if(fd != -1){
    11f4:	57fd                	li	a5,-1
    11f6:	0ef51563          	bne	a0,a5,12e0 <copyinstr2+0x130>
  ret = link(b, b);
    11fa:	f6840593          	addi	a1,s0,-152
    11fe:	852e                	mv	a0,a1
    1200:	00004097          	auipc	ra,0x4
    1204:	5e0080e7          	jalr	1504(ra) # 57e0 <link>
  if(ret != -1){
    1208:	57fd                	li	a5,-1
    120a:	0ef51b63          	bne	a0,a5,1300 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    120e:	00006797          	auipc	a5,0x6
    1212:	42a78793          	addi	a5,a5,1066 # 7638 <malloc+0x1a6e>
    1216:	f4f43c23          	sd	a5,-168(s0)
    121a:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    121e:	f5840593          	addi	a1,s0,-168
    1222:	f6840513          	addi	a0,s0,-152
    1226:	00004097          	auipc	ra,0x4
    122a:	592080e7          	jalr	1426(ra) # 57b8 <exec>
  if(ret != -1){
    122e:	57fd                	li	a5,-1
    1230:	0ef51963          	bne	a0,a5,1322 <copyinstr2+0x172>
  int pid = fork();
    1234:	00004097          	auipc	ra,0x4
    1238:	544080e7          	jalr	1348(ra) # 5778 <fork>
  if(pid < 0){
    123c:	10054363          	bltz	a0,1342 <copyinstr2+0x192>
  if(pid == 0){
    1240:	12051463          	bnez	a0,1368 <copyinstr2+0x1b8>
    1244:	00007797          	auipc	a5,0x7
    1248:	38c78793          	addi	a5,a5,908 # 85d0 <big.0>
    124c:	00008697          	auipc	a3,0x8
    1250:	38468693          	addi	a3,a3,900 # 95d0 <__global_pointer$+0x910>
      big[i] = 'x';
    1254:	07800713          	li	a4,120
    1258:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    125c:	0785                	addi	a5,a5,1
    125e:	fed79de3          	bne	a5,a3,1258 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1262:	00008797          	auipc	a5,0x8
    1266:	36078723          	sb	zero,878(a5) # 95d0 <__global_pointer$+0x910>
    char *args2[] = { big, big, big, 0 };
    126a:	00007797          	auipc	a5,0x7
    126e:	dde78793          	addi	a5,a5,-546 # 8048 <malloc+0x247e>
    1272:	6390                	ld	a2,0(a5)
    1274:	6794                	ld	a3,8(a5)
    1276:	6b98                	ld	a4,16(a5)
    1278:	6f9c                	ld	a5,24(a5)
    127a:	f2c43823          	sd	a2,-208(s0)
    127e:	f2d43c23          	sd	a3,-200(s0)
    1282:	f4e43023          	sd	a4,-192(s0)
    1286:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    128a:	f3040593          	addi	a1,s0,-208
    128e:	00005517          	auipc	a0,0x5
    1292:	a5a50513          	addi	a0,a0,-1446 # 5ce8 <malloc+0x11e>
    1296:	00004097          	auipc	ra,0x4
    129a:	522080e7          	jalr	1314(ra) # 57b8 <exec>
    if(ret != -1){
    129e:	57fd                	li	a5,-1
    12a0:	0af50e63          	beq	a0,a5,135c <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    12a4:	55fd                	li	a1,-1
    12a6:	00005517          	auipc	a0,0x5
    12aa:	24250513          	addi	a0,a0,578 # 64e8 <malloc+0x91e>
    12ae:	00005097          	auipc	ra,0x5
    12b2:	864080e7          	jalr	-1948(ra) # 5b12 <printf>
      exit(1);
    12b6:	4505                	li	a0,1
    12b8:	00004097          	auipc	ra,0x4
    12bc:	4c8080e7          	jalr	1224(ra) # 5780 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    12c0:	862a                	mv	a2,a0
    12c2:	f6840593          	addi	a1,s0,-152
    12c6:	00005517          	auipc	a0,0x5
    12ca:	19a50513          	addi	a0,a0,410 # 6460 <malloc+0x896>
    12ce:	00005097          	auipc	ra,0x5
    12d2:	844080e7          	jalr	-1980(ra) # 5b12 <printf>
    exit(1);
    12d6:	4505                	li	a0,1
    12d8:	00004097          	auipc	ra,0x4
    12dc:	4a8080e7          	jalr	1192(ra) # 5780 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    12e0:	862a                	mv	a2,a0
    12e2:	f6840593          	addi	a1,s0,-152
    12e6:	00005517          	auipc	a0,0x5
    12ea:	19a50513          	addi	a0,a0,410 # 6480 <malloc+0x8b6>
    12ee:	00005097          	auipc	ra,0x5
    12f2:	824080e7          	jalr	-2012(ra) # 5b12 <printf>
    exit(1);
    12f6:	4505                	li	a0,1
    12f8:	00004097          	auipc	ra,0x4
    12fc:	488080e7          	jalr	1160(ra) # 5780 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1300:	86aa                	mv	a3,a0
    1302:	f6840613          	addi	a2,s0,-152
    1306:	85b2                	mv	a1,a2
    1308:	00005517          	auipc	a0,0x5
    130c:	19850513          	addi	a0,a0,408 # 64a0 <malloc+0x8d6>
    1310:	00005097          	auipc	ra,0x5
    1314:	802080e7          	jalr	-2046(ra) # 5b12 <printf>
    exit(1);
    1318:	4505                	li	a0,1
    131a:	00004097          	auipc	ra,0x4
    131e:	466080e7          	jalr	1126(ra) # 5780 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1322:	567d                	li	a2,-1
    1324:	f6840593          	addi	a1,s0,-152
    1328:	00005517          	auipc	a0,0x5
    132c:	1a050513          	addi	a0,a0,416 # 64c8 <malloc+0x8fe>
    1330:	00004097          	auipc	ra,0x4
    1334:	7e2080e7          	jalr	2018(ra) # 5b12 <printf>
    exit(1);
    1338:	4505                	li	a0,1
    133a:	00004097          	auipc	ra,0x4
    133e:	446080e7          	jalr	1094(ra) # 5780 <exit>
    printf("fork failed\n");
    1342:	00005517          	auipc	a0,0x5
    1346:	61e50513          	addi	a0,a0,1566 # 6960 <malloc+0xd96>
    134a:	00004097          	auipc	ra,0x4
    134e:	7c8080e7          	jalr	1992(ra) # 5b12 <printf>
    exit(1);
    1352:	4505                	li	a0,1
    1354:	00004097          	auipc	ra,0x4
    1358:	42c080e7          	jalr	1068(ra) # 5780 <exit>
    exit(747); // OK
    135c:	2eb00513          	li	a0,747
    1360:	00004097          	auipc	ra,0x4
    1364:	420080e7          	jalr	1056(ra) # 5780 <exit>
  int st = 0;
    1368:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    136c:	f5440513          	addi	a0,s0,-172
    1370:	00004097          	auipc	ra,0x4
    1374:	418080e7          	jalr	1048(ra) # 5788 <wait>
  if(st != 747){
    1378:	f5442703          	lw	a4,-172(s0)
    137c:	2eb00793          	li	a5,747
    1380:	00f71663          	bne	a4,a5,138c <copyinstr2+0x1dc>
}
    1384:	60ae                	ld	ra,200(sp)
    1386:	640e                	ld	s0,192(sp)
    1388:	6169                	addi	sp,sp,208
    138a:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    138c:	00005517          	auipc	a0,0x5
    1390:	18450513          	addi	a0,a0,388 # 6510 <malloc+0x946>
    1394:	00004097          	auipc	ra,0x4
    1398:	77e080e7          	jalr	1918(ra) # 5b12 <printf>
    exit(1);
    139c:	4505                	li	a0,1
    139e:	00004097          	auipc	ra,0x4
    13a2:	3e2080e7          	jalr	994(ra) # 5780 <exit>

00000000000013a6 <truncate3>:
{
    13a6:	7159                	addi	sp,sp,-112
    13a8:	f486                	sd	ra,104(sp)
    13aa:	f0a2                	sd	s0,96(sp)
    13ac:	eca6                	sd	s1,88(sp)
    13ae:	e8ca                	sd	s2,80(sp)
    13b0:	e4ce                	sd	s3,72(sp)
    13b2:	e0d2                	sd	s4,64(sp)
    13b4:	fc56                	sd	s5,56(sp)
    13b6:	1880                	addi	s0,sp,112
    13b8:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    13ba:	60100593          	li	a1,1537
    13be:	00005517          	auipc	a0,0x5
    13c2:	98250513          	addi	a0,a0,-1662 # 5d40 <malloc+0x176>
    13c6:	00004097          	auipc	ra,0x4
    13ca:	3fa080e7          	jalr	1018(ra) # 57c0 <open>
    13ce:	00004097          	auipc	ra,0x4
    13d2:	3da080e7          	jalr	986(ra) # 57a8 <close>
  pid = fork();
    13d6:	00004097          	auipc	ra,0x4
    13da:	3a2080e7          	jalr	930(ra) # 5778 <fork>
  if(pid < 0){
    13de:	08054063          	bltz	a0,145e <truncate3+0xb8>
  if(pid == 0){
    13e2:	e969                	bnez	a0,14b4 <truncate3+0x10e>
    13e4:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    13e8:	00005a17          	auipc	s4,0x5
    13ec:	958a0a13          	addi	s4,s4,-1704 # 5d40 <malloc+0x176>
      int n = write(fd, "1234567890", 10);
    13f0:	00005a97          	auipc	s5,0x5
    13f4:	180a8a93          	addi	s5,s5,384 # 6570 <malloc+0x9a6>
      int fd = open("truncfile", O_WRONLY);
    13f8:	4585                	li	a1,1
    13fa:	8552                	mv	a0,s4
    13fc:	00004097          	auipc	ra,0x4
    1400:	3c4080e7          	jalr	964(ra) # 57c0 <open>
    1404:	84aa                	mv	s1,a0
      if(fd < 0){
    1406:	06054a63          	bltz	a0,147a <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    140a:	4629                	li	a2,10
    140c:	85d6                	mv	a1,s5
    140e:	00004097          	auipc	ra,0x4
    1412:	392080e7          	jalr	914(ra) # 57a0 <write>
      if(n != 10){
    1416:	47a9                	li	a5,10
    1418:	06f51f63          	bne	a0,a5,1496 <truncate3+0xf0>
      close(fd);
    141c:	8526                	mv	a0,s1
    141e:	00004097          	auipc	ra,0x4
    1422:	38a080e7          	jalr	906(ra) # 57a8 <close>
      fd = open("truncfile", O_RDONLY);
    1426:	4581                	li	a1,0
    1428:	8552                	mv	a0,s4
    142a:	00004097          	auipc	ra,0x4
    142e:	396080e7          	jalr	918(ra) # 57c0 <open>
    1432:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1434:	02000613          	li	a2,32
    1438:	f9840593          	addi	a1,s0,-104
    143c:	00004097          	auipc	ra,0x4
    1440:	35c080e7          	jalr	860(ra) # 5798 <read>
      close(fd);
    1444:	8526                	mv	a0,s1
    1446:	00004097          	auipc	ra,0x4
    144a:	362080e7          	jalr	866(ra) # 57a8 <close>
    for(int i = 0; i < 100; i++){
    144e:	39fd                	addiw	s3,s3,-1
    1450:	fa0994e3          	bnez	s3,13f8 <truncate3+0x52>
    exit(0);
    1454:	4501                	li	a0,0
    1456:	00004097          	auipc	ra,0x4
    145a:	32a080e7          	jalr	810(ra) # 5780 <exit>
    printf("%s: fork failed\n", s);
    145e:	85ca                	mv	a1,s2
    1460:	00005517          	auipc	a0,0x5
    1464:	0e050513          	addi	a0,a0,224 # 6540 <malloc+0x976>
    1468:	00004097          	auipc	ra,0x4
    146c:	6aa080e7          	jalr	1706(ra) # 5b12 <printf>
    exit(1);
    1470:	4505                	li	a0,1
    1472:	00004097          	auipc	ra,0x4
    1476:	30e080e7          	jalr	782(ra) # 5780 <exit>
        printf("%s: open failed\n", s);
    147a:	85ca                	mv	a1,s2
    147c:	00005517          	auipc	a0,0x5
    1480:	0dc50513          	addi	a0,a0,220 # 6558 <malloc+0x98e>
    1484:	00004097          	auipc	ra,0x4
    1488:	68e080e7          	jalr	1678(ra) # 5b12 <printf>
        exit(1);
    148c:	4505                	li	a0,1
    148e:	00004097          	auipc	ra,0x4
    1492:	2f2080e7          	jalr	754(ra) # 5780 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1496:	862a                	mv	a2,a0
    1498:	85ca                	mv	a1,s2
    149a:	00005517          	auipc	a0,0x5
    149e:	0e650513          	addi	a0,a0,230 # 6580 <malloc+0x9b6>
    14a2:	00004097          	auipc	ra,0x4
    14a6:	670080e7          	jalr	1648(ra) # 5b12 <printf>
        exit(1);
    14aa:	4505                	li	a0,1
    14ac:	00004097          	auipc	ra,0x4
    14b0:	2d4080e7          	jalr	724(ra) # 5780 <exit>
    14b4:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14b8:	00005a17          	auipc	s4,0x5
    14bc:	888a0a13          	addi	s4,s4,-1912 # 5d40 <malloc+0x176>
    int n = write(fd, "xxx", 3);
    14c0:	00005a97          	auipc	s5,0x5
    14c4:	0e0a8a93          	addi	s5,s5,224 # 65a0 <malloc+0x9d6>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14c8:	60100593          	li	a1,1537
    14cc:	8552                	mv	a0,s4
    14ce:	00004097          	auipc	ra,0x4
    14d2:	2f2080e7          	jalr	754(ra) # 57c0 <open>
    14d6:	84aa                	mv	s1,a0
    if(fd < 0){
    14d8:	04054763          	bltz	a0,1526 <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    14dc:	460d                	li	a2,3
    14de:	85d6                	mv	a1,s5
    14e0:	00004097          	auipc	ra,0x4
    14e4:	2c0080e7          	jalr	704(ra) # 57a0 <write>
    if(n != 3){
    14e8:	478d                	li	a5,3
    14ea:	04f51c63          	bne	a0,a5,1542 <truncate3+0x19c>
    close(fd);
    14ee:	8526                	mv	a0,s1
    14f0:	00004097          	auipc	ra,0x4
    14f4:	2b8080e7          	jalr	696(ra) # 57a8 <close>
  for(int i = 0; i < 150; i++){
    14f8:	39fd                	addiw	s3,s3,-1
    14fa:	fc0997e3          	bnez	s3,14c8 <truncate3+0x122>
  wait(&xstatus);
    14fe:	fbc40513          	addi	a0,s0,-68
    1502:	00004097          	auipc	ra,0x4
    1506:	286080e7          	jalr	646(ra) # 5788 <wait>
  unlink("truncfile");
    150a:	00005517          	auipc	a0,0x5
    150e:	83650513          	addi	a0,a0,-1994 # 5d40 <malloc+0x176>
    1512:	00004097          	auipc	ra,0x4
    1516:	2be080e7          	jalr	702(ra) # 57d0 <unlink>
  exit(xstatus);
    151a:	fbc42503          	lw	a0,-68(s0)
    151e:	00004097          	auipc	ra,0x4
    1522:	262080e7          	jalr	610(ra) # 5780 <exit>
      printf("%s: open failed\n", s);
    1526:	85ca                	mv	a1,s2
    1528:	00005517          	auipc	a0,0x5
    152c:	03050513          	addi	a0,a0,48 # 6558 <malloc+0x98e>
    1530:	00004097          	auipc	ra,0x4
    1534:	5e2080e7          	jalr	1506(ra) # 5b12 <printf>
      exit(1);
    1538:	4505                	li	a0,1
    153a:	00004097          	auipc	ra,0x4
    153e:	246080e7          	jalr	582(ra) # 5780 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1542:	862a                	mv	a2,a0
    1544:	85ca                	mv	a1,s2
    1546:	00005517          	auipc	a0,0x5
    154a:	06250513          	addi	a0,a0,98 # 65a8 <malloc+0x9de>
    154e:	00004097          	auipc	ra,0x4
    1552:	5c4080e7          	jalr	1476(ra) # 5b12 <printf>
      exit(1);
    1556:	4505                	li	a0,1
    1558:	00004097          	auipc	ra,0x4
    155c:	228080e7          	jalr	552(ra) # 5780 <exit>

0000000000001560 <exectest>:
{
    1560:	715d                	addi	sp,sp,-80
    1562:	e486                	sd	ra,72(sp)
    1564:	e0a2                	sd	s0,64(sp)
    1566:	fc26                	sd	s1,56(sp)
    1568:	f84a                	sd	s2,48(sp)
    156a:	0880                	addi	s0,sp,80
    156c:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    156e:	00004797          	auipc	a5,0x4
    1572:	77a78793          	addi	a5,a5,1914 # 5ce8 <malloc+0x11e>
    1576:	fcf43023          	sd	a5,-64(s0)
    157a:	00005797          	auipc	a5,0x5
    157e:	04e78793          	addi	a5,a5,78 # 65c8 <malloc+0x9fe>
    1582:	fcf43423          	sd	a5,-56(s0)
    1586:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    158a:	00005517          	auipc	a0,0x5
    158e:	04650513          	addi	a0,a0,70 # 65d0 <malloc+0xa06>
    1592:	00004097          	auipc	ra,0x4
    1596:	23e080e7          	jalr	574(ra) # 57d0 <unlink>
  pid = fork();
    159a:	00004097          	auipc	ra,0x4
    159e:	1de080e7          	jalr	478(ra) # 5778 <fork>
  if(pid < 0) {
    15a2:	04054663          	bltz	a0,15ee <exectest+0x8e>
    15a6:	84aa                	mv	s1,a0
  if(pid == 0) {
    15a8:	e959                	bnez	a0,163e <exectest+0xde>
    close(1);
    15aa:	4505                	li	a0,1
    15ac:	00004097          	auipc	ra,0x4
    15b0:	1fc080e7          	jalr	508(ra) # 57a8 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    15b4:	20100593          	li	a1,513
    15b8:	00005517          	auipc	a0,0x5
    15bc:	01850513          	addi	a0,a0,24 # 65d0 <malloc+0xa06>
    15c0:	00004097          	auipc	ra,0x4
    15c4:	200080e7          	jalr	512(ra) # 57c0 <open>
    if(fd < 0) {
    15c8:	04054163          	bltz	a0,160a <exectest+0xaa>
    if(fd != 1) {
    15cc:	4785                	li	a5,1
    15ce:	04f50c63          	beq	a0,a5,1626 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    15d2:	85ca                	mv	a1,s2
    15d4:	00005517          	auipc	a0,0x5
    15d8:	01c50513          	addi	a0,a0,28 # 65f0 <malloc+0xa26>
    15dc:	00004097          	auipc	ra,0x4
    15e0:	536080e7          	jalr	1334(ra) # 5b12 <printf>
      exit(1);
    15e4:	4505                	li	a0,1
    15e6:	00004097          	auipc	ra,0x4
    15ea:	19a080e7          	jalr	410(ra) # 5780 <exit>
     printf("%s: fork failed\n", s);
    15ee:	85ca                	mv	a1,s2
    15f0:	00005517          	auipc	a0,0x5
    15f4:	f5050513          	addi	a0,a0,-176 # 6540 <malloc+0x976>
    15f8:	00004097          	auipc	ra,0x4
    15fc:	51a080e7          	jalr	1306(ra) # 5b12 <printf>
     exit(1);
    1600:	4505                	li	a0,1
    1602:	00004097          	auipc	ra,0x4
    1606:	17e080e7          	jalr	382(ra) # 5780 <exit>
      printf("%s: create failed\n", s);
    160a:	85ca                	mv	a1,s2
    160c:	00005517          	auipc	a0,0x5
    1610:	fcc50513          	addi	a0,a0,-52 # 65d8 <malloc+0xa0e>
    1614:	00004097          	auipc	ra,0x4
    1618:	4fe080e7          	jalr	1278(ra) # 5b12 <printf>
      exit(1);
    161c:	4505                	li	a0,1
    161e:	00004097          	auipc	ra,0x4
    1622:	162080e7          	jalr	354(ra) # 5780 <exit>
    if(exec("echo", echoargv) < 0){
    1626:	fc040593          	addi	a1,s0,-64
    162a:	00004517          	auipc	a0,0x4
    162e:	6be50513          	addi	a0,a0,1726 # 5ce8 <malloc+0x11e>
    1632:	00004097          	auipc	ra,0x4
    1636:	186080e7          	jalr	390(ra) # 57b8 <exec>
    163a:	02054163          	bltz	a0,165c <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    163e:	fdc40513          	addi	a0,s0,-36
    1642:	00004097          	auipc	ra,0x4
    1646:	146080e7          	jalr	326(ra) # 5788 <wait>
    164a:	02951763          	bne	a0,s1,1678 <exectest+0x118>
  if(xstatus != 0)
    164e:	fdc42503          	lw	a0,-36(s0)
    1652:	cd0d                	beqz	a0,168c <exectest+0x12c>
    exit(xstatus);
    1654:	00004097          	auipc	ra,0x4
    1658:	12c080e7          	jalr	300(ra) # 5780 <exit>
      printf("%s: exec echo failed\n", s);
    165c:	85ca                	mv	a1,s2
    165e:	00005517          	auipc	a0,0x5
    1662:	fa250513          	addi	a0,a0,-94 # 6600 <malloc+0xa36>
    1666:	00004097          	auipc	ra,0x4
    166a:	4ac080e7          	jalr	1196(ra) # 5b12 <printf>
      exit(1);
    166e:	4505                	li	a0,1
    1670:	00004097          	auipc	ra,0x4
    1674:	110080e7          	jalr	272(ra) # 5780 <exit>
    printf("%s: wait failed!\n", s);
    1678:	85ca                	mv	a1,s2
    167a:	00005517          	auipc	a0,0x5
    167e:	f9e50513          	addi	a0,a0,-98 # 6618 <malloc+0xa4e>
    1682:	00004097          	auipc	ra,0x4
    1686:	490080e7          	jalr	1168(ra) # 5b12 <printf>
    168a:	b7d1                	j	164e <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    168c:	4581                	li	a1,0
    168e:	00005517          	auipc	a0,0x5
    1692:	f4250513          	addi	a0,a0,-190 # 65d0 <malloc+0xa06>
    1696:	00004097          	auipc	ra,0x4
    169a:	12a080e7          	jalr	298(ra) # 57c0 <open>
  if(fd < 0) {
    169e:	02054a63          	bltz	a0,16d2 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    16a2:	4609                	li	a2,2
    16a4:	fb840593          	addi	a1,s0,-72
    16a8:	00004097          	auipc	ra,0x4
    16ac:	0f0080e7          	jalr	240(ra) # 5798 <read>
    16b0:	4789                	li	a5,2
    16b2:	02f50e63          	beq	a0,a5,16ee <exectest+0x18e>
    printf("%s: read failed\n", s);
    16b6:	85ca                	mv	a1,s2
    16b8:	00005517          	auipc	a0,0x5
    16bc:	9d050513          	addi	a0,a0,-1584 # 6088 <malloc+0x4be>
    16c0:	00004097          	auipc	ra,0x4
    16c4:	452080e7          	jalr	1106(ra) # 5b12 <printf>
    exit(1);
    16c8:	4505                	li	a0,1
    16ca:	00004097          	auipc	ra,0x4
    16ce:	0b6080e7          	jalr	182(ra) # 5780 <exit>
    printf("%s: open failed\n", s);
    16d2:	85ca                	mv	a1,s2
    16d4:	00005517          	auipc	a0,0x5
    16d8:	e8450513          	addi	a0,a0,-380 # 6558 <malloc+0x98e>
    16dc:	00004097          	auipc	ra,0x4
    16e0:	436080e7          	jalr	1078(ra) # 5b12 <printf>
    exit(1);
    16e4:	4505                	li	a0,1
    16e6:	00004097          	auipc	ra,0x4
    16ea:	09a080e7          	jalr	154(ra) # 5780 <exit>
  unlink("echo-ok");
    16ee:	00005517          	auipc	a0,0x5
    16f2:	ee250513          	addi	a0,a0,-286 # 65d0 <malloc+0xa06>
    16f6:	00004097          	auipc	ra,0x4
    16fa:	0da080e7          	jalr	218(ra) # 57d0 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    16fe:	fb844703          	lbu	a4,-72(s0)
    1702:	04f00793          	li	a5,79
    1706:	00f71863          	bne	a4,a5,1716 <exectest+0x1b6>
    170a:	fb944703          	lbu	a4,-71(s0)
    170e:	04b00793          	li	a5,75
    1712:	02f70063          	beq	a4,a5,1732 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    1716:	85ca                	mv	a1,s2
    1718:	00005517          	auipc	a0,0x5
    171c:	f1850513          	addi	a0,a0,-232 # 6630 <malloc+0xa66>
    1720:	00004097          	auipc	ra,0x4
    1724:	3f2080e7          	jalr	1010(ra) # 5b12 <printf>
    exit(1);
    1728:	4505                	li	a0,1
    172a:	00004097          	auipc	ra,0x4
    172e:	056080e7          	jalr	86(ra) # 5780 <exit>
    exit(0);
    1732:	4501                	li	a0,0
    1734:	00004097          	auipc	ra,0x4
    1738:	04c080e7          	jalr	76(ra) # 5780 <exit>

000000000000173c <pipe1>:
{
    173c:	711d                	addi	sp,sp,-96
    173e:	ec86                	sd	ra,88(sp)
    1740:	e8a2                	sd	s0,80(sp)
    1742:	e4a6                	sd	s1,72(sp)
    1744:	e0ca                	sd	s2,64(sp)
    1746:	fc4e                	sd	s3,56(sp)
    1748:	f852                	sd	s4,48(sp)
    174a:	f456                	sd	s5,40(sp)
    174c:	f05a                	sd	s6,32(sp)
    174e:	ec5e                	sd	s7,24(sp)
    1750:	1080                	addi	s0,sp,96
    1752:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    1754:	fa840513          	addi	a0,s0,-88
    1758:	00004097          	auipc	ra,0x4
    175c:	038080e7          	jalr	56(ra) # 5790 <pipe>
    1760:	e93d                	bnez	a0,17d6 <pipe1+0x9a>
    1762:	84aa                	mv	s1,a0
  pid = fork();
    1764:	00004097          	auipc	ra,0x4
    1768:	014080e7          	jalr	20(ra) # 5778 <fork>
    176c:	8a2a                	mv	s4,a0
  if(pid == 0){
    176e:	c151                	beqz	a0,17f2 <pipe1+0xb6>
  } else if(pid > 0){
    1770:	16a05d63          	blez	a0,18ea <pipe1+0x1ae>
    close(fds[1]);
    1774:	fac42503          	lw	a0,-84(s0)
    1778:	00004097          	auipc	ra,0x4
    177c:	030080e7          	jalr	48(ra) # 57a8 <close>
    total = 0;
    1780:	8a26                	mv	s4,s1
    cc = 1;
    1782:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    1784:	0000aa97          	auipc	s5,0xa
    1788:	564a8a93          	addi	s5,s5,1380 # bce8 <buf>
      if(cc > sizeof(buf))
    178c:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    178e:	864e                	mv	a2,s3
    1790:	85d6                	mv	a1,s5
    1792:	fa842503          	lw	a0,-88(s0)
    1796:	00004097          	auipc	ra,0x4
    179a:	002080e7          	jalr	2(ra) # 5798 <read>
    179e:	10a05163          	blez	a0,18a0 <pipe1+0x164>
      for(i = 0; i < n; i++){
    17a2:	0000a717          	auipc	a4,0xa
    17a6:	54670713          	addi	a4,a4,1350 # bce8 <buf>
    17aa:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17ae:	00074683          	lbu	a3,0(a4)
    17b2:	0ff4f793          	zext.b	a5,s1
    17b6:	2485                	addiw	s1,s1,1
    17b8:	0cf69063          	bne	a3,a5,1878 <pipe1+0x13c>
      for(i = 0; i < n; i++){
    17bc:	0705                	addi	a4,a4,1
    17be:	fec498e3          	bne	s1,a2,17ae <pipe1+0x72>
      total += n;
    17c2:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    17c6:	0019979b          	slliw	a5,s3,0x1
    17ca:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    17ce:	fd3b70e3          	bgeu	s6,s3,178e <pipe1+0x52>
        cc = sizeof(buf);
    17d2:	89da                	mv	s3,s6
    17d4:	bf6d                	j	178e <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    17d6:	85ca                	mv	a1,s2
    17d8:	00005517          	auipc	a0,0x5
    17dc:	e7050513          	addi	a0,a0,-400 # 6648 <malloc+0xa7e>
    17e0:	00004097          	auipc	ra,0x4
    17e4:	332080e7          	jalr	818(ra) # 5b12 <printf>
    exit(1);
    17e8:	4505                	li	a0,1
    17ea:	00004097          	auipc	ra,0x4
    17ee:	f96080e7          	jalr	-106(ra) # 5780 <exit>
    close(fds[0]);
    17f2:	fa842503          	lw	a0,-88(s0)
    17f6:	00004097          	auipc	ra,0x4
    17fa:	fb2080e7          	jalr	-78(ra) # 57a8 <close>
    for(n = 0; n < N; n++){
    17fe:	0000ab17          	auipc	s6,0xa
    1802:	4eab0b13          	addi	s6,s6,1258 # bce8 <buf>
    1806:	416004bb          	negw	s1,s6
    180a:	0ff4f493          	zext.b	s1,s1
    180e:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1812:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1814:	6a85                	lui	s5,0x1
    1816:	42da8a93          	addi	s5,s5,1069 # 142d <truncate3+0x87>
{
    181a:	87da                	mv	a5,s6
        buf[i] = seq++;
    181c:	0097873b          	addw	a4,a5,s1
    1820:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1824:	0785                	addi	a5,a5,1
    1826:	fef99be3          	bne	s3,a5,181c <pipe1+0xe0>
        buf[i] = seq++;
    182a:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    182e:	40900613          	li	a2,1033
    1832:	85de                	mv	a1,s7
    1834:	fac42503          	lw	a0,-84(s0)
    1838:	00004097          	auipc	ra,0x4
    183c:	f68080e7          	jalr	-152(ra) # 57a0 <write>
    1840:	40900793          	li	a5,1033
    1844:	00f51c63          	bne	a0,a5,185c <pipe1+0x120>
    for(n = 0; n < N; n++){
    1848:	24a5                	addiw	s1,s1,9
    184a:	0ff4f493          	zext.b	s1,s1
    184e:	fd5a16e3          	bne	s4,s5,181a <pipe1+0xde>
    exit(0);
    1852:	4501                	li	a0,0
    1854:	00004097          	auipc	ra,0x4
    1858:	f2c080e7          	jalr	-212(ra) # 5780 <exit>
        printf("%s: pipe1 oops 1\n", s);
    185c:	85ca                	mv	a1,s2
    185e:	00005517          	auipc	a0,0x5
    1862:	e0250513          	addi	a0,a0,-510 # 6660 <malloc+0xa96>
    1866:	00004097          	auipc	ra,0x4
    186a:	2ac080e7          	jalr	684(ra) # 5b12 <printf>
        exit(1);
    186e:	4505                	li	a0,1
    1870:	00004097          	auipc	ra,0x4
    1874:	f10080e7          	jalr	-240(ra) # 5780 <exit>
          printf("%s: pipe1 oops 2\n", s);
    1878:	85ca                	mv	a1,s2
    187a:	00005517          	auipc	a0,0x5
    187e:	dfe50513          	addi	a0,a0,-514 # 6678 <malloc+0xaae>
    1882:	00004097          	auipc	ra,0x4
    1886:	290080e7          	jalr	656(ra) # 5b12 <printf>
}
    188a:	60e6                	ld	ra,88(sp)
    188c:	6446                	ld	s0,80(sp)
    188e:	64a6                	ld	s1,72(sp)
    1890:	6906                	ld	s2,64(sp)
    1892:	79e2                	ld	s3,56(sp)
    1894:	7a42                	ld	s4,48(sp)
    1896:	7aa2                	ld	s5,40(sp)
    1898:	7b02                	ld	s6,32(sp)
    189a:	6be2                	ld	s7,24(sp)
    189c:	6125                	addi	sp,sp,96
    189e:	8082                	ret
    if(total != N * SZ){
    18a0:	6785                	lui	a5,0x1
    18a2:	42d78793          	addi	a5,a5,1069 # 142d <truncate3+0x87>
    18a6:	02fa0063          	beq	s4,a5,18c6 <pipe1+0x18a>
      printf("%s: pipe1 oops 3 total %d\n", total);
    18aa:	85d2                	mv	a1,s4
    18ac:	00005517          	auipc	a0,0x5
    18b0:	de450513          	addi	a0,a0,-540 # 6690 <malloc+0xac6>
    18b4:	00004097          	auipc	ra,0x4
    18b8:	25e080e7          	jalr	606(ra) # 5b12 <printf>
      exit(1);
    18bc:	4505                	li	a0,1
    18be:	00004097          	auipc	ra,0x4
    18c2:	ec2080e7          	jalr	-318(ra) # 5780 <exit>
    close(fds[0]);
    18c6:	fa842503          	lw	a0,-88(s0)
    18ca:	00004097          	auipc	ra,0x4
    18ce:	ede080e7          	jalr	-290(ra) # 57a8 <close>
    wait(&xstatus);
    18d2:	fa440513          	addi	a0,s0,-92
    18d6:	00004097          	auipc	ra,0x4
    18da:	eb2080e7          	jalr	-334(ra) # 5788 <wait>
    exit(xstatus);
    18de:	fa442503          	lw	a0,-92(s0)
    18e2:	00004097          	auipc	ra,0x4
    18e6:	e9e080e7          	jalr	-354(ra) # 5780 <exit>
    printf("%s: fork() failed\n", s);
    18ea:	85ca                	mv	a1,s2
    18ec:	00005517          	auipc	a0,0x5
    18f0:	dc450513          	addi	a0,a0,-572 # 66b0 <malloc+0xae6>
    18f4:	00004097          	auipc	ra,0x4
    18f8:	21e080e7          	jalr	542(ra) # 5b12 <printf>
    exit(1);
    18fc:	4505                	li	a0,1
    18fe:	00004097          	auipc	ra,0x4
    1902:	e82080e7          	jalr	-382(ra) # 5780 <exit>

0000000000001906 <exitwait>:
{
    1906:	7139                	addi	sp,sp,-64
    1908:	fc06                	sd	ra,56(sp)
    190a:	f822                	sd	s0,48(sp)
    190c:	f426                	sd	s1,40(sp)
    190e:	f04a                	sd	s2,32(sp)
    1910:	ec4e                	sd	s3,24(sp)
    1912:	e852                	sd	s4,16(sp)
    1914:	0080                	addi	s0,sp,64
    1916:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1918:	4901                	li	s2,0
    191a:	06400993          	li	s3,100
    pid = fork();
    191e:	00004097          	auipc	ra,0x4
    1922:	e5a080e7          	jalr	-422(ra) # 5778 <fork>
    1926:	84aa                	mv	s1,a0
    if(pid < 0){
    1928:	02054a63          	bltz	a0,195c <exitwait+0x56>
    if(pid){
    192c:	c151                	beqz	a0,19b0 <exitwait+0xaa>
      if(wait(&xstate) != pid){
    192e:	fcc40513          	addi	a0,s0,-52
    1932:	00004097          	auipc	ra,0x4
    1936:	e56080e7          	jalr	-426(ra) # 5788 <wait>
    193a:	02951f63          	bne	a0,s1,1978 <exitwait+0x72>
      if(i != xstate) {
    193e:	fcc42783          	lw	a5,-52(s0)
    1942:	05279963          	bne	a5,s2,1994 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    1946:	2905                	addiw	s2,s2,1
    1948:	fd391be3          	bne	s2,s3,191e <exitwait+0x18>
}
    194c:	70e2                	ld	ra,56(sp)
    194e:	7442                	ld	s0,48(sp)
    1950:	74a2                	ld	s1,40(sp)
    1952:	7902                	ld	s2,32(sp)
    1954:	69e2                	ld	s3,24(sp)
    1956:	6a42                	ld	s4,16(sp)
    1958:	6121                	addi	sp,sp,64
    195a:	8082                	ret
      printf("%s: fork failed\n", s);
    195c:	85d2                	mv	a1,s4
    195e:	00005517          	auipc	a0,0x5
    1962:	be250513          	addi	a0,a0,-1054 # 6540 <malloc+0x976>
    1966:	00004097          	auipc	ra,0x4
    196a:	1ac080e7          	jalr	428(ra) # 5b12 <printf>
      exit(1);
    196e:	4505                	li	a0,1
    1970:	00004097          	auipc	ra,0x4
    1974:	e10080e7          	jalr	-496(ra) # 5780 <exit>
        printf("%s: wait wrong pid\n", s);
    1978:	85d2                	mv	a1,s4
    197a:	00005517          	auipc	a0,0x5
    197e:	d4e50513          	addi	a0,a0,-690 # 66c8 <malloc+0xafe>
    1982:	00004097          	auipc	ra,0x4
    1986:	190080e7          	jalr	400(ra) # 5b12 <printf>
        exit(1);
    198a:	4505                	li	a0,1
    198c:	00004097          	auipc	ra,0x4
    1990:	df4080e7          	jalr	-524(ra) # 5780 <exit>
        printf("%s: wait wrong exit status\n", s);
    1994:	85d2                	mv	a1,s4
    1996:	00005517          	auipc	a0,0x5
    199a:	d4a50513          	addi	a0,a0,-694 # 66e0 <malloc+0xb16>
    199e:	00004097          	auipc	ra,0x4
    19a2:	174080e7          	jalr	372(ra) # 5b12 <printf>
        exit(1);
    19a6:	4505                	li	a0,1
    19a8:	00004097          	auipc	ra,0x4
    19ac:	dd8080e7          	jalr	-552(ra) # 5780 <exit>
      exit(i);
    19b0:	854a                	mv	a0,s2
    19b2:	00004097          	auipc	ra,0x4
    19b6:	dce080e7          	jalr	-562(ra) # 5780 <exit>

00000000000019ba <twochildren>:
{
    19ba:	1101                	addi	sp,sp,-32
    19bc:	ec06                	sd	ra,24(sp)
    19be:	e822                	sd	s0,16(sp)
    19c0:	e426                	sd	s1,8(sp)
    19c2:	e04a                	sd	s2,0(sp)
    19c4:	1000                	addi	s0,sp,32
    19c6:	892a                	mv	s2,a0
    19c8:	3e800493          	li	s1,1000
    int pid1 = fork();
    19cc:	00004097          	auipc	ra,0x4
    19d0:	dac080e7          	jalr	-596(ra) # 5778 <fork>
    if(pid1 < 0){
    19d4:	02054c63          	bltz	a0,1a0c <twochildren+0x52>
    if(pid1 == 0){
    19d8:	c921                	beqz	a0,1a28 <twochildren+0x6e>
      int pid2 = fork();
    19da:	00004097          	auipc	ra,0x4
    19de:	d9e080e7          	jalr	-610(ra) # 5778 <fork>
      if(pid2 < 0){
    19e2:	04054763          	bltz	a0,1a30 <twochildren+0x76>
      if(pid2 == 0){
    19e6:	c13d                	beqz	a0,1a4c <twochildren+0x92>
        wait(0);
    19e8:	4501                	li	a0,0
    19ea:	00004097          	auipc	ra,0x4
    19ee:	d9e080e7          	jalr	-610(ra) # 5788 <wait>
        wait(0);
    19f2:	4501                	li	a0,0
    19f4:	00004097          	auipc	ra,0x4
    19f8:	d94080e7          	jalr	-620(ra) # 5788 <wait>
  for(int i = 0; i < 1000; i++){
    19fc:	34fd                	addiw	s1,s1,-1
    19fe:	f4f9                	bnez	s1,19cc <twochildren+0x12>
}
    1a00:	60e2                	ld	ra,24(sp)
    1a02:	6442                	ld	s0,16(sp)
    1a04:	64a2                	ld	s1,8(sp)
    1a06:	6902                	ld	s2,0(sp)
    1a08:	6105                	addi	sp,sp,32
    1a0a:	8082                	ret
      printf("%s: fork failed\n", s);
    1a0c:	85ca                	mv	a1,s2
    1a0e:	00005517          	auipc	a0,0x5
    1a12:	b3250513          	addi	a0,a0,-1230 # 6540 <malloc+0x976>
    1a16:	00004097          	auipc	ra,0x4
    1a1a:	0fc080e7          	jalr	252(ra) # 5b12 <printf>
      exit(1);
    1a1e:	4505                	li	a0,1
    1a20:	00004097          	auipc	ra,0x4
    1a24:	d60080e7          	jalr	-672(ra) # 5780 <exit>
      exit(0);
    1a28:	00004097          	auipc	ra,0x4
    1a2c:	d58080e7          	jalr	-680(ra) # 5780 <exit>
        printf("%s: fork failed\n", s);
    1a30:	85ca                	mv	a1,s2
    1a32:	00005517          	auipc	a0,0x5
    1a36:	b0e50513          	addi	a0,a0,-1266 # 6540 <malloc+0x976>
    1a3a:	00004097          	auipc	ra,0x4
    1a3e:	0d8080e7          	jalr	216(ra) # 5b12 <printf>
        exit(1);
    1a42:	4505                	li	a0,1
    1a44:	00004097          	auipc	ra,0x4
    1a48:	d3c080e7          	jalr	-708(ra) # 5780 <exit>
        exit(0);
    1a4c:	00004097          	auipc	ra,0x4
    1a50:	d34080e7          	jalr	-716(ra) # 5780 <exit>

0000000000001a54 <forkfork>:
{
    1a54:	7179                	addi	sp,sp,-48
    1a56:	f406                	sd	ra,40(sp)
    1a58:	f022                	sd	s0,32(sp)
    1a5a:	ec26                	sd	s1,24(sp)
    1a5c:	1800                	addi	s0,sp,48
    1a5e:	84aa                	mv	s1,a0
    int pid = fork();
    1a60:	00004097          	auipc	ra,0x4
    1a64:	d18080e7          	jalr	-744(ra) # 5778 <fork>
    if(pid < 0){
    1a68:	04054163          	bltz	a0,1aaa <forkfork+0x56>
    if(pid == 0){
    1a6c:	cd29                	beqz	a0,1ac6 <forkfork+0x72>
    int pid = fork();
    1a6e:	00004097          	auipc	ra,0x4
    1a72:	d0a080e7          	jalr	-758(ra) # 5778 <fork>
    if(pid < 0){
    1a76:	02054a63          	bltz	a0,1aaa <forkfork+0x56>
    if(pid == 0){
    1a7a:	c531                	beqz	a0,1ac6 <forkfork+0x72>
    wait(&xstatus);
    1a7c:	fdc40513          	addi	a0,s0,-36
    1a80:	00004097          	auipc	ra,0x4
    1a84:	d08080e7          	jalr	-760(ra) # 5788 <wait>
    if(xstatus != 0) {
    1a88:	fdc42783          	lw	a5,-36(s0)
    1a8c:	ebbd                	bnez	a5,1b02 <forkfork+0xae>
    wait(&xstatus);
    1a8e:	fdc40513          	addi	a0,s0,-36
    1a92:	00004097          	auipc	ra,0x4
    1a96:	cf6080e7          	jalr	-778(ra) # 5788 <wait>
    if(xstatus != 0) {
    1a9a:	fdc42783          	lw	a5,-36(s0)
    1a9e:	e3b5                	bnez	a5,1b02 <forkfork+0xae>
}
    1aa0:	70a2                	ld	ra,40(sp)
    1aa2:	7402                	ld	s0,32(sp)
    1aa4:	64e2                	ld	s1,24(sp)
    1aa6:	6145                	addi	sp,sp,48
    1aa8:	8082                	ret
      printf("%s: fork failed", s);
    1aaa:	85a6                	mv	a1,s1
    1aac:	00005517          	auipc	a0,0x5
    1ab0:	c5450513          	addi	a0,a0,-940 # 6700 <malloc+0xb36>
    1ab4:	00004097          	auipc	ra,0x4
    1ab8:	05e080e7          	jalr	94(ra) # 5b12 <printf>
      exit(1);
    1abc:	4505                	li	a0,1
    1abe:	00004097          	auipc	ra,0x4
    1ac2:	cc2080e7          	jalr	-830(ra) # 5780 <exit>
{
    1ac6:	0c800493          	li	s1,200
        int pid1 = fork();
    1aca:	00004097          	auipc	ra,0x4
    1ace:	cae080e7          	jalr	-850(ra) # 5778 <fork>
        if(pid1 < 0){
    1ad2:	00054f63          	bltz	a0,1af0 <forkfork+0x9c>
        if(pid1 == 0){
    1ad6:	c115                	beqz	a0,1afa <forkfork+0xa6>
        wait(0);
    1ad8:	4501                	li	a0,0
    1ada:	00004097          	auipc	ra,0x4
    1ade:	cae080e7          	jalr	-850(ra) # 5788 <wait>
      for(int j = 0; j < 200; j++){
    1ae2:	34fd                	addiw	s1,s1,-1
    1ae4:	f0fd                	bnez	s1,1aca <forkfork+0x76>
      exit(0);
    1ae6:	4501                	li	a0,0
    1ae8:	00004097          	auipc	ra,0x4
    1aec:	c98080e7          	jalr	-872(ra) # 5780 <exit>
          exit(1);
    1af0:	4505                	li	a0,1
    1af2:	00004097          	auipc	ra,0x4
    1af6:	c8e080e7          	jalr	-882(ra) # 5780 <exit>
          exit(0);
    1afa:	00004097          	auipc	ra,0x4
    1afe:	c86080e7          	jalr	-890(ra) # 5780 <exit>
      printf("%s: fork in child failed", s);
    1b02:	85a6                	mv	a1,s1
    1b04:	00005517          	auipc	a0,0x5
    1b08:	c0c50513          	addi	a0,a0,-1012 # 6710 <malloc+0xb46>
    1b0c:	00004097          	auipc	ra,0x4
    1b10:	006080e7          	jalr	6(ra) # 5b12 <printf>
      exit(1);
    1b14:	4505                	li	a0,1
    1b16:	00004097          	auipc	ra,0x4
    1b1a:	c6a080e7          	jalr	-918(ra) # 5780 <exit>

0000000000001b1e <reparent2>:
{
    1b1e:	1101                	addi	sp,sp,-32
    1b20:	ec06                	sd	ra,24(sp)
    1b22:	e822                	sd	s0,16(sp)
    1b24:	e426                	sd	s1,8(sp)
    1b26:	1000                	addi	s0,sp,32
    1b28:	32000493          	li	s1,800
    int pid1 = fork();
    1b2c:	00004097          	auipc	ra,0x4
    1b30:	c4c080e7          	jalr	-948(ra) # 5778 <fork>
    if(pid1 < 0){
    1b34:	00054f63          	bltz	a0,1b52 <reparent2+0x34>
    if(pid1 == 0){
    1b38:	c915                	beqz	a0,1b6c <reparent2+0x4e>
    wait(0);
    1b3a:	4501                	li	a0,0
    1b3c:	00004097          	auipc	ra,0x4
    1b40:	c4c080e7          	jalr	-948(ra) # 5788 <wait>
  for(int i = 0; i < 800; i++){
    1b44:	34fd                	addiw	s1,s1,-1
    1b46:	f0fd                	bnez	s1,1b2c <reparent2+0xe>
  exit(0);
    1b48:	4501                	li	a0,0
    1b4a:	00004097          	auipc	ra,0x4
    1b4e:	c36080e7          	jalr	-970(ra) # 5780 <exit>
      printf("fork failed\n");
    1b52:	00005517          	auipc	a0,0x5
    1b56:	e0e50513          	addi	a0,a0,-498 # 6960 <malloc+0xd96>
    1b5a:	00004097          	auipc	ra,0x4
    1b5e:	fb8080e7          	jalr	-72(ra) # 5b12 <printf>
      exit(1);
    1b62:	4505                	li	a0,1
    1b64:	00004097          	auipc	ra,0x4
    1b68:	c1c080e7          	jalr	-996(ra) # 5780 <exit>
      fork();
    1b6c:	00004097          	auipc	ra,0x4
    1b70:	c0c080e7          	jalr	-1012(ra) # 5778 <fork>
      fork();
    1b74:	00004097          	auipc	ra,0x4
    1b78:	c04080e7          	jalr	-1020(ra) # 5778 <fork>
      exit(0);
    1b7c:	4501                	li	a0,0
    1b7e:	00004097          	auipc	ra,0x4
    1b82:	c02080e7          	jalr	-1022(ra) # 5780 <exit>

0000000000001b86 <createdelete>:
{
    1b86:	7175                	addi	sp,sp,-144
    1b88:	e506                	sd	ra,136(sp)
    1b8a:	e122                	sd	s0,128(sp)
    1b8c:	fca6                	sd	s1,120(sp)
    1b8e:	f8ca                	sd	s2,112(sp)
    1b90:	f4ce                	sd	s3,104(sp)
    1b92:	f0d2                	sd	s4,96(sp)
    1b94:	ecd6                	sd	s5,88(sp)
    1b96:	e8da                	sd	s6,80(sp)
    1b98:	e4de                	sd	s7,72(sp)
    1b9a:	e0e2                	sd	s8,64(sp)
    1b9c:	fc66                	sd	s9,56(sp)
    1b9e:	0900                	addi	s0,sp,144
    1ba0:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1ba2:	4901                	li	s2,0
    1ba4:	4991                	li	s3,4
    pid = fork();
    1ba6:	00004097          	auipc	ra,0x4
    1baa:	bd2080e7          	jalr	-1070(ra) # 5778 <fork>
    1bae:	84aa                	mv	s1,a0
    if(pid < 0){
    1bb0:	02054f63          	bltz	a0,1bee <createdelete+0x68>
    if(pid == 0){
    1bb4:	c939                	beqz	a0,1c0a <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1bb6:	2905                	addiw	s2,s2,1
    1bb8:	ff3917e3          	bne	s2,s3,1ba6 <createdelete+0x20>
    1bbc:	4491                	li	s1,4
    wait(&xstatus);
    1bbe:	f7c40513          	addi	a0,s0,-132
    1bc2:	00004097          	auipc	ra,0x4
    1bc6:	bc6080e7          	jalr	-1082(ra) # 5788 <wait>
    if(xstatus != 0)
    1bca:	f7c42903          	lw	s2,-132(s0)
    1bce:	0e091263          	bnez	s2,1cb2 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1bd2:	34fd                	addiw	s1,s1,-1
    1bd4:	f4ed                	bnez	s1,1bbe <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1bd6:	f8040123          	sb	zero,-126(s0)
    1bda:	03000993          	li	s3,48
    1bde:	5a7d                	li	s4,-1
    1be0:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1be4:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1be6:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1be8:	07400a93          	li	s5,116
    1bec:	a29d                	j	1d52 <createdelete+0x1cc>
      printf("fork failed\n", s);
    1bee:	85e6                	mv	a1,s9
    1bf0:	00005517          	auipc	a0,0x5
    1bf4:	d7050513          	addi	a0,a0,-656 # 6960 <malloc+0xd96>
    1bf8:	00004097          	auipc	ra,0x4
    1bfc:	f1a080e7          	jalr	-230(ra) # 5b12 <printf>
      exit(1);
    1c00:	4505                	li	a0,1
    1c02:	00004097          	auipc	ra,0x4
    1c06:	b7e080e7          	jalr	-1154(ra) # 5780 <exit>
      name[0] = 'p' + pi;
    1c0a:	0709091b          	addiw	s2,s2,112
    1c0e:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1c12:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1c16:	4951                	li	s2,20
    1c18:	a015                	j	1c3c <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1c1a:	85e6                	mv	a1,s9
    1c1c:	00005517          	auipc	a0,0x5
    1c20:	9bc50513          	addi	a0,a0,-1604 # 65d8 <malloc+0xa0e>
    1c24:	00004097          	auipc	ra,0x4
    1c28:	eee080e7          	jalr	-274(ra) # 5b12 <printf>
          exit(1);
    1c2c:	4505                	li	a0,1
    1c2e:	00004097          	auipc	ra,0x4
    1c32:	b52080e7          	jalr	-1198(ra) # 5780 <exit>
      for(i = 0; i < N; i++){
    1c36:	2485                	addiw	s1,s1,1
    1c38:	07248863          	beq	s1,s2,1ca8 <createdelete+0x122>
        name[1] = '0' + i;
    1c3c:	0304879b          	addiw	a5,s1,48
    1c40:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1c44:	20200593          	li	a1,514
    1c48:	f8040513          	addi	a0,s0,-128
    1c4c:	00004097          	auipc	ra,0x4
    1c50:	b74080e7          	jalr	-1164(ra) # 57c0 <open>
        if(fd < 0){
    1c54:	fc0543e3          	bltz	a0,1c1a <createdelete+0x94>
        close(fd);
    1c58:	00004097          	auipc	ra,0x4
    1c5c:	b50080e7          	jalr	-1200(ra) # 57a8 <close>
        if(i > 0 && (i % 2 ) == 0){
    1c60:	fc905be3          	blez	s1,1c36 <createdelete+0xb0>
    1c64:	0014f793          	andi	a5,s1,1
    1c68:	f7f9                	bnez	a5,1c36 <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1c6a:	01f4d79b          	srliw	a5,s1,0x1f
    1c6e:	9fa5                	addw	a5,a5,s1
    1c70:	4017d79b          	sraiw	a5,a5,0x1
    1c74:	0307879b          	addiw	a5,a5,48
    1c78:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1c7c:	f8040513          	addi	a0,s0,-128
    1c80:	00004097          	auipc	ra,0x4
    1c84:	b50080e7          	jalr	-1200(ra) # 57d0 <unlink>
    1c88:	fa0557e3          	bgez	a0,1c36 <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1c8c:	85e6                	mv	a1,s9
    1c8e:	00005517          	auipc	a0,0x5
    1c92:	aa250513          	addi	a0,a0,-1374 # 6730 <malloc+0xb66>
    1c96:	00004097          	auipc	ra,0x4
    1c9a:	e7c080e7          	jalr	-388(ra) # 5b12 <printf>
            exit(1);
    1c9e:	4505                	li	a0,1
    1ca0:	00004097          	auipc	ra,0x4
    1ca4:	ae0080e7          	jalr	-1312(ra) # 5780 <exit>
      exit(0);
    1ca8:	4501                	li	a0,0
    1caa:	00004097          	auipc	ra,0x4
    1cae:	ad6080e7          	jalr	-1322(ra) # 5780 <exit>
      exit(1);
    1cb2:	4505                	li	a0,1
    1cb4:	00004097          	auipc	ra,0x4
    1cb8:	acc080e7          	jalr	-1332(ra) # 5780 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1cbc:	f8040613          	addi	a2,s0,-128
    1cc0:	85e6                	mv	a1,s9
    1cc2:	00005517          	auipc	a0,0x5
    1cc6:	a8650513          	addi	a0,a0,-1402 # 6748 <malloc+0xb7e>
    1cca:	00004097          	auipc	ra,0x4
    1cce:	e48080e7          	jalr	-440(ra) # 5b12 <printf>
        exit(1);
    1cd2:	4505                	li	a0,1
    1cd4:	00004097          	auipc	ra,0x4
    1cd8:	aac080e7          	jalr	-1364(ra) # 5780 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1cdc:	054b7163          	bgeu	s6,s4,1d1e <createdelete+0x198>
      if(fd >= 0)
    1ce0:	02055a63          	bgez	a0,1d14 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1ce4:	2485                	addiw	s1,s1,1
    1ce6:	0ff4f493          	zext.b	s1,s1
    1cea:	05548c63          	beq	s1,s5,1d42 <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1cee:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1cf2:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1cf6:	4581                	li	a1,0
    1cf8:	f8040513          	addi	a0,s0,-128
    1cfc:	00004097          	auipc	ra,0x4
    1d00:	ac4080e7          	jalr	-1340(ra) # 57c0 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1d04:	00090463          	beqz	s2,1d0c <createdelete+0x186>
    1d08:	fd2bdae3          	bge	s7,s2,1cdc <createdelete+0x156>
    1d0c:	fa0548e3          	bltz	a0,1cbc <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d10:	014b7963          	bgeu	s6,s4,1d22 <createdelete+0x19c>
        close(fd);
    1d14:	00004097          	auipc	ra,0x4
    1d18:	a94080e7          	jalr	-1388(ra) # 57a8 <close>
    1d1c:	b7e1                	j	1ce4 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d1e:	fc0543e3          	bltz	a0,1ce4 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1d22:	f8040613          	addi	a2,s0,-128
    1d26:	85e6                	mv	a1,s9
    1d28:	00005517          	auipc	a0,0x5
    1d2c:	a4850513          	addi	a0,a0,-1464 # 6770 <malloc+0xba6>
    1d30:	00004097          	auipc	ra,0x4
    1d34:	de2080e7          	jalr	-542(ra) # 5b12 <printf>
        exit(1);
    1d38:	4505                	li	a0,1
    1d3a:	00004097          	auipc	ra,0x4
    1d3e:	a46080e7          	jalr	-1466(ra) # 5780 <exit>
  for(i = 0; i < N; i++){
    1d42:	2905                	addiw	s2,s2,1
    1d44:	2a05                	addiw	s4,s4,1
    1d46:	2985                	addiw	s3,s3,1
    1d48:	0ff9f993          	zext.b	s3,s3
    1d4c:	47d1                	li	a5,20
    1d4e:	02f90a63          	beq	s2,a5,1d82 <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1d52:	84e2                	mv	s1,s8
    1d54:	bf69                	j	1cee <createdelete+0x168>
  for(i = 0; i < N; i++){
    1d56:	2905                	addiw	s2,s2,1
    1d58:	0ff97913          	zext.b	s2,s2
    1d5c:	2985                	addiw	s3,s3,1
    1d5e:	0ff9f993          	zext.b	s3,s3
    1d62:	03490863          	beq	s2,s4,1d92 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1d66:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1d68:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1d6c:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1d70:	f8040513          	addi	a0,s0,-128
    1d74:	00004097          	auipc	ra,0x4
    1d78:	a5c080e7          	jalr	-1444(ra) # 57d0 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1d7c:	34fd                	addiw	s1,s1,-1
    1d7e:	f4ed                	bnez	s1,1d68 <createdelete+0x1e2>
    1d80:	bfd9                	j	1d56 <createdelete+0x1d0>
    1d82:	03000993          	li	s3,48
    1d86:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1d8a:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1d8c:	08400a13          	li	s4,132
    1d90:	bfd9                	j	1d66 <createdelete+0x1e0>
}
    1d92:	60aa                	ld	ra,136(sp)
    1d94:	640a                	ld	s0,128(sp)
    1d96:	74e6                	ld	s1,120(sp)
    1d98:	7946                	ld	s2,112(sp)
    1d9a:	79a6                	ld	s3,104(sp)
    1d9c:	7a06                	ld	s4,96(sp)
    1d9e:	6ae6                	ld	s5,88(sp)
    1da0:	6b46                	ld	s6,80(sp)
    1da2:	6ba6                	ld	s7,72(sp)
    1da4:	6c06                	ld	s8,64(sp)
    1da6:	7ce2                	ld	s9,56(sp)
    1da8:	6149                	addi	sp,sp,144
    1daa:	8082                	ret

0000000000001dac <linkunlink>:
{
    1dac:	711d                	addi	sp,sp,-96
    1dae:	ec86                	sd	ra,88(sp)
    1db0:	e8a2                	sd	s0,80(sp)
    1db2:	e4a6                	sd	s1,72(sp)
    1db4:	e0ca                	sd	s2,64(sp)
    1db6:	fc4e                	sd	s3,56(sp)
    1db8:	f852                	sd	s4,48(sp)
    1dba:	f456                	sd	s5,40(sp)
    1dbc:	f05a                	sd	s6,32(sp)
    1dbe:	ec5e                	sd	s7,24(sp)
    1dc0:	e862                	sd	s8,16(sp)
    1dc2:	e466                	sd	s9,8(sp)
    1dc4:	1080                	addi	s0,sp,96
    1dc6:	84aa                	mv	s1,a0
  unlink("x");
    1dc8:	00004517          	auipc	a0,0x4
    1dcc:	f9050513          	addi	a0,a0,-112 # 5d58 <malloc+0x18e>
    1dd0:	00004097          	auipc	ra,0x4
    1dd4:	a00080e7          	jalr	-1536(ra) # 57d0 <unlink>
  pid = fork();
    1dd8:	00004097          	auipc	ra,0x4
    1ddc:	9a0080e7          	jalr	-1632(ra) # 5778 <fork>
  if(pid < 0){
    1de0:	02054b63          	bltz	a0,1e16 <linkunlink+0x6a>
    1de4:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1de6:	4c85                	li	s9,1
    1de8:	e119                	bnez	a0,1dee <linkunlink+0x42>
    1dea:	06100c93          	li	s9,97
    1dee:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1df2:	41c659b7          	lui	s3,0x41c65
    1df6:	e6d9899b          	addiw	s3,s3,-403
    1dfa:	690d                	lui	s2,0x3
    1dfc:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    1e00:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1e02:	4b05                	li	s6,1
      unlink("x");
    1e04:	00004a97          	auipc	s5,0x4
    1e08:	f54a8a93          	addi	s5,s5,-172 # 5d58 <malloc+0x18e>
      link("cat", "x");
    1e0c:	00005b97          	auipc	s7,0x5
    1e10:	98cb8b93          	addi	s7,s7,-1652 # 6798 <malloc+0xbce>
    1e14:	a825                	j	1e4c <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1e16:	85a6                	mv	a1,s1
    1e18:	00004517          	auipc	a0,0x4
    1e1c:	72850513          	addi	a0,a0,1832 # 6540 <malloc+0x976>
    1e20:	00004097          	auipc	ra,0x4
    1e24:	cf2080e7          	jalr	-782(ra) # 5b12 <printf>
    exit(1);
    1e28:	4505                	li	a0,1
    1e2a:	00004097          	auipc	ra,0x4
    1e2e:	956080e7          	jalr	-1706(ra) # 5780 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1e32:	20200593          	li	a1,514
    1e36:	8556                	mv	a0,s5
    1e38:	00004097          	auipc	ra,0x4
    1e3c:	988080e7          	jalr	-1656(ra) # 57c0 <open>
    1e40:	00004097          	auipc	ra,0x4
    1e44:	968080e7          	jalr	-1688(ra) # 57a8 <close>
  for(i = 0; i < 100; i++){
    1e48:	34fd                	addiw	s1,s1,-1
    1e4a:	c88d                	beqz	s1,1e7c <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    1e4c:	033c87bb          	mulw	a5,s9,s3
    1e50:	012787bb          	addw	a5,a5,s2
    1e54:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1e58:	0347f7bb          	remuw	a5,a5,s4
    1e5c:	dbf9                	beqz	a5,1e32 <linkunlink+0x86>
    } else if((x % 3) == 1){
    1e5e:	01678863          	beq	a5,s6,1e6e <linkunlink+0xc2>
      unlink("x");
    1e62:	8556                	mv	a0,s5
    1e64:	00004097          	auipc	ra,0x4
    1e68:	96c080e7          	jalr	-1684(ra) # 57d0 <unlink>
    1e6c:	bff1                	j	1e48 <linkunlink+0x9c>
      link("cat", "x");
    1e6e:	85d6                	mv	a1,s5
    1e70:	855e                	mv	a0,s7
    1e72:	00004097          	auipc	ra,0x4
    1e76:	96e080e7          	jalr	-1682(ra) # 57e0 <link>
    1e7a:	b7f9                	j	1e48 <linkunlink+0x9c>
  if(pid)
    1e7c:	020c0463          	beqz	s8,1ea4 <linkunlink+0xf8>
    wait(0);
    1e80:	4501                	li	a0,0
    1e82:	00004097          	auipc	ra,0x4
    1e86:	906080e7          	jalr	-1786(ra) # 5788 <wait>
}
    1e8a:	60e6                	ld	ra,88(sp)
    1e8c:	6446                	ld	s0,80(sp)
    1e8e:	64a6                	ld	s1,72(sp)
    1e90:	6906                	ld	s2,64(sp)
    1e92:	79e2                	ld	s3,56(sp)
    1e94:	7a42                	ld	s4,48(sp)
    1e96:	7aa2                	ld	s5,40(sp)
    1e98:	7b02                	ld	s6,32(sp)
    1e9a:	6be2                	ld	s7,24(sp)
    1e9c:	6c42                	ld	s8,16(sp)
    1e9e:	6ca2                	ld	s9,8(sp)
    1ea0:	6125                	addi	sp,sp,96
    1ea2:	8082                	ret
    exit(0);
    1ea4:	4501                	li	a0,0
    1ea6:	00004097          	auipc	ra,0x4
    1eaa:	8da080e7          	jalr	-1830(ra) # 5780 <exit>

0000000000001eae <manywrites>:
{
    1eae:	711d                	addi	sp,sp,-96
    1eb0:	ec86                	sd	ra,88(sp)
    1eb2:	e8a2                	sd	s0,80(sp)
    1eb4:	e4a6                	sd	s1,72(sp)
    1eb6:	e0ca                	sd	s2,64(sp)
    1eb8:	fc4e                	sd	s3,56(sp)
    1eba:	f852                	sd	s4,48(sp)
    1ebc:	f456                	sd	s5,40(sp)
    1ebe:	f05a                	sd	s6,32(sp)
    1ec0:	ec5e                	sd	s7,24(sp)
    1ec2:	1080                	addi	s0,sp,96
    1ec4:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    1ec6:	4981                	li	s3,0
    1ec8:	4911                	li	s2,4
    int pid = fork();
    1eca:	00004097          	auipc	ra,0x4
    1ece:	8ae080e7          	jalr	-1874(ra) # 5778 <fork>
    1ed2:	84aa                	mv	s1,a0
    if(pid < 0){
    1ed4:	02054963          	bltz	a0,1f06 <manywrites+0x58>
    if(pid == 0){
    1ed8:	c521                	beqz	a0,1f20 <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    1eda:	2985                	addiw	s3,s3,1
    1edc:	ff2997e3          	bne	s3,s2,1eca <manywrites+0x1c>
    1ee0:	4491                	li	s1,4
    int st = 0;
    1ee2:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    1ee6:	fa840513          	addi	a0,s0,-88
    1eea:	00004097          	auipc	ra,0x4
    1eee:	89e080e7          	jalr	-1890(ra) # 5788 <wait>
    if(st != 0)
    1ef2:	fa842503          	lw	a0,-88(s0)
    1ef6:	ed6d                	bnez	a0,1ff0 <manywrites+0x142>
  for(int ci = 0; ci < nchildren; ci++){
    1ef8:	34fd                	addiw	s1,s1,-1
    1efa:	f4e5                	bnez	s1,1ee2 <manywrites+0x34>
  exit(0);
    1efc:	4501                	li	a0,0
    1efe:	00004097          	auipc	ra,0x4
    1f02:	882080e7          	jalr	-1918(ra) # 5780 <exit>
      printf("fork failed\n");
    1f06:	00005517          	auipc	a0,0x5
    1f0a:	a5a50513          	addi	a0,a0,-1446 # 6960 <malloc+0xd96>
    1f0e:	00004097          	auipc	ra,0x4
    1f12:	c04080e7          	jalr	-1020(ra) # 5b12 <printf>
      exit(1);
    1f16:	4505                	li	a0,1
    1f18:	00004097          	auipc	ra,0x4
    1f1c:	868080e7          	jalr	-1944(ra) # 5780 <exit>
      name[0] = 'b';
    1f20:	06200793          	li	a5,98
    1f24:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    1f28:	0619879b          	addiw	a5,s3,97
    1f2c:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    1f30:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    1f34:	fa840513          	addi	a0,s0,-88
    1f38:	00004097          	auipc	ra,0x4
    1f3c:	898080e7          	jalr	-1896(ra) # 57d0 <unlink>
    1f40:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    1f42:	0000ab17          	auipc	s6,0xa
    1f46:	da6b0b13          	addi	s6,s6,-602 # bce8 <buf>
        for(int i = 0; i < ci+1; i++){
    1f4a:	8a26                	mv	s4,s1
    1f4c:	0209ce63          	bltz	s3,1f88 <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    1f50:	20200593          	li	a1,514
    1f54:	fa840513          	addi	a0,s0,-88
    1f58:	00004097          	auipc	ra,0x4
    1f5c:	868080e7          	jalr	-1944(ra) # 57c0 <open>
    1f60:	892a                	mv	s2,a0
          if(fd < 0){
    1f62:	04054763          	bltz	a0,1fb0 <manywrites+0x102>
          int cc = write(fd, buf, sz);
    1f66:	660d                	lui	a2,0x3
    1f68:	85da                	mv	a1,s6
    1f6a:	00004097          	auipc	ra,0x4
    1f6e:	836080e7          	jalr	-1994(ra) # 57a0 <write>
          if(cc != sz){
    1f72:	678d                	lui	a5,0x3
    1f74:	04f51e63          	bne	a0,a5,1fd0 <manywrites+0x122>
          close(fd);
    1f78:	854a                	mv	a0,s2
    1f7a:	00004097          	auipc	ra,0x4
    1f7e:	82e080e7          	jalr	-2002(ra) # 57a8 <close>
        for(int i = 0; i < ci+1; i++){
    1f82:	2a05                	addiw	s4,s4,1
    1f84:	fd49d6e3          	bge	s3,s4,1f50 <manywrites+0xa2>
        unlink(name);
    1f88:	fa840513          	addi	a0,s0,-88
    1f8c:	00004097          	auipc	ra,0x4
    1f90:	844080e7          	jalr	-1980(ra) # 57d0 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1f94:	3bfd                	addiw	s7,s7,-1
    1f96:	fa0b9ae3          	bnez	s7,1f4a <manywrites+0x9c>
      unlink(name);
    1f9a:	fa840513          	addi	a0,s0,-88
    1f9e:	00004097          	auipc	ra,0x4
    1fa2:	832080e7          	jalr	-1998(ra) # 57d0 <unlink>
      exit(0);
    1fa6:	4501                	li	a0,0
    1fa8:	00003097          	auipc	ra,0x3
    1fac:	7d8080e7          	jalr	2008(ra) # 5780 <exit>
            printf("%s: cannot create %s\n", s, name);
    1fb0:	fa840613          	addi	a2,s0,-88
    1fb4:	85d6                	mv	a1,s5
    1fb6:	00004517          	auipc	a0,0x4
    1fba:	7ea50513          	addi	a0,a0,2026 # 67a0 <malloc+0xbd6>
    1fbe:	00004097          	auipc	ra,0x4
    1fc2:	b54080e7          	jalr	-1196(ra) # 5b12 <printf>
            exit(1);
    1fc6:	4505                	li	a0,1
    1fc8:	00003097          	auipc	ra,0x3
    1fcc:	7b8080e7          	jalr	1976(ra) # 5780 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1fd0:	86aa                	mv	a3,a0
    1fd2:	660d                	lui	a2,0x3
    1fd4:	85d6                	mv	a1,s5
    1fd6:	00004517          	auipc	a0,0x4
    1fda:	de250513          	addi	a0,a0,-542 # 5db8 <malloc+0x1ee>
    1fde:	00004097          	auipc	ra,0x4
    1fe2:	b34080e7          	jalr	-1228(ra) # 5b12 <printf>
            exit(1);
    1fe6:	4505                	li	a0,1
    1fe8:	00003097          	auipc	ra,0x3
    1fec:	798080e7          	jalr	1944(ra) # 5780 <exit>
      exit(st);
    1ff0:	00003097          	auipc	ra,0x3
    1ff4:	790080e7          	jalr	1936(ra) # 5780 <exit>

0000000000001ff8 <forktest>:
{
    1ff8:	7179                	addi	sp,sp,-48
    1ffa:	f406                	sd	ra,40(sp)
    1ffc:	f022                	sd	s0,32(sp)
    1ffe:	ec26                	sd	s1,24(sp)
    2000:	e84a                	sd	s2,16(sp)
    2002:	e44e                	sd	s3,8(sp)
    2004:	1800                	addi	s0,sp,48
    2006:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    2008:	4481                	li	s1,0
    200a:	3e800913          	li	s2,1000
    pid = fork();
    200e:	00003097          	auipc	ra,0x3
    2012:	76a080e7          	jalr	1898(ra) # 5778 <fork>
    if(pid < 0)
    2016:	02054863          	bltz	a0,2046 <forktest+0x4e>
    if(pid == 0)
    201a:	c115                	beqz	a0,203e <forktest+0x46>
  for(n=0; n<N; n++){
    201c:	2485                	addiw	s1,s1,1
    201e:	ff2498e3          	bne	s1,s2,200e <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    2022:	85ce                	mv	a1,s3
    2024:	00004517          	auipc	a0,0x4
    2028:	7ac50513          	addi	a0,a0,1964 # 67d0 <malloc+0xc06>
    202c:	00004097          	auipc	ra,0x4
    2030:	ae6080e7          	jalr	-1306(ra) # 5b12 <printf>
    exit(1);
    2034:	4505                	li	a0,1
    2036:	00003097          	auipc	ra,0x3
    203a:	74a080e7          	jalr	1866(ra) # 5780 <exit>
      exit(0);
    203e:	00003097          	auipc	ra,0x3
    2042:	742080e7          	jalr	1858(ra) # 5780 <exit>
  if (n == 0) {
    2046:	cc9d                	beqz	s1,2084 <forktest+0x8c>
  if(n == N){
    2048:	3e800793          	li	a5,1000
    204c:	fcf48be3          	beq	s1,a5,2022 <forktest+0x2a>
  for(; n > 0; n--){
    2050:	00905b63          	blez	s1,2066 <forktest+0x6e>
    if(wait(0) < 0){
    2054:	4501                	li	a0,0
    2056:	00003097          	auipc	ra,0x3
    205a:	732080e7          	jalr	1842(ra) # 5788 <wait>
    205e:	04054163          	bltz	a0,20a0 <forktest+0xa8>
  for(; n > 0; n--){
    2062:	34fd                	addiw	s1,s1,-1
    2064:	f8e5                	bnez	s1,2054 <forktest+0x5c>
  if(wait(0) != -1){
    2066:	4501                	li	a0,0
    2068:	00003097          	auipc	ra,0x3
    206c:	720080e7          	jalr	1824(ra) # 5788 <wait>
    2070:	57fd                	li	a5,-1
    2072:	04f51563          	bne	a0,a5,20bc <forktest+0xc4>
}
    2076:	70a2                	ld	ra,40(sp)
    2078:	7402                	ld	s0,32(sp)
    207a:	64e2                	ld	s1,24(sp)
    207c:	6942                	ld	s2,16(sp)
    207e:	69a2                	ld	s3,8(sp)
    2080:	6145                	addi	sp,sp,48
    2082:	8082                	ret
    printf("%s: no fork at all!\n", s);
    2084:	85ce                	mv	a1,s3
    2086:	00004517          	auipc	a0,0x4
    208a:	73250513          	addi	a0,a0,1842 # 67b8 <malloc+0xbee>
    208e:	00004097          	auipc	ra,0x4
    2092:	a84080e7          	jalr	-1404(ra) # 5b12 <printf>
    exit(1);
    2096:	4505                	li	a0,1
    2098:	00003097          	auipc	ra,0x3
    209c:	6e8080e7          	jalr	1768(ra) # 5780 <exit>
      printf("%s: wait stopped early\n", s);
    20a0:	85ce                	mv	a1,s3
    20a2:	00004517          	auipc	a0,0x4
    20a6:	75650513          	addi	a0,a0,1878 # 67f8 <malloc+0xc2e>
    20aa:	00004097          	auipc	ra,0x4
    20ae:	a68080e7          	jalr	-1432(ra) # 5b12 <printf>
      exit(1);
    20b2:	4505                	li	a0,1
    20b4:	00003097          	auipc	ra,0x3
    20b8:	6cc080e7          	jalr	1740(ra) # 5780 <exit>
    printf("%s: wait got too many\n", s);
    20bc:	85ce                	mv	a1,s3
    20be:	00004517          	auipc	a0,0x4
    20c2:	75250513          	addi	a0,a0,1874 # 6810 <malloc+0xc46>
    20c6:	00004097          	auipc	ra,0x4
    20ca:	a4c080e7          	jalr	-1460(ra) # 5b12 <printf>
    exit(1);
    20ce:	4505                	li	a0,1
    20d0:	00003097          	auipc	ra,0x3
    20d4:	6b0080e7          	jalr	1712(ra) # 5780 <exit>

00000000000020d8 <kernmem>:
{
    20d8:	715d                	addi	sp,sp,-80
    20da:	e486                	sd	ra,72(sp)
    20dc:	e0a2                	sd	s0,64(sp)
    20de:	fc26                	sd	s1,56(sp)
    20e0:	f84a                	sd	s2,48(sp)
    20e2:	f44e                	sd	s3,40(sp)
    20e4:	f052                	sd	s4,32(sp)
    20e6:	ec56                	sd	s5,24(sp)
    20e8:	0880                	addi	s0,sp,80
    20ea:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    20ec:	4485                	li	s1,1
    20ee:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    20f0:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    20f2:	69b1                	lui	s3,0xc
    20f4:	35098993          	addi	s3,s3,848 # c350 <buf+0x668>
    20f8:	1003d937          	lui	s2,0x1003d
    20fc:	090e                	slli	s2,s2,0x3
    20fe:	48090913          	addi	s2,s2,1152 # 1003d480 <__BSS_END__+0x1002e788>
    pid = fork();
    2102:	00003097          	auipc	ra,0x3
    2106:	676080e7          	jalr	1654(ra) # 5778 <fork>
    if(pid < 0){
    210a:	02054963          	bltz	a0,213c <kernmem+0x64>
    if(pid == 0){
    210e:	c529                	beqz	a0,2158 <kernmem+0x80>
    wait(&xstatus);
    2110:	fbc40513          	addi	a0,s0,-68
    2114:	00003097          	auipc	ra,0x3
    2118:	674080e7          	jalr	1652(ra) # 5788 <wait>
    if(xstatus != -1)  // did kernel kill child?
    211c:	fbc42783          	lw	a5,-68(s0)
    2120:	05579d63          	bne	a5,s5,217a <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2124:	94ce                	add	s1,s1,s3
    2126:	fd249ee3          	bne	s1,s2,2102 <kernmem+0x2a>
}
    212a:	60a6                	ld	ra,72(sp)
    212c:	6406                	ld	s0,64(sp)
    212e:	74e2                	ld	s1,56(sp)
    2130:	7942                	ld	s2,48(sp)
    2132:	79a2                	ld	s3,40(sp)
    2134:	7a02                	ld	s4,32(sp)
    2136:	6ae2                	ld	s5,24(sp)
    2138:	6161                	addi	sp,sp,80
    213a:	8082                	ret
      printf("%s: fork failed\n", s);
    213c:	85d2                	mv	a1,s4
    213e:	00004517          	auipc	a0,0x4
    2142:	40250513          	addi	a0,a0,1026 # 6540 <malloc+0x976>
    2146:	00004097          	auipc	ra,0x4
    214a:	9cc080e7          	jalr	-1588(ra) # 5b12 <printf>
      exit(1);
    214e:	4505                	li	a0,1
    2150:	00003097          	auipc	ra,0x3
    2154:	630080e7          	jalr	1584(ra) # 5780 <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    2158:	0004c683          	lbu	a3,0(s1)
    215c:	8626                	mv	a2,s1
    215e:	85d2                	mv	a1,s4
    2160:	00004517          	auipc	a0,0x4
    2164:	6c850513          	addi	a0,a0,1736 # 6828 <malloc+0xc5e>
    2168:	00004097          	auipc	ra,0x4
    216c:	9aa080e7          	jalr	-1622(ra) # 5b12 <printf>
      exit(1);
    2170:	4505                	li	a0,1
    2172:	00003097          	auipc	ra,0x3
    2176:	60e080e7          	jalr	1550(ra) # 5780 <exit>
      exit(1);
    217a:	4505                	li	a0,1
    217c:	00003097          	auipc	ra,0x3
    2180:	604080e7          	jalr	1540(ra) # 5780 <exit>

0000000000002184 <MAXVAplus>:
{
    2184:	7179                	addi	sp,sp,-48
    2186:	f406                	sd	ra,40(sp)
    2188:	f022                	sd	s0,32(sp)
    218a:	ec26                	sd	s1,24(sp)
    218c:	e84a                	sd	s2,16(sp)
    218e:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    2190:	4785                	li	a5,1
    2192:	179a                	slli	a5,a5,0x26
    2194:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    2198:	fd843783          	ld	a5,-40(s0)
    219c:	cf85                	beqz	a5,21d4 <MAXVAplus+0x50>
    219e:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    21a0:	54fd                	li	s1,-1
    pid = fork();
    21a2:	00003097          	auipc	ra,0x3
    21a6:	5d6080e7          	jalr	1494(ra) # 5778 <fork>
    if(pid < 0){
    21aa:	02054b63          	bltz	a0,21e0 <MAXVAplus+0x5c>
    if(pid == 0){
    21ae:	c539                	beqz	a0,21fc <MAXVAplus+0x78>
    wait(&xstatus);
    21b0:	fd440513          	addi	a0,s0,-44
    21b4:	00003097          	auipc	ra,0x3
    21b8:	5d4080e7          	jalr	1492(ra) # 5788 <wait>
    if(xstatus != -1)  // did kernel kill child?
    21bc:	fd442783          	lw	a5,-44(s0)
    21c0:	06979463          	bne	a5,s1,2228 <MAXVAplus+0xa4>
  for( ; a != 0; a <<= 1){
    21c4:	fd843783          	ld	a5,-40(s0)
    21c8:	0786                	slli	a5,a5,0x1
    21ca:	fcf43c23          	sd	a5,-40(s0)
    21ce:	fd843783          	ld	a5,-40(s0)
    21d2:	fbe1                	bnez	a5,21a2 <MAXVAplus+0x1e>
}
    21d4:	70a2                	ld	ra,40(sp)
    21d6:	7402                	ld	s0,32(sp)
    21d8:	64e2                	ld	s1,24(sp)
    21da:	6942                	ld	s2,16(sp)
    21dc:	6145                	addi	sp,sp,48
    21de:	8082                	ret
      printf("%s: fork failed\n", s);
    21e0:	85ca                	mv	a1,s2
    21e2:	00004517          	auipc	a0,0x4
    21e6:	35e50513          	addi	a0,a0,862 # 6540 <malloc+0x976>
    21ea:	00004097          	auipc	ra,0x4
    21ee:	928080e7          	jalr	-1752(ra) # 5b12 <printf>
      exit(1);
    21f2:	4505                	li	a0,1
    21f4:	00003097          	auipc	ra,0x3
    21f8:	58c080e7          	jalr	1420(ra) # 5780 <exit>
      *(char*)a = 99;
    21fc:	fd843783          	ld	a5,-40(s0)
    2200:	06300713          	li	a4,99
    2204:	00e78023          	sb	a4,0(a5) # 3000 <iputtest+0x8c>
      printf("%s: oops wrote %x\n", s, a);
    2208:	fd843603          	ld	a2,-40(s0)
    220c:	85ca                	mv	a1,s2
    220e:	00004517          	auipc	a0,0x4
    2212:	63a50513          	addi	a0,a0,1594 # 6848 <malloc+0xc7e>
    2216:	00004097          	auipc	ra,0x4
    221a:	8fc080e7          	jalr	-1796(ra) # 5b12 <printf>
      exit(1);
    221e:	4505                	li	a0,1
    2220:	00003097          	auipc	ra,0x3
    2224:	560080e7          	jalr	1376(ra) # 5780 <exit>
      exit(1);
    2228:	4505                	li	a0,1
    222a:	00003097          	auipc	ra,0x3
    222e:	556080e7          	jalr	1366(ra) # 5780 <exit>

0000000000002232 <bigargtest>:
{
    2232:	7179                	addi	sp,sp,-48
    2234:	f406                	sd	ra,40(sp)
    2236:	f022                	sd	s0,32(sp)
    2238:	ec26                	sd	s1,24(sp)
    223a:	1800                	addi	s0,sp,48
    223c:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    223e:	00004517          	auipc	a0,0x4
    2242:	62250513          	addi	a0,a0,1570 # 6860 <malloc+0xc96>
    2246:	00003097          	auipc	ra,0x3
    224a:	58a080e7          	jalr	1418(ra) # 57d0 <unlink>
  pid = fork();
    224e:	00003097          	auipc	ra,0x3
    2252:	52a080e7          	jalr	1322(ra) # 5778 <fork>
  if(pid == 0){
    2256:	c121                	beqz	a0,2296 <bigargtest+0x64>
  } else if(pid < 0){
    2258:	0a054063          	bltz	a0,22f8 <bigargtest+0xc6>
  wait(&xstatus);
    225c:	fdc40513          	addi	a0,s0,-36
    2260:	00003097          	auipc	ra,0x3
    2264:	528080e7          	jalr	1320(ra) # 5788 <wait>
  if(xstatus != 0)
    2268:	fdc42503          	lw	a0,-36(s0)
    226c:	e545                	bnez	a0,2314 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    226e:	4581                	li	a1,0
    2270:	00004517          	auipc	a0,0x4
    2274:	5f050513          	addi	a0,a0,1520 # 6860 <malloc+0xc96>
    2278:	00003097          	auipc	ra,0x3
    227c:	548080e7          	jalr	1352(ra) # 57c0 <open>
  if(fd < 0){
    2280:	08054e63          	bltz	a0,231c <bigargtest+0xea>
  close(fd);
    2284:	00003097          	auipc	ra,0x3
    2288:	524080e7          	jalr	1316(ra) # 57a8 <close>
}
    228c:	70a2                	ld	ra,40(sp)
    228e:	7402                	ld	s0,32(sp)
    2290:	64e2                	ld	s1,24(sp)
    2292:	6145                	addi	sp,sp,48
    2294:	8082                	ret
    2296:	00006797          	auipc	a5,0x6
    229a:	23a78793          	addi	a5,a5,570 # 84d0 <args.1>
    229e:	00006697          	auipc	a3,0x6
    22a2:	32a68693          	addi	a3,a3,810 # 85c8 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    22a6:	00004717          	auipc	a4,0x4
    22aa:	5ca70713          	addi	a4,a4,1482 # 6870 <malloc+0xca6>
    22ae:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    22b0:	07a1                	addi	a5,a5,8
    22b2:	fed79ee3          	bne	a5,a3,22ae <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    22b6:	00006597          	auipc	a1,0x6
    22ba:	21a58593          	addi	a1,a1,538 # 84d0 <args.1>
    22be:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    22c2:	00004517          	auipc	a0,0x4
    22c6:	a2650513          	addi	a0,a0,-1498 # 5ce8 <malloc+0x11e>
    22ca:	00003097          	auipc	ra,0x3
    22ce:	4ee080e7          	jalr	1262(ra) # 57b8 <exec>
    fd = open("bigarg-ok", O_CREATE);
    22d2:	20000593          	li	a1,512
    22d6:	00004517          	auipc	a0,0x4
    22da:	58a50513          	addi	a0,a0,1418 # 6860 <malloc+0xc96>
    22de:	00003097          	auipc	ra,0x3
    22e2:	4e2080e7          	jalr	1250(ra) # 57c0 <open>
    close(fd);
    22e6:	00003097          	auipc	ra,0x3
    22ea:	4c2080e7          	jalr	1218(ra) # 57a8 <close>
    exit(0);
    22ee:	4501                	li	a0,0
    22f0:	00003097          	auipc	ra,0x3
    22f4:	490080e7          	jalr	1168(ra) # 5780 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    22f8:	85a6                	mv	a1,s1
    22fa:	00004517          	auipc	a0,0x4
    22fe:	65650513          	addi	a0,a0,1622 # 6950 <malloc+0xd86>
    2302:	00004097          	auipc	ra,0x4
    2306:	810080e7          	jalr	-2032(ra) # 5b12 <printf>
    exit(1);
    230a:	4505                	li	a0,1
    230c:	00003097          	auipc	ra,0x3
    2310:	474080e7          	jalr	1140(ra) # 5780 <exit>
    exit(xstatus);
    2314:	00003097          	auipc	ra,0x3
    2318:	46c080e7          	jalr	1132(ra) # 5780 <exit>
    printf("%s: bigarg test failed!\n", s);
    231c:	85a6                	mv	a1,s1
    231e:	00004517          	auipc	a0,0x4
    2322:	65250513          	addi	a0,a0,1618 # 6970 <malloc+0xda6>
    2326:	00003097          	auipc	ra,0x3
    232a:	7ec080e7          	jalr	2028(ra) # 5b12 <printf>
    exit(1);
    232e:	4505                	li	a0,1
    2330:	00003097          	auipc	ra,0x3
    2334:	450080e7          	jalr	1104(ra) # 5780 <exit>

0000000000002338 <stacktest>:
{
    2338:	7179                	addi	sp,sp,-48
    233a:	f406                	sd	ra,40(sp)
    233c:	f022                	sd	s0,32(sp)
    233e:	ec26                	sd	s1,24(sp)
    2340:	1800                	addi	s0,sp,48
    2342:	84aa                	mv	s1,a0
  pid = fork();
    2344:	00003097          	auipc	ra,0x3
    2348:	434080e7          	jalr	1076(ra) # 5778 <fork>
  if(pid == 0) {
    234c:	c115                	beqz	a0,2370 <stacktest+0x38>
  } else if(pid < 0){
    234e:	04054463          	bltz	a0,2396 <stacktest+0x5e>
  wait(&xstatus);
    2352:	fdc40513          	addi	a0,s0,-36
    2356:	00003097          	auipc	ra,0x3
    235a:	432080e7          	jalr	1074(ra) # 5788 <wait>
  if(xstatus == -1)  // kernel killed child?
    235e:	fdc42503          	lw	a0,-36(s0)
    2362:	57fd                	li	a5,-1
    2364:	04f50763          	beq	a0,a5,23b2 <stacktest+0x7a>
    exit(xstatus);
    2368:	00003097          	auipc	ra,0x3
    236c:	418080e7          	jalr	1048(ra) # 5780 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    2370:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    2372:	77fd                	lui	a5,0xfffff
    2374:	97ba                	add	a5,a5,a4
    2376:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff0308>
    237a:	85a6                	mv	a1,s1
    237c:	00004517          	auipc	a0,0x4
    2380:	61450513          	addi	a0,a0,1556 # 6990 <malloc+0xdc6>
    2384:	00003097          	auipc	ra,0x3
    2388:	78e080e7          	jalr	1934(ra) # 5b12 <printf>
    exit(1);
    238c:	4505                	li	a0,1
    238e:	00003097          	auipc	ra,0x3
    2392:	3f2080e7          	jalr	1010(ra) # 5780 <exit>
    printf("%s: fork failed\n", s);
    2396:	85a6                	mv	a1,s1
    2398:	00004517          	auipc	a0,0x4
    239c:	1a850513          	addi	a0,a0,424 # 6540 <malloc+0x976>
    23a0:	00003097          	auipc	ra,0x3
    23a4:	772080e7          	jalr	1906(ra) # 5b12 <printf>
    exit(1);
    23a8:	4505                	li	a0,1
    23aa:	00003097          	auipc	ra,0x3
    23ae:	3d6080e7          	jalr	982(ra) # 5780 <exit>
    exit(0);
    23b2:	4501                	li	a0,0
    23b4:	00003097          	auipc	ra,0x3
    23b8:	3cc080e7          	jalr	972(ra) # 5780 <exit>

00000000000023bc <copyinstr3>:
{
    23bc:	7179                	addi	sp,sp,-48
    23be:	f406                	sd	ra,40(sp)
    23c0:	f022                	sd	s0,32(sp)
    23c2:	ec26                	sd	s1,24(sp)
    23c4:	1800                	addi	s0,sp,48
  sbrk(8192);
    23c6:	6509                	lui	a0,0x2
    23c8:	00003097          	auipc	ra,0x3
    23cc:	440080e7          	jalr	1088(ra) # 5808 <sbrk>
  uint64 top = (uint64) sbrk(0);
    23d0:	4501                	li	a0,0
    23d2:	00003097          	auipc	ra,0x3
    23d6:	436080e7          	jalr	1078(ra) # 5808 <sbrk>
  if((top % PGSIZE) != 0){
    23da:	03451793          	slli	a5,a0,0x34
    23de:	e3c9                	bnez	a5,2460 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    23e0:	4501                	li	a0,0
    23e2:	00003097          	auipc	ra,0x3
    23e6:	426080e7          	jalr	1062(ra) # 5808 <sbrk>
  if(top % PGSIZE){
    23ea:	03451793          	slli	a5,a0,0x34
    23ee:	e3d9                	bnez	a5,2474 <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    23f0:	fff50493          	addi	s1,a0,-1 # 1fff <forktest+0x7>
  *b = 'x';
    23f4:	07800793          	li	a5,120
    23f8:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    23fc:	8526                	mv	a0,s1
    23fe:	00003097          	auipc	ra,0x3
    2402:	3d2080e7          	jalr	978(ra) # 57d0 <unlink>
  if(ret != -1){
    2406:	57fd                	li	a5,-1
    2408:	08f51363          	bne	a0,a5,248e <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    240c:	20100593          	li	a1,513
    2410:	8526                	mv	a0,s1
    2412:	00003097          	auipc	ra,0x3
    2416:	3ae080e7          	jalr	942(ra) # 57c0 <open>
  if(fd != -1){
    241a:	57fd                	li	a5,-1
    241c:	08f51863          	bne	a0,a5,24ac <copyinstr3+0xf0>
  ret = link(b, b);
    2420:	85a6                	mv	a1,s1
    2422:	8526                	mv	a0,s1
    2424:	00003097          	auipc	ra,0x3
    2428:	3bc080e7          	jalr	956(ra) # 57e0 <link>
  if(ret != -1){
    242c:	57fd                	li	a5,-1
    242e:	08f51e63          	bne	a0,a5,24ca <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    2432:	00005797          	auipc	a5,0x5
    2436:	20678793          	addi	a5,a5,518 # 7638 <malloc+0x1a6e>
    243a:	fcf43823          	sd	a5,-48(s0)
    243e:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2442:	fd040593          	addi	a1,s0,-48
    2446:	8526                	mv	a0,s1
    2448:	00003097          	auipc	ra,0x3
    244c:	370080e7          	jalr	880(ra) # 57b8 <exec>
  if(ret != -1){
    2450:	57fd                	li	a5,-1
    2452:	08f51c63          	bne	a0,a5,24ea <copyinstr3+0x12e>
}
    2456:	70a2                	ld	ra,40(sp)
    2458:	7402                	ld	s0,32(sp)
    245a:	64e2                	ld	s1,24(sp)
    245c:	6145                	addi	sp,sp,48
    245e:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2460:	0347d513          	srli	a0,a5,0x34
    2464:	6785                	lui	a5,0x1
    2466:	40a7853b          	subw	a0,a5,a0
    246a:	00003097          	auipc	ra,0x3
    246e:	39e080e7          	jalr	926(ra) # 5808 <sbrk>
    2472:	b7bd                	j	23e0 <copyinstr3+0x24>
    printf("oops\n");
    2474:	00004517          	auipc	a0,0x4
    2478:	54450513          	addi	a0,a0,1348 # 69b8 <malloc+0xdee>
    247c:	00003097          	auipc	ra,0x3
    2480:	696080e7          	jalr	1686(ra) # 5b12 <printf>
    exit(1);
    2484:	4505                	li	a0,1
    2486:	00003097          	auipc	ra,0x3
    248a:	2fa080e7          	jalr	762(ra) # 5780 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    248e:	862a                	mv	a2,a0
    2490:	85a6                	mv	a1,s1
    2492:	00004517          	auipc	a0,0x4
    2496:	fce50513          	addi	a0,a0,-50 # 6460 <malloc+0x896>
    249a:	00003097          	auipc	ra,0x3
    249e:	678080e7          	jalr	1656(ra) # 5b12 <printf>
    exit(1);
    24a2:	4505                	li	a0,1
    24a4:	00003097          	auipc	ra,0x3
    24a8:	2dc080e7          	jalr	732(ra) # 5780 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    24ac:	862a                	mv	a2,a0
    24ae:	85a6                	mv	a1,s1
    24b0:	00004517          	auipc	a0,0x4
    24b4:	fd050513          	addi	a0,a0,-48 # 6480 <malloc+0x8b6>
    24b8:	00003097          	auipc	ra,0x3
    24bc:	65a080e7          	jalr	1626(ra) # 5b12 <printf>
    exit(1);
    24c0:	4505                	li	a0,1
    24c2:	00003097          	auipc	ra,0x3
    24c6:	2be080e7          	jalr	702(ra) # 5780 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    24ca:	86aa                	mv	a3,a0
    24cc:	8626                	mv	a2,s1
    24ce:	85a6                	mv	a1,s1
    24d0:	00004517          	auipc	a0,0x4
    24d4:	fd050513          	addi	a0,a0,-48 # 64a0 <malloc+0x8d6>
    24d8:	00003097          	auipc	ra,0x3
    24dc:	63a080e7          	jalr	1594(ra) # 5b12 <printf>
    exit(1);
    24e0:	4505                	li	a0,1
    24e2:	00003097          	auipc	ra,0x3
    24e6:	29e080e7          	jalr	670(ra) # 5780 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    24ea:	567d                	li	a2,-1
    24ec:	85a6                	mv	a1,s1
    24ee:	00004517          	auipc	a0,0x4
    24f2:	fda50513          	addi	a0,a0,-38 # 64c8 <malloc+0x8fe>
    24f6:	00003097          	auipc	ra,0x3
    24fa:	61c080e7          	jalr	1564(ra) # 5b12 <printf>
    exit(1);
    24fe:	4505                	li	a0,1
    2500:	00003097          	auipc	ra,0x3
    2504:	280080e7          	jalr	640(ra) # 5780 <exit>

0000000000002508 <rwsbrk>:
{
    2508:	1101                	addi	sp,sp,-32
    250a:	ec06                	sd	ra,24(sp)
    250c:	e822                	sd	s0,16(sp)
    250e:	e426                	sd	s1,8(sp)
    2510:	e04a                	sd	s2,0(sp)
    2512:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    2514:	6509                	lui	a0,0x2
    2516:	00003097          	auipc	ra,0x3
    251a:	2f2080e7          	jalr	754(ra) # 5808 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    251e:	57fd                	li	a5,-1
    2520:	06f50263          	beq	a0,a5,2584 <rwsbrk+0x7c>
    2524:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    2526:	7579                	lui	a0,0xffffe
    2528:	00003097          	auipc	ra,0x3
    252c:	2e0080e7          	jalr	736(ra) # 5808 <sbrk>
    2530:	57fd                	li	a5,-1
    2532:	06f50663          	beq	a0,a5,259e <rwsbrk+0x96>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    2536:	20100593          	li	a1,513
    253a:	00004517          	auipc	a0,0x4
    253e:	4be50513          	addi	a0,a0,1214 # 69f8 <malloc+0xe2e>
    2542:	00003097          	auipc	ra,0x3
    2546:	27e080e7          	jalr	638(ra) # 57c0 <open>
    254a:	892a                	mv	s2,a0
  if(fd < 0){
    254c:	06054663          	bltz	a0,25b8 <rwsbrk+0xb0>
  n = write(fd, (void*)(a+4096), 1024);
    2550:	6785                	lui	a5,0x1
    2552:	94be                	add	s1,s1,a5
    2554:	40000613          	li	a2,1024
    2558:	85a6                	mv	a1,s1
    255a:	00003097          	auipc	ra,0x3
    255e:	246080e7          	jalr	582(ra) # 57a0 <write>
    2562:	862a                	mv	a2,a0
  if(n >= 0){
    2564:	06054763          	bltz	a0,25d2 <rwsbrk+0xca>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    2568:	85a6                	mv	a1,s1
    256a:	00004517          	auipc	a0,0x4
    256e:	4ae50513          	addi	a0,a0,1198 # 6a18 <malloc+0xe4e>
    2572:	00003097          	auipc	ra,0x3
    2576:	5a0080e7          	jalr	1440(ra) # 5b12 <printf>
    exit(1);
    257a:	4505                	li	a0,1
    257c:	00003097          	auipc	ra,0x3
    2580:	204080e7          	jalr	516(ra) # 5780 <exit>
    printf("sbrk(rwsbrk) failed\n");
    2584:	00004517          	auipc	a0,0x4
    2588:	43c50513          	addi	a0,a0,1084 # 69c0 <malloc+0xdf6>
    258c:	00003097          	auipc	ra,0x3
    2590:	586080e7          	jalr	1414(ra) # 5b12 <printf>
    exit(1);
    2594:	4505                	li	a0,1
    2596:	00003097          	auipc	ra,0x3
    259a:	1ea080e7          	jalr	490(ra) # 5780 <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    259e:	00004517          	auipc	a0,0x4
    25a2:	43a50513          	addi	a0,a0,1082 # 69d8 <malloc+0xe0e>
    25a6:	00003097          	auipc	ra,0x3
    25aa:	56c080e7          	jalr	1388(ra) # 5b12 <printf>
    exit(1);
    25ae:	4505                	li	a0,1
    25b0:	00003097          	auipc	ra,0x3
    25b4:	1d0080e7          	jalr	464(ra) # 5780 <exit>
    printf("open(rwsbrk) failed\n");
    25b8:	00004517          	auipc	a0,0x4
    25bc:	44850513          	addi	a0,a0,1096 # 6a00 <malloc+0xe36>
    25c0:	00003097          	auipc	ra,0x3
    25c4:	552080e7          	jalr	1362(ra) # 5b12 <printf>
    exit(1);
    25c8:	4505                	li	a0,1
    25ca:	00003097          	auipc	ra,0x3
    25ce:	1b6080e7          	jalr	438(ra) # 5780 <exit>
  close(fd);
    25d2:	854a                	mv	a0,s2
    25d4:	00003097          	auipc	ra,0x3
    25d8:	1d4080e7          	jalr	468(ra) # 57a8 <close>
  unlink("rwsbrk");
    25dc:	00004517          	auipc	a0,0x4
    25e0:	41c50513          	addi	a0,a0,1052 # 69f8 <malloc+0xe2e>
    25e4:	00003097          	auipc	ra,0x3
    25e8:	1ec080e7          	jalr	492(ra) # 57d0 <unlink>
  fd = open("README", O_RDONLY);
    25ec:	4581                	li	a1,0
    25ee:	00004517          	auipc	a0,0x4
    25f2:	8a250513          	addi	a0,a0,-1886 # 5e90 <malloc+0x2c6>
    25f6:	00003097          	auipc	ra,0x3
    25fa:	1ca080e7          	jalr	458(ra) # 57c0 <open>
    25fe:	892a                	mv	s2,a0
  if(fd < 0){
    2600:	02054963          	bltz	a0,2632 <rwsbrk+0x12a>
  n = read(fd, (void*)(a+4096), 10);
    2604:	4629                	li	a2,10
    2606:	85a6                	mv	a1,s1
    2608:	00003097          	auipc	ra,0x3
    260c:	190080e7          	jalr	400(ra) # 5798 <read>
    2610:	862a                	mv	a2,a0
  if(n >= 0){
    2612:	02054d63          	bltz	a0,264c <rwsbrk+0x144>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    2616:	85a6                	mv	a1,s1
    2618:	00004517          	auipc	a0,0x4
    261c:	43050513          	addi	a0,a0,1072 # 6a48 <malloc+0xe7e>
    2620:	00003097          	auipc	ra,0x3
    2624:	4f2080e7          	jalr	1266(ra) # 5b12 <printf>
    exit(1);
    2628:	4505                	li	a0,1
    262a:	00003097          	auipc	ra,0x3
    262e:	156080e7          	jalr	342(ra) # 5780 <exit>
    printf("open(rwsbrk) failed\n");
    2632:	00004517          	auipc	a0,0x4
    2636:	3ce50513          	addi	a0,a0,974 # 6a00 <malloc+0xe36>
    263a:	00003097          	auipc	ra,0x3
    263e:	4d8080e7          	jalr	1240(ra) # 5b12 <printf>
    exit(1);
    2642:	4505                	li	a0,1
    2644:	00003097          	auipc	ra,0x3
    2648:	13c080e7          	jalr	316(ra) # 5780 <exit>
  close(fd);
    264c:	854a                	mv	a0,s2
    264e:	00003097          	auipc	ra,0x3
    2652:	15a080e7          	jalr	346(ra) # 57a8 <close>
  exit(0);
    2656:	4501                	li	a0,0
    2658:	00003097          	auipc	ra,0x3
    265c:	128080e7          	jalr	296(ra) # 5780 <exit>

0000000000002660 <sbrkbasic>:
{
    2660:	7139                	addi	sp,sp,-64
    2662:	fc06                	sd	ra,56(sp)
    2664:	f822                	sd	s0,48(sp)
    2666:	f426                	sd	s1,40(sp)
    2668:	f04a                	sd	s2,32(sp)
    266a:	ec4e                	sd	s3,24(sp)
    266c:	e852                	sd	s4,16(sp)
    266e:	0080                	addi	s0,sp,64
    2670:	8a2a                	mv	s4,a0
  pid = fork();
    2672:	00003097          	auipc	ra,0x3
    2676:	106080e7          	jalr	262(ra) # 5778 <fork>
  if(pid < 0){
    267a:	02054c63          	bltz	a0,26b2 <sbrkbasic+0x52>
  if(pid == 0){
    267e:	ed21                	bnez	a0,26d6 <sbrkbasic+0x76>
    a = sbrk(TOOMUCH);
    2680:	40000537          	lui	a0,0x40000
    2684:	00003097          	auipc	ra,0x3
    2688:	184080e7          	jalr	388(ra) # 5808 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    268c:	57fd                	li	a5,-1
    268e:	02f50f63          	beq	a0,a5,26cc <sbrkbasic+0x6c>
    for(b = a; b < a+TOOMUCH; b += 4096){
    2692:	400007b7          	lui	a5,0x40000
    2696:	97aa                	add	a5,a5,a0
      *b = 99;
    2698:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    269c:	6705                	lui	a4,0x1
      *b = 99;
    269e:	00d50023          	sb	a3,0(a0) # 40000000 <__BSS_END__+0x3fff1308>
    for(b = a; b < a+TOOMUCH; b += 4096){
    26a2:	953a                	add	a0,a0,a4
    26a4:	fef51de3          	bne	a0,a5,269e <sbrkbasic+0x3e>
    exit(1);
    26a8:	4505                	li	a0,1
    26aa:	00003097          	auipc	ra,0x3
    26ae:	0d6080e7          	jalr	214(ra) # 5780 <exit>
    printf("fork failed in sbrkbasic\n");
    26b2:	00004517          	auipc	a0,0x4
    26b6:	3be50513          	addi	a0,a0,958 # 6a70 <malloc+0xea6>
    26ba:	00003097          	auipc	ra,0x3
    26be:	458080e7          	jalr	1112(ra) # 5b12 <printf>
    exit(1);
    26c2:	4505                	li	a0,1
    26c4:	00003097          	auipc	ra,0x3
    26c8:	0bc080e7          	jalr	188(ra) # 5780 <exit>
      exit(0);
    26cc:	4501                	li	a0,0
    26ce:	00003097          	auipc	ra,0x3
    26d2:	0b2080e7          	jalr	178(ra) # 5780 <exit>
  wait(&xstatus);
    26d6:	fcc40513          	addi	a0,s0,-52
    26da:	00003097          	auipc	ra,0x3
    26de:	0ae080e7          	jalr	174(ra) # 5788 <wait>
  if(xstatus == 1){
    26e2:	fcc42703          	lw	a4,-52(s0)
    26e6:	4785                	li	a5,1
    26e8:	00f70d63          	beq	a4,a5,2702 <sbrkbasic+0xa2>
  a = sbrk(0);
    26ec:	4501                	li	a0,0
    26ee:	00003097          	auipc	ra,0x3
    26f2:	11a080e7          	jalr	282(ra) # 5808 <sbrk>
    26f6:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    26f8:	4901                	li	s2,0
    26fa:	6985                	lui	s3,0x1
    26fc:	38898993          	addi	s3,s3,904 # 1388 <copyinstr2+0x1d8>
    2700:	a005                	j	2720 <sbrkbasic+0xc0>
    printf("%s: too much memory allocated!\n", s);
    2702:	85d2                	mv	a1,s4
    2704:	00004517          	auipc	a0,0x4
    2708:	38c50513          	addi	a0,a0,908 # 6a90 <malloc+0xec6>
    270c:	00003097          	auipc	ra,0x3
    2710:	406080e7          	jalr	1030(ra) # 5b12 <printf>
    exit(1);
    2714:	4505                	li	a0,1
    2716:	00003097          	auipc	ra,0x3
    271a:	06a080e7          	jalr	106(ra) # 5780 <exit>
    a = b + 1;
    271e:	84be                	mv	s1,a5
    b = sbrk(1);
    2720:	4505                	li	a0,1
    2722:	00003097          	auipc	ra,0x3
    2726:	0e6080e7          	jalr	230(ra) # 5808 <sbrk>
    if(b != a){
    272a:	04951c63          	bne	a0,s1,2782 <sbrkbasic+0x122>
    *b = 1;
    272e:	4785                	li	a5,1
    2730:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    2734:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    2738:	2905                	addiw	s2,s2,1
    273a:	ff3912e3          	bne	s2,s3,271e <sbrkbasic+0xbe>
  pid = fork();
    273e:	00003097          	auipc	ra,0x3
    2742:	03a080e7          	jalr	58(ra) # 5778 <fork>
    2746:	892a                	mv	s2,a0
  if(pid < 0){
    2748:	04054e63          	bltz	a0,27a4 <sbrkbasic+0x144>
  c = sbrk(1);
    274c:	4505                	li	a0,1
    274e:	00003097          	auipc	ra,0x3
    2752:	0ba080e7          	jalr	186(ra) # 5808 <sbrk>
  c = sbrk(1);
    2756:	4505                	li	a0,1
    2758:	00003097          	auipc	ra,0x3
    275c:	0b0080e7          	jalr	176(ra) # 5808 <sbrk>
  if(c != a + 1){
    2760:	0489                	addi	s1,s1,2
    2762:	04a48f63          	beq	s1,a0,27c0 <sbrkbasic+0x160>
    printf("%s: sbrk test failed post-fork\n", s);
    2766:	85d2                	mv	a1,s4
    2768:	00004517          	auipc	a0,0x4
    276c:	38850513          	addi	a0,a0,904 # 6af0 <malloc+0xf26>
    2770:	00003097          	auipc	ra,0x3
    2774:	3a2080e7          	jalr	930(ra) # 5b12 <printf>
    exit(1);
    2778:	4505                	li	a0,1
    277a:	00003097          	auipc	ra,0x3
    277e:	006080e7          	jalr	6(ra) # 5780 <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    2782:	872a                	mv	a4,a0
    2784:	86a6                	mv	a3,s1
    2786:	864a                	mv	a2,s2
    2788:	85d2                	mv	a1,s4
    278a:	00004517          	auipc	a0,0x4
    278e:	32650513          	addi	a0,a0,806 # 6ab0 <malloc+0xee6>
    2792:	00003097          	auipc	ra,0x3
    2796:	380080e7          	jalr	896(ra) # 5b12 <printf>
      exit(1);
    279a:	4505                	li	a0,1
    279c:	00003097          	auipc	ra,0x3
    27a0:	fe4080e7          	jalr	-28(ra) # 5780 <exit>
    printf("%s: sbrk test fork failed\n", s);
    27a4:	85d2                	mv	a1,s4
    27a6:	00004517          	auipc	a0,0x4
    27aa:	32a50513          	addi	a0,a0,810 # 6ad0 <malloc+0xf06>
    27ae:	00003097          	auipc	ra,0x3
    27b2:	364080e7          	jalr	868(ra) # 5b12 <printf>
    exit(1);
    27b6:	4505                	li	a0,1
    27b8:	00003097          	auipc	ra,0x3
    27bc:	fc8080e7          	jalr	-56(ra) # 5780 <exit>
  if(pid == 0)
    27c0:	00091763          	bnez	s2,27ce <sbrkbasic+0x16e>
    exit(0);
    27c4:	4501                	li	a0,0
    27c6:	00003097          	auipc	ra,0x3
    27ca:	fba080e7          	jalr	-70(ra) # 5780 <exit>
  wait(&xstatus);
    27ce:	fcc40513          	addi	a0,s0,-52
    27d2:	00003097          	auipc	ra,0x3
    27d6:	fb6080e7          	jalr	-74(ra) # 5788 <wait>
  exit(xstatus);
    27da:	fcc42503          	lw	a0,-52(s0)
    27de:	00003097          	auipc	ra,0x3
    27e2:	fa2080e7          	jalr	-94(ra) # 5780 <exit>

00000000000027e6 <sbrkmuch>:
{
    27e6:	7179                	addi	sp,sp,-48
    27e8:	f406                	sd	ra,40(sp)
    27ea:	f022                	sd	s0,32(sp)
    27ec:	ec26                	sd	s1,24(sp)
    27ee:	e84a                	sd	s2,16(sp)
    27f0:	e44e                	sd	s3,8(sp)
    27f2:	e052                	sd	s4,0(sp)
    27f4:	1800                	addi	s0,sp,48
    27f6:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    27f8:	4501                	li	a0,0
    27fa:	00003097          	auipc	ra,0x3
    27fe:	00e080e7          	jalr	14(ra) # 5808 <sbrk>
    2802:	892a                	mv	s2,a0
  a = sbrk(0);
    2804:	4501                	li	a0,0
    2806:	00003097          	auipc	ra,0x3
    280a:	002080e7          	jalr	2(ra) # 5808 <sbrk>
    280e:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2810:	06400537          	lui	a0,0x6400
    2814:	9d05                	subw	a0,a0,s1
    2816:	00003097          	auipc	ra,0x3
    281a:	ff2080e7          	jalr	-14(ra) # 5808 <sbrk>
  if (p != a) {
    281e:	0ca49863          	bne	s1,a0,28ee <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2822:	4501                	li	a0,0
    2824:	00003097          	auipc	ra,0x3
    2828:	fe4080e7          	jalr	-28(ra) # 5808 <sbrk>
    282c:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    282e:	00a4f963          	bgeu	s1,a0,2840 <sbrkmuch+0x5a>
    *pp = 1;
    2832:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2834:	6705                	lui	a4,0x1
    *pp = 1;
    2836:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    283a:	94ba                	add	s1,s1,a4
    283c:	fef4ede3          	bltu	s1,a5,2836 <sbrkmuch+0x50>
  *lastaddr = 99;
    2840:	064007b7          	lui	a5,0x6400
    2844:	06300713          	li	a4,99
    2848:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f1307>
  a = sbrk(0);
    284c:	4501                	li	a0,0
    284e:	00003097          	auipc	ra,0x3
    2852:	fba080e7          	jalr	-70(ra) # 5808 <sbrk>
    2856:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2858:	757d                	lui	a0,0xfffff
    285a:	00003097          	auipc	ra,0x3
    285e:	fae080e7          	jalr	-82(ra) # 5808 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2862:	57fd                	li	a5,-1
    2864:	0af50363          	beq	a0,a5,290a <sbrkmuch+0x124>
  c = sbrk(0);
    2868:	4501                	li	a0,0
    286a:	00003097          	auipc	ra,0x3
    286e:	f9e080e7          	jalr	-98(ra) # 5808 <sbrk>
  if(c != a - PGSIZE){
    2872:	77fd                	lui	a5,0xfffff
    2874:	97a6                	add	a5,a5,s1
    2876:	0af51863          	bne	a0,a5,2926 <sbrkmuch+0x140>
  a = sbrk(0);
    287a:	4501                	li	a0,0
    287c:	00003097          	auipc	ra,0x3
    2880:	f8c080e7          	jalr	-116(ra) # 5808 <sbrk>
    2884:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2886:	6505                	lui	a0,0x1
    2888:	00003097          	auipc	ra,0x3
    288c:	f80080e7          	jalr	-128(ra) # 5808 <sbrk>
    2890:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2892:	0aa49a63          	bne	s1,a0,2946 <sbrkmuch+0x160>
    2896:	4501                	li	a0,0
    2898:	00003097          	auipc	ra,0x3
    289c:	f70080e7          	jalr	-144(ra) # 5808 <sbrk>
    28a0:	6785                	lui	a5,0x1
    28a2:	97a6                	add	a5,a5,s1
    28a4:	0af51163          	bne	a0,a5,2946 <sbrkmuch+0x160>
  if(*lastaddr == 99){
    28a8:	064007b7          	lui	a5,0x6400
    28ac:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f1307>
    28b0:	06300793          	li	a5,99
    28b4:	0af70963          	beq	a4,a5,2966 <sbrkmuch+0x180>
  a = sbrk(0);
    28b8:	4501                	li	a0,0
    28ba:	00003097          	auipc	ra,0x3
    28be:	f4e080e7          	jalr	-178(ra) # 5808 <sbrk>
    28c2:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    28c4:	4501                	li	a0,0
    28c6:	00003097          	auipc	ra,0x3
    28ca:	f42080e7          	jalr	-190(ra) # 5808 <sbrk>
    28ce:	40a9053b          	subw	a0,s2,a0
    28d2:	00003097          	auipc	ra,0x3
    28d6:	f36080e7          	jalr	-202(ra) # 5808 <sbrk>
  if(c != a){
    28da:	0aa49463          	bne	s1,a0,2982 <sbrkmuch+0x19c>
}
    28de:	70a2                	ld	ra,40(sp)
    28e0:	7402                	ld	s0,32(sp)
    28e2:	64e2                	ld	s1,24(sp)
    28e4:	6942                	ld	s2,16(sp)
    28e6:	69a2                	ld	s3,8(sp)
    28e8:	6a02                	ld	s4,0(sp)
    28ea:	6145                	addi	sp,sp,48
    28ec:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    28ee:	85ce                	mv	a1,s3
    28f0:	00004517          	auipc	a0,0x4
    28f4:	22050513          	addi	a0,a0,544 # 6b10 <malloc+0xf46>
    28f8:	00003097          	auipc	ra,0x3
    28fc:	21a080e7          	jalr	538(ra) # 5b12 <printf>
    exit(1);
    2900:	4505                	li	a0,1
    2902:	00003097          	auipc	ra,0x3
    2906:	e7e080e7          	jalr	-386(ra) # 5780 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    290a:	85ce                	mv	a1,s3
    290c:	00004517          	auipc	a0,0x4
    2910:	24c50513          	addi	a0,a0,588 # 6b58 <malloc+0xf8e>
    2914:	00003097          	auipc	ra,0x3
    2918:	1fe080e7          	jalr	510(ra) # 5b12 <printf>
    exit(1);
    291c:	4505                	li	a0,1
    291e:	00003097          	auipc	ra,0x3
    2922:	e62080e7          	jalr	-414(ra) # 5780 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    2926:	86aa                	mv	a3,a0
    2928:	8626                	mv	a2,s1
    292a:	85ce                	mv	a1,s3
    292c:	00004517          	auipc	a0,0x4
    2930:	24c50513          	addi	a0,a0,588 # 6b78 <malloc+0xfae>
    2934:	00003097          	auipc	ra,0x3
    2938:	1de080e7          	jalr	478(ra) # 5b12 <printf>
    exit(1);
    293c:	4505                	li	a0,1
    293e:	00003097          	auipc	ra,0x3
    2942:	e42080e7          	jalr	-446(ra) # 5780 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    2946:	86d2                	mv	a3,s4
    2948:	8626                	mv	a2,s1
    294a:	85ce                	mv	a1,s3
    294c:	00004517          	auipc	a0,0x4
    2950:	26c50513          	addi	a0,a0,620 # 6bb8 <malloc+0xfee>
    2954:	00003097          	auipc	ra,0x3
    2958:	1be080e7          	jalr	446(ra) # 5b12 <printf>
    exit(1);
    295c:	4505                	li	a0,1
    295e:	00003097          	auipc	ra,0x3
    2962:	e22080e7          	jalr	-478(ra) # 5780 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2966:	85ce                	mv	a1,s3
    2968:	00004517          	auipc	a0,0x4
    296c:	28050513          	addi	a0,a0,640 # 6be8 <malloc+0x101e>
    2970:	00003097          	auipc	ra,0x3
    2974:	1a2080e7          	jalr	418(ra) # 5b12 <printf>
    exit(1);
    2978:	4505                	li	a0,1
    297a:	00003097          	auipc	ra,0x3
    297e:	e06080e7          	jalr	-506(ra) # 5780 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    2982:	86aa                	mv	a3,a0
    2984:	8626                	mv	a2,s1
    2986:	85ce                	mv	a1,s3
    2988:	00004517          	auipc	a0,0x4
    298c:	29850513          	addi	a0,a0,664 # 6c20 <malloc+0x1056>
    2990:	00003097          	auipc	ra,0x3
    2994:	182080e7          	jalr	386(ra) # 5b12 <printf>
    exit(1);
    2998:	4505                	li	a0,1
    299a:	00003097          	auipc	ra,0x3
    299e:	de6080e7          	jalr	-538(ra) # 5780 <exit>

00000000000029a2 <sbrkarg>:
{
    29a2:	7179                	addi	sp,sp,-48
    29a4:	f406                	sd	ra,40(sp)
    29a6:	f022                	sd	s0,32(sp)
    29a8:	ec26                	sd	s1,24(sp)
    29aa:	e84a                	sd	s2,16(sp)
    29ac:	e44e                	sd	s3,8(sp)
    29ae:	1800                	addi	s0,sp,48
    29b0:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    29b2:	6505                	lui	a0,0x1
    29b4:	00003097          	auipc	ra,0x3
    29b8:	e54080e7          	jalr	-428(ra) # 5808 <sbrk>
    29bc:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    29be:	20100593          	li	a1,513
    29c2:	00004517          	auipc	a0,0x4
    29c6:	28650513          	addi	a0,a0,646 # 6c48 <malloc+0x107e>
    29ca:	00003097          	auipc	ra,0x3
    29ce:	df6080e7          	jalr	-522(ra) # 57c0 <open>
    29d2:	84aa                	mv	s1,a0
  unlink("sbrk");
    29d4:	00004517          	auipc	a0,0x4
    29d8:	27450513          	addi	a0,a0,628 # 6c48 <malloc+0x107e>
    29dc:	00003097          	auipc	ra,0x3
    29e0:	df4080e7          	jalr	-524(ra) # 57d0 <unlink>
  if(fd < 0)  {
    29e4:	0404c163          	bltz	s1,2a26 <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    29e8:	6605                	lui	a2,0x1
    29ea:	85ca                	mv	a1,s2
    29ec:	8526                	mv	a0,s1
    29ee:	00003097          	auipc	ra,0x3
    29f2:	db2080e7          	jalr	-590(ra) # 57a0 <write>
    29f6:	04054663          	bltz	a0,2a42 <sbrkarg+0xa0>
  close(fd);
    29fa:	8526                	mv	a0,s1
    29fc:	00003097          	auipc	ra,0x3
    2a00:	dac080e7          	jalr	-596(ra) # 57a8 <close>
  a = sbrk(PGSIZE);
    2a04:	6505                	lui	a0,0x1
    2a06:	00003097          	auipc	ra,0x3
    2a0a:	e02080e7          	jalr	-510(ra) # 5808 <sbrk>
  if(pipe((int *) a) != 0){
    2a0e:	00003097          	auipc	ra,0x3
    2a12:	d82080e7          	jalr	-638(ra) # 5790 <pipe>
    2a16:	e521                	bnez	a0,2a5e <sbrkarg+0xbc>
}
    2a18:	70a2                	ld	ra,40(sp)
    2a1a:	7402                	ld	s0,32(sp)
    2a1c:	64e2                	ld	s1,24(sp)
    2a1e:	6942                	ld	s2,16(sp)
    2a20:	69a2                	ld	s3,8(sp)
    2a22:	6145                	addi	sp,sp,48
    2a24:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2a26:	85ce                	mv	a1,s3
    2a28:	00004517          	auipc	a0,0x4
    2a2c:	22850513          	addi	a0,a0,552 # 6c50 <malloc+0x1086>
    2a30:	00003097          	auipc	ra,0x3
    2a34:	0e2080e7          	jalr	226(ra) # 5b12 <printf>
    exit(1);
    2a38:	4505                	li	a0,1
    2a3a:	00003097          	auipc	ra,0x3
    2a3e:	d46080e7          	jalr	-698(ra) # 5780 <exit>
    printf("%s: write sbrk failed\n", s);
    2a42:	85ce                	mv	a1,s3
    2a44:	00004517          	auipc	a0,0x4
    2a48:	22450513          	addi	a0,a0,548 # 6c68 <malloc+0x109e>
    2a4c:	00003097          	auipc	ra,0x3
    2a50:	0c6080e7          	jalr	198(ra) # 5b12 <printf>
    exit(1);
    2a54:	4505                	li	a0,1
    2a56:	00003097          	auipc	ra,0x3
    2a5a:	d2a080e7          	jalr	-726(ra) # 5780 <exit>
    printf("%s: pipe() failed\n", s);
    2a5e:	85ce                	mv	a1,s3
    2a60:	00004517          	auipc	a0,0x4
    2a64:	be850513          	addi	a0,a0,-1048 # 6648 <malloc+0xa7e>
    2a68:	00003097          	auipc	ra,0x3
    2a6c:	0aa080e7          	jalr	170(ra) # 5b12 <printf>
    exit(1);
    2a70:	4505                	li	a0,1
    2a72:	00003097          	auipc	ra,0x3
    2a76:	d0e080e7          	jalr	-754(ra) # 5780 <exit>

0000000000002a7a <argptest>:
{
    2a7a:	1101                	addi	sp,sp,-32
    2a7c:	ec06                	sd	ra,24(sp)
    2a7e:	e822                	sd	s0,16(sp)
    2a80:	e426                	sd	s1,8(sp)
    2a82:	e04a                	sd	s2,0(sp)
    2a84:	1000                	addi	s0,sp,32
    2a86:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2a88:	4581                	li	a1,0
    2a8a:	00004517          	auipc	a0,0x4
    2a8e:	1f650513          	addi	a0,a0,502 # 6c80 <malloc+0x10b6>
    2a92:	00003097          	auipc	ra,0x3
    2a96:	d2e080e7          	jalr	-722(ra) # 57c0 <open>
  if (fd < 0) {
    2a9a:	02054b63          	bltz	a0,2ad0 <argptest+0x56>
    2a9e:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2aa0:	4501                	li	a0,0
    2aa2:	00003097          	auipc	ra,0x3
    2aa6:	d66080e7          	jalr	-666(ra) # 5808 <sbrk>
    2aaa:	567d                	li	a2,-1
    2aac:	fff50593          	addi	a1,a0,-1
    2ab0:	8526                	mv	a0,s1
    2ab2:	00003097          	auipc	ra,0x3
    2ab6:	ce6080e7          	jalr	-794(ra) # 5798 <read>
  close(fd);
    2aba:	8526                	mv	a0,s1
    2abc:	00003097          	auipc	ra,0x3
    2ac0:	cec080e7          	jalr	-788(ra) # 57a8 <close>
}
    2ac4:	60e2                	ld	ra,24(sp)
    2ac6:	6442                	ld	s0,16(sp)
    2ac8:	64a2                	ld	s1,8(sp)
    2aca:	6902                	ld	s2,0(sp)
    2acc:	6105                	addi	sp,sp,32
    2ace:	8082                	ret
    printf("%s: open failed\n", s);
    2ad0:	85ca                	mv	a1,s2
    2ad2:	00004517          	auipc	a0,0x4
    2ad6:	a8650513          	addi	a0,a0,-1402 # 6558 <malloc+0x98e>
    2ada:	00003097          	auipc	ra,0x3
    2ade:	038080e7          	jalr	56(ra) # 5b12 <printf>
    exit(1);
    2ae2:	4505                	li	a0,1
    2ae4:	00003097          	auipc	ra,0x3
    2ae8:	c9c080e7          	jalr	-868(ra) # 5780 <exit>

0000000000002aec <sbrkbugs>:
{
    2aec:	1141                	addi	sp,sp,-16
    2aee:	e406                	sd	ra,8(sp)
    2af0:	e022                	sd	s0,0(sp)
    2af2:	0800                	addi	s0,sp,16
  int pid = fork();
    2af4:	00003097          	auipc	ra,0x3
    2af8:	c84080e7          	jalr	-892(ra) # 5778 <fork>
  if(pid < 0){
    2afc:	02054263          	bltz	a0,2b20 <sbrkbugs+0x34>
  if(pid == 0){
    2b00:	ed0d                	bnez	a0,2b3a <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2b02:	00003097          	auipc	ra,0x3
    2b06:	d06080e7          	jalr	-762(ra) # 5808 <sbrk>
    sbrk(-sz);
    2b0a:	40a0053b          	negw	a0,a0
    2b0e:	00003097          	auipc	ra,0x3
    2b12:	cfa080e7          	jalr	-774(ra) # 5808 <sbrk>
    exit(0);
    2b16:	4501                	li	a0,0
    2b18:	00003097          	auipc	ra,0x3
    2b1c:	c68080e7          	jalr	-920(ra) # 5780 <exit>
    printf("fork failed\n");
    2b20:	00004517          	auipc	a0,0x4
    2b24:	e4050513          	addi	a0,a0,-448 # 6960 <malloc+0xd96>
    2b28:	00003097          	auipc	ra,0x3
    2b2c:	fea080e7          	jalr	-22(ra) # 5b12 <printf>
    exit(1);
    2b30:	4505                	li	a0,1
    2b32:	00003097          	auipc	ra,0x3
    2b36:	c4e080e7          	jalr	-946(ra) # 5780 <exit>
  wait(0);
    2b3a:	4501                	li	a0,0
    2b3c:	00003097          	auipc	ra,0x3
    2b40:	c4c080e7          	jalr	-948(ra) # 5788 <wait>
  pid = fork();
    2b44:	00003097          	auipc	ra,0x3
    2b48:	c34080e7          	jalr	-972(ra) # 5778 <fork>
  if(pid < 0){
    2b4c:	02054563          	bltz	a0,2b76 <sbrkbugs+0x8a>
  if(pid == 0){
    2b50:	e121                	bnez	a0,2b90 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2b52:	00003097          	auipc	ra,0x3
    2b56:	cb6080e7          	jalr	-842(ra) # 5808 <sbrk>
    sbrk(-(sz - 3500));
    2b5a:	6785                	lui	a5,0x1
    2b5c:	dac7879b          	addiw	a5,a5,-596
    2b60:	40a7853b          	subw	a0,a5,a0
    2b64:	00003097          	auipc	ra,0x3
    2b68:	ca4080e7          	jalr	-860(ra) # 5808 <sbrk>
    exit(0);
    2b6c:	4501                	li	a0,0
    2b6e:	00003097          	auipc	ra,0x3
    2b72:	c12080e7          	jalr	-1006(ra) # 5780 <exit>
    printf("fork failed\n");
    2b76:	00004517          	auipc	a0,0x4
    2b7a:	dea50513          	addi	a0,a0,-534 # 6960 <malloc+0xd96>
    2b7e:	00003097          	auipc	ra,0x3
    2b82:	f94080e7          	jalr	-108(ra) # 5b12 <printf>
    exit(1);
    2b86:	4505                	li	a0,1
    2b88:	00003097          	auipc	ra,0x3
    2b8c:	bf8080e7          	jalr	-1032(ra) # 5780 <exit>
  wait(0);
    2b90:	4501                	li	a0,0
    2b92:	00003097          	auipc	ra,0x3
    2b96:	bf6080e7          	jalr	-1034(ra) # 5788 <wait>
  pid = fork();
    2b9a:	00003097          	auipc	ra,0x3
    2b9e:	bde080e7          	jalr	-1058(ra) # 5778 <fork>
  if(pid < 0){
    2ba2:	02054a63          	bltz	a0,2bd6 <sbrkbugs+0xea>
  if(pid == 0){
    2ba6:	e529                	bnez	a0,2bf0 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2ba8:	00003097          	auipc	ra,0x3
    2bac:	c60080e7          	jalr	-928(ra) # 5808 <sbrk>
    2bb0:	67ad                	lui	a5,0xb
    2bb2:	8007879b          	addiw	a5,a5,-2048
    2bb6:	40a7853b          	subw	a0,a5,a0
    2bba:	00003097          	auipc	ra,0x3
    2bbe:	c4e080e7          	jalr	-946(ra) # 5808 <sbrk>
    sbrk(-10);
    2bc2:	5559                	li	a0,-10
    2bc4:	00003097          	auipc	ra,0x3
    2bc8:	c44080e7          	jalr	-956(ra) # 5808 <sbrk>
    exit(0);
    2bcc:	4501                	li	a0,0
    2bce:	00003097          	auipc	ra,0x3
    2bd2:	bb2080e7          	jalr	-1102(ra) # 5780 <exit>
    printf("fork failed\n");
    2bd6:	00004517          	auipc	a0,0x4
    2bda:	d8a50513          	addi	a0,a0,-630 # 6960 <malloc+0xd96>
    2bde:	00003097          	auipc	ra,0x3
    2be2:	f34080e7          	jalr	-204(ra) # 5b12 <printf>
    exit(1);
    2be6:	4505                	li	a0,1
    2be8:	00003097          	auipc	ra,0x3
    2bec:	b98080e7          	jalr	-1128(ra) # 5780 <exit>
  wait(0);
    2bf0:	4501                	li	a0,0
    2bf2:	00003097          	auipc	ra,0x3
    2bf6:	b96080e7          	jalr	-1130(ra) # 5788 <wait>
  exit(0);
    2bfa:	4501                	li	a0,0
    2bfc:	00003097          	auipc	ra,0x3
    2c00:	b84080e7          	jalr	-1148(ra) # 5780 <exit>

0000000000002c04 <sbrklast>:
{
    2c04:	7179                	addi	sp,sp,-48
    2c06:	f406                	sd	ra,40(sp)
    2c08:	f022                	sd	s0,32(sp)
    2c0a:	ec26                	sd	s1,24(sp)
    2c0c:	e84a                	sd	s2,16(sp)
    2c0e:	e44e                	sd	s3,8(sp)
    2c10:	e052                	sd	s4,0(sp)
    2c12:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2c14:	4501                	li	a0,0
    2c16:	00003097          	auipc	ra,0x3
    2c1a:	bf2080e7          	jalr	-1038(ra) # 5808 <sbrk>
  if((top % 4096) != 0)
    2c1e:	03451793          	slli	a5,a0,0x34
    2c22:	ebd9                	bnez	a5,2cb8 <sbrklast+0xb4>
  sbrk(4096);
    2c24:	6505                	lui	a0,0x1
    2c26:	00003097          	auipc	ra,0x3
    2c2a:	be2080e7          	jalr	-1054(ra) # 5808 <sbrk>
  sbrk(10);
    2c2e:	4529                	li	a0,10
    2c30:	00003097          	auipc	ra,0x3
    2c34:	bd8080e7          	jalr	-1064(ra) # 5808 <sbrk>
  sbrk(-20);
    2c38:	5531                	li	a0,-20
    2c3a:	00003097          	auipc	ra,0x3
    2c3e:	bce080e7          	jalr	-1074(ra) # 5808 <sbrk>
  top = (uint64) sbrk(0);
    2c42:	4501                	li	a0,0
    2c44:	00003097          	auipc	ra,0x3
    2c48:	bc4080e7          	jalr	-1084(ra) # 5808 <sbrk>
    2c4c:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2c4e:	fc050913          	addi	s2,a0,-64 # fc0 <bigdir+0x60>
  p[0] = 'x';
    2c52:	07800a13          	li	s4,120
    2c56:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    2c5a:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2c5e:	20200593          	li	a1,514
    2c62:	854a                	mv	a0,s2
    2c64:	00003097          	auipc	ra,0x3
    2c68:	b5c080e7          	jalr	-1188(ra) # 57c0 <open>
    2c6c:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2c6e:	4605                	li	a2,1
    2c70:	85ca                	mv	a1,s2
    2c72:	00003097          	auipc	ra,0x3
    2c76:	b2e080e7          	jalr	-1234(ra) # 57a0 <write>
  close(fd);
    2c7a:	854e                	mv	a0,s3
    2c7c:	00003097          	auipc	ra,0x3
    2c80:	b2c080e7          	jalr	-1236(ra) # 57a8 <close>
  fd = open(p, O_RDWR);
    2c84:	4589                	li	a1,2
    2c86:	854a                	mv	a0,s2
    2c88:	00003097          	auipc	ra,0x3
    2c8c:	b38080e7          	jalr	-1224(ra) # 57c0 <open>
  p[0] = '\0';
    2c90:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2c94:	4605                	li	a2,1
    2c96:	85ca                	mv	a1,s2
    2c98:	00003097          	auipc	ra,0x3
    2c9c:	b00080e7          	jalr	-1280(ra) # 5798 <read>
  if(p[0] != 'x')
    2ca0:	fc04c783          	lbu	a5,-64(s1)
    2ca4:	03479463          	bne	a5,s4,2ccc <sbrklast+0xc8>
}
    2ca8:	70a2                	ld	ra,40(sp)
    2caa:	7402                	ld	s0,32(sp)
    2cac:	64e2                	ld	s1,24(sp)
    2cae:	6942                	ld	s2,16(sp)
    2cb0:	69a2                	ld	s3,8(sp)
    2cb2:	6a02                	ld	s4,0(sp)
    2cb4:	6145                	addi	sp,sp,48
    2cb6:	8082                	ret
    sbrk(4096 - (top % 4096));
    2cb8:	0347d513          	srli	a0,a5,0x34
    2cbc:	6785                	lui	a5,0x1
    2cbe:	40a7853b          	subw	a0,a5,a0
    2cc2:	00003097          	auipc	ra,0x3
    2cc6:	b46080e7          	jalr	-1210(ra) # 5808 <sbrk>
    2cca:	bfa9                	j	2c24 <sbrklast+0x20>
    exit(1);
    2ccc:	4505                	li	a0,1
    2cce:	00003097          	auipc	ra,0x3
    2cd2:	ab2080e7          	jalr	-1358(ra) # 5780 <exit>

0000000000002cd6 <sbrk8000>:
{
    2cd6:	1141                	addi	sp,sp,-16
    2cd8:	e406                	sd	ra,8(sp)
    2cda:	e022                	sd	s0,0(sp)
    2cdc:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2cde:	80000537          	lui	a0,0x80000
    2ce2:	0511                	addi	a0,a0,4
    2ce4:	00003097          	auipc	ra,0x3
    2ce8:	b24080e7          	jalr	-1244(ra) # 5808 <sbrk>
  volatile char *top = sbrk(0);
    2cec:	4501                	li	a0,0
    2cee:	00003097          	auipc	ra,0x3
    2cf2:	b1a080e7          	jalr	-1254(ra) # 5808 <sbrk>
  *(top-1) = *(top-1) + 1;
    2cf6:	fff54783          	lbu	a5,-1(a0) # ffffffff7fffffff <__BSS_END__+0xffffffff7fff1307>
    2cfa:	2785                	addiw	a5,a5,1
    2cfc:	0ff7f793          	zext.b	a5,a5
    2d00:	fef50fa3          	sb	a5,-1(a0)
}
    2d04:	60a2                	ld	ra,8(sp)
    2d06:	6402                	ld	s0,0(sp)
    2d08:	0141                	addi	sp,sp,16
    2d0a:	8082                	ret

0000000000002d0c <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    2d0c:	715d                	addi	sp,sp,-80
    2d0e:	e486                	sd	ra,72(sp)
    2d10:	e0a2                	sd	s0,64(sp)
    2d12:	fc26                	sd	s1,56(sp)
    2d14:	f84a                	sd	s2,48(sp)
    2d16:	f44e                	sd	s3,40(sp)
    2d18:	f052                	sd	s4,32(sp)
    2d1a:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2d1c:	4901                	li	s2,0
    2d1e:	49bd                	li	s3,15
    int pid = fork();
    2d20:	00003097          	auipc	ra,0x3
    2d24:	a58080e7          	jalr	-1448(ra) # 5778 <fork>
    2d28:	84aa                	mv	s1,a0
    if(pid < 0){
    2d2a:	02054063          	bltz	a0,2d4a <execout+0x3e>
      printf("fork failed\n");
      exit(1);
    } else if(pid == 0){
    2d2e:	c91d                	beqz	a0,2d64 <execout+0x58>
      close(1);
      char *args[] = { "echo", "x", 0 };
      exec("echo", args);
      exit(0);
    } else {
      wait((int*)0);
    2d30:	4501                	li	a0,0
    2d32:	00003097          	auipc	ra,0x3
    2d36:	a56080e7          	jalr	-1450(ra) # 5788 <wait>
  for(int avail = 0; avail < 15; avail++){
    2d3a:	2905                	addiw	s2,s2,1
    2d3c:	ff3912e3          	bne	s2,s3,2d20 <execout+0x14>
    }
  }

  exit(0);
    2d40:	4501                	li	a0,0
    2d42:	00003097          	auipc	ra,0x3
    2d46:	a3e080e7          	jalr	-1474(ra) # 5780 <exit>
      printf("fork failed\n");
    2d4a:	00004517          	auipc	a0,0x4
    2d4e:	c1650513          	addi	a0,a0,-1002 # 6960 <malloc+0xd96>
    2d52:	00003097          	auipc	ra,0x3
    2d56:	dc0080e7          	jalr	-576(ra) # 5b12 <printf>
      exit(1);
    2d5a:	4505                	li	a0,1
    2d5c:	00003097          	auipc	ra,0x3
    2d60:	a24080e7          	jalr	-1500(ra) # 5780 <exit>
        if(a == 0xffffffffffffffffLL)
    2d64:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2d66:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2d68:	6505                	lui	a0,0x1
    2d6a:	00003097          	auipc	ra,0x3
    2d6e:	a9e080e7          	jalr	-1378(ra) # 5808 <sbrk>
        if(a == 0xffffffffffffffffLL)
    2d72:	01350763          	beq	a0,s3,2d80 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2d76:	6785                	lui	a5,0x1
    2d78:	97aa                	add	a5,a5,a0
    2d7a:	ff478fa3          	sb	s4,-1(a5) # fff <bigdir+0x9f>
      while(1){
    2d7e:	b7ed                	j	2d68 <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2d80:	01205a63          	blez	s2,2d94 <execout+0x88>
        sbrk(-4096);
    2d84:	757d                	lui	a0,0xfffff
    2d86:	00003097          	auipc	ra,0x3
    2d8a:	a82080e7          	jalr	-1406(ra) # 5808 <sbrk>
      for(int i = 0; i < avail; i++)
    2d8e:	2485                	addiw	s1,s1,1
    2d90:	ff249ae3          	bne	s1,s2,2d84 <execout+0x78>
      close(1);
    2d94:	4505                	li	a0,1
    2d96:	00003097          	auipc	ra,0x3
    2d9a:	a12080e7          	jalr	-1518(ra) # 57a8 <close>
      char *args[] = { "echo", "x", 0 };
    2d9e:	00003517          	auipc	a0,0x3
    2da2:	f4a50513          	addi	a0,a0,-182 # 5ce8 <malloc+0x11e>
    2da6:	faa43c23          	sd	a0,-72(s0)
    2daa:	00003797          	auipc	a5,0x3
    2dae:	fae78793          	addi	a5,a5,-82 # 5d58 <malloc+0x18e>
    2db2:	fcf43023          	sd	a5,-64(s0)
    2db6:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2dba:	fb840593          	addi	a1,s0,-72
    2dbe:	00003097          	auipc	ra,0x3
    2dc2:	9fa080e7          	jalr	-1542(ra) # 57b8 <exec>
      exit(0);
    2dc6:	4501                	li	a0,0
    2dc8:	00003097          	auipc	ra,0x3
    2dcc:	9b8080e7          	jalr	-1608(ra) # 5780 <exit>

0000000000002dd0 <fourteen>:
{
    2dd0:	1101                	addi	sp,sp,-32
    2dd2:	ec06                	sd	ra,24(sp)
    2dd4:	e822                	sd	s0,16(sp)
    2dd6:	e426                	sd	s1,8(sp)
    2dd8:	1000                	addi	s0,sp,32
    2dda:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2ddc:	00004517          	auipc	a0,0x4
    2de0:	07c50513          	addi	a0,a0,124 # 6e58 <malloc+0x128e>
    2de4:	00003097          	auipc	ra,0x3
    2de8:	a04080e7          	jalr	-1532(ra) # 57e8 <mkdir>
    2dec:	e165                	bnez	a0,2ecc <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    2dee:	00004517          	auipc	a0,0x4
    2df2:	ec250513          	addi	a0,a0,-318 # 6cb0 <malloc+0x10e6>
    2df6:	00003097          	auipc	ra,0x3
    2dfa:	9f2080e7          	jalr	-1550(ra) # 57e8 <mkdir>
    2dfe:	e56d                	bnez	a0,2ee8 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2e00:	20000593          	li	a1,512
    2e04:	00004517          	auipc	a0,0x4
    2e08:	f0450513          	addi	a0,a0,-252 # 6d08 <malloc+0x113e>
    2e0c:	00003097          	auipc	ra,0x3
    2e10:	9b4080e7          	jalr	-1612(ra) # 57c0 <open>
  if(fd < 0){
    2e14:	0e054863          	bltz	a0,2f04 <fourteen+0x134>
  close(fd);
    2e18:	00003097          	auipc	ra,0x3
    2e1c:	990080e7          	jalr	-1648(ra) # 57a8 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2e20:	4581                	li	a1,0
    2e22:	00004517          	auipc	a0,0x4
    2e26:	f5e50513          	addi	a0,a0,-162 # 6d80 <malloc+0x11b6>
    2e2a:	00003097          	auipc	ra,0x3
    2e2e:	996080e7          	jalr	-1642(ra) # 57c0 <open>
  if(fd < 0){
    2e32:	0e054763          	bltz	a0,2f20 <fourteen+0x150>
  close(fd);
    2e36:	00003097          	auipc	ra,0x3
    2e3a:	972080e7          	jalr	-1678(ra) # 57a8 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2e3e:	00004517          	auipc	a0,0x4
    2e42:	fb250513          	addi	a0,a0,-78 # 6df0 <malloc+0x1226>
    2e46:	00003097          	auipc	ra,0x3
    2e4a:	9a2080e7          	jalr	-1630(ra) # 57e8 <mkdir>
    2e4e:	c57d                	beqz	a0,2f3c <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    2e50:	00004517          	auipc	a0,0x4
    2e54:	ff850513          	addi	a0,a0,-8 # 6e48 <malloc+0x127e>
    2e58:	00003097          	auipc	ra,0x3
    2e5c:	990080e7          	jalr	-1648(ra) # 57e8 <mkdir>
    2e60:	cd65                	beqz	a0,2f58 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2e62:	00004517          	auipc	a0,0x4
    2e66:	fe650513          	addi	a0,a0,-26 # 6e48 <malloc+0x127e>
    2e6a:	00003097          	auipc	ra,0x3
    2e6e:	966080e7          	jalr	-1690(ra) # 57d0 <unlink>
  unlink("12345678901234/12345678901234");
    2e72:	00004517          	auipc	a0,0x4
    2e76:	f7e50513          	addi	a0,a0,-130 # 6df0 <malloc+0x1226>
    2e7a:	00003097          	auipc	ra,0x3
    2e7e:	956080e7          	jalr	-1706(ra) # 57d0 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2e82:	00004517          	auipc	a0,0x4
    2e86:	efe50513          	addi	a0,a0,-258 # 6d80 <malloc+0x11b6>
    2e8a:	00003097          	auipc	ra,0x3
    2e8e:	946080e7          	jalr	-1722(ra) # 57d0 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2e92:	00004517          	auipc	a0,0x4
    2e96:	e7650513          	addi	a0,a0,-394 # 6d08 <malloc+0x113e>
    2e9a:	00003097          	auipc	ra,0x3
    2e9e:	936080e7          	jalr	-1738(ra) # 57d0 <unlink>
  unlink("12345678901234/123456789012345");
    2ea2:	00004517          	auipc	a0,0x4
    2ea6:	e0e50513          	addi	a0,a0,-498 # 6cb0 <malloc+0x10e6>
    2eaa:	00003097          	auipc	ra,0x3
    2eae:	926080e7          	jalr	-1754(ra) # 57d0 <unlink>
  unlink("12345678901234");
    2eb2:	00004517          	auipc	a0,0x4
    2eb6:	fa650513          	addi	a0,a0,-90 # 6e58 <malloc+0x128e>
    2eba:	00003097          	auipc	ra,0x3
    2ebe:	916080e7          	jalr	-1770(ra) # 57d0 <unlink>
}
    2ec2:	60e2                	ld	ra,24(sp)
    2ec4:	6442                	ld	s0,16(sp)
    2ec6:	64a2                	ld	s1,8(sp)
    2ec8:	6105                	addi	sp,sp,32
    2eca:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2ecc:	85a6                	mv	a1,s1
    2ece:	00004517          	auipc	a0,0x4
    2ed2:	dba50513          	addi	a0,a0,-582 # 6c88 <malloc+0x10be>
    2ed6:	00003097          	auipc	ra,0x3
    2eda:	c3c080e7          	jalr	-964(ra) # 5b12 <printf>
    exit(1);
    2ede:	4505                	li	a0,1
    2ee0:	00003097          	auipc	ra,0x3
    2ee4:	8a0080e7          	jalr	-1888(ra) # 5780 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2ee8:	85a6                	mv	a1,s1
    2eea:	00004517          	auipc	a0,0x4
    2eee:	de650513          	addi	a0,a0,-538 # 6cd0 <malloc+0x1106>
    2ef2:	00003097          	auipc	ra,0x3
    2ef6:	c20080e7          	jalr	-992(ra) # 5b12 <printf>
    exit(1);
    2efa:	4505                	li	a0,1
    2efc:	00003097          	auipc	ra,0x3
    2f00:	884080e7          	jalr	-1916(ra) # 5780 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2f04:	85a6                	mv	a1,s1
    2f06:	00004517          	auipc	a0,0x4
    2f0a:	e3250513          	addi	a0,a0,-462 # 6d38 <malloc+0x116e>
    2f0e:	00003097          	auipc	ra,0x3
    2f12:	c04080e7          	jalr	-1020(ra) # 5b12 <printf>
    exit(1);
    2f16:	4505                	li	a0,1
    2f18:	00003097          	auipc	ra,0x3
    2f1c:	868080e7          	jalr	-1944(ra) # 5780 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2f20:	85a6                	mv	a1,s1
    2f22:	00004517          	auipc	a0,0x4
    2f26:	e8e50513          	addi	a0,a0,-370 # 6db0 <malloc+0x11e6>
    2f2a:	00003097          	auipc	ra,0x3
    2f2e:	be8080e7          	jalr	-1048(ra) # 5b12 <printf>
    exit(1);
    2f32:	4505                	li	a0,1
    2f34:	00003097          	auipc	ra,0x3
    2f38:	84c080e7          	jalr	-1972(ra) # 5780 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2f3c:	85a6                	mv	a1,s1
    2f3e:	00004517          	auipc	a0,0x4
    2f42:	ed250513          	addi	a0,a0,-302 # 6e10 <malloc+0x1246>
    2f46:	00003097          	auipc	ra,0x3
    2f4a:	bcc080e7          	jalr	-1076(ra) # 5b12 <printf>
    exit(1);
    2f4e:	4505                	li	a0,1
    2f50:	00003097          	auipc	ra,0x3
    2f54:	830080e7          	jalr	-2000(ra) # 5780 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2f58:	85a6                	mv	a1,s1
    2f5a:	00004517          	auipc	a0,0x4
    2f5e:	f0e50513          	addi	a0,a0,-242 # 6e68 <malloc+0x129e>
    2f62:	00003097          	auipc	ra,0x3
    2f66:	bb0080e7          	jalr	-1104(ra) # 5b12 <printf>
    exit(1);
    2f6a:	4505                	li	a0,1
    2f6c:	00003097          	auipc	ra,0x3
    2f70:	814080e7          	jalr	-2028(ra) # 5780 <exit>

0000000000002f74 <iputtest>:
{
    2f74:	1101                	addi	sp,sp,-32
    2f76:	ec06                	sd	ra,24(sp)
    2f78:	e822                	sd	s0,16(sp)
    2f7a:	e426                	sd	s1,8(sp)
    2f7c:	1000                	addi	s0,sp,32
    2f7e:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2f80:	00004517          	auipc	a0,0x4
    2f84:	f2050513          	addi	a0,a0,-224 # 6ea0 <malloc+0x12d6>
    2f88:	00003097          	auipc	ra,0x3
    2f8c:	860080e7          	jalr	-1952(ra) # 57e8 <mkdir>
    2f90:	04054563          	bltz	a0,2fda <iputtest+0x66>
  if(chdir("iputdir") < 0){
    2f94:	00004517          	auipc	a0,0x4
    2f98:	f0c50513          	addi	a0,a0,-244 # 6ea0 <malloc+0x12d6>
    2f9c:	00003097          	auipc	ra,0x3
    2fa0:	854080e7          	jalr	-1964(ra) # 57f0 <chdir>
    2fa4:	04054963          	bltz	a0,2ff6 <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    2fa8:	00004517          	auipc	a0,0x4
    2fac:	f3850513          	addi	a0,a0,-200 # 6ee0 <malloc+0x1316>
    2fb0:	00003097          	auipc	ra,0x3
    2fb4:	820080e7          	jalr	-2016(ra) # 57d0 <unlink>
    2fb8:	04054d63          	bltz	a0,3012 <iputtest+0x9e>
  if(chdir("/") < 0){
    2fbc:	00004517          	auipc	a0,0x4
    2fc0:	f5450513          	addi	a0,a0,-172 # 6f10 <malloc+0x1346>
    2fc4:	00003097          	auipc	ra,0x3
    2fc8:	82c080e7          	jalr	-2004(ra) # 57f0 <chdir>
    2fcc:	06054163          	bltz	a0,302e <iputtest+0xba>
}
    2fd0:	60e2                	ld	ra,24(sp)
    2fd2:	6442                	ld	s0,16(sp)
    2fd4:	64a2                	ld	s1,8(sp)
    2fd6:	6105                	addi	sp,sp,32
    2fd8:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2fda:	85a6                	mv	a1,s1
    2fdc:	00004517          	auipc	a0,0x4
    2fe0:	ecc50513          	addi	a0,a0,-308 # 6ea8 <malloc+0x12de>
    2fe4:	00003097          	auipc	ra,0x3
    2fe8:	b2e080e7          	jalr	-1234(ra) # 5b12 <printf>
    exit(1);
    2fec:	4505                	li	a0,1
    2fee:	00002097          	auipc	ra,0x2
    2ff2:	792080e7          	jalr	1938(ra) # 5780 <exit>
    printf("%s: chdir iputdir failed\n", s);
    2ff6:	85a6                	mv	a1,s1
    2ff8:	00004517          	auipc	a0,0x4
    2ffc:	ec850513          	addi	a0,a0,-312 # 6ec0 <malloc+0x12f6>
    3000:	00003097          	auipc	ra,0x3
    3004:	b12080e7          	jalr	-1262(ra) # 5b12 <printf>
    exit(1);
    3008:	4505                	li	a0,1
    300a:	00002097          	auipc	ra,0x2
    300e:	776080e7          	jalr	1910(ra) # 5780 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    3012:	85a6                	mv	a1,s1
    3014:	00004517          	auipc	a0,0x4
    3018:	edc50513          	addi	a0,a0,-292 # 6ef0 <malloc+0x1326>
    301c:	00003097          	auipc	ra,0x3
    3020:	af6080e7          	jalr	-1290(ra) # 5b12 <printf>
    exit(1);
    3024:	4505                	li	a0,1
    3026:	00002097          	auipc	ra,0x2
    302a:	75a080e7          	jalr	1882(ra) # 5780 <exit>
    printf("%s: chdir / failed\n", s);
    302e:	85a6                	mv	a1,s1
    3030:	00004517          	auipc	a0,0x4
    3034:	ee850513          	addi	a0,a0,-280 # 6f18 <malloc+0x134e>
    3038:	00003097          	auipc	ra,0x3
    303c:	ada080e7          	jalr	-1318(ra) # 5b12 <printf>
    exit(1);
    3040:	4505                	li	a0,1
    3042:	00002097          	auipc	ra,0x2
    3046:	73e080e7          	jalr	1854(ra) # 5780 <exit>

000000000000304a <exitiputtest>:
{
    304a:	7179                	addi	sp,sp,-48
    304c:	f406                	sd	ra,40(sp)
    304e:	f022                	sd	s0,32(sp)
    3050:	ec26                	sd	s1,24(sp)
    3052:	1800                	addi	s0,sp,48
    3054:	84aa                	mv	s1,a0
  pid = fork();
    3056:	00002097          	auipc	ra,0x2
    305a:	722080e7          	jalr	1826(ra) # 5778 <fork>
  if(pid < 0){
    305e:	04054663          	bltz	a0,30aa <exitiputtest+0x60>
  if(pid == 0){
    3062:	ed45                	bnez	a0,311a <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    3064:	00004517          	auipc	a0,0x4
    3068:	e3c50513          	addi	a0,a0,-452 # 6ea0 <malloc+0x12d6>
    306c:	00002097          	auipc	ra,0x2
    3070:	77c080e7          	jalr	1916(ra) # 57e8 <mkdir>
    3074:	04054963          	bltz	a0,30c6 <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    3078:	00004517          	auipc	a0,0x4
    307c:	e2850513          	addi	a0,a0,-472 # 6ea0 <malloc+0x12d6>
    3080:	00002097          	auipc	ra,0x2
    3084:	770080e7          	jalr	1904(ra) # 57f0 <chdir>
    3088:	04054d63          	bltz	a0,30e2 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    308c:	00004517          	auipc	a0,0x4
    3090:	e5450513          	addi	a0,a0,-428 # 6ee0 <malloc+0x1316>
    3094:	00002097          	auipc	ra,0x2
    3098:	73c080e7          	jalr	1852(ra) # 57d0 <unlink>
    309c:	06054163          	bltz	a0,30fe <exitiputtest+0xb4>
    exit(0);
    30a0:	4501                	li	a0,0
    30a2:	00002097          	auipc	ra,0x2
    30a6:	6de080e7          	jalr	1758(ra) # 5780 <exit>
    printf("%s: fork failed\n", s);
    30aa:	85a6                	mv	a1,s1
    30ac:	00003517          	auipc	a0,0x3
    30b0:	49450513          	addi	a0,a0,1172 # 6540 <malloc+0x976>
    30b4:	00003097          	auipc	ra,0x3
    30b8:	a5e080e7          	jalr	-1442(ra) # 5b12 <printf>
    exit(1);
    30bc:	4505                	li	a0,1
    30be:	00002097          	auipc	ra,0x2
    30c2:	6c2080e7          	jalr	1730(ra) # 5780 <exit>
      printf("%s: mkdir failed\n", s);
    30c6:	85a6                	mv	a1,s1
    30c8:	00004517          	auipc	a0,0x4
    30cc:	de050513          	addi	a0,a0,-544 # 6ea8 <malloc+0x12de>
    30d0:	00003097          	auipc	ra,0x3
    30d4:	a42080e7          	jalr	-1470(ra) # 5b12 <printf>
      exit(1);
    30d8:	4505                	li	a0,1
    30da:	00002097          	auipc	ra,0x2
    30de:	6a6080e7          	jalr	1702(ra) # 5780 <exit>
      printf("%s: child chdir failed\n", s);
    30e2:	85a6                	mv	a1,s1
    30e4:	00004517          	auipc	a0,0x4
    30e8:	e4c50513          	addi	a0,a0,-436 # 6f30 <malloc+0x1366>
    30ec:	00003097          	auipc	ra,0x3
    30f0:	a26080e7          	jalr	-1498(ra) # 5b12 <printf>
      exit(1);
    30f4:	4505                	li	a0,1
    30f6:	00002097          	auipc	ra,0x2
    30fa:	68a080e7          	jalr	1674(ra) # 5780 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    30fe:	85a6                	mv	a1,s1
    3100:	00004517          	auipc	a0,0x4
    3104:	df050513          	addi	a0,a0,-528 # 6ef0 <malloc+0x1326>
    3108:	00003097          	auipc	ra,0x3
    310c:	a0a080e7          	jalr	-1526(ra) # 5b12 <printf>
      exit(1);
    3110:	4505                	li	a0,1
    3112:	00002097          	auipc	ra,0x2
    3116:	66e080e7          	jalr	1646(ra) # 5780 <exit>
  wait(&xstatus);
    311a:	fdc40513          	addi	a0,s0,-36
    311e:	00002097          	auipc	ra,0x2
    3122:	66a080e7          	jalr	1642(ra) # 5788 <wait>
  exit(xstatus);
    3126:	fdc42503          	lw	a0,-36(s0)
    312a:	00002097          	auipc	ra,0x2
    312e:	656080e7          	jalr	1622(ra) # 5780 <exit>

0000000000003132 <dirtest>:
{
    3132:	1101                	addi	sp,sp,-32
    3134:	ec06                	sd	ra,24(sp)
    3136:	e822                	sd	s0,16(sp)
    3138:	e426                	sd	s1,8(sp)
    313a:	1000                	addi	s0,sp,32
    313c:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    313e:	00004517          	auipc	a0,0x4
    3142:	e0a50513          	addi	a0,a0,-502 # 6f48 <malloc+0x137e>
    3146:	00002097          	auipc	ra,0x2
    314a:	6a2080e7          	jalr	1698(ra) # 57e8 <mkdir>
    314e:	04054563          	bltz	a0,3198 <dirtest+0x66>
  if(chdir("dir0") < 0){
    3152:	00004517          	auipc	a0,0x4
    3156:	df650513          	addi	a0,a0,-522 # 6f48 <malloc+0x137e>
    315a:	00002097          	auipc	ra,0x2
    315e:	696080e7          	jalr	1686(ra) # 57f0 <chdir>
    3162:	04054963          	bltz	a0,31b4 <dirtest+0x82>
  if(chdir("..") < 0){
    3166:	00004517          	auipc	a0,0x4
    316a:	e0250513          	addi	a0,a0,-510 # 6f68 <malloc+0x139e>
    316e:	00002097          	auipc	ra,0x2
    3172:	682080e7          	jalr	1666(ra) # 57f0 <chdir>
    3176:	04054d63          	bltz	a0,31d0 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    317a:	00004517          	auipc	a0,0x4
    317e:	dce50513          	addi	a0,a0,-562 # 6f48 <malloc+0x137e>
    3182:	00002097          	auipc	ra,0x2
    3186:	64e080e7          	jalr	1614(ra) # 57d0 <unlink>
    318a:	06054163          	bltz	a0,31ec <dirtest+0xba>
}
    318e:	60e2                	ld	ra,24(sp)
    3190:	6442                	ld	s0,16(sp)
    3192:	64a2                	ld	s1,8(sp)
    3194:	6105                	addi	sp,sp,32
    3196:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3198:	85a6                	mv	a1,s1
    319a:	00004517          	auipc	a0,0x4
    319e:	d0e50513          	addi	a0,a0,-754 # 6ea8 <malloc+0x12de>
    31a2:	00003097          	auipc	ra,0x3
    31a6:	970080e7          	jalr	-1680(ra) # 5b12 <printf>
    exit(1);
    31aa:	4505                	li	a0,1
    31ac:	00002097          	auipc	ra,0x2
    31b0:	5d4080e7          	jalr	1492(ra) # 5780 <exit>
    printf("%s: chdir dir0 failed\n", s);
    31b4:	85a6                	mv	a1,s1
    31b6:	00004517          	auipc	a0,0x4
    31ba:	d9a50513          	addi	a0,a0,-614 # 6f50 <malloc+0x1386>
    31be:	00003097          	auipc	ra,0x3
    31c2:	954080e7          	jalr	-1708(ra) # 5b12 <printf>
    exit(1);
    31c6:	4505                	li	a0,1
    31c8:	00002097          	auipc	ra,0x2
    31cc:	5b8080e7          	jalr	1464(ra) # 5780 <exit>
    printf("%s: chdir .. failed\n", s);
    31d0:	85a6                	mv	a1,s1
    31d2:	00004517          	auipc	a0,0x4
    31d6:	d9e50513          	addi	a0,a0,-610 # 6f70 <malloc+0x13a6>
    31da:	00003097          	auipc	ra,0x3
    31de:	938080e7          	jalr	-1736(ra) # 5b12 <printf>
    exit(1);
    31e2:	4505                	li	a0,1
    31e4:	00002097          	auipc	ra,0x2
    31e8:	59c080e7          	jalr	1436(ra) # 5780 <exit>
    printf("%s: unlink dir0 failed\n", s);
    31ec:	85a6                	mv	a1,s1
    31ee:	00004517          	auipc	a0,0x4
    31f2:	d9a50513          	addi	a0,a0,-614 # 6f88 <malloc+0x13be>
    31f6:	00003097          	auipc	ra,0x3
    31fa:	91c080e7          	jalr	-1764(ra) # 5b12 <printf>
    exit(1);
    31fe:	4505                	li	a0,1
    3200:	00002097          	auipc	ra,0x2
    3204:	580080e7          	jalr	1408(ra) # 5780 <exit>

0000000000003208 <subdir>:
{
    3208:	1101                	addi	sp,sp,-32
    320a:	ec06                	sd	ra,24(sp)
    320c:	e822                	sd	s0,16(sp)
    320e:	e426                	sd	s1,8(sp)
    3210:	e04a                	sd	s2,0(sp)
    3212:	1000                	addi	s0,sp,32
    3214:	892a                	mv	s2,a0
  unlink("ff");
    3216:	00004517          	auipc	a0,0x4
    321a:	eba50513          	addi	a0,a0,-326 # 70d0 <malloc+0x1506>
    321e:	00002097          	auipc	ra,0x2
    3222:	5b2080e7          	jalr	1458(ra) # 57d0 <unlink>
  if(mkdir("dd") != 0){
    3226:	00004517          	auipc	a0,0x4
    322a:	d7a50513          	addi	a0,a0,-646 # 6fa0 <malloc+0x13d6>
    322e:	00002097          	auipc	ra,0x2
    3232:	5ba080e7          	jalr	1466(ra) # 57e8 <mkdir>
    3236:	38051663          	bnez	a0,35c2 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    323a:	20200593          	li	a1,514
    323e:	00004517          	auipc	a0,0x4
    3242:	d8250513          	addi	a0,a0,-638 # 6fc0 <malloc+0x13f6>
    3246:	00002097          	auipc	ra,0x2
    324a:	57a080e7          	jalr	1402(ra) # 57c0 <open>
    324e:	84aa                	mv	s1,a0
  if(fd < 0){
    3250:	38054763          	bltz	a0,35de <subdir+0x3d6>
  write(fd, "ff", 2);
    3254:	4609                	li	a2,2
    3256:	00004597          	auipc	a1,0x4
    325a:	e7a58593          	addi	a1,a1,-390 # 70d0 <malloc+0x1506>
    325e:	00002097          	auipc	ra,0x2
    3262:	542080e7          	jalr	1346(ra) # 57a0 <write>
  close(fd);
    3266:	8526                	mv	a0,s1
    3268:	00002097          	auipc	ra,0x2
    326c:	540080e7          	jalr	1344(ra) # 57a8 <close>
  if(unlink("dd") >= 0){
    3270:	00004517          	auipc	a0,0x4
    3274:	d3050513          	addi	a0,a0,-720 # 6fa0 <malloc+0x13d6>
    3278:	00002097          	auipc	ra,0x2
    327c:	558080e7          	jalr	1368(ra) # 57d0 <unlink>
    3280:	36055d63          	bgez	a0,35fa <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    3284:	00004517          	auipc	a0,0x4
    3288:	d9450513          	addi	a0,a0,-620 # 7018 <malloc+0x144e>
    328c:	00002097          	auipc	ra,0x2
    3290:	55c080e7          	jalr	1372(ra) # 57e8 <mkdir>
    3294:	38051163          	bnez	a0,3616 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    3298:	20200593          	li	a1,514
    329c:	00004517          	auipc	a0,0x4
    32a0:	da450513          	addi	a0,a0,-604 # 7040 <malloc+0x1476>
    32a4:	00002097          	auipc	ra,0x2
    32a8:	51c080e7          	jalr	1308(ra) # 57c0 <open>
    32ac:	84aa                	mv	s1,a0
  if(fd < 0){
    32ae:	38054263          	bltz	a0,3632 <subdir+0x42a>
  write(fd, "FF", 2);
    32b2:	4609                	li	a2,2
    32b4:	00004597          	auipc	a1,0x4
    32b8:	dbc58593          	addi	a1,a1,-580 # 7070 <malloc+0x14a6>
    32bc:	00002097          	auipc	ra,0x2
    32c0:	4e4080e7          	jalr	1252(ra) # 57a0 <write>
  close(fd);
    32c4:	8526                	mv	a0,s1
    32c6:	00002097          	auipc	ra,0x2
    32ca:	4e2080e7          	jalr	1250(ra) # 57a8 <close>
  fd = open("dd/dd/../ff", 0);
    32ce:	4581                	li	a1,0
    32d0:	00004517          	auipc	a0,0x4
    32d4:	da850513          	addi	a0,a0,-600 # 7078 <malloc+0x14ae>
    32d8:	00002097          	auipc	ra,0x2
    32dc:	4e8080e7          	jalr	1256(ra) # 57c0 <open>
    32e0:	84aa                	mv	s1,a0
  if(fd < 0){
    32e2:	36054663          	bltz	a0,364e <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    32e6:	660d                	lui	a2,0x3
    32e8:	00009597          	auipc	a1,0x9
    32ec:	a0058593          	addi	a1,a1,-1536 # bce8 <buf>
    32f0:	00002097          	auipc	ra,0x2
    32f4:	4a8080e7          	jalr	1192(ra) # 5798 <read>
  if(cc != 2 || buf[0] != 'f'){
    32f8:	4789                	li	a5,2
    32fa:	36f51863          	bne	a0,a5,366a <subdir+0x462>
    32fe:	00009717          	auipc	a4,0x9
    3302:	9ea74703          	lbu	a4,-1558(a4) # bce8 <buf>
    3306:	06600793          	li	a5,102
    330a:	36f71063          	bne	a4,a5,366a <subdir+0x462>
  close(fd);
    330e:	8526                	mv	a0,s1
    3310:	00002097          	auipc	ra,0x2
    3314:	498080e7          	jalr	1176(ra) # 57a8 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    3318:	00004597          	auipc	a1,0x4
    331c:	db058593          	addi	a1,a1,-592 # 70c8 <malloc+0x14fe>
    3320:	00004517          	auipc	a0,0x4
    3324:	d2050513          	addi	a0,a0,-736 # 7040 <malloc+0x1476>
    3328:	00002097          	auipc	ra,0x2
    332c:	4b8080e7          	jalr	1208(ra) # 57e0 <link>
    3330:	34051b63          	bnez	a0,3686 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    3334:	00004517          	auipc	a0,0x4
    3338:	d0c50513          	addi	a0,a0,-756 # 7040 <malloc+0x1476>
    333c:	00002097          	auipc	ra,0x2
    3340:	494080e7          	jalr	1172(ra) # 57d0 <unlink>
    3344:	34051f63          	bnez	a0,36a2 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3348:	4581                	li	a1,0
    334a:	00004517          	auipc	a0,0x4
    334e:	cf650513          	addi	a0,a0,-778 # 7040 <malloc+0x1476>
    3352:	00002097          	auipc	ra,0x2
    3356:	46e080e7          	jalr	1134(ra) # 57c0 <open>
    335a:	36055263          	bgez	a0,36be <subdir+0x4b6>
  if(chdir("dd") != 0){
    335e:	00004517          	auipc	a0,0x4
    3362:	c4250513          	addi	a0,a0,-958 # 6fa0 <malloc+0x13d6>
    3366:	00002097          	auipc	ra,0x2
    336a:	48a080e7          	jalr	1162(ra) # 57f0 <chdir>
    336e:	36051663          	bnez	a0,36da <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    3372:	00004517          	auipc	a0,0x4
    3376:	dee50513          	addi	a0,a0,-530 # 7160 <malloc+0x1596>
    337a:	00002097          	auipc	ra,0x2
    337e:	476080e7          	jalr	1142(ra) # 57f0 <chdir>
    3382:	36051a63          	bnez	a0,36f6 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    3386:	00004517          	auipc	a0,0x4
    338a:	e0a50513          	addi	a0,a0,-502 # 7190 <malloc+0x15c6>
    338e:	00002097          	auipc	ra,0x2
    3392:	462080e7          	jalr	1122(ra) # 57f0 <chdir>
    3396:	36051e63          	bnez	a0,3712 <subdir+0x50a>
  if(chdir("./..") != 0){
    339a:	00004517          	auipc	a0,0x4
    339e:	e2650513          	addi	a0,a0,-474 # 71c0 <malloc+0x15f6>
    33a2:	00002097          	auipc	ra,0x2
    33a6:	44e080e7          	jalr	1102(ra) # 57f0 <chdir>
    33aa:	38051263          	bnez	a0,372e <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    33ae:	4581                	li	a1,0
    33b0:	00004517          	auipc	a0,0x4
    33b4:	d1850513          	addi	a0,a0,-744 # 70c8 <malloc+0x14fe>
    33b8:	00002097          	auipc	ra,0x2
    33bc:	408080e7          	jalr	1032(ra) # 57c0 <open>
    33c0:	84aa                	mv	s1,a0
  if(fd < 0){
    33c2:	38054463          	bltz	a0,374a <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    33c6:	660d                	lui	a2,0x3
    33c8:	00009597          	auipc	a1,0x9
    33cc:	92058593          	addi	a1,a1,-1760 # bce8 <buf>
    33d0:	00002097          	auipc	ra,0x2
    33d4:	3c8080e7          	jalr	968(ra) # 5798 <read>
    33d8:	4789                	li	a5,2
    33da:	38f51663          	bne	a0,a5,3766 <subdir+0x55e>
  close(fd);
    33de:	8526                	mv	a0,s1
    33e0:	00002097          	auipc	ra,0x2
    33e4:	3c8080e7          	jalr	968(ra) # 57a8 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    33e8:	4581                	li	a1,0
    33ea:	00004517          	auipc	a0,0x4
    33ee:	c5650513          	addi	a0,a0,-938 # 7040 <malloc+0x1476>
    33f2:	00002097          	auipc	ra,0x2
    33f6:	3ce080e7          	jalr	974(ra) # 57c0 <open>
    33fa:	38055463          	bgez	a0,3782 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    33fe:	20200593          	li	a1,514
    3402:	00004517          	auipc	a0,0x4
    3406:	e4e50513          	addi	a0,a0,-434 # 7250 <malloc+0x1686>
    340a:	00002097          	auipc	ra,0x2
    340e:	3b6080e7          	jalr	950(ra) # 57c0 <open>
    3412:	38055663          	bgez	a0,379e <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    3416:	20200593          	li	a1,514
    341a:	00004517          	auipc	a0,0x4
    341e:	e6650513          	addi	a0,a0,-410 # 7280 <malloc+0x16b6>
    3422:	00002097          	auipc	ra,0x2
    3426:	39e080e7          	jalr	926(ra) # 57c0 <open>
    342a:	38055863          	bgez	a0,37ba <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    342e:	20000593          	li	a1,512
    3432:	00004517          	auipc	a0,0x4
    3436:	b6e50513          	addi	a0,a0,-1170 # 6fa0 <malloc+0x13d6>
    343a:	00002097          	auipc	ra,0x2
    343e:	386080e7          	jalr	902(ra) # 57c0 <open>
    3442:	38055a63          	bgez	a0,37d6 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    3446:	4589                	li	a1,2
    3448:	00004517          	auipc	a0,0x4
    344c:	b5850513          	addi	a0,a0,-1192 # 6fa0 <malloc+0x13d6>
    3450:	00002097          	auipc	ra,0x2
    3454:	370080e7          	jalr	880(ra) # 57c0 <open>
    3458:	38055d63          	bgez	a0,37f2 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    345c:	4585                	li	a1,1
    345e:	00004517          	auipc	a0,0x4
    3462:	b4250513          	addi	a0,a0,-1214 # 6fa0 <malloc+0x13d6>
    3466:	00002097          	auipc	ra,0x2
    346a:	35a080e7          	jalr	858(ra) # 57c0 <open>
    346e:	3a055063          	bgez	a0,380e <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    3472:	00004597          	auipc	a1,0x4
    3476:	e9e58593          	addi	a1,a1,-354 # 7310 <malloc+0x1746>
    347a:	00004517          	auipc	a0,0x4
    347e:	dd650513          	addi	a0,a0,-554 # 7250 <malloc+0x1686>
    3482:	00002097          	auipc	ra,0x2
    3486:	35e080e7          	jalr	862(ra) # 57e0 <link>
    348a:	3a050063          	beqz	a0,382a <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    348e:	00004597          	auipc	a1,0x4
    3492:	e8258593          	addi	a1,a1,-382 # 7310 <malloc+0x1746>
    3496:	00004517          	auipc	a0,0x4
    349a:	dea50513          	addi	a0,a0,-534 # 7280 <malloc+0x16b6>
    349e:	00002097          	auipc	ra,0x2
    34a2:	342080e7          	jalr	834(ra) # 57e0 <link>
    34a6:	3a050063          	beqz	a0,3846 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    34aa:	00004597          	auipc	a1,0x4
    34ae:	c1e58593          	addi	a1,a1,-994 # 70c8 <malloc+0x14fe>
    34b2:	00004517          	auipc	a0,0x4
    34b6:	b0e50513          	addi	a0,a0,-1266 # 6fc0 <malloc+0x13f6>
    34ba:	00002097          	auipc	ra,0x2
    34be:	326080e7          	jalr	806(ra) # 57e0 <link>
    34c2:	3a050063          	beqz	a0,3862 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    34c6:	00004517          	auipc	a0,0x4
    34ca:	d8a50513          	addi	a0,a0,-630 # 7250 <malloc+0x1686>
    34ce:	00002097          	auipc	ra,0x2
    34d2:	31a080e7          	jalr	794(ra) # 57e8 <mkdir>
    34d6:	3a050463          	beqz	a0,387e <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    34da:	00004517          	auipc	a0,0x4
    34de:	da650513          	addi	a0,a0,-602 # 7280 <malloc+0x16b6>
    34e2:	00002097          	auipc	ra,0x2
    34e6:	306080e7          	jalr	774(ra) # 57e8 <mkdir>
    34ea:	3a050863          	beqz	a0,389a <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    34ee:	00004517          	auipc	a0,0x4
    34f2:	bda50513          	addi	a0,a0,-1062 # 70c8 <malloc+0x14fe>
    34f6:	00002097          	auipc	ra,0x2
    34fa:	2f2080e7          	jalr	754(ra) # 57e8 <mkdir>
    34fe:	3a050c63          	beqz	a0,38b6 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    3502:	00004517          	auipc	a0,0x4
    3506:	d7e50513          	addi	a0,a0,-642 # 7280 <malloc+0x16b6>
    350a:	00002097          	auipc	ra,0x2
    350e:	2c6080e7          	jalr	710(ra) # 57d0 <unlink>
    3512:	3c050063          	beqz	a0,38d2 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    3516:	00004517          	auipc	a0,0x4
    351a:	d3a50513          	addi	a0,a0,-710 # 7250 <malloc+0x1686>
    351e:	00002097          	auipc	ra,0x2
    3522:	2b2080e7          	jalr	690(ra) # 57d0 <unlink>
    3526:	3c050463          	beqz	a0,38ee <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    352a:	00004517          	auipc	a0,0x4
    352e:	a9650513          	addi	a0,a0,-1386 # 6fc0 <malloc+0x13f6>
    3532:	00002097          	auipc	ra,0x2
    3536:	2be080e7          	jalr	702(ra) # 57f0 <chdir>
    353a:	3c050863          	beqz	a0,390a <subdir+0x702>
  if(chdir("dd/xx") == 0){
    353e:	00004517          	auipc	a0,0x4
    3542:	f2250513          	addi	a0,a0,-222 # 7460 <malloc+0x1896>
    3546:	00002097          	auipc	ra,0x2
    354a:	2aa080e7          	jalr	682(ra) # 57f0 <chdir>
    354e:	3c050c63          	beqz	a0,3926 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    3552:	00004517          	auipc	a0,0x4
    3556:	b7650513          	addi	a0,a0,-1162 # 70c8 <malloc+0x14fe>
    355a:	00002097          	auipc	ra,0x2
    355e:	276080e7          	jalr	630(ra) # 57d0 <unlink>
    3562:	3e051063          	bnez	a0,3942 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    3566:	00004517          	auipc	a0,0x4
    356a:	a5a50513          	addi	a0,a0,-1446 # 6fc0 <malloc+0x13f6>
    356e:	00002097          	auipc	ra,0x2
    3572:	262080e7          	jalr	610(ra) # 57d0 <unlink>
    3576:	3e051463          	bnez	a0,395e <subdir+0x756>
  if(unlink("dd") == 0){
    357a:	00004517          	auipc	a0,0x4
    357e:	a2650513          	addi	a0,a0,-1498 # 6fa0 <malloc+0x13d6>
    3582:	00002097          	auipc	ra,0x2
    3586:	24e080e7          	jalr	590(ra) # 57d0 <unlink>
    358a:	3e050863          	beqz	a0,397a <subdir+0x772>
  if(unlink("dd/dd") < 0){
    358e:	00004517          	auipc	a0,0x4
    3592:	f4250513          	addi	a0,a0,-190 # 74d0 <malloc+0x1906>
    3596:	00002097          	auipc	ra,0x2
    359a:	23a080e7          	jalr	570(ra) # 57d0 <unlink>
    359e:	3e054c63          	bltz	a0,3996 <subdir+0x78e>
  if(unlink("dd") < 0){
    35a2:	00004517          	auipc	a0,0x4
    35a6:	9fe50513          	addi	a0,a0,-1538 # 6fa0 <malloc+0x13d6>
    35aa:	00002097          	auipc	ra,0x2
    35ae:	226080e7          	jalr	550(ra) # 57d0 <unlink>
    35b2:	40054063          	bltz	a0,39b2 <subdir+0x7aa>
}
    35b6:	60e2                	ld	ra,24(sp)
    35b8:	6442                	ld	s0,16(sp)
    35ba:	64a2                	ld	s1,8(sp)
    35bc:	6902                	ld	s2,0(sp)
    35be:	6105                	addi	sp,sp,32
    35c0:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    35c2:	85ca                	mv	a1,s2
    35c4:	00004517          	auipc	a0,0x4
    35c8:	9e450513          	addi	a0,a0,-1564 # 6fa8 <malloc+0x13de>
    35cc:	00002097          	auipc	ra,0x2
    35d0:	546080e7          	jalr	1350(ra) # 5b12 <printf>
    exit(1);
    35d4:	4505                	li	a0,1
    35d6:	00002097          	auipc	ra,0x2
    35da:	1aa080e7          	jalr	426(ra) # 5780 <exit>
    printf("%s: create dd/ff failed\n", s);
    35de:	85ca                	mv	a1,s2
    35e0:	00004517          	auipc	a0,0x4
    35e4:	9e850513          	addi	a0,a0,-1560 # 6fc8 <malloc+0x13fe>
    35e8:	00002097          	auipc	ra,0x2
    35ec:	52a080e7          	jalr	1322(ra) # 5b12 <printf>
    exit(1);
    35f0:	4505                	li	a0,1
    35f2:	00002097          	auipc	ra,0x2
    35f6:	18e080e7          	jalr	398(ra) # 5780 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    35fa:	85ca                	mv	a1,s2
    35fc:	00004517          	auipc	a0,0x4
    3600:	9ec50513          	addi	a0,a0,-1556 # 6fe8 <malloc+0x141e>
    3604:	00002097          	auipc	ra,0x2
    3608:	50e080e7          	jalr	1294(ra) # 5b12 <printf>
    exit(1);
    360c:	4505                	li	a0,1
    360e:	00002097          	auipc	ra,0x2
    3612:	172080e7          	jalr	370(ra) # 5780 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3616:	85ca                	mv	a1,s2
    3618:	00004517          	auipc	a0,0x4
    361c:	a0850513          	addi	a0,a0,-1528 # 7020 <malloc+0x1456>
    3620:	00002097          	auipc	ra,0x2
    3624:	4f2080e7          	jalr	1266(ra) # 5b12 <printf>
    exit(1);
    3628:	4505                	li	a0,1
    362a:	00002097          	auipc	ra,0x2
    362e:	156080e7          	jalr	342(ra) # 5780 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3632:	85ca                	mv	a1,s2
    3634:	00004517          	auipc	a0,0x4
    3638:	a1c50513          	addi	a0,a0,-1508 # 7050 <malloc+0x1486>
    363c:	00002097          	auipc	ra,0x2
    3640:	4d6080e7          	jalr	1238(ra) # 5b12 <printf>
    exit(1);
    3644:	4505                	li	a0,1
    3646:	00002097          	auipc	ra,0x2
    364a:	13a080e7          	jalr	314(ra) # 5780 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    364e:	85ca                	mv	a1,s2
    3650:	00004517          	auipc	a0,0x4
    3654:	a3850513          	addi	a0,a0,-1480 # 7088 <malloc+0x14be>
    3658:	00002097          	auipc	ra,0x2
    365c:	4ba080e7          	jalr	1210(ra) # 5b12 <printf>
    exit(1);
    3660:	4505                	li	a0,1
    3662:	00002097          	auipc	ra,0x2
    3666:	11e080e7          	jalr	286(ra) # 5780 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    366a:	85ca                	mv	a1,s2
    366c:	00004517          	auipc	a0,0x4
    3670:	a3c50513          	addi	a0,a0,-1476 # 70a8 <malloc+0x14de>
    3674:	00002097          	auipc	ra,0x2
    3678:	49e080e7          	jalr	1182(ra) # 5b12 <printf>
    exit(1);
    367c:	4505                	li	a0,1
    367e:	00002097          	auipc	ra,0x2
    3682:	102080e7          	jalr	258(ra) # 5780 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3686:	85ca                	mv	a1,s2
    3688:	00004517          	auipc	a0,0x4
    368c:	a5050513          	addi	a0,a0,-1456 # 70d8 <malloc+0x150e>
    3690:	00002097          	auipc	ra,0x2
    3694:	482080e7          	jalr	1154(ra) # 5b12 <printf>
    exit(1);
    3698:	4505                	li	a0,1
    369a:	00002097          	auipc	ra,0x2
    369e:	0e6080e7          	jalr	230(ra) # 5780 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    36a2:	85ca                	mv	a1,s2
    36a4:	00004517          	auipc	a0,0x4
    36a8:	a5c50513          	addi	a0,a0,-1444 # 7100 <malloc+0x1536>
    36ac:	00002097          	auipc	ra,0x2
    36b0:	466080e7          	jalr	1126(ra) # 5b12 <printf>
    exit(1);
    36b4:	4505                	li	a0,1
    36b6:	00002097          	auipc	ra,0x2
    36ba:	0ca080e7          	jalr	202(ra) # 5780 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    36be:	85ca                	mv	a1,s2
    36c0:	00004517          	auipc	a0,0x4
    36c4:	a6050513          	addi	a0,a0,-1440 # 7120 <malloc+0x1556>
    36c8:	00002097          	auipc	ra,0x2
    36cc:	44a080e7          	jalr	1098(ra) # 5b12 <printf>
    exit(1);
    36d0:	4505                	li	a0,1
    36d2:	00002097          	auipc	ra,0x2
    36d6:	0ae080e7          	jalr	174(ra) # 5780 <exit>
    printf("%s: chdir dd failed\n", s);
    36da:	85ca                	mv	a1,s2
    36dc:	00004517          	auipc	a0,0x4
    36e0:	a6c50513          	addi	a0,a0,-1428 # 7148 <malloc+0x157e>
    36e4:	00002097          	auipc	ra,0x2
    36e8:	42e080e7          	jalr	1070(ra) # 5b12 <printf>
    exit(1);
    36ec:	4505                	li	a0,1
    36ee:	00002097          	auipc	ra,0x2
    36f2:	092080e7          	jalr	146(ra) # 5780 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    36f6:	85ca                	mv	a1,s2
    36f8:	00004517          	auipc	a0,0x4
    36fc:	a7850513          	addi	a0,a0,-1416 # 7170 <malloc+0x15a6>
    3700:	00002097          	auipc	ra,0x2
    3704:	412080e7          	jalr	1042(ra) # 5b12 <printf>
    exit(1);
    3708:	4505                	li	a0,1
    370a:	00002097          	auipc	ra,0x2
    370e:	076080e7          	jalr	118(ra) # 5780 <exit>
    printf("chdir dd/../../dd failed\n", s);
    3712:	85ca                	mv	a1,s2
    3714:	00004517          	auipc	a0,0x4
    3718:	a8c50513          	addi	a0,a0,-1396 # 71a0 <malloc+0x15d6>
    371c:	00002097          	auipc	ra,0x2
    3720:	3f6080e7          	jalr	1014(ra) # 5b12 <printf>
    exit(1);
    3724:	4505                	li	a0,1
    3726:	00002097          	auipc	ra,0x2
    372a:	05a080e7          	jalr	90(ra) # 5780 <exit>
    printf("%s: chdir ./.. failed\n", s);
    372e:	85ca                	mv	a1,s2
    3730:	00004517          	auipc	a0,0x4
    3734:	a9850513          	addi	a0,a0,-1384 # 71c8 <malloc+0x15fe>
    3738:	00002097          	auipc	ra,0x2
    373c:	3da080e7          	jalr	986(ra) # 5b12 <printf>
    exit(1);
    3740:	4505                	li	a0,1
    3742:	00002097          	auipc	ra,0x2
    3746:	03e080e7          	jalr	62(ra) # 5780 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    374a:	85ca                	mv	a1,s2
    374c:	00004517          	auipc	a0,0x4
    3750:	a9450513          	addi	a0,a0,-1388 # 71e0 <malloc+0x1616>
    3754:	00002097          	auipc	ra,0x2
    3758:	3be080e7          	jalr	958(ra) # 5b12 <printf>
    exit(1);
    375c:	4505                	li	a0,1
    375e:	00002097          	auipc	ra,0x2
    3762:	022080e7          	jalr	34(ra) # 5780 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3766:	85ca                	mv	a1,s2
    3768:	00004517          	auipc	a0,0x4
    376c:	a9850513          	addi	a0,a0,-1384 # 7200 <malloc+0x1636>
    3770:	00002097          	auipc	ra,0x2
    3774:	3a2080e7          	jalr	930(ra) # 5b12 <printf>
    exit(1);
    3778:	4505                	li	a0,1
    377a:	00002097          	auipc	ra,0x2
    377e:	006080e7          	jalr	6(ra) # 5780 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3782:	85ca                	mv	a1,s2
    3784:	00004517          	auipc	a0,0x4
    3788:	a9c50513          	addi	a0,a0,-1380 # 7220 <malloc+0x1656>
    378c:	00002097          	auipc	ra,0x2
    3790:	386080e7          	jalr	902(ra) # 5b12 <printf>
    exit(1);
    3794:	4505                	li	a0,1
    3796:	00002097          	auipc	ra,0x2
    379a:	fea080e7          	jalr	-22(ra) # 5780 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    379e:	85ca                	mv	a1,s2
    37a0:	00004517          	auipc	a0,0x4
    37a4:	ac050513          	addi	a0,a0,-1344 # 7260 <malloc+0x1696>
    37a8:	00002097          	auipc	ra,0x2
    37ac:	36a080e7          	jalr	874(ra) # 5b12 <printf>
    exit(1);
    37b0:	4505                	li	a0,1
    37b2:	00002097          	auipc	ra,0x2
    37b6:	fce080e7          	jalr	-50(ra) # 5780 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    37ba:	85ca                	mv	a1,s2
    37bc:	00004517          	auipc	a0,0x4
    37c0:	ad450513          	addi	a0,a0,-1324 # 7290 <malloc+0x16c6>
    37c4:	00002097          	auipc	ra,0x2
    37c8:	34e080e7          	jalr	846(ra) # 5b12 <printf>
    exit(1);
    37cc:	4505                	li	a0,1
    37ce:	00002097          	auipc	ra,0x2
    37d2:	fb2080e7          	jalr	-78(ra) # 5780 <exit>
    printf("%s: create dd succeeded!\n", s);
    37d6:	85ca                	mv	a1,s2
    37d8:	00004517          	auipc	a0,0x4
    37dc:	ad850513          	addi	a0,a0,-1320 # 72b0 <malloc+0x16e6>
    37e0:	00002097          	auipc	ra,0x2
    37e4:	332080e7          	jalr	818(ra) # 5b12 <printf>
    exit(1);
    37e8:	4505                	li	a0,1
    37ea:	00002097          	auipc	ra,0x2
    37ee:	f96080e7          	jalr	-106(ra) # 5780 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    37f2:	85ca                	mv	a1,s2
    37f4:	00004517          	auipc	a0,0x4
    37f8:	adc50513          	addi	a0,a0,-1316 # 72d0 <malloc+0x1706>
    37fc:	00002097          	auipc	ra,0x2
    3800:	316080e7          	jalr	790(ra) # 5b12 <printf>
    exit(1);
    3804:	4505                	li	a0,1
    3806:	00002097          	auipc	ra,0x2
    380a:	f7a080e7          	jalr	-134(ra) # 5780 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    380e:	85ca                	mv	a1,s2
    3810:	00004517          	auipc	a0,0x4
    3814:	ae050513          	addi	a0,a0,-1312 # 72f0 <malloc+0x1726>
    3818:	00002097          	auipc	ra,0x2
    381c:	2fa080e7          	jalr	762(ra) # 5b12 <printf>
    exit(1);
    3820:	4505                	li	a0,1
    3822:	00002097          	auipc	ra,0x2
    3826:	f5e080e7          	jalr	-162(ra) # 5780 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    382a:	85ca                	mv	a1,s2
    382c:	00004517          	auipc	a0,0x4
    3830:	af450513          	addi	a0,a0,-1292 # 7320 <malloc+0x1756>
    3834:	00002097          	auipc	ra,0x2
    3838:	2de080e7          	jalr	734(ra) # 5b12 <printf>
    exit(1);
    383c:	4505                	li	a0,1
    383e:	00002097          	auipc	ra,0x2
    3842:	f42080e7          	jalr	-190(ra) # 5780 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3846:	85ca                	mv	a1,s2
    3848:	00004517          	auipc	a0,0x4
    384c:	b0050513          	addi	a0,a0,-1280 # 7348 <malloc+0x177e>
    3850:	00002097          	auipc	ra,0x2
    3854:	2c2080e7          	jalr	706(ra) # 5b12 <printf>
    exit(1);
    3858:	4505                	li	a0,1
    385a:	00002097          	auipc	ra,0x2
    385e:	f26080e7          	jalr	-218(ra) # 5780 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3862:	85ca                	mv	a1,s2
    3864:	00004517          	auipc	a0,0x4
    3868:	b0c50513          	addi	a0,a0,-1268 # 7370 <malloc+0x17a6>
    386c:	00002097          	auipc	ra,0x2
    3870:	2a6080e7          	jalr	678(ra) # 5b12 <printf>
    exit(1);
    3874:	4505                	li	a0,1
    3876:	00002097          	auipc	ra,0x2
    387a:	f0a080e7          	jalr	-246(ra) # 5780 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    387e:	85ca                	mv	a1,s2
    3880:	00004517          	auipc	a0,0x4
    3884:	b1850513          	addi	a0,a0,-1256 # 7398 <malloc+0x17ce>
    3888:	00002097          	auipc	ra,0x2
    388c:	28a080e7          	jalr	650(ra) # 5b12 <printf>
    exit(1);
    3890:	4505                	li	a0,1
    3892:	00002097          	auipc	ra,0x2
    3896:	eee080e7          	jalr	-274(ra) # 5780 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    389a:	85ca                	mv	a1,s2
    389c:	00004517          	auipc	a0,0x4
    38a0:	b1c50513          	addi	a0,a0,-1252 # 73b8 <malloc+0x17ee>
    38a4:	00002097          	auipc	ra,0x2
    38a8:	26e080e7          	jalr	622(ra) # 5b12 <printf>
    exit(1);
    38ac:	4505                	li	a0,1
    38ae:	00002097          	auipc	ra,0x2
    38b2:	ed2080e7          	jalr	-302(ra) # 5780 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    38b6:	85ca                	mv	a1,s2
    38b8:	00004517          	auipc	a0,0x4
    38bc:	b2050513          	addi	a0,a0,-1248 # 73d8 <malloc+0x180e>
    38c0:	00002097          	auipc	ra,0x2
    38c4:	252080e7          	jalr	594(ra) # 5b12 <printf>
    exit(1);
    38c8:	4505                	li	a0,1
    38ca:	00002097          	auipc	ra,0x2
    38ce:	eb6080e7          	jalr	-330(ra) # 5780 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    38d2:	85ca                	mv	a1,s2
    38d4:	00004517          	auipc	a0,0x4
    38d8:	b2c50513          	addi	a0,a0,-1236 # 7400 <malloc+0x1836>
    38dc:	00002097          	auipc	ra,0x2
    38e0:	236080e7          	jalr	566(ra) # 5b12 <printf>
    exit(1);
    38e4:	4505                	li	a0,1
    38e6:	00002097          	auipc	ra,0x2
    38ea:	e9a080e7          	jalr	-358(ra) # 5780 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    38ee:	85ca                	mv	a1,s2
    38f0:	00004517          	auipc	a0,0x4
    38f4:	b3050513          	addi	a0,a0,-1232 # 7420 <malloc+0x1856>
    38f8:	00002097          	auipc	ra,0x2
    38fc:	21a080e7          	jalr	538(ra) # 5b12 <printf>
    exit(1);
    3900:	4505                	li	a0,1
    3902:	00002097          	auipc	ra,0x2
    3906:	e7e080e7          	jalr	-386(ra) # 5780 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    390a:	85ca                	mv	a1,s2
    390c:	00004517          	auipc	a0,0x4
    3910:	b3450513          	addi	a0,a0,-1228 # 7440 <malloc+0x1876>
    3914:	00002097          	auipc	ra,0x2
    3918:	1fe080e7          	jalr	510(ra) # 5b12 <printf>
    exit(1);
    391c:	4505                	li	a0,1
    391e:	00002097          	auipc	ra,0x2
    3922:	e62080e7          	jalr	-414(ra) # 5780 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3926:	85ca                	mv	a1,s2
    3928:	00004517          	auipc	a0,0x4
    392c:	b4050513          	addi	a0,a0,-1216 # 7468 <malloc+0x189e>
    3930:	00002097          	auipc	ra,0x2
    3934:	1e2080e7          	jalr	482(ra) # 5b12 <printf>
    exit(1);
    3938:	4505                	li	a0,1
    393a:	00002097          	auipc	ra,0x2
    393e:	e46080e7          	jalr	-442(ra) # 5780 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3942:	85ca                	mv	a1,s2
    3944:	00003517          	auipc	a0,0x3
    3948:	7bc50513          	addi	a0,a0,1980 # 7100 <malloc+0x1536>
    394c:	00002097          	auipc	ra,0x2
    3950:	1c6080e7          	jalr	454(ra) # 5b12 <printf>
    exit(1);
    3954:	4505                	li	a0,1
    3956:	00002097          	auipc	ra,0x2
    395a:	e2a080e7          	jalr	-470(ra) # 5780 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    395e:	85ca                	mv	a1,s2
    3960:	00004517          	auipc	a0,0x4
    3964:	b2850513          	addi	a0,a0,-1240 # 7488 <malloc+0x18be>
    3968:	00002097          	auipc	ra,0x2
    396c:	1aa080e7          	jalr	426(ra) # 5b12 <printf>
    exit(1);
    3970:	4505                	li	a0,1
    3972:	00002097          	auipc	ra,0x2
    3976:	e0e080e7          	jalr	-498(ra) # 5780 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    397a:	85ca                	mv	a1,s2
    397c:	00004517          	auipc	a0,0x4
    3980:	b2c50513          	addi	a0,a0,-1236 # 74a8 <malloc+0x18de>
    3984:	00002097          	auipc	ra,0x2
    3988:	18e080e7          	jalr	398(ra) # 5b12 <printf>
    exit(1);
    398c:	4505                	li	a0,1
    398e:	00002097          	auipc	ra,0x2
    3992:	df2080e7          	jalr	-526(ra) # 5780 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3996:	85ca                	mv	a1,s2
    3998:	00004517          	auipc	a0,0x4
    399c:	b4050513          	addi	a0,a0,-1216 # 74d8 <malloc+0x190e>
    39a0:	00002097          	auipc	ra,0x2
    39a4:	172080e7          	jalr	370(ra) # 5b12 <printf>
    exit(1);
    39a8:	4505                	li	a0,1
    39aa:	00002097          	auipc	ra,0x2
    39ae:	dd6080e7          	jalr	-554(ra) # 5780 <exit>
    printf("%s: unlink dd failed\n", s);
    39b2:	85ca                	mv	a1,s2
    39b4:	00004517          	auipc	a0,0x4
    39b8:	b4450513          	addi	a0,a0,-1212 # 74f8 <malloc+0x192e>
    39bc:	00002097          	auipc	ra,0x2
    39c0:	156080e7          	jalr	342(ra) # 5b12 <printf>
    exit(1);
    39c4:	4505                	li	a0,1
    39c6:	00002097          	auipc	ra,0x2
    39ca:	dba080e7          	jalr	-582(ra) # 5780 <exit>

00000000000039ce <rmdot>:
{
    39ce:	1101                	addi	sp,sp,-32
    39d0:	ec06                	sd	ra,24(sp)
    39d2:	e822                	sd	s0,16(sp)
    39d4:	e426                	sd	s1,8(sp)
    39d6:	1000                	addi	s0,sp,32
    39d8:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    39da:	00004517          	auipc	a0,0x4
    39de:	b3650513          	addi	a0,a0,-1226 # 7510 <malloc+0x1946>
    39e2:	00002097          	auipc	ra,0x2
    39e6:	e06080e7          	jalr	-506(ra) # 57e8 <mkdir>
    39ea:	e549                	bnez	a0,3a74 <rmdot+0xa6>
  if(chdir("dots") != 0){
    39ec:	00004517          	auipc	a0,0x4
    39f0:	b2450513          	addi	a0,a0,-1244 # 7510 <malloc+0x1946>
    39f4:	00002097          	auipc	ra,0x2
    39f8:	dfc080e7          	jalr	-516(ra) # 57f0 <chdir>
    39fc:	e951                	bnez	a0,3a90 <rmdot+0xc2>
  if(unlink(".") == 0){
    39fe:	00003517          	auipc	a0,0x3
    3a02:	9a250513          	addi	a0,a0,-1630 # 63a0 <malloc+0x7d6>
    3a06:	00002097          	auipc	ra,0x2
    3a0a:	dca080e7          	jalr	-566(ra) # 57d0 <unlink>
    3a0e:	cd59                	beqz	a0,3aac <rmdot+0xde>
  if(unlink("..") == 0){
    3a10:	00003517          	auipc	a0,0x3
    3a14:	55850513          	addi	a0,a0,1368 # 6f68 <malloc+0x139e>
    3a18:	00002097          	auipc	ra,0x2
    3a1c:	db8080e7          	jalr	-584(ra) # 57d0 <unlink>
    3a20:	c545                	beqz	a0,3ac8 <rmdot+0xfa>
  if(chdir("/") != 0){
    3a22:	00003517          	auipc	a0,0x3
    3a26:	4ee50513          	addi	a0,a0,1262 # 6f10 <malloc+0x1346>
    3a2a:	00002097          	auipc	ra,0x2
    3a2e:	dc6080e7          	jalr	-570(ra) # 57f0 <chdir>
    3a32:	e94d                	bnez	a0,3ae4 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3a34:	00004517          	auipc	a0,0x4
    3a38:	b4450513          	addi	a0,a0,-1212 # 7578 <malloc+0x19ae>
    3a3c:	00002097          	auipc	ra,0x2
    3a40:	d94080e7          	jalr	-620(ra) # 57d0 <unlink>
    3a44:	cd55                	beqz	a0,3b00 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3a46:	00004517          	auipc	a0,0x4
    3a4a:	b5a50513          	addi	a0,a0,-1190 # 75a0 <malloc+0x19d6>
    3a4e:	00002097          	auipc	ra,0x2
    3a52:	d82080e7          	jalr	-638(ra) # 57d0 <unlink>
    3a56:	c179                	beqz	a0,3b1c <rmdot+0x14e>
  if(unlink("dots") != 0){
    3a58:	00004517          	auipc	a0,0x4
    3a5c:	ab850513          	addi	a0,a0,-1352 # 7510 <malloc+0x1946>
    3a60:	00002097          	auipc	ra,0x2
    3a64:	d70080e7          	jalr	-656(ra) # 57d0 <unlink>
    3a68:	e961                	bnez	a0,3b38 <rmdot+0x16a>
}
    3a6a:	60e2                	ld	ra,24(sp)
    3a6c:	6442                	ld	s0,16(sp)
    3a6e:	64a2                	ld	s1,8(sp)
    3a70:	6105                	addi	sp,sp,32
    3a72:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3a74:	85a6                	mv	a1,s1
    3a76:	00004517          	auipc	a0,0x4
    3a7a:	aa250513          	addi	a0,a0,-1374 # 7518 <malloc+0x194e>
    3a7e:	00002097          	auipc	ra,0x2
    3a82:	094080e7          	jalr	148(ra) # 5b12 <printf>
    exit(1);
    3a86:	4505                	li	a0,1
    3a88:	00002097          	auipc	ra,0x2
    3a8c:	cf8080e7          	jalr	-776(ra) # 5780 <exit>
    printf("%s: chdir dots failed\n", s);
    3a90:	85a6                	mv	a1,s1
    3a92:	00004517          	auipc	a0,0x4
    3a96:	a9e50513          	addi	a0,a0,-1378 # 7530 <malloc+0x1966>
    3a9a:	00002097          	auipc	ra,0x2
    3a9e:	078080e7          	jalr	120(ra) # 5b12 <printf>
    exit(1);
    3aa2:	4505                	li	a0,1
    3aa4:	00002097          	auipc	ra,0x2
    3aa8:	cdc080e7          	jalr	-804(ra) # 5780 <exit>
    printf("%s: rm . worked!\n", s);
    3aac:	85a6                	mv	a1,s1
    3aae:	00004517          	auipc	a0,0x4
    3ab2:	a9a50513          	addi	a0,a0,-1382 # 7548 <malloc+0x197e>
    3ab6:	00002097          	auipc	ra,0x2
    3aba:	05c080e7          	jalr	92(ra) # 5b12 <printf>
    exit(1);
    3abe:	4505                	li	a0,1
    3ac0:	00002097          	auipc	ra,0x2
    3ac4:	cc0080e7          	jalr	-832(ra) # 5780 <exit>
    printf("%s: rm .. worked!\n", s);
    3ac8:	85a6                	mv	a1,s1
    3aca:	00004517          	auipc	a0,0x4
    3ace:	a9650513          	addi	a0,a0,-1386 # 7560 <malloc+0x1996>
    3ad2:	00002097          	auipc	ra,0x2
    3ad6:	040080e7          	jalr	64(ra) # 5b12 <printf>
    exit(1);
    3ada:	4505                	li	a0,1
    3adc:	00002097          	auipc	ra,0x2
    3ae0:	ca4080e7          	jalr	-860(ra) # 5780 <exit>
    printf("%s: chdir / failed\n", s);
    3ae4:	85a6                	mv	a1,s1
    3ae6:	00003517          	auipc	a0,0x3
    3aea:	43250513          	addi	a0,a0,1074 # 6f18 <malloc+0x134e>
    3aee:	00002097          	auipc	ra,0x2
    3af2:	024080e7          	jalr	36(ra) # 5b12 <printf>
    exit(1);
    3af6:	4505                	li	a0,1
    3af8:	00002097          	auipc	ra,0x2
    3afc:	c88080e7          	jalr	-888(ra) # 5780 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3b00:	85a6                	mv	a1,s1
    3b02:	00004517          	auipc	a0,0x4
    3b06:	a7e50513          	addi	a0,a0,-1410 # 7580 <malloc+0x19b6>
    3b0a:	00002097          	auipc	ra,0x2
    3b0e:	008080e7          	jalr	8(ra) # 5b12 <printf>
    exit(1);
    3b12:	4505                	li	a0,1
    3b14:	00002097          	auipc	ra,0x2
    3b18:	c6c080e7          	jalr	-916(ra) # 5780 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3b1c:	85a6                	mv	a1,s1
    3b1e:	00004517          	auipc	a0,0x4
    3b22:	a8a50513          	addi	a0,a0,-1398 # 75a8 <malloc+0x19de>
    3b26:	00002097          	auipc	ra,0x2
    3b2a:	fec080e7          	jalr	-20(ra) # 5b12 <printf>
    exit(1);
    3b2e:	4505                	li	a0,1
    3b30:	00002097          	auipc	ra,0x2
    3b34:	c50080e7          	jalr	-944(ra) # 5780 <exit>
    printf("%s: unlink dots failed!\n", s);
    3b38:	85a6                	mv	a1,s1
    3b3a:	00004517          	auipc	a0,0x4
    3b3e:	a8e50513          	addi	a0,a0,-1394 # 75c8 <malloc+0x19fe>
    3b42:	00002097          	auipc	ra,0x2
    3b46:	fd0080e7          	jalr	-48(ra) # 5b12 <printf>
    exit(1);
    3b4a:	4505                	li	a0,1
    3b4c:	00002097          	auipc	ra,0x2
    3b50:	c34080e7          	jalr	-972(ra) # 5780 <exit>

0000000000003b54 <dirfile>:
{
    3b54:	1101                	addi	sp,sp,-32
    3b56:	ec06                	sd	ra,24(sp)
    3b58:	e822                	sd	s0,16(sp)
    3b5a:	e426                	sd	s1,8(sp)
    3b5c:	e04a                	sd	s2,0(sp)
    3b5e:	1000                	addi	s0,sp,32
    3b60:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3b62:	20000593          	li	a1,512
    3b66:	00004517          	auipc	a0,0x4
    3b6a:	a8250513          	addi	a0,a0,-1406 # 75e8 <malloc+0x1a1e>
    3b6e:	00002097          	auipc	ra,0x2
    3b72:	c52080e7          	jalr	-942(ra) # 57c0 <open>
  if(fd < 0){
    3b76:	0e054d63          	bltz	a0,3c70 <dirfile+0x11c>
  close(fd);
    3b7a:	00002097          	auipc	ra,0x2
    3b7e:	c2e080e7          	jalr	-978(ra) # 57a8 <close>
  if(chdir("dirfile") == 0){
    3b82:	00004517          	auipc	a0,0x4
    3b86:	a6650513          	addi	a0,a0,-1434 # 75e8 <malloc+0x1a1e>
    3b8a:	00002097          	auipc	ra,0x2
    3b8e:	c66080e7          	jalr	-922(ra) # 57f0 <chdir>
    3b92:	cd6d                	beqz	a0,3c8c <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    3b94:	4581                	li	a1,0
    3b96:	00004517          	auipc	a0,0x4
    3b9a:	a9a50513          	addi	a0,a0,-1382 # 7630 <malloc+0x1a66>
    3b9e:	00002097          	auipc	ra,0x2
    3ba2:	c22080e7          	jalr	-990(ra) # 57c0 <open>
  if(fd >= 0){
    3ba6:	10055163          	bgez	a0,3ca8 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    3baa:	20000593          	li	a1,512
    3bae:	00004517          	auipc	a0,0x4
    3bb2:	a8250513          	addi	a0,a0,-1406 # 7630 <malloc+0x1a66>
    3bb6:	00002097          	auipc	ra,0x2
    3bba:	c0a080e7          	jalr	-1014(ra) # 57c0 <open>
  if(fd >= 0){
    3bbe:	10055363          	bgez	a0,3cc4 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    3bc2:	00004517          	auipc	a0,0x4
    3bc6:	a6e50513          	addi	a0,a0,-1426 # 7630 <malloc+0x1a66>
    3bca:	00002097          	auipc	ra,0x2
    3bce:	c1e080e7          	jalr	-994(ra) # 57e8 <mkdir>
    3bd2:	10050763          	beqz	a0,3ce0 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    3bd6:	00004517          	auipc	a0,0x4
    3bda:	a5a50513          	addi	a0,a0,-1446 # 7630 <malloc+0x1a66>
    3bde:	00002097          	auipc	ra,0x2
    3be2:	bf2080e7          	jalr	-1038(ra) # 57d0 <unlink>
    3be6:	10050b63          	beqz	a0,3cfc <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    3bea:	00004597          	auipc	a1,0x4
    3bee:	a4658593          	addi	a1,a1,-1466 # 7630 <malloc+0x1a66>
    3bf2:	00002517          	auipc	a0,0x2
    3bf6:	29e50513          	addi	a0,a0,670 # 5e90 <malloc+0x2c6>
    3bfa:	00002097          	auipc	ra,0x2
    3bfe:	be6080e7          	jalr	-1050(ra) # 57e0 <link>
    3c02:	10050b63          	beqz	a0,3d18 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    3c06:	00004517          	auipc	a0,0x4
    3c0a:	9e250513          	addi	a0,a0,-1566 # 75e8 <malloc+0x1a1e>
    3c0e:	00002097          	auipc	ra,0x2
    3c12:	bc2080e7          	jalr	-1086(ra) # 57d0 <unlink>
    3c16:	10051f63          	bnez	a0,3d34 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    3c1a:	4589                	li	a1,2
    3c1c:	00002517          	auipc	a0,0x2
    3c20:	78450513          	addi	a0,a0,1924 # 63a0 <malloc+0x7d6>
    3c24:	00002097          	auipc	ra,0x2
    3c28:	b9c080e7          	jalr	-1124(ra) # 57c0 <open>
  if(fd >= 0){
    3c2c:	12055263          	bgez	a0,3d50 <dirfile+0x1fc>
  fd = open(".", 0);
    3c30:	4581                	li	a1,0
    3c32:	00002517          	auipc	a0,0x2
    3c36:	76e50513          	addi	a0,a0,1902 # 63a0 <malloc+0x7d6>
    3c3a:	00002097          	auipc	ra,0x2
    3c3e:	b86080e7          	jalr	-1146(ra) # 57c0 <open>
    3c42:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3c44:	4605                	li	a2,1
    3c46:	00002597          	auipc	a1,0x2
    3c4a:	11258593          	addi	a1,a1,274 # 5d58 <malloc+0x18e>
    3c4e:	00002097          	auipc	ra,0x2
    3c52:	b52080e7          	jalr	-1198(ra) # 57a0 <write>
    3c56:	10a04b63          	bgtz	a0,3d6c <dirfile+0x218>
  close(fd);
    3c5a:	8526                	mv	a0,s1
    3c5c:	00002097          	auipc	ra,0x2
    3c60:	b4c080e7          	jalr	-1204(ra) # 57a8 <close>
}
    3c64:	60e2                	ld	ra,24(sp)
    3c66:	6442                	ld	s0,16(sp)
    3c68:	64a2                	ld	s1,8(sp)
    3c6a:	6902                	ld	s2,0(sp)
    3c6c:	6105                	addi	sp,sp,32
    3c6e:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3c70:	85ca                	mv	a1,s2
    3c72:	00004517          	auipc	a0,0x4
    3c76:	97e50513          	addi	a0,a0,-1666 # 75f0 <malloc+0x1a26>
    3c7a:	00002097          	auipc	ra,0x2
    3c7e:	e98080e7          	jalr	-360(ra) # 5b12 <printf>
    exit(1);
    3c82:	4505                	li	a0,1
    3c84:	00002097          	auipc	ra,0x2
    3c88:	afc080e7          	jalr	-1284(ra) # 5780 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3c8c:	85ca                	mv	a1,s2
    3c8e:	00004517          	auipc	a0,0x4
    3c92:	98250513          	addi	a0,a0,-1662 # 7610 <malloc+0x1a46>
    3c96:	00002097          	auipc	ra,0x2
    3c9a:	e7c080e7          	jalr	-388(ra) # 5b12 <printf>
    exit(1);
    3c9e:	4505                	li	a0,1
    3ca0:	00002097          	auipc	ra,0x2
    3ca4:	ae0080e7          	jalr	-1312(ra) # 5780 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3ca8:	85ca                	mv	a1,s2
    3caa:	00004517          	auipc	a0,0x4
    3cae:	99650513          	addi	a0,a0,-1642 # 7640 <malloc+0x1a76>
    3cb2:	00002097          	auipc	ra,0x2
    3cb6:	e60080e7          	jalr	-416(ra) # 5b12 <printf>
    exit(1);
    3cba:	4505                	li	a0,1
    3cbc:	00002097          	auipc	ra,0x2
    3cc0:	ac4080e7          	jalr	-1340(ra) # 5780 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3cc4:	85ca                	mv	a1,s2
    3cc6:	00004517          	auipc	a0,0x4
    3cca:	97a50513          	addi	a0,a0,-1670 # 7640 <malloc+0x1a76>
    3cce:	00002097          	auipc	ra,0x2
    3cd2:	e44080e7          	jalr	-444(ra) # 5b12 <printf>
    exit(1);
    3cd6:	4505                	li	a0,1
    3cd8:	00002097          	auipc	ra,0x2
    3cdc:	aa8080e7          	jalr	-1368(ra) # 5780 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    3ce0:	85ca                	mv	a1,s2
    3ce2:	00004517          	auipc	a0,0x4
    3ce6:	98650513          	addi	a0,a0,-1658 # 7668 <malloc+0x1a9e>
    3cea:	00002097          	auipc	ra,0x2
    3cee:	e28080e7          	jalr	-472(ra) # 5b12 <printf>
    exit(1);
    3cf2:	4505                	li	a0,1
    3cf4:	00002097          	auipc	ra,0x2
    3cf8:	a8c080e7          	jalr	-1396(ra) # 5780 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3cfc:	85ca                	mv	a1,s2
    3cfe:	00004517          	auipc	a0,0x4
    3d02:	99250513          	addi	a0,a0,-1646 # 7690 <malloc+0x1ac6>
    3d06:	00002097          	auipc	ra,0x2
    3d0a:	e0c080e7          	jalr	-500(ra) # 5b12 <printf>
    exit(1);
    3d0e:	4505                	li	a0,1
    3d10:	00002097          	auipc	ra,0x2
    3d14:	a70080e7          	jalr	-1424(ra) # 5780 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3d18:	85ca                	mv	a1,s2
    3d1a:	00004517          	auipc	a0,0x4
    3d1e:	99e50513          	addi	a0,a0,-1634 # 76b8 <malloc+0x1aee>
    3d22:	00002097          	auipc	ra,0x2
    3d26:	df0080e7          	jalr	-528(ra) # 5b12 <printf>
    exit(1);
    3d2a:	4505                	li	a0,1
    3d2c:	00002097          	auipc	ra,0x2
    3d30:	a54080e7          	jalr	-1452(ra) # 5780 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3d34:	85ca                	mv	a1,s2
    3d36:	00004517          	auipc	a0,0x4
    3d3a:	9aa50513          	addi	a0,a0,-1622 # 76e0 <malloc+0x1b16>
    3d3e:	00002097          	auipc	ra,0x2
    3d42:	dd4080e7          	jalr	-556(ra) # 5b12 <printf>
    exit(1);
    3d46:	4505                	li	a0,1
    3d48:	00002097          	auipc	ra,0x2
    3d4c:	a38080e7          	jalr	-1480(ra) # 5780 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3d50:	85ca                	mv	a1,s2
    3d52:	00004517          	auipc	a0,0x4
    3d56:	9ae50513          	addi	a0,a0,-1618 # 7700 <malloc+0x1b36>
    3d5a:	00002097          	auipc	ra,0x2
    3d5e:	db8080e7          	jalr	-584(ra) # 5b12 <printf>
    exit(1);
    3d62:	4505                	li	a0,1
    3d64:	00002097          	auipc	ra,0x2
    3d68:	a1c080e7          	jalr	-1508(ra) # 5780 <exit>
    printf("%s: write . succeeded!\n", s);
    3d6c:	85ca                	mv	a1,s2
    3d6e:	00004517          	auipc	a0,0x4
    3d72:	9ba50513          	addi	a0,a0,-1606 # 7728 <malloc+0x1b5e>
    3d76:	00002097          	auipc	ra,0x2
    3d7a:	d9c080e7          	jalr	-612(ra) # 5b12 <printf>
    exit(1);
    3d7e:	4505                	li	a0,1
    3d80:	00002097          	auipc	ra,0x2
    3d84:	a00080e7          	jalr	-1536(ra) # 5780 <exit>

0000000000003d88 <iref>:
{
    3d88:	7139                	addi	sp,sp,-64
    3d8a:	fc06                	sd	ra,56(sp)
    3d8c:	f822                	sd	s0,48(sp)
    3d8e:	f426                	sd	s1,40(sp)
    3d90:	f04a                	sd	s2,32(sp)
    3d92:	ec4e                	sd	s3,24(sp)
    3d94:	e852                	sd	s4,16(sp)
    3d96:	e456                	sd	s5,8(sp)
    3d98:	e05a                	sd	s6,0(sp)
    3d9a:	0080                	addi	s0,sp,64
    3d9c:	8b2a                	mv	s6,a0
    3d9e:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    3da2:	00004a17          	auipc	s4,0x4
    3da6:	99ea0a13          	addi	s4,s4,-1634 # 7740 <malloc+0x1b76>
    mkdir("");
    3daa:	00003497          	auipc	s1,0x3
    3dae:	49e48493          	addi	s1,s1,1182 # 7248 <malloc+0x167e>
    link("README", "");
    3db2:	00002a97          	auipc	s5,0x2
    3db6:	0dea8a93          	addi	s5,s5,222 # 5e90 <malloc+0x2c6>
    fd = open("xx", O_CREATE);
    3dba:	00004997          	auipc	s3,0x4
    3dbe:	87e98993          	addi	s3,s3,-1922 # 7638 <malloc+0x1a6e>
    3dc2:	a891                	j	3e16 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    3dc4:	85da                	mv	a1,s6
    3dc6:	00004517          	auipc	a0,0x4
    3dca:	98250513          	addi	a0,a0,-1662 # 7748 <malloc+0x1b7e>
    3dce:	00002097          	auipc	ra,0x2
    3dd2:	d44080e7          	jalr	-700(ra) # 5b12 <printf>
      exit(1);
    3dd6:	4505                	li	a0,1
    3dd8:	00002097          	auipc	ra,0x2
    3ddc:	9a8080e7          	jalr	-1624(ra) # 5780 <exit>
      printf("%s: chdir irefd failed\n", s);
    3de0:	85da                	mv	a1,s6
    3de2:	00004517          	auipc	a0,0x4
    3de6:	97e50513          	addi	a0,a0,-1666 # 7760 <malloc+0x1b96>
    3dea:	00002097          	auipc	ra,0x2
    3dee:	d28080e7          	jalr	-728(ra) # 5b12 <printf>
      exit(1);
    3df2:	4505                	li	a0,1
    3df4:	00002097          	auipc	ra,0x2
    3df8:	98c080e7          	jalr	-1652(ra) # 5780 <exit>
      close(fd);
    3dfc:	00002097          	auipc	ra,0x2
    3e00:	9ac080e7          	jalr	-1620(ra) # 57a8 <close>
    3e04:	a889                	j	3e56 <iref+0xce>
    unlink("xx");
    3e06:	854e                	mv	a0,s3
    3e08:	00002097          	auipc	ra,0x2
    3e0c:	9c8080e7          	jalr	-1592(ra) # 57d0 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3e10:	397d                	addiw	s2,s2,-1
    3e12:	06090063          	beqz	s2,3e72 <iref+0xea>
    if(mkdir("irefd") != 0){
    3e16:	8552                	mv	a0,s4
    3e18:	00002097          	auipc	ra,0x2
    3e1c:	9d0080e7          	jalr	-1584(ra) # 57e8 <mkdir>
    3e20:	f155                	bnez	a0,3dc4 <iref+0x3c>
    if(chdir("irefd") != 0){
    3e22:	8552                	mv	a0,s4
    3e24:	00002097          	auipc	ra,0x2
    3e28:	9cc080e7          	jalr	-1588(ra) # 57f0 <chdir>
    3e2c:	f955                	bnez	a0,3de0 <iref+0x58>
    mkdir("");
    3e2e:	8526                	mv	a0,s1
    3e30:	00002097          	auipc	ra,0x2
    3e34:	9b8080e7          	jalr	-1608(ra) # 57e8 <mkdir>
    link("README", "");
    3e38:	85a6                	mv	a1,s1
    3e3a:	8556                	mv	a0,s5
    3e3c:	00002097          	auipc	ra,0x2
    3e40:	9a4080e7          	jalr	-1628(ra) # 57e0 <link>
    fd = open("", O_CREATE);
    3e44:	20000593          	li	a1,512
    3e48:	8526                	mv	a0,s1
    3e4a:	00002097          	auipc	ra,0x2
    3e4e:	976080e7          	jalr	-1674(ra) # 57c0 <open>
    if(fd >= 0)
    3e52:	fa0555e3          	bgez	a0,3dfc <iref+0x74>
    fd = open("xx", O_CREATE);
    3e56:	20000593          	li	a1,512
    3e5a:	854e                	mv	a0,s3
    3e5c:	00002097          	auipc	ra,0x2
    3e60:	964080e7          	jalr	-1692(ra) # 57c0 <open>
    if(fd >= 0)
    3e64:	fa0541e3          	bltz	a0,3e06 <iref+0x7e>
      close(fd);
    3e68:	00002097          	auipc	ra,0x2
    3e6c:	940080e7          	jalr	-1728(ra) # 57a8 <close>
    3e70:	bf59                	j	3e06 <iref+0x7e>
    3e72:	03300493          	li	s1,51
    chdir("..");
    3e76:	00003997          	auipc	s3,0x3
    3e7a:	0f298993          	addi	s3,s3,242 # 6f68 <malloc+0x139e>
    unlink("irefd");
    3e7e:	00004917          	auipc	s2,0x4
    3e82:	8c290913          	addi	s2,s2,-1854 # 7740 <malloc+0x1b76>
    chdir("..");
    3e86:	854e                	mv	a0,s3
    3e88:	00002097          	auipc	ra,0x2
    3e8c:	968080e7          	jalr	-1688(ra) # 57f0 <chdir>
    unlink("irefd");
    3e90:	854a                	mv	a0,s2
    3e92:	00002097          	auipc	ra,0x2
    3e96:	93e080e7          	jalr	-1730(ra) # 57d0 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3e9a:	34fd                	addiw	s1,s1,-1
    3e9c:	f4ed                	bnez	s1,3e86 <iref+0xfe>
  chdir("/");
    3e9e:	00003517          	auipc	a0,0x3
    3ea2:	07250513          	addi	a0,a0,114 # 6f10 <malloc+0x1346>
    3ea6:	00002097          	auipc	ra,0x2
    3eaa:	94a080e7          	jalr	-1718(ra) # 57f0 <chdir>
}
    3eae:	70e2                	ld	ra,56(sp)
    3eb0:	7442                	ld	s0,48(sp)
    3eb2:	74a2                	ld	s1,40(sp)
    3eb4:	7902                	ld	s2,32(sp)
    3eb6:	69e2                	ld	s3,24(sp)
    3eb8:	6a42                	ld	s4,16(sp)
    3eba:	6aa2                	ld	s5,8(sp)
    3ebc:	6b02                	ld	s6,0(sp)
    3ebe:	6121                	addi	sp,sp,64
    3ec0:	8082                	ret

0000000000003ec2 <openiputtest>:
{
    3ec2:	7179                	addi	sp,sp,-48
    3ec4:	f406                	sd	ra,40(sp)
    3ec6:	f022                	sd	s0,32(sp)
    3ec8:	ec26                	sd	s1,24(sp)
    3eca:	1800                	addi	s0,sp,48
    3ecc:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    3ece:	00004517          	auipc	a0,0x4
    3ed2:	8aa50513          	addi	a0,a0,-1878 # 7778 <malloc+0x1bae>
    3ed6:	00002097          	auipc	ra,0x2
    3eda:	912080e7          	jalr	-1774(ra) # 57e8 <mkdir>
    3ede:	04054263          	bltz	a0,3f22 <openiputtest+0x60>
  pid = fork();
    3ee2:	00002097          	auipc	ra,0x2
    3ee6:	896080e7          	jalr	-1898(ra) # 5778 <fork>
  if(pid < 0){
    3eea:	04054a63          	bltz	a0,3f3e <openiputtest+0x7c>
  if(pid == 0){
    3eee:	e93d                	bnez	a0,3f64 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    3ef0:	4589                	li	a1,2
    3ef2:	00004517          	auipc	a0,0x4
    3ef6:	88650513          	addi	a0,a0,-1914 # 7778 <malloc+0x1bae>
    3efa:	00002097          	auipc	ra,0x2
    3efe:	8c6080e7          	jalr	-1850(ra) # 57c0 <open>
    if(fd >= 0){
    3f02:	04054c63          	bltz	a0,3f5a <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    3f06:	85a6                	mv	a1,s1
    3f08:	00004517          	auipc	a0,0x4
    3f0c:	89050513          	addi	a0,a0,-1904 # 7798 <malloc+0x1bce>
    3f10:	00002097          	auipc	ra,0x2
    3f14:	c02080e7          	jalr	-1022(ra) # 5b12 <printf>
      exit(1);
    3f18:	4505                	li	a0,1
    3f1a:	00002097          	auipc	ra,0x2
    3f1e:	866080e7          	jalr	-1946(ra) # 5780 <exit>
    printf("%s: mkdir oidir failed\n", s);
    3f22:	85a6                	mv	a1,s1
    3f24:	00004517          	auipc	a0,0x4
    3f28:	85c50513          	addi	a0,a0,-1956 # 7780 <malloc+0x1bb6>
    3f2c:	00002097          	auipc	ra,0x2
    3f30:	be6080e7          	jalr	-1050(ra) # 5b12 <printf>
    exit(1);
    3f34:	4505                	li	a0,1
    3f36:	00002097          	auipc	ra,0x2
    3f3a:	84a080e7          	jalr	-1974(ra) # 5780 <exit>
    printf("%s: fork failed\n", s);
    3f3e:	85a6                	mv	a1,s1
    3f40:	00002517          	auipc	a0,0x2
    3f44:	60050513          	addi	a0,a0,1536 # 6540 <malloc+0x976>
    3f48:	00002097          	auipc	ra,0x2
    3f4c:	bca080e7          	jalr	-1078(ra) # 5b12 <printf>
    exit(1);
    3f50:	4505                	li	a0,1
    3f52:	00002097          	auipc	ra,0x2
    3f56:	82e080e7          	jalr	-2002(ra) # 5780 <exit>
    exit(0);
    3f5a:	4501                	li	a0,0
    3f5c:	00002097          	auipc	ra,0x2
    3f60:	824080e7          	jalr	-2012(ra) # 5780 <exit>
  sleep(1);
    3f64:	4505                	li	a0,1
    3f66:	00002097          	auipc	ra,0x2
    3f6a:	8aa080e7          	jalr	-1878(ra) # 5810 <sleep>
  if(unlink("oidir") != 0){
    3f6e:	00004517          	auipc	a0,0x4
    3f72:	80a50513          	addi	a0,a0,-2038 # 7778 <malloc+0x1bae>
    3f76:	00002097          	auipc	ra,0x2
    3f7a:	85a080e7          	jalr	-1958(ra) # 57d0 <unlink>
    3f7e:	cd19                	beqz	a0,3f9c <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    3f80:	85a6                	mv	a1,s1
    3f82:	00002517          	auipc	a0,0x2
    3f86:	7ae50513          	addi	a0,a0,1966 # 6730 <malloc+0xb66>
    3f8a:	00002097          	auipc	ra,0x2
    3f8e:	b88080e7          	jalr	-1144(ra) # 5b12 <printf>
    exit(1);
    3f92:	4505                	li	a0,1
    3f94:	00001097          	auipc	ra,0x1
    3f98:	7ec080e7          	jalr	2028(ra) # 5780 <exit>
  wait(&xstatus);
    3f9c:	fdc40513          	addi	a0,s0,-36
    3fa0:	00001097          	auipc	ra,0x1
    3fa4:	7e8080e7          	jalr	2024(ra) # 5788 <wait>
  exit(xstatus);
    3fa8:	fdc42503          	lw	a0,-36(s0)
    3fac:	00001097          	auipc	ra,0x1
    3fb0:	7d4080e7          	jalr	2004(ra) # 5780 <exit>

0000000000003fb4 <forkforkfork>:
{
    3fb4:	1101                	addi	sp,sp,-32
    3fb6:	ec06                	sd	ra,24(sp)
    3fb8:	e822                	sd	s0,16(sp)
    3fba:	e426                	sd	s1,8(sp)
    3fbc:	1000                	addi	s0,sp,32
    3fbe:	84aa                	mv	s1,a0
  unlink("stopforking");
    3fc0:	00004517          	auipc	a0,0x4
    3fc4:	80050513          	addi	a0,a0,-2048 # 77c0 <malloc+0x1bf6>
    3fc8:	00002097          	auipc	ra,0x2
    3fcc:	808080e7          	jalr	-2040(ra) # 57d0 <unlink>
  int pid = fork();
    3fd0:	00001097          	auipc	ra,0x1
    3fd4:	7a8080e7          	jalr	1960(ra) # 5778 <fork>
  if(pid < 0){
    3fd8:	04054563          	bltz	a0,4022 <forkforkfork+0x6e>
  if(pid == 0){
    3fdc:	c12d                	beqz	a0,403e <forkforkfork+0x8a>
  sleep(20); // two seconds
    3fde:	4551                	li	a0,20
    3fe0:	00002097          	auipc	ra,0x2
    3fe4:	830080e7          	jalr	-2000(ra) # 5810 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    3fe8:	20200593          	li	a1,514
    3fec:	00003517          	auipc	a0,0x3
    3ff0:	7d450513          	addi	a0,a0,2004 # 77c0 <malloc+0x1bf6>
    3ff4:	00001097          	auipc	ra,0x1
    3ff8:	7cc080e7          	jalr	1996(ra) # 57c0 <open>
    3ffc:	00001097          	auipc	ra,0x1
    4000:	7ac080e7          	jalr	1964(ra) # 57a8 <close>
  wait(0);
    4004:	4501                	li	a0,0
    4006:	00001097          	auipc	ra,0x1
    400a:	782080e7          	jalr	1922(ra) # 5788 <wait>
  sleep(10); // one second
    400e:	4529                	li	a0,10
    4010:	00002097          	auipc	ra,0x2
    4014:	800080e7          	jalr	-2048(ra) # 5810 <sleep>
}
    4018:	60e2                	ld	ra,24(sp)
    401a:	6442                	ld	s0,16(sp)
    401c:	64a2                	ld	s1,8(sp)
    401e:	6105                	addi	sp,sp,32
    4020:	8082                	ret
    printf("%s: fork failed", s);
    4022:	85a6                	mv	a1,s1
    4024:	00002517          	auipc	a0,0x2
    4028:	6dc50513          	addi	a0,a0,1756 # 6700 <malloc+0xb36>
    402c:	00002097          	auipc	ra,0x2
    4030:	ae6080e7          	jalr	-1306(ra) # 5b12 <printf>
    exit(1);
    4034:	4505                	li	a0,1
    4036:	00001097          	auipc	ra,0x1
    403a:	74a080e7          	jalr	1866(ra) # 5780 <exit>
      int fd = open("stopforking", 0);
    403e:	00003497          	auipc	s1,0x3
    4042:	78248493          	addi	s1,s1,1922 # 77c0 <malloc+0x1bf6>
    4046:	4581                	li	a1,0
    4048:	8526                	mv	a0,s1
    404a:	00001097          	auipc	ra,0x1
    404e:	776080e7          	jalr	1910(ra) # 57c0 <open>
      if(fd >= 0){
    4052:	02055463          	bgez	a0,407a <forkforkfork+0xc6>
      if(fork() < 0){
    4056:	00001097          	auipc	ra,0x1
    405a:	722080e7          	jalr	1826(ra) # 5778 <fork>
    405e:	fe0554e3          	bgez	a0,4046 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    4062:	20200593          	li	a1,514
    4066:	8526                	mv	a0,s1
    4068:	00001097          	auipc	ra,0x1
    406c:	758080e7          	jalr	1880(ra) # 57c0 <open>
    4070:	00001097          	auipc	ra,0x1
    4074:	738080e7          	jalr	1848(ra) # 57a8 <close>
    4078:	b7f9                	j	4046 <forkforkfork+0x92>
        exit(0);
    407a:	4501                	li	a0,0
    407c:	00001097          	auipc	ra,0x1
    4080:	704080e7          	jalr	1796(ra) # 5780 <exit>

0000000000004084 <preempt>:
{
    4084:	7139                	addi	sp,sp,-64
    4086:	fc06                	sd	ra,56(sp)
    4088:	f822                	sd	s0,48(sp)
    408a:	f426                	sd	s1,40(sp)
    408c:	f04a                	sd	s2,32(sp)
    408e:	ec4e                	sd	s3,24(sp)
    4090:	e852                	sd	s4,16(sp)
    4092:	0080                	addi	s0,sp,64
    4094:	892a                	mv	s2,a0
  pid1 = fork();
    4096:	00001097          	auipc	ra,0x1
    409a:	6e2080e7          	jalr	1762(ra) # 5778 <fork>
  if(pid1 < 0) {
    409e:	00054563          	bltz	a0,40a8 <preempt+0x24>
    40a2:	84aa                	mv	s1,a0
  if(pid1 == 0)
    40a4:	e105                	bnez	a0,40c4 <preempt+0x40>
    for(;;)
    40a6:	a001                	j	40a6 <preempt+0x22>
    printf("%s: fork failed", s);
    40a8:	85ca                	mv	a1,s2
    40aa:	00002517          	auipc	a0,0x2
    40ae:	65650513          	addi	a0,a0,1622 # 6700 <malloc+0xb36>
    40b2:	00002097          	auipc	ra,0x2
    40b6:	a60080e7          	jalr	-1440(ra) # 5b12 <printf>
    exit(1);
    40ba:	4505                	li	a0,1
    40bc:	00001097          	auipc	ra,0x1
    40c0:	6c4080e7          	jalr	1732(ra) # 5780 <exit>
  pid2 = fork();
    40c4:	00001097          	auipc	ra,0x1
    40c8:	6b4080e7          	jalr	1716(ra) # 5778 <fork>
    40cc:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    40ce:	00054463          	bltz	a0,40d6 <preempt+0x52>
  if(pid2 == 0)
    40d2:	e105                	bnez	a0,40f2 <preempt+0x6e>
    for(;;)
    40d4:	a001                	j	40d4 <preempt+0x50>
    printf("%s: fork failed\n", s);
    40d6:	85ca                	mv	a1,s2
    40d8:	00002517          	auipc	a0,0x2
    40dc:	46850513          	addi	a0,a0,1128 # 6540 <malloc+0x976>
    40e0:	00002097          	auipc	ra,0x2
    40e4:	a32080e7          	jalr	-1486(ra) # 5b12 <printf>
    exit(1);
    40e8:	4505                	li	a0,1
    40ea:	00001097          	auipc	ra,0x1
    40ee:	696080e7          	jalr	1686(ra) # 5780 <exit>
  pipe(pfds);
    40f2:	fc840513          	addi	a0,s0,-56
    40f6:	00001097          	auipc	ra,0x1
    40fa:	69a080e7          	jalr	1690(ra) # 5790 <pipe>
  pid3 = fork();
    40fe:	00001097          	auipc	ra,0x1
    4102:	67a080e7          	jalr	1658(ra) # 5778 <fork>
    4106:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    4108:	02054e63          	bltz	a0,4144 <preempt+0xc0>
  if(pid3 == 0){
    410c:	e525                	bnez	a0,4174 <preempt+0xf0>
    close(pfds[0]);
    410e:	fc842503          	lw	a0,-56(s0)
    4112:	00001097          	auipc	ra,0x1
    4116:	696080e7          	jalr	1686(ra) # 57a8 <close>
    if(write(pfds[1], "x", 1) != 1)
    411a:	4605                	li	a2,1
    411c:	00002597          	auipc	a1,0x2
    4120:	c3c58593          	addi	a1,a1,-964 # 5d58 <malloc+0x18e>
    4124:	fcc42503          	lw	a0,-52(s0)
    4128:	00001097          	auipc	ra,0x1
    412c:	678080e7          	jalr	1656(ra) # 57a0 <write>
    4130:	4785                	li	a5,1
    4132:	02f51763          	bne	a0,a5,4160 <preempt+0xdc>
    close(pfds[1]);
    4136:	fcc42503          	lw	a0,-52(s0)
    413a:	00001097          	auipc	ra,0x1
    413e:	66e080e7          	jalr	1646(ra) # 57a8 <close>
    for(;;)
    4142:	a001                	j	4142 <preempt+0xbe>
     printf("%s: fork failed\n", s);
    4144:	85ca                	mv	a1,s2
    4146:	00002517          	auipc	a0,0x2
    414a:	3fa50513          	addi	a0,a0,1018 # 6540 <malloc+0x976>
    414e:	00002097          	auipc	ra,0x2
    4152:	9c4080e7          	jalr	-1596(ra) # 5b12 <printf>
     exit(1);
    4156:	4505                	li	a0,1
    4158:	00001097          	auipc	ra,0x1
    415c:	628080e7          	jalr	1576(ra) # 5780 <exit>
      printf("%s: preempt write error", s);
    4160:	85ca                	mv	a1,s2
    4162:	00003517          	auipc	a0,0x3
    4166:	66e50513          	addi	a0,a0,1646 # 77d0 <malloc+0x1c06>
    416a:	00002097          	auipc	ra,0x2
    416e:	9a8080e7          	jalr	-1624(ra) # 5b12 <printf>
    4172:	b7d1                	j	4136 <preempt+0xb2>
  close(pfds[1]);
    4174:	fcc42503          	lw	a0,-52(s0)
    4178:	00001097          	auipc	ra,0x1
    417c:	630080e7          	jalr	1584(ra) # 57a8 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    4180:	660d                	lui	a2,0x3
    4182:	00008597          	auipc	a1,0x8
    4186:	b6658593          	addi	a1,a1,-1178 # bce8 <buf>
    418a:	fc842503          	lw	a0,-56(s0)
    418e:	00001097          	auipc	ra,0x1
    4192:	60a080e7          	jalr	1546(ra) # 5798 <read>
    4196:	4785                	li	a5,1
    4198:	02f50363          	beq	a0,a5,41be <preempt+0x13a>
    printf("%s: preempt read error", s);
    419c:	85ca                	mv	a1,s2
    419e:	00003517          	auipc	a0,0x3
    41a2:	64a50513          	addi	a0,a0,1610 # 77e8 <malloc+0x1c1e>
    41a6:	00002097          	auipc	ra,0x2
    41aa:	96c080e7          	jalr	-1684(ra) # 5b12 <printf>
}
    41ae:	70e2                	ld	ra,56(sp)
    41b0:	7442                	ld	s0,48(sp)
    41b2:	74a2                	ld	s1,40(sp)
    41b4:	7902                	ld	s2,32(sp)
    41b6:	69e2                	ld	s3,24(sp)
    41b8:	6a42                	ld	s4,16(sp)
    41ba:	6121                	addi	sp,sp,64
    41bc:	8082                	ret
  close(pfds[0]);
    41be:	fc842503          	lw	a0,-56(s0)
    41c2:	00001097          	auipc	ra,0x1
    41c6:	5e6080e7          	jalr	1510(ra) # 57a8 <close>
  printf("kill... ");
    41ca:	00003517          	auipc	a0,0x3
    41ce:	63650513          	addi	a0,a0,1590 # 7800 <malloc+0x1c36>
    41d2:	00002097          	auipc	ra,0x2
    41d6:	940080e7          	jalr	-1728(ra) # 5b12 <printf>
  kill(pid1);
    41da:	8526                	mv	a0,s1
    41dc:	00001097          	auipc	ra,0x1
    41e0:	5d4080e7          	jalr	1492(ra) # 57b0 <kill>
  kill(pid2);
    41e4:	854e                	mv	a0,s3
    41e6:	00001097          	auipc	ra,0x1
    41ea:	5ca080e7          	jalr	1482(ra) # 57b0 <kill>
  kill(pid3);
    41ee:	8552                	mv	a0,s4
    41f0:	00001097          	auipc	ra,0x1
    41f4:	5c0080e7          	jalr	1472(ra) # 57b0 <kill>
  printf("wait... ");
    41f8:	00003517          	auipc	a0,0x3
    41fc:	61850513          	addi	a0,a0,1560 # 7810 <malloc+0x1c46>
    4200:	00002097          	auipc	ra,0x2
    4204:	912080e7          	jalr	-1774(ra) # 5b12 <printf>
  wait(0);
    4208:	4501                	li	a0,0
    420a:	00001097          	auipc	ra,0x1
    420e:	57e080e7          	jalr	1406(ra) # 5788 <wait>
  wait(0);
    4212:	4501                	li	a0,0
    4214:	00001097          	auipc	ra,0x1
    4218:	574080e7          	jalr	1396(ra) # 5788 <wait>
  wait(0);
    421c:	4501                	li	a0,0
    421e:	00001097          	auipc	ra,0x1
    4222:	56a080e7          	jalr	1386(ra) # 5788 <wait>
    4226:	b761                	j	41ae <preempt+0x12a>

0000000000004228 <sbrkfail>:
{
    4228:	7119                	addi	sp,sp,-128
    422a:	fc86                	sd	ra,120(sp)
    422c:	f8a2                	sd	s0,112(sp)
    422e:	f4a6                	sd	s1,104(sp)
    4230:	f0ca                	sd	s2,96(sp)
    4232:	ecce                	sd	s3,88(sp)
    4234:	e8d2                	sd	s4,80(sp)
    4236:	e4d6                	sd	s5,72(sp)
    4238:	0100                	addi	s0,sp,128
    423a:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    423c:	fb040513          	addi	a0,s0,-80
    4240:	00001097          	auipc	ra,0x1
    4244:	550080e7          	jalr	1360(ra) # 5790 <pipe>
    4248:	e901                	bnez	a0,4258 <sbrkfail+0x30>
    424a:	f8040493          	addi	s1,s0,-128
    424e:	fa840993          	addi	s3,s0,-88
    4252:	8926                	mv	s2,s1
    if(pids[i] != -1)
    4254:	5a7d                	li	s4,-1
    4256:	a085                	j	42b6 <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    4258:	85d6                	mv	a1,s5
    425a:	00002517          	auipc	a0,0x2
    425e:	3ee50513          	addi	a0,a0,1006 # 6648 <malloc+0xa7e>
    4262:	00002097          	auipc	ra,0x2
    4266:	8b0080e7          	jalr	-1872(ra) # 5b12 <printf>
    exit(1);
    426a:	4505                	li	a0,1
    426c:	00001097          	auipc	ra,0x1
    4270:	514080e7          	jalr	1300(ra) # 5780 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    4274:	00001097          	auipc	ra,0x1
    4278:	594080e7          	jalr	1428(ra) # 5808 <sbrk>
    427c:	064007b7          	lui	a5,0x6400
    4280:	40a7853b          	subw	a0,a5,a0
    4284:	00001097          	auipc	ra,0x1
    4288:	584080e7          	jalr	1412(ra) # 5808 <sbrk>
      write(fds[1], "x", 1);
    428c:	4605                	li	a2,1
    428e:	00002597          	auipc	a1,0x2
    4292:	aca58593          	addi	a1,a1,-1334 # 5d58 <malloc+0x18e>
    4296:	fb442503          	lw	a0,-76(s0)
    429a:	00001097          	auipc	ra,0x1
    429e:	506080e7          	jalr	1286(ra) # 57a0 <write>
      for(;;) sleep(1000);
    42a2:	3e800513          	li	a0,1000
    42a6:	00001097          	auipc	ra,0x1
    42aa:	56a080e7          	jalr	1386(ra) # 5810 <sleep>
    42ae:	bfd5                	j	42a2 <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    42b0:	0911                	addi	s2,s2,4
    42b2:	03390563          	beq	s2,s3,42dc <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    42b6:	00001097          	auipc	ra,0x1
    42ba:	4c2080e7          	jalr	1218(ra) # 5778 <fork>
    42be:	00a92023          	sw	a0,0(s2)
    42c2:	d94d                	beqz	a0,4274 <sbrkfail+0x4c>
    if(pids[i] != -1)
    42c4:	ff4506e3          	beq	a0,s4,42b0 <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    42c8:	4605                	li	a2,1
    42ca:	faf40593          	addi	a1,s0,-81
    42ce:	fb042503          	lw	a0,-80(s0)
    42d2:	00001097          	auipc	ra,0x1
    42d6:	4c6080e7          	jalr	1222(ra) # 5798 <read>
    42da:	bfd9                	j	42b0 <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    42dc:	6505                	lui	a0,0x1
    42de:	00001097          	auipc	ra,0x1
    42e2:	52a080e7          	jalr	1322(ra) # 5808 <sbrk>
    42e6:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    42e8:	597d                	li	s2,-1
    42ea:	a021                	j	42f2 <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    42ec:	0491                	addi	s1,s1,4
    42ee:	01348f63          	beq	s1,s3,430c <sbrkfail+0xe4>
    if(pids[i] == -1)
    42f2:	4088                	lw	a0,0(s1)
    42f4:	ff250ce3          	beq	a0,s2,42ec <sbrkfail+0xc4>
    kill(pids[i]);
    42f8:	00001097          	auipc	ra,0x1
    42fc:	4b8080e7          	jalr	1208(ra) # 57b0 <kill>
    wait(0);
    4300:	4501                	li	a0,0
    4302:	00001097          	auipc	ra,0x1
    4306:	486080e7          	jalr	1158(ra) # 5788 <wait>
    430a:	b7cd                	j	42ec <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    430c:	57fd                	li	a5,-1
    430e:	04fa0163          	beq	s4,a5,4350 <sbrkfail+0x128>
  pid = fork();
    4312:	00001097          	auipc	ra,0x1
    4316:	466080e7          	jalr	1126(ra) # 5778 <fork>
    431a:	84aa                	mv	s1,a0
  if(pid < 0){
    431c:	04054863          	bltz	a0,436c <sbrkfail+0x144>
  if(pid == 0){
    4320:	c525                	beqz	a0,4388 <sbrkfail+0x160>
  wait(&xstatus);
    4322:	fbc40513          	addi	a0,s0,-68
    4326:	00001097          	auipc	ra,0x1
    432a:	462080e7          	jalr	1122(ra) # 5788 <wait>
  if(xstatus != -1 && xstatus != 2)
    432e:	fbc42783          	lw	a5,-68(s0)
    4332:	577d                	li	a4,-1
    4334:	00e78563          	beq	a5,a4,433e <sbrkfail+0x116>
    4338:	4709                	li	a4,2
    433a:	08e79d63          	bne	a5,a4,43d4 <sbrkfail+0x1ac>
}
    433e:	70e6                	ld	ra,120(sp)
    4340:	7446                	ld	s0,112(sp)
    4342:	74a6                	ld	s1,104(sp)
    4344:	7906                	ld	s2,96(sp)
    4346:	69e6                	ld	s3,88(sp)
    4348:	6a46                	ld	s4,80(sp)
    434a:	6aa6                	ld	s5,72(sp)
    434c:	6109                	addi	sp,sp,128
    434e:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    4350:	85d6                	mv	a1,s5
    4352:	00003517          	auipc	a0,0x3
    4356:	4ce50513          	addi	a0,a0,1230 # 7820 <malloc+0x1c56>
    435a:	00001097          	auipc	ra,0x1
    435e:	7b8080e7          	jalr	1976(ra) # 5b12 <printf>
    exit(1);
    4362:	4505                	li	a0,1
    4364:	00001097          	auipc	ra,0x1
    4368:	41c080e7          	jalr	1052(ra) # 5780 <exit>
    printf("%s: fork failed\n", s);
    436c:	85d6                	mv	a1,s5
    436e:	00002517          	auipc	a0,0x2
    4372:	1d250513          	addi	a0,a0,466 # 6540 <malloc+0x976>
    4376:	00001097          	auipc	ra,0x1
    437a:	79c080e7          	jalr	1948(ra) # 5b12 <printf>
    exit(1);
    437e:	4505                	li	a0,1
    4380:	00001097          	auipc	ra,0x1
    4384:	400080e7          	jalr	1024(ra) # 5780 <exit>
    a = sbrk(0);
    4388:	4501                	li	a0,0
    438a:	00001097          	auipc	ra,0x1
    438e:	47e080e7          	jalr	1150(ra) # 5808 <sbrk>
    4392:	892a                	mv	s2,a0
    sbrk(10*BIG);
    4394:	3e800537          	lui	a0,0x3e800
    4398:	00001097          	auipc	ra,0x1
    439c:	470080e7          	jalr	1136(ra) # 5808 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    43a0:	87ca                	mv	a5,s2
    43a2:	3e800737          	lui	a4,0x3e800
    43a6:	993a                	add	s2,s2,a4
    43a8:	6705                	lui	a4,0x1
      n += *(a+i);
    43aa:	0007c683          	lbu	a3,0(a5) # 6400000 <__BSS_END__+0x63f1308>
    43ae:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    43b0:	97ba                	add	a5,a5,a4
    43b2:	ff279ce3          	bne	a5,s2,43aa <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    43b6:	8626                	mv	a2,s1
    43b8:	85d6                	mv	a1,s5
    43ba:	00003517          	auipc	a0,0x3
    43be:	48650513          	addi	a0,a0,1158 # 7840 <malloc+0x1c76>
    43c2:	00001097          	auipc	ra,0x1
    43c6:	750080e7          	jalr	1872(ra) # 5b12 <printf>
    exit(1);
    43ca:	4505                	li	a0,1
    43cc:	00001097          	auipc	ra,0x1
    43d0:	3b4080e7          	jalr	948(ra) # 5780 <exit>
    exit(1);
    43d4:	4505                	li	a0,1
    43d6:	00001097          	auipc	ra,0x1
    43da:	3aa080e7          	jalr	938(ra) # 5780 <exit>

00000000000043de <reparent>:
{
    43de:	7179                	addi	sp,sp,-48
    43e0:	f406                	sd	ra,40(sp)
    43e2:	f022                	sd	s0,32(sp)
    43e4:	ec26                	sd	s1,24(sp)
    43e6:	e84a                	sd	s2,16(sp)
    43e8:	e44e                	sd	s3,8(sp)
    43ea:	e052                	sd	s4,0(sp)
    43ec:	1800                	addi	s0,sp,48
    43ee:	89aa                	mv	s3,a0
  int master_pid = getpid();
    43f0:	00001097          	auipc	ra,0x1
    43f4:	410080e7          	jalr	1040(ra) # 5800 <getpid>
    43f8:	8a2a                	mv	s4,a0
    43fa:	0c800913          	li	s2,200
    int pid = fork();
    43fe:	00001097          	auipc	ra,0x1
    4402:	37a080e7          	jalr	890(ra) # 5778 <fork>
    4406:	84aa                	mv	s1,a0
    if(pid < 0){
    4408:	02054263          	bltz	a0,442c <reparent+0x4e>
    if(pid){
    440c:	cd21                	beqz	a0,4464 <reparent+0x86>
      if(wait(0) != pid){
    440e:	4501                	li	a0,0
    4410:	00001097          	auipc	ra,0x1
    4414:	378080e7          	jalr	888(ra) # 5788 <wait>
    4418:	02951863          	bne	a0,s1,4448 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    441c:	397d                	addiw	s2,s2,-1
    441e:	fe0910e3          	bnez	s2,43fe <reparent+0x20>
  exit(0);
    4422:	4501                	li	a0,0
    4424:	00001097          	auipc	ra,0x1
    4428:	35c080e7          	jalr	860(ra) # 5780 <exit>
      printf("%s: fork failed\n", s);
    442c:	85ce                	mv	a1,s3
    442e:	00002517          	auipc	a0,0x2
    4432:	11250513          	addi	a0,a0,274 # 6540 <malloc+0x976>
    4436:	00001097          	auipc	ra,0x1
    443a:	6dc080e7          	jalr	1756(ra) # 5b12 <printf>
      exit(1);
    443e:	4505                	li	a0,1
    4440:	00001097          	auipc	ra,0x1
    4444:	340080e7          	jalr	832(ra) # 5780 <exit>
        printf("%s: wait wrong pid\n", s);
    4448:	85ce                	mv	a1,s3
    444a:	00002517          	auipc	a0,0x2
    444e:	27e50513          	addi	a0,a0,638 # 66c8 <malloc+0xafe>
    4452:	00001097          	auipc	ra,0x1
    4456:	6c0080e7          	jalr	1728(ra) # 5b12 <printf>
        exit(1);
    445a:	4505                	li	a0,1
    445c:	00001097          	auipc	ra,0x1
    4460:	324080e7          	jalr	804(ra) # 5780 <exit>
      int pid2 = fork();
    4464:	00001097          	auipc	ra,0x1
    4468:	314080e7          	jalr	788(ra) # 5778 <fork>
      if(pid2 < 0){
    446c:	00054763          	bltz	a0,447a <reparent+0x9c>
      exit(0);
    4470:	4501                	li	a0,0
    4472:	00001097          	auipc	ra,0x1
    4476:	30e080e7          	jalr	782(ra) # 5780 <exit>
        kill(master_pid);
    447a:	8552                	mv	a0,s4
    447c:	00001097          	auipc	ra,0x1
    4480:	334080e7          	jalr	820(ra) # 57b0 <kill>
        exit(1);
    4484:	4505                	li	a0,1
    4486:	00001097          	auipc	ra,0x1
    448a:	2fa080e7          	jalr	762(ra) # 5780 <exit>

000000000000448e <mem>:
{
    448e:	7139                	addi	sp,sp,-64
    4490:	fc06                	sd	ra,56(sp)
    4492:	f822                	sd	s0,48(sp)
    4494:	f426                	sd	s1,40(sp)
    4496:	f04a                	sd	s2,32(sp)
    4498:	ec4e                	sd	s3,24(sp)
    449a:	0080                	addi	s0,sp,64
    449c:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    449e:	00001097          	auipc	ra,0x1
    44a2:	2da080e7          	jalr	730(ra) # 5778 <fork>
    m1 = 0;
    44a6:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    44a8:	6909                	lui	s2,0x2
    44aa:	71190913          	addi	s2,s2,1809 # 2711 <sbrkbasic+0xb1>
  if((pid = fork()) == 0){
    44ae:	c115                	beqz	a0,44d2 <mem+0x44>
    wait(&xstatus);
    44b0:	fcc40513          	addi	a0,s0,-52
    44b4:	00001097          	auipc	ra,0x1
    44b8:	2d4080e7          	jalr	724(ra) # 5788 <wait>
    if(xstatus == -1){
    44bc:	fcc42503          	lw	a0,-52(s0)
    44c0:	57fd                	li	a5,-1
    44c2:	06f50363          	beq	a0,a5,4528 <mem+0x9a>
    exit(xstatus);
    44c6:	00001097          	auipc	ra,0x1
    44ca:	2ba080e7          	jalr	698(ra) # 5780 <exit>
      *(char**)m2 = m1;
    44ce:	e104                	sd	s1,0(a0)
      m1 = m2;
    44d0:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    44d2:	854a                	mv	a0,s2
    44d4:	00001097          	auipc	ra,0x1
    44d8:	6f6080e7          	jalr	1782(ra) # 5bca <malloc>
    44dc:	f96d                	bnez	a0,44ce <mem+0x40>
    while(m1){
    44de:	c881                	beqz	s1,44ee <mem+0x60>
      m2 = *(char**)m1;
    44e0:	8526                	mv	a0,s1
    44e2:	6084                	ld	s1,0(s1)
      free(m1);
    44e4:	00001097          	auipc	ra,0x1
    44e8:	664080e7          	jalr	1636(ra) # 5b48 <free>
    while(m1){
    44ec:	f8f5                	bnez	s1,44e0 <mem+0x52>
    m1 = malloc(1024*20);
    44ee:	6515                	lui	a0,0x5
    44f0:	00001097          	auipc	ra,0x1
    44f4:	6da080e7          	jalr	1754(ra) # 5bca <malloc>
    if(m1 == 0){
    44f8:	c911                	beqz	a0,450c <mem+0x7e>
    free(m1);
    44fa:	00001097          	auipc	ra,0x1
    44fe:	64e080e7          	jalr	1614(ra) # 5b48 <free>
    exit(0);
    4502:	4501                	li	a0,0
    4504:	00001097          	auipc	ra,0x1
    4508:	27c080e7          	jalr	636(ra) # 5780 <exit>
      printf("couldn't allocate mem?!!\n", s);
    450c:	85ce                	mv	a1,s3
    450e:	00003517          	auipc	a0,0x3
    4512:	36250513          	addi	a0,a0,866 # 7870 <malloc+0x1ca6>
    4516:	00001097          	auipc	ra,0x1
    451a:	5fc080e7          	jalr	1532(ra) # 5b12 <printf>
      exit(1);
    451e:	4505                	li	a0,1
    4520:	00001097          	auipc	ra,0x1
    4524:	260080e7          	jalr	608(ra) # 5780 <exit>
      exit(0);
    4528:	4501                	li	a0,0
    452a:	00001097          	auipc	ra,0x1
    452e:	256080e7          	jalr	598(ra) # 5780 <exit>

0000000000004532 <sharedfd>:
{
    4532:	7159                	addi	sp,sp,-112
    4534:	f486                	sd	ra,104(sp)
    4536:	f0a2                	sd	s0,96(sp)
    4538:	eca6                	sd	s1,88(sp)
    453a:	e8ca                	sd	s2,80(sp)
    453c:	e4ce                	sd	s3,72(sp)
    453e:	e0d2                	sd	s4,64(sp)
    4540:	fc56                	sd	s5,56(sp)
    4542:	f85a                	sd	s6,48(sp)
    4544:	f45e                	sd	s7,40(sp)
    4546:	1880                	addi	s0,sp,112
    4548:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    454a:	00003517          	auipc	a0,0x3
    454e:	34650513          	addi	a0,a0,838 # 7890 <malloc+0x1cc6>
    4552:	00001097          	auipc	ra,0x1
    4556:	27e080e7          	jalr	638(ra) # 57d0 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    455a:	20200593          	li	a1,514
    455e:	00003517          	auipc	a0,0x3
    4562:	33250513          	addi	a0,a0,818 # 7890 <malloc+0x1cc6>
    4566:	00001097          	auipc	ra,0x1
    456a:	25a080e7          	jalr	602(ra) # 57c0 <open>
  if(fd < 0){
    456e:	04054a63          	bltz	a0,45c2 <sharedfd+0x90>
    4572:	892a                	mv	s2,a0
  pid = fork();
    4574:	00001097          	auipc	ra,0x1
    4578:	204080e7          	jalr	516(ra) # 5778 <fork>
    457c:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    457e:	06300593          	li	a1,99
    4582:	c119                	beqz	a0,4588 <sharedfd+0x56>
    4584:	07000593          	li	a1,112
    4588:	4629                	li	a2,10
    458a:	fa040513          	addi	a0,s0,-96
    458e:	00001097          	auipc	ra,0x1
    4592:	ff8080e7          	jalr	-8(ra) # 5586 <memset>
    4596:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    459a:	4629                	li	a2,10
    459c:	fa040593          	addi	a1,s0,-96
    45a0:	854a                	mv	a0,s2
    45a2:	00001097          	auipc	ra,0x1
    45a6:	1fe080e7          	jalr	510(ra) # 57a0 <write>
    45aa:	47a9                	li	a5,10
    45ac:	02f51963          	bne	a0,a5,45de <sharedfd+0xac>
  for(i = 0; i < N; i++){
    45b0:	34fd                	addiw	s1,s1,-1
    45b2:	f4e5                	bnez	s1,459a <sharedfd+0x68>
  if(pid == 0) {
    45b4:	04099363          	bnez	s3,45fa <sharedfd+0xc8>
    exit(0);
    45b8:	4501                	li	a0,0
    45ba:	00001097          	auipc	ra,0x1
    45be:	1c6080e7          	jalr	454(ra) # 5780 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    45c2:	85d2                	mv	a1,s4
    45c4:	00003517          	auipc	a0,0x3
    45c8:	2dc50513          	addi	a0,a0,732 # 78a0 <malloc+0x1cd6>
    45cc:	00001097          	auipc	ra,0x1
    45d0:	546080e7          	jalr	1350(ra) # 5b12 <printf>
    exit(1);
    45d4:	4505                	li	a0,1
    45d6:	00001097          	auipc	ra,0x1
    45da:	1aa080e7          	jalr	426(ra) # 5780 <exit>
      printf("%s: write sharedfd failed\n", s);
    45de:	85d2                	mv	a1,s4
    45e0:	00003517          	auipc	a0,0x3
    45e4:	2e850513          	addi	a0,a0,744 # 78c8 <malloc+0x1cfe>
    45e8:	00001097          	auipc	ra,0x1
    45ec:	52a080e7          	jalr	1322(ra) # 5b12 <printf>
      exit(1);
    45f0:	4505                	li	a0,1
    45f2:	00001097          	auipc	ra,0x1
    45f6:	18e080e7          	jalr	398(ra) # 5780 <exit>
    wait(&xstatus);
    45fa:	f9c40513          	addi	a0,s0,-100
    45fe:	00001097          	auipc	ra,0x1
    4602:	18a080e7          	jalr	394(ra) # 5788 <wait>
    if(xstatus != 0)
    4606:	f9c42983          	lw	s3,-100(s0)
    460a:	00098763          	beqz	s3,4618 <sharedfd+0xe6>
      exit(xstatus);
    460e:	854e                	mv	a0,s3
    4610:	00001097          	auipc	ra,0x1
    4614:	170080e7          	jalr	368(ra) # 5780 <exit>
  close(fd);
    4618:	854a                	mv	a0,s2
    461a:	00001097          	auipc	ra,0x1
    461e:	18e080e7          	jalr	398(ra) # 57a8 <close>
  fd = open("sharedfd", 0);
    4622:	4581                	li	a1,0
    4624:	00003517          	auipc	a0,0x3
    4628:	26c50513          	addi	a0,a0,620 # 7890 <malloc+0x1cc6>
    462c:	00001097          	auipc	ra,0x1
    4630:	194080e7          	jalr	404(ra) # 57c0 <open>
    4634:	8baa                	mv	s7,a0
  nc = np = 0;
    4636:	8ace                	mv	s5,s3
  if(fd < 0){
    4638:	02054563          	bltz	a0,4662 <sharedfd+0x130>
    463c:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    4640:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4644:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4648:	4629                	li	a2,10
    464a:	fa040593          	addi	a1,s0,-96
    464e:	855e                	mv	a0,s7
    4650:	00001097          	auipc	ra,0x1
    4654:	148080e7          	jalr	328(ra) # 5798 <read>
    4658:	02a05f63          	blez	a0,4696 <sharedfd+0x164>
    465c:	fa040793          	addi	a5,s0,-96
    4660:	a01d                	j	4686 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    4662:	85d2                	mv	a1,s4
    4664:	00003517          	auipc	a0,0x3
    4668:	28450513          	addi	a0,a0,644 # 78e8 <malloc+0x1d1e>
    466c:	00001097          	auipc	ra,0x1
    4670:	4a6080e7          	jalr	1190(ra) # 5b12 <printf>
    exit(1);
    4674:	4505                	li	a0,1
    4676:	00001097          	auipc	ra,0x1
    467a:	10a080e7          	jalr	266(ra) # 5780 <exit>
        nc++;
    467e:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    4680:	0785                	addi	a5,a5,1
    4682:	fd2783e3          	beq	a5,s2,4648 <sharedfd+0x116>
      if(buf[i] == 'c')
    4686:	0007c703          	lbu	a4,0(a5)
    468a:	fe970ae3          	beq	a4,s1,467e <sharedfd+0x14c>
      if(buf[i] == 'p')
    468e:	ff6719e3          	bne	a4,s6,4680 <sharedfd+0x14e>
        np++;
    4692:	2a85                	addiw	s5,s5,1
    4694:	b7f5                	j	4680 <sharedfd+0x14e>
  close(fd);
    4696:	855e                	mv	a0,s7
    4698:	00001097          	auipc	ra,0x1
    469c:	110080e7          	jalr	272(ra) # 57a8 <close>
  unlink("sharedfd");
    46a0:	00003517          	auipc	a0,0x3
    46a4:	1f050513          	addi	a0,a0,496 # 7890 <malloc+0x1cc6>
    46a8:	00001097          	auipc	ra,0x1
    46ac:	128080e7          	jalr	296(ra) # 57d0 <unlink>
  if(nc == N*SZ && np == N*SZ){
    46b0:	6789                	lui	a5,0x2
    46b2:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0xb0>
    46b6:	00f99763          	bne	s3,a5,46c4 <sharedfd+0x192>
    46ba:	6789                	lui	a5,0x2
    46bc:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0xb0>
    46c0:	02fa8063          	beq	s5,a5,46e0 <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    46c4:	85d2                	mv	a1,s4
    46c6:	00003517          	auipc	a0,0x3
    46ca:	24a50513          	addi	a0,a0,586 # 7910 <malloc+0x1d46>
    46ce:	00001097          	auipc	ra,0x1
    46d2:	444080e7          	jalr	1092(ra) # 5b12 <printf>
    exit(1);
    46d6:	4505                	li	a0,1
    46d8:	00001097          	auipc	ra,0x1
    46dc:	0a8080e7          	jalr	168(ra) # 5780 <exit>
    exit(0);
    46e0:	4501                	li	a0,0
    46e2:	00001097          	auipc	ra,0x1
    46e6:	09e080e7          	jalr	158(ra) # 5780 <exit>

00000000000046ea <fourfiles>:
{
    46ea:	7171                	addi	sp,sp,-176
    46ec:	f506                	sd	ra,168(sp)
    46ee:	f122                	sd	s0,160(sp)
    46f0:	ed26                	sd	s1,152(sp)
    46f2:	e94a                	sd	s2,144(sp)
    46f4:	e54e                	sd	s3,136(sp)
    46f6:	e152                	sd	s4,128(sp)
    46f8:	fcd6                	sd	s5,120(sp)
    46fa:	f8da                	sd	s6,112(sp)
    46fc:	f4de                	sd	s7,104(sp)
    46fe:	f0e2                	sd	s8,96(sp)
    4700:	ece6                	sd	s9,88(sp)
    4702:	e8ea                	sd	s10,80(sp)
    4704:	e4ee                	sd	s11,72(sp)
    4706:	1900                	addi	s0,sp,176
    4708:	f4a43c23          	sd	a0,-168(s0)
  char *names[] = { "f0", "f1", "f2", "f3" };
    470c:	00003797          	auipc	a5,0x3
    4710:	21c78793          	addi	a5,a5,540 # 7928 <malloc+0x1d5e>
    4714:	f6f43823          	sd	a5,-144(s0)
    4718:	00003797          	auipc	a5,0x3
    471c:	21878793          	addi	a5,a5,536 # 7930 <malloc+0x1d66>
    4720:	f6f43c23          	sd	a5,-136(s0)
    4724:	00003797          	auipc	a5,0x3
    4728:	21478793          	addi	a5,a5,532 # 7938 <malloc+0x1d6e>
    472c:	f8f43023          	sd	a5,-128(s0)
    4730:	00003797          	auipc	a5,0x3
    4734:	21078793          	addi	a5,a5,528 # 7940 <malloc+0x1d76>
    4738:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    473c:	f7040c13          	addi	s8,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4740:	8962                	mv	s2,s8
  for(pi = 0; pi < NCHILD; pi++){
    4742:	4481                	li	s1,0
    4744:	4a11                	li	s4,4
    fname = names[pi];
    4746:	00093983          	ld	s3,0(s2)
    unlink(fname);
    474a:	854e                	mv	a0,s3
    474c:	00001097          	auipc	ra,0x1
    4750:	084080e7          	jalr	132(ra) # 57d0 <unlink>
    pid = fork();
    4754:	00001097          	auipc	ra,0x1
    4758:	024080e7          	jalr	36(ra) # 5778 <fork>
    if(pid < 0){
    475c:	04054463          	bltz	a0,47a4 <fourfiles+0xba>
    if(pid == 0){
    4760:	c12d                	beqz	a0,47c2 <fourfiles+0xd8>
  for(pi = 0; pi < NCHILD; pi++){
    4762:	2485                	addiw	s1,s1,1
    4764:	0921                	addi	s2,s2,8
    4766:	ff4490e3          	bne	s1,s4,4746 <fourfiles+0x5c>
    476a:	4491                	li	s1,4
    wait(&xstatus);
    476c:	f6c40513          	addi	a0,s0,-148
    4770:	00001097          	auipc	ra,0x1
    4774:	018080e7          	jalr	24(ra) # 5788 <wait>
    if(xstatus != 0)
    4778:	f6c42b03          	lw	s6,-148(s0)
    477c:	0c0b1e63          	bnez	s6,4858 <fourfiles+0x16e>
  for(pi = 0; pi < NCHILD; pi++){
    4780:	34fd                	addiw	s1,s1,-1
    4782:	f4ed                	bnez	s1,476c <fourfiles+0x82>
    4784:	03000b93          	li	s7,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4788:	00007a17          	auipc	s4,0x7
    478c:	560a0a13          	addi	s4,s4,1376 # bce8 <buf>
    4790:	00007a97          	auipc	s5,0x7
    4794:	559a8a93          	addi	s5,s5,1369 # bce9 <buf+0x1>
    if(total != N*SZ){
    4798:	6d85                	lui	s11,0x1
    479a:	770d8d93          	addi	s11,s11,1904 # 1770 <pipe1+0x34>
  for(i = 0; i < NCHILD; i++){
    479e:	03400d13          	li	s10,52
    47a2:	aa1d                	j	48d8 <fourfiles+0x1ee>
      printf("fork failed\n", s);
    47a4:	f5843583          	ld	a1,-168(s0)
    47a8:	00002517          	auipc	a0,0x2
    47ac:	1b850513          	addi	a0,a0,440 # 6960 <malloc+0xd96>
    47b0:	00001097          	auipc	ra,0x1
    47b4:	362080e7          	jalr	866(ra) # 5b12 <printf>
      exit(1);
    47b8:	4505                	li	a0,1
    47ba:	00001097          	auipc	ra,0x1
    47be:	fc6080e7          	jalr	-58(ra) # 5780 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    47c2:	20200593          	li	a1,514
    47c6:	854e                	mv	a0,s3
    47c8:	00001097          	auipc	ra,0x1
    47cc:	ff8080e7          	jalr	-8(ra) # 57c0 <open>
    47d0:	892a                	mv	s2,a0
      if(fd < 0){
    47d2:	04054763          	bltz	a0,4820 <fourfiles+0x136>
      memset(buf, '0'+pi, SZ);
    47d6:	1f400613          	li	a2,500
    47da:	0304859b          	addiw	a1,s1,48
    47de:	00007517          	auipc	a0,0x7
    47e2:	50a50513          	addi	a0,a0,1290 # bce8 <buf>
    47e6:	00001097          	auipc	ra,0x1
    47ea:	da0080e7          	jalr	-608(ra) # 5586 <memset>
    47ee:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    47f0:	00007997          	auipc	s3,0x7
    47f4:	4f898993          	addi	s3,s3,1272 # bce8 <buf>
    47f8:	1f400613          	li	a2,500
    47fc:	85ce                	mv	a1,s3
    47fe:	854a                	mv	a0,s2
    4800:	00001097          	auipc	ra,0x1
    4804:	fa0080e7          	jalr	-96(ra) # 57a0 <write>
    4808:	85aa                	mv	a1,a0
    480a:	1f400793          	li	a5,500
    480e:	02f51863          	bne	a0,a5,483e <fourfiles+0x154>
      for(i = 0; i < N; i++){
    4812:	34fd                	addiw	s1,s1,-1
    4814:	f0f5                	bnez	s1,47f8 <fourfiles+0x10e>
      exit(0);
    4816:	4501                	li	a0,0
    4818:	00001097          	auipc	ra,0x1
    481c:	f68080e7          	jalr	-152(ra) # 5780 <exit>
        printf("create failed\n", s);
    4820:	f5843583          	ld	a1,-168(s0)
    4824:	00003517          	auipc	a0,0x3
    4828:	12450513          	addi	a0,a0,292 # 7948 <malloc+0x1d7e>
    482c:	00001097          	auipc	ra,0x1
    4830:	2e6080e7          	jalr	742(ra) # 5b12 <printf>
        exit(1);
    4834:	4505                	li	a0,1
    4836:	00001097          	auipc	ra,0x1
    483a:	f4a080e7          	jalr	-182(ra) # 5780 <exit>
          printf("write failed %d\n", n);
    483e:	00003517          	auipc	a0,0x3
    4842:	11a50513          	addi	a0,a0,282 # 7958 <malloc+0x1d8e>
    4846:	00001097          	auipc	ra,0x1
    484a:	2cc080e7          	jalr	716(ra) # 5b12 <printf>
          exit(1);
    484e:	4505                	li	a0,1
    4850:	00001097          	auipc	ra,0x1
    4854:	f30080e7          	jalr	-208(ra) # 5780 <exit>
      exit(xstatus);
    4858:	855a                	mv	a0,s6
    485a:	00001097          	auipc	ra,0x1
    485e:	f26080e7          	jalr	-218(ra) # 5780 <exit>
          printf("wrong char\n", s);
    4862:	f5843583          	ld	a1,-168(s0)
    4866:	00003517          	auipc	a0,0x3
    486a:	10a50513          	addi	a0,a0,266 # 7970 <malloc+0x1da6>
    486e:	00001097          	auipc	ra,0x1
    4872:	2a4080e7          	jalr	676(ra) # 5b12 <printf>
          exit(1);
    4876:	4505                	li	a0,1
    4878:	00001097          	auipc	ra,0x1
    487c:	f08080e7          	jalr	-248(ra) # 5780 <exit>
      total += n;
    4880:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4884:	660d                	lui	a2,0x3
    4886:	85d2                	mv	a1,s4
    4888:	854e                	mv	a0,s3
    488a:	00001097          	auipc	ra,0x1
    488e:	f0e080e7          	jalr	-242(ra) # 5798 <read>
    4892:	02a05363          	blez	a0,48b8 <fourfiles+0x1ce>
    4896:	00007797          	auipc	a5,0x7
    489a:	45278793          	addi	a5,a5,1106 # bce8 <buf>
    489e:	fff5069b          	addiw	a3,a0,-1
    48a2:	1682                	slli	a3,a3,0x20
    48a4:	9281                	srli	a3,a3,0x20
    48a6:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    48a8:	0007c703          	lbu	a4,0(a5)
    48ac:	fa971be3          	bne	a4,s1,4862 <fourfiles+0x178>
      for(j = 0; j < n; j++){
    48b0:	0785                	addi	a5,a5,1
    48b2:	fed79be3          	bne	a5,a3,48a8 <fourfiles+0x1be>
    48b6:	b7e9                	j	4880 <fourfiles+0x196>
    close(fd);
    48b8:	854e                	mv	a0,s3
    48ba:	00001097          	auipc	ra,0x1
    48be:	eee080e7          	jalr	-274(ra) # 57a8 <close>
    if(total != N*SZ){
    48c2:	03b91863          	bne	s2,s11,48f2 <fourfiles+0x208>
    unlink(fname);
    48c6:	8566                	mv	a0,s9
    48c8:	00001097          	auipc	ra,0x1
    48cc:	f08080e7          	jalr	-248(ra) # 57d0 <unlink>
  for(i = 0; i < NCHILD; i++){
    48d0:	0c21                	addi	s8,s8,8
    48d2:	2b85                	addiw	s7,s7,1
    48d4:	03ab8d63          	beq	s7,s10,490e <fourfiles+0x224>
    fname = names[i];
    48d8:	000c3c83          	ld	s9,0(s8)
    fd = open(fname, 0);
    48dc:	4581                	li	a1,0
    48de:	8566                	mv	a0,s9
    48e0:	00001097          	auipc	ra,0x1
    48e4:	ee0080e7          	jalr	-288(ra) # 57c0 <open>
    48e8:	89aa                	mv	s3,a0
    total = 0;
    48ea:	895a                	mv	s2,s6
        if(buf[j] != '0'+i){
    48ec:	000b849b          	sext.w	s1,s7
    while((n = read(fd, buf, sizeof(buf))) > 0){
    48f0:	bf51                	j	4884 <fourfiles+0x19a>
      printf("wrong length %d\n", total);
    48f2:	85ca                	mv	a1,s2
    48f4:	00003517          	auipc	a0,0x3
    48f8:	08c50513          	addi	a0,a0,140 # 7980 <malloc+0x1db6>
    48fc:	00001097          	auipc	ra,0x1
    4900:	216080e7          	jalr	534(ra) # 5b12 <printf>
      exit(1);
    4904:	4505                	li	a0,1
    4906:	00001097          	auipc	ra,0x1
    490a:	e7a080e7          	jalr	-390(ra) # 5780 <exit>
}
    490e:	70aa                	ld	ra,168(sp)
    4910:	740a                	ld	s0,160(sp)
    4912:	64ea                	ld	s1,152(sp)
    4914:	694a                	ld	s2,144(sp)
    4916:	69aa                	ld	s3,136(sp)
    4918:	6a0a                	ld	s4,128(sp)
    491a:	7ae6                	ld	s5,120(sp)
    491c:	7b46                	ld	s6,112(sp)
    491e:	7ba6                	ld	s7,104(sp)
    4920:	7c06                	ld	s8,96(sp)
    4922:	6ce6                	ld	s9,88(sp)
    4924:	6d46                	ld	s10,80(sp)
    4926:	6da6                	ld	s11,72(sp)
    4928:	614d                	addi	sp,sp,176
    492a:	8082                	ret

000000000000492c <concreate>:
{
    492c:	7135                	addi	sp,sp,-160
    492e:	ed06                	sd	ra,152(sp)
    4930:	e922                	sd	s0,144(sp)
    4932:	e526                	sd	s1,136(sp)
    4934:	e14a                	sd	s2,128(sp)
    4936:	fcce                	sd	s3,120(sp)
    4938:	f8d2                	sd	s4,112(sp)
    493a:	f4d6                	sd	s5,104(sp)
    493c:	f0da                	sd	s6,96(sp)
    493e:	ecde                	sd	s7,88(sp)
    4940:	1100                	addi	s0,sp,160
    4942:	89aa                	mv	s3,a0
  file[0] = 'C';
    4944:	04300793          	li	a5,67
    4948:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    494c:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4950:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4952:	4b0d                	li	s6,3
    4954:	4a85                	li	s5,1
      link("C0", file);
    4956:	00003b97          	auipc	s7,0x3
    495a:	042b8b93          	addi	s7,s7,66 # 7998 <malloc+0x1dce>
  for(i = 0; i < N; i++){
    495e:	02800a13          	li	s4,40
    4962:	acc9                	j	4c34 <concreate+0x308>
      link("C0", file);
    4964:	fa840593          	addi	a1,s0,-88
    4968:	855e                	mv	a0,s7
    496a:	00001097          	auipc	ra,0x1
    496e:	e76080e7          	jalr	-394(ra) # 57e0 <link>
    if(pid == 0) {
    4972:	a465                	j	4c1a <concreate+0x2ee>
    } else if(pid == 0 && (i % 5) == 1){
    4974:	4795                	li	a5,5
    4976:	02f9693b          	remw	s2,s2,a5
    497a:	4785                	li	a5,1
    497c:	02f90b63          	beq	s2,a5,49b2 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4980:	20200593          	li	a1,514
    4984:	fa840513          	addi	a0,s0,-88
    4988:	00001097          	auipc	ra,0x1
    498c:	e38080e7          	jalr	-456(ra) # 57c0 <open>
      if(fd < 0){
    4990:	26055c63          	bgez	a0,4c08 <concreate+0x2dc>
        printf("concreate create %s failed\n", file);
    4994:	fa840593          	addi	a1,s0,-88
    4998:	00003517          	auipc	a0,0x3
    499c:	00850513          	addi	a0,a0,8 # 79a0 <malloc+0x1dd6>
    49a0:	00001097          	auipc	ra,0x1
    49a4:	172080e7          	jalr	370(ra) # 5b12 <printf>
        exit(1);
    49a8:	4505                	li	a0,1
    49aa:	00001097          	auipc	ra,0x1
    49ae:	dd6080e7          	jalr	-554(ra) # 5780 <exit>
      link("C0", file);
    49b2:	fa840593          	addi	a1,s0,-88
    49b6:	00003517          	auipc	a0,0x3
    49ba:	fe250513          	addi	a0,a0,-30 # 7998 <malloc+0x1dce>
    49be:	00001097          	auipc	ra,0x1
    49c2:	e22080e7          	jalr	-478(ra) # 57e0 <link>
      exit(0);
    49c6:	4501                	li	a0,0
    49c8:	00001097          	auipc	ra,0x1
    49cc:	db8080e7          	jalr	-584(ra) # 5780 <exit>
        exit(1);
    49d0:	4505                	li	a0,1
    49d2:	00001097          	auipc	ra,0x1
    49d6:	dae080e7          	jalr	-594(ra) # 5780 <exit>
  memset(fa, 0, sizeof(fa));
    49da:	02800613          	li	a2,40
    49de:	4581                	li	a1,0
    49e0:	f8040513          	addi	a0,s0,-128
    49e4:	00001097          	auipc	ra,0x1
    49e8:	ba2080e7          	jalr	-1118(ra) # 5586 <memset>
  fd = open(".", 0);
    49ec:	4581                	li	a1,0
    49ee:	00002517          	auipc	a0,0x2
    49f2:	9b250513          	addi	a0,a0,-1614 # 63a0 <malloc+0x7d6>
    49f6:	00001097          	auipc	ra,0x1
    49fa:	dca080e7          	jalr	-566(ra) # 57c0 <open>
    49fe:	892a                	mv	s2,a0
  n = 0;
    4a00:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4a02:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4a06:	02700b13          	li	s6,39
      fa[i] = 1;
    4a0a:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4a0c:	4641                	li	a2,16
    4a0e:	f7040593          	addi	a1,s0,-144
    4a12:	854a                	mv	a0,s2
    4a14:	00001097          	auipc	ra,0x1
    4a18:	d84080e7          	jalr	-636(ra) # 5798 <read>
    4a1c:	08a05263          	blez	a0,4aa0 <concreate+0x174>
    if(de.inum == 0)
    4a20:	f7045783          	lhu	a5,-144(s0)
    4a24:	d7e5                	beqz	a5,4a0c <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4a26:	f7244783          	lbu	a5,-142(s0)
    4a2a:	ff4791e3          	bne	a5,s4,4a0c <concreate+0xe0>
    4a2e:	f7444783          	lbu	a5,-140(s0)
    4a32:	ffe9                	bnez	a5,4a0c <concreate+0xe0>
      i = de.name[1] - '0';
    4a34:	f7344783          	lbu	a5,-141(s0)
    4a38:	fd07879b          	addiw	a5,a5,-48
    4a3c:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4a40:	02eb6063          	bltu	s6,a4,4a60 <concreate+0x134>
      if(fa[i]){
    4a44:	fb070793          	addi	a5,a4,-80 # fb0 <bigdir+0x50>
    4a48:	97a2                	add	a5,a5,s0
    4a4a:	fd07c783          	lbu	a5,-48(a5)
    4a4e:	eb8d                	bnez	a5,4a80 <concreate+0x154>
      fa[i] = 1;
    4a50:	fb070793          	addi	a5,a4,-80
    4a54:	00878733          	add	a4,a5,s0
    4a58:	fd770823          	sb	s7,-48(a4)
      n++;
    4a5c:	2a85                	addiw	s5,s5,1
    4a5e:	b77d                	j	4a0c <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4a60:	f7240613          	addi	a2,s0,-142
    4a64:	85ce                	mv	a1,s3
    4a66:	00003517          	auipc	a0,0x3
    4a6a:	f5a50513          	addi	a0,a0,-166 # 79c0 <malloc+0x1df6>
    4a6e:	00001097          	auipc	ra,0x1
    4a72:	0a4080e7          	jalr	164(ra) # 5b12 <printf>
        exit(1);
    4a76:	4505                	li	a0,1
    4a78:	00001097          	auipc	ra,0x1
    4a7c:	d08080e7          	jalr	-760(ra) # 5780 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4a80:	f7240613          	addi	a2,s0,-142
    4a84:	85ce                	mv	a1,s3
    4a86:	00003517          	auipc	a0,0x3
    4a8a:	f5a50513          	addi	a0,a0,-166 # 79e0 <malloc+0x1e16>
    4a8e:	00001097          	auipc	ra,0x1
    4a92:	084080e7          	jalr	132(ra) # 5b12 <printf>
        exit(1);
    4a96:	4505                	li	a0,1
    4a98:	00001097          	auipc	ra,0x1
    4a9c:	ce8080e7          	jalr	-792(ra) # 5780 <exit>
  close(fd);
    4aa0:	854a                	mv	a0,s2
    4aa2:	00001097          	auipc	ra,0x1
    4aa6:	d06080e7          	jalr	-762(ra) # 57a8 <close>
  if(n != N){
    4aaa:	02800793          	li	a5,40
    4aae:	00fa9763          	bne	s5,a5,4abc <concreate+0x190>
    if(((i % 3) == 0 && pid == 0) ||
    4ab2:	4a8d                	li	s5,3
    4ab4:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    4ab6:	02800a13          	li	s4,40
    4aba:	a8c9                	j	4b8c <concreate+0x260>
    printf("%s: concreate not enough files in directory listing\n", s);
    4abc:	85ce                	mv	a1,s3
    4abe:	00003517          	auipc	a0,0x3
    4ac2:	f4a50513          	addi	a0,a0,-182 # 7a08 <malloc+0x1e3e>
    4ac6:	00001097          	auipc	ra,0x1
    4aca:	04c080e7          	jalr	76(ra) # 5b12 <printf>
    exit(1);
    4ace:	4505                	li	a0,1
    4ad0:	00001097          	auipc	ra,0x1
    4ad4:	cb0080e7          	jalr	-848(ra) # 5780 <exit>
      printf("%s: fork failed\n", s);
    4ad8:	85ce                	mv	a1,s3
    4ada:	00002517          	auipc	a0,0x2
    4ade:	a6650513          	addi	a0,a0,-1434 # 6540 <malloc+0x976>
    4ae2:	00001097          	auipc	ra,0x1
    4ae6:	030080e7          	jalr	48(ra) # 5b12 <printf>
      exit(1);
    4aea:	4505                	li	a0,1
    4aec:	00001097          	auipc	ra,0x1
    4af0:	c94080e7          	jalr	-876(ra) # 5780 <exit>
      close(open(file, 0));
    4af4:	4581                	li	a1,0
    4af6:	fa840513          	addi	a0,s0,-88
    4afa:	00001097          	auipc	ra,0x1
    4afe:	cc6080e7          	jalr	-826(ra) # 57c0 <open>
    4b02:	00001097          	auipc	ra,0x1
    4b06:	ca6080e7          	jalr	-858(ra) # 57a8 <close>
      close(open(file, 0));
    4b0a:	4581                	li	a1,0
    4b0c:	fa840513          	addi	a0,s0,-88
    4b10:	00001097          	auipc	ra,0x1
    4b14:	cb0080e7          	jalr	-848(ra) # 57c0 <open>
    4b18:	00001097          	auipc	ra,0x1
    4b1c:	c90080e7          	jalr	-880(ra) # 57a8 <close>
      close(open(file, 0));
    4b20:	4581                	li	a1,0
    4b22:	fa840513          	addi	a0,s0,-88
    4b26:	00001097          	auipc	ra,0x1
    4b2a:	c9a080e7          	jalr	-870(ra) # 57c0 <open>
    4b2e:	00001097          	auipc	ra,0x1
    4b32:	c7a080e7          	jalr	-902(ra) # 57a8 <close>
      close(open(file, 0));
    4b36:	4581                	li	a1,0
    4b38:	fa840513          	addi	a0,s0,-88
    4b3c:	00001097          	auipc	ra,0x1
    4b40:	c84080e7          	jalr	-892(ra) # 57c0 <open>
    4b44:	00001097          	auipc	ra,0x1
    4b48:	c64080e7          	jalr	-924(ra) # 57a8 <close>
      close(open(file, 0));
    4b4c:	4581                	li	a1,0
    4b4e:	fa840513          	addi	a0,s0,-88
    4b52:	00001097          	auipc	ra,0x1
    4b56:	c6e080e7          	jalr	-914(ra) # 57c0 <open>
    4b5a:	00001097          	auipc	ra,0x1
    4b5e:	c4e080e7          	jalr	-946(ra) # 57a8 <close>
      close(open(file, 0));
    4b62:	4581                	li	a1,0
    4b64:	fa840513          	addi	a0,s0,-88
    4b68:	00001097          	auipc	ra,0x1
    4b6c:	c58080e7          	jalr	-936(ra) # 57c0 <open>
    4b70:	00001097          	auipc	ra,0x1
    4b74:	c38080e7          	jalr	-968(ra) # 57a8 <close>
    if(pid == 0)
    4b78:	08090363          	beqz	s2,4bfe <concreate+0x2d2>
      wait(0);
    4b7c:	4501                	li	a0,0
    4b7e:	00001097          	auipc	ra,0x1
    4b82:	c0a080e7          	jalr	-1014(ra) # 5788 <wait>
  for(i = 0; i < N; i++){
    4b86:	2485                	addiw	s1,s1,1
    4b88:	0f448563          	beq	s1,s4,4c72 <concreate+0x346>
    file[1] = '0' + i;
    4b8c:	0304879b          	addiw	a5,s1,48
    4b90:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    4b94:	00001097          	auipc	ra,0x1
    4b98:	be4080e7          	jalr	-1052(ra) # 5778 <fork>
    4b9c:	892a                	mv	s2,a0
    if(pid < 0){
    4b9e:	f2054de3          	bltz	a0,4ad8 <concreate+0x1ac>
    if(((i % 3) == 0 && pid == 0) ||
    4ba2:	0354e73b          	remw	a4,s1,s5
    4ba6:	00a767b3          	or	a5,a4,a0
    4baa:	2781                	sext.w	a5,a5
    4bac:	d7a1                	beqz	a5,4af4 <concreate+0x1c8>
    4bae:	01671363          	bne	a4,s6,4bb4 <concreate+0x288>
       ((i % 3) == 1 && pid != 0)){
    4bb2:	f129                	bnez	a0,4af4 <concreate+0x1c8>
      unlink(file);
    4bb4:	fa840513          	addi	a0,s0,-88
    4bb8:	00001097          	auipc	ra,0x1
    4bbc:	c18080e7          	jalr	-1000(ra) # 57d0 <unlink>
      unlink(file);
    4bc0:	fa840513          	addi	a0,s0,-88
    4bc4:	00001097          	auipc	ra,0x1
    4bc8:	c0c080e7          	jalr	-1012(ra) # 57d0 <unlink>
      unlink(file);
    4bcc:	fa840513          	addi	a0,s0,-88
    4bd0:	00001097          	auipc	ra,0x1
    4bd4:	c00080e7          	jalr	-1024(ra) # 57d0 <unlink>
      unlink(file);
    4bd8:	fa840513          	addi	a0,s0,-88
    4bdc:	00001097          	auipc	ra,0x1
    4be0:	bf4080e7          	jalr	-1036(ra) # 57d0 <unlink>
      unlink(file);
    4be4:	fa840513          	addi	a0,s0,-88
    4be8:	00001097          	auipc	ra,0x1
    4bec:	be8080e7          	jalr	-1048(ra) # 57d0 <unlink>
      unlink(file);
    4bf0:	fa840513          	addi	a0,s0,-88
    4bf4:	00001097          	auipc	ra,0x1
    4bf8:	bdc080e7          	jalr	-1060(ra) # 57d0 <unlink>
    4bfc:	bfb5                	j	4b78 <concreate+0x24c>
      exit(0);
    4bfe:	4501                	li	a0,0
    4c00:	00001097          	auipc	ra,0x1
    4c04:	b80080e7          	jalr	-1152(ra) # 5780 <exit>
      close(fd);
    4c08:	00001097          	auipc	ra,0x1
    4c0c:	ba0080e7          	jalr	-1120(ra) # 57a8 <close>
    if(pid == 0) {
    4c10:	bb5d                	j	49c6 <concreate+0x9a>
      close(fd);
    4c12:	00001097          	auipc	ra,0x1
    4c16:	b96080e7          	jalr	-1130(ra) # 57a8 <close>
      wait(&xstatus);
    4c1a:	f6c40513          	addi	a0,s0,-148
    4c1e:	00001097          	auipc	ra,0x1
    4c22:	b6a080e7          	jalr	-1174(ra) # 5788 <wait>
      if(xstatus != 0)
    4c26:	f6c42483          	lw	s1,-148(s0)
    4c2a:	da0493e3          	bnez	s1,49d0 <concreate+0xa4>
  for(i = 0; i < N; i++){
    4c2e:	2905                	addiw	s2,s2,1
    4c30:	db4905e3          	beq	s2,s4,49da <concreate+0xae>
    file[1] = '0' + i;
    4c34:	0309079b          	addiw	a5,s2,48
    4c38:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    4c3c:	fa840513          	addi	a0,s0,-88
    4c40:	00001097          	auipc	ra,0x1
    4c44:	b90080e7          	jalr	-1136(ra) # 57d0 <unlink>
    pid = fork();
    4c48:	00001097          	auipc	ra,0x1
    4c4c:	b30080e7          	jalr	-1232(ra) # 5778 <fork>
    if(pid && (i % 3) == 1){
    4c50:	d20502e3          	beqz	a0,4974 <concreate+0x48>
    4c54:	036967bb          	remw	a5,s2,s6
    4c58:	d15786e3          	beq	a5,s5,4964 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    4c5c:	20200593          	li	a1,514
    4c60:	fa840513          	addi	a0,s0,-88
    4c64:	00001097          	auipc	ra,0x1
    4c68:	b5c080e7          	jalr	-1188(ra) # 57c0 <open>
      if(fd < 0){
    4c6c:	fa0553e3          	bgez	a0,4c12 <concreate+0x2e6>
    4c70:	b315                	j	4994 <concreate+0x68>
}
    4c72:	60ea                	ld	ra,152(sp)
    4c74:	644a                	ld	s0,144(sp)
    4c76:	64aa                	ld	s1,136(sp)
    4c78:	690a                	ld	s2,128(sp)
    4c7a:	79e6                	ld	s3,120(sp)
    4c7c:	7a46                	ld	s4,112(sp)
    4c7e:	7aa6                	ld	s5,104(sp)
    4c80:	7b06                	ld	s6,96(sp)
    4c82:	6be6                	ld	s7,88(sp)
    4c84:	610d                	addi	sp,sp,160
    4c86:	8082                	ret

0000000000004c88 <bigfile>:
{
    4c88:	7139                	addi	sp,sp,-64
    4c8a:	fc06                	sd	ra,56(sp)
    4c8c:	f822                	sd	s0,48(sp)
    4c8e:	f426                	sd	s1,40(sp)
    4c90:	f04a                	sd	s2,32(sp)
    4c92:	ec4e                	sd	s3,24(sp)
    4c94:	e852                	sd	s4,16(sp)
    4c96:	e456                	sd	s5,8(sp)
    4c98:	0080                	addi	s0,sp,64
    4c9a:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    4c9c:	00003517          	auipc	a0,0x3
    4ca0:	da450513          	addi	a0,a0,-604 # 7a40 <malloc+0x1e76>
    4ca4:	00001097          	auipc	ra,0x1
    4ca8:	b2c080e7          	jalr	-1236(ra) # 57d0 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    4cac:	20200593          	li	a1,514
    4cb0:	00003517          	auipc	a0,0x3
    4cb4:	d9050513          	addi	a0,a0,-624 # 7a40 <malloc+0x1e76>
    4cb8:	00001097          	auipc	ra,0x1
    4cbc:	b08080e7          	jalr	-1272(ra) # 57c0 <open>
    4cc0:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    4cc2:	4481                	li	s1,0
    memset(buf, i, SZ);
    4cc4:	00007917          	auipc	s2,0x7
    4cc8:	02490913          	addi	s2,s2,36 # bce8 <buf>
  for(i = 0; i < N; i++){
    4ccc:	4a51                	li	s4,20
  if(fd < 0){
    4cce:	0a054063          	bltz	a0,4d6e <bigfile+0xe6>
    memset(buf, i, SZ);
    4cd2:	25800613          	li	a2,600
    4cd6:	85a6                	mv	a1,s1
    4cd8:	854a                	mv	a0,s2
    4cda:	00001097          	auipc	ra,0x1
    4cde:	8ac080e7          	jalr	-1876(ra) # 5586 <memset>
    if(write(fd, buf, SZ) != SZ){
    4ce2:	25800613          	li	a2,600
    4ce6:	85ca                	mv	a1,s2
    4ce8:	854e                	mv	a0,s3
    4cea:	00001097          	auipc	ra,0x1
    4cee:	ab6080e7          	jalr	-1354(ra) # 57a0 <write>
    4cf2:	25800793          	li	a5,600
    4cf6:	08f51a63          	bne	a0,a5,4d8a <bigfile+0x102>
  for(i = 0; i < N; i++){
    4cfa:	2485                	addiw	s1,s1,1
    4cfc:	fd449be3          	bne	s1,s4,4cd2 <bigfile+0x4a>
  close(fd);
    4d00:	854e                	mv	a0,s3
    4d02:	00001097          	auipc	ra,0x1
    4d06:	aa6080e7          	jalr	-1370(ra) # 57a8 <close>
  fd = open("bigfile.dat", 0);
    4d0a:	4581                	li	a1,0
    4d0c:	00003517          	auipc	a0,0x3
    4d10:	d3450513          	addi	a0,a0,-716 # 7a40 <malloc+0x1e76>
    4d14:	00001097          	auipc	ra,0x1
    4d18:	aac080e7          	jalr	-1364(ra) # 57c0 <open>
    4d1c:	8a2a                	mv	s4,a0
  total = 0;
    4d1e:	4981                	li	s3,0
  for(i = 0; ; i++){
    4d20:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    4d22:	00007917          	auipc	s2,0x7
    4d26:	fc690913          	addi	s2,s2,-58 # bce8 <buf>
  if(fd < 0){
    4d2a:	06054e63          	bltz	a0,4da6 <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    4d2e:	12c00613          	li	a2,300
    4d32:	85ca                	mv	a1,s2
    4d34:	8552                	mv	a0,s4
    4d36:	00001097          	auipc	ra,0x1
    4d3a:	a62080e7          	jalr	-1438(ra) # 5798 <read>
    if(cc < 0){
    4d3e:	08054263          	bltz	a0,4dc2 <bigfile+0x13a>
    if(cc == 0)
    4d42:	c971                	beqz	a0,4e16 <bigfile+0x18e>
    if(cc != SZ/2){
    4d44:	12c00793          	li	a5,300
    4d48:	08f51b63          	bne	a0,a5,4dde <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4d4c:	01f4d79b          	srliw	a5,s1,0x1f
    4d50:	9fa5                	addw	a5,a5,s1
    4d52:	4017d79b          	sraiw	a5,a5,0x1
    4d56:	00094703          	lbu	a4,0(s2)
    4d5a:	0af71063          	bne	a4,a5,4dfa <bigfile+0x172>
    4d5e:	12b94703          	lbu	a4,299(s2)
    4d62:	08f71c63          	bne	a4,a5,4dfa <bigfile+0x172>
    total += cc;
    4d66:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    4d6a:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    4d6c:	b7c9                	j	4d2e <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    4d6e:	85d6                	mv	a1,s5
    4d70:	00003517          	auipc	a0,0x3
    4d74:	ce050513          	addi	a0,a0,-800 # 7a50 <malloc+0x1e86>
    4d78:	00001097          	auipc	ra,0x1
    4d7c:	d9a080e7          	jalr	-614(ra) # 5b12 <printf>
    exit(1);
    4d80:	4505                	li	a0,1
    4d82:	00001097          	auipc	ra,0x1
    4d86:	9fe080e7          	jalr	-1538(ra) # 5780 <exit>
      printf("%s: write bigfile failed\n", s);
    4d8a:	85d6                	mv	a1,s5
    4d8c:	00003517          	auipc	a0,0x3
    4d90:	ce450513          	addi	a0,a0,-796 # 7a70 <malloc+0x1ea6>
    4d94:	00001097          	auipc	ra,0x1
    4d98:	d7e080e7          	jalr	-642(ra) # 5b12 <printf>
      exit(1);
    4d9c:	4505                	li	a0,1
    4d9e:	00001097          	auipc	ra,0x1
    4da2:	9e2080e7          	jalr	-1566(ra) # 5780 <exit>
    printf("%s: cannot open bigfile\n", s);
    4da6:	85d6                	mv	a1,s5
    4da8:	00003517          	auipc	a0,0x3
    4dac:	ce850513          	addi	a0,a0,-792 # 7a90 <malloc+0x1ec6>
    4db0:	00001097          	auipc	ra,0x1
    4db4:	d62080e7          	jalr	-670(ra) # 5b12 <printf>
    exit(1);
    4db8:	4505                	li	a0,1
    4dba:	00001097          	auipc	ra,0x1
    4dbe:	9c6080e7          	jalr	-1594(ra) # 5780 <exit>
      printf("%s: read bigfile failed\n", s);
    4dc2:	85d6                	mv	a1,s5
    4dc4:	00003517          	auipc	a0,0x3
    4dc8:	cec50513          	addi	a0,a0,-788 # 7ab0 <malloc+0x1ee6>
    4dcc:	00001097          	auipc	ra,0x1
    4dd0:	d46080e7          	jalr	-698(ra) # 5b12 <printf>
      exit(1);
    4dd4:	4505                	li	a0,1
    4dd6:	00001097          	auipc	ra,0x1
    4dda:	9aa080e7          	jalr	-1622(ra) # 5780 <exit>
      printf("%s: short read bigfile\n", s);
    4dde:	85d6                	mv	a1,s5
    4de0:	00003517          	auipc	a0,0x3
    4de4:	cf050513          	addi	a0,a0,-784 # 7ad0 <malloc+0x1f06>
    4de8:	00001097          	auipc	ra,0x1
    4dec:	d2a080e7          	jalr	-726(ra) # 5b12 <printf>
      exit(1);
    4df0:	4505                	li	a0,1
    4df2:	00001097          	auipc	ra,0x1
    4df6:	98e080e7          	jalr	-1650(ra) # 5780 <exit>
      printf("%s: read bigfile wrong data\n", s);
    4dfa:	85d6                	mv	a1,s5
    4dfc:	00003517          	auipc	a0,0x3
    4e00:	cec50513          	addi	a0,a0,-788 # 7ae8 <malloc+0x1f1e>
    4e04:	00001097          	auipc	ra,0x1
    4e08:	d0e080e7          	jalr	-754(ra) # 5b12 <printf>
      exit(1);
    4e0c:	4505                	li	a0,1
    4e0e:	00001097          	auipc	ra,0x1
    4e12:	972080e7          	jalr	-1678(ra) # 5780 <exit>
  close(fd);
    4e16:	8552                	mv	a0,s4
    4e18:	00001097          	auipc	ra,0x1
    4e1c:	990080e7          	jalr	-1648(ra) # 57a8 <close>
  if(total != N*SZ){
    4e20:	678d                	lui	a5,0x3
    4e22:	ee078793          	addi	a5,a5,-288 # 2ee0 <fourteen+0x110>
    4e26:	02f99363          	bne	s3,a5,4e4c <bigfile+0x1c4>
  unlink("bigfile.dat");
    4e2a:	00003517          	auipc	a0,0x3
    4e2e:	c1650513          	addi	a0,a0,-1002 # 7a40 <malloc+0x1e76>
    4e32:	00001097          	auipc	ra,0x1
    4e36:	99e080e7          	jalr	-1634(ra) # 57d0 <unlink>
}
    4e3a:	70e2                	ld	ra,56(sp)
    4e3c:	7442                	ld	s0,48(sp)
    4e3e:	74a2                	ld	s1,40(sp)
    4e40:	7902                	ld	s2,32(sp)
    4e42:	69e2                	ld	s3,24(sp)
    4e44:	6a42                	ld	s4,16(sp)
    4e46:	6aa2                	ld	s5,8(sp)
    4e48:	6121                	addi	sp,sp,64
    4e4a:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4e4c:	85d6                	mv	a1,s5
    4e4e:	00003517          	auipc	a0,0x3
    4e52:	cba50513          	addi	a0,a0,-838 # 7b08 <malloc+0x1f3e>
    4e56:	00001097          	auipc	ra,0x1
    4e5a:	cbc080e7          	jalr	-836(ra) # 5b12 <printf>
    exit(1);
    4e5e:	4505                	li	a0,1
    4e60:	00001097          	auipc	ra,0x1
    4e64:	920080e7          	jalr	-1760(ra) # 5780 <exit>

0000000000004e68 <fsfull>:
{
    4e68:	7171                	addi	sp,sp,-176
    4e6a:	f506                	sd	ra,168(sp)
    4e6c:	f122                	sd	s0,160(sp)
    4e6e:	ed26                	sd	s1,152(sp)
    4e70:	e94a                	sd	s2,144(sp)
    4e72:	e54e                	sd	s3,136(sp)
    4e74:	e152                	sd	s4,128(sp)
    4e76:	fcd6                	sd	s5,120(sp)
    4e78:	f8da                	sd	s6,112(sp)
    4e7a:	f4de                	sd	s7,104(sp)
    4e7c:	f0e2                	sd	s8,96(sp)
    4e7e:	ece6                	sd	s9,88(sp)
    4e80:	e8ea                	sd	s10,80(sp)
    4e82:	e4ee                	sd	s11,72(sp)
    4e84:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4e86:	00003517          	auipc	a0,0x3
    4e8a:	ca250513          	addi	a0,a0,-862 # 7b28 <malloc+0x1f5e>
    4e8e:	00001097          	auipc	ra,0x1
    4e92:	c84080e7          	jalr	-892(ra) # 5b12 <printf>
  for(nfiles = 0; ; nfiles++){
    4e96:	4481                	li	s1,0
    name[0] = 'f';
    4e98:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4e9c:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4ea0:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4ea4:	4b29                	li	s6,10
    printf("writing %s\n", name);
    4ea6:	00003c97          	auipc	s9,0x3
    4eaa:	c92c8c93          	addi	s9,s9,-878 # 7b38 <malloc+0x1f6e>
    int total = 0;
    4eae:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    4eb0:	00007a17          	auipc	s4,0x7
    4eb4:	e38a0a13          	addi	s4,s4,-456 # bce8 <buf>
    name[0] = 'f';
    4eb8:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4ebc:	0384c7bb          	divw	a5,s1,s8
    4ec0:	0307879b          	addiw	a5,a5,48
    4ec4:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4ec8:	0384e7bb          	remw	a5,s1,s8
    4ecc:	0377c7bb          	divw	a5,a5,s7
    4ed0:	0307879b          	addiw	a5,a5,48
    4ed4:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4ed8:	0374e7bb          	remw	a5,s1,s7
    4edc:	0367c7bb          	divw	a5,a5,s6
    4ee0:	0307879b          	addiw	a5,a5,48
    4ee4:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4ee8:	0364e7bb          	remw	a5,s1,s6
    4eec:	0307879b          	addiw	a5,a5,48
    4ef0:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4ef4:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    4ef8:	f5040593          	addi	a1,s0,-176
    4efc:	8566                	mv	a0,s9
    4efe:	00001097          	auipc	ra,0x1
    4f02:	c14080e7          	jalr	-1004(ra) # 5b12 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4f06:	20200593          	li	a1,514
    4f0a:	f5040513          	addi	a0,s0,-176
    4f0e:	00001097          	auipc	ra,0x1
    4f12:	8b2080e7          	jalr	-1870(ra) # 57c0 <open>
    4f16:	892a                	mv	s2,a0
    if(fd < 0){
    4f18:	0a055663          	bgez	a0,4fc4 <fsfull+0x15c>
      printf("open %s failed\n", name);
    4f1c:	f5040593          	addi	a1,s0,-176
    4f20:	00003517          	auipc	a0,0x3
    4f24:	c2850513          	addi	a0,a0,-984 # 7b48 <malloc+0x1f7e>
    4f28:	00001097          	auipc	ra,0x1
    4f2c:	bea080e7          	jalr	-1046(ra) # 5b12 <printf>
  while(nfiles >= 0){
    4f30:	0604c363          	bltz	s1,4f96 <fsfull+0x12e>
    name[0] = 'f';
    4f34:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4f38:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4f3c:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    4f40:	4929                	li	s2,10
  while(nfiles >= 0){
    4f42:	5afd                	li	s5,-1
    name[0] = 'f';
    4f44:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4f48:	0344c7bb          	divw	a5,s1,s4
    4f4c:	0307879b          	addiw	a5,a5,48
    4f50:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4f54:	0344e7bb          	remw	a5,s1,s4
    4f58:	0337c7bb          	divw	a5,a5,s3
    4f5c:	0307879b          	addiw	a5,a5,48
    4f60:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4f64:	0334e7bb          	remw	a5,s1,s3
    4f68:	0327c7bb          	divw	a5,a5,s2
    4f6c:	0307879b          	addiw	a5,a5,48
    4f70:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4f74:	0324e7bb          	remw	a5,s1,s2
    4f78:	0307879b          	addiw	a5,a5,48
    4f7c:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4f80:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    4f84:	f5040513          	addi	a0,s0,-176
    4f88:	00001097          	auipc	ra,0x1
    4f8c:	848080e7          	jalr	-1976(ra) # 57d0 <unlink>
    nfiles--;
    4f90:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    4f92:	fb5499e3          	bne	s1,s5,4f44 <fsfull+0xdc>
  printf("fsfull test finished\n");
    4f96:	00003517          	auipc	a0,0x3
    4f9a:	bd250513          	addi	a0,a0,-1070 # 7b68 <malloc+0x1f9e>
    4f9e:	00001097          	auipc	ra,0x1
    4fa2:	b74080e7          	jalr	-1164(ra) # 5b12 <printf>
}
    4fa6:	70aa                	ld	ra,168(sp)
    4fa8:	740a                	ld	s0,160(sp)
    4faa:	64ea                	ld	s1,152(sp)
    4fac:	694a                	ld	s2,144(sp)
    4fae:	69aa                	ld	s3,136(sp)
    4fb0:	6a0a                	ld	s4,128(sp)
    4fb2:	7ae6                	ld	s5,120(sp)
    4fb4:	7b46                	ld	s6,112(sp)
    4fb6:	7ba6                	ld	s7,104(sp)
    4fb8:	7c06                	ld	s8,96(sp)
    4fba:	6ce6                	ld	s9,88(sp)
    4fbc:	6d46                	ld	s10,80(sp)
    4fbe:	6da6                	ld	s11,72(sp)
    4fc0:	614d                	addi	sp,sp,176
    4fc2:	8082                	ret
    int total = 0;
    4fc4:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    4fc6:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    4fca:	40000613          	li	a2,1024
    4fce:	85d2                	mv	a1,s4
    4fd0:	854a                	mv	a0,s2
    4fd2:	00000097          	auipc	ra,0x0
    4fd6:	7ce080e7          	jalr	1998(ra) # 57a0 <write>
      if(cc < BSIZE)
    4fda:	00aad563          	bge	s5,a0,4fe4 <fsfull+0x17c>
      total += cc;
    4fde:	00a989bb          	addw	s3,s3,a0
    while(1){
    4fe2:	b7e5                	j	4fca <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    4fe4:	85ce                	mv	a1,s3
    4fe6:	00003517          	auipc	a0,0x3
    4fea:	b7250513          	addi	a0,a0,-1166 # 7b58 <malloc+0x1f8e>
    4fee:	00001097          	auipc	ra,0x1
    4ff2:	b24080e7          	jalr	-1244(ra) # 5b12 <printf>
    close(fd);
    4ff6:	854a                	mv	a0,s2
    4ff8:	00000097          	auipc	ra,0x0
    4ffc:	7b0080e7          	jalr	1968(ra) # 57a8 <close>
    if(total == 0)
    5000:	f20988e3          	beqz	s3,4f30 <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    5004:	2485                	addiw	s1,s1,1
    5006:	bd4d                	j	4eb8 <fsfull+0x50>

0000000000005008 <badwrite>:
{
    5008:	7179                	addi	sp,sp,-48
    500a:	f406                	sd	ra,40(sp)
    500c:	f022                	sd	s0,32(sp)
    500e:	ec26                	sd	s1,24(sp)
    5010:	e84a                	sd	s2,16(sp)
    5012:	e44e                	sd	s3,8(sp)
    5014:	e052                	sd	s4,0(sp)
    5016:	1800                	addi	s0,sp,48
  unlink("junk");
    5018:	00003517          	auipc	a0,0x3
    501c:	b6850513          	addi	a0,a0,-1176 # 7b80 <malloc+0x1fb6>
    5020:	00000097          	auipc	ra,0x0
    5024:	7b0080e7          	jalr	1968(ra) # 57d0 <unlink>
    5028:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    502c:	00003997          	auipc	s3,0x3
    5030:	b5498993          	addi	s3,s3,-1196 # 7b80 <malloc+0x1fb6>
    write(fd, (char*)0xffffffffffL, 1);
    5034:	5a7d                	li	s4,-1
    5036:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    503a:	20100593          	li	a1,513
    503e:	854e                	mv	a0,s3
    5040:	00000097          	auipc	ra,0x0
    5044:	780080e7          	jalr	1920(ra) # 57c0 <open>
    5048:	84aa                	mv	s1,a0
    if(fd < 0){
    504a:	06054b63          	bltz	a0,50c0 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    504e:	4605                	li	a2,1
    5050:	85d2                	mv	a1,s4
    5052:	00000097          	auipc	ra,0x0
    5056:	74e080e7          	jalr	1870(ra) # 57a0 <write>
    close(fd);
    505a:	8526                	mv	a0,s1
    505c:	00000097          	auipc	ra,0x0
    5060:	74c080e7          	jalr	1868(ra) # 57a8 <close>
    unlink("junk");
    5064:	854e                	mv	a0,s3
    5066:	00000097          	auipc	ra,0x0
    506a:	76a080e7          	jalr	1898(ra) # 57d0 <unlink>
  for(int i = 0; i < assumed_free; i++){
    506e:	397d                	addiw	s2,s2,-1
    5070:	fc0915e3          	bnez	s2,503a <badwrite+0x32>
  int fd = open("junk", O_CREATE|O_WRONLY);
    5074:	20100593          	li	a1,513
    5078:	00003517          	auipc	a0,0x3
    507c:	b0850513          	addi	a0,a0,-1272 # 7b80 <malloc+0x1fb6>
    5080:	00000097          	auipc	ra,0x0
    5084:	740080e7          	jalr	1856(ra) # 57c0 <open>
    5088:	84aa                	mv	s1,a0
  if(fd < 0){
    508a:	04054863          	bltz	a0,50da <badwrite+0xd2>
  if(write(fd, "x", 1) != 1){
    508e:	4605                	li	a2,1
    5090:	00001597          	auipc	a1,0x1
    5094:	cc858593          	addi	a1,a1,-824 # 5d58 <malloc+0x18e>
    5098:	00000097          	auipc	ra,0x0
    509c:	708080e7          	jalr	1800(ra) # 57a0 <write>
    50a0:	4785                	li	a5,1
    50a2:	04f50963          	beq	a0,a5,50f4 <badwrite+0xec>
    printf("write failed\n");
    50a6:	00003517          	auipc	a0,0x3
    50aa:	afa50513          	addi	a0,a0,-1286 # 7ba0 <malloc+0x1fd6>
    50ae:	00001097          	auipc	ra,0x1
    50b2:	a64080e7          	jalr	-1436(ra) # 5b12 <printf>
    exit(1);
    50b6:	4505                	li	a0,1
    50b8:	00000097          	auipc	ra,0x0
    50bc:	6c8080e7          	jalr	1736(ra) # 5780 <exit>
      printf("open junk failed\n");
    50c0:	00003517          	auipc	a0,0x3
    50c4:	ac850513          	addi	a0,a0,-1336 # 7b88 <malloc+0x1fbe>
    50c8:	00001097          	auipc	ra,0x1
    50cc:	a4a080e7          	jalr	-1462(ra) # 5b12 <printf>
      exit(1);
    50d0:	4505                	li	a0,1
    50d2:	00000097          	auipc	ra,0x0
    50d6:	6ae080e7          	jalr	1710(ra) # 5780 <exit>
    printf("open junk failed\n");
    50da:	00003517          	auipc	a0,0x3
    50de:	aae50513          	addi	a0,a0,-1362 # 7b88 <malloc+0x1fbe>
    50e2:	00001097          	auipc	ra,0x1
    50e6:	a30080e7          	jalr	-1488(ra) # 5b12 <printf>
    exit(1);
    50ea:	4505                	li	a0,1
    50ec:	00000097          	auipc	ra,0x0
    50f0:	694080e7          	jalr	1684(ra) # 5780 <exit>
  close(fd);
    50f4:	8526                	mv	a0,s1
    50f6:	00000097          	auipc	ra,0x0
    50fa:	6b2080e7          	jalr	1714(ra) # 57a8 <close>
  unlink("junk");
    50fe:	00003517          	auipc	a0,0x3
    5102:	a8250513          	addi	a0,a0,-1406 # 7b80 <malloc+0x1fb6>
    5106:	00000097          	auipc	ra,0x0
    510a:	6ca080e7          	jalr	1738(ra) # 57d0 <unlink>
  exit(0);
    510e:	4501                	li	a0,0
    5110:	00000097          	auipc	ra,0x0
    5114:	670080e7          	jalr	1648(ra) # 5780 <exit>

0000000000005118 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    5118:	7139                	addi	sp,sp,-64
    511a:	fc06                	sd	ra,56(sp)
    511c:	f822                	sd	s0,48(sp)
    511e:	f426                	sd	s1,40(sp)
    5120:	f04a                	sd	s2,32(sp)
    5122:	ec4e                	sd	s3,24(sp)
    5124:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    5126:	fc840513          	addi	a0,s0,-56
    512a:	00000097          	auipc	ra,0x0
    512e:	666080e7          	jalr	1638(ra) # 5790 <pipe>
    5132:	06054763          	bltz	a0,51a0 <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    5136:	00000097          	auipc	ra,0x0
    513a:	642080e7          	jalr	1602(ra) # 5778 <fork>

  if(pid < 0){
    513e:	06054e63          	bltz	a0,51ba <countfree+0xa2>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    5142:	ed51                	bnez	a0,51de <countfree+0xc6>
    close(fds[0]);
    5144:	fc842503          	lw	a0,-56(s0)
    5148:	00000097          	auipc	ra,0x0
    514c:	660080e7          	jalr	1632(ra) # 57a8 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    5150:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    5152:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    5154:	00001997          	auipc	s3,0x1
    5158:	c0498993          	addi	s3,s3,-1020 # 5d58 <malloc+0x18e>
      uint64 a = (uint64) sbrk(4096);
    515c:	6505                	lui	a0,0x1
    515e:	00000097          	auipc	ra,0x0
    5162:	6aa080e7          	jalr	1706(ra) # 5808 <sbrk>
      if(a == 0xffffffffffffffff){
    5166:	07250763          	beq	a0,s2,51d4 <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    516a:	6785                	lui	a5,0x1
    516c:	97aa                	add	a5,a5,a0
    516e:	fe978fa3          	sb	s1,-1(a5) # fff <bigdir+0x9f>
      if(write(fds[1], "x", 1) != 1){
    5172:	8626                	mv	a2,s1
    5174:	85ce                	mv	a1,s3
    5176:	fcc42503          	lw	a0,-52(s0)
    517a:	00000097          	auipc	ra,0x0
    517e:	626080e7          	jalr	1574(ra) # 57a0 <write>
    5182:	fc950de3          	beq	a0,s1,515c <countfree+0x44>
        printf("write() failed in countfree()\n");
    5186:	00003517          	auipc	a0,0x3
    518a:	a6a50513          	addi	a0,a0,-1430 # 7bf0 <malloc+0x2026>
    518e:	00001097          	auipc	ra,0x1
    5192:	984080e7          	jalr	-1660(ra) # 5b12 <printf>
        exit(1);
    5196:	4505                	li	a0,1
    5198:	00000097          	auipc	ra,0x0
    519c:	5e8080e7          	jalr	1512(ra) # 5780 <exit>
    printf("pipe() failed in countfree()\n");
    51a0:	00003517          	auipc	a0,0x3
    51a4:	a1050513          	addi	a0,a0,-1520 # 7bb0 <malloc+0x1fe6>
    51a8:	00001097          	auipc	ra,0x1
    51ac:	96a080e7          	jalr	-1686(ra) # 5b12 <printf>
    exit(1);
    51b0:	4505                	li	a0,1
    51b2:	00000097          	auipc	ra,0x0
    51b6:	5ce080e7          	jalr	1486(ra) # 5780 <exit>
    printf("fork failed in countfree()\n");
    51ba:	00003517          	auipc	a0,0x3
    51be:	a1650513          	addi	a0,a0,-1514 # 7bd0 <malloc+0x2006>
    51c2:	00001097          	auipc	ra,0x1
    51c6:	950080e7          	jalr	-1712(ra) # 5b12 <printf>
    exit(1);
    51ca:	4505                	li	a0,1
    51cc:	00000097          	auipc	ra,0x0
    51d0:	5b4080e7          	jalr	1460(ra) # 5780 <exit>
      }
    }

    exit(0);
    51d4:	4501                	li	a0,0
    51d6:	00000097          	auipc	ra,0x0
    51da:	5aa080e7          	jalr	1450(ra) # 5780 <exit>
  }

  close(fds[1]);
    51de:	fcc42503          	lw	a0,-52(s0)
    51e2:	00000097          	auipc	ra,0x0
    51e6:	5c6080e7          	jalr	1478(ra) # 57a8 <close>

  int n = 0;
    51ea:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    51ec:	4605                	li	a2,1
    51ee:	fc740593          	addi	a1,s0,-57
    51f2:	fc842503          	lw	a0,-56(s0)
    51f6:	00000097          	auipc	ra,0x0
    51fa:	5a2080e7          	jalr	1442(ra) # 5798 <read>
    if(cc < 0){
    51fe:	00054563          	bltz	a0,5208 <countfree+0xf0>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    5202:	c105                	beqz	a0,5222 <countfree+0x10a>
      break;
    n += 1;
    5204:	2485                	addiw	s1,s1,1
  while(1){
    5206:	b7dd                	j	51ec <countfree+0xd4>
      printf("read() failed in countfree()\n");
    5208:	00003517          	auipc	a0,0x3
    520c:	a0850513          	addi	a0,a0,-1528 # 7c10 <malloc+0x2046>
    5210:	00001097          	auipc	ra,0x1
    5214:	902080e7          	jalr	-1790(ra) # 5b12 <printf>
      exit(1);
    5218:	4505                	li	a0,1
    521a:	00000097          	auipc	ra,0x0
    521e:	566080e7          	jalr	1382(ra) # 5780 <exit>
  }

  close(fds[0]);
    5222:	fc842503          	lw	a0,-56(s0)
    5226:	00000097          	auipc	ra,0x0
    522a:	582080e7          	jalr	1410(ra) # 57a8 <close>
  wait((int*)0);
    522e:	4501                	li	a0,0
    5230:	00000097          	auipc	ra,0x0
    5234:	558080e7          	jalr	1368(ra) # 5788 <wait>
  
  return n;
}
    5238:	8526                	mv	a0,s1
    523a:	70e2                	ld	ra,56(sp)
    523c:	7442                	ld	s0,48(sp)
    523e:	74a2                	ld	s1,40(sp)
    5240:	7902                	ld	s2,32(sp)
    5242:	69e2                	ld	s3,24(sp)
    5244:	6121                	addi	sp,sp,64
    5246:	8082                	ret

0000000000005248 <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    5248:	7179                	addi	sp,sp,-48
    524a:	f406                	sd	ra,40(sp)
    524c:	f022                	sd	s0,32(sp)
    524e:	ec26                	sd	s1,24(sp)
    5250:	e84a                	sd	s2,16(sp)
    5252:	1800                	addi	s0,sp,48
    5254:	84aa                	mv	s1,a0
    5256:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    5258:	00003517          	auipc	a0,0x3
    525c:	9d850513          	addi	a0,a0,-1576 # 7c30 <malloc+0x2066>
    5260:	00001097          	auipc	ra,0x1
    5264:	8b2080e7          	jalr	-1870(ra) # 5b12 <printf>
  if((pid = fork()) < 0) {
    5268:	00000097          	auipc	ra,0x0
    526c:	510080e7          	jalr	1296(ra) # 5778 <fork>
    5270:	02054e63          	bltz	a0,52ac <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    5274:	c929                	beqz	a0,52c6 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    5276:	fdc40513          	addi	a0,s0,-36
    527a:	00000097          	auipc	ra,0x0
    527e:	50e080e7          	jalr	1294(ra) # 5788 <wait>
    if(xstatus != 0) 
    5282:	fdc42783          	lw	a5,-36(s0)
    5286:	c7b9                	beqz	a5,52d4 <run+0x8c>
      printf("FAILED\n");
    5288:	00003517          	auipc	a0,0x3
    528c:	9d050513          	addi	a0,a0,-1584 # 7c58 <malloc+0x208e>
    5290:	00001097          	auipc	ra,0x1
    5294:	882080e7          	jalr	-1918(ra) # 5b12 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    5298:	fdc42503          	lw	a0,-36(s0)
  }
}
    529c:	00153513          	seqz	a0,a0
    52a0:	70a2                	ld	ra,40(sp)
    52a2:	7402                	ld	s0,32(sp)
    52a4:	64e2                	ld	s1,24(sp)
    52a6:	6942                	ld	s2,16(sp)
    52a8:	6145                	addi	sp,sp,48
    52aa:	8082                	ret
    printf("runtest: fork error\n");
    52ac:	00003517          	auipc	a0,0x3
    52b0:	99450513          	addi	a0,a0,-1644 # 7c40 <malloc+0x2076>
    52b4:	00001097          	auipc	ra,0x1
    52b8:	85e080e7          	jalr	-1954(ra) # 5b12 <printf>
    exit(1);
    52bc:	4505                	li	a0,1
    52be:	00000097          	auipc	ra,0x0
    52c2:	4c2080e7          	jalr	1218(ra) # 5780 <exit>
    f(s);
    52c6:	854a                	mv	a0,s2
    52c8:	9482                	jalr	s1
    exit(0);
    52ca:	4501                	li	a0,0
    52cc:	00000097          	auipc	ra,0x0
    52d0:	4b4080e7          	jalr	1204(ra) # 5780 <exit>
      printf("OK\n");
    52d4:	00003517          	auipc	a0,0x3
    52d8:	98c50513          	addi	a0,a0,-1652 # 7c60 <malloc+0x2096>
    52dc:	00001097          	auipc	ra,0x1
    52e0:	836080e7          	jalr	-1994(ra) # 5b12 <printf>
    52e4:	bf55                	j	5298 <run+0x50>

00000000000052e6 <main>:

int
main(int argc, char *argv[])
{
    52e6:	be010113          	addi	sp,sp,-1056
    52ea:	40113c23          	sd	ra,1048(sp)
    52ee:	40813823          	sd	s0,1040(sp)
    52f2:	40913423          	sd	s1,1032(sp)
    52f6:	41213023          	sd	s2,1024(sp)
    52fa:	3f313c23          	sd	s3,1016(sp)
    52fe:	3f413823          	sd	s4,1008(sp)
    5302:	3f513423          	sd	s5,1000(sp)
    5306:	3f613023          	sd	s6,992(sp)
    530a:	42010413          	addi	s0,sp,1056
    530e:	89aa                	mv	s3,a0
  int continuous = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    5310:	4789                	li	a5,2
    5312:	08f50763          	beq	a0,a5,53a0 <main+0xba>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    5316:	4785                	li	a5,1
  char *justone = 0;
    5318:	4901                	li	s2,0
  } else if(argc > 1){
    531a:	0ca7c163          	blt	a5,a0,53dc <main+0xf6>
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    531e:	00003797          	auipc	a5,0x3
    5322:	d4a78793          	addi	a5,a5,-694 # 8068 <malloc+0x249e>
    5326:	be040713          	addi	a4,s0,-1056
    532a:	00003817          	auipc	a6,0x3
    532e:	11e80813          	addi	a6,a6,286 # 8448 <malloc+0x287e>
    5332:	6388                	ld	a0,0(a5)
    5334:	678c                	ld	a1,8(a5)
    5336:	6b90                	ld	a2,16(a5)
    5338:	6f94                	ld	a3,24(a5)
    533a:	e308                	sd	a0,0(a4)
    533c:	e70c                	sd	a1,8(a4)
    533e:	eb10                	sd	a2,16(a4)
    5340:	ef14                	sd	a3,24(a4)
    5342:	02078793          	addi	a5,a5,32
    5346:	02070713          	addi	a4,a4,32
    534a:	ff0794e3          	bne	a5,a6,5332 <main+0x4c>
          exit(1);
      }
    }
  }

  printf("usertests starting\n");
    534e:	00003517          	auipc	a0,0x3
    5352:	9ca50513          	addi	a0,a0,-1590 # 7d18 <malloc+0x214e>
    5356:	00000097          	auipc	ra,0x0
    535a:	7bc080e7          	jalr	1980(ra) # 5b12 <printf>
  int free0 = countfree();
    535e:	00000097          	auipc	ra,0x0
    5362:	dba080e7          	jalr	-582(ra) # 5118 <countfree>
    5366:	8a2a                	mv	s4,a0
  int free1 = 0;
  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    5368:	be843503          	ld	a0,-1048(s0)
    536c:	be040493          	addi	s1,s0,-1056
  int fail = 0;
    5370:	4981                	li	s3,0
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    5372:	4a85                	li	s5,1
  for (struct test *t = tests; t->s != 0; t++) {
    5374:	e55d                	bnez	a0,5422 <main+0x13c>
  }

  if(fail){
    printf("SOME TESTS FAILED\n");
    exit(1);
  } else if((free1 = countfree()) < free0){
    5376:	00000097          	auipc	ra,0x0
    537a:	da2080e7          	jalr	-606(ra) # 5118 <countfree>
    537e:	85aa                	mv	a1,a0
    5380:	0f455163          	bge	a0,s4,5462 <main+0x17c>
    printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5384:	8652                	mv	a2,s4
    5386:	00003517          	auipc	a0,0x3
    538a:	94a50513          	addi	a0,a0,-1718 # 7cd0 <malloc+0x2106>
    538e:	00000097          	auipc	ra,0x0
    5392:	784080e7          	jalr	1924(ra) # 5b12 <printf>
    exit(1);
    5396:	4505                	li	a0,1
    5398:	00000097          	auipc	ra,0x0
    539c:	3e8080e7          	jalr	1000(ra) # 5780 <exit>
    53a0:	84ae                	mv	s1,a1
  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    53a2:	00003597          	auipc	a1,0x3
    53a6:	8c658593          	addi	a1,a1,-1850 # 7c68 <malloc+0x209e>
    53aa:	6488                	ld	a0,8(s1)
    53ac:	00000097          	auipc	ra,0x0
    53b0:	184080e7          	jalr	388(ra) # 5530 <strcmp>
    53b4:	10050563          	beqz	a0,54be <main+0x1d8>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    53b8:	00003597          	auipc	a1,0x3
    53bc:	99858593          	addi	a1,a1,-1640 # 7d50 <malloc+0x2186>
    53c0:	6488                	ld	a0,8(s1)
    53c2:	00000097          	auipc	ra,0x0
    53c6:	16e080e7          	jalr	366(ra) # 5530 <strcmp>
    53ca:	c97d                	beqz	a0,54c0 <main+0x1da>
  } else if(argc == 2 && argv[1][0] != '-'){
    53cc:	0084b903          	ld	s2,8(s1)
    53d0:	00094703          	lbu	a4,0(s2)
    53d4:	02d00793          	li	a5,45
    53d8:	f4f713e3          	bne	a4,a5,531e <main+0x38>
    printf("Usage: usertests [-c] [testname]\n");
    53dc:	00003517          	auipc	a0,0x3
    53e0:	89450513          	addi	a0,a0,-1900 # 7c70 <malloc+0x20a6>
    53e4:	00000097          	auipc	ra,0x0
    53e8:	72e080e7          	jalr	1838(ra) # 5b12 <printf>
    exit(1);
    53ec:	4505                	li	a0,1
    53ee:	00000097          	auipc	ra,0x0
    53f2:	392080e7          	jalr	914(ra) # 5780 <exit>
          exit(1);
    53f6:	4505                	li	a0,1
    53f8:	00000097          	auipc	ra,0x0
    53fc:	388080e7          	jalr	904(ra) # 5780 <exit>
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    5400:	40a905bb          	subw	a1,s2,a0
    5404:	855a                	mv	a0,s6
    5406:	00000097          	auipc	ra,0x0
    540a:	70c080e7          	jalr	1804(ra) # 5b12 <printf>
        if(continuous != 2)
    540e:	09498463          	beq	s3,s4,5496 <main+0x1b0>
          exit(1);
    5412:	4505                	li	a0,1
    5414:	00000097          	auipc	ra,0x0
    5418:	36c080e7          	jalr	876(ra) # 5780 <exit>
  for (struct test *t = tests; t->s != 0; t++) {
    541c:	04c1                	addi	s1,s1,16
    541e:	6488                	ld	a0,8(s1)
    5420:	c115                	beqz	a0,5444 <main+0x15e>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    5422:	00090863          	beqz	s2,5432 <main+0x14c>
    5426:	85ca                	mv	a1,s2
    5428:	00000097          	auipc	ra,0x0
    542c:	108080e7          	jalr	264(ra) # 5530 <strcmp>
    5430:	f575                	bnez	a0,541c <main+0x136>
      if(!run(t->f, t->s))
    5432:	648c                	ld	a1,8(s1)
    5434:	6088                	ld	a0,0(s1)
    5436:	00000097          	auipc	ra,0x0
    543a:	e12080e7          	jalr	-494(ra) # 5248 <run>
    543e:	fd79                	bnez	a0,541c <main+0x136>
        fail = 1;
    5440:	89d6                	mv	s3,s5
    5442:	bfe9                	j	541c <main+0x136>
  if(fail){
    5444:	f20989e3          	beqz	s3,5376 <main+0x90>
    printf("SOME TESTS FAILED\n");
    5448:	00003517          	auipc	a0,0x3
    544c:	87050513          	addi	a0,a0,-1936 # 7cb8 <malloc+0x20ee>
    5450:	00000097          	auipc	ra,0x0
    5454:	6c2080e7          	jalr	1730(ra) # 5b12 <printf>
    exit(1);
    5458:	4505                	li	a0,1
    545a:	00000097          	auipc	ra,0x0
    545e:	326080e7          	jalr	806(ra) # 5780 <exit>
  } else {
    printf("ALL TESTS PASSED\n");
    5462:	00003517          	auipc	a0,0x3
    5466:	89e50513          	addi	a0,a0,-1890 # 7d00 <malloc+0x2136>
    546a:	00000097          	auipc	ra,0x0
    546e:	6a8080e7          	jalr	1704(ra) # 5b12 <printf>
    exit(0);
    5472:	4501                	li	a0,0
    5474:	00000097          	auipc	ra,0x0
    5478:	30c080e7          	jalr	780(ra) # 5780 <exit>
        printf("SOME TESTS FAILED\n");
    547c:	8556                	mv	a0,s5
    547e:	00000097          	auipc	ra,0x0
    5482:	694080e7          	jalr	1684(ra) # 5b12 <printf>
        if(continuous != 2)
    5486:	f74998e3          	bne	s3,s4,53f6 <main+0x110>
      int free1 = countfree();
    548a:	00000097          	auipc	ra,0x0
    548e:	c8e080e7          	jalr	-882(ra) # 5118 <countfree>
      if(free1 < free0){
    5492:	f72547e3          	blt	a0,s2,5400 <main+0x11a>
      int free0 = countfree();
    5496:	00000097          	auipc	ra,0x0
    549a:	c82080e7          	jalr	-894(ra) # 5118 <countfree>
    549e:	892a                	mv	s2,a0
      for (struct test *t = tests; t->s != 0; t++) {
    54a0:	be843583          	ld	a1,-1048(s0)
    54a4:	d1fd                	beqz	a1,548a <main+0x1a4>
    54a6:	be040493          	addi	s1,s0,-1056
        if(!run(t->f, t->s)){
    54aa:	6088                	ld	a0,0(s1)
    54ac:	00000097          	auipc	ra,0x0
    54b0:	d9c080e7          	jalr	-612(ra) # 5248 <run>
    54b4:	d561                	beqz	a0,547c <main+0x196>
      for (struct test *t = tests; t->s != 0; t++) {
    54b6:	04c1                	addi	s1,s1,16
    54b8:	648c                	ld	a1,8(s1)
    54ba:	f9e5                	bnez	a1,54aa <main+0x1c4>
    54bc:	b7f9                	j	548a <main+0x1a4>
    continuous = 1;
    54be:	4985                	li	s3,1
  } tests[] = {
    54c0:	00003797          	auipc	a5,0x3
    54c4:	ba878793          	addi	a5,a5,-1112 # 8068 <malloc+0x249e>
    54c8:	be040713          	addi	a4,s0,-1056
    54cc:	00003817          	auipc	a6,0x3
    54d0:	f7c80813          	addi	a6,a6,-132 # 8448 <malloc+0x287e>
    54d4:	6388                	ld	a0,0(a5)
    54d6:	678c                	ld	a1,8(a5)
    54d8:	6b90                	ld	a2,16(a5)
    54da:	6f94                	ld	a3,24(a5)
    54dc:	e308                	sd	a0,0(a4)
    54de:	e70c                	sd	a1,8(a4)
    54e0:	eb10                	sd	a2,16(a4)
    54e2:	ef14                	sd	a3,24(a4)
    54e4:	02078793          	addi	a5,a5,32
    54e8:	02070713          	addi	a4,a4,32
    54ec:	ff0794e3          	bne	a5,a6,54d4 <main+0x1ee>
    printf("continuous usertests starting\n");
    54f0:	00003517          	auipc	a0,0x3
    54f4:	84050513          	addi	a0,a0,-1984 # 7d30 <malloc+0x2166>
    54f8:	00000097          	auipc	ra,0x0
    54fc:	61a080e7          	jalr	1562(ra) # 5b12 <printf>
        printf("SOME TESTS FAILED\n");
    5500:	00002a97          	auipc	s5,0x2
    5504:	7b8a8a93          	addi	s5,s5,1976 # 7cb8 <malloc+0x20ee>
        if(continuous != 2)
    5508:	4a09                	li	s4,2
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    550a:	00002b17          	auipc	s6,0x2
    550e:	78eb0b13          	addi	s6,s6,1934 # 7c98 <malloc+0x20ce>
    5512:	b751                	j	5496 <main+0x1b0>

0000000000005514 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    5514:	1141                	addi	sp,sp,-16
    5516:	e422                	sd	s0,8(sp)
    5518:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    551a:	87aa                	mv	a5,a0
    551c:	0585                	addi	a1,a1,1
    551e:	0785                	addi	a5,a5,1
    5520:	fff5c703          	lbu	a4,-1(a1)
    5524:	fee78fa3          	sb	a4,-1(a5)
    5528:	fb75                	bnez	a4,551c <strcpy+0x8>
    ;
  return os;
}
    552a:	6422                	ld	s0,8(sp)
    552c:	0141                	addi	sp,sp,16
    552e:	8082                	ret

0000000000005530 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    5530:	1141                	addi	sp,sp,-16
    5532:	e422                	sd	s0,8(sp)
    5534:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    5536:	00054783          	lbu	a5,0(a0)
    553a:	cb91                	beqz	a5,554e <strcmp+0x1e>
    553c:	0005c703          	lbu	a4,0(a1)
    5540:	00f71763          	bne	a4,a5,554e <strcmp+0x1e>
    p++, q++;
    5544:	0505                	addi	a0,a0,1
    5546:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    5548:	00054783          	lbu	a5,0(a0)
    554c:	fbe5                	bnez	a5,553c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    554e:	0005c503          	lbu	a0,0(a1)
}
    5552:	40a7853b          	subw	a0,a5,a0
    5556:	6422                	ld	s0,8(sp)
    5558:	0141                	addi	sp,sp,16
    555a:	8082                	ret

000000000000555c <strlen>:

uint
strlen(const char *s)
{
    555c:	1141                	addi	sp,sp,-16
    555e:	e422                	sd	s0,8(sp)
    5560:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    5562:	00054783          	lbu	a5,0(a0)
    5566:	cf91                	beqz	a5,5582 <strlen+0x26>
    5568:	0505                	addi	a0,a0,1
    556a:	87aa                	mv	a5,a0
    556c:	4685                	li	a3,1
    556e:	9e89                	subw	a3,a3,a0
    5570:	00f6853b          	addw	a0,a3,a5
    5574:	0785                	addi	a5,a5,1
    5576:	fff7c703          	lbu	a4,-1(a5)
    557a:	fb7d                	bnez	a4,5570 <strlen+0x14>
    ;
  return n;
}
    557c:	6422                	ld	s0,8(sp)
    557e:	0141                	addi	sp,sp,16
    5580:	8082                	ret
  for(n = 0; s[n]; n++)
    5582:	4501                	li	a0,0
    5584:	bfe5                	j	557c <strlen+0x20>

0000000000005586 <memset>:

void*
memset(void *dst, int c, uint n)
{
    5586:	1141                	addi	sp,sp,-16
    5588:	e422                	sd	s0,8(sp)
    558a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    558c:	ca19                	beqz	a2,55a2 <memset+0x1c>
    558e:	87aa                	mv	a5,a0
    5590:	1602                	slli	a2,a2,0x20
    5592:	9201                	srli	a2,a2,0x20
    5594:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    5598:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    559c:	0785                	addi	a5,a5,1
    559e:	fee79de3          	bne	a5,a4,5598 <memset+0x12>
  }
  return dst;
}
    55a2:	6422                	ld	s0,8(sp)
    55a4:	0141                	addi	sp,sp,16
    55a6:	8082                	ret

00000000000055a8 <strchr>:

char*
strchr(const char *s, char c)
{
    55a8:	1141                	addi	sp,sp,-16
    55aa:	e422                	sd	s0,8(sp)
    55ac:	0800                	addi	s0,sp,16
  for(; *s; s++)
    55ae:	00054783          	lbu	a5,0(a0)
    55b2:	cb99                	beqz	a5,55c8 <strchr+0x20>
    if(*s == c)
    55b4:	00f58763          	beq	a1,a5,55c2 <strchr+0x1a>
  for(; *s; s++)
    55b8:	0505                	addi	a0,a0,1
    55ba:	00054783          	lbu	a5,0(a0)
    55be:	fbfd                	bnez	a5,55b4 <strchr+0xc>
      return (char*)s;
  return 0;
    55c0:	4501                	li	a0,0
}
    55c2:	6422                	ld	s0,8(sp)
    55c4:	0141                	addi	sp,sp,16
    55c6:	8082                	ret
  return 0;
    55c8:	4501                	li	a0,0
    55ca:	bfe5                	j	55c2 <strchr+0x1a>

00000000000055cc <gets>:

char*
gets(char *buf, int max)
{
    55cc:	711d                	addi	sp,sp,-96
    55ce:	ec86                	sd	ra,88(sp)
    55d0:	e8a2                	sd	s0,80(sp)
    55d2:	e4a6                	sd	s1,72(sp)
    55d4:	e0ca                	sd	s2,64(sp)
    55d6:	fc4e                	sd	s3,56(sp)
    55d8:	f852                	sd	s4,48(sp)
    55da:	f456                	sd	s5,40(sp)
    55dc:	f05a                	sd	s6,32(sp)
    55de:	ec5e                	sd	s7,24(sp)
    55e0:	1080                	addi	s0,sp,96
    55e2:	8baa                	mv	s7,a0
    55e4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    55e6:	892a                	mv	s2,a0
    55e8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    55ea:	4aa9                	li	s5,10
    55ec:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    55ee:	89a6                	mv	s3,s1
    55f0:	2485                	addiw	s1,s1,1
    55f2:	0344d863          	bge	s1,s4,5622 <gets+0x56>
    cc = read(0, &c, 1);
    55f6:	4605                	li	a2,1
    55f8:	faf40593          	addi	a1,s0,-81
    55fc:	4501                	li	a0,0
    55fe:	00000097          	auipc	ra,0x0
    5602:	19a080e7          	jalr	410(ra) # 5798 <read>
    if(cc < 1)
    5606:	00a05e63          	blez	a0,5622 <gets+0x56>
    buf[i++] = c;
    560a:	faf44783          	lbu	a5,-81(s0)
    560e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5612:	01578763          	beq	a5,s5,5620 <gets+0x54>
    5616:	0905                	addi	s2,s2,1
    5618:	fd679be3          	bne	a5,s6,55ee <gets+0x22>
  for(i=0; i+1 < max; ){
    561c:	89a6                	mv	s3,s1
    561e:	a011                	j	5622 <gets+0x56>
    5620:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5622:	99de                	add	s3,s3,s7
    5624:	00098023          	sb	zero,0(s3)
  return buf;
}
    5628:	855e                	mv	a0,s7
    562a:	60e6                	ld	ra,88(sp)
    562c:	6446                	ld	s0,80(sp)
    562e:	64a6                	ld	s1,72(sp)
    5630:	6906                	ld	s2,64(sp)
    5632:	79e2                	ld	s3,56(sp)
    5634:	7a42                	ld	s4,48(sp)
    5636:	7aa2                	ld	s5,40(sp)
    5638:	7b02                	ld	s6,32(sp)
    563a:	6be2                	ld	s7,24(sp)
    563c:	6125                	addi	sp,sp,96
    563e:	8082                	ret

0000000000005640 <stat>:

int
stat(const char *n, struct stat *st)
{
    5640:	1101                	addi	sp,sp,-32
    5642:	ec06                	sd	ra,24(sp)
    5644:	e822                	sd	s0,16(sp)
    5646:	e426                	sd	s1,8(sp)
    5648:	e04a                	sd	s2,0(sp)
    564a:	1000                	addi	s0,sp,32
    564c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    564e:	4581                	li	a1,0
    5650:	00000097          	auipc	ra,0x0
    5654:	170080e7          	jalr	368(ra) # 57c0 <open>
  if(fd < 0)
    5658:	02054563          	bltz	a0,5682 <stat+0x42>
    565c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    565e:	85ca                	mv	a1,s2
    5660:	00000097          	auipc	ra,0x0
    5664:	178080e7          	jalr	376(ra) # 57d8 <fstat>
    5668:	892a                	mv	s2,a0
  close(fd);
    566a:	8526                	mv	a0,s1
    566c:	00000097          	auipc	ra,0x0
    5670:	13c080e7          	jalr	316(ra) # 57a8 <close>
  return r;
}
    5674:	854a                	mv	a0,s2
    5676:	60e2                	ld	ra,24(sp)
    5678:	6442                	ld	s0,16(sp)
    567a:	64a2                	ld	s1,8(sp)
    567c:	6902                	ld	s2,0(sp)
    567e:	6105                	addi	sp,sp,32
    5680:	8082                	ret
    return -1;
    5682:	597d                	li	s2,-1
    5684:	bfc5                	j	5674 <stat+0x34>

0000000000005686 <atoi>:

int
atoi(const char *s)
{
    5686:	1141                	addi	sp,sp,-16
    5688:	e422                	sd	s0,8(sp)
    568a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    568c:	00054683          	lbu	a3,0(a0)
    5690:	fd06879b          	addiw	a5,a3,-48
    5694:	0ff7f793          	zext.b	a5,a5
    5698:	4625                	li	a2,9
    569a:	02f66863          	bltu	a2,a5,56ca <atoi+0x44>
    569e:	872a                	mv	a4,a0
  n = 0;
    56a0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    56a2:	0705                	addi	a4,a4,1
    56a4:	0025179b          	slliw	a5,a0,0x2
    56a8:	9fa9                	addw	a5,a5,a0
    56aa:	0017979b          	slliw	a5,a5,0x1
    56ae:	9fb5                	addw	a5,a5,a3
    56b0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    56b4:	00074683          	lbu	a3,0(a4)
    56b8:	fd06879b          	addiw	a5,a3,-48
    56bc:	0ff7f793          	zext.b	a5,a5
    56c0:	fef671e3          	bgeu	a2,a5,56a2 <atoi+0x1c>
  return n;
}
    56c4:	6422                	ld	s0,8(sp)
    56c6:	0141                	addi	sp,sp,16
    56c8:	8082                	ret
  n = 0;
    56ca:	4501                	li	a0,0
    56cc:	bfe5                	j	56c4 <atoi+0x3e>

00000000000056ce <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    56ce:	1141                	addi	sp,sp,-16
    56d0:	e422                	sd	s0,8(sp)
    56d2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    56d4:	02b57463          	bgeu	a0,a1,56fc <memmove+0x2e>
    while(n-- > 0)
    56d8:	00c05f63          	blez	a2,56f6 <memmove+0x28>
    56dc:	1602                	slli	a2,a2,0x20
    56de:	9201                	srli	a2,a2,0x20
    56e0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    56e4:	872a                	mv	a4,a0
      *dst++ = *src++;
    56e6:	0585                	addi	a1,a1,1
    56e8:	0705                	addi	a4,a4,1
    56ea:	fff5c683          	lbu	a3,-1(a1)
    56ee:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    56f2:	fee79ae3          	bne	a5,a4,56e6 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    56f6:	6422                	ld	s0,8(sp)
    56f8:	0141                	addi	sp,sp,16
    56fa:	8082                	ret
    dst += n;
    56fc:	00c50733          	add	a4,a0,a2
    src += n;
    5700:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5702:	fec05ae3          	blez	a2,56f6 <memmove+0x28>
    5706:	fff6079b          	addiw	a5,a2,-1
    570a:	1782                	slli	a5,a5,0x20
    570c:	9381                	srli	a5,a5,0x20
    570e:	fff7c793          	not	a5,a5
    5712:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5714:	15fd                	addi	a1,a1,-1
    5716:	177d                	addi	a4,a4,-1
    5718:	0005c683          	lbu	a3,0(a1)
    571c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5720:	fee79ae3          	bne	a5,a4,5714 <memmove+0x46>
    5724:	bfc9                	j	56f6 <memmove+0x28>

0000000000005726 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5726:	1141                	addi	sp,sp,-16
    5728:	e422                	sd	s0,8(sp)
    572a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    572c:	ca05                	beqz	a2,575c <memcmp+0x36>
    572e:	fff6069b          	addiw	a3,a2,-1
    5732:	1682                	slli	a3,a3,0x20
    5734:	9281                	srli	a3,a3,0x20
    5736:	0685                	addi	a3,a3,1
    5738:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    573a:	00054783          	lbu	a5,0(a0)
    573e:	0005c703          	lbu	a4,0(a1)
    5742:	00e79863          	bne	a5,a4,5752 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5746:	0505                	addi	a0,a0,1
    p2++;
    5748:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    574a:	fed518e3          	bne	a0,a3,573a <memcmp+0x14>
  }
  return 0;
    574e:	4501                	li	a0,0
    5750:	a019                	j	5756 <memcmp+0x30>
      return *p1 - *p2;
    5752:	40e7853b          	subw	a0,a5,a4
}
    5756:	6422                	ld	s0,8(sp)
    5758:	0141                	addi	sp,sp,16
    575a:	8082                	ret
  return 0;
    575c:	4501                	li	a0,0
    575e:	bfe5                	j	5756 <memcmp+0x30>

0000000000005760 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5760:	1141                	addi	sp,sp,-16
    5762:	e406                	sd	ra,8(sp)
    5764:	e022                	sd	s0,0(sp)
    5766:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5768:	00000097          	auipc	ra,0x0
    576c:	f66080e7          	jalr	-154(ra) # 56ce <memmove>
}
    5770:	60a2                	ld	ra,8(sp)
    5772:	6402                	ld	s0,0(sp)
    5774:	0141                	addi	sp,sp,16
    5776:	8082                	ret

0000000000005778 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5778:	4885                	li	a7,1
 ecall
    577a:	00000073          	ecall
 ret
    577e:	8082                	ret

0000000000005780 <exit>:
.global exit
exit:
 li a7, SYS_exit
    5780:	4889                	li	a7,2
 ecall
    5782:	00000073          	ecall
 ret
    5786:	8082                	ret

0000000000005788 <wait>:
.global wait
wait:
 li a7, SYS_wait
    5788:	488d                	li	a7,3
 ecall
    578a:	00000073          	ecall
 ret
    578e:	8082                	ret

0000000000005790 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5790:	4891                	li	a7,4
 ecall
    5792:	00000073          	ecall
 ret
    5796:	8082                	ret

0000000000005798 <read>:
.global read
read:
 li a7, SYS_read
    5798:	4895                	li	a7,5
 ecall
    579a:	00000073          	ecall
 ret
    579e:	8082                	ret

00000000000057a0 <write>:
.global write
write:
 li a7, SYS_write
    57a0:	48c1                	li	a7,16
 ecall
    57a2:	00000073          	ecall
 ret
    57a6:	8082                	ret

00000000000057a8 <close>:
.global close
close:
 li a7, SYS_close
    57a8:	48d5                	li	a7,21
 ecall
    57aa:	00000073          	ecall
 ret
    57ae:	8082                	ret

00000000000057b0 <kill>:
.global kill
kill:
 li a7, SYS_kill
    57b0:	4899                	li	a7,6
 ecall
    57b2:	00000073          	ecall
 ret
    57b6:	8082                	ret

00000000000057b8 <exec>:
.global exec
exec:
 li a7, SYS_exec
    57b8:	489d                	li	a7,7
 ecall
    57ba:	00000073          	ecall
 ret
    57be:	8082                	ret

00000000000057c0 <open>:
.global open
open:
 li a7, SYS_open
    57c0:	48bd                	li	a7,15
 ecall
    57c2:	00000073          	ecall
 ret
    57c6:	8082                	ret

00000000000057c8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    57c8:	48c5                	li	a7,17
 ecall
    57ca:	00000073          	ecall
 ret
    57ce:	8082                	ret

00000000000057d0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    57d0:	48c9                	li	a7,18
 ecall
    57d2:	00000073          	ecall
 ret
    57d6:	8082                	ret

00000000000057d8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    57d8:	48a1                	li	a7,8
 ecall
    57da:	00000073          	ecall
 ret
    57de:	8082                	ret

00000000000057e0 <link>:
.global link
link:
 li a7, SYS_link
    57e0:	48cd                	li	a7,19
 ecall
    57e2:	00000073          	ecall
 ret
    57e6:	8082                	ret

00000000000057e8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    57e8:	48d1                	li	a7,20
 ecall
    57ea:	00000073          	ecall
 ret
    57ee:	8082                	ret

00000000000057f0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    57f0:	48a5                	li	a7,9
 ecall
    57f2:	00000073          	ecall
 ret
    57f6:	8082                	ret

00000000000057f8 <dup>:
.global dup
dup:
 li a7, SYS_dup
    57f8:	48a9                	li	a7,10
 ecall
    57fa:	00000073          	ecall
 ret
    57fe:	8082                	ret

0000000000005800 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5800:	48ad                	li	a7,11
 ecall
    5802:	00000073          	ecall
 ret
    5806:	8082                	ret

0000000000005808 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5808:	48b1                	li	a7,12
 ecall
    580a:	00000073          	ecall
 ret
    580e:	8082                	ret

0000000000005810 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5810:	48b5                	li	a7,13
 ecall
    5812:	00000073          	ecall
 ret
    5816:	8082                	ret

0000000000005818 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5818:	48b9                	li	a7,14
 ecall
    581a:	00000073          	ecall
 ret
    581e:	8082                	ret

0000000000005820 <trace>:
.global trace
trace:
 li a7, SYS_trace
    5820:	48d9                	li	a7,22
 ecall
    5822:	00000073          	ecall
 ret
    5826:	8082                	ret

0000000000005828 <set_priority>:
.global set_priority
set_priority:
 li a7, SYS_set_priority
    5828:	48dd                	li	a7,23
 ecall
    582a:	00000073          	ecall
 ret
    582e:	8082                	ret

0000000000005830 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
    5830:	48e1                	li	a7,24
 ecall
    5832:	00000073          	ecall
 ret
    5836:	8082                	ret

0000000000005838 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5838:	1101                	addi	sp,sp,-32
    583a:	ec06                	sd	ra,24(sp)
    583c:	e822                	sd	s0,16(sp)
    583e:	1000                	addi	s0,sp,32
    5840:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5844:	4605                	li	a2,1
    5846:	fef40593          	addi	a1,s0,-17
    584a:	00000097          	auipc	ra,0x0
    584e:	f56080e7          	jalr	-170(ra) # 57a0 <write>
}
    5852:	60e2                	ld	ra,24(sp)
    5854:	6442                	ld	s0,16(sp)
    5856:	6105                	addi	sp,sp,32
    5858:	8082                	ret

000000000000585a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    585a:	7139                	addi	sp,sp,-64
    585c:	fc06                	sd	ra,56(sp)
    585e:	f822                	sd	s0,48(sp)
    5860:	f426                	sd	s1,40(sp)
    5862:	f04a                	sd	s2,32(sp)
    5864:	ec4e                	sd	s3,24(sp)
    5866:	0080                	addi	s0,sp,64
    5868:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    586a:	c299                	beqz	a3,5870 <printint+0x16>
    586c:	0805c963          	bltz	a1,58fe <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5870:	2581                	sext.w	a1,a1
  neg = 0;
    5872:	4881                	li	a7,0
    5874:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    5878:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    587a:	2601                	sext.w	a2,a2
    587c:	00003517          	auipc	a0,0x3
    5880:	c2c50513          	addi	a0,a0,-980 # 84a8 <digits>
    5884:	883a                	mv	a6,a4
    5886:	2705                	addiw	a4,a4,1
    5888:	02c5f7bb          	remuw	a5,a1,a2
    588c:	1782                	slli	a5,a5,0x20
    588e:	9381                	srli	a5,a5,0x20
    5890:	97aa                	add	a5,a5,a0
    5892:	0007c783          	lbu	a5,0(a5)
    5896:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    589a:	0005879b          	sext.w	a5,a1
    589e:	02c5d5bb          	divuw	a1,a1,a2
    58a2:	0685                	addi	a3,a3,1
    58a4:	fec7f0e3          	bgeu	a5,a2,5884 <printint+0x2a>
  if(neg)
    58a8:	00088c63          	beqz	a7,58c0 <printint+0x66>
    buf[i++] = '-';
    58ac:	fd070793          	addi	a5,a4,-48
    58b0:	00878733          	add	a4,a5,s0
    58b4:	02d00793          	li	a5,45
    58b8:	fef70823          	sb	a5,-16(a4)
    58bc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    58c0:	02e05863          	blez	a4,58f0 <printint+0x96>
    58c4:	fc040793          	addi	a5,s0,-64
    58c8:	00e78933          	add	s2,a5,a4
    58cc:	fff78993          	addi	s3,a5,-1
    58d0:	99ba                	add	s3,s3,a4
    58d2:	377d                	addiw	a4,a4,-1
    58d4:	1702                	slli	a4,a4,0x20
    58d6:	9301                	srli	a4,a4,0x20
    58d8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    58dc:	fff94583          	lbu	a1,-1(s2)
    58e0:	8526                	mv	a0,s1
    58e2:	00000097          	auipc	ra,0x0
    58e6:	f56080e7          	jalr	-170(ra) # 5838 <putc>
  while(--i >= 0)
    58ea:	197d                	addi	s2,s2,-1
    58ec:	ff3918e3          	bne	s2,s3,58dc <printint+0x82>
}
    58f0:	70e2                	ld	ra,56(sp)
    58f2:	7442                	ld	s0,48(sp)
    58f4:	74a2                	ld	s1,40(sp)
    58f6:	7902                	ld	s2,32(sp)
    58f8:	69e2                	ld	s3,24(sp)
    58fa:	6121                	addi	sp,sp,64
    58fc:	8082                	ret
    x = -xx;
    58fe:	40b005bb          	negw	a1,a1
    neg = 1;
    5902:	4885                	li	a7,1
    x = -xx;
    5904:	bf85                	j	5874 <printint+0x1a>

0000000000005906 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5906:	7119                	addi	sp,sp,-128
    5908:	fc86                	sd	ra,120(sp)
    590a:	f8a2                	sd	s0,112(sp)
    590c:	f4a6                	sd	s1,104(sp)
    590e:	f0ca                	sd	s2,96(sp)
    5910:	ecce                	sd	s3,88(sp)
    5912:	e8d2                	sd	s4,80(sp)
    5914:	e4d6                	sd	s5,72(sp)
    5916:	e0da                	sd	s6,64(sp)
    5918:	fc5e                	sd	s7,56(sp)
    591a:	f862                	sd	s8,48(sp)
    591c:	f466                	sd	s9,40(sp)
    591e:	f06a                	sd	s10,32(sp)
    5920:	ec6e                	sd	s11,24(sp)
    5922:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5924:	0005c903          	lbu	s2,0(a1)
    5928:	18090f63          	beqz	s2,5ac6 <vprintf+0x1c0>
    592c:	8aaa                	mv	s5,a0
    592e:	8b32                	mv	s6,a2
    5930:	00158493          	addi	s1,a1,1
  state = 0;
    5934:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5936:	02500a13          	li	s4,37
    593a:	4c55                	li	s8,21
    593c:	00003c97          	auipc	s9,0x3
    5940:	b14c8c93          	addi	s9,s9,-1260 # 8450 <malloc+0x2886>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    5944:	02800d93          	li	s11,40
  putc(fd, 'x');
    5948:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    594a:	00003b97          	auipc	s7,0x3
    594e:	b5eb8b93          	addi	s7,s7,-1186 # 84a8 <digits>
    5952:	a839                	j	5970 <vprintf+0x6a>
        putc(fd, c);
    5954:	85ca                	mv	a1,s2
    5956:	8556                	mv	a0,s5
    5958:	00000097          	auipc	ra,0x0
    595c:	ee0080e7          	jalr	-288(ra) # 5838 <putc>
    5960:	a019                	j	5966 <vprintf+0x60>
    } else if(state == '%'){
    5962:	01498d63          	beq	s3,s4,597c <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
    5966:	0485                	addi	s1,s1,1
    5968:	fff4c903          	lbu	s2,-1(s1)
    596c:	14090d63          	beqz	s2,5ac6 <vprintf+0x1c0>
    if(state == 0){
    5970:	fe0999e3          	bnez	s3,5962 <vprintf+0x5c>
      if(c == '%'){
    5974:	ff4910e3          	bne	s2,s4,5954 <vprintf+0x4e>
        state = '%';
    5978:	89d2                	mv	s3,s4
    597a:	b7f5                	j	5966 <vprintf+0x60>
      if(c == 'd'){
    597c:	11490c63          	beq	s2,s4,5a94 <vprintf+0x18e>
    5980:	f9d9079b          	addiw	a5,s2,-99
    5984:	0ff7f793          	zext.b	a5,a5
    5988:	10fc6e63          	bltu	s8,a5,5aa4 <vprintf+0x19e>
    598c:	f9d9079b          	addiw	a5,s2,-99
    5990:	0ff7f713          	zext.b	a4,a5
    5994:	10ec6863          	bltu	s8,a4,5aa4 <vprintf+0x19e>
    5998:	00271793          	slli	a5,a4,0x2
    599c:	97e6                	add	a5,a5,s9
    599e:	439c                	lw	a5,0(a5)
    59a0:	97e6                	add	a5,a5,s9
    59a2:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    59a4:	008b0913          	addi	s2,s6,8
    59a8:	4685                	li	a3,1
    59aa:	4629                	li	a2,10
    59ac:	000b2583          	lw	a1,0(s6)
    59b0:	8556                	mv	a0,s5
    59b2:	00000097          	auipc	ra,0x0
    59b6:	ea8080e7          	jalr	-344(ra) # 585a <printint>
    59ba:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    59bc:	4981                	li	s3,0
    59be:	b765                	j	5966 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    59c0:	008b0913          	addi	s2,s6,8
    59c4:	4681                	li	a3,0
    59c6:	4629                	li	a2,10
    59c8:	000b2583          	lw	a1,0(s6)
    59cc:	8556                	mv	a0,s5
    59ce:	00000097          	auipc	ra,0x0
    59d2:	e8c080e7          	jalr	-372(ra) # 585a <printint>
    59d6:	8b4a                	mv	s6,s2
      state = 0;
    59d8:	4981                	li	s3,0
    59da:	b771                	j	5966 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    59dc:	008b0913          	addi	s2,s6,8
    59e0:	4681                	li	a3,0
    59e2:	866a                	mv	a2,s10
    59e4:	000b2583          	lw	a1,0(s6)
    59e8:	8556                	mv	a0,s5
    59ea:	00000097          	auipc	ra,0x0
    59ee:	e70080e7          	jalr	-400(ra) # 585a <printint>
    59f2:	8b4a                	mv	s6,s2
      state = 0;
    59f4:	4981                	li	s3,0
    59f6:	bf85                	j	5966 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    59f8:	008b0793          	addi	a5,s6,8
    59fc:	f8f43423          	sd	a5,-120(s0)
    5a00:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    5a04:	03000593          	li	a1,48
    5a08:	8556                	mv	a0,s5
    5a0a:	00000097          	auipc	ra,0x0
    5a0e:	e2e080e7          	jalr	-466(ra) # 5838 <putc>
  putc(fd, 'x');
    5a12:	07800593          	li	a1,120
    5a16:	8556                	mv	a0,s5
    5a18:	00000097          	auipc	ra,0x0
    5a1c:	e20080e7          	jalr	-480(ra) # 5838 <putc>
    5a20:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5a22:	03c9d793          	srli	a5,s3,0x3c
    5a26:	97de                	add	a5,a5,s7
    5a28:	0007c583          	lbu	a1,0(a5)
    5a2c:	8556                	mv	a0,s5
    5a2e:	00000097          	auipc	ra,0x0
    5a32:	e0a080e7          	jalr	-502(ra) # 5838 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5a36:	0992                	slli	s3,s3,0x4
    5a38:	397d                	addiw	s2,s2,-1
    5a3a:	fe0914e3          	bnez	s2,5a22 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
    5a3e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    5a42:	4981                	li	s3,0
    5a44:	b70d                	j	5966 <vprintf+0x60>
        s = va_arg(ap, char*);
    5a46:	008b0913          	addi	s2,s6,8
    5a4a:	000b3983          	ld	s3,0(s6)
        if(s == 0)
    5a4e:	02098163          	beqz	s3,5a70 <vprintf+0x16a>
        while(*s != 0){
    5a52:	0009c583          	lbu	a1,0(s3)
    5a56:	c5ad                	beqz	a1,5ac0 <vprintf+0x1ba>
          putc(fd, *s);
    5a58:	8556                	mv	a0,s5
    5a5a:	00000097          	auipc	ra,0x0
    5a5e:	dde080e7          	jalr	-546(ra) # 5838 <putc>
          s++;
    5a62:	0985                	addi	s3,s3,1
        while(*s != 0){
    5a64:	0009c583          	lbu	a1,0(s3)
    5a68:	f9e5                	bnez	a1,5a58 <vprintf+0x152>
        s = va_arg(ap, char*);
    5a6a:	8b4a                	mv	s6,s2
      state = 0;
    5a6c:	4981                	li	s3,0
    5a6e:	bde5                	j	5966 <vprintf+0x60>
          s = "(null)";
    5a70:	00003997          	auipc	s3,0x3
    5a74:	9d898993          	addi	s3,s3,-1576 # 8448 <malloc+0x287e>
        while(*s != 0){
    5a78:	85ee                	mv	a1,s11
    5a7a:	bff9                	j	5a58 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
    5a7c:	008b0913          	addi	s2,s6,8
    5a80:	000b4583          	lbu	a1,0(s6)
    5a84:	8556                	mv	a0,s5
    5a86:	00000097          	auipc	ra,0x0
    5a8a:	db2080e7          	jalr	-590(ra) # 5838 <putc>
    5a8e:	8b4a                	mv	s6,s2
      state = 0;
    5a90:	4981                	li	s3,0
    5a92:	bdd1                	j	5966 <vprintf+0x60>
        putc(fd, c);
    5a94:	85d2                	mv	a1,s4
    5a96:	8556                	mv	a0,s5
    5a98:	00000097          	auipc	ra,0x0
    5a9c:	da0080e7          	jalr	-608(ra) # 5838 <putc>
      state = 0;
    5aa0:	4981                	li	s3,0
    5aa2:	b5d1                	j	5966 <vprintf+0x60>
        putc(fd, '%');
    5aa4:	85d2                	mv	a1,s4
    5aa6:	8556                	mv	a0,s5
    5aa8:	00000097          	auipc	ra,0x0
    5aac:	d90080e7          	jalr	-624(ra) # 5838 <putc>
        putc(fd, c);
    5ab0:	85ca                	mv	a1,s2
    5ab2:	8556                	mv	a0,s5
    5ab4:	00000097          	auipc	ra,0x0
    5ab8:	d84080e7          	jalr	-636(ra) # 5838 <putc>
      state = 0;
    5abc:	4981                	li	s3,0
    5abe:	b565                	j	5966 <vprintf+0x60>
        s = va_arg(ap, char*);
    5ac0:	8b4a                	mv	s6,s2
      state = 0;
    5ac2:	4981                	li	s3,0
    5ac4:	b54d                	j	5966 <vprintf+0x60>
    }
  }
}
    5ac6:	70e6                	ld	ra,120(sp)
    5ac8:	7446                	ld	s0,112(sp)
    5aca:	74a6                	ld	s1,104(sp)
    5acc:	7906                	ld	s2,96(sp)
    5ace:	69e6                	ld	s3,88(sp)
    5ad0:	6a46                	ld	s4,80(sp)
    5ad2:	6aa6                	ld	s5,72(sp)
    5ad4:	6b06                	ld	s6,64(sp)
    5ad6:	7be2                	ld	s7,56(sp)
    5ad8:	7c42                	ld	s8,48(sp)
    5ada:	7ca2                	ld	s9,40(sp)
    5adc:	7d02                	ld	s10,32(sp)
    5ade:	6de2                	ld	s11,24(sp)
    5ae0:	6109                	addi	sp,sp,128
    5ae2:	8082                	ret

0000000000005ae4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5ae4:	715d                	addi	sp,sp,-80
    5ae6:	ec06                	sd	ra,24(sp)
    5ae8:	e822                	sd	s0,16(sp)
    5aea:	1000                	addi	s0,sp,32
    5aec:	e010                	sd	a2,0(s0)
    5aee:	e414                	sd	a3,8(s0)
    5af0:	e818                	sd	a4,16(s0)
    5af2:	ec1c                	sd	a5,24(s0)
    5af4:	03043023          	sd	a6,32(s0)
    5af8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5afc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5b00:	8622                	mv	a2,s0
    5b02:	00000097          	auipc	ra,0x0
    5b06:	e04080e7          	jalr	-508(ra) # 5906 <vprintf>
}
    5b0a:	60e2                	ld	ra,24(sp)
    5b0c:	6442                	ld	s0,16(sp)
    5b0e:	6161                	addi	sp,sp,80
    5b10:	8082                	ret

0000000000005b12 <printf>:

void
printf(const char *fmt, ...)
{
    5b12:	711d                	addi	sp,sp,-96
    5b14:	ec06                	sd	ra,24(sp)
    5b16:	e822                	sd	s0,16(sp)
    5b18:	1000                	addi	s0,sp,32
    5b1a:	e40c                	sd	a1,8(s0)
    5b1c:	e810                	sd	a2,16(s0)
    5b1e:	ec14                	sd	a3,24(s0)
    5b20:	f018                	sd	a4,32(s0)
    5b22:	f41c                	sd	a5,40(s0)
    5b24:	03043823          	sd	a6,48(s0)
    5b28:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5b2c:	00840613          	addi	a2,s0,8
    5b30:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5b34:	85aa                	mv	a1,a0
    5b36:	4505                	li	a0,1
    5b38:	00000097          	auipc	ra,0x0
    5b3c:	dce080e7          	jalr	-562(ra) # 5906 <vprintf>
}
    5b40:	60e2                	ld	ra,24(sp)
    5b42:	6442                	ld	s0,16(sp)
    5b44:	6125                	addi	sp,sp,96
    5b46:	8082                	ret

0000000000005b48 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5b48:	1141                	addi	sp,sp,-16
    5b4a:	e422                	sd	s0,8(sp)
    5b4c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5b4e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5b52:	00003797          	auipc	a5,0x3
    5b56:	9767b783          	ld	a5,-1674(a5) # 84c8 <freep>
    5b5a:	a02d                	j	5b84 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5b5c:	4618                	lw	a4,8(a2)
    5b5e:	9f2d                	addw	a4,a4,a1
    5b60:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5b64:	6398                	ld	a4,0(a5)
    5b66:	6310                	ld	a2,0(a4)
    5b68:	a83d                	j	5ba6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5b6a:	ff852703          	lw	a4,-8(a0)
    5b6e:	9f31                	addw	a4,a4,a2
    5b70:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5b72:	ff053683          	ld	a3,-16(a0)
    5b76:	a091                	j	5bba <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5b78:	6398                	ld	a4,0(a5)
    5b7a:	00e7e463          	bltu	a5,a4,5b82 <free+0x3a>
    5b7e:	00e6ea63          	bltu	a3,a4,5b92 <free+0x4a>
{
    5b82:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5b84:	fed7fae3          	bgeu	a5,a3,5b78 <free+0x30>
    5b88:	6398                	ld	a4,0(a5)
    5b8a:	00e6e463          	bltu	a3,a4,5b92 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5b8e:	fee7eae3          	bltu	a5,a4,5b82 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    5b92:	ff852583          	lw	a1,-8(a0)
    5b96:	6390                	ld	a2,0(a5)
    5b98:	02059813          	slli	a6,a1,0x20
    5b9c:	01c85713          	srli	a4,a6,0x1c
    5ba0:	9736                	add	a4,a4,a3
    5ba2:	fae60de3          	beq	a2,a4,5b5c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    5ba6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5baa:	4790                	lw	a2,8(a5)
    5bac:	02061593          	slli	a1,a2,0x20
    5bb0:	01c5d713          	srli	a4,a1,0x1c
    5bb4:	973e                	add	a4,a4,a5
    5bb6:	fae68ae3          	beq	a3,a4,5b6a <free+0x22>
    p->s.ptr = bp->s.ptr;
    5bba:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    5bbc:	00003717          	auipc	a4,0x3
    5bc0:	90f73623          	sd	a5,-1780(a4) # 84c8 <freep>
}
    5bc4:	6422                	ld	s0,8(sp)
    5bc6:	0141                	addi	sp,sp,16
    5bc8:	8082                	ret

0000000000005bca <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5bca:	7139                	addi	sp,sp,-64
    5bcc:	fc06                	sd	ra,56(sp)
    5bce:	f822                	sd	s0,48(sp)
    5bd0:	f426                	sd	s1,40(sp)
    5bd2:	f04a                	sd	s2,32(sp)
    5bd4:	ec4e                	sd	s3,24(sp)
    5bd6:	e852                	sd	s4,16(sp)
    5bd8:	e456                	sd	s5,8(sp)
    5bda:	e05a                	sd	s6,0(sp)
    5bdc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5bde:	02051493          	slli	s1,a0,0x20
    5be2:	9081                	srli	s1,s1,0x20
    5be4:	04bd                	addi	s1,s1,15
    5be6:	8091                	srli	s1,s1,0x4
    5be8:	0014899b          	addiw	s3,s1,1
    5bec:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    5bee:	00003517          	auipc	a0,0x3
    5bf2:	8da53503          	ld	a0,-1830(a0) # 84c8 <freep>
    5bf6:	c515                	beqz	a0,5c22 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5bf8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5bfa:	4798                	lw	a4,8(a5)
    5bfc:	02977f63          	bgeu	a4,s1,5c3a <malloc+0x70>
    5c00:	8a4e                	mv	s4,s3
    5c02:	0009871b          	sext.w	a4,s3
    5c06:	6685                	lui	a3,0x1
    5c08:	00d77363          	bgeu	a4,a3,5c0e <malloc+0x44>
    5c0c:	6a05                	lui	s4,0x1
    5c0e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5c12:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    5c16:	00003917          	auipc	s2,0x3
    5c1a:	8b290913          	addi	s2,s2,-1870 # 84c8 <freep>
  if(p == (char*)-1)
    5c1e:	5afd                	li	s5,-1
    5c20:	a895                	j	5c94 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    5c22:	00009797          	auipc	a5,0x9
    5c26:	0c678793          	addi	a5,a5,198 # ece8 <base>
    5c2a:	00003717          	auipc	a4,0x3
    5c2e:	88f73f23          	sd	a5,-1890(a4) # 84c8 <freep>
    5c32:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5c34:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5c38:	b7e1                	j	5c00 <malloc+0x36>
      if(p->s.size == nunits)
    5c3a:	02e48c63          	beq	s1,a4,5c72 <malloc+0xa8>
        p->s.size -= nunits;
    5c3e:	4137073b          	subw	a4,a4,s3
    5c42:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5c44:	02071693          	slli	a3,a4,0x20
    5c48:	01c6d713          	srli	a4,a3,0x1c
    5c4c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5c4e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5c52:	00003717          	auipc	a4,0x3
    5c56:	86a73b23          	sd	a0,-1930(a4) # 84c8 <freep>
      return (void*)(p + 1);
    5c5a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    5c5e:	70e2                	ld	ra,56(sp)
    5c60:	7442                	ld	s0,48(sp)
    5c62:	74a2                	ld	s1,40(sp)
    5c64:	7902                	ld	s2,32(sp)
    5c66:	69e2                	ld	s3,24(sp)
    5c68:	6a42                	ld	s4,16(sp)
    5c6a:	6aa2                	ld	s5,8(sp)
    5c6c:	6b02                	ld	s6,0(sp)
    5c6e:	6121                	addi	sp,sp,64
    5c70:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    5c72:	6398                	ld	a4,0(a5)
    5c74:	e118                	sd	a4,0(a0)
    5c76:	bff1                	j	5c52 <malloc+0x88>
  hp->s.size = nu;
    5c78:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    5c7c:	0541                	addi	a0,a0,16
    5c7e:	00000097          	auipc	ra,0x0
    5c82:	eca080e7          	jalr	-310(ra) # 5b48 <free>
  return freep;
    5c86:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    5c8a:	d971                	beqz	a0,5c5e <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5c8c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5c8e:	4798                	lw	a4,8(a5)
    5c90:	fa9775e3          	bgeu	a4,s1,5c3a <malloc+0x70>
    if(p == freep)
    5c94:	00093703          	ld	a4,0(s2)
    5c98:	853e                	mv	a0,a5
    5c9a:	fef719e3          	bne	a4,a5,5c8c <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    5c9e:	8552                	mv	a0,s4
    5ca0:	00000097          	auipc	ra,0x0
    5ca4:	b68080e7          	jalr	-1176(ra) # 5808 <sbrk>
  if(p == (char*)-1)
    5ca8:	fd5518e3          	bne	a0,s5,5c78 <malloc+0xae>
        return 0;
    5cac:	4501                	li	a0,0
    5cae:	bf45                	j	5c5e <malloc+0x94>
