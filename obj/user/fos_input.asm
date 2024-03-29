
obj/user/fos_input:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	mov $0, %eax
  800020:	b8 00 00 00 00       	mov    $0x0,%eax
	cmpl $USTACKTOP, %esp
  800025:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  80002b:	75 04                	jne    800031 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  80002d:	6a 00                	push   $0x0
	pushl $0
  80002f:	6a 00                	push   $0x0

00800031 <args_exist>:

args_exist:
	call libmain
  800031:	e8 a5 00 00 00       	call   8000db <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void
_main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 04 00 00    	sub    $0x418,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int i2=0;
  800048:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	char buff1[512];
	char buff2[512];


	atomic_readline("Please enter first number :", buff1);
  80004f:	83 ec 08             	sub    $0x8,%esp
  800052:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
  800058:	50                   	push   %eax
  800059:	68 80 1d 80 00       	push   $0x801d80
  80005e:	e8 fa 09 00 00       	call   800a5d <atomic_readline>
  800063:	83 c4 10             	add    $0x10,%esp
	i1 = strtol(buff1, NULL, 10);
  800066:	83 ec 04             	sub    $0x4,%esp
  800069:	6a 0a                	push   $0xa
  80006b:	6a 00                	push   $0x0
  80006d:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
  800073:	50                   	push   %eax
  800074:	e8 4c 0e 00 00       	call   800ec5 <strtol>
  800079:	83 c4 10             	add    $0x10,%esp
  80007c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	//sleep
	env_sleep(2800);
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	68 f0 0a 00 00       	push   $0xaf0
  800087:	e8 1f 19 00 00       	call   8019ab <env_sleep>
  80008c:	83 c4 10             	add    $0x10,%esp

	atomic_readline("Please enter second number :", buff2);
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  800098:	50                   	push   %eax
  800099:	68 9c 1d 80 00       	push   $0x801d9c
  80009e:	e8 ba 09 00 00       	call   800a5d <atomic_readline>
  8000a3:	83 c4 10             	add    $0x10,%esp
	
	i2 = strtol(buff2, NULL, 10);
  8000a6:	83 ec 04             	sub    $0x4,%esp
  8000a9:	6a 0a                	push   $0xa
  8000ab:	6a 00                	push   $0x0
  8000ad:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  8000b3:	50                   	push   %eax
  8000b4:	e8 0c 0e 00 00       	call   800ec5 <strtol>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("number 1 + number 2 = %d\n",i1+i2);
  8000bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c5:	01 d0                	add    %edx,%eax
  8000c7:	83 ec 08             	sub    $0x8,%esp
  8000ca:	50                   	push   %eax
  8000cb:	68 b9 1d 80 00       	push   $0x801db9
  8000d0:	e8 35 02 00 00       	call   80030a <atomic_cprintf>
  8000d5:	83 c4 10             	add    $0x10,%esp
	return;	
  8000d8:	90                   	nop
}
  8000d9:	c9                   	leave  
  8000da:	c3                   	ret    

008000db <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000db:	55                   	push   %ebp
  8000dc:	89 e5                	mov    %esp,%ebp
  8000de:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000e1:	e8 6e 15 00 00       	call   801654 <sys_getenvindex>
  8000e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000ec:	89 d0                	mov    %edx,%eax
  8000ee:	01 c0                	add    %eax,%eax
  8000f0:	01 d0                	add    %edx,%eax
  8000f2:	c1 e0 06             	shl    $0x6,%eax
  8000f5:	29 d0                	sub    %edx,%eax
  8000f7:	c1 e0 03             	shl    $0x3,%eax
  8000fa:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000ff:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800104:	a1 20 30 80 00       	mov    0x803020,%eax
  800109:	8a 40 68             	mov    0x68(%eax),%al
  80010c:	84 c0                	test   %al,%al
  80010e:	74 0d                	je     80011d <libmain+0x42>
		binaryname = myEnv->prog_name;
  800110:	a1 20 30 80 00       	mov    0x803020,%eax
  800115:	83 c0 68             	add    $0x68,%eax
  800118:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80011d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800121:	7e 0a                	jle    80012d <libmain+0x52>
		binaryname = argv[0];
  800123:	8b 45 0c             	mov    0xc(%ebp),%eax
  800126:	8b 00                	mov    (%eax),%eax
  800128:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80012d:	83 ec 08             	sub    $0x8,%esp
  800130:	ff 75 0c             	pushl  0xc(%ebp)
  800133:	ff 75 08             	pushl  0x8(%ebp)
  800136:	e8 fd fe ff ff       	call   800038 <_main>
  80013b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80013e:	e8 1e 13 00 00       	call   801461 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	68 ec 1d 80 00       	push   $0x801dec
  80014b:	e8 8d 01 00 00       	call   8002dd <cprintf>
  800150:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800153:	a1 20 30 80 00       	mov    0x803020,%eax
  800158:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  80015e:	a1 20 30 80 00       	mov    0x803020,%eax
  800163:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  800169:	83 ec 04             	sub    $0x4,%esp
  80016c:	52                   	push   %edx
  80016d:	50                   	push   %eax
  80016e:	68 14 1e 80 00       	push   $0x801e14
  800173:	e8 65 01 00 00       	call   8002dd <cprintf>
  800178:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80017b:	a1 20 30 80 00       	mov    0x803020,%eax
  800180:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  800186:	a1 20 30 80 00       	mov    0x803020,%eax
  80018b:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  800191:	a1 20 30 80 00       	mov    0x803020,%eax
  800196:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  80019c:	51                   	push   %ecx
  80019d:	52                   	push   %edx
  80019e:	50                   	push   %eax
  80019f:	68 3c 1e 80 00       	push   $0x801e3c
  8001a4:	e8 34 01 00 00       	call   8002dd <cprintf>
  8001a9:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001ac:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b1:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  8001b7:	83 ec 08             	sub    $0x8,%esp
  8001ba:	50                   	push   %eax
  8001bb:	68 94 1e 80 00       	push   $0x801e94
  8001c0:	e8 18 01 00 00       	call   8002dd <cprintf>
  8001c5:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8001c8:	83 ec 0c             	sub    $0xc,%esp
  8001cb:	68 ec 1d 80 00       	push   $0x801dec
  8001d0:	e8 08 01 00 00       	call   8002dd <cprintf>
  8001d5:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001d8:	e8 9e 12 00 00       	call   80147b <sys_enable_interrupt>

	// exit gracefully
	exit();
  8001dd:	e8 19 00 00 00       	call   8001fb <exit>
}
  8001e2:	90                   	nop
  8001e3:	c9                   	leave  
  8001e4:	c3                   	ret    

008001e5 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001e5:	55                   	push   %ebp
  8001e6:	89 e5                	mov    %esp,%ebp
  8001e8:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001eb:	83 ec 0c             	sub    $0xc,%esp
  8001ee:	6a 00                	push   $0x0
  8001f0:	e8 2b 14 00 00       	call   801620 <sys_destroy_env>
  8001f5:	83 c4 10             	add    $0x10,%esp
}
  8001f8:	90                   	nop
  8001f9:	c9                   	leave  
  8001fa:	c3                   	ret    

008001fb <exit>:

void
exit(void)
{
  8001fb:	55                   	push   %ebp
  8001fc:	89 e5                	mov    %esp,%ebp
  8001fe:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800201:	e8 80 14 00 00       	call   801686 <sys_exit_env>
}
  800206:	90                   	nop
  800207:	c9                   	leave  
  800208:	c3                   	ret    

00800209 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800209:	55                   	push   %ebp
  80020a:	89 e5                	mov    %esp,%ebp
  80020c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80020f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800212:	8b 00                	mov    (%eax),%eax
  800214:	8d 48 01             	lea    0x1(%eax),%ecx
  800217:	8b 55 0c             	mov    0xc(%ebp),%edx
  80021a:	89 0a                	mov    %ecx,(%edx)
  80021c:	8b 55 08             	mov    0x8(%ebp),%edx
  80021f:	88 d1                	mov    %dl,%cl
  800221:	8b 55 0c             	mov    0xc(%ebp),%edx
  800224:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800228:	8b 45 0c             	mov    0xc(%ebp),%eax
  80022b:	8b 00                	mov    (%eax),%eax
  80022d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800232:	75 2c                	jne    800260 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800234:	a0 24 30 80 00       	mov    0x803024,%al
  800239:	0f b6 c0             	movzbl %al,%eax
  80023c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80023f:	8b 12                	mov    (%edx),%edx
  800241:	89 d1                	mov    %edx,%ecx
  800243:	8b 55 0c             	mov    0xc(%ebp),%edx
  800246:	83 c2 08             	add    $0x8,%edx
  800249:	83 ec 04             	sub    $0x4,%esp
  80024c:	50                   	push   %eax
  80024d:	51                   	push   %ecx
  80024e:	52                   	push   %edx
  80024f:	e8 b4 10 00 00       	call   801308 <sys_cputs>
  800254:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800257:	8b 45 0c             	mov    0xc(%ebp),%eax
  80025a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800260:	8b 45 0c             	mov    0xc(%ebp),%eax
  800263:	8b 40 04             	mov    0x4(%eax),%eax
  800266:	8d 50 01             	lea    0x1(%eax),%edx
  800269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80026c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80026f:	90                   	nop
  800270:	c9                   	leave  
  800271:	c3                   	ret    

00800272 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800272:	55                   	push   %ebp
  800273:	89 e5                	mov    %esp,%ebp
  800275:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80027b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800282:	00 00 00 
	b.cnt = 0;
  800285:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80028c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80028f:	ff 75 0c             	pushl  0xc(%ebp)
  800292:	ff 75 08             	pushl  0x8(%ebp)
  800295:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80029b:	50                   	push   %eax
  80029c:	68 09 02 80 00       	push   $0x800209
  8002a1:	e8 11 02 00 00       	call   8004b7 <vprintfmt>
  8002a6:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8002a9:	a0 24 30 80 00       	mov    0x803024,%al
  8002ae:	0f b6 c0             	movzbl %al,%eax
  8002b1:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002b7:	83 ec 04             	sub    $0x4,%esp
  8002ba:	50                   	push   %eax
  8002bb:	52                   	push   %edx
  8002bc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002c2:	83 c0 08             	add    $0x8,%eax
  8002c5:	50                   	push   %eax
  8002c6:	e8 3d 10 00 00       	call   801308 <sys_cputs>
  8002cb:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002ce:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8002d5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002db:	c9                   	leave  
  8002dc:	c3                   	ret    

008002dd <cprintf>:

int cprintf(const char *fmt, ...) {
  8002dd:	55                   	push   %ebp
  8002de:	89 e5                	mov    %esp,%ebp
  8002e0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002e3:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8002ea:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f3:	83 ec 08             	sub    $0x8,%esp
  8002f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8002f9:	50                   	push   %eax
  8002fa:	e8 73 ff ff ff       	call   800272 <vcprintf>
  8002ff:	83 c4 10             	add    $0x10,%esp
  800302:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800305:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800308:	c9                   	leave  
  800309:	c3                   	ret    

0080030a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80030a:	55                   	push   %ebp
  80030b:	89 e5                	mov    %esp,%ebp
  80030d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800310:	e8 4c 11 00 00       	call   801461 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800315:	8d 45 0c             	lea    0xc(%ebp),%eax
  800318:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80031b:	8b 45 08             	mov    0x8(%ebp),%eax
  80031e:	83 ec 08             	sub    $0x8,%esp
  800321:	ff 75 f4             	pushl  -0xc(%ebp)
  800324:	50                   	push   %eax
  800325:	e8 48 ff ff ff       	call   800272 <vcprintf>
  80032a:	83 c4 10             	add    $0x10,%esp
  80032d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800330:	e8 46 11 00 00       	call   80147b <sys_enable_interrupt>
	return cnt;
  800335:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800338:	c9                   	leave  
  800339:	c3                   	ret    

0080033a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80033a:	55                   	push   %ebp
  80033b:	89 e5                	mov    %esp,%ebp
  80033d:	53                   	push   %ebx
  80033e:	83 ec 14             	sub    $0x14,%esp
  800341:	8b 45 10             	mov    0x10(%ebp),%eax
  800344:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800347:	8b 45 14             	mov    0x14(%ebp),%eax
  80034a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80034d:	8b 45 18             	mov    0x18(%ebp),%eax
  800350:	ba 00 00 00 00       	mov    $0x0,%edx
  800355:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800358:	77 55                	ja     8003af <printnum+0x75>
  80035a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80035d:	72 05                	jb     800364 <printnum+0x2a>
  80035f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800362:	77 4b                	ja     8003af <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800364:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800367:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80036a:	8b 45 18             	mov    0x18(%ebp),%eax
  80036d:	ba 00 00 00 00       	mov    $0x0,%edx
  800372:	52                   	push   %edx
  800373:	50                   	push   %eax
  800374:	ff 75 f4             	pushl  -0xc(%ebp)
  800377:	ff 75 f0             	pushl  -0x10(%ebp)
  80037a:	e8 81 17 00 00       	call   801b00 <__udivdi3>
  80037f:	83 c4 10             	add    $0x10,%esp
  800382:	83 ec 04             	sub    $0x4,%esp
  800385:	ff 75 20             	pushl  0x20(%ebp)
  800388:	53                   	push   %ebx
  800389:	ff 75 18             	pushl  0x18(%ebp)
  80038c:	52                   	push   %edx
  80038d:	50                   	push   %eax
  80038e:	ff 75 0c             	pushl  0xc(%ebp)
  800391:	ff 75 08             	pushl  0x8(%ebp)
  800394:	e8 a1 ff ff ff       	call   80033a <printnum>
  800399:	83 c4 20             	add    $0x20,%esp
  80039c:	eb 1a                	jmp    8003b8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80039e:	83 ec 08             	sub    $0x8,%esp
  8003a1:	ff 75 0c             	pushl  0xc(%ebp)
  8003a4:	ff 75 20             	pushl  0x20(%ebp)
  8003a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003aa:	ff d0                	call   *%eax
  8003ac:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003af:	ff 4d 1c             	decl   0x1c(%ebp)
  8003b2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003b6:	7f e6                	jg     80039e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003b8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003c6:	53                   	push   %ebx
  8003c7:	51                   	push   %ecx
  8003c8:	52                   	push   %edx
  8003c9:	50                   	push   %eax
  8003ca:	e8 41 18 00 00       	call   801c10 <__umoddi3>
  8003cf:	83 c4 10             	add    $0x10,%esp
  8003d2:	05 d4 20 80 00       	add    $0x8020d4,%eax
  8003d7:	8a 00                	mov    (%eax),%al
  8003d9:	0f be c0             	movsbl %al,%eax
  8003dc:	83 ec 08             	sub    $0x8,%esp
  8003df:	ff 75 0c             	pushl  0xc(%ebp)
  8003e2:	50                   	push   %eax
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e6:	ff d0                	call   *%eax
  8003e8:	83 c4 10             	add    $0x10,%esp
}
  8003eb:	90                   	nop
  8003ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003ef:	c9                   	leave  
  8003f0:	c3                   	ret    

008003f1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003f1:	55                   	push   %ebp
  8003f2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003f4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003f8:	7e 1c                	jle    800416 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8003fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fd:	8b 00                	mov    (%eax),%eax
  8003ff:	8d 50 08             	lea    0x8(%eax),%edx
  800402:	8b 45 08             	mov    0x8(%ebp),%eax
  800405:	89 10                	mov    %edx,(%eax)
  800407:	8b 45 08             	mov    0x8(%ebp),%eax
  80040a:	8b 00                	mov    (%eax),%eax
  80040c:	83 e8 08             	sub    $0x8,%eax
  80040f:	8b 50 04             	mov    0x4(%eax),%edx
  800412:	8b 00                	mov    (%eax),%eax
  800414:	eb 40                	jmp    800456 <getuint+0x65>
	else if (lflag)
  800416:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80041a:	74 1e                	je     80043a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80041c:	8b 45 08             	mov    0x8(%ebp),%eax
  80041f:	8b 00                	mov    (%eax),%eax
  800421:	8d 50 04             	lea    0x4(%eax),%edx
  800424:	8b 45 08             	mov    0x8(%ebp),%eax
  800427:	89 10                	mov    %edx,(%eax)
  800429:	8b 45 08             	mov    0x8(%ebp),%eax
  80042c:	8b 00                	mov    (%eax),%eax
  80042e:	83 e8 04             	sub    $0x4,%eax
  800431:	8b 00                	mov    (%eax),%eax
  800433:	ba 00 00 00 00       	mov    $0x0,%edx
  800438:	eb 1c                	jmp    800456 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80043a:	8b 45 08             	mov    0x8(%ebp),%eax
  80043d:	8b 00                	mov    (%eax),%eax
  80043f:	8d 50 04             	lea    0x4(%eax),%edx
  800442:	8b 45 08             	mov    0x8(%ebp),%eax
  800445:	89 10                	mov    %edx,(%eax)
  800447:	8b 45 08             	mov    0x8(%ebp),%eax
  80044a:	8b 00                	mov    (%eax),%eax
  80044c:	83 e8 04             	sub    $0x4,%eax
  80044f:	8b 00                	mov    (%eax),%eax
  800451:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800456:	5d                   	pop    %ebp
  800457:	c3                   	ret    

00800458 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800458:	55                   	push   %ebp
  800459:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80045b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80045f:	7e 1c                	jle    80047d <getint+0x25>
		return va_arg(*ap, long long);
  800461:	8b 45 08             	mov    0x8(%ebp),%eax
  800464:	8b 00                	mov    (%eax),%eax
  800466:	8d 50 08             	lea    0x8(%eax),%edx
  800469:	8b 45 08             	mov    0x8(%ebp),%eax
  80046c:	89 10                	mov    %edx,(%eax)
  80046e:	8b 45 08             	mov    0x8(%ebp),%eax
  800471:	8b 00                	mov    (%eax),%eax
  800473:	83 e8 08             	sub    $0x8,%eax
  800476:	8b 50 04             	mov    0x4(%eax),%edx
  800479:	8b 00                	mov    (%eax),%eax
  80047b:	eb 38                	jmp    8004b5 <getint+0x5d>
	else if (lflag)
  80047d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800481:	74 1a                	je     80049d <getint+0x45>
		return va_arg(*ap, long);
  800483:	8b 45 08             	mov    0x8(%ebp),%eax
  800486:	8b 00                	mov    (%eax),%eax
  800488:	8d 50 04             	lea    0x4(%eax),%edx
  80048b:	8b 45 08             	mov    0x8(%ebp),%eax
  80048e:	89 10                	mov    %edx,(%eax)
  800490:	8b 45 08             	mov    0x8(%ebp),%eax
  800493:	8b 00                	mov    (%eax),%eax
  800495:	83 e8 04             	sub    $0x4,%eax
  800498:	8b 00                	mov    (%eax),%eax
  80049a:	99                   	cltd   
  80049b:	eb 18                	jmp    8004b5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80049d:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a0:	8b 00                	mov    (%eax),%eax
  8004a2:	8d 50 04             	lea    0x4(%eax),%edx
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	89 10                	mov    %edx,(%eax)
  8004aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ad:	8b 00                	mov    (%eax),%eax
  8004af:	83 e8 04             	sub    $0x4,%eax
  8004b2:	8b 00                	mov    (%eax),%eax
  8004b4:	99                   	cltd   
}
  8004b5:	5d                   	pop    %ebp
  8004b6:	c3                   	ret    

008004b7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004b7:	55                   	push   %ebp
  8004b8:	89 e5                	mov    %esp,%ebp
  8004ba:	56                   	push   %esi
  8004bb:	53                   	push   %ebx
  8004bc:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004bf:	eb 17                	jmp    8004d8 <vprintfmt+0x21>
			if (ch == '\0')
  8004c1:	85 db                	test   %ebx,%ebx
  8004c3:	0f 84 af 03 00 00    	je     800878 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8004c9:	83 ec 08             	sub    $0x8,%esp
  8004cc:	ff 75 0c             	pushl  0xc(%ebp)
  8004cf:	53                   	push   %ebx
  8004d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d3:	ff d0                	call   *%eax
  8004d5:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8004db:	8d 50 01             	lea    0x1(%eax),%edx
  8004de:	89 55 10             	mov    %edx,0x10(%ebp)
  8004e1:	8a 00                	mov    (%eax),%al
  8004e3:	0f b6 d8             	movzbl %al,%ebx
  8004e6:	83 fb 25             	cmp    $0x25,%ebx
  8004e9:	75 d6                	jne    8004c1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004eb:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004ef:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8004f6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004fd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800504:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80050b:	8b 45 10             	mov    0x10(%ebp),%eax
  80050e:	8d 50 01             	lea    0x1(%eax),%edx
  800511:	89 55 10             	mov    %edx,0x10(%ebp)
  800514:	8a 00                	mov    (%eax),%al
  800516:	0f b6 d8             	movzbl %al,%ebx
  800519:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80051c:	83 f8 55             	cmp    $0x55,%eax
  80051f:	0f 87 2b 03 00 00    	ja     800850 <vprintfmt+0x399>
  800525:	8b 04 85 f8 20 80 00 	mov    0x8020f8(,%eax,4),%eax
  80052c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80052e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800532:	eb d7                	jmp    80050b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800534:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800538:	eb d1                	jmp    80050b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80053a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800541:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800544:	89 d0                	mov    %edx,%eax
  800546:	c1 e0 02             	shl    $0x2,%eax
  800549:	01 d0                	add    %edx,%eax
  80054b:	01 c0                	add    %eax,%eax
  80054d:	01 d8                	add    %ebx,%eax
  80054f:	83 e8 30             	sub    $0x30,%eax
  800552:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800555:	8b 45 10             	mov    0x10(%ebp),%eax
  800558:	8a 00                	mov    (%eax),%al
  80055a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80055d:	83 fb 2f             	cmp    $0x2f,%ebx
  800560:	7e 3e                	jle    8005a0 <vprintfmt+0xe9>
  800562:	83 fb 39             	cmp    $0x39,%ebx
  800565:	7f 39                	jg     8005a0 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800567:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80056a:	eb d5                	jmp    800541 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80056c:	8b 45 14             	mov    0x14(%ebp),%eax
  80056f:	83 c0 04             	add    $0x4,%eax
  800572:	89 45 14             	mov    %eax,0x14(%ebp)
  800575:	8b 45 14             	mov    0x14(%ebp),%eax
  800578:	83 e8 04             	sub    $0x4,%eax
  80057b:	8b 00                	mov    (%eax),%eax
  80057d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800580:	eb 1f                	jmp    8005a1 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800582:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800586:	79 83                	jns    80050b <vprintfmt+0x54>
				width = 0;
  800588:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80058f:	e9 77 ff ff ff       	jmp    80050b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800594:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80059b:	e9 6b ff ff ff       	jmp    80050b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005a0:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005a5:	0f 89 60 ff ff ff    	jns    80050b <vprintfmt+0x54>
				width = precision, precision = -1;
  8005ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005b1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005b8:	e9 4e ff ff ff       	jmp    80050b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005bd:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005c0:	e9 46 ff ff ff       	jmp    80050b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c8:	83 c0 04             	add    $0x4,%eax
  8005cb:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d1:	83 e8 04             	sub    $0x4,%eax
  8005d4:	8b 00                	mov    (%eax),%eax
  8005d6:	83 ec 08             	sub    $0x8,%esp
  8005d9:	ff 75 0c             	pushl  0xc(%ebp)
  8005dc:	50                   	push   %eax
  8005dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e0:	ff d0                	call   *%eax
  8005e2:	83 c4 10             	add    $0x10,%esp
			break;
  8005e5:	e9 89 02 00 00       	jmp    800873 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ed:	83 c0 04             	add    $0x4,%eax
  8005f0:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f6:	83 e8 04             	sub    $0x4,%eax
  8005f9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8005fb:	85 db                	test   %ebx,%ebx
  8005fd:	79 02                	jns    800601 <vprintfmt+0x14a>
				err = -err;
  8005ff:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800601:	83 fb 64             	cmp    $0x64,%ebx
  800604:	7f 0b                	jg     800611 <vprintfmt+0x15a>
  800606:	8b 34 9d 40 1f 80 00 	mov    0x801f40(,%ebx,4),%esi
  80060d:	85 f6                	test   %esi,%esi
  80060f:	75 19                	jne    80062a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800611:	53                   	push   %ebx
  800612:	68 e5 20 80 00       	push   $0x8020e5
  800617:	ff 75 0c             	pushl  0xc(%ebp)
  80061a:	ff 75 08             	pushl  0x8(%ebp)
  80061d:	e8 5e 02 00 00       	call   800880 <printfmt>
  800622:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800625:	e9 49 02 00 00       	jmp    800873 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80062a:	56                   	push   %esi
  80062b:	68 ee 20 80 00       	push   $0x8020ee
  800630:	ff 75 0c             	pushl  0xc(%ebp)
  800633:	ff 75 08             	pushl  0x8(%ebp)
  800636:	e8 45 02 00 00       	call   800880 <printfmt>
  80063b:	83 c4 10             	add    $0x10,%esp
			break;
  80063e:	e9 30 02 00 00       	jmp    800873 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800643:	8b 45 14             	mov    0x14(%ebp),%eax
  800646:	83 c0 04             	add    $0x4,%eax
  800649:	89 45 14             	mov    %eax,0x14(%ebp)
  80064c:	8b 45 14             	mov    0x14(%ebp),%eax
  80064f:	83 e8 04             	sub    $0x4,%eax
  800652:	8b 30                	mov    (%eax),%esi
  800654:	85 f6                	test   %esi,%esi
  800656:	75 05                	jne    80065d <vprintfmt+0x1a6>
				p = "(null)";
  800658:	be f1 20 80 00       	mov    $0x8020f1,%esi
			if (width > 0 && padc != '-')
  80065d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800661:	7e 6d                	jle    8006d0 <vprintfmt+0x219>
  800663:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800667:	74 67                	je     8006d0 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800669:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80066c:	83 ec 08             	sub    $0x8,%esp
  80066f:	50                   	push   %eax
  800670:	56                   	push   %esi
  800671:	e8 12 05 00 00       	call   800b88 <strnlen>
  800676:	83 c4 10             	add    $0x10,%esp
  800679:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80067c:	eb 16                	jmp    800694 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80067e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800682:	83 ec 08             	sub    $0x8,%esp
  800685:	ff 75 0c             	pushl  0xc(%ebp)
  800688:	50                   	push   %eax
  800689:	8b 45 08             	mov    0x8(%ebp),%eax
  80068c:	ff d0                	call   *%eax
  80068e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800691:	ff 4d e4             	decl   -0x1c(%ebp)
  800694:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800698:	7f e4                	jg     80067e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80069a:	eb 34                	jmp    8006d0 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80069c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006a0:	74 1c                	je     8006be <vprintfmt+0x207>
  8006a2:	83 fb 1f             	cmp    $0x1f,%ebx
  8006a5:	7e 05                	jle    8006ac <vprintfmt+0x1f5>
  8006a7:	83 fb 7e             	cmp    $0x7e,%ebx
  8006aa:	7e 12                	jle    8006be <vprintfmt+0x207>
					putch('?', putdat);
  8006ac:	83 ec 08             	sub    $0x8,%esp
  8006af:	ff 75 0c             	pushl  0xc(%ebp)
  8006b2:	6a 3f                	push   $0x3f
  8006b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b7:	ff d0                	call   *%eax
  8006b9:	83 c4 10             	add    $0x10,%esp
  8006bc:	eb 0f                	jmp    8006cd <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006be:	83 ec 08             	sub    $0x8,%esp
  8006c1:	ff 75 0c             	pushl  0xc(%ebp)
  8006c4:	53                   	push   %ebx
  8006c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c8:	ff d0                	call   *%eax
  8006ca:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006cd:	ff 4d e4             	decl   -0x1c(%ebp)
  8006d0:	89 f0                	mov    %esi,%eax
  8006d2:	8d 70 01             	lea    0x1(%eax),%esi
  8006d5:	8a 00                	mov    (%eax),%al
  8006d7:	0f be d8             	movsbl %al,%ebx
  8006da:	85 db                	test   %ebx,%ebx
  8006dc:	74 24                	je     800702 <vprintfmt+0x24b>
  8006de:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006e2:	78 b8                	js     80069c <vprintfmt+0x1e5>
  8006e4:	ff 4d e0             	decl   -0x20(%ebp)
  8006e7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006eb:	79 af                	jns    80069c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006ed:	eb 13                	jmp    800702 <vprintfmt+0x24b>
				putch(' ', putdat);
  8006ef:	83 ec 08             	sub    $0x8,%esp
  8006f2:	ff 75 0c             	pushl  0xc(%ebp)
  8006f5:	6a 20                	push   $0x20
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	ff d0                	call   *%eax
  8006fc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006ff:	ff 4d e4             	decl   -0x1c(%ebp)
  800702:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800706:	7f e7                	jg     8006ef <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800708:	e9 66 01 00 00       	jmp    800873 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80070d:	83 ec 08             	sub    $0x8,%esp
  800710:	ff 75 e8             	pushl  -0x18(%ebp)
  800713:	8d 45 14             	lea    0x14(%ebp),%eax
  800716:	50                   	push   %eax
  800717:	e8 3c fd ff ff       	call   800458 <getint>
  80071c:	83 c4 10             	add    $0x10,%esp
  80071f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800722:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800725:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800728:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80072b:	85 d2                	test   %edx,%edx
  80072d:	79 23                	jns    800752 <vprintfmt+0x29b>
				putch('-', putdat);
  80072f:	83 ec 08             	sub    $0x8,%esp
  800732:	ff 75 0c             	pushl  0xc(%ebp)
  800735:	6a 2d                	push   $0x2d
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	ff d0                	call   *%eax
  80073c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80073f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800742:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800745:	f7 d8                	neg    %eax
  800747:	83 d2 00             	adc    $0x0,%edx
  80074a:	f7 da                	neg    %edx
  80074c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80074f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800752:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800759:	e9 bc 00 00 00       	jmp    80081a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80075e:	83 ec 08             	sub    $0x8,%esp
  800761:	ff 75 e8             	pushl  -0x18(%ebp)
  800764:	8d 45 14             	lea    0x14(%ebp),%eax
  800767:	50                   	push   %eax
  800768:	e8 84 fc ff ff       	call   8003f1 <getuint>
  80076d:	83 c4 10             	add    $0x10,%esp
  800770:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800773:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800776:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80077d:	e9 98 00 00 00       	jmp    80081a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800782:	83 ec 08             	sub    $0x8,%esp
  800785:	ff 75 0c             	pushl  0xc(%ebp)
  800788:	6a 58                	push   $0x58
  80078a:	8b 45 08             	mov    0x8(%ebp),%eax
  80078d:	ff d0                	call   *%eax
  80078f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800792:	83 ec 08             	sub    $0x8,%esp
  800795:	ff 75 0c             	pushl  0xc(%ebp)
  800798:	6a 58                	push   $0x58
  80079a:	8b 45 08             	mov    0x8(%ebp),%eax
  80079d:	ff d0                	call   *%eax
  80079f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007a2:	83 ec 08             	sub    $0x8,%esp
  8007a5:	ff 75 0c             	pushl  0xc(%ebp)
  8007a8:	6a 58                	push   $0x58
  8007aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ad:	ff d0                	call   *%eax
  8007af:	83 c4 10             	add    $0x10,%esp
			break;
  8007b2:	e9 bc 00 00 00       	jmp    800873 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8007b7:	83 ec 08             	sub    $0x8,%esp
  8007ba:	ff 75 0c             	pushl  0xc(%ebp)
  8007bd:	6a 30                	push   $0x30
  8007bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c2:	ff d0                	call   *%eax
  8007c4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007c7:	83 ec 08             	sub    $0x8,%esp
  8007ca:	ff 75 0c             	pushl  0xc(%ebp)
  8007cd:	6a 78                	push   $0x78
  8007cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d2:	ff d0                	call   *%eax
  8007d4:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007da:	83 c0 04             	add    $0x4,%eax
  8007dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e3:	83 e8 04             	sub    $0x4,%eax
  8007e6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8007f2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8007f9:	eb 1f                	jmp    80081a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007fb:	83 ec 08             	sub    $0x8,%esp
  8007fe:	ff 75 e8             	pushl  -0x18(%ebp)
  800801:	8d 45 14             	lea    0x14(%ebp),%eax
  800804:	50                   	push   %eax
  800805:	e8 e7 fb ff ff       	call   8003f1 <getuint>
  80080a:	83 c4 10             	add    $0x10,%esp
  80080d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800810:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800813:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80081a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80081e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800821:	83 ec 04             	sub    $0x4,%esp
  800824:	52                   	push   %edx
  800825:	ff 75 e4             	pushl  -0x1c(%ebp)
  800828:	50                   	push   %eax
  800829:	ff 75 f4             	pushl  -0xc(%ebp)
  80082c:	ff 75 f0             	pushl  -0x10(%ebp)
  80082f:	ff 75 0c             	pushl  0xc(%ebp)
  800832:	ff 75 08             	pushl  0x8(%ebp)
  800835:	e8 00 fb ff ff       	call   80033a <printnum>
  80083a:	83 c4 20             	add    $0x20,%esp
			break;
  80083d:	eb 34                	jmp    800873 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80083f:	83 ec 08             	sub    $0x8,%esp
  800842:	ff 75 0c             	pushl  0xc(%ebp)
  800845:	53                   	push   %ebx
  800846:	8b 45 08             	mov    0x8(%ebp),%eax
  800849:	ff d0                	call   *%eax
  80084b:	83 c4 10             	add    $0x10,%esp
			break;
  80084e:	eb 23                	jmp    800873 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800850:	83 ec 08             	sub    $0x8,%esp
  800853:	ff 75 0c             	pushl  0xc(%ebp)
  800856:	6a 25                	push   $0x25
  800858:	8b 45 08             	mov    0x8(%ebp),%eax
  80085b:	ff d0                	call   *%eax
  80085d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800860:	ff 4d 10             	decl   0x10(%ebp)
  800863:	eb 03                	jmp    800868 <vprintfmt+0x3b1>
  800865:	ff 4d 10             	decl   0x10(%ebp)
  800868:	8b 45 10             	mov    0x10(%ebp),%eax
  80086b:	48                   	dec    %eax
  80086c:	8a 00                	mov    (%eax),%al
  80086e:	3c 25                	cmp    $0x25,%al
  800870:	75 f3                	jne    800865 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800872:	90                   	nop
		}
	}
  800873:	e9 47 fc ff ff       	jmp    8004bf <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800878:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800879:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80087c:	5b                   	pop    %ebx
  80087d:	5e                   	pop    %esi
  80087e:	5d                   	pop    %ebp
  80087f:	c3                   	ret    

00800880 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800880:	55                   	push   %ebp
  800881:	89 e5                	mov    %esp,%ebp
  800883:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800886:	8d 45 10             	lea    0x10(%ebp),%eax
  800889:	83 c0 04             	add    $0x4,%eax
  80088c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80088f:	8b 45 10             	mov    0x10(%ebp),%eax
  800892:	ff 75 f4             	pushl  -0xc(%ebp)
  800895:	50                   	push   %eax
  800896:	ff 75 0c             	pushl  0xc(%ebp)
  800899:	ff 75 08             	pushl  0x8(%ebp)
  80089c:	e8 16 fc ff ff       	call   8004b7 <vprintfmt>
  8008a1:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008a4:	90                   	nop
  8008a5:	c9                   	leave  
  8008a6:	c3                   	ret    

008008a7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008a7:	55                   	push   %ebp
  8008a8:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ad:	8b 40 08             	mov    0x8(%eax),%eax
  8008b0:	8d 50 01             	lea    0x1(%eax),%edx
  8008b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008bc:	8b 10                	mov    (%eax),%edx
  8008be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c1:	8b 40 04             	mov    0x4(%eax),%eax
  8008c4:	39 c2                	cmp    %eax,%edx
  8008c6:	73 12                	jae    8008da <sprintputch+0x33>
		*b->buf++ = ch;
  8008c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008cb:	8b 00                	mov    (%eax),%eax
  8008cd:	8d 48 01             	lea    0x1(%eax),%ecx
  8008d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d3:	89 0a                	mov    %ecx,(%edx)
  8008d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8008d8:	88 10                	mov    %dl,(%eax)
}
  8008da:	90                   	nop
  8008db:	5d                   	pop    %ebp
  8008dc:	c3                   	ret    

008008dd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ec:	8d 50 ff             	lea    -0x1(%eax),%edx
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	01 d0                	add    %edx,%eax
  8008f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800902:	74 06                	je     80090a <vsnprintf+0x2d>
  800904:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800908:	7f 07                	jg     800911 <vsnprintf+0x34>
		return -E_INVAL;
  80090a:	b8 03 00 00 00       	mov    $0x3,%eax
  80090f:	eb 20                	jmp    800931 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800911:	ff 75 14             	pushl  0x14(%ebp)
  800914:	ff 75 10             	pushl  0x10(%ebp)
  800917:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80091a:	50                   	push   %eax
  80091b:	68 a7 08 80 00       	push   $0x8008a7
  800920:	e8 92 fb ff ff       	call   8004b7 <vprintfmt>
  800925:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800928:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80092b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80092e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800931:	c9                   	leave  
  800932:	c3                   	ret    

00800933 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800933:	55                   	push   %ebp
  800934:	89 e5                	mov    %esp,%ebp
  800936:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800939:	8d 45 10             	lea    0x10(%ebp),%eax
  80093c:	83 c0 04             	add    $0x4,%eax
  80093f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800942:	8b 45 10             	mov    0x10(%ebp),%eax
  800945:	ff 75 f4             	pushl  -0xc(%ebp)
  800948:	50                   	push   %eax
  800949:	ff 75 0c             	pushl  0xc(%ebp)
  80094c:	ff 75 08             	pushl  0x8(%ebp)
  80094f:	e8 89 ff ff ff       	call   8008dd <vsnprintf>
  800954:	83 c4 10             	add    $0x10,%esp
  800957:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80095a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80095d:	c9                   	leave  
  80095e:	c3                   	ret    

0080095f <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80095f:	55                   	push   %ebp
  800960:	89 e5                	mov    %esp,%ebp
  800962:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  800965:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800969:	74 13                	je     80097e <readline+0x1f>
		cprintf("%s", prompt);
  80096b:	83 ec 08             	sub    $0x8,%esp
  80096e:	ff 75 08             	pushl  0x8(%ebp)
  800971:	68 50 22 80 00       	push   $0x802250
  800976:	e8 62 f9 ff ff       	call   8002dd <cprintf>
  80097b:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80097e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800985:	83 ec 0c             	sub    $0xc,%esp
  800988:	6a 00                	push   $0x0
  80098a:	e8 66 11 00 00       	call   801af5 <iscons>
  80098f:	83 c4 10             	add    $0x10,%esp
  800992:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800995:	e8 0d 11 00 00       	call   801aa7 <getchar>
  80099a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80099d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009a1:	79 22                	jns    8009c5 <readline+0x66>
			if (c != -E_EOF)
  8009a3:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8009a7:	0f 84 ad 00 00 00    	je     800a5a <readline+0xfb>
				cprintf("read error: %e\n", c);
  8009ad:	83 ec 08             	sub    $0x8,%esp
  8009b0:	ff 75 ec             	pushl  -0x14(%ebp)
  8009b3:	68 53 22 80 00       	push   $0x802253
  8009b8:	e8 20 f9 ff ff       	call   8002dd <cprintf>
  8009bd:	83 c4 10             	add    $0x10,%esp
			return;
  8009c0:	e9 95 00 00 00       	jmp    800a5a <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8009c5:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8009c9:	7e 34                	jle    8009ff <readline+0xa0>
  8009cb:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8009d2:	7f 2b                	jg     8009ff <readline+0xa0>
			if (echoing)
  8009d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8009d8:	74 0e                	je     8009e8 <readline+0x89>
				cputchar(c);
  8009da:	83 ec 0c             	sub    $0xc,%esp
  8009dd:	ff 75 ec             	pushl  -0x14(%ebp)
  8009e0:	e8 7a 10 00 00       	call   801a5f <cputchar>
  8009e5:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8009e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009eb:	8d 50 01             	lea    0x1(%eax),%edx
  8009ee:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8009f1:	89 c2                	mov    %eax,%edx
  8009f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f6:	01 d0                	add    %edx,%eax
  8009f8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8009fb:	88 10                	mov    %dl,(%eax)
  8009fd:	eb 56                	jmp    800a55 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8009ff:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800a03:	75 1f                	jne    800a24 <readline+0xc5>
  800a05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a09:	7e 19                	jle    800a24 <readline+0xc5>
			if (echoing)
  800a0b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a0f:	74 0e                	je     800a1f <readline+0xc0>
				cputchar(c);
  800a11:	83 ec 0c             	sub    $0xc,%esp
  800a14:	ff 75 ec             	pushl  -0x14(%ebp)
  800a17:	e8 43 10 00 00       	call   801a5f <cputchar>
  800a1c:	83 c4 10             	add    $0x10,%esp

			i--;
  800a1f:	ff 4d f4             	decl   -0xc(%ebp)
  800a22:	eb 31                	jmp    800a55 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800a24:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800a28:	74 0a                	je     800a34 <readline+0xd5>
  800a2a:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800a2e:	0f 85 61 ff ff ff    	jne    800995 <readline+0x36>
			if (echoing)
  800a34:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a38:	74 0e                	je     800a48 <readline+0xe9>
				cputchar(c);
  800a3a:	83 ec 0c             	sub    $0xc,%esp
  800a3d:	ff 75 ec             	pushl  -0x14(%ebp)
  800a40:	e8 1a 10 00 00       	call   801a5f <cputchar>
  800a45:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800a48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4e:	01 d0                	add    %edx,%eax
  800a50:	c6 00 00             	movb   $0x0,(%eax)
			return;
  800a53:	eb 06                	jmp    800a5b <readline+0xfc>
		}
	}
  800a55:	e9 3b ff ff ff       	jmp    800995 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  800a5a:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  800a5b:	c9                   	leave  
  800a5c:	c3                   	ret    

00800a5d <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800a5d:	55                   	push   %ebp
  800a5e:	89 e5                	mov    %esp,%ebp
  800a60:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a63:	e8 f9 09 00 00       	call   801461 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  800a68:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a6c:	74 13                	je     800a81 <atomic_readline+0x24>
		cprintf("%s", prompt);
  800a6e:	83 ec 08             	sub    $0x8,%esp
  800a71:	ff 75 08             	pushl  0x8(%ebp)
  800a74:	68 50 22 80 00       	push   $0x802250
  800a79:	e8 5f f8 ff ff       	call   8002dd <cprintf>
  800a7e:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a88:	83 ec 0c             	sub    $0xc,%esp
  800a8b:	6a 00                	push   $0x0
  800a8d:	e8 63 10 00 00       	call   801af5 <iscons>
  800a92:	83 c4 10             	add    $0x10,%esp
  800a95:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800a98:	e8 0a 10 00 00       	call   801aa7 <getchar>
  800a9d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800aa0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800aa4:	79 23                	jns    800ac9 <atomic_readline+0x6c>
			if (c != -E_EOF)
  800aa6:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800aaa:	74 13                	je     800abf <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  800aac:	83 ec 08             	sub    $0x8,%esp
  800aaf:	ff 75 ec             	pushl  -0x14(%ebp)
  800ab2:	68 53 22 80 00       	push   $0x802253
  800ab7:	e8 21 f8 ff ff       	call   8002dd <cprintf>
  800abc:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800abf:	e8 b7 09 00 00       	call   80147b <sys_enable_interrupt>
			return;
  800ac4:	e9 9a 00 00 00       	jmp    800b63 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800ac9:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800acd:	7e 34                	jle    800b03 <atomic_readline+0xa6>
  800acf:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800ad6:	7f 2b                	jg     800b03 <atomic_readline+0xa6>
			if (echoing)
  800ad8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800adc:	74 0e                	je     800aec <atomic_readline+0x8f>
				cputchar(c);
  800ade:	83 ec 0c             	sub    $0xc,%esp
  800ae1:	ff 75 ec             	pushl  -0x14(%ebp)
  800ae4:	e8 76 0f 00 00       	call   801a5f <cputchar>
  800ae9:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800aef:	8d 50 01             	lea    0x1(%eax),%edx
  800af2:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800af5:	89 c2                	mov    %eax,%edx
  800af7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afa:	01 d0                	add    %edx,%eax
  800afc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800aff:	88 10                	mov    %dl,(%eax)
  800b01:	eb 5b                	jmp    800b5e <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  800b03:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800b07:	75 1f                	jne    800b28 <atomic_readline+0xcb>
  800b09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b0d:	7e 19                	jle    800b28 <atomic_readline+0xcb>
			if (echoing)
  800b0f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b13:	74 0e                	je     800b23 <atomic_readline+0xc6>
				cputchar(c);
  800b15:	83 ec 0c             	sub    $0xc,%esp
  800b18:	ff 75 ec             	pushl  -0x14(%ebp)
  800b1b:	e8 3f 0f 00 00       	call   801a5f <cputchar>
  800b20:	83 c4 10             	add    $0x10,%esp
			i--;
  800b23:	ff 4d f4             	decl   -0xc(%ebp)
  800b26:	eb 36                	jmp    800b5e <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  800b28:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b2c:	74 0a                	je     800b38 <atomic_readline+0xdb>
  800b2e:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b32:	0f 85 60 ff ff ff    	jne    800a98 <atomic_readline+0x3b>
			if (echoing)
  800b38:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b3c:	74 0e                	je     800b4c <atomic_readline+0xef>
				cputchar(c);
  800b3e:	83 ec 0c             	sub    $0xc,%esp
  800b41:	ff 75 ec             	pushl  -0x14(%ebp)
  800b44:	e8 16 0f 00 00       	call   801a5f <cputchar>
  800b49:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  800b4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b52:	01 d0                	add    %edx,%eax
  800b54:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  800b57:	e8 1f 09 00 00       	call   80147b <sys_enable_interrupt>
			return;
  800b5c:	eb 05                	jmp    800b63 <atomic_readline+0x106>
		}
	}
  800b5e:	e9 35 ff ff ff       	jmp    800a98 <atomic_readline+0x3b>
}
  800b63:	c9                   	leave  
  800b64:	c3                   	ret    

00800b65 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b6b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b72:	eb 06                	jmp    800b7a <strlen+0x15>
		n++;
  800b74:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b77:	ff 45 08             	incl   0x8(%ebp)
  800b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7d:	8a 00                	mov    (%eax),%al
  800b7f:	84 c0                	test   %al,%al
  800b81:	75 f1                	jne    800b74 <strlen+0xf>
		n++;
	return n;
  800b83:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b86:	c9                   	leave  
  800b87:	c3                   	ret    

00800b88 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b88:	55                   	push   %ebp
  800b89:	89 e5                	mov    %esp,%ebp
  800b8b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b95:	eb 09                	jmp    800ba0 <strnlen+0x18>
		n++;
  800b97:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b9a:	ff 45 08             	incl   0x8(%ebp)
  800b9d:	ff 4d 0c             	decl   0xc(%ebp)
  800ba0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ba4:	74 09                	je     800baf <strnlen+0x27>
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba9:	8a 00                	mov    (%eax),%al
  800bab:	84 c0                	test   %al,%al
  800bad:	75 e8                	jne    800b97 <strnlen+0xf>
		n++;
	return n;
  800baf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bb2:	c9                   	leave  
  800bb3:	c3                   	ret    

00800bb4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bc0:	90                   	nop
  800bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc4:	8d 50 01             	lea    0x1(%eax),%edx
  800bc7:	89 55 08             	mov    %edx,0x8(%ebp)
  800bca:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bcd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bd0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bd3:	8a 12                	mov    (%edx),%dl
  800bd5:	88 10                	mov    %dl,(%eax)
  800bd7:	8a 00                	mov    (%eax),%al
  800bd9:	84 c0                	test   %al,%al
  800bdb:	75 e4                	jne    800bc1 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800bdd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800be0:	c9                   	leave  
  800be1:	c3                   	ret    

00800be2 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800be2:	55                   	push   %ebp
  800be3:	89 e5                	mov    %esp,%ebp
  800be5:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800be8:	8b 45 08             	mov    0x8(%ebp),%eax
  800beb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800bee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf5:	eb 1f                	jmp    800c16 <strncpy+0x34>
		*dst++ = *src;
  800bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfa:	8d 50 01             	lea    0x1(%eax),%edx
  800bfd:	89 55 08             	mov    %edx,0x8(%ebp)
  800c00:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c03:	8a 12                	mov    (%edx),%dl
  800c05:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0a:	8a 00                	mov    (%eax),%al
  800c0c:	84 c0                	test   %al,%al
  800c0e:	74 03                	je     800c13 <strncpy+0x31>
			src++;
  800c10:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c13:	ff 45 fc             	incl   -0x4(%ebp)
  800c16:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c19:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c1c:	72 d9                	jb     800bf7 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c21:	c9                   	leave  
  800c22:	c3                   	ret    

00800c23 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c23:	55                   	push   %ebp
  800c24:	89 e5                	mov    %esp,%ebp
  800c26:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c29:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c2f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c33:	74 30                	je     800c65 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c35:	eb 16                	jmp    800c4d <strlcpy+0x2a>
			*dst++ = *src++;
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	8d 50 01             	lea    0x1(%eax),%edx
  800c3d:	89 55 08             	mov    %edx,0x8(%ebp)
  800c40:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c43:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c46:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c49:	8a 12                	mov    (%edx),%dl
  800c4b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c4d:	ff 4d 10             	decl   0x10(%ebp)
  800c50:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c54:	74 09                	je     800c5f <strlcpy+0x3c>
  800c56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c59:	8a 00                	mov    (%eax),%al
  800c5b:	84 c0                	test   %al,%al
  800c5d:	75 d8                	jne    800c37 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c62:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c65:	8b 55 08             	mov    0x8(%ebp),%edx
  800c68:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c6b:	29 c2                	sub    %eax,%edx
  800c6d:	89 d0                	mov    %edx,%eax
}
  800c6f:	c9                   	leave  
  800c70:	c3                   	ret    

00800c71 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c71:	55                   	push   %ebp
  800c72:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c74:	eb 06                	jmp    800c7c <strcmp+0xb>
		p++, q++;
  800c76:	ff 45 08             	incl   0x8(%ebp)
  800c79:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	8a 00                	mov    (%eax),%al
  800c81:	84 c0                	test   %al,%al
  800c83:	74 0e                	je     800c93 <strcmp+0x22>
  800c85:	8b 45 08             	mov    0x8(%ebp),%eax
  800c88:	8a 10                	mov    (%eax),%dl
  800c8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8d:	8a 00                	mov    (%eax),%al
  800c8f:	38 c2                	cmp    %al,%dl
  800c91:	74 e3                	je     800c76 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c93:	8b 45 08             	mov    0x8(%ebp),%eax
  800c96:	8a 00                	mov    (%eax),%al
  800c98:	0f b6 d0             	movzbl %al,%edx
  800c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9e:	8a 00                	mov    (%eax),%al
  800ca0:	0f b6 c0             	movzbl %al,%eax
  800ca3:	29 c2                	sub    %eax,%edx
  800ca5:	89 d0                	mov    %edx,%eax
}
  800ca7:	5d                   	pop    %ebp
  800ca8:	c3                   	ret    

00800ca9 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cac:	eb 09                	jmp    800cb7 <strncmp+0xe>
		n--, p++, q++;
  800cae:	ff 4d 10             	decl   0x10(%ebp)
  800cb1:	ff 45 08             	incl   0x8(%ebp)
  800cb4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cb7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cbb:	74 17                	je     800cd4 <strncmp+0x2b>
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	8a 00                	mov    (%eax),%al
  800cc2:	84 c0                	test   %al,%al
  800cc4:	74 0e                	je     800cd4 <strncmp+0x2b>
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	8a 10                	mov    (%eax),%dl
  800ccb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cce:	8a 00                	mov    (%eax),%al
  800cd0:	38 c2                	cmp    %al,%dl
  800cd2:	74 da                	je     800cae <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800cd4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd8:	75 07                	jne    800ce1 <strncmp+0x38>
		return 0;
  800cda:	b8 00 00 00 00       	mov    $0x0,%eax
  800cdf:	eb 14                	jmp    800cf5 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce4:	8a 00                	mov    (%eax),%al
  800ce6:	0f b6 d0             	movzbl %al,%edx
  800ce9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cec:	8a 00                	mov    (%eax),%al
  800cee:	0f b6 c0             	movzbl %al,%eax
  800cf1:	29 c2                	sub    %eax,%edx
  800cf3:	89 d0                	mov    %edx,%eax
}
  800cf5:	5d                   	pop    %ebp
  800cf6:	c3                   	ret    

00800cf7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cf7:	55                   	push   %ebp
  800cf8:	89 e5                	mov    %esp,%ebp
  800cfa:	83 ec 04             	sub    $0x4,%esp
  800cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d00:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d03:	eb 12                	jmp    800d17 <strchr+0x20>
		if (*s == c)
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	8a 00                	mov    (%eax),%al
  800d0a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d0d:	75 05                	jne    800d14 <strchr+0x1d>
			return (char *) s;
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	eb 11                	jmp    800d25 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d14:	ff 45 08             	incl   0x8(%ebp)
  800d17:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1a:	8a 00                	mov    (%eax),%al
  800d1c:	84 c0                	test   %al,%al
  800d1e:	75 e5                	jne    800d05 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d25:	c9                   	leave  
  800d26:	c3                   	ret    

00800d27 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	83 ec 04             	sub    $0x4,%esp
  800d2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d30:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d33:	eb 0d                	jmp    800d42 <strfind+0x1b>
		if (*s == c)
  800d35:	8b 45 08             	mov    0x8(%ebp),%eax
  800d38:	8a 00                	mov    (%eax),%al
  800d3a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d3d:	74 0e                	je     800d4d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d3f:	ff 45 08             	incl   0x8(%ebp)
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	84 c0                	test   %al,%al
  800d49:	75 ea                	jne    800d35 <strfind+0xe>
  800d4b:	eb 01                	jmp    800d4e <strfind+0x27>
		if (*s == c)
			break;
  800d4d:	90                   	nop
	return (char *) s;
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d51:	c9                   	leave  
  800d52:	c3                   	ret    

00800d53 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d62:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d65:	eb 0e                	jmp    800d75 <memset+0x22>
		*p++ = c;
  800d67:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d6a:	8d 50 01             	lea    0x1(%eax),%edx
  800d6d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d70:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d73:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d75:	ff 4d f8             	decl   -0x8(%ebp)
  800d78:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d7c:	79 e9                	jns    800d67 <memset+0x14>
		*p++ = c;

	return v;
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d81:	c9                   	leave  
  800d82:	c3                   	ret    

00800d83 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d83:	55                   	push   %ebp
  800d84:	89 e5                	mov    %esp,%ebp
  800d86:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d92:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d95:	eb 16                	jmp    800dad <memcpy+0x2a>
		*d++ = *s++;
  800d97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d9a:	8d 50 01             	lea    0x1(%eax),%edx
  800d9d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800da0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800da3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800da6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800da9:	8a 12                	mov    (%edx),%dl
  800dab:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dad:	8b 45 10             	mov    0x10(%ebp),%eax
  800db0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800db3:	89 55 10             	mov    %edx,0x10(%ebp)
  800db6:	85 c0                	test   %eax,%eax
  800db8:	75 dd                	jne    800d97 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dbd:	c9                   	leave  
  800dbe:	c3                   	ret    

00800dbf <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
  800dc2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800dd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800dd7:	73 50                	jae    800e29 <memmove+0x6a>
  800dd9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ddc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ddf:	01 d0                	add    %edx,%eax
  800de1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800de4:	76 43                	jbe    800e29 <memmove+0x6a>
		s += n;
  800de6:	8b 45 10             	mov    0x10(%ebp),%eax
  800de9:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800dec:	8b 45 10             	mov    0x10(%ebp),%eax
  800def:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800df2:	eb 10                	jmp    800e04 <memmove+0x45>
			*--d = *--s;
  800df4:	ff 4d f8             	decl   -0x8(%ebp)
  800df7:	ff 4d fc             	decl   -0x4(%ebp)
  800dfa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dfd:	8a 10                	mov    (%eax),%dl
  800dff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e02:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e04:	8b 45 10             	mov    0x10(%ebp),%eax
  800e07:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e0a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e0d:	85 c0                	test   %eax,%eax
  800e0f:	75 e3                	jne    800df4 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e11:	eb 23                	jmp    800e36 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e13:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e16:	8d 50 01             	lea    0x1(%eax),%edx
  800e19:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e1c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e1f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e22:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e25:	8a 12                	mov    (%edx),%dl
  800e27:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e29:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e2f:	89 55 10             	mov    %edx,0x10(%ebp)
  800e32:	85 c0                	test   %eax,%eax
  800e34:	75 dd                	jne    800e13 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e36:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e39:	c9                   	leave  
  800e3a:	c3                   	ret    

00800e3b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e3b:	55                   	push   %ebp
  800e3c:	89 e5                	mov    %esp,%ebp
  800e3e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e4d:	eb 2a                	jmp    800e79 <memcmp+0x3e>
		if (*s1 != *s2)
  800e4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e52:	8a 10                	mov    (%eax),%dl
  800e54:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e57:	8a 00                	mov    (%eax),%al
  800e59:	38 c2                	cmp    %al,%dl
  800e5b:	74 16                	je     800e73 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e60:	8a 00                	mov    (%eax),%al
  800e62:	0f b6 d0             	movzbl %al,%edx
  800e65:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e68:	8a 00                	mov    (%eax),%al
  800e6a:	0f b6 c0             	movzbl %al,%eax
  800e6d:	29 c2                	sub    %eax,%edx
  800e6f:	89 d0                	mov    %edx,%eax
  800e71:	eb 18                	jmp    800e8b <memcmp+0x50>
		s1++, s2++;
  800e73:	ff 45 fc             	incl   -0x4(%ebp)
  800e76:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e79:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e7f:	89 55 10             	mov    %edx,0x10(%ebp)
  800e82:	85 c0                	test   %eax,%eax
  800e84:	75 c9                	jne    800e4f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e8b:	c9                   	leave  
  800e8c:	c3                   	ret    

00800e8d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e93:	8b 55 08             	mov    0x8(%ebp),%edx
  800e96:	8b 45 10             	mov    0x10(%ebp),%eax
  800e99:	01 d0                	add    %edx,%eax
  800e9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e9e:	eb 15                	jmp    800eb5 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea3:	8a 00                	mov    (%eax),%al
  800ea5:	0f b6 d0             	movzbl %al,%edx
  800ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eab:	0f b6 c0             	movzbl %al,%eax
  800eae:	39 c2                	cmp    %eax,%edx
  800eb0:	74 0d                	je     800ebf <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800eb2:	ff 45 08             	incl   0x8(%ebp)
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ebb:	72 e3                	jb     800ea0 <memfind+0x13>
  800ebd:	eb 01                	jmp    800ec0 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ebf:	90                   	nop
	return (void *) s;
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec3:	c9                   	leave  
  800ec4:	c3                   	ret    

00800ec5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ec5:	55                   	push   %ebp
  800ec6:	89 e5                	mov    %esp,%ebp
  800ec8:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ecb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ed2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ed9:	eb 03                	jmp    800ede <strtol+0x19>
		s++;
  800edb:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	8a 00                	mov    (%eax),%al
  800ee3:	3c 20                	cmp    $0x20,%al
  800ee5:	74 f4                	je     800edb <strtol+0x16>
  800ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eea:	8a 00                	mov    (%eax),%al
  800eec:	3c 09                	cmp    $0x9,%al
  800eee:	74 eb                	je     800edb <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	8a 00                	mov    (%eax),%al
  800ef5:	3c 2b                	cmp    $0x2b,%al
  800ef7:	75 05                	jne    800efe <strtol+0x39>
		s++;
  800ef9:	ff 45 08             	incl   0x8(%ebp)
  800efc:	eb 13                	jmp    800f11 <strtol+0x4c>
	else if (*s == '-')
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	8a 00                	mov    (%eax),%al
  800f03:	3c 2d                	cmp    $0x2d,%al
  800f05:	75 0a                	jne    800f11 <strtol+0x4c>
		s++, neg = 1;
  800f07:	ff 45 08             	incl   0x8(%ebp)
  800f0a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f15:	74 06                	je     800f1d <strtol+0x58>
  800f17:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f1b:	75 20                	jne    800f3d <strtol+0x78>
  800f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f20:	8a 00                	mov    (%eax),%al
  800f22:	3c 30                	cmp    $0x30,%al
  800f24:	75 17                	jne    800f3d <strtol+0x78>
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	40                   	inc    %eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	3c 78                	cmp    $0x78,%al
  800f2e:	75 0d                	jne    800f3d <strtol+0x78>
		s += 2, base = 16;
  800f30:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f34:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f3b:	eb 28                	jmp    800f65 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f3d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f41:	75 15                	jne    800f58 <strtol+0x93>
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	3c 30                	cmp    $0x30,%al
  800f4a:	75 0c                	jne    800f58 <strtol+0x93>
		s++, base = 8;
  800f4c:	ff 45 08             	incl   0x8(%ebp)
  800f4f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f56:	eb 0d                	jmp    800f65 <strtol+0xa0>
	else if (base == 0)
  800f58:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f5c:	75 07                	jne    800f65 <strtol+0xa0>
		base = 10;
  800f5e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	8a 00                	mov    (%eax),%al
  800f6a:	3c 2f                	cmp    $0x2f,%al
  800f6c:	7e 19                	jle    800f87 <strtol+0xc2>
  800f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f71:	8a 00                	mov    (%eax),%al
  800f73:	3c 39                	cmp    $0x39,%al
  800f75:	7f 10                	jg     800f87 <strtol+0xc2>
			dig = *s - '0';
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	8a 00                	mov    (%eax),%al
  800f7c:	0f be c0             	movsbl %al,%eax
  800f7f:	83 e8 30             	sub    $0x30,%eax
  800f82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f85:	eb 42                	jmp    800fc9 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	8a 00                	mov    (%eax),%al
  800f8c:	3c 60                	cmp    $0x60,%al
  800f8e:	7e 19                	jle    800fa9 <strtol+0xe4>
  800f90:	8b 45 08             	mov    0x8(%ebp),%eax
  800f93:	8a 00                	mov    (%eax),%al
  800f95:	3c 7a                	cmp    $0x7a,%al
  800f97:	7f 10                	jg     800fa9 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f99:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9c:	8a 00                	mov    (%eax),%al
  800f9e:	0f be c0             	movsbl %al,%eax
  800fa1:	83 e8 57             	sub    $0x57,%eax
  800fa4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fa7:	eb 20                	jmp    800fc9 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	8a 00                	mov    (%eax),%al
  800fae:	3c 40                	cmp    $0x40,%al
  800fb0:	7e 39                	jle    800feb <strtol+0x126>
  800fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb5:	8a 00                	mov    (%eax),%al
  800fb7:	3c 5a                	cmp    $0x5a,%al
  800fb9:	7f 30                	jg     800feb <strtol+0x126>
			dig = *s - 'A' + 10;
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	8a 00                	mov    (%eax),%al
  800fc0:	0f be c0             	movsbl %al,%eax
  800fc3:	83 e8 37             	sub    $0x37,%eax
  800fc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800fc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fcc:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fcf:	7d 19                	jge    800fea <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800fd1:	ff 45 08             	incl   0x8(%ebp)
  800fd4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd7:	0f af 45 10          	imul   0x10(%ebp),%eax
  800fdb:	89 c2                	mov    %eax,%edx
  800fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe0:	01 d0                	add    %edx,%eax
  800fe2:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800fe5:	e9 7b ff ff ff       	jmp    800f65 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800fea:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800feb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fef:	74 08                	je     800ff9 <strtol+0x134>
		*endptr = (char *) s;
  800ff1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff7:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800ff9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800ffd:	74 07                	je     801006 <strtol+0x141>
  800fff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801002:	f7 d8                	neg    %eax
  801004:	eb 03                	jmp    801009 <strtol+0x144>
  801006:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801009:	c9                   	leave  
  80100a:	c3                   	ret    

0080100b <ltostr>:

void
ltostr(long value, char *str)
{
  80100b:	55                   	push   %ebp
  80100c:	89 e5                	mov    %esp,%ebp
  80100e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801011:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801018:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80101f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801023:	79 13                	jns    801038 <ltostr+0x2d>
	{
		neg = 1;
  801025:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80102c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801032:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801035:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801040:	99                   	cltd   
  801041:	f7 f9                	idiv   %ecx
  801043:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801046:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801049:	8d 50 01             	lea    0x1(%eax),%edx
  80104c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80104f:	89 c2                	mov    %eax,%edx
  801051:	8b 45 0c             	mov    0xc(%ebp),%eax
  801054:	01 d0                	add    %edx,%eax
  801056:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801059:	83 c2 30             	add    $0x30,%edx
  80105c:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80105e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801061:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801066:	f7 e9                	imul   %ecx
  801068:	c1 fa 02             	sar    $0x2,%edx
  80106b:	89 c8                	mov    %ecx,%eax
  80106d:	c1 f8 1f             	sar    $0x1f,%eax
  801070:	29 c2                	sub    %eax,%edx
  801072:	89 d0                	mov    %edx,%eax
  801074:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801077:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80107a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80107f:	f7 e9                	imul   %ecx
  801081:	c1 fa 02             	sar    $0x2,%edx
  801084:	89 c8                	mov    %ecx,%eax
  801086:	c1 f8 1f             	sar    $0x1f,%eax
  801089:	29 c2                	sub    %eax,%edx
  80108b:	89 d0                	mov    %edx,%eax
  80108d:	c1 e0 02             	shl    $0x2,%eax
  801090:	01 d0                	add    %edx,%eax
  801092:	01 c0                	add    %eax,%eax
  801094:	29 c1                	sub    %eax,%ecx
  801096:	89 ca                	mov    %ecx,%edx
  801098:	85 d2                	test   %edx,%edx
  80109a:	75 9c                	jne    801038 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80109c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a6:	48                   	dec    %eax
  8010a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010ae:	74 3d                	je     8010ed <ltostr+0xe2>
		start = 1 ;
  8010b0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010b7:	eb 34                	jmp    8010ed <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bf:	01 d0                	add    %edx,%eax
  8010c1:	8a 00                	mov    (%eax),%al
  8010c3:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cc:	01 c2                	add    %eax,%edx
  8010ce:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d4:	01 c8                	add    %ecx,%eax
  8010d6:	8a 00                	mov    (%eax),%al
  8010d8:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e0:	01 c2                	add    %eax,%edx
  8010e2:	8a 45 eb             	mov    -0x15(%ebp),%al
  8010e5:	88 02                	mov    %al,(%edx)
		start++ ;
  8010e7:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8010ea:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8010ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010f0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010f3:	7c c4                	jl     8010b9 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8010f5:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8010f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fb:	01 d0                	add    %edx,%eax
  8010fd:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801100:	90                   	nop
  801101:	c9                   	leave  
  801102:	c3                   	ret    

00801103 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
  801106:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801109:	ff 75 08             	pushl  0x8(%ebp)
  80110c:	e8 54 fa ff ff       	call   800b65 <strlen>
  801111:	83 c4 04             	add    $0x4,%esp
  801114:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801117:	ff 75 0c             	pushl  0xc(%ebp)
  80111a:	e8 46 fa ff ff       	call   800b65 <strlen>
  80111f:	83 c4 04             	add    $0x4,%esp
  801122:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801125:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80112c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801133:	eb 17                	jmp    80114c <strcconcat+0x49>
		final[s] = str1[s] ;
  801135:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801138:	8b 45 10             	mov    0x10(%ebp),%eax
  80113b:	01 c2                	add    %eax,%edx
  80113d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801140:	8b 45 08             	mov    0x8(%ebp),%eax
  801143:	01 c8                	add    %ecx,%eax
  801145:	8a 00                	mov    (%eax),%al
  801147:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801149:	ff 45 fc             	incl   -0x4(%ebp)
  80114c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80114f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801152:	7c e1                	jl     801135 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801154:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80115b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801162:	eb 1f                	jmp    801183 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801164:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801167:	8d 50 01             	lea    0x1(%eax),%edx
  80116a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80116d:	89 c2                	mov    %eax,%edx
  80116f:	8b 45 10             	mov    0x10(%ebp),%eax
  801172:	01 c2                	add    %eax,%edx
  801174:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801177:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117a:	01 c8                	add    %ecx,%eax
  80117c:	8a 00                	mov    (%eax),%al
  80117e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801180:	ff 45 f8             	incl   -0x8(%ebp)
  801183:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801186:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801189:	7c d9                	jl     801164 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80118b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80118e:	8b 45 10             	mov    0x10(%ebp),%eax
  801191:	01 d0                	add    %edx,%eax
  801193:	c6 00 00             	movb   $0x0,(%eax)
}
  801196:	90                   	nop
  801197:	c9                   	leave  
  801198:	c3                   	ret    

00801199 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801199:	55                   	push   %ebp
  80119a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80119c:	8b 45 14             	mov    0x14(%ebp),%eax
  80119f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8011a8:	8b 00                	mov    (%eax),%eax
  8011aa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b4:	01 d0                	add    %edx,%eax
  8011b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011bc:	eb 0c                	jmp    8011ca <strsplit+0x31>
			*string++ = 0;
  8011be:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c1:	8d 50 01             	lea    0x1(%eax),%edx
  8011c4:	89 55 08             	mov    %edx,0x8(%ebp)
  8011c7:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cd:	8a 00                	mov    (%eax),%al
  8011cf:	84 c0                	test   %al,%al
  8011d1:	74 18                	je     8011eb <strsplit+0x52>
  8011d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d6:	8a 00                	mov    (%eax),%al
  8011d8:	0f be c0             	movsbl %al,%eax
  8011db:	50                   	push   %eax
  8011dc:	ff 75 0c             	pushl  0xc(%ebp)
  8011df:	e8 13 fb ff ff       	call   800cf7 <strchr>
  8011e4:	83 c4 08             	add    $0x8,%esp
  8011e7:	85 c0                	test   %eax,%eax
  8011e9:	75 d3                	jne    8011be <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8011eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ee:	8a 00                	mov    (%eax),%al
  8011f0:	84 c0                	test   %al,%al
  8011f2:	74 5a                	je     80124e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8011f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f7:	8b 00                	mov    (%eax),%eax
  8011f9:	83 f8 0f             	cmp    $0xf,%eax
  8011fc:	75 07                	jne    801205 <strsplit+0x6c>
		{
			return 0;
  8011fe:	b8 00 00 00 00       	mov    $0x0,%eax
  801203:	eb 66                	jmp    80126b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801205:	8b 45 14             	mov    0x14(%ebp),%eax
  801208:	8b 00                	mov    (%eax),%eax
  80120a:	8d 48 01             	lea    0x1(%eax),%ecx
  80120d:	8b 55 14             	mov    0x14(%ebp),%edx
  801210:	89 0a                	mov    %ecx,(%edx)
  801212:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801219:	8b 45 10             	mov    0x10(%ebp),%eax
  80121c:	01 c2                	add    %eax,%edx
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801223:	eb 03                	jmp    801228 <strsplit+0x8f>
			string++;
  801225:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801228:	8b 45 08             	mov    0x8(%ebp),%eax
  80122b:	8a 00                	mov    (%eax),%al
  80122d:	84 c0                	test   %al,%al
  80122f:	74 8b                	je     8011bc <strsplit+0x23>
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	8a 00                	mov    (%eax),%al
  801236:	0f be c0             	movsbl %al,%eax
  801239:	50                   	push   %eax
  80123a:	ff 75 0c             	pushl  0xc(%ebp)
  80123d:	e8 b5 fa ff ff       	call   800cf7 <strchr>
  801242:	83 c4 08             	add    $0x8,%esp
  801245:	85 c0                	test   %eax,%eax
  801247:	74 dc                	je     801225 <strsplit+0x8c>
			string++;
	}
  801249:	e9 6e ff ff ff       	jmp    8011bc <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80124e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80124f:	8b 45 14             	mov    0x14(%ebp),%eax
  801252:	8b 00                	mov    (%eax),%eax
  801254:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80125b:	8b 45 10             	mov    0x10(%ebp),%eax
  80125e:	01 d0                	add    %edx,%eax
  801260:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801266:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80126b:	c9                   	leave  
  80126c:	c3                   	ret    

0080126d <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  80126d:	55                   	push   %ebp
  80126e:	89 e5                	mov    %esp,%ebp
  801270:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  801273:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80127a:	eb 4c                	jmp    8012c8 <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  80127c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80127f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801282:	01 d0                	add    %edx,%eax
  801284:	8a 00                	mov    (%eax),%al
  801286:	3c 40                	cmp    $0x40,%al
  801288:	7e 27                	jle    8012b1 <str2lower+0x44>
  80128a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80128d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801290:	01 d0                	add    %edx,%eax
  801292:	8a 00                	mov    (%eax),%al
  801294:	3c 5a                	cmp    $0x5a,%al
  801296:	7f 19                	jg     8012b1 <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  801298:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80129b:	8b 45 08             	mov    0x8(%ebp),%eax
  80129e:	01 d0                	add    %edx,%eax
  8012a0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a6:	01 ca                	add    %ecx,%edx
  8012a8:	8a 12                	mov    (%edx),%dl
  8012aa:	83 c2 20             	add    $0x20,%edx
  8012ad:	88 10                	mov    %dl,(%eax)
  8012af:	eb 14                	jmp    8012c5 <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  8012b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	01 c2                	add    %eax,%edx
  8012b9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bf:	01 c8                	add    %ecx,%eax
  8012c1:	8a 00                	mov    (%eax),%al
  8012c3:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  8012c5:	ff 45 fc             	incl   -0x4(%ebp)
  8012c8:	ff 75 0c             	pushl  0xc(%ebp)
  8012cb:	e8 95 f8 ff ff       	call   800b65 <strlen>
  8012d0:	83 c4 04             	add    $0x4,%esp
  8012d3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8012d6:	7f a4                	jg     80127c <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return dst;
  8012d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012db:	c9                   	leave  
  8012dc:	c3                   	ret    

008012dd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8012dd:	55                   	push   %ebp
  8012de:	89 e5                	mov    %esp,%ebp
  8012e0:	57                   	push   %edi
  8012e1:	56                   	push   %esi
  8012e2:	53                   	push   %ebx
  8012e3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012ef:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012f2:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012f5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012f8:	cd 30                	int    $0x30
  8012fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8012fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801300:	83 c4 10             	add    $0x10,%esp
  801303:	5b                   	pop    %ebx
  801304:	5e                   	pop    %esi
  801305:	5f                   	pop    %edi
  801306:	5d                   	pop    %ebp
  801307:	c3                   	ret    

00801308 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801308:	55                   	push   %ebp
  801309:	89 e5                	mov    %esp,%ebp
  80130b:	83 ec 04             	sub    $0x4,%esp
  80130e:	8b 45 10             	mov    0x10(%ebp),%eax
  801311:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801314:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801318:	8b 45 08             	mov    0x8(%ebp),%eax
  80131b:	6a 00                	push   $0x0
  80131d:	6a 00                	push   $0x0
  80131f:	52                   	push   %edx
  801320:	ff 75 0c             	pushl  0xc(%ebp)
  801323:	50                   	push   %eax
  801324:	6a 00                	push   $0x0
  801326:	e8 b2 ff ff ff       	call   8012dd <syscall>
  80132b:	83 c4 18             	add    $0x18,%esp
}
  80132e:	90                   	nop
  80132f:	c9                   	leave  
  801330:	c3                   	ret    

00801331 <sys_cgetc>:

int
sys_cgetc(void)
{
  801331:	55                   	push   %ebp
  801332:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801334:	6a 00                	push   $0x0
  801336:	6a 00                	push   $0x0
  801338:	6a 00                	push   $0x0
  80133a:	6a 00                	push   $0x0
  80133c:	6a 00                	push   $0x0
  80133e:	6a 01                	push   $0x1
  801340:	e8 98 ff ff ff       	call   8012dd <syscall>
  801345:	83 c4 18             	add    $0x18,%esp
}
  801348:	c9                   	leave  
  801349:	c3                   	ret    

0080134a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80134d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
  801353:	6a 00                	push   $0x0
  801355:	6a 00                	push   $0x0
  801357:	6a 00                	push   $0x0
  801359:	52                   	push   %edx
  80135a:	50                   	push   %eax
  80135b:	6a 05                	push   $0x5
  80135d:	e8 7b ff ff ff       	call   8012dd <syscall>
  801362:	83 c4 18             	add    $0x18,%esp
}
  801365:	c9                   	leave  
  801366:	c3                   	ret    

00801367 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801367:	55                   	push   %ebp
  801368:	89 e5                	mov    %esp,%ebp
  80136a:	56                   	push   %esi
  80136b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80136c:	8b 75 18             	mov    0x18(%ebp),%esi
  80136f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801372:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801375:	8b 55 0c             	mov    0xc(%ebp),%edx
  801378:	8b 45 08             	mov    0x8(%ebp),%eax
  80137b:	56                   	push   %esi
  80137c:	53                   	push   %ebx
  80137d:	51                   	push   %ecx
  80137e:	52                   	push   %edx
  80137f:	50                   	push   %eax
  801380:	6a 06                	push   $0x6
  801382:	e8 56 ff ff ff       	call   8012dd <syscall>
  801387:	83 c4 18             	add    $0x18,%esp
}
  80138a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80138d:	5b                   	pop    %ebx
  80138e:	5e                   	pop    %esi
  80138f:	5d                   	pop    %ebp
  801390:	c3                   	ret    

00801391 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801391:	55                   	push   %ebp
  801392:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801394:	8b 55 0c             	mov    0xc(%ebp),%edx
  801397:	8b 45 08             	mov    0x8(%ebp),%eax
  80139a:	6a 00                	push   $0x0
  80139c:	6a 00                	push   $0x0
  80139e:	6a 00                	push   $0x0
  8013a0:	52                   	push   %edx
  8013a1:	50                   	push   %eax
  8013a2:	6a 07                	push   $0x7
  8013a4:	e8 34 ff ff ff       	call   8012dd <syscall>
  8013a9:	83 c4 18             	add    $0x18,%esp
}
  8013ac:	c9                   	leave  
  8013ad:	c3                   	ret    

008013ae <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8013ae:	55                   	push   %ebp
  8013af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8013b1:	6a 00                	push   $0x0
  8013b3:	6a 00                	push   $0x0
  8013b5:	6a 00                	push   $0x0
  8013b7:	ff 75 0c             	pushl  0xc(%ebp)
  8013ba:	ff 75 08             	pushl  0x8(%ebp)
  8013bd:	6a 08                	push   $0x8
  8013bf:	e8 19 ff ff ff       	call   8012dd <syscall>
  8013c4:	83 c4 18             	add    $0x18,%esp
}
  8013c7:	c9                   	leave  
  8013c8:	c3                   	ret    

008013c9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8013c9:	55                   	push   %ebp
  8013ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013cc:	6a 00                	push   $0x0
  8013ce:	6a 00                	push   $0x0
  8013d0:	6a 00                	push   $0x0
  8013d2:	6a 00                	push   $0x0
  8013d4:	6a 00                	push   $0x0
  8013d6:	6a 09                	push   $0x9
  8013d8:	e8 00 ff ff ff       	call   8012dd <syscall>
  8013dd:	83 c4 18             	add    $0x18,%esp
}
  8013e0:	c9                   	leave  
  8013e1:	c3                   	ret    

008013e2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8013e2:	55                   	push   %ebp
  8013e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013e5:	6a 00                	push   $0x0
  8013e7:	6a 00                	push   $0x0
  8013e9:	6a 00                	push   $0x0
  8013eb:	6a 00                	push   $0x0
  8013ed:	6a 00                	push   $0x0
  8013ef:	6a 0a                	push   $0xa
  8013f1:	e8 e7 fe ff ff       	call   8012dd <syscall>
  8013f6:	83 c4 18             	add    $0x18,%esp
}
  8013f9:	c9                   	leave  
  8013fa:	c3                   	ret    

008013fb <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8013fb:	55                   	push   %ebp
  8013fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013fe:	6a 00                	push   $0x0
  801400:	6a 00                	push   $0x0
  801402:	6a 00                	push   $0x0
  801404:	6a 00                	push   $0x0
  801406:	6a 00                	push   $0x0
  801408:	6a 0b                	push   $0xb
  80140a:	e8 ce fe ff ff       	call   8012dd <syscall>
  80140f:	83 c4 18             	add    $0x18,%esp
}
  801412:	c9                   	leave  
  801413:	c3                   	ret    

00801414 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  801414:	55                   	push   %ebp
  801415:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801417:	6a 00                	push   $0x0
  801419:	6a 00                	push   $0x0
  80141b:	6a 00                	push   $0x0
  80141d:	6a 00                	push   $0x0
  80141f:	6a 00                	push   $0x0
  801421:	6a 0c                	push   $0xc
  801423:	e8 b5 fe ff ff       	call   8012dd <syscall>
  801428:	83 c4 18             	add    $0x18,%esp
}
  80142b:	c9                   	leave  
  80142c:	c3                   	ret    

0080142d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80142d:	55                   	push   %ebp
  80142e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801430:	6a 00                	push   $0x0
  801432:	6a 00                	push   $0x0
  801434:	6a 00                	push   $0x0
  801436:	6a 00                	push   $0x0
  801438:	ff 75 08             	pushl  0x8(%ebp)
  80143b:	6a 0d                	push   $0xd
  80143d:	e8 9b fe ff ff       	call   8012dd <syscall>
  801442:	83 c4 18             	add    $0x18,%esp
}
  801445:	c9                   	leave  
  801446:	c3                   	ret    

00801447 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80144a:	6a 00                	push   $0x0
  80144c:	6a 00                	push   $0x0
  80144e:	6a 00                	push   $0x0
  801450:	6a 00                	push   $0x0
  801452:	6a 00                	push   $0x0
  801454:	6a 0e                	push   $0xe
  801456:	e8 82 fe ff ff       	call   8012dd <syscall>
  80145b:	83 c4 18             	add    $0x18,%esp
}
  80145e:	90                   	nop
  80145f:	c9                   	leave  
  801460:	c3                   	ret    

00801461 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801461:	55                   	push   %ebp
  801462:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801464:	6a 00                	push   $0x0
  801466:	6a 00                	push   $0x0
  801468:	6a 00                	push   $0x0
  80146a:	6a 00                	push   $0x0
  80146c:	6a 00                	push   $0x0
  80146e:	6a 11                	push   $0x11
  801470:	e8 68 fe ff ff       	call   8012dd <syscall>
  801475:	83 c4 18             	add    $0x18,%esp
}
  801478:	90                   	nop
  801479:	c9                   	leave  
  80147a:	c3                   	ret    

0080147b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80147b:	55                   	push   %ebp
  80147c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80147e:	6a 00                	push   $0x0
  801480:	6a 00                	push   $0x0
  801482:	6a 00                	push   $0x0
  801484:	6a 00                	push   $0x0
  801486:	6a 00                	push   $0x0
  801488:	6a 12                	push   $0x12
  80148a:	e8 4e fe ff ff       	call   8012dd <syscall>
  80148f:	83 c4 18             	add    $0x18,%esp
}
  801492:	90                   	nop
  801493:	c9                   	leave  
  801494:	c3                   	ret    

00801495 <sys_cputc>:


void
sys_cputc(const char c)
{
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
  801498:	83 ec 04             	sub    $0x4,%esp
  80149b:	8b 45 08             	mov    0x8(%ebp),%eax
  80149e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8014a1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014a5:	6a 00                	push   $0x0
  8014a7:	6a 00                	push   $0x0
  8014a9:	6a 00                	push   $0x0
  8014ab:	6a 00                	push   $0x0
  8014ad:	50                   	push   %eax
  8014ae:	6a 13                	push   $0x13
  8014b0:	e8 28 fe ff ff       	call   8012dd <syscall>
  8014b5:	83 c4 18             	add    $0x18,%esp
}
  8014b8:	90                   	nop
  8014b9:	c9                   	leave  
  8014ba:	c3                   	ret    

008014bb <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8014be:	6a 00                	push   $0x0
  8014c0:	6a 00                	push   $0x0
  8014c2:	6a 00                	push   $0x0
  8014c4:	6a 00                	push   $0x0
  8014c6:	6a 00                	push   $0x0
  8014c8:	6a 14                	push   $0x14
  8014ca:	e8 0e fe ff ff       	call   8012dd <syscall>
  8014cf:	83 c4 18             	add    $0x18,%esp
}
  8014d2:	90                   	nop
  8014d3:	c9                   	leave  
  8014d4:	c3                   	ret    

008014d5 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8014d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014db:	6a 00                	push   $0x0
  8014dd:	6a 00                	push   $0x0
  8014df:	6a 00                	push   $0x0
  8014e1:	ff 75 0c             	pushl  0xc(%ebp)
  8014e4:	50                   	push   %eax
  8014e5:	6a 15                	push   $0x15
  8014e7:	e8 f1 fd ff ff       	call   8012dd <syscall>
  8014ec:	83 c4 18             	add    $0x18,%esp
}
  8014ef:	c9                   	leave  
  8014f0:	c3                   	ret    

008014f1 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8014f1:	55                   	push   %ebp
  8014f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 00                	push   $0x0
  801500:	52                   	push   %edx
  801501:	50                   	push   %eax
  801502:	6a 18                	push   $0x18
  801504:	e8 d4 fd ff ff       	call   8012dd <syscall>
  801509:	83 c4 18             	add    $0x18,%esp
}
  80150c:	c9                   	leave  
  80150d:	c3                   	ret    

0080150e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80150e:	55                   	push   %ebp
  80150f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801511:	8b 55 0c             	mov    0xc(%ebp),%edx
  801514:	8b 45 08             	mov    0x8(%ebp),%eax
  801517:	6a 00                	push   $0x0
  801519:	6a 00                	push   $0x0
  80151b:	6a 00                	push   $0x0
  80151d:	52                   	push   %edx
  80151e:	50                   	push   %eax
  80151f:	6a 16                	push   $0x16
  801521:	e8 b7 fd ff ff       	call   8012dd <syscall>
  801526:	83 c4 18             	add    $0x18,%esp
}
  801529:	90                   	nop
  80152a:	c9                   	leave  
  80152b:	c3                   	ret    

0080152c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80152c:	55                   	push   %ebp
  80152d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80152f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801532:	8b 45 08             	mov    0x8(%ebp),%eax
  801535:	6a 00                	push   $0x0
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	52                   	push   %edx
  80153c:	50                   	push   %eax
  80153d:	6a 17                	push   $0x17
  80153f:	e8 99 fd ff ff       	call   8012dd <syscall>
  801544:	83 c4 18             	add    $0x18,%esp
}
  801547:	90                   	nop
  801548:	c9                   	leave  
  801549:	c3                   	ret    

0080154a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80154a:	55                   	push   %ebp
  80154b:	89 e5                	mov    %esp,%ebp
  80154d:	83 ec 04             	sub    $0x4,%esp
  801550:	8b 45 10             	mov    0x10(%ebp),%eax
  801553:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801556:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801559:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	6a 00                	push   $0x0
  801562:	51                   	push   %ecx
  801563:	52                   	push   %edx
  801564:	ff 75 0c             	pushl  0xc(%ebp)
  801567:	50                   	push   %eax
  801568:	6a 19                	push   $0x19
  80156a:	e8 6e fd ff ff       	call   8012dd <syscall>
  80156f:	83 c4 18             	add    $0x18,%esp
}
  801572:	c9                   	leave  
  801573:	c3                   	ret    

00801574 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801577:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157a:	8b 45 08             	mov    0x8(%ebp),%eax
  80157d:	6a 00                	push   $0x0
  80157f:	6a 00                	push   $0x0
  801581:	6a 00                	push   $0x0
  801583:	52                   	push   %edx
  801584:	50                   	push   %eax
  801585:	6a 1a                	push   $0x1a
  801587:	e8 51 fd ff ff       	call   8012dd <syscall>
  80158c:	83 c4 18             	add    $0x18,%esp
}
  80158f:	c9                   	leave  
  801590:	c3                   	ret    

00801591 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801591:	55                   	push   %ebp
  801592:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801594:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801597:	8b 55 0c             	mov    0xc(%ebp),%edx
  80159a:	8b 45 08             	mov    0x8(%ebp),%eax
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	51                   	push   %ecx
  8015a2:	52                   	push   %edx
  8015a3:	50                   	push   %eax
  8015a4:	6a 1b                	push   $0x1b
  8015a6:	e8 32 fd ff ff       	call   8012dd <syscall>
  8015ab:	83 c4 18             	add    $0x18,%esp
}
  8015ae:	c9                   	leave  
  8015af:	c3                   	ret    

008015b0 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8015b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 00                	push   $0x0
  8015bf:	52                   	push   %edx
  8015c0:	50                   	push   %eax
  8015c1:	6a 1c                	push   $0x1c
  8015c3:	e8 15 fd ff ff       	call   8012dd <syscall>
  8015c8:	83 c4 18             	add    $0x18,%esp
}
  8015cb:	c9                   	leave  
  8015cc:	c3                   	ret    

008015cd <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8015cd:	55                   	push   %ebp
  8015ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 1d                	push   $0x1d
  8015dc:	e8 fc fc ff ff       	call   8012dd <syscall>
  8015e1:	83 c4 18             	add    $0x18,%esp
}
  8015e4:	c9                   	leave  
  8015e5:	c3                   	ret    

008015e6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8015e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ec:	6a 00                	push   $0x0
  8015ee:	ff 75 14             	pushl  0x14(%ebp)
  8015f1:	ff 75 10             	pushl  0x10(%ebp)
  8015f4:	ff 75 0c             	pushl  0xc(%ebp)
  8015f7:	50                   	push   %eax
  8015f8:	6a 1e                	push   $0x1e
  8015fa:	e8 de fc ff ff       	call   8012dd <syscall>
  8015ff:	83 c4 18             	add    $0x18,%esp
}
  801602:	c9                   	leave  
  801603:	c3                   	ret    

00801604 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801604:	55                   	push   %ebp
  801605:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801607:	8b 45 08             	mov    0x8(%ebp),%eax
  80160a:	6a 00                	push   $0x0
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	50                   	push   %eax
  801613:	6a 1f                	push   $0x1f
  801615:	e8 c3 fc ff ff       	call   8012dd <syscall>
  80161a:	83 c4 18             	add    $0x18,%esp
}
  80161d:	90                   	nop
  80161e:	c9                   	leave  
  80161f:	c3                   	ret    

00801620 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	6a 00                	push   $0x0
  80162c:	6a 00                	push   $0x0
  80162e:	50                   	push   %eax
  80162f:	6a 20                	push   $0x20
  801631:	e8 a7 fc ff ff       	call   8012dd <syscall>
  801636:	83 c4 18             	add    $0x18,%esp
}
  801639:	c9                   	leave  
  80163a:	c3                   	ret    

0080163b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80163b:	55                   	push   %ebp
  80163c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	6a 02                	push   $0x2
  80164a:	e8 8e fc ff ff       	call   8012dd <syscall>
  80164f:	83 c4 18             	add    $0x18,%esp
}
  801652:	c9                   	leave  
  801653:	c3                   	ret    

00801654 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801654:	55                   	push   %ebp
  801655:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	6a 00                	push   $0x0
  801661:	6a 03                	push   $0x3
  801663:	e8 75 fc ff ff       	call   8012dd <syscall>
  801668:	83 c4 18             	add    $0x18,%esp
}
  80166b:	c9                   	leave  
  80166c:	c3                   	ret    

0080166d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	6a 00                	push   $0x0
  80167a:	6a 04                	push   $0x4
  80167c:	e8 5c fc ff ff       	call   8012dd <syscall>
  801681:	83 c4 18             	add    $0x18,%esp
}
  801684:	c9                   	leave  
  801685:	c3                   	ret    

00801686 <sys_exit_env>:


void sys_exit_env(void)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801689:	6a 00                	push   $0x0
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	6a 00                	push   $0x0
  801693:	6a 21                	push   $0x21
  801695:	e8 43 fc ff ff       	call   8012dd <syscall>
  80169a:	83 c4 18             	add    $0x18,%esp
}
  80169d:	90                   	nop
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
  8016a3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8016a6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016a9:	8d 50 04             	lea    0x4(%eax),%edx
  8016ac:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	52                   	push   %edx
  8016b6:	50                   	push   %eax
  8016b7:	6a 22                	push   $0x22
  8016b9:	e8 1f fc ff ff       	call   8012dd <syscall>
  8016be:	83 c4 18             	add    $0x18,%esp
	return result;
  8016c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016ca:	89 01                	mov    %eax,(%ecx)
  8016cc:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8016cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d2:	c9                   	leave  
  8016d3:	c2 04 00             	ret    $0x4

008016d6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	ff 75 10             	pushl  0x10(%ebp)
  8016e0:	ff 75 0c             	pushl  0xc(%ebp)
  8016e3:	ff 75 08             	pushl  0x8(%ebp)
  8016e6:	6a 10                	push   $0x10
  8016e8:	e8 f0 fb ff ff       	call   8012dd <syscall>
  8016ed:	83 c4 18             	add    $0x18,%esp
	return ;
  8016f0:	90                   	nop
}
  8016f1:	c9                   	leave  
  8016f2:	c3                   	ret    

008016f3 <sys_rcr2>:
uint32 sys_rcr2()
{
  8016f3:	55                   	push   %ebp
  8016f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 23                	push   $0x23
  801702:	e8 d6 fb ff ff       	call   8012dd <syscall>
  801707:	83 c4 18             	add    $0x18,%esp
}
  80170a:	c9                   	leave  
  80170b:	c3                   	ret    

0080170c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
  80170f:	83 ec 04             	sub    $0x4,%esp
  801712:	8b 45 08             	mov    0x8(%ebp),%eax
  801715:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801718:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	50                   	push   %eax
  801725:	6a 24                	push   $0x24
  801727:	e8 b1 fb ff ff       	call   8012dd <syscall>
  80172c:	83 c4 18             	add    $0x18,%esp
	return ;
  80172f:	90                   	nop
}
  801730:	c9                   	leave  
  801731:	c3                   	ret    

00801732 <rsttst>:
void rsttst()
{
  801732:	55                   	push   %ebp
  801733:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 26                	push   $0x26
  801741:	e8 97 fb ff ff       	call   8012dd <syscall>
  801746:	83 c4 18             	add    $0x18,%esp
	return ;
  801749:	90                   	nop
}
  80174a:	c9                   	leave  
  80174b:	c3                   	ret    

0080174c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
  80174f:	83 ec 04             	sub    $0x4,%esp
  801752:	8b 45 14             	mov    0x14(%ebp),%eax
  801755:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801758:	8b 55 18             	mov    0x18(%ebp),%edx
  80175b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80175f:	52                   	push   %edx
  801760:	50                   	push   %eax
  801761:	ff 75 10             	pushl  0x10(%ebp)
  801764:	ff 75 0c             	pushl  0xc(%ebp)
  801767:	ff 75 08             	pushl  0x8(%ebp)
  80176a:	6a 25                	push   $0x25
  80176c:	e8 6c fb ff ff       	call   8012dd <syscall>
  801771:	83 c4 18             	add    $0x18,%esp
	return ;
  801774:	90                   	nop
}
  801775:	c9                   	leave  
  801776:	c3                   	ret    

00801777 <chktst>:
void chktst(uint32 n)
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	ff 75 08             	pushl  0x8(%ebp)
  801785:	6a 27                	push   $0x27
  801787:	e8 51 fb ff ff       	call   8012dd <syscall>
  80178c:	83 c4 18             	add    $0x18,%esp
	return ;
  80178f:	90                   	nop
}
  801790:	c9                   	leave  
  801791:	c3                   	ret    

00801792 <inctst>:

void inctst()
{
  801792:	55                   	push   %ebp
  801793:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 28                	push   $0x28
  8017a1:	e8 37 fb ff ff       	call   8012dd <syscall>
  8017a6:	83 c4 18             	add    $0x18,%esp
	return ;
  8017a9:	90                   	nop
}
  8017aa:	c9                   	leave  
  8017ab:	c3                   	ret    

008017ac <gettst>:
uint32 gettst()
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 29                	push   $0x29
  8017bb:	e8 1d fb ff ff       	call   8012dd <syscall>
  8017c0:	83 c4 18             	add    $0x18,%esp
}
  8017c3:	c9                   	leave  
  8017c4:	c3                   	ret    

008017c5 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
  8017c8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 2a                	push   $0x2a
  8017d7:	e8 01 fb ff ff       	call   8012dd <syscall>
  8017dc:	83 c4 18             	add    $0x18,%esp
  8017df:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8017e2:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8017e6:	75 07                	jne    8017ef <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8017e8:	b8 01 00 00 00       	mov    $0x1,%eax
  8017ed:	eb 05                	jmp    8017f4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8017ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017f4:	c9                   	leave  
  8017f5:	c3                   	ret    

008017f6 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
  8017f9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 2a                	push   $0x2a
  801808:	e8 d0 fa ff ff       	call   8012dd <syscall>
  80180d:	83 c4 18             	add    $0x18,%esp
  801810:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801813:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801817:	75 07                	jne    801820 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801819:	b8 01 00 00 00       	mov    $0x1,%eax
  80181e:	eb 05                	jmp    801825 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801820:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801825:	c9                   	leave  
  801826:	c3                   	ret    

00801827 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
  80182a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 2a                	push   $0x2a
  801839:	e8 9f fa ff ff       	call   8012dd <syscall>
  80183e:	83 c4 18             	add    $0x18,%esp
  801841:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801844:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801848:	75 07                	jne    801851 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80184a:	b8 01 00 00 00       	mov    $0x1,%eax
  80184f:	eb 05                	jmp    801856 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801851:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801856:	c9                   	leave  
  801857:	c3                   	ret    

00801858 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
  80185b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 2a                	push   $0x2a
  80186a:	e8 6e fa ff ff       	call   8012dd <syscall>
  80186f:	83 c4 18             	add    $0x18,%esp
  801872:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801875:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801879:	75 07                	jne    801882 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80187b:	b8 01 00 00 00       	mov    $0x1,%eax
  801880:	eb 05                	jmp    801887 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801882:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	ff 75 08             	pushl  0x8(%ebp)
  801897:	6a 2b                	push   $0x2b
  801899:	e8 3f fa ff ff       	call   8012dd <syscall>
  80189e:	83 c4 18             	add    $0x18,%esp
	return ;
  8018a1:	90                   	nop
}
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
  8018a7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8018a8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b4:	6a 00                	push   $0x0
  8018b6:	53                   	push   %ebx
  8018b7:	51                   	push   %ecx
  8018b8:	52                   	push   %edx
  8018b9:	50                   	push   %eax
  8018ba:	6a 2c                	push   $0x2c
  8018bc:	e8 1c fa ff ff       	call   8012dd <syscall>
  8018c1:	83 c4 18             	add    $0x18,%esp
}
  8018c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018c7:	c9                   	leave  
  8018c8:	c3                   	ret    

008018c9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8018cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	52                   	push   %edx
  8018d9:	50                   	push   %eax
  8018da:	6a 2d                	push   $0x2d
  8018dc:	e8 fc f9 ff ff       	call   8012dd <syscall>
  8018e1:	83 c4 18             	add    $0x18,%esp
}
  8018e4:	c9                   	leave  
  8018e5:	c3                   	ret    

008018e6 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8018e9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f2:	6a 00                	push   $0x0
  8018f4:	51                   	push   %ecx
  8018f5:	ff 75 10             	pushl  0x10(%ebp)
  8018f8:	52                   	push   %edx
  8018f9:	50                   	push   %eax
  8018fa:	6a 2e                	push   $0x2e
  8018fc:	e8 dc f9 ff ff       	call   8012dd <syscall>
  801901:	83 c4 18             	add    $0x18,%esp
}
  801904:	c9                   	leave  
  801905:	c3                   	ret    

00801906 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	ff 75 10             	pushl  0x10(%ebp)
  801910:	ff 75 0c             	pushl  0xc(%ebp)
  801913:	ff 75 08             	pushl  0x8(%ebp)
  801916:	6a 0f                	push   $0xf
  801918:	e8 c0 f9 ff ff       	call   8012dd <syscall>
  80191d:	83 c4 18             	add    $0x18,%esp
	return ;
  801920:	90                   	nop
}
  801921:	c9                   	leave  
  801922:	c3                   	ret    

00801923 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	50                   	push   %eax
  801932:	6a 2f                	push   $0x2f
  801934:	e8 a4 f9 ff ff       	call   8012dd <syscall>
  801939:	83 c4 18             	add    $0x18,%esp

}
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    

0080193e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	ff 75 0c             	pushl  0xc(%ebp)
  80194a:	ff 75 08             	pushl  0x8(%ebp)
  80194d:	6a 30                	push   $0x30
  80194f:	e8 89 f9 ff ff       	call   8012dd <syscall>
  801954:	83 c4 18             	add    $0x18,%esp
	return;
  801957:	90                   	nop
}
  801958:	c9                   	leave  
  801959:	c3                   	ret    

0080195a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	ff 75 0c             	pushl  0xc(%ebp)
  801966:	ff 75 08             	pushl  0x8(%ebp)
  801969:	6a 31                	push   $0x31
  80196b:	e8 6d f9 ff ff       	call   8012dd <syscall>
  801970:	83 c4 18             	add    $0x18,%esp
	return;
  801973:	90                   	nop
}
  801974:	c9                   	leave  
  801975:	c3                   	ret    

00801976 <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 32                	push   $0x32
  801985:	e8 53 f9 ff ff       	call   8012dd <syscall>
  80198a:	83 c4 18             	add    $0x18,%esp
}
  80198d:	c9                   	leave  
  80198e:	c3                   	ret    

0080198f <sys_env_set_nice>:

void sys_env_set_nice(int nice){
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  801992:	8b 45 08             	mov    0x8(%ebp),%eax
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	50                   	push   %eax
  80199e:	6a 33                	push   $0x33
  8019a0:	e8 38 f9 ff ff       	call   8012dd <syscall>
  8019a5:	83 c4 18             	add    $0x18,%esp
}
  8019a8:	90                   	nop
  8019a9:	c9                   	leave  
  8019aa:	c3                   	ret    

008019ab <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8019ab:	55                   	push   %ebp
  8019ac:	89 e5                	mov    %esp,%ebp
  8019ae:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8019b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8019b4:	89 d0                	mov    %edx,%eax
  8019b6:	c1 e0 02             	shl    $0x2,%eax
  8019b9:	01 d0                	add    %edx,%eax
  8019bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019c2:	01 d0                	add    %edx,%eax
  8019c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019cb:	01 d0                	add    %edx,%eax
  8019cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019d4:	01 d0                	add    %edx,%eax
  8019d6:	c1 e0 04             	shl    $0x4,%eax
  8019d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8019dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8019e3:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8019e6:	83 ec 0c             	sub    $0xc,%esp
  8019e9:	50                   	push   %eax
  8019ea:	e8 b1 fc ff ff       	call   8016a0 <sys_get_virtual_time>
  8019ef:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8019f2:	eb 41                	jmp    801a35 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8019f4:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8019f7:	83 ec 0c             	sub    $0xc,%esp
  8019fa:	50                   	push   %eax
  8019fb:	e8 a0 fc ff ff       	call   8016a0 <sys_get_virtual_time>
  801a00:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801a03:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a09:	29 c2                	sub    %eax,%edx
  801a0b:	89 d0                	mov    %edx,%eax
  801a0d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801a10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a16:	89 d1                	mov    %edx,%ecx
  801a18:	29 c1                	sub    %eax,%ecx
  801a1a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a20:	39 c2                	cmp    %eax,%edx
  801a22:	0f 97 c0             	seta   %al
  801a25:	0f b6 c0             	movzbl %al,%eax
  801a28:	29 c1                	sub    %eax,%ecx
  801a2a:	89 c8                	mov    %ecx,%eax
  801a2c:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801a2f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a32:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a38:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a3b:	72 b7                	jb     8019f4 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801a3d:	90                   	nop
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
  801a43:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801a46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801a4d:	eb 03                	jmp    801a52 <busy_wait+0x12>
  801a4f:	ff 45 fc             	incl   -0x4(%ebp)
  801a52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a55:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a58:	72 f5                	jb     801a4f <busy_wait+0xf>
	return i;
  801a5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801a5d:	c9                   	leave  
  801a5e:	c3                   	ret    

00801a5f <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
  801a62:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801a65:	8b 45 08             	mov    0x8(%ebp),%eax
  801a68:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801a6b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801a6f:	83 ec 0c             	sub    $0xc,%esp
  801a72:	50                   	push   %eax
  801a73:	e8 1d fa ff ff       	call   801495 <sys_cputc>
  801a78:	83 c4 10             	add    $0x10,%esp
}
  801a7b:	90                   	nop
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
  801a81:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801a84:	e8 d8 f9 ff ff       	call   801461 <sys_disable_interrupt>
	char c = ch;
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801a8f:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801a93:	83 ec 0c             	sub    $0xc,%esp
  801a96:	50                   	push   %eax
  801a97:	e8 f9 f9 ff ff       	call   801495 <sys_cputc>
  801a9c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  801a9f:	e8 d7 f9 ff ff       	call   80147b <sys_enable_interrupt>
}
  801aa4:	90                   	nop
  801aa5:	c9                   	leave  
  801aa6:	c3                   	ret    

00801aa7 <getchar>:

int
getchar(void)
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
  801aaa:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  801aad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  801ab4:	eb 08                	jmp    801abe <getchar+0x17>
	{
		c = sys_cgetc();
  801ab6:	e8 76 f8 ff ff       	call   801331 <sys_cgetc>
  801abb:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  801abe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ac2:	74 f2                	je     801ab6 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  801ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <atomic_getchar>:

int
atomic_getchar(void)
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
  801acc:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801acf:	e8 8d f9 ff ff       	call   801461 <sys_disable_interrupt>
	int c=0;
  801ad4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  801adb:	eb 08                	jmp    801ae5 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  801add:	e8 4f f8 ff ff       	call   801331 <sys_cgetc>
  801ae2:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  801ae5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ae9:	74 f2                	je     801add <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  801aeb:	e8 8b f9 ff ff       	call   80147b <sys_enable_interrupt>
	return c;
  801af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <iscons>:

int iscons(int fdnum)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801af8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801afd:	5d                   	pop    %ebp
  801afe:	c3                   	ret    
  801aff:	90                   	nop

00801b00 <__udivdi3>:
  801b00:	55                   	push   %ebp
  801b01:	57                   	push   %edi
  801b02:	56                   	push   %esi
  801b03:	53                   	push   %ebx
  801b04:	83 ec 1c             	sub    $0x1c,%esp
  801b07:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b0b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b0f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b13:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b17:	89 ca                	mov    %ecx,%edx
  801b19:	89 f8                	mov    %edi,%eax
  801b1b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b1f:	85 f6                	test   %esi,%esi
  801b21:	75 2d                	jne    801b50 <__udivdi3+0x50>
  801b23:	39 cf                	cmp    %ecx,%edi
  801b25:	77 65                	ja     801b8c <__udivdi3+0x8c>
  801b27:	89 fd                	mov    %edi,%ebp
  801b29:	85 ff                	test   %edi,%edi
  801b2b:	75 0b                	jne    801b38 <__udivdi3+0x38>
  801b2d:	b8 01 00 00 00       	mov    $0x1,%eax
  801b32:	31 d2                	xor    %edx,%edx
  801b34:	f7 f7                	div    %edi
  801b36:	89 c5                	mov    %eax,%ebp
  801b38:	31 d2                	xor    %edx,%edx
  801b3a:	89 c8                	mov    %ecx,%eax
  801b3c:	f7 f5                	div    %ebp
  801b3e:	89 c1                	mov    %eax,%ecx
  801b40:	89 d8                	mov    %ebx,%eax
  801b42:	f7 f5                	div    %ebp
  801b44:	89 cf                	mov    %ecx,%edi
  801b46:	89 fa                	mov    %edi,%edx
  801b48:	83 c4 1c             	add    $0x1c,%esp
  801b4b:	5b                   	pop    %ebx
  801b4c:	5e                   	pop    %esi
  801b4d:	5f                   	pop    %edi
  801b4e:	5d                   	pop    %ebp
  801b4f:	c3                   	ret    
  801b50:	39 ce                	cmp    %ecx,%esi
  801b52:	77 28                	ja     801b7c <__udivdi3+0x7c>
  801b54:	0f bd fe             	bsr    %esi,%edi
  801b57:	83 f7 1f             	xor    $0x1f,%edi
  801b5a:	75 40                	jne    801b9c <__udivdi3+0x9c>
  801b5c:	39 ce                	cmp    %ecx,%esi
  801b5e:	72 0a                	jb     801b6a <__udivdi3+0x6a>
  801b60:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b64:	0f 87 9e 00 00 00    	ja     801c08 <__udivdi3+0x108>
  801b6a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b6f:	89 fa                	mov    %edi,%edx
  801b71:	83 c4 1c             	add    $0x1c,%esp
  801b74:	5b                   	pop    %ebx
  801b75:	5e                   	pop    %esi
  801b76:	5f                   	pop    %edi
  801b77:	5d                   	pop    %ebp
  801b78:	c3                   	ret    
  801b79:	8d 76 00             	lea    0x0(%esi),%esi
  801b7c:	31 ff                	xor    %edi,%edi
  801b7e:	31 c0                	xor    %eax,%eax
  801b80:	89 fa                	mov    %edi,%edx
  801b82:	83 c4 1c             	add    $0x1c,%esp
  801b85:	5b                   	pop    %ebx
  801b86:	5e                   	pop    %esi
  801b87:	5f                   	pop    %edi
  801b88:	5d                   	pop    %ebp
  801b89:	c3                   	ret    
  801b8a:	66 90                	xchg   %ax,%ax
  801b8c:	89 d8                	mov    %ebx,%eax
  801b8e:	f7 f7                	div    %edi
  801b90:	31 ff                	xor    %edi,%edi
  801b92:	89 fa                	mov    %edi,%edx
  801b94:	83 c4 1c             	add    $0x1c,%esp
  801b97:	5b                   	pop    %ebx
  801b98:	5e                   	pop    %esi
  801b99:	5f                   	pop    %edi
  801b9a:	5d                   	pop    %ebp
  801b9b:	c3                   	ret    
  801b9c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ba1:	89 eb                	mov    %ebp,%ebx
  801ba3:	29 fb                	sub    %edi,%ebx
  801ba5:	89 f9                	mov    %edi,%ecx
  801ba7:	d3 e6                	shl    %cl,%esi
  801ba9:	89 c5                	mov    %eax,%ebp
  801bab:	88 d9                	mov    %bl,%cl
  801bad:	d3 ed                	shr    %cl,%ebp
  801baf:	89 e9                	mov    %ebp,%ecx
  801bb1:	09 f1                	or     %esi,%ecx
  801bb3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801bb7:	89 f9                	mov    %edi,%ecx
  801bb9:	d3 e0                	shl    %cl,%eax
  801bbb:	89 c5                	mov    %eax,%ebp
  801bbd:	89 d6                	mov    %edx,%esi
  801bbf:	88 d9                	mov    %bl,%cl
  801bc1:	d3 ee                	shr    %cl,%esi
  801bc3:	89 f9                	mov    %edi,%ecx
  801bc5:	d3 e2                	shl    %cl,%edx
  801bc7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bcb:	88 d9                	mov    %bl,%cl
  801bcd:	d3 e8                	shr    %cl,%eax
  801bcf:	09 c2                	or     %eax,%edx
  801bd1:	89 d0                	mov    %edx,%eax
  801bd3:	89 f2                	mov    %esi,%edx
  801bd5:	f7 74 24 0c          	divl   0xc(%esp)
  801bd9:	89 d6                	mov    %edx,%esi
  801bdb:	89 c3                	mov    %eax,%ebx
  801bdd:	f7 e5                	mul    %ebp
  801bdf:	39 d6                	cmp    %edx,%esi
  801be1:	72 19                	jb     801bfc <__udivdi3+0xfc>
  801be3:	74 0b                	je     801bf0 <__udivdi3+0xf0>
  801be5:	89 d8                	mov    %ebx,%eax
  801be7:	31 ff                	xor    %edi,%edi
  801be9:	e9 58 ff ff ff       	jmp    801b46 <__udivdi3+0x46>
  801bee:	66 90                	xchg   %ax,%ax
  801bf0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801bf4:	89 f9                	mov    %edi,%ecx
  801bf6:	d3 e2                	shl    %cl,%edx
  801bf8:	39 c2                	cmp    %eax,%edx
  801bfa:	73 e9                	jae    801be5 <__udivdi3+0xe5>
  801bfc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801bff:	31 ff                	xor    %edi,%edi
  801c01:	e9 40 ff ff ff       	jmp    801b46 <__udivdi3+0x46>
  801c06:	66 90                	xchg   %ax,%ax
  801c08:	31 c0                	xor    %eax,%eax
  801c0a:	e9 37 ff ff ff       	jmp    801b46 <__udivdi3+0x46>
  801c0f:	90                   	nop

00801c10 <__umoddi3>:
  801c10:	55                   	push   %ebp
  801c11:	57                   	push   %edi
  801c12:	56                   	push   %esi
  801c13:	53                   	push   %ebx
  801c14:	83 ec 1c             	sub    $0x1c,%esp
  801c17:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c1b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c1f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c23:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c27:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c2b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c2f:	89 f3                	mov    %esi,%ebx
  801c31:	89 fa                	mov    %edi,%edx
  801c33:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c37:	89 34 24             	mov    %esi,(%esp)
  801c3a:	85 c0                	test   %eax,%eax
  801c3c:	75 1a                	jne    801c58 <__umoddi3+0x48>
  801c3e:	39 f7                	cmp    %esi,%edi
  801c40:	0f 86 a2 00 00 00    	jbe    801ce8 <__umoddi3+0xd8>
  801c46:	89 c8                	mov    %ecx,%eax
  801c48:	89 f2                	mov    %esi,%edx
  801c4a:	f7 f7                	div    %edi
  801c4c:	89 d0                	mov    %edx,%eax
  801c4e:	31 d2                	xor    %edx,%edx
  801c50:	83 c4 1c             	add    $0x1c,%esp
  801c53:	5b                   	pop    %ebx
  801c54:	5e                   	pop    %esi
  801c55:	5f                   	pop    %edi
  801c56:	5d                   	pop    %ebp
  801c57:	c3                   	ret    
  801c58:	39 f0                	cmp    %esi,%eax
  801c5a:	0f 87 ac 00 00 00    	ja     801d0c <__umoddi3+0xfc>
  801c60:	0f bd e8             	bsr    %eax,%ebp
  801c63:	83 f5 1f             	xor    $0x1f,%ebp
  801c66:	0f 84 ac 00 00 00    	je     801d18 <__umoddi3+0x108>
  801c6c:	bf 20 00 00 00       	mov    $0x20,%edi
  801c71:	29 ef                	sub    %ebp,%edi
  801c73:	89 fe                	mov    %edi,%esi
  801c75:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c79:	89 e9                	mov    %ebp,%ecx
  801c7b:	d3 e0                	shl    %cl,%eax
  801c7d:	89 d7                	mov    %edx,%edi
  801c7f:	89 f1                	mov    %esi,%ecx
  801c81:	d3 ef                	shr    %cl,%edi
  801c83:	09 c7                	or     %eax,%edi
  801c85:	89 e9                	mov    %ebp,%ecx
  801c87:	d3 e2                	shl    %cl,%edx
  801c89:	89 14 24             	mov    %edx,(%esp)
  801c8c:	89 d8                	mov    %ebx,%eax
  801c8e:	d3 e0                	shl    %cl,%eax
  801c90:	89 c2                	mov    %eax,%edx
  801c92:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c96:	d3 e0                	shl    %cl,%eax
  801c98:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c9c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ca0:	89 f1                	mov    %esi,%ecx
  801ca2:	d3 e8                	shr    %cl,%eax
  801ca4:	09 d0                	or     %edx,%eax
  801ca6:	d3 eb                	shr    %cl,%ebx
  801ca8:	89 da                	mov    %ebx,%edx
  801caa:	f7 f7                	div    %edi
  801cac:	89 d3                	mov    %edx,%ebx
  801cae:	f7 24 24             	mull   (%esp)
  801cb1:	89 c6                	mov    %eax,%esi
  801cb3:	89 d1                	mov    %edx,%ecx
  801cb5:	39 d3                	cmp    %edx,%ebx
  801cb7:	0f 82 87 00 00 00    	jb     801d44 <__umoddi3+0x134>
  801cbd:	0f 84 91 00 00 00    	je     801d54 <__umoddi3+0x144>
  801cc3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801cc7:	29 f2                	sub    %esi,%edx
  801cc9:	19 cb                	sbb    %ecx,%ebx
  801ccb:	89 d8                	mov    %ebx,%eax
  801ccd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801cd1:	d3 e0                	shl    %cl,%eax
  801cd3:	89 e9                	mov    %ebp,%ecx
  801cd5:	d3 ea                	shr    %cl,%edx
  801cd7:	09 d0                	or     %edx,%eax
  801cd9:	89 e9                	mov    %ebp,%ecx
  801cdb:	d3 eb                	shr    %cl,%ebx
  801cdd:	89 da                	mov    %ebx,%edx
  801cdf:	83 c4 1c             	add    $0x1c,%esp
  801ce2:	5b                   	pop    %ebx
  801ce3:	5e                   	pop    %esi
  801ce4:	5f                   	pop    %edi
  801ce5:	5d                   	pop    %ebp
  801ce6:	c3                   	ret    
  801ce7:	90                   	nop
  801ce8:	89 fd                	mov    %edi,%ebp
  801cea:	85 ff                	test   %edi,%edi
  801cec:	75 0b                	jne    801cf9 <__umoddi3+0xe9>
  801cee:	b8 01 00 00 00       	mov    $0x1,%eax
  801cf3:	31 d2                	xor    %edx,%edx
  801cf5:	f7 f7                	div    %edi
  801cf7:	89 c5                	mov    %eax,%ebp
  801cf9:	89 f0                	mov    %esi,%eax
  801cfb:	31 d2                	xor    %edx,%edx
  801cfd:	f7 f5                	div    %ebp
  801cff:	89 c8                	mov    %ecx,%eax
  801d01:	f7 f5                	div    %ebp
  801d03:	89 d0                	mov    %edx,%eax
  801d05:	e9 44 ff ff ff       	jmp    801c4e <__umoddi3+0x3e>
  801d0a:	66 90                	xchg   %ax,%ax
  801d0c:	89 c8                	mov    %ecx,%eax
  801d0e:	89 f2                	mov    %esi,%edx
  801d10:	83 c4 1c             	add    $0x1c,%esp
  801d13:	5b                   	pop    %ebx
  801d14:	5e                   	pop    %esi
  801d15:	5f                   	pop    %edi
  801d16:	5d                   	pop    %ebp
  801d17:	c3                   	ret    
  801d18:	3b 04 24             	cmp    (%esp),%eax
  801d1b:	72 06                	jb     801d23 <__umoddi3+0x113>
  801d1d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d21:	77 0f                	ja     801d32 <__umoddi3+0x122>
  801d23:	89 f2                	mov    %esi,%edx
  801d25:	29 f9                	sub    %edi,%ecx
  801d27:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d2b:	89 14 24             	mov    %edx,(%esp)
  801d2e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d32:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d36:	8b 14 24             	mov    (%esp),%edx
  801d39:	83 c4 1c             	add    $0x1c,%esp
  801d3c:	5b                   	pop    %ebx
  801d3d:	5e                   	pop    %esi
  801d3e:	5f                   	pop    %edi
  801d3f:	5d                   	pop    %ebp
  801d40:	c3                   	ret    
  801d41:	8d 76 00             	lea    0x0(%esi),%esi
  801d44:	2b 04 24             	sub    (%esp),%eax
  801d47:	19 fa                	sbb    %edi,%edx
  801d49:	89 d1                	mov    %edx,%ecx
  801d4b:	89 c6                	mov    %eax,%esi
  801d4d:	e9 71 ff ff ff       	jmp    801cc3 <__umoddi3+0xb3>
  801d52:	66 90                	xchg   %ax,%ax
  801d54:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d58:	72 ea                	jb     801d44 <__umoddi3+0x134>
  801d5a:	89 d9                	mov    %ebx,%ecx
  801d5c:	e9 62 ff ff ff       	jmp    801cc3 <__umoddi3+0xb3>
